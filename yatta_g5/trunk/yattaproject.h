#ifndef YATTAPROJECT_H
#define YATTAPROJECT_H

#include "videoprovider.h"
#include "metricscontainers.h"
#include "matchhandler.h"
#include "freezeframehandler.h"

class TYattaProject
{
public:

    // video source abstraction class
    TVideoProvider *video;
    //
    // a separate class will wrap avisynth preview
    // idea: make the avisynth_c source also work when
    // is is fed a script, so the code can be shared between them

    // field matching metric containers
    TTelecideMetrics *telecideMetrics;
    TTFMMetrics *tfmMetrics;

    // field matching handler
    TMatchHandler *matches;

    // freezeframes
    TFreezeFrameHandler *freezeFrames;

    // decimation metrics collector
    // blindly collects metrics every time a match is changed
    // possibly multithreaded so one thread can wait
    // to fix up user input while the others look ahead in the file
    // without a loaded video file this will just act like
    // a dmetric container
    // the actual metric calculationimplementation will most likely be borrowed
    // straight from tdecimate
    // needs access to the current matches to work properly

    // decimation handler
    // examines the decimation metrics and matches together to produce a
    // decision, will invoke the metrics collector when the necessary
    // dmetrics are unavailable to produce a decision
    // it will also be aware of common matching patterns such as ccnnc and
    // the proper frame to remove during 1 in 5 decimation
    // markers will set the start of every decimation region in the same
    // style as section markers do
    // m in n decimation will then be set for every region, with freedecimate-
    // like behavior being producable by allowing both m and n to be very
    // large numbers
    // there shall be a way for a user to implement the decimation script for
    // a section, much like a decimation preset, to implement increases or
    // complicated reductions in framerate beyond normal decimation
    // behavior in the "gaps" before a new decimation marker where there isn't
    // enough room to handle a full cycle poses a problem, the easiest way is
    // most likely to leave all the frames in such a gap, and to avoid these
    // cases as much as possible clearly hint the user on where the cycle
    // borders are
    // will handle a list of decimation presets as well

    // layer container
    // has a preset handling class as well, the preset class will always
    // provide the "null" default preset and it should be unchangable, also
    // a preset should not be deletable if it's in use
    // handles section and custom list style layers
    // stores ordering of the layers, including a special marker for
    // matching placement


    TYattaProject();
};

#endif // YATTAPROJECT_H
