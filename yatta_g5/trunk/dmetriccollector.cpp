#include "dmetriccollector.h"

inline int line16diff(uint8_t *l1, uint8_t *l2) {
    int sum = 0;
    for (int i = 0; i < 16; i += 4) {
        sum += abs(l1[i + 0] - l2[i + 0]);
        sum += abs(l1[i + 1] - l2[i + 1]);
        sum += abs(l1[i + 2] - l2[i + 2]);
        sum += abs(l1[i + 3] - l2[i + 3]);
    }
    return sum;
}

inline int line8diff(uint8_t *l1, uint8_t *l2) {
    int sum = 0;
    for (int i = 0; i < 8; i += 4) {
        sum += abs(l1[i + 0] - l2[i + 0]);
        sum += abs(l1[i + 1] - l2[i + 1]);
        sum += abs(l1[i + 2] - l2[i + 2]);
        sum += abs(l1[i + 3] - l2[i + 3]);
    }
    return sum;
}

inline int lineXdiff(uint8_t *l1, uint8_t *l2, int n) {
    int sum = 0;
    for (int i = 0; i < n; ++i) {
        sum += abs(l1[i] - l2[i]);
    }
    return sum;
}

// This function first calculates the sum of absolute differences for every 16x16 block in an image (chroma inside the area also included) and then selects the highest value from overlapping 32x32 blocks. It should perform identically to TDecimate at the default settings (nt=0, blockx/blocky=32, ssd=false, chroma=true). It also calculates the SAD for the whole image.
// fixme, this is possibly the ugliest function in the whole program and it's not even comppletely finished
// it should also be optimized at once
void TDMetricCollector::calculateSAD(const TVideoFrame *f1top, const TVideoFrame *f1bottom,
                  const TVideoFrame *f2top, const TVideoFrame *f2bottom,
                  const TVideoInfo &vi, int &dmetric, int &sad)
{
    const int blockSize = 16;
    // fixme, check the colorspace here, assume it's YV12
    int numBlocksX = (vi.width) / blockSize;
    int numBlocksY = (vi.height) / blockSize;

    // src<Previous/Current><Top/Bottom>

    uint8_t *srcpt = f1top->data[0];
    int srcptPitch = f1top->lineSize[0];
    uint8_t *srcpb = f1bottom->data[0];
    int srcpbPitch = f1bottom->lineSize[0];
    srcpb += srcpbPitch;
    srcpbPitch *= 2;
    uint8_t *srcct = f2top->data[0];
    int srcctPitch = f2top->lineSize[0];
    uint8_t *srccb = f2bottom->data[0];
    int srccbPitch = f2bottom->lineSize[0];
    srccb += srccbPitch;
    srccbPitch *= 2;

    for (int y = 0; y < numBlocksY; ++y) {
        for (int x = 0; x < numBlocksX; ++x) {
            int blockDiff = 0;
            for (int inBlockY = 0; inBlockY < 8; ++inBlockY) {
                blockDiff += line16diff(srcpt + inBlockY * srcptPitch, srcct + inBlockY * srcctPitch);
                blockDiff += line16diff(srcpb + inBlockY * srcpbPitch, srccb + inBlockY * srccbPitch);
            }
            sad += blockDiff;
            if (dmetric < blockDiff)
                dmetric = blockDiff;
        }
        srcpt += srcptPitch * 8;
        srcpb += srcpbPitch * 8;
        srcct += srcctPitch * 8;
        srccb += srccbPitch * 8;
    }
}

TDMetricCollector::TDMetricCollector(TVideoProvider *video, TDecimationHandler &owner) : fOwner(owner), cache(10)
{
    this->video = video->clone();
    currentArea = -1;
}

void TDMetricCollector::run()
{
    while (true) {
        QList<int> &unprocessed = fOwner.unprocessedAreas;
        fOwner.mutex.lock();
        if (unprocessed.contains(++currentArea)) {
            unprocessed.removeOne(currentArea);
        } else if (!unprocessed.empty()) {
            currentArea = unprocessed.takeAt((qrand() * unprocessed.count()) / RAND_MAX);
        } else {
            fOwner.mutex.unlock();
            msleep(500);
            continue;
        }
        fOwner.mutex.unlock();

        int start = fOwner.blockSize * currentArea;
        int end = start + fOwner.blockSize;
        for (int i = start; i < end; ++i) {
            if (fOwner.metrics[i].dmetric >= 0)
                continue;

            const TFrameInfo &f1 = fOwner.fMatches[i];
            const TFrameInfo &f2 = fOwner.fMatches[qMax(i - 1, 0)];

            QList<int> framesNeeded;
            framesNeeded.reserve(4);
            framesNeeded.append(f1.top);
            framesNeeded.append(f1.bottom);
            framesNeeded.append(f2.top);
            framesNeeded.append(f2.bottom);
            qSort(framesNeeded);

            // make sure the new frames always fit in the cache so they won't be deleted prematurely
            cache.setMaxCost(cache.maxCost() + 4);
            QListIterator<int> j(framesNeeded);
            while (j.hasNext())
                if (!cache.contains(j.next()))
                    cache.insert(j.peekPrevious(), video->getFrame(j.peekPrevious()));

            int dmetric = 0;
            int sad = 0;
            calculateSAD(cache[f1.top], cache[f1.bottom],
                         cache[f2.top], cache[f2.bottom],
                         video->videoInfo(), dmetric, sad);

            fOwner.metrics[i].dmetric = dmetric;
            fOwner.metrics[i].sad = sad;
            // shrink the cache again to remove the oldest frames
            cache.setMaxCost(cache.maxCost() - 4);
        }

    }

    // no more work to do for the moment, reduce the cache size?
}

void TDecimationHandler::startCollection(int threads)
{

}

int TDecimationHandler::operator [](int i)
{

}

TCanDecimateResult TDecimationHandler::canForceDecimate(int frame)
{

}

TCanDecimateResult TDecimationHandler::setForceDecimate(int frame, bool decimate)
{

}

QList<TDecimationError> TDecimationHandler::makeErrorReport(int start, int end)
{

}

TDecimationHandler::TDecimationHandler(TMatchHandler &matches, TLayers &layers) : fMatches(matches), fLayers(layers), fDecimationLayer(layers.decimationLayer())
{
    metrics.resize(matches.numFrames());
}

int TDecimationHandler::getDecimatedFrameNumber(int frame)
{
    int framesPassed = 0;
    for (int i = 0; i < fDecimationLayer.count(); ++i) {
        const TSection &t = fDecimationLayer[i];
        const TPreset *p = fLayers.presets.getPresetById(t.preset);
        int m = p->m;
        int n = p->n;
        if (frame < t.start) {
            // just add up all the frame before, no metrics are needed for these
            int length = t.end - t.start + 1;
            if (m <= n)
                framesPassed += length - ((length / n) * m); // the remainder in a section is not decimated
            else if (n == 1 && m > 1)
                framesPassed += length * m; // if n = 1 it's a framerate multiplier section
        } else {
            int length = frame - t.start;
            if (m <= n) {
                // add the frames before
                framesPassed += (length / n) * (n - m);

                // are we in the undecimated tail?
                if (t.start + ((t.end - t.start + 1) / n) * n <= frame)
                    return framesPassed + (frame - t.start) % n;
                // fixme, check so the frame isn't decimated

                // are all frames

                // special case for normal telecine decimation
                if (m == 1 && n == 5) {

                }

            } else if (n == 1 && m > 1) {
                return framesPassed + length * m;
            }
        }
    }
}
