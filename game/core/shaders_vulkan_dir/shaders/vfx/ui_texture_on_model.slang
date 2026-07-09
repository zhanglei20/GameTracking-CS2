//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "Tools Generic";
	DevShader = true;
	Version = 0;
	
	// VcsVersion: 71
	// Platform: VULKAN_SM_50
	// Programs: ps, vs
}

MODES
{
	ToolsUtil();
	Default();
}

FEATURES
{
	Feature( F_TRANSLUCENT, 0..1, "Translucent" );
	Feature( F_ADDITIVE_BLEND, 0..1, "Translucent" );
	Feature( F_DISABLE_DEPTH_TEST, 0..1, "Z-Buffering" );
	FeatureRule( Requires( F_ADDITIVE_BLEND, F_TRANSLUCENT ), "Requires translucency" );
}

COMMON
{
	#include "system.fxc"
}

struct VS_INPUT
{
	float4 vBlendIndices : BLENDINDICES0  < Semantic( BlendIndices ); >;                           // D_BLEND_WEIGHT_COUNT=1, D_BLEND_WEIGHT_COUNT=2, D_BLEND_WEIGHT_COUNT=3, D_BLEND_WEIGHT_COUNT=4
	float4 vBlendWeight  : BLENDWEIGHT0   < Semantic( BlendWeight ); >;                            // D_BLEND_WEIGHT_COUNT=2, D_BLEND_WEIGHT_COUNT=3, D_BLEND_WEIGHT_COUNT=4
	float4 vNormalOs     : NORMAL0        < Semantic( Normal ); >;                                
	float3 vPositionOs   : POSITION0      < Semantic( PosXyz ); >;                                
	float2 vTexCoord     : TEXCOORD0      < Semantic( LowPrecisionUv ); >;                        
	float2 nInstanceIdx  : TEXCOORD13     < Semantic( InstanceTransformUv ); >;                   
};

VS
{
	StaticCombo( S_TRANSLUCENT, F_TRANSLUCENT );
	DynamicCombo( D_BLEND_WEIGHT_COUNT, 0..4 );
	
	cbuffer PerViewConstantBuffer_t < Attribute("PerViewConstantBuffer_t"); >;
	StructuredBuffer g_instanceBuffer < Attribute("InstanceBuffer"); >;
	StructuredBuffer g_transformBuffer < Attribute("TransformBuffer"); >;
	
	// Color
	float2 g_vTexCoordScale < Default2(1, 1); Range2(0, 0, 8, 8); UiType(VectorText); UiGroup("Color/30"); >;
	float2 g_vTexCoordOffset < Range2(-1, -1, 1, 1); UiType(VectorText); UiGroup("Color/40"); >;
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (2688 bytes), HLSL reflection with SPIRV-Cross by KhronosGroup
	
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
	
	struct _1119
	{
	    float3x4 _m0;
	};
	
	struct _1126
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
	
	struct _1120
	{
	    row_major float3x4 _m0;
	};
	
	ByteAddressBuffer g_instanceBuffer : register(t32, space0);
	ByteAddressBuffer g_transformBuffer : register(t30, space0);
	cbuffer PerViewConstantBuffer_t : register(b1, space0)
	{
	    column_major float4x4 PerViewConstantBuffer_t_1_m0 : packoffset(c0);
	    float4 PerViewConstantBuffer_t_1_m1 : packoffset(c24);
	};
	
	cbuffer _Globals_ : register(b0, space0)
	{
	    float2 _Globals_1_g_vTexCoordScale : packoffset(c0);
	    float2 _Globals_1_g_vTexCoordOffset : packoffset(c0.z);
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
	    _1126 _24007;
	    _24007._m0 = g_instanceBuffer.Load(nInstanceIdx * 32 + 0);
	    _24007._m1 = g_instanceBuffer.Load(nInstanceIdx * 32 + 4);
	    _24007._m2 = g_instanceBuffer.Load(nInstanceIdx * 32 + 8);
	    _24007._m3 = g_instanceBuffer.Load(nInstanceIdx * 32 + 12);
	    _24007._m4 = g_instanceBuffer.Load(nInstanceIdx * 32 + 16);
	    _24007._m5 = g_instanceBuffer.Load(nInstanceIdx * 32 + 20);
	    _24007._m6 = g_instanceBuffer.Load(nInstanceIdx * 32 + 24);
	    _24007._m7 = asfloat(g_instanceBuffer.Load(nInstanceIdx * 32 + 28));
	    _1125 _19924;
	    _19924._m0 = _24007._m0;
	    _19924._m1 = _24007._m1;
	    _19924._m2 = _24007._m2;
	    _19924._m3 = _24007._m3;
	    _19924._m4 = _24007._m4;
	    _19924._m5 = _24007._m5;
	    _19924._m6 = _24007._m6;
	    _19924._m7 = _24007._m7;
	    _1120 _8152;
	    _8152._m0 = asfloat(uint3x4(g_transformBuffer.Load4(_19924._m1 * 48 + 0), g_transformBuffer.Load4(_19924._m1 * 48 + 16), g_transformBuffer.Load4(_19924._m1 * 48 + 32)));
	    _1119 _19848;
	    _19848._m0 = _8152._m0;
	    float4 _17895 = mul(PerViewConstantBuffer_t_1_m0, (float4(mul(_19848._m0, float4(vPositionOs.xyz, 1.0f)).xyz, 1.0f) + (PerViewConstantBuffer_t_1_m1 * 1.0f)).xyzw);
	    output_0 = normalize(mul(_19848._m0, float4(vTexCoord.xyz, 0.0f)));
	    output_1 = (vNormalOs.xy * _Globals_1_g_vTexCoordScale.xy) + _Globals_1_g_vTexCoordOffset.xy;
	    _17895.y = -_17895.y;
	    gl_Position = _17895;
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
	
	RenderState(BlendEnable, True);
	RenderState(DepthFunc, F_DISABLE_DEPTH_TEST ? Always : Less);
	RenderState(DepthWriteEnable, False);
	RenderState(DstBlend, F_ADDITIVE_BLEND ? One : InvSrcAlpha);
	Texture2D g_tCodeSuppliedColor < Attribute("UITextureOnModel"); SrgbRead(true); >;
	
	// Translucent
	float g_flOpacityScale < Default(1); UiType(Slider); UiGroup("Translucent"); >;
	
	// Color
	float3 g_vColorTint < Default3(1, 1, 1); UiType(Color); UiGroup("Color,10/20"); >;
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (1012 bytes), HLSL reflection with SPIRV-Cross by KhronosGroup
	
	cbuffer _Globals_ : register(b0, space1)
	{
	    float3 _Globals_1_g_vColorTint : packoffset(c0);
	};
	
	Texture2D<float4> g_tCodeSuppliedColor : register(t30, space1);
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
	    output_0 = float4(g_tCodeSuppliedColor.Sample(Filter_MinMagMipLinear, input_0.xy).xyz * _Globals_1_g_vColorTint.xyz, 1.0f);
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
