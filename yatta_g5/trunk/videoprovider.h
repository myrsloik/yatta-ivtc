#ifndef VIDEOPROVIDER_H
#define VIDEOPROVIDER_H

#include <QtCore/QList>
#include <QtCore/QString>
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

struct TVideoFrame {
    uint8_t *Data[4];
    int Linesize[4];
    int TopFieldFirst;
};

class TVideoWrapper
{
public:
    virtual ~TVideoWrapper();
    virtual void videoInfo(TVideoInfo &videoInfo) = 0;
    virtual void setColorSpace(TColorSpace colorSpace) = 0;
    virtual const TVideoFrame &getFrame(int n) = 0;
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
    const TVideoFrame &getFrame(int n);
};

#endif // VIDEOPROVIDER_H
