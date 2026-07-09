//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "Environment shader with blended layers";
	DevShader = false;
	Version = 5;
	
	// VcsVersion: 71
	// Platform: VULKAN_SM_60
	// Programs: ps, psrs, rtx, vs
}

MODES
{
	CsgoForward();
	RayTrace();
	Depth(S_MODE_DEPTH);
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
	Feature( F_DETAIL_NORMAL, 0..1, "Detail" );
	Feature( F_WETNESS, 0..1, "Wetness" );
	Feature( F_MATERIAL_REFERENCE, 0..1, "Create Variation" );
	Feature( F_ALPHA_TEST, 0..1, "Translucent" );
	Feature( F_OCCLUSION_CULLING_BOUNDS_SCALE, 0..1, "Z-Buffering" );
	FeatureRule( Requires( F_DONT_FLIP_BACKFACE_NORMALS, F_RENDER_BACKFACES ), "Only applies to backfaces" );
}

COMMON
{
	#include "system.fxc"
}

struct VS_INPUT
{
	float4 vBlendIndices              : BLENDINDICES0  < Semantic( BlendIndices ); >;              // D_CS_VERTEX_ANIMATION=0
	float4 vBlendColorTint            : COLOR0         < Semantic( VertexPaintTintColor ); >;      // S_MODE_DEPTH=0, S_MODE_TOOLS_VIS=1, S_ALPHA_TEST_LAYER=1
	float4 vPerVertexLighting         : COLOR1         < Semantic( PerVertexLighting ); >;        
	uint4  nPackedFrame               : NORMAL0        < Semantic( CompressedTangentFrame ); >;   
	float4 vNormalOs                  : NORMAL0        < Semantic( Normal ); >;                   
	float3 vPositionOs                : POSITION0      < Semantic( PosXyz ); >;                    // D_CS_VERTEX_ANIMATION=0
	float4 vTangentUOs_flTangentVSign : TANGENT0       < Semantic( TangentU_SignV ); >;           
	float2 vLightmapUV                : TEXCOORD3      < Semantic( LightmapUV ); >;               
	float2 vTexCoord                  : TEXCOORD0      < Semantic( LowPrecisionUv ); >;            // S_MODE_DEPTH=0, S_MODE_TOOLS_VIS=1, S_ALPHA_TEST_LAYER=1
	float2 vTexCoord2                 : TEXCOORD1      < Semantic( LowPrecisionUv1 ); >;           // S_MODE_DEPTH=0, S_MODE_TOOLS_VIS=1, S_ALPHA_TEST_LAYER=1
	float4 vColorBlendValues          : TEXCOORD4      < Semantic( VertexPaintBlendParams ); >;    // S_MODE_DEPTH=0, S_MODE_TOOLS_VIS=1, S_ALPHA_TEST_LAYER=1
	float2 nInstanceIdx               : TEXCOORD13     < Semantic( InstanceTransformUv ); >;      
};

VS
{
	StaticCombo( S_DETAIL_NORMAL, F_DETAIL_NORMAL );
	StaticCombo( S_MATERIAL_REFERENCE, F_MATERIAL_REFERENCE );
	StaticCombo( S_MODE_TOOLS_VIS, 0..1 );
	StaticCombo( S_ALPHA_TEST_LAYER, F_ALPHA_TEST );
	StaticCombo( S_MODE_DEPTH, 0..1 );
	StaticComboRule( Allow1( S_MODE_TOOLS_VIS, S_MODE_DEPTH ) );
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
	float4 g_vDetailTexCoordXform0_1 < UiType(VectorText); Expression(v0 = (g_flDetailTexCoordRotation1*3.1415927)/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v1*g_vDetailTexCoordScale1.x,-v2*g_vDetailTexCoordScale1.y,0,((g_vDetailTexCoordCenter1.x+g_vDetailTexCoordOffset1.x)+(v2*g_vDetailTexCoordCenter1.y))-(v1*g_vDetailTexCoordCenter1.x))); >;
	float4 g_vDetailTexCoordXform1_1 < UiType(VectorText); Expression(v0 = (g_flDetailTexCoordRotation1*3.1415927)/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v2*g_vDetailTexCoordScale1.x,v1*g_vDetailTexCoordScale1.y,0,(g_vDetailTexCoordCenter1.y+g_vDetailTexCoordOffset1.y)-((v2*g_vDetailTexCoordCenter1.x)+(v1*g_vDetailTexCoordCenter1.y)))); >;
	float4 g_vTexCoordScaleByModelU < UiType(VectorText); Expression(float4((g_nScaleTexCoordUByModelScaleAxis==1) || 0,(g_nScaleTexCoordUByModelScaleAxis==2) || 0,(g_nScaleTexCoordUByModelScaleAxis==3) || 0,(g_nScaleTexCoordUByModelScaleAxis==0) || 0)); >;
	float4 g_vTexCoordScaleByModelV < UiType(VectorText); Expression(float4((g_nScaleTexCoordVByModelScaleAxis==1) || 0,(g_nScaleTexCoordVByModelScaleAxis==2) || 0,(g_nScaleTexCoordVByModelScaleAxis==3) || 0,(g_nScaleTexCoordVByModelScaleAxis==0) || 0)); >;
	float4 g_vTexCoordXform0_1 < UiType(VectorText); Expression(v0 = (g_flTexCoordRotation1*3.1415927)/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v1*g_vTexCoordScale1.x,-v2*g_vTexCoordScale1.y,0,((g_vTexCoordCenter1.x+g_vTexCoordOffset1.x)+(v2*g_vTexCoordCenter1.y))-(v1*g_vTexCoordCenter1.x))); >;
	float4 g_vTexCoordXform1_1 < UiType(VectorText); Expression(v0 = (g_flTexCoordRotation1*3.1415927)/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v2*g_vTexCoordScale1.x,v1*g_vTexCoordScale1.y,0,(g_vTexCoordCenter1.y+g_vTexCoordOffset1.y)-((v2*g_vTexCoordCenter1.x)+(v1*g_vTexCoordCenter1.y)))); >;
	
	// Material1
	int g_nUVSet1 < Default(1); Range4(0, 0, 0, 0, 2, 2, 2, 2); UiOptions("0=Biplanar,1=UV1,2=UV2"); UiType(Enum); UiGroup("Material1/Texture Coordinates,34/1"); >;
	float2 g_vTexCoordCenter1 < Default2(0.5, 0.5); Attribute("0=X,1=Y"); UiType(VectorText); UiGroup("Material1/Texture Transform,35/1"); UiVisibility(1); >;
	int g_nDetailUVSet1 < Default(-1); Range4(-1, -1, -1, -1, 2, 2, 2, 2); UiOptions("-1=Inherit,0=Biplanar,1=UV1,2=UV2"); UiType(Enum); UiGroup("Material1/Texture Coordinates,34/2"); >;
	float2 g_vTexCoordScale1 < Default2(1, 1); Range2(0, 0, 100, 100); Attribute("0=X,1=Y"); UiType(VectorText); UiGroup("Material1/Texture Transform,35/2"); >;
	float2 g_vTexCoordOffset1 < Range2(-1, -1, 1, 1); Attribute("0=X,1=Y"); UiType(VectorText); UiGroup("Material1/Texture Transform,35/4"); UiVisibility(1); >;
	float2 g_vDetailTexCoordCenter1 < Default2(0.5, 0.5); Attribute("0=X,1=Y"); UiType(VectorText); UiGroup("Material1/Detail Texture Transform/5"); UiVisibility(1); >;
	float2 g_vDetailTexCoordScale1 < Default2(1, 1); Range2(0, 0, 100, 100); Attribute("0=X,1=Y"); UiType(VectorText); UiGroup("Material1/Detail Texture Transform/6"); >;
	float g_flDetailTexCoordRotation1 < Range(-360, 360); UiType(Slider); UiGroup("Material1/Detail Texture Transform/8"); UiVisibility(1); >;
	float2 g_vDetailTexCoordOffset1 < Range2(-1, -1, 1, 1); Attribute("0=X,1=Y"); UiType(VectorText); UiGroup("Material1/Detail Texture Transform/9"); UiVisibility(1); >;
	float g_flTexCoordRotation1 < Range(-360, 360); UiType(Slider); UiGroup("Material1/Texture Transform,35/13"); UiVisibility(1); >;
	
	// Color
	float3 g_vColorTint < Default3(1, 1, 1); UiType(Color); UiGroup("Color,10/20"); Expression(SrgbGammaToLinear(this)); >;
	float g_flModelTintAmount < Default(1); UiType(Slider); UiGroup("Color,10/30"); >;
	int g_nScaleTexCoordUByModelScaleAxis < Range4(0, 0, 0, 0, 3, 3, 3, 3); UiOptions("0=None,1=UV.u * model.x,2=UV.u * model.y,3=UV.u * model.z"); UiType(Enum); UiGroup("Color/80"); >;
	int g_nScaleTexCoordVByModelScaleAxis < Range4(0, 0, 0, 0, 3, 3, 3, 3); UiOptions("0=None,1=UV.v * model.x,2=UV.v * model.y,3=UV.v * model.z"); UiType(Enum); UiGroup("Color/90"); >;
	
	// SPIR-V reflection failed for backend HLSL:
	// cbuffer ID 5618 (name: _Globals_), member index 0 (name: g_vColorTint) cannot be expressed with either HLSL packing layout or packoffset.
	//
	// Re-attempting reflection with the GLSL backend.
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (7220 bytes), GLSL reflection with SPIRV-Cross by KhronosGroup
	
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
	
	struct _1224
	{
	    mat4 _m0;
	    vec4 _m1;
	};
	
	layout(set = 0) uniform _1224 PerViewConstantBuffer_t;
	
	struct _1269
	{
	    vec3 g_vColorTint;
	    float g_flModelTintAmount;
	    int g_nUVSet1;
	    vec4 g_vTexCoordXform0_1;
	    vec4 g_vTexCoordXform1_1;
	};
	
	layout(set = 0) uniform _1269 _Globals_;
	
	struct _1017
	{
	    vec4 _m0;
	};
	
	layout(set = 0) uniform _1017 PerViewConstantBufferCsgo_t;
	
	layout(location = 0) in vec3 vPositionOs;
	layout(location = 1) in vec2 vTexCoord;
	layout(location = 2) in vec2 vTexCoord2;
	layout(location = 3) in vec3 vNormalOs;
	layout(location = 4) in vec4 vTangentUOs_flTangentVSign;
	layout(location = 5) in uvec4 vBlendIndices;
	layout(location = 6) in uint nInstanceIdx;
	layout(location = 7) in vec4 vColorBlendValues;
	layout(location = 8) in vec4 vBlendColorTint;
	layout(location = 0) out vec4 output_0;
	layout(location = 1) out vec4 output_1;
	layout(location = 2) out vec3 output_2;
	layout(location = 3) out vec3 output_3;
	layout(location = 4) out vec4 output_4;
	layout(location = 5) centroid out vec4 output_5;
	layout(location = 6) centroid out vec3 output_6;
	layout(location = 7) out vec4 output_7;
	layout(location = 8) flat out uint output_8;
	
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
	    vec3 _11179 = normalize(vec4(vNormalOs.xyz, 0.0) * _21957._m0);
	    vec3 _12151 = vec4(vPositionOs.xyz * _19321.xyz, 1.0) * _21957._m0;
	    vec4 _18237 = (vec4(_12151.xyz, 1.0) + (PerViewConstantBuffer_t._m1 * 1.0)).xyzw * PerViewConstantBuffer_t._m0;
	    vec4 _9337 = vTexCoord.xyxy;
	    _9337.z = vTexCoord2.x;
	    _9337.w = vTexCoord2.y;
	    vec4 _18606;
	    if (_Globals_.g_nUVSet1 > 0)
	    {
	        vec4 _11399 = vec4(mix(_9337.xy, _9337.zw, bvec2(_Globals_.g_nUVSet1 == 2)), vTexCoord2);
	        vec2 _9573 = _11399.xy;
	        vec4 _16823 = _11399;
	        _16823.x = dot(_9573, _Globals_.g_vTexCoordXform0_1.xy) + _Globals_.g_vTexCoordXform0_1.w;
	        _16823.y = dot(_9573, _Globals_.g_vTexCoordXform1_1.xy) + _Globals_.g_vTexCoordXform1_1.w;
	        _18606 = _16823;
	    }
	    else
	    {
	        _18606 = _9337;
	    }
	    vec4 _11323 = vec4(_Globals_.g_vColorTint, _23812.w * _20228._m7);
	    vec3 _14119 = _11323.xyz * mix(vec3(1.0), vColorBlendValues.xyz, vec3(vColorBlendValues.w));
	    vec4 _23714 = _11323;
	    _23714.x = _14119.x;
	    _23714.y = _14119.y;
	    _23714.z = _14119.z;
	    output_0 = vec4(_21354, _21355, _17978, _Globals_.g_flModelTintAmount * (1.0 - min(_21354, min(_21355, _17978))));
	    output_1 = vec4(vBlendColorTint.xyz, max(min(vBlendColorTint.w, 1.0), 0.001000000047497451305389404296875));
	    output_2 = _12151.xyz - PerViewConstantBufferCsgo_t._m0.xyz;
	    output_3 = _11179;
	    output_4 = _18606;
	    output_5 = _23714;
	    output_6 = _11179;
	    output_7 = vec4(normalize(vec4(vTangentUOs_flTangentVSign.xyz, 0.0) * _21957._m0), vTangentUOs_flTangentVSign.w);
	    output_8 = _20228._m5 & 65535u;
	    _18237.y = -_18237.y;
	    gl_Position = _18237;
	}
	
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
	
	BoolAttribute(BindlessResources, true);
	StringAttribute(MaterialLayerRefType, csgo_environment);
	BoolAttribute(environmentmapped, true);
	BoolAttribute(environmentmappeddynamic, true);
	BoolAttribute(CanBatchWithDynamicShaderConstants, true);
	IntAttribute(TexCoordScaleByModelU, g_nScaleTexCoordUByModelScaleAxis-1);
	IntAttribute(TexCoordScaleByModelV, g_nScaleTexCoordVByModelScaleAxis-1);
	Float3Attribute(LightSim_MaterialTint, g_vColorTint);
	BoolAttribute(VertexPaintUIPickColor, true);
	BoolAttribute(GroupDefaultCollapseState_TextureTransform, true);
	BoolAttribute(GroupDefaultCollapseState_DetailTextureTransform, true);
	BoolAttribute(HasTexcoordTransform, ((g_nUVSet1>0) && (((g_vTexCoordScale1.x!=1) || (g_vTexCoordScale1.y!=1)) || (g_flTexCoordRotation1!=0))) || 0);
	BoolAttribute(VertexPaintUIAlphaBlendFactor, true);
	BoolAttribute(VertexPaintUIPuddles, (F_WETNESS==1) || 0);
	BoolAttribute(SupportsAggregateInstancing, true);
	
	#if (S_MATERIAL_REFERENCE == 1)
		IntAttribute(MaterialLayerCount, 1);
		StringAttribute(MaterialLayerType, csgo_environment);
	#endif
}

PS
{
	StaticCombo( S_DETAIL_NORMAL, F_DETAIL_NORMAL );
	StaticCombo( S_MATERIAL_REFERENCE, F_MATERIAL_REFERENCE );
	StaticCombo( S_ALPHA_TEST_LAYER, F_ALPHA_TEST );
	StaticCombo( S_MODE_TOOLS_VIS, 0..1 );
	StaticCombo( S_SHADER_QUALITY, 0..1 );
	StaticCombo( S_MODE_DEPTH, 0..1 );
	StaticComboRule( Requires( S_MODE_TOOLS_VIS, S_SHADER_QUALITY ) );
	DynamicCombo( D_BAKED_LIGHTING_FROM_VERTEX_STREAM, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_PROBE, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_LIGHTMAP, 0..1 );
	DynamicCombo( D_OPAQUE_FADE, 0..1 );
	DynamicCombo( D_SPECULAR_CUBE_MAP_STATIC, 0..1 );
	DynamicCombo( D_ALPHA_TEST_PREPASS, 0..1 );
	DynamicComboRule( Allow1( D_BAKED_LIGHTING_FROM_PROBE, D_BAKED_LIGHTING_FROM_VERTEX_STREAM, D_BAKED_LIGHTING_FROM_LIGHTMAP ) );
	DynamicComboRule( Requires( D_SPECULAR_CUBE_MAP_STATIC, S_SHADER_QUALITY=1 ) );
	DynamicComboRule( Allow1( S_ALPHA_TEST_LAYER, D_OPAQUE_FADE ) );
	DynamicComboRule( Allow1( S_MODE_DEPTH, D_SPECULAR_CUBE_MAP_STATIC ) );
	DynamicComboRule( Requires( D_ALPHA_TEST_PREPASS, S_ALPHA_TEST_LAYER ) );
	
	cbuffer BakedLightingConstantBuffer_t < Attribute("BakedLightingConstantBuffer_t"); >;
	cbuffer PerViewConstantBufferCsgo_t < Attribute("PerViewConstantBufferCsgo_t"); >;
	cbuffer PerViewConstantBuffer_t < Attribute("PerViewConstantBuffer_t"); >;
	cbuffer PerViewLightProbeVolumeConstantBuffer_t < Attribute("PerViewLightProbeVolumeConstantBuffer_t"); >;
	cbuffer PerViewLightingConstantBufferGpu_t < Attribute("PerViewLightingConstantBufferGpu_t"); >;
	StructuredBuffer g_BarnLights < Attribute("BarnLights"); >;
	StructuredBuffer g_CullBits < Attribute("CullBits"); >;
	bool g_bAdjustBaseColor1 < UiType(CheckBox); Expression(g_nColorCorrectionMode1==1); >;
	bool g_bCubemapNormalization < Attribute("g_bCubemapNormalization"); UiType(CheckBox); >;
	bool g_bDisableNormalMapping < Attribute("g_bDisableNormalMapping"); UiType(CheckBox); >;
	bool g_bDontFlipBackfaceNormals < UiType(CheckBox); Expression(F_DONT_FLIP_BACKFACE_NORMALS || 0); >;
	bool g_bHighlightDeprecated < Attribute("g_bHighlightDeprecated"); UiType(CheckBox); >;
	bool g_bIsDeprecated < Attribute("bIsDeprecated"); UiType(CheckBox); >;
	bool g_bRenderBackfaceNormals < UiType(CheckBox); Expression((F_RENDER_BACKFACES && 1) || 0); >;
	bool g_bRenderingToCubemaps < Attribute("g_bRenderingToCubemaps"); UiType(CheckBox); >;
	bool g_bShowLPVVoxels < Attribute("g_bShowLPVVoxels"); UiType(CheckBox); >;
	bool g_bShowLightmapTexels < Attribute("g_bShowLightmapTexels"); UiType(CheckBox); >;
	bool g_bWetness < UiType(CheckBox); Expression((F_WETNESS==1) || 0); >;
	float g_fToolsVisHeightTint < Default(0.9); Attribute("g_fToolsVisHeightTint"); UiType(Slider); >;
	float g_fToolsVisMaxHeightRange < Default(1); Attribute("g_fToolsVisMaxHeightRange"); UiType(Slider); >;
	float g_fToolsVisMaxLightingComplexity < Default(8); Attribute("g_fToolsVisMaxLightingComplexity"); UiType(Slider); >;
	float g_flReflectance < UiType(Slider); Expression(pow((1.5-1)/(1.5+1),2)); >;
	ExternalDescriptorSet g_globalLateBoundBindlessSet < Source(ExternalDescSet); Attribute("g_globalLateBoundBindlessSet"); >;
	ExternalDescriptorSet g_lightBinnerGpuSet < Source(ExternalDescSet); Attribute("g_lightBinnerGpuSet"); >;
	float4x4 g_mTextureAdjust1 < Expression(MatrixMultiply(MatrixColorTint2(float3(1,1,1),1),MatrixColorCorrect2(float3(g_fTextureColorContrast1,g_fTextureColorSaturation1,g_fTextureColorBrightness1),TextureAverageColor(g_tColor1)))); >;
	float4x4 g_mTextureColorAdjust1 < Expression(MatrixMultiply(MatrixColorTint2(g_vTextureColorTint1,1),MatrixColorCorrect2(float3(g_fTextureColorContrast1,g_fTextureColorSaturation1,g_fTextureColorBrightness1),TextureAverageColor(g_tColor1)))); >;
	float4x4 g_mTextureColorAdjust1 < Expression(MatrixMultiply(MatrixColorTint2(float3(1,1,1),1),MatrixColorCorrect2(float3(1,1,1),TextureAverageColor(g_tColor1)))); >;
	int g_nToolsVisMode < Attribute("g_nToolsVisMode"); UiType(Slider); >;
	Texture2D g_tColor1 < Channel(RGB, ArtistDefined(TextureColor1), Srgb); Channel(A, Box(TextureAmbientOcclusion1), Linear); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tColor1 < Channel(RGB, ArtistDefinedOrAlphaWeighted(TextureColor1, TextureTranslucency1), Srgb); Channel(A, PreserveCoverage(TextureTranslucency1), Linear); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tHeight1 < Channel(R, ArtistDefined(TextureHeight1), Linear); Channel(G, ArtistDefined(TextureTintMask1), Linear); Channel(A, Box(TextureMetalness1), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tHeight1 < Channel(R, ArtistDefined(TextureHeight1), Linear); Channel(G, ArtistDefined(TextureTintMask1), Linear); Channel(B, Box(TextureAmbientOcclusion1), Linear); Channel(A, Box(TextureMetalness1), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tNormal1 < Channel(RGBA, HemiOctIsoRoughness_RG_B(TextureNormal1, TextureRoughness1), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tNormalDetail1 < Channel(RG, HemiOctIsoRoughness_RG_B(TextureNormalDetail1), Linear); OutputFormat(ATI2N); SrgbRead(false); >;
	float3 g_vBiplanarTexCoordScale < UiType(VectorText); Expression((1/64)*float3(-1,1,-1)); >;
	float4 g_vDetailNormalXform_1 < UiType(VectorText); Expression(v0 = (g_flDetailTexCoordRotation1*3.1415927)/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v1,-v2,v2,v1)); >;
	float3 g_vFlatOverlayColor < Default2(1, 0); Attribute("FlatOverlayColor"); UiType(VectorText); >;
	float4 g_vNormalXform_1 < UiType(VectorText); Expression(v0 = (g_flTexCoordRotation1*3.1415927)/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v1,-v2,v2,v1)); >;
	float4 g_vShaderIDColor < Source(ShaderIDColor); UiType(VectorText); >;
	
	// Material1
	CreateInputTexture2D(TextureColor1, Srgb, 8, "", "_color", "Material1,0/Color,10/0", Default4(1, 1, 1, 0));
	CreateInputTexture2D(TextureNormal1, Linear, 8, "NormalizeNormals", "_normal", "Material1/Lighting/0", Default4(0.5, 0.5, 1, 0));
	CreateInputTexture2D(TextureTintMask1, Linear, 8, "", "_mask", "Material1/Tint Mask,15/0", Default4(1, 1, 1, 0));
	CreateInputTexture2D(TextureTranslucency1, Linear, 8, "", "_trans", "Material1/Translucent,15/0", Default4(1, 1, 1, 0));
	int g_nUVSet1 < Default(1); Range4(0, 0, 0, 0, 2, 2, 2, 2); UiOptions("0=Biplanar,1=UV1,2=UV2"); UiType(Enum); UiGroup("Material1/Texture Coordinates,34/1"); >;
	int g_nDetailUVSet1 < Default(-1); Range4(-1, -1, -1, -1, 2, 2, 2, 2); UiOptions("-1=Inherit,0=Biplanar,1=UV1,2=UV2"); UiType(Enum); UiGroup("Material1/Texture Coordinates,34/2"); >;
	float2 g_vTexCoordScale1 < Default2(1, 1); Range2(0, 0, 100, 100); Attribute("0=X,1=Y"); UiType(VectorText); UiGroup("Material1/Texture Transform,35/2"); >;
	float g_fTintMaskBrightness1 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material1/Tint Mask/5"); >;
	float2 g_vDetailTexCoordScale1 < Default2(1, 1); Range2(0, 0, 100, 100); Attribute("0=X,1=Y"); UiType(VectorText); UiGroup("Material1/Detail Texture Transform/6"); >;
	float g_flDetailTexCoordRotation1 < Range(-360, 360); UiType(Slider); UiGroup("Material1/Detail Texture Transform/8"); UiVisibility(1); >;
	CreateInputTexture2D(TextureHeight1, Linear, 8, "", "_height", "Material1/Height,30/10", Default4(0.5, 0.5, 0.5, 0));
	CreateInputTexture2D(TextureRoughness1, Linear, 8, "Inverse", "_rough", "Material1/Lighting/10", Default4(0.5, 0.5, 0.5, 0));
	float g_fTintMaskContrast1 < Default(1); Range(-2, 4); UiType(Slider); UiGroup("Material1/Tint Mask/10"); >;
	float3 g_vTextureColorTint1 < Default3(1, 1, 1); UiType(Color); UiGroup("Material1/Color Correction,17/10"); >;
	float g_fTextureRoughnessContrast1 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material1/Lighting/11"); >;
	float g_fTextureRoughnessBrightness1 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material1/Lighting/12"); >;
	float g_fTextureNormalContrast1 < Default(1); Range(-2, 2); UiType(Slider); UiGroup("Material1/Lighting/13"); >;
	float g_flTexCoordRotation1 < Range(-360, 360); UiType(Slider); UiGroup("Material1/Texture Transform,35/13"); UiVisibility(1); >;
	bool g_bMetalness1 < Default(1); UiType(CheckBox); UiGroup("Material1/Lighting/14"); >;
	CreateInputTexture2D(TextureAmbientOcclusion1, Linear, 8, "", "_ao", "Material1/Lighting,20/20", Default4(1, 1, 1, 0));
	float g_fTextureColorContrast1 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material1/Color Correction/20"); >;
	float g_flHeightMapScale1 < Default(1); Range(-4, 4); UiType(Slider); UiGroup("Material1/Height/20"); >;
	float3 g_vAmbientOcclusionLevels1 < Default2(0, 0.5); Range(-1, 1); Attribute("0=Option 1,1=Option 2,2=Option 3"); UiType(VectorText); UiGroup("Material1/Lighting/21"); Expression(float3(-this.x,-1.4427*log(max(.0001,1-this.y)),2-this.z)); >;
	CreateInputTexture2D(TextureMetalness1, Linear, 8, "", "_metal", "Material1/Lighting/30", Default4(0, 0, 0, 0));
	float g_fTextureColorSaturation1 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material1/Color Correction/30"); >;
	float g_flHeightMapZeroPoint1 < Default(0.5); UiType(Slider); UiGroup("Material1/Height/30"); >;
	CreateInputTexture2D(TextureNormalDetail1, Linear, 8, "NormalizeNormals", "_normal", "Material1/Detail/35", Default4(0.5, 0.5, 1, 0));
	float g_fTextureColorBrightness1 < Default(1); Range(-8, 8); UiType(Slider); UiGroup("Material1/Color Correction/40"); >;
	float g_fDetailTextureNormalContrast1 < Default(1); Range(-2, 2); UiType(Slider); UiGroup("Material1/Detail/45"); >;
	int g_nColorCorrectionMode1 < UiOptions("0=Mask All,1=Mask only Tint"); UiType(Enum); UiGroup("Material1/Color Correction/45"); >;
	bool g_bModelTint1 < Default(1); UiType(CheckBox); UiGroup("Material1/Color Correction/60"); >;
	float g_flWetnessDarkeningStrength1 < Default(1); UiType(Slider); UiGroup("Material1/Lighting/61"); >;
	bool g_bSnowLayer1 < UiType(CheckBox); UiGroup("Material1/Snow,100"); >;
	
	// Fog
	bool g_bFogEnabled < Default(1); UiType(CheckBox); UiGroup("Fog"); >;
	
	// Wetness
	bool g_bWetnessUseHeightmapAdjustments < UiType(CheckBox); UiGroup("Wetness/2"); UiVisibility(F_WETNESS || 0); >;
	bool g_bPuddlesOnVerticalSurfaces < UiType(CheckBox); UiGroup("Wetness,9/3"); UiVisibility(F_WETNESS || 0); >;
	float g_fPuddleStrength < Default(1); UiType(Slider); UiGroup("Wetness/5"); UiVisibility(F_WETNESS || 0); >;
	float3 g_vPuddleSedimentColor < Default3(0.62, 0.56, 0.5); UiType(Color); UiGroup("Wetness/10"); Expression(SrgbGammaToLinear(this)); UiVisibility(F_WETNESS || 0); >;
	float g_fPuddleSedimentHeight < Default(0.9); Range(0, 2); UiType(Slider); UiGroup("Wetness/15"); Expression((this*2)-1); UiVisibility(F_WETNESS || 0); >;
	float g_fPuddleSedimentOpacity < Default(0.25); UiType(Slider); UiGroup("Wetness/16"); UiVisibility(F_WETNESS || 0); >;
	float g_fPuddleRoughness < Default(0.02); UiType(Slider); UiGroup("Wetness/17"); UiVisibility(F_WETNESS || 0); >;
	float g_fPuddleBlendSoftness < Default(0.08); UiType(Slider); UiGroup("Wetness/18"); UiVisibility(F_WETNESS || 0); >;
	float g_fWetEdgeStrength < Default(0.5); UiType(Slider); UiGroup("Wetness/20"); UiVisibility(F_WETNESS || 0); >;
	float g_fWetEdgeSpread < Default(0.2); UiType(Slider); UiGroup("Wetness/25"); UiVisibility(F_WETNESS || 0); >;
	float g_fWetnessStrength < Default(1); Range(0, 2); UiType(Slider); UiGroup("Wetness/30"); UiVisibility(F_WETNESS || 0); >;
	float g_fRainStrength < Default(1); Range(0, 2); UiType(Slider); UiGroup("Wetness/35"); UiVisibility(F_WETNESS || 0); >;
	float g_fRippleStrength < Default(1); Range(0, 2); UiType(Slider); UiGroup("Wetness/40"); UiVisibility(F_WETNESS || 0); >;
	
	// Translucent
	float g_flAlphaTestReference < Default(0.5); Range(0.01, 0.99); UiType(Slider); UiGroup("Translucent"); >;
	float g_flAntiAliasedEdgeStrength < Default(1); UiType(Slider); UiGroup("Translucent"); >;
	
	// Color
	float g_flBlendSoftnessDistanceModifierStrength < Default(1); UiType(Slider); UiGroup("Color/120"); >;
	
	// Occlusion Culling
	float g_flOcclusionCullingBoundsScale < Default(1); Range(1, 100); UiType(Slider); UiGroup("Occlusion Culling"); UiVisibility(F_OCCLUSION_CULLING_BOUNDS_SCALE); >;
	
	// Texture Address Mode
	int g_nTextureAddressModeU < UiOption("RsTextureAddressMode_t"); UiType(Enum); UiGroup("Texture Address Mode"); >;
	int g_nTextureAddressModeV < UiOption("RsTextureAddressMode_t"); UiType(Enum); UiGroup("Texture Address Mode"); >;
	
	#if (S_MODE_TOOLS_VIS == 1)
		Texture2D g_tColor1 < Channel(RGB, ArtistDefinedOrAlphaWeighted(TextureColor1, TextureTranslucency1), Srgb); Channel(A, PreserveCoverage(TextureTranslucency1), Linear); OutputFormat(BC7); SrgbRead(true); >;
	#endif
	#if (S_MODE_DEPTH == 1)
		Texture2D g_tColor1 < Channel(RGB, ArtistDefinedOrAlphaWeighted(TextureColor1, TextureTranslucency1), Srgb); Channel(A, PreserveCoverage(TextureTranslucency1), Linear); OutputFormat(BC7); SrgbRead(true); >;
	#endif
	#if (S_ALPHA_TEST_LAYER == 1)
		Texture2D g_tColor1 < Channel(RGB, ArtistDefinedOrAlphaWeighted(TextureColor1, TextureTranslucency1), Srgb); Channel(A, PreserveCoverage(TextureTranslucency1), Linear); OutputFormat(BC7); SrgbRead(true); >;
	#endif
	#if (S_SHADER_QUALITY == 1)
		Texture2D g_tColor1 < Channel(RGB, ArtistDefinedOrAlphaWeighted(TextureColor1, TextureTranslucency1), Srgb); Channel(A, PreserveCoverage(TextureTranslucency1), Linear); OutputFormat(BC7); SrgbRead(true); >;
	#endif
	
	// SPIR-V reflection failed for backend HLSL:
	// cbuffer ID 5618 (name: _Globals_), member index 5 (name: g_vBiplanarTexCoordScale) cannot be expressed with either HLSL packing layout or packoffset.
	//
	// Re-attempting reflection with the GLSL backend.
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (61788 bytes), GLSL reflection with SPIRV-Cross by KhronosGroup
	
	#version 460
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
	#extension GL_KHR_shader_subgroup_arithmetic : require
	
	const vec3 _2109[3] = vec3[](vec3(-1.0, 0.0, 0.0), vec3(0.0, 1.0, 0.0), vec3(-1.0, 0.0, 0.0));
	const vec3 _922[3] = vec3[](vec3(0.0, 0.0, 1.0), vec3(0.0, -1.0, 0.0), vec3(0.0, 0.0, 1.0));
	
	struct _2872
	{
	    vec4 _m0[3];
	};
	
	struct _71
	{
	    vec4 _m0[4];
	};
	
	struct _2139
	{
	    mat4 _m0[4];
	};
	
	struct _200
	{
	    mat4 _m0;
	    mat4 _m1;
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
	    mat4x3 _m15;
	    vec4 _m16;
	    vec4 _m17;
	    vec4 _m18;
	    vec4 _m19;
	    vec4 _m20;
	    vec3 _m21;
	    float _m22;
	    mat4 _m23;
	};
	
	float _4;
	vec3 _5;
	vec3 _6;
	vec4 _7;
	float _10;
	
	struct _2558
	{
	    uint g_sTrilinearWrap;
	    uint g_sTrilinearClamp;
	    uint g_sPointClamp;
	    uint g_sUserConfig;
	    uint g_tColor1;
	    vec3 g_vBiplanarTexCoordScale;
	    int g_bSnowLayer1;
	    int g_nUVSet1;
	    vec2 g_vTexCoordScale1;
	    vec4 g_vNormalXform_1;
	    float g_flWetnessDarkeningStrength1;
	    uint g_tNormal1;
	    uint g_tHeight1;
	    mat4 g_mTextureColorAdjust1;
	    int g_bPuddlesOnVerticalSurfaces;
	    int g_bWetnessUseHeightmapAdjustments;
	    float g_fPuddleStrength;
	    vec3 g_vPuddleSedimentColor;
	    float g_fPuddleSedimentHeight;
	    float g_fPuddleSedimentOpacity;
	    float g_fPuddleRoughness;
	    float g_fPuddleBlendSoftness;
	    float g_fWetEdgeStrength;
	    float g_fWetEdgeSpread;
	    float g_fWetnessStrength;
	    float g_fRainStrength;
	    float g_fRippleStrength;
	    uint g_sCookieSampler;
	    uint g_tShadowDepthBufferCmpSampler;
	    int g_bFogEnabled;
	    int g_bDontFlipBackfaceNormals;
	    int g_bRenderBackfaceNormals;
	    float g_flReflectance;
	    int g_bWetness;
	};
	
	layout(set = 1) uniform _2558 _Globals_;
	
	struct _698
	{
	    ivec4 _m0;
	    ivec4 _m1;
	    uint _m2;
	    uint _m3;
	    uint _m4;
	    uint _m5;
	    uint _m6;
	    uint _m7;
	    float _m8;
	    float _m9;
	    float _m10;
	    float _m11;
	    float _m12;
	    mat4 _m13;
	    vec2 _m14;
	    float _m15;
	    vec4 _m16;
	    vec4 _m17;
	    vec4 _m18;
	    vec4 _m19;
	    vec4 _m20;
	    vec4 _m21;
	    mat4 _m22;
	    vec4 _m23;
	    vec4 _m24;
	    vec4 _m25;
	    float _m26;
	};
	
	layout(set = 1) uniform _698 PerViewConstantBufferCsgo_t;
	
	struct _1337
	{
	    float _m0;
	    float _m1;
	    vec2 _m2;
	    vec2 _m3;
	    vec4 _m4;
	    vec3 _m5;
	};
	
	layout(set = 1) uniform _1337 PerViewConstantBuffer_t;
	
	struct _1992
	{
	    _2872 _m0;
	    _71 _m1;
	    vec4 _m2;
	    vec4 _m3;
	    vec4 _m4;
	    uvec4 _m5;
	    uvec4 _m6;
	    vec4 _m7;
	    vec4 _m8;
	    vec4 _m9;
	    vec4 _m10;
	    int _m11;
	    float _m12;
	    vec4 _m13;
	    float _m14;
	    float _m15;
	    float _m16;
	    float _m17;
	    _2139 _m18;
	    _71 _m19;
	    uint _m20;
	    uint _m21;
	};
	
	layout(set = 3) uniform _1992 PerViewLightingConstantBufferGpu_t;
	
	layout(set = 3, binding = 30, std430) readonly buffer g_CullBits
	{
	    uint _m0[];
	} g_CullBits_1;
	
	layout(set = 3, binding = 31, std430) readonly buffer g_BarnLights
	{
	    layout(row_major) _200 _m0[];
	} g_BarnLights_1;
	
	layout(set = 4, binding = 46) uniform texture2D g_bindless_Texture2D_float4[65536];
	layout(set = 4, binding = 29) uniform sampler g_bindless_Sampler[2048];
	layout(set = 4, binding = 29) uniform samplerShadow g_bindless_Sampler_1[2048];
	layout(set = 4, binding = 46) uniform texture3D g_bindless_Texture3D_float4[65536];
	layout(set = 4, binding = 46) uniform textureCubeArray g_bindless_TextureCubeArray_float4[65536];
	layout(set = 4, binding = 46) uniform textureCube g_bindless_TextureCube_float4[65536];
	
	layout(location = 0) in vec4 input_0;
	layout(location = 1) in vec4 input_1;
	layout(location = 2) in vec3 input_2;
	layout(location = 3) in vec3 input_3;
	layout(location = 4) in vec4 input_4;
	layout(location = 5) centroid in vec4 input_5;
	layout(location = 6) centroid in vec3 input_6;
	layout(location = 7) in vec4 input_7;
	layout(location = 0) out vec4 output_0;
	
	void main()
	{
	    vec4 _11408 = gl_FragCoord;
	    _11408.w = 1.0 / _11408.w;
	    vec3 _21709;
	    if (dot(input_3.xyz, input_3.xyz) >= 1.0099999904632568359375)
	    {
	        _21709 = input_6.xyz;
	    }
	    else
	    {
	        _21709 = input_3.xyz;
	    }
	    bool _14874 = _Globals_.g_bRenderBackfaceNormals != 0;
	    bool _12885;
	    if (_14874)
	    {
	        _12885 = _Globals_.g_bDontFlipBackfaceNormals == 0;
	    }
	    else
	    {
	        _12885 = false;
	    }
	    vec3 _10251;
	    SPIRV_CROSS_BRANCH
	    if (_12885)
	    {
	        _10251 = _21709 * (gl_FrontFacing ? 1.0 : (-1.0));
	    }
	    else
	    {
	        _10251 = _21709;
	    }
	    vec3 _24347 = normalize(_10251);
	    vec3 _10061 = input_2 + PerViewConstantBufferCsgo_t._m25.xyz;
	    bool _7312 = _Globals_.g_nUVSet1 > 1;
	    bool _21710;
	    if (PerViewConstantBufferCsgo_t._m26 > 1.9900000095367431640625)
	    {
	        _21710 = step(0.5, fract(PerViewConstantBuffer_t._m0 * 0.5)) != 0.0;
	    }
	    else
	    {
	        _21710 = !(PerViewConstantBufferCsgo_t._m26 > 0.9900000095367431640625);
	    }
	    vec3 _22993 = _10061 - PerViewConstantBuffer_t._m5.xyz;
	    bool _12886;
	    if (_14874)
	    {
	        _12886 = _Globals_.g_bDontFlipBackfaceNormals == 0;
	    }
	    else
	    {
	        _12886 = false;
	    }
	    bool _18545;
	    if (_12886)
	    {
	        _18545 = !gl_FrontFacing;
	    }
	    else
	    {
	        _18545 = false;
	    }
	    vec3 _7147 = dFdxFine(_22993);
	    vec3 _20949 = dFdyFine(_22993);
	    float _12157 = 1.0 / length(input_3);
	    vec3 _11587 = input_3 * _12157;
	    vec3 _8889;
	    if (_18545)
	    {
	        _8889 = _11587 * (-1.0);
	    }
	    else
	    {
	        _8889 = _11587;
	    }
	    vec3 _10247;
	    vec3 _11711;
	    if (_7312)
	    {
	        vec2 _13939 = dFdxFine(input_4.zw);
	        vec2 _13915 = dFdyFine(input_4.zw);
	        float _17522 = _13915.y;
	        float _15279 = dot(_13939, vec2(_17522, -_13915.x));
	        float _17298 = (_15279 < 0.0) ? (-1.0) : 1.0;
	        vec2 _24530 = vec2(_17522, -_13939.y) * _17298;
	        vec3 _7463 = ((_7147 - (_8889 * dot(_7147, _8889))) * _24530.x) + ((_20949 - (_8889 * dot(_20949, _8889))) * _24530.y);
	        vec3 _9082;
	        if (abs(_15279) > 0.0)
	        {
	            _9082 = normalize(_7463);
	        }
	        else
	        {
	            _9082 = _7463;
	        }
	        _11711 = _9082;
	        _10247 = cross(_8889, _9082) * (_17298 * float((dot(_20949, cross(_8889, _7147)) < 0.0) ? (-1) : 1));
	    }
	    else
	    {
	        _11711 = _5;
	        _10247 = _5;
	    }
	    bool _8452 = _Globals_.g_nUVSet1 == 0;
	    vec2 _6616;
	    ivec2 _13136;
	    vec2 _13694;
	    ivec2 _16305;
	    vec2 _17114;
	    vec2 _17115;
	    vec2 _17116;
	    vec2 _17117;
	    vec2 _17118;
	    if (_8452)
	    {
	        vec3 _10577 = abs(_24347);
	        vec3 _16100 = _10577;
	        float _17349 = _10577.x;
	        float _8043 = _10577.y;
	        bool _12887;
	        if (_17349 > _8043)
	        {
	            _12887 = _17349 > _10577.z;
	        }
	        else
	        {
	            _12887 = false;
	        }
	        ivec3 _23727;
	        if (_12887)
	        {
	            _23727 = ivec3(0, 1, 2);
	        }
	        else
	        {
	            _23727 = mix(ivec3(2, 0, 1), ivec3(1, 2, 0), bvec3(_8043 > _10577.z));
	        }
	        bool _12888;
	        if (_17349 < _8043)
	        {
	            _12888 = _17349 < _10577.z;
	        }
	        else
	        {
	            _12888 = false;
	        }
	        ivec3 _11775;
	        if (_12888)
	        {
	            _11775 = ivec3(0, 1, 2);
	        }
	        else
	        {
	            _11775 = mix(ivec3(2, 0, 1), ivec3(1, 2, 0), bvec3(_8043 < _10577.z));
	        }
	        ivec3 _19442 = (ivec3(3) - _11775) - _23727;
	        ivec2 _19321;
	        if (_23727.x == 1)
	        {
	            _19321 = _23727.zy;
	        }
	        else
	        {
	            _19321 = _23727.yz;
	        }
	        int _9992 = _19442.x;
	        ivec2 _19322;
	        if (_9992 == 1)
	        {
	            _19322 = _19442.zy;
	        }
	        else
	        {
	            _19322 = _19442.yz;
	        }
	        vec2 _19651 = clamp((vec2(_16100[_23727.x], _16100[_9992]) - vec2(0.577300012111663818359375)) * vec2(2.365744113922119140625), vec2(0.0), vec2(1.0));
	        vec3 _18781 = _10061 * _Globals_.g_vBiplanarTexCoordScale.xyz;
	        vec3 _16414 = _18781;
	        vec3 _16415 = dFdxFine(_18781);
	        vec3 _16446 = dFdyFine(_18781);
	        _13136 = _19321;
	        _16305 = _19322;
	        _17114 = vec2(_16414[_19321.x], _16414[_19321.y]);
	        _17115 = vec2(_16414[_19322.x], _16414[_19322.y]);
	        _17116 = vec2(_16415[_19321.x], _16415[_19321.y]);
	        _17117 = vec2(_16446[_19321.x], _16446[_19321.y]);
	        _17118 = vec2(_16415[_19322.x], _16415[_19322.y]);
	        _13694 = vec2(_16446[_19322.x], _16446[_19322.y]);
	        _6616 = _19651 / vec2(_19651.x + _19651.y);
	    }
	    else
	    {
	        _13136 = ivec2(0);
	        _16305 = ivec2(0);
	        _17114 = vec2(0.0);
	        _17115 = vec2(0.0);
	        _17116 = vec2(0.0);
	        _17117 = vec2(0.0);
	        _17118 = vec2(0.0);
	        _13694 = vec2(0.0);
	        _6616 = vec2(0.0);
	    }
	    vec3 _18905;
	    _18905.x = input_4.x;
	    _18905.y = input_4.y;
	    vec4 _9716;
	    vec3 _24878;
	    if (_8452)
	    {
	        _9716 = vec4(0.0);
	        _24878 = _18905;
	    }
	    else
	    {
	        vec4 _8625 = vec4(dFdx(_18905.xy), dFdy(_18905.xy));
	        vec2 _20312 = _18905.xy + vec2(length(_8625) * 1.0000000133514319600180897396058e-10);
	        vec3 _20488;
	        _20488.x = _20312.x;
	        _20488.y = _20312.y;
	        _9716 = _8625;
	        _24878 = _20488;
	    }
	    vec4 _19323;
	    if (_8452)
	    {
	        _19323 = (textureGrad(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tHeight1], g_bindless_Sampler[_Globals_.g_sUserConfig]), (_17114 * _Globals_.g_vTexCoordScale1.xy).xy, (_17116 * _Globals_.g_vTexCoordScale1.xy).xy, (_17117 * _Globals_.g_vTexCoordScale1.xy).xy) * _6616.x) + (textureGrad(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tHeight1], g_bindless_Sampler[_Globals_.g_sUserConfig]), (_17115 * _Globals_.g_vTexCoordScale1.xy).xy, (_17118 * _Globals_.g_vTexCoordScale1.xy).xy, (_13694 * _Globals_.g_vTexCoordScale1.xy).xy) * _6616.y);
	    }
	    else
	    {
	        _19323 = texture(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tHeight1], g_bindless_Sampler[_Globals_.g_sUserConfig]), _24878.xy).xyzw;
	    }
	    float _21711;
	    SPIRV_CROSS_BRANCH
	    if (_Globals_.g_bWetnessUseHeightmapAdjustments != 0)
	    {
	        _21711 = max(0.0, _19323.x);
	    }
	    else
	    {
	        _21711 = _19323.x;
	    }
	    float _13138;
	    vec3 _13189;
	    vec4 _22057;
	    if (_8452)
	    {
	        vec2 _8315 = (_17114 * _Globals_.g_vTexCoordScale1.xy).xy;
	        vec2 _7412 = (_17116 * _Globals_.g_vTexCoordScale1.xy).xy;
	        vec2 _8904 = (_17117 * _Globals_.g_vTexCoordScale1.xy).xy;
	        vec4 _23806 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tColor1], g_bindless_Sampler[_Globals_.g_sUserConfig]), _8315, _7412, _8904) * _6616.x;
	        vec4 _12167 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tNormal1], g_bindless_Sampler[_Globals_.g_sUserConfig]), _8315, _7412, _8904);
	        float _18178 = _12167.z * _6616.x;
	        float _15456 = _12167.x;
	        float _24534 = _12167.y;
	        float _16784 = (_15456 + _24534) - 1.00392162799835205078125;
	        float _11177 = _15456 - _24534;
	        vec3 _21631 = normalize(vec3(vec2(_16784, _11177), (1.0 - abs(_16784)) - abs(_11177))).xyz * _6616.x;
	        vec3 _24466 = (_2109[_13136.x] * _21631.x) + (_922[_13136.y] * _21631.y);
	        float _13137;
	        vec3 _13753;
	        vec4 _14101;
	        if (_6616.y > 0.0)
	        {
	            vec2 _17047 = (_17115 * _Globals_.g_vTexCoordScale1.xy).xy;
	            vec2 _10017 = (_17118 * _Globals_.g_vTexCoordScale1.xy).xy;
	            vec2 _8905 = (_13694 * _Globals_.g_vTexCoordScale1.xy).xy;
	            vec4 _12168 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tNormal1], g_bindless_Sampler[_Globals_.g_sUserConfig]), _17047, _10017, _8905);
	            float _13491 = _12168.x;
	            float _21308 = _12168.y;
	            float _16785 = (_13491 + _21308) - 1.00392162799835205078125;
	            float _11178 = _13491 - _21308;
	            vec3 _21632 = normalize(vec3(vec2(_16785, _11178), (1.0 - abs(_16785)) - abs(_11178))).xyz * _6616.y;
	            _13137 = _18178 + (_12168.z * _6616.y);
	            _14101 = _23806 + (textureGrad(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tColor1], g_bindless_Sampler[_Globals_.g_sUserConfig]), _17047, _10017, _8905) * _6616.y);
	            _13753 = _24466 + ((_2109[_16305.x] * _21632.x) + (_922[_16305.y] * _21632.y));
	        }
	        else
	        {
	            _13137 = _18178;
	            _14101 = _23806;
	            _13753 = _24466;
	        }
	        _13138 = _13137;
	        _13189 = normalize(_13753 + _24347);
	        _22057 = _14101;
	    }
	    else
	    {
	        vec4 _11179 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tNormal1], g_bindless_Sampler[_Globals_.g_sUserConfig]), _24878.xy, _9716.xy, _9716.zw);
	        float _6493 = _11179.x;
	        float _14881 = _11179.y;
	        float _16783 = (_6493 + _14881) - 1.00392162799835205078125;
	        float _11176 = _6493 - _14881;
	        vec3 _15162 = normalize(vec3(vec2(_16783, _11176), (1.0 - abs(_16783)) - abs(_11176)));
	        vec2 _20890 = _15162.xy;
	        float _7796 = dot(_20890, _Globals_.g_vNormalXform_1.xy);
	        float _19701 = dot(_20890, _Globals_.g_vNormalXform_1.zw);
	        vec3 _19582 = _15162;
	        _19582.x = _7796;
	        _19582.y = _19701;
	        bvec3 _20662 = bvec3(_7312);
	        vec3 _10844 = abs(_19582.xyz);
	        vec2 _16475 = (-vec2(_7796, (-1.0) * _19701)) / vec2(max(_10844.z, 0.0078125 * max(_10844.x, _10844.y)));
	        _13138 = _11179.z;
	        _13189 = normalize(_8889 - ((mix(input_7.xyz * _12157, _11711, _20662) * _16475.x) + (mix((cross(input_3, input_7.xyz) * ((input_7.w > 0.0) ? 1.0 : (-1.0))) * _12157, _10247, _20662) * _16475.y)));
	        _22057 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tColor1], g_bindless_Sampler[_Globals_.g_sUserConfig]), _24878.xy, _9716.xy, _9716.zw).xyzw;
	    }
	    vec3 _19225 = normalize(_13189);
	    float _6375 = saturate(_13138);
	    float _14713 = clamp(mix(0.0, 1.0, pow(_22057.w, 1.0)), 0.0, 1.0);
	    float _7029 = saturate(_19323.y);
	    vec3 _25191 = mix(_22057.xyz, vec4((vec4(_22057.xyz, 1.0) * _Globals_.g_mTextureColorAdjust1).xyz, _4).xyz, vec3(_7029));
	    vec4 _17842;
	    _17842.x = _25191.x;
	    _17842.y = _25191.y;
	    _17842.z = _25191.z;
	    float _24323 = dot(_17842.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125));
	    vec3 _9577 = normalize(max(input_0.xyz, vec3(0.001000000047497451305389404296875)));
	    bool _21618 = _Globals_.g_bSnowLayer1 != 0;
	    vec3 _6756 = _19225.xyz;
	    vec3 _6663 = vec4(clamp(mix(_17842.xyz, (_9577 * min(_24323 / dot(_9577.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125)), (3.0 * _24323) * max(input_0.x, max(input_0.y, input_0.z)))).xyz, vec3(input_0.w * _7029)), vec3(0.0), vec3(1.0)).xyz, _10).xyz;
	    vec2 _11281 = vec2(_6375);
	    vec3 _21712;
	    if (_21710)
	    {
	        _21712 = _6663 * mix(vec3(1.0), input_5.xyz, vec3(saturate(_7029)));
	    }
	    else
	    {
	        _21712 = _6663;
	    }
	    bool _12889;
	    if (_Globals_.g_bWetness != 0)
	    {
	        _12889 = (_Globals_.g_fPuddleStrength + _Globals_.g_fWetnessStrength) > 0.0;
	    }
	    else
	    {
	        _12889 = false;
	    }
	    bool _12890;
	    if (_12889)
	    {
	        _12890 = input_1.z > 0.0;
	    }
	    else
	    {
	        _12890 = false;
	    }
	    vec3 _13141;
	    float _13960;
	    vec2 _16306;
	    float _17119;
	    float _17120;
	    vec3 _17121;
	    vec3 _24595;
	    SPIRV_CROSS_BRANCH
	    if (_12890)
	    {
	        vec4 _19372 = texture(sampler2D(g_bindless_Texture2D_float4[PerViewConstantBufferCsgo_t._m7], g_bindless_Sampler[_Globals_.g_sUserConfig]), (_10061.xy * 0.006000000052154064178466796875).xy);
	        float _21302 = _24347.z;
	        float _14498 = pow(max(0.0, _21302), 32.0);
	        float _23204 = min(min(input_1.z, saturate(PerViewConstantBufferCsgo_t._m11)), 1.0 - (saturate(PerViewConstantBufferCsgo_t._m12 - 0.5) * 2.0));
	        float _20426 = saturate(_23204 - 0.75);
	        float _8284 = _23204 + (4.0 * (_20426 * _20426));
	        float _16777 = _8284 - _Globals_.g_fWetEdgeSpread;
	        float _11964 = saturate(_8284 * 20.0);
	        vec4 _9717;
	        float _24879;
	        SPIRV_CROSS_BRANCH
	        if (_Globals_.g_bPuddlesOnVerticalSurfaces != 0)
	        {
	            vec4 _9186 = vec4(0.0, 0.0, 1.0, 0.0);
	            _9186.x = _24347.x;
	            _9186.y = _24347.y;
	            _9186.z = _21302;
	            _9717 = _9186;
	            _24879 = max(0.0, _16777);
	        }
	        else
	        {
	            _9717 = vec4(0.0, 0.0, 1.0, 0.0);
	            _24879 = max(0.0, (_8284 * _14498) - _Globals_.g_fWetEdgeSpread);
	        }
	        float _15811 = max(0.001000000047497451305389404296875, _Globals_.g_fPuddleBlendSoftness);
	        float _14611 = smoothstep(_24879 + _15811, _24879 - (input_1.w + (_15811 * 2.0)), _21711) * _11964;
	        float _19808 = max((smoothstep(_23204, _16777 - (0.20000000298023223876953125 * _8284), _21711) * _Globals_.g_fWetEdgeStrength) * _11964, _14611) * _Globals_.g_fPuddleStrength;
	        float _17924 = (_23204 - 1.0) - _21711;
	        float _10334 = (saturate(_17924 + _Globals_.g_fPuddleSedimentHeight) * _Globals_.g_fPuddleSedimentOpacity) * _14611;
	        float _13706 = clamp(((clamp((((_8284 * 2.0) - (mix(0.5, _19372.w, saturate(_14498 * 20.0)) * 0.5)) - (_21711 * 0.5)) + 0.25, 0.0, 1.0) * _Globals_.g_fWetnessStrength) * _11964) + _14611, 0.0, 1.0);
	        float _13140;
	        float _13151;
	        vec4 _23607;
	        SPIRV_CROSS_BRANCH
	        if (_13706 > 0.5)
	        {
	            float _12497 = _Globals_.g_fRippleStrength * PerViewConstantBufferCsgo_t._m9;
	            vec3 _6617;
	            vec4 _12891;
	            float _13139;
	            SPIRV_CROSS_BRANCH
	            if (_12497 > 0.0)
	            {
	                vec3 _18756 = normalize(vec3(-1.0, 0.20000000298023223876953125, 0.0));
	                float _9925 = PerViewConstantBufferCsgo_t._m10 * 6.283185482025146484375;
	                float _22373 = sin(_9925);
	                float _20617 = cos(_9925);
	                vec2 _23932 = _18756.xy * mat2(vec2(_20617, -_22373), vec2(_22373, _20617));
	                vec3 _22900 = _18756;
	                _22900.x = _23932.x;
	                _22900.y = _23932.y;
	                vec3 _21326 = -cross(_22900, _24347);
	                vec3 _13887 = _10061.xyz;
	                float _9965 = dot(_13887, _21326);
	                float _12056 = 1.0 - input_1.z;
	                vec2 _20274 = ((vec2(dot(_13887, _22900)) + (vec2(0.100000001490116119384765625, -0.100000001490116119384765625) * _9965)) + (vec2(8.0, 5.0) * _10061.z)) + vec2((_12056 * _12056) * (-80.0));
	                vec2 _15991 = vec2(_20274.x, _9965) * vec2(0.0199999995529651641845703125, 0.010999999940395355224609375);
	                vec4 _20877 = texture(sampler2D(g_bindless_Texture2D_float4[PerViewConstantBufferCsgo_t._m7], g_bindless_Sampler[_Globals_.g_sUserConfig]), (_15991 + (vec2(0.20000000298023223876953125, 0.0) * PerViewConstantBuffer_t._m1)).xy);
	                vec2 _18922 = (_20877.xy * 2.0) - vec2(1.0);
	                float _22216 = clamp(length(fwidth(_15991)) * 10.0, 0.0, 1.0);
	                vec2 _15297 = ((_18922 * vec2(0.100000001490116119384765625, 0.0500000007450580596923828125)) * input_1.z) * mix(1.0, 0.300000011920928955078125, _22216);
	                vec2 _13711 = _21326.xy;
	                vec4 _19601 = vec4(0.0);
	                _19601.x = dot(_22900.xy, _15297);
	                _19601.y = dot(_13711, _15297);
	                vec2 _16046 = (vec2(_20274.y, _9965) * vec2(0.03599999845027923583984375, 0.01620000042021274566650390625)) + (_18922 * 0.0500000007450580596923828125);
	                vec4 _20878 = texture(sampler2D(g_bindless_Texture2D_float4[PerViewConstantBufferCsgo_t._m7], g_bindless_Sampler[_Globals_.g_sUserConfig]), (_16046 + (vec2(0.1500000059604644775390625, 0.0) * PerViewConstantBuffer_t._m1)).xy);
	                vec2 _17104 = (((_20878.xy * 2.0) - vec2(1.0)) * 0.05200000107288360595703125) * input_1.z;
	                _17104.y = _17104.y * 0.5;
	                float _9250 = clamp(length(fwidth(_16046)) * 10.0, 0.0, 1.0);
	                vec2 _13560 = _17104 * mix(1.0, 0.300000011920928955078125, _9250);
	                vec2 _13330 = _19601.xy + vec2(dot(_22900.xy, _13560), dot(_13711, _13560));
	                vec4 _20489 = _19601;
	                _20489.x = _13330.x;
	                _20489.y = _13330.y;
	                _20489.w = input_1.z * (_20877.z + _20878.z);
	                vec3 _20490;
	                _20490.x = _10061.x;
	                _20490.y = _10061.y;
	                _13139 = _12497 * (0.039999999105930328369140625 * (_22216 + _9250));
	                _12891 = _9717 + ((_20489 * _14498) * _12497);
	                _6617 = _20490;
	            }
	            else
	            {
	                _13139 = 0.0;
	                _12891 = _9717;
	                _6617 = _10061;
	            }
	            float _8914 = (_Globals_.g_fRainStrength * PerViewConstantBufferCsgo_t._m8) * PerViewConstantBufferCsgo_t._m8;
	            float _9982;
	            vec4 _21594;
	            SPIRV_CROSS_BRANCH
	            if (_8914 > 0.0)
	            {
	                vec2 _10473 = _6617.xy * 0.119999997317790985107421875;
	                vec3 _20506 = vec3(PerViewConstantBuffer_t._m1 * 6.5) + vec3(0.0, 0.3167000114917755126953125, 0.633400022983551025390625);
	                vec3 _13155;
	                _13155 = vec3(0.0);
	                int _18440;
	                vec3 _25251;
	                int _16208 = 0;
	                SPIRV_CROSS_UNROLL
	                for (;;)
	                {
	                    if (!(_16208 < 3))
	                    {
	                        break;
	                    }
	                    vec3 _23854 = vec3(0.97130000591278076171875, 0.751800000667572021484375, 0.362399995326995849609375);
	                    vec3 _16408 = vec3(0.23770000040531158447265625, 0.65939998626708984375, 0.931999981403350830078125);
	                    mat2 _21666 = mat2(vec2(_23854[_16208], -_16408[_16208]), vec2(_16408[_16208], _23854[_16208]));
	                    vec3 _16409 = vec3(0.60000002384185791015625, 0.666100025177001953125, 0.73220002651214599609375);
	                    float _23410 = _20506[_16208];
	                    vec2 _10212 = ((_21666 * _10473) * _16409[_16208]) + vec2(_23410 * 0.0199999995529651641845703125);
	                    vec2 _7848 = _21666 * ((fract(_10212) * 2.0) - vec2(1.0));
	                    float _8329 = length(_7848);
	                    float _20173 = clamp(1.0 - (_8329 * mix(3.0, 1.0, _14611)), 0.0, 1.0);
	                    float _20213 = clamp(1.0 - (_8329 * 6.0), 0.0, 1.0);
	                    float _7135 = floor(fract(_10212.x * 0.100000001490116119384765625) * 10.0);
	                    float _23598 = _20506[_16208];
	                    float _18429 = _23598 + ((_7135 + (floor(fract(_10212.y * 0.100000001490116119384765625) * 10.0) * (0.20000000298023223876953125 + _7135))) * 8.0);
	                    _20506[_16208] = _18429;
	                    float _18120 = _8914 * _8914;
	                    _25251 = vec3(_13155.xy + (((-(((((_7848 / vec2(_8329)) * cos(mix(1.0, (_20173 * 40.0) + (PerViewConstantBuffer_t._m1 * 65.0), _14611))) * _20173) * _20173) * mix(2.0, 0.25, clamp(fwidth(_20173) * 20.0, 0.0, 1.0)))) * ((clamp((sin(((_20173 * mix(1.0, 4.0, _14611)) + _18429) * _8914) - (1.0 - ((0.20000000298023223876953125 * _18120) * mix(0.25, 1.0, _14611)))) * 2.0, 0.0, 1.0) * _20173) / _18120)) * mix(16.0, 2.0, _14611)), _13155.z + (((clamp((sin((((_20213 + _18429) + 4.0) + (sin(_21711 * 60.0) * 0.25)) * _8914) - (1.0 - (_18120 * 0.02000000141561031341552734375))) * 2.0, 0.0, 1.0) * _20213) / _18120) * 28.0));
	                    _18440 = _16208 + 1;
	                    _13155 = _25251;
	                    _16208 = _18440;
	                    continue;
	                }
	                vec3 _9348 = _13155 * _14498;
	                vec2 _15752 = _12891.xy + _9348.xy;
	                vec4 _20491 = _12891;
	                _20491.x = _15752.x;
	                _20491.y = _15752.y;
	                _9982 = _9348.z;
	                _21594 = _20491;
	            }
	            else
	            {
	                _9982 = 0.0;
	                _21594 = _12891;
	            }
	            vec3 _10508 = normalize(_21594.xyz);
	            vec4 _16886 = _21594;
	            _16886.x = _10508.x;
	            _16886.y = _10508.y;
	            _16886.z = _10508.z;
	            _13140 = _9982;
	            _13151 = _13139;
	            _23607 = _16886;
	        }
	        else
	        {
	            _13140 = 0.0;
	            _13151 = 0.0;
	            _23607 = _9717;
	        }
	        float _10839 = _14611 * _Globals_.g_fPuddleStrength;
	        vec3 _23311 = vec3(_19808 * _10334);
	        vec3 _13712 = normalize(mix(_19225.xyz, _23607.xyz, vec3(saturate(_10839 * 4.0))));
	        float _9038 = max(_13706 * (1.0 - saturate(PerViewConstantBufferCsgo_t._m12 * 2.0)), _19808);
	        vec3 _18806 = mix(_21712, pow(_21712, vec3(1.2999999523162841796875)) * 0.800000011920928955078125, clamp((pow(_21712, vec3(0.25)) * (_9038 * _6375)) * 8.0, vec3(0.0), vec3(1.0)) * _Globals_.g_flWetnessDarkeningStrength1);
	        _13141 = fma(mix((mix(_18806, _18806 * 0.5, vec3(saturate(_14611 * 1.5))) * mix(1.0, _14713, _19808)) * mix(1.0, 1.0 - _17924, _10334), _Globals_.g_vPuddleSedimentColor, _23311), vec3(1.0 + _13140), vec3(_13140 * 0.100000001490116119384765625));
	        _16306 = clamp(mix(_11281.xx, vec2(_Globals_.g_fPuddleRoughness), vec2(_9038)) + vec2(_13151 + (length(fwidth(_13712.xyz)) * 0.5)), vec2(0.0), vec2(1.0));
	        _17119 = mix(_14713, 1.0, _19808);
	        _17120 = mix(_Globals_.g_flReflectance, 0.0350000001490116119384765625, _9038);
	        _17121 = _13712;
	        _13960 = _10839 * (0.20000000298023223876953125 + (((0.1500000059604644775390625 * _23607.w) * _23607.w) * _23607.w));
	        _24595 = mix(_6756, _23607.xyz, _23311);
	    }
	    else
	    {
	        _13141 = _21712;
	        _16306 = _11281;
	        _17119 = _14713;
	        _17120 = _Globals_.g_flReflectance;
	        _17121 = vec3(1.0);
	        _13960 = 0.0;
	        _24595 = _6756;
	    }
	    vec3 _9451 = mix(vec3(_17120).xyz, _13141.xyz, vec3(_19323.w));
	    vec3 _17892 = mix(_17121, _24595, bvec3(all(equal(_17121, vec3(1.0)))));
	    vec3 _10560 = _24347.xyz;
	    vec3 _11099 = dFdx(_10560);
	    vec3 _9175 = dFdy(_10560);
	    vec3 _10347 = _11099.xyz;
	    vec3 _12420 = _9175.xyz;
	    vec2 _21818 = max(_16306.xy, vec2(pow(clamp(max(dot(_10347, _10347), dot(_12420, _12420)), 0.0, 1.0), 0.333000004291534423828125)));
	    vec3 _15598 = -_24347;
	    vec4 _23875 = vec4(_24595.xyz, 1.0);
	    bvec4 _24464 = notEqual(PerViewConstantBufferCsgo_t._m0, ivec4(0));
	    float _21714;
	    if (_24464.x)
	    {
	        vec3 _11394 = _24347.xyz;
	        vec2 _11086 = ((floor(_11408.xy * PerViewConstantBufferCsgo_t._m15) * PerViewConstantBufferCsgo_t._m14.xy) + (PerViewConstantBufferCsgo_t._m14.xy * 0.5)).xy;
	        vec4 _18418 = textureGather(sampler2D(g_bindless_Texture2D_float4[PerViewConstantBufferCsgo_t._m4], g_bindless_Sampler[_Globals_.g_sCookieSampler]), _11086).xyzw - _11408.zzzz;
	        float _18579 = _18418.w;
	        float _12013 = _18418.z;
	        bool _12285 = abs(_12013) < _18579;
	        vec2 _23168;
	        if (_12285)
	        {
	            _23168 = vec2(PerViewConstantBufferCsgo_t._m14.x, 0.0);
	        }
	        else
	        {
	            _23168 = vec2(0.0);
	        }
	        float _20965 = _12285 ? _12013 : _18579;
	        float _15372 = _18418.x;
	        bool _12287 = abs(_15372) < _20965;
	        vec2 _23169;
	        if (_12287)
	        {
	            _23169 = vec2(0.0, PerViewConstantBufferCsgo_t._m14.y);
	        }
	        else
	        {
	            _23169 = _23168;
	        }
	        vec4 _10010 = normalize(vec4(PerViewLightingConstantBufferGpu_t._m2.x * fma(dot(_15598, normalize(vec3(PerViewLightingConstantBufferGpu_t._m1._m0[0].xy, 0.25))), 0.5, 0.5), PerViewLightingConstantBufferGpu_t._m2.y * fma(dot(_15598, normalize(vec3(PerViewLightingConstantBufferGpu_t._m1._m0[1].xy, 0.25))), 0.5, 0.5), PerViewLightingConstantBufferGpu_t._m2.z * fma(dot(_15598, normalize(vec3(PerViewLightingConstantBufferGpu_t._m1._m0[2].xy, 0.25))), 0.5, 0.5), PerViewLightingConstantBufferGpu_t._m2.w * fma(dot(_15598, normalize(vec3(PerViewLightingConstantBufferGpu_t._m1._m0[3].xy, 0.25))), 0.5, 0.5)));
	        vec4 _13232 = max(vec4(dot(PerViewLightingConstantBufferGpu_t._m1._m0[0].xyz, _11394), dot(PerViewLightingConstantBufferGpu_t._m1._m0[1].xyz, _11394), dot(PerViewLightingConstantBufferGpu_t._m1._m0[2].xyz, _11394), dot(PerViewLightingConstantBufferGpu_t._m1._m0[3].xyz, _11394)).xyzw, vec4(0.0)) * normalize(clamp(((_10010 - vec4(max(max(_10010.x, _10010.y), max(_10010.z, _10010.w)))) + vec4(0.20000000298023223876953125)) * vec4(5.0), vec4(0.0), vec4(1.0)));
	        _21714 = (1.0 / (dot(_13232, vec4(1.0)) + PerViewLightingConstantBufferGpu_t._m3.x)) * (PerViewLightingConstantBufferGpu_t._m3.x + dot(_13232, textureLod(sampler2D(g_bindless_Texture2D_float4[PerViewConstantBufferCsgo_t._m3], g_bindless_Sampler[_Globals_.g_sPointClamp]), (_11086 + mix(_23169, PerViewConstantBufferCsgo_t._m14.xy, bvec2(abs(_18418.y) < (_12287 ? _15372 : _20965))).xy).xy, 0.0)));
	    }
	    else
	    {
	        _21714 = 1.0;
	    }
	    float _21715;
	    SPIRV_CROSS_BRANCH
	    if (PerViewLightingConstantBufferGpu_t._m11 != 0)
	    {
	        int _23989;
	        int _10191;
	        float _13142;
	        vec3 _14975;
	        int _13039 = 0;
	        for (;;)
	        {
	            if (!(_13039 < PerViewLightingConstantBufferGpu_t._m11))
	            {
	                _13142 = 1.0;
	                _14975 = vec3(0.0);
	                _10191 = -1;
	                break;
	            }
	            vec4 _18322 = vec4(input_2.xyz, 1.0) * PerViewLightingConstantBufferGpu_t._m18._m0[_13039];
	            float _12779 = _18322.x;
	            if (max(abs(_12779), abs(_18322.y)) < PerViewLightingConstantBufferGpu_t._m13[_13039])
	            {
	                vec3 _19470 = vec3(_12779, _18322.yz);
	                vec2 _24804 = _19470.xy;
	                vec2 _22193 = vec2(1.0) - clamp((abs(_24804) * vec2(PerViewLightingConstantBufferGpu_t._m15)) + vec2(PerViewLightingConstantBufferGpu_t._m14), vec2(0.0), vec2(1.0));
	                vec2 _20561 = (_24804 * PerViewLightingConstantBufferGpu_t._m19._m0[_13039].zw) + PerViewLightingConstantBufferGpu_t._m19._m0[_13039].xy;
	                vec3 _20492 = _19470;
	                _20492.x = _20561.x;
	                _20492.y = _20561.y;
	                _13142 = saturate(_22193.x * _22193.y);
	                _14975 = _20492;
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
	            float _18270 = textureLod(sampler2DShadow(g_bindless_Texture2D_float4[PerViewLightingConstantBufferGpu_t._m20], g_bindless_Sampler_1[_Globals_.g_tShadowDepthBufferCmpSampler]), vec3(_14975.xy, saturate(_14975.z + PerViewLightingConstantBufferGpu_t._m12)), 0.0);
	            float _12501;
	            SPIRV_CROSS_BRANCH
	            if (_13142 < 1.0)
	            {
	                float _7934;
	                if (_10191 < (PerViewLightingConstantBufferGpu_t._m11 - 1))
	                {
	                    int _15335 = _10191 + 1;
	                    vec4 _19671 = vec4(input_2.xyz, 1.0) * PerViewLightingConstantBufferGpu_t._m18._m0[_15335];
	                    vec2 _20562 = (_19671.xy * PerViewLightingConstantBufferGpu_t._m19._m0[_15335].zw) + PerViewLightingConstantBufferGpu_t._m19._m0[_15335].xy;
	                    vec3 _20493;
	                    _20493.x = _20562.x;
	                    _20493.y = _20562.y;
	                    _7934 = textureLod(sampler2DShadow(g_bindless_Texture2D_float4[PerViewLightingConstantBufferGpu_t._m20], g_bindless_Sampler_1[_Globals_.g_tShadowDepthBufferCmpSampler]), vec3(_20493.xy, saturate(_19671.z + PerViewLightingConstantBufferGpu_t._m12)), 0.0);
	                }
	                else
	                {
	                    _7934 = 1.0;
	                }
	                _12501 = mix(_7934, _18270, _13142);
	            }
	            else
	            {
	                _12501 = _18270;
	            }
	            _18423 = _12501;
	        }
	        else
	        {
	            _18423 = 1.0;
	        }
	        float _13279 = mix(_18423, 1.0, clamp((distance(_10061.xyz, PerViewConstantBuffer_t._m5) * PerViewLightingConstantBufferGpu_t._m17) + PerViewLightingConstantBufferGpu_t._m16, 0.0, 1.0));
	        float _12502;
	        if (_24464.y)
	        {
	            _12502 = min(_13279, textureLod(sampler2D(g_bindless_Texture2D_float4[PerViewConstantBufferCsgo_t._m5], g_bindless_Sampler[_Globals_.g_sTrilinearClamp]), (_11408.xy * PerViewConstantBuffer_t._m4.xy).xy, 0.0).z);
	        }
	        else
	        {
	            _12502 = _13279;
	        }
	        _21715 = _12502;
	    }
	    else
	    {
	        _21715 = 1.0;
	    }
	    vec3 _9718;
	    vec3 _24880;
	    SPIRV_CROSS_BRANCH
	    if ((dot(PerViewLightingConstantBufferGpu_t._m9.xyz, _24595.xyz) * _21715) > 0.0)
	    {
	        vec3 _15460 = mix(_17892, _24595.xyz, bvec3(all(equal(_17892, vec3(1.0)))));
	        float _13811 = max(0.0, dot(_24595.xyz, PerViewLightingConstantBufferGpu_t._m9.xyz));
	        vec3 _17874 = vec3(_13811);
	        vec3 _18223;
	        if (_13960 > 0.0)
	        {
	            float _8780 = dot(_15460, PerViewLightingConstantBufferGpu_t._m9.xyz);
	            float _8124 = saturate(_13960);
	            _18223 = mix(_17874.xyz, vec3((((0.5 + (_13811 * 0.5)) + pow(1.0 - saturate(_8780), 4.0)) * clamp((_8780 + 0.20000000298023223876953125) * 4.0, 0.0, 1.0)) * clamp(mix(dot(mix(_24595.xyz, _15460, vec3(10.0)), PerViewLightingConstantBufferGpu_t._m9.xyz), 1.0, _8124), 0.0, 1.0)), vec3(_8124));
	        }
	        else
	        {
	            _18223 = _17874;
	        }
	        vec2 _17301 = max(_21818, vec2(PerViewLightingConstantBufferGpu_t._m9.w));
	        vec3 _12281 = normalize(PerViewLightingConstantBufferGpu_t._m9.xyz + (-normalize(_10061.xyz - PerViewConstantBuffer_t._m5.xyz)).xyz).xyz;
	        float _12386 = dot(_12281, _15460.xyz);
	        float _19210 = max(0.0, dot(PerViewLightingConstantBufferGpu_t._m9.xyz, _12281));
	        float _9850 = _17301.x;
	        float _25211 = _9850 * _9850;
	        float _19095 = _25211 * _25211;
	        float _15346 = ((_12386 * _12386) * (_19095 - 1.0)) + 1.0;
	        vec3 _16808 = (PerViewLightingConstantBufferGpu_t._m10.xyz * _21715).xyz;
	        _9718 = ((_9451.xyz * (_19095 / (((_15346 * _15346) * (_19210 * _19210)) * ((_9850 * 4.0) + 2.0)))).xyz * _13811).xyz * _16808;
	        _24880 = PerViewLightingConstantBufferGpu_t._m4.xyz + (_18223.xyz * _16808);
	    }
	    else
	    {
	        _9718 = vec3(0.0);
	        _24880 = PerViewLightingConstantBufferGpu_t._m4.xyz;
	    }
	    bvec4 _24465 = notEqual(PerViewConstantBufferCsgo_t._m1, ivec4(0));
	    bool _20059 = _24465.x;
	    vec4 _19364;
	    if (_20059)
	    {
	        vec4 _18621 = vec4(_10061.xyz, 1.0).xyzw * PerViewConstantBufferCsgo_t._m13;
	        float _20176 = _18621.w;
	        vec2 _11414 = _18621.xy / vec2(_20176);
	        vec4 _6651;
	        _6651.x = clamp(((_11414.x + 1.0) * PerViewConstantBuffer_t._m3.x) * 0.5, 0.0, PerViewConstantBuffer_t._m3.x - 1.0);
	        _6651.y = clamp(((1.0 - _11414.y) * PerViewConstantBuffer_t._m3.y) * 0.5, 0.0, PerViewConstantBuffer_t._m3.y - 1.0);
	        _6651.w = _20176;
	        _19364 = _6651;
	    }
	    else
	    {
	        _19364 = _11408;
	    }
	    uvec2 _12083 = uvec2(_19364.xy - PerViewConstantBuffer_t._m2.xy) >> uvec2(PerViewLightingConstantBufferGpu_t._m6.x);
	    uint _10838 = PerViewLightingConstantBufferGpu_t._m5.y + (((_12083.y * PerViewLightingConstantBufferGpu_t._m6.y) + _12083.x) * PerViewLightingConstantBufferGpu_t._m5.z);
	    uint _23393 = PerViewLightingConstantBufferGpu_t._m5.x + (uint(clamp(_19364.w * PerViewLightingConstantBufferGpu_t._m7.x, 0.0, PerViewLightingConstantBufferGpu_t._m7.y)) * PerViewLightingConstantBufferGpu_t._m5.z);
	    vec3 _13143;
	    vec3 _16324;
	    _13143 = _9718;
	    _16324 = _24880;
	    uint _21567;
	    vec3 _13144;
	    vec3 _16325;
	    uint _17017 = 0u;
	    for (;;)
	    {
	        if (!(_17017 < PerViewLightingConstantBufferGpu_t._m5.z))
	        {
	            break;
	        }
	        uint _14475 = subgroupOr(g_CullBits_1._m0[_10838 + _17017] & g_CullBits_1._m0[_23393 + _17017]);
	        _13144 = _13143;
	        _16325 = _16324;
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
	                vec4 _24893 = g_BarnLights_1._m0[_12608]._m0 * vec4(input_2.xyz, 1.0);
	                vec3 _10521 = _24893.xyz / vec3(_24893.w);
	                vec4 _22905;
	                _22905.x = _10521.x;
	                _22905.y = _10521.y;
	                float _21775 = _10521.z;
	                _22905.z = _21775;
	                vec3 _21642 = _22905.xyz;
	                bool _7424;
	                if (all(greaterThan(_22905.xyz, vec3(-1.0, -1.0, 0.0))))
	                {
	                    _7424 = all(lessThan(_22905.xyz, vec3(1.0)));
	                }
	                else
	                {
	                    _7424 = false;
	                }
	                bool _12893;
	                if (!_7424)
	                {
	                    _12893 = true;
	                }
	                else
	                {
	                    _12893 = !all(lessThanEqual(abs((g_BarnLights_1._m0[_12608]._m15 * vec4(input_2.xyz, 1.0)).xyz), vec3(1.0)));
	                }
	                if (_12893)
	                {
	                    _13212 = _13144;
	                    _15670 = _16325;
	                    break;
	                }
	                float _23572 = 2.0 * g_BarnLights_1._m0[_12608]._m5.y;
	                float _18492 = (2.0 * g_BarnLights_1._m0[_12608]._m5.z) * g_BarnLights_1._m0[_12608]._m5.z;
	                float _14805 = 2.0 * g_BarnLights_1._m0[_12608]._m5.x;
	                float _9058 = _14805 * g_BarnLights_1._m0[_12608]._m5.y;
	                float _17330 = 2.0 * g_BarnLights_1._m0[_12608]._m5.w;
	                float _19825 = _17330 * g_BarnLights_1._m0[_12608]._m5.z;
	                vec3 _16268 = vec3(_9058 - _19825, (1.0 - (_14805 * g_BarnLights_1._m0[_12608]._m5.x)) - _18492, (_23572 * g_BarnLights_1._m0[_12608]._m5.z) + (_17330 * g_BarnLights_1._m0[_12608]._m5.x)) * g_BarnLights_1._m0[_12608]._m6.z;
	                float _21316;
	                if (g_BarnLights_1._m0[_12608]._m3.z > 0.0)
	                {
	                    _21316 = min(1.0, _21775 * g_BarnLights_1._m0[_12608]._m3.z);
	                }
	                else
	                {
	                    _21316 = 1.0;
	                }
	                float _19667;
	                if (g_BarnLights_1._m0[_12608]._m3.w > 0.0)
	                {
	                    _19667 = _21316 * min(1.0, (1.0 - _21775) * g_BarnLights_1._m0[_12608]._m3.w);
	                }
	                else
	                {
	                    _19667 = _21316;
	                }
	                vec3 _11180;
	                float _11633;
	                if (g_BarnLights_1._m0[_12608]._m2.w != 0.0)
	                {
	                    vec3 _10018 = g_BarnLights_1._m0[_12608]._m2.xyz - input_2.xyz;
	                    float _18345 = dot(_10018, _10018);
	                    float _17647 = sqrt(_18345);
	                    vec3 _12302 = _10018 - _16268;
	                    vec3 _10210;
	                    do
	                    {
	                        vec3 _20229 = (_10018 + _16268) - _12302;
	                        float _25105 = dot(-_12302, _20229);
	                        if (_25105 <= 0.0)
	                        {
	                            _10210 = _12302;
	                            break;
	                        }
	                        else
	                        {
	                            _10210 = _12302 + (_20229 * min(1.0, _25105 / dot(_20229, _20229)));
	                            break;
	                        }
	                        break; // unreachable workaround
	                    } while(false);
	                    _11180 = _10018 / vec3(_17647);
	                    _11633 = ((_19667 * (g_BarnLights_1._m0[_12608]._m2.w / max(_18345, g_BarnLights_1._m0[_12608]._m2.w))) * clamp(g_BarnLights_1._m0[_12608]._m3.x + (g_BarnLights_1._m0[_12608]._m3.y * _17647), 0.0, 1.0)) * clamp(g_BarnLights_1._m0[_12608]._m6.x + (g_BarnLights_1._m0[_12608]._m6.y * dot(vec3((1.0 - (_23572 * g_BarnLights_1._m0[_12608]._m5.y)) - _18492, _9058 + _19825, (_14805 * g_BarnLights_1._m0[_12608]._m5.z) - (_17330 * g_BarnLights_1._m0[_12608]._m5.y)), normalize(_10210))), 0.0, 1.0);
	                }
	                else
	                {
	                    _11180 = g_BarnLights_1._m0[_12608]._m2.xyz;
	                    _11633 = _19667;
	                }
	                vec3 _17828 = (g_BarnLights_1._m0[_12608]._m4.xyz * 1.0).xyz * _11633;
	                bool _24419;
	                if (g_BarnLights_1._m0[_12608]._m8.z > 0.0)
	                {
	                    _24419 = !_20059;
	                }
	                else
	                {
	                    _24419 = false;
	                }
	                vec3 _21548;
	                SPIRV_CROSS_BRANCH
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
	                            float _11475 = _22154.x;
	                            float _15266 = 2.0 / g_BarnLights_1._m0[_12608]._m9.z;
	                            float _15018 = _22154.y;
	                            float _23041 = (-0.5) * g_BarnLights_1._m0[_12608]._m9.z;
	                            float _11981 = (g_BarnLights_1._m0[_12608]._m9.x * g_BarnLights_1._m0[_12608]._m9.y) * pow(max(pow(g_BarnLights_1._m0[_12608]._m9.y * _11475, _15266) + pow(g_BarnLights_1._m0[_12608]._m9.x * _15018, _15266), 1.1754943508222875079687365372222e-38), _23041);
	                            float _16524 = pow(max(pow(_11475, _15266) + pow(_15018, _15266), 1.1754943508222875079687365372222e-38), _23041);
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
	                    vec3 _12503;
	                    if (g_BarnLights_1._m0[_12608]._m4.w < 0.0)
	                    {
	                        vec4 _17795 = vec4(-g_BarnLights_1._m0[_12608]._m5.xyz, g_BarnLights_1._m0[_12608]._m5.w);
	                        vec4 _19008 = _17795.xyzw * vec4(-1.0, -1.0, -1.0, 1.0);
	                        vec3 _24989 = _19008.xyz;
	                        vec3 _23629 = vec4((-_11180).xyz, 0.0).xyz;
	                        float _15156 = -dot(_23629, _24989);
	                        vec3 _20479 = vec4((_23629 * _19008.w) + cross(_23629, _24989), _15156).xyz;
	                        vec3 _23592 = _17795.xyz;
	                        vec3 _12170 = ((_20479 * g_BarnLights_1._m0[_12608]._m5.w) + (_23592 * _15156)) + cross(_23592, _20479);
	                        vec3 _14081 = vec3(vec2(atan(_12170.y, -_12170.x) * 0.15915493667125701904296875, acos(_12170.z) * 0.3183098733425140380859375), -g_BarnLights_1._m0[_12608]._m4.w);
	                        vec2 _20564 = (_14081.xy * g_BarnLights_1._m0[_12608]._m9.zw) + g_BarnLights_1._m0[_12608]._m9.xy;
	                        vec3 _20496 = _14081;
	                        _20496.x = _20564.x;
	                        _20496.y = _20564.y;
	                        _12503 = _17828.xyz * textureLod(sampler3D(g_bindless_Texture3D_float4[PerViewLightingConstantBufferGpu_t._m21], g_bindless_Sampler[_Globals_.g_sTrilinearWrap]), _20496.xyz, 0.0).xyz;
	                    }
	                    else
	                    {
	                        vec3 _13791 = vec3(fma(_22905.xy, vec2(0.5, -0.5), vec2(0.5)), g_BarnLights_1._m0[_12608]._m4.w);
	                        vec2 _20563 = (_13791.xy * g_BarnLights_1._m0[_12608]._m9.zw) + g_BarnLights_1._m0[_12608]._m9.xy;
	                        vec3 _20494 = _13791;
	                        _20494.x = _20563.x;
	                        _20494.y = _20563.y;
	                        _12503 = _17828.xyz * textureLod(sampler3D(g_bindless_Texture3D_float4[PerViewLightingConstantBufferGpu_t._m21], g_bindless_Sampler[_Globals_.g_sCookieSampler]), _20494.xyz, 0.0).xyz;
	                    }
	                    _21548 = _12503;
	                }
	                if (all(equal(_21548.xyz, vec3(0.0))))
	                {
	                    _13212 = _13144;
	                    _15670 = _16325;
	                    break;
	                }
	                vec3 _21549;
	                if (_24419)
	                {
	                    vec3 _19629;
	                    if ((g_BarnLights_1._m0[_12608]._m13 & 4u) != 0u)
	                    {
	                        vec2 _6281 = _22905.yx * vec2(1.0, -1.0);
	                        vec3 _23714 = _21642;
	                        _23714.x = _6281.x;
	                        _23714.y = _6281.y;
	                        _19629 = _23714;
	                    }
	                    else
	                    {
	                        _19629 = _21642;
	                    }
	                    vec3 _20482 = _21548.xyz * mix(1.0, textureLod(sampler2DShadow(g_bindless_Texture2D_float4[PerViewLightingConstantBufferGpu_t._m20], g_bindless_Sampler_1[_Globals_.g_tShadowDepthBufferCmpSampler]), vec3(vec3(fma(_19629.xy, g_BarnLights_1._m0[_12608]._m8.zw, g_BarnLights_1._m0[_12608]._m8.xy), _19629.z).xy, saturate(_19629.z + PerViewLightingConstantBufferGpu_t._m12)), 0.0), g_BarnLights_1._m0[_12608]._m12);
	                    if (all(equal(_20482.xyz, vec3(0.0))))
	                    {
	                        _13212 = _13144;
	                        _15670 = _16325;
	                        break;
	                    }
	                    _21549 = _20482;
	                }
	                else
	                {
	                    _21549 = _21548;
	                }
	                vec3 _15461 = mix(_17892, _24595.xyz, bvec3(all(equal(_17892, vec3(1.0)))));
	                float _13812 = max(0.0, dot(_24595.xyz, _11180.xyz));
	                vec3 _17875 = vec3(_13812);
	                vec3 _18225;
	                if (_13960 > 0.0)
	                {
	                    float _8781 = dot(_15461, _11180.xyz);
	                    float _8125 = saturate(_13960);
	                    _18225 = mix(_17875.xyz, vec3((((0.5 + (_13812 * 0.5)) + pow(1.0 - saturate(_8781), 4.0)) * clamp((_8781 + 0.20000000298023223876953125) * 4.0, 0.0, 1.0)) * clamp(mix(dot(mix(_24595.xyz, _15461, vec3(10.0)), _11180.xyz), 1.0, _8125), 0.0, 1.0)), vec3(_8125));
	                }
	                else
	                {
	                    _18225 = _17875;
	                }
	                vec2 _17302 = max(_21818, vec2(g_BarnLights_1._m0[_12608]._m11));
	                vec3 _12282 = normalize(_11180.xyz + (-normalize(_10061.xyz - PerViewConstantBuffer_t._m5.xyz)).xyz).xyz;
	                float _12387 = dot(_12282, _15461.xyz);
	                float _19211 = max(0.0, dot(_11180.xyz, _12282));
	                float _9851 = _17302.x;
	                float _25212 = _9851 * _9851;
	                float _19097 = _25212 * _25212;
	                float _15348 = ((_12387 * _12387) * (_19097 - 1.0)) + 1.0;
	                _13212 = _13144.xyz + (((_9451.xyz * (_19097 / (((_15348 * _15348) * (_19211 * _19211)) * ((_9851 * 4.0) + 2.0)))).xyz * _13812).xyz * _21549.xyz);
	                _15670 = _16325.xyz + (_18225.xyz * _21549.xyz);
	                break;
	            } while(false);
	            _13144 = _13212;
	            _16325 = _15670;
	            _17018 = _20344;
	            continue;
	        }
	        _21567 = _17017 + 1u;
	        _13143 = _13144;
	        _16324 = _16325;
	        _17017 = _21567;
	        continue;
	    }
	    float _17172 = dot(_21818.xy, vec2(0.5));
	    vec3 _7507 = _17892.xyz;
	    vec3 _17138 = normalize(_10061.xyz - PerViewConstantBuffer_t._m5.xyz);
	    float _17225 = _17172 * _17172;
	    float _20711 = saturate(1.0 - _17225);
	    vec4 _15344 = (vec4(-1.0, -0.0274999998509883880615234375, -0.572000026702880859375, 0.02199999988079071044921875) * _17172) + vec4(1.0, 0.0425000004470348358154296875, 1.03999996185302734375, -0.039999999105930328369140625);
	    float _21215 = _15344.x;
	    vec2 _24572 = (vec2(-1.03999996185302734375, 1.03999996185302734375) * ((min(_21215 * _21215, exp2((-9.27999973297119140625) * max(0.0, dot((-_17138).xyz, _7507)))) * _21215) + _15344.y)) + _15344.zw;
	    float _20339 = _24572.y;
	    vec2 _11427 = vec2(_20339, _24572.x + _20339);
	    vec3 _8745 = vec3(dot(PerViewLightingConstantBufferGpu_t._m0._m0[0].xyzw, _23875), dot(PerViewLightingConstantBufferGpu_t._m0._m0[1].xyzw, _23875), dot(PerViewLightingConstantBufferGpu_t._m0._m0[2].xyzw, _23875)).xyz;
	    vec3 _16991 = _16324.xyz + _8745;
	    vec3 _20418 = vec3(_21714 * _17119).xyz;
	    vec3 _20015 = _8745 * _20418;
	    vec3 _20579;
	    if (_21618)
	    {
	        _20579 = mix(_20015, pow(_20015, vec3(1.0499999523162841796875, 0.949999988079071044921875, 0.800000011920928955078125)), vec3(float(_21618)));
	    }
	    else
	    {
	        _20579 = _20015;
	    }
	    vec3 _22686 = (_16324.xyz + _20579.xyz) * (_13141.xyz * (1.0 - _19323.w)).xyz;
	    float _12931 = _22686.x;
	    vec4 _11204 = vec4(_12931, _22686.yz, input_5.w);
	    _11204.x = _12931;
	    _11204.y = _22686.y;
	    _11204.z = _22686.z;
	    vec3 _15753 = _11204.xyz + (_13143.xyz * _20418).xyz;
	    vec4 _20497 = _11204;
	    _20497.x = _15753.x;
	    _20497.y = _15753.y;
	    _20497.z = _15753.z;
	    vec3 _15734 = _20497.xyz + ((((mix(_11427.xxx, _11427.yyy, _9451) * textureLod(samplerCubeArray(g_bindless_TextureCubeArray_float4[PerViewConstantBufferCsgo_t._m6], g_bindless_Sampler[_Globals_.g_sTrilinearClamp]), vec4(normalize(mix(_7507, reflect(_17138.xyz, _17892.xyz).xyz, vec3(_20711 * (sqrt(_20711) + _17225)))), 0.0), PerViewLightingConstantBufferGpu_t._m8.y * sqrt(_17172)).xyz).xyz * (normalize(_16991 + vec3(0.001000000047497451305389404296875)) * clamp(length(_16991), 0.0, 1.75))).xyz * (vec3(1.0) + (normalize(_8745 + vec3(0.001000000047497451305389404296875)) * 0.5))).xyz * _20418).xyz;
	    vec4 _13888 = _20497;
	    _13888.x = _15734.x;
	    _13888.y = _15734.y;
	    _13888.z = _15734.z;
	    vec4 _6805;
	    if (_Globals_.g_bFogEnabled != 0)
	    {
	        vec3 _21493;
	        vec3 _22956 = _10061.xyz - PerViewConstantBuffer_t._m5.xyz;
	        vec3 _9057 = _22956.xyz;
	        vec3 _19340;
	        do
	        {
	            _21493 = _22956.xyz;
	            bool _12894;
	            if (dot(_21493, _21493) > PerViewConstantBufferCsgo_t._m19.x)
	            {
	                _12894 = (_10061.z * PerViewConstantBufferCsgo_t._m19.z) < PerViewConstantBufferCsgo_t._m19.y;
	            }
	            else
	            {
	                _12894 = false;
	            }
	            SPIRV_CROSS_BRANCH
	            if (_12894)
	            {
	                vec2 _9342 = clamp(PerViewConstantBufferCsgo_t._m16.xy + (PerViewConstantBufferCsgo_t._m16.zw * vec2(length(_21493), _10061.z)), vec2(0.0), vec2(1.0));
	                float _12872 = (pow(_9342.x, PerViewConstantBufferCsgo_t._m17.x) * pow(_9342.y, PerViewConstantBufferCsgo_t._m17.y)) * PerViewConstantBufferCsgo_t._m18.w;
	                _19340 = mix(_13888.xyz, vec4(PerViewConstantBufferCsgo_t._m18.xyz, _12872).xyz, vec3(_12872));
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
	            bool _12895;
	            if (dot(_9057, _9057) > PerViewConstantBufferCsgo_t._m23.x)
	            {
	                _12895 = (PerViewConstantBufferCsgo_t._m23.z * _10061.z) < PerViewConstantBufferCsgo_t._m23.y;
	            }
	            else
	            {
	                _12895 = false;
	            }
	            if (_12895)
	            {
	                float _14602 = clamp(pow(max(0.0, (length(_21493) * PerViewConstantBufferCsgo_t._m20.y) + PerViewConstantBufferCsgo_t._m20.x), PerViewConstantBufferCsgo_t._m20.w), 0.0, 1.0) * clamp(pow(max(0.0, (_10061.z * PerViewConstantBufferCsgo_t._m21.y) + PerViewConstantBufferCsgo_t._m21.x), PerViewConstantBufferCsgo_t._m21.z), 0.0, 1.0);
	                float _8892 = saturate(_14602) * PerViewConstantBufferCsgo_t._m23.w;
	                _19341 = mix(_23944.xyz, vec4((textureLod(samplerCube(g_bindless_TextureCube_float4[PerViewConstantBufferCsgo_t._m2], g_bindless_Sampler[_Globals_.g_sTrilinearClamp]), normalize((PerViewConstantBufferCsgo_t._m22 * vec4(_9057, 0.0)).xyz).xyz, PerViewConstantBufferCsgo_t._m21.w * clamp(1.0 - (_14602 * PerViewConstantBufferCsgo_t._m20.z), 0.0, 1.0)) * PerViewConstantBufferCsgo_t._m24.x).xyz, _8892).xyz, vec3(_8892));
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
	
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
	
	BoolAttribute(BindlessResources, true);
	StringAttribute(MaterialLayerRefType, csgo_environment);
	BoolAttribute(GroupDefaultCollapseState_TextureTransform, true);
	BoolAttribute(GroupDefaultCollapseState_DetailTextureTransform, true);
	BoolAttribute(HasTexcoordTransform, ((g_nUVSet1>0) && (((g_vTexCoordScale1.x!=1) || (g_vTexCoordScale1.y!=1)) || (g_flTexCoordRotation1!=0))) || 0);
	BoolAttribute(environmentmapped, true);
	BoolAttribute(environmentmappeddynamic, true);
	BoolAttribute(NeedsLightProbe, true);
	BoolAttribute(DoNotCastShadows, F_DO_NOT_CAST_SHADOWS || 0);
	BoolAttribute(SupportsMappingDimensions, true);
	BoolAttribute(renderbackfaces, F_RENDER_BACKFACES || 0);
	BoolAttribute(SupportsLightmapping, true);
	BoolAttribute(PerVertexLighting, true);
	BoolAttribute(AllowBackfaceCulling, F_RENDER_BACKFACES ? 0 : 1);
	TextureAttribute(LightSim_DiffuseAlbedoTexture, g_tColor1);
	TextureAttribute(RepresentativeTexture, g_tColor1);
	FloatAttribute(OcclusionCullingBoundsScale, F_OCCLUSION_CULLING_BOUNDS_SCALE ? g_flOcclusionCullingBoundsScale : 1);
	
	#if (S_MATERIAL_REFERENCE == 0)
		BoolAttribute(alphatest, true);
		FloatAttribute(_dummyReferenceAlphaTestReferenceInMainShader, g_flAlphaTestReference);
		FloatAttribute(_dummyReferenceAntiAliasedEdgeStrengthReferenceInMainShader, g_flAntiAliasedEdgeStrength);
		BoolAttribute(NoZPrepass, true);
		BoolAttribute(AlphaTestZPrepass, true);
		TextureAttribute(LightSim_Opacity_A, g_tColor1);
	#endif
	#if (S_ALPHA_TEST_LAYER == 1)
		BoolAttribute(alphatest, true);
		FloatAttribute(_dummyReferenceAlphaTestReferenceInMainShader, g_flAlphaTestReference);
		FloatAttribute(_dummyReferenceAntiAliasedEdgeStrengthReferenceInMainShader, g_flAntiAliasedEdgeStrength);
		BoolAttribute(NoZPrepass, true);
		BoolAttribute(AlphaTestZPrepass, true);
		TextureAttribute(LightSim_Opacity_A, g_tColor1);
	#endif
	#if (S_ALPHA_TEST_LAYER == 0)
		IntAttribute(DepthPassBatchID, F_RENDER_BACKFACES ? 0 : 1);
		BoolAttribute(NoZPrepass, F_DISABLE_Z_PREPASS || 0);
	#endif
	#if (S_MATERIAL_REFERENCE == 1)
		IntAttribute(MaterialLayerCount, 1);
		StringAttribute(MaterialLayerType, csgo_environment);
	#endif
	
	// PSRS
	
	RenderState(BackStencilFunc, F_RENDER_BACKFACES ? 5 : 7);
	RenderState(CullMode, F_RENDER_BACKFACES ? None : Front);
	RenderState(CullMode, F_RENDER_BACKFACES ? None : Back);
	RenderState(DepthEnable, F_DISABLE_Z_BUFFERING ? False : True);
	RenderState(DepthFunc, Equal);
	RenderState(SlopeScaleDepthBias, 0);
	RenderState(StencilEnable, 1);
	RenderState(StencilFunc, 5);
	RenderState(StencilReadMask, 1);
	RenderState(StencilRef, 3);
	RenderState(StencilWriteMask, 254);
	
	
	BoolAttribute(BindlessResources, true);
	StringAttribute(MaterialLayerRefType, csgo_environment);
	
	#if (S_MATERIAL_REFERENCE == 1)
		IntAttribute(MaterialLayerCount, 1);
		StringAttribute(MaterialLayerType, csgo_environment);
	#endif
}

RTX
{
	StaticCombo( S_DETAIL_NORMAL, F_DETAIL_NORMAL );
	StaticCombo( S_MATERIAL_REFERENCE, F_MATERIAL_REFERENCE );
	StaticCombo( S_MODE_TOOLS_VIS, 0..1 );
	StaticCombo( S_ALPHA_TEST_LAYER, F_ALPHA_TEST );
	StaticCombo( S_MODE_DEPTH, 0..1 );
	StaticCombo( S_SHADER_QUALITY, 0..1 );
	StaticComboRule( Allow1( S_MODE_TOOLS_VIS, S_MODE_DEPTH ) );
	StaticComboRule( Requires( S_MODE_TOOLS_VIS, S_SHADER_QUALITY ) );
	StaticComboRule( Allow0( S_MODE_DEPTH ) );
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
	
	bool g_bAdjustBaseColor1 < UiType(CheckBox); Expression(g_nColorCorrectionMode1==1); >;
	bool g_bDontFlipBackfaceNormals < UiType(CheckBox); Expression(F_DONT_FLIP_BACKFACE_NORMALS || 0); >;
	bool g_bRenderBackfaceNormals < UiType(CheckBox); Expression((F_RENDER_BACKFACES && 1) || 0); >;
	float g_flReflectance < UiType(Slider); Expression(pow((1.5-1)/(1.5+1),2)); >;
	float4x4 g_mTextureAdjust1 < Expression(MatrixMultiply(MatrixColorTint2(float3(1,1,1),1),MatrixColorCorrect2(float3(g_fTextureColorContrast1,g_fTextureColorSaturation1,g_fTextureColorBrightness1),TextureAverageColor(g_tColor1)))); >;
	float4x4 g_mTextureColorAdjust1 < Expression(MatrixMultiply(MatrixColorTint2(g_vTextureColorTint1,1),MatrixColorCorrect2(float3(g_fTextureColorContrast1,g_fTextureColorSaturation1,g_fTextureColorBrightness1),TextureAverageColor(g_tColor1)))); >;
	float4x4 g_mTextureColorAdjust1 < Expression(MatrixMultiply(MatrixColorTint2(float3(1,1,1),1),MatrixColorCorrect2(float3(1,1,1),TextureAverageColor(g_tColor1)))); >;
	Texture2D g_tColor1 < Channel(RGB, ArtistDefined(TextureColor1), Srgb); Channel(A, Box(TextureAmbientOcclusion1), Linear); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tColor1 < Channel(RGB, ArtistDefinedOrAlphaWeighted(TextureColor1, TextureTranslucency1), Srgb); Channel(A, PreserveCoverage(TextureTranslucency1), Linear); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tHeight1 < Channel(R, ArtistDefined(TextureHeight1), Linear); Channel(G, ArtistDefined(TextureTintMask1), Linear); Channel(A, Box(TextureMetalness1), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tHeight1 < Channel(R, ArtistDefined(TextureHeight1), Linear); Channel(G, ArtistDefined(TextureTintMask1), Linear); Channel(B, Box(TextureAmbientOcclusion1), Linear); Channel(A, Box(TextureMetalness1), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tNormal1 < Channel(RGBA, HemiOctIsoRoughness_RG_B(TextureNormal1, TextureRoughness1), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tNormalDetail1 < Channel(RG, HemiOctIsoRoughness_RG_B(TextureNormalDetail1), Linear); OutputFormat(ATI2N); SrgbRead(false); >;
	float3 g_vBiplanarTexCoordScale < UiType(VectorText); Expression((1/64)*float3(-1,1,-1)); >;
	float4 g_vDetailNormalXform_1 < UiType(VectorText); Expression(v0 = (g_flDetailTexCoordRotation1*3.1415927)/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v1,-v2,v2,v1)); >;
	float4 g_vDetailTexCoordXform0_1 < UiType(VectorText); Expression(v0 = (g_flDetailTexCoordRotation1*3.1415927)/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v1*g_vDetailTexCoordScale1.x,-v2*g_vDetailTexCoordScale1.y,0,((g_vDetailTexCoordCenter1.x+g_vDetailTexCoordOffset1.x)+(v2*g_vDetailTexCoordCenter1.y))-(v1*g_vDetailTexCoordCenter1.x))); >;
	float4 g_vDetailTexCoordXform1_1 < UiType(VectorText); Expression(v0 = (g_flDetailTexCoordRotation1*3.1415927)/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v2*g_vDetailTexCoordScale1.x,v1*g_vDetailTexCoordScale1.y,0,(g_vDetailTexCoordCenter1.y+g_vDetailTexCoordOffset1.y)-((v2*g_vDetailTexCoordCenter1.x)+(v1*g_vDetailTexCoordCenter1.y)))); >;
	float4 g_vNormalXform_1 < UiType(VectorText); Expression(v0 = (g_flTexCoordRotation1*3.1415927)/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v1,-v2,v2,v1)); >;
	float4 g_vTexCoordXform0_1 < UiType(VectorText); Expression(v0 = (g_flTexCoordRotation1*3.1415927)/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v1*g_vTexCoordScale1.x,-v2*g_vTexCoordScale1.y,0,((g_vTexCoordCenter1.x+g_vTexCoordOffset1.x)+(v2*g_vTexCoordCenter1.y))-(v1*g_vTexCoordCenter1.x))); >;
	float4 g_vTexCoordXform1_1 < UiType(VectorText); Expression(v0 = (g_flTexCoordRotation1*3.1415927)/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v2*g_vTexCoordScale1.x,v1*g_vTexCoordScale1.y,0,(g_vTexCoordCenter1.y+g_vTexCoordOffset1.y)-((v2*g_vTexCoordCenter1.x)+(v1*g_vTexCoordCenter1.y)))); >;
	
	// Material1
	CreateInputTexture2D(TextureColor1, Srgb, 8, "", "_color", "Material1,0/Color,10/0", Default4(1, 1, 1, 0));
	CreateInputTexture2D(TextureNormal1, Linear, 8, "NormalizeNormals", "_normal", "Material1/Lighting/0", Default4(0.5, 0.5, 1, 0));
	CreateInputTexture2D(TextureTintMask1, Linear, 8, "", "_mask", "Material1/Tint Mask,15/0", Default4(1, 1, 1, 0));
	CreateInputTexture2D(TextureTranslucency1, Linear, 8, "", "_trans", "Material1/Translucent,15/0", Default4(1, 1, 1, 0));
	int g_nUVSet1 < Default(1); Range4(0, 0, 0, 0, 2, 2, 2, 2); UiOptions("0=Biplanar,1=UV1,2=UV2"); UiType(Enum); UiGroup("Material1/Texture Coordinates,34/1"); >;
	float2 g_vTexCoordCenter1 < Default2(0.5, 0.5); Attribute("0=X,1=Y"); UiType(VectorText); UiGroup("Material1/Texture Transform,35/1"); UiVisibility(1); >;
	int g_nDetailUVSet1 < Default(-1); Range4(-1, -1, -1, -1, 2, 2, 2, 2); UiOptions("-1=Inherit,0=Biplanar,1=UV1,2=UV2"); UiType(Enum); UiGroup("Material1/Texture Coordinates,34/2"); >;
	float2 g_vTexCoordScale1 < Default2(1, 1); Range2(0, 0, 100, 100); Attribute("0=X,1=Y"); UiType(VectorText); UiGroup("Material1/Texture Transform,35/2"); >;
	float2 g_vTexCoordOffset1 < Range2(-1, -1, 1, 1); Attribute("0=X,1=Y"); UiType(VectorText); UiGroup("Material1/Texture Transform,35/4"); UiVisibility(1); >;
	float g_fTintMaskBrightness1 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material1/Tint Mask/5"); >;
	float2 g_vDetailTexCoordCenter1 < Default2(0.5, 0.5); Attribute("0=X,1=Y"); UiType(VectorText); UiGroup("Material1/Detail Texture Transform/5"); UiVisibility(1); >;
	float2 g_vDetailTexCoordScale1 < Default2(1, 1); Range2(0, 0, 100, 100); Attribute("0=X,1=Y"); UiType(VectorText); UiGroup("Material1/Detail Texture Transform/6"); >;
	float g_flDetailTexCoordRotation1 < Range(-360, 360); UiType(Slider); UiGroup("Material1/Detail Texture Transform/8"); UiVisibility(1); >;
	float2 g_vDetailTexCoordOffset1 < Range2(-1, -1, 1, 1); Attribute("0=X,1=Y"); UiType(VectorText); UiGroup("Material1/Detail Texture Transform/9"); UiVisibility(1); >;
	CreateInputTexture2D(TextureHeight1, Linear, 8, "", "_height", "Material1/Height,30/10", Default4(0.5, 0.5, 0.5, 0));
	CreateInputTexture2D(TextureRoughness1, Linear, 8, "Inverse", "_rough", "Material1/Lighting/10", Default4(0.5, 0.5, 0.5, 0));
	float g_fTintMaskContrast1 < Default(1); Range(-2, 4); UiType(Slider); UiGroup("Material1/Tint Mask/10"); >;
	float3 g_vTextureColorTint1 < Default3(1, 1, 1); UiType(Color); UiGroup("Material1/Color Correction,17/10"); >;
	float g_fTextureRoughnessContrast1 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material1/Lighting/11"); >;
	float g_fTextureRoughnessBrightness1 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material1/Lighting/12"); >;
	float g_fTextureNormalContrast1 < Default(1); Range(-2, 2); UiType(Slider); UiGroup("Material1/Lighting/13"); >;
	float g_flTexCoordRotation1 < Range(-360, 360); UiType(Slider); UiGroup("Material1/Texture Transform,35/13"); UiVisibility(1); >;
	bool g_bMetalness1 < Default(1); UiType(CheckBox); UiGroup("Material1/Lighting/14"); >;
	CreateInputTexture2D(TextureAmbientOcclusion1, Linear, 8, "", "_ao", "Material1/Lighting,20/20", Default4(1, 1, 1, 0));
	float g_fTextureColorContrast1 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material1/Color Correction/20"); >;
	CreateInputTexture2D(TextureMetalness1, Linear, 8, "", "_metal", "Material1/Lighting/30", Default4(0, 0, 0, 0));
	float g_fTextureColorSaturation1 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material1/Color Correction/30"); >;
	CreateInputTexture2D(TextureNormalDetail1, Linear, 8, "NormalizeNormals", "_normal", "Material1/Detail/35", Default4(0.5, 0.5, 1, 0));
	float g_fTextureColorBrightness1 < Default(1); Range(-8, 8); UiType(Slider); UiGroup("Material1/Color Correction/40"); >;
	float g_fDetailTextureNormalContrast1 < Default(1); Range(-2, 2); UiType(Slider); UiGroup("Material1/Detail/45"); >;
	int g_nColorCorrectionMode1 < UiOptions("0=Mask All,1=Mask only Tint"); UiType(Enum); UiGroup("Material1/Color Correction/45"); >;
	bool g_bModelTint1 < Default(1); UiType(CheckBox); UiGroup("Material1/Color Correction/60"); >;
	
	// Translucent
	float g_flAlphaTestReference < Default(0.5); Range(0.01, 0.99); UiType(Slider); UiGroup("Translucent"); >;
	float g_flAntiAliasedEdgeStrength < Default(1); UiType(Slider); UiGroup("Translucent"); >;
	
	// Color
	float3 g_vColorTint < Default3(1, 1, 1); UiType(Color); UiGroup("Color,10/20"); Expression(SrgbGammaToLinear(this)); >;
	float g_flModelTintAmount < Default(1); UiType(Slider); UiGroup("Color,10/30"); >;
	int g_nScaleTexCoordUByModelScaleAxis < Range4(0, 0, 0, 0, 3, 3, 3, 3); UiOptions("0=None,1=UV.u * model.x,2=UV.u * model.y,3=UV.u * model.z"); UiType(Enum); UiGroup("Color/80"); >;
	int g_nScaleTexCoordVByModelScaleAxis < Range4(0, 0, 0, 0, 3, 3, 3, 3); UiOptions("0=None,1=UV.v * model.x,2=UV.v * model.y,3=UV.v * model.z"); UiType(Enum); UiGroup("Color/90"); >;
	
	// Texture Address Mode
	int g_nTextureAddressModeU < UiOption("RsTextureAddressMode_t"); UiType(Enum); UiGroup("Texture Address Mode"); >;
	int g_nTextureAddressModeV < UiOption("RsTextureAddressMode_t"); UiType(Enum); UiGroup("Texture Address Mode"); >;
	
	#if (S_MATERIAL_REFERENCE == 1)
		float4x4 g_mTextureColorAdjust1 < Expression(MatrixMultiply(MatrixColorTint2(g_vTextureColorTint1,1),MatrixColorCorrect2(float3(g_fTextureColorContrast1,g_fTextureColorSaturation1,g_fTextureColorBrightness1),TextureAverageColor(g_tColor1)))); >;
	#endif
	#if (S_ALPHA_TEST_LAYER == 1)
		Texture2D g_tHeight1 < Channel(R, ArtistDefined(TextureHeight1), Linear); Channel(G, ArtistDefined(TextureTintMask1), Linear); Channel(B, Box(TextureAmbientOcclusion1), Linear); Channel(A, Box(TextureMetalness1), Linear); OutputFormat(BC7); SrgbRead(false); >;
		Texture2D g_tColor1 < Channel(RGB, ArtistDefinedOrAlphaWeighted(TextureColor1, TextureTranslucency1), Srgb); Channel(A, PreserveCoverage(TextureTranslucency1), Linear); OutputFormat(BC7); SrgbRead(true); >;
	#endif
	
	// SPIR-V reflection failed for backend HLSL:
	// Unsupported builtin in HLSL: 5326
	//
	// Re-attempting reflection with the GLSL backend.
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (110164 bytes), GLSL reflection with SPIRV-Cross by KhronosGroup
	
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
	    vec2 vTexCoord2;
	    vec3 vNormalOs;
	    vec4 vTangentUOs_flTangentVSign;
	    uvec4 vBlendIndices;
	    uint nInstanceIdx;
	    vec4 vBlendColorTint;
	    vec4 vColorBlendValues;
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
	
	struct _RTX_MATERIAL_DATA_
	{
	    vec2 g_vDetailTexCoordScale;
	    float g_flDetailTexCoordRotation;
	    float _g_fl_AutoPad0_;
	    vec2 g_vDetailTexCoordOffset;
	    float _g_fl_AutoPad1_;
	    float _g_fl_AutoPad2_;
	    vec4 g_vDetailTexCoordXform;
	    float g_flDetailNormalStrength;
	    float _g_fl_AutoPad3_;
	    float _g_fl_AutoPad4_;
	    float _g_fl_AutoPad5_;
	    vec4 g_vDetailNormalStrengthOffsetScale;
	    vec2 g_vTexCoordCenter;
	    vec2 g_vTexCoordScale;
	    float g_flTexCoordRotation;
	    float _g_fl_AutoPad6_;
	    vec2 g_vTexCoordOffset;
	    vec4 g_vTexCoordXform0;
	    vec4 g_vTexCoordXform1;
	    vec2 g_vTexCoordScrollSpeed;
	    int g_nScaleTexCoordUByModelScaleAxis;
	    int g_nScaleTexCoordVByModelScaleAxis;
	    bool g_bTexCoordScaleByModel;
	    float _g_fl_AutoPad7_;
	    float _g_fl_AutoPad8_;
	    float _g_fl_AutoPad9_;
	    vec4 g_vTexCoordScaleByModelU;
	    vec4 g_vTexCoordScaleByModelV;
	    vec3 g_vColorTint;
	    float g_flModelTintAmount;
	    bool g_bUseSecondaryUvForDetailTexture;
	    float _g_fl_AutoPad10_;
	    float _g_fl_AutoPad11_;
	    float _g_fl_AutoPad12_;
	    vec3 g_vBiplanarTexCoordScale;
	    float g_flDetailPropMaskBias1;
	    float g_flDetailPropPuddleReduction1;
	    bool g_bSnowLayer1;
	    int g_nUVSet1;
	    float _g_fl_AutoPad13_;
	    vec2 g_vTexCoordScale1;
	    vec2 g_vTexCoordCenter1;
	    float g_flTexCoordRotation1;
	    float _g_fl_AutoPad14_;
	    vec2 g_vTexCoordOffset1;
	    vec4 g_vTexCoordXform0_1;
	    vec4 g_vTexCoordXform1_1;
	    vec4 g_vNormalXform_1;
	    float g_flWetnessDarkeningStrength1;
	    int g_nDetailUVSet1;
	    vec2 g_vDetailTexCoordScale1;
	    vec2 g_vDetailTexCoordCenter1;
	    float g_flDetailTexCoordRotation1;
	    float _g_fl_AutoPad15_;
	    vec2 g_vDetailTexCoordOffset1;
	    float _g_fl_AutoPad16_;
	    float _g_fl_AutoPad17_;
	    vec4 g_vDetailTexCoordXform0_1;
	    vec4 g_vDetailTexCoordXform1_1;
	    vec4 g_vDetailNormalXform_1;
	    uint g_tNormal1;
	    uint g_tHeight1;
	    uint g_tNormalDetail1;
	    float g_fDetailTextureNormalContrast1;
	    mat4 g_mTextureColorAdjust1;
	    mat4 g_mTextureAdjust1;
	    float g_flBlendSoftnessDistanceModifierStrength;
	    bool g_bPuddlesOnVerticalSurfaces;
	    bool g_bWetnessUseHeightmapAdjustments;
	    float g_flWetnessUnderlyingHeightMapInfluence;
	    float g_flHorizontalSurfaceTolerance;
	    float g_fPuddleStrength;
	    float g_fPuddleHeight;
	    float _g_fl_AutoPad18_;
	    vec3 g_vPuddleSedimentColor;
	    float g_fPuddleSedimentHeight;
	    float g_fPuddleSedimentOpacity;
	    float g_fPuddleRoughness;
	    float g_fPuddleBlendSoftness;
	    float g_fWetEdgeStrength;
	    float g_fWetEdgeSpread;
	    float g_fWetEdgeSoftness;
	    float g_fWetnessStrength;
	    float g_fRainStrength;
	    float g_fRippleStrength;
	    uint g_sAniso;
	    uint g_sBilinearClamp;
	    uint g_sTrilinearWrap;
	    uint g_sTrilinearClamp;
	    uint g_sPointClamp;
	    int g_nTextureAddressModeU;
	    int g_nTextureAddressModeV;
	    uint g_sUserConfig;
	    uint g_sUserConfigAllowGlobalMipBias;
	    uint g_tColor1;
	    bool g_bFogEnabled;
	    bool g_bDontFlipBackfaceNormals;
	    bool g_bRenderBackfaceNormals;
	    float g_flReflectance;
	    uint g_tAmbientOcclusion;
	    float g_flMetalness;
	    float g_flRetroReflectivity;
	    bool g_bWetness;
	    float _g_fl_AutoPad19_;
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
	
	const vec3 _417[3] = vec3[](vec3(-1.0, 0.0, 0.0), vec3(0.0, 1.0, 0.0), vec3(-1.0, 0.0, 0.0));
	const vec3 _421[3] = vec3[](vec3(0.0, 0.0, 1.0), vec3(0.0, -1.0, 0.0), vec3(0.0, 0.0, 1.0));
	
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
	
	vec4 _477;
	float _478;
	
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
	    int _member0[];
	} g_MaterialData_3;
	
	layout(set = 3, binding = 34, std430) readonly buffer g_MaterialData_4
	{
	    int _member0[];
	} g_MaterialData_5;
	
	layout(set = 3, binding = 34, std430) readonly buffer g_MaterialData_6
	{
	    uint _member0[];
	} g_MaterialData_7;
	
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
	    PackedRtxInstanceData_t_natural_logical _760;
	    _760.nSrgbColor = g_instanceBuffer._member0[uint(gl_InstanceID)].nSrgbColor;
	    _760.nTriangleGeometry = g_instanceBuffer._member0[uint(gl_InstanceID)].nTriangleGeometry;
	    _760.nMaterialData = g_instanceBuffer._member0[uint(gl_InstanceID)].nMaterialData;
	    _760.nMaterialFlags_nInstanceFlags = g_instanceBuffer._member0[uint(gl_InstanceID)].nMaterialFlags_nInstanceFlags;
	    _760.fEmissiveBoost = g_instanceBuffer._member0[uint(gl_InstanceID)].fEmissiveBoost;
	    _760.nInstanceFlags = g_instanceBuffer._member0[uint(gl_InstanceID)].nInstanceFlags;
	    _760._pad1 = g_instanceBuffer._member0[uint(gl_InstanceID)]._pad1;
	    _760._pad2 = g_instanceBuffer._member0[uint(gl_InstanceID)]._pad2;
	    uint _517 = _760.nMaterialData;
	    _RTX_MATERIAL_DATA_ _1563 = _RTX_MATERIAL_DATA_(vec2(g_MaterialData_1._member0[_517 / 4u], g_MaterialData_1._member0[(_517 + 4u) / 4u]), g_MaterialData_1._member0[(_517 + 8u) / 4u], g_MaterialData_1._member0[(_517 + 12u) / 4u], vec2(g_MaterialData_1._member0[(_517 + 16u) / 4u], g_MaterialData_1._member0[(_517 + 20u) / 4u]), g_MaterialData_1._member0[(_517 + 24u) / 4u], g_MaterialData_1._member0[(_517 + 28u) / 4u], vec4(g_MaterialData_1._member0[(_517 + 32u) / 4u], g_MaterialData_1._member0[(_517 + 36u) / 4u], g_MaterialData_1._member0[(_517 + 40u) / 4u], g_MaterialData_1._member0[(_517 + 44u) / 4u]), g_MaterialData_1._member0[(_517 + 48u) / 4u], g_MaterialData_1._member0[(_517 + 52u) / 4u], g_MaterialData_1._member0[(_517 + 56u) / 4u], g_MaterialData_1._member0[(_517 + 60u) / 4u], vec4(g_MaterialData_1._member0[(_517 + 64u) / 4u], g_MaterialData_1._member0[(_517 + 68u) / 4u], g_MaterialData_1._member0[(_517 + 72u) / 4u], g_MaterialData_1._member0[(_517 + 76u) / 4u]), vec2(g_MaterialData_1._member0[(_517 + 80u) / 4u], g_MaterialData_1._member0[(_517 + 84u) / 4u]), vec2(g_MaterialData_1._member0[(_517 + 88u) / 4u], g_MaterialData_1._member0[(_517 + 92u) / 4u]), g_MaterialData_1._member0[(_517 + 96u) / 4u], g_MaterialData_1._member0[(_517 + 100u) / 4u], vec2(g_MaterialData_1._member0[(_517 + 104u) / 4u], g_MaterialData_1._member0[(_517 + 108u) / 4u]), vec4(g_MaterialData_1._member0[(_517 + 112u) / 4u], g_MaterialData_1._member0[(_517 + 116u) / 4u], g_MaterialData_1._member0[(_517 + 120u) / 4u], g_MaterialData_1._member0[(_517 + 124u) / 4u]), vec4(g_MaterialData_1._member0[(_517 + 128u) / 4u], g_MaterialData_1._member0[(_517 + 132u) / 4u], g_MaterialData_1._member0[(_517 + 136u) / 4u], g_MaterialData_1._member0[(_517 + 140u) / 4u]), vec2(g_MaterialData_1._member0[(_517 + 144u) / 4u], g_MaterialData_1._member0[(_517 + 148u) / 4u]), g_MaterialData_3._member0[(_517 + 152u) / 4u], g_MaterialData_3._member0[(_517 + 156u) / 4u], g_MaterialData_5._member0[(_517 + 160u) / 4u] != 0, g_MaterialData_1._member0[(_517 + 164u) / 4u], g_MaterialData_1._member0[(_517 + 168u) / 4u], g_MaterialData_1._member0[(_517 + 172u) / 4u], vec4(g_MaterialData_1._member0[(_517 + 176u) / 4u], g_MaterialData_1._member0[(_517 + 180u) / 4u], g_MaterialData_1._member0[(_517 + 184u) / 4u], g_MaterialData_1._member0[(_517 + 188u) / 4u]), vec4(g_MaterialData_1._member0[(_517 + 192u) / 4u], g_MaterialData_1._member0[(_517 + 196u) / 4u], g_MaterialData_1._member0[(_517 + 200u) / 4u], g_MaterialData_1._member0[(_517 + 204u) / 4u]), vec3(g_MaterialData_1._member0[(_517 + 208u) / 4u], g_MaterialData_1._member0[(_517 + 212u) / 4u], g_MaterialData_1._member0[(_517 + 216u) / 4u]), g_MaterialData_1._member0[(_517 + 220u) / 4u], g_MaterialData_5._member0[(_517 + 224u) / 4u] != 0, g_MaterialData_1._member0[(_517 + 228u) / 4u], g_MaterialData_1._member0[(_517 + 232u) / 4u], g_MaterialData_1._member0[(_517 + 236u) / 4u], vec3(g_MaterialData_1._member0[(_517 + 240u) / 4u], g_MaterialData_1._member0[(_517 + 244u) / 4u], g_MaterialData_1._member0[(_517 + 248u) / 4u]), g_MaterialData_1._member0[(_517 + 252u) / 4u], g_MaterialData_1._member0[(_517 + 256u) / 4u], g_MaterialData_5._member0[(_517 + 260u) / 4u] != 0, g_MaterialData_3._member0[(_517 + 264u) / 4u], g_MaterialData_1._member0[(_517 + 268u) / 4u], vec2(g_MaterialData_1._member0[(_517 + 272u) / 4u], g_MaterialData_1._member0[(_517 + 276u) / 4u]), vec2(g_MaterialData_1._member0[(_517 + 280u) / 4u], g_MaterialData_1._member0[(_517 + 284u) / 4u]), g_MaterialData_1._member0[(_517 + 288u) / 4u], g_MaterialData_1._member0[(_517 + 292u) / 4u], vec2(g_MaterialData_1._member0[(_517 + 296u) / 4u], g_MaterialData_1._member0[(_517 + 300u) / 4u]), vec4(g_MaterialData_1._member0[(_517 + 304u) / 4u], g_MaterialData_1._member0[(_517 + 308u) / 4u], g_MaterialData_1._member0[(_517 + 312u) / 4u], g_MaterialData_1._member0[(_517 + 316u) / 4u]), vec4(g_MaterialData_1._member0[(_517 + 320u) / 4u], g_MaterialData_1._member0[(_517 + 324u) / 4u], g_MaterialData_1._member0[(_517 + 328u) / 4u], g_MaterialData_1._member0[(_517 + 332u) / 4u]), vec4(g_MaterialData_1._member0[(_517 + 336u) / 4u], g_MaterialData_1._member0[(_517 + 340u) / 4u], g_MaterialData_1._member0[(_517 + 344u) / 4u], g_MaterialData_1._member0[(_517 + 348u) / 4u]), g_MaterialData_1._member0[(_517 + 352u) / 4u], g_MaterialData_3._member0[(_517 + 356u) / 4u], vec2(g_MaterialData_1._member0[(_517 + 360u) / 4u], g_MaterialData_1._member0[(_517 + 364u) / 4u]), vec2(g_MaterialData_1._member0[(_517 + 368u) / 4u], g_MaterialData_1._member0[(_517 + 372u) / 4u]), g_MaterialData_1._member0[(_517 + 376u) / 4u], g_MaterialData_1._member0[(_517 + 380u) / 4u], vec2(g_MaterialData_1._member0[(_517 + 384u) / 4u], g_MaterialData_1._member0[(_517 + 388u) / 4u]), g_MaterialData_1._member0[(_517 + 392u) / 4u], g_MaterialData_1._member0[(_517 + 396u) / 4u], vec4(g_MaterialData_1._member0[(_517 + 400u) / 4u], g_MaterialData_1._member0[(_517 + 404u) / 4u], g_MaterialData_1._member0[(_517 + 408u) / 4u], g_MaterialData_1._member0[(_517 + 412u) / 4u]), vec4(g_MaterialData_1._member0[(_517 + 416u) / 4u], g_MaterialData_1._member0[(_517 + 420u) / 4u], g_MaterialData_1._member0[(_517 + 424u) / 4u], g_MaterialData_1._member0[(_517 + 428u) / 4u]), vec4(g_MaterialData_1._member0[(_517 + 432u) / 4u], g_MaterialData_1._member0[(_517 + 436u) / 4u], g_MaterialData_1._member0[(_517 + 440u) / 4u], g_MaterialData_1._member0[(_517 + 444u) / 4u]), g_MaterialData_7._member0[(_517 + 448u) / 4u], g_MaterialData_7._member0[(_517 + 452u) / 4u], g_MaterialData_7._member0[(_517 + 456u) / 4u], g_MaterialData_1._member0[(_517 + 460u) / 4u], mat4(vec4(g_MaterialData_1._member0[(_517 + 464u) / 4u], g_MaterialData_1._member0[(_517 + 480u) / 4u], g_MaterialData_1._member0[(_517 + 496u) / 4u], g_MaterialData_1._member0[(_517 + 512u) / 4u]), vec4(g_MaterialData_1._member0[(_517 + 468u) / 4u], g_MaterialData_1._member0[(_517 + 484u) / 4u], g_MaterialData_1._member0[(_517 + 500u) / 4u], g_MaterialData_1._member0[(_517 + 516u) / 4u]), vec4(g_MaterialData_1._member0[(_517 + 472u) / 4u], g_MaterialData_1._member0[(_517 + 488u) / 4u], g_MaterialData_1._member0[(_517 + 504u) / 4u], g_MaterialData_1._member0[(_517 + 520u) / 4u]), vec4(g_MaterialData_1._member0[(_517 + 476u) / 4u], g_MaterialData_1._member0[(_517 + 492u) / 4u], g_MaterialData_1._member0[(_517 + 508u) / 4u], g_MaterialData_1._member0[(_517 + 524u) / 4u])), mat4(vec4(g_MaterialData_1._member0[(_517 + 528u) / 4u], g_MaterialData_1._member0[(_517 + 544u) / 4u], g_MaterialData_1._member0[(_517 + 560u) / 4u], g_MaterialData_1._member0[(_517 + 576u) / 4u]), vec4(g_MaterialData_1._member0[(_517 + 532u) / 4u], g_MaterialData_1._member0[(_517 + 548u) / 4u], g_MaterialData_1._member0[(_517 + 564u) / 4u], g_MaterialData_1._member0[(_517 + 580u) / 4u]), vec4(g_MaterialData_1._member0[(_517 + 536u) / 4u], g_MaterialData_1._member0[(_517 + 552u) / 4u], g_MaterialData_1._member0[(_517 + 568u) / 4u], g_MaterialData_1._member0[(_517 + 584u) / 4u]), vec4(g_MaterialData_1._member0[(_517 + 540u) / 4u], g_MaterialData_1._member0[(_517 + 556u) / 4u], g_MaterialData_1._member0[(_517 + 572u) / 4u], g_MaterialData_1._member0[(_517 + 588u) / 4u])), g_MaterialData_1._member0[(_517 + 592u) / 4u], g_MaterialData_5._member0[(_517 + 596u) / 4u] != 0, g_MaterialData_5._member0[(_517 + 600u) / 4u] != 0, g_MaterialData_1._member0[(_517 + 604u) / 4u], g_MaterialData_1._member0[(_517 + 608u) / 4u], g_MaterialData_1._member0[(_517 + 612u) / 4u], g_MaterialData_1._member0[(_517 + 616u) / 4u], g_MaterialData_1._member0[(_517 + 620u) / 4u], vec3(g_MaterialData_1._member0[(_517 + 624u) / 4u], g_MaterialData_1._member0[(_517 + 628u) / 4u], g_MaterialData_1._member0[(_517 + 632u) / 4u]), g_MaterialData_1._member0[(_517 + 636u) / 4u], g_MaterialData_1._member0[(_517 + 640u) / 4u], g_MaterialData_1._member0[(_517 + 644u) / 4u], g_MaterialData_1._member0[(_517 + 648u) / 4u], g_MaterialData_1._member0[(_517 + 652u) / 4u], g_MaterialData_1._member0[(_517 + 656u) / 4u], g_MaterialData_1._member0[(_517 + 660u) / 4u], g_MaterialData_1._member0[(_517 + 664u) / 4u], g_MaterialData_1._member0[(_517 + 668u) / 4u], g_MaterialData_1._member0[(_517 + 672u) / 4u], g_MaterialData_7._member0[(_517 + 676u) / 4u], g_MaterialData_7._member0[(_517 + 680u) / 4u], g_MaterialData_7._member0[(_517 + 684u) / 4u], g_MaterialData_7._member0[(_517 + 688u) / 4u], g_MaterialData_7._member0[(_517 + 692u) / 4u], g_MaterialData_3._member0[(_517 + 696u) / 4u], g_MaterialData_3._member0[(_517 + 700u) / 4u], g_MaterialData_7._member0[(_517 + 704u) / 4u], g_MaterialData_7._member0[(_517 + 708u) / 4u], g_MaterialData_7._member0[(_517 + 712u) / 4u], g_MaterialData_5._member0[(_517 + 716u) / 4u] != 0, g_MaterialData_5._member0[(_517 + 720u) / 4u] != 0, g_MaterialData_5._member0[(_517 + 724u) / 4u] != 0, g_MaterialData_1._member0[(_517 + 728u) / 4u], g_MaterialData_7._member0[(_517 + 732u) / 4u], g_MaterialData_1._member0[(_517 + 736u) / 4u], g_MaterialData_1._member0[(_517 + 740u) / 4u], g_MaterialData_5._member0[(_517 + 744u) / 4u] != 0, g_MaterialData_1._member0[(_517 + 748u) / 4u]);
	    _RTX_MATERIAL_DATA_ _g_rtx_material_data_ = _1563;
	    uvec3 _753;
	    do
	    {
	        if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes.w == 4)
	        {
	            uint _1611 = (12u * uint(gl_PrimitiveID)) + uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes.w);
	            _753 = uvec3(g_Indices_1[g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._member0[_1611 / 4u], g_Indices_1[g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._member0[(_1611 + 4u) / 4u], g_Indices_1[g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._member0[(_1611 + 8u) / 4u]);
	            break;
	        }
	        else
	        {
	            uint _1584 = (6u * uint(gl_PrimitiveID)) + uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes.w);
	            uint _1585 = _1584 & 4294967292u;
	            uint _1586 = _1585 / 4u;
	            uint _1590 = (_1585 + 4u) / 4u;
	            uint _1595 = (g_Indices_1[g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._member0[_1586] & 4294901760u) >> uint(16);
	            uint _1596 = g_Indices_1[g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._member0[_1590] & 65535u;
	            uvec3 _754;
	            if (_1584 == _1585)
	            {
	                _754 = uvec3(g_Indices_1[g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._member0[_1586] & 65535u, _1595, _1596);
	            }
	            else
	            {
	                _754 = uvec3(_1595, _1596, (g_Indices_1[g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._member0[_1590] & 4294901760u) >> uint(16));
	            }
	            _753 = _754;
	            break;
	        }
	        break;
	    } while(false);
	    uint _61 = uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.x);
	    uvec3 _1642 = (uvec3(uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes.x)) * _753) + uvec3(uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes.x));
	    vec3 _747[3];
	    uint _1644 = _1642.x;
	    _747[0] = vec3(g_Vertices_1[_61]._member0[_1644 / 4u], g_Vertices_1[_61]._member0[(_1644 + 4u) / 4u], g_Vertices_1[_61]._member0[(_1644 + 8u) / 4u]);
	    uint _1658 = _1642.y;
	    _747[1] = vec3(g_Vertices_1[_61]._member0[_1658 / 4u], g_Vertices_1[_61]._member0[(_1658 + 4u) / 4u], g_Vertices_1[_61]._member0[(_1658 + 8u) / 4u]);
	    uint _1672 = _1642.z;
	    _747[2] = vec3(g_Vertices_1[_61]._member0[_1672 / 4u], g_Vertices_1[_61]._member0[(_1672 + 4u) / 4u], g_Vertices_1[_61]._member0[(_1672 + 8u) / 4u]);
	    int _748 = 0;
	    VS_INPUT vsInput[3];
	    for (;;)
	    {
	        if (!(_748 < 3))
	        {
	            break;
	        }
	        vsInput[_748].vPositionOs = _747[_748];
	        _748++;
	        continue;
	    }
	    vec2 _749[3];
	    _749[0] = vec2(0.0);
	    _749[1] = vec2(0.0);
	    _749[2] = vec2(0.0);
	    if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].y != 0)
	    {
	        ivec4 _746 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers;
	        uint _63 = uint(_746[g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].z]);
	        uint _1723 = uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].z);
	        ivec4 _744 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes;
	        ivec4 _745 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes;
	        uvec3 _1739 = (uvec3(uint(_744[_1723])) * _753) + uvec3(uint(_745[_1723]) + uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].x));
	        if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].y == 16)
	        {
	            uint _1871 = _1739.x;
	            _749[0] = vec2(g_Vertices_1[_63]._member0[_1871 / 4u], g_Vertices_1[_63]._member0[(_1871 + 4u) / 4u]);
	            uint _1880 = _1739.y;
	            _749[1] = vec2(g_Vertices_1[_63]._member0[_1880 / 4u], g_Vertices_1[_63]._member0[(_1880 + 4u) / 4u]);
	            uint _1889 = _1739.z;
	            _749[2] = vec2(g_Vertices_1[_63]._member0[_1889 / 4u], g_Vertices_1[_63]._member0[(_1889 + 4u) / 4u]);
	        }
	        else
	        {
	            if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].y == 34)
	            {
	                uint _1842 = _1739.x / 4u;
	                _749[0] = vec2(uint16BitsToFloat16(u16vec2(uvec2(g_Vertices_3[_63]._member0[_1842], g_Vertices_3[_63]._member0[_1842] >> uint(16)) & uvec2(65535u))));
	                uint _1852 = _1739.y / 4u;
	                _749[1] = vec2(uint16BitsToFloat16(u16vec2(uvec2(g_Vertices_3[_63]._member0[_1852], g_Vertices_3[_63]._member0[_1852] >> uint(16)) & uvec2(65535u))));
	                uint _1862 = _1739.z / 4u;
	                _749[2] = vec2(uint16BitsToFloat16(u16vec2(uvec2(g_Vertices_3[_63]._member0[_1862], g_Vertices_3[_63]._member0[_1862] >> uint(16)) & uvec2(65535u))));
	            }
	            else
	            {
	                if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].y == 37)
	                {
	                    uint _1752 = _1739.x / 4u;
	                    uint _1755 = g_Vertices_3[_63]._member0[_1752] & 65535u;
	                    int _743;
	                    if (_1755 > 32767u)
	                    {
	                        _743 = int(4294901760u | _1755);
	                    }
	                    else
	                    {
	                        _743 = int(_1755);
	                    }
	                    uint _1768 = (g_Vertices_3[_63]._member0[_1752] & 4294901760u) >> uint(16);
	                    int _742;
	                    if (_1768 > 32767u)
	                    {
	                        _742 = int(4294901760u | _1768);
	                    }
	                    else
	                    {
	                        _742 = int(_1768);
	                    }
	                    _749[0] = vec2(max(float(_743) * 3.0518509447574615478515625e-05, -1.0), max(float(_742) * 3.0518509447574615478515625e-05, -1.0));
	                    uint _1782 = _1739.y / 4u;
	                    uint _1785 = g_Vertices_3[_63]._member0[_1782] & 65535u;
	                    int _741;
	                    if (_1785 > 32767u)
	                    {
	                        _741 = int(4294901760u | _1785);
	                    }
	                    else
	                    {
	                        _741 = int(_1785);
	                    }
	                    uint _1798 = (g_Vertices_3[_63]._member0[_1782] & 4294901760u) >> uint(16);
	                    int _740;
	                    if (_1798 > 32767u)
	                    {
	                        _740 = int(4294901760u | _1798);
	                    }
	                    else
	                    {
	                        _740 = int(_1798);
	                    }
	                    _749[1] = vec2(max(float(_741) * 3.0518509447574615478515625e-05, -1.0), max(float(_740) * 3.0518509447574615478515625e-05, -1.0));
	                    uint _1812 = _1739.z / 4u;
	                    uint _1815 = g_Vertices_3[_63]._member0[_1812] & 65535u;
	                    int _739;
	                    if (_1815 > 32767u)
	                    {
	                        _739 = int(4294901760u | _1815);
	                    }
	                    else
	                    {
	                        _739 = int(_1815);
	                    }
	                    uint _1828 = (g_Vertices_3[_63]._member0[_1812] & 4294901760u) >> uint(16);
	                    int _738;
	                    if (_1828 > 32767u)
	                    {
	                        _738 = int(4294901760u | _1828);
	                    }
	                    else
	                    {
	                        _738 = int(_1828);
	                    }
	                    _749[2] = vec2(max(float(_739) * 3.0518509447574615478515625e-05, -1.0), max(float(_738) * 3.0518509447574615478515625e-05, -1.0));
	                }
	            }
	        }
	    }
	    _748 = 0;
	    for (;;)
	    {
	        if (!(_748 < 3))
	        {
	            break;
	        }
	        vsInput[_748].vTexCoord = _749[_748];
	        _748++;
	        continue;
	    }
	    _749[0] = vec2(0.0);
	    _749[1] = vec2(0.0);
	    _749[2] = vec2(0.0);
	    if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[1].y != 0)
	    {
	        ivec4 _737 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers;
	        uint _67 = uint(_737[g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[1].z]);
	        uint _1934 = uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[1].z);
	        ivec4 _735 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes;
	        ivec4 _736 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes;
	        uvec3 _1950 = (uvec3(uint(_735[_1934])) * _753) + uvec3(uint(_736[_1934]) + uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[1].x));
	        if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[1].y == 16)
	        {
	            uint _2082 = _1950.x;
	            _749[0] = vec2(g_Vertices_1[_67]._member0[_2082 / 4u], g_Vertices_1[_67]._member0[(_2082 + 4u) / 4u]);
	            uint _2091 = _1950.y;
	            _749[1] = vec2(g_Vertices_1[_67]._member0[_2091 / 4u], g_Vertices_1[_67]._member0[(_2091 + 4u) / 4u]);
	            uint _2100 = _1950.z;
	            _749[2] = vec2(g_Vertices_1[_67]._member0[_2100 / 4u], g_Vertices_1[_67]._member0[(_2100 + 4u) / 4u]);
	        }
	        else
	        {
	            if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[1].y == 34)
	            {
	                uint _2053 = _1950.x / 4u;
	                _749[0] = vec2(uint16BitsToFloat16(u16vec2(uvec2(g_Vertices_3[_67]._member0[_2053], g_Vertices_3[_67]._member0[_2053] >> uint(16)) & uvec2(65535u))));
	                uint _2063 = _1950.y / 4u;
	                _749[1] = vec2(uint16BitsToFloat16(u16vec2(uvec2(g_Vertices_3[_67]._member0[_2063], g_Vertices_3[_67]._member0[_2063] >> uint(16)) & uvec2(65535u))));
	                uint _2073 = _1950.z / 4u;
	                _749[2] = vec2(uint16BitsToFloat16(u16vec2(uvec2(g_Vertices_3[_67]._member0[_2073], g_Vertices_3[_67]._member0[_2073] >> uint(16)) & uvec2(65535u))));
	            }
	            else
	            {
	                if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[1].y == 37)
	                {
	                    uint _1963 = _1950.x / 4u;
	                    uint _1966 = g_Vertices_3[_67]._member0[_1963] & 65535u;
	                    int _734;
	                    if (_1966 > 32767u)
	                    {
	                        _734 = int(4294901760u | _1966);
	                    }
	                    else
	                    {
	                        _734 = int(_1966);
	                    }
	                    uint _1979 = (g_Vertices_3[_67]._member0[_1963] & 4294901760u) >> uint(16);
	                    int _733;
	                    if (_1979 > 32767u)
	                    {
	                        _733 = int(4294901760u | _1979);
	                    }
	                    else
	                    {
	                        _733 = int(_1979);
	                    }
	                    _749[0] = vec2(max(float(_734) * 3.0518509447574615478515625e-05, -1.0), max(float(_733) * 3.0518509447574615478515625e-05, -1.0));
	                    uint _1993 = _1950.y / 4u;
	                    uint _1996 = g_Vertices_3[_67]._member0[_1993] & 65535u;
	                    int _732;
	                    if (_1996 > 32767u)
	                    {
	                        _732 = int(4294901760u | _1996);
	                    }
	                    else
	                    {
	                        _732 = int(_1996);
	                    }
	                    uint _2009 = (g_Vertices_3[_67]._member0[_1993] & 4294901760u) >> uint(16);
	                    int _731;
	                    if (_2009 > 32767u)
	                    {
	                        _731 = int(4294901760u | _2009);
	                    }
	                    else
	                    {
	                        _731 = int(_2009);
	                    }
	                    _749[1] = vec2(max(float(_732) * 3.0518509447574615478515625e-05, -1.0), max(float(_731) * 3.0518509447574615478515625e-05, -1.0));
	                    uint _2023 = _1950.z / 4u;
	                    uint _2026 = g_Vertices_3[_67]._member0[_2023] & 65535u;
	                    int _730;
	                    if (_2026 > 32767u)
	                    {
	                        _730 = int(4294901760u | _2026);
	                    }
	                    else
	                    {
	                        _730 = int(_2026);
	                    }
	                    uint _2039 = (g_Vertices_3[_67]._member0[_2023] & 4294901760u) >> uint(16);
	                    int _729;
	                    if (_2039 > 32767u)
	                    {
	                        _729 = int(4294901760u | _2039);
	                    }
	                    else
	                    {
	                        _729 = int(_2039);
	                    }
	                    _749[2] = vec2(max(float(_730) * 3.0518509447574615478515625e-05, -1.0), max(float(_729) * 3.0518509447574615478515625e-05, -1.0));
	                }
	            }
	        }
	    }
	    _748 = 0;
	    for (;;)
	    {
	        if (!(_748 < 3))
	        {
	            break;
	        }
	        vsInput[_748].vTexCoord2 = _749[_748];
	        _748++;
	        continue;
	    }
	    vec3 _750[3];
	    vec4 _751[3];
	    do
	    {
	        if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.y != 0)
	        {
	            ivec4 _715 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers;
	            uint _71 = uint(_715[g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.z]);
	            uint _2150 = uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.z);
	            ivec4 _713 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes;
	            ivec4 _714 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes;
	            uvec3 _2166 = (uvec3(uint(_713[_2150])) * _753) + uvec3(uint(_714[_2150]) + uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.x));
	            if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.y == 6)
	            {
	                uint _2694 = _2166.x;
	                _750[0] = vec3(g_Vertices_1[_71]._member0[_2694 / 4u], g_Vertices_1[_71]._member0[(_2694 + 4u) / 4u], g_Vertices_1[_71]._member0[(_2694 + 8u) / 4u]);
	                uint _2708 = _2166.y;
	                _750[1] = vec3(g_Vertices_1[_71]._member0[_2708 / 4u], g_Vertices_1[_71]._member0[(_2708 + 4u) / 4u], g_Vertices_1[_71]._member0[(_2708 + 8u) / 4u]);
	                uint _2722 = _2166.z;
	                _750[2] = vec3(g_Vertices_1[_71]._member0[_2722 / 4u], g_Vertices_1[_71]._member0[(_2722 + 4u) / 4u], g_Vertices_1[_71]._member0[(_2722 + 8u) / 4u]);
	            }
	            else
	            {
	                if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.y == 17)
	                {
	                    uint _2430 = _2166.x;
	                    uvec2 _2438 = uvec2(g_Vertices_3[_71]._member0[_2430 / 4u], g_Vertices_3[_71]._member0[(_2430 + 4u) / 4u]);
	                    uint _2439 = _2166.y;
	                    uvec2 _498 = uvec2(g_Vertices_3[_71]._member0[_2439 / 4u], g_Vertices_3[_71]._member0[(_2439 + 4u) / 4u]);
	                    uint _2448 = _2166.z;
	                    uvec2 _497 = uvec2(g_Vertices_3[_71]._member0[_2448 / 4u], g_Vertices_3[_71]._member0[(_2448 + 4u) / 4u]);
	                    uint _2460 = _2438.x;
	                    uint _2468 = _2438.y;
	                    vec2 _2478 = ((vec2(float(_2460 & 65535u), float((_2460 >> 16u) & 65535u)) * vec2(1.525902189314365386962890625e-05)) * 2.0) - vec2(1.0);
	                    float _2479 = _2478.x;
	                    float _2484 = (1.0 - abs(_2479)) - abs(_2478.y);
	                    vec3 _2485 = vec3(_2479, _2478.y, _2484);
	                    float _2487 = saturate(-_2484);
	                    vec2 _2493 = _2478 + mix(vec2(_2487), vec2(-_2487), greaterThanEqual(_2478, vec2(0.0)));
	                    _2485.x = _2493.x;
	                    _2485.y = _2493.y;
	                    vec3 _717 = normalize(_2485);
	                    vec2 _2500 = ((vec2(float((_2468 >> uint(1)) & 32767u), float((_2468 >> 16u) & 32767u)) * vec2(3.0518509447574615478515625e-05)) * 2.0) - vec2(1.0);
	                    float _2501 = _2500.x;
	                    float _2506 = (1.0 - abs(_2501)) - abs(_2500.y);
	                    vec3 _2507 = vec3(_2501, _2500.y, _2506);
	                    float _2509 = saturate(-_2506);
	                    vec2 _2515 = _2500 + mix(vec2(_2509), vec2(-_2509), greaterThanEqual(_2500, vec2(0.0)));
	                    _2507.x = _2515.x;
	                    _2507.y = _2515.y;
	                    vec3 _716 = normalize(_2507);
	                    float _703;
	                    if ((_2468 & 1u) != 0u)
	                    {
	                        _703 = 1.0;
	                    }
	                    else
	                    {
	                        _703 = -1.0;
	                    }
	                    _750[0] = _717;
	                    _751[0].w = _703;
	                    _751[0].x = _716.x;
	                    _751[0].y = _716.y;
	                    _751[0].z = _716.z;
	                    vec2 _2557 = ((vec2(float(_498.x & 65535u), float((_498.x >> 16u) & 65535u)) * vec2(1.525902189314365386962890625e-05)) * 2.0) - vec2(1.0);
	                    float _2558 = _2557.x;
	                    float _2563 = (1.0 - abs(_2558)) - abs(_2557.y);
	                    vec3 _2564 = vec3(_2558, _2557.y, _2563);
	                    float _2566 = saturate(-_2563);
	                    vec2 _2572 = _2557 + mix(vec2(_2566), vec2(-_2566), greaterThanEqual(_2557, vec2(0.0)));
	                    _2564.x = _2572.x;
	                    _2564.y = _2572.y;
	                    vec3 _719 = normalize(_2564);
	                    vec2 _2579 = ((vec2(float((_498.y >> uint(1)) & 32767u), float((_498.y >> 16u) & 32767u)) * vec2(3.0518509447574615478515625e-05)) * 2.0) - vec2(1.0);
	                    float _2580 = _2579.x;
	                    float _2585 = (1.0 - abs(_2580)) - abs(_2579.y);
	                    vec3 _2586 = vec3(_2580, _2579.y, _2585);
	                    float _2588 = saturate(-_2585);
	                    vec2 _2594 = _2579 + mix(vec2(_2588), vec2(-_2588), greaterThanEqual(_2579, vec2(0.0)));
	                    _2586.x = _2594.x;
	                    _2586.y = _2594.y;
	                    vec3 _718 = normalize(_2586);
	                    float _702;
	                    if ((_498.y & 1u) != 0u)
	                    {
	                        _702 = 1.0;
	                    }
	                    else
	                    {
	                        _702 = -1.0;
	                    }
	                    _750[1] = _719;
	                    _751[1].w = _702;
	                    _751[1].x = _718.x;
	                    _751[1].y = _718.y;
	                    _751[1].z = _718.z;
	                    vec2 _2636 = ((vec2(float(_497.x & 65535u), float((_497.x >> 16u) & 65535u)) * vec2(1.525902189314365386962890625e-05)) * 2.0) - vec2(1.0);
	                    float _2637 = _2636.x;
	                    float _2642 = (1.0 - abs(_2637)) - abs(_2636.y);
	                    vec3 _2643 = vec3(_2637, _2636.y, _2642);
	                    float _2645 = saturate(-_2642);
	                    vec2 _2651 = _2636 + mix(vec2(_2645), vec2(-_2645), greaterThanEqual(_2636, vec2(0.0)));
	                    _2643.x = _2651.x;
	                    _2643.y = _2651.y;
	                    vec3 _721 = normalize(_2643);
	                    vec2 _2658 = ((vec2(float((_497.y >> uint(1)) & 32767u), float((_497.y >> 16u) & 32767u)) * vec2(3.0518509447574615478515625e-05)) * 2.0) - vec2(1.0);
	                    float _2659 = _2658.x;
	                    float _2664 = (1.0 - abs(_2659)) - abs(_2658.y);
	                    vec3 _2665 = vec3(_2659, _2658.y, _2664);
	                    float _2667 = saturate(-_2664);
	                    vec2 _2673 = _2658 + mix(vec2(_2667), vec2(-_2667), greaterThanEqual(_2658, vec2(0.0)));
	                    _2665.x = _2673.x;
	                    _2665.y = _2673.y;
	                    vec3 _720 = normalize(_2665);
	                    float _701;
	                    if ((_497.y & 1u) != 0u)
	                    {
	                        _701 = 1.0;
	                    }
	                    else
	                    {
	                        _701 = -1.0;
	                    }
	                    _750[2] = _721;
	                    _751[2].w = _701;
	                    _751[2].x = _720.x;
	                    _751[2].y = _720.y;
	                    _751[2].z = _720.z;
	                    break;
	                }
	                else
	                {
	                    uint _2176 = _2166.x / 4u;
	                    vec4 _723 = _751[0];
	                    float _2191 = (float((g_Vertices_3[_71]._member0[_2176] >> 12u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _2194 = (float((g_Vertices_3[_71]._member0[_2176] >> 22u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _2198 = (1.0 - abs(_2191)) - abs(_2194);
	                    vec3 _2199 = vec3(_2191, _2194, _2198);
	                    float _2201 = saturate(-_2198);
	                    vec2 _2202 = vec2(_2191, _2194);
	                    vec2 _2208 = _2202 + mix(vec2(_2201), vec2(-_2201), greaterThanEqual(_2202, vec2(0.0)));
	                    _2199.x = _2208.x;
	                    _2199.y = _2208.y;
	                    vec3 _2213 = normalize(_2199);
	                    vec3 _722 = _2213;
	                    float _2214 = _2213.z;
	                    float _710;
	                    if (_2214 >= 0.0)
	                    {
	                        _710 = 1.0;
	                    }
	                    else
	                    {
	                        _710 = -1.0;
	                    }
	                    float _2221 = (-1.0) / (_710 + _2214);
	                    float _2222 = _2213.x;
	                    vec3 _711;
	                    vec3 _2230 = _711;
	                    _2230.x = 1.0 + (((_710 * _2222) * _2222) * _2221);
	                    _2230.y = _710 * ((_2222 * _2213.y) * _2221);
	                    _2230.z = (-_710) * _2222;
	                    _711 = _2230;
	                    float _2238 = float((g_Vertices_3[_71]._member0[_2176] >> uint(1)) & 2047u) * 0.003069460391998291015625;
	                    vec3 _2244 = (_2230 * cos(_2238)) + (cross(_2213, _2230) * sin(_2238));
	                    vec4 _2246 = _723;
	                    _2246.x = _2244.x;
	                    _2246.y = _2244.y;
	                    _2246.z = _2244.z;
	                    _723 = _2246;
	                    float _712;
	                    if ((g_Vertices_3[_71]._member0[_2176] & 1u) == 0u)
	                    {
	                        _712 = -1.0;
	                    }
	                    else
	                    {
	                        _712 = 1.0;
	                    }
	                    vec4 _2257 = _723;
	                    _2257.w = _712;
	                    _723 = _2257;
	                    _750[0] = _722;
	                    _751[0] = _2257;
	                    uint _2261 = _2166.y / 4u;
	                    vec4 _725 = _751[1];
	                    float _2276 = (float((g_Vertices_3[_71]._member0[_2261] >> 12u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _2279 = (float((g_Vertices_3[_71]._member0[_2261] >> 22u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _2283 = (1.0 - abs(_2276)) - abs(_2279);
	                    vec3 _2284 = vec3(_2276, _2279, _2283);
	                    float _2286 = saturate(-_2283);
	                    vec2 _2287 = vec2(_2276, _2279);
	                    vec2 _2293 = _2287 + mix(vec2(_2286), vec2(-_2286), greaterThanEqual(_2287, vec2(0.0)));
	                    _2284.x = _2293.x;
	                    _2284.y = _2293.y;
	                    vec3 _2298 = normalize(_2284);
	                    vec3 _724 = _2298;
	                    float _2299 = _2298.z;
	                    float _707;
	                    if (_2299 >= 0.0)
	                    {
	                        _707 = 1.0;
	                    }
	                    else
	                    {
	                        _707 = -1.0;
	                    }
	                    float _2306 = (-1.0) / (_707 + _2299);
	                    float _2307 = _2298.x;
	                    vec3 _708;
	                    vec3 _2315 = _708;
	                    _2315.x = 1.0 + (((_707 * _2307) * _2307) * _2306);
	                    _2315.y = _707 * ((_2307 * _2298.y) * _2306);
	                    _2315.z = (-_707) * _2307;
	                    _708 = _2315;
	                    float _2323 = float((g_Vertices_3[_71]._member0[_2261] >> uint(1)) & 2047u) * 0.003069460391998291015625;
	                    vec3 _2329 = (_2315 * cos(_2323)) + (cross(_2298, _2315) * sin(_2323));
	                    vec4 _2331 = _725;
	                    _2331.x = _2329.x;
	                    _2331.y = _2329.y;
	                    _2331.z = _2329.z;
	                    _725 = _2331;
	                    float _709;
	                    if ((g_Vertices_3[_71]._member0[_2261] & 1u) == 0u)
	                    {
	                        _709 = -1.0;
	                    }
	                    else
	                    {
	                        _709 = 1.0;
	                    }
	                    vec4 _2342 = _725;
	                    _2342.w = _709;
	                    _725 = _2342;
	                    _750[1] = _724;
	                    _751[1] = _2342;
	                    uint _2346 = _2166.z / 4u;
	                    vec4 _727 = _751[2];
	                    float _2361 = (float((g_Vertices_3[_71]._member0[_2346] >> 12u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _2364 = (float((g_Vertices_3[_71]._member0[_2346] >> 22u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _2368 = (1.0 - abs(_2361)) - abs(_2364);
	                    vec3 _2369 = vec3(_2361, _2364, _2368);
	                    float _2371 = saturate(-_2368);
	                    vec2 _2372 = vec2(_2361, _2364);
	                    vec2 _2378 = _2372 + mix(vec2(_2371), vec2(-_2371), greaterThanEqual(_2372, vec2(0.0)));
	                    _2369.x = _2378.x;
	                    _2369.y = _2378.y;
	                    vec3 _2383 = normalize(_2369);
	                    vec3 _726 = _2383;
	                    float _2384 = _2383.z;
	                    float _704;
	                    if (_2384 >= 0.0)
	                    {
	                        _704 = 1.0;
	                    }
	                    else
	                    {
	                        _704 = -1.0;
	                    }
	                    float _2391 = (-1.0) / (_704 + _2384);
	                    float _2392 = _2383.x;
	                    vec3 _705;
	                    vec3 _2400 = _705;
	                    _2400.x = 1.0 + (((_704 * _2392) * _2392) * _2391);
	                    _2400.y = _704 * ((_2392 * _2383.y) * _2391);
	                    _2400.z = (-_704) * _2392;
	                    _705 = _2400;
	                    float _2408 = float((g_Vertices_3[_71]._member0[_2346] >> uint(1)) & 2047u) * 0.003069460391998291015625;
	                    vec3 _2414 = (_2400 * cos(_2408)) + (cross(_2383, _2400) * sin(_2408));
	                    vec4 _2416 = _727;
	                    _2416.x = _2414.x;
	                    _2416.y = _2414.y;
	                    _2416.z = _2414.z;
	                    _727 = _2416;
	                    float _706;
	                    if ((g_Vertices_3[_71]._member0[_2346] & 1u) == 0u)
	                    {
	                        _706 = -1.0;
	                    }
	                    else
	                    {
	                        _706 = 1.0;
	                    }
	                    vec4 _2427 = _727;
	                    _2427.w = _706;
	                    _727 = _2427;
	                    _750[2] = _726;
	                    _751[2] = _2427;
	                    break;
	                }
	                break;
	            }
	        }
	        else
	        {
	            _750[0] = vec3(0.0);
	            _750[1] = vec3(0.0);
	            _750[2] = vec3(0.0);
	        }
	        if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTangentFieldInfo.y != 0)
	        {
	            ivec4 _728 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers;
	            uint _75 = uint(_728[g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTangentFieldInfo.z]);
	            uint _2750 = uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTangentFieldInfo.z);
	            ivec4 _699 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes;
	            ivec4 _700 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes;
	            uvec3 _2766 = (uvec3(uint(_699[_2750])) * _753) + uvec3(uint(_700[_2750]) + uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTangentFieldInfo.x));
	            uint _2768 = _2766.x;
	            _751[0] = vec4(g_Vertices_1[_75]._member0[_2768 / 4u], g_Vertices_1[_75]._member0[(_2768 + 4u) / 4u], g_Vertices_1[_75]._member0[(_2768 + 8u) / 4u], g_Vertices_1[_75]._member0[(_2768 + 12u) / 4u]);
	            uint _2786 = _2766.y;
	            _751[1] = vec4(g_Vertices_1[_75]._member0[_2786 / 4u], g_Vertices_1[_75]._member0[(_2786 + 4u) / 4u], g_Vertices_1[_75]._member0[(_2786 + 8u) / 4u], g_Vertices_1[_75]._member0[(_2786 + 12u) / 4u]);
	            uint _2804 = _2766.z;
	            _751[2] = vec4(g_Vertices_1[_75]._member0[_2804 / 4u], g_Vertices_1[_75]._member0[(_2804 + 4u) / 4u], g_Vertices_1[_75]._member0[(_2804 + 8u) / 4u], g_Vertices_1[_75]._member0[(_2804 + 12u) / 4u]);
	        }
	        else
	        {
	            _751[0] = vec4(0.0);
	            _751[1] = vec4(0.0);
	            _751[2] = vec4(0.0);
	        }
	        break;
	    } while(false);
	    _748 = 0;
	    for (;;)
	    {
	        if (!(_748 < 3))
	        {
	            break;
	        }
	        vsInput[_748].vNormalOs = _750[_748];
	        vsInput[_748].vTangentUOs_flTangentVSign = _751[_748];
	        _748++;
	        continue;
	    }
	    vec4 _752[3];
	    if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vColorFieldInfo.data[0].y != 0)
	    {
	        ivec4 _698 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers;
	        uint _77 = uint(_698[g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vColorFieldInfo.data[0].z]);
	        uint _2863 = uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vColorFieldInfo.data[0].z);
	        ivec4 _696 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes;
	        ivec4 _697 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes;
	        uvec3 _2879 = (uvec3(uint(_696[_2863])) * _753) + uvec3(uint(_697[_2863]) + uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vColorFieldInfo.data[0].x));
	        if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vColorFieldInfo.data[0].y == 2)
	        {
	            uint _2930 = _2879.x;
	            _752[0] = vec4(g_Vertices_1[_77]._member0[_2930 / 4u], g_Vertices_1[_77]._member0[(_2930 + 4u) / 4u], g_Vertices_1[_77]._member0[(_2930 + 8u) / 4u], g_Vertices_1[_77]._member0[(_2930 + 12u) / 4u]);
	            uint _2948 = _2879.y;
	            _752[1] = vec4(g_Vertices_1[_77]._member0[_2948 / 4u], g_Vertices_1[_77]._member0[(_2948 + 4u) / 4u], g_Vertices_1[_77]._member0[(_2948 + 8u) / 4u], g_Vertices_1[_77]._member0[(_2948 + 12u) / 4u]);
	            uint _2966 = _2879.z;
	            _752[2] = vec4(g_Vertices_1[_77]._member0[_2966 / 4u], g_Vertices_1[_77]._member0[(_2966 + 4u) / 4u], g_Vertices_1[_77]._member0[(_2966 + 8u) / 4u], g_Vertices_1[_77]._member0[(_2966 + 12u) / 4u]);
	        }
	        else
	        {
	            uint _2886 = _2879.x / 4u;
	            _752[0] = vec4(uvec4(g_Vertices_3[_77]._member0[_2886] & 255u, (g_Vertices_3[_77]._member0[_2886] & 65280u) >> uint(8), (g_Vertices_3[_77]._member0[_2886] & 16711680u) >> uint(16), (g_Vertices_3[_77]._member0[_2886] & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	            uint _2901 = _2879.y / 4u;
	            _752[1] = vec4(uvec4(g_Vertices_3[_77]._member0[_2901] & 255u, (g_Vertices_3[_77]._member0[_2901] & 65280u) >> uint(8), (g_Vertices_3[_77]._member0[_2901] & 16711680u) >> uint(16), (g_Vertices_3[_77]._member0[_2901] & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	            uint _2916 = _2879.z / 4u;
	            _752[2] = vec4(uvec4(g_Vertices_3[_77]._member0[_2916] & 255u, (g_Vertices_3[_77]._member0[_2916] & 65280u) >> uint(8), (g_Vertices_3[_77]._member0[_2916] & 16711680u) >> uint(16), (g_Vertices_3[_77]._member0[_2916] & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	        }
	    }
	    else
	    {
	        _752[0] = vec4(0.0);
	        _752[1] = vec4(0.0);
	        _752[2] = vec4(0.0);
	    }
	    _748 = 0;
	    for (;;)
	    {
	        if (!(_748 < 3))
	        {
	            break;
	        }
	        vsInput[_748].vBlendColorTint = _752[_748];
	        _748++;
	        continue;
	    }
	    vec4 _755[3];
	    _755[0] = vec4(0.0);
	    _755[1] = vec4(0.0);
	    _755[2] = vec4(0.0);
	    if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[4].y != 0)
	    {
	        ivec4 _695 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers;
	        uint _80 = uint(_695[g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[4].z]);
	        uint _3021 = uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[4].z);
	        ivec4 _693 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes;
	        ivec4 _694 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes;
	        uvec3 _3037 = (uvec3(uint(_693[_3021])) * _753) + uvec3(uint(_694[_3021]) + uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[4].x));
	        if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[4].y == 2)
	        {
	            uint _3087 = _3037.x;
	            _755[0] = vec4(g_Vertices_1[_80]._member0[_3087 / 4u], g_Vertices_1[_80]._member0[(_3087 + 4u) / 4u], g_Vertices_1[_80]._member0[(_3087 + 8u) / 4u], g_Vertices_1[_80]._member0[(_3087 + 12u) / 4u]);
	            uint _3104 = _3037.y;
	            _755[1] = vec4(g_Vertices_1[_80]._member0[_3104 / 4u], g_Vertices_1[_80]._member0[(_3104 + 4u) / 4u], g_Vertices_1[_80]._member0[(_3104 + 8u) / 4u], g_Vertices_1[_80]._member0[(_3104 + 12u) / 4u]);
	            uint _3121 = _3037.z;
	            _755[2] = vec4(g_Vertices_1[_80]._member0[_3121 / 4u], g_Vertices_1[_80]._member0[(_3121 + 4u) / 4u], g_Vertices_1[_80]._member0[(_3121 + 8u) / 4u], g_Vertices_1[_80]._member0[(_3121 + 12u) / 4u]);
	        }
	        else
	        {
	            if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[4].y == 28)
	            {
	                uint _3046 = _3037.x / 4u;
	                _755[0] = vec4(uvec4(g_Vertices_3[_80]._member0[_3046] & 255u, (g_Vertices_3[_80]._member0[_3046] & 65280u) >> uint(8), (g_Vertices_3[_80]._member0[_3046] & 16711680u) >> uint(16), (g_Vertices_3[_80]._member0[_3046] & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	                uint _3060 = _3037.y / 4u;
	                _755[1] = vec4(uvec4(g_Vertices_3[_80]._member0[_3060] & 255u, (g_Vertices_3[_80]._member0[_3060] & 65280u) >> uint(8), (g_Vertices_3[_80]._member0[_3060] & 16711680u) >> uint(16), (g_Vertices_3[_80]._member0[_3060] & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	                uint _3074 = _3037.z / 4u;
	                _755[2] = vec4(uvec4(g_Vertices_3[_80]._member0[_3074] & 255u, (g_Vertices_3[_80]._member0[_3074] & 65280u) >> uint(8), (g_Vertices_3[_80]._member0[_3074] & 16711680u) >> uint(16), (g_Vertices_3[_80]._member0[_3074] & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	            }
	        }
	    }
	    int _756 = 0;
	    for (;;)
	    {
	        if (!(_756 < 3))
	        {
	            break;
	        }
	        vsInput[_756].vColorBlendValues = _755[_756];
	        _756++;
	        continue;
	    }
	    vec2 _516 = vsInput[0].vTexCoord;
	    vec2 _515 = vsInput[0].vTexCoord2;
	    vec4 _514 = vsInput[0].vBlendColorTint;
	    vec3 _690 = vsInput[0].vNormalOs;
	    vec4 _691;
	    vec4 _3166 = _691;
	    _3166.x = vsInput[0].vTangentUOs_flTangentVSign.x;
	    _3166.y = vsInput[0].vTangentUOs_flTangentVSign.y;
	    _3166.z = vsInput[0].vTangentUOs_flTangentVSign.z;
	    _3166.w = vsInput[0].vTangentUOs_flTangentVSign.w;
	    _691 = _3166;
	    PackedRtxInstanceData_t_natural_logical _3179;
	    _3179.nSrgbColor = g_instanceBuffer._member0[uint(gl_InstanceID)].nSrgbColor;
	    _3179.nTriangleGeometry = g_instanceBuffer._member0[uint(gl_InstanceID)].nTriangleGeometry;
	    _3179.nMaterialData = g_instanceBuffer._member0[uint(gl_InstanceID)].nMaterialData;
	    _3179.nMaterialFlags_nInstanceFlags = g_instanceBuffer._member0[uint(gl_InstanceID)].nMaterialFlags_nInstanceFlags;
	    _3179.fEmissiveBoost = g_instanceBuffer._member0[uint(gl_InstanceID)].fEmissiveBoost;
	    _3179.nInstanceFlags = g_instanceBuffer._member0[uint(gl_InstanceID)].nInstanceFlags;
	    _3179._pad1 = g_instanceBuffer._member0[uint(gl_InstanceID)]._pad1;
	    _3179._pad2 = g_instanceBuffer._member0[uint(gl_InstanceID)]._pad2;
	    vec4 _3190 = vec4(uvec4(_3179.nSrgbColor & 255u, (_3179.nSrgbColor & 65280u) >> uint(8), (_3179.nSrgbColor & 16711680u) >> uint(16), (_3179.nSrgbColor & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	    vec4 _689 = _3190;
	    vec3 _3191 = _3190.xyz;
	    vec3 _3192 = _3191 * vec3(0.077399380505084991455078125);
	    vec3 _3195 = pow((_3191 * vec3(0.947867333889007568359375)) + vec3(0.052132703363895416259765625), vec3(2.400000095367431640625));
	    float _686;
	    if (_3190.x <= 0.040449999272823333740234375)
	    {
	        _686 = _3192.x;
	    }
	    else
	    {
	        _686 = _3195.x;
	    }
	    float _687;
	    if (_3190.y <= 0.040449999272823333740234375)
	    {
	        _687 = _3192.y;
	    }
	    else
	    {
	        _687 = _3195.y;
	    }
	    float _688;
	    if (_3190.z <= 0.040449999272823333740234375)
	    {
	        _688 = _3192.z;
	    }
	    else
	    {
	        _688 = _3195.z;
	    }
	    vec3 _3220 = vec3(_686, _687, _688);
	    vec4 _3222 = _689;
	    _3222.x = _3220.x;
	    _3222.y = _3220.y;
	    _3222.z = _3220.z;
	    _689 = _3222;
	    vec4 _525;
	    vec4 _3229 = _525;
	    _3229.x = _3222.x;
	    _3229.y = _3222.y;
	    _3229.z = _3222.z;
	    _3229.w = _3222.w;
	    _525 = _3229;
	    mat3x4 _3240 = transpose(gl_WorldToObjectEXT);
	    mat3 _685;
	    mat3 _3243 = _685;
	    _3243[0] = _3240[0].xyz;
	    _3243[1] = _3240[1].xyz;
	    _3243[2] = _3240[2].xyz;
	    _685 = _3243;
	    vec3 _3252 = normalize(_3243 * _690.xyz);
	    vec3 _526;
	    vec3 _3254 = _526;
	    _3254.x = _3252.x;
	    _3254.y = _3252.y;
	    _3254.z = _3252.z;
	    _526 = _3254;
	    mat3x4 _3266 = transpose(gl_WorldToObjectEXT);
	    mat3 _684;
	    mat3 _3269 = _684;
	    _3269[0] = _3266[0].xyz;
	    _3269[1] = _3266[1].xyz;
	    _3269[2] = _3266[2].xyz;
	    _684 = _3269;
	    vec3 _3278 = normalize(_3269 * _691.xyz);
	    vec4 _524;
	    vec4 _3280 = _524;
	    _3280.x = _3278.x;
	    _3280.y = _3278.y;
	    _3280.z = _3278.z;
	    _3280.w = _691.w;
	    _524 = _3280;
	    vec4 _3289 = _516.xyxy;
	    _3289.z = _515.x;
	    _3289.w = _515.y;
	    vec4 _527;
	    vec4 _523 = _527;
	    vec3 _522 = vec4(vsInput[0].vPositionOs.xyz, 1.0) * transpose(gl_ObjectToWorldEXT);
	    vec3 _521 = _3254;
	    vec4 _520 = _3289;
	    vec4 _519 = _3229;
	    vec4 _518 = _3280;
	    if (_g_rtx_material_data_.g_nUVSet1 > 0)
	    {
	        vec2 _692;
	        if (_g_rtx_material_data_.g_nUVSet1 == 2)
	        {
	            _692 = _3289.zw;
	        }
	        else
	        {
	            _692 = _3289.xy;
	        }
	        vec4 _3311 = _520;
	        _3311.x = _692.x;
	        _3311.y = _692.y;
	        vec4 _3330 = _3311;
	        _3330.x = dot(_3311.xy, _g_rtx_material_data_.g_vTexCoordXform0_1.xy) + _g_rtx_material_data_.g_vTexCoordXform0_1.w;
	        _3330.y = dot(_3311.xy, _g_rtx_material_data_.g_vTexCoordXform1_1.xy) + _g_rtx_material_data_.g_vTexCoordXform1_1.w;
	        _520 = _3330;
	    }
	    vec4 _3332 = _519;
	    vec4 _3334 = _523;
	    _3334.x = _3332.x;
	    _3334.y = _3332.y;
	    _3334.z = _3332.z;
	    _3334.w = _g_rtx_material_data_.g_flModelTintAmount * (1.0 - min(_3334.x, min(_3334.y, _3334.z)));
	    _523 = _3334;
	    _3332.x = _g_rtx_material_data_.g_vColorTint.x;
	    _3332.y = _g_rtx_material_data_.g_vColorTint.y;
	    _3332.z = _g_rtx_material_data_.g_vColorTint.z;
	    vec3 _3363 = _3332.xyz * mix(vec3(1.0), _514.xyz, vec3(_514.w));
	    vec4 _3365 = _3332;
	    _3365.x = _3363.x;
	    _3365.y = _3363.y;
	    _3365.z = _3363.z;
	    _519 = _3365;
	    vec4 _496 = _3334;
	    vec3 _495 = _522;
	    vec3 _494 = _521;
	    vec4 _493 = _520;
	    vec4 _492 = _3365;
	    vec4 _491 = _518;
	    vec2 _513 = vsInput[1].vTexCoord;
	    vec2 _512 = vsInput[1].vTexCoord2;
	    vec4 _511 = vsInput[1].vBlendColorTint;
	    vec3 _681 = vsInput[1].vNormalOs;
	    vec4 _682;
	    vec4 _3383 = _682;
	    _3383.x = vsInput[1].vTangentUOs_flTangentVSign.x;
	    _3383.y = vsInput[1].vTangentUOs_flTangentVSign.y;
	    _3383.z = vsInput[1].vTangentUOs_flTangentVSign.z;
	    _3383.w = vsInput[1].vTangentUOs_flTangentVSign.w;
	    _682 = _3383;
	    PackedRtxInstanceData_t_natural_logical _3396;
	    _3396.nSrgbColor = g_instanceBuffer._member0[uint(gl_InstanceID)].nSrgbColor;
	    _3396.nTriangleGeometry = g_instanceBuffer._member0[uint(gl_InstanceID)].nTriangleGeometry;
	    _3396.nMaterialData = g_instanceBuffer._member0[uint(gl_InstanceID)].nMaterialData;
	    _3396.nMaterialFlags_nInstanceFlags = g_instanceBuffer._member0[uint(gl_InstanceID)].nMaterialFlags_nInstanceFlags;
	    _3396.fEmissiveBoost = g_instanceBuffer._member0[uint(gl_InstanceID)].fEmissiveBoost;
	    _3396.nInstanceFlags = g_instanceBuffer._member0[uint(gl_InstanceID)].nInstanceFlags;
	    _3396._pad1 = g_instanceBuffer._member0[uint(gl_InstanceID)]._pad1;
	    _3396._pad2 = g_instanceBuffer._member0[uint(gl_InstanceID)]._pad2;
	    vec4 _3407 = vec4(uvec4(_3396.nSrgbColor & 255u, (_3396.nSrgbColor & 65280u) >> uint(8), (_3396.nSrgbColor & 16711680u) >> uint(16), (_3396.nSrgbColor & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	    vec4 _680 = _3407;
	    vec3 _3408 = _3407.xyz;
	    vec3 _3409 = _3408 * vec3(0.077399380505084991455078125);
	    vec3 _3412 = pow((_3408 * vec3(0.947867333889007568359375)) + vec3(0.052132703363895416259765625), vec3(2.400000095367431640625));
	    float _677;
	    if (_3407.x <= 0.040449999272823333740234375)
	    {
	        _677 = _3409.x;
	    }
	    else
	    {
	        _677 = _3412.x;
	    }
	    float _678;
	    if (_3407.y <= 0.040449999272823333740234375)
	    {
	        _678 = _3409.y;
	    }
	    else
	    {
	        _678 = _3412.y;
	    }
	    float _679;
	    if (_3407.z <= 0.040449999272823333740234375)
	    {
	        _679 = _3409.z;
	    }
	    else
	    {
	        _679 = _3412.z;
	    }
	    vec3 _3437 = vec3(_677, _678, _679);
	    vec4 _3439 = _680;
	    _3439.x = _3437.x;
	    _3439.y = _3437.y;
	    _3439.z = _3437.z;
	    _680 = _3439;
	    vec4 _535;
	    vec4 _3446 = _535;
	    _3446.x = _3439.x;
	    _3446.y = _3439.y;
	    _3446.z = _3439.z;
	    _3446.w = _3439.w;
	    _535 = _3446;
	    mat3x4 _3457 = transpose(gl_WorldToObjectEXT);
	    mat3 _676;
	    mat3 _3460 = _676;
	    _3460[0] = _3457[0].xyz;
	    _3460[1] = _3457[1].xyz;
	    _3460[2] = _3457[2].xyz;
	    _676 = _3460;
	    vec3 _3469 = normalize(_3460 * _681.xyz);
	    vec3 _536;
	    vec3 _3471 = _536;
	    _3471.x = _3469.x;
	    _3471.y = _3469.y;
	    _3471.z = _3469.z;
	    _536 = _3471;
	    mat3x4 _3483 = transpose(gl_WorldToObjectEXT);
	    mat3 _675;
	    mat3 _3486 = _675;
	    _3486[0] = _3483[0].xyz;
	    _3486[1] = _3483[1].xyz;
	    _3486[2] = _3483[2].xyz;
	    _675 = _3486;
	    vec3 _3495 = normalize(_3486 * _682.xyz);
	    vec4 _534;
	    vec4 _3497 = _534;
	    _3497.x = _3495.x;
	    _3497.y = _3495.y;
	    _3497.z = _3495.z;
	    _3497.w = _682.w;
	    _534 = _3497;
	    vec4 _3506 = _513.xyxy;
	    _3506.z = _512.x;
	    _3506.w = _512.y;
	    vec4 _537;
	    vec4 _533 = _537;
	    vec3 _532 = vec4(vsInput[1].vPositionOs.xyz, 1.0) * transpose(gl_ObjectToWorldEXT);
	    vec3 _531 = _3471;
	    vec4 _530 = _3506;
	    vec4 _529 = _3446;
	    vec4 _528 = _3497;
	    if (_g_rtx_material_data_.g_nUVSet1 > 0)
	    {
	        vec2 _683;
	        if (_g_rtx_material_data_.g_nUVSet1 == 2)
	        {
	            _683 = _3506.zw;
	        }
	        else
	        {
	            _683 = _3506.xy;
	        }
	        vec4 _3528 = _530;
	        _3528.x = _683.x;
	        _3528.y = _683.y;
	        vec4 _3547 = _3528;
	        _3547.x = dot(_3528.xy, _g_rtx_material_data_.g_vTexCoordXform0_1.xy) + _g_rtx_material_data_.g_vTexCoordXform0_1.w;
	        _3547.y = dot(_3528.xy, _g_rtx_material_data_.g_vTexCoordXform1_1.xy) + _g_rtx_material_data_.g_vTexCoordXform1_1.w;
	        _530 = _3547;
	    }
	    vec4 _3549 = _529;
	    vec4 _3551 = _533;
	    _3551.x = _3549.x;
	    _3551.y = _3549.y;
	    _3551.z = _3549.z;
	    _3551.w = _g_rtx_material_data_.g_flModelTintAmount * (1.0 - min(_3551.x, min(_3551.y, _3551.z)));
	    _533 = _3551;
	    _3549.x = _g_rtx_material_data_.g_vColorTint.x;
	    _3549.y = _g_rtx_material_data_.g_vColorTint.y;
	    _3549.z = _g_rtx_material_data_.g_vColorTint.z;
	    vec3 _3580 = _3549.xyz * mix(vec3(1.0), _511.xyz, vec3(_511.w));
	    vec4 _3582 = _3549;
	    _3582.x = _3580.x;
	    _3582.y = _3580.y;
	    _3582.z = _3580.z;
	    _529 = _3582;
	    vec4 _490 = _3551;
	    vec3 _489 = _532;
	    vec3 _488 = _531;
	    vec4 _487 = _530;
	    vec4 _486 = _3582;
	    vec4 _485 = _528;
	    vec2 _510 = vsInput[2].vTexCoord;
	    vec2 _509 = vsInput[2].vTexCoord2;
	    vec4 _508 = vsInput[2].vBlendColorTint;
	    vec3 _672 = vsInput[2].vNormalOs;
	    vec4 _673;
	    vec4 _3600 = _673;
	    _3600.x = vsInput[2].vTangentUOs_flTangentVSign.x;
	    _3600.y = vsInput[2].vTangentUOs_flTangentVSign.y;
	    _3600.z = vsInput[2].vTangentUOs_flTangentVSign.z;
	    _3600.w = vsInput[2].vTangentUOs_flTangentVSign.w;
	    _673 = _3600;
	    PackedRtxInstanceData_t_natural_logical _3613;
	    _3613.nSrgbColor = g_instanceBuffer._member0[uint(gl_InstanceID)].nSrgbColor;
	    _3613.nTriangleGeometry = g_instanceBuffer._member0[uint(gl_InstanceID)].nTriangleGeometry;
	    _3613.nMaterialData = g_instanceBuffer._member0[uint(gl_InstanceID)].nMaterialData;
	    _3613.nMaterialFlags_nInstanceFlags = g_instanceBuffer._member0[uint(gl_InstanceID)].nMaterialFlags_nInstanceFlags;
	    _3613.fEmissiveBoost = g_instanceBuffer._member0[uint(gl_InstanceID)].fEmissiveBoost;
	    _3613.nInstanceFlags = g_instanceBuffer._member0[uint(gl_InstanceID)].nInstanceFlags;
	    _3613._pad1 = g_instanceBuffer._member0[uint(gl_InstanceID)]._pad1;
	    _3613._pad2 = g_instanceBuffer._member0[uint(gl_InstanceID)]._pad2;
	    vec4 _3624 = vec4(uvec4(_3613.nSrgbColor & 255u, (_3613.nSrgbColor & 65280u) >> uint(8), (_3613.nSrgbColor & 16711680u) >> uint(16), (_3613.nSrgbColor & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	    vec4 _671 = _3624;
	    vec3 _3625 = _3624.xyz;
	    vec3 _3626 = _3625 * vec3(0.077399380505084991455078125);
	    vec3 _3629 = pow((_3625 * vec3(0.947867333889007568359375)) + vec3(0.052132703363895416259765625), vec3(2.400000095367431640625));
	    float _668;
	    if (_3624.x <= 0.040449999272823333740234375)
	    {
	        _668 = _3626.x;
	    }
	    else
	    {
	        _668 = _3629.x;
	    }
	    float _669;
	    if (_3624.y <= 0.040449999272823333740234375)
	    {
	        _669 = _3626.y;
	    }
	    else
	    {
	        _669 = _3629.y;
	    }
	    float _670;
	    if (_3624.z <= 0.040449999272823333740234375)
	    {
	        _670 = _3626.z;
	    }
	    else
	    {
	        _670 = _3629.z;
	    }
	    vec3 _3654 = vec3(_668, _669, _670);
	    vec4 _3656 = _671;
	    _3656.x = _3654.x;
	    _3656.y = _3654.y;
	    _3656.z = _3654.z;
	    _671 = _3656;
	    vec4 _545;
	    vec4 _3663 = _545;
	    _3663.x = _3656.x;
	    _3663.y = _3656.y;
	    _3663.z = _3656.z;
	    _3663.w = _3656.w;
	    _545 = _3663;
	    mat3x4 _3674 = transpose(gl_WorldToObjectEXT);
	    mat3 _667;
	    mat3 _3677 = _667;
	    _3677[0] = _3674[0].xyz;
	    _3677[1] = _3674[1].xyz;
	    _3677[2] = _3674[2].xyz;
	    _667 = _3677;
	    vec3 _3686 = normalize(_3677 * _672.xyz);
	    vec3 _546;
	    vec3 _3688 = _546;
	    _3688.x = _3686.x;
	    _3688.y = _3686.y;
	    _3688.z = _3686.z;
	    _546 = _3688;
	    mat3x4 _3700 = transpose(gl_WorldToObjectEXT);
	    mat3 _666;
	    mat3 _3703 = _666;
	    _3703[0] = _3700[0].xyz;
	    _3703[1] = _3700[1].xyz;
	    _3703[2] = _3700[2].xyz;
	    _666 = _3703;
	    vec3 _3712 = normalize(_3703 * _673.xyz);
	    vec4 _544;
	    vec4 _3714 = _544;
	    _3714.x = _3712.x;
	    _3714.y = _3712.y;
	    _3714.z = _3712.z;
	    _3714.w = _673.w;
	    _544 = _3714;
	    vec4 _3723 = _510.xyxy;
	    _3723.z = _509.x;
	    _3723.w = _509.y;
	    vec4 _547;
	    vec4 _543 = _547;
	    vec3 _542 = vec4(vsInput[2].vPositionOs.xyz, 1.0) * transpose(gl_ObjectToWorldEXT);
	    vec3 _541 = _3688;
	    vec4 _540 = _3723;
	    vec4 _539 = _3663;
	    vec4 _538 = _3714;
	    if (_g_rtx_material_data_.g_nUVSet1 > 0)
	    {
	        vec2 _674;
	        if (_g_rtx_material_data_.g_nUVSet1 == 2)
	        {
	            _674 = _3723.zw;
	        }
	        else
	        {
	            _674 = _3723.xy;
	        }
	        vec4 _3745 = _540;
	        _3745.x = _674.x;
	        _3745.y = _674.y;
	        vec4 _3764 = _3745;
	        _3764.x = dot(_3745.xy, _g_rtx_material_data_.g_vTexCoordXform0_1.xy) + _g_rtx_material_data_.g_vTexCoordXform0_1.w;
	        _3764.y = dot(_3745.xy, _g_rtx_material_data_.g_vTexCoordXform1_1.xy) + _g_rtx_material_data_.g_vTexCoordXform1_1.w;
	        _540 = _3764;
	    }
	    vec4 _3766 = _539;
	    vec4 _3768 = _543;
	    _3768.x = _3766.x;
	    _3768.y = _3766.y;
	    _3768.z = _3766.z;
	    _3768.w = _g_rtx_material_data_.g_flModelTintAmount * (1.0 - min(_3768.x, min(_3768.y, _3768.z)));
	    _543 = _3768;
	    _3766.x = _g_rtx_material_data_.g_vColorTint.x;
	    _3766.y = _g_rtx_material_data_.g_vColorTint.y;
	    _3766.z = _g_rtx_material_data_.g_vColorTint.z;
	    vec3 _3797 = _3766.xyz * mix(vec3(1.0), _508.xyz, vec3(_508.w));
	    vec4 _3799 = _3766;
	    _3799.x = _3797.x;
	    _3799.y = _3797.y;
	    _3799.z = _3797.z;
	    _539 = _3799;
	    vec3 _484 = _542;
	    vec3 _483 = _541;
	    vec3 _3830 = ((_494 * ((1.0 - attrs.barycentrics.x) - attrs.barycentrics.y)) + (_488 * attrs.barycentrics.x)) + (_541 * attrs.barycentrics.y);
	    bool _3836 = gl_HitKindEXT == 254u;
	    vec3 _548;
	    vec3 _549;
	    vec4 _507 = ((_496 * ((1.0 - attrs.barycentrics.x) - attrs.barycentrics.y)) + (_490 * attrs.barycentrics.x)) + (_3768 * attrs.barycentrics.y);
	    vec3 _506 = _549;
	    vec3 _505 = _3830;
	    vec4 _504 = ((_493 * ((1.0 - attrs.barycentrics.x) - attrs.barycentrics.y)) + (_487 * attrs.barycentrics.x)) + (_540 * attrs.barycentrics.y);
	    vec4 _503 = ((_492 * ((1.0 - attrs.barycentrics.x) - attrs.barycentrics.y)) + (_486 * attrs.barycentrics.x)) + (_3799 * attrs.barycentrics.y);
	    vec4 _502 = ((_491 * ((1.0 - attrs.barycentrics.x) - attrs.barycentrics.y)) + (_485 * attrs.barycentrics.x)) + (_538 * attrs.barycentrics.y);
	    bool _501 = _3836;
	    vec3 _558 = _548;
	    vec3 _557 = normalize(cross(_489 - _495, _542 - _495));
	    bool _556 = _3836;
	    vec3 _567 = vec3(0.5);
	    vec2 _566 = vec2(0.5);
	    float _565 = 0.0;
	    vec3 _564 = vec3(0.0);
	    float _563 = 0.039999999105930328369140625;
	    vec3 _562 = vec3(0.0);
	    vec3 _560 = vec3(1.0);
	    bool _559 = false;
	    vec3 _3875 = _3830.xyz;
	    vec3 _561 = _3875;
	    if (dot(_3875, _3875) >= 1.0099999904632568359375)
	    {
	        _561 = _558.xyz;
	    }
	    _563 = _g_rtx_material_data_.g_flReflectance;
	    _560 = _557;
	    bool _664;
	    if (_g_rtx_material_data_.g_bRenderBackfaceNormals)
	    {
	        _664 = !_g_rtx_material_data_.g_bDontFlipBackfaceNormals;
	    }
	    else
	    {
	        _664 = false;
	    }
	    SPIRV_CROSS_BRANCH
	    if (_664)
	    {
	        float _665;
	        if (_556)
	        {
	            _665 = 1.0;
	        }
	        else
	        {
	            _665 = -1.0;
	        }
	        _561 *= _665;
	        if (_556)
	        {
	            _665 = 1.0;
	        }
	        else
	        {
	            _665 = -1.0;
	        }
	        _560 *= _665;
	        _559 = !_556;
	    }
	    vec3 _3909 = _561;
	    vec3 _3910 = normalize(_3909);
	    _561 = _3910;
	    vec4 _555 = _507;
	    vec3 _554 = _506;
	    vec3 _553 = _505;
	    vec4 _552 = _504;
	    vec4 _551 = _503;
	    bool _550 = _501;
	    vec3 _601 = _3910;
	    vec3 _600 = _567;
	    vec2 _599 = _566;
	    float _598 = _565;
	    vec3 _597 = _564;
	    float _596 = _563;
	    vec3 _595 = _562;
	    vec3 _594 = _3910;
	    vec3 _593 = _560;
	    bool _592 = _559;
	    bool _662;
	    if (_g_rtx_material_data_.g_bRenderBackfaceNormals)
	    {
	        _662 = !_g_rtx_material_data_.g_bDontFlipBackfaceNormals;
	    }
	    else
	    {
	        _662 = false;
	    }
	    if (_662)
	    {
	        float _663;
	        if (_550)
	        {
	            _663 = 1.0;
	        }
	        else
	        {
	            _663 = -1.0;
	        }
	        _662 = _663 < 0.0;
	    }
	    else
	    {
	        _662 = false;
	    }
	    vec3 _605 = vec3(0.0);
	    vec3 _604 = vec3(0.0);
	    float _660;
	    if (_502.w > 0.0)
	    {
	        _660 = 1.0;
	    }
	    else
	    {
	        _660 = -1.0;
	    }
	    float _3961 = 1.0 / length(_553);
	    vec3 _606 = _553 * _3961;
	    vec3 _500 = _502.xyz * _3961;
	    vec3 _499 = (cross(_553, _502.xyz) * _660) * _3961;
	    if (_662)
	    {
	        _606 *= (-1.0);
	    }
	    vec3 _603 = _605 - (_606 * dot(_605, _606));
	    vec3 _602 = _604 - (_606 * dot(_604, _606));
	    int _661;
	    if (dot(_604, cross(_606, _605)) < 0.0)
	    {
	        _661 = -1;
	    }
	    else
	    {
	        _661 = 1;
	    }
	    vec3 _629 = _606;
	    vec3 _628 = _603;
	    vec3 _627 = _602;
	    float _626 = float(_661);
	    vec3 _590;
	    vec3 _591;
	    if (_g_rtx_material_data_.g_nUVSet1 > 1)
	    {
	        float _659;
	        if (false)
	        {
	            _659 = -1.0;
	        }
	        else
	        {
	            _659 = 1.0;
	        }
	        vec2 _3997 = vec2(0.0, -0.0) * _659;
	        vec3 _607 = (_628 * _3997.x) + (_627 * _3997.y);
	        float _4005 = abs(0.0);
	        if (_4005 > 0.0)
	        {
	            _607 = normalize(_607);
	        }
	        _591 = _607;
	        _590 = cross(_629, _607) * (_659 * _626);
	    }
	    vec2 _589 = vec2(0.0);
	    vec2 _588 = vec2(0.0);
	    vec2 _587 = vec2(0.0);
	    vec2 _586 = vec2(0.0);
	    vec2 _585 = vec2(0.0);
	    vec2 _584 = vec2(0.0);
	    vec2 _583 = vec2(0.0);
	    ivec2 _582 = ivec2(0);
	    ivec2 _581 = ivec2(0);
	    if (_g_rtx_material_data_.g_nUVSet1 == 0)
	    {
	        vec3 _4025 = abs(_594);
	        vec3 _654 = _4025;
	        float _4026 = _4025.x;
	        float _4027 = _4025.y;
	        bool _655;
	        if (_4026 > _4027)
	        {
	            _655 = _4026 > _4025.z;
	        }
	        else
	        {
	            _655 = false;
	        }
	        ivec3 _656;
	        if (_655)
	        {
	            _656 = ivec3(0, 1, 2);
	        }
	        else
	        {
	            if (_4027 > _4025.z)
	            {
	                _656 = ivec3(1, 2, 0);
	            }
	            else
	            {
	                _656 = ivec3(2, 0, 1);
	            }
	        }
	        if (_4026 < _4027)
	        {
	            _655 = _4026 < _4025.z;
	        }
	        else
	        {
	            _655 = false;
	        }
	        ivec3 _657;
	        if (_655)
	        {
	            _657 = ivec3(0, 1, 2);
	        }
	        else
	        {
	            if (_4027 < _4025.z)
	            {
	                _657 = ivec3(1, 2, 0);
	            }
	            else
	            {
	                _657 = ivec3(2, 0, 1);
	            }
	        }
	        ivec3 _4061 = (ivec3(3) - _657) - _656;
	        ivec2 _658;
	        if (_656.x == 1)
	        {
	            _658 = _656.zy;
	        }
	        else
	        {
	            _658 = _656.yz;
	        }
	        ivec2 _4073 = _582;
	        _4073.x = _658.x;
	        _4073.y = _658.y;
	        _582 = _4073;
	        int _4077 = _4061.x;
	        if (_4077 == 1)
	        {
	            _658 = _4061.zy;
	        }
	        else
	        {
	            _658 = _4061.yz;
	        }
	        ivec2 _4086 = _581;
	        _4086.x = _658.x;
	        _4086.y = _658.y;
	        _581 = _4086;
	        vec2 _4097 = clamp((vec2(_654[_656.x], _654[_4077]) - vec2(0.577300012111663818359375)) * vec2(2.365744113922119140625), vec2(0.0), vec2(1.0));
	        _583 = _4097 / vec2(_4097.x + _4097.y);
	        vec3 _645 = _554 * _g_rtx_material_data_.g_vBiplanarTexCoordScale.xyz;
	        _589 = vec2(_645[_582.x], _645[_582.y]);
	        vec3 _646 = vec3(0.0);
	        vec3 _647 = vec3(0.0);
	        _587 = vec2(_646[_582.x], _647[_582.y]);
	        vec3 _648 = vec3(0.0);
	        vec3 _649 = vec3(0.0);
	        _586 = vec2(_648[_582.x], _649[_582.y]);
	        _588 = vec2(_645[_4086.x], _645[_4086.y]);
	        vec3 _650 = vec3(0.0);
	        vec3 _651 = vec3(0.0);
	        _585 = vec2(_650[_4086.x], _651[_4086.y]);
	        vec3 _652 = vec3(0.0);
	        vec3 _653 = vec3(0.0);
	        _584 = vec2(_652[_4086.x], _653[_4086.y]);
	    }
	    vec4 _580 = vec4(0.0);
	    vec3 _579 = vec3(0.0);
	    vec4 _576 = vec4(0.0);
	    float _575 = 0.0;
	    float _574 = 0.0;
	    float _573 = 0.0;
	    vec3 _4155 = vec3(0.0);
	    _4155.x = _552.x;
	    _4155.y = _552.y;
	    vec3 _578 = _4155;
	    vec2 _577 = _g_rtx_material_data_.g_vTexCoordScale1.xy;
	    vec2 _614 = _589;
	    vec2 _613 = _588;
	    vec2 _612 = _587;
	    vec2 _611 = _586;
	    vec2 _610 = _585;
	    vec2 _609 = _584;
	    vec2 _608 = _583;
	    vec4 _644;
	    if (_g_rtx_material_data_.g_nUVSet1 == 0)
	    {
	        vec2 _4182 = _614;
	        vec2 _4183 = _4182 * _577;
	        _614 = _4183;
	        vec2 _4184 = _612;
	        vec2 _4185 = _4184 * _577;
	        _612 = _4185;
	        vec2 _4186 = _611;
	        vec2 _4187 = _4186 * _577;
	        _611 = _4187;
	        vec2 _4188 = _613;
	        vec2 _4189 = _4188 * _577;
	        _613 = _4189;
	        vec2 _4190 = _610;
	        vec2 _4191 = _4190 * _577;
	        _610 = _4191;
	        vec2 _4192 = _609;
	        vec2 _4193 = _4192 * _577;
	        _609 = _4193;
	        _644 = (textureGrad(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_.g_tHeight1], g_bindless_Sampler[_g_rtx_material_data_.g_sUserConfig]), _4183.xy, _4185.xy, _4187.xy) * _608.x) + (textureGrad(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_.g_tHeight1], g_bindless_Sampler[_g_rtx_material_data_.g_sUserConfig]), _4189.xy, _4191.xy, _4193.xy) * _608.y);
	    }
	    else
	    {
	        _644 = textureLod(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_.g_tHeight1], g_bindless_Sampler[_g_rtx_material_data_.g_sUserConfig]), _578.xy, 0.0).xyzw;
	    }
	    _574 = _644.y;
	    _575 = _644.w;
	    vec3 _572 = _594;
	    vec3 _571 = _500;
	    vec3 _570 = _499;
	    vec3 _569 = _591;
	    vec3 _568 = _590;
	    vec2 _625 = _589;
	    vec2 _624 = _588;
	    vec2 _623 = _587;
	    vec2 _622 = _586;
	    vec2 _621 = _585;
	    vec2 _620 = _584;
	    vec2 _619 = _583;
	    ivec2 _618 = _582;
	    ivec2 _617 = _581;
	    if (_g_rtx_material_data_.g_nUVSet1 == 0)
	    {
	        _625 *= _577;
	        _623 *= _577;
	        _622 *= _577;
	        _624 *= _577;
	        _621 *= _577;
	        _620 *= _577;
	        _579 = _572;
	        if (true)
	        {
	            _580 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_.g_tColor1], g_bindless_Sampler[_g_rtx_material_data_.g_sUserConfig]), _625.xy, _623.xy, _622.xy) * _619.x;
	        }
	        if (true)
	        {
	            vec4 _4382 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_.g_tNormal1], g_bindless_Sampler[_g_rtx_material_data_.g_sUserConfig]), _625.xy, _623.xy, _622.xy);
	            _573 = _4382.z * _619.x;
	            float _4387 = _4382.x;
	            float _4388 = _4382.y;
	            float _4390 = (_4387 + _4388) - 1.00392162799835205078125;
	            float _4391 = _4387 - _4388;
	            vec3 _4401 = normalize(vec3(vec2(_4390, _4391), (1.0 - abs(_4390)) - abs(_4391))).xyz * _619.x;
	            vec4 _4403;
	            _4403.x = _4401.x;
	            _4403.y = _4401.y;
	            vec4 _4407 = _4403;
	            _4407.z = _4401.z;
	            _579 = (_417[_618.x] * _4403.x) + (_421[_618.y] * _4403.y);
	        }
	        if (_619.y > 0.0)
	        {
	            if (true)
	            {
	                _580 += (textureGrad(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_.g_tColor1], g_bindless_Sampler[_g_rtx_material_data_.g_sUserConfig]), _624.xy, _621.xy, _620.xy) * _619.y);
	            }
	            if (true)
	            {
	                vec4 _4459 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_.g_tNormal1], g_bindless_Sampler[_g_rtx_material_data_.g_sUserConfig]), _624.xy, _621.xy, _620.xy);
	                _573 += (_4459.z * _619.y);
	                float _4466 = _4459.x;
	                float _4467 = _4459.y;
	                float _4469 = (_4466 + _4467) - 1.00392162799835205078125;
	                float _4470 = _4466 - _4467;
	                vec3 _4480 = normalize(vec3(vec2(_4469, _4470), (1.0 - abs(_4469)) - abs(_4470))).xyz * _619.y;
	                vec4 _4482;
	                _4482.x = _4480.x;
	                _4482.y = _4480.y;
	                vec4 _4486 = _4482;
	                _4486.z = _4480.z;
	                _579 += ((_417[_617.x] * _4482.x) + (_421[_617.y] * _4482.y));
	            }
	        }
	        _579 = normalize(_579 + _572);
	    }
	    else
	    {
	        if (true)
	        {
	            _580 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_.g_tColor1], g_bindless_Sampler[_g_rtx_material_data_.g_sUserConfig]), _578.xy, _576.xy, _576.zw).xyzw;
	        }
	        if (true)
	        {
	            vec4 _4273 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_.g_tNormal1], g_bindless_Sampler[_g_rtx_material_data_.g_sUserConfig]), _578.xy, _576.xy, _576.zw);
	            vec3 _4274 = _4273.xyz;
	            _573 = _4273.z;
	            float _4276 = _4273.x;
	            float _4277 = _4273.y;
	            float _4279 = (_4276 + _4277) - 1.00392162799835205078125;
	            float _4280 = _4276 - _4277;
	            vec3 _4287 = normalize(vec3(vec2(_4279, _4280), (1.0 - abs(_4279)) - abs(_4280)));
	            _4274.x = _4287.x;
	            _4274.y = _4287.y;
	            _4274.z = _4287.z;
	            vec3 _4300 = _4274;
	            _4300.x = dot(_4274.xy, _g_rtx_material_data_.g_vNormalXform_1.xy);
	            _4300.y = dot(_4274.xy, _g_rtx_material_data_.g_vNormalXform_1.zw);
	            vec3 _643 = _4300;
	            vec3 _615;
	            vec3 _616;
	            if (_g_rtx_material_data_.g_nUVSet1 > 1)
	            {
	                _616 = _569;
	                _615 = _568;
	            }
	            else
	            {
	                _616 = _571;
	                _615 = _570;
	            }
	            vec3 _4312 = abs(_643.xyz);
	            vec2 _4325 = (-vec2(_643.x, (-1.0) * _643.y)) / vec2(max(_4312.z, 0.0078125 * max(_4312.x, _4312.y)));
	            _579 = normalize(_629 - ((_616 * _4325.x) + (_615 * _4325.y)));
	        }
	    }
	    if (true)
	    {
	        _579 = normalize(_579);
	        _573 = saturate(_573);
	    }
	    vec4 _638;
	    if (false)
	    {
	        _638 = vec4((vec4(_580.xyz, 1.0) * _g_rtx_material_data_.g_mTextureAdjust1).xyz, _580.w);
	    }
	    else
	    {
	        _638 = _580;
	    }
	    vec4 _4529 = _638;
	    float _4531 = _574;
	    float _4532 = saturate(_4531);
	    _574 = _4532;
	    vec3 _4536 = mix(_4529.xyz, vec4((vec4(_580.xyz, 1.0) * _g_rtx_material_data_.g_mTextureColorAdjust1).xyz, _478).xyz, vec3(_4532));
	    vec4 _4538 = _4529;
	    _4538.x = _4536.x;
	    _4538.y = _4536.y;
	    _4538.z = _4536.z;
	    float _4548 = dot(_4538.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125));
	    vec3 _4551 = normalize(max(_555.xyz, vec3(0.001000000047497451305389404296875)));
	    vec4 _4570 = vec4(clamp(mix(_4538.xyz, (_4551 * min(_4548 / dot(_4551.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125)), (3.0 * _4548) * max(_555.x, max(_555.y, _555.z)))).xyz, vec3(_555.w * _4532)), vec3(0.0), vec3(1.0)).xyz, _4538.w);
	    _580 = _4570;
	    _601 = _579.xyz;
	    _600 = _4570.xyz;
	    vec2 _4575 = _599;
	    _4575.x = _573;
	    _598 = _575;
	    vec2 _4578 = _4575;
	    _4578.x = _4575.x;
	    _4578.y = _4575.x;
	    _599 = _4578;
	    vec3 _4588 = _600;
	    vec3 _4589 = _4588 * mix(vec3(1.0), _551.xyz, vec3(saturate(_574)));
	    _600 = _4589;
	    payload.nInstance = int(uint(gl_InstanceID));
	    payload.flHitT = gl_RayTmaxEXT;
	    payload.vFaceNormalWs = _593;
	    payload.vInterpolatedNormalWs = _594;
	    vec3 _636[3] = vec3[](_495, _489, _484);
	    vec3 _637[3] = vec3[](_494, _488, _483);
	    vec3 _4630 = ((_636[0] * ((1.0 - attrs.barycentrics.x) - attrs.barycentrics.y)) + (_636[1] * attrs.barycentrics.x)) + (_636[2] * attrs.barycentrics.y);
	    vec3 _630[3];
	    _630[0] = _4630 - (_637[0] * dot(_4630 - _636[0], _637[0]));
	    _630[1] = _4630 - (_637[1] * dot(_4630 - _636[1], _637[1]));
	    _630[2] = _4630 - (_637[2] * dot(_4630 - _636[2], _637[2]));
	    vec3 _4670 = ((_630[0] * ((1.0 - attrs.barycentrics.x) - attrs.barycentrics.y)) + (_630[1] * attrs.barycentrics.x)) + (_630[2] * attrs.barycentrics.y);
	    vec3 _631[3];
	    _631[0] = cross(_636[0] - _636[1], _593);
	    _631[1] = cross(_636[1] - _636[2], _593);
	    _631[2] = cross(_636[2] - _636[0], _593);
	    float _632 = dot(_4670 - _4630, _593);
	    vec3 _633 = _4670;
	    int _634 = 0;
	    for (;;)
	    {
	        bool _4686_ladder_break = false;
	        do
	        {
	            if (!(_634 < 3))
	            {
	                _4686_ladder_break = true;
	                break;
	            }
	            if (_632 > 0.00999999977648258209228515625)
	            {
	                _4686_ladder_break = true;
	                break;
	            }
	            if (dot(_631[_634], _631[_634]) == 0.0)
	            {
	                break;
	            }
	            _631[_634] = normalize(_631[_634]);
	            int _635 = 0;
	            for (;;)
	            {
	                if (!(_635 < 3))
	                {
	                    break;
	                }
	                vec3 _4724 = _637[_635] - (_631[_634] * dot(_631[_634], _637[_635]));
	                _630[_635] = _4630 - (_4724 * dot(_4630 - _636[_635], _4724));
	                _635++;
	                continue;
	            }
	            vec3 _4748 = ((_630[0] * ((1.0 - attrs.barycentrics.x) - attrs.barycentrics.y)) + (_630[1] * attrs.barycentrics.x)) + (_630[2] * attrs.barycentrics.y);
	            _632 = dot(_4748 - _4630, _593);
	            _633 = _4748;
	            break;
	        } while(false);
	        if (_4686_ladder_break)
	        {
	            break;
	        }
	        _634++;
	        continue;
	    }
	    if (!(_632 > 0.00999999977648258209228515625))
	    {
	        _633 = vec3(3.4028234663852885981170418348452e+38);
	    }
	    payload.vSmoothPositionWs = _633;
	    payload.bFlippedNormal = _592;
	    f16vec3 _4761 = f16vec3(vec3(0.0));
	    payload.material = MaterialDataMinimal_t(_4761, float16_t(0.0), f16vec3(vec3(1.0, 0.0, 1.0)), float16_t(1.0), _4761, float16_t(0.040008544921875), 0u, f16vec4(ivec4(0)));
	    payload.material.vNormalWs = f16vec3(_601);
	    payload.material.vAlbedo = f16vec3(_4589);
	    payload.material.vEmissive = f16vec3(_597);
	    payload.material.flReflectance = float16_t(_596);
	    payload.material.flMetalness = float16_t(_598);
	    payload.material.flRoughness = float16_t(dot(_599, vec2(0.5)));
	    if (any(greaterThan(_595, vec3(0.0))))
	    {
	        payload.material.nMaterialTypeAndFlags = (payload.material.nMaterialTypeAndFlags & 4294901760u) | 1u;
	        f16vec3 _4787 = f16vec3(_595);
	        payload.material.vMaterialBits.x = _4787.x;
	        payload.material.vMaterialBits.y = _4787.y;
	        payload.material.vMaterialBits.z = _4787.z;
	    }
	}
	
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
	
	BoolAttribute(BindlessResources, true);
	IntAttribute(RayTypeCount, 2);
	StringAttribute(MaterialLayerRefType, csgo_environment);
	BoolAttribute(CanBatchWithDynamicShaderConstants, true);
	IntAttribute(TexCoordScaleByModelU, g_nScaleTexCoordUByModelScaleAxis-1);
	IntAttribute(TexCoordScaleByModelV, g_nScaleTexCoordVByModelScaleAxis-1);
	Float3Attribute(LightSim_MaterialTint, g_vColorTint);
	BoolAttribute(VertexPaintUIPickColor, true);
	BoolAttribute(GroupDefaultCollapseState_TextureTransform, true);
	BoolAttribute(GroupDefaultCollapseState_DetailTextureTransform, true);
	BoolAttribute(HasTexcoordTransform, ((g_nUVSet1>0) && (((g_vTexCoordScale1.x!=1) || (g_vTexCoordScale1.y!=1)) || (g_flTexCoordRotation1!=0))) || 0);
	BoolAttribute(VertexPaintUIAlphaBlendFactor, true);
	BoolAttribute(VertexPaintUIPuddles, (F_WETNESS==1) || 0);
	BoolAttribute(SupportsAggregateInstancing, true);
	BoolAttribute(NeedsLightProbe, true);
	BoolAttribute(DoNotCastShadows, F_DO_NOT_CAST_SHADOWS || 0);
	BoolAttribute(SupportsMappingDimensions, true);
	BoolAttribute(renderbackfaces, F_RENDER_BACKFACES || 0);
	
	#if (S_SHADER_QUALITY == 0)
		BoolAttribute(alphatest, true);
		FloatAttribute(_dummyReferenceAlphaTestReferenceInMainShader, g_flAlphaTestReference);
		FloatAttribute(_dummyReferenceAntiAliasedEdgeStrengthReferenceInMainShader, g_flAntiAliasedEdgeStrength);
		BoolAttribute(NoZPrepass, true);
		BoolAttribute(AlphaTestZPrepass, true);
	#endif
	#if (S_ALPHA_TEST_LAYER == 1)
		BoolAttribute(alphatest, true);
		FloatAttribute(_dummyReferenceAlphaTestReferenceInMainShader, g_flAlphaTestReference);
		FloatAttribute(_dummyReferenceAntiAliasedEdgeStrengthReferenceInMainShader, g_flAntiAliasedEdgeStrength);
		BoolAttribute(NoZPrepass, true);
		BoolAttribute(AlphaTestZPrepass, true);
	#endif
	#if (S_ALPHA_TEST_LAYER == 0)
		BoolAttribute(NoZPrepass, F_DISABLE_Z_PREPASS || 0);
	#endif
	#if (S_MODE_DEPTH == 0)
		BoolAttribute(alphatest, true);
		FloatAttribute(_dummyReferenceAlphaTestReferenceInMainShader, g_flAlphaTestReference);
		FloatAttribute(_dummyReferenceAntiAliasedEdgeStrengthReferenceInMainShader, g_flAntiAliasedEdgeStrength);
		BoolAttribute(NoZPrepass, true);
		BoolAttribute(AlphaTestZPrepass, true);
	#endif
	#if (S_MODE_TOOLS_VIS == 0)
		BoolAttribute(alphatest, true);
		FloatAttribute(_dummyReferenceAlphaTestReferenceInMainShader, g_flAlphaTestReference);
		FloatAttribute(_dummyReferenceAntiAliasedEdgeStrengthReferenceInMainShader, g_flAntiAliasedEdgeStrength);
		BoolAttribute(NoZPrepass, true);
		BoolAttribute(AlphaTestZPrepass, true);
	#endif
	#if (S_MATERIAL_REFERENCE == 0)
		BoolAttribute(alphatest, true);
		FloatAttribute(_dummyReferenceAlphaTestReferenceInMainShader, g_flAlphaTestReference);
		FloatAttribute(_dummyReferenceAntiAliasedEdgeStrengthReferenceInMainShader, g_flAntiAliasedEdgeStrength);
		BoolAttribute(NoZPrepass, true);
		BoolAttribute(AlphaTestZPrepass, true);
	#endif
	#if (S_MATERIAL_REFERENCE == 1)
		IntAttribute(MaterialLayerCount, 1);
		StringAttribute(MaterialLayerType, csgo_environment);
	#endif
}
