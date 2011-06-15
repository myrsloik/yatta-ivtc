#ifndef FREEZEFRAMEHANDLER_H
#define FREEZEFRAMEHANDLER_H

#include <QList>

struct TFreezeFrame
{
    int start;
    int end;
    int replace;
    bool operator<(const TFreezeFrame &freezeFrame) const;
    TFreezeFrame(int start, int end, int replace);
};

class TFreezeFrameHandler
{
private:
    QList<TFreezeFrame> freezeFrames;
    TFreezeFrame *lastFF;
public:
    const TFreezeFrame &operator [] (int i);
    int count();
    const TFreezeFrame *getByFrame(int frame);
    int getFrozenFrame(int frame);
    bool add(int start, int end, int replace);
    void remove(int index);
    void clear();
};

#endif // FREEZEFRAMEHANDLER_H
