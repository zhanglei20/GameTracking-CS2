//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "s2 version of lightmappedgeneric/worldvertextransition shader for csgo.";
	DevShader = false;
	Version = 4;
	
	// VcsVersion: 70
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
	StaticCombo( S_FANCY_BLENDING, F_FANCY_BLENDING!=0 );
	StaticCombo( S_DETAILTEXTURE, F_DETAILTEXTURE );
	StaticCombo( S_TEXTURETRANSFORMS, F_TEXTURETRANSFORMS );
	StaticComboRule( Requires( S_SPECULAR_DIRECT, S_SPECULAR_INDIRECT ) );
	StaticComboRule( Requires( S_DETAILTEXTURE=2, S_LAYERS=1 ) );
	DynamicCombo( D_COMPRESSED_NORMALS_AND_TANGENTS, 0..1 );
	DynamicCombo( D_CS_VERTEX_ANIMATION, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_VERTEX_STREAM, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_LIGHTMAP, 0..1 );
	DynamicComboRule( Allow1( D_BAKED_LIGHTING_FROM_VERTEX_STREAM, D_BAKED_LIGHTING_FROM_LIGHTMAP ) );
	
	cbuffer BakedLightingConstantBuffer_t < Attribute("BakedLightingConstantBuffer_t"); >;
	cbuffer PerViewConstantBufferCsgo_t < Attribute("PerViewConstantBufferCsgo_t"); >;
	cbuffer PerViewConstantBuffer_t < Attribute("PerViewConstantBuffer_t"); >;
	ByteAddressBuffer g_animatedVertexCache < Attribute("AnimatedVertexCache"); SrgbRead(false); >;
	ExternalDescriptorSet g_globalLateBoundBindlessSet < Source(ExternalDescSet); Attribute("g_globalLateBoundBindlessSet"); >;
	StructuredBuffer g_instanceBuffer < Attribute("InstanceBuffer"); SrgbRead(false); >;
	ExternalDescriptorSet g_lightBinnerGpuSet < Source(ExternalDescSet); Attribute("g_lightBinnerGpuSet"); >;
	StructuredBuffer g_transformBuffer < Attribute("TransformBuffer"); SrgbRead(false); >;
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
	// SPIR-V source (6664 bytes), HLSL reflection with SPIRV-Cross by KhronosGroup
	
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
	
	struct _1738
	{
	    float4 _m0[3];
	};
	
	struct _1424
	{
	    _1738 _m0;
	};
	
	struct _239
	{
	    float4 _m0[4];
	};
	
	static float4 _3;
	
	ByteAddressBuffer g_instanceBuffer : register(t32, space4);
	ByteAddressBuffer g_transformBuffer : register(t30, space4);
	cbuffer PerViewConstantBuffer_t : register(b1, space0)
	{
	    _239 PerViewConstantBuffer_t_1_m0 : packoffset(c0);
	    float4 PerViewConstantBuffer_t_1_m1 : packoffset(c24);
	};
	
	cbuffer _Globals_ : register(b0, space0)
	{
	    float3 _Globals_1_g_vColorTint : packoffset(c4.y);
	    float _Globals_1_g_flVertexColorOpacityScale : packoffset(c5);
	    float _Globals_1_g_flModelTintAmount : packoffset(c5.y);
	};
	
	cbuffer PerViewConstantBufferCsgo_t : register(b4, space0)
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
	    uint _13771 = (g_instanceBuffer.Load(nInstanceIdx * 32 + 20) >> uint(16)) & 15u;
	    uint _21785;
	    if (_13771 == 1u)
	    {
	        _21785 = g_instanceBuffer.Load(nInstanceIdx * 32 + 4) + (2u + vBlendIndices.x);
	    }
	    else
	    {
	        _21785 = g_instanceBuffer.Load(nInstanceIdx * 32 + 4);
	    }
	    _1738 _25207;
	    [unroll]
	    for (int _2ident = 0; _2ident < 3; _2ident++)
	    {
	        _25207._m0[_2ident] = asfloat(g_transformBuffer.Load4(_2ident * 16 + _21785 * 48 + 0));
	    }
	    float3x4 _17839 = float3x4(_25207._m0[0], _25207._m0[1], _25207._m0[2]);
	    float3 _21709;
	    if (_13771 > 0u)
	    {
	        _1738 _25208;
	        [unroll]
	        for (int _3ident = 0; _3ident < 3; _3ident++)
	        {
	            _25208._m0[_3ident] = asfloat(g_transformBuffer.Load4(_3ident * 16 + g_instanceBuffer.Load(nInstanceIdx * 32 + 4) * 48 + 0));
	        }
	        _21709 = _25208._m0[0].z.xxx;
	    }
	    else
	    {
	        _21709 = 1.0f.xxx;
	    }
	    float4 _23812 = float4(uint4((g_instanceBuffer.Load(nInstanceIdx * 32 + 0) & 255u), (g_instanceBuffer.Load(nInstanceIdx * 32 + 0) & 65280u) >> uint(8), (g_instanceBuffer.Load(nInstanceIdx * 32 + 0) & 16711680u) >> uint(16), (g_instanceBuffer.Load(nInstanceIdx * 32 + 0) & 4278190080u) >> uint(24))) * 0.0039215688593685626983642578125f.xxxx;
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
	    float _14124;
	    if (_23812.z <= 0.040449999272823333740234375f)
	    {
	        _14124 = _17828.z;
	    }
	    else
	    {
	        _14124 = _7676.z;
	    }
	    float _8825 = _23812.w;
	    float3 _12151 = mul(_17839, float4(vPositionOs.xyz * _21709.xyz, 1.0f));
	    float4 _23875 = mul(float4x4(float4(PerViewConstantBuffer_t_1_m0._m0[0].x, PerViewConstantBuffer_t_1_m0._m0[1].x, PerViewConstantBuffer_t_1_m0._m0[2].x, PerViewConstantBuffer_t_1_m0._m0[3].x), float4(PerViewConstantBuffer_t_1_m0._m0[0].y, PerViewConstantBuffer_t_1_m0._m0[1].y, PerViewConstantBuffer_t_1_m0._m0[2].y, PerViewConstantBuffer_t_1_m0._m0[3].y), float4(PerViewConstantBuffer_t_1_m0._m0[0].z, PerViewConstantBuffer_t_1_m0._m0[1].z, PerViewConstantBuffer_t_1_m0._m0[2].z, PerViewConstantBuffer_t_1_m0._m0[3].z), float4(PerViewConstantBuffer_t_1_m0._m0[0].w, PerViewConstantBuffer_t_1_m0._m0[1].w, PerViewConstantBuffer_t_1_m0._m0[2].w, PerViewConstantBuffer_t_1_m0._m0[3].w)), (float4(_12151.xyz, 1.0f) + (PerViewConstantBuffer_t_1_m1 * 1.0f)).xyzw);
	    float4 _9337 = vTexCoord.xyxy;
	    _9337.z = vTexCoord.x;
	    _9337.w = vTexCoord.y;
	    float3 _23588 = lerp(1.0f.xxx, float4(_21354, _21355, _14124, _8825).xyz, _Globals_1_g_flModelTintAmount.xxx);
	    float4 _17842;
	    _17842.x = _23588.x;
	    _17842.y = _23588.y;
	    _17842.z = _23588.z;
	    output_0 = _12151.xyz - PerViewConstantBufferCsgo_t_1_m0.xyz;
	    output_1 = normalize(mul(_17839, float4(vNormalOs.xyz, 0.0f)));
	    output_2 = _9337;
	    output_3 = float4(_17842.xyz * _Globals_1_g_vColorTint.xyz, _8825 * _Globals_1_g_flVertexColorOpacityScale);
	    output_4 = float4(normalize(mul(_17839, float4(vTangentUOs_flTangentVSign.xyz, 0.0f))), vTangentUOs_flTangentVSign.w);
	    output_5 = (g_instanceBuffer.Load(nInstanceIdx * 32 + 20)) & 65535u;
	    _23875.y = -_23875.y;
	    gl_Position = _23875;
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
	StaticCombo( S_FANCY_BLENDING, F_FANCY_BLENDING!=0 );
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
	StructuredBuffer g_BarnLights < Attribute("BarnLights"); SrgbRead(false); >;
	StructuredBuffer g_CullBits < Attribute("CullBits"); SrgbRead(false); >;
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
	Texture2DArray g_bindless_Texture2DArray_float4 < Source(ExternalDescSet); SrgbRead(false); >;
	Texture2D g_bindless_Texture2D_float4 < Source(ExternalDescSet); SrgbRead(false); >;
	Texture3D g_bindless_Texture3D_float4 < Source(ExternalDescSet); SrgbRead(false); >;
	TextureCubeArray g_bindless_TextureCubeArray < Source(ExternalDescSet); SrgbRead(false); >;
	TextureCubeArray g_bindless_TextureCubeArray_float4 < Source(ExternalDescSet); SrgbRead(false); >;
	TextureCube g_bindless_TextureCube_float4 < Source(ExternalDescSet); SrgbRead(false); >;
	float g_fToolsVisHeightTint < Default(0.9); Attribute("g_fToolsVisHeightTint"); UiType(Slider); >;
	float g_fToolsVisMaxHeightRange < Default(1); Attribute("g_fToolsVisMaxHeightRange"); UiType(Slider); >;
	float g_fToolsVisMaxLightingComplexity < Default(8); Attribute("g_fToolsVisMaxLightingComplexity"); UiType(Slider); >;
	float g_flReflectance < UiType(Slider); Expression(pow((1.5-1)/(1.5+1),2)); >;
	ExternalDescriptorSet g_globalLateBoundBindlessSet < Source(ExternalDescSet); Attribute("g_globalLateBoundBindlessSet"); >;
	ExternalDescriptorSet g_lightBinnerGpuSet < Source(ExternalDescSet); Attribute("g_lightBinnerGpuSet"); >;
	int g_nFancyBlendingMode < UiType(Slider); Expression(F_FANCY_BLENDING); >;
	int g_nToolsVisMode < Attribute("g_nToolsVisMode"); UiType(Slider); >;
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
		float g_flAlphaTestReference < Default(0.5); Range(0.01, 0.99); UiType(Slider); UiGroup("Translucent"); >;
	#endif
	#if (S_TRANSLUCENT == 1)
	#endif
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (33572 bytes), HLSL reflection with SPIRV-Cross by KhronosGroup
	
	struct _2494
	{
	    float4 _m0[4];
	};
	
	struct _2284
	{
	    float4 _m0[3];
	};
	
	struct _2495
	{
	    float4 _m0[4];
	};
	
	struct _2285
	{
	    float4 _m0[3];
	};
	
	struct _1096
	{
	    _2494 _m0[4];
	};
	
	struct _2041
	{
	    _2494 _m0;
	    _2494 _m1;
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
	    _2285 _m15;
	    float4 _m16;
	    float4 _m17;
	    float4 _m18;
	    float4 _m19;
	    float4 _m20;
	    float3 _m21;
	    float _m22;
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
	
	cbuffer PerViewConstantBufferCsgo_t : register(b4, space1)
	{
	    int4 PerViewConstantBufferCsgo_t_1_m0 : packoffset(c1);
	    int4 PerViewConstantBufferCsgo_t_1_m1 : packoffset(c2);
	    int4 PerViewConstantBufferCsgo_t_1_m2 : packoffset(c3);
	    uint PerViewConstantBufferCsgo_t_1_m3 : packoffset(c4.z);
	    uint PerViewConstantBufferCsgo_t_1_m4 : packoffset(c4.w);
	    uint PerViewConstantBufferCsgo_t_1_m5 : packoffset(c5);
	    uint PerViewConstantBufferCsgo_t_1_m6 : packoffset(c5.z);
	    _2494 PerViewConstantBufferCsgo_t_1_m7 : packoffset(c12);
	    float2 PerViewConstantBufferCsgo_t_1_m8 : packoffset(c16);
	    float PerViewConstantBufferCsgo_t_1_m9 : packoffset(c16.z);
	    float4 PerViewConstantBufferCsgo_t_1_m10 : packoffset(c23);
	    float4 PerViewConstantBufferCsgo_t_1_m11 : packoffset(c24);
	    float4 PerViewConstantBufferCsgo_t_1_m12 : packoffset(c25);
	    float4 PerViewConstantBufferCsgo_t_1_m13 : packoffset(c26);
	    float4 PerViewConstantBufferCsgo_t_1_m14 : packoffset(c27);
	    float4 PerViewConstantBufferCsgo_t_1_m15 : packoffset(c28);
	    _2494 PerViewConstantBufferCsgo_t_1_m16 : packoffset(c29);
	    float4 PerViewConstantBufferCsgo_t_1_m17 : packoffset(c33);
	    float4 PerViewConstantBufferCsgo_t_1_m18 : packoffset(c34);
	    float4 PerViewConstantBufferCsgo_t_1_m19 : packoffset(c35);
	};
	
	cbuffer PerViewLightingConstantBufferGpu_t : register(b0, space3)
	{
	    _2284 PerViewLightingConstantBufferGpu_t_1_m0 : packoffset(c7);
	    _2495 PerViewLightingConstantBufferGpu_t_1_m1 : packoffset(c11);
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
	    _1096 PerViewLightingConstantBufferGpu_t_1_m17 : packoffset(c1956);
	    _2495 PerViewLightingConstantBufferGpu_t_1_m18 : packoffset(c1988);
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
	SamplerState undetermined[2048] : register(s29, space4);
	SamplerComparisonState undetermined_1[2048] : register(s29, space4);
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
	        _12885 = !(_Globals_1_g_bDontFlipBackfaceNormals != 0);
	    }
	    else
	    {
	        _12885 = false;
	    }
	    float3 _10251;
	    if (_12885)
	    {
	        _10251 = input_1.xyz * (gl_FrontFacing ? 1.0f : (-1.0f));
	    }
	    else
	    {
	        _10251 = input_1.xyz;
	    }
	    float3 _10061 = input_0 + PerViewConstantBufferCsgo_t_1_m19.xyz;
	    float4 _19414 = g_bindless_Texture2D_float4[_Globals_1_g_tColor].Sample(undetermined[_Globals_1_g_sUserConfig], input_2.xy);
	    float4 _19068 = g_bindless_Texture2D_float4[_Globals_1_g_tLayer1AmbientOcclusion].Sample(undetermined[_Globals_1_g_sTrilinearWrap], input_2.xy);
	    float4 _19372 = g_bindless_Texture2D_float4[_Globals_1_g_tLayer1NormalRoughness].Sample(undetermined[_Globals_1_g_sUserConfig], input_2.zw);
	    float _16000 = _19372.x;
	    float _19720 = _19372.y;
	    float _16783 = (_16000 + _19720) - 1.00392162799835205078125f;
	    float _11176 = _16000 - _19720;
	    float3 _8418 = normalize(float3(float2(_16783, _11176), (1.0f - abs(_16783)) - abs(_11176)));
	    bool _12886;
	    if (_14874)
	    {
	        _12886 = !(_Globals_1_g_bDontFlipBackfaceNormals != 0);
	    }
	    else
	    {
	        _12886 = false;
	    }
	    bool _24327;
	    if (_12886)
	    {
	        _24327 = (gl_FrontFacing ? 1.0f : (-1.0f)) < 0.0f;
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
	    bool4 _24465 = bool4(PerViewConstantBufferCsgo_t_1_m0.x != int4(0, 0, 0, 0).x, PerViewConstantBufferCsgo_t_1_m0.y != int4(0, 0, 0, 0).y, PerViewConstantBufferCsgo_t_1_m0.z != int4(0, 0, 0, 0).z, PerViewConstantBufferCsgo_t_1_m0.w != int4(0, 0, 0, 0).w);
	    float _21785;
	    if (_24465.x)
	    {
	        float3 _11394 = normalize(_10251).xyz;
	        float2 _11086 = ((floor(_11408.xy * PerViewConstantBufferCsgo_t_1_m9) * PerViewConstantBufferCsgo_t_1_m8.xy) + (PerViewConstantBufferCsgo_t_1_m8.xy * 0.5f)).xy;
	        float4 _18418 = g_bindless_Texture2D_float4[PerViewConstantBufferCsgo_t_1_m5].GatherRed(undetermined[_Globals_1_g_sCookieSampler], _11086).xyzw - _11408.zzzz;
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
	        float4 _17422 = (max(float4(dot(PerViewLightingConstantBufferGpu_t_1_m1._m0[0].xyz, _11394), dot(PerViewLightingConstantBufferGpu_t_1_m1._m0[1].xyz, _11394), dot(PerViewLightingConstantBufferGpu_t_1_m1._m0[2].xyz, _11394), dot(PerViewLightingConstantBufferGpu_t_1_m1._m0[3].xyz, _11394)).xyzw, 0.0f.xxxx).xyzw * PerViewLightingConstantBufferGpu_t_1_m2.xyzw).xyzw;
	        _21785 = (1.0f / (dot(_17422, 1.0f.xxxx) + PerViewLightingConstantBufferGpu_t_1_m3.x)) * (PerViewLightingConstantBufferGpu_t_1_m3.x + dot(_17422, g_bindless_Texture2D_float4[PerViewConstantBufferCsgo_t_1_m4].SampleLevel(undetermined[_Globals_1_g_sPointClamp], (_11086 + float2(_13083.x ? PerViewConstantBufferCsgo_t_1_m8.xy.x : _23169.x, _13083.y ? PerViewConstantBufferCsgo_t_1_m8.xy.y : _23169.y).xy).xy, 0.0f).xyzw));
	    }
	    else
	    {
	        _21785 = 1.0f;
	    }
	    float3 _24735 = _14786.xyz;
	    float4 _23875 = float4(_24735, 1.0f);
	    float _21709;
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
	            float4 _18322 = mul(float4x4(float4(PerViewLightingConstantBufferGpu_t_1_m17._m0[_13039]._m0[0].x, PerViewLightingConstantBufferGpu_t_1_m17._m0[_13039]._m0[1].x, PerViewLightingConstantBufferGpu_t_1_m17._m0[_13039]._m0[2].x, PerViewLightingConstantBufferGpu_t_1_m17._m0[_13039]._m0[3].x), float4(PerViewLightingConstantBufferGpu_t_1_m17._m0[_13039]._m0[0].y, PerViewLightingConstantBufferGpu_t_1_m17._m0[_13039]._m0[1].y, PerViewLightingConstantBufferGpu_t_1_m17._m0[_13039]._m0[2].y, PerViewLightingConstantBufferGpu_t_1_m17._m0[_13039]._m0[3].y), float4(PerViewLightingConstantBufferGpu_t_1_m17._m0[_13039]._m0[0].z, PerViewLightingConstantBufferGpu_t_1_m17._m0[_13039]._m0[1].z, PerViewLightingConstantBufferGpu_t_1_m17._m0[_13039]._m0[2].z, PerViewLightingConstantBufferGpu_t_1_m17._m0[_13039]._m0[3].z), float4(PerViewLightingConstantBufferGpu_t_1_m17._m0[_13039]._m0[0].w, PerViewLightingConstantBufferGpu_t_1_m17._m0[_13039]._m0[1].w, PerViewLightingConstantBufferGpu_t_1_m17._m0[_13039]._m0[2].w, PerViewLightingConstantBufferGpu_t_1_m17._m0[_13039]._m0[3].w)), float4(input_0.xyz, 1.0f));
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
	            float _18270 = g_bindless_Texture2D_float4[PerViewLightingConstantBufferGpu_t_1_m19].SampleCmpLevelZero(undetermined_1[_Globals_1_g_tShadowDepthBufferCmpSampler], _14975.xy, clamp(_14975.z + PerViewLightingConstantBufferGpu_t_1_m11, 0.0f, 1.0f));
	            float _12501;
	            if (_13136 < 1.0f)
	            {
	                float _7934;
	                if (_10191 < (PerViewLightingConstantBufferGpu_t_1_m10 - 1))
	                {
	                    int _15335 = _10191 + 1;
	                    float4 _19671 = mul(float4x4(float4(PerViewLightingConstantBufferGpu_t_1_m17._m0[_15335]._m0[0].x, PerViewLightingConstantBufferGpu_t_1_m17._m0[_15335]._m0[1].x, PerViewLightingConstantBufferGpu_t_1_m17._m0[_15335]._m0[2].x, PerViewLightingConstantBufferGpu_t_1_m17._m0[_15335]._m0[3].x), float4(PerViewLightingConstantBufferGpu_t_1_m17._m0[_15335]._m0[0].y, PerViewLightingConstantBufferGpu_t_1_m17._m0[_15335]._m0[1].y, PerViewLightingConstantBufferGpu_t_1_m17._m0[_15335]._m0[2].y, PerViewLightingConstantBufferGpu_t_1_m17._m0[_15335]._m0[3].y), float4(PerViewLightingConstantBufferGpu_t_1_m17._m0[_15335]._m0[0].z, PerViewLightingConstantBufferGpu_t_1_m17._m0[_15335]._m0[1].z, PerViewLightingConstantBufferGpu_t_1_m17._m0[_15335]._m0[2].z, PerViewLightingConstantBufferGpu_t_1_m17._m0[_15335]._m0[3].z), float4(PerViewLightingConstantBufferGpu_t_1_m17._m0[_15335]._m0[0].w, PerViewLightingConstantBufferGpu_t_1_m17._m0[_15335]._m0[1].w, PerViewLightingConstantBufferGpu_t_1_m17._m0[_15335]._m0[2].w, PerViewLightingConstantBufferGpu_t_1_m17._m0[_15335]._m0[3].w)), float4(input_0.xyz, 1.0f));
	                    float2 _20562 = (_19671.xy * PerViewLightingConstantBufferGpu_t_1_m18._m0[_15335].zw) + PerViewLightingConstantBufferGpu_t_1_m18._m0[_15335].xy;
	                    float3 _20489;
	                    _20489.x = _20562.x;
	                    _20489.y = _20562.y;
	                    _7934 = g_bindless_Texture2D_float4[PerViewLightingConstantBufferGpu_t_1_m19].SampleCmpLevelZero(undetermined_1[_Globals_1_g_tShadowDepthBufferCmpSampler], _20489.xy, clamp(_19671.z + PerViewLightingConstantBufferGpu_t_1_m11, 0.0f, 1.0f));
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
	            _12502 = min(_13279, g_bindless_Texture2D_float4[PerViewConstantBufferCsgo_t_1_m6].SampleLevel(undetermined[_Globals_1_g_sTrilinearClamp], (_11408.xy * PerViewConstantBuffer_t_1_m2.xy).xy, 0.0f).z);
	        }
	        else
	        {
	            _12502 = _13279;
	        }
	        _21709 = _12502;
	    }
	    else
	    {
	        _21709 = 1.0f;
	    }
	    float3 _21710;
	    if ((dot(PerViewLightingConstantBufferGpu_t_1_m8.xyz, _24735) * _21709) > 0.0f)
	    {
	        _21710 = PerViewLightingConstantBufferGpu_t_1_m4.xyz + (max(0.0f, dot(_14786.xyz, PerViewLightingConstantBufferGpu_t_1_m8.xyz)).xxx.xyz * (PerViewLightingConstantBufferGpu_t_1_m9.xyz * _21709).xyz);
	    }
	    else
	    {
	        _21710 = PerViewLightingConstantBufferGpu_t_1_m4.xyz;
	    }
	    bool4 _24466 = bool4(PerViewConstantBufferCsgo_t_1_m1.x != int4(0, 0, 0, 0).x, PerViewConstantBufferCsgo_t_1_m1.y != int4(0, 0, 0, 0).y, PerViewConstantBufferCsgo_t_1_m1.z != int4(0, 0, 0, 0).z, PerViewConstantBufferCsgo_t_1_m1.w != int4(0, 0, 0, 0).w);
	    bool _20060 = _24466.x;
	    float4 _19364;
	    if (_20060)
	    {
	        float4 _24259 = mul(float4x4(float4(PerViewConstantBufferCsgo_t_1_m7._m0[0].x, PerViewConstantBufferCsgo_t_1_m7._m0[1].x, PerViewConstantBufferCsgo_t_1_m7._m0[2].x, PerViewConstantBufferCsgo_t_1_m7._m0[3].x), float4(PerViewConstantBufferCsgo_t_1_m7._m0[0].y, PerViewConstantBufferCsgo_t_1_m7._m0[1].y, PerViewConstantBufferCsgo_t_1_m7._m0[2].y, PerViewConstantBufferCsgo_t_1_m7._m0[3].y), float4(PerViewConstantBufferCsgo_t_1_m7._m0[0].z, PerViewConstantBufferCsgo_t_1_m7._m0[1].z, PerViewConstantBufferCsgo_t_1_m7._m0[2].z, PerViewConstantBufferCsgo_t_1_m7._m0[3].z), float4(PerViewConstantBufferCsgo_t_1_m7._m0[0].w, PerViewConstantBufferCsgo_t_1_m7._m0[1].w, PerViewConstantBufferCsgo_t_1_m7._m0[2].w, PerViewConstantBufferCsgo_t_1_m7._m0[3].w)), float4(_10061.xyz, 1.0f).xyzw);
	        float _20176 = _24259.w;
	        float2 _11414 = _24259.xy / _20176.xx;
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
	    _13155 = _21710;
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
	                _2494 _25209;
	                [unroll]
	                for (int _2ident = 0; _2ident < 4; _2ident++)
	                {
	                    _25209._m0[_2ident] = asfloat(g_BarnLights.Load4(_2ident * 16 + _12608 * 416 + 0));
	                }
	                float4 _15817 = mul(float4(input_0.xyz, 1.0f), float4x4(float4(_25209._m0[0].x, _25209._m0[1].x, _25209._m0[2].x, _25209._m0[3].x), float4(_25209._m0[0].y, _25209._m0[1].y, _25209._m0[2].y, _25209._m0[3].y), float4(_25209._m0[0].z, _25209._m0[1].z, _25209._m0[2].z, _25209._m0[3].z), float4(_25209._m0[0].w, _25209._m0[1].w, _25209._m0[2].w, _25209._m0[3].w)));
	                float3 _10521 = _15817.xyz / _15817.w.xxx;
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
	                    _2285 _8549;
	                    [unroll]
	                    for (int _3ident = 0; _3ident < 3; _3ident++)
	                    {
	                        _8549._m0[_3ident] = asfloat(g_BarnLights.Load4(_3ident * 16 + _12608 * 416 + 272));
	                    }
	                    float3 _6368 = abs(mul(float4(input_0.xyz, 1.0f), float4x3(float3(_8549._m0[0].x, _8549._m0[1].x, _8549._m0[2].x), float3(_8549._m0[0].y, _8549._m0[1].y, _8549._m0[2].y), float3(_8549._m0[0].z, _8549._m0[1].z, _8549._m0[2].z), float3(_8549._m0[0].w, _8549._m0[1].w, _8549._m0[2].w))).xyz);
	                    _12887 = !all(bool3(_6368.x <= 1.0f.xxx.x, _6368.y <= 1.0f.xxx.y, _6368.z <= 1.0f.xxx.z));
	                }
	                if (_12887)
	                {
	                    _12504 = _13156;
	                    break;
	                }
	                float _23571 = 2.0f * asfloat(g_BarnLights.Load4(_12608 * 416 + 176)).y;
	                float _18492 = (2.0f * asfloat(g_BarnLights.Load4(_12608 * 416 + 176)).z) * asfloat(g_BarnLights.Load4(_12608 * 416 + 176)).z;
	                float _14805 = 2.0f * asfloat(g_BarnLights.Load4(_12608 * 416 + 176)).x;
	                float _9058 = _14805 * asfloat(g_BarnLights.Load4(_12608 * 416 + 176)).y;
	                float _17330 = 2.0f * asfloat(g_BarnLights.Load4(_12608 * 416 + 176)).w;
	                float _19825 = _17330 * asfloat(g_BarnLights.Load4(_12608 * 416 + 176)).z;
	                float3 _16268 = float3(_9058 - _19825, (1.0f - (_14805 * asfloat(g_BarnLights.Load4(_12608 * 416 + 176)).x)) - _18492, (_23571 * asfloat(g_BarnLights.Load4(_12608 * 416 + 176)).z) + (_17330 * asfloat(g_BarnLights.Load4(_12608 * 416 + 176)).x)) * asfloat(g_BarnLights.Load3(_12608 * 416 + 192)).z;
	                float _21316;
	                if (asfloat(g_BarnLights.Load4(_12608 * 416 + 144)).z > 0.0f)
	                {
	                    _21316 = min(1.0f, _21775 * asfloat(g_BarnLights.Load4(_12608 * 416 + 144)).z);
	                }
	                else
	                {
	                    _21316 = 1.0f;
	                }
	                float _19667;
	                if (asfloat(g_BarnLights.Load4(_12608 * 416 + 144)).w > 0.0f)
	                {
	                    _19667 = _21316 * min(1.0f, (1.0f - _21775) * asfloat(g_BarnLights.Load4(_12608 * 416 + 144)).w);
	                }
	                else
	                {
	                    _19667 = _21316;
	                }
	                float3 _11179;
	                float _11633;
	                if (asfloat(g_BarnLights.Load4(_12608 * 416 + 128)).w != 0.0f)
	                {
	                    float3 _10017 = asfloat(g_BarnLights.Load4(_12608 * 416 + 128)).xyz - input_0.xyz;
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
	                    _11633 = ((_19667 * (asfloat(g_BarnLights.Load4(_12608 * 416 + 128)).w / max(_18345, asfloat(g_BarnLights.Load4(_12608 * 416 + 128)).w))) * clamp(asfloat(g_BarnLights.Load4(_12608 * 416 + 144)).x + (asfloat(g_BarnLights.Load4(_12608 * 416 + 144)).y * _17647), 0.0f, 1.0f)) * clamp(asfloat(g_BarnLights.Load3(_12608 * 416 + 192)).x + (asfloat(g_BarnLights.Load3(_12608 * 416 + 192)).y * dot(float3((1.0f - (_23571 * asfloat(g_BarnLights.Load4(_12608 * 416 + 176)).y)) - _18492, _9058 + _19825, (_14805 * asfloat(g_BarnLights.Load4(_12608 * 416 + 176)).z) - (_17330 * asfloat(g_BarnLights.Load4(_12608 * 416 + 176)).y)), normalize(_10210))), 0.0f, 1.0f);
	                }
	                else
	                {
	                    _11179 = asfloat(g_BarnLights.Load4(_12608 * 416 + 128)).xyz;
	                    _11633 = _19667;
	                }
	                float3 _17828 = (asfloat(g_BarnLights.Load4(_12608 * 416 + 160)).xyz * 1.0f).xyz * _11633;
	                bool _24419;
	                if (asfloat(g_BarnLights.Load4(_12608 * 416 + 208)).z > 0.0f)
	                {
	                    _24419 = !_20060;
	                }
	                else
	                {
	                    _24419 = false;
	                }
	                float3 _21548;
	                if (asfloat(g_BarnLights.Load4(_12608 * 416 + 160)).w == 0.0f)
	                {
	                    float _10342;
	                    do
	                    {
	                        float2 _22154 = abs(_22905.xy);
	                        if (asfloat(g_BarnLights.Load4(_12608 * 416 + 224)).z == 0.0f)
	                        {
	                            _10342 = smoothstep(1.0f, asfloat(g_BarnLights.Load4(_12608 * 416 + 224)).x, _22154.x) * smoothstep(1.0f, asfloat(g_BarnLights.Load4(_12608 * 416 + 224)).y, _22154.y);
	                            break;
	                        }
	                        else
	                        {
	                            float _11473 = _22154.x;
	                            float _15266 = 2.0f / asfloat(g_BarnLights.Load4(_12608 * 416 + 224)).z;
	                            float _15019 = _22154.y;
	                            float _23041 = (-0.5f) * asfloat(g_BarnLights.Load4(_12608 * 416 + 224)).z;
	                            float _11981 = (asfloat(g_BarnLights.Load4(_12608 * 416 + 224)).x * asfloat(g_BarnLights.Load4(_12608 * 416 + 224)).y) * pow(max(pow(asfloat(g_BarnLights.Load4(_12608 * 416 + 224)).y * _11473, _15266) + pow(asfloat(g_BarnLights.Load4(_12608 * 416 + 224)).x * _15019, _15266), 1.1754943508222875079687365372222e-38f), _23041);
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
	                    if (asfloat(g_BarnLights.Load4(_12608 * 416 + 160)).w < 0.0f)
	                    {
	                        float4 _17795 = float4(-asfloat(g_BarnLights.Load4(_12608 * 416 + 176)).xyz, asfloat(g_BarnLights.Load4(_12608 * 416 + 176)).w);
	                        float4 _19008 = _17795.xyzw * float4(-1.0f, -1.0f, -1.0f, 1.0f);
	                        float3 _24989 = _19008.xyz;
	                        float3 _23629 = float4((-_11179).xyz, 0.0f).xyz;
	                        float _15156 = -dot(_23629, _24989);
	                        float3 _20479 = float4((_23629 * _19008.w) + cross(_23629, _24989), _15156).xyz;
	                        float3 _23593 = _17795.xyz;
	                        float3 _12170 = ((_20479 * asfloat(g_BarnLights.Load4(_12608 * 416 + 176)).w) + (_23593 * _15156)) + cross(_23593, _20479);
	                        float3 _14081 = float3(float2(atan2(_12170.y, -_12170.x) * 0.15915493667125701904296875f, acos(_12170.z) * 0.3183098733425140380859375f), -asfloat(g_BarnLights.Load4(_12608 * 416 + 160)).w);
	                        float2 _20564 = (_14081.xy * asfloat(g_BarnLights.Load4(_12608 * 416 + 224)).zw) + asfloat(g_BarnLights.Load4(_12608 * 416 + 224)).xy;
	                        float3 _20491 = _14081;
	                        _20491.x = _20564.x;
	                        _20491.y = _20564.y;
	                        _12503 = _17828.xyz * g_bindless_Texture3D_float4[PerViewLightingConstantBufferGpu_t_1_m20].SampleLevel(undetermined[_Globals_1_g_sTrilinearWrap], _20491.xyz, 0.0f).xyz;
	                    }
	                    else
	                    {
	                        float3 _13791 = float3(mad(_22905.xy, float2(0.5f, -0.5f), 0.5f.xx), asfloat(g_BarnLights.Load4(_12608 * 416 + 160)).w);
	                        float2 _20563 = (_13791.xy * asfloat(g_BarnLights.Load4(_12608 * 416 + 224)).zw) + asfloat(g_BarnLights.Load4(_12608 * 416 + 224)).xy;
	                        float3 _20490 = _13791;
	                        _20490.x = _20563.x;
	                        _20490.y = _20563.y;
	                        _12503 = _17828.xyz * g_bindless_Texture3D_float4[PerViewLightingConstantBufferGpu_t_1_m20].SampleLevel(undetermined[_Globals_1_g_sCookieSampler], _20490.xyz, 0.0f).xyz;
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
	                    if ((g_BarnLights.Load(_12608 * 416 + 264) & 4u) != 0u)
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
	                    float3 _20482 = _21548.xyz * lerp(1.0f, g_bindless_Texture2D_float4[PerViewLightingConstantBufferGpu_t_1_m19].SampleCmpLevelZero(undetermined_1[_Globals_1_g_tShadowDepthBufferCmpSampler], float3(mad(_19629.xy, asfloat(g_BarnLights.Load4(_12608 * 416 + 208)).zw, asfloat(g_BarnLights.Load4(_12608 * 416 + 208)).xy), _19629.z).xy, clamp(_19629.z + PerViewLightingConstantBufferGpu_t_1_m11, 0.0f, 1.0f)), asfloat(g_BarnLights.Load(_12608 * 416 + 260)));
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
	    float3 _22686 = ((_13155.xyz * _21785.xxx).xyz + (float3(dot(PerViewLightingConstantBufferGpu_t_1_m0._m0[0].xyzw, _23875), dot(PerViewLightingConstantBufferGpu_t_1_m0._m0[1].xyzw, _23875), dot(PerViewLightingConstantBufferGpu_t_1_m0._m0[2].xyzw, _23875)).xyz * (_21785 * _19068.x).xxx.xyz).xyz) * (((_19414.xyz * _Globals_1_g_vLayer1Tint.xyz).xyz * input_3.xyz).xyz * (1.0f - _Globals_1_g_flMetalness)).xyz;
	    float4 _11203 = float4(_22686, input_3.w);
	    _11203.x = _22686.x;
	    _11203.y = _22686.y;
	    _11203.z = _22686.z;
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
	            if (_12888)
	            {
	                float2 _9342 = clamp(PerViewConstantBufferCsgo_t_1_m10.xy + (PerViewConstantBufferCsgo_t_1_m10.zw * float2(length(_21493), _10061.z)), 0.0f.xx, 1.0f.xx);
	                float _12872 = (pow(_9342.x, PerViewConstantBufferCsgo_t_1_m11.x) * pow(_9342.y, PerViewConstantBufferCsgo_t_1_m11.y)) * PerViewConstantBufferCsgo_t_1_m12.w;
	                _19340 = lerp(_11203.xyz, float4(PerViewConstantBufferCsgo_t_1_m12.xyz, _12872).xyz, _12872.xxx);
	                break;
	            }
	            _19340 = _11203.xyz;
	            break;
	        } while(false);
	        float4 _23944 = _11203;
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
	                _19341 = lerp(_23944.xyz, float4((g_bindless_TextureCube_float4[PerViewConstantBufferCsgo_t_1_m3].SampleLevel(undetermined[_Globals_1_g_sTrilinearClamp], normalize(mul(float4(_9057, 0.0f), float4x4(float4(PerViewConstantBufferCsgo_t_1_m16._m0[0].x, PerViewConstantBufferCsgo_t_1_m16._m0[1].x, PerViewConstantBufferCsgo_t_1_m16._m0[2].x, PerViewConstantBufferCsgo_t_1_m16._m0[3].x), float4(PerViewConstantBufferCsgo_t_1_m16._m0[0].y, PerViewConstantBufferCsgo_t_1_m16._m0[1].y, PerViewConstantBufferCsgo_t_1_m16._m0[2].y, PerViewConstantBufferCsgo_t_1_m16._m0[3].y), float4(PerViewConstantBufferCsgo_t_1_m16._m0[0].z, PerViewConstantBufferCsgo_t_1_m16._m0[1].z, PerViewConstantBufferCsgo_t_1_m16._m0[2].z, PerViewConstantBufferCsgo_t_1_m16._m0[3].z), float4(PerViewConstantBufferCsgo_t_1_m16._m0[0].w, PerViewConstantBufferCsgo_t_1_m16._m0[1].w, PerViewConstantBufferCsgo_t_1_m16._m0[2].w, PerViewConstantBufferCsgo_t_1_m16._m0[3].w))).xyz).xyz, PerViewConstantBufferCsgo_t_1_m15.w * clamp(1.0f - (_14602 * PerViewConstantBufferCsgo_t_1_m14.z), 0.0f, 1.0f)) * PerViewConstantBufferCsgo_t_1_m18.x).xyz, _8892).xyz, _8892.xxx);
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
	        _6805 = _11203;
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
	StaticCombo( S_FANCY_BLENDING, F_FANCY_BLENDING!=0 );
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
	#endif
	#if (S_DETAILTEXTURE == 2)
	#endif
	#if (S_ALPHA_TEST == 1)
	#endif
	#if (S_TRANSLUCENT == 1)
	#endif
	#if (S_DETAILBLENDMODE == 1)
	#endif
	
	// SPIR-V reflection failed for backend HLSL:
	// Unsupported builtin in HLSL: 5326
	// 
	// Re-attempting reflection with the GLSL backend.
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (55028 bytes), GLSL reflection with SPIRV-Cross by KhronosGroup
	
	#version 460
	#if defined(GL_AMD_gpu_shader_half_float)
	#extension GL_AMD_gpu_shader_half_float : require
	#elif defined(GL_EXT_shader_explicit_arithmetic_types_float16)
	#extension GL_EXT_shader_explicit_arithmetic_types_float16 : require
	#else
	#error No extension available for FP16.
	#endif
	#extension GL_EXT_shader_16bit_storage : require
	#extension GL_EXT_shader_explicit_arithmetic_types_int16 : require
	#extension GL_EXT_ray_tracing : require
	#extension GL_EXT_nonuniform_qualifier : require
	
	struct VS_INPUT
	{
	    vec3 nInstanceIdx;
	    vec2 _m1;
	    vec3 _m2;
	    vec4 _m3;
	    uvec4 _m4;
	    uint _m5;
	};
	
	struct MaterialDataMinimal_t
	{
	    f16vec3 vMaterialBits;
	    float16_t _m1;
	    f16vec3 _m2;
	    float16_t _m3;
	    f16vec3 _m4;
	    float16_t _m5;
	    uint _m6;
	    f16vec4 _m7;
	};
	
	struct BuiltInTriangleIntersectionAttributes
	{
	    vec2 barycentrics;
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
	
	struct Payload_t
	{
	    vec3 material;
	    vec3 _m1;
	    vec3 _m2;
	    float _m3;
	    float _m4;
	    int _m5;
	    bool _m6;
	    MaterialDataMinimal_t _m7;
	};
	
	vec4 _233;
	
	struct PayloadShadow_t
	{
	    float m_flVisibility;
	};
	
	layout(set = 3, binding = 35, std430) readonly buffer StructuredBuffer
	{
	    PackedRtxInstanceData_t_natural _m0[];
	} g_instanceBuffer;
	
	layout(set = 3, binding = 34, std430) readonly buffer g_MaterialData
	{
	    float _m0[];
	} g_MaterialData_1;
	
	layout(set = 3, binding = 34, std430) readonly buffer g_MaterialData_2
	{
	    uint _m0[];
	} g_MaterialData_3;
	
	layout(set = 3, binding = 34, std430) readonly buffer g_MaterialData_4
	{
	    int _m0[];
	} g_MaterialData_5;
	
	layout(set = 3, binding = 31, std430) readonly buffer g_Geometries
	{
	    GeometryInfo_t_natural _m0[];
	} g_Geometries_1;
	
	layout(set = 3, binding = 33, std430) readonly buffer g_Indices
	{
	    uint _m0[];
	} g_Indices_1[];
	
	layout(set = 3, binding = 32, std430) readonly buffer g_Vertices
	{
	    float _m0[];
	} g_Vertices_1[];
	
	layout(set = 3, binding = 32, std430) readonly buffer g_Vertices_2
	{
	    uint _m0[];
	} g_Vertices_3[];
	
	hitAttributeEXT BuiltInTriangleIntersectionAttributes _21;
	layout(set = 4, binding = 46) uniform texture2D g_bindless_Texture2D_float4[65536];
	layout(set = 4, binding = 29) uniform sampler g_bindless_Sampler[2048];
	layout(location = 0) rayPayloadInEXT Payload_t _20;
	
	void main()
	{
	    vec3 _288 = vec3(g_MaterialData_1._m0[g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 4u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 8u) / 4u]);
	    float _287 = g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 12u) / 4u];
	    float _286 = g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 16u) / 4u];
	    uint _285 = g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 48u) / 4u];
	    uint _284 = g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 56u) / 4u];
	    uint _283 = g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 60u) / 4u];
	    vec3 _282 = vec3(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 80u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 84u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 88u) / 4u]);
	    bool _281 = g_MaterialData_5._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 96u) / 4u] != 0;
	    bool _280 = g_MaterialData_5._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 104u) / 4u] != 0;
	    bool _279 = g_MaterialData_5._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 108u) / 4u] != 0;
	    float _278 = g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 196u) / 4u];
	    uvec3 _374;
	    do
	    {
	        if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes.w == 4)
	        {
	            uint _501 = (12u * uint(gl_PrimitiveID)) + uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes.w);
	            _374 = uvec3(g_Indices_1[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._m0[_501 / 4u], g_Indices_1[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._m0[(_501 + 4u) / 4u], g_Indices_1[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._m0[(_501 + 8u) / 4u]);
	            break;
	        }
	        else
	        {
	            uint _476 = (6u * uint(gl_PrimitiveID)) + uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes.w);
	            uint _477 = _476 & 4294967292u;
	            uint _478 = _477 / 4u;
	            uint _482 = (_477 + 4u) / 4u;
	            uint _487 = (g_Indices_1[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._m0[_478] & 4294901760u) >> uint(16);
	            uint _488 = g_Indices_1[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._m0[_482] & 65535u;
	            uvec3 _375;
	            if (_476 == _477)
	            {
	                _375 = uvec3(g_Indices_1[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._m0[_478] & 65535u, _487, _488);
	            }
	            else
	            {
	                _375 = uvec3(_487, _488, (g_Indices_1[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._m0[_482] & 4294901760u) >> uint(16));
	            }
	            _374 = _375;
	            break;
	        }
	        break;
	    } while(false);
	    uint _516 = uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.x);
	    uvec3 _524 = (uvec3(uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes.x)) * _374) + uvec3(uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes.x));
	    vec3 _369[3];
	    uint _526 = _524.x;
	    _369[0] = vec3(g_Vertices_1[_516]._m0[_526 / 4u], g_Vertices_1[_516]._m0[(_526 + 4u) / 4u], g_Vertices_1[_516]._m0[(_526 + 8u) / 4u]);
	    uint _540 = _524.y;
	    _369[1] = vec3(g_Vertices_1[_516]._m0[_540 / 4u], g_Vertices_1[_516]._m0[(_540 + 4u) / 4u], g_Vertices_1[_516]._m0[(_540 + 8u) / 4u]);
	    uint _554 = _524.z;
	    _369[2] = vec3(g_Vertices_1[_516]._m0[_554 / 4u], g_Vertices_1[_516]._m0[(_554 + 4u) / 4u], g_Vertices_1[_516]._m0[(_554 + 8u) / 4u]);
	    int _370 = 0;
	    VS_INPUT vsInput[3];
	    for (;;)
	    {
	        if (!(_370 < 3))
	        {
	            break;
	        }
	        vsInput[_370].nInstanceIdx = _369[_370];
	        _370++;
	        continue;
	    }
	    vec2 _371[3];
	    _371[0] = vec2(0.0);
	    _371[1] = vec2(0.0);
	    _371[2] = vec2(0.0);
	    if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].y != 0)
	    {
	        ivec4 _368 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers;
	        uint _597 = uint(_368[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].z]);
	        uint _599 = uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].z);
	        ivec4 _366 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes;
	        ivec4 _367 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes;
	        uvec3 _610 = (uvec3(uint(_366[_599])) * _374) + uvec3(uint(_367[_599]) + uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].x));
	        if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].y == 16)
	        {
	            uint _745 = _610.x;
	            _371[0] = vec2(g_Vertices_1[_597]._m0[_745 / 4u], g_Vertices_1[_597]._m0[(_745 + 4u) / 4u]);
	            uint _754 = _610.y;
	            _371[1] = vec2(g_Vertices_1[_597]._m0[_754 / 4u], g_Vertices_1[_597]._m0[(_754 + 4u) / 4u]);
	            uint _763 = _610.z;
	            _371[2] = vec2(g_Vertices_1[_597]._m0[_763 / 4u], g_Vertices_1[_597]._m0[(_763 + 4u) / 4u]);
	        }
	        else
	        {
	            if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].y == 34)
	            {
	                uint _716 = _610.x / 4u;
	                _371[0] = vec2(uint16BitsToFloat16(u16vec2(uvec2(g_Vertices_3[_597]._m0[_716], g_Vertices_3[_597]._m0[_716] >> uint(16)) & uvec2(65535u))));
	                uint _726 = _610.y / 4u;
	                _371[1] = vec2(uint16BitsToFloat16(u16vec2(uvec2(g_Vertices_3[_597]._m0[_726], g_Vertices_3[_597]._m0[_726] >> uint(16)) & uvec2(65535u))));
	                uint _736 = _610.z / 4u;
	                _371[2] = vec2(uint16BitsToFloat16(u16vec2(uvec2(g_Vertices_3[_597]._m0[_736], g_Vertices_3[_597]._m0[_736] >> uint(16)) & uvec2(65535u))));
	            }
	            else
	            {
	                if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].y == 37)
	                {
	                    uint _623 = _610.x / 4u;
	                    uint _627 = (g_Vertices_3[_597]._m0[_623] & 65535u);
	                    int _365;
	                    if (_627 > 32767u)
	                    {
	                        _365 = int(4294901760u | _627);
	                    }
	                    else
	                    {
	                        _365 = int(_627);
	                    }
	                    uint _640 = (g_Vertices_3[_597]._m0[_623] & 4294901760u) >> uint(16);
	                    int _364;
	                    if (_640 > 32767u)
	                    {
	                        _364 = int(4294901760u | _640);
	                    }
	                    else
	                    {
	                        _364 = int(_640);
	                    }
	                    _371[0] = vec2(max(float(_365) * 3.0518509447574615478515625e-05, -1.0), max(float(_364) * 3.0518509447574615478515625e-05, -1.0));
	                    uint _654 = _610.y / 4u;
	                    uint _658 = (g_Vertices_3[_597]._m0[_654] & 65535u);
	                    int _363;
	                    if (_658 > 32767u)
	                    {
	                        _363 = int(4294901760u | _658);
	                    }
	                    else
	                    {
	                        _363 = int(_658);
	                    }
	                    uint _671 = (g_Vertices_3[_597]._m0[_654] & 4294901760u) >> uint(16);
	                    int _362;
	                    if (_671 > 32767u)
	                    {
	                        _362 = int(4294901760u | _671);
	                    }
	                    else
	                    {
	                        _362 = int(_671);
	                    }
	                    _371[1] = vec2(max(float(_363) * 3.0518509447574615478515625e-05, -1.0), max(float(_362) * 3.0518509447574615478515625e-05, -1.0));
	                    uint _685 = _610.z / 4u;
	                    uint _689 = (g_Vertices_3[_597]._m0[_685] & 65535u);
	                    int _361;
	                    if (_689 > 32767u)
	                    {
	                        _361 = int(4294901760u | _689);
	                    }
	                    else
	                    {
	                        _361 = int(_689);
	                    }
	                    uint _702 = (g_Vertices_3[_597]._m0[_685] & 4294901760u) >> uint(16);
	                    int _360;
	                    if (_702 > 32767u)
	                    {
	                        _360 = int(4294901760u | _702);
	                    }
	                    else
	                    {
	                        _360 = int(_702);
	                    }
	                    _371[2] = vec2(max(float(_361) * 3.0518509447574615478515625e-05, -1.0), max(float(_360) * 3.0518509447574615478515625e-05, -1.0));
	                }
	            }
	        }
	    }
	    _370 = 0;
	    for (;;)
	    {
	        if (!(_370 < 3))
	        {
	            break;
	        }
	        vsInput[_370]._m1 = _371[_370];
	        _370++;
	        continue;
	    }
	    vec3 _372[3];
	    vec4 _373[3];
	    do
	    {
	        if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.y != 0)
	        {
	            ivec4 _346 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers;
	            uint _805 = uint(_346[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.z]);
	            uint _807 = uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.z);
	            ivec4 _344 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes;
	            ivec4 _345 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes;
	            uvec3 _818 = (uvec3(uint(_344[_807])) * _374) + uvec3(uint(_345[_807]) + uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.x));
	            if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.y == 6)
	            {
	                uint _1349 = _818.x;
	                _372[0] = vec3(g_Vertices_1[_805]._m0[_1349 / 4u], g_Vertices_1[_805]._m0[(_1349 + 4u) / 4u], g_Vertices_1[_805]._m0[(_1349 + 8u) / 4u]);
	                uint _1363 = _818.y;
	                _372[1] = vec3(g_Vertices_1[_805]._m0[_1363 / 4u], g_Vertices_1[_805]._m0[(_1363 + 4u) / 4u], g_Vertices_1[_805]._m0[(_1363 + 8u) / 4u]);
	                uint _1377 = _818.z;
	                _372[2] = vec3(g_Vertices_1[_805]._m0[_1377 / 4u], g_Vertices_1[_805]._m0[(_1377 + 4u) / 4u], g_Vertices_1[_805]._m0[(_1377 + 8u) / 4u]);
	            }
	            else
	            {
	                if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.y == 17)
	                {
	                    uint _1082 = _818.x;
	                    uvec2 _1090 = uvec2(g_Vertices_3[_805]._m0[_1082 / 4u], g_Vertices_3[_805]._m0[(_1082 + 4u) / 4u]);
	                    uint _1091 = _818.y;
	                    uvec2 _251 = uvec2(g_Vertices_3[_805]._m0[_1091 / 4u], g_Vertices_3[_805]._m0[(_1091 + 4u) / 4u]);
	                    uint _1100 = _818.z;
	                    uvec2 _250 = uvec2(g_Vertices_3[_805]._m0[_1100 / 4u], g_Vertices_3[_805]._m0[(_1100 + 4u) / 4u]);
	                    uint _1112 = _1090.x;
	                    uint _1121 = _1090.y;
	                    vec2 _1131 = ((vec2(float((_1112) & 65535u), float((_1112 >> 16u) & 65535u)) * vec2(1.525902189314365386962890625e-05)) * 2.0) - vec2(1.0);
	                    float _1132 = _1131.x;
	                    float _1137 = (1.0 - abs(_1132)) - abs(_1131.y);
	                    vec3 _1138 = vec3(_1132, _1131.y, _1137);
	                    float _1140 = saturate(-_1137);
	                    vec2 _1146 = _1131 + mix(vec2(_1140), vec2(-_1140), greaterThanEqual(_1131, vec2(0.0)));
	                    _1138.x = _1146.x;
	                    _1138.y = _1146.y;
	                    vec3 _354 = normalize(_1138);
	                    vec2 _1153 = ((vec2(float((_1121 >> uint(1)) & 32767u), float((_1121 >> 16u) & 32767u)) * vec2(3.0518509447574615478515625e-05)) * 2.0) - vec2(1.0);
	                    float _1154 = _1153.x;
	                    float _1159 = (1.0 - abs(_1154)) - abs(_1153.y);
	                    vec3 _1160 = vec3(_1154, _1153.y, _1159);
	                    float _1162 = saturate(-_1159);
	                    vec2 _1168 = _1153 + mix(vec2(_1162), vec2(-_1162), greaterThanEqual(_1153, vec2(0.0)));
	                    _1160.x = _1168.x;
	                    _1160.y = _1168.y;
	                    vec3 _353 = normalize(_1160);
	                    float _334;
	                    if ((_1121 & 1u) != 0u)
	                    {
	                        _334 = 1.0;
	                    }
	                    else
	                    {
	                        _334 = -1.0;
	                    }
	                    _372[0] = _354;
	                    _373[0].w = _334;
	                    _373[0].x = _353.x;
	                    _373[0].y = _353.y;
	                    _373[0].z = _353.z;
	                    vec2 _1211 = ((vec2(float((_251.x) & 65535u), float((_251.x >> 16u) & 65535u)) * vec2(1.525902189314365386962890625e-05)) * 2.0) - vec2(1.0);
	                    float _1212 = _1211.x;
	                    float _1217 = (1.0 - abs(_1212)) - abs(_1211.y);
	                    vec3 _1218 = vec3(_1212, _1211.y, _1217);
	                    float _1220 = saturate(-_1217);
	                    vec2 _1226 = _1211 + mix(vec2(_1220), vec2(-_1220), greaterThanEqual(_1211, vec2(0.0)));
	                    _1218.x = _1226.x;
	                    _1218.y = _1226.y;
	                    vec3 _356 = normalize(_1218);
	                    vec2 _1233 = ((vec2(float((_251.y >> uint(1)) & 32767u), float((_251.y >> 16u) & 32767u)) * vec2(3.0518509447574615478515625e-05)) * 2.0) - vec2(1.0);
	                    float _1234 = _1233.x;
	                    float _1239 = (1.0 - abs(_1234)) - abs(_1233.y);
	                    vec3 _1240 = vec3(_1234, _1233.y, _1239);
	                    float _1242 = saturate(-_1239);
	                    vec2 _1248 = _1233 + mix(vec2(_1242), vec2(-_1242), greaterThanEqual(_1233, vec2(0.0)));
	                    _1240.x = _1248.x;
	                    _1240.y = _1248.y;
	                    vec3 _355 = normalize(_1240);
	                    float _333;
	                    if ((_251.y & 1u) != 0u)
	                    {
	                        _333 = 1.0;
	                    }
	                    else
	                    {
	                        _333 = -1.0;
	                    }
	                    _372[1] = _356;
	                    _373[1].w = _333;
	                    _373[1].x = _355.x;
	                    _373[1].y = _355.y;
	                    _373[1].z = _355.z;
	                    vec2 _1291 = ((vec2(float((_250.x) & 65535u), float((_250.x >> 16u) & 65535u)) * vec2(1.525902189314365386962890625e-05)) * 2.0) - vec2(1.0);
	                    float _1292 = _1291.x;
	                    float _1297 = (1.0 - abs(_1292)) - abs(_1291.y);
	                    vec3 _1298 = vec3(_1292, _1291.y, _1297);
	                    float _1300 = saturate(-_1297);
	                    vec2 _1306 = _1291 + mix(vec2(_1300), vec2(-_1300), greaterThanEqual(_1291, vec2(0.0)));
	                    _1298.x = _1306.x;
	                    _1298.y = _1306.y;
	                    vec3 _358 = normalize(_1298);
	                    vec2 _1313 = ((vec2(float((_250.y >> uint(1)) & 32767u), float((_250.y >> 16u) & 32767u)) * vec2(3.0518509447574615478515625e-05)) * 2.0) - vec2(1.0);
	                    float _1314 = _1313.x;
	                    float _1319 = (1.0 - abs(_1314)) - abs(_1313.y);
	                    vec3 _1320 = vec3(_1314, _1313.y, _1319);
	                    float _1322 = saturate(-_1319);
	                    vec2 _1328 = _1313 + mix(vec2(_1322), vec2(-_1322), greaterThanEqual(_1313, vec2(0.0)));
	                    _1320.x = _1328.x;
	                    _1320.y = _1328.y;
	                    vec3 _357 = normalize(_1320);
	                    float _332;
	                    if ((_250.y & 1u) != 0u)
	                    {
	                        _332 = 1.0;
	                    }
	                    else
	                    {
	                        _332 = -1.0;
	                    }
	                    _372[2] = _358;
	                    _373[2].w = _332;
	                    _373[2].x = _357.x;
	                    _373[2].y = _357.y;
	                    _373[2].z = _357.z;
	                    break;
	                }
	                else
	                {
	                    uint _828 = _818.x / 4u;
	                    vec4 _348 = _373[0];
	                    float _843 = (float((g_Vertices_3[_805]._m0[_828] >> 12u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _846 = (float((g_Vertices_3[_805]._m0[_828] >> 22u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _850 = (1.0 - abs(_843)) - abs(_846);
	                    vec3 _851 = vec3(_843, _846, _850);
	                    float _853 = saturate(-_850);
	                    vec2 _854 = vec2(_843, _846);
	                    vec2 _860 = _854 + mix(vec2(_853), vec2(-_853), greaterThanEqual(_854, vec2(0.0)));
	                    _851.x = _860.x;
	                    _851.y = _860.y;
	                    vec3 _865 = normalize(_851);
	                    vec3 _347 = _865;
	                    float _866 = _865.z;
	                    float _341;
	                    if (_866 >= 0.0)
	                    {
	                        _341 = 1.0;
	                    }
	                    else
	                    {
	                        _341 = -1.0;
	                    }
	                    float _873 = (-1.0) / (_341 + _866);
	                    float _874 = _865.x;
	                    vec3 _342;
	                    vec3 _882 = _342;
	                    _882.x = 1.0 + (((_341 * _874) * _874) * _873);
	                    _882.y = _341 * ((_874 * _865.y) * _873);
	                    _882.z = (-_341) * _874;
	                    _342 = _882;
	                    float _890 = float((g_Vertices_3[_805]._m0[_828] >> uint(1)) & 2047u) * 0.003069460391998291015625;
	                    vec3 _896 = (_882 * cos(_890)) + (cross(_865, _882) * sin(_890));
	                    vec4 _898 = _348;
	                    _898.x = _896.x;
	                    _898.y = _896.y;
	                    _898.z = _896.z;
	                    _348 = _898;
	                    float _343;
	                    if ((g_Vertices_3[_805]._m0[_828] & 1u) == 0u)
	                    {
	                        _343 = -1.0;
	                    }
	                    else
	                    {
	                        _343 = 1.0;
	                    }
	                    vec4 _909 = _348;
	                    _909.w = _343;
	                    _348 = _909;
	                    _372[0] = _347;
	                    _373[0] = _909;
	                    uint _913 = _818.y / 4u;
	                    vec4 _350 = _373[1];
	                    float _928 = (float((g_Vertices_3[_805]._m0[_913] >> 12u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _931 = (float((g_Vertices_3[_805]._m0[_913] >> 22u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _935 = (1.0 - abs(_928)) - abs(_931);
	                    vec3 _936 = vec3(_928, _931, _935);
	                    float _938 = saturate(-_935);
	                    vec2 _939 = vec2(_928, _931);
	                    vec2 _945 = _939 + mix(vec2(_938), vec2(-_938), greaterThanEqual(_939, vec2(0.0)));
	                    _936.x = _945.x;
	                    _936.y = _945.y;
	                    vec3 _950 = normalize(_936);
	                    vec3 _349 = _950;
	                    float _951 = _950.z;
	                    float _338;
	                    if (_951 >= 0.0)
	                    {
	                        _338 = 1.0;
	                    }
	                    else
	                    {
	                        _338 = -1.0;
	                    }
	                    float _958 = (-1.0) / (_338 + _951);
	                    float _959 = _950.x;
	                    vec3 _339;
	                    vec3 _967 = _339;
	                    _967.x = 1.0 + (((_338 * _959) * _959) * _958);
	                    _967.y = _338 * ((_959 * _950.y) * _958);
	                    _967.z = (-_338) * _959;
	                    _339 = _967;
	                    float _975 = float((g_Vertices_3[_805]._m0[_913] >> uint(1)) & 2047u) * 0.003069460391998291015625;
	                    vec3 _981 = (_967 * cos(_975)) + (cross(_950, _967) * sin(_975));
	                    vec4 _983 = _350;
	                    _983.x = _981.x;
	                    _983.y = _981.y;
	                    _983.z = _981.z;
	                    _350 = _983;
	                    float _340;
	                    if ((g_Vertices_3[_805]._m0[_913] & 1u) == 0u)
	                    {
	                        _340 = -1.0;
	                    }
	                    else
	                    {
	                        _340 = 1.0;
	                    }
	                    vec4 _994 = _350;
	                    _994.w = _340;
	                    _350 = _994;
	                    _372[1] = _349;
	                    _373[1] = _994;
	                    uint _998 = _818.z / 4u;
	                    vec4 _352 = _373[2];
	                    float _1013 = (float((g_Vertices_3[_805]._m0[_998] >> 12u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _1016 = (float((g_Vertices_3[_805]._m0[_998] >> 22u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _1020 = (1.0 - abs(_1013)) - abs(_1016);
	                    vec3 _1021 = vec3(_1013, _1016, _1020);
	                    float _1023 = saturate(-_1020);
	                    vec2 _1024 = vec2(_1013, _1016);
	                    vec2 _1030 = _1024 + mix(vec2(_1023), vec2(-_1023), greaterThanEqual(_1024, vec2(0.0)));
	                    _1021.x = _1030.x;
	                    _1021.y = _1030.y;
	                    vec3 _1035 = normalize(_1021);
	                    vec3 _351 = _1035;
	                    float _1036 = _1035.z;
	                    float _335;
	                    if (_1036 >= 0.0)
	                    {
	                        _335 = 1.0;
	                    }
	                    else
	                    {
	                        _335 = -1.0;
	                    }
	                    float _1043 = (-1.0) / (_335 + _1036);
	                    float _1044 = _1035.x;
	                    vec3 _336;
	                    vec3 _1052 = _336;
	                    _1052.x = 1.0 + (((_335 * _1044) * _1044) * _1043);
	                    _1052.y = _335 * ((_1044 * _1035.y) * _1043);
	                    _1052.z = (-_335) * _1044;
	                    _336 = _1052;
	                    float _1060 = float((g_Vertices_3[_805]._m0[_998] >> uint(1)) & 2047u) * 0.003069460391998291015625;
	                    vec3 _1066 = (_1052 * cos(_1060)) + (cross(_1035, _1052) * sin(_1060));
	                    vec4 _1068 = _352;
	                    _1068.x = _1066.x;
	                    _1068.y = _1066.y;
	                    _1068.z = _1066.z;
	                    _352 = _1068;
	                    float _337;
	                    if ((g_Vertices_3[_805]._m0[_998] & 1u) == 0u)
	                    {
	                        _337 = -1.0;
	                    }
	                    else
	                    {
	                        _337 = 1.0;
	                    }
	                    vec4 _1079 = _352;
	                    _1079.w = _337;
	                    _352 = _1079;
	                    _372[2] = _351;
	                    _373[2] = _1079;
	                    break;
	                }
	                break;
	            }
	        }
	        else
	        {
	            _372[0] = vec3(0.0);
	            _372[1] = vec3(0.0);
	            _372[2] = vec3(0.0);
	        }
	        if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTangentFieldInfo.y != 0)
	        {
	            ivec4 _359 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers;
	            uint _1402 = uint(_359[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTangentFieldInfo.z]);
	            uint _1404 = uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTangentFieldInfo.z);
	            ivec4 _330 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes;
	            ivec4 _331 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes;
	            uvec3 _1415 = (uvec3(uint(_330[_1404])) * _374) + uvec3(uint(_331[_1404]) + uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTangentFieldInfo.x));
	            uint _1417 = _1415.x;
	            _373[0] = vec4(g_Vertices_1[_1402]._m0[_1417 / 4u], g_Vertices_1[_1402]._m0[(_1417 + 4u) / 4u], g_Vertices_1[_1402]._m0[(_1417 + 8u) / 4u], g_Vertices_1[_1402]._m0[(_1417 + 12u) / 4u]);
	            uint _1435 = _1415.y;
	            _373[1] = vec4(g_Vertices_1[_1402]._m0[_1435 / 4u], g_Vertices_1[_1402]._m0[(_1435 + 4u) / 4u], g_Vertices_1[_1402]._m0[(_1435 + 8u) / 4u], g_Vertices_1[_1402]._m0[(_1435 + 12u) / 4u]);
	            uint _1453 = _1415.z;
	            _373[2] = vec4(g_Vertices_1[_1402]._m0[_1453 / 4u], g_Vertices_1[_1402]._m0[(_1453 + 4u) / 4u], g_Vertices_1[_1402]._m0[(_1453 + 8u) / 4u], g_Vertices_1[_1402]._m0[(_1453 + 12u) / 4u]);
	        }
	        else
	        {
	            _373[0] = vec4(0.0);
	            _373[1] = vec4(0.0);
	            _373[2] = vec4(0.0);
	        }
	        break;
	    } while(false);
	    _370 = 0;
	    for (;;)
	    {
	        if (!(_370 < 3))
	        {
	            break;
	        }
	        vsInput[_370]._m2 = _372[_370];
	        vsInput[_370]._m3 = _373[_370];
	        _370++;
	        continue;
	    }
	    vec3 _328 = vsInput[0]._m2;
	    vec4 _329;
	    vec4 _1497 = _329;
	    _1497.x = vsInput[0]._m3.x;
	    _1497.y = vsInput[0]._m3.y;
	    _1497.z = vsInput[0]._m3.z;
	    _1497.w = vsInput[0]._m3.w;
	    _329 = _1497;
	    vec4 _1522 = vec4(uvec4((g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 255u), (g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 65280u) >> uint(8), (g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 16711680u) >> uint(16), (g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	    vec4 _327 = _1522;
	    vec3 _1523 = _1522.xyz;
	    vec3 _1524 = _1523 * vec3(0.077399380505084991455078125);
	    vec3 _1527 = pow((_1523 * vec3(0.947867333889007568359375)) + vec3(0.052132703363895416259765625), vec3(2.400000095367431640625));
	    float _324;
	    if (_1522.x <= 0.040449999272823333740234375)
	    {
	        _324 = _1524.x;
	    }
	    else
	    {
	        _324 = _1527.x;
	    }
	    float _325;
	    if (_1522.y <= 0.040449999272823333740234375)
	    {
	        _325 = _1524.y;
	    }
	    else
	    {
	        _325 = _1527.y;
	    }
	    float _326;
	    if (_1522.z <= 0.040449999272823333740234375)
	    {
	        _326 = _1524.z;
	    }
	    else
	    {
	        _326 = _1527.z;
	    }
	    vec3 _1552 = vec3(_324, _325, _326);
	    vec4 _1554 = _327;
	    _1554.x = _1552.x;
	    _1554.y = _1552.y;
	    _1554.z = _1552.z;
	    _327 = _1554;
	    vec4 _253;
	    vec4 _1561 = _253;
	    _1561.x = _1554.x;
	    _1561.y = _1554.y;
	    _1561.z = _1554.z;
	    _1561.w = _1554.w;
	    _253 = _1561;
	    mat3x4 _1572 = transpose(gl_WorldToObjectEXT);
	    mat3 _323;
	    mat3 _1575 = _323;
	    _1575[0] = _1572[0].xyz;
	    _1575[1] = _1572[1].xyz;
	    _1575[2] = _1572[2].xyz;
	    _323 = _1575;
	    vec3 _1584 = normalize(_1575 * _328.xyz);
	    vec3 _254;
	    vec3 _1586 = _254;
	    _1586.x = _1584.x;
	    _1586.y = _1584.y;
	    _1586.z = _1584.z;
	    _254 = _1586;
	    mat3x4 _1598 = transpose(gl_WorldToObjectEXT);
	    mat3 _322;
	    mat3 _1601 = _322;
	    _1601[0] = _1598[0].xyz;
	    _1601[1] = _1598[1].xyz;
	    _1601[2] = _1598[2].xyz;
	    _322 = _1601;
	    vec3 _1610 = normalize(_1601 * _329.xyz);
	    vec4 _252;
	    vec4 _1612 = _252;
	    _1612.x = _1610.x;
	    _1612.y = _1610.y;
	    _1612.z = _1610.z;
	    _1612.w = _329.w;
	    _252 = _1612;
	    vec4 _1621 = vsInput[0]._m1.xyxy;
	    _1621.z = vsInput[0]._m1.x;
	    _1621.w = vsInput[0]._m1.y;
	    vec3 _1630 = mix(vec3(1.0), _1561.xyz, vec3(_286));
	    vec4 _1632 = _1561;
	    _1632.x = _1630.x;
	    _1632.y = _1630.y;
	    _1632.z = _1630.z;
	    vec3 _1640 = _1632.xyz * _288.xyz;
	    vec4 _1642 = _1632;
	    _1642.x = _1640.x;
	    _1642.y = _1640.y;
	    _1642.z = _1640.z;
	    _1642.w = _1642.w * _287;
	    vec3 _249 = vec4(vsInput[0].nInstanceIdx.xyz, 1.0) * transpose(gl_ObjectToWorldEXT);
	    vec3 _248 = _1586;
	    vec4 _247 = _1621;
	    vec4 _246 = _1642;
	    vec4 _245 = _1612;
	    vec3 _320 = vsInput[1]._m2;
	    vec4 _321;
	    vec4 _1656 = _321;
	    _1656.x = vsInput[1]._m3.x;
	    _1656.y = vsInput[1]._m3.y;
	    _1656.z = vsInput[1]._m3.z;
	    _1656.w = vsInput[1]._m3.w;
	    _321 = _1656;
	    vec4 _1681 = vec4(uvec4((g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 255u), (g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 65280u) >> uint(8), (g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 16711680u) >> uint(16), (g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	    vec4 _319 = _1681;
	    vec3 _1682 = _1681.xyz;
	    vec3 _1683 = _1682 * vec3(0.077399380505084991455078125);
	    vec3 _1686 = pow((_1682 * vec3(0.947867333889007568359375)) + vec3(0.052132703363895416259765625), vec3(2.400000095367431640625));
	    float _316;
	    if (_1681.x <= 0.040449999272823333740234375)
	    {
	        _316 = _1683.x;
	    }
	    else
	    {
	        _316 = _1686.x;
	    }
	    float _317;
	    if (_1681.y <= 0.040449999272823333740234375)
	    {
	        _317 = _1683.y;
	    }
	    else
	    {
	        _317 = _1686.y;
	    }
	    float _318;
	    if (_1681.z <= 0.040449999272823333740234375)
	    {
	        _318 = _1683.z;
	    }
	    else
	    {
	        _318 = _1686.z;
	    }
	    vec3 _1711 = vec3(_316, _317, _318);
	    vec4 _1713 = _319;
	    _1713.x = _1711.x;
	    _1713.y = _1711.y;
	    _1713.z = _1711.z;
	    _319 = _1713;
	    vec4 _256;
	    vec4 _1720 = _256;
	    _1720.x = _1713.x;
	    _1720.y = _1713.y;
	    _1720.z = _1713.z;
	    _1720.w = _1713.w;
	    _256 = _1720;
	    mat3x4 _1731 = transpose(gl_WorldToObjectEXT);
	    mat3 _315;
	    mat3 _1734 = _315;
	    _1734[0] = _1731[0].xyz;
	    _1734[1] = _1731[1].xyz;
	    _1734[2] = _1731[2].xyz;
	    _315 = _1734;
	    vec3 _1743 = normalize(_1734 * _320.xyz);
	    vec3 _257;
	    vec3 _1745 = _257;
	    _1745.x = _1743.x;
	    _1745.y = _1743.y;
	    _1745.z = _1743.z;
	    _257 = _1745;
	    mat3x4 _1757 = transpose(gl_WorldToObjectEXT);
	    mat3 _314;
	    mat3 _1760 = _314;
	    _1760[0] = _1757[0].xyz;
	    _1760[1] = _1757[1].xyz;
	    _1760[2] = _1757[2].xyz;
	    _314 = _1760;
	    vec3 _1769 = normalize(_1760 * _321.xyz);
	    vec4 _255;
	    vec4 _1771 = _255;
	    _1771.x = _1769.x;
	    _1771.y = _1769.y;
	    _1771.z = _1769.z;
	    _1771.w = _321.w;
	    _255 = _1771;
	    vec4 _1780 = vsInput[1]._m1.xyxy;
	    _1780.z = vsInput[1]._m1.x;
	    _1780.w = vsInput[1]._m1.y;
	    vec3 _1789 = mix(vec3(1.0), _1720.xyz, vec3(_286));
	    vec4 _1791 = _1720;
	    _1791.x = _1789.x;
	    _1791.y = _1789.y;
	    _1791.z = _1789.z;
	    vec3 _1799 = _1791.xyz * _288.xyz;
	    vec4 _1801 = _1791;
	    _1801.x = _1799.x;
	    _1801.y = _1799.y;
	    _1801.z = _1799.z;
	    _1801.w = _1801.w * _287;
	    vec3 _244 = vec4(vsInput[1].nInstanceIdx.xyz, 1.0) * transpose(gl_ObjectToWorldEXT);
	    vec3 _243 = _1745;
	    vec4 _242 = _1780;
	    vec4 _241 = _1801;
	    vec4 _240 = _1771;
	    vec3 _312 = vsInput[2]._m2;
	    vec4 _313;
	    vec4 _1815 = _313;
	    _1815.x = vsInput[2]._m3.x;
	    _1815.y = vsInput[2]._m3.y;
	    _1815.z = vsInput[2]._m3.z;
	    _1815.w = vsInput[2]._m3.w;
	    _313 = _1815;
	    vec4 _1840 = vec4(uvec4((g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 255u), (g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 65280u) >> uint(8), (g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 16711680u) >> uint(16), (g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	    vec4 _311 = _1840;
	    vec3 _1841 = _1840.xyz;
	    vec3 _1842 = _1841 * vec3(0.077399380505084991455078125);
	    vec3 _1845 = pow((_1841 * vec3(0.947867333889007568359375)) + vec3(0.052132703363895416259765625), vec3(2.400000095367431640625));
	    float _308;
	    if (_1840.x <= 0.040449999272823333740234375)
	    {
	        _308 = _1842.x;
	    }
	    else
	    {
	        _308 = _1845.x;
	    }
	    float _309;
	    if (_1840.y <= 0.040449999272823333740234375)
	    {
	        _309 = _1842.y;
	    }
	    else
	    {
	        _309 = _1845.y;
	    }
	    float _310;
	    if (_1840.z <= 0.040449999272823333740234375)
	    {
	        _310 = _1842.z;
	    }
	    else
	    {
	        _310 = _1845.z;
	    }
	    vec3 _1870 = vec3(_308, _309, _310);
	    vec4 _1872 = _311;
	    _1872.x = _1870.x;
	    _1872.y = _1870.y;
	    _1872.z = _1870.z;
	    _311 = _1872;
	    vec4 _259;
	    vec4 _1879 = _259;
	    _1879.x = _1872.x;
	    _1879.y = _1872.y;
	    _1879.z = _1872.z;
	    _1879.w = _1872.w;
	    _259 = _1879;
	    mat3x4 _1890 = transpose(gl_WorldToObjectEXT);
	    mat3 _307;
	    mat3 _1893 = _307;
	    _1893[0] = _1890[0].xyz;
	    _1893[1] = _1890[1].xyz;
	    _1893[2] = _1890[2].xyz;
	    _307 = _1893;
	    vec3 _1902 = normalize(_1893 * _312.xyz);
	    vec3 _260;
	    vec3 _1904 = _260;
	    _1904.x = _1902.x;
	    _1904.y = _1902.y;
	    _1904.z = _1902.z;
	    _260 = _1904;
	    vec3 _1912 = vec4(vsInput[2].nInstanceIdx.xyz, 1.0) * transpose(gl_ObjectToWorldEXT);
	    mat3x4 _1916 = transpose(gl_WorldToObjectEXT);
	    mat3 _306;
	    mat3 _1919 = _306;
	    _1919[0] = _1916[0].xyz;
	    _1919[1] = _1916[1].xyz;
	    _1919[2] = _1916[2].xyz;
	    _306 = _1919;
	    vec3 _1928 = normalize(_1919 * _313.xyz);
	    vec4 _258;
	    vec4 _1930 = _258;
	    _1930.x = _1928.x;
	    _1930.y = _1928.y;
	    _1930.z = _1928.z;
	    _1930.w = _313.w;
	    _258 = _1930;
	    vec4 _1939 = vsInput[2]._m1.xyxy;
	    _1939.z = vsInput[2]._m1.x;
	    _1939.w = vsInput[2]._m1.y;
	    vec3 _1948 = mix(vec3(1.0), _1879.xyz, vec3(_286));
	    vec4 _1950;
	    _1950.x = _1948.x;
	    _1950.y = _1948.y;
	    _1950.z = _1948.z;
	    vec3 _1958 = _1950.xyz * _288.xyz;
	    vec4 _1960;
	    _1960.x = _1958.x;
	    _1960.y = _1958.y;
	    _1960.z = _1958.z;
	    vec4 _1968 = _1960;
	    _1968.w = _1960.w * _287;
	    vec3 _239 = _1912;
	    vec3 _238 = _1904;
	    vec3 _1988 = ((_248 * ((1.0 - _21.barycentrics.x) - _21.barycentrics.y)) + (_243 * _21.barycentrics.x)) + (_1904 * _21.barycentrics.y);
	    bool _1994 = gl_HitKindEXT == 254u;
	    vec4 _2003 = ((_247 * ((1.0 - _21.barycentrics.x) - _21.barycentrics.y)) + (_242 * _21.barycentrics.x)) + (_1939 * _21.barycentrics.y);
	    vec4 _2012 = ((_246 * ((1.0 - _21.barycentrics.x) - _21.barycentrics.y)) + (_241 * _21.barycentrics.x)) + (_1960 * _21.barycentrics.y);
	    vec4 _2021 = ((_245 * ((1.0 - _21.barycentrics.x) - _21.barycentrics.y)) + (_240 * _21.barycentrics.x)) + (_1930 * _21.barycentrics.y);
	    vec3 _277 = vec3(0.5);
	    vec2 _276 = vec2(0.5);
	    vec3 _275 = vec3(0.0);
	    float _274 = 0.039999999105930328369140625;
	    vec3 _273 = vec3(0.0);
	    bool _270 = false;
	    vec3 _272 = _1988.xyz;
	    vec3 _271 = normalize(cross(_244 - _249, _1912 - _249));
	    bool _304;
	    if (_279)
	    {
	        _304 = !_280;
	    }
	    else
	    {
	        _304 = false;
	    }
	    if (_304)
	    {
	        float _305;
	        if (_1994)
	        {
	            _305 = 1.0;
	        }
	        else
	        {
	            _305 = -1.0;
	        }
	        _272 *= _305;
	        if (_1994)
	        {
	            _305 = 1.0;
	        }
	        else
	        {
	            _305 = -1.0;
	        }
	        _271 *= _305;
	        _270 = !_1994;
	    }
	    vec3 _2045 = _272;
	    vec3 _2046 = normalize(_2045);
	    _272 = _2046;
	    vec2 _2052 = _276;
	    vec3 _2053 = _277;
	    vec3 _266 = _275;
	    float _265 = _274;
	    vec3 _264 = _273;
	    vec3 _263 = _2046;
	    vec3 _262 = _271;
	    bool _261 = _270;
	    vec4 _2061 = textureLod(sampler2D(g_bindless_Texture2D_float4[_284], g_bindless_Sampler[_285]), _2003.xy, 0.0).xyzw;
	    vec4 _2065 = _2061;
	    _2065.w = _2061.w * _2012.w;
	    vec3 _2069 = _2061.xyz * _282.xyz;
	    vec4 _2071;
	    _2071.x = _2069.x;
	    _2071.y = _2069.y;
	    _2071.z = _2069.z;
	    _2053.x = _2071.x;
	    _2053.y = _2071.y;
	    _2053.z = _2071.z;
	    vec3 _2084 = _2053.xyz * _2012.xyz;
	    vec3 _2086 = _2053;
	    _2086.x = _2084.x;
	    _2086.y = _2084.y;
	    _2086.z = _2084.z;
	    vec3 _269 = _2086;
	    float _267 = _278;
	    vec4 _2097 = textureLod(sampler2D(g_bindless_Texture2D_float4[_283], g_bindless_Sampler[_285]), _2003.zw, 0.0);
	    float _2098 = _2097.x;
	    float _2099 = _2097.y;
	    float _2101 = (_2098 + _2099) - 1.00392162799835205078125;
	    float _2102 = _2098 - _2099;
	    _2052.x = _2097.z;
	    _2052.y = _2097.z;
	    vec2 _268 = _2052;
	    if (_281)
	    {
	        vec2 _2117 = _268;
	        vec2 _2122 = _2117.xy + (smoothstep(vec2(0.89999997615814208984375), vec2(1.0), _2117.xy) * 2.0);
	        vec2 _2124 = _2117;
	        _2124.x = _2122.x;
	        _2124.y = _2122.y;
	        _268 = _2124;
	    }
	    vec3 _302 = normalize(vec3(vec2(_2101, _2102), (1.0 - abs(_2101)) - abs(_2102)));
	    bool _300;
	    if (_279)
	    {
	        _300 = !_280;
	    }
	    else
	    {
	        _300 = false;
	    }
	    if (_300)
	    {
	        float _301;
	        if (_1994)
	        {
	            _301 = 1.0;
	        }
	        else
	        {
	            _301 = -1.0;
	        }
	        _300 = _301 < 0.0;
	    }
	    else
	    {
	        _300 = false;
	    }
	    float _303;
	    if (_300)
	    {
	        _303 = -1.0;
	    }
	    else
	    {
	        _303 = 1.0;
	    }
	    float _2147 = _303;
	    vec3 _2148 = _1988.xyz * _2147;
	    if (_2021.w > 0.0)
	    {
	        _303 = 1.0;
	    }
	    else
	    {
	        _303 = -1.0;
	    }
	    bool _298;
	    if (_279)
	    {
	        _298 = !_280;
	    }
	    else
	    {
	        _298 = false;
	    }
	    if (_298)
	    {
	        float _299;
	        if (_1994)
	        {
	            _299 = 1.0;
	        }
	        else
	        {
	            _299 = -1.0;
	        }
	        _298 = _299 < 0.0;
	    }
	    else
	    {
	        _298 = false;
	    }
	    if (!_298)
	    {
	        vec3 _2178 = _302;
	        _2178.y = -_2178.y;
	        _302 = _2178;
	    }
	    vec3 _2185 = _2021.xyz * _302.x;
	    vec3 _297;
	    vec3 _2187 = _297;
	    _2187.x = _2185.x;
	    _2187.y = _2185.y;
	    _2187.z = _2185.z;
	    vec3 _2197 = _2187.xyz + ((cross(_2148.xyz, _2021.xyz) * _303).xyz * _302.y);
	    vec3 _2199 = _2187;
	    _2199.x = _2197.x;
	    _2199.y = _2197.y;
	    _2199.z = _2197.z;
	    vec3 _2208 = _2199.xyz + (_2148.xyz * _302.z);
	    vec3 _2210 = _2199;
	    _2210.x = _2208.x;
	    _2210.y = _2208.y;
	    _2210.z = _2208.z;
	    _297 = _2210;
	    _20._m5 = int(uint(gl_InstanceID));
	    _20._m3 = gl_RayTmaxEXT;
	    _20._m1 = _262;
	    _20._m2 = _263;
	    vec3 _289[3] = vec3[](_248, _243, _238);
	    vec3 _290[3] = vec3[](_249, _244, _239);
	    vec3 _2251 = ((_249 * ((1.0 - _21.barycentrics.x) - _21.barycentrics.y)) + (_244 * _21.barycentrics.x)) + (_239 * _21.barycentrics.y);
	    vec3 _291[3];
	    _291[0] = _2251 - (_248 * dot(_2251 - _249, _248));
	    _291[1] = _2251 - (_243 * dot(_2251 - _244, _243));
	    _291[2] = _2251 - (_238 * dot(_2251 - _239, _238));
	    vec3 _2279 = ((_291[0] * ((1.0 - _21.barycentrics.x) - _21.barycentrics.y)) + (_291[1] * _21.barycentrics.x)) + (_291[2] * _21.barycentrics.y);
	    vec3 _292[3];
	    _292[0] = cross(_249 - _244, _20._m1);
	    _292[1] = cross(_244 - _239, _20._m1);
	    _292[2] = cross(_239 - _249, _20._m1);
	    float _293 = dot(_2279 - _2251, _20._m1);
	    vec3 _294 = _2279;
	    int _295 = 0;
	    for (;;)
	    {
	        bool _2295_ladder_break = false;
	        do
	        {
	            if (!(_295 < 3))
	            {
	                _2295_ladder_break = true;
	                break;
	            }
	            if (_293 > 0.00999999977648258209228515625)
	            {
	                _2295_ladder_break = true;
	                break;
	            }
	            if (dot(_292[_295], _292[_295]) == 0.0)
	            {
	                break;
	            }
	            _292[_295] = normalize(_292[_295]);
	            int _296 = 0;
	            for (;;)
	            {
	                if (!(_296 < 3))
	                {
	                    break;
	                }
	                vec3 _2333 = _289[_296] - (_292[_295] * dot(_292[_295], _289[_296]));
	                _291[_296] = _2251 - (_2333 * dot(_2251 - _290[_296], _2333));
	                _296++;
	                continue;
	            }
	            vec3 _2357 = ((_291[0] * ((1.0 - _21.barycentrics.x) - _21.barycentrics.y)) + (_291[1] * _21.barycentrics.x)) + (_291[2] * _21.barycentrics.y);
	            _293 = dot(_2357 - _2251, _20._m1);
	            _294 = _2357;
	            break;
	        } while(false);
	        if (_2295_ladder_break)
	        {
	            break;
	        }
	        _295++;
	        continue;
	    }
	    if (!(_293 > 0.00999999977648258209228515625))
	    {
	        _294 = vec3(3.4028234663852885981170418348452e+38);
	    }
	    _20.material = _294;
	    _20._m6 = _261;
	    f16vec3 _2370 = f16vec3(vec3(0.0));
	    _20._m7 = MaterialDataMinimal_t(_2370, float16_t(0.0), f16vec3(vec3(1.0, 0.0, 1.0)), float16_t(1.0), _2370, float16_t(0.040008544921875), 0u, f16vec4(ivec4(0)));
	    _20._m7.vMaterialBits = f16vec3(normalize(_2210.xyz));
	    _20._m7._m2 = f16vec3(_269);
	    _20._m7._m4 = f16vec3(_266);
	    _20._m7._m5 = float16_t(_265);
	    _20._m7._m1 = float16_t(_267);
	    _20._m7._m3 = float16_t(dot(_268, vec2(0.5)));
	    if (any(greaterThan(_264, vec3(0.0))))
	    {
	        f16vec4 _2399 = _20._m7._m7;
	        f16vec3 _2402 = f16vec3(_264);
	        _2399.x = _2402.x;
	        _2399.y = _2402.y;
	        _2399.z = _2402.z;
	        _20._m7 = MaterialDataMinimal_t(_20._m7.vMaterialBits, _20._m7._m1, _20._m7._m2, _20._m7._m3, _20._m7._m4, _20._m7._m5, (_20._m7._m6 & 4294901760u) | 1u, _2399);
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
