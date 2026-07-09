//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "Depth Only - Used as a Mode Fallback";
	DevShader = true;
	Version = 0;
	
	// VcsVersion: 71
	// Platform: VULKAN_SM_50
	// Programs: ps, vs
}

MODES
{
	Depth(S_MODE_DEPTH);
}

FEATURES
{
	Feature( F_ALPHA_TEST, 0..1, "Translucent" );
	Feature( F_TRANSLUCENT, 0..1, "Translucent" );
	Feature( F_RENDER_BACKFACES, 0..1, "2-Sided Rendering" );
	Feature( F_FOLIAGE_ANIMATION, 0..1, "Foliage Animation" );
	Feature( F_MORPH_SUPPORTED, 0..1, "Morph" );
	FeatureRule( Allow1( F_TRANSLUCENT, F_ALPHA_TEST ), "Translucent and Alpha Test are not compatible" );
}

COMMON
{
	#include "system.fxc"
}

struct VS_INPUT
{
	uint4  nPackedFrame       : NORMAL0        < Semantic( CompressedTangentFrame ); >;           
	float4 vNormalOs          : NORMAL0        < Semantic( Normal ); >;                           
	uint4  nVertexIndex       : TEXCOORD14     < Semantic( MorphIndex ); >;                       
	float4 vBlendIndices      : BLENDINDICES0  < Semantic( BlendIndices ); >;                      // D_BLEND_WEIGHT_COUNT=4
	float4 vFoliageAnimParams : TEXCOORD1      < Semantic( VertexPaintBlendParams ); >;            // S_FOLIAGE_ANIMATION=1
	float2 vTextureCoords     : TEXCOORD0      < Semantic( LowPrecisionUv ); >;                    // S_ALPHA_TEST=1, S_TRANSLUCENT=1
	float4 vBlendWeight       : BLENDWEIGHT0   < Semantic( BlendWeight ); >;                       // D_BLEND_WEIGHT_COUNT=4
	float3 vPositionOs        : POSITION0      < Semantic( PosXyz ); >;                           
	float2 nInstanceIdx       : TEXCOORD13     < Semantic( InstanceTransformUv ); >;              
};

VS
{
	StaticCombo( S_MODE_DEPTH, 0..1 );
	StaticCombo( S_ALPHA_TEST, F_ALPHA_TEST );
	StaticCombo( S_TRANSLUCENT, F_TRANSLUCENT );
	StaticCombo( S_FOLIAGE_ANIMATION, F_FOLIAGE_ANIMATION );
	StaticCombo( S_MORPH_SUPPORTED, F_MORPH_SUPPORTED );
	StaticComboRule( Allow1( S_TRANSLUCENT, S_ALPHA_TEST ) );
	DynamicCombo( D_BLEND_WEIGHT_COUNT, 0..4 );
	DynamicCombo( D_COMPRESSED_NORMALS_AND_TANGENTS, 0..1 );
	DynamicCombo( D_MORPH, 0..1 );
	DynamicCombo( D_FREEFORM_DEFORMATION, 0..1 );
	DynamicComboRule( Requires( D_MORPH, S_MORPH_SUPPORTED ) );
	DynamicComboRule( Allow1( D_FREEFORM_DEFORMATION, D_BLEND_WEIGHT_COUNT ) );
	
	cbuffer FFDTransforms_t < Attribute("FFDTransforms_t"); >;
	cbuffer PerViewConstantBuffer_t < Attribute("PerViewConstantBuffer_t"); >;
	StructuredBuffer g_instanceBuffer < Attribute("InstanceBuffer"); >;
	Texture2D g_tCompositeMorphTextureAtlas < Attribute("CompositeMorphTextureAtlas"); SrgbRead(false); >;
	StructuredBuffer g_transformBuffer < Attribute("TransformBuffer"); >;
	
	// Foliage Animation
	float g_flBendScale < Default(0.1); UiType(Slider); UiGroup("Foliage Animation"); >;
	float g_flBranchAmp < Default(1); Range(0, 5); UiType(Slider); UiGroup("Foliage Animation"); >;
	float g_flBranchFrequency < Default(1); Range(0, 5); UiType(Slider); UiGroup("Foliage Animation"); >;
	float g_flDetailAmp < Default(1); Range(0, 5); UiType(Slider); UiGroup("Foliage Animation"); >;
	float g_flDetailFrequency < Default(1); Range(0, 5); UiType(Slider); UiGroup("Foliage Animation"); >;
	float g_flWindAngle < Range(0, 7); UiType(Slider); UiGroup("Foliage Animation"); >;
	float g_flWindSpeed < Default(1); Range(0, 5); UiType(Slider); UiGroup("Foliage Animation"); >;
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (2204 bytes), HLSL reflection with SPIRV-Cross by KhronosGroup
	
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
	    float4 PerViewConstantBuffer_t_1_m1 : packoffset(c17);
	    float4 PerViewConstantBuffer_t_1_m2 : packoffset(c24);
	};
	
	
	static float4 gl_Position;
	static float gl_ClipDistance[1];
	static float3 vPositionOs;
	static uint nInstanceIdx;
	
	struct VS_INPUT
	{
	    float3 vPositionOs : TEXCOORD0;
	    uint nInstanceIdx : TEXCOORD3;
	};
	
	struct PS_INPUT
	{
	    float4 gl_Position : SV_Position;
	    float gl_ClipDistance0 : SV_ClipDistance0;
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
	    float3 _19498 = mul(_19848._m0, float4(vPositionOs.xyz, 1.0f));
	    float4 _19149 = mul(PerViewConstantBuffer_t_1_m0, (float4(_19498.xyz, 1.0f) + (PerViewConstantBuffer_t_1_m2 * 1.0f)).xyzw);
	    _19149.y = -_19149.y;
	    gl_Position = _19149;
	    gl_ClipDistance[0] = dot(float4(_19498, 1.0f), PerViewConstantBuffer_t_1_m1);
	}
	
	PS_INPUT MainVs(VS_INPUT stage_input)
	{
	    vPositionOs = stage_input.vPositionOs;
	    nInstanceIdx = stage_input.nInstanceIdx;
	    MainVs_inner();
	    PS_INPUT stage_output;
	    stage_output.gl_Position = gl_Position;
	    stage_output.gl_ClipDistance0.x = gl_ClipDistance[0];
	    return stage_output;
	}
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
	#if (S_ALPHA_TEST == 0)
		IntAttribute(DepthPassBatchID, 1);
	#endif
	#if (S_TRANSLUCENT == 0)
		IntAttribute(DepthPassBatchID, 1);
	#endif
	#if (S_MORPH_SUPPORTED == 0)
		IntAttribute(DepthPassBatchID, 1);
	#endif
}

PS
{
	StaticCombo( S_MODE_DEPTH, 0..1 );
	StaticCombo( S_ALPHA_TEST, F_ALPHA_TEST );
	StaticCombo( S_TRANSLUCENT, F_TRANSLUCENT );
	StaticComboRule( Allow1( S_TRANSLUCENT, S_ALPHA_TEST ) );
	DynamicCombo( D_WRITE_DEPTH_TO_COLOR, 0..1 );
	DynamicCombo( D_SHADOW_PASS, 0..1 );
	DynamicCombo( D_DISABLE_TRANSLUCENT_CLIP, 0..1 );
	DynamicComboRule( Requires( D_DISABLE_TRANSLUCENT_CLIP, S_TRANSLUCENT ) );
	
	RenderState(CullMode, F_RENDER_BACKFACES ? None : ((exists(ATTRIBUTE[d9386527]) ? None : ATTRIBUTE[d9386527]) ? Front : Back));
	RenderState(DepthBias, DepthBias);
	cbuffer PerViewConstantBuffer_t < Attribute("PerViewConstantBuffer_t"); >;
	RenderState(SlopeScaleDepthBias, SlopeScaleDepthBias);
	Texture2D g_tColor < Channel(RGB, AlphaWeighted(TextureColor, TextureTranslucency), Srgb); Channel(A, PreserveCoverage(TextureTranslucency), Linear); OutputFormat(DXT5); SrgbRead(true); >;
	
	// Color
	CreateInputTexture2D(TextureColor, Srgb, 8, "", "_color", "Color", Default4(1, 1, 1, 0));
	
	// Translucent
	CreateInputTexture2D(TextureTranslucency, Linear, 8, "", "_trans", "Translucent", Default4(1, 1, 1, 0));
	float g_flAlphaTestReference < Default(0.7); Range(0.01, 0.99); UiType(Slider); UiGroup("Translucent"); >;
	float g_flOpacityScale < Default(1); UiType(Slider); UiGroup("Translucent"); >;
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (280 bytes), HLSL reflection with SPIRV-Cross by KhronosGroup
	
	static float4 output_0;
	
	struct PS_OUTPUT
	{
	    float4 output_0 : SV_Target0;
	};
	
	void MainPs_inner()
	{
	    output_0 = float4(0.0f, 0.0f, 0.0f, 1.0f);
	}
	
	PS_OUTPUT MainPs()
	{
	    MainPs_inner();
	    PS_OUTPUT stage_output;
	    stage_output.output_0 = output_0;
	    return stage_output;
	}
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
	#if (S_ALPHA_TEST == 0)
		BoolAttribute(translucent, true);
	#endif
	#if (S_ALPHA_TEST == 1)
		BoolAttribute(alphatest, true);
	#endif
	#if (S_TRANSLUCENT == 0)
		BoolAttribute(alphatest, true);
	#endif
	#if (S_TRANSLUCENT == 1)
		BoolAttribute(translucent, true);
	#endif
}
