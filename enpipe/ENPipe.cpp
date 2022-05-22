#include <stdio.h>
#include <windows.h>
#include "avisynth.h"

#include <windows.h> 
#include <tchar.h>
#include <stdio.h> 
#include <strsafe.h>

#define BUFSIZE 4096 

static const int planes[] = {PLANAR_Y, PLANAR_U, PLANAR_V};

struct TPipes {
	HANDLE g_hChildStd_IN_Wr;	
	HANDLE g_hChildStd_IN_Rd;
	HANDLE g_hChildStd_OUT_Wr;
	HANDLE g_hChildStd_OUT_Rd;
};

class ENPipe : public GenericVideoFilter {
private:
	void WriteAudioToPipe(TPipes &Pipes, void *Buf, __int64 Count, IScriptEnvironment *Env) {
		DWORD dwWritten;
		DWORD dwToWrite = vi.BytesPerAudioSample() * Count;
		BOOL bSuccess = WriteFile(Pipes.g_hChildStd_IN_Wr, Buf, dwToWrite, &dwWritten, NULL);
		if (!bSuccess)
			Env->ThrowError("ENPipe: Failed writing y4m header to pipe");
	}

	void WriteY4MToPipe(TPipes &Pipes, IScriptEnvironment *Env) {
		char str[1024];
		DWORD dwWritten;
		DWORD dwToWrite = sprintf(str, "YUV4MPEG2 W%d H%d F%ld:%ld Ip A0:0 C%s\n",
			vi.width, vi.height, vi.fps_numerator, vi.fps_denominator, vi.IsYV12() ? "420" : "422") + 1;	
		BOOL bSuccess = WriteFile(Pipes.g_hChildStd_IN_Wr, str, dwToWrite, &dwWritten, NULL);
		if (!bSuccess)
			Env->ThrowError("ENPipe: Failed writing y4m header to pipe");
	}

	void WriteFrameToPipe(PVideoFrame &Frame, TPipes &Pipes, IScriptEnvironment *Env) { 
		DWORD dwWritten; 
		BOOL bSuccess = FALSE;

		if (vi.IsYV12()) {
			for (int i = 0; i < 3; i++) {
				const BYTE *src = Frame->GetReadPtr(planes[i]);
				const int pitch = Frame->GetPitch(planes[i]);
				const int rowsize = Frame->GetRowSize(planes[i]);
				const int height = Frame->GetHeight(planes[i]);
				for (int y = 0; y < height; y++) {
					bSuccess = WriteFile(Pipes.g_hChildStd_IN_Wr, src, rowsize, &dwWritten, NULL);
					if (!bSuccess)
						Env->ThrowError("ENPipe: Failed writing frame to pipe");
					src += pitch;
				}
			}
		} else {
			const BYTE *src = Frame->GetReadPtr();
			const int pitch = Frame->GetPitch();
			const int rowsize = Frame->GetRowSize();
			const int height = Frame->GetHeight();
			for (int y = 0; y < height; y++) {
				bSuccess = WriteFile(Pipes.g_hChildStd_IN_Wr, src, rowsize, &dwWritten, NULL);
				if (!bSuccess)
					Env->ThrowError("ENPipe: Failed writing frame to pipe");
				src += pitch;
			}
		}
	}

	void ReadFromPipe(TPipes &Pipes) { 
		DWORD dwRead; 
		CHAR chBuf[BUFSIZE]; 
		BOOL bSuccess = FALSE;

		bSuccess = ReadFile(Pipes.g_hChildStd_OUT_Rd, chBuf, BUFSIZE, &dwRead, NULL);
		if (!bSuccess || dwRead == 0 )
			return;

		chBuf[dwRead] = NULL;
		OutputDebugString(chBuf);
	}

	void CreateChildProcess(LPSTR szCmdline, PROCESS_INFORMATION &piProcInfo, TPipes &Pipes, IScriptEnvironment *Env) { 
		STARTUPINFO siStartInfo;
		BOOL bSuccess = FALSE; 

		ZeroMemory(&piProcInfo, sizeof(PROCESS_INFORMATION));
		ZeroMemory(&siStartInfo, sizeof(STARTUPINFO));

		siStartInfo.cb = sizeof(STARTUPINFO); 
		siStartInfo.hStdError = Pipes.g_hChildStd_OUT_Wr;
		siStartInfo.hStdOutput = Pipes.g_hChildStd_OUT_Wr;
		siStartInfo.hStdInput = Pipes.g_hChildStd_IN_Rd;
		siStartInfo.dwFlags |= STARTF_USESTDHANDLES;

		bSuccess = CreateProcess(NULL, 
			szCmdline,     // command line 
			NULL,          // process security attributes 
			NULL,          // primary thread security attributes 
			TRUE,          // handles are inherited 
			0,             // creation flags 
			NULL,          // use parent's environment 
			NULL,          // use parent's current directory 
			&siStartInfo,  // STARTUPINFO pointer 
			&piProcInfo);  // receives PROCESS_INFORMATION 

		if (!bSuccess)
			Env->ThrowError("ENPipe: Process creation failed");
	}

	void CreatePipes(LPSTR szCmdline, PROCESS_INFORMATION &piProcInfo, TPipes &Pipes, IScriptEnvironment *Env) {
		ZeroMemory(&Pipes, sizeof(TPipes));
		SECURITY_ATTRIBUTES saAttr; 

		saAttr.nLength = sizeof(SECURITY_ATTRIBUTES); 
		saAttr.bInheritHandle = TRUE; 
		saAttr.lpSecurityDescriptor = NULL; 

		if (!CreatePipe(&Pipes.g_hChildStd_OUT_Rd, &Pipes.g_hChildStd_OUT_Wr, &saAttr, 0)) 
			Env->ThrowError("ENPipe: StdoutRd CreatePipe"); 

		if (!SetHandleInformation(Pipes.g_hChildStd_OUT_Rd, HANDLE_FLAG_INHERIT, 0))
			Env->ThrowError("ENPipe: Stdout SetHandleInformation"); 

		if (!CreatePipe(&Pipes.g_hChildStd_IN_Rd, &Pipes.g_hChildStd_IN_Wr, &saAttr, 0)) 
			Env->ThrowError("ENPipe: Stdin CreatePipe"); 

		if (!SetHandleInformation(Pipes.g_hChildStd_IN_Wr, HANDLE_FLAG_INHERIT, 0))
			Env->ThrowError("ENPipe: Stdin SetHandleInformation"); 

		CreateChildProcess(szCmdline, piProcInfo, Pipes, Env); 
	}

	void CloseHandles(PROCESS_INFORMATION &PI, TPipes &Pipes) {
		CloseHandle(PI.hProcess);
		CloseHandle(PI.hThread);
		CloseHandle(Pipes.g_hChildStd_IN_Wr);
		CloseHandle(Pipes.g_hChildStd_IN_Rd);
		CloseHandle(Pipes.g_hChildStd_OUT_Wr);
		CloseHandle(Pipes.g_hChildStd_OUT_Rd);
	}

	PROCESS_INFORMATION VideoPI, AudioPI;
	TPipes VideoPipes, AudioPipes;
	bool VideoOpen, AudioOpen;
	int NextFrame;
	__int64 NextSample;
	bool y4m;
	HANDLE WaitObjects[2];
	int NumWaitObjects;

public:
	ENPipe(PClip _child, const char *videocl, const char *audiocl, bool _y4m, int waitms, IScriptEnvironment* env) : GenericVideoFilter(_child) {
		VideoOpen = false;
		AudioOpen = false;
		NextFrame = 0;
		NextSample = 0;
		NumWaitObjects = 0;
		y4m = _y4m;
		
		if (strcmp(videocl, "")) {
			CreatePipes((LPSTR)videocl, VideoPI, VideoPipes, env);
			WaitObjects[NumWaitObjects++] = VideoPI.hProcess;
			VideoOpen = true;

		}

		if (strcmp(audiocl, "")) {
			CreatePipes((LPSTR)audiocl, AudioPI, AudioPipes, env);
			WaitObjects[NumWaitObjects++] = AudioPI.hProcess;
			AudioOpen = true;
		}

		if (WaitForMultipleObjects(NumWaitObjects, WaitObjects, FALSE, waitms) != WAIT_TIMEOUT)
			env->ThrowError("ENPipe: Created processes not ready for input");
	}

	~ENPipe() {
		if (VideoOpen)
			CloseHandles(VideoPI, VideoPipes);
		if (AudioOpen)
			CloseHandles(AudioPI, AudioPipes);
	}

	PVideoFrame __stdcall GetFrame(int n, IScriptEnvironment* env);
	void __stdcall GetAudio(void* buf, __int64 start, __int64 count, IScriptEnvironment* env);
};

PVideoFrame __stdcall ENPipe::GetFrame(int n, IScriptEnvironment* env) {
	PVideoFrame src = child->GetFrame(n, env);
	if (VideoOpen && n == NextFrame) {
		if (y4m && vi.IsYUV()) {
			WriteY4MToPipe(VideoPipes, env);
			y4m = false;
		}
		WriteFrameToPipe(src, VideoPipes, env);
		NextFrame++;
	}
	return src;
}

void __stdcall ENPipe::GetAudio(void* buf, __int64 start, __int64 count, IScriptEnvironment* env) {
	child->GetAudio(buf, start, count, env);
	if (VideoOpen && start == NextSample) {
		WriteAudioToPipe(AudioPipes, buf, count, env);
		NextSample = start + count;
	}
}

static AVSValue __cdecl Create_ENPipe(AVSValue args, void* user_data, IScriptEnvironment* env) {
	return new ENPipe(args[0].AsClip(), args[1].AsString(""), args[2].AsString(""), args[3].AsBool(false), args[4].AsInt(2000), env);
}

extern "C" __declspec(dllexport) const char* __stdcall AvisynthPluginInit2(IScriptEnvironment* env) {
	env->AddFunction("ENPipe", "c[videocl]s[audiocl]s[y4m]b[waitms]i", Create_ENPipe, 0);
	return 0;
};
