{
* Copyright (c) 2015 Fredrik Mellbin
*
* This file is part of VapourSynth.
*
* VapourSynth is free software; you can redistribute it and/or
* modify it under the terms of the GNU Lesser General Public
* License as published by the Free Software Foundation; either
* version 2.1 of the License, or (at your option) any later version.
*
* VapourSynth is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
* Lesser General Public License for more details.
*
* You should have received a copy of the GNU Lesser General Public
* License along with VapourSynth; if not, write to the Free Software
* Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
}

unit VapourSynth;

{$IFDEF WIN32}
{$DEFINE STDCALL}
{$ENDIF}

{$ALIGN 8}
{$Z4}

interface

const
  VAPOURSYNTH_API_MAJOR = 3;
  VAPOURSYNTH_API_MINOR = 1;
  VAPOURSYNTH_API_VERSION = (VAPOURSYNTH_API_MAJOR shl 16) or VAPOURSYNTH_API_MINOR;

type
  PPointer = ^Pointer;
  PVSFrameRef = Pointer;
  PVSNodeRef = Pointer;
  PVSCore = Pointer;
  PVSPlugin = Pointer;
  PVSNode = Pointer;
  PVSFuncRef = Pointer;
  PVSMap = Pointer;
  PVSFrameContext = Pointer;

  VSColorFamily = (
    cmGray   = 1000000,
    cmRGB    = 2000000,
    cmYUV    = 3000000,
    cmYCoCg  = 4000000,
    cmCompat = 9000000);

  VSSampleType = (
    stInteger = 0,
    stFloat = 1);

  VSPresetFormat = (
    pfNone = 0,

    pfGray8 = Integer(cmGray) + 10,
    pfGray16,

    pfGrayH,
    pfGrayS,

    pfYUV420P8 = Integer(cmYUV) + 10,
    pfYUV422P8,
    pfYUV444P8,
    pfYUV410P8,
    pfYUV411P8,
    pfYUV440P8,

    pfYUV420P9,
    pfYUV422P9,
    pfYUV444P9,

    pfYUV420P10,
    pfYUV422P10,
    pfYUV444P10,

    pfYUV420P16,
    pfYUV422P16,
    pfYUV444P16,

    pfYUV444PH,
    pfYUV444PS,

    pfRGB24 = Integer(cmRGB) + 10,
    pfRGB27,
    pfRGB30,
    pfRGB48,

    pfRGBH,
    pfRGBS,

    pfCompatBGR32 = Integer(cmCompat) + 10,
    pfCompatYUY2);

  VSFilterMode = (
    fmParallel = 100,
    fmParallelRequests = 200,
    fmUnordered = 300,
    fmSerial = 400);

  VSFormat = record
    name: array[0..31] of AnsiChar;
    id: Integer;
    colorFamily: VSColorFamily;
    sampleType: VSSampleType;
    bitsPerSample: Integer;
    bytesPerSample: Integer;

    subSamplingW: Integer;
    subSamplingH: Integer;

    numPlanes: Integer;
  end;

  PVSFormat = ^VSFormat;

  VSNodeFlags = (
    nfNoCache = 1,
    nfIsCache = 2);

  VSPropTypes = (
    ptUnset = Integer('u'),
    ptInt = Integer('i'),
    ptFloat = Integer('f'),
    ptData = Integer('s'),
    ptNode = Integer('c'),
    ptFrame = Integer('v'),
    ptFunction = Integer('m'));

  VSGetPropErrors = (
    peUnset = 1,
    peType  = 2,
    peIndex = 4);

  VSPropAppendMode = (
    paReplace = 0,
    paAppend  = 1,
    paTouch   = 2);

  VSCoreInfo = record
    versionString: PAnsiChar;
    core: Integer;
    api: Integer;
    numThreads: Integer;
    maxFramebufferSize: Int64;
    usedFramebufferSize: Int64;
  end;

  PVSCoreInfo = ^VSCoreInfo;

  VSVideoInfo = record
    format: PVSFormat;
    fpsNum: Int64;
    fpsDen: Int64;
    width: Integer;
    height: Integer;
    numFrames: Integer;
    flags: Integer;
  end;

  VSActivationReason = (
    arInitial = 0,
    arFrameReady = 1,
    arAllFramesReady = 2,
    arError = -1);

  VSMessageType = (
    mtDebug = 0,
    mtWarning = 1,
    mtCritical = 2,
    mtFatal = 3);

  PVSAPI = ^VSAPI;

  VSPublicFunction = procedure(inm: PVSMap; outm: PVSMap; userData: Pointer; core: PVSCore = nil; vsapi: PVSAPI = nil);
  VSFilterInit = procedure(inm: PVSMap; outm: PVSMap; instanceData: PPointer; node: PVSNode; core: PVSCore; vsapi: PVSAPI);
  VSFilterGetFrame = function(n: Integer; activationReason: Integer; instanceData: PPointer; frameData: PPointer; frameCtx: PVSFrameContext; core: PVSCore; vsapi: PVSAPI): PVSFrameRef;
  VSFilterFree = procedure(instanceData: Pointer; core: PVSCore; vsapi: PVSAPI);

  VSAPI = record
    createCore: function(threads: Integer): PVSCore; {$IFDEF STDCALL}stdcall;{$ENDIF}
    freeCore: procedure(core: PVSCore); {$IFDEF STDCALL}stdcall;{$ENDIF}
    getCoreInfo: function(core: PVSCore): PVSCoreInfo; {$IFDEF STDCALL}stdcall;{$ENDIF}

    cloneFrameRef: function(f: PVSFrameRef): PVSFrameRef; {$IFDEF STDCALL}stdcall;{$ENDIF}
    cloneNodeRef: function(node: PVSNodeRef): PVSNodeRef; {$IFDEF STDCALL}stdcall;{$ENDIF}
    cloneFuncRef: function(f: PVSFuncRef): PVSFuncRef; {$IFDEF STDCALL}stdcall;{$ENDIF}

    freeFrame: procedure(f: PVSFrameRef); {$IFDEF STDCALL}stdcall;{$ENDIF}
    freeNode: procedure(node: PVSNodeRef); {$IFDEF STDCALL}stdcall;{$ENDIF}
    freeFunc: procedure(f: PVSFuncRef); {$IFDEF STDCALL}stdcall;{$ENDIF}

    newVideoFrame: function(format: PVSFormat; width: Integer; height: Integer; propSrc: PVSFrameRef; core: PVSCore): PVSFrameRef; {$IFDEF STDCALL}stdcall;{$ENDIF}
    copyFrame: function(f: PVSFrameRef; core: PVSCore): PVSFrameRef; {$IFDEF STDCALL}stdcall;{$ENDIF}
    copyFrameProps: procedure(src: PVSFrameRef; dst: PVSFrameRef; core: PVSCore); {$IFDEF STDCALL}stdcall;{$ENDIF}

    registerFunction: procedure(name: PAnsiChar; args: PAnsiChar; argsFunc: VSPublicFunction; functionData: Pointer; plugin: PVSPlugin);
    getPluginById: function(identifier: PAnsiChar; core: PVSCore): PVSPlugin;
    getPluginByNs: function(ns: PAnsiChar; core: PVSCore): PVSPlugin;
    getPlugins: function(core: PVSCore): PVSMap;
    getFunctions: function(plugin: PVSPlugin): PVSMap;
    createFilter: procedure(inm: PVSMap; outm: PVSMap; name: PAnsiChar; init: VSFilterInit; getFrame: VSFilterGetFrame; free: VSFilterFree; fitlerMode: Integer; flags:Integer; instanceData: Pointer; core: PVSCore);
    setError: procedure(map: PVSMap; errorMessage: PAnsiChar);
    getError: function(map: PVSMap): PAnsiChar;
    setFilterError: procedure(errorMessage: PAnsiChar; frameCtx: PVSFrameContext);
    invoke: function(plugin: PVSPlugin; name: PAnsiChar; args: PVSMap): PVSMap;
    getFormatPreset: function(id: Integer; core: PVSCore): PVSFormat;
    registerFormat: function(colorFamily: VSColorFamily; sampleType: VSSampleType; bitsPerSample: Integer; subSamplingW: Integer; subSamplingH: Integer; core: PVSCore): PVSFormat;

    getFrame;
    getFrameAsync;
    getFrameFilter;
    requestFrameFilter;
    queryCompletedFrame;
    releaseFrameEarly;
  end;



implementation

end.


#if defined(_WIN32) && !defined(_WIN64)
#    define VS_CC __stdcall
#else
#    define VS_CC
#endif


/* core function typedefs */
typedef const VSAPI *(VS_CC *VSGetVapourSynthAPI)(int version);



/* function/filter typedefs */
typedef void (VS_CC *VSPublicFunction)(const VSMap *in, VSMap *out, void *userData, VSCore *core, const VSAPI *vsapi);
typedef void (VS_CC *VSFreeFuncData)(void *userData);
typedef void (VS_CC *VSFilterInit)(VSMap *in, VSMap *out, void **instanceData, VSNode *node, VSCore *core, const VSAPI *vsapi);
typedef const VSFrameRef *(VS_CC *VSFilterGetFrame)(int n, int activationReason, void **instanceData, void **frameData, VSFrameContext *frameCtx, VSCore *core, const VSAPI *vsapi);
typedef int (VS_CC *VSGetOutputIndex)(VSFrameContext *frameCtx);
typedef void (VS_CC *VSFilterFree)(void *instanceData, VSCore *core, const VSAPI *vsapi);
typedef void (VS_CC *VSRegisterFunction)(const char *name, const char *args, VSPublicFunction argsFunc, void *functionData, VSPlugin *plugin);
typedef void (VS_CC *VSCreateFilter)(const VSMap *in, VSMap *out, const char *name, VSFilterInit init, VSFilterGetFrame getFrame, VSFilterFree free, int filterMode, int flags, void *instanceData, VSCore *core);
typedef VSMap *(VS_CC *VSInvoke)(VSPlugin *plugin, const char *name, const VSMap *args);
typedef void (VS_CC *VSSetError)(VSMap *map, const char *errorMessage);
typedef const char *(VS_CC *VSGetError)(const VSMap *map);
typedef void (VS_CC *VSSetFilterError)(const char *errorMessage, VSFrameContext *frameCtx);

typedef const VSFormat *(VS_CC *VSGetFormatPreset)(int id, VSCore *core);
typedef const VSFormat *(VS_CC *VSRegisterFormat)(int colorFamily, int sampleType, int bitsPerSample, int subSamplingW, int subSamplingH, VSCore *core);

/* frame and clip handling */
typedef void (VS_CC *VSFrameDoneCallback)(void *userData, const VSFrameRef *f, int n, VSNodeRef *, const char *errorMsg);
typedef void (VS_CC *VSGetFrameAsync)(int n, VSNodeRef *node, VSFrameDoneCallback callback, void *userData);
typedef const VSFrameRef *(VS_CC *VSGetFrame)(int n, VSNodeRef *node, char *errorMsg, int bufSize);
typedef void (VS_CC *VSRequestFrameFilter)(int n, VSNodeRef *node, VSFrameContext *frameCtx);
typedef const VSFrameRef *(VS_CC *VSGetFrameFilter)(int n, VSNodeRef *node, VSFrameContext *frameCtx);
typedef const VSFrameRef *(VS_CC *VSCloneFrameRef)(const VSFrameRef *f);
typedef VSNodeRef *(VS_CC *VSCloneNodeRef)(VSNodeRef *node);
typedef VSFuncRef *(VS_CC *VSCloneFuncRef)(VSFuncRef *f);
typedef void (VS_CC *VSFreeFrame)(const VSFrameRef *f);
typedef void (VS_CC *VSFreeNode)(VSNodeRef *node);
typedef void (VS_CC *VSFreeFunc)(VSFuncRef *f);
typedef VSFrameRef *(VS_CC *VSNewVideoFrame)(const VSFormat *format, int width, int height, const VSFrameRef *propSrc, VSCore *core);
typedef VSFrameRef *(VS_CC *VSNewVideoFrame2)(const VSFormat *format, int width, int height, const VSFrameRef **planeSrc, const int *planes, const VSFrameRef *propSrc, VSCore *core);
typedef VSFrameRef *(VS_CC *VSCopyFrame)(const VSFrameRef *f, VSCore *core);
typedef void (VS_CC *VSCopyFrameProps)(const VSFrameRef *src, VSFrameRef *dst, VSCore *core);
typedef int (VS_CC *VSGetStride)(const VSFrameRef *f, int plane);
typedef const uint8_t *(VS_CC *VSGetReadPtr)(const VSFrameRef *f, int plane);
typedef uint8_t *(VS_CC *VSGetWritePtr)(VSFrameRef *f, int plane);

/* property access */
typedef const VSVideoInfo *(VS_CC *VSGetVideoInfo)(VSNodeRef *node);
typedef void (VS_CC *VSSetVideoInfo)(const VSVideoInfo *vi, int numOutputs, VSNode *node);
typedef const VSFormat *(VS_CC *VSGetFrameFormat)(const VSFrameRef *f);
typedef int (VS_CC *VSGetFrameWidth)(const VSFrameRef *f, int plane);
typedef int (VS_CC *VSGetFrameHeight)(const VSFrameRef *f, int plane);
typedef const VSMap *(VS_CC *VSGetFramePropsRO)(const VSFrameRef *f);
typedef VSMap *(VS_CC *VSGetFramePropsRW)(VSFrameRef *f);
typedef int (VS_CC *VSPropNumKeys)(const VSMap *map);
typedef const char *(VS_CC *VSPropGetKey)(const VSMap *map, int index);
typedef int (VS_CC *VSPropNumElements)(const VSMap *map, const char *key);
typedef char(VS_CC *VSPropGetType)(const VSMap *map, const char *key);

typedef VSMap *(VS_CC *VSCreateMap)(void);
typedef void (VS_CC *VSFreeMap)(VSMap *map);
typedef void (VS_CC *VSClearMap)(VSMap *map);

typedef int64_t (VS_CC *VSPropGetInt)(const VSMap *map, const char *key, int index, int *error);
typedef double(VS_CC *VSPropGetFloat)(const VSMap *map, const char *key, int index, int *error);
typedef const char *(VS_CC *VSPropGetData)(const VSMap *map, const char *key, int index, int *error);
typedef int (VS_CC *VSPropGetDataSize)(const VSMap *map, const char *key, int index, int *error);
typedef VSNodeRef *(VS_CC *VSPropGetNode)(const VSMap *map, const char *key, int index, int *error);
typedef const VSFrameRef *(VS_CC *VSPropGetFrame)(const VSMap *map, const char *key, int index, int *error);
typedef VSFuncRef *(VS_CC *VSPropGetFunc)(const VSMap *map, const char *key, int index, int *error);

typedef int (VS_CC *VSPropDeleteKey)(VSMap *map, const char *key);
typedef int (VS_CC *VSPropSetInt)(VSMap *map, const char *key, int64_t i, int append);
typedef int (VS_CC *VSPropSetFloat)(VSMap *map, const char *key, double d, int append);
typedef int (VS_CC *VSPropSetData)(VSMap *map, const char *key, const char *data, int size, int append);
typedef int (VS_CC *VSPropSetNode)(VSMap *map, const char *key, VSNodeRef *node, int append);
typedef int (VS_CC *VSPropSetFrame)(VSMap *map, const char *key, const VSFrameRef *f, int append);
typedef int (VS_CC *VSPropSetFunc)(VSMap *map, const char *key, VSFuncRef *func, int append);

/* mixed */
typedef void (VS_CC *VSConfigPlugin)(const char *identifier, const char *defaultNamespace, const char *name, int apiVersion, int readonly, VSPlugin *plugin);
typedef void (VS_CC *VSInitPlugin)(VSConfigPlugin configFunc, VSRegisterFunction registerFunc, VSPlugin *plugin);

typedef VSPlugin *(VS_CC *VSGetPluginById)(const char *identifier, VSCore *core);
typedef VSPlugin *(VS_CC *VSGetPluginByNs)(const char *ns, VSCore *core);

typedef VSMap *(VS_CC *VSGetPlugins)(VSCore *core);
typedef VSMap *(VS_CC *VSGetFunctions)(VSPlugin *plugin);

typedef void (VS_CC *VSCallFunc)(VSFuncRef *func, const VSMap *in, VSMap *out, VSCore *core, const VSAPI *vsapi); /* core and vsapi arguments are completely ignored, they only remain to preserve ABI */
typedef VSFuncRef *(VS_CC *VSCreateFunc)(VSPublicFunction func, void *userData, VSFreeFuncData free, VSCore *core, const VSAPI *vsapi);

typedef void (VS_CC *VSQueryCompletedFrame)(VSNodeRef **node, int *n, VSFrameContext *frameCtx);
typedef void (VS_CC *VSReleaseFrameEarly)(VSNodeRef *node, int n, VSFrameContext *frameCtx);

typedef int64_t (VS_CC *VSSetMaxCacheSize)(int64_t bytes, VSCore *core);
typedef int (VS_CC *VSSetThreadCount)(int threads, VSCore *core);

typedef void (VS_CC *VSMessageHandler)(int msgType, const char *msg, void *userData);
typedef void (VS_CC *VSSetMessageHandler)(VSMessageHandler handler, void *userData);

typedef const char *(VS_CC *VSGetPluginPath)(const VSPlugin *plugin);

typedef const int64_t *(VS_CC *VSPropGetIntArray)(const VSMap *map, const char *key, int *error);
typedef const double *(VS_CC *VSPropGetFloatArray)(const VSMap *map, const char *key, int *error);

typedef int (VS_CC *VSPropSetIntArray)(VSMap *map, const char *key, const int64_t *i, int size);
typedef int (VS_CC *VSPropSetFloatArray)(VSMap *map, const char *key, const double *d, int size);


struct VSAPI {
    VSGetFrame getFrame; /* do never use inside a filter's getframe function, for external applications using the core as a library or for requesting frames in a filter constructor */
    VSGetFrameAsync getFrameAsync; /* do never use inside a filter's getframe function, for external applications using the core as a library or for requesting frames in a filter constructor */
    VSGetFrameFilter getFrameFilter; /* only use inside a filter's getframe function */
    VSRequestFrameFilter requestFrameFilter; /* only use inside a filter's getframe function */
    VSQueryCompletedFrame queryCompletedFrame; /* only use inside a filter's getframe function */
    VSReleaseFrameEarly releaseFrameEarly; /* only use inside a filter's getframe function */

    VSGetStride getStride;
    VSGetReadPtr getReadPtr;
    VSGetWritePtr getWritePtr;

    VSCreateFunc createFunc;
    VSCallFunc callFunc;

    /* property access functions */
    VSCreateMap createMap;
    VSFreeMap freeMap;
    VSClearMap clearMap;

    VSGetVideoInfo getVideoInfo;
    VSSetVideoInfo setVideoInfo;
    VSGetFrameFormat getFrameFormat;
    VSGetFrameWidth getFrameWidth;
    VSGetFrameHeight getFrameHeight;
    VSGetFramePropsRO getFramePropsRO;
    VSGetFramePropsRW getFramePropsRW;

    VSPropNumKeys propNumKeys;
    VSPropGetKey propGetKey;
    VSPropNumElements propNumElements;
    VSPropGetType propGetType;
    VSPropGetInt propGetInt;
    VSPropGetFloat propGetFloat;
    VSPropGetData propGetData;
    VSPropGetDataSize propGetDataSize;
    VSPropGetNode propGetNode;
    VSPropGetFrame propGetFrame;
    VSPropGetFunc propGetFunc;

    VSPropDeleteKey propDeleteKey;
    VSPropSetInt propSetInt;
    VSPropSetFloat propSetFloat;
    VSPropSetData propSetData;
    VSPropSetNode propSetNode;
    VSPropSetFrame propSetFrame;
    VSPropSetFunc propSetFunc;

    VSSetMaxCacheSize setMaxCacheSize;
    VSGetOutputIndex getOutputIndex;
    VSNewVideoFrame2 newVideoFrame2;

    VSSetMessageHandler setMessageHandler;
    VSSetThreadCount setThreadCount;

    VSGetPluginPath getPluginPath;

    VSPropGetIntArray propGetIntArray;
    VSPropGetFloatArray propGetFloatArray;

    VSPropSetIntArray propSetIntArray;
    VSPropSetFloatArray propSetFloatArray;
};

VS_API(const VSAPI *) getVapourSynthAPI(int version);

