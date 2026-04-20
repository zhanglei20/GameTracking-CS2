//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "CS2 Character Shader";
	DevShader = false;
	Version = 8;
	
	// VcsVersion: 70
	// Platform: VULKAN_SM_50
	// Programs: ps, psrs, vs
}

MODES
{
	Depth(S_MODE_DEPTH);
	Decals("csgo_decal_renderer.vfx");
	CsgoForward();
	ToolsVis(S_MODE_TOOLS_VIS);
	ToolsWireframe("csgo_tools_wireframe.vfx");
	ToolsShadingComplexity("csgo_tools_shading_complexity.vfx");
	FirstpersonLegsPrepass("csgo_legs_prepass.vfx");
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
	Feature( F_DECAL_TEXTURE, 0..1, "Decal Texture" );
	Feature( F_DECAL_BLEND_MODE, 0..1, "Decal Blend Mode" );
	Feature( F_ANISOTROPIC_GLOSS, 0..1, "PBR" );
	Feature( F_RETRO_REFLECTIVE, 0..1, "PBR" );
	Feature( F_SPHERICAL_PROJECTED_ANISOTROPIC_TANGENTS, 0..1, "PBR" );
	Feature( F_ANISOTROPIC_HAIR, 0..1, "PBR" );
	Feature( F_IRIDESCENCE, 0..1, "PBR" );
	Feature( F_SUBSURFACE_SCATTERING, 0..1, "Skin" );
	Feature( F_CLOTH_SHADING, 0..1, "PBR" );
	Feature( F_PATCHES, 0..1, "Enable Patches" );
	Feature( F_SUPPORTS_DECALS, 0..1, "Blood Decals" );
	Feature( F_EYEBALLS, 0..1, "Eyeballs" );
	Feature( F_DISTANCE_CONTRAST_ADJUSTMENT, 0..1, "Visibility" );
	Feature( F_ENABLE_ADJUSTMENTS, 0..1, "Adjustments" );
	Feature( F_DETAIL_TEXTURE, 0..1 (0="Multiply", 1="Replace"), "Adjustments" );
	FeatureRule( Requires( F_DONT_FLIP_BACKFACE_NORMALS, F_RENDER_BACKFACES ), "Only applies to backfaces" );
	FeatureRule( Allow1( F_ALPHA_TEST, F_TRANSLUCENT ), "Translucent and Alpha Test are not compatible" );
	FeatureRule( Requires( F_ADDITIVE_BLEND, F_TRANSLUCENT ), "Requires translucency" );
	FeatureRule( Allow1( F_TRANSLUCENT, F_DO_NOT_CAST_SHADOWS ), "Translucent and Do Not Cast Shadows are not compatible" );
	FeatureRule( Allow1( F_ANISOTROPIC_GLOSS, F_ADDITIVE_BLEND ), "Anisotropic Gloss and Additive Blend are incompatible" );
	FeatureRule( Allow1( F_RETRO_REFLECTIVE, F_ADDITIVE_BLEND ), "Retro reflective and Additive Blend are incompatible" );
	FeatureRule( ChildOf( F_SPHERICAL_PROJECTED_ANISOTROPIC_TANGENTS, F_ANISOTROPIC_GLOSS ), "Spherical Projected Anisotropic Tangents require Anisotropic Gloss" );
	FeatureRule( ChildOf( F_ANISOTROPIC_HAIR, F_ANISOTROPIC_GLOSS ), "Anisotropic Hair requires Anisotropic Gloss" );
	FeatureRule( Allow1( F_IRIDESCENCE, F_ANISOTROPIC_HAIR ), "Iridescence and Anisotropic Hair are incompatible" );
	FeatureRule( ChildOf( F_DECAL_BLEND_MODE, F_DECAL_TEXTURE ), "Decal Blend Mode requires Decal Texture" );
	FeatureRule( Allow1( F_DECAL_TEXTURE, F_SUPPORTS_DECALS ), "Decal Texture and Blood Decals are incompatible" );
	FeatureRule( Allow1( F_EYEBALLS, F_ADDITIVE_BLEND ), "Eyeballs and Additive Blend are incompatible" );
	FeatureRule( Allow1( F_EYEBALLS, F_TRANSLUCENT ), "Eyeballs and Translucent are incompatible" );
	FeatureRule( Allow1( F_EYEBALLS, F_ALPHA_TEST ), "Eyeballs and Alpha Test are incompatible" );
	FeatureRule( Allow1( F_EYEBALLS, F_PATCHES ), "Eyeballs and Patches are incompatible" );
	FeatureRule( Requires( F_DETAIL_TEXTURE, F_ENABLE_ADJUSTMENTS ), "Detail texture requires Enable Adjustments" );
	FeatureRule( Allow1( F_ENABLE_ADJUSTMENTS, F_SUPPORTS_DECALS ), "Enable Adjustments and Blood Decals are incompatible" );
	FeatureRule( Allow1( F_ENABLE_ADJUSTMENTS, F_ADDITIVE_BLEND ), "Enable Adjustments and Additive Blend are incompatible" );
	FeatureRule( Allow1( F_ENABLE_ADJUSTMENTS, F_PATCHES ), "Enable Adjustments and Patches are incompatible" );
	FeatureRule( Allow1( F_ENABLE_ADJUSTMENTS, F_SUBSURFACE_SCATTERING ), "Enable Adjustments and Subsurface Scattering are incompatible" );
	FeatureRule( Allow1( F_ENABLE_ADJUSTMENTS, F_ANISOTROPIC_HAIR ), "Enable Adjustments and Anisotropic Hair are incompatible" );
	FeatureRule( Allow1( F_ENABLE_ADJUSTMENTS, F_RETRO_REFLECTIVE ), "Enable Adjustments and Retro Reflective are incompatible" );
	FeatureRule( Allow1( F_ENABLE_ADJUSTMENTS, F_DECAL_TEXTURE ), "Enable Adjustments and Decal Texture are incompatible" );
}

COMMON
{
	#include "system.fxc"
}

struct VS_INPUT
{
	float4 vBlendIndices              : BLENDINDICES0  < Semantic( BlendIndices ); >;              // D_CS_VERTEX_ANIMATION=0, S_SPHERICAL_PROJECTED_ANISOTROPIC_TANGENTS=1, S_MODE_TOOLS_VIS=1
	float4 vBlendWeight               : BLENDWEIGHT0   < Semantic( BlendWeight ); >;              
	float4 vBlendColorTint            : COLOR0         < Semantic( VertexPaintTintColor ); >;     
	float4 vPerVertexLighting         : COLOR1         < Semantic( PerVertexLighting ); >;         // D_BAKED_LIGHTING_FROM_VERTEX_STREAM=1
	uint4  nPackedFrame               : NORMAL0        < Semantic( CompressedTangentFrame ); >;   
	float4 vNormalOs                  : NORMAL0        < Semantic( Normal ); >;                   
	float2 vTexCoord2                 : TEXCOORD1      < Semantic( LowPrecisionUv1 ); >;           // S_SUPPORTS_DECALS=1
	float4 flSSSCurvature             : TEXCOORD2      < Semantic( Curvature ); >;                 // S_USE_PER_VERTEX_CURVATURE=1
	float3 vPositionOs                : POSITION0      < Semantic( PosXyz ); >;                   
	float2 vLightmapUV                : TEXCOORD3      < Semantic( LightmapUV ); >;                // D_BAKED_LIGHTING_FROM_LIGHTMAP=1
	float4 vTangentUOs_flTangentVSign : TANGENT0       < Semantic( TangentU_SignV ); >;           
	float2 vTexCoord                  : TEXCOORD0      < Semantic( LowPrecisionUv ); >;           
	float2 nInstanceIdx               : TEXCOORD13     < Semantic( InstanceTransformUv ); >;      
};

VS
{
	StaticCombo( S_ANISOTROPIC_GLOSS, F_ANISOTROPIC_GLOSS );
	StaticCombo( S_SPHERICAL_PROJECTED_ANISOTROPIC_TANGENTS, F_SPHERICAL_PROJECTED_ANISOTROPIC_TANGENTS );
	StaticCombo( S_SUBSURFACE_SCATTERING, F_SUBSURFACE_SCATTERING );
	StaticCombo( S_USE_PER_VERTEX_CURVATURE, F_SUBSURFACE_SCATTERING );
	StaticCombo( S_ENABLE_ADJUSTMENTS, F_ENABLE_ADJUSTMENTS );
	StaticCombo( S_EYEBALLS, F_EYEBALLS );
	StaticCombo( S_MODE_TOOLS_VIS, 0..1 );
	StaticCombo( S_SUPPORTS_DECALS, F_SUPPORTS_DECALS );
	StaticCombo( S_MODE_DEPTH, 0..1 );
	StaticComboRule( Allow1( S_MODE_DEPTH, S_SUPPORTS_DECALS ) );
	StaticComboRule( ChildOf( S_SPHERICAL_PROJECTED_ANISOTROPIC_TANGENTS, S_ANISOTROPIC_GLOSS ) );
	StaticComboRule( Allow1( S_ENABLE_ADJUSTMENTS, S_SUPPORTS_DECALS ) );
	StaticComboRule( Allow1( S_ENABLE_ADJUSTMENTS, S_SUBSURFACE_SCATTERING ) );
	DynamicCombo( D_COMPRESSED_NORMALS_AND_TANGENTS, 0..1 );
	DynamicCombo( D_CS_VERTEX_ANIMATION, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_VERTEX_STREAM, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_LIGHTMAP, 0..1 );
	DynamicComboRule( Allow1( D_BAKED_LIGHTING_FROM_VERTEX_STREAM, D_BAKED_LIGHTING_FROM_LIGHTMAP ) );
	DynamicComboRule( Requires( D_BAKED_LIGHTING_FROM_VERTEX_STREAM, S_MODE_DEPTH=0 ) );
	DynamicComboRule( Requires( D_BAKED_LIGHTING_FROM_LIGHTMAP, S_MODE_DEPTH=0 ) );
	
	cbuffer PerViewConstantBufferCsgo_t < Attribute("PerViewConstantBufferCsgo_t"); >;
	cbuffer PerViewConstantBuffer_t < Attribute("PerViewConstantBuffer_t"); >;
	ByteAddressBuffer g_animatedVertexCache < Attribute("AnimatedVertexCache"); SrgbRead(false); >;
	int g_bDisableFirstpersonLegsDistortion < Attribute("FirstPersonLegsDisableDistortion"); UiType(Slider); >;
	bool g_bTexCoordScaleByModel < UiType(CheckBox); Expression((g_nScaleTexCoordUByModelScaleAxis!=0) || (g_nScaleTexCoordVByModelScaleAxis!=0)); >;
	bool g_bTranslucentDistanceContrastAdjustment < UiType(CheckBox); Expression(F_DISTANCE_CONTRAST_ADJUSTMENT && F_TRANSLUCENT); >;
	float g_flFirstpersonLegsFade < Attribute("FirstpersonLegsFade"); UiType(Slider); >;
	float g_flPlayerOcclusionAmount < Attribute("PlayerOcclusionAmount"); UiType(Slider); >;
	ExternalDescriptorSet g_globalLateBoundBindlessSet < Source(ExternalDescSet); Attribute("g_globalLateBoundBindlessSet"); >;
	StructuredBuffer g_instanceBuffer < Attribute("InstanceBuffer"); SrgbRead(false); >;
	ExternalDescriptorSet g_lightBinnerGpuSet < Source(ExternalDescSet); Attribute("g_lightBinnerGpuSet"); >;
	int g_nEyeLBindIdx < Attribute("eyeball_bone_l_index"); UiType(Slider); >;
	int g_nEyeRBindIdx < Attribute("eyeball_bone_r_index"); UiType(Slider); >;
	int g_nEyeTargetBindIdx < Attribute("eye_target_bone_index"); UiType(Slider); >;
	StructuredBuffer g_transformBuffer < Attribute("TransformBuffer"); SrgbRead(false); >;
	float4 g_vDetailTexCoordXform < UiType(VectorText); Expression(v0 = (g_flDetailTexCoordRotation*3.1415927)/180;
		v1 = cos(v0);
		v2 = sin(v0);
		v3 = g_vDetailTexCoordScale;
		v3.xxy*float4(v1,-v2,v2,v1)); >;
	float3 g_vEyeLBindFwd < Attribute("eyeball_bind_l_forward"); UiType(VectorText); >;
	float3 g_vEyeLBindPos < Attribute("eyeball_bind_l_pos"); UiType(VectorText); >;
	float3 g_vEyeLBindUp < Attribute("eyeball_bind_l_up"); UiType(VectorText); >;
	float3 g_vEyeRBindFwd < Attribute("eyeball_bind_r_forward"); UiType(VectorText); >;
	float3 g_vEyeRBindPos < Attribute("eyeball_bind_r_pos"); UiType(VectorText); >;
	float3 g_vEyeRBindUp < Attribute("eyeball_bind_r_up"); UiType(VectorText); >;
	float3 g_vEyeTargetBindPos < Attribute("eye_target_pos"); UiType(VectorText); >;
	float3 g_vPlayerOrigin < Attribute("PlayerOcclusionOrigin"); UiType(VectorText); >;
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
	
	// Material1
	float g_flEyeBallWalleyeL1 < Range(0, 25); UiType(Slider); UiGroup("Material1/Eyes/95"); >;
	float g_flEyeBallWalleyeR1 < Range(0, 25); UiType(Slider); UiGroup("Material1/Eyes/95"); >;
	bool g_bPointAtEyeTarget1 < Default(1); UiType(CheckBox); UiGroup("Material1/Eyes/96"); >;
	
	// Visibility
	float g_fDistanceContrastExposure < Default(0.6); UiType(Slider); UiGroup("Visibility"); Expression(F_TRANSLUCENT ? this : (1-this)); UiVisibility(F_DISTANCE_CONTRAST_ADJUSTMENT); >;
	
	// Detail Texture
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
	
	// Lighting
	float3 g_vSphericalAnisotropyPole < Default(0); Range3(-1, -1, -1, 1, 1, 1); UiType(VectorText); UiGroup("Lighting,30/Roughness,20/30"); >;
	float g_vSphericalAnisotropyAngle < Range(0, 180); UiType(Slider); UiGroup("Lighting,30/Roughness,20/40"); Expression((this/90)-1); >;
	
	// SPIR-V reflection failed for backend HLSL:
	// cbuffer ID 5618 (name: _Globals_), member index 4 (name: g_vTexCoordXform0) cannot be expressed with either HLSL packing layout or packoffset.
	// 
	// Re-attempting reflection with the GLSL backend.
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (10728 bytes), GLSL reflection with SPIRV-Cross by KhronosGroup
	
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
	
	struct _2914
	{
	    vec4 _m0[3];
	};
	
	struct _765
	{
	    _2914 _m0;
	};
	
	struct _1415
	{
	    vec4 _m0[4];
	};
	
	layout(set = 4, binding = 32, std430) readonly buffer g_instanceBuffer
	{
	    _1125 _m0[];
	} g_instanceBuffer_1;
	
	layout(set = 4, binding = 30, std430) readonly buffer g_transformBuffer
	{
	    _765 _m0[];
	} g_transformBuffer_1;
	
	struct _1745
	{
	    int g_bTranslucentDistanceContrastAdjustment;
	    float g_fDistanceContrastExposure;
	    vec3 g_vPlayerOrigin;
	    float g_flPlayerOcclusionAmount;
	    vec4 g_vTexCoordXform0;
	    vec4 g_vTexCoordXform1;
	    vec2 g_vTexCoordScrollSpeed;
	    vec3 g_vColorTint;
	    float g_flModelTintAmount;
	    float g_flFirstpersonLegsFade;
	    int g_bDisableFirstpersonLegsDistortion;
	};
	
	layout(set = 0) uniform _1745 _Globals_;
	
	struct _1053
	{
	    _1415 _m0;
	    float _m1;
	    vec4 _m2;
	    vec3 _m3;
	    vec3 _m4;
	};
	
	layout(set = 0) uniform _1053 PerViewConstantBuffer_t;
	
	struct _1032
	{
	    vec4 _m0;
	    float _m1;
	};
	
	layout(set = 0) uniform _1032 PerViewConstantBufferCsgo_t;
	
	layout(location = 0) in vec3 vPositionOs;
	layout(location = 1) in vec2 vTexCoord;
	layout(location = 2) in vec3 vNormalOs;
	layout(location = 3) in vec4 vTangentUOs_flTangentVSign;
	layout(location = 4) in uvec4 vBlendIndices;
	layout(location = 5) in uint nInstanceIdx;
	layout(location = 6) in vec4 vBlendColorTint;
	layout(location = 0) out vec3 output_0;
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
	    vec4 _10296 = vec4(_21354, _21355, _14124, _23812.w);
	    vec3 _11179 = normalize(vec4(vNormalOs.xyz, 0.0) * _17839);
	    vec3 _12151 = vec4(vPositionOs.xyz * _21709.xyz, 1.0) * _17839;
	    vec3 _19648;
	    if (_Globals_.g_flPlayerOcclusionAmount >= 1.0)
	    {
	        vec3 _23555 = _12151.xyz - _Globals_.g_vPlayerOrigin;
	        _19648 = vec3(clamp(_23555.x, -16.0, 16.0), clamp(_23555.y, -16.0, 16.0), clamp(_23555.z, 0.0, 72.0)) + _Globals_.g_vPlayerOrigin;
	    }
	    else
	    {
	        _19648 = _12151;
	    }
	    vec4 _23875 = (vec4(_19648.xyz, 1.0) + (PerViewConstantBuffer_t._m2 * 1.0)).xyzw * mat4(vec4(PerViewConstantBuffer_t._m0._m0[0].x, PerViewConstantBuffer_t._m0._m0[1].x, PerViewConstantBuffer_t._m0._m0[2].x, PerViewConstantBuffer_t._m0._m0[3].x), vec4(PerViewConstantBuffer_t._m0._m0[0].y, PerViewConstantBuffer_t._m0._m0[1].y, PerViewConstantBuffer_t._m0._m0[2].y, PerViewConstantBuffer_t._m0._m0[3].y), vec4(PerViewConstantBuffer_t._m0._m0[0].z, PerViewConstantBuffer_t._m0._m0[1].z, PerViewConstantBuffer_t._m0._m0[2].z, PerViewConstantBuffer_t._m0._m0[3].z), vec4(PerViewConstantBuffer_t._m0._m0[0].w, PerViewConstantBuffer_t._m0._m0[1].w, PerViewConstantBuffer_t._m0._m0[2].w, PerViewConstantBuffer_t._m0._m0[3].w));
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
	    bool _12885;
	    if (vBlendColorTint.x == 0.0)
	    {
	        _12885 = vBlendColorTint.y == 0.0;
	    }
	    else
	    {
	        _12885 = false;
	    }
	    bool _12886;
	    if (_12885)
	    {
	        _12886 = vBlendColorTint.z == 0.0;
	    }
	    else
	    {
	        _12886 = false;
	    }
	    bool _7424;
	    if (_12886)
	    {
	        _7424 = vBlendColorTint.w == 0.0;
	    }
	    else
	    {
	        _7424 = false;
	    }
	    vec4 _19363;
	    if (!_7424)
	    {
	        _19363 = _23714.xyzw * vBlendColorTint.xyzw;
	    }
	    else
	    {
	        _19363 = _23714;
	    }
	    bool _12887;
	    if (_Globals_.g_flFirstpersonLegsFade > 0.0)
	    {
	        _12887 = _Globals_.g_bDisableFirstpersonLegsDistortion == 0;
	    }
	    else
	    {
	        _12887 = false;
	    }
	    vec3 _10020;
	    vec3 _22509;
	    if (_12887)
	    {
	        float _24164 = pow((clamp((vPositionOs.z + 1.0) * 0.012500000186264514923095703125, 0.0, 1.0) * 0.5) * pow(saturate(-PerViewConstantBuffer_t._m4.z), 2.0), 1.5);
	        vec2 _21266 = _23875.xy * (1.0 + (5.0 * _24164));
	        _10020 = vec3(_21266.x, _21266.y - (200.0 * _24164), _23875.z - (40.0 * _24164));
	        _22509 = normalize(_11179 + (vec3(0.0, 0.0, 0.5) * float(int(sign(_24164)))));
	    }
	    else
	    {
	        _10020 = _23875.xyz;
	        _22509 = _11179;
	    }
	    _23875.x = _10020.x;
	    _23875.z = _10020.z;
	    vec4 _19364;
	    if (_Globals_.g_bTranslucentDistanceContrastAdjustment != 0)
	    {
	        vec3 _11028 = _19363.xyz * mix(1.0, _Globals_.g_fDistanceContrastExposure, smoothstep(400.0, 1400.0, length(PerViewConstantBuffer_t._m3.xyz - _19648.xyz) / PerViewConstantBufferCsgo_t._m1));
	        vec4 _8673 = _19363;
	        _8673.x = _11028.x;
	        _8673.y = _11028.y;
	        _8673.z = _11028.z;
	        _19364 = _8673;
	    }
	    else
	    {
	        _19364 = _19363;
	    }
	    output_0 = vPositionOs;
	    output_1 = _19648.xyz - PerViewConstantBufferCsgo_t._m0.xyz;
	    output_2 = _22509;
	    output_3 = _20488;
	    output_4 = _19364;
	    output_5 = _11179;
	    output_6 = vec4(normalize(vec4(vTangentUOs_flTangentVSign.xyz, 0.0) * _17839), vTangentUOs_flTangentVSign.w);
	    output_7 = (g_instanceBuffer_1._m0[nInstanceIdx]._m5) & 65535u;
	    _23875.y = -_10020.y;
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
	BoolAttribute(VertexPaintUIPickColor, true);
	
	#if (S_EYEBALLS == 1)
		IntAttribute(MaterialLayerCount, 1);
		StringAttribute(MaterialLayerRefType, csgo_eyeball);
	#endif
}

PS
{
	StaticCombo( S_ANISOTROPIC_GLOSS, F_ANISOTROPIC_GLOSS );
	StaticCombo( S_SPHERICAL_PROJECTED_ANISOTROPIC_TANGENTS, F_SPHERICAL_PROJECTED_ANISOTROPIC_TANGENTS );
	StaticCombo( S_SUBSURFACE_SCATTERING, F_SUBSURFACE_SCATTERING );
	StaticCombo( S_USE_PER_VERTEX_CURVATURE, F_SUBSURFACE_SCATTERING );
	StaticCombo( S_ENABLE_ADJUSTMENTS, F_ENABLE_ADJUSTMENTS );
	StaticCombo( S_EYEBALLS, F_EYEBALLS );
	StaticCombo( S_MODE_TOOLS_VIS, 0..1 );
	StaticCombo( S_DECAL_TEXTURE, F_DECAL_TEXTURE );
	StaticCombo( S_ALPHA_TEST, F_ALPHA_TEST );
	StaticCombo( S_TRANSLUCENT, F_TRANSLUCENT );
	StaticCombo( S_ADDITIVE_BLEND, F_ADDITIVE_BLEND );
	StaticCombo( S_TINT_MASK, F_TINT_MASK );
	StaticCombo( S_RETRO_REFLECTIVE, F_RETRO_REFLECTIVE );
	StaticCombo( S_ANISOTROPIC_HAIR, F_ANISOTROPIC_HAIR );
	StaticCombo( S_IRIDESCENCE, F_IRIDESCENCE );
	StaticCombo( S_MODE_DEPTH, 0..1 );
	StaticCombo( S_PATCHES, F_PATCHES );
	StaticCombo( S_SUPPORTS_DECALS, F_SUPPORTS_DECALS );
	StaticComboRule( Allow1( S_MODE_DEPTH, S_DECAL_TEXTURE ) );
	StaticComboRule( Allow1( S_MODE_DEPTH, S_ADDITIVE_BLEND ) );
	StaticComboRule( Allow1( S_MODE_DEPTH, S_TINT_MASK ) );
	StaticComboRule( Allow1( S_MODE_DEPTH, S_RETRO_REFLECTIVE ) );
	StaticComboRule( Allow1( S_MODE_DEPTH, S_ANISOTROPIC_HAIR ) );
	StaticComboRule( Allow1( S_MODE_DEPTH, S_IRIDESCENCE ) );
	StaticComboRule( Allow1( S_PATCHES, S_MODE_DEPTH ) );
	StaticComboRule( Allow1( S_SUPPORTS_DECALS, S_MODE_DEPTH ) );
	StaticComboRule( Allow1( S_ALPHA_TEST, S_TRANSLUCENT ) );
	StaticComboRule( Requires( S_ADDITIVE_BLEND, S_TRANSLUCENT ) );
	StaticComboRule( Allow1( S_ANISOTROPIC_GLOSS, S_ADDITIVE_BLEND ) );
	StaticComboRule( Allow1( S_RETRO_REFLECTIVE, S_ADDITIVE_BLEND ) );
	StaticComboRule( ChildOf( S_SPHERICAL_PROJECTED_ANISOTROPIC_TANGENTS, S_ANISOTROPIC_GLOSS ) );
	StaticComboRule( ChildOf( S_ANISOTROPIC_HAIR, S_ANISOTROPIC_GLOSS ) );
	StaticComboRule( Allow1( S_IRIDESCENCE, S_ANISOTROPIC_HAIR ) );
	StaticComboRule( Allow1( S_DECAL_TEXTURE, S_SUPPORTS_DECALS ) );
	StaticComboRule( Allow1( S_EYEBALLS, S_ADDITIVE_BLEND ) );
	StaticComboRule( Allow1( S_EYEBALLS, S_TRANSLUCENT ) );
	StaticComboRule( Allow1( S_EYEBALLS, S_ALPHA_TEST ) );
	StaticComboRule( Allow1( S_EYEBALLS, S_PATCHES ) );
	StaticComboRule( Allow1( S_ENABLE_ADJUSTMENTS, S_SUPPORTS_DECALS ) );
	StaticComboRule( Allow1( S_ENABLE_ADJUSTMENTS, S_ADDITIVE_BLEND ) );
	StaticComboRule( Allow1( S_ENABLE_ADJUSTMENTS, S_PATCHES ) );
	StaticComboRule( Allow1( S_ENABLE_ADJUSTMENTS, S_SUBSURFACE_SCATTERING ) );
	StaticComboRule( Allow1( S_ENABLE_ADJUSTMENTS, S_ANISOTROPIC_HAIR ) );
	StaticComboRule( Allow1( S_ENABLE_ADJUSTMENTS, S_RETRO_REFLECTIVE ) );
	StaticComboRule( Allow1( S_ENABLE_ADJUSTMENTS, S_DECAL_TEXTURE ) );
	DynamicCombo( D_BAKED_LIGHTING_FROM_VERTEX_STREAM, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_PROBE, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_LIGHTMAP, 0..1 );
	DynamicCombo( D_MBOIT_PASS1, 0..1 );
	DynamicCombo( D_MBOIT_PASS2, 0..1 );
	DynamicCombo( D_MBOIT_4_MOMENTS, 0..1 );
	DynamicCombo( D_DECALS_ENABLED, 0..1 );
	DynamicComboRule( Allow1( D_BAKED_LIGHTING_FROM_PROBE, D_BAKED_LIGHTING_FROM_VERTEX_STREAM, D_BAKED_LIGHTING_FROM_LIGHTMAP ) );
	DynamicComboRule( Allow1( D_MBOIT_PASS1, D_MBOIT_PASS2 ) );
	DynamicComboRule( Requires( D_MBOIT_PASS1, S_TRANSLUCENT ) );
	DynamicComboRule( Requires( D_MBOIT_PASS2, S_TRANSLUCENT ) );
	DynamicComboRule( Requires( D_MBOIT_4_MOMENTS, D_MBOIT_PASS1, D_MBOIT_PASS2 ) );
	DynamicComboRule( Requires( D_MBOIT_PASS1, S_MODE_DEPTH=0 ) );
	DynamicComboRule( Requires( D_MBOIT_PASS2, S_MODE_DEPTH=0 ) );
	DynamicComboRule( Requires( D_DECALS_ENABLED, S_SUPPORTS_DECALS ) );
	DynamicComboRule( Requires( D_DECALS_ENABLED, S_MODE_DEPTH=0 ) );
	DynamicComboRule( Requires( D_BAKED_LIGHTING_FROM_VERTEX_STREAM, S_MODE_DEPTH=0 ) );
	DynamicComboRule( Requires( D_BAKED_LIGHTING_FROM_PROBE, S_MODE_DEPTH=0 ) );
	DynamicComboRule( Requires( D_BAKED_LIGHTING_FROM_LIGHTMAP, S_MODE_DEPTH=0 ) );
	
	cbuffer BakedLightingConstantBuffer_t < Attribute("BakedLightingConstantBuffer_t"); >;
	cbuffer PerViewConstantBufferCsgo_t < Attribute("PerViewConstantBufferCsgo_t"); >;
	cbuffer PerViewConstantBuffer_t < Attribute("PerViewConstantBuffer_t"); >;
	cbuffer PerViewLightProbeVolumeConstantBuffer_t < Attribute("PerViewLightProbeVolumeConstantBuffer_t"); >;
	cbuffer PerViewLightingConstantBufferGpu_t < Attribute("PerViewLightingConstantBufferGpu_t"); >;
	StructuredBuffer g_BarnLights < Attribute("BarnLights"); SrgbRead(false); >;
	StructuredBuffer g_CullBits < Attribute("CullBits"); SrgbRead(false); >;
	bool g_bClothShading < UiType(CheckBox); Expression(F_CLOTH_SHADING || 0); >;
	bool g_bCubemapNormalization < Attribute("g_bCubemapNormalization"); UiType(CheckBox); >;
	bool g_bDisableNormalMapping < Attribute("g_bDisableNormalMapping"); UiType(CheckBox); >;
	bool g_bDistanceContrastAdjustment < UiType(CheckBox); Expression(F_DISTANCE_CONTRAST_ADJUSTMENT && !F_TRANSLUCENT); >;
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
	TextureCube g_bindless_TextureCube_float4 < Source(ExternalDescSet); SrgbRead(false); >;
	float3 g_cInvulnerabilityColor < Attribute("InvulnerabilityColor"); UiType(VectorText); >;
	float g_fToolsVisHeightTint < Default(0.9); Attribute("g_fToolsVisHeightTint"); UiType(Slider); >;
	float g_fToolsVisMaxHeightRange < Default(1); Attribute("g_fToolsVisMaxHeightRange"); UiType(Slider); >;
	float g_fToolsVisMaxLightingComplexity < Default(8); Attribute("g_fToolsVisMaxLightingComplexity"); UiType(Slider); >;
	float g_flFogModificationAmount < Attribute("FogModificationAmount"); UiType(Slider); >;
	float g_flPatch0HighlightTime < Attribute("HighlightTimePatch0"); UiType(Slider); >;
	float g_flPatch1HighlightTime < Attribute("HighlightTimePatch1"); UiType(Slider); >;
	float g_flPatch2HighlightTime < Attribute("HighlightTimePatch2"); UiType(Slider); >;
	float g_flRainExposureLocalTimer < Attribute("RainExposureLocalTimer"); UiType(Slider); >;
	float g_flRainExposureToSkyWetness < Attribute("RainExposureToSkyWetness"); UiType(Slider); >;
	float g_flReflectance < UiType(Slider); Expression(pow((1.5-1)/(1.5+1),2)); >;
	float g_flSpawnInvulnerability < Attribute("SpawnInvulnerability"); UiType(Slider); >;
	float g_flWaterHeightMaxOs < Attribute("water_height_max"); UiType(Slider); >;
	float g_flWaterHeightMinOs < Attribute("water_height_min"); UiType(Slider); >;
	ExternalDescriptorSet g_globalLateBoundBindlessSet < Source(ExternalDescSet); Attribute("g_globalLateBoundBindlessSet"); >;
	ExternalDescriptorSet g_lightBinnerGpuSet < Source(ExternalDescSet); Attribute("g_lightBinnerGpuSet"); >;
	int g_nDecalBlendMode < UiType(Slider); Expression(F_DECAL_BLEND_MODE || 0); >;
	int g_nDetailBlendMode < UiType(Slider); Expression(F_DETAIL_TEXTURE); >;
	int g_nToolsVisMode < Attribute("g_nToolsVisMode"); UiType(Slider); >;
	float3 g_vAvgAlbedo < UiType(VectorText); Expression(TextureAverageColor(g_tColor).xyz); >;
	float3 g_vFlatOverlayColor < Default2(1, 0); Attribute("FlatOverlayColor"); UiType(VectorText); >;
	float4 g_vShaderIDColor < Source(ShaderIDColor); UiType(VectorText); >;
	
	// Ambient Occlusion
	CreateInputTexture2D(TextureAmbientOcclusion, Linear, 8, "", "_ao", "Ambient Occlusion/10", Default4(1, 1, 1, 0));
	
	// Blood Mask
	CreateInputTexture2D(TextureBloodMask, Linear, 8, "", "_mask", "Blood Mask", Default4(1, 1, 1, 0));
	
	// Lighting
	CreateInputTexture2D(TextureIridescentMask, Linear, 8, "", "", "Lighting/Iridescence", Default4(1, 1, 1, 0));
	CreateInputTexture2D(TextureRimMask, Linear, 8, "", "_rimmask", "Lighting,30/Rimlight,50/0", Default4(1, 1, 1, 0));
	float g_flIridescentFresnelStrength < Default(2); Range(0, 20); UiType(Slider); UiGroup("Lighting/Iridescence"); >;
	float g_flIridescentHueShift < Default(0.5); UiType(Slider); UiGroup("Lighting/Iridescence"); >;
	float g_flIridescentStrength < Default(0.75); Range(0, 2); UiType(Slider); UiGroup("Lighting/Iridescence"); >;
	CreateInputTexture2D(TextureMetalness, Linear, 8, "", "_metal", "Lighting,30/Metalness,30/10", Default4(0, 0, 0, 0));
	CreateInputTexture2D(TextureRoughness, Linear, 8, "Inverse", "_rough", "Lighting,30/Roughness,20/10", Default4(0.5, 0.5, 0.5, 0));
	float g_flAmbientOcclusionMasking < Default(0.4); Range(0, 0.99); UiType(Slider); UiGroup("Lighting,30/Rimlight,50/10"); >;
	float g_fTextureRoughnessContrast < Default(1); Range(0, 4); UiType(Slider); UiGroup("Lighting/Roughness/11"); >;
	float g_fTextureRoughnessBrightness < Default(1); Range(0, 4); UiType(Slider); UiGroup("Lighting/Roughness/12"); >;
	bool g_bMaskRoughnessAdjustmentsByTintMask < UiType(CheckBox); UiGroup("Lighting/Roughness/13"); UiVisibility(F_TINT_MASK==1); >;
	CreateInputTexture2D(TextureRetroReflectiveMask, Linear, 8, "", "_mask", "Lighting,30/RetroReflectivity,30/20", Default4(1, 1, 1, 0));
	CreateInputTexture2D(TextureCloth, Linear, 8, "", "_cloth", "Lighting,30/Cloth,40", "materials/default/default_black_mask.tga");
	float g_flSheenScale < Default(0.667); Range(0, 10); UiType(Slider); UiGroup("Lighting,30/Cloth,40"); UiVisibility(F_CLOTH_SHADING); >;
	float3 g_flSheenTintColor < Default3(1, 1, 1); UiType(Color); UiGroup("Lighting,30/Cloth,40"); Expression(SrgbGammaToLinear(this)); UiVisibility(F_CLOTH_SHADING); >;
	CreateInputTexture2D(TextureHairMask, Linear, 8, "", "_hair", "Lighting,30/Hair/45,20", "materials/default/default_mask.tga");
	CreateInputTexture2D(TextureIridescentThickness, Linear, 8, "", "", "Lighting/Iridescence,45", Default4(1, 1, 1, 0));
	float g_flHairGlossRoughnessScale < Default(1.25); Range(1, 10); UiType(Slider); UiGroup("Lighting,30/Hair/45,5"); >;
	float g_flHairGlossShift < Default(0.3); Range(0, 0.5); UiType(Slider); UiGroup("Lighting,30/Hair/45,0"); >;
	float g_flHairTransmission < Default(0.3); UiType(Slider); UiGroup("Lighting,30/Hair/45,10"); >;
	
	// Color
	CreateInputTexture2D(TextureTintMask, Linear, 8, "", "_mask", "Color", Default4(1, 1, 1, 0));
	bool g_bUseSecondaryUvForTintMask < UiType(CheckBox); UiGroup("Color,101"); >;
	CreateInputTexture2D(TextureColor, Srgb, 8, "", "_color", "Color/10", Default4(1, 1, 1, 0));
	float g_fHueShift < Range(-180, 180); UiType(Slider); UiGroup("Color/Adjustments/10"); Expression(radians(this)); >;
	float g_fSaturation < Default(1); Range(0, 2); UiType(Slider); UiGroup("Color/Adjustments/11"); >;
	float g_fContrast < Default(1); Range(0, 4); UiType(Slider); UiGroup("Color/Adjustments/15"); >;
	float g_fBrightness < Default(1); Range(0, 4); UiType(Slider); UiGroup("Color/Adjustments/16"); >;
	
	// Patch0
	CreateInputTexture2D(TextureColorPatch0, Srgb, 8, "", "", "Patch0", "materials/default/patches/patch_default.psd");
	CreateInputTexture2D(TexturePatch0Backing, Srgb, 8, "", "", "Patch0", "materials/default/patches/patch_backing_default.psd");
	bool g_bEnablePatch0 < UiType(CheckBox); UiGroup("Patch0"); >;
	float g_flPatch0BackingScale < Range(0, 4); UiType(Slider); UiGroup("Patch0"); >;
	float g_flPatch0Rotation < Range(-3.15, 3.5); UiType(Slider); UiGroup("Patch0"); >;
	float g_flPatch0Scale < Range(0, 16); UiType(Slider); UiGroup("Patch0"); >;
	float g_flPatch0Squash < Default(1); Range(-10, 10); UiType(Slider); UiGroup("Patch0"); >;
	float2 g_vPatch0Offset < Range2(-0.5, -0.5, 0.5, 0.5); UiType(VectorText); UiGroup("Patch0"); >;
	
	// Patch1
	CreateInputTexture2D(TextureColorPatch1, Srgb, 8, "", "", "Patch1", "materials/default/patches/patch_default.psd");
	CreateInputTexture2D(TexturePatch1Backing, Srgb, 8, "", "", "Patch1", "materials/default/patches/patch_backing_default.psd");
	bool g_bEnablePatch1 < UiType(CheckBox); UiGroup("Patch1"); >;
	float g_flPatch1BackingScale < Range(0, 4); UiType(Slider); UiGroup("Patch1"); >;
	float g_flPatch1Rotation < Range(-3.15, 3.5); UiType(Slider); UiGroup("Patch1"); >;
	float g_flPatch1Scale < Range(0, 16); UiType(Slider); UiGroup("Patch1"); >;
	float g_flPatch1Squash < Default(1); Range(-10, 10); UiType(Slider); UiGroup("Patch1"); >;
	float2 g_vPatch1Offset < Range2(-0.5, -0.5, 0.5, 0.5); UiType(VectorText); UiGroup("Patch1"); >;
	
	// Patch2
	CreateInputTexture2D(TextureColorPatch2, Srgb, 8, "", "", "Patch2", "materials/default/patches/patch_default.psd");
	CreateInputTexture2D(TexturePatch2Backing, Srgb, 8, "", "", "Patch2", "materials/default/patches/patch_backing_default.psd");
	bool g_bEnablePatch2 < UiType(CheckBox); UiGroup("Patch2"); >;
	float g_flPatch2BackingScale < Range(0, 4); UiType(Slider); UiGroup("Patch2"); >;
	float g_flPatch2Rotation < Range(-3.15, 3.5); UiType(Slider); UiGroup("Patch2"); >;
	float g_flPatch2Scale < Range(0, 16); UiType(Slider); UiGroup("Patch2"); >;
	float g_flPatch2Squash < Default(1); Range(-10, 10); UiType(Slider); UiGroup("Patch2"); >;
	float2 g_vPatch2Offset < Range2(-0.5, -0.5, 0.5, 0.5); UiType(VectorText); UiGroup("Patch2"); >;
	
	// Decal Texture
	bool g_bUseSecondaryUvForDecal < Default(1); UiType(CheckBox); UiGroup("Decal Texture, 180"); >;
	CreateInputTexture2D(TextureDecal, Srgb, 8, "", "_decal", "Decal Texture,70/10", Default4(1, 1, 1, 0));
	CreateInputTexture2D(TextureDecalTranslucency, Linear, 8, "", "_trans", "Decal Texture,70/10", Default4(1, 1, 1, 0));
	
	// Detail Texture
	CreateInputTexture2D(TextureDetail, Srgb, 8, "", "_detail", "Detail Texture/0", Default4(1, 1, 1, 1));
	float g_fDetailBlendFactor < Default(1); UiType(Slider); UiGroup("Detail Texture/1"); >;
	int g_nMaskDetailTextureByTintMask < Range4(0, 0, 0, 0, 2, 2, 2, 2); UiOptions("0=Unmasked,1=Masked,2=Inverted"); UiType(Enum); UiGroup("Detail Texture/2"); UiVisibility(F_TINT_MASK==1); >;
	float g_fDetailHueShift < Range(-180, 180); UiType(Slider); UiGroup("Detail Texture/Adjustments/10"); Expression(radians(this)); >;
	float g_fDetailSaturation < Default(1); Range(0, 2); UiType(Slider); UiGroup("Detail Texture/Adjustments/11"); >;
	float g_fDetailContrast < Default(1); Range(0, 4); UiType(Slider); UiGroup("Detail Texture/Adjustments/15"); >;
	float g_fDetailBrightness < Default(1); Range(0, 4); UiType(Slider); UiGroup("Detail Texture/Adjustments/16"); >;
	
	// Skin
	CreateInputTexture2D(TextureDiffuseFalloff, Srgb, 8, "", "_diffusewarp", "Skin", "materials/default/default_skin_diffusewarp.tga");
	CreateInputTexture2D(TextureSssMask, Linear, 8, "", "_mask", "Skin", Default4(1, 1, 1, 0));
	float g_flCurvatureScale < Default(1); Range(0, 3); UiType(Slider); UiGroup("Skin"); >;
	float3 g_vNormalSoftness < Default2(1, 0.3); UiType(Color); UiGroup("Skin"); >;
	
	// Material1
	CreateInputTexture2D(TextureEyeAlbedo1, Srgb, 8, "", "_color", "Material1/Eyes/10", Default4(1, 1, 1, 0));
	CreateInputTexture2D(TextureIrisMask1, Linear, 8, "", "_mask", "Material1/Eyes/11", Default4(1, 1, 1, 0));
	CreateInputTexture2D(TextureEyeMask1, Linear, 8, "", "_eyemask", "Material1/Eyes/20", Default4(0, 0, 0, 0));
	float g_flEyeBallRadius1 < Default(0.6); Range(0.2, 0.8); UiType(Slider); UiGroup("Material1/Eyes/25"); >;
	float g_flEyeIrisSize1 < Default(1); Range(0, 2); UiType(Slider); UiGroup("Material1/Eyes/30"); >;
	float g_flEyePupilSize1 < Default(0.15); Range(0.05, 0.25); UiType(Slider); UiGroup("Material1/Eyes/35"); Expression(this*g_flEyeIrisSize1); >;
	float g_flEyeHueShift1 < Range(-3.14159, 3.14159); UiType(Slider); UiGroup("Material1/Eyes/80"); >;
	float g_flEyeSaturation1 < Default(1); Range(0, 2); UiType(Slider); UiGroup("Material1/Eyes/91"); >;
	
	// Normal Map
	CreateInputTexture2D(TextureNormal, Linear, 8, "NormalizeNormals", "_normal", "Normal Map,20", Default4(0.5, 0.5, 1, 0));
	
	// Translucent
	CreateInputTexture2D(TextureTranslucency, Linear, 8, "", "_trans", "Translucent,15", Default4(1, 1, 1, 0));
	float g_flAlphaTestReference < Default(0.5); Range(0.01, 0.99); UiType(Slider); UiGroup("Translucent"); >;
	float g_flAntiAliasedEdgeStrength < Default(1); UiType(Slider); UiGroup("Translucent"); >;
	float g_flOpacityScale < Default(1); UiType(Slider); UiGroup("Translucent"); >;
	
	// Fog
	bool g_bFogEnabled < Default(1); UiType(CheckBox); UiGroup("Fog"); >;
	
	// Visibility
	float g_fDistanceContrastExposure < Default(0.6); UiType(Slider); UiGroup("Visibility"); Expression(F_TRANSLUCENT ? this : (1-this)); UiVisibility(F_DISTANCE_CONTRAST_ADJUSTMENT); >;
	
	// Texture Address Mode
	int g_nTextureAddressModeU < UiOption("RsTextureAddressMode_t"); UiType(Enum); UiGroup("Texture Address Mode"); >;
	int g_nTextureAddressModeV < UiOption("RsTextureAddressMode_t"); UiType(Enum); UiGroup("Texture Address Mode"); >;
	
	#if (S_PATCHES == 1)
	#endif
	#if (S_EYEBALLS == 1)
	#endif
	#if (S_ALPHA_TEST == 1)
	#endif
	#if (S_TRANSLUCENT == 1)
	#endif
	#if (S_ADDITIVE_BLEND == 1)
	#endif
	#if (S_RETRO_REFLECTIVE == 1)
	#endif
	#if (S_ANISOTROPIC_HAIR == 1)
	#endif
	
	// SPIR-V reflection failed for backend HLSL:
	// cbuffer ID 5618 (name: _Globals_), member index 21 (name: g_flSheenTintColor) cannot be expressed with either HLSL packing layout or packoffset.
	// 
	// Re-attempting reflection with the GLSL backend.
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (86012 bytes), GLSL reflection with SPIRV-Cross by KhronosGroup
	
	#version 460
	#extension GL_KHR_shader_subgroup_arithmetic : require
	#extension GL_EXT_samplerless_texture_functions : require
	
	struct _2213
	{
	    vec4 _m0[4];
	};
	
	struct _126
	{
	    vec4 _m0[3];
	};
	
	struct _2214
	{
	    vec4 _m0[4];
	};
	
	struct _127
	{
	    vec4 _m0[3];
	};
	
	struct _1833
	{
	    _127 _m0;
	    vec3 _m1;
	    uint _m2;
	    vec3 _m3;
	    uint _m4;
	    vec4 _m5;
	    vec3 _m6;
	    vec4 _m7;
	};
	
	struct _771
	{
	    _1833 _m0[128];
	};
	
	struct _1421
	{
	    _127 _m0;
	    vec3 _m1;
	    vec3 _m2;
	    vec3 _m3;
	    uint _m4;
	};
	
	struct _545
	{
	    _1421 _m0[128];
	};
	
	struct _2669
	{
	    _2213 _m0[4];
	};
	
	struct _1009
	{
	    _2213 _m0;
	    _2213 _m1;
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
	    _127 _m15;
	    vec4 _m16;
	    vec4 _m17;
	    vec4 _m18;
	    vec4 _m19;
	    vec4 _m20;
	    vec3 _m21;
	    float _m22;
	    _2213 _m23;
	};
	
	struct _1704
	{
	    _127 _m0;
	    vec3 _m1;
	    vec3 _m2;
	    uint _m3;
	    vec4 _m4;
	    vec3 _m5;
	    vec3 _m6;
	};
	
	struct _2905
	{
	    _1704 _m0[400];
	};
	
	vec4 _4;
	vec3 _5;
	
	struct _929
	{
	    int g_bClothShading;
	    int g_bDistanceContrastAdjustment;
	    float g_fDistanceContrastExposure;
	    float g_flFogModificationAmount;
	    uint g_sAniso;
	    uint g_sBilinearClamp;
	    uint g_sTrilinearWrap;
	    uint g_sTrilinearClamp;
	    uint g_sPointClamp;
	    uint g_sUserConfig;
	    uint g_sUserConfigAllowGlobalMipBias;
	    uint g_sCookieSampler;
	    uint g_tShadowDepthBufferCmpSampler;
	    int g_bFogEnabled;
	    int g_bDontFlipBackfaceNormals;
	    int g_bRenderBackfaceNormals;
	    float g_flReflectance;
	    uint g_tColor;
	    uint g_tNormal;
	    uint g_tAmbientOcclusion;
	    float g_flSheenScale;
	    vec3 g_flSheenTintColor;
	    uint g_tMetalness;
	    float g_flRainExposureToSkyWetness;
	    float g_flRainExposureLocalTimer;
	    vec3 g_vAvgAlbedo;
	    float g_flWaterHeightMinOs;
	    float g_flWaterHeightMaxOs;
	    float g_flSpawnInvulnerability;
	    vec3 g_cInvulnerabilityColor;
	};
	
	layout(set = 1) uniform _929 _Globals_;
	
	struct _251
	{
	    ivec4 _m0;
	    ivec4 _m1;
	    ivec4 _m2;
	    ivec4 _m3;
	    uint _m4;
	    uint _m5;
	    uint _m6;
	    uint _m7;
	    uint _m8;
	    uint _m9;
	    uint _m10;
	    uint _m11;
	    float _m12;
	    float _m13;
	    ivec2 _m14;
	    _2213 _m15;
	    vec2 _m16;
	    float _m17;
	    vec4 _m18;
	    vec4 _m19;
	    vec4 _m20;
	    vec4 _m21;
	    vec4 _m22;
	    vec4 _m23;
	    _2213 _m24;
	    vec4 _m25;
	    vec4 _m26;
	    vec4 _m27;
	    float _m28;
	    float _m29;
	    float _m30;
	    vec4 _m31;
	};
	
	layout(set = 1) uniform _251 PerViewConstantBufferCsgo_t;
	
	struct _1616
	{
	    float _m0;
	    vec2 _m1;
	    vec2 _m2;
	    vec4 _m3;
	    float _m4;
	    vec4 _m5;
	    vec3 _m6;
	    vec3 _m7;
	};
	
	layout(set = 1) uniform _1616 PerViewConstantBuffer_t;
	
	struct _223
	{
	    vec4 _m0;
	    vec4 _m1;
	    vec4 _m2;
	    vec4 _m3;
	    vec4 _m4;
	    _126 _m5;
	    _2214 _m6;
	    vec4 _m7;
	    vec4 _m8;
	    vec4 _m9;
	    uvec4 _m10;
	    uvec4 _m11;
	    uvec4 _m12;
	    uvec4 _m13;
	    vec4 _m14;
	    vec4 _m15;
	    _771 _m16;
	    _545 _m17;
	    vec4 _m18;
	    vec4 _m19;
	    int _m20;
	    float _m21;
	    vec4 _m22;
	    float _m23;
	    float _m24;
	    float _m25;
	    float _m26;
	    _2669 _m27;
	    _2214 _m28;
	    uint _m29;
	    uint _m30;
	};
	
	layout(set = 3) uniform _223 PerViewLightingConstantBufferGpu_t;
	
	layout(set = 3, binding = 30, std430) readonly buffer g_CullBits
	{
	    uint _m0[];
	} g_CullBits_1;
	
	layout(set = 3, binding = 31, std430) readonly buffer g_BarnLights
	{
	    _1009 _m0[];
	} g_BarnLights_1;
	
	struct _747
	{
	    _2905 _m0;
	};
	
	layout(set = 1) uniform _747 PerViewLightProbeVolumeConstantBuffer_t;
	
	layout(set = 4, binding = 46) uniform texture2D g_bindless_Texture2D_float4[65536];
	layout(set = 4, binding = 29) uniform sampler undetermined[2048];
	layout(set = 4, binding = 29) uniform samplerShadow undetermined_1[2048];
	layout(set = 4, binding = 46) uniform texture3D g_bindless_Texture3D_float4[65536];
	layout(set = 4, binding = 46) uniform textureCubeArray g_bindless_TextureCubeArray[65536];
	layout(set = 4, binding = 46) uniform texture2DArray undetermined_unexpectedTypeId470_1782[65536];
	layout(set = 4, binding = 46) uniform textureCube g_bindless_TextureCube_float4[65536];
	
	layout(location = 0) in vec3 input_0;
	layout(location = 1) in vec3 input_1;
	layout(location = 2) in vec3 input_2;
	layout(location = 3) in vec4 input_3;
	layout(location = 4) centroid in vec4 input_4;
	layout(location = 5) centroid in vec3 input_5;
	layout(location = 6) in vec4 input_6;
	layout(location = 0) out vec4 output_0;
	
	void main()
	{
	    vec4 _11408 = gl_FragCoord;
	    _11408.w = 1.0 / _11408.w;
	    float _21709;
	    if (_Globals_.g_flWaterHeightMinOs < _Globals_.g_flWaterHeightMaxOs)
	    {
	        _21709 = (1.0 - smoothstep(_Globals_.g_flWaterHeightMinOs, _Globals_.g_flWaterHeightMaxOs + 4.0, input_0.z)) + (_Globals_.g_flWaterHeightMaxOs * 0.0199999995529651641845703125);
	    }
	    else
	    {
	        _21709 = 0.0;
	    }
	    float _12497 = (saturate(_21709 + _Globals_.g_flRainExposureToSkyWetness) * 1.10000002384185791015625) * PerViewConstantBufferCsgo_t._m13;
	    bool _15436 = _12497 > 0.0;
	    float _13136;
	    vec2 _13998;
	    float _16305;
	    float _17114;
	    vec4 _23261;
	    if (_15436)
	    {
	        vec3 _10413 = input_1 + PerViewConstantBufferCsgo_t._m27.xyz;
	        vec2 _20603 = input_3.xy * 2.5;
	        vec2 _20826;
	        if (float((length(cross(vec3(dFdx(input_3.xy), 0.0), vec3(dFdy(input_3.xy), 0.0))) / max(9.9999997473787516355514526367188e-05, length(cross(dFdx(_10413), dFdy(_10413))))) < 0.00200000009499490261077880859375) != 0.0)
	        {
	            _20826 = _20603 * 3.0;
	        }
	        else
	        {
	            _20826 = _20603;
	        }
	        vec4 _20877 = texture(sampler2D(g_bindless_Texture2D_float4[PerViewConstantBufferCsgo_t._m11], undetermined[_Globals_.g_sAniso]), (_20826 + (_10413.xy * 9.9999997473787516355514526367188e-05)).xy);
	        vec2 _8562 = (_20877.xy * 2.0) - vec2(1.0);
	        _8562.y = -_8562.y;
	        float _7729 = _20877.w;
	        float _12471 = _20877.z + (input_0.x * 0.00999999977648258209228515625);
	        float _10538 = clamp((((_12497 * 0.25) - fract(_12471 + (((_Globals_.g_flRainExposureLocalTimer * 0.100000001490116119384765625) * PerViewConstantBufferCsgo_t._m12) * PerViewConstantBufferCsgo_t._m12))) * 5.0) / (PerViewConstantBufferCsgo_t._m13 + 0.001000000047497451305389404296875), 0.0, 1.0) * clamp((input_2.z + 0.75) * 4.0, 0.0, 1.0);
	        vec2 _13861 = input_3.xy + (((_8562.xy * (-0.0199999995529651641845703125)) * _10538) * _7729);
	        vec4 _20488;
	        _20488.x = _13861.x;
	        _20488.y = _13861.y;
	        _13136 = _10538;
	        _16305 = _7729;
	        _17114 = _12471;
	        _13998 = _8562;
	        _23261 = _20488;
	    }
	    else
	    {
	        _13136 = 0.0;
	        _16305 = 0.0;
	        _17114 = 0.0;
	        _13998 = vec2(0.0);
	        _23261 = input_3;
	    }
	    vec3 _21710;
	    if (dot(input_2.xyz, input_2.xyz) >= 1.0099999904632568359375)
	    {
	        _21710 = input_5.xyz;
	    }
	    else
	    {
	        _21710 = input_2.xyz;
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
	        _10251 = _21710 * (gl_FrontFacing ? 1.0 : (-1.0));
	    }
	    else
	    {
	        _10251 = _21710;
	    }
	    vec3 _24347 = normalize(_10251);
	    vec3 _10061 = input_1 + PerViewConstantBufferCsgo_t._m27.xyz;
	    vec4 _19680 = texture(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tColor], undetermined[_Globals_.g_sUserConfigAllowGlobalMipBias]), _23261.xy);
	    vec3 _21103 = _19680.xyz * input_4.xyz;
	    vec4 _19068 = texture(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tAmbientOcclusion], undetermined[_Globals_.g_sUserConfig]), vec2(_23261.xy).xy);
	    float _17476 = _19068.x;
	    vec4 _19069 = texture(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tMetalness], undetermined[_Globals_.g_sUserConfig]), _23261.xy);
	    float _17477 = _19069.y;
	    bool _14875 = _Globals_.g_bClothShading != 0;
	    float _21711;
	    if (_14875)
	    {
	        _21711 = _19069.z * (1.0 - _17477);
	    }
	    else
	    {
	        _21711 = 0.0;
	    }
	    vec4 _19372 = texture(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tNormal], undetermined[_Globals_.g_sUserConfig]), _23261.xy);
	    float _16000 = _19372.x;
	    float _19720 = _19372.y;
	    float _16783 = (_16000 + _19720) - 1.00392162799835205078125;
	    float _11176 = _16000 - _19720;
	    vec3 _18354 = normalize(vec3(vec2(_16783, _11176), (1.0 - abs(_16783)) - abs(_11176)));
	    bool _12886;
	    if (_14874)
	    {
	        _12886 = !(_Globals_.g_bDontFlipBackfaceNormals != 0);
	    }
	    else
	    {
	        _12886 = false;
	    }
	    bool _24327;
	    if (_12886)
	    {
	        _24327 = (gl_FrontFacing ? 1.0 : (-1.0)) < 0.0;
	    }
	    else
	    {
	        _24327 = false;
	    }
	    vec3 _12631 = input_2.xyz * (_24327 ? (-1.0) : 1.0);
	    vec3 _14435 = cross(_12631.xyz, input_6.xyz) * ((input_6.w > 0.0) ? 1.0 : (-1.0));
	    vec3 _7424;
	    if (notEqual(PerViewConstantBufferCsgo_t._m3, ivec4(0)).w)
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
	        vec3 _7482 = _18354;
	        _7482.y = -_18354.y;
	        _20480 = _7482;
	    }
	    else
	    {
	        _20480 = _18354;
	    }
	    vec3 _14786 = normalize((((input_6.xyz * _20480.x).xyz + (_7424.xyz * _20480.y)).xyz + (_12631.xyz * _20480.z)).xyz);
	    vec3 _14202 = _21103.xyz;
	    vec3 _12829 = _14202 * (1.0 - _17477);
	    vec3 _9186 = vec3(_Globals_.g_flReflectance);
	    vec3 _19648;
	    if (_14875)
	    {
	        _19648 = mix(_9186.xyz, clamp((_Globals_.g_flSheenTintColor.xyz * sqrt(_14202)) * _Globals_.g_flSheenScale, vec3(0.0), vec3(1.0)), vec3(_21711));
	    }
	    else
	    {
	        _19648 = _9186;
	    }
	    vec3 _18736 = mix(_19648.xyz, _14202, vec3(_17477));
	    float _6616;
	    vec3 _13137;
	    vec3 _13694;
	    vec3 _16306;
	    vec3 _17115;
	    vec2 _17116;
	    float _17117;
	    if (_15436)
	    {
	        float _14970 = mix(clamp((_19372.z - 0.75) * 4.0, 0.0, 1.0), 1.0, _21711);
	        float _20709 = saturate(_12497);
	        float _23650 = (clamp((_13136 * _16305) + (_20709 * 0.5), 0.0, 1.0) * ((_14970 * 0.75) + 0.25)) * _20709;
	        float _18407 = _13136 * saturate(1.0 - _14970);
	        float _22907 = _18407 * _16305;
	        vec3 _6961 = vec3(_23650);
	        _13137 = mix(_12829, pow(_12829, vec3(1.60000002384185791015625)) * 0.60000002384185791015625, _6961);
	        _16306 = _18736.xyz * mix(1.0, 0.1500000059604644775390625, _14970 * _12497);
	        _17115 = mix(_21103, pow(_21103, vec3(1.60000002384185791015625)) * 0.60000002384185791015625, _6961);
	        _17116 = mix(_19372.zz, vec2(mix(0.100000001490116119384765625, 0.5, _21711)), vec2(_17476 * clamp(((_22907 * 4.0) + ((((cos((_17114 + (_Globals_.g_flRainExposureLocalTimer * 0.20000000298023223876953125)) * 6.28318500518798828125) * 0.5) + 0.5) * _20709) * 0.20000000298023223876953125)) + (_12497 * 0.4000000059604644775390625), 0.0, 1.0)));
	        _17117 = _21711 * mix(1.0, 0.0, _23650);
	        _13694 = mix(normalize(mix(_24347, _14786, vec3(1.0 + (_23650 * 1.5)))), normalize((((input_6.xyz * _13998.x).xyz + (_7424.xyz * _13998.y)).xyz + (_24347.xyz * sqrt(1.0 - clamp(dot(_13998.xy, _13998.xy), 0.0, 1.0)))).xyz), vec3(_18407));
	        _6616 = saturate(_22907 * 2.0);
	    }
	    else
	    {
	        _13137 = _12829;
	        _16306 = _18736;
	        _17115 = _21103;
	        _17116 = _19372.zz;
	        _17117 = _21711;
	        _13694 = vec3(1.0);
	        _6616 = 0.0;
	    }
	    bool _10513 = PerViewConstantBufferCsgo_t._m31.x > 0.0;
	    float _22671;
	    if (_10513)
	    {
	        _22671 = length(PerViewConstantBuffer_t._m6.xyz - _10061.xyz) / PerViewConstantBufferCsgo_t._m30;
	    }
	    else
	    {
	        _22671 = 0.0;
	    }
	    vec3 _17892 = mix(_13694, _14786, bvec3(all(equal(_13694, vec3(1.0)))));
	    vec3 _10560 = _24347.xyz;
	    vec3 _11099 = dFdx(_10560);
	    vec3 _9175 = dFdy(_10560);
	    vec3 _10347 = _11099.xyz;
	    vec3 _12420 = _9175.xyz;
	    vec2 _11004 = max(_17116.xy, vec2(pow(clamp(max(dot(_10347, _10347), dot(_12420, _12420)), 0.0, 1.0), 0.333000004291534423828125)));
	    vec3 _10170 = -_24347;
	    vec3 _24735 = _14786.xyz;
	    vec4 _23876 = vec4(_24735, 1.0);
	    vec3 _18708 = vec3(dot(PerViewLightingConstantBufferGpu_t._m5._m0[0].xyzw, _23876), dot(PerViewLightingConstantBufferGpu_t._m5._m0[1].xyzw, _23876), dot(PerViewLightingConstantBufferGpu_t._m5._m0[2].xyzw, _23876));
	    bvec4 _24465 = notEqual(PerViewConstantBufferCsgo_t._m1, ivec4(0));
	    float _21712;
	    if (_24465.x)
	    {
	        vec3 _11394 = _24347.xyz;
	        vec2 _11087 = ((floor(_11408.xy * PerViewConstantBufferCsgo_t._m17) * PerViewConstantBufferCsgo_t._m16.xy) + (PerViewConstantBufferCsgo_t._m16.xy * 0.5)).xy;
	        vec4 _18418 = textureGather(sampler2D(g_bindless_Texture2D_float4[PerViewConstantBufferCsgo_t._m8], undetermined[_Globals_.g_sCookieSampler]), _11087).xyzw - _11408.zzzz;
	        float _18579 = _18418.w;
	        float _12013 = _18418.z;
	        bool _12285 = abs(_12013) < _18579;
	        vec2 _23168;
	        if (_12285)
	        {
	            _23168 = vec2(PerViewConstantBufferCsgo_t._m16.x, 0.0);
	        }
	        else
	        {
	            _23168 = vec2(0.0);
	        }
	        float _20965 = _12285 ? _12013 : _18579;
	        float _15372 = _18418.x;
	        bool _12286 = abs(_15372) < _20965;
	        vec2 _23169;
	        if (_12286)
	        {
	            _23169 = vec2(0.0, PerViewConstantBufferCsgo_t._m16.y);
	        }
	        else
	        {
	            _23169 = _23168;
	        }
	        vec4 _10010 = normalize(vec4(PerViewLightingConstantBufferGpu_t._m7.x * fma(dot(_10170, normalize(vec3(PerViewLightingConstantBufferGpu_t._m6._m0[0].xy, 0.25))), 0.5, 0.5), PerViewLightingConstantBufferGpu_t._m7.y * fma(dot(_10170, normalize(vec3(PerViewLightingConstantBufferGpu_t._m6._m0[1].xy, 0.25))), 0.5, 0.5), PerViewLightingConstantBufferGpu_t._m7.z * fma(dot(_10170, normalize(vec3(PerViewLightingConstantBufferGpu_t._m6._m0[2].xy, 0.25))), 0.5, 0.5), PerViewLightingConstantBufferGpu_t._m7.w * fma(dot(_10170, normalize(vec3(PerViewLightingConstantBufferGpu_t._m6._m0[3].xy, 0.25))), 0.5, 0.5)));
	        vec4 _13232 = max(vec4(dot(PerViewLightingConstantBufferGpu_t._m6._m0[0].xyz, _11394), dot(PerViewLightingConstantBufferGpu_t._m6._m0[1].xyz, _11394), dot(PerViewLightingConstantBufferGpu_t._m6._m0[2].xyz, _11394), dot(PerViewLightingConstantBufferGpu_t._m6._m0[3].xyz, _11394)).xyzw, vec4(0.0)) * normalize(clamp(((_10010 - vec4(max(max(_10010.x, _10010.y), max(_10010.z, _10010.w)))) + vec4(0.20000000298023223876953125)) * vec4(5.0), vec4(0.0), vec4(1.0)));
	        _21712 = (1.0 / (dot(_13232, vec4(1.0)) + PerViewLightingConstantBufferGpu_t._m8.x)) * (PerViewLightingConstantBufferGpu_t._m8.x + dot(_13232, textureLod(sampler2D(g_bindless_Texture2D_float4[PerViewConstantBufferCsgo_t._m7], undetermined[_Globals_.g_sPointClamp]), (_11087 + mix(_23169, PerViewConstantBufferCsgo_t._m16.xy, bvec2(abs(_18418.y) < (_12286 ? _15372 : _20965))).xy).xy, 0.0)));
	    }
	    else
	    {
	        _21712 = 1.0;
	    }
	    float _21713;
	    if (notEqual(PerViewConstantBufferCsgo_t._m0, ivec4(0)).w)
	    {
	        _21713 = _21712 * textureLod(sampler2D(g_bindless_Texture2D_float4[PerViewConstantBufferCsgo_t._m9], undetermined[_Globals_.g_sUserConfig]), (_11408.xy * PerViewConstantBuffer_t._m3.xy).xy, 0.0).x;
	    }
	    else
	    {
	        _21713 = _21712;
	    }
	    float _21714;
	    if (PerViewLightingConstantBufferGpu_t._m20 != 0)
	    {
	        int _23989;
	        int _10191;
	        float _13138;
	        vec3 _14975;
	        int _13039 = 0;
	        for (;;)
	        {
	            if (!(_13039 < PerViewLightingConstantBufferGpu_t._m20))
	            {
	                _13138 = 1.0;
	                _14975 = vec3(0.0);
	                _10191 = -1;
	                break;
	            }
	            vec4 _18322 = vec4(input_1.xyz, 1.0) * mat4(vec4(PerViewLightingConstantBufferGpu_t._m27._m0[_13039]._m0[0].x, PerViewLightingConstantBufferGpu_t._m27._m0[_13039]._m0[1].x, PerViewLightingConstantBufferGpu_t._m27._m0[_13039]._m0[2].x, PerViewLightingConstantBufferGpu_t._m27._m0[_13039]._m0[3].x), vec4(PerViewLightingConstantBufferGpu_t._m27._m0[_13039]._m0[0].y, PerViewLightingConstantBufferGpu_t._m27._m0[_13039]._m0[1].y, PerViewLightingConstantBufferGpu_t._m27._m0[_13039]._m0[2].y, PerViewLightingConstantBufferGpu_t._m27._m0[_13039]._m0[3].y), vec4(PerViewLightingConstantBufferGpu_t._m27._m0[_13039]._m0[0].z, PerViewLightingConstantBufferGpu_t._m27._m0[_13039]._m0[1].z, PerViewLightingConstantBufferGpu_t._m27._m0[_13039]._m0[2].z, PerViewLightingConstantBufferGpu_t._m27._m0[_13039]._m0[3].z), vec4(PerViewLightingConstantBufferGpu_t._m27._m0[_13039]._m0[0].w, PerViewLightingConstantBufferGpu_t._m27._m0[_13039]._m0[1].w, PerViewLightingConstantBufferGpu_t._m27._m0[_13039]._m0[2].w, PerViewLightingConstantBufferGpu_t._m27._m0[_13039]._m0[3].w));
	            float _12779 = _18322.x;
	            if (max(abs(_12779), abs(_18322.y)) < PerViewLightingConstantBufferGpu_t._m22[_13039])
	            {
	                vec3 _19470 = vec3(_12779, _18322.yz);
	                vec2 _24804 = _19470.xy;
	                vec2 _22193 = vec2(1.0) - clamp((abs(_24804) * vec2(PerViewLightingConstantBufferGpu_t._m24)) + vec2(PerViewLightingConstantBufferGpu_t._m23), vec2(0.0), vec2(1.0));
	                vec2 _20561 = (_24804 * PerViewLightingConstantBufferGpu_t._m28._m0[_13039].zw) + PerViewLightingConstantBufferGpu_t._m28._m0[_13039].xy;
	                vec3 _20489 = _19470;
	                _20489.x = _20561.x;
	                _20489.y = _20561.y;
	                _13138 = saturate(_22193.x * _22193.y);
	                _14975 = _20489;
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
	            vec2 _7045;
	            vec2 _7046;
	            vec2 _7735;
	            float _8969;
	            float _8970;
	            float _15996;
	            float _17299;
	            vec2 _18870;
	            vec4 _20581;
	            vec4 _24370;
	            uint _24711;
	            float _23727;
	            do
	            {
	                float _21452 = saturate(_14975.z + PerViewLightingConstantBufferGpu_t._m21);
	                _20581 = PerViewLightingConstantBufferGpu_t._m0;
	                _24370 = PerViewLightingConstantBufferGpu_t._m1;
	                _24711 = _Globals_.g_tShadowDepthBufferCmpSampler;
	                _17299 = PerViewLightingConstantBufferGpu_t._m2.z;
	                _15996 = PerViewLightingConstantBufferGpu_t._m3.z;
	                _18870 = vec2(_17299, _15996);
	                _8969 = PerViewLightingConstantBufferGpu_t._m2.y;
	                _7045 = vec2(_8969, _15996);
	                _8970 = PerViewLightingConstantBufferGpu_t._m3.y;
	                _7046 = vec2(_17299, _8970);
	                _7735 = vec2(_8969, _8970);
	                float _15310 = dot(vec4(textureLod(sampler2DShadow(g_bindless_Texture2D_float4[PerViewLightingConstantBufferGpu_t._m29], undetermined_1[_24711]), vec3((_14975.xy + _18870).xy, _21452), 0.0), textureLod(sampler2DShadow(g_bindless_Texture2D_float4[PerViewLightingConstantBufferGpu_t._m29], undetermined_1[_24711]), vec3((_14975.xy + _7045).xy, _21452), 0.0), textureLod(sampler2DShadow(g_bindless_Texture2D_float4[PerViewLightingConstantBufferGpu_t._m29], undetermined_1[_24711]), vec3((_14975.xy + _7046).xy, _21452), 0.0), textureLod(sampler2DShadow(g_bindless_Texture2D_float4[PerViewLightingConstantBufferGpu_t._m29], undetermined_1[_24711]), vec3((_14975.xy + _7735).xy, _21452), 0.0)).xyzw, vec4(0.25));
	                bool _12887;
	                if (_15310 == 0.0)
	                {
	                    _12887 = true;
	                }
	                else
	                {
	                    _12887 = _15310 == 1.0;
	                }
	                if (_12887)
	                {
	                    _23727 = _15310;
	                    break;
	                }
	                _23727 = ((_15310 * (_20581.w * 4.0)) + dot(vec4(textureLod(sampler2DShadow(g_bindless_Texture2D_float4[PerViewLightingConstantBufferGpu_t._m29], undetermined_1[_24711]), vec3((_14975.xy + vec2(_17299, 0.0)).xy, _21452), 0.0), textureLod(sampler2DShadow(g_bindless_Texture2D_float4[PerViewLightingConstantBufferGpu_t._m29], undetermined_1[_24711]), vec3((_14975.xy + vec2(_8969, 0.0)).xy, _21452), 0.0), textureLod(sampler2DShadow(g_bindless_Texture2D_float4[PerViewLightingConstantBufferGpu_t._m29], undetermined_1[_24711]), vec3((_14975.xy + vec2(0.0, _8970)).xy, _21452), 0.0), textureLod(sampler2DShadow(g_bindless_Texture2D_float4[PerViewLightingConstantBufferGpu_t._m29], undetermined_1[_24711]), vec3((_14975.xy + vec2(0.0, _15996)).xy, _21452), 0.0)).xyzw, _24370.xxxx)) + (textureLod(sampler2DShadow(g_bindless_Texture2D_float4[PerViewLightingConstantBufferGpu_t._m29], undetermined_1[_24711]), vec3(_14975.xy, _21452), 0.0) * _24370.y);
	                break;
	            } while(false);
	            float _12502;
	            if (_13138 < 1.0)
	            {
	                float _7934;
	                if (_10191 < (PerViewLightingConstantBufferGpu_t._m20 - 1))
	                {
	                    int _15335 = _10191 + 1;
	                    vec4 _19671 = vec4(input_1.xyz, 1.0) * mat4(vec4(PerViewLightingConstantBufferGpu_t._m27._m0[_15335]._m0[0].x, PerViewLightingConstantBufferGpu_t._m27._m0[_15335]._m0[1].x, PerViewLightingConstantBufferGpu_t._m27._m0[_15335]._m0[2].x, PerViewLightingConstantBufferGpu_t._m27._m0[_15335]._m0[3].x), vec4(PerViewLightingConstantBufferGpu_t._m27._m0[_15335]._m0[0].y, PerViewLightingConstantBufferGpu_t._m27._m0[_15335]._m0[1].y, PerViewLightingConstantBufferGpu_t._m27._m0[_15335]._m0[2].y, PerViewLightingConstantBufferGpu_t._m27._m0[_15335]._m0[3].y), vec4(PerViewLightingConstantBufferGpu_t._m27._m0[_15335]._m0[0].z, PerViewLightingConstantBufferGpu_t._m27._m0[_15335]._m0[1].z, PerViewLightingConstantBufferGpu_t._m27._m0[_15335]._m0[2].z, PerViewLightingConstantBufferGpu_t._m27._m0[_15335]._m0[3].z), vec4(PerViewLightingConstantBufferGpu_t._m27._m0[_15335]._m0[0].w, PerViewLightingConstantBufferGpu_t._m27._m0[_15335]._m0[1].w, PerViewLightingConstantBufferGpu_t._m27._m0[_15335]._m0[2].w, PerViewLightingConstantBufferGpu_t._m27._m0[_15335]._m0[3].w));
	                    vec2 _20562 = (_19671.xy * PerViewLightingConstantBufferGpu_t._m28._m0[_15335].zw) + PerViewLightingConstantBufferGpu_t._m28._m0[_15335].xy;
	                    vec3 _20490;
	                    _20490.x = _20562.x;
	                    _20490.y = _20562.y;
	                    float _12501;
	                    do
	                    {
	                        float _20322 = saturate(_19671.z + PerViewLightingConstantBufferGpu_t._m21);
	                        float _15311 = dot(vec4(textureLod(sampler2DShadow(g_bindless_Texture2D_float4[PerViewLightingConstantBufferGpu_t._m29], undetermined_1[_24711]), vec3((_20490.xy + _18870).xy, _20322), 0.0), textureLod(sampler2DShadow(g_bindless_Texture2D_float4[PerViewLightingConstantBufferGpu_t._m29], undetermined_1[_24711]), vec3((_20490.xy + _7045).xy, _20322), 0.0), textureLod(sampler2DShadow(g_bindless_Texture2D_float4[PerViewLightingConstantBufferGpu_t._m29], undetermined_1[_24711]), vec3((_20490.xy + _7046).xy, _20322), 0.0), textureLod(sampler2DShadow(g_bindless_Texture2D_float4[PerViewLightingConstantBufferGpu_t._m29], undetermined_1[_24711]), vec3((_20490.xy + _7735).xy, _20322), 0.0)).xyzw, vec4(0.25));
	                        bool _12888;
	                        if (_15311 == 0.0)
	                        {
	                            _12888 = true;
	                        }
	                        else
	                        {
	                            _12888 = _15311 == 1.0;
	                        }
	                        if (_12888)
	                        {
	                            _12501 = _15311;
	                            break;
	                        }
	                        _12501 = ((_15311 * (_20581.w * 4.0)) + dot(vec4(textureLod(sampler2DShadow(g_bindless_Texture2D_float4[PerViewLightingConstantBufferGpu_t._m29], undetermined_1[_24711]), vec3((_20490.xy + vec2(_17299, 0.0)).xy, _20322), 0.0), textureLod(sampler2DShadow(g_bindless_Texture2D_float4[PerViewLightingConstantBufferGpu_t._m29], undetermined_1[_24711]), vec3((_20490.xy + vec2(_8969, 0.0)).xy, _20322), 0.0), textureLod(sampler2DShadow(g_bindless_Texture2D_float4[PerViewLightingConstantBufferGpu_t._m29], undetermined_1[_24711]), vec3((_20490.xy + vec2(0.0, _8970)).xy, _20322), 0.0), textureLod(sampler2DShadow(g_bindless_Texture2D_float4[PerViewLightingConstantBufferGpu_t._m29], undetermined_1[_24711]), vec3((_20490.xy + vec2(0.0, _15996)).xy, _20322), 0.0)).xyzw, _24370.xxxx)) + (textureLod(sampler2DShadow(g_bindless_Texture2D_float4[PerViewLightingConstantBufferGpu_t._m29], undetermined_1[_24711]), vec3(_20490.xy, _20322), 0.0) * _24370.y);
	                        break;
	                    } while(false);
	                    _7934 = _12501;
	                }
	                else
	                {
	                    _7934 = 1.0;
	                }
	                _12502 = mix(_7934, _23727, _13138);
	            }
	            else
	            {
	                _12502 = _23727;
	            }
	            _19363 = _12502;
	        }
	        else
	        {
	            _19363 = 1.0;
	        }
	        float _13279 = mix(_19363, 1.0, clamp((distance(_10061.xyz, PerViewConstantBuffer_t._m6) * PerViewLightingConstantBufferGpu_t._m26) + PerViewLightingConstantBufferGpu_t._m25, 0.0, 1.0));
	        float _12503;
	        if (_24465.y)
	        {
	            _12503 = min(_13279, textureLod(sampler2D(g_bindless_Texture2D_float4[PerViewConstantBufferCsgo_t._m10], undetermined[_Globals_.g_sTrilinearClamp]), (_11408.xy * PerViewConstantBuffer_t._m3.xy).xy, 0.0).z);
	        }
	        else
	        {
	            _12503 = _13279;
	        }
	        _21714 = _12503;
	    }
	    else
	    {
	        _21714 = 1.0;
	    }
	    vec3 _9717;
	    vec3 _24879;
	    if ((dot(PerViewLightingConstantBufferGpu_t._m18.xyz, _24735) * _21714) > 0.0)
	    {
	        vec3 _15460 = mix(_17892, _24735, bvec3(all(equal(_17892, vec3(1.0)))));
	        float _13811 = max(0.0, dot(_14786.xyz, PerViewLightingConstantBufferGpu_t._m18.xyz));
	        vec3 _17874 = vec3(_13811);
	        vec3 _18223;
	        if (_6616 > 0.0)
	        {
	            float _8780 = dot(_15460, PerViewLightingConstantBufferGpu_t._m18.xyz);
	            float _8124 = saturate(_6616);
	            _18223 = mix(_17874.xyz, vec3((((0.5 + (_13811 * 0.5)) + pow(1.0 - saturate(_8780), 4.0)) * clamp((_8780 + 0.20000000298023223876953125) * 4.0, 0.0, 1.0)) * clamp(mix(dot(mix(_24735, _15460, vec3(10.0)), PerViewLightingConstantBufferGpu_t._m18.xyz), 1.0, _8124), 0.0, 1.0)), vec3(_8124));
	        }
	        else
	        {
	            _18223 = _17874;
	        }
	        vec2 _17301 = max(_11004, vec2(PerViewLightingConstantBufferGpu_t._m18.w));
	        vec3 _21889 = (-normalize(_10061.xyz - PerViewConstantBuffer_t._m6.xyz)).xyz;
	        vec3 _12281 = normalize(PerViewLightingConstantBufferGpu_t._m18.xyz + _21889).xyz;
	        vec3 _19012 = _15460.xyz;
	        float _12386 = dot(_12281, _19012);
	        float _25073 = max(0.0, dot(_19012, _21889));
	        float _9850 = _17301.x;
	        float _25211 = _9850 * _9850;
	        float _19097 = _12386 * _12386;
	        float _24198 = _25211 / ((_19097 * ((_25211 * _25211) - 1.0)) + 1.0);
	        float _16150 = _9850 + 1.0;
	        float _6835 = (_16150 * _16150) * 0.125;
	        float _19569 = 1.0 - _6835;
	        float _21624 = (_24198 * _24198) / ((4.0 * ((_13811 * _19569) + _6835)) * ((_25073 * _19569) + _6835));
	        float _11621;
	        if (_14875)
	        {
	            float _6597 = dot(_17301.xy, vec2(0.5));
	            float _20791 = max(_6597 * _6597, 9.9999997473787516355514526367188e-06);
	            float _21401 = saturate(_25073 + 0.001000000047497451305389404296875);
	            _11621 = mix(_21624, (((((2.0 + (1.0 / _20791)) * pow(1.0 - _19097, 0.5 / _20791)) * 0.159154832363128662109375) * (0.25 / ((_13811 + _21401) - (_13811 * _21401)))) * 3.1415927410125732421875) * _13811, _17117);
	        }
	        else
	        {
	            _11621 = _21624;
	        }
	        vec3 _15806 = ((_16306.xyz + ((vec3(1.0) - _16306.xyz) * pow(max(9.9999999747524270787835121154785e-07, 1.0 - max(0.0, dot(PerViewLightingConstantBufferGpu_t._m18.xyz, _12281))), 5.0))) * _11621).xyz * _13811;
	        vec3 _9716;
	        vec3 _24878;
	        if (notEqual(PerViewConstantBufferCsgo_t._m2, ivec4(0)).w)
	        {
	            float _22996 = smoothstep(0.0, 1.0, clamp(dot(_24735, PerViewLightingConstantBufferGpu_t._m18.xyz) / sqrt(max(1.0 - _17476, 9.9999997473787516355514526367188e-06)), 0.0, 1.0));
	            _9716 = _15806 * _22996;
	            _24878 = _18223 * _22996;
	        }
	        else
	        {
	            _9716 = _15806;
	            _24878 = _18223;
	        }
	        vec3 _16808 = (PerViewLightingConstantBufferGpu_t._m19.xyz * _21714).xyz;
	        _9717 = PerViewLightingConstantBufferGpu_t._m9.xyz + (_24878.xyz * _16808);
	        _24879 = _9716.xyz * _16808;
	    }
	    else
	    {
	        _9717 = PerViewLightingConstantBufferGpu_t._m9.xyz;
	        _24879 = vec3(0.0);
	    }
	    bvec4 _24468 = notEqual(PerViewConstantBufferCsgo_t._m2, ivec4(0));
	    bool _20062 = _24468.x;
	    vec4 _19364;
	    if (_20062)
	    {
	        vec4 _24259 = vec4(_10061.xyz, 1.0).xyzw * mat4(vec4(PerViewConstantBufferCsgo_t._m15._m0[0].x, PerViewConstantBufferCsgo_t._m15._m0[1].x, PerViewConstantBufferCsgo_t._m15._m0[2].x, PerViewConstantBufferCsgo_t._m15._m0[3].x), vec4(PerViewConstantBufferCsgo_t._m15._m0[0].y, PerViewConstantBufferCsgo_t._m15._m0[1].y, PerViewConstantBufferCsgo_t._m15._m0[2].y, PerViewConstantBufferCsgo_t._m15._m0[3].y), vec4(PerViewConstantBufferCsgo_t._m15._m0[0].z, PerViewConstantBufferCsgo_t._m15._m0[1].z, PerViewConstantBufferCsgo_t._m15._m0[2].z, PerViewConstantBufferCsgo_t._m15._m0[3].z), vec4(PerViewConstantBufferCsgo_t._m15._m0[0].w, PerViewConstantBufferCsgo_t._m15._m0[1].w, PerViewConstantBufferCsgo_t._m15._m0[2].w, PerViewConstantBufferCsgo_t._m15._m0[3].w));
	        float _20176 = _24259.w;
	        vec2 _11414 = _24259.xy / vec2(_20176);
	        vec4 _6651;
	        _6651.x = clamp(((_11414.x + 1.0) * PerViewConstantBuffer_t._m2.x) * 0.5, 0.0, PerViewConstantBuffer_t._m2.x - 1.0);
	        _6651.y = clamp(((1.0 - _11414.y) * PerViewConstantBuffer_t._m2.y) * 0.5, 0.0, PerViewConstantBuffer_t._m2.y - 1.0);
	        _6651.w = _20176;
	        _19364 = _6651;
	    }
	    else
	    {
	        _19364 = _11408;
	    }
	    uvec2 _7663 = uvec2(PerViewLightingConstantBufferGpu_t._m13.x);
	    uvec2 _12083 = uvec2(_19364.xy - PerViewConstantBuffer_t._m1.xy) >> _7663;
	    uint _10838 = PerViewLightingConstantBufferGpu_t._m10.y + (((_12083.y * PerViewLightingConstantBufferGpu_t._m13.y) + _12083.x) * PerViewLightingConstantBufferGpu_t._m10.z);
	    uint _23393 = PerViewLightingConstantBufferGpu_t._m10.x + (uint(clamp(_19364.w * PerViewLightingConstantBufferGpu_t._m14.x, 0.0, PerViewLightingConstantBufferGpu_t._m14.y)) * PerViewLightingConstantBufferGpu_t._m10.z);
	    vec3 _13139;
	    vec3 _16324;
	    _13139 = _9717;
	    _16324 = _24879;
	    uint _21567;
	    vec3 _13140;
	    vec3 _16325;
	    uint _17017 = 0u;
	    for (;;)
	    {
	        if (!(_17017 < PerViewLightingConstantBufferGpu_t._m10.z))
	        {
	            break;
	        }
	        uint _14475 = subgroupOr(g_CullBits_1._m0[_10838 + _17017] & g_CullBits_1._m0[_23393 + _17017]);
	        _13140 = _16324;
	        _16325 = _13139;
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
	                vec4 _15817 = mat4(vec4(g_BarnLights_1._m0[_12608]._m0._m0[0].x, g_BarnLights_1._m0[_12608]._m0._m0[1].x, g_BarnLights_1._m0[_12608]._m0._m0[2].x, g_BarnLights_1._m0[_12608]._m0._m0[3].x), vec4(g_BarnLights_1._m0[_12608]._m0._m0[0].y, g_BarnLights_1._m0[_12608]._m0._m0[1].y, g_BarnLights_1._m0[_12608]._m0._m0[2].y, g_BarnLights_1._m0[_12608]._m0._m0[3].y), vec4(g_BarnLights_1._m0[_12608]._m0._m0[0].z, g_BarnLights_1._m0[_12608]._m0._m0[1].z, g_BarnLights_1._m0[_12608]._m0._m0[2].z, g_BarnLights_1._m0[_12608]._m0._m0[3].z), vec4(g_BarnLights_1._m0[_12608]._m0._m0[0].w, g_BarnLights_1._m0[_12608]._m0._m0[1].w, g_BarnLights_1._m0[_12608]._m0._m0[2].w, g_BarnLights_1._m0[_12608]._m0._m0[3].w)) * vec4(input_1.xyz, 1.0);
	                vec3 _10521 = _15817.xyz / vec3(_15817.w);
	                vec4 _22905;
	                _22905.x = _10521.x;
	                _22905.y = _10521.y;
	                float _21775 = _10521.z;
	                _22905.z = _21775;
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
	                bool _12889;
	                if (!_7425)
	                {
	                    _12889 = true;
	                }
	                else
	                {
	                    _12889 = !all(lessThanEqual(abs((mat4x3(vec3(g_BarnLights_1._m0[_12608]._m15._m0[0].x, g_BarnLights_1._m0[_12608]._m15._m0[1].x, g_BarnLights_1._m0[_12608]._m15._m0[2].x), vec3(g_BarnLights_1._m0[_12608]._m15._m0[0].y, g_BarnLights_1._m0[_12608]._m15._m0[1].y, g_BarnLights_1._m0[_12608]._m15._m0[2].y), vec3(g_BarnLights_1._m0[_12608]._m15._m0[0].z, g_BarnLights_1._m0[_12608]._m15._m0[1].z, g_BarnLights_1._m0[_12608]._m15._m0[2].z), vec3(g_BarnLights_1._m0[_12608]._m15._m0[0].w, g_BarnLights_1._m0[_12608]._m15._m0[1].w, g_BarnLights_1._m0[_12608]._m15._m0[2].w)) * vec4(input_1.xyz, 1.0)).xyz), vec3(1.0)));
	                }
	                if (_12889)
	                {
	                    _13212 = _13140;
	                    _15670 = _16325;
	                    break;
	                }
	                float _23571 = 2.0 * g_BarnLights_1._m0[_12608]._m5.y;
	                float _18492 = (2.0 * g_BarnLights_1._m0[_12608]._m5.z) * g_BarnLights_1._m0[_12608]._m5.z;
	                float _14805 = 2.0 * g_BarnLights_1._m0[_12608]._m5.x;
	                float _9058 = _14805 * g_BarnLights_1._m0[_12608]._m5.y;
	                float _17330 = 2.0 * g_BarnLights_1._m0[_12608]._m5.w;
	                float _19825 = _17330 * g_BarnLights_1._m0[_12608]._m5.z;
	                vec3 _16268 = vec3(_9058 - _19825, (1.0 - (_14805 * g_BarnLights_1._m0[_12608]._m5.x)) - _18492, (_23571 * g_BarnLights_1._m0[_12608]._m5.z) + (_17330 * g_BarnLights_1._m0[_12608]._m5.x)) * g_BarnLights_1._m0[_12608]._m6.z;
	                float _21316;
	                if (g_BarnLights_1._m0[_12608]._m3.z > 0.0)
	                {
	                    _21316 = smoothstep(0.0, 1.0, _21775 * g_BarnLights_1._m0[_12608]._m3.z);
	                }
	                else
	                {
	                    _21316 = 1.0;
	                }
	                float _19667;
	                if (g_BarnLights_1._m0[_12608]._m3.w > 0.0)
	                {
	                    _19667 = _21316 * smoothstep(0.0, 1.0, (1.0 - _21775) * g_BarnLights_1._m0[_12608]._m3.w);
	                }
	                else
	                {
	                    _19667 = _21316;
	                }
	                vec3 _11179;
	                float _11633;
	                if (g_BarnLights_1._m0[_12608]._m2.w != 0.0)
	                {
	                    vec3 _10017 = g_BarnLights_1._m0[_12608]._m2.xyz - input_1.xyz;
	                    float _18345 = dot(_10017, _10017);
	                    float _17647 = sqrt(_18345);
	                    vec3 _20958 = _10017 - _16268;
	                    vec3 _10210;
	                    do
	                    {
	                        vec3 _20229 = (_10017 + _16268) - _20958;
	                        float _25105 = dot(-_20958, _20229);
	                        if (_25105 <= 0.0)
	                        {
	                            _10210 = _20958;
	                            break;
	                        }
	                        else
	                        {
	                            _10210 = _20958 + (_20229 * min(1.0, _25105 / dot(_20229, _20229)));
	                            break;
	                        }
	                        break; // unreachable workaround
	                    } while(false);
	                    _11179 = _10017 / vec3(_17647);
	                    _11633 = ((_19667 * (g_BarnLights_1._m0[_12608]._m2.w / max(_18345, g_BarnLights_1._m0[_12608]._m2.w))) * smoothstep(0.0, 1.0, g_BarnLights_1._m0[_12608]._m3.x + (g_BarnLights_1._m0[_12608]._m3.y * _17647))) * clamp(g_BarnLights_1._m0[_12608]._m6.x + (g_BarnLights_1._m0[_12608]._m6.y * dot(vec3((1.0 - (_23571 * g_BarnLights_1._m0[_12608]._m5.y)) - _18492, _9058 + _19825, (_14805 * g_BarnLights_1._m0[_12608]._m5.z) - (_17330 * g_BarnLights_1._m0[_12608]._m5.y)), normalize(_10210))), 0.0, 1.0);
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
	                    _24419 = !_20062;
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
	                            float _15267 = 2.0 / g_BarnLights_1._m0[_12608]._m9.z;
	                            float _15020 = _22154.y;
	                            float _23041 = (-0.5) * g_BarnLights_1._m0[_12608]._m9.z;
	                            float _11981 = (g_BarnLights_1._m0[_12608]._m9.x * g_BarnLights_1._m0[_12608]._m9.y) * pow(max(pow(g_BarnLights_1._m0[_12608]._m9.y * _11473, _15267) + pow(g_BarnLights_1._m0[_12608]._m9.x * _15020, _15267), 1.1754943508222875079687365372222e-38), _23041);
	                            float _16524 = pow(max(pow(_11473, _15267) + pow(_15020, _15267), 1.1754943508222875079687365372222e-38), _23041);
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
	                    vec3 _12504;
	                    if (g_BarnLights_1._m0[_12608]._m4.w < 0.0)
	                    {
	                        vec4 _17795 = vec4(-g_BarnLights_1._m0[_12608]._m5.xyz, g_BarnLights_1._m0[_12608]._m5.w);
	                        vec4 _19008 = _17795.xyzw * vec4(-1.0, -1.0, -1.0, 1.0);
	                        vec3 _24989 = _19008.xyz;
	                        vec3 _23629 = vec4((-_11179).xyz, 0.0).xyz;
	                        float _15156 = -dot(_23629, _24989);
	                        vec3 _20479 = vec4((_23629 * _19008.w) + cross(_23629, _24989), _15156).xyz;
	                        vec3 _23593 = _17795.xyz;
	                        vec3 _12170 = ((_20479 * g_BarnLights_1._m0[_12608]._m5.w) + (_23593 * _15156)) + cross(_23593, _20479);
	                        vec3 _14081 = vec3(vec2(atan(_12170.y, -_12170.x) * 0.15915493667125701904296875, acos(_12170.z) * 0.3183098733425140380859375), -g_BarnLights_1._m0[_12608]._m4.w);
	                        vec2 _20564 = (_14081.xy * g_BarnLights_1._m0[_12608]._m9.zw) + g_BarnLights_1._m0[_12608]._m9.xy;
	                        vec3 _20492 = _14081;
	                        _20492.x = _20564.x;
	                        _20492.y = _20564.y;
	                        _12504 = _17828.xyz * textureLod(sampler3D(g_bindless_Texture3D_float4[PerViewLightingConstantBufferGpu_t._m30], undetermined[_Globals_.g_sTrilinearWrap]), _20492.xyz, 0.0).xyz;
	                    }
	                    else
	                    {
	                        vec3 _13791 = vec3(fma(_22905.xy, vec2(0.5, -0.5), vec2(0.5)), g_BarnLights_1._m0[_12608]._m4.w);
	                        vec2 _20563 = (_13791.xy * g_BarnLights_1._m0[_12608]._m9.zw) + g_BarnLights_1._m0[_12608]._m9.xy;
	                        vec3 _20491 = _13791;
	                        _20491.x = _20563.x;
	                        _20491.y = _20563.y;
	                        _12504 = _17828.xyz * textureLod(sampler3D(g_bindless_Texture3D_float4[PerViewLightingConstantBufferGpu_t._m30], undetermined[_Globals_.g_sCookieSampler]), _20491.xyz, 0.0).xyz;
	                    }
	                    _21548 = _12504;
	                }
	                if (all(equal(_21548.xyz, vec3(0.0))))
	                {
	                    _13212 = _13140;
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
	                    float _24972;
	                    do
	                    {
	                        float _21462 = saturate(_19629.z + PerViewLightingConstantBufferGpu_t._m21);
	                        vec2 _10393 = vec3(fma(_19629.xy, g_BarnLights_1._m0[_12608]._m8.zw, g_BarnLights_1._m0[_12608]._m8.xy), _19629.z).xy;
	                        float _15312 = dot(vec4(textureLod(sampler2DShadow(g_bindless_Texture2D_float4[PerViewLightingConstantBufferGpu_t._m29], undetermined_1[_Globals_.g_tShadowDepthBufferCmpSampler]), vec3((_10393 + vec2(PerViewLightingConstantBufferGpu_t._m2.z, PerViewLightingConstantBufferGpu_t._m3.z)).xy, _21462), 0.0), textureLod(sampler2DShadow(g_bindless_Texture2D_float4[PerViewLightingConstantBufferGpu_t._m29], undetermined_1[_Globals_.g_tShadowDepthBufferCmpSampler]), vec3((_10393 + vec2(PerViewLightingConstantBufferGpu_t._m2.y, PerViewLightingConstantBufferGpu_t._m3.z)).xy, _21462), 0.0), textureLod(sampler2DShadow(g_bindless_Texture2D_float4[PerViewLightingConstantBufferGpu_t._m29], undetermined_1[_Globals_.g_tShadowDepthBufferCmpSampler]), vec3((_10393 + vec2(PerViewLightingConstantBufferGpu_t._m2.z, PerViewLightingConstantBufferGpu_t._m3.y)).xy, _21462), 0.0), textureLod(sampler2DShadow(g_bindless_Texture2D_float4[PerViewLightingConstantBufferGpu_t._m29], undetermined_1[_Globals_.g_tShadowDepthBufferCmpSampler]), vec3((_10393 + vec2(PerViewLightingConstantBufferGpu_t._m2.y, PerViewLightingConstantBufferGpu_t._m3.y)).xy, _21462), 0.0)).xyzw, vec4(0.25));
	                        bool _12890;
	                        if (_15312 == 0.0)
	                        {
	                            _12890 = true;
	                        }
	                        else
	                        {
	                            _12890 = _15312 == 1.0;
	                        }
	                        if (_12890)
	                        {
	                            _24972 = _15312;
	                            break;
	                        }
	                        _24972 = ((_15312 * (PerViewLightingConstantBufferGpu_t._m0.w * 4.0)) + dot(vec4(textureLod(sampler2DShadow(g_bindless_Texture2D_float4[PerViewLightingConstantBufferGpu_t._m29], undetermined_1[_Globals_.g_tShadowDepthBufferCmpSampler]), vec3((_10393 + vec2(PerViewLightingConstantBufferGpu_t._m2.z, 0.0)).xy, _21462), 0.0), textureLod(sampler2DShadow(g_bindless_Texture2D_float4[PerViewLightingConstantBufferGpu_t._m29], undetermined_1[_Globals_.g_tShadowDepthBufferCmpSampler]), vec3((_10393 + vec2(PerViewLightingConstantBufferGpu_t._m2.y, 0.0)).xy, _21462), 0.0), textureLod(sampler2DShadow(g_bindless_Texture2D_float4[PerViewLightingConstantBufferGpu_t._m29], undetermined_1[_Globals_.g_tShadowDepthBufferCmpSampler]), vec3((_10393 + vec2(0.0, PerViewLightingConstantBufferGpu_t._m3.y)).xy, _21462), 0.0), textureLod(sampler2DShadow(g_bindless_Texture2D_float4[PerViewLightingConstantBufferGpu_t._m29], undetermined_1[_Globals_.g_tShadowDepthBufferCmpSampler]), vec3((_10393 + vec2(0.0, PerViewLightingConstantBufferGpu_t._m3.z)).xy, _21462), 0.0)).xyzw, PerViewLightingConstantBufferGpu_t._m1.xxxx)) + (textureLod(sampler2DShadow(g_bindless_Texture2D_float4[PerViewLightingConstantBufferGpu_t._m29], undetermined_1[_Globals_.g_tShadowDepthBufferCmpSampler]), vec3(_10393, _21462), 0.0) * PerViewLightingConstantBufferGpu_t._m1.y);
	                        break;
	                    } while(false);
	                    vec3 _19878 = _21548.xyz * mix(1.0, _24972, g_BarnLights_1._m0[_12608]._m12);
	                    if (all(equal(_19878.xyz, vec3(0.0))))
	                    {
	                        _13212 = _13140;
	                        _15670 = _16325;
	                        break;
	                    }
	                    _21549 = _19878;
	                }
	                else
	                {
	                    _21549 = _21548;
	                }
	                vec3 _15462 = mix(_17892, _24735, bvec3(all(equal(_17892, vec3(1.0)))));
	                float _13812 = max(0.0, dot(_14786.xyz, _11179.xyz));
	                vec3 _17875 = vec3(_13812);
	                vec3 _18224;
	                if (_6616 > 0.0)
	                {
	                    float _8781 = dot(_15462, _11179.xyz);
	                    float _8125 = saturate(_6616);
	                    _18224 = mix(_17875.xyz, vec3((((0.5 + (_13812 * 0.5)) + pow(1.0 - saturate(_8781), 4.0)) * clamp((_8781 + 0.20000000298023223876953125) * 4.0, 0.0, 1.0)) * clamp(mix(dot(mix(_24735, _15462, vec3(10.0)), _11179.xyz), 1.0, _8125), 0.0, 1.0)), vec3(_8125));
	                }
	                else
	                {
	                    _18224 = _17875;
	                }
	                vec2 _17302 = max(_11004, vec2(g_BarnLights_1._m0[_12608]._m11));
	                vec3 _21890 = (-normalize(_10061.xyz - PerViewConstantBuffer_t._m6.xyz)).xyz;
	                vec3 _12282 = normalize(_11179.xyz + _21890).xyz;
	                vec3 _19014 = _15462.xyz;
	                float _12387 = dot(_12282, _19014);
	                float _25074 = max(0.0, dot(_19014, _21890));
	                float _9851 = _17302.x;
	                float _25214 = _9851 * _9851;
	                float _19098 = _12387 * _12387;
	                float _24199 = _25214 / ((_19098 * ((_25214 * _25214) - 1.0)) + 1.0);
	                float _16151 = _9851 + 1.0;
	                float _6836 = (_16151 * _16151) * 0.125;
	                float _19571 = 1.0 - _6836;
	                float _21625 = (_24199 * _24199) / ((4.0 * ((_13812 * _19571) + _6836)) * ((_25074 * _19571) + _6836));
	                float _11622;
	                if (_14875)
	                {
	                    float _6598 = dot(_17302.xy, vec2(0.5));
	                    float _20792 = max(_6598 * _6598, 9.9999997473787516355514526367188e-06);
	                    float _21402 = saturate(_25074 + 0.001000000047497451305389404296875);
	                    _11622 = mix(_21625, (((((2.0 + (1.0 / _20792)) * pow(1.0 - _19098, 0.5 / _20792)) * 0.159154832363128662109375) * (0.25 / ((_13812 + _21402) - (_13812 * _21402)))) * 3.1415927410125732421875) * _13812, _17117);
	                }
	                else
	                {
	                    _11622 = _21625;
	                }
	                vec3 _16572 = ((_16306.xyz + ((vec3(1.0) - _16306.xyz) * pow(max(9.9999999747524270787835121154785e-07, 1.0 - max(0.0, dot(_11179.xyz, _12282))), 5.0))) * _11622).xyz * _13812;
	                vec3 _9982;
	                vec3 _22798;
	                if (_24468.w)
	                {
	                    float _22998 = smoothstep(0.0, 1.0, clamp(dot(_24735, _11179.xyz) / sqrt(max(1.0 - _17476, 9.9999997473787516355514526367188e-06)), 0.0, 1.0));
	                    _9982 = _16572 * _22998;
	                    _22798 = _18224 * _22998;
	                }
	                else
	                {
	                    _9982 = _16572;
	                    _22798 = _18224;
	                }
	                _13212 = _13140.xyz + (_9982.xyz * _21549.xyz);
	                _15670 = _16325.xyz + (_22798.xyz * _21549.xyz);
	                break;
	            } while(false);
	            _13140 = _13212;
	            _16325 = _15670;
	            _17018 = _20344;
	            continue;
	        }
	        _21567 = _17017 + 1u;
	        _13139 = _16325;
	        _16324 = _13140;
	        _17017 = _21567;
	        continue;
	    }
	    vec3 _10145 = normalize(_10061.xyz - PerViewConstantBuffer_t._m6.xyz);
	    vec3 _19257 = -_10145;
	    float _19582 = (_11004.x + _11004.y) * 0.5;
	    float _6489 = _19582 * _19582;
	    vec3 _22447 = vec3(1.0) + (_16306 * (((2.0 * _6489) * _6489) * clamp(dot(_17892, _19257), 0.0, 1.0)));
	    vec3 _10288;
	    if (_14875)
	    {
	        _10288 = mix(_22447, vec3(1.0), vec3(_17117));
	    }
	    else
	    {
	        _10288 = _22447;
	    }
	    float _17751 = dot(_11004.xy, vec2(0.5));
	    vec3 _6520 = _17892.xyz;
	    vec3 _12148 = _10145.xyz;
	    vec3 _19081 = _17892.xyz;
	    float _12853 = PerViewLightingConstantBufferGpu_t._m15.y * sqrt(_17751);
	    vec3 _11901 = _10061.xyz;
	    bool _11913 = PerViewConstantBufferCsgo_t._m29 != 0.0;
	    vec3 _11008;
	    vec4 _14444;
	    if (_11913)
	    {
	        float _9642 = dot(vec4(((_11901 + PerViewConstantBuffer_t._m5.xyz) + ((-PerViewConstantBuffer_t._m7) * PerViewConstantBufferCsgo_t._m29)).xyz, 1.0), vec4(PerViewConstantBuffer_t._m7.xyz, dot((PerViewConstantBuffer_t._m5.xyz + PerViewConstantBuffer_t._m6.xyz).xyz + (PerViewConstantBuffer_t._m7.xyz * PerViewConstantBuffer_t._m4), PerViewConstantBuffer_t._m7.xyz)));
	        vec3 _21715;
	        if (_9642 <= 0.0)
	        {
	            _21715 = _10061;
	        }
	        else
	        {
	            _21715 = _11901 + ((-PerViewConstantBuffer_t._m7.xyz) * _9642);
	        }
	        vec4 _19975 = vec4(_21715.xyz, 1.0) * mat4(vec4(PerViewConstantBufferCsgo_t._m15._m0[0].x, PerViewConstantBufferCsgo_t._m15._m0[1].x, PerViewConstantBufferCsgo_t._m15._m0[2].x, PerViewConstantBufferCsgo_t._m15._m0[3].x), vec4(PerViewConstantBufferCsgo_t._m15._m0[0].y, PerViewConstantBufferCsgo_t._m15._m0[1].y, PerViewConstantBufferCsgo_t._m15._m0[2].y, PerViewConstantBufferCsgo_t._m15._m0[3].y), vec4(PerViewConstantBufferCsgo_t._m15._m0[0].z, PerViewConstantBufferCsgo_t._m15._m0[1].z, PerViewConstantBufferCsgo_t._m15._m0[2].z, PerViewConstantBufferCsgo_t._m15._m0[3].z), vec4(PerViewConstantBufferCsgo_t._m15._m0[0].w, PerViewConstantBufferCsgo_t._m15._m0[1].w, PerViewConstantBufferCsgo_t._m15._m0[2].w, PerViewConstantBufferCsgo_t._m15._m0[3].w));
	        float _20177 = _19975.w;
	        vec2 _11415 = _19975.xy / vec2(_20177);
	        vec4 _6652;
	        _6652.x = clamp(((_11415.x + 1.0) * PerViewConstantBuffer_t._m2.x) * 0.5, 0.0, PerViewConstantBuffer_t._m2.x - 1.0);
	        _6652.y = clamp(((1.0 - _11415.y) * PerViewConstantBuffer_t._m2.y) * 0.5, 0.0, PerViewConstantBuffer_t._m2.y - 1.0);
	        _6652.w = _20177;
	        _11008 = _21715;
	        _14444 = _6652;
	    }
	    else
	    {
	        _11008 = _11901;
	        _14444 = _11408.xyzw;
	    }
	    float _22046 = _17751 * _17751;
	    float _20711 = saturate(1.0 - _22046);
	    vec3 _25271 = normalize(mix(_6520, reflect(_12148, _19081).xyz, vec3(_20711 * (sqrt(_20711) + _22046))));
	    uvec2 _6814 = uvec2(_14444.xy - PerViewConstantBuffer_t._m1.xy) >> _7663;
	    uint _12130 = PerViewLightingConstantBufferGpu_t._m11.y + (((_6814.y * PerViewLightingConstantBufferGpu_t._m13.y) + _6814.x) * PerViewLightingConstantBufferGpu_t._m11.z);
	    uint _23394 = PerViewLightingConstantBufferGpu_t._m11.x + (uint(clamp(_14444.w * PerViewLightingConstantBufferGpu_t._m14.x, 0.0, PerViewLightingConstantBufferGpu_t._m14.y)) * PerViewLightingConstantBufferGpu_t._m11.z);
	    vec4 _13141;
	    float _16307;
	    vec3 _17118;
	    _13141 = vec4(0.0);
	    _16307 = 0.00999999977648258209228515625;
	    _17118 = vec3(0.0);
	    uint _8896;
	    vec4 _13144;
	    vec3 _14891;
	    float _16309;
	    bool _18379;
	    uint _17020 = 0u;
	    bool _17133 = false;
	    for (;;)
	    {
	        bool _12891;
	        if (_17020 < PerViewLightingConstantBufferGpu_t._m11.z)
	        {
	            _12891 = !_17133;
	        }
	        else
	        {
	            _12891 = false;
	        }
	        if (!_12891)
	        {
	            break;
	        }
	        uint _14476 = subgroupOr(g_CullBits_1._m0[_12130 + _17020] & g_CullBits_1._m0[_23394 + _17020]);
	        vec3 _13142;
	        vec4 _16308;
	        _13142 = _17118;
	        _16308 = _13141;
	        uint _10154;
	        vec3 _13143;
	        vec4 _16381;
	        float _16479;
	        uint _17021 = _14476;
	        float _17134 = _16307;
	        for (;;)
	        {
	            bool _7956_ladder_break = false;
	            do
	            {
	                if (!(_17021 != 0u))
	                {
	                    _13144 = _16308;
	                    _16309 = _17134;
	                    _14891 = _13142;
	                    _18379 = _17133;
	                    _7956_ladder_break = true;
	                    break;
	                }
	                int _12609 = int(uint(findLSB(_17021)) + (_17020 * 32u));
	                _10154 = _17021 & (_17021 - 1u);
	                mat4x3 _16416 = mat4x3(vec3(PerViewLightingConstantBufferGpu_t._m16._m0[_12609]._m0._m0[0].x, PerViewLightingConstantBufferGpu_t._m16._m0[_12609]._m0._m0[1].x, PerViewLightingConstantBufferGpu_t._m16._m0[_12609]._m0._m0[2].x), vec3(PerViewLightingConstantBufferGpu_t._m16._m0[_12609]._m0._m0[0].y, PerViewLightingConstantBufferGpu_t._m16._m0[_12609]._m0._m0[1].y, PerViewLightingConstantBufferGpu_t._m16._m0[_12609]._m0._m0[2].y), vec3(PerViewLightingConstantBufferGpu_t._m16._m0[_12609]._m0._m0[0].z, PerViewLightingConstantBufferGpu_t._m16._m0[_12609]._m0._m0[1].z, PerViewLightingConstantBufferGpu_t._m16._m0[_12609]._m0._m0[2].z), vec3(PerViewLightingConstantBufferGpu_t._m16._m0[_12609]._m0._m0[0].w, PerViewLightingConstantBufferGpu_t._m16._m0[_12609]._m0._m0[1].w, PerViewLightingConstantBufferGpu_t._m16._m0[_12609]._m0._m0[2].w));
	                vec3 _21376 = (_16416 * vec4(_11008.xyz, 1.0)).xyz;
	                vec3 _8793 = clamp((_21376 - PerViewLightingConstantBufferGpu_t._m16._m0[_12609]._m1) * PerViewLightingConstantBufferGpu_t._m16._m0[_12609]._m5.xyz, vec3(0.0), vec3(1.0));
	                vec3 _19651 = clamp((PerViewLightingConstantBufferGpu_t._m16._m0[_12609]._m3 - _21376) * PerViewLightingConstantBufferGpu_t._m16._m0[_12609]._m5.xyz, vec3(0.0), vec3(1.0));
	                float _17265 = min(min(_8793.x, min(_8793.y, _8793.z)), min(_19651.x, min(_19651.y, _19651.z)));
	                if (_17265 == 0.0)
	                {
	                    _13143 = _13142;
	                    _16381 = _16308;
	                    _16479 = _17134;
	                    break;
	                }
	                vec3 _19630;
	                if (PerViewConstantBufferCsgo_t._m28 != 0.0)
	                {
	                    vec3 _19779 = PerViewLightingConstantBufferGpu_t._m16._m0[_12609]._m1 + ((PerViewLightingConstantBufferGpu_t._m16._m0[_12609]._m3 - PerViewLightingConstantBufferGpu_t._m16._m0[_12609]._m1) * 0.5);
	                    _19630 = ((_21376 - _19779) * PerViewConstantBufferCsgo_t._m28) + _19779;
	                }
	                else
	                {
	                    _19630 = _21376;
	                }
	                vec3 _7648 = (_16416 * vec4(_25271.xyz, 0.0)).xyz;
	                vec3 _11253 = max(((PerViewLightingConstantBufferGpu_t._m16._m0[_12609]._m3.xyz - _19630.xyz) / _7648).xyz, ((PerViewLightingConstantBufferGpu_t._m16._m0[_12609]._m1.xyz - _19630.xyz) / _7648).xyz);
	                float _11076 = ((_17265 * _17265) * (((-2.0) * _17265) + 3.0)) * (1.0 - _17134);
	                float _13713 = _17134 + _11076;
	                vec3 _22473 = _13142 + ((textureLod(samplerCubeArray(g_bindless_TextureCubeArray[PerViewLightingConstantBufferGpu_t._m16._m0[_12609]._m4], undetermined[_Globals_.g_sTrilinearWrap]), vec4(mix(_19630.xyz + (_7648 * abs(min(_11253.x, min(_11253.y, _11253.z)))), _7648, vec3(_17751)).xyz, float(PerViewLightingConstantBufferGpu_t._m16._m0[_12609]._m2)), _12853).xyz * PerViewLightingConstantBufferGpu_t._m16._m0[_12609]._m6) * _11076);
	                vec4 _17103 = _16308 + (PerViewLightingConstantBufferGpu_t._m16._m0[_12609]._m7 * _11076);
	                if (_13713 > 0.9900000095367431640625)
	                {
	                    _13144 = _17103;
	                    _16309 = _13713;
	                    _14891 = _22473;
	                    _18379 = true;
	                    _7956_ladder_break = true;
	                    break;
	                }
	                _13143 = _22473;
	                _16381 = _17103;
	                _16479 = _13713;
	                break;
	            } while(false);
	            if (_7956_ladder_break)
	            {
	                break;
	            }
	            _13142 = _13143;
	            _16308 = _16381;
	            _17134 = _16479;
	            _17021 = _10154;
	            continue;
	        }
	        _8896 = _17020 + 1u;
	        _13141 = _13144;
	        _16307 = _16309;
	        _17118 = _14891;
	        _17133 = _18379;
	        _17020 = _8896;
	        continue;
	    }
	    vec3 _20869 = _19257.xyz;
	    float _20784 = max(0.0, dot(_20869, _6520));
	    vec4 _11487 = textureLod(sampler2DArray(undetermined_unexpectedTypeId470_1782[PerViewConstantBufferCsgo_t._m5], undetermined[_Globals_.g_sBilinearClamp]), vec3((vec2(_17751, sqrt(1.0 - _20784)) * 0.984375) + vec2(0.0078125), 1.0).xyz, 0.0);
	    vec3 _18985 = mix(_11487.xxx, _11487.yyy, _16306);
	    float _10020;
	    vec3 _23440;
	    if (_14875)
	    {
	        float _7173 = dot(normalize(_6520 + _20869).xyz, _6520);
	        float _22187 = max(_22046, 9.9999997473787516355514526367188e-06);
	        float _21363 = saturate(_20784 + 0.001000000047497451305389404296875);
	        _10020 = 1.0 - _17117;
	        _23440 = mix(_18985, _16306 * (((((2.0 + (1.0 / _22187)) * pow(1.0 - (_7173 * _7173), 0.5 / _22187)) * 0.159154832363128662109375) * (0.25 / ((1.0 + _21363) - _21363))) * 3.1415927410125732421875), vec3(_17117));
	    }
	    else
	    {
	        _10020 = 1.0;
	        _23440 = _18985;
	    }
	    float _8840 = 1.0 - _11487.y;
	    vec3 _15517 = _16306 + ((vec3(1.0) - _16306) * vec3(0.0476190485060214996337890625));
	    vec3 _20883 = ((_23440 * _15517) / (vec3(1.0) - (_15517 * _8840))) * _8840;
	    vec3 _13436 = vec3(_17476 * _21713).xyz;
	    vec3 _22686 = (_13139.xyz + ((_18708 * mix(vec3(1.0), vec3(1.0) - (_23440 + _20883), vec3(_10020))).xyz * vec3(_21713 * _17476).xyz).xyz) * _13137.xyz;
	    float _12931 = _22686.x;
	    vec4 _11203 = vec4(_12931, _22686.yz, input_4.w);
	    _11203.x = _12931;
	    _11203.y = _22686.y;
	    _11203.z = _22686.z;
	    vec3 _15752 = _11203.xyz + ((_16324 * _10288).xyz * _13436).xyz;
	    vec4 _20493 = _11203;
	    _20493.x = _15752.x;
	    _20493.y = _15752.y;
	    _20493.z = _15752.z;
	    vec3 _15733 = _20493.xyz + ((((_17118 / vec3(_16307)).xyz * min(dot(_18708.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125)) / dot(vec4(_19081, 1.0), (_13141 / vec4(_16307)).xyzw), max((_17751 * PerViewLightingConstantBufferGpu_t._m4.x) + PerViewLightingConstantBufferGpu_t._m4.y, 1.0))).xyz * (_23440 + (_20883 * _10020))).xyz * _13436).xyz;
	    vec4 _13888 = _20493;
	    _13888.x = _15733.x;
	    _13888.y = _15733.y;
	    _13888.z = _15733.z;
	    vec4 _12894;
	    if (_Globals_.g_bFogEnabled != 0)
	    {
	        vec3 _21493;
	        vec3 _23187 = _11901 - PerViewConstantBuffer_t._m6.xyz;
	        vec3 _9057 = _23187.xyz;
	        vec3 _19340;
	        do
	        {
	            _21493 = _23187.xyz;
	            bool _12892;
	            if (dot(_21493, _21493) > PerViewConstantBufferCsgo_t._m21.x)
	            {
	                _12892 = (_10061.z * PerViewConstantBufferCsgo_t._m21.z) < PerViewConstantBufferCsgo_t._m21.y;
	            }
	            else
	            {
	                _12892 = false;
	            }
	            if (_12892)
	            {
	                float _16579 = length(_21493);
	                vec2 _9342 = clamp(PerViewConstantBufferCsgo_t._m18.xy + (PerViewConstantBufferCsgo_t._m18.zw * vec2(mix(_16579, _16579 * PerViewConstantBufferCsgo_t._m31.y, _Globals_.g_flFogModificationAmount), _10061.z)), vec2(0.0), vec2(1.0));
	                float _13533 = (pow(_9342.x, PerViewConstantBufferCsgo_t._m19.x) * pow(_9342.y, PerViewConstantBufferCsgo_t._m19.y)) * PerViewConstantBufferCsgo_t._m20.w;
	                float _12715 = mix(_13533, _13533 * PerViewConstantBufferCsgo_t._m31.z, _Globals_.g_flFogModificationAmount);
	                _19340 = mix(_13888.xyz, vec4(PerViewConstantBufferCsgo_t._m20.xyz, _12715).xyz, vec3(_12715));
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
	            bool _12893;
	            if (dot(_9057, _9057) > PerViewConstantBufferCsgo_t._m25.x)
	            {
	                _12893 = (PerViewConstantBufferCsgo_t._m25.z * _10061.z) < PerViewConstantBufferCsgo_t._m25.y;
	            }
	            else
	            {
	                _12893 = false;
	            }
	            if (_12893)
	            {
	                float _16580 = length(_21493);
	                float _14602 = clamp(pow(max(0.0, (mix(_16580, _16580 * PerViewConstantBufferCsgo_t._m31.y, _Globals_.g_flFogModificationAmount) * PerViewConstantBufferCsgo_t._m22.y) + PerViewConstantBufferCsgo_t._m22.x), PerViewConstantBufferCsgo_t._m22.w), 0.0, 1.0) * clamp(pow(max(0.0, (_10061.z * PerViewConstantBufferCsgo_t._m23.y) + PerViewConstantBufferCsgo_t._m23.x), PerViewConstantBufferCsgo_t._m23.z), 0.0, 1.0);
	                float _16973 = saturate(_14602) * mix(PerViewConstantBufferCsgo_t._m25.w, PerViewConstantBufferCsgo_t._m25.w * PerViewConstantBufferCsgo_t._m31.z, _Globals_.g_flFogModificationAmount);
	                _19341 = mix(_23944.xyz, vec4((textureLod(samplerCube(g_bindless_TextureCube_float4[PerViewConstantBufferCsgo_t._m6], undetermined[_Globals_.g_sTrilinearClamp]), normalize((mat4(vec4(PerViewConstantBufferCsgo_t._m24._m0[0].x, PerViewConstantBufferCsgo_t._m24._m0[1].x, PerViewConstantBufferCsgo_t._m24._m0[2].x, PerViewConstantBufferCsgo_t._m24._m0[3].x), vec4(PerViewConstantBufferCsgo_t._m24._m0[0].y, PerViewConstantBufferCsgo_t._m24._m0[1].y, PerViewConstantBufferCsgo_t._m24._m0[2].y, PerViewConstantBufferCsgo_t._m24._m0[3].y), vec4(PerViewConstantBufferCsgo_t._m24._m0[0].z, PerViewConstantBufferCsgo_t._m24._m0[1].z, PerViewConstantBufferCsgo_t._m24._m0[2].z, PerViewConstantBufferCsgo_t._m24._m0[3].z), vec4(PerViewConstantBufferCsgo_t._m24._m0[0].w, PerViewConstantBufferCsgo_t._m24._m0[1].w, PerViewConstantBufferCsgo_t._m24._m0[2].w, PerViewConstantBufferCsgo_t._m24._m0[3].w)) * vec4(_9057, 0.0)).xyz).xyz, PerViewConstantBufferCsgo_t._m23.w * clamp(1.0 - (_14602 * PerViewConstantBufferCsgo_t._m22.z), 0.0, 1.0)) * PerViewConstantBufferCsgo_t._m26.x).xyz, _16973).xyz, vec3(_16973));
	                break;
	            }
	            _19341 = _23944.xyz;
	            break;
	        } while(false);
	        _23944.x = _19341.x;
	        _23944.y = _19341.y;
	        _23944.z = _19341.z;
	        _12894 = _23944;
	    }
	    else
	    {
	        _12894 = _13888;
	    }
	    bool _12895;
	    if (_10513)
	    {
	        _12895 = _22671 > 400.0;
	    }
	    else
	    {
	        _12895 = false;
	    }
	    vec4 _23728;
	    if (_12895)
	    {
	        float _6967 = dot(_Globals_.g_vAvgAlbedo.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125));
	        bool _14878 = _Globals_.g_bDistanceContrastAdjustment != 0;
	        float _14796;
	        if (_14878)
	        {
	            _14796 = max(_Globals_.g_fDistanceContrastExposure, _6967);
	        }
	        else
	        {
	            _14796 = _6967;
	        }
	        float _9018 = max(_14796, 0.001000000047497451305389404296875);
	        vec3 _3295 = _Globals_.g_vAvgAlbedo.xyz / vec3(_9018);
	        float _8491 = _3295.x;
	        float _7521 = _3295.y;
	        float _6866 = _3295.z;
	        float _19392 = max(max(_8491, _7521), _6866);
	        float _8757 = min(min(_8491, _7521), _6866);
	        vec3 _10021;
	        vec4 _22452;
	        if (_11913)
	        {
	            float _9643 = dot(vec4(((_11901 + PerViewConstantBuffer_t._m5.xyz) + ((-PerViewConstantBuffer_t._m7) * PerViewConstantBufferCsgo_t._m29)).xyz, 1.0), vec4(PerViewConstantBuffer_t._m7.xyz, dot((PerViewConstantBuffer_t._m5.xyz + PerViewConstantBuffer_t._m6.xyz).xyz + (PerViewConstantBuffer_t._m7.xyz * PerViewConstantBuffer_t._m4), PerViewConstantBuffer_t._m7.xyz)));
	            vec3 _21719;
	            if (_9643 <= 0.0)
	            {
	                _21719 = _10061;
	            }
	            else
	            {
	                _21719 = _11901 + ((-PerViewConstantBuffer_t._m7.xyz) * _9643);
	            }
	            vec4 _19976 = vec4(_21719.xyz, 1.0) * mat4(vec4(PerViewConstantBufferCsgo_t._m15._m0[0].x, PerViewConstantBufferCsgo_t._m15._m0[1].x, PerViewConstantBufferCsgo_t._m15._m0[2].x, PerViewConstantBufferCsgo_t._m15._m0[3].x), vec4(PerViewConstantBufferCsgo_t._m15._m0[0].y, PerViewConstantBufferCsgo_t._m15._m0[1].y, PerViewConstantBufferCsgo_t._m15._m0[2].y, PerViewConstantBufferCsgo_t._m15._m0[3].y), vec4(PerViewConstantBufferCsgo_t._m15._m0[0].z, PerViewConstantBufferCsgo_t._m15._m0[1].z, PerViewConstantBufferCsgo_t._m15._m0[2].z, PerViewConstantBufferCsgo_t._m15._m0[3].z), vec4(PerViewConstantBufferCsgo_t._m15._m0[0].w, PerViewConstantBufferCsgo_t._m15._m0[1].w, PerViewConstantBufferCsgo_t._m15._m0[2].w, PerViewConstantBufferCsgo_t._m15._m0[3].w));
	            float _20178 = _19976.w;
	            vec2 _11416 = _19976.xy / vec2(_20178);
	            vec4 _6653;
	            _6653.x = clamp(((_11416.x + 1.0) * PerViewConstantBuffer_t._m2.x) * 0.5, 0.0, PerViewConstantBuffer_t._m2.x - 1.0);
	            _6653.y = clamp(((1.0 - _11416.y) * PerViewConstantBuffer_t._m2.y) * 0.5, 0.0, PerViewConstantBuffer_t._m2.y - 1.0);
	            _6653.w = _20178;
	            _10021 = _21719;
	            _22452 = _6653;
	        }
	        else
	        {
	            _10021 = _11901;
	            _22452 = _11408.xyzw;
	        }
	        uvec2 _6815 = uvec2(_22452.xy - PerViewConstantBuffer_t._m1.xy) >> _7663;
	        uint _19949 = PerViewLightingConstantBufferGpu_t._m12.y + (((_6815.y * PerViewLightingConstantBufferGpu_t._m13.y) + _6815.x) * PerViewLightingConstantBufferGpu_t._m12.z);
	        uint _23395 = PerViewLightingConstantBufferGpu_t._m12.x + (uint(clamp(_22452.w * PerViewLightingConstantBufferGpu_t._m14.x, 0.0, PerViewLightingConstantBufferGpu_t._m14.y)) * PerViewLightingConstantBufferGpu_t._m12.z);
	        vec3 _13145;
	        float _16310;
	        _13145 = vec3(0.0);
	        _16310 = 0.0;
	        uint _8897;
	        vec3 _13147;
	        float _14082;
	        bool _18380;
	        uint _17022 = 0u;
	        bool _17135 = false;
	        for (;;)
	        {
	            bool _12896;
	            if (_17022 < PerViewLightingConstantBufferGpu_t._m12.z)
	            {
	                _12896 = !_17135;
	            }
	            else
	            {
	                _12896 = false;
	            }
	            if (!_12896)
	            {
	                break;
	            }
	            uint _14477 = subgroupOr(g_CullBits_1._m0[_19949 + _17022] & g_CullBits_1._m0[_23395 + _17022]);
	            vec3 _13146;
	            _13146 = _13145;
	            uint _10155;
	            vec3 _13213;
	            float _15671;
	            float _16326 = _16310;
	            uint _17023 = _14477;
	            for (;;)
	            {
	                bool _7957_ladder_break = false;
	                do
	                {
	                    if (!(_17023 != 0u))
	                    {
	                        _13147 = _13146;
	                        _14082 = _16326;
	                        _18380 = _17135;
	                        _7957_ladder_break = true;
	                        break;
	                    }
	                    int _12610 = int(uint(findLSB(_17023)) + (_17022 * 32u));
	                    _10155 = _17023 & (_17023 - 1u);
	                    vec4 _19087 = vec4(_10021.xyz, 1.0);
	                    vec3 _21110 = (mat4x3(vec3(PerViewLightingConstantBufferGpu_t._m17._m0[_12610]._m0._m0[0].x, PerViewLightingConstantBufferGpu_t._m17._m0[_12610]._m0._m0[1].x, PerViewLightingConstantBufferGpu_t._m17._m0[_12610]._m0._m0[2].x), vec3(PerViewLightingConstantBufferGpu_t._m17._m0[_12610]._m0._m0[0].y, PerViewLightingConstantBufferGpu_t._m17._m0[_12610]._m0._m0[1].y, PerViewLightingConstantBufferGpu_t._m17._m0[_12610]._m0._m0[2].y), vec3(PerViewLightingConstantBufferGpu_t._m17._m0[_12610]._m0._m0[0].z, PerViewLightingConstantBufferGpu_t._m17._m0[_12610]._m0._m0[1].z, PerViewLightingConstantBufferGpu_t._m17._m0[_12610]._m0._m0[2].z), vec3(PerViewLightingConstantBufferGpu_t._m17._m0[_12610]._m0._m0[0].w, PerViewLightingConstantBufferGpu_t._m17._m0[_12610]._m0._m0[1].w, PerViewLightingConstantBufferGpu_t._m17._m0[_12610]._m0._m0[2].w)) * _19087).xyz;
	                    vec3 _7191 = clamp((_21110 - PerViewLightingConstantBufferGpu_t._m17._m0[_12610]._m1.xyz) * PerViewLightingConstantBufferGpu_t._m17._m0[_12610]._m3, vec3(0.0), vec3(1.0));
	                    vec3 _19652 = clamp((PerViewLightingConstantBufferGpu_t._m17._m0[_12610]._m2.xyz - _21110) * PerViewLightingConstantBufferGpu_t._m17._m0[_12610]._m3, vec3(0.0), vec3(1.0));
	                    float _17266 = min(min(_7191.x, min(_7191.y, _7191.z)), min(_19652.x, min(_19652.y, _19652.z)));
	                    if (_17266 == 0.0)
	                    {
	                        _13213 = _13146;
	                        _15671 = _16326;
	                        break;
	                    }
	                    float _9614 = ((_17266 * _17266) * (((-2.0) * _17266) + 3.0)) * (1.0 - _16326);
	                    float _6671 = _16326 + _9614;
	                    uint _19926 = uint(int(PerViewLightingConstantBufferGpu_t._m17._m0[_12610]._m4));
	                    vec3 _24893 = mat4x3(vec3(PerViewLightProbeVolumeConstantBuffer_t._m0._m0[_19926]._m0._m0[0].x, PerViewLightProbeVolumeConstantBuffer_t._m0._m0[_19926]._m0._m0[1].x, PerViewLightProbeVolumeConstantBuffer_t._m0._m0[_19926]._m0._m0[2].x), vec3(PerViewLightProbeVolumeConstantBuffer_t._m0._m0[_19926]._m0._m0[0].y, PerViewLightProbeVolumeConstantBuffer_t._m0._m0[_19926]._m0._m0[1].y, PerViewLightProbeVolumeConstantBuffer_t._m0._m0[_19926]._m0._m0[2].y), vec3(PerViewLightProbeVolumeConstantBuffer_t._m0._m0[_19926]._m0._m0[0].z, PerViewLightProbeVolumeConstantBuffer_t._m0._m0[_19926]._m0._m0[1].z, PerViewLightProbeVolumeConstantBuffer_t._m0._m0[_19926]._m0._m0[2].z), vec3(PerViewLightProbeVolumeConstantBuffer_t._m0._m0[_19926]._m0._m0[0].w, PerViewLightProbeVolumeConstantBuffer_t._m0._m0[_19926]._m0._m0[1].w, PerViewLightProbeVolumeConstantBuffer_t._m0._m0[_19926]._m0._m0[2].w)) * _19087;
	                    vec3 _6343 = _24893.xyz;
	                    _6343.z = _24893.z * 0.16666667163372039794921875;
	                    vec3 _12209 = clamp(_6343.xyz, PerViewLightProbeVolumeConstantBuffer_t._m0._m0[_19926]._m1, PerViewLightProbeVolumeConstantBuffer_t._m0._m0[_19926]._m2);
	                    _12209.z = _12209.z * 6.0;
	                    vec3 _21530 = (_12209.xyz * PerViewLightProbeVolumeConstantBuffer_t._m0._m0[_19926]._m5).xyz + PerViewLightProbeVolumeConstantBuffer_t._m0._m0[_19926]._m6;
	                    _21530.z = _21530.z * 0.16666667163372039794921875;
	                    vec3 _17331 = _10145.xyz;
	                    vec3 _15715 = mix(vec3(0.0, 0.16666667163372039794921875, 0.3333333432674407958984375), vec3(0.5, 0.666666686534881591796875, 0.833333313465118408203125), step(_17331, vec3(0.0)).xyz);
	                    vec3 _19678 = _17331 * _17331;
	                    vec3 _13872 = _13146 + (((((textureLod(sampler3D(g_bindless_Texture3D_float4[PerViewLightProbeVolumeConstantBuffer_t._m0._m0[_19926]._m3], undetermined[_Globals_.g_sBilinearClamp]), _21530.xyz + vec3(0.0, 0.0, _15715.x), 0.0).xyz * _19678.x) + (textureLod(sampler3D(g_bindless_Texture3D_float4[PerViewLightProbeVolumeConstantBuffer_t._m0._m0[_19926]._m3], undetermined[_Globals_.g_sBilinearClamp]), _21530.xyz + vec3(0.0, 0.0, _15715.y), 0.0).xyz * _19678.y)) + (textureLod(sampler3D(g_bindless_Texture3D_float4[PerViewLightProbeVolumeConstantBuffer_t._m0._m0[_19926]._m3], undetermined[_Globals_.g_sBilinearClamp]), _21530.xyz + vec3(0.0, 0.0, _15715.z), 0.0).xyz * _19678.z)).xyz * PerViewLightProbeVolumeConstantBuffer_t._m0._m0[_19926]._m4.xyz) * _9614);
	                    if (_6671 > 0.9900000095367431640625)
	                    {
	                        _13147 = _13872;
	                        _14082 = _6671;
	                        _18380 = true;
	                        _7957_ladder_break = true;
	                        break;
	                    }
	                    _13213 = _13872;
	                    _15671 = _6671;
	                    break;
	                } while(false);
	                if (_7957_ladder_break)
	                {
	                    break;
	                }
	                _13146 = _13213;
	                _16326 = _15671;
	                _17023 = _10155;
	                continue;
	            }
	            _8897 = _17022 + 1u;
	            _13145 = _13147;
	            _16310 = _14082;
	            _17135 = _18380;
	            _17022 = _8897;
	            continue;
	        }
	        vec3 _20940;
	        if (_16310 < 0.9900000095367431640625)
	        {
	            vec4 _16034 = vec4(_10145.xyz, 1.0);
	            _20940 = _13145 + (vec3(dot(PerViewLightingConstantBufferGpu_t._m5._m0[0].xyzw, _16034), dot(PerViewLightingConstantBufferGpu_t._m5._m0[1].xyzw, _16034), dot(PerViewLightingConstantBufferGpu_t._m5._m0[2].xyzw, _16034)) * (1.0 - _16310));
	        }
	        else
	        {
	            _20940 = _13145;
	        }
	        vec3 _16025 = -_12148;
	        vec3 _10022;
	        vec4 _22485;
	        if (_11913)
	        {
	            float _9644 = dot(vec4(((_11901 + PerViewConstantBuffer_t._m5.xyz) + ((-PerViewConstantBuffer_t._m7) * PerViewConstantBufferCsgo_t._m29)).xyz, 1.0), vec4(PerViewConstantBuffer_t._m7.xyz, dot((PerViewConstantBuffer_t._m5.xyz + PerViewConstantBuffer_t._m6.xyz).xyz + (PerViewConstantBuffer_t._m7.xyz * PerViewConstantBuffer_t._m4), PerViewConstantBuffer_t._m7.xyz)));
	            vec3 _21720;
	            if (_9644 <= 0.0)
	            {
	                _21720 = _10061;
	            }
	            else
	            {
	                _21720 = _11901 + ((-PerViewConstantBuffer_t._m7.xyz) * _9644);
	            }
	            vec4 _19977 = vec4(_21720.xyz, 1.0) * mat4(vec4(PerViewConstantBufferCsgo_t._m15._m0[0].x, PerViewConstantBufferCsgo_t._m15._m0[1].x, PerViewConstantBufferCsgo_t._m15._m0[2].x, PerViewConstantBufferCsgo_t._m15._m0[3].x), vec4(PerViewConstantBufferCsgo_t._m15._m0[0].y, PerViewConstantBufferCsgo_t._m15._m0[1].y, PerViewConstantBufferCsgo_t._m15._m0[2].y, PerViewConstantBufferCsgo_t._m15._m0[3].y), vec4(PerViewConstantBufferCsgo_t._m15._m0[0].z, PerViewConstantBufferCsgo_t._m15._m0[1].z, PerViewConstantBufferCsgo_t._m15._m0[2].z, PerViewConstantBufferCsgo_t._m15._m0[3].z), vec4(PerViewConstantBufferCsgo_t._m15._m0[0].w, PerViewConstantBufferCsgo_t._m15._m0[1].w, PerViewConstantBufferCsgo_t._m15._m0[2].w, PerViewConstantBufferCsgo_t._m15._m0[3].w));
	            float _20179 = _19977.w;
	            vec2 _11418 = _19977.xy / vec2(_20179);
	            vec4 _6654;
	            _6654.x = clamp(((_11418.x + 1.0) * PerViewConstantBuffer_t._m2.x) * 0.5, 0.0, PerViewConstantBuffer_t._m2.x - 1.0);
	            _6654.y = clamp(((1.0 - _11418.y) * PerViewConstantBuffer_t._m2.y) * 0.5, 0.0, PerViewConstantBuffer_t._m2.y - 1.0);
	            _6654.w = _20179;
	            _10022 = _21720;
	            _22485 = _6654;
	        }
	        else
	        {
	            _10022 = _11901;
	            _22485 = _11408.xyzw;
	        }
	        uvec2 _6816 = uvec2(_22485.xy - PerViewConstantBuffer_t._m1.xy) >> _7663;
	        uint _22486 = PerViewLightingConstantBufferGpu_t._m12.y + (((_6816.y * PerViewLightingConstantBufferGpu_t._m13.y) + _6816.x) * PerViewLightingConstantBufferGpu_t._m12.z);
	        uint _7533 = PerViewLightingConstantBufferGpu_t._m12.x + (uint(clamp(_22485.w * PerViewLightingConstantBufferGpu_t._m14.x, 0.0, PerViewLightingConstantBufferGpu_t._m14.y)) * PerViewLightingConstantBufferGpu_t._m12.z);
	        vec3 _13148;
	        float _16312;
	        _13148 = vec3(0.0);
	        _16312 = 0.0;
	        uint _8898;
	        vec3 _13150;
	        float _14083;
	        bool _18382;
	        uint _17024 = 0u;
	        bool _17136 = false;
	        for (;;)
	        {
	            bool _12897;
	            if (_17024 < PerViewLightingConstantBufferGpu_t._m12.z)
	            {
	                _12897 = !_17136;
	            }
	            else
	            {
	                _12897 = false;
	            }
	            if (!_12897)
	            {
	                break;
	            }
	            uint _14478 = subgroupOr(g_CullBits_1._m0[_22486 + _17024] & g_CullBits_1._m0[_7533 + _17024]);
	            vec3 _13149;
	            _13149 = _13148;
	            uint _10156;
	            vec3 _13214;
	            float _15672;
	            float _16327 = _16312;
	            uint _17025 = _14478;
	            for (;;)
	            {
	                bool _7965_ladder_break = false;
	                do
	                {
	                    if (!(_17025 != 0u))
	                    {
	                        _13150 = _13149;
	                        _14083 = _16327;
	                        _18382 = _17136;
	                        _7965_ladder_break = true;
	                        break;
	                    }
	                    int _12611 = int(uint(findLSB(_17025)) + (_17024 * 32u));
	                    _10156 = _17025 & (_17025 - 1u);
	                    vec4 _19088 = vec4(_10022.xyz, 1.0);
	                    vec3 _21111 = (mat4x3(vec3(PerViewLightingConstantBufferGpu_t._m17._m0[_12611]._m0._m0[0].x, PerViewLightingConstantBufferGpu_t._m17._m0[_12611]._m0._m0[1].x, PerViewLightingConstantBufferGpu_t._m17._m0[_12611]._m0._m0[2].x), vec3(PerViewLightingConstantBufferGpu_t._m17._m0[_12611]._m0._m0[0].y, PerViewLightingConstantBufferGpu_t._m17._m0[_12611]._m0._m0[1].y, PerViewLightingConstantBufferGpu_t._m17._m0[_12611]._m0._m0[2].y), vec3(PerViewLightingConstantBufferGpu_t._m17._m0[_12611]._m0._m0[0].z, PerViewLightingConstantBufferGpu_t._m17._m0[_12611]._m0._m0[1].z, PerViewLightingConstantBufferGpu_t._m17._m0[_12611]._m0._m0[2].z), vec3(PerViewLightingConstantBufferGpu_t._m17._m0[_12611]._m0._m0[0].w, PerViewLightingConstantBufferGpu_t._m17._m0[_12611]._m0._m0[1].w, PerViewLightingConstantBufferGpu_t._m17._m0[_12611]._m0._m0[2].w)) * _19088).xyz;
	                    vec3 _7192 = clamp((_21111 - PerViewLightingConstantBufferGpu_t._m17._m0[_12611]._m1.xyz) * PerViewLightingConstantBufferGpu_t._m17._m0[_12611]._m3, vec3(0.0), vec3(1.0));
	                    vec3 _19654 = clamp((PerViewLightingConstantBufferGpu_t._m17._m0[_12611]._m2.xyz - _21111) * PerViewLightingConstantBufferGpu_t._m17._m0[_12611]._m3, vec3(0.0), vec3(1.0));
	                    float _17267 = min(min(_7192.x, min(_7192.y, _7192.z)), min(_19654.x, min(_19654.y, _19654.z)));
	                    if (_17267 == 0.0)
	                    {
	                        _13214 = _13149;
	                        _15672 = _16327;
	                        break;
	                    }
	                    float _9615 = ((_17267 * _17267) * (((-2.0) * _17267) + 3.0)) * (1.0 - _16327);
	                    float _6672 = _16327 + _9615;
	                    uint _19927 = uint(int(PerViewLightingConstantBufferGpu_t._m17._m0[_12611]._m4));
	                    vec3 _24894 = mat4x3(vec3(PerViewLightProbeVolumeConstantBuffer_t._m0._m0[_19927]._m0._m0[0].x, PerViewLightProbeVolumeConstantBuffer_t._m0._m0[_19927]._m0._m0[1].x, PerViewLightProbeVolumeConstantBuffer_t._m0._m0[_19927]._m0._m0[2].x), vec3(PerViewLightProbeVolumeConstantBuffer_t._m0._m0[_19927]._m0._m0[0].y, PerViewLightProbeVolumeConstantBuffer_t._m0._m0[_19927]._m0._m0[1].y, PerViewLightProbeVolumeConstantBuffer_t._m0._m0[_19927]._m0._m0[2].y), vec3(PerViewLightProbeVolumeConstantBuffer_t._m0._m0[_19927]._m0._m0[0].z, PerViewLightProbeVolumeConstantBuffer_t._m0._m0[_19927]._m0._m0[1].z, PerViewLightProbeVolumeConstantBuffer_t._m0._m0[_19927]._m0._m0[2].z), vec3(PerViewLightProbeVolumeConstantBuffer_t._m0._m0[_19927]._m0._m0[0].w, PerViewLightProbeVolumeConstantBuffer_t._m0._m0[_19927]._m0._m0[1].w, PerViewLightProbeVolumeConstantBuffer_t._m0._m0[_19927]._m0._m0[2].w)) * _19088;
	                    vec3 _6345 = _24894.xyz;
	                    _6345.z = _24894.z * 0.16666667163372039794921875;
	                    vec3 _12210 = clamp(_6345.xyz, PerViewLightProbeVolumeConstantBuffer_t._m0._m0[_19927]._m1, PerViewLightProbeVolumeConstantBuffer_t._m0._m0[_19927]._m2);
	                    _12210.z = _12210.z * 6.0;
	                    vec3 _21531 = (_12210.xyz * PerViewLightProbeVolumeConstantBuffer_t._m0._m0[_19927]._m5).xyz + PerViewLightProbeVolumeConstantBuffer_t._m0._m0[_19927]._m6;
	                    _21531.z = _21531.z * 0.16666667163372039794921875;
	                    vec3 _17332 = _16025.xyz;
	                    vec3 _15717 = mix(vec3(0.0, 0.16666667163372039794921875, 0.3333333432674407958984375), vec3(0.5, 0.666666686534881591796875, 0.833333313465118408203125), step(_17332, vec3(0.0)).xyz);
	                    vec3 _19679 = _17332 * _17332;
	                    vec3 _13873 = _13149 + (((((textureLod(sampler3D(g_bindless_Texture3D_float4[PerViewLightProbeVolumeConstantBuffer_t._m0._m0[_19927]._m3], undetermined[_Globals_.g_sBilinearClamp]), _21531.xyz + vec3(0.0, 0.0, _15717.x), 0.0).xyz * _19679.x) + (textureLod(sampler3D(g_bindless_Texture3D_float4[PerViewLightProbeVolumeConstantBuffer_t._m0._m0[_19927]._m3], undetermined[_Globals_.g_sBilinearClamp]), _21531.xyz + vec3(0.0, 0.0, _15717.y), 0.0).xyz * _19679.y)) + (textureLod(sampler3D(g_bindless_Texture3D_float4[PerViewLightProbeVolumeConstantBuffer_t._m0._m0[_19927]._m3], undetermined[_Globals_.g_sBilinearClamp]), _21531.xyz + vec3(0.0, 0.0, _15717.z), 0.0).xyz * _19679.z)).xyz * PerViewLightProbeVolumeConstantBuffer_t._m0._m0[_19927]._m4.xyz) * _9615);
	                    if (_6672 > 0.9900000095367431640625)
	                    {
	                        _13150 = _13873;
	                        _14083 = _6672;
	                        _18382 = true;
	                        _7965_ladder_break = true;
	                        break;
	                    }
	                    _13214 = _13873;
	                    _15672 = _6672;
	                    break;
	                } while(false);
	                if (_7965_ladder_break)
	                {
	                    break;
	                }
	                _13149 = _13214;
	                _16327 = _15672;
	                _17025 = _10156;
	                continue;
	            }
	            _8898 = _17024 + 1u;
	            _13148 = _13150;
	            _16312 = _14083;
	            _17136 = _18382;
	            _17024 = _8898;
	            continue;
	        }
	        vec3 _20941;
	        if (_16312 < 0.9900000095367431640625)
	        {
	            vec4 _16035 = vec4(_16025.xyz, 1.0);
	            _20941 = _13148 + (vec3(dot(PerViewLightingConstantBufferGpu_t._m5._m0[0].xyzw, _16035), dot(PerViewLightingConstantBufferGpu_t._m5._m0[1].xyzw, _16035), dot(PerViewLightingConstantBufferGpu_t._m5._m0[2].xyzw, _16035)) * (1.0 - _16312));
	        }
	        else
	        {
	            _20941 = _13148;
	        }
	        float _18268 = dot(_17115.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125));
	        float _9680;
	        if (_14878)
	        {
	            _9680 = _Globals_.g_fDistanceContrastExposure;
	        }
	        else
	        {
	            _9680 = 1.0;
	        }
	        vec3 _10929 = mix(_12894.xyz, min(vec3(1.0), (_12894.xyz * (((smoothstep(0.0, _9018, _18268) * 0.5) + (smoothstep(_9018, _9018 + 0.1500000059604644775390625, _18268) * 0.5)) * (2.0 + (smoothstep(0.5, 0.0, abs((clamp(dot(_20941.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125)), 0.0, 1.0) * _9018) - clamp(dot(_20940.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125)), 0.0, 1.0))) * 2.0)))) * mix(_3295, vec3(1.0), vec3(smoothstep(0.449999988079071044921875, 0.550000011920928955078125, (_19392 - _8757) / (_19392 + _8757))))) + (max(vec3(0.0), _12894.xyz - vec3(1.0)) * _9680), vec3((min(0.800000011920928955078125, PerViewConstantBufferCsgo_t._m31.x) * smoothstep(400.0, 1400.0, _22671)) * _Globals_.g_flFogModificationAmount));
	        vec4 _17842 = _12894;
	        _17842.x = _10929.x;
	        _17842.y = _10929.y;
	        _17842.z = _10929.z;
	        _23728 = _17842;
	    }
	    else
	    {
	        _23728 = _12894;
	    }
	    if (input_4.w < 1.0)
	    {
	        if ((fma(input_4.w, 2.0, -1.5) + texelFetch(g_bindless_Texture2D_float4[PerViewConstantBufferCsgo_t._m4], ivec3(ivec2(_11408.xy) & PerViewConstantBufferCsgo_t._m14, 0).xy, 0).y) < 0.0)
	        {
	            discard;
	        }
	    }
	    vec3 _19342;
	    if (_Globals_.g_flSpawnInvulnerability > 0.0)
	    {
	        float _11148 = 1.0 - clamp(dot(_19257, _24735), 0.0, 1.0);
	        _19342 = mix(_23728.xyz, _Globals_.g_cInvulnerabilityColor * (mix(dot(_23728.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125)), 0.5, 0.5) + (4.0 * pow(mix(_11148 * texelFetch(g_bindless_Texture2D_float4[PerViewConstantBufferCsgo_t._m4], ivec3(ivec2(_11408.xy) & PerViewConstantBufferCsgo_t._m14, 0).xy, 0).y, 1.0, _11148), mix(3.0, 6.0, 1.0 + (sin(PerViewConstantBuffer_t._m0 * 20.0) * 0.5))))), vec3(_Globals_.g_flSpawnInvulnerability));
	    }
	    else
	    {
	        _19342 = _23728.xyz;
	    }
	    vec4 _23946 = _23728;
	    _23946.x = _19342.x;
	    _23946.y = _19342.y;
	    _23946.z = _19342.z;
	    output_0 = _23946;
	}
	
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
	
	BoolAttribute(BindlessResources, true);
	BoolAttribute(environmentmapped, true);
	BoolAttribute(environmentmappeddynamic, true);
	BoolAttribute(NeedsLightProbe, true);
	BoolAttribute(DoNotCastShadows, F_DO_NOT_CAST_SHADOWS || 0);
	BoolAttribute(SupportsMappingDimensions, true);
	TextureAttribute(LightSim_DiffuseAlbedoTexture, g_tColor);
	TextureAttribute(RepresentativeTexture, g_tColor);
	BoolAttribute(renderbackfaces, F_RENDER_BACKFACES || 0);
	BoolAttribute(SupportsLightmapping, true);
	BoolAttribute(PerVertexLighting, true);
	
	#if (S_TINT_MASK == 0)
		BoolAttribute(SupportsDecals, true);
	#endif
	#if (S_MODE_DEPTH == 1)
		BoolAttribute(translucent, true);
		BoolAttribute(NoZPrepass, F_DISABLE_Z_PREPASS || 0);
	#endif
	#if (S_DECAL_TEXTURE == 0)
		BoolAttribute(SupportsDecals, true);
	#endif
	#if (S_ENABLE_ADJUSTMENTS == 0)
		BoolAttribute(SupportsDecals, true);
	#endif
	#if (S_ALPHA_TEST == 1)
		BoolAttribute(alphatest, true);
		FloatAttribute(_dummyReferenceAlphaTestReferenceInMainShader, g_flAlphaTestReference);
		FloatAttribute(_dummyReferenceAntiAliasedEdgeStrengthReferenceInMainShader, g_flAntiAliasedEdgeStrength);
		BoolAttribute(NoZPrepass, true);
	#endif
	#if (S_ALPHA_TEST == 0)
		BoolAttribute(NoZPrepass, F_DISABLE_Z_PREPASS || 0);
	#endif
	#if (S_SUPPORTS_DECALS == 1)
		BoolAttribute(SupportsDecals, true);
	#endif
	#if (S_TINT_MASK == 1)
		TextureAttribute(LightSim_TintMaskTextureR, g_tTintMask);
	#endif
	#if (S_TRANSLUCENT == 1)
		BoolAttribute(translucent, true);
		BoolAttribute(NoZPrepass, F_DISABLE_Z_PREPASS || 0);
	#endif
	#if (S_EYEBALLS == 0)
		BoolAttribute(SupportsDecals, true);
	#endif
	#if (S_TRANSLUCENT == 0)
		BoolAttribute(SupportsDecals, true);
	#endif
	#if (S_ENABLE_ADJUSTMENTS == 1)
		BoolAttribute(translucent, true);
		BoolAttribute(NoZPrepass, F_DISABLE_Z_PREPASS || 0);
	#endif
	#if (S_EYEBALLS == 1)
		IntAttribute(MaterialLayerCount, 1);
		StringAttribute(MaterialLayerRefType, csgo_eyeball);
		BoolAttribute(NoZPrepass, F_DISABLE_Z_PREPASS || 0);
	#endif
	#if (S_DECAL_TEXTURE == 1)
		TextureAttribute(LightSim_TintMaskTextureR, g_tTintMask);
	#endif
	#if (S_SUPPORTS_DECALS == 0)
		TextureAttribute(LightSim_TintMaskTextureR, g_tTintMask);
	#endif
	#if (S_ADDITIVE_BLEND == 1)
		BoolAttribute(translucent, true);
		BoolAttribute(NoZPrepass, F_DISABLE_Z_PREPASS || 0);
	#endif
	#if (S_ADDITIVE_BLEND == 0)
		BoolAttribute(SupportsDecals, true);
	#endif
	#if (S_MODE_DEPTH == 0)
		BoolAttribute(SupportsDecals, true);
	#endif
	
	// PSRS
	
	RenderState(BackStencilFunc, F_RENDER_BACKFACES ? 5 : 7);
	RenderState(BlendEnable, True);
	RenderState(BlendEnable0, True);
	RenderState(BlendEnable1, True);
	RenderState(BlendEnable2, True);
	RenderState(CullMode, F_RENDER_BACKFACES ? None : Front);
	RenderState(CullMode, F_RENDER_BACKFACES ? None : Back);
	RenderState(DepthEnable, F_DISABLE_Z_BUFFERING ? False : True);
	RenderState(DepthWriteEnable, False);
	RenderState(DepthWriteEnable, F_DISABLE_Z_BUFFERING ? False : True);
	RenderState(DstBlend, F_ADDITIVE_BLEND ? One : InvSrcAlpha);
	RenderState(DstBlend0, One);
	RenderState(DstBlend1, One);
	RenderState(DstBlend2, One);
	RenderState(DstBlendAlpha0, One);
	RenderState(DstBlendAlpha1, One);
	RenderState(DstBlendAlpha2, One);
	RenderState(SlopeScaleDepthBias, 0);
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
	
	
	BoolAttribute(BindlessResources, true);
	
	#if (S_EYEBALLS == 1)
		IntAttribute(MaterialLayerCount, 1);
		StringAttribute(MaterialLayerRefType, csgo_eyeball);
	#endif
	#if (S_ALPHA_TEST == 0)
		IntAttribute(MaterialLayerCount, 1);
		StringAttribute(MaterialLayerRefType, csgo_eyeball);
	#endif
	#if (S_TRANSLUCENT == 0)
		IntAttribute(MaterialLayerCount, 1);
		StringAttribute(MaterialLayerRefType, csgo_eyeball);
	#endif
}
