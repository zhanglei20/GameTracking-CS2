//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "Simple 2-way blending shader";
	DevShader = false;
	Version = 1;
	
	// VcsVersion: 71
	// Platform: VULKAN_SM_60
	// Programs: ps, psrs, rtx, vs
}

MODES
{
	CsgoForward();
	RayTrace();
	Depth("csgo_depth_only.vfx");
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
	Feature( F_ENABLE_TINT_MASKS, 0..1, "Enable Tint Masks" );
	Feature( F_ENABLE_AMBIENT_OCCLUSION, 0..1, "Enable Ambient Occlusion" );
	Feature( F_PAINT_VERTEX_COLORS, 0..1, "Vertex Color" );
	FeatureRule( Requires( F_DONT_FLIP_BACKFACE_NORMALS, F_RENDER_BACKFACES ), "Only applies to backfaces" );
}

COMMON
{
	#include "system.fxc"
}

struct VS_INPUT
{
	float4 vBlendIndices              : BLENDINDICES0  < Semantic( BlendIndices ); >;              // D_CS_VERTEX_ANIMATION=0, S_MODE_TOOLS_VIS=1
	float4 vBlendColorTint            : COLOR0         < Semantic( VertexPaintTintColor ); >;      // S_PAINT_VERTEX_COLORS=1
	float4 vPerVertexLighting         : COLOR1         < Semantic( PerVertexLighting ); >;         // D_BAKED_LIGHTING_FROM_VERTEX_STREAM=1
	uint4  nPackedFrame               : NORMAL0        < Semantic( CompressedTangentFrame ); >;   
	float4 vNormalOs                  : NORMAL0        < Semantic( Normal ); >;                   
	float3 vPositionOs                : POSITION0      < Semantic( PosXyz ); >;                    // D_CS_VERTEX_ANIMATION=0
	float2 vLightmapUV                : TEXCOORD3      < Semantic( LightmapUV ); >;                // D_BAKED_LIGHTING_FROM_LIGHTMAP=1
	float4 vTangentUOs_flTangentVSign : TANGENT0       < Semantic( TangentU_SignV ); >;           
	float2 vTexCoord                  : TEXCOORD0      < Semantic( LowPrecisionUv ); >;           
	float4 vBlendValues               : TEXCOORD4      < Semantic( VertexPaintBlendParams ); >;   
	float2 nInstanceIdx               : TEXCOORD13     < Semantic( InstanceTransformUv ); >;      
};

VS
{
	StaticCombo( S_MODE_TOOLS_VIS, 0..1 );
	StaticCombo( S_PAINT_VERTEX_COLORS, F_PAINT_VERTEX_COLORS );
	DynamicCombo( D_COMPRESSED_NORMALS_AND_TANGENTS, 0..1 );
	DynamicCombo( D_CS_VERTEX_ANIMATION, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_VERTEX_STREAM, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_LIGHTMAP, 0..1 );
	DynamicComboRule( Allow1( D_BAKED_LIGHTING_FROM_VERTEX_STREAM, D_BAKED_LIGHTING_FROM_LIGHTMAP ) );
	
	cbuffer PerViewConstantBufferCsgo_t < Attribute("PerViewConstantBufferCsgo_t"); >;
	cbuffer PerViewConstantBuffer_t < Attribute("PerViewConstantBuffer_t"); >;
	ByteAddressBuffer g_animatedVertexCache < Attribute("AnimatedVertexCache"); >;
	bool g_bTexCoordScaleByModel < UiType(CheckBox); Expression((g_nScaleTexCoordUByModelScaleAxis!=0) || (g_nScaleTexCoordVByModelScaleAxis!=0)); >;
	ExternalDescriptorSet g_globalLateBoundBindlessSet < Source(ExternalDescSet); Attribute("g_globalLateBoundBindlessSet"); >;
	StructuredBuffer g_instanceBuffer < Attribute("InstanceBuffer"); >;
	ExternalDescriptorSet g_lightBinnerGpuSet < Source(ExternalDescSet); Attribute("g_lightBinnerGpuSet"); >;
	StructuredBuffer g_transformBuffer < Attribute("TransformBuffer"); >;
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
	// cbuffer ID 5618 (name: _Globals_), member index 0 (name: g_vTexCoordXform0) cannot be expressed with either HLSL packing layout or packoffset.
	//
	// Re-attempting reflection with the GLSL backend.
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (6804 bytes), GLSL reflection with SPIRV-Cross by KhronosGroup
	
	#version 460
	
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
	    mat3x4 _m0;
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
	    mat3x4 _m0;
	};
	
	layout(set = 4, binding = 32, std430) readonly buffer g_instanceBuffer
	{
	    _1126 _m0[];
	} g_instanceBuffer_1;
	
	layout(set = 4, binding = 30, std430) readonly buffer g_transformBuffer
	{
	    _1120 _m0[];
	} g_transformBuffer_1;
	
	struct _1260
	{
	    mat4 _m0;
	    float _m1;
	    vec4 _m2;
	};
	
	layout(set = 0) uniform _1260 PerViewConstantBuffer_t;
	
	struct _1234
	{
	    vec4 g_vTexCoordXform0;
	    vec4 g_vTexCoordXform1;
	    vec2 g_vTexCoordScrollSpeed;
	    vec3 g_vColorTint;
	    float g_flModelTintAmount;
	};
	
	layout(set = 0) uniform _1234 _Globals_;
	
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
	layout(location = 6) in vec4 vBlendValues;
	layout(location = 0) out vec4 output_0;
	layout(location = 1) out vec3 output_1;
	layout(location = 2) out vec3 output_2;
	layout(location = 3) out vec4 output_3;
	layout(location = 4) centroid out vec4 output_4;
	layout(location = 5) centroid out vec3 output_5;
	layout(location = 6) out vec4 output_6;
	layout(location = 7) flat out uint output_7;
	
	void main()
	{
	    _1125 _20228;
	    _20228._m0 = g_instanceBuffer_1._m0[nInstanceIdx]._m0;
	    _20228._m1 = g_instanceBuffer_1._m0[nInstanceIdx]._m1;
	    _20228._m2 = g_instanceBuffer_1._m0[nInstanceIdx]._m2;
	    _20228._m3 = g_instanceBuffer_1._m0[nInstanceIdx]._m3;
	    _20228._m4 = g_instanceBuffer_1._m0[nInstanceIdx]._m4;
	    _20228._m5 = g_instanceBuffer_1._m0[nInstanceIdx]._m5;
	    _20228._m6 = g_instanceBuffer_1._m0[nInstanceIdx]._m6;
	    _20228._m7 = g_instanceBuffer_1._m0[nInstanceIdx]._m7;
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
	    _1119 _21957;
	    _21957._m0 = g_transformBuffer_1._m0[_21709]._m0;
	    vec3 _19321;
	    if (_16987 > 0u)
	    {
	        _1119 _20229;
	        _20229._m0 = g_transformBuffer_1._m0[_20228._m1]._m0;
	        _19321 = vec3(_20229._m0[0].z);
	    }
	    else
	    {
	        _19321 = vec3(1.0);
	    }
	    vec4 _23812 = vec4(uvec4(_20228._m0 & 255u, (_20228._m0 & 65280u) >> uint(8), (_20228._m0 & 16711680u) >> uint(16), (_20228._m0 & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
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
	    float _17978;
	    if (_23812.z <= 0.040449999272823333740234375)
	    {
	        _17978 = _17828.z;
	    }
	    else
	    {
	        _17978 = _7676.z;
	    }
	    float _7654 = _23812.w;
	    vec3 _11179 = normalize(vec4(vNormalOs.xyz, 0.0) * _21957._m0);
	    vec3 _12151 = vec4(vPositionOs.xyz * _19321.xyz, 1.0) * _21957._m0;
	    vec4 _18237 = (vec4(_12151.xyz, 1.0) + (PerViewConstantBuffer_t._m2 * 1.0)).xyzw * PerViewConstantBuffer_t._m0;
	    vec4 _9360 = vTexCoord.xyxy;
	    _9360.x = dot(vTexCoord.xy, _Globals_.g_vTexCoordXform0.xy) + _Globals_.g_vTexCoordXform0.w;
	    _9360.y = dot(vTexCoord.xy, _Globals_.g_vTexCoordXform1.xy) + _Globals_.g_vTexCoordXform1.w;
	    vec2 _22490 = _9360.xy + (_Globals_.g_vTexCoordScrollSpeed.xy * PerViewConstantBuffer_t._m1);
	    vec4 _20488 = _9360;
	    _20488.x = _22490.x;
	    _20488.y = _22490.y;
	    vec4 _11399 = vec4(mix(vec3(1.0), vec4(_21354, _21355, _17978, _7654).xyz, vec3(_Globals_.g_flModelTintAmount)), _7654 * _20228._m7);
	    vec3 _13062 = _11399.xyz * _Globals_.g_vColorTint.xyz;
	    vec4 _23714 = _11399;
	    _23714.x = _13062.x;
	    _23714.y = _13062.y;
	    _23714.z = _13062.z;
	    output_0 = vec4(vBlendValues.xyz, max(vBlendValues.w, 0.100000001490116119384765625));
	    output_1 = _12151.xyz - PerViewConstantBufferCsgo_t._m0.xyz;
	    output_2 = _11179;
	    output_3 = _20488;
	    output_4 = _23714;
	    output_5 = _11179;
	    output_6 = vec4(normalize(vec4(vTangentUOs_flTangentVSign.xyz, 0.0) * _21957._m0), vTangentUOs_flTangentVSign.w);
	    output_7 = _20228._m5 & 65535u;
	    _18237.y = -_18237.y;
	    gl_Position = _18237;
	}
	
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
	
	BoolAttribute(BindlessResources, true);
	BoolAttribute(environmentmapped, true);
	BoolAttribute(environmentmappeddynamic, true);
	BoolAttribute(CanBatchWithDynamicShaderConstants, true);
	IntAttribute(TexCoordScaleByModelU, g_nScaleTexCoordUByModelScaleAxis-1);
	IntAttribute(TexCoordScaleByModelV, g_nScaleTexCoordVByModelScaleAxis-1);
	Float3Attribute(LightSim_MaterialTint, g_vColorTint);
	BoolAttribute(VertexPaintUI2Layer, true);
	BoolAttribute(VertexPaintUIAlphaBlendFactor, true);
	BoolAttribute(SupportsAggregateInstancing, true);
	
	#if (S_PAINT_VERTEX_COLORS == 1)
		BoolAttribute(VertexPaintUIPickColor, true);
	#endif
}

PS
{
	StaticCombo( S_ENABLE_TINT_MASKS, F_ENABLE_TINT_MASKS );
	StaticCombo( S_SHADER_QUALITY, 0..1 );
	StaticCombo( S_MODE_TOOLS_VIS, 0..1 );
	StaticCombo( S_ENABLE_AO, F_ENABLE_AMBIENT_OCCLUSION );
	StaticComboRule( Requires( S_MODE_TOOLS_VIS, S_SHADER_QUALITY ) );
	DynamicCombo( D_BAKED_LIGHTING_FROM_VERTEX_STREAM, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_PROBE, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_LIGHTMAP, 0..1 );
	DynamicCombo( D_OPAQUE_FADE, 0..1 );
	DynamicCombo( D_SPECULAR_CUBE_MAP_STATIC, 0..1 );
	DynamicComboRule( Allow1( D_BAKED_LIGHTING_FROM_PROBE, D_BAKED_LIGHTING_FROM_VERTEX_STREAM, D_BAKED_LIGHTING_FROM_LIGHTMAP ) );
	DynamicComboRule( Requires( D_SPECULAR_CUBE_MAP_STATIC, S_SHADER_QUALITY ) );
	
	cbuffer BakedLightingConstantBuffer_t < Attribute("BakedLightingConstantBuffer_t"); >;
	cbuffer PerViewConstantBufferCsgo_t < Attribute("PerViewConstantBufferCsgo_t"); >;
	cbuffer PerViewConstantBuffer_t < Attribute("PerViewConstantBuffer_t"); >;
	cbuffer PerViewLightProbeVolumeConstantBuffer_t < Attribute("PerViewLightProbeVolumeConstantBuffer_t"); >;
	cbuffer PerViewLightingConstantBufferGpu_t < Attribute("PerViewLightingConstantBufferGpu_t"); >;
	StructuredBuffer g_BarnLights < Attribute("BarnLights"); >;
	StructuredBuffer g_CullBits < Attribute("CullBits"); >;
	bool g_bCubemapNormalization < Attribute("g_bCubemapNormalization"); UiType(CheckBox); >;
	bool g_bDisableNormalMapping < Attribute("g_bDisableNormalMapping"); UiType(CheckBox); >;
	bool g_bHighlightDeprecated < Attribute("g_bHighlightDeprecated"); UiType(CheckBox); >;
	bool g_bIsDeprecated < Attribute("bIsDeprecated"); UiType(CheckBox); >;
	bool g_bRenderingToCubemaps < Attribute("g_bRenderingToCubemaps"); UiType(CheckBox); >;
	bool g_bShowLPVVoxels < Attribute("g_bShowLPVVoxels"); UiType(CheckBox); >;
	bool g_bShowLightmapTexels < Attribute("g_bShowLightmapTexels"); UiType(CheckBox); >;
	float g_fToolsVisHeightTint < Default(0.9); Attribute("g_fToolsVisHeightTint"); UiType(Slider); >;
	float g_fToolsVisMaxHeightRange < Default(1); Attribute("g_fToolsVisMaxHeightRange"); UiType(Slider); >;
	float g_fToolsVisMaxLightingComplexity < Default(8); Attribute("g_fToolsVisMaxLightingComplexity"); UiType(Slider); >;
	float g_flReflectance < UiType(Slider); Expression(pow((1.5-1)/(1.5+1),2)); >;
	ExternalDescriptorSet g_globalLateBoundBindlessSet < Source(ExternalDescSet); Attribute("g_globalLateBoundBindlessSet"); >;
	ExternalDescriptorSet g_lightBinnerGpuSet < Source(ExternalDescSet); Attribute("g_lightBinnerGpuSet"); >;
	int g_nToolsVisMode < Attribute("g_nToolsVisMode"); UiType(Slider); >;
	Texture2D g_tColorA < Channel(RGB, Box(TextureColorA), Srgb); OutputFormat(DXT1); SrgbRead(true); >;
	Texture2D g_tColorA < Channel(RGB, Box(TextureColorA), Srgb); Channel(A, Box(TextureAmbientOcclusionA), Linear); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tColorB < Channel(RGB, Box(TextureColorB), Srgb); OutputFormat(DXT1); SrgbRead(true); >;
	Texture2D g_tColorB < Channel(RGB, Box(TextureColorB), Srgb); Channel(A, Box(TextureAmbientOcclusionB), Linear); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tMask < Channel(R, Box(TextureMask), Linear); OutputFormat(ATI1N); SrgbRead(false); >;
	Texture2D g_tNormalA < Channel(RGBA, HemiOctIsoRoughness_RG_B(TextureNormalA, TextureRoughnessA), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tNormalB < Channel(RGBA, HemiOctIsoRoughness_RG_B(TextureNormalB, TextureRoughnessB), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tTintMask < Channel(R, Box(TextureTintMaskA), Linear); Channel(G, Box(TextureTintMaskB), Linear); OutputFormat(ATI2N); SrgbRead(false); >;
	float3 g_vFlatOverlayColor < Default2(1, 0); Attribute("FlatOverlayColor"); UiType(VectorText); >;
	float4 g_vShaderIDColor < Source(ShaderIDColor); UiType(VectorText); >;
	
	// Material A
	CreateInputTexture2D(TextureColorA, Srgb, 8, "", "_color", "Material A,10/10", Default4(1, 1, 1, 0));
	CreateInputTexture2D(TextureNormalA, Linear, 8, "NormalizeNormals", "_normal", "Material A,10/20", Default4(0.5, 0.5, 1, 0));
	CreateInputTexture2D(TextureRoughnessA, Linear, 8, "Inverse", "_rough", "Material A,10/30", Default4(0.5, 0.5, 0.5, 0));
	CreateInputTexture2D(TextureAmbientOcclusionA, Linear, 8, "", "_ao", "Material A,10/40", Default4(1, 1, 1, 0));
	CreateInputTexture2D(TextureTintMaskA, Linear, 8, "", "_mask", "Material A,10/50", Default4(1, 1, 1, 0));
	float g_flMetalnessA < UiType(Slider); UiGroup("Material A,10/60"); >;
	
	// Material B
	float2 g_vTexCoordScale2 < Default2(1, 1); Range2(0, 0, 100, 100); UiType(VectorText); UiGroup("Material B,100"); >;
	CreateInputTexture2D(TextureColorB, Srgb, 8, "", "_color", "Material B,20/10", Default4(1, 1, 1, 0));
	CreateInputTexture2D(TextureNormalB, Linear, 8, "NormalizeNormals", "_normal", "Material B,20/20", Default4(0.5, 0.5, 1, 0));
	CreateInputTexture2D(TextureRoughnessB, Linear, 8, "Inverse", "_rough", "Material B,20/30", Default4(0.5, 0.5, 0.5, 0));
	CreateInputTexture2D(TextureAmbientOcclusionB, Linear, 8, "", "_ao", "Material B,20/40", Default4(1, 1, 1, 0));
	CreateInputTexture2D(TextureTintMaskB, Linear, 8, "", "_mask", "Material B,10/50", Default4(1, 1, 1, 0));
	float g_flMetalnessB < UiType(Slider); UiGroup("Material B,20/60"); >;
	
	// Mask
	CreateInputTexture2D(TextureMask, Linear, 8, "", "_mask", "Mask,30/10", Default4(1, 1, 1, 0));
	
	// Fog
	bool g_bFogEnabled < Default(1); UiType(CheckBox); UiGroup("Fog"); >;
	
	// Texture Address Mode
	int g_nTextureAddressModeU < UiOption("RsTextureAddressMode_t"); UiType(Enum); UiGroup("Texture Address Mode"); >;
	int g_nTextureAddressModeV < UiOption("RsTextureAddressMode_t"); UiType(Enum); UiGroup("Texture Address Mode"); >;
	
	#if (S_ENABLE_AO == 1)
		Texture2D g_tColorA < Channel(RGB, Box(TextureColorA), Srgb); Channel(A, Box(TextureAmbientOcclusionA), Linear); OutputFormat(BC7); SrgbRead(true); >;
		Texture2D g_tColorB < Channel(RGB, Box(TextureColorB), Srgb); Channel(A, Box(TextureAmbientOcclusionB), Linear); OutputFormat(BC7); SrgbRead(true); >;
	#endif
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (37540 bytes), HLSL reflection with SPIRV-Cross by KhronosGroup
	
	struct _2242
	{
	    float4 _m0[3];
	};
	
	struct _2452
	{
	    float4 _m0[4];
	};
	
	struct _2360
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
	
	static float4 _3;
	static float3 _4;
	
	cbuffer _Globals_ : register(b0, space1)
	{
	    uint _Globals_1_g_sTrilinearWrap : packoffset(c0.z);
	    uint _Globals_1_g_sTrilinearClamp : packoffset(c0.w);
	    uint _Globals_1_g_sPointClamp : packoffset(c1);
	    uint _Globals_1_g_sUserConfig : packoffset(c1.w);
	    float _Globals_1_g_flMetalnessA : packoffset(c3);
	    float _Globals_1_g_flMetalnessB : packoffset(c3.y);
	    float2 _Globals_1_g_vTexCoordScale2 : packoffset(c3.z);
	    uint _Globals_1_g_tColorA : packoffset(c4);
	    uint _Globals_1_g_tColorB : packoffset(c4.y);
	    uint _Globals_1_g_tNormalA : packoffset(c4.z);
	    uint _Globals_1_g_tNormalB : packoffset(c4.w);
	    uint _Globals_1_g_tMask : packoffset(c5);
	    uint _Globals_1_g_sCookieSampler : packoffset(c5.z);
	    uint _Globals_1_g_tShadowDepthBufferCmpSampler : packoffset(c5.w);
	    int _Globals_1_g_bFogEnabled : packoffset(c6.y);
	    float _Globals_1_g_flReflectance : packoffset(c7);
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
	    uint PerViewConstantBufferCsgo_t_1_m7 : packoffset(c6.z);
	    column_major float4x4 PerViewConstantBufferCsgo_t_1_m8 : packoffset(c12);
	    float2 PerViewConstantBufferCsgo_t_1_m9 : packoffset(c16);
	    float PerViewConstantBufferCsgo_t_1_m10 : packoffset(c16.z);
	    float4 PerViewConstantBufferCsgo_t_1_m11 : packoffset(c23);
	    float4 PerViewConstantBufferCsgo_t_1_m12 : packoffset(c24);
	    float4 PerViewConstantBufferCsgo_t_1_m13 : packoffset(c25);
	    float4 PerViewConstantBufferCsgo_t_1_m14 : packoffset(c26);
	    float4 PerViewConstantBufferCsgo_t_1_m15 : packoffset(c27);
	    float4 PerViewConstantBufferCsgo_t_1_m16 : packoffset(c28);
	    column_major float4x4 PerViewConstantBufferCsgo_t_1_m17 : packoffset(c29);
	    float4 PerViewConstantBufferCsgo_t_1_m18 : packoffset(c33);
	    float4 PerViewConstantBufferCsgo_t_1_m19 : packoffset(c34);
	    float4 PerViewConstantBufferCsgo_t_1_m20 : packoffset(c35);
	};
	
	cbuffer PerViewLightingConstantBufferGpu_t : register(b0, space3)
	{
	    _2242 PerViewLightingConstantBufferGpu_t_1_m0 : packoffset(c7);
	    _2452 PerViewLightingConstantBufferGpu_t_1_m1 : packoffset(c11);
	    float4 PerViewLightingConstantBufferGpu_t_1_m2 : packoffset(c16);
	    float4 PerViewLightingConstantBufferGpu_t_1_m3 : packoffset(c17);
	    float4 PerViewLightingConstantBufferGpu_t_1_m4 : packoffset(c18);
	    uint4 PerViewLightingConstantBufferGpu_t_1_m5 : packoffset(c19);
	    uint4 PerViewLightingConstantBufferGpu_t_1_m6 : packoffset(c22);
	    float4 PerViewLightingConstantBufferGpu_t_1_m7 : packoffset(c23);
	    float4 PerViewLightingConstantBufferGpu_t_1_m8 : packoffset(c24);
	    float4 PerViewLightingConstantBufferGpu_t_1_m9 : packoffset(c1945);
	    float4 PerViewLightingConstantBufferGpu_t_1_m10 : packoffset(c1946);
	    int PerViewLightingConstantBufferGpu_t_1_m11 : packoffset(c1953);
	    float PerViewLightingConstantBufferGpu_t_1_m12 : packoffset(c1953.z);
	    float4 PerViewLightingConstantBufferGpu_t_1_m13 : packoffset(c1954);
	    float PerViewLightingConstantBufferGpu_t_1_m14 : packoffset(c1955);
	    float PerViewLightingConstantBufferGpu_t_1_m15 : packoffset(c1955.y);
	    float PerViewLightingConstantBufferGpu_t_1_m16 : packoffset(c1955.z);
	    float PerViewLightingConstantBufferGpu_t_1_m17 : packoffset(c1955.w);
	    _2360 PerViewLightingConstantBufferGpu_t_1_m18 : packoffset(c1956);
	    _2452 PerViewLightingConstantBufferGpu_t_1_m19 : packoffset(c1988);
	    uint PerViewLightingConstantBufferGpu_t_1_m20 : packoffset(c1996);
	    uint PerViewLightingConstantBufferGpu_t_1_m21 : packoffset(c1996.y);
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
	TextureCubeArray<float4> g_bindless_TextureCubeArray_float4[65536] : register(t46, space4);
	TextureCube<float4> g_bindless_TextureCube_float4[65536] : register(t46, space4);
	
	static float4 gl_FragCoord;
	static float4 input_0;
	static float3 input_1;
	static float3 input_2;
	static float4 input_3;
	static float4 input_4;
	static float3 input_5;
	static float4 input_6;
	static float4 output_0;
	
	struct PS_INPUT
	{
	    float4 input_0 : TEXCOORD0;
	    float3 input_1 : TEXCOORD1;
	    float3 input_2 : TEXCOORD2;
	    float4 input_3 : TEXCOORD3;
	    centroid float4 input_4 : TEXCOORD4;
	    centroid float3 input_5 : TEXCOORD5;
	    float4 input_6 : TEXCOORD6;
	    float4 gl_FragCoord : SV_Position;
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
	    if (dot(input_2.xyz, input_2.xyz) >= 1.0099999904632568359375f)
	    {
	        _21709 = input_5.xyz;
	    }
	    else
	    {
	        _21709 = input_2.xyz;
	    }
	    float3 _20700 = normalize(_21709);
	    float3 _7715 = input_1 + PerViewConstantBufferCsgo_t_1_m20.xyz;
	    float2 _11085 = (input_3.xy * _Globals_1_g_vTexCoordScale2.xy).xy;
	    float4 _21762 = g_bindless_Texture2D_float4[_Globals_1_g_tNormalA].Sample(g_bindless_Sampler[_Globals_1_g_sUserConfig], input_3.xy);
	    float4 _21763 = g_bindless_Texture2D_float4[_Globals_1_g_tNormalB].Sample(g_bindless_Sampler[_Globals_1_g_sUserConfig], _11085);
	    float4 _19372 = g_bindless_Texture2D_float4[_Globals_1_g_tMask].Sample(g_bindless_Sampler[_Globals_1_g_sTrilinearWrap], _11085);
	    float _16038 = _19372.x;
	    float _24575 = smoothstep(max(0.0f, _16038 - input_0.w), min(1.0f, _16038 + input_0.w), input_0.x);
	    float3 _21122 = g_bindless_Texture2D_float4[_Globals_1_g_tColorA].Sample(g_bindless_Sampler[_Globals_1_g_sUserConfig], input_3.xy).xyz * input_4.xyz;
	    float4 _23714;
	    _23714.x = _21122.x;
	    _23714.y = _21122.y;
	    _23714.z = _21122.z;
	    float3 _20313 = g_bindless_Texture2D_float4[_Globals_1_g_tColorB].Sample(g_bindless_Sampler[_Globals_1_g_sUserConfig], _11085).xyz * input_4.xyz;
	    float4 _23715;
	    _23715.x = _20313.x;
	    _23715.y = _20313.y;
	    _23715.z = _20313.z;
	    float4 _8489 = lerp(_21762.xyzw, _21763.xyzw, _24575.xxxx);
	    float _14051 = lerp(_Globals_1_g_flMetalnessA, _Globals_1_g_flMetalnessB, _24575);
	    float3 _11217 = lerp(_23714.xyz, _23715.xyz, _24575.xxx).xyz;
	    float3 _25153 = lerp(_Globals_1_g_flReflectance.xxx.xyz, _11217, _14051.xxx);
	    float _10782 = _8489.x;
	    float _17303 = _8489.y;
	    float _16783 = (_10782 + _17303) - 1.00392162799835205078125f;
	    float _11176 = _10782 - _17303;
	    float3 _23372 = normalize(float3(float2(_16783, _11176), (1.0f - abs(_16783)) - abs(_11176)));
	    float3 _20024 = input_2.xyz * 1.0f;
	    float3 _14435 = cross(_20024.xyz, input_6.xyz) * ((input_6.w > 0.0f) ? 1.0f : (-1.0f));
	    float3 _20195;
	    if (bool4(PerViewConstantBufferCsgo_t_1_m2.x != int4(0, 0, 0, 0).x, PerViewConstantBufferCsgo_t_1_m2.y != int4(0, 0, 0, 0).y, PerViewConstantBufferCsgo_t_1_m2.z != int4(0, 0, 0, 0).z, PerViewConstantBufferCsgo_t_1_m2.w != int4(0, 0, 0, 0).w).w)
	    {
	        _20195 = -_14435;
	    }
	    else
	    {
	        _20195 = _14435;
	    }
	    float3 _19740 = normalize((((input_6.xyz * _23372.x).xyz + (_20195.xyz * (-_23372.y))).xyz + (_20024.xyz * _23372.z)).xyz);
	    bool3 _10679 = all(bool3(true, true, true)).xxx;
	    float3 _17892 = float3(_10679.x ? _19740.x : 1.0f.xxx.x, _10679.y ? _19740.y : 1.0f.xxx.y, _10679.z ? _19740.z : 1.0f.xxx.z);
	    float3 _10560 = _20700.xyz;
	    float3 _11099 = ddx(_10560);
	    float3 _9175 = ddy(_10560);
	    float3 _10347 = _11099.xyz;
	    float3 _12420 = _9175.xyz;
	    float2 _21815 = max(_8489.z.xx.xy, pow(clamp(max(dot(_10347, _10347), dot(_12420, _12420)), 0.0f, 1.0f), 0.333000004291534423828125f).xx);
	    float3 _15598 = -_20700;
	    float3 _24735 = _19740.xyz;
	    float4 _23875 = float4(_24735, 1.0f);
	    bool4 _24465 = bool4(PerViewConstantBufferCsgo_t_1_m0.x != int4(0, 0, 0, 0).x, PerViewConstantBufferCsgo_t_1_m0.y != int4(0, 0, 0, 0).y, PerViewConstantBufferCsgo_t_1_m0.z != int4(0, 0, 0, 0).z, PerViewConstantBufferCsgo_t_1_m0.w != int4(0, 0, 0, 0).w);
	    float _21710;
	    if (_24465.x)
	    {
	        float3 _11394 = _20700.xyz;
	        float2 _11086 = ((floor(_11408.xy * PerViewConstantBufferCsgo_t_1_m10) * PerViewConstantBufferCsgo_t_1_m9.xy) + (PerViewConstantBufferCsgo_t_1_m9.xy * 0.5f)).xy;
	        float4 _18418 = g_bindless_Texture2D_float4[PerViewConstantBufferCsgo_t_1_m5].GatherRed(g_bindless_Sampler[_Globals_1_g_sCookieSampler], _11086).xyzw - _11408.zzzz;
	        float _18579 = _18418.w;
	        float _12013 = _18418.z;
	        bool _12285 = abs(_12013) < _18579;
	        float2 _23168;
	        if (_12285)
	        {
	            _23168 = float2(PerViewConstantBufferCsgo_t_1_m9.x, 0.0f);
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
	            _23169 = float2(0.0f, PerViewConstantBufferCsgo_t_1_m9.y);
	        }
	        else
	        {
	            _23169 = _23168;
	        }
	        bool2 _13083 = (abs(_18418.y) < (_12286 ? _15372 : _20965)).xx;
	        float4 _10010 = normalize(float4(PerViewLightingConstantBufferGpu_t_1_m2.x * mad(dot(_15598, normalize(float3(PerViewLightingConstantBufferGpu_t_1_m1._m0[0].xy, 0.25f))), 0.5f, 0.5f), PerViewLightingConstantBufferGpu_t_1_m2.y * mad(dot(_15598, normalize(float3(PerViewLightingConstantBufferGpu_t_1_m1._m0[1].xy, 0.25f))), 0.5f, 0.5f), PerViewLightingConstantBufferGpu_t_1_m2.z * mad(dot(_15598, normalize(float3(PerViewLightingConstantBufferGpu_t_1_m1._m0[2].xy, 0.25f))), 0.5f, 0.5f), PerViewLightingConstantBufferGpu_t_1_m2.w * mad(dot(_15598, normalize(float3(PerViewLightingConstantBufferGpu_t_1_m1._m0[3].xy, 0.25f))), 0.5f, 0.5f)));
	        float4 _13232 = max(float4(dot(PerViewLightingConstantBufferGpu_t_1_m1._m0[0].xyz, _11394), dot(PerViewLightingConstantBufferGpu_t_1_m1._m0[1].xyz, _11394), dot(PerViewLightingConstantBufferGpu_t_1_m1._m0[2].xyz, _11394), dot(PerViewLightingConstantBufferGpu_t_1_m1._m0[3].xyz, _11394)).xyzw, 0.0f.xxxx) * normalize(clamp(((_10010 - max(max(_10010.x, _10010.y), max(_10010.z, _10010.w)).xxxx) + 0.20000000298023223876953125f.xxxx) * 5.0f.xxxx, 0.0f.xxxx, 1.0f.xxxx));
	        _21710 = (1.0f / (dot(_13232, 1.0f.xxxx) + PerViewLightingConstantBufferGpu_t_1_m3.x)) * (PerViewLightingConstantBufferGpu_t_1_m3.x + dot(_13232, g_bindless_Texture2D_float4[PerViewConstantBufferCsgo_t_1_m4].SampleLevel(g_bindless_Sampler[_Globals_1_g_sPointClamp], (_11086 + float2(_13083.x ? PerViewConstantBufferCsgo_t_1_m9.xy.x : _23169.x, _13083.y ? PerViewConstantBufferCsgo_t_1_m9.xy.y : _23169.y).xy).xy, 0.0f)));
	    }
	    else
	    {
	        _21710 = 1.0f;
	    }
	    float _21711;
	    [branch]
	    if (PerViewLightingConstantBufferGpu_t_1_m11 != 0)
	    {
	        int _23989;
	        int _10191;
	        float _13136;
	        float3 _14975;
	        int _13039 = 0;
	        for (;;)
	        {
	            if (!(_13039 < PerViewLightingConstantBufferGpu_t_1_m11))
	            {
	                _13136 = 1.0f;
	                _14975 = 0.0f.xxx;
	                _10191 = -1;
	                break;
	            }
	            float4 _18322 = mul(PerViewLightingConstantBufferGpu_t_1_m18._m0[_13039], float4(input_1.xyz, 1.0f));
	            float _12779 = _18322.x;
	            if (max(abs(_12779), abs(_18322.y)) < PerViewLightingConstantBufferGpu_t_1_m13[_13039])
	            {
	                float3 _19470 = float3(_12779, _18322.yz);
	                float2 _24804 = _19470.xy;
	                float2 _22193 = 1.0f.xx - clamp((abs(_24804) * PerViewLightingConstantBufferGpu_t_1_m15.xx) + PerViewLightingConstantBufferGpu_t_1_m14.xx, 0.0f.xx, 1.0f.xx);
	                float2 _20561 = (_24804 * PerViewLightingConstantBufferGpu_t_1_m19._m0[_13039].zw) + PerViewLightingConstantBufferGpu_t_1_m19._m0[_13039].xy;
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
	            float _18270 = g_bindless_Texture2D_float4[PerViewLightingConstantBufferGpu_t_1_m20].SampleCmpLevelZero(g_bindless_Sampler_1[_Globals_1_g_tShadowDepthBufferCmpSampler], _14975.xy, clamp(_14975.z + PerViewLightingConstantBufferGpu_t_1_m12, 0.0f, 1.0f));
	            float _12501;
	            [branch]
	            if (_13136 < 1.0f)
	            {
	                float _7934;
	                if (_10191 < (PerViewLightingConstantBufferGpu_t_1_m11 - 1))
	                {
	                    int _15335 = _10191 + 1;
	                    float4 _19671 = mul(PerViewLightingConstantBufferGpu_t_1_m18._m0[_15335], float4(input_1.xyz, 1.0f));
	                    float2 _20562 = (_19671.xy * PerViewLightingConstantBufferGpu_t_1_m19._m0[_15335].zw) + PerViewLightingConstantBufferGpu_t_1_m19._m0[_15335].xy;
	                    float3 _20489;
	                    _20489.x = _20562.x;
	                    _20489.y = _20562.y;
	                    _7934 = g_bindless_Texture2D_float4[PerViewLightingConstantBufferGpu_t_1_m20].SampleCmpLevelZero(g_bindless_Sampler_1[_Globals_1_g_tShadowDepthBufferCmpSampler], _20489.xy, clamp(_19671.z + PerViewLightingConstantBufferGpu_t_1_m12, 0.0f, 1.0f));
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
	        float _13279 = lerp(_19363, 1.0f, clamp((distance(_7715.xyz, PerViewConstantBuffer_t_1_m3) * PerViewLightingConstantBufferGpu_t_1_m17) + PerViewLightingConstantBufferGpu_t_1_m16, 0.0f, 1.0f));
	        float _12502;
	        if (_24465.y)
	        {
	            _12502 = min(_13279, g_bindless_Texture2D_float4[PerViewConstantBufferCsgo_t_1_m6].SampleLevel(g_bindless_Sampler[_Globals_1_g_sTrilinearClamp], (_11408.xy * PerViewConstantBuffer_t_1_m2.xy).xy, 0.0f).z);
	        }
	        else
	        {
	            _12502 = _13279;
	        }
	        _21711 = _12502;
	    }
	    else
	    {
	        _21711 = 1.0f;
	    }
	    float3 _9716;
	    float3 _24878;
	    [branch]
	    if ((dot(PerViewLightingConstantBufferGpu_t_1_m9.xyz, _24735) * _21711) > 0.0f)
	    {
	        bool3 _19899 = all(bool3(_17892.x == 1.0f.xxx.x, _17892.y == 1.0f.xxx.y, _17892.z == 1.0f.xxx.z)).xxx;
	        float _11797 = max(0.0f, dot(_19740.xyz, PerViewLightingConstantBufferGpu_t_1_m9.xyz));
	        float2 _9840 = max(_21815, PerViewLightingConstantBufferGpu_t_1_m9.w.xx);
	        float3 _12281 = normalize(PerViewLightingConstantBufferGpu_t_1_m9.xyz + (-normalize(_7715.xyz - PerViewConstantBuffer_t_1_m3.xyz)).xyz).xyz;
	        float _12386 = dot(_12281, float3(_19899.x ? _24735.x : _17892.x, _19899.y ? _24735.y : _17892.y, _19899.z ? _24735.z : _17892.z).xyz);
	        float _19210 = max(0.0f, dot(PerViewLightingConstantBufferGpu_t_1_m9.xyz, _12281));
	        float _9850 = _9840.x;
	        float _25211 = _9850 * _9850;
	        float _19095 = _25211 * _25211;
	        float _15346 = ((_12386 * _12386) * (_19095 - 1.0f)) + 1.0f;
	        float3 _16808 = (PerViewLightingConstantBufferGpu_t_1_m10.xyz * _21711).xyz;
	        _9716 = ((_25153.xyz * (_19095 / (((_15346 * _15346) * (_19210 * _19210)) * ((_9850 * 4.0f) + 2.0f)))).xyz * _11797).xyz * _16808;
	        _24878 = PerViewLightingConstantBufferGpu_t_1_m4.xyz + (_11797.xxx.xyz * _16808);
	    }
	    else
	    {
	        _9716 = 0.0f.xxx;
	        _24878 = PerViewLightingConstantBufferGpu_t_1_m4.xyz;
	    }
	    bool4 _24466 = bool4(PerViewConstantBufferCsgo_t_1_m1.x != int4(0, 0, 0, 0).x, PerViewConstantBufferCsgo_t_1_m1.y != int4(0, 0, 0, 0).y, PerViewConstantBufferCsgo_t_1_m1.z != int4(0, 0, 0, 0).z, PerViewConstantBufferCsgo_t_1_m1.w != int4(0, 0, 0, 0).w);
	    bool _20060 = _24466.x;
	    float4 _19364;
	    if (_20060)
	    {
	        float4 _18621 = mul(PerViewConstantBufferCsgo_t_1_m8, float4(_7715.xyz, 1.0f).xyzw);
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
	    float3 _13137;
	    float3 _16324;
	    _13137 = _9716;
	    _16324 = _24878;
	    uint _21567;
	    float3 _13138;
	    float3 _16325;
	    uint _17017 = 0u;
	    for (;;)
	    {
	        if (!(_17017 < PerViewLightingConstantBufferGpu_t_1_m5.z))
	        {
	            break;
	        }
	        uint _14475 = WaveActiveBitOr(g_CullBits.Load((_10838 + _17017) * 4 + 0) & g_CullBits.Load((_23393 + _17017) * 4 + 0));
	        _13138 = _13137;
	        _16325 = _16324;
	        uint _20344;
	        float3 _13212;
	        float3 _15670;
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
	                float4x4 _14097 = asfloat(uint4x4(g_BarnLights.Load(_12608 * 480 + 0), g_BarnLights.Load(_12608 * 480 + 16), g_BarnLights.Load(_12608 * 480 + 32), g_BarnLights.Load(_12608 * 480 + 48), g_BarnLights.Load(_12608 * 480 + 4), g_BarnLights.Load(_12608 * 480 + 20), g_BarnLights.Load(_12608 * 480 + 36), g_BarnLights.Load(_12608 * 480 + 52), g_BarnLights.Load(_12608 * 480 + 8), g_BarnLights.Load(_12608 * 480 + 24), g_BarnLights.Load(_12608 * 480 + 40), g_BarnLights.Load(_12608 * 480 + 56), g_BarnLights.Load(_12608 * 480 + 12), g_BarnLights.Load(_12608 * 480 + 28), g_BarnLights.Load(_12608 * 480 + 44), g_BarnLights.Load(_12608 * 480 + 60)));
	                float4 _24893 = mul(float4(input_1.xyz, 1.0f), _14097);
	                float3 _10521 = _24893.xyz / _24893.w.xxx;
	                float4 _22905;
	                _22905.x = _10521.x;
	                _22905.y = _10521.y;
	                float _21778 = _10521.z;
	                _22905.z = _21778;
	                float3 _21642 = _22905.xyz;
	                bool _7424;
	                if (all(bool3(_22905.xyz.x > float3(-1.0f, -1.0f, 0.0f).x, _22905.xyz.y > float3(-1.0f, -1.0f, 0.0f).y, _22905.xyz.z > float3(-1.0f, -1.0f, 0.0f).z)))
	                {
	                    _7424 = all(bool3(_22905.xyz.x < 1.0f.xxx.x, _22905.xyz.y < 1.0f.xxx.y, _22905.xyz.z < 1.0f.xxx.z));
	                }
	                else
	                {
	                    _7424 = false;
	                }
	                bool _12885;
	                if (!_7424)
	                {
	                    _12885 = true;
	                }
	                else
	                {
	                    float4x3 _16509 = asfloat(uint4x3(g_BarnLights.Load(_12608 * 480 + 272), g_BarnLights.Load(_12608 * 480 + 288), g_BarnLights.Load(_12608 * 480 + 304), g_BarnLights.Load(_12608 * 480 + 276), g_BarnLights.Load(_12608 * 480 + 292), g_BarnLights.Load(_12608 * 480 + 308), g_BarnLights.Load(_12608 * 480 + 280), g_BarnLights.Load(_12608 * 480 + 296), g_BarnLights.Load(_12608 * 480 + 312), g_BarnLights.Load(_12608 * 480 + 284), g_BarnLights.Load(_12608 * 480 + 300), g_BarnLights.Load(_12608 * 480 + 316)));
	                    float3 _6368 = abs(mul(float4(input_1.xyz, 1.0f), _16509).xyz);
	                    _12885 = !all(bool3(_6368.x <= 1.0f.xxx.x, _6368.y <= 1.0f.xxx.y, _6368.z <= 1.0f.xxx.z));
	                }
	                if (_12885)
	                {
	                    _13212 = _13138;
	                    _15670 = _16325;
	                    break;
	                }
	                float _23572 = 2.0f * asfloat(g_BarnLights.Load4(_12608 * 480 + 176)).y;
	                float _18492 = (2.0f * asfloat(g_BarnLights.Load4(_12608 * 480 + 176)).z) * asfloat(g_BarnLights.Load4(_12608 * 480 + 176)).z;
	                float _14805 = 2.0f * asfloat(g_BarnLights.Load4(_12608 * 480 + 176)).x;
	                float _9058 = _14805 * asfloat(g_BarnLights.Load4(_12608 * 480 + 176)).y;
	                float _17330 = 2.0f * asfloat(g_BarnLights.Load4(_12608 * 480 + 176)).w;
	                float _19825 = _17330 * asfloat(g_BarnLights.Load4(_12608 * 480 + 176)).z;
	                float3 _16268 = float3(_9058 - _19825, (1.0f - (_14805 * asfloat(g_BarnLights.Load4(_12608 * 480 + 176)).x)) - _18492, (_23572 * asfloat(g_BarnLights.Load4(_12608 * 480 + 176)).z) + (_17330 * asfloat(g_BarnLights.Load4(_12608 * 480 + 176)).x)) * asfloat(g_BarnLights.Load3(_12608 * 480 + 192)).z;
	                float _21316;
	                if (asfloat(g_BarnLights.Load4(_12608 * 480 + 144)).z > 0.0f)
	                {
	                    _21316 = min(1.0f, _21778 * asfloat(g_BarnLights.Load4(_12608 * 480 + 144)).z);
	                }
	                else
	                {
	                    _21316 = 1.0f;
	                }
	                float _19667;
	                if (asfloat(g_BarnLights.Load4(_12608 * 480 + 144)).w > 0.0f)
	                {
	                    _19667 = _21316 * min(1.0f, (1.0f - _21778) * asfloat(g_BarnLights.Load4(_12608 * 480 + 144)).w);
	                }
	                else
	                {
	                    _19667 = _21316;
	                }
	                float3 _11179;
	                float _11633;
	                if (asfloat(g_BarnLights.Load4(_12608 * 480 + 128)).w != 0.0f)
	                {
	                    float3 _10017 = asfloat(g_BarnLights.Load4(_12608 * 480 + 128)).xyz - input_1.xyz;
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
	                    _11633 = ((_19667 * (asfloat(g_BarnLights.Load4(_12608 * 480 + 128)).w / max(_18345, asfloat(g_BarnLights.Load4(_12608 * 480 + 128)).w))) * clamp(asfloat(g_BarnLights.Load4(_12608 * 480 + 144)).x + (asfloat(g_BarnLights.Load4(_12608 * 480 + 144)).y * _17647), 0.0f, 1.0f)) * clamp(asfloat(g_BarnLights.Load3(_12608 * 480 + 192)).x + (asfloat(g_BarnLights.Load3(_12608 * 480 + 192)).y * dot(float3((1.0f - (_23572 * asfloat(g_BarnLights.Load4(_12608 * 480 + 176)).y)) - _18492, _9058 + _19825, (_14805 * asfloat(g_BarnLights.Load4(_12608 * 480 + 176)).z) - (_17330 * asfloat(g_BarnLights.Load4(_12608 * 480 + 176)).y)), normalize(_10210))), 0.0f, 1.0f);
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
	                            float _15018 = _22154.y;
	                            float _23041 = (-0.5f) * asfloat(g_BarnLights.Load4(_12608 * 480 + 224)).z;
	                            float _11981 = (asfloat(g_BarnLights.Load4(_12608 * 480 + 224)).x * asfloat(g_BarnLights.Load4(_12608 * 480 + 224)).y) * pow(max(pow(asfloat(g_BarnLights.Load4(_12608 * 480 + 224)).y * _11473, _15266) + pow(asfloat(g_BarnLights.Load4(_12608 * 480 + 224)).x * _15018, _15266), 1.1754943508222875079687365372222e-38f), _23041);
	                            float _16524 = pow(max(pow(_11473, _15266) + pow(_15018, _15266), 1.1754943508222875079687365372222e-38f), _23041);
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
	                        float3 _20492 = _14081;
	                        _20492.x = _20564.x;
	                        _20492.y = _20564.y;
	                        _12503 = _17828.xyz * g_bindless_Texture3D_float4[PerViewLightingConstantBufferGpu_t_1_m21].SampleLevel(g_bindless_Sampler[_Globals_1_g_sTrilinearWrap], _20492.xyz, 0.0f).xyz;
	                    }
	                    else
	                    {
	                        float3 _13791 = float3(mad(_22905.xy, float2(0.5f, -0.5f), 0.5f.xx), asfloat(g_BarnLights.Load4(_12608 * 480 + 160)).w);
	                        float2 _20563 = (_13791.xy * asfloat(g_BarnLights.Load4(_12608 * 480 + 224)).zw) + asfloat(g_BarnLights.Load4(_12608 * 480 + 224)).xy;
	                        float3 _20491 = _13791;
	                        _20491.x = _20563.x;
	                        _20491.y = _20563.y;
	                        _12503 = _17828.xyz * g_bindless_Texture3D_float4[PerViewLightingConstantBufferGpu_t_1_m21].SampleLevel(g_bindless_Sampler[_Globals_1_g_sCookieSampler], _20491.xyz, 0.0f).xyz;
	                    }
	                    _21548 = _12503;
	                }
	                if (all(bool3(_21548.xyz.x == 0.0f.xxx.x, _21548.xyz.y == 0.0f.xxx.y, _21548.xyz.z == 0.0f.xxx.z)))
	                {
	                    _13212 = _13138;
	                    _15670 = _16325;
	                    break;
	                }
	                float3 _22671;
	                if (_24419)
	                {
	                    float3 _19629;
	                    if ((g_BarnLights.Load(_12608 * 480 + 264) & 4u) != 0u)
	                    {
	                        float2 _6281 = _22905.yx * float2(1.0f, -1.0f);
	                        float3 _23716 = _21642;
	                        _23716.x = _6281.x;
	                        _23716.y = _6281.y;
	                        _19629 = _23716;
	                    }
	                    else
	                    {
	                        _19629 = _21642;
	                    }
	                    float3 _20482 = _21548.xyz * lerp(1.0f, g_bindless_Texture2D_float4[PerViewLightingConstantBufferGpu_t_1_m20].SampleCmpLevelZero(g_bindless_Sampler_1[_Globals_1_g_tShadowDepthBufferCmpSampler], float3(mad(_19629.xy, asfloat(g_BarnLights.Load4(_12608 * 480 + 208)).zw, asfloat(g_BarnLights.Load4(_12608 * 480 + 208)).xy), _19629.z).xy, clamp(_19629.z + PerViewLightingConstantBufferGpu_t_1_m12, 0.0f, 1.0f)), asfloat(g_BarnLights.Load(_12608 * 480 + 260)));
	                    float3 _16449 = _20482.xyz;
	                    if (all(bool3(_16449.x == 0.0f.xxx.x, _16449.y == 0.0f.xxx.y, _16449.z == 0.0f.xxx.z)))
	                    {
	                        _13212 = _13138;
	                        _15670 = _16325;
	                        break;
	                    }
	                    _22671 = _20482;
	                }
	                else
	                {
	                    _22671 = _21548;
	                }
	                bool3 _19900 = all(bool3(_17892.x == 1.0f.xxx.x, _17892.y == 1.0f.xxx.y, _17892.z == 1.0f.xxx.z)).xxx;
	                float _11798 = max(0.0f, dot(_19740.xyz, _11179.xyz));
	                float2 _9841 = max(_21815, asfloat(g_BarnLights.Load(_12608 * 480 + 256)).xx);
	                float3 _12282 = normalize(_11179.xyz + (-normalize(_7715.xyz - PerViewConstantBuffer_t_1_m3.xyz)).xyz).xyz;
	                float _12387 = dot(_12282, float3(_19900.x ? _24735.x : _17892.x, _19900.y ? _24735.y : _17892.y, _19900.z ? _24735.z : _17892.z).xyz);
	                float _19211 = max(0.0f, dot(_11179.xyz, _12282));
	                float _9851 = _9841.x;
	                float _25212 = _9851 * _9851;
	                float _19097 = _25212 * _25212;
	                float _15348 = ((_12387 * _12387) * (_19097 - 1.0f)) + 1.0f;
	                _13212 = _13138.xyz + (((_25153.xyz * (_19097 / (((_15348 * _15348) * (_19211 * _19211)) * ((_9851 * 4.0f) + 2.0f)))).xyz * _11798).xyz * _22671.xyz);
	                _15670 = _16325.xyz + (_11798.xxx.xyz * _22671.xyz);
	                break;
	            } while(false);
	            _13138 = _13212;
	            _16325 = _15670;
	            _17018 = _20344;
	            continue;
	        }
	        _21567 = _17017 + 1u;
	        _13137 = _13138;
	        _16324 = _16325;
	        _17017 = _21567;
	        continue;
	    }
	    float _17172 = dot(_21815.xy, 0.5f.xx);
	    float3 _6253 = _17892.xyz;
	    float3 _17138 = normalize(_7715.xyz - PerViewConstantBuffer_t_1_m3.xyz);
	    float _17225 = _17172 * _17172;
	    float _20711 = clamp(1.0f - _17225, 0.0f, 1.0f);
	    float4 _15343 = (float4(-1.0f, -0.0274999998509883880615234375f, -0.572000026702880859375f, 0.02199999988079071044921875f) * _17172) + float4(1.0f, 0.0425000004470348358154296875f, 1.03999996185302734375f, -0.039999999105930328369140625f);
	    float _21215 = _15343.x;
	    float2 _24572 = (float2(-1.03999996185302734375f, 1.03999996185302734375f) * ((min(_21215 * _21215, exp2((-9.27999973297119140625f) * max(0.0f, dot((-_17138).xyz, _6253)))) * _21215) + _15343.y)) + _15343.zw;
	    float _20339 = _24572.y;
	    float2 _11427 = float2(_20339, _24572.x + _20339);
	    float3 _8745 = float3(dot(PerViewLightingConstantBufferGpu_t_1_m0._m0[0].xyzw, _23875), dot(PerViewLightingConstantBufferGpu_t_1_m0._m0[1].xyzw, _23875), dot(PerViewLightingConstantBufferGpu_t_1_m0._m0[2].xyzw, _23875)).xyz;
	    float3 _16991 = _16324.xyz + _8745;
	    float3 _20418 = _21710.xxx.xyz;
	    float3 _22686 = (_16324.xyz + (_8745 * _20418).xyz) * (_11217 * (1.0f - _14051)).xyz;
	    float _12931 = _22686.x;
	    float4 _11203 = float4(_12931, _22686.yz, input_4.w);
	    _11203.x = _12931;
	    _11203.y = _22686.y;
	    _11203.z = _22686.z;
	    float3 _15752 = _11203.xyz + (_13137.xyz * _20418).xyz;
	    float4 _20490 = _11203;
	    _20490.x = _15752.x;
	    _20490.y = _15752.y;
	    _20490.z = _15752.z;
	    float3 _15734 = _20490.xyz + ((((lerp(_11427.xxx, _11427.yyy, _25153) * g_bindless_TextureCubeArray_float4[PerViewConstantBufferCsgo_t_1_m7].SampleLevel(g_bindless_Sampler[_Globals_1_g_sTrilinearClamp], float4(normalize(lerp(_6253, reflect(_17138.xyz, _17892.xyz).xyz, (_20711 * (sqrt(_20711) + _17225)).xxx)), 0.0f), PerViewLightingConstantBufferGpu_t_1_m8.y * sqrt(_17172)).xyz).xyz * (normalize(_16991 + 0.001000000047497451305389404296875f.xxx) * clamp(length(_16991), 0.0f, 1.75f))).xyz * (1.0f.xxx + (normalize(_8745 + 0.001000000047497451305389404296875f.xxx) * 0.5f))).xyz * _20418).xyz;
	    float4 _13888 = _20490;
	    _13888.x = _15734.x;
	    _13888.y = _15734.y;
	    _13888.z = _15734.z;
	    float4 _6805;
	    if (_Globals_1_g_bFogEnabled != 0)
	    {
	        float3 _21493;
	        float3 _22956 = _7715.xyz - PerViewConstantBuffer_t_1_m3.xyz;
	        float3 _9057 = _22956.xyz;
	        float3 _19340;
	        do
	        {
	            _21493 = _22956.xyz;
	            bool _12886;
	            if (dot(_21493, _21493) > PerViewConstantBufferCsgo_t_1_m14.x)
	            {
	                _12886 = (_7715.z * PerViewConstantBufferCsgo_t_1_m14.z) < PerViewConstantBufferCsgo_t_1_m14.y;
	            }
	            else
	            {
	                _12886 = false;
	            }
	            [branch]
	            if (_12886)
	            {
	                float2 _9342 = clamp(PerViewConstantBufferCsgo_t_1_m11.xy + (PerViewConstantBufferCsgo_t_1_m11.zw * float2(length(_21493), _7715.z)), 0.0f.xx, 1.0f.xx);
	                float _12872 = (pow(_9342.x, PerViewConstantBufferCsgo_t_1_m12.x) * pow(_9342.y, PerViewConstantBufferCsgo_t_1_m12.y)) * PerViewConstantBufferCsgo_t_1_m13.w;
	                _19340 = lerp(_13888.xyz, float4(PerViewConstantBufferCsgo_t_1_m13.xyz, _12872).xyz, _12872.xxx);
	                break;
	            }
	            _19340 = _13888.xyz;
	            break;
	        } while(false);
	        float4 _23944 = _13888;
	        _23944.x = _19340.x;
	        _23944.y = _19340.y;
	        _23944.z = _19340.z;
	        float3 _19341;
	        do
	        {
	            bool _12887;
	            if (dot(_9057, _9057) > PerViewConstantBufferCsgo_t_1_m18.x)
	            {
	                _12887 = (PerViewConstantBufferCsgo_t_1_m18.z * _7715.z) < PerViewConstantBufferCsgo_t_1_m18.y;
	            }
	            else
	            {
	                _12887 = false;
	            }
	            if (_12887)
	            {
	                float _14602 = clamp(pow(max(0.0f, (length(_21493) * PerViewConstantBufferCsgo_t_1_m15.y) + PerViewConstantBufferCsgo_t_1_m15.x), PerViewConstantBufferCsgo_t_1_m15.w), 0.0f, 1.0f) * clamp(pow(max(0.0f, (_7715.z * PerViewConstantBufferCsgo_t_1_m16.y) + PerViewConstantBufferCsgo_t_1_m16.x), PerViewConstantBufferCsgo_t_1_m16.z), 0.0f, 1.0f);
	                float _8892 = clamp(_14602, 0.0f, 1.0f) * PerViewConstantBufferCsgo_t_1_m18.w;
	                _19341 = lerp(_23944.xyz, float4((g_bindless_TextureCube_float4[PerViewConstantBufferCsgo_t_1_m3].SampleLevel(g_bindless_Sampler[_Globals_1_g_sTrilinearClamp], normalize(mul(float4(_9057, 0.0f), PerViewConstantBufferCsgo_t_1_m17).xyz).xyz, PerViewConstantBufferCsgo_t_1_m16.w * clamp(1.0f - (_14602 * PerViewConstantBufferCsgo_t_1_m15.z), 0.0f, 1.0f)) * PerViewConstantBufferCsgo_t_1_m19.x).xyz, _8892).xyz, _8892.xxx);
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
	        _6805 = _13888;
	    }
	    output_0 = _6805;
	}
	
	PS_OUTPUT MainPs(PS_INPUT stage_input)
	{
	    gl_FragCoord = stage_input.gl_FragCoord;
	    gl_FragCoord.w = 1.0 / gl_FragCoord.w;
	    input_0 = stage_input.input_0;
	    input_1 = stage_input.input_1;
	    input_2 = stage_input.input_2;
	    input_3 = stage_input.input_3;
	    input_4 = stage_input.input_4;
	    input_5 = stage_input.input_5;
	    input_6 = stage_input.input_6;
	    MainPs_inner();
	    PS_OUTPUT stage_output;
	    stage_output.output_0 = output_0;
	    return stage_output;
	}
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
	
	BoolAttribute(BindlessResources, true);
	BoolAttribute(SupportsLightmapping, true);
	BoolAttribute(PerVertexLighting, true);
	BoolAttribute(AllowBackfaceCulling, F_RENDER_BACKFACES ? 0 : 1);
	TextureAttribute(LightSim_DiffuseAlbedoTexture, g_tColorA);
	TextureAttribute(RepresentativeTexture, g_tColorA);
	BoolAttribute(environmentmapped, true);
	BoolAttribute(environmentmappeddynamic, true);
	BoolAttribute(NeedsLightProbe, true);
	BoolAttribute(NoZPrepass, F_DISABLE_Z_PREPASS || 0);
	BoolAttribute(DoNotCastShadows, F_DO_NOT_CAST_SHADOWS || 0);
	BoolAttribute(SupportsMappingDimensions, true);
	BoolAttribute(renderbackfaces, F_RENDER_BACKFACES || 0);
	
	#if (S_ENABLE_TINT_MASKS == 1)
		TextureAttribute(LightSim_TintMaskTextureR, g_tTintMask);
	#endif
	
	// PSRS
	
	RenderState(BackStencilFunc, F_RENDER_BACKFACES ? 5 : 7);
	RenderState(CullMode, F_RENDER_BACKFACES ? None : Front);
	RenderState(CullMode, F_RENDER_BACKFACES ? None : Back);
	RenderState(DepthEnable, F_DISABLE_Z_BUFFERING ? False : True);
	RenderState(DepthWriteEnable, F_DISABLE_Z_BUFFERING ? False : True);
	RenderState(StencilEnable, 1);
	RenderState(StencilFunc, 5);
	RenderState(StencilReadMask, 1);
	RenderState(StencilRef, 3);
	RenderState(StencilWriteMask, 254);
	
	
	BoolAttribute(BindlessResources, true);
	
}

RTX
{
	StaticCombo( S_MODE_TOOLS_VIS, 0..1 );
	StaticCombo( S_PAINT_VERTEX_COLORS, F_PAINT_VERTEX_COLORS );
	StaticCombo( S_ENABLE_TINT_MASKS, F_ENABLE_TINT_MASKS );
	StaticCombo( S_SHADER_QUALITY, 0..1 );
	StaticComboRule( Allow0( S_MODE_TOOLS_VIS, S_SHADER_QUALITY ) );
	DynamicCombo( D_COMPRESSED_NORMALS_AND_TANGENTS, 0..1 );
	DynamicCombo( D_CS_VERTEX_ANIMATION, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_VERTEX_STREAM, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_LIGHTMAP, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_PROBE, 0..1 );
	DynamicComboRule( Allow1( D_BAKED_LIGHTING_FROM_VERTEX_STREAM, D_BAKED_LIGHTING_FROM_LIGHTMAP ) );
	DynamicComboRule( Allow1( D_BAKED_LIGHTING_FROM_PROBE, D_BAKED_LIGHTING_FROM_VERTEX_STREAM, D_BAKED_LIGHTING_FROM_LIGHTMAP ) );
	DynamicComboRule( Allow0( D_BAKED_LIGHTING_FROM_PROBE, D_BAKED_LIGHTING_FROM_VERTEX_STREAM, D_BAKED_LIGHTING_FROM_LIGHTMAP ) );
	DynamicComboRule( Allow0( D_COMPRESSED_NORMALS_AND_TANGENTS, D_CS_VERTEX_ANIMATION ) );
	
	float g_flReflectance < UiType(Slider); Expression(pow((1.5-1)/(1.5+1),2)); >;
	Texture2D g_tColorA < Channel(RGB, Box(TextureColorA), Srgb); OutputFormat(DXT1); SrgbRead(true); >;
	Texture2D g_tColorB < Channel(RGB, Box(TextureColorB), Srgb); OutputFormat(DXT1); SrgbRead(true); >;
	Texture2D g_tMask < Channel(R, Box(TextureMask), Linear); OutputFormat(ATI1N); SrgbRead(false); >;
	Texture2D g_tNormalA < Channel(RGBA, HemiOctIsoRoughness_RG_B(TextureNormalA, TextureRoughnessA), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tNormalB < Channel(RGBA, HemiOctIsoRoughness_RG_B(TextureNormalB, TextureRoughnessB), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tTintMask < Channel(R, Box(TextureTintMaskA), Linear); Channel(G, Box(TextureTintMaskB), Linear); OutputFormat(ATI2N); SrgbRead(false); >;
	float4 g_vTexCoordXform0 < UiType(VectorText); Expression(v0 = (g_flTexCoordRotation*3.1415927)/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v1*g_vTexCoordScale.x,-v2*g_vTexCoordScale.y,0,((g_vTexCoordCenter.x+g_vTexCoordOffset.x)+(v2*g_vTexCoordCenter.y))-(v1*g_vTexCoordCenter.x))); >;
	float4 g_vTexCoordXform1 < UiType(VectorText); Expression(v0 = (g_flTexCoordRotation*3.1415927)/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v2*g_vTexCoordScale.x,v1*g_vTexCoordScale.y,0,(g_vTexCoordCenter.y+g_vTexCoordOffset.y)-((v2*g_vTexCoordCenter.x)+(v1*g_vTexCoordCenter.y)))); >;
	
	// Material A
	CreateInputTexture2D(TextureColorA, Srgb, 8, "", "_color", "Material A,10/10", Default4(1, 1, 1, 0));
	CreateInputTexture2D(TextureNormalA, Linear, 8, "NormalizeNormals", "_normal", "Material A,10/20", Default4(0.5, 0.5, 1, 0));
	CreateInputTexture2D(TextureRoughnessA, Linear, 8, "Inverse", "_rough", "Material A,10/30", Default4(0.5, 0.5, 0.5, 0));
	CreateInputTexture2D(TextureTintMaskA, Linear, 8, "", "_mask", "Material A,10/50", Default4(1, 1, 1, 0));
	float g_flMetalnessA < UiType(Slider); UiGroup("Material A,10/60"); >;
	
	// Material B
	float2 g_vTexCoordScale2 < Default2(1, 1); Range2(0, 0, 100, 100); UiType(VectorText); UiGroup("Material B,100"); >;
	CreateInputTexture2D(TextureColorB, Srgb, 8, "", "_color", "Material B,20/10", Default4(1, 1, 1, 0));
	CreateInputTexture2D(TextureNormalB, Linear, 8, "NormalizeNormals", "_normal", "Material B,20/20", Default4(0.5, 0.5, 1, 0));
	CreateInputTexture2D(TextureRoughnessB, Linear, 8, "Inverse", "_rough", "Material B,20/30", Default4(0.5, 0.5, 0.5, 0));
	CreateInputTexture2D(TextureTintMaskB, Linear, 8, "", "_mask", "Material B,10/50", Default4(1, 1, 1, 0));
	float g_flMetalnessB < UiType(Slider); UiGroup("Material B,20/60"); >;
	
	// Mask
	CreateInputTexture2D(TextureMask, Linear, 8, "", "_mask", "Mask,30/10", Default4(1, 1, 1, 0));
	
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
	
	// Texture Address Mode
	int g_nTextureAddressModeU < UiOption("RsTextureAddressMode_t"); UiType(Enum); UiGroup("Texture Address Mode"); >;
	int g_nTextureAddressModeV < UiOption("RsTextureAddressMode_t"); UiType(Enum); UiGroup("Texture Address Mode"); >;
	
	
	// SPIR-V reflection failed for backend HLSL:
	// Unsupported builtin in HLSL: 5326
	//
	// Re-attempting reflection with the GLSL backend.
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (65972 bytes), GLSL reflection with SPIRV-Cross by KhronosGroup
	
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
	
	struct VS_INPUT
	{
	    vec3 vPositionOs;
	    vec2 vTexCoord;
	    vec3 vNormalOs;
	    vec4 vTangentUOs_flTangentVSign;
	    uvec4 vBlendIndices;
	    uint nInstanceIdx;
	    vec4 vBlendValues;
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
	
	vec4 _268;
	
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
	
	struct SLANG_ParameterGroup_PerViewConstantBuffer_t_natural
	{
	    mat4 g_matWorldToProjection;
	    mat4 g_matProjectionToWorld;
	    mat4 g_matWorldToView;
	    mat4 g_matViewToProjection;
	    vec4 g_vInvProjLowerRight2x2;
	    vec4 g_vClipPlane0;
	    float g_flToneMapScalarLinear;
	    float g_flInvToneMapScalarLinear;
	    float g_flRealTime;
	    float g_flGameTime;
	    vec2 g_vViewportToGBufferRatio;
	    float g_fInvViewportZRange;
	    float g_fMinViewportZScaled;
	    vec2 g_vViewportOffset;
	    vec2 g_vViewportSize;
	    vec2 g_vInvViewportSize;
	    vec2 g_vRenderTargetSize;
	    vec4 g_vInvGBufferSize;
	    float g_flViewportMinZ;
	    float g_flViewportMaxZ;
	    float g_flNearPlane;
	    float g_flFarPlane;
	    vec4 g_vWorldToCameraOffset;
	    vec4 g_vCameraAngles;
	    vec3 g_vCameraPositionWs;
	    float _PerViewPad0;
	    vec3 g_vCameraUpDirWs;
	    float _PerViewPad1;
	    vec3 g_vCameraDirWs;
	    float g_flInvMSAASampleCount;
	    vec3 g_vDepthPsToVsConversion;
	    int g_nMSAASampleCount;
	    vec2 g_vMorphTextureAtlasSize;
	    uint g_tCompositeMorphAtlasTextureIndex;
	    float _PerViewPad4;
	    vec3 g_vFogColor;
	    float g_flNegFogStartOverFogRange;
	    float g_flInvFogRange;
	    float g_flFogMaxDensity;
	    float g_flFogExponent;
	    float g_flFogBlendToBackground;
	    vec4 g_vFrameBufferCopyInvSizeAndUvScale;
	    vec4 g_vPrevWorldToCameraOffset;
	    mat4 g_matPrevWorldToProjection;
	    vec4 g_vWireframeColor;
	};
	
	layout(set = 5) uniform SLANG_ParameterGroup_PerViewConstantBuffer_t_natural PerViewConstantBuffer_t;
	
	hitAttributeEXT BuiltInTriangleIntersectionAttributes attrs;
	layout(set = 4, binding = 46) uniform texture2D g_bindless_Texture2D_float4[65536];
	layout(set = 4, binding = 29) uniform sampler g_bindless_Sampler[2048];
	layout(location = 0) rayPayloadInEXT Payload_t payload;
	
	void main()
	{
	    PackedRtxInstanceData_t_natural_logical _436;
	    _436.nSrgbColor = g_instanceBuffer._member0[uint(gl_InstanceID)].nSrgbColor;
	    _436.nTriangleGeometry = g_instanceBuffer._member0[uint(gl_InstanceID)].nTriangleGeometry;
	    _436.nMaterialData = g_instanceBuffer._member0[uint(gl_InstanceID)].nMaterialData;
	    _436.nMaterialFlags_nInstanceFlags = g_instanceBuffer._member0[uint(gl_InstanceID)].nMaterialFlags_nInstanceFlags;
	    _436.fEmissiveBoost = g_instanceBuffer._member0[uint(gl_InstanceID)].fEmissiveBoost;
	    _436.nInstanceFlags = g_instanceBuffer._member0[uint(gl_InstanceID)].nInstanceFlags;
	    _436._pad1 = g_instanceBuffer._member0[uint(gl_InstanceID)]._pad1;
	    _436._pad2 = g_instanceBuffer._member0[uint(gl_InstanceID)]._pad2;
	    uint _300 = _436.nMaterialData;
	    vec4 _346 = vec4(g_MaterialData_1._member0[(_300 + 112u) / 4u], g_MaterialData_1._member0[(_300 + 116u) / 4u], g_MaterialData_1._member0[(_300 + 120u) / 4u], g_MaterialData_1._member0[(_300 + 124u) / 4u]);
	    vec4 _345 = vec4(g_MaterialData_1._member0[(_300 + 128u) / 4u], g_MaterialData_1._member0[(_300 + 132u) / 4u], g_MaterialData_1._member0[(_300 + 136u) / 4u], g_MaterialData_1._member0[(_300 + 140u) / 4u]);
	    vec2 _344 = vec2(g_MaterialData_1._member0[(_300 + 144u) / 4u], g_MaterialData_1._member0[(_300 + 148u) / 4u]);
	    vec3 _343 = vec3(g_MaterialData_1._member0[(_300 + 208u) / 4u], g_MaterialData_1._member0[(_300 + 212u) / 4u], g_MaterialData_1._member0[(_300 + 216u) / 4u]);
	    float _342 = g_MaterialData_1._member0[(_300 + 220u) / 4u];
	    uint _341 = g_MaterialData_3._member0[(_300 + 236u) / 4u];
	    uint _340 = g_MaterialData_3._member0[(_300 + 256u) / 4u];
	    float _339 = g_MaterialData_1._member0[(_300 + 284u) / 4u];
	    float _338 = g_MaterialData_1._member0[(_300 + 288u) / 4u];
	    vec2 _337 = vec2(g_MaterialData_1._member0[(_300 + 296u) / 4u], g_MaterialData_1._member0[(_300 + 300u) / 4u]);
	    uint _336 = g_MaterialData_3._member0[(_300 + 304u) / 4u];
	    uint _335 = g_MaterialData_3._member0[(_300 + 308u) / 4u];
	    uint _334 = g_MaterialData_3._member0[(_300 + 312u) / 4u];
	    uint _333 = g_MaterialData_3._member0[(_300 + 316u) / 4u];
	    uint _332 = g_MaterialData_3._member0[(_300 + 320u) / 4u];
	    float _331 = g_MaterialData_1._member0[(_300 + 336u) / 4u];
	    uvec3 _429;
	    do
	    {
	        if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes.w == 4)
	        {
	            uint _598 = (12u * uint(gl_PrimitiveID)) + uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes.w);
	            _429 = uvec3(g_Indices_1[g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._member0[_598 / 4u], g_Indices_1[g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._member0[(_598 + 4u) / 4u], g_Indices_1[g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._member0[(_598 + 8u) / 4u]);
	            break;
	        }
	        else
	        {
	            uint _571 = (6u * uint(gl_PrimitiveID)) + uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes.w);
	            uint _572 = _571 & 4294967292u;
	            uint _573 = _572 / 4u;
	            uint _577 = (_572 + 4u) / 4u;
	            uint _582 = (g_Indices_1[g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._member0[_573] & 4294901760u) >> uint(16);
	            uint _583 = g_Indices_1[g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._member0[_577] & 65535u;
	            uvec3 _430;
	            if (_571 == _572)
	            {
	                _430 = uvec3(g_Indices_1[g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._member0[_573] & 65535u, _582, _583);
	            }
	            else
	            {
	                _430 = uvec3(_582, _583, (g_Indices_1[g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._member0[_577] & 4294901760u) >> uint(16));
	            }
	            _429 = _430;
	            break;
	        }
	        break;
	    } while(false);
	    uint _55 = uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.x);
	    uvec3 _629 = (uvec3(uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes.x)) * _429) + uvec3(uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes.x));
	    vec3 _424[3];
	    uint _631 = _629.x;
	    _424[0] = vec3(g_Vertices_1[_55]._member0[_631 / 4u], g_Vertices_1[_55]._member0[(_631 + 4u) / 4u], g_Vertices_1[_55]._member0[(_631 + 8u) / 4u]);
	    uint _645 = _629.y;
	    _424[1] = vec3(g_Vertices_1[_55]._member0[_645 / 4u], g_Vertices_1[_55]._member0[(_645 + 4u) / 4u], g_Vertices_1[_55]._member0[(_645 + 8u) / 4u]);
	    uint _659 = _629.z;
	    _424[2] = vec3(g_Vertices_1[_55]._member0[_659 / 4u], g_Vertices_1[_55]._member0[(_659 + 4u) / 4u], g_Vertices_1[_55]._member0[(_659 + 8u) / 4u]);
	    int _425 = 0;
	    VS_INPUT vsInput[3];
	    for (;;)
	    {
	        if (!(_425 < 3))
	        {
	            break;
	        }
	        vsInput[_425].vPositionOs = _424[_425];
	        _425++;
	        continue;
	    }
	    vec2 _426[3];
	    _426[0] = vec2(0.0);
	    _426[1] = vec2(0.0);
	    _426[2] = vec2(0.0);
	    if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].y != 0)
	    {
	        ivec4 _423 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers;
	        uint _57 = uint(_423[g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].z]);
	        uint _710 = uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].z);
	        ivec4 _421 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes;
	        ivec4 _422 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes;
	        uvec3 _726 = (uvec3(uint(_421[_710])) * _429) + uvec3(uint(_422[_710]) + uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].x));
	        if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].y == 16)
	        {
	            uint _858 = _726.x;
	            _426[0] = vec2(g_Vertices_1[_57]._member0[_858 / 4u], g_Vertices_1[_57]._member0[(_858 + 4u) / 4u]);
	            uint _867 = _726.y;
	            _426[1] = vec2(g_Vertices_1[_57]._member0[_867 / 4u], g_Vertices_1[_57]._member0[(_867 + 4u) / 4u]);
	            uint _876 = _726.z;
	            _426[2] = vec2(g_Vertices_1[_57]._member0[_876 / 4u], g_Vertices_1[_57]._member0[(_876 + 4u) / 4u]);
	        }
	        else
	        {
	            if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].y == 34)
	            {
	                uint _829 = _726.x / 4u;
	                _426[0] = vec2(uint16BitsToFloat16(u16vec2(uvec2(g_Vertices_3[_57]._member0[_829], g_Vertices_3[_57]._member0[_829] >> uint(16)) & uvec2(65535u))));
	                uint _839 = _726.y / 4u;
	                _426[1] = vec2(uint16BitsToFloat16(u16vec2(uvec2(g_Vertices_3[_57]._member0[_839], g_Vertices_3[_57]._member0[_839] >> uint(16)) & uvec2(65535u))));
	                uint _849 = _726.z / 4u;
	                _426[2] = vec2(uint16BitsToFloat16(u16vec2(uvec2(g_Vertices_3[_57]._member0[_849], g_Vertices_3[_57]._member0[_849] >> uint(16)) & uvec2(65535u))));
	            }
	            else
	            {
	                if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].y == 37)
	                {
	                    uint _739 = _726.x / 4u;
	                    uint _742 = g_Vertices_3[_57]._member0[_739] & 65535u;
	                    int _420;
	                    if (_742 > 32767u)
	                    {
	                        _420 = int(4294901760u | _742);
	                    }
	                    else
	                    {
	                        _420 = int(_742);
	                    }
	                    uint _755 = (g_Vertices_3[_57]._member0[_739] & 4294901760u) >> uint(16);
	                    int _419;
	                    if (_755 > 32767u)
	                    {
	                        _419 = int(4294901760u | _755);
	                    }
	                    else
	                    {
	                        _419 = int(_755);
	                    }
	                    _426[0] = vec2(max(float(_420) * 3.0518509447574615478515625e-05, -1.0), max(float(_419) * 3.0518509447574615478515625e-05, -1.0));
	                    uint _769 = _726.y / 4u;
	                    uint _772 = g_Vertices_3[_57]._member0[_769] & 65535u;
	                    int _418;
	                    if (_772 > 32767u)
	                    {
	                        _418 = int(4294901760u | _772);
	                    }
	                    else
	                    {
	                        _418 = int(_772);
	                    }
	                    uint _785 = (g_Vertices_3[_57]._member0[_769] & 4294901760u) >> uint(16);
	                    int _417;
	                    if (_785 > 32767u)
	                    {
	                        _417 = int(4294901760u | _785);
	                    }
	                    else
	                    {
	                        _417 = int(_785);
	                    }
	                    _426[1] = vec2(max(float(_418) * 3.0518509447574615478515625e-05, -1.0), max(float(_417) * 3.0518509447574615478515625e-05, -1.0));
	                    uint _799 = _726.z / 4u;
	                    uint _802 = g_Vertices_3[_57]._member0[_799] & 65535u;
	                    int _416;
	                    if (_802 > 32767u)
	                    {
	                        _416 = int(4294901760u | _802);
	                    }
	                    else
	                    {
	                        _416 = int(_802);
	                    }
	                    uint _815 = (g_Vertices_3[_57]._member0[_799] & 4294901760u) >> uint(16);
	                    int _415;
	                    if (_815 > 32767u)
	                    {
	                        _415 = int(4294901760u | _815);
	                    }
	                    else
	                    {
	                        _415 = int(_815);
	                    }
	                    _426[2] = vec2(max(float(_416) * 3.0518509447574615478515625e-05, -1.0), max(float(_415) * 3.0518509447574615478515625e-05, -1.0));
	                }
	            }
	        }
	    }
	    _425 = 0;
	    for (;;)
	    {
	        if (!(_425 < 3))
	        {
	            break;
	        }
	        vsInput[_425].vTexCoord = _426[_425];
	        _425++;
	        continue;
	    }
	    vec3 _427[3];
	    vec4 _428[3];
	    do
	    {
	        if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.y != 0)
	        {
	            ivec4 _401 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers;
	            uint _61 = uint(_401[g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.z]);
	            uint _926 = uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.z);
	            ivec4 _399 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes;
	            ivec4 _400 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes;
	            uvec3 _942 = (uvec3(uint(_399[_926])) * _429) + uvec3(uint(_400[_926]) + uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.x));
	            if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.y == 6)
	            {
	                uint _1470 = _942.x;
	                _427[0] = vec3(g_Vertices_1[_61]._member0[_1470 / 4u], g_Vertices_1[_61]._member0[(_1470 + 4u) / 4u], g_Vertices_1[_61]._member0[(_1470 + 8u) / 4u]);
	                uint _1484 = _942.y;
	                _427[1] = vec3(g_Vertices_1[_61]._member0[_1484 / 4u], g_Vertices_1[_61]._member0[(_1484 + 4u) / 4u], g_Vertices_1[_61]._member0[(_1484 + 8u) / 4u]);
	                uint _1498 = _942.z;
	                _427[2] = vec3(g_Vertices_1[_61]._member0[_1498 / 4u], g_Vertices_1[_61]._member0[(_1498 + 4u) / 4u], g_Vertices_1[_61]._member0[(_1498 + 8u) / 4u]);
	            }
	            else
	            {
	                if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.y == 17)
	                {
	                    uint _1206 = _942.x;
	                    uvec2 _1214 = uvec2(g_Vertices_3[_61]._member0[_1206 / 4u], g_Vertices_3[_61]._member0[(_1206 + 4u) / 4u]);
	                    uint _1215 = _942.y;
	                    uvec2 _288 = uvec2(g_Vertices_3[_61]._member0[_1215 / 4u], g_Vertices_3[_61]._member0[(_1215 + 4u) / 4u]);
	                    uint _1224 = _942.z;
	                    uvec2 _287 = uvec2(g_Vertices_3[_61]._member0[_1224 / 4u], g_Vertices_3[_61]._member0[(_1224 + 4u) / 4u]);
	                    uint _1236 = _1214.x;
	                    uint _1244 = _1214.y;
	                    vec2 _1254 = ((vec2(float(_1236 & 65535u), float((_1236 >> 16u) & 65535u)) * vec2(1.525902189314365386962890625e-05)) * 2.0) - vec2(1.0);
	                    float _1255 = _1254.x;
	                    float _1260 = (1.0 - abs(_1255)) - abs(_1254.y);
	                    vec3 _1261 = vec3(_1255, _1254.y, _1260);
	                    float _1263 = saturate(-_1260);
	                    vec2 _1269 = _1254 + mix(vec2(_1263), vec2(-_1263), greaterThanEqual(_1254, vec2(0.0)));
	                    _1261.x = _1269.x;
	                    _1261.y = _1269.y;
	                    vec3 _403 = normalize(_1261);
	                    vec2 _1276 = ((vec2(float((_1244 >> uint(1)) & 32767u), float((_1244 >> 16u) & 32767u)) * vec2(3.0518509447574615478515625e-05)) * 2.0) - vec2(1.0);
	                    float _1277 = _1276.x;
	                    float _1282 = (1.0 - abs(_1277)) - abs(_1276.y);
	                    vec3 _1283 = vec3(_1277, _1276.y, _1282);
	                    float _1285 = saturate(-_1282);
	                    vec2 _1291 = _1276 + mix(vec2(_1285), vec2(-_1285), greaterThanEqual(_1276, vec2(0.0)));
	                    _1283.x = _1291.x;
	                    _1283.y = _1291.y;
	                    vec3 _402 = normalize(_1283);
	                    float _389;
	                    if ((_1244 & 1u) != 0u)
	                    {
	                        _389 = 1.0;
	                    }
	                    else
	                    {
	                        _389 = -1.0;
	                    }
	                    _427[0] = _403;
	                    _428[0].w = _389;
	                    _428[0].x = _402.x;
	                    _428[0].y = _402.y;
	                    _428[0].z = _402.z;
	                    vec2 _1333 = ((vec2(float(_288.x & 65535u), float((_288.x >> 16u) & 65535u)) * vec2(1.525902189314365386962890625e-05)) * 2.0) - vec2(1.0);
	                    float _1334 = _1333.x;
	                    float _1339 = (1.0 - abs(_1334)) - abs(_1333.y);
	                    vec3 _1340 = vec3(_1334, _1333.y, _1339);
	                    float _1342 = saturate(-_1339);
	                    vec2 _1348 = _1333 + mix(vec2(_1342), vec2(-_1342), greaterThanEqual(_1333, vec2(0.0)));
	                    _1340.x = _1348.x;
	                    _1340.y = _1348.y;
	                    vec3 _405 = normalize(_1340);
	                    vec2 _1355 = ((vec2(float((_288.y >> uint(1)) & 32767u), float((_288.y >> 16u) & 32767u)) * vec2(3.0518509447574615478515625e-05)) * 2.0) - vec2(1.0);
	                    float _1356 = _1355.x;
	                    float _1361 = (1.0 - abs(_1356)) - abs(_1355.y);
	                    vec3 _1362 = vec3(_1356, _1355.y, _1361);
	                    float _1364 = saturate(-_1361);
	                    vec2 _1370 = _1355 + mix(vec2(_1364), vec2(-_1364), greaterThanEqual(_1355, vec2(0.0)));
	                    _1362.x = _1370.x;
	                    _1362.y = _1370.y;
	                    vec3 _404 = normalize(_1362);
	                    float _388;
	                    if ((_288.y & 1u) != 0u)
	                    {
	                        _388 = 1.0;
	                    }
	                    else
	                    {
	                        _388 = -1.0;
	                    }
	                    _427[1] = _405;
	                    _428[1].w = _388;
	                    _428[1].x = _404.x;
	                    _428[1].y = _404.y;
	                    _428[1].z = _404.z;
	                    vec2 _1412 = ((vec2(float(_287.x & 65535u), float((_287.x >> 16u) & 65535u)) * vec2(1.525902189314365386962890625e-05)) * 2.0) - vec2(1.0);
	                    float _1413 = _1412.x;
	                    float _1418 = (1.0 - abs(_1413)) - abs(_1412.y);
	                    vec3 _1419 = vec3(_1413, _1412.y, _1418);
	                    float _1421 = saturate(-_1418);
	                    vec2 _1427 = _1412 + mix(vec2(_1421), vec2(-_1421), greaterThanEqual(_1412, vec2(0.0)));
	                    _1419.x = _1427.x;
	                    _1419.y = _1427.y;
	                    vec3 _407 = normalize(_1419);
	                    vec2 _1434 = ((vec2(float((_287.y >> uint(1)) & 32767u), float((_287.y >> 16u) & 32767u)) * vec2(3.0518509447574615478515625e-05)) * 2.0) - vec2(1.0);
	                    float _1435 = _1434.x;
	                    float _1440 = (1.0 - abs(_1435)) - abs(_1434.y);
	                    vec3 _1441 = vec3(_1435, _1434.y, _1440);
	                    float _1443 = saturate(-_1440);
	                    vec2 _1449 = _1434 + mix(vec2(_1443), vec2(-_1443), greaterThanEqual(_1434, vec2(0.0)));
	                    _1441.x = _1449.x;
	                    _1441.y = _1449.y;
	                    vec3 _406 = normalize(_1441);
	                    float _387;
	                    if ((_287.y & 1u) != 0u)
	                    {
	                        _387 = 1.0;
	                    }
	                    else
	                    {
	                        _387 = -1.0;
	                    }
	                    _427[2] = _407;
	                    _428[2].w = _387;
	                    _428[2].x = _406.x;
	                    _428[2].y = _406.y;
	                    _428[2].z = _406.z;
	                    break;
	                }
	                else
	                {
	                    uint _952 = _942.x / 4u;
	                    vec4 _409 = _428[0];
	                    float _967 = (float((g_Vertices_3[_61]._member0[_952] >> 12u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _970 = (float((g_Vertices_3[_61]._member0[_952] >> 22u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _974 = (1.0 - abs(_967)) - abs(_970);
	                    vec3 _975 = vec3(_967, _970, _974);
	                    float _977 = saturate(-_974);
	                    vec2 _978 = vec2(_967, _970);
	                    vec2 _984 = _978 + mix(vec2(_977), vec2(-_977), greaterThanEqual(_978, vec2(0.0)));
	                    _975.x = _984.x;
	                    _975.y = _984.y;
	                    vec3 _989 = normalize(_975);
	                    vec3 _408 = _989;
	                    float _990 = _989.z;
	                    float _396;
	                    if (_990 >= 0.0)
	                    {
	                        _396 = 1.0;
	                    }
	                    else
	                    {
	                        _396 = -1.0;
	                    }
	                    float _997 = (-1.0) / (_396 + _990);
	                    float _998 = _989.x;
	                    vec3 _397;
	                    vec3 _1006 = _397;
	                    _1006.x = 1.0 + (((_396 * _998) * _998) * _997);
	                    _1006.y = _396 * ((_998 * _989.y) * _997);
	                    _1006.z = (-_396) * _998;
	                    _397 = _1006;
	                    float _1014 = float((g_Vertices_3[_61]._member0[_952] >> uint(1)) & 2047u) * 0.003069460391998291015625;
	                    vec3 _1020 = (_1006 * cos(_1014)) + (cross(_989, _1006) * sin(_1014));
	                    vec4 _1022 = _409;
	                    _1022.x = _1020.x;
	                    _1022.y = _1020.y;
	                    _1022.z = _1020.z;
	                    _409 = _1022;
	                    float _398;
	                    if ((g_Vertices_3[_61]._member0[_952] & 1u) == 0u)
	                    {
	                        _398 = -1.0;
	                    }
	                    else
	                    {
	                        _398 = 1.0;
	                    }
	                    vec4 _1033 = _409;
	                    _1033.w = _398;
	                    _409 = _1033;
	                    _427[0] = _408;
	                    _428[0] = _1033;
	                    uint _1037 = _942.y / 4u;
	                    vec4 _411 = _428[1];
	                    float _1052 = (float((g_Vertices_3[_61]._member0[_1037] >> 12u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _1055 = (float((g_Vertices_3[_61]._member0[_1037] >> 22u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _1059 = (1.0 - abs(_1052)) - abs(_1055);
	                    vec3 _1060 = vec3(_1052, _1055, _1059);
	                    float _1062 = saturate(-_1059);
	                    vec2 _1063 = vec2(_1052, _1055);
	                    vec2 _1069 = _1063 + mix(vec2(_1062), vec2(-_1062), greaterThanEqual(_1063, vec2(0.0)));
	                    _1060.x = _1069.x;
	                    _1060.y = _1069.y;
	                    vec3 _1074 = normalize(_1060);
	                    vec3 _410 = _1074;
	                    float _1075 = _1074.z;
	                    float _393;
	                    if (_1075 >= 0.0)
	                    {
	                        _393 = 1.0;
	                    }
	                    else
	                    {
	                        _393 = -1.0;
	                    }
	                    float _1082 = (-1.0) / (_393 + _1075);
	                    float _1083 = _1074.x;
	                    vec3 _394;
	                    vec3 _1091 = _394;
	                    _1091.x = 1.0 + (((_393 * _1083) * _1083) * _1082);
	                    _1091.y = _393 * ((_1083 * _1074.y) * _1082);
	                    _1091.z = (-_393) * _1083;
	                    _394 = _1091;
	                    float _1099 = float((g_Vertices_3[_61]._member0[_1037] >> uint(1)) & 2047u) * 0.003069460391998291015625;
	                    vec3 _1105 = (_1091 * cos(_1099)) + (cross(_1074, _1091) * sin(_1099));
	                    vec4 _1107 = _411;
	                    _1107.x = _1105.x;
	                    _1107.y = _1105.y;
	                    _1107.z = _1105.z;
	                    _411 = _1107;
	                    float _395;
	                    if ((g_Vertices_3[_61]._member0[_1037] & 1u) == 0u)
	                    {
	                        _395 = -1.0;
	                    }
	                    else
	                    {
	                        _395 = 1.0;
	                    }
	                    vec4 _1118 = _411;
	                    _1118.w = _395;
	                    _411 = _1118;
	                    _427[1] = _410;
	                    _428[1] = _1118;
	                    uint _1122 = _942.z / 4u;
	                    vec4 _413 = _428[2];
	                    float _1137 = (float((g_Vertices_3[_61]._member0[_1122] >> 12u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _1140 = (float((g_Vertices_3[_61]._member0[_1122] >> 22u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _1144 = (1.0 - abs(_1137)) - abs(_1140);
	                    vec3 _1145 = vec3(_1137, _1140, _1144);
	                    float _1147 = saturate(-_1144);
	                    vec2 _1148 = vec2(_1137, _1140);
	                    vec2 _1154 = _1148 + mix(vec2(_1147), vec2(-_1147), greaterThanEqual(_1148, vec2(0.0)));
	                    _1145.x = _1154.x;
	                    _1145.y = _1154.y;
	                    vec3 _1159 = normalize(_1145);
	                    vec3 _412 = _1159;
	                    float _1160 = _1159.z;
	                    float _390;
	                    if (_1160 >= 0.0)
	                    {
	                        _390 = 1.0;
	                    }
	                    else
	                    {
	                        _390 = -1.0;
	                    }
	                    float _1167 = (-1.0) / (_390 + _1160);
	                    float _1168 = _1159.x;
	                    vec3 _391;
	                    vec3 _1176 = _391;
	                    _1176.x = 1.0 + (((_390 * _1168) * _1168) * _1167);
	                    _1176.y = _390 * ((_1168 * _1159.y) * _1167);
	                    _1176.z = (-_390) * _1168;
	                    _391 = _1176;
	                    float _1184 = float((g_Vertices_3[_61]._member0[_1122] >> uint(1)) & 2047u) * 0.003069460391998291015625;
	                    vec3 _1190 = (_1176 * cos(_1184)) + (cross(_1159, _1176) * sin(_1184));
	                    vec4 _1192 = _413;
	                    _1192.x = _1190.x;
	                    _1192.y = _1190.y;
	                    _1192.z = _1190.z;
	                    _413 = _1192;
	                    float _392;
	                    if ((g_Vertices_3[_61]._member0[_1122] & 1u) == 0u)
	                    {
	                        _392 = -1.0;
	                    }
	                    else
	                    {
	                        _392 = 1.0;
	                    }
	                    vec4 _1203 = _413;
	                    _1203.w = _392;
	                    _413 = _1203;
	                    _427[2] = _412;
	                    _428[2] = _1203;
	                    break;
	                }
	                break;
	            }
	        }
	        else
	        {
	            _427[0] = vec3(0.0);
	            _427[1] = vec3(0.0);
	            _427[2] = vec3(0.0);
	        }
	        if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTangentFieldInfo.y != 0)
	        {
	            ivec4 _414 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers;
	            uint _65 = uint(_414[g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTangentFieldInfo.z]);
	            uint _1526 = uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTangentFieldInfo.z);
	            ivec4 _385 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes;
	            ivec4 _386 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes;
	            uvec3 _1542 = (uvec3(uint(_385[_1526])) * _429) + uvec3(uint(_386[_1526]) + uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTangentFieldInfo.x));
	            uint _1544 = _1542.x;
	            _428[0] = vec4(g_Vertices_1[_65]._member0[_1544 / 4u], g_Vertices_1[_65]._member0[(_1544 + 4u) / 4u], g_Vertices_1[_65]._member0[(_1544 + 8u) / 4u], g_Vertices_1[_65]._member0[(_1544 + 12u) / 4u]);
	            uint _1562 = _1542.y;
	            _428[1] = vec4(g_Vertices_1[_65]._member0[_1562 / 4u], g_Vertices_1[_65]._member0[(_1562 + 4u) / 4u], g_Vertices_1[_65]._member0[(_1562 + 8u) / 4u], g_Vertices_1[_65]._member0[(_1562 + 12u) / 4u]);
	            uint _1580 = _1542.z;
	            _428[2] = vec4(g_Vertices_1[_65]._member0[_1580 / 4u], g_Vertices_1[_65]._member0[(_1580 + 4u) / 4u], g_Vertices_1[_65]._member0[(_1580 + 8u) / 4u], g_Vertices_1[_65]._member0[(_1580 + 12u) / 4u]);
	        }
	        else
	        {
	            _428[0] = vec4(0.0);
	            _428[1] = vec4(0.0);
	            _428[2] = vec4(0.0);
	        }
	        break;
	    } while(false);
	    _425 = 0;
	    for (;;)
	    {
	        if (!(_425 < 3))
	        {
	            break;
	        }
	        vsInput[_425].vNormalOs = _427[_425];
	        vsInput[_425].vTangentUOs_flTangentVSign = _428[_425];
	        _425++;
	        continue;
	    }
	    vec4 _431[3];
	    _431[0] = vec4(0.0);
	    _431[1] = vec4(0.0);
	    _431[2] = vec4(0.0);
	    if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[4].y != 0)
	    {
	        ivec4 _384 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers;
	        uint _67 = uint(_384[g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[4].z]);
	        uint _1638 = uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[4].z);
	        ivec4 _382 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes;
	        ivec4 _383 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes;
	        uvec3 _1654 = (uvec3(uint(_382[_1638])) * _429) + uvec3(uint(_383[_1638]) + uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[4].x));
	        if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[4].y == 2)
	        {
	            uint _1704 = _1654.x;
	            _431[0] = vec4(g_Vertices_1[_67]._member0[_1704 / 4u], g_Vertices_1[_67]._member0[(_1704 + 4u) / 4u], g_Vertices_1[_67]._member0[(_1704 + 8u) / 4u], g_Vertices_1[_67]._member0[(_1704 + 12u) / 4u]);
	            uint _1721 = _1654.y;
	            _431[1] = vec4(g_Vertices_1[_67]._member0[_1721 / 4u], g_Vertices_1[_67]._member0[(_1721 + 4u) / 4u], g_Vertices_1[_67]._member0[(_1721 + 8u) / 4u], g_Vertices_1[_67]._member0[(_1721 + 12u) / 4u]);
	            uint _1738 = _1654.z;
	            _431[2] = vec4(g_Vertices_1[_67]._member0[_1738 / 4u], g_Vertices_1[_67]._member0[(_1738 + 4u) / 4u], g_Vertices_1[_67]._member0[(_1738 + 8u) / 4u], g_Vertices_1[_67]._member0[(_1738 + 12u) / 4u]);
	        }
	        else
	        {
	            if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[4].y == 28)
	            {
	                uint _1663 = _1654.x / 4u;
	                _431[0] = vec4(uvec4(g_Vertices_3[_67]._member0[_1663] & 255u, (g_Vertices_3[_67]._member0[_1663] & 65280u) >> uint(8), (g_Vertices_3[_67]._member0[_1663] & 16711680u) >> uint(16), (g_Vertices_3[_67]._member0[_1663] & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	                uint _1677 = _1654.y / 4u;
	                _431[1] = vec4(uvec4(g_Vertices_3[_67]._member0[_1677] & 255u, (g_Vertices_3[_67]._member0[_1677] & 65280u) >> uint(8), (g_Vertices_3[_67]._member0[_1677] & 16711680u) >> uint(16), (g_Vertices_3[_67]._member0[_1677] & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	                uint _1691 = _1654.z / 4u;
	                _431[2] = vec4(uvec4(g_Vertices_3[_67]._member0[_1691] & 255u, (g_Vertices_3[_67]._member0[_1691] & 65280u) >> uint(8), (g_Vertices_3[_67]._member0[_1691] & 16711680u) >> uint(16), (g_Vertices_3[_67]._member0[_1691] & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	            }
	        }
	    }
	    int _432 = 0;
	    for (;;)
	    {
	        if (!(_432 < 3))
	        {
	            break;
	        }
	        vsInput[_432].vBlendValues = _431[_432];
	        _432++;
	        continue;
	    }
	    vec2 _299 = vsInput[0].vTexCoord;
	    vec4 _298 = vsInput[0].vBlendValues;
	    vec3 _380 = vsInput[0].vNormalOs;
	    vec4 _381;
	    vec4 _1782 = _381;
	    _1782.x = vsInput[0].vTangentUOs_flTangentVSign.x;
	    _1782.y = vsInput[0].vTangentUOs_flTangentVSign.y;
	    _1782.z = vsInput[0].vTangentUOs_flTangentVSign.z;
	    _1782.w = vsInput[0].vTangentUOs_flTangentVSign.w;
	    _381 = _1782;
	    PackedRtxInstanceData_t_natural_logical _1795;
	    _1795.nSrgbColor = g_instanceBuffer._member0[uint(gl_InstanceID)].nSrgbColor;
	    _1795.nTriangleGeometry = g_instanceBuffer._member0[uint(gl_InstanceID)].nTriangleGeometry;
	    _1795.nMaterialData = g_instanceBuffer._member0[uint(gl_InstanceID)].nMaterialData;
	    _1795.nMaterialFlags_nInstanceFlags = g_instanceBuffer._member0[uint(gl_InstanceID)].nMaterialFlags_nInstanceFlags;
	    _1795.fEmissiveBoost = g_instanceBuffer._member0[uint(gl_InstanceID)].fEmissiveBoost;
	    _1795.nInstanceFlags = g_instanceBuffer._member0[uint(gl_InstanceID)].nInstanceFlags;
	    _1795._pad1 = g_instanceBuffer._member0[uint(gl_InstanceID)]._pad1;
	    _1795._pad2 = g_instanceBuffer._member0[uint(gl_InstanceID)]._pad2;
	    vec4 _1806 = vec4(uvec4(_1795.nSrgbColor & 255u, (_1795.nSrgbColor & 65280u) >> uint(8), (_1795.nSrgbColor & 16711680u) >> uint(16), (_1795.nSrgbColor & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	    vec4 _379 = _1806;
	    vec3 _1807 = _1806.xyz;
	    vec3 _1808 = _1807 * vec3(0.077399380505084991455078125);
	    vec3 _1811 = pow((_1807 * vec3(0.947867333889007568359375)) + vec3(0.052132703363895416259765625), vec3(2.400000095367431640625));
	    float _376;
	    if (_1806.x <= 0.040449999272823333740234375)
	    {
	        _376 = _1808.x;
	    }
	    else
	    {
	        _376 = _1811.x;
	    }
	    float _377;
	    if (_1806.y <= 0.040449999272823333740234375)
	    {
	        _377 = _1808.y;
	    }
	    else
	    {
	        _377 = _1811.y;
	    }
	    float _378;
	    if (_1806.z <= 0.040449999272823333740234375)
	    {
	        _378 = _1808.z;
	    }
	    else
	    {
	        _378 = _1811.z;
	    }
	    vec3 _1836 = vec3(_376, _377, _378);
	    vec4 _1838 = _379;
	    _1838.x = _1836.x;
	    _1838.y = _1836.y;
	    _1838.z = _1836.z;
	    _379 = _1838;
	    vec4 _302;
	    vec4 _1845 = _302;
	    _1845.x = _1838.x;
	    _1845.y = _1838.y;
	    _1845.z = _1838.z;
	    _1845.w = _1838.w;
	    _302 = _1845;
	    mat3x4 _1856 = transpose(gl_WorldToObjectEXT);
	    mat3 _375;
	    mat3 _1859 = _375;
	    _1859[0] = _1856[0].xyz;
	    _1859[1] = _1856[1].xyz;
	    _1859[2] = _1856[2].xyz;
	    _375 = _1859;
	    vec3 _1868 = normalize(_1859 * _380.xyz);
	    vec3 _303;
	    vec3 _1870 = _303;
	    _1870.x = _1868.x;
	    _1870.y = _1868.y;
	    _1870.z = _1868.z;
	    _303 = _1870;
	    mat3x4 _1882 = transpose(gl_WorldToObjectEXT);
	    mat3 _374;
	    mat3 _1885 = _374;
	    _1885[0] = _1882[0].xyz;
	    _1885[1] = _1882[1].xyz;
	    _1885[2] = _1882[2].xyz;
	    _374 = _1885;
	    vec3 _1894 = normalize(_1885 * _381.xyz);
	    vec4 _301;
	    vec4 _1896 = _301;
	    _1896.x = _1894.x;
	    _1896.y = _1894.y;
	    _1896.z = _1894.z;
	    _1896.w = _381.w;
	    _301 = _1896;
	    vec4 _1905 = _299.xyxy;
	    vec4 _304;
	    vec4 _1906 = _304;
	    vec4 _1919 = _1905;
	    _1919.x = dot(_1905.xy, _346.xy) + _346.w;
	    _1919.y = dot(_1905.xy, _345.xy) + _345.w;
	    vec2 _1927 = _1919.xy + (_344.xy * PerViewConstantBuffer_t.g_flGameTime);
	    vec4 _1929 = _1919;
	    _1929.x = _1927.x;
	    _1929.y = _1927.y;
	    vec3 _1935 = mix(vec3(1.0), _1845.xyz, vec3(_342));
	    vec4 _1937 = _1845;
	    _1937.x = _1935.x;
	    _1937.y = _1935.y;
	    _1937.z = _1935.z;
	    vec3 _1945 = _1937.xyz * _343.xyz;
	    vec4 _1947 = _1937;
	    _1947.x = _1945.x;
	    _1947.y = _1945.y;
	    _1947.z = _1945.z;
	    _1906.x = _298.x;
	    _1906.y = _298.y;
	    _1906.z = _298.z;
	    _1906.w = max(_298.w, 0.100000001490116119384765625);
	    vec4 _286 = _1906;
	    vec3 _285 = vec4(vsInput[0].vPositionOs.xyz, 1.0) * transpose(gl_ObjectToWorldEXT);
	    vec3 _284 = _1870;
	    vec4 _283 = _1929;
	    vec4 _282 = _1947;
	    vec4 _281 = _1896;
	    vec2 _297 = vsInput[1].vTexCoord;
	    vec4 _296 = vsInput[1].vBlendValues;
	    vec3 _372 = vsInput[1].vNormalOs;
	    vec4 _373;
	    vec4 _1970 = _373;
	    _1970.x = vsInput[1].vTangentUOs_flTangentVSign.x;
	    _1970.y = vsInput[1].vTangentUOs_flTangentVSign.y;
	    _1970.z = vsInput[1].vTangentUOs_flTangentVSign.z;
	    _1970.w = vsInput[1].vTangentUOs_flTangentVSign.w;
	    _373 = _1970;
	    PackedRtxInstanceData_t_natural_logical _1983;
	    _1983.nSrgbColor = g_instanceBuffer._member0[uint(gl_InstanceID)].nSrgbColor;
	    _1983.nTriangleGeometry = g_instanceBuffer._member0[uint(gl_InstanceID)].nTriangleGeometry;
	    _1983.nMaterialData = g_instanceBuffer._member0[uint(gl_InstanceID)].nMaterialData;
	    _1983.nMaterialFlags_nInstanceFlags = g_instanceBuffer._member0[uint(gl_InstanceID)].nMaterialFlags_nInstanceFlags;
	    _1983.fEmissiveBoost = g_instanceBuffer._member0[uint(gl_InstanceID)].fEmissiveBoost;
	    _1983.nInstanceFlags = g_instanceBuffer._member0[uint(gl_InstanceID)].nInstanceFlags;
	    _1983._pad1 = g_instanceBuffer._member0[uint(gl_InstanceID)]._pad1;
	    _1983._pad2 = g_instanceBuffer._member0[uint(gl_InstanceID)]._pad2;
	    vec4 _1994 = vec4(uvec4(_1983.nSrgbColor & 255u, (_1983.nSrgbColor & 65280u) >> uint(8), (_1983.nSrgbColor & 16711680u) >> uint(16), (_1983.nSrgbColor & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	    vec4 _371 = _1994;
	    vec3 _1995 = _1994.xyz;
	    vec3 _1996 = _1995 * vec3(0.077399380505084991455078125);
	    vec3 _1999 = pow((_1995 * vec3(0.947867333889007568359375)) + vec3(0.052132703363895416259765625), vec3(2.400000095367431640625));
	    float _368;
	    if (_1994.x <= 0.040449999272823333740234375)
	    {
	        _368 = _1996.x;
	    }
	    else
	    {
	        _368 = _1999.x;
	    }
	    float _369;
	    if (_1994.y <= 0.040449999272823333740234375)
	    {
	        _369 = _1996.y;
	    }
	    else
	    {
	        _369 = _1999.y;
	    }
	    float _370;
	    if (_1994.z <= 0.040449999272823333740234375)
	    {
	        _370 = _1996.z;
	    }
	    else
	    {
	        _370 = _1999.z;
	    }
	    vec3 _2024 = vec3(_368, _369, _370);
	    vec4 _2026 = _371;
	    _2026.x = _2024.x;
	    _2026.y = _2024.y;
	    _2026.z = _2024.z;
	    _371 = _2026;
	    vec4 _306;
	    vec4 _2033 = _306;
	    _2033.x = _2026.x;
	    _2033.y = _2026.y;
	    _2033.z = _2026.z;
	    _2033.w = _2026.w;
	    _306 = _2033;
	    mat3x4 _2044 = transpose(gl_WorldToObjectEXT);
	    mat3 _367;
	    mat3 _2047 = _367;
	    _2047[0] = _2044[0].xyz;
	    _2047[1] = _2044[1].xyz;
	    _2047[2] = _2044[2].xyz;
	    _367 = _2047;
	    vec3 _2056 = normalize(_2047 * _372.xyz);
	    vec3 _307;
	    vec3 _2058 = _307;
	    _2058.x = _2056.x;
	    _2058.y = _2056.y;
	    _2058.z = _2056.z;
	    _307 = _2058;
	    mat3x4 _2070 = transpose(gl_WorldToObjectEXT);
	    mat3 _366;
	    mat3 _2073 = _366;
	    _2073[0] = _2070[0].xyz;
	    _2073[1] = _2070[1].xyz;
	    _2073[2] = _2070[2].xyz;
	    _366 = _2073;
	    vec3 _2082 = normalize(_2073 * _373.xyz);
	    vec4 _305;
	    vec4 _2084 = _305;
	    _2084.x = _2082.x;
	    _2084.y = _2082.y;
	    _2084.z = _2082.z;
	    _2084.w = _373.w;
	    _305 = _2084;
	    vec4 _2093 = _297.xyxy;
	    vec4 _308;
	    vec4 _2094 = _308;
	    vec4 _2107 = _2093;
	    _2107.x = dot(_2093.xy, _346.xy) + _346.w;
	    _2107.y = dot(_2093.xy, _345.xy) + _345.w;
	    vec2 _2115 = _2107.xy + (_344.xy * PerViewConstantBuffer_t.g_flGameTime);
	    vec4 _2117 = _2107;
	    _2117.x = _2115.x;
	    _2117.y = _2115.y;
	    vec3 _2123 = mix(vec3(1.0), _2033.xyz, vec3(_342));
	    vec4 _2125 = _2033;
	    _2125.x = _2123.x;
	    _2125.y = _2123.y;
	    _2125.z = _2123.z;
	    vec3 _2133 = _2125.xyz * _343.xyz;
	    vec4 _2135 = _2125;
	    _2135.x = _2133.x;
	    _2135.y = _2133.y;
	    _2135.z = _2133.z;
	    _2094.x = _296.x;
	    _2094.y = _296.y;
	    _2094.z = _296.z;
	    _2094.w = max(_296.w, 0.100000001490116119384765625);
	    vec4 _280 = _2094;
	    vec3 _279 = vec4(vsInput[1].vPositionOs.xyz, 1.0) * transpose(gl_ObjectToWorldEXT);
	    vec3 _278 = _2058;
	    vec4 _277 = _2117;
	    vec4 _276 = _2135;
	    vec4 _275 = _2084;
	    vec2 _295 = vsInput[2].vTexCoord;
	    vec4 _294 = vsInput[2].vBlendValues;
	    vec3 _364 = vsInput[2].vNormalOs;
	    vec4 _365;
	    vec4 _2158 = _365;
	    _2158.x = vsInput[2].vTangentUOs_flTangentVSign.x;
	    _2158.y = vsInput[2].vTangentUOs_flTangentVSign.y;
	    _2158.z = vsInput[2].vTangentUOs_flTangentVSign.z;
	    _2158.w = vsInput[2].vTangentUOs_flTangentVSign.w;
	    _365 = _2158;
	    PackedRtxInstanceData_t_natural_logical _2171;
	    _2171.nSrgbColor = g_instanceBuffer._member0[uint(gl_InstanceID)].nSrgbColor;
	    _2171.nTriangleGeometry = g_instanceBuffer._member0[uint(gl_InstanceID)].nTriangleGeometry;
	    _2171.nMaterialData = g_instanceBuffer._member0[uint(gl_InstanceID)].nMaterialData;
	    _2171.nMaterialFlags_nInstanceFlags = g_instanceBuffer._member0[uint(gl_InstanceID)].nMaterialFlags_nInstanceFlags;
	    _2171.fEmissiveBoost = g_instanceBuffer._member0[uint(gl_InstanceID)].fEmissiveBoost;
	    _2171.nInstanceFlags = g_instanceBuffer._member0[uint(gl_InstanceID)].nInstanceFlags;
	    _2171._pad1 = g_instanceBuffer._member0[uint(gl_InstanceID)]._pad1;
	    _2171._pad2 = g_instanceBuffer._member0[uint(gl_InstanceID)]._pad2;
	    vec4 _2182 = vec4(uvec4(_2171.nSrgbColor & 255u, (_2171.nSrgbColor & 65280u) >> uint(8), (_2171.nSrgbColor & 16711680u) >> uint(16), (_2171.nSrgbColor & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	    vec4 _363 = _2182;
	    vec3 _2183 = _2182.xyz;
	    vec3 _2184 = _2183 * vec3(0.077399380505084991455078125);
	    vec3 _2187 = pow((_2183 * vec3(0.947867333889007568359375)) + vec3(0.052132703363895416259765625), vec3(2.400000095367431640625));
	    float _360;
	    if (_2182.x <= 0.040449999272823333740234375)
	    {
	        _360 = _2184.x;
	    }
	    else
	    {
	        _360 = _2187.x;
	    }
	    float _361;
	    if (_2182.y <= 0.040449999272823333740234375)
	    {
	        _361 = _2184.y;
	    }
	    else
	    {
	        _361 = _2187.y;
	    }
	    float _362;
	    if (_2182.z <= 0.040449999272823333740234375)
	    {
	        _362 = _2184.z;
	    }
	    else
	    {
	        _362 = _2187.z;
	    }
	    vec3 _2212 = vec3(_360, _361, _362);
	    vec4 _2214 = _363;
	    _2214.x = _2212.x;
	    _2214.y = _2212.y;
	    _2214.z = _2212.z;
	    _363 = _2214;
	    vec4 _310;
	    vec4 _2221 = _310;
	    _2221.x = _2214.x;
	    _2221.y = _2214.y;
	    _2221.z = _2214.z;
	    _2221.w = _2214.w;
	    _310 = _2221;
	    mat3x4 _2232 = transpose(gl_WorldToObjectEXT);
	    mat3 _359;
	    mat3 _2235 = _359;
	    _2235[0] = _2232[0].xyz;
	    _2235[1] = _2232[1].xyz;
	    _2235[2] = _2232[2].xyz;
	    _359 = _2235;
	    vec3 _2244 = normalize(_2235 * _364.xyz);
	    vec3 _311;
	    vec3 _2246 = _311;
	    _2246.x = _2244.x;
	    _2246.y = _2244.y;
	    _2246.z = _2244.z;
	    _311 = _2246;
	    vec3 _2254 = vec4(vsInput[2].vPositionOs.xyz, 1.0) * transpose(gl_ObjectToWorldEXT);
	    mat3x4 _2258 = transpose(gl_WorldToObjectEXT);
	    mat3 _358;
	    mat3 _2261 = _358;
	    _2261[0] = _2258[0].xyz;
	    _2261[1] = _2258[1].xyz;
	    _2261[2] = _2258[2].xyz;
	    _358 = _2261;
	    vec3 _2270 = normalize(_2261 * _365.xyz);
	    vec4 _309;
	    vec4 _2272 = _309;
	    _2272.x = _2270.x;
	    _2272.y = _2270.y;
	    _2272.z = _2270.z;
	    _2272.w = _365.w;
	    _309 = _2272;
	    vec4 _2281 = _295.xyxy;
	    vec4 _312;
	    vec4 _2282 = _312;
	    vec4 _2295 = _2281;
	    _2295.x = dot(_2281.xy, _346.xy) + _346.w;
	    _2295.y = dot(_2281.xy, _345.xy) + _345.w;
	    vec2 _2303 = _2295.xy + (_344.xy * PerViewConstantBuffer_t.g_flGameTime);
	    vec4 _2305 = _2295;
	    _2305.x = _2303.x;
	    _2305.y = _2303.y;
	    vec3 _2311 = mix(vec3(1.0), _2221.xyz, vec3(_342));
	    vec4 _2313 = _2221;
	    _2313.x = _2311.x;
	    _2313.y = _2311.y;
	    _2313.z = _2311.z;
	    vec3 _2321 = _2313.xyz * _343.xyz;
	    vec4 _2323 = _2313;
	    _2323.x = _2321.x;
	    _2323.y = _2321.y;
	    _2323.z = _2321.z;
	    _2282.x = _294.x;
	    _2282.y = _294.y;
	    _2282.z = _294.z;
	    _2282.w = max(_294.w, 0.100000001490116119384765625);
	    vec3 _274 = _2254;
	    vec3 _273 = _2246;
	    vec3 _2360 = ((_284 * ((1.0 - attrs.barycentrics.x) - attrs.barycentrics.y)) + (_278 * attrs.barycentrics.x)) + (_2246 * attrs.barycentrics.y);
	    vec3 _313;
	    vec4 _293 = ((_286 * ((1.0 - attrs.barycentrics.x) - attrs.barycentrics.y)) + (_280 * attrs.barycentrics.x)) + (_2282 * attrs.barycentrics.y);
	    vec3 _292 = _2360;
	    vec4 _291 = ((_283 * ((1.0 - attrs.barycentrics.x) - attrs.barycentrics.y)) + (_277 * attrs.barycentrics.x)) + (_2305 * attrs.barycentrics.y);
	    vec4 _290 = ((_282 * ((1.0 - attrs.barycentrics.x) - attrs.barycentrics.y)) + (_276 * attrs.barycentrics.x)) + (_2323 * attrs.barycentrics.y);
	    vec4 _289 = ((_281 * ((1.0 - attrs.barycentrics.x) - attrs.barycentrics.y)) + (_275 * attrs.barycentrics.x)) + (_2272 * attrs.barycentrics.y);
	    vec3 _316 = _313;
	    vec3 _315 = normalize(cross(_279 - _285, _2254 - _285));
	    vec2 _330 = vec2(0.5);
	    vec3 _329 = vec3(0.0);
	    vec3 _328 = vec3(0.0);
	    bool _326 = false;
	    vec3 _2402 = _2360.xyz;
	    vec3 _327 = _2402;
	    if (dot(_2402, _2402) >= 1.0099999904632568359375)
	    {
	        _327 = _316.xyz;
	    }
	    vec3 _2411 = _327;
	    vec3 _2412 = normalize(_2411);
	    _327 = _2412;
	    vec2 _2416 = _330;
	    vec3 _322 = _329;
	    float _321 = _331;
	    vec3 _320 = _328;
	    vec3 _319 = _2412;
	    vec3 _318 = _315;
	    bool _317 = _326;
	    vec2 _2431 = (_291.xy * _337.xy).xy;
	    vec4 _2452 = textureLod(sampler2D(g_bindless_Texture2D_float4[_332], g_bindless_Sampler[_341]), _2431, 0.0);
	    float _2453 = _2452.x;
	    float _2462 = smoothstep(max(0.0, _2453 - _293.w), min(1.0, _2453 + _293.w), _293.x);
	    vec3 _2466 = textureLod(sampler2D(g_bindless_Texture2D_float4[_336], g_bindless_Sampler[_340]), _291.xy, 0.0).xyzw.xyz * _290.xyz;
	    vec4 _2468;
	    _2468.x = _2466.x;
	    _2468.y = _2466.y;
	    _2468.z = _2466.z;
	    vec3 _2475 = textureLod(sampler2D(g_bindless_Texture2D_float4[_335], g_bindless_Sampler[_340]), _2431, 0.0).xyzw.xyz * _290.xyz;
	    vec4 _2477;
	    _2477.x = _2475.x;
	    _2477.y = _2475.y;
	    _2477.z = _2475.z;
	    vec4 _2489 = mix(textureLod(sampler2D(g_bindless_Texture2D_float4[_334], g_bindless_Sampler[_340]), _291.xy, 0.0).xyzw, textureLod(sampler2D(g_bindless_Texture2D_float4[_333], g_bindless_Sampler[_340]), _2431, 0.0).xyzw, vec4(_2462));
	    vec3 _325 = mix(_2468.xyz, _2477.xyz, vec3(_2462)).xyz;
	    float _323 = mix(_339, _338, _2462);
	    _2416.x = _2489.z;
	    _2416.y = _2489.z;
	    vec2 _324 = _2416;
	    float _2500 = _2489.x;
	    float _2501 = _2489.y;
	    float _2503 = (_2500 + _2501) - 1.00392162799835205078125;
	    float _2504 = _2500 - _2501;
	    vec4 _314 = _289;
	    vec3 _356 = normalize(vec3(vec2(_2503, _2504), (1.0 - abs(_2503)) - abs(_2504)));
	    float _357;
	    if (false)
	    {
	        _357 = -1.0;
	    }
	    else
	    {
	        _357 = 1.0;
	    }
	    float _2516 = _357;
	    vec3 _2517 = _292.xyz * _2516;
	    if (_314.w > 0.0)
	    {
	        _357 = 1.0;
	    }
	    else
	    {
	        _357 = -1.0;
	    }
	    if (!false)
	    {
	        vec3 _2532 = _356;
	        _2532.y = -_2532.y;
	        _356 = _2532;
	    }
	    vec3 _2539 = _314.xyz * _356.x;
	    vec3 _355;
	    vec3 _2541 = _355;
	    _2541.x = _2539.x;
	    _2541.y = _2539.y;
	    _2541.z = _2539.z;
	    vec3 _2551 = _2541.xyz + ((cross(_2517.xyz, _314.xyz) * _357).xyz * _356.y);
	    vec3 _2553 = _2541;
	    _2553.x = _2551.x;
	    _2553.y = _2551.y;
	    _2553.z = _2551.z;
	    vec3 _2562 = _2553.xyz + (_2517.xyz * _356.z);
	    vec3 _2564 = _2553;
	    _2564.x = _2562.x;
	    _2564.y = _2562.y;
	    _2564.z = _2562.z;
	    _355 = _2564;
	    payload.nInstance = int(uint(gl_InstanceID));
	    payload.flHitT = gl_RayTmaxEXT;
	    payload.vFaceNormalWs = _318;
	    payload.vInterpolatedNormalWs = _319;
	    vec3 _353[3] = vec3[](_285, _279, _274);
	    vec3 _354[3] = vec3[](_284, _278, _273);
	    vec3 _2611 = ((_353[0] * ((1.0 - attrs.barycentrics.x) - attrs.barycentrics.y)) + (_353[1] * attrs.barycentrics.x)) + (_353[2] * attrs.barycentrics.y);
	    vec3 _347[3];
	    _347[0] = _2611 - (_354[0] * dot(_2611 - _353[0], _354[0]));
	    _347[1] = _2611 - (_354[1] * dot(_2611 - _353[1], _354[1]));
	    _347[2] = _2611 - (_354[2] * dot(_2611 - _353[2], _354[2]));
	    vec3 _2651 = ((_347[0] * ((1.0 - attrs.barycentrics.x) - attrs.barycentrics.y)) + (_347[1] * attrs.barycentrics.x)) + (_347[2] * attrs.barycentrics.y);
	    vec3 _348[3];
	    _348[0] = cross(_353[0] - _353[1], _318);
	    _348[1] = cross(_353[1] - _353[2], _318);
	    _348[2] = cross(_353[2] - _353[0], _318);
	    float _349 = dot(_2651 - _2611, _318);
	    vec3 _350 = _2651;
	    int _351 = 0;
	    for (;;)
	    {
	        bool _2667_ladder_break = false;
	        do
	        {
	            if (!(_351 < 3))
	            {
	                _2667_ladder_break = true;
	                break;
	            }
	            if (_349 > 0.00999999977648258209228515625)
	            {
	                _2667_ladder_break = true;
	                break;
	            }
	            if (dot(_348[_351], _348[_351]) == 0.0)
	            {
	                break;
	            }
	            _348[_351] = normalize(_348[_351]);
	            int _352 = 0;
	            for (;;)
	            {
	                if (!(_352 < 3))
	                {
	                    break;
	                }
	                vec3 _2705 = _354[_352] - (_348[_351] * dot(_348[_351], _354[_352]));
	                _347[_352] = _2611 - (_2705 * dot(_2611 - _353[_352], _2705));
	                _352++;
	                continue;
	            }
	            vec3 _2729 = ((_347[0] * ((1.0 - attrs.barycentrics.x) - attrs.barycentrics.y)) + (_347[1] * attrs.barycentrics.x)) + (_347[2] * attrs.barycentrics.y);
	            _349 = dot(_2729 - _2611, _318);
	            _350 = _2729;
	            break;
	        } while(false);
	        if (_2667_ladder_break)
	        {
	            break;
	        }
	        _351++;
	        continue;
	    }
	    if (!(_349 > 0.00999999977648258209228515625))
	    {
	        _350 = vec3(3.4028234663852885981170418348452e+38);
	    }
	    payload.vSmoothPositionWs = _350;
	    payload.bFlippedNormal = _317;
	    f16vec3 _2742 = f16vec3(vec3(0.0));
	    payload.material = MaterialDataMinimal_t(_2742, float16_t(0.0), f16vec3(vec3(1.0, 0.0, 1.0)), float16_t(1.0), _2742, float16_t(0.040008544921875), 0u, f16vec4(ivec4(0)));
	    payload.material.vNormalWs = f16vec3(normalize(_2564.xyz));
	    payload.material.vAlbedo = f16vec3(_325);
	    payload.material.vEmissive = f16vec3(_322);
	    payload.material.flReflectance = float16_t(_321);
	    payload.material.flMetalness = float16_t(_323);
	    payload.material.flRoughness = float16_t(dot(_324, vec2(0.5)));
	    if (any(greaterThan(_320, vec3(0.0))))
	    {
	        payload.material.nMaterialTypeAndFlags = (payload.material.nMaterialTypeAndFlags & 4294901760u) | 1u;
	        f16vec3 _2768 = f16vec3(_320);
	        payload.material.vMaterialBits.x = _2768.x;
	        payload.material.vMaterialBits.y = _2768.y;
	        payload.material.vMaterialBits.z = _2768.z;
	    }
	}
	
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
	
	BoolAttribute(BindlessResources, true);
	IntAttribute(RayTypeCount, 2);
	BoolAttribute(CanBatchWithDynamicShaderConstants, true);
	IntAttribute(TexCoordScaleByModelU, g_nScaleTexCoordUByModelScaleAxis-1);
	IntAttribute(TexCoordScaleByModelV, g_nScaleTexCoordVByModelScaleAxis-1);
	Float3Attribute(LightSim_MaterialTint, g_vColorTint);
	BoolAttribute(VertexPaintUI2Layer, true);
	BoolAttribute(VertexPaintUIAlphaBlendFactor, true);
	BoolAttribute(SupportsAggregateInstancing, true);
	BoolAttribute(SupportsLightmapping, true);
	BoolAttribute(PerVertexLighting, true);
	BoolAttribute(AllowBackfaceCulling, F_RENDER_BACKFACES ? 0 : 1);
	TextureAttribute(LightSim_DiffuseAlbedoTexture, g_tColorA);
	TextureAttribute(RepresentativeTexture, g_tColorA);
	BoolAttribute(NeedsLightProbe, true);
	BoolAttribute(NoZPrepass, F_DISABLE_Z_PREPASS || 0);
	BoolAttribute(DoNotCastShadows, F_DO_NOT_CAST_SHADOWS || 0);
	BoolAttribute(SupportsMappingDimensions, true);
	BoolAttribute(renderbackfaces, F_RENDER_BACKFACES || 0);
	
	#if (S_PAINT_VERTEX_COLORS == 0)
		TextureAttribute(LightSim_TintMaskTextureR, g_tTintMask);
	#endif
	#if (S_PAINT_VERTEX_COLORS == 1)
		BoolAttribute(VertexPaintUIPickColor, true);
	#endif
	#if (S_ENABLE_TINT_MASKS == 0)
		BoolAttribute(VertexPaintUIPickColor, true);
	#endif
	#if (S_MODE_TOOLS_VIS == 0)
		BoolAttribute(VertexPaintUIPickColor, true);
		TextureAttribute(LightSim_TintMaskTextureR, g_tTintMask);
	#endif
	#if (S_ENABLE_TINT_MASKS == 1)
		TextureAttribute(LightSim_TintMaskTextureR, g_tTintMask);
	#endif
	#if (S_SHADER_QUALITY == 0)
		BoolAttribute(VertexPaintUIPickColor, true);
		TextureAttribute(LightSim_TintMaskTextureR, g_tTintMask);
	#endif
}
