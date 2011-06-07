#ifndef FFMSVIDEOWRAPPER_H
#define FFMSVIDEOWRAPPER_H

#include "external/ffms.h"
#include "videoprovider.h"
#include <QtCore/QString>
#include <QSharedPointer>

class TFFMSVideoWrapper : public TVideoWrapper
{
private:
    char errorMessage[1024];
    FFMS_ErrorInfo errorInfo;
    FFMS_VideoSource *video;
    TVideoFrame vf;
    QSharedPointer<FFMS_Index> index;
    QString filename;
    int track;
    TFFMSVideoWrapper(const TFFMSVideoWrapper &source);
public:
    TFFMSVideoWrapper(const QString &filename);
    ~TFFMSVideoWrapper();
    void videoInfo(TVideoInfo &videoInfo);
    void setColorSpace(TColorSpace colorSpace);
    const TVideoFrame &getFrame(int n);
    TVideoWrapper *clone();
};

#endif // FFMSVIDEOWRAPPER_H
