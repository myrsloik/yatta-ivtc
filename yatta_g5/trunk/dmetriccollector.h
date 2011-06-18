#ifndef DMETRICCOLLECTOR_H
#define DMETRICCOLLECTOR_H

#include <QVector>
#include <QList>
#include <QObject>
#include <QThread>
#include <QMutex>
#include "videoprovider.h"
#include "layers.h"

class TDMetrics;

class TDMetricCollector : public QThread
{
    Q_OBJECT
private:
    TVideoProvider *video;
    QVector<int> &metrics;
    TDMetrics &owner;
public:
    TDMetricCollector(TVideoProvider *video, QVector<int> &metrics, TDMetrics &owner);
    void run();

public slots:
    void workAvailable();
};

struct TDecimationRecord
{
    int dmetric;
    bool forceDecimate;
    bool sceneChange;
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

class TDMetrics : private QObject
{
    Q_OBJECT

    friend class TDMetricCollector;

private:
    QVector<TDecimationRecord> dmetrics;
    QList<int> unprocessedAreas;
    QList<int> reservedAreas;
    QMutex mutex;
    QList<TDMetricCollector *> collectors;

public:
    static const int blockSize = 250;
    void startCollection(int threads);
    int operator [](int i);
    TCanDecimateResult canForceDecimate(int frame);
    void setForceDecimate(int frame, bool decimate);
    QList<TDecimationError> makeErrorReport();
public slots:
    void matchChanged(int frame);

signals:
    void newMetricAvailable(int n, int dmetric);
};

#endif // DMETRICCOLLECTOR_H
