#ifndef METRICSCONTAINERS_H
#define METRICSCONTAINERS_H

#include <QtCore/QList>

struct TTelecideMetricSet
{
    int MMetrics[3];
    int VMetrics[3];
};

class TTelecideMetrics : public QList<TTelecideMetricSet>
{

};

struct TTFMMetricSet
{
    float TMetric[1];
};


class TTFMMetrics : public QList<TTFMMetricSet>
{

};

#endif // METRICSCONTAINERS_H
