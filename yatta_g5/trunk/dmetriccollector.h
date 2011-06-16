#ifndef DMETRICCOLLECTOR_H
#define DMETRICCOLLECTOR_H

#include <QList>
#include <QObject>

class TDMetricCollector : private QObject
{
    Q_OBJECT

private:
    QList<int> dmetrics;
public:

public slots:
    void matchChanged(int frame);
};

#endif // DMETRICCOLLECTOR_H
