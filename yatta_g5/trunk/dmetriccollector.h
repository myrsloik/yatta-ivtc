#ifndef DMETRICCOLLECTOR_H
#define DMETRICCOLLECTOR_H

#include <QVector>
#include <QList>
#include <QObject>
#include <QThread>
#include <QMutex>
#include <QCache>
#include "videoprovider.h"
#include "layers.h"
#include "matchhandler.h"

class TDecimationHandler;

class TDMetricCollector : public QThread
{
    Q_OBJECT
private:
    TVideoProvider *video;
    TDecimationHandler &fOwner;
    QCache<int, TVideoFrame> cache;
    int currentArea;

    static void calculateSAD(const TVideoFrame *f1top, const TVideoFrame *f1bottom,
                      const TVideoFrame *f2top, const TVideoFrame *f2bottom,
                      const TVideoInfo &vi, int &dmetric, int &sad);
public:
    TDMetricCollector(TVideoProvider *video, TDecimationHandler &owner);
    void run();

public slots:
    void workAvailable();
};

struct TDecimationRecord
{
    int dmetric;
    int sad;
    bool forceDecimate;
};

enum TDecimationErrorType { deOverDecimated = 0, deScriptDecimate, deNoDecimation };

struct TDecimationError
{
    int frame;
    int index;
    int preset;
    TDecimationErrorType error;
};

enum TCanDecimateResult { cdOK = 0, cdScriptDecimate, cdAlreadyForceDecimated, cdNoDecimation, cdFullyDecimated };

enum TDPosError { dpOK = 0, dpMissingMetrics, dpScriptDecimate, dpOverDecimated };

class TDecimationHandler : private QObject
{
    Q_OBJECT

    friend class TDMetricCollector;

private:
    TMatchHandler &fMatches;
    TLayers &fLayers;
    TDecimationLayer &fDecimationLayer;
    QVector<TDecimationRecord> metrics;
    QList<int> unprocessedAreas;
    QMutex mutex;
    QList<TDMetricCollector *> collectors;

public:
    static const int blockSize = 250;
    void startCollection(int threads);
    int operator [](int i);
    TCanDecimateResult canForceDecimate(int frame);
    TCanDecimateResult setForceDecimate(int frame, bool decimate);
    QList<TDecimationError> makeErrorReport(int start, int end);
    TDecimationHandler(TMatchHandler &matches, TLayers &layers);
    int getDecimatedFrameNumber(int frame);
public slots:
    void matchChanged(int frame);

signals:
    void newMetricAvailable(int frame, int dmetric);
};

#endif // DMETRICCOLLECTOR_H
