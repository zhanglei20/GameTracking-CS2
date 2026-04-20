//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "CSGO Weapon StatTrak Shader";
	DevShader = false;
	Version = 2;
	
	// VcsVersion: 70
	// Platform: VULKAN_SM_50
	// Programs: ps, psrs, vs
}

MODES
{
	Depth(S_MODE_DEPTH);
	CsgoForward();
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
	Feature( F_SELF_ILLUM, 0..1, "Self Illum" );
	FeatureRule( Requires( F_DONT_FLIP_BACKFACE_NORMALS, F_RENDER_BACKFACES ), "Only applies to backfaces" );
	FeatureRule( Allow1( F_ALPHA_TEST, F_TRANSLUCENT ), "Translucent and Alpha Test are not compatible" );
	FeatureRule( Requires( F_ADDITIVE_BLEND, F_TRANSLUCENT ), "Requires translucency" );
	FeatureRule( Allow1( F_TRANSLUCENT, F_DO_NOT_CAST_SHADOWS ), "Translucent and Do Not Cast Shadows are not compatible" );
}

COMMON
{
	#include "system.fxc"
}

struct VS_INPUT
{
	float4 vBlendIndices              : BLENDINDICES0  < Semantic( BlendIndices ); >;              // D_CS_VERTEX_ANIMATION=0, S_MODE_TOOLS_VIS=1
	float4 vPerVertexLighting         : COLOR1         < Semantic( PerVertexLighting ); >;         // D_BAKED_LIGHTING_FROM_VERTEX_STREAM=1
	uint4  nPackedFrame               : NORMAL0        < Semantic( CompressedTangentFrame ); >;   
	float4 vNormalOs                  : NORMAL0        < Semantic( Normal ); >;                   
	float3 vPositionOs                : POSITION0      < Semantic( PosXyz ); >;                    // D_CS_VERTEX_ANIMATION=0
	float2 vLightmapUV                : TEXCOORD3      < Semantic( LightmapUV ); >;                // D_BAKED_LIGHTING_FROM_LIGHTMAP=1
	float4 vTangentUOs_flTangentVSign : TANGENT0       < Semantic( TangentU_SignV ); >;           
	float2 vTexCoord                  : TEXCOORD0      < Semantic( LowPrecisionUv ); >;           
	float2 nInstanceIdx               : TEXCOORD13     < Semantic( InstanceTransformUv ); >;      
};

VS
{
	StaticCombo( S_MODE_TOOLS_VIS, 0..1 );
	StaticCombo( S_SHADER_QUALITY, 0..1 );
	StaticComboRule( Requires( S_MODE_TOOLS_VIS, S_SHADER_QUALITY ) );
	DynamicCombo( D_COMPRESSED_NORMALS_AND_TANGENTS, 0..1 );
	DynamicCombo( D_CS_VERTEX_ANIMATION, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_VERTEX_STREAM, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_LIGHTMAP, 0..1 );
	DynamicComboRule( Allow1( D_BAKED_LIGHTING_FROM_VERTEX_STREAM, D_BAKED_LIGHTING_FROM_LIGHTMAP ) );
	
	cbuffer BakedLightingConstantBuffer_t < Attribute("BakedLightingConstantBuffer_t"); >;
	cbuffer PerViewConstantBufferCsgo_t < Attribute("PerViewConstantBufferCsgo_t"); >;
	cbuffer PerViewConstantBuffer_t < Attribute("PerViewConstantBuffer_t"); >;
	ByteAddressBuffer g_animatedVertexCache < Attribute("AnimatedVertexCache"); SrgbRead(false); >;
	bool g_bTexCoordScaleByModel < UiType(CheckBox); Expression((g_nScaleTexCoordUByModelScaleAxis!=0) || (g_nScaleTexCoordVByModelScaleAxis!=0)); >;
	ExternalDescriptorSet g_globalLateBoundBindlessSet < Source(ExternalDescSet); Attribute("g_globalLateBoundBindlessSet"); >;
	StructuredBuffer g_instanceBuffer < Attribute("InstanceBuffer"); SrgbRead(false); >;
	ExternalDescriptorSet g_lightBinnerGpuSet < Source(ExternalDescSet); Attribute("g_lightBinnerGpuSet"); >;
	StructuredBuffer g_transformBuffer < Attribute("TransformBuffer"); SrgbRead(false); >;
	float4 g_vPlayerRenderClipPlane < Attribute("PlayerRenderClipPlane"); UiType(VectorText); >;
	float4 g_vTexCoordScaleByModelU < UiType(VectorText); Expression(float4((g_nScaleTexCoordUByModelScaleAxis==1) || 0,(g_nScaleTexCoordUByModelScaleAxis==2) || 0,(g_nScaleTexCoordUByModelScaleAxis==3) || 0,(g_nScaleTexCoordUByModelScaleAxis==0) || 0)); >;
	float4 g_vTexCoordScaleByModelV < UiType(VectorText); Expression(float4((g_nScaleTexCoordVByModelScaleAxis==1) || 0,(g_nScaleTexCoordVByModelScaleAxis==2) || 0,(g_nScaleTexCoordVByModelScaleAxis==3) || 0,(g_nScaleTexCoordVByModelScaleAxis==0) || 0)); >;
	float4 g_vTexCoordXform0 < UiType(VectorText); Expression(v0 = (g_flTexCoordRotation*3.1415927)/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v1*g_vTexCoordScale.x,-v2*g_vTexCoordScale.y,0,((g_vTexCoordCenter.x+g_vTexCoordOffset.x)+(v2*g_vTexCoordCenter.y))-(v1*g_vTexCoordCenter.x))); >;
	float4 g_vTexCoordXform1 < UiType(VectorText); Expression(v0 = (g_flTexCoordRotation*3.1415927)/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v2*g_vTexCoordScale.x,v1*g_vTexCoordScale.y,0,(g_vTexCoordCenter.y+g_vTexCoordOffset.y)-((v2*g_vTexCoordCenter.x)+(v1*g_vTexCoordCenter.y)))); >;
	
	// Color
	float3 g_vColorTint < Default3(1, 1, 1); UiType(Color); UiGroup("Color,10/20"); Expression(SrgbGammaToLinear(this)); >;
	float g_flModelTintAmount < Default(1); UiType(Slider); UiGroup("Color,10/30"); >;
	float2 g_vTexCoordCenter < Default2(0.5, 0.5); UiType(VectorText); UiGroup("Color/30"); >;
	float2 g_vTexCoordScale < Default2(1, 1); Range2(0, 0, 100, 100); UiType(VectorText); UiGroup("Color/40"); >;
	float g_flTexCoordRotation < Range(-360, 360); UiType(Slider); UiGroup("Color/50"); >;
	float2 g_vTexCoordOffset < Range2(-1, -1, 1, 1); UiType(VectorText); UiGroup("Color/60"); >;
	float2 g_vTexCoordScrollSpeed < Range2(-10, -10, 10, 10); UiType(VectorText); UiGroup("Color/70"); >;
	int g_nScaleTexCoordUByModelScaleAxis < Range4(0, 0, 0, 0, 3, 3, 3, 3); UiOptions("0=None,1=UV.u * model.x,2=UV.u * model.y,3=UV.u * model.z"); UiType(Enum); UiGroup("Color/80"); >;
	int g_nScaleTexCoordVByModelScaleAxis < Range4(0, 0, 0, 0, 3, 3, 3, 3); UiOptions("0=None,1=UV.v * model.x,2=UV.v * model.y,3=UV.v * model.z"); UiType(Enum); UiGroup("Color/90"); >;
	
	// SPIR-V reflection failed for backend HLSL:
	// cbuffer ID 4459 (name: PerViewConstantBuffer_t), member index 1 (name: _m1) cannot be expressed with either HLSL packing layout or packoffset.
	// 
	// Re-attempting reflection with the GLSL backend.
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (7644 bytes), GLSL reflection with SPIRV-Cross by KhronosGroup
	
	#version 460
	
	out float gl_ClipDistance[1];
	
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
	
	struct _1948
	{
	    vec4 _m0[3];
	};
	
	struct _1844
	{
	    _1948 _m0;
	};
	
	struct _450
	{
	    vec4 _m0[4];
	};
	
	layout(set = 4, binding = 32, std430) readonly buffer g_instanceBuffer
	{
	    _1125 _m0[];
	} g_instanceBuffer_1;
	
	layout(set = 4, binding = 30, std430) readonly buffer g_transformBuffer
	{
	    _1844 _m0[];
	} g_transformBuffer_1;
	
	struct _1956
	{
	    _450 _m0;
	    float _m1;
	    vec4 _m2;
	};
	
	layout(set = 0) uniform _1956 PerViewConstantBuffer_t;
	
	struct _1381
	{
	    vec4 g_vTexCoordXform0;
	    vec4 g_vTexCoordXform1;
	    vec2 g_vTexCoordScrollSpeed;
	    vec3 g_vColorTint;
	    float g_flModelTintAmount;
	    vec4 g_vPlayerRenderClipPlane;
	};
	
	layout(set = 0) uniform _1381 _Globals_;
	
	struct _1017
	{
	    vec4 _m0;
	};
	
	layout(set = 0) uniform _1017 PerViewConstantBufferCsgo_t;
	
	layout(location = 0) in vec3 vPositionOs;
	layout(location = 1) in vec2 vTexCoord;
	layout(location = 2) in vec3 vNormalOs;
	layout(location = 3) in vec4 vTangentUOs_flTangentVSign;
	layout(location = 4) in uvec4 vBlendIndices;
	layout(location = 5) in uint nInstanceIdx;
	layout(location = 0) out vec3 output_0;
	layout(location = 1) out vec3 output_1;
	layout(location = 2) out vec4 output_2;
	layout(location = 3) centroid out vec4 output_3;
	layout(location = 4) centroid out vec3 output_4;
	layout(location = 5) out vec4 output_5;
	layout(location = 6) flat out uint output_6;
	
	void main()
	{
	    uint _13771 = (g_instanceBuffer_1._m0[nInstanceIdx]._m5 >> uint(16)) & 15u;
	    uint _21785;
	    if (_13771 == 1u)
	    {
	        _21785 = g_instanceBuffer_1._m0[nInstanceIdx]._m1 + (2u + vBlendIndices.x);
	    }
	    else
	    {
	        _21785 = g_instanceBuffer_1._m0[nInstanceIdx]._m1;
	    }
	    mat3x4 _17839 = mat3x4(g_transformBuffer_1._m0[_21785]._m0._m0[0], g_transformBuffer_1._m0[_21785]._m0._m0[1], g_transformBuffer_1._m0[_21785]._m0._m0[2]);
	    vec3 _21709;
	    if (_13771 > 0u)
	    {
	        _21709 = vec3(g_transformBuffer_1._m0[g_instanceBuffer_1._m0[nInstanceIdx]._m1]._m0._m0[0].z);
	    }
	    else
	    {
	        _21709 = vec3(1.0);
	    }
	    vec4 _23812 = vec4(uvec4((g_instanceBuffer_1._m0[nInstanceIdx]._m0 & 255u), (g_instanceBuffer_1._m0[nInstanceIdx]._m0 & 65280u) >> uint(8), (g_instanceBuffer_1._m0[nInstanceIdx]._m0 & 16711680u) >> uint(16), (g_instanceBuffer_1._m0[nInstanceIdx]._m0 & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	    vec3 _6253 = _23812.xyz;
	    vec3 _17828 = _6253 * vec3(0.077399380505084991455078125);
	    vec3 _7676 = pow((_6253 * vec3(0.947867333889007568359375)) + vec3(0.052132703363895416259765625), vec3(2.400000095367431640625));
	    float _21354;
	    if (_23812.x <= 0.040449999272823333740234375)
	    {
	        _21354 = _17828.x;
	    }
	    else
	    {
	        _21354 = _7676.x;
	    }
	    float _21355;
	    if (_23812.y <= 0.040449999272823333740234375)
	    {
	        _21355 = _17828.y;
	    }
	    else
	    {
	        _21355 = _7676.y;
	    }
	    float _14124;
	    if (_23812.z <= 0.040449999272823333740234375)
	    {
	        _14124 = _17828.z;
	    }
	    else
	    {
	        _14124 = _7676.z;
	    }
	    vec4 _10296 = vec4(_21354, _21355, _14124, _23812.w);
	    vec3 _11179 = normalize(vec4(vNormalOs.xyz, 0.0) * _17839);
	    vec3 _12151 = vec4(vPositionOs.xyz * _21709.xyz, 1.0) * _17839;
	    vec4 _23875 = (vec4(_12151.xyz, 1.0) + (PerViewConstantBuffer_t._m2 * 1.0)).xyzw * mat4(vec4(PerViewConstantBuffer_t._m0._m0[0].x, PerViewConstantBuffer_t._m0._m0[1].x, PerViewConstantBuffer_t._m0._m0[2].x, PerViewConstantBuffer_t._m0._m0[3].x), vec4(PerViewConstantBuffer_t._m0._m0[0].y, PerViewConstantBuffer_t._m0._m0[1].y, PerViewConstantBuffer_t._m0._m0[2].y, PerViewConstantBuffer_t._m0._m0[3].y), vec4(PerViewConstantBuffer_t._m0._m0[0].z, PerViewConstantBuffer_t._m0._m0[1].z, PerViewConstantBuffer_t._m0._m0[2].z, PerViewConstantBuffer_t._m0._m0[3].z), vec4(PerViewConstantBuffer_t._m0._m0[0].w, PerViewConstantBuffer_t._m0._m0[1].w, PerViewConstantBuffer_t._m0._m0[2].w, PerViewConstantBuffer_t._m0._m0[3].w));
	    vec4 _9360 = vTexCoord.xyxy;
	    _9360.x = dot(vTexCoord.xy, _Globals_.g_vTexCoordXform0.xy) + _Globals_.g_vTexCoordXform0.w;
	    _9360.y = dot(vTexCoord.xy, _Globals_.g_vTexCoordXform1.xy) + _Globals_.g_vTexCoordXform1.w;
	    vec2 _22490 = _9360.xy + (_Globals_.g_vTexCoordScrollSpeed.xy * PerViewConstantBuffer_t._m1);
	    vec4 _20488 = _9360;
	    _20488.x = _22490.x;
	    _20488.y = _22490.y;
	    vec3 _23588 = mix(vec3(1.0), _10296.xyz, vec3(_Globals_.g_flModelTintAmount));
	    vec4 _17842 = _10296;
	    _17842.x = _23588.x;
	    _17842.y = _23588.y;
	    _17842.z = _23588.z;
	    vec3 _13062 = _17842.xyz * _Globals_.g_vColorTint.xyz;
	    vec4 _23714 = _17842;
	    _23714.x = _13062.x;
	    _23714.y = _13062.y;
	    _23714.z = _13062.z;
	    vec3 _19170 = _12151.xyz;
	    output_0 = _19170 - PerViewConstantBufferCsgo_t._m0.xyz;
	    output_1 = _11179;
	    output_2 = _20488;
	    output_3 = _23714;
	    output_4 = _11179;
	    output_5 = vec4(normalize(vec4(vTangentUOs_flTangentVSign.xyz, 0.0) * _17839), vTangentUOs_flTangentVSign.w);
	    output_6 = (g_instanceBuffer_1._m0[nInstanceIdx]._m5) & 65535u;
	    _23875.y = -_23875.y;
	    gl_Position = _23875;
	    gl_ClipDistance[0] = dot(vec4(_19170, 1.0), vec4(_Globals_.g_vPlayerRenderClipPlane.xyz, -_Globals_.g_vPlayerRenderClipPlane.w));
	}
	
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
	
	BoolAttribute(environmentmapped, true);
	BoolAttribute(environmentmappeddynamic, true);
	BoolAttribute(CanBatchWithDynamicShaderConstants, true);
	IntAttribute(TexCoordScaleByModelU, g_nScaleTexCoordUByModelScaleAxis-1);
	IntAttribute(TexCoordScaleByModelV, g_nScaleTexCoordVByModelScaleAxis-1);
	Float3Attribute(LightSim_MaterialTint, g_vColorTint);
	BoolAttribute(SupportsAggregateInstancing, F_TRANSLUCENT==0);
	
}

PS
{
	StaticCombo( S_MODE_TOOLS_VIS, 0..1 );
	StaticCombo( S_ALPHA_TEST, F_ALPHA_TEST );
	StaticCombo( S_TRANSLUCENT, F_TRANSLUCENT );
	StaticCombo( S_ADDITIVE_BLEND, F_ADDITIVE_BLEND );
	StaticCombo( S_SELF_ILLUM, F_SELF_ILLUM );
	StaticCombo( S_MODE_DEPTH, 0..1 );
	StaticComboRule( Requires( S_ADDITIVE_BLEND, S_MODE_DEPTH=0 ) );
	StaticComboRule( Allow1( S_ALPHA_TEST, S_TRANSLUCENT ) );
	StaticComboRule( Requires( S_ADDITIVE_BLEND, S_TRANSLUCENT ) );
	DynamicCombo( D_BAKED_LIGHTING_FROM_VERTEX_STREAM, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_PROBE, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_LIGHTMAP, 0..1 );
	DynamicCombo( D_SPECULAR_CUBE_MAP_STATIC, 0..1 );
	DynamicComboRule( Allow1( D_BAKED_LIGHTING_FROM_PROBE, D_BAKED_LIGHTING_FROM_VERTEX_STREAM, D_BAKED_LIGHTING_FROM_LIGHTMAP ) );
	DynamicComboRule( Requires( D_SPECULAR_CUBE_MAP_STATIC, S_MODE_DEPTH=0 ) );
	
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
	float3 g_cInvulnerabilityColor < Attribute("InvulnerabilityColor"); UiType(VectorText); >;
	float g_fToolsVisHeightTint < Default(0.9); Attribute("g_fToolsVisHeightTint"); UiType(Slider); >;
	float g_fToolsVisMaxHeightRange < Default(1); Attribute("g_fToolsVisMaxHeightRange"); UiType(Slider); >;
	float g_fToolsVisMaxLightingComplexity < Default(8); Attribute("g_fToolsVisMaxLightingComplexity"); UiType(Slider); >;
	float g_flReflectance < UiType(Slider); Expression(pow((1.5-1)/(1.5+1),2)); >;
	float g_flSpawnInvulnerability < Attribute("SpawnInvulnerability"); UiType(Slider); >;
	ExternalDescriptorSet g_globalLateBoundBindlessSet < Source(ExternalDescSet); Attribute("g_globalLateBoundBindlessSet"); >;
	ExternalDescriptorSet g_lightBinnerGpuSet < Source(ExternalDescSet); Attribute("g_lightBinnerGpuSet"); >;
	int g_nToolsVisMode < Attribute("g_nToolsVisMode"); UiType(Slider); >;
	Texture2D g_tAmbientOcclusion < Channel(R, Box3(TextureAmbientOcclusion), Linear); OutputFormat(ATI1N); SrgbRead(false); >;
	Texture2DArray g_tBRDFLookup < Attribute("BRDFLookup"); SrgbRead(false); >;
	Texture2D g_tBlueNoise < Attribute("BlueNoise"); SrgbRead(false); >;
	Texture2D g_tColor < Channel(RGBA, ArtistDefined(TextureColor1), Srgb); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tDynamicAmbientOcclusion < Attribute("DynamicAmbientOcclusion"); SrgbRead(false); >;
	Texture2D g_tDynamicAmbientOcclusionDepth < Attribute("DynamicAmbientOcclusionDepth"); SrgbRead(false); >;
	TextureCubeArray g_tEnvironmentMap < Attribute("EnvironmentMap"); SrgbRead(false); >;
	TextureCube g_tFogCubeTexture < Attribute("CubemapFogTexture"); SrgbRead(true); >;
	Texture3D g_tLPV_Irradiance < Attribute("LPV_Irradiance"); SrgbRead(false); >;
	Texture3D g_tLPV_Shadows < Attribute("LPV_DirectShadows"); SrgbRead(false); >;
	Texture3D g_tLightCookieTexture < Attribute("LightCookieTexture"); SrgbRead(true); >;
	Texture2DArray g_tLightmap0 < Attribute("direct_light_shadows"); SrgbRead(false); >;
	Texture2DArray g_tLightmap1 < Attribute("irradiance"); SrgbRead(false); >;
	Texture2DArray g_tLightmap2 < Attribute("directional_irradiance"); SrgbRead(false); >;
	Texture2DArray g_tLightmap3 < Attribute("debug_chart_color"); SrgbRead(false); >;
	Texture2D g_tMetalness < Channel(R, BoxInverse(TextureRoughness1), Linear); Channel(G, Box(TextureMetalness1), Linear); OutputFormat(ATI2N); SrgbRead(false); >;
	Texture2D g_tNormal < Channel(RG, HemiOctIsoRoughness_RG_B(TextureNormal), Linear); OutputFormat(ATI2N); SrgbRead(false); >;
	Texture2D g_tParticleShadowBuffer < Attribute("ParticleShadowBuffer"); SrgbRead(false); >;
	Texture2D g_tSelfIllumMask < Channel(RGB, Box(TextureSelfIllumMask), Srgb); OutputFormat(DXT1); SrgbRead(true); >;
	Texture2D g_tShadowDepthBufferDepth < Attribute("ShadowDepthBuffer"); SrgbRead(false); >;
	Texture2D g_tSsao < Attribute("SSAOOcclusionFactor"); SrgbRead(false); >;
	float3 g_vFlatOverlayColor < Default2(1, 0); Attribute("FlatOverlayColor"); UiType(VectorText); >;
	float3 g_vSelfIllumTintScaled < UiType(VectorText); Expression((pow(2,g_flSelfIllumBrightness).x*g_flSelfIllumScale.x)*SrgbGammaToLinear(g_vSelfIllumTint.xyz)); >;
	float4 g_vShaderIDColor < Source(ShaderIDColor); UiType(VectorText); >;
	
	// Ambient Occlusion
	CreateInputTexture2D(TextureAmbientOcclusion, Linear, 8, "", "_ao", "Ambient Occlusion/10", Default4(1, 1, 1, 0));
	
	// Color
	CreateInputTexture2D(TextureColor1, Srgb, 8, "", "_color", "Color/11", Default4(1, 1, 1, 1));
	
	// Lighting
	float g_flMetalnessTransitionBias < Default(2); Range(0.001, 3); UiType(Slider); UiGroup("Lighting,30/Metalness,50/10"); >;
	float2 g_vMetalnessRemapRange < Default(0); UiType(VectorText); UiGroup("Lighting,30/Metalness,40/10"); >;
	CreateInputTexture2D(TextureMetalness1, Linear, 8, "", "_metal", "Lighting,30/Metalness,30/11", Default4(0, 0, 0, 0));
	CreateInputTexture2D(TextureRoughness1, Linear, 8, "Inverse", "_rough", "Lighting,30/Roughness,20/11", Default4(0.5, 0.5, 0.5, 0));
	
	// Normal Map
	CreateInputTexture2D(TextureNormal, Linear, 8, "NormalizeNormals", "_normal", "Normal Map,20", Default4(0.5, 0.5, 1, 0));
	
	// Self Illum
	float g_flSelfIllumBrightness < Range(-10, 10); UiType(Slider); UiGroup("Self Illum"); >;
	CreateInputTexture2D(TextureSelfIllumMask, Srgb, 8, "", "_selfillum", "Self Illum/10", Default4(0, 0, 0, 0));
	float3 g_vSelfIllumTint < Default3(1, 1, 1); UiType(Color); UiGroup("Self Illum/20"); >;
	float g_flSelfIllumScale < Default(1); UiType(Slider); UiGroup("Self Illum/30"); >;
	float2 g_vSelfIllumScrollSpeed < Range2(-10, -10, 10, 10); UiType(VectorText); UiGroup("Self Illum/40"); >;
	float g_flSelfIllumAlbedoFactor < Default(1); UiType(Slider); UiGroup("Self Illum/50"); >;
	
	// Fog
	bool g_bFogEnabled < Default(1); UiType(CheckBox); UiGroup("Fog"); >;
	
	// Translucent
	float g_flAlphaTestReference < Default(0.5); Range(0.01, 0.99); UiType(Slider); UiGroup("Translucent"); >;
	float g_flAntiAliasedEdgeStrength < Default(1); UiType(Slider); UiGroup("Translucent"); >;
	float g_flOpacityScale < Default(1); UiType(Slider); UiGroup("Translucent"); >;
	
	// StatTrak
	int g_nStatTrakValue < Range(-1, 999999); UiType(Slider); UiGroup("StatTrak"); >;
	
	// Texture Address Mode
	int g_nTextureAddressModeU < UiOption("RsTextureAddressMode_t"); UiType(Enum); UiGroup("Texture Address Mode"); >;
	int g_nTextureAddressModeV < UiOption("RsTextureAddressMode_t"); UiType(Enum); UiGroup("Texture Address Mode"); >;
	
	
	// SPIR-V reflection failed for backend HLSL:
	// cbuffer ID 5538 (name: PerViewLightingConstantBufferGpu_t), member index 15 (name: _m15) cannot be expressed with either HLSL packing layout or packoffset.
	// 
	// Re-attempting reflection with the GLSL backend.
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (55660 bytes), GLSL reflection with SPIRV-Cross by KhronosGroup
	
	#version 460
	#extension GL_KHR_shader_subgroup_arithmetic : require
	#extension GL_EXT_samplerless_texture_functions : require
	
	struct _239
	{
	    vec4 _m0[4];
	};
	
	const uint _1118[6] = uint[](100000u, 10000u, 1000u, 100u, 10u, 1u);
	
	struct _2016
	{
	    vec4 _m0[3];
	};
	
	struct _240
	{
	    vec4 _m0[4];
	};
	
	struct _2017
	{
	    vec4 _m0[3];
	};
	
	struct _2526
	{
	    _2017 _m0;
	    vec3 _m1;
	    uint _m2;
	    vec3 _m3;
	    vec4 _m4;
	    vec3 _m5;
	    vec4 _m6;
	};
	
	struct _651
	{
	    _2526 _m0[128];
	};
	
	struct _925
	{
	    _239 _m0[4];
	};
	
	struct _1265
	{
	    _239 _m0;
	    _239 _m1;
	    vec4 _m2;
	    vec4 _m3;
	    vec4 _m4;
	    vec4 _m5;
	    vec3 _m6;
	    uint _m7;
	    vec4 _m8;
	    vec4 _m9;
	    vec4 _m10;
	    float _m11;
	    float _m12;
	    uint _m13;
	    int _m14;
	    _2017 _m15;
	    vec4 _m16;
	    vec4 _m17;
	    vec4 _m18;
	    vec4 _m19;
	    vec4 _m20;
	    vec3 _m21;
	    float _m22;
	};
	
	vec4 _4;
	vec3 _5;
	
	struct _1374
	{
	    int g_bFogEnabled;
	    int g_bDontFlipBackfaceNormals;
	    int g_bRenderBackfaceNormals;
	    float g_flReflectance;
	    vec2 g_vMetalnessRemapRange;
	    float g_flMetalnessTransitionBias;
	    int g_nStatTrakValue;
	    float g_flSpawnInvulnerability;
	    vec3 g_cInvulnerabilityColor;
	};
	
	layout(set = 1) uniform _1374 _Globals_;
	
	struct _1616
	{
	    float _m0;
	    vec2 _m1;
	    vec2 _m2;
	    vec4 _m3;
	    float _m4;
	    vec4 _m5;
	    vec3 _m6;
	    vec3 _m7;
	};
	
	layout(set = 1) uniform _1616 PerViewConstantBuffer_t;
	
	struct _614
	{
	    ivec4 _m0;
	    ivec4 _m1;
	    ivec4 _m2;
	    ivec4 _m3;
	    ivec2 _m4;
	    _239 _m5;
	    vec2 _m6;
	    float _m7;
	    vec4 _m8;
	    vec4 _m9;
	    vec4 _m10;
	    vec4 _m11;
	    vec4 _m12;
	    vec4 _m13;
	    _239 _m14;
	    vec4 _m15;
	    vec4 _m16;
	    vec4 _m17;
	    float _m18;
	    float _m19;
	};
	
	layout(set = 1) uniform _614 PerViewConstantBufferCsgo_t;
	
	struct _2966
	{
	    vec4 _m0;
	    vec4 _m1;
	    vec4 _m2;
	    vec4 _m3;
	    vec4 _m4;
	    _2016 _m5;
	    _240 _m6;
	    vec4 _m7;
	    vec4 _m8;
	    vec4 _m9;
	    uvec4 _m10;
	    uvec4 _m11;
	    uvec4 _m12;
	    vec4 _m13;
	    vec4 _m14;
	    _651 _m15;
	    vec4 _m16;
	    vec4 _m17;
	    int _m18;
	    float _m19;
	    vec4 _m20;
	    float _m21;
	    float _m22;
	    float _m23;
	    float _m24;
	    _925 _m25;
	    _240 _m26;
	};
	
	layout(set = 3) uniform _2966 PerViewLightingConstantBufferGpu_t;
	
	layout(set = 3, binding = 30, std430) readonly buffer g_CullBits
	{
	    uint _m0[];
	} g_CullBits_1;
	
	layout(set = 3, binding = 31, std430) readonly buffer g_BarnLights
	{
	    _1265 _m0[];
	} g_BarnLights_1;
	
	layout(set = 1, binding = 43) uniform texture2D g_tColor;
	layout(set = 1, binding = 20) uniform sampler g_sUserConfigAllowGlobalMipBias;
	layout(set = 1, binding = 57) uniform texture2D g_tAmbientOcclusion;
	layout(set = 1, binding = 19) uniform sampler g_sUserConfig;
	layout(set = 1, binding = 44) uniform texture2D g_tMetalness;
	layout(set = 1, binding = 55) uniform texture2D g_tNormal;
	layout(set = 1, binding = 38) uniform texture2D g_tDynamicAmbientOcclusionDepth;
	layout(set = 1, binding = 22) uniform sampler g_sCookieSampler;
	layout(set = 1, binding = 37) uniform texture2D g_tDynamicAmbientOcclusion;
	layout(set = 1, binding = 18) uniform sampler g_sPointClamp;
	layout(set = 1, binding = 39) uniform texture2D g_tSsao;
	layout(set = 1, binding = 23) uniform samplerShadow g_tShadowDepthBufferCmpSampler;
	layout(set = 1, binding = 36) uniform texture2D g_tShadowDepthBufferDepth;
	layout(set = 1, binding = 53) uniform texture2D g_tParticleShadowBuffer;
	layout(set = 1, binding = 17) uniform sampler g_sTrilinearClamp;
	layout(set = 1, binding = 34) uniform texture3D g_tLightCookieTexture;
	layout(set = 1, binding = 16) uniform sampler g_sTrilinearWrap;
	layout(set = 1, binding = 40) uniform textureCubeArray g_tEnvironmentMap;
	layout(set = 1, binding = 15) uniform sampler g_sBilinearClamp;
	layout(set = 1, binding = 35) uniform texture2DArray g_tBRDFLookup_unexpectedTypeId470_1107;
	layout(set = 1, binding = 42) uniform textureCube g_tFogCubeTexture;
	layout(set = 1, binding = 30) uniform texture2D g_tBlueNoise;
	
	layout(location = 0) in vec3 input_0;
	layout(location = 1) in vec3 input_1;
	layout(location = 2) in vec4 input_2;
	layout(location = 3) centroid in vec4 input_3;
	layout(location = 4) centroid in vec3 input_4;
	layout(location = 5) in vec4 input_5;
	layout(location = 0) out vec4 output_0;
	
	void main()
	{
	    vec4 _11408 = gl_FragCoord;
	    _11408.w = 1.0 / _11408.w;
	    float _6262 = input_2.x * 6.0;
	    int _11326 = clamp(int(_6262), 0, 5);
	    ivec2 _19891;
	    if (_Globals_.g_nStatTrakValue >= 0)
	    {
	        uint _24507 = uint(_Globals_.g_nStatTrakValue) / _1118[_11326];
	        _19891 = ivec2(int(uint(int((_24507 != 0u) || (_11326 == 5))) + (_24507 % 10u)), 0);
	    }
	    else
	    {
	        _19891 = ivec2(_11326, int(1u + (uint(int(PerViewConstantBuffer_t._m0)) % 5u)));
	    }
	    float _18785 = (float(_19891.x) * 0.0625) + (fract(_6262) * 0.0546875);
	    float _19984 = ((float(_19891.y) * 0.125) + (input_2.y * 0.07421875)) + (float(_11326) * 64.0);
	    vec4 _23284;
	    _23284.x = _18785;
	    _23284.y = _19984;
	    vec3 _21709;
	    if (dot(input_1.xyz, input_1.xyz) >= 1.0099999904632568359375)
	    {
	        _21709 = input_4.xyz;
	    }
	    else
	    {
	        _21709 = input_1.xyz;
	    }
	    bool _14874 = _Globals_.g_bRenderBackfaceNormals != 0;
	    bool _12885;
	    if (_14874)
	    {
	        _12885 = !(_Globals_.g_bDontFlipBackfaceNormals != 0);
	    }
	    else
	    {
	        _12885 = false;
	    }
	    vec3 _10251;
	    if (_12885)
	    {
	        _10251 = _21709 * (gl_FrontFacing ? 1.0 : (-1.0));
	    }
	    else
	    {
	        _10251 = _21709;
	    }
	    vec3 _24347 = normalize(_10251);
	    vec3 _7639 = input_0 + PerViewConstantBufferCsgo_t._m17.xyz;
	    vec4 _19680 = texture(sampler2D(g_tColor, g_sUserConfigAllowGlobalMipBias), _23284.xy);
	    vec4 _18992 = texture(sampler2D(g_tAmbientOcclusion, g_sUserConfig), vec2(_18785, _19984).xy);
	    float _18168 = _18992.x;
	    vec4 _21760 = texture(sampler2D(g_tMetalness, g_sUserConfig), _23284.xy);
	    float _20060 = mix(_Globals_.g_vMetalnessRemapRange.x, _Globals_.g_vMetalnessRemapRange.y, _21760.y);
	    vec4 _19372 = texture(sampler2D(g_tNormal, g_sUserConfig), _23284.xy);
	    float _16000 = _19372.x;
	    float _19720 = _19372.y;
	    float _16783 = (_16000 + _19720) - 1.00392162799835205078125;
	    float _11176 = _16000 - _19720;
	    vec3 _8418 = normalize(vec3(vec2(_16783, _11176), (1.0 - abs(_16783)) - abs(_11176)));
	    bool _12886;
	    if (_14874)
	    {
	        _12886 = !(_Globals_.g_bDontFlipBackfaceNormals != 0);
	    }
	    else
	    {
	        _12886 = false;
	    }
	    bool _24327;
	    if (_12886)
	    {
	        _24327 = (gl_FrontFacing ? 1.0 : (-1.0)) < 0.0;
	    }
	    else
	    {
	        _24327 = false;
	    }
	    vec3 _12631 = input_1.xyz * (_24327 ? (-1.0) : 1.0);
	    vec3 _14435 = cross(_12631.xyz, input_5.xyz) * ((input_5.w > 0.0) ? 1.0 : (-1.0));
	    vec3 _7424;
	    if (notEqual(PerViewConstantBufferCsgo_t._m3, ivec4(0)).w)
	    {
	        _7424 = -_14435;
	    }
	    else
	    {
	        _7424 = _14435;
	    }
	    vec3 _20480;
	    if (!_24327)
	    {
	        vec3 _7482 = _8418;
	        _7482.y = -_8418.y;
	        _20480 = _7482;
	    }
	    else
	    {
	        _20480 = _8418;
	    }
	    vec3 _14786 = normalize((((input_5.xyz * _20480.x).xyz + (_7424.xyz * _20480.y)).xyz + (_12631.xyz * _20480.z)).xyz);
	    vec3 _12739 = (_19680.xyz * input_3.xyz).xyz;
	    vec3 _12351 = mix(vec3(_Globals_.g_flReflectance).xyz, _12739, vec3(_20060));
	    vec3 _17892 = mix(vec3(1.0), _14786, bvec3(all(bvec3(true))));
	    vec3 _10560 = _24347.xyz;
	    vec3 _11099 = dFdx(_10560);
	    vec3 _9175 = dFdy(_10560);
	    vec3 _10347 = _11099.xyz;
	    vec3 _12420 = _9175.xyz;
	    vec2 _11004 = max(vec2(_21760.x).xy, vec2(pow(clamp(max(dot(_10347, _10347), dot(_12420, _12420)), 0.0, 1.0), 0.333000004291534423828125)));
	    bvec4 _24465 = notEqual(PerViewConstantBufferCsgo_t._m1, ivec4(0));
	    float _21710;
	    if (_24465.x)
	    {
	        vec3 _11394 = _24347.xyz;
	        vec2 _10547 = ((floor(_11408.xy * PerViewConstantBufferCsgo_t._m7) * PerViewConstantBufferCsgo_t._m6.xy) + (PerViewConstantBufferCsgo_t._m6.xy * 0.5)).xy;
	        vec4 _18418 = textureGather(sampler2D(g_tDynamicAmbientOcclusionDepth, g_sCookieSampler), _10547).xyzw - _11408.zzzz;
	        float _18579 = _18418.w;
	        float _12013 = _18418.z;
	        bool _12285 = abs(_12013) < _18579;
	        vec2 _23168;
	        if (_12285)
	        {
	            _23168 = vec2(PerViewConstantBufferCsgo_t._m6.x, 0.0);
	        }
	        else
	        {
	            _23168 = vec2(0.0);
	        }
	        float _20965 = _12285 ? _12013 : _18579;
	        float _15372 = _18418.x;
	        bool _12286 = abs(_15372) < _20965;
	        vec2 _23169;
	        if (_12286)
	        {
	            _23169 = vec2(0.0, PerViewConstantBufferCsgo_t._m6.y);
	        }
	        else
	        {
	            _23169 = _23168;
	        }
	        vec4 _17422 = (max(vec4(dot(PerViewLightingConstantBufferGpu_t._m6._m0[0].xyz, _11394), dot(PerViewLightingConstantBufferGpu_t._m6._m0[1].xyz, _11394), dot(PerViewLightingConstantBufferGpu_t._m6._m0[2].xyz, _11394), dot(PerViewLightingConstantBufferGpu_t._m6._m0[3].xyz, _11394)).xyzw, vec4(0.0)).xyzw * PerViewLightingConstantBufferGpu_t._m7.xyzw).xyzw;
	        _21710 = (1.0 / (dot(_17422, vec4(1.0)) + PerViewLightingConstantBufferGpu_t._m8.x)) * (PerViewLightingConstantBufferGpu_t._m8.x + dot(_17422, textureLod(sampler2D(g_tDynamicAmbientOcclusion, g_sPointClamp), (_10547 + mix(_23169, PerViewConstantBufferCsgo_t._m6.xy, bvec2(abs(_18418.y) < (_12286 ? _15372 : _20965))).xy).xy, 0.0).xyzw));
	    }
	    else
	    {
	        _21710 = 1.0;
	    }
	    float _21785;
	    if (notEqual(PerViewConstantBufferCsgo_t._m0, ivec4(0)).w)
	    {
	        _21785 = _21710 * textureLod(sampler2D(g_tSsao, g_sUserConfig), (_11408.xy * PerViewConstantBuffer_t._m3.xy).xy, 0.0).x;
	    }
	    else
	    {
	        _21785 = _21710;
	    }
	    vec3 _24735 = _14786.xyz;
	    vec4 _23875 = vec4(_24735, 1.0);
	    vec3 _18708 = vec3(dot(PerViewLightingConstantBufferGpu_t._m5._m0[0].xyzw, _23875), dot(PerViewLightingConstantBufferGpu_t._m5._m0[1].xyzw, _23875), dot(PerViewLightingConstantBufferGpu_t._m5._m0[2].xyzw, _23875));
	    float _21711;
	    if (PerViewLightingConstantBufferGpu_t._m18 != 0)
	    {
	        int _23989;
	        int _10191;
	        float _13136;
	        vec3 _14975;
	        int _13039 = 0;
	        for (;;)
	        {
	            if (!(_13039 < PerViewLightingConstantBufferGpu_t._m18))
	            {
	                _13136 = 1.0;
	                _14975 = vec3(0.0);
	                _10191 = -1;
	                break;
	            }
	            vec4 _18322 = vec4(input_0.xyz, 1.0) * mat4(vec4(PerViewLightingConstantBufferGpu_t._m25._m0[_13039]._m0[0].x, PerViewLightingConstantBufferGpu_t._m25._m0[_13039]._m0[1].x, PerViewLightingConstantBufferGpu_t._m25._m0[_13039]._m0[2].x, PerViewLightingConstantBufferGpu_t._m25._m0[_13039]._m0[3].x), vec4(PerViewLightingConstantBufferGpu_t._m25._m0[_13039]._m0[0].y, PerViewLightingConstantBufferGpu_t._m25._m0[_13039]._m0[1].y, PerViewLightingConstantBufferGpu_t._m25._m0[_13039]._m0[2].y, PerViewLightingConstantBufferGpu_t._m25._m0[_13039]._m0[3].y), vec4(PerViewLightingConstantBufferGpu_t._m25._m0[_13039]._m0[0].z, PerViewLightingConstantBufferGpu_t._m25._m0[_13039]._m0[1].z, PerViewLightingConstantBufferGpu_t._m25._m0[_13039]._m0[2].z, PerViewLightingConstantBufferGpu_t._m25._m0[_13039]._m0[3].z), vec4(PerViewLightingConstantBufferGpu_t._m25._m0[_13039]._m0[0].w, PerViewLightingConstantBufferGpu_t._m25._m0[_13039]._m0[1].w, PerViewLightingConstantBufferGpu_t._m25._m0[_13039]._m0[2].w, PerViewLightingConstantBufferGpu_t._m25._m0[_13039]._m0[3].w));
	            float _12779 = _18322.x;
	            if (max(abs(_12779), abs(_18322.y)) < PerViewLightingConstantBufferGpu_t._m20[_13039])
	            {
	                vec3 _19470 = vec3(_12779, _18322.yz);
	                vec2 _24804 = _19470.xy;
	                vec2 _22193 = vec2(1.0) - clamp((abs(_24804) * vec2(PerViewLightingConstantBufferGpu_t._m22)) + vec2(PerViewLightingConstantBufferGpu_t._m21), vec2(0.0), vec2(1.0));
	                vec2 _20561 = (_24804 * PerViewLightingConstantBufferGpu_t._m26._m0[_13039].zw) + PerViewLightingConstantBufferGpu_t._m26._m0[_13039].xy;
	                vec3 _20488 = _19470;
	                _20488.x = _20561.x;
	                _20488.y = _20561.y;
	                _13136 = saturate(_22193.x * _22193.y);
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
	            vec2 _7045;
	            vec2 _7046;
	            vec2 _7735;
	            float _8969;
	            float _8970;
	            float _15996;
	            float _17299;
	            vec2 _18870;
	            vec4 _20581;
	            vec4 _22023;
	            float _23727;
	            do
	            {
	                float _21452 = saturate(_14975.z + PerViewLightingConstantBufferGpu_t._m19);
	                _20581 = PerViewLightingConstantBufferGpu_t._m0;
	                _22023 = PerViewLightingConstantBufferGpu_t._m1;
	                _17299 = PerViewLightingConstantBufferGpu_t._m2.z;
	                _15996 = PerViewLightingConstantBufferGpu_t._m3.z;
	                _18870 = vec2(_17299, _15996);
	                _8969 = PerViewLightingConstantBufferGpu_t._m2.y;
	                _7045 = vec2(_8969, _15996);
	                _8970 = PerViewLightingConstantBufferGpu_t._m3.y;
	                _7046 = vec2(_17299, _8970);
	                _7735 = vec2(_8969, _8970);
	                float _15310 = dot(vec4(textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_14975.xy + _18870).xy, _21452), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_14975.xy + _7045).xy, _21452), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_14975.xy + _7046).xy, _21452), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_14975.xy + _7735).xy, _21452), 0.0)).xyzw, vec4(0.25));
	                bool _12887;
	                if (_15310 == 0.0)
	                {
	                    _12887 = true;
	                }
	                else
	                {
	                    _12887 = _15310 == 1.0;
	                }
	                if (_12887)
	                {
	                    _23727 = _15310;
	                    break;
	                }
	                _23727 = ((_15310 * (_20581.w * 4.0)) + dot(vec4(textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_14975.xy + vec2(_17299, 0.0)).xy, _21452), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_14975.xy + vec2(_8969, 0.0)).xy, _21452), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_14975.xy + vec2(0.0, _8970)).xy, _21452), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_14975.xy + vec2(0.0, _15996)).xy, _21452), 0.0)).xyzw, _22023.xxxx)) + (textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3(_14975.xy, _21452), 0.0) * _22023.y);
	                break;
	            } while(false);
	            float _12502;
	            if (_13136 < 1.0)
	            {
	                float _7934;
	                if (_10191 < (PerViewLightingConstantBufferGpu_t._m18 - 1))
	                {
	                    int _15335 = _10191 + 1;
	                    vec4 _19671 = vec4(input_0.xyz, 1.0) * mat4(vec4(PerViewLightingConstantBufferGpu_t._m25._m0[_15335]._m0[0].x, PerViewLightingConstantBufferGpu_t._m25._m0[_15335]._m0[1].x, PerViewLightingConstantBufferGpu_t._m25._m0[_15335]._m0[2].x, PerViewLightingConstantBufferGpu_t._m25._m0[_15335]._m0[3].x), vec4(PerViewLightingConstantBufferGpu_t._m25._m0[_15335]._m0[0].y, PerViewLightingConstantBufferGpu_t._m25._m0[_15335]._m0[1].y, PerViewLightingConstantBufferGpu_t._m25._m0[_15335]._m0[2].y, PerViewLightingConstantBufferGpu_t._m25._m0[_15335]._m0[3].y), vec4(PerViewLightingConstantBufferGpu_t._m25._m0[_15335]._m0[0].z, PerViewLightingConstantBufferGpu_t._m25._m0[_15335]._m0[1].z, PerViewLightingConstantBufferGpu_t._m25._m0[_15335]._m0[2].z, PerViewLightingConstantBufferGpu_t._m25._m0[_15335]._m0[3].z), vec4(PerViewLightingConstantBufferGpu_t._m25._m0[_15335]._m0[0].w, PerViewLightingConstantBufferGpu_t._m25._m0[_15335]._m0[1].w, PerViewLightingConstantBufferGpu_t._m25._m0[_15335]._m0[2].w, PerViewLightingConstantBufferGpu_t._m25._m0[_15335]._m0[3].w));
	                    vec2 _20562 = (_19671.xy * PerViewLightingConstantBufferGpu_t._m26._m0[_15335].zw) + PerViewLightingConstantBufferGpu_t._m26._m0[_15335].xy;
	                    vec3 _20489;
	                    _20489.x = _20562.x;
	                    _20489.y = _20562.y;
	                    float _12501;
	                    do
	                    {
	                        float _20322 = saturate(_19671.z + PerViewLightingConstantBufferGpu_t._m19);
	                        float _15311 = dot(vec4(textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_20489.xy + _18870).xy, _20322), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_20489.xy + _7045).xy, _20322), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_20489.xy + _7046).xy, _20322), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_20489.xy + _7735).xy, _20322), 0.0)).xyzw, vec4(0.25));
	                        bool _12888;
	                        if (_15311 == 0.0)
	                        {
	                            _12888 = true;
	                        }
	                        else
	                        {
	                            _12888 = _15311 == 1.0;
	                        }
	                        if (_12888)
	                        {
	                            _12501 = _15311;
	                            break;
	                        }
	                        _12501 = ((_15311 * (_20581.w * 4.0)) + dot(vec4(textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_20489.xy + vec2(_17299, 0.0)).xy, _20322), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_20489.xy + vec2(_8969, 0.0)).xy, _20322), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_20489.xy + vec2(0.0, _8970)).xy, _20322), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_20489.xy + vec2(0.0, _15996)).xy, _20322), 0.0)).xyzw, _22023.xxxx)) + (textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3(_20489.xy, _20322), 0.0) * _22023.y);
	                        break;
	                    } while(false);
	                    _7934 = _12501;
	                }
	                else
	                {
	                    _7934 = 1.0;
	                }
	                _12502 = mix(_7934, _23727, _13136);
	            }
	            else
	            {
	                _12502 = _23727;
	            }
	            _19363 = _12502;
	        }
	        else
	        {
	            _19363 = 1.0;
	        }
	        float _13279 = mix(_19363, 1.0, clamp((distance(_7639.xyz, PerViewConstantBuffer_t._m6) * PerViewLightingConstantBufferGpu_t._m24) + PerViewLightingConstantBufferGpu_t._m23, 0.0, 1.0));
	        float _12503;
	        if (_24465.y)
	        {
	            _12503 = min(_13279, textureLod(sampler2D(g_tParticleShadowBuffer, g_sTrilinearClamp), (_11408.xy * PerViewConstantBuffer_t._m3.xy).xy, 0.0).z);
	        }
	        else
	        {
	            _12503 = _13279;
	        }
	        _21711 = _12503;
	    }
	    else
	    {
	        _21711 = 1.0;
	    }
	    vec3 _9716;
	    vec3 _24878;
	    if ((dot(PerViewLightingConstantBufferGpu_t._m16.xyz, _24735) * _21711) > 0.0)
	    {
	        float _11797 = max(0.0, dot(_14786.xyz, PerViewLightingConstantBufferGpu_t._m16.xyz));
	        vec2 _9840 = max(_11004, vec2(PerViewLightingConstantBufferGpu_t._m16.w));
	        vec3 _21889 = (-normalize(_7639.xyz - PerViewConstantBuffer_t._m6.xyz)).xyz;
	        vec3 _12281 = normalize(PerViewLightingConstantBufferGpu_t._m16.xyz + _21889).xyz;
	        vec3 _19012 = mix(_17892, _24735, bvec3(all(equal(_17892, vec3(1.0))))).xyz;
	        float _12386 = dot(_12281, _19012);
	        vec3 _22995 = _12351.xyz;
	        float _9850 = _9840.x;
	        float _25211 = _9850 * _9850;
	        float _24198 = _25211 / (((_12386 * _12386) * ((_25211 * _25211) - 1.0)) + 1.0);
	        float _16150 = _9850 + 1.0;
	        float _6835 = (_16150 * _16150) * 0.125;
	        float _19569 = 1.0 - _6835;
	        vec3 _16808 = (PerViewLightingConstantBufferGpu_t._m17.xyz * _21711).xyz;
	        _9716 = PerViewLightingConstantBufferGpu_t._m9.xyz + (vec3(_11797).xyz * _16808);
	        _24878 = (((_22995 + ((vec3(1.0) - _22995) * pow(max(9.9999999747524270787835121154785e-07, 1.0 - max(0.0, dot(PerViewLightingConstantBufferGpu_t._m16.xyz, _12281))), 5.0))) * ((_24198 * _24198) / ((4.0 * ((_11797 * _19569) + _6835)) * ((max(0.0, dot(_19012, _21889)) * _19569) + _6835)))).xyz * _11797).xyz * _16808;
	    }
	    else
	    {
	        _9716 = PerViewLightingConstantBufferGpu_t._m9.xyz;
	        _24878 = vec3(0.0);
	    }
	    bvec4 _24467 = notEqual(PerViewConstantBufferCsgo_t._m2, ivec4(0));
	    bool _20062 = _24467.x;
	    vec4 _19364;
	    if (_20062)
	    {
	        vec4 _24259 = vec4(_7639.xyz, 1.0).xyzw * mat4(vec4(PerViewConstantBufferCsgo_t._m5._m0[0].x, PerViewConstantBufferCsgo_t._m5._m0[1].x, PerViewConstantBufferCsgo_t._m5._m0[2].x, PerViewConstantBufferCsgo_t._m5._m0[3].x), vec4(PerViewConstantBufferCsgo_t._m5._m0[0].y, PerViewConstantBufferCsgo_t._m5._m0[1].y, PerViewConstantBufferCsgo_t._m5._m0[2].y, PerViewConstantBufferCsgo_t._m5._m0[3].y), vec4(PerViewConstantBufferCsgo_t._m5._m0[0].z, PerViewConstantBufferCsgo_t._m5._m0[1].z, PerViewConstantBufferCsgo_t._m5._m0[2].z, PerViewConstantBufferCsgo_t._m5._m0[3].z), vec4(PerViewConstantBufferCsgo_t._m5._m0[0].w, PerViewConstantBufferCsgo_t._m5._m0[1].w, PerViewConstantBufferCsgo_t._m5._m0[2].w, PerViewConstantBufferCsgo_t._m5._m0[3].w));
	        float _20176 = _24259.w;
	        vec2 _11414 = _24259.xy / vec2(_20176);
	        vec4 _6651;
	        _6651.x = clamp(((_11414.x + 1.0) * PerViewConstantBuffer_t._m2.x) * 0.5, 0.0, PerViewConstantBuffer_t._m2.x - 1.0);
	        _6651.y = clamp(((1.0 - _11414.y) * PerViewConstantBuffer_t._m2.y) * 0.5, 0.0, PerViewConstantBuffer_t._m2.y - 1.0);
	        _6651.w = _20176;
	        _19364 = _6651;
	    }
	    else
	    {
	        _19364 = _11408;
	    }
	    uvec2 _7663 = uvec2(PerViewLightingConstantBufferGpu_t._m12.x);
	    uvec2 _12083 = uvec2(_19364.xy - PerViewConstantBuffer_t._m1.xy) >> _7663;
	    uint _10838 = PerViewLightingConstantBufferGpu_t._m10.y + (((_12083.y * PerViewLightingConstantBufferGpu_t._m12.y) + _12083.x) * PerViewLightingConstantBufferGpu_t._m10.z);
	    uint _23393 = PerViewLightingConstantBufferGpu_t._m10.x + (uint(clamp(_19364.w * PerViewLightingConstantBufferGpu_t._m13.x, 0.0, PerViewLightingConstantBufferGpu_t._m13.y)) * PerViewLightingConstantBufferGpu_t._m10.z);
	    vec3 _13137;
	    vec3 _16324;
	    _13137 = _9716;
	    _16324 = _24878;
	    uint _21567;
	    vec3 _13138;
	    vec3 _16325;
	    uint _17017 = 0u;
	    for (;;)
	    {
	        if (!(_17017 < PerViewLightingConstantBufferGpu_t._m10.z))
	        {
	            break;
	        }
	        uint _14475 = subgroupOr(g_CullBits_1._m0[_10838 + _17017] & g_CullBits_1._m0[_23393 + _17017]);
	        _13138 = _16324;
	        _16325 = _13137;
	        uint _20344;
	        vec3 _13212;
	        vec3 _15670;
	        uint _17018 = _14475;
	        for (;;)
	        {
	            if (!(_17018 != 0u))
	            {
	                break;
	            }
	            int _12608 = int(uint(findLSB(_17018)) + (_17017 * 32u));
	            _20344 = _17018 & (_17018 - 1u);
	            do
	            {
	                vec4 _15817 = mat4(vec4(g_BarnLights_1._m0[_12608]._m0._m0[0].x, g_BarnLights_1._m0[_12608]._m0._m0[1].x, g_BarnLights_1._m0[_12608]._m0._m0[2].x, g_BarnLights_1._m0[_12608]._m0._m0[3].x), vec4(g_BarnLights_1._m0[_12608]._m0._m0[0].y, g_BarnLights_1._m0[_12608]._m0._m0[1].y, g_BarnLights_1._m0[_12608]._m0._m0[2].y, g_BarnLights_1._m0[_12608]._m0._m0[3].y), vec4(g_BarnLights_1._m0[_12608]._m0._m0[0].z, g_BarnLights_1._m0[_12608]._m0._m0[1].z, g_BarnLights_1._m0[_12608]._m0._m0[2].z, g_BarnLights_1._m0[_12608]._m0._m0[3].z), vec4(g_BarnLights_1._m0[_12608]._m0._m0[0].w, g_BarnLights_1._m0[_12608]._m0._m0[1].w, g_BarnLights_1._m0[_12608]._m0._m0[2].w, g_BarnLights_1._m0[_12608]._m0._m0[3].w)) * vec4(input_0.xyz, 1.0);
	                vec3 _10521 = _15817.xyz / vec3(_15817.w);
	                vec4 _22905;
	                _22905.x = _10521.x;
	                _22905.y = _10521.y;
	                float _21775 = _10521.z;
	                _22905.z = _21775;
	                vec3 _21642 = _22905.xyz;
	                bool _7425;
	                if (all(greaterThan(_22905.xyz, vec3(-1.0, -1.0, 0.0))))
	                {
	                    _7425 = all(lessThan(_22905.xyz, vec3(1.0)));
	                }
	                else
	                {
	                    _7425 = false;
	                }
	                bool _12889;
	                if (!_7425)
	                {
	                    _12889 = true;
	                }
	                else
	                {
	                    _12889 = !all(lessThanEqual(abs((mat4x3(vec3(g_BarnLights_1._m0[_12608]._m15._m0[0].x, g_BarnLights_1._m0[_12608]._m15._m0[1].x, g_BarnLights_1._m0[_12608]._m15._m0[2].x), vec3(g_BarnLights_1._m0[_12608]._m15._m0[0].y, g_BarnLights_1._m0[_12608]._m15._m0[1].y, g_BarnLights_1._m0[_12608]._m15._m0[2].y), vec3(g_BarnLights_1._m0[_12608]._m15._m0[0].z, g_BarnLights_1._m0[_12608]._m15._m0[1].z, g_BarnLights_1._m0[_12608]._m15._m0[2].z), vec3(g_BarnLights_1._m0[_12608]._m15._m0[0].w, g_BarnLights_1._m0[_12608]._m15._m0[1].w, g_BarnLights_1._m0[_12608]._m15._m0[2].w)) * vec4(input_0.xyz, 1.0)).xyz), vec3(1.0)));
	                }
	                if (_12889)
	                {
	                    _13212 = _13138;
	                    _15670 = _16325;
	                    break;
	                }
	                float _23571 = 2.0 * g_BarnLights_1._m0[_12608]._m5.y;
	                float _18492 = (2.0 * g_BarnLights_1._m0[_12608]._m5.z) * g_BarnLights_1._m0[_12608]._m5.z;
	                float _14805 = 2.0 * g_BarnLights_1._m0[_12608]._m5.x;
	                float _9058 = _14805 * g_BarnLights_1._m0[_12608]._m5.y;
	                float _17330 = 2.0 * g_BarnLights_1._m0[_12608]._m5.w;
	                float _19825 = _17330 * g_BarnLights_1._m0[_12608]._m5.z;
	                vec3 _16268 = vec3(_9058 - _19825, (1.0 - (_14805 * g_BarnLights_1._m0[_12608]._m5.x)) - _18492, (_23571 * g_BarnLights_1._m0[_12608]._m5.z) + (_17330 * g_BarnLights_1._m0[_12608]._m5.x)) * g_BarnLights_1._m0[_12608]._m6.z;
	                float _21316;
	                if (g_BarnLights_1._m0[_12608]._m3.z > 0.0)
	                {
	                    _21316 = smoothstep(0.0, 1.0, _21775 * g_BarnLights_1._m0[_12608]._m3.z);
	                }
	                else
	                {
	                    _21316 = 1.0;
	                }
	                float _19667;
	                if (g_BarnLights_1._m0[_12608]._m3.w > 0.0)
	                {
	                    _19667 = _21316 * smoothstep(0.0, 1.0, (1.0 - _21775) * g_BarnLights_1._m0[_12608]._m3.w);
	                }
	                else
	                {
	                    _19667 = _21316;
	                }
	                vec3 _11179;
	                float _11633;
	                if (g_BarnLights_1._m0[_12608]._m2.w != 0.0)
	                {
	                    vec3 _10017 = g_BarnLights_1._m0[_12608]._m2.xyz - input_0.xyz;
	                    float _18345 = dot(_10017, _10017);
	                    float _17647 = sqrt(_18345);
	                    vec3 _20958 = _10017 - _16268;
	                    vec3 _10210;
	                    do
	                    {
	                        vec3 _20229 = (_10017 + _16268) - _20958;
	                        float _25105 = dot(-_20958, _20229);
	                        if (_25105 <= 0.0)
	                        {
	                            _10210 = _20958;
	                            break;
	                        }
	                        else
	                        {
	                            _10210 = _20958 + (_20229 * min(1.0, _25105 / dot(_20229, _20229)));
	                            break;
	                        }
	                        break; // unreachable workaround
	                    } while(false);
	                    _11179 = _10017 / vec3(_17647);
	                    _11633 = ((_19667 * (g_BarnLights_1._m0[_12608]._m2.w / max(_18345, g_BarnLights_1._m0[_12608]._m2.w))) * smoothstep(0.0, 1.0, g_BarnLights_1._m0[_12608]._m3.x + (g_BarnLights_1._m0[_12608]._m3.y * _17647))) * clamp(g_BarnLights_1._m0[_12608]._m6.x + (g_BarnLights_1._m0[_12608]._m6.y * dot(vec3((1.0 - (_23571 * g_BarnLights_1._m0[_12608]._m5.y)) - _18492, _9058 + _19825, (_14805 * g_BarnLights_1._m0[_12608]._m5.z) - (_17330 * g_BarnLights_1._m0[_12608]._m5.y)), normalize(_10210))), 0.0, 1.0);
	                }
	                else
	                {
	                    _11179 = g_BarnLights_1._m0[_12608]._m2.xyz;
	                    _11633 = _19667;
	                }
	                vec3 _17828 = (g_BarnLights_1._m0[_12608]._m4.xyz * 1.0).xyz * _11633;
	                bool _24419;
	                if (g_BarnLights_1._m0[_12608]._m8.z > 0.0)
	                {
	                    _24419 = !_20062;
	                }
	                else
	                {
	                    _24419 = false;
	                }
	                vec3 _21548;
	                if (g_BarnLights_1._m0[_12608]._m4.w == 0.0)
	                {
	                    float _10342;
	                    do
	                    {
	                        vec2 _22154 = abs(_22905.xy);
	                        if (g_BarnLights_1._m0[_12608]._m9.z == 0.0)
	                        {
	                            _10342 = smoothstep(1.0, g_BarnLights_1._m0[_12608]._m9.x, _22154.x) * smoothstep(1.0, g_BarnLights_1._m0[_12608]._m9.y, _22154.y);
	                            break;
	                        }
	                        else
	                        {
	                            float _11473 = _22154.x;
	                            float _15266 = 2.0 / g_BarnLights_1._m0[_12608]._m9.z;
	                            float _15017 = _22154.y;
	                            float _23041 = (-0.5) * g_BarnLights_1._m0[_12608]._m9.z;
	                            float _11981 = (g_BarnLights_1._m0[_12608]._m9.x * g_BarnLights_1._m0[_12608]._m9.y) * pow(max(pow(g_BarnLights_1._m0[_12608]._m9.y * _11473, _15266) + pow(g_BarnLights_1._m0[_12608]._m9.x * _15017, _15266), 1.1754943508222875079687365372222e-38), _23041);
	                            float _16524 = pow(max(pow(_11473, _15266) + pow(_15017, _15266), 1.1754943508222875079687365372222e-38), _23041);
	                            if (_11981 < _16524)
	                            {
	                                _10342 = smoothstep(_16524, _11981, 1.0);
	                                break;
	                            }
	                            else
	                            {
	                                _10342 = float(_16524 > 1.0);
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
	                    vec3 _12504;
	                    if (g_BarnLights_1._m0[_12608]._m4.w < 0.0)
	                    {
	                        vec4 _17795 = vec4(-g_BarnLights_1._m0[_12608]._m5.xyz, g_BarnLights_1._m0[_12608]._m5.w);
	                        vec4 _19008 = _17795.xyzw * vec4(-1.0, -1.0, -1.0, 1.0);
	                        vec3 _24989 = _19008.xyz;
	                        vec3 _23629 = vec4((-_11179).xyz, 0.0).xyz;
	                        float _15156 = -dot(_23629, _24989);
	                        vec3 _20479 = vec4((_23629 * _19008.w) + cross(_23629, _24989), _15156).xyz;
	                        vec3 _23593 = _17795.xyz;
	                        vec3 _12170 = ((_20479 * g_BarnLights_1._m0[_12608]._m5.w) + (_23593 * _15156)) + cross(_23593, _20479);
	                        vec3 _14081 = vec3(vec2(atan(_12170.y, -_12170.x) * 0.15915493667125701904296875, acos(_12170.z) * 0.3183098733425140380859375), -g_BarnLights_1._m0[_12608]._m4.w);
	                        vec2 _20564 = (_14081.xy * g_BarnLights_1._m0[_12608]._m9.zw) + g_BarnLights_1._m0[_12608]._m9.xy;
	                        vec3 _20491 = _14081;
	                        _20491.x = _20564.x;
	                        _20491.y = _20564.y;
	                        _12504 = _17828.xyz * textureLod(sampler3D(g_tLightCookieTexture, g_sTrilinearWrap), _20491.xyz, 0.0).xyz;
	                    }
	                    else
	                    {
	                        vec3 _13791 = vec3(fma(_22905.xy, vec2(0.5, -0.5), vec2(0.5)), g_BarnLights_1._m0[_12608]._m4.w);
	                        vec2 _20563 = (_13791.xy * g_BarnLights_1._m0[_12608]._m9.zw) + g_BarnLights_1._m0[_12608]._m9.xy;
	                        vec3 _20490 = _13791;
	                        _20490.x = _20563.x;
	                        _20490.y = _20563.y;
	                        _12504 = _17828.xyz * textureLod(sampler3D(g_tLightCookieTexture, g_sCookieSampler), _20490.xyz, 0.0).xyz;
	                    }
	                    _21548 = _12504;
	                }
	                if (all(equal(_21548.xyz, vec3(0.0))))
	                {
	                    _13212 = _13138;
	                    _15670 = _16325;
	                    break;
	                }
	                vec3 _22671;
	                if (_24419)
	                {
	                    vec3 _19629;
	                    if ((g_BarnLights_1._m0[_12608]._m13 & 4u) != 0u)
	                    {
	                        vec2 _6281 = _22905.yx * vec2(1.0, -1.0);
	                        vec3 _23715 = _21642;
	                        _23715.x = _6281.x;
	                        _23715.y = _6281.y;
	                        _19629 = _23715;
	                    }
	                    else
	                    {
	                        _19629 = _21642;
	                    }
	                    float _24972;
	                    do
	                    {
	                        float _11455 = saturate(_19629.z + PerViewLightingConstantBufferGpu_t._m19);
	                        vec2 _14616 = vec3(fma(_19629.xy, g_BarnLights_1._m0[_12608]._m8.zw, g_BarnLights_1._m0[_12608]._m8.xy), _19629.z).xy;
	                        float _15312 = dot(vec4(textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_14616 + vec2(PerViewLightingConstantBufferGpu_t._m2.z, PerViewLightingConstantBufferGpu_t._m3.z)).xy, _11455), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_14616 + vec2(PerViewLightingConstantBufferGpu_t._m2.y, PerViewLightingConstantBufferGpu_t._m3.z)).xy, _11455), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_14616 + vec2(PerViewLightingConstantBufferGpu_t._m2.z, PerViewLightingConstantBufferGpu_t._m3.y)).xy, _11455), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_14616 + vec2(PerViewLightingConstantBufferGpu_t._m2.y, PerViewLightingConstantBufferGpu_t._m3.y)).xy, _11455), 0.0)).xyzw, vec4(0.25));
	                        bool _12890;
	                        if (_15312 == 0.0)
	                        {
	                            _12890 = true;
	                        }
	                        else
	                        {
	                            _12890 = _15312 == 1.0;
	                        }
	                        if (_12890)
	                        {
	                            _24972 = _15312;
	                            break;
	                        }
	                        _24972 = ((_15312 * (PerViewLightingConstantBufferGpu_t._m0.w * 4.0)) + dot(vec4(textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_14616 + vec2(PerViewLightingConstantBufferGpu_t._m2.z, 0.0)).xy, _11455), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_14616 + vec2(PerViewLightingConstantBufferGpu_t._m2.y, 0.0)).xy, _11455), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_14616 + vec2(0.0, PerViewLightingConstantBufferGpu_t._m3.y)).xy, _11455), 0.0), textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3((_14616 + vec2(0.0, PerViewLightingConstantBufferGpu_t._m3.z)).xy, _11455), 0.0)).xyzw, PerViewLightingConstantBufferGpu_t._m1.xxxx)) + (textureLod(sampler2DShadow(g_tShadowDepthBufferDepth, g_tShadowDepthBufferCmpSampler), vec3(_14616, _11455), 0.0) * PerViewLightingConstantBufferGpu_t._m1.y);
	                        break;
	                    } while(false);
	                    vec3 _19878 = _21548.xyz * mix(1.0, _24972, g_BarnLights_1._m0[_12608]._m12);
	                    if (all(equal(_19878.xyz, vec3(0.0))))
	                    {
	                        _13212 = _13138;
	                        _15670 = _16325;
	                        break;
	                    }
	                    _22671 = _19878;
	                }
	                else
	                {
	                    _22671 = _21548;
	                }
	                float _11798 = max(0.0, dot(_14786.xyz, _11179.xyz));
	                vec2 _9841 = max(_11004, vec2(g_BarnLights_1._m0[_12608]._m11));
	                vec3 _21890 = (-normalize(_7639.xyz - PerViewConstantBuffer_t._m6.xyz)).xyz;
	                vec3 _12282 = normalize(_11179.xyz + _21890).xyz;
	                vec3 _19014 = mix(_17892, _24735, bvec3(all(equal(_17892, vec3(1.0))))).xyz;
	                float _12387 = dot(_12282, _19014);
	                vec3 _22996 = _12351.xyz;
	                float _9851 = _9841.x;
	                float _25212 = _9851 * _9851;
	                float _24199 = _25212 / (((_12387 * _12387) * ((_25212 * _25212) - 1.0)) + 1.0);
	                float _16151 = _9851 + 1.0;
	                float _6836 = (_16151 * _16151) * 0.125;
	                float _19571 = 1.0 - _6836;
	                _13212 = _13138.xyz + ((((_22996 + ((vec3(1.0) - _22996) * pow(max(9.9999999747524270787835121154785e-07, 1.0 - max(0.0, dot(_11179.xyz, _12282))), 5.0))) * ((_24199 * _24199) / ((4.0 * ((_11798 * _19571) + _6836)) * ((max(0.0, dot(_19014, _21890)) * _19571) + _6836)))).xyz * _11798).xyz * _22671.xyz);
	                _15670 = _16325.xyz + (vec3(_11798).xyz * _22671.xyz);
	                break;
	            } while(false);
	            _13138 = _13212;
	            _16325 = _15670;
	            _17018 = _20344;
	            continue;
	        }
	        _21567 = _17017 + 1u;
	        _13137 = _16325;
	        _16324 = _13138;
	        _17017 = _21567;
	        continue;
	    }
	    vec3 _10145 = normalize(_7639.xyz - PerViewConstantBuffer_t._m6.xyz);
	    vec3 _19257 = -_10145;
	    float _19582 = (_11004.x + _11004.y) * 0.5;
	    float _6489 = _19582 * _19582;
	    float _17751 = dot(_11004.xy, vec2(0.5));
	    vec3 _6519 = _17892.xyz;
	    vec3 _19081 = _17892.xyz;
	    float _12853 = PerViewLightingConstantBufferGpu_t._m14.y * sqrt(_17751);
	    vec3 _11901 = _7639.xyz;
	    vec3 _11008;
	    vec4 _14444;
	    if (PerViewConstantBufferCsgo_t._m19 != 0.0)
	    {
	        float _9642 = dot(vec4(((_11901 + PerViewConstantBuffer_t._m5.xyz) + ((-PerViewConstantBuffer_t._m7) * PerViewConstantBufferCsgo_t._m19)).xyz, 1.0), vec4(PerViewConstantBuffer_t._m7.xyz, dot((PerViewConstantBuffer_t._m5.xyz + PerViewConstantBuffer_t._m6.xyz).xyz + (PerViewConstantBuffer_t._m7.xyz * PerViewConstantBuffer_t._m4), PerViewConstantBuffer_t._m7.xyz)));
	        vec3 _21712;
	        if (_9642 <= 0.0)
	        {
	            _21712 = _7639;
	        }
	        else
	        {
	            _21712 = _11901 + ((-PerViewConstantBuffer_t._m7.xyz) * _9642);
	        }
	        vec4 _19975 = vec4(_21712.xyz, 1.0) * mat4(vec4(PerViewConstantBufferCsgo_t._m5._m0[0].x, PerViewConstantBufferCsgo_t._m5._m0[1].x, PerViewConstantBufferCsgo_t._m5._m0[2].x, PerViewConstantBufferCsgo_t._m5._m0[3].x), vec4(PerViewConstantBufferCsgo_t._m5._m0[0].y, PerViewConstantBufferCsgo_t._m5._m0[1].y, PerViewConstantBufferCsgo_t._m5._m0[2].y, PerViewConstantBufferCsgo_t._m5._m0[3].y), vec4(PerViewConstantBufferCsgo_t._m5._m0[0].z, PerViewConstantBufferCsgo_t._m5._m0[1].z, PerViewConstantBufferCsgo_t._m5._m0[2].z, PerViewConstantBufferCsgo_t._m5._m0[3].z), vec4(PerViewConstantBufferCsgo_t._m5._m0[0].w, PerViewConstantBufferCsgo_t._m5._m0[1].w, PerViewConstantBufferCsgo_t._m5._m0[2].w, PerViewConstantBufferCsgo_t._m5._m0[3].w));
	        float _20177 = _19975.w;
	        vec2 _11415 = _19975.xy / vec2(_20177);
	        vec4 _6652;
	        _6652.x = clamp(((_11415.x + 1.0) * PerViewConstantBuffer_t._m2.x) * 0.5, 0.0, PerViewConstantBuffer_t._m2.x - 1.0);
	        _6652.y = clamp(((1.0 - _11415.y) * PerViewConstantBuffer_t._m2.y) * 0.5, 0.0, PerViewConstantBuffer_t._m2.y - 1.0);
	        _6652.w = _20177;
	        _11008 = _21712;
	        _14444 = _6652;
	    }
	    else
	    {
	        _11008 = _11901;
	        _14444 = _11408.xyzw;
	    }
	    float _22046 = _17751 * _17751;
	    float _20711 = saturate(1.0 - _22046);
	    vec3 _25271 = normalize(mix(_6519, reflect(_10145.xyz, _19081).xyz, vec3(_20711 * (sqrt(_20711) + _22046))));
	    uvec2 _6814 = uvec2(_14444.xy - PerViewConstantBuffer_t._m1.xy) >> _7663;
	    uint _12130 = PerViewLightingConstantBufferGpu_t._m11.y + (((_6814.y * PerViewLightingConstantBufferGpu_t._m12.y) + _6814.x) * PerViewLightingConstantBufferGpu_t._m11.z);
	    uint _23394 = PerViewLightingConstantBufferGpu_t._m11.x + (uint(clamp(_14444.w * PerViewLightingConstantBufferGpu_t._m13.x, 0.0, PerViewLightingConstantBufferGpu_t._m13.y)) * PerViewLightingConstantBufferGpu_t._m11.z);
	    vec4 _13139;
	    float _16305;
	    vec3 _17114;
	    _13139 = vec4(0.0);
	    _16305 = 0.00999999977648258209228515625;
	    _17114 = vec3(0.0);
	    uint _8896;
	    vec4 _13142;
	    vec3 _14891;
	    float _16307;
	    bool _18379;
	    uint _17020 = 0u;
	    bool _17133 = false;
	    for (;;)
	    {
	        bool _12891;
	        if (_17020 < PerViewLightingConstantBufferGpu_t._m11.z)
	        {
	            _12891 = !_17133;
	        }
	        else
	        {
	            _12891 = false;
	        }
	        if (!_12891)
	        {
	            break;
	        }
	        uint _14476 = subgroupOr(g_CullBits_1._m0[_12130 + _17020] & g_CullBits_1._m0[_23394 + _17020]);
	        vec3 _13140;
	        vec4 _16306;
	        _13140 = _17114;
	        _16306 = _13139;
	        uint _10156;
	        vec3 _13141;
	        vec4 _16381;
	        float _16479;
	        uint _17021 = _14476;
	        float _17134 = _16305;
	        for (;;)
	        {
	            bool _7956_ladder_break = false;
	            do
	            {
	                if (!(_17021 != 0u))
	                {
	                    _13142 = _16306;
	                    _16307 = _17134;
	                    _14891 = _13140;
	                    _18379 = _17133;
	                    _7956_ladder_break = true;
	                    break;
	                }
	                int _12609 = int(uint(findLSB(_17021)) + (_17020 * 32u));
	                _10156 = _17021 & (_17021 - 1u);
	                mat4x3 _16416 = mat4x3(vec3(PerViewLightingConstantBufferGpu_t._m15._m0[_12609]._m0._m0[0].x, PerViewLightingConstantBufferGpu_t._m15._m0[_12609]._m0._m0[1].x, PerViewLightingConstantBufferGpu_t._m15._m0[_12609]._m0._m0[2].x), vec3(PerViewLightingConstantBufferGpu_t._m15._m0[_12609]._m0._m0[0].y, PerViewLightingConstantBufferGpu_t._m15._m0[_12609]._m0._m0[1].y, PerViewLightingConstantBufferGpu_t._m15._m0[_12609]._m0._m0[2].y), vec3(PerViewLightingConstantBufferGpu_t._m15._m0[_12609]._m0._m0[0].z, PerViewLightingConstantBufferGpu_t._m15._m0[_12609]._m0._m0[1].z, PerViewLightingConstantBufferGpu_t._m15._m0[_12609]._m0._m0[2].z), vec3(PerViewLightingConstantBufferGpu_t._m15._m0[_12609]._m0._m0[0].w, PerViewLightingConstantBufferGpu_t._m15._m0[_12609]._m0._m0[1].w, PerViewLightingConstantBufferGpu_t._m15._m0[_12609]._m0._m0[2].w));
	                vec3 _21376 = (_16416 * vec4(_11008.xyz, 1.0)).xyz;
	                vec3 _8793 = clamp((_21376 - PerViewLightingConstantBufferGpu_t._m15._m0[_12609]._m1) * PerViewLightingConstantBufferGpu_t._m15._m0[_12609]._m4.xyz, vec3(0.0), vec3(1.0));
	                vec3 _19651 = clamp((PerViewLightingConstantBufferGpu_t._m15._m0[_12609]._m3 - _21376) * PerViewLightingConstantBufferGpu_t._m15._m0[_12609]._m4.xyz, vec3(0.0), vec3(1.0));
	                float _17265 = min(min(_8793.x, min(_8793.y, _8793.z)), min(_19651.x, min(_19651.y, _19651.z)));
	                if (_17265 == 0.0)
	                {
	                    _13141 = _13140;
	                    _16381 = _16306;
	                    _16479 = _17134;
	                    break;
	                }
	                vec3 _19630;
	                if (PerViewConstantBufferCsgo_t._m18 != 0.0)
	                {
	                    vec3 _19779 = PerViewLightingConstantBufferGpu_t._m15._m0[_12609]._m1 + ((PerViewLightingConstantBufferGpu_t._m15._m0[_12609]._m3 - PerViewLightingConstantBufferGpu_t._m15._m0[_12609]._m1) * 0.5);
	                    _19630 = ((_21376 - _19779) * PerViewConstantBufferCsgo_t._m18) + _19779;
	                }
	                else
	                {
	                    _19630 = _21376;
	                }
	                vec3 _7648 = (_16416 * vec4(_25271.xyz, 0.0)).xyz;
	                vec3 _11253 = max(((PerViewLightingConstantBufferGpu_t._m15._m0[_12609]._m3.xyz - _19630.xyz) / _7648).xyz, ((PerViewLightingConstantBufferGpu_t._m15._m0[_12609]._m1.xyz - _19630.xyz) / _7648).xyz);
	                float _11076 = ((_17265 * _17265) * (((-2.0) * _17265) + 3.0)) * (1.0 - _17134);
	                float _13713 = _17134 + _11076;
	                vec3 _22473 = _13140 + ((textureLod(samplerCubeArray(g_tEnvironmentMap, g_sTrilinearWrap), vec4(mix(_19630.xyz + (_7648 * abs(min(_11253.x, min(_11253.y, _11253.z)))), _7648, vec3(_17751)).xyz, float(PerViewLightingConstantBufferGpu_t._m15._m0[_12609]._m2)), _12853).xyz * PerViewLightingConstantBufferGpu_t._m15._m0[_12609]._m5) * _11076);
	                vec4 _17103 = _16306 + (PerViewLightingConstantBufferGpu_t._m15._m0[_12609]._m6 * _11076);
	                if (_13713 > 0.9900000095367431640625)
	                {
	                    _13142 = _17103;
	                    _16307 = _13713;
	                    _14891 = _22473;
	                    _18379 = true;
	                    _7956_ladder_break = true;
	                    break;
	                }
	                _13141 = _22473;
	                _16381 = _17103;
	                _16479 = _13713;
	                break;
	            } while(false);
	            if (_7956_ladder_break)
	            {
	                break;
	            }
	            _13140 = _13141;
	            _16306 = _16381;
	            _17134 = _16479;
	            _17021 = _10156;
	            continue;
	        }
	        _8896 = _17020 + 1u;
	        _13139 = _13142;
	        _16305 = _16307;
	        _17114 = _14891;
	        _17133 = _18379;
	        _17020 = _8896;
	        continue;
	    }
	    vec4 _11487 = textureLod(sampler2DArray(g_tBRDFLookup_unexpectedTypeId470_1107, g_sBilinearClamp), vec3((vec2(_17751, sqrt(1.0 - max(0.0, dot(_19257.xyz, _6519)))) * 0.984375) + vec2(0.0078125), 1.0).xyz, 0.0);
	    vec3 _7300 = mix(_11487.xxx, _11487.yyy, _12351);
	    float _21809 = 1.0 - _11487.y;
	    vec3 _15517 = _12351 + ((vec3(1.0) - _12351) * vec3(0.0476190485060214996337890625));
	    vec3 _23208 = ((_7300 * _15517) / (vec3(1.0) - (_15517 * _21809))) * _21809;
	    vec3 _13438 = vec3(_18168 * _21785).xyz;
	    vec3 _22686 = ((_13137.xyz * vec3(_21785)).xyz + ((_18708 * (vec3(1.0) - (_7300 + _23208))).xyz * vec3(_21785 * _18168).xyz).xyz) * (_12739 * pow(1.0 - _20060, _Globals_.g_flMetalnessTransitionBias)).xyz;
	    float _12931 = _22686.x;
	    vec4 _11203 = vec4(_12931, _22686.yz, input_3.w);
	    _11203.x = _12931;
	    _11203.y = _22686.y;
	    _11203.z = _22686.z;
	    vec3 _15752 = _11203.xyz + ((_16324 * (vec3(1.0) + (_12351 * (((2.0 * _6489) * _6489) * clamp(dot(_17892, _19257), 0.0, 1.0))))).xyz * _13438).xyz;
	    vec4 _20492 = _11203;
	    _20492.x = _15752.x;
	    _20492.y = _15752.y;
	    _20492.z = _15752.z;
	    vec3 _15733 = _20492.xyz + ((((_17114 / vec3(_16305)).xyz * min(dot(_18708.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125)) / dot(vec4(_19081, 1.0), (_13139 / vec4(_16305)).xyzw), max((_17751 * PerViewLightingConstantBufferGpu_t._m4.x) + PerViewLightingConstantBufferGpu_t._m4.y, 1.0))).xyz * (_7300 + _23208)).xyz * _13438).xyz;
	    vec4 _13888 = _20492;
	    _13888.x = _15733.x;
	    _13888.y = _15733.y;
	    _13888.z = _15733.z;
	    vec4 _19366;
	    if (_Globals_.g_bFogEnabled != 0)
	    {
	        vec3 _21493;
	        vec3 _6538 = _11901 - PerViewConstantBuffer_t._m6.xyz;
	        vec3 _9057 = _6538.xyz;
	        vec3 _19340;
	        do
	        {
	            _21493 = _6538.xyz;
	            bool _12892;
	            if (dot(_21493, _21493) > PerViewConstantBufferCsgo_t._m11.x)
	            {
	                _12892 = (_7639.z * PerViewConstantBufferCsgo_t._m11.z) < PerViewConstantBufferCsgo_t._m11.y;
	            }
	            else
	            {
	                _12892 = false;
	            }
	            if (_12892)
	            {
	                vec2 _9342 = clamp(PerViewConstantBufferCsgo_t._m8.xy + (PerViewConstantBufferCsgo_t._m8.zw * vec2(length(_21493), _7639.z)), vec2(0.0), vec2(1.0));
	                float _12872 = (pow(_9342.x, PerViewConstantBufferCsgo_t._m9.x) * pow(_9342.y, PerViewConstantBufferCsgo_t._m9.y)) * PerViewConstantBufferCsgo_t._m10.w;
	                _19340 = mix(_13888.xyz, vec4(PerViewConstantBufferCsgo_t._m10.xyz, _12872).xyz, vec3(_12872));
	                break;
	            }
	            _19340 = _13888.xyz;
	            break;
	        } while(false);
	        vec4 _23944 = _13888;
	        _23944.x = _19340.x;
	        _23944.y = _19340.y;
	        _23944.z = _19340.z;
	        vec3 _19341;
	        do
	        {
	            bool _12893;
	            if (dot(_9057, _9057) > PerViewConstantBufferCsgo_t._m15.x)
	            {
	                _12893 = (PerViewConstantBufferCsgo_t._m15.z * _7639.z) < PerViewConstantBufferCsgo_t._m15.y;
	            }
	            else
	            {
	                _12893 = false;
	            }
	            if (_12893)
	            {
	                float _14602 = clamp(pow(max(0.0, (length(_21493) * PerViewConstantBufferCsgo_t._m12.y) + PerViewConstantBufferCsgo_t._m12.x), PerViewConstantBufferCsgo_t._m12.w), 0.0, 1.0) * clamp(pow(max(0.0, (_7639.z * PerViewConstantBufferCsgo_t._m13.y) + PerViewConstantBufferCsgo_t._m13.x), PerViewConstantBufferCsgo_t._m13.z), 0.0, 1.0);
	                float _8892 = saturate(_14602) * PerViewConstantBufferCsgo_t._m15.w;
	                _19341 = mix(_23944.xyz, vec4((textureLod(samplerCube(g_tFogCubeTexture, g_sTrilinearClamp), normalize((mat4(vec4(PerViewConstantBufferCsgo_t._m14._m0[0].x, PerViewConstantBufferCsgo_t._m14._m0[1].x, PerViewConstantBufferCsgo_t._m14._m0[2].x, PerViewConstantBufferCsgo_t._m14._m0[3].x), vec4(PerViewConstantBufferCsgo_t._m14._m0[0].y, PerViewConstantBufferCsgo_t._m14._m0[1].y, PerViewConstantBufferCsgo_t._m14._m0[2].y, PerViewConstantBufferCsgo_t._m14._m0[3].y), vec4(PerViewConstantBufferCsgo_t._m14._m0[0].z, PerViewConstantBufferCsgo_t._m14._m0[1].z, PerViewConstantBufferCsgo_t._m14._m0[2].z, PerViewConstantBufferCsgo_t._m14._m0[3].z), vec4(PerViewConstantBufferCsgo_t._m14._m0[0].w, PerViewConstantBufferCsgo_t._m14._m0[1].w, PerViewConstantBufferCsgo_t._m14._m0[2].w, PerViewConstantBufferCsgo_t._m14._m0[3].w)) * vec4(_9057, 0.0)).xyz).xyz, PerViewConstantBufferCsgo_t._m13.w * clamp(1.0 - (_14602 * PerViewConstantBufferCsgo_t._m12.z), 0.0, 1.0)) * PerViewConstantBufferCsgo_t._m16.x).xyz, _8892).xyz, vec3(_8892));
	                break;
	            }
	            _19341 = _23944.xyz;
	            break;
	        } while(false);
	        _23944.x = _19341.x;
	        _23944.y = _19341.y;
	        _23944.z = _19341.z;
	        _19366 = _23944;
	    }
	    else
	    {
	        _19366 = _13888;
	    }
	    vec3 _19342;
	    if (_Globals_.g_flSpawnInvulnerability > 0.0)
	    {
	        float _9657 = 1.0 - clamp(dot(_19257, _24735), 0.0, 1.0);
	        _19342 = mix(_19366.xyz, _Globals_.g_cInvulnerabilityColor * (mix(dot(_19366.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125)), 0.5, 0.5) + (4.0 * pow(mix(_9657 * texelFetch(g_tBlueNoise, ivec3(ivec2(_11408.xy) & PerViewConstantBufferCsgo_t._m4, 0).xy, 0).y, 1.0, _9657), mix(3.0, 6.0, 1.0 + (sin(PerViewConstantBuffer_t._m0 * 20.0) * 0.5))))), vec3(_Globals_.g_flSpawnInvulnerability));
	    }
	    else
	    {
	        _19342 = _19366.xyz;
	    }
	    vec4 _23946 = _19366;
	    _23946.x = _19342.x;
	    _23946.y = _19342.y;
	    _23946.z = _19342.z;
	    output_0 = _23946;
	}
	
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
	
	BoolAttribute(environmentmapped, true);
	BoolAttribute(environmentmappeddynamic, true);
	BoolAttribute(NeedsLightProbe, true);
	BoolAttribute(DoNotCastShadows, F_DO_NOT_CAST_SHADOWS || 0);
	BoolAttribute(SupportsMappingDimensions, true);
	BoolAttribute(renderbackfaces, F_RENDER_BACKFACES || 0);
	BoolAttribute(SupportsLightmapping, false);
	BoolAttribute(PerVertexLighting, true);
	StringAttribute(MaterialLayerType, csgo_weapon);
	
	#if (S_ALPHA_TEST == 1)
		BoolAttribute(alphatest, true);
		FloatAttribute(_dummyReferenceAlphaTestReferenceInMainShader, g_flAlphaTestReference);
		FloatAttribute(_dummyReferenceAntiAliasedEdgeStrengthReferenceInMainShader, g_flAntiAliasedEdgeStrength);
		BoolAttribute(NoZPrepass, true);
		TextureAttribute(LightSim_Opacity_A, g_tColor);
	#endif
	#if (S_ALPHA_TEST == 0)
		BoolAttribute(NoZPrepass, F_DISABLE_Z_PREPASS || 0);
	#endif
	#if (S_TRANSLUCENT == 0)
		TextureAttribute(LightSim_SelfIllumMaskTexture, g_tSelfIllumMask);
		Float3Attribute(LightSim_SelfIllumTint, g_vSelfIllumTint);
		FloatAttribute(LightSim_SelfIllumScale, g_flSelfIllumScale);
	#endif
	#if (S_ADDITIVE_BLEND == 0)
		TextureAttribute(LightSim_SelfIllumMaskTexture, g_tSelfIllumMask);
		Float3Attribute(LightSim_SelfIllumTint, g_vSelfIllumTint);
		FloatAttribute(LightSim_SelfIllumScale, g_flSelfIllumScale);
	#endif
	#if (S_SELF_ILLUM == 1)
		TextureAttribute(LightSim_SelfIllumMaskTexture, g_tSelfIllumMask);
		Float3Attribute(LightSim_SelfIllumTint, g_vSelfIllumTint);
		FloatAttribute(LightSim_SelfIllumScale, g_flSelfIllumScale);
	#endif
	#if (S_TRANSLUCENT == 1)
		BoolAttribute(translucent, true);
		BoolAttribute(NoZPrepass, F_DISABLE_Z_PREPASS || 0);
		TextureAttribute(LightSim_Opacity_A, g_tColor);
	#endif
	#if (S_ADDITIVE_BLEND == 1)
		BoolAttribute(translucent, true);
		BoolAttribute(NoZPrepass, F_DISABLE_Z_PREPASS || 0);
		TextureAttribute(LightSim_Opacity_A, g_tColor);
	#endif
	#if (S_SELF_ILLUM == 0)
		TextureAttribute(LightSim_Opacity_A, g_tColor);
	#endif
	
	// PSRS
	
	RenderState(BackStencilFunc, F_RENDER_BACKFACES ? 5 : 7);
	RenderState(BlendEnable, True);
	RenderState(CullMode, F_RENDER_BACKFACES ? None : Front);
	RenderState(CullMode, F_RENDER_BACKFACES ? None : Back);
	RenderState(DepthEnable, F_DISABLE_Z_BUFFERING ? False : True);
	RenderState(DepthWriteEnable, False);
	RenderState(DepthWriteEnable, F_DISABLE_Z_BUFFERING ? False : True);
	RenderState(DstBlend, F_ADDITIVE_BLEND ? One : InvSrcAlpha);
	RenderState(SlopeScaleDepthBias, 0);
	RenderState(StencilEnable, 1);
	RenderState(StencilFunc, 5);
	RenderState(StencilReadMask, 1);
	RenderState(StencilRef, 3);
	RenderState(StencilWriteMask, 254);
	
	#if (S_ALPHA_TEST == 0)
		RenderState(CullMode, F_RENDER_BACKFACES ? None : Front);
		RenderState(CullMode, F_RENDER_BACKFACES ? None : Back);
	#endif
	#if (S_TRANSLUCENT == 0)
		RenderState(CullMode, F_RENDER_BACKFACES ? None : Front);
		RenderState(CullMode, F_RENDER_BACKFACES ? None : Back);
	#endif
	#if (S_ALPHA_TEST == 1)
		RenderState(CullMode, F_RENDER_BACKFACES ? None : Front);
		RenderState(CullMode, F_RENDER_BACKFACES ? None : Back);
		RenderState(DepthWriteEnable, F_DISABLE_Z_BUFFERING ? False : True);
	#endif
	#if (S_TRANSLUCENT == 1)
		RenderState(CullMode, F_RENDER_BACKFACES ? None : Front);
		RenderState(CullMode, F_RENDER_BACKFACES ? None : Back);
		RenderState(DepthWriteEnable, False);
	#endif
}
