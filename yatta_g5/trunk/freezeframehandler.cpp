#include "freezeframehandler.h"

bool TFreezeFrame::operator<(const TFreezeFrame &freezeFrame) const
{
    return start < freezeFrame.start;
}

TFreezeFrame::TFreezeFrame(int start, int end, int replace)
{
    this->start = start;
    this->end = end;
    this->replace = replace;
}

const TFreezeFrame &TFreezeFrameHandler::operator [] (int i)
{
    return freezeFrames[i];
}

int TFreezeFrameHandler::count()
{
    return freezeFrames.count();
}

const TFreezeFrame *TFreezeFrameHandler::getByFrame(int frame)
{
    for (QList<TFreezeFrame>::const_iterator i = freezeFrames.constBegin(); i != freezeFrames.constEnd(); ++i) {
        if (i->start <= frame && i->end >= frame)
            return &(*i);
    }
    return NULL;
}

int TFreezeFrameHandler::getFrozenFrame(int frame)
{
    const TFreezeFrame *ff = getByFrame(frame);
    if (ff)
        return ff->replace;
    else
        return frame;
}

bool TFreezeFrameHandler::add(int start, int end, int replace)
{
    if (start > end || start < 0 || (start == end && replace == end))
        return false;

    for (QList<TFreezeFrame>::const_iterator i = freezeFrames.constBegin(); i != freezeFrames.constEnd(); ++i) {
        if ((i->start <= replace) && (i->end >= replace) || (i->start >= start) && (i->start <= end) || (i->end <= end) && (i->end >= start) || (i->start <= start) && (i->end >= end) || (i->replace >= start) && (i->replace <= end))
            return false;
    }

    freezeFrames.append(TFreezeFrame(start, end, replace));
    qSort(freezeFrames);
    return true;
}

void TFreezeFrameHandler::remove(int index)
{
    freezeFrames.removeAt(index);
}

void TFreezeFrameHandler::clear()
{
    freezeFrames.clear();
}
