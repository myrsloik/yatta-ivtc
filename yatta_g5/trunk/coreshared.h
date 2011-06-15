#ifndef CORESHARED_H
#define CORESHARED_H

enum TLayerType { ltSection, ltCustomList, ltMatching };

class TLayer
{
public:
    virtual const QString &name() = 0;
    virtual TLayerType layerType() = 0;
};

typedef struct
{
    int start;
    int end;
} TCutRange, TCustomRange;

typedef QList<TCutRange> TCutList;

struct TSection
{
    int start;
    int preset;
};

#endif // CORESHARED_H
