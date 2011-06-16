#ifndef LAYERS_H
#define LAYERS_H

#include <QList>
#include <QString>
#include "coreshared.h"
#include "presets.h"


class TMarkerLayer : public TLayer
{
protected:
    TPresets *presets;
    QList<TSection> sections;
public:
    TMarkerLayer(TPresets *presets);
    bool remove(int index);
    int count();
    const TSection &getByFrame(int frame);
    const TSection &operator [](int i);
    bool setPreset(int index, int preset);
    bool add(int start, int preset);
    bool isPresetUsed(int id) const;
};

class TSectionLayer : public TMarkerLayer {
public:
    TSectionLayer(TPresets *apresets);
    TLayerType layerType() const;
};

class TDecimationLayer : public TMarkerLayer {
public:
    TDecimationLayer(TPresets *apresets);
    TLayerType layerType() const;
};


class TCustomListLayer : public TLayer
{
private:
    QString fName;
    QList<TCustomRange> ranges;
public:
    int preset;
    bool add(int start, int end);
    void remove(int index);
    int count();
    const TCustomRange *getByFrame(int frame);
    const TCustomRange &operator [](int i);

    TLayerType layerType() const;
    bool isPresetUsed(int id) const;
};

class TLayers
{
private:
    QList<TLayer *> layers;
public:
    TPresets presets;

    bool isPresetUsed(int id);
    int count();
    int customListLayerCount();
    int sectionLayerCount();


    void exchange(int i1, int i2);
    const TLayer &operator [](int i);

    TLayers();
    ~TLayers();
};

#endif // LAYERS_H
