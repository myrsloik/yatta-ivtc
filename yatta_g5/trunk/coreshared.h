#ifndef CORESHARED_H
#define CORESHARED_H

#include <QString>

enum TLayerType { ltSection = 200, ltMatching = 600, ltCustomList = 800 };

class TLayer
{
public:
    QString name;
    virtual TLayerType layerType() const = 0;
    virtual bool isPresetUsed(int id) const = 0;
};

typedef struct TRange
{
    int start;
    int end;
    bool operator<(const TRange &range) const;
    // fixme, add an overlap checking function here
    TRange(int start, int end)
    {
        this->start = start;
        this->end = end;
    }
} TCutRange, TCustomRange;

struct TFreezeFrame : public TRange
{
    int replace;
    TFreezeFrame(int start, int end, int replace) : TRange(start, end)
    {
        this->replace = replace;
    }
};

typedef QList<TCutRange> TCutList;

struct TSection : public TRange
{
    int preset;
    int index;
    TSection(int start, int preset) : TRange(start, 0)
    {
        this->preset = preset;
        index = 0;
    }
};

#endif // CORESHARED_H
