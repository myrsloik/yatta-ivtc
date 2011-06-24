#include "ffmsvideowrapper.h"

TFFMSVideoWrapper::TFFMSVideoWrapper(const TFFMSVideoWrapper &source)
{
    errorInfo.Buffer      = errorMessage;
    errorInfo.BufferSize  = sizeof(errorMessage);
    index = source.index;
    video = FFMS_CreateVideoSource(filename.toUtf8(), track, index.data(), 1, FFMS_SEEK_NORMAL, &errorInfo);
    setColorSpace(csDEFAULT);
}

TFFMSVideoWrapper::TFFMSVideoWrapper(const QString &filename)
{
    FFMS_Init(FFMS_CPU_CAPS_MMX | FFMS_CPU_CAPS_MMX2, 1);

    this->filename = filename;
    QString indexName = filename + ".ffindex";
    errorInfo.Buffer      = errorMessage;
    errorInfo.BufferSize  = sizeof(errorMessage);

    index = QSharedPointer<FFMS_Index>(FFMS_ReadIndex(indexName.toUtf8(), &errorInfo), FFMS_DestroyIndex);
    if (!index) {
        index = QSharedPointer<FFMS_Index>(FFMS_MakeIndex(filename.toUtf8(), 0, 0, NULL, NULL, FFMS_IEH_ABORT, NULL, NULL, &errorInfo), FFMS_DestroyIndex);
        if (!index)
            throw QString("bleh");
        FFMS_WriteIndex(indexName.toUtf8(), index.data(), &errorInfo);
    }
    track = FFMS_GetFirstTrackOfType(index.data(), FFMS_TYPE_VIDEO, &errorInfo);
    video = FFMS_CreateVideoSource(filename.toUtf8(), track, index.data(), 1, FFMS_SEEK_NORMAL, &errorInfo);

    setColorSpace(csDEFAULT);
}

TFFMSVideoWrapper::~TFFMSVideoWrapper()
{
    FFMS_DestroyVideoSource(video);
}

void TFFMSVideoWrapper::videoInfo(TVideoInfo &videoInfo)
{
    const FFMS_VideoProperties *VP = FFMS_GetVideoProperties(video);
    const FFMS_Frame *frame = FFMS_GetFrame(video, 0, &errorInfo);

    videoInfo.width = frame->ScaledWidth;
    videoInfo.height = frame->ScaledHeight;
    videoInfo.numFrames = VP->NumFrames;
    videoInfo.FPSDen = VP->FPSDenominator;
    videoInfo.FPSNum = VP->FPSNumerator;

    if (frame->ConvertedPixelFormat == FFMS_GetPixFmt("yuv420p") || frame->ConvertedPixelFormat == FFMS_GetPixFmt("yuvj420p"))
        videoInfo.colorSpace = csYV12;
    else if (frame->ConvertedPixelFormat == FFMS_GetPixFmt("yuyv422"))
        videoInfo.colorSpace = csYUY2;
    else if (frame->ConvertedPixelFormat == FFMS_GetPixFmt("rgb32"))
        videoInfo.colorSpace = csRGB32;
}

void TFFMSVideoWrapper::setColorSpace(TColorSpace colorSpace)
{
    int64_t targetFormats = 0;

    switch (colorSpace) {
    case csYV12:
        targetFormats = (1 << FFMS_GetPixFmt("yuvj420p")) |
                (1 << FFMS_GetPixFmt("yuv420p"));
        break;
    case csYUY2:
        targetFormats = 1 << FFMS_GetPixFmt("yuyv422");
        break;
    case csRGB32:
        targetFormats = 1 << FFMS_GetPixFmt("rgb32");
        break;
    case csDEFAULT:
        targetFormats = (1 << FFMS_GetPixFmt("yuvj420p")) |
                    (1 << FFMS_GetPixFmt("yuv420p")) | (1 << FFMS_GetPixFmt("yuyv422")) |
                    (1 << FFMS_GetPixFmt("rgb32"));
        break;
    }

    const FFMS_Frame *frame = FFMS_GetFrame(video, 0, &errorInfo);
    FFMS_SetOutputFormatV(video, targetFormats, frame->EncodedWidth, frame->EncodedHeight, FFMS_RESIZER_BICUBIC, &errorInfo);
}

TFFMSVideoFrame::TFFMSVideoFrame(const FFMS_Frame *frame)
{
    for (int i = 0; i < 4; i++) {
        lineSize[i] = frame->Linesize[i];
        if (frame->Data[i]) {
            int memSize = lineSize[i] * frame->ScaledHeight;
            data[i] = new uint8_t[memSize];
            memcpy(data[i], frame->Data[i], memSize);
        } else {
            data[i] = NULL;
        }
    }
    topFieldFirst = frame->TopFieldFirst;
}

TFFMSVideoFrame::~TFFMSVideoFrame()
{
    for (int i = 0; i < 4; i++)
        delete [] data[i];
}

TFFMSVideoFrame *TFFMSVideoWrapper::getFrame(int n)
{
    const FFMS_Frame *frame = FFMS_GetFrame(video, n, &errorInfo);
    return new TFFMSVideoFrame(frame);
}

TFFMSVideoWrapper *TFFMSVideoWrapper::clone()
{
    return new TFFMSVideoWrapper(*this);
}
