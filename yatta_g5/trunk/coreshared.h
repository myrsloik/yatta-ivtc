#ifndef CORESHARED_H
#define CORESHARED_H

enum TLayerType { ltSection, ltCustomList, ltMatching };

class TLayer
{
public:
    virtual const QString &name() const = 0;
    virtual TLayerType layerType() const = 0;
};

typedef struct TRange
{
    int start;
    int end;
    bool operator<(const TRange &range) const;
    // add an overlap checking function here
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
    int start;
    int end;
    int preset;
    int index;
    TSection(int start, int preset) : TRange(start, 0)
    {
        this->preset = preset;
        index = 0;
    }
};

#endif // CORESHARED_H
