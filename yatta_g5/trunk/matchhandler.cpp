#include "matchhandler.h"

TFrameInfo::TFrameInfo(int frame)
{
    top = frame;
    bottom = frame;
    originalTop = frame;
    originalBottom = frame;
    topFieldFirst = false;
    originalFromRFF = false;
}

const TFrameInfo &TMatchHandler::operator [] (int i)
{
    return matches[i];
}

void TMatchHandler::setMatchChar(int frame, char match)
{
    TFrameInfo &f = matches[frame];
    switch (match) {
    case 'c':
        f.top = frame;
        f.bottom = frame;
        break;
    case 'u':
        f.top = frame + (f.topFieldFirst ? 1 : 0);
        f.bottom = frame + (f.topFieldFirst ? 0 : 1);
        break;
    case 'n':
        f.top = frame + (f.topFieldFirst ? 0 : 1);
        f.bottom = frame + (f.topFieldFirst ? 1 : 0);
        break;
    case 'b':
        f.top = frame - (f.topFieldFirst ? 0 : 1);
        f.bottom = frame - (f.topFieldFirst ? 1 : 0);
        break;
    case 'p':
        f.top = frame - (f.topFieldFirst ? 1 : 0);
        f.bottom = frame - (f.topFieldFirst ? 0 : 1);
        break;
    }
}

char TMatchHandler::matchChar(int frame)
{
    const TFrameInfo &f = matches[frame];

    if (f.top == frame && f.bottom == frame)
        return 'c';

    if (f.top == frame + 1 && f.bottom == frame)
        return f.topFieldFirst ? 'u' : 'n';

    if (f.top == frame && f.bottom == frame + 1)
        return f.topFieldFirst ? 'n' : 'u';

    if (f.top == frame && f.bottom == frame - 1)
        return f.topFieldFirst ? 'b' : 'p';

    if (f.top == frame - 1 && f.bottom == frame)
        return f.topFieldFirst ? 'p' : 'b';

    return 's';
}

void TMatchHandler::setNumFrames(int n)
{
    matches.clear();
    matches.reserve(n);
    for (int i = 0; i < n; n++)
        matches.append(TFrameInfo(i));
}

int TMatchHandler::numFrames()
{
    return matches.count();
}

void TMatchHandler::matchesFromD2V(const QString &d2vFile, const TCutList &cuts)
{

}
