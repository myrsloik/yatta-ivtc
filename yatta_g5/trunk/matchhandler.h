#ifndef MATCHHANDLER_H
#define MATCHHANDLER_H

#include <QList>
#include <QString>
#include <QObject>
#include "coreshared.h"

struct TFrameInfo {
    int top;
    int bottom;
    int originalTop;
    int originalBottom;
    bool topFieldFirst;
    bool originalFromRFF;
    TFrameInfo(int frame);
};

class TMatchHandler : private QObject
{
    Q_OBJECT

private:
    QList<TFrameInfo> matches;

public:
    const TFrameInfo &operator [] (int i);
    bool setMatch(int top, int bottom);
    void resetMatch(int frame);
    void setMatchChar(int frame, char match);
    char matchChar(int frame);
    void setNumFrames(int n);
    void setFrame(int frame, const TFrameInfo &match);
    int numFrames();
    void matchesFromD2V(const QString &d2vFile, const TCutList &cuts);
signals:
    void matchChanged(int frame);
};

#endif // MATCHHANDLER_H
