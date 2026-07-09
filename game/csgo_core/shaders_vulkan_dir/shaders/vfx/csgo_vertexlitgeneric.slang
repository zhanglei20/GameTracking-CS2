//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "(S1) vertexlit, bump, phong shader for CSGO.";
	DevShader = false;
	Version = 4;
	
	// VcsVersion: 71
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
	Feature( F_SELF_ILLUM, 0..1, "Self Illum" );
	Feature( F_DECAL_TEXTURE, 0..1, "Decal Texture" );
	Feature( F_DECAL_BLEND_MODE, 0..1, "Decal Blend Mode" );
	Feature( F_DEPTH_BIAS, 0..1, "Z-Buffering" );
	Feature( F_DETAIL_TEXTURE, 0..1 (0="None", 1="Mod2X"), "Detail Texture" );
	Feature( F_NOTINT, 0..1, "Prevent Tinting" );
	Feature( F_FORCE_UV2, 0..1, "Ensure 2nd UV set presnt in vertex data" );
	FeatureRule( Requires( F_DONT_FLIP_BACKFACE_NORMALS, F_RENDER_BACKFACES ), "Only applies to backfaces" );
	FeatureRule( Allow1( F_ALPHA_TEST, F_TRANSLUCENT ), "Translucent and Alpha Test are not compatible" );
	FeatureRule( Requires( F_ADDITIVE_BLEND, F_TRANSLUCENT ), "Requires translucency" );
	FeatureRule( Allow1( F_TRANSLUCENT, F_DO_NOT_CAST_SHADOWS ), "Translucent and Do Not Cast Shadows are not compatible" );
	FeatureRule( Requires( F_SPECULAR_DIRECT, F_SPECULAR_INDIRECT ), "Direct specular requires indirect (we'd prefer to avoid having only direct specular)" );
	FeatureRule( Allow1( F_DETAIL_TEXTURE, F_ADDITIVE_BLEND ), "Detail Texture and Additive Blend are not compatible" );
	FeatureRule( ChildOf( F_DECAL_BLEND_MODE, F_DECAL_TEXTURE ), "Decal Blend Mode requires Decal Texture" );
}

COMMON
{
	#include "system.fxc"
}

struct VS_INPUT
{
	float4 vBlendIndices              : BLENDINDICES0  < Semantic( BlendIndices ); >;              // D_CS_VERTEX_ANIMATION=0, S_MODE_TOOLS_VIS=1, S_SHADER_QUALITY=1
	float4 vPerVertexLighting         : COLOR1         < Semantic( PerVertexLighting ); >;         // D_BAKED_LIGHTING_FROM_VERTEX_STREAM=1
	uint4  nPackedFrame               : NORMAL0        < Semantic( CompressedTangentFrame ); >;   
	float4 vNormalOs                  : NORMAL0        < Semantic( Normal ); >;                   
	float3 vPositionOs                : POSITION0      < Semantic( PosXyz ); >;                    // D_CS_VERTEX_ANIMATION=0
	float2 vTexCoord2                 : TEXCOORD1      < Semantic( LowPrecisionUv1 ); >;           // S_FORCE_UV2=1, S_DECAL_TEXTURE=1
	float2 vLightmapUV                : TEXCOORD3      < Semantic( LightmapUV ); >;                // D_BAKED_LIGHTING_FROM_LIGHTMAP=1
	float4 vTangentUOs_flTangentVSign : TANGENT0       < Semantic( TangentU_SignV ); >;           
	float2 vTexCoord                  : TEXCOORD0      < Semantic( LowPrecisionUv ); >;           
	float2 nInstanceIdx               : TEXCOORD13     < Semantic( InstanceTransformUv ); >;      
};

VS
{
	StaticCombo( S_SPECULAR_DIRECT, F_SPECULAR_DIRECT );
	StaticCombo( S_SPECULAR_INDIRECT, F_SPECULAR_INDIRECT );
	StaticCombo( S_FORCE_UV2, F_FORCE_UV2 );
	StaticCombo( S_DECAL_TEXTURE, F_DECAL_TEXTURE );
	StaticCombo( S_DETAIL_TEXTURE, F_DETAIL_TEXTURE );
	StaticCombo( S_MODE_TOOLS_VIS, 0..1 );
	StaticCombo( S_SHADER_QUALITY, 0..1 );
	StaticComboRule( Allow1( S_DECAL_TEXTURE, S_FORCE_UV2 ) );
	StaticComboRule( Requires( S_SHADER_QUALITY, S_MODE_TOOLS_VIS ) );
	StaticComboRule( Requires( S_SPECULAR_DIRECT, S_SPECULAR_INDIRECT ) );
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
	float4 g_vDetailTexCoordXform < UiType(VectorText); Expression(v0 = (g_flDetailTexCoordRotation*3.1415927)/180;
		v1 = cos(v0);
		v2 = sin(v0);
		v3 = g_vDetailTexCoordScale;
		v3.xxy*float4(v1,-v2,v2,v1)); >;
	float4 g_vNormalTexCoordXform0 < UiType(VectorText); Expression(v0 = (g_flNormalTexCoordRotation*3.14159)/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v1*g_vNormalTexCoordScale.x,-v2*g_vNormalTexCoordScale.y,0,((g_vNormalTexCoordCenter.x+g_vNormalTexCoordOffset.x)+((v2*g_vNormalTexCoordScale.y)*g_vNormalTexCoordCenter.y))-((v1*g_vNormalTexCoordScale.x)*g_vNormalTexCoordCenter.x))); >;
	float4 g_vNormalTexCoordXform1 < UiType(VectorText); Expression(v0 = (g_flNormalTexCoordRotation*3.14159)/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v2*g_vNormalTexCoordScale.x,v1*g_vNormalTexCoordScale.y,0,((g_vNormalTexCoordCenter.y+g_vNormalTexCoordOffset.y)+((v2*g_vNormalTexCoordScale.x)*g_vNormalTexCoordCenter.x))-((v1*g_vNormalTexCoordScale.y)*g_vNormalTexCoordCenter.y))); >;
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
	
	// Detail Texture
	bool g_bUseSecondaryUvForDetailTexture < Default(1); UiType(CheckBox); UiGroup("Detail Texture, 170"); >;
	float2 g_vDetailTexCoordScale < Default2(1, 1); UiType(VectorText); UiGroup("Detail Texture,80/30"); >;
	float g_flDetailTexCoordRotation < Range(0, 360); UiType(Slider); UiGroup("Detail Texture,80/35"); >;
	float2 g_vDetailTexCoordOffset < Range2(-1, -1, 1, 1); UiType(VectorText); UiGroup("Detail Texture,80/40"); Expression(v0 = (g_flDetailTexCoordRotation*3.1415927)/180;
		v1 = cos(v0);
		v2 = sin(v0);
		v3 = g_vDetailTexCoordScale;
		v4 = this;
		(((-.5*v3)*float2(v1-v2,v2+v1))+v4)+.5); >;
	
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
	
	// Normal Map
	float g_flNormalTexCoordRotation < Range(-360, 360); UiType(Slider); UiGroup("Normal Map,50"); >;
	float2 g_vNormalTexCoordCenter < Default2(0.5, 0.5); UiType(VectorText); UiGroup("Normal Map,30"); >;
	float2 g_vNormalTexCoordOffset < Range2(-1, -1, 1, 1); UiType(VectorText); UiGroup("Normal Map,60"); >;
	float2 g_vNormalTexCoordScale < Default2(1, 1); Range2(0, 0, 100, 100); UiType(VectorText); UiGroup("Normal Map,40"); >;
	
	// SPIR-V reflection failed for backend HLSL:
	// cbuffer ID 5618 (name: _Globals_), member index 0 (name: g_vTexCoordXform0) cannot be expressed with either HLSL packing layout or packoffset.
	//
	// Re-attempting reflection with the GLSL backend.
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (6932 bytes), GLSL reflection with SPIRV-Cross by KhronosGroup
	
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
	
	struct _1549
	{
	    vec4 g_vTexCoordXform0;
	    vec4 g_vTexCoordXform1;
	    vec2 g_vTexCoordScrollSpeed;
	    vec3 g_vColorTint;
	    float g_flModelTintAmount;
	    vec4 g_vNormalTexCoordXform0;
	    vec4 g_vNormalTexCoordXform1;
	};
	
	layout(set = 0) uniform _1549 _Globals_;
	
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
	layout(location = 0) out vec2 output_0;
	layout(location = 1) out vec3 output_1;
	layout(location = 2) out vec3 output_2;
	layout(location = 3) out vec4 output_3;
	layout(location = 4) centroid out vec4 output_4;
	layout(location = 5) out vec4 output_5;
	layout(location = 6) flat out uint output_6;
	
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
	    output_0 = vec2(dot(vTexCoord.xy, _Globals_.g_vNormalTexCoordXform0.xy) + _Globals_.g_vNormalTexCoordXform0.w, dot(vTexCoord.xy, _Globals_.g_vNormalTexCoordXform1.xy) + _Globals_.g_vNormalTexCoordXform1.w);
	    output_1 = _12151.xyz - PerViewConstantBufferCsgo_t._m0.xyz;
	    output_2 = normalize(vec4(vNormalOs.xyz, 0.0) * _21957._m0);
	    output_3 = _20488;
	    output_4 = _23714;
	    output_5 = vec4(normalize(vec4(vTangentUOs_flTangentVSign.xyz, 0.0) * _21957._m0), vTangentUOs_flTangentVSign.w);
	    output_6 = _20228._m5 & 65535u;
	    _18237.y = -_18237.y;
	    gl_Position = _18237;
	}
	
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
	
	BoolAttribute(BindlessResources, true);
	BoolAttribute(CanBatchWithDynamicShaderConstants, true);
	IntAttribute(TexCoordScaleByModelU, g_nScaleTexCoordUByModelScaleAxis-1);
	IntAttribute(TexCoordScaleByModelV, g_nScaleTexCoordVByModelScaleAxis-1);
	Float3Attribute(LightSim_MaterialTint, g_vColorTint);
	BoolAttribute(SupportsAggregateInstancing, F_TRANSLUCENT==0);
	
	
	// Variant Attributes
	BoolAttribute(environmentmapped, true);
	BoolAttribute(environmentmappeddynamic, true);
}

PS
{
	StaticCombo( S_SPECULAR_DIRECT, F_SPECULAR_DIRECT );
	StaticCombo( S_SPECULAR_INDIRECT, F_SPECULAR_INDIRECT );
	StaticCombo( S_FORCE_UV2, F_FORCE_UV2 );
	StaticCombo( S_DECAL_TEXTURE, F_DECAL_TEXTURE );
	StaticCombo( S_DETAIL_TEXTURE, F_DETAIL_TEXTURE );
	StaticCombo( S_MODE_TOOLS_VIS, 0..1 );
	StaticCombo( S_ALPHA_TEST, F_ALPHA_TEST );
	StaticCombo( S_TRANSLUCENT, F_TRANSLUCENT );
	StaticCombo( S_ADDITIVE_BLEND, F_ADDITIVE_BLEND );
	StaticCombo( S_TINT_MASK, F_TINT_MASK );
	StaticCombo( S_SELF_ILLUM, F_SELF_ILLUM );
	StaticCombo( S_SHADER_QUALITY, 0..1 );
	StaticComboRule( Allow1( S_DECAL_TEXTURE, S_FORCE_UV2 ) );
	StaticComboRule( Requires( S_MODE_TOOLS_VIS, S_SHADER_QUALITY ) );
	StaticComboRule( Allow1( S_ALPHA_TEST, S_TRANSLUCENT ) );
	StaticComboRule( Requires( S_ADDITIVE_BLEND, S_TRANSLUCENT ) );
	StaticComboRule( Requires( S_SPECULAR_DIRECT, S_SPECULAR_INDIRECT ) );
	StaticComboRule( Allow1( S_DETAIL_TEXTURE, S_ADDITIVE_BLEND ) );
	DynamicCombo( D_BAKED_LIGHTING_FROM_VERTEX_STREAM, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_PROBE, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_LIGHTMAP, 0..1 );
	DynamicCombo( D_SPECULAR_CUBE_MAP_STATIC, 0..1 );
	DynamicCombo( D_OPAQUE_FADE, 0..1 );
	DynamicCombo( D_MBOIT_PASS1, 0..1 );
	DynamicCombo( D_MBOIT_PASS2, 0..1 );
	DynamicCombo( D_MBOIT_4_MOMENTS, 0..1 );
	DynamicComboRule( Allow1( D_BAKED_LIGHTING_FROM_PROBE, D_BAKED_LIGHTING_FROM_VERTEX_STREAM, D_BAKED_LIGHTING_FROM_LIGHTMAP ) );
	DynamicComboRule( Requires( D_SPECULAR_CUBE_MAP_STATIC, S_SPECULAR_INDIRECT, S_MODE_TOOLS_VIS ) );
	DynamicComboRule( Allow1( S_ALPHA_TEST, S_TRANSLUCENT, D_OPAQUE_FADE ) );
	DynamicComboRule( Allow1( D_MBOIT_PASS1, D_MBOIT_PASS2 ) );
	DynamicComboRule( Requires( D_MBOIT_PASS1, S_TRANSLUCENT ) );
	DynamicComboRule( Requires( D_MBOIT_PASS2, S_TRANSLUCENT ) );
	DynamicComboRule( Requires( D_MBOIT_4_MOMENTS, D_MBOIT_PASS1, D_MBOIT_PASS2 ) );
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
	bool g_bDontFlipBackfaceNormals < UiType(CheckBox); Expression(F_DONT_FLIP_BACKFACE_NORMALS || 0); >;
	bool g_bHighlightDeprecated < Attribute("g_bHighlightDeprecated"); UiType(CheckBox); >;
	bool g_bIsDeprecated < Attribute("bIsDeprecated"); UiType(CheckBox); >;
	bool g_bRenderBackfaceNormals < UiType(CheckBox); Expression((F_RENDER_BACKFACES && 1) || 0); >;
	bool g_bRenderingToCubemaps < Attribute("g_bRenderingToCubemaps"); UiType(CheckBox); >;
	bool g_bShowLPVVoxels < Attribute("g_bShowLPVVoxels"); UiType(CheckBox); >;
	bool g_bShowLightmapTexels < Attribute("g_bShowLightmapTexels"); UiType(CheckBox); >;
	float g_fToolsVisHeightTint < Default(0.9); Attribute("g_fToolsVisHeightTint"); UiType(Slider); >;
	float g_fToolsVisMaxHeightRange < Default(1); Attribute("g_fToolsVisMaxHeightRange"); UiType(Slider); >;
	float g_fToolsVisMaxLightingComplexity < Default(8); Attribute("g_fToolsVisMaxLightingComplexity"); UiType(Slider); >;
	float g_flInverseBlendTint < UiType(Slider); Expression(F_NOTINT ? -1 : (1-(F_TINT_MASK || 0))); >;
	float g_flReflectance < UiType(Slider); Expression(pow((1.5-1)/(1.5+1),2)); >;
	ExternalDescriptorSet g_globalLateBoundBindlessSet < Source(ExternalDescSet); Attribute("g_globalLateBoundBindlessSet"); >;
	ExternalDescriptorSet g_lightBinnerGpuSet < Source(ExternalDescSet); Attribute("g_lightBinnerGpuSet"); >;
	int g_nDecalBlendMode < UiType(Slider); Expression(F_DECAL_BLEND_MODE || 0); >;
	int g_nToolsVisMode < Attribute("g_nToolsVisMode"); UiType(Slider); >;
	Texture2D g_tAmbientOcclusion < Channel(R, Box3(TextureAmbientOcclusion), Linear); OutputFormat(ATI1N); SrgbRead(false); >;
	Texture2D g_tColor < Channel(RGB, ArtistDefined(TextureColor), Srgb); OutputFormat(DXT1); SrgbRead(true); >;
	Texture2D g_tColor < Channel(RGB, ArtistDefinedOrAlphaWeighted(TextureColor, TextureTranslucency), Srgb); Channel(A, PreserveCoverage(TextureTranslucency), Linear); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tColor < Channel(RGB, ArtistDefinedOrAlphaWeighted(TextureColor, TextureTranslucency), Srgb); Channel(A, Box(TextureTranslucency), Linear); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tDecal < Channel(RGB, ArtistDefinedOrAlphaWeighted(TextureDecal, TextureDecalTranslucency), Srgb); Channel(A, Box(TextureDecalTranslucency), Linear); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tDetail < Channel(RGB, ArtistDefined(TextureDetail), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tDetailMask < Channel(R, Box(TextureDetailMask), Linear); OutputFormat(ATI1N); SrgbRead(false); >;
	Texture2D g_tMetalness < Channel(G, Box(TextureMetalness), Linear); OutputFormat(DXT1); SrgbRead(false); >;
	Texture2D g_tNormal < Channel(RGBA, HemiOctIsoRoughness_RG_B(TextureNormal, TextureRoughness), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tSelfIllumMask < Channel(RGB, Box(TextureSelfIllumMask), Srgb); OutputFormat(DXT1); SrgbRead(true); >;
	Texture2D g_tTintMask < Channel(R, Box(TextureTintMask), Linear); OutputFormat(ATI1N); SrgbRead(false); >;
	float3 g_vFlatOverlayColor < Default2(1, 0); Attribute("FlatOverlayColor"); UiType(VectorText); >;
	float3 g_vSelfIllumTintScaled < UiType(VectorText); Expression((pow(2,g_flSelfIllumBrightness).x*g_flSelfIllumScale.x)*SrgbGammaToLinear(g_vSelfIllumTint.xyz)); >;
	float4 g_vShaderIDColor < Source(ShaderIDColor); UiType(VectorText); >;
	
	// Ambient Occlusion
	CreateInputTexture2D(TextureAmbientOcclusion, Linear, 8, "", "_ao", "Ambient Occlusion/10", Default4(1, 1, 1, 0));
	float g_flAmbientOcclusionScale < Range(0, 2); UiType(Slider); UiGroup("Ambient Occlusion/20"); >;
	
	// Color
	CreateInputTexture2D(TextureTintMask, Linear, 8, "", "_mask", "Color", Default4(1, 1, 1, 0));
	bool g_bUseSecondaryUvForTintMask < UiType(CheckBox); UiGroup("Color,101"); >;
	CreateInputTexture2D(TextureColor, Srgb, 8, "", "_color", "Color/10", Default4(1, 1, 1, 0));
	
	// Decal Texture
	bool g_bUseSecondaryUvForDecal < Default(1); UiType(CheckBox); UiGroup("Decal Texture, 180"); >;
	CreateInputTexture2D(TextureDecal, Srgb, 8, "", "_decal", "Decal Texture,70/10", Default4(1, 1, 1, 0));
	CreateInputTexture2D(TextureDecalTranslucency, Linear, 8, "", "_trans", "Decal Texture,70/10", Default4(1, 1, 1, 0));
	
	// Detail Texture
	bool g_bUseSecondaryUvForDetailMask < Default(1); UiType(CheckBox); UiGroup("Detail Texture, 180"); >;
	CreateInputTexture2D(TextureDetail, Linear, 8, "Mod2XCenter", "_detail", "Detail Texture,80/10", Default4(1, 1, 1, 1));
	float g_flDetailBlendFactor < Default(1); UiType(Slider); UiGroup("Detail Texture,80/20"); >;
	CreateInputTexture2D(TextureDetailMask, Linear, 8, "", "_detailmask", "Detail Texture,80/40", Default4(1, 1, 1, 1));
	float g_flDetailBlendToFull < UiType(Slider); UiGroup("Detail Texture,80/50"); >;
	
	// Lighting
	CreateInputTexture2D(TextureMetalness, Linear, 8, "", "_metal", "Lighting,30/Metalness,30/10", Default4(0, 0, 0, 0));
	CreateInputTexture2D(TextureRoughness, Linear, 8, "Inverse", "_rough", "Lighting,30/Roughness,20/10", Default4(0.5, 0.5, 0.5, 0));
	
	// Normal Map
	CreateInputTexture2D(TextureNormal, Linear, 8, "NormalizeNormals", "_normal", "Normal Map,20", Default4(0.5, 0.5, 1, 0));
	
	// Self Illum
	bool g_bUseSecondaryUvForSelfIllum < UiType(CheckBox); UiGroup("Self Illum,100"); >;
	float g_flSelfIllumBrightness < Range(-10, 10); UiType(Slider); UiGroup("Self Illum"); >;
	CreateInputTexture2D(TextureSelfIllumMask, Srgb, 8, "", "_selfillum", "Self Illum/10", Default4(0, 0, 0, 0));
	float3 g_vSelfIllumTint < Default3(1, 1, 1); UiType(Color); UiGroup("Self Illum/20"); >;
	float g_flSelfIllumScale < Default(1); UiType(Slider); UiGroup("Self Illum/30"); >;
	float2 g_vSelfIllumScrollSpeed < Range2(-10, -10, 10, 10); UiType(VectorText); UiGroup("Self Illum/40"); >;
	float g_flSelfIllumAlbedoFactor < Default(1); UiType(Slider); UiGroup("Self Illum/50"); >;
	
	// Translucent
	CreateInputTexture2D(TextureTranslucency, Linear, 8, "", "_trans", "Translucent,15", Default4(1, 1, 1, 0));
	float g_flAlphaTestReference < Default(0.5); Range(0.01, 0.99); UiType(Slider); UiGroup("Translucent"); >;
	float g_flAntiAliasedEdgeStrength < Default(1); UiType(Slider); UiGroup("Translucent"); >;
	float g_flOpacityScale < Default(1); UiType(Slider); UiGroup("Translucent"); >;
	
	// Fog
	bool g_bFogEnabled < Default(1); UiType(CheckBox); UiGroup("Fog"); >;
	
	// Texture Address Mode
	int g_nTextureAddressModeU < UiOption("RsTextureAddressMode_t"); UiType(Enum); UiGroup("Texture Address Mode"); >;
	int g_nTextureAddressModeV < UiOption("RsTextureAddressMode_t"); UiType(Enum); UiGroup("Texture Address Mode"); >;
	
	#if (S_ALPHA_TEST == 1)
		Texture2D g_tColor < Channel(RGB, ArtistDefinedOrAlphaWeighted(TextureColor, TextureTranslucency), Srgb); Channel(A, PreserveCoverage(TextureTranslucency), Linear); OutputFormat(BC7); SrgbRead(true); >;
	#endif
	#if (S_TRANSLUCENT == 1)
		Texture2D g_tColor < Channel(RGB, ArtistDefinedOrAlphaWeighted(TextureColor, TextureTranslucency), Srgb); Channel(A, Box(TextureTranslucency), Linear); OutputFormat(BC7); SrgbRead(true); >;
	#endif
	#if (S_ADDITIVE_BLEND == 1)
		Texture2D g_tColor < Channel(RGB, ArtistDefinedOrAlphaWeighted(TextureColor, TextureTranslucency), Srgb); Channel(A, Box(TextureTranslucency), Linear); OutputFormat(BC7); SrgbRead(true); >;
	#endif
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (32156 bytes), HLSL reflection with SPIRV-Cross by KhronosGroup
	
	struct _2620
	{
	    float4 _m0[3];
	};
	
	struct _2830
	{
	    float4 _m0[4];
	};
	
	struct _1023
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
	
	static float3 _4;
	static float4 _5;
	
	cbuffer _Globals_ : register(b0, space1)
	{
	    uint _Globals_1_g_sTrilinearWrap : packoffset(c0.z);
	    uint _Globals_1_g_sTrilinearClamp : packoffset(c0.w);
	    uint _Globals_1_g_sPointClamp : packoffset(c1);
	    uint _Globals_1_g_sUserConfig : packoffset(c1.w);
	    uint _Globals_1_g_sUserConfigAllowGlobalMipBias : packoffset(c2);
	    uint _Globals_1_g_sCookieSampler : packoffset(c2.z);
	    uint _Globals_1_g_tShadowDepthBufferCmpSampler : packoffset(c2.w);
	    int _Globals_1_g_bFogEnabled : packoffset(c3.y);
	    int _Globals_1_g_bDontFlipBackfaceNormals : packoffset(c3.z);
	    int _Globals_1_g_bRenderBackfaceNormals : packoffset(c3.w);
	    uint _Globals_1_g_tColor : packoffset(c7.w);
	    uint _Globals_1_g_tNormal : packoffset(c8);
	    uint _Globals_1_g_tAmbientOcclusion : packoffset(c8.w);
	    float _Globals_1_g_flAmbientOcclusionScale : packoffset(c9);
	    uint _Globals_1_g_tMetalness : packoffset(c9.y);
	    float _Globals_1_g_flInverseBlendTint : packoffset(c9.z);
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
	    column_major float4x4 PerViewConstantBufferCsgo_t_1_m7 : packoffset(c12);
	    float2 PerViewConstantBufferCsgo_t_1_m8 : packoffset(c16);
	    float PerViewConstantBufferCsgo_t_1_m9 : packoffset(c16.z);
	    float4 PerViewConstantBufferCsgo_t_1_m10 : packoffset(c23);
	    float4 PerViewConstantBufferCsgo_t_1_m11 : packoffset(c24);
	    float4 PerViewConstantBufferCsgo_t_1_m12 : packoffset(c25);
	    float4 PerViewConstantBufferCsgo_t_1_m13 : packoffset(c26);
	    float4 PerViewConstantBufferCsgo_t_1_m14 : packoffset(c27);
	    float4 PerViewConstantBufferCsgo_t_1_m15 : packoffset(c28);
	    column_major float4x4 PerViewConstantBufferCsgo_t_1_m16 : packoffset(c29);
	    float4 PerViewConstantBufferCsgo_t_1_m17 : packoffset(c33);
	    float4 PerViewConstantBufferCsgo_t_1_m18 : packoffset(c34);
	    float4 PerViewConstantBufferCsgo_t_1_m19 : packoffset(c35);
	};
	
	cbuffer PerViewLightingConstantBufferGpu_t : register(b0, space3)
	{
	    _2620 PerViewLightingConstantBufferGpu_t_1_m0 : packoffset(c7);
	    _2830 PerViewLightingConstantBufferGpu_t_1_m1 : packoffset(c11);
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
	    _1023 PerViewLightingConstantBufferGpu_t_1_m17 : packoffset(c1956);
	    _2830 PerViewLightingConstantBufferGpu_t_1_m18 : packoffset(c1988);
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
	SamplerState g_bindless_Sampler[2048] : register(s29, space4);
	SamplerComparisonState g_bindless_Sampler_1[2048] : register(s29, space4);
	Texture3D<float4> g_bindless_Texture3D_float4[65536] : register(t46, space4);
	TextureCube<float4> g_bindless_TextureCube_float4[65536] : register(t46, space4);
	
	static float4 gl_FragCoord;
	static bool gl_FrontFacing;
	static float2 input_0;
	static float3 input_1;
	static float3 input_2;
	static float4 input_3;
	static float4 input_4;
	static float4 input_5;
	static float4 output_0;
	
	struct PS_INPUT
	{
	    float2 input_0 : TEXCOORD0;
	    float3 input_1 : TEXCOORD1;
	    float3 input_2 : TEXCOORD2;
	    float4 input_3 : TEXCOORD3;
	    centroid float4 input_4 : TEXCOORD4;
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
	    bool _14874 = _Globals_1_g_bRenderBackfaceNormals != 0;
	    bool _12885;
	    if (_14874)
	    {
	        _12885 = _Globals_1_g_bDontFlipBackfaceNormals == 0;
	    }
	    else
	    {
	        _12885 = false;
	    }
	    float3 _10251;
	    [branch]
	    if (_12885)
	    {
	        _10251 = input_2.xyz * (gl_FrontFacing ? 1.0f : (-1.0f));
	    }
	    else
	    {
	        _10251 = input_2.xyz;
	    }
	    float3 _24347 = normalize(_10251);
	    float3 _10061 = input_1 + PerViewConstantBufferCsgo_t_1_m19.xyz;
	    float4 _19680 = g_bindless_Texture2D_float4[_Globals_1_g_tColor].Sample(g_bindless_Sampler[_Globals_1_g_sUserConfigAllowGlobalMipBias], input_3.xy);
	    float3 _13737 = _19680.xyz;
	    float4 _19068 = g_bindless_Texture2D_float4[_Globals_1_g_tAmbientOcclusion].Sample(g_bindless_Sampler[_Globals_1_g_sUserConfig], float2(input_3.zw).xy);
	    float _17476 = _19068.x;
	    float _21709;
	    if (_Globals_1_g_flAmbientOcclusionScale > 0.0f)
	    {
	        _21709 = min(lerp(1.0f, 2.0f * _17476, _Globals_1_g_flAmbientOcclusionScale), 1.0f);
	    }
	    else
	    {
	        _21709 = _17476;
	    }
	    float4 _19069 = g_bindless_Texture2D_float4[_Globals_1_g_tMetalness].Sample(g_bindless_Sampler[_Globals_1_g_sUserConfig], input_3.xy);
	    float4 _19372 = g_bindless_Texture2D_float4[_Globals_1_g_tNormal].Sample(g_bindless_Sampler[_Globals_1_g_sUserConfig], input_0.xy);
	    float _16000 = _19372.x;
	    float _19720 = _19372.y;
	    float _16783 = (_16000 + _19720) - 1.00392162799835205078125f;
	    float _11176 = _16000 - _19720;
	    float3 _8418 = normalize(float3(float2(_16783, _11176), (1.0f - abs(_16783)) - abs(_11176)));
	    bool _12886;
	    if (_14874)
	    {
	        _12886 = _Globals_1_g_bDontFlipBackfaceNormals == 0;
	    }
	    else
	    {
	        _12886 = false;
	    }
	    bool _24327;
	    if (_12886)
	    {
	        _24327 = !gl_FrontFacing;
	    }
	    else
	    {
	        _24327 = false;
	    }
	    float3 _12631 = input_2.xyz * (_24327 ? (-1.0f) : 1.0f);
	    float3 _14435 = cross(_12631.xyz, input_5.xyz) * ((input_5.w > 0.0f) ? 1.0f : (-1.0f));
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
	    float3 _14786 = normalize((((input_5.xyz * _20480.x).xyz + (_7424.xyz * _20480.y)).xyz + (_12631.xyz * _20480.z)).xyz);
	    float3 _7978 = -_24347;
	    float3 _24735 = _14786.xyz;
	    float4 _23875 = float4(_24735, 1.0f);
	    bool4 _24465 = bool4(PerViewConstantBufferCsgo_t_1_m0.x != int4(0, 0, 0, 0).x, PerViewConstantBufferCsgo_t_1_m0.y != int4(0, 0, 0, 0).y, PerViewConstantBufferCsgo_t_1_m0.z != int4(0, 0, 0, 0).z, PerViewConstantBufferCsgo_t_1_m0.w != int4(0, 0, 0, 0).w);
	    float _21710;
	    if (_24465.x)
	    {
	        float3 _11394 = _24347.xyz;
	        float2 _11087 = ((floor(_11408.xy * PerViewConstantBufferCsgo_t_1_m9) * PerViewConstantBufferCsgo_t_1_m8.xy) + (PerViewConstantBufferCsgo_t_1_m8.xy * 0.5f)).xy;
	        float4 _18418 = g_bindless_Texture2D_float4[PerViewConstantBufferCsgo_t_1_m5].GatherRed(g_bindless_Sampler[_Globals_1_g_sCookieSampler], _11087).xyzw - _11408.zzzz;
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
	        float4 _10010 = normalize(float4(PerViewLightingConstantBufferGpu_t_1_m2.x * mad(dot(_7978, normalize(float3(PerViewLightingConstantBufferGpu_t_1_m1._m0[0].xy, 0.25f))), 0.5f, 0.5f), PerViewLightingConstantBufferGpu_t_1_m2.y * mad(dot(_7978, normalize(float3(PerViewLightingConstantBufferGpu_t_1_m1._m0[1].xy, 0.25f))), 0.5f, 0.5f), PerViewLightingConstantBufferGpu_t_1_m2.z * mad(dot(_7978, normalize(float3(PerViewLightingConstantBufferGpu_t_1_m1._m0[2].xy, 0.25f))), 0.5f, 0.5f), PerViewLightingConstantBufferGpu_t_1_m2.w * mad(dot(_7978, normalize(float3(PerViewLightingConstantBufferGpu_t_1_m1._m0[3].xy, 0.25f))), 0.5f, 0.5f)));
	        float4 _13232 = max(float4(dot(PerViewLightingConstantBufferGpu_t_1_m1._m0[0].xyz, _11394), dot(PerViewLightingConstantBufferGpu_t_1_m1._m0[1].xyz, _11394), dot(PerViewLightingConstantBufferGpu_t_1_m1._m0[2].xyz, _11394), dot(PerViewLightingConstantBufferGpu_t_1_m1._m0[3].xyz, _11394)).xyzw, 0.0f.xxxx) * normalize(clamp(((_10010 - max(max(_10010.x, _10010.y), max(_10010.z, _10010.w)).xxxx) + 0.20000000298023223876953125f.xxxx) * 5.0f.xxxx, 0.0f.xxxx, 1.0f.xxxx));
	        _21710 = (1.0f / (dot(_13232, 1.0f.xxxx) + PerViewLightingConstantBufferGpu_t_1_m3.x)) * (PerViewLightingConstantBufferGpu_t_1_m3.x + dot(_13232, g_bindless_Texture2D_float4[PerViewConstantBufferCsgo_t_1_m4].SampleLevel(g_bindless_Sampler[_Globals_1_g_sPointClamp], (_11087 + float2(_13083.x ? PerViewConstantBufferCsgo_t_1_m8.xy.x : _23169.x, _13083.y ? PerViewConstantBufferCsgo_t_1_m8.xy.y : _23169.y).xy).xy, 0.0f)));
	    }
	    else
	    {
	        _21710 = 1.0f;
	    }
	    float _21711;
	    [branch]
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
	            float4 _18322 = mul(PerViewLightingConstantBufferGpu_t_1_m17._m0[_13039], float4(input_1.xyz, 1.0f));
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
	            float _18270 = g_bindless_Texture2D_float4[PerViewLightingConstantBufferGpu_t_1_m19].SampleCmpLevelZero(g_bindless_Sampler_1[_Globals_1_g_tShadowDepthBufferCmpSampler], _14975.xy, clamp(_14975.z + PerViewLightingConstantBufferGpu_t_1_m11, 0.0f, 1.0f));
	            float _12501;
	            [branch]
	            if (_13136 < 1.0f)
	            {
	                float _7934;
	                if (_10191 < (PerViewLightingConstantBufferGpu_t_1_m10 - 1))
	                {
	                    int _15335 = _10191 + 1;
	                    float4 _19671 = mul(PerViewLightingConstantBufferGpu_t_1_m17._m0[_15335], float4(input_1.xyz, 1.0f));
	                    float2 _20562 = (_19671.xy * PerViewLightingConstantBufferGpu_t_1_m18._m0[_15335].zw) + PerViewLightingConstantBufferGpu_t_1_m18._m0[_15335].xy;
	                    float3 _20489;
	                    _20489.x = _20562.x;
	                    _20489.y = _20562.y;
	                    _7934 = g_bindless_Texture2D_float4[PerViewLightingConstantBufferGpu_t_1_m19].SampleCmpLevelZero(g_bindless_Sampler_1[_Globals_1_g_tShadowDepthBufferCmpSampler], _20489.xy, clamp(_19671.z + PerViewLightingConstantBufferGpu_t_1_m11, 0.0f, 1.0f));
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
	    float3 _21712;
	    [branch]
	    if ((dot(PerViewLightingConstantBufferGpu_t_1_m8.xyz, _24735) * _21711) > 0.0f)
	    {
	        _21712 = PerViewLightingConstantBufferGpu_t_1_m4.xyz + (max(0.0f, dot(_14786.xyz, PerViewLightingConstantBufferGpu_t_1_m8.xyz)).xxx.xyz * (PerViewLightingConstantBufferGpu_t_1_m9.xyz * _21711).xyz);
	    }
	    else
	    {
	        _21712 = PerViewLightingConstantBufferGpu_t_1_m4.xyz;
	    }
	    bool4 _24466 = bool4(PerViewConstantBufferCsgo_t_1_m1.x != int4(0, 0, 0, 0).x, PerViewConstantBufferCsgo_t_1_m1.y != int4(0, 0, 0, 0).y, PerViewConstantBufferCsgo_t_1_m1.z != int4(0, 0, 0, 0).z, PerViewConstantBufferCsgo_t_1_m1.w != int4(0, 0, 0, 0).w);
	    bool _20060 = _24466.x;
	    float4 _19364;
	    if (_20060)
	    {
	        float4 _18621 = mul(PerViewConstantBufferCsgo_t_1_m7, float4(_10061.xyz, 1.0f).xyzw);
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
	    float3 _13155;
	    _13155 = _21712;
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
	                float4x4 _14097 = asfloat(uint4x4(g_BarnLights.Load(_12608 * 480 + 0), g_BarnLights.Load(_12608 * 480 + 16), g_BarnLights.Load(_12608 * 480 + 32), g_BarnLights.Load(_12608 * 480 + 48), g_BarnLights.Load(_12608 * 480 + 4), g_BarnLights.Load(_12608 * 480 + 20), g_BarnLights.Load(_12608 * 480 + 36), g_BarnLights.Load(_12608 * 480 + 52), g_BarnLights.Load(_12608 * 480 + 8), g_BarnLights.Load(_12608 * 480 + 24), g_BarnLights.Load(_12608 * 480 + 40), g_BarnLights.Load(_12608 * 480 + 56), g_BarnLights.Load(_12608 * 480 + 12), g_BarnLights.Load(_12608 * 480 + 28), g_BarnLights.Load(_12608 * 480 + 44), g_BarnLights.Load(_12608 * 480 + 60)));
	                float4 _24893 = mul(float4(input_1.xyz, 1.0f), _14097);
	                float3 _10521 = _24893.xyz / _24893.w.xxx;
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
	                    float4x3 _16509 = asfloat(uint4x3(g_BarnLights.Load(_12608 * 480 + 272), g_BarnLights.Load(_12608 * 480 + 288), g_BarnLights.Load(_12608 * 480 + 304), g_BarnLights.Load(_12608 * 480 + 276), g_BarnLights.Load(_12608 * 480 + 292), g_BarnLights.Load(_12608 * 480 + 308), g_BarnLights.Load(_12608 * 480 + 280), g_BarnLights.Load(_12608 * 480 + 296), g_BarnLights.Load(_12608 * 480 + 312), g_BarnLights.Load(_12608 * 480 + 284), g_BarnLights.Load(_12608 * 480 + 300), g_BarnLights.Load(_12608 * 480 + 316)));
	                    float3 _6368 = abs(mul(float4(input_1.xyz, 1.0f), _16509).xyz);
	                    _12887 = !all(bool3(_6368.x <= 1.0f.xxx.x, _6368.y <= 1.0f.xxx.y, _6368.z <= 1.0f.xxx.z));
	                }
	                if (_12887)
	                {
	                    _12504 = _13156;
	                    break;
	                }
	                float _23571 = 2.0f * asfloat(g_BarnLights.Load4(_12608 * 480 + 176)).y;
	                float _18492 = (2.0f * asfloat(g_BarnLights.Load4(_12608 * 480 + 176)).z) * asfloat(g_BarnLights.Load4(_12608 * 480 + 176)).z;
	                float _14805 = 2.0f * asfloat(g_BarnLights.Load4(_12608 * 480 + 176)).x;
	                float _9058 = _14805 * asfloat(g_BarnLights.Load4(_12608 * 480 + 176)).y;
	                float _17330 = 2.0f * asfloat(g_BarnLights.Load4(_12608 * 480 + 176)).w;
	                float _19825 = _17330 * asfloat(g_BarnLights.Load4(_12608 * 480 + 176)).z;
	                float3 _16268 = float3(_9058 - _19825, (1.0f - (_14805 * asfloat(g_BarnLights.Load4(_12608 * 480 + 176)).x)) - _18492, (_23571 * asfloat(g_BarnLights.Load4(_12608 * 480 + 176)).z) + (_17330 * asfloat(g_BarnLights.Load4(_12608 * 480 + 176)).x)) * asfloat(g_BarnLights.Load3(_12608 * 480 + 192)).z;
	                float _21316;
	                if (asfloat(g_BarnLights.Load4(_12608 * 480 + 144)).z > 0.0f)
	                {
	                    _21316 = min(1.0f, _21775 * asfloat(g_BarnLights.Load4(_12608 * 480 + 144)).z);
	                }
	                else
	                {
	                    _21316 = 1.0f;
	                }
	                float _19667;
	                if (asfloat(g_BarnLights.Load4(_12608 * 480 + 144)).w > 0.0f)
	                {
	                    _19667 = _21316 * min(1.0f, (1.0f - _21775) * asfloat(g_BarnLights.Load4(_12608 * 480 + 144)).w);
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
	                    _11633 = ((_19667 * (asfloat(g_BarnLights.Load4(_12608 * 480 + 128)).w / max(_18345, asfloat(g_BarnLights.Load4(_12608 * 480 + 128)).w))) * clamp(asfloat(g_BarnLights.Load4(_12608 * 480 + 144)).x + (asfloat(g_BarnLights.Load4(_12608 * 480 + 144)).y * _17647), 0.0f, 1.0f)) * clamp(asfloat(g_BarnLights.Load3(_12608 * 480 + 192)).x + (asfloat(g_BarnLights.Load3(_12608 * 480 + 192)).y * dot(float3((1.0f - (_23571 * asfloat(g_BarnLights.Load4(_12608 * 480 + 176)).y)) - _18492, _9058 + _19825, (_14805 * asfloat(g_BarnLights.Load4(_12608 * 480 + 176)).z) - (_17330 * asfloat(g_BarnLights.Load4(_12608 * 480 + 176)).y)), normalize(_10210))), 0.0f, 1.0f);
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
	                            float _15019 = _22154.y;
	                            float _23041 = (-0.5f) * asfloat(g_BarnLights.Load4(_12608 * 480 + 224)).z;
	                            float _11981 = (asfloat(g_BarnLights.Load4(_12608 * 480 + 224)).x * asfloat(g_BarnLights.Load4(_12608 * 480 + 224)).y) * pow(max(pow(asfloat(g_BarnLights.Load4(_12608 * 480 + 224)).y * _11473, _15266) + pow(asfloat(g_BarnLights.Load4(_12608 * 480 + 224)).x * _15019, _15266), 1.1754943508222875079687365372222e-38f), _23041);
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
	                        float3 _20491 = _14081;
	                        _20491.x = _20564.x;
	                        _20491.y = _20564.y;
	                        _12503 = _17828.xyz * g_bindless_Texture3D_float4[PerViewLightingConstantBufferGpu_t_1_m20].SampleLevel(g_bindless_Sampler[_Globals_1_g_sTrilinearWrap], _20491.xyz, 0.0f).xyz;
	                    }
	                    else
	                    {
	                        float3 _13791 = float3(mad(_22905.xy, float2(0.5f, -0.5f), 0.5f.xx), asfloat(g_BarnLights.Load4(_12608 * 480 + 160)).w);
	                        float2 _20563 = (_13791.xy * asfloat(g_BarnLights.Load4(_12608 * 480 + 224)).zw) + asfloat(g_BarnLights.Load4(_12608 * 480 + 224)).xy;
	                        float3 _20490 = _13791;
	                        _20490.x = _20563.x;
	                        _20490.y = _20563.y;
	                        _12503 = _17828.xyz * g_bindless_Texture3D_float4[PerViewLightingConstantBufferGpu_t_1_m20].SampleLevel(g_bindless_Sampler[_Globals_1_g_sCookieSampler], _20490.xyz, 0.0f).xyz;
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
	                    if ((g_BarnLights.Load(_12608 * 480 + 264) & 4u) != 0u)
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
	                    float3 _20482 = _21548.xyz * lerp(1.0f, g_bindless_Texture2D_float4[PerViewLightingConstantBufferGpu_t_1_m19].SampleCmpLevelZero(g_bindless_Sampler_1[_Globals_1_g_tShadowDepthBufferCmpSampler], float3(mad(_19629.xy, asfloat(g_BarnLights.Load4(_12608 * 480 + 208)).zw, asfloat(g_BarnLights.Load4(_12608 * 480 + 208)).xy), _19629.z).xy, clamp(_19629.z + PerViewLightingConstantBufferGpu_t_1_m11, 0.0f, 1.0f)), asfloat(g_BarnLights.Load(_12608 * 480 + 260)));
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
	    float3 _22686 = (_13155.xyz + (float3(dot(PerViewLightingConstantBufferGpu_t_1_m0._m0[0].xyzw, _23875), dot(PerViewLightingConstantBufferGpu_t_1_m0._m0[1].xyzw, _23875), dot(PerViewLightingConstantBufferGpu_t_1_m0._m0[2].xyzw, _23875)).xyz * (_21710 * _21709).xxx.xyz).xyz) * (lerp(_13737, _13737 * input_4.xyz, clamp(_19680.w + _Globals_1_g_flInverseBlendTint, 0.0f, 1.0f).xxx).xyz * (1.0f - _19069.y)).xyz;
	    float4 _11204 = float4(_22686, input_4.w);
	    _11204.x = _22686.x;
	    _11204.y = _22686.y;
	    _11204.z = _22686.z;
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
	            [branch]
	            if (_12888)
	            {
	                float2 _9342 = clamp(PerViewConstantBufferCsgo_t_1_m10.xy + (PerViewConstantBufferCsgo_t_1_m10.zw * float2(length(_21493), _10061.z)), 0.0f.xx, 1.0f.xx);
	                float _12872 = (pow(_9342.x, PerViewConstantBufferCsgo_t_1_m11.x) * pow(_9342.y, PerViewConstantBufferCsgo_t_1_m11.y)) * PerViewConstantBufferCsgo_t_1_m12.w;
	                _19340 = lerp(_11204.xyz, float4(PerViewConstantBufferCsgo_t_1_m12.xyz, _12872).xyz, _12872.xxx);
	                break;
	            }
	            _19340 = _11204.xyz;
	            break;
	        } while(false);
	        float4 _23944 = _11204;
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
	                _19341 = lerp(_23944.xyz, float4((g_bindless_TextureCube_float4[PerViewConstantBufferCsgo_t_1_m3].SampleLevel(g_bindless_Sampler[_Globals_1_g_sTrilinearClamp], normalize(mul(float4(_9057, 0.0f), PerViewConstantBufferCsgo_t_1_m16).xyz).xyz, PerViewConstantBufferCsgo_t_1_m15.w * clamp(1.0f - (_14602 * PerViewConstantBufferCsgo_t_1_m14.z), 0.0f, 1.0f)) * PerViewConstantBufferCsgo_t_1_m18.x).xyz, _8892).xyz, _8892.xxx);
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
	        _6805 = _11204;
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
	    input_5 = stage_input.input_5;
	    MainPs_inner();
	    PS_OUTPUT stage_output;
	    stage_output.output_0 = output_0;
	    return stage_output;
	}
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
	
	BoolAttribute(BindlessResources, true);
	BoolAttribute(NeedsLightProbe, true);
	BoolAttribute(DoNotCastShadows, F_DO_NOT_CAST_SHADOWS || 0);
	BoolAttribute(SupportsMappingDimensions, true);
	TextureAttribute(LightSim_DiffuseAlbedoTexture, g_tColor);
	TextureAttribute(RepresentativeTexture, g_tColor);
	BoolAttribute(renderbackfaces, F_RENDER_BACKFACES || 0);
	BoolAttribute(overlay, (F_TRANSLUCENT && F_DEPTH_BIAS) || 0);
	BoolAttribute(SupportsLightmapping, true);
	BoolAttribute(PerVertexLighting, true);
	FloatAttribute(OcclusionCullingBoundsScale, F_DEPTH_BIAS ? 1.3 : 1);
	
	#if (S_TINT_MASK == 0)
		TextureAttribute(LightSim_SelfIllumMaskTexture, g_tSelfIllumMask);
		Float3Attribute(LightSim_SelfIllumTint, g_vSelfIllumTint);
		FloatAttribute(LightSim_SelfIllumScale, g_flSelfIllumScale);
	#endif
	#if (S_SELF_ILLUM == 1)
		TextureAttribute(LightSim_SelfIllumMaskTexture, g_tSelfIllumMask);
		Float3Attribute(LightSim_SelfIllumTint, g_vSelfIllumTint);
		FloatAttribute(LightSim_SelfIllumScale, g_flSelfIllumScale);
	#endif
	#if (S_TINT_MASK == 1)
		TextureAttribute(LightSim_TintMaskTextureR, g_tTintMask);
	#endif
	#if (S_ALPHA_TEST == 1)
		BoolAttribute(alphatest, true);
		FloatAttribute(_dummyReferenceAlphaTestReferenceInMainShader, g_flAlphaTestReference);
		FloatAttribute(_dummyReferenceAntiAliasedEdgeStrengthReferenceInMainShader, g_flAntiAliasedEdgeStrength);
		BoolAttribute(NoZPrepass, true);
		BoolAttribute(AlphaTestZPrepass, true);
		TextureAttribute(LightSim_Opacity_A, g_tColor);
	#endif
	#if (S_ALPHA_TEST == 0)
		BoolAttribute(NoZPrepass, F_DISABLE_Z_PREPASS || 0);
	#endif
	#if (S_ADDITIVE_BLEND == 0)
		TextureAttribute(LightSim_SelfIllumMaskTexture, g_tSelfIllumMask);
		Float3Attribute(LightSim_SelfIllumTint, g_vSelfIllumTint);
		FloatAttribute(LightSim_SelfIllumScale, g_flSelfIllumScale);
	#endif
	#if (S_TRANSLUCENT == 0)
		TextureAttribute(LightSim_SelfIllumMaskTexture, g_tSelfIllumMask);
		Float3Attribute(LightSim_SelfIllumTint, g_vSelfIllumTint);
		FloatAttribute(LightSim_SelfIllumScale, g_flSelfIllumScale);
	#endif
	#if (S_MODE_TOOLS_VIS == 0)
		TextureAttribute(LightSim_SelfIllumMaskTexture, g_tSelfIllumMask);
		Float3Attribute(LightSim_SelfIllumTint, g_vSelfIllumTint);
		FloatAttribute(LightSim_SelfIllumScale, g_flSelfIllumScale);
	#endif
	#if (S_SELF_ILLUM == 0)
		TextureAttribute(LightSim_TintMaskTextureR, g_tTintMask);
	#endif
	#if (S_SPECULAR_INDIRECT == 1)
		BoolAttribute(environmentmapped, true);
		BoolAttribute(environmentmappeddynamic, true);
	#endif
	#if (S_SPECULAR_DIRECT == 1)
		BoolAttribute(environmentmapped, true);
		BoolAttribute(environmentmappeddynamic, true);
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
	#if (S_SPECULAR_DIRECT == 0)
		TextureAttribute(LightSim_SelfIllumMaskTexture, g_tSelfIllumMask);
		Float3Attribute(LightSim_SelfIllumTint, g_vSelfIllumTint);
		FloatAttribute(LightSim_SelfIllumScale, g_flSelfIllumScale);
	#endif
	#if (S_SPECULAR_INDIRECT == 0)
		TextureAttribute(LightSim_SelfIllumMaskTexture, g_tSelfIllumMask);
		Float3Attribute(LightSim_SelfIllumTint, g_vSelfIllumTint);
		FloatAttribute(LightSim_SelfIllumScale, g_flSelfIllumScale);
	#endif
	#if (S_MODE_TOOLS_VIS == 1)
		BoolAttribute(environmentmapped, true);
		BoolAttribute(environmentmappeddynamic, true);
	#endif
	
	// PSRS
	
	RenderState(BackStencilFunc, F_RENDER_BACKFACES ? 5 : 7);
	RenderState(BlendEnable, True);
	RenderState(BlendEnable0, True);
	RenderState(BlendEnable1, True);
	RenderState(BlendEnable2, True);
	RenderState(CullMode, F_RENDER_BACKFACES ? None : Front);
	RenderState(CullMode, F_RENDER_BACKFACES ? None : Back);
	RenderState(DepthBias, F_DEPTH_BIAS ? -64 : 0);
	RenderState(DepthBiasClamp, F_DEPTH_BIAS ? -.0005 : 0);
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
	RenderState(SlopeScaleDepthBias, F_DEPTH_BIAS ? -2 : 0);
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
		RenderState(DepthWriteEnable, False);
	#endif
	#if (S_TRANSLUCENT == 1)
		RenderState(CullMode, F_RENDER_BACKFACES ? None : Front);
		RenderState(CullMode, F_RENDER_BACKFACES ? None : Back);
		RenderState(DepthWriteEnable, False);
	#endif
	
	BoolAttribute(BindlessResources, true);
	
}

RTX
{
	StaticCombo( S_SPECULAR_DIRECT, F_SPECULAR_DIRECT );
	StaticCombo( S_SPECULAR_INDIRECT, F_SPECULAR_INDIRECT );
	StaticCombo( S_FORCE_UV2, F_FORCE_UV2 );
	StaticCombo( S_DECAL_TEXTURE, F_DECAL_TEXTURE );
	StaticCombo( S_DETAIL_TEXTURE, F_DETAIL_TEXTURE );
	StaticCombo( S_MODE_TOOLS_VIS, 0..1 );
	StaticCombo( S_SHADER_QUALITY, 0..1 );
	StaticCombo( S_ALPHA_TEST, F_ALPHA_TEST );
	StaticCombo( S_TRANSLUCENT, F_TRANSLUCENT );
	StaticCombo( S_ADDITIVE_BLEND, F_ADDITIVE_BLEND );
	StaticCombo( S_TINT_MASK, F_TINT_MASK );
	StaticCombo( S_SELF_ILLUM, F_SELF_ILLUM );
	StaticComboRule( Allow1( S_DECAL_TEXTURE, S_FORCE_UV2 ) );
	StaticComboRule( Requires( S_SHADER_QUALITY, S_MODE_TOOLS_VIS ) );
	StaticComboRule( Allow0( S_SPECULAR_DIRECT, S_SPECULAR_INDIRECT ) );
	StaticComboRule( Allow0( S_MODE_TOOLS_VIS, S_SHADER_QUALITY ) );
	StaticComboRule( Allow1( S_ALPHA_TEST, S_TRANSLUCENT ) );
	StaticComboRule( Requires( S_ADDITIVE_BLEND, S_TRANSLUCENT ) );
	StaticComboRule( Requires( S_SPECULAR_DIRECT, S_SPECULAR_INDIRECT ) );
	StaticComboRule( Allow1( S_DETAIL_TEXTURE, S_ADDITIVE_BLEND ) );
	DynamicCombo( D_COMPRESSED_NORMALS_AND_TANGENTS, 0..1 );
	DynamicCombo( D_CS_VERTEX_ANIMATION, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_VERTEX_STREAM, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_LIGHTMAP, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_PROBE, 0..1 );
	DynamicComboRule( Allow1( D_BAKED_LIGHTING_FROM_VERTEX_STREAM, D_BAKED_LIGHTING_FROM_LIGHTMAP ) );
	DynamicComboRule( Allow1( D_BAKED_LIGHTING_FROM_PROBE, D_BAKED_LIGHTING_FROM_VERTEX_STREAM, D_BAKED_LIGHTING_FROM_LIGHTMAP ) );
	DynamicComboRule( Allow0( D_BAKED_LIGHTING_FROM_PROBE, D_BAKED_LIGHTING_FROM_VERTEX_STREAM, D_BAKED_LIGHTING_FROM_LIGHTMAP ) );
	DynamicComboRule( Allow0( D_COMPRESSED_NORMALS_AND_TANGENTS, D_CS_VERTEX_ANIMATION ) );
	
	bool g_bDontFlipBackfaceNormals < UiType(CheckBox); Expression(F_DONT_FLIP_BACKFACE_NORMALS || 0); >;
	bool g_bRenderBackfaceNormals < UiType(CheckBox); Expression((F_RENDER_BACKFACES && 1) || 0); >;
	float g_flInverseBlendTint < UiType(Slider); Expression(F_NOTINT ? -1 : (1-(F_TINT_MASK || 0))); >;
	int g_nDecalBlendMode < UiType(Slider); Expression(F_DECAL_BLEND_MODE || 0); >;
	Texture2D g_tColor < Channel(RGB, ArtistDefined(TextureColor), Srgb); OutputFormat(DXT1); SrgbRead(true); >;
	Texture2D g_tColor < Channel(RGB, ArtistDefinedOrAlphaWeighted(TextureColor, TextureTranslucency), Srgb); Channel(A, PreserveCoverage(TextureTranslucency), Linear); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tColor < Channel(RGB, ArtistDefinedOrAlphaWeighted(TextureColor, TextureTranslucency), Srgb); Channel(A, Box(TextureTranslucency), Linear); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tDecal < Channel(RGB, ArtistDefinedOrAlphaWeighted(TextureDecal, TextureDecalTranslucency), Srgb); Channel(A, Box(TextureDecalTranslucency), Linear); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tDetail < Channel(RGB, ArtistDefined(TextureDetail), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tDetailMask < Channel(R, Box(TextureDetailMask), Linear); OutputFormat(ATI1N); SrgbRead(false); >;
	Texture2D g_tMetalness < Channel(G, Box(TextureMetalness), Linear); OutputFormat(DXT1); SrgbRead(false); >;
	Texture2D g_tNormal < Channel(RGBA, HemiOctIsoRoughness_RG_B(TextureNormal, TextureRoughness), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tSelfIllumMask < Channel(RGB, Box(TextureSelfIllumMask), Srgb); OutputFormat(DXT1); SrgbRead(true); >;
	Texture2D g_tTintMask < Channel(R, Box(TextureTintMask), Linear); OutputFormat(ATI1N); SrgbRead(false); >;
	float4 g_vDetailTexCoordXform < UiType(VectorText); Expression(v0 = (g_flDetailTexCoordRotation*3.1415927)/180;
		v1 = cos(v0);
		v2 = sin(v0);
		v3 = g_vDetailTexCoordScale;
		v3.xxy*float4(v1,-v2,v2,v1)); >;
	float4 g_vNormalTexCoordXform0 < UiType(VectorText); Expression(v0 = (g_flNormalTexCoordRotation*3.14159)/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v1*g_vNormalTexCoordScale.x,-v2*g_vNormalTexCoordScale.y,0,((g_vNormalTexCoordCenter.x+g_vNormalTexCoordOffset.x)+((v2*g_vNormalTexCoordScale.y)*g_vNormalTexCoordCenter.y))-((v1*g_vNormalTexCoordScale.x)*g_vNormalTexCoordCenter.x))); >;
	float4 g_vNormalTexCoordXform1 < UiType(VectorText); Expression(v0 = (g_flNormalTexCoordRotation*3.14159)/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v2*g_vNormalTexCoordScale.x,v1*g_vNormalTexCoordScale.y,0,((g_vNormalTexCoordCenter.y+g_vNormalTexCoordOffset.y)+((v2*g_vNormalTexCoordScale.x)*g_vNormalTexCoordCenter.x))-((v1*g_vNormalTexCoordScale.y)*g_vNormalTexCoordCenter.y))); >;
	float3 g_vSelfIllumTintScaled < UiType(VectorText); Expression((pow(2,g_flSelfIllumBrightness).x*g_flSelfIllumScale.x)*SrgbGammaToLinear(g_vSelfIllumTint.xyz)); >;
	float4 g_vTexCoordXform0 < UiType(VectorText); Expression(v0 = (g_flTexCoordRotation*3.1415927)/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v1*g_vTexCoordScale.x,-v2*g_vTexCoordScale.y,0,((g_vTexCoordCenter.x+g_vTexCoordOffset.x)+(v2*g_vTexCoordCenter.y))-(v1*g_vTexCoordCenter.x))); >;
	float4 g_vTexCoordXform1 < UiType(VectorText); Expression(v0 = (g_flTexCoordRotation*3.1415927)/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v2*g_vTexCoordScale.x,v1*g_vTexCoordScale.y,0,(g_vTexCoordCenter.y+g_vTexCoordOffset.y)-((v2*g_vTexCoordCenter.x)+(v1*g_vTexCoordCenter.y)))); >;
	
	// Color
	CreateInputTexture2D(TextureTintMask, Linear, 8, "", "_mask", "Color", Default4(1, 1, 1, 0));
	bool g_bUseSecondaryUvForTintMask < UiType(CheckBox); UiGroup("Color,101"); >;
	CreateInputTexture2D(TextureColor, Srgb, 8, "", "_color", "Color/10", Default4(1, 1, 1, 0));
	float3 g_vColorTint < Default3(1, 1, 1); UiType(Color); UiGroup("Color,10/20"); Expression(SrgbGammaToLinear(this)); >;
	float g_flModelTintAmount < Default(1); UiType(Slider); UiGroup("Color,10/30"); >;
	float2 g_vTexCoordCenter < Default2(0.5, 0.5); UiType(VectorText); UiGroup("Color/30"); >;
	float2 g_vTexCoordScale < Default2(1, 1); Range2(0, 0, 100, 100); UiType(VectorText); UiGroup("Color/40"); >;
	float g_flTexCoordRotation < Range(-360, 360); UiType(Slider); UiGroup("Color/50"); >;
	float2 g_vTexCoordOffset < Range2(-1, -1, 1, 1); UiType(VectorText); UiGroup("Color/60"); >;
	float2 g_vTexCoordScrollSpeed < Range2(-10, -10, 10, 10); UiType(VectorText); UiGroup("Color/70"); >;
	int g_nScaleTexCoordUByModelScaleAxis < Range4(0, 0, 0, 0, 3, 3, 3, 3); UiOptions("0=None,1=UV.u * model.x,2=UV.u * model.y,3=UV.u * model.z"); UiType(Enum); UiGroup("Color/80"); >;
	int g_nScaleTexCoordVByModelScaleAxis < Range4(0, 0, 0, 0, 3, 3, 3, 3); UiOptions("0=None,1=UV.v * model.x,2=UV.v * model.y,3=UV.v * model.z"); UiType(Enum); UiGroup("Color/90"); >;
	
	// Decal Texture
	bool g_bUseSecondaryUvForDecal < Default(1); UiType(CheckBox); UiGroup("Decal Texture, 180"); >;
	CreateInputTexture2D(TextureDecal, Srgb, 8, "", "_decal", "Decal Texture,70/10", Default4(1, 1, 1, 0));
	CreateInputTexture2D(TextureDecalTranslucency, Linear, 8, "", "_trans", "Decal Texture,70/10", Default4(1, 1, 1, 0));
	
	// Detail Texture
	bool g_bUseSecondaryUvForDetailMask < Default(1); UiType(CheckBox); UiGroup("Detail Texture, 180"); >;
	bool g_bUseSecondaryUvForDetailTexture < Default(1); UiType(CheckBox); UiGroup("Detail Texture, 170"); >;
	CreateInputTexture2D(TextureDetail, Linear, 8, "Mod2XCenter", "_detail", "Detail Texture,80/10", Default4(1, 1, 1, 1));
	float g_flDetailBlendFactor < Default(1); UiType(Slider); UiGroup("Detail Texture,80/20"); >;
	float2 g_vDetailTexCoordScale < Default2(1, 1); UiType(VectorText); UiGroup("Detail Texture,80/30"); >;
	float g_flDetailTexCoordRotation < Range(0, 360); UiType(Slider); UiGroup("Detail Texture,80/35"); >;
	CreateInputTexture2D(TextureDetailMask, Linear, 8, "", "_detailmask", "Detail Texture,80/40", Default4(1, 1, 1, 1));
	float2 g_vDetailTexCoordOffset < Range2(-1, -1, 1, 1); UiType(VectorText); UiGroup("Detail Texture,80/40"); Expression(v0 = (g_flDetailTexCoordRotation*3.1415927)/180;
		v1 = cos(v0);
		v2 = sin(v0);
		v3 = g_vDetailTexCoordScale;
		v4 = this;
		(((-.5*v3)*float2(v1-v2,v2+v1))+v4)+.5); >;
	float g_flDetailBlendToFull < UiType(Slider); UiGroup("Detail Texture,80/50"); >;
	
	// Lighting
	CreateInputTexture2D(TextureMetalness, Linear, 8, "", "_metal", "Lighting,30/Metalness,30/10", Default4(0, 0, 0, 0));
	CreateInputTexture2D(TextureRoughness, Linear, 8, "Inverse", "_rough", "Lighting,30/Roughness,20/10", Default4(0.5, 0.5, 0.5, 0));
	
	// Normal Map
	CreateInputTexture2D(TextureNormal, Linear, 8, "NormalizeNormals", "_normal", "Normal Map,20", Default4(0.5, 0.5, 1, 0));
	float g_flNormalTexCoordRotation < Range(-360, 360); UiType(Slider); UiGroup("Normal Map,50"); >;
	float2 g_vNormalTexCoordCenter < Default2(0.5, 0.5); UiType(VectorText); UiGroup("Normal Map,30"); >;
	float2 g_vNormalTexCoordOffset < Range2(-1, -1, 1, 1); UiType(VectorText); UiGroup("Normal Map,60"); >;
	float2 g_vNormalTexCoordScale < Default2(1, 1); Range2(0, 0, 100, 100); UiType(VectorText); UiGroup("Normal Map,40"); >;
	
	// Self Illum
	bool g_bUseSecondaryUvForSelfIllum < UiType(CheckBox); UiGroup("Self Illum,100"); >;
	float g_flSelfIllumBrightness < Range(-10, 10); UiType(Slider); UiGroup("Self Illum"); >;
	CreateInputTexture2D(TextureSelfIllumMask, Srgb, 8, "", "_selfillum", "Self Illum/10", Default4(0, 0, 0, 0));
	float3 g_vSelfIllumTint < Default3(1, 1, 1); UiType(Color); UiGroup("Self Illum/20"); >;
	float g_flSelfIllumScale < Default(1); UiType(Slider); UiGroup("Self Illum/30"); >;
	float2 g_vSelfIllumScrollSpeed < Range2(-10, -10, 10, 10); UiType(VectorText); UiGroup("Self Illum/40"); >;
	float g_flSelfIllumAlbedoFactor < Default(1); UiType(Slider); UiGroup("Self Illum/50"); >;
	
	// Translucent
	CreateInputTexture2D(TextureTranslucency, Linear, 8, "", "_trans", "Translucent,15", Default4(1, 1, 1, 0));
	float g_flAlphaTestReference < Default(0.5); Range(0.01, 0.99); UiType(Slider); UiGroup("Translucent"); >;
	float g_flAntiAliasedEdgeStrength < Default(1); UiType(Slider); UiGroup("Translucent"); >;
	float g_flOpacityScale < Default(1); UiType(Slider); UiGroup("Translucent"); >;
	
	// Texture Address Mode
	int g_nTextureAddressModeU < UiOption("RsTextureAddressMode_t"); UiType(Enum); UiGroup("Texture Address Mode"); >;
	int g_nTextureAddressModeV < UiOption("RsTextureAddressMode_t"); UiType(Enum); UiGroup("Texture Address Mode"); >;
	
	#if (S_ALPHA_TEST == 1)
		Texture2D g_tColor < Channel(RGB, ArtistDefinedOrAlphaWeighted(TextureColor, TextureTranslucency), Srgb); Channel(A, PreserveCoverage(TextureTranslucency), Linear); OutputFormat(BC7); SrgbRead(true); >;
	#endif
	#if (S_TRANSLUCENT == 1)
		Texture2D g_tColor < Channel(RGB, ArtistDefinedOrAlphaWeighted(TextureColor, TextureTranslucency), Srgb); Channel(A, Box(TextureTranslucency), Linear); OutputFormat(BC7); SrgbRead(true); >;
	#endif
	#if (S_ADDITIVE_BLEND == 1)
		Texture2D g_tColor < Channel(RGB, ArtistDefinedOrAlphaWeighted(TextureColor, TextureTranslucency), Srgb); Channel(A, Box(TextureTranslucency), Linear); OutputFormat(BC7); SrgbRead(true); >;
	#endif
	
	// SPIR-V reflection failed for backend HLSL:
	// Unsupported builtin in HLSL: 5326
	//
	// Re-attempting reflection with the GLSL backend.
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (63292 bytes), GLSL reflection with SPIRV-Cross by KhronosGroup
	
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
	    vec3 vNormalOs;
	    vec4 vTangentUOs_flTangentVSign;
	    uvec4 vBlendIndices;
	    uint nInstanceIdx;
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
	    uint _member0[];
	} g_MaterialData_5;
	
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
	    PackedRtxInstanceData_t_natural_logical _432;
	    _432.nSrgbColor = g_instanceBuffer._member0[uint(gl_InstanceID)].nSrgbColor;
	    _432.nTriangleGeometry = g_instanceBuffer._member0[uint(gl_InstanceID)].nTriangleGeometry;
	    _432.nMaterialData = g_instanceBuffer._member0[uint(gl_InstanceID)].nMaterialData;
	    _432.nMaterialFlags_nInstanceFlags = g_instanceBuffer._member0[uint(gl_InstanceID)].nMaterialFlags_nInstanceFlags;
	    _432.fEmissiveBoost = g_instanceBuffer._member0[uint(gl_InstanceID)].fEmissiveBoost;
	    _432.nInstanceFlags = g_instanceBuffer._member0[uint(gl_InstanceID)].nInstanceFlags;
	    _432._pad1 = g_instanceBuffer._member0[uint(gl_InstanceID)]._pad1;
	    _432._pad2 = g_instanceBuffer._member0[uint(gl_InstanceID)]._pad2;
	    uint _297 = _432.nMaterialData;
	    vec4 _341 = vec4(g_MaterialData_1._member0[(_297 + 112u) / 4u], g_MaterialData_1._member0[(_297 + 116u) / 4u], g_MaterialData_1._member0[(_297 + 120u) / 4u], g_MaterialData_1._member0[(_297 + 124u) / 4u]);
	    vec4 _340 = vec4(g_MaterialData_1._member0[(_297 + 128u) / 4u], g_MaterialData_1._member0[(_297 + 132u) / 4u], g_MaterialData_1._member0[(_297 + 136u) / 4u], g_MaterialData_1._member0[(_297 + 140u) / 4u]);
	    vec2 _339 = vec2(g_MaterialData_1._member0[(_297 + 144u) / 4u], g_MaterialData_1._member0[(_297 + 148u) / 4u]);
	    vec3 _338 = vec3(g_MaterialData_1._member0[(_297 + 208u) / 4u], g_MaterialData_1._member0[(_297 + 212u) / 4u], g_MaterialData_1._member0[(_297 + 216u) / 4u]);
	    float _337 = g_MaterialData_1._member0[(_297 + 220u) / 4u];
	    vec4 _336 = vec4(g_MaterialData_1._member0[(_297 + 272u) / 4u], g_MaterialData_1._member0[(_297 + 276u) / 4u], g_MaterialData_1._member0[(_297 + 280u) / 4u], g_MaterialData_1._member0[(_297 + 284u) / 4u]);
	    vec4 _335 = vec4(g_MaterialData_1._member0[(_297 + 288u) / 4u], g_MaterialData_1._member0[(_297 + 292u) / 4u], g_MaterialData_1._member0[(_297 + 296u) / 4u], g_MaterialData_1._member0[(_297 + 300u) / 4u]);
	    bool _334 = g_MaterialData_3._member0[(_297 + 308u) / 4u] != 0;
	    bool _333 = g_MaterialData_3._member0[(_297 + 312u) / 4u] != 0;
	    uint _332 = g_MaterialData_5._member0[(_297 + 348u) / 4u];
	    uint _331 = g_MaterialData_5._member0[(_297 + 352u) / 4u];
	    uint _330 = g_MaterialData_5._member0[(_297 + 356u) / 4u];
	    uint _329 = g_MaterialData_5._member0[(_297 + 360u) / 4u];
	    uint _328 = g_MaterialData_5._member0[(_297 + 380u) / 4u];
	    float _327 = g_MaterialData_1._member0[(_297 + 384u) / 4u];
	    uvec3 _427;
	    do
	    {
	        if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes.w == 4)
	        {
	            uint _612 = (12u * uint(gl_PrimitiveID)) + uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes.w);
	            _427 = uvec3(g_Indices_1[g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._member0[_612 / 4u], g_Indices_1[g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._member0[(_612 + 4u) / 4u], g_Indices_1[g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._member0[(_612 + 8u) / 4u]);
	            break;
	        }
	        else
	        {
	            uint _585 = (6u * uint(gl_PrimitiveID)) + uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes.w);
	            uint _586 = _585 & 4294967292u;
	            uint _587 = _586 / 4u;
	            uint _591 = (_586 + 4u) / 4u;
	            uint _596 = (g_Indices_1[g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._member0[_587] & 4294901760u) >> uint(16);
	            uint _597 = g_Indices_1[g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._member0[_591] & 65535u;
	            uvec3 _428;
	            if (_585 == _586)
	            {
	                _428 = uvec3(g_Indices_1[g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._member0[_587] & 65535u, _596, _597);
	            }
	            else
	            {
	                _428 = uvec3(_596, _597, (g_Indices_1[g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._member0[_591] & 4294901760u) >> uint(16));
	            }
	            _427 = _428;
	            break;
	        }
	        break;
	    } while(false);
	    uint _60 = uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.x);
	    uvec3 _643 = (uvec3(uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes.x)) * _427) + uvec3(uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes.x));
	    vec3 _422[3];
	    uint _645 = _643.x;
	    _422[0] = vec3(g_Vertices_1[_60]._member0[_645 / 4u], g_Vertices_1[_60]._member0[(_645 + 4u) / 4u], g_Vertices_1[_60]._member0[(_645 + 8u) / 4u]);
	    uint _659 = _643.y;
	    _422[1] = vec3(g_Vertices_1[_60]._member0[_659 / 4u], g_Vertices_1[_60]._member0[(_659 + 4u) / 4u], g_Vertices_1[_60]._member0[(_659 + 8u) / 4u]);
	    uint _673 = _643.z;
	    _422[2] = vec3(g_Vertices_1[_60]._member0[_673 / 4u], g_Vertices_1[_60]._member0[(_673 + 4u) / 4u], g_Vertices_1[_60]._member0[(_673 + 8u) / 4u]);
	    int _423 = 0;
	    VS_INPUT vsInput[3];
	    for (;;)
	    {
	        if (!(_423 < 3))
	        {
	            break;
	        }
	        vsInput[_423].vPositionOs = _422[_423];
	        _423++;
	        continue;
	    }
	    vec2 _424[3];
	    _424[0] = vec2(0.0);
	    _424[1] = vec2(0.0);
	    _424[2] = vec2(0.0);
	    if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].y != 0)
	    {
	        ivec4 _421 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers;
	        uint _62 = uint(_421[g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].z]);
	        uint _724 = uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].z);
	        ivec4 _419 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes;
	        ivec4 _420 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes;
	        uvec3 _740 = (uvec3(uint(_419[_724])) * _427) + uvec3(uint(_420[_724]) + uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].x));
	        if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].y == 16)
	        {
	            uint _872 = _740.x;
	            _424[0] = vec2(g_Vertices_1[_62]._member0[_872 / 4u], g_Vertices_1[_62]._member0[(_872 + 4u) / 4u]);
	            uint _881 = _740.y;
	            _424[1] = vec2(g_Vertices_1[_62]._member0[_881 / 4u], g_Vertices_1[_62]._member0[(_881 + 4u) / 4u]);
	            uint _890 = _740.z;
	            _424[2] = vec2(g_Vertices_1[_62]._member0[_890 / 4u], g_Vertices_1[_62]._member0[(_890 + 4u) / 4u]);
	        }
	        else
	        {
	            if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].y == 34)
	            {
	                uint _843 = _740.x / 4u;
	                _424[0] = vec2(uint16BitsToFloat16(u16vec2(uvec2(g_Vertices_3[_62]._member0[_843], g_Vertices_3[_62]._member0[_843] >> uint(16)) & uvec2(65535u))));
	                uint _853 = _740.y / 4u;
	                _424[1] = vec2(uint16BitsToFloat16(u16vec2(uvec2(g_Vertices_3[_62]._member0[_853], g_Vertices_3[_62]._member0[_853] >> uint(16)) & uvec2(65535u))));
	                uint _863 = _740.z / 4u;
	                _424[2] = vec2(uint16BitsToFloat16(u16vec2(uvec2(g_Vertices_3[_62]._member0[_863], g_Vertices_3[_62]._member0[_863] >> uint(16)) & uvec2(65535u))));
	            }
	            else
	            {
	                if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].y == 37)
	                {
	                    uint _753 = _740.x / 4u;
	                    uint _756 = g_Vertices_3[_62]._member0[_753] & 65535u;
	                    int _418;
	                    if (_756 > 32767u)
	                    {
	                        _418 = int(4294901760u | _756);
	                    }
	                    else
	                    {
	                        _418 = int(_756);
	                    }
	                    uint _769 = (g_Vertices_3[_62]._member0[_753] & 4294901760u) >> uint(16);
	                    int _417;
	                    if (_769 > 32767u)
	                    {
	                        _417 = int(4294901760u | _769);
	                    }
	                    else
	                    {
	                        _417 = int(_769);
	                    }
	                    _424[0] = vec2(max(float(_418) * 3.0518509447574615478515625e-05, -1.0), max(float(_417) * 3.0518509447574615478515625e-05, -1.0));
	                    uint _783 = _740.y / 4u;
	                    uint _786 = g_Vertices_3[_62]._member0[_783] & 65535u;
	                    int _416;
	                    if (_786 > 32767u)
	                    {
	                        _416 = int(4294901760u | _786);
	                    }
	                    else
	                    {
	                        _416 = int(_786);
	                    }
	                    uint _799 = (g_Vertices_3[_62]._member0[_783] & 4294901760u) >> uint(16);
	                    int _415;
	                    if (_799 > 32767u)
	                    {
	                        _415 = int(4294901760u | _799);
	                    }
	                    else
	                    {
	                        _415 = int(_799);
	                    }
	                    _424[1] = vec2(max(float(_416) * 3.0518509447574615478515625e-05, -1.0), max(float(_415) * 3.0518509447574615478515625e-05, -1.0));
	                    uint _813 = _740.z / 4u;
	                    uint _816 = g_Vertices_3[_62]._member0[_813] & 65535u;
	                    int _414;
	                    if (_816 > 32767u)
	                    {
	                        _414 = int(4294901760u | _816);
	                    }
	                    else
	                    {
	                        _414 = int(_816);
	                    }
	                    uint _829 = (g_Vertices_3[_62]._member0[_813] & 4294901760u) >> uint(16);
	                    int _413;
	                    if (_829 > 32767u)
	                    {
	                        _413 = int(4294901760u | _829);
	                    }
	                    else
	                    {
	                        _413 = int(_829);
	                    }
	                    _424[2] = vec2(max(float(_414) * 3.0518509447574615478515625e-05, -1.0), max(float(_413) * 3.0518509447574615478515625e-05, -1.0));
	                }
	            }
	        }
	    }
	    _423 = 0;
	    for (;;)
	    {
	        if (!(_423 < 3))
	        {
	            break;
	        }
	        vsInput[_423].vTexCoord = _424[_423];
	        _423++;
	        continue;
	    }
	    vec3 _425[3];
	    vec4 _426[3];
	    do
	    {
	        if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.y != 0)
	        {
	            ivec4 _399 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers;
	            uint _66 = uint(_399[g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.z]);
	            uint _940 = uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.z);
	            ivec4 _397 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes;
	            ivec4 _398 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes;
	            uvec3 _956 = (uvec3(uint(_397[_940])) * _427) + uvec3(uint(_398[_940]) + uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.x));
	            if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.y == 6)
	            {
	                uint _1484 = _956.x;
	                _425[0] = vec3(g_Vertices_1[_66]._member0[_1484 / 4u], g_Vertices_1[_66]._member0[(_1484 + 4u) / 4u], g_Vertices_1[_66]._member0[(_1484 + 8u) / 4u]);
	                uint _1498 = _956.y;
	                _425[1] = vec3(g_Vertices_1[_66]._member0[_1498 / 4u], g_Vertices_1[_66]._member0[(_1498 + 4u) / 4u], g_Vertices_1[_66]._member0[(_1498 + 8u) / 4u]);
	                uint _1512 = _956.z;
	                _425[2] = vec3(g_Vertices_1[_66]._member0[_1512 / 4u], g_Vertices_1[_66]._member0[(_1512 + 4u) / 4u], g_Vertices_1[_66]._member0[(_1512 + 8u) / 4u]);
	            }
	            else
	            {
	                if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.y == 17)
	                {
	                    uint _1220 = _956.x;
	                    uvec2 _1228 = uvec2(g_Vertices_3[_66]._member0[_1220 / 4u], g_Vertices_3[_66]._member0[(_1220 + 4u) / 4u]);
	                    uint _1229 = _956.y;
	                    uvec2 _287 = uvec2(g_Vertices_3[_66]._member0[_1229 / 4u], g_Vertices_3[_66]._member0[(_1229 + 4u) / 4u]);
	                    uint _1238 = _956.z;
	                    uvec2 _286 = uvec2(g_Vertices_3[_66]._member0[_1238 / 4u], g_Vertices_3[_66]._member0[(_1238 + 4u) / 4u]);
	                    uint _1250 = _1228.x;
	                    uint _1258 = _1228.y;
	                    vec2 _1268 = ((vec2(float(_1250 & 65535u), float((_1250 >> 16u) & 65535u)) * vec2(1.525902189314365386962890625e-05)) * 2.0) - vec2(1.0);
	                    float _1269 = _1268.x;
	                    float _1274 = (1.0 - abs(_1269)) - abs(_1268.y);
	                    vec3 _1275 = vec3(_1269, _1268.y, _1274);
	                    float _1277 = saturate(-_1274);
	                    vec2 _1283 = _1268 + mix(vec2(_1277), vec2(-_1277), greaterThanEqual(_1268, vec2(0.0)));
	                    _1275.x = _1283.x;
	                    _1275.y = _1283.y;
	                    vec3 _401 = normalize(_1275);
	                    vec2 _1290 = ((vec2(float((_1258 >> uint(1)) & 32767u), float((_1258 >> 16u) & 32767u)) * vec2(3.0518509447574615478515625e-05)) * 2.0) - vec2(1.0);
	                    float _1291 = _1290.x;
	                    float _1296 = (1.0 - abs(_1291)) - abs(_1290.y);
	                    vec3 _1297 = vec3(_1291, _1290.y, _1296);
	                    float _1299 = saturate(-_1296);
	                    vec2 _1305 = _1290 + mix(vec2(_1299), vec2(-_1299), greaterThanEqual(_1290, vec2(0.0)));
	                    _1297.x = _1305.x;
	                    _1297.y = _1305.y;
	                    vec3 _400 = normalize(_1297);
	                    float _387;
	                    if ((_1258 & 1u) != 0u)
	                    {
	                        _387 = 1.0;
	                    }
	                    else
	                    {
	                        _387 = -1.0;
	                    }
	                    _425[0] = _401;
	                    _426[0].w = _387;
	                    _426[0].x = _400.x;
	                    _426[0].y = _400.y;
	                    _426[0].z = _400.z;
	                    vec2 _1347 = ((vec2(float(_287.x & 65535u), float((_287.x >> 16u) & 65535u)) * vec2(1.525902189314365386962890625e-05)) * 2.0) - vec2(1.0);
	                    float _1348 = _1347.x;
	                    float _1353 = (1.0 - abs(_1348)) - abs(_1347.y);
	                    vec3 _1354 = vec3(_1348, _1347.y, _1353);
	                    float _1356 = saturate(-_1353);
	                    vec2 _1362 = _1347 + mix(vec2(_1356), vec2(-_1356), greaterThanEqual(_1347, vec2(0.0)));
	                    _1354.x = _1362.x;
	                    _1354.y = _1362.y;
	                    vec3 _403 = normalize(_1354);
	                    vec2 _1369 = ((vec2(float((_287.y >> uint(1)) & 32767u), float((_287.y >> 16u) & 32767u)) * vec2(3.0518509447574615478515625e-05)) * 2.0) - vec2(1.0);
	                    float _1370 = _1369.x;
	                    float _1375 = (1.0 - abs(_1370)) - abs(_1369.y);
	                    vec3 _1376 = vec3(_1370, _1369.y, _1375);
	                    float _1378 = saturate(-_1375);
	                    vec2 _1384 = _1369 + mix(vec2(_1378), vec2(-_1378), greaterThanEqual(_1369, vec2(0.0)));
	                    _1376.x = _1384.x;
	                    _1376.y = _1384.y;
	                    vec3 _402 = normalize(_1376);
	                    float _386;
	                    if ((_287.y & 1u) != 0u)
	                    {
	                        _386 = 1.0;
	                    }
	                    else
	                    {
	                        _386 = -1.0;
	                    }
	                    _425[1] = _403;
	                    _426[1].w = _386;
	                    _426[1].x = _402.x;
	                    _426[1].y = _402.y;
	                    _426[1].z = _402.z;
	                    vec2 _1426 = ((vec2(float(_286.x & 65535u), float((_286.x >> 16u) & 65535u)) * vec2(1.525902189314365386962890625e-05)) * 2.0) - vec2(1.0);
	                    float _1427 = _1426.x;
	                    float _1432 = (1.0 - abs(_1427)) - abs(_1426.y);
	                    vec3 _1433 = vec3(_1427, _1426.y, _1432);
	                    float _1435 = saturate(-_1432);
	                    vec2 _1441 = _1426 + mix(vec2(_1435), vec2(-_1435), greaterThanEqual(_1426, vec2(0.0)));
	                    _1433.x = _1441.x;
	                    _1433.y = _1441.y;
	                    vec3 _405 = normalize(_1433);
	                    vec2 _1448 = ((vec2(float((_286.y >> uint(1)) & 32767u), float((_286.y >> 16u) & 32767u)) * vec2(3.0518509447574615478515625e-05)) * 2.0) - vec2(1.0);
	                    float _1449 = _1448.x;
	                    float _1454 = (1.0 - abs(_1449)) - abs(_1448.y);
	                    vec3 _1455 = vec3(_1449, _1448.y, _1454);
	                    float _1457 = saturate(-_1454);
	                    vec2 _1463 = _1448 + mix(vec2(_1457), vec2(-_1457), greaterThanEqual(_1448, vec2(0.0)));
	                    _1455.x = _1463.x;
	                    _1455.y = _1463.y;
	                    vec3 _404 = normalize(_1455);
	                    float _385;
	                    if ((_286.y & 1u) != 0u)
	                    {
	                        _385 = 1.0;
	                    }
	                    else
	                    {
	                        _385 = -1.0;
	                    }
	                    _425[2] = _405;
	                    _426[2].w = _385;
	                    _426[2].x = _404.x;
	                    _426[2].y = _404.y;
	                    _426[2].z = _404.z;
	                    break;
	                }
	                else
	                {
	                    uint _966 = _956.x / 4u;
	                    vec4 _407 = _426[0];
	                    float _981 = (float((g_Vertices_3[_66]._member0[_966] >> 12u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _984 = (float((g_Vertices_3[_66]._member0[_966] >> 22u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _988 = (1.0 - abs(_981)) - abs(_984);
	                    vec3 _989 = vec3(_981, _984, _988);
	                    float _991 = saturate(-_988);
	                    vec2 _992 = vec2(_981, _984);
	                    vec2 _998 = _992 + mix(vec2(_991), vec2(-_991), greaterThanEqual(_992, vec2(0.0)));
	                    _989.x = _998.x;
	                    _989.y = _998.y;
	                    vec3 _1003 = normalize(_989);
	                    vec3 _406 = _1003;
	                    float _1004 = _1003.z;
	                    float _394;
	                    if (_1004 >= 0.0)
	                    {
	                        _394 = 1.0;
	                    }
	                    else
	                    {
	                        _394 = -1.0;
	                    }
	                    float _1011 = (-1.0) / (_394 + _1004);
	                    float _1012 = _1003.x;
	                    vec3 _395;
	                    vec3 _1020 = _395;
	                    _1020.x = 1.0 + (((_394 * _1012) * _1012) * _1011);
	                    _1020.y = _394 * ((_1012 * _1003.y) * _1011);
	                    _1020.z = (-_394) * _1012;
	                    _395 = _1020;
	                    float _1028 = float((g_Vertices_3[_66]._member0[_966] >> uint(1)) & 2047u) * 0.003069460391998291015625;
	                    vec3 _1034 = (_1020 * cos(_1028)) + (cross(_1003, _1020) * sin(_1028));
	                    vec4 _1036 = _407;
	                    _1036.x = _1034.x;
	                    _1036.y = _1034.y;
	                    _1036.z = _1034.z;
	                    _407 = _1036;
	                    float _396;
	                    if ((g_Vertices_3[_66]._member0[_966] & 1u) == 0u)
	                    {
	                        _396 = -1.0;
	                    }
	                    else
	                    {
	                        _396 = 1.0;
	                    }
	                    vec4 _1047 = _407;
	                    _1047.w = _396;
	                    _407 = _1047;
	                    _425[0] = _406;
	                    _426[0] = _1047;
	                    uint _1051 = _956.y / 4u;
	                    vec4 _409 = _426[1];
	                    float _1066 = (float((g_Vertices_3[_66]._member0[_1051] >> 12u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _1069 = (float((g_Vertices_3[_66]._member0[_1051] >> 22u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _1073 = (1.0 - abs(_1066)) - abs(_1069);
	                    vec3 _1074 = vec3(_1066, _1069, _1073);
	                    float _1076 = saturate(-_1073);
	                    vec2 _1077 = vec2(_1066, _1069);
	                    vec2 _1083 = _1077 + mix(vec2(_1076), vec2(-_1076), greaterThanEqual(_1077, vec2(0.0)));
	                    _1074.x = _1083.x;
	                    _1074.y = _1083.y;
	                    vec3 _1088 = normalize(_1074);
	                    vec3 _408 = _1088;
	                    float _1089 = _1088.z;
	                    float _391;
	                    if (_1089 >= 0.0)
	                    {
	                        _391 = 1.0;
	                    }
	                    else
	                    {
	                        _391 = -1.0;
	                    }
	                    float _1096 = (-1.0) / (_391 + _1089);
	                    float _1097 = _1088.x;
	                    vec3 _392;
	                    vec3 _1105 = _392;
	                    _1105.x = 1.0 + (((_391 * _1097) * _1097) * _1096);
	                    _1105.y = _391 * ((_1097 * _1088.y) * _1096);
	                    _1105.z = (-_391) * _1097;
	                    _392 = _1105;
	                    float _1113 = float((g_Vertices_3[_66]._member0[_1051] >> uint(1)) & 2047u) * 0.003069460391998291015625;
	                    vec3 _1119 = (_1105 * cos(_1113)) + (cross(_1088, _1105) * sin(_1113));
	                    vec4 _1121 = _409;
	                    _1121.x = _1119.x;
	                    _1121.y = _1119.y;
	                    _1121.z = _1119.z;
	                    _409 = _1121;
	                    float _393;
	                    if ((g_Vertices_3[_66]._member0[_1051] & 1u) == 0u)
	                    {
	                        _393 = -1.0;
	                    }
	                    else
	                    {
	                        _393 = 1.0;
	                    }
	                    vec4 _1132 = _409;
	                    _1132.w = _393;
	                    _409 = _1132;
	                    _425[1] = _408;
	                    _426[1] = _1132;
	                    uint _1136 = _956.z / 4u;
	                    vec4 _411 = _426[2];
	                    float _1151 = (float((g_Vertices_3[_66]._member0[_1136] >> 12u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _1154 = (float((g_Vertices_3[_66]._member0[_1136] >> 22u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _1158 = (1.0 - abs(_1151)) - abs(_1154);
	                    vec3 _1159 = vec3(_1151, _1154, _1158);
	                    float _1161 = saturate(-_1158);
	                    vec2 _1162 = vec2(_1151, _1154);
	                    vec2 _1168 = _1162 + mix(vec2(_1161), vec2(-_1161), greaterThanEqual(_1162, vec2(0.0)));
	                    _1159.x = _1168.x;
	                    _1159.y = _1168.y;
	                    vec3 _1173 = normalize(_1159);
	                    vec3 _410 = _1173;
	                    float _1174 = _1173.z;
	                    float _388;
	                    if (_1174 >= 0.0)
	                    {
	                        _388 = 1.0;
	                    }
	                    else
	                    {
	                        _388 = -1.0;
	                    }
	                    float _1181 = (-1.0) / (_388 + _1174);
	                    float _1182 = _1173.x;
	                    vec3 _389;
	                    vec3 _1190 = _389;
	                    _1190.x = 1.0 + (((_388 * _1182) * _1182) * _1181);
	                    _1190.y = _388 * ((_1182 * _1173.y) * _1181);
	                    _1190.z = (-_388) * _1182;
	                    _389 = _1190;
	                    float _1198 = float((g_Vertices_3[_66]._member0[_1136] >> uint(1)) & 2047u) * 0.003069460391998291015625;
	                    vec3 _1204 = (_1190 * cos(_1198)) + (cross(_1173, _1190) * sin(_1198));
	                    vec4 _1206 = _411;
	                    _1206.x = _1204.x;
	                    _1206.y = _1204.y;
	                    _1206.z = _1204.z;
	                    _411 = _1206;
	                    float _390;
	                    if ((g_Vertices_3[_66]._member0[_1136] & 1u) == 0u)
	                    {
	                        _390 = -1.0;
	                    }
	                    else
	                    {
	                        _390 = 1.0;
	                    }
	                    vec4 _1217 = _411;
	                    _1217.w = _390;
	                    _411 = _1217;
	                    _425[2] = _410;
	                    _426[2] = _1217;
	                    break;
	                }
	                break;
	            }
	        }
	        else
	        {
	            _425[0] = vec3(0.0);
	            _425[1] = vec3(0.0);
	            _425[2] = vec3(0.0);
	        }
	        if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTangentFieldInfo.y != 0)
	        {
	            ivec4 _412 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers;
	            uint _70 = uint(_412[g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTangentFieldInfo.z]);
	            uint _1540 = uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTangentFieldInfo.z);
	            ivec4 _383 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes;
	            ivec4 _384 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes;
	            uvec3 _1556 = (uvec3(uint(_383[_1540])) * _427) + uvec3(uint(_384[_1540]) + uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTangentFieldInfo.x));
	            uint _1558 = _1556.x;
	            _426[0] = vec4(g_Vertices_1[_70]._member0[_1558 / 4u], g_Vertices_1[_70]._member0[(_1558 + 4u) / 4u], g_Vertices_1[_70]._member0[(_1558 + 8u) / 4u], g_Vertices_1[_70]._member0[(_1558 + 12u) / 4u]);
	            uint _1576 = _1556.y;
	            _426[1] = vec4(g_Vertices_1[_70]._member0[_1576 / 4u], g_Vertices_1[_70]._member0[(_1576 + 4u) / 4u], g_Vertices_1[_70]._member0[(_1576 + 8u) / 4u], g_Vertices_1[_70]._member0[(_1576 + 12u) / 4u]);
	            uint _1594 = _1556.z;
	            _426[2] = vec4(g_Vertices_1[_70]._member0[_1594 / 4u], g_Vertices_1[_70]._member0[(_1594 + 4u) / 4u], g_Vertices_1[_70]._member0[(_1594 + 8u) / 4u], g_Vertices_1[_70]._member0[(_1594 + 12u) / 4u]);
	        }
	        else
	        {
	            _426[0] = vec4(0.0);
	            _426[1] = vec4(0.0);
	            _426[2] = vec4(0.0);
	        }
	        break;
	    } while(false);
	    _423 = 0;
	    for (;;)
	    {
	        if (!(_423 < 3))
	        {
	            break;
	        }
	        vsInput[_423].vNormalOs = _425[_423];
	        vsInput[_423].vTangentUOs_flTangentVSign = _426[_423];
	        _423++;
	        continue;
	    }
	    vec2 _296 = vsInput[0].vTexCoord;
	    vec3 _381 = vsInput[0].vNormalOs;
	    vec4 _382;
	    vec4 _1640 = _382;
	    _1640.x = vsInput[0].vTangentUOs_flTangentVSign.x;
	    _1640.y = vsInput[0].vTangentUOs_flTangentVSign.y;
	    _1640.z = vsInput[0].vTangentUOs_flTangentVSign.z;
	    _1640.w = vsInput[0].vTangentUOs_flTangentVSign.w;
	    _382 = _1640;
	    PackedRtxInstanceData_t_natural_logical _1653;
	    _1653.nSrgbColor = g_instanceBuffer._member0[uint(gl_InstanceID)].nSrgbColor;
	    _1653.nTriangleGeometry = g_instanceBuffer._member0[uint(gl_InstanceID)].nTriangleGeometry;
	    _1653.nMaterialData = g_instanceBuffer._member0[uint(gl_InstanceID)].nMaterialData;
	    _1653.nMaterialFlags_nInstanceFlags = g_instanceBuffer._member0[uint(gl_InstanceID)].nMaterialFlags_nInstanceFlags;
	    _1653.fEmissiveBoost = g_instanceBuffer._member0[uint(gl_InstanceID)].fEmissiveBoost;
	    _1653.nInstanceFlags = g_instanceBuffer._member0[uint(gl_InstanceID)].nInstanceFlags;
	    _1653._pad1 = g_instanceBuffer._member0[uint(gl_InstanceID)]._pad1;
	    _1653._pad2 = g_instanceBuffer._member0[uint(gl_InstanceID)]._pad2;
	    vec4 _1664 = vec4(uvec4(_1653.nSrgbColor & 255u, (_1653.nSrgbColor & 65280u) >> uint(8), (_1653.nSrgbColor & 16711680u) >> uint(16), (_1653.nSrgbColor & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	    vec4 _380 = _1664;
	    vec3 _1665 = _1664.xyz;
	    vec3 _1666 = _1665 * vec3(0.077399380505084991455078125);
	    vec3 _1669 = pow((_1665 * vec3(0.947867333889007568359375)) + vec3(0.052132703363895416259765625), vec3(2.400000095367431640625));
	    float _377;
	    if (_1664.x <= 0.040449999272823333740234375)
	    {
	        _377 = _1666.x;
	    }
	    else
	    {
	        _377 = _1669.x;
	    }
	    float _378;
	    if (_1664.y <= 0.040449999272823333740234375)
	    {
	        _378 = _1666.y;
	    }
	    else
	    {
	        _378 = _1669.y;
	    }
	    float _379;
	    if (_1664.z <= 0.040449999272823333740234375)
	    {
	        _379 = _1666.z;
	    }
	    else
	    {
	        _379 = _1669.z;
	    }
	    vec3 _1694 = vec3(_377, _378, _379);
	    vec4 _1696 = _380;
	    _1696.x = _1694.x;
	    _1696.y = _1694.y;
	    _1696.z = _1694.z;
	    _380 = _1696;
	    vec4 _299;
	    vec4 _1703 = _299;
	    _1703.x = _1696.x;
	    _1703.y = _1696.y;
	    _1703.z = _1696.z;
	    _1703.w = _1696.w;
	    _299 = _1703;
	    mat3x4 _1714 = transpose(gl_WorldToObjectEXT);
	    mat3 _376;
	    mat3 _1717 = _376;
	    _1717[0] = _1714[0].xyz;
	    _1717[1] = _1714[1].xyz;
	    _1717[2] = _1714[2].xyz;
	    _376 = _1717;
	    vec3 _1726 = normalize(_1717 * _381.xyz);
	    vec3 _300;
	    vec3 _1728 = _300;
	    _1728.x = _1726.x;
	    _1728.y = _1726.y;
	    _1728.z = _1726.z;
	    _300 = _1728;
	    mat3x4 _1740 = transpose(gl_WorldToObjectEXT);
	    mat3 _375;
	    mat3 _1743 = _375;
	    _1743[0] = _1740[0].xyz;
	    _1743[1] = _1740[1].xyz;
	    _1743[2] = _1740[2].xyz;
	    _375 = _1743;
	    vec3 _1752 = normalize(_1743 * _382.xyz);
	    vec4 _298;
	    vec4 _1754 = _298;
	    _1754.x = _1752.x;
	    _1754.y = _1752.y;
	    _1754.z = _1752.z;
	    _1754.w = _382.w;
	    _298 = _1754;
	    vec4 _1763 = _296.xyxy;
	    vec2 _301;
	    vec2 _1764 = _301;
	    vec4 _1777 = _1763;
	    _1777.x = dot(_1763.xy, _341.xy) + _341.w;
	    _1777.y = dot(_1763.xy, _340.xy) + _340.w;
	    vec2 _1785 = _1777.xy + (_339.xy * PerViewConstantBuffer_t.g_flGameTime);
	    vec4 _1787 = _1777;
	    _1787.x = _1785.x;
	    _1787.y = _1785.y;
	    vec3 _1793 = mix(vec3(1.0), _1703.xyz, vec3(_337));
	    vec4 _1795 = _1703;
	    _1795.x = _1793.x;
	    _1795.y = _1793.y;
	    _1795.z = _1793.z;
	    vec3 _1803 = _1795.xyz * _338.xyz;
	    vec4 _1805 = _1795;
	    _1805.x = _1803.x;
	    _1805.y = _1803.y;
	    _1805.z = _1803.z;
	    _1764.x = dot(_296.xy, _336.xy) + _336.w;
	    _1764.y = dot(_296.xy, _335.xy) + _335.w;
	    vec2 _285 = _1764;
	    vec3 _284 = vec4(vsInput[0].vPositionOs.xyz, 1.0) * transpose(gl_ObjectToWorldEXT);
	    vec3 _283 = _1728;
	    vec4 _282 = _1787;
	    vec4 _281 = _1805;
	    vec4 _280 = _1754;
	    vec2 _295 = vsInput[1].vTexCoord;
	    vec3 _373 = vsInput[1].vNormalOs;
	    vec4 _374;
	    vec4 _1830 = _374;
	    _1830.x = vsInput[1].vTangentUOs_flTangentVSign.x;
	    _1830.y = vsInput[1].vTangentUOs_flTangentVSign.y;
	    _1830.z = vsInput[1].vTangentUOs_flTangentVSign.z;
	    _1830.w = vsInput[1].vTangentUOs_flTangentVSign.w;
	    _374 = _1830;
	    PackedRtxInstanceData_t_natural_logical _1843;
	    _1843.nSrgbColor = g_instanceBuffer._member0[uint(gl_InstanceID)].nSrgbColor;
	    _1843.nTriangleGeometry = g_instanceBuffer._member0[uint(gl_InstanceID)].nTriangleGeometry;
	    _1843.nMaterialData = g_instanceBuffer._member0[uint(gl_InstanceID)].nMaterialData;
	    _1843.nMaterialFlags_nInstanceFlags = g_instanceBuffer._member0[uint(gl_InstanceID)].nMaterialFlags_nInstanceFlags;
	    _1843.fEmissiveBoost = g_instanceBuffer._member0[uint(gl_InstanceID)].fEmissiveBoost;
	    _1843.nInstanceFlags = g_instanceBuffer._member0[uint(gl_InstanceID)].nInstanceFlags;
	    _1843._pad1 = g_instanceBuffer._member0[uint(gl_InstanceID)]._pad1;
	    _1843._pad2 = g_instanceBuffer._member0[uint(gl_InstanceID)]._pad2;
	    vec4 _1854 = vec4(uvec4(_1843.nSrgbColor & 255u, (_1843.nSrgbColor & 65280u) >> uint(8), (_1843.nSrgbColor & 16711680u) >> uint(16), (_1843.nSrgbColor & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	    vec4 _372 = _1854;
	    vec3 _1855 = _1854.xyz;
	    vec3 _1856 = _1855 * vec3(0.077399380505084991455078125);
	    vec3 _1859 = pow((_1855 * vec3(0.947867333889007568359375)) + vec3(0.052132703363895416259765625), vec3(2.400000095367431640625));
	    float _369;
	    if (_1854.x <= 0.040449999272823333740234375)
	    {
	        _369 = _1856.x;
	    }
	    else
	    {
	        _369 = _1859.x;
	    }
	    float _370;
	    if (_1854.y <= 0.040449999272823333740234375)
	    {
	        _370 = _1856.y;
	    }
	    else
	    {
	        _370 = _1859.y;
	    }
	    float _371;
	    if (_1854.z <= 0.040449999272823333740234375)
	    {
	        _371 = _1856.z;
	    }
	    else
	    {
	        _371 = _1859.z;
	    }
	    vec3 _1884 = vec3(_369, _370, _371);
	    vec4 _1886 = _372;
	    _1886.x = _1884.x;
	    _1886.y = _1884.y;
	    _1886.z = _1884.z;
	    _372 = _1886;
	    vec4 _303;
	    vec4 _1893 = _303;
	    _1893.x = _1886.x;
	    _1893.y = _1886.y;
	    _1893.z = _1886.z;
	    _1893.w = _1886.w;
	    _303 = _1893;
	    mat3x4 _1904 = transpose(gl_WorldToObjectEXT);
	    mat3 _368;
	    mat3 _1907 = _368;
	    _1907[0] = _1904[0].xyz;
	    _1907[1] = _1904[1].xyz;
	    _1907[2] = _1904[2].xyz;
	    _368 = _1907;
	    vec3 _1916 = normalize(_1907 * _373.xyz);
	    vec3 _304;
	    vec3 _1918 = _304;
	    _1918.x = _1916.x;
	    _1918.y = _1916.y;
	    _1918.z = _1916.z;
	    _304 = _1918;
	    mat3x4 _1930 = transpose(gl_WorldToObjectEXT);
	    mat3 _367;
	    mat3 _1933 = _367;
	    _1933[0] = _1930[0].xyz;
	    _1933[1] = _1930[1].xyz;
	    _1933[2] = _1930[2].xyz;
	    _367 = _1933;
	    vec3 _1942 = normalize(_1933 * _374.xyz);
	    vec4 _302;
	    vec4 _1944 = _302;
	    _1944.x = _1942.x;
	    _1944.y = _1942.y;
	    _1944.z = _1942.z;
	    _1944.w = _374.w;
	    _302 = _1944;
	    vec4 _1953 = _295.xyxy;
	    vec2 _305;
	    vec2 _1954 = _305;
	    vec4 _1967 = _1953;
	    _1967.x = dot(_1953.xy, _341.xy) + _341.w;
	    _1967.y = dot(_1953.xy, _340.xy) + _340.w;
	    vec2 _1975 = _1967.xy + (_339.xy * PerViewConstantBuffer_t.g_flGameTime);
	    vec4 _1977 = _1967;
	    _1977.x = _1975.x;
	    _1977.y = _1975.y;
	    vec3 _1983 = mix(vec3(1.0), _1893.xyz, vec3(_337));
	    vec4 _1985 = _1893;
	    _1985.x = _1983.x;
	    _1985.y = _1983.y;
	    _1985.z = _1983.z;
	    vec3 _1993 = _1985.xyz * _338.xyz;
	    vec4 _1995 = _1985;
	    _1995.x = _1993.x;
	    _1995.y = _1993.y;
	    _1995.z = _1993.z;
	    _1954.x = dot(_295.xy, _336.xy) + _336.w;
	    _1954.y = dot(_295.xy, _335.xy) + _335.w;
	    vec2 _279 = _1954;
	    vec3 _278 = vec4(vsInput[1].vPositionOs.xyz, 1.0) * transpose(gl_ObjectToWorldEXT);
	    vec3 _277 = _1918;
	    vec4 _276 = _1977;
	    vec4 _275 = _1995;
	    vec4 _274 = _1944;
	    vec2 _294 = vsInput[2].vTexCoord;
	    vec3 _365 = vsInput[2].vNormalOs;
	    vec4 _366;
	    vec4 _2020 = _366;
	    _2020.x = vsInput[2].vTangentUOs_flTangentVSign.x;
	    _2020.y = vsInput[2].vTangentUOs_flTangentVSign.y;
	    _2020.z = vsInput[2].vTangentUOs_flTangentVSign.z;
	    _2020.w = vsInput[2].vTangentUOs_flTangentVSign.w;
	    _366 = _2020;
	    PackedRtxInstanceData_t_natural_logical _2033;
	    _2033.nSrgbColor = g_instanceBuffer._member0[uint(gl_InstanceID)].nSrgbColor;
	    _2033.nTriangleGeometry = g_instanceBuffer._member0[uint(gl_InstanceID)].nTriangleGeometry;
	    _2033.nMaterialData = g_instanceBuffer._member0[uint(gl_InstanceID)].nMaterialData;
	    _2033.nMaterialFlags_nInstanceFlags = g_instanceBuffer._member0[uint(gl_InstanceID)].nMaterialFlags_nInstanceFlags;
	    _2033.fEmissiveBoost = g_instanceBuffer._member0[uint(gl_InstanceID)].fEmissiveBoost;
	    _2033.nInstanceFlags = g_instanceBuffer._member0[uint(gl_InstanceID)].nInstanceFlags;
	    _2033._pad1 = g_instanceBuffer._member0[uint(gl_InstanceID)]._pad1;
	    _2033._pad2 = g_instanceBuffer._member0[uint(gl_InstanceID)]._pad2;
	    vec4 _2044 = vec4(uvec4(_2033.nSrgbColor & 255u, (_2033.nSrgbColor & 65280u) >> uint(8), (_2033.nSrgbColor & 16711680u) >> uint(16), (_2033.nSrgbColor & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	    vec4 _364 = _2044;
	    vec3 _2045 = _2044.xyz;
	    vec3 _2046 = _2045 * vec3(0.077399380505084991455078125);
	    vec3 _2049 = pow((_2045 * vec3(0.947867333889007568359375)) + vec3(0.052132703363895416259765625), vec3(2.400000095367431640625));
	    float _361;
	    if (_2044.x <= 0.040449999272823333740234375)
	    {
	        _361 = _2046.x;
	    }
	    else
	    {
	        _361 = _2049.x;
	    }
	    float _362;
	    if (_2044.y <= 0.040449999272823333740234375)
	    {
	        _362 = _2046.y;
	    }
	    else
	    {
	        _362 = _2049.y;
	    }
	    float _363;
	    if (_2044.z <= 0.040449999272823333740234375)
	    {
	        _363 = _2046.z;
	    }
	    else
	    {
	        _363 = _2049.z;
	    }
	    vec3 _2074 = vec3(_361, _362, _363);
	    vec4 _2076 = _364;
	    _2076.x = _2074.x;
	    _2076.y = _2074.y;
	    _2076.z = _2074.z;
	    _364 = _2076;
	    vec4 _307;
	    vec4 _2083 = _307;
	    _2083.x = _2076.x;
	    _2083.y = _2076.y;
	    _2083.z = _2076.z;
	    _2083.w = _2076.w;
	    _307 = _2083;
	    mat3x4 _2094 = transpose(gl_WorldToObjectEXT);
	    mat3 _360;
	    mat3 _2097 = _360;
	    _2097[0] = _2094[0].xyz;
	    _2097[1] = _2094[1].xyz;
	    _2097[2] = _2094[2].xyz;
	    _360 = _2097;
	    vec3 _2106 = normalize(_2097 * _365.xyz);
	    vec3 _308;
	    vec3 _2108 = _308;
	    _2108.x = _2106.x;
	    _2108.y = _2106.y;
	    _2108.z = _2106.z;
	    _308 = _2108;
	    vec3 _2116 = vec4(vsInput[2].vPositionOs.xyz, 1.0) * transpose(gl_ObjectToWorldEXT);
	    mat3x4 _2120 = transpose(gl_WorldToObjectEXT);
	    mat3 _359;
	    mat3 _2123 = _359;
	    _2123[0] = _2120[0].xyz;
	    _2123[1] = _2120[1].xyz;
	    _2123[2] = _2120[2].xyz;
	    _359 = _2123;
	    vec3 _2132 = normalize(_2123 * _366.xyz);
	    vec4 _306;
	    vec4 _2134 = _306;
	    _2134.x = _2132.x;
	    _2134.y = _2132.y;
	    _2134.z = _2132.z;
	    _2134.w = _366.w;
	    _306 = _2134;
	    vec4 _2143 = _294.xyxy;
	    vec2 _309;
	    vec2 _2144 = _309;
	    vec4 _2157 = _2143;
	    _2157.x = dot(_2143.xy, _341.xy) + _341.w;
	    _2157.y = dot(_2143.xy, _340.xy) + _340.w;
	    vec2 _2165 = _2157.xy + (_339.xy * PerViewConstantBuffer_t.g_flGameTime);
	    vec4 _2167 = _2157;
	    _2167.x = _2165.x;
	    _2167.y = _2165.y;
	    vec3 _2173 = mix(vec3(1.0), _2083.xyz, vec3(_337));
	    vec4 _2175 = _2083;
	    _2175.x = _2173.x;
	    _2175.y = _2173.y;
	    _2175.z = _2173.z;
	    vec3 _2183 = _2175.xyz * _338.xyz;
	    vec4 _2185 = _2175;
	    _2185.x = _2183.x;
	    _2185.y = _2183.y;
	    _2185.z = _2183.z;
	    _2144.x = dot(_294.xy, _336.xy) + _336.w;
	    _2144.y = dot(_294.xy, _335.xy) + _335.w;
	    vec3 _273 = _2116;
	    vec3 _272 = _2108;
	    vec3 _2225 = ((_283 * ((1.0 - attrs.barycentrics.x) - attrs.barycentrics.y)) + (_277 * attrs.barycentrics.x)) + (_2108 * attrs.barycentrics.y);
	    vec2 _293 = ((_285 * ((1.0 - attrs.barycentrics.x) - attrs.barycentrics.y)) + (_279 * attrs.barycentrics.x)) + (_2144 * attrs.barycentrics.y);
	    vec3 _292 = _2225;
	    vec4 _291 = ((_282 * ((1.0 - attrs.barycentrics.x) - attrs.barycentrics.y)) + (_276 * attrs.barycentrics.x)) + (_2167 * attrs.barycentrics.y);
	    vec4 _290 = ((_281 * ((1.0 - attrs.barycentrics.x) - attrs.barycentrics.y)) + (_275 * attrs.barycentrics.x)) + (_2185 * attrs.barycentrics.y);
	    vec4 _289 = ((_280 * ((1.0 - attrs.barycentrics.x) - attrs.barycentrics.y)) + (_274 * attrs.barycentrics.x)) + (_2134 * attrs.barycentrics.y);
	    bool _288 = gl_HitKindEXT == 254u;
	    vec2 _326 = vec2(0.5);
	    float _325 = 0.0;
	    vec3 _324 = vec3(0.0);
	    float _323 = 0.039999999105930328369140625;
	    vec3 _322 = vec3(0.0);
	    bool _319 = false;
	    vec3 _321 = _2225.xyz;
	    vec3 _320 = normalize(cross(_278 - _284, _2116 - _284));
	    bool _357;
	    if (_333)
	    {
	        _357 = !_334;
	    }
	    else
	    {
	        _357 = false;
	    }
	    SPIRV_CROSS_BRANCH
	    if (_357)
	    {
	        float _358;
	        if (_288)
	        {
	            _358 = 1.0;
	        }
	        else
	        {
	            _358 = -1.0;
	        }
	        _321 *= _358;
	        if (_288)
	        {
	            _358 = 1.0;
	        }
	        else
	        {
	            _358 = -1.0;
	        }
	        _320 *= _358;
	        _319 = !_288;
	    }
	    vec3 _2292 = _321;
	    vec3 _2293 = normalize(_2292);
	    _321 = _2293;
	    vec2 _317 = _326;
	    float _316 = _325;
	    vec3 _315 = _324;
	    float _314 = _323;
	    vec3 _313 = _322;
	    vec3 _312 = _2293;
	    vec3 _311 = _320;
	    bool _310 = _319;
	    vec4 _2308 = textureLod(sampler2D(g_bindless_Texture2D_float4[_330], g_bindless_Sampler[_331]), _291.xy, 0.0);
	    vec3 _2309 = _2308.xyz;
	    vec3 _318 = mix(_2309, _2309 * _290.xyz, vec3(saturate(_2308.w + _327)));
	    _316 = textureLod(sampler2D(g_bindless_Texture2D_float4[_328], g_bindless_Sampler[_332]), _291.xy, 0.0).y;
	    vec4 _2334 = textureLod(sampler2D(g_bindless_Texture2D_float4[_329], g_bindless_Sampler[_332]), _293.xy, 0.0);
	    float _2335 = _2334.x;
	    float _2336 = _2334.y;
	    float _2338 = (_2335 + _2336) - 1.00392162799835205078125;
	    float _2339 = _2335 - _2336;
	    _317 = _2334.zz;
	    vec3 _355 = normalize(vec3(vec2(_2338, _2339), (1.0 - abs(_2338)) - abs(_2339)));
	    bool _353;
	    if (_333)
	    {
	        _353 = !_334;
	    }
	    else
	    {
	        _353 = false;
	    }
	    if (_353)
	    {
	        float _354;
	        if (_288)
	        {
	            _354 = 1.0;
	        }
	        else
	        {
	            _354 = -1.0;
	        }
	        _353 = _354 < 0.0;
	    }
	    else
	    {
	        _353 = false;
	    }
	    float _356;
	    if (_353)
	    {
	        _356 = -1.0;
	    }
	    else
	    {
	        _356 = 1.0;
	    }
	    float _2370 = _356;
	    vec3 _2371 = _292.xyz * _2370;
	    if (_289.w > 0.0)
	    {
	        _356 = 1.0;
	    }
	    else
	    {
	        _356 = -1.0;
	    }
	    bool _351;
	    if (_333)
	    {
	        _351 = !_334;
	    }
	    else
	    {
	        _351 = false;
	    }
	    if (_351)
	    {
	        float _352;
	        if (_288)
	        {
	            _352 = 1.0;
	        }
	        else
	        {
	            _352 = -1.0;
	        }
	        _351 = _352 < 0.0;
	    }
	    else
	    {
	        _351 = false;
	    }
	    if (!_351)
	    {
	        vec3 _2403 = _355;
	        _2403.y = -_2403.y;
	        _355 = _2403;
	    }
	    vec3 _2410 = _289.xyz * _355.x;
	    vec3 _350;
	    vec3 _2412 = _350;
	    _2412.x = _2410.x;
	    _2412.y = _2410.y;
	    _2412.z = _2410.z;
	    vec3 _2422 = _2412.xyz + ((cross(_2371.xyz, _289.xyz) * _356).xyz * _355.y);
	    vec3 _2424 = _2412;
	    _2424.x = _2422.x;
	    _2424.y = _2422.y;
	    _2424.z = _2422.z;
	    vec3 _2433 = _2424.xyz + (_2371.xyz * _355.z);
	    vec3 _2435 = _2424;
	    _2435.x = _2433.x;
	    _2435.y = _2433.y;
	    _2435.z = _2433.z;
	    _350 = _2435;
	    payload.nInstance = int(uint(gl_InstanceID));
	    payload.flHitT = gl_RayTmaxEXT;
	    payload.vFaceNormalWs = _311;
	    payload.vInterpolatedNormalWs = _312;
	    vec3 _348[3] = vec3[](_284, _278, _273);
	    vec3 _349[3] = vec3[](_283, _277, _272);
	    vec3 _2482 = ((_348[0] * ((1.0 - attrs.barycentrics.x) - attrs.barycentrics.y)) + (_348[1] * attrs.barycentrics.x)) + (_348[2] * attrs.barycentrics.y);
	    vec3 _342[3];
	    _342[0] = _2482 - (_349[0] * dot(_2482 - _348[0], _349[0]));
	    _342[1] = _2482 - (_349[1] * dot(_2482 - _348[1], _349[1]));
	    _342[2] = _2482 - (_349[2] * dot(_2482 - _348[2], _349[2]));
	    vec3 _2522 = ((_342[0] * ((1.0 - attrs.barycentrics.x) - attrs.barycentrics.y)) + (_342[1] * attrs.barycentrics.x)) + (_342[2] * attrs.barycentrics.y);
	    vec3 _343[3];
	    _343[0] = cross(_348[0] - _348[1], _311);
	    _343[1] = cross(_348[1] - _348[2], _311);
	    _343[2] = cross(_348[2] - _348[0], _311);
	    float _344 = dot(_2522 - _2482, _311);
	    vec3 _345 = _2522;
	    int _346 = 0;
	    for (;;)
	    {
	        bool _2538_ladder_break = false;
	        do
	        {
	            if (!(_346 < 3))
	            {
	                _2538_ladder_break = true;
	                break;
	            }
	            if (_344 > 0.00999999977648258209228515625)
	            {
	                _2538_ladder_break = true;
	                break;
	            }
	            if (dot(_343[_346], _343[_346]) == 0.0)
	            {
	                break;
	            }
	            _343[_346] = normalize(_343[_346]);
	            int _347 = 0;
	            for (;;)
	            {
	                if (!(_347 < 3))
	                {
	                    break;
	                }
	                vec3 _2576 = _349[_347] - (_343[_346] * dot(_343[_346], _349[_347]));
	                _342[_347] = _2482 - (_2576 * dot(_2482 - _348[_347], _2576));
	                _347++;
	                continue;
	            }
	            vec3 _2600 = ((_342[0] * ((1.0 - attrs.barycentrics.x) - attrs.barycentrics.y)) + (_342[1] * attrs.barycentrics.x)) + (_342[2] * attrs.barycentrics.y);
	            _344 = dot(_2600 - _2482, _311);
	            _345 = _2600;
	            break;
	        } while(false);
	        if (_2538_ladder_break)
	        {
	            break;
	        }
	        _346++;
	        continue;
	    }
	    if (!(_344 > 0.00999999977648258209228515625))
	    {
	        _345 = vec3(3.4028234663852885981170418348452e+38);
	    }
	    payload.vSmoothPositionWs = _345;
	    payload.bFlippedNormal = _310;
	    f16vec3 _2613 = f16vec3(vec3(0.0));
	    payload.material = MaterialDataMinimal_t(_2613, float16_t(0.0), f16vec3(vec3(1.0, 0.0, 1.0)), float16_t(1.0), _2613, float16_t(0.040008544921875), 0u, f16vec4(ivec4(0)));
	    payload.material.vNormalWs = f16vec3(normalize(_2435.xyz));
	    payload.material.vAlbedo = f16vec3(_318);
	    payload.material.vEmissive = f16vec3(_315);
	    payload.material.flReflectance = float16_t(_314);
	    payload.material.flMetalness = float16_t(_316);
	    payload.material.flRoughness = float16_t(dot(_317, vec2(0.5)));
	    if (any(greaterThan(_313, vec3(0.0))))
	    {
	        payload.material.nMaterialTypeAndFlags = (payload.material.nMaterialTypeAndFlags & 4294901760u) | 1u;
	        f16vec3 _2639 = f16vec3(_313);
	        payload.material.vMaterialBits.x = _2639.x;
	        payload.material.vMaterialBits.y = _2639.y;
	        payload.material.vMaterialBits.z = _2639.z;
	    }
	}
	
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
	
	BoolAttribute(BindlessResources, true);
	IntAttribute(RayTypeCount, 2);
	BoolAttribute(CanBatchWithDynamicShaderConstants, true);
	IntAttribute(TexCoordScaleByModelU, g_nScaleTexCoordUByModelScaleAxis-1);
	IntAttribute(TexCoordScaleByModelV, g_nScaleTexCoordVByModelScaleAxis-1);
	Float3Attribute(LightSim_MaterialTint, g_vColorTint);
	BoolAttribute(SupportsAggregateInstancing, F_TRANSLUCENT==0);
	BoolAttribute(NeedsLightProbe, true);
	BoolAttribute(DoNotCastShadows, F_DO_NOT_CAST_SHADOWS || 0);
	BoolAttribute(SupportsMappingDimensions, true);
	TextureAttribute(LightSim_DiffuseAlbedoTexture, g_tColor);
	TextureAttribute(RepresentativeTexture, g_tColor);
	BoolAttribute(renderbackfaces, F_RENDER_BACKFACES || 0);
	
	#if (S_TINT_MASK == 0)
		TextureAttribute(LightSim_SelfIllumMaskTexture, g_tSelfIllumMask);
		Float3Attribute(LightSim_SelfIllumTint, g_vSelfIllumTint);
		FloatAttribute(LightSim_SelfIllumScale, g_flSelfIllumScale);
	#endif
	#if (S_TRANSLUCENT == 0)
		TextureAttribute(LightSim_SelfIllumMaskTexture, g_tSelfIllumMask);
		Float3Attribute(LightSim_SelfIllumTint, g_vSelfIllumTint);
		FloatAttribute(LightSim_SelfIllumScale, g_flSelfIllumScale);
	#endif
	#if (S_SPECULAR_INDIRECT == 0)
		TextureAttribute(LightSim_SelfIllumMaskTexture, g_tSelfIllumMask);
		Float3Attribute(LightSim_SelfIllumTint, g_vSelfIllumTint);
		FloatAttribute(LightSim_SelfIllumScale, g_flSelfIllumScale);
	#endif
	#if (S_TINT_MASK == 1)
		TextureAttribute(LightSim_TintMaskTextureR, g_tTintMask);
	#endif
	#if (S_TRANSLUCENT == 1)
		BoolAttribute(translucent, true);
		BoolAttribute(NoZPrepass, F_DISABLE_Z_PREPASS || 0);
	#endif
	#if (S_ALPHA_TEST == 1)
		BoolAttribute(alphatest, true);
		FloatAttribute(_dummyReferenceAlphaTestReferenceInMainShader, g_flAlphaTestReference);
		FloatAttribute(_dummyReferenceAntiAliasedEdgeStrengthReferenceInMainShader, g_flAntiAliasedEdgeStrength);
		BoolAttribute(NoZPrepass, true);
		BoolAttribute(AlphaTestZPrepass, true);
	#endif
	#if (S_ALPHA_TEST == 0)
		BoolAttribute(NoZPrepass, F_DISABLE_Z_PREPASS || 0);
	#endif
	#if (S_MODE_TOOLS_VIS == 0)
		TextureAttribute(LightSim_SelfIllumMaskTexture, g_tSelfIllumMask);
		Float3Attribute(LightSim_SelfIllumTint, g_vSelfIllumTint);
		FloatAttribute(LightSim_SelfIllumScale, g_flSelfIllumScale);
	#endif
	#if (S_SELF_ILLUM == 0)
		TextureAttribute(LightSim_TintMaskTextureR, g_tTintMask);
	#endif
	#if (S_ADDITIVE_BLEND == 0)
		TextureAttribute(LightSim_SelfIllumMaskTexture, g_tSelfIllumMask);
		Float3Attribute(LightSim_SelfIllumTint, g_vSelfIllumTint);
		FloatAttribute(LightSim_SelfIllumScale, g_flSelfIllumScale);
	#endif
	#if (S_SHADER_QUALITY == 0)
		TextureAttribute(LightSim_SelfIllumMaskTexture, g_tSelfIllumMask);
		Float3Attribute(LightSim_SelfIllumTint, g_vSelfIllumTint);
		FloatAttribute(LightSim_SelfIllumScale, g_flSelfIllumScale);
	#endif
	#if (S_SELF_ILLUM == 1)
		TextureAttribute(LightSim_SelfIllumMaskTexture, g_tSelfIllumMask);
		Float3Attribute(LightSim_SelfIllumTint, g_vSelfIllumTint);
		FloatAttribute(LightSim_SelfIllumScale, g_flSelfIllumScale);
	#endif
	#if (S_ADDITIVE_BLEND == 1)
		BoolAttribute(translucent, true);
		BoolAttribute(NoZPrepass, F_DISABLE_Z_PREPASS || 0);
	#endif
	#if (S_SPECULAR_DIRECT == 0)
		TextureAttribute(LightSim_SelfIllumMaskTexture, g_tSelfIllumMask);
		Float3Attribute(LightSim_SelfIllumTint, g_vSelfIllumTint);
		FloatAttribute(LightSim_SelfIllumScale, g_flSelfIllumScale);
	#endif
}
