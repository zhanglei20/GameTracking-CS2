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
	// SPIR-V source (8020 bytes), GLSL reflection with SPIRV-Cross by KhronosGroup
	
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
	
	struct _2592
	{
	    _785 _m0;
	    vec4 _m1;
	};
	
	layout(set = 0) uniform _2592 PerViewConstantBuffer_t;
	
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
	    vec4 _10296 = vec4(_21354, _21355, _14124, _23812.w);
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
	    _10296.x = _Globals_.g_vColorTint.x;
	    _10296.y = _Globals_.g_vColorTint.y;
	    _10296.z = _Globals_.g_vColorTint.z;
	    vec3 _14119 = _10296.xyz * mix(vec3(1.0), vColorBlendValues.xyz, vec3(vColorBlendValues.w));
	    vec4 _23714 = _10296;
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
	// SPIR-V source (65088 bytes), GLSL reflection with SPIRV-Cross by KhronosGroup
	
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
	
	struct _231
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
	};
	
	layout(set = 1) uniform _231 PerViewConstantBufferCsgo_t;
	
	struct _1263
	{
	    float _m0;
	    vec2 _m1;
	    vec2 _m2;
	    vec4 _m3;
	    vec3 _m4;
	};
	
	layout(set = 1) uniform _1263 PerViewConstantBuffer_t;
	
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
	    vec3 _22993 = _10061 - PerViewConstantBuffer_t._m4.xyz;
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
	        vec3 _18781 = _10061 * _Globals_.g_vBiplanarTexCoordScale.xyz;
	        vec3 _16414 = _18781;
	        vec3 _16415 = dFdxFine(_18781);
	        vec3 _16446 = dFdyFine(_18781);
	        _13136 = _19321;
	        _16305 = _19322;
	        _17114 = vec2(_16100[_23727.x], _16100[_9992]) / vec2(_16100[_23727.x] + _16100[_9992]);
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
	    vec4 _21710;
	    if (_8452)
	    {
	        _21710 = vec4(0.0);
	    }
	    else
	    {
	        _21710 = vec4(dFdx(_18905.xy), dFdy(_18905.xy));
	    }
	    vec2 _13137;
	    vec2 _13998;
	    vec2 _16306;
	    vec2 _17119;
	    vec2 _17120;
	    vec2 _17121;
	    vec2 _17122;
	    vec4 _23299;
	    if (_8452)
	    {
	        vec2 _19978 = _6616 * _Globals_.g_vTexCoordScale1.xy;
	        vec2 _21750 = _13694 * _Globals_.g_vTexCoordScale1.xy;
	        vec2 _22329 = _17118 * _Globals_.g_vTexCoordScale1.xy;
	        vec2 _22330 = _17117 * _Globals_.g_vTexCoordScale1.xy;
	        vec2 _21037 = _17116 * _Globals_.g_vTexCoordScale1.xy;
	        vec2 _13654 = _17115 * _Globals_.g_vTexCoordScale1.xy;
	        vec4 _11487 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tHeight1], undetermined[_Globals_.g_sUserConfig]), _19978.xy, _21750.xy, _22329.xy);
	        vec4 _19697 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tHeight1], undetermined[_Globals_.g_sUserConfig]), _22330.xy, _21037.xy, _13654.xy);
	        vec2 _10640 = (_17114 * 3.0) + vec2(_11487.x, _19697.x);
	        vec2 _20211 = max(_10640 - vec2(max(_10640.x, _10640.y) - 0.0500000007450580596923828125), vec2(0.0));
	        vec2 _18088 = _20211 / vec2(_20211.x + _20211.y);
	        _13137 = _19978;
	        _16306 = _22330;
	        _17119 = _21750;
	        _17120 = _22329;
	        _17121 = _21037;
	        _17122 = _13654;
	        _13998 = _18088;
	        _23299 = (_11487 * _18088.x) + (_19697 * _18088.y);
	    }
	    else
	    {
	        _13137 = _6616;
	        _16306 = _17117;
	        _17119 = _13694;
	        _17120 = _17118;
	        _17121 = _17116;
	        _17122 = _17115;
	        _13998 = _17114;
	        _23299 = texture(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tHeight1], undetermined[_Globals_.g_sUserConfig]), _18905.xy).xyzw;
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
	    vec3 _6618;
	    vec3 _13139;
	    float _13695;
	    vec4 _16307;
	    if (_8452)
	    {
	        vec2 _8315 = (_13137 * _Globals_.g_vTexCoordScale1.xy).xy;
	        vec2 _7412 = (_17119 * _Globals_.g_vTexCoordScale1.xy).xy;
	        vec2 _8904 = (_17120 * _Globals_.g_vTexCoordScale1.xy).xy;
	        vec4 _23805 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tColor1], undetermined[_Globals_.g_sUserConfig]), _8315, _7412, _8904) * _13998.x;
	        vec4 _12167 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tNormal1], undetermined[_Globals_.g_sUserConfig]), _8315, _7412, _8904);
	        float _18178 = _12167.z * _13998.x;
	        float _15456 = _12167.x;
	        float _24534 = _12167.y;
	        float _16784 = (_15456 + _24534) - 1.00392162799835205078125;
	        float _11177 = _15456 - _24534;
	        vec3 _12920 = (normalize(vec3(vec2(_16784, _11177), (1.0 - abs(_16784)) - abs(_11177))).xyz * _13998.x) * 1.0;
	        vec3 _24466 = (_2029[_13136.x] * _12920.x) + (_842[_13136.y] * _12920.y);
	        vec4 _13138;
	        vec3 _13753;
	        float _14101;
	        if (_13998.y > 0.0)
	        {
	            vec2 _17047 = (_16306 * _Globals_.g_vTexCoordScale1.xy).xy;
	            vec2 _10017 = (_17121 * _Globals_.g_vTexCoordScale1.xy).xy;
	            vec2 _8905 = (_17122 * _Globals_.g_vTexCoordScale1.xy).xy;
	            vec4 _12168 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tNormal1], undetermined[_Globals_.g_sUserConfig]), _17047, _10017, _8905);
	            float _13491 = _12168.x;
	            float _21308 = _12168.y;
	            float _16785 = (_13491 + _21308) - 1.00392162799835205078125;
	            float _11178 = _13491 - _21308;
	            vec3 _12921 = (normalize(vec3(vec2(_16785, _11178), (1.0 - abs(_16785)) - abs(_11178))).xyz * _13998.y) * 1.0;
	            _13138 = _23805 + (textureGrad(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tColor1], undetermined[_Globals_.g_sUserConfig]), _17047, _10017, _8905) * _13998.y);
	            _14101 = _18178 + (_12168.z * _13998.y);
	            _13753 = _24466 + ((_2029[_16305.x] * _12921.x) + (_842[_16305.y] * _12921.y));
	        }
	        else
	        {
	            _13138 = _23805;
	            _14101 = _18178;
	            _13753 = _24466;
	        }
	        _13139 = normalize(_13753 + _24347);
	        _16307 = _13138;
	        _13695 = _14101;
	        _6618 = vec3(0.0);
	    }
	    else
	    {
	        vec4 _11179 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tNormal1], undetermined[_Globals_.g_sUserConfig]), _18905.xy, _21710.xy, _21710.zw);
	        float _6493 = _11179.x;
	        float _14881 = _11179.y;
	        float _16783 = (_6493 + _14881) - 1.00392162799835205078125;
	        float _11176 = _6493 - _14881;
	        vec3 _16359 = normalize(vec3(vec2(_16783, _11176), (1.0 - abs(_16783)) - abs(_11176)));
	        vec2 _21650 = _16359.xy * 1.0;
	        vec3 _8673 = _16359;
	        _8673.x = _21650.x;
	        _8673.y = _21650.y;
	        _13139 = vec3(0.0);
	        _16307 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tColor1], undetermined[_Globals_.g_sUserConfig]), _18905.xy, _21710.xy, _21710.zw).xyzw;
	        _13695 = _11179.z;
	        _6618 = _8673;
	    }
	    vec3 _9484;
	    if (_8452)
	    {
	        _9484 = _13139;
	    }
	    else
	    {
	        float _7796 = dot(_6618.xy, _Globals_.g_vNormalXform_1.xy);
	        float _19701 = dot(_6618.xy, _Globals_.g_vNormalXform_1.zw);
	        vec3 _19582 = _6618;
	        _19582.x = _7796;
	        _19582.y = _19701;
	        bvec3 _20662 = bvec3(_7312);
	        vec3 _10844 = abs(_19582.xyz);
	        vec2 _16475 = (-vec2(_7796, (-1.0) * _19701)) / vec2(max(_10844.z, 0.0078125 * max(_10844.x, _10844.y)));
	        _9484 = normalize(_8889 - ((mix(input_7.xyz * _12157, _11711, _20662) * _16475.x) + (mix((cross(input_3, input_7.xyz) * ((input_7.w > 0.0) ? 1.0 : (-1.0))) * _12157, _10247, _20662) * _16475.y)));
	    }
	    float _24470 = saturate(_13695);
	    float _14713 = clamp(mix(0.0, 1.0, pow(_16307.w, 1.0)), 0.0, 1.0);
	    float _7029 = saturate(_23299.y);
	    vec4 _12345 = vec4(mix(_16307.xyz, vec4((vec4(_16307.xyz, 1.0) * mat4(vec4(_Globals_.g_mTextureColorAdjust1._m0[0].x, _Globals_.g_mTextureColorAdjust1._m0[1].x, _Globals_.g_mTextureColorAdjust1._m0[2].x, _Globals_.g_mTextureColorAdjust1._m0[3].x), vec4(_Globals_.g_mTextureColorAdjust1._m0[0].y, _Globals_.g_mTextureColorAdjust1._m0[1].y, _Globals_.g_mTextureColorAdjust1._m0[2].y, _Globals_.g_mTextureColorAdjust1._m0[3].y), vec4(_Globals_.g_mTextureColorAdjust1._m0[0].z, _Globals_.g_mTextureColorAdjust1._m0[1].z, _Globals_.g_mTextureColorAdjust1._m0[2].z, _Globals_.g_mTextureColorAdjust1._m0[3].z), vec4(_Globals_.g_mTextureColorAdjust1._m0[0].w, _Globals_.g_mTextureColorAdjust1._m0[1].w, _Globals_.g_mTextureColorAdjust1._m0[2].w, _Globals_.g_mTextureColorAdjust1._m0[3].w))).xyz, _4).xyz, vec3(_7029)), _14713);
	    float _24323 = dot(_12345.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125));
	    vec3 _9577 = normalize(max(input_0.xyz, vec3(0.001000000047497451305389404296875)));
	    vec3 _23405 = vec4(clamp(mix(_12345.xyz, (_9577 * min(_24323 / dot(_9577.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125)), (3.0 * _24323) * max(input_0.x, max(input_0.y, input_0.z)))).xyz, vec3(input_0.w * _7029)), vec3(0.0), vec3(1.0)).xyz, _14713).xyz;
	    vec2 _22927 = vec2(0.5);
	    _22927.x = _24470;
	    float _7406 = float(_Globals_.g_bSnowLayer1 != 0);
	    bool _12889;
	    if (_Globals_.g_bWetness != 0)
	    {
	        _12889 = (_Globals_.g_fPuddleStrength + _Globals_.g_fWetnessStrength) > 0.0;
	    }
	    else
	    {
	        _12889 = false;
	    }
	    vec3 _13142;
	    float _13960;
	    vec2 _16308;
	    float _17124;
	    float _17125;
	    vec3 _17126;
	    vec3 _24595;
	    if (_12889)
	    {
	        vec4 _19372 = texture(sampler2D(g_bindless_Texture2D_float4[PerViewConstantBufferCsgo_t._m7], undetermined[_Globals_.g_sUserConfig]), (_10061.xy * 0.006000000052154064178466796875).xy);
	        float _21302 = _24347.z;
	        float _14498 = pow(max(0.0, _21302), 32.0);
	        float _23204 = min(min(input_1.z, saturate(PerViewConstantBufferCsgo_t._m11)), 1.0 - (saturate(PerViewConstantBufferCsgo_t._m12 - 0.5) * 2.0));
	        float _18407 = saturate(_23204 - 0.75) * 2.0;
	        float _8284 = _23204 + (_18407 * _18407);
	        float _16777 = _8284 - _Globals_.g_fWetEdgeSpread;
	        float _11964 = saturate(_8284 * 20.0);
	        vec4 _9716;
	        float _24878;
	        if (_Globals_.g_bPuddlesOnVerticalSurfaces != 0)
	        {
	            vec4 _9186 = vec4(0.0, 0.0, 1.0, 0.0);
	            _9186.x = _24347.x;
	            _9186.y = _24347.y;
	            _9186.z = _21302;
	            _9716 = _9186;
	            _24878 = max(0.0, _16777);
	        }
	        else
	        {
	            _9716 = vec4(0.0, 0.0, 1.0, 0.0);
	            _24878 = max(0.0, (_8284 * _14498) - _Globals_.g_fWetEdgeSpread);
	        }
	        float _15811 = max(0.001000000047497451305389404296875, _Globals_.g_fPuddleBlendSoftness);
	        float _14611 = smoothstep(_24878 + _15811, _24878 - (input_1.w + (_15811 * 2.0)), _21711) * _11964;
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
	            vec3 _6619;
	            vec4 _12890;
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
	                vec4 _15054 = texture(sampler2D(g_bindless_Texture2D_float4[PerViewConstantBufferCsgo_t._m7], undetermined[_Globals_.g_sUserConfig]), (_15991 + (vec2(0.20000000298023223876953125, 0.0) * PerViewConstantBuffer_t._m0)).xy);
	                float _18070 = clamp(length(fwidth(_15991)) * 10.0, 0.0, 1.0);
	                vec2 _18922 = (_15054.xy * 2.0) - vec2(1.0);
	                vec2 _10456 = ((_18922 * vec2(0.100000001490116119384765625, 0.0500000007450580596923828125)) * input_1.z) * mix(1.0, 0.300000011920928955078125, _18070);
	                vec2 _13711 = _21326.xy;
	                vec4 _19601 = vec4(0.0);
	                _19601.x = dot(_22900.xy, _10456);
	                _19601.y = dot(_13711, _10456);
	                vec2 _16048 = (vec2(_20274.y, _9965) * vec2(0.03599999845027923583984375, 0.01620000042021274566650390625)) + (_18922 * 0.0500000007450580596923828125);
	                vec4 _15055 = texture(sampler2D(g_bindless_Texture2D_float4[PerViewConstantBufferCsgo_t._m7], undetermined[_Globals_.g_sUserConfig]), (_16048 + (vec2(0.1500000059604644775390625, 0.0) * PerViewConstantBuffer_t._m0)).xy);
	                float _9250 = clamp(length(fwidth(_16048)) * 10.0, 0.0, 1.0);
	                vec2 _9825 = ((((_15055.xy * 2.0) - vec2(1.0)) * 0.05200000107288360595703125) * input_1.z) * mix(1.0, 0.300000011920928955078125, _9250);
	                _9825.y = _9825.y * 0.5;
	                vec2 _13330 = _19601.xy + vec2(dot(_22900.xy, _9825), dot(_13711, _9825));
	                vec4 _20488 = _19601;
	                _20488.x = _13330.x;
	                _20488.y = _13330.y;
	                _20488.w = input_1.z * (_15054.z + _15055.z);
	                vec3 _20489;
	                _20489.x = _10061.x;
	                _20489.y = _10061.y;
	                _13140 = _12497 * (0.039999999105930328369140625 * (_18070 + _9250));
	                _12890 = _9716 + ((_20488 * _14498) * _12497);
	                _6619 = _20489;
	            }
	            else
	            {
	                _13140 = 0.0;
	                _12890 = _9716;
	                _6619 = _10061;
	            }
	            float _8914 = (_Globals_.g_fRainStrength * PerViewConstantBufferCsgo_t._m8) * PerViewConstantBufferCsgo_t._m8;
	            float _9982;
	            vec4 _21594;
	            if (_8914 > 0.0)
	            {
	                vec2 _10473 = _6619.xy * 0.119999997317790985107421875;
	                vec3 _20506 = vec3(PerViewConstantBuffer_t._m0 * 6.5) + vec3(0.0, 0.3167000114917755126953125, 0.633400022983551025390625);
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
	                    float _20214 = clamp(1.0 - (_8329 * 6.0), 0.0, 1.0);
	                    float _7135 = floor(fract(_10212.x * 0.100000001490116119384765625) * 10.0);
	                    float _23598 = _20506[_16208];
	                    float _18429 = _23598 + ((_7135 + (floor(fract(_10212.y * 0.100000001490116119384765625) * 10.0) * (0.20000000298023223876953125 + _7135))) * 8.0);
	                    _20506[_16208] = _18429;
	                    float _18120 = _8914 * _8914;
	                    _25251 = vec3(_13155.xy + (((-(((((_7848 / vec2(_8329)) * cos(mix(1.0, (_20173 * 40.0) + (PerViewConstantBuffer_t._m0 * 65.0), _14611))) * _20173) * _20173) * mix(2.0, 0.25, clamp(fwidth(_20173) * 20.0, 0.0, 1.0)))) * ((clamp((sin(((_20173 * mix(1.0, 4.0, _14611)) + _18429) * _8914) - (1.0 - ((0.20000000298023223876953125 * _18120) * mix(0.25, 1.0, _14611)))) * 2.0, 0.0, 1.0) * _20173) / _18120)) * mix(16.0, 2.0, _14611)), _13155.z + (((clamp((sin((((_20214 + _18429) + 4.0) + (sin(_21711 * 60.0) * 0.25)) * _8914) - (1.0 - (_18120 * 0.02000000141561031341552734375))) * 2.0, 0.0, 1.0) * _20214) / _18120) * 28.0));
	                    _18440 = _16208 + 1;
	                    _13155 = _25251;
	                    _16208 = _18440;
	                    continue;
	                }
	                vec3 _9348 = _13155 * _14498;
	                vec2 _15752 = _12890.xy + _9348.xy;
	                vec4 _20490 = _12890;
	                _20490.x = _15752.x;
	                _20490.y = _15752.y;
	                _9982 = _9348.z;
	                _21594 = _20490;
	            }
	            else
	            {
	                _9982 = 0.0;
	                _21594 = _12890;
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
	            _23607 = _9716;
	        }
	        float _10839 = _14611 * _Globals_.g_fPuddleStrength;
	        vec3 _13712 = normalize(mix(_9484.xyz, _23607.xyz, vec3(saturate(_10839 * 4.0))));
	        float _9038 = max(_13706 * (1.0 - saturate(PerViewConstantBufferCsgo_t._m12 * 2.0)), _19808);
	        vec3 _18806 = mix(_23405, pow(_23405, vec3(1.2999999523162841796875)) * 0.800000011920928955078125, clamp((pow(_23405, vec3(0.25)) * (_9038 * _24470)) * 8.0, vec3(0.0), vec3(1.0)) * _Globals_.g_flWetnessDarkeningStrength1);
	        _13142 = fma(mix((mix(_18806, _18806 * 0.5, vec3(saturate(_14611 * 1.5))) * mix(1.0, _14713, _19808)) * mix(1.0, 1.0 - _17924, _10334), _Globals_.g_vPuddleSedimentColor, vec3(_10334 * _19808)), vec3(1.0 + _13141), vec3(_13141 * 0.100000001490116119384765625));
	        _16308 = clamp(mix(_22927.xx, vec2(_Globals_.g_fPuddleRoughness), vec2(_9038)) + vec2(_13151 + (length(fwidth(_13712.xyz)) * 0.5)), vec2(0.0), vec2(1.0));
	        _17124 = mix(_14713, 1.0, _19808);
	        _17125 = mix(_Globals_.g_flReflectance, 0.0350000001490116119384765625, _9038);
	        _17126 = _13712;
	        _13960 = _10839 * (0.20000000298023223876953125 + (((0.1500000059604644775390625 * _23607.w) * _23607.w) * _23607.w));
	        _24595 = mix(_9484.xyz, _23607.xyz, vec3(_19808 * _10334));
	    }
	    else
	    {
	        _13142 = _23405;
	        _16308 = _22927;
	        _17124 = _14713;
	        _17125 = _Globals_.g_flReflectance;
	        _17126 = vec3(1.0);
	        _13960 = 0.0;
	        _24595 = _9484.xyz;
	    }
	    vec3 _9453 = mix(vec3(_17125).xyz, _13142.xyz, vec3(_23299.w));
	    vec3 _17892 = mix(_17126, _24595, bvec3(all(equal(_17126, vec3(1.0)))));
	    vec3 _10560 = _24347.xyz;
	    vec3 _11099 = dFdx(_10560);
	    vec3 _9175 = dFdy(_10560);
	    vec3 _10347 = _11099.xyz;
	    vec3 _12420 = _9175.xyz;
	    vec2 _21816 = max(_16308.xy, vec2(pow(clamp(max(dot(_10347, _10347), dot(_12420, _12420)), 0.0, 1.0), 0.333000004291534423828125)));
	    vec3 _15598 = -_24347;
	    vec4 _23875 = vec4(_24595.xyz, 1.0);
	    bvec4 _24464 = notEqual(PerViewConstantBufferCsgo_t._m0, ivec4(0));
	    float _21712;
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
	        _21712 = (1.0 / (dot(_13232, vec4(1.0)) + PerViewLightingConstantBufferGpu_t._m3.x)) * (PerViewLightingConstantBufferGpu_t._m3.x + dot(_13232, textureLod(sampler2D(g_bindless_Texture2D_float4[PerViewConstantBufferCsgo_t._m3], undetermined[_Globals_.g_sPointClamp]), (_11086 + mix(_23169, PerViewConstantBufferCsgo_t._m14.xy, bvec2(abs(_18418.y) < (_12287 ? _15372 : _20965))).xy).xy, 0.0)));
	    }
	    else
	    {
	        _21712 = 1.0;
	    }
	    float _21714;
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
	                vec3 _20491 = _19470;
	                _20491.x = _20561.x;
	                _20491.y = _20561.y;
	                _13143 = saturate(_22193.x * _22193.y);
	                _14975 = _20491;
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
	                    vec3 _20492;
	                    _20492.x = _20562.x;
	                    _20492.y = _20562.y;
	                    _7934 = textureLod(sampler2DShadow(g_bindless_Texture2D_float4[PerViewLightingConstantBufferGpu_t._m20], undetermined_1[_Globals_.g_tShadowDepthBufferCmpSampler]), vec3(_20492.xy, saturate(_19671.z + PerViewLightingConstantBufferGpu_t._m12)), 0.0);
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
	        float _13279 = mix(_18423, 1.0, clamp((distance(_10061.xyz, PerViewConstantBuffer_t._m4) * PerViewLightingConstantBufferGpu_t._m17) + PerViewLightingConstantBufferGpu_t._m16, 0.0, 1.0));
	        float _12502;
	        if (_24464.y)
	        {
	            _12502 = min(_13279, textureLod(sampler2D(g_bindless_Texture2D_float4[PerViewConstantBufferCsgo_t._m5], undetermined[_Globals_.g_sTrilinearClamp]), (_11408.xy * PerViewConstantBuffer_t._m3.xy).xy, 0.0).z);
	        }
	        else
	        {
	            _12502 = _13279;
	        }
	        _21714 = _12502;
	    }
	    else
	    {
	        _21714 = 1.0;
	    }
	    vec3 _9717;
	    vec3 _24879;
	    if ((dot(PerViewLightingConstantBufferGpu_t._m9.xyz, _24595.xyz) * _21714) > 0.0)
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
	        vec2 _17301 = max(_21816, vec2(PerViewLightingConstantBufferGpu_t._m9.w));
	        vec3 _12281 = normalize(PerViewLightingConstantBufferGpu_t._m9.xyz + (-normalize(_10061.xyz - PerViewConstantBuffer_t._m4.xyz)).xyz).xyz;
	        float _12386 = dot(_12281, _15460.xyz);
	        float _19210 = max(0.0, dot(PerViewLightingConstantBufferGpu_t._m9.xyz, _12281));
	        float _9850 = _17301.x;
	        float _25211 = _9850 * _9850;
	        float _19095 = _25211 * _25211;
	        float _15346 = ((_12386 * _12386) * (_19095 - 1.0)) + 1.0;
	        vec3 _16808 = (PerViewLightingConstantBufferGpu_t._m10.xyz * _21714).xyz;
	        _9717 = ((_9453.xyz * (_19095 / (((_15346 * _15346) * (_19210 * _19210)) * ((_9850 * 4.0) + 2.0)))).xyz * _13811).xyz * _16808;
	        _24879 = PerViewLightingConstantBufferGpu_t._m4.xyz + (_18223.xyz * _16808);
	    }
	    else
	    {
	        _9717 = vec3(0.0);
	        _24879 = PerViewLightingConstantBufferGpu_t._m4.xyz;
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
	        _6651.x = clamp(((_11414.x + 1.0) * PerViewConstantBuffer_t._m2.x) * 0.5, 0.0, PerViewConstantBuffer_t._m2.x - 1.0);
	        _6651.y = clamp(((1.0 - _11414.y) * PerViewConstantBuffer_t._m2.y) * 0.5, 0.0, PerViewConstantBuffer_t._m2.y - 1.0);
	        _6651.w = _20176;
	        _19363 = _6651;
	    }
	    else
	    {
	        _19363 = _11408;
	    }
	    uvec2 _12083 = uvec2(_19363.xy - PerViewConstantBuffer_t._m1.xy) >> uvec2(PerViewLightingConstantBufferGpu_t._m6.x);
	    uint _10838 = PerViewLightingConstantBufferGpu_t._m5.y + (((_12083.y * PerViewLightingConstantBufferGpu_t._m6.y) + _12083.x) * PerViewLightingConstantBufferGpu_t._m5.z);
	    uint _23393 = PerViewLightingConstantBufferGpu_t._m5.x + (uint(clamp(_19363.w * PerViewLightingConstantBufferGpu_t._m7.x, 0.0, PerViewLightingConstantBufferGpu_t._m7.y)) * PerViewLightingConstantBufferGpu_t._m5.z);
	    vec3 _13144;
	    vec3 _16324;
	    _13144 = _9717;
	    _16324 = _24879;
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
	                bool _12892;
	                if (!_7424)
	                {
	                    _12892 = true;
	                }
	                else
	                {
	                    _12892 = !all(lessThanEqual(abs((mat4x3(vec3(g_BarnLights_1._m0[_12608]._m15._m0[0].x, g_BarnLights_1._m0[_12608]._m15._m0[1].x, g_BarnLights_1._m0[_12608]._m15._m0[2].x), vec3(g_BarnLights_1._m0[_12608]._m15._m0[0].y, g_BarnLights_1._m0[_12608]._m15._m0[1].y, g_BarnLights_1._m0[_12608]._m15._m0[2].y), vec3(g_BarnLights_1._m0[_12608]._m15._m0[0].z, g_BarnLights_1._m0[_12608]._m15._m0[1].z, g_BarnLights_1._m0[_12608]._m15._m0[2].z), vec3(g_BarnLights_1._m0[_12608]._m15._m0[0].w, g_BarnLights_1._m0[_12608]._m15._m0[1].w, g_BarnLights_1._m0[_12608]._m15._m0[2].w)) * vec4(input_2.xyz, 1.0)).xyz), vec3(1.0)));
	                }
	                if (_12892)
	                {
	                    _13212 = _13145;
	                    _15670 = _16325;
	                    break;
	                }
	                float _23572 = 2.0 * g_BarnLights_1._m0[_12608]._m5.y;
	                float _18493 = (2.0 * g_BarnLights_1._m0[_12608]._m5.z) * g_BarnLights_1._m0[_12608]._m5.z;
	                float _14805 = 2.0 * g_BarnLights_1._m0[_12608]._m5.x;
	                float _9058 = _14805 * g_BarnLights_1._m0[_12608]._m5.y;
	                float _17330 = 2.0 * g_BarnLights_1._m0[_12608]._m5.w;
	                float _19825 = _17330 * g_BarnLights_1._m0[_12608]._m5.z;
	                vec3 _16268 = vec3(_9058 - _19825, (1.0 - (_14805 * g_BarnLights_1._m0[_12608]._m5.x)) - _18493, (_23572 * g_BarnLights_1._m0[_12608]._m5.z) + (_17330 * g_BarnLights_1._m0[_12608]._m5.x)) * g_BarnLights_1._m0[_12608]._m6.z;
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
	                    _11633 = ((_19667 * (g_BarnLights_1._m0[_12608]._m2.w / max(_18345, g_BarnLights_1._m0[_12608]._m2.w))) * clamp(g_BarnLights_1._m0[_12608]._m3.x + (g_BarnLights_1._m0[_12608]._m3.y * _17647), 0.0, 1.0)) * clamp(g_BarnLights_1._m0[_12608]._m6.x + (g_BarnLights_1._m0[_12608]._m6.y * dot(vec3((1.0 - (_23572 * g_BarnLights_1._m0[_12608]._m5.y)) - _18493, _9058 + _19825, (_14805 * g_BarnLights_1._m0[_12608]._m5.z) - (_17330 * g_BarnLights_1._m0[_12608]._m5.y)), normalize(_10210))), 0.0, 1.0);
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
	                        vec3 _20494 = _14081;
	                        _20494.x = _20564.x;
	                        _20494.y = _20564.y;
	                        _12503 = _17828.xyz * textureLod(sampler3D(g_bindless_Texture3D_float4[PerViewLightingConstantBufferGpu_t._m21], undetermined[_Globals_.g_sTrilinearWrap]), _20494.xyz, 0.0).xyz;
	                    }
	                    else
	                    {
	                        vec3 _13791 = vec3(fma(_22905.xy, vec2(0.5, -0.5), vec2(0.5)), g_BarnLights_1._m0[_12608]._m4.w);
	                        vec2 _20563 = (_13791.xy * g_BarnLights_1._m0[_12608]._m9.zw) + g_BarnLights_1._m0[_12608]._m9.xy;
	                        vec3 _20493 = _13791;
	                        _20493.x = _20563.x;
	                        _20493.y = _20563.y;
	                        _12503 = _17828.xyz * textureLod(sampler3D(g_bindless_Texture3D_float4[PerViewLightingConstantBufferGpu_t._m21], undetermined[_Globals_.g_sCookieSampler]), _20493.xyz, 0.0).xyz;
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
	                vec2 _17302 = max(_21816, vec2(g_BarnLights_1._m0[_12608]._m11));
	                vec3 _12282 = normalize(_11180.xyz + (-normalize(_10061.xyz - PerViewConstantBuffer_t._m4.xyz)).xyz).xyz;
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
	    float _17172 = dot(_21816.xy, vec2(0.5));
	    vec3 _7507 = _17892.xyz;
	    vec3 _17138 = normalize(_10061.xyz - PerViewConstantBuffer_t._m4.xyz);
	    float _17225 = _17172 * _17172;
	    float _20711 = saturate(1.0 - _17225);
	    vec4 _15343 = (vec4(-1.0, -0.0274999998509883880615234375, -0.572000026702880859375, 0.02199999988079071044921875) * _17172) + vec4(1.0, 0.0425000004470348358154296875, 1.03999996185302734375, -0.039999999105930328369140625);
	    float _21215 = _15343.x;
	    vec2 _24572 = (vec2(-1.03999996185302734375, 1.03999996185302734375) * ((min(_21215 * _21215, exp2((-9.27999973297119140625) * max(0.0, dot((-_17138).xyz, _7507)))) * _21215) + _15343.y)) + _15343.zw;
	    float _20339 = _24572.y;
	    vec2 _11427 = vec2(_20339, _24572.x + _20339);
	    vec3 _8745 = vec3(dot(PerViewLightingConstantBufferGpu_t._m0._m0[0].xyzw, _23875), dot(PerViewLightingConstantBufferGpu_t._m0._m0[1].xyzw, _23875), dot(PerViewLightingConstantBufferGpu_t._m0._m0[2].xyzw, _23875)).xyz;
	    vec3 _16991 = _16324.xyz + _8745;
	    vec3 _9666 = _8745 * vec3(_21712 * _17124).xyz;
	    vec3 _13436 = vec3(_17124 * _21712).xyz;
	    vec3 _20579;
	    if (_7406 > 0.0)
	    {
	        _20579 = mix(_9666, pow(_9666, vec3(1.0499999523162841796875, 0.949999988079071044921875, 0.800000011920928955078125)), vec3(_7406));
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
	    vec4 _20496 = _11203;
	    _20496.x = _15753.x;
	    _20496.y = _15753.y;
	    _20496.z = _15753.z;
	    vec3 _15734 = _20496.xyz + ((((mix(_11427.xxx, _11427.yyy, _9453) * textureLod(samplerCubeArray(g_bindless_TextureCubeArray_float4[PerViewConstantBufferCsgo_t._m6], undetermined[_Globals_.g_sTrilinearClamp]), vec4(normalize(mix(_7507, reflect(_17138.xyz, _17892.xyz).xyz, vec3(_20711 * (sqrt(_20711) + _17225)))), 0.0), PerViewLightingConstantBufferGpu_t._m8.y * sqrt(_17172)).xyz).xyz * (normalize(_16991 + vec3(0.001000000047497451305389404296875)) * clamp(length(_16991), 0.0, 1.75))).xyz * (vec3(1.0) + (normalize(_8745 + vec3(0.001000000047497451305389404296875)) * 0.5))).xyz * _13436).xyz;
	    vec4 _13888 = _20496;
	    _13888.x = _15734.x;
	    _13888.y = _15734.y;
	    _13888.z = _15734.z;
	    vec4 _6805;
	    if (_Globals_.g_bFogEnabled != 0)
	    {
	        vec3 _21493;
	        vec3 _22956 = _10061.xyz - PerViewConstantBuffer_t._m4.xyz;
	        vec3 _9057 = _22956.xyz;
	        vec3 _19340;
	        do
	        {
	            _21493 = _22956.xyz;
	            bool _12893;
	            if (dot(_21493, _21493) > PerViewConstantBufferCsgo_t._m19.x)
	            {
	                _12893 = (_10061.z * PerViewConstantBufferCsgo_t._m19.z) < PerViewConstantBufferCsgo_t._m19.y;
	            }
	            else
	            {
	                _12893 = false;
	            }
	            if (_12893)
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
	            bool _12894;
	            if (dot(_9057, _9057) > PerViewConstantBufferCsgo_t._m23.x)
	            {
	                _12894 = (PerViewConstantBufferCsgo_t._m23.z * _10061.z) < PerViewConstantBufferCsgo_t._m23.y;
	            }
	            else
	            {
	                _12894 = false;
	            }
	            if (_12894)
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
	float3 g_vAmbientOcclusionLevels1 < Default2(0, 0.5); Range(-1, 1); Attribute("0=Option 1,1=Option 2,2=Option 3"); UiType(VectorText); UiGroup("Material1/Lighting/21"); Expression(float3(-this.x,-1.4427*log(max(.0001,1-this.y)),2-this.z)); >;
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
	// SPIR-V source (106144 bytes), GLSL reflection with SPIRV-Cross by KhronosGroup
	
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
	    vec2 _g_fl_AutoPad23_;
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
	    bool _m36;
	    int _m37;
	    vec2 _m38;
	    vec2 _m39;
	    float _m40;
	    float _m41;
	    vec2 _m42;
	    float _m43;
	    float _m44;
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
	    uint _m84;
	    uint _m85;
	    uint _m86;
	    uint _m87;
	    uint _m88;
	    int _m89;
	    int _m90;
	    uint _m91;
	    uint _m92;
	    uint _m93;
	    bool _m94;
	    bool _m95;
	    bool _m96;
	    float _m97;
	    uint _m98;
	    float _m99;
	    float _m100;
	    bool _m101;
	    float _m102;
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
	
	const vec3 _414[3] = vec3[](vec3(-1.0, 0.0, 0.0), vec3(0.0, 1.0, 0.0), vec3(-1.0, 0.0, 0.0));
	const vec3 _418[3] = vec3[](vec3(0.0, 0.0, 1.0), vec3(0.0, -1.0, 0.0), vec3(0.0, 0.0, 1.0));
	
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
	
	vec4 _466;
	float _467;
	
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
	    _RTX_MATERIAL_DATA_ _1512 = _RTX_MATERIAL_DATA_(vec2(g_MaterialData_1._m0[g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 4u) / 4u]), g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 8u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 12u) / 4u], vec2(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 16u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 20u) / 4u]), g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 24u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 28u) / 4u], vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 32u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 36u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 40u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 44u) / 4u]), g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 48u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 52u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 56u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 60u) / 4u], vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 64u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 68u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 72u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 76u) / 4u]), vec2(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 80u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 84u) / 4u]), vec2(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 88u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 92u) / 4u]), g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 96u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 100u) / 4u], vec2(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 104u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 108u) / 4u]), vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 112u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 116u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 120u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 124u) / 4u]), vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 128u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 132u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 136u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 140u) / 4u]), vec2(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 144u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 148u) / 4u]), g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 152u) / 4u], g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 156u) / 4u], g_MaterialData_5._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 160u) / 4u] != 0, g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 164u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 168u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 172u) / 4u], vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 176u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 180u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 184u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 188u) / 4u]), vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 192u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 196u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 200u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 204u) / 4u]), vec3(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 208u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 212u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 216u) / 4u]), g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 220u) / 4u], g_MaterialData_5._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 224u) / 4u] != 0, g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 228u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 232u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 236u) / 4u], vec3(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 240u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 244u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 248u) / 4u]), g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 252u) / 4u], g_MaterialData_5._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 256u) / 4u] != 0, g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 260u) / 4u], vec2(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 264u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 268u) / 4u]), vec2(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 272u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 276u) / 4u]), g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 280u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 284u) / 4u], vec2(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 288u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 292u) / 4u]), g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 296u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 300u) / 4u], vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 304u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 308u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 312u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 316u) / 4u]), vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 320u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 324u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 328u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 332u) / 4u]), vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 336u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 340u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 344u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 348u) / 4u]), g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 352u) / 4u], g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 356u) / 4u], vec2(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 360u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 364u) / 4u]), vec2(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 368u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 372u) / 4u]), g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 376u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 380u) / 4u], vec2(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 384u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 388u) / 4u]), g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 392u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 396u) / 4u], vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 400u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 404u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 408u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 412u) / 4u]), vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 416u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 420u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 424u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 428u) / 4u]), vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 432u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 436u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 440u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 444u) / 4u]), g_MaterialData_7._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 448u) / 4u], g_MaterialData_7._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 452u) / 4u], g_MaterialData_7._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 456u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 460u) / 4u], mat4(vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 464u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 480u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 496u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 512u) / 4u]), vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 468u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 484u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 500u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 516u) / 4u]), vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 472u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 488u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 504u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 520u) / 4u]), vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 476u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 492u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 508u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 524u) / 4u])), mat4(vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 528u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 544u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 560u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 576u) / 4u]), vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 532u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 548u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 564u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 580u) / 4u]), vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 536u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 552u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 568u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 584u) / 4u]), vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 540u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 556u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 572u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 588u) / 4u])), g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 592u) / 4u], g_MaterialData_5._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 596u) / 4u] != 0, g_MaterialData_5._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 600u) / 4u] != 0, g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 604u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 608u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 612u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 616u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 620u) / 4u], vec3(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 624u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 628u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 632u) / 4u]), g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 636u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 640u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 644u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 648u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 652u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 656u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 660u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 664u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 668u) / 4u], g_MaterialData_7._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 672u) / 4u], g_MaterialData_7._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 676u) / 4u], g_MaterialData_7._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 680u) / 4u], g_MaterialData_7._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 684u) / 4u], g_MaterialData_7._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 688u) / 4u], g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 692u) / 4u], g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 696u) / 4u], g_MaterialData_7._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 700u) / 4u], g_MaterialData_7._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 704u) / 4u], g_MaterialData_7._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 708u) / 4u], g_MaterialData_5._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 712u) / 4u] != 0, g_MaterialData_5._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 716u) / 4u] != 0, g_MaterialData_5._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 720u) / 4u] != 0, g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 724u) / 4u], g_MaterialData_7._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 728u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 732u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 736u) / 4u], g_MaterialData_5._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 740u) / 4u] != 0, g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 744u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 748u) / 4u]);
	    _RTX_MATERIAL_DATA_ _g_rtx_material_data_ = _1512;
	    uvec3 _703;
	    do
	    {
	        if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes.w == 4)
	        {
	            uint _1573 = (12u * uint(gl_PrimitiveID)) + uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes.w);
	            _703 = uvec3(g_Indices_1[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._m0[_1573 / 4u], g_Indices_1[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._m0[(_1573 + 4u) / 4u], g_Indices_1[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._m0[(_1573 + 8u) / 4u]);
	            break;
	        }
	        else
	        {
	            uint _1548 = (6u * uint(gl_PrimitiveID)) + uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes.w);
	            uint _1549 = _1548 & 4294967292u;
	            uint _1550 = _1549 / 4u;
	            uint _1554 = (_1549 + 4u) / 4u;
	            uint _1559 = (g_Indices_1[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._m0[_1550] & 4294901760u) >> uint(16);
	            uint _1560 = g_Indices_1[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._m0[_1554] & 65535u;
	            uvec3 _704;
	            if (_1548 == _1549)
	            {
	                _704 = uvec3(g_Indices_1[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._m0[_1550] & 65535u, _1559, _1560);
	            }
	            else
	            {
	                _704 = uvec3(_1559, _1560, (g_Indices_1[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._m0[_1554] & 4294901760u) >> uint(16));
	            }
	            _703 = _704;
	            break;
	        }
	        break;
	    } while(false);
	    uint _1588 = uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.x);
	    uvec3 _1596 = (uvec3(uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes.x)) * _703) + uvec3(uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes.x));
	    vec3 _697[3];
	    uint _1598 = _1596.x;
	    _697[0] = vec3(g_Vertices_1[_1588]._m0[_1598 / 4u], g_Vertices_1[_1588]._m0[(_1598 + 4u) / 4u], g_Vertices_1[_1588]._m0[(_1598 + 8u) / 4u]);
	    uint _1612 = _1596.y;
	    _697[1] = vec3(g_Vertices_1[_1588]._m0[_1612 / 4u], g_Vertices_1[_1588]._m0[(_1612 + 4u) / 4u], g_Vertices_1[_1588]._m0[(_1612 + 8u) / 4u]);
	    uint _1626 = _1596.z;
	    _697[2] = vec3(g_Vertices_1[_1588]._m0[_1626 / 4u], g_Vertices_1[_1588]._m0[(_1626 + 4u) / 4u], g_Vertices_1[_1588]._m0[(_1626 + 8u) / 4u]);
	    int _698 = 0;
	    VS_INPUT vsInput[3];
	    for (;;)
	    {
	        if (!(_698 < 3))
	        {
	            break;
	        }
	        vsInput[_698].vColorBlendValues = _697[_698];
	        _698++;
	        continue;
	    }
	    vec2 _699[3];
	    _699[0] = vec2(0.0);
	    _699[1] = vec2(0.0);
	    _699[2] = vec2(0.0);
	    if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].y != 0)
	    {
	        ivec4 _696 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers;
	        uint _1669 = uint(_696[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].z]);
	        uint _1671 = uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].z);
	        ivec4 _694 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes;
	        ivec4 _695 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes;
	        uvec3 _1682 = (uvec3(uint(_694[_1671])) * _703) + uvec3(uint(_695[_1671]) + uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].x));
	        if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].y == 16)
	        {
	            uint _1817 = _1682.x;
	            _699[0] = vec2(g_Vertices_1[_1669]._m0[_1817 / 4u], g_Vertices_1[_1669]._m0[(_1817 + 4u) / 4u]);
	            uint _1826 = _1682.y;
	            _699[1] = vec2(g_Vertices_1[_1669]._m0[_1826 / 4u], g_Vertices_1[_1669]._m0[(_1826 + 4u) / 4u]);
	            uint _1835 = _1682.z;
	            _699[2] = vec2(g_Vertices_1[_1669]._m0[_1835 / 4u], g_Vertices_1[_1669]._m0[(_1835 + 4u) / 4u]);
	        }
	        else
	        {
	            if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].y == 34)
	            {
	                uint _1788 = _1682.x / 4u;
	                _699[0] = vec2(uint16BitsToFloat16(u16vec2(uvec2(g_Vertices_3[_1669]._m0[_1788], g_Vertices_3[_1669]._m0[_1788] >> uint(16)) & uvec2(65535u))));
	                uint _1798 = _1682.y / 4u;
	                _699[1] = vec2(uint16BitsToFloat16(u16vec2(uvec2(g_Vertices_3[_1669]._m0[_1798], g_Vertices_3[_1669]._m0[_1798] >> uint(16)) & uvec2(65535u))));
	                uint _1808 = _1682.z / 4u;
	                _699[2] = vec2(uint16BitsToFloat16(u16vec2(uvec2(g_Vertices_3[_1669]._m0[_1808], g_Vertices_3[_1669]._m0[_1808] >> uint(16)) & uvec2(65535u))));
	            }
	            else
	            {
	                if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].y == 37)
	                {
	                    uint _1695 = _1682.x / 4u;
	                    uint _1699 = (g_Vertices_3[_1669]._m0[_1695] & 65535u);
	                    int _693;
	                    if (_1699 > 32767u)
	                    {
	                        _693 = int(4294901760u | _1699);
	                    }
	                    else
	                    {
	                        _693 = int(_1699);
	                    }
	                    uint _1712 = (g_Vertices_3[_1669]._m0[_1695] & 4294901760u) >> uint(16);
	                    int _692;
	                    if (_1712 > 32767u)
	                    {
	                        _692 = int(4294901760u | _1712);
	                    }
	                    else
	                    {
	                        _692 = int(_1712);
	                    }
	                    _699[0] = vec2(max(float(_693) * 3.0518509447574615478515625e-05, -1.0), max(float(_692) * 3.0518509447574615478515625e-05, -1.0));
	                    uint _1726 = _1682.y / 4u;
	                    uint _1730 = (g_Vertices_3[_1669]._m0[_1726] & 65535u);
	                    int _691;
	                    if (_1730 > 32767u)
	                    {
	                        _691 = int(4294901760u | _1730);
	                    }
	                    else
	                    {
	                        _691 = int(_1730);
	                    }
	                    uint _1743 = (g_Vertices_3[_1669]._m0[_1726] & 4294901760u) >> uint(16);
	                    int _690;
	                    if (_1743 > 32767u)
	                    {
	                        _690 = int(4294901760u | _1743);
	                    }
	                    else
	                    {
	                        _690 = int(_1743);
	                    }
	                    _699[1] = vec2(max(float(_691) * 3.0518509447574615478515625e-05, -1.0), max(float(_690) * 3.0518509447574615478515625e-05, -1.0));
	                    uint _1757 = _1682.z / 4u;
	                    uint _1761 = (g_Vertices_3[_1669]._m0[_1757] & 65535u);
	                    int _689;
	                    if (_1761 > 32767u)
	                    {
	                        _689 = int(4294901760u | _1761);
	                    }
	                    else
	                    {
	                        _689 = int(_1761);
	                    }
	                    uint _1774 = (g_Vertices_3[_1669]._m0[_1757] & 4294901760u) >> uint(16);
	                    int _688;
	                    if (_1774 > 32767u)
	                    {
	                        _688 = int(4294901760u | _1774);
	                    }
	                    else
	                    {
	                        _688 = int(_1774);
	                    }
	                    _699[2] = vec2(max(float(_689) * 3.0518509447574615478515625e-05, -1.0), max(float(_688) * 3.0518509447574615478515625e-05, -1.0));
	                }
	            }
	        }
	    }
	    _698 = 0;
	    for (;;)
	    {
	        if (!(_698 < 3))
	        {
	            break;
	        }
	        vsInput[_698]._m1 = _699[_698];
	        _698++;
	        continue;
	    }
	    _699[0] = vec2(0.0);
	    _699[1] = vec2(0.0);
	    _699[2] = vec2(0.0);
	    if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[1].y != 0)
	    {
	        ivec4 _687 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers;
	        uint _1874 = uint(_687[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[1].z]);
	        uint _1876 = uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[1].z);
	        ivec4 _685 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes;
	        ivec4 _686 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes;
	        uvec3 _1887 = (uvec3(uint(_685[_1876])) * _703) + uvec3(uint(_686[_1876]) + uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[1].x));
	        if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[1].y == 16)
	        {
	            uint _2022 = _1887.x;
	            _699[0] = vec2(g_Vertices_1[_1874]._m0[_2022 / 4u], g_Vertices_1[_1874]._m0[(_2022 + 4u) / 4u]);
	            uint _2031 = _1887.y;
	            _699[1] = vec2(g_Vertices_1[_1874]._m0[_2031 / 4u], g_Vertices_1[_1874]._m0[(_2031 + 4u) / 4u]);
	            uint _2040 = _1887.z;
	            _699[2] = vec2(g_Vertices_1[_1874]._m0[_2040 / 4u], g_Vertices_1[_1874]._m0[(_2040 + 4u) / 4u]);
	        }
	        else
	        {
	            if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[1].y == 34)
	            {
	                uint _1993 = _1887.x / 4u;
	                _699[0] = vec2(uint16BitsToFloat16(u16vec2(uvec2(g_Vertices_3[_1874]._m0[_1993], g_Vertices_3[_1874]._m0[_1993] >> uint(16)) & uvec2(65535u))));
	                uint _2003 = _1887.y / 4u;
	                _699[1] = vec2(uint16BitsToFloat16(u16vec2(uvec2(g_Vertices_3[_1874]._m0[_2003], g_Vertices_3[_1874]._m0[_2003] >> uint(16)) & uvec2(65535u))));
	                uint _2013 = _1887.z / 4u;
	                _699[2] = vec2(uint16BitsToFloat16(u16vec2(uvec2(g_Vertices_3[_1874]._m0[_2013], g_Vertices_3[_1874]._m0[_2013] >> uint(16)) & uvec2(65535u))));
	            }
	            else
	            {
	                if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[1].y == 37)
	                {
	                    uint _1900 = _1887.x / 4u;
	                    uint _1904 = (g_Vertices_3[_1874]._m0[_1900] & 65535u);
	                    int _684;
	                    if (_1904 > 32767u)
	                    {
	                        _684 = int(4294901760u | _1904);
	                    }
	                    else
	                    {
	                        _684 = int(_1904);
	                    }
	                    uint _1917 = (g_Vertices_3[_1874]._m0[_1900] & 4294901760u) >> uint(16);
	                    int _683;
	                    if (_1917 > 32767u)
	                    {
	                        _683 = int(4294901760u | _1917);
	                    }
	                    else
	                    {
	                        _683 = int(_1917);
	                    }
	                    _699[0] = vec2(max(float(_684) * 3.0518509447574615478515625e-05, -1.0), max(float(_683) * 3.0518509447574615478515625e-05, -1.0));
	                    uint _1931 = _1887.y / 4u;
	                    uint _1935 = (g_Vertices_3[_1874]._m0[_1931] & 65535u);
	                    int _682;
	                    if (_1935 > 32767u)
	                    {
	                        _682 = int(4294901760u | _1935);
	                    }
	                    else
	                    {
	                        _682 = int(_1935);
	                    }
	                    uint _1948 = (g_Vertices_3[_1874]._m0[_1931] & 4294901760u) >> uint(16);
	                    int _681;
	                    if (_1948 > 32767u)
	                    {
	                        _681 = int(4294901760u | _1948);
	                    }
	                    else
	                    {
	                        _681 = int(_1948);
	                    }
	                    _699[1] = vec2(max(float(_682) * 3.0518509447574615478515625e-05, -1.0), max(float(_681) * 3.0518509447574615478515625e-05, -1.0));
	                    uint _1962 = _1887.z / 4u;
	                    uint _1966 = (g_Vertices_3[_1874]._m0[_1962] & 65535u);
	                    int _680;
	                    if (_1966 > 32767u)
	                    {
	                        _680 = int(4294901760u | _1966);
	                    }
	                    else
	                    {
	                        _680 = int(_1966);
	                    }
	                    uint _1979 = (g_Vertices_3[_1874]._m0[_1962] & 4294901760u) >> uint(16);
	                    int _679;
	                    if (_1979 > 32767u)
	                    {
	                        _679 = int(4294901760u | _1979);
	                    }
	                    else
	                    {
	                        _679 = int(_1979);
	                    }
	                    _699[2] = vec2(max(float(_680) * 3.0518509447574615478515625e-05, -1.0), max(float(_679) * 3.0518509447574615478515625e-05, -1.0));
	                }
	            }
	        }
	    }
	    _698 = 0;
	    for (;;)
	    {
	        if (!(_698 < 3))
	        {
	            break;
	        }
	        vsInput[_698]._m2 = _699[_698];
	        _698++;
	        continue;
	    }
	    vec3 _700[3];
	    vec4 _701[3];
	    do
	    {
	        if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.y != 0)
	        {
	            ivec4 _665 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers;
	            uint _2082 = uint(_665[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.z]);
	            uint _2084 = uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.z);
	            ivec4 _663 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes;
	            ivec4 _664 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes;
	            uvec3 _2095 = (uvec3(uint(_663[_2084])) * _703) + uvec3(uint(_664[_2084]) + uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.x));
	            if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.y == 6)
	            {
	                uint _2626 = _2095.x;
	                _700[0] = vec3(g_Vertices_1[_2082]._m0[_2626 / 4u], g_Vertices_1[_2082]._m0[(_2626 + 4u) / 4u], g_Vertices_1[_2082]._m0[(_2626 + 8u) / 4u]);
	                uint _2640 = _2095.y;
	                _700[1] = vec3(g_Vertices_1[_2082]._m0[_2640 / 4u], g_Vertices_1[_2082]._m0[(_2640 + 4u) / 4u], g_Vertices_1[_2082]._m0[(_2640 + 8u) / 4u]);
	                uint _2654 = _2095.z;
	                _700[2] = vec3(g_Vertices_1[_2082]._m0[_2654 / 4u], g_Vertices_1[_2082]._m0[(_2654 + 4u) / 4u], g_Vertices_1[_2082]._m0[(_2654 + 8u) / 4u]);
	            }
	            else
	            {
	                if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.y == 17)
	                {
	                    uint _2359 = _2095.x;
	                    uvec2 _2367 = uvec2(g_Vertices_3[_2082]._m0[_2359 / 4u], g_Vertices_3[_2082]._m0[(_2359 + 4u) / 4u]);
	                    uint _2368 = _2095.y;
	                    uvec2 _485 = uvec2(g_Vertices_3[_2082]._m0[_2368 / 4u], g_Vertices_3[_2082]._m0[(_2368 + 4u) / 4u]);
	                    uint _2377 = _2095.z;
	                    uvec2 _484 = uvec2(g_Vertices_3[_2082]._m0[_2377 / 4u], g_Vertices_3[_2082]._m0[(_2377 + 4u) / 4u]);
	                    uint _2389 = _2367.x;
	                    uint _2398 = _2367.y;
	                    vec2 _2408 = ((vec2(float((_2389) & 65535u), float((_2389 >> 16u) & 65535u)) * vec2(1.525902189314365386962890625e-05)) * 2.0) - vec2(1.0);
	                    float _2409 = _2408.x;
	                    float _2414 = (1.0 - abs(_2409)) - abs(_2408.y);
	                    vec3 _2415 = vec3(_2409, _2408.y, _2414);
	                    float _2417 = saturate(-_2414);
	                    vec2 _2423 = _2408 + mix(vec2(_2417), vec2(-_2417), greaterThanEqual(_2408, vec2(0.0)));
	                    _2415.x = _2423.x;
	                    _2415.y = _2423.y;
	                    vec3 _673 = normalize(_2415);
	                    vec2 _2430 = ((vec2(float((_2398 >> uint(1)) & 32767u), float((_2398 >> 16u) & 32767u)) * vec2(3.0518509447574615478515625e-05)) * 2.0) - vec2(1.0);
	                    float _2431 = _2430.x;
	                    float _2436 = (1.0 - abs(_2431)) - abs(_2430.y);
	                    vec3 _2437 = vec3(_2431, _2430.y, _2436);
	                    float _2439 = saturate(-_2436);
	                    vec2 _2445 = _2430 + mix(vec2(_2439), vec2(-_2439), greaterThanEqual(_2430, vec2(0.0)));
	                    _2437.x = _2445.x;
	                    _2437.y = _2445.y;
	                    vec3 _672 = normalize(_2437);
	                    float _653;
	                    if ((_2398 & 1u) != 0u)
	                    {
	                        _653 = 1.0;
	                    }
	                    else
	                    {
	                        _653 = -1.0;
	                    }
	                    _700[0] = _673;
	                    _701[0].w = _653;
	                    _701[0].x = _672.x;
	                    _701[0].y = _672.y;
	                    _701[0].z = _672.z;
	                    vec2 _2488 = ((vec2(float((_485.x) & 65535u), float((_485.x >> 16u) & 65535u)) * vec2(1.525902189314365386962890625e-05)) * 2.0) - vec2(1.0);
	                    float _2489 = _2488.x;
	                    float _2494 = (1.0 - abs(_2489)) - abs(_2488.y);
	                    vec3 _2495 = vec3(_2489, _2488.y, _2494);
	                    float _2497 = saturate(-_2494);
	                    vec2 _2503 = _2488 + mix(vec2(_2497), vec2(-_2497), greaterThanEqual(_2488, vec2(0.0)));
	                    _2495.x = _2503.x;
	                    _2495.y = _2503.y;
	                    vec3 _675 = normalize(_2495);
	                    vec2 _2510 = ((vec2(float((_485.y >> uint(1)) & 32767u), float((_485.y >> 16u) & 32767u)) * vec2(3.0518509447574615478515625e-05)) * 2.0) - vec2(1.0);
	                    float _2511 = _2510.x;
	                    float _2516 = (1.0 - abs(_2511)) - abs(_2510.y);
	                    vec3 _2517 = vec3(_2511, _2510.y, _2516);
	                    float _2519 = saturate(-_2516);
	                    vec2 _2525 = _2510 + mix(vec2(_2519), vec2(-_2519), greaterThanEqual(_2510, vec2(0.0)));
	                    _2517.x = _2525.x;
	                    _2517.y = _2525.y;
	                    vec3 _674 = normalize(_2517);
	                    float _652;
	                    if ((_485.y & 1u) != 0u)
	                    {
	                        _652 = 1.0;
	                    }
	                    else
	                    {
	                        _652 = -1.0;
	                    }
	                    _700[1] = _675;
	                    _701[1].w = _652;
	                    _701[1].x = _674.x;
	                    _701[1].y = _674.y;
	                    _701[1].z = _674.z;
	                    vec2 _2568 = ((vec2(float((_484.x) & 65535u), float((_484.x >> 16u) & 65535u)) * vec2(1.525902189314365386962890625e-05)) * 2.0) - vec2(1.0);
	                    float _2569 = _2568.x;
	                    float _2574 = (1.0 - abs(_2569)) - abs(_2568.y);
	                    vec3 _2575 = vec3(_2569, _2568.y, _2574);
	                    float _2577 = saturate(-_2574);
	                    vec2 _2583 = _2568 + mix(vec2(_2577), vec2(-_2577), greaterThanEqual(_2568, vec2(0.0)));
	                    _2575.x = _2583.x;
	                    _2575.y = _2583.y;
	                    vec3 _677 = normalize(_2575);
	                    vec2 _2590 = ((vec2(float((_484.y >> uint(1)) & 32767u), float((_484.y >> 16u) & 32767u)) * vec2(3.0518509447574615478515625e-05)) * 2.0) - vec2(1.0);
	                    float _2591 = _2590.x;
	                    float _2596 = (1.0 - abs(_2591)) - abs(_2590.y);
	                    vec3 _2597 = vec3(_2591, _2590.y, _2596);
	                    float _2599 = saturate(-_2596);
	                    vec2 _2605 = _2590 + mix(vec2(_2599), vec2(-_2599), greaterThanEqual(_2590, vec2(0.0)));
	                    _2597.x = _2605.x;
	                    _2597.y = _2605.y;
	                    vec3 _676 = normalize(_2597);
	                    float _651;
	                    if ((_484.y & 1u) != 0u)
	                    {
	                        _651 = 1.0;
	                    }
	                    else
	                    {
	                        _651 = -1.0;
	                    }
	                    _700[2] = _677;
	                    _701[2].w = _651;
	                    _701[2].x = _676.x;
	                    _701[2].y = _676.y;
	                    _701[2].z = _676.z;
	                    break;
	                }
	                else
	                {
	                    uint _2105 = _2095.x / 4u;
	                    vec4 _667 = _701[0];
	                    float _2120 = (float((g_Vertices_3[_2082]._m0[_2105] >> 12u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _2123 = (float((g_Vertices_3[_2082]._m0[_2105] >> 22u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _2127 = (1.0 - abs(_2120)) - abs(_2123);
	                    vec3 _2128 = vec3(_2120, _2123, _2127);
	                    float _2130 = saturate(-_2127);
	                    vec2 _2131 = vec2(_2120, _2123);
	                    vec2 _2137 = _2131 + mix(vec2(_2130), vec2(-_2130), greaterThanEqual(_2131, vec2(0.0)));
	                    _2128.x = _2137.x;
	                    _2128.y = _2137.y;
	                    vec3 _2142 = normalize(_2128);
	                    vec3 _666 = _2142;
	                    float _2143 = _2142.z;
	                    float _660;
	                    if (_2143 >= 0.0)
	                    {
	                        _660 = 1.0;
	                    }
	                    else
	                    {
	                        _660 = -1.0;
	                    }
	                    float _2150 = (-1.0) / (_660 + _2143);
	                    float _2151 = _2142.x;
	                    vec3 _661;
	                    vec3 _2159 = _661;
	                    _2159.x = 1.0 + (((_660 * _2151) * _2151) * _2150);
	                    _2159.y = _660 * ((_2151 * _2142.y) * _2150);
	                    _2159.z = (-_660) * _2151;
	                    _661 = _2159;
	                    float _2167 = float((g_Vertices_3[_2082]._m0[_2105] >> uint(1)) & 2047u) * 0.003069460391998291015625;
	                    vec3 _2173 = (_2159 * cos(_2167)) + (cross(_2142, _2159) * sin(_2167));
	                    vec4 _2175 = _667;
	                    _2175.x = _2173.x;
	                    _2175.y = _2173.y;
	                    _2175.z = _2173.z;
	                    _667 = _2175;
	                    float _662;
	                    if ((g_Vertices_3[_2082]._m0[_2105] & 1u) == 0u)
	                    {
	                        _662 = -1.0;
	                    }
	                    else
	                    {
	                        _662 = 1.0;
	                    }
	                    vec4 _2186 = _667;
	                    _2186.w = _662;
	                    _667 = _2186;
	                    _700[0] = _666;
	                    _701[0] = _2186;
	                    uint _2190 = _2095.y / 4u;
	                    vec4 _669 = _701[1];
	                    float _2205 = (float((g_Vertices_3[_2082]._m0[_2190] >> 12u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _2208 = (float((g_Vertices_3[_2082]._m0[_2190] >> 22u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _2212 = (1.0 - abs(_2205)) - abs(_2208);
	                    vec3 _2213 = vec3(_2205, _2208, _2212);
	                    float _2215 = saturate(-_2212);
	                    vec2 _2216 = vec2(_2205, _2208);
	                    vec2 _2222 = _2216 + mix(vec2(_2215), vec2(-_2215), greaterThanEqual(_2216, vec2(0.0)));
	                    _2213.x = _2222.x;
	                    _2213.y = _2222.y;
	                    vec3 _2227 = normalize(_2213);
	                    vec3 _668 = _2227;
	                    float _2228 = _2227.z;
	                    float _657;
	                    if (_2228 >= 0.0)
	                    {
	                        _657 = 1.0;
	                    }
	                    else
	                    {
	                        _657 = -1.0;
	                    }
	                    float _2235 = (-1.0) / (_657 + _2228);
	                    float _2236 = _2227.x;
	                    vec3 _658;
	                    vec3 _2244 = _658;
	                    _2244.x = 1.0 + (((_657 * _2236) * _2236) * _2235);
	                    _2244.y = _657 * ((_2236 * _2227.y) * _2235);
	                    _2244.z = (-_657) * _2236;
	                    _658 = _2244;
	                    float _2252 = float((g_Vertices_3[_2082]._m0[_2190] >> uint(1)) & 2047u) * 0.003069460391998291015625;
	                    vec3 _2258 = (_2244 * cos(_2252)) + (cross(_2227, _2244) * sin(_2252));
	                    vec4 _2260 = _669;
	                    _2260.x = _2258.x;
	                    _2260.y = _2258.y;
	                    _2260.z = _2258.z;
	                    _669 = _2260;
	                    float _659;
	                    if ((g_Vertices_3[_2082]._m0[_2190] & 1u) == 0u)
	                    {
	                        _659 = -1.0;
	                    }
	                    else
	                    {
	                        _659 = 1.0;
	                    }
	                    vec4 _2271 = _669;
	                    _2271.w = _659;
	                    _669 = _2271;
	                    _700[1] = _668;
	                    _701[1] = _2271;
	                    uint _2275 = _2095.z / 4u;
	                    vec4 _671 = _701[2];
	                    float _2290 = (float((g_Vertices_3[_2082]._m0[_2275] >> 12u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _2293 = (float((g_Vertices_3[_2082]._m0[_2275] >> 22u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _2297 = (1.0 - abs(_2290)) - abs(_2293);
	                    vec3 _2298 = vec3(_2290, _2293, _2297);
	                    float _2300 = saturate(-_2297);
	                    vec2 _2301 = vec2(_2290, _2293);
	                    vec2 _2307 = _2301 + mix(vec2(_2300), vec2(-_2300), greaterThanEqual(_2301, vec2(0.0)));
	                    _2298.x = _2307.x;
	                    _2298.y = _2307.y;
	                    vec3 _2312 = normalize(_2298);
	                    vec3 _670 = _2312;
	                    float _2313 = _2312.z;
	                    float _654;
	                    if (_2313 >= 0.0)
	                    {
	                        _654 = 1.0;
	                    }
	                    else
	                    {
	                        _654 = -1.0;
	                    }
	                    float _2320 = (-1.0) / (_654 + _2313);
	                    float _2321 = _2312.x;
	                    vec3 _655;
	                    vec3 _2329 = _655;
	                    _2329.x = 1.0 + (((_654 * _2321) * _2321) * _2320);
	                    _2329.y = _654 * ((_2321 * _2312.y) * _2320);
	                    _2329.z = (-_654) * _2321;
	                    _655 = _2329;
	                    float _2337 = float((g_Vertices_3[_2082]._m0[_2275] >> uint(1)) & 2047u) * 0.003069460391998291015625;
	                    vec3 _2343 = (_2329 * cos(_2337)) + (cross(_2312, _2329) * sin(_2337));
	                    vec4 _2345 = _671;
	                    _2345.x = _2343.x;
	                    _2345.y = _2343.y;
	                    _2345.z = _2343.z;
	                    _671 = _2345;
	                    float _656;
	                    if ((g_Vertices_3[_2082]._m0[_2275] & 1u) == 0u)
	                    {
	                        _656 = -1.0;
	                    }
	                    else
	                    {
	                        _656 = 1.0;
	                    }
	                    vec4 _2356 = _671;
	                    _2356.w = _656;
	                    _671 = _2356;
	                    _700[2] = _670;
	                    _701[2] = _2356;
	                    break;
	                }
	                break;
	            }
	        }
	        else
	        {
	            _700[0] = vec3(0.0);
	            _700[1] = vec3(0.0);
	            _700[2] = vec3(0.0);
	        }
	        if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTangentFieldInfo.y != 0)
	        {
	            ivec4 _678 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers;
	            uint _2679 = uint(_678[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTangentFieldInfo.z]);
	            uint _2681 = uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTangentFieldInfo.z);
	            ivec4 _649 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes;
	            ivec4 _650 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes;
	            uvec3 _2692 = (uvec3(uint(_649[_2681])) * _703) + uvec3(uint(_650[_2681]) + uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTangentFieldInfo.x));
	            uint _2694 = _2692.x;
	            _701[0] = vec4(g_Vertices_1[_2679]._m0[_2694 / 4u], g_Vertices_1[_2679]._m0[(_2694 + 4u) / 4u], g_Vertices_1[_2679]._m0[(_2694 + 8u) / 4u], g_Vertices_1[_2679]._m0[(_2694 + 12u) / 4u]);
	            uint _2712 = _2692.y;
	            _701[1] = vec4(g_Vertices_1[_2679]._m0[_2712 / 4u], g_Vertices_1[_2679]._m0[(_2712 + 4u) / 4u], g_Vertices_1[_2679]._m0[(_2712 + 8u) / 4u], g_Vertices_1[_2679]._m0[(_2712 + 12u) / 4u]);
	            uint _2730 = _2692.z;
	            _701[2] = vec4(g_Vertices_1[_2679]._m0[_2730 / 4u], g_Vertices_1[_2679]._m0[(_2730 + 4u) / 4u], g_Vertices_1[_2679]._m0[(_2730 + 8u) / 4u], g_Vertices_1[_2679]._m0[(_2730 + 12u) / 4u]);
	        }
	        else
	        {
	            _701[0] = vec4(0.0);
	            _701[1] = vec4(0.0);
	            _701[2] = vec4(0.0);
	        }
	        break;
	    } while(false);
	    _698 = 0;
	    for (;;)
	    {
	        if (!(_698 < 3))
	        {
	            break;
	        }
	        vsInput[_698]._m3 = _700[_698];
	        vsInput[_698]._m4 = _701[_698];
	        _698++;
	        continue;
	    }
	    vec4 _702[3];
	    if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vColorFieldInfo.data[0].y != 0)
	    {
	        ivec4 _648 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers;
	        uint _2781 = uint(_648[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vColorFieldInfo.data[0].z]);
	        uint _2783 = uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vColorFieldInfo.data[0].z);
	        ivec4 _646 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes;
	        ivec4 _647 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes;
	        uvec3 _2794 = (uvec3(uint(_646[_2783])) * _703) + uvec3(uint(_647[_2783]) + uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vColorFieldInfo.data[0].x));
	        if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vColorFieldInfo.data[0].y == 2)
	        {
	            uint _2848 = _2794.x;
	            _702[0] = vec4(g_Vertices_1[_2781]._m0[_2848 / 4u], g_Vertices_1[_2781]._m0[(_2848 + 4u) / 4u], g_Vertices_1[_2781]._m0[(_2848 + 8u) / 4u], g_Vertices_1[_2781]._m0[(_2848 + 12u) / 4u]);
	            uint _2866 = _2794.y;
	            _702[1] = vec4(g_Vertices_1[_2781]._m0[_2866 / 4u], g_Vertices_1[_2781]._m0[(_2866 + 4u) / 4u], g_Vertices_1[_2781]._m0[(_2866 + 8u) / 4u], g_Vertices_1[_2781]._m0[(_2866 + 12u) / 4u]);
	            uint _2884 = _2794.z;
	            _702[2] = vec4(g_Vertices_1[_2781]._m0[_2884 / 4u], g_Vertices_1[_2781]._m0[(_2884 + 4u) / 4u], g_Vertices_1[_2781]._m0[(_2884 + 8u) / 4u], g_Vertices_1[_2781]._m0[(_2884 + 12u) / 4u]);
	        }
	        else
	        {
	            uint _2801 = _2794.x / 4u;
	            _702[0] = vec4(uvec4((g_Vertices_3[_2781]._m0[_2801] & 255u), (g_Vertices_3[_2781]._m0[_2801] & 65280u) >> uint(8), (g_Vertices_3[_2781]._m0[_2801] & 16711680u) >> uint(16), (g_Vertices_3[_2781]._m0[_2801] & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	            uint _2817 = _2794.y / 4u;
	            _702[1] = vec4(uvec4((g_Vertices_3[_2781]._m0[_2817] & 255u), (g_Vertices_3[_2781]._m0[_2817] & 65280u) >> uint(8), (g_Vertices_3[_2781]._m0[_2817] & 16711680u) >> uint(16), (g_Vertices_3[_2781]._m0[_2817] & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	            uint _2833 = _2794.z / 4u;
	            _702[2] = vec4(uvec4((g_Vertices_3[_2781]._m0[_2833] & 255u), (g_Vertices_3[_2781]._m0[_2833] & 65280u) >> uint(8), (g_Vertices_3[_2781]._m0[_2833] & 16711680u) >> uint(16), (g_Vertices_3[_2781]._m0[_2833] & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	        }
	    }
	    else
	    {
	        _702[0] = vec4(0.0);
	        _702[1] = vec4(0.0);
	        _702[2] = vec4(0.0);
	    }
	    _698 = 0;
	    for (;;)
	    {
	        if (!(_698 < 3))
	        {
	            break;
	        }
	        vsInput[_698]._m7 = _702[_698];
	        _698++;
	        continue;
	    }
	    vec4 _705[3];
	    _705[0] = vec4(0.0);
	    _705[1] = vec4(0.0);
	    _705[2] = vec4(0.0);
	    if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[4].y != 0)
	    {
	        ivec4 _645 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers;
	        uint _2935 = uint(_645[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[4].z]);
	        uint _2937 = uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[4].z);
	        ivec4 _643 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes;
	        ivec4 _644 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes;
	        uvec3 _2948 = (uvec3(uint(_643[_2937])) * _703) + uvec3(uint(_644[_2937]) + uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[4].x));
	        if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[4].y == 2)
	        {
	            uint _3001 = _2948.x;
	            _705[0] = vec4(g_Vertices_1[_2935]._m0[_3001 / 4u], g_Vertices_1[_2935]._m0[(_3001 + 4u) / 4u], g_Vertices_1[_2935]._m0[(_3001 + 8u) / 4u], g_Vertices_1[_2935]._m0[(_3001 + 12u) / 4u]);
	            uint _3018 = _2948.y;
	            _705[1] = vec4(g_Vertices_1[_2935]._m0[_3018 / 4u], g_Vertices_1[_2935]._m0[(_3018 + 4u) / 4u], g_Vertices_1[_2935]._m0[(_3018 + 8u) / 4u], g_Vertices_1[_2935]._m0[(_3018 + 12u) / 4u]);
	            uint _3035 = _2948.z;
	            _705[2] = vec4(g_Vertices_1[_2935]._m0[_3035 / 4u], g_Vertices_1[_2935]._m0[(_3035 + 4u) / 4u], g_Vertices_1[_2935]._m0[(_3035 + 8u) / 4u], g_Vertices_1[_2935]._m0[(_3035 + 12u) / 4u]);
	        }
	        else
	        {
	            if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[4].y == 28)
	            {
	                uint _2957 = _2948.x / 4u;
	                _705[0] = vec4(uvec4((g_Vertices_3[_2935]._m0[_2957] & 255u), (g_Vertices_3[_2935]._m0[_2957] & 65280u) >> uint(8), (g_Vertices_3[_2935]._m0[_2957] & 16711680u) >> uint(16), (g_Vertices_3[_2935]._m0[_2957] & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	                uint _2972 = _2948.y / 4u;
	                _705[1] = vec4(uvec4((g_Vertices_3[_2935]._m0[_2972] & 255u), (g_Vertices_3[_2935]._m0[_2972] & 65280u) >> uint(8), (g_Vertices_3[_2935]._m0[_2972] & 16711680u) >> uint(16), (g_Vertices_3[_2935]._m0[_2972] & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	                uint _2987 = _2948.z / 4u;
	                _705[2] = vec4(uvec4((g_Vertices_3[_2935]._m0[_2987] & 255u), (g_Vertices_3[_2935]._m0[_2987] & 65280u) >> uint(8), (g_Vertices_3[_2935]._m0[_2987] & 16711680u) >> uint(16), (g_Vertices_3[_2935]._m0[_2987] & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	            }
	        }
	    }
	    int _706 = 0;
	    for (;;)
	    {
	        if (!(_706 < 3))
	        {
	            break;
	        }
	        vsInput[_706]._m8 = _705[_706];
	        _706++;
	        continue;
	    }
	    vec3 _640 = vsInput[0]._m3;
	    vec4 _641;
	    vec4 _3076 = _641;
	    _3076.x = vsInput[0]._m4.x;
	    _3076.y = vsInput[0]._m4.y;
	    _3076.z = vsInput[0]._m4.z;
	    _3076.w = vsInput[0]._m4.w;
	    _641 = _3076;
	    vec4 _3101 = vec4(uvec4((g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 255u), (g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 65280u) >> uint(8), (g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 16711680u) >> uint(16), (g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	    vec4 _639 = _3101;
	    vec3 _3102 = _3101.xyz;
	    vec3 _3103 = _3102 * vec3(0.077399380505084991455078125);
	    vec3 _3106 = pow((_3102 * vec3(0.947867333889007568359375)) + vec3(0.052132703363895416259765625), vec3(2.400000095367431640625));
	    float _636;
	    if (_3101.x <= 0.040449999272823333740234375)
	    {
	        _636 = _3103.x;
	    }
	    else
	    {
	        _636 = _3106.x;
	    }
	    float _637;
	    if (_3101.y <= 0.040449999272823333740234375)
	    {
	        _637 = _3103.y;
	    }
	    else
	    {
	        _637 = _3106.y;
	    }
	    float _638;
	    if (_3101.z <= 0.040449999272823333740234375)
	    {
	        _638 = _3103.z;
	    }
	    else
	    {
	        _638 = _3106.z;
	    }
	    vec3 _3131 = vec3(_636, _637, _638);
	    vec4 _3133 = _639;
	    _3133.x = _3131.x;
	    _3133.y = _3131.y;
	    _3133.z = _3131.z;
	    _639 = _3133;
	    vec4 _501;
	    vec4 _3140 = _501;
	    _3140.x = _3133.x;
	    _3140.y = _3133.y;
	    _3140.z = _3133.z;
	    _3140.w = _3133.w;
	    _501 = _3140;
	    mat3x4 _3151 = transpose(gl_WorldToObjectEXT);
	    mat3 _635;
	    mat3 _3154 = _635;
	    _3154[0] = _3151[0].xyz;
	    _3154[1] = _3151[1].xyz;
	    _3154[2] = _3151[2].xyz;
	    _635 = _3154;
	    vec3 _3163 = normalize(_3154 * _640.xyz);
	    vec3 _502;
	    vec3 _3165 = _502;
	    _3165.x = _3163.x;
	    _3165.y = _3163.y;
	    _3165.z = _3163.z;
	    _502 = _3165;
	    mat3x4 _3177 = transpose(gl_WorldToObjectEXT);
	    mat3 _634;
	    mat3 _3180 = _634;
	    _3180[0] = _3177[0].xyz;
	    _3180[1] = _3177[1].xyz;
	    _3180[2] = _3177[2].xyz;
	    _634 = _3180;
	    vec3 _3189 = normalize(_3180 * _641.xyz);
	    vec4 _500;
	    vec4 _3191 = _500;
	    _3191.x = _3189.x;
	    _3191.y = _3189.y;
	    _3191.z = _3189.z;
	    _3191.w = _641.w;
	    _500 = _3191;
	    vec4 _3200 = vsInput[0]._m1.xyxy;
	    _3200.z = vsInput[0]._m2.x;
	    _3200.w = vsInput[0]._m2.y;
	    vec4 _503;
	    vec4 _499 = _503;
	    vec3 _498 = vec4(vsInput[0].vColorBlendValues.xyz, 1.0) * transpose(gl_ObjectToWorldEXT);
	    vec3 _497 = _3165;
	    vec4 _496 = _3200;
	    vec4 _495 = _3140;
	    vec4 _494 = _3191;
	    if (_g_rtx_material_data_._m37 > 0)
	    {
	        vec2 _642;
	        if (_g_rtx_material_data_._m37 == 2)
	        {
	            _642 = _3200.zw;
	        }
	        else
	        {
	            _642 = _3200.xy;
	        }
	        vec4 _3222 = _496;
	        _3222.x = _642.x;
	        _3222.y = _642.y;
	        vec4 _3241 = _3222;
	        _3241.x = dot(_3222.xy, _g_rtx_material_data_._m45.xy) + _g_rtx_material_data_._m45.w;
	        _3241.y = dot(_3222.xy, _g_rtx_material_data_._m46.xy) + _g_rtx_material_data_._m46.w;
	        _496 = _3241;
	    }
	    vec4 _3243 = _495;
	    vec4 _3245 = _499;
	    _3245.x = _3243.x;
	    _3245.y = _3243.y;
	    _3245.z = _3243.z;
	    _3245.w = _g_rtx_material_data_._m29 * (1.0 - min(_3245.x, min(_3245.y, _3245.z)));
	    _499 = _3245;
	    _3243.x = _g_rtx_material_data_._m28.x;
	    _3243.y = _g_rtx_material_data_._m28.y;
	    _3243.z = _g_rtx_material_data_._m28.z;
	    vec3 _3274 = _3243.xyz * mix(vec3(1.0), vsInput[0]._m7.xyz, vec3(vsInput[0]._m7.w));
	    vec4 _3276 = _3243;
	    _3276.x = _3274.x;
	    _3276.y = _3274.y;
	    _3276.z = _3274.z;
	    _495 = _3276;
	    vec4 _483 = _3245;
	    vec3 _482 = _498;
	    vec3 _481 = _497;
	    vec4 _480 = _496;
	    vec4 _479 = _494;
	    vec3 _631 = vsInput[1]._m3;
	    vec4 _632;
	    vec4 _3290 = _632;
	    _3290.x = vsInput[1]._m4.x;
	    _3290.y = vsInput[1]._m4.y;
	    _3290.z = vsInput[1]._m4.z;
	    _3290.w = vsInput[1]._m4.w;
	    _632 = _3290;
	    vec4 _3315 = vec4(uvec4((g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 255u), (g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 65280u) >> uint(8), (g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 16711680u) >> uint(16), (g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	    vec4 _630 = _3315;
	    vec3 _3316 = _3315.xyz;
	    vec3 _3317 = _3316 * vec3(0.077399380505084991455078125);
	    vec3 _3320 = pow((_3316 * vec3(0.947867333889007568359375)) + vec3(0.052132703363895416259765625), vec3(2.400000095367431640625));
	    float _627;
	    if (_3315.x <= 0.040449999272823333740234375)
	    {
	        _627 = _3317.x;
	    }
	    else
	    {
	        _627 = _3320.x;
	    }
	    float _628;
	    if (_3315.y <= 0.040449999272823333740234375)
	    {
	        _628 = _3317.y;
	    }
	    else
	    {
	        _628 = _3320.y;
	    }
	    float _629;
	    if (_3315.z <= 0.040449999272823333740234375)
	    {
	        _629 = _3317.z;
	    }
	    else
	    {
	        _629 = _3320.z;
	    }
	    vec3 _3345 = vec3(_627, _628, _629);
	    vec4 _3347 = _630;
	    _3347.x = _3345.x;
	    _3347.y = _3345.y;
	    _3347.z = _3345.z;
	    _630 = _3347;
	    vec4 _511;
	    vec4 _3354 = _511;
	    _3354.x = _3347.x;
	    _3354.y = _3347.y;
	    _3354.z = _3347.z;
	    _3354.w = _3347.w;
	    _511 = _3354;
	    mat3x4 _3365 = transpose(gl_WorldToObjectEXT);
	    mat3 _626;
	    mat3 _3368 = _626;
	    _3368[0] = _3365[0].xyz;
	    _3368[1] = _3365[1].xyz;
	    _3368[2] = _3365[2].xyz;
	    _626 = _3368;
	    vec3 _3377 = normalize(_3368 * _631.xyz);
	    vec3 _512;
	    vec3 _3379 = _512;
	    _3379.x = _3377.x;
	    _3379.y = _3377.y;
	    _3379.z = _3377.z;
	    _512 = _3379;
	    mat3x4 _3391 = transpose(gl_WorldToObjectEXT);
	    mat3 _625;
	    mat3 _3394 = _625;
	    _3394[0] = _3391[0].xyz;
	    _3394[1] = _3391[1].xyz;
	    _3394[2] = _3391[2].xyz;
	    _625 = _3394;
	    vec3 _3403 = normalize(_3394 * _632.xyz);
	    vec4 _510;
	    vec4 _3405 = _510;
	    _3405.x = _3403.x;
	    _3405.y = _3403.y;
	    _3405.z = _3403.z;
	    _3405.w = _632.w;
	    _510 = _3405;
	    vec4 _3414 = vsInput[1]._m1.xyxy;
	    _3414.z = vsInput[1]._m2.x;
	    _3414.w = vsInput[1]._m2.y;
	    vec4 _513;
	    vec4 _509 = _513;
	    vec3 _508 = vec4(vsInput[1].vColorBlendValues.xyz, 1.0) * transpose(gl_ObjectToWorldEXT);
	    vec3 _507 = _3379;
	    vec4 _506 = _3414;
	    vec4 _505 = _3354;
	    vec4 _504 = _3405;
	    if (_g_rtx_material_data_._m37 > 0)
	    {
	        vec2 _633;
	        if (_g_rtx_material_data_._m37 == 2)
	        {
	            _633 = _3414.zw;
	        }
	        else
	        {
	            _633 = _3414.xy;
	        }
	        vec4 _3436 = _506;
	        _3436.x = _633.x;
	        _3436.y = _633.y;
	        vec4 _3455 = _3436;
	        _3455.x = dot(_3436.xy, _g_rtx_material_data_._m45.xy) + _g_rtx_material_data_._m45.w;
	        _3455.y = dot(_3436.xy, _g_rtx_material_data_._m46.xy) + _g_rtx_material_data_._m46.w;
	        _506 = _3455;
	    }
	    vec4 _3457 = _505;
	    vec4 _3459 = _509;
	    _3459.x = _3457.x;
	    _3459.y = _3457.y;
	    _3459.z = _3457.z;
	    _3459.w = _g_rtx_material_data_._m29 * (1.0 - min(_3459.x, min(_3459.y, _3459.z)));
	    _509 = _3459;
	    _3457.x = _g_rtx_material_data_._m28.x;
	    _3457.y = _g_rtx_material_data_._m28.y;
	    _3457.z = _g_rtx_material_data_._m28.z;
	    vec3 _3488 = _3457.xyz * mix(vec3(1.0), vsInput[1]._m7.xyz, vec3(vsInput[1]._m7.w));
	    vec4 _3490 = _3457;
	    _3490.x = _3488.x;
	    _3490.y = _3488.y;
	    _3490.z = _3488.z;
	    _505 = _3490;
	    vec4 _478 = _3459;
	    vec3 _477 = _508;
	    vec3 _476 = _507;
	    vec4 _475 = _506;
	    vec4 _474 = _504;
	    vec3 _622 = vsInput[2]._m3;
	    vec4 _623;
	    vec4 _3504 = _623;
	    _3504.x = vsInput[2]._m4.x;
	    _3504.y = vsInput[2]._m4.y;
	    _3504.z = vsInput[2]._m4.z;
	    _3504.w = vsInput[2]._m4.w;
	    _623 = _3504;
	    vec4 _3529 = vec4(uvec4((g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 255u), (g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 65280u) >> uint(8), (g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 16711680u) >> uint(16), (g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	    vec4 _621 = _3529;
	    vec3 _3530 = _3529.xyz;
	    vec3 _3531 = _3530 * vec3(0.077399380505084991455078125);
	    vec3 _3534 = pow((_3530 * vec3(0.947867333889007568359375)) + vec3(0.052132703363895416259765625), vec3(2.400000095367431640625));
	    float _618;
	    if (_3529.x <= 0.040449999272823333740234375)
	    {
	        _618 = _3531.x;
	    }
	    else
	    {
	        _618 = _3534.x;
	    }
	    float _619;
	    if (_3529.y <= 0.040449999272823333740234375)
	    {
	        _619 = _3531.y;
	    }
	    else
	    {
	        _619 = _3534.y;
	    }
	    float _620;
	    if (_3529.z <= 0.040449999272823333740234375)
	    {
	        _620 = _3531.z;
	    }
	    else
	    {
	        _620 = _3534.z;
	    }
	    vec3 _3559 = vec3(_618, _619, _620);
	    vec4 _3561 = _621;
	    _3561.x = _3559.x;
	    _3561.y = _3559.y;
	    _3561.z = _3559.z;
	    _621 = _3561;
	    vec4 _521;
	    vec4 _3568 = _521;
	    _3568.x = _3561.x;
	    _3568.y = _3561.y;
	    _3568.z = _3561.z;
	    _3568.w = _3561.w;
	    _521 = _3568;
	    mat3x4 _3579 = transpose(gl_WorldToObjectEXT);
	    mat3 _617;
	    mat3 _3582 = _617;
	    _3582[0] = _3579[0].xyz;
	    _3582[1] = _3579[1].xyz;
	    _3582[2] = _3579[2].xyz;
	    _617 = _3582;
	    vec3 _3591 = normalize(_3582 * _622.xyz);
	    vec3 _522;
	    vec3 _3593 = _522;
	    _3593.x = _3591.x;
	    _3593.y = _3591.y;
	    _3593.z = _3591.z;
	    _522 = _3593;
	    mat3x4 _3605 = transpose(gl_WorldToObjectEXT);
	    mat3 _616;
	    mat3 _3608 = _616;
	    _3608[0] = _3605[0].xyz;
	    _3608[1] = _3605[1].xyz;
	    _3608[2] = _3605[2].xyz;
	    _616 = _3608;
	    vec3 _3617 = normalize(_3608 * _623.xyz);
	    vec4 _520;
	    vec4 _3619 = _520;
	    _3619.x = _3617.x;
	    _3619.y = _3617.y;
	    _3619.z = _3617.z;
	    _3619.w = _623.w;
	    _520 = _3619;
	    vec4 _3628 = vsInput[2]._m1.xyxy;
	    _3628.z = vsInput[2]._m2.x;
	    _3628.w = vsInput[2]._m2.y;
	    vec4 _523;
	    vec4 _519 = _523;
	    vec3 _518 = vec4(vsInput[2].vColorBlendValues.xyz, 1.0) * transpose(gl_ObjectToWorldEXT);
	    vec3 _517 = _3593;
	    vec4 _516 = _3628;
	    vec4 _515 = _3568;
	    vec4 _514 = _3619;
	    if (_g_rtx_material_data_._m37 > 0)
	    {
	        vec2 _624;
	        if (_g_rtx_material_data_._m37 == 2)
	        {
	            _624 = _3628.zw;
	        }
	        else
	        {
	            _624 = _3628.xy;
	        }
	        vec4 _3650 = _516;
	        _3650.x = _624.x;
	        _3650.y = _624.y;
	        vec4 _3669 = _3650;
	        _3669.x = dot(_3650.xy, _g_rtx_material_data_._m45.xy) + _g_rtx_material_data_._m45.w;
	        _3669.y = dot(_3650.xy, _g_rtx_material_data_._m46.xy) + _g_rtx_material_data_._m46.w;
	        _516 = _3669;
	    }
	    vec4 _3671 = _515;
	    vec4 _3673 = _519;
	    _3673.x = _3671.x;
	    _3673.y = _3671.y;
	    _3673.z = _3671.z;
	    _3673.w = _g_rtx_material_data_._m29 * (1.0 - min(_3673.x, min(_3673.y, _3673.z)));
	    _519 = _3673;
	    _3671.x = _g_rtx_material_data_._m28.x;
	    _3671.y = _g_rtx_material_data_._m28.y;
	    _3671.z = _g_rtx_material_data_._m28.z;
	    vec3 _3702 = _3671.xyz * mix(vec3(1.0), vsInput[2]._m7.xyz, vec3(vsInput[2]._m7.w));
	    vec4 _3704 = _3671;
	    _3704.x = _3702.x;
	    _3704.y = _3702.y;
	    _3704.z = _3702.z;
	    _515 = _3704;
	    vec3 _473 = _518;
	    vec3 _472 = _517;
	    vec3 _3732 = ((_481 * ((1.0 - _22.barycentrics.x) - _22.barycentrics.y)) + (_476 * _22.barycentrics.x)) + (_517 * _22.barycentrics.y);
	    bool _3738 = gl_HitKindEXT == 254u;
	    vec3 _524;
	    vec3 _525;
	    vec4 _493 = ((_483 * ((1.0 - _22.barycentrics.x) - _22.barycentrics.y)) + (_478 * _22.barycentrics.x)) + (_3673 * _22.barycentrics.y);
	    vec3 _492 = _525;
	    vec3 _491 = _3732;
	    vec4 _490 = ((_480 * ((1.0 - _22.barycentrics.x) - _22.barycentrics.y)) + (_475 * _22.barycentrics.x)) + (_516 * _22.barycentrics.y);
	    vec4 _489 = ((_479 * ((1.0 - _22.barycentrics.x) - _22.barycentrics.y)) + (_474 * _22.barycentrics.x)) + (_514 * _22.barycentrics.y);
	    bool _488 = _3738;
	    vec2 _532 = vec2(0.5);
	    vec3 _531 = vec3(0.0);
	    float _530 = 0.039999999105930328369140625;
	    vec3 _529 = vec3(0.0);
	    vec3 _527 = vec3(1.0);
	    bool _526 = false;
	    vec3 _3768 = _3732.xyz;
	    vec3 _528 = _3768;
	    if (dot(_3768, _3768) >= 1.0099999904632568359375)
	    {
	        _528 = _524.xyz;
	    }
	    _530 = _g_rtx_material_data_._m97;
	    _527 = normalize(cross(_477 - _482, _518 - _482));
	    bool _614;
	    if (_g_rtx_material_data_._m96)
	    {
	        _614 = !_g_rtx_material_data_._m95;
	    }
	    else
	    {
	        _614 = false;
	    }
	    if (_614)
	    {
	        float _615;
	        if (_3738)
	        {
	            _615 = 1.0;
	        }
	        else
	        {
	            _615 = -1.0;
	        }
	        _528 *= _615;
	        if (_3738)
	        {
	            _615 = 1.0;
	        }
	        else
	        {
	            _615 = -1.0;
	        }
	        _527 *= _615;
	        _526 = !_3738;
	    }
	    vec3 _3799 = _528;
	    vec3 _3800 = normalize(_3799);
	    _528 = _3800;
	    vec2 _559 = _532;
	    vec3 _558 = _531;
	    float _557 = _530;
	    vec3 _556 = _529;
	    vec3 _555 = _3800;
	    vec3 _554 = _527;
	    bool _553 = _526;
	    bool _612;
	    if (_g_rtx_material_data_._m96)
	    {
	        _612 = !_g_rtx_material_data_._m95;
	    }
	    else
	    {
	        _612 = false;
	    }
	    if (_612)
	    {
	        float _613;
	        if (_488)
	        {
	            _613 = 1.0;
	        }
	        else
	        {
	            _613 = -1.0;
	        }
	        _612 = _613 < 0.0;
	    }
	    else
	    {
	        _612 = false;
	    }
	    vec3 _563 = vec3(0.0);
	    vec3 _562 = vec3(0.0);
	    float _610;
	    if (_489.w > 0.0)
	    {
	        _610 = 1.0;
	    }
	    else
	    {
	        _610 = -1.0;
	    }
	    float _3845 = 1.0 / length(_491);
	    vec3 _564 = _491 * _3845;
	    vec3 _487 = _489.xyz * _3845;
	    vec3 _486 = (cross(_491, _489.xyz) * _610) * _3845;
	    if (_612)
	    {
	        _564 *= (-1.0);
	    }
	    vec3 _561 = _563 - (_564 * dot(_563, _564));
	    vec3 _560 = _562 - (_564 * dot(_562, _564));
	    int _611;
	    if (dot(_562, cross(_564, _563)) < 0.0)
	    {
	        _611 = -1;
	    }
	    else
	    {
	        _611 = 1;
	    }
	    vec3 _580 = _564;
	    vec3 _579 = _561;
	    vec3 _578 = _560;
	    float _577 = float(_611);
	    vec3 _551;
	    vec3 _552;
	    if (_g_rtx_material_data_._m37 > 1)
	    {
	        float _609;
	        if (false)
	        {
	            _609 = -1.0;
	        }
	        else
	        {
	            _609 = 1.0;
	        }
	        vec2 _3881 = vec2(0.0, -0.0) * _609;
	        vec3 _565 = (_579 * _3881.x) + (_578 * _3881.y);
	        float _3889 = abs(0.0);
	        if (_3889 > 0.0)
	        {
	            _565 = normalize(_565);
	        }
	        _552 = _565;
	        _551 = cross(_580, _565) * (_609 * _577);
	    }
	    vec2 _550 = vec2(0.0);
	    vec2 _549 = vec2(0.0);
	    vec2 _548 = vec2(0.0);
	    vec2 _547 = vec2(0.0);
	    vec2 _546 = vec2(0.0);
	    vec2 _545 = vec2(0.0);
	    vec2 _544 = vec2(0.0);
	    ivec2 _543 = ivec2(0);
	    ivec2 _542 = ivec2(0);
	    if (_g_rtx_material_data_._m37 == 0)
	    {
	        vec3 _3909 = abs(_555);
	        vec3 _604 = _3909;
	        float _3910 = _3909.x;
	        float _3911 = _3909.y;
	        bool _605;
	        if (_3910 > _3911)
	        {
	            _605 = _3910 > _3909.z;
	        }
	        else
	        {
	            _605 = false;
	        }
	        ivec3 _606;
	        if (_605)
	        {
	            _606 = ivec3(0, 1, 2);
	        }
	        else
	        {
	            if (_3911 > _3909.z)
	            {
	                _606 = ivec3(1, 2, 0);
	            }
	            else
	            {
	                _606 = ivec3(2, 0, 1);
	            }
	        }
	        if (_3910 < _3911)
	        {
	            _605 = _3910 < _3909.z;
	        }
	        else
	        {
	            _605 = false;
	        }
	        ivec3 _607;
	        if (_605)
	        {
	            _607 = ivec3(0, 1, 2);
	        }
	        else
	        {
	            if (_3911 < _3909.z)
	            {
	                _607 = ivec3(1, 2, 0);
	            }
	            else
	            {
	                _607 = ivec3(2, 0, 1);
	            }
	        }
	        ivec3 _3945 = (ivec3(3) - _607) - _606;
	        ivec2 _608;
	        if (_606.x == 1)
	        {
	            _608 = _606.zy;
	        }
	        else
	        {
	            _608 = _606.yz;
	        }
	        ivec2 _3957 = _543;
	        _3957.x = _608.x;
	        _3957.y = _608.y;
	        _543 = _3957;
	        int _3961 = _3945.x;
	        if (_3961 == 1)
	        {
	            _608 = _3945.zy;
	        }
	        else
	        {
	            _608 = _3945.yz;
	        }
	        ivec2 _3970 = _542;
	        _3970.x = _608.x;
	        _3970.y = _608.y;
	        _542 = _3970;
	        _544 = vec2(_604[_606.x], _604[_3961]) / vec2(_604[_606.x] + _604[_3961]);
	        vec3 _595 = _492 * _g_rtx_material_data_._m34.xyz;
	        _550 = vec2(_595[_543.x], _595[_543.y]);
	        vec3 _596 = vec3(0.0);
	        vec3 _597 = vec3(0.0);
	        _548 = vec2(_596[_543.x], _597[_543.y]);
	        vec3 _598 = vec3(0.0);
	        vec3 _599 = vec3(0.0);
	        _547 = vec2(_598[_543.x], _599[_543.y]);
	        _549 = vec2(_595[_3970.x], _595[_3970.y]);
	        vec3 _600 = vec3(0.0);
	        vec3 _601 = vec3(0.0);
	        _546 = vec2(_600[_3970.x], _601[_3970.y]);
	        vec3 _602 = vec3(0.0);
	        vec3 _603 = vec3(0.0);
	        _545 = vec2(_602[_3970.x], _603[_3970.y]);
	    }
	    vec4 _541 = vec4(0.0);
	    vec3 _540 = vec3(0.0);
	    vec3 _539 = vec3(0.0);
	    vec4 _536 = vec4(0.0);
	    float _535 = 0.0;
	    float _534 = 0.0;
	    float _533 = 0.0;
	    vec3 _4033 = vec3(0.0);
	    _4033.x = _490.x;
	    _4033.y = _490.y;
	    vec3 _538 = _4033;
	    vec2 _537 = _g_rtx_material_data_._m38.xy;
	    vec4 _594;
	    if (_g_rtx_material_data_._m37 == 0)
	    {
	        vec2 _4052 = _550;
	        vec2 _4053 = _4052 * _537;
	        _550 = _4053;
	        vec2 _4054 = _548;
	        vec2 _4055 = _4054 * _537;
	        _548 = _4055;
	        vec2 _4056 = _547;
	        vec2 _4057 = _4056 * _537;
	        _547 = _4057;
	        vec2 _4058 = _549;
	        vec2 _4059 = _4058 * _537;
	        _549 = _4059;
	        vec2 _4060 = _546;
	        vec2 _4061 = _4060 * _537;
	        _546 = _4061;
	        vec2 _4062 = _545;
	        vec2 _4063 = _4062 * _537;
	        _545 = _4063;
	        vec4 _4072 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_._m61], g_bindless_Sampler[_g_rtx_material_data_._m91]), _4053.xy, _4055.xy, _4057.xy);
	        vec4 _4080 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_._m61], g_bindless_Sampler[_g_rtx_material_data_._m91]), _4059.xy, _4061.xy, _4063.xy);
	        vec2 _4081 = _544;
	        vec2 _4086 = (_4081 * 3.0) + vec2(_4072.x, _4080.x);
	        vec2 _4093 = max(_4086 - vec2(max(_4086.x, _4086.y) - 0.0500000007450580596923828125), vec2(0.0));
	        vec2 _4098 = _4093 / vec2(_4093.x + _4093.y);
	        _544 = _4098;
	        _594 = (_4072 * _4098.x) + (_4080 * _4098.y);
	    }
	    else
	    {
	        _594 = textureLod(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_._m61], g_bindless_Sampler[_g_rtx_material_data_._m91]), _538.xy, 0.0).xyzw;
	    }
	    _534 = _594.y;
	    _535 = _594.w;
	    vec2 _574 = _550;
	    vec2 _573 = _549;
	    vec2 _572 = _548;
	    vec2 _571 = _547;
	    vec2 _570 = _546;
	    vec2 _569 = _545;
	    vec2 _568 = _544;
	    ivec2 _567 = _543;
	    ivec2 _566 = _542;
	    if (_g_rtx_material_data_._m37 == 0)
	    {
	        vec2 _4175 = _574;
	        vec2 _4176 = _4175 * _537;
	        _574 = _4176;
	        vec2 _4177 = _572;
	        vec2 _4178 = _4177 * _537;
	        _572 = _4178;
	        vec2 _4179 = _571;
	        vec2 _4180 = _4179 * _537;
	        _571 = _4180;
	        _573 *= _537;
	        _570 *= _537;
	        _569 *= _537;
	        _541 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_._m93], g_bindless_Sampler[_g_rtx_material_data_._m91]), _4176.xy, _4178.xy, _4180.xy) * _568.x;
	        vec4 _4206 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_._m60], g_bindless_Sampler[_g_rtx_material_data_._m91]), _4176.xy, _4178.xy, _4180.xy);
	        _533 = _4206.z * _568.x;
	        float _4210 = _4206.x;
	        float _4211 = _4206.y;
	        float _4213 = (_4210 + _4211) - 1.00392162799835205078125;
	        float _4214 = _4210 - _4211;
	        vec3 _4225 = (normalize(vec3(vec2(_4213, _4214), (1.0 - abs(_4213)) - abs(_4214))).xyz * _568.x) * 1.0;
	        vec4 _4227;
	        _4227.x = _4225.x;
	        _4227.y = _4225.y;
	        vec4 _4231 = _4227;
	        _4231.z = _4225.z;
	        _539 = (_414[_567.x] * _4227.x) + (_418[_567.y] * _4227.y);
	        if (_568.y > 0.0)
	        {
	            _541 += (textureGrad(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_._m93], g_bindless_Sampler[_g_rtx_material_data_._m91]), _573.xy, _570.xy, _569.xy) * _568.y);
	            vec4 _4272 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_._m60], g_bindless_Sampler[_g_rtx_material_data_._m91]), _573.xy, _570.xy, _569.xy);
	            _533 += (_4272.z * _568.y);
	            float _4278 = _4272.x;
	            float _4279 = _4272.y;
	            float _4281 = (_4278 + _4279) - 1.00392162799835205078125;
	            float _4282 = _4278 - _4279;
	            vec3 _4293 = (normalize(vec3(vec2(_4281, _4282), (1.0 - abs(_4281)) - abs(_4282))).xyz * _568.y) * 1.0;
	            vec4 _4295;
	            _4295.x = _4293.x;
	            _4295.y = _4293.y;
	            vec4 _4299 = _4295;
	            _4299.z = _4293.z;
	            _539 += ((_414[_566.x] * _4295.x) + (_418[_566.y] * _4295.y));
	        }
	        _539 = normalize(_539 + _555);
	    }
	    else
	    {
	        _541 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_._m93], g_bindless_Sampler[_g_rtx_material_data_._m91]), _538.xy, _536.xy, _536.zw).xyzw;
	        vec4 _4147 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_g_rtx_material_data_._m60], g_bindless_Sampler[_g_rtx_material_data_._m91]), _538.xy, _536.xy, _536.zw);
	        vec3 _4148 = _4147.xyz;
	        _533 = _4147.z;
	        float _4150 = _4148.x;
	        float _4151 = _4148.y;
	        float _4153 = (_4150 + _4151) - 1.00392162799835205078125;
	        float _4154 = _4150 - _4151;
	        vec3 _4161 = normalize(vec3(vec2(_4153, _4154), (1.0 - abs(_4153)) - abs(_4154)));
	        vec3 _4163 = _4148;
	        _4163.x = _4161.x;
	        _4163.y = _4161.y;
	        _4163.z = _4161.z;
	        vec2 _4169 = _4163.xy * 1.0;
	        vec3 _4171 = _4163;
	        _4171.x = _4169.x;
	        _4171.y = _4169.y;
	        _540 = _4171;
	    }
	    if (!(_g_rtx_material_data_._m37 == 0))
	    {
	        vec3 _4325 = _540;
	        vec3 _4332 = _4325;
	        _4332.x = dot(_4325.xy, _g_rtx_material_data_._m47.xy);
	        _4332.y = dot(_4325.xy, _g_rtx_material_data_._m47.zw);
	        _540 = _4332;
	        vec3 _575;
	        vec3 _576;
	        if (_g_rtx_material_data_._m37 > 1)
	        {
	            _576 = _552;
	            _575 = _551;
	        }
	        else
	        {
	            _576 = _487;
	            _575 = _486;
	        }
	        vec3 _4340 = abs(_540.xyz);
	        vec2 _4353 = (-vec2(_540.x, (-1.0) * _540.y)) / vec2(max(_4340.z, 0.0078125 * max(_4340.x, _4340.y)));
	        _539 = normalize(_580 - ((_576 * _4353.x) + (_575 * _4353.y)));
	    }
	    _533 = saturate(_533);
	    vec4 _589;
	    if (false)
	    {
	        _589 = vec4((vec4(_541.xyz, 1.0) * _g_rtx_material_data_._m65).xyz, _541.w);
	    }
	    else
	    {
	        _589 = _541;
	    }
	    vec4 _4385 = _589;
	    _4385.w = clamp(mix(0.0, 1.0, pow(_4385.w, 1.0)), 0.0, 1.0);
	    float _4392 = _534;
	    float _4393 = saturate(_4392);
	    _534 = _4393;
	    vec3 _4397 = mix(_4385.xyz, vec4((vec4(_541.xyz, 1.0) * _g_rtx_material_data_._m64).xyz, _467).xyz, vec3(_4393));
	    vec4 _4399 = _4385;
	    _4399.x = _4397.x;
	    _4399.y = _4397.y;
	    _4399.z = _4397.z;
	    float _4408 = dot(_4399.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125));
	    vec3 _4411 = normalize(max(_493.xyz, vec3(0.001000000047497451305389404296875)));
	    vec4 _4430 = vec4(clamp(mix(_4399.xyz, (_4411 * min(_4408 / dot(_4411.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125)), (3.0 * _4408) * max(_493.x, max(_493.y, _493.z)))).xyz, vec3(_493.w * _4393)), vec3(0.0), vec3(1.0)).xyz, _4399.w);
	    _541 = _4430;
	    vec2 _4435 = _559;
	    _4435.x = _533;
	    _559 = _4435;
	    _21._m5 = int(uint(gl_InstanceID));
	    _21._m3 = gl_RayTmaxEXT;
	    _21._m1 = _554;
	    _21._m2 = _555;
	    vec3 _581[3] = vec3[](_481, _476, _472);
	    vec3 _582[3] = vec3[](_482, _477, _473);
	    vec3 _4468 = ((_482 * ((1.0 - _22.barycentrics.x) - _22.barycentrics.y)) + (_477 * _22.barycentrics.x)) + (_473 * _22.barycentrics.y);
	    vec3 _583[3];
	    _583[0] = _4468 - (_481 * dot(_4468 - _482, _481));
	    _583[1] = _4468 - (_476 * dot(_4468 - _477, _476));
	    _583[2] = _4468 - (_472 * dot(_4468 - _473, _472));
	    vec3 _4496 = ((_583[0] * ((1.0 - _22.barycentrics.x) - _22.barycentrics.y)) + (_583[1] * _22.barycentrics.x)) + (_583[2] * _22.barycentrics.y);
	    vec3 _584[3];
	    _584[0] = cross(_482 - _477, _21._m1);
	    _584[1] = cross(_477 - _473, _21._m1);
	    _584[2] = cross(_473 - _482, _21._m1);
	    float _585 = dot(_4496 - _4468, _21._m1);
	    vec3 _586 = _4496;
	    int _587 = 0;
	    for (;;)
	    {
	        bool _4512_ladder_break = false;
	        do
	        {
	            if (!(_587 < 3))
	            {
	                _4512_ladder_break = true;
	                break;
	            }
	            if (_585 > 0.00999999977648258209228515625)
	            {
	                _4512_ladder_break = true;
	                break;
	            }
	            if (dot(_584[_587], _584[_587]) == 0.0)
	            {
	                break;
	            }
	            _584[_587] = normalize(_584[_587]);
	            int _588 = 0;
	            for (;;)
	            {
	                if (!(_588 < 3))
	                {
	                    break;
	                }
	                vec3 _4550 = _581[_588] - (_584[_587] * dot(_584[_587], _581[_588]));
	                _583[_588] = _4468 - (_4550 * dot(_4468 - _582[_588], _4550));
	                _588++;
	                continue;
	            }
	            vec3 _4574 = ((_583[0] * ((1.0 - _22.barycentrics.x) - _22.barycentrics.y)) + (_583[1] * _22.barycentrics.x)) + (_583[2] * _22.barycentrics.y);
	            _585 = dot(_4574 - _4468, _21._m1);
	            _586 = _4574;
	            break;
	        } while(false);
	        if (_4512_ladder_break)
	        {
	            break;
	        }
	        _587++;
	        continue;
	    }
	    if (!(_585 > 0.00999999977648258209228515625))
	    {
	        _586 = vec3(3.4028234663852885981170418348452e+38);
	    }
	    _21.material = _586;
	    _21._m6 = _553;
	    f16vec3 _4587 = f16vec3(vec3(0.0));
	    _21._m7 = MaterialDataMinimal_t(_4587, float16_t(0.0), f16vec3(vec3(1.0, 0.0, 1.0)), float16_t(1.0), _4587, float16_t(0.040008544921875), 0u, f16vec4(ivec4(0)));
	    _21._m7.vMaterialBits = f16vec3(_539.xyz);
	    _21._m7._m2 = f16vec3(_4430.xyz);
	    _21._m7._m4 = f16vec3(_558);
	    _21._m7._m5 = float16_t(_557);
	    _21._m7._m1 = float16_t(_535);
	    _21._m7._m3 = float16_t(dot(_4435, vec2(0.5)));
	    if (any(greaterThan(_556, vec3(0.0))))
	    {
	        f16vec4 _4616 = _21._m7._m7;
	        f16vec3 _4619 = f16vec3(_556);
	        _4616.x = _4619.x;
	        _4616.y = _4619.y;
	        _4616.z = _4619.z;
	        _21._m7 = MaterialDataMinimal_t(_21._m7.vMaterialBits, _21._m7._m1, _21._m7._m2, _21._m7._m3, _21._m7._m4, _21._m7._m5, (_21._m7._m6 & 4294901760u) | 1u, _4616);
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
