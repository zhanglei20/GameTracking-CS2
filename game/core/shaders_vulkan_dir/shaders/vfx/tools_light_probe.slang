//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "Shader used in tools to render the reflection from an environment map. Meant to look like Paul Debevec's light probes. See www.debevec.org/probes";
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
}

COMMON
{
	#include "system.fxc"
}

struct VS_INPUT
{
	float4 vNormalWs   : NORMAL0    < Semantic( Normal ); >;                                      
	float3 vPositionWs : POSITION0  < Semantic( PosXyz ); >;                                      
};

VS
{
	
	cbuffer PerViewConstantBuffer_t < Attribute("PerViewConstantBuffer_t"); >;
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (1716 bytes), HLSL reflection with SPIRV-Cross by KhronosGroup
	
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
	static float4 vPositionWs;
	static float4 vNormalWs;
	static float3 output_0;
	static float3 output_1;
	
	struct VS_INPUT
	{
	    float4 vPositionWs : TEXCOORD0;
	    float4 vNormalWs : TEXCOORD1;
	};
	
	struct PS_INPUT
	{
	    float3 output_0 : TEXCOORD0;
	    float3 output_1 : TEXCOORD1;
	    float4 gl_Position : SV_Position;
	};
	
	void MainVs_inner()
	{
	    float4 _8264 = mul(float4x4(float4(_Globals_1_m0._m0[0].x, _Globals_1_m0._m0[1].x, _Globals_1_m0._m0[2].x, _Globals_1_m0._m0[3].x), float4(_Globals_1_m0._m0[0].y, _Globals_1_m0._m0[1].y, _Globals_1_m0._m0[2].y, _Globals_1_m0._m0[3].y), float4(_Globals_1_m0._m0[0].z, _Globals_1_m0._m0[1].z, _Globals_1_m0._m0[2].z, _Globals_1_m0._m0[3].z), float4(_Globals_1_m0._m0[0].w, _Globals_1_m0._m0[1].w, _Globals_1_m0._m0[2].w, _Globals_1_m0._m0[3].w)), (float4(vPositionWs.xyz, 1.0f) + (_Globals_1_m1 * 1.0f)).xyzw);
	    output_0 = vPositionWs.xyz;
	    output_1 = vNormalWs.xyz;
	    _8264.y = -_8264.y;
	    gl_Position = _8264;
	}
	
	PS_INPUT MainVs(VS_INPUT stage_input)
	{
	    vPositionWs = stage_input.vPositionWs;
	    vNormalWs = stage_input.vNormalWs;
	    MainVs_inner();
	    PS_INPUT stage_output;
	    stage_output.gl_Position = gl_Position;
	    stage_output.output_0 = output_0;
	    stage_output.output_1 = output_1;
	    return stage_output;
	}
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
}

PS
{
	
	cbuffer PerViewConstantBuffer_t < Attribute("PerViewConstantBuffer_t"); >;
	Texture2D g_tSkyRadiance < Attribute("CustomTexture0"); SrgbRead(false); >;
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (1452 bytes), HLSL reflection with SPIRV-Cross by KhronosGroup
	
	cbuffer _Globals_ : register(b0, space1)
	{
	    float3 _Globals_1_m0 : packoffset(c26);
	};
	
	SamplerState AddressU_Wrap_AddressV_Clamp_Filter_MinMagMipLinear : register(s14, space1);
	Texture2D<float4> g_tSkyRadiance : register(t30, space1);
	
	static float3 input_0;
	static float3 input_1;
	static float4 output_0;
	
	struct PS_INPUT
	{
	    float3 input_1 : TEXCOORD0;
	    float3 input_0 : TEXCOORD1;
	};
	
	struct PS_OUTPUT
	{
	    float4 output_0 : SV_Target0;
	};
	
	void MainPs_inner()
	{
	    float3 _19258 = normalize(reflect(input_1.xyz - _Globals_1_m0.xyz, normalize(input_0)));
	    float _7511 = acos(_19258.z) * 0.3183098733425140380859375f;
	    float2 _16582 = _19258.xy;
	    output_0 = g_tSkyRadiance.SampleGrad(AddressU_Wrap_AddressV_Clamp_Filter_MinMagMipLinear, float2(atan2(_19258.y, _19258.x) * 0.15915493667125701904296875f, _7511), float2(length(ddx(_16582)) * 0.15915493667125701904296875f, ddx(_7511)), float2(length(ddy(_16582)) * 0.15915493667125701904296875f, ddy(_7511)));
	}
	
	PS_OUTPUT MainPs(PS_INPUT stage_input)
	{
	    input_0 = stage_input.input_0;
	    input_1 = stage_input.input_1;
	    MainPs_inner();
	    PS_OUTPUT stage_output;
	    stage_output.output_0 = output_0;
	    return stage_output;
	}
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
}
