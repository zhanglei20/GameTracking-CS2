//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "Unlit Textured";
	DevShader = true;
	Version = 0;
	
	// VcsVersion: 70
	// Platform: VULKAN_SM_40
	// Programs: ps, vs
}

MODES
{
	ToolsUtil();
}

FEATURES
{
	Feature( F_TRANSLUCENT, 0..1, "Translucent" );
}

COMMON
{
	#include "system.fxc"
}

struct VS_INPUT
{
	float4 vNormalOs    : NORMAL0    < Semantic( Normal ); >;                                     
	float3 vPositionOs  : POSITION0  < Semantic( PosXyz ); >;                                     
	float2 vTexCoord    : TEXCOORD0  < Semantic( LowPrecisionUv ); >;                             
	float2 nInstanceIdx : TEXCOORD13 < Semantic( InstanceTransformUv ); >;                        
};

VS
{
	StaticCombo( S_TRANSLUCENT, F_TRANSLUCENT );
	DynamicCombo( D_BLEND_WEIGHT_COUNT, 0..4 );
	DynamicComboRule( Allow0( D_BLEND_WEIGHT_COUNT ) );
	
	cbuffer PerViewConstantBuffer_t < Attribute("PerViewConstantBuffer_t"); >;
	StructuredBuffer g_instanceBuffer < Attribute("InstanceBuffer"); SrgbRead(false); >;
	StructuredBuffer g_transformBuffer < Attribute("TransformBuffer"); SrgbRead(false); >;
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (3008 bytes), HLSL reflection with SPIRV-Cross by KhronosGroup
	
	struct _1125
	{
	    uint _m0;
	    uint _m1;
	    uint _m2;
	    uint _m3;
	    uint _m4;
	    uint _m5;
	    uint _m6;
	    float _m7;
	};
	
	struct _1108
	{
	    float4 _m0[3];
	};
	
	struct _164
	{
	    _1108 _m0;
	};
	
	struct _1234
	{
	    float4 _m0[4];
	};
	
	ByteAddressBuffer g_instanceBuffer : register(t32, space0);
	ByteAddressBuffer g_transformBuffer : register(t30, space0);
	cbuffer _Globals_ : register(b0, space0)
	{
	    _1234 _Globals_1_m0 : packoffset(c0);
	    float4 _Globals_1_m1 : packoffset(c24);
	};
	
	
	static float4 gl_Position;
	static float3 vPositionOs;
	static float3 vTexCoord;
	static float2 vNormalOs;
	static uint nInstanceIdx;
	static float3 output_0;
	static float2 output_1;
	
	struct VS_INPUT
	{
	    float3 vPositionOs : TEXCOORD0;
	    float3 vTexCoord : TEXCOORD1;
	    float2 vNormalOs : TEXCOORD2;
	    uint nInstanceIdx : TEXCOORD3;
	};
	
	struct PS_INPUT
	{
	    float3 output_0 : TEXCOORD0;
	    float2 output_1 : TEXCOORD1;
	    float4 gl_Position : SV_Position;
	};
	
	void MainVs_inner()
	{
	    _1108 _25207;
	    [unroll]
	    for (int _1ident = 0; _1ident < 3; _1ident++)
	    {
	        _25207._m0[_1ident] = asfloat(g_transformBuffer.Load4(_1ident * 16 + g_instanceBuffer.Load(nInstanceIdx * 32 + 4) * 48 + 0));
	    }
	    float3x4 _14779 = float3x4(_25207._m0[0], _25207._m0[1], _25207._m0[2]);
	    float4 _23533 = mul(float4x4(float4(_Globals_1_m0._m0[0].x, _Globals_1_m0._m0[1].x, _Globals_1_m0._m0[2].x, _Globals_1_m0._m0[3].x), float4(_Globals_1_m0._m0[0].y, _Globals_1_m0._m0[1].y, _Globals_1_m0._m0[2].y, _Globals_1_m0._m0[3].y), float4(_Globals_1_m0._m0[0].z, _Globals_1_m0._m0[1].z, _Globals_1_m0._m0[2].z, _Globals_1_m0._m0[3].z), float4(_Globals_1_m0._m0[0].w, _Globals_1_m0._m0[1].w, _Globals_1_m0._m0[2].w, _Globals_1_m0._m0[3].w)), (float4(mul(_14779, float4(vPositionOs.xyz, 1.0f)).xyz, 1.0f) + (_Globals_1_m1 * 1.0f)).xyzw);
	    output_0 = normalize(mul(_14779, float4(vTexCoord.xyz, 0.0f)));
	    output_1 = vNormalOs;
	    _23533.y = -_23533.y;
	    gl_Position = _23533;
	}
	
	PS_INPUT MainVs(VS_INPUT stage_input)
	{
	    vPositionOs = stage_input.vPositionOs;
	    vTexCoord = stage_input.vTexCoord;
	    vNormalOs = stage_input.vNormalOs;
	    nInstanceIdx = stage_input.nInstanceIdx;
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
	StaticCombo( S_TRANSLUCENT, F_TRANSLUCENT );
	
	RenderState(StencilRef, 1);
	Texture2D g_tColor < Attribute("ColorTexture"); SrgbRead(false); >;
	
	// Translucent
	float g_flOpacityScale < Default(1); UiType(Slider); UiGroup("Translucent"); >;
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (716 bytes), HLSL reflection with SPIRV-Cross by KhronosGroup
	
	Texture2D<float4> g_tColor : register(t30, space1);
	SamplerState Filter_MinMagMipLinear : register(s14, space1);
	
	static float2 input_0;
	static float4 output_0;
	
	struct PS_INPUT
	{
	    float2 input_0 : TEXCOORD1;
	};
	
	struct PS_OUTPUT
	{
	    float4 output_0 : SV_Target0;
	};
	
	void MainPs_inner()
	{
	    output_0 = float4(g_tColor.Sample(Filter_MinMagMipLinear, input_0.xy).xyz, 1.0f);
	}
	
	PS_OUTPUT MainPs(PS_INPUT stage_input)
	{
	    input_0 = stage_input.input_0;
	    MainPs_inner();
	    PS_OUTPUT stage_output;
	    stage_output.output_0 = output_0;
	    return stage_output;
	}
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
	#if (S_TRANSLUCENT == 1)
		BoolAttribute(translucent, true);
	#endif
}
