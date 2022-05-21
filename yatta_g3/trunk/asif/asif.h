#include <windows.h>
#include <vector>
#include <string>
#include "avisynth.h"

typedef IScriptEnvironment* (__stdcall *CreateScriptEnvironmentFunc)(int);

struct AsifData {
    HMODULE Dll;
    CreateScriptEnvironmentFunc CreateScriptEnvironment;
};

class CAsifVideoFrame {
public:
    PVideoFrame pf;
    CAsifVideoFrame(PVideoFrame vf);
    int GetPitch(int plane);
    int GetHeight(int plane);
    int GetRowSize(int plane);
    const BYTE* GetReadPtr(int plane);
};

class CAsifClip {
    friend class CAsifScriptEnvironment;
private:
    PClip video;
    VideoInfo vi;
    IScriptEnvironment* clipse;
public:
    CAsifClip(PClip clip, IScriptEnvironment* env);
    VideoInfo GetVideoInfo();
    CAsifVideoFrame* GetFrame(int n);
    void SetCacheHints(int cachehints, int frame_range);
    bool GetParity(int n);
    void GetAudio(void* buf, __int64 start, __int64 count);
};

struct AVSValueStruct {
    int errors;
    int arraysize;
    int type;
    union {
        int ival;
        float fval;
        bool bval;
        const char* sval;
        CAsifClip* cval;
    } returnvalue;
};

class CAsifScriptEnvironment {
    friend class CAsifVideoFrame;
private:
    IScriptEnvironment* envse;
    std::vector<AVSValue> args;
    std::vector<std::string> argnames;
    void ResetArgs();
public:
    CAsifScriptEnvironment(IScriptEnvironment *ienv);
    ~CAsifScriptEnvironment();

    void SetVar(const char* varname, AVSValueStruct varvalue);
    int CharArg(const char* arg, const char* argname);
    int IntArg(const int arg, const char* argname);
    int BoolArg(const bool arg, const char* argname);
    int FloatArg(const float arg, const char* argname);
    int ClipArg(CAsifClip* clip, const char* argname);
    AVSValueStruct Invoke(const char* command);
    void SetGlobalVar(const char* varname, AVSValueStruct varvalue);
    void CheckVersion(int version);
    bool FunctionExists(const char* name);
    void SaveString(const char* s, int length);
};



