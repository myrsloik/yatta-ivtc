#ifndef MATCHHANDLER_H
#define MATCHHANDLER_H

#include <QtCore/QList>
#include <QtCore/QString>
#include "ffmsvideowrapper.h"

struct TFrameInfo {
    int top;
    int bottom;
    int originalTop;
    int originalBottom;
    bool topFieldFirst;
    bool originalFromRFF;

    TFrameInfo(int frame);
};

class TMatchHandler
{
private:
    QList<TFrameInfo> matches;

public:
    TMatchHandler();
    TFrameInfo &operator [] (int i);
    void setMatchChar(int frame, char match);
    char matchChar(int frame);
    void setNumFrames(int n);
    int numFrames();
    void matchesFromD2V(const QString &d2vFile, const TCutList &cuts);
};

#endif // MATCHHANDLER_H
