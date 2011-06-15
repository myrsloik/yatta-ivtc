#ifndef LAYERS_H
#define LAYERS_H

#include <QtCore/QList>
#include <QtCore/QString>
#include "coreshared.h"


class TSectionLayer : public TLayer
{
private:
    QList<TSection> sections;
public:
    bool add(int start, int end);
    void remove(int index);
    int count();
    TSection &getByFrame(int frame);
};

class TCustomListLayer : public TLayer
{
private:
    QList<TCustomRange> sections;
public:
    QString script;
    bool add(int start, int end);
    void remove(int index);
    int count();
    TCustomRange *getByFrame(int frame);
};

class TLayers
{
private:
    QList<TLayer *> order;
public:
    int count();
    int customListLayerCount();
    int sectionLayerCount();
    void exchange(int i1, int i2);

    TLayers();
};

#endif // LAYERS_H
