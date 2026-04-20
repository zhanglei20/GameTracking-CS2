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
	
	cbuffer BakedLightingConstantBuffer_t < Attribute("BakedLightingConstantBuffer_t"); >;
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
	bool g_bMaskVertexColor1 < UiType(CheckBox); Expression(g_nVertexColorMode1==0); >;
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
	float g_flAlphaTestReference1 < Default(0.5); Range(0.01, 0.99); UiType(Slider); UiGroup("Material1/Translucent,15/10"); >;
	float3 g_vTextureColorTint1 < Default3(1, 1, 1); UiType(Color); UiGroup("Material1/Color Correction,17/10"); >;
	float g_fTextureRoughnessContrast1 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material1/Lighting/11"); >;
	float g_fTextureRoughnessBrightness1 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material1/Lighting/12"); >;
	float g_fTextureNormalContrast1 < Default(1); Range(-2, 2); UiType(Slider); UiGroup("Material1/Lighting/13"); >;
	float g_flTexCoordRotation1 < Range(-360, 360); UiType(Slider); UiGroup("Material1/Texture Transform,35/13"); UiVisibility(1); >;
	float g_flAntiAliasedEdgeStrength1 < Default(1); UiType(Slider); UiGroup("Material1/Translucent,15/15"); >;
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
	int g_nVertexColorMode1 < Range4(0, 0, 0, 0, 2, 2, 2, 2); UiOptions("0=Masked,1=Unmasked,2=Disabled"); UiType(Enum); UiGroup("Material1/Color Correction/60"); >;
	float g_flWetnessDarkeningStrength1 < Default(1); UiType(Slider); UiGroup("Material1/Lighting/61"); >;
	bool g_bSnowLayer1 < UiType(CheckBox); UiGroup("Material1/Snow,100"); >;
	
	// Fog
	bool g_bFogEnabled < Default(1); UiType(CheckBox); UiGroup("Fog"); >;
	
	// Wetness
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
	// SPIR-V source (64580 bytes), GLSL reflection with SPIRV-Cross by KhronosGroup
	
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
	
	const vec3 _853[3] = vec3[](vec3(-1.0, 0.0, 0.0), vec3(0.0, 1.0, 0.0), vec3(0.0, 0.0, -1.0));
	
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
	
	struct _1324
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
	};
	
	vec3 _4;
	vec3 _5;
	vec4 _6;
	float _7;
	
	struct _1808
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
	
	layout(set = 1) uniform _1808 _Globals_;
	
	struct _257
	{
	    ivec4 _m0;
	    ivec4 _m1;
	    ivec4 _m2;
	    uint _m3;
	    uint _m4;
	    uint _m5;
	    uint _m6;
	    uint _m7;
	    uint _m8;
	    float _m9;
	    float _m10;
	    float _m11;
	    float _m12;
	    float _m13;
	    anon_g_mTextureColorAdjust1 _m14;
	    vec2 _m15;
	    float _m16;
	    vec4 _m17;
	    vec4 _m18;
	    vec4 _m19;
	    vec4 _m20;
	    vec4 _m21;
	    vec4 _m22;
	    anon_g_mTextureColorAdjust1 _m23;
	    vec4 _m24;
	    vec4 _m25;
	    vec4 _m26;
	};
	
	layout(set = 1) uniform _257 PerViewConstantBufferCsgo_t;
	
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
	    _1324 _m0[];
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
	    vec3 _10061 = input_2 + PerViewConstantBufferCsgo_t._m26.xyz;
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
	    float _22035 = (input_7.w > 0.0) ? 1.0 : (-1.0);
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
	        _11711 = _4;
	        _10247 = _4;
	    }
	    bool _8452 = _Globals_.g_nUVSet1 == 0;
	    vec2 _8037;
	    float _13136;
	    float _15670;
	    float _16305;
	    float _17114;
	    vec3 _17115;
	    vec4 _17116;
	    if (_8452)
	    {
	        _13136 = 0.0;
	        _16305 = 0.0;
	        _17114 = 0.0;
	        _17115 = vec3(0.0);
	        _17116 = vec4(0.0);
	        _15670 = 0.0;
	        _8037 = _Globals_.g_vTexCoordScale1.xy;
	    }
	    else
	    {
	        vec3 _23135;
	        _23135.x = input_4.x;
	        _23135.y = input_4.y;
	        vec4 _19372 = texture(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tHeight1], undetermined[_Globals_.g_sUserConfig]), _23135.xy);
	        vec4 _19373 = texture(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tNormal1], undetermined[_Globals_.g_sUserConfig]), _23135.xy);
	        float _16000 = _19373.x;
	        float _19720 = _19373.y;
	        float _16783 = (_16000 + _19720) - 1.00392162799835205078125;
	        float _11176 = _16000 - _19720;
	        vec3 _14896 = normalize(vec3(vec2(_16783, _11176), (1.0 - abs(_16783)) - abs(_11176)));
	        vec2 _21659 = _14896.xy;
	        float _25264 = dot(_21659, _Globals_.g_vNormalXform_1.xy);
	        float _19701 = dot(_21659, _Globals_.g_vNormalXform_1.zw);
	        vec3 _19601 = _14896;
	        _19601.x = _25264;
	        _19601.y = _19701;
	        bvec3 _20911 = bvec3(_7312);
	        vec3 _10844 = abs(_19601.xyz);
	        vec2 _16475 = (-vec2(_25264, (-1.0) * _19701)) / vec2(max(_10844.z, 0.0078125 * max(_10844.x, _10844.y)));
	        _13136 = _19372.w;
	        _16305 = _19373.z;
	        _17114 = _19372.x;
	        _17115 = normalize(_8889 - ((mix(input_7.xyz * _12157, _11711, _20911) * _16475.x) + (mix((cross(input_3, input_7.xyz) * _22035) * _12157, _10247, _20911) * _16475.y)));
	        _17116 = texture(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tColor1], undetermined[_Globals_.g_sUserConfig]), _23135.xy).xyzw;
	        _15670 = _19372.y;
	        _8037 = vec2(0.0);
	    }
	    vec4 _12727;
	    float _13138;
	    float _16307;
	    float _17119;
	    vec3 _17120;
	    float _18508;
	    if (_8452 ? true : false)
	    {
	        vec3 _22922 = abs(_24347.xyz);
	        vec3 _16100 = _22922;
	        vec3 _12669 = (cross(input_3.xyz, input_7.xyz) * _22035).xyz;
	        float _6476 = _22922.x;
	        float _12068 = _22922.y;
	        bool _12887;
	        if (_6476 > _12068)
	        {
	            _12887 = _6476 > _22922.z;
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
	            _23727 = mix(ivec3(2, 0, 1), ivec3(1, 2, 0), bvec3(_12068 > _22922.z));
	        }
	        bool _12888;
	        if (_6476 < _12068)
	        {
	            _12888 = _6476 < _22922.z;
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
	            _11775 = mix(ivec3(2, 0, 1), ivec3(1, 2, 0), bvec3(_12068 < _22922.z));
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
	        vec2 _19317 = _19651 / vec2(_19651.x + _19651.y);
	        vec3 _18781 = _10061 * _Globals_.g_vBiplanarTexCoordScale.xyz;
	        vec3 _16414 = _18781;
	        vec3 _16415 = dFdxFine(_18781);
	        vec3 _16446 = dFdyFine(_18781);
	        float _13137;
	        float _16306;
	        float _16479;
	        float _17117;
	        vec3 _17118;
	        vec4 _17190;
	        if (_8452)
	        {
	            vec2 _8312 = (vec2(_16414[_19321.x], _16414[_19321.y]) * _8037).xy;
	            vec2 _7410 = (vec2(_16415[_19321.x], _16415[_19321.y]) * _8037).xy;
	            vec2 _8901 = (vec2(_16446[_19321.x], _16446[_19321.y]) * _8037).xy;
	            float _23319 = _19317.x;
	            vec2 _16083 = (vec2(_16414[_19322.x], _16414[_19322.y]) * _8037).xy;
	            vec2 _14626 = (vec2(_16415[_19322.x], _16415[_19322.y]) * _8037).xy;
	            vec2 _8902 = (vec2(_16446[_19322.x], _16446[_19322.y]) * _8037).xy;
	            float _24269 = _19317.y;
	            vec4 _9696 = (textureGrad(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tHeight1], undetermined[_Globals_.g_sUserConfig]), _8312, _7410, _8901) * _23319) + (textureGrad(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tHeight1], undetermined[_Globals_.g_sUserConfig]), _16083, _14626, _8902) * _24269);
	            vec4 _12167 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tNormal1], undetermined[_Globals_.g_sUserConfig]), _8312, _7410, _8901);
	            float _15456 = _12167.x;
	            float _24534 = _12167.y;
	            float _16784 = (_15456 + _24534) - 1.00392162799835205078125;
	            float _11177 = _15456 - _24534;
	            vec3 _21631 = normalize(vec3(vec2(_16784, _11177), (1.0 - abs(_16784)) - abs(_11177))).xyz * _23319;
	            vec3 _22193 = _21631;
	            _22193.x = _21631.x * ((int(sign(dot(input_7.xyz, _853[_19321.x]))) < 0) ? (-1.0) : 1.0);
	            _22193.y = _21631.y * ((int(sign(dot(_12669, _853[_19321.y]))) < 0) ? (-1.0) : 1.0);
	            vec4 _12168 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tNormal1], undetermined[_Globals_.g_sUserConfig]), _16083, _14626, _8902);
	            float _13491 = _12168.x;
	            float _21308 = _12168.y;
	            float _16785 = (_13491 + _21308) - 1.00392162799835205078125;
	            float _11178 = _13491 - _21308;
	            vec3 _21632 = normalize(vec3(vec2(_16785, _11178), (1.0 - abs(_16785)) - abs(_11178))).xyz * _24269;
	            vec4 _17025;
	            _17025.z = _21632.z;
	            _17025.x = _21632.x * ((int(sign(dot(input_7.xyz, _853[_19322.x]))) < 0) ? (-1.0) : 1.0);
	            _17025.y = _21632.y * ((int(sign(dot(_12669, _853[_19322.y]))) < 0) ? (-1.0) : 1.0);
	            vec3 _15733 = _22193.xyz + _17025.xyz;
	            vec3 _13114 = _15733.xyz;
	            bool _12889;
	            if (_14874)
	            {
	                _12889 = !(_Globals_.g_bDontFlipBackfaceNormals != 0);
	            }
	            else
	            {
	                _12889 = false;
	            }
	            bool _24327;
	            if (_12889)
	            {
	                _24327 = (gl_FrontFacing ? 1.0 : (-1.0)) < 0.0;
	            }
	            else
	            {
	                _24327 = false;
	            }
	            vec3 _9739 = input_3.xyz * (_24327 ? (-1.0) : 1.0);
	            vec3 _14435 = cross(_9739.xyz, input_7.xyz) * _22035;
	            vec3 _7424;
	            if (notEqual(PerViewConstantBufferCsgo_t._m2, ivec4(0)).w)
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
	                vec3 _16556 = _13114;
	                _16556.y = -_15733.y;
	                _20480 = _16556;
	            }
	            else
	            {
	                _20480 = _13114;
	            }
	            _13137 = _9696.w;
	            _16306 = (_12167.z * _23319) + (_12168.z * _24269);
	            _17117 = _9696.x;
	            _17118 = normalize((((input_7.xyz * _20480.x).xyz + (_7424.xyz * _20480.y)).xyz + (_9739.xyz * _20480.z)).xyz);
	            _17190 = (textureGrad(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tColor1], undetermined[_Globals_.g_sUserConfig]), _8312, _7410, _8901) * _23319) + (textureGrad(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tColor1], undetermined[_Globals_.g_sUserConfig]), _16083, _14626, _8902) * _24269);
	            _16479 = _9696.y;
	        }
	        else
	        {
	            _13137 = _13136;
	            _16306 = _16305;
	            _17117 = _17114;
	            _17118 = _17115;
	            _17190 = _17116;
	            _16479 = _15670;
	        }
	        _13138 = _13137;
	        _16307 = _16306;
	        _17119 = _17117;
	        _17120 = _17118;
	        _12727 = _17190;
	        _18508 = _16479;
	    }
	    else
	    {
	        _13138 = _13136;
	        _16307 = _16305;
	        _17119 = _17114;
	        _17120 = _17115;
	        _12727 = _17116;
	        _18508 = _15670;
	    }
	    vec4 _22750 = mix(_12727, vec4((vec4(_12727.xyz, 1.0) * mat4(vec4(_Globals_.g_mTextureColorAdjust1._m0[0].x, _Globals_.g_mTextureColorAdjust1._m0[1].x, _Globals_.g_mTextureColorAdjust1._m0[2].x, _Globals_.g_mTextureColorAdjust1._m0[3].x), vec4(_Globals_.g_mTextureColorAdjust1._m0[0].y, _Globals_.g_mTextureColorAdjust1._m0[1].y, _Globals_.g_mTextureColorAdjust1._m0[2].y, _Globals_.g_mTextureColorAdjust1._m0[3].y), vec4(_Globals_.g_mTextureColorAdjust1._m0[0].z, _Globals_.g_mTextureColorAdjust1._m0[1].z, _Globals_.g_mTextureColorAdjust1._m0[2].z, _Globals_.g_mTextureColorAdjust1._m0[3].z), vec4(_Globals_.g_mTextureColorAdjust1._m0[0].w, _Globals_.g_mTextureColorAdjust1._m0[1].w, _Globals_.g_mTextureColorAdjust1._m0[2].w, _Globals_.g_mTextureColorAdjust1._m0[3].w))).xyz, _12727.w), vec4(_18508));
	    float _21562 = _22750.w;
	    float _24323 = dot(_22750.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125));
	    vec3 _9577 = normalize(max(input_0.xyz, vec3(0.001000000047497451305389404296875)));
	    vec3 _14119 = vec4(clamp(mix(_22750.xyz, (_9577 * min(_24323 / dot(_9577.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125)), (3.0 * _24323) * max(input_0.x, max(input_0.y, input_0.z)))).xyz, vec3(input_0.w * _18508)), vec3(0.0), vec3(1.0)).xyz, _7).xyz * mix(vec3(1.0), input_5.xyz, vec3(clamp(max(0.0, _18508), 0.0, 1.0)));
	    vec4 _23714;
	    _23714.x = _14119.x;
	    _23714.y = _14119.y;
	    _23714.z = _14119.z;
	    vec2 _13496 = vec2(_16307);
	    float _23793 = float(_Globals_.g_bSnowLayer1 != 0);
	    bool _12890;
	    if (_Globals_.g_bWetness != 0)
	    {
	        _12890 = (_Globals_.g_fPuddleStrength + _Globals_.g_fWetnessStrength) > 0.0;
	    }
	    else
	    {
	        _12890 = false;
	    }
	    vec2 _13141;
	    vec3 _13998;
	    float _16308;
	    vec3 _17121;
	    float _17123;
	    float _17124;
	    vec3 _23318;
	    if (_12890)
	    {
	        vec4 _19374 = texture(sampler2D(g_bindless_Texture2D_float4[PerViewConstantBufferCsgo_t._m8], undetermined[_Globals_.g_sUserConfig]), (_10061.xy * 0.006000000052154064178466796875).xy);
	        float _21302 = _24347.z;
	        float _14498 = pow(max(0.0, _21302), 32.0);
	        float _23204 = min(min(input_1.z, saturate(PerViewConstantBufferCsgo_t._m12)), 1.0 - (saturate(PerViewConstantBufferCsgo_t._m13 - 0.5) * 2.0));
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
	        float _14611 = smoothstep(_24878 + _15811, _24878 - (input_1.w + (_15811 * 2.0)), _17119) * _11964;
	        float _19808 = max((smoothstep(_23204, _16777 - (0.20000000298023223876953125 * _8284), _17119) * _Globals_.g_fWetEdgeStrength) * _11964, _14611) * _Globals_.g_fPuddleStrength;
	        float _17924 = (_23204 - 1.0) - _17119;
	        float _10334 = (saturate(_17924 + _Globals_.g_fPuddleSedimentHeight) * _Globals_.g_fPuddleSedimentOpacity) * _14611;
	        float _13706 = clamp(((clamp((((_8284 * 2.0) - (mix(0.5, _19374.w, saturate(_14498 * 20.0)) * 0.5)) - (_17119 * 0.5)) + 0.25, 0.0, 1.0) * _Globals_.g_fWetnessStrength) * _11964) + _14611, 0.0, 1.0);
	        float _13140;
	        float _13151;
	        vec4 _23607;
	        if (_13706 > 0.5)
	        {
	            float _12497 = _Globals_.g_fRippleStrength * PerViewConstantBufferCsgo_t._m10;
	            vec3 _6616;
	            vec4 _12891;
	            float _13139;
	            if (_12497 > 0.0)
	            {
	                vec3 _18756 = normalize(vec3(-1.0, 0.20000000298023223876953125, 0.0));
	                float _9925 = PerViewConstantBufferCsgo_t._m11 * 6.283185482025146484375;
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
	                vec4 _15054 = texture(sampler2D(g_bindless_Texture2D_float4[PerViewConstantBufferCsgo_t._m8], undetermined[_Globals_.g_sUserConfig]), (_15991 + (vec2(0.20000000298023223876953125, 0.0) * PerViewConstantBuffer_t._m0)).xy);
	                float _18070 = clamp(length(fwidth(_15991)) * 10.0, 0.0, 1.0);
	                vec2 _18922 = (_15054.xy * 2.0) - vec2(1.0);
	                vec2 _10456 = ((_18922 * vec2(0.100000001490116119384765625, 0.0500000007450580596923828125)) * input_1.z) * mix(1.0, 0.300000011920928955078125, _18070);
	                vec2 _13711 = _21326.xy;
	                vec4 _19602 = vec4(0.0);
	                _19602.x = dot(_22900.xy, _10456);
	                _19602.y = dot(_13711, _10456);
	                vec2 _16049 = (vec2(_20274.y, _9965) * vec2(0.03599999845027923583984375, 0.01620000042021274566650390625)) + (_18922 * 0.0500000007450580596923828125);
	                vec4 _15055 = texture(sampler2D(g_bindless_Texture2D_float4[PerViewConstantBufferCsgo_t._m8], undetermined[_Globals_.g_sUserConfig]), (_16049 + (vec2(0.1500000059604644775390625, 0.0) * PerViewConstantBuffer_t._m0)).xy);
	                float _9250 = clamp(length(fwidth(_16049)) * 10.0, 0.0, 1.0);
	                vec2 _9825 = ((((_15055.xy * 2.0) - vec2(1.0)) * 0.05200000107288360595703125) * input_1.z) * mix(1.0, 0.300000011920928955078125, _9250);
	                _9825.y = _9825.y * 0.5;
	                vec2 _13330 = _19602.xy + vec2(dot(_22900.xy, _9825), dot(_13711, _9825));
	                vec4 _20488 = _19602;
	                _20488.x = _13330.x;
	                _20488.y = _13330.y;
	                _20488.w = input_1.z * (_15054.z + _15055.z);
	                vec3 _20489;
	                _20489.x = _10061.x;
	                _20489.y = _10061.y;
	                _13139 = _12497 * (0.039999999105930328369140625 * (_18070 + _9250));
	                _12891 = _9716 + ((_20488 * _14498) * _12497);
	                _6616 = _20489;
	            }
	            else
	            {
	                _13139 = 0.0;
	                _12891 = _9716;
	                _6616 = _10061;
	            }
	            float _8914 = (_Globals_.g_fRainStrength * PerViewConstantBufferCsgo_t._m9) * PerViewConstantBufferCsgo_t._m9;
	            float _9982;
	            vec4 _21594;
	            if (_8914 > 0.0)
	            {
	                vec2 _10473 = _6616.xy * 0.119999997317790985107421875;
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
	                    float _20213 = clamp(1.0 - (_8329 * 6.0), 0.0, 1.0);
	                    float _7135 = floor(fract(_10212.x * 0.100000001490116119384765625) * 10.0);
	                    float _23598 = _20506[_16208];
	                    float _18429 = _23598 + ((_7135 + (floor(fract(_10212.y * 0.100000001490116119384765625) * 10.0) * (0.20000000298023223876953125 + _7135))) * 8.0);
	                    _20506[_16208] = _18429;
	                    float _18120 = _8914 * _8914;
	                    _25251 = vec3(_13155.xy + (((-(((((_7848 / vec2(_8329)) * cos(mix(1.0, (_20173 * 40.0) + (PerViewConstantBuffer_t._m0 * 65.0), _14611))) * _20173) * _20173) * mix(2.0, 0.25, clamp(fwidth(_20173) * 20.0, 0.0, 1.0)))) * ((clamp((sin(((_20173 * mix(1.0, 4.0, _14611)) + _18429) * _8914) - (1.0 - ((0.20000000298023223876953125 * _18120) * mix(0.25, 1.0, _14611)))) * 2.0, 0.0, 1.0) * _20173) / _18120)) * mix(16.0, 2.0, _14611)), _13155.z + (((clamp((sin((((_20213 + _18429) + 4.0) + (sin(_17119 * 60.0) * 0.25)) * _8914) - (1.0 - (_18120 * 0.02000000141561031341552734375))) * 2.0, 0.0, 1.0) * _20213) / _18120) * 28.0));
	                    _18440 = _16208 + 1;
	                    _13155 = _25251;
	                    _16208 = _18440;
	                    continue;
	                }
	                vec3 _9348 = _13155 * _14498;
	                vec2 _15752 = _12891.xy + _9348.xy;
	                vec4 _20490 = _12891;
	                _20490.x = _15752.x;
	                _20490.y = _15752.y;
	                _9982 = _9348.z;
	                _21594 = _20490;
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
	            _23607 = _9716;
	        }
	        float _10839 = _14611 * _Globals_.g_fPuddleStrength;
	        vec3 _13712 = normalize(mix(_17120.xyz, _23607.xyz, vec3(saturate(_10839 * 4.0))));
	        float _9038 = max(_13706 * (1.0 - saturate(PerViewConstantBufferCsgo_t._m13 * 2.0)), _19808);
	        vec3 _18806 = mix(_23714.xyz, pow(_23714.xyz, vec3(1.2999999523162841796875)) * 0.800000011920928955078125, clamp((pow(_23714.xyz, vec3(0.25)) * (_9038 * _16307)) * 8.0, vec3(0.0), vec3(1.0)) * _Globals_.g_flWetnessDarkeningStrength1);
	        _13141 = clamp(mix(_13496.xx, vec2(_Globals_.g_fPuddleRoughness), vec2(_9038)) + vec2(_13151 + (length(fwidth(_13712.xyz)) * 0.5)), vec2(0.0), vec2(1.0));
	        _16308 = mix(_Globals_.g_flReflectance, 0.0350000001490116119384765625, _9038);
	        _17121 = _13712;
	        _17123 = _10839 * (0.20000000298023223876953125 + (((0.1500000059604644775390625 * _23607.w) * _23607.w) * _23607.w));
	        _17124 = mix(_21562, 1.0, _19808);
	        _13998 = mix(_17120, _23607.xyz, vec3(_19808 * _10334));
	        _23318 = fma(mix((mix(_18806, _18806 * 0.5, vec3(saturate(_14611 * 1.5))) * mix(1.0, _21562, _19808)) * mix(1.0, 1.0 - _17924, _10334), _Globals_.g_vPuddleSedimentColor, vec3(_10334 * _19808)), vec3(1.0 + _13140), vec3(_13140 * 0.100000001490116119384765625));
	    }
	    else
	    {
	        _13141 = _13496;
	        _16308 = _Globals_.g_flReflectance;
	        _17121 = vec3(1.0);
	        _17123 = 0.0;
	        _17124 = _21562;
	        _13998 = _17120;
	        _23318 = _23714.xyz;
	    }
	    vec4 _23944;
	    _23944.x = _23318.x;
	    _23944.y = _23318.y;
	    _23944.z = _23318.z;
	    vec3 _9454 = mix(vec3(_16308).xyz, _23944.xyz, vec3(_13138));
	    vec3 _17892 = mix(_17121, _13998, bvec3(all(equal(_17121, vec3(1.0)))));
	    vec3 _10560 = _24347.xyz;
	    vec3 _11099 = dFdx(_10560);
	    vec3 _9175 = dFdy(_10560);
	    vec3 _10347 = _11099.xyz;
	    vec3 _12420 = _9175.xyz;
	    vec2 _13392 = max(_13141.xy, vec2(pow(clamp(max(dot(_10347, _10347), dot(_12420, _12420)), 0.0, 1.0), 0.333000004291534423828125)));
	    bvec4 _24465 = notEqual(PerViewConstantBufferCsgo_t._m0, ivec4(0));
	    float _21785;
	    if (_24465.x)
	    {
	        vec3 _11394 = _24347.xyz;
	        vec2 _11086 = ((floor(_11408.xy * PerViewConstantBufferCsgo_t._m16) * PerViewConstantBufferCsgo_t._m15.xy) + (PerViewConstantBufferCsgo_t._m15.xy * 0.5)).xy;
	        vec4 _18418 = textureGather(sampler2D(g_bindless_Texture2D_float4[PerViewConstantBufferCsgo_t._m5], undetermined[_Globals_.g_sCookieSampler]), _11086).xyzw - _11408.zzzz;
	        float _18579 = _18418.w;
	        float _12013 = _18418.z;
	        bool _12285 = abs(_12013) < _18579;
	        vec2 _23168;
	        if (_12285)
	        {
	            _23168 = vec2(PerViewConstantBufferCsgo_t._m15.x, 0.0);
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
	            _23169 = vec2(0.0, PerViewConstantBufferCsgo_t._m15.y);
	        }
	        else
	        {
	            _23169 = _23168;
	        }
	        vec4 _17422 = (max(vec4(dot(PerViewLightingConstantBufferGpu_t._m1._m0[0].xyz, _11394), dot(PerViewLightingConstantBufferGpu_t._m1._m0[1].xyz, _11394), dot(PerViewLightingConstantBufferGpu_t._m1._m0[2].xyz, _11394), dot(PerViewLightingConstantBufferGpu_t._m1._m0[3].xyz, _11394)).xyzw, vec4(0.0)).xyzw * PerViewLightingConstantBufferGpu_t._m2.xyzw).xyzw;
	        _21785 = (1.0 / (dot(_17422, vec4(1.0)) + PerViewLightingConstantBufferGpu_t._m3.x)) * (PerViewLightingConstantBufferGpu_t._m3.x + dot(_17422, textureLod(sampler2D(g_bindless_Texture2D_float4[PerViewConstantBufferCsgo_t._m4], undetermined[_Globals_.g_sPointClamp]), (_11086 + mix(_23169, PerViewConstantBufferCsgo_t._m15.xy, bvec2(abs(_18418.y) < (_12287 ? _15372 : _20965))).xy).xy, 0.0).xyzw));
	    }
	    else
	    {
	        _21785 = 1.0;
	    }
	    vec4 _23875 = vec4(_13998.xyz, 1.0);
	    float _21710;
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
	                vec2 _22195 = vec2(1.0) - clamp((abs(_24804) * vec2(PerViewLightingConstantBufferGpu_t._m15)) + vec2(PerViewLightingConstantBufferGpu_t._m14), vec2(0.0), vec2(1.0));
	                vec2 _20561 = (_24804 * PerViewLightingConstantBufferGpu_t._m19._m0[_13039].zw) + PerViewLightingConstantBufferGpu_t._m19._m0[_13039].xy;
	                vec3 _20491 = _19470;
	                _20491.x = _20561.x;
	                _20491.y = _20561.y;
	                _13142 = saturate(_22195.x * _22195.y);
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
	            if (_13142 < 1.0)
	            {
	                float _7934;
	                if (_10191 < (PerViewLightingConstantBufferGpu_t._m11 - 1))
	                {
	                    int _15336 = _10191 + 1;
	                    vec4 _19671 = vec4(input_2.xyz, 1.0) * mat4(vec4(PerViewLightingConstantBufferGpu_t._m18._m0[_15336]._m0[0].x, PerViewLightingConstantBufferGpu_t._m18._m0[_15336]._m0[1].x, PerViewLightingConstantBufferGpu_t._m18._m0[_15336]._m0[2].x, PerViewLightingConstantBufferGpu_t._m18._m0[_15336]._m0[3].x), vec4(PerViewLightingConstantBufferGpu_t._m18._m0[_15336]._m0[0].y, PerViewLightingConstantBufferGpu_t._m18._m0[_15336]._m0[1].y, PerViewLightingConstantBufferGpu_t._m18._m0[_15336]._m0[2].y, PerViewLightingConstantBufferGpu_t._m18._m0[_15336]._m0[3].y), vec4(PerViewLightingConstantBufferGpu_t._m18._m0[_15336]._m0[0].z, PerViewLightingConstantBufferGpu_t._m18._m0[_15336]._m0[1].z, PerViewLightingConstantBufferGpu_t._m18._m0[_15336]._m0[2].z, PerViewLightingConstantBufferGpu_t._m18._m0[_15336]._m0[3].z), vec4(PerViewLightingConstantBufferGpu_t._m18._m0[_15336]._m0[0].w, PerViewLightingConstantBufferGpu_t._m18._m0[_15336]._m0[1].w, PerViewLightingConstantBufferGpu_t._m18._m0[_15336]._m0[2].w, PerViewLightingConstantBufferGpu_t._m18._m0[_15336]._m0[3].w));
	                    vec2 _20562 = (_19671.xy * PerViewLightingConstantBufferGpu_t._m19._m0[_15336].zw) + PerViewLightingConstantBufferGpu_t._m19._m0[_15336].xy;
	                    vec3 _20492;
	                    _20492.x = _20562.x;
	                    _20492.y = _20562.y;
	                    _7934 = textureLod(sampler2DShadow(g_bindless_Texture2D_float4[PerViewLightingConstantBufferGpu_t._m20], undetermined_1[_Globals_.g_tShadowDepthBufferCmpSampler]), vec3(_20492.xy, saturate(_19671.z + PerViewLightingConstantBufferGpu_t._m12)), 0.0);
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
	        float _13279 = mix(_18423, 1.0, clamp((distance(_10061.xyz, PerViewConstantBuffer_t._m4) * PerViewLightingConstantBufferGpu_t._m17) + PerViewLightingConstantBufferGpu_t._m16, 0.0, 1.0));
	        float _12502;
	        if (_24465.y)
	        {
	            _12502 = min(_13279, textureLod(sampler2D(g_bindless_Texture2D_float4[PerViewConstantBufferCsgo_t._m6], undetermined[_Globals_.g_sTrilinearClamp]), (_11408.xy * PerViewConstantBuffer_t._m3.xy).xy, 0.0).z);
	        }
	        else
	        {
	            _12502 = _13279;
	        }
	        _21710 = _12502;
	    }
	    else
	    {
	        _21710 = 1.0;
	    }
	    vec3 _9717;
	    vec3 _24879;
	    if ((dot(PerViewLightingConstantBufferGpu_t._m9.xyz, _13998.xyz) * _21710) > 0.0)
	    {
	        vec3 _15460 = mix(_17892, _13998.xyz, bvec3(all(equal(_17892, vec3(1.0)))));
	        float _13811 = max(0.0, dot(_13998.xyz, PerViewLightingConstantBufferGpu_t._m9.xyz));
	        vec3 _17874 = vec3(_13811);
	        vec3 _18223;
	        if (_17123 > 0.0)
	        {
	            float _8780 = dot(_15460, PerViewLightingConstantBufferGpu_t._m9.xyz);
	            float _8124 = saturate(_17123);
	            _18223 = mix(_17874.xyz, vec3((((0.5 + (_13811 * 0.5)) + pow(1.0 - saturate(_8780), 4.0)) * clamp((_8780 + 0.20000000298023223876953125) * 4.0, 0.0, 1.0)) * clamp(mix(dot(mix(_13998.xyz, _15460, vec3(10.0)), PerViewLightingConstantBufferGpu_t._m9.xyz), 1.0, _8124), 0.0, 1.0)), vec3(_8124));
	        }
	        else
	        {
	            _18223 = _17874;
	        }
	        vec2 _17301 = max(_13392, vec2(PerViewLightingConstantBufferGpu_t._m9.w));
	        vec3 _12282 = normalize(PerViewLightingConstantBufferGpu_t._m9.xyz + (-normalize(_10061.xyz - PerViewConstantBuffer_t._m4.xyz)).xyz).xyz;
	        float _12386 = dot(_12282, _15460.xyz);
	        float _19210 = max(0.0, dot(PerViewLightingConstantBufferGpu_t._m9.xyz, _12282));
	        float _9850 = _17301.x;
	        float _25211 = _9850 * _9850;
	        float _19095 = _25211 * _25211;
	        float _15346 = ((_12386 * _12386) * (_19095 - 1.0)) + 1.0;
	        vec3 _16808 = (PerViewLightingConstantBufferGpu_t._m10.xyz * _21710).xyz;
	        _9717 = ((_9454.xyz * (_19095 / (((_15346 * _15346) * (_19210 * _19210)) * ((_9850 * 4.0) + 2.0)))).xyz * _13811).xyz * _16808;
	        _24879 = PerViewLightingConstantBufferGpu_t._m4.xyz + (_18223.xyz * _16808);
	    }
	    else
	    {
	        _9717 = vec3(0.0);
	        _24879 = PerViewLightingConstantBufferGpu_t._m4.xyz;
	    }
	    bvec4 _24466 = notEqual(PerViewConstantBufferCsgo_t._m1, ivec4(0));
	    bool _20060 = _24466.x;
	    vec4 _19363;
	    if (_20060)
	    {
	        vec4 _24259 = vec4(_10061.xyz, 1.0).xyzw * mat4(vec4(PerViewConstantBufferCsgo_t._m14._m0[0].x, PerViewConstantBufferCsgo_t._m14._m0[1].x, PerViewConstantBufferCsgo_t._m14._m0[2].x, PerViewConstantBufferCsgo_t._m14._m0[3].x), vec4(PerViewConstantBufferCsgo_t._m14._m0[0].y, PerViewConstantBufferCsgo_t._m14._m0[1].y, PerViewConstantBufferCsgo_t._m14._m0[2].y, PerViewConstantBufferCsgo_t._m14._m0[3].y), vec4(PerViewConstantBufferCsgo_t._m14._m0[0].z, PerViewConstantBufferCsgo_t._m14._m0[1].z, PerViewConstantBufferCsgo_t._m14._m0[2].z, PerViewConstantBufferCsgo_t._m14._m0[3].z), vec4(PerViewConstantBufferCsgo_t._m14._m0[0].w, PerViewConstantBufferCsgo_t._m14._m0[1].w, PerViewConstantBufferCsgo_t._m14._m0[2].w, PerViewConstantBufferCsgo_t._m14._m0[3].w));
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
	    vec3 _13143;
	    vec3 _16324;
	    _13143 = _9717;
	    _16324 = _24879;
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
	        vec3 _15671;
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
	                float _21776 = _10521.z;
	                _22905.z = _21776;
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
	                bool _12892;
	                if (!_7425)
	                {
	                    _12892 = true;
	                }
	                else
	                {
	                    _12892 = !all(lessThanEqual(abs((mat4x3(vec3(g_BarnLights_1._m0[_12608]._m15._m0[0].x, g_BarnLights_1._m0[_12608]._m15._m0[1].x, g_BarnLights_1._m0[_12608]._m15._m0[2].x), vec3(g_BarnLights_1._m0[_12608]._m15._m0[0].y, g_BarnLights_1._m0[_12608]._m15._m0[1].y, g_BarnLights_1._m0[_12608]._m15._m0[2].y), vec3(g_BarnLights_1._m0[_12608]._m15._m0[0].z, g_BarnLights_1._m0[_12608]._m15._m0[1].z, g_BarnLights_1._m0[_12608]._m15._m0[2].z), vec3(g_BarnLights_1._m0[_12608]._m15._m0[0].w, g_BarnLights_1._m0[_12608]._m15._m0[1].w, g_BarnLights_1._m0[_12608]._m15._m0[2].w)) * vec4(input_2.xyz, 1.0)).xyz), vec3(1.0)));
	                }
	                if (_12892)
	                {
	                    _13212 = _13144;
	                    _15671 = _16325;
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
	                    _21316 = min(1.0, _21776 * g_BarnLights_1._m0[_12608]._m3.z);
	                }
	                else
	                {
	                    _21316 = 1.0;
	                }
	                float _19667;
	                if (g_BarnLights_1._m0[_12608]._m3.w > 0.0)
	                {
	                    _19667 = _21316 * min(1.0, (1.0 - _21776) * g_BarnLights_1._m0[_12608]._m3.w);
	                }
	                else
	                {
	                    _19667 = _21316;
	                }
	                vec3 _11179;
	                float _11633;
	                if (g_BarnLights_1._m0[_12608]._m2.w != 0.0)
	                {
	                    vec3 _10017 = g_BarnLights_1._m0[_12608]._m2.xyz - input_2.xyz;
	                    float _18345 = dot(_10017, _10017);
	                    float _17647 = sqrt(_18345);
	                    vec3 _12302 = _10017 - _16268;
	                    vec3 _10211;
	                    do
	                    {
	                        vec3 _20229 = (_10017 + _16268) - _12302;
	                        float _25105 = dot(-_12302, _20229);
	                        if (_25105 <= 0.0)
	                        {
	                            _10211 = _12302;
	                            break;
	                        }
	                        else
	                        {
	                            _10211 = _12302 + (_20229 * min(1.0, _25105 / dot(_20229, _20229)));
	                            break;
	                        }
	                        break; // unreachable workaround
	                    } while(false);
	                    _11179 = _10017 / vec3(_17647);
	                    _11633 = ((_19667 * (g_BarnLights_1._m0[_12608]._m2.w / max(_18345, g_BarnLights_1._m0[_12608]._m2.w))) * clamp(g_BarnLights_1._m0[_12608]._m3.x + (g_BarnLights_1._m0[_12608]._m3.y * _17647), 0.0, 1.0)) * clamp(g_BarnLights_1._m0[_12608]._m6.x + (g_BarnLights_1._m0[_12608]._m6.y * dot(vec3((1.0 - (_23572 * g_BarnLights_1._m0[_12608]._m5.y)) - _18492, _9058 + _19825, (_14805 * g_BarnLights_1._m0[_12608]._m5.z) - (_17330 * g_BarnLights_1._m0[_12608]._m5.y)), normalize(_10211))), 0.0, 1.0);
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
	                    _24419 = !_20060;
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
	                            float _15018 = _22154.y;
	                            float _23041 = (-0.5) * g_BarnLights_1._m0[_12608]._m9.z;
	                            float _11981 = (g_BarnLights_1._m0[_12608]._m9.x * g_BarnLights_1._m0[_12608]._m9.y) * pow(max(pow(g_BarnLights_1._m0[_12608]._m9.y * _11473, _15266) + pow(g_BarnLights_1._m0[_12608]._m9.x * _15018, _15266), 1.1754943508222875079687365372222e-38), _23041);
	                            float _16524 = pow(max(pow(_11473, _15266) + pow(_15018, _15266), 1.1754943508222875079687365372222e-38), _23041);
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
	                        vec3 _23629 = vec4((-_11179).xyz, 0.0).xyz;
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
	                    _13212 = _13144;
	                    _15671 = _16325;
	                    break;
	                }
	                vec3 _21549;
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
	                    vec3 _20482 = _21548.xyz * mix(1.0, textureLod(sampler2DShadow(g_bindless_Texture2D_float4[PerViewLightingConstantBufferGpu_t._m20], undetermined_1[_Globals_.g_tShadowDepthBufferCmpSampler]), vec3(vec3(fma(_19629.xy, g_BarnLights_1._m0[_12608]._m8.zw, g_BarnLights_1._m0[_12608]._m8.xy), _19629.z).xy, saturate(_19629.z + PerViewLightingConstantBufferGpu_t._m12)), 0.0), g_BarnLights_1._m0[_12608]._m12);
	                    if (all(equal(_20482.xyz, vec3(0.0))))
	                    {
	                        _13212 = _13144;
	                        _15671 = _16325;
	                        break;
	                    }
	                    _21549 = _20482;
	                }
	                else
	                {
	                    _21549 = _21548;
	                }
	                vec3 _15461 = mix(_17892, _13998.xyz, bvec3(all(equal(_17892, vec3(1.0)))));
	                float _13812 = max(0.0, dot(_13998.xyz, _11179.xyz));
	                vec3 _17875 = vec3(_13812);
	                vec3 _18225;
	                if (_17123 > 0.0)
	                {
	                    float _8781 = dot(_15461, _11179.xyz);
	                    float _8125 = saturate(_17123);
	                    _18225 = mix(_17875.xyz, vec3((((0.5 + (_13812 * 0.5)) + pow(1.0 - saturate(_8781), 4.0)) * clamp((_8781 + 0.20000000298023223876953125) * 4.0, 0.0, 1.0)) * clamp(mix(dot(mix(_13998.xyz, _15461, vec3(10.0)), _11179.xyz), 1.0, _8125), 0.0, 1.0)), vec3(_8125));
	                }
	                else
	                {
	                    _18225 = _17875;
	                }
	                vec2 _17302 = max(_13392, vec2(g_BarnLights_1._m0[_12608]._m11));
	                vec3 _12283 = normalize(_11179.xyz + (-normalize(_10061.xyz - PerViewConstantBuffer_t._m4.xyz)).xyz).xyz;
	                float _12387 = dot(_12283, _15461.xyz);
	                float _19211 = max(0.0, dot(_11179.xyz, _12283));
	                float _9851 = _17302.x;
	                float _25215 = _9851 * _9851;
	                float _19097 = _25215 * _25215;
	                float _15348 = ((_12387 * _12387) * (_19097 - 1.0)) + 1.0;
	                _13212 = _13144.xyz + (((_9454.xyz * (_19097 / (((_15348 * _15348) * (_19211 * _19211)) * ((_9851 * 4.0) + 2.0)))).xyz * _13812).xyz * _21549.xyz);
	                _15671 = _16325.xyz + (_18225.xyz * _21549.xyz);
	                break;
	            } while(false);
	            _13144 = _13212;
	            _16325 = _15671;
	            _17018 = _20344;
	            continue;
	        }
	        _21567 = _17017 + 1u;
	        _13143 = _13144;
	        _16324 = _16325;
	        _17017 = _21567;
	        continue;
	    }
	    float _17172 = dot(_13392.xy, vec2(0.5));
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
	    vec3 _19842 = _8745 * vec3(_21785 * _17124).xyz;
	    vec3 _13436 = vec3(_17124 * _21785).xyz;
	    vec3 _19630;
	    if (_23793 > 0.0)
	    {
	        _19630 = mix(_19842, pow(_19842, vec3(1.0499999523162841796875, 0.949999988079071044921875, 0.800000011920928955078125)), vec3(_23793));
	    }
	    else
	    {
	        _19630 = _19842;
	    }
	    vec3 _22686 = ((_16324.xyz * vec3(_21785)).xyz + _19630.xyz) * (_23944.xyz * (1.0 - _13138)).xyz;
	    float _12931 = _22686.x;
	    vec4 _11203 = vec4(_12931, _22686.yz, input_5.w);
	    _11203.x = _12931;
	    _11203.y = _22686.y;
	    _11203.z = _22686.z;
	    vec3 _15753 = _11203.xyz + (_13143.xyz * _13436).xyz;
	    vec4 _20496 = _11203;
	    _20496.x = _15753.x;
	    _20496.y = _15753.y;
	    _20496.z = _15753.z;
	    vec3 _15735 = _20496.xyz + ((((mix(_11427.xxx, _11427.yyy, _9454) * textureLod(samplerCubeArray(g_bindless_TextureCubeArray_float4[PerViewConstantBufferCsgo_t._m7], undetermined[_Globals_.g_sTrilinearClamp]), vec4(normalize(mix(_7507, reflect(_17138.xyz, _17892.xyz).xyz, vec3(_20711 * (sqrt(_20711) + _17225)))), 0.0), PerViewLightingConstantBufferGpu_t._m8.y * sqrt(_17172)).xyz).xyz * (normalize(_16991 + vec3(0.001000000047497451305389404296875)) * clamp(length(_16991), 0.0, 1.75))).xyz * (vec3(1.0) + (normalize(_8745 + vec3(0.001000000047497451305389404296875)) * 0.5))).xyz * _13436).xyz;
	    vec4 _13888 = _20496;
	    _13888.x = _15735.x;
	    _13888.y = _15735.y;
	    _13888.z = _15735.z;
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
	            if (dot(_21493, _21493) > PerViewConstantBufferCsgo_t._m20.x)
	            {
	                _12893 = (_10061.z * PerViewConstantBufferCsgo_t._m20.z) < PerViewConstantBufferCsgo_t._m20.y;
	            }
	            else
	            {
	                _12893 = false;
	            }
	            if (_12893)
	            {
	                vec2 _9342 = clamp(PerViewConstantBufferCsgo_t._m17.xy + (PerViewConstantBufferCsgo_t._m17.zw * vec2(length(_21493), _10061.z)), vec2(0.0), vec2(1.0));
	                float _12872 = (pow(_9342.x, PerViewConstantBufferCsgo_t._m18.x) * pow(_9342.y, PerViewConstantBufferCsgo_t._m18.y)) * PerViewConstantBufferCsgo_t._m19.w;
	                _19340 = mix(_13888.xyz, vec4(PerViewConstantBufferCsgo_t._m19.xyz, _12872).xyz, vec3(_12872));
	                break;
	            }
	            _19340 = _13888.xyz;
	            break;
	        } while(false);
	        vec4 _23945 = _13888;
	        _23945.x = _19340.x;
	        _23945.y = _19340.y;
	        _23945.z = _19340.z;
	        vec3 _19341;
	        do
	        {
	            bool _12894;
	            if (dot(_9057, _9057) > PerViewConstantBufferCsgo_t._m24.x)
	            {
	                _12894 = (PerViewConstantBufferCsgo_t._m24.z * _10061.z) < PerViewConstantBufferCsgo_t._m24.y;
	            }
	            else
	            {
	                _12894 = false;
	            }
	            if (_12894)
	            {
	                float _14602 = clamp(pow(max(0.0, (length(_21493) * PerViewConstantBufferCsgo_t._m21.y) + PerViewConstantBufferCsgo_t._m21.x), PerViewConstantBufferCsgo_t._m21.w), 0.0, 1.0) * clamp(pow(max(0.0, (_10061.z * PerViewConstantBufferCsgo_t._m22.y) + PerViewConstantBufferCsgo_t._m22.x), PerViewConstantBufferCsgo_t._m22.z), 0.0, 1.0);
	                float _8892 = saturate(_14602) * PerViewConstantBufferCsgo_t._m24.w;
	                _19341 = mix(_23945.xyz, vec4((textureLod(samplerCube(g_bindless_TextureCube_float4[PerViewConstantBufferCsgo_t._m3], undetermined[_Globals_.g_sTrilinearClamp]), normalize((mat4(vec4(PerViewConstantBufferCsgo_t._m23._m0[0].x, PerViewConstantBufferCsgo_t._m23._m0[1].x, PerViewConstantBufferCsgo_t._m23._m0[2].x, PerViewConstantBufferCsgo_t._m23._m0[3].x), vec4(PerViewConstantBufferCsgo_t._m23._m0[0].y, PerViewConstantBufferCsgo_t._m23._m0[1].y, PerViewConstantBufferCsgo_t._m23._m0[2].y, PerViewConstantBufferCsgo_t._m23._m0[3].y), vec4(PerViewConstantBufferCsgo_t._m23._m0[0].z, PerViewConstantBufferCsgo_t._m23._m0[1].z, PerViewConstantBufferCsgo_t._m23._m0[2].z, PerViewConstantBufferCsgo_t._m23._m0[3].z), vec4(PerViewConstantBufferCsgo_t._m23._m0[0].w, PerViewConstantBufferCsgo_t._m23._m0[1].w, PerViewConstantBufferCsgo_t._m23._m0[2].w, PerViewConstantBufferCsgo_t._m23._m0[3].w)) * vec4(_9057, 0.0)).xyz).xyz, PerViewConstantBufferCsgo_t._m22.w * clamp(1.0 - (_14602 * PerViewConstantBufferCsgo_t._m21.z), 0.0, 1.0)) * PerViewConstantBufferCsgo_t._m25.x).xyz, _8892).xyz, vec3(_8892));
	                break;
	            }
	            _19341 = _23945.xyz;
	            break;
	        } while(false);
	        _23945.x = _19341.x;
	        _23945.y = _19341.y;
	        _23945.z = _19341.z;
	        _6805 = _23945;
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
	bool g_bMaskVertexColor1 < UiType(CheckBox); Expression(g_nVertexColorMode1==0); >;
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
	float g_flAlphaTestReference1 < Default(0.5); Range(0.01, 0.99); UiType(Slider); UiGroup("Material1/Translucent,15/10"); >;
	float3 g_vTextureColorTint1 < Default3(1, 1, 1); UiType(Color); UiGroup("Material1/Color Correction,17/10"); >;
	float g_fTextureRoughnessContrast1 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material1/Lighting/11"); >;
	float g_fTextureRoughnessBrightness1 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material1/Lighting/12"); >;
	float g_fTextureNormalContrast1 < Default(1); Range(-2, 2); UiType(Slider); UiGroup("Material1/Lighting/13"); >;
	float g_flTexCoordRotation1 < Range(-360, 360); UiType(Slider); UiGroup("Material1/Texture Transform,35/13"); UiVisibility(1); >;
	CreateInputTexture2D(TextureAmbientOcclusion1, Linear, 8, "", "_ao", "Material1/Lighting,20/20", Default4(1, 1, 1, 0));
	float g_fTextureColorContrast1 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material1/Color Correction/20"); >;
	CreateInputTexture2D(TextureMetalness1, Linear, 8, "", "_metal", "Material1/Lighting/30", Default4(0, 0, 0, 0));
	float g_fTextureColorSaturation1 < Default(1); Range(0, 4); UiType(Slider); UiGroup("Material1/Color Correction/30"); >;
	CreateInputTexture2D(TextureNormalDetail1, Linear, 8, "NormalizeNormals", "_normal", "Material1/Detail/35", Default4(0.5, 0.5, 1, 0));
	float g_fTextureColorBrightness1 < Default(1); Range(-8, 8); UiType(Slider); UiGroup("Material1/Color Correction/40"); >;
	float g_fDetailTextureNormalContrast1 < Default(1); Range(-2, 2); UiType(Slider); UiGroup("Material1/Detail/45"); >;
	int g_nColorCorrectionMode1 < UiOptions("0=Mask All,1=Mask only Tint"); UiType(Enum); UiGroup("Material1/Color Correction/45"); >;
	bool g_bModelTint1 < Default(1); UiType(CheckBox); UiGroup("Material1/Color Correction/60"); >;
	int g_nVertexColorMode1 < Range4(0, 0, 0, 0, 2, 2, 2, 2); UiOptions("0=Masked,1=Unmasked,2=Disabled"); UiType(Enum); UiGroup("Material1/Color Correction/60"); >;
	
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
	// SPIR-V source (89152 bytes), GLSL reflection with SPIRV-Cross by KhronosGroup
	
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
	
	const vec3 _282[3] = vec3[](vec3(-1.0, 0.0, 0.0), vec3(0.0, 1.0, 0.0), vec3(0.0, 0.0, -1.0));
	
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
	
	float _333;
	vec4 _334;
	
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
	    vec3 _458 = vec3(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 208u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 212u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 216u) / 4u]);
	    float _457 = g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 220u) / 4u];
	    vec3 _456 = vec3(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 240u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 244u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 248u) / 4u]);
	    int _455 = g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 256u) / 4u];
	    vec2 _454 = vec2(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 264u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 268u) / 4u]);
	    vec4 _453 = vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 304u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 308u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 312u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 316u) / 4u]);
	    vec4 _452 = vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 320u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 324u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 328u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 332u) / 4u]);
	    vec4 _451 = vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 336u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 340u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 344u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 348u) / 4u]);
	    uint _450 = g_MaterialData_7._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 356u) / 4u];
	    uint _449 = g_MaterialData_7._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 360u) / 4u];
	    mat4 _448 = mat4(vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 368u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 384u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 400u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 416u) / 4u]), vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 372u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 388u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 404u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 420u) / 4u]), vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 376u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 392u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 408u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 424u) / 4u]), vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 380u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 396u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 412u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 428u) / 4u]));
	    uint _447 = g_MaterialData_7._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 588u) / 4u];
	    uint _446 = g_MaterialData_7._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 596u) / 4u];
	    bool _445 = g_MaterialData_5._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 604u) / 4u] != 0;
	    bool _444 = g_MaterialData_5._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 608u) / 4u] != 0;
	    float _443 = g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 612u) / 4u];
	    uvec3 _590;
	    do
	    {
	        if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes.w == 4)
	        {
	            uint _855 = (12u * uint(gl_PrimitiveID)) + uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes.w);
	            _590 = uvec3(g_Indices_1[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._m0[_855 / 4u], g_Indices_1[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._m0[(_855 + 4u) / 4u], g_Indices_1[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._m0[(_855 + 8u) / 4u]);
	            break;
	        }
	        else
	        {
	            uint _830 = (6u * uint(gl_PrimitiveID)) + uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes.w);
	            uint _831 = _830 & 4294967292u;
	            uint _832 = _831 / 4u;
	            uint _836 = (_831 + 4u) / 4u;
	            uint _841 = (g_Indices_1[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._m0[_832] & 4294901760u) >> uint(16);
	            uint _842 = g_Indices_1[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._m0[_836] & 65535u;
	            uvec3 _591;
	            if (_830 == _831)
	            {
	                _591 = uvec3(g_Indices_1[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._m0[_832] & 65535u, _841, _842);
	            }
	            else
	            {
	                _591 = uvec3(_841, _842, (g_Indices_1[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._m0[_836] & 4294901760u) >> uint(16));
	            }
	            _590 = _591;
	            break;
	        }
	        break;
	    } while(false);
	    uint _870 = uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.x);
	    uvec3 _878 = (uvec3(uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes.x)) * _590) + uvec3(uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes.x));
	    vec3 _584[3];
	    uint _880 = _878.x;
	    _584[0] = vec3(g_Vertices_1[_870]._m0[_880 / 4u], g_Vertices_1[_870]._m0[(_880 + 4u) / 4u], g_Vertices_1[_870]._m0[(_880 + 8u) / 4u]);
	    uint _894 = _878.y;
	    _584[1] = vec3(g_Vertices_1[_870]._m0[_894 / 4u], g_Vertices_1[_870]._m0[(_894 + 4u) / 4u], g_Vertices_1[_870]._m0[(_894 + 8u) / 4u]);
	    uint _908 = _878.z;
	    _584[2] = vec3(g_Vertices_1[_870]._m0[_908 / 4u], g_Vertices_1[_870]._m0[(_908 + 4u) / 4u], g_Vertices_1[_870]._m0[(_908 + 8u) / 4u]);
	    int _585 = 0;
	    VS_INPUT vsInput[3];
	    for (;;)
	    {
	        if (!(_585 < 3))
	        {
	            break;
	        }
	        vsInput[_585].vColorBlendValues = _584[_585];
	        _585++;
	        continue;
	    }
	    vec2 _586[3];
	    _586[0] = vec2(0.0);
	    _586[1] = vec2(0.0);
	    _586[2] = vec2(0.0);
	    if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].y != 0)
	    {
	        ivec4 _583 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers;
	        uint _951 = uint(_583[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].z]);
	        uint _953 = uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].z);
	        ivec4 _581 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes;
	        ivec4 _582 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes;
	        uvec3 _964 = (uvec3(uint(_581[_953])) * _590) + uvec3(uint(_582[_953]) + uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].x));
	        if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].y == 16)
	        {
	            uint _1099 = _964.x;
	            _586[0] = vec2(g_Vertices_1[_951]._m0[_1099 / 4u], g_Vertices_1[_951]._m0[(_1099 + 4u) / 4u]);
	            uint _1108 = _964.y;
	            _586[1] = vec2(g_Vertices_1[_951]._m0[_1108 / 4u], g_Vertices_1[_951]._m0[(_1108 + 4u) / 4u]);
	            uint _1117 = _964.z;
	            _586[2] = vec2(g_Vertices_1[_951]._m0[_1117 / 4u], g_Vertices_1[_951]._m0[(_1117 + 4u) / 4u]);
	        }
	        else
	        {
	            if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].y == 34)
	            {
	                uint _1070 = _964.x / 4u;
	                _586[0] = vec2(uint16BitsToFloat16(u16vec2(uvec2(g_Vertices_3[_951]._m0[_1070], g_Vertices_3[_951]._m0[_1070] >> uint(16)) & uvec2(65535u))));
	                uint _1080 = _964.y / 4u;
	                _586[1] = vec2(uint16BitsToFloat16(u16vec2(uvec2(g_Vertices_3[_951]._m0[_1080], g_Vertices_3[_951]._m0[_1080] >> uint(16)) & uvec2(65535u))));
	                uint _1090 = _964.z / 4u;
	                _586[2] = vec2(uint16BitsToFloat16(u16vec2(uvec2(g_Vertices_3[_951]._m0[_1090], g_Vertices_3[_951]._m0[_1090] >> uint(16)) & uvec2(65535u))));
	            }
	            else
	            {
	                if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].y == 37)
	                {
	                    uint _977 = _964.x / 4u;
	                    uint _981 = (g_Vertices_3[_951]._m0[_977] & 65535u);
	                    int _580;
	                    if (_981 > 32767u)
	                    {
	                        _580 = int(4294901760u | _981);
	                    }
	                    else
	                    {
	                        _580 = int(_981);
	                    }
	                    uint _994 = (g_Vertices_3[_951]._m0[_977] & 4294901760u) >> uint(16);
	                    int _579;
	                    if (_994 > 32767u)
	                    {
	                        _579 = int(4294901760u | _994);
	                    }
	                    else
	                    {
	                        _579 = int(_994);
	                    }
	                    _586[0] = vec2(max(float(_580) * 3.0518509447574615478515625e-05, -1.0), max(float(_579) * 3.0518509447574615478515625e-05, -1.0));
	                    uint _1008 = _964.y / 4u;
	                    uint _1012 = (g_Vertices_3[_951]._m0[_1008] & 65535u);
	                    int _578;
	                    if (_1012 > 32767u)
	                    {
	                        _578 = int(4294901760u | _1012);
	                    }
	                    else
	                    {
	                        _578 = int(_1012);
	                    }
	                    uint _1025 = (g_Vertices_3[_951]._m0[_1008] & 4294901760u) >> uint(16);
	                    int _577;
	                    if (_1025 > 32767u)
	                    {
	                        _577 = int(4294901760u | _1025);
	                    }
	                    else
	                    {
	                        _577 = int(_1025);
	                    }
	                    _586[1] = vec2(max(float(_578) * 3.0518509447574615478515625e-05, -1.0), max(float(_577) * 3.0518509447574615478515625e-05, -1.0));
	                    uint _1039 = _964.z / 4u;
	                    uint _1043 = (g_Vertices_3[_951]._m0[_1039] & 65535u);
	                    int _576;
	                    if (_1043 > 32767u)
	                    {
	                        _576 = int(4294901760u | _1043);
	                    }
	                    else
	                    {
	                        _576 = int(_1043);
	                    }
	                    uint _1056 = (g_Vertices_3[_951]._m0[_1039] & 4294901760u) >> uint(16);
	                    int _575;
	                    if (_1056 > 32767u)
	                    {
	                        _575 = int(4294901760u | _1056);
	                    }
	                    else
	                    {
	                        _575 = int(_1056);
	                    }
	                    _586[2] = vec2(max(float(_576) * 3.0518509447574615478515625e-05, -1.0), max(float(_575) * 3.0518509447574615478515625e-05, -1.0));
	                }
	            }
	        }
	    }
	    _585 = 0;
	    for (;;)
	    {
	        if (!(_585 < 3))
	        {
	            break;
	        }
	        vsInput[_585]._m1 = _586[_585];
	        _585++;
	        continue;
	    }
	    _586[0] = vec2(0.0);
	    _586[1] = vec2(0.0);
	    _586[2] = vec2(0.0);
	    if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[1].y != 0)
	    {
	        ivec4 _574 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers;
	        uint _1156 = uint(_574[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[1].z]);
	        uint _1158 = uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[1].z);
	        ivec4 _572 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes;
	        ivec4 _573 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes;
	        uvec3 _1169 = (uvec3(uint(_572[_1158])) * _590) + uvec3(uint(_573[_1158]) + uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[1].x));
	        if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[1].y == 16)
	        {
	            uint _1304 = _1169.x;
	            _586[0] = vec2(g_Vertices_1[_1156]._m0[_1304 / 4u], g_Vertices_1[_1156]._m0[(_1304 + 4u) / 4u]);
	            uint _1313 = _1169.y;
	            _586[1] = vec2(g_Vertices_1[_1156]._m0[_1313 / 4u], g_Vertices_1[_1156]._m0[(_1313 + 4u) / 4u]);
	            uint _1322 = _1169.z;
	            _586[2] = vec2(g_Vertices_1[_1156]._m0[_1322 / 4u], g_Vertices_1[_1156]._m0[(_1322 + 4u) / 4u]);
	        }
	        else
	        {
	            if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[1].y == 34)
	            {
	                uint _1275 = _1169.x / 4u;
	                _586[0] = vec2(uint16BitsToFloat16(u16vec2(uvec2(g_Vertices_3[_1156]._m0[_1275], g_Vertices_3[_1156]._m0[_1275] >> uint(16)) & uvec2(65535u))));
	                uint _1285 = _1169.y / 4u;
	                _586[1] = vec2(uint16BitsToFloat16(u16vec2(uvec2(g_Vertices_3[_1156]._m0[_1285], g_Vertices_3[_1156]._m0[_1285] >> uint(16)) & uvec2(65535u))));
	                uint _1295 = _1169.z / 4u;
	                _586[2] = vec2(uint16BitsToFloat16(u16vec2(uvec2(g_Vertices_3[_1156]._m0[_1295], g_Vertices_3[_1156]._m0[_1295] >> uint(16)) & uvec2(65535u))));
	            }
	            else
	            {
	                if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[1].y == 37)
	                {
	                    uint _1182 = _1169.x / 4u;
	                    uint _1186 = (g_Vertices_3[_1156]._m0[_1182] & 65535u);
	                    int _571;
	                    if (_1186 > 32767u)
	                    {
	                        _571 = int(4294901760u | _1186);
	                    }
	                    else
	                    {
	                        _571 = int(_1186);
	                    }
	                    uint _1199 = (g_Vertices_3[_1156]._m0[_1182] & 4294901760u) >> uint(16);
	                    int _570;
	                    if (_1199 > 32767u)
	                    {
	                        _570 = int(4294901760u | _1199);
	                    }
	                    else
	                    {
	                        _570 = int(_1199);
	                    }
	                    _586[0] = vec2(max(float(_571) * 3.0518509447574615478515625e-05, -1.0), max(float(_570) * 3.0518509447574615478515625e-05, -1.0));
	                    uint _1213 = _1169.y / 4u;
	                    uint _1217 = (g_Vertices_3[_1156]._m0[_1213] & 65535u);
	                    int _569;
	                    if (_1217 > 32767u)
	                    {
	                        _569 = int(4294901760u | _1217);
	                    }
	                    else
	                    {
	                        _569 = int(_1217);
	                    }
	                    uint _1230 = (g_Vertices_3[_1156]._m0[_1213] & 4294901760u) >> uint(16);
	                    int _568;
	                    if (_1230 > 32767u)
	                    {
	                        _568 = int(4294901760u | _1230);
	                    }
	                    else
	                    {
	                        _568 = int(_1230);
	                    }
	                    _586[1] = vec2(max(float(_569) * 3.0518509447574615478515625e-05, -1.0), max(float(_568) * 3.0518509447574615478515625e-05, -1.0));
	                    uint _1244 = _1169.z / 4u;
	                    uint _1248 = (g_Vertices_3[_1156]._m0[_1244] & 65535u);
	                    int _567;
	                    if (_1248 > 32767u)
	                    {
	                        _567 = int(4294901760u | _1248);
	                    }
	                    else
	                    {
	                        _567 = int(_1248);
	                    }
	                    uint _1261 = (g_Vertices_3[_1156]._m0[_1244] & 4294901760u) >> uint(16);
	                    int _566;
	                    if (_1261 > 32767u)
	                    {
	                        _566 = int(4294901760u | _1261);
	                    }
	                    else
	                    {
	                        _566 = int(_1261);
	                    }
	                    _586[2] = vec2(max(float(_567) * 3.0518509447574615478515625e-05, -1.0), max(float(_566) * 3.0518509447574615478515625e-05, -1.0));
	                }
	            }
	        }
	    }
	    _585 = 0;
	    for (;;)
	    {
	        if (!(_585 < 3))
	        {
	            break;
	        }
	        vsInput[_585]._m2 = _586[_585];
	        _585++;
	        continue;
	    }
	    vec3 _587[3];
	    vec4 _588[3];
	    do
	    {
	        if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.y != 0)
	        {
	            ivec4 _552 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers;
	            uint _1364 = uint(_552[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.z]);
	            uint _1366 = uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.z);
	            ivec4 _550 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes;
	            ivec4 _551 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes;
	            uvec3 _1377 = (uvec3(uint(_550[_1366])) * _590) + uvec3(uint(_551[_1366]) + uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.x));
	            if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.y == 6)
	            {
	                uint _1908 = _1377.x;
	                _587[0] = vec3(g_Vertices_1[_1364]._m0[_1908 / 4u], g_Vertices_1[_1364]._m0[(_1908 + 4u) / 4u], g_Vertices_1[_1364]._m0[(_1908 + 8u) / 4u]);
	                uint _1922 = _1377.y;
	                _587[1] = vec3(g_Vertices_1[_1364]._m0[_1922 / 4u], g_Vertices_1[_1364]._m0[(_1922 + 4u) / 4u], g_Vertices_1[_1364]._m0[(_1922 + 8u) / 4u]);
	                uint _1936 = _1377.z;
	                _587[2] = vec3(g_Vertices_1[_1364]._m0[_1936 / 4u], g_Vertices_1[_1364]._m0[(_1936 + 4u) / 4u], g_Vertices_1[_1364]._m0[(_1936 + 8u) / 4u]);
	            }
	            else
	            {
	                if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.y == 17)
	                {
	                    uint _1641 = _1377.x;
	                    uvec2 _1649 = uvec2(g_Vertices_3[_1364]._m0[_1641 / 4u], g_Vertices_3[_1364]._m0[(_1641 + 4u) / 4u]);
	                    uint _1650 = _1377.y;
	                    uvec2 _354 = uvec2(g_Vertices_3[_1364]._m0[_1650 / 4u], g_Vertices_3[_1364]._m0[(_1650 + 4u) / 4u]);
	                    uint _1659 = _1377.z;
	                    uvec2 _353 = uvec2(g_Vertices_3[_1364]._m0[_1659 / 4u], g_Vertices_3[_1364]._m0[(_1659 + 4u) / 4u]);
	                    uint _1671 = _1649.x;
	                    uint _1680 = _1649.y;
	                    vec2 _1690 = ((vec2(float((_1671) & 65535u), float((_1671 >> 16u) & 65535u)) * vec2(1.525902189314365386962890625e-05)) * 2.0) - vec2(1.0);
	                    float _1691 = _1690.x;
	                    float _1696 = (1.0 - abs(_1691)) - abs(_1690.y);
	                    vec3 _1697 = vec3(_1691, _1690.y, _1696);
	                    float _1699 = saturate(-_1696);
	                    vec2 _1705 = _1690 + mix(vec2(_1699), vec2(-_1699), greaterThanEqual(_1690, vec2(0.0)));
	                    _1697.x = _1705.x;
	                    _1697.y = _1705.y;
	                    vec3 _560 = normalize(_1697);
	                    vec2 _1712 = ((vec2(float((_1680 >> uint(1)) & 32767u), float((_1680 >> 16u) & 32767u)) * vec2(3.0518509447574615478515625e-05)) * 2.0) - vec2(1.0);
	                    float _1713 = _1712.x;
	                    float _1718 = (1.0 - abs(_1713)) - abs(_1712.y);
	                    vec3 _1719 = vec3(_1713, _1712.y, _1718);
	                    float _1721 = saturate(-_1718);
	                    vec2 _1727 = _1712 + mix(vec2(_1721), vec2(-_1721), greaterThanEqual(_1712, vec2(0.0)));
	                    _1719.x = _1727.x;
	                    _1719.y = _1727.y;
	                    vec3 _559 = normalize(_1719);
	                    float _540;
	                    if ((_1680 & 1u) != 0u)
	                    {
	                        _540 = 1.0;
	                    }
	                    else
	                    {
	                        _540 = -1.0;
	                    }
	                    _587[0] = _560;
	                    _588[0].w = _540;
	                    _588[0].x = _559.x;
	                    _588[0].y = _559.y;
	                    _588[0].z = _559.z;
	                    vec2 _1770 = ((vec2(float((_354.x) & 65535u), float((_354.x >> 16u) & 65535u)) * vec2(1.525902189314365386962890625e-05)) * 2.0) - vec2(1.0);
	                    float _1771 = _1770.x;
	                    float _1776 = (1.0 - abs(_1771)) - abs(_1770.y);
	                    vec3 _1777 = vec3(_1771, _1770.y, _1776);
	                    float _1779 = saturate(-_1776);
	                    vec2 _1785 = _1770 + mix(vec2(_1779), vec2(-_1779), greaterThanEqual(_1770, vec2(0.0)));
	                    _1777.x = _1785.x;
	                    _1777.y = _1785.y;
	                    vec3 _562 = normalize(_1777);
	                    vec2 _1792 = ((vec2(float((_354.y >> uint(1)) & 32767u), float((_354.y >> 16u) & 32767u)) * vec2(3.0518509447574615478515625e-05)) * 2.0) - vec2(1.0);
	                    float _1793 = _1792.x;
	                    float _1798 = (1.0 - abs(_1793)) - abs(_1792.y);
	                    vec3 _1799 = vec3(_1793, _1792.y, _1798);
	                    float _1801 = saturate(-_1798);
	                    vec2 _1807 = _1792 + mix(vec2(_1801), vec2(-_1801), greaterThanEqual(_1792, vec2(0.0)));
	                    _1799.x = _1807.x;
	                    _1799.y = _1807.y;
	                    vec3 _561 = normalize(_1799);
	                    float _539;
	                    if ((_354.y & 1u) != 0u)
	                    {
	                        _539 = 1.0;
	                    }
	                    else
	                    {
	                        _539 = -1.0;
	                    }
	                    _587[1] = _562;
	                    _588[1].w = _539;
	                    _588[1].x = _561.x;
	                    _588[1].y = _561.y;
	                    _588[1].z = _561.z;
	                    vec2 _1850 = ((vec2(float((_353.x) & 65535u), float((_353.x >> 16u) & 65535u)) * vec2(1.525902189314365386962890625e-05)) * 2.0) - vec2(1.0);
	                    float _1851 = _1850.x;
	                    float _1856 = (1.0 - abs(_1851)) - abs(_1850.y);
	                    vec3 _1857 = vec3(_1851, _1850.y, _1856);
	                    float _1859 = saturate(-_1856);
	                    vec2 _1865 = _1850 + mix(vec2(_1859), vec2(-_1859), greaterThanEqual(_1850, vec2(0.0)));
	                    _1857.x = _1865.x;
	                    _1857.y = _1865.y;
	                    vec3 _564 = normalize(_1857);
	                    vec2 _1872 = ((vec2(float((_353.y >> uint(1)) & 32767u), float((_353.y >> 16u) & 32767u)) * vec2(3.0518509447574615478515625e-05)) * 2.0) - vec2(1.0);
	                    float _1873 = _1872.x;
	                    float _1878 = (1.0 - abs(_1873)) - abs(_1872.y);
	                    vec3 _1879 = vec3(_1873, _1872.y, _1878);
	                    float _1881 = saturate(-_1878);
	                    vec2 _1887 = _1872 + mix(vec2(_1881), vec2(-_1881), greaterThanEqual(_1872, vec2(0.0)));
	                    _1879.x = _1887.x;
	                    _1879.y = _1887.y;
	                    vec3 _563 = normalize(_1879);
	                    float _538;
	                    if ((_353.y & 1u) != 0u)
	                    {
	                        _538 = 1.0;
	                    }
	                    else
	                    {
	                        _538 = -1.0;
	                    }
	                    _587[2] = _564;
	                    _588[2].w = _538;
	                    _588[2].x = _563.x;
	                    _588[2].y = _563.y;
	                    _588[2].z = _563.z;
	                    break;
	                }
	                else
	                {
	                    uint _1387 = _1377.x / 4u;
	                    vec4 _554 = _588[0];
	                    float _1402 = (float((g_Vertices_3[_1364]._m0[_1387] >> 12u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _1405 = (float((g_Vertices_3[_1364]._m0[_1387] >> 22u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _1409 = (1.0 - abs(_1402)) - abs(_1405);
	                    vec3 _1410 = vec3(_1402, _1405, _1409);
	                    float _1412 = saturate(-_1409);
	                    vec2 _1413 = vec2(_1402, _1405);
	                    vec2 _1419 = _1413 + mix(vec2(_1412), vec2(-_1412), greaterThanEqual(_1413, vec2(0.0)));
	                    _1410.x = _1419.x;
	                    _1410.y = _1419.y;
	                    vec3 _1424 = normalize(_1410);
	                    vec3 _553 = _1424;
	                    float _1425 = _1424.z;
	                    float _547;
	                    if (_1425 >= 0.0)
	                    {
	                        _547 = 1.0;
	                    }
	                    else
	                    {
	                        _547 = -1.0;
	                    }
	                    float _1432 = (-1.0) / (_547 + _1425);
	                    float _1433 = _1424.x;
	                    vec3 _548;
	                    vec3 _1441 = _548;
	                    _1441.x = 1.0 + (((_547 * _1433) * _1433) * _1432);
	                    _1441.y = _547 * ((_1433 * _1424.y) * _1432);
	                    _1441.z = (-_547) * _1433;
	                    _548 = _1441;
	                    float _1449 = float((g_Vertices_3[_1364]._m0[_1387] >> uint(1)) & 2047u) * 0.003069460391998291015625;
	                    vec3 _1455 = (_1441 * cos(_1449)) + (cross(_1424, _1441) * sin(_1449));
	                    vec4 _1457 = _554;
	                    _1457.x = _1455.x;
	                    _1457.y = _1455.y;
	                    _1457.z = _1455.z;
	                    _554 = _1457;
	                    float _549;
	                    if ((g_Vertices_3[_1364]._m0[_1387] & 1u) == 0u)
	                    {
	                        _549 = -1.0;
	                    }
	                    else
	                    {
	                        _549 = 1.0;
	                    }
	                    vec4 _1468 = _554;
	                    _1468.w = _549;
	                    _554 = _1468;
	                    _587[0] = _553;
	                    _588[0] = _1468;
	                    uint _1472 = _1377.y / 4u;
	                    vec4 _556 = _588[1];
	                    float _1487 = (float((g_Vertices_3[_1364]._m0[_1472] >> 12u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _1490 = (float((g_Vertices_3[_1364]._m0[_1472] >> 22u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _1494 = (1.0 - abs(_1487)) - abs(_1490);
	                    vec3 _1495 = vec3(_1487, _1490, _1494);
	                    float _1497 = saturate(-_1494);
	                    vec2 _1498 = vec2(_1487, _1490);
	                    vec2 _1504 = _1498 + mix(vec2(_1497), vec2(-_1497), greaterThanEqual(_1498, vec2(0.0)));
	                    _1495.x = _1504.x;
	                    _1495.y = _1504.y;
	                    vec3 _1509 = normalize(_1495);
	                    vec3 _555 = _1509;
	                    float _1510 = _1509.z;
	                    float _544;
	                    if (_1510 >= 0.0)
	                    {
	                        _544 = 1.0;
	                    }
	                    else
	                    {
	                        _544 = -1.0;
	                    }
	                    float _1517 = (-1.0) / (_544 + _1510);
	                    float _1518 = _1509.x;
	                    vec3 _545;
	                    vec3 _1526 = _545;
	                    _1526.x = 1.0 + (((_544 * _1518) * _1518) * _1517);
	                    _1526.y = _544 * ((_1518 * _1509.y) * _1517);
	                    _1526.z = (-_544) * _1518;
	                    _545 = _1526;
	                    float _1534 = float((g_Vertices_3[_1364]._m0[_1472] >> uint(1)) & 2047u) * 0.003069460391998291015625;
	                    vec3 _1540 = (_1526 * cos(_1534)) + (cross(_1509, _1526) * sin(_1534));
	                    vec4 _1542 = _556;
	                    _1542.x = _1540.x;
	                    _1542.y = _1540.y;
	                    _1542.z = _1540.z;
	                    _556 = _1542;
	                    float _546;
	                    if ((g_Vertices_3[_1364]._m0[_1472] & 1u) == 0u)
	                    {
	                        _546 = -1.0;
	                    }
	                    else
	                    {
	                        _546 = 1.0;
	                    }
	                    vec4 _1553 = _556;
	                    _1553.w = _546;
	                    _556 = _1553;
	                    _587[1] = _555;
	                    _588[1] = _1553;
	                    uint _1557 = _1377.z / 4u;
	                    vec4 _558 = _588[2];
	                    float _1572 = (float((g_Vertices_3[_1364]._m0[_1557] >> 12u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _1575 = (float((g_Vertices_3[_1364]._m0[_1557] >> 22u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _1579 = (1.0 - abs(_1572)) - abs(_1575);
	                    vec3 _1580 = vec3(_1572, _1575, _1579);
	                    float _1582 = saturate(-_1579);
	                    vec2 _1583 = vec2(_1572, _1575);
	                    vec2 _1589 = _1583 + mix(vec2(_1582), vec2(-_1582), greaterThanEqual(_1583, vec2(0.0)));
	                    _1580.x = _1589.x;
	                    _1580.y = _1589.y;
	                    vec3 _1594 = normalize(_1580);
	                    vec3 _557 = _1594;
	                    float _1595 = _1594.z;
	                    float _541;
	                    if (_1595 >= 0.0)
	                    {
	                        _541 = 1.0;
	                    }
	                    else
	                    {
	                        _541 = -1.0;
	                    }
	                    float _1602 = (-1.0) / (_541 + _1595);
	                    float _1603 = _1594.x;
	                    vec3 _542;
	                    vec3 _1611 = _542;
	                    _1611.x = 1.0 + (((_541 * _1603) * _1603) * _1602);
	                    _1611.y = _541 * ((_1603 * _1594.y) * _1602);
	                    _1611.z = (-_541) * _1603;
	                    _542 = _1611;
	                    float _1619 = float((g_Vertices_3[_1364]._m0[_1557] >> uint(1)) & 2047u) * 0.003069460391998291015625;
	                    vec3 _1625 = (_1611 * cos(_1619)) + (cross(_1594, _1611) * sin(_1619));
	                    vec4 _1627 = _558;
	                    _1627.x = _1625.x;
	                    _1627.y = _1625.y;
	                    _1627.z = _1625.z;
	                    _558 = _1627;
	                    float _543;
	                    if ((g_Vertices_3[_1364]._m0[_1557] & 1u) == 0u)
	                    {
	                        _543 = -1.0;
	                    }
	                    else
	                    {
	                        _543 = 1.0;
	                    }
	                    vec4 _1638 = _558;
	                    _1638.w = _543;
	                    _558 = _1638;
	                    _587[2] = _557;
	                    _588[2] = _1638;
	                    break;
	                }
	                break;
	            }
	        }
	        else
	        {
	            _587[0] = vec3(0.0);
	            _587[1] = vec3(0.0);
	            _587[2] = vec3(0.0);
	        }
	        if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTangentFieldInfo.y != 0)
	        {
	            ivec4 _565 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers;
	            uint _1961 = uint(_565[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTangentFieldInfo.z]);
	            uint _1963 = uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTangentFieldInfo.z);
	            ivec4 _536 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes;
	            ivec4 _537 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes;
	            uvec3 _1974 = (uvec3(uint(_536[_1963])) * _590) + uvec3(uint(_537[_1963]) + uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTangentFieldInfo.x));
	            uint _1976 = _1974.x;
	            _588[0] = vec4(g_Vertices_1[_1961]._m0[_1976 / 4u], g_Vertices_1[_1961]._m0[(_1976 + 4u) / 4u], g_Vertices_1[_1961]._m0[(_1976 + 8u) / 4u], g_Vertices_1[_1961]._m0[(_1976 + 12u) / 4u]);
	            uint _1994 = _1974.y;
	            _588[1] = vec4(g_Vertices_1[_1961]._m0[_1994 / 4u], g_Vertices_1[_1961]._m0[(_1994 + 4u) / 4u], g_Vertices_1[_1961]._m0[(_1994 + 8u) / 4u], g_Vertices_1[_1961]._m0[(_1994 + 12u) / 4u]);
	            uint _2012 = _1974.z;
	            _588[2] = vec4(g_Vertices_1[_1961]._m0[_2012 / 4u], g_Vertices_1[_1961]._m0[(_2012 + 4u) / 4u], g_Vertices_1[_1961]._m0[(_2012 + 8u) / 4u], g_Vertices_1[_1961]._m0[(_2012 + 12u) / 4u]);
	        }
	        else
	        {
	            _588[0] = vec4(0.0);
	            _588[1] = vec4(0.0);
	            _588[2] = vec4(0.0);
	        }
	        break;
	    } while(false);
	    _585 = 0;
	    for (;;)
	    {
	        if (!(_585 < 3))
	        {
	            break;
	        }
	        vsInput[_585]._m3 = _587[_585];
	        vsInput[_585]._m4 = _588[_585];
	        _585++;
	        continue;
	    }
	    vec4 _589[3];
	    if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vColorFieldInfo.data[0].y != 0)
	    {
	        ivec4 _535 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers;
	        uint _2063 = uint(_535[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vColorFieldInfo.data[0].z]);
	        uint _2065 = uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vColorFieldInfo.data[0].z);
	        ivec4 _533 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes;
	        ivec4 _534 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes;
	        uvec3 _2076 = (uvec3(uint(_533[_2065])) * _590) + uvec3(uint(_534[_2065]) + uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vColorFieldInfo.data[0].x));
	        if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vColorFieldInfo.data[0].y == 2)
	        {
	            uint _2130 = _2076.x;
	            _589[0] = vec4(g_Vertices_1[_2063]._m0[_2130 / 4u], g_Vertices_1[_2063]._m0[(_2130 + 4u) / 4u], g_Vertices_1[_2063]._m0[(_2130 + 8u) / 4u], g_Vertices_1[_2063]._m0[(_2130 + 12u) / 4u]);
	            uint _2148 = _2076.y;
	            _589[1] = vec4(g_Vertices_1[_2063]._m0[_2148 / 4u], g_Vertices_1[_2063]._m0[(_2148 + 4u) / 4u], g_Vertices_1[_2063]._m0[(_2148 + 8u) / 4u], g_Vertices_1[_2063]._m0[(_2148 + 12u) / 4u]);
	            uint _2166 = _2076.z;
	            _589[2] = vec4(g_Vertices_1[_2063]._m0[_2166 / 4u], g_Vertices_1[_2063]._m0[(_2166 + 4u) / 4u], g_Vertices_1[_2063]._m0[(_2166 + 8u) / 4u], g_Vertices_1[_2063]._m0[(_2166 + 12u) / 4u]);
	        }
	        else
	        {
	            uint _2083 = _2076.x / 4u;
	            _589[0] = vec4(uvec4((g_Vertices_3[_2063]._m0[_2083] & 255u), (g_Vertices_3[_2063]._m0[_2083] & 65280u) >> uint(8), (g_Vertices_3[_2063]._m0[_2083] & 16711680u) >> uint(16), (g_Vertices_3[_2063]._m0[_2083] & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	            uint _2099 = _2076.y / 4u;
	            _589[1] = vec4(uvec4((g_Vertices_3[_2063]._m0[_2099] & 255u), (g_Vertices_3[_2063]._m0[_2099] & 65280u) >> uint(8), (g_Vertices_3[_2063]._m0[_2099] & 16711680u) >> uint(16), (g_Vertices_3[_2063]._m0[_2099] & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	            uint _2115 = _2076.z / 4u;
	            _589[2] = vec4(uvec4((g_Vertices_3[_2063]._m0[_2115] & 255u), (g_Vertices_3[_2063]._m0[_2115] & 65280u) >> uint(8), (g_Vertices_3[_2063]._m0[_2115] & 16711680u) >> uint(16), (g_Vertices_3[_2063]._m0[_2115] & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	        }
	    }
	    else
	    {
	        _589[0] = vec4(0.0);
	        _589[1] = vec4(0.0);
	        _589[2] = vec4(0.0);
	    }
	    _585 = 0;
	    for (;;)
	    {
	        if (!(_585 < 3))
	        {
	            break;
	        }
	        vsInput[_585]._m7 = _589[_585];
	        _585++;
	        continue;
	    }
	    vec4 _592[3];
	    _592[0] = vec4(0.0);
	    _592[1] = vec4(0.0);
	    _592[2] = vec4(0.0);
	    if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[4].y != 0)
	    {
	        ivec4 _532 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers;
	        uint _2217 = uint(_532[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[4].z]);
	        uint _2219 = uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[4].z);
	        ivec4 _530 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes;
	        ivec4 _531 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes;
	        uvec3 _2230 = (uvec3(uint(_530[_2219])) * _590) + uvec3(uint(_531[_2219]) + uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[4].x));
	        if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[4].y == 2)
	        {
	            uint _2283 = _2230.x;
	            _592[0] = vec4(g_Vertices_1[_2217]._m0[_2283 / 4u], g_Vertices_1[_2217]._m0[(_2283 + 4u) / 4u], g_Vertices_1[_2217]._m0[(_2283 + 8u) / 4u], g_Vertices_1[_2217]._m0[(_2283 + 12u) / 4u]);
	            uint _2300 = _2230.y;
	            _592[1] = vec4(g_Vertices_1[_2217]._m0[_2300 / 4u], g_Vertices_1[_2217]._m0[(_2300 + 4u) / 4u], g_Vertices_1[_2217]._m0[(_2300 + 8u) / 4u], g_Vertices_1[_2217]._m0[(_2300 + 12u) / 4u]);
	            uint _2317 = _2230.z;
	            _592[2] = vec4(g_Vertices_1[_2217]._m0[_2317 / 4u], g_Vertices_1[_2217]._m0[(_2317 + 4u) / 4u], g_Vertices_1[_2217]._m0[(_2317 + 8u) / 4u], g_Vertices_1[_2217]._m0[(_2317 + 12u) / 4u]);
	        }
	        else
	        {
	            if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[4].y == 28)
	            {
	                uint _2239 = _2230.x / 4u;
	                _592[0] = vec4(uvec4((g_Vertices_3[_2217]._m0[_2239] & 255u), (g_Vertices_3[_2217]._m0[_2239] & 65280u) >> uint(8), (g_Vertices_3[_2217]._m0[_2239] & 16711680u) >> uint(16), (g_Vertices_3[_2217]._m0[_2239] & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	                uint _2254 = _2230.y / 4u;
	                _592[1] = vec4(uvec4((g_Vertices_3[_2217]._m0[_2254] & 255u), (g_Vertices_3[_2217]._m0[_2254] & 65280u) >> uint(8), (g_Vertices_3[_2217]._m0[_2254] & 16711680u) >> uint(16), (g_Vertices_3[_2217]._m0[_2254] & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	                uint _2269 = _2230.z / 4u;
	                _592[2] = vec4(uvec4((g_Vertices_3[_2217]._m0[_2269] & 255u), (g_Vertices_3[_2217]._m0[_2269] & 65280u) >> uint(8), (g_Vertices_3[_2217]._m0[_2269] & 16711680u) >> uint(16), (g_Vertices_3[_2217]._m0[_2269] & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	            }
	        }
	    }
	    int _593 = 0;
	    for (;;)
	    {
	        if (!(_593 < 3))
	        {
	            break;
	        }
	        vsInput[_593]._m8 = _592[_593];
	        _593++;
	        continue;
	    }
	    vec3 _527 = vsInput[0]._m3;
	    vec4 _528;
	    vec4 _2358 = _528;
	    _2358.x = vsInput[0]._m4.x;
	    _2358.y = vsInput[0]._m4.y;
	    _2358.z = vsInput[0]._m4.z;
	    _2358.w = vsInput[0]._m4.w;
	    _528 = _2358;
	    vec4 _2383 = vec4(uvec4((g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 255u), (g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 65280u) >> uint(8), (g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 16711680u) >> uint(16), (g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	    vec4 _526 = _2383;
	    vec3 _2384 = _2383.xyz;
	    vec3 _2385 = _2384 * vec3(0.077399380505084991455078125);
	    vec3 _2388 = pow((_2384 * vec3(0.947867333889007568359375)) + vec3(0.052132703363895416259765625), vec3(2.400000095367431640625));
	    float _523;
	    if (_2383.x <= 0.040449999272823333740234375)
	    {
	        _523 = _2385.x;
	    }
	    else
	    {
	        _523 = _2388.x;
	    }
	    float _524;
	    if (_2383.y <= 0.040449999272823333740234375)
	    {
	        _524 = _2385.y;
	    }
	    else
	    {
	        _524 = _2388.y;
	    }
	    float _525;
	    if (_2383.z <= 0.040449999272823333740234375)
	    {
	        _525 = _2385.z;
	    }
	    else
	    {
	        _525 = _2388.z;
	    }
	    vec3 _2413 = vec3(_523, _524, _525);
	    vec4 _2415 = _526;
	    _2415.x = _2413.x;
	    _2415.y = _2413.y;
	    _2415.z = _2413.z;
	    _526 = _2415;
	    vec4 _371;
	    vec4 _2422 = _371;
	    _2422.x = _2415.x;
	    _2422.y = _2415.y;
	    _2422.z = _2415.z;
	    _2422.w = _2415.w;
	    _371 = _2422;
	    mat3x4 _2433 = transpose(gl_WorldToObjectEXT);
	    mat3 _522;
	    mat3 _2436 = _522;
	    _2436[0] = _2433[0].xyz;
	    _2436[1] = _2433[1].xyz;
	    _2436[2] = _2433[2].xyz;
	    _522 = _2436;
	    vec3 _2445 = normalize(_2436 * _527.xyz);
	    vec3 _372;
	    vec3 _2447 = _372;
	    _2447.x = _2445.x;
	    _2447.y = _2445.y;
	    _2447.z = _2445.z;
	    _372 = _2447;
	    mat3x4 _2459 = transpose(gl_WorldToObjectEXT);
	    mat3 _521;
	    mat3 _2462 = _521;
	    _2462[0] = _2459[0].xyz;
	    _2462[1] = _2459[1].xyz;
	    _2462[2] = _2459[2].xyz;
	    _521 = _2462;
	    vec3 _2471 = normalize(_2462 * _528.xyz);
	    vec4 _370;
	    vec4 _2473 = _370;
	    _2473.x = _2471.x;
	    _2473.y = _2471.y;
	    _2473.z = _2471.z;
	    _2473.w = _528.w;
	    _370 = _2473;
	    vec4 _2482 = vsInput[0]._m1.xyxy;
	    _2482.z = vsInput[0]._m2.x;
	    _2482.w = vsInput[0]._m2.y;
	    vec4 _373;
	    vec4 _369 = _373;
	    vec3 _368 = vec4(vsInput[0].vColorBlendValues.xyz, 1.0) * transpose(gl_ObjectToWorldEXT);
	    vec3 _367 = _2447;
	    vec4 _366 = _2482;
	    vec4 _365 = _2422;
	    vec4 _364 = _2473;
	    if (_455 > 0)
	    {
	        vec2 _529;
	        if (_455 == 2)
	        {
	            _529 = _2482.zw;
	        }
	        else
	        {
	            _529 = _2482.xy;
	        }
	        vec4 _2502 = _366;
	        _2502.x = _529.x;
	        _2502.y = _529.y;
	        vec4 _2518 = _2502;
	        _2518.x = dot(_2502.xy, _453.xy) + _453.w;
	        _2518.y = dot(_2502.xy, _452.xy) + _452.w;
	        _366 = _2518;
	    }
	    vec4 _2520 = _365;
	    vec4 _2522 = _369;
	    _2522.x = _2520.x;
	    _2522.y = _2520.y;
	    _2522.z = _2520.z;
	    _2522.w = _457 * (1.0 - min(_2522.x, min(_2522.y, _2522.z)));
	    _369 = _2522;
	    _2520.x = _458.x;
	    _2520.y = _458.y;
	    _2520.z = _458.z;
	    vec3 _2550 = _2520.xyz * mix(vec3(1.0), vsInput[0]._m7.xyz, vec3(vsInput[0]._m7.w));
	    vec4 _2552 = _2520;
	    _2552.x = _2550.x;
	    _2552.y = _2550.y;
	    _2552.z = _2550.z;
	    _365 = _2552;
	    vec4 _352 = _2522;
	    vec3 _351 = _368;
	    vec3 _350 = _367;
	    vec4 _349 = _366;
	    vec4 _348 = _2552;
	    vec4 _347 = _364;
	    vec3 _518 = vsInput[1]._m3;
	    vec4 _519;
	    vec4 _2566 = _519;
	    _2566.x = vsInput[1]._m4.x;
	    _2566.y = vsInput[1]._m4.y;
	    _2566.z = vsInput[1]._m4.z;
	    _2566.w = vsInput[1]._m4.w;
	    _519 = _2566;
	    vec4 _2591 = vec4(uvec4((g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 255u), (g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 65280u) >> uint(8), (g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 16711680u) >> uint(16), (g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	    vec4 _517 = _2591;
	    vec3 _2592 = _2591.xyz;
	    vec3 _2593 = _2592 * vec3(0.077399380505084991455078125);
	    vec3 _2596 = pow((_2592 * vec3(0.947867333889007568359375)) + vec3(0.052132703363895416259765625), vec3(2.400000095367431640625));
	    float _514;
	    if (_2591.x <= 0.040449999272823333740234375)
	    {
	        _514 = _2593.x;
	    }
	    else
	    {
	        _514 = _2596.x;
	    }
	    float _515;
	    if (_2591.y <= 0.040449999272823333740234375)
	    {
	        _515 = _2593.y;
	    }
	    else
	    {
	        _515 = _2596.y;
	    }
	    float _516;
	    if (_2591.z <= 0.040449999272823333740234375)
	    {
	        _516 = _2593.z;
	    }
	    else
	    {
	        _516 = _2596.z;
	    }
	    vec3 _2621 = vec3(_514, _515, _516);
	    vec4 _2623 = _517;
	    _2623.x = _2621.x;
	    _2623.y = _2621.y;
	    _2623.z = _2621.z;
	    _517 = _2623;
	    vec4 _381;
	    vec4 _2630 = _381;
	    _2630.x = _2623.x;
	    _2630.y = _2623.y;
	    _2630.z = _2623.z;
	    _2630.w = _2623.w;
	    _381 = _2630;
	    mat3x4 _2641 = transpose(gl_WorldToObjectEXT);
	    mat3 _513;
	    mat3 _2644 = _513;
	    _2644[0] = _2641[0].xyz;
	    _2644[1] = _2641[1].xyz;
	    _2644[2] = _2641[2].xyz;
	    _513 = _2644;
	    vec3 _2653 = normalize(_2644 * _518.xyz);
	    vec3 _382;
	    vec3 _2655 = _382;
	    _2655.x = _2653.x;
	    _2655.y = _2653.y;
	    _2655.z = _2653.z;
	    _382 = _2655;
	    mat3x4 _2667 = transpose(gl_WorldToObjectEXT);
	    mat3 _512;
	    mat3 _2670 = _512;
	    _2670[0] = _2667[0].xyz;
	    _2670[1] = _2667[1].xyz;
	    _2670[2] = _2667[2].xyz;
	    _512 = _2670;
	    vec3 _2679 = normalize(_2670 * _519.xyz);
	    vec4 _380;
	    vec4 _2681 = _380;
	    _2681.x = _2679.x;
	    _2681.y = _2679.y;
	    _2681.z = _2679.z;
	    _2681.w = _519.w;
	    _380 = _2681;
	    vec4 _2690 = vsInput[1]._m1.xyxy;
	    _2690.z = vsInput[1]._m2.x;
	    _2690.w = vsInput[1]._m2.y;
	    vec4 _383;
	    vec4 _379 = _383;
	    vec3 _378 = vec4(vsInput[1].vColorBlendValues.xyz, 1.0) * transpose(gl_ObjectToWorldEXT);
	    vec3 _377 = _2655;
	    vec4 _376 = _2690;
	    vec4 _375 = _2630;
	    vec4 _374 = _2681;
	    if (_455 > 0)
	    {
	        vec2 _520;
	        if (_455 == 2)
	        {
	            _520 = _2690.zw;
	        }
	        else
	        {
	            _520 = _2690.xy;
	        }
	        vec4 _2710 = _376;
	        _2710.x = _520.x;
	        _2710.y = _520.y;
	        vec4 _2726 = _2710;
	        _2726.x = dot(_2710.xy, _453.xy) + _453.w;
	        _2726.y = dot(_2710.xy, _452.xy) + _452.w;
	        _376 = _2726;
	    }
	    vec4 _2728 = _375;
	    vec4 _2730 = _379;
	    _2730.x = _2728.x;
	    _2730.y = _2728.y;
	    _2730.z = _2728.z;
	    _2730.w = _457 * (1.0 - min(_2730.x, min(_2730.y, _2730.z)));
	    _379 = _2730;
	    _2728.x = _458.x;
	    _2728.y = _458.y;
	    _2728.z = _458.z;
	    vec3 _2758 = _2728.xyz * mix(vec3(1.0), vsInput[1]._m7.xyz, vec3(vsInput[1]._m7.w));
	    vec4 _2760 = _2728;
	    _2760.x = _2758.x;
	    _2760.y = _2758.y;
	    _2760.z = _2758.z;
	    _375 = _2760;
	    vec4 _346 = _2730;
	    vec3 _345 = _378;
	    vec3 _344 = _377;
	    vec4 _343 = _376;
	    vec4 _342 = _2760;
	    vec4 _341 = _374;
	    vec3 _509 = vsInput[2]._m3;
	    vec4 _510;
	    vec4 _2774 = _510;
	    _2774.x = vsInput[2]._m4.x;
	    _2774.y = vsInput[2]._m4.y;
	    _2774.z = vsInput[2]._m4.z;
	    _2774.w = vsInput[2]._m4.w;
	    _510 = _2774;
	    vec4 _2799 = vec4(uvec4((g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 255u), (g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 65280u) >> uint(8), (g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 16711680u) >> uint(16), (g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	    vec4 _508 = _2799;
	    vec3 _2800 = _2799.xyz;
	    vec3 _2801 = _2800 * vec3(0.077399380505084991455078125);
	    vec3 _2804 = pow((_2800 * vec3(0.947867333889007568359375)) + vec3(0.052132703363895416259765625), vec3(2.400000095367431640625));
	    float _505;
	    if (_2799.x <= 0.040449999272823333740234375)
	    {
	        _505 = _2801.x;
	    }
	    else
	    {
	        _505 = _2804.x;
	    }
	    float _506;
	    if (_2799.y <= 0.040449999272823333740234375)
	    {
	        _506 = _2801.y;
	    }
	    else
	    {
	        _506 = _2804.y;
	    }
	    float _507;
	    if (_2799.z <= 0.040449999272823333740234375)
	    {
	        _507 = _2801.z;
	    }
	    else
	    {
	        _507 = _2804.z;
	    }
	    vec3 _2829 = vec3(_505, _506, _507);
	    vec4 _2831 = _508;
	    _2831.x = _2829.x;
	    _2831.y = _2829.y;
	    _2831.z = _2829.z;
	    _508 = _2831;
	    vec4 _391;
	    vec4 _2838 = _391;
	    _2838.x = _2831.x;
	    _2838.y = _2831.y;
	    _2838.z = _2831.z;
	    _2838.w = _2831.w;
	    _391 = _2838;
	    mat3x4 _2849 = transpose(gl_WorldToObjectEXT);
	    mat3 _504;
	    mat3 _2852 = _504;
	    _2852[0] = _2849[0].xyz;
	    _2852[1] = _2849[1].xyz;
	    _2852[2] = _2849[2].xyz;
	    _504 = _2852;
	    vec3 _2861 = normalize(_2852 * _509.xyz);
	    vec3 _392;
	    vec3 _2863 = _392;
	    _2863.x = _2861.x;
	    _2863.y = _2861.y;
	    _2863.z = _2861.z;
	    _392 = _2863;
	    mat3x4 _2875 = transpose(gl_WorldToObjectEXT);
	    mat3 _503;
	    mat3 _2878 = _503;
	    _2878[0] = _2875[0].xyz;
	    _2878[1] = _2875[1].xyz;
	    _2878[2] = _2875[2].xyz;
	    _503 = _2878;
	    vec3 _2887 = normalize(_2878 * _510.xyz);
	    vec4 _390;
	    vec4 _2889 = _390;
	    _2889.x = _2887.x;
	    _2889.y = _2887.y;
	    _2889.z = _2887.z;
	    _2889.w = _510.w;
	    _390 = _2889;
	    vec4 _2898 = vsInput[2]._m1.xyxy;
	    _2898.z = vsInput[2]._m2.x;
	    _2898.w = vsInput[2]._m2.y;
	    vec4 _393;
	    vec4 _389 = _393;
	    vec3 _388 = vec4(vsInput[2].vColorBlendValues.xyz, 1.0) * transpose(gl_ObjectToWorldEXT);
	    vec3 _387 = _2863;
	    vec4 _386 = _2898;
	    vec4 _385 = _2838;
	    vec4 _384 = _2889;
	    if (_455 > 0)
	    {
	        vec2 _511;
	        if (_455 == 2)
	        {
	            _511 = _2898.zw;
	        }
	        else
	        {
	            _511 = _2898.xy;
	        }
	        vec4 _2918 = _386;
	        _2918.x = _511.x;
	        _2918.y = _511.y;
	        vec4 _2934 = _2918;
	        _2934.x = dot(_2918.xy, _453.xy) + _453.w;
	        _2934.y = dot(_2918.xy, _452.xy) + _452.w;
	        _386 = _2934;
	    }
	    vec4 _2936 = _385;
	    vec4 _2938 = _389;
	    _2938.x = _2936.x;
	    _2938.y = _2936.y;
	    _2938.z = _2936.z;
	    _2938.w = _457 * (1.0 - min(_2938.x, min(_2938.y, _2938.z)));
	    _389 = _2938;
	    _2936.x = _458.x;
	    _2936.y = _458.y;
	    _2936.z = _458.z;
	    vec3 _2966 = _2936.xyz * mix(vec3(1.0), vsInput[2]._m7.xyz, vec3(vsInput[2]._m7.w));
	    vec4 _2968 = _2936;
	    _2968.x = _2966.x;
	    _2968.y = _2966.y;
	    _2968.z = _2966.z;
	    _385 = _2968;
	    vec3 _340 = _388;
	    vec3 _339 = _387;
	    vec3 _2998 = ((_350 * ((1.0 - _22.barycentrics.x) - _22.barycentrics.y)) + (_344 * _22.barycentrics.x)) + (_387 * _22.barycentrics.y);
	    bool _3004 = gl_HitKindEXT == 254u;
	    vec3 _394;
	    vec3 _395;
	    vec4 _363 = ((_352 * ((1.0 - _22.barycentrics.x) - _22.barycentrics.y)) + (_346 * _22.barycentrics.x)) + (_2938 * _22.barycentrics.y);
	    vec3 _362 = _395;
	    vec3 _361 = _2998;
	    vec4 _360 = ((_349 * ((1.0 - _22.barycentrics.x) - _22.barycentrics.y)) + (_343 * _22.barycentrics.x)) + (_386 * _22.barycentrics.y);
	    vec4 _359 = ((_348 * ((1.0 - _22.barycentrics.x) - _22.barycentrics.y)) + (_342 * _22.barycentrics.x)) + (_2968 * _22.barycentrics.y);
	    vec4 _358 = ((_347 * ((1.0 - _22.barycentrics.x) - _22.barycentrics.y)) + (_341 * _22.barycentrics.x)) + (_384 * _22.barycentrics.y);
	    bool _357 = _3004;
	    vec2 _405 = vec2(0.5);
	    vec3 _404 = vec3(0.0);
	    float _403 = 0.039999999105930328369140625;
	    vec3 _402 = vec3(0.0);
	    vec3 _401 = vec3(0.0);
	    vec3 _399 = vec3(1.0);
	    bool _398 = false;
	    vec3 _397 = vec3(1.0, 0.0, 0.0);
	    vec3 _396 = vec3(0.0, 1.0, 0.0);
	    vec3 _3043 = _2998.xyz;
	    vec3 _400 = _3043;
	    if (dot(_3043, _3043) >= 1.0099999904632568359375)
	    {
	        _400 = _394.xyz;
	    }
	    _403 = _443;
	    _399 = normalize(cross(_345 - _351, _388 - _351));
	    bool _501;
	    if (_444)
	    {
	        _501 = !_445;
	    }
	    else
	    {
	        _501 = false;
	    }
	    if (_501)
	    {
	        float _502;
	        if (_3004)
	        {
	            _502 = 1.0;
	        }
	        else
	        {
	            _502 = -1.0;
	        }
	        _400 *= _502;
	        if (_3004)
	        {
	            _502 = 1.0;
	        }
	        else
	        {
	            _502 = -1.0;
	        }
	        _399 *= _502;
	        _398 = !_3004;
	    }
	    vec3 _3072 = _400;
	    vec3 _3073 = normalize(_3072);
	    _400 = _3073;
	    vec2 _433 = _405;
	    vec3 _432 = _404;
	    float _431 = _403;
	    vec3 _430 = _402;
	    vec3 _429 = _401;
	    vec3 _428 = _3073;
	    vec3 _427 = _399;
	    bool _426 = _398;
	    vec3 _425 = _397;
	    vec3 _424 = _396;
	    bool _492;
	    if (_444)
	    {
	        _492 = !_445;
	    }
	    else
	    {
	        _492 = false;
	    }
	    if (_492)
	    {
	        float _493;
	        if (_357)
	        {
	            _493 = 1.0;
	        }
	        else
	        {
	            _493 = -1.0;
	        }
	        _492 = _493 < 0.0;
	    }
	    else
	    {
	        _492 = false;
	    }
	    vec3 _437 = vec3(0.0);
	    vec3 _436 = vec3(0.0);
	    float _490;
	    if (_358.w > 0.0)
	    {
	        _490 = 1.0;
	    }
	    else
	    {
	        _490 = -1.0;
	    }
	    float _3118 = 1.0 / length(_361);
	    vec3 _438 = _361 * _3118;
	    vec3 _356 = _358.xyz * _3118;
	    vec3 _355 = (cross(_361, _358.xyz) * _490) * _3118;
	    if (_492)
	    {
	        _438 *= (-1.0);
	    }
	    vec3 _435 = _437 - (_438 * dot(_437, _438));
	    vec3 _434 = _436 - (_438 * dot(_436, _438));
	    int _491;
	    if (dot(_436, cross(_438, _437)) < 0.0)
	    {
	        _491 = -1;
	    }
	    else
	    {
	        _491 = 1;
	    }
	    vec3 _462 = _438;
	    vec3 _461 = _435;
	    vec3 _460 = _434;
	    float _459 = float(_491);
	    vec3 _422;
	    vec3 _423;
	    if (_455 > 1)
	    {
	        float _489;
	        if (false)
	        {
	            _489 = -1.0;
	        }
	        else
	        {
	            _489 = 1.0;
	        }
	        vec2 _3154 = vec2(0.0, -0.0) * _489;
	        vec3 _439 = (_461 * _3154.x) + (_460 * _3154.y);
	        float _3162 = abs(0.0);
	        if (_3162 > 0.0)
	        {
	            _439 = normalize(_439);
	        }
	        _423 = _439;
	        _422 = cross(_462, _439) * (_489 * _459);
	    }
	    vec4 _421 = vec4(0.0);
	    vec3 _420 = vec3(0.0);
	    vec3 _419 = vec3(0.0);
	    vec3 _418 = vec3(0.0);
	    vec2 _417 = vec2(0.0);
	    float _416 = 0.0;
	    float _415 = 0.0;
	    float _414 = 0.0;
	    bool _494;
	    if (_455 == 0)
	    {
	        vec3 _3273 = _429.xyz * _456.xyz;
	        vec3 _3275 = _418;
	        _3275.x = _3273.x;
	        _3275.y = _3273.y;
	        _3275.z = _3273.z;
	        _418 = _3275;
	        _417 = _454.xy;
	        _494 = true;
	    }
	    else
	    {
	        vec3 _3181 = _418;
	        _3181.x = _360.x;
	        _3181.y = _360.y;
	        _418 = _3181;
	        vec4 _3191 = textureLod(sampler2D(g_bindless_Texture2D_float4[_449], g_bindless_Sampler[_447]), _3181.xy, 0.0);
	        _415 = _3191.y;
	        _416 = _3191.w;
	        _421 = textureLod(sampler2D(g_bindless_Texture2D_float4[_446], g_bindless_Sampler[_447]), _3181.xy, 0.0).xyzw;
	        vec4 _3206 = textureLod(sampler2D(g_bindless_Texture2D_float4[_450], g_bindless_Sampler[_447]), _3181.xy, 0.0);
	        float _3207 = _3206.x;
	        float _3208 = _3206.y;
	        float _3210 = (_3207 + _3208) - 1.00392162799835205078125;
	        float _3211 = _3207 - _3208;
	        vec3 _3218 = normalize(vec3(vec2(_3210, _3211), (1.0 - abs(_3210)) - abs(_3211)));
	        vec3 _3220 = _420;
	        _3220.x = _3218.x;
	        _3220.y = _3218.y;
	        _3220.z = _3218.z;
	        vec3 _3233 = _3220;
	        _3233.x = dot(_3220.xy, _451.xy);
	        _3233.y = dot(_3220.xy, _451.zw);
	        _420 = _3233;
	        _414 = _3206.z;
	        vec3 _412;
	        vec3 _413;
	        if (_455 > 1)
	        {
	            _413 = _423;
	            _412 = _422;
	        }
	        else
	        {
	            _413 = _356;
	            _412 = _355;
	        }
	        vec3 _3245 = abs(_420.xyz);
	        vec2 _3258 = (-vec2(_420.x, (-1.0) * _420.y)) / vec2(max(_3245.z, 0.0078125 * max(_3245.x, _3245.y)));
	        _419 = normalize(_462 - ((_413 * _3258.x) + (_412 * _3258.y)));
	        _494 = false;
	    }
	    _425 = _358.xyz;
	    float _495;
	    if (_358.w > 0.0)
	    {
	        _495 = 1.0;
	    }
	    else
	    {
	        _495 = -1.0;
	    }
	    _424 = cross(_361.xyz, _425.xyz) * _495;
	    if (_494)
	    {
	        vec3 _3300 = abs(_428.xyz);
	        vec3 _496 = _3300;
	        float _3305 = _3300.x;
	        float _3306 = _3300.y;
	        if (_3305 > _3306)
	        {
	            _494 = _3305 > _3300.z;
	        }
	        else
	        {
	            _494 = false;
	        }
	        ivec3 _498;
	        if (_494)
	        {
	            _498 = ivec3(0, 1, 2);
	        }
	        else
	        {
	            if (_3306 > _3300.z)
	            {
	                _498 = ivec3(1, 2, 0);
	            }
	            else
	            {
	                _498 = ivec3(2, 0, 1);
	            }
	        }
	        ivec3 _497 = _498;
	        if (_3305 < _3306)
	        {
	            _494 = _3305 < _3300.z;
	        }
	        else
	        {
	            _494 = false;
	        }
	        if (_494)
	        {
	            _498 = ivec3(0, 1, 2);
	        }
	        else
	        {
	            if (_3306 < _3300.z)
	            {
	                _498 = ivec3(1, 2, 0);
	            }
	            else
	            {
	                _498 = ivec3(2, 0, 1);
	            }
	        }
	        ivec3 _499 = (ivec3(3) - _498) - _497;
	        ivec2 _500;
	        if (_497.x == 1)
	        {
	            _500 = _497.zy;
	        }
	        else
	        {
	            _500 = _497.yz;
	        }
	        ivec3 _3353 = _497;
	        _3353.y = _500.x;
	        _3353.z = _500.y;
	        _497 = _3353;
	        if (_499.x == 1)
	        {
	            _500 = _499.zy;
	        }
	        else
	        {
	            _500 = _499.yz;
	        }
	        ivec3 _3369 = _499;
	        _3369.y = _500.x;
	        _3369.z = _500.y;
	        _499 = _3369;
	        vec2 _3383 = clamp((vec2(_496[_497.x], _496[_3369.x]) - vec2(0.577300012111663818359375)) * vec2(2.365744113922119140625), vec2(0.0), vec2(1.0));
	        vec2 _3388 = _3383 / vec2(_3383.x + _3383.y);
	        vec3 _484 = _362 * _456.xyz;
	        vec2 _411 = vec2(_484[_497.y], _484[_497.z]);
	        vec3 _485 = vec3(0.0);
	        vec3 _486 = vec3(0.0);
	        vec2 _3403 = vec2(_485[_497.y], _486[_497.z]);
	        vec2 _409 = _3403;
	        vec2 _408 = _3403;
	        vec2 _410 = vec2(_484[_3369.y], _484[_3369.z]);
	        vec3 _487 = vec3(0.0);
	        vec3 _488 = vec3(0.0);
	        vec2 _3415 = vec2(_487[_3369.y], _488[_3369.z]);
	        vec2 _407 = _3415;
	        vec2 _406 = _3415;
	        if (_455 == 0)
	        {
	            vec2 _3432 = _411 * _417;
	            vec2 _3433 = _409 * _417;
	            vec2 _3434 = _408 * _417;
	            vec2 _3435 = _410 * _417;
	            vec2 _442 = _3435;
	            vec2 _3436 = _407 * _417;
	            vec2 _441 = _3436;
	            vec2 _3437 = _406 * _417;
	            vec2 _440 = _3437;
	            float _3446 = _3388.x;
	            float _3455 = _3388.y;
	            vec4 _3457 = (textureGrad(sampler2D(g_bindless_Texture2D_float4[_449], g_bindless_Sampler[_447]), _3432.xy, _3433.xy, _3434.xy) * _3446) + (textureGrad(sampler2D(g_bindless_Texture2D_float4[_449], g_bindless_Sampler[_447]), _3435.xy, _3436.xy, _3437.xy) * _3455);
	            _421 = (textureGrad(sampler2D(g_bindless_Texture2D_float4[_446], g_bindless_Sampler[_447]), _3432.xy, _3433.xy, _3434.xy) * _3446) + (textureGrad(sampler2D(g_bindless_Texture2D_float4[_446], g_bindless_Sampler[_447]), _3435.xy, _3436.xy, _3437.xy) * _3455);
	            vec4 _3481 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_450], g_bindless_Sampler[_447]), _3432.xy, _3433.xy, _3434.xy);
	            vec4 _478 = _3481;
	            _414 = _3481.z * _3446;
	            float _3484 = _3481.x;
	            float _3485 = _3481.y;
	            float _3487 = (_3484 + _3485) - 1.00392162799835205078125;
	            float _3488 = _3484 - _3485;
	            vec3 _3497 = normalize(vec3(vec2(_3487, _3488), (1.0 - abs(_3487)) - abs(_3488))).xyz * _3446;
	            vec3 _3499 = _420;
	            _3499.x = _3497.x;
	            _3499.y = _3497.y;
	            _3499.z = _3497.z;
	            _420 = _3499;
	            float _480;
	            if (int(sign(dot(_425.xyz, _282[_497.y]))) < 0)
	            {
	                _480 = -1.0;
	            }
	            else
	            {
	                _480 = 1.0;
	            }
	            vec3 _3515 = _420;
	            _3515.x = _3515.x * _480;
	            _420 = _3515;
	            if (int(sign(dot(_424.xyz, _282[_497.z]))) < 0)
	            {
	                _480 = -1.0;
	            }
	            else
	            {
	                _480 = 1.0;
	            }
	            vec3 _3530 = _420;
	            _3530.y = _3530.y * _480;
	            _420 = _3530;
	            vec4 _3545 = textureGrad(sampler2D(g_bindless_Texture2D_float4[_450], g_bindless_Sampler[_447]), _442.xy, _441.xy, _440.xy);
	            _414 += (_3545.z * _3455);
	            float _3550 = _3545.x;
	            float _3551 = _3545.y;
	            float _3553 = (_3550 + _3551) - 1.00392162799835205078125;
	            float _3554 = _3550 - _3551;
	            vec3 _3563 = normalize(vec3(vec2(_3553, _3554), (1.0 - abs(_3553)) - abs(_3554))).xyz * _3455;
	            vec4 _3565 = _3545;
	            _3565.x = _3563.x;
	            _3565.y = _3563.y;
	            _3565.z = _3563.z;
	            _478 = _3565;
	            if (int(sign(dot(_425.xyz, _282[_499.y]))) < 0)
	            {
	                _480 = -1.0;
	            }
	            else
	            {
	                _480 = 1.0;
	            }
	            vec4 _3580 = _478;
	            _3580.x = _3580.x * _480;
	            _478 = _3580;
	            if (int(sign(dot(_424.xyz, _282[_499.z]))) < 0)
	            {
	                _480 = -1.0;
	            }
	            else
	            {
	                _480 = 1.0;
	            }
	            vec4 _3595 = _478;
	            _3595.y = _3595.y * _480;
	            _478 = _3595;
	            vec3 _3600 = _420;
	            vec3 _3603 = _3600.xyz + _3595.xyz;
	            vec3 _3605 = _3600;
	            _3605.x = _3603.x;
	            _3605.y = _3603.y;
	            _3605.z = _3603.z;
	            _420 = _3605;
	            _415 = _3457.y;
	            _416 = _3457.w;
	            vec3 _476 = _3605.xyz;
	            bool _474;
	            if (_444)
	            {
	                _474 = !_445;
	            }
	            else
	            {
	                _474 = false;
	            }
	            if (_474)
	            {
	                float _475;
	                if (_357)
	                {
	                    _475 = 1.0;
	                }
	                else
	                {
	                    _475 = -1.0;
	                }
	                _474 = _475 < 0.0;
	            }
	            else
	            {
	                _474 = false;
	            }
	            float _477;
	            if (_474)
	            {
	                _477 = -1.0;
	            }
	            else
	            {
	                _477 = 1.0;
	            }
	            float _3633 = _477;
	            vec3 _3634 = _361.xyz * _3633;
	            if (_358.w > 0.0)
	            {
	                _477 = 1.0;
	            }
	            else
	            {
	                _477 = -1.0;
	            }
	            vec3 _3645 = cross(_3634.xyz, _358.xyz) * _477;
	            bool _472;
	            if (_444)
	            {
	                _472 = !_445;
	            }
	            else
	            {
	                _472 = false;
	            }
	            if (_472)
	            {
	                float _473;
	                if (_357)
	                {
	                    _473 = 1.0;
	                }
	                else
	                {
	                    _473 = -1.0;
	                }
	                _472 = _473 < 0.0;
	            }
	            else
	            {
	                _472 = false;
	            }
	            if (!_472)
	            {
	                vec3 _3665 = _476;
	                _3665.y = -_3665.y;
	                _476 = _3665;
	            }
	            _425 = _358.xyz;
	            _424 = _3645;
	            vec3 _3672 = _358.xyz * _476.x;
	            vec3 _471;
	            vec3 _3674 = _471;
	            _3674.x = _3672.x;
	            _3674.y = _3672.y;
	            _3674.z = _3672.z;
	            vec3 _3684 = _3674.xyz + (_3645.xyz * _476.y);
	            vec3 _3686 = _3674;
	            _3686.x = _3684.x;
	            _3686.y = _3684.y;
	            _3686.z = _3684.z;
	            vec3 _3695 = _3686.xyz + (_3634.xyz * _476.z);
	            vec3 _3697 = _3686;
	            _3697.x = _3695.x;
	            _3697.y = _3695.y;
	            _3697.z = _3695.z;
	            _471 = _3697;
	            _419 = normalize(_3697.xyz);
	        }
	    }
	    vec4 _3718 = mix(_421, vec4((vec4(_421.xyz, 1.0) * _448).xyz, _421.w), vec4(_415));
	    float _3723 = dot(_3718.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125));
	    vec3 _3726 = normalize(max(_363.xyz, vec3(0.001000000047497451305389404296875)));
	    vec3 _3750 = vec4(clamp(mix(_3718.xyz, (_3726 * min(_3723 / dot(_3726.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125)), (3.0 * _3723) * max(_363.x, max(_363.y, _363.z)))).xyz, vec3(_363.w * _415)), vec3(0.0), vec3(1.0)).xyz, _333).xyz * mix(vec3(1.0), _359.xyz, vec3(clamp(max(0.0, _415), 0.0, 1.0)));
	    vec4 _3752;
	    _3752.x = _3750.x;
	    _3752.y = _3750.y;
	    _3752.z = _3750.z;
	    vec2 _3759 = _433;
	    _3759.x = _414;
	    _3759.y = _414;
	    _433 = _3759;
	    _21._m5 = int(uint(gl_InstanceID));
	    _21._m3 = gl_RayTmaxEXT;
	    _21._m1 = _427;
	    _21._m2 = _428;
	    vec3 _463[3] = vec3[](_350, _344, _339);
	    vec3 _464[3] = vec3[](_351, _345, _340);
	    vec3 _3795 = ((_351 * ((1.0 - _22.barycentrics.x) - _22.barycentrics.y)) + (_345 * _22.barycentrics.x)) + (_340 * _22.barycentrics.y);
	    vec3 _465[3];
	    _465[0] = _3795 - (_350 * dot(_3795 - _351, _350));
	    _465[1] = _3795 - (_344 * dot(_3795 - _345, _344));
	    _465[2] = _3795 - (_339 * dot(_3795 - _340, _339));
	    vec3 _3823 = ((_465[0] * ((1.0 - _22.barycentrics.x) - _22.barycentrics.y)) + (_465[1] * _22.barycentrics.x)) + (_465[2] * _22.barycentrics.y);
	    vec3 _466[3];
	    _466[0] = cross(_351 - _345, _21._m1);
	    _466[1] = cross(_345 - _340, _21._m1);
	    _466[2] = cross(_340 - _351, _21._m1);
	    float _467 = dot(_3823 - _3795, _21._m1);
	    vec3 _468 = _3823;
	    int _469 = 0;
	    for (;;)
	    {
	        bool _3839_ladder_break = false;
	        do
	        {
	            if (!(_469 < 3))
	            {
	                _3839_ladder_break = true;
	                break;
	            }
	            if (_467 > 0.00999999977648258209228515625)
	            {
	                _3839_ladder_break = true;
	                break;
	            }
	            if (dot(_466[_469], _466[_469]) == 0.0)
	            {
	                break;
	            }
	            _466[_469] = normalize(_466[_469]);
	            int _470 = 0;
	            for (;;)
	            {
	                if (!(_470 < 3))
	                {
	                    break;
	                }
	                vec3 _3877 = _463[_470] - (_466[_469] * dot(_466[_469], _463[_470]));
	                _465[_470] = _3795 - (_3877 * dot(_3795 - _464[_470], _3877));
	                _470++;
	                continue;
	            }
	            vec3 _3901 = ((_465[0] * ((1.0 - _22.barycentrics.x) - _22.barycentrics.y)) + (_465[1] * _22.barycentrics.x)) + (_465[2] * _22.barycentrics.y);
	            _467 = dot(_3901 - _3795, _21._m1);
	            _468 = _3901;
	            break;
	        } while(false);
	        if (_3839_ladder_break)
	        {
	            break;
	        }
	        _469++;
	        continue;
	    }
	    if (!(_467 > 0.00999999977648258209228515625))
	    {
	        _468 = vec3(3.4028234663852885981170418348452e+38);
	    }
	    _21.material = _468;
	    _21._m6 = _426;
	    f16vec3 _3914 = f16vec3(vec3(0.0));
	    _21._m7 = MaterialDataMinimal_t(_3914, float16_t(0.0), f16vec3(vec3(1.0, 0.0, 1.0)), float16_t(1.0), _3914, float16_t(0.040008544921875), 0u, f16vec4(ivec4(0)));
	    _21._m7.vMaterialBits = f16vec3(_419);
	    _21._m7._m2 = f16vec3(_3752.xyz);
	    _21._m7._m4 = f16vec3(_432);
	    _21._m7._m5 = float16_t(_431);
	    _21._m7._m1 = float16_t(_416);
	    _21._m7._m3 = float16_t(dot(_3759, vec2(0.5)));
	    if (any(greaterThan(_430, vec3(0.0))))
	    {
	        f16vec4 _3943 = _21._m7._m7;
	        f16vec3 _3946 = f16vec3(_430);
	        _3943.x = _3946.x;
	        _3943.y = _3946.y;
	        _3943.z = _3946.z;
	        _21._m7 = MaterialDataMinimal_t(_21._m7.vMaterialBits, _21._m7._m1, _21._m7._m2, _21._m7._m3, _21._m7._m4, _21._m7._m5, (_21._m7._m6 & 4294901760u) | 1u, _3943);
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
