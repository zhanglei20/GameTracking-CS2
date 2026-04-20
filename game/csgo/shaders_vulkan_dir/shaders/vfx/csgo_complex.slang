//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "uber shader with lots of configurability";
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
	
	cbuffer BakedLightingConstantBuffer_t < Attribute("BakedLightingConstantBuffer_t"); >;
	cbuffer PerViewConstantBufferCsgo_t < Attribute("PerViewConstantBufferCsgo_t"); >;
	cbuffer PerViewConstantBuffer_t < Attribute("PerViewConstantBuffer_t"); >;
	ByteAddressBuffer g_animatedVertexCache < Attribute("AnimatedVertexCache"); SrgbRead(false); >;
	bool g_bTexCoordScaleByModel < UiType(CheckBox); Expression((g_nScaleTexCoordUByModelScaleAxis!=0) || (g_nScaleTexCoordVByModelScaleAxis!=0)); >;
	ExternalDescriptorSet g_globalLateBoundBindlessSet < Source(ExternalDescSet); Attribute("g_globalLateBoundBindlessSet"); >;
	StructuredBuffer g_instanceBuffer < Attribute("InstanceBuffer"); SrgbRead(false); >;
	ExternalDescriptorSet g_lightBinnerGpuSet < Source(ExternalDescSet); Attribute("g_lightBinnerGpuSet"); >;
	int g_nTextureAnimationMode < UiType(Slider); Expression(F_TEXTURE_ANIMATION_MODE); >;
	StructuredBuffer g_transformBuffer < Attribute("TransformBuffer"); SrgbRead(false); >;
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
	// cbuffer ID 4459 (name: PerViewConstantBuffer_t), member index 1 (name: _m1) cannot be expressed with either HLSL packing layout or packoffset.
	// 
	// Re-attempting reflection with the GLSL backend.
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (7324 bytes), GLSL reflection with SPIRV-Cross by KhronosGroup
	
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
	
	struct _1906
	{
	    vec4 _m0[3];
	};
	
	struct _1760
	{
	    _1906 _m0;
	};
	
	struct _407
	{
	    vec4 _m0[4];
	};
	
	layout(set = 4, binding = 32, std430) readonly buffer g_instanceBuffer
	{
	    _1125 _m0[];
	} g_instanceBuffer_1;
	
	layout(set = 4, binding = 30, std430) readonly buffer g_transformBuffer
	{
	    _1760 _m0[];
	} g_transformBuffer_1;
	
	struct _1872
	{
	    _407 _m0;
	    float _m1;
	    vec4 _m2;
	};
	
	layout(set = 0) uniform _1872 PerViewConstantBuffer_t;
	
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
	    output_0 = _12151.xyz - PerViewConstantBufferCsgo_t._m0.xyz;
	    output_1 = _11179;
	    output_2 = _20488;
	    output_3 = _23714;
	    output_4 = _11179;
	    output_5 = vec4(normalize(vec4(vTangentUOs_flTangentVSign.xyz, 0.0) * _17839), vTangentUOs_flTangentVSign.w);
	    output_6 = (g_instanceBuffer_1._m0[nInstanceIdx]._m5) & 65535u;
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
	bool g_bTransmissiveShadows < UiType(CheckBox); Expression(F_DISABLE_TRANSMISSIVE_SHADOWS ? 0 : 1); >;
	bool g_bUseAlbedoForTransmissive < UiType(CheckBox); Expression(F_USE_ALBEDO_FOR_TRANSMISSIVE || 0); >;
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
	int g_nDecalBlendMode < UiType(Slider); Expression(F_DECAL_BLEND_MODE || 0); >;
	int g_nToolsVisMode < Attribute("g_nToolsVisMode"); UiType(Slider); >;
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
	#endif
	#if (S_ALPHA_TEST == 1)
	#endif
	#if (S_TRANSLUCENT == 1)
	#endif
	#if (S_ADDITIVE_BLEND == 1)
	#endif
	#if (S_DECAL_TEXTURE == 1)
	#endif
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (39340 bytes), HLSL reflection with SPIRV-Cross by KhronosGroup
	
	struct _2956
	{
	    float4 _m0[4];
	};
	
	struct _2746
	{
	    float4 _m0[3];
	};
	
	struct _2957
	{
	    float4 _m0[4];
	};
	
	struct _2747
	{
	    float4 _m0[3];
	};
	
	struct _2051
	{
	    _2956 _m0[4];
	};
	
	struct _161
	{
	    _2956 _m0;
	    _2956 _m1;
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
	    _2747 _m15;
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
	
	cbuffer PerViewConstantBufferCsgo_t : register(b4, space1)
	{
	    int4 PerViewConstantBufferCsgo_t_1_m0 : packoffset(c1);
	    int4 PerViewConstantBufferCsgo_t_1_m1 : packoffset(c2);
	    int4 PerViewConstantBufferCsgo_t_1_m2 : packoffset(c3);
	    uint PerViewConstantBufferCsgo_t_1_m3 : packoffset(c4.z);
	    uint PerViewConstantBufferCsgo_t_1_m4 : packoffset(c4.w);
	    uint PerViewConstantBufferCsgo_t_1_m5 : packoffset(c5);
	    uint PerViewConstantBufferCsgo_t_1_m6 : packoffset(c5.z);
	    uint PerViewConstantBufferCsgo_t_1_m7 : packoffset(c6.z);
	    _2956 PerViewConstantBufferCsgo_t_1_m8 : packoffset(c12);
	    float2 PerViewConstantBufferCsgo_t_1_m9 : packoffset(c16);
	    float PerViewConstantBufferCsgo_t_1_m10 : packoffset(c16.z);
	    float4 PerViewConstantBufferCsgo_t_1_m11 : packoffset(c23);
	    float4 PerViewConstantBufferCsgo_t_1_m12 : packoffset(c24);
	    float4 PerViewConstantBufferCsgo_t_1_m13 : packoffset(c25);
	    float4 PerViewConstantBufferCsgo_t_1_m14 : packoffset(c26);
	    float4 PerViewConstantBufferCsgo_t_1_m15 : packoffset(c27);
	    float4 PerViewConstantBufferCsgo_t_1_m16 : packoffset(c28);
	    _2956 PerViewConstantBufferCsgo_t_1_m17 : packoffset(c29);
	    float4 PerViewConstantBufferCsgo_t_1_m18 : packoffset(c33);
	    float4 PerViewConstantBufferCsgo_t_1_m19 : packoffset(c34);
	    float4 PerViewConstantBufferCsgo_t_1_m20 : packoffset(c35);
	};
	
	cbuffer PerViewLightingConstantBufferGpu_t : register(b0, space3)
	{
	    _2746 PerViewLightingConstantBufferGpu_t_1_m0 : packoffset(c7);
	    _2957 PerViewLightingConstantBufferGpu_t_1_m1 : packoffset(c11);
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
	    _2051 PerViewLightingConstantBufferGpu_t_1_m18 : packoffset(c1956);
	    _2957 PerViewLightingConstantBufferGpu_t_1_m19 : packoffset(c1988);
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
	        _12885 = !(_Globals_1_g_bDontFlipBackfaceNormals != 0);
	    }
	    else
	    {
	        _12885 = false;
	    }
	    float3 _10251;
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
	    float4 _19680 = g_bindless_Texture2D_float4[_Globals_1_g_tColor].Sample(undetermined[_Globals_1_g_sUserConfigAllowGlobalMipBias], input_2.xy);
	    float4 _19068 = g_bindless_Texture2D_float4[_Globals_1_g_tAmbientOcclusion].Sample(undetermined[_Globals_1_g_sUserConfig], float2(input_2.xy).xy);
	    float _17476 = _19068.x;
	    float4 _19372 = g_bindless_Texture2D_float4[_Globals_1_g_tNormal].Sample(undetermined[_Globals_1_g_sUserConfig], input_2.xy);
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
	    float2 _13392 = max(_19372.zz, pow(clamp(max(dot(_10347, _10347), dot(_12420, _12420)), 0.0f, 1.0f), 0.333000004291534423828125f).xx);
	    bool4 _24465 = bool4(PerViewConstantBufferCsgo_t_1_m0.x != int4(0, 0, 0, 0).x, PerViewConstantBufferCsgo_t_1_m0.y != int4(0, 0, 0, 0).y, PerViewConstantBufferCsgo_t_1_m0.z != int4(0, 0, 0, 0).z, PerViewConstantBufferCsgo_t_1_m0.w != int4(0, 0, 0, 0).w);
	    float _21785;
	    if (_24465.x)
	    {
	        float3 _11394 = _24347.xyz;
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
	        float4 _17422 = (max(float4(dot(PerViewLightingConstantBufferGpu_t_1_m1._m0[0].xyz, _11394), dot(PerViewLightingConstantBufferGpu_t_1_m1._m0[1].xyz, _11394), dot(PerViewLightingConstantBufferGpu_t_1_m1._m0[2].xyz, _11394), dot(PerViewLightingConstantBufferGpu_t_1_m1._m0[3].xyz, _11394)).xyzw, 0.0f.xxxx).xyzw * PerViewLightingConstantBufferGpu_t_1_m2.xyzw).xyzw;
	        _21785 = (1.0f / (dot(_17422, 1.0f.xxxx) + PerViewLightingConstantBufferGpu_t_1_m3.x)) * (PerViewLightingConstantBufferGpu_t_1_m3.x + dot(_17422, g_bindless_Texture2D_float4[PerViewConstantBufferCsgo_t_1_m4].SampleLevel(undetermined[_Globals_1_g_sPointClamp], (_11086 + float2(_13083.x ? PerViewConstantBufferCsgo_t_1_m9.xy.x : _23169.x, _13083.y ? PerViewConstantBufferCsgo_t_1_m9.xy.y : _23169.y).xy).xy, 0.0f).xyzw));
	    }
	    else
	    {
	        _21785 = 1.0f;
	    }
	    float3 _24735 = _14786.xyz;
	    float4 _23875 = float4(_24735, 1.0f);
	    float _21710;
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
	            float4 _18322 = mul(float4x4(float4(PerViewLightingConstantBufferGpu_t_1_m18._m0[_13039]._m0[0].x, PerViewLightingConstantBufferGpu_t_1_m18._m0[_13039]._m0[1].x, PerViewLightingConstantBufferGpu_t_1_m18._m0[_13039]._m0[2].x, PerViewLightingConstantBufferGpu_t_1_m18._m0[_13039]._m0[3].x), float4(PerViewLightingConstantBufferGpu_t_1_m18._m0[_13039]._m0[0].y, PerViewLightingConstantBufferGpu_t_1_m18._m0[_13039]._m0[1].y, PerViewLightingConstantBufferGpu_t_1_m18._m0[_13039]._m0[2].y, PerViewLightingConstantBufferGpu_t_1_m18._m0[_13039]._m0[3].y), float4(PerViewLightingConstantBufferGpu_t_1_m18._m0[_13039]._m0[0].z, PerViewLightingConstantBufferGpu_t_1_m18._m0[_13039]._m0[1].z, PerViewLightingConstantBufferGpu_t_1_m18._m0[_13039]._m0[2].z, PerViewLightingConstantBufferGpu_t_1_m18._m0[_13039]._m0[3].z), float4(PerViewLightingConstantBufferGpu_t_1_m18._m0[_13039]._m0[0].w, PerViewLightingConstantBufferGpu_t_1_m18._m0[_13039]._m0[1].w, PerViewLightingConstantBufferGpu_t_1_m18._m0[_13039]._m0[2].w, PerViewLightingConstantBufferGpu_t_1_m18._m0[_13039]._m0[3].w)), float4(input_0.xyz, 1.0f));
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
	                    float4 _19671 = mul(float4x4(float4(PerViewLightingConstantBufferGpu_t_1_m18._m0[_15335]._m0[0].x, PerViewLightingConstantBufferGpu_t_1_m18._m0[_15335]._m0[1].x, PerViewLightingConstantBufferGpu_t_1_m18._m0[_15335]._m0[2].x, PerViewLightingConstantBufferGpu_t_1_m18._m0[_15335]._m0[3].x), float4(PerViewLightingConstantBufferGpu_t_1_m18._m0[_15335]._m0[0].y, PerViewLightingConstantBufferGpu_t_1_m18._m0[_15335]._m0[1].y, PerViewLightingConstantBufferGpu_t_1_m18._m0[_15335]._m0[2].y, PerViewLightingConstantBufferGpu_t_1_m18._m0[_15335]._m0[3].y), float4(PerViewLightingConstantBufferGpu_t_1_m18._m0[_15335]._m0[0].z, PerViewLightingConstantBufferGpu_t_1_m18._m0[_15335]._m0[1].z, PerViewLightingConstantBufferGpu_t_1_m18._m0[_15335]._m0[2].z, PerViewLightingConstantBufferGpu_t_1_m18._m0[_15335]._m0[3].z), float4(PerViewLightingConstantBufferGpu_t_1_m18._m0[_15335]._m0[0].w, PerViewLightingConstantBufferGpu_t_1_m18._m0[_15335]._m0[1].w, PerViewLightingConstantBufferGpu_t_1_m18._m0[_15335]._m0[2].w, PerViewLightingConstantBufferGpu_t_1_m18._m0[_15335]._m0[3].w)), float4(input_0.xyz, 1.0f));
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
	        float _13279 = lerp(_19363, 1.0f, clamp((distance(_10061.xyz, PerViewConstantBuffer_t_1_m3) * PerViewLightingConstantBufferGpu_t_1_m17) + PerViewLightingConstantBufferGpu_t_1_m16, 0.0f, 1.0f));
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
	    float3 _9716;
	    float3 _24878;
	    if ((dot(PerViewLightingConstantBufferGpu_t_1_m9.xyz, _24735) * _21710) > 0.0f)
	    {
	        bool3 _19899 = all(bool3(_17892.x == 1.0f.xxx.x, _17892.y == 1.0f.xxx.y, _17892.z == 1.0f.xxx.z)).xxx;
	        float _11797 = max(0.0f, dot(_14786.xyz, PerViewLightingConstantBufferGpu_t_1_m9.xyz));
	        float2 _9840 = max(_13392, PerViewLightingConstantBufferGpu_t_1_m9.w.xx);
	        float3 _12281 = normalize(PerViewLightingConstantBufferGpu_t_1_m9.xyz + (-normalize(_10061.xyz - PerViewConstantBuffer_t_1_m3.xyz)).xyz).xyz;
	        float _12386 = dot(_12281, float3(_19899.x ? _24735.x : _17892.x, _19899.y ? _24735.y : _17892.y, _19899.z ? _24735.z : _17892.z).xyz);
	        float _19210 = max(0.0f, dot(PerViewLightingConstantBufferGpu_t_1_m9.xyz, _12281));
	        float _9850 = _9840.x;
	        float _25211 = _9850 * _9850;
	        float _19095 = _25211 * _25211;
	        float _15346 = ((_12386 * _12386) * (_19095 - 1.0f)) + 1.0f;
	        float3 _16808 = (PerViewLightingConstantBufferGpu_t_1_m10.xyz * _21710).xyz;
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
	        float4 _24259 = mul(float4x4(float4(PerViewConstantBufferCsgo_t_1_m8._m0[0].x, PerViewConstantBufferCsgo_t_1_m8._m0[1].x, PerViewConstantBufferCsgo_t_1_m8._m0[2].x, PerViewConstantBufferCsgo_t_1_m8._m0[3].x), float4(PerViewConstantBufferCsgo_t_1_m8._m0[0].y, PerViewConstantBufferCsgo_t_1_m8._m0[1].y, PerViewConstantBufferCsgo_t_1_m8._m0[2].y, PerViewConstantBufferCsgo_t_1_m8._m0[3].y), float4(PerViewConstantBufferCsgo_t_1_m8._m0[0].z, PerViewConstantBufferCsgo_t_1_m8._m0[1].z, PerViewConstantBufferCsgo_t_1_m8._m0[2].z, PerViewConstantBufferCsgo_t_1_m8._m0[3].z), float4(PerViewConstantBufferCsgo_t_1_m8._m0[0].w, PerViewConstantBufferCsgo_t_1_m8._m0[1].w, PerViewConstantBufferCsgo_t_1_m8._m0[2].w, PerViewConstantBufferCsgo_t_1_m8._m0[3].w)), float4(_10061.xyz, 1.0f).xyzw);
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
	                _2956 _25209;
	                [unroll]
	                for (int _4ident = 0; _4ident < 4; _4ident++)
	                {
	                    _25209._m0[_4ident] = asfloat(g_BarnLights.Load4(_4ident * 16 + _12608 * 416 + 0));
	                }
	                float4 _15817 = mul(float4(input_0.xyz, 1.0f), float4x4(float4(_25209._m0[0].x, _25209._m0[1].x, _25209._m0[2].x, _25209._m0[3].x), float4(_25209._m0[0].y, _25209._m0[1].y, _25209._m0[2].y, _25209._m0[3].y), float4(_25209._m0[0].z, _25209._m0[1].z, _25209._m0[2].z, _25209._m0[3].z), float4(_25209._m0[0].w, _25209._m0[1].w, _25209._m0[2].w, _25209._m0[3].w)));
	                float3 _10521 = _15817.xyz / _15817.w.xxx;
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
	                    _2747 _8549;
	                    [unroll]
	                    for (int _5ident = 0; _5ident < 3; _5ident++)
	                    {
	                        _8549._m0[_5ident] = asfloat(g_BarnLights.Load4(_5ident * 16 + _12608 * 416 + 272));
	                    }
	                    float3 _6368 = abs(mul(float4(input_0.xyz, 1.0f), float4x3(float3(_8549._m0[0].x, _8549._m0[1].x, _8549._m0[2].x), float3(_8549._m0[0].y, _8549._m0[1].y, _8549._m0[2].y), float3(_8549._m0[0].z, _8549._m0[1].z, _8549._m0[2].z), float3(_8549._m0[0].w, _8549._m0[1].w, _8549._m0[2].w))).xyz);
	                    _12887 = !all(bool3(_6368.x <= 1.0f.xxx.x, _6368.y <= 1.0f.xxx.y, _6368.z <= 1.0f.xxx.z));
	                }
	                if (_12887)
	                {
	                    _13212 = _13138;
	                    _15670 = _16325;
	                    break;
	                }
	                float _23572 = 2.0f * asfloat(g_BarnLights.Load4(_12608 * 416 + 176)).y;
	                float _18492 = (2.0f * asfloat(g_BarnLights.Load4(_12608 * 416 + 176)).z) * asfloat(g_BarnLights.Load4(_12608 * 416 + 176)).z;
	                float _14805 = 2.0f * asfloat(g_BarnLights.Load4(_12608 * 416 + 176)).x;
	                float _9058 = _14805 * asfloat(g_BarnLights.Load4(_12608 * 416 + 176)).y;
	                float _17330 = 2.0f * asfloat(g_BarnLights.Load4(_12608 * 416 + 176)).w;
	                float _19825 = _17330 * asfloat(g_BarnLights.Load4(_12608 * 416 + 176)).z;
	                float3 _16268 = float3(_9058 - _19825, (1.0f - (_14805 * asfloat(g_BarnLights.Load4(_12608 * 416 + 176)).x)) - _18492, (_23572 * asfloat(g_BarnLights.Load4(_12608 * 416 + 176)).z) + (_17330 * asfloat(g_BarnLights.Load4(_12608 * 416 + 176)).x)) * asfloat(g_BarnLights.Load3(_12608 * 416 + 192)).z;
	                float _21316;
	                if (asfloat(g_BarnLights.Load4(_12608 * 416 + 144)).z > 0.0f)
	                {
	                    _21316 = min(1.0f, _21776 * asfloat(g_BarnLights.Load4(_12608 * 416 + 144)).z);
	                }
	                else
	                {
	                    _21316 = 1.0f;
	                }
	                float _19667;
	                if (asfloat(g_BarnLights.Load4(_12608 * 416 + 144)).w > 0.0f)
	                {
	                    _19667 = _21316 * min(1.0f, (1.0f - _21776) * asfloat(g_BarnLights.Load4(_12608 * 416 + 144)).w);
	                }
	                else
	                {
	                    _19667 = _21316;
	                }
	                float3 _11179;
	                float _11633;
	                if (asfloat(g_BarnLights.Load4(_12608 * 416 + 128)).w != 0.0f)
	                {
	                    float3 _10017 = asfloat(g_BarnLights.Load4(_12608 * 416 + 128)).xyz - input_0.xyz;
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
	                    _11633 = ((_19667 * (asfloat(g_BarnLights.Load4(_12608 * 416 + 128)).w / max(_18345, asfloat(g_BarnLights.Load4(_12608 * 416 + 128)).w))) * clamp(asfloat(g_BarnLights.Load4(_12608 * 416 + 144)).x + (asfloat(g_BarnLights.Load4(_12608 * 416 + 144)).y * _17647), 0.0f, 1.0f)) * clamp(asfloat(g_BarnLights.Load3(_12608 * 416 + 192)).x + (asfloat(g_BarnLights.Load3(_12608 * 416 + 192)).y * dot(float3((1.0f - (_23572 * asfloat(g_BarnLights.Load4(_12608 * 416 + 176)).y)) - _18492, _9058 + _19825, (_14805 * asfloat(g_BarnLights.Load4(_12608 * 416 + 176)).z) - (_17330 * asfloat(g_BarnLights.Load4(_12608 * 416 + 176)).y)), normalize(_10210))), 0.0f, 1.0f);
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
	                        float3 _20492 = _14081;
	                        _20492.x = _20564.x;
	                        _20492.y = _20564.y;
	                        _12503 = _17828.xyz * g_bindless_Texture3D_float4[PerViewLightingConstantBufferGpu_t_1_m21].SampleLevel(undetermined[_Globals_1_g_sTrilinearWrap], _20492.xyz, 0.0f).xyz;
	                    }
	                    else
	                    {
	                        float3 _13791 = float3(mad(_22905.xy, float2(0.5f, -0.5f), 0.5f.xx), asfloat(g_BarnLights.Load4(_12608 * 416 + 160)).w);
	                        float2 _20563 = (_13791.xy * asfloat(g_BarnLights.Load4(_12608 * 416 + 224)).zw) + asfloat(g_BarnLights.Load4(_12608 * 416 + 224)).xy;
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
	                    float3 _20482 = _21548.xyz * lerp(1.0f, g_bindless_Texture2D_float4[PerViewLightingConstantBufferGpu_t_1_m20].SampleCmpLevelZero(undetermined_1[_Globals_1_g_tShadowDepthBufferCmpSampler], float3(mad(_19629.xy, asfloat(g_BarnLights.Load4(_12608 * 416 + 208)).zw, asfloat(g_BarnLights.Load4(_12608 * 416 + 208)).xy), _19629.z).xy, clamp(_19629.z + PerViewLightingConstantBufferGpu_t_1_m12, 0.0f, 1.0f)), asfloat(g_BarnLights.Load(_12608 * 416 + 260)));
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
	                float2 _9841 = max(_13392, asfloat(g_BarnLights.Load(_12608 * 416 + 256)).xx);
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
	    float _17172 = dot(_13392.xy, 0.5f.xx);
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
	    float3 _13436 = (_17476 * _21785).xxx.xyz;
	    float3 _22686 = ((_16324.xyz * _21785.xxx).xyz + (_8745 * (_21785 * _17476).xxx.xyz).xyz) * (_14202 * (1.0f - _Globals_1_g_flMetalness)).xyz;
	    float4 _11203 = float4(_22686, input_3.w);
	    _11203.x = _22686.x;
	    _11203.y = _22686.y;
	    _11203.z = _22686.z;
	    float3 _15752 = _11203.xyz + (_13137.xyz * _13436).xyz;
	    float4 _20490 = _11203;
	    _20490.x = _15752.x;
	    _20490.y = _15752.y;
	    _20490.z = _15752.z;
	    float3 _15734 = _20490.xyz + ((((lerp(_11427.xxx, _11427.yyy, _12351) * g_bindless_TextureCubeArray_float4[PerViewConstantBufferCsgo_t_1_m7].SampleLevel(undetermined[_Globals_1_g_sTrilinearClamp], float4(normalize(lerp(_6253, reflect(_17138.xyz, _17892.xyz).xyz, (_20711 * (sqrt(_20711) + _17225)).xxx)), 0.0f), PerViewLightingConstantBufferGpu_t_1_m8.y * sqrt(_17172)).xyz).xyz * (normalize(_16991 + 0.001000000047497451305389404296875f.xxx) * clamp(length(_16991), 0.0f, 1.75f))).xyz * (1.0f.xxx + (normalize(_8745 + 0.001000000047497451305389404296875f.xxx) * 0.5f))).xyz * _13436).xyz;
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
	#endif
	#if (S_ALPHA_TEST == 1)
	#endif
	#if (S_TRANSLUCENT == 1)
	#endif
	#if (S_ADDITIVE_BLEND == 1)
	#endif
	#if (S_DECAL_TEXTURE == 1)
	#endif
	
	// SPIR-V reflection failed for backend HLSL:
	// Unsupported builtin in HLSL: 5326
	// 
	// Re-attempting reflection with the GLSL backend.
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (58952 bytes), GLSL reflection with SPIRV-Cross by KhronosGroup
	
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
	
	vec4 _250;
	
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
	    uint _m0[];
	} g_MaterialData_1;
	
	layout(set = 3, binding = 34, std430) readonly buffer g_MaterialData_2
	{
	    float _m0[];
	} g_MaterialData_3;
	
	layout(set = 3, binding = 34, std430) readonly buffer g_MaterialData_4
	{
	    int _m0[];
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
	    uint _306 = g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 28u) / 4u];
	    uint _305 = g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 32u) / 4u];
	    vec4 _304 = vec4(g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 144u) / 4u], g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 148u) / 4u], g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 152u) / 4u], g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 156u) / 4u]);
	    vec4 _303 = vec4(g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 160u) / 4u], g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 164u) / 4u], g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 168u) / 4u], g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 172u) / 4u]);
	    vec2 _302 = vec2(g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 176u) / 4u], g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 180u) / 4u]);
	    vec3 _301 = vec3(g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 240u) / 4u], g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 244u) / 4u], g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 248u) / 4u]);
	    float _300 = g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 252u) / 4u];
	    uint _299 = g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 260u) / 4u];
	    bool _298 = g_MaterialData_5._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 316u) / 4u] != 0;
	    bool _297 = g_MaterialData_5._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 320u) / 4u] != 0;
	    float _296 = g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 324u) / 4u];
	    uint _295 = g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 328u) / 4u];
	    float _294 = g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 344u) / 4u];
	    uvec3 _392;
	    do
	    {
	        if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes.w == 4)
	        {
	            uint _549 = (12u * uint(gl_PrimitiveID)) + uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes.w);
	            _392 = uvec3(g_Indices_1[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._m0[_549 / 4u], g_Indices_1[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._m0[(_549 + 4u) / 4u], g_Indices_1[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._m0[(_549 + 8u) / 4u]);
	            break;
	        }
	        else
	        {
	            uint _524 = (6u * uint(gl_PrimitiveID)) + uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes.w);
	            uint _525 = _524 & 4294967292u;
	            uint _526 = _525 / 4u;
	            uint _530 = (_525 + 4u) / 4u;
	            uint _535 = (g_Indices_1[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._m0[_526] & 4294901760u) >> uint(16);
	            uint _536 = g_Indices_1[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._m0[_530] & 65535u;
	            uvec3 _393;
	            if (_524 == _525)
	            {
	                _393 = uvec3(g_Indices_1[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._m0[_526] & 65535u, _535, _536);
	            }
	            else
	            {
	                _393 = uvec3(_535, _536, (g_Indices_1[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._m0[_530] & 4294901760u) >> uint(16));
	            }
	            _392 = _393;
	            break;
	        }
	        break;
	    } while(false);
	    uint _564 = uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.x);
	    uvec3 _572 = (uvec3(uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes.x)) * _392) + uvec3(uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes.x));
	    vec3 _387[3];
	    uint _574 = _572.x;
	    _387[0] = vec3(g_Vertices_1[_564]._m0[_574 / 4u], g_Vertices_1[_564]._m0[(_574 + 4u) / 4u], g_Vertices_1[_564]._m0[(_574 + 8u) / 4u]);
	    uint _588 = _572.y;
	    _387[1] = vec3(g_Vertices_1[_564]._m0[_588 / 4u], g_Vertices_1[_564]._m0[(_588 + 4u) / 4u], g_Vertices_1[_564]._m0[(_588 + 8u) / 4u]);
	    uint _602 = _572.z;
	    _387[2] = vec3(g_Vertices_1[_564]._m0[_602 / 4u], g_Vertices_1[_564]._m0[(_602 + 4u) / 4u], g_Vertices_1[_564]._m0[(_602 + 8u) / 4u]);
	    int _388 = 0;
	    VS_INPUT vsInput[3];
	    for (;;)
	    {
	        if (!(_388 < 3))
	        {
	            break;
	        }
	        vsInput[_388].nInstanceIdx = _387[_388];
	        _388++;
	        continue;
	    }
	    vec2 _389[3];
	    _389[0] = vec2(0.0);
	    _389[1] = vec2(0.0);
	    _389[2] = vec2(0.0);
	    if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].y != 0)
	    {
	        ivec4 _386 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers;
	        uint _645 = uint(_386[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].z]);
	        uint _647 = uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].z);
	        ivec4 _384 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes;
	        ivec4 _385 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes;
	        uvec3 _658 = (uvec3(uint(_384[_647])) * _392) + uvec3(uint(_385[_647]) + uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].x));
	        if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].y == 16)
	        {
	            uint _793 = _658.x;
	            _389[0] = vec2(g_Vertices_1[_645]._m0[_793 / 4u], g_Vertices_1[_645]._m0[(_793 + 4u) / 4u]);
	            uint _802 = _658.y;
	            _389[1] = vec2(g_Vertices_1[_645]._m0[_802 / 4u], g_Vertices_1[_645]._m0[(_802 + 4u) / 4u]);
	            uint _811 = _658.z;
	            _389[2] = vec2(g_Vertices_1[_645]._m0[_811 / 4u], g_Vertices_1[_645]._m0[(_811 + 4u) / 4u]);
	        }
	        else
	        {
	            if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].y == 34)
	            {
	                uint _764 = _658.x / 4u;
	                _389[0] = vec2(uint16BitsToFloat16(u16vec2(uvec2(g_Vertices_3[_645]._m0[_764], g_Vertices_3[_645]._m0[_764] >> uint(16)) & uvec2(65535u))));
	                uint _774 = _658.y / 4u;
	                _389[1] = vec2(uint16BitsToFloat16(u16vec2(uvec2(g_Vertices_3[_645]._m0[_774], g_Vertices_3[_645]._m0[_774] >> uint(16)) & uvec2(65535u))));
	                uint _784 = _658.z / 4u;
	                _389[2] = vec2(uint16BitsToFloat16(u16vec2(uvec2(g_Vertices_3[_645]._m0[_784], g_Vertices_3[_645]._m0[_784] >> uint(16)) & uvec2(65535u))));
	            }
	            else
	            {
	                if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].y == 37)
	                {
	                    uint _671 = _658.x / 4u;
	                    uint _675 = (g_Vertices_3[_645]._m0[_671] & 65535u);
	                    int _383;
	                    if (_675 > 32767u)
	                    {
	                        _383 = int(4294901760u | _675);
	                    }
	                    else
	                    {
	                        _383 = int(_675);
	                    }
	                    uint _688 = (g_Vertices_3[_645]._m0[_671] & 4294901760u) >> uint(16);
	                    int _382;
	                    if (_688 > 32767u)
	                    {
	                        _382 = int(4294901760u | _688);
	                    }
	                    else
	                    {
	                        _382 = int(_688);
	                    }
	                    _389[0] = vec2(max(float(_383) * 3.0518509447574615478515625e-05, -1.0), max(float(_382) * 3.0518509447574615478515625e-05, -1.0));
	                    uint _702 = _658.y / 4u;
	                    uint _706 = (g_Vertices_3[_645]._m0[_702] & 65535u);
	                    int _381;
	                    if (_706 > 32767u)
	                    {
	                        _381 = int(4294901760u | _706);
	                    }
	                    else
	                    {
	                        _381 = int(_706);
	                    }
	                    uint _719 = (g_Vertices_3[_645]._m0[_702] & 4294901760u) >> uint(16);
	                    int _380;
	                    if (_719 > 32767u)
	                    {
	                        _380 = int(4294901760u | _719);
	                    }
	                    else
	                    {
	                        _380 = int(_719);
	                    }
	                    _389[1] = vec2(max(float(_381) * 3.0518509447574615478515625e-05, -1.0), max(float(_380) * 3.0518509447574615478515625e-05, -1.0));
	                    uint _733 = _658.z / 4u;
	                    uint _737 = (g_Vertices_3[_645]._m0[_733] & 65535u);
	                    int _379;
	                    if (_737 > 32767u)
	                    {
	                        _379 = int(4294901760u | _737);
	                    }
	                    else
	                    {
	                        _379 = int(_737);
	                    }
	                    uint _750 = (g_Vertices_3[_645]._m0[_733] & 4294901760u) >> uint(16);
	                    int _378;
	                    if (_750 > 32767u)
	                    {
	                        _378 = int(4294901760u | _750);
	                    }
	                    else
	                    {
	                        _378 = int(_750);
	                    }
	                    _389[2] = vec2(max(float(_379) * 3.0518509447574615478515625e-05, -1.0), max(float(_378) * 3.0518509447574615478515625e-05, -1.0));
	                }
	            }
	        }
	    }
	    _388 = 0;
	    for (;;)
	    {
	        if (!(_388 < 3))
	        {
	            break;
	        }
	        vsInput[_388]._m1 = _389[_388];
	        _388++;
	        continue;
	    }
	    vec3 _390[3];
	    vec4 _391[3];
	    do
	    {
	        if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.y != 0)
	        {
	            ivec4 _364 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers;
	            uint _853 = uint(_364[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.z]);
	            uint _855 = uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.z);
	            ivec4 _362 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes;
	            ivec4 _363 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes;
	            uvec3 _866 = (uvec3(uint(_362[_855])) * _392) + uvec3(uint(_363[_855]) + uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.x));
	            if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.y == 6)
	            {
	                uint _1397 = _866.x;
	                _390[0] = vec3(g_Vertices_1[_853]._m0[_1397 / 4u], g_Vertices_1[_853]._m0[(_1397 + 4u) / 4u], g_Vertices_1[_853]._m0[(_1397 + 8u) / 4u]);
	                uint _1411 = _866.y;
	                _390[1] = vec3(g_Vertices_1[_853]._m0[_1411 / 4u], g_Vertices_1[_853]._m0[(_1411 + 4u) / 4u], g_Vertices_1[_853]._m0[(_1411 + 8u) / 4u]);
	                uint _1425 = _866.z;
	                _390[2] = vec3(g_Vertices_1[_853]._m0[_1425 / 4u], g_Vertices_1[_853]._m0[(_1425 + 4u) / 4u], g_Vertices_1[_853]._m0[(_1425 + 8u) / 4u]);
	            }
	            else
	            {
	                if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.y == 17)
	                {
	                    uint _1130 = _866.x;
	                    uvec2 _1138 = uvec2(g_Vertices_3[_853]._m0[_1130 / 4u], g_Vertices_3[_853]._m0[(_1130 + 4u) / 4u]);
	                    uint _1139 = _866.y;
	                    uvec2 _268 = uvec2(g_Vertices_3[_853]._m0[_1139 / 4u], g_Vertices_3[_853]._m0[(_1139 + 4u) / 4u]);
	                    uint _1148 = _866.z;
	                    uvec2 _267 = uvec2(g_Vertices_3[_853]._m0[_1148 / 4u], g_Vertices_3[_853]._m0[(_1148 + 4u) / 4u]);
	                    uint _1160 = _1138.x;
	                    uint _1169 = _1138.y;
	                    vec2 _1179 = ((vec2(float((_1160) & 65535u), float((_1160 >> 16u) & 65535u)) * vec2(1.525902189314365386962890625e-05)) * 2.0) - vec2(1.0);
	                    float _1180 = _1179.x;
	                    float _1185 = (1.0 - abs(_1180)) - abs(_1179.y);
	                    vec3 _1186 = vec3(_1180, _1179.y, _1185);
	                    float _1188 = saturate(-_1185);
	                    vec2 _1194 = _1179 + mix(vec2(_1188), vec2(-_1188), greaterThanEqual(_1179, vec2(0.0)));
	                    _1186.x = _1194.x;
	                    _1186.y = _1194.y;
	                    vec3 _372 = normalize(_1186);
	                    vec2 _1201 = ((vec2(float((_1169 >> uint(1)) & 32767u), float((_1169 >> 16u) & 32767u)) * vec2(3.0518509447574615478515625e-05)) * 2.0) - vec2(1.0);
	                    float _1202 = _1201.x;
	                    float _1207 = (1.0 - abs(_1202)) - abs(_1201.y);
	                    vec3 _1208 = vec3(_1202, _1201.y, _1207);
	                    float _1210 = saturate(-_1207);
	                    vec2 _1216 = _1201 + mix(vec2(_1210), vec2(-_1210), greaterThanEqual(_1201, vec2(0.0)));
	                    _1208.x = _1216.x;
	                    _1208.y = _1216.y;
	                    vec3 _371 = normalize(_1208);
	                    float _352;
	                    if ((_1169 & 1u) != 0u)
	                    {
	                        _352 = 1.0;
	                    }
	                    else
	                    {
	                        _352 = -1.0;
	                    }
	                    _390[0] = _372;
	                    _391[0].w = _352;
	                    _391[0].x = _371.x;
	                    _391[0].y = _371.y;
	                    _391[0].z = _371.z;
	                    vec2 _1259 = ((vec2(float((_268.x) & 65535u), float((_268.x >> 16u) & 65535u)) * vec2(1.525902189314365386962890625e-05)) * 2.0) - vec2(1.0);
	                    float _1260 = _1259.x;
	                    float _1265 = (1.0 - abs(_1260)) - abs(_1259.y);
	                    vec3 _1266 = vec3(_1260, _1259.y, _1265);
	                    float _1268 = saturate(-_1265);
	                    vec2 _1274 = _1259 + mix(vec2(_1268), vec2(-_1268), greaterThanEqual(_1259, vec2(0.0)));
	                    _1266.x = _1274.x;
	                    _1266.y = _1274.y;
	                    vec3 _374 = normalize(_1266);
	                    vec2 _1281 = ((vec2(float((_268.y >> uint(1)) & 32767u), float((_268.y >> 16u) & 32767u)) * vec2(3.0518509447574615478515625e-05)) * 2.0) - vec2(1.0);
	                    float _1282 = _1281.x;
	                    float _1287 = (1.0 - abs(_1282)) - abs(_1281.y);
	                    vec3 _1288 = vec3(_1282, _1281.y, _1287);
	                    float _1290 = saturate(-_1287);
	                    vec2 _1296 = _1281 + mix(vec2(_1290), vec2(-_1290), greaterThanEqual(_1281, vec2(0.0)));
	                    _1288.x = _1296.x;
	                    _1288.y = _1296.y;
	                    vec3 _373 = normalize(_1288);
	                    float _351;
	                    if ((_268.y & 1u) != 0u)
	                    {
	                        _351 = 1.0;
	                    }
	                    else
	                    {
	                        _351 = -1.0;
	                    }
	                    _390[1] = _374;
	                    _391[1].w = _351;
	                    _391[1].x = _373.x;
	                    _391[1].y = _373.y;
	                    _391[1].z = _373.z;
	                    vec2 _1339 = ((vec2(float((_267.x) & 65535u), float((_267.x >> 16u) & 65535u)) * vec2(1.525902189314365386962890625e-05)) * 2.0) - vec2(1.0);
	                    float _1340 = _1339.x;
	                    float _1345 = (1.0 - abs(_1340)) - abs(_1339.y);
	                    vec3 _1346 = vec3(_1340, _1339.y, _1345);
	                    float _1348 = saturate(-_1345);
	                    vec2 _1354 = _1339 + mix(vec2(_1348), vec2(-_1348), greaterThanEqual(_1339, vec2(0.0)));
	                    _1346.x = _1354.x;
	                    _1346.y = _1354.y;
	                    vec3 _376 = normalize(_1346);
	                    vec2 _1361 = ((vec2(float((_267.y >> uint(1)) & 32767u), float((_267.y >> 16u) & 32767u)) * vec2(3.0518509447574615478515625e-05)) * 2.0) - vec2(1.0);
	                    float _1362 = _1361.x;
	                    float _1367 = (1.0 - abs(_1362)) - abs(_1361.y);
	                    vec3 _1368 = vec3(_1362, _1361.y, _1367);
	                    float _1370 = saturate(-_1367);
	                    vec2 _1376 = _1361 + mix(vec2(_1370), vec2(-_1370), greaterThanEqual(_1361, vec2(0.0)));
	                    _1368.x = _1376.x;
	                    _1368.y = _1376.y;
	                    vec3 _375 = normalize(_1368);
	                    float _350;
	                    if ((_267.y & 1u) != 0u)
	                    {
	                        _350 = 1.0;
	                    }
	                    else
	                    {
	                        _350 = -1.0;
	                    }
	                    _390[2] = _376;
	                    _391[2].w = _350;
	                    _391[2].x = _375.x;
	                    _391[2].y = _375.y;
	                    _391[2].z = _375.z;
	                    break;
	                }
	                else
	                {
	                    uint _876 = _866.x / 4u;
	                    vec4 _366 = _391[0];
	                    float _891 = (float((g_Vertices_3[_853]._m0[_876] >> 12u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _894 = (float((g_Vertices_3[_853]._m0[_876] >> 22u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _898 = (1.0 - abs(_891)) - abs(_894);
	                    vec3 _899 = vec3(_891, _894, _898);
	                    float _901 = saturate(-_898);
	                    vec2 _902 = vec2(_891, _894);
	                    vec2 _908 = _902 + mix(vec2(_901), vec2(-_901), greaterThanEqual(_902, vec2(0.0)));
	                    _899.x = _908.x;
	                    _899.y = _908.y;
	                    vec3 _913 = normalize(_899);
	                    vec3 _365 = _913;
	                    float _914 = _913.z;
	                    float _359;
	                    if (_914 >= 0.0)
	                    {
	                        _359 = 1.0;
	                    }
	                    else
	                    {
	                        _359 = -1.0;
	                    }
	                    float _921 = (-1.0) / (_359 + _914);
	                    float _922 = _913.x;
	                    vec3 _360;
	                    vec3 _930 = _360;
	                    _930.x = 1.0 + (((_359 * _922) * _922) * _921);
	                    _930.y = _359 * ((_922 * _913.y) * _921);
	                    _930.z = (-_359) * _922;
	                    _360 = _930;
	                    float _938 = float((g_Vertices_3[_853]._m0[_876] >> uint(1)) & 2047u) * 0.003069460391998291015625;
	                    vec3 _944 = (_930 * cos(_938)) + (cross(_913, _930) * sin(_938));
	                    vec4 _946 = _366;
	                    _946.x = _944.x;
	                    _946.y = _944.y;
	                    _946.z = _944.z;
	                    _366 = _946;
	                    float _361;
	                    if ((g_Vertices_3[_853]._m0[_876] & 1u) == 0u)
	                    {
	                        _361 = -1.0;
	                    }
	                    else
	                    {
	                        _361 = 1.0;
	                    }
	                    vec4 _957 = _366;
	                    _957.w = _361;
	                    _366 = _957;
	                    _390[0] = _365;
	                    _391[0] = _957;
	                    uint _961 = _866.y / 4u;
	                    vec4 _368 = _391[1];
	                    float _976 = (float((g_Vertices_3[_853]._m0[_961] >> 12u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _979 = (float((g_Vertices_3[_853]._m0[_961] >> 22u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _983 = (1.0 - abs(_976)) - abs(_979);
	                    vec3 _984 = vec3(_976, _979, _983);
	                    float _986 = saturate(-_983);
	                    vec2 _987 = vec2(_976, _979);
	                    vec2 _993 = _987 + mix(vec2(_986), vec2(-_986), greaterThanEqual(_987, vec2(0.0)));
	                    _984.x = _993.x;
	                    _984.y = _993.y;
	                    vec3 _998 = normalize(_984);
	                    vec3 _367 = _998;
	                    float _999 = _998.z;
	                    float _356;
	                    if (_999 >= 0.0)
	                    {
	                        _356 = 1.0;
	                    }
	                    else
	                    {
	                        _356 = -1.0;
	                    }
	                    float _1006 = (-1.0) / (_356 + _999);
	                    float _1007 = _998.x;
	                    vec3 _357;
	                    vec3 _1015 = _357;
	                    _1015.x = 1.0 + (((_356 * _1007) * _1007) * _1006);
	                    _1015.y = _356 * ((_1007 * _998.y) * _1006);
	                    _1015.z = (-_356) * _1007;
	                    _357 = _1015;
	                    float _1023 = float((g_Vertices_3[_853]._m0[_961] >> uint(1)) & 2047u) * 0.003069460391998291015625;
	                    vec3 _1029 = (_1015 * cos(_1023)) + (cross(_998, _1015) * sin(_1023));
	                    vec4 _1031 = _368;
	                    _1031.x = _1029.x;
	                    _1031.y = _1029.y;
	                    _1031.z = _1029.z;
	                    _368 = _1031;
	                    float _358;
	                    if ((g_Vertices_3[_853]._m0[_961] & 1u) == 0u)
	                    {
	                        _358 = -1.0;
	                    }
	                    else
	                    {
	                        _358 = 1.0;
	                    }
	                    vec4 _1042 = _368;
	                    _1042.w = _358;
	                    _368 = _1042;
	                    _390[1] = _367;
	                    _391[1] = _1042;
	                    uint _1046 = _866.z / 4u;
	                    vec4 _370 = _391[2];
	                    float _1061 = (float((g_Vertices_3[_853]._m0[_1046] >> 12u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _1064 = (float((g_Vertices_3[_853]._m0[_1046] >> 22u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _1068 = (1.0 - abs(_1061)) - abs(_1064);
	                    vec3 _1069 = vec3(_1061, _1064, _1068);
	                    float _1071 = saturate(-_1068);
	                    vec2 _1072 = vec2(_1061, _1064);
	                    vec2 _1078 = _1072 + mix(vec2(_1071), vec2(-_1071), greaterThanEqual(_1072, vec2(0.0)));
	                    _1069.x = _1078.x;
	                    _1069.y = _1078.y;
	                    vec3 _1083 = normalize(_1069);
	                    vec3 _369 = _1083;
	                    float _1084 = _1083.z;
	                    float _353;
	                    if (_1084 >= 0.0)
	                    {
	                        _353 = 1.0;
	                    }
	                    else
	                    {
	                        _353 = -1.0;
	                    }
	                    float _1091 = (-1.0) / (_353 + _1084);
	                    float _1092 = _1083.x;
	                    vec3 _354;
	                    vec3 _1100 = _354;
	                    _1100.x = 1.0 + (((_353 * _1092) * _1092) * _1091);
	                    _1100.y = _353 * ((_1092 * _1083.y) * _1091);
	                    _1100.z = (-_353) * _1092;
	                    _354 = _1100;
	                    float _1108 = float((g_Vertices_3[_853]._m0[_1046] >> uint(1)) & 2047u) * 0.003069460391998291015625;
	                    vec3 _1114 = (_1100 * cos(_1108)) + (cross(_1083, _1100) * sin(_1108));
	                    vec4 _1116 = _370;
	                    _1116.x = _1114.x;
	                    _1116.y = _1114.y;
	                    _1116.z = _1114.z;
	                    _370 = _1116;
	                    float _355;
	                    if ((g_Vertices_3[_853]._m0[_1046] & 1u) == 0u)
	                    {
	                        _355 = -1.0;
	                    }
	                    else
	                    {
	                        _355 = 1.0;
	                    }
	                    vec4 _1127 = _370;
	                    _1127.w = _355;
	                    _370 = _1127;
	                    _390[2] = _369;
	                    _391[2] = _1127;
	                    break;
	                }
	                break;
	            }
	        }
	        else
	        {
	            _390[0] = vec3(0.0);
	            _390[1] = vec3(0.0);
	            _390[2] = vec3(0.0);
	        }
	        if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTangentFieldInfo.y != 0)
	        {
	            ivec4 _377 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers;
	            uint _1450 = uint(_377[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTangentFieldInfo.z]);
	            uint _1452 = uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTangentFieldInfo.z);
	            ivec4 _348 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes;
	            ivec4 _349 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes;
	            uvec3 _1463 = (uvec3(uint(_348[_1452])) * _392) + uvec3(uint(_349[_1452]) + uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTangentFieldInfo.x));
	            uint _1465 = _1463.x;
	            _391[0] = vec4(g_Vertices_1[_1450]._m0[_1465 / 4u], g_Vertices_1[_1450]._m0[(_1465 + 4u) / 4u], g_Vertices_1[_1450]._m0[(_1465 + 8u) / 4u], g_Vertices_1[_1450]._m0[(_1465 + 12u) / 4u]);
	            uint _1483 = _1463.y;
	            _391[1] = vec4(g_Vertices_1[_1450]._m0[_1483 / 4u], g_Vertices_1[_1450]._m0[(_1483 + 4u) / 4u], g_Vertices_1[_1450]._m0[(_1483 + 8u) / 4u], g_Vertices_1[_1450]._m0[(_1483 + 12u) / 4u]);
	            uint _1501 = _1463.z;
	            _391[2] = vec4(g_Vertices_1[_1450]._m0[_1501 / 4u], g_Vertices_1[_1450]._m0[(_1501 + 4u) / 4u], g_Vertices_1[_1450]._m0[(_1501 + 8u) / 4u], g_Vertices_1[_1450]._m0[(_1501 + 12u) / 4u]);
	        }
	        else
	        {
	            _391[0] = vec4(0.0);
	            _391[1] = vec4(0.0);
	            _391[2] = vec4(0.0);
	        }
	        break;
	    } while(false);
	    _388 = 0;
	    for (;;)
	    {
	        if (!(_388 < 3))
	        {
	            break;
	        }
	        vsInput[_388]._m2 = _390[_388];
	        vsInput[_388]._m3 = _391[_388];
	        _388++;
	        continue;
	    }
	    vec3 _346 = vsInput[0]._m2;
	    vec4 _347;
	    vec4 _1545 = _347;
	    _1545.x = vsInput[0]._m3.x;
	    _1545.y = vsInput[0]._m3.y;
	    _1545.z = vsInput[0]._m3.z;
	    _1545.w = vsInput[0]._m3.w;
	    _347 = _1545;
	    vec4 _1570 = vec4(uvec4((g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 255u), (g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 65280u) >> uint(8), (g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 16711680u) >> uint(16), (g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	    vec4 _345 = _1570;
	    vec3 _1571 = _1570.xyz;
	    vec3 _1572 = _1571 * vec3(0.077399380505084991455078125);
	    vec3 _1575 = pow((_1571 * vec3(0.947867333889007568359375)) + vec3(0.052132703363895416259765625), vec3(2.400000095367431640625));
	    float _342;
	    if (_1570.x <= 0.040449999272823333740234375)
	    {
	        _342 = _1572.x;
	    }
	    else
	    {
	        _342 = _1575.x;
	    }
	    float _343;
	    if (_1570.y <= 0.040449999272823333740234375)
	    {
	        _343 = _1572.y;
	    }
	    else
	    {
	        _343 = _1575.y;
	    }
	    float _344;
	    if (_1570.z <= 0.040449999272823333740234375)
	    {
	        _344 = _1572.z;
	    }
	    else
	    {
	        _344 = _1575.z;
	    }
	    vec3 _1600 = vec3(_342, _343, _344);
	    vec4 _1602 = _345;
	    _1602.x = _1600.x;
	    _1602.y = _1600.y;
	    _1602.z = _1600.z;
	    _345 = _1602;
	    vec4 _270;
	    vec4 _1609 = _270;
	    _1609.x = _1602.x;
	    _1609.y = _1602.y;
	    _1609.z = _1602.z;
	    _1609.w = _1602.w;
	    _270 = _1609;
	    mat3x4 _1620 = transpose(gl_WorldToObjectEXT);
	    mat3 _341;
	    mat3 _1623 = _341;
	    _1623[0] = _1620[0].xyz;
	    _1623[1] = _1620[1].xyz;
	    _1623[2] = _1620[2].xyz;
	    _341 = _1623;
	    vec3 _1632 = normalize(_1623 * _346.xyz);
	    vec3 _271;
	    vec3 _1634 = _271;
	    _1634.x = _1632.x;
	    _1634.y = _1632.y;
	    _1634.z = _1632.z;
	    _271 = _1634;
	    mat3x4 _1646 = transpose(gl_WorldToObjectEXT);
	    mat3 _340;
	    mat3 _1649 = _340;
	    _1649[0] = _1646[0].xyz;
	    _1649[1] = _1646[1].xyz;
	    _1649[2] = _1646[2].xyz;
	    _340 = _1649;
	    vec3 _1658 = normalize(_1649 * _347.xyz);
	    vec4 _269;
	    vec4 _1660 = _269;
	    _1660.x = _1658.x;
	    _1660.y = _1658.y;
	    _1660.z = _1658.z;
	    _1660.w = _347.w;
	    _269 = _1660;
	    vec4 _1669 = vsInput[0]._m1.xyxy;
	    vec4 _1682 = _1669;
	    _1682.x = dot(_1669.xy, _304.xy) + _304.w;
	    _1682.y = dot(_1669.xy, _303.xy) + _303.w;
	    vec2 _1690 = _1682.xy + (_302.xy * PerViewConstantBuffer_t.g_flGameTime);
	    vec4 _1692 = _1682;
	    _1692.x = _1690.x;
	    _1692.y = _1690.y;
	    vec3 _1698 = mix(vec3(1.0), _1609.xyz, vec3(_300));
	    vec4 _1700 = _1609;
	    _1700.x = _1698.x;
	    _1700.y = _1698.y;
	    _1700.z = _1698.z;
	    vec3 _1708 = _1700.xyz * _301.xyz;
	    vec4 _1710 = _1700;
	    _1710.x = _1708.x;
	    _1710.y = _1708.y;
	    _1710.z = _1708.z;
	    vec3 _266 = vec4(vsInput[0].nInstanceIdx.xyz, 1.0) * transpose(gl_ObjectToWorldEXT);
	    vec3 _265 = _1634;
	    vec4 _264 = _1692;
	    vec4 _263 = _1710;
	    vec4 _262 = _1660;
	    vec3 _338 = vsInput[1]._m2;
	    vec4 _339;
	    vec4 _1720 = _339;
	    _1720.x = vsInput[1]._m3.x;
	    _1720.y = vsInput[1]._m3.y;
	    _1720.z = vsInput[1]._m3.z;
	    _1720.w = vsInput[1]._m3.w;
	    _339 = _1720;
	    vec4 _1745 = vec4(uvec4((g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 255u), (g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 65280u) >> uint(8), (g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 16711680u) >> uint(16), (g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	    vec4 _337 = _1745;
	    vec3 _1746 = _1745.xyz;
	    vec3 _1747 = _1746 * vec3(0.077399380505084991455078125);
	    vec3 _1750 = pow((_1746 * vec3(0.947867333889007568359375)) + vec3(0.052132703363895416259765625), vec3(2.400000095367431640625));
	    float _334;
	    if (_1745.x <= 0.040449999272823333740234375)
	    {
	        _334 = _1747.x;
	    }
	    else
	    {
	        _334 = _1750.x;
	    }
	    float _335;
	    if (_1745.y <= 0.040449999272823333740234375)
	    {
	        _335 = _1747.y;
	    }
	    else
	    {
	        _335 = _1750.y;
	    }
	    float _336;
	    if (_1745.z <= 0.040449999272823333740234375)
	    {
	        _336 = _1747.z;
	    }
	    else
	    {
	        _336 = _1750.z;
	    }
	    vec3 _1775 = vec3(_334, _335, _336);
	    vec4 _1777 = _337;
	    _1777.x = _1775.x;
	    _1777.y = _1775.y;
	    _1777.z = _1775.z;
	    _337 = _1777;
	    vec4 _273;
	    vec4 _1784 = _273;
	    _1784.x = _1777.x;
	    _1784.y = _1777.y;
	    _1784.z = _1777.z;
	    _1784.w = _1777.w;
	    _273 = _1784;
	    mat3x4 _1795 = transpose(gl_WorldToObjectEXT);
	    mat3 _333;
	    mat3 _1798 = _333;
	    _1798[0] = _1795[0].xyz;
	    _1798[1] = _1795[1].xyz;
	    _1798[2] = _1795[2].xyz;
	    _333 = _1798;
	    vec3 _1807 = normalize(_1798 * _338.xyz);
	    vec3 _274;
	    vec3 _1809 = _274;
	    _1809.x = _1807.x;
	    _1809.y = _1807.y;
	    _1809.z = _1807.z;
	    _274 = _1809;
	    mat3x4 _1821 = transpose(gl_WorldToObjectEXT);
	    mat3 _332;
	    mat3 _1824 = _332;
	    _1824[0] = _1821[0].xyz;
	    _1824[1] = _1821[1].xyz;
	    _1824[2] = _1821[2].xyz;
	    _332 = _1824;
	    vec3 _1833 = normalize(_1824 * _339.xyz);
	    vec4 _272;
	    vec4 _1835 = _272;
	    _1835.x = _1833.x;
	    _1835.y = _1833.y;
	    _1835.z = _1833.z;
	    _1835.w = _339.w;
	    _272 = _1835;
	    vec4 _1844 = vsInput[1]._m1.xyxy;
	    vec4 _1857 = _1844;
	    _1857.x = dot(_1844.xy, _304.xy) + _304.w;
	    _1857.y = dot(_1844.xy, _303.xy) + _303.w;
	    vec2 _1865 = _1857.xy + (_302.xy * PerViewConstantBuffer_t.g_flGameTime);
	    vec4 _1867 = _1857;
	    _1867.x = _1865.x;
	    _1867.y = _1865.y;
	    vec3 _1873 = mix(vec3(1.0), _1784.xyz, vec3(_300));
	    vec4 _1875 = _1784;
	    _1875.x = _1873.x;
	    _1875.y = _1873.y;
	    _1875.z = _1873.z;
	    vec3 _1883 = _1875.xyz * _301.xyz;
	    vec4 _1885 = _1875;
	    _1885.x = _1883.x;
	    _1885.y = _1883.y;
	    _1885.z = _1883.z;
	    vec3 _261 = vec4(vsInput[1].nInstanceIdx.xyz, 1.0) * transpose(gl_ObjectToWorldEXT);
	    vec3 _260 = _1809;
	    vec4 _259 = _1867;
	    vec4 _258 = _1885;
	    vec4 _257 = _1835;
	    vec3 _330 = vsInput[2]._m2;
	    vec4 _331;
	    vec4 _1895 = _331;
	    _1895.x = vsInput[2]._m3.x;
	    _1895.y = vsInput[2]._m3.y;
	    _1895.z = vsInput[2]._m3.z;
	    _1895.w = vsInput[2]._m3.w;
	    _331 = _1895;
	    vec4 _1920 = vec4(uvec4((g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 255u), (g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 65280u) >> uint(8), (g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 16711680u) >> uint(16), (g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	    vec4 _329 = _1920;
	    vec3 _1921 = _1920.xyz;
	    vec3 _1922 = _1921 * vec3(0.077399380505084991455078125);
	    vec3 _1925 = pow((_1921 * vec3(0.947867333889007568359375)) + vec3(0.052132703363895416259765625), vec3(2.400000095367431640625));
	    float _326;
	    if (_1920.x <= 0.040449999272823333740234375)
	    {
	        _326 = _1922.x;
	    }
	    else
	    {
	        _326 = _1925.x;
	    }
	    float _327;
	    if (_1920.y <= 0.040449999272823333740234375)
	    {
	        _327 = _1922.y;
	    }
	    else
	    {
	        _327 = _1925.y;
	    }
	    float _328;
	    if (_1920.z <= 0.040449999272823333740234375)
	    {
	        _328 = _1922.z;
	    }
	    else
	    {
	        _328 = _1925.z;
	    }
	    vec3 _1950 = vec3(_326, _327, _328);
	    vec4 _1952 = _329;
	    _1952.x = _1950.x;
	    _1952.y = _1950.y;
	    _1952.z = _1950.z;
	    _329 = _1952;
	    vec4 _276;
	    vec4 _1959 = _276;
	    _1959.x = _1952.x;
	    _1959.y = _1952.y;
	    _1959.z = _1952.z;
	    _1959.w = _1952.w;
	    _276 = _1959;
	    mat3x4 _1970 = transpose(gl_WorldToObjectEXT);
	    mat3 _325;
	    mat3 _1973 = _325;
	    _1973[0] = _1970[0].xyz;
	    _1973[1] = _1970[1].xyz;
	    _1973[2] = _1970[2].xyz;
	    _325 = _1973;
	    vec3 _1982 = normalize(_1973 * _330.xyz);
	    vec3 _277;
	    vec3 _1984 = _277;
	    _1984.x = _1982.x;
	    _1984.y = _1982.y;
	    _1984.z = _1982.z;
	    _277 = _1984;
	    vec3 _1992 = vec4(vsInput[2].nInstanceIdx.xyz, 1.0) * transpose(gl_ObjectToWorldEXT);
	    mat3x4 _1996 = transpose(gl_WorldToObjectEXT);
	    mat3 _324;
	    mat3 _1999 = _324;
	    _1999[0] = _1996[0].xyz;
	    _1999[1] = _1996[1].xyz;
	    _1999[2] = _1996[2].xyz;
	    _324 = _1999;
	    vec3 _2008 = normalize(_1999 * _331.xyz);
	    vec4 _275;
	    vec4 _2010 = _275;
	    _2010.x = _2008.x;
	    _2010.y = _2008.y;
	    _2010.z = _2008.z;
	    _2010.w = _331.w;
	    _275 = _2010;
	    vec4 _2032;
	    _2032.x = dot(vsInput[2]._m1.xyxy.xy, _304.xy) + _304.w;
	    _2032.y = dot(vsInput[2]._m1.xyxy.xy, _303.xy) + _303.w;
	    vec2 _2040 = _2032.xy + (_302.xy * PerViewConstantBuffer_t.g_flGameTime);
	    vec4 _2042;
	    _2042.x = _2040.x;
	    _2042.y = _2040.y;
	    vec3 _2048 = mix(vec3(1.0), _1959.xyz, vec3(_300));
	    vec4 _2050;
	    _2050.x = _2048.x;
	    _2050.y = _2048.y;
	    _2050.z = _2048.z;
	    vec3 _2058 = _2050.xyz * _301.xyz;
	    vec4 _2060;
	    _2060.x = _2058.x;
	    _2060.y = _2058.y;
	    _2060.z = _2058.z;
	    vec3 _256 = _1992;
	    vec3 _255 = _1984;
	    vec3 _2084 = ((_265 * ((1.0 - _22.barycentrics.x) - _22.barycentrics.y)) + (_260 * _22.barycentrics.x)) + (_1984 * _22.barycentrics.y);
	    bool _2090 = gl_HitKindEXT == 254u;
	    vec4 _2099 = ((_264 * ((1.0 - _22.barycentrics.x) - _22.barycentrics.y)) + (_259 * _22.barycentrics.x)) + (_2042 * _22.barycentrics.y);
	    vec4 _2117 = ((_262 * ((1.0 - _22.barycentrics.x) - _22.barycentrics.y)) + (_257 * _22.barycentrics.x)) + (_2010 * _22.barycentrics.y);
	    vec3 _278;
	    vec3 _293 = vec3(0.0);
	    float _292 = 0.039999999105930328369140625;
	    vec3 _291 = vec3(0.0);
	    vec3 _289 = vec3(1.0);
	    bool _288 = false;
	    vec3 _2119 = _2084.xyz;
	    vec3 _290 = _2119;
	    if (dot(_2119, _2119) >= 1.0099999904632568359375)
	    {
	        _290 = _278.xyz;
	    }
	    _292 = _296;
	    _289 = normalize(cross(_261 - _266, _1992 - _266));
	    bool _322;
	    if (_297)
	    {
	        _322 = !_298;
	    }
	    else
	    {
	        _322 = false;
	    }
	    if (_322)
	    {
	        float _323;
	        if (_2090)
	        {
	            _323 = 1.0;
	        }
	        else
	        {
	            _323 = -1.0;
	        }
	        _290 *= _323;
	        if (_2090)
	        {
	            _323 = 1.0;
	        }
	        else
	        {
	            _323 = -1.0;
	        }
	        _289 *= _323;
	        _288 = !_2090;
	    }
	    vec3 _2148 = _290;
	    vec3 _2149 = normalize(_2148);
	    _290 = _2149;
	    vec3 _284 = _293;
	    float _283 = _292;
	    vec3 _282 = _291;
	    vec3 _281 = _2149;
	    vec3 _280 = _289;
	    bool _279 = _288;
	    vec3 _287 = textureLod(sampler2D(g_bindless_Texture2D_float4[_299], g_bindless_Sampler[_305]), _2099.xy, 0.0).xyz * (((_263 * ((1.0 - _22.barycentrics.x) - _22.barycentrics.y)) + (_258 * _22.barycentrics.x)) + (_2060 * _22.barycentrics.y)).xyz;
	    float _285 = _294;
	    vec4 _2172 = textureLod(sampler2D(g_bindless_Texture2D_float4[_295], g_bindless_Sampler[_306]), _2099.xy, 0.0);
	    float _2173 = _2172.x;
	    float _2174 = _2172.y;
	    float _2176 = (_2173 + _2174) - 1.00392162799835205078125;
	    float _2177 = _2173 - _2174;
	    vec2 _286 = _2172.zz;
	    vec3 _320 = normalize(vec3(vec2(_2176, _2177), (1.0 - abs(_2176)) - abs(_2177)));
	    bool _318;
	    if (_297)
	    {
	        _318 = !_298;
	    }
	    else
	    {
	        _318 = false;
	    }
	    if (_318)
	    {
	        float _319;
	        if (_2090)
	        {
	            _319 = 1.0;
	        }
	        else
	        {
	            _319 = -1.0;
	        }
	        _318 = _319 < 0.0;
	    }
	    else
	    {
	        _318 = false;
	    }
	    float _321;
	    if (_318)
	    {
	        _321 = -1.0;
	    }
	    else
	    {
	        _321 = 1.0;
	    }
	    float _2206 = _321;
	    vec3 _2207 = _2084.xyz * _2206;
	    if (_2117.w > 0.0)
	    {
	        _321 = 1.0;
	    }
	    else
	    {
	        _321 = -1.0;
	    }
	    bool _316;
	    if (_297)
	    {
	        _316 = !_298;
	    }
	    else
	    {
	        _316 = false;
	    }
	    if (_316)
	    {
	        float _317;
	        if (_2090)
	        {
	            _317 = 1.0;
	        }
	        else
	        {
	            _317 = -1.0;
	        }
	        _316 = _317 < 0.0;
	    }
	    else
	    {
	        _316 = false;
	    }
	    if (!_316)
	    {
	        vec3 _2237 = _320;
	        _2237.y = -_2237.y;
	        _320 = _2237;
	    }
	    vec3 _2244 = _2117.xyz * _320.x;
	    vec3 _315;
	    vec3 _2246 = _315;
	    _2246.x = _2244.x;
	    _2246.y = _2244.y;
	    _2246.z = _2244.z;
	    vec3 _2256 = _2246.xyz + ((cross(_2207.xyz, _2117.xyz) * _321).xyz * _320.y);
	    vec3 _2258 = _2246;
	    _2258.x = _2256.x;
	    _2258.y = _2256.y;
	    _2258.z = _2256.z;
	    vec3 _2267 = _2258.xyz + (_2207.xyz * _320.z);
	    vec3 _2269 = _2258;
	    _2269.x = _2267.x;
	    _2269.y = _2267.y;
	    _2269.z = _2267.z;
	    _315 = _2269;
	    _21._m5 = int(uint(gl_InstanceID));
	    _21._m3 = gl_RayTmaxEXT;
	    _21._m1 = _280;
	    _21._m2 = _281;
	    vec3 _307[3] = vec3[](_265, _260, _255);
	    vec3 _308[3] = vec3[](_266, _261, _256);
	    vec3 _2310 = ((_266 * ((1.0 - _22.barycentrics.x) - _22.barycentrics.y)) + (_261 * _22.barycentrics.x)) + (_256 * _22.barycentrics.y);
	    vec3 _309[3];
	    _309[0] = _2310 - (_265 * dot(_2310 - _266, _265));
	    _309[1] = _2310 - (_260 * dot(_2310 - _261, _260));
	    _309[2] = _2310 - (_255 * dot(_2310 - _256, _255));
	    vec3 _2338 = ((_309[0] * ((1.0 - _22.barycentrics.x) - _22.barycentrics.y)) + (_309[1] * _22.barycentrics.x)) + (_309[2] * _22.barycentrics.y);
	    vec3 _310[3];
	    _310[0] = cross(_266 - _261, _21._m1);
	    _310[1] = cross(_261 - _256, _21._m1);
	    _310[2] = cross(_256 - _266, _21._m1);
	    float _311 = dot(_2338 - _2310, _21._m1);
	    vec3 _312 = _2338;
	    int _313 = 0;
	    for (;;)
	    {
	        bool _2354_ladder_break = false;
	        do
	        {
	            if (!(_313 < 3))
	            {
	                _2354_ladder_break = true;
	                break;
	            }
	            if (_311 > 0.00999999977648258209228515625)
	            {
	                _2354_ladder_break = true;
	                break;
	            }
	            if (dot(_310[_313], _310[_313]) == 0.0)
	            {
	                break;
	            }
	            _310[_313] = normalize(_310[_313]);
	            int _314 = 0;
	            for (;;)
	            {
	                if (!(_314 < 3))
	                {
	                    break;
	                }
	                vec3 _2392 = _307[_314] - (_310[_313] * dot(_310[_313], _307[_314]));
	                _309[_314] = _2310 - (_2392 * dot(_2310 - _308[_314], _2392));
	                _314++;
	                continue;
	            }
	            vec3 _2416 = ((_309[0] * ((1.0 - _22.barycentrics.x) - _22.barycentrics.y)) + (_309[1] * _22.barycentrics.x)) + (_309[2] * _22.barycentrics.y);
	            _311 = dot(_2416 - _2310, _21._m1);
	            _312 = _2416;
	            break;
	        } while(false);
	        if (_2354_ladder_break)
	        {
	            break;
	        }
	        _313++;
	        continue;
	    }
	    if (!(_311 > 0.00999999977648258209228515625))
	    {
	        _312 = vec3(3.4028234663852885981170418348452e+38);
	    }
	    _21.material = _312;
	    _21._m6 = _279;
	    f16vec3 _2429 = f16vec3(vec3(0.0));
	    _21._m7 = MaterialDataMinimal_t(_2429, float16_t(0.0), f16vec3(vec3(1.0, 0.0, 1.0)), float16_t(1.0), _2429, float16_t(0.040008544921875), 0u, f16vec4(ivec4(0)));
	    _21._m7.vMaterialBits = f16vec3(normalize(_2269.xyz));
	    _21._m7._m2 = f16vec3(_287);
	    _21._m7._m4 = f16vec3(_284);
	    _21._m7._m5 = float16_t(_283);
	    _21._m7._m1 = float16_t(_285);
	    _21._m7._m3 = float16_t(dot(_286, vec2(0.5)));
	    if (any(greaterThan(_282, vec3(0.0))))
	    {
	        f16vec4 _2458 = _21._m7._m7;
	        f16vec3 _2461 = f16vec3(_282);
	        _2458.x = _2461.x;
	        _2458.y = _2461.y;
	        _2458.z = _2461.z;
	        _21._m7 = MaterialDataMinimal_t(_21._m7.vMaterialBits, _21._m7._m1, _21._m7._m2, _21._m7._m3, _21._m7._m4, _21._m7._m5, (_21._m7._m6 & 4294901760u) | 1u, _2458);
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
