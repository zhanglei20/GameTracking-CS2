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
	// SPIR-V source (65520 bytes), GLSL reflection with SPIRV-Cross by KhronosGroup
	
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
	        _19323 = (textureGrad(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tHeight1], undetermined[_Globals_.g_sUserConfig]), (_17114 * _Globals_.g_vTexCoordScale1.xy).xy, (_17116 * _Globals_.g_vTexCoordScale1.xy).xy, (_17117 * _Globals_.g_vTexCoordScale1.xy).xy) * _6616.x) + (textureGrad(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tHeight1], undetermined[_Globals_.g_sUserConfig]), (_17115 * _Globals_.g_vTexCoordScale1.xy).xy, (_17118 * _Globals_.g_vTexCoordScale1.xy).xy, (_13694 * _Globals_.g_vTexCoordScale1.xy).xy) * _6616.y);
	    }
	    else
	    {
	        _19323 = texture(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tHeight1], undetermined[_Globals_.g_sUserConfig]), _24878.xy).xyzw;
	    }
	    float _21711;
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
	        vec4 _23806 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tColor1], undetermined[_Globals_.g_sUserConfig]), _8315, _7412, _8904) * _6616.x;
	        vec4 _12167 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tNormal1], undetermined[_Globals_.g_sUserConfig]), _8315, _7412, _8904);
	        float _18178 = _12167.z * _6616.x;
	        float _15456 = _12167.x;
	        float _24534 = _12167.y;
	        float _16784 = (_15456 + _24534) - 1.00392162799835205078125;
	        float _11177 = _15456 - _24534;
	        vec3 _21631 = normalize(vec3(vec2(_16784, _11177), (1.0 - abs(_16784)) - abs(_11177))).xyz * _6616.x;
	        vec3 _24466 = (_2029[_13136.x] * _21631.x) + (_842[_13136.y] * _21631.y);
	        float _13137;
	        vec3 _13753;
	        vec4 _14101;
	        if (_6616.y > 0.0)
	        {
	            vec2 _17047 = (_17115 * _Globals_.g_vTexCoordScale1.xy).xy;
	            vec2 _10017 = (_17118 * _Globals_.g_vTexCoordScale1.xy).xy;
	            vec2 _8905 = (_13694 * _Globals_.g_vTexCoordScale1.xy).xy;
	            vec4 _12168 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tNormal1], undetermined[_Globals_.g_sUserConfig]), _17047, _10017, _8905);
	            float _13491 = _12168.x;
	            float _21308 = _12168.y;
	            float _16785 = (_13491 + _21308) - 1.00392162799835205078125;
	            float _11178 = _13491 - _21308;
	            vec3 _21632 = normalize(vec3(vec2(_16785, _11178), (1.0 - abs(_16785)) - abs(_11178))).xyz * _6616.y;
	            _13137 = _18178 + (_12168.z * _6616.y);
	            _14101 = _23806 + (textureGrad(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tColor1], undetermined[_Globals_.g_sUserConfig]), _17047, _10017, _8905) * _6616.y);
	            _13753 = _24466 + ((_2029[_16305.x] * _21632.x) + (_842[_16305.y] * _21632.y));
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
	        _13138 = _11179.z;
	        _13189 = normalize(_8889 - ((mix(input_7.xyz * _12157, _11711, _20662) * _16475.x) + (mix((cross(input_3, input_7.xyz) * ((input_7.w > 0.0) ? 1.0 : (-1.0))) * _12157, _10247, _20662) * _16475.y)));
	        _22057 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tColor1], undetermined[_Globals_.g_sUserConfig]), _24878.xy, _9716.xy, _9716.zw).xyzw;
	    }
	    vec3 _19225 = normalize(_13189);
	    float _6375 = saturate(_13138);
	    float _14713 = clamp(mix(0.0, 1.0, pow(_22057.w, 1.0)), 0.0, 1.0);
	    float _7029 = saturate(_19323.y);
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
	    vec3 _13141;
	    float _13960;
	    vec2 _16306;
	    float _17119;
	    float _17120;
	    vec3 _17121;
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
	        float _13140;
	        float _13151;
	        vec4 _23607;
	        if (_13706 > 0.5)
	        {
	            float _12497 = _Globals_.g_fRippleStrength * PerViewConstantBufferCsgo_t._m9;
	            vec3 _6617;
	            vec4 _12891;
	            float _13139;
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
	                _13139 = _12497 * (0.039999999105930328369140625 * (_22217 + _9250));
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
	        vec3 _13712 = normalize(mix(_19225.xyz, _23607.xyz, vec3(saturate(_10839 * 4.0))));
	        float _9038 = max(_13706 * (1.0 - saturate(PerViewConstantBufferCsgo_t._m12 * 2.0)), _19808);
	        vec3 _18806 = mix(_21712, pow(_21712, vec3(1.2999999523162841796875)) * 0.800000011920928955078125, clamp((pow(_21712, vec3(0.25)) * (_9038 * _6375)) * 8.0, vec3(0.0), vec3(1.0)) * _Globals_.g_flWetnessDarkeningStrength1);
	        _13141 = fma(mix((mix(_18806, _18806 * 0.5, vec3(saturate(_14611 * 1.5))) * mix(1.0, _14713, _19808)) * mix(1.0, 1.0 - _17924, _10334), _Globals_.g_vPuddleSedimentColor, vec3(_10334 * _19808)), vec3(1.0 + _13140), vec3(_13140 * 0.100000001490116119384765625));
	        _16306 = clamp(mix(_11281.xx, vec2(_Globals_.g_fPuddleRoughness), vec2(_9038)) + vec2(_13151 + (length(fwidth(_13712.xyz)) * 0.5)), vec2(0.0), vec2(1.0));
	        _17119 = mix(_14713, 1.0, _19808);
	        _17120 = mix(_Globals_.g_flReflectance, 0.0350000001490116119384765625, _9038);
	        _17121 = _13712;
	        _13960 = _10839 * (0.20000000298023223876953125 + (((0.1500000059604644775390625 * _23607.w) * _23607.w) * _23607.w));
	        _24595 = mix(_6756, _23607.xyz, vec3(_19808 * _10334));
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
	    vec3 _9453 = mix(vec3(_17120).xyz, _13141.xyz, vec3(_19323.w));
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
	            float _18270 = textureLod(sampler2DShadow(g_bindless_Texture2D_float4[PerViewLightingConstantBufferGpu_t._m20], undetermined_1[_Globals_.g_tShadowDepthBufferCmpSampler]), vec3(_14975.xy, saturate(_14975.z + PerViewLightingConstantBufferGpu_t._m12)), 0.0);
	            float _12501;
	            if (_13142 < 1.0)
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
	                    vec3 _20482 = _21548.xyz * mix(1.0, textureLod(sampler2DShadow(g_bindless_Texture2D_float4[PerViewLightingConstantBufferGpu_t._m20], undetermined_1[_Globals_.g_tShadowDepthBufferCmpSampler]), vec3(vec3(fma(_19629.xy, g_BarnLights_1._m0[_12608]._m8.zw, g_BarnLights_1._m0[_12608]._m8.xy), _19629.z).xy, saturate(_19629.z + PerViewLightingConstantBufferGpu_t._m12)), 0.0), g_BarnLights_1._m0[_12608]._m12);
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
	                float _25215 = _9851 * _9851;
	                float _19097 = _25215 * _25215;
	                float _15348 = ((_12387 * _12387) * (_19097 - 1.0)) + 1.0;
	                _13212 = _13144.xyz + (((_9453.xyz * (_19097 / (((_15348 * _15348) * (_19211 * _19211)) * ((_9851 * 4.0) + 2.0)))).xyz * _13812).xyz * _21549.xyz);
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
	    vec4 _15343 = (vec4(-1.0, -0.0274999998509883880615234375, -0.572000026702880859375, 0.02199999988079071044921875) * _17172) + vec4(1.0, 0.0425000004470348358154296875, 1.03999996185302734375, -0.039999999105930328369140625);
	    float _21215 = _15343.x;
	    vec2 _24572 = (vec2(-1.03999996185302734375, 1.03999996185302734375) * ((min(_21215 * _21215, exp2((-9.27999973297119140625) * max(0.0, dot((-_17138).xyz, _7507)))) * _21215) + _15343.y)) + _15343.zw;
	    float _20339 = _24572.y;
	    vec2 _11427 = vec2(_20339, _24572.x + _20339);
	    vec3 _8745 = vec3(dot(PerViewLightingConstantBufferGpu_t._m0._m0[0].xyzw, _23875), dot(PerViewLightingConstantBufferGpu_t._m0._m0[1].xyzw, _23875), dot(PerViewLightingConstantBufferGpu_t._m0._m0[2].xyzw, _23875)).xyz;
	    vec3 _16991 = _16324.xyz + _8745;
	    vec3 _9666 = _8745 * vec3(_21714 * _17119).xyz;
	    vec3 _13436 = vec3(_17119 * _21714).xyz;
	    vec3 _20579;
	    if (_9090 > 0.0)
	    {
	        _20579 = mix(_9666, pow(_9666, vec3(1.0499999523162841796875, 0.949999988079071044921875, 0.800000011920928955078125)), vec3(_9090));
	    }
	    else
	    {
	        _20579 = _9666;
	    }
	    vec3 _22686 = (_16324.xyz + _20579.xyz) * (_13141.xyz * (1.0 - _19323.w)).xyz;
	    float _12931 = _22686.x;
	    vec4 _11203 = vec4(_12931, _22686.yz, input_5.w);
	    _11203.x = _12931;
	    _11203.y = _22686.y;
	    _11203.z = _22686.z;
	    vec3 _15753 = _11203.xyz + (_13143.xyz * _13436).xyz;
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
	// SPIR-V source (107420 bytes), GLSL reflection with SPIRV-Cross by KhronosGroup
	
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
	    _RTX_MATERIAL_DATA_ _1533 = _RTX_MATERIAL_DATA_(vec2(g_MaterialData_1._m0[g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 4u) / 4u]), g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 8u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 12u) / 4u], vec2(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 16u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 20u) / 4u]), g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 24u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 28u) / 4u], vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 32u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 36u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 40u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 44u) / 4u]), g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 48u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 52u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 56u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 60u) / 4u], vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 64u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 68u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 72u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 76u) / 4u]), vec2(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 80u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 84u) / 4u]), vec2(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 88u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 92u) / 4u]), g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 96u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 100u) / 4u], vec2(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 104u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 108u) / 4u]), vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 112u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 116u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 120u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 124u) / 4u]), vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 128u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 132u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 136u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 140u) / 4u]), vec2(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 144u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 148u) / 4u]), g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 152u) / 4u], g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 156u) / 4u], g_MaterialData_5._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 160u) / 4u] != 0, g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 164u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 168u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 172u) / 4u], vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 176u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 180u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 184u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 188u) / 4u]), vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 192u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 196u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 200u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 204u) / 4u]), vec3(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 208u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 212u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 216u) / 4u]), g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 220u) / 4u], g_MaterialData_5._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 224u) / 4u] != 0, g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 228u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 232u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 236u) / 4u], vec3(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 240u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 244u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 248u) / 4u]), g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 252u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 256u) / 4u], g_MaterialData_5._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 260u) / 4u] != 0, g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 264u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 268u) / 4u], vec2(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 272u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 276u) / 4u]), vec2(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 280u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 284u) / 4u]), g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 288u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 292u) / 4u], vec2(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 296u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 300u) / 4u]), vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 304u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 308u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 312u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 316u) / 4u]), vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 320u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 324u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 328u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 332u) / 4u]), vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 336u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 340u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 344u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 348u) / 4u]), g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 352u) / 4u], g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 356u) / 4u], vec2(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 360u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 364u) / 4u]), vec2(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 368u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 372u) / 4u]), g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 376u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 380u) / 4u], vec2(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 384u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 388u) / 4u]), g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 392u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 396u) / 4u], vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 400u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 404u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 408u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 412u) / 4u]), vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 416u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 420u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 424u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 428u) / 4u]), vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 432u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 436u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 440u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 444u) / 4u]), g_MaterialData_7._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 448u) / 4u], g_MaterialData_7._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 452u) / 4u], g_MaterialData_7._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 456u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 460u) / 4u], mat4(vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 464u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 480u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 496u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 512u) / 4u]), vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 468u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 484u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 500u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 516u) / 4u]), vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 472u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 488u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 504u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 520u) / 4u]), vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 476u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 492u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 508u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 524u) / 4u])), mat4(vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 528u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 544u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 560u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 576u) / 4u]), vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 532u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 548u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 564u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 580u) / 4u]), vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 536u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 552u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 568u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 584u) / 4u]), vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 540u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 556u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 572u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 588u) / 4u])), g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 592u) / 4u], g_MaterialData_5._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 596u) / 4u] != 0, g_MaterialData_5._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 600u) / 4u] != 0, g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 604u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 608u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 612u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 616u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 620u) / 4u], vec3(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 624u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 628u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 632u) / 4u]), g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 636u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 640u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 644u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 648u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 652u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 656u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 660u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 664u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 668u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 672u) / 4u], g_MaterialData_7._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 676u) / 4u], g_MaterialData_7._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 680u) / 4u], g_MaterialData_7._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 684u) / 4u], g_MaterialData_7._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 688u) / 4u], g_MaterialData_7._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 692u) / 4u], g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 696u) / 4u], g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 700u) / 4u], g_MaterialData_7._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 704u) / 4u], g_MaterialData_7._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 708u) / 4u], g_MaterialData_7._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 712u) / 4u], g_MaterialData_5._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 716u) / 4u] != 0, g_MaterialData_5._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 720u) / 4u] != 0, g_MaterialData_5._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 724u) / 4u] != 0, g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 728u) / 4u], g_MaterialData_7._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 732u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 736u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 740u) / 4u], g_MaterialData_5._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 744u) / 4u] != 0, g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 748u) / 4u]);
	    _RTX_MATERIAL_DATA_ _g_rtx_material_data_ = _1533;
	    uvec3 _724;
	    do
	    {
	        if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes.w == 4)
	        {
	            uint _1594 = (12u * uint(gl_PrimitiveID)) + uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes.w);
	            _724 = uvec3(g_Indices_1[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._m0[_1594 / 4u], g_Indices_1[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._m0[(_1594 + 4u) / 4u], g_Indices_1[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._m0[(_1594 + 8u) / 4u]);
	            break;
	        }
	        else
	        {
	            uint _1569 = (6u * uint(gl_PrimitiveID)) + uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes.w);
	            uint _1570 = _1569 & 4294967292u;
	            uint _1571 = _1570 / 4u;
	            uint _1575 = (_1570 + 4u) / 4u;
	            uint _1580 = (g_Indices_1[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._m0[_1571] & 4294901760u) >> uint(16);
	            uint _1581 = g_Indices_1[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._m0[_1575] & 65535u;
	            uvec3 _725;
	            if (_1569 == _1570)
	            {
	                _725 = uvec3(g_Indices_1[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._m0[_1571] & 65535u, _1580, _1581);
	            }
	            else
	            {
	                _725 = uvec3(_1580, _1581, (g_Indices_1[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._m0[_1575] & 4294901760u) >> uint(16));
	            }
	            _724 = _725;
	            break;
	        }
	        break;
	    } while(false);
	    uint _1609 = uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.x);
	    uvec3 _1617 = (uvec3(uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes.x)) * _724) + uvec3(uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes.x));
	    vec3 _718[3];
	    uint _1619 = _1617.x;
	    _718[0] = vec3(g_Vertices_1[_1609]._m0[_1619 / 4u], g_Vertices_1[_1609]._m0[(_1619 + 4u) / 4u], g_Vertices_1[_1609]._m0[(_1619 + 8u) / 4u]);
	    uint _1633 = _1617.y;
	    _718[1] = vec3(g_Vertices_1[_1609]._m0[_1633 / 4u], g_Vertices_1[_1609]._m0[(_1633 + 4u) / 4u], g_Vertices_1[_1609]._m0[(_1633 + 8u) / 4u]);
	    uint _1647 = _1617.z;
	    _718[2] = vec3(g_Vertices_1[_1609]._m0[_1647 / 4u], g_Vertices_1[_1609]._m0[(_1647 + 4u) / 4u], g_Vertices_1[_1609]._m0[(_1647 + 8u) / 4u]);
	    int _719 = 0;
	    VS_INPUT vsInput[3];
	    for (;;)
	    {
	        if (!(_719 < 3))
	        {
	            break;
	        }
	        vsInput[_719].vColorBlendValues = _718[_719];
	        _719++;
	        continue;
	    }
	    vec2 _720[3];
	    _720[0] = vec2(0.0);
	    _720[1] = vec2(0.0);
	    _720[2] = vec2(0.0);
	    if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].y != 0)
	    {
	        ivec4 _717 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers;
	        uint _1690 = uint(_717[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].z]);
	        uint _1692 = uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].z);
	        ivec4 _715 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes;
	        ivec4 _716 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes;
	        uvec3 _1703 = (uvec3(uint(_715[_1692])) * _724) + uvec3(uint(_716[_1692]) + uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].x));
	        if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].y == 16)
	        {
	            uint _1838 = _1703.x;
	            _720[0] = vec2(g_Vertices_1[_1690]._m0[_1838 / 4u], g_Vertices_1[_1690]._m0[(_1838 + 4u) / 4u]);
	            uint _1847 = _1703.y;
	            _720[1] = vec2(g_Vertices_1[_1690]._m0[_1847 / 4u], g_Vertices_1[_1690]._m0[(_1847 + 4u) / 4u]);
	            uint _1856 = _1703.z;
	            _720[2] = vec2(g_Vertices_1[_1690]._m0[_1856 / 4u], g_Vertices_1[_1690]._m0[(_1856 + 4u) / 4u]);
	        }
	        else
	        {
	            if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].y == 34)
	            {
	                uint _1809 = _1703.x / 4u;
	                _720[0] = vec2(uint16BitsToFloat16(u16vec2(uvec2(g_Vertices_3[_1690]._m0[_1809], g_Vertices_3[_1690]._m0[_1809] >> uint(16)) & uvec2(65535u))));
	                uint _1819 = _1703.y / 4u;
	                _720[1] = vec2(uint16BitsToFloat16(u16vec2(uvec2(g_Vertices_3[_1690]._m0[_1819], g_Vertices_3[_1690]._m0[_1819] >> uint(16)) & uvec2(65535u))));
	                uint _1829 = _1703.z / 4u;
	                _720[2] = vec2(uint16BitsToFloat16(u16vec2(uvec2(g_Vertices_3[_1690]._m0[_1829], g_Vertices_3[_1690]._m0[_1829] >> uint(16)) & uvec2(65535u))));
	            }
	            else
	            {
	                if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].y == 37)
	                {
	                    uint _1716 = _1703.x / 4u;
	                    uint _1720 = (g_Vertices_3[_1690]._m0[_1716] & 65535u);
	                    int _714;
	                    if (_1720 > 32767u)
	                    {
	                        _714 = int(4294901760u | _1720);
	                    }
	                    else
	                    {
	                        _714 = int(_1720);
	                    }
	                    uint _1733 = (g_Vertices_3[_1690]._m0[_1716] & 4294901760u) >> uint(16);
	                    int _713;
	                    if (_1733 > 32767u)
	                    {
	                        _713 = int(4294901760u | _1733);
	                    }
	                    else
	                    {
	                        _713 = int(_1733);
	                    }
	                    _720[0] = vec2(max(float(_714) * 3.0518509447574615478515625e-05, -1.0), max(float(_713) * 3.0518509447574615478515625e-05, -1.0));
	                    uint _1747 = _1703.y / 4u;
	                    uint _1751 = (g_Vertices_3[_1690]._m0[_1747] & 65535u);
	                    int _712;
	                    if (_1751 > 32767u)
	                    {
	                        _712 = int(4294901760u | _1751);
	                    }
	                    else
	                    {
	                        _712 = int(_1751);
	                    }
	                    uint _1764 = (g_Vertices_3[_1690]._m0[_1747] & 4294901760u) >> uint(16);
	                    int _711;
	                    if (_1764 > 32767u)
	                    {
	                        _711 = int(4294901760u | _1764);
	                    }
	                    else
	                    {
	                        _711 = int(_1764);
	                    }
	                    _720[1] = vec2(max(float(_712) * 3.0518509447574615478515625e-05, -1.0), max(float(_711) * 3.0518509447574615478515625e-05, -1.0));
	                    uint _1778 = _1703.z / 4u;
	                    uint _1782 = (g_Vertices_3[_1690]._m0[_1778] & 65535u);
	                    int _710;
	                    if (_1782 > 32767u)
	                    {
	                        _710 = int(4294901760u | _1782);
	                    }
	                    else
	                    {
	                        _710 = int(_1782);
	                    }
	                    uint _1795 = (g_Vertices_3[_1690]._m0[_1778] & 4294901760u) >> uint(16);
	                    int _709;
	                    if (_1795 > 32767u)
	                    {
	                        _709 = int(4294901760u | _1795);
	                    }
	                    else
	                    {
	                        _709 = int(_1795);
	                    }
	                    _720[2] = vec2(max(float(_710) * 3.0518509447574615478515625e-05, -1.0), max(float(_709) * 3.0518509447574615478515625e-05, -1.0));
	                }
	            }
	        }
	    }
	    _719 = 0;
	    for (;;)
	    {
	        if (!(_719 < 3))
	        {
	            break;
	        }
	        vsInput[_719]._m1 = _720[_719];
	        _719++;
	        continue;
	    }
	    _720[0] = vec2(0.0);
	    _720[1] = vec2(0.0);
	    _720[2] = vec2(0.0);
	    if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[1].y != 0)
	    {
	        ivec4 _708 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers;
	        uint _1895 = uint(_708[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[1].z]);
	        uint _1897 = uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[1].z);
	        ivec4 _706 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes;
	        ivec4 _707 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes;
	        uvec3 _1908 = (uvec3(uint(_706[_1897])) * _724) + uvec3(uint(_707[_1897]) + uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[1].x));
	        if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[1].y == 16)
	        {
	            uint _2043 = _1908.x;
	            _720[0] = vec2(g_Vertices_1[_1895]._m0[_2043 / 4u], g_Vertices_1[_1895]._m0[(_2043 + 4u) / 4u]);
	            uint _2052 = _1908.y;
	            _720[1] = vec2(g_Vertices_1[_1895]._m0[_2052 / 4u], g_Vertices_1[_1895]._m0[(_2052 + 4u) / 4u]);
	            uint _2061 = _1908.z;
	            _720[2] = vec2(g_Vertices_1[_1895]._m0[_2061 / 4u], g_Vertices_1[_1895]._m0[(_2061 + 4u) / 4u]);
	        }
	        else
	        {
	            if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[1].y == 34)
	            {
	                uint _2014 = _1908.x / 4u;
	                _720[0] = vec2(uint16BitsToFloat16(u16vec2(uvec2(g_Vertices_3[_1895]._m0[_2014], g_Vertices_3[_1895]._m0[_2014] >> uint(16)) & uvec2(65535u))));
	                uint _2024 = _1908.y / 4u;
	                _720[1] = vec2(uint16BitsToFloat16(u16vec2(uvec2(g_Vertices_3[_1895]._m0[_2024], g_Vertices_3[_1895]._m0[_2024] >> uint(16)) & uvec2(65535u))));
	                uint _2034 = _1908.z / 4u;
	                _720[2] = vec2(uint16BitsToFloat16(u16vec2(uvec2(g_Vertices_3[_1895]._m0[_2034], g_Vertices_3[_1895]._m0[_2034] >> uint(16)) & uvec2(65535u))));
	            }
	            else
	            {
	                if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[1].y == 37)
	                {
	                    uint _1921 = _1908.x / 4u;
	                    uint _1925 = (g_Vertices_3[_1895]._m0[_1921] & 65535u);
	                    int _705;
	                    if (_1925 > 32767u)
	                    {
	                        _705 = int(4294901760u | _1925);
	                    }
	                    else
	                    {
	                        _705 = int(_1925);
	                    }
	                    uint _1938 = (g_Vertices_3[_1895]._m0[_1921] & 4294901760u) >> uint(16);
	                    int _704;
	                    if (_1938 > 32767u)
	                    {
	                        _704 = int(4294901760u | _1938);
	                    }
	                    else
	                    {
	                        _704 = int(_1938);
	                    }
	                    _720[0] = vec2(max(float(_705) * 3.0518509447574615478515625e-05, -1.0), max(float(_704) * 3.0518509447574615478515625e-05, -1.0));
	                    uint _1952 = _1908.y / 4u;
	                    uint _1956 = (g_Vertices_3[_1895]._m0[_1952] & 65535u);
	                    int _703;
	                    if (_1956 > 32767u)
	                    {
	                        _703 = int(4294901760u | _1956);
	                    }
	                    else
	                    {
	                        _703 = int(_1956);
	                    }
	                    uint _1969 = (g_Vertices_3[_1895]._m0[_1952] & 4294901760u) >> uint(16);
	                    int _702;
	                    if (_1969 > 32767u)
	                    {
	                        _702 = int(4294901760u | _1969);
	                    }
	                    else
	                    {
	                        _702 = int(_1969);
	                    }
	                    _720[1] = vec2(max(float(_703) * 3.0518509447574615478515625e-05, -1.0), max(float(_702) * 3.0518509447574615478515625e-05, -1.0));
	                    uint _1983 = _1908.z / 4u;
	                    uint _1987 = (g_Vertices_3[_1895]._m0[_1983] & 65535u);
	                    int _701;
	                    if (_1987 > 32767u)
	                    {
	                        _701 = int(4294901760u | _1987);
	                    }
	                    else
	                    {
	                        _701 = int(_1987);
	                    }
	                    uint _2000 = (g_Vertices_3[_1895]._m0[_1983] & 4294901760u) >> uint(16);
	                    int _700;
	                    if (_2000 > 32767u)
	                    {
	                        _700 = int(4294901760u | _2000);
	                    }
	                    else
	                    {
	                        _700 = int(_2000);
	                    }
	                    _720[2] = vec2(max(float(_701) * 3.0518509447574615478515625e-05, -1.0), max(float(_700) * 3.0518509447574615478515625e-05, -1.0));
	                }
	            }
	        }
	    }
	    _719 = 0;
	    for (;;)
	    {
	        if (!(_719 < 3))
	        {
	            break;
	        }
	        vsInput[_719]._m2 = _720[_719];
	        _719++;
	        continue;
	    }
	    vec3 _721[3];
	    vec4 _722[3];
	    do
	    {
	        if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.y != 0)
	        {
	            ivec4 _686 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers;
	            uint _2103 = uint(_686[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.z]);
	            uint _2105 = uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.z);
	            ivec4 _684 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes;
	            ivec4 _685 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes;
	            uvec3 _2116 = (uvec3(uint(_684[_2105])) * _724) + uvec3(uint(_685[_2105]) + uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.x));
	            if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.y == 6)
	            {
	                uint _2647 = _2116.x;
	                _721[0] = vec3(g_Vertices_1[_2103]._m0[_2647 / 4u], g_Vertices_1[_2103]._m0[(_2647 + 4u) / 4u], g_Vertices_1[_2103]._m0[(_2647 + 8u) / 4u]);
	                uint _2661 = _2116.y;
	                _721[1] = vec3(g_Vertices_1[_2103]._m0[_2661 / 4u], g_Vertices_1[_2103]._m0[(_2661 + 4u) / 4u], g_Vertices_1[_2103]._m0[(_2661 + 8u) / 4u]);
	                uint _2675 = _2116.z;
	                _721[2] = vec3(g_Vertices_1[_2103]._m0[_2675 / 4u], g_Vertices_1[_2103]._m0[(_2675 + 4u) / 4u], g_Vertices_1[_2103]._m0[(_2675 + 8u) / 4u]);
	            }
	            else
	            {
	                if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.y == 17)
	                {
	                    uint _2380 = _2116.x;
	                    uvec2 _2388 = uvec2(g_Vertices_3[_2103]._m0[_2380 / 4u], g_Vertices_3[_2103]._m0[(_2380 + 4u) / 4u]);
	                    uint _2389 = _2116.y;
	                    uvec2 _493 = uvec2(g_Vertices_3[_2103]._m0[_2389 / 4u], g_Vertices_3[_2103]._m0[(_2389 + 4u) / 4u]);
	                    uint _2398 = _2116.z;
	                    uvec2 _492 = uvec2(g_Vertices_3[_2103]._m0[_2398 / 4u], g_Vertices_3[_2103]._m0[(_2398 + 4u) / 4u]);
	                    uint _2410 = _2388.x;
	                    uint _2419 = _2388.y;
	                    vec2 _2429 = ((vec2(float((_2410) & 65535u), float((_2410 >> 16u) & 65535u)) * vec2(1.525902189314365386962890625e-05)) * 2.0) - vec2(1.0);
	                    float _2430 = _2429.x;
	                    float _2435 = (1.0 - abs(_2430)) - abs(_2429.y);
	                    vec3 _2436 = vec3(_2430, _2429.y, _2435);
	                    float _2438 = saturate(-_2435);
	                    vec2 _2444 = _2429 + mix(vec2(_2438), vec2(-_2438), greaterThanEqual(_2429, vec2(0.0)));
	                    _2436.x = _2444.x;
	                    _2436.y = _2444.y;
	                    vec3 _694 = normalize(_2436);
	                    vec2 _2451 = ((vec2(float((_2419 >> uint(1)) & 32767u), float((_2419 >> 16u) & 32767u)) * vec2(3.0518509447574615478515625e-05)) * 2.0) - vec2(1.0);
	                    float _2452 = _2451.x;
	                    float _2457 = (1.0 - abs(_2452)) - abs(_2451.y);
	                    vec3 _2458 = vec3(_2452, _2451.y, _2457);
	                    float _2460 = saturate(-_2457);
	                    vec2 _2466 = _2451 + mix(vec2(_2460), vec2(-_2460), greaterThanEqual(_2451, vec2(0.0)));
	                    _2458.x = _2466.x;
	                    _2458.y = _2466.y;
	                    vec3 _693 = normalize(_2458);
	                    float _674;
	                    if ((_2419 & 1u) != 0u)
	                    {
	                        _674 = 1.0;
	                    }
	                    else
	                    {
	                        _674 = -1.0;
	                    }
	                    _721[0] = _694;
	                    _722[0].w = _674;
	                    _722[0].x = _693.x;
	                    _722[0].y = _693.y;
	                    _722[0].z = _693.z;
	                    vec2 _2509 = ((vec2(float((_493.x) & 65535u), float((_493.x >> 16u) & 65535u)) * vec2(1.525902189314365386962890625e-05)) * 2.0) - vec2(1.0);
	                    float _2510 = _2509.x;
	                    float _2515 = (1.0 - abs(_2510)) - abs(_2509.y);
	                    vec3 _2516 = vec3(_2510, _2509.y, _2515);
	                    float _2518 = saturate(-_2515);
	                    vec2 _2524 = _2509 + mix(vec2(_2518), vec2(-_2518), greaterThanEqual(_2509, vec2(0.0)));
	                    _2516.x = _2524.x;
	                    _2516.y = _2524.y;
	                    vec3 _696 = normalize(_2516);
	                    vec2 _2531 = ((vec2(float((_493.y >> uint(1)) & 32767u), float((_493.y >> 16u) & 32767u)) * vec2(3.0518509447574615478515625e-05)) * 2.0) - vec2(1.0);
	                    float _2532 = _2531.x;
	                    float _2537 = (1.0 - abs(_2532)) - abs(_2531.y);
	                    vec3 _2538 = vec3(_2532, _2531.y, _2537);
	                    float _2540 = saturate(-_2537);
	                    vec2 _2546 = _2531 + mix(vec2(_2540), vec2(-_2540), greaterThanEqual(_2531, vec2(0.0)));
	                    _2538.x = _2546.x;
	                    _2538.y = _2546.y;
	                    vec3 _695 = normalize(_2538);
	                    float _673;
	                    if ((_493.y & 1u) != 0u)
	                    {
	                        _673 = 1.0;
	                    }
	                    else
	                    {
	                        _673 = -1.0;
	                    }
	                    _721[1] = _696;
	                    _722[1].w = _673;
	                    _722[1].x = _695.x;
	                    _722[1].y = _695.y;
	                    _722[1].z = _695.z;
	                    vec2 _2589 = ((vec2(float((_492.x) & 65535u), float((_492.x >> 16u) & 65535u)) * vec2(1.525902189314365386962890625e-05)) * 2.0) - vec2(1.0);
	                    float _2590 = _2589.x;
	                    float _2595 = (1.0 - abs(_2590)) - abs(_2589.y);
	                    vec3 _2596 = vec3(_2590, _2589.y, _2595);
	                    float _2598 = saturate(-_2595);
	                    vec2 _2604 = _2589 + mix(vec2(_2598), vec2(-_2598), greaterThanEqual(_2589, vec2(0.0)));
	                    _2596.x = _2604.x;
	                    _2596.y = _2604.y;
	                    vec3 _698 = normalize(_2596);
	                    vec2 _2611 = ((vec2(float((_492.y >> uint(1)) & 32767u), float((_492.y >> 16u) & 32767u)) * vec2(3.0518509447574615478515625e-05)) * 2.0) - vec2(1.0);
	                    float _2612 = _2611.x;
	                    float _2617 = (1.0 - abs(_2612)) - abs(_2611.y);
	                    vec3 _2618 = vec3(_2612, _2611.y, _2617);
	                    float _2620 = saturate(-_2617);
	                    vec2 _2626 = _2611 + mix(vec2(_2620), vec2(-_2620), greaterThanEqual(_2611, vec2(0.0)));
	                    _2618.x = _2626.x;
	                    _2618.y = _2626.y;
	                    vec3 _697 = normalize(_2618);
	                    float _672;
	                    if ((_492.y & 1u) != 0u)
	                    {
	                        _672 = 1.0;
	                    }
	                    else
	                    {
	                        _672 = -1.0;
	                    }
	                    _721[2] = _698;
	                    _722[2].w = _672;
	                    _722[2].x = _697.x;
	                    _722[2].y = _697.y;
	                    _722[2].z = _697.z;
	                    break;
	                }
	                else
	                {
	                    uint _2126 = _2116.x / 4u;
	                    vec4 _688 = _722[0];
	                    float _2141 = (float((g_Vertices_3[_2103]._m0[_2126] >> 12u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _2144 = (float((g_Vertices_3[_2103]._m0[_2126] >> 22u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _2148 = (1.0 - abs(_2141)) - abs(_2144);
	                    vec3 _2149 = vec3(_2141, _2144, _2148);
	                    float _2151 = saturate(-_2148);
	                    vec2 _2152 = vec2(_2141, _2144);
	                    vec2 _2158 = _2152 + mix(vec2(_2151), vec2(-_2151), greaterThanEqual(_2152, vec2(0.0)));
	                    _2149.x = _2158.x;
	                    _2149.y = _2158.y;
	                    vec3 _2163 = normalize(_2149);
	                    vec3 _687 = _2163;
	                    float _2164 = _2163.z;
	                    float _681;
	                    if (_2164 >= 0.0)
	                    {
	                        _681 = 1.0;
	                    }
	                    else
	                    {
	                        _681 = -1.0;
	                    }
	                    float _2171 = (-1.0) / (_681 + _2164);
	                    float _2172 = _2163.x;
	                    vec3 _682;
	                    vec3 _2180 = _682;
	                    _2180.x = 1.0 + (((_681 * _2172) * _2172) * _2171);
	                    _2180.y = _681 * ((_2172 * _2163.y) * _2171);
	                    _2180.z = (-_681) * _2172;
	                    _682 = _2180;
	                    float _2188 = float((g_Vertices_3[_2103]._m0[_2126] >> uint(1)) & 2047u) * 0.003069460391998291015625;
	                    vec3 _2194 = (_2180 * cos(_2188)) + (cross(_2163, _2180) * sin(_2188));
	                    vec4 _2196 = _688;
	                    _2196.x = _2194.x;
	                    _2196.y = _2194.y;
	                    _2196.z = _2194.z;
	                    _688 = _2196;
	                    float _683;
	                    if ((g_Vertices_3[_2103]._m0[_2126] & 1u) == 0u)
	                    {
	                        _683 = -1.0;
	                    }
	                    else
	                    {
	                        _683 = 1.0;
	                    }
	                    vec4 _2207 = _688;
	                    _2207.w = _683;
	                    _688 = _2207;
	                    _721[0] = _687;
	                    _722[0] = _2207;
	                    uint _2211 = _2116.y / 4u;
	                    vec4 _690 = _722[1];
	                    float _2226 = (float((g_Vertices_3[_2103]._m0[_2211] >> 12u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _2229 = (float((g_Vertices_3[_2103]._m0[_2211] >> 22u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _2233 = (1.0 - abs(_2226)) - abs(_2229);
	                    vec3 _2234 = vec3(_2226, _2229, _2233);
	                    float _2236 = saturate(-_2233);
	                    vec2 _2237 = vec2(_2226, _2229);
	                    vec2 _2243 = _2237 + mix(vec2(_2236), vec2(-_2236), greaterThanEqual(_2237, vec2(0.0)));
	                    _2234.x = _2243.x;
	                    _2234.y = _2243.y;
	                    vec3 _2248 = normalize(_2234);
	                    vec3 _689 = _2248;
	                    float _2249 = _2248.z;
	                    float _678;
	                    if (_2249 >= 0.0)
	                    {
	                        _678 = 1.0;
	                    }
	                    else
	                    {
	                        _678 = -1.0;
	                    }
	                    float _2256 = (-1.0) / (_678 + _2249);
	                    float _2257 = _2248.x;
	                    vec3 _679;
	                    vec3 _2265 = _679;
	                    _2265.x = 1.0 + (((_678 * _2257) * _2257) * _2256);
	                    _2265.y = _678 * ((_2257 * _2248.y) * _2256);
	                    _2265.z = (-_678) * _2257;
	                    _679 = _2265;
	                    float _2273 = float((g_Vertices_3[_2103]._m0[_2211] >> uint(1)) & 2047u) * 0.003069460391998291015625;
	                    vec3 _2279 = (_2265 * cos(_2273)) + (cross(_2248, _2265) * sin(_2273));
	                    vec4 _2281 = _690;
	                    _2281.x = _2279.x;
	                    _2281.y = _2279.y;
	                    _2281.z = _2279.z;
	                    _690 = _2281;
	                    float _680;
	                    if ((g_Vertices_3[_2103]._m0[_2211] & 1u) == 0u)
	                    {
	                        _680 = -1.0;
	                    }
	                    else
	                    {
	                        _680 = 1.0;
	                    }
	                    vec4 _2292 = _690;
	                    _2292.w = _680;
	                    _690 = _2292;
	                    _721[1] = _689;
	                    _722[1] = _2292;
	                    uint _2296 = _2116.z / 4u;
	                    vec4 _692 = _722[2];
	                    float _2311 = (float((g_Vertices_3[_2103]._m0[_2296] >> 12u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _2314 = (float((g_Vertices_3[_2103]._m0[_2296] >> 22u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _2318 = (1.0 - abs(_2311)) - abs(_2314);
	                    vec3 _2319 = vec3(_2311, _2314, _2318);
	                    float _2321 = saturate(-_2318);
	                    vec2 _2322 = vec2(_2311, _2314);
	                    vec2 _2328 = _2322 + mix(vec2(_2321), vec2(-_2321), greaterThanEqual(_2322, vec2(0.0)));
	                    _2319.x = _2328.x;
	                    _2319.y = _2328.y;
	                    vec3 _2333 = normalize(_2319);
	                    vec3 _691 = _2333;
	                    float _2334 = _2333.z;
	                    float _675;
	                    if (_2334 >= 0.0)
	                    {
	                        _675 = 1.0;
	                    }
	                    else
	                    {
	                        _675 = -1.0;
	                    }
	                    float _2341 = (-1.0) / (_675 + _2334);
	                    float _2342 = _2333.x;
	                    vec3 _676;
	                    vec3 _2350 = _676;
	                    _2350.x = 1.0 + (((_675 * _2342) * _2342) * _2341);
	                    _2350.y = _675 * ((_2342 * _2333.y) * _2341);
	                    _2350.z = (-_675) * _2342;
	                    _676 = _2350;
	                    float _2358 = float((g_Vertices_3[_2103]._m0[_2296] >> uint(1)) & 2047u) * 0.003069460391998291015625;
	                    vec3 _2364 = (_2350 * cos(_2358)) + (cross(_2333, _2350) * sin(_2358));
	                    vec4 _2366 = _692;
	                    _2366.x = _2364.x;
	                    _2366.y = _2364.y;
	                    _2366.z = _2364.z;
	                    _692 = _2366;
	                    float _677;
	                    if ((g_Vertices_3[_2103]._m0[_2296] & 1u) == 0u)
	                    {
	                        _677 = -1.0;
	                    }
	                    else
	                    {
	                        _677 = 1.0;
	                    }
	                    vec4 _2377 = _692;
	                    _2377.w = _677;
	                    _692 = _2377;
	                    _721[2] = _691;
	                    _722[2] = _2377;
	                    break;
	                }
	                break;
	            }
	        }
	        else
	        {
	            _721[0] = vec3(0.0);
	            _721[1] = vec3(0.0);
	            _721[2] = vec3(0.0);
	        }
	        if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTangentFieldInfo.y != 0)
	        {
	            ivec4 _699 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers;
	            uint _2700 = uint(_699[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTangentFieldInfo.z]);
	            uint _2702 = uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTangentFieldInfo.z);
	            ivec4 _670 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes;
	            ivec4 _671 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes;
	            uvec3 _2713 = (uvec3(uint(_670[_2702])) * _724) + uvec3(uint(_671[_2702]) + uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTangentFieldInfo.x));
	            uint _2715 = _2713.x;
	            _722[0] = vec4(g_Vertices_1[_2700]._m0[_2715 / 4u], g_Vertices_1[_2700]._m0[(_2715 + 4u) / 4u], g_Vertices_1[_2700]._m0[(_2715 + 8u) / 4u], g_Vertices_1[_2700]._m0[(_2715 + 12u) / 4u]);
	            uint _2733 = _2713.y;
	            _722[1] = vec4(g_Vertices_1[_2700]._m0[_2733 / 4u], g_Vertices_1[_2700]._m0[(_2733 + 4u) / 4u], g_Vertices_1[_2700]._m0[(_2733 + 8u) / 4u], g_Vertices_1[_2700]._m0[(_2733 + 12u) / 4u]);
	            uint _2751 = _2713.z;
	            _722[2] = vec4(g_Vertices_1[_2700]._m0[_2751 / 4u], g_Vertices_1[_2700]._m0[(_2751 + 4u) / 4u], g_Vertices_1[_2700]._m0[(_2751 + 8u) / 4u], g_Vertices_1[_2700]._m0[(_2751 + 12u) / 4u]);
	        }
	        else
	        {
	            _722[0] = vec4(0.0);
	            _722[1] = vec4(0.0);
	            _722[2] = vec4(0.0);
	        }
	        break;
	    } while(false);
	    _719 = 0;
	    for (;;)
	    {
	        if (!(_719 < 3))
	        {
	            break;
	        }
	        vsInput[_719]._m3 = _721[_719];
	        vsInput[_719]._m4 = _722[_719];
	        _719++;
	        continue;
	    }
	    vec4 _723[3];
	    if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vColorFieldInfo.data[0].y != 0)
	    {
	        ivec4 _669 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers;
	        uint _2802 = uint(_669[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vColorFieldInfo.data[0].z]);
	        uint _2804 = uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vColorFieldInfo.data[0].z);
	        ivec4 _667 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes;
	        ivec4 _668 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes;
	        uvec3 _2815 = (uvec3(uint(_667[_2804])) * _724) + uvec3(uint(_668[_2804]) + uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vColorFieldInfo.data[0].x));
	        if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vColorFieldInfo.data[0].y == 2)
	        {
	            uint _2869 = _2815.x;
	            _723[0] = vec4(g_Vertices_1[_2802]._m0[_2869 / 4u], g_Vertices_1[_2802]._m0[(_2869 + 4u) / 4u], g_Vertices_1[_2802]._m0[(_2869 + 8u) / 4u], g_Vertices_1[_2802]._m0[(_2869 + 12u) / 4u]);
	            uint _2887 = _2815.y;
	            _723[1] = vec4(g_Vertices_1[_2802]._m0[_2887 / 4u], g_Vertices_1[_2802]._m0[(_2887 + 4u) / 4u], g_Vertices_1[_2802]._m0[(_2887 + 8u) / 4u], g_Vertices_1[_2802]._m0[(_2887 + 12u) / 4u]);
	            uint _2905 = _2815.z;
	            _723[2] = vec4(g_Vertices_1[_2802]._m0[_2905 / 4u], g_Vertices_1[_2802]._m0[(_2905 + 4u) / 4u], g_Vertices_1[_2802]._m0[(_2905 + 8u) / 4u], g_Vertices_1[_2802]._m0[(_2905 + 12u) / 4u]);
	        }
	        else
	        {
	            uint _2822 = _2815.x / 4u;
	            _723[0] = vec4(uvec4((g_Vertices_3[_2802]._m0[_2822] & 255u), (g_Vertices_3[_2802]._m0[_2822] & 65280u) >> uint(8), (g_Vertices_3[_2802]._m0[_2822] & 16711680u) >> uint(16), (g_Vertices_3[_2802]._m0[_2822] & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	            uint _2838 = _2815.y / 4u;
	            _723[1] = vec4(uvec4((g_Vertices_3[_2802]._m0[_2838] & 255u), (g_Vertices_3[_2802]._m0[_2838] & 65280u) >> uint(8), (g_Vertices_3[_2802]._m0[_2838] & 16711680u) >> uint(16), (g_Vertices_3[_2802]._m0[_2838] & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	            uint _2854 = _2815.z / 4u;
	            _723[2] = vec4(uvec4((g_Vertices_3[_2802]._m0[_2854] & 255u), (g_Vertices_3[_2802]._m0[_2854] & 65280u) >> uint(8), (g_Vertices_3[_2802]._m0[_2854] & 16711680u) >> uint(16), (g_Vertices_3[_2802]._m0[_2854] & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	        }
	    }
	    else
	    {
	        _723[0] = vec4(0.0);
	        _723[1] = vec4(0.0);
	        _723[2] = vec4(0.0);
	    }
	    _719 = 0;
	    for (;;)
	    {
	        if (!(_719 < 3))
	        {
	            break;
	        }
	        vsInput[_719]._m7 = _723[_719];
	        _719++;
	        continue;
	    }
	    vec4 _726[3];
	    _726[0] = vec4(0.0);
	    _726[1] = vec4(0.0);
	    _726[2] = vec4(0.0);
	    if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[4].y != 0)
	    {
	        ivec4 _666 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers;
	        uint _2956 = uint(_666[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[4].z]);
	        uint _2958 = uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[4].z);
	        ivec4 _664 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes;
	        ivec4 _665 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes;
	        uvec3 _2969 = (uvec3(uint(_664[_2958])) * _724) + uvec3(uint(_665[_2958]) + uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[4].x));
	        if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[4].y == 2)
	        {
	            uint _3022 = _2969.x;
	            _726[0] = vec4(g_Vertices_1[_2956]._m0[_3022 / 4u], g_Vertices_1[_2956]._m0[(_3022 + 4u) / 4u], g_Vertices_1[_2956]._m0[(_3022 + 8u) / 4u], g_Vertices_1[_2956]._m0[(_3022 + 12u) / 4u]);
	            uint _3039 = _2969.y;
	            _726[1] = vec4(g_Vertices_1[_2956]._m0[_3039 / 4u], g_Vertices_1[_2956]._m0[(_3039 + 4u) / 4u], g_Vertices_1[_2956]._m0[(_3039 + 8u) / 4u], g_Vertices_1[_2956]._m0[(_3039 + 12u) / 4u]);
	            uint _3056 = _2969.z;
	            _726[2] = vec4(g_Vertices_1[_2956]._m0[_3056 / 4u], g_Vertices_1[_2956]._m0[(_3056 + 4u) / 4u], g_Vertices_1[_2956]._m0[(_3056 + 8u) / 4u], g_Vertices_1[_2956]._m0[(_3056 + 12u) / 4u]);
	        }
	        else
	        {
	            if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[4].y == 28)
	            {
	                uint _2978 = _2969.x / 4u;
	                _726[0] = vec4(uvec4((g_Vertices_3[_2956]._m0[_2978] & 255u), (g_Vertices_3[_2956]._m0[_2978] & 65280u) >> uint(8), (g_Vertices_3[_2956]._m0[_2978] & 16711680u) >> uint(16), (g_Vertices_3[_2956]._m0[_2978] & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	                uint _2993 = _2969.y / 4u;
	                _726[1] = vec4(uvec4((g_Vertices_3[_2956]._m0[_2993] & 255u), (g_Vertices_3[_2956]._m0[_2993] & 65280u) >> uint(8), (g_Vertices_3[_2956]._m0[_2993] & 16711680u) >> uint(16), (g_Vertices_3[_2956]._m0[_2993] & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	                uint _3008 = _2969.z / 4u;
	                _726[2] = vec4(uvec4((g_Vertices_3[_2956]._m0[_3008] & 255u), (g_Vertices_3[_2956]._m0[_3008] & 65280u) >> uint(8), (g_Vertices_3[_2956]._m0[_3008] & 16711680u) >> uint(16), (g_Vertices_3[_2956]._m0[_3008] & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	            }
	        }
	    }
	    int _727 = 0;
	    for (;;)
	    {
	        if (!(_727 < 3))
	        {
	            break;
	        }
	        vsInput[_727]._m8 = _726[_727];
	        _727++;
	        continue;
	    }
	    vec3 _661 = vsInput[0]._m3;
	    vec4 _662;
	    vec4 _3097 = _662;
	    _3097.x = vsInput[0]._m4.x;
	    _3097.y = vsInput[0]._m4.y;
	    _3097.z = vsInput[0]._m4.z;
	    _3097.w = vsInput[0]._m4.w;
	    _662 = _3097;
	    vec4 _3122 = vec4(uvec4((g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 255u), (g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 65280u) >> uint(8), (g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 16711680u) >> uint(16), (g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	    vec4 _660 = _3122;
	    vec3 _3123 = _3122.xyz;
	    vec3 _3124 = _3123 * vec3(0.077399380505084991455078125);
	    vec3 _3127 = pow((_3123 * vec3(0.947867333889007568359375)) + vec3(0.052132703363895416259765625), vec3(2.400000095367431640625));
	    float _657;
	    if (_3122.x <= 0.040449999272823333740234375)
	    {
	        _657 = _3124.x;
	    }
	    else
	    {
	        _657 = _3127.x;
	    }
	    float _658;
	    if (_3122.y <= 0.040449999272823333740234375)
	    {
	        _658 = _3124.y;
	    }
	    else
	    {
	        _658 = _3127.y;
	    }
	    float _659;
	    if (_3122.z <= 0.040449999272823333740234375)
	    {
	        _659 = _3124.z;
	    }
	    else
	    {
	        _659 = _3127.z;
	    }
	    vec3 _3152 = vec3(_657, _658, _659);
	    vec4 _3154 = _660;
	    _3154.x = _3152.x;
	    _3154.y = _3152.y;
	    _3154.z = _3152.z;
	    _660 = _3154;
	    vec4 _510;
	    vec4 _3161 = _510;
	    _3161.x = _3154.x;
	    _3161.y = _3154.y;
	    _3161.z = _3154.z;
	    _3161.w = _3154.w;
	    _510 = _3161;
	    mat3x4 _3172 = transpose(gl_WorldToObjectEXT);
	    mat3 _656;
	    mat3 _3175 = _656;
	    _3175[0] = _3172[0].xyz;
	    _3175[1] = _3172[1].xyz;
	    _3175[2] = _3172[2].xyz;
	    _656 = _3175;
	    vec3 _3184 = normalize(_3175 * _661.xyz);
	    vec3 _511;
	    vec3 _3186 = _511;
	    _3186.x = _3184.x;
	    _3186.y = _3184.y;
	    _3186.z = _3184.z;
	    _511 = _3186;
	    mat3x4 _3198 = transpose(gl_WorldToObjectEXT);
	    mat3 _655;
	    mat3 _3201 = _655;
	    _3201[0] = _3198[0].xyz;
	    _3201[1] = _3198[1].xyz;
	    _3201[2] = _3198[2].xyz;
	    _655 = _3201;
	    vec3 _3210 = normalize(_3201 * _662.xyz);
	    vec4 _509;
	    vec4 _3212 = _509;
	    _3212.x = _3210.x;
	    _3212.y = _3210.y;
	    _3212.z = _3210.z;
	    _3212.w = _662.w;
	    _509 = _3212;
	    vec4 _3221 = vsInput[0]._m1.xyxy;
	    _3221.z = vsInput[0]._m2.x;
	    _3221.w = vsInput[0]._m2.y;
	    vec4 _512;
	    vec4 _508 = _512;
	    vec3 _507 = vec4(vsInput[0].vColorBlendValues.xyz, 1.0) * transpose(gl_ObjectToWorldEXT);
	    vec3 _506 = _3186;
	    vec4 _505 = _3221;
	    vec4 _504 = _3161;
	    vec4 _503 = _3212;
	    if (_g_rtx_material_data_._m38 > 0)
	    {
	        vec2 _663;
	        if (_g_rtx_material_data_._m38 == 2)
	        {
	            _663 = _3221.zw;
	        }
	        else
	        {
	            _663 = _3221.xy;
	        }
	        vec4 _3243 = _505;
	        _3243.x = _663.x;
	        _3243.y = _663.y;
	        vec4 _3262 = _3243;
	        _3262.x = dot(_3243.xy, _g_rtx_material_data_._m45.xy) + _g_rtx_material_data_._m45.w;
	        _3262.y = dot(_3243.xy, _g_rtx_material_data_._m46.xy) + _g_rtx_material_data_._m46.w;
	        _505 = _3262;
	    }
	    vec4 _3264 = _504;
	    vec4 _3266 = _508;
	    _3266.x = _3264.x;
	    _3266.y = _3264.y;
	    _3266.z = _3264.z;
	    _3266.w = _g_rtx_material_data_._m29 * (1.0 - min(_3266.x, min(_3266.y, _3266.z)));
	    _508 = _3266;
	    _3264.x = _g_rtx_material_data_._m28.x;
	    _3264.y = _g_rtx_material_data_._m28.y;
	    _3264.z = _g_rtx_material_data_._m28.z;
	    vec3 _3295 = _3264.xyz * mix(vec3(1.0), vsInput[0]._m7.xyz, vec3(vsInput[0]._m7.w));
	    vec4 _3297 = _3264;
	    _3297.x = _3295.x;
	    _3297.y = _3295.y;
	    _3297.z = _3295.z;
	    _504 = _3297;
	    vec4 _491 = _3266;
	    vec3 _490 = _507;
	    vec3 _489 = _506;
	    vec4 _488 = _505;
	    vec4 _487 = _3297;
	    vec4 _486 = _503;
	    vec3 _652 = vsInput[1]._m3;
	    vec4 _653;
	    vec4 _3311 = _653;
	    _3311.x = vsInput[1]._m4.x;
	    _3311.y = vsInput[1]._m4.y;
	    _3311.z = vsInput[1]._m4.z;
	    _3311.w = vsInput[1]._m4.w;
	    _653 = _3311;
	    vec4 _3336 = vec4(uvec4((g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 255u), (g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 65280u) >> uint(8), (g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 16711680u) >> uint(16), (g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	    vec4 _651 = _3336;
	    vec3 _3337 = _3336.xyz;
	    vec3 _3338 = _3337 * vec3(0.077399380505084991455078125);
	    vec3 _3341 = pow((_3337 * vec3(0.947867333889007568359375)) + vec3(0.052132703363895416259765625), vec3(2.400000095367431640625));
	    float _648;
	    if (_3336.x <= 0.040449999272823333740234375)
	    {
	        _648 = _3338.x;
	    }
	    else
	    {
	        _648 = _3341.x;
	    }
	    float _649;
	    if (_3336.y <= 0.040449999272823333740234375)
	    {
	        _649 = _3338.y;
	    }
	    else
	    {
	        _649 = _3341.y;
	    }
	    float _650;
	    if (_3336.z <= 0.040449999272823333740234375)
	    {
	        _650 = _3338.z;
	    }
	    else
	    {
	        _650 = _3341.z;
	    }
	    vec3 _3366 = vec3(_648, _649, _650);
	    vec4 _3368 = _651;
	    _3368.x = _3366.x;
	    _3368.y = _3366.y;
	    _3368.z = _3366.z;
	    _651 = _3368;
	    vec4 _520;
	    vec4 _3375 = _520;
	    _3375.x = _3368.x;
	    _3375.y = _3368.y;
	    _3375.z = _3368.z;
	    _3375.w = _3368.w;
	    _520 = _3375;
	    mat3x4 _3386 = transpose(gl_WorldToObjectEXT);
	    mat3 _647;
	    mat3 _3389 = _647;
	    _3389[0] = _3386[0].xyz;
	    _3389[1] = _3386[1].xyz;
	    _3389[2] = _3386[2].xyz;
	    _647 = _3389;
	    vec3 _3398 = normalize(_3389 * _652.xyz);
	    vec3 _521;
	    vec3 _3400 = _521;
	    _3400.x = _3398.x;
	    _3400.y = _3398.y;
	    _3400.z = _3398.z;
	    _521 = _3400;
	    mat3x4 _3412 = transpose(gl_WorldToObjectEXT);
	    mat3 _646;
	    mat3 _3415 = _646;
	    _3415[0] = _3412[0].xyz;
	    _3415[1] = _3412[1].xyz;
	    _3415[2] = _3412[2].xyz;
	    _646 = _3415;
	    vec3 _3424 = normalize(_3415 * _653.xyz);
	    vec4 _519;
	    vec4 _3426 = _519;
	    _3426.x = _3424.x;
	    _3426.y = _3424.y;
	    _3426.z = _3424.z;
	    _3426.w = _653.w;
	    _519 = _3426;
	    vec4 _3435 = vsInput[1]._m1.xyxy;
	    _3435.z = vsInput[1]._m2.x;
	    _3435.w = vsInput[1]._m2.y;
	    vec4 _522;
	    vec4 _518 = _522;
	    vec3 _517 = vec4(vsInput[1].vColorBlendValues.xyz, 1.0) * transpose(gl_ObjectToWorldEXT);
	    vec3 _516 = _3400;
	    vec4 _515 = _3435;
	    vec4 _514 = _3375;
	    vec4 _513 = _3426;
	    if (_g_rtx_material_data_._m38 > 0)
	    {
	        vec2 _654;
	        if (_g_rtx_material_data_._m38 == 2)
	        {
	            _654 = _3435.zw;
	        }
	        else
	        {
	            _654 = _3435.xy;
	        }
	        vec4 _3457 = _515;
	        _3457.x = _654.x;
	        _3457.y = _654.y;
	        vec4 _3476 = _3457;
	        _3476.x = dot(_3457.xy, _g_rtx_material_data_._m45.xy) + _g_rtx_material_data_._m45.w;
	        _3476.y = dot(_3457.xy, _g_rtx_material_data_._m46.xy) + _g_rtx_material_data_._m46.w;
	        _515 = _3476;
	    }
	    vec4 _3478 = _514;
	    vec4 _3480 = _518;
	    _3480.x = _3478.x;
	    _3480.y = _3478.y;
	    _3480.z = _3478.z;
	    _3480.w = _g_rtx_material_data_._m29 * (1.0 - min(_3480.x, min(_3480.y, _3480.z)));
	    _518 = _3480;
	    _3478.x = _g_rtx_material_data_._m28.x;
	    _3478.y = _g_rtx_material_data_._m28.y;
	    _3478.z = _g_rtx_material_data_._m28.z;
	    vec3 _3509 = _3478.xyz * mix(vec3(1.0), vsInput[1]._m7.xyz, vec3(vsInput[1]._m7.w));
	    vec4 _3511 = _3478;
	    _3511.x = _3509.x;
	    _3511.y = _3509.y;
	    _3511.z = _3509.z;
	    _514 = _3511;
	    vec4 _485 = _3480;
	    vec3 _484 = _517;
	    vec3 _483 = _516;
	    vec4 _482 = _515;
	    vec4 _481 = _3511;
	    vec4 _480 = _513;
	    vec3 _643 = vsInput[2]._m3;
	    vec4 _644;
	    vec4 _3525 = _644;
	    _3525.x = vsInput[2]._m4.x;
	    _3525.y = vsInput[2]._m4.y;
	    _3525.z = vsInput[2]._m4.z;
	    _3525.w = vsInput[2]._m4.w;
	    _644 = _3525;
	    vec4 _3550 = vec4(uvec4((g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 255u), (g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 65280u) >> uint(8), (g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 16711680u) >> uint(16), (g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	    vec4 _642 = _3550;
	    vec3 _3551 = _3550.xyz;
	    vec3 _3552 = _3551 * vec3(0.077399380505084991455078125);
	    vec3 _3555 = pow((_3551 * vec3(0.947867333889007568359375)) + vec3(0.052132703363895416259765625), vec3(2.400000095367431640625));
	    float _639;
	    if (_3550.x <= 0.040449999272823333740234375)
	    {
	        _639 = _3552.x;
	    }
	    else
	    {
	        _639 = _3555.x;
	    }
	    float _640;
	    if (_3550.y <= 0.040449999272823333740234375)
	    {
	        _640 = _3552.y;
	    }
	    else
	    {
	        _640 = _3555.y;
	    }
	    float _641;
	    if (_3550.z <= 0.040449999272823333740234375)
	    {
	        _641 = _3552.z;
	    }
	    else
	    {
	        _641 = _3555.z;
	    }
	    vec3 _3580 = vec3(_639, _640, _641);
	    vec4 _3582 = _642;
	    _3582.x = _3580.x;
	    _3582.y = _3580.y;
	    _3582.z = _3580.z;
	    _642 = _3582;
	    vec4 _530;
	    vec4 _3589 = _530;
	    _3589.x = _3582.x;
	    _3589.y = _3582.y;
	    _3589.z = _3582.z;
	    _3589.w = _3582.w;
	    _530 = _3589;
	    mat3x4 _3600 = transpose(gl_WorldToObjectEXT);
	    mat3 _638;
	    mat3 _3603 = _638;
	    _3603[0] = _3600[0].xyz;
	    _3603[1] = _3600[1].xyz;
	    _3603[2] = _3600[2].xyz;
	    _638 = _3603;
	    vec3 _3612 = normalize(_3603 * _643.xyz);
	    vec3 _531;
	    vec3 _3614 = _531;
	    _3614.x = _3612.x;
	    _3614.y = _3612.y;
	    _3614.z = _3612.z;
	    _531 = _3614;
	    mat3x4 _3626 = transpose(gl_WorldToObjectEXT);
	    mat3 _637;
	    mat3 _3629 = _637;
	    _3629[0] = _3626[0].xyz;
	    _3629[1] = _3626[1].xyz;
	    _3629[2] = _3626[2].xyz;
	    _637 = _3629;
	    vec3 _3638 = normalize(_3629 * _644.xyz);
	    vec4 _529;
	    vec4 _3640 = _529;
	    _3640.x = _3638.x;
	    _3640.y = _3638.y;
	    _3640.z = _3638.z;
	    _3640.w = _644.w;
	    _529 = _3640;
	    vec4 _3649 = vsInput[2]._m1.xyxy;
	    _3649.z = vsInput[2]._m2.x;
	    _3649.w = vsInput[2]._m2.y;
	    vec4 _532;
	    vec4 _528 = _532;
	    vec3 _527 = vec4(vsInput[2].vColorBlendValues.xyz, 1.0) * transpose(gl_ObjectToWorldEXT);
	    vec3 _526 = _3614;
	    vec4 _525 = _3649;
	    vec4 _524 = _3589;
	    vec4 _523 = _3640;
	    if (_g_rtx_material_data_._m38 > 0)
	    {
	        vec2 _645;
	        if (_g_rtx_material_data_._m38 == 2)
	        {
	            _645 = _3649.zw;
	        }
	        else
	        {
	            _645 = _3649.xy;
	        }
	        vec4 _3671 = _525;
	        _3671.x = _645.x;
	        _3671.y = _645.y;
	        vec4 _3690 = _3671;
	        _3690.x = dot(_3671.xy, _g_rtx_material_data_._m45.xy) + _g_rtx_material_data_._m45.w;
	        _3690.y = dot(_3671.xy, _g_rtx_material_data_._m46.xy) + _g_rtx_material_data_._m46.w;
	        _525 = _3690;
	    }
	    vec4 _3692 = _524;
	    vec4 _3694 = _528;
	    _3694.x = _3692.x;
	    _3694.y = _3692.y;
	    _3694.z = _3692.z;
	    _3694.w = _g_rtx_material_data_._m29 * (1.0 - min(_3694.x, min(_3694.y, _3694.z)));
	    _528 = _3694;
	    _3692.x = _g_rtx_material_data_._m28.x;
	    _3692.y = _g_rtx_material_data_._m28.y;
	    _3692.z = _g_rtx_material_data_._m28.z;
	    vec3 _3723 = _3692.xyz * mix(vec3(1.0), vsInput[2]._m7.xyz, vec3(vsInput[2]._m7.w));
	    vec4 _3725 = _3692;
	    _3725.x = _3723.x;
	    _3725.y = _3723.y;
	    _3725.z = _3723.z;
	    _524 = _3725;
	    vec3 _479 = _527;
	    vec3 _478 = _526;
	    vec3 _3755 = ((_489 * ((1.0 - _22.barycentrics.x) - _22.barycentrics.y)) + (_483 * _22.barycentrics.x)) + (_526 * _22.barycentrics.y);
	    bool _3761 = gl_HitKindEXT == 254u;
	    vec3 _533;
	    vec3 _534;
	    vec4 _502 = ((_491 * ((1.0 - _22.barycentrics.x) - _22.barycentrics.y)) + (_485 * _22.barycentrics.x)) + (_3694 * _22.barycentrics.y);
	    vec3 _501 = _534;
	    vec3 _500 = _3755;
	    vec4 _499 = ((_488 * ((1.0 - _22.barycentrics.x) - _22.barycentrics.y)) + (_482 * _22.barycentrics.x)) + (_525 * _22.barycentrics.y);
	    vec4 _498 = ((_487 * ((1.0 - _22.barycentrics.x) - _22.barycentrics.y)) + (_481 * _22.barycentrics.x)) + (_3725 * _22.barycentrics.y);
	    vec4 _497 = ((_486 * ((1.0 - _22.barycentrics.x) - _22.barycentrics.y)) + (_480 * _22.barycentrics.x)) + (_523 * _22.barycentrics.y);
	    bool _496 = _3761;
	    vec3 _543 = vec3(0.5);
	    vec2 _542 = vec2(0.5);
	    float _541 = 0.0;
	    vec3 _540 = vec3(0.0);
	    float _539 = 0.039999999105930328369140625;
	    vec3 _538 = vec3(0.0);
	    vec3 _536 = vec3(1.0);
	    bool _535 = false;
	    vec3 _3800 = _3755.xyz;
	    vec3 _537 = _3800;
	    if (dot(_3800, _3800) >= 1.0099999904632568359375)
	    {
	        _537 = _533.xyz;
	    }
	    _539 = _g_rtx_material_data_._m98;
	    _536 = normalize(cross(_484 - _490, _527 - _490));
	    bool _635;
	    if (_g_rtx_material_data_._m97)
	    {
	        _635 = !_g_rtx_material_data_._m96;
	    }
	    else
	    {
	        _635 = false;
	    }
	    if (_635)
	    {
	        float _636;
	        if (_3761)
	        {
	            _636 = 1.0;
	        }
	        else
	        {
	            _636 = -1.0;
	        }
	        _537 *= _636;
	        if (_3761)
	        {
	            _636 = 1.0;
	        }
	        else
	        {
	            _636 = -1.0;
	        }
	        _536 *= _636;
	        _535 = !_3761;
	    }
	    vec3 _3831 = _537;
	    vec3 _3832 = normalize(_3831);
	    _537 = _3832;
	    vec3 _572 = _3832;
	    vec3 _571 = _543;
	    vec2 _570 = _542;
	    float _569 = _541;
	    vec3 _568 = _540;
	    float _567 = _539;
	    vec3 _566 = _538;
	    vec3 _565 = _3832;
	    vec3 _564 = _536;
	    bool _563 = _535;
	    bool _633;
	    if (_g_rtx_material_data_._m97)
	    {
	        _633 = !_g_rtx_material_data_._m96;
	    }
	    else
	    {
	        _633 = false;
	    }
	    if (_633)
	    {
	        float _634;
	        if (_496)
	        {
	            _634 = 1.0;
	        }
	        else
	        {
	            _634 = -1.0;
	        }
	        _633 = _634 < 0.0;
	    }
	    else
	    {
	        _633 = false;
	    }
	    vec3 _576 = vec3(0.0);
	    vec3 _575 = vec3(0.0);
	    float _631;
	    if (_497.w > 0.0)
	    {
	        _631 = 1.0;
	    }
	    else
	    {
	        _631 = -1.0;
	    }
	    float _3880 = 1.0 / length(_500);
	    vec3 _577 = _500 * _3880;
	    vec3 _495 = _497.xyz * _3880;
	    vec3 _494 = (cross(_500, _497.xyz) * _631) * _3880;
	    if (_633)
	    {
	        _577 *= (-1.0);
	    }
	    vec3 _574 = _576 - (_577 * dot(_576, _577));
	    vec3 _573 = _575 - (_577 * dot(_575, _577));
	    int _632;
	    if (dot(_575, cross(_577, _576)) < 0.0)
	    {
	        _632 = -1;
	    }
	    else
	    {
	        _632 = 1;
	    }
	    vec3 _600 = _577;
	    vec3 _599 = _574;
	    vec3 _598 = _573;
	    float _597 = float(_632);
	    vec3 _561;
	    vec3 _562;
	    if (_g_rtx_material_data_._m38 > 1)
	    {
	        float _630;
	        if (false)
	        {
	            _630 = -1.0;
	        }
	        else
	        {
	            _630 = 1.0;
	        }
	        vec2 _3916 = vec2(0.0, -0.0) * _630;
	        vec3 _578 = (_599 * _3916.x) + (_598 * _3916.y);
	        float _3924 = abs(0.0);
	        if (_3924 > 0.0)
	        {
	            _578 = normalize(_578);
	        }
	        _562 = _578;
	        _561 = cross(_600, _578) * (_630 * _597);
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
	        vec3 _3944 = abs(_565);
	        vec3 _625 = _3944;
	        float _3945 = _3944.x;
	        float _3946 = _3944.y;
	        bool _626;
	        if (_3945 > _3946)
	        {
	            _626 = _3945 > _3944.z;
	        }
	        else
	        {
	            _626 = false;
	        }
	        ivec3 _627;
	        if (_626)
	        {
	            _627 = ivec3(0, 1, 2);
	        }
	        else
	        {
	            if (_3946 > _3944.z)
	            {
	                _627 = ivec3(1, 2, 0);
	            }
	            else
	            {
	                _627 = ivec3(2, 0, 1);
	            }
	        }
	        if (_3945 < _3946)
	        {
	            _626 = _3945 < _3944.z;
	        }
	        else
	        {
	            _626 = false;
	        }
	        ivec3 _628;
	        if (_626)
	        {
	            _628 = ivec3(0, 1, 2);
	        }
	        else
	        {
	            if (_3946 < _3944.z)
	            {
	                _628 = ivec3(1, 2, 0);
	            }
	            else
	            {
	                _628 = ivec3(2, 0, 1);
	            }
	        }
	        ivec3 _3980 = (ivec3(3) - _628) - _627;
	        ivec2 _629;
	        if (_627.x == 1)
	        {
	            _629 = _627.zy;
	        }
	        else
	        {
	            _629 = _627.yz;
	        }
	        ivec2 _3992 = _553;
	        _3992.x = _629.x;
	        _3992.y = _629.y;
	        _553 = _3992;
	        int _3996 = _3980.x;
	        if (_3996 == 1)
	        {
	            _629 = _3980.zy;
	        }
	        else
	        {
	            _629 = _3980.yz;
	        }
	        ivec2 _4005 = _552;
	        _4005.x = _629.x;
	        _4005.y = _629.y;
	        _552 = _4005;
	        vec2 _4016 = clamp((vec2(_625[_627.x], _625[_3996]) - vec2(0.577300012111663818359375)) * vec2(2.365744113922119140625), vec2(0.0), vec2(1.0));
	        _554 = _4016 / vec2(_4016.x + _4016.y);
	        vec3 _616 = _501 * _g_rtx_material_data_._m34.xyz;
	        _560 = vec2(_616[_553.x], _616[_553.y]);
	        vec3 _617 = vec3(0.0);
	        vec3 _618 = vec3(0.0);
	        _558 = vec2(_617[_553.x], _618[_553.y]);
	        vec3 _619 = vec3(0.0);
	        vec3 _620 = vec3(0.0);
	        _557 = vec2(_619[_553.x], _620[_553.y]);
	        _559 = vec2(_616[_4005.x], _616[_4005.y]);
	        vec3 _621 = vec3(0.0);
	        vec3 _622 = vec3(0.0);
	        _556 = vec2(_621[_4005.x], _622[_4005.y]);
	        vec3 _623 = vec3(0.0);
	        vec3 _624 = vec3(0.0);
	        _555 = vec2(_623[_4005.x], _624[_4005.y]);
	    }
	    vec4 _551 = vec4(0.0);
	    vec3 _550 = vec3(0.0);
	    vec4 _547 = vec4(0.0);
	    float _546 = 0.0;
	    float _545 = 0.0;
	    float _544 = 0.0;
	    vec3 _4073 = vec3(0.0);
	    _4073.x = _499.x;
	    _4073.y = _499.y;
	    vec3 _549 = _4073;
	    vec2 _548 = _g_rtx_material_data_._m40.xy;
	    vec2 _585 = _560;
	    vec2 _584 = _559;
	    vec2 _583 = _558;
	    vec2 _582 = _557;
	    vec2 _581 = _556;
	    vec2 _580 = _555;
	    vec2 _579 = _554;
	    vec4 _615;
	    if (_g_rtx_material_data_._m38 == 0)
	    {
	        vec2 _4099 = _585;
	        vec2 _4100 = _4099 * _548;
	        _585 = _4100;
	        vec2 _4101 = _583;
	        vec2 _4102 = _4101 * _548;
	        _583 = _4102;
	        vec2 _4103 = _582;
	        vec2 _4104 = _4103 * _548;
	        _582 = _4104;
	        vec2 _4105 = _584;
	        vec2 _4106 = _4105 * _548;
	        _584 = _4106;
	        vec2 _4107 = _581;
	        vec2 _4108 = _4107 * _548;
	        _581 = _4108;
	        vec2 _4109 = _580;
	        vec2 _4110 = _4109 * _548;
	        _580 = _4110;
	        _615 = (textureGrad(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_._m61], g_bindless_Sampler[_g_rtx_material_data_._m92]), _4100.xy, _4102.xy, _4104.xy) * _579.x) + (textureGrad(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_._m61], g_bindless_Sampler[_g_rtx_material_data_._m92]), _4106.xy, _4108.xy, _4110.xy) * _579.y);
	    }
	    else
	    {
	        _615 = textureLod(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_._m61], g_bindless_Sampler[_g_rtx_material_data_._m92]), _549.xy, 0.0).xyzw;
	    }
	    _545 = _615.y;
	    _546 = _615.w;
	    vec2 _596 = _560;
	    vec2 _595 = _559;
	    vec2 _594 = _558;
	    vec2 _593 = _557;
	    vec2 _592 = _556;
	    vec2 _591 = _555;
	    vec2 _590 = _554;
	    ivec2 _589 = _553;
	    ivec2 _588 = _552;
	    if (_g_rtx_material_data_._m38 == 0)
	    {
	        _596 *= _548;
	        _594 *= _548;
	        _593 *= _548;
	        _595 *= _548;
	        _592 *= _548;
	        _591 *= _548;
	        _550 = _565;
	        if (true)
	        {
	            _551 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_._m94], g_bindless_Sampler[_g_rtx_material_data_._m92]), _596.xy, _594.xy, _593.xy) * _590.x;
	        }
	        if (true)
	        {
	            vec4 _4288 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_._m60], g_bindless_Sampler[_g_rtx_material_data_._m92]), _596.xy, _594.xy, _593.xy);
	            _544 = _4288.z * _590.x;
	            float _4293 = _4288.x;
	            float _4294 = _4288.y;
	            float _4296 = (_4293 + _4294) - 1.00392162799835205078125;
	            float _4297 = _4293 - _4294;
	            vec3 _4307 = normalize(vec3(vec2(_4296, _4297), (1.0 - abs(_4296)) - abs(_4297))).xyz * _590.x;
	            vec4 _4309;
	            _4309.x = _4307.x;
	            _4309.y = _4307.y;
	            vec4 _4313 = _4309;
	            _4313.z = _4307.z;
	            _550 = (_417[_589.x] * _4309.x) + (_421[_589.y] * _4309.y);
	        }
	        if (_590.y > 0.0)
	        {
	            if (true)
	            {
	                _551 += (textureGrad(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_._m94], g_bindless_Sampler[_g_rtx_material_data_._m92]), _595.xy, _592.xy, _591.xy) * _590.y);
	            }
	            if (true)
	            {
	                vec4 _4363 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_._m60], g_bindless_Sampler[_g_rtx_material_data_._m92]), _595.xy, _592.xy, _591.xy);
	                _544 += (_4363.z * _590.y);
	                float _4370 = _4363.x;
	                float _4371 = _4363.y;
	                float _4373 = (_4370 + _4371) - 1.00392162799835205078125;
	                float _4374 = _4370 - _4371;
	                vec3 _4384 = normalize(vec3(vec2(_4373, _4374), (1.0 - abs(_4373)) - abs(_4374))).xyz * _590.y;
	                vec4 _4386;
	                _4386.x = _4384.x;
	                _4386.y = _4384.y;
	                vec4 _4390 = _4386;
	                _4390.z = _4384.z;
	                _550 += ((_417[_588.x] * _4386.x) + (_421[_588.y] * _4386.y));
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
	            vec4 _4186 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_._m60], g_bindless_Sampler[_g_rtx_material_data_._m92]), _549.xy, _547.xy, _547.zw);
	            vec3 _4187 = _4186.xyz;
	            _544 = _4186.z;
	            float _4189 = _4186.x;
	            float _4190 = _4186.y;
	            float _4192 = (_4189 + _4190) - 1.00392162799835205078125;
	            float _4193 = _4189 - _4190;
	            vec3 _4200 = normalize(vec3(vec2(_4192, _4193), (1.0 - abs(_4192)) - abs(_4193)));
	            _4187.x = _4200.x;
	            _4187.y = _4200.y;
	            _4187.z = _4200.z;
	            vec3 _4213 = _4187;
	            _4213.x = dot(_4187.xy, _g_rtx_material_data_._m47.xy);
	            _4213.y = dot(_4187.xy, _g_rtx_material_data_._m47.zw);
	            vec3 _614 = _4213;
	            vec3 _586;
	            vec3 _587;
	            if (_g_rtx_material_data_._m38 > 1)
	            {
	                _587 = _562;
	                _586 = _561;
	            }
	            else
	            {
	                _587 = _495;
	                _586 = _494;
	            }
	            vec3 _4221 = abs(_614.xyz);
	            vec2 _4234 = (-vec2(_614.x, (-1.0) * _614.y)) / vec2(max(_4221.z, 0.0078125 * max(_4221.x, _4221.y)));
	            _550 = normalize(_600 - ((_587 * _4234.x) + (_586 * _4234.y)));
	        }
	    }
	    if (true)
	    {
	        _550 = normalize(_550);
	        _544 = saturate(_544);
	    }
	    vec4 _609;
	    if (false)
	    {
	        _609 = vec4((vec4(_551.xyz, 1.0) * _g_rtx_material_data_._m65).xyz, _551.w);
	    }
	    else
	    {
	        _609 = _551;
	    }
	    vec4 _4433 = _609;
	    float _4435 = _545;
	    float _4436 = saturate(_4435);
	    _545 = _4436;
	    vec3 _4440 = mix(_4433.xyz, vec4((vec4(_551.xyz, 1.0) * _g_rtx_material_data_._m64).xyz, _473).xyz, vec3(_4436));
	    vec4 _4442 = _4433;
	    _4442.x = _4440.x;
	    _4442.y = _4440.y;
	    _4442.z = _4440.z;
	    float _4451 = dot(_4442.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125));
	    vec3 _4454 = normalize(max(_502.xyz, vec3(0.001000000047497451305389404296875)));
	    vec4 _4473 = vec4(clamp(mix(_4442.xyz, (_4454 * min(_4451 / dot(_4454.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125)), (3.0 * _4451) * max(_502.x, max(_502.y, _502.z)))).xyz, vec3(_502.w * _4436)), vec3(0.0), vec3(1.0)).xyz, _4442.w);
	    _551 = _4473;
	    _572 = _550.xyz;
	    _571 = _4473.xyz;
	    vec2 _4478 = _570;
	    _4478.x = _544;
	    _569 = _546;
	    vec2 _4481 = _4478;
	    _4481.x = _4478.x;
	    _4481.y = _4478.x;
	    _570 = _4481;
	    vec3 _4490 = _571;
	    vec3 _4491 = _4490 * mix(vec3(1.0), _498.xyz, vec3(saturate(_545)));
	    _571 = _4491;
	    _21._m5 = int(uint(gl_InstanceID));
	    _21._m3 = gl_RayTmaxEXT;
	    _21._m1 = _564;
	    _21._m2 = _565;
	    vec3 _601[3] = vec3[](_489, _483, _478);
	    vec3 _602[3] = vec3[](_490, _484, _479);
	    vec3 _4526 = ((_490 * ((1.0 - _22.barycentrics.x) - _22.barycentrics.y)) + (_484 * _22.barycentrics.x)) + (_479 * _22.barycentrics.y);
	    vec3 _603[3];
	    _603[0] = _4526 - (_489 * dot(_4526 - _490, _489));
	    _603[1] = _4526 - (_483 * dot(_4526 - _484, _483));
	    _603[2] = _4526 - (_478 * dot(_4526 - _479, _478));
	    vec3 _4554 = ((_603[0] * ((1.0 - _22.barycentrics.x) - _22.barycentrics.y)) + (_603[1] * _22.barycentrics.x)) + (_603[2] * _22.barycentrics.y);
	    vec3 _604[3];
	    _604[0] = cross(_490 - _484, _21._m1);
	    _604[1] = cross(_484 - _479, _21._m1);
	    _604[2] = cross(_479 - _490, _21._m1);
	    float _605 = dot(_4554 - _4526, _21._m1);
	    vec3 _606 = _4554;
	    int _607 = 0;
	    for (;;)
	    {
	        bool _4570_ladder_break = false;
	        do
	        {
	            if (!(_607 < 3))
	            {
	                _4570_ladder_break = true;
	                break;
	            }
	            if (_605 > 0.00999999977648258209228515625)
	            {
	                _4570_ladder_break = true;
	                break;
	            }
	            if (dot(_604[_607], _604[_607]) == 0.0)
	            {
	                break;
	            }
	            _604[_607] = normalize(_604[_607]);
	            int _608 = 0;
	            for (;;)
	            {
	                if (!(_608 < 3))
	                {
	                    break;
	                }
	                vec3 _4608 = _601[_608] - (_604[_607] * dot(_604[_607], _601[_608]));
	                _603[_608] = _4526 - (_4608 * dot(_4526 - _602[_608], _4608));
	                _608++;
	                continue;
	            }
	            vec3 _4632 = ((_603[0] * ((1.0 - _22.barycentrics.x) - _22.barycentrics.y)) + (_603[1] * _22.barycentrics.x)) + (_603[2] * _22.barycentrics.y);
	            _605 = dot(_4632 - _4526, _21._m1);
	            _606 = _4632;
	            break;
	        } while(false);
	        if (_4570_ladder_break)
	        {
	            break;
	        }
	        _607++;
	        continue;
	    }
	    if (!(_605 > 0.00999999977648258209228515625))
	    {
	        _606 = vec3(3.4028234663852885981170418348452e+38);
	    }
	    _21.material = _606;
	    _21._m6 = _563;
	    f16vec3 _4645 = f16vec3(vec3(0.0));
	    _21._m7 = MaterialDataMinimal_t(_4645, float16_t(0.0), f16vec3(vec3(1.0, 0.0, 1.0)), float16_t(1.0), _4645, float16_t(0.040008544921875), 0u, f16vec4(ivec4(0)));
	    _21._m7.vMaterialBits = f16vec3(_572);
	    _21._m7._m2 = f16vec3(_4491);
	    _21._m7._m4 = f16vec3(_568);
	    _21._m7._m5 = float16_t(_567);
	    _21._m7._m1 = float16_t(_569);
	    _21._m7._m3 = float16_t(dot(_570, vec2(0.5)));
	    if (any(greaterThan(_566, vec3(0.0))))
	    {
	        f16vec4 _4674 = _21._m7._m7;
	        f16vec3 _4677 = f16vec3(_566);
	        _4674.x = _4677.x;
	        _4674.y = _4677.y;
	        _4674.z = _4677.z;
	        _21._m7 = MaterialDataMinimal_t(_21._m7.vMaterialBits, _21._m7._m1, _21._m7._m2, _21._m7._m3, _21._m7._m4, _21._m7._m5, (_21._m7._m6 & 4294901760u) | 1u, _4674);
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
