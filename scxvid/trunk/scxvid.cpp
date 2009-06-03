#include <stdio.h>
#include <windows.h>
#include "xvid.h"
#include "avisynth.h"

#define SCXVID_BUFFER_SIZE (1024*1024*4)

class SCXvid : public GenericVideoFilter {
private:
	void *xvid_handle;
	xvid_enc_frame_t xvid_enc_frame;
	void *output_buffer;
	int next_frame;
	xvid_enc_create_t xvid_enc_create;
	xvid_gbl_init_t xvid_init;
public:
	SCXvid(PClip _child, const char *log, IScriptEnvironment* env) : GenericVideoFilter(_child) {
		output_buffer = NULL;;
		next_frame = 0;
		int error = 0;


		memset(&xvid_init, 0, sizeof(xvid_init));
		xvid_init.version = XVID_VERSION;
		xvid_init.debug = ~0;
		error = xvid_global(NULL, XVID_GBL_INIT, &xvid_init, NULL);
		if (error)
			env->ThrowError("SCXvid: Failed initialize Xvid");


		memset(&xvid_enc_create, 0, sizeof(xvid_enc_create));
		xvid_enc_create.version = XVID_VERSION;
		xvid_enc_create.profile = 0;
		xvid_enc_create.width = vi.width;
		xvid_enc_create.height = vi.height;
		xvid_enc_create.num_threads = 0; //user configurable?
		xvid_enc_create.fincr = vi.fps_numerator;
		xvid_enc_create.fbase = vi.fps_denominator;
		xvid_enc_create.max_key_interval = 10000000; //huge number
		xvid_enc_plugin_t plugins[1];
		xvid_plugin_2pass1_t xvid_rc_plugin;
		memset(&xvid_rc_plugin, 0, sizeof(xvid_rc_plugin));
		xvid_rc_plugin.version = XVID_VERSION;
		xvid_rc_plugin.filename = env->SaveString(log);
		plugins[0].func = xvid_plugin_2pass1;
		plugins[0].param = &xvid_rc_plugin;
		xvid_enc_create.plugins = plugins;
		xvid_enc_create.num_plugins = 1;

		error = xvid_encore(NULL, XVID_ENC_CREATE, &xvid_enc_create, NULL);
		if (error)
			env->ThrowError("SCXvid: Failed initialize Xvid encoder");
		xvid_handle = xvid_enc_create.handle;

		//default identical(?) to xvid 1.1.2 vfw general preset
		memset(&xvid_enc_frame, 0, sizeof(xvid_enc_frame));
		xvid_enc_frame.version = XVID_VERSION;
		xvid_enc_frame.vol_flags = 0;
		xvid_enc_frame.vop_flags = XVID_VOP_MODEDECISION_RD | XVID_VOP_HALFPEL |
				XVID_VOP_HQACPRED | XVID_VOP_TRELLISQUANT | XVID_VOP_INTER4V;
				
		xvid_enc_frame.motion = XVID_ME_CHROMA_PVOP | XVID_ME_CHROMA_BVOP |
			XVID_ME_HALFPELREFINE16 | XVID_ME_EXTSEARCH16 |
			XVID_ME_HALFPELREFINE8 | 0 | XVID_ME_USESQUARES16;

		xvid_enc_frame.type = XVID_TYPE_AUTO;
		xvid_enc_frame.quant = 0;

		if (vi.IsYV12())
			xvid_enc_frame.input.csp = XVID_CSP_YV12;
		else if (vi.IsYUY2())
			xvid_enc_frame.input.csp = XVID_CSP_YUY2;
		else if (vi.IsRGB32())
			xvid_enc_frame.input.csp = XVID_CSP_BGRA;
		else if (vi.IsRGB24())
			xvid_enc_frame.input.csp = XVID_CSP_BGR;
		else 
			env->ThrowError("SCXvid: Unknown Colorspace");

		if (!(output_buffer = malloc(SCXVID_BUFFER_SIZE)))
			env->ThrowError("SCXvid: Failed to allocate buffer");
	}

	~SCXvid() {
		free(output_buffer);
		xvid_encore(xvid_handle, XVID_ENC_DESTROY, NULL, NULL);
	}

    PVideoFrame __stdcall GetFrame(int n, IScriptEnvironment* env);
};

PVideoFrame __stdcall SCXvid::GetFrame(int n, IScriptEnvironment* env) {
	PVideoFrame src = child->GetFrame(n, env);

	if (next_frame == n) {
		if (xvid_enc_frame.input.csp == XVID_CSP_YV12) {
			xvid_enc_frame.input.plane[0] = (void *)src->GetReadPtr(PLANAR_Y);
			xvid_enc_frame.input.stride[0] = src->GetPitch(PLANAR_Y);
			xvid_enc_frame.input.plane[1] = (void *)src->GetReadPtr(PLANAR_U);
			xvid_enc_frame.input.stride[1] = src->GetPitch(PLANAR_U);
			xvid_enc_frame.input.plane[2] = (void *)src->GetReadPtr(PLANAR_V);
			xvid_enc_frame.input.stride[2] = src->GetPitch(PLANAR_V);
		} else	{
			xvid_enc_frame.input.plane[0] = (void *)src->GetReadPtr();
			xvid_enc_frame.input.stride[0] = src->GetPitch();
		}

		xvid_enc_frame.length = SCXVID_BUFFER_SIZE;
		xvid_enc_frame.bitstream = output_buffer;

		xvid_enc_stats_t stats;
		stats.version = XVID_VERSION;

		int error = xvid_encore(xvid_handle, XVID_ENC_ENCODE, &xvid_enc_frame, &stats);
		if (error < 0)
			env->ThrowError("SCXvid: xvid_encore returned an error code");
		next_frame++;
	}
	return src;
}

AVSValue __cdecl Create_SCXvid(AVSValue args, void* user_data, IScriptEnvironment* env) {
	if (!args[1].Defined())
		env->ThrowError("SCXvid: Log filename must be specified");
	return new SCXvid(args[0].AsClip(), args[1].AsString(), env);
}

extern "C" __declspec(dllexport) const char* __stdcall AvisynthPluginInit2(IScriptEnvironment* env) {
    env->AddFunction("SCXvid", "c[log]s", Create_SCXvid, 0);
    return 0;
};

