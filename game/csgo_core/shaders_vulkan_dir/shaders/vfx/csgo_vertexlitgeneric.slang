//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "(S1) vertexlit, bump, phong shader for CSGO.";
	DevShader = false;
	Version = 4;
	
	// VcsVersion: 70
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
	
	cbuffer BakedLightingConstantBuffer_t < Attribute("BakedLightingConstantBuffer_t"); >;
	cbuffer PerViewConstantBufferCsgo_t < Attribute("PerViewConstantBufferCsgo_t"); >;
	cbuffer PerViewConstantBuffer_t < Attribute("PerViewConstantBuffer_t"); >;
	ByteAddressBuffer g_animatedVertexCache < Attribute("AnimatedVertexCache"); SrgbRead(false); >;
	bool g_bTexCoordScaleByModel < UiType(CheckBox); Expression((g_nScaleTexCoordUByModelScaleAxis!=0) || (g_nScaleTexCoordVByModelScaleAxis!=0)); >;
	ExternalDescriptorSet g_globalLateBoundBindlessSet < Source(ExternalDescSet); Attribute("g_globalLateBoundBindlessSet"); >;
	StructuredBuffer g_instanceBuffer < Attribute("InstanceBuffer"); SrgbRead(false); >;
	ExternalDescriptorSet g_lightBinnerGpuSet < Source(ExternalDescSet); Attribute("g_lightBinnerGpuSet"); >;
	StructuredBuffer g_transformBuffer < Attribute("TransformBuffer"); SrgbRead(false); >;
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
	// cbuffer ID 4459 (name: PerViewConstantBuffer_t), member index 1 (name: _m1) cannot be expressed with either HLSL packing layout or packoffset.
	// 
	// Re-attempting reflection with the GLSL backend.
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (7704 bytes), GLSL reflection with SPIRV-Cross by KhronosGroup
	
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
	    output_0 = vec2(dot(vTexCoord.xy, _Globals_.g_vNormalTexCoordXform0.xy) + _Globals_.g_vNormalTexCoordXform0.w, dot(vTexCoord.xy, _Globals_.g_vNormalTexCoordXform1.xy) + _Globals_.g_vNormalTexCoordXform1.w);
	    output_1 = _12151.xyz - PerViewConstantBufferCsgo_t._m0.xyz;
	    output_2 = normalize(vec4(vNormalOs.xyz, 0.0) * _17839);
	    output_3 = _20488;
	    output_4 = _23714;
	    output_5 = vec4(normalize(vec4(vTangentUOs_flTangentVSign.xyz, 0.0) * _17839), vTangentUOs_flTangentVSign.w);
	    output_6 = (g_instanceBuffer_1._m0[nInstanceIdx]._m5) & 65535u;
	    _23875.y = -_23875.y;
	    gl_Position = _23875;
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
	float g_flInverseBlendTint < UiType(Slider); Expression(F_NOTINT ? -1 : (1-(F_TINT_MASK || 0))); >;
	float g_flReflectance < UiType(Slider); Expression(pow((1.5-1)/(1.5+1),2)); >;
	ExternalDescriptorSet g_globalLateBoundBindlessSet < Source(ExternalDescSet); Attribute("g_globalLateBoundBindlessSet"); >;
	ExternalDescriptorSet g_lightBinnerGpuSet < Source(ExternalDescSet); Attribute("g_lightBinnerGpuSet"); >;
	int g_nDecalBlendMode < UiType(Slider); Expression(F_DECAL_BLEND_MODE || 0); >;
	int g_nToolsVisMode < Attribute("g_nToolsVisMode"); UiType(Slider); >;
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
	#endif
	#if (S_TRANSLUCENT == 1)
	#endif
	#if (S_ADDITIVE_BLEND == 1)
	#endif
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (34188 bytes), HLSL reflection with SPIRV-Cross by KhronosGroup
	
	struct _2620
	{
	    float4 _m0[4];
	};
	
	struct _2410
	{
	    float4 _m0[3];
	};
	
	struct _2621
	{
	    float4 _m0[4];
	};
	
	struct _2411
	{
	    float4 _m0[3];
	};
	
	struct _1804
	{
	    _2620 _m0[4];
	};
	
	struct _1802
	{
	    _2620 _m0;
	    _2620 _m1;
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
	    _2411 _m15;
	    float4 _m16;
	    float4 _m17;
	    float4 _m18;
	    float4 _m19;
	    float4 _m20;
	    float3 _m21;
	    float _m22;
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
	
	cbuffer PerViewConstantBufferCsgo_t : register(b4, space1)
	{
	    int4 PerViewConstantBufferCsgo_t_1_m0 : packoffset(c1);
	    int4 PerViewConstantBufferCsgo_t_1_m1 : packoffset(c2);
	    int4 PerViewConstantBufferCsgo_t_1_m2 : packoffset(c3);
	    uint PerViewConstantBufferCsgo_t_1_m3 : packoffset(c4.z);
	    uint PerViewConstantBufferCsgo_t_1_m4 : packoffset(c4.w);
	    uint PerViewConstantBufferCsgo_t_1_m5 : packoffset(c5);
	    uint PerViewConstantBufferCsgo_t_1_m6 : packoffset(c5.z);
	    _2620 PerViewConstantBufferCsgo_t_1_m7 : packoffset(c12);
	    float2 PerViewConstantBufferCsgo_t_1_m8 : packoffset(c16);
	    float PerViewConstantBufferCsgo_t_1_m9 : packoffset(c16.z);
	    float4 PerViewConstantBufferCsgo_t_1_m10 : packoffset(c23);
	    float4 PerViewConstantBufferCsgo_t_1_m11 : packoffset(c24);
	    float4 PerViewConstantBufferCsgo_t_1_m12 : packoffset(c25);
	    float4 PerViewConstantBufferCsgo_t_1_m13 : packoffset(c26);
	    float4 PerViewConstantBufferCsgo_t_1_m14 : packoffset(c27);
	    float4 PerViewConstantBufferCsgo_t_1_m15 : packoffset(c28);
	    _2620 PerViewConstantBufferCsgo_t_1_m16 : packoffset(c29);
	    float4 PerViewConstantBufferCsgo_t_1_m17 : packoffset(c33);
	    float4 PerViewConstantBufferCsgo_t_1_m18 : packoffset(c34);
	    float4 PerViewConstantBufferCsgo_t_1_m19 : packoffset(c35);
	};
	
	cbuffer PerViewLightingConstantBufferGpu_t : register(b0, space3)
	{
	    _2410 PerViewLightingConstantBufferGpu_t_1_m0 : packoffset(c7);
	    _2621 PerViewLightingConstantBufferGpu_t_1_m1 : packoffset(c11);
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
	    _1804 PerViewLightingConstantBufferGpu_t_1_m17 : packoffset(c1956);
	    _2621 PerViewLightingConstantBufferGpu_t_1_m18 : packoffset(c1988);
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
	SamplerState undetermined[2048] : register(s29, space4);
	SamplerComparisonState undetermined_1[2048] : register(s29, space4);
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
	        _12885 = !(_Globals_1_g_bDontFlipBackfaceNormals != 0);
	    }
	    else
	    {
	        _12885 = false;
	    }
	    float3 _10251;
	    if (_12885)
	    {
	        _10251 = input_2.xyz * (gl_FrontFacing ? 1.0f : (-1.0f));
	    }
	    else
	    {
	        _10251 = input_2.xyz;
	    }
	    float3 _10061 = input_1 + PerViewConstantBufferCsgo_t_1_m19.xyz;
	    float4 _19680 = g_bindless_Texture2D_float4[_Globals_1_g_tColor].Sample(undetermined[_Globals_1_g_sUserConfigAllowGlobalMipBias], input_3.xy);
	    float3 _13737 = _19680.xyz;
	    float4 _19068 = g_bindless_Texture2D_float4[_Globals_1_g_tAmbientOcclusion].Sample(undetermined[_Globals_1_g_sUserConfig], float2(input_3.zw).xy);
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
	    float4 _19069 = g_bindless_Texture2D_float4[_Globals_1_g_tMetalness].Sample(undetermined[_Globals_1_g_sUserConfig], input_3.xy);
	    float4 _19372 = g_bindless_Texture2D_float4[_Globals_1_g_tNormal].Sample(undetermined[_Globals_1_g_sUserConfig], input_0.xy);
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
	    bool4 _24465 = bool4(PerViewConstantBufferCsgo_t_1_m0.x != int4(0, 0, 0, 0).x, PerViewConstantBufferCsgo_t_1_m0.y != int4(0, 0, 0, 0).y, PerViewConstantBufferCsgo_t_1_m0.z != int4(0, 0, 0, 0).z, PerViewConstantBufferCsgo_t_1_m0.w != int4(0, 0, 0, 0).w);
	    float _21785;
	    if (_24465.x)
	    {
	        float3 _11394 = normalize(_10251).xyz;
	        float2 _11087 = ((floor(_11408.xy * PerViewConstantBufferCsgo_t_1_m9) * PerViewConstantBufferCsgo_t_1_m8.xy) + (PerViewConstantBufferCsgo_t_1_m8.xy * 0.5f)).xy;
	        float4 _18418 = g_bindless_Texture2D_float4[PerViewConstantBufferCsgo_t_1_m5].GatherRed(undetermined[_Globals_1_g_sCookieSampler], _11087).xyzw - _11408.zzzz;
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
	        float4 _17422 = (max(float4(dot(PerViewLightingConstantBufferGpu_t_1_m1._m0[0].xyz, _11394), dot(PerViewLightingConstantBufferGpu_t_1_m1._m0[1].xyz, _11394), dot(PerViewLightingConstantBufferGpu_t_1_m1._m0[2].xyz, _11394), dot(PerViewLightingConstantBufferGpu_t_1_m1._m0[3].xyz, _11394)).xyzw, 0.0f.xxxx).xyzw * PerViewLightingConstantBufferGpu_t_1_m2.xyzw).xyzw;
	        _21785 = (1.0f / (dot(_17422, 1.0f.xxxx) + PerViewLightingConstantBufferGpu_t_1_m3.x)) * (PerViewLightingConstantBufferGpu_t_1_m3.x + dot(_17422, g_bindless_Texture2D_float4[PerViewConstantBufferCsgo_t_1_m4].SampleLevel(undetermined[_Globals_1_g_sPointClamp], (_11087 + float2(_13083.x ? PerViewConstantBufferCsgo_t_1_m8.xy.x : _23169.x, _13083.y ? PerViewConstantBufferCsgo_t_1_m8.xy.y : _23169.y).xy).xy, 0.0f).xyzw));
	    }
	    else
	    {
	        _21785 = 1.0f;
	    }
	    float3 _24735 = _14786.xyz;
	    float4 _23875 = float4(_24735, 1.0f);
	    float _21710;
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
	            float4 _18322 = mul(float4x4(float4(PerViewLightingConstantBufferGpu_t_1_m17._m0[_13039]._m0[0].x, PerViewLightingConstantBufferGpu_t_1_m17._m0[_13039]._m0[1].x, PerViewLightingConstantBufferGpu_t_1_m17._m0[_13039]._m0[2].x, PerViewLightingConstantBufferGpu_t_1_m17._m0[_13039]._m0[3].x), float4(PerViewLightingConstantBufferGpu_t_1_m17._m0[_13039]._m0[0].y, PerViewLightingConstantBufferGpu_t_1_m17._m0[_13039]._m0[1].y, PerViewLightingConstantBufferGpu_t_1_m17._m0[_13039]._m0[2].y, PerViewLightingConstantBufferGpu_t_1_m17._m0[_13039]._m0[3].y), float4(PerViewLightingConstantBufferGpu_t_1_m17._m0[_13039]._m0[0].z, PerViewLightingConstantBufferGpu_t_1_m17._m0[_13039]._m0[1].z, PerViewLightingConstantBufferGpu_t_1_m17._m0[_13039]._m0[2].z, PerViewLightingConstantBufferGpu_t_1_m17._m0[_13039]._m0[3].z), float4(PerViewLightingConstantBufferGpu_t_1_m17._m0[_13039]._m0[0].w, PerViewLightingConstantBufferGpu_t_1_m17._m0[_13039]._m0[1].w, PerViewLightingConstantBufferGpu_t_1_m17._m0[_13039]._m0[2].w, PerViewLightingConstantBufferGpu_t_1_m17._m0[_13039]._m0[3].w)), float4(input_1.xyz, 1.0f));
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
	            float _18270 = g_bindless_Texture2D_float4[PerViewLightingConstantBufferGpu_t_1_m19].SampleCmpLevelZero(undetermined_1[_Globals_1_g_tShadowDepthBufferCmpSampler], _14975.xy, clamp(_14975.z + PerViewLightingConstantBufferGpu_t_1_m11, 0.0f, 1.0f));
	            float _12501;
	            if (_13136 < 1.0f)
	            {
	                float _7934;
	                if (_10191 < (PerViewLightingConstantBufferGpu_t_1_m10 - 1))
	                {
	                    int _15335 = _10191 + 1;
	                    float4 _19671 = mul(float4x4(float4(PerViewLightingConstantBufferGpu_t_1_m17._m0[_15335]._m0[0].x, PerViewLightingConstantBufferGpu_t_1_m17._m0[_15335]._m0[1].x, PerViewLightingConstantBufferGpu_t_1_m17._m0[_15335]._m0[2].x, PerViewLightingConstantBufferGpu_t_1_m17._m0[_15335]._m0[3].x), float4(PerViewLightingConstantBufferGpu_t_1_m17._m0[_15335]._m0[0].y, PerViewLightingConstantBufferGpu_t_1_m17._m0[_15335]._m0[1].y, PerViewLightingConstantBufferGpu_t_1_m17._m0[_15335]._m0[2].y, PerViewLightingConstantBufferGpu_t_1_m17._m0[_15335]._m0[3].y), float4(PerViewLightingConstantBufferGpu_t_1_m17._m0[_15335]._m0[0].z, PerViewLightingConstantBufferGpu_t_1_m17._m0[_15335]._m0[1].z, PerViewLightingConstantBufferGpu_t_1_m17._m0[_15335]._m0[2].z, PerViewLightingConstantBufferGpu_t_1_m17._m0[_15335]._m0[3].z), float4(PerViewLightingConstantBufferGpu_t_1_m17._m0[_15335]._m0[0].w, PerViewLightingConstantBufferGpu_t_1_m17._m0[_15335]._m0[1].w, PerViewLightingConstantBufferGpu_t_1_m17._m0[_15335]._m0[2].w, PerViewLightingConstantBufferGpu_t_1_m17._m0[_15335]._m0[3].w)), float4(input_1.xyz, 1.0f));
	                    float2 _20562 = (_19671.xy * PerViewLightingConstantBufferGpu_t_1_m18._m0[_15335].zw) + PerViewLightingConstantBufferGpu_t_1_m18._m0[_15335].xy;
	                    float3 _20489;
	                    _20489.x = _20562.x;
	                    _20489.y = _20562.y;
	                    _7934 = g_bindless_Texture2D_float4[PerViewLightingConstantBufferGpu_t_1_m19].SampleCmpLevelZero(undetermined_1[_Globals_1_g_tShadowDepthBufferCmpSampler], _20489.xy, clamp(_19671.z + PerViewLightingConstantBufferGpu_t_1_m11, 0.0f, 1.0f));
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
	            _12502 = min(_13279, g_bindless_Texture2D_float4[PerViewConstantBufferCsgo_t_1_m6].SampleLevel(undetermined[_Globals_1_g_sTrilinearClamp], (_11408.xy * PerViewConstantBuffer_t_1_m2.xy).xy, 0.0f).z);
	        }
	        else
	        {
	            _12502 = _13279;
	        }
	        _21710 = _12502;
	    }
	    else
	    {
	        _21710 = 1.0f;
	    }
	    float3 _21711;
	    if ((dot(PerViewLightingConstantBufferGpu_t_1_m8.xyz, _24735) * _21710) > 0.0f)
	    {
	        _21711 = PerViewLightingConstantBufferGpu_t_1_m4.xyz + (max(0.0f, dot(_14786.xyz, PerViewLightingConstantBufferGpu_t_1_m8.xyz)).xxx.xyz * (PerViewLightingConstantBufferGpu_t_1_m9.xyz * _21710).xyz);
	    }
	    else
	    {
	        _21711 = PerViewLightingConstantBufferGpu_t_1_m4.xyz;
	    }
	    bool4 _24466 = bool4(PerViewConstantBufferCsgo_t_1_m1.x != int4(0, 0, 0, 0).x, PerViewConstantBufferCsgo_t_1_m1.y != int4(0, 0, 0, 0).y, PerViewConstantBufferCsgo_t_1_m1.z != int4(0, 0, 0, 0).z, PerViewConstantBufferCsgo_t_1_m1.w != int4(0, 0, 0, 0).w);
	    bool _20060 = _24466.x;
	    float4 _19364;
	    if (_20060)
	    {
	        float4 _24259 = mul(float4x4(float4(PerViewConstantBufferCsgo_t_1_m7._m0[0].x, PerViewConstantBufferCsgo_t_1_m7._m0[1].x, PerViewConstantBufferCsgo_t_1_m7._m0[2].x, PerViewConstantBufferCsgo_t_1_m7._m0[3].x), float4(PerViewConstantBufferCsgo_t_1_m7._m0[0].y, PerViewConstantBufferCsgo_t_1_m7._m0[1].y, PerViewConstantBufferCsgo_t_1_m7._m0[2].y, PerViewConstantBufferCsgo_t_1_m7._m0[3].y), float4(PerViewConstantBufferCsgo_t_1_m7._m0[0].z, PerViewConstantBufferCsgo_t_1_m7._m0[1].z, PerViewConstantBufferCsgo_t_1_m7._m0[2].z, PerViewConstantBufferCsgo_t_1_m7._m0[3].z), float4(PerViewConstantBufferCsgo_t_1_m7._m0[0].w, PerViewConstantBufferCsgo_t_1_m7._m0[1].w, PerViewConstantBufferCsgo_t_1_m7._m0[2].w, PerViewConstantBufferCsgo_t_1_m7._m0[3].w)), float4(_10061.xyz, 1.0f).xyzw);
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
	    float3 _13155;
	    _13155 = _21711;
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
	                _2620 _25209;
	                [unroll]
	                for (int _2ident = 0; _2ident < 4; _2ident++)
	                {
	                    _25209._m0[_2ident] = asfloat(g_BarnLights.Load4(_2ident * 16 + _12608 * 416 + 0));
	                }
	                float4 _15817 = mul(float4(input_1.xyz, 1.0f), float4x4(float4(_25209._m0[0].x, _25209._m0[1].x, _25209._m0[2].x, _25209._m0[3].x), float4(_25209._m0[0].y, _25209._m0[1].y, _25209._m0[2].y, _25209._m0[3].y), float4(_25209._m0[0].z, _25209._m0[1].z, _25209._m0[2].z, _25209._m0[3].z), float4(_25209._m0[0].w, _25209._m0[1].w, _25209._m0[2].w, _25209._m0[3].w)));
	                float3 _10521 = _15817.xyz / _15817.w.xxx;
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
	                    _2411 _8549;
	                    [unroll]
	                    for (int _3ident = 0; _3ident < 3; _3ident++)
	                    {
	                        _8549._m0[_3ident] = asfloat(g_BarnLights.Load4(_3ident * 16 + _12608 * 416 + 272));
	                    }
	                    float3 _6368 = abs(mul(float4(input_1.xyz, 1.0f), float4x3(float3(_8549._m0[0].x, _8549._m0[1].x, _8549._m0[2].x), float3(_8549._m0[0].y, _8549._m0[1].y, _8549._m0[2].y), float3(_8549._m0[0].z, _8549._m0[1].z, _8549._m0[2].z), float3(_8549._m0[0].w, _8549._m0[1].w, _8549._m0[2].w))).xyz);
	                    _12887 = !all(bool3(_6368.x <= 1.0f.xxx.x, _6368.y <= 1.0f.xxx.y, _6368.z <= 1.0f.xxx.z));
	                }
	                if (_12887)
	                {
	                    _12504 = _13156;
	                    break;
	                }
	                float _23571 = 2.0f * asfloat(g_BarnLights.Load4(_12608 * 416 + 176)).y;
	                float _18492 = (2.0f * asfloat(g_BarnLights.Load4(_12608 * 416 + 176)).z) * asfloat(g_BarnLights.Load4(_12608 * 416 + 176)).z;
	                float _14805 = 2.0f * asfloat(g_BarnLights.Load4(_12608 * 416 + 176)).x;
	                float _9058 = _14805 * asfloat(g_BarnLights.Load4(_12608 * 416 + 176)).y;
	                float _17330 = 2.0f * asfloat(g_BarnLights.Load4(_12608 * 416 + 176)).w;
	                float _19825 = _17330 * asfloat(g_BarnLights.Load4(_12608 * 416 + 176)).z;
	                float3 _16268 = float3(_9058 - _19825, (1.0f - (_14805 * asfloat(g_BarnLights.Load4(_12608 * 416 + 176)).x)) - _18492, (_23571 * asfloat(g_BarnLights.Load4(_12608 * 416 + 176)).z) + (_17330 * asfloat(g_BarnLights.Load4(_12608 * 416 + 176)).x)) * asfloat(g_BarnLights.Load3(_12608 * 416 + 192)).z;
	                float _21316;
	                if (asfloat(g_BarnLights.Load4(_12608 * 416 + 144)).z > 0.0f)
	                {
	                    _21316 = min(1.0f, _21775 * asfloat(g_BarnLights.Load4(_12608 * 416 + 144)).z);
	                }
	                else
	                {
	                    _21316 = 1.0f;
	                }
	                float _19667;
	                if (asfloat(g_BarnLights.Load4(_12608 * 416 + 144)).w > 0.0f)
	                {
	                    _19667 = _21316 * min(1.0f, (1.0f - _21775) * asfloat(g_BarnLights.Load4(_12608 * 416 + 144)).w);
	                }
	                else
	                {
	                    _19667 = _21316;
	                }
	                float3 _11179;
	                float _11633;
	                if (asfloat(g_BarnLights.Load4(_12608 * 416 + 128)).w != 0.0f)
	                {
	                    float3 _10017 = asfloat(g_BarnLights.Load4(_12608 * 416 + 128)).xyz - input_1.xyz;
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
	                    _11633 = ((_19667 * (asfloat(g_BarnLights.Load4(_12608 * 416 + 128)).w / max(_18345, asfloat(g_BarnLights.Load4(_12608 * 416 + 128)).w))) * clamp(asfloat(g_BarnLights.Load4(_12608 * 416 + 144)).x + (asfloat(g_BarnLights.Load4(_12608 * 416 + 144)).y * _17647), 0.0f, 1.0f)) * clamp(asfloat(g_BarnLights.Load3(_12608 * 416 + 192)).x + (asfloat(g_BarnLights.Load3(_12608 * 416 + 192)).y * dot(float3((1.0f - (_23571 * asfloat(g_BarnLights.Load4(_12608 * 416 + 176)).y)) - _18492, _9058 + _19825, (_14805 * asfloat(g_BarnLights.Load4(_12608 * 416 + 176)).z) - (_17330 * asfloat(g_BarnLights.Load4(_12608 * 416 + 176)).y)), normalize(_10210))), 0.0f, 1.0f);
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
	                    _24419 = !_20060;
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
	                            float _15019 = _22154.y;
	                            float _23041 = (-0.5f) * asfloat(g_BarnLights.Load4(_12608 * 416 + 224)).z;
	                            float _11981 = (asfloat(g_BarnLights.Load4(_12608 * 416 + 224)).x * asfloat(g_BarnLights.Load4(_12608 * 416 + 224)).y) * pow(max(pow(asfloat(g_BarnLights.Load4(_12608 * 416 + 224)).y * _11473, _15266) + pow(asfloat(g_BarnLights.Load4(_12608 * 416 + 224)).x * _15019, _15266), 1.1754943508222875079687365372222e-38f), _23041);
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
	                        float3 _20491 = _14081;
	                        _20491.x = _20564.x;
	                        _20491.y = _20564.y;
	                        _12503 = _17828.xyz * g_bindless_Texture3D_float4[PerViewLightingConstantBufferGpu_t_1_m20].SampleLevel(undetermined[_Globals_1_g_sTrilinearWrap], _20491.xyz, 0.0f).xyz;
	                    }
	                    else
	                    {
	                        float3 _13791 = float3(mad(_22905.xy, float2(0.5f, -0.5f), 0.5f.xx), asfloat(g_BarnLights.Load4(_12608 * 416 + 160)).w);
	                        float2 _20563 = (_13791.xy * asfloat(g_BarnLights.Load4(_12608 * 416 + 224)).zw) + asfloat(g_BarnLights.Load4(_12608 * 416 + 224)).xy;
	                        float3 _20490 = _13791;
	                        _20490.x = _20563.x;
	                        _20490.y = _20563.y;
	                        _12503 = _17828.xyz * g_bindless_Texture3D_float4[PerViewLightingConstantBufferGpu_t_1_m20].SampleLevel(undetermined[_Globals_1_g_sCookieSampler], _20490.xyz, 0.0f).xyz;
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
	                    if ((g_BarnLights.Load(_12608 * 416 + 264) & 4u) != 0u)
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
	                    float3 _20482 = _21548.xyz * lerp(1.0f, g_bindless_Texture2D_float4[PerViewLightingConstantBufferGpu_t_1_m19].SampleCmpLevelZero(undetermined_1[_Globals_1_g_tShadowDepthBufferCmpSampler], float3(mad(_19629.xy, asfloat(g_BarnLights.Load4(_12608 * 416 + 208)).zw, asfloat(g_BarnLights.Load4(_12608 * 416 + 208)).xy), _19629.z).xy, clamp(_19629.z + PerViewLightingConstantBufferGpu_t_1_m11, 0.0f, 1.0f)), asfloat(g_BarnLights.Load(_12608 * 416 + 260)));
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
	    float3 _22686 = ((_13155.xyz * _21785.xxx).xyz + (float3(dot(PerViewLightingConstantBufferGpu_t_1_m0._m0[0].xyzw, _23875), dot(PerViewLightingConstantBufferGpu_t_1_m0._m0[1].xyzw, _23875), dot(PerViewLightingConstantBufferGpu_t_1_m0._m0[2].xyzw, _23875)).xyz * (_21785 * _21709).xxx.xyz).xyz) * (lerp(_13737, _13737 * input_4.xyz, clamp(_19680.w + _Globals_1_g_flInverseBlendTint, 0.0f, 1.0f).xxx).xyz * (1.0f - _19069.y)).xyz;
	    float4 _11203 = float4(_22686, input_4.w);
	    _11203.x = _22686.x;
	    _11203.y = _22686.y;
	    _11203.z = _22686.z;
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
	            if (_12888)
	            {
	                float2 _9342 = clamp(PerViewConstantBufferCsgo_t_1_m10.xy + (PerViewConstantBufferCsgo_t_1_m10.zw * float2(length(_21493), _10061.z)), 0.0f.xx, 1.0f.xx);
	                float _12872 = (pow(_9342.x, PerViewConstantBufferCsgo_t_1_m11.x) * pow(_9342.y, PerViewConstantBufferCsgo_t_1_m11.y)) * PerViewConstantBufferCsgo_t_1_m12.w;
	                _19340 = lerp(_11203.xyz, float4(PerViewConstantBufferCsgo_t_1_m12.xyz, _12872).xyz, _12872.xxx);
	                break;
	            }
	            _19340 = _11203.xyz;
	            break;
	        } while(false);
	        float4 _23944 = _11203;
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
	                _19341 = lerp(_23944.xyz, float4((g_bindless_TextureCube_float4[PerViewConstantBufferCsgo_t_1_m3].SampleLevel(undetermined[_Globals_1_g_sTrilinearClamp], normalize(mul(float4(_9057, 0.0f), float4x4(float4(PerViewConstantBufferCsgo_t_1_m16._m0[0].x, PerViewConstantBufferCsgo_t_1_m16._m0[1].x, PerViewConstantBufferCsgo_t_1_m16._m0[2].x, PerViewConstantBufferCsgo_t_1_m16._m0[3].x), float4(PerViewConstantBufferCsgo_t_1_m16._m0[0].y, PerViewConstantBufferCsgo_t_1_m16._m0[1].y, PerViewConstantBufferCsgo_t_1_m16._m0[2].y, PerViewConstantBufferCsgo_t_1_m16._m0[3].y), float4(PerViewConstantBufferCsgo_t_1_m16._m0[0].z, PerViewConstantBufferCsgo_t_1_m16._m0[1].z, PerViewConstantBufferCsgo_t_1_m16._m0[2].z, PerViewConstantBufferCsgo_t_1_m16._m0[3].z), float4(PerViewConstantBufferCsgo_t_1_m16._m0[0].w, PerViewConstantBufferCsgo_t_1_m16._m0[1].w, PerViewConstantBufferCsgo_t_1_m16._m0[2].w, PerViewConstantBufferCsgo_t_1_m16._m0[3].w))).xyz).xyz, PerViewConstantBufferCsgo_t_1_m15.w * clamp(1.0f - (_14602 * PerViewConstantBufferCsgo_t_1_m14.z), 0.0f, 1.0f)) * PerViewConstantBufferCsgo_t_1_m18.x).xyz, _8892).xyz, _8892.xxx);
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
	        _6805 = _11203;
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
	#endif
	#if (S_TRANSLUCENT == 1)
	#endif
	#if (S_ADDITIVE_BLEND == 1)
	#endif
	
	// SPIR-V reflection failed for backend HLSL:
	// Unsupported builtin in HLSL: 5326
	// 
	// Re-attempting reflection with the GLSL backend.
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (61340 bytes), GLSL reflection with SPIRV-Cross by KhronosGroup
	
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
	    vec3 nInstanceIdx;
	    vec2 _m1;
	    vec3 _m2;
	    vec4 _m3;
	    uvec4 _m4;
	    uint _m5;
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
	
	vec2 _259;
	vec4 _260;
	
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
	    uint _m0[];
	} g_MaterialData_5;
	
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
	    vec4 g_vInvProjRow3;
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
	};
	
	layout(set = 5) uniform SLANG_ParameterGroup_PerViewConstantBuffer_t_natural PerViewConstantBuffer_t;
	
	hitAttributeEXT BuiltInTriangleIntersectionAttributes _22;
	layout(set = 4, binding = 46) uniform texture2D g_bindless_Texture2D_float4[65536];
	layout(set = 4, binding = 29) uniform sampler g_bindless_Sampler[2048];
	layout(location = 0) rayPayloadInEXT Payload_t _21;
	
	void main()
	{
	    vec4 _324 = vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 112u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 116u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 120u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 124u) / 4u]);
	    vec4 _323 = vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 128u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 132u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 136u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 140u) / 4u]);
	    vec2 _322 = vec2(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 144u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 148u) / 4u]);
	    vec3 _321 = vec3(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 208u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 212u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 216u) / 4u]);
	    float _320 = g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 220u) / 4u];
	    vec4 _319 = vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 272u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 276u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 280u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 284u) / 4u]);
	    vec4 _318 = vec4(g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 288u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 292u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 296u) / 4u], g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 300u) / 4u]);
	    bool _317 = g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 308u) / 4u] != 0;
	    bool _316 = g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 312u) / 4u] != 0;
	    uint _315 = g_MaterialData_5._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 348u) / 4u];
	    uint _314 = g_MaterialData_5._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 352u) / 4u];
	    uint _313 = g_MaterialData_5._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 356u) / 4u];
	    uint _312 = g_MaterialData_5._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 360u) / 4u];
	    uint _311 = g_MaterialData_5._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 380u) / 4u];
	    float _310 = g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 384u) / 4u];
	    uvec3 _410;
	    do
	    {
	        if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes.w == 4)
	        {
	            uint _601 = (12u * uint(gl_PrimitiveID)) + uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes.w);
	            _410 = uvec3(g_Indices_1[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._m0[_601 / 4u], g_Indices_1[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._m0[(_601 + 4u) / 4u], g_Indices_1[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._m0[(_601 + 8u) / 4u]);
	            break;
	        }
	        else
	        {
	            uint _576 = (6u * uint(gl_PrimitiveID)) + uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes.w);
	            uint _577 = _576 & 4294967292u;
	            uint _578 = _577 / 4u;
	            uint _582 = (_577 + 4u) / 4u;
	            uint _587 = (g_Indices_1[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._m0[_578] & 4294901760u) >> uint(16);
	            uint _588 = g_Indices_1[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._m0[_582] & 65535u;
	            uvec3 _411;
	            if (_576 == _577)
	            {
	                _411 = uvec3(g_Indices_1[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._m0[_578] & 65535u, _587, _588);
	            }
	            else
	            {
	                _411 = uvec3(_587, _588, (g_Indices_1[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._m0[_582] & 4294901760u) >> uint(16));
	            }
	            _410 = _411;
	            break;
	        }
	        break;
	    } while(false);
	    uint _616 = uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.x);
	    uvec3 _624 = (uvec3(uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes.x)) * _410) + uvec3(uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes.x));
	    vec3 _405[3];
	    uint _626 = _624.x;
	    _405[0] = vec3(g_Vertices_1[_616]._m0[_626 / 4u], g_Vertices_1[_616]._m0[(_626 + 4u) / 4u], g_Vertices_1[_616]._m0[(_626 + 8u) / 4u]);
	    uint _640 = _624.y;
	    _405[1] = vec3(g_Vertices_1[_616]._m0[_640 / 4u], g_Vertices_1[_616]._m0[(_640 + 4u) / 4u], g_Vertices_1[_616]._m0[(_640 + 8u) / 4u]);
	    uint _654 = _624.z;
	    _405[2] = vec3(g_Vertices_1[_616]._m0[_654 / 4u], g_Vertices_1[_616]._m0[(_654 + 4u) / 4u], g_Vertices_1[_616]._m0[(_654 + 8u) / 4u]);
	    int _406 = 0;
	    VS_INPUT vsInput[3];
	    for (;;)
	    {
	        if (!(_406 < 3))
	        {
	            break;
	        }
	        vsInput[_406].nInstanceIdx = _405[_406];
	        _406++;
	        continue;
	    }
	    vec2 _407[3];
	    _407[0] = vec2(0.0);
	    _407[1] = vec2(0.0);
	    _407[2] = vec2(0.0);
	    if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].y != 0)
	    {
	        ivec4 _404 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers;
	        uint _697 = uint(_404[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].z]);
	        uint _699 = uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].z);
	        ivec4 _402 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes;
	        ivec4 _403 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes;
	        uvec3 _710 = (uvec3(uint(_402[_699])) * _410) + uvec3(uint(_403[_699]) + uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].x));
	        if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].y == 16)
	        {
	            uint _845 = _710.x;
	            _407[0] = vec2(g_Vertices_1[_697]._m0[_845 / 4u], g_Vertices_1[_697]._m0[(_845 + 4u) / 4u]);
	            uint _854 = _710.y;
	            _407[1] = vec2(g_Vertices_1[_697]._m0[_854 / 4u], g_Vertices_1[_697]._m0[(_854 + 4u) / 4u]);
	            uint _863 = _710.z;
	            _407[2] = vec2(g_Vertices_1[_697]._m0[_863 / 4u], g_Vertices_1[_697]._m0[(_863 + 4u) / 4u]);
	        }
	        else
	        {
	            if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].y == 34)
	            {
	                uint _816 = _710.x / 4u;
	                _407[0] = vec2(uint16BitsToFloat16(u16vec2(uvec2(g_Vertices_3[_697]._m0[_816], g_Vertices_3[_697]._m0[_816] >> uint(16)) & uvec2(65535u))));
	                uint _826 = _710.y / 4u;
	                _407[1] = vec2(uint16BitsToFloat16(u16vec2(uvec2(g_Vertices_3[_697]._m0[_826], g_Vertices_3[_697]._m0[_826] >> uint(16)) & uvec2(65535u))));
	                uint _836 = _710.z / 4u;
	                _407[2] = vec2(uint16BitsToFloat16(u16vec2(uvec2(g_Vertices_3[_697]._m0[_836], g_Vertices_3[_697]._m0[_836] >> uint(16)) & uvec2(65535u))));
	            }
	            else
	            {
	                if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].y == 37)
	                {
	                    uint _723 = _710.x / 4u;
	                    uint _727 = (g_Vertices_3[_697]._m0[_723] & 65535u);
	                    int _401;
	                    if (_727 > 32767u)
	                    {
	                        _401 = int(4294901760u | _727);
	                    }
	                    else
	                    {
	                        _401 = int(_727);
	                    }
	                    uint _740 = (g_Vertices_3[_697]._m0[_723] & 4294901760u) >> uint(16);
	                    int _400;
	                    if (_740 > 32767u)
	                    {
	                        _400 = int(4294901760u | _740);
	                    }
	                    else
	                    {
	                        _400 = int(_740);
	                    }
	                    _407[0] = vec2(max(float(_401) * 3.0518509447574615478515625e-05, -1.0), max(float(_400) * 3.0518509447574615478515625e-05, -1.0));
	                    uint _754 = _710.y / 4u;
	                    uint _758 = (g_Vertices_3[_697]._m0[_754] & 65535u);
	                    int _399;
	                    if (_758 > 32767u)
	                    {
	                        _399 = int(4294901760u | _758);
	                    }
	                    else
	                    {
	                        _399 = int(_758);
	                    }
	                    uint _771 = (g_Vertices_3[_697]._m0[_754] & 4294901760u) >> uint(16);
	                    int _398;
	                    if (_771 > 32767u)
	                    {
	                        _398 = int(4294901760u | _771);
	                    }
	                    else
	                    {
	                        _398 = int(_771);
	                    }
	                    _407[1] = vec2(max(float(_399) * 3.0518509447574615478515625e-05, -1.0), max(float(_398) * 3.0518509447574615478515625e-05, -1.0));
	                    uint _785 = _710.z / 4u;
	                    uint _789 = (g_Vertices_3[_697]._m0[_785] & 65535u);
	                    int _397;
	                    if (_789 > 32767u)
	                    {
	                        _397 = int(4294901760u | _789);
	                    }
	                    else
	                    {
	                        _397 = int(_789);
	                    }
	                    uint _802 = (g_Vertices_3[_697]._m0[_785] & 4294901760u) >> uint(16);
	                    int _396;
	                    if (_802 > 32767u)
	                    {
	                        _396 = int(4294901760u | _802);
	                    }
	                    else
	                    {
	                        _396 = int(_802);
	                    }
	                    _407[2] = vec2(max(float(_397) * 3.0518509447574615478515625e-05, -1.0), max(float(_396) * 3.0518509447574615478515625e-05, -1.0));
	                }
	            }
	        }
	    }
	    _406 = 0;
	    for (;;)
	    {
	        if (!(_406 < 3))
	        {
	            break;
	        }
	        vsInput[_406]._m1 = _407[_406];
	        _406++;
	        continue;
	    }
	    vec3 _408[3];
	    vec4 _409[3];
	    do
	    {
	        if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.y != 0)
	        {
	            ivec4 _382 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers;
	            uint _905 = uint(_382[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.z]);
	            uint _907 = uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.z);
	            ivec4 _380 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes;
	            ivec4 _381 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes;
	            uvec3 _918 = (uvec3(uint(_380[_907])) * _410) + uvec3(uint(_381[_907]) + uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.x));
	            if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.y == 6)
	            {
	                uint _1449 = _918.x;
	                _408[0] = vec3(g_Vertices_1[_905]._m0[_1449 / 4u], g_Vertices_1[_905]._m0[(_1449 + 4u) / 4u], g_Vertices_1[_905]._m0[(_1449 + 8u) / 4u]);
	                uint _1463 = _918.y;
	                _408[1] = vec3(g_Vertices_1[_905]._m0[_1463 / 4u], g_Vertices_1[_905]._m0[(_1463 + 4u) / 4u], g_Vertices_1[_905]._m0[(_1463 + 8u) / 4u]);
	                uint _1477 = _918.z;
	                _408[2] = vec3(g_Vertices_1[_905]._m0[_1477 / 4u], g_Vertices_1[_905]._m0[(_1477 + 4u) / 4u], g_Vertices_1[_905]._m0[(_1477 + 8u) / 4u]);
	            }
	            else
	            {
	                if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.y == 17)
	                {
	                    uint _1182 = _918.x;
	                    uvec2 _1190 = uvec2(g_Vertices_3[_905]._m0[_1182 / 4u], g_Vertices_3[_905]._m0[(_1182 + 4u) / 4u]);
	                    uint _1191 = _918.y;
	                    uvec2 _280 = uvec2(g_Vertices_3[_905]._m0[_1191 / 4u], g_Vertices_3[_905]._m0[(_1191 + 4u) / 4u]);
	                    uint _1200 = _918.z;
	                    uvec2 _279 = uvec2(g_Vertices_3[_905]._m0[_1200 / 4u], g_Vertices_3[_905]._m0[(_1200 + 4u) / 4u]);
	                    uint _1212 = _1190.x;
	                    uint _1221 = _1190.y;
	                    vec2 _1231 = ((vec2(float((_1212) & 65535u), float((_1212 >> 16u) & 65535u)) * vec2(1.525902189314365386962890625e-05)) * 2.0) - vec2(1.0);
	                    float _1232 = _1231.x;
	                    float _1237 = (1.0 - abs(_1232)) - abs(_1231.y);
	                    vec3 _1238 = vec3(_1232, _1231.y, _1237);
	                    float _1240 = saturate(-_1237);
	                    vec2 _1246 = _1231 + mix(vec2(_1240), vec2(-_1240), greaterThanEqual(_1231, vec2(0.0)));
	                    _1238.x = _1246.x;
	                    _1238.y = _1246.y;
	                    vec3 _390 = normalize(_1238);
	                    vec2 _1253 = ((vec2(float((_1221 >> uint(1)) & 32767u), float((_1221 >> 16u) & 32767u)) * vec2(3.0518509447574615478515625e-05)) * 2.0) - vec2(1.0);
	                    float _1254 = _1253.x;
	                    float _1259 = (1.0 - abs(_1254)) - abs(_1253.y);
	                    vec3 _1260 = vec3(_1254, _1253.y, _1259);
	                    float _1262 = saturate(-_1259);
	                    vec2 _1268 = _1253 + mix(vec2(_1262), vec2(-_1262), greaterThanEqual(_1253, vec2(0.0)));
	                    _1260.x = _1268.x;
	                    _1260.y = _1268.y;
	                    vec3 _389 = normalize(_1260);
	                    float _370;
	                    if ((_1221 & 1u) != 0u)
	                    {
	                        _370 = 1.0;
	                    }
	                    else
	                    {
	                        _370 = -1.0;
	                    }
	                    _408[0] = _390;
	                    _409[0].w = _370;
	                    _409[0].x = _389.x;
	                    _409[0].y = _389.y;
	                    _409[0].z = _389.z;
	                    vec2 _1311 = ((vec2(float((_280.x) & 65535u), float((_280.x >> 16u) & 65535u)) * vec2(1.525902189314365386962890625e-05)) * 2.0) - vec2(1.0);
	                    float _1312 = _1311.x;
	                    float _1317 = (1.0 - abs(_1312)) - abs(_1311.y);
	                    vec3 _1318 = vec3(_1312, _1311.y, _1317);
	                    float _1320 = saturate(-_1317);
	                    vec2 _1326 = _1311 + mix(vec2(_1320), vec2(-_1320), greaterThanEqual(_1311, vec2(0.0)));
	                    _1318.x = _1326.x;
	                    _1318.y = _1326.y;
	                    vec3 _392 = normalize(_1318);
	                    vec2 _1333 = ((vec2(float((_280.y >> uint(1)) & 32767u), float((_280.y >> 16u) & 32767u)) * vec2(3.0518509447574615478515625e-05)) * 2.0) - vec2(1.0);
	                    float _1334 = _1333.x;
	                    float _1339 = (1.0 - abs(_1334)) - abs(_1333.y);
	                    vec3 _1340 = vec3(_1334, _1333.y, _1339);
	                    float _1342 = saturate(-_1339);
	                    vec2 _1348 = _1333 + mix(vec2(_1342), vec2(-_1342), greaterThanEqual(_1333, vec2(0.0)));
	                    _1340.x = _1348.x;
	                    _1340.y = _1348.y;
	                    vec3 _391 = normalize(_1340);
	                    float _369;
	                    if ((_280.y & 1u) != 0u)
	                    {
	                        _369 = 1.0;
	                    }
	                    else
	                    {
	                        _369 = -1.0;
	                    }
	                    _408[1] = _392;
	                    _409[1].w = _369;
	                    _409[1].x = _391.x;
	                    _409[1].y = _391.y;
	                    _409[1].z = _391.z;
	                    vec2 _1391 = ((vec2(float((_279.x) & 65535u), float((_279.x >> 16u) & 65535u)) * vec2(1.525902189314365386962890625e-05)) * 2.0) - vec2(1.0);
	                    float _1392 = _1391.x;
	                    float _1397 = (1.0 - abs(_1392)) - abs(_1391.y);
	                    vec3 _1398 = vec3(_1392, _1391.y, _1397);
	                    float _1400 = saturate(-_1397);
	                    vec2 _1406 = _1391 + mix(vec2(_1400), vec2(-_1400), greaterThanEqual(_1391, vec2(0.0)));
	                    _1398.x = _1406.x;
	                    _1398.y = _1406.y;
	                    vec3 _394 = normalize(_1398);
	                    vec2 _1413 = ((vec2(float((_279.y >> uint(1)) & 32767u), float((_279.y >> 16u) & 32767u)) * vec2(3.0518509447574615478515625e-05)) * 2.0) - vec2(1.0);
	                    float _1414 = _1413.x;
	                    float _1419 = (1.0 - abs(_1414)) - abs(_1413.y);
	                    vec3 _1420 = vec3(_1414, _1413.y, _1419);
	                    float _1422 = saturate(-_1419);
	                    vec2 _1428 = _1413 + mix(vec2(_1422), vec2(-_1422), greaterThanEqual(_1413, vec2(0.0)));
	                    _1420.x = _1428.x;
	                    _1420.y = _1428.y;
	                    vec3 _393 = normalize(_1420);
	                    float _368;
	                    if ((_279.y & 1u) != 0u)
	                    {
	                        _368 = 1.0;
	                    }
	                    else
	                    {
	                        _368 = -1.0;
	                    }
	                    _408[2] = _394;
	                    _409[2].w = _368;
	                    _409[2].x = _393.x;
	                    _409[2].y = _393.y;
	                    _409[2].z = _393.z;
	                    break;
	                }
	                else
	                {
	                    uint _928 = _918.x / 4u;
	                    vec4 _384 = _409[0];
	                    float _943 = (float((g_Vertices_3[_905]._m0[_928] >> 12u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _946 = (float((g_Vertices_3[_905]._m0[_928] >> 22u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _950 = (1.0 - abs(_943)) - abs(_946);
	                    vec3 _951 = vec3(_943, _946, _950);
	                    float _953 = saturate(-_950);
	                    vec2 _954 = vec2(_943, _946);
	                    vec2 _960 = _954 + mix(vec2(_953), vec2(-_953), greaterThanEqual(_954, vec2(0.0)));
	                    _951.x = _960.x;
	                    _951.y = _960.y;
	                    vec3 _965 = normalize(_951);
	                    vec3 _383 = _965;
	                    float _966 = _965.z;
	                    float _377;
	                    if (_966 >= 0.0)
	                    {
	                        _377 = 1.0;
	                    }
	                    else
	                    {
	                        _377 = -1.0;
	                    }
	                    float _973 = (-1.0) / (_377 + _966);
	                    float _974 = _965.x;
	                    vec3 _378;
	                    vec3 _982 = _378;
	                    _982.x = 1.0 + (((_377 * _974) * _974) * _973);
	                    _982.y = _377 * ((_974 * _965.y) * _973);
	                    _982.z = (-_377) * _974;
	                    _378 = _982;
	                    float _990 = float((g_Vertices_3[_905]._m0[_928] >> uint(1)) & 2047u) * 0.003069460391998291015625;
	                    vec3 _996 = (_982 * cos(_990)) + (cross(_965, _982) * sin(_990));
	                    vec4 _998 = _384;
	                    _998.x = _996.x;
	                    _998.y = _996.y;
	                    _998.z = _996.z;
	                    _384 = _998;
	                    float _379;
	                    if ((g_Vertices_3[_905]._m0[_928] & 1u) == 0u)
	                    {
	                        _379 = -1.0;
	                    }
	                    else
	                    {
	                        _379 = 1.0;
	                    }
	                    vec4 _1009 = _384;
	                    _1009.w = _379;
	                    _384 = _1009;
	                    _408[0] = _383;
	                    _409[0] = _1009;
	                    uint _1013 = _918.y / 4u;
	                    vec4 _386 = _409[1];
	                    float _1028 = (float((g_Vertices_3[_905]._m0[_1013] >> 12u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _1031 = (float((g_Vertices_3[_905]._m0[_1013] >> 22u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _1035 = (1.0 - abs(_1028)) - abs(_1031);
	                    vec3 _1036 = vec3(_1028, _1031, _1035);
	                    float _1038 = saturate(-_1035);
	                    vec2 _1039 = vec2(_1028, _1031);
	                    vec2 _1045 = _1039 + mix(vec2(_1038), vec2(-_1038), greaterThanEqual(_1039, vec2(0.0)));
	                    _1036.x = _1045.x;
	                    _1036.y = _1045.y;
	                    vec3 _1050 = normalize(_1036);
	                    vec3 _385 = _1050;
	                    float _1051 = _1050.z;
	                    float _374;
	                    if (_1051 >= 0.0)
	                    {
	                        _374 = 1.0;
	                    }
	                    else
	                    {
	                        _374 = -1.0;
	                    }
	                    float _1058 = (-1.0) / (_374 + _1051);
	                    float _1059 = _1050.x;
	                    vec3 _375;
	                    vec3 _1067 = _375;
	                    _1067.x = 1.0 + (((_374 * _1059) * _1059) * _1058);
	                    _1067.y = _374 * ((_1059 * _1050.y) * _1058);
	                    _1067.z = (-_374) * _1059;
	                    _375 = _1067;
	                    float _1075 = float((g_Vertices_3[_905]._m0[_1013] >> uint(1)) & 2047u) * 0.003069460391998291015625;
	                    vec3 _1081 = (_1067 * cos(_1075)) + (cross(_1050, _1067) * sin(_1075));
	                    vec4 _1083 = _386;
	                    _1083.x = _1081.x;
	                    _1083.y = _1081.y;
	                    _1083.z = _1081.z;
	                    _386 = _1083;
	                    float _376;
	                    if ((g_Vertices_3[_905]._m0[_1013] & 1u) == 0u)
	                    {
	                        _376 = -1.0;
	                    }
	                    else
	                    {
	                        _376 = 1.0;
	                    }
	                    vec4 _1094 = _386;
	                    _1094.w = _376;
	                    _386 = _1094;
	                    _408[1] = _385;
	                    _409[1] = _1094;
	                    uint _1098 = _918.z / 4u;
	                    vec4 _388 = _409[2];
	                    float _1113 = (float((g_Vertices_3[_905]._m0[_1098] >> 12u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _1116 = (float((g_Vertices_3[_905]._m0[_1098] >> 22u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _1120 = (1.0 - abs(_1113)) - abs(_1116);
	                    vec3 _1121 = vec3(_1113, _1116, _1120);
	                    float _1123 = saturate(-_1120);
	                    vec2 _1124 = vec2(_1113, _1116);
	                    vec2 _1130 = _1124 + mix(vec2(_1123), vec2(-_1123), greaterThanEqual(_1124, vec2(0.0)));
	                    _1121.x = _1130.x;
	                    _1121.y = _1130.y;
	                    vec3 _1135 = normalize(_1121);
	                    vec3 _387 = _1135;
	                    float _1136 = _1135.z;
	                    float _371;
	                    if (_1136 >= 0.0)
	                    {
	                        _371 = 1.0;
	                    }
	                    else
	                    {
	                        _371 = -1.0;
	                    }
	                    float _1143 = (-1.0) / (_371 + _1136);
	                    float _1144 = _1135.x;
	                    vec3 _372;
	                    vec3 _1152 = _372;
	                    _1152.x = 1.0 + (((_371 * _1144) * _1144) * _1143);
	                    _1152.y = _371 * ((_1144 * _1135.y) * _1143);
	                    _1152.z = (-_371) * _1144;
	                    _372 = _1152;
	                    float _1160 = float((g_Vertices_3[_905]._m0[_1098] >> uint(1)) & 2047u) * 0.003069460391998291015625;
	                    vec3 _1166 = (_1152 * cos(_1160)) + (cross(_1135, _1152) * sin(_1160));
	                    vec4 _1168 = _388;
	                    _1168.x = _1166.x;
	                    _1168.y = _1166.y;
	                    _1168.z = _1166.z;
	                    _388 = _1168;
	                    float _373;
	                    if ((g_Vertices_3[_905]._m0[_1098] & 1u) == 0u)
	                    {
	                        _373 = -1.0;
	                    }
	                    else
	                    {
	                        _373 = 1.0;
	                    }
	                    vec4 _1179 = _388;
	                    _1179.w = _373;
	                    _388 = _1179;
	                    _408[2] = _387;
	                    _409[2] = _1179;
	                    break;
	                }
	                break;
	            }
	        }
	        else
	        {
	            _408[0] = vec3(0.0);
	            _408[1] = vec3(0.0);
	            _408[2] = vec3(0.0);
	        }
	        if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTangentFieldInfo.y != 0)
	        {
	            ivec4 _395 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers;
	            uint _1502 = uint(_395[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTangentFieldInfo.z]);
	            uint _1504 = uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTangentFieldInfo.z);
	            ivec4 _366 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes;
	            ivec4 _367 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes;
	            uvec3 _1515 = (uvec3(uint(_366[_1504])) * _410) + uvec3(uint(_367[_1504]) + uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTangentFieldInfo.x));
	            uint _1517 = _1515.x;
	            _409[0] = vec4(g_Vertices_1[_1502]._m0[_1517 / 4u], g_Vertices_1[_1502]._m0[(_1517 + 4u) / 4u], g_Vertices_1[_1502]._m0[(_1517 + 8u) / 4u], g_Vertices_1[_1502]._m0[(_1517 + 12u) / 4u]);
	            uint _1535 = _1515.y;
	            _409[1] = vec4(g_Vertices_1[_1502]._m0[_1535 / 4u], g_Vertices_1[_1502]._m0[(_1535 + 4u) / 4u], g_Vertices_1[_1502]._m0[(_1535 + 8u) / 4u], g_Vertices_1[_1502]._m0[(_1535 + 12u) / 4u]);
	            uint _1553 = _1515.z;
	            _409[2] = vec4(g_Vertices_1[_1502]._m0[_1553 / 4u], g_Vertices_1[_1502]._m0[(_1553 + 4u) / 4u], g_Vertices_1[_1502]._m0[(_1553 + 8u) / 4u], g_Vertices_1[_1502]._m0[(_1553 + 12u) / 4u]);
	        }
	        else
	        {
	            _409[0] = vec4(0.0);
	            _409[1] = vec4(0.0);
	            _409[2] = vec4(0.0);
	        }
	        break;
	    } while(false);
	    _406 = 0;
	    for (;;)
	    {
	        if (!(_406 < 3))
	        {
	            break;
	        }
	        vsInput[_406]._m2 = _408[_406];
	        vsInput[_406]._m3 = _409[_406];
	        _406++;
	        continue;
	    }
	    vec3 _364 = vsInput[0]._m2;
	    vec4 _365;
	    vec4 _1597 = _365;
	    _1597.x = vsInput[0]._m3.x;
	    _1597.y = vsInput[0]._m3.y;
	    _1597.z = vsInput[0]._m3.z;
	    _1597.w = vsInput[0]._m3.w;
	    _365 = _1597;
	    vec4 _1622 = vec4(uvec4((g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 255u), (g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 65280u) >> uint(8), (g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 16711680u) >> uint(16), (g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	    vec4 _363 = _1622;
	    vec3 _1623 = _1622.xyz;
	    vec3 _1624 = _1623 * vec3(0.077399380505084991455078125);
	    vec3 _1627 = pow((_1623 * vec3(0.947867333889007568359375)) + vec3(0.052132703363895416259765625), vec3(2.400000095367431640625));
	    float _360;
	    if (_1622.x <= 0.040449999272823333740234375)
	    {
	        _360 = _1624.x;
	    }
	    else
	    {
	        _360 = _1627.x;
	    }
	    float _361;
	    if (_1622.y <= 0.040449999272823333740234375)
	    {
	        _361 = _1624.y;
	    }
	    else
	    {
	        _361 = _1627.y;
	    }
	    float _362;
	    if (_1622.z <= 0.040449999272823333740234375)
	    {
	        _362 = _1624.z;
	    }
	    else
	    {
	        _362 = _1627.z;
	    }
	    vec3 _1652 = vec3(_360, _361, _362);
	    vec4 _1654 = _363;
	    _1654.x = _1652.x;
	    _1654.y = _1652.y;
	    _1654.z = _1652.z;
	    _363 = _1654;
	    vec4 _282;
	    vec4 _1661 = _282;
	    _1661.x = _1654.x;
	    _1661.y = _1654.y;
	    _1661.z = _1654.z;
	    _1661.w = _1654.w;
	    _282 = _1661;
	    mat3x4 _1672 = transpose(gl_WorldToObjectEXT);
	    mat3 _359;
	    mat3 _1675 = _359;
	    _1675[0] = _1672[0].xyz;
	    _1675[1] = _1672[1].xyz;
	    _1675[2] = _1672[2].xyz;
	    _359 = _1675;
	    vec3 _1684 = normalize(_1675 * _364.xyz);
	    vec3 _283;
	    vec3 _1686 = _283;
	    _1686.x = _1684.x;
	    _1686.y = _1684.y;
	    _1686.z = _1684.z;
	    _283 = _1686;
	    mat3x4 _1698 = transpose(gl_WorldToObjectEXT);
	    mat3 _358;
	    mat3 _1701 = _358;
	    _1701[0] = _1698[0].xyz;
	    _1701[1] = _1698[1].xyz;
	    _1701[2] = _1698[2].xyz;
	    _358 = _1701;
	    vec3 _1710 = normalize(_1701 * _365.xyz);
	    vec4 _281;
	    vec4 _1712 = _281;
	    _1712.x = _1710.x;
	    _1712.y = _1710.y;
	    _1712.z = _1710.z;
	    _1712.w = _365.w;
	    _281 = _1712;
	    vec4 _1721 = vsInput[0]._m1.xyxy;
	    vec2 _284;
	    vec2 _1722 = _284;
	    vec4 _1735 = _1721;
	    _1735.x = dot(_1721.xy, _324.xy) + _324.w;
	    _1735.y = dot(_1721.xy, _323.xy) + _323.w;
	    vec2 _1743 = _1735.xy + (_322.xy * PerViewConstantBuffer_t.g_flGameTime);
	    vec4 _1745 = _1735;
	    _1745.x = _1743.x;
	    _1745.y = _1743.y;
	    vec3 _1751 = mix(vec3(1.0), _1661.xyz, vec3(_320));
	    vec4 _1753 = _1661;
	    _1753.x = _1751.x;
	    _1753.y = _1751.y;
	    _1753.z = _1751.z;
	    vec3 _1761 = _1753.xyz * _321.xyz;
	    vec4 _1763 = _1753;
	    _1763.x = _1761.x;
	    _1763.y = _1761.y;
	    _1763.z = _1761.z;
	    _1722.x = dot(vsInput[0]._m1.xy, _319.xy) + _319.w;
	    _1722.y = dot(vsInput[0]._m1.xy, _318.xy) + _318.w;
	    vec2 _278 = _1722;
	    vec3 _277 = vec4(vsInput[0].nInstanceIdx.xyz, 1.0) * transpose(gl_ObjectToWorldEXT);
	    vec3 _276 = _1686;
	    vec4 _275 = _1745;
	    vec4 _274 = _1763;
	    vec4 _273 = _1712;
	    vec3 _356 = vsInput[1]._m2;
	    vec4 _357;
	    vec4 _1787 = _357;
	    _1787.x = vsInput[1]._m3.x;
	    _1787.y = vsInput[1]._m3.y;
	    _1787.z = vsInput[1]._m3.z;
	    _1787.w = vsInput[1]._m3.w;
	    _357 = _1787;
	    vec4 _1812 = vec4(uvec4((g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 255u), (g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 65280u) >> uint(8), (g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 16711680u) >> uint(16), (g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	    vec4 _355 = _1812;
	    vec3 _1813 = _1812.xyz;
	    vec3 _1814 = _1813 * vec3(0.077399380505084991455078125);
	    vec3 _1817 = pow((_1813 * vec3(0.947867333889007568359375)) + vec3(0.052132703363895416259765625), vec3(2.400000095367431640625));
	    float _352;
	    if (_1812.x <= 0.040449999272823333740234375)
	    {
	        _352 = _1814.x;
	    }
	    else
	    {
	        _352 = _1817.x;
	    }
	    float _353;
	    if (_1812.y <= 0.040449999272823333740234375)
	    {
	        _353 = _1814.y;
	    }
	    else
	    {
	        _353 = _1817.y;
	    }
	    float _354;
	    if (_1812.z <= 0.040449999272823333740234375)
	    {
	        _354 = _1814.z;
	    }
	    else
	    {
	        _354 = _1817.z;
	    }
	    vec3 _1842 = vec3(_352, _353, _354);
	    vec4 _1844 = _355;
	    _1844.x = _1842.x;
	    _1844.y = _1842.y;
	    _1844.z = _1842.z;
	    _355 = _1844;
	    vec4 _286;
	    vec4 _1851 = _286;
	    _1851.x = _1844.x;
	    _1851.y = _1844.y;
	    _1851.z = _1844.z;
	    _1851.w = _1844.w;
	    _286 = _1851;
	    mat3x4 _1862 = transpose(gl_WorldToObjectEXT);
	    mat3 _351;
	    mat3 _1865 = _351;
	    _1865[0] = _1862[0].xyz;
	    _1865[1] = _1862[1].xyz;
	    _1865[2] = _1862[2].xyz;
	    _351 = _1865;
	    vec3 _1874 = normalize(_1865 * _356.xyz);
	    vec3 _287;
	    vec3 _1876 = _287;
	    _1876.x = _1874.x;
	    _1876.y = _1874.y;
	    _1876.z = _1874.z;
	    _287 = _1876;
	    mat3x4 _1888 = transpose(gl_WorldToObjectEXT);
	    mat3 _350;
	    mat3 _1891 = _350;
	    _1891[0] = _1888[0].xyz;
	    _1891[1] = _1888[1].xyz;
	    _1891[2] = _1888[2].xyz;
	    _350 = _1891;
	    vec3 _1900 = normalize(_1891 * _357.xyz);
	    vec4 _285;
	    vec4 _1902 = _285;
	    _1902.x = _1900.x;
	    _1902.y = _1900.y;
	    _1902.z = _1900.z;
	    _1902.w = _357.w;
	    _285 = _1902;
	    vec4 _1911 = vsInput[1]._m1.xyxy;
	    vec2 _288;
	    vec2 _1912 = _288;
	    vec4 _1925 = _1911;
	    _1925.x = dot(_1911.xy, _324.xy) + _324.w;
	    _1925.y = dot(_1911.xy, _323.xy) + _323.w;
	    vec2 _1933 = _1925.xy + (_322.xy * PerViewConstantBuffer_t.g_flGameTime);
	    vec4 _1935 = _1925;
	    _1935.x = _1933.x;
	    _1935.y = _1933.y;
	    vec3 _1941 = mix(vec3(1.0), _1851.xyz, vec3(_320));
	    vec4 _1943 = _1851;
	    _1943.x = _1941.x;
	    _1943.y = _1941.y;
	    _1943.z = _1941.z;
	    vec3 _1951 = _1943.xyz * _321.xyz;
	    vec4 _1953 = _1943;
	    _1953.x = _1951.x;
	    _1953.y = _1951.y;
	    _1953.z = _1951.z;
	    _1912.x = dot(vsInput[1]._m1.xy, _319.xy) + _319.w;
	    _1912.y = dot(vsInput[1]._m1.xy, _318.xy) + _318.w;
	    vec2 _272 = _1912;
	    vec3 _271 = vec4(vsInput[1].nInstanceIdx.xyz, 1.0) * transpose(gl_ObjectToWorldEXT);
	    vec3 _270 = _1876;
	    vec4 _269 = _1935;
	    vec4 _268 = _1953;
	    vec4 _267 = _1902;
	    vec3 _348 = vsInput[2]._m2;
	    vec4 _349;
	    vec4 _1977 = _349;
	    _1977.x = vsInput[2]._m3.x;
	    _1977.y = vsInput[2]._m3.y;
	    _1977.z = vsInput[2]._m3.z;
	    _1977.w = vsInput[2]._m3.w;
	    _349 = _1977;
	    vec4 _2002 = vec4(uvec4((g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 255u), (g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 65280u) >> uint(8), (g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 16711680u) >> uint(16), (g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	    vec4 _347 = _2002;
	    vec3 _2003 = _2002.xyz;
	    vec3 _2004 = _2003 * vec3(0.077399380505084991455078125);
	    vec3 _2007 = pow((_2003 * vec3(0.947867333889007568359375)) + vec3(0.052132703363895416259765625), vec3(2.400000095367431640625));
	    float _344;
	    if (_2002.x <= 0.040449999272823333740234375)
	    {
	        _344 = _2004.x;
	    }
	    else
	    {
	        _344 = _2007.x;
	    }
	    float _345;
	    if (_2002.y <= 0.040449999272823333740234375)
	    {
	        _345 = _2004.y;
	    }
	    else
	    {
	        _345 = _2007.y;
	    }
	    float _346;
	    if (_2002.z <= 0.040449999272823333740234375)
	    {
	        _346 = _2004.z;
	    }
	    else
	    {
	        _346 = _2007.z;
	    }
	    vec3 _2032 = vec3(_344, _345, _346);
	    vec4 _2034 = _347;
	    _2034.x = _2032.x;
	    _2034.y = _2032.y;
	    _2034.z = _2032.z;
	    _347 = _2034;
	    vec4 _290;
	    vec4 _2041 = _290;
	    _2041.x = _2034.x;
	    _2041.y = _2034.y;
	    _2041.z = _2034.z;
	    _2041.w = _2034.w;
	    _290 = _2041;
	    mat3x4 _2052 = transpose(gl_WorldToObjectEXT);
	    mat3 _343;
	    mat3 _2055 = _343;
	    _2055[0] = _2052[0].xyz;
	    _2055[1] = _2052[1].xyz;
	    _2055[2] = _2052[2].xyz;
	    _343 = _2055;
	    vec3 _2064 = normalize(_2055 * _348.xyz);
	    vec3 _291;
	    vec3 _2066 = _291;
	    _2066.x = _2064.x;
	    _2066.y = _2064.y;
	    _2066.z = _2064.z;
	    _291 = _2066;
	    vec3 _2074 = vec4(vsInput[2].nInstanceIdx.xyz, 1.0) * transpose(gl_ObjectToWorldEXT);
	    mat3x4 _2078 = transpose(gl_WorldToObjectEXT);
	    mat3 _342;
	    mat3 _2081 = _342;
	    _2081[0] = _2078[0].xyz;
	    _2081[1] = _2078[1].xyz;
	    _2081[2] = _2078[2].xyz;
	    _342 = _2081;
	    vec3 _2090 = normalize(_2081 * _349.xyz);
	    vec4 _289;
	    vec4 _2092 = _289;
	    _2092.x = _2090.x;
	    _2092.y = _2090.y;
	    _2092.z = _2090.z;
	    _2092.w = _349.w;
	    _289 = _2092;
	    vec4 _2114;
	    _2114.x = dot(vsInput[2]._m1.xyxy.xy, _324.xy) + _324.w;
	    _2114.y = dot(vsInput[2]._m1.xyxy.xy, _323.xy) + _323.w;
	    vec2 _2122 = _2114.xy + (_322.xy * PerViewConstantBuffer_t.g_flGameTime);
	    vec4 _2124;
	    _2124.x = _2122.x;
	    _2124.y = _2122.y;
	    vec3 _2130 = mix(vec3(1.0), _2041.xyz, vec3(_320));
	    vec4 _2132;
	    _2132.x = _2130.x;
	    _2132.y = _2130.y;
	    _2132.z = _2130.z;
	    vec3 _2140 = _2132.xyz * _321.xyz;
	    vec4 _2142;
	    _2142.x = _2140.x;
	    _2142.y = _2140.y;
	    _2142.z = _2140.z;
	    vec2 _2159;
	    _2159.x = dot(vsInput[2]._m1.xy, _319.xy) + _319.w;
	    _2159.y = dot(vsInput[2]._m1.xy, _318.xy) + _318.w;
	    vec3 _266 = _2074;
	    vec3 _265 = _2066;
	    vec3 _2182 = ((_276 * ((1.0 - _22.barycentrics.x) - _22.barycentrics.y)) + (_270 * _22.barycentrics.x)) + (_2066 * _22.barycentrics.y);
	    bool _2188 = gl_HitKindEXT == 254u;
	    vec4 _2197 = ((_275 * ((1.0 - _22.barycentrics.x) - _22.barycentrics.y)) + (_269 * _22.barycentrics.x)) + (_2124 * _22.barycentrics.y);
	    vec4 _2215 = ((_273 * ((1.0 - _22.barycentrics.x) - _22.barycentrics.y)) + (_267 * _22.barycentrics.x)) + (_2092 * _22.barycentrics.y);
	    vec2 _309 = vec2(0.5);
	    float _308 = 0.0;
	    vec3 _307 = vec3(0.0);
	    float _306 = 0.039999999105930328369140625;
	    vec3 _305 = vec3(0.0);
	    bool _302 = false;
	    vec3 _304 = _2182.xyz;
	    vec3 _303 = normalize(cross(_271 - _277, _2074 - _277));
	    bool _340;
	    if (_316)
	    {
	        _340 = !_317;
	    }
	    else
	    {
	        _340 = false;
	    }
	    if (_340)
	    {
	        float _341;
	        if (_2188)
	        {
	            _341 = 1.0;
	        }
	        else
	        {
	            _341 = -1.0;
	        }
	        _304 *= _341;
	        if (_2188)
	        {
	            _341 = 1.0;
	        }
	        else
	        {
	            _341 = -1.0;
	        }
	        _303 *= _341;
	        _302 = !_2188;
	    }
	    vec3 _2248 = _304;
	    vec3 _2249 = normalize(_2248);
	    _304 = _2249;
	    vec2 _300 = _309;
	    float _299 = _308;
	    vec3 _298 = _307;
	    float _297 = _306;
	    vec3 _296 = _305;
	    vec3 _295 = _2249;
	    vec3 _294 = _303;
	    bool _293 = _302;
	    vec4 _2263 = textureLod(sampler2D(g_bindless_Texture2D_float4[_313], g_bindless_Sampler[_314]), _2197.xy, 0.0);
	    vec3 _2264 = _2263.xyz;
	    vec3 _301 = mix(_2264, _2264 * (((_274 * ((1.0 - _22.barycentrics.x) - _22.barycentrics.y)) + (_268 * _22.barycentrics.x)) + (_2142 * _22.barycentrics.y)).xyz, vec3(saturate(_2263.w + _310)));
	    _299 = textureLod(sampler2D(g_bindless_Texture2D_float4[_311], g_bindless_Sampler[_315]), _2197.xy, 0.0).y;
	    vec4 _2287 = textureLod(sampler2D(g_bindless_Texture2D_float4[_312], g_bindless_Sampler[_315]), (((_278 * ((1.0 - _22.barycentrics.x) - _22.barycentrics.y)) + (_272 * _22.barycentrics.x)) + (_2159 * _22.barycentrics.y)).xy, 0.0);
	    float _2288 = _2287.x;
	    float _2289 = _2287.y;
	    float _2291 = (_2288 + _2289) - 1.00392162799835205078125;
	    float _2292 = _2288 - _2289;
	    _300 = _2287.zz;
	    vec3 _338 = normalize(vec3(vec2(_2291, _2292), (1.0 - abs(_2291)) - abs(_2292)));
	    bool _336;
	    if (_316)
	    {
	        _336 = !_317;
	    }
	    else
	    {
	        _336 = false;
	    }
	    if (_336)
	    {
	        float _337;
	        if (_2188)
	        {
	            _337 = 1.0;
	        }
	        else
	        {
	            _337 = -1.0;
	        }
	        _336 = _337 < 0.0;
	    }
	    else
	    {
	        _336 = false;
	    }
	    float _339;
	    if (_336)
	    {
	        _339 = -1.0;
	    }
	    else
	    {
	        _339 = 1.0;
	    }
	    float _2321 = _339;
	    vec3 _2322 = _2182.xyz * _2321;
	    if (_2215.w > 0.0)
	    {
	        _339 = 1.0;
	    }
	    else
	    {
	        _339 = -1.0;
	    }
	    bool _334;
	    if (_316)
	    {
	        _334 = !_317;
	    }
	    else
	    {
	        _334 = false;
	    }
	    if (_334)
	    {
	        float _335;
	        if (_2188)
	        {
	            _335 = 1.0;
	        }
	        else
	        {
	            _335 = -1.0;
	        }
	        _334 = _335 < 0.0;
	    }
	    else
	    {
	        _334 = false;
	    }
	    if (!_334)
	    {
	        vec3 _2352 = _338;
	        _2352.y = -_2352.y;
	        _338 = _2352;
	    }
	    vec3 _2359 = _2215.xyz * _338.x;
	    vec3 _333;
	    vec3 _2361 = _333;
	    _2361.x = _2359.x;
	    _2361.y = _2359.y;
	    _2361.z = _2359.z;
	    vec3 _2371 = _2361.xyz + ((cross(_2322.xyz, _2215.xyz) * _339).xyz * _338.y);
	    vec3 _2373 = _2361;
	    _2373.x = _2371.x;
	    _2373.y = _2371.y;
	    _2373.z = _2371.z;
	    vec3 _2382 = _2373.xyz + (_2322.xyz * _338.z);
	    vec3 _2384 = _2373;
	    _2384.x = _2382.x;
	    _2384.y = _2382.y;
	    _2384.z = _2382.z;
	    _333 = _2384;
	    _21._m5 = int(uint(gl_InstanceID));
	    _21._m3 = gl_RayTmaxEXT;
	    _21._m1 = _294;
	    _21._m2 = _295;
	    vec3 _325[3] = vec3[](_276, _270, _265);
	    vec3 _326[3] = vec3[](_277, _271, _266);
	    vec3 _2425 = ((_277 * ((1.0 - _22.barycentrics.x) - _22.barycentrics.y)) + (_271 * _22.barycentrics.x)) + (_266 * _22.barycentrics.y);
	    vec3 _327[3];
	    _327[0] = _2425 - (_276 * dot(_2425 - _277, _276));
	    _327[1] = _2425 - (_270 * dot(_2425 - _271, _270));
	    _327[2] = _2425 - (_265 * dot(_2425 - _266, _265));
	    vec3 _2453 = ((_327[0] * ((1.0 - _22.barycentrics.x) - _22.barycentrics.y)) + (_327[1] * _22.barycentrics.x)) + (_327[2] * _22.barycentrics.y);
	    vec3 _328[3];
	    _328[0] = cross(_277 - _271, _21._m1);
	    _328[1] = cross(_271 - _266, _21._m1);
	    _328[2] = cross(_266 - _277, _21._m1);
	    float _329 = dot(_2453 - _2425, _21._m1);
	    vec3 _330 = _2453;
	    int _331 = 0;
	    for (;;)
	    {
	        bool _2469_ladder_break = false;
	        do
	        {
	            if (!(_331 < 3))
	            {
	                _2469_ladder_break = true;
	                break;
	            }
	            if (_329 > 0.00999999977648258209228515625)
	            {
	                _2469_ladder_break = true;
	                break;
	            }
	            if (dot(_328[_331], _328[_331]) == 0.0)
	            {
	                break;
	            }
	            _328[_331] = normalize(_328[_331]);
	            int _332 = 0;
	            for (;;)
	            {
	                if (!(_332 < 3))
	                {
	                    break;
	                }
	                vec3 _2507 = _325[_332] - (_328[_331] * dot(_328[_331], _325[_332]));
	                _327[_332] = _2425 - (_2507 * dot(_2425 - _326[_332], _2507));
	                _332++;
	                continue;
	            }
	            vec3 _2531 = ((_327[0] * ((1.0 - _22.barycentrics.x) - _22.barycentrics.y)) + (_327[1] * _22.barycentrics.x)) + (_327[2] * _22.barycentrics.y);
	            _329 = dot(_2531 - _2425, _21._m1);
	            _330 = _2531;
	            break;
	        } while(false);
	        if (_2469_ladder_break)
	        {
	            break;
	        }
	        _331++;
	        continue;
	    }
	    if (!(_329 > 0.00999999977648258209228515625))
	    {
	        _330 = vec3(3.4028234663852885981170418348452e+38);
	    }
	    _21.material = _330;
	    _21._m6 = _293;
	    f16vec3 _2544 = f16vec3(vec3(0.0));
	    _21._m7 = MaterialDataMinimal_t(_2544, float16_t(0.0), f16vec3(vec3(1.0, 0.0, 1.0)), float16_t(1.0), _2544, float16_t(0.040008544921875), 0u, f16vec4(ivec4(0)));
	    _21._m7.vMaterialBits = f16vec3(normalize(_2384.xyz));
	    _21._m7._m2 = f16vec3(_301);
	    _21._m7._m4 = f16vec3(_298);
	    _21._m7._m5 = float16_t(_297);
	    _21._m7._m1 = float16_t(_299);
	    _21._m7._m3 = float16_t(dot(_300, vec2(0.5)));
	    if (any(greaterThan(_296, vec3(0.0))))
	    {
	        f16vec4 _2573 = _21._m7._m7;
	        f16vec3 _2576 = f16vec3(_296);
	        _2573.x = _2576.x;
	        _2573.y = _2576.y;
	        _2573.z = _2576.z;
	        _21._m7 = MaterialDataMinimal_t(_21._m7.vMaterialBits, _21._m7._m1, _21._m7._m2, _21._m7._m3, _21._m7._m4, _21._m7._m5, (_21._m7._m6 & 4294901760u) | 1u, _2573);
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
