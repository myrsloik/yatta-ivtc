#ifndef VIDEOPROVIDER_H
#define VIDEOPROVIDER_H

#include <QList>
#include <QString>
#include <QSharedPointer>
#include "coreshared.h"


enum TColorSpace { csDEFAULT, csYV12, csYUY2, csRGB32 };

struct TVideoInfo
{
    int width;
    int height;
    int numFrames;
    int FPSNum;
    int FPSDen;
    TColorSpace colorSpace;
};

class TVideoFrame {
public:
    uint8_t *data[4];
    int lineSize[4];
    bool topFieldFirst;
    virtual ~TVideoFrame() {}
};

typedef QSharedPointer<TVideoFrame> PVideoFrame;

class TVideoWrapper
{
public:
    virtual ~TVideoWrapper();
    virtual void videoInfo(TVideoInfo &videoInfo) = 0;
    virtual void setColorSpace(TColorSpace colorSpace) = 0;
    virtual PVideoFrame getFrame(int n) = 0;
    virtual TVideoWrapper *clone() = 0;
};

class TVideoProvider
{
private:
    QString filename;
    TVideoWrapper *video;
    TCutList cutList;
    TVideoInfo fVideoInfo;
    TVideoProvider(const TVideoProvider &source);
public:
    TVideoProvider(const QString &filename);
    ~TVideoProvider();
    TVideoProvider *clone();
    void setCuts(const TCutList &cuts);
    const TCutList &cuts() const;
    const TVideoInfo &videoInfo() const;
    void setColorSpace(TColorSpace colorSpace);
    PVideoFrame getFrame(int n);
    // add keyframe hinting where it's possible
    // add caching
};

#endif // VIDEOPROVIDER_H
