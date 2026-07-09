//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "uber shader with lots of configurability";
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
	Feature( F_ALPHA_TEST, 0..1, "Translucent" );
	Feature( F_TRANSLUCENT, 0..1, "Translucent" );
	Feature( F_ADDITIVE_BLEND, 0..1, "Translucent" );
	Feature( F_TINT_MASK, 0..1, "Per-Instance Tint Mask" );
	Feature( F_ANISOTROPIC_GLOSS, 0..1, "PBR" );
	Feature( F_SELF_ILLUM, 0..1, "PBR" );
	Feature( F_DETAIL_TEXTURE, 0..4 (0="None", 1="Mod2X", 2="Overlay", 3="Normals", 4="Overlay and Normals"), "Detail Texture" );
	Feature( F_METALNESS_TEXTURE, 0..1, "PBR" );
	Feature( F_SECONDARY_UV, 0..1, "Secondary UV" );
	Feature( F_TEXTURE_ANIMATION, 0..1, "Animation" );
	Feature( F_TEXTURE_ANIMATION_MODE, 0..2 (0="Sequential", 1="Random", 2="Scripted"), "Animation" );
	Feature( F_PRE_BAKED_VERTEX_ANIMATION, 0..1, "Animation" );
	Feature( F_TRANSMISSIVE_BACKFACE_NDOTL, 0..1, "PBR" );
	Feature( F_USE_ALBEDO_FOR_TRANSMISSIVE, 0..1, "PBR" );
	Feature( F_DISABLE_TRANSMISSIVE_SHADOWS, 0..1, "PBR" );
	Feature( F_CLOTH_SHADING, 0..1, "PBR" );
	Feature( F_DECAL_TEXTURE, 0..1, "Decal Texture" );
	Feature( F_DECAL_BLEND_MODE, 0..1, "Decal Blend Mode" );
	Feature( F_PAINT_VERTEX_COLORS, 0..1, "Vertex Color" );
	Feature( F_DEPTH_BIAS, 0..1, "Z-Buffering" );
	Feature( F_OCCLUSION_CULLING_BOUNDS_SCALE, 0..1, "Z-Buffering" );
	Feature( F_IGNORE_FACE_NORMALS_FOR_LIGHTING, 0..1, "Lightmapping" );
	FeatureRule( Requires( F_DONT_FLIP_BACKFACE_NORMALS, F_RENDER_BACKFACES ), "Only applies to backfaces" );
	FeatureRule( Allow1( F_ALPHA_TEST, F_TRANSLUCENT ), "Translucent and Alpha Test are not compatible" );
	FeatureRule( Requires( F_ADDITIVE_BLEND, F_TRANSLUCENT ), "Requires translucency" );
	FeatureRule( Allow1( F_TRANSLUCENT, F_DO_NOT_CAST_SHADOWS ), "Translucent and Do Not Cast Shadows are not compatible" );
	FeatureRule( Allow1( F_ANISOTROPIC_GLOSS, F_ADDITIVE_BLEND ), "Anisotropic Gloss and Additive Blend are incompatible" );
	FeatureRule( Allow1( F_DETAIL_TEXTURE, F_SELF_ILLUM ), "Detail Texture and Self Illum are not compatible" );
	FeatureRule( Allow1( F_DETAIL_TEXTURE, F_ANISOTROPIC_GLOSS ), "Detail Texture and Anisotropic Gloss are not compatible" );
	FeatureRule( Allow1( F_DETAIL_TEXTURE, F_ADDITIVE_BLEND ), "Detail Texture and Additive Blend are not compatible" );
	FeatureRule( Allow1( F_METALNESS_TEXTURE, F_ADDITIVE_BLEND ), "Metalness Texture and Additive Blend are not compatible" );
	FeatureRule( Requires( F_TEXTURE_ANIMATION_MODE, F_TEXTURE_ANIMATION=1 ), "Texture Animation Mode requires Texture Animation On" );
	FeatureRule( Allow1( F_PRE_BAKED_VERTEX_ANIMATION, F_TEXTURE_ANIMATION ), "Pre Baked Vertex Animation and Texture Animation are not compatible" );
	FeatureRule( Allow1( F_TRANSMISSIVE_BACKFACE_NDOTL, F_DETAIL_TEXTURE ), "Transmissive Backface Ndotl and Detail Texture are not compatible" );
	FeatureRule( Allow1( F_TRANSMISSIVE_BACKFACE_NDOTL, F_PRE_BAKED_VERTEX_ANIMATION ), "Transmissive Backface Ndotl and Pre Baked Vertex Animation are not compatible" );
	FeatureRule( Allow1( F_TRANSMISSIVE_BACKFACE_NDOTL, F_ADDITIVE_BLEND ), "Transmissive Backface Ndotl and Additive Blend are not compatible" );
	FeatureRule( ChildOf( F_USE_ALBEDO_FOR_TRANSMISSIVE, F_TRANSMISSIVE_BACKFACE_NDOTL ), "Use Albedo for Transmissive requires Transmissive Backface Ndotl" );
	FeatureRule( ChildOf( F_DISABLE_TRANSMISSIVE_SHADOWS, F_TRANSMISSIVE_BACKFACE_NDOTL ), "Disable Transmissive Shadows requires Transmissive Backface Ndotl" );
	FeatureRule( Allow1( F_CLOTH_SHADING, F_ANISOTROPIC_GLOSS ), "Cloth Shading and Anisotropic Gloss are not compatible" );
	FeatureRule( Allow1( F_CLOTH_SHADING, F_METALNESS_TEXTURE ), "Cloth Shading and Metalness Texture are not compatible" );
	FeatureRule( ChildOf( F_DECAL_BLEND_MODE, F_DECAL_TEXTURE ), "Decal Blend Mode requires Decal Texture" );
	FeatureRule( Allow1( F_DECAL_TEXTURE, F_ANISOTROPIC_GLOSS ), "Decal Texture not supported with Anisotropic Gloss to reduce combos." );
	FeatureRule( Allow1( F_DECAL_TEXTURE, F_SELF_ILLUM ), "Decal Texture not supported with Self Ilum to reduce combos." );
	FeatureRule( Allow1( F_DECAL_TEXTURE, F_TEXTURE_ANIMATION ), "Decal Texture not supported with Texture Animation to reduce combos." );
	FeatureRule( Allow1( F_DECAL_TEXTURE, F_PRE_BAKED_VERTEX_ANIMATION ), "Decal Texture not supported with Pre Baked Vertex Animation to reduce combos." );
	FeatureRule( Allow1( F_DECAL_TEXTURE, F_TRANSMISSIVE_BACKFACE_NDOTL ), "Decal Texture not supported with Transmissive Backface Ndotl to reduce combos." );
	FeatureRule( Allow1( F_DECAL_TEXTURE, F_CLOTH_SHADING ), "Decal Texture not supported with Cloth Shading to reduce combos." );
	FeatureRule( Allow1( F_DISABLE_Z_BUFFERING, F_DEPTH_BIAS ), "Z Bias and Disable Z Buffering are not compatible" );
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
	float2 vTexCoord2                 : TEXCOORD1      < Semantic( LowPrecisionUv1 ); >;           // S_SECONDARY_UV=1
	float2 vLightmapUV                : TEXCOORD3      < Semantic( LightmapUV ); >;                // D_BAKED_LIGHTING_FROM_LIGHTMAP=1
	float4 vTangentUOs_flTangentVSign : TANGENT0       < Semantic( TangentU_SignV ); >;           
	float2 vTexCoord                  : TEXCOORD0      < Semantic( LowPrecisionUv ); >;           
	float2 nInstanceIdx               : TEXCOORD13     < Semantic( InstanceTransformUv ); >;      
};

VS
{
	StaticCombo( S_MODE_TOOLS_VIS, 0..1 );
	StaticCombo( S_DETAIL_TEXTURE, F_DETAIL_TEXTURE );
	StaticCombo( S_SECONDARY_UV, F_SECONDARY_UV );
	StaticCombo( S_TEXTURE_ANIMATION, F_TEXTURE_ANIMATION );
	StaticCombo( S_PRE_BAKED_VERTEX_ANIMATION, F_PRE_BAKED_VERTEX_ANIMATION );
	StaticCombo( S_PAINT_VERTEX_COLORS, F_PAINT_VERTEX_COLORS );
	StaticComboRule( Allow1( S_PRE_BAKED_VERTEX_ANIMATION, S_TEXTURE_ANIMATION ) );
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
	int g_nTextureAnimationMode < UiType(Slider); Expression(F_TEXTURE_ANIMATION_MODE); >;
	StructuredBuffer g_transformBuffer < Attribute("TransformBuffer"); >;
	float2 g_vAnimationInvGrid < UiType(VectorText); Expression(1/g_vAnimationGrid); >;
	float4 g_vDetailTexCoordXform < UiType(VectorText); Expression(v0 = (g_flDetailTexCoordRotation*3.14159)/180;
		v1 = cos(v0);
		v2 = sin(v0);
		v3 = g_vDetailTexCoordScale;
		v3.xxy*float4(v1,-v2,v2,v1)); >;
	float4 g_vTexCoordScaleByModelU < UiType(VectorText); Expression(float4((g_nScaleTexCoordUByModelScaleAxis==1) || 0,(g_nScaleTexCoordUByModelScaleAxis==2) || 0,(g_nScaleTexCoordUByModelScaleAxis==3) || 0,(g_nScaleTexCoordUByModelScaleAxis==0) || 0)); >;
	float4 g_vTexCoordScaleByModelV < UiType(VectorText); Expression(float4((g_nScaleTexCoordVByModelScaleAxis==1) || 0,(g_nScaleTexCoordVByModelScaleAxis==2) || 0,(g_nScaleTexCoordVByModelScaleAxis==3) || 0,(g_nScaleTexCoordVByModelScaleAxis==0) || 0)); >;
	float4 g_vTexCoordXform0 < UiType(VectorText); Expression(v0 = (g_flTexCoordRotation*3.14159)/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v1*g_vTexCoordScale.x,-v2*g_vTexCoordScale.y,0,((g_vTexCoordCenter.x+g_vTexCoordOffset.x)+(v2*g_vTexCoordCenter.y))-(v1*g_vTexCoordCenter.x))); >;
	float4 g_vTexCoordXform1 < UiType(VectorText); Expression(v0 = (g_flTexCoordRotation*3.14159)/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v2*g_vTexCoordScale.x,v1*g_vTexCoordScale.y,0,(g_vTexCoordCenter.y+g_vTexCoordOffset.y)-((v2*g_vTexCoordCenter.x)+(v1*g_vTexCoordCenter.y)))); >;
	
	// Detail Texture
	bool g_bUseSecondaryUvForDetailTexture < Default(1); UiType(CheckBox); UiGroup("Detail Texture, 170"); >;
	float2 g_vDetailTexCoordScale < Default2(1, 1); UiType(VectorText); UiGroup("Detail Texture,80/30"); >;
	float g_flDetailTexCoordRotation < Range(0, 360); UiType(Slider); UiGroup("Detail Texture,80/35"); >;
	float2 g_vDetailTexCoordOffset < Range2(-1, -1, 1, 1); UiType(VectorText); UiGroup("Detail Texture,80/40"); Expression(v0 = (g_flDetailTexCoordRotation*3.14159)/180;
		v1 = cos(v0);
		v2 = sin(v0);
		v3 = g_vDetailTexCoordScale;
		v4 = this;
		(((-.5*v3)*float2(v1-v2,v2+v1))+v4)+.5); >;
	
	// Texture Animation
	int2 g_vAnimationGrid < Default2(1, 1); Range2(1, 1, 64, 64); UiType(VectorText); UiGroup("Texture Animation,12/10"); >;
	int g_nNumAnimationCells < Default(1); Range(1, 4096); UiType(Slider); UiGroup("Texture Animation,12/20"); >;
	float g_flAnimationTimePerFrame < Default(0.1); Range(0, 10); UiType(Slider); UiGroup("Texture Animation,12/30"); >;
	float g_flAnimationTimeOffset < Range(0, 1000); UiType(Slider); UiGroup("Texture Animation,12/40"); >;
	float g_flAnimationFrame < Range(0, 4096); UiType(Slider); UiGroup("Texture Animation,12/50"); >;
	
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
	// SPIR-V source (6552 bytes), GLSL reflection with SPIRV-Cross by KhronosGroup
	
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
	layout(location = 0) out vec3 output_0;
	layout(location = 1) out vec3 output_1;
	layout(location = 2) out vec4 output_2;
	layout(location = 3) centroid out vec4 output_3;
	layout(location = 4) centroid out vec3 output_4;
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
	    output_0 = _12151.xyz - PerViewConstantBufferCsgo_t._m0.xyz;
	    output_1 = _11179;
	    output_2 = _20488;
	    output_3 = _23714;
	    output_4 = _11179;
	    output_5 = vec4(normalize(vec4(vTangentUOs_flTangentVSign.xyz, 0.0) * _21957._m0), vTangentUOs_flTangentVSign.w);
	    output_6 = _20228._m5 & 65535u;
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
	BoolAttribute(SupportsAggregateInstancing, F_TRANSLUCENT==0);
	
	#if (S_PAINT_VERTEX_COLORS == 1)
		BoolAttribute(VertexPaintUIPickColor, true);
		BoolAttribute(VertexPaintUIPickColorAlpha, (F_ALPHA_TEST==1) || (F_TRANSLUCENT==1));
	#endif
}

PS
{
	StaticCombo( S_MODE_TOOLS_VIS, 0..1 );
	StaticCombo( S_DETAIL_TEXTURE, F_DETAIL_TEXTURE );
	StaticCombo( S_SECONDARY_UV, F_SECONDARY_UV );
	StaticCombo( S_ANISOTROPIC_GLOSS, F_ANISOTROPIC_GLOSS );
	StaticCombo( S_ALPHA_TEST, F_ALPHA_TEST );
	StaticCombo( S_TRANSLUCENT, F_TRANSLUCENT );
	StaticCombo( S_ADDITIVE_BLEND, F_ADDITIVE_BLEND );
	StaticCombo( S_SELF_ILLUM, F_SELF_ILLUM );
	StaticCombo( S_TINT_MASK, F_TINT_MASK );
	StaticCombo( S_METALNESS_TEXTURE, F_METALNESS_TEXTURE );
	StaticCombo( S_DECAL_TEXTURE, F_DECAL_TEXTURE );
	StaticCombo( S_SHADER_QUALITY, 0..1 );
	StaticCombo( S_TRANSMISSIVE_BACKFACE_NDOTL, F_TRANSMISSIVE_BACKFACE_NDOTL );
	StaticComboRule( Requires( S_MODE_TOOLS_VIS, S_SHADER_QUALITY ) );
	StaticComboRule( Allow1( S_ALPHA_TEST, S_TRANSLUCENT ) );
	StaticComboRule( Requires( S_ADDITIVE_BLEND, S_TRANSLUCENT ) );
	StaticComboRule( Allow1( S_ANISOTROPIC_GLOSS, S_ADDITIVE_BLEND ) );
	StaticComboRule( Allow1( S_DETAIL_TEXTURE, S_SELF_ILLUM ) );
	StaticComboRule( Allow1( S_DETAIL_TEXTURE, S_ANISOTROPIC_GLOSS ) );
	StaticComboRule( Allow1( S_DETAIL_TEXTURE, S_ADDITIVE_BLEND ) );
	StaticComboRule( Allow1( S_METALNESS_TEXTURE, S_ADDITIVE_BLEND ) );
	StaticComboRule( Allow1( S_TRANSMISSIVE_BACKFACE_NDOTL, S_DETAIL_TEXTURE ) );
	StaticComboRule( Allow1( S_TRANSMISSIVE_BACKFACE_NDOTL, S_ADDITIVE_BLEND ) );
	StaticComboRule( Allow1( S_DECAL_TEXTURE, S_ANISOTROPIC_GLOSS ) );
	StaticComboRule( Allow1( S_DECAL_TEXTURE, S_SELF_ILLUM ) );
	StaticComboRule( Allow1( S_DECAL_TEXTURE, S_TRANSMISSIVE_BACKFACE_NDOTL ) );
	DynamicCombo( D_BAKED_LIGHTING_FROM_VERTEX_STREAM, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_PROBE, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_LIGHTMAP, 0..1 );
	DynamicCombo( D_SPECULAR_CUBE_MAP_STATIC, 0..1 );
	DynamicCombo( D_OPAQUE_FADE, 0..1 );
	DynamicCombo( D_MBOIT_PASS1, 0..1 );
	DynamicCombo( D_MBOIT_PASS2, 0..1 );
	DynamicCombo( D_MBOIT_4_MOMENTS, 0..1 );
	DynamicComboRule( Allow1( D_BAKED_LIGHTING_FROM_PROBE, D_BAKED_LIGHTING_FROM_VERTEX_STREAM, D_BAKED_LIGHTING_FROM_LIGHTMAP ) );
	DynamicComboRule( Requires( D_SPECULAR_CUBE_MAP_STATIC, S_SHADER_QUALITY=1 ) );
	DynamicComboRule( Allow1( S_ALPHA_TEST, S_TRANSLUCENT, D_OPAQUE_FADE ) );
	DynamicComboRule( Allow1( D_MBOIT_PASS1, D_MBOIT_PASS2 ) );
	DynamicComboRule( Requires( D_MBOIT_4_MOMENTS, D_MBOIT_PASS1, D_MBOIT_PASS2 ) );
	DynamicComboRule( Requires( D_MBOIT_PASS1, S_TRANSLUCENT ) );
	DynamicComboRule( Requires( D_MBOIT_PASS2, S_TRANSLUCENT ) );
	
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
	bool g_bTransmissiveShadows < UiType(CheckBox); Expression(F_DISABLE_TRANSMISSIVE_SHADOWS ? 0 : 1); >;
	bool g_bUseAlbedoForTransmissive < UiType(CheckBox); Expression(F_USE_ALBEDO_FOR_TRANSMISSIVE || 0); >;
	float g_fToolsVisHeightTint < Default(0.9); Attribute("g_fToolsVisHeightTint"); UiType(Slider); >;
	float g_fToolsVisMaxHeightRange < Default(1); Attribute("g_fToolsVisMaxHeightRange"); UiType(Slider); >;
	float g_fToolsVisMaxLightingComplexity < Default(8); Attribute("g_fToolsVisMaxLightingComplexity"); UiType(Slider); >;
	float g_flReflectance < UiType(Slider); Expression(pow((1.5-1)/(1.5+1),2)); >;
	ExternalDescriptorSet g_globalLateBoundBindlessSet < Source(ExternalDescSet); Attribute("g_globalLateBoundBindlessSet"); >;
	ExternalDescriptorSet g_lightBinnerGpuSet < Source(ExternalDescSet); Attribute("g_lightBinnerGpuSet"); >;
	int g_nDecalBlendMode < UiType(Slider); Expression(F_DECAL_BLEND_MODE || 0); >;
	int g_nToolsVisMode < Attribute("g_nToolsVisMode"); UiType(Slider); >;
	Texture2D g_tAmbientOcclusion < Channel(R, Box3(TextureAmbientOcclusion), Linear); OutputFormat(ATI1N); SrgbRead(false); >;
	Texture2D g_tAnisoGloss < Channel(RG, AnisoRoughness_RG(TextureNormal, TextureRoughness), Linear); OutputFormat(ATI2N); SrgbRead(false); >;
	Texture2D g_tColor < Channel(RGB, ArtistDefined(TextureColor), Srgb); OutputFormat(DXT1); SrgbRead(true); >;
	Texture2D g_tColor < Channel(RGB, ArtistDefined(TextureColor), Srgb); Channel(A, Box(TextureMetalness), Linear); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tColor < Channel(RGB, ArtistDefinedOrAlphaWeighted(TextureColor, TextureTranslucency), Srgb); Channel(A, PreserveCoverage(TextureTranslucency), Linear); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tColor < Channel(RGB, ArtistDefinedOrAlphaWeighted(TextureColor, TextureTranslucency), Srgb); Channel(A, Box(TextureTranslucency), Linear); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tDecal < Channel(RGB, ArtistDefinedOrAlphaWeighted(TextureDecal, TextureDecalTranslucency), Srgb); Channel(A, Box(TextureDecalTranslucency), Linear); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tDetail < Channel(RGB, ArtistDefined(TextureDetail), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tDetailMask < Channel(R, Box(TextureDetailMask), Linear); OutputFormat(ATI1N); SrgbRead(false); >;
	Texture2D g_tMetalness < Channel(G, Box(TextureMetalness), Linear); OutputFormat(DXT1); SrgbRead(false); >;
	Texture2D g_tNormal < Channel(RG, HemiOctIsoRoughness_RG_B(TextureNormal, TextureRoughness), Linear); OutputFormat(ATI2N); SrgbRead(false); >;
	Texture2D g_tNormal < Channel(RGBA, HemiOctIsoRoughness_RG_B(TextureNormal, TextureRoughness), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tNormalDetail < Channel(RG, HemiOctIsoRoughness_RG_B(TextureNormalDetail), Linear); OutputFormat(ATI2N); SrgbRead(false); >;
	Texture2D g_tSelfIllumMask < Channel(RGB, Box(TextureSelfIllumMask), Srgb); OutputFormat(DXT1); SrgbRead(true); >;
	Texture2D g_tTintMask < Channel(R, Box(TextureTintMask), Linear); OutputFormat(ATI1N); SrgbRead(false); >;
	Texture2D g_tTransmissiveColor < Channel(RGB, Box(TextureTransmissiveColor), Srgb); OutputFormat(BC7); SrgbRead(true); >;
	float4 g_vDetailNormalStrengthOffsetScale < UiType(VectorText); Expression(float4(0,0,1-g_flDetailNormalStrength,g_flDetailNormalStrength)); >;
	float3 g_vFlatOverlayColor < Default2(1, 0); Attribute("FlatOverlayColor"); UiType(VectorText); >;
	float3 g_vSelfIllumTintScaled < UiType(VectorText); Expression((pow(2,g_flSelfIllumBrightness).x*g_flSelfIllumScale.x)*SrgbGammaToLinear(g_vSelfIllumTint.xyz)); >;
	float4 g_vShaderIDColor < Source(ShaderIDColor); UiType(VectorText); >;
	
	// Ambient Occlusion
	bool g_bUseSecondaryUvForAmbientOcclusion < Default(1); UiType(CheckBox); UiGroup("Ambient Occlusion, 100"); >;
	CreateInputTexture2D(TextureAmbientOcclusion, Linear, 8, "", "_ao", "Ambient Occlusion/10", Default4(1, 1, 1, 0));
	
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
	CreateInputTexture2D(TextureNormalDetail, Linear, 8, "NormalizeNormals", "_normal", "Detail Texture,80/10", Default4(0.5, 0.5, 1, 0));
	float g_flDetailNormalStrength < Default(1); UiType(Slider); UiGroup("Detail Texture,80/15"); >;
	float g_flDetailBlendFactor < Default(1); UiType(Slider); UiGroup("Detail Texture,80/20"); >;
	CreateInputTexture2D(TextureDetailMask, Linear, 8, "", "_detailmask", "Detail Texture,80/40", Default4(1, 1, 1, 1));
	float g_flDetailBlendToFull < UiType(Slider); UiGroup("Detail Texture,80/50"); >;
	
	// Lighting
	CreateInputTexture2D(TextureMetalness, Linear, 8, "", "_metal", "Lighting,30/Metalness,30/10", Default4(0, 0, 0, 0));
	CreateInputTexture2D(TextureRoughness, Linear, 8, "Inverse", "_rough", "Lighting,30/Roughness,20/10", Default4(0.5, 0.5, 0.5, 0));
	float g_flMetalness < UiType(Slider); UiGroup("Lighting,30/Metalness/30"); >;
	
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
	
	// Transmission
	CreateInputTexture2D(TextureTransmissiveColor, Srgb, 8, "", "_color", "Transmission", Default4(1, 1, 1, 0));
	
	// Fog
	bool g_bFogEnabled < Default(1); UiType(CheckBox); UiGroup("Fog"); >;
	
	// Occlusion Culling
	float g_flOcclusionCullingBoundsScale < Default(1); Range(1, 100); UiType(Slider); UiGroup("Occlusion Culling"); UiVisibility(F_OCCLUSION_CULLING_BOUNDS_SCALE); >;
	
	// Texture Address Mode
	int g_nTextureAddressModeU < UiOption("RsTextureAddressMode_t"); UiType(Enum); UiGroup("Texture Address Mode"); >;
	int g_nTextureAddressModeV < UiOption("RsTextureAddressMode_t"); UiType(Enum); UiGroup("Texture Address Mode"); >;
	
	#if (S_ANISOTROPIC_GLOSS == 1)
		Texture2D g_tNormal < Channel(RG, HemiOctIsoRoughness_RG_B(TextureNormal, TextureRoughness), Linear); OutputFormat(ATI2N); SrgbRead(false); >;
	#endif
	#if (S_ALPHA_TEST == 1)
		Texture2D g_tColor < Channel(RGB, ArtistDefinedOrAlphaWeighted(TextureColor, TextureTranslucency), Srgb); Channel(A, PreserveCoverage(TextureTranslucency), Linear); OutputFormat(BC7); SrgbRead(true); >;
	#endif
	#if (S_TRANSLUCENT == 1)
		Texture2D g_tColor < Channel(RGB, ArtistDefinedOrAlphaWeighted(TextureColor, TextureTranslucency), Srgb); Channel(A, Box(TextureTranslucency), Linear); OutputFormat(BC7); SrgbRead(true); >;
	#endif
	#if (S_ADDITIVE_BLEND == 1)
		Texture2D g_tColor < Channel(RGB, ArtistDefinedOrAlphaWeighted(TextureColor, TextureTranslucency), Srgb); Channel(A, Box(TextureTranslucency), Linear); OutputFormat(BC7); SrgbRead(true); >;
		Texture2D g_tNormal < Channel(RGBA, HemiOctIsoRoughness_RG_B(TextureNormal, TextureRoughness), Linear); OutputFormat(BC7); SrgbRead(false); >;
	#endif
	#if (S_DECAL_TEXTURE == 1)
		Texture2D g_tNormal < Channel(RGBA, HemiOctIsoRoughness_RG_B(TextureNormal, TextureRoughness), Linear); OutputFormat(BC7); SrgbRead(false); >;
	#endif
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (37208 bytes), HLSL reflection with SPIRV-Cross by KhronosGroup
	
	struct _2872
	{
	    float4 _m0[3];
	};
	
	struct _71
	{
	    float4 _m0[4];
	};
	
	struct _2139
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
	    uint _Globals_1_g_tColor : packoffset(c0);
	    uint _Globals_1_g_sTrilinearWrap : packoffset(c3.w);
	    uint _Globals_1_g_sTrilinearClamp : packoffset(c4);
	    uint _Globals_1_g_sPointClamp : packoffset(c4.y);
	    uint _Globals_1_g_sUserConfig : packoffset(c5);
	    uint _Globals_1_g_sUserConfigAllowGlobalMipBias : packoffset(c5.y);
	    uint _Globals_1_g_sCookieSampler : packoffset(c5.w);
	    uint _Globals_1_g_tShadowDepthBufferCmpSampler : packoffset(c6);
	    int _Globals_1_g_bFogEnabled : packoffset(c6.z);
	    int _Globals_1_g_bDontFlipBackfaceNormals : packoffset(c6.w);
	    int _Globals_1_g_bRenderBackfaceNormals : packoffset(c7);
	    float _Globals_1_g_flReflectance : packoffset(c7.y);
	    uint _Globals_1_g_tNormal : packoffset(c11);
	    uint _Globals_1_g_tAmbientOcclusion : packoffset(c11.w);
	    float _Globals_1_g_flMetalness : packoffset(c12);
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
	    _2872 PerViewLightingConstantBufferGpu_t_1_m0 : packoffset(c7);
	    _71 PerViewLightingConstantBufferGpu_t_1_m1 : packoffset(c11);
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
	    _2139 PerViewLightingConstantBufferGpu_t_1_m18 : packoffset(c1956);
	    _71 PerViewLightingConstantBufferGpu_t_1_m19 : packoffset(c1988);
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
	static bool gl_FrontFacing;
	static float3 input_0;
	static float3 input_1;
	static float4 input_2;
	static float4 input_3;
	static float3 input_4;
	static float4 input_5;
	static float4 output_0;
	
	struct PS_INPUT
	{
	    float3 input_0 : TEXCOORD0;
	    float3 input_1 : TEXCOORD1;
	    float4 input_2 : TEXCOORD2;
	    centroid float4 input_3 : TEXCOORD3;
	    centroid float3 input_4 : TEXCOORD4;
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
	    float3 _21709;
	    if (dot(input_1.xyz, input_1.xyz) >= 1.0099999904632568359375f)
	    {
	        _21709 = input_4.xyz;
	    }
	    else
	    {
	        _21709 = input_1.xyz;
	    }
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
	        _10251 = _21709 * (gl_FrontFacing ? 1.0f : (-1.0f));
	    }
	    else
	    {
	        _10251 = _21709;
	    }
	    float3 _24347 = normalize(_10251);
	    float3 _10061 = input_0 + PerViewConstantBufferCsgo_t_1_m20.xyz;
	    float4 _19680 = g_bindless_Texture2D_float4[_Globals_1_g_tColor].Sample(g_bindless_Sampler[_Globals_1_g_sUserConfigAllowGlobalMipBias], input_2.xy);
	    float4 _19068 = g_bindless_Texture2D_float4[_Globals_1_g_tAmbientOcclusion].Sample(g_bindless_Sampler[_Globals_1_g_sUserConfig], float2(input_2.xy).xy);
	    float4 _19372 = g_bindless_Texture2D_float4[_Globals_1_g_tNormal].Sample(g_bindless_Sampler[_Globals_1_g_sUserConfig], input_2.xy);
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
	    float3 _12631 = input_1.xyz * (_24327 ? (-1.0f) : 1.0f);
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
	    float3 _14202 = (_19680.xyz * input_3.xyz).xyz;
	    float3 _12351 = lerp(_Globals_1_g_flReflectance.xxx.xyz, _14202, _Globals_1_g_flMetalness.xxx);
	    bool3 _24249 = all(bool3(true, true, true)).xxx;
	    float3 _17892 = float3(_24249.x ? _14786.x : 1.0f.xxx.x, _24249.y ? _14786.y : 1.0f.xxx.y, _24249.z ? _14786.z : 1.0f.xxx.z);
	    float3 _10560 = _24347.xyz;
	    float3 _11099 = ddx(_10560);
	    float3 _9175 = ddy(_10560);
	    float3 _10347 = _11099.xyz;
	    float3 _12420 = _9175.xyz;
	    float2 _21813 = max(_19372.zz, pow(clamp(max(dot(_10347, _10347), dot(_12420, _12420)), 0.0f, 1.0f), 0.333000004291534423828125f).xx);
	    float3 _15598 = -_24347;
	    float3 _24735 = _14786.xyz;
	    float4 _23875 = float4(_24735, 1.0f);
	    bool4 _24465 = bool4(PerViewConstantBufferCsgo_t_1_m0.x != int4(0, 0, 0, 0).x, PerViewConstantBufferCsgo_t_1_m0.y != int4(0, 0, 0, 0).y, PerViewConstantBufferCsgo_t_1_m0.z != int4(0, 0, 0, 0).z, PerViewConstantBufferCsgo_t_1_m0.w != int4(0, 0, 0, 0).w);
	    float _21710;
	    if (_24465.x)
	    {
	        float3 _11394 = _24347.xyz;
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
	            float4 _18322 = mul(PerViewLightingConstantBufferGpu_t_1_m18._m0[_13039], float4(input_0.xyz, 1.0f));
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
	                    float4 _19671 = mul(PerViewLightingConstantBufferGpu_t_1_m18._m0[_15335], float4(input_0.xyz, 1.0f));
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
	        float _13279 = lerp(_19363, 1.0f, clamp((distance(_10061.xyz, PerViewConstantBuffer_t_1_m3) * PerViewLightingConstantBufferGpu_t_1_m17) + PerViewLightingConstantBufferGpu_t_1_m16, 0.0f, 1.0f));
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
	        float _11797 = max(0.0f, dot(_14786.xyz, PerViewLightingConstantBufferGpu_t_1_m9.xyz));
	        float2 _9840 = max(_21813, PerViewLightingConstantBufferGpu_t_1_m9.w.xx);
	        float3 _12281 = normalize(PerViewLightingConstantBufferGpu_t_1_m9.xyz + (-normalize(_10061.xyz - PerViewConstantBuffer_t_1_m3.xyz)).xyz).xyz;
	        float _12386 = dot(_12281, float3(_19899.x ? _24735.x : _17892.x, _19899.y ? _24735.y : _17892.y, _19899.z ? _24735.z : _17892.z).xyz);
	        float _19210 = max(0.0f, dot(PerViewLightingConstantBufferGpu_t_1_m9.xyz, _12281));
	        float _9850 = _9840.x;
	        float _25211 = _9850 * _9850;
	        float _19095 = _25211 * _25211;
	        float _15346 = ((_12386 * _12386) * (_19095 - 1.0f)) + 1.0f;
	        float3 _16808 = (PerViewLightingConstantBufferGpu_t_1_m10.xyz * _21711).xyz;
	        _9716 = ((_12351.xyz * (_19095 / (((_15346 * _15346) * (_19210 * _19210)) * ((_9850 * 4.0f) + 2.0f)))).xyz * _11797).xyz * _16808;
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
	        float4 _18621 = mul(PerViewConstantBufferCsgo_t_1_m8, float4(_10061.xyz, 1.0f).xyzw);
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
	                float4 _24893 = mul(float4(input_0.xyz, 1.0f), _14097);
	                float3 _10521 = _24893.xyz / _24893.w.xxx;
	                float4 _22905;
	                _22905.x = _10521.x;
	                _22905.y = _10521.y;
	                float _21776 = _10521.z;
	                _22905.z = _21776;
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
	                    float3 _6368 = abs(mul(float4(input_0.xyz, 1.0f), _16509).xyz);
	                    _12887 = !all(bool3(_6368.x <= 1.0f.xxx.x, _6368.y <= 1.0f.xxx.y, _6368.z <= 1.0f.xxx.z));
	                }
	                if (_12887)
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
	                    _21316 = min(1.0f, _21776 * asfloat(g_BarnLights.Load4(_12608 * 480 + 144)).z);
	                }
	                else
	                {
	                    _21316 = 1.0f;
	                }
	                float _19667;
	                if (asfloat(g_BarnLights.Load4(_12608 * 480 + 144)).w > 0.0f)
	                {
	                    _19667 = _21316 * min(1.0f, (1.0f - _21776) * asfloat(g_BarnLights.Load4(_12608 * 480 + 144)).w);
	                }
	                else
	                {
	                    _19667 = _21316;
	                }
	                float3 _11179;
	                float _11633;
	                if (asfloat(g_BarnLights.Load4(_12608 * 480 + 128)).w != 0.0f)
	                {
	                    float3 _10017 = asfloat(g_BarnLights.Load4(_12608 * 480 + 128)).xyz - input_0.xyz;
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
	                        float3 _23714 = _21642;
	                        _23714.x = _6281.x;
	                        _23714.y = _6281.y;
	                        _19629 = _23714;
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
	                float _11798 = max(0.0f, dot(_14786.xyz, _11179.xyz));
	                float2 _9841 = max(_21813, asfloat(g_BarnLights.Load(_12608 * 480 + 256)).xx);
	                float3 _12282 = normalize(_11179.xyz + (-normalize(_10061.xyz - PerViewConstantBuffer_t_1_m3.xyz)).xyz).xyz;
	                float _12387 = dot(_12282, float3(_19900.x ? _24735.x : _17892.x, _19900.y ? _24735.y : _17892.y, _19900.z ? _24735.z : _17892.z).xyz);
	                float _19211 = max(0.0f, dot(_11179.xyz, _12282));
	                float _9851 = _9841.x;
	                float _25212 = _9851 * _9851;
	                float _19097 = _25212 * _25212;
	                float _15348 = ((_12387 * _12387) * (_19097 - 1.0f)) + 1.0f;
	                _13212 = _13138.xyz + (((_12351.xyz * (_19097 / (((_15348 * _15348) * (_19211 * _19211)) * ((_9851 * 4.0f) + 2.0f)))).xyz * _11798).xyz * _22671.xyz);
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
	    float _17172 = dot(_21813.xy, 0.5f.xx);
	    float3 _6253 = _17892.xyz;
	    float3 _17138 = normalize(_10061.xyz - PerViewConstantBuffer_t_1_m3.xyz);
	    float _17225 = _17172 * _17172;
	    float _20711 = clamp(1.0f - _17225, 0.0f, 1.0f);
	    float4 _15343 = (float4(-1.0f, -0.0274999998509883880615234375f, -0.572000026702880859375f, 0.02199999988079071044921875f) * _17172) + float4(1.0f, 0.0425000004470348358154296875f, 1.03999996185302734375f, -0.039999999105930328369140625f);
	    float _21215 = _15343.x;
	    float2 _24572 = (float2(-1.03999996185302734375f, 1.03999996185302734375f) * ((min(_21215 * _21215, exp2((-9.27999973297119140625f) * max(0.0f, dot((-_17138).xyz, _6253)))) * _21215) + _15343.y)) + _15343.zw;
	    float _20339 = _24572.y;
	    float2 _11427 = float2(_20339, _24572.x + _20339);
	    float3 _8745 = float3(dot(PerViewLightingConstantBufferGpu_t_1_m0._m0[0].xyzw, _23875), dot(PerViewLightingConstantBufferGpu_t_1_m0._m0[1].xyzw, _23875), dot(PerViewLightingConstantBufferGpu_t_1_m0._m0[2].xyzw, _23875)).xyz;
	    float3 _16991 = _16324.xyz + _8745;
	    float3 _20418 = (_21710 * _19068.x).xxx.xyz;
	    float3 _22686 = (_16324.xyz + (_8745 * _20418).xyz) * (_14202 * (1.0f - _Globals_1_g_flMetalness)).xyz;
	    float4 _11204 = float4(_22686, input_3.w);
	    _11204.x = _22686.x;
	    _11204.y = _22686.y;
	    _11204.z = _22686.z;
	    float3 _15752 = _11204.xyz + (_13137.xyz * _20418).xyz;
	    float4 _20490 = _11204;
	    _20490.x = _15752.x;
	    _20490.y = _15752.y;
	    _20490.z = _15752.z;
	    float3 _15734 = _20490.xyz + ((((lerp(_11427.xxx, _11427.yyy, _12351) * g_bindless_TextureCubeArray_float4[PerViewConstantBufferCsgo_t_1_m7].SampleLevel(g_bindless_Sampler[_Globals_1_g_sTrilinearClamp], float4(normalize(lerp(_6253, reflect(_17138.xyz, _17892.xyz).xyz, (_20711 * (sqrt(_20711) + _17225)).xxx)), 0.0f), PerViewLightingConstantBufferGpu_t_1_m8.y * sqrt(_17172)).xyz).xyz * (normalize(_16991 + 0.001000000047497451305389404296875f.xxx) * clamp(length(_16991), 0.0f, 1.75f))).xyz * (1.0f.xxx + (normalize(_8745 + 0.001000000047497451305389404296875f.xxx) * 0.5f))).xyz * _20418).xyz;
	    float4 _13888 = _20490;
	    _13888.x = _15734.x;
	    _13888.y = _15734.y;
	    _13888.z = _15734.z;
	    float4 _6805;
	    if (_Globals_1_g_bFogEnabled != 0)
	    {
	        float3 _21493;
	        float3 _22956 = _10061.xyz - PerViewConstantBuffer_t_1_m3.xyz;
	        float3 _9057 = _22956.xyz;
	        float3 _19340;
	        do
	        {
	            _21493 = _22956.xyz;
	            bool _12888;
	            if (dot(_21493, _21493) > PerViewConstantBufferCsgo_t_1_m14.x)
	            {
	                _12888 = (_10061.z * PerViewConstantBufferCsgo_t_1_m14.z) < PerViewConstantBufferCsgo_t_1_m14.y;
	            }
	            else
	            {
	                _12888 = false;
	            }
	            [branch]
	            if (_12888)
	            {
	                float2 _9342 = clamp(PerViewConstantBufferCsgo_t_1_m11.xy + (PerViewConstantBufferCsgo_t_1_m11.zw * float2(length(_21493), _10061.z)), 0.0f.xx, 1.0f.xx);
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
	            bool _12889;
	            if (dot(_9057, _9057) > PerViewConstantBufferCsgo_t_1_m18.x)
	            {
	                _12889 = (PerViewConstantBufferCsgo_t_1_m18.z * _10061.z) < PerViewConstantBufferCsgo_t_1_m18.y;
	            }
	            else
	            {
	                _12889 = false;
	            }
	            if (_12889)
	            {
	                float _14602 = clamp(pow(max(0.0f, (length(_21493) * PerViewConstantBufferCsgo_t_1_m15.y) + PerViewConstantBufferCsgo_t_1_m15.x), PerViewConstantBufferCsgo_t_1_m15.w), 0.0f, 1.0f) * clamp(pow(max(0.0f, (_10061.z * PerViewConstantBufferCsgo_t_1_m16.y) + PerViewConstantBufferCsgo_t_1_m16.x), PerViewConstantBufferCsgo_t_1_m16.z), 0.0f, 1.0f);
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
	BoolAttribute(environmentmapped, true);
	BoolAttribute(environmentmappeddynamic, true);
	BoolAttribute(NeedsLightProbe, true);
	BoolAttribute(DoNotCastShadows, F_DO_NOT_CAST_SHADOWS || 0);
	BoolAttribute(SupportsMappingDimensions, true);
	BoolAttribute(renderbackfaces, F_RENDER_BACKFACES || 0);
	TextureAttribute(LightSim_DiffuseAlbedoTexture, g_tColor);
	TextureAttribute(RepresentativeTexture, g_tColor);
	BoolAttribute(SupportsLightmapping, true);
	BoolAttribute(PerVertexLighting, true);
	BoolAttribute(AllowBackfaceCulling, F_RENDER_BACKFACES ? 0 : 1);
	BoolAttribute(DoubleSided, F_RENDER_BACKFACES);
	BoolAttribute(IgnoreFaceNormalsForLighting, F_IGNORE_FACE_NORMALS_FOR_LIGHTING);
	FloatAttribute(OcclusionCullingBoundsScale, F_OCCLUSION_CULLING_BOUNDS_SCALE ? g_flOcclusionCullingBoundsScale : (F_DEPTH_BIAS ? 1.3 : 1));
	
	#if (S_SELF_ILLUM == 0)
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
	#if (S_TINT_MASK == 1)
		TextureAttribute(LightSim_TintMaskTextureR, g_tTintMask);
	#endif
	#if (S_SELF_ILLUM == 1)
		TextureAttribute(LightSim_SelfIllumMaskTexture, g_tSelfIllumMask);
		Float3Attribute(LightSim_SelfIllumTint, g_vSelfIllumTint);
		FloatAttribute(LightSim_SelfIllumScale, g_flSelfIllumScale);
	#endif
	#if (S_TINT_MASK == 0)
		TextureAttribute(LightSim_SelfIllumMaskTexture, g_tSelfIllumMask);
		Float3Attribute(LightSim_SelfIllumTint, g_vSelfIllumTint);
		FloatAttribute(LightSim_SelfIllumScale, g_flSelfIllumScale);
	#endif
	#if (S_ADDITIVE_BLEND == 0)
		TextureAttribute(LightSim_TintMaskTextureR, g_tTintMask);
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
	#if (S_TRANSLUCENT == 0)
		TextureAttribute(LightSim_TintMaskTextureR, g_tTintMask);
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
	RenderState(DepthWriteEnable, (F_DISABLE_Z_BUFFERING ? True : F_DEPTH_BIAS) ? False : True);
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
		RenderState(DepthWriteEnable, (F_DISABLE_Z_BUFFERING ? True : F_DEPTH_BIAS) ? False : True);
	#endif
	
	BoolAttribute(BindlessResources, true);
	BoolAttribute(overlay, (F_DEPTH_BIAS && F_TRANSLUCENT) || 0);
	
}

RTX
{
	StaticCombo( S_MODE_TOOLS_VIS, 0..1 );
	StaticCombo( S_DETAIL_TEXTURE, F_DETAIL_TEXTURE );
	StaticCombo( S_SECONDARY_UV, F_SECONDARY_UV );
	StaticCombo( S_TEXTURE_ANIMATION, F_TEXTURE_ANIMATION );
	StaticCombo( S_PRE_BAKED_VERTEX_ANIMATION, F_PRE_BAKED_VERTEX_ANIMATION );
	StaticCombo( S_PAINT_VERTEX_COLORS, F_PAINT_VERTEX_COLORS );
	StaticCombo( S_ANISOTROPIC_GLOSS, F_ANISOTROPIC_GLOSS );
	StaticCombo( S_ALPHA_TEST, F_ALPHA_TEST );
	StaticCombo( S_TRANSLUCENT, F_TRANSLUCENT );
	StaticCombo( S_ADDITIVE_BLEND, F_ADDITIVE_BLEND );
	StaticCombo( S_SELF_ILLUM, F_SELF_ILLUM );
	StaticCombo( S_TINT_MASK, F_TINT_MASK );
	StaticCombo( S_METALNESS_TEXTURE, F_METALNESS_TEXTURE );
	StaticCombo( S_DECAL_TEXTURE, F_DECAL_TEXTURE );
	StaticCombo( S_SHADER_QUALITY, 0..1 );
	StaticCombo( S_TRANSMISSIVE_BACKFACE_NDOTL, F_TRANSMISSIVE_BACKFACE_NDOTL );
	StaticComboRule( Requires( S_MODE_TOOLS_VIS, S_SHADER_QUALITY ) );
	StaticComboRule( Allow0( S_PRE_BAKED_VERTEX_ANIMATION ) );
	StaticComboRule( Allow0( S_MODE_TOOLS_VIS, S_SHADER_QUALITY ) );
	StaticComboRule( Allow1( S_ALPHA_TEST, S_TRANSLUCENT ) );
	StaticComboRule( Requires( S_ADDITIVE_BLEND, S_TRANSLUCENT ) );
	StaticComboRule( Allow1( S_ANISOTROPIC_GLOSS, S_ADDITIVE_BLEND ) );
	StaticComboRule( Allow1( S_DETAIL_TEXTURE, S_SELF_ILLUM ) );
	StaticComboRule( Allow1( S_DETAIL_TEXTURE, S_ANISOTROPIC_GLOSS ) );
	StaticComboRule( Allow1( S_DETAIL_TEXTURE, S_ADDITIVE_BLEND ) );
	StaticComboRule( Allow1( S_METALNESS_TEXTURE, S_ADDITIVE_BLEND ) );
	StaticComboRule( Allow1( S_PRE_BAKED_VERTEX_ANIMATION, S_TEXTURE_ANIMATION ) );
	StaticComboRule( Allow1( S_TRANSMISSIVE_BACKFACE_NDOTL, S_DETAIL_TEXTURE ) );
	StaticComboRule( Allow1( S_TRANSMISSIVE_BACKFACE_NDOTL, S_PRE_BAKED_VERTEX_ANIMATION ) );
	StaticComboRule( Allow1( S_TRANSMISSIVE_BACKFACE_NDOTL, S_ADDITIVE_BLEND ) );
	StaticComboRule( Allow1( S_DECAL_TEXTURE, S_ANISOTROPIC_GLOSS ) );
	StaticComboRule( Allow1( S_DECAL_TEXTURE, S_SELF_ILLUM ) );
	StaticComboRule( Allow1( S_DECAL_TEXTURE, S_TEXTURE_ANIMATION ) );
	StaticComboRule( Allow1( S_DECAL_TEXTURE, S_PRE_BAKED_VERTEX_ANIMATION ) );
	StaticComboRule( Allow1( S_DECAL_TEXTURE, S_TRANSMISSIVE_BACKFACE_NDOTL ) );
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
	bool g_bUseAlbedoForTransmissive < UiType(CheckBox); Expression(F_USE_ALBEDO_FOR_TRANSMISSIVE || 0); >;
	float g_flReflectance < UiType(Slider); Expression(pow((1.5-1)/(1.5+1),2)); >;
	int g_nDecalBlendMode < UiType(Slider); Expression(F_DECAL_BLEND_MODE || 0); >;
	int g_nTextureAnimationMode < UiType(Slider); Expression(F_TEXTURE_ANIMATION_MODE); >;
	Texture2D g_tAnisoGloss < Channel(RG, AnisoRoughness_RG(TextureNormal, TextureRoughness), Linear); OutputFormat(ATI2N); SrgbRead(false); >;
	Texture2D g_tColor < Channel(RGB, ArtistDefined(TextureColor), Srgb); OutputFormat(DXT1); SrgbRead(true); >;
	Texture2D g_tColor < Channel(RGB, ArtistDefined(TextureColor), Srgb); Channel(A, Box(TextureMetalness), Linear); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tColor < Channel(RGB, ArtistDefinedOrAlphaWeighted(TextureColor, TextureTranslucency), Srgb); Channel(A, PreserveCoverage(TextureTranslucency), Linear); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tColor < Channel(RGB, ArtistDefinedOrAlphaWeighted(TextureColor, TextureTranslucency), Srgb); Channel(A, Box(TextureTranslucency), Linear); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tDecal < Channel(RGB, ArtistDefinedOrAlphaWeighted(TextureDecal, TextureDecalTranslucency), Srgb); Channel(A, Box(TextureDecalTranslucency), Linear); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tDetail < Channel(RGB, ArtistDefined(TextureDetail), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tDetailMask < Channel(R, Box(TextureDetailMask), Linear); OutputFormat(ATI1N); SrgbRead(false); >;
	Texture2D g_tMetalness < Channel(G, Box(TextureMetalness), Linear); OutputFormat(DXT1); SrgbRead(false); >;
	Texture2D g_tNormal < Channel(RG, HemiOctIsoRoughness_RG_B(TextureNormal, TextureRoughness), Linear); OutputFormat(ATI2N); SrgbRead(false); >;
	Texture2D g_tNormal < Channel(RGBA, HemiOctIsoRoughness_RG_B(TextureNormal, TextureRoughness), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tNormalDetail < Channel(RG, HemiOctIsoRoughness_RG_B(TextureNormalDetail), Linear); OutputFormat(ATI2N); SrgbRead(false); >;
	Texture2D g_tSelfIllumMask < Channel(RGB, Box(TextureSelfIllumMask), Srgb); OutputFormat(DXT1); SrgbRead(true); >;
	Texture2D g_tTintMask < Channel(R, Box(TextureTintMask), Linear); OutputFormat(ATI1N); SrgbRead(false); >;
	Texture2D g_tTransmissiveColor < Channel(RGB, Box(TextureTransmissiveColor), Srgb); OutputFormat(BC7); SrgbRead(true); >;
	float2 g_vAnimationInvGrid < UiType(VectorText); Expression(1/g_vAnimationGrid); >;
	float4 g_vDetailNormalStrengthOffsetScale < UiType(VectorText); Expression(float4(0,0,1-g_flDetailNormalStrength,g_flDetailNormalStrength)); >;
	float4 g_vDetailTexCoordXform < UiType(VectorText); Expression(v0 = (g_flDetailTexCoordRotation*3.14159)/180;
		v1 = cos(v0);
		v2 = sin(v0);
		v3 = g_vDetailTexCoordScale;
		v3.xxy*float4(v1,-v2,v2,v1)); >;
	float3 g_vSelfIllumTintScaled < UiType(VectorText); Expression((pow(2,g_flSelfIllumBrightness).x*g_flSelfIllumScale.x)*SrgbGammaToLinear(g_vSelfIllumTint.xyz)); >;
	float4 g_vTexCoordXform0 < UiType(VectorText); Expression(v0 = (g_flTexCoordRotation*3.14159)/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v1*g_vTexCoordScale.x,-v2*g_vTexCoordScale.y,0,((g_vTexCoordCenter.x+g_vTexCoordOffset.x)+(v2*g_vTexCoordCenter.y))-(v1*g_vTexCoordCenter.x))); >;
	float4 g_vTexCoordXform1 < UiType(VectorText); Expression(v0 = (g_flTexCoordRotation*3.14159)/180;
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
	CreateInputTexture2D(TextureNormalDetail, Linear, 8, "NormalizeNormals", "_normal", "Detail Texture,80/10", Default4(0.5, 0.5, 1, 0));
	float g_flDetailNormalStrength < Default(1); UiType(Slider); UiGroup("Detail Texture,80/15"); >;
	float g_flDetailBlendFactor < Default(1); UiType(Slider); UiGroup("Detail Texture,80/20"); >;
	float2 g_vDetailTexCoordScale < Default2(1, 1); UiType(VectorText); UiGroup("Detail Texture,80/30"); >;
	float g_flDetailTexCoordRotation < Range(0, 360); UiType(Slider); UiGroup("Detail Texture,80/35"); >;
	CreateInputTexture2D(TextureDetailMask, Linear, 8, "", "_detailmask", "Detail Texture,80/40", Default4(1, 1, 1, 1));
	float2 g_vDetailTexCoordOffset < Range2(-1, -1, 1, 1); UiType(VectorText); UiGroup("Detail Texture,80/40"); Expression(v0 = (g_flDetailTexCoordRotation*3.14159)/180;
		v1 = cos(v0);
		v2 = sin(v0);
		v3 = g_vDetailTexCoordScale;
		v4 = this;
		(((-.5*v3)*float2(v1-v2,v2+v1))+v4)+.5); >;
	float g_flDetailBlendToFull < UiType(Slider); UiGroup("Detail Texture,80/50"); >;
	
	// Lighting
	CreateInputTexture2D(TextureMetalness, Linear, 8, "", "_metal", "Lighting,30/Metalness,30/10", Default4(0, 0, 0, 0));
	CreateInputTexture2D(TextureRoughness, Linear, 8, "Inverse", "_rough", "Lighting,30/Roughness,20/10", Default4(0.5, 0.5, 0.5, 0));
	float g_flMetalness < UiType(Slider); UiGroup("Lighting,30/Metalness/30"); >;
	
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
	
	// Transmission
	CreateInputTexture2D(TextureTransmissiveColor, Srgb, 8, "", "_color", "Transmission", Default4(1, 1, 1, 0));
	
	// Texture Animation
	int2 g_vAnimationGrid < Default2(1, 1); Range2(1, 1, 64, 64); UiType(VectorText); UiGroup("Texture Animation,12/10"); >;
	int g_nNumAnimationCells < Default(1); Range(1, 4096); UiType(Slider); UiGroup("Texture Animation,12/20"); >;
	float g_flAnimationTimePerFrame < Default(0.1); Range(0, 10); UiType(Slider); UiGroup("Texture Animation,12/30"); >;
	float g_flAnimationTimeOffset < Range(0, 1000); UiType(Slider); UiGroup("Texture Animation,12/40"); >;
	float g_flAnimationFrame < Range(0, 4096); UiType(Slider); UiGroup("Texture Animation,12/50"); >;
	
	// Texture Address Mode
	int g_nTextureAddressModeU < UiOption("RsTextureAddressMode_t"); UiType(Enum); UiGroup("Texture Address Mode"); >;
	int g_nTextureAddressModeV < UiOption("RsTextureAddressMode_t"); UiType(Enum); UiGroup("Texture Address Mode"); >;
	
	#if (S_ANISOTROPIC_GLOSS == 1)
		Texture2D g_tNormal < Channel(RG, HemiOctIsoRoughness_RG_B(TextureNormal, TextureRoughness), Linear); OutputFormat(ATI2N); SrgbRead(false); >;
	#endif
	#if (S_ALPHA_TEST == 1)
		Texture2D g_tColor < Channel(RGB, ArtistDefinedOrAlphaWeighted(TextureColor, TextureTranslucency), Srgb); Channel(A, PreserveCoverage(TextureTranslucency), Linear); OutputFormat(BC7); SrgbRead(true); >;
	#endif
	#if (S_TRANSLUCENT == 1)
		Texture2D g_tColor < Channel(RGB, ArtistDefinedOrAlphaWeighted(TextureColor, TextureTranslucency), Srgb); Channel(A, Box(TextureTranslucency), Linear); OutputFormat(BC7); SrgbRead(true); >;
	#endif
	#if (S_ADDITIVE_BLEND == 1)
		Texture2D g_tColor < Channel(RGB, ArtistDefinedOrAlphaWeighted(TextureColor, TextureTranslucency), Srgb); Channel(A, Box(TextureTranslucency), Linear); OutputFormat(BC7); SrgbRead(true); >;
		Texture2D g_tNormal < Channel(RGBA, HemiOctIsoRoughness_RG_B(TextureNormal, TextureRoughness), Linear); OutputFormat(BC7); SrgbRead(false); >;
	#endif
	#if (S_DECAL_TEXTURE == 1)
		Texture2D g_tNormal < Channel(RGBA, HemiOctIsoRoughness_RG_B(TextureNormal, TextureRoughness), Linear); OutputFormat(BC7); SrgbRead(false); >;
	#endif
	
	// SPIR-V reflection failed for backend HLSL:
	// Unsupported builtin in HLSL: 5326
	//
	// Re-attempting reflection with the GLSL backend.
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (61004 bytes), GLSL reflection with SPIRV-Cross by KhronosGroup
	
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
	    uint _member0[];
	} g_MaterialData_1;
	
	layout(set = 3, binding = 34, std430) readonly buffer g_MaterialData_2
	{
	    float _member0[];
	} g_MaterialData_3;
	
	layout(set = 3, binding = 34, std430) readonly buffer g_MaterialData_4
	{
	    int _member0[];
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
	    PackedRtxInstanceData_t_natural_logical _416;
	    _416.nSrgbColor = g_instanceBuffer._member0[uint(gl_InstanceID)].nSrgbColor;
	    _416.nTriangleGeometry = g_instanceBuffer._member0[uint(gl_InstanceID)].nTriangleGeometry;
	    _416.nMaterialData = g_instanceBuffer._member0[uint(gl_InstanceID)].nMaterialData;
	    _416.nMaterialFlags_nInstanceFlags = g_instanceBuffer._member0[uint(gl_InstanceID)].nMaterialFlags_nInstanceFlags;
	    _416.fEmissiveBoost = g_instanceBuffer._member0[uint(gl_InstanceID)].fEmissiveBoost;
	    _416.nInstanceFlags = g_instanceBuffer._member0[uint(gl_InstanceID)].nInstanceFlags;
	    _416._pad1 = g_instanceBuffer._member0[uint(gl_InstanceID)]._pad1;
	    _416._pad2 = g_instanceBuffer._member0[uint(gl_InstanceID)]._pad2;
	    uint _280 = _416.nMaterialData;
	    uint _325 = g_MaterialData_1._member0[(_280 + 28u) / 4u];
	    uint _324 = g_MaterialData_1._member0[(_280 + 32u) / 4u];
	    vec4 _323 = vec4(g_MaterialData_3._member0[(_280 + 144u) / 4u], g_MaterialData_3._member0[(_280 + 148u) / 4u], g_MaterialData_3._member0[(_280 + 152u) / 4u], g_MaterialData_3._member0[(_280 + 156u) / 4u]);
	    vec4 _322 = vec4(g_MaterialData_3._member0[(_280 + 160u) / 4u], g_MaterialData_3._member0[(_280 + 164u) / 4u], g_MaterialData_3._member0[(_280 + 168u) / 4u], g_MaterialData_3._member0[(_280 + 172u) / 4u]);
	    vec2 _321 = vec2(g_MaterialData_3._member0[(_280 + 176u) / 4u], g_MaterialData_3._member0[(_280 + 180u) / 4u]);
	    vec3 _320 = vec3(g_MaterialData_3._member0[(_280 + 240u) / 4u], g_MaterialData_3._member0[(_280 + 244u) / 4u], g_MaterialData_3._member0[(_280 + 248u) / 4u]);
	    float _319 = g_MaterialData_3._member0[(_280 + 252u) / 4u];
	    uint _318 = g_MaterialData_1._member0[(_280 + 260u) / 4u];
	    bool _317 = g_MaterialData_5._member0[(_280 + 316u) / 4u] != 0;
	    bool _316 = g_MaterialData_5._member0[(_280 + 320u) / 4u] != 0;
	    float _315 = g_MaterialData_3._member0[(_280 + 324u) / 4u];
	    uint _314 = g_MaterialData_1._member0[(_280 + 328u) / 4u];
	    float _313 = g_MaterialData_3._member0[(_280 + 344u) / 4u];
	    uvec3 _411;
	    do
	    {
	        if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes.w == 4)
	        {
	            uint _562 = (12u * uint(gl_PrimitiveID)) + uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes.w);
	            _411 = uvec3(g_Indices_1[g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._member0[_562 / 4u], g_Indices_1[g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._member0[(_562 + 4u) / 4u], g_Indices_1[g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._member0[(_562 + 8u) / 4u]);
	            break;
	        }
	        else
	        {
	            uint _535 = (6u * uint(gl_PrimitiveID)) + uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes.w);
	            uint _536 = _535 & 4294967292u;
	            uint _537 = _536 / 4u;
	            uint _541 = (_536 + 4u) / 4u;
	            uint _546 = (g_Indices_1[g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._member0[_537] & 4294901760u) >> uint(16);
	            uint _547 = g_Indices_1[g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._member0[_541] & 65535u;
	            uvec3 _412;
	            if (_535 == _536)
	            {
	                _412 = uvec3(g_Indices_1[g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._member0[_537] & 65535u, _546, _547);
	            }
	            else
	            {
	                _412 = uvec3(_546, _547, (g_Indices_1[g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._member0[_541] & 4294901760u) >> uint(16));
	            }
	            _411 = _412;
	            break;
	        }
	        break;
	    } while(false);
	    uint _60 = uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.x);
	    uvec3 _593 = (uvec3(uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes.x)) * _411) + uvec3(uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes.x));
	    vec3 _406[3];
	    uint _595 = _593.x;
	    _406[0] = vec3(g_Vertices_1[_60]._member0[_595 / 4u], g_Vertices_1[_60]._member0[(_595 + 4u) / 4u], g_Vertices_1[_60]._member0[(_595 + 8u) / 4u]);
	    uint _609 = _593.y;
	    _406[1] = vec3(g_Vertices_1[_60]._member0[_609 / 4u], g_Vertices_1[_60]._member0[(_609 + 4u) / 4u], g_Vertices_1[_60]._member0[(_609 + 8u) / 4u]);
	    uint _623 = _593.z;
	    _406[2] = vec3(g_Vertices_1[_60]._member0[_623 / 4u], g_Vertices_1[_60]._member0[(_623 + 4u) / 4u], g_Vertices_1[_60]._member0[(_623 + 8u) / 4u]);
	    int _407 = 0;
	    VS_INPUT vsInput[3];
	    for (;;)
	    {
	        if (!(_407 < 3))
	        {
	            break;
	        }
	        vsInput[_407].vPositionOs = _406[_407];
	        _407++;
	        continue;
	    }
	    vec2 _408[3];
	    _408[0] = vec2(0.0);
	    _408[1] = vec2(0.0);
	    _408[2] = vec2(0.0);
	    if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].y != 0)
	    {
	        ivec4 _405 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers;
	        uint _62 = uint(_405[g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].z]);
	        uint _674 = uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].z);
	        ivec4 _403 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes;
	        ivec4 _404 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes;
	        uvec3 _690 = (uvec3(uint(_403[_674])) * _411) + uvec3(uint(_404[_674]) + uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].x));
	        if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].y == 16)
	        {
	            uint _822 = _690.x;
	            _408[0] = vec2(g_Vertices_1[_62]._member0[_822 / 4u], g_Vertices_1[_62]._member0[(_822 + 4u) / 4u]);
	            uint _831 = _690.y;
	            _408[1] = vec2(g_Vertices_1[_62]._member0[_831 / 4u], g_Vertices_1[_62]._member0[(_831 + 4u) / 4u]);
	            uint _840 = _690.z;
	            _408[2] = vec2(g_Vertices_1[_62]._member0[_840 / 4u], g_Vertices_1[_62]._member0[(_840 + 4u) / 4u]);
	        }
	        else
	        {
	            if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].y == 34)
	            {
	                uint _793 = _690.x / 4u;
	                _408[0] = vec2(uint16BitsToFloat16(u16vec2(uvec2(g_Vertices_3[_62]._member0[_793], g_Vertices_3[_62]._member0[_793] >> uint(16)) & uvec2(65535u))));
	                uint _803 = _690.y / 4u;
	                _408[1] = vec2(uint16BitsToFloat16(u16vec2(uvec2(g_Vertices_3[_62]._member0[_803], g_Vertices_3[_62]._member0[_803] >> uint(16)) & uvec2(65535u))));
	                uint _813 = _690.z / 4u;
	                _408[2] = vec2(uint16BitsToFloat16(u16vec2(uvec2(g_Vertices_3[_62]._member0[_813], g_Vertices_3[_62]._member0[_813] >> uint(16)) & uvec2(65535u))));
	            }
	            else
	            {
	                if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].y == 37)
	                {
	                    uint _703 = _690.x / 4u;
	                    uint _706 = g_Vertices_3[_62]._member0[_703] & 65535u;
	                    int _402;
	                    if (_706 > 32767u)
	                    {
	                        _402 = int(4294901760u | _706);
	                    }
	                    else
	                    {
	                        _402 = int(_706);
	                    }
	                    uint _719 = (g_Vertices_3[_62]._member0[_703] & 4294901760u) >> uint(16);
	                    int _401;
	                    if (_719 > 32767u)
	                    {
	                        _401 = int(4294901760u | _719);
	                    }
	                    else
	                    {
	                        _401 = int(_719);
	                    }
	                    _408[0] = vec2(max(float(_402) * 3.0518509447574615478515625e-05, -1.0), max(float(_401) * 3.0518509447574615478515625e-05, -1.0));
	                    uint _733 = _690.y / 4u;
	                    uint _736 = g_Vertices_3[_62]._member0[_733] & 65535u;
	                    int _400;
	                    if (_736 > 32767u)
	                    {
	                        _400 = int(4294901760u | _736);
	                    }
	                    else
	                    {
	                        _400 = int(_736);
	                    }
	                    uint _749 = (g_Vertices_3[_62]._member0[_733] & 4294901760u) >> uint(16);
	                    int _399;
	                    if (_749 > 32767u)
	                    {
	                        _399 = int(4294901760u | _749);
	                    }
	                    else
	                    {
	                        _399 = int(_749);
	                    }
	                    _408[1] = vec2(max(float(_400) * 3.0518509447574615478515625e-05, -1.0), max(float(_399) * 3.0518509447574615478515625e-05, -1.0));
	                    uint _763 = _690.z / 4u;
	                    uint _766 = g_Vertices_3[_62]._member0[_763] & 65535u;
	                    int _398;
	                    if (_766 > 32767u)
	                    {
	                        _398 = int(4294901760u | _766);
	                    }
	                    else
	                    {
	                        _398 = int(_766);
	                    }
	                    uint _779 = (g_Vertices_3[_62]._member0[_763] & 4294901760u) >> uint(16);
	                    int _397;
	                    if (_779 > 32767u)
	                    {
	                        _397 = int(4294901760u | _779);
	                    }
	                    else
	                    {
	                        _397 = int(_779);
	                    }
	                    _408[2] = vec2(max(float(_398) * 3.0518509447574615478515625e-05, -1.0), max(float(_397) * 3.0518509447574615478515625e-05, -1.0));
	                }
	            }
	        }
	    }
	    _407 = 0;
	    for (;;)
	    {
	        if (!(_407 < 3))
	        {
	            break;
	        }
	        vsInput[_407].vTexCoord = _408[_407];
	        _407++;
	        continue;
	    }
	    vec3 _409[3];
	    vec4 _410[3];
	    do
	    {
	        if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.y != 0)
	        {
	            ivec4 _383 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers;
	            uint _66 = uint(_383[g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.z]);
	            uint _890 = uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.z);
	            ivec4 _381 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes;
	            ivec4 _382 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes;
	            uvec3 _906 = (uvec3(uint(_381[_890])) * _411) + uvec3(uint(_382[_890]) + uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.x));
	            if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.y == 6)
	            {
	                uint _1434 = _906.x;
	                _409[0] = vec3(g_Vertices_1[_66]._member0[_1434 / 4u], g_Vertices_1[_66]._member0[(_1434 + 4u) / 4u], g_Vertices_1[_66]._member0[(_1434 + 8u) / 4u]);
	                uint _1448 = _906.y;
	                _409[1] = vec3(g_Vertices_1[_66]._member0[_1448 / 4u], g_Vertices_1[_66]._member0[(_1448 + 4u) / 4u], g_Vertices_1[_66]._member0[(_1448 + 8u) / 4u]);
	                uint _1462 = _906.z;
	                _409[2] = vec3(g_Vertices_1[_66]._member0[_1462 / 4u], g_Vertices_1[_66]._member0[(_1462 + 4u) / 4u], g_Vertices_1[_66]._member0[(_1462 + 8u) / 4u]);
	            }
	            else
	            {
	                if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.y == 17)
	                {
	                    uint _1170 = _906.x;
	                    uvec2 _1178 = uvec2(g_Vertices_3[_66]._member0[_1170 / 4u], g_Vertices_3[_66]._member0[(_1170 + 4u) / 4u]);
	                    uint _1179 = _906.y;
	                    uvec2 _276 = uvec2(g_Vertices_3[_66]._member0[_1179 / 4u], g_Vertices_3[_66]._member0[(_1179 + 4u) / 4u]);
	                    uint _1188 = _906.z;
	                    uvec2 _275 = uvec2(g_Vertices_3[_66]._member0[_1188 / 4u], g_Vertices_3[_66]._member0[(_1188 + 4u) / 4u]);
	                    uint _1200 = _1178.x;
	                    uint _1208 = _1178.y;
	                    vec2 _1218 = ((vec2(float(_1200 & 65535u), float((_1200 >> 16u) & 65535u)) * vec2(1.525902189314365386962890625e-05)) * 2.0) - vec2(1.0);
	                    float _1219 = _1218.x;
	                    float _1224 = (1.0 - abs(_1219)) - abs(_1218.y);
	                    vec3 _1225 = vec3(_1219, _1218.y, _1224);
	                    float _1227 = saturate(-_1224);
	                    vec2 _1233 = _1218 + mix(vec2(_1227), vec2(-_1227), greaterThanEqual(_1218, vec2(0.0)));
	                    _1225.x = _1233.x;
	                    _1225.y = _1233.y;
	                    vec3 _385 = normalize(_1225);
	                    vec2 _1240 = ((vec2(float((_1208 >> uint(1)) & 32767u), float((_1208 >> 16u) & 32767u)) * vec2(3.0518509447574615478515625e-05)) * 2.0) - vec2(1.0);
	                    float _1241 = _1240.x;
	                    float _1246 = (1.0 - abs(_1241)) - abs(_1240.y);
	                    vec3 _1247 = vec3(_1241, _1240.y, _1246);
	                    float _1249 = saturate(-_1246);
	                    vec2 _1255 = _1240 + mix(vec2(_1249), vec2(-_1249), greaterThanEqual(_1240, vec2(0.0)));
	                    _1247.x = _1255.x;
	                    _1247.y = _1255.y;
	                    vec3 _384 = normalize(_1247);
	                    float _371;
	                    if ((_1208 & 1u) != 0u)
	                    {
	                        _371 = 1.0;
	                    }
	                    else
	                    {
	                        _371 = -1.0;
	                    }
	                    _409[0] = _385;
	                    _410[0].w = _371;
	                    _410[0].x = _384.x;
	                    _410[0].y = _384.y;
	                    _410[0].z = _384.z;
	                    vec2 _1297 = ((vec2(float(_276.x & 65535u), float((_276.x >> 16u) & 65535u)) * vec2(1.525902189314365386962890625e-05)) * 2.0) - vec2(1.0);
	                    float _1298 = _1297.x;
	                    float _1303 = (1.0 - abs(_1298)) - abs(_1297.y);
	                    vec3 _1304 = vec3(_1298, _1297.y, _1303);
	                    float _1306 = saturate(-_1303);
	                    vec2 _1312 = _1297 + mix(vec2(_1306), vec2(-_1306), greaterThanEqual(_1297, vec2(0.0)));
	                    _1304.x = _1312.x;
	                    _1304.y = _1312.y;
	                    vec3 _387 = normalize(_1304);
	                    vec2 _1319 = ((vec2(float((_276.y >> uint(1)) & 32767u), float((_276.y >> 16u) & 32767u)) * vec2(3.0518509447574615478515625e-05)) * 2.0) - vec2(1.0);
	                    float _1320 = _1319.x;
	                    float _1325 = (1.0 - abs(_1320)) - abs(_1319.y);
	                    vec3 _1326 = vec3(_1320, _1319.y, _1325);
	                    float _1328 = saturate(-_1325);
	                    vec2 _1334 = _1319 + mix(vec2(_1328), vec2(-_1328), greaterThanEqual(_1319, vec2(0.0)));
	                    _1326.x = _1334.x;
	                    _1326.y = _1334.y;
	                    vec3 _386 = normalize(_1326);
	                    float _370;
	                    if ((_276.y & 1u) != 0u)
	                    {
	                        _370 = 1.0;
	                    }
	                    else
	                    {
	                        _370 = -1.0;
	                    }
	                    _409[1] = _387;
	                    _410[1].w = _370;
	                    _410[1].x = _386.x;
	                    _410[1].y = _386.y;
	                    _410[1].z = _386.z;
	                    vec2 _1376 = ((vec2(float(_275.x & 65535u), float((_275.x >> 16u) & 65535u)) * vec2(1.525902189314365386962890625e-05)) * 2.0) - vec2(1.0);
	                    float _1377 = _1376.x;
	                    float _1382 = (1.0 - abs(_1377)) - abs(_1376.y);
	                    vec3 _1383 = vec3(_1377, _1376.y, _1382);
	                    float _1385 = saturate(-_1382);
	                    vec2 _1391 = _1376 + mix(vec2(_1385), vec2(-_1385), greaterThanEqual(_1376, vec2(0.0)));
	                    _1383.x = _1391.x;
	                    _1383.y = _1391.y;
	                    vec3 _389 = normalize(_1383);
	                    vec2 _1398 = ((vec2(float((_275.y >> uint(1)) & 32767u), float((_275.y >> 16u) & 32767u)) * vec2(3.0518509447574615478515625e-05)) * 2.0) - vec2(1.0);
	                    float _1399 = _1398.x;
	                    float _1404 = (1.0 - abs(_1399)) - abs(_1398.y);
	                    vec3 _1405 = vec3(_1399, _1398.y, _1404);
	                    float _1407 = saturate(-_1404);
	                    vec2 _1413 = _1398 + mix(vec2(_1407), vec2(-_1407), greaterThanEqual(_1398, vec2(0.0)));
	                    _1405.x = _1413.x;
	                    _1405.y = _1413.y;
	                    vec3 _388 = normalize(_1405);
	                    float _369;
	                    if ((_275.y & 1u) != 0u)
	                    {
	                        _369 = 1.0;
	                    }
	                    else
	                    {
	                        _369 = -1.0;
	                    }
	                    _409[2] = _389;
	                    _410[2].w = _369;
	                    _410[2].x = _388.x;
	                    _410[2].y = _388.y;
	                    _410[2].z = _388.z;
	                    break;
	                }
	                else
	                {
	                    uint _916 = _906.x / 4u;
	                    vec4 _391 = _410[0];
	                    float _931 = (float((g_Vertices_3[_66]._member0[_916] >> 12u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _934 = (float((g_Vertices_3[_66]._member0[_916] >> 22u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _938 = (1.0 - abs(_931)) - abs(_934);
	                    vec3 _939 = vec3(_931, _934, _938);
	                    float _941 = saturate(-_938);
	                    vec2 _942 = vec2(_931, _934);
	                    vec2 _948 = _942 + mix(vec2(_941), vec2(-_941), greaterThanEqual(_942, vec2(0.0)));
	                    _939.x = _948.x;
	                    _939.y = _948.y;
	                    vec3 _953 = normalize(_939);
	                    vec3 _390 = _953;
	                    float _954 = _953.z;
	                    float _378;
	                    if (_954 >= 0.0)
	                    {
	                        _378 = 1.0;
	                    }
	                    else
	                    {
	                        _378 = -1.0;
	                    }
	                    float _961 = (-1.0) / (_378 + _954);
	                    float _962 = _953.x;
	                    vec3 _379;
	                    vec3 _970 = _379;
	                    _970.x = 1.0 + (((_378 * _962) * _962) * _961);
	                    _970.y = _378 * ((_962 * _953.y) * _961);
	                    _970.z = (-_378) * _962;
	                    _379 = _970;
	                    float _978 = float((g_Vertices_3[_66]._member0[_916] >> uint(1)) & 2047u) * 0.003069460391998291015625;
	                    vec3 _984 = (_970 * cos(_978)) + (cross(_953, _970) * sin(_978));
	                    vec4 _986 = _391;
	                    _986.x = _984.x;
	                    _986.y = _984.y;
	                    _986.z = _984.z;
	                    _391 = _986;
	                    float _380;
	                    if ((g_Vertices_3[_66]._member0[_916] & 1u) == 0u)
	                    {
	                        _380 = -1.0;
	                    }
	                    else
	                    {
	                        _380 = 1.0;
	                    }
	                    vec4 _997 = _391;
	                    _997.w = _380;
	                    _391 = _997;
	                    _409[0] = _390;
	                    _410[0] = _997;
	                    uint _1001 = _906.y / 4u;
	                    vec4 _393 = _410[1];
	                    float _1016 = (float((g_Vertices_3[_66]._member0[_1001] >> 12u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _1019 = (float((g_Vertices_3[_66]._member0[_1001] >> 22u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _1023 = (1.0 - abs(_1016)) - abs(_1019);
	                    vec3 _1024 = vec3(_1016, _1019, _1023);
	                    float _1026 = saturate(-_1023);
	                    vec2 _1027 = vec2(_1016, _1019);
	                    vec2 _1033 = _1027 + mix(vec2(_1026), vec2(-_1026), greaterThanEqual(_1027, vec2(0.0)));
	                    _1024.x = _1033.x;
	                    _1024.y = _1033.y;
	                    vec3 _1038 = normalize(_1024);
	                    vec3 _392 = _1038;
	                    float _1039 = _1038.z;
	                    float _375;
	                    if (_1039 >= 0.0)
	                    {
	                        _375 = 1.0;
	                    }
	                    else
	                    {
	                        _375 = -1.0;
	                    }
	                    float _1046 = (-1.0) / (_375 + _1039);
	                    float _1047 = _1038.x;
	                    vec3 _376;
	                    vec3 _1055 = _376;
	                    _1055.x = 1.0 + (((_375 * _1047) * _1047) * _1046);
	                    _1055.y = _375 * ((_1047 * _1038.y) * _1046);
	                    _1055.z = (-_375) * _1047;
	                    _376 = _1055;
	                    float _1063 = float((g_Vertices_3[_66]._member0[_1001] >> uint(1)) & 2047u) * 0.003069460391998291015625;
	                    vec3 _1069 = (_1055 * cos(_1063)) + (cross(_1038, _1055) * sin(_1063));
	                    vec4 _1071 = _393;
	                    _1071.x = _1069.x;
	                    _1071.y = _1069.y;
	                    _1071.z = _1069.z;
	                    _393 = _1071;
	                    float _377;
	                    if ((g_Vertices_3[_66]._member0[_1001] & 1u) == 0u)
	                    {
	                        _377 = -1.0;
	                    }
	                    else
	                    {
	                        _377 = 1.0;
	                    }
	                    vec4 _1082 = _393;
	                    _1082.w = _377;
	                    _393 = _1082;
	                    _409[1] = _392;
	                    _410[1] = _1082;
	                    uint _1086 = _906.z / 4u;
	                    vec4 _395 = _410[2];
	                    float _1101 = (float((g_Vertices_3[_66]._member0[_1086] >> 12u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _1104 = (float((g_Vertices_3[_66]._member0[_1086] >> 22u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _1108 = (1.0 - abs(_1101)) - abs(_1104);
	                    vec3 _1109 = vec3(_1101, _1104, _1108);
	                    float _1111 = saturate(-_1108);
	                    vec2 _1112 = vec2(_1101, _1104);
	                    vec2 _1118 = _1112 + mix(vec2(_1111), vec2(-_1111), greaterThanEqual(_1112, vec2(0.0)));
	                    _1109.x = _1118.x;
	                    _1109.y = _1118.y;
	                    vec3 _1123 = normalize(_1109);
	                    vec3 _394 = _1123;
	                    float _1124 = _1123.z;
	                    float _372;
	                    if (_1124 >= 0.0)
	                    {
	                        _372 = 1.0;
	                    }
	                    else
	                    {
	                        _372 = -1.0;
	                    }
	                    float _1131 = (-1.0) / (_372 + _1124);
	                    float _1132 = _1123.x;
	                    vec3 _373;
	                    vec3 _1140 = _373;
	                    _1140.x = 1.0 + (((_372 * _1132) * _1132) * _1131);
	                    _1140.y = _372 * ((_1132 * _1123.y) * _1131);
	                    _1140.z = (-_372) * _1132;
	                    _373 = _1140;
	                    float _1148 = float((g_Vertices_3[_66]._member0[_1086] >> uint(1)) & 2047u) * 0.003069460391998291015625;
	                    vec3 _1154 = (_1140 * cos(_1148)) + (cross(_1123, _1140) * sin(_1148));
	                    vec4 _1156 = _395;
	                    _1156.x = _1154.x;
	                    _1156.y = _1154.y;
	                    _1156.z = _1154.z;
	                    _395 = _1156;
	                    float _374;
	                    if ((g_Vertices_3[_66]._member0[_1086] & 1u) == 0u)
	                    {
	                        _374 = -1.0;
	                    }
	                    else
	                    {
	                        _374 = 1.0;
	                    }
	                    vec4 _1167 = _395;
	                    _1167.w = _374;
	                    _395 = _1167;
	                    _409[2] = _394;
	                    _410[2] = _1167;
	                    break;
	                }
	                break;
	            }
	        }
	        else
	        {
	            _409[0] = vec3(0.0);
	            _409[1] = vec3(0.0);
	            _409[2] = vec3(0.0);
	        }
	        if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTangentFieldInfo.y != 0)
	        {
	            ivec4 _396 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers;
	            uint _70 = uint(_396[g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTangentFieldInfo.z]);
	            uint _1490 = uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTangentFieldInfo.z);
	            ivec4 _367 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes;
	            ivec4 _368 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes;
	            uvec3 _1506 = (uvec3(uint(_367[_1490])) * _411) + uvec3(uint(_368[_1490]) + uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTangentFieldInfo.x));
	            uint _1508 = _1506.x;
	            _410[0] = vec4(g_Vertices_1[_70]._member0[_1508 / 4u], g_Vertices_1[_70]._member0[(_1508 + 4u) / 4u], g_Vertices_1[_70]._member0[(_1508 + 8u) / 4u], g_Vertices_1[_70]._member0[(_1508 + 12u) / 4u]);
	            uint _1526 = _1506.y;
	            _410[1] = vec4(g_Vertices_1[_70]._member0[_1526 / 4u], g_Vertices_1[_70]._member0[(_1526 + 4u) / 4u], g_Vertices_1[_70]._member0[(_1526 + 8u) / 4u], g_Vertices_1[_70]._member0[(_1526 + 12u) / 4u]);
	            uint _1544 = _1506.z;
	            _410[2] = vec4(g_Vertices_1[_70]._member0[_1544 / 4u], g_Vertices_1[_70]._member0[(_1544 + 4u) / 4u], g_Vertices_1[_70]._member0[(_1544 + 8u) / 4u], g_Vertices_1[_70]._member0[(_1544 + 12u) / 4u]);
	        }
	        else
	        {
	            _410[0] = vec4(0.0);
	            _410[1] = vec4(0.0);
	            _410[2] = vec4(0.0);
	        }
	        break;
	    } while(false);
	    _407 = 0;
	    for (;;)
	    {
	        if (!(_407 < 3))
	        {
	            break;
	        }
	        vsInput[_407].vNormalOs = _409[_407];
	        vsInput[_407].vTangentUOs_flTangentVSign = _410[_407];
	        _407++;
	        continue;
	    }
	    vec2 _279 = vsInput[0].vTexCoord;
	    vec3 _365 = vsInput[0].vNormalOs;
	    vec4 _366;
	    vec4 _1590 = _366;
	    _1590.x = vsInput[0].vTangentUOs_flTangentVSign.x;
	    _1590.y = vsInput[0].vTangentUOs_flTangentVSign.y;
	    _1590.z = vsInput[0].vTangentUOs_flTangentVSign.z;
	    _1590.w = vsInput[0].vTangentUOs_flTangentVSign.w;
	    _366 = _1590;
	    PackedRtxInstanceData_t_natural_logical _1603;
	    _1603.nSrgbColor = g_instanceBuffer._member0[uint(gl_InstanceID)].nSrgbColor;
	    _1603.nTriangleGeometry = g_instanceBuffer._member0[uint(gl_InstanceID)].nTriangleGeometry;
	    _1603.nMaterialData = g_instanceBuffer._member0[uint(gl_InstanceID)].nMaterialData;
	    _1603.nMaterialFlags_nInstanceFlags = g_instanceBuffer._member0[uint(gl_InstanceID)].nMaterialFlags_nInstanceFlags;
	    _1603.fEmissiveBoost = g_instanceBuffer._member0[uint(gl_InstanceID)].fEmissiveBoost;
	    _1603.nInstanceFlags = g_instanceBuffer._member0[uint(gl_InstanceID)].nInstanceFlags;
	    _1603._pad1 = g_instanceBuffer._member0[uint(gl_InstanceID)]._pad1;
	    _1603._pad2 = g_instanceBuffer._member0[uint(gl_InstanceID)]._pad2;
	    vec4 _1614 = vec4(uvec4(_1603.nSrgbColor & 255u, (_1603.nSrgbColor & 65280u) >> uint(8), (_1603.nSrgbColor & 16711680u) >> uint(16), (_1603.nSrgbColor & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	    vec4 _364 = _1614;
	    vec3 _1615 = _1614.xyz;
	    vec3 _1616 = _1615 * vec3(0.077399380505084991455078125);
	    vec3 _1619 = pow((_1615 * vec3(0.947867333889007568359375)) + vec3(0.052132703363895416259765625), vec3(2.400000095367431640625));
	    float _361;
	    if (_1614.x <= 0.040449999272823333740234375)
	    {
	        _361 = _1616.x;
	    }
	    else
	    {
	        _361 = _1619.x;
	    }
	    float _362;
	    if (_1614.y <= 0.040449999272823333740234375)
	    {
	        _362 = _1616.y;
	    }
	    else
	    {
	        _362 = _1619.y;
	    }
	    float _363;
	    if (_1614.z <= 0.040449999272823333740234375)
	    {
	        _363 = _1616.z;
	    }
	    else
	    {
	        _363 = _1619.z;
	    }
	    vec3 _1644 = vec3(_361, _362, _363);
	    vec4 _1646 = _364;
	    _1646.x = _1644.x;
	    _1646.y = _1644.y;
	    _1646.z = _1644.z;
	    _364 = _1646;
	    vec4 _282;
	    vec4 _1653 = _282;
	    _1653.x = _1646.x;
	    _1653.y = _1646.y;
	    _1653.z = _1646.z;
	    _1653.w = _1646.w;
	    _282 = _1653;
	    mat3x4 _1664 = transpose(gl_WorldToObjectEXT);
	    mat3 _360;
	    mat3 _1667 = _360;
	    _1667[0] = _1664[0].xyz;
	    _1667[1] = _1664[1].xyz;
	    _1667[2] = _1664[2].xyz;
	    _360 = _1667;
	    vec3 _1676 = normalize(_1667 * _365.xyz);
	    vec3 _283;
	    vec3 _1678 = _283;
	    _1678.x = _1676.x;
	    _1678.y = _1676.y;
	    _1678.z = _1676.z;
	    _283 = _1678;
	    mat3x4 _1690 = transpose(gl_WorldToObjectEXT);
	    mat3 _359;
	    mat3 _1693 = _359;
	    _1693[0] = _1690[0].xyz;
	    _1693[1] = _1690[1].xyz;
	    _1693[2] = _1690[2].xyz;
	    _359 = _1693;
	    vec3 _1702 = normalize(_1693 * _366.xyz);
	    vec4 _281;
	    vec4 _1704 = _281;
	    _1704.x = _1702.x;
	    _1704.y = _1702.y;
	    _1704.z = _1702.z;
	    _1704.w = _366.w;
	    _281 = _1704;
	    vec4 _1713 = _279.xyxy;
	    vec4 _1726 = _1713;
	    _1726.x = dot(_1713.xy, _323.xy) + _323.w;
	    _1726.y = dot(_1713.xy, _322.xy) + _322.w;
	    vec2 _1734 = _1726.xy + (_321.xy * PerViewConstantBuffer_t.g_flGameTime);
	    vec4 _1736 = _1726;
	    _1736.x = _1734.x;
	    _1736.y = _1734.y;
	    vec3 _1742 = mix(vec3(1.0), _1653.xyz, vec3(_319));
	    vec4 _1744 = _1653;
	    _1744.x = _1742.x;
	    _1744.y = _1742.y;
	    _1744.z = _1742.z;
	    vec3 _1752 = _1744.xyz * _320.xyz;
	    vec4 _1754 = _1744;
	    _1754.x = _1752.x;
	    _1754.y = _1752.y;
	    _1754.z = _1752.z;
	    vec3 _274 = vec4(vsInput[0].vPositionOs.xyz, 1.0) * transpose(gl_ObjectToWorldEXT);
	    vec3 _273 = _1678;
	    vec4 _272 = _1736;
	    vec4 _271 = _1754;
	    vec4 _270 = _1704;
	    vec2 _278 = vsInput[1].vTexCoord;
	    vec3 _357 = vsInput[1].vNormalOs;
	    vec4 _358;
	    vec4 _1766 = _358;
	    _1766.x = vsInput[1].vTangentUOs_flTangentVSign.x;
	    _1766.y = vsInput[1].vTangentUOs_flTangentVSign.y;
	    _1766.z = vsInput[1].vTangentUOs_flTangentVSign.z;
	    _1766.w = vsInput[1].vTangentUOs_flTangentVSign.w;
	    _358 = _1766;
	    PackedRtxInstanceData_t_natural_logical _1779;
	    _1779.nSrgbColor = g_instanceBuffer._member0[uint(gl_InstanceID)].nSrgbColor;
	    _1779.nTriangleGeometry = g_instanceBuffer._member0[uint(gl_InstanceID)].nTriangleGeometry;
	    _1779.nMaterialData = g_instanceBuffer._member0[uint(gl_InstanceID)].nMaterialData;
	    _1779.nMaterialFlags_nInstanceFlags = g_instanceBuffer._member0[uint(gl_InstanceID)].nMaterialFlags_nInstanceFlags;
	    _1779.fEmissiveBoost = g_instanceBuffer._member0[uint(gl_InstanceID)].fEmissiveBoost;
	    _1779.nInstanceFlags = g_instanceBuffer._member0[uint(gl_InstanceID)].nInstanceFlags;
	    _1779._pad1 = g_instanceBuffer._member0[uint(gl_InstanceID)]._pad1;
	    _1779._pad2 = g_instanceBuffer._member0[uint(gl_InstanceID)]._pad2;
	    vec4 _1790 = vec4(uvec4(_1779.nSrgbColor & 255u, (_1779.nSrgbColor & 65280u) >> uint(8), (_1779.nSrgbColor & 16711680u) >> uint(16), (_1779.nSrgbColor & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	    vec4 _356 = _1790;
	    vec3 _1791 = _1790.xyz;
	    vec3 _1792 = _1791 * vec3(0.077399380505084991455078125);
	    vec3 _1795 = pow((_1791 * vec3(0.947867333889007568359375)) + vec3(0.052132703363895416259765625), vec3(2.400000095367431640625));
	    float _353;
	    if (_1790.x <= 0.040449999272823333740234375)
	    {
	        _353 = _1792.x;
	    }
	    else
	    {
	        _353 = _1795.x;
	    }
	    float _354;
	    if (_1790.y <= 0.040449999272823333740234375)
	    {
	        _354 = _1792.y;
	    }
	    else
	    {
	        _354 = _1795.y;
	    }
	    float _355;
	    if (_1790.z <= 0.040449999272823333740234375)
	    {
	        _355 = _1792.z;
	    }
	    else
	    {
	        _355 = _1795.z;
	    }
	    vec3 _1820 = vec3(_353, _354, _355);
	    vec4 _1822 = _356;
	    _1822.x = _1820.x;
	    _1822.y = _1820.y;
	    _1822.z = _1820.z;
	    _356 = _1822;
	    vec4 _285;
	    vec4 _1829 = _285;
	    _1829.x = _1822.x;
	    _1829.y = _1822.y;
	    _1829.z = _1822.z;
	    _1829.w = _1822.w;
	    _285 = _1829;
	    mat3x4 _1840 = transpose(gl_WorldToObjectEXT);
	    mat3 _352;
	    mat3 _1843 = _352;
	    _1843[0] = _1840[0].xyz;
	    _1843[1] = _1840[1].xyz;
	    _1843[2] = _1840[2].xyz;
	    _352 = _1843;
	    vec3 _1852 = normalize(_1843 * _357.xyz);
	    vec3 _286;
	    vec3 _1854 = _286;
	    _1854.x = _1852.x;
	    _1854.y = _1852.y;
	    _1854.z = _1852.z;
	    _286 = _1854;
	    mat3x4 _1866 = transpose(gl_WorldToObjectEXT);
	    mat3 _351;
	    mat3 _1869 = _351;
	    _1869[0] = _1866[0].xyz;
	    _1869[1] = _1866[1].xyz;
	    _1869[2] = _1866[2].xyz;
	    _351 = _1869;
	    vec3 _1878 = normalize(_1869 * _358.xyz);
	    vec4 _284;
	    vec4 _1880 = _284;
	    _1880.x = _1878.x;
	    _1880.y = _1878.y;
	    _1880.z = _1878.z;
	    _1880.w = _358.w;
	    _284 = _1880;
	    vec4 _1889 = _278.xyxy;
	    vec4 _1902 = _1889;
	    _1902.x = dot(_1889.xy, _323.xy) + _323.w;
	    _1902.y = dot(_1889.xy, _322.xy) + _322.w;
	    vec2 _1910 = _1902.xy + (_321.xy * PerViewConstantBuffer_t.g_flGameTime);
	    vec4 _1912 = _1902;
	    _1912.x = _1910.x;
	    _1912.y = _1910.y;
	    vec3 _1918 = mix(vec3(1.0), _1829.xyz, vec3(_319));
	    vec4 _1920 = _1829;
	    _1920.x = _1918.x;
	    _1920.y = _1918.y;
	    _1920.z = _1918.z;
	    vec3 _1928 = _1920.xyz * _320.xyz;
	    vec4 _1930 = _1920;
	    _1930.x = _1928.x;
	    _1930.y = _1928.y;
	    _1930.z = _1928.z;
	    vec3 _269 = vec4(vsInput[1].vPositionOs.xyz, 1.0) * transpose(gl_ObjectToWorldEXT);
	    vec3 _268 = _1854;
	    vec4 _267 = _1912;
	    vec4 _266 = _1930;
	    vec4 _265 = _1880;
	    vec2 _277 = vsInput[2].vTexCoord;
	    vec3 _349 = vsInput[2].vNormalOs;
	    vec4 _350;
	    vec4 _1942 = _350;
	    _1942.x = vsInput[2].vTangentUOs_flTangentVSign.x;
	    _1942.y = vsInput[2].vTangentUOs_flTangentVSign.y;
	    _1942.z = vsInput[2].vTangentUOs_flTangentVSign.z;
	    _1942.w = vsInput[2].vTangentUOs_flTangentVSign.w;
	    _350 = _1942;
	    PackedRtxInstanceData_t_natural_logical _1955;
	    _1955.nSrgbColor = g_instanceBuffer._member0[uint(gl_InstanceID)].nSrgbColor;
	    _1955.nTriangleGeometry = g_instanceBuffer._member0[uint(gl_InstanceID)].nTriangleGeometry;
	    _1955.nMaterialData = g_instanceBuffer._member0[uint(gl_InstanceID)].nMaterialData;
	    _1955.nMaterialFlags_nInstanceFlags = g_instanceBuffer._member0[uint(gl_InstanceID)].nMaterialFlags_nInstanceFlags;
	    _1955.fEmissiveBoost = g_instanceBuffer._member0[uint(gl_InstanceID)].fEmissiveBoost;
	    _1955.nInstanceFlags = g_instanceBuffer._member0[uint(gl_InstanceID)].nInstanceFlags;
	    _1955._pad1 = g_instanceBuffer._member0[uint(gl_InstanceID)]._pad1;
	    _1955._pad2 = g_instanceBuffer._member0[uint(gl_InstanceID)]._pad2;
	    vec4 _1966 = vec4(uvec4(_1955.nSrgbColor & 255u, (_1955.nSrgbColor & 65280u) >> uint(8), (_1955.nSrgbColor & 16711680u) >> uint(16), (_1955.nSrgbColor & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	    vec4 _348 = _1966;
	    vec3 _1967 = _1966.xyz;
	    vec3 _1968 = _1967 * vec3(0.077399380505084991455078125);
	    vec3 _1971 = pow((_1967 * vec3(0.947867333889007568359375)) + vec3(0.052132703363895416259765625), vec3(2.400000095367431640625));
	    float _345;
	    if (_1966.x <= 0.040449999272823333740234375)
	    {
	        _345 = _1968.x;
	    }
	    else
	    {
	        _345 = _1971.x;
	    }
	    float _346;
	    if (_1966.y <= 0.040449999272823333740234375)
	    {
	        _346 = _1968.y;
	    }
	    else
	    {
	        _346 = _1971.y;
	    }
	    float _347;
	    if (_1966.z <= 0.040449999272823333740234375)
	    {
	        _347 = _1968.z;
	    }
	    else
	    {
	        _347 = _1971.z;
	    }
	    vec3 _1996 = vec3(_345, _346, _347);
	    vec4 _1998 = _348;
	    _1998.x = _1996.x;
	    _1998.y = _1996.y;
	    _1998.z = _1996.z;
	    _348 = _1998;
	    vec4 _288;
	    vec4 _2005 = _288;
	    _2005.x = _1998.x;
	    _2005.y = _1998.y;
	    _2005.z = _1998.z;
	    _2005.w = _1998.w;
	    _288 = _2005;
	    mat3x4 _2016 = transpose(gl_WorldToObjectEXT);
	    mat3 _344;
	    mat3 _2019 = _344;
	    _2019[0] = _2016[0].xyz;
	    _2019[1] = _2016[1].xyz;
	    _2019[2] = _2016[2].xyz;
	    _344 = _2019;
	    vec3 _2028 = normalize(_2019 * _349.xyz);
	    vec3 _289;
	    vec3 _2030 = _289;
	    _2030.x = _2028.x;
	    _2030.y = _2028.y;
	    _2030.z = _2028.z;
	    _289 = _2030;
	    vec3 _2038 = vec4(vsInput[2].vPositionOs.xyz, 1.0) * transpose(gl_ObjectToWorldEXT);
	    mat3x4 _2042 = transpose(gl_WorldToObjectEXT);
	    mat3 _343;
	    mat3 _2045 = _343;
	    _2045[0] = _2042[0].xyz;
	    _2045[1] = _2042[1].xyz;
	    _2045[2] = _2042[2].xyz;
	    _343 = _2045;
	    vec3 _2054 = normalize(_2045 * _350.xyz);
	    vec4 _287;
	    vec4 _2056 = _287;
	    _2056.x = _2054.x;
	    _2056.y = _2054.y;
	    _2056.z = _2054.z;
	    _2056.w = _350.w;
	    _287 = _2056;
	    vec4 _2065 = _277.xyxy;
	    vec4 _2078 = _2065;
	    _2078.x = dot(_2065.xy, _323.xy) + _323.w;
	    _2078.y = dot(_2065.xy, _322.xy) + _322.w;
	    vec2 _2086 = _2078.xy + (_321.xy * PerViewConstantBuffer_t.g_flGameTime);
	    vec4 _2088 = _2078;
	    _2088.x = _2086.x;
	    _2088.y = _2086.y;
	    vec3 _2094 = mix(vec3(1.0), _2005.xyz, vec3(_319));
	    vec4 _2096 = _2005;
	    _2096.x = _2094.x;
	    _2096.y = _2094.y;
	    _2096.z = _2094.z;
	    vec3 _2104 = _2096.xyz * _320.xyz;
	    vec4 _2106 = _2096;
	    _2106.x = _2104.x;
	    _2106.y = _2104.y;
	    _2106.z = _2104.z;
	    vec3 _264 = _2038;
	    vec3 _263 = _2030;
	    vec3 _2131 = ((_273 * ((1.0 - attrs.barycentrics.x) - attrs.barycentrics.y)) + (_268 * attrs.barycentrics.x)) + (_2030 * attrs.barycentrics.y);
	    vec3 _290;
	    vec3 _297 = _2131;
	    vec4 _296 = ((_272 * ((1.0 - attrs.barycentrics.x) - attrs.barycentrics.y)) + (_267 * attrs.barycentrics.x)) + (_2088 * attrs.barycentrics.y);
	    vec4 _295 = ((_271 * ((1.0 - attrs.barycentrics.x) - attrs.barycentrics.y)) + (_266 * attrs.barycentrics.x)) + (_2106 * attrs.barycentrics.y);
	    vec3 _294 = _290;
	    vec4 _293 = ((_270 * ((1.0 - attrs.barycentrics.x) - attrs.barycentrics.y)) + (_265 * attrs.barycentrics.x)) + (_2056 * attrs.barycentrics.y);
	    vec3 _292 = normalize(cross(_269 - _274, _2038 - _274));
	    bool _291 = gl_HitKindEXT == 254u;
	    vec3 _312 = vec3(0.0);
	    float _311 = 0.039999999105930328369140625;
	    vec3 _310 = vec3(0.0);
	    vec3 _308 = vec3(1.0);
	    bool _307 = false;
	    vec3 _2166 = _2131.xyz;
	    vec3 _309 = _2166;
	    if (dot(_2166, _2166) >= 1.0099999904632568359375)
	    {
	        _309 = _294.xyz;
	    }
	    _311 = _315;
	    _308 = _292;
	    bool _341;
	    if (_316)
	    {
	        _341 = !_317;
	    }
	    else
	    {
	        _341 = false;
	    }
	    SPIRV_CROSS_BRANCH
	    if (_341)
	    {
	        float _342;
	        if (_291)
	        {
	            _342 = 1.0;
	        }
	        else
	        {
	            _342 = -1.0;
	        }
	        _309 *= _342;
	        if (_291)
	        {
	            _342 = 1.0;
	        }
	        else
	        {
	            _342 = -1.0;
	        }
	        _308 *= _342;
	        _307 = !_291;
	    }
	    vec3 _2198 = _309;
	    vec3 _2199 = normalize(_2198);
	    _309 = _2199;
	    vec3 _303 = _312;
	    float _302 = _311;
	    vec3 _301 = _310;
	    vec3 _300 = _2199;
	    vec3 _299 = _308;
	    bool _298 = _307;
	    vec3 _306 = textureLod(sampler2D(g_bindless_Texture2D_float4[_318], g_bindless_Sampler[_324]), _296.xy, 0.0).xyz * _295.xyz;
	    float _304 = _313;
	    vec4 _2224 = textureLod(sampler2D(g_bindless_Texture2D_float4[_314], g_bindless_Sampler[_325]), _296.xy, 0.0);
	    float _2225 = _2224.x;
	    float _2226 = _2224.y;
	    float _2228 = (_2225 + _2226) - 1.00392162799835205078125;
	    float _2229 = _2225 - _2226;
	    vec2 _305 = _2224.zz;
	    vec3 _339 = normalize(vec3(vec2(_2228, _2229), (1.0 - abs(_2228)) - abs(_2229)));
	    bool _337;
	    if (_316)
	    {
	        _337 = !_317;
	    }
	    else
	    {
	        _337 = false;
	    }
	    if (_337)
	    {
	        float _338;
	        if (_291)
	        {
	            _338 = 1.0;
	        }
	        else
	        {
	            _338 = -1.0;
	        }
	        _337 = _338 < 0.0;
	    }
	    else
	    {
	        _337 = false;
	    }
	    float _340;
	    if (_337)
	    {
	        _340 = -1.0;
	    }
	    else
	    {
	        _340 = 1.0;
	    }
	    float _2260 = _340;
	    vec3 _2261 = _297.xyz * _2260;
	    if (_293.w > 0.0)
	    {
	        _340 = 1.0;
	    }
	    else
	    {
	        _340 = -1.0;
	    }
	    bool _335;
	    if (_316)
	    {
	        _335 = !_317;
	    }
	    else
	    {
	        _335 = false;
	    }
	    if (_335)
	    {
	        float _336;
	        if (_291)
	        {
	            _336 = 1.0;
	        }
	        else
	        {
	            _336 = -1.0;
	        }
	        _335 = _336 < 0.0;
	    }
	    else
	    {
	        _335 = false;
	    }
	    if (!_335)
	    {
	        vec3 _2293 = _339;
	        _2293.y = -_2293.y;
	        _339 = _2293;
	    }
	    vec3 _2300 = _293.xyz * _339.x;
	    vec3 _334;
	    vec3 _2302 = _334;
	    _2302.x = _2300.x;
	    _2302.y = _2300.y;
	    _2302.z = _2300.z;
	    vec3 _2312 = _2302.xyz + ((cross(_2261.xyz, _293.xyz) * _340).xyz * _339.y);
	    vec3 _2314 = _2302;
	    _2314.x = _2312.x;
	    _2314.y = _2312.y;
	    _2314.z = _2312.z;
	    vec3 _2323 = _2314.xyz + (_2261.xyz * _339.z);
	    vec3 _2325 = _2314;
	    _2325.x = _2323.x;
	    _2325.y = _2323.y;
	    _2325.z = _2323.z;
	    _334 = _2325;
	    payload.nInstance = int(uint(gl_InstanceID));
	    payload.flHitT = gl_RayTmaxEXT;
	    payload.vFaceNormalWs = _299;
	    payload.vInterpolatedNormalWs = _300;
	    vec3 _332[3] = vec3[](_274, _269, _264);
	    vec3 _333[3] = vec3[](_273, _268, _263);
	    vec3 _2372 = ((_332[0] * ((1.0 - attrs.barycentrics.x) - attrs.barycentrics.y)) + (_332[1] * attrs.barycentrics.x)) + (_332[2] * attrs.barycentrics.y);
	    vec3 _326[3];
	    _326[0] = _2372 - (_333[0] * dot(_2372 - _332[0], _333[0]));
	    _326[1] = _2372 - (_333[1] * dot(_2372 - _332[1], _333[1]));
	    _326[2] = _2372 - (_333[2] * dot(_2372 - _332[2], _333[2]));
	    vec3 _2412 = ((_326[0] * ((1.0 - attrs.barycentrics.x) - attrs.barycentrics.y)) + (_326[1] * attrs.barycentrics.x)) + (_326[2] * attrs.barycentrics.y);
	    vec3 _327[3];
	    _327[0] = cross(_332[0] - _332[1], _299);
	    _327[1] = cross(_332[1] - _332[2], _299);
	    _327[2] = cross(_332[2] - _332[0], _299);
	    float _328 = dot(_2412 - _2372, _299);
	    vec3 _329 = _2412;
	    int _330 = 0;
	    for (;;)
	    {
	        bool _2428_ladder_break = false;
	        do
	        {
	            if (!(_330 < 3))
	            {
	                _2428_ladder_break = true;
	                break;
	            }
	            if (_328 > 0.00999999977648258209228515625)
	            {
	                _2428_ladder_break = true;
	                break;
	            }
	            if (dot(_327[_330], _327[_330]) == 0.0)
	            {
	                break;
	            }
	            _327[_330] = normalize(_327[_330]);
	            int _331 = 0;
	            for (;;)
	            {
	                if (!(_331 < 3))
	                {
	                    break;
	                }
	                vec3 _2466 = _333[_331] - (_327[_330] * dot(_327[_330], _333[_331]));
	                _326[_331] = _2372 - (_2466 * dot(_2372 - _332[_331], _2466));
	                _331++;
	                continue;
	            }
	            vec3 _2490 = ((_326[0] * ((1.0 - attrs.barycentrics.x) - attrs.barycentrics.y)) + (_326[1] * attrs.barycentrics.x)) + (_326[2] * attrs.barycentrics.y);
	            _328 = dot(_2490 - _2372, _299);
	            _329 = _2490;
	            break;
	        } while(false);
	        if (_2428_ladder_break)
	        {
	            break;
	        }
	        _330++;
	        continue;
	    }
	    if (!(_328 > 0.00999999977648258209228515625))
	    {
	        _329 = vec3(3.4028234663852885981170418348452e+38);
	    }
	    payload.vSmoothPositionWs = _329;
	    payload.bFlippedNormal = _298;
	    f16vec3 _2503 = f16vec3(vec3(0.0));
	    payload.material = MaterialDataMinimal_t(_2503, float16_t(0.0), f16vec3(vec3(1.0, 0.0, 1.0)), float16_t(1.0), _2503, float16_t(0.040008544921875), 0u, f16vec4(ivec4(0)));
	    payload.material.vNormalWs = f16vec3(normalize(_2325.xyz));
	    payload.material.vAlbedo = f16vec3(_306);
	    payload.material.vEmissive = f16vec3(_303);
	    payload.material.flReflectance = float16_t(_302);
	    payload.material.flMetalness = float16_t(_304);
	    payload.material.flRoughness = float16_t(dot(_305, vec2(0.5)));
	    if (any(greaterThan(_301, vec3(0.0))))
	    {
	        payload.material.nMaterialTypeAndFlags = (payload.material.nMaterialTypeAndFlags & 4294901760u) | 1u;
	        f16vec3 _2529 = f16vec3(_301);
	        payload.material.vMaterialBits.x = _2529.x;
	        payload.material.vMaterialBits.y = _2529.y;
	        payload.material.vMaterialBits.z = _2529.z;
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
	BoolAttribute(renderbackfaces, F_RENDER_BACKFACES || 0);
	
	#if (S_TRANSLUCENT == 0)
		TextureAttribute(LightSim_TintMaskTextureR, g_tTintMask);
	#endif
	#if (S_SHADER_QUALITY == 0)
		TextureAttribute(LightSim_TintMaskTextureR, g_tTintMask);
	#endif
	#if (S_PAINT_VERTEX_COLORS == 0)
		TextureAttribute(LightSim_TintMaskTextureR, g_tTintMask);
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
	#if (S_TINT_MASK == 1)
		TextureAttribute(LightSim_TintMaskTextureR, g_tTintMask);
	#endif
	#if (S_SELF_ILLUM == 1)
		TextureAttribute(LightSim_SelfIllumMaskTexture, g_tSelfIllumMask);
		Float3Attribute(LightSim_SelfIllumTint, g_vSelfIllumTint);
		FloatAttribute(LightSim_SelfIllumScale, g_flSelfIllumScale);
	#endif
	#if (S_TRANSLUCENT == 1)
		BoolAttribute(translucent, true);
		BoolAttribute(NoZPrepass, F_DISABLE_Z_PREPASS || 0);
	#endif
	#if (S_ADDITIVE_BLEND == 0)
		TextureAttribute(LightSim_TintMaskTextureR, g_tTintMask);
	#endif
	#if (S_SELF_ILLUM == 0)
		TextureAttribute(LightSim_TintMaskTextureR, g_tTintMask);
	#endif
	#if (S_MODE_TOOLS_VIS == 0)
		TextureAttribute(LightSim_TintMaskTextureR, g_tTintMask);
	#endif
	#if (S_PRE_BAKED_VERTEX_ANIMATION == 0)
		TextureAttribute(LightSim_TintMaskTextureR, g_tTintMask);
	#endif
	#if (S_PAINT_VERTEX_COLORS == 1)
		BoolAttribute(VertexPaintUIPickColor, true);
		BoolAttribute(VertexPaintUIPickColorAlpha, (F_ALPHA_TEST==1) || (F_TRANSLUCENT==1));
	#endif
	#if (S_ADDITIVE_BLEND == 1)
		BoolAttribute(translucent, true);
		BoolAttribute(NoZPrepass, F_DISABLE_Z_PREPASS || 0);
	#endif
	#if (S_TINT_MASK == 0)
		TextureAttribute(LightSim_SelfIllumMaskTexture, g_tSelfIllumMask);
		Float3Attribute(LightSim_SelfIllumTint, g_vSelfIllumTint);
		FloatAttribute(LightSim_SelfIllumScale, g_flSelfIllumScale);
	#endif
}
