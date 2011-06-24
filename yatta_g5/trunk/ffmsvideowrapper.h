#ifndef FFMSVIDEOWRAPPER_H
#define FFMSVIDEOWRAPPER_H

#include <QString>
#include <QSharedPointer>
#include "external/ffms.h"
#include "videoprovider.h"

class TFFMSVideoFrame : public TVideoFrame
{
public:
    TFFMSVideoFrame(const FFMS_Frame *frame);
    ~TFFMSVideoFrame();
};

class TFFMSVideoWrapper : public TVideoWrapper
{
private:
    char errorMessage[1024];
    FFMS_ErrorInfo errorInfo;
    FFMS_VideoSource *video;
    QSharedPointer<FFMS_Index> index;
    QString filename;
    int track;
    TFFMSVideoWrapper(const TFFMSVideoWrapper &source);
public:
    TFFMSVideoWrapper(const QString &filename);
    ~TFFMSVideoWrapper();
    void videoInfo(TVideoInfo &videoInfo);
    void setColorSpace(TColorSpace colorSpace);
    TFFMSVideoFrame *getFrame(int n);
    TFFMSVideoWrapper *clone();
};

#endif // FFMSVIDEOWRAPPER_H
