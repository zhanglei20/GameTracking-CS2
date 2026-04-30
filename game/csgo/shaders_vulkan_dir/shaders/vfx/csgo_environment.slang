//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "Environment shader with blended layers";
	DevShader = false;
	Version = 5;
	
	// VcsVersion: 70
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
	ByteAddressBuffer g_animatedVertexCache < Attribute("AnimatedVertexCache"); SrgbRead(false); >;
	bool g_bTexCoordScaleByModel < UiType(CheckBox); Expression((g_nScaleTexCoordUByModelScaleAxis!=0) || (g_nScaleTexCoordVByModelScaleAxis!=0)); >;
	ExternalDescriptorSet g_globalLateBoundBindlessSet < Source(ExternalDescSet); Attribute("g_globalLateBoundBindlessSet"); >;
	StructuredBuffer g_instanceBuffer < Attribute("InstanceBuffer"); SrgbRead(false); >;
	ExternalDescriptorSet g_lightBinnerGpuSet < Source(ExternalDescSet); Attribute("g_lightBinnerGpuSet"); >;
	StructuredBuffer g_transformBuffer < Attribute("TransformBuffer"); SrgbRead(false); >;
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
	// SPIR-V source (8036 bytes), GLSL reflection with SPIRV-Cross by KhronosGroup
	
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
	
	struct _2284
	{
	    vec4 _m0[3];
	};
	
	struct _2516
	{
	    _2284 _m0;
	};
	
	struct _785
	{
	    vec4 _m0[4];
	};
	
	layout(set = 4, binding = 32, std430) readonly buffer g_instanceBuffer
	{
	    _1125 _m0[];
	} g_instanceBuffer_1;
	
	layout(set = 4, binding = 30, std430) readonly buffer g_transformBuffer
	{
	    _2516 _m0[];
	} g_transformBuffer_1;
	
	struct _2593
	{
	    _785 _m0;
	    vec4 _m1;
	};
	
	layout(set = 0) uniform _2593 PerViewConstantBuffer_t;
	
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
	    vec3 _11179 = normalize(vec4(vNormalOs.xyz, 0.0) * _17839);
	    vec3 _12151 = vec4(vPositionOs.xyz * _21709.xyz, 1.0) * _17839;
	    vec4 _23875 = (vec4(_12151.xyz, 1.0) + (PerViewConstantBuffer_t._m1 * 1.0)).xyzw * mat4(vec4(PerViewConstantBuffer_t._m0._m0[0].x, PerViewConstantBuffer_t._m0._m0[1].x, PerViewConstantBuffer_t._m0._m0[2].x, PerViewConstantBuffer_t._m0._m0[3].x), vec4(PerViewConstantBuffer_t._m0._m0[0].y, PerViewConstantBuffer_t._m0._m0[1].y, PerViewConstantBuffer_t._m0._m0[2].y, PerViewConstantBuffer_t._m0._m0[3].y), vec4(PerViewConstantBuffer_t._m0._m0[0].z, PerViewConstantBuffer_t._m0._m0[1].z, PerViewConstantBuffer_t._m0._m0[2].z, PerViewConstantBuffer_t._m0._m0[3].z), vec4(PerViewConstantBuffer_t._m0._m0[0].w, PerViewConstantBuffer_t._m0._m0[1].w, PerViewConstantBuffer_t._m0._m0[2].w, PerViewConstantBuffer_t._m0._m0[3].w));
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
	    vec4 _11323 = vec4(_Globals_.g_vColorTint, _23812.w * g_instanceBuffer_1._m0[nInstanceIdx]._m7);
	    vec3 _14119 = _11323.xyz * mix(vec3(1.0), vColorBlendValues.xyz, vec3(vColorBlendValues.w));
	    vec4 _23714 = _11323;
	    _23714.x = _14119.x;
	    _23714.y = _14119.y;
	    _23714.z = _14119.z;
	    output_0 = vec4(_21354, _21355, _14124, _Globals_.g_flModelTintAmount * (1.0 - min(_21354, min(_21355, _14124))));
	    output_1 = vec4(vBlendColorTint.xyz, max(min(vBlendColorTint.w, 1.0), 0.001000000047497451305389404296875));
	    output_2 = _12151.xyz - PerViewConstantBufferCsgo_t._m0.xyz;
	    output_3 = _11179;
	    output_4 = _18606;
	    output_5 = _23714;
	    output_6 = _11179;
	    output_7 = vec4(normalize(vec4(vTangentUOs_flTangentVSign.xyz, 0.0) * _17839), vTangentUOs_flTangentVSign.w);
	    output_8 = (g_instanceBuffer_1._m0[nInstanceIdx]._m5) & 65535u;
	    _23875.y = -_23875.y;
	    gl_Position = _23875;
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
	BoolAttribute(HasTexcoordTransform, (((g_vTexCoordScale1.x!=1) || (g_vTexCoordScale1.y!=1)) || (g_flTexCoordRotation1!=0)) || 0);
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
	StructuredBuffer g_BarnLights < Attribute("BarnLights"); SrgbRead(false); >;
	StructuredBuffer g_CullBits < Attribute("CullBits"); SrgbRead(false); >;
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
	float4x4 g_mTextureAdjust1 < Expression(MatrixMultiply(MatrixColorTint2(float3(1,1,1),1),MatrixColorCorrect2(float3(g_fTextureColorContrast1,g_fTextureColorSaturation1,g_fTextureColorBrightness1),TextureAverageColor(g_tColor1)))); >;
	float4x4 g_mTextureColorAdjust1 < Expression(MatrixMultiply(MatrixColorTint2(g_vTextureColorTint1,1),MatrixColorCorrect2(float3(g_fTextureColorContrast1,g_fTextureColorSaturation1,g_fTextureColorBrightness1),TextureAverageColor(g_tColor1)))); >;
	float4x4 g_mTextureColorAdjust1 < Expression(MatrixMultiply(MatrixColorTint2(float3(1,1,1),1),MatrixColorCorrect2(float3(1,1,1),TextureAverageColor(g_tColor1)))); >;
	int g_nToolsVisMode < Attribute("g_nToolsVisMode"); UiType(Slider); >;
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
	#endif
	#if (S_MODE_DEPTH == 1)
	#endif
	#if (S_ALPHA_TEST_LAYER == 1)
	#endif
	#if (S_SHADER_QUALITY == 1)
	#endif
	
	// SPIR-V reflection failed for backend HLSL:
	// cbuffer ID 5618 (name: _Globals_), member index 5 (name: g_vBiplanarTexCoordScale) cannot be expressed with either HLSL packing layout or packoffset.
	// 
	// Re-attempting reflection with the GLSL backend.
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (65688 bytes), GLSL reflection with SPIRV-Cross by KhronosGroup
	
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
	
	struct anon_g_mTextureColorAdjust1
	{
	    vec4 _m0[4];
	};
	
	const vec3 _2029[3] = vec3[](vec3(-1.0, 0.0, 0.0), vec3(0.0, 1.0, 0.0), vec3(-1.0, 0.0, 0.0));
	const vec3 _842[3] = vec3[](vec3(0.0, 0.0, 1.0), vec3(0.0, -1.0, 0.0), vec3(0.0, 0.0, 1.0));
	
	struct _2662
	{
	    vec4 _m0[3];
	};
	
	struct _2873
	{
	    vec4 _m0[4];
	};
	
	struct _2663
	{
	    vec4 _m0[3];
	};
	
	struct _1734
	{
	    anon_g_mTextureColorAdjust1 _m0[4];
	};
	
	struct _665
	{
	    anon_g_mTextureColorAdjust1 _m0;
	    anon_g_mTextureColorAdjust1 _m1;
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
	    _2663 _m15;
	    vec4 _m16;
	    vec4 _m17;
	    vec4 _m18;
	    vec4 _m19;
	    vec4 _m20;
	    vec3 _m21;
	    float _m22;
	    anon_g_mTextureColorAdjust1 _m23;
	};
	
	float _4;
	vec3 _5;
	vec3 _6;
	vec4 _7;
	float _10;
	
	struct _1969
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
	    anon_g_mTextureColorAdjust1 g_mTextureColorAdjust1;
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
	
	layout(set = 1) uniform _1969 _Globals_;
	
	struct _371
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
	    anon_g_mTextureColorAdjust1 _m13;
	    vec2 _m14;
	    float _m15;
	    vec4 _m16;
	    vec4 _m17;
	    vec4 _m18;
	    vec4 _m19;
	    vec4 _m20;
	    vec4 _m21;
	    anon_g_mTextureColorAdjust1 _m22;
	    vec4 _m23;
	    vec4 _m24;
	    vec4 _m25;
	    float _m26;
	};
	
	layout(set = 1) uniform _371 PerViewConstantBufferCsgo_t;
	
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
	
	struct _476
	{
	    _2662 _m0;
	    _2873 _m1;
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
	    _1734 _m18;
	    _2873 _m19;
	    uint _m20;
	    uint _m21;
	};
	
	layout(set = 3) uniform _476 PerViewLightingConstantBufferGpu_t;
	
	layout(set = 3, binding = 30, std430) readonly buffer g_CullBits
	{
	    uint _m0[];
	} g_CullBits_1;
	
	layout(set = 3, binding = 31, std430) readonly buffer g_BarnLights
	{
	    _665 _m0[];
	} g_BarnLights_1;
	
	layout(set = 4, binding = 46) uniform texture2D g_bindless_Texture2D_float4[65536];
	layout(set = 4, binding = 29) uniform sampler undetermined[2048];
	layout(set = 4, binding = 29) uniform samplerShadow undetermined_1[2048];
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
	        _12886 = !(_Globals_.g_bDontFlipBackfaceNormals != 0);
	    }
	    else
	    {
	        _12886 = false;
	    }
	    bool _18545;
	    if (_12886)
	    {
	        _18545 = (gl_FrontFacing ? 1.0 : (-1.0)) < 0.0;
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
	        _17114 = _19651 / vec2(_19651.x + _19651.y);
	        _17115 = vec2(_16446[_19322.x], _16446[_19322.y]);
	        _17116 = vec2(_16415[_19322.x], _16415[_19322.y]);
	        _17117 = vec2(_16414[_19322.x], _16414[_19322.y]);
	        _17118 = vec2(_16446[_19321.x], _16446[_19321.y]);
	        _13694 = vec2(_16415[_19321.x], _16415[_19321.y]);
	        _6616 = vec2(_16414[_19321.x], _16414[_19321.y]);
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
	    vec2 _13137;
	    vec2 _13998;
	    vec2 _16306;
	    vec2 _17119;
	    vec2 _17120;
	    vec2 _17121;
	    vec4 _23299;
	    if (_8452)
	    {
	        vec2 _19978 = _6616 * _Globals_.g_vTexCoordScale1.xy;
	        vec2 _21750 = _13694 * _Globals_.g_vTexCoordScale1.xy;
	        vec2 _22329 = _17118 * _Globals_.g_vTexCoordScale1.xy;
	        vec2 _22330 = _17117 * _Globals_.g_vTexCoordScale1.xy;
	        vec2 _21037 = _17116 * _Globals_.g_vTexCoordScale1.xy;
	        vec2 _13654 = _17115 * _Globals_.g_vTexCoordScale1.xy;
	        _13137 = _19978;
	        _16306 = _22330;
	        _17119 = _21750;
	        _17120 = _22329;
	        _17121 = _21037;
	        _13998 = _13654;
	        _23299 = (textureGrad(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tHeight1], undetermined[_Globals_.g_sUserConfig]), _19978.xy, _21750.xy, _22329.xy) * _17114.x) + (textureGrad(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tHeight1], undetermined[_Globals_.g_sUserConfig]), _22330.xy, _21037.xy, _13654.xy) * _17114.y);
	    }
	    else
	    {
	        _13137 = _6616;
	        _16306 = _17117;
	        _17119 = _13694;
	        _17120 = _17118;
	        _17121 = _17116;
	        _13998 = _17115;
	        _23299 = texture(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tHeight1], undetermined[_Globals_.g_sUserConfig]), _24878.xy).xyzw;
	    }
	    float _21711;
	    if (_Globals_.g_bWetnessUseHeightmapAdjustments != 0)
	    {
	        _21711 = max(0.0, _23299.x);
	    }
	    else
	    {
	        _21711 = _23299.x;
	    }
	    float _13139;
	    vec3 _13189;
	    vec4 _22057;
	    if (_8452)
	    {
	        vec2 _8315 = (_13137 * _Globals_.g_vTexCoordScale1.xy).xy;
	        vec2 _7412 = (_17119 * _Globals_.g_vTexCoordScale1.xy).xy;
	        vec2 _8904 = (_17120 * _Globals_.g_vTexCoordScale1.xy).xy;
	        vec4 _23806 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tColor1], undetermined[_Globals_.g_sUserConfig]), _8315, _7412, _8904) * _17114.x;
	        vec4 _12167 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tNormal1], undetermined[_Globals_.g_sUserConfig]), _8315, _7412, _8904);
	        float _18178 = _12167.z * _17114.x;
	        float _15456 = _12167.x;
	        float _24534 = _12167.y;
	        float _16784 = (_15456 + _24534) - 1.00392162799835205078125;
	        float _11177 = _15456 - _24534;
	        vec3 _21631 = normalize(vec3(vec2(_16784, _11177), (1.0 - abs(_16784)) - abs(_11177))).xyz * _17114.x;
	        vec3 _24466 = (_2029[_13136.x] * _21631.x) + (_842[_13136.y] * _21631.y);
	        float _13138;
	        vec3 _13753;
	        vec4 _14101;
	        if (_17114.y > 0.0)
	        {
	            vec2 _17047 = (_16306 * _Globals_.g_vTexCoordScale1.xy).xy;
	            vec2 _10017 = (_17121 * _Globals_.g_vTexCoordScale1.xy).xy;
	            vec2 _8905 = (_13998 * _Globals_.g_vTexCoordScale1.xy).xy;
	            vec4 _12168 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tNormal1], undetermined[_Globals_.g_sUserConfig]), _17047, _10017, _8905);
	            float _13491 = _12168.x;
	            float _21308 = _12168.y;
	            float _16785 = (_13491 + _21308) - 1.00392162799835205078125;
	            float _11178 = _13491 - _21308;
	            vec3 _21632 = normalize(vec3(vec2(_16785, _11178), (1.0 - abs(_16785)) - abs(_11178))).xyz * _17114.y;
	            _13138 = _18178 + (_12168.z * _17114.y);
	            _14101 = _23806 + (textureGrad(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tColor1], undetermined[_Globals_.g_sUserConfig]), _17047, _10017, _8905) * _17114.y);
	            _13753 = _24466 + ((_2029[_16305.x] * _21632.x) + (_842[_16305.y] * _21632.y));
	        }
	        else
	        {
	            _13138 = _18178;
	            _14101 = _23806;
	            _13753 = _24466;
	        }
	        _13139 = _13138;
	        _13189 = normalize(_13753 + _24347);
	        _22057 = _14101;
	    }
	    else
	    {
	        vec4 _11179 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tNormal1], undetermined[_Globals_.g_sUserConfig]), _24878.xy, _9716.xy, _9716.zw);
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
	        _13139 = _11179.z;
	        _13189 = normalize(_8889 - ((mix(input_7.xyz * _12157, _11711, _20662) * _16475.x) + (mix((cross(input_3, input_7.xyz) * ((input_7.w > 0.0) ? 1.0 : (-1.0))) * _12157, _10247, _20662) * _16475.y)));
	        _22057 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tColor1], undetermined[_Globals_.g_sUserConfig]), _24878.xy, _9716.xy, _9716.zw).xyzw;
	    }
	    vec3 _19225 = normalize(_13189);
	    float _6375 = saturate(_13139);
	    float _14713 = clamp(mix(0.0, 1.0, pow(_22057.w, 1.0)), 0.0, 1.0);
	    float _7029 = saturate(_23299.y);
	    vec3 _25191 = mix(_22057.xyz, vec4((vec4(_22057.xyz, 1.0) * mat4(vec4(_Globals_.g_mTextureColorAdjust1._m0[0].x, _Globals_.g_mTextureColorAdjust1._m0[1].x, _Globals_.g_mTextureColorAdjust1._m0[2].x, _Globals_.g_mTextureColorAdjust1._m0[3].x), vec4(_Globals_.g_mTextureColorAdjust1._m0[0].y, _Globals_.g_mTextureColorAdjust1._m0[1].y, _Globals_.g_mTextureColorAdjust1._m0[2].y, _Globals_.g_mTextureColorAdjust1._m0[3].y), vec4(_Globals_.g_mTextureColorAdjust1._m0[0].z, _Globals_.g_mTextureColorAdjust1._m0[1].z, _Globals_.g_mTextureColorAdjust1._m0[2].z, _Globals_.g_mTextureColorAdjust1._m0[3].z), vec4(_Globals_.g_mTextureColorAdjust1._m0[0].w, _Globals_.g_mTextureColorAdjust1._m0[1].w, _Globals_.g_mTextureColorAdjust1._m0[2].w, _Globals_.g_mTextureColorAdjust1._m0[3].w))).xyz, _4).xyz, vec3(_7029));
	    vec4 _17842;
	    _17842.x = _25191.x;
	    _17842.y = _25191.y;
	    _17842.z = _25191.z;
	    float _24323 = dot(_17842.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125));
	    vec3 _9577 = normalize(max(input_0.xyz, vec3(0.001000000047497451305389404296875)));
	    vec3 _6756 = _19225.xyz;
	    vec3 _6663 = vec4(clamp(mix(_17842.xyz, (_9577 * min(_24323 / dot(_9577.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125)), (3.0 * _24323) * max(input_0.x, max(input_0.y, input_0.z)))).xyz, vec3(input_0.w * _7029)), vec3(0.0), vec3(1.0)).xyz, _10).xyz;
	    float _9090 = float(_Globals_.g_bSnowLayer1 != 0);
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
	    vec3 _13142;
	    float _13960;
	    vec2 _16307;
	    float _17123;
	    float _17124;
	    vec3 _17125;
	    vec3 _24595;
	    if (_12890)
	    {
	        vec4 _19372 = texture(sampler2D(g_bindless_Texture2D_float4[PerViewConstantBufferCsgo_t._m7], undetermined[_Globals_.g_sUserConfig]), (_10061.xy * 0.006000000052154064178466796875).xy);
	        float _21302 = _24347.z;
	        float _14498 = pow(max(0.0, _21302), 32.0);
	        float _23204 = min(min(input_1.z, saturate(PerViewConstantBufferCsgo_t._m11)), 1.0 - (saturate(PerViewConstantBufferCsgo_t._m12 - 0.5) * 2.0));
	        float _18407 = saturate(_23204 - 0.75) * 2.0;
	        float _8284 = _23204 + (_18407 * _18407);
	        float _16777 = _8284 - _Globals_.g_fWetEdgeSpread;
	        float _11964 = saturate(_8284 * 20.0);
	        vec4 _9717;
	        float _24879;
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
	        float _13141;
	        float _13151;
	        vec4 _23607;
	        if (_13706 > 0.5)
	        {
	            float _12497 = _Globals_.g_fRippleStrength * PerViewConstantBufferCsgo_t._m9;
	            vec3 _6617;
	            vec4 _12891;
	            float _13140;
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
	                vec4 _20877 = texture(sampler2D(g_bindless_Texture2D_float4[PerViewConstantBufferCsgo_t._m7], undetermined[_Globals_.g_sUserConfig]), (_15991 + (vec2(0.20000000298023223876953125, 0.0) * PerViewConstantBuffer_t._m1)).xy);
	                vec2 _18922 = (_20877.xy * 2.0) - vec2(1.0);
	                float _22217 = clamp(length(fwidth(_15991)) * 10.0, 0.0, 1.0);
	                vec2 _15297 = ((_18922 * vec2(0.100000001490116119384765625, 0.0500000007450580596923828125)) * input_1.z) * mix(1.0, 0.300000011920928955078125, _22217);
	                vec2 _13711 = _21326.xy;
	                vec4 _19601 = vec4(0.0);
	                _19601.x = dot(_22900.xy, _15297);
	                _19601.y = dot(_13711, _15297);
	                vec2 _16048 = (vec2(_20274.y, _9965) * vec2(0.03599999845027923583984375, 0.01620000042021274566650390625)) + (_18922 * 0.0500000007450580596923828125);
	                vec4 _20878 = texture(sampler2D(g_bindless_Texture2D_float4[PerViewConstantBufferCsgo_t._m7], undetermined[_Globals_.g_sUserConfig]), (_16048 + (vec2(0.1500000059604644775390625, 0.0) * PerViewConstantBuffer_t._m1)).xy);
	                vec2 _17104 = (((_20878.xy * 2.0) - vec2(1.0)) * 0.05200000107288360595703125) * input_1.z;
	                _17104.y = _17104.y * 0.5;
	                float _9250 = clamp(length(fwidth(_16048)) * 10.0, 0.0, 1.0);
	                vec2 _13560 = _17104 * mix(1.0, 0.300000011920928955078125, _9250);
	                vec2 _13330 = _19601.xy + vec2(dot(_22900.xy, _13560), dot(_13711, _13560));
	                vec4 _20489 = _19601;
	                _20489.x = _13330.x;
	                _20489.y = _13330.y;
	                _20489.w = input_1.z * (_20877.z + _20878.z);
	                vec3 _20490;
	                _20490.x = _10061.x;
	                _20490.y = _10061.y;
	                _13140 = _12497 * (0.039999999105930328369140625 * (_22217 + _9250));
	                _12891 = _9717 + ((_20489 * _14498) * _12497);
	                _6617 = _20490;
	            }
	            else
	            {
	                _13140 = 0.0;
	                _12891 = _9717;
	                _6617 = _10061;
	            }
	            float _8914 = (_Globals_.g_fRainStrength * PerViewConstantBufferCsgo_t._m8) * PerViewConstantBufferCsgo_t._m8;
	            float _9982;
	            vec4 _21594;
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
	            _13141 = _9982;
	            _13151 = _13140;
	            _23607 = _16886;
	        }
	        else
	        {
	            _13141 = 0.0;
	            _13151 = 0.0;
	            _23607 = _9717;
	        }
	        float _10839 = _14611 * _Globals_.g_fPuddleStrength;
	        vec3 _13712 = normalize(mix(_19225.xyz, _23607.xyz, vec3(saturate(_10839 * 4.0))));
	        float _9038 = max(_13706 * (1.0 - saturate(PerViewConstantBufferCsgo_t._m12 * 2.0)), _19808);
	        vec3 _18806 = mix(_21712, pow(_21712, vec3(1.2999999523162841796875)) * 0.800000011920928955078125, clamp((pow(_21712, vec3(0.25)) * (_9038 * _6375)) * 8.0, vec3(0.0), vec3(1.0)) * _Globals_.g_flWetnessDarkeningStrength1);
	        _13142 = fma(mix((mix(_18806, _18806 * 0.5, vec3(saturate(_14611 * 1.5))) * mix(1.0, _14713, _19808)) * mix(1.0, 1.0 - _17924, _10334), _Globals_.g_vPuddleSedimentColor, vec3(_10334 * _19808)), vec3(1.0 + _13141), vec3(_13141 * 0.100000001490116119384765625));
	        _16307 = clamp(mix(_11281.xx, vec2(_Globals_.g_fPuddleRoughness), vec2(_9038)) + vec2(_13151 + (length(fwidth(_13712.xyz)) * 0.5)), vec2(0.0), vec2(1.0));
	        _17123 = mix(_14713, 1.0, _19808);
	        _17124 = mix(_Globals_.g_flReflectance, 0.0350000001490116119384765625, _9038);
	        _17125 = _13712;
	        _13960 = _10839 * (0.20000000298023223876953125 + (((0.1500000059604644775390625 * _23607.w) * _23607.w) * _23607.w));
	        _24595 = mix(_6756, _23607.xyz, vec3(_19808 * _10334));
	    }
	    else
	    {
	        _13142 = _21712;
	        _16307 = _11281;
	        _17123 = _14713;
	        _17124 = _Globals_.g_flReflectance;
	        _17125 = vec3(1.0);
	        _13960 = 0.0;
	        _24595 = _6756;
	    }
	    vec3 _9453 = mix(vec3(_17124).xyz, _13142.xyz, vec3(_23299.w));
	    vec3 _17892 = mix(_17125, _24595, bvec3(all(equal(_17125, vec3(1.0)))));
	    vec3 _10560 = _24347.xyz;
	    vec3 _11099 = dFdx(_10560);
	    vec3 _9175 = dFdy(_10560);
	    vec3 _10347 = _11099.xyz;
	    vec3 _12420 = _9175.xyz;
	    vec2 _21818 = max(_16307.xy, vec2(pow(clamp(max(dot(_10347, _10347), dot(_12420, _12420)), 0.0, 1.0), 0.333000004291534423828125)));
	    vec3 _15598 = -_24347;
	    vec4 _23875 = vec4(_24595.xyz, 1.0);
	    bvec4 _24464 = notEqual(PerViewConstantBufferCsgo_t._m0, ivec4(0));
	    float _21714;
	    if (_24464.x)
	    {
	        vec3 _11394 = _24347.xyz;
	        vec2 _11086 = ((floor(_11408.xy * PerViewConstantBufferCsgo_t._m15) * PerViewConstantBufferCsgo_t._m14.xy) + (PerViewConstantBufferCsgo_t._m14.xy * 0.5)).xy;
	        vec4 _18418 = textureGather(sampler2D(g_bindless_Texture2D_float4[PerViewConstantBufferCsgo_t._m4], undetermined[_Globals_.g_sCookieSampler]), _11086).xyzw - _11408.zzzz;
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
	        _21714 = (1.0 / (dot(_13232, vec4(1.0)) + PerViewLightingConstantBufferGpu_t._m3.x)) * (PerViewLightingConstantBufferGpu_t._m3.x + dot(_13232, textureLod(sampler2D(g_bindless_Texture2D_float4[PerViewConstantBufferCsgo_t._m3], undetermined[_Globals_.g_sPointClamp]), (_11086 + mix(_23169, PerViewConstantBufferCsgo_t._m14.xy, bvec2(abs(_18418.y) < (_12287 ? _15372 : _20965))).xy).xy, 0.0)));
	    }
	    else
	    {
	        _21714 = 1.0;
	    }
	    float _21715;
	    if (PerViewLightingConstantBufferGpu_t._m11 != 0)
	    {
	        int _23989;
	        int _10191;
	        float _13143;
	        vec3 _14975;
	        int _13039 = 0;
	        for (;;)
	        {
	            if (!(_13039 < PerViewLightingConstantBufferGpu_t._m11))
	            {
	                _13143 = 1.0;
	                _14975 = vec3(0.0);
	                _10191 = -1;
	                break;
	            }
	            vec4 _18322 = vec4(input_2.xyz, 1.0) * mat4(vec4(PerViewLightingConstantBufferGpu_t._m18._m0[_13039]._m0[0].x, PerViewLightingConstantBufferGpu_t._m18._m0[_13039]._m0[1].x, PerViewLightingConstantBufferGpu_t._m18._m0[_13039]._m0[2].x, PerViewLightingConstantBufferGpu_t._m18._m0[_13039]._m0[3].x), vec4(PerViewLightingConstantBufferGpu_t._m18._m0[_13039]._m0[0].y, PerViewLightingConstantBufferGpu_t._m18._m0[_13039]._m0[1].y, PerViewLightingConstantBufferGpu_t._m18._m0[_13039]._m0[2].y, PerViewLightingConstantBufferGpu_t._m18._m0[_13039]._m0[3].y), vec4(PerViewLightingConstantBufferGpu_t._m18._m0[_13039]._m0[0].z, PerViewLightingConstantBufferGpu_t._m18._m0[_13039]._m0[1].z, PerViewLightingConstantBufferGpu_t._m18._m0[_13039]._m0[2].z, PerViewLightingConstantBufferGpu_t._m18._m0[_13039]._m0[3].z), vec4(PerViewLightingConstantBufferGpu_t._m18._m0[_13039]._m0[0].w, PerViewLightingConstantBufferGpu_t._m18._m0[_13039]._m0[1].w, PerViewLightingConstantBufferGpu_t._m18._m0[_13039]._m0[2].w, PerViewLightingConstantBufferGpu_t._m18._m0[_13039]._m0[3].w));
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
	                _13143 = saturate(_22193.x * _22193.y);
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
	            float _18270 = textureLod(sampler2DShadow(g_bindless_Texture2D_float4[PerViewLightingConstantBufferGpu_t._m20], undetermined_1[_Globals_.g_tShadowDepthBufferCmpSampler]), vec3(_14975.xy, saturate(_14975.z + PerViewLightingConstantBufferGpu_t._m12)), 0.0);
	            float _12501;
	            if (_13143 < 1.0)
	            {
	                float _7934;
	                if (_10191 < (PerViewLightingConstantBufferGpu_t._m11 - 1))
	                {
	                    int _15335 = _10191 + 1;
	                    vec4 _19671 = vec4(input_2.xyz, 1.0) * mat4(vec4(PerViewLightingConstantBufferGpu_t._m18._m0[_15335]._m0[0].x, PerViewLightingConstantBufferGpu_t._m18._m0[_15335]._m0[1].x, PerViewLightingConstantBufferGpu_t._m18._m0[_15335]._m0[2].x, PerViewLightingConstantBufferGpu_t._m18._m0[_15335]._m0[3].x), vec4(PerViewLightingConstantBufferGpu_t._m18._m0[_15335]._m0[0].y, PerViewLightingConstantBufferGpu_t._m18._m0[_15335]._m0[1].y, PerViewLightingConstantBufferGpu_t._m18._m0[_15335]._m0[2].y, PerViewLightingConstantBufferGpu_t._m18._m0[_15335]._m0[3].y), vec4(PerViewLightingConstantBufferGpu_t._m18._m0[_15335]._m0[0].z, PerViewLightingConstantBufferGpu_t._m18._m0[_15335]._m0[1].z, PerViewLightingConstantBufferGpu_t._m18._m0[_15335]._m0[2].z, PerViewLightingConstantBufferGpu_t._m18._m0[_15335]._m0[3].z), vec4(PerViewLightingConstantBufferGpu_t._m18._m0[_15335]._m0[0].w, PerViewLightingConstantBufferGpu_t._m18._m0[_15335]._m0[1].w, PerViewLightingConstantBufferGpu_t._m18._m0[_15335]._m0[2].w, PerViewLightingConstantBufferGpu_t._m18._m0[_15335]._m0[3].w));
	                    vec2 _20562 = (_19671.xy * PerViewLightingConstantBufferGpu_t._m19._m0[_15335].zw) + PerViewLightingConstantBufferGpu_t._m19._m0[_15335].xy;
	                    vec3 _20493;
	                    _20493.x = _20562.x;
	                    _20493.y = _20562.y;
	                    _7934 = textureLod(sampler2DShadow(g_bindless_Texture2D_float4[PerViewLightingConstantBufferGpu_t._m20], undetermined_1[_Globals_.g_tShadowDepthBufferCmpSampler]), vec3(_20493.xy, saturate(_19671.z + PerViewLightingConstantBufferGpu_t._m12)), 0.0);
	                }
	                else
	                {
	                    _7934 = 1.0;
	                }
	                _12501 = mix(_7934, _18270, _13143);
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
	            _12502 = min(_13279, textureLod(sampler2D(g_bindless_Texture2D_float4[PerViewConstantBufferCsgo_t._m5], undetermined[_Globals_.g_sTrilinearClamp]), (_11408.xy * PerViewConstantBuffer_t._m4.xy).xy, 0.0).z);
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
	        _9718 = ((_9453.xyz * (_19095 / (((_15346 * _15346) * (_19210 * _19210)) * ((_9850 * 4.0) + 2.0)))).xyz * _13811).xyz * _16808;
	        _24880 = PerViewLightingConstantBufferGpu_t._m4.xyz + (_18223.xyz * _16808);
	    }
	    else
	    {
	        _9718 = vec3(0.0);
	        _24880 = PerViewLightingConstantBufferGpu_t._m4.xyz;
	    }
	    bvec4 _24465 = notEqual(PerViewConstantBufferCsgo_t._m1, ivec4(0));
	    bool _20059 = _24465.x;
	    vec4 _19363;
	    if (_20059)
	    {
	        vec4 _24259 = vec4(_10061.xyz, 1.0).xyzw * mat4(vec4(PerViewConstantBufferCsgo_t._m13._m0[0].x, PerViewConstantBufferCsgo_t._m13._m0[1].x, PerViewConstantBufferCsgo_t._m13._m0[2].x, PerViewConstantBufferCsgo_t._m13._m0[3].x), vec4(PerViewConstantBufferCsgo_t._m13._m0[0].y, PerViewConstantBufferCsgo_t._m13._m0[1].y, PerViewConstantBufferCsgo_t._m13._m0[2].y, PerViewConstantBufferCsgo_t._m13._m0[3].y), vec4(PerViewConstantBufferCsgo_t._m13._m0[0].z, PerViewConstantBufferCsgo_t._m13._m0[1].z, PerViewConstantBufferCsgo_t._m13._m0[2].z, PerViewConstantBufferCsgo_t._m13._m0[3].z), vec4(PerViewConstantBufferCsgo_t._m13._m0[0].w, PerViewConstantBufferCsgo_t._m13._m0[1].w, PerViewConstantBufferCsgo_t._m13._m0[2].w, PerViewConstantBufferCsgo_t._m13._m0[3].w));
	        float _20176 = _24259.w;
	        vec2 _11414 = _24259.xy / vec2(_20176);
	        vec4 _6651;
	        _6651.x = clamp(((_11414.x + 1.0) * PerViewConstantBuffer_t._m3.x) * 0.5, 0.0, PerViewConstantBuffer_t._m3.x - 1.0);
	        _6651.y = clamp(((1.0 - _11414.y) * PerViewConstantBuffer_t._m3.y) * 0.5, 0.0, PerViewConstantBuffer_t._m3.y - 1.0);
	        _6651.w = _20176;
	        _19363 = _6651;
	    }
	    else
	    {
	        _19363 = _11408;
	    }
	    uvec2 _12083 = uvec2(_19363.xy - PerViewConstantBuffer_t._m2.xy) >> uvec2(PerViewLightingConstantBufferGpu_t._m6.x);
	    uint _10838 = PerViewLightingConstantBufferGpu_t._m5.y + (((_12083.y * PerViewLightingConstantBufferGpu_t._m6.y) + _12083.x) * PerViewLightingConstantBufferGpu_t._m5.z);
	    uint _23393 = PerViewLightingConstantBufferGpu_t._m5.x + (uint(clamp(_19363.w * PerViewLightingConstantBufferGpu_t._m7.x, 0.0, PerViewLightingConstantBufferGpu_t._m7.y)) * PerViewLightingConstantBufferGpu_t._m5.z);
	    vec3 _13144;
	    vec3 _16324;
	    _13144 = _9718;
	    _16324 = _24880;
	    uint _21567;
	    vec3 _13145;
	    vec3 _16325;
	    uint _17017 = 0u;
	    for (;;)
	    {
	        if (!(_17017 < PerViewLightingConstantBufferGpu_t._m5.z))
	        {
	            break;
	        }
	        uint _14475 = subgroupOr(g_CullBits_1._m0[_10838 + _17017] & g_CullBits_1._m0[_23393 + _17017]);
	        _13145 = _13144;
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
	                vec4 _15817 = mat4(vec4(g_BarnLights_1._m0[_12608]._m0._m0[0].x, g_BarnLights_1._m0[_12608]._m0._m0[1].x, g_BarnLights_1._m0[_12608]._m0._m0[2].x, g_BarnLights_1._m0[_12608]._m0._m0[3].x), vec4(g_BarnLights_1._m0[_12608]._m0._m0[0].y, g_BarnLights_1._m0[_12608]._m0._m0[1].y, g_BarnLights_1._m0[_12608]._m0._m0[2].y, g_BarnLights_1._m0[_12608]._m0._m0[3].y), vec4(g_BarnLights_1._m0[_12608]._m0._m0[0].z, g_BarnLights_1._m0[_12608]._m0._m0[1].z, g_BarnLights_1._m0[_12608]._m0._m0[2].z, g_BarnLights_1._m0[_12608]._m0._m0[3].z), vec4(g_BarnLights_1._m0[_12608]._m0._m0[0].w, g_BarnLights_1._m0[_12608]._m0._m0[1].w, g_BarnLights_1._m0[_12608]._m0._m0[2].w, g_BarnLights_1._m0[_12608]._m0._m0[3].w)) * vec4(input_2.xyz, 1.0);
	                vec3 _10521 = _15817.xyz / vec3(_15817.w);
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
	                    _12893 = !all(lessThanEqual(abs((mat4x3(vec3(g_BarnLights_1._m0[_12608]._m15._m0[0].x, g_BarnLights_1._m0[_12608]._m15._m0[1].x, g_BarnLights_1._m0[_12608]._m15._m0[2].x), vec3(g_BarnLights_1._m0[_12608]._m15._m0[0].y, g_BarnLights_1._m0[_12608]._m15._m0[1].y, g_BarnLights_1._m0[_12608]._m15._m0[2].y), vec3(g_BarnLights_1._m0[_12608]._m15._m0[0].z, g_BarnLights_1._m0[_12608]._m15._m0[1].z, g_BarnLights_1._m0[_12608]._m15._m0[2].z), vec3(g_BarnLights_1._m0[_12608]._m15._m0[0].w, g_BarnLights_1._m0[_12608]._m15._m0[1].w, g_BarnLights_1._m0[_12608]._m15._m0[2].w)) * vec4(input_2.xyz, 1.0)).xyz), vec3(1.0)));
	                }
	                if (_12893)
	                {
	                    _13212 = _13145;
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
	                        vec3 _23594 = _17795.xyz;
	                        vec3 _12170 = ((_20479 * g_BarnLights_1._m0[_12608]._m5.w) + (_23594 * _15156)) + cross(_23594, _20479);
	                        vec3 _14081 = vec3(vec2(atan(_12170.y, -_12170.x) * 0.15915493667125701904296875, acos(_12170.z) * 0.3183098733425140380859375), -g_BarnLights_1._m0[_12608]._m4.w);
	                        vec2 _20564 = (_14081.xy * g_BarnLights_1._m0[_12608]._m9.zw) + g_BarnLights_1._m0[_12608]._m9.xy;
	                        vec3 _20496 = _14081;
	                        _20496.x = _20564.x;
	                        _20496.y = _20564.y;
	                        _12503 = _17828.xyz * textureLod(sampler3D(g_bindless_Texture3D_float4[PerViewLightingConstantBufferGpu_t._m21], undetermined[_Globals_.g_sTrilinearWrap]), _20496.xyz, 0.0).xyz;
	                    }
	                    else
	                    {
	                        vec3 _13791 = vec3(fma(_22905.xy, vec2(0.5, -0.5), vec2(0.5)), g_BarnLights_1._m0[_12608]._m4.w);
	                        vec2 _20563 = (_13791.xy * g_BarnLights_1._m0[_12608]._m9.zw) + g_BarnLights_1._m0[_12608]._m9.xy;
	                        vec3 _20494 = _13791;
	                        _20494.x = _20563.x;
	                        _20494.y = _20563.y;
	                        _12503 = _17828.xyz * textureLod(sampler3D(g_bindless_Texture3D_float4[PerViewLightingConstantBufferGpu_t._m21], undetermined[_Globals_.g_sCookieSampler]), _20494.xyz, 0.0).xyz;
	                    }
	                    _21548 = _12503;
	                }
	                if (all(equal(_21548.xyz, vec3(0.0))))
	                {
	                    _13212 = _13145;
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
	                    vec3 _20482 = _21548.xyz * mix(1.0, textureLod(sampler2DShadow(g_bindless_Texture2D_float4[PerViewLightingConstantBufferGpu_t._m20], undetermined_1[_Globals_.g_tShadowDepthBufferCmpSampler]), vec3(vec3(fma(_19629.xy, g_BarnLights_1._m0[_12608]._m8.zw, g_BarnLights_1._m0[_12608]._m8.xy), _19629.z).xy, saturate(_19629.z + PerViewLightingConstantBufferGpu_t._m12)), 0.0), g_BarnLights_1._m0[_12608]._m12);
	                    if (all(equal(_20482.xyz, vec3(0.0))))
	                    {
	                        _13212 = _13145;
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
	                float _25215 = _9851 * _9851;
	                float _19097 = _25215 * _25215;
	                float _15348 = ((_12387 * _12387) * (_19097 - 1.0)) + 1.0;
	                _13212 = _13145.xyz + (((_9453.xyz * (_19097 / (((_15348 * _15348) * (_19211 * _19211)) * ((_9851 * 4.0) + 2.0)))).xyz * _13812).xyz * _21549.xyz);
	                _15670 = _16325.xyz + (_18225.xyz * _21549.xyz);
	                break;
	            } while(false);
	            _13145 = _13212;
	            _16325 = _15670;
	            _17018 = _20344;
	            continue;
	        }
	        _21567 = _17017 + 1u;
	        _13144 = _13145;
	        _16324 = _16325;
	        _17017 = _21567;
	        continue;
	    }
	    float _17172 = dot(_21818.xy, vec2(0.5));
	    vec3 _7507 = _17892.xyz;
	    vec3 _17138 = normalize(_10061.xyz - PerViewConstantBuffer_t._m5.xyz);
	    float _17225 = _17172 * _17172;
	    float _20711 = saturate(1.0 - _17225);
	    vec4 _15343 = (vec4(-1.0, -0.0274999998509883880615234375, -0.572000026702880859375, 0.02199999988079071044921875) * _17172) + vec4(1.0, 0.0425000004470348358154296875, 1.03999996185302734375, -0.039999999105930328369140625);
	    float _21215 = _15343.x;
	    vec2 _24572 = (vec2(-1.03999996185302734375, 1.03999996185302734375) * ((min(_21215 * _21215, exp2((-9.27999973297119140625) * max(0.0, dot((-_17138).xyz, _7507)))) * _21215) + _15343.y)) + _15343.zw;
	    float _20339 = _24572.y;
	    vec2 _11427 = vec2(_20339, _24572.x + _20339);
	    vec3 _8745 = vec3(dot(PerViewLightingConstantBufferGpu_t._m0._m0[0].xyzw, _23875), dot(PerViewLightingConstantBufferGpu_t._m0._m0[1].xyzw, _23875), dot(PerViewLightingConstantBufferGpu_t._m0._m0[2].xyzw, _23875)).xyz;
	    vec3 _16991 = _16324.xyz + _8745;
	    vec3 _9666 = _8745 * vec3(_21714 * _17123).xyz;
	    vec3 _13436 = vec3(_17123 * _21714).xyz;
	    vec3 _20579;
	    if (_9090 > 0.0)
	    {
	        _20579 = mix(_9666, pow(_9666, vec3(1.0499999523162841796875, 0.949999988079071044921875, 0.800000011920928955078125)), vec3(_9090));
	    }
	    else
	    {
	        _20579 = _9666;
	    }
	    vec3 _22686 = (_16324.xyz + _20579.xyz) * (_13142.xyz * (1.0 - _23299.w)).xyz;
	    float _12931 = _22686.x;
	    vec4 _11203 = vec4(_12931, _22686.yz, input_5.w);
	    _11203.x = _12931;
	    _11203.y = _22686.y;
	    _11203.z = _22686.z;
	    vec3 _15753 = _11203.xyz + (_13144.xyz * _13436).xyz;
	    vec4 _20497 = _11203;
	    _20497.x = _15753.x;
	    _20497.y = _15753.y;
	    _20497.z = _15753.z;
	    vec3 _15734 = _20497.xyz + ((((mix(_11427.xxx, _11427.yyy, _9453) * textureLod(samplerCubeArray(g_bindless_TextureCubeArray_float4[PerViewConstantBufferCsgo_t._m6], undetermined[_Globals_.g_sTrilinearClamp]), vec4(normalize(mix(_7507, reflect(_17138.xyz, _17892.xyz).xyz, vec3(_20711 * (sqrt(_20711) + _17225)))), 0.0), PerViewLightingConstantBufferGpu_t._m8.y * sqrt(_17172)).xyz).xyz * (normalize(_16991 + vec3(0.001000000047497451305389404296875)) * clamp(length(_16991), 0.0, 1.75))).xyz * (vec3(1.0) + (normalize(_8745 + vec3(0.001000000047497451305389404296875)) * 0.5))).xyz * _13436).xyz;
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
	                _19341 = mix(_23944.xyz, vec4((textureLod(samplerCube(g_bindless_TextureCube_float4[PerViewConstantBufferCsgo_t._m2], undetermined[_Globals_.g_sTrilinearClamp]), normalize((mat4(vec4(PerViewConstantBufferCsgo_t._m22._m0[0].x, PerViewConstantBufferCsgo_t._m22._m0[1].x, PerViewConstantBufferCsgo_t._m22._m0[2].x, PerViewConstantBufferCsgo_t._m22._m0[3].x), vec4(PerViewConstantBufferCsgo_t._m22._m0[0].y, PerViewConstantBufferCsgo_t._m22._m0[1].y, PerViewConstantBufferCsgo_t._m22._m0[2].y, PerViewConstantBufferCsgo_t._m22._m0[3].y), vec4(PerViewConstantBufferCsgo_t._m22._m0[0].z, PerViewConstantBufferCsgo_t._m22._m0[1].z, PerViewConstantBufferCsgo_t._m22._m0[2].z, PerViewConstantBufferCsgo_t._m22._m0[3].z), vec4(PerViewConstantBufferCsgo_t._m22._m0[0].w, PerViewConstantBufferCsgo_t._m22._m0[1].w, PerViewConstantBufferCsgo_t._m22._m0[2].w, PerViewConstantBufferCsgo_t._m22._m0[3].w)) * vec4(_9057, 0.0)).xyz).xyz, PerViewConstantBufferCsgo_t._m21.w * clamp(1.0 - (_14602 * PerViewConstantBufferCsgo_t._m20.z), 0.0, 1.0)) * PerViewConstantBufferCsgo_t._m24.x).xyz, _8892).xyz, vec3(_8892));
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
	BoolAttribute(HasTexcoordTransform, (((g_vTexCoordScale1.x!=1) || (g_vTexCoordScale1.y!=1)) || (g_flTexCoordRotation1!=0)) || 0);
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
	#endif
	
	// SPIR-V reflection failed for backend HLSL:
	// Unsupported builtin in HLSL: 5326
	// 
	// Re-attempting reflection with the GLSL backend.
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (107112 bytes), GLSL reflection with SPIRV-Cross by KhronosGroup
	
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
	    vec3 vColorBlendValues;
	    vec2 _m1;
	    vec2 _m2;
	    vec3 _m3;
	    vec4 _m4;
	    uvec4 _m5;
	    uint _m6;
	    vec4 _m7;
	    vec4 _m8;
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
	
	struct _RTX_MATERIAL_DATA_
	{
	    vec2 _g_fl_AutoPad19_;
	    float _m1;
	    float _m2;
	    vec2 _m3;
	    float _m4;
	    float _m5;
	    vec4 _m6;
	    float _m7;
	    float _m8;
	    float _m9;
	    float _m10;
	    vec4 _m11;
	    vec2 _m12;
	    vec2 _m13;
	    float _m14;
	    float _m15;
	    vec2 _m16;
	    vec4 _m17;
	    vec4 _m18;
	    vec2 _m19;
	    int _m20;
	    int _m21;
	    bool _m22;
	    float _m23;
	    float _m24;
	    float _m25;
	    vec4 _m26;
	    vec4 _m27;
	    vec3 _m28;
	    float _m29;
	    bool _m30;
	    float _m31;
	    float _m32;
	    float _m33;
	    vec3 _m34;
	    float _m35;
	    float _m36;
	    bool _m37;
	    int _m38;
	    float _m39;
	    vec2 _m40;
	    vec2 _m41;
	    float _m42;
	    float _m43;
	    vec2 _m44;
	    vec4 _m45;
	    vec4 _m46;
	    vec4 _m47;
	    float _m48;
	    int _m49;
	    vec2 _m50;
	    vec2 _m51;
	    float _m52;
	    float _m53;
	    vec2 _m54;
	    float _m55;
	    float _m56;
	    vec4 _m57;
	    vec4 _m58;
	    vec4 _m59;
	    uint _m60;
	    uint _m61;
	    uint _m62;
	    float _m63;
	    mat4 _m64;
	    mat4 _m65;
	    float _m66;
	    bool _m67;
	    bool _m68;
	    float _m69;
	    float _m70;
	    float _m71;
	    float _m72;
	    float _m73;
	    vec3 _m74;
	    float _m75;
	    float _m76;
	    float _m77;
	    float _m78;
	    float _m79;
	    float _m80;
	    float _m81;
	    float _m82;
	    float _m83;
	    float _m84;
	    uint _m85;
	    uint _m86;
	    uint _m87;
	    uint _m88;
	    uint _m89;
	    int _m90;
	    int _m91;
	    uint _m92;
	    uint _m93;
	    uint _m94;
	    bool _m95;
	    bool _m96;
	    bool _m97;
	    float _m98;
	    uint _m99;
	    float _m100;
	    float _m101;
	    bool _m102;
	    float _m103;
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
	
	const vec3 _417[3] = vec3[](vec3(-1.0, 0.0, 0.0), vec3(0.0, 1.0, 0.0), vec3(-1.0, 0.0, 0.0));
	const vec3 _421[3] = vec3[](vec3(0.0, 0.0, 1.0), vec3(0.0, -1.0, 0.0), vec3(0.0, 0.0, 1.0));
	
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
	
	vec4 _472;
	float _473;
	
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
	    int _m0[];
	} g_MaterialData_3;
	
	layout(set = 3, binding = 34, std430) readonly buffer g_MaterialData_4
	{
	    int _m0[];
	} g_MaterialData_5;
	
	layout(set = 3, binding = 34, std430) readonly buffer g_MaterialData_6
	{
	    uint _m0[];
	} g_MaterialData_7;
	
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
	
	hitAttributeEXT BuiltInTriangleIntersectionAttributes _22;
	layout(set = 4, binding = 46) uniform texture2D g_bindless_Texture2D_float4[65536];
	layout(set = 4, binding = 29) uniform sampler g_bindless_Sampler[2048];
	layout(location = 0) rayPayloadInEXT Payload_t _21;
	
	void main()
	{
	    _RTX_MATERIAL_DATA_ _1526 = _RTX_MATERIAL_DATA_(vec2(g_MaterialData_1._m0[g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 4u) / 4u]), g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 8u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 12u) / 4u], vec2(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 16u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 20u) / 4u]), g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 24u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 28u) / 4u], vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 32u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 36u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 40u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 44u) / 4u]), g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 48u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 52u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 56u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 60u) / 4u], vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 64u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 68u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 72u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 76u) / 4u]), vec2(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 80u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 84u) / 4u]), vec2(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 88u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 92u) / 4u]), g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 96u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 100u) / 4u], vec2(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 104u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 108u) / 4u]), vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 112u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 116u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 120u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 124u) / 4u]), vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 128u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 132u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 136u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 140u) / 4u]), vec2(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 144u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 148u) / 4u]), g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 152u) / 4u], g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 156u) / 4u], g_MaterialData_5._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 160u) / 4u] != 0, g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 164u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 168u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 172u) / 4u], vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 176u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 180u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 184u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 188u) / 4u]), vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 192u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 196u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 200u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 204u) / 4u]), vec3(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 208u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 212u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 216u) / 4u]), g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 220u) / 4u], g_MaterialData_5._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 224u) / 4u] != 0, g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 228u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 232u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 236u) / 4u], vec3(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 240u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 244u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 248u) / 4u]), g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 252u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 256u) / 4u], g_MaterialData_5._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 260u) / 4u] != 0, g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 264u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 268u) / 4u], vec2(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 272u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 276u) / 4u]), vec2(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 280u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 284u) / 4u]), g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 288u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 292u) / 4u], vec2(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 296u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 300u) / 4u]), vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 304u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 308u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 312u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 316u) / 4u]), vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 320u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 324u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 328u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 332u) / 4u]), vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 336u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 340u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 344u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 348u) / 4u]), g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 352u) / 4u], g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 356u) / 4u], vec2(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 360u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 364u) / 4u]), vec2(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 368u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 372u) / 4u]), g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 376u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 380u) / 4u], vec2(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 384u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 388u) / 4u]), g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 392u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 396u) / 4u], vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 400u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 404u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 408u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 412u) / 4u]), vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 416u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 420u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 424u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 428u) / 4u]), vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 432u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 436u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 440u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 444u) / 4u]), g_MaterialData_7._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 448u) / 4u], g_MaterialData_7._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 452u) / 4u], g_MaterialData_7._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 456u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 460u) / 4u], mat4(vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 464u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 480u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 496u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 512u) / 4u]), vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 468u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 484u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 500u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 516u) / 4u]), vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 472u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 488u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 504u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 520u) / 4u]), vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 476u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 492u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 508u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 524u) / 4u])), mat4(vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 528u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 544u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 560u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 576u) / 4u]), vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 532u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 548u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 564u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 580u) / 4u]), vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 536u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 552u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 568u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 584u) / 4u]), vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 540u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 556u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 572u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 588u) / 4u])), g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 592u) / 4u], g_MaterialData_5._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 596u) / 4u] != 0, g_MaterialData_5._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 600u) / 4u] != 0, g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 604u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 608u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 612u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 616u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 620u) / 4u], vec3(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 624u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 628u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 632u) / 4u]), g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 636u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 640u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 644u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 648u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 652u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 656u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 660u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 664u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 668u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 672u) / 4u], g_MaterialData_7._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 676u) / 4u], g_MaterialData_7._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 680u) / 4u], g_MaterialData_7._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 684u) / 4u], g_MaterialData_7._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 688u) / 4u], g_MaterialData_7._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 692u) / 4u], g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 696u) / 4u], g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 700u) / 4u], g_MaterialData_7._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 704u) / 4u], g_MaterialData_7._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 708u) / 4u], g_MaterialData_7._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 712u) / 4u], g_MaterialData_5._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 716u) / 4u] != 0, g_MaterialData_5._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 720u) / 4u] != 0, g_MaterialData_5._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 724u) / 4u] != 0, g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 728u) / 4u], g_MaterialData_7._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 732u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 736u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 740u) / 4u], g_MaterialData_5._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 744u) / 4u] != 0, g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 748u) / 4u]);
	    _RTX_MATERIAL_DATA_ _g_rtx_material_data_ = _1526;
	    uvec3 _717;
	    do
	    {
	        if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes.w == 4)
	        {
	            uint _1587 = (12u * uint(gl_PrimitiveID)) + uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes.w);
	            _717 = uvec3(g_Indices_1[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._m0[_1587 / 4u], g_Indices_1[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._m0[(_1587 + 4u) / 4u], g_Indices_1[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._m0[(_1587 + 8u) / 4u]);
	            break;
	        }
	        else
	        {
	            uint _1562 = (6u * uint(gl_PrimitiveID)) + uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes.w);
	            uint _1563 = _1562 & 4294967292u;
	            uint _1564 = _1563 / 4u;
	            uint _1568 = (_1563 + 4u) / 4u;
	            uint _1573 = (g_Indices_1[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._m0[_1564] & 4294901760u) >> uint(16);
	            uint _1574 = g_Indices_1[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._m0[_1568] & 65535u;
	            uvec3 _718;
	            if (_1562 == _1563)
	            {
	                _718 = uvec3(g_Indices_1[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._m0[_1564] & 65535u, _1573, _1574);
	            }
	            else
	            {
	                _718 = uvec3(_1573, _1574, (g_Indices_1[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._m0[_1568] & 4294901760u) >> uint(16));
	            }
	            _717 = _718;
	            break;
	        }
	        break;
	    } while(false);
	    uint _1602 = uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.x);
	    uvec3 _1610 = (uvec3(uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes.x)) * _717) + uvec3(uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes.x));
	    vec3 _711[3];
	    uint _1612 = _1610.x;
	    _711[0] = vec3(g_Vertices_1[_1602]._m0[_1612 / 4u], g_Vertices_1[_1602]._m0[(_1612 + 4u) / 4u], g_Vertices_1[_1602]._m0[(_1612 + 8u) / 4u]);
	    uint _1626 = _1610.y;
	    _711[1] = vec3(g_Vertices_1[_1602]._m0[_1626 / 4u], g_Vertices_1[_1602]._m0[(_1626 + 4u) / 4u], g_Vertices_1[_1602]._m0[(_1626 + 8u) / 4u]);
	    uint _1640 = _1610.z;
	    _711[2] = vec3(g_Vertices_1[_1602]._m0[_1640 / 4u], g_Vertices_1[_1602]._m0[(_1640 + 4u) / 4u], g_Vertices_1[_1602]._m0[(_1640 + 8u) / 4u]);
	    int _712 = 0;
	    VS_INPUT vsInput[3];
	    for (;;)
	    {
	        if (!(_712 < 3))
	        {
	            break;
	        }
	        vsInput[_712].vColorBlendValues = _711[_712];
	        _712++;
	        continue;
	    }
	    vec2 _713[3];
	    _713[0] = vec2(0.0);
	    _713[1] = vec2(0.0);
	    _713[2] = vec2(0.0);
	    if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].y != 0)
	    {
	        ivec4 _710 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers;
	        uint _1683 = uint(_710[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].z]);
	        uint _1685 = uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].z);
	        ivec4 _708 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes;
	        ivec4 _709 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes;
	        uvec3 _1696 = (uvec3(uint(_708[_1685])) * _717) + uvec3(uint(_709[_1685]) + uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].x));
	        if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].y == 16)
	        {
	            uint _1831 = _1696.x;
	            _713[0] = vec2(g_Vertices_1[_1683]._m0[_1831 / 4u], g_Vertices_1[_1683]._m0[(_1831 + 4u) / 4u]);
	            uint _1840 = _1696.y;
	            _713[1] = vec2(g_Vertices_1[_1683]._m0[_1840 / 4u], g_Vertices_1[_1683]._m0[(_1840 + 4u) / 4u]);
	            uint _1849 = _1696.z;
	            _713[2] = vec2(g_Vertices_1[_1683]._m0[_1849 / 4u], g_Vertices_1[_1683]._m0[(_1849 + 4u) / 4u]);
	        }
	        else
	        {
	            if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].y == 34)
	            {
	                uint _1802 = _1696.x / 4u;
	                _713[0] = vec2(uint16BitsToFloat16(u16vec2(uvec2(g_Vertices_3[_1683]._m0[_1802], g_Vertices_3[_1683]._m0[_1802] >> uint(16)) & uvec2(65535u))));
	                uint _1812 = _1696.y / 4u;
	                _713[1] = vec2(uint16BitsToFloat16(u16vec2(uvec2(g_Vertices_3[_1683]._m0[_1812], g_Vertices_3[_1683]._m0[_1812] >> uint(16)) & uvec2(65535u))));
	                uint _1822 = _1696.z / 4u;
	                _713[2] = vec2(uint16BitsToFloat16(u16vec2(uvec2(g_Vertices_3[_1683]._m0[_1822], g_Vertices_3[_1683]._m0[_1822] >> uint(16)) & uvec2(65535u))));
	            }
	            else
	            {
	                if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].y == 37)
	                {
	                    uint _1709 = _1696.x / 4u;
	                    uint _1713 = (g_Vertices_3[_1683]._m0[_1709] & 65535u);
	                    int _707;
	                    if (_1713 > 32767u)
	                    {
	                        _707 = int(4294901760u | _1713);
	                    }
	                    else
	                    {
	                        _707 = int(_1713);
	                    }
	                    uint _1726 = (g_Vertices_3[_1683]._m0[_1709] & 4294901760u) >> uint(16);
	                    int _706;
	                    if (_1726 > 32767u)
	                    {
	                        _706 = int(4294901760u | _1726);
	                    }
	                    else
	                    {
	                        _706 = int(_1726);
	                    }
	                    _713[0] = vec2(max(float(_707) * 3.0518509447574615478515625e-05, -1.0), max(float(_706) * 3.0518509447574615478515625e-05, -1.0));
	                    uint _1740 = _1696.y / 4u;
	                    uint _1744 = (g_Vertices_3[_1683]._m0[_1740] & 65535u);
	                    int _705;
	                    if (_1744 > 32767u)
	                    {
	                        _705 = int(4294901760u | _1744);
	                    }
	                    else
	                    {
	                        _705 = int(_1744);
	                    }
	                    uint _1757 = (g_Vertices_3[_1683]._m0[_1740] & 4294901760u) >> uint(16);
	                    int _704;
	                    if (_1757 > 32767u)
	                    {
	                        _704 = int(4294901760u | _1757);
	                    }
	                    else
	                    {
	                        _704 = int(_1757);
	                    }
	                    _713[1] = vec2(max(float(_705) * 3.0518509447574615478515625e-05, -1.0), max(float(_704) * 3.0518509447574615478515625e-05, -1.0));
	                    uint _1771 = _1696.z / 4u;
	                    uint _1775 = (g_Vertices_3[_1683]._m0[_1771] & 65535u);
	                    int _703;
	                    if (_1775 > 32767u)
	                    {
	                        _703 = int(4294901760u | _1775);
	                    }
	                    else
	                    {
	                        _703 = int(_1775);
	                    }
	                    uint _1788 = (g_Vertices_3[_1683]._m0[_1771] & 4294901760u) >> uint(16);
	                    int _702;
	                    if (_1788 > 32767u)
	                    {
	                        _702 = int(4294901760u | _1788);
	                    }
	                    else
	                    {
	                        _702 = int(_1788);
	                    }
	                    _713[2] = vec2(max(float(_703) * 3.0518509447574615478515625e-05, -1.0), max(float(_702) * 3.0518509447574615478515625e-05, -1.0));
	                }
	            }
	        }
	    }
	    _712 = 0;
	    for (;;)
	    {
	        if (!(_712 < 3))
	        {
	            break;
	        }
	        vsInput[_712]._m1 = _713[_712];
	        _712++;
	        continue;
	    }
	    _713[0] = vec2(0.0);
	    _713[1] = vec2(0.0);
	    _713[2] = vec2(0.0);
	    if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[1].y != 0)
	    {
	        ivec4 _701 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers;
	        uint _1888 = uint(_701[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[1].z]);
	        uint _1890 = uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[1].z);
	        ivec4 _699 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes;
	        ivec4 _700 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes;
	        uvec3 _1901 = (uvec3(uint(_699[_1890])) * _717) + uvec3(uint(_700[_1890]) + uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[1].x));
	        if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[1].y == 16)
	        {
	            uint _2036 = _1901.x;
	            _713[0] = vec2(g_Vertices_1[_1888]._m0[_2036 / 4u], g_Vertices_1[_1888]._m0[(_2036 + 4u) / 4u]);
	            uint _2045 = _1901.y;
	            _713[1] = vec2(g_Vertices_1[_1888]._m0[_2045 / 4u], g_Vertices_1[_1888]._m0[(_2045 + 4u) / 4u]);
	            uint _2054 = _1901.z;
	            _713[2] = vec2(g_Vertices_1[_1888]._m0[_2054 / 4u], g_Vertices_1[_1888]._m0[(_2054 + 4u) / 4u]);
	        }
	        else
	        {
	            if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[1].y == 34)
	            {
	                uint _2007 = _1901.x / 4u;
	                _713[0] = vec2(uint16BitsToFloat16(u16vec2(uvec2(g_Vertices_3[_1888]._m0[_2007], g_Vertices_3[_1888]._m0[_2007] >> uint(16)) & uvec2(65535u))));
	                uint _2017 = _1901.y / 4u;
	                _713[1] = vec2(uint16BitsToFloat16(u16vec2(uvec2(g_Vertices_3[_1888]._m0[_2017], g_Vertices_3[_1888]._m0[_2017] >> uint(16)) & uvec2(65535u))));
	                uint _2027 = _1901.z / 4u;
	                _713[2] = vec2(uint16BitsToFloat16(u16vec2(uvec2(g_Vertices_3[_1888]._m0[_2027], g_Vertices_3[_1888]._m0[_2027] >> uint(16)) & uvec2(65535u))));
	            }
	            else
	            {
	                if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[1].y == 37)
	                {
	                    uint _1914 = _1901.x / 4u;
	                    uint _1918 = (g_Vertices_3[_1888]._m0[_1914] & 65535u);
	                    int _698;
	                    if (_1918 > 32767u)
	                    {
	                        _698 = int(4294901760u | _1918);
	                    }
	                    else
	                    {
	                        _698 = int(_1918);
	                    }
	                    uint _1931 = (g_Vertices_3[_1888]._m0[_1914] & 4294901760u) >> uint(16);
	                    int _697;
	                    if (_1931 > 32767u)
	                    {
	                        _697 = int(4294901760u | _1931);
	                    }
	                    else
	                    {
	                        _697 = int(_1931);
	                    }
	                    _713[0] = vec2(max(float(_698) * 3.0518509447574615478515625e-05, -1.0), max(float(_697) * 3.0518509447574615478515625e-05, -1.0));
	                    uint _1945 = _1901.y / 4u;
	                    uint _1949 = (g_Vertices_3[_1888]._m0[_1945] & 65535u);
	                    int _696;
	                    if (_1949 > 32767u)
	                    {
	                        _696 = int(4294901760u | _1949);
	                    }
	                    else
	                    {
	                        _696 = int(_1949);
	                    }
	                    uint _1962 = (g_Vertices_3[_1888]._m0[_1945] & 4294901760u) >> uint(16);
	                    int _695;
	                    if (_1962 > 32767u)
	                    {
	                        _695 = int(4294901760u | _1962);
	                    }
	                    else
	                    {
	                        _695 = int(_1962);
	                    }
	                    _713[1] = vec2(max(float(_696) * 3.0518509447574615478515625e-05, -1.0), max(float(_695) * 3.0518509447574615478515625e-05, -1.0));
	                    uint _1976 = _1901.z / 4u;
	                    uint _1980 = (g_Vertices_3[_1888]._m0[_1976] & 65535u);
	                    int _694;
	                    if (_1980 > 32767u)
	                    {
	                        _694 = int(4294901760u | _1980);
	                    }
	                    else
	                    {
	                        _694 = int(_1980);
	                    }
	                    uint _1993 = (g_Vertices_3[_1888]._m0[_1976] & 4294901760u) >> uint(16);
	                    int _693;
	                    if (_1993 > 32767u)
	                    {
	                        _693 = int(4294901760u | _1993);
	                    }
	                    else
	                    {
	                        _693 = int(_1993);
	                    }
	                    _713[2] = vec2(max(float(_694) * 3.0518509447574615478515625e-05, -1.0), max(float(_693) * 3.0518509447574615478515625e-05, -1.0));
	                }
	            }
	        }
	    }
	    _712 = 0;
	    for (;;)
	    {
	        if (!(_712 < 3))
	        {
	            break;
	        }
	        vsInput[_712]._m2 = _713[_712];
	        _712++;
	        continue;
	    }
	    vec3 _714[3];
	    vec4 _715[3];
	    do
	    {
	        if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.y != 0)
	        {
	            ivec4 _679 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers;
	            uint _2096 = uint(_679[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.z]);
	            uint _2098 = uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.z);
	            ivec4 _677 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes;
	            ivec4 _678 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes;
	            uvec3 _2109 = (uvec3(uint(_677[_2098])) * _717) + uvec3(uint(_678[_2098]) + uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.x));
	            if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.y == 6)
	            {
	                uint _2640 = _2109.x;
	                _714[0] = vec3(g_Vertices_1[_2096]._m0[_2640 / 4u], g_Vertices_1[_2096]._m0[(_2640 + 4u) / 4u], g_Vertices_1[_2096]._m0[(_2640 + 8u) / 4u]);
	                uint _2654 = _2109.y;
	                _714[1] = vec3(g_Vertices_1[_2096]._m0[_2654 / 4u], g_Vertices_1[_2096]._m0[(_2654 + 4u) / 4u], g_Vertices_1[_2096]._m0[(_2654 + 8u) / 4u]);
	                uint _2668 = _2109.z;
	                _714[2] = vec3(g_Vertices_1[_2096]._m0[_2668 / 4u], g_Vertices_1[_2096]._m0[(_2668 + 4u) / 4u], g_Vertices_1[_2096]._m0[(_2668 + 8u) / 4u]);
	            }
	            else
	            {
	                if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.y == 17)
	                {
	                    uint _2373 = _2109.x;
	                    uvec2 _2381 = uvec2(g_Vertices_3[_2096]._m0[_2373 / 4u], g_Vertices_3[_2096]._m0[(_2373 + 4u) / 4u]);
	                    uint _2382 = _2109.y;
	                    uvec2 _493 = uvec2(g_Vertices_3[_2096]._m0[_2382 / 4u], g_Vertices_3[_2096]._m0[(_2382 + 4u) / 4u]);
	                    uint _2391 = _2109.z;
	                    uvec2 _492 = uvec2(g_Vertices_3[_2096]._m0[_2391 / 4u], g_Vertices_3[_2096]._m0[(_2391 + 4u) / 4u]);
	                    uint _2403 = _2381.x;
	                    uint _2412 = _2381.y;
	                    vec2 _2422 = ((vec2(float((_2403) & 65535u), float((_2403 >> 16u) & 65535u)) * vec2(1.525902189314365386962890625e-05)) * 2.0) - vec2(1.0);
	                    float _2423 = _2422.x;
	                    float _2428 = (1.0 - abs(_2423)) - abs(_2422.y);
	                    vec3 _2429 = vec3(_2423, _2422.y, _2428);
	                    float _2431 = saturate(-_2428);
	                    vec2 _2437 = _2422 + mix(vec2(_2431), vec2(-_2431), greaterThanEqual(_2422, vec2(0.0)));
	                    _2429.x = _2437.x;
	                    _2429.y = _2437.y;
	                    vec3 _687 = normalize(_2429);
	                    vec2 _2444 = ((vec2(float((_2412 >> uint(1)) & 32767u), float((_2412 >> 16u) & 32767u)) * vec2(3.0518509447574615478515625e-05)) * 2.0) - vec2(1.0);
	                    float _2445 = _2444.x;
	                    float _2450 = (1.0 - abs(_2445)) - abs(_2444.y);
	                    vec3 _2451 = vec3(_2445, _2444.y, _2450);
	                    float _2453 = saturate(-_2450);
	                    vec2 _2459 = _2444 + mix(vec2(_2453), vec2(-_2453), greaterThanEqual(_2444, vec2(0.0)));
	                    _2451.x = _2459.x;
	                    _2451.y = _2459.y;
	                    vec3 _686 = normalize(_2451);
	                    float _667;
	                    if ((_2412 & 1u) != 0u)
	                    {
	                        _667 = 1.0;
	                    }
	                    else
	                    {
	                        _667 = -1.0;
	                    }
	                    _714[0] = _687;
	                    _715[0].w = _667;
	                    _715[0].x = _686.x;
	                    _715[0].y = _686.y;
	                    _715[0].z = _686.z;
	                    vec2 _2502 = ((vec2(float((_493.x) & 65535u), float((_493.x >> 16u) & 65535u)) * vec2(1.525902189314365386962890625e-05)) * 2.0) - vec2(1.0);
	                    float _2503 = _2502.x;
	                    float _2508 = (1.0 - abs(_2503)) - abs(_2502.y);
	                    vec3 _2509 = vec3(_2503, _2502.y, _2508);
	                    float _2511 = saturate(-_2508);
	                    vec2 _2517 = _2502 + mix(vec2(_2511), vec2(-_2511), greaterThanEqual(_2502, vec2(0.0)));
	                    _2509.x = _2517.x;
	                    _2509.y = _2517.y;
	                    vec3 _689 = normalize(_2509);
	                    vec2 _2524 = ((vec2(float((_493.y >> uint(1)) & 32767u), float((_493.y >> 16u) & 32767u)) * vec2(3.0518509447574615478515625e-05)) * 2.0) - vec2(1.0);
	                    float _2525 = _2524.x;
	                    float _2530 = (1.0 - abs(_2525)) - abs(_2524.y);
	                    vec3 _2531 = vec3(_2525, _2524.y, _2530);
	                    float _2533 = saturate(-_2530);
	                    vec2 _2539 = _2524 + mix(vec2(_2533), vec2(-_2533), greaterThanEqual(_2524, vec2(0.0)));
	                    _2531.x = _2539.x;
	                    _2531.y = _2539.y;
	                    vec3 _688 = normalize(_2531);
	                    float _666;
	                    if ((_493.y & 1u) != 0u)
	                    {
	                        _666 = 1.0;
	                    }
	                    else
	                    {
	                        _666 = -1.0;
	                    }
	                    _714[1] = _689;
	                    _715[1].w = _666;
	                    _715[1].x = _688.x;
	                    _715[1].y = _688.y;
	                    _715[1].z = _688.z;
	                    vec2 _2582 = ((vec2(float((_492.x) & 65535u), float((_492.x >> 16u) & 65535u)) * vec2(1.525902189314365386962890625e-05)) * 2.0) - vec2(1.0);
	                    float _2583 = _2582.x;
	                    float _2588 = (1.0 - abs(_2583)) - abs(_2582.y);
	                    vec3 _2589 = vec3(_2583, _2582.y, _2588);
	                    float _2591 = saturate(-_2588);
	                    vec2 _2597 = _2582 + mix(vec2(_2591), vec2(-_2591), greaterThanEqual(_2582, vec2(0.0)));
	                    _2589.x = _2597.x;
	                    _2589.y = _2597.y;
	                    vec3 _691 = normalize(_2589);
	                    vec2 _2604 = ((vec2(float((_492.y >> uint(1)) & 32767u), float((_492.y >> 16u) & 32767u)) * vec2(3.0518509447574615478515625e-05)) * 2.0) - vec2(1.0);
	                    float _2605 = _2604.x;
	                    float _2610 = (1.0 - abs(_2605)) - abs(_2604.y);
	                    vec3 _2611 = vec3(_2605, _2604.y, _2610);
	                    float _2613 = saturate(-_2610);
	                    vec2 _2619 = _2604 + mix(vec2(_2613), vec2(-_2613), greaterThanEqual(_2604, vec2(0.0)));
	                    _2611.x = _2619.x;
	                    _2611.y = _2619.y;
	                    vec3 _690 = normalize(_2611);
	                    float _665;
	                    if ((_492.y & 1u) != 0u)
	                    {
	                        _665 = 1.0;
	                    }
	                    else
	                    {
	                        _665 = -1.0;
	                    }
	                    _714[2] = _691;
	                    _715[2].w = _665;
	                    _715[2].x = _690.x;
	                    _715[2].y = _690.y;
	                    _715[2].z = _690.z;
	                    break;
	                }
	                else
	                {
	                    uint _2119 = _2109.x / 4u;
	                    vec4 _681 = _715[0];
	                    float _2134 = (float((g_Vertices_3[_2096]._m0[_2119] >> 12u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _2137 = (float((g_Vertices_3[_2096]._m0[_2119] >> 22u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _2141 = (1.0 - abs(_2134)) - abs(_2137);
	                    vec3 _2142 = vec3(_2134, _2137, _2141);
	                    float _2144 = saturate(-_2141);
	                    vec2 _2145 = vec2(_2134, _2137);
	                    vec2 _2151 = _2145 + mix(vec2(_2144), vec2(-_2144), greaterThanEqual(_2145, vec2(0.0)));
	                    _2142.x = _2151.x;
	                    _2142.y = _2151.y;
	                    vec3 _2156 = normalize(_2142);
	                    vec3 _680 = _2156;
	                    float _2157 = _2156.z;
	                    float _674;
	                    if (_2157 >= 0.0)
	                    {
	                        _674 = 1.0;
	                    }
	                    else
	                    {
	                        _674 = -1.0;
	                    }
	                    float _2164 = (-1.0) / (_674 + _2157);
	                    float _2165 = _2156.x;
	                    vec3 _675;
	                    vec3 _2173 = _675;
	                    _2173.x = 1.0 + (((_674 * _2165) * _2165) * _2164);
	                    _2173.y = _674 * ((_2165 * _2156.y) * _2164);
	                    _2173.z = (-_674) * _2165;
	                    _675 = _2173;
	                    float _2181 = float((g_Vertices_3[_2096]._m0[_2119] >> uint(1)) & 2047u) * 0.003069460391998291015625;
	                    vec3 _2187 = (_2173 * cos(_2181)) + (cross(_2156, _2173) * sin(_2181));
	                    vec4 _2189 = _681;
	                    _2189.x = _2187.x;
	                    _2189.y = _2187.y;
	                    _2189.z = _2187.z;
	                    _681 = _2189;
	                    float _676;
	                    if ((g_Vertices_3[_2096]._m0[_2119] & 1u) == 0u)
	                    {
	                        _676 = -1.0;
	                    }
	                    else
	                    {
	                        _676 = 1.0;
	                    }
	                    vec4 _2200 = _681;
	                    _2200.w = _676;
	                    _681 = _2200;
	                    _714[0] = _680;
	                    _715[0] = _2200;
	                    uint _2204 = _2109.y / 4u;
	                    vec4 _683 = _715[1];
	                    float _2219 = (float((g_Vertices_3[_2096]._m0[_2204] >> 12u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _2222 = (float((g_Vertices_3[_2096]._m0[_2204] >> 22u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _2226 = (1.0 - abs(_2219)) - abs(_2222);
	                    vec3 _2227 = vec3(_2219, _2222, _2226);
	                    float _2229 = saturate(-_2226);
	                    vec2 _2230 = vec2(_2219, _2222);
	                    vec2 _2236 = _2230 + mix(vec2(_2229), vec2(-_2229), greaterThanEqual(_2230, vec2(0.0)));
	                    _2227.x = _2236.x;
	                    _2227.y = _2236.y;
	                    vec3 _2241 = normalize(_2227);
	                    vec3 _682 = _2241;
	                    float _2242 = _2241.z;
	                    float _671;
	                    if (_2242 >= 0.0)
	                    {
	                        _671 = 1.0;
	                    }
	                    else
	                    {
	                        _671 = -1.0;
	                    }
	                    float _2249 = (-1.0) / (_671 + _2242);
	                    float _2250 = _2241.x;
	                    vec3 _672;
	                    vec3 _2258 = _672;
	                    _2258.x = 1.0 + (((_671 * _2250) * _2250) * _2249);
	                    _2258.y = _671 * ((_2250 * _2241.y) * _2249);
	                    _2258.z = (-_671) * _2250;
	                    _672 = _2258;
	                    float _2266 = float((g_Vertices_3[_2096]._m0[_2204] >> uint(1)) & 2047u) * 0.003069460391998291015625;
	                    vec3 _2272 = (_2258 * cos(_2266)) + (cross(_2241, _2258) * sin(_2266));
	                    vec4 _2274 = _683;
	                    _2274.x = _2272.x;
	                    _2274.y = _2272.y;
	                    _2274.z = _2272.z;
	                    _683 = _2274;
	                    float _673;
	                    if ((g_Vertices_3[_2096]._m0[_2204] & 1u) == 0u)
	                    {
	                        _673 = -1.0;
	                    }
	                    else
	                    {
	                        _673 = 1.0;
	                    }
	                    vec4 _2285 = _683;
	                    _2285.w = _673;
	                    _683 = _2285;
	                    _714[1] = _682;
	                    _715[1] = _2285;
	                    uint _2289 = _2109.z / 4u;
	                    vec4 _685 = _715[2];
	                    float _2304 = (float((g_Vertices_3[_2096]._m0[_2289] >> 12u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _2307 = (float((g_Vertices_3[_2096]._m0[_2289] >> 22u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _2311 = (1.0 - abs(_2304)) - abs(_2307);
	                    vec3 _2312 = vec3(_2304, _2307, _2311);
	                    float _2314 = saturate(-_2311);
	                    vec2 _2315 = vec2(_2304, _2307);
	                    vec2 _2321 = _2315 + mix(vec2(_2314), vec2(-_2314), greaterThanEqual(_2315, vec2(0.0)));
	                    _2312.x = _2321.x;
	                    _2312.y = _2321.y;
	                    vec3 _2326 = normalize(_2312);
	                    vec3 _684 = _2326;
	                    float _2327 = _2326.z;
	                    float _668;
	                    if (_2327 >= 0.0)
	                    {
	                        _668 = 1.0;
	                    }
	                    else
	                    {
	                        _668 = -1.0;
	                    }
	                    float _2334 = (-1.0) / (_668 + _2327);
	                    float _2335 = _2326.x;
	                    vec3 _669;
	                    vec3 _2343 = _669;
	                    _2343.x = 1.0 + (((_668 * _2335) * _2335) * _2334);
	                    _2343.y = _668 * ((_2335 * _2326.y) * _2334);
	                    _2343.z = (-_668) * _2335;
	                    _669 = _2343;
	                    float _2351 = float((g_Vertices_3[_2096]._m0[_2289] >> uint(1)) & 2047u) * 0.003069460391998291015625;
	                    vec3 _2357 = (_2343 * cos(_2351)) + (cross(_2326, _2343) * sin(_2351));
	                    vec4 _2359 = _685;
	                    _2359.x = _2357.x;
	                    _2359.y = _2357.y;
	                    _2359.z = _2357.z;
	                    _685 = _2359;
	                    float _670;
	                    if ((g_Vertices_3[_2096]._m0[_2289] & 1u) == 0u)
	                    {
	                        _670 = -1.0;
	                    }
	                    else
	                    {
	                        _670 = 1.0;
	                    }
	                    vec4 _2370 = _685;
	                    _2370.w = _670;
	                    _685 = _2370;
	                    _714[2] = _684;
	                    _715[2] = _2370;
	                    break;
	                }
	                break;
	            }
	        }
	        else
	        {
	            _714[0] = vec3(0.0);
	            _714[1] = vec3(0.0);
	            _714[2] = vec3(0.0);
	        }
	        if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTangentFieldInfo.y != 0)
	        {
	            ivec4 _692 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers;
	            uint _2693 = uint(_692[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTangentFieldInfo.z]);
	            uint _2695 = uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTangentFieldInfo.z);
	            ivec4 _663 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes;
	            ivec4 _664 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes;
	            uvec3 _2706 = (uvec3(uint(_663[_2695])) * _717) + uvec3(uint(_664[_2695]) + uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTangentFieldInfo.x));
	            uint _2708 = _2706.x;
	            _715[0] = vec4(g_Vertices_1[_2693]._m0[_2708 / 4u], g_Vertices_1[_2693]._m0[(_2708 + 4u) / 4u], g_Vertices_1[_2693]._m0[(_2708 + 8u) / 4u], g_Vertices_1[_2693]._m0[(_2708 + 12u) / 4u]);
	            uint _2726 = _2706.y;
	            _715[1] = vec4(g_Vertices_1[_2693]._m0[_2726 / 4u], g_Vertices_1[_2693]._m0[(_2726 + 4u) / 4u], g_Vertices_1[_2693]._m0[(_2726 + 8u) / 4u], g_Vertices_1[_2693]._m0[(_2726 + 12u) / 4u]);
	            uint _2744 = _2706.z;
	            _715[2] = vec4(g_Vertices_1[_2693]._m0[_2744 / 4u], g_Vertices_1[_2693]._m0[(_2744 + 4u) / 4u], g_Vertices_1[_2693]._m0[(_2744 + 8u) / 4u], g_Vertices_1[_2693]._m0[(_2744 + 12u) / 4u]);
	        }
	        else
	        {
	            _715[0] = vec4(0.0);
	            _715[1] = vec4(0.0);
	            _715[2] = vec4(0.0);
	        }
	        break;
	    } while(false);
	    _712 = 0;
	    for (;;)
	    {
	        if (!(_712 < 3))
	        {
	            break;
	        }
	        vsInput[_712]._m3 = _714[_712];
	        vsInput[_712]._m4 = _715[_712];
	        _712++;
	        continue;
	    }
	    vec4 _716[3];
	    if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vColorFieldInfo.data[0].y != 0)
	    {
	        ivec4 _662 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers;
	        uint _2795 = uint(_662[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vColorFieldInfo.data[0].z]);
	        uint _2797 = uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vColorFieldInfo.data[0].z);
	        ivec4 _660 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes;
	        ivec4 _661 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes;
	        uvec3 _2808 = (uvec3(uint(_660[_2797])) * _717) + uvec3(uint(_661[_2797]) + uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vColorFieldInfo.data[0].x));
	        if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vColorFieldInfo.data[0].y == 2)
	        {
	            uint _2862 = _2808.x;
	            _716[0] = vec4(g_Vertices_1[_2795]._m0[_2862 / 4u], g_Vertices_1[_2795]._m0[(_2862 + 4u) / 4u], g_Vertices_1[_2795]._m0[(_2862 + 8u) / 4u], g_Vertices_1[_2795]._m0[(_2862 + 12u) / 4u]);
	            uint _2880 = _2808.y;
	            _716[1] = vec4(g_Vertices_1[_2795]._m0[_2880 / 4u], g_Vertices_1[_2795]._m0[(_2880 + 4u) / 4u], g_Vertices_1[_2795]._m0[(_2880 + 8u) / 4u], g_Vertices_1[_2795]._m0[(_2880 + 12u) / 4u]);
	            uint _2898 = _2808.z;
	            _716[2] = vec4(g_Vertices_1[_2795]._m0[_2898 / 4u], g_Vertices_1[_2795]._m0[(_2898 + 4u) / 4u], g_Vertices_1[_2795]._m0[(_2898 + 8u) / 4u], g_Vertices_1[_2795]._m0[(_2898 + 12u) / 4u]);
	        }
	        else
	        {
	            uint _2815 = _2808.x / 4u;
	            _716[0] = vec4(uvec4((g_Vertices_3[_2795]._m0[_2815] & 255u), (g_Vertices_3[_2795]._m0[_2815] & 65280u) >> uint(8), (g_Vertices_3[_2795]._m0[_2815] & 16711680u) >> uint(16), (g_Vertices_3[_2795]._m0[_2815] & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	            uint _2831 = _2808.y / 4u;
	            _716[1] = vec4(uvec4((g_Vertices_3[_2795]._m0[_2831] & 255u), (g_Vertices_3[_2795]._m0[_2831] & 65280u) >> uint(8), (g_Vertices_3[_2795]._m0[_2831] & 16711680u) >> uint(16), (g_Vertices_3[_2795]._m0[_2831] & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	            uint _2847 = _2808.z / 4u;
	            _716[2] = vec4(uvec4((g_Vertices_3[_2795]._m0[_2847] & 255u), (g_Vertices_3[_2795]._m0[_2847] & 65280u) >> uint(8), (g_Vertices_3[_2795]._m0[_2847] & 16711680u) >> uint(16), (g_Vertices_3[_2795]._m0[_2847] & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	        }
	    }
	    else
	    {
	        _716[0] = vec4(0.0);
	        _716[1] = vec4(0.0);
	        _716[2] = vec4(0.0);
	    }
	    _712 = 0;
	    for (;;)
	    {
	        if (!(_712 < 3))
	        {
	            break;
	        }
	        vsInput[_712]._m7 = _716[_712];
	        _712++;
	        continue;
	    }
	    vec4 _719[3];
	    _719[0] = vec4(0.0);
	    _719[1] = vec4(0.0);
	    _719[2] = vec4(0.0);
	    if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[4].y != 0)
	    {
	        ivec4 _659 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers;
	        uint _2949 = uint(_659[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[4].z]);
	        uint _2951 = uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[4].z);
	        ivec4 _657 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes;
	        ivec4 _658 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes;
	        uvec3 _2962 = (uvec3(uint(_657[_2951])) * _717) + uvec3(uint(_658[_2951]) + uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[4].x));
	        if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[4].y == 2)
	        {
	            uint _3015 = _2962.x;
	            _719[0] = vec4(g_Vertices_1[_2949]._m0[_3015 / 4u], g_Vertices_1[_2949]._m0[(_3015 + 4u) / 4u], g_Vertices_1[_2949]._m0[(_3015 + 8u) / 4u], g_Vertices_1[_2949]._m0[(_3015 + 12u) / 4u]);
	            uint _3032 = _2962.y;
	            _719[1] = vec4(g_Vertices_1[_2949]._m0[_3032 / 4u], g_Vertices_1[_2949]._m0[(_3032 + 4u) / 4u], g_Vertices_1[_2949]._m0[(_3032 + 8u) / 4u], g_Vertices_1[_2949]._m0[(_3032 + 12u) / 4u]);
	            uint _3049 = _2962.z;
	            _719[2] = vec4(g_Vertices_1[_2949]._m0[_3049 / 4u], g_Vertices_1[_2949]._m0[(_3049 + 4u) / 4u], g_Vertices_1[_2949]._m0[(_3049 + 8u) / 4u], g_Vertices_1[_2949]._m0[(_3049 + 12u) / 4u]);
	        }
	        else
	        {
	            if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[4].y == 28)
	            {
	                uint _2971 = _2962.x / 4u;
	                _719[0] = vec4(uvec4((g_Vertices_3[_2949]._m0[_2971] & 255u), (g_Vertices_3[_2949]._m0[_2971] & 65280u) >> uint(8), (g_Vertices_3[_2949]._m0[_2971] & 16711680u) >> uint(16), (g_Vertices_3[_2949]._m0[_2971] & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	                uint _2986 = _2962.y / 4u;
	                _719[1] = vec4(uvec4((g_Vertices_3[_2949]._m0[_2986] & 255u), (g_Vertices_3[_2949]._m0[_2986] & 65280u) >> uint(8), (g_Vertices_3[_2949]._m0[_2986] & 16711680u) >> uint(16), (g_Vertices_3[_2949]._m0[_2986] & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	                uint _3001 = _2962.z / 4u;
	                _719[2] = vec4(uvec4((g_Vertices_3[_2949]._m0[_3001] & 255u), (g_Vertices_3[_2949]._m0[_3001] & 65280u) >> uint(8), (g_Vertices_3[_2949]._m0[_3001] & 16711680u) >> uint(16), (g_Vertices_3[_2949]._m0[_3001] & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	            }
	        }
	    }
	    int _720 = 0;
	    for (;;)
	    {
	        if (!(_720 < 3))
	        {
	            break;
	        }
	        vsInput[_720]._m8 = _719[_720];
	        _720++;
	        continue;
	    }
	    vec3 _654 = vsInput[0]._m3;
	    vec4 _655;
	    vec4 _3090 = _655;
	    _3090.x = vsInput[0]._m4.x;
	    _3090.y = vsInput[0]._m4.y;
	    _3090.z = vsInput[0]._m4.z;
	    _3090.w = vsInput[0]._m4.w;
	    _655 = _3090;
	    vec4 _3115 = vec4(uvec4((g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 255u), (g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 65280u) >> uint(8), (g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 16711680u) >> uint(16), (g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	    vec4 _653 = _3115;
	    vec3 _3116 = _3115.xyz;
	    vec3 _3117 = _3116 * vec3(0.077399380505084991455078125);
	    vec3 _3120 = pow((_3116 * vec3(0.947867333889007568359375)) + vec3(0.052132703363895416259765625), vec3(2.400000095367431640625));
	    float _650;
	    if (_3115.x <= 0.040449999272823333740234375)
	    {
	        _650 = _3117.x;
	    }
	    else
	    {
	        _650 = _3120.x;
	    }
	    float _651;
	    if (_3115.y <= 0.040449999272823333740234375)
	    {
	        _651 = _3117.y;
	    }
	    else
	    {
	        _651 = _3120.y;
	    }
	    float _652;
	    if (_3115.z <= 0.040449999272823333740234375)
	    {
	        _652 = _3117.z;
	    }
	    else
	    {
	        _652 = _3120.z;
	    }
	    vec3 _3145 = vec3(_650, _651, _652);
	    vec4 _3147 = _653;
	    _3147.x = _3145.x;
	    _3147.y = _3145.y;
	    _3147.z = _3145.z;
	    _653 = _3147;
	    vec4 _510;
	    vec4 _3154 = _510;
	    _3154.x = _3147.x;
	    _3154.y = _3147.y;
	    _3154.z = _3147.z;
	    _3154.w = _3147.w;
	    _510 = _3154;
	    mat3x4 _3165 = transpose(gl_WorldToObjectEXT);
	    mat3 _649;
	    mat3 _3168 = _649;
	    _3168[0] = _3165[0].xyz;
	    _3168[1] = _3165[1].xyz;
	    _3168[2] = _3165[2].xyz;
	    _649 = _3168;
	    vec3 _3177 = normalize(_3168 * _654.xyz);
	    vec3 _511;
	    vec3 _3179 = _511;
	    _3179.x = _3177.x;
	    _3179.y = _3177.y;
	    _3179.z = _3177.z;
	    _511 = _3179;
	    mat3x4 _3191 = transpose(gl_WorldToObjectEXT);
	    mat3 _648;
	    mat3 _3194 = _648;
	    _3194[0] = _3191[0].xyz;
	    _3194[1] = _3191[1].xyz;
	    _3194[2] = _3191[2].xyz;
	    _648 = _3194;
	    vec3 _3203 = normalize(_3194 * _655.xyz);
	    vec4 _509;
	    vec4 _3205 = _509;
	    _3205.x = _3203.x;
	    _3205.y = _3203.y;
	    _3205.z = _3203.z;
	    _3205.w = _655.w;
	    _509 = _3205;
	    vec4 _3214 = vsInput[0]._m1.xyxy;
	    _3214.z = vsInput[0]._m2.x;
	    _3214.w = vsInput[0]._m2.y;
	    vec4 _512;
	    vec4 _508 = _512;
	    vec3 _507 = vec4(vsInput[0].vColorBlendValues.xyz, 1.0) * transpose(gl_ObjectToWorldEXT);
	    vec3 _506 = _3179;
	    vec4 _505 = _3214;
	    vec4 _504 = _3154;
	    vec4 _503 = _3205;
	    if (_g_rtx_material_data_._m38 > 0)
	    {
	        vec2 _656;
	        if (_g_rtx_material_data_._m38 == 2)
	        {
	            _656 = _3214.zw;
	        }
	        else
	        {
	            _656 = _3214.xy;
	        }
	        vec4 _3236 = _505;
	        _3236.x = _656.x;
	        _3236.y = _656.y;
	        vec4 _3255 = _3236;
	        _3255.x = dot(_3236.xy, _g_rtx_material_data_._m45.xy) + _g_rtx_material_data_._m45.w;
	        _3255.y = dot(_3236.xy, _g_rtx_material_data_._m46.xy) + _g_rtx_material_data_._m46.w;
	        _505 = _3255;
	    }
	    vec4 _3257 = _504;
	    vec4 _3259 = _508;
	    _3259.x = _3257.x;
	    _3259.y = _3257.y;
	    _3259.z = _3257.z;
	    _3259.w = _g_rtx_material_data_._m29 * (1.0 - min(_3259.x, min(_3259.y, _3259.z)));
	    _508 = _3259;
	    _3257.x = _g_rtx_material_data_._m28.x;
	    _3257.y = _g_rtx_material_data_._m28.y;
	    _3257.z = _g_rtx_material_data_._m28.z;
	    vec3 _3288 = _3257.xyz * mix(vec3(1.0), vsInput[0]._m7.xyz, vec3(vsInput[0]._m7.w));
	    vec4 _3290 = _3257;
	    _3290.x = _3288.x;
	    _3290.y = _3288.y;
	    _3290.z = _3288.z;
	    _504 = _3290;
	    vec4 _491 = _3259;
	    vec3 _490 = _507;
	    vec3 _489 = _506;
	    vec4 _488 = _505;
	    vec4 _487 = _3290;
	    vec4 _486 = _503;
	    vec3 _645 = vsInput[1]._m3;
	    vec4 _646;
	    vec4 _3304 = _646;
	    _3304.x = vsInput[1]._m4.x;
	    _3304.y = vsInput[1]._m4.y;
	    _3304.z = vsInput[1]._m4.z;
	    _3304.w = vsInput[1]._m4.w;
	    _646 = _3304;
	    vec4 _3329 = vec4(uvec4((g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 255u), (g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 65280u) >> uint(8), (g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 16711680u) >> uint(16), (g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	    vec4 _644 = _3329;
	    vec3 _3330 = _3329.xyz;
	    vec3 _3331 = _3330 * vec3(0.077399380505084991455078125);
	    vec3 _3334 = pow((_3330 * vec3(0.947867333889007568359375)) + vec3(0.052132703363895416259765625), vec3(2.400000095367431640625));
	    float _641;
	    if (_3329.x <= 0.040449999272823333740234375)
	    {
	        _641 = _3331.x;
	    }
	    else
	    {
	        _641 = _3334.x;
	    }
	    float _642;
	    if (_3329.y <= 0.040449999272823333740234375)
	    {
	        _642 = _3331.y;
	    }
	    else
	    {
	        _642 = _3334.y;
	    }
	    float _643;
	    if (_3329.z <= 0.040449999272823333740234375)
	    {
	        _643 = _3331.z;
	    }
	    else
	    {
	        _643 = _3334.z;
	    }
	    vec3 _3359 = vec3(_641, _642, _643);
	    vec4 _3361 = _644;
	    _3361.x = _3359.x;
	    _3361.y = _3359.y;
	    _3361.z = _3359.z;
	    _644 = _3361;
	    vec4 _520;
	    vec4 _3368 = _520;
	    _3368.x = _3361.x;
	    _3368.y = _3361.y;
	    _3368.z = _3361.z;
	    _3368.w = _3361.w;
	    _520 = _3368;
	    mat3x4 _3379 = transpose(gl_WorldToObjectEXT);
	    mat3 _640;
	    mat3 _3382 = _640;
	    _3382[0] = _3379[0].xyz;
	    _3382[1] = _3379[1].xyz;
	    _3382[2] = _3379[2].xyz;
	    _640 = _3382;
	    vec3 _3391 = normalize(_3382 * _645.xyz);
	    vec3 _521;
	    vec3 _3393 = _521;
	    _3393.x = _3391.x;
	    _3393.y = _3391.y;
	    _3393.z = _3391.z;
	    _521 = _3393;
	    mat3x4 _3405 = transpose(gl_WorldToObjectEXT);
	    mat3 _639;
	    mat3 _3408 = _639;
	    _3408[0] = _3405[0].xyz;
	    _3408[1] = _3405[1].xyz;
	    _3408[2] = _3405[2].xyz;
	    _639 = _3408;
	    vec3 _3417 = normalize(_3408 * _646.xyz);
	    vec4 _519;
	    vec4 _3419 = _519;
	    _3419.x = _3417.x;
	    _3419.y = _3417.y;
	    _3419.z = _3417.z;
	    _3419.w = _646.w;
	    _519 = _3419;
	    vec4 _3428 = vsInput[1]._m1.xyxy;
	    _3428.z = vsInput[1]._m2.x;
	    _3428.w = vsInput[1]._m2.y;
	    vec4 _522;
	    vec4 _518 = _522;
	    vec3 _517 = vec4(vsInput[1].vColorBlendValues.xyz, 1.0) * transpose(gl_ObjectToWorldEXT);
	    vec3 _516 = _3393;
	    vec4 _515 = _3428;
	    vec4 _514 = _3368;
	    vec4 _513 = _3419;
	    if (_g_rtx_material_data_._m38 > 0)
	    {
	        vec2 _647;
	        if (_g_rtx_material_data_._m38 == 2)
	        {
	            _647 = _3428.zw;
	        }
	        else
	        {
	            _647 = _3428.xy;
	        }
	        vec4 _3450 = _515;
	        _3450.x = _647.x;
	        _3450.y = _647.y;
	        vec4 _3469 = _3450;
	        _3469.x = dot(_3450.xy, _g_rtx_material_data_._m45.xy) + _g_rtx_material_data_._m45.w;
	        _3469.y = dot(_3450.xy, _g_rtx_material_data_._m46.xy) + _g_rtx_material_data_._m46.w;
	        _515 = _3469;
	    }
	    vec4 _3471 = _514;
	    vec4 _3473 = _518;
	    _3473.x = _3471.x;
	    _3473.y = _3471.y;
	    _3473.z = _3471.z;
	    _3473.w = _g_rtx_material_data_._m29 * (1.0 - min(_3473.x, min(_3473.y, _3473.z)));
	    _518 = _3473;
	    _3471.x = _g_rtx_material_data_._m28.x;
	    _3471.y = _g_rtx_material_data_._m28.y;
	    _3471.z = _g_rtx_material_data_._m28.z;
	    vec3 _3502 = _3471.xyz * mix(vec3(1.0), vsInput[1]._m7.xyz, vec3(vsInput[1]._m7.w));
	    vec4 _3504 = _3471;
	    _3504.x = _3502.x;
	    _3504.y = _3502.y;
	    _3504.z = _3502.z;
	    _514 = _3504;
	    vec4 _485 = _3473;
	    vec3 _484 = _517;
	    vec3 _483 = _516;
	    vec4 _482 = _515;
	    vec4 _481 = _3504;
	    vec4 _480 = _513;
	    vec3 _636 = vsInput[2]._m3;
	    vec4 _637;
	    vec4 _3518 = _637;
	    _3518.x = vsInput[2]._m4.x;
	    _3518.y = vsInput[2]._m4.y;
	    _3518.z = vsInput[2]._m4.z;
	    _3518.w = vsInput[2]._m4.w;
	    _637 = _3518;
	    vec4 _3543 = vec4(uvec4((g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 255u), (g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 65280u) >> uint(8), (g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 16711680u) >> uint(16), (g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	    vec4 _635 = _3543;
	    vec3 _3544 = _3543.xyz;
	    vec3 _3545 = _3544 * vec3(0.077399380505084991455078125);
	    vec3 _3548 = pow((_3544 * vec3(0.947867333889007568359375)) + vec3(0.052132703363895416259765625), vec3(2.400000095367431640625));
	    float _632;
	    if (_3543.x <= 0.040449999272823333740234375)
	    {
	        _632 = _3545.x;
	    }
	    else
	    {
	        _632 = _3548.x;
	    }
	    float _633;
	    if (_3543.y <= 0.040449999272823333740234375)
	    {
	        _633 = _3545.y;
	    }
	    else
	    {
	        _633 = _3548.y;
	    }
	    float _634;
	    if (_3543.z <= 0.040449999272823333740234375)
	    {
	        _634 = _3545.z;
	    }
	    else
	    {
	        _634 = _3548.z;
	    }
	    vec3 _3573 = vec3(_632, _633, _634);
	    vec4 _3575 = _635;
	    _3575.x = _3573.x;
	    _3575.y = _3573.y;
	    _3575.z = _3573.z;
	    _635 = _3575;
	    vec4 _530;
	    vec4 _3582 = _530;
	    _3582.x = _3575.x;
	    _3582.y = _3575.y;
	    _3582.z = _3575.z;
	    _3582.w = _3575.w;
	    _530 = _3582;
	    mat3x4 _3593 = transpose(gl_WorldToObjectEXT);
	    mat3 _631;
	    mat3 _3596 = _631;
	    _3596[0] = _3593[0].xyz;
	    _3596[1] = _3593[1].xyz;
	    _3596[2] = _3593[2].xyz;
	    _631 = _3596;
	    vec3 _3605 = normalize(_3596 * _636.xyz);
	    vec3 _531;
	    vec3 _3607 = _531;
	    _3607.x = _3605.x;
	    _3607.y = _3605.y;
	    _3607.z = _3605.z;
	    _531 = _3607;
	    mat3x4 _3619 = transpose(gl_WorldToObjectEXT);
	    mat3 _630;
	    mat3 _3622 = _630;
	    _3622[0] = _3619[0].xyz;
	    _3622[1] = _3619[1].xyz;
	    _3622[2] = _3619[2].xyz;
	    _630 = _3622;
	    vec3 _3631 = normalize(_3622 * _637.xyz);
	    vec4 _529;
	    vec4 _3633 = _529;
	    _3633.x = _3631.x;
	    _3633.y = _3631.y;
	    _3633.z = _3631.z;
	    _3633.w = _637.w;
	    _529 = _3633;
	    vec4 _3642 = vsInput[2]._m1.xyxy;
	    _3642.z = vsInput[2]._m2.x;
	    _3642.w = vsInput[2]._m2.y;
	    vec4 _532;
	    vec4 _528 = _532;
	    vec3 _527 = vec4(vsInput[2].vColorBlendValues.xyz, 1.0) * transpose(gl_ObjectToWorldEXT);
	    vec3 _526 = _3607;
	    vec4 _525 = _3642;
	    vec4 _524 = _3582;
	    vec4 _523 = _3633;
	    if (_g_rtx_material_data_._m38 > 0)
	    {
	        vec2 _638;
	        if (_g_rtx_material_data_._m38 == 2)
	        {
	            _638 = _3642.zw;
	        }
	        else
	        {
	            _638 = _3642.xy;
	        }
	        vec4 _3664 = _525;
	        _3664.x = _638.x;
	        _3664.y = _638.y;
	        vec4 _3683 = _3664;
	        _3683.x = dot(_3664.xy, _g_rtx_material_data_._m45.xy) + _g_rtx_material_data_._m45.w;
	        _3683.y = dot(_3664.xy, _g_rtx_material_data_._m46.xy) + _g_rtx_material_data_._m46.w;
	        _525 = _3683;
	    }
	    vec4 _3685 = _524;
	    vec4 _3687 = _528;
	    _3687.x = _3685.x;
	    _3687.y = _3685.y;
	    _3687.z = _3685.z;
	    _3687.w = _g_rtx_material_data_._m29 * (1.0 - min(_3687.x, min(_3687.y, _3687.z)));
	    _528 = _3687;
	    _3685.x = _g_rtx_material_data_._m28.x;
	    _3685.y = _g_rtx_material_data_._m28.y;
	    _3685.z = _g_rtx_material_data_._m28.z;
	    vec3 _3716 = _3685.xyz * mix(vec3(1.0), vsInput[2]._m7.xyz, vec3(vsInput[2]._m7.w));
	    vec4 _3718 = _3685;
	    _3718.x = _3716.x;
	    _3718.y = _3716.y;
	    _3718.z = _3716.z;
	    _524 = _3718;
	    vec3 _479 = _527;
	    vec3 _478 = _526;
	    vec3 _3748 = ((_489 * ((1.0 - _22.barycentrics.x) - _22.barycentrics.y)) + (_483 * _22.barycentrics.x)) + (_526 * _22.barycentrics.y);
	    bool _3754 = gl_HitKindEXT == 254u;
	    vec3 _533;
	    vec3 _534;
	    vec4 _502 = ((_491 * ((1.0 - _22.barycentrics.x) - _22.barycentrics.y)) + (_485 * _22.barycentrics.x)) + (_3687 * _22.barycentrics.y);
	    vec3 _501 = _534;
	    vec3 _500 = _3748;
	    vec4 _499 = ((_488 * ((1.0 - _22.barycentrics.x) - _22.barycentrics.y)) + (_482 * _22.barycentrics.x)) + (_525 * _22.barycentrics.y);
	    vec4 _498 = ((_487 * ((1.0 - _22.barycentrics.x) - _22.barycentrics.y)) + (_481 * _22.barycentrics.x)) + (_3718 * _22.barycentrics.y);
	    vec4 _497 = ((_486 * ((1.0 - _22.barycentrics.x) - _22.barycentrics.y)) + (_480 * _22.barycentrics.x)) + (_523 * _22.barycentrics.y);
	    bool _496 = _3754;
	    vec3 _543 = vec3(0.5);
	    vec2 _542 = vec2(0.5);
	    float _541 = 0.0;
	    vec3 _540 = vec3(0.0);
	    float _539 = 0.039999999105930328369140625;
	    vec3 _538 = vec3(0.0);
	    vec3 _536 = vec3(1.0);
	    bool _535 = false;
	    vec3 _3793 = _3748.xyz;
	    vec3 _537 = _3793;
	    if (dot(_3793, _3793) >= 1.0099999904632568359375)
	    {
	        _537 = _533.xyz;
	    }
	    _539 = _g_rtx_material_data_._m98;
	    _536 = normalize(cross(_484 - _490, _527 - _490));
	    bool _628;
	    if (_g_rtx_material_data_._m97)
	    {
	        _628 = !_g_rtx_material_data_._m96;
	    }
	    else
	    {
	        _628 = false;
	    }
	    if (_628)
	    {
	        float _629;
	        if (_3754)
	        {
	            _629 = 1.0;
	        }
	        else
	        {
	            _629 = -1.0;
	        }
	        _537 *= _629;
	        if (_3754)
	        {
	            _629 = 1.0;
	        }
	        else
	        {
	            _629 = -1.0;
	        }
	        _536 *= _629;
	        _535 = !_3754;
	    }
	    vec3 _3824 = _537;
	    vec3 _3825 = normalize(_3824);
	    _537 = _3825;
	    vec3 _572 = _3825;
	    vec3 _571 = _543;
	    vec2 _570 = _542;
	    float _569 = _541;
	    vec3 _568 = _540;
	    float _567 = _539;
	    vec3 _566 = _538;
	    vec3 _565 = _3825;
	    vec3 _564 = _536;
	    bool _563 = _535;
	    bool _626;
	    if (_g_rtx_material_data_._m97)
	    {
	        _626 = !_g_rtx_material_data_._m96;
	    }
	    else
	    {
	        _626 = false;
	    }
	    if (_626)
	    {
	        float _627;
	        if (_496)
	        {
	            _627 = 1.0;
	        }
	        else
	        {
	            _627 = -1.0;
	        }
	        _626 = _627 < 0.0;
	    }
	    else
	    {
	        _626 = false;
	    }
	    vec3 _576 = vec3(0.0);
	    vec3 _575 = vec3(0.0);
	    float _624;
	    if (_497.w > 0.0)
	    {
	        _624 = 1.0;
	    }
	    else
	    {
	        _624 = -1.0;
	    }
	    float _3873 = 1.0 / length(_500);
	    vec3 _577 = _500 * _3873;
	    vec3 _495 = _497.xyz * _3873;
	    vec3 _494 = (cross(_500, _497.xyz) * _624) * _3873;
	    if (_626)
	    {
	        _577 *= (-1.0);
	    }
	    vec3 _574 = _576 - (_577 * dot(_576, _577));
	    vec3 _573 = _575 - (_577 * dot(_575, _577));
	    int _625;
	    if (dot(_575, cross(_577, _576)) < 0.0)
	    {
	        _625 = -1;
	    }
	    else
	    {
	        _625 = 1;
	    }
	    vec3 _593 = _577;
	    vec3 _592 = _574;
	    vec3 _591 = _573;
	    float _590 = float(_625);
	    vec3 _561;
	    vec3 _562;
	    if (_g_rtx_material_data_._m38 > 1)
	    {
	        float _623;
	        if (false)
	        {
	            _623 = -1.0;
	        }
	        else
	        {
	            _623 = 1.0;
	        }
	        vec2 _3909 = vec2(0.0, -0.0) * _623;
	        vec3 _578 = (_592 * _3909.x) + (_591 * _3909.y);
	        float _3917 = abs(0.0);
	        if (_3917 > 0.0)
	        {
	            _578 = normalize(_578);
	        }
	        _562 = _578;
	        _561 = cross(_593, _578) * (_623 * _590);
	    }
	    vec2 _560 = vec2(0.0);
	    vec2 _559 = vec2(0.0);
	    vec2 _558 = vec2(0.0);
	    vec2 _557 = vec2(0.0);
	    vec2 _556 = vec2(0.0);
	    vec2 _555 = vec2(0.0);
	    vec2 _554 = vec2(0.0);
	    ivec2 _553 = ivec2(0);
	    ivec2 _552 = ivec2(0);
	    if (_g_rtx_material_data_._m38 == 0)
	    {
	        vec3 _3937 = abs(_565);
	        vec3 _618 = _3937;
	        float _3938 = _3937.x;
	        float _3939 = _3937.y;
	        bool _619;
	        if (_3938 > _3939)
	        {
	            _619 = _3938 > _3937.z;
	        }
	        else
	        {
	            _619 = false;
	        }
	        ivec3 _620;
	        if (_619)
	        {
	            _620 = ivec3(0, 1, 2);
	        }
	        else
	        {
	            if (_3939 > _3937.z)
	            {
	                _620 = ivec3(1, 2, 0);
	            }
	            else
	            {
	                _620 = ivec3(2, 0, 1);
	            }
	        }
	        if (_3938 < _3939)
	        {
	            _619 = _3938 < _3937.z;
	        }
	        else
	        {
	            _619 = false;
	        }
	        ivec3 _621;
	        if (_619)
	        {
	            _621 = ivec3(0, 1, 2);
	        }
	        else
	        {
	            if (_3939 < _3937.z)
	            {
	                _621 = ivec3(1, 2, 0);
	            }
	            else
	            {
	                _621 = ivec3(2, 0, 1);
	            }
	        }
	        ivec3 _3973 = (ivec3(3) - _621) - _620;
	        ivec2 _622;
	        if (_620.x == 1)
	        {
	            _622 = _620.zy;
	        }
	        else
	        {
	            _622 = _620.yz;
	        }
	        ivec2 _3985 = _553;
	        _3985.x = _622.x;
	        _3985.y = _622.y;
	        _553 = _3985;
	        int _3989 = _3973.x;
	        if (_3989 == 1)
	        {
	            _622 = _3973.zy;
	        }
	        else
	        {
	            _622 = _3973.yz;
	        }
	        ivec2 _3998 = _552;
	        _3998.x = _622.x;
	        _3998.y = _622.y;
	        _552 = _3998;
	        vec2 _4009 = clamp((vec2(_618[_620.x], _618[_3989]) - vec2(0.577300012111663818359375)) * vec2(2.365744113922119140625), vec2(0.0), vec2(1.0));
	        _554 = _4009 / vec2(_4009.x + _4009.y);
	        vec3 _609 = _501 * _g_rtx_material_data_._m34.xyz;
	        _560 = vec2(_609[_553.x], _609[_553.y]);
	        vec3 _610 = vec3(0.0);
	        vec3 _611 = vec3(0.0);
	        _558 = vec2(_610[_553.x], _611[_553.y]);
	        vec3 _612 = vec3(0.0);
	        vec3 _613 = vec3(0.0);
	        _557 = vec2(_612[_553.x], _613[_553.y]);
	        _559 = vec2(_609[_3998.x], _609[_3998.y]);
	        vec3 _614 = vec3(0.0);
	        vec3 _615 = vec3(0.0);
	        _556 = vec2(_614[_3998.x], _615[_3998.y]);
	        vec3 _616 = vec3(0.0);
	        vec3 _617 = vec3(0.0);
	        _555 = vec2(_616[_3998.x], _617[_3998.y]);
	    }
	    vec4 _551 = vec4(0.0);
	    vec3 _550 = vec3(0.0);
	    vec4 _547 = vec4(0.0);
	    float _546 = 0.0;
	    float _545 = 0.0;
	    float _544 = 0.0;
	    vec3 _4066 = vec3(0.0);
	    _4066.x = _499.x;
	    _4066.y = _499.y;
	    vec3 _549 = _4066;
	    vec2 _548 = _g_rtx_material_data_._m40.xy;
	    vec4 _608;
	    if (_g_rtx_material_data_._m38 == 0)
	    {
	        vec2 _4085 = _560;
	        vec2 _4086 = _4085 * _548;
	        _560 = _4086;
	        vec2 _4087 = _558;
	        vec2 _4088 = _4087 * _548;
	        _558 = _4088;
	        vec2 _4089 = _557;
	        vec2 _4090 = _4089 * _548;
	        _557 = _4090;
	        vec2 _4091 = _559;
	        vec2 _4092 = _4091 * _548;
	        _559 = _4092;
	        vec2 _4093 = _556;
	        vec2 _4094 = _4093 * _548;
	        _556 = _4094;
	        vec2 _4095 = _555;
	        vec2 _4096 = _4095 * _548;
	        _555 = _4096;
	        _608 = (textureGrad(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_._m61], g_bindless_Sampler[_g_rtx_material_data_._m92]), _4086.xy, _4088.xy, _4090.xy) * _554.x) + (textureGrad(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_._m61], g_bindless_Sampler[_g_rtx_material_data_._m92]), _4092.xy, _4094.xy, _4096.xy) * _554.y);
	    }
	    else
	    {
	        _608 = textureLod(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_._m61], g_bindless_Sampler[_g_rtx_material_data_._m92]), _549.xy, 0.0).xyzw;
	    }
	    _545 = _608.y;
	    _546 = _608.w;
	    vec2 _589 = _560;
	    vec2 _588 = _559;
	    vec2 _587 = _558;
	    vec2 _586 = _557;
	    vec2 _585 = _556;
	    vec2 _584 = _555;
	    vec2 _583 = _554;
	    ivec2 _582 = _553;
	    ivec2 _581 = _552;
	    if (_g_rtx_material_data_._m38 == 0)
	    {
	        _589 *= _548;
	        _587 *= _548;
	        _586 *= _548;
	        _588 *= _548;
	        _585 *= _548;
	        _584 *= _548;
	        _550 = _565;
	        if (true)
	        {
	            _551 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_._m94], g_bindless_Sampler[_g_rtx_material_data_._m92]), _589.xy, _587.xy, _586.xy) * _583.x;
	        }
	        if (true)
	        {
	            vec4 _4274 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_._m60], g_bindless_Sampler[_g_rtx_material_data_._m92]), _589.xy, _587.xy, _586.xy);
	            _544 = _4274.z * _583.x;
	            float _4279 = _4274.x;
	            float _4280 = _4274.y;
	            float _4282 = (_4279 + _4280) - 1.00392162799835205078125;
	            float _4283 = _4279 - _4280;
	            vec3 _4293 = normalize(vec3(vec2(_4282, _4283), (1.0 - abs(_4282)) - abs(_4283))).xyz * _583.x;
	            vec4 _4295;
	            _4295.x = _4293.x;
	            _4295.y = _4293.y;
	            vec4 _4299 = _4295;
	            _4299.z = _4293.z;
	            _550 = (_417[_582.x] * _4295.x) + (_421[_582.y] * _4295.y);
	        }
	        if (_583.y > 0.0)
	        {
	            if (true)
	            {
	                _551 += (textureGrad(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_._m94], g_bindless_Sampler[_g_rtx_material_data_._m92]), _588.xy, _585.xy, _584.xy) * _583.y);
	            }
	            if (true)
	            {
	                vec4 _4349 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_._m60], g_bindless_Sampler[_g_rtx_material_data_._m92]), _588.xy, _585.xy, _584.xy);
	                _544 += (_4349.z * _583.y);
	                float _4356 = _4349.x;
	                float _4357 = _4349.y;
	                float _4359 = (_4356 + _4357) - 1.00392162799835205078125;
	                float _4360 = _4356 - _4357;
	                vec3 _4370 = normalize(vec3(vec2(_4359, _4360), (1.0 - abs(_4359)) - abs(_4360))).xyz * _583.y;
	                vec4 _4372;
	                _4372.x = _4370.x;
	                _4372.y = _4370.y;
	                vec4 _4376 = _4372;
	                _4376.z = _4370.z;
	                _550 += ((_417[_581.x] * _4372.x) + (_421[_581.y] * _4372.y));
	            }
	        }
	        _550 = normalize(_550 + _565);
	    }
	    else
	    {
	        if (true)
	        {
	            _551 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_._m94], g_bindless_Sampler[_g_rtx_material_data_._m92]), _549.xy, _547.xy, _547.zw).xyzw;
	        }
	        if (true)
	        {
	            vec4 _4172 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_._m60], g_bindless_Sampler[_g_rtx_material_data_._m92]), _549.xy, _547.xy, _547.zw);
	            vec3 _4173 = _4172.xyz;
	            _544 = _4172.z;
	            float _4175 = _4172.x;
	            float _4176 = _4172.y;
	            float _4178 = (_4175 + _4176) - 1.00392162799835205078125;
	            float _4179 = _4175 - _4176;
	            vec3 _4186 = normalize(vec3(vec2(_4178, _4179), (1.0 - abs(_4178)) - abs(_4179)));
	            _4173.x = _4186.x;
	            _4173.y = _4186.y;
	            _4173.z = _4186.z;
	            vec3 _4199 = _4173;
	            _4199.x = dot(_4173.xy, _g_rtx_material_data_._m47.xy);
	            _4199.y = dot(_4173.xy, _g_rtx_material_data_._m47.zw);
	            vec3 _607 = _4199;
	            vec3 _579;
	            vec3 _580;
	            if (_g_rtx_material_data_._m38 > 1)
	            {
	                _580 = _562;
	                _579 = _561;
	            }
	            else
	            {
	                _580 = _495;
	                _579 = _494;
	            }
	            vec3 _4207 = abs(_607.xyz);
	            vec2 _4220 = (-vec2(_607.x, (-1.0) * _607.y)) / vec2(max(_4207.z, 0.0078125 * max(_4207.x, _4207.y)));
	            _550 = normalize(_593 - ((_580 * _4220.x) + (_579 * _4220.y)));
	        }
	    }
	    if (true)
	    {
	        _550 = normalize(_550);
	        _544 = saturate(_544);
	    }
	    vec4 _602;
	    if (false)
	    {
	        _602 = vec4((vec4(_551.xyz, 1.0) * _g_rtx_material_data_._m65).xyz, _551.w);
	    }
	    else
	    {
	        _602 = _551;
	    }
	    vec4 _4419 = _602;
	    float _4421 = _545;
	    float _4422 = saturate(_4421);
	    _545 = _4422;
	    vec3 _4426 = mix(_4419.xyz, vec4((vec4(_551.xyz, 1.0) * _g_rtx_material_data_._m64).xyz, _473).xyz, vec3(_4422));
	    vec4 _4428 = _4419;
	    _4428.x = _4426.x;
	    _4428.y = _4426.y;
	    _4428.z = _4426.z;
	    float _4437 = dot(_4428.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125));
	    vec3 _4440 = normalize(max(_502.xyz, vec3(0.001000000047497451305389404296875)));
	    vec4 _4459 = vec4(clamp(mix(_4428.xyz, (_4440 * min(_4437 / dot(_4440.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125)), (3.0 * _4437) * max(_502.x, max(_502.y, _502.z)))).xyz, vec3(_502.w * _4422)), vec3(0.0), vec3(1.0)).xyz, _4428.w);
	    _551 = _4459;
	    _572 = _550.xyz;
	    _571 = _4459.xyz;
	    vec2 _4464 = _570;
	    _4464.x = _544;
	    _569 = _546;
	    vec2 _4467 = _4464;
	    _4467.x = _4464.x;
	    _4467.y = _4464.x;
	    _570 = _4467;
	    vec3 _4476 = _571;
	    vec3 _4477 = _4476 * mix(vec3(1.0), _498.xyz, vec3(saturate(_545)));
	    _571 = _4477;
	    _21._m5 = int(uint(gl_InstanceID));
	    _21._m3 = gl_RayTmaxEXT;
	    _21._m1 = _564;
	    _21._m2 = _565;
	    vec3 _594[3] = vec3[](_489, _483, _478);
	    vec3 _595[3] = vec3[](_490, _484, _479);
	    vec3 _4512 = ((_490 * ((1.0 - _22.barycentrics.x) - _22.barycentrics.y)) + (_484 * _22.barycentrics.x)) + (_479 * _22.barycentrics.y);
	    vec3 _596[3];
	    _596[0] = _4512 - (_489 * dot(_4512 - _490, _489));
	    _596[1] = _4512 - (_483 * dot(_4512 - _484, _483));
	    _596[2] = _4512 - (_478 * dot(_4512 - _479, _478));
	    vec3 _4540 = ((_596[0] * ((1.0 - _22.barycentrics.x) - _22.barycentrics.y)) + (_596[1] * _22.barycentrics.x)) + (_596[2] * _22.barycentrics.y);
	    vec3 _597[3];
	    _597[0] = cross(_490 - _484, _21._m1);
	    _597[1] = cross(_484 - _479, _21._m1);
	    _597[2] = cross(_479 - _490, _21._m1);
	    float _598 = dot(_4540 - _4512, _21._m1);
	    vec3 _599 = _4540;
	    int _600 = 0;
	    for (;;)
	    {
	        bool _4556_ladder_break = false;
	        do
	        {
	            if (!(_600 < 3))
	            {
	                _4556_ladder_break = true;
	                break;
	            }
	            if (_598 > 0.00999999977648258209228515625)
	            {
	                _4556_ladder_break = true;
	                break;
	            }
	            if (dot(_597[_600], _597[_600]) == 0.0)
	            {
	                break;
	            }
	            _597[_600] = normalize(_597[_600]);
	            int _601 = 0;
	            for (;;)
	            {
	                if (!(_601 < 3))
	                {
	                    break;
	                }
	                vec3 _4594 = _594[_601] - (_597[_600] * dot(_597[_600], _594[_601]));
	                _596[_601] = _4512 - (_4594 * dot(_4512 - _595[_601], _4594));
	                _601++;
	                continue;
	            }
	            vec3 _4618 = ((_596[0] * ((1.0 - _22.barycentrics.x) - _22.barycentrics.y)) + (_596[1] * _22.barycentrics.x)) + (_596[2] * _22.barycentrics.y);
	            _598 = dot(_4618 - _4512, _21._m1);
	            _599 = _4618;
	            break;
	        } while(false);
	        if (_4556_ladder_break)
	        {
	            break;
	        }
	        _600++;
	        continue;
	    }
	    if (!(_598 > 0.00999999977648258209228515625))
	    {
	        _599 = vec3(3.4028234663852885981170418348452e+38);
	    }
	    _21.material = _599;
	    _21._m6 = _563;
	    f16vec3 _4631 = f16vec3(vec3(0.0));
	    _21._m7 = MaterialDataMinimal_t(_4631, float16_t(0.0), f16vec3(vec3(1.0, 0.0, 1.0)), float16_t(1.0), _4631, float16_t(0.040008544921875), 0u, f16vec4(ivec4(0)));
	    _21._m7.vMaterialBits = f16vec3(_572);
	    _21._m7._m2 = f16vec3(_4477);
	    _21._m7._m4 = f16vec3(_568);
	    _21._m7._m5 = float16_t(_567);
	    _21._m7._m1 = float16_t(_569);
	    _21._m7._m3 = float16_t(dot(_570, vec2(0.5)));
	    if (any(greaterThan(_566, vec3(0.0))))
	    {
	        f16vec4 _4660 = _21._m7._m7;
	        f16vec3 _4663 = f16vec3(_566);
	        _4660.x = _4663.x;
	        _4660.y = _4663.y;
	        _4660.z = _4663.z;
	        _21._m7 = MaterialDataMinimal_t(_21._m7.vMaterialBits, _21._m7._m1, _21._m7._m2, _21._m7._m3, _21._m7._m4, _21._m7._m5, (_21._m7._m6 & 4294901760u) | 1u, _4660);
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
	BoolAttribute(HasTexcoordTransform, (((g_vTexCoordScale1.x!=1) || (g_vTexCoordScale1.y!=1)) || (g_flTexCoordRotation1!=0)) || 0);
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
