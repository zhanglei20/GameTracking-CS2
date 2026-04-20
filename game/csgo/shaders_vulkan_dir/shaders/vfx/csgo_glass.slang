//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "Multipurpose glass.";
	DevShader = false;
	Version = 4;
	
	// VcsVersion: 70
	// Platform: VULKAN_SM_50
	// Programs: ps, psrs, vs
}

MODES
{
	CsgoForward();
	Depth(S_MODE_DEPTH);
	ToolsVis(S_MODE_TOOLS_VIS);
	ToolsWireframe("csgo_tools_wireframe.vfx");
	ToolsShadingComplexity("csgo_tools_shading_complexity.vfx");
}

FEATURES
{
	Feature( F_DO_NOT_CAST_SHADOWS, 0..1, "Rendering" );
	Feature( F_RENDER_BACKFACES, 0..1, "Rendering" );
	Feature( F_DONT_FLIP_BACKFACE_NORMALS, 0..1, "Rendering" );
	Feature( F_PAINT_VERTEX_COLORS, 0..1, "Vertex Color" );
	Feature( F_OPAQUE_CUBEMAP_REFRACTION, 0..1, "Blend Mode" );
	Feature( F_DISABLE_Z_BUFFERING, 0..1, "Z-Buffering" );
	Feature( F_VERTEX_BREAK_ANIMATION, 0..1, "Vertex Break Animation" );
	FeatureRule( Requires( F_DONT_FLIP_BACKFACE_NORMALS, F_RENDER_BACKFACES ), "Only applies to backfaces" );
	FeatureRule( Requires( F_DISABLE_Z_BUFFERING, F_OPAQUE_CUBEMAP_REFRACTION ), "Disable Z Buffering requires Opaque Cubemap Refraction." );
}

COMMON
{
	#include "system.fxc"
}

struct VS_INPUT
{
	float4 vBlendIndices              : BLENDINDICES0  < Semantic( BlendIndices ); >;              // S_MODE_DEPTH=1, D_CS_VERTEX_ANIMATION=1
	float4 vBlendColorTint            : COLOR0         < Semantic( VertexPaintTintColor ); >;      // S_PAINT_VERTEX_COLORS=1
	uint4  nPackedFrame               : NORMAL0        < Semantic( CompressedTangentFrame ); >;    // D_CS_VERTEX_ANIMATION=1
	float4 vPerVertexLighting         : COLOR1         < Semantic( PerVertexLighting ); >;        
	float4 vNormalOs                  : NORMAL0        < Semantic( Normal ); >;                   
	float3 vPositionOs                : POSITION0      < Semantic( PosXyz ); >;                    // S_MODE_DEPTH=1, D_CS_VERTEX_ANIMATION=1
	float4 vVertexElementData         : TEXCOORD4      < Semantic( VertexElementAnnotation ); >;  
	float4 vTangentUOs_flTangentVSign : TANGENT0       < Semantic( TangentU_SignV ); >;           
	float2 vLightmapUV                : TEXCOORD3      < Semantic( LightmapUV ); >;               
	float2 vTexCoord                  : TEXCOORD0      < Semantic( LowPrecisionUv ); >;           
	float2 nInstanceIdx               : TEXCOORD13     < Semantic( InstanceTransformUv ); >;      
};

VS
{
	StaticCombo( S_MODE_DEPTH, 0..1 );
	StaticCombo( S_OPAQUE_CUBEMAP_REFRACTION, F_OPAQUE_CUBEMAP_REFRACTION );
	StaticCombo( S_VERTEX_BREAK_ANIMATION, F_VERTEX_BREAK_ANIMATION );
	StaticCombo( S_PAINT_VERTEX_COLORS, F_PAINT_VERTEX_COLORS );
	StaticCombo( S_MODE_TOOLS_VIS, 0..1 );
	DynamicCombo( D_DISABLE_TRANSLUCENT_CLIP, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_VERTEX_STREAM, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_LIGHTMAP, 0..1 );
	DynamicCombo( D_COMPRESSED_NORMALS_AND_TANGENTS, 0..1 );
	DynamicCombo( D_CS_VERTEX_ANIMATION, 0..1 );
	DynamicComboRule( Requires( D_DISABLE_TRANSLUCENT_CLIP, S_MODE_DEPTH ) );
	DynamicComboRule( Allow1( D_BAKED_LIGHTING_FROM_VERTEX_STREAM, D_BAKED_LIGHTING_FROM_LIGHTMAP ) );
	
	cbuffer BakedLightingConstantBuffer_t < Attribute("BakedLightingConstantBuffer_t"); >;
	cbuffer PerViewConstantBufferCsgo_t < Attribute("PerViewConstantBufferCsgo_t"); >;
	cbuffer PerViewConstantBuffer_t < Attribute("PerViewConstantBuffer_t"); >;
	ByteAddressBuffer g_animatedVertexCache < Attribute("AnimatedVertexCache"); SrgbRead(false); >;
	ExternalDescriptorSet g_globalLateBoundBindlessSet < Source(ExternalDescSet); Attribute("g_globalLateBoundBindlessSet"); >;
	StructuredBuffer g_instanceBuffer < Attribute("InstanceBuffer"); SrgbRead(false); >;
	ExternalDescriptorSet g_lightBinnerGpuSet < Source(ExternalDescSet); Attribute("g_lightBinnerGpuSet"); >;
	StructuredBuffer g_transformBuffer < Attribute("TransformBuffer"); SrgbRead(false); >;
	
	// Vertex Break
	float g_flBreakShotSize < Default(100); Range(0, 300); UiType(Slider); UiGroup("Vertex Break/Params/10"); >;
	float3 g_vBreakShotPosition < Range3(-128, -128, -128, 128, 128, 128); UiType(VectorText); UiGroup("Vertex Break/Params/20"); >;
	float g_flBreakBounceFloor < Default(64); Range(0, 128); UiType(Slider); UiGroup("Vertex Break/Params/40"); >;
	float g_flBreakTime < Range(0, 3); UiType(Slider); UiGroup("Vertex Break/Params/50"); >;
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (5888 bytes), HLSL reflection with SPIRV-Cross by KhronosGroup
	
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
	
	struct _1696
	{
	    float4 _m0[3];
	};
	
	struct _1340
	{
	    _1696 _m0;
	};
	
	struct _197
	{
	    float4 _m0[4];
	};
	
	ByteAddressBuffer g_instanceBuffer : register(t32, space4);
	ByteAddressBuffer g_transformBuffer : register(t30, space4);
	cbuffer PerViewConstantBuffer_t : register(b1, space0)
	{
	    _197 PerViewConstantBuffer_t_1_m0 : packoffset(c0);
	    float4 PerViewConstantBuffer_t_1_m1 : packoffset(c24);
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
	static float3 output_4;
	static float4 output_5;
	static uint output_6;
	
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
	    centroid float3 output_4 : TEXCOORD4;
	    float4 output_5 : TEXCOORD5;
	    nointerpolation uint output_6 : TEXCOORD6;
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
	    _1696 _25207;
	    [unroll]
	    for (int _2ident = 0; _2ident < 3; _2ident++)
	    {
	        _25207._m0[_2ident] = asfloat(g_transformBuffer.Load4(_2ident * 16 + _21785 * 48 + 0));
	    }
	    float3x4 _17839 = float3x4(_25207._m0[0], _25207._m0[1], _25207._m0[2]);
	    float3 _21709;
	    if (_13771 > 0u)
	    {
	        _1696 _25208;
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
	    float3 _11179 = normalize(mul(_17839, float4(vNormalOs.xyz, 0.0f)));
	    float3 _12151 = mul(_17839, float4(vPositionOs.xyz * _21709.xyz, 1.0f));
	    float4 _23875 = mul(float4x4(float4(PerViewConstantBuffer_t_1_m0._m0[0].x, PerViewConstantBuffer_t_1_m0._m0[1].x, PerViewConstantBuffer_t_1_m0._m0[2].x, PerViewConstantBuffer_t_1_m0._m0[3].x), float4(PerViewConstantBuffer_t_1_m0._m0[0].y, PerViewConstantBuffer_t_1_m0._m0[1].y, PerViewConstantBuffer_t_1_m0._m0[2].y, PerViewConstantBuffer_t_1_m0._m0[3].y), float4(PerViewConstantBuffer_t_1_m0._m0[0].z, PerViewConstantBuffer_t_1_m0._m0[1].z, PerViewConstantBuffer_t_1_m0._m0[2].z, PerViewConstantBuffer_t_1_m0._m0[3].z), float4(PerViewConstantBuffer_t_1_m0._m0[0].w, PerViewConstantBuffer_t_1_m0._m0[1].w, PerViewConstantBuffer_t_1_m0._m0[2].w, PerViewConstantBuffer_t_1_m0._m0[3].w)), (float4(_12151.xyz, 1.0f) + (PerViewConstantBuffer_t_1_m1 * 1.0f)).xyzw);
	    output_0 = _12151.xyz - PerViewConstantBufferCsgo_t_1_m0.xyz;
	    output_1 = _11179;
	    output_2 = vTexCoord.xyxy;
	    output_3 = float4(_21354, _21355, _14124, _23812.w);
	    output_4 = _11179;
	    output_5 = float4(normalize(mul(_17839, float4(vTangentUOs_flTangentVSign.xyz, 0.0f))), vTangentUOs_flTangentVSign.w);
	    output_6 = (g_instanceBuffer.Load(nInstanceIdx * 32 + 20)) & 65535u;
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
	    stage_output.output_6 = output_6;
	    return stage_output;
	}
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
	
	BoolAttribute(BindlessResources, true);
	BoolAttribute(CanBatchWithDynamicShaderConstants, true);
	
	#if (S_MODE_DEPTH == 0)
		BoolAttribute(environmentmapped, true);
		BoolAttribute(environmentmappeddynamic, true);
	#endif
	#if (S_PAINT_VERTEX_COLORS == 0)
		BoolAttribute(environmentmapped, true);
		BoolAttribute(environmentmappeddynamic, true);
	#endif
	#if (S_PAINT_VERTEX_COLORS == 1)
		BoolAttribute(VertexPaintUIPickColorAlpha, true);
	#endif
	#if (S_MODE_DEPTH == 1)
		BoolAttribute(VertexPaintUIPickColorAlpha, true);
	#endif
}

PS
{
	StaticCombo( S_MODE_DEPTH, 0..1 );
	StaticCombo( S_OPAQUE_CUBEMAP_REFRACTION, F_OPAQUE_CUBEMAP_REFRACTION );
	StaticCombo( S_VERTEX_BREAK_ANIMATION, F_VERTEX_BREAK_ANIMATION );
	StaticCombo( S_PAINT_VERTEX_COLORS, F_PAINT_VERTEX_COLORS );
	StaticCombo( S_SHADER_QUALITY, 0..1 );
	StaticCombo( S_MODE_TOOLS_VIS, 0..1 );
	StaticComboRule( Allow1( S_MODE_DEPTH, S_SHADER_QUALITY ) );
	StaticComboRule( Requires( S_MODE_TOOLS_VIS, S_SHADER_QUALITY ) );
	DynamicCombo( D_DISABLE_TRANSLUCENT_CLIP, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_VERTEX_STREAM, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_LIGHTMAP, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_PROBE, 0..1 );
	DynamicCombo( D_MBOIT_PASS1, 0..1 );
	DynamicCombo( D_MBOIT_PASS2, 0..1 );
	DynamicCombo( D_MBOIT_4_MOMENTS, 0..1 );
	DynamicComboRule( Requires( D_DISABLE_TRANSLUCENT_CLIP, S_MODE_DEPTH ) );
	DynamicComboRule( Allow1( D_BAKED_LIGHTING_FROM_VERTEX_STREAM, D_BAKED_LIGHTING_FROM_LIGHTMAP ) );
	DynamicComboRule( Allow1( D_MBOIT_PASS1, D_MBOIT_PASS2 ) );
	DynamicComboRule( Requires( D_MBOIT_4_MOMENTS, D_MBOIT_PASS1, D_MBOIT_PASS2 ) );
	DynamicComboRule( Allow1( S_MODE_DEPTH, D_MBOIT_PASS1, D_MBOIT_PASS2 ) );
	DynamicComboRule( Requires( D_MBOIT_PASS1, S_OPAQUE_CUBEMAP_REFRACTION=0 ) );
	DynamicComboRule( Requires( D_MBOIT_PASS2, S_OPAQUE_CUBEMAP_REFRACTION=0 ) );
	
	cbuffer BakedLightingConstantBuffer_t < Attribute("BakedLightingConstantBuffer_t"); >;
	cbuffer PerViewConstantBufferCsgo_t < Attribute("PerViewConstantBufferCsgo_t"); >;
	cbuffer PerViewConstantBuffer_t < Attribute("PerViewConstantBuffer_t"); >;
	cbuffer PerViewLightProbeVolumeConstantBuffer_t < Attribute("PerViewLightProbeVolumeConstantBuffer_t"); >;
	cbuffer PerViewLightingConstantBufferGpu_t < Attribute("PerViewLightingConstantBufferGpu_t"); >;
	StructuredBuffer g_BarnLights < Attribute("BarnLights"); SrgbRead(false); >;
	StructuredBuffer g_CullBits < Attribute("CullBits"); SrgbRead(false); >;
	bool g_bCubemapNormalization < Attribute("g_bCubemapNormalization"); UiType(CheckBox); >;
	bool g_bDisableNormalMapping < Attribute("g_bDisableNormalMapping"); UiType(CheckBox); >;
	bool g_bDontFlipBackfaceNormals < UiType(CheckBox); Expression(F_DONT_FLIP_BACKFACE_NORMALS || 0); >;
	bool g_bHighlightDeprecated < Attribute("g_bHighlightDeprecated"); UiType(CheckBox); >;
	bool g_bIsDeprecated < Attribute("bIsDeprecated"); UiType(CheckBox); >;
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
	int g_nToolsVisMode < Attribute("g_nToolsVisMode"); UiType(Slider); >;
	float3 g_vFlatOverlayColor < Default2(1, 0); Attribute("FlatOverlayColor"); UiType(VectorText); >;
	float4 g_vShaderIDColor < Source(ShaderIDColor); UiType(VectorText); >;
	
	// Glass
	CreateInputTexture2D(GlassTintColor, Srgb, 8, "", "_color", "Glass,10/Tint,30/10", "materials/default/default_tint_color.tga");
	CreateInputTexture2D(GlassMaskColor, Srgb, 8, "", "_color", "Glass,10/Mask,10/20", Default4(1, 1, 1, 0));
	CreateInputTexture2D(GlassMaskTranslucency, Linear, 8, "", "_trans", "Glass,10/Mask,10/30", Default4(0, 0, 0, 0));
	float2 g_flTranslucencyRemap < Default(0); UiType(VectorText); UiGroup("Glass,10/Mask,10/30"); >;
	CreateInputTexture2D(GlassMaskTransmission, Linear, 8, "", "_mask", "Glass,10/Mask,10/40", Default4(1, 1, 1, 0));
	
	// Normal
	CreateInputTexture2D(TextureNormal, Linear, 8, "NormalizeNormals", "_normal", "Normal,20/10", Default4(0.5, 0.5, 1, 0));
	
	// Roughness
	CreateInputTexture2D(TextureRoughness, Linear, 8, "Inverse", "_rough", "Roughness,23/20", Default4(0.5, 0.5, 0.5, 0));
	
	// Fog
	bool g_bFogEnabled < Default(1); UiType(CheckBox); UiGroup("Fog"); >;
	
	// Tint
	float g_flModelTintAmount < Default(1); UiType(Slider); UiGroup("Tint,15/40/10"); >;
	
	// Refraction
	float g_flRefractMinRoughness < UiType(Slider); UiGroup("Refraction, 100/70"); >;
	
	// Texture Address Mode
	int g_nTextureAddressModeU < UiOption("RsTextureAddressMode_t"); UiType(Enum); UiGroup("Texture Address Mode"); >;
	int g_nTextureAddressModeV < UiOption("RsTextureAddressMode_t"); UiType(Enum); UiGroup("Texture Address Mode"); >;
	
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (38028 bytes), HLSL reflection with SPIRV-Cross by KhronosGroup
	
	struct _1331
	{
	    float4 _m0[4];
	};
	
	struct _2452
	{
	    float4 _m0[3];
	};
	
	struct _1332
	{
	    float4 _m0[4];
	};
	
	struct _2453
	{
	    float4 _m0[3];
	};
	
	struct _422
	{
	    _1331 _m0[4];
	};
	
	struct _2093
	{
	    _1331 _m0;
	    _1331 _m1;
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
	    _2453 _m15;
	    float4 _m16;
	    float4 _m17;
	    float4 _m18;
	    float4 _m19;
	    float4 _m20;
	    float3 _m21;
	    float _m22;
	};
	
	static float4 _4;
	static float3 _5;
	
	cbuffer _Globals_ : register(b0, space1)
	{
	    uint _Globals_1_g_tGlassTintColor : packoffset(c0);
	    uint _Globals_1_g_tNormal : packoffset(c0.y);
	    uint _Globals_1_g_tGlassDust : packoffset(c0.w);
	    float2 _Globals_1_g_flTranslucencyRemap : packoffset(c1);
	    float _Globals_1_g_flModelTintAmount : packoffset(c1.z);
	    uint _Globals_1_g_sTrilinearWrap : packoffset(c2.y);
	    uint _Globals_1_g_sTrilinearClamp : packoffset(c2.z);
	    uint _Globals_1_g_sUserConfig : packoffset(c3.z);
	    uint _Globals_1_g_sCookieSampler : packoffset(c4.y);
	    uint _Globals_1_g_tShadowDepthBufferCmpSampler : packoffset(c4.z);
	    int _Globals_1_g_bFogEnabled : packoffset(c5);
	    int _Globals_1_g_bDontFlipBackfaceNormals : packoffset(c5.y);
	    int _Globals_1_g_bRenderBackfaceNormals : packoffset(c5.z);
	    float _Globals_1_g_flReflectance : packoffset(c5.w);
	};
	
	cbuffer PerViewConstantBufferCsgo_t : register(b4, space1)
	{
	    int4 PerViewConstantBufferCsgo_t_1_m0 : packoffset(c0);
	    int4 PerViewConstantBufferCsgo_t_1_m1 : packoffset(c1);
	    int4 PerViewConstantBufferCsgo_t_1_m2 : packoffset(c2);
	    int4 PerViewConstantBufferCsgo_t_1_m3 : packoffset(c3);
	    uint PerViewConstantBufferCsgo_t_1_m4 : packoffset(c4.z);
	    uint PerViewConstantBufferCsgo_t_1_m5 : packoffset(c5.z);
	    uint PerViewConstantBufferCsgo_t_1_m6 : packoffset(c6.z);
	    _1331 PerViewConstantBufferCsgo_t_1_m7 : packoffset(c12);
	    float4 PerViewConstantBufferCsgo_t_1_m8 : packoffset(c23);
	    float4 PerViewConstantBufferCsgo_t_1_m9 : packoffset(c24);
	    float4 PerViewConstantBufferCsgo_t_1_m10 : packoffset(c25);
	    float4 PerViewConstantBufferCsgo_t_1_m11 : packoffset(c27);
	    float4 PerViewConstantBufferCsgo_t_1_m12 : packoffset(c28);
	    _1331 PerViewConstantBufferCsgo_t_1_m13 : packoffset(c29);
	    float4 PerViewConstantBufferCsgo_t_1_m14 : packoffset(c33);
	    float4 PerViewConstantBufferCsgo_t_1_m15 : packoffset(c34);
	    float4 PerViewConstantBufferCsgo_t_1_m16 : packoffset(c35);
	};
	
	cbuffer PerViewConstantBuffer_t : register(b1, space1)
	{
	    float2 PerViewConstantBuffer_t_1_m0 : packoffset(c20);
	    float2 PerViewConstantBuffer_t_1_m1 : packoffset(c20.z);
	    float4 PerViewConstantBuffer_t_1_m2 : packoffset(c22);
	    float3 PerViewConstantBuffer_t_1_m3 : packoffset(c26);
	};
	
	cbuffer PerViewLightingConstantBufferGpu_t : register(b0, space3)
	{
	    _2452 PerViewLightingConstantBufferGpu_t_1_m0 : packoffset(c7);
	    float4 PerViewLightingConstantBufferGpu_t_1_m1 : packoffset(c18);
	    uint4 PerViewLightingConstantBufferGpu_t_1_m2 : packoffset(c19);
	    uint4 PerViewLightingConstantBufferGpu_t_1_m3 : packoffset(c22);
	    float4 PerViewLightingConstantBufferGpu_t_1_m4 : packoffset(c23);
	    float4 PerViewLightingConstantBufferGpu_t_1_m5 : packoffset(c24);
	    float4 PerViewLightingConstantBufferGpu_t_1_m6 : packoffset(c1945);
	    float4 PerViewLightingConstantBufferGpu_t_1_m7 : packoffset(c1946);
	    int PerViewLightingConstantBufferGpu_t_1_m8 : packoffset(c1953);
	    float PerViewLightingConstantBufferGpu_t_1_m9 : packoffset(c1953.z);
	    float PerViewLightingConstantBufferGpu_t_1_m10 : packoffset(c1953.w);
	    float4 PerViewLightingConstantBufferGpu_t_1_m11 : packoffset(c1954);
	    float PerViewLightingConstantBufferGpu_t_1_m12 : packoffset(c1955);
	    float PerViewLightingConstantBufferGpu_t_1_m13 : packoffset(c1955.y);
	    float PerViewLightingConstantBufferGpu_t_1_m14 : packoffset(c1955.z);
	    float PerViewLightingConstantBufferGpu_t_1_m15 : packoffset(c1955.w);
	    _422 PerViewLightingConstantBufferGpu_t_1_m16 : packoffset(c1956);
	    _1332 PerViewLightingConstantBufferGpu_t_1_m17 : packoffset(c1988);
	    uint PerViewLightingConstantBufferGpu_t_1_m18 : packoffset(c1996);
	    uint PerViewLightingConstantBufferGpu_t_1_m19 : packoffset(c1996.y);
	};
	
	ByteAddressBuffer g_CullBits : register(t30, space3);
	ByteAddressBuffer g_BarnLights : register(t31, space3);
	Texture2D<float4> g_bindless_Texture2D_float4[65536] : register(t46, space4);
	SamplerState undetermined[2048] : register(s29, space4);
	SamplerComparisonState undetermined_1[2048] : register(s29, space4);
	Texture3D<float4> g_bindless_Texture3D_float4[65536] : register(t46, space4);
	TextureCubeArray<float4> g_bindless_TextureCubeArray_float4[65536] : register(t46, space4);
	TextureCube<float4> g_bindless_TextureCube_float4[65536] : register(t46, space4);
	
	static float4 gl_FragCoord;
	static bool gl_FrontFacing;
	static float3 input_0;
	static float3 input_1;
	static float4 input_2;
	static float4 input_3;
	static float3 input_4;
	static float4 input_5;
	static float4 output_0;
	
	struct PS_INPUT
	{
	    float3 input_0 : TEXCOORD0;
	    float3 input_1 : TEXCOORD1;
	    float4 input_2 : TEXCOORD2;
	    centroid float4 input_3 : TEXCOORD3;
	    centroid float3 input_4 : TEXCOORD4;
	    float4 input_5 : TEXCOORD5;
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
	    float3 _21709;
	    if (dot(input_1.xyz, input_1.xyz) >= 1.0099999904632568359375f)
	    {
	        _21709 = input_4.xyz;
	    }
	    else
	    {
	        _21709 = input_1.xyz;
	    }
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
	        _10251 = _21709 * (gl_FrontFacing ? 1.0f : (-1.0f));
	    }
	    else
	    {
	        _10251 = _21709;
	    }
	    float3 _24347 = normalize(_10251);
	    float3 _7542 = input_0 + PerViewConstantBufferCsgo_t_1_m16.xyz;
	    float3 _11894 = _Globals_1_g_flReflectance.xxx;
	    float4 _19372 = g_bindless_Texture2D_float4[_Globals_1_g_tNormal].Sample(undetermined[_Globals_1_g_sUserConfig], input_2.xy);
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
	    float3 _14435 = cross(_12631.xyz, input_5.xyz) * ((input_5.w > 0.0f) ? 1.0f : (-1.0f));
	    float3 _7424;
	    if (bool4(PerViewConstantBufferCsgo_t_1_m3.x != int4(0, 0, 0, 0).x, PerViewConstantBufferCsgo_t_1_m3.y != int4(0, 0, 0, 0).y, PerViewConstantBufferCsgo_t_1_m3.z != int4(0, 0, 0, 0).z, PerViewConstantBufferCsgo_t_1_m3.w != int4(0, 0, 0, 0).w).w)
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
	    float3 _13456 = normalize((((input_5.xyz * _20480.x).xyz + (_7424.xyz * _20480.y)).xyz + (_12631.xyz * _20480.z)).xyz);
	    float3 _8834 = normalize(_7542.xyz - PerViewConstantBuffer_t_1_m3.xyz);
	    float3 _13353 = -_8834;
	    float3 _24254 = _13353.xyz;
	    float3 _18457 = _13456.xyz;
	    float3 _9145 = _24347.xyz;
	    float _22668 = max(0.0f, dot(_24254, _9145));
	    float4 _20360 = g_bindless_Texture2D_float4[_Globals_1_g_tGlassDust].Sample(undetermined[_Globals_1_g_sUserConfig], input_2.xy);
	    float _6671 = (clamp(_20360.w * input_3.w, 0.0f, 1.0f) * (_Globals_1_g_flTranslucencyRemap.y - _Globals_1_g_flTranslucencyRemap.x)) + _Globals_1_g_flTranslucencyRemap.x;
	    float4 _3401 = g_bindless_Texture2D_float4[_Globals_1_g_tGlassTintColor].Sample(undetermined[_Globals_1_g_sUserConfig], input_2.xy);
	    float3 _20059 = _3401.xyz * lerp(1.0f.xxx, input_3.xyz, _Globals_1_g_flModelTintAmount.xxx);
	    float4 _23714;
	    _23714.x = _20059.x;
	    _23714.y = _20059.y;
	    _23714.z = _20059.z;
	    bool3 _10276 = all(bool3(true, true, true)).xxx;
	    float3 _17892 = float3(_10276.x ? _13456.x : 1.0f.xxx.x, _10276.y ? _13456.y : 1.0f.xxx.y, _10276.z ? _13456.z : 1.0f.xxx.z);
	    float3 _10560 = _24347.xyz;
	    float3 _11099 = ddx(_10560);
	    float3 _9175 = ddy(_10560);
	    float3 _10347 = _11099.xyz;
	    float3 _12420 = _9175.xyz;
	    float2 _13468 = max((_19372.zz * input_3.w).xy, pow(clamp(max(dot(_10347, _10347), dot(_12420, _12420)), 0.0f, 1.0f), 0.333000004291534423828125f).xx);
	    float4 _22272 = float4(_18457, 1.0f);
	    float3 _19477 = float3(dot(PerViewLightingConstantBufferGpu_t_1_m0._m0[0].xyzw, _22272), dot(PerViewLightingConstantBufferGpu_t_1_m0._m0[1].xyzw, _22272), dot(PerViewLightingConstantBufferGpu_t_1_m0._m0[2].xyzw, _22272));
	    float _21710;
	    if (dot(PerViewLightingConstantBufferGpu_t_1_m6.xyz, _18457) <= 0.0f)
	    {
	        _21710 = PerViewLightingConstantBufferGpu_t_1_m10;
	    }
	    else
	    {
	        _21710 = PerViewLightingConstantBufferGpu_t_1_m9;
	    }
	    float _21202;
	    if (PerViewLightingConstantBufferGpu_t_1_m8 != 0)
	    {
	        int _23989;
	        int _10191;
	        float _13136;
	        float3 _14975;
	        int _13039 = 0;
	        for (;;)
	        {
	            if (!(_13039 < PerViewLightingConstantBufferGpu_t_1_m8))
	            {
	                _13136 = 1.0f;
	                _14975 = 0.0f.xxx;
	                _10191 = -1;
	                break;
	            }
	            float4 _18322 = mul(float4x4(float4(PerViewLightingConstantBufferGpu_t_1_m16._m0[_13039]._m0[0].x, PerViewLightingConstantBufferGpu_t_1_m16._m0[_13039]._m0[1].x, PerViewLightingConstantBufferGpu_t_1_m16._m0[_13039]._m0[2].x, PerViewLightingConstantBufferGpu_t_1_m16._m0[_13039]._m0[3].x), float4(PerViewLightingConstantBufferGpu_t_1_m16._m0[_13039]._m0[0].y, PerViewLightingConstantBufferGpu_t_1_m16._m0[_13039]._m0[1].y, PerViewLightingConstantBufferGpu_t_1_m16._m0[_13039]._m0[2].y, PerViewLightingConstantBufferGpu_t_1_m16._m0[_13039]._m0[3].y), float4(PerViewLightingConstantBufferGpu_t_1_m16._m0[_13039]._m0[0].z, PerViewLightingConstantBufferGpu_t_1_m16._m0[_13039]._m0[1].z, PerViewLightingConstantBufferGpu_t_1_m16._m0[_13039]._m0[2].z, PerViewLightingConstantBufferGpu_t_1_m16._m0[_13039]._m0[3].z), float4(PerViewLightingConstantBufferGpu_t_1_m16._m0[_13039]._m0[0].w, PerViewLightingConstantBufferGpu_t_1_m16._m0[_13039]._m0[1].w, PerViewLightingConstantBufferGpu_t_1_m16._m0[_13039]._m0[2].w, PerViewLightingConstantBufferGpu_t_1_m16._m0[_13039]._m0[3].w)), float4(input_0.xyz, 1.0f));
	            float _12779 = _18322.x;
	            if (max(abs(_12779), abs(_18322.y)) < PerViewLightingConstantBufferGpu_t_1_m11[_13039])
	            {
	                float3 _19470 = float3(_12779, _18322.yz);
	                float2 _24804 = _19470.xy;
	                float2 _22193 = 1.0f.xx - clamp((abs(_24804) * PerViewLightingConstantBufferGpu_t_1_m13.xx) + PerViewLightingConstantBufferGpu_t_1_m12.xx, 0.0f.xx, 1.0f.xx);
	                float2 _20561 = (_24804 * PerViewLightingConstantBufferGpu_t_1_m17._m0[_13039].zw) + PerViewLightingConstantBufferGpu_t_1_m17._m0[_13039].xy;
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
	        float _18423;
	        if (_10191 >= 0)
	        {
	            float _18270 = g_bindless_Texture2D_float4[PerViewLightingConstantBufferGpu_t_1_m18].SampleCmpLevelZero(undetermined_1[_Globals_1_g_tShadowDepthBufferCmpSampler], _14975.xy, clamp(_14975.z + _21710, 0.0f, 1.0f));
	            float _12501;
	            if (_13136 < 1.0f)
	            {
	                float _7934;
	                if (_10191 < (PerViewLightingConstantBufferGpu_t_1_m8 - 1))
	                {
	                    int _15335 = _10191 + 1;
	                    float4 _19671 = mul(float4x4(float4(PerViewLightingConstantBufferGpu_t_1_m16._m0[_15335]._m0[0].x, PerViewLightingConstantBufferGpu_t_1_m16._m0[_15335]._m0[1].x, PerViewLightingConstantBufferGpu_t_1_m16._m0[_15335]._m0[2].x, PerViewLightingConstantBufferGpu_t_1_m16._m0[_15335]._m0[3].x), float4(PerViewLightingConstantBufferGpu_t_1_m16._m0[_15335]._m0[0].y, PerViewLightingConstantBufferGpu_t_1_m16._m0[_15335]._m0[1].y, PerViewLightingConstantBufferGpu_t_1_m16._m0[_15335]._m0[2].y, PerViewLightingConstantBufferGpu_t_1_m16._m0[_15335]._m0[3].y), float4(PerViewLightingConstantBufferGpu_t_1_m16._m0[_15335]._m0[0].z, PerViewLightingConstantBufferGpu_t_1_m16._m0[_15335]._m0[1].z, PerViewLightingConstantBufferGpu_t_1_m16._m0[_15335]._m0[2].z, PerViewLightingConstantBufferGpu_t_1_m16._m0[_15335]._m0[3].z), float4(PerViewLightingConstantBufferGpu_t_1_m16._m0[_15335]._m0[0].w, PerViewLightingConstantBufferGpu_t_1_m16._m0[_15335]._m0[1].w, PerViewLightingConstantBufferGpu_t_1_m16._m0[_15335]._m0[2].w, PerViewLightingConstantBufferGpu_t_1_m16._m0[_15335]._m0[3].w)), float4(input_0.xyz, 1.0f));
	                    float2 _20562 = (_19671.xy * PerViewLightingConstantBufferGpu_t_1_m17._m0[_15335].zw) + PerViewLightingConstantBufferGpu_t_1_m17._m0[_15335].xy;
	                    float3 _20489;
	                    _20489.x = _20562.x;
	                    _20489.y = _20562.y;
	                    _7934 = g_bindless_Texture2D_float4[PerViewLightingConstantBufferGpu_t_1_m18].SampleCmpLevelZero(undetermined_1[_Globals_1_g_tShadowDepthBufferCmpSampler], _20489.xy, clamp(_19671.z + _21710, 0.0f, 1.0f));
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
	            _18423 = _12501;
	        }
	        else
	        {
	            _18423 = 1.0f;
	        }
	        float _12513 = lerp(_18423, 1.0f, clamp((distance(_7542.xyz, PerViewConstantBuffer_t_1_m3) * PerViewLightingConstantBufferGpu_t_1_m15) + PerViewLightingConstantBufferGpu_t_1_m14, 0.0f, 1.0f));
	        float _12502;
	        if (bool4(PerViewConstantBufferCsgo_t_1_m1.x != int4(0, 0, 0, 0).x, PerViewConstantBufferCsgo_t_1_m1.y != int4(0, 0, 0, 0).y, PerViewConstantBufferCsgo_t_1_m1.z != int4(0, 0, 0, 0).z, PerViewConstantBufferCsgo_t_1_m1.w != int4(0, 0, 0, 0).w).y)
	        {
	            _12502 = min(_12513, g_bindless_Texture2D_float4[PerViewConstantBufferCsgo_t_1_m5].SampleLevel(undetermined[_Globals_1_g_sTrilinearClamp], (_11408.xy * PerViewConstantBuffer_t_1_m2.xy).xy, 0.0f).z);
	        }
	        else
	        {
	            _12502 = _12513;
	        }
	        _21202 = _12502;
	    }
	    else
	    {
	        _21202 = 1.0f;
	    }
	    bool3 _19899 = all(bool3(_17892.x == 1.0f.xxx.x, _17892.y == 1.0f.xxx.y, _17892.z == 1.0f.xxx.z)).xxx;
	    float3 _12493 = _13456.xyz;
	    float _11797 = max(0.0f, dot(_12493, PerViewLightingConstantBufferGpu_t_1_m6.xyz));
	    float2 _9840 = max(_13468, PerViewLightingConstantBufferGpu_t_1_m6.w.xx);
	    float3 _21889 = _13353.xyz;
	    float3 _12281 = normalize(PerViewLightingConstantBufferGpu_t_1_m6.xyz + _21889).xyz;
	    float3 _19012 = float3(_19899.x ? _18457.x : _17892.x, _19899.y ? _18457.y : _17892.y, _19899.z ? _18457.z : _17892.z).xyz;
	    float _12386 = dot(_12281, _19012);
	    float _19210 = max(0.0f, dot(PerViewLightingConstantBufferGpu_t_1_m6.xyz, _12281));
	    float3 _22995 = _11894.xyz;
	    float _9850 = _9840.x;
	    float _25211 = _9850 * _9850;
	    float _19095 = _25211 * _25211;
	    float _15346 = ((_12386 * _12386) * (_19095 - 1.0f)) + 1.0f;
	    float3 _16808 = (PerViewLightingConstantBufferGpu_t_1_m7.xyz * _21202).xyz;
	    bool4 _24466 = bool4(PerViewConstantBufferCsgo_t_1_m2.x != int4(0, 0, 0, 0).x, PerViewConstantBufferCsgo_t_1_m2.y != int4(0, 0, 0, 0).y, PerViewConstantBufferCsgo_t_1_m2.z != int4(0, 0, 0, 0).z, PerViewConstantBufferCsgo_t_1_m2.w != int4(0, 0, 0, 0).w);
	    bool _20061 = _24466.x;
	    float4 _19363;
	    if (_20061)
	    {
	        float4 _24259 = mul(float4x4(float4(PerViewConstantBufferCsgo_t_1_m7._m0[0].x, PerViewConstantBufferCsgo_t_1_m7._m0[1].x, PerViewConstantBufferCsgo_t_1_m7._m0[2].x, PerViewConstantBufferCsgo_t_1_m7._m0[3].x), float4(PerViewConstantBufferCsgo_t_1_m7._m0[0].y, PerViewConstantBufferCsgo_t_1_m7._m0[1].y, PerViewConstantBufferCsgo_t_1_m7._m0[2].y, PerViewConstantBufferCsgo_t_1_m7._m0[3].y), float4(PerViewConstantBufferCsgo_t_1_m7._m0[0].z, PerViewConstantBufferCsgo_t_1_m7._m0[1].z, PerViewConstantBufferCsgo_t_1_m7._m0[2].z, PerViewConstantBufferCsgo_t_1_m7._m0[3].z), float4(PerViewConstantBufferCsgo_t_1_m7._m0[0].w, PerViewConstantBufferCsgo_t_1_m7._m0[1].w, PerViewConstantBufferCsgo_t_1_m7._m0[2].w, PerViewConstantBufferCsgo_t_1_m7._m0[3].w)), float4(_7542.xyz, 1.0f).xyzw);
	        float _20176 = _24259.w;
	        float2 _11414 = _24259.xy / _20176.xx;
	        float4 _6651;
	        _6651.x = clamp(((_11414.x + 1.0f) * PerViewConstantBuffer_t_1_m1.x) * 0.5f, 0.0f, PerViewConstantBuffer_t_1_m1.x - 1.0f);
	        _6651.y = clamp(((1.0f - _11414.y) * PerViewConstantBuffer_t_1_m1.y) * 0.5f, 0.0f, PerViewConstantBuffer_t_1_m1.y - 1.0f);
	        _6651.w = _20176;
	        _19363 = _6651;
	    }
	    else
	    {
	        _19363 = _11408;
	    }
	    uint2 _12083 = uint2(_19363.xy - PerViewConstantBuffer_t_1_m0.xy) >> PerViewLightingConstantBufferGpu_t_1_m3.x.xx;
	    uint _10838 = PerViewLightingConstantBufferGpu_t_1_m2.y + (((_12083.y * PerViewLightingConstantBufferGpu_t_1_m3.y) + _12083.x) * PerViewLightingConstantBufferGpu_t_1_m2.z);
	    uint _23393 = PerViewLightingConstantBufferGpu_t_1_m2.x + (uint(clamp(_19363.w * PerViewLightingConstantBufferGpu_t_1_m4.x, 0.0f, PerViewLightingConstantBufferGpu_t_1_m4.y)) * PerViewLightingConstantBufferGpu_t_1_m2.z);
	    float3 _13137;
	    float3 _16305;
	    float3 _17133;
	    _13137 = (max(0.0f, -dot(_9145, PerViewLightingConstantBufferGpu_t_1_m6.xyz)).xxx.xyz * PerViewLightingConstantBufferGpu_t_1_m7.xyz) * _21202;
	    _16305 = ((_22995 * (_19095 / (((_15346 * _15346) * (_19210 * _19210)) * ((_9850 * 4.0f) + 2.0f)))).xyz * _11797).xyz * _16808;
	    _17133 = PerViewLightingConstantBufferGpu_t_1_m1.xyz + (_11797.xxx.xyz * _16808);
	    uint _21567;
	    float3 _13138;
	    float3 _16306;
	    float3 _17134;
	    uint _17017 = 0u;
	    for (;;)
	    {
	        if (!(_17017 < PerViewLightingConstantBufferGpu_t_1_m2.z))
	        {
	            break;
	        }
	        uint _14475 = WaveActiveBitOr(g_CullBits.Load((_10838 + _17017) * 4 + 0) & g_CullBits.Load((_23393 + _17017) * 4 + 0));
	        _13138 = _13137;
	        _16306 = _16305;
	        _17134 = _17133;
	        uint _20344;
	        float3 _13139;
	        float3 _16381;
	        float3 _16479;
	        uint _17018 = _14475;
	        for (;;)
	        {
	            if (!(_17018 != 0u))
	            {
	                break;
	            }
	            int _12608 = int(firstbitlow(_17018) + (_17017 * 32u));
	            _20344 = _17018 & (_17018 - 1u);
	            do
	            {
	                _1331 _25209;
	                [unroll]
	                for (int _4ident = 0; _4ident < 4; _4ident++)
	                {
	                    _25209._m0[_4ident] = asfloat(g_BarnLights.Load4(_4ident * 16 + _12608 * 416 + 0));
	                }
	                float4 _15817 = mul(float4(input_0.xyz, 1.0f), float4x4(float4(_25209._m0[0].x, _25209._m0[1].x, _25209._m0[2].x, _25209._m0[3].x), float4(_25209._m0[0].y, _25209._m0[1].y, _25209._m0[2].y, _25209._m0[3].y), float4(_25209._m0[0].z, _25209._m0[1].z, _25209._m0[2].z, _25209._m0[3].z), float4(_25209._m0[0].w, _25209._m0[1].w, _25209._m0[2].w, _25209._m0[3].w)));
	                float3 _10521 = _15817.xyz / _15817.w.xxx;
	                float4 _22905;
	                _22905.x = _10521.x;
	                _22905.y = _10521.y;
	                float _21780 = _10521.z;
	                _22905.z = _21780;
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
	                    _2453 _8549;
	                    [unroll]
	                    for (int _5ident = 0; _5ident < 3; _5ident++)
	                    {
	                        _8549._m0[_5ident] = asfloat(g_BarnLights.Load4(_5ident * 16 + _12608 * 416 + 272));
	                    }
	                    float3 _6368 = abs(mul(float4(input_0.xyz, 1.0f), float4x3(float3(_8549._m0[0].x, _8549._m0[1].x, _8549._m0[2].x), float3(_8549._m0[0].y, _8549._m0[1].y, _8549._m0[2].y), float3(_8549._m0[0].z, _8549._m0[1].z, _8549._m0[2].z), float3(_8549._m0[0].w, _8549._m0[1].w, _8549._m0[2].w))).xyz);
	                    _12887 = !all(bool3(_6368.x <= 1.0f.xxx.x, _6368.y <= 1.0f.xxx.y, _6368.z <= 1.0f.xxx.z));
	                }
	                if (_12887)
	                {
	                    _13139 = _13138;
	                    _16381 = _16306;
	                    _16479 = _17134;
	                    break;
	                }
	                float _23572 = 2.0f * asfloat(g_BarnLights.Load4(_12608 * 416 + 176)).y;
	                float _18492 = (2.0f * asfloat(g_BarnLights.Load4(_12608 * 416 + 176)).z) * asfloat(g_BarnLights.Load4(_12608 * 416 + 176)).z;
	                float _14805 = 2.0f * asfloat(g_BarnLights.Load4(_12608 * 416 + 176)).x;
	                float _9058 = _14805 * asfloat(g_BarnLights.Load4(_12608 * 416 + 176)).y;
	                float _17330 = 2.0f * asfloat(g_BarnLights.Load4(_12608 * 416 + 176)).w;
	                float _19825 = _17330 * asfloat(g_BarnLights.Load4(_12608 * 416 + 176)).z;
	                float3 _16268 = float3(_9058 - _19825, (1.0f - (_14805 * asfloat(g_BarnLights.Load4(_12608 * 416 + 176)).x)) - _18492, (_23572 * asfloat(g_BarnLights.Load4(_12608 * 416 + 176)).z) + (_17330 * asfloat(g_BarnLights.Load4(_12608 * 416 + 176)).x)) * asfloat(g_BarnLights.Load3(_12608 * 416 + 192)).z;
	                float _21316;
	                if (asfloat(g_BarnLights.Load4(_12608 * 416 + 144)).z > 0.0f)
	                {
	                    _21316 = min(1.0f, _21780 * asfloat(g_BarnLights.Load4(_12608 * 416 + 144)).z);
	                }
	                else
	                {
	                    _21316 = 1.0f;
	                }
	                float _19667;
	                if (asfloat(g_BarnLights.Load4(_12608 * 416 + 144)).w > 0.0f)
	                {
	                    _19667 = _21316 * min(1.0f, (1.0f - _21780) * asfloat(g_BarnLights.Load4(_12608 * 416 + 144)).w);
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
	                    _11633 = ((_19667 * (asfloat(g_BarnLights.Load4(_12608 * 416 + 128)).w / max(_18345, asfloat(g_BarnLights.Load4(_12608 * 416 + 128)).w))) * clamp(asfloat(g_BarnLights.Load4(_12608 * 416 + 144)).x + (asfloat(g_BarnLights.Load4(_12608 * 416 + 144)).y * _17647), 0.0f, 1.0f)) * clamp(asfloat(g_BarnLights.Load3(_12608 * 416 + 192)).x + (asfloat(g_BarnLights.Load3(_12608 * 416 + 192)).y * dot(float3((1.0f - (_23572 * asfloat(g_BarnLights.Load4(_12608 * 416 + 176)).y)) - _18492, _9058 + _19825, (_14805 * asfloat(g_BarnLights.Load4(_12608 * 416 + 176)).z) - (_17330 * asfloat(g_BarnLights.Load4(_12608 * 416 + 176)).y)), normalize(_10210))), 0.0f, 1.0f);
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
	                    _24419 = !_20061;
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
	                            float _15017 = _22154.y;
	                            float _23041 = (-0.5f) * asfloat(g_BarnLights.Load4(_12608 * 416 + 224)).z;
	                            float _11981 = (asfloat(g_BarnLights.Load4(_12608 * 416 + 224)).x * asfloat(g_BarnLights.Load4(_12608 * 416 + 224)).y) * pow(max(pow(asfloat(g_BarnLights.Load4(_12608 * 416 + 224)).y * _11473, _15266) + pow(asfloat(g_BarnLights.Load4(_12608 * 416 + 224)).x * _15017, _15266), 1.1754943508222875079687365372222e-38f), _23041);
	                            float _16524 = pow(max(pow(_11473, _15266) + pow(_15017, _15266), 1.1754943508222875079687365372222e-38f), _23041);
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
	                        float3 _20493 = _14081;
	                        _20493.x = _20564.x;
	                        _20493.y = _20564.y;
	                        _12503 = _17828.xyz * g_bindless_Texture3D_float4[PerViewLightingConstantBufferGpu_t_1_m19].SampleLevel(undetermined[_Globals_1_g_sTrilinearWrap], _20493.xyz, 0.0f).xyz;
	                    }
	                    else
	                    {
	                        float3 _13791 = float3(mad(_22905.xy, float2(0.5f, -0.5f), 0.5f.xx), asfloat(g_BarnLights.Load4(_12608 * 416 + 160)).w);
	                        float2 _20563 = (_13791.xy * asfloat(g_BarnLights.Load4(_12608 * 416 + 224)).zw) + asfloat(g_BarnLights.Load4(_12608 * 416 + 224)).xy;
	                        float3 _20492 = _13791;
	                        _20492.x = _20563.x;
	                        _20492.y = _20563.y;
	                        _12503 = _17828.xyz * g_bindless_Texture3D_float4[PerViewLightingConstantBufferGpu_t_1_m19].SampleLevel(undetermined[_Globals_1_g_sCookieSampler], _20492.xyz, 0.0f).xyz;
	                    }
	                    _21548 = _12503;
	                }
	                if (all(bool3(_21548.xyz.x == 0.0f.xxx.x, _21548.xyz.y == 0.0f.xxx.y, _21548.xyz.z == 0.0f.xxx.z)))
	                {
	                    _13139 = _13138;
	                    _16381 = _16306;
	                    _16479 = _17134;
	                    break;
	                }
	                float3 _20940;
	                if (_24419)
	                {
	                    float3 _19629;
	                    if ((g_BarnLights.Load(_12608 * 416 + 264) & 4u) != 0u)
	                    {
	                        float2 _6281 = _22905.yx * float2(1.0f, -1.0f);
	                        float3 _23717 = _21642;
	                        _23717.x = _6281.x;
	                        _23717.y = _6281.y;
	                        _19629 = _23717;
	                    }
	                    else
	                    {
	                        _19629 = _21642;
	                    }
	                    float3 _20482 = _21548.xyz * lerp(1.0f, g_bindless_Texture2D_float4[PerViewLightingConstantBufferGpu_t_1_m18].SampleCmpLevelZero(undetermined_1[_Globals_1_g_tShadowDepthBufferCmpSampler], float3(mad(_19629.xy, asfloat(g_BarnLights.Load4(_12608 * 416 + 208)).zw, asfloat(g_BarnLights.Load4(_12608 * 416 + 208)).xy), _19629.z).xy, clamp(_19629.z + PerViewLightingConstantBufferGpu_t_1_m9, 0.0f, 1.0f)), asfloat(g_BarnLights.Load(_12608 * 416 + 260)));
	                    float3 _16449 = _20482.xyz;
	                    if (all(bool3(_16449.x == 0.0f.xxx.x, _16449.y == 0.0f.xxx.y, _16449.z == 0.0f.xxx.z)))
	                    {
	                        _13139 = _13138;
	                        _16381 = _16306;
	                        _16479 = _17134;
	                        break;
	                    }
	                    _20940 = _20482;
	                }
	                else
	                {
	                    _20940 = _21548;
	                }
	                float _11798 = max(0.0f, dot(_12493, _11179.xyz));
	                float2 _18107 = max(_13468, asfloat(g_BarnLights.Load(_12608 * 416 + 256)).xx);
	                float3 _19415 = normalize(_11179.xyz + _21889).xyz;
	                float _16824 = dot(_19415, _19012);
	                float _19852 = max(0.0f, dot(_11179.xyz, _19415));
	                float _16684 = _18107.x;
	                float _21949 = _16684 * _16684;
	                float _19096 = _21949 * _21949;
	                float _15348 = ((_16824 * _16824) * (_19096 - 1.0f)) + 1.0f;
	                _13139 = _13138.xyz + (max(0.0f, -dot(_9145, _11179.xyz)).xxx.xyz * _20940.xyz);
	                _16381 = _16306.xyz + (((_22995 * (_19096 / (((_15348 * _15348) * (_19852 * _19852)) * ((_16684 * 4.0f) + 2.0f)))).xyz * _11798).xyz * _20940.xyz);
	                _16479 = _17134.xyz + (_11798.xxx.xyz * _20940.xyz);
	                break;
	            } while(false);
	            _13138 = _13139;
	            _16306 = _16381;
	            _17134 = _16479;
	            _17018 = _20344;
	            continue;
	        }
	        _21567 = _17017 + 1u;
	        _13137 = _13138;
	        _16305 = _16306;
	        _17133 = _17134;
	        _17017 = _21567;
	        continue;
	    }
	    float _17172 = dot(_13468.xy, 0.5f.xx);
	    float3 _6519 = _17892.xyz;
	    float _17225 = _17172 * _17172;
	    float _20711 = clamp(1.0f - _17225, 0.0f, 1.0f);
	    float4 _15343 = (float4(-1.0f, -0.0274999998509883880615234375f, -0.572000026702880859375f, 0.02199999988079071044921875f) * _17172) + float4(1.0f, 0.0425000004470348358154296875f, 1.03999996185302734375f, -0.039999999105930328369140625f);
	    float _21215 = _15343.x;
	    float2 _24572 = (float2(-1.03999996185302734375f, 1.03999996185302734375f) * ((min(_21215 * _21215, exp2((-9.27999973297119140625f) * max(0.0f, dot(_24254, _6519)))) * _21215) + _15343.y)) + _15343.zw;
	    float _20339 = _24572.y;
	    float2 _11427 = float2(_20339, _24572.x + _20339);
	    float3 _8745 = _19477.xyz;
	    float3 _16992 = _17133.xyz + _8745;
	    float3 _13168 = _20360.xyz;
	    float3 _20321 = ((_17133 + _19477) + (_13137.xyz * (_3401.w * _6671).xxx.xyz)).xyz;
	    float3 _6860 = ((1.0f.xxx * _6671) * _13168) * _20321;
	    float4 _23715;
	    _23715.x = _6860.x;
	    _23715.y = _6860.y;
	    _23715.z = _6860.z;
	    float3 _15752 = _23715.xyz + (_16305 + (((lerp(_11427.xxx, _11427.yyy, _11894) * g_bindless_TextureCubeArray_float4[PerViewConstantBufferCsgo_t_1_m6].SampleLevel(undetermined[_Globals_1_g_sTrilinearClamp], float4(normalize(lerp(_6519, reflect(_8834.xyz, _17892.xyz).xyz, (_20711 * (sqrt(_20711) + _17225)).xxx)), 0.0f), PerViewLightingConstantBufferGpu_t_1_m5.y * sqrt(_17172)).xyz).xyz * (normalize(_16992 + 0.001000000047497451305389404296875f.xxx) * clamp(length(_16992), 0.0f, 1.75f))).xyz * (1.0f.xxx + (normalize(_8745 + 0.001000000047497451305389404296875f.xxx) * 0.5f)))).xyz;
	    float4 _20490;
	    _20490.x = _15752.x;
	    _20490.y = _15752.y;
	    _20490.z = _15752.z;
	    float3 _8712 = 1.0f.xxx * (1.0f - lerp(0.039999999105930328369140625f, 1.0f, pow(1.0f - max(0.0f, dot(_24254, _18457)), 5.0f)));
	    float4 _8673;
	    _8673.x = _8712.x;
	    _8673.y = _8712.y;
	    _8673.z = _8712.z;
	    float3 _21122 = _8673.xyz * pow(_23714.xyz, (1.0f / max(0.00999999977648258209228515625f, sqrt(1.0f - (0.4444444477558135986328125f * (1.0f - (_22668 * _22668)))))).xxx).xyz;
	    float4 _23716;
	    _23716.x = _21122.x;
	    _23716.y = _21122.y;
	    _23716.z = _21122.z;
	    float _7056 = 1.0f - _6671;
	    float3 _9521 = _23716.xyz * _7056;
	    float4 _8674;
	    _8674.x = _9521.x;
	    _8674.y = _9521.y;
	    _8674.z = _9521.z;
	    float3 _20177 = _20490.xyz + ((((_8674.xyz * _6671) * _13168) * _20321) * pow(_23714.xyz, 1.60000002384185791015625f.xxx).xyz);
	    float4 _20491;
	    _20491.x = _20177.x;
	    _20491.y = _20177.y;
	    _20491.z = _20177.z;
	    float3 _3895 = _7542.xyz - PerViewConstantBuffer_t_1_m3.xyz;
	    bool _14876 = _Globals_1_g_bFogEnabled != 0;
	    bool _12888;
	    if (_14876)
	    {
	        _12888 = bool4(PerViewConstantBufferCsgo_t_1_m0.x != int4(0, 0, 0, 0).x, PerViewConstantBufferCsgo_t_1_m0.y != int4(0, 0, 0, 0).y, PerViewConstantBufferCsgo_t_1_m0.z != int4(0, 0, 0, 0).z, PerViewConstantBufferCsgo_t_1_m0.w != int4(0, 0, 0, 0).w).y;
	    }
	    else
	    {
	        _12888 = false;
	    }
	    float4 _13174;
	    float4 _16054;
	    if (_12888)
	    {
	        float2 _9342 = clamp(PerViewConstantBufferCsgo_t_1_m8.xy + (PerViewConstantBufferCsgo_t_1_m8.zw * float2(length(_3895.xyz), _7542.z)), 0.0f.xx, 1.0f.xx);
	        float _12872 = (pow(_9342.x, PerViewConstantBufferCsgo_t_1_m9.x) * pow(_9342.y, PerViewConstantBufferCsgo_t_1_m9.y)) * PerViewConstantBufferCsgo_t_1_m10.w;
	        float3 _7099 = _8674.xyz * (1.0f - _12872);
	        float4 _8675;
	        _8675.x = _7099.x;
	        _8675.y = _7099.y;
	        _8675.z = _7099.z;
	        float3 _10929 = lerp(_20491.xyz, float4(PerViewConstantBufferCsgo_t_1_m10.xyz, _12872).xyz, (_12872 * _7056).xxx);
	        float4 _17842;
	        _17842.x = _10929.x;
	        _17842.y = _10929.y;
	        _17842.z = _10929.z;
	        _13174 = _17842;
	        _16054 = _8675;
	    }
	    else
	    {
	        _13174 = _20491;
	        _16054 = _8674;
	    }
	    bool _12889;
	    if (_14876)
	    {
	        _12889 = bool4(PerViewConstantBufferCsgo_t_1_m0.x != int4(0, 0, 0, 0).x, PerViewConstantBufferCsgo_t_1_m0.y != int4(0, 0, 0, 0).y, PerViewConstantBufferCsgo_t_1_m0.z != int4(0, 0, 0, 0).z, PerViewConstantBufferCsgo_t_1_m0.w != int4(0, 0, 0, 0).w).z;
	    }
	    else
	    {
	        _12889 = false;
	    }
	    float4 _9982;
	    float4 _24109;
	    if (_12889)
	    {
	        float _14602 = clamp(pow(max(0.0f, (length(_3895.xyz) * PerViewConstantBufferCsgo_t_1_m11.y) + PerViewConstantBufferCsgo_t_1_m11.x), PerViewConstantBufferCsgo_t_1_m11.w), 0.0f, 1.0f) * clamp(pow(max(0.0f, (_7542.z * PerViewConstantBufferCsgo_t_1_m12.y) + PerViewConstantBufferCsgo_t_1_m12.x), PerViewConstantBufferCsgo_t_1_m12.z), 0.0f, 1.0f);
	        float _12680 = clamp(_14602, 0.0f, 1.0f) * PerViewConstantBufferCsgo_t_1_m14.w;
	        float3 _9522 = _16054.xyz * (1.0f - _12680);
	        float4 _8676;
	        _8676.x = _9522.x;
	        _8676.y = _9522.y;
	        _8676.z = _9522.z;
	        float3 _10930 = lerp(_13174.xyz, float4((g_bindless_TextureCube_float4[PerViewConstantBufferCsgo_t_1_m4].SampleLevel(undetermined[_Globals_1_g_sTrilinearClamp], normalize(mul(float4(_3895.xyz, 0.0f), float4x4(float4(PerViewConstantBufferCsgo_t_1_m13._m0[0].x, PerViewConstantBufferCsgo_t_1_m13._m0[1].x, PerViewConstantBufferCsgo_t_1_m13._m0[2].x, PerViewConstantBufferCsgo_t_1_m13._m0[3].x), float4(PerViewConstantBufferCsgo_t_1_m13._m0[0].y, PerViewConstantBufferCsgo_t_1_m13._m0[1].y, PerViewConstantBufferCsgo_t_1_m13._m0[2].y, PerViewConstantBufferCsgo_t_1_m13._m0[3].y), float4(PerViewConstantBufferCsgo_t_1_m13._m0[0].z, PerViewConstantBufferCsgo_t_1_m13._m0[1].z, PerViewConstantBufferCsgo_t_1_m13._m0[2].z, PerViewConstantBufferCsgo_t_1_m13._m0[3].z), float4(PerViewConstantBufferCsgo_t_1_m13._m0[0].w, PerViewConstantBufferCsgo_t_1_m13._m0[1].w, PerViewConstantBufferCsgo_t_1_m13._m0[2].w, PerViewConstantBufferCsgo_t_1_m13._m0[3].w))).xyz).xyz, PerViewConstantBufferCsgo_t_1_m12.w * clamp(1.0f - (_14602 * PerViewConstantBufferCsgo_t_1_m11.z), 0.0f, 1.0f)) * PerViewConstantBufferCsgo_t_1_m15.x).xyz, _12680).xyz, (_12680 * _7056).xxx);
	        float4 _17843;
	        _17843.x = _10930.x;
	        _17843.y = _10930.y;
	        _17843.z = _10930.z;
	        _9982 = _17843;
	        _24109 = _8676;
	    }
	    else
	    {
	        _9982 = _13174;
	        _24109 = _16054;
	    }
	    output_0 = float4(_9982.xyz, dot(_24109.xyz, float3(0.2125000059604644775390625f, 0.7153999805450439453125f, 0.07209999859333038330078125f)));
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
	    input_5 = stage_input.input_5;
	    MainPs_inner();
	    PS_OUTPUT stage_output;
	    stage_output.output_0 = output_0;
	    return stage_output;
	}
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
	
	BoolAttribute(BindlessResources, true);
	BoolAttribute(AllowBackfaceCulling, F_RENDER_BACKFACES ? 0 : 1);
	BoolAttribute(DoNotCastShadows, F_DO_NOT_CAST_SHADOWS || 0);
	BoolAttribute(renderbackfaces, F_RENDER_BACKFACES || 0);
	BoolAttribute(SupportsMappingDimensions, true);
	BoolAttribute(SupportsLightmapping, true);
	TextureAttribute(LightSim_DiffuseAlbedoTexture, g_tGlassDust);
	TextureAttribute(RepresentativeTexture, g_tGlassDust);
	BoolAttribute(NeedsLightProbe, true);
	
	#if (S_MODE_DEPTH == 0)
		BoolAttribute(environmentmapped, true);
		BoolAttribute(environmentmappeddynamic, true);
	#endif
	#if (S_OPAQUE_CUBEMAP_REFRACTION == 0)
		BoolAttribute(translucent, true);
		TextureAttribute(LightSim_Opacity_A, g_tGlassDust);
	#endif
	#if (S_SHADER_QUALITY == 0)
		BoolAttribute(translucent, false);
	#endif
	#if (S_OPAQUE_CUBEMAP_REFRACTION == 1)
		BoolAttribute(translucent, false);
	#endif
	#if (S_SHADER_QUALITY == 1)
		BoolAttribute(environmentmapped, true);
		BoolAttribute(environmentmappeddynamic, true);
	#endif
	
	// PSRS
	
	RenderState(BackStencilFunc, F_RENDER_BACKFACES ? 5 : 7);
	RenderState(CullMode, F_RENDER_BACKFACES ? None : Front);
	RenderState(CullMode, F_RENDER_BACKFACES ? None : Back);
	RenderState(DepthEnable, F_DISABLE_Z_BUFFERING ? False : True);
	RenderState(DepthWriteEnable, F_DISABLE_Z_BUFFERING ? False : True);
	RenderState(SlopeScaleDepthBias, 0);
	RenderState(StencilEnable, 1);
	RenderState(StencilFunc, 5);
	RenderState(StencilReadMask, 1);
	RenderState(StencilRef, 3);
	RenderState(StencilWriteMask, 254);
	
	
	BoolAttribute(BindlessResources, true);
	
}
