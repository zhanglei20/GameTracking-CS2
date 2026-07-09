//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "s2 version of lightmappedgeneric/worldvertextransition shader for csgo.";
	DevShader = false;
	Version = 4;
	
	// VcsVersion: 71
	// Platform: VULKAN_SM_60
	// Programs: ps, psrs, rtx, vs
}

MODES
{
	Depth("csgo_depth_only.vfx");
	CsgoForward();
	RayTrace();
	ToolsVis(S_MODE_TOOLS_VIS);
	ToolsWireframe("csgo_tools_wireframe.vfx");
	ToolsShadingComplexity("csgo_tools_shading_complexity.vfx");
}

FEATURES
{
	Feature( F_DO_NOT_CAST_SHADOWS, 0..1, "Shadows" );
	Feature( F_RENDER_BACKFACES, 0..1, "2-Sided Rendering" );
	Feature( F_DONT_FLIP_BACKFACE_NORMALS, 0..1, "2-Sided Rendering" );
	Feature( F_DISABLE_Z_BUFFERING, 0..1, "Z-Buffering" );
	Feature( F_DISABLE_Z_PREPASS, 0..1, "Z-Prepass" );
	Feature( F_ALPHA_TEST, 0..1, "Translucent" );
	Feature( F_TRANSLUCENT, 0..1, "Translucent" );
	Feature( F_ADDITIVE_BLEND, 0..1, "Translucent" );
	Feature( F_TINT_MASK, 0..1, "Per-Instance Tint Mask" );
	Feature( F_SPECULAR_DIRECT, 0..1, "Direct/Per-Pixel Specular - S1 $phong" );
	Feature( F_SPECULAR_INDIRECT, 0..1, "Indirect/Cubemap Specular - S1 $envmap" );
	Feature( F_LAYERS, 0..1 (0="LightmappedGeneric", 1="WorldVertexTransition"), "Number of Additional Layers" );
	Feature( F_TEXTURETRANSFORMS, 0..1 (0="No Texture Transforms", 1="All Texture Transforms enabled"), "Texture Transforms" );
	Feature( F_FANCY_BLENDING, 0..3 (0="VertexBlend", 1="BlendModulateTexture,rg", 2="NewLayerBlending,g", 3="NewLayerBlending,a"), "Fancy Blending" );
	Feature( F_DETAILTEXTURE, 0..2 (0="None", 1="Layer 1 Detail Only", 2="Layer 1 and 2 Detail"), "Detail Textures" );
	Feature( F_DETAILBLENDMODE, 0..1 (0="Mod2x", 1="Mod2x_Select_Two_Patterns"), "S1 Combine Modes Supported" );
	Feature( F_ADDBUMPMAPS, 0..1 (0="None", 1="Detail Bumpmaps"), "S1 Detail bumpmaps" );
	Feature( F_OVERLAY, 0..1, "Overlay" );
	Feature( F_METALNESS_TEXTURE, 0..1, "PBR" );
	Feature( F_NO_SPECULAR_AT_FULL_ROUGHNESS, 0..1, "PBR" );
	FeatureRule( Requires( F_DONT_FLIP_BACKFACE_NORMALS, F_RENDER_BACKFACES ), "Only applies to backfaces" );
	FeatureRule( Allow1( F_ALPHA_TEST, F_TRANSLUCENT ), "Translucent and Alpha Test are not compatible" );
	FeatureRule( Requires( F_ADDITIVE_BLEND, F_TRANSLUCENT ), "Requires translucency" );
	FeatureRule( Allow1( F_TRANSLUCENT, F_DO_NOT_CAST_SHADOWS ), "Translucent and Do Not Cast Shadows are not compatible" );
	FeatureRule( Requires( F_SPECULAR_DIRECT, F_SPECULAR_INDIRECT ), "Direct specular requires indirect (we'd prefer to avoid having only direct specular)" );
	FeatureRule( Requires( F_FANCY_BLENDING, F_LAYERS=1 ), "fancy blending requires multiple layers" );
	FeatureRule( Requires( F_DETAILTEXTURE=2, F_LAYERS=1 ), "Detail blend mode requires detail textures" );
	FeatureRule( Requires( F_DETAILBLENDMODE, F_DETAILTEXTURE=2, F_LAYERS=1 ), "Detail blend mode requires detail textures" );
	FeatureRule( Requires( F_ADDBUMPMAPS, F_DETAILTEXTURE=1, F_DETAILTEXTURE=2 ), "Detail bumpmaps requires detail" );
	FeatureRule( Requires( F_OVERLAY, F_TRANSLUCENT, F_ALPHA_TEST ), "Overlay requires translucent or alphatest" );
	FeatureRule( Allow1( F_OVERLAY, F_LAYERS ), "Multiple layers not supported with overlays" );
	FeatureRule( Allow1( F_OVERLAY, F_DO_NOT_CAST_SHADOWS ), "Overlay and Do Not Cast Shadow Only are not compatible" );
	FeatureRule( Allow1( F_OVERLAY, F_RENDER_BACKFACES ), "Overlay and render backfaces are not compatible" );
	FeatureRule( Requires( F_TRANSLUCENT, F_LAYERS=0 ), "Translucency not yet supported with multiple layers" );
	FeatureRule( Requires( F_ALPHA_TEST, F_LAYERS=0 ), "AlphaTest not yet supported with multiple layers" );
	FeatureRule( Allow1( F_METALNESS_TEXTURE, F_ADDITIVE_BLEND ), "Metalness Texture and Additive Blend are not compatible" );
}

COMMON
{
	#include "system.fxc"
}

struct VS_INPUT
{
	float4 vBlendIndices              : BLENDINDICES0  < Semantic( BlendIndices ); >;              // D_CS_VERTEX_ANIMATION=0
	float4 vPerVertexLighting         : COLOR1         < Semantic( PerVertexLighting ); >;         // D_BAKED_LIGHTING_FROM_VERTEX_STREAM=1
	uint4  nPackedFrame               : NORMAL0        < Semantic( CompressedTangentFrame ); >;   
	float4 vNormalOs                  : NORMAL0        < Semantic( Normal ); >;                   
	float3 vPositionOs                : POSITION0      < Semantic( PosXyz ); >;                    // D_CS_VERTEX_ANIMATION=0
	float4 vColorBlendValues          : TEXCOORD4      < Semantic( VertexPaintBlendParams ); >;    // S_LAYERS=1, S_DETAILTEXTURE=2
	float2 vLightmapUV                : TEXCOORD3      < Semantic( LightmapUV ); >;                // D_BAKED_LIGHTING_FROM_LIGHTMAP=1
	float4 vTangentUOs_flTangentVSign : TANGENT0       < Semantic( TangentU_SignV ); >;           
	float2 vTexCoord                  : TEXCOORD0      < Semantic( LowPrecisionUv ); >;           
	float2 nInstanceIdx               : TEXCOORD13     < Semantic( InstanceTransformUv ); >;      
};

VS
{
	StaticCombo( S_MODE_TOOLS_VIS, 0..1 );
	StaticCombo( S_SPECULAR_DIRECT, F_SPECULAR_DIRECT );
	StaticCombo( S_SPECULAR_INDIRECT, F_SPECULAR_INDIRECT );
	StaticCombo( S_LAYERS, F_LAYERS );
	StaticCombo( S_FANCY_BLENDING, F_FANCY_BLENDING );
	StaticCombo( S_DETAILTEXTURE, F_DETAILTEXTURE );
	StaticCombo( S_TEXTURETRANSFORMS, F_TEXTURETRANSFORMS );
	StaticComboRule( Requires( S_SPECULAR_DIRECT, S_SPECULAR_INDIRECT ) );
	StaticComboRule( Requires( S_DETAILTEXTURE=2, S_LAYERS=1 ) );
	DynamicCombo( D_COMPRESSED_NORMALS_AND_TANGENTS, 0..1 );
	DynamicCombo( D_CS_VERTEX_ANIMATION, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_VERTEX_STREAM, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_LIGHTMAP, 0..1 );
	DynamicComboRule( Allow1( D_BAKED_LIGHTING_FROM_VERTEX_STREAM, D_BAKED_LIGHTING_FROM_LIGHTMAP ) );
	
	cbuffer PerViewConstantBufferCsgo_t < Attribute("PerViewConstantBufferCsgo_t"); >;
	cbuffer PerViewConstantBuffer_t < Attribute("PerViewConstantBuffer_t"); >;
	ByteAddressBuffer g_animatedVertexCache < Attribute("AnimatedVertexCache"); >;
	ExternalDescriptorSet g_globalLateBoundBindlessSet < Source(ExternalDescSet); Attribute("g_globalLateBoundBindlessSet"); >;
	StructuredBuffer g_instanceBuffer < Attribute("InstanceBuffer"); >;
	ExternalDescriptorSet g_lightBinnerGpuSet < Source(ExternalDescSet); Attribute("g_lightBinnerGpuSet"); >;
	StructuredBuffer g_transformBuffer < Attribute("TransformBuffer"); >;
	float4 g_vBlendModulateTexCoordXform0 < UiType(VectorText); Expression(v0 = (g_flBlendModulateTexCoordRotation*3.14159)/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v1*g_vBlendModulateTexCoordScale.x,-v2*g_vBlendModulateTexCoordScale.y,0,((g_vBlendModulateTexCoordCenter.x+g_vBlendModulateTexCoordOffset.x)+((v2*g_vBlendModulateTexCoordScale.y)*g_vBlendModulateTexCoordCenter.y))-((v1*g_vBlendModulateTexCoordScale.x)*g_vBlendModulateTexCoordCenter.x))); >;
	float4 g_vBlendModulateTexCoordXform1 < UiType(VectorText); Expression(v0 = (g_flBlendModulateTexCoordRotation*3.14159)/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v2*g_vBlendModulateTexCoordScale.x,v1*g_vBlendModulateTexCoordScale.y,0,((g_vBlendModulateTexCoordCenter.y+g_vBlendModulateTexCoordOffset.y)+((v2*g_vBlendModulateTexCoordScale.x)*g_vBlendModulateTexCoordCenter.x))-((v1*g_vBlendModulateTexCoordScale.y)*g_vBlendModulateTexCoordCenter.y))); >;
	float4 g_vLayer1NormalTexCoordXform0 < UiType(VectorText); Expression(v0 = (g_flLayer1NormalTexCoordRotation*3.14159)/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v1*g_vLayer1NormalTexCoordScale.x,-v2*g_vLayer1NormalTexCoordScale.y,0,((g_vLayer1NormalTexCoordCenter.x+g_vLayer1NormalTexCoordOffset.x)+((v2*g_vLayer1NormalTexCoordScale.y)*g_vLayer1NormalTexCoordCenter.y))-((v1*g_vLayer1NormalTexCoordScale.x)*g_vLayer1NormalTexCoordCenter.x))); >;
	float4 g_vLayer1NormalTexCoordXform1 < UiType(VectorText); Expression(v0 = (g_flLayer1NormalTexCoordRotation*3.14159)/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v2*g_vLayer1NormalTexCoordScale.x,v1*g_vLayer1NormalTexCoordScale.y,0,((g_vLayer1NormalTexCoordCenter.y+g_vLayer1NormalTexCoordOffset.y)+((v2*g_vLayer1NormalTexCoordScale.x)*g_vLayer1NormalTexCoordCenter.x))-((v1*g_vLayer1NormalTexCoordScale.y)*g_vLayer1NormalTexCoordCenter.y))); >;
	float4 g_vLayer1TexCoordXform0 < UiType(VectorText); Expression(v0 = (g_flLayer1TexCoordRotation*3.14159)/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v1*g_vLayer1TexCoordScale.x,-v2*g_vLayer1TexCoordScale.y,0,((g_vLayer1TexCoordCenter.x+g_vLayer1TexCoordOffset.x)+((v2*g_vLayer1TexCoordScale.y)*g_vLayer1TexCoordCenter.y))-((v1*g_vLayer1TexCoordScale.x)*g_vLayer1TexCoordCenter.x))); >;
	float4 g_vLayer1TexCoordXform1 < UiType(VectorText); Expression(v0 = (g_flLayer1TexCoordRotation*3.14159)/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v2*g_vLayer1TexCoordScale.x,v1*g_vLayer1TexCoordScale.y,0,((g_vLayer1TexCoordCenter.y+g_vLayer1TexCoordOffset.y)+((v2*g_vLayer1TexCoordScale.x)*g_vLayer1TexCoordCenter.x))-((v1*g_vLayer1TexCoordScale.y)*g_vLayer1TexCoordCenter.y))); >;
	float4 g_vLayer2NormalTexCoordXform0 < UiType(VectorText); Expression(v0 = (g_flLayer2NormalTexCoordRotation*3.14159)/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v1*g_vLayer2NormalTexCoordScale.x,-v2*g_vLayer2NormalTexCoordScale.y,0,((g_vLayer2NormalTexCoordCenter.x+g_vLayer2NormalTexCoordOffset.x)+((v2*g_vLayer2NormalTexCoordScale.y)*g_vLayer2NormalTexCoordCenter.y))-((v1*g_vLayer2NormalTexCoordScale.x)*g_vLayer2NormalTexCoordCenter.x))); >;
	float4 g_vLayer2NormalTexCoordXform1 < UiType(VectorText); Expression(v0 = (g_flLayer2NormalTexCoordRotation*3.14159)/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v2*g_vLayer2NormalTexCoordScale.x,v1*g_vLayer2NormalTexCoordScale.y,0,((g_vLayer2NormalTexCoordCenter.y+g_vLayer2NormalTexCoordOffset.y)+((v2*g_vLayer2NormalTexCoordScale.x)*g_vLayer2NormalTexCoordCenter.x))-((v1*g_vLayer2NormalTexCoordScale.y)*g_vLayer2NormalTexCoordCenter.y))); >;
	float4 g_vLayer2TexCoordXform0 < UiType(VectorText); Expression(v0 = (g_flLayer2TexCoordRotation*3.14159)/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v1*g_vLayer2TexCoordScale.x,-v2*g_vLayer2TexCoordScale.y,0,((g_vLayer2TexCoordCenter.x+g_vLayer2TexCoordOffset.x)+((v2*g_vLayer2TexCoordScale.y)*g_vLayer2TexCoordCenter.y))-((v1*g_vLayer2TexCoordScale.x)*g_vLayer2TexCoordCenter.x))); >;
	float4 g_vLayer2TexCoordXform1 < UiType(VectorText); Expression(v0 = (g_flLayer2TexCoordRotation*3.14159)/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v2*g_vLayer2TexCoordScale.x,v1*g_vLayer2TexCoordScale.y,0,((g_vLayer2TexCoordCenter.y+g_vLayer2TexCoordOffset.y)+((v2*g_vLayer2TexCoordScale.x)*g_vLayer2TexCoordCenter.x))-((v1*g_vLayer2TexCoordScale.y)*g_vLayer2TexCoordCenter.y))); >;
	
	// Blend Modulation
	float2 g_vBlendModulateTexCoordCenter < Default2(0.5, 0.5); UiType(VectorText); UiGroup("Blend Modulation,20 / Texture,10 / 20"); >;
	float2 g_vBlendModulateTexCoordScale < Default2(1, 1); Range2(0, 0, 100, 100); UiType(VectorText); UiGroup("Blend Modulation,20 / Texture,10 / 30"); >;
	float g_flBlendModulateTexCoordRotation < Range(-360, 360); UiType(Slider); UiGroup("Blend Modulation,20 / Texture,10 / 40"); >;
	float2 g_vBlendModulateTexCoordOffset < Range2(-1, -1, 1, 1); UiType(VectorText); UiGroup("Blend Modulation,20 / Texture,10 / 50"); >;
	
	// PBR 1
	float2 g_vLayer1DetailScale < Default2(4, 4); Range2(0, 0, 100, 100); UiType(VectorText); UiGroup("PBR 1,10 / Detail,70 / 15"); >;
	float2 g_vLayer1NormalTexCoordCenter < Default2(0.5, 0.5); UiType(VectorText); UiGroup("PBR 1,10 / Normal,20 / 30"); >;
	float2 g_vLayer1TexCoordCenter < Default2(0.5, 0.5); UiType(VectorText); UiGroup("PBR 1,10 / Albedo,10 / 30"); >;
	float2 g_vLayer1NormalTexCoordScale < Default2(1, 1); Range2(0, 0, 100, 100); UiType(VectorText); UiGroup("PBR 1,10 / Normal,20 / 40"); >;
	float2 g_vLayer1TexCoordScale < Default2(1, 1); Range2(0, 0, 100, 100); UiType(VectorText); UiGroup("PBR 1,10 / Albedo,10 / 40"); >;
	float g_flLayer1NormalTexCoordRotation < Range(-360, 360); UiType(Slider); UiGroup("PBR 1,10 / Normal,20 / 50"); >;
	float g_flLayer1TexCoordRotation < Range(-360, 360); UiType(Slider); UiGroup("PBR 1,10 / Albedo,10 / 50"); >;
	float2 g_vLayer1NormalTexCoordOffset < Range2(-1, -1, 1, 1); UiType(VectorText); UiGroup("PBR 1,10 / Normal,20 / 60"); >;
	float2 g_vLayer1TexCoordOffset < Range2(-1, -1, 1, 1); UiType(VectorText); UiGroup("PBR 1,10 / Albedo,10 / 60"); >;
	
	// PBR 2
	float2 g_vLayer2DetailScale < Default2(4, 4); Range2(0, 0, 100, 100); UiType(VectorText); UiGroup("PBR 2,10 / Detail,70 / 15"); >;
	float2 g_vLayer2NormalTexCoordCenter < Default2(0.5, 0.5); UiType(VectorText); UiGroup("PBR 2,10 / Normal,20 / 30"); >;
	float2 g_vLayer2TexCoordCenter < Default2(0.5, 0.5); UiType(VectorText); UiGroup("PBR 2,10 / Albedo,10 / 30"); >;
	float2 g_vLayer2NormalTexCoordScale < Default2(1, 1); Range2(0, 0, 100, 100); UiType(VectorText); UiGroup("PBR 2,10 / Normal,20 / 40"); >;
	float2 g_vLayer2TexCoordScale < Default2(1, 1); Range2(0, 0, 100, 100); UiType(VectorText); UiGroup("PBR 2,10 / Albedo,10 / 40"); >;
	float g_flLayer2NormalTexCoordRotation < Range(-360, 360); UiType(Slider); UiGroup("PBR 2,10 / Normal,20 / 50"); >;
	float g_flLayer2TexCoordRotation < Range(-360, 360); UiType(Slider); UiGroup("PBR 2,10 / Albedo,10 / 50"); >;
	float2 g_vLayer2NormalTexCoordOffset < Range2(-1, -1, 1, 1); UiType(VectorText); UiGroup("PBR 2,10 / Normal,20 / 60"); >;
	float2 g_vLayer2TexCoordOffset < Range2(-1, -1, 1, 1); UiType(VectorText); UiGroup("PBR 2,10 / Albedo,10 / 60"); >;
	
	// Color
	float3 g_vColorTint < Default3(1, 1, 1); UiType(Color); UiGroup("Color,10/20"); Expression(SrgbGammaToLinear(this)); >;
	float g_flVertexColorOpacityScale < Default(1); UiType(Slider); UiGroup("Color, 10/25"); >;
	float g_flModelTintAmount < Default(1); UiType(Slider); UiGroup("Color,10/30"); >;
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (5880 bytes), HLSL reflection with SPIRV-Cross by KhronosGroup
	
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
	
	ByteAddressBuffer g_instanceBuffer : register(t32, space4);
	ByteAddressBuffer g_transformBuffer : register(t30, space4);
	cbuffer PerViewConstantBuffer_t : register(b1, space0)
	{
	    column_major float4x4 PerViewConstantBuffer_t_1_m0 : packoffset(c0);
	    float4 PerViewConstantBuffer_t_1_m1 : packoffset(c24);
	};
	
	cbuffer _Globals_ : register(b0, space0)
	{
	    float3 _Globals_1_g_vColorTint : packoffset(c4.y);
	    float _Globals_1_g_flVertexColorOpacityScale : packoffset(c5);
	    float _Globals_1_g_flModelTintAmount : packoffset(c5.y);
	};
	
	cbuffer PerViewConstantBufferCsgo_t : register(b3, space0)
	{
	    float4 PerViewConstantBufferCsgo_t_1_m0 : packoffset(c35);
	};
	
	
	static float4 gl_Position;
	static float3 vPositionOs;
	static float2 vTexCoord;
	static float3 vNormalOs;
	static float4 vTangentUOs_flTangentVSign;
	static uint4 vBlendIndices;
	static uint nInstanceIdx;
	static float3 output_0;
	static float3 output_1;
	static float4 output_2;
	static float4 output_3;
	static float4 output_4;
	static uint output_5;
	
	struct VS_INPUT
	{
	    float3 vPositionOs : TEXCOORD0;
	    float2 vTexCoord : TEXCOORD1;
	    float3 vNormalOs : TEXCOORD2;
	    float4 vTangentUOs_flTangentVSign : TEXCOORD3;
	    uint4 vBlendIndices : TEXCOORD4;
	    uint nInstanceIdx : TEXCOORD5;
	};
	
	struct PS_INPUT
	{
	    float3 output_0 : TEXCOORD0;
	    float3 output_1 : TEXCOORD1;
	    float4 output_2 : TEXCOORD2;
	    centroid float4 output_3 : TEXCOORD3;
	    float4 output_4 : TEXCOORD4;
	    nointerpolation uint output_5 : TEXCOORD5;
	    float4 gl_Position : SV_Position;
	};
	
	void MainVs_inner()
	{
	    _1126 _8152;
	    _8152._m0 = g_instanceBuffer.Load(nInstanceIdx * 32 + 0);
	    _8152._m1 = g_instanceBuffer.Load(nInstanceIdx * 32 + 4);
	    _8152._m2 = g_instanceBuffer.Load(nInstanceIdx * 32 + 8);
	    _8152._m3 = g_instanceBuffer.Load(nInstanceIdx * 32 + 12);
	    _8152._m4 = g_instanceBuffer.Load(nInstanceIdx * 32 + 16);
	    _8152._m5 = g_instanceBuffer.Load(nInstanceIdx * 32 + 20);
	    _8152._m6 = g_instanceBuffer.Load(nInstanceIdx * 32 + 24);
	    _8152._m7 = asfloat(g_instanceBuffer.Load(nInstanceIdx * 32 + 28));
	    _1125 _20228;
	    _20228._m0 = _8152._m0;
	    _20228._m1 = _8152._m1;
	    _20228._m2 = _8152._m2;
	    _20228._m3 = _8152._m3;
	    _20228._m4 = _8152._m4;
	    _20228._m5 = _8152._m5;
	    _20228._m6 = _8152._m6;
	    _20228._m7 = _8152._m7;
	    uint _16987 = (_20228._m5 >> uint(16)) & 15u;
	    uint _21709;
	    if (_16987 == 1u)
	    {
	        _21709 = _20228._m1 + (2u + vBlendIndices.x);
	    }
	    else
	    {
	        _21709 = _20228._m1;
	    }
	    _1120 _11578;
	    _11578._m0 = asfloat(uint3x4(g_transformBuffer.Load4(_21709 * 48 + 0), g_transformBuffer.Load4(_21709 * 48 + 16), g_transformBuffer.Load4(_21709 * 48 + 32)));
	    _1119 _21957;
	    _21957._m0 = _11578._m0;
	    float3 _19321;
	    if (_16987 > 0u)
	    {
	        _1120 _10769;
	        _10769._m0 = asfloat(uint3x4(g_transformBuffer.Load4(_20228._m1 * 48 + 0), g_transformBuffer.Load4(_20228._m1 * 48 + 16), g_transformBuffer.Load4(_20228._m1 * 48 + 32)));
	        _1119 _20229;
	        _20229._m0 = _10769._m0;
	        _19321 = _20229._m0[0].z.xxx;
	    }
	    else
	    {
	        _19321 = 1.0f.xxx;
	    }
	    float4 _23812 = float4(uint4(_20228._m0 & 255u, (_20228._m0 & 65280u) >> uint(8), (_20228._m0 & 16711680u) >> uint(16), (_20228._m0 & 4278190080u) >> uint(24))) * 0.0039215688593685626983642578125f.xxxx;
	    float3 _6253 = _23812.xyz;
	    float3 _17828 = _6253 * 0.077399380505084991455078125f.xxx;
	    float3 _7676 = pow((_6253 * 0.947867333889007568359375f.xxx) + 0.052132703363895416259765625f.xxx, 2.400000095367431640625f.xxx);
	    float _21354;
	    if (_23812.x <= 0.040449999272823333740234375f)
	    {
	        _21354 = _17828.x;
	    }
	    else
	    {
	        _21354 = _7676.x;
	    }
	    float _21355;
	    if (_23812.y <= 0.040449999272823333740234375f)
	    {
	        _21355 = _17828.y;
	    }
	    else
	    {
	        _21355 = _7676.y;
	    }
	    float _17978;
	    if (_23812.z <= 0.040449999272823333740234375f)
	    {
	        _17978 = _17828.z;
	    }
	    else
	    {
	        _17978 = _7676.z;
	    }
	    float _7654 = _23812.w;
	    float _16337 = _7654 * _20228._m7;
	    float3 _12151 = mul(_21957._m0, float4(vPositionOs.xyz * _19321.xyz, 1.0f));
	    float4 _18237 = mul(PerViewConstantBuffer_t_1_m0, (float4(_12151.xyz, 1.0f) + (PerViewConstantBuffer_t_1_m1 * 1.0f)).xyzw);
	    float4 _9337 = vTexCoord.xyxy;
	    _9337.z = vTexCoord.x;
	    _9337.w = vTexCoord.y;
	    output_0 = _12151.xyz - PerViewConstantBufferCsgo_t_1_m0.xyz;
	    output_1 = normalize(mul(_21957._m0, float4(vNormalOs.xyz, 0.0f)));
	    output_2 = _9337;
	    output_3 = float4(float4(lerp(1.0f.xxx, float4(_21354, _21355, _17978, _7654).xyz, _Globals_1_g_flModelTintAmount.xxx), _16337).xyz * _Globals_1_g_vColorTint.xyz, _16337 * _Globals_1_g_flVertexColorOpacityScale);
	    output_4 = float4(normalize(mul(_21957._m0, float4(vTangentUOs_flTangentVSign.xyz, 0.0f))), vTangentUOs_flTangentVSign.w);
	    output_5 = _20228._m5 & 65535u;
	    _18237.y = -_18237.y;
	    gl_Position = _18237;
	}
	
	PS_INPUT MainVs(VS_INPUT stage_input)
	{
	    vPositionOs = stage_input.vPositionOs;
	    vTexCoord = stage_input.vTexCoord;
	    vNormalOs = stage_input.vNormalOs;
	    vTangentUOs_flTangentVSign = stage_input.vTangentUOs_flTangentVSign;
	    vBlendIndices = stage_input.vBlendIndices;
	    nInstanceIdx = stage_input.nInstanceIdx;
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
	
	
	
	BoolAttribute(BindlessResources, true);
	BoolAttribute(CanBatchWithDynamicShaderConstants, true);
	BoolAttribute(SupportsAggregateInstancing, F_TRANSLUCENT==0);
	BoolAttribute(VertexPaintUI2Layer, true);
	BoolAttribute(VertexPaintUIPickColor, true);
	
	
	// Variant Attributes
	BoolAttribute(environmentmapped, true);
	BoolAttribute(environmentmappeddynamic, true);
}

PS
{
	StaticCombo( S_MODE_TOOLS_VIS, 0..1 );
	StaticCombo( S_SPECULAR_DIRECT, F_SPECULAR_DIRECT );
	StaticCombo( S_SPECULAR_INDIRECT, F_SPECULAR_INDIRECT );
	StaticCombo( S_LAYERS, F_LAYERS );
	StaticCombo( S_FANCY_BLENDING, F_FANCY_BLENDING );
	StaticCombo( S_DETAILTEXTURE, F_DETAILTEXTURE );
	StaticCombo( S_TEXTURETRANSFORMS, F_TEXTURETRANSFORMS );
	StaticCombo( S_ALPHA_TEST, F_ALPHA_TEST );
	StaticCombo( S_TRANSLUCENT, F_TRANSLUCENT );
	StaticCombo( S_DETAILBLENDMODE, F_DETAILBLENDMODE );
	StaticCombo( S_OVERLAY, F_OVERLAY );
	StaticCombo( S_METALNESS_TEXTURE, F_METALNESS_TEXTURE );
	StaticCombo( S_SHADER_QUALITY, 0..1 );
	StaticComboRule( Requires( S_MODE_TOOLS_VIS, S_SHADER_QUALITY ) );
	StaticComboRule( Allow1( S_ALPHA_TEST, S_TRANSLUCENT ) );
	StaticComboRule( Requires( S_SPECULAR_DIRECT, S_SPECULAR_INDIRECT ) );
	StaticComboRule( Requires( S_DETAILTEXTURE=2, S_LAYERS=1 ) );
	StaticComboRule( Requires( S_DETAILBLENDMODE, S_DETAILTEXTURE=2, S_LAYERS=1 ) );
	StaticComboRule( Requires( S_OVERLAY, S_TRANSLUCENT, S_ALPHA_TEST ) );
	StaticComboRule( Allow1( S_OVERLAY, S_LAYERS ) );
	StaticComboRule( Requires( S_TRANSLUCENT, S_LAYERS=0 ) );
	StaticComboRule( Requires( S_ALPHA_TEST, S_LAYERS=0 ) );
	DynamicCombo( D_BAKED_LIGHTING_FROM_VERTEX_STREAM, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_PROBE, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_LIGHTMAP, 0..1 );
	DynamicCombo( D_SPECULAR_CUBE_MAP_STATIC, 0..1 );
	DynamicCombo( D_OPAQUE_FADE, 0..1 );
	DynamicCombo( D_MBOIT_PASS1, 0..1 );
	DynamicCombo( D_MBOIT_PASS2, 0..1 );
	DynamicCombo( D_MBOIT_4_MOMENTS, 0..1 );
	DynamicComboRule( Allow1( D_BAKED_LIGHTING_FROM_PROBE, D_BAKED_LIGHTING_FROM_VERTEX_STREAM, D_BAKED_LIGHTING_FROM_LIGHTMAP ) );
	DynamicComboRule( Requires( D_SPECULAR_CUBE_MAP_STATIC, S_SHADER_QUALITY ) );
	DynamicComboRule( Requires( D_SPECULAR_CUBE_MAP_STATIC, S_SPECULAR_INDIRECT, S_MODE_TOOLS_VIS ) );
	DynamicComboRule( Allow1( S_ALPHA_TEST, S_TRANSLUCENT, D_OPAQUE_FADE ) );
	DynamicComboRule( Allow1( D_MBOIT_PASS1, D_MBOIT_PASS2 ) );
	DynamicComboRule( Requires( D_MBOIT_PASS1, S_TRANSLUCENT ) );
	DynamicComboRule( Requires( D_MBOIT_PASS2, S_TRANSLUCENT ) );
	DynamicComboRule( Requires( D_MBOIT_4_MOMENTS, D_MBOIT_PASS1, D_MBOIT_PASS2 ) );
	
	cbuffer BakedLightingConstantBuffer_t < Attribute("BakedLightingConstantBuffer_t"); >;
	cbuffer PerViewConstantBufferCsgo_t < Attribute("PerViewConstantBufferCsgo_t"); >;
	cbuffer PerViewConstantBuffer_t < Attribute("PerViewConstantBuffer_t"); >;
	cbuffer PerViewLightProbeVolumeConstantBuffer_t < Attribute("PerViewLightProbeVolumeConstantBuffer_t"); >;
	cbuffer PerViewLightingConstantBufferGpu_t < Attribute("PerViewLightingConstantBufferGpu_t"); >;
	StructuredBuffer g_BarnLights < Attribute("BarnLights"); >;
	StructuredBuffer g_CullBits < Attribute("CullBits"); >;
	bool g_bAddBumpMaps < UiType(CheckBox); Expression(F_ADDBUMPMAPS || 0); >;
	bool g_bCubemapNormalization < Attribute("g_bCubemapNormalization"); UiType(CheckBox); >;
	bool g_bDisableNormalMapping < Attribute("g_bDisableNormalMapping"); UiType(CheckBox); >;
	bool g_bDontFlipBackfaceNormals < UiType(CheckBox); Expression(F_DONT_FLIP_BACKFACE_NORMALS || 0); >;
	bool g_bHighlightDeprecated < Attribute("g_bHighlightDeprecated"); UiType(CheckBox); >;
	bool g_bIsDeprecated < Attribute("bIsDeprecated"); UiType(CheckBox); >;
	bool g_bNoSpecularAtFullRoughness < UiType(CheckBox); Expression(F_NO_SPECULAR_AT_FULL_ROUGHNESS || 0); >;
	bool g_bRenderBackfaceNormals < UiType(CheckBox); Expression((F_RENDER_BACKFACES && 1) || 0); >;
	bool g_bRenderingToCubemaps < Attribute("g_bRenderingToCubemaps"); UiType(CheckBox); >;
	bool g_bShowLPVVoxels < Attribute("g_bShowLPVVoxels"); UiType(CheckBox); >;
	bool g_bShowLightmapTexels < Attribute("g_bShowLightmapTexels"); UiType(CheckBox); >;
	float g_fToolsVisHeightTint < Default(0.9); Attribute("g_fToolsVisHeightTint"); UiType(Slider); >;
	float g_fToolsVisMaxHeightRange < Default(1); Attribute("g_fToolsVisMaxHeightRange"); UiType(Slider); >;
	float g_fToolsVisMaxLightingComplexity < Default(8); Attribute("g_fToolsVisMaxLightingComplexity"); UiType(Slider); >;
	float g_flReflectance < UiType(Slider); Expression(pow((1.5-1)/(1.5+1),2)); >;
	ExternalDescriptorSet g_globalLateBoundBindlessSet < Source(ExternalDescSet); Attribute("g_globalLateBoundBindlessSet"); >;
	ExternalDescriptorSet g_lightBinnerGpuSet < Source(ExternalDescSet); Attribute("g_lightBinnerGpuSet"); >;
	int g_nFancyBlendingMode < UiType(Slider); Expression(F_FANCY_BLENDING); >;
	int g_nToolsVisMode < Attribute("g_nToolsVisMode"); UiType(Slider); >;
	Texture2D g_tBlendModulation < Channel(RGBA, Box(TextureBlendModulation), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tColor < Channel(RGB, ArtistDefined(TextureLayer1Color), Srgb); OutputFormat(DXT1); SrgbRead(true); >;
	Texture2D g_tColor < Channel(RGB, ArtistDefined(TextureLayer1Color), Srgb); Channel(A, Box(TextureMetalness), Linear); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tColor < Channel(RGB, ArtistDefinedOrAlphaWeighted(TextureLayer1Color, TextureLayer1Translucency), Srgb); Channel(A, PreserveCoverage(TextureLayer1Translucency), Linear); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tColor < Channel(RGB, ArtistDefinedOrAlphaWeighted(TextureLayer1Color, TextureLayer1Translucency), Srgb); Channel(A, Box(TextureLayer1Translucency), Linear); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tLayer1AmbientOcclusion < Channel(R, Box3(TextureLayer1AmbientOcclusion), Linear); OutputFormat(ATI1N); SrgbRead(false); >;
	Texture2D g_tLayer1Detail < Channel(RGB, Box(TextureLayer1Detail), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tLayer1NormalRoughness < Channel(RGBA, HemiOctIsoRoughness_RG_B(TextureLayer1Normal, TextureLayer1Roughness), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tLayer2AmbientOcclusion < Channel(R, Box3(TextureLayer2AmbientOcclusion), Linear); OutputFormat(ATI1N); SrgbRead(false); >;
	Texture2D g_tLayer2Color < Channel(RGB, ArtistDefined(TextureLayer2Color), Srgb); OutputFormat(DXT1); SrgbRead(true); >;
	Texture2D g_tLayer2Detail < Channel(RGB, Box(TextureLayer2Detail), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tLayer2NormalRoughness < Channel(RGBA, HemiOctIsoRoughness_RG_B(TextureLayer2Normal, TextureLayer2Roughness), Linear); OutputFormat(BC7); SrgbRead(false); >;
	float3 g_vFlatOverlayColor < Default2(1, 0); Attribute("FlatOverlayColor"); UiType(VectorText); >;
	float4 g_vShaderIDColor < Source(ShaderIDColor); UiType(VectorText); >;
	
	// Blend Modulation
	CreateInputTexture2D(TextureBlendModulation, Linear, 8, "", "_blend", "Blend Modulation,20 / Texture,10 / 10", Default4(0.5, 0.5, 0.5, 0.5));
	float g_flBlendSoftness < Default(0.5); UiType(Slider); UiGroup("Blend Modulation,20 / Texture,10 / 60"); >;
	float g_flLayerBorderStrength < Default(0.5); UiType(Slider); UiGroup("Blend Modulation,20 / Texture,10 / 70"); >;
	float g_flLayerBorderOffset < Range(-1, 1); UiType(Slider); UiGroup("Blend Modulation,20 / Texture,10 / 80"); Expression(-this); >;
	float g_flLayerBorderSoftness < Default(0.5); UiType(Slider); UiGroup("Blend Modulation,20 / Texture,10 / 90"); >;
	float3 g_vLayerBorderTint < Default3(1, 1, 1); UiType(Color); UiGroup("Blend Modulation,20 / Texture,10 / 100"); Expression(SrgbGammaToLinear(this)); >;
	float g_flBevelBlendWidth < Default(4); Range(0, 10); UiType(Slider); UiGroup("Blend Modulation,20 / Texture,10 / 110"); >;
	float g_flBevelBlendSharpness < Default(2); Range(0, 10); UiType(Slider); UiGroup("Blend Modulation,20 / Texture,10 / 120"); >;
	float g_flBevelBlendStrength < Range(-4, 4); UiType(Slider); UiGroup("Blend Modulation,20 / Texture,10 / 130"); >;
	
	// PBR 1
	CreateInputTexture2D(TextureLayer1AmbientOcclusion, Linear, 8, "", "_ao", "PBR 1,10 / Ambient Occlusion,50 / 10", Default4(1, 1, 1, 0));
	CreateInputTexture2D(TextureLayer1Color, Srgb, 8, "", "_color", "PBR 1,10 / Albedo,10 / 10", Default4(0.5, 0.5, 0.5, 0));
	CreateInputTexture2D(TextureLayer1Detail, Linear, 8, "Mod2XCenter", "_detail", "PBR 1,10 / Detail,70 / 10", Default4(1, 1, 1, 1));
	CreateInputTexture2D(TextureLayer1Normal, Linear, 8, "NormalizeNormals", "_normal", "PBR 1,10 / Normal,20 / 10", Default4(0.5, 0.5, 1, 0));
	CreateInputTexture2D(TextureLayer1Roughness, Linear, 8, "Inverse", "_rough", "PBR 1,10 / Roughness,30 / 10", Default4(0.5, 0.5, 0.5, 0));
	CreateInputTexture2D(TextureLayer1Translucency, Linear, 8, "", "_trans", "PBR 1,10 / Albedo Translucency,15 / 10", Default4(1, 1, 1, 0));
	float4 g_vLayer1DetailTintAndBlend < Default4(1, 1, 1, 1); UiType(VectorText); UiGroup("PBR 1,10 / Detail,70 / 20"); >;
	float3 g_vLayer1Tint < Default3(1, 1, 1); UiType(Color); UiGroup("PBR 1,10 / Albedo,10 / 20"); Expression(SrgbGammaToLinear(this)); >;
	
	// PBR 2
	CreateInputTexture2D(TextureLayer2AmbientOcclusion, Linear, 8, "", "_ao", "PBR 2,10 / Ambient Occlusion,50 / 10", Default4(1, 1, 1, 0));
	CreateInputTexture2D(TextureLayer2Color, Srgb, 8, "", "_color", "PBR 2,10 / Albedo,10 / 10", Default4(0.5, 0.5, 0.5, 0));
	CreateInputTexture2D(TextureLayer2Detail, Linear, 8, "Mod2XCenter", "_detail", "PBR 2,10 / Detail,70 / 10", Default4(1, 1, 1, 1));
	CreateInputTexture2D(TextureLayer2Normal, Linear, 8, "NormalizeNormals", "_normal", "PBR 2,10 / Normal,20 / 10", Default4(0.5, 0.5, 1, 0));
	CreateInputTexture2D(TextureLayer2Roughness, Linear, 8, "Inverse", "_rough", "PBR 2,10 / Roughness,30 / 10", Default4(0.5, 0.5, 0.5, 0));
	float4 g_vLayer2DetailTintAndBlend < Default4(1, 1, 1, 1); UiType(VectorText); UiGroup("PBR 2,10 / Detail,70 / 20"); >;
	float3 g_vLayer2Tint < Default3(1, 1, 1); UiType(Color); UiGroup("PBR 2,10 / Albedo,10 / 20"); Expression(SrgbGammaToLinear(this)); >;
	
	// Lighting
	CreateInputTexture2D(TextureMetalness, Linear, 8, "", "_metal", "Lighting,30/Metalness,30/10", Default4(0, 0, 0, 0));
	float g_flMetalness < UiType(Slider); UiGroup("Lighting,30/Metalness/30"); >;
	
	// Fog
	bool g_bFogEnabled < Default(1); UiType(CheckBox); UiGroup("Fog"); >;
	
	// Translucent
	float g_flAlphaTestReference < Default(0.5); Range(0.01, 0.99); UiType(Slider); UiGroup("Translucent"); >;
	float g_flAlphaTestReference < Default(0.01); Range(0.01, 0.99); UiType(Slider); UiGroup("Translucent"); >;
	float g_flAntiAliasedEdgeStrength < Default(1); UiType(Slider); UiGroup("Translucent"); >;
	float g_flOpacityScale < Default(1); UiType(Slider); UiGroup("Translucent"); >;
	
	// Texture Address Mode
	int g_nTextureAddressModeU < UiOption("RsTextureAddressMode_t"); UiType(Enum); UiGroup("Texture Address Mode"); >;
	int g_nTextureAddressModeV < UiOption("RsTextureAddressMode_t"); UiType(Enum); UiGroup("Texture Address Mode"); >;
	
	#if (S_ALPHA_TEST == 1)
		Texture2D g_tColor < Channel(RGB, ArtistDefinedOrAlphaWeighted(TextureLayer1Color, TextureLayer1Translucency), Srgb); Channel(A, PreserveCoverage(TextureLayer1Translucency), Linear); OutputFormat(BC7); SrgbRead(true); >;
		float g_flAlphaTestReference < Default(0.5); Range(0.01, 0.99); UiType(Slider); UiGroup("Translucent"); >;
	#endif
	#if (S_TRANSLUCENT == 1)
		Texture2D g_tColor < Channel(RGB, ArtistDefinedOrAlphaWeighted(TextureLayer1Color, TextureLayer1Translucency), Srgb); Channel(A, Box(TextureLayer1Translucency), Linear); OutputFormat(BC7); SrgbRead(true); >;
	#endif
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (31540 bytes), HLSL reflection with SPIRV-Cross by KhronosGroup
	
	struct _2494
	{
	    float4 _m0[3];
	};
	
	struct _2704
	{
	    float4 _m0[4];
	};
	
	struct _465
	{
	    column_major float4x4 _m0[4];
	};
	
	struct _200
	{
	    column_major float4x4 _m0;
	    column_major float4x4 _m1;
	    float4 _m2;
	    float4 _m3;
	    float4 _m4;
	    float4 _m5;
	    float3 _m6;
	    uint _m7;
	    float4 _m8;
	    float4 _m9;
	    float4 _m10;
	    float _m11;
	    float _m12;
	    uint _m13;
	    int _m14;
	    column_major float4x3 _m15;
	    float4 _m16;
	    float4 _m17;
	    float4 _m18;
	    float4 _m19;
	    float4 _m20;
	    float3 _m21;
	    float _m22;
	    column_major float4x4 _m23;
	};
	
	static float3 _4;
	static float4 _5;
	
	cbuffer _Globals_ : register(b0, space1)
	{
	    uint _Globals_1_g_sTrilinearWrap : packoffset(c0.z);
	    uint _Globals_1_g_sTrilinearClamp : packoffset(c0.w);
	    uint _Globals_1_g_sPointClamp : packoffset(c1);
	    uint _Globals_1_g_sUserConfig : packoffset(c1.w);
	    uint _Globals_1_g_tColor : packoffset(c2.y);
	    uint _Globals_1_g_tLayer1NormalRoughness : packoffset(c2.z);
	    uint _Globals_1_g_tLayer1AmbientOcclusion : packoffset(c2.w);
	    float3 _Globals_1_g_vLayer1Tint : packoffset(c3);
	    uint _Globals_1_g_sCookieSampler : packoffset(c4.z);
	    uint _Globals_1_g_tShadowDepthBufferCmpSampler : packoffset(c4.w);
	    int _Globals_1_g_bFogEnabled : packoffset(c5.y);
	    int _Globals_1_g_bDontFlipBackfaceNormals : packoffset(c5.z);
	    int _Globals_1_g_bRenderBackfaceNormals : packoffset(c5.w);
	    float _Globals_1_g_flMetalness : packoffset(c10);
	};
	
	cbuffer PerViewConstantBufferCsgo_t : register(b3, space1)
	{
	    int4 PerViewConstantBufferCsgo_t_1_m0 : packoffset(c1);
	    int4 PerViewConstantBufferCsgo_t_1_m1 : packoffset(c2);
	    int4 PerViewConstantBufferCsgo_t_1_m2 : packoffset(c3);
	    uint PerViewConstantBufferCsgo_t_1_m3 : packoffset(c4.z);
	    uint PerViewConstantBufferCsgo_t_1_m4 : packoffset(c4.w);
	    uint PerViewConstantBufferCsgo_t_1_m5 : packoffset(c5);
	    uint PerViewConstantBufferCsgo_t_1_m6 : packoffset(c5.z);
	    column_major float4x4 PerViewConstantBufferCsgo_t_1_m7 : packoffset(c12);
	    float2 PerViewConstantBufferCsgo_t_1_m8 : packoffset(c16);
	    float PerViewConstantBufferCsgo_t_1_m9 : packoffset(c16.z);
	    float4 PerViewConstantBufferCsgo_t_1_m10 : packoffset(c23);
	    float4 PerViewConstantBufferCsgo_t_1_m11 : packoffset(c24);
	    float4 PerViewConstantBufferCsgo_t_1_m12 : packoffset(c25);
	    float4 PerViewConstantBufferCsgo_t_1_m13 : packoffset(c26);
	    float4 PerViewConstantBufferCsgo_t_1_m14 : packoffset(c27);
	    float4 PerViewConstantBufferCsgo_t_1_m15 : packoffset(c28);
	    column_major float4x4 PerViewConstantBufferCsgo_t_1_m16 : packoffset(c29);
	    float4 PerViewConstantBufferCsgo_t_1_m17 : packoffset(c33);
	    float4 PerViewConstantBufferCsgo_t_1_m18 : packoffset(c34);
	    float4 PerViewConstantBufferCsgo_t_1_m19 : packoffset(c35);
	};
	
	cbuffer PerViewLightingConstantBufferGpu_t : register(b0, space3)
	{
	    _2494 PerViewLightingConstantBufferGpu_t_1_m0 : packoffset(c7);
	    _2704 PerViewLightingConstantBufferGpu_t_1_m1 : packoffset(c11);
	    float4 PerViewLightingConstantBufferGpu_t_1_m2 : packoffset(c16);
	    float4 PerViewLightingConstantBufferGpu_t_1_m3 : packoffset(c17);
	    float4 PerViewLightingConstantBufferGpu_t_1_m4 : packoffset(c18);
	    uint4 PerViewLightingConstantBufferGpu_t_1_m5 : packoffset(c19);
	    uint4 PerViewLightingConstantBufferGpu_t_1_m6 : packoffset(c22);
	    float4 PerViewLightingConstantBufferGpu_t_1_m7 : packoffset(c23);
	    float4 PerViewLightingConstantBufferGpu_t_1_m8 : packoffset(c1945);
	    float4 PerViewLightingConstantBufferGpu_t_1_m9 : packoffset(c1946);
	    int PerViewLightingConstantBufferGpu_t_1_m10 : packoffset(c1953);
	    float PerViewLightingConstantBufferGpu_t_1_m11 : packoffset(c1953.z);
	    float4 PerViewLightingConstantBufferGpu_t_1_m12 : packoffset(c1954);
	    float PerViewLightingConstantBufferGpu_t_1_m13 : packoffset(c1955);
	    float PerViewLightingConstantBufferGpu_t_1_m14 : packoffset(c1955.y);
	    float PerViewLightingConstantBufferGpu_t_1_m15 : packoffset(c1955.z);
	    float PerViewLightingConstantBufferGpu_t_1_m16 : packoffset(c1955.w);
	    _465 PerViewLightingConstantBufferGpu_t_1_m17 : packoffset(c1956);
	    _2704 PerViewLightingConstantBufferGpu_t_1_m18 : packoffset(c1988);
	    uint PerViewLightingConstantBufferGpu_t_1_m19 : packoffset(c1996);
	    uint PerViewLightingConstantBufferGpu_t_1_m20 : packoffset(c1996.y);
	};
	
	cbuffer PerViewConstantBuffer_t : register(b1, space1)
	{
	    float2 PerViewConstantBuffer_t_1_m0 : packoffset(c20);
	    float2 PerViewConstantBuffer_t_1_m1 : packoffset(c20.z);
	    float4 PerViewConstantBuffer_t_1_m2 : packoffset(c22);
	    float3 PerViewConstantBuffer_t_1_m3 : packoffset(c26);
	};
	
	ByteAddressBuffer g_CullBits : register(t30, space3);
	ByteAddressBuffer g_BarnLights : register(t31, space3);
	Texture2D<float4> g_bindless_Texture2D_float4[65536] : register(t46, space4);
	SamplerState g_bindless_Sampler[2048] : register(s29, space4);
	SamplerComparisonState g_bindless_Sampler_1[2048] : register(s29, space4);
	Texture3D<float4> g_bindless_Texture3D_float4[65536] : register(t46, space4);
	TextureCube<float4> g_bindless_TextureCube_float4[65536] : register(t46, space4);
	
	static float4 gl_FragCoord;
	static bool gl_FrontFacing;
	static float3 input_0;
	static float3 input_1;
	static float4 input_2;
	static float4 input_3;
	static float4 input_4;
	static float4 output_0;
	
	struct PS_INPUT
	{
	    float3 input_0 : TEXCOORD0;
	    float3 input_1 : TEXCOORD1;
	    float4 input_2 : TEXCOORD2;
	    centroid float4 input_3 : TEXCOORD3;
	    float4 input_4 : TEXCOORD4;
	    float4 gl_FragCoord : SV_Position;
	    bool gl_FrontFacing : SV_IsFrontFace;
	};
	
	struct PS_OUTPUT
	{
	    float4 output_0 : SV_Target0;
	};
	
	void MainPs_inner()
	{
	    float4 _11408 = gl_FragCoord;
	    _11408.w = 1.0f / _11408.w;
	    bool _14874 = _Globals_1_g_bRenderBackfaceNormals != 0;
	    bool _12885;
	    if (_14874)
	    {
	        _12885 = _Globals_1_g_bDontFlipBackfaceNormals == 0;
	    }
	    else
	    {
	        _12885 = false;
	    }
	    float3 _10251;
	    [branch]
	    if (_12885)
	    {
	        _10251 = input_1.xyz * (gl_FrontFacing ? 1.0f : (-1.0f));
	    }
	    else
	    {
	        _10251 = input_1.xyz;
	    }
	    float3 _24347 = normalize(_10251);
	    float3 _10061 = input_0 + PerViewConstantBufferCsgo_t_1_m19.xyz;
	    float4 _19414 = g_bindless_Texture2D_float4[_Globals_1_g_tColor].Sample(g_bindless_Sampler[_Globals_1_g_sUserConfig], input_2.xy);
	    float4 _19068 = g_bindless_Texture2D_float4[_Globals_1_g_tLayer1AmbientOcclusion].Sample(g_bindless_Sampler[_Globals_1_g_sTrilinearWrap], input_2.xy);
	    float4 _19372 = g_bindless_Texture2D_float4[_Globals_1_g_tLayer1NormalRoughness].Sample(g_bindless_Sampler[_Globals_1_g_sUserConfig], input_2.zw);
	    float _16000 = _19372.x;
	    float _19720 = _19372.y;
	    float _16783 = (_16000 + _19720) - 1.00392162799835205078125f;
	    float _11176 = _16000 - _19720;
	    float3 _8418 = normalize(float3(float2(_16783, _11176), (1.0f - abs(_16783)) - abs(_11176)));
	    bool _12886;
	    if (_14874)
	    {
	        _12886 = _Globals_1_g_bDontFlipBackfaceNormals == 0;
	    }
	    else
	    {
	        _12886 = false;
	    }
	    bool _24327;
	    if (_12886)
	    {
	        _24327 = !gl_FrontFacing;
	    }
	    else
	    {
	        _24327 = false;
	    }
	    float3 _12631 = input_1.xyz * (_24327 ? (-1.0f) : 1.0f);
	    float3 _14435 = cross(_12631.xyz, input_4.xyz) * ((input_4.w > 0.0f) ? 1.0f : (-1.0f));
	    float3 _7424;
	    if (bool4(PerViewConstantBufferCsgo_t_1_m2.x != int4(0, 0, 0, 0).x, PerViewConstantBufferCsgo_t_1_m2.y != int4(0, 0, 0, 0).y, PerViewConstantBufferCsgo_t_1_m2.z != int4(0, 0, 0, 0).z, PerViewConstantBufferCsgo_t_1_m2.w != int4(0, 0, 0, 0).w).w)
	    {
	        _7424 = -_14435;
	    }
	    else
	    {
	        _7424 = _14435;
	    }
	    float3 _20480;
	    if (!_24327)
	    {
	        float3 _7482 = _8418;
	        _7482.y = -_8418.y;
	        _20480 = _7482;
	    }
	    else
	    {
	        _20480 = _8418;
	    }
	    float3 _14786 = normalize((((input_4.xyz * _20480.x).xyz + (_7424.xyz * _20480.y)).xyz + (_12631.xyz * _20480.z)).xyz);
	    float3 _7978 = -_24347;
	    float3 _24735 = _14786.xyz;
	    float4 _23875 = float4(_24735, 1.0f);
	    bool4 _24465 = bool4(PerViewConstantBufferCsgo_t_1_m0.x != int4(0, 0, 0, 0).x, PerViewConstantBufferCsgo_t_1_m0.y != int4(0, 0, 0, 0).y, PerViewConstantBufferCsgo_t_1_m0.z != int4(0, 0, 0, 0).z, PerViewConstantBufferCsgo_t_1_m0.w != int4(0, 0, 0, 0).w);
	    float _21709;
	    if (_24465.x)
	    {
	        float3 _11394 = _24347.xyz;
	        float2 _11086 = ((floor(_11408.xy * PerViewConstantBufferCsgo_t_1_m9) * PerViewConstantBufferCsgo_t_1_m8.xy) + (PerViewConstantBufferCsgo_t_1_m8.xy * 0.5f)).xy;
	        float4 _18418 = g_bindless_Texture2D_float4[PerViewConstantBufferCsgo_t_1_m5].GatherRed(g_bindless_Sampler[_Globals_1_g_sCookieSampler], _11086).xyzw - _11408.zzzz;
	        float _18579 = _18418.w;
	        float _12013 = _18418.z;
	        bool _12285 = abs(_12013) < _18579;
	        float2 _23168;
	        if (_12285)
	        {
	            _23168 = float2(PerViewConstantBufferCsgo_t_1_m8.x, 0.0f);
	        }
	        else
	        {
	            _23168 = 0.0f.xx;
	        }
	        float _20965 = _12285 ? _12013 : _18579;
	        float _15372 = _18418.x;
	        bool _12286 = abs(_15372) < _20965;
	        float2 _23169;
	        if (_12286)
	        {
	            _23169 = float2(0.0f, PerViewConstantBufferCsgo_t_1_m8.y);
	        }
	        else
	        {
	            _23169 = _23168;
	        }
	        bool2 _13083 = (abs(_18418.y) < (_12286 ? _15372 : _20965)).xx;
	        float4 _10010 = normalize(float4(PerViewLightingConstantBufferGpu_t_1_m2.x * mad(dot(_7978, normalize(float3(PerViewLightingConstantBufferGpu_t_1_m1._m0[0].xy, 0.25f))), 0.5f, 0.5f), PerViewLightingConstantBufferGpu_t_1_m2.y * mad(dot(_7978, normalize(float3(PerViewLightingConstantBufferGpu_t_1_m1._m0[1].xy, 0.25f))), 0.5f, 0.5f), PerViewLightingConstantBufferGpu_t_1_m2.z * mad(dot(_7978, normalize(float3(PerViewLightingConstantBufferGpu_t_1_m1._m0[2].xy, 0.25f))), 0.5f, 0.5f), PerViewLightingConstantBufferGpu_t_1_m2.w * mad(dot(_7978, normalize(float3(PerViewLightingConstantBufferGpu_t_1_m1._m0[3].xy, 0.25f))), 0.5f, 0.5f)));
	        float4 _13232 = max(float4(dot(PerViewLightingConstantBufferGpu_t_1_m1._m0[0].xyz, _11394), dot(PerViewLightingConstantBufferGpu_t_1_m1._m0[1].xyz, _11394), dot(PerViewLightingConstantBufferGpu_t_1_m1._m0[2].xyz, _11394), dot(PerViewLightingConstantBufferGpu_t_1_m1._m0[3].xyz, _11394)).xyzw, 0.0f.xxxx) * normalize(clamp(((_10010 - max(max(_10010.x, _10010.y), max(_10010.z, _10010.w)).xxxx) + 0.20000000298023223876953125f.xxxx) * 5.0f.xxxx, 0.0f.xxxx, 1.0f.xxxx));
	        _21709 = (1.0f / (dot(_13232, 1.0f.xxxx) + PerViewLightingConstantBufferGpu_t_1_m3.x)) * (PerViewLightingConstantBufferGpu_t_1_m3.x + dot(_13232, g_bindless_Texture2D_float4[PerViewConstantBufferCsgo_t_1_m4].SampleLevel(g_bindless_Sampler[_Globals_1_g_sPointClamp], (_11086 + float2(_13083.x ? PerViewConstantBufferCsgo_t_1_m8.xy.x : _23169.x, _13083.y ? PerViewConstantBufferCsgo_t_1_m8.xy.y : _23169.y).xy).xy, 0.0f)));
	    }
	    else
	    {
	        _21709 = 1.0f;
	    }
	    float _21710;
	    [branch]
	    if (PerViewLightingConstantBufferGpu_t_1_m10 != 0)
	    {
	        int _23989;
	        int _10191;
	        float _13136;
	        float3 _14975;
	        int _13039 = 0;
	        for (;;)
	        {
	            if (!(_13039 < PerViewLightingConstantBufferGpu_t_1_m10))
	            {
	                _13136 = 1.0f;
	                _14975 = 0.0f.xxx;
	                _10191 = -1;
	                break;
	            }
	            float4 _18322 = mul(PerViewLightingConstantBufferGpu_t_1_m17._m0[_13039], float4(input_0.xyz, 1.0f));
	            float _12779 = _18322.x;
	            if (max(abs(_12779), abs(_18322.y)) < PerViewLightingConstantBufferGpu_t_1_m12[_13039])
	            {
	                float3 _19470 = float3(_12779, _18322.yz);
	                float2 _24804 = _19470.xy;
	                float2 _22193 = 1.0f.xx - clamp((abs(_24804) * PerViewLightingConstantBufferGpu_t_1_m14.xx) + PerViewLightingConstantBufferGpu_t_1_m13.xx, 0.0f.xx, 1.0f.xx);
	                float2 _20561 = (_24804 * PerViewLightingConstantBufferGpu_t_1_m18._m0[_13039].zw) + PerViewLightingConstantBufferGpu_t_1_m18._m0[_13039].xy;
	                float3 _20488 = _19470;
	                _20488.x = _20561.x;
	                _20488.y = _20561.y;
	                _13136 = clamp(_22193.x * _22193.y, 0.0f, 1.0f);
	                _14975 = _20488;
	                _10191 = _13039;
	                break;
	            }
	            _23989 = _13039 + 1;
	            _13039 = _23989;
	            continue;
	        }
	        float _19363;
	        if (_10191 >= 0)
	        {
	            float _18270 = g_bindless_Texture2D_float4[PerViewLightingConstantBufferGpu_t_1_m19].SampleCmpLevelZero(g_bindless_Sampler_1[_Globals_1_g_tShadowDepthBufferCmpSampler], _14975.xy, clamp(_14975.z + PerViewLightingConstantBufferGpu_t_1_m11, 0.0f, 1.0f));
	            float _12501;
	            [branch]
	            if (_13136 < 1.0f)
	            {
	                float _7934;
	                if (_10191 < (PerViewLightingConstantBufferGpu_t_1_m10 - 1))
	                {
	                    int _15335 = _10191 + 1;
	                    float4 _19671 = mul(PerViewLightingConstantBufferGpu_t_1_m17._m0[_15335], float4(input_0.xyz, 1.0f));
	                    float2 _20562 = (_19671.xy * PerViewLightingConstantBufferGpu_t_1_m18._m0[_15335].zw) + PerViewLightingConstantBufferGpu_t_1_m18._m0[_15335].xy;
	                    float3 _20489;
	                    _20489.x = _20562.x;
	                    _20489.y = _20562.y;
	                    _7934 = g_bindless_Texture2D_float4[PerViewLightingConstantBufferGpu_t_1_m19].SampleCmpLevelZero(g_bindless_Sampler_1[_Globals_1_g_tShadowDepthBufferCmpSampler], _20489.xy, clamp(_19671.z + PerViewLightingConstantBufferGpu_t_1_m11, 0.0f, 1.0f));
	                }
	                else
	                {
	                    _7934 = 1.0f;
	                }
	                _12501 = lerp(_7934, _18270, _13136);
	            }
	            else
	            {
	                _12501 = _18270;
	            }
	            _19363 = _12501;
	        }
	        else
	        {
	            _19363 = 1.0f;
	        }
	        float _13279 = lerp(_19363, 1.0f, clamp((distance(_10061.xyz, PerViewConstantBuffer_t_1_m3) * PerViewLightingConstantBufferGpu_t_1_m16) + PerViewLightingConstantBufferGpu_t_1_m15, 0.0f, 1.0f));
	        float _12502;
	        if (_24465.y)
	        {
	            _12502 = min(_13279, g_bindless_Texture2D_float4[PerViewConstantBufferCsgo_t_1_m6].SampleLevel(g_bindless_Sampler[_Globals_1_g_sTrilinearClamp], (_11408.xy * PerViewConstantBuffer_t_1_m2.xy).xy, 0.0f).z);
	        }
	        else
	        {
	            _12502 = _13279;
	        }
	        _21710 = _12502;
	    }
	    else
	    {
	        _21710 = 1.0f;
	    }
	    float3 _21711;
	    [branch]
	    if ((dot(PerViewLightingConstantBufferGpu_t_1_m8.xyz, _24735) * _21710) > 0.0f)
	    {
	        _21711 = PerViewLightingConstantBufferGpu_t_1_m4.xyz + (max(0.0f, dot(_14786.xyz, PerViewLightingConstantBufferGpu_t_1_m8.xyz)).xxx.xyz * (PerViewLightingConstantBufferGpu_t_1_m9.xyz * _21710).xyz);
	    }
	    else
	    {
	        _21711 = PerViewLightingConstantBufferGpu_t_1_m4.xyz;
	    }
	    bool4 _24466 = bool4(PerViewConstantBufferCsgo_t_1_m1.x != int4(0, 0, 0, 0).x, PerViewConstantBufferCsgo_t_1_m1.y != int4(0, 0, 0, 0).y, PerViewConstantBufferCsgo_t_1_m1.z != int4(0, 0, 0, 0).z, PerViewConstantBufferCsgo_t_1_m1.w != int4(0, 0, 0, 0).w);
	    bool _20060 = _24466.x;
	    float4 _19364;
	    if (_20060)
	    {
	        float4 _18621 = mul(PerViewConstantBufferCsgo_t_1_m7, float4(_10061.xyz, 1.0f).xyzw);
	        float _20176 = _18621.w;
	        float2 _11414 = _18621.xy / _20176.xx;
	        float4 _6651;
	        _6651.x = clamp(((_11414.x + 1.0f) * PerViewConstantBuffer_t_1_m1.x) * 0.5f, 0.0f, PerViewConstantBuffer_t_1_m1.x - 1.0f);
	        _6651.y = clamp(((1.0f - _11414.y) * PerViewConstantBuffer_t_1_m1.y) * 0.5f, 0.0f, PerViewConstantBuffer_t_1_m1.y - 1.0f);
	        _6651.w = _20176;
	        _19364 = _6651;
	    }
	    else
	    {
	        _19364 = _11408;
	    }
	    uint2 _12083 = uint2(_19364.xy - PerViewConstantBuffer_t_1_m0.xy) >> PerViewLightingConstantBufferGpu_t_1_m6.x.xx;
	    uint _10838 = PerViewLightingConstantBufferGpu_t_1_m5.y + (((_12083.y * PerViewLightingConstantBufferGpu_t_1_m6.y) + _12083.x) * PerViewLightingConstantBufferGpu_t_1_m5.z);
	    uint _23393 = PerViewLightingConstantBufferGpu_t_1_m5.x + (uint(clamp(_19364.w * PerViewLightingConstantBufferGpu_t_1_m7.x, 0.0f, PerViewLightingConstantBufferGpu_t_1_m7.y)) * PerViewLightingConstantBufferGpu_t_1_m5.z);
	    float3 _13155;
	    _13155 = _21711;
	    uint _21567;
	    float3 _13156;
	    uint _16208 = 0u;
	    for (;;)
	    {
	        if (!(_16208 < PerViewLightingConstantBufferGpu_t_1_m5.z))
	        {
	            break;
	        }
	        uint _14475 = WaveActiveBitOr(g_CullBits.Load((_10838 + _16208) * 4 + 0) & g_CullBits.Load((_23393 + _16208) * 4 + 0));
	        _13156 = _13155;
	        uint _20344;
	        float3 _12504;
	        uint _16209 = _14475;
	        for (;;)
	        {
	            if (!(_16209 != 0u))
	            {
	                break;
	            }
	            int _12608 = int(firstbitlow(_16209) + (_16208 * 32u));
	            _20344 = _16209 & (_16209 - 1u);
	            do
	            {
	                float4x4 _14097 = asfloat(uint4x4(g_BarnLights.Load(_12608 * 480 + 0), g_BarnLights.Load(_12608 * 480 + 16), g_BarnLights.Load(_12608 * 480 + 32), g_BarnLights.Load(_12608 * 480 + 48), g_BarnLights.Load(_12608 * 480 + 4), g_BarnLights.Load(_12608 * 480 + 20), g_BarnLights.Load(_12608 * 480 + 36), g_BarnLights.Load(_12608 * 480 + 52), g_BarnLights.Load(_12608 * 480 + 8), g_BarnLights.Load(_12608 * 480 + 24), g_BarnLights.Load(_12608 * 480 + 40), g_BarnLights.Load(_12608 * 480 + 56), g_BarnLights.Load(_12608 * 480 + 12), g_BarnLights.Load(_12608 * 480 + 28), g_BarnLights.Load(_12608 * 480 + 44), g_BarnLights.Load(_12608 * 480 + 60)));
	                float4 _24893 = mul(float4(input_0.xyz, 1.0f), _14097);
	                float3 _10521 = _24893.xyz / _24893.w.xxx;
	                float4 _22905;
	                _22905.x = _10521.x;
	                _22905.y = _10521.y;
	                float _21775 = _10521.z;
	                _22905.z = _21775;
	                float3 _21642 = _22905.xyz;
	                bool _7425;
	                if (all(bool3(_22905.xyz.x > float3(-1.0f, -1.0f, 0.0f).x, _22905.xyz.y > float3(-1.0f, -1.0f, 0.0f).y, _22905.xyz.z > float3(-1.0f, -1.0f, 0.0f).z)))
	                {
	                    _7425 = all(bool3(_22905.xyz.x < 1.0f.xxx.x, _22905.xyz.y < 1.0f.xxx.y, _22905.xyz.z < 1.0f.xxx.z));
	                }
	                else
	                {
	                    _7425 = false;
	                }
	                bool _12887;
	                if (!_7425)
	                {
	                    _12887 = true;
	                }
	                else
	                {
	                    float4x3 _16509 = asfloat(uint4x3(g_BarnLights.Load(_12608 * 480 + 272), g_BarnLights.Load(_12608 * 480 + 288), g_BarnLights.Load(_12608 * 480 + 304), g_BarnLights.Load(_12608 * 480 + 276), g_BarnLights.Load(_12608 * 480 + 292), g_BarnLights.Load(_12608 * 480 + 308), g_BarnLights.Load(_12608 * 480 + 280), g_BarnLights.Load(_12608 * 480 + 296), g_BarnLights.Load(_12608 * 480 + 312), g_BarnLights.Load(_12608 * 480 + 284), g_BarnLights.Load(_12608 * 480 + 300), g_BarnLights.Load(_12608 * 480 + 316)));
	                    float3 _6368 = abs(mul(float4(input_0.xyz, 1.0f), _16509).xyz);
	                    _12887 = !all(bool3(_6368.x <= 1.0f.xxx.x, _6368.y <= 1.0f.xxx.y, _6368.z <= 1.0f.xxx.z));
	                }
	                if (_12887)
	                {
	                    _12504 = _13156;
	                    break;
	                }
	                float _23571 = 2.0f * asfloat(g_BarnLights.Load4(_12608 * 480 + 176)).y;
	                float _18492 = (2.0f * asfloat(g_BarnLights.Load4(_12608 * 480 + 176)).z) * asfloat(g_BarnLights.Load4(_12608 * 480 + 176)).z;
	                float _14805 = 2.0f * asfloat(g_BarnLights.Load4(_12608 * 480 + 176)).x;
	                float _9058 = _14805 * asfloat(g_BarnLights.Load4(_12608 * 480 + 176)).y;
	                float _17330 = 2.0f * asfloat(g_BarnLights.Load4(_12608 * 480 + 176)).w;
	                float _19825 = _17330 * asfloat(g_BarnLights.Load4(_12608 * 480 + 176)).z;
	                float3 _16268 = float3(_9058 - _19825, (1.0f - (_14805 * asfloat(g_BarnLights.Load4(_12608 * 480 + 176)).x)) - _18492, (_23571 * asfloat(g_BarnLights.Load4(_12608 * 480 + 176)).z) + (_17330 * asfloat(g_BarnLights.Load4(_12608 * 480 + 176)).x)) * asfloat(g_BarnLights.Load3(_12608 * 480 + 192)).z;
	                float _21316;
	                if (asfloat(g_BarnLights.Load4(_12608 * 480 + 144)).z > 0.0f)
	                {
	                    _21316 = min(1.0f, _21775 * asfloat(g_BarnLights.Load4(_12608 * 480 + 144)).z);
	                }
	                else
	                {
	                    _21316 = 1.0f;
	                }
	                float _19667;
	                if (asfloat(g_BarnLights.Load4(_12608 * 480 + 144)).w > 0.0f)
	                {
	                    _19667 = _21316 * min(1.0f, (1.0f - _21775) * asfloat(g_BarnLights.Load4(_12608 * 480 + 144)).w);
	                }
	                else
	                {
	                    _19667 = _21316;
	                }
	                float3 _11179;
	                float _11633;
	                if (asfloat(g_BarnLights.Load4(_12608 * 480 + 128)).w != 0.0f)
	                {
	                    float3 _10017 = asfloat(g_BarnLights.Load4(_12608 * 480 + 128)).xyz - input_0.xyz;
	                    float _18345 = dot(_10017, _10017);
	                    float _17647 = sqrt(_18345);
	                    float3 _12302 = _10017 - _16268;
	                    float3 _10210;
	                    do
	                    {
	                        float3 _20229 = (_10017 + _16268) - _12302;
	                        float _25105 = dot(-_12302, _20229);
	                        if (_25105 <= 0.0f)
	                        {
	                            _10210 = _12302;
	                            break;
	                        }
	                        else
	                        {
	                            _10210 = _12302 + (_20229 * min(1.0f, _25105 / dot(_20229, _20229)));
	                            break;
	                        }
	                        break; // unreachable workaround
	                    } while(false);
	                    _11179 = _10017 / _17647.xxx;
	                    _11633 = ((_19667 * (asfloat(g_BarnLights.Load4(_12608 * 480 + 128)).w / max(_18345, asfloat(g_BarnLights.Load4(_12608 * 480 + 128)).w))) * clamp(asfloat(g_BarnLights.Load4(_12608 * 480 + 144)).x + (asfloat(g_BarnLights.Load4(_12608 * 480 + 144)).y * _17647), 0.0f, 1.0f)) * clamp(asfloat(g_BarnLights.Load3(_12608 * 480 + 192)).x + (asfloat(g_BarnLights.Load3(_12608 * 480 + 192)).y * dot(float3((1.0f - (_23571 * asfloat(g_BarnLights.Load4(_12608 * 480 + 176)).y)) - _18492, _9058 + _19825, (_14805 * asfloat(g_BarnLights.Load4(_12608 * 480 + 176)).z) - (_17330 * asfloat(g_BarnLights.Load4(_12608 * 480 + 176)).y)), normalize(_10210))), 0.0f, 1.0f);
	                }
	                else
	                {
	                    _11179 = asfloat(g_BarnLights.Load4(_12608 * 480 + 128)).xyz;
	                    _11633 = _19667;
	                }
	                float3 _17828 = (asfloat(g_BarnLights.Load4(_12608 * 480 + 160)).xyz * 1.0f).xyz * _11633;
	                bool _24419;
	                if (asfloat(g_BarnLights.Load4(_12608 * 480 + 208)).z > 0.0f)
	                {
	                    _24419 = !_20060;
	                }
	                else
	                {
	                    _24419 = false;
	                }
	                float3 _21548;
	                [branch]
	                if (asfloat(g_BarnLights.Load4(_12608 * 480 + 160)).w == 0.0f)
	                {
	                    float _10342;
	                    do
	                    {
	                        float2 _22154 = abs(_22905.xy);
	                        if (asfloat(g_BarnLights.Load4(_12608 * 480 + 224)).z == 0.0f)
	                        {
	                            _10342 = smoothstep(1.0f, asfloat(g_BarnLights.Load4(_12608 * 480 + 224)).x, _22154.x) * smoothstep(1.0f, asfloat(g_BarnLights.Load4(_12608 * 480 + 224)).y, _22154.y);
	                            break;
	                        }
	                        else
	                        {
	                            float _11473 = _22154.x;
	                            float _15266 = 2.0f / asfloat(g_BarnLights.Load4(_12608 * 480 + 224)).z;
	                            float _15019 = _22154.y;
	                            float _23041 = (-0.5f) * asfloat(g_BarnLights.Load4(_12608 * 480 + 224)).z;
	                            float _11981 = (asfloat(g_BarnLights.Load4(_12608 * 480 + 224)).x * asfloat(g_BarnLights.Load4(_12608 * 480 + 224)).y) * pow(max(pow(asfloat(g_BarnLights.Load4(_12608 * 480 + 224)).y * _11473, _15266) + pow(asfloat(g_BarnLights.Load4(_12608 * 480 + 224)).x * _15019, _15266), 1.1754943508222875079687365372222e-38f), _23041);
	                            float _16524 = pow(max(pow(_11473, _15266) + pow(_15019, _15266), 1.1754943508222875079687365372222e-38f), _23041);
	                            if (_11981 < _16524)
	                            {
	                                _10342 = smoothstep(_16524, _11981, 1.0f);
	                                break;
	                            }
	                            else
	                            {
	                                _10342 = float(_16524 > 1.0f);
	                                break;
	                            }
	                            break; // unreachable workaround
	                        }
	                        break; // unreachable workaround
	                    } while(false);
	                    _21548 = _17828.xyz * _10342;
	                }
	                else
	                {
	                    float3 _12503;
	                    if (asfloat(g_BarnLights.Load4(_12608 * 480 + 160)).w < 0.0f)
	                    {
	                        float4 _17795 = float4(-asfloat(g_BarnLights.Load4(_12608 * 480 + 176)).xyz, asfloat(g_BarnLights.Load4(_12608 * 480 + 176)).w);
	                        float4 _19008 = _17795.xyzw * float4(-1.0f, -1.0f, -1.0f, 1.0f);
	                        float3 _24989 = _19008.xyz;
	                        float3 _23629 = float4((-_11179).xyz, 0.0f).xyz;
	                        float _15156 = -dot(_23629, _24989);
	                        float3 _20479 = float4((_23629 * _19008.w) + cross(_23629, _24989), _15156).xyz;
	                        float3 _23592 = _17795.xyz;
	                        float3 _12170 = ((_20479 * asfloat(g_BarnLights.Load4(_12608 * 480 + 176)).w) + (_23592 * _15156)) + cross(_23592, _20479);
	                        float3 _14081 = float3(float2(atan2(_12170.y, -_12170.x) * 0.15915493667125701904296875f, acos(_12170.z) * 0.3183098733425140380859375f), -asfloat(g_BarnLights.Load4(_12608 * 480 + 160)).w);
	                        float2 _20564 = (_14081.xy * asfloat(g_BarnLights.Load4(_12608 * 480 + 224)).zw) + asfloat(g_BarnLights.Load4(_12608 * 480 + 224)).xy;
	                        float3 _20491 = _14081;
	                        _20491.x = _20564.x;
	                        _20491.y = _20564.y;
	                        _12503 = _17828.xyz * g_bindless_Texture3D_float4[PerViewLightingConstantBufferGpu_t_1_m20].SampleLevel(g_bindless_Sampler[_Globals_1_g_sTrilinearWrap], _20491.xyz, 0.0f).xyz;
	                    }
	                    else
	                    {
	                        float3 _13791 = float3(mad(_22905.xy, float2(0.5f, -0.5f), 0.5f.xx), asfloat(g_BarnLights.Load4(_12608 * 480 + 160)).w);
	                        float2 _20563 = (_13791.xy * asfloat(g_BarnLights.Load4(_12608 * 480 + 224)).zw) + asfloat(g_BarnLights.Load4(_12608 * 480 + 224)).xy;
	                        float3 _20490 = _13791;
	                        _20490.x = _20563.x;
	                        _20490.y = _20563.y;
	                        _12503 = _17828.xyz * g_bindless_Texture3D_float4[PerViewLightingConstantBufferGpu_t_1_m20].SampleLevel(g_bindless_Sampler[_Globals_1_g_sCookieSampler], _20490.xyz, 0.0f).xyz;
	                    }
	                    _21548 = _12503;
	                }
	                if (all(bool3(_21548.xyz.x == 0.0f.xxx.x, _21548.xyz.y == 0.0f.xxx.y, _21548.xyz.z == 0.0f.xxx.z)))
	                {
	                    _12504 = _13156;
	                    break;
	                }
	                float3 _19630;
	                if (_24419)
	                {
	                    float3 _19629;
	                    if ((g_BarnLights.Load(_12608 * 480 + 264) & 4u) != 0u)
	                    {
	                        float2 _6281 = _22905.yx * float2(1.0f, -1.0f);
	                        float3 _23714 = _21642;
	                        _23714.x = _6281.x;
	                        _23714.y = _6281.y;
	                        _19629 = _23714;
	                    }
	                    else
	                    {
	                        _19629 = _21642;
	                    }
	                    float3 _20482 = _21548.xyz * lerp(1.0f, g_bindless_Texture2D_float4[PerViewLightingConstantBufferGpu_t_1_m19].SampleCmpLevelZero(g_bindless_Sampler_1[_Globals_1_g_tShadowDepthBufferCmpSampler], float3(mad(_19629.xy, asfloat(g_BarnLights.Load4(_12608 * 480 + 208)).zw, asfloat(g_BarnLights.Load4(_12608 * 480 + 208)).xy), _19629.z).xy, clamp(_19629.z + PerViewLightingConstantBufferGpu_t_1_m11, 0.0f, 1.0f)), asfloat(g_BarnLights.Load(_12608 * 480 + 260)));
	                    float3 _16449 = _20482.xyz;
	                    if (all(bool3(_16449.x == 0.0f.xxx.x, _16449.y == 0.0f.xxx.y, _16449.z == 0.0f.xxx.z)))
	                    {
	                        _12504 = _13156;
	                        break;
	                    }
	                    _19630 = _20482;
	                }
	                else
	                {
	                    _19630 = _21548;
	                }
	                _12504 = _13156.xyz + (max(0.0f, dot(_14786.xyz, _11179.xyz)).xxx.xyz * _19630.xyz);
	                break;
	            } while(false);
	            _13156 = _12504;
	            _16209 = _20344;
	            continue;
	        }
	        _21567 = _16208 + 1u;
	        _13155 = _13156;
	        _16208 = _21567;
	        continue;
	    }
	    float3 _22686 = (_13155.xyz + (float3(dot(PerViewLightingConstantBufferGpu_t_1_m0._m0[0].xyzw, _23875), dot(PerViewLightingConstantBufferGpu_t_1_m0._m0[1].xyzw, _23875), dot(PerViewLightingConstantBufferGpu_t_1_m0._m0[2].xyzw, _23875)).xyz * (_21709 * _19068.x).xxx.xyz).xyz) * (((_19414.xyz * _Globals_1_g_vLayer1Tint.xyz).xyz * input_3.xyz).xyz * (1.0f - _Globals_1_g_flMetalness)).xyz;
	    float4 _11204 = float4(_22686, input_3.w);
	    _11204.x = _22686.x;
	    _11204.y = _22686.y;
	    _11204.z = _22686.z;
	    float4 _6805;
	    if (_Globals_1_g_bFogEnabled != 0)
	    {
	        float3 _21493;
	        float3 _10666 = _10061.xyz - PerViewConstantBuffer_t_1_m3.xyz;
	        float3 _9057 = _10666.xyz;
	        float3 _19340;
	        do
	        {
	            _21493 = _10666.xyz;
	            bool _12888;
	            if (dot(_21493, _21493) > PerViewConstantBufferCsgo_t_1_m13.x)
	            {
	                _12888 = (_10061.z * PerViewConstantBufferCsgo_t_1_m13.z) < PerViewConstantBufferCsgo_t_1_m13.y;
	            }
	            else
	            {
	                _12888 = false;
	            }
	            [branch]
	            if (_12888)
	            {
	                float2 _9342 = clamp(PerViewConstantBufferCsgo_t_1_m10.xy + (PerViewConstantBufferCsgo_t_1_m10.zw * float2(length(_21493), _10061.z)), 0.0f.xx, 1.0f.xx);
	                float _12872 = (pow(_9342.x, PerViewConstantBufferCsgo_t_1_m11.x) * pow(_9342.y, PerViewConstantBufferCsgo_t_1_m11.y)) * PerViewConstantBufferCsgo_t_1_m12.w;
	                _19340 = lerp(_11204.xyz, float4(PerViewConstantBufferCsgo_t_1_m12.xyz, _12872).xyz, _12872.xxx);
	                break;
	            }
	            _19340 = _11204.xyz;
	            break;
	        } while(false);
	        float4 _23944 = _11204;
	        _23944.x = _19340.x;
	        _23944.y = _19340.y;
	        _23944.z = _19340.z;
	        float3 _19341;
	        do
	        {
	            bool _12889;
	            if (dot(_9057, _9057) > PerViewConstantBufferCsgo_t_1_m17.x)
	            {
	                _12889 = (PerViewConstantBufferCsgo_t_1_m17.z * _10061.z) < PerViewConstantBufferCsgo_t_1_m17.y;
	            }
	            else
	            {
	                _12889 = false;
	            }
	            if (_12889)
	            {
	                float _14602 = clamp(pow(max(0.0f, (length(_21493) * PerViewConstantBufferCsgo_t_1_m14.y) + PerViewConstantBufferCsgo_t_1_m14.x), PerViewConstantBufferCsgo_t_1_m14.w), 0.0f, 1.0f) * clamp(pow(max(0.0f, (_10061.z * PerViewConstantBufferCsgo_t_1_m15.y) + PerViewConstantBufferCsgo_t_1_m15.x), PerViewConstantBufferCsgo_t_1_m15.z), 0.0f, 1.0f);
	                float _8892 = clamp(_14602, 0.0f, 1.0f) * PerViewConstantBufferCsgo_t_1_m17.w;
	                _19341 = lerp(_23944.xyz, float4((g_bindless_TextureCube_float4[PerViewConstantBufferCsgo_t_1_m3].SampleLevel(g_bindless_Sampler[_Globals_1_g_sTrilinearClamp], normalize(mul(float4(_9057, 0.0f), PerViewConstantBufferCsgo_t_1_m16).xyz).xyz, PerViewConstantBufferCsgo_t_1_m15.w * clamp(1.0f - (_14602 * PerViewConstantBufferCsgo_t_1_m14.z), 0.0f, 1.0f)) * PerViewConstantBufferCsgo_t_1_m18.x).xyz, _8892).xyz, _8892.xxx);
	                break;
	            }
	            _19341 = _23944.xyz;
	            break;
	        } while(false);
	        _23944.x = _19341.x;
	        _23944.y = _19341.y;
	        _23944.z = _19341.z;
	        _6805 = _23944;
	    }
	    else
	    {
	        _6805 = _11204;
	    }
	    output_0 = _6805;
	}
	
	PS_OUTPUT MainPs(PS_INPUT stage_input)
	{
	    gl_FragCoord = stage_input.gl_FragCoord;
	    gl_FragCoord.w = 1.0 / gl_FragCoord.w;
	    gl_FrontFacing = stage_input.gl_FrontFacing;
	    input_0 = stage_input.input_0;
	    input_1 = stage_input.input_1;
	    input_2 = stage_input.input_2;
	    input_3 = stage_input.input_3;
	    input_4 = stage_input.input_4;
	    MainPs_inner();
	    PS_OUTPUT stage_output;
	    stage_output.output_0 = output_0;
	    return stage_output;
	}
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
	
	BoolAttribute(BindlessResources, true);
	TextureAttribute(LightSim_DiffuseAlbedoTexture, g_tColor);
	TextureAttribute(RepresentativeTexture, g_tColor);
	TextureAttribute(LightSim_DiffuseAlbedoTexture1, g_tColor);
	TextureAttribute(RepresentativeTexture1, g_tColor);
	BoolAttribute(SupportsLightmapping, true);
	BoolAttribute(PerVertexLighting, true);
	BoolAttribute(overlay, F_OVERLAY || 0);
	BoolAttribute(NeedsLightProbe, true);
	BoolAttribute(DoNotCastShadows, F_DO_NOT_CAST_SHADOWS || 0);
	BoolAttribute(SupportsMappingDimensions, true);
	BoolAttribute(renderbackfaces, F_RENDER_BACKFACES || 0);
	
	#if (S_SPECULAR_DIRECT == 0)
		TextureAttribute(LightSim_Opacity_A, g_tColor);
	#endif
	#if (S_LAYERS == 0)
		TextureAttribute(LightSim_Opacity_A, g_tColor);
	#endif
	#if (S_DETAILBLENDMODE == 1)
		TextureAttribute(LightSim_DiffuseAlbedoTexture2, g_tLayer2Color);
		TextureAttribute(RepresentativeTexture2, g_tLayer2Color);
		BoolAttribute(NoZPrepass, F_DISABLE_Z_PREPASS || 0);
	#endif
	#if (S_ALPHA_TEST == 1)
		TextureAttribute(LightSim_Opacity_A, g_tColor);
		BoolAttribute(alphatest, true);
		FloatAttribute(_dummyReferenceAlphaTestReferenceInMainShader, g_flAlphaTestReference);
		FloatAttribute(_dummyReferenceAntiAliasedEdgeStrengthReferenceInMainShader, g_flAntiAliasedEdgeStrength);
		BoolAttribute(NoZPrepass, true);
		BoolAttribute(AlphaTestZPrepass, true);
	#endif
	#if (S_ALPHA_TEST == 0)
		BoolAttribute(NoZPrepass, F_DISABLE_Z_PREPASS || 0);
	#endif
	#if (S_MODE_TOOLS_VIS == 1)
		BoolAttribute(environmentmapped, true);
		BoolAttribute(environmentmappeddynamic, true);
	#endif
	#if (S_OVERLAY == 1)
		TextureAttribute(LightSim_Opacity_A, g_tColor);
	#endif
	#if (S_TRANSLUCENT == 0)
		TextureAttribute(LightSim_Opacity_A, g_tColor);
		BoolAttribute(alphatest, true);
		FloatAttribute(_dummyReferenceAlphaTestReferenceInMainShader, g_flAlphaTestReference);
		FloatAttribute(_dummyReferenceAntiAliasedEdgeStrengthReferenceInMainShader, g_flAntiAliasedEdgeStrength);
		BoolAttribute(NoZPrepass, true);
		BoolAttribute(AlphaTestZPrepass, true);
	#endif
	#if (S_OVERLAY == 0)
		TextureAttribute(LightSim_DiffuseAlbedoTexture2, g_tLayer2Color);
		TextureAttribute(RepresentativeTexture2, g_tLayer2Color);
		BoolAttribute(NoZPrepass, F_DISABLE_Z_PREPASS || 0);
	#endif
	#if (S_SPECULAR_INDIRECT == 1)
		BoolAttribute(environmentmapped, true);
		BoolAttribute(environmentmappeddynamic, true);
	#endif
	#if (S_SPECULAR_DIRECT == 1)
		BoolAttribute(environmentmapped, true);
		BoolAttribute(environmentmappeddynamic, true);
	#endif
	#if (S_LAYERS == 1)
		TextureAttribute(LightSim_DiffuseAlbedoTexture2, g_tLayer2Color);
		TextureAttribute(RepresentativeTexture2, g_tLayer2Color);
		BoolAttribute(NoZPrepass, F_DISABLE_Z_PREPASS || 0);
	#endif
	#if (S_DETAILTEXTURE == 2)
		TextureAttribute(LightSim_DiffuseAlbedoTexture2, g_tLayer2Color);
		TextureAttribute(RepresentativeTexture2, g_tLayer2Color);
		BoolAttribute(NoZPrepass, F_DISABLE_Z_PREPASS || 0);
	#endif
	#if (S_TRANSLUCENT == 1)
		TextureAttribute(LightSim_Opacity_A, g_tColor);
		BoolAttribute(translucent, true);
		BoolAttribute(NoZPrepass, F_DISABLE_Z_PREPASS || 0);
	#endif
	#if (S_DETAILBLENDMODE == 0)
		TextureAttribute(LightSim_Opacity_A, g_tColor);
	#endif
	#if (S_SPECULAR_INDIRECT == 0)
		TextureAttribute(LightSim_Opacity_A, g_tColor);
	#endif
	#if (S_MODE_TOOLS_VIS == 0)
		TextureAttribute(LightSim_Opacity_A, g_tColor);
	#endif
	
	// PSRS
	
	RenderState(BackStencilFunc, F_RENDER_BACKFACES ? 5 : 7);
	RenderState(BlendEnable, True);
	RenderState(BlendEnable0, True);
	RenderState(BlendEnable1, True);
	RenderState(BlendEnable2, True);
	RenderState(ColorWriteEnable0, 7);
	RenderState(CullMode, F_RENDER_BACKFACES ? None : Front);
	RenderState(CullMode, F_RENDER_BACKFACES ? None : Back);
	RenderState(DepthBias, -64);
	RenderState(DepthBiasClamp, 0);
	RenderState(DepthEnable, F_DISABLE_Z_BUFFERING ? False : True);
	RenderState(DepthFunc, Equal);
	RenderState(DepthWriteEnable, False);
	RenderState(DepthWriteEnable, F_DISABLE_Z_BUFFERING ? False : True);
	RenderState(DstBlend, F_ADDITIVE_BLEND ? One : InvSrcAlpha);
	RenderState(DstBlend0, One);
	RenderState(DstBlend1, One);
	RenderState(DstBlend2, One);
	RenderState(DstBlendAlpha0, One);
	RenderState(DstBlendAlpha1, One);
	RenderState(DstBlendAlpha2, One);
	RenderState(SlopeScaleDepthBias, 0);
	RenderState(SrcBlend0, One);
	RenderState(SrcBlend1, One);
	RenderState(SrcBlend2, One);
	RenderState(SrcBlendAlpha0, One);
	RenderState(SrcBlendAlpha1, One);
	RenderState(SrcBlendAlpha2, One);
	RenderState(StencilEnable, 1);
	RenderState(StencilFunc, 5);
	RenderState(StencilReadMask, 1);
	RenderState(StencilRef, 3);
	RenderState(StencilWriteMask, 254);
	
	#if (S_LAYERS == 0)
		RenderState(CullMode, F_RENDER_BACKFACES ? None : Front);
		RenderState(CullMode, F_RENDER_BACKFACES ? None : Back);
	#endif
	#if (S_ALPHA_TEST == 0)
		RenderState(CullMode, F_RENDER_BACKFACES ? None : Front);
		RenderState(CullMode, F_RENDER_BACKFACES ? None : Back);
	#endif
	#if (S_TRANSLUCENT == 0)
		RenderState(CullMode, F_RENDER_BACKFACES ? None : Front);
		RenderState(CullMode, F_RENDER_BACKFACES ? None : Back);
	#endif
	#if (S_OVERLAY == 0)
		RenderState(CullMode, F_RENDER_BACKFACES ? None : Front);
		RenderState(CullMode, F_RENDER_BACKFACES ? None : Back);
	#endif
	#if (S_LAYERS == 1)
		RenderState(CullMode, F_RENDER_BACKFACES ? None : Front);
		RenderState(CullMode, F_RENDER_BACKFACES ? None : Back);
		RenderState(DepthWriteEnable, F_DISABLE_Z_BUFFERING ? False : True);
	#endif
	#if (S_DETAILTEXTURE == 2)
		RenderState(CullMode, F_RENDER_BACKFACES ? None : Front);
		RenderState(CullMode, F_RENDER_BACKFACES ? None : Back);
		RenderState(DepthWriteEnable, F_DISABLE_Z_BUFFERING ? False : True);
	#endif
	#if (S_ALPHA_TEST == 1)
		RenderState(CullMode, F_RENDER_BACKFACES ? None : Front);
		RenderState(CullMode, F_RENDER_BACKFACES ? None : Back);
		RenderState(DepthWriteEnable, False);
	#endif
	#if (S_TRANSLUCENT == 1)
		RenderState(CullMode, F_RENDER_BACKFACES ? None : Front);
		RenderState(CullMode, F_RENDER_BACKFACES ? None : Back);
		RenderState(DepthWriteEnable, False);
	#endif
	#if (S_OVERLAY == 1)
		RenderState(CullMode, F_RENDER_BACKFACES ? None : Front);
		RenderState(CullMode, F_RENDER_BACKFACES ? None : Back);
		RenderState(DepthWriteEnable, False);
	#endif
	
	BoolAttribute(BindlessResources, true);
	
}

RTX
{
	StaticCombo( S_MODE_TOOLS_VIS, 0..1 );
	StaticCombo( S_SPECULAR_DIRECT, F_SPECULAR_DIRECT );
	StaticCombo( S_SPECULAR_INDIRECT, F_SPECULAR_INDIRECT );
	StaticCombo( S_LAYERS, F_LAYERS );
	StaticCombo( S_FANCY_BLENDING, F_FANCY_BLENDING );
	StaticCombo( S_DETAILTEXTURE, F_DETAILTEXTURE );
	StaticCombo( S_TEXTURETRANSFORMS, F_TEXTURETRANSFORMS );
	StaticCombo( S_ALPHA_TEST, F_ALPHA_TEST );
	StaticCombo( S_TRANSLUCENT, F_TRANSLUCENT );
	StaticCombo( S_DETAILBLENDMODE, F_DETAILBLENDMODE );
	StaticCombo( S_OVERLAY, F_OVERLAY );
	StaticCombo( S_METALNESS_TEXTURE, F_METALNESS_TEXTURE );
	StaticCombo( S_SHADER_QUALITY, 0..1 );
	StaticComboRule( Requires( S_MODE_TOOLS_VIS, S_SHADER_QUALITY ) );
	StaticComboRule( Allow0( S_SPECULAR_DIRECT, S_SPECULAR_INDIRECT ) );
	StaticComboRule( Allow0( S_OVERLAY ) );
	StaticComboRule( Allow0( S_MODE_TOOLS_VIS, S_SHADER_QUALITY ) );
	StaticComboRule( Allow1( S_ALPHA_TEST, S_TRANSLUCENT ) );
	StaticComboRule( Requires( S_SPECULAR_DIRECT, S_SPECULAR_INDIRECT ) );
	StaticComboRule( Requires( S_DETAILTEXTURE=2, S_LAYERS=1 ) );
	StaticComboRule( Requires( S_DETAILBLENDMODE, S_DETAILTEXTURE=2, S_LAYERS=1 ) );
	StaticComboRule( Requires( S_OVERLAY, S_TRANSLUCENT, S_ALPHA_TEST ) );
	StaticComboRule( Allow1( S_OVERLAY, S_LAYERS ) );
	StaticComboRule( Requires( S_TRANSLUCENT, S_LAYERS=0 ) );
	StaticComboRule( Requires( S_ALPHA_TEST, S_LAYERS=0 ) );
	DynamicCombo( D_COMPRESSED_NORMALS_AND_TANGENTS, 0..1 );
	DynamicCombo( D_CS_VERTEX_ANIMATION, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_VERTEX_STREAM, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_LIGHTMAP, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_PROBE, 0..1 );
	DynamicComboRule( Allow1( D_BAKED_LIGHTING_FROM_VERTEX_STREAM, D_BAKED_LIGHTING_FROM_LIGHTMAP ) );
	DynamicComboRule( Allow1( D_BAKED_LIGHTING_FROM_PROBE, D_BAKED_LIGHTING_FROM_VERTEX_STREAM, D_BAKED_LIGHTING_FROM_LIGHTMAP ) );
	DynamicComboRule( Allow0( D_BAKED_LIGHTING_FROM_PROBE, D_BAKED_LIGHTING_FROM_VERTEX_STREAM, D_BAKED_LIGHTING_FROM_LIGHTMAP ) );
	DynamicComboRule( Allow0( D_COMPRESSED_NORMALS_AND_TANGENTS, D_CS_VERTEX_ANIMATION ) );
	
	bool g_bAddBumpMaps < UiType(CheckBox); Expression(F_ADDBUMPMAPS || 0); >;
	bool g_bDontFlipBackfaceNormals < UiType(CheckBox); Expression(F_DONT_FLIP_BACKFACE_NORMALS || 0); >;
	bool g_bNoSpecularAtFullRoughness < UiType(CheckBox); Expression(F_NO_SPECULAR_AT_FULL_ROUGHNESS || 0); >;
	bool g_bRenderBackfaceNormals < UiType(CheckBox); Expression((F_RENDER_BACKFACES && 1) || 0); >;
	int g_nFancyBlendingMode < UiType(Slider); Expression(F_FANCY_BLENDING); >;
	Texture2D g_tBlendModulation < Channel(RGBA, Box(TextureBlendModulation), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tColor < Channel(RGB, ArtistDefined(TextureLayer1Color), Srgb); OutputFormat(DXT1); SrgbRead(true); >;
	Texture2D g_tColor < Channel(RGB, ArtistDefinedOrAlphaWeighted(TextureLayer1Color, TextureLayer1Translucency), Srgb); Channel(A, PreserveCoverage(TextureLayer1Translucency), Linear); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tColor < Channel(RGB, ArtistDefinedOrAlphaWeighted(TextureLayer1Color, TextureLayer1Translucency), Srgb); Channel(A, Box(TextureLayer1Translucency), Linear); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tLayer1Detail < Channel(RGB, Box(TextureLayer1Detail), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tLayer1NormalRoughness < Channel(RGBA, HemiOctIsoRoughness_RG_B(TextureLayer1Normal, TextureLayer1Roughness), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tLayer2Color < Channel(RGB, ArtistDefined(TextureLayer2Color), Srgb); OutputFormat(DXT1); SrgbRead(true); >;
	Texture2D g_tLayer2Detail < Channel(RGB, Box(TextureLayer2Detail), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tLayer2NormalRoughness < Channel(RGBA, HemiOctIsoRoughness_RG_B(TextureLayer2Normal, TextureLayer2Roughness), Linear); OutputFormat(BC7); SrgbRead(false); >;
	float4 g_vBlendModulateTexCoordXform0 < UiType(VectorText); Expression(v0 = (g_flBlendModulateTexCoordRotation*3.14159)/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v1*g_vBlendModulateTexCoordScale.x,-v2*g_vBlendModulateTexCoordScale.y,0,((g_vBlendModulateTexCoordCenter.x+g_vBlendModulateTexCoordOffset.x)+((v2*g_vBlendModulateTexCoordScale.y)*g_vBlendModulateTexCoordCenter.y))-((v1*g_vBlendModulateTexCoordScale.x)*g_vBlendModulateTexCoordCenter.x))); >;
	float4 g_vBlendModulateTexCoordXform1 < UiType(VectorText); Expression(v0 = (g_flBlendModulateTexCoordRotation*3.14159)/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v2*g_vBlendModulateTexCoordScale.x,v1*g_vBlendModulateTexCoordScale.y,0,((g_vBlendModulateTexCoordCenter.y+g_vBlendModulateTexCoordOffset.y)+((v2*g_vBlendModulateTexCoordScale.x)*g_vBlendModulateTexCoordCenter.x))-((v1*g_vBlendModulateTexCoordScale.y)*g_vBlendModulateTexCoordCenter.y))); >;
	float4 g_vLayer1NormalTexCoordXform0 < UiType(VectorText); Expression(v0 = (g_flLayer1NormalTexCoordRotation*3.14159)/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v1*g_vLayer1NormalTexCoordScale.x,-v2*g_vLayer1NormalTexCoordScale.y,0,((g_vLayer1NormalTexCoordCenter.x+g_vLayer1NormalTexCoordOffset.x)+((v2*g_vLayer1NormalTexCoordScale.y)*g_vLayer1NormalTexCoordCenter.y))-((v1*g_vLayer1NormalTexCoordScale.x)*g_vLayer1NormalTexCoordCenter.x))); >;
	float4 g_vLayer1NormalTexCoordXform1 < UiType(VectorText); Expression(v0 = (g_flLayer1NormalTexCoordRotation*3.14159)/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v2*g_vLayer1NormalTexCoordScale.x,v1*g_vLayer1NormalTexCoordScale.y,0,((g_vLayer1NormalTexCoordCenter.y+g_vLayer1NormalTexCoordOffset.y)+((v2*g_vLayer1NormalTexCoordScale.x)*g_vLayer1NormalTexCoordCenter.x))-((v1*g_vLayer1NormalTexCoordScale.y)*g_vLayer1NormalTexCoordCenter.y))); >;
	float4 g_vLayer1TexCoordXform0 < UiType(VectorText); Expression(v0 = (g_flLayer1TexCoordRotation*3.14159)/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v1*g_vLayer1TexCoordScale.x,-v2*g_vLayer1TexCoordScale.y,0,((g_vLayer1TexCoordCenter.x+g_vLayer1TexCoordOffset.x)+((v2*g_vLayer1TexCoordScale.y)*g_vLayer1TexCoordCenter.y))-((v1*g_vLayer1TexCoordScale.x)*g_vLayer1TexCoordCenter.x))); >;
	float4 g_vLayer1TexCoordXform1 < UiType(VectorText); Expression(v0 = (g_flLayer1TexCoordRotation*3.14159)/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v2*g_vLayer1TexCoordScale.x,v1*g_vLayer1TexCoordScale.y,0,((g_vLayer1TexCoordCenter.y+g_vLayer1TexCoordOffset.y)+((v2*g_vLayer1TexCoordScale.x)*g_vLayer1TexCoordCenter.x))-((v1*g_vLayer1TexCoordScale.y)*g_vLayer1TexCoordCenter.y))); >;
	float4 g_vLayer2NormalTexCoordXform0 < UiType(VectorText); Expression(v0 = (g_flLayer2NormalTexCoordRotation*3.14159)/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v1*g_vLayer2NormalTexCoordScale.x,-v2*g_vLayer2NormalTexCoordScale.y,0,((g_vLayer2NormalTexCoordCenter.x+g_vLayer2NormalTexCoordOffset.x)+((v2*g_vLayer2NormalTexCoordScale.y)*g_vLayer2NormalTexCoordCenter.y))-((v1*g_vLayer2NormalTexCoordScale.x)*g_vLayer2NormalTexCoordCenter.x))); >;
	float4 g_vLayer2NormalTexCoordXform1 < UiType(VectorText); Expression(v0 = (g_flLayer2NormalTexCoordRotation*3.14159)/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v2*g_vLayer2NormalTexCoordScale.x,v1*g_vLayer2NormalTexCoordScale.y,0,((g_vLayer2NormalTexCoordCenter.y+g_vLayer2NormalTexCoordOffset.y)+((v2*g_vLayer2NormalTexCoordScale.x)*g_vLayer2NormalTexCoordCenter.x))-((v1*g_vLayer2NormalTexCoordScale.y)*g_vLayer2NormalTexCoordCenter.y))); >;
	float4 g_vLayer2TexCoordXform0 < UiType(VectorText); Expression(v0 = (g_flLayer2TexCoordRotation*3.14159)/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v1*g_vLayer2TexCoordScale.x,-v2*g_vLayer2TexCoordScale.y,0,((g_vLayer2TexCoordCenter.x+g_vLayer2TexCoordOffset.x)+((v2*g_vLayer2TexCoordScale.y)*g_vLayer2TexCoordCenter.y))-((v1*g_vLayer2TexCoordScale.x)*g_vLayer2TexCoordCenter.x))); >;
	float4 g_vLayer2TexCoordXform1 < UiType(VectorText); Expression(v0 = (g_flLayer2TexCoordRotation*3.14159)/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v2*g_vLayer2TexCoordScale.x,v1*g_vLayer2TexCoordScale.y,0,((g_vLayer2TexCoordCenter.y+g_vLayer2TexCoordOffset.y)+((v2*g_vLayer2TexCoordScale.x)*g_vLayer2TexCoordCenter.x))-((v1*g_vLayer2TexCoordScale.y)*g_vLayer2TexCoordCenter.y))); >;
	
	// Blend Modulation
	CreateInputTexture2D(TextureBlendModulation, Linear, 8, "", "_blend", "Blend Modulation,20 / Texture,10 / 10", Default4(0.5, 0.5, 0.5, 0.5));
	float2 g_vBlendModulateTexCoordCenter < Default2(0.5, 0.5); UiType(VectorText); UiGroup("Blend Modulation,20 / Texture,10 / 20"); >;
	float2 g_vBlendModulateTexCoordScale < Default2(1, 1); Range2(0, 0, 100, 100); UiType(VectorText); UiGroup("Blend Modulation,20 / Texture,10 / 30"); >;
	float g_flBlendModulateTexCoordRotation < Range(-360, 360); UiType(Slider); UiGroup("Blend Modulation,20 / Texture,10 / 40"); >;
	float2 g_vBlendModulateTexCoordOffset < Range2(-1, -1, 1, 1); UiType(VectorText); UiGroup("Blend Modulation,20 / Texture,10 / 50"); >;
	float g_flBlendSoftness < Default(0.5); UiType(Slider); UiGroup("Blend Modulation,20 / Texture,10 / 60"); >;
	float g_flLayerBorderStrength < Default(0.5); UiType(Slider); UiGroup("Blend Modulation,20 / Texture,10 / 70"); >;
	float g_flLayerBorderOffset < Range(-1, 1); UiType(Slider); UiGroup("Blend Modulation,20 / Texture,10 / 80"); Expression(-this); >;
	float g_flLayerBorderSoftness < Default(0.5); UiType(Slider); UiGroup("Blend Modulation,20 / Texture,10 / 90"); >;
	float3 g_vLayerBorderTint < Default3(1, 1, 1); UiType(Color); UiGroup("Blend Modulation,20 / Texture,10 / 100"); Expression(SrgbGammaToLinear(this)); >;
	
	// PBR 1
	CreateInputTexture2D(TextureLayer1Color, Srgb, 8, "", "_color", "PBR 1,10 / Albedo,10 / 10", Default4(0.5, 0.5, 0.5, 0));
	CreateInputTexture2D(TextureLayer1Detail, Linear, 8, "Mod2XCenter", "_detail", "PBR 1,10 / Detail,70 / 10", Default4(1, 1, 1, 1));
	CreateInputTexture2D(TextureLayer1Normal, Linear, 8, "NormalizeNormals", "_normal", "PBR 1,10 / Normal,20 / 10", Default4(0.5, 0.5, 1, 0));
	CreateInputTexture2D(TextureLayer1Roughness, Linear, 8, "Inverse", "_rough", "PBR 1,10 / Roughness,30 / 10", Default4(0.5, 0.5, 0.5, 0));
	CreateInputTexture2D(TextureLayer1Translucency, Linear, 8, "", "_trans", "PBR 1,10 / Albedo Translucency,15 / 10", Default4(1, 1, 1, 0));
	float2 g_vLayer1DetailScale < Default2(4, 4); Range2(0, 0, 100, 100); UiType(VectorText); UiGroup("PBR 1,10 / Detail,70 / 15"); >;
	float4 g_vLayer1DetailTintAndBlend < Default4(1, 1, 1, 1); UiType(VectorText); UiGroup("PBR 1,10 / Detail,70 / 20"); >;
	float3 g_vLayer1Tint < Default3(1, 1, 1); UiType(Color); UiGroup("PBR 1,10 / Albedo,10 / 20"); Expression(SrgbGammaToLinear(this)); >;
	float2 g_vLayer1NormalTexCoordCenter < Default2(0.5, 0.5); UiType(VectorText); UiGroup("PBR 1,10 / Normal,20 / 30"); >;
	float2 g_vLayer1TexCoordCenter < Default2(0.5, 0.5); UiType(VectorText); UiGroup("PBR 1,10 / Albedo,10 / 30"); >;
	float2 g_vLayer1NormalTexCoordScale < Default2(1, 1); Range2(0, 0, 100, 100); UiType(VectorText); UiGroup("PBR 1,10 / Normal,20 / 40"); >;
	float2 g_vLayer1TexCoordScale < Default2(1, 1); Range2(0, 0, 100, 100); UiType(VectorText); UiGroup("PBR 1,10 / Albedo,10 / 40"); >;
	float g_flLayer1NormalTexCoordRotation < Range(-360, 360); UiType(Slider); UiGroup("PBR 1,10 / Normal,20 / 50"); >;
	float g_flLayer1TexCoordRotation < Range(-360, 360); UiType(Slider); UiGroup("PBR 1,10 / Albedo,10 / 50"); >;
	float2 g_vLayer1NormalTexCoordOffset < Range2(-1, -1, 1, 1); UiType(VectorText); UiGroup("PBR 1,10 / Normal,20 / 60"); >;
	float2 g_vLayer1TexCoordOffset < Range2(-1, -1, 1, 1); UiType(VectorText); UiGroup("PBR 1,10 / Albedo,10 / 60"); >;
	
	// PBR 2
	CreateInputTexture2D(TextureLayer2Color, Srgb, 8, "", "_color", "PBR 2,10 / Albedo,10 / 10", Default4(0.5, 0.5, 0.5, 0));
	CreateInputTexture2D(TextureLayer2Detail, Linear, 8, "Mod2XCenter", "_detail", "PBR 2,10 / Detail,70 / 10", Default4(1, 1, 1, 1));
	CreateInputTexture2D(TextureLayer2Normal, Linear, 8, "NormalizeNormals", "_normal", "PBR 2,10 / Normal,20 / 10", Default4(0.5, 0.5, 1, 0));
	CreateInputTexture2D(TextureLayer2Roughness, Linear, 8, "Inverse", "_rough", "PBR 2,10 / Roughness,30 / 10", Default4(0.5, 0.5, 0.5, 0));
	float2 g_vLayer2DetailScale < Default2(4, 4); Range2(0, 0, 100, 100); UiType(VectorText); UiGroup("PBR 2,10 / Detail,70 / 15"); >;
	float4 g_vLayer2DetailTintAndBlend < Default4(1, 1, 1, 1); UiType(VectorText); UiGroup("PBR 2,10 / Detail,70 / 20"); >;
	float3 g_vLayer2Tint < Default3(1, 1, 1); UiType(Color); UiGroup("PBR 2,10 / Albedo,10 / 20"); Expression(SrgbGammaToLinear(this)); >;
	float2 g_vLayer2NormalTexCoordCenter < Default2(0.5, 0.5); UiType(VectorText); UiGroup("PBR 2,10 / Normal,20 / 30"); >;
	float2 g_vLayer2TexCoordCenter < Default2(0.5, 0.5); UiType(VectorText); UiGroup("PBR 2,10 / Albedo,10 / 30"); >;
	float2 g_vLayer2NormalTexCoordScale < Default2(1, 1); Range2(0, 0, 100, 100); UiType(VectorText); UiGroup("PBR 2,10 / Normal,20 / 40"); >;
	float2 g_vLayer2TexCoordScale < Default2(1, 1); Range2(0, 0, 100, 100); UiType(VectorText); UiGroup("PBR 2,10 / Albedo,10 / 40"); >;
	float g_flLayer2NormalTexCoordRotation < Range(-360, 360); UiType(Slider); UiGroup("PBR 2,10 / Normal,20 / 50"); >;
	float g_flLayer2TexCoordRotation < Range(-360, 360); UiType(Slider); UiGroup("PBR 2,10 / Albedo,10 / 50"); >;
	float2 g_vLayer2NormalTexCoordOffset < Range2(-1, -1, 1, 1); UiType(VectorText); UiGroup("PBR 2,10 / Normal,20 / 60"); >;
	float2 g_vLayer2TexCoordOffset < Range2(-1, -1, 1, 1); UiType(VectorText); UiGroup("PBR 2,10 / Albedo,10 / 60"); >;
	
	// Translucent
	float g_flAlphaTestReference < Default(0.5); Range(0.01, 0.99); UiType(Slider); UiGroup("Translucent"); >;
	float g_flAntiAliasedEdgeStrength < Default(1); UiType(Slider); UiGroup("Translucent"); >;
	float g_flOpacityScale < Default(1); UiType(Slider); UiGroup("Translucent"); >;
	
	// Lighting
	float g_flMetalness < UiType(Slider); UiGroup("Lighting,30/Metalness/30"); >;
	
	// Color
	float3 g_vColorTint < Default3(1, 1, 1); UiType(Color); UiGroup("Color,10/20"); Expression(SrgbGammaToLinear(this)); >;
	float g_flVertexColorOpacityScale < Default(1); UiType(Slider); UiGroup("Color, 10/25"); >;
	float g_flModelTintAmount < Default(1); UiType(Slider); UiGroup("Color,10/30"); >;
	
	// Texture Address Mode
	int g_nTextureAddressModeU < UiOption("RsTextureAddressMode_t"); UiType(Enum); UiGroup("Texture Address Mode"); >;
	int g_nTextureAddressModeV < UiOption("RsTextureAddressMode_t"); UiType(Enum); UiGroup("Texture Address Mode"); >;
	
	#if (S_LAYERS == 1)
		Texture2D g_tColor < Channel(RGB, ArtistDefined(TextureLayer1Color), Srgb); OutputFormat(DXT1); SrgbRead(true); >;
	#endif
	#if (S_DETAILTEXTURE == 2)
		Texture2D g_tColor < Channel(RGB, ArtistDefined(TextureLayer1Color), Srgb); OutputFormat(DXT1); SrgbRead(true); >;
	#endif
	#if (S_ALPHA_TEST == 1)
		Texture2D g_tColor < Channel(RGB, ArtistDefinedOrAlphaWeighted(TextureLayer1Color, TextureLayer1Translucency), Srgb); Channel(A, PreserveCoverage(TextureLayer1Translucency), Linear); OutputFormat(BC7); SrgbRead(true); >;
	#endif
	#if (S_TRANSLUCENT == 1)
		Texture2D g_tColor < Channel(RGB, ArtistDefinedOrAlphaWeighted(TextureLayer1Color, TextureLayer1Translucency), Srgb); Channel(A, Box(TextureLayer1Translucency), Linear); OutputFormat(BC7); SrgbRead(true); >;
	#endif
	#if (S_DETAILBLENDMODE == 1)
		Texture2D g_tColor < Channel(RGB, ArtistDefined(TextureLayer1Color), Srgb); OutputFormat(DXT1); SrgbRead(true); >;
	#endif
	
	// SPIR-V reflection failed for backend HLSL:
	// Unsupported builtin in HLSL: 5326
	//
	// Re-attempting reflection with the GLSL backend.
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (56816 bytes), GLSL reflection with SPIRV-Cross by KhronosGroup
	
	#version 460
	#extension GL_EXT_shader_explicit_arithmetic_types_int16 : require
	#extension GL_EXT_shader_16bit_storage : require
	#if defined(GL_AMD_gpu_shader_half_float)
	#extension GL_AMD_gpu_shader_half_float : require
	#elif defined(GL_EXT_shader_explicit_arithmetic_types_float16)
	#extension GL_EXT_shader_explicit_arithmetic_types_float16 : require
	#else
	#error No extension available for FP16.
	#endif
	#extension GL_EXT_ray_tracing : require
	#extension GL_EXT_nonuniform_qualifier : require
	#if defined(GL_EXT_control_flow_attributes)
	#extension GL_EXT_control_flow_attributes : require
	#define SPIRV_CROSS_FLATTEN [[flatten]]
	#define SPIRV_CROSS_BRANCH [[dont_flatten]]
	#define SPIRV_CROSS_UNROLL [[unroll]]
	#define SPIRV_CROSS_LOOP [[dont_unroll]]
	#else
	#define SPIRV_CROSS_FLATTEN
	#define SPIRV_CROSS_BRANCH
	#define SPIRV_CROSS_UNROLL
	#define SPIRV_CROSS_LOOP
	#endif
	
	struct VS_INPUT
	{
	    vec3 vPositionOs;
	    vec2 vTexCoord;
	    vec3 vNormalOs;
	    vec4 vTangentUOs_flTangentVSign;
	    uvec4 vBlendIndices;
	    uint nInstanceIdx;
	};
	
	struct PackedRtxInstanceData_t_natural_logical
	{
	    uint nSrgbColor;
	    uint nTriangleGeometry;
	    uint nMaterialData;
	    uint nMaterialFlags_nInstanceFlags;
	    float fEmissiveBoost;
	    uint nInstanceFlags;
	    uint _pad1;
	    uint _pad2;
	};
	
	struct PackedRtxInstanceData_t_natural
	{
	    uint nSrgbColor;
	    uint nTriangleGeometry;
	    uint nMaterialData;
	    uint nMaterialFlags_nInstanceFlags;
	    float fEmissiveBoost;
	    uint nInstanceFlags;
	    uint _pad1;
	    uint _pad2;
	};
	
	struct _Array_natural_vector_int_4_8
	{
	    ivec4 data[8];
	};
	
	struct GeometryInfo_t_natural
	{
	    ivec4 m_nVertexAndIndexBuffers;
	    ivec4 m_nBufferBindOffsetBytes;
	    ivec4 m_nBufferStrideInBytes;
	    ivec4 m_vNormalFieldInfo;
	    ivec4 m_vTangentFieldInfo;
	    _Array_natural_vector_int_4_8 m_vTexCoordFieldInfo;
	    _Array_natural_vector_int_4_8 m_vColorFieldInfo;
	};
	
	struct BuiltInTriangleIntersectionAttributes
	{
	    vec2 barycentrics;
	};
	
	struct MaterialDataMinimal_t
	{
	    f16vec3 vNormalWs;
	    float16_t flMetalness;
	    f16vec3 vAlbedo;
	    float16_t flRoughness;
	    f16vec3 vEmissive;
	    float16_t flReflectance;
	    uint nMaterialTypeAndFlags;
	    f16vec4 vMaterialBits;
	};
	
	struct Payload_t
	{
	    vec3 vSmoothPositionWs;
	    vec3 vFaceNormalWs;
	    vec3 vInterpolatedNormalWs;
	    float flHitT;
	    float flOpacityRng;
	    int nInstance;
	    bool bFlippedNormal;
	    MaterialDataMinimal_t material;
	};
	
	vec4 _243;
	
	struct PayloadShadow_t
	{
	    float m_flVisibility;
	};
	
	layout(set = 3, binding = 35, std430) readonly buffer StructuredBuffer
	{
	    PackedRtxInstanceData_t_natural _member0[];
	} g_instanceBuffer;
	
	layout(set = 3, binding = 34, std430) readonly buffer g_MaterialData
	{
	    float _member0[];
	} g_MaterialData_1;
	
	layout(set = 3, binding = 34, std430) readonly buffer g_MaterialData_2
	{
	    uint _member0[];
	} g_MaterialData_3;
	
	layout(set = 3, binding = 34, std430) readonly buffer g_MaterialData_4
	{
	    int _member0[];
	} g_MaterialData_5;
	
	layout(set = 3, binding = 31, std430) readonly buffer g_Geometries
	{
	    GeometryInfo_t_natural _member0[];
	} g_Geometries_1;
	
	layout(set = 3, binding = 33, std430) readonly buffer g_Indices
	{
	    uint _member0[];
	} g_Indices_1[];
	
	layout(set = 3, binding = 32, std430) readonly buffer g_Vertices
	{
	    float _member0[];
	} g_Vertices_1[];
	
	layout(set = 3, binding = 32, std430) readonly buffer g_Vertices_2
	{
	    uint _member0[];
	} g_Vertices_3[];
	
	hitAttributeEXT BuiltInTriangleIntersectionAttributes attrs;
	layout(set = 4, binding = 46) uniform texture2D g_bindless_Texture2D_float4[65536];
	layout(set = 4, binding = 29) uniform sampler g_bindless_Sampler[2048];
	layout(location = 0) rayPayloadInEXT Payload_t payload;
	
	void main()
	{
	    PackedRtxInstanceData_t_natural_logical _398;
	    _398.nSrgbColor = g_instanceBuffer._member0[uint(gl_InstanceID)].nSrgbColor;
	    _398.nTriangleGeometry = g_instanceBuffer._member0[uint(gl_InstanceID)].nTriangleGeometry;
	    _398.nMaterialData = g_instanceBuffer._member0[uint(gl_InstanceID)].nMaterialData;
	    _398.nMaterialFlags_nInstanceFlags = g_instanceBuffer._member0[uint(gl_InstanceID)].nMaterialFlags_nInstanceFlags;
	    _398.fEmissiveBoost = g_instanceBuffer._member0[uint(gl_InstanceID)].fEmissiveBoost;
	    _398.nInstanceFlags = g_instanceBuffer._member0[uint(gl_InstanceID)].nInstanceFlags;
	    _398._pad1 = g_instanceBuffer._member0[uint(gl_InstanceID)]._pad1;
	    _398._pad2 = g_instanceBuffer._member0[uint(gl_InstanceID)]._pad2;
	    uint _270 = _398.nMaterialData;
	    vec3 _307 = vec3(g_MaterialData_1._member0[_270 / 4u], g_MaterialData_1._member0[(_270 + 4u) / 4u], g_MaterialData_1._member0[(_270 + 8u) / 4u]);
	    float _306 = g_MaterialData_1._member0[(_270 + 12u) / 4u];
	    float _305 = g_MaterialData_1._member0[(_270 + 16u) / 4u];
	    uint _304 = g_MaterialData_3._member0[(_270 + 48u) / 4u];
	    uint _303 = g_MaterialData_3._member0[(_270 + 56u) / 4u];
	    uint _302 = g_MaterialData_3._member0[(_270 + 60u) / 4u];
	    vec3 _301 = vec3(g_MaterialData_1._member0[(_270 + 80u) / 4u], g_MaterialData_1._member0[(_270 + 84u) / 4u], g_MaterialData_1._member0[(_270 + 88u) / 4u]);
	    bool _300 = g_MaterialData_5._member0[(_270 + 96u) / 4u] != 0;
	    bool _299 = g_MaterialData_5._member0[(_270 + 104u) / 4u] != 0;
	    bool _298 = g_MaterialData_5._member0[(_270 + 108u) / 4u] != 0;
	    float _297 = g_MaterialData_1._member0[(_270 + 196u) / 4u];
	    uvec3 _393;
	    do
	    {
	        if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes.w == 4)
	        {
	            uint _514 = (12u * uint(gl_PrimitiveID)) + uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes.w);
	            _393 = uvec3(g_Indices_1[g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._member0[_514 / 4u], g_Indices_1[g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._member0[(_514 + 4u) / 4u], g_Indices_1[g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._member0[(_514 + 8u) / 4u]);
	            break;
	        }
	        else
	        {
	            uint _487 = (6u * uint(gl_PrimitiveID)) + uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes.w);
	            uint _488 = _487 & 4294967292u;
	            uint _489 = _488 / 4u;
	            uint _493 = (_488 + 4u) / 4u;
	            uint _498 = (g_Indices_1[g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._member0[_489] & 4294901760u) >> uint(16);
	            uint _499 = g_Indices_1[g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._member0[_493] & 65535u;
	            uvec3 _394;
	            if (_487 == _488)
	            {
	                _394 = uvec3(g_Indices_1[g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._member0[_489] & 65535u, _498, _499);
	            }
	            else
	            {
	                _394 = uvec3(_498, _499, (g_Indices_1[g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._member0[_493] & 4294901760u) >> uint(16));
	            }
	            _393 = _394;
	            break;
	        }
	        break;
	    } while(false);
	    uint _58 = uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.x);
	    uvec3 _545 = (uvec3(uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes.x)) * _393) + uvec3(uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes.x));
	    vec3 _388[3];
	    uint _547 = _545.x;
	    _388[0] = vec3(g_Vertices_1[_58]._member0[_547 / 4u], g_Vertices_1[_58]._member0[(_547 + 4u) / 4u], g_Vertices_1[_58]._member0[(_547 + 8u) / 4u]);
	    uint _561 = _545.y;
	    _388[1] = vec3(g_Vertices_1[_58]._member0[_561 / 4u], g_Vertices_1[_58]._member0[(_561 + 4u) / 4u], g_Vertices_1[_58]._member0[(_561 + 8u) / 4u]);
	    uint _575 = _545.z;
	    _388[2] = vec3(g_Vertices_1[_58]._member0[_575 / 4u], g_Vertices_1[_58]._member0[(_575 + 4u) / 4u], g_Vertices_1[_58]._member0[(_575 + 8u) / 4u]);
	    int _389 = 0;
	    VS_INPUT vsInput[3];
	    for (;;)
	    {
	        if (!(_389 < 3))
	        {
	            break;
	        }
	        vsInput[_389].vPositionOs = _388[_389];
	        _389++;
	        continue;
	    }
	    vec2 _390[3];
	    _390[0] = vec2(0.0);
	    _390[1] = vec2(0.0);
	    _390[2] = vec2(0.0);
	    if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].y != 0)
	    {
	        ivec4 _387 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers;
	        uint _60 = uint(_387[g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].z]);
	        uint _626 = uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].z);
	        ivec4 _385 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes;
	        ivec4 _386 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes;
	        uvec3 _642 = (uvec3(uint(_385[_626])) * _393) + uvec3(uint(_386[_626]) + uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].x));
	        if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].y == 16)
	        {
	            uint _774 = _642.x;
	            _390[0] = vec2(g_Vertices_1[_60]._member0[_774 / 4u], g_Vertices_1[_60]._member0[(_774 + 4u) / 4u]);
	            uint _783 = _642.y;
	            _390[1] = vec2(g_Vertices_1[_60]._member0[_783 / 4u], g_Vertices_1[_60]._member0[(_783 + 4u) / 4u]);
	            uint _792 = _642.z;
	            _390[2] = vec2(g_Vertices_1[_60]._member0[_792 / 4u], g_Vertices_1[_60]._member0[(_792 + 4u) / 4u]);
	        }
	        else
	        {
	            if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].y == 34)
	            {
	                uint _745 = _642.x / 4u;
	                _390[0] = vec2(uint16BitsToFloat16(u16vec2(uvec2(g_Vertices_3[_60]._member0[_745], g_Vertices_3[_60]._member0[_745] >> uint(16)) & uvec2(65535u))));
	                uint _755 = _642.y / 4u;
	                _390[1] = vec2(uint16BitsToFloat16(u16vec2(uvec2(g_Vertices_3[_60]._member0[_755], g_Vertices_3[_60]._member0[_755] >> uint(16)) & uvec2(65535u))));
	                uint _765 = _642.z / 4u;
	                _390[2] = vec2(uint16BitsToFloat16(u16vec2(uvec2(g_Vertices_3[_60]._member0[_765], g_Vertices_3[_60]._member0[_765] >> uint(16)) & uvec2(65535u))));
	            }
	            else
	            {
	                if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].y == 37)
	                {
	                    uint _655 = _642.x / 4u;
	                    uint _658 = g_Vertices_3[_60]._member0[_655] & 65535u;
	                    int _384;
	                    if (_658 > 32767u)
	                    {
	                        _384 = int(4294901760u | _658);
	                    }
	                    else
	                    {
	                        _384 = int(_658);
	                    }
	                    uint _671 = (g_Vertices_3[_60]._member0[_655] & 4294901760u) >> uint(16);
	                    int _383;
	                    if (_671 > 32767u)
	                    {
	                        _383 = int(4294901760u | _671);
	                    }
	                    else
	                    {
	                        _383 = int(_671);
	                    }
	                    _390[0] = vec2(max(float(_384) * 3.0518509447574615478515625e-05, -1.0), max(float(_383) * 3.0518509447574615478515625e-05, -1.0));
	                    uint _685 = _642.y / 4u;
	                    uint _688 = g_Vertices_3[_60]._member0[_685] & 65535u;
	                    int _382;
	                    if (_688 > 32767u)
	                    {
	                        _382 = int(4294901760u | _688);
	                    }
	                    else
	                    {
	                        _382 = int(_688);
	                    }
	                    uint _701 = (g_Vertices_3[_60]._member0[_685] & 4294901760u) >> uint(16);
	                    int _381;
	                    if (_701 > 32767u)
	                    {
	                        _381 = int(4294901760u | _701);
	                    }
	                    else
	                    {
	                        _381 = int(_701);
	                    }
	                    _390[1] = vec2(max(float(_382) * 3.0518509447574615478515625e-05, -1.0), max(float(_381) * 3.0518509447574615478515625e-05, -1.0));
	                    uint _715 = _642.z / 4u;
	                    uint _718 = g_Vertices_3[_60]._member0[_715] & 65535u;
	                    int _380;
	                    if (_718 > 32767u)
	                    {
	                        _380 = int(4294901760u | _718);
	                    }
	                    else
	                    {
	                        _380 = int(_718);
	                    }
	                    uint _731 = (g_Vertices_3[_60]._member0[_715] & 4294901760u) >> uint(16);
	                    int _379;
	                    if (_731 > 32767u)
	                    {
	                        _379 = int(4294901760u | _731);
	                    }
	                    else
	                    {
	                        _379 = int(_731);
	                    }
	                    _390[2] = vec2(max(float(_380) * 3.0518509447574615478515625e-05, -1.0), max(float(_379) * 3.0518509447574615478515625e-05, -1.0));
	                }
	            }
	        }
	    }
	    _389 = 0;
	    for (;;)
	    {
	        if (!(_389 < 3))
	        {
	            break;
	        }
	        vsInput[_389].vTexCoord = _390[_389];
	        _389++;
	        continue;
	    }
	    vec3 _391[3];
	    vec4 _392[3];
	    do
	    {
	        if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.y != 0)
	        {
	            ivec4 _365 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers;
	            uint _64 = uint(_365[g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.z]);
	            uint _842 = uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.z);
	            ivec4 _363 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes;
	            ivec4 _364 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes;
	            uvec3 _858 = (uvec3(uint(_363[_842])) * _393) + uvec3(uint(_364[_842]) + uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.x));
	            if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.y == 6)
	            {
	                uint _1386 = _858.x;
	                _391[0] = vec3(g_Vertices_1[_64]._member0[_1386 / 4u], g_Vertices_1[_64]._member0[(_1386 + 4u) / 4u], g_Vertices_1[_64]._member0[(_1386 + 8u) / 4u]);
	                uint _1400 = _858.y;
	                _391[1] = vec3(g_Vertices_1[_64]._member0[_1400 / 4u], g_Vertices_1[_64]._member0[(_1400 + 4u) / 4u], g_Vertices_1[_64]._member0[(_1400 + 8u) / 4u]);
	                uint _1414 = _858.z;
	                _391[2] = vec3(g_Vertices_1[_64]._member0[_1414 / 4u], g_Vertices_1[_64]._member0[(_1414 + 4u) / 4u], g_Vertices_1[_64]._member0[(_1414 + 8u) / 4u]);
	            }
	            else
	            {
	                if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.y == 17)
	                {
	                    uint _1122 = _858.x;
	                    uvec2 _1130 = uvec2(g_Vertices_3[_64]._member0[_1122 / 4u], g_Vertices_3[_64]._member0[(_1122 + 4u) / 4u]);
	                    uint _1131 = _858.y;
	                    uvec2 _261 = uvec2(g_Vertices_3[_64]._member0[_1131 / 4u], g_Vertices_3[_64]._member0[(_1131 + 4u) / 4u]);
	                    uint _1140 = _858.z;
	                    uvec2 _260 = uvec2(g_Vertices_3[_64]._member0[_1140 / 4u], g_Vertices_3[_64]._member0[(_1140 + 4u) / 4u]);
	                    uint _1152 = _1130.x;
	                    uint _1160 = _1130.y;
	                    vec2 _1170 = ((vec2(float(_1152 & 65535u), float((_1152 >> 16u) & 65535u)) * vec2(1.525902189314365386962890625e-05)) * 2.0) - vec2(1.0);
	                    float _1171 = _1170.x;
	                    float _1176 = (1.0 - abs(_1171)) - abs(_1170.y);
	                    vec3 _1177 = vec3(_1171, _1170.y, _1176);
	                    float _1179 = saturate(-_1176);
	                    vec2 _1185 = _1170 + mix(vec2(_1179), vec2(-_1179), greaterThanEqual(_1170, vec2(0.0)));
	                    _1177.x = _1185.x;
	                    _1177.y = _1185.y;
	                    vec3 _367 = normalize(_1177);
	                    vec2 _1192 = ((vec2(float((_1160 >> uint(1)) & 32767u), float((_1160 >> 16u) & 32767u)) * vec2(3.0518509447574615478515625e-05)) * 2.0) - vec2(1.0);
	                    float _1193 = _1192.x;
	                    float _1198 = (1.0 - abs(_1193)) - abs(_1192.y);
	                    vec3 _1199 = vec3(_1193, _1192.y, _1198);
	                    float _1201 = saturate(-_1198);
	                    vec2 _1207 = _1192 + mix(vec2(_1201), vec2(-_1201), greaterThanEqual(_1192, vec2(0.0)));
	                    _1199.x = _1207.x;
	                    _1199.y = _1207.y;
	                    vec3 _366 = normalize(_1199);
	                    float _353;
	                    if ((_1160 & 1u) != 0u)
	                    {
	                        _353 = 1.0;
	                    }
	                    else
	                    {
	                        _353 = -1.0;
	                    }
	                    _391[0] = _367;
	                    _392[0].w = _353;
	                    _392[0].x = _366.x;
	                    _392[0].y = _366.y;
	                    _392[0].z = _366.z;
	                    vec2 _1249 = ((vec2(float(_261.x & 65535u), float((_261.x >> 16u) & 65535u)) * vec2(1.525902189314365386962890625e-05)) * 2.0) - vec2(1.0);
	                    float _1250 = _1249.x;
	                    float _1255 = (1.0 - abs(_1250)) - abs(_1249.y);
	                    vec3 _1256 = vec3(_1250, _1249.y, _1255);
	                    float _1258 = saturate(-_1255);
	                    vec2 _1264 = _1249 + mix(vec2(_1258), vec2(-_1258), greaterThanEqual(_1249, vec2(0.0)));
	                    _1256.x = _1264.x;
	                    _1256.y = _1264.y;
	                    vec3 _369 = normalize(_1256);
	                    vec2 _1271 = ((vec2(float((_261.y >> uint(1)) & 32767u), float((_261.y >> 16u) & 32767u)) * vec2(3.0518509447574615478515625e-05)) * 2.0) - vec2(1.0);
	                    float _1272 = _1271.x;
	                    float _1277 = (1.0 - abs(_1272)) - abs(_1271.y);
	                    vec3 _1278 = vec3(_1272, _1271.y, _1277);
	                    float _1280 = saturate(-_1277);
	                    vec2 _1286 = _1271 + mix(vec2(_1280), vec2(-_1280), greaterThanEqual(_1271, vec2(0.0)));
	                    _1278.x = _1286.x;
	                    _1278.y = _1286.y;
	                    vec3 _368 = normalize(_1278);
	                    float _352;
	                    if ((_261.y & 1u) != 0u)
	                    {
	                        _352 = 1.0;
	                    }
	                    else
	                    {
	                        _352 = -1.0;
	                    }
	                    _391[1] = _369;
	                    _392[1].w = _352;
	                    _392[1].x = _368.x;
	                    _392[1].y = _368.y;
	                    _392[1].z = _368.z;
	                    vec2 _1328 = ((vec2(float(_260.x & 65535u), float((_260.x >> 16u) & 65535u)) * vec2(1.525902189314365386962890625e-05)) * 2.0) - vec2(1.0);
	                    float _1329 = _1328.x;
	                    float _1334 = (1.0 - abs(_1329)) - abs(_1328.y);
	                    vec3 _1335 = vec3(_1329, _1328.y, _1334);
	                    float _1337 = saturate(-_1334);
	                    vec2 _1343 = _1328 + mix(vec2(_1337), vec2(-_1337), greaterThanEqual(_1328, vec2(0.0)));
	                    _1335.x = _1343.x;
	                    _1335.y = _1343.y;
	                    vec3 _371 = normalize(_1335);
	                    vec2 _1350 = ((vec2(float((_260.y >> uint(1)) & 32767u), float((_260.y >> 16u) & 32767u)) * vec2(3.0518509447574615478515625e-05)) * 2.0) - vec2(1.0);
	                    float _1351 = _1350.x;
	                    float _1356 = (1.0 - abs(_1351)) - abs(_1350.y);
	                    vec3 _1357 = vec3(_1351, _1350.y, _1356);
	                    float _1359 = saturate(-_1356);
	                    vec2 _1365 = _1350 + mix(vec2(_1359), vec2(-_1359), greaterThanEqual(_1350, vec2(0.0)));
	                    _1357.x = _1365.x;
	                    _1357.y = _1365.y;
	                    vec3 _370 = normalize(_1357);
	                    float _351;
	                    if ((_260.y & 1u) != 0u)
	                    {
	                        _351 = 1.0;
	                    }
	                    else
	                    {
	                        _351 = -1.0;
	                    }
	                    _391[2] = _371;
	                    _392[2].w = _351;
	                    _392[2].x = _370.x;
	                    _392[2].y = _370.y;
	                    _392[2].z = _370.z;
	                    break;
	                }
	                else
	                {
	                    uint _868 = _858.x / 4u;
	                    vec4 _373 = _392[0];
	                    float _883 = (float((g_Vertices_3[_64]._member0[_868] >> 12u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _886 = (float((g_Vertices_3[_64]._member0[_868] >> 22u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _890 = (1.0 - abs(_883)) - abs(_886);
	                    vec3 _891 = vec3(_883, _886, _890);
	                    float _893 = saturate(-_890);
	                    vec2 _894 = vec2(_883, _886);
	                    vec2 _900 = _894 + mix(vec2(_893), vec2(-_893), greaterThanEqual(_894, vec2(0.0)));
	                    _891.x = _900.x;
	                    _891.y = _900.y;
	                    vec3 _905 = normalize(_891);
	                    vec3 _372 = _905;
	                    float _906 = _905.z;
	                    float _360;
	                    if (_906 >= 0.0)
	                    {
	                        _360 = 1.0;
	                    }
	                    else
	                    {
	                        _360 = -1.0;
	                    }
	                    float _913 = (-1.0) / (_360 + _906);
	                    float _914 = _905.x;
	                    vec3 _361;
	                    vec3 _922 = _361;
	                    _922.x = 1.0 + (((_360 * _914) * _914) * _913);
	                    _922.y = _360 * ((_914 * _905.y) * _913);
	                    _922.z = (-_360) * _914;
	                    _361 = _922;
	                    float _930 = float((g_Vertices_3[_64]._member0[_868] >> uint(1)) & 2047u) * 0.003069460391998291015625;
	                    vec3 _936 = (_922 * cos(_930)) + (cross(_905, _922) * sin(_930));
	                    vec4 _938 = _373;
	                    _938.x = _936.x;
	                    _938.y = _936.y;
	                    _938.z = _936.z;
	                    _373 = _938;
	                    float _362;
	                    if ((g_Vertices_3[_64]._member0[_868] & 1u) == 0u)
	                    {
	                        _362 = -1.0;
	                    }
	                    else
	                    {
	                        _362 = 1.0;
	                    }
	                    vec4 _949 = _373;
	                    _949.w = _362;
	                    _373 = _949;
	                    _391[0] = _372;
	                    _392[0] = _949;
	                    uint _953 = _858.y / 4u;
	                    vec4 _375 = _392[1];
	                    float _968 = (float((g_Vertices_3[_64]._member0[_953] >> 12u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _971 = (float((g_Vertices_3[_64]._member0[_953] >> 22u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _975 = (1.0 - abs(_968)) - abs(_971);
	                    vec3 _976 = vec3(_968, _971, _975);
	                    float _978 = saturate(-_975);
	                    vec2 _979 = vec2(_968, _971);
	                    vec2 _985 = _979 + mix(vec2(_978), vec2(-_978), greaterThanEqual(_979, vec2(0.0)));
	                    _976.x = _985.x;
	                    _976.y = _985.y;
	                    vec3 _990 = normalize(_976);
	                    vec3 _374 = _990;
	                    float _991 = _990.z;
	                    float _357;
	                    if (_991 >= 0.0)
	                    {
	                        _357 = 1.0;
	                    }
	                    else
	                    {
	                        _357 = -1.0;
	                    }
	                    float _998 = (-1.0) / (_357 + _991);
	                    float _999 = _990.x;
	                    vec3 _358;
	                    vec3 _1007 = _358;
	                    _1007.x = 1.0 + (((_357 * _999) * _999) * _998);
	                    _1007.y = _357 * ((_999 * _990.y) * _998);
	                    _1007.z = (-_357) * _999;
	                    _358 = _1007;
	                    float _1015 = float((g_Vertices_3[_64]._member0[_953] >> uint(1)) & 2047u) * 0.003069460391998291015625;
	                    vec3 _1021 = (_1007 * cos(_1015)) + (cross(_990, _1007) * sin(_1015));
	                    vec4 _1023 = _375;
	                    _1023.x = _1021.x;
	                    _1023.y = _1021.y;
	                    _1023.z = _1021.z;
	                    _375 = _1023;
	                    float _359;
	                    if ((g_Vertices_3[_64]._member0[_953] & 1u) == 0u)
	                    {
	                        _359 = -1.0;
	                    }
	                    else
	                    {
	                        _359 = 1.0;
	                    }
	                    vec4 _1034 = _375;
	                    _1034.w = _359;
	                    _375 = _1034;
	                    _391[1] = _374;
	                    _392[1] = _1034;
	                    uint _1038 = _858.z / 4u;
	                    vec4 _377 = _392[2];
	                    float _1053 = (float((g_Vertices_3[_64]._member0[_1038] >> 12u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _1056 = (float((g_Vertices_3[_64]._member0[_1038] >> 22u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _1060 = (1.0 - abs(_1053)) - abs(_1056);
	                    vec3 _1061 = vec3(_1053, _1056, _1060);
	                    float _1063 = saturate(-_1060);
	                    vec2 _1064 = vec2(_1053, _1056);
	                    vec2 _1070 = _1064 + mix(vec2(_1063), vec2(-_1063), greaterThanEqual(_1064, vec2(0.0)));
	                    _1061.x = _1070.x;
	                    _1061.y = _1070.y;
	                    vec3 _1075 = normalize(_1061);
	                    vec3 _376 = _1075;
	                    float _1076 = _1075.z;
	                    float _354;
	                    if (_1076 >= 0.0)
	                    {
	                        _354 = 1.0;
	                    }
	                    else
	                    {
	                        _354 = -1.0;
	                    }
	                    float _1083 = (-1.0) / (_354 + _1076);
	                    float _1084 = _1075.x;
	                    vec3 _355;
	                    vec3 _1092 = _355;
	                    _1092.x = 1.0 + (((_354 * _1084) * _1084) * _1083);
	                    _1092.y = _354 * ((_1084 * _1075.y) * _1083);
	                    _1092.z = (-_354) * _1084;
	                    _355 = _1092;
	                    float _1100 = float((g_Vertices_3[_64]._member0[_1038] >> uint(1)) & 2047u) * 0.003069460391998291015625;
	                    vec3 _1106 = (_1092 * cos(_1100)) + (cross(_1075, _1092) * sin(_1100));
	                    vec4 _1108 = _377;
	                    _1108.x = _1106.x;
	                    _1108.y = _1106.y;
	                    _1108.z = _1106.z;
	                    _377 = _1108;
	                    float _356;
	                    if ((g_Vertices_3[_64]._member0[_1038] & 1u) == 0u)
	                    {
	                        _356 = -1.0;
	                    }
	                    else
	                    {
	                        _356 = 1.0;
	                    }
	                    vec4 _1119 = _377;
	                    _1119.w = _356;
	                    _377 = _1119;
	                    _391[2] = _376;
	                    _392[2] = _1119;
	                    break;
	                }
	                break;
	            }
	        }
	        else
	        {
	            _391[0] = vec3(0.0);
	            _391[1] = vec3(0.0);
	            _391[2] = vec3(0.0);
	        }
	        if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTangentFieldInfo.y != 0)
	        {
	            ivec4 _378 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers;
	            uint _68 = uint(_378[g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTangentFieldInfo.z]);
	            uint _1442 = uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTangentFieldInfo.z);
	            ivec4 _349 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes;
	            ivec4 _350 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes;
	            uvec3 _1458 = (uvec3(uint(_349[_1442])) * _393) + uvec3(uint(_350[_1442]) + uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTangentFieldInfo.x));
	            uint _1460 = _1458.x;
	            _392[0] = vec4(g_Vertices_1[_68]._member0[_1460 / 4u], g_Vertices_1[_68]._member0[(_1460 + 4u) / 4u], g_Vertices_1[_68]._member0[(_1460 + 8u) / 4u], g_Vertices_1[_68]._member0[(_1460 + 12u) / 4u]);
	            uint _1478 = _1458.y;
	            _392[1] = vec4(g_Vertices_1[_68]._member0[_1478 / 4u], g_Vertices_1[_68]._member0[(_1478 + 4u) / 4u], g_Vertices_1[_68]._member0[(_1478 + 8u) / 4u], g_Vertices_1[_68]._member0[(_1478 + 12u) / 4u]);
	            uint _1496 = _1458.z;
	            _392[2] = vec4(g_Vertices_1[_68]._member0[_1496 / 4u], g_Vertices_1[_68]._member0[(_1496 + 4u) / 4u], g_Vertices_1[_68]._member0[(_1496 + 8u) / 4u], g_Vertices_1[_68]._member0[(_1496 + 12u) / 4u]);
	        }
	        else
	        {
	            _392[0] = vec4(0.0);
	            _392[1] = vec4(0.0);
	            _392[2] = vec4(0.0);
	        }
	        break;
	    } while(false);
	    _389 = 0;
	    for (;;)
	    {
	        if (!(_389 < 3))
	        {
	            break;
	        }
	        vsInput[_389].vNormalOs = _391[_389];
	        vsInput[_389].vTangentUOs_flTangentVSign = _392[_389];
	        _389++;
	        continue;
	    }
	    vec2 _269 = vsInput[0].vTexCoord;
	    vec3 _347 = vsInput[0].vNormalOs;
	    vec4 _348;
	    vec4 _1542 = _348;
	    _1542.x = vsInput[0].vTangentUOs_flTangentVSign.x;
	    _1542.y = vsInput[0].vTangentUOs_flTangentVSign.y;
	    _1542.z = vsInput[0].vTangentUOs_flTangentVSign.z;
	    _1542.w = vsInput[0].vTangentUOs_flTangentVSign.w;
	    _348 = _1542;
	    PackedRtxInstanceData_t_natural_logical _1555;
	    _1555.nSrgbColor = g_instanceBuffer._member0[uint(gl_InstanceID)].nSrgbColor;
	    _1555.nTriangleGeometry = g_instanceBuffer._member0[uint(gl_InstanceID)].nTriangleGeometry;
	    _1555.nMaterialData = g_instanceBuffer._member0[uint(gl_InstanceID)].nMaterialData;
	    _1555.nMaterialFlags_nInstanceFlags = g_instanceBuffer._member0[uint(gl_InstanceID)].nMaterialFlags_nInstanceFlags;
	    _1555.fEmissiveBoost = g_instanceBuffer._member0[uint(gl_InstanceID)].fEmissiveBoost;
	    _1555.nInstanceFlags = g_instanceBuffer._member0[uint(gl_InstanceID)].nInstanceFlags;
	    _1555._pad1 = g_instanceBuffer._member0[uint(gl_InstanceID)]._pad1;
	    _1555._pad2 = g_instanceBuffer._member0[uint(gl_InstanceID)]._pad2;
	    vec4 _1566 = vec4(uvec4(_1555.nSrgbColor & 255u, (_1555.nSrgbColor & 65280u) >> uint(8), (_1555.nSrgbColor & 16711680u) >> uint(16), (_1555.nSrgbColor & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	    vec4 _346 = _1566;
	    vec3 _1567 = _1566.xyz;
	    vec3 _1568 = _1567 * vec3(0.077399380505084991455078125);
	    vec3 _1571 = pow((_1567 * vec3(0.947867333889007568359375)) + vec3(0.052132703363895416259765625), vec3(2.400000095367431640625));
	    float _343;
	    if (_1566.x <= 0.040449999272823333740234375)
	    {
	        _343 = _1568.x;
	    }
	    else
	    {
	        _343 = _1571.x;
	    }
	    float _344;
	    if (_1566.y <= 0.040449999272823333740234375)
	    {
	        _344 = _1568.y;
	    }
	    else
	    {
	        _344 = _1571.y;
	    }
	    float _345;
	    if (_1566.z <= 0.040449999272823333740234375)
	    {
	        _345 = _1568.z;
	    }
	    else
	    {
	        _345 = _1571.z;
	    }
	    vec3 _1596 = vec3(_343, _344, _345);
	    vec4 _1598 = _346;
	    _1598.x = _1596.x;
	    _1598.y = _1596.y;
	    _1598.z = _1596.z;
	    _346 = _1598;
	    vec4 _272;
	    vec4 _1605 = _272;
	    _1605.x = _1598.x;
	    _1605.y = _1598.y;
	    _1605.z = _1598.z;
	    _1605.w = _1598.w;
	    _272 = _1605;
	    mat3x4 _1616 = transpose(gl_WorldToObjectEXT);
	    mat3 _342;
	    mat3 _1619 = _342;
	    _1619[0] = _1616[0].xyz;
	    _1619[1] = _1616[1].xyz;
	    _1619[2] = _1616[2].xyz;
	    _342 = _1619;
	    vec3 _1628 = normalize(_1619 * _347.xyz);
	    vec3 _273;
	    vec3 _1630 = _273;
	    _1630.x = _1628.x;
	    _1630.y = _1628.y;
	    _1630.z = _1628.z;
	    _273 = _1630;
	    mat3x4 _1642 = transpose(gl_WorldToObjectEXT);
	    mat3 _341;
	    mat3 _1645 = _341;
	    _1645[0] = _1642[0].xyz;
	    _1645[1] = _1642[1].xyz;
	    _1645[2] = _1642[2].xyz;
	    _341 = _1645;
	    vec3 _1654 = normalize(_1645 * _348.xyz);
	    vec4 _271;
	    vec4 _1656 = _271;
	    _1656.x = _1654.x;
	    _1656.y = _1654.y;
	    _1656.z = _1654.z;
	    _1656.w = _348.w;
	    _271 = _1656;
	    vec4 _1665 = _269.xyxy;
	    _1665.z = _269.x;
	    _1665.w = _269.y;
	    vec3 _1673 = mix(vec3(1.0), _1605.xyz, vec3(_305));
	    vec4 _1675 = _1605;
	    _1675.x = _1673.x;
	    _1675.y = _1673.y;
	    _1675.z = _1673.z;
	    vec3 _1683 = _1675.xyz * _307.xyz;
	    vec4 _1685 = _1675;
	    _1685.x = _1683.x;
	    _1685.y = _1683.y;
	    _1685.z = _1683.z;
	    _1685.w = _1685.w * _306;
	    vec3 _259 = vec4(vsInput[0].vPositionOs.xyz, 1.0) * transpose(gl_ObjectToWorldEXT);
	    vec3 _258 = _1630;
	    vec4 _257 = _1665;
	    vec4 _256 = _1685;
	    vec4 _255 = _1656;
	    vec2 _268 = vsInput[1].vTexCoord;
	    vec3 _339 = vsInput[1].vNormalOs;
	    vec4 _340;
	    vec4 _1701 = _340;
	    _1701.x = vsInput[1].vTangentUOs_flTangentVSign.x;
	    _1701.y = vsInput[1].vTangentUOs_flTangentVSign.y;
	    _1701.z = vsInput[1].vTangentUOs_flTangentVSign.z;
	    _1701.w = vsInput[1].vTangentUOs_flTangentVSign.w;
	    _340 = _1701;
	    PackedRtxInstanceData_t_natural_logical _1714;
	    _1714.nSrgbColor = g_instanceBuffer._member0[uint(gl_InstanceID)].nSrgbColor;
	    _1714.nTriangleGeometry = g_instanceBuffer._member0[uint(gl_InstanceID)].nTriangleGeometry;
	    _1714.nMaterialData = g_instanceBuffer._member0[uint(gl_InstanceID)].nMaterialData;
	    _1714.nMaterialFlags_nInstanceFlags = g_instanceBuffer._member0[uint(gl_InstanceID)].nMaterialFlags_nInstanceFlags;
	    _1714.fEmissiveBoost = g_instanceBuffer._member0[uint(gl_InstanceID)].fEmissiveBoost;
	    _1714.nInstanceFlags = g_instanceBuffer._member0[uint(gl_InstanceID)].nInstanceFlags;
	    _1714._pad1 = g_instanceBuffer._member0[uint(gl_InstanceID)]._pad1;
	    _1714._pad2 = g_instanceBuffer._member0[uint(gl_InstanceID)]._pad2;
	    vec4 _1725 = vec4(uvec4(_1714.nSrgbColor & 255u, (_1714.nSrgbColor & 65280u) >> uint(8), (_1714.nSrgbColor & 16711680u) >> uint(16), (_1714.nSrgbColor & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	    vec4 _338 = _1725;
	    vec3 _1726 = _1725.xyz;
	    vec3 _1727 = _1726 * vec3(0.077399380505084991455078125);
	    vec3 _1730 = pow((_1726 * vec3(0.947867333889007568359375)) + vec3(0.052132703363895416259765625), vec3(2.400000095367431640625));
	    float _335;
	    if (_1725.x <= 0.040449999272823333740234375)
	    {
	        _335 = _1727.x;
	    }
	    else
	    {
	        _335 = _1730.x;
	    }
	    float _336;
	    if (_1725.y <= 0.040449999272823333740234375)
	    {
	        _336 = _1727.y;
	    }
	    else
	    {
	        _336 = _1730.y;
	    }
	    float _337;
	    if (_1725.z <= 0.040449999272823333740234375)
	    {
	        _337 = _1727.z;
	    }
	    else
	    {
	        _337 = _1730.z;
	    }
	    vec3 _1755 = vec3(_335, _336, _337);
	    vec4 _1757 = _338;
	    _1757.x = _1755.x;
	    _1757.y = _1755.y;
	    _1757.z = _1755.z;
	    _338 = _1757;
	    vec4 _275;
	    vec4 _1764 = _275;
	    _1764.x = _1757.x;
	    _1764.y = _1757.y;
	    _1764.z = _1757.z;
	    _1764.w = _1757.w;
	    _275 = _1764;
	    mat3x4 _1775 = transpose(gl_WorldToObjectEXT);
	    mat3 _334;
	    mat3 _1778 = _334;
	    _1778[0] = _1775[0].xyz;
	    _1778[1] = _1775[1].xyz;
	    _1778[2] = _1775[2].xyz;
	    _334 = _1778;
	    vec3 _1787 = normalize(_1778 * _339.xyz);
	    vec3 _276;
	    vec3 _1789 = _276;
	    _1789.x = _1787.x;
	    _1789.y = _1787.y;
	    _1789.z = _1787.z;
	    _276 = _1789;
	    mat3x4 _1801 = transpose(gl_WorldToObjectEXT);
	    mat3 _333;
	    mat3 _1804 = _333;
	    _1804[0] = _1801[0].xyz;
	    _1804[1] = _1801[1].xyz;
	    _1804[2] = _1801[2].xyz;
	    _333 = _1804;
	    vec3 _1813 = normalize(_1804 * _340.xyz);
	    vec4 _274;
	    vec4 _1815 = _274;
	    _1815.x = _1813.x;
	    _1815.y = _1813.y;
	    _1815.z = _1813.z;
	    _1815.w = _340.w;
	    _274 = _1815;
	    vec4 _1824 = _268.xyxy;
	    _1824.z = _268.x;
	    _1824.w = _268.y;
	    vec3 _1832 = mix(vec3(1.0), _1764.xyz, vec3(_305));
	    vec4 _1834 = _1764;
	    _1834.x = _1832.x;
	    _1834.y = _1832.y;
	    _1834.z = _1832.z;
	    vec3 _1842 = _1834.xyz * _307.xyz;
	    vec4 _1844 = _1834;
	    _1844.x = _1842.x;
	    _1844.y = _1842.y;
	    _1844.z = _1842.z;
	    _1844.w = _1844.w * _306;
	    vec3 _254 = vec4(vsInput[1].vPositionOs.xyz, 1.0) * transpose(gl_ObjectToWorldEXT);
	    vec3 _253 = _1789;
	    vec4 _252 = _1824;
	    vec4 _251 = _1844;
	    vec4 _250 = _1815;
	    vec2 _267 = vsInput[2].vTexCoord;
	    vec3 _331 = vsInput[2].vNormalOs;
	    vec4 _332;
	    vec4 _1860 = _332;
	    _1860.x = vsInput[2].vTangentUOs_flTangentVSign.x;
	    _1860.y = vsInput[2].vTangentUOs_flTangentVSign.y;
	    _1860.z = vsInput[2].vTangentUOs_flTangentVSign.z;
	    _1860.w = vsInput[2].vTangentUOs_flTangentVSign.w;
	    _332 = _1860;
	    PackedRtxInstanceData_t_natural_logical _1873;
	    _1873.nSrgbColor = g_instanceBuffer._member0[uint(gl_InstanceID)].nSrgbColor;
	    _1873.nTriangleGeometry = g_instanceBuffer._member0[uint(gl_InstanceID)].nTriangleGeometry;
	    _1873.nMaterialData = g_instanceBuffer._member0[uint(gl_InstanceID)].nMaterialData;
	    _1873.nMaterialFlags_nInstanceFlags = g_instanceBuffer._member0[uint(gl_InstanceID)].nMaterialFlags_nInstanceFlags;
	    _1873.fEmissiveBoost = g_instanceBuffer._member0[uint(gl_InstanceID)].fEmissiveBoost;
	    _1873.nInstanceFlags = g_instanceBuffer._member0[uint(gl_InstanceID)].nInstanceFlags;
	    _1873._pad1 = g_instanceBuffer._member0[uint(gl_InstanceID)]._pad1;
	    _1873._pad2 = g_instanceBuffer._member0[uint(gl_InstanceID)]._pad2;
	    vec4 _1884 = vec4(uvec4(_1873.nSrgbColor & 255u, (_1873.nSrgbColor & 65280u) >> uint(8), (_1873.nSrgbColor & 16711680u) >> uint(16), (_1873.nSrgbColor & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	    vec4 _330 = _1884;
	    vec3 _1885 = _1884.xyz;
	    vec3 _1886 = _1885 * vec3(0.077399380505084991455078125);
	    vec3 _1889 = pow((_1885 * vec3(0.947867333889007568359375)) + vec3(0.052132703363895416259765625), vec3(2.400000095367431640625));
	    float _327;
	    if (_1884.x <= 0.040449999272823333740234375)
	    {
	        _327 = _1886.x;
	    }
	    else
	    {
	        _327 = _1889.x;
	    }
	    float _328;
	    if (_1884.y <= 0.040449999272823333740234375)
	    {
	        _328 = _1886.y;
	    }
	    else
	    {
	        _328 = _1889.y;
	    }
	    float _329;
	    if (_1884.z <= 0.040449999272823333740234375)
	    {
	        _329 = _1886.z;
	    }
	    else
	    {
	        _329 = _1889.z;
	    }
	    vec3 _1914 = vec3(_327, _328, _329);
	    vec4 _1916 = _330;
	    _1916.x = _1914.x;
	    _1916.y = _1914.y;
	    _1916.z = _1914.z;
	    _330 = _1916;
	    vec4 _278;
	    vec4 _1923 = _278;
	    _1923.x = _1916.x;
	    _1923.y = _1916.y;
	    _1923.z = _1916.z;
	    _1923.w = _1916.w;
	    _278 = _1923;
	    mat3x4 _1934 = transpose(gl_WorldToObjectEXT);
	    mat3 _326;
	    mat3 _1937 = _326;
	    _1937[0] = _1934[0].xyz;
	    _1937[1] = _1934[1].xyz;
	    _1937[2] = _1934[2].xyz;
	    _326 = _1937;
	    vec3 _1946 = normalize(_1937 * _331.xyz);
	    vec3 _279;
	    vec3 _1948 = _279;
	    _1948.x = _1946.x;
	    _1948.y = _1946.y;
	    _1948.z = _1946.z;
	    _279 = _1948;
	    vec3 _1956 = vec4(vsInput[2].vPositionOs.xyz, 1.0) * transpose(gl_ObjectToWorldEXT);
	    mat3x4 _1960 = transpose(gl_WorldToObjectEXT);
	    mat3 _325;
	    mat3 _1963 = _325;
	    _1963[0] = _1960[0].xyz;
	    _1963[1] = _1960[1].xyz;
	    _1963[2] = _1960[2].xyz;
	    _325 = _1963;
	    vec3 _1972 = normalize(_1963 * _332.xyz);
	    vec4 _277;
	    vec4 _1974 = _277;
	    _1974.x = _1972.x;
	    _1974.y = _1972.y;
	    _1974.z = _1972.z;
	    _1974.w = _332.w;
	    _277 = _1974;
	    vec4 _1983 = _267.xyxy;
	    _1983.z = _267.x;
	    _1983.w = _267.y;
	    vec3 _1991 = mix(vec3(1.0), _1923.xyz, vec3(_305));
	    vec4 _1993 = _1923;
	    _1993.x = _1991.x;
	    _1993.y = _1991.y;
	    _1993.z = _1991.z;
	    vec3 _2001 = _1993.xyz * _307.xyz;
	    vec4 _2003 = _1993;
	    _2003.x = _2001.x;
	    _2003.y = _2001.y;
	    _2003.z = _2001.z;
	    _2003.w = _2003.w * _306;
	    vec3 _249 = _1956;
	    vec3 _248 = _1948;
	    vec3 _2032 = ((_258 * ((1.0 - attrs.barycentrics.x) - attrs.barycentrics.y)) + (_253 * attrs.barycentrics.x)) + (_1948 * attrs.barycentrics.y);
	    vec3 _266 = _2032;
	    vec4 _265 = ((_257 * ((1.0 - attrs.barycentrics.x) - attrs.barycentrics.y)) + (_252 * attrs.barycentrics.x)) + (_1983 * attrs.barycentrics.y);
	    vec4 _264 = ((_256 * ((1.0 - attrs.barycentrics.x) - attrs.barycentrics.y)) + (_251 * attrs.barycentrics.x)) + (_2003 * attrs.barycentrics.y);
	    vec4 _263 = ((_255 * ((1.0 - attrs.barycentrics.x) - attrs.barycentrics.y)) + (_250 * attrs.barycentrics.x)) + (_1974 * attrs.barycentrics.y);
	    bool _262 = gl_HitKindEXT == 254u;
	    vec3 _296 = vec3(0.5);
	    vec2 _295 = vec2(0.5);
	    vec3 _294 = vec3(0.0);
	    float _293 = 0.039999999105930328369140625;
	    vec3 _292 = vec3(0.0);
	    bool _289 = false;
	    vec3 _291 = _2032.xyz;
	    vec3 _290 = normalize(cross(_254 - _259, _1956 - _259));
	    bool _323;
	    if (_298)
	    {
	        _323 = !_299;
	    }
	    else
	    {
	        _323 = false;
	    }
	    SPIRV_CROSS_BRANCH
	    if (_323)
	    {
	        float _324;
	        if (_262)
	        {
	            _324 = 1.0;
	        }
	        else
	        {
	            _324 = -1.0;
	        }
	        _291 *= _324;
	        if (_262)
	        {
	            _324 = 1.0;
	        }
	        else
	        {
	            _324 = -1.0;
	        }
	        _290 *= _324;
	        _289 = !_262;
	    }
	    vec3 _2090 = _291;
	    vec3 _2091 = normalize(_2090);
	    _291 = _2091;
	    vec2 _2097 = _295;
	    vec3 _2098 = _296;
	    vec3 _285 = _294;
	    float _284 = _293;
	    vec3 _283 = _292;
	    vec3 _282 = _2091;
	    vec3 _281 = _290;
	    bool _280 = _289;
	    vec4 _2107 = textureLod(sampler2D(g_bindless_Texture2D_float4[_303], g_bindless_Sampler[_304]), _265.xy, 0.0).xyzw;
	    vec4 _2112 = _2107;
	    _2112.w = _2107.w * _264.w;
	    vec3 _2116 = _2107.xyz * _301.xyz;
	    vec4 _2118;
	    _2118.x = _2116.x;
	    _2118.y = _2116.y;
	    _2118.z = _2116.z;
	    _2098.x = _2118.x;
	    _2098.y = _2118.y;
	    _2098.z = _2118.z;
	    vec3 _2131 = _2098.xyz * _264.xyz;
	    vec3 _2133 = _2098;
	    _2133.x = _2131.x;
	    _2133.y = _2131.y;
	    _2133.z = _2131.z;
	    vec3 _288 = _2133;
	    float _286 = _297;
	    vec4 _2144 = textureLod(sampler2D(g_bindless_Texture2D_float4[_302], g_bindless_Sampler[_304]), _265.zw, 0.0);
	    float _2145 = _2144.x;
	    float _2146 = _2144.y;
	    float _2148 = (_2145 + _2146) - 1.00392162799835205078125;
	    float _2149 = _2145 - _2146;
	    _2097.x = _2144.z;
	    _2097.y = _2144.z;
	    vec2 _287 = _2097;
	    if (_300)
	    {
	        vec2 _2164 = _287;
	        vec2 _2169 = _2164.xy + (smoothstep(vec2(0.89999997615814208984375), vec2(1.0), _2164.xy) * 2.0);
	        vec2 _2171 = _2164;
	        _2171.x = _2169.x;
	        _2171.y = _2169.y;
	        _287 = _2171;
	    }
	    vec3 _321 = normalize(vec3(vec2(_2148, _2149), (1.0 - abs(_2148)) - abs(_2149)));
	    bool _319;
	    if (_298)
	    {
	        _319 = !_299;
	    }
	    else
	    {
	        _319 = false;
	    }
	    if (_319)
	    {
	        float _320;
	        if (_262)
	        {
	            _320 = 1.0;
	        }
	        else
	        {
	            _320 = -1.0;
	        }
	        _319 = _320 < 0.0;
	    }
	    else
	    {
	        _319 = false;
	    }
	    float _322;
	    if (_319)
	    {
	        _322 = -1.0;
	    }
	    else
	    {
	        _322 = 1.0;
	    }
	    float _2196 = _322;
	    vec3 _2197 = _266.xyz * _2196;
	    if (_263.w > 0.0)
	    {
	        _322 = 1.0;
	    }
	    else
	    {
	        _322 = -1.0;
	    }
	    bool _317;
	    if (_298)
	    {
	        _317 = !_299;
	    }
	    else
	    {
	        _317 = false;
	    }
	    if (_317)
	    {
	        float _318;
	        if (_262)
	        {
	            _318 = 1.0;
	        }
	        else
	        {
	            _318 = -1.0;
	        }
	        _317 = _318 < 0.0;
	    }
	    else
	    {
	        _317 = false;
	    }
	    if (!_317)
	    {
	        vec3 _2229 = _321;
	        _2229.y = -_2229.y;
	        _321 = _2229;
	    }
	    vec3 _2236 = _263.xyz * _321.x;
	    vec3 _316;
	    vec3 _2238 = _316;
	    _2238.x = _2236.x;
	    _2238.y = _2236.y;
	    _2238.z = _2236.z;
	    vec3 _2248 = _2238.xyz + ((cross(_2197.xyz, _263.xyz) * _322).xyz * _321.y);
	    vec3 _2250 = _2238;
	    _2250.x = _2248.x;
	    _2250.y = _2248.y;
	    _2250.z = _2248.z;
	    vec3 _2259 = _2250.xyz + (_2197.xyz * _321.z);
	    vec3 _2261 = _2250;
	    _2261.x = _2259.x;
	    _2261.y = _2259.y;
	    _2261.z = _2259.z;
	    _316 = _2261;
	    payload.nInstance = int(uint(gl_InstanceID));
	    payload.flHitT = gl_RayTmaxEXT;
	    payload.vFaceNormalWs = _281;
	    payload.vInterpolatedNormalWs = _282;
	    vec3 _314[3] = vec3[](_259, _254, _249);
	    vec3 _315[3] = vec3[](_258, _253, _248);
	    vec3 _2308 = ((_314[0] * ((1.0 - attrs.barycentrics.x) - attrs.barycentrics.y)) + (_314[1] * attrs.barycentrics.x)) + (_314[2] * attrs.barycentrics.y);
	    vec3 _308[3];
	    _308[0] = _2308 - (_315[0] * dot(_2308 - _314[0], _315[0]));
	    _308[1] = _2308 - (_315[1] * dot(_2308 - _314[1], _315[1]));
	    _308[2] = _2308 - (_315[2] * dot(_2308 - _314[2], _315[2]));
	    vec3 _2348 = ((_308[0] * ((1.0 - attrs.barycentrics.x) - attrs.barycentrics.y)) + (_308[1] * attrs.barycentrics.x)) + (_308[2] * attrs.barycentrics.y);
	    vec3 _309[3];
	    _309[0] = cross(_314[0] - _314[1], _281);
	    _309[1] = cross(_314[1] - _314[2], _281);
	    _309[2] = cross(_314[2] - _314[0], _281);
	    float _310 = dot(_2348 - _2308, _281);
	    vec3 _311 = _2348;
	    int _312 = 0;
	    for (;;)
	    {
	        bool _2364_ladder_break = false;
	        do
	        {
	            if (!(_312 < 3))
	            {
	                _2364_ladder_break = true;
	                break;
	            }
	            if (_310 > 0.00999999977648258209228515625)
	            {
	                _2364_ladder_break = true;
	                break;
	            }
	            if (dot(_309[_312], _309[_312]) == 0.0)
	            {
	                break;
	            }
	            _309[_312] = normalize(_309[_312]);
	            int _313 = 0;
	            for (;;)
	            {
	                if (!(_313 < 3))
	                {
	                    break;
	                }
	                vec3 _2402 = _315[_313] - (_309[_312] * dot(_309[_312], _315[_313]));
	                _308[_313] = _2308 - (_2402 * dot(_2308 - _314[_313], _2402));
	                _313++;
	                continue;
	            }
	            vec3 _2426 = ((_308[0] * ((1.0 - attrs.barycentrics.x) - attrs.barycentrics.y)) + (_308[1] * attrs.barycentrics.x)) + (_308[2] * attrs.barycentrics.y);
	            _310 = dot(_2426 - _2308, _281);
	            _311 = _2426;
	            break;
	        } while(false);
	        if (_2364_ladder_break)
	        {
	            break;
	        }
	        _312++;
	        continue;
	    }
	    if (!(_310 > 0.00999999977648258209228515625))
	    {
	        _311 = vec3(3.4028234663852885981170418348452e+38);
	    }
	    payload.vSmoothPositionWs = _311;
	    payload.bFlippedNormal = _280;
	    f16vec3 _2439 = f16vec3(vec3(0.0));
	    payload.material = MaterialDataMinimal_t(_2439, float16_t(0.0), f16vec3(vec3(1.0, 0.0, 1.0)), float16_t(1.0), _2439, float16_t(0.040008544921875), 0u, f16vec4(ivec4(0)));
	    payload.material.vNormalWs = f16vec3(normalize(_2261.xyz));
	    payload.material.vAlbedo = f16vec3(_288);
	    payload.material.vEmissive = f16vec3(_285);
	    payload.material.flReflectance = float16_t(_284);
	    payload.material.flMetalness = float16_t(_286);
	    payload.material.flRoughness = float16_t(dot(_287, vec2(0.5)));
	    if (any(greaterThan(_283, vec3(0.0))))
	    {
	        payload.material.nMaterialTypeAndFlags = (payload.material.nMaterialTypeAndFlags & 4294901760u) | 1u;
	        f16vec3 _2465 = f16vec3(_283);
	        payload.material.vMaterialBits.x = _2465.x;
	        payload.material.vMaterialBits.y = _2465.y;
	        payload.material.vMaterialBits.z = _2465.z;
	    }
	}
	
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
	
	BoolAttribute(BindlessResources, true);
	IntAttribute(RayTypeCount, 2);
	BoolAttribute(CanBatchWithDynamicShaderConstants, true);
	BoolAttribute(SupportsAggregateInstancing, F_TRANSLUCENT==0);
	BoolAttribute(VertexPaintUI2Layer, true);
	BoolAttribute(VertexPaintUIPickColor, true);
	TextureAttribute(LightSim_DiffuseAlbedoTexture, g_tColor);
	TextureAttribute(RepresentativeTexture, g_tColor);
	TextureAttribute(LightSim_DiffuseAlbedoTexture1, g_tColor);
	TextureAttribute(RepresentativeTexture1, g_tColor);
	BoolAttribute(SupportsLightmapping, true);
	BoolAttribute(PerVertexLighting, true);
	BoolAttribute(overlay, F_OVERLAY || 0);
	BoolAttribute(NeedsLightProbe, true);
	BoolAttribute(DoNotCastShadows, F_DO_NOT_CAST_SHADOWS || 0);
	BoolAttribute(SupportsMappingDimensions, true);
	BoolAttribute(renderbackfaces, F_RENDER_BACKFACES || 0);
	
	#if (S_SHADER_QUALITY == 0)
		TextureAttribute(LightSim_DiffuseAlbedoTexture2, g_tLayer2Color);
		TextureAttribute(RepresentativeTexture2, g_tLayer2Color);
		BoolAttribute(NoZPrepass, F_DISABLE_Z_PREPASS || 0);
	#endif
	#if (S_MODE_TOOLS_VIS == 0)
		TextureAttribute(LightSim_DiffuseAlbedoTexture2, g_tLayer2Color);
		TextureAttribute(RepresentativeTexture2, g_tLayer2Color);
		BoolAttribute(NoZPrepass, F_DISABLE_Z_PREPASS || 0);
	#endif
	#if (S_DETAILBLENDMODE == 1)
		TextureAttribute(LightSim_DiffuseAlbedoTexture2, g_tLayer2Color);
		TextureAttribute(RepresentativeTexture2, g_tLayer2Color);
		BoolAttribute(NoZPrepass, F_DISABLE_Z_PREPASS || 0);
	#endif
	#if (S_ALPHA_TEST == 1)
		TextureAttribute(LightSim_Opacity_A, g_tColor);
		BoolAttribute(alphatest, true);
		FloatAttribute(_dummyReferenceAlphaTestReferenceInMainShader, g_flAlphaTestReference);
		FloatAttribute(_dummyReferenceAntiAliasedEdgeStrengthReferenceInMainShader, g_flAntiAliasedEdgeStrength);
		BoolAttribute(NoZPrepass, true);
		BoolAttribute(AlphaTestZPrepass, true);
	#endif
	#if (S_ALPHA_TEST == 0)
		BoolAttribute(NoZPrepass, F_DISABLE_Z_PREPASS || 0);
	#endif
	#if (S_OVERLAY == 0)
		TextureAttribute(LightSim_DiffuseAlbedoTexture2, g_tLayer2Color);
		TextureAttribute(RepresentativeTexture2, g_tLayer2Color);
		BoolAttribute(NoZPrepass, F_DISABLE_Z_PREPASS || 0);
	#endif
	#if (S_LAYERS == 0)
		TextureAttribute(LightSim_Opacity_A, g_tColor);
	#endif
	#if (S_SPECULAR_INDIRECT == 0)
		TextureAttribute(LightSim_DiffuseAlbedoTexture2, g_tLayer2Color);
		TextureAttribute(RepresentativeTexture2, g_tLayer2Color);
		BoolAttribute(NoZPrepass, F_DISABLE_Z_PREPASS || 0);
	#endif
	#if (S_LAYERS == 1)
		TextureAttribute(LightSim_DiffuseAlbedoTexture2, g_tLayer2Color);
		TextureAttribute(RepresentativeTexture2, g_tLayer2Color);
		BoolAttribute(NoZPrepass, F_DISABLE_Z_PREPASS || 0);
	#endif
	#if (S_DETAILBLENDMODE == 0)
		TextureAttribute(LightSim_Opacity_A, g_tColor);
	#endif
	#if (S_TRANSLUCENT == 0)
		TextureAttribute(LightSim_DiffuseAlbedoTexture2, g_tLayer2Color);
		TextureAttribute(RepresentativeTexture2, g_tLayer2Color);
		BoolAttribute(NoZPrepass, F_DISABLE_Z_PREPASS || 0);
	#endif
	#if (S_DETAILTEXTURE == 2)
		TextureAttribute(LightSim_DiffuseAlbedoTexture2, g_tLayer2Color);
		TextureAttribute(RepresentativeTexture2, g_tLayer2Color);
		BoolAttribute(NoZPrepass, F_DISABLE_Z_PREPASS || 0);
	#endif
	#if (S_TRANSLUCENT == 1)
		TextureAttribute(LightSim_Opacity_A, g_tColor);
		BoolAttribute(translucent, true);
		BoolAttribute(NoZPrepass, F_DISABLE_Z_PREPASS || 0);
	#endif
	#if (S_SPECULAR_DIRECT == 0)
		TextureAttribute(LightSim_DiffuseAlbedoTexture2, g_tLayer2Color);
		TextureAttribute(RepresentativeTexture2, g_tLayer2Color);
		BoolAttribute(NoZPrepass, F_DISABLE_Z_PREPASS || 0);
	#endif
}
