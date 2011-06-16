#ifndef LAYERS_H
#define LAYERS_H

#include <QList>
#include <QString>
#include "coreshared.h"


class TSectionLayer : public TLayer
{
private:
    QList<TSection> sections;
public:
    TSectionLayer();
    bool add(int start, int end);
    bool remove(int index);
    int count();
    const TSection &getByFrame(int frame);
    const TSection &operator [](int i);
};

class TCustomListLayer : public TLayer
{
private:
    QList<TCustomRange> ranges;
public:
    QString script;
    bool add(int start, int end);
    bool remove(int index);
    int count();
    const TCustomRange *getByFrame(int frame);
    const TCustomRange &operator [](int i);
};

class TLayers
{
private:
    QList<TLayer *> order;
public:
    bool isPresetUsed(int id);
    int count();
    int customListLayerCount();
    int sectionLayerCount();

    void exchange(int i1, int i2);
    const TLayer &operator [](int i);
    TLayers();
};

#endif // LAYERS_H
