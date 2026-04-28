//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "Simple 2-way blending shader";
	DevShader = false;
	Version = 1;
	
	// VcsVersion: 70
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
	ByteAddressBuffer g_animatedVertexCache < Attribute("AnimatedVertexCache"); SrgbRead(false); >;
	bool g_bTexCoordScaleByModel < UiType(CheckBox); Expression((g_nScaleTexCoordUByModelScaleAxis!=0) || (g_nScaleTexCoordVByModelScaleAxis!=0)); >;
	ExternalDescriptorSet g_globalLateBoundBindlessSet < Source(ExternalDescSet); Attribute("g_globalLateBoundBindlessSet"); >;
	StructuredBuffer g_instanceBuffer < Attribute("InstanceBuffer"); SrgbRead(false); >;
	ExternalDescriptorSet g_lightBinnerGpuSet < Source(ExternalDescSet); Attribute("g_lightBinnerGpuSet"); >;
	StructuredBuffer g_transformBuffer < Attribute("TransformBuffer"); SrgbRead(false); >;
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
	// SPIR-V source (7620 bytes), GLSL reflection with SPIRV-Cross by KhronosGroup
	
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
	
	struct _2032
	{
	    vec4 _m0[3];
	};
	
	struct _2012
	{
	    _2032 _m0;
	};
	
	struct _533
	{
	    vec4 _m0[4];
	};
	
	layout(set = 4, binding = 32, std430) readonly buffer g_instanceBuffer
	{
	    _1125 _m0[];
	} g_instanceBuffer_1;
	
	layout(set = 4, binding = 30, std430) readonly buffer g_transformBuffer
	{
	    _2012 _m0[];
	} g_transformBuffer_1;
	
	struct _2124
	{
	    _533 _m0;
	    float _m1;
	    vec4 _m2;
	};
	
	layout(set = 0) uniform _2124 PerViewConstantBuffer_t;
	
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
	    float _9851 = _23812.w;
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
	    vec4 _11399 = vec4(mix(vec3(1.0), vec4(_21354, _21355, _14124, _9851).xyz, vec3(_Globals_.g_flModelTintAmount)), _9851 * g_instanceBuffer_1._m0[nInstanceIdx]._m7);
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
	    output_6 = vec4(normalize(vec4(vTangentUOs_flTangentVSign.xyz, 0.0) * _17839), vTangentUOs_flTangentVSign.w);
	    output_7 = (g_instanceBuffer_1._m0[nInstanceIdx]._m5) & 65535u;
	    _23875.y = -_23875.y;
	    gl_Position = _23875;
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
	StructuredBuffer g_BarnLights < Attribute("BarnLights"); SrgbRead(false); >;
	StructuredBuffer g_CullBits < Attribute("CullBits"); SrgbRead(false); >;
	bool g_bCubemapNormalization < Attribute("g_bCubemapNormalization"); UiType(CheckBox); >;
	bool g_bDisableNormalMapping < Attribute("g_bDisableNormalMapping"); UiType(CheckBox); >;
	bool g_bHighlightDeprecated < Attribute("g_bHighlightDeprecated"); UiType(CheckBox); >;
	bool g_bIsDeprecated < Attribute("bIsDeprecated"); UiType(CheckBox); >;
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
	#endif
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (40532 bytes), HLSL reflection with SPIRV-Cross by KhronosGroup
	
	struct _2284
	{
	    float4 _m0[4];
	};
	
	struct _2074
	{
	    float4 _m0[3];
	};
	
	struct _2285
	{
	    float4 _m0[4];
	};
	
	struct _2075
	{
	    float4 _m0[3];
	};
	
	struct _265
	{
	    _2284 _m0[4];
	};
	
	struct _123
	{
	    _2284 _m0;
	    _2284 _m1;
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
	    _2075 _m15;
	    float4 _m16;
	    float4 _m17;
	    float4 _m18;
	    float4 _m19;
	    float4 _m20;
	    float3 _m21;
	    float _m22;
	    _2284 _m23;
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
	    _2284 PerViewConstantBufferCsgo_t_1_m8 : packoffset(c12);
	    float2 PerViewConstantBufferCsgo_t_1_m9 : packoffset(c16);
	    float PerViewConstantBufferCsgo_t_1_m10 : packoffset(c16.z);
	    float4 PerViewConstantBufferCsgo_t_1_m11 : packoffset(c23);
	    float4 PerViewConstantBufferCsgo_t_1_m12 : packoffset(c24);
	    float4 PerViewConstantBufferCsgo_t_1_m13 : packoffset(c25);
	    float4 PerViewConstantBufferCsgo_t_1_m14 : packoffset(c26);
	    float4 PerViewConstantBufferCsgo_t_1_m15 : packoffset(c27);
	    float4 PerViewConstantBufferCsgo_t_1_m16 : packoffset(c28);
	    _2284 PerViewConstantBufferCsgo_t_1_m17 : packoffset(c29);
	    float4 PerViewConstantBufferCsgo_t_1_m18 : packoffset(c33);
	    float4 PerViewConstantBufferCsgo_t_1_m19 : packoffset(c34);
	    float4 PerViewConstantBufferCsgo_t_1_m20 : packoffset(c35);
	};
	
	cbuffer PerViewLightingConstantBufferGpu_t : register(b0, space3)
	{
	    _2074 PerViewLightingConstantBufferGpu_t_1_m0 : packoffset(c7);
	    _2285 PerViewLightingConstantBufferGpu_t_1_m1 : packoffset(c11);
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
	    _265 PerViewLightingConstantBufferGpu_t_1_m18 : packoffset(c1956);
	    _2285 PerViewLightingConstantBufferGpu_t_1_m19 : packoffset(c1988);
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
	SamplerState undetermined[2048] : register(s29, space4);
	SamplerComparisonState undetermined_1[2048] : register(s29, space4);
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
	    float4 _21762 = g_bindless_Texture2D_float4[_Globals_1_g_tNormalA].Sample(undetermined[_Globals_1_g_sUserConfig], input_3.xy);
	    float4 _21763 = g_bindless_Texture2D_float4[_Globals_1_g_tNormalB].Sample(undetermined[_Globals_1_g_sUserConfig], _11085);
	    float4 _19372 = g_bindless_Texture2D_float4[_Globals_1_g_tMask].Sample(undetermined[_Globals_1_g_sTrilinearWrap], _11085);
	    float _16038 = _19372.x;
	    float _24575 = smoothstep(max(0.0f, _16038 - input_0.w), min(1.0f, _16038 + input_0.w), input_0.x);
	    float3 _21122 = g_bindless_Texture2D_float4[_Globals_1_g_tColorA].Sample(undetermined[_Globals_1_g_sUserConfig], input_3.xy).xyz * input_4.xyz;
	    float4 _23714;
	    _23714.x = _21122.x;
	    _23714.y = _21122.y;
	    _23714.z = _21122.z;
	    float3 _20313 = g_bindless_Texture2D_float4[_Globals_1_g_tColorB].Sample(undetermined[_Globals_1_g_sUserConfig], _11085).xyz * input_4.xyz;
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
	        float4 _18418 = g_bindless_Texture2D_float4[PerViewConstantBufferCsgo_t_1_m5].GatherRed(undetermined[_Globals_1_g_sCookieSampler], _11086).xyzw - _11408.zzzz;
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
	        _21710 = (1.0f / (dot(_13232, 1.0f.xxxx) + PerViewLightingConstantBufferGpu_t_1_m3.x)) * (PerViewLightingConstantBufferGpu_t_1_m3.x + dot(_13232, g_bindless_Texture2D_float4[PerViewConstantBufferCsgo_t_1_m4].SampleLevel(undetermined[_Globals_1_g_sPointClamp], (_11086 + float2(_13083.x ? PerViewConstantBufferCsgo_t_1_m9.xy.x : _23169.x, _13083.y ? PerViewConstantBufferCsgo_t_1_m9.xy.y : _23169.y).xy).xy, 0.0f)));
	    }
	    else
	    {
	        _21710 = 1.0f;
	    }
	    float _21711;
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
	            float4 _18322 = mul(float4x4(float4(PerViewLightingConstantBufferGpu_t_1_m18._m0[_13039]._m0[0].x, PerViewLightingConstantBufferGpu_t_1_m18._m0[_13039]._m0[1].x, PerViewLightingConstantBufferGpu_t_1_m18._m0[_13039]._m0[2].x, PerViewLightingConstantBufferGpu_t_1_m18._m0[_13039]._m0[3].x), float4(PerViewLightingConstantBufferGpu_t_1_m18._m0[_13039]._m0[0].y, PerViewLightingConstantBufferGpu_t_1_m18._m0[_13039]._m0[1].y, PerViewLightingConstantBufferGpu_t_1_m18._m0[_13039]._m0[2].y, PerViewLightingConstantBufferGpu_t_1_m18._m0[_13039]._m0[3].y), float4(PerViewLightingConstantBufferGpu_t_1_m18._m0[_13039]._m0[0].z, PerViewLightingConstantBufferGpu_t_1_m18._m0[_13039]._m0[1].z, PerViewLightingConstantBufferGpu_t_1_m18._m0[_13039]._m0[2].z, PerViewLightingConstantBufferGpu_t_1_m18._m0[_13039]._m0[3].z), float4(PerViewLightingConstantBufferGpu_t_1_m18._m0[_13039]._m0[0].w, PerViewLightingConstantBufferGpu_t_1_m18._m0[_13039]._m0[1].w, PerViewLightingConstantBufferGpu_t_1_m18._m0[_13039]._m0[2].w, PerViewLightingConstantBufferGpu_t_1_m18._m0[_13039]._m0[3].w)), float4(input_1.xyz, 1.0f));
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
	            float _18270 = g_bindless_Texture2D_float4[PerViewLightingConstantBufferGpu_t_1_m20].SampleCmpLevelZero(undetermined_1[_Globals_1_g_tShadowDepthBufferCmpSampler], _14975.xy, clamp(_14975.z + PerViewLightingConstantBufferGpu_t_1_m12, 0.0f, 1.0f));
	            float _12501;
	            if (_13136 < 1.0f)
	            {
	                float _7934;
	                if (_10191 < (PerViewLightingConstantBufferGpu_t_1_m11 - 1))
	                {
	                    int _15335 = _10191 + 1;
	                    float4 _19671 = mul(float4x4(float4(PerViewLightingConstantBufferGpu_t_1_m18._m0[_15335]._m0[0].x, PerViewLightingConstantBufferGpu_t_1_m18._m0[_15335]._m0[1].x, PerViewLightingConstantBufferGpu_t_1_m18._m0[_15335]._m0[2].x, PerViewLightingConstantBufferGpu_t_1_m18._m0[_15335]._m0[3].x), float4(PerViewLightingConstantBufferGpu_t_1_m18._m0[_15335]._m0[0].y, PerViewLightingConstantBufferGpu_t_1_m18._m0[_15335]._m0[1].y, PerViewLightingConstantBufferGpu_t_1_m18._m0[_15335]._m0[2].y, PerViewLightingConstantBufferGpu_t_1_m18._m0[_15335]._m0[3].y), float4(PerViewLightingConstantBufferGpu_t_1_m18._m0[_15335]._m0[0].z, PerViewLightingConstantBufferGpu_t_1_m18._m0[_15335]._m0[1].z, PerViewLightingConstantBufferGpu_t_1_m18._m0[_15335]._m0[2].z, PerViewLightingConstantBufferGpu_t_1_m18._m0[_15335]._m0[3].z), float4(PerViewLightingConstantBufferGpu_t_1_m18._m0[_15335]._m0[0].w, PerViewLightingConstantBufferGpu_t_1_m18._m0[_15335]._m0[1].w, PerViewLightingConstantBufferGpu_t_1_m18._m0[_15335]._m0[2].w, PerViewLightingConstantBufferGpu_t_1_m18._m0[_15335]._m0[3].w)), float4(input_1.xyz, 1.0f));
	                    float2 _20562 = (_19671.xy * PerViewLightingConstantBufferGpu_t_1_m19._m0[_15335].zw) + PerViewLightingConstantBufferGpu_t_1_m19._m0[_15335].xy;
	                    float3 _20489;
	                    _20489.x = _20562.x;
	                    _20489.y = _20562.y;
	                    _7934 = g_bindless_Texture2D_float4[PerViewLightingConstantBufferGpu_t_1_m20].SampleCmpLevelZero(undetermined_1[_Globals_1_g_tShadowDepthBufferCmpSampler], _20489.xy, clamp(_19671.z + PerViewLightingConstantBufferGpu_t_1_m12, 0.0f, 1.0f));
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
	            _12502 = min(_13279, g_bindless_Texture2D_float4[PerViewConstantBufferCsgo_t_1_m6].SampleLevel(undetermined[_Globals_1_g_sTrilinearClamp], (_11408.xy * PerViewConstantBuffer_t_1_m2.xy).xy, 0.0f).z);
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
	        float4 _24259 = mul(float4x4(float4(PerViewConstantBufferCsgo_t_1_m8._m0[0].x, PerViewConstantBufferCsgo_t_1_m8._m0[1].x, PerViewConstantBufferCsgo_t_1_m8._m0[2].x, PerViewConstantBufferCsgo_t_1_m8._m0[3].x), float4(PerViewConstantBufferCsgo_t_1_m8._m0[0].y, PerViewConstantBufferCsgo_t_1_m8._m0[1].y, PerViewConstantBufferCsgo_t_1_m8._m0[2].y, PerViewConstantBufferCsgo_t_1_m8._m0[3].y), float4(PerViewConstantBufferCsgo_t_1_m8._m0[0].z, PerViewConstantBufferCsgo_t_1_m8._m0[1].z, PerViewConstantBufferCsgo_t_1_m8._m0[2].z, PerViewConstantBufferCsgo_t_1_m8._m0[3].z), float4(PerViewConstantBufferCsgo_t_1_m8._m0[0].w, PerViewConstantBufferCsgo_t_1_m8._m0[1].w, PerViewConstantBufferCsgo_t_1_m8._m0[2].w, PerViewConstantBufferCsgo_t_1_m8._m0[3].w)), float4(_7715.xyz, 1.0f).xyzw);
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
	                _2284 _25209;
	                [unroll]
	                for (int _4ident = 0; _4ident < 4; _4ident++)
	                {
	                    _25209._m0[_4ident] = asfloat(g_BarnLights.Load4(_4ident * 16 + _12608 * 480 + 0));
	                }
	                float4 _15817 = mul(float4(input_1.xyz, 1.0f), float4x4(float4(_25209._m0[0].x, _25209._m0[1].x, _25209._m0[2].x, _25209._m0[3].x), float4(_25209._m0[0].y, _25209._m0[1].y, _25209._m0[2].y, _25209._m0[3].y), float4(_25209._m0[0].z, _25209._m0[1].z, _25209._m0[2].z, _25209._m0[3].z), float4(_25209._m0[0].w, _25209._m0[1].w, _25209._m0[2].w, _25209._m0[3].w)));
	                float3 _10521 = _15817.xyz / _15817.w.xxx;
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
	                    _2075 _8549;
	                    [unroll]
	                    for (int _5ident = 0; _5ident < 3; _5ident++)
	                    {
	                        _8549._m0[_5ident] = asfloat(g_BarnLights.Load4(_5ident * 16 + _12608 * 480 + 272));
	                    }
	                    float3 _6368 = abs(mul(float4(input_1.xyz, 1.0f), float4x3(float3(_8549._m0[0].x, _8549._m0[1].x, _8549._m0[2].x), float3(_8549._m0[0].y, _8549._m0[1].y, _8549._m0[2].y), float3(_8549._m0[0].z, _8549._m0[1].z, _8549._m0[2].z), float3(_8549._m0[0].w, _8549._m0[1].w, _8549._m0[2].w))).xyz);
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
	                        float3 _23593 = _17795.xyz;
	                        float3 _12170 = ((_20479 * asfloat(g_BarnLights.Load4(_12608 * 480 + 176)).w) + (_23593 * _15156)) + cross(_23593, _20479);
	                        float3 _14081 = float3(float2(atan2(_12170.y, -_12170.x) * 0.15915493667125701904296875f, acos(_12170.z) * 0.3183098733425140380859375f), -asfloat(g_BarnLights.Load4(_12608 * 480 + 160)).w);
	                        float2 _20564 = (_14081.xy * asfloat(g_BarnLights.Load4(_12608 * 480 + 224)).zw) + asfloat(g_BarnLights.Load4(_12608 * 480 + 224)).xy;
	                        float3 _20492 = _14081;
	                        _20492.x = _20564.x;
	                        _20492.y = _20564.y;
	                        _12503 = _17828.xyz * g_bindless_Texture3D_float4[PerViewLightingConstantBufferGpu_t_1_m21].SampleLevel(undetermined[_Globals_1_g_sTrilinearWrap], _20492.xyz, 0.0f).xyz;
	                    }
	                    else
	                    {
	                        float3 _13791 = float3(mad(_22905.xy, float2(0.5f, -0.5f), 0.5f.xx), asfloat(g_BarnLights.Load4(_12608 * 480 + 160)).w);
	                        float2 _20563 = (_13791.xy * asfloat(g_BarnLights.Load4(_12608 * 480 + 224)).zw) + asfloat(g_BarnLights.Load4(_12608 * 480 + 224)).xy;
	                        float3 _20491 = _13791;
	                        _20491.x = _20563.x;
	                        _20491.y = _20563.y;
	                        _12503 = _17828.xyz * g_bindless_Texture3D_float4[PerViewLightingConstantBufferGpu_t_1_m21].SampleLevel(undetermined[_Globals_1_g_sCookieSampler], _20491.xyz, 0.0f).xyz;
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
	                    float3 _20482 = _21548.xyz * lerp(1.0f, g_bindless_Texture2D_float4[PerViewLightingConstantBufferGpu_t_1_m20].SampleCmpLevelZero(undetermined_1[_Globals_1_g_tShadowDepthBufferCmpSampler], float3(mad(_19629.xy, asfloat(g_BarnLights.Load4(_12608 * 480 + 208)).zw, asfloat(g_BarnLights.Load4(_12608 * 480 + 208)).xy), _19629.z).xy, clamp(_19629.z + PerViewLightingConstantBufferGpu_t_1_m12, 0.0f, 1.0f)), asfloat(g_BarnLights.Load(_12608 * 480 + 260)));
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
	    float3 _15734 = _20490.xyz + ((((lerp(_11427.xxx, _11427.yyy, _25153) * g_bindless_TextureCubeArray_float4[PerViewConstantBufferCsgo_t_1_m7].SampleLevel(undetermined[_Globals_1_g_sTrilinearClamp], float4(normalize(lerp(_6253, reflect(_17138.xyz, _17892.xyz).xyz, (_20711 * (sqrt(_20711) + _17225)).xxx)), 0.0f), PerViewLightingConstantBufferGpu_t_1_m8.y * sqrt(_17172)).xyz).xyz * (normalize(_16991 + 0.001000000047497451305389404296875f.xxx) * clamp(length(_16991), 0.0f, 1.75f))).xyz * (1.0f.xxx + (normalize(_8745 + 0.001000000047497451305389404296875f.xxx) * 0.5f))).xyz * _20418).xyz;
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
	                _19341 = lerp(_23944.xyz, float4((g_bindless_TextureCube_float4[PerViewConstantBufferCsgo_t_1_m3].SampleLevel(undetermined[_Globals_1_g_sTrilinearClamp], normalize(mul(float4(_9057, 0.0f), float4x4(float4(PerViewConstantBufferCsgo_t_1_m17._m0[0].x, PerViewConstantBufferCsgo_t_1_m17._m0[1].x, PerViewConstantBufferCsgo_t_1_m17._m0[2].x, PerViewConstantBufferCsgo_t_1_m17._m0[3].x), float4(PerViewConstantBufferCsgo_t_1_m17._m0[0].y, PerViewConstantBufferCsgo_t_1_m17._m0[1].y, PerViewConstantBufferCsgo_t_1_m17._m0[2].y, PerViewConstantBufferCsgo_t_1_m17._m0[3].y), float4(PerViewConstantBufferCsgo_t_1_m17._m0[0].z, PerViewConstantBufferCsgo_t_1_m17._m0[1].z, PerViewConstantBufferCsgo_t_1_m17._m0[2].z, PerViewConstantBufferCsgo_t_1_m17._m0[3].z), float4(PerViewConstantBufferCsgo_t_1_m17._m0[0].w, PerViewConstantBufferCsgo_t_1_m17._m0[1].w, PerViewConstantBufferCsgo_t_1_m17._m0[2].w, PerViewConstantBufferCsgo_t_1_m17._m0[3].w))).xyz).xyz, PerViewConstantBufferCsgo_t_1_m16.w * clamp(1.0f - (_14602 * PerViewConstantBufferCsgo_t_1_m15.z), 0.0f, 1.0f)) * PerViewConstantBufferCsgo_t_1_m19.x).xyz, _8892).xyz, _8892.xxx);
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
	// SPIR-V source (63968 bytes), GLSL reflection with SPIRV-Cross by KhronosGroup
	
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
	    vec3 vBlendValues;
	    vec2 _m1;
	    vec3 _m2;
	    vec4 _m3;
	    uvec4 _m4;
	    uint _m5;
	    vec4 _m6;
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
	
	struct _MatrixStorage_float4x4_ColMajornatural
	{
	    vec4 data[4];
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
	
	vec4 _258;
	
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
	
	struct SLANG_ParameterGroup_PerViewConstantBuffer_t_natural
	{
	    _MatrixStorage_float4x4_ColMajornatural g_matWorldToProjection;
	    _MatrixStorage_float4x4_ColMajornatural g_matProjectionToWorld;
	    _MatrixStorage_float4x4_ColMajornatural g_matWorldToView;
	    _MatrixStorage_float4x4_ColMajornatural g_matViewToProjection;
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
	    _MatrixStorage_float4x4_ColMajornatural g_matPrevWorldToProjection;
	    vec4 g_vWireframeColor;
	};
	
	layout(set = 5) uniform SLANG_ParameterGroup_PerViewConstantBuffer_t_natural PerViewConstantBuffer_t;
	
	hitAttributeEXT BuiltInTriangleIntersectionAttributes _20;
	layout(set = 4, binding = 46) uniform texture2D g_bindless_Texture2D_float4[65536];
	layout(set = 4, binding = 29) uniform sampler g_bindless_Sampler[2048];
	layout(location = 0) rayPayloadInEXT Payload_t _19;
	
	void main()
	{
	    vec4 _326 = vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 112u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 116u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 120u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 124u) / 4u]);
	    vec4 _325 = vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 128u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 132u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 136u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 140u) / 4u]);
	    vec2 _324 = vec2(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 144u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 148u) / 4u]);
	    vec3 _323 = vec3(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 208u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 212u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 216u) / 4u]);
	    float _322 = g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 220u) / 4u];
	    uint _321 = g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 236u) / 4u];
	    uint _320 = g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 256u) / 4u];
	    float _319 = g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 284u) / 4u];
	    float _318 = g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 288u) / 4u];
	    vec2 _317 = vec2(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 296u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 300u) / 4u]);
	    uint _316 = g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 304u) / 4u];
	    uint _315 = g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 308u) / 4u];
	    uint _314 = g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 312u) / 4u];
	    uint _313 = g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 316u) / 4u];
	    uint _312 = g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 320u) / 4u];
	    float _311 = g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 336u) / 4u];
	    uvec3 _409;
	    do
	    {
	        if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes.w == 4)
	        {
	            uint _584 = (12u * uint(gl_PrimitiveID)) + uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes.w);
	            _409 = uvec3(g_Indices_1[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._m0[_584 / 4u], g_Indices_1[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._m0[(_584 + 4u) / 4u], g_Indices_1[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._m0[(_584 + 8u) / 4u]);
	            break;
	        }
	        else
	        {
	            uint _559 = (6u * uint(gl_PrimitiveID)) + uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes.w);
	            uint _560 = _559 & 4294967292u;
	            uint _561 = _560 / 4u;
	            uint _565 = (_560 + 4u) / 4u;
	            uint _570 = (g_Indices_1[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._m0[_561] & 4294901760u) >> uint(16);
	            uint _571 = g_Indices_1[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._m0[_565] & 65535u;
	            uvec3 _410;
	            if (_559 == _560)
	            {
	                _410 = uvec3(g_Indices_1[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._m0[_561] & 65535u, _570, _571);
	            }
	            else
	            {
	                _410 = uvec3(_570, _571, (g_Indices_1[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._m0[_565] & 4294901760u) >> uint(16));
	            }
	            _409 = _410;
	            break;
	        }
	        break;
	    } while(false);
	    uint _599 = uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.x);
	    uvec3 _607 = (uvec3(uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes.x)) * _409) + uvec3(uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes.x));
	    vec3 _404[3];
	    uint _609 = _607.x;
	    _404[0] = vec3(g_Vertices_1[_599]._m0[_609 / 4u], g_Vertices_1[_599]._m0[(_609 + 4u) / 4u], g_Vertices_1[_599]._m0[(_609 + 8u) / 4u]);
	    uint _623 = _607.y;
	    _404[1] = vec3(g_Vertices_1[_599]._m0[_623 / 4u], g_Vertices_1[_599]._m0[(_623 + 4u) / 4u], g_Vertices_1[_599]._m0[(_623 + 8u) / 4u]);
	    uint _637 = _607.z;
	    _404[2] = vec3(g_Vertices_1[_599]._m0[_637 / 4u], g_Vertices_1[_599]._m0[(_637 + 4u) / 4u], g_Vertices_1[_599]._m0[(_637 + 8u) / 4u]);
	    int _405 = 0;
	    VS_INPUT vsInput[3];
	    for (;;)
	    {
	        if (!(_405 < 3))
	        {
	            break;
	        }
	        vsInput[_405].vBlendValues = _404[_405];
	        _405++;
	        continue;
	    }
	    vec2 _406[3];
	    _406[0] = vec2(0.0);
	    _406[1] = vec2(0.0);
	    _406[2] = vec2(0.0);
	    if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].y != 0)
	    {
	        ivec4 _403 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers;
	        uint _680 = uint(_403[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].z]);
	        uint _682 = uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].z);
	        ivec4 _401 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes;
	        ivec4 _402 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes;
	        uvec3 _693 = (uvec3(uint(_401[_682])) * _409) + uvec3(uint(_402[_682]) + uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].x));
	        if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].y == 16)
	        {
	            uint _828 = _693.x;
	            _406[0] = vec2(g_Vertices_1[_680]._m0[_828 / 4u], g_Vertices_1[_680]._m0[(_828 + 4u) / 4u]);
	            uint _837 = _693.y;
	            _406[1] = vec2(g_Vertices_1[_680]._m0[_837 / 4u], g_Vertices_1[_680]._m0[(_837 + 4u) / 4u]);
	            uint _846 = _693.z;
	            _406[2] = vec2(g_Vertices_1[_680]._m0[_846 / 4u], g_Vertices_1[_680]._m0[(_846 + 4u) / 4u]);
	        }
	        else
	        {
	            if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].y == 34)
	            {
	                uint _799 = _693.x / 4u;
	                _406[0] = vec2(uint16BitsToFloat16(u16vec2(uvec2(g_Vertices_3[_680]._m0[_799], g_Vertices_3[_680]._m0[_799] >> uint(16)) & uvec2(65535u))));
	                uint _809 = _693.y / 4u;
	                _406[1] = vec2(uint16BitsToFloat16(u16vec2(uvec2(g_Vertices_3[_680]._m0[_809], g_Vertices_3[_680]._m0[_809] >> uint(16)) & uvec2(65535u))));
	                uint _819 = _693.z / 4u;
	                _406[2] = vec2(uint16BitsToFloat16(u16vec2(uvec2(g_Vertices_3[_680]._m0[_819], g_Vertices_3[_680]._m0[_819] >> uint(16)) & uvec2(65535u))));
	            }
	            else
	            {
	                if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].y == 37)
	                {
	                    uint _706 = _693.x / 4u;
	                    uint _710 = (g_Vertices_3[_680]._m0[_706] & 65535u);
	                    int _400;
	                    if (_710 > 32767u)
	                    {
	                        _400 = int(4294901760u | _710);
	                    }
	                    else
	                    {
	                        _400 = int(_710);
	                    }
	                    uint _723 = (g_Vertices_3[_680]._m0[_706] & 4294901760u) >> uint(16);
	                    int _399;
	                    if (_723 > 32767u)
	                    {
	                        _399 = int(4294901760u | _723);
	                    }
	                    else
	                    {
	                        _399 = int(_723);
	                    }
	                    _406[0] = vec2(max(float(_400) * 3.0518509447574615478515625e-05, -1.0), max(float(_399) * 3.0518509447574615478515625e-05, -1.0));
	                    uint _737 = _693.y / 4u;
	                    uint _741 = (g_Vertices_3[_680]._m0[_737] & 65535u);
	                    int _398;
	                    if (_741 > 32767u)
	                    {
	                        _398 = int(4294901760u | _741);
	                    }
	                    else
	                    {
	                        _398 = int(_741);
	                    }
	                    uint _754 = (g_Vertices_3[_680]._m0[_737] & 4294901760u) >> uint(16);
	                    int _397;
	                    if (_754 > 32767u)
	                    {
	                        _397 = int(4294901760u | _754);
	                    }
	                    else
	                    {
	                        _397 = int(_754);
	                    }
	                    _406[1] = vec2(max(float(_398) * 3.0518509447574615478515625e-05, -1.0), max(float(_397) * 3.0518509447574615478515625e-05, -1.0));
	                    uint _768 = _693.z / 4u;
	                    uint _772 = (g_Vertices_3[_680]._m0[_768] & 65535u);
	                    int _396;
	                    if (_772 > 32767u)
	                    {
	                        _396 = int(4294901760u | _772);
	                    }
	                    else
	                    {
	                        _396 = int(_772);
	                    }
	                    uint _785 = (g_Vertices_3[_680]._m0[_768] & 4294901760u) >> uint(16);
	                    int _395;
	                    if (_785 > 32767u)
	                    {
	                        _395 = int(4294901760u | _785);
	                    }
	                    else
	                    {
	                        _395 = int(_785);
	                    }
	                    _406[2] = vec2(max(float(_396) * 3.0518509447574615478515625e-05, -1.0), max(float(_395) * 3.0518509447574615478515625e-05, -1.0));
	                }
	            }
	        }
	    }
	    _405 = 0;
	    for (;;)
	    {
	        if (!(_405 < 3))
	        {
	            break;
	        }
	        vsInput[_405]._m1 = _406[_405];
	        _405++;
	        continue;
	    }
	    vec3 _407[3];
	    vec4 _408[3];
	    do
	    {
	        if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.y != 0)
	        {
	            ivec4 _381 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers;
	            uint _888 = uint(_381[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.z]);
	            uint _890 = uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.z);
	            ivec4 _379 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes;
	            ivec4 _380 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes;
	            uvec3 _901 = (uvec3(uint(_379[_890])) * _409) + uvec3(uint(_380[_890]) + uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.x));
	            if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.y == 6)
	            {
	                uint _1432 = _901.x;
	                _407[0] = vec3(g_Vertices_1[_888]._m0[_1432 / 4u], g_Vertices_1[_888]._m0[(_1432 + 4u) / 4u], g_Vertices_1[_888]._m0[(_1432 + 8u) / 4u]);
	                uint _1446 = _901.y;
	                _407[1] = vec3(g_Vertices_1[_888]._m0[_1446 / 4u], g_Vertices_1[_888]._m0[(_1446 + 4u) / 4u], g_Vertices_1[_888]._m0[(_1446 + 8u) / 4u]);
	                uint _1460 = _901.z;
	                _407[2] = vec3(g_Vertices_1[_888]._m0[_1460 / 4u], g_Vertices_1[_888]._m0[(_1460 + 4u) / 4u], g_Vertices_1[_888]._m0[(_1460 + 8u) / 4u]);
	            }
	            else
	            {
	                if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.y == 17)
	                {
	                    uint _1165 = _901.x;
	                    uvec2 _1173 = uvec2(g_Vertices_3[_888]._m0[_1165 / 4u], g_Vertices_3[_888]._m0[(_1165 + 4u) / 4u]);
	                    uint _1174 = _901.y;
	                    uvec2 _278 = uvec2(g_Vertices_3[_888]._m0[_1174 / 4u], g_Vertices_3[_888]._m0[(_1174 + 4u) / 4u]);
	                    uint _1183 = _901.z;
	                    uvec2 _277 = uvec2(g_Vertices_3[_888]._m0[_1183 / 4u], g_Vertices_3[_888]._m0[(_1183 + 4u) / 4u]);
	                    uint _1195 = _1173.x;
	                    uint _1204 = _1173.y;
	                    vec2 _1214 = ((vec2(float((_1195) & 65535u), float((_1195 >> 16u) & 65535u)) * vec2(1.525902189314365386962890625e-05)) * 2.0) - vec2(1.0);
	                    float _1215 = _1214.x;
	                    float _1220 = (1.0 - abs(_1215)) - abs(_1214.y);
	                    vec3 _1221 = vec3(_1215, _1214.y, _1220);
	                    float _1223 = saturate(-_1220);
	                    vec2 _1229 = _1214 + mix(vec2(_1223), vec2(-_1223), greaterThanEqual(_1214, vec2(0.0)));
	                    _1221.x = _1229.x;
	                    _1221.y = _1229.y;
	                    vec3 _389 = normalize(_1221);
	                    vec2 _1236 = ((vec2(float((_1204 >> uint(1)) & 32767u), float((_1204 >> 16u) & 32767u)) * vec2(3.0518509447574615478515625e-05)) * 2.0) - vec2(1.0);
	                    float _1237 = _1236.x;
	                    float _1242 = (1.0 - abs(_1237)) - abs(_1236.y);
	                    vec3 _1243 = vec3(_1237, _1236.y, _1242);
	                    float _1245 = saturate(-_1242);
	                    vec2 _1251 = _1236 + mix(vec2(_1245), vec2(-_1245), greaterThanEqual(_1236, vec2(0.0)));
	                    _1243.x = _1251.x;
	                    _1243.y = _1251.y;
	                    vec3 _388 = normalize(_1243);
	                    float _369;
	                    if ((_1204 & 1u) != 0u)
	                    {
	                        _369 = 1.0;
	                    }
	                    else
	                    {
	                        _369 = -1.0;
	                    }
	                    _407[0] = _389;
	                    _408[0].w = _369;
	                    _408[0].x = _388.x;
	                    _408[0].y = _388.y;
	                    _408[0].z = _388.z;
	                    vec2 _1294 = ((vec2(float((_278.x) & 65535u), float((_278.x >> 16u) & 65535u)) * vec2(1.525902189314365386962890625e-05)) * 2.0) - vec2(1.0);
	                    float _1295 = _1294.x;
	                    float _1300 = (1.0 - abs(_1295)) - abs(_1294.y);
	                    vec3 _1301 = vec3(_1295, _1294.y, _1300);
	                    float _1303 = saturate(-_1300);
	                    vec2 _1309 = _1294 + mix(vec2(_1303), vec2(-_1303), greaterThanEqual(_1294, vec2(0.0)));
	                    _1301.x = _1309.x;
	                    _1301.y = _1309.y;
	                    vec3 _391 = normalize(_1301);
	                    vec2 _1316 = ((vec2(float((_278.y >> uint(1)) & 32767u), float((_278.y >> 16u) & 32767u)) * vec2(3.0518509447574615478515625e-05)) * 2.0) - vec2(1.0);
	                    float _1317 = _1316.x;
	                    float _1322 = (1.0 - abs(_1317)) - abs(_1316.y);
	                    vec3 _1323 = vec3(_1317, _1316.y, _1322);
	                    float _1325 = saturate(-_1322);
	                    vec2 _1331 = _1316 + mix(vec2(_1325), vec2(-_1325), greaterThanEqual(_1316, vec2(0.0)));
	                    _1323.x = _1331.x;
	                    _1323.y = _1331.y;
	                    vec3 _390 = normalize(_1323);
	                    float _368;
	                    if ((_278.y & 1u) != 0u)
	                    {
	                        _368 = 1.0;
	                    }
	                    else
	                    {
	                        _368 = -1.0;
	                    }
	                    _407[1] = _391;
	                    _408[1].w = _368;
	                    _408[1].x = _390.x;
	                    _408[1].y = _390.y;
	                    _408[1].z = _390.z;
	                    vec2 _1374 = ((vec2(float((_277.x) & 65535u), float((_277.x >> 16u) & 65535u)) * vec2(1.525902189314365386962890625e-05)) * 2.0) - vec2(1.0);
	                    float _1375 = _1374.x;
	                    float _1380 = (1.0 - abs(_1375)) - abs(_1374.y);
	                    vec3 _1381 = vec3(_1375, _1374.y, _1380);
	                    float _1383 = saturate(-_1380);
	                    vec2 _1389 = _1374 + mix(vec2(_1383), vec2(-_1383), greaterThanEqual(_1374, vec2(0.0)));
	                    _1381.x = _1389.x;
	                    _1381.y = _1389.y;
	                    vec3 _393 = normalize(_1381);
	                    vec2 _1396 = ((vec2(float((_277.y >> uint(1)) & 32767u), float((_277.y >> 16u) & 32767u)) * vec2(3.0518509447574615478515625e-05)) * 2.0) - vec2(1.0);
	                    float _1397 = _1396.x;
	                    float _1402 = (1.0 - abs(_1397)) - abs(_1396.y);
	                    vec3 _1403 = vec3(_1397, _1396.y, _1402);
	                    float _1405 = saturate(-_1402);
	                    vec2 _1411 = _1396 + mix(vec2(_1405), vec2(-_1405), greaterThanEqual(_1396, vec2(0.0)));
	                    _1403.x = _1411.x;
	                    _1403.y = _1411.y;
	                    vec3 _392 = normalize(_1403);
	                    float _367;
	                    if ((_277.y & 1u) != 0u)
	                    {
	                        _367 = 1.0;
	                    }
	                    else
	                    {
	                        _367 = -1.0;
	                    }
	                    _407[2] = _393;
	                    _408[2].w = _367;
	                    _408[2].x = _392.x;
	                    _408[2].y = _392.y;
	                    _408[2].z = _392.z;
	                    break;
	                }
	                else
	                {
	                    uint _911 = _901.x / 4u;
	                    vec4 _383 = _408[0];
	                    float _926 = (float((g_Vertices_3[_888]._m0[_911] >> 12u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _929 = (float((g_Vertices_3[_888]._m0[_911] >> 22u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _933 = (1.0 - abs(_926)) - abs(_929);
	                    vec3 _934 = vec3(_926, _929, _933);
	                    float _936 = saturate(-_933);
	                    vec2 _937 = vec2(_926, _929);
	                    vec2 _943 = _937 + mix(vec2(_936), vec2(-_936), greaterThanEqual(_937, vec2(0.0)));
	                    _934.x = _943.x;
	                    _934.y = _943.y;
	                    vec3 _948 = normalize(_934);
	                    vec3 _382 = _948;
	                    float _949 = _948.z;
	                    float _376;
	                    if (_949 >= 0.0)
	                    {
	                        _376 = 1.0;
	                    }
	                    else
	                    {
	                        _376 = -1.0;
	                    }
	                    float _956 = (-1.0) / (_376 + _949);
	                    float _957 = _948.x;
	                    vec3 _377;
	                    vec3 _965 = _377;
	                    _965.x = 1.0 + (((_376 * _957) * _957) * _956);
	                    _965.y = _376 * ((_957 * _948.y) * _956);
	                    _965.z = (-_376) * _957;
	                    _377 = _965;
	                    float _973 = float((g_Vertices_3[_888]._m0[_911] >> uint(1)) & 2047u) * 0.003069460391998291015625;
	                    vec3 _979 = (_965 * cos(_973)) + (cross(_948, _965) * sin(_973));
	                    vec4 _981 = _383;
	                    _981.x = _979.x;
	                    _981.y = _979.y;
	                    _981.z = _979.z;
	                    _383 = _981;
	                    float _378;
	                    if ((g_Vertices_3[_888]._m0[_911] & 1u) == 0u)
	                    {
	                        _378 = -1.0;
	                    }
	                    else
	                    {
	                        _378 = 1.0;
	                    }
	                    vec4 _992 = _383;
	                    _992.w = _378;
	                    _383 = _992;
	                    _407[0] = _382;
	                    _408[0] = _992;
	                    uint _996 = _901.y / 4u;
	                    vec4 _385 = _408[1];
	                    float _1011 = (float((g_Vertices_3[_888]._m0[_996] >> 12u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _1014 = (float((g_Vertices_3[_888]._m0[_996] >> 22u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _1018 = (1.0 - abs(_1011)) - abs(_1014);
	                    vec3 _1019 = vec3(_1011, _1014, _1018);
	                    float _1021 = saturate(-_1018);
	                    vec2 _1022 = vec2(_1011, _1014);
	                    vec2 _1028 = _1022 + mix(vec2(_1021), vec2(-_1021), greaterThanEqual(_1022, vec2(0.0)));
	                    _1019.x = _1028.x;
	                    _1019.y = _1028.y;
	                    vec3 _1033 = normalize(_1019);
	                    vec3 _384 = _1033;
	                    float _1034 = _1033.z;
	                    float _373;
	                    if (_1034 >= 0.0)
	                    {
	                        _373 = 1.0;
	                    }
	                    else
	                    {
	                        _373 = -1.0;
	                    }
	                    float _1041 = (-1.0) / (_373 + _1034);
	                    float _1042 = _1033.x;
	                    vec3 _374;
	                    vec3 _1050 = _374;
	                    _1050.x = 1.0 + (((_373 * _1042) * _1042) * _1041);
	                    _1050.y = _373 * ((_1042 * _1033.y) * _1041);
	                    _1050.z = (-_373) * _1042;
	                    _374 = _1050;
	                    float _1058 = float((g_Vertices_3[_888]._m0[_996] >> uint(1)) & 2047u) * 0.003069460391998291015625;
	                    vec3 _1064 = (_1050 * cos(_1058)) + (cross(_1033, _1050) * sin(_1058));
	                    vec4 _1066 = _385;
	                    _1066.x = _1064.x;
	                    _1066.y = _1064.y;
	                    _1066.z = _1064.z;
	                    _385 = _1066;
	                    float _375;
	                    if ((g_Vertices_3[_888]._m0[_996] & 1u) == 0u)
	                    {
	                        _375 = -1.0;
	                    }
	                    else
	                    {
	                        _375 = 1.0;
	                    }
	                    vec4 _1077 = _385;
	                    _1077.w = _375;
	                    _385 = _1077;
	                    _407[1] = _384;
	                    _408[1] = _1077;
	                    uint _1081 = _901.z / 4u;
	                    vec4 _387 = _408[2];
	                    float _1096 = (float((g_Vertices_3[_888]._m0[_1081] >> 12u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _1099 = (float((g_Vertices_3[_888]._m0[_1081] >> 22u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _1103 = (1.0 - abs(_1096)) - abs(_1099);
	                    vec3 _1104 = vec3(_1096, _1099, _1103);
	                    float _1106 = saturate(-_1103);
	                    vec2 _1107 = vec2(_1096, _1099);
	                    vec2 _1113 = _1107 + mix(vec2(_1106), vec2(-_1106), greaterThanEqual(_1107, vec2(0.0)));
	                    _1104.x = _1113.x;
	                    _1104.y = _1113.y;
	                    vec3 _1118 = normalize(_1104);
	                    vec3 _386 = _1118;
	                    float _1119 = _1118.z;
	                    float _370;
	                    if (_1119 >= 0.0)
	                    {
	                        _370 = 1.0;
	                    }
	                    else
	                    {
	                        _370 = -1.0;
	                    }
	                    float _1126 = (-1.0) / (_370 + _1119);
	                    float _1127 = _1118.x;
	                    vec3 _371;
	                    vec3 _1135 = _371;
	                    _1135.x = 1.0 + (((_370 * _1127) * _1127) * _1126);
	                    _1135.y = _370 * ((_1127 * _1118.y) * _1126);
	                    _1135.z = (-_370) * _1127;
	                    _371 = _1135;
	                    float _1143 = float((g_Vertices_3[_888]._m0[_1081] >> uint(1)) & 2047u) * 0.003069460391998291015625;
	                    vec3 _1149 = (_1135 * cos(_1143)) + (cross(_1118, _1135) * sin(_1143));
	                    vec4 _1151 = _387;
	                    _1151.x = _1149.x;
	                    _1151.y = _1149.y;
	                    _1151.z = _1149.z;
	                    _387 = _1151;
	                    float _372;
	                    if ((g_Vertices_3[_888]._m0[_1081] & 1u) == 0u)
	                    {
	                        _372 = -1.0;
	                    }
	                    else
	                    {
	                        _372 = 1.0;
	                    }
	                    vec4 _1162 = _387;
	                    _1162.w = _372;
	                    _387 = _1162;
	                    _407[2] = _386;
	                    _408[2] = _1162;
	                    break;
	                }
	                break;
	            }
	        }
	        else
	        {
	            _407[0] = vec3(0.0);
	            _407[1] = vec3(0.0);
	            _407[2] = vec3(0.0);
	        }
	        if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTangentFieldInfo.y != 0)
	        {
	            ivec4 _394 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers;
	            uint _1485 = uint(_394[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTangentFieldInfo.z]);
	            uint _1487 = uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTangentFieldInfo.z);
	            ivec4 _365 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes;
	            ivec4 _366 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes;
	            uvec3 _1498 = (uvec3(uint(_365[_1487])) * _409) + uvec3(uint(_366[_1487]) + uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTangentFieldInfo.x));
	            uint _1500 = _1498.x;
	            _408[0] = vec4(g_Vertices_1[_1485]._m0[_1500 / 4u], g_Vertices_1[_1485]._m0[(_1500 + 4u) / 4u], g_Vertices_1[_1485]._m0[(_1500 + 8u) / 4u], g_Vertices_1[_1485]._m0[(_1500 + 12u) / 4u]);
	            uint _1518 = _1498.y;
	            _408[1] = vec4(g_Vertices_1[_1485]._m0[_1518 / 4u], g_Vertices_1[_1485]._m0[(_1518 + 4u) / 4u], g_Vertices_1[_1485]._m0[(_1518 + 8u) / 4u], g_Vertices_1[_1485]._m0[(_1518 + 12u) / 4u]);
	            uint _1536 = _1498.z;
	            _408[2] = vec4(g_Vertices_1[_1485]._m0[_1536 / 4u], g_Vertices_1[_1485]._m0[(_1536 + 4u) / 4u], g_Vertices_1[_1485]._m0[(_1536 + 8u) / 4u], g_Vertices_1[_1485]._m0[(_1536 + 12u) / 4u]);
	        }
	        else
	        {
	            _408[0] = vec4(0.0);
	            _408[1] = vec4(0.0);
	            _408[2] = vec4(0.0);
	        }
	        break;
	    } while(false);
	    _405 = 0;
	    for (;;)
	    {
	        if (!(_405 < 3))
	        {
	            break;
	        }
	        vsInput[_405]._m2 = _407[_405];
	        vsInput[_405]._m3 = _408[_405];
	        _405++;
	        continue;
	    }
	    vec4 _411[3];
	    _411[0] = vec4(0.0);
	    _411[1] = vec4(0.0);
	    _411[2] = vec4(0.0);
	    if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[4].y != 0)
	    {
	        ivec4 _364 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers;
	        uint _1590 = uint(_364[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[4].z]);
	        uint _1592 = uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[4].z);
	        ivec4 _362 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes;
	        ivec4 _363 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes;
	        uvec3 _1603 = (uvec3(uint(_362[_1592])) * _409) + uvec3(uint(_363[_1592]) + uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[4].x));
	        if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[4].y == 2)
	        {
	            uint _1656 = _1603.x;
	            _411[0] = vec4(g_Vertices_1[_1590]._m0[_1656 / 4u], g_Vertices_1[_1590]._m0[(_1656 + 4u) / 4u], g_Vertices_1[_1590]._m0[(_1656 + 8u) / 4u], g_Vertices_1[_1590]._m0[(_1656 + 12u) / 4u]);
	            uint _1673 = _1603.y;
	            _411[1] = vec4(g_Vertices_1[_1590]._m0[_1673 / 4u], g_Vertices_1[_1590]._m0[(_1673 + 4u) / 4u], g_Vertices_1[_1590]._m0[(_1673 + 8u) / 4u], g_Vertices_1[_1590]._m0[(_1673 + 12u) / 4u]);
	            uint _1690 = _1603.z;
	            _411[2] = vec4(g_Vertices_1[_1590]._m0[_1690 / 4u], g_Vertices_1[_1590]._m0[(_1690 + 4u) / 4u], g_Vertices_1[_1590]._m0[(_1690 + 8u) / 4u], g_Vertices_1[_1590]._m0[(_1690 + 12u) / 4u]);
	        }
	        else
	        {
	            if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[4].y == 28)
	            {
	                uint _1612 = _1603.x / 4u;
	                _411[0] = vec4(uvec4((g_Vertices_3[_1590]._m0[_1612] & 255u), (g_Vertices_3[_1590]._m0[_1612] & 65280u) >> uint(8), (g_Vertices_3[_1590]._m0[_1612] & 16711680u) >> uint(16), (g_Vertices_3[_1590]._m0[_1612] & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	                uint _1627 = _1603.y / 4u;
	                _411[1] = vec4(uvec4((g_Vertices_3[_1590]._m0[_1627] & 255u), (g_Vertices_3[_1590]._m0[_1627] & 65280u) >> uint(8), (g_Vertices_3[_1590]._m0[_1627] & 16711680u) >> uint(16), (g_Vertices_3[_1590]._m0[_1627] & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	                uint _1642 = _1603.z / 4u;
	                _411[2] = vec4(uvec4((g_Vertices_3[_1590]._m0[_1642] & 255u), (g_Vertices_3[_1590]._m0[_1642] & 65280u) >> uint(8), (g_Vertices_3[_1590]._m0[_1642] & 16711680u) >> uint(16), (g_Vertices_3[_1590]._m0[_1642] & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	            }
	        }
	    }
	    int _412 = 0;
	    for (;;)
	    {
	        if (!(_412 < 3))
	        {
	            break;
	        }
	        vsInput[_412]._m6 = _411[_412];
	        _412++;
	        continue;
	    }
	    vec3 _360 = vsInput[0]._m2;
	    vec4 _361;
	    vec4 _1731 = _361;
	    _1731.x = vsInput[0]._m3.x;
	    _1731.y = vsInput[0]._m3.y;
	    _1731.z = vsInput[0]._m3.z;
	    _1731.w = vsInput[0]._m3.w;
	    _361 = _1731;
	    vec4 _1756 = vec4(uvec4((g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 255u), (g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 65280u) >> uint(8), (g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 16711680u) >> uint(16), (g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	    vec4 _359 = _1756;
	    vec3 _1757 = _1756.xyz;
	    vec3 _1758 = _1757 * vec3(0.077399380505084991455078125);
	    vec3 _1761 = pow((_1757 * vec3(0.947867333889007568359375)) + vec3(0.052132703363895416259765625), vec3(2.400000095367431640625));
	    float _356;
	    if (_1756.x <= 0.040449999272823333740234375)
	    {
	        _356 = _1758.x;
	    }
	    else
	    {
	        _356 = _1761.x;
	    }
	    float _357;
	    if (_1756.y <= 0.040449999272823333740234375)
	    {
	        _357 = _1758.y;
	    }
	    else
	    {
	        _357 = _1761.y;
	    }
	    float _358;
	    if (_1756.z <= 0.040449999272823333740234375)
	    {
	        _358 = _1758.z;
	    }
	    else
	    {
	        _358 = _1761.z;
	    }
	    vec3 _1786 = vec3(_356, _357, _358);
	    vec4 _1788 = _359;
	    _1788.x = _1786.x;
	    _1788.y = _1786.y;
	    _1788.z = _1786.z;
	    _359 = _1788;
	    vec4 _285;
	    vec4 _1795 = _285;
	    _1795.x = _1788.x;
	    _1795.y = _1788.y;
	    _1795.z = _1788.z;
	    _1795.w = _1788.w;
	    _285 = _1795;
	    mat3x4 _1806 = transpose(gl_WorldToObjectEXT);
	    mat3 _355;
	    mat3 _1809 = _355;
	    _1809[0] = _1806[0].xyz;
	    _1809[1] = _1806[1].xyz;
	    _1809[2] = _1806[2].xyz;
	    _355 = _1809;
	    vec3 _1818 = normalize(_1809 * _360.xyz);
	    vec3 _286;
	    vec3 _1820 = _286;
	    _1820.x = _1818.x;
	    _1820.y = _1818.y;
	    _1820.z = _1818.z;
	    _286 = _1820;
	    mat3x4 _1832 = transpose(gl_WorldToObjectEXT);
	    mat3 _354;
	    mat3 _1835 = _354;
	    _1835[0] = _1832[0].xyz;
	    _1835[1] = _1832[1].xyz;
	    _1835[2] = _1832[2].xyz;
	    _354 = _1835;
	    vec3 _1844 = normalize(_1835 * _361.xyz);
	    vec4 _284;
	    vec4 _1846 = _284;
	    _1846.x = _1844.x;
	    _1846.y = _1844.y;
	    _1846.z = _1844.z;
	    _1846.w = _361.w;
	    _284 = _1846;
	    vec4 _1855 = vsInput[0]._m1.xyxy;
	    vec4 _287;
	    vec4 _1856 = _287;
	    vec4 _1869 = _1855;
	    _1869.x = dot(_1855.xy, _326.xy) + _326.w;
	    _1869.y = dot(_1855.xy, _325.xy) + _325.w;
	    vec2 _1877 = _1869.xy + (_324.xy * PerViewConstantBuffer_t.g_flGameTime);
	    vec4 _1879 = _1869;
	    _1879.x = _1877.x;
	    _1879.y = _1877.y;
	    vec3 _1885 = mix(vec3(1.0), _1795.xyz, vec3(_322));
	    vec4 _1887 = _1795;
	    _1887.x = _1885.x;
	    _1887.y = _1885.y;
	    _1887.z = _1885.z;
	    vec3 _1895 = _1887.xyz * _323.xyz;
	    vec4 _1897 = _1887;
	    _1897.x = _1895.x;
	    _1897.y = _1895.y;
	    _1897.z = _1895.z;
	    _1856.x = vsInput[0]._m6.x;
	    _1856.y = vsInput[0]._m6.y;
	    _1856.z = vsInput[0]._m6.z;
	    _1856.w = max(vsInput[0]._m6.w, 0.100000001490116119384765625);
	    vec4 _276 = _1856;
	    vec3 _275 = vec4(vsInput[0].vBlendValues.xyz, 1.0) * transpose(gl_ObjectToWorldEXT);
	    vec3 _274 = _1820;
	    vec4 _273 = _1879;
	    vec4 _272 = _1897;
	    vec4 _271 = _1846;
	    vec3 _352 = vsInput[1]._m2;
	    vec4 _353;
	    vec4 _1917 = _353;
	    _1917.x = vsInput[1]._m3.x;
	    _1917.y = vsInput[1]._m3.y;
	    _1917.z = vsInput[1]._m3.z;
	    _1917.w = vsInput[1]._m3.w;
	    _353 = _1917;
	    vec4 _1942 = vec4(uvec4((g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 255u), (g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 65280u) >> uint(8), (g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 16711680u) >> uint(16), (g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	    vec4 _351 = _1942;
	    vec3 _1943 = _1942.xyz;
	    vec3 _1944 = _1943 * vec3(0.077399380505084991455078125);
	    vec3 _1947 = pow((_1943 * vec3(0.947867333889007568359375)) + vec3(0.052132703363895416259765625), vec3(2.400000095367431640625));
	    float _348;
	    if (_1942.x <= 0.040449999272823333740234375)
	    {
	        _348 = _1944.x;
	    }
	    else
	    {
	        _348 = _1947.x;
	    }
	    float _349;
	    if (_1942.y <= 0.040449999272823333740234375)
	    {
	        _349 = _1944.y;
	    }
	    else
	    {
	        _349 = _1947.y;
	    }
	    float _350;
	    if (_1942.z <= 0.040449999272823333740234375)
	    {
	        _350 = _1944.z;
	    }
	    else
	    {
	        _350 = _1947.z;
	    }
	    vec3 _1972 = vec3(_348, _349, _350);
	    vec4 _1974 = _351;
	    _1974.x = _1972.x;
	    _1974.y = _1972.y;
	    _1974.z = _1972.z;
	    _351 = _1974;
	    vec4 _289;
	    vec4 _1981 = _289;
	    _1981.x = _1974.x;
	    _1981.y = _1974.y;
	    _1981.z = _1974.z;
	    _1981.w = _1974.w;
	    _289 = _1981;
	    mat3x4 _1992 = transpose(gl_WorldToObjectEXT);
	    mat3 _347;
	    mat3 _1995 = _347;
	    _1995[0] = _1992[0].xyz;
	    _1995[1] = _1992[1].xyz;
	    _1995[2] = _1992[2].xyz;
	    _347 = _1995;
	    vec3 _2004 = normalize(_1995 * _352.xyz);
	    vec3 _290;
	    vec3 _2006 = _290;
	    _2006.x = _2004.x;
	    _2006.y = _2004.y;
	    _2006.z = _2004.z;
	    _290 = _2006;
	    mat3x4 _2018 = transpose(gl_WorldToObjectEXT);
	    mat3 _346;
	    mat3 _2021 = _346;
	    _2021[0] = _2018[0].xyz;
	    _2021[1] = _2018[1].xyz;
	    _2021[2] = _2018[2].xyz;
	    _346 = _2021;
	    vec3 _2030 = normalize(_2021 * _353.xyz);
	    vec4 _288;
	    vec4 _2032 = _288;
	    _2032.x = _2030.x;
	    _2032.y = _2030.y;
	    _2032.z = _2030.z;
	    _2032.w = _353.w;
	    _288 = _2032;
	    vec4 _2041 = vsInput[1]._m1.xyxy;
	    vec4 _291;
	    vec4 _2042 = _291;
	    vec4 _2055 = _2041;
	    _2055.x = dot(_2041.xy, _326.xy) + _326.w;
	    _2055.y = dot(_2041.xy, _325.xy) + _325.w;
	    vec2 _2063 = _2055.xy + (_324.xy * PerViewConstantBuffer_t.g_flGameTime);
	    vec4 _2065 = _2055;
	    _2065.x = _2063.x;
	    _2065.y = _2063.y;
	    vec3 _2071 = mix(vec3(1.0), _1981.xyz, vec3(_322));
	    vec4 _2073 = _1981;
	    _2073.x = _2071.x;
	    _2073.y = _2071.y;
	    _2073.z = _2071.z;
	    vec3 _2081 = _2073.xyz * _323.xyz;
	    vec4 _2083 = _2073;
	    _2083.x = _2081.x;
	    _2083.y = _2081.y;
	    _2083.z = _2081.z;
	    _2042.x = vsInput[1]._m6.x;
	    _2042.y = vsInput[1]._m6.y;
	    _2042.z = vsInput[1]._m6.z;
	    _2042.w = max(vsInput[1]._m6.w, 0.100000001490116119384765625);
	    vec4 _270 = _2042;
	    vec3 _269 = vec4(vsInput[1].vBlendValues.xyz, 1.0) * transpose(gl_ObjectToWorldEXT);
	    vec3 _268 = _2006;
	    vec4 _267 = _2065;
	    vec4 _266 = _2083;
	    vec4 _265 = _2032;
	    vec3 _344 = vsInput[2]._m2;
	    vec4 _345;
	    vec4 _2103 = _345;
	    _2103.x = vsInput[2]._m3.x;
	    _2103.y = vsInput[2]._m3.y;
	    _2103.z = vsInput[2]._m3.z;
	    _2103.w = vsInput[2]._m3.w;
	    _345 = _2103;
	    vec4 _2128 = vec4(uvec4((g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 255u), (g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 65280u) >> uint(8), (g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 16711680u) >> uint(16), (g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	    vec4 _343 = _2128;
	    vec3 _2129 = _2128.xyz;
	    vec3 _2130 = _2129 * vec3(0.077399380505084991455078125);
	    vec3 _2133 = pow((_2129 * vec3(0.947867333889007568359375)) + vec3(0.052132703363895416259765625), vec3(2.400000095367431640625));
	    float _340;
	    if (_2128.x <= 0.040449999272823333740234375)
	    {
	        _340 = _2130.x;
	    }
	    else
	    {
	        _340 = _2133.x;
	    }
	    float _341;
	    if (_2128.y <= 0.040449999272823333740234375)
	    {
	        _341 = _2130.y;
	    }
	    else
	    {
	        _341 = _2133.y;
	    }
	    float _342;
	    if (_2128.z <= 0.040449999272823333740234375)
	    {
	        _342 = _2130.z;
	    }
	    else
	    {
	        _342 = _2133.z;
	    }
	    vec3 _2158 = vec3(_340, _341, _342);
	    vec4 _2160 = _343;
	    _2160.x = _2158.x;
	    _2160.y = _2158.y;
	    _2160.z = _2158.z;
	    _343 = _2160;
	    vec4 _293;
	    vec4 _2167 = _293;
	    _2167.x = _2160.x;
	    _2167.y = _2160.y;
	    _2167.z = _2160.z;
	    _2167.w = _2160.w;
	    _293 = _2167;
	    mat3x4 _2178 = transpose(gl_WorldToObjectEXT);
	    mat3 _339;
	    mat3 _2181 = _339;
	    _2181[0] = _2178[0].xyz;
	    _2181[1] = _2178[1].xyz;
	    _2181[2] = _2178[2].xyz;
	    _339 = _2181;
	    vec3 _2190 = normalize(_2181 * _344.xyz);
	    vec3 _294;
	    vec3 _2192 = _294;
	    _2192.x = _2190.x;
	    _2192.y = _2190.y;
	    _2192.z = _2190.z;
	    _294 = _2192;
	    vec3 _2200 = vec4(vsInput[2].vBlendValues.xyz, 1.0) * transpose(gl_ObjectToWorldEXT);
	    mat3x4 _2204 = transpose(gl_WorldToObjectEXT);
	    mat3 _338;
	    mat3 _2207 = _338;
	    _2207[0] = _2204[0].xyz;
	    _2207[1] = _2204[1].xyz;
	    _2207[2] = _2204[2].xyz;
	    _338 = _2207;
	    vec3 _2216 = normalize(_2207 * _345.xyz);
	    vec4 _292;
	    vec4 _2218 = _292;
	    _2218.x = _2216.x;
	    _2218.y = _2216.y;
	    _2218.z = _2216.z;
	    _2218.w = _345.w;
	    _292 = _2218;
	    vec4 _2227 = vsInput[2]._m1.xyxy;
	    vec4 _295;
	    vec4 _2228 = _295;
	    vec4 _2241 = _2227;
	    _2241.x = dot(_2227.xy, _326.xy) + _326.w;
	    _2241.y = dot(_2227.xy, _325.xy) + _325.w;
	    vec2 _2249 = _2241.xy + (_324.xy * PerViewConstantBuffer_t.g_flGameTime);
	    vec4 _2251 = _2241;
	    _2251.x = _2249.x;
	    _2251.y = _2249.y;
	    vec3 _2257 = mix(vec3(1.0), _2167.xyz, vec3(_322));
	    vec4 _2259 = _2167;
	    _2259.x = _2257.x;
	    _2259.y = _2257.y;
	    _2259.z = _2257.z;
	    vec3 _2267 = _2259.xyz * _323.xyz;
	    vec4 _2269 = _2259;
	    _2269.x = _2267.x;
	    _2269.y = _2267.y;
	    _2269.z = _2267.z;
	    _2228.x = vsInput[2]._m6.x;
	    _2228.y = vsInput[2]._m6.y;
	    _2228.z = vsInput[2]._m6.z;
	    _2228.w = max(vsInput[2]._m6.w, 0.100000001490116119384765625);
	    vec3 _264 = _2200;
	    vec3 _263 = _2192;
	    vec3 _2305 = ((_274 * ((1.0 - _20.barycentrics.x) - _20.barycentrics.y)) + (_268 * _20.barycentrics.x)) + (_2192 * _20.barycentrics.y);
	    vec3 _296;
	    vec4 _283 = ((_276 * ((1.0 - _20.barycentrics.x) - _20.barycentrics.y)) + (_270 * _20.barycentrics.x)) + (_2228 * _20.barycentrics.y);
	    vec3 _282 = _2305;
	    vec4 _281 = ((_273 * ((1.0 - _20.barycentrics.x) - _20.barycentrics.y)) + (_267 * _20.barycentrics.x)) + (_2251 * _20.barycentrics.y);
	    vec4 _280 = ((_272 * ((1.0 - _20.barycentrics.x) - _20.barycentrics.y)) + (_266 * _20.barycentrics.x)) + (_2269 * _20.barycentrics.y);
	    vec4 _279 = ((_271 * ((1.0 - _20.barycentrics.x) - _20.barycentrics.y)) + (_265 * _20.barycentrics.x)) + (_2218 * _20.barycentrics.y);
	    vec2 _310 = vec2(0.5);
	    vec3 _309 = vec3(0.0);
	    vec3 _308 = vec3(0.0);
	    bool _306 = false;
	    vec3 _2347 = _2305.xyz;
	    vec3 _307 = _2347;
	    if (dot(_2347, _2347) >= 1.0099999904632568359375)
	    {
	        _307 = _296.xyz;
	    }
	    vec3 _2354 = _307;
	    vec3 _2355 = normalize(_2354);
	    _307 = _2355;
	    vec2 _2359 = _310;
	    vec3 _302 = _309;
	    float _301 = _311;
	    vec3 _300 = _308;
	    vec3 _299 = _2355;
	    vec3 _298 = normalize(cross(_269 - _275, _2200 - _275));
	    bool _297 = _306;
	    vec2 _2375 = (_281.xy * _317.xy).xy;
	    vec4 _2395 = textureLod(sampler2D(g_bindless_Texture2D_float4[_312], g_bindless_Sampler[_321]), _2375, 0.0);
	    float _2396 = _2395.x;
	    float _2405 = smoothstep(max(0.0, _2396 - _283.w), min(1.0, _2396 + _283.w), _283.x);
	    vec3 _2409 = textureLod(sampler2D(g_bindless_Texture2D_float4[_316], g_bindless_Sampler[_320]), _281.xy, 0.0).xyzw.xyz * _280.xyz;
	    vec4 _2411;
	    _2411.x = _2409.x;
	    _2411.y = _2409.y;
	    _2411.z = _2409.z;
	    vec3 _2418 = textureLod(sampler2D(g_bindless_Texture2D_float4[_315], g_bindless_Sampler[_320]), _2375, 0.0).xyzw.xyz * _280.xyz;
	    vec4 _2420;
	    _2420.x = _2418.x;
	    _2420.y = _2418.y;
	    _2420.z = _2418.z;
	    vec4 _2432 = mix(textureLod(sampler2D(g_bindless_Texture2D_float4[_314], g_bindless_Sampler[_320]), _281.xy, 0.0).xyzw, textureLod(sampler2D(g_bindless_Texture2D_float4[_313], g_bindless_Sampler[_320]), _2375, 0.0).xyzw, vec4(_2405));
	    vec3 _305 = mix(_2411.xyz, _2420.xyz, vec3(_2405)).xyz;
	    float _303 = mix(_319, _318, _2405);
	    _2359.x = _2432.z;
	    _2359.y = _2432.z;
	    vec2 _304 = _2359;
	    float _2443 = _2432.x;
	    float _2444 = _2432.y;
	    float _2446 = (_2443 + _2444) - 1.00392162799835205078125;
	    float _2447 = _2443 - _2444;
	    vec3 _336 = normalize(vec3(vec2(_2446, _2447), (1.0 - abs(_2446)) - abs(_2447)));
	    float _337;
	    if (false)
	    {
	        _337 = -1.0;
	    }
	    else
	    {
	        _337 = 1.0;
	    }
	    float _2459 = _337;
	    vec3 _2460 = _282.xyz * _2459;
	    if (_279.w > 0.0)
	    {
	        _337 = 1.0;
	    }
	    else
	    {
	        _337 = -1.0;
	    }
	    if (!false)
	    {
	        vec3 _2474 = _336;
	        _2474.y = -_2474.y;
	        _336 = _2474;
	    }
	    vec3 _2481 = _279.xyz * _336.x;
	    vec3 _335;
	    vec3 _2483 = _335;
	    _2483.x = _2481.x;
	    _2483.y = _2481.y;
	    _2483.z = _2481.z;
	    vec3 _2493 = _2483.xyz + ((cross(_2460.xyz, _279.xyz) * _337).xyz * _336.y);
	    vec3 _2495 = _2483;
	    _2495.x = _2493.x;
	    _2495.y = _2493.y;
	    _2495.z = _2493.z;
	    vec3 _2504 = _2495.xyz + (_2460.xyz * _336.z);
	    vec3 _2506 = _2495;
	    _2506.x = _2504.x;
	    _2506.y = _2504.y;
	    _2506.z = _2504.z;
	    _335 = _2506;
	    _19._m5 = int(uint(gl_InstanceID));
	    _19._m3 = gl_RayTmaxEXT;
	    _19._m1 = _298;
	    _19._m2 = _299;
	    vec3 _327[3] = vec3[](_274, _268, _263);
	    vec3 _328[3] = vec3[](_275, _269, _264);
	    vec3 _2547 = ((_275 * ((1.0 - _20.barycentrics.x) - _20.barycentrics.y)) + (_269 * _20.barycentrics.x)) + (_264 * _20.barycentrics.y);
	    vec3 _329[3];
	    _329[0] = _2547 - (_274 * dot(_2547 - _275, _274));
	    _329[1] = _2547 - (_268 * dot(_2547 - _269, _268));
	    _329[2] = _2547 - (_263 * dot(_2547 - _264, _263));
	    vec3 _2575 = ((_329[0] * ((1.0 - _20.barycentrics.x) - _20.barycentrics.y)) + (_329[1] * _20.barycentrics.x)) + (_329[2] * _20.barycentrics.y);
	    vec3 _330[3];
	    _330[0] = cross(_275 - _269, _19._m1);
	    _330[1] = cross(_269 - _264, _19._m1);
	    _330[2] = cross(_264 - _275, _19._m1);
	    float _331 = dot(_2575 - _2547, _19._m1);
	    vec3 _332 = _2575;
	    int _333 = 0;
	    for (;;)
	    {
	        bool _2591_ladder_break = false;
	        do
	        {
	            if (!(_333 < 3))
	            {
	                _2591_ladder_break = true;
	                break;
	            }
	            if (_331 > 0.00999999977648258209228515625)
	            {
	                _2591_ladder_break = true;
	                break;
	            }
	            if (dot(_330[_333], _330[_333]) == 0.0)
	            {
	                break;
	            }
	            _330[_333] = normalize(_330[_333]);
	            int _334 = 0;
	            for (;;)
	            {
	                if (!(_334 < 3))
	                {
	                    break;
	                }
	                vec3 _2629 = _327[_334] - (_330[_333] * dot(_330[_333], _327[_334]));
	                _329[_334] = _2547 - (_2629 * dot(_2547 - _328[_334], _2629));
	                _334++;
	                continue;
	            }
	            vec3 _2653 = ((_329[0] * ((1.0 - _20.barycentrics.x) - _20.barycentrics.y)) + (_329[1] * _20.barycentrics.x)) + (_329[2] * _20.barycentrics.y);
	            _331 = dot(_2653 - _2547, _19._m1);
	            _332 = _2653;
	            break;
	        } while(false);
	        if (_2591_ladder_break)
	        {
	            break;
	        }
	        _333++;
	        continue;
	    }
	    if (!(_331 > 0.00999999977648258209228515625))
	    {
	        _332 = vec3(3.4028234663852885981170418348452e+38);
	    }
	    _19.material = _332;
	    _19._m6 = _297;
	    f16vec3 _2666 = f16vec3(vec3(0.0));
	    _19._m7 = MaterialDataMinimal_t(_2666, float16_t(0.0), f16vec3(vec3(1.0, 0.0, 1.0)), float16_t(1.0), _2666, float16_t(0.040008544921875), 0u, f16vec4(ivec4(0)));
	    _19._m7.vMaterialBits = f16vec3(normalize(_2506.xyz));
	    _19._m7._m2 = f16vec3(_305);
	    _19._m7._m4 = f16vec3(_302);
	    _19._m7._m5 = float16_t(_301);
	    _19._m7._m1 = float16_t(_303);
	    _19._m7._m3 = float16_t(dot(_304, vec2(0.5)));
	    if (any(greaterThan(_300, vec3(0.0))))
	    {
	        f16vec4 _2695 = _19._m7._m7;
	        f16vec3 _2698 = f16vec3(_300);
	        _2695.x = _2698.x;
	        _2695.y = _2698.y;
	        _2695.z = _2698.z;
	        _19._m7 = MaterialDataMinimal_t(_19._m7.vMaterialBits, _19._m7._m1, _19._m7._m2, _19._m7._m3, _19._m7._m4, _19._m7._m5, (_19._m7._m6 & 4294901760u) | 1u, _2695);
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
