#include "videoprovider.h"
#include "ffmsvideowrapper.h"

TVideoWrapper::~TVideoWrapper()
{

}

TVideoProvider::TVideoProvider(const TVideoProvider &source)
{
    filename = source.filename;
    cutList = source.cutList;
    video = source.video->clone();
    video->setColorSpace(source.videoInfo().colorSpace);
    video->videoInfo(fVideoInfo);
    // adjust for cuts
}

TVideoProvider::TVideoProvider(const QString &filename)
{
    this->filename = filename;
    video = new TFFMSVideoWrapper(filename);
    video->videoInfo(fVideoInfo);
}

TVideoProvider::~TVideoProvider()
{
    delete video;
}

TVideoProvider *TVideoProvider::clone()
{
    return new TVideoProvider(*this);
}

void TVideoProvider::setCuts(const TCutList &cuts)
{
    cutList = cuts;
}

const TCutList &TVideoProvider::cuts() const
{
    return cutList;
}

const TVideoInfo &TVideoProvider::videoInfo() const
{
    return fVideoInfo;
}

void TVideoProvider::setColorSpace(TColorSpace colorSpace)
{
    video->setColorSpace(colorSpace);
    video->videoInfo(fVideoInfo);
    //adjust for cuts
}

PVideoFrame TVideoProvider::getFrame(int n)
{
    // adjust for cuts
    return video->getFrame(n);
}
