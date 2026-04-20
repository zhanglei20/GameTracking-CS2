//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "Shader used by occlusion query proxy rendering";
	DevShader = true;
	Version = 0;
	
	// VcsVersion: 70
	// Platform: VULKAN_SM_40
	// Programs: ps, vs
}

MODES
{
	Default();
}

FEATURES
{
	Feature( F_DEPTH_TEST, 0..1, "" );
	Feature( F_DEBUG_DRAW_OCCLUDER, 0..1, "" );
}

COMMON
{
	#include "system.fxc"
}

struct VS_INPUT
{
	float3 m_vPositionWs : POSITION0  < Semantic( PosXyz ); >;                                    
};

VS
{
	
	cbuffer PerViewConstantBuffer_t < Attribute("PerViewConstantBuffer_t"); >;
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (1488 bytes), HLSL reflection with SPIRV-Cross by KhronosGroup
	
	struct _436
	{
	    float4 _m0[4];
	};
	
	cbuffer _Globals_ : register(b0, space0)
	{
	    _436 _Globals_1_m0 : packoffset(c0);
	    float4 _Globals_1_m1 : packoffset(c24);
	};
	
	
	static float4 gl_Position;
	static float3 m_vPositionWs;
	
	struct VS_INPUT
	{
	    float3 m_vPositionWs : TEXCOORD0;
	};
	
	struct PS_INPUT
	{
	    float4 gl_Position : SV_Position;
	};
	
	void MainVs_inner()
	{
	    float4 _24787 = mul(float4x4(float4(_Globals_1_m0._m0[0].x, _Globals_1_m0._m0[1].x, _Globals_1_m0._m0[2].x, _Globals_1_m0._m0[3].x), float4(_Globals_1_m0._m0[0].y, _Globals_1_m0._m0[1].y, _Globals_1_m0._m0[2].y, _Globals_1_m0._m0[3].y), float4(_Globals_1_m0._m0[0].z, _Globals_1_m0._m0[1].z, _Globals_1_m0._m0[2].z, _Globals_1_m0._m0[3].z), float4(_Globals_1_m0._m0[0].w, _Globals_1_m0._m0[1].w, _Globals_1_m0._m0[2].w, _Globals_1_m0._m0[3].w)), (float4(m_vPositionWs.xyz, 1.0f) + (_Globals_1_m1 * 1.0f)).xyzw);
	    _24787.y = -_24787.y;
	    gl_Position = _24787;
	}
	
	PS_INPUT MainVs(VS_INPUT stage_input)
	{
	    m_vPositionWs = stage_input.m_vPositionWs;
	    MainVs_inner();
	    PS_INPUT stage_output;
	    stage_output.gl_Position = gl_Position;
	    return stage_output;
	}
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
}

PS
{
	StaticCombo( S_DEPTH_TEST, F_DEPTH_TEST );
	StaticCombo( S_DEBUG_DRAW_OCCLUDER, F_DEBUG_DRAW_OCCLUDER );
	StaticCombo( S_REVERSE_DEPTH_BUFFER, 0..1 );
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (280 bytes), HLSL reflection with SPIRV-Cross by KhronosGroup
	
	static float4 output_0;
	
	struct PS_OUTPUT
	{
	    float4 output_0 : SV_Target0;
	};
	
	void MainPs_inner()
	{
	    output_0 = float4(1.0f, 0.0f, 0.0f, 1.0f);
	}
	
	PS_OUTPUT MainPs()
	{
	    MainPs_inner();
	    PS_OUTPUT stage_output;
	    stage_output.output_0 = output_0;
	    return stage_output;
	}
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
}
