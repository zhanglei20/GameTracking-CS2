//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "MBOIT Mixed Resolution Combine";
	DevShader = true;
	Version = 0;
	
	// VcsVersion: 70
	// Platform: VULKAN_SM_50
	// Programs: ps, vs
}

MODES
{
	Default();
	CsgoForward();
	ToolsVis();
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
	float4 vPositionPs : POSITION0  < Semantic( position ); >;                                    
	float4 vTexCoord   : TEXCOORD0  < Semantic( texcoord ); >;                                    
};

VS
{
	
	cbuffer PerViewConstantBuffer_t < Attribute("PerViewConstantBuffer_t"); >;
	float4 g_vlowResTexelSize < Attribute("LowResTexelSize"); UiType(VectorText); >;
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (2568 bytes), HLSL reflection with SPIRV-Cross by KhronosGroup
	
	struct _2032
	{
	    float4 _m0[4];
	};
	
	cbuffer _Globals_ : register(b0, space0)
	{
	    float4 _Globals_1_g_vlowResTexelSize : packoffset(c1);
	};
	
	cbuffer PerViewConstantBuffer_t : register(b1, space0)
	{
	    _2032 PerViewConstantBuffer_t_1_m0 : packoffset(c4);
	    float3 PerViewConstantBuffer_t_1_m1 : packoffset(c26);
	};
	
	
	static float4 gl_Position;
	static float2 vPositionPs;
	static float2 vTexCoord;
	static float2 output_0;
	static float2 output_1;
	static float2 output_2;
	static float2 output_3;
	static float2 output_4;
	static float3 output_5;
	
	struct VS_INPUT
	{
	    float2 vPositionPs : TEXCOORD0;
	    float2 vTexCoord : TEXCOORD1;
	};
	
	struct PS_INPUT
	{
	    float2 output_0 : TEXCOORD0;
	    float2 output_1 : TEXCOORD1;
	    float2 output_2 : TEXCOORD2;
	    float2 output_3 : TEXCOORD3;
	    float2 output_4 : TEXCOORD4;
	    float3 output_5 : TEXCOORD5;
	    float4 gl_Position : SV_Position;
	};
	
	void MainVs_inner()
	{
	    float4 _14513 = float4(vPositionPs, 0.0f, 1.0f);
	    float2 _7669 = vTexCoord - (_Globals_1_g_vlowResTexelSize.xy * 0.5f);
	    float4 _24010 = mul(float4x4(float4(PerViewConstantBuffer_t_1_m0._m0[0].x, PerViewConstantBuffer_t_1_m0._m0[1].x, PerViewConstantBuffer_t_1_m0._m0[2].x, PerViewConstantBuffer_t_1_m0._m0[3].x), float4(PerViewConstantBuffer_t_1_m0._m0[0].y, PerViewConstantBuffer_t_1_m0._m0[1].y, PerViewConstantBuffer_t_1_m0._m0[2].y, PerViewConstantBuffer_t_1_m0._m0[3].y), float4(PerViewConstantBuffer_t_1_m0._m0[0].z, PerViewConstantBuffer_t_1_m0._m0[1].z, PerViewConstantBuffer_t_1_m0._m0[2].z, PerViewConstantBuffer_t_1_m0._m0[3].z), float4(PerViewConstantBuffer_t_1_m0._m0[0].w, PerViewConstantBuffer_t_1_m0._m0[1].w, PerViewConstantBuffer_t_1_m0._m0[2].w, PerViewConstantBuffer_t_1_m0._m0[3].w)), float4((vTexCoord.x * 2.0f) - 1.0f, ((1.0f - vTexCoord.y) * 2.0f) - 1.0f, 1.0f, 1.0f));
	    output_0 = vTexCoord;
	    output_1 = _7669;
	    output_2 = _7669 + float2(_Globals_1_g_vlowResTexelSize.x, 0.0f);
	    output_3 = _7669 + float2(0.0f, _Globals_1_g_vlowResTexelSize.y);
	    output_4 = _7669 + _Globals_1_g_vlowResTexelSize.xy;
	    output_5 = normalize((_24010.xyz / _24010.w.xxx) - PerViewConstantBuffer_t_1_m1.xyz);
	    _14513.y = -vPositionPs.y;
	    gl_Position = _14513;
	}
	
	PS_INPUT MainVs(VS_INPUT stage_input)
	{
	    vPositionPs = stage_input.vPositionPs;
	    vTexCoord = stage_input.vTexCoord;
	    MainVs_inner();
	    PS_INPUT stage_output;
	    stage_output.gl_Position = gl_Position;
	    stage_output.output_0 = output_0;
	    stage_output.output_1 = output_1;
	    stage_output.output_2 = output_2;
	    stage_output.output_3 = output_3;
	    stage_output.output_4 = output_4;
	    stage_output.output_5 = output_5;
	    return stage_output;
	}
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
}

PS
{
	DynamicCombo( D_HI_LOW, 0..1 );
	DynamicCombo( D_LOW_HI, 0..1 );
	DynamicCombo( D_LOW_HI_OUTPUT, 0..1 );
	DynamicCombo( D_UPSCALE_SMOKE_DEPTH, 0..1 );
	DynamicCombo( D_KEEP_FULL_RES, 0..1 );
	DynamicCombo( D_MBOIT_4_MOMENTS, 0..1 );
	DynamicComboRule( Allow1( D_LOW_HI, D_LOW_HI_OUTPUT, D_HI_LOW ) );
	DynamicComboRule( Requires( D_MBOIT_4_MOMENTS, D_HI_LOW, D_LOW_HI ) );
	DynamicComboRule( Requires( D_KEEP_FULL_RES, D_LOW_HI, D_LOW_HI_OUTPUT ) );
	
	cbuffer PerViewConstantBuffer_t < Attribute("PerViewConstantBuffer_t"); >;
	bool g_bDiscardSmokeBehind < Attribute("bDiscardSmokeBehind"); UiType(CheckBox); >;
	bool g_bIgnoreSmokeDepth < Attribute("bIgnoreSmokeDepth"); UiType(CheckBox); >;
	Texture2D g_tMboitOptimDepthHalfTexture < Attribute("SmokeOptimDepthHalfTex"); SrgbRead(false); >;
	Texture2D g_tMboitOptimDepthQuarterTexture < Attribute("SmokeOptimDepthQuarterTex"); SrgbRead(false); >;
	Texture2D g_tMboitOptimDepthTexture < Attribute("SmokeOptimDepthTex"); SrgbRead(false); >;
	Texture2D g_tMoments < Attribute("moments"); SrgbRead(true); >;
	Texture2D g_tMoments_Extra < Attribute("moments_extra"); SrgbRead(true); >;
	Texture2D g_tOutput < Attribute("mboit_output"); SrgbRead(true); >;
	Texture2D g_tSmokeFullResMask < Attribute("SmokeFullResMask"); SrgbRead(false); >;
	Texture2D g_tZeroth_Moment < Attribute("zeroth_moment"); SrgbRead(true); >;
	Texture2D g_thiResDepth < Attribute("hiresdepth"); SrgbRead(false); >;
	Texture2D g_tlowResDepth < Attribute("lowresdepth"); SrgbRead(false); >;
	float4 g_vlowResTexelSize < Attribute("LowResTexelSize"); UiType(VectorText); >;
	
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (1264 bytes), HLSL reflection with SPIRV-Cross by KhronosGroup
	
	cbuffer PerViewConstantBuffer_t : register(b1, space1)
	{
	    float4 PerViewConstantBuffer_t_1_m0 : packoffset(c22);
	};
	
	Texture2D<float4> g_tZeroth_Moment : register(t31, space1);
	SamplerState g_sBilinearClamp : register(s15, space1);
	Texture2D<float4> g_tMoments : register(t32, space1);
	Texture2D<float4> g_tMoments_Extra : register(t33, space1);
	
	static float4 gl_FragCoord;
	static float4 output_0;
	static float4 output_1;
	static float4 output_2;
	
	struct PS_INPUT
	{
	    float4 gl_FragCoord : SV_Position;
	};
	
	struct PS_OUTPUT
	{
	    float4 output_0 : SV_Target0;
	    float4 output_1 : SV_Target1;
	    float4 output_2 : SV_Target2;
	};
	
	void MainPs_inner()
	{
	    float2 _13326 = (gl_FragCoord.xy * PerViewConstantBuffer_t_1_m0.xy).xy;
	    output_0 = g_tZeroth_Moment.SampleLevel(g_sBilinearClamp, _13326, 0.0f);
	    output_1 = g_tMoments.SampleLevel(g_sBilinearClamp, _13326, 0.0f);
	    output_2 = g_tMoments_Extra.SampleLevel(g_sBilinearClamp, _13326, 0.0f);
	}
	
	PS_OUTPUT MainPs(PS_INPUT stage_input)
	{
	    gl_FragCoord = stage_input.gl_FragCoord;
	    gl_FragCoord.w = 1.0 / gl_FragCoord.w;
	    MainPs_inner();
	    PS_OUTPUT stage_output;
	    stage_output.output_0 = output_0;
	    stage_output.output_1 = output_1;
	    stage_output.output_2 = output_2;
	    return stage_output;
	}
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
}
