//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "Foliage Shader";
	DevShader = false;
	Version = 9;
	
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
	ToolsShadingComplexity(S_MODE_TOOLS_SHADING_COMPLEXITY);
}

FEATURES
{
	Feature( F_DO_NOT_CAST_SHADOWS, 0..1, "Shadows" );
	Feature( F_RENDER_BACKFACES, 0..1, "2-Sided Rendering" );
	Feature( F_DONT_FLIP_BACKFACE_NORMALS, 0..1, "2-Sided Rendering" );
	Feature( F_DISABLE_Z_BUFFERING, 0..1, "Z-Buffering" );
	Feature( F_DISABLE_Z_PREPASS, 0..1, "Z-Prepass" );
	Feature( F_ALPHA_TEST, 0..1, "Translucent" );
	Feature( F_TINT_MASK, 0..1, "Per-Instance Tint Mask" );
	Feature( F_VERTEX_ANIMATION, 0..2 (0="None", 1="Simple", 2="Advanced"), "Vertex Animation" );
	Feature( F_FOLIAGE_ANIMATION, 0..1, "Foliage Animation" );
	Feature( F_FOLIAGE_UV_ANIMATION, 0..1, "Foliage Animation" );
	Feature( F_TRANSMISSIVE_BACKFACE_NDOTL, 0..1, "PBR" );
	Feature( F_USE_ALBEDO_FOR_TRANSMISSIVE, 0..1, "PBR" );
	Feature( F_DISABLE_TRANSMISSIVE_SHADOWS, 0..1, "PBR" );
	Feature( F_ANIMATED_SHADOWS, 0..1, "Shadows" );
	FeatureRule( Requires( F_DONT_FLIP_BACKFACE_NORMALS, F_RENDER_BACKFACES ), "Only applies to backfaces" );
	FeatureRule( Requires( F_FOLIAGE_UV_ANIMATION, F_ALPHA_TEST ), "Foliage UV Animation requires alpha test" );
	FeatureRule( ChildOf( F_USE_ALBEDO_FOR_TRANSMISSIVE, F_TRANSMISSIVE_BACKFACE_NDOTL ), "Use Albedo for Transmissive requires Transmissive Backface Ndotl" );
	FeatureRule( ChildOf( F_DISABLE_TRANSMISSIVE_SHADOWS, F_TRANSMISSIVE_BACKFACE_NDOTL ), "Disable Transmissive Shadows requires Transmissive Backface Ndotl" );
	FeatureRule( Allow1( F_FOLIAGE_ANIMATION, F_VERTEX_ANIMATION ), "Foliage Animation and Vertex Animation are not compatible" );
	FeatureRule( Requires( F_ANIMATED_SHADOWS, F_VERTEX_ANIMATION, F_DO_NOT_CAST_SHADOWS=0 ), "Fully Animated shadows requires vertex animation and shadows" );
}

COMMON
{
	#include "system.fxc"
}

struct VS_INPUT
{
	float4 vBlendIndices              : BLENDINDICES0  < Semantic( BlendIndices ); >;              // D_CS_VERTEX_ANIMATION=0
	float4 vBlendColorTint            : COLOR0         < Semantic( Color ); >;                    
	float4 vPerVertexLighting         : COLOR1         < Semantic( PerVertexLighting ); >;         // D_BAKED_LIGHTING_FROM_VERTEX_STREAM=1
	uint4  nPackedFrame               : NORMAL0        < Semantic( CompressedTangentFrame ); >;   
	float4 vNormalOs                  : NORMAL0        < Semantic( Normal ); >;                   
	float3 vPositionOs                : POSITION0      < Semantic( PosXyz ); >;                    // D_CS_VERTEX_ANIMATION=0, S_FOLIAGE_UV_ANIMATION=1
	float4 vPivotPaint                : TEXCOORD4      < Semantic( PivotPaint ); >;               
	float4 vFoliageParams             : TEXCOORD5      < Semantic( FoliageAnimation ); >;         
	float2 vLightmapUV                : TEXCOORD3      < Semantic( LightmapUV ); >;                // D_BAKED_LIGHTING_FROM_LIGHTMAP=1
	float4 vTangentUOs_flTangentVSign : TANGENT0       < Semantic( TangentU_SignV ); >;           
	float2 vTexCoord                  : TEXCOORD0      < Semantic( LowPrecisionUv ); >;           
	float2 nInstanceIdx               : TEXCOORD13     < Semantic( InstanceTransformUv ); >;      
};

VS
{
	StaticCombo( S_FOLIAGE_UV_ANIMATION, F_FOLIAGE_UV_ANIMATION );
	StaticCombo( S_MODE_DEPTH, 0..1 );
	StaticCombo( S_ANIMATED_SHADOWS, F_ANIMATED_SHADOWS );
	StaticCombo( S_VERTEX_ANIMATION, F_VERTEX_ANIMATION );
	StaticCombo( S_FOLIAGE_ANIMATION, F_FOLIAGE_ANIMATION );
	StaticCombo( S_MODE_TOOLS_VIS, 0..1 );
	StaticComboRule( Allow1( S_FOLIAGE_ANIMATION, S_VERTEX_ANIMATION ) );
	DynamicCombo( D_COMPRESSED_NORMALS_AND_TANGENTS, 0..1 );
	DynamicCombo( D_CS_VERTEX_ANIMATION, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_VERTEX_STREAM, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_LIGHTMAP, 0..1 );
	DynamicComboRule( Allow1( D_BAKED_LIGHTING_FROM_VERTEX_STREAM, D_BAKED_LIGHTING_FROM_LIGHTMAP ) );
	
	cbuffer PerViewConstantBufferCsgo_t < Attribute("PerViewConstantBufferCsgo_t"); >;
	cbuffer PerViewConstantBuffer_t < Attribute("PerViewConstantBuffer_t"); >;
	ByteAddressBuffer g_animatedVertexCache < Attribute("AnimatedVertexCache"); >;
	ExternalDescriptorSet g_globalLateBoundBindlessSet < Source(ExternalDescSet); Attribute("g_globalLateBoundBindlessSet"); >;
	StructuredBuffer g_instanceBuffer < Attribute("InstanceBuffer"); >;
	ExternalDescriptorSet g_lightBinnerGpuSet < Source(ExternalDescSet); Attribute("g_lightBinnerGpuSet"); >;
	Texture3D g_tNoiseMap < Channel(RGB, Box(NoiseMap), Linear); OutputFormat(RGBA8888); SrgbRead(false); >;
	StructuredBuffer g_transformBuffer < Attribute("TransformBuffer"); >;
	float4 g_vTexCoordXform0 < UiType(VectorText); Expression(v0 = (0*3.14159)/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v1*float2(1,1).x,-v2*float2(1,1).y,0,((float2(.5,.5).x+float2(0,0).x)+(v2*float2(.5,.5).y))-(v1*float2(.5,.5).x))); >;
	float4 g_vTexCoordXform1 < UiType(VectorText); Expression(v0 = (0*3.14159)/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v2*float2(1,1).x,v1*float2(1,1).y,0,(float2(.5,.5).y+float2(0,0).y)-((v2*float2(.5,.5).x)+(v1*float2(.5,.5).y)))); >;
	
	// Vertex Noise
	CreateInputTexture2D(NoiseMap, Linear, 8, "", "", "Vertex Noise,15/10", "materials/default/effects/noise/perlin_a_z000.tga");
	
	// Foliage Animation
	float g_flFrondTipStrength < Default(2); Range(0, 25); UiType(Slider); UiGroup("Foliage Animation,15/Frond Tip Anim (Red Channel),40/10"); >;
	bool g_bBranchMotionPerpendicular < Default(1); UiType(CheckBox); UiGroup("Foliage Animation,15/Branch Animation,40/13"); >;
	bool g_bFrondTipUseEnvWind < UiType(CheckBox); UiGroup("Foliage Animation,15/Frond Tip Anim (Red Channel),40/13"); >;
	bool g_bSmootherNoiseBranchAndTrunk < Default(1); UiType(CheckBox); UiGroup("Foliage Animation,15/Common Noise Parameters,40/13"); >;
	float g_flBranchAnimSpeed < Default(1); Range(0, 4); UiType(Slider); UiGroup("Foliage Animation,15/Branch Animation,40/13"); >;
	float g_flBranchDeflection < UiType(Slider); UiGroup("Foliage Animation,15/Branch Animation,40/13"); >;
	float g_flBranchDeflectionEnd < Default(150); Range(0.001, 1000); UiType(Slider); UiGroup("Foliage Animation,15/Branch Animation,40/13"); >;
	float g_flBranchDeflectionStart < Range(0, 1000); UiType(Slider); UiGroup("Foliage Animation,15/Branch Animation,40/13"); >;
	float g_flBranchNoiseLevel < Default(0.5); UiType(Slider); UiGroup("Foliage Animation,15/Branch Animation,40/13"); >;
	float g_flFrondTipAnimSpeed < Default(1); Range(0, 4); UiType(Slider); UiGroup("Foliage Animation,15/Frond Tip Anim (Red Channel),40/13"); >;
	float g_flFrondTipMaskFalloff < Default(1); Range(1, 5); UiType(Slider); UiGroup("Foliage Animation,15/Frond Tip Anim (Red Channel),40/13"); >;
	float g_flFrondTipSpatialIncoherence < Default(1); Range(0, 10); UiType(Slider); UiGroup("Foliage Animation,15/Frond Tip Anim (Red Channel),40/13"); >;
	float g_flTrunkAnimSpeed < Default(1); Range(0, 4); UiType(Slider); UiGroup("Foliage Animation,15/Trunk Animation,40/13"); >;
	float g_flTrunkDeflection < UiType(Slider); UiGroup("Foliage Animation/Trunk Animation,40/13"); >;
	float g_flTrunkDeflectionEnd < Default(300); Range(-1000, 1000); UiType(Slider); UiGroup("Foliage Animation/Trunk Animation,40/13"); >;
	float g_flTrunkDeflectionStart < Range(-1000, 1000); UiType(Slider); UiGroup("Foliage Animation/Trunk Animation,40/13"); >;
	float g_flTrunkNoiseLevel < Default(0.5); UiType(Slider); UiGroup("Foliage Animation,15/Trunk Animation,40/13"); >;
	float3 g_vNoiseUvScale < Default3(1, 1, 1); Range3(0, 0, 0, 5, 5, 5); UiType(VectorText); UiGroup("Foliage Animation,15/Common Noise Parameters,40/13"); >;
	float3 g_vNoiseUvSpeed < Default3(0.25, 0.25, 0.25); Range3(-1, -1, -1, 1, 1, 1); UiType(VectorText); UiGroup("Foliage Animation,15/Common Noise Parameters,40/13"); >;
	
	// Vertex Animation
	bool g_bUseEnvWind < UiType(CheckBox); UiGroup("Vertex Animation,15/Use Env Wind,43/10"); >;
	float g_flFlutterAmount < Default(0.25); UiType(Slider); UiGroup("Vertex Animation,15/Flutter (Blue Channel),41/10"); >;
	float g_flNoise1Strength < Range(0, 150); UiType(Slider); UiGroup("Vertex Animation,15/Noise 1 (Red Channel),40/10"); >;
	float g_flNoise2Strength < Range(0, 150); UiType(Slider); UiGroup("Vertex Animation,15/Noise 2 (Blue Channel),41/10"); >;
	float g_flSwayAmount < Default(0.25); Range(0, 2); UiType(Slider); UiGroup("Vertex Animation,15/Sway (Red Channel),40/10"); >;
	float g_flFlutterSpeed < Default(1); Range(0, 2); UiType(Slider); UiGroup("Vertex Animation,15/Flutter (Blue Channel),41/11"); >;
	float g_flSwaySpeed < Default(1); Range(0, 2); UiType(Slider); UiGroup("Vertex Animation,15/Sway (Red Channel),40/11"); >;
	float3 g_vNoise1Speed < Range3(-1, -1, -1, 1, 1, 1); UiType(VectorText); UiGroup("Vertex Animation,15/Noise 1 (Red Channel),40/11"); >;
	float3 g_vNoise2Speed < Range3(-1, -1, -1, 1, 1, 1); UiType(VectorText); UiGroup("Vertex Animation,15/Noise 2 (Blue Channel),41/11"); >;
	float g_flFlutterNoiseScale < Default(1); Range(0, 2); UiType(Slider); UiGroup("Vertex Animation,15/Flutter (Blue Channel),41/12"); >;
	float g_flSwayNoiseScale < Default(1); Range(0, 2); UiType(Slider); UiGroup("Vertex Animation,15/Sway (Red Channel),40/12"); >;
	float3 g_vNoise1Scale < Range3(0, 0, 0, 5, 5, 5); UiType(VectorText); UiGroup("Vertex Animation,15/Noise 1 (Red Channel),40/12"); >;
	float3 g_vNoise2Scale < Range3(0, 0, 0, 5, 5, 5); UiType(VectorText); UiGroup("Vertex Animation,15/Noise 2 (Blue Channel),41/12"); >;
	float g_flFlutterFalloff < Default(1); Range(1, 5); UiType(Slider); UiGroup("Vertex Animation,15/Flutter (Blue Channel),41/13"); >;
	float g_flNoise1MaskFalloff < Default(1); Range(1, 5); UiType(Slider); UiGroup("Vertex Animation,15/Noise 1 (Red Channel),40/13"); >;
	float g_flNoise2MaskFalloff < Default(1); Range(1, 5); UiType(Slider); UiGroup("Vertex Animation,15/Noise 2 (Blue Channel),41/13"); >;
	float g_flSwayFalloff < Default(1); Range(1, 5); UiType(Slider); UiGroup("Vertex Animation,15/Sway (Red Channel),40/13"); >;
	
	// Color
	float3 g_vColorTint < Default3(1, 1, 1); UiType(Color); UiGroup("Color,10/20"); Expression(SrgbGammaToLinear(this)); >;
	float g_flModelTintAmount < Default(1); UiType(Slider); UiGroup("Color,10/30"); >;
	float2 g_vTexCoordScrollSpeed < Range2(-10, -10, 10, 10); UiType(VectorText); UiGroup("Color/70"); >;
	
	// Foliage UV Animation
	float g_flSpatialIncoherence < Default(0.1); UiType(Slider); UiGroup("Foliage UV Animation"); >;
	
	// SPIR-V reflection failed for backend HLSL:
	// cbuffer ID 5618 (name: _Globals_), member index 3 (name: g_vColorTint) cannot be expressed with either HLSL packing layout or packoffset.
	//
	// Re-attempting reflection with the GLSL backend.
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (6652 bytes), GLSL reflection with SPIRV-Cross by KhronosGroup
	
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
	layout(location = 1) in vec2 vBlendColorTint;
	layout(location = 2) in vec3 vTexCoord;
	layout(location = 3) in vec4 vNormalOs;
	layout(location = 4) in uvec4 vTangentUOs_flTangentVSign;
	layout(location = 5) in uint vBlendIndices;
	layout(location = 6) in vec4 nInstanceIdx;
	layout(location = 0) out vec4 output_0;
	layout(location = 1) out vec3 output_1;
	layout(location = 2) out vec3 output_2;
	layout(location = 3) out vec4 output_3;
	layout(location = 4) centroid out vec4 output_4;
	layout(location = 5) centroid out vec3 output_5;
	layout(location = 6) out vec4 output_6;
	layout(location = 7) flat out uint output_7;
	
	void main()
	{
	    _1125 _20228;
	    _20228._m0 = g_instanceBuffer_1._m0[vBlendIndices]._m0;
	    _20228._m1 = g_instanceBuffer_1._m0[vBlendIndices]._m1;
	    _20228._m2 = g_instanceBuffer_1._m0[vBlendIndices]._m2;
	    _20228._m3 = g_instanceBuffer_1._m0[vBlendIndices]._m3;
	    _20228._m4 = g_instanceBuffer_1._m0[vBlendIndices]._m4;
	    _20228._m5 = g_instanceBuffer_1._m0[vBlendIndices]._m5;
	    _20228._m6 = g_instanceBuffer_1._m0[vBlendIndices]._m6;
	    _20228._m7 = g_instanceBuffer_1._m0[vBlendIndices]._m7;
	    uint _16987 = (_20228._m5 >> uint(16)) & 15u;
	    uint _21709;
	    if (_16987 == 1u)
	    {
	        _21709 = _20228._m1 + (2u + vTangentUOs_flTangentVSign.x);
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
	    vec3 _11179 = normalize(vec4(vTexCoord.xyz, 0.0) * _21957._m0);
	    vec3 _12151 = vec4(vPositionOs.xyz * _19321.xyz, 1.0) * _21957._m0;
	    vec4 _7227 = vBlendColorTint.xyxy;
	    _7227.x = dot(vBlendColorTint.xy, _Globals_.g_vTexCoordXform0.xy) + _Globals_.g_vTexCoordXform0.w;
	    _7227.y = dot(vBlendColorTint.xy, _Globals_.g_vTexCoordXform1.xy) + _Globals_.g_vTexCoordXform1.w;
	    vec2 _22490 = _7227.xy + (_Globals_.g_vTexCoordScrollSpeed.xy * PerViewConstantBuffer_t._m1);
	    vec4 _20488 = _7227;
	    _20488.x = _22490.x;
	    _20488.y = _22490.y;
	    vec4 _11399 = vec4(mix(vec3(1.0), vec4(_21354, _21355, _17978, _7654).xyz, vec3(_Globals_.g_flModelTintAmount)), _7654 * _20228._m7);
	    vec3 _13062 = _11399.xyz * _Globals_.g_vColorTint.xyz;
	    vec4 _23714 = _11399;
	    _23714.x = _13062.x;
	    _23714.y = _13062.y;
	    _23714.z = _13062.z;
	    vec4 _17895 = (vec4(_12151.xyz, 1.0) + (PerViewConstantBuffer_t._m2 * 1.0)).xyzw * PerViewConstantBuffer_t._m0;
	    output_0 = nInstanceIdx;
	    output_1 = _12151.xyz - PerViewConstantBufferCsgo_t._m0.xyz;
	    output_2 = _11179;
	    output_3 = _20488;
	    output_4 = _23714;
	    output_5 = _11179;
	    output_6 = vec4(normalize(vec4(vNormalOs.xyz, 0.0) * _21957._m0), vNormalOs.w);
	    output_7 = _20228._m5 & 65535u;
	    _17895.y = -_17895.y;
	    gl_Position = _17895;
	}
	
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
	
	BoolAttribute(BindlessResources, true);
	BoolAttribute(DoNotRenderIntoSST, F_ANIMATED_SHADOWS);
	BoolAttribute(environmentmapped, true);
	BoolAttribute(environmentmappeddynamic, true);
	BoolAttribute(CanBatchWithDynamicShaderConstants, true);
	Float3Attribute(LightSim_MaterialTint, g_vColorTint);
	
	#if (S_VERTEX_ANIMATION == 0)
		BoolAttribute(NeedsLocalSpaceVertices, true);
	#endif
	#if (S_FOLIAGE_ANIMATION == 1)
		BoolAttribute(NeedsLocalSpaceVertices, true);
	#endif
}

PS
{
	StaticCombo( S_FOLIAGE_UV_ANIMATION, F_FOLIAGE_UV_ANIMATION );
	StaticCombo( S_MODE_DEPTH, 0..1 );
	StaticCombo( S_ANIMATED_SHADOWS, F_ANIMATED_SHADOWS );
	StaticCombo( S_ALPHA_TEST, F_ALPHA_TEST );
	StaticCombo( S_TINT_MASK, F_TINT_MASK );
	StaticCombo( S_TRANSMISSIVE_BACKFACE_NDOTL, F_TRANSMISSIVE_BACKFACE_NDOTL );
	StaticCombo( S_VERTEX_ANIMATION, F_VERTEX_ANIMATION );
	StaticCombo( S_MODE_TOOLS_SHADING_COMPLEXITY, 0..1 );
	StaticCombo( S_SHADER_QUALITY, 0..1 );
	StaticCombo( S_MODE_TOOLS_VIS, 0..1 );
	StaticComboRule( Allow1( S_MODE_DEPTH, S_TINT_MASK ) );
	StaticComboRule( Allow1( S_MODE_DEPTH, S_TRANSMISSIVE_BACKFACE_NDOTL ) );
	StaticComboRule( Allow1( S_MODE_TOOLS_SHADING_COMPLEXITY, S_TINT_MASK ) );
	StaticComboRule( Allow1( S_MODE_TOOLS_SHADING_COMPLEXITY, S_TRANSMISSIVE_BACKFACE_NDOTL ) );
	StaticComboRule( Allow1( S_MODE_TOOLS_SHADING_COMPLEXITY, S_VERTEX_ANIMATION ) );
	StaticComboRule( Allow1( S_MODE_DEPTH, S_SHADER_QUALITY ) );
	StaticComboRule( Allow1( S_MODE_TOOLS_VIS ) );
	StaticComboRule( Requires( S_MODE_TOOLS_VIS, S_SHADER_QUALITY ) );
	StaticComboRule( Requires( S_FOLIAGE_UV_ANIMATION, S_ALPHA_TEST ) );
	DynamicCombo( D_ALPHA_TEST_PREPASS, 0..1 );
	DynamicCombo( D_QUAD_OVERDRAW, 0..1 );
	DynamicCombo( D_OPAQUE_FADE, 0..1 );
	DynamicCombo( D_SPECULAR_CUBE_MAP_STATIC, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_VERTEX_STREAM, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_PROBE, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_LIGHTMAP, 0..1 );
	DynamicComboRule( Requires( D_ALPHA_TEST_PREPASS, S_ALPHA_TEST ) );
	DynamicComboRule( Requires( D_QUAD_OVERDRAW, S_MODE_TOOLS_SHADING_COMPLEXITY ) );
	DynamicComboRule( Requires( D_SPECULAR_CUBE_MAP_STATIC, S_SHADER_QUALITY ) );
	DynamicComboRule( Allow1( D_BAKED_LIGHTING_FROM_PROBE, D_BAKED_LIGHTING_FROM_VERTEX_STREAM, D_BAKED_LIGHTING_FROM_LIGHTMAP ) );
	
	cbuffer BakedLightingConstantBuffer_t < Attribute("BakedLightingConstantBuffer_t"); >;
	cbuffer PerViewConstantBufferCsgo_t < Attribute("PerViewConstantBufferCsgo_t"); >;
	cbuffer PerViewConstantBuffer_t < Attribute("PerViewConstantBuffer_t"); >;
	cbuffer PerViewLightProbeVolumeConstantBuffer_t < Attribute("PerViewLightProbeVolumeConstantBuffer_t"); >;
	cbuffer PerViewLightingConstantBufferGpu_t < Attribute("PerViewLightingConstantBufferGpu_t"); >;
	StructuredBuffer g_BarnLights < Attribute("BarnLights"); >;
	StructuredBuffer g_CullBits < Attribute("CullBits"); >;
	bool g_bAdjustBaseColor < UiType(CheckBox); Expression(g_nColorCorrectionMode==1); >;
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
	float4x4 g_mTextureAdjust < Expression(MatrixMultiply(MatrixColorTint2(float3(1,1,1),1),MatrixColorCorrect2(float3(g_fTextureColorContrast,g_fTextureColorSaturation,g_fTextureColorBrightness),TextureAverageColor(g_tColor)))); >;
	float4x4 g_mTextureColorAdjust < Expression(MatrixMultiply(MatrixColorTint2(g_vTextureColorCorrectionTint,1),MatrixColorCorrect2(float3(g_fTextureColorContrast,g_fTextureColorSaturation,g_fTextureColorBrightness),TextureAverageColor(g_tColor)))); >;
	float4x4 g_mTransmissiveTextureAdjust < Expression(MatrixMultiply(MatrixColorTint2(float3(1,1,1),1),MatrixColorCorrect2(float3(g_fTextureColorContrast,g_fTextureColorSaturation,g_fTextureColorBrightness),TextureAverageColor(g_tTransmissiveColor)))); >;
	float4x4 g_mTransmissiveTextureColorAdjust < Expression(MatrixMultiply(MatrixColorTint2(g_vTextureColorCorrectionTint,1),MatrixColorCorrect2(float3(g_fTextureColorContrast,g_fTextureColorSaturation,g_fTextureColorBrightness),TextureAverageColor(g_tTransmissiveColor)))); >;
	int g_nToolsVisMode < Attribute("g_nToolsVisMode"); UiType(Slider); >;
	Texture2D g_tAmbientOcclusion < Channel(R, Box3(TextureAmbientOcclusion), Linear); OutputFormat(ATI1N); SrgbRead(false); >;
	Texture2D g_tColor < Channel(RGB, ArtistDefined(TextureColor), Srgb); OutputFormat(DXT1); SrgbRead(true); >;
	Texture2D g_tColor < Channel(RGB, ArtistDefinedOrAlphaWeighted(TextureColor, TextureTranslucency), Srgb); Channel(A, PreserveCoverage(TextureTranslucency), Linear); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tNormal < Channel(RGBA, HemiOctIsoRoughness_RG_B(TextureNormal, TextureRoughness), Linear); OutputFormat(BC7); SrgbRead(false); >;
	RWTexture2D<float4> g_tQuadOverdrawMutexUAV < Attribute("QuadOverdrawMutexUAV"); >;
	RWTexture2D<float4> g_tQuadOverdrawUAV < Attribute("QuadOverdrawUAV"); >;
	Texture2D g_tTintMask < Channel(R, Box(TextureTintMask), Linear); OutputFormat(ATI1N); SrgbRead(false); >;
	Texture2D g_tTransmissiveColor < Channel(RGB, Box(TextureTransmissiveColor), Srgb); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tUvMotionMask < Channel(RGBA, Box(FoliageUvAnimation), Linear); OutputFormat(BC7); SrgbRead(false); >;
	float3 g_vFlatOverlayColor < Default2(1, 0); Attribute("FlatOverlayColor"); UiType(VectorText); >;
	float4 g_vShaderIDColor < Source(ShaderIDColor); UiType(VectorText); >;
	float4 g_vShadingComplexity < Source(ShadingComplexity); UiType(VectorText); >;
	
	// Foliage UV Animation
	CreateInputTexture2D(FoliageUvAnimation, Linear, 8, "", "_wind", "Foliage UV Animation", Default4(0, 0, 0, 0));
	float g_flFoliageUvAnimation < Default(0.1); UiType(Slider); UiGroup("Foliage UV Animation"); >;
	
	// Ambient Occlusion
	CreateInputTexture2D(TextureAmbientOcclusion, Linear, 8, "", "_ao", "Ambient Occlusion/10", Default4(1, 1, 1, 0));
	
	// Color
	CreateInputTexture2D(TextureTintMask, Linear, 8, "", "_mask", "Color", Default4(1, 1, 1, 0));
	CreateInputTexture2D(TextureColor, Srgb, 8, "", "_color", "Color/10", Default4(1, 1, 1, 0));
	float3 g_vTextureColorCorrectionTint < Default3(1, 1, 1); UiType(Color); UiGroup("Color/Color Correction,75/50"); >;
	float g_fTextureColorContrast < Default(1); Range(0, 4); UiType(Slider); UiGroup("Color/Color Correction/52"); >;
	float g_fTextureColorSaturation < Default(1); Range(0, 4); UiType(Slider); UiGroup("Color/Color Correction/53"); >;
	float g_fTextureColorBrightness < Default(1); Range(-8, 8); UiType(Slider); UiGroup("Color/Color Correction/54"); >;
	int g_nColorCorrectionMode < UiOptions("0=Mask All,1=Mask only Tint"); UiType(Enum); UiGroup("Color/Color Correction/55"); UiVisibility(F_TINT_MASK==1); >;
	
	// Normal Map
	CreateInputTexture2D(TextureNormal, Linear, 8, "NormalizeNormals", "_normal", "Normal Map,20", Default4(0.5, 0.5, 1, 0));
	float g_fTextureNormalContrast < Default(1); Range(-2, 2); UiType(Slider); UiGroup("Normal Map"); >;
	
	// Lighting
	CreateInputTexture2D(TextureRoughness, Linear, 8, "Inverse", "_rough", "Lighting,30/Roughness,20/10", Default4(0.5, 0.5, 0.5, 0));
	float g_fTextureRoughnessContrast < Default(1); Range(0, 4); UiType(Slider); UiGroup("Lighting/Roughness/11"); >;
	float g_fTextureRoughnessBrightness < Default(1); Range(0, 4); UiType(Slider); UiGroup("Lighting/Roughness/12"); >;
	bool g_bMaskRoughnessAdjustmentsByTintMask < UiType(CheckBox); UiGroup("Lighting/Roughness/13"); UiVisibility(F_TINT_MASK==1); >;
	
	// Translucent
	CreateInputTexture2D(TextureTranslucency, Linear, 8, "", "_trans", "Translucent,15", Default4(1, 1, 1, 0));
	float g_flAlphaTestReference < Default(0.5); Range(0.01, 0.99); UiType(Slider); UiGroup("Translucent"); >;
	float g_flGrazingAngleMask < UiType(Slider); UiGroup("Translucent/Grazing Angle Mask,40/10"); >;
	float g_flAlphaBoostStrength < Default(3); Range(1, 20); UiType(Slider); UiGroup("Translucent/Alpha Boost Mask,40/11"); >;
	float g_flAlphaBoostDistance < Default(20000); Range(5000, 20000); UiType(Slider); UiGroup("Translucent/Alpha Boost Mask,40/12"); >;
	
	// Transmission
	CreateInputTexture2D(TextureTransmissiveColor, Srgb, 8, "", "_color", "Transmission/0", Default4(1, 1, 1, 0));
	bool g_bApplyColorCorrectionToTransmissiveColor < UiType(CheckBox); UiGroup("Transmission/5"); >;
	
	// Fog
	bool g_bFogEnabled < Default(1); UiType(CheckBox); UiGroup("Fog"); >;
	
	// Vertex Color
	float g_flVertexAmbientOcclusionAmount < UiType(Slider); UiGroup("Vertex Color,15/Ambient Occlusion (Alpha Channel), 15/10"); >;
	float g_flVertexAmbientOcclusionPower < Default(1); Range(1, 5); UiType(Slider); UiGroup("Vertex Color,15/Ambient Occlusion (Alpha Channel), 15/11"); >;
	float g_flHeightGradientAmount < UiType(Slider); UiGroup("Vertex Color,15/Height Gradient (Red Channel), 15/12"); >;
	float g_flHeightGradientPower < Default(1); Range(1, 5); UiType(Slider); UiGroup("Vertex Color,15/Height Gradient (Red Channel), 15/13"); >;
	
	// Texture Address Mode
	int g_nTextureAddressModeU < UiOption("RsTextureAddressMode_t"); UiType(Enum); UiGroup("Texture Address Mode"); >;
	int g_nTextureAddressModeV < UiOption("RsTextureAddressMode_t"); UiType(Enum); UiGroup("Texture Address Mode"); >;
	
	#if (S_TINT_MASK == 0)
		Texture2D g_tColor < Channel(RGB, ArtistDefinedOrAlphaWeighted(TextureColor, TextureTranslucency), Srgb); Channel(A, PreserveCoverage(TextureTranslucency), Linear); OutputFormat(BC7); SrgbRead(true); >;
	#endif
	#if (S_TRANSMISSIVE_BACKFACE_NDOTL == 0)
		Texture2D g_tColor < Channel(RGB, ArtistDefinedOrAlphaWeighted(TextureColor, TextureTranslucency), Srgb); Channel(A, PreserveCoverage(TextureTranslucency), Linear); OutputFormat(BC7); SrgbRead(true); >;
	#endif
	#if (S_MODE_TOOLS_VIS == 1)
		Texture2D g_tColor < Channel(RGB, ArtistDefinedOrAlphaWeighted(TextureColor, TextureTranslucency), Srgb); Channel(A, PreserveCoverage(TextureTranslucency), Linear); OutputFormat(BC7); SrgbRead(true); >;
	#endif
	#if (S_SHADER_QUALITY == 1)
		Texture2D g_tColor < Channel(RGB, ArtistDefinedOrAlphaWeighted(TextureColor, TextureTranslucency), Srgb); Channel(A, PreserveCoverage(TextureTranslucency), Linear); OutputFormat(BC7); SrgbRead(true); >;
	#endif
	#if (S_ALPHA_TEST == 1)
		Texture2D g_tColor < Channel(RGB, ArtistDefinedOrAlphaWeighted(TextureColor, TextureTranslucency), Srgb); Channel(A, PreserveCoverage(TextureTranslucency), Linear); OutputFormat(BC7); SrgbRead(true); >;
	#endif
	#if (S_VERTEX_ANIMATION == 0)
		Texture2D g_tColor < Channel(RGB, ArtistDefinedOrAlphaWeighted(TextureColor, TextureTranslucency), Srgb); Channel(A, PreserveCoverage(TextureTranslucency), Linear); OutputFormat(BC7); SrgbRead(true); >;
	#endif
	#if (S_MODE_TOOLS_SHADING_COMPLEXITY == 1)
		Texture2D g_tColor < Channel(RGB, ArtistDefinedOrAlphaWeighted(TextureColor, TextureTranslucency), Srgb); Channel(A, PreserveCoverage(TextureTranslucency), Linear); OutputFormat(BC7); SrgbRead(true); >;
	#endif
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (39636 bytes), HLSL reflection with SPIRV-Cross by KhronosGroup
	
	struct _1289
	{
	    float4 _m0[3];
	};
	
	struct _1499
	{
	    float4 _m0[4];
	};
	
	struct _2441
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
	    uint _Globals_1_g_sTrilinearWrap : packoffset(c0.w);
	    uint _Globals_1_g_sTrilinearClamp : packoffset(c1);
	    uint _Globals_1_g_sPointClamp : packoffset(c1.y);
	    uint _Globals_1_g_sUserConfig : packoffset(c2);
	    uint _Globals_1_g_sUserConfigAllowGlobalMipBias : packoffset(c2.y);
	    uint _Globals_1_g_sCookieSampler : packoffset(c2.w);
	    uint _Globals_1_g_tShadowDepthBufferCmpSampler : packoffset(c3);
	    int _Globals_1_g_bFogEnabled : packoffset(c3.z);
	    int _Globals_1_g_bDontFlipBackfaceNormals : packoffset(c3.w);
	    int _Globals_1_g_bRenderBackfaceNormals : packoffset(c4);
	    float _Globals_1_g_flReflectance : packoffset(c4.y);
	    uint _Globals_1_g_tNormal : packoffset(c8);
	    uint _Globals_1_g_tAmbientOcclusion : packoffset(c8.w);
	    float _Globals_1_g_flVertexAmbientOcclusionAmount : packoffset(c11);
	    float _Globals_1_g_flVertexAmbientOcclusionPower : packoffset(c11.y);
	    float _Globals_1_g_flHeightGradientAmount : packoffset(c11.z);
	    float _Globals_1_g_flHeightGradientPower : packoffset(c11.w);
	    column_major float4x4 _Globals_1_g_mTextureColorAdjust : packoffset(c14);
	    float _Globals_1_g_fTextureRoughnessContrast : packoffset(c30.y);
	    float _Globals_1_g_fTextureRoughnessBrightness : packoffset(c30.z);
	    float _Globals_1_g_fTextureNormalContrast : packoffset(c31);
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
	    _1289 PerViewLightingConstantBufferGpu_t_1_m0 : packoffset(c7);
	    _1499 PerViewLightingConstantBufferGpu_t_1_m1 : packoffset(c11);
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
	    _2441 PerViewLightingConstantBufferGpu_t_1_m18 : packoffset(c1956);
	    _1499 PerViewLightingConstantBufferGpu_t_1_m19 : packoffset(c1988);
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
	static float4 input_0;
	static float3 input_1;
	static float3 input_2;
	static float4 input_3;
	static float4 input_4;
	static float3 input_5;
	static float4 input_6;
	static float4 output_0;
	
	struct PS_INPUT
	{
	    float4 input_0 : TEXCOORD0;
	    float3 input_1 : TEXCOORD1;
	    float3 input_2 : TEXCOORD2;
	    float4 input_3 : TEXCOORD3;
	    centroid float4 input_4 : TEXCOORD4;
	    centroid float3 input_5 : TEXCOORD5;
	    float4 input_6 : TEXCOORD6;
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
	    float4 _24079 = clamp(input_0, 0.001000000047497451305389404296875f.xxxx, 1.0f.xxxx);
	    float3 _21709;
	    if (dot(input_2.xyz, input_2.xyz) >= 1.0099999904632568359375f)
	    {
	        _21709 = input_5.xyz;
	    }
	    else
	    {
	        _21709 = input_2.xyz;
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
	    float3 _10061 = input_1 + PerViewConstantBufferCsgo_t_1_m20.xyz;
	    float4 _19334 = g_bindless_Texture2D_float4[_Globals_1_g_tColor].Sample(g_bindless_Sampler[_Globals_1_g_sUserConfigAllowGlobalMipBias], input_3.xy);
	    float4 _19068 = g_bindless_Texture2D_float4[_Globals_1_g_tAmbientOcclusion].Sample(g_bindless_Sampler[_Globals_1_g_sUserConfig], float2(input_3.xy).xy);
	    float4 _19372 = g_bindless_Texture2D_float4[_Globals_1_g_tNormal].Sample(g_bindless_Sampler[_Globals_1_g_sUserConfig], input_3.xy);
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
	    float _23240 = (input_6.w > 0.0f) ? 1.0f : (-1.0f);
	    float3 _14435 = cross(_12631.xyz, input_6.xyz) * _23240;
	    bool4 _24464 = bool4(PerViewConstantBufferCsgo_t_1_m2.x != int4(0, 0, 0, 0).x, PerViewConstantBufferCsgo_t_1_m2.y != int4(0, 0, 0, 0).y, PerViewConstantBufferCsgo_t_1_m2.z != int4(0, 0, 0, 0).z, PerViewConstantBufferCsgo_t_1_m2.w != int4(0, 0, 0, 0).w);
	    bool _20058 = _24464.w;
	    float3 _7424;
	    if (_20058)
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
	    float3 _8357 = _Globals_1_g_flReflectance.xxx;
	    float3 _21710;
	    [branch]
	    if (_Globals_1_g_fTextureNormalContrast != 1.0f)
	    {
	        float2 _8828 = _20480.yx * _Globals_1_g_fTextureNormalContrast;
	        float _16674 = _8828.x;
	        float3 _8673 = _20480;
	        _8673.y = _16674;
	        _8673.x = _8828.y;
	        bool _12887;
	        if (_14874)
	        {
	            _12887 = _Globals_1_g_bDontFlipBackfaceNormals == 0;
	        }
	        else
	        {
	            _12887 = false;
	        }
	        bool _24328;
	        if (_12887)
	        {
	            _24328 = !gl_FrontFacing;
	        }
	        else
	        {
	            _24328 = false;
	        }
	        float3 _9739 = input_2.xyz * (_24328 ? (-1.0f) : 1.0f);
	        float3 _24682 = cross(_9739.xyz, input_6.xyz) * _23240;
	        float3 _7425;
	        if (_20058)
	        {
	            _7425 = -_24682;
	        }
	        else
	        {
	            _7425 = _24682;
	        }
	        float3 _20481;
	        if (!_24328)
	        {
	            float3 _16556 = _8673;
	            _16556.y = -_16674;
	            _20481 = _16556;
	        }
	        else
	        {
	            _20481 = _8673;
	        }
	        _21710 = normalize((((input_6.xyz * _20481.x).xyz + (_7425.xyz * _20481.y)).xyz + (_9739.xyz * _20481.z)).xyz);
	    }
	    else
	    {
	        _21710 = normalize((((input_6.xyz * _20480.x).xyz + (_7424.xyz * _20480.y)).xyz + (_12631.xyz * _20480.z)).xyz);
	    }
	    bool3 _15080 = all(bool3(true, true, true)).xxx;
	    float3 _17892 = float3(_15080.x ? _21710.x : 1.0f.xxx.x, _15080.y ? _21710.y : 1.0f.xxx.y, _15080.z ? _21710.z : 1.0f.xxx.z);
	    float3 _10560 = _24347.xyz;
	    float3 _11099 = ddx(_10560);
	    float3 _9175 = ddy(_10560);
	    float3 _10347 = _11099.xyz;
	    float3 _12420 = _9175.xyz;
	    float2 _21813 = max(clamp((((_19372.zz - 0.5f.xx) * _Globals_1_g_fTextureRoughnessContrast) + 0.5f.xx).xy * _Globals_1_g_fTextureRoughnessBrightness, 0.0f.xx, 1.0f.xx).xy, pow(clamp(max(dot(_10347, _10347), dot(_12420, _12420)), 0.0f, 1.0f), 0.333000004291534423828125f).xx);
	    float3 _15598 = -_24347;
	    float4 _23875 = float4(_21710.xyz, 1.0f);
	    bool4 _24465 = bool4(PerViewConstantBufferCsgo_t_1_m0.x != int4(0, 0, 0, 0).x, PerViewConstantBufferCsgo_t_1_m0.y != int4(0, 0, 0, 0).y, PerViewConstantBufferCsgo_t_1_m0.z != int4(0, 0, 0, 0).z, PerViewConstantBufferCsgo_t_1_m0.w != int4(0, 0, 0, 0).w);
	    float _21711;
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
	        _21711 = (1.0f / (dot(_13232, 1.0f.xxxx) + PerViewLightingConstantBufferGpu_t_1_m3.x)) * (PerViewLightingConstantBufferGpu_t_1_m3.x + dot(_13232, g_bindless_Texture2D_float4[PerViewConstantBufferCsgo_t_1_m4].SampleLevel(g_bindless_Sampler[_Globals_1_g_sPointClamp], (_11086 + float2(_13083.x ? PerViewConstantBufferCsgo_t_1_m9.xy.x : _23169.x, _13083.y ? PerViewConstantBufferCsgo_t_1_m9.xy.y : _23169.y).xy).xy, 0.0f)));
	    }
	    else
	    {
	        _21711 = 1.0f;
	    }
	    float _21712;
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
	            float4 _18322 = mul(PerViewLightingConstantBufferGpu_t_1_m18._m0[_13039], float4(input_1.xyz, 1.0f));
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
	                    float4 _19671 = mul(PerViewLightingConstantBufferGpu_t_1_m18._m0[_15335], float4(input_1.xyz, 1.0f));
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
	        _21712 = _12502;
	    }
	    else
	    {
	        _21712 = 1.0f;
	    }
	    float3 _9716;
	    float3 _24878;
	    [branch]
	    if ((dot(PerViewLightingConstantBufferGpu_t_1_m9.xyz, _21710.xyz) * _21712) > 0.0f)
	    {
	        bool3 _19899 = all(bool3(_17892.x == 1.0f.xxx.x, _17892.y == 1.0f.xxx.y, _17892.z == 1.0f.xxx.z)).xxx;
	        float _11797 = max(0.0f, dot(_21710.xyz, PerViewLightingConstantBufferGpu_t_1_m9.xyz));
	        float2 _9840 = max(_21813, PerViewLightingConstantBufferGpu_t_1_m9.w.xx);
	        float3 _12281 = normalize(PerViewLightingConstantBufferGpu_t_1_m9.xyz + (-normalize(_10061.xyz - PerViewConstantBuffer_t_1_m3.xyz)).xyz).xyz;
	        float _12386 = dot(_12281, float3(_19899.x ? _21710.xyz.x : _17892.x, _19899.y ? _21710.xyz.y : _17892.y, _19899.z ? _21710.xyz.z : _17892.z).xyz);
	        float _19210 = max(0.0f, dot(PerViewLightingConstantBufferGpu_t_1_m9.xyz, _12281));
	        float _9850 = _9840.x;
	        float _25211 = _9850 * _9850;
	        float _19095 = _25211 * _25211;
	        float _15346 = ((_12386 * _12386) * (_19095 - 1.0f)) + 1.0f;
	        float3 _16808 = (PerViewLightingConstantBufferGpu_t_1_m10.xyz * _21712).xyz;
	        _9716 = ((_8357.xyz * (_19095 / (((_15346 * _15346) * (_19210 * _19210)) * ((_9850 * 4.0f) + 2.0f)))).xyz * _11797).xyz * _16808;
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
	                float4 _24893 = mul(float4(input_1.xyz, 1.0f), _14097);
	                float3 _10521 = _24893.xyz / _24893.w.xxx;
	                float4 _22905;
	                _22905.x = _10521.x;
	                _22905.y = _10521.y;
	                float _21776 = _10521.z;
	                _22905.z = _21776;
	                float3 _21642 = _22905.xyz;
	                bool _7426;
	                if (all(bool3(_22905.xyz.x > float3(-1.0f, -1.0f, 0.0f).x, _22905.xyz.y > float3(-1.0f, -1.0f, 0.0f).y, _22905.xyz.z > float3(-1.0f, -1.0f, 0.0f).z)))
	                {
	                    _7426 = all(bool3(_22905.xyz.x < 1.0f.xxx.x, _22905.xyz.y < 1.0f.xxx.y, _22905.xyz.z < 1.0f.xxx.z));
	                }
	                else
	                {
	                    _7426 = false;
	                }
	                bool _12888;
	                if (!_7426)
	                {
	                    _12888 = true;
	                }
	                else
	                {
	                    float4x3 _16509 = asfloat(uint4x3(g_BarnLights.Load(_12608 * 480 + 272), g_BarnLights.Load(_12608 * 480 + 288), g_BarnLights.Load(_12608 * 480 + 304), g_BarnLights.Load(_12608 * 480 + 276), g_BarnLights.Load(_12608 * 480 + 292), g_BarnLights.Load(_12608 * 480 + 308), g_BarnLights.Load(_12608 * 480 + 280), g_BarnLights.Load(_12608 * 480 + 296), g_BarnLights.Load(_12608 * 480 + 312), g_BarnLights.Load(_12608 * 480 + 284), g_BarnLights.Load(_12608 * 480 + 300), g_BarnLights.Load(_12608 * 480 + 316)));
	                    float3 _6368 = abs(mul(float4(input_1.xyz, 1.0f), _16509).xyz);
	                    _12888 = !all(bool3(_6368.x <= 1.0f.xxx.x, _6368.y <= 1.0f.xxx.y, _6368.z <= 1.0f.xxx.z));
	                }
	                if (_12888)
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
	                float _11798 = max(0.0f, dot(_21710.xyz, _11179.xyz));
	                float2 _9841 = max(_21813, asfloat(g_BarnLights.Load(_12608 * 480 + 256)).xx);
	                float3 _12282 = normalize(_11179.xyz + (-normalize(_10061.xyz - PerViewConstantBuffer_t_1_m3.xyz)).xyz).xyz;
	                float _12387 = dot(_12282, float3(_19900.x ? _21710.xyz.x : _17892.x, _19900.y ? _21710.xyz.y : _17892.y, _19900.z ? _21710.xyz.z : _17892.z).xyz);
	                float _19211 = max(0.0f, dot(_11179.xyz, _12282));
	                float _9851 = _9841.x;
	                float _25212 = _9851 * _9851;
	                float _19097 = _25212 * _25212;
	                float _15348 = ((_12387 * _12387) * (_19097 - 1.0f)) + 1.0f;
	                _13212 = _13138.xyz + (((_8357.xyz * (_19097 / (((_15348 * _15348) * (_19211 * _19211)) * ((_9851 * 4.0f) + 2.0f)))).xyz * _11798).xyz * _22671.xyz);
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
	    float3 _20418 = (_21711 * (_19068.x * lerp(1.0f, pow(_24079.w, _Globals_1_g_flVertexAmbientOcclusionPower), _Globals_1_g_flVertexAmbientOcclusionAmount))).xxx.xyz;
	    float3 _22686 = (_16324.xyz + (_8745 * _20418).xyz) * ((float3(max(float4(mul(_Globals_1_g_mTextureColorAdjust, float4(float4((_19334.xyz * input_4.xyz).xyz, 1.0f).xyz, 1.0f)).xyz, 1.0f), 0.0f.xxxx).xyz).xyz * 1.0f) * (lerp(0.0f, pow(_24079.x, _Globals_1_g_flHeightGradientPower), _Globals_1_g_flHeightGradientAmount) + 1.0f)).xyz;
	    float4 _11205 = float4(_22686, _19334.w);
	    _11205.x = _22686.x;
	    _11205.y = _22686.y;
	    _11205.z = _22686.z;
	    float3 _15752 = _11205.xyz + (_13137.xyz * _20418).xyz;
	    float4 _20490 = _11205;
	    _20490.x = _15752.x;
	    _20490.y = _15752.y;
	    _20490.z = _15752.z;
	    float3 _15734 = _20490.xyz + ((((lerp(_11427.xxx, _11427.yyy, _8357) * g_bindless_TextureCubeArray_float4[PerViewConstantBufferCsgo_t_1_m7].SampleLevel(g_bindless_Sampler[_Globals_1_g_sTrilinearClamp], float4(normalize(lerp(_6253, reflect(_17138.xyz, _17892.xyz).xyz, (_20711 * (sqrt(_20711) + _17225)).xxx)), 0.0f), PerViewLightingConstantBufferGpu_t_1_m8.y * sqrt(_17172)).xyz).xyz * (normalize(_16991 + 0.001000000047497451305389404296875f.xxx) * clamp(length(_16991), 0.0f, 1.75f))).xyz * (1.0f.xxx + (normalize(_8745 + 0.001000000047497451305389404296875f.xxx) * 0.5f))).xyz * _20418).xyz;
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
	            bool _12889;
	            if (dot(_21493, _21493) > PerViewConstantBufferCsgo_t_1_m14.x)
	            {
	                _12889 = (_10061.z * PerViewConstantBufferCsgo_t_1_m14.z) < PerViewConstantBufferCsgo_t_1_m14.y;
	            }
	            else
	            {
	                _12889 = false;
	            }
	            [branch]
	            if (_12889)
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
	            bool _12890;
	            if (dot(_9057, _9057) > PerViewConstantBufferCsgo_t_1_m18.x)
	            {
	                _12890 = (PerViewConstantBufferCsgo_t_1_m18.z * _10061.z) < PerViewConstantBufferCsgo_t_1_m18.y;
	            }
	            else
	            {
	                _12890 = false;
	            }
	            if (_12890)
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
	    input_6 = stage_input.input_6;
	    MainPs_inner();
	    PS_OUTPUT stage_output;
	    stage_output.output_0 = output_0;
	    return stage_output;
	}
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
	
	BoolAttribute(BindlessResources, true);
	TextureAttribute(LightSim_DiffuseAlbedoTexture, g_tColor);
	TextureAttribute(RepresentativeTexture, g_tColor);
	BoolAttribute(environmentmapped, true);
	BoolAttribute(environmentmappeddynamic, true);
	BoolAttribute(NeedsLightProbe, true);
	BoolAttribute(DoNotCastShadows, F_DO_NOT_CAST_SHADOWS || 0);
	BoolAttribute(SupportsMappingDimensions, true);
	BoolAttribute(renderbackfaces, F_RENDER_BACKFACES || 0);
	BoolAttribute(SupportsLightmapping, true);
	BoolAttribute(PerVertexLighting, true);
	BoolAttribute(AllowBackfaceCulling, F_RENDER_BACKFACES ? 0 : 1);
	BoolAttribute(DoubleSided, F_RENDER_BACKFACES);
	BoolAttribute(SupportsAggregateInstancing, F_FOLIAGE_ANIMATION==0);
	BoolAttribute(IgnoreFaceNormalsForLighting, true);
	
	#if (S_MODE_TOOLS_SHADING_COMPLEXITY == 0)
		TextureAttribute(LightSim_TintMaskTextureR, g_tTintMask);
	#endif
	#if (S_ALPHA_TEST == 1)
		TextureAttribute(LightSim_Opacity_A, g_tColor);
		BoolAttribute(alphatest, true);
		BoolAttribute(NoZPrepass, true);
		BoolAttribute(AlphaTestZPrepass, true);
	#endif
	#if (S_ALPHA_TEST == 0)
		BoolAttribute(NoZPrepass, F_DISABLE_Z_PREPASS || 0);
	#endif
	#if (S_TINT_MASK == 1)
		TextureAttribute(LightSim_TintMaskTextureR, g_tTintMask);
	#endif
	#if (S_MODE_TOOLS_SHADING_COMPLEXITY == 1)
		TextureAttribute(LightSim_Opacity_A, g_tColor);
		BoolAttribute(alphatest, true);
		BoolAttribute(NoZPrepass, true);
		BoolAttribute(AlphaTestZPrepass, true);
	#endif
	#if (S_TINT_MASK == 0)
		TextureAttribute(LightSim_Opacity_A, g_tColor);
		BoolAttribute(alphatest, true);
		BoolAttribute(NoZPrepass, true);
		BoolAttribute(AlphaTestZPrepass, true);
	#endif
	#if (S_VERTEX_ANIMATION == 0)
		TextureAttribute(LightSim_Opacity_A, g_tColor);
		BoolAttribute(alphatest, true);
		BoolAttribute(NoZPrepass, true);
		BoolAttribute(AlphaTestZPrepass, true);
	#endif
	#if (S_TRANSMISSIVE_BACKFACE_NDOTL == 0)
		TextureAttribute(LightSim_Opacity_A, g_tColor);
		BoolAttribute(alphatest, true);
		BoolAttribute(NoZPrepass, true);
		BoolAttribute(AlphaTestZPrepass, true);
	#endif
	#if (S_TRANSMISSIVE_BACKFACE_NDOTL == 1)
		TextureAttribute(LightSim_TintMaskTextureR, g_tTintMask);
	#endif
	
	// PSRS
	
	RenderState(BackStencilFunc, F_RENDER_BACKFACES ? 5 : 7);
	RenderState(CullMode, F_RENDER_BACKFACES ? None : Front);
	RenderState(CullMode, F_RENDER_BACKFACES ? None : Back);
	RenderState(DepthEnable, F_DISABLE_Z_BUFFERING ? False : True);
	RenderState(DepthFunc, Equal);
	RenderState(DepthWriteEnable, False);
	RenderState(DepthWriteEnable, F_DISABLE_Z_BUFFERING ? False : True);
	RenderState(SlopeScaleDepthBias, 0);
	RenderState(StencilEnable, 1);
	RenderState(StencilFunc, 5);
	RenderState(StencilReadMask, 1);
	RenderState(StencilRef, 3);
	RenderState(StencilWriteMask, 254);
	
	
	BoolAttribute(BindlessResources, true);
	
}

RTX
{
	StaticCombo( S_FOLIAGE_UV_ANIMATION, F_FOLIAGE_UV_ANIMATION );
	StaticCombo( S_MODE_DEPTH, 0..1 );
	StaticCombo( S_ANIMATED_SHADOWS, F_ANIMATED_SHADOWS );
	StaticCombo( S_VERTEX_ANIMATION, F_VERTEX_ANIMATION );
	StaticCombo( S_FOLIAGE_ANIMATION, F_FOLIAGE_ANIMATION );
	StaticCombo( S_MODE_TOOLS_VIS, 0..1 );
	StaticCombo( S_ALPHA_TEST, F_ALPHA_TEST );
	StaticCombo( S_TINT_MASK, F_TINT_MASK );
	StaticCombo( S_TRANSMISSIVE_BACKFACE_NDOTL, F_TRANSMISSIVE_BACKFACE_NDOTL );
	StaticCombo( S_MODE_TOOLS_SHADING_COMPLEXITY, 0..1 );
	StaticCombo( S_SHADER_QUALITY, 0..1 );
	StaticComboRule( Allow1( S_MODE_DEPTH, S_TINT_MASK ) );
	StaticComboRule( Allow1( S_MODE_DEPTH, S_TRANSMISSIVE_BACKFACE_NDOTL ) );
	StaticComboRule( Allow1( S_MODE_TOOLS_SHADING_COMPLEXITY, S_TINT_MASK ) );
	StaticComboRule( Allow1( S_MODE_TOOLS_SHADING_COMPLEXITY, S_TRANSMISSIVE_BACKFACE_NDOTL ) );
	StaticComboRule( Allow1( S_MODE_TOOLS_SHADING_COMPLEXITY, S_VERTEX_ANIMATION ) );
	StaticComboRule( Allow1( S_MODE_DEPTH, S_SHADER_QUALITY ) );
	StaticComboRule( Allow1( S_MODE_TOOLS_VIS ) );
	StaticComboRule( Requires( S_MODE_TOOLS_VIS, S_SHADER_QUALITY ) );
	StaticComboRule( Allow0( S_MODE_DEPTH, S_MODE_TOOLS_SHADING_COMPLEXITY ) );
	StaticComboRule( Allow0( S_VERTEX_ANIMATION ) );
	StaticComboRule( Allow0( S_FOLIAGE_ANIMATION ) );
	StaticComboRule( Allow0( S_FOLIAGE_UV_ANIMATION ) );
	StaticComboRule( Allow0( S_MODE_TOOLS_VIS, S_SHADER_QUALITY ) );
	StaticComboRule( Requires( S_FOLIAGE_UV_ANIMATION, S_ALPHA_TEST ) );
	StaticComboRule( Allow1( S_FOLIAGE_ANIMATION, S_VERTEX_ANIMATION ) );
	DynamicCombo( D_COMPRESSED_NORMALS_AND_TANGENTS, 0..1 );
	DynamicCombo( D_CS_VERTEX_ANIMATION, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_VERTEX_STREAM, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_LIGHTMAP, 0..1 );
	DynamicCombo( D_ALPHA_TEST_PREPASS, 0..1 );
	DynamicCombo( D_QUAD_OVERDRAW, 0..1 );
	DynamicCombo( D_OPAQUE_FADE, 0..1 );
	DynamicCombo( D_SPECULAR_CUBE_MAP_STATIC, 0..1 );
	DynamicCombo( D_BAKED_LIGHTING_FROM_PROBE, 0..1 );
	DynamicComboRule( Allow1( D_BAKED_LIGHTING_FROM_VERTEX_STREAM, D_BAKED_LIGHTING_FROM_LIGHTMAP ) );
	DynamicComboRule( Requires( D_ALPHA_TEST_PREPASS, S_ALPHA_TEST ) );
	DynamicComboRule( Requires( D_QUAD_OVERDRAW, S_MODE_TOOLS_SHADING_COMPLEXITY ) );
	DynamicComboRule( Requires( D_SPECULAR_CUBE_MAP_STATIC, S_SHADER_QUALITY ) );
	DynamicComboRule( Allow1( D_BAKED_LIGHTING_FROM_PROBE, D_BAKED_LIGHTING_FROM_VERTEX_STREAM, D_BAKED_LIGHTING_FROM_LIGHTMAP ) );
	DynamicComboRule( Allow0( D_OPAQUE_FADE ) );
	DynamicComboRule( Allow0( D_ALPHA_TEST_PREPASS ) );
	DynamicComboRule( Allow0( D_SPECULAR_CUBE_MAP_STATIC ) );
	DynamicComboRule( Allow0( D_BAKED_LIGHTING_FROM_PROBE, D_BAKED_LIGHTING_FROM_VERTEX_STREAM, D_BAKED_LIGHTING_FROM_LIGHTMAP ) );
	DynamicComboRule( Allow0( D_COMPRESSED_NORMALS_AND_TANGENTS, D_CS_VERTEX_ANIMATION ) );
	
	bool g_bDontFlipBackfaceNormals < UiType(CheckBox); Expression(F_DONT_FLIP_BACKFACE_NORMALS || 0); >;
	bool g_bRenderBackfaceNormals < UiType(CheckBox); Expression((F_RENDER_BACKFACES && 1) || 0); >;
	bool g_bUseAlbedoForTransmissive < UiType(CheckBox); Expression(F_USE_ALBEDO_FOR_TRANSMISSIVE || 0); >;
	float g_flReflectance < UiType(Slider); Expression(pow((1.5-1)/(1.5+1),2)); >;
	float4x4 g_mTextureColorAdjust < Expression(MatrixMultiply(MatrixColorTint2(g_vTextureColorCorrectionTint,1),MatrixColorCorrect2(float3(g_fTextureColorContrast,g_fTextureColorSaturation,g_fTextureColorBrightness),TextureAverageColor(g_tColor)))); >;
	float4x4 g_mTransmissiveTextureColorAdjust < Expression(MatrixMultiply(MatrixColorTint2(g_vTextureColorCorrectionTint,1),MatrixColorCorrect2(float3(g_fTextureColorContrast,g_fTextureColorSaturation,g_fTextureColorBrightness),TextureAverageColor(g_tTransmissiveColor)))); >;
	Texture2D g_tColor < Channel(RGB, ArtistDefined(TextureColor), Srgb); OutputFormat(DXT1); SrgbRead(true); >;
	Texture2D g_tColor < Channel(RGB, ArtistDefinedOrAlphaWeighted(TextureColor, TextureTranslucency), Srgb); Channel(A, PreserveCoverage(TextureTranslucency), Linear); OutputFormat(BC7); SrgbRead(true); >;
	Texture2D g_tNormal < Channel(RGBA, HemiOctIsoRoughness_RG_B(TextureNormal, TextureRoughness), Linear); OutputFormat(BC7); SrgbRead(false); >;
	Texture2D g_tTintMask < Channel(R, Box(TextureTintMask), Linear); OutputFormat(ATI1N); SrgbRead(false); >;
	Texture2D g_tTransmissiveColor < Channel(RGB, Box(TextureTransmissiveColor), Srgb); OutputFormat(BC7); SrgbRead(true); >;
	float4 g_vTexCoordXform0 < UiType(VectorText); Expression(v0 = (0*3.14159)/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v1*float2(1,1).x,-v2*float2(1,1).y,0,((float2(.5,.5).x+float2(0,0).x)+(v2*float2(.5,.5).y))-(v1*float2(.5,.5).x))); >;
	float4 g_vTexCoordXform1 < UiType(VectorText); Expression(v0 = (0*3.14159)/180;
		v1 = cos(v0);
		v2 = sin(v0);
		float4(v2*float2(1,1).x,v1*float2(1,1).y,0,(float2(.5,.5).y+float2(0,0).y)-((v2*float2(.5,.5).x)+(v1*float2(.5,.5).y)))); >;
	
	// Color
	CreateInputTexture2D(TextureTintMask, Linear, 8, "", "_mask", "Color", Default4(1, 1, 1, 0));
	CreateInputTexture2D(TextureColor, Srgb, 8, "", "_color", "Color/10", Default4(1, 1, 1, 0));
	float3 g_vColorTint < Default3(1, 1, 1); UiType(Color); UiGroup("Color,10/20"); Expression(SrgbGammaToLinear(this)); >;
	float g_flModelTintAmount < Default(1); UiType(Slider); UiGroup("Color,10/30"); >;
	float3 g_vTextureColorCorrectionTint < Default3(1, 1, 1); UiType(Color); UiGroup("Color/Color Correction,75/50"); >;
	float g_fTextureColorContrast < Default(1); Range(0, 4); UiType(Slider); UiGroup("Color/Color Correction/52"); >;
	float g_fTextureColorSaturation < Default(1); Range(0, 4); UiType(Slider); UiGroup("Color/Color Correction/53"); >;
	float g_fTextureColorBrightness < Default(1); Range(-8, 8); UiType(Slider); UiGroup("Color/Color Correction/54"); >;
	float2 g_vTexCoordScrollSpeed < Range2(-10, -10, 10, 10); UiType(VectorText); UiGroup("Color/70"); >;
	
	// Normal Map
	CreateInputTexture2D(TextureNormal, Linear, 8, "NormalizeNormals", "_normal", "Normal Map,20", Default4(0.5, 0.5, 1, 0));
	float g_fTextureNormalContrast < Default(1); Range(-2, 2); UiType(Slider); UiGroup("Normal Map"); >;
	
	// Lighting
	CreateInputTexture2D(TextureRoughness, Linear, 8, "Inverse", "_rough", "Lighting,30/Roughness,20/10", Default4(0.5, 0.5, 0.5, 0));
	float g_fTextureRoughnessContrast < Default(1); Range(0, 4); UiType(Slider); UiGroup("Lighting/Roughness/11"); >;
	float g_fTextureRoughnessBrightness < Default(1); Range(0, 4); UiType(Slider); UiGroup("Lighting/Roughness/12"); >;
	
	// Translucent
	CreateInputTexture2D(TextureTranslucency, Linear, 8, "", "_trans", "Translucent,15", Default4(1, 1, 1, 0));
	
	// Transmission
	CreateInputTexture2D(TextureTransmissiveColor, Srgb, 8, "", "_color", "Transmission/0", Default4(1, 1, 1, 0));
	bool g_bApplyColorCorrectionToTransmissiveColor < UiType(CheckBox); UiGroup("Transmission/5"); >;
	
	// Texture Address Mode
	int g_nTextureAddressModeU < UiOption("RsTextureAddressMode_t"); UiType(Enum); UiGroup("Texture Address Mode"); >;
	int g_nTextureAddressModeV < UiOption("RsTextureAddressMode_t"); UiType(Enum); UiGroup("Texture Address Mode"); >;
	
	#if (S_ALPHA_TEST == 1)
		Texture2D g_tColor < Channel(RGB, ArtistDefinedOrAlphaWeighted(TextureColor, TextureTranslucency), Srgb); Channel(A, PreserveCoverage(TextureTranslucency), Linear); OutputFormat(BC7); SrgbRead(true); >;
	#endif
	
	// SPIR-V reflection failed for backend HLSL:
	// Unsupported builtin in HLSL: 5326
	//
	// Re-attempting reflection with the GLSL backend.
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (73364 bytes), GLSL reflection with SPIRV-Cross by KhronosGroup
	
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
	    vec4 vBlendColorTint;
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
	    PackedRtxInstanceData_t_natural_logical _493;
	    _493.nSrgbColor = g_instanceBuffer._member0[uint(gl_InstanceID)].nSrgbColor;
	    _493.nTriangleGeometry = g_instanceBuffer._member0[uint(gl_InstanceID)].nTriangleGeometry;
	    _493.nMaterialData = g_instanceBuffer._member0[uint(gl_InstanceID)].nMaterialData;
	    _493.nMaterialFlags_nInstanceFlags = g_instanceBuffer._member0[uint(gl_InstanceID)].nMaterialFlags_nInstanceFlags;
	    _493.fEmissiveBoost = g_instanceBuffer._member0[uint(gl_InstanceID)].fEmissiveBoost;
	    _493.nInstanceFlags = g_instanceBuffer._member0[uint(gl_InstanceID)].nInstanceFlags;
	    _493._pad1 = g_instanceBuffer._member0[uint(gl_InstanceID)]._pad1;
	    _493._pad2 = g_instanceBuffer._member0[uint(gl_InstanceID)]._pad2;
	    uint _332 = _493.nMaterialData;
	    uint _387 = g_MaterialData_1._member0[(_332 + 28u) / 4u];
	    uint _386 = g_MaterialData_1._member0[(_332 + 32u) / 4u];
	    vec4 _385 = vec4(g_MaterialData_3._member0[(_332 + 112u) / 4u], g_MaterialData_3._member0[(_332 + 116u) / 4u], g_MaterialData_3._member0[(_332 + 120u) / 4u], g_MaterialData_3._member0[(_332 + 124u) / 4u]);
	    vec4 _384 = vec4(g_MaterialData_3._member0[(_332 + 128u) / 4u], g_MaterialData_3._member0[(_332 + 132u) / 4u], g_MaterialData_3._member0[(_332 + 136u) / 4u], g_MaterialData_3._member0[(_332 + 140u) / 4u]);
	    vec2 _383 = vec2(g_MaterialData_3._member0[(_332 + 144u) / 4u], g_MaterialData_3._member0[(_332 + 148u) / 4u]);
	    vec3 _382 = vec3(g_MaterialData_3._member0[(_332 + 160u) / 4u], g_MaterialData_3._member0[(_332 + 164u) / 4u], g_MaterialData_3._member0[(_332 + 168u) / 4u]);
	    float _381 = g_MaterialData_3._member0[(_332 + 172u) / 4u];
	    uint _380 = g_MaterialData_1._member0[(_332 + 180u) / 4u];
	    bool _379 = g_MaterialData_5._member0[(_332 + 188u) / 4u] != 0;
	    bool _378 = g_MaterialData_5._member0[(_332 + 192u) / 4u] != 0;
	    float _377 = g_MaterialData_3._member0[(_332 + 196u) / 4u];
	    uint _376 = g_MaterialData_1._member0[(_332 + 200u) / 4u];
	    bool _375 = g_MaterialData_5._member0[(_332 + 300u) / 4u] != 0;
	    mat4 _374 = mat4(vec4(g_MaterialData_3._member0[(_332 + 304u) / 4u], g_MaterialData_3._member0[(_332 + 320u) / 4u], g_MaterialData_3._member0[(_332 + 336u) / 4u], g_MaterialData_3._member0[(_332 + 352u) / 4u]), vec4(g_MaterialData_3._member0[(_332 + 308u) / 4u], g_MaterialData_3._member0[(_332 + 324u) / 4u], g_MaterialData_3._member0[(_332 + 340u) / 4u], g_MaterialData_3._member0[(_332 + 356u) / 4u]), vec4(g_MaterialData_3._member0[(_332 + 312u) / 4u], g_MaterialData_3._member0[(_332 + 328u) / 4u], g_MaterialData_3._member0[(_332 + 344u) / 4u], g_MaterialData_3._member0[(_332 + 360u) / 4u]), vec4(g_MaterialData_3._member0[(_332 + 316u) / 4u], g_MaterialData_3._member0[(_332 + 332u) / 4u], g_MaterialData_3._member0[(_332 + 348u) / 4u], g_MaterialData_3._member0[(_332 + 364u) / 4u]));
	    mat4 _373 = mat4(vec4(g_MaterialData_3._member0[(_332 + 368u) / 4u], g_MaterialData_3._member0[(_332 + 384u) / 4u], g_MaterialData_3._member0[(_332 + 400u) / 4u], g_MaterialData_3._member0[(_332 + 416u) / 4u]), vec4(g_MaterialData_3._member0[(_332 + 372u) / 4u], g_MaterialData_3._member0[(_332 + 388u) / 4u], g_MaterialData_3._member0[(_332 + 404u) / 4u], g_MaterialData_3._member0[(_332 + 420u) / 4u]), vec4(g_MaterialData_3._member0[(_332 + 376u) / 4u], g_MaterialData_3._member0[(_332 + 392u) / 4u], g_MaterialData_3._member0[(_332 + 408u) / 4u], g_MaterialData_3._member0[(_332 + 424u) / 4u]), vec4(g_MaterialData_3._member0[(_332 + 380u) / 4u], g_MaterialData_3._member0[(_332 + 396u) / 4u], g_MaterialData_3._member0[(_332 + 412u) / 4u], g_MaterialData_3._member0[(_332 + 428u) / 4u]));
	    float _372 = g_MaterialData_3._member0[(_332 + 564u) / 4u];
	    float _371 = g_MaterialData_3._member0[(_332 + 568u) / 4u];
	    bool _370 = g_MaterialData_5._member0[(_332 + 572u) / 4u] != 0;
	    float _369 = g_MaterialData_3._member0[(_332 + 576u) / 4u];
	    uvec3 _486;
	    do
	    {
	        if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes.w == 4)
	        {
	            uint _796 = (12u * uint(gl_PrimitiveID)) + uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes.w);
	            _486 = uvec3(g_Indices_1[g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._member0[_796 / 4u], g_Indices_1[g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._member0[(_796 + 4u) / 4u], g_Indices_1[g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._member0[(_796 + 8u) / 4u]);
	            break;
	        }
	        else
	        {
	            uint _769 = (6u * uint(gl_PrimitiveID)) + uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes.w);
	            uint _770 = _769 & 4294967292u;
	            uint _771 = _770 / 4u;
	            uint _775 = (_770 + 4u) / 4u;
	            uint _780 = (g_Indices_1[g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._member0[_771] & 4294901760u) >> uint(16);
	            uint _781 = g_Indices_1[g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._member0[_775] & 65535u;
	            uvec3 _487;
	            if (_769 == _770)
	            {
	                _487 = uvec3(g_Indices_1[g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._member0[_771] & 65535u, _780, _781);
	            }
	            else
	            {
	                _487 = uvec3(_780, _781, (g_Indices_1[g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._member0[_775] & 4294901760u) >> uint(16));
	            }
	            _486 = _487;
	            break;
	        }
	        break;
	    } while(false);
	    uint _60 = uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.x);
	    uvec3 _827 = (uvec3(uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes.x)) * _486) + uvec3(uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes.x));
	    vec3 _481[3];
	    uint _829 = _827.x;
	    _481[0] = vec3(g_Vertices_1[_60]._member0[_829 / 4u], g_Vertices_1[_60]._member0[(_829 + 4u) / 4u], g_Vertices_1[_60]._member0[(_829 + 8u) / 4u]);
	    uint _843 = _827.y;
	    _481[1] = vec3(g_Vertices_1[_60]._member0[_843 / 4u], g_Vertices_1[_60]._member0[(_843 + 4u) / 4u], g_Vertices_1[_60]._member0[(_843 + 8u) / 4u]);
	    uint _857 = _827.z;
	    _481[2] = vec3(g_Vertices_1[_60]._member0[_857 / 4u], g_Vertices_1[_60]._member0[(_857 + 4u) / 4u], g_Vertices_1[_60]._member0[(_857 + 8u) / 4u]);
	    int _482 = 0;
	    VS_INPUT vsInput[3];
	    for (;;)
	    {
	        if (!(_482 < 3))
	        {
	            break;
	        }
	        vsInput[_482].vPositionOs = _481[_482];
	        _482++;
	        continue;
	    }
	    vec2 _483[3];
	    _483[0] = vec2(0.0);
	    _483[1] = vec2(0.0);
	    _483[2] = vec2(0.0);
	    if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].y != 0)
	    {
	        ivec4 _480 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers;
	        uint _62 = uint(_480[g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].z]);
	        uint _908 = uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].z);
	        ivec4 _478 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes;
	        ivec4 _479 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes;
	        uvec3 _924 = (uvec3(uint(_478[_908])) * _486) + uvec3(uint(_479[_908]) + uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].x));
	        if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].y == 16)
	        {
	            uint _1056 = _924.x;
	            _483[0] = vec2(g_Vertices_1[_62]._member0[_1056 / 4u], g_Vertices_1[_62]._member0[(_1056 + 4u) / 4u]);
	            uint _1065 = _924.y;
	            _483[1] = vec2(g_Vertices_1[_62]._member0[_1065 / 4u], g_Vertices_1[_62]._member0[(_1065 + 4u) / 4u]);
	            uint _1074 = _924.z;
	            _483[2] = vec2(g_Vertices_1[_62]._member0[_1074 / 4u], g_Vertices_1[_62]._member0[(_1074 + 4u) / 4u]);
	        }
	        else
	        {
	            if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].y == 34)
	            {
	                uint _1027 = _924.x / 4u;
	                _483[0] = vec2(uint16BitsToFloat16(u16vec2(uvec2(g_Vertices_3[_62]._member0[_1027], g_Vertices_3[_62]._member0[_1027] >> uint(16)) & uvec2(65535u))));
	                uint _1037 = _924.y / 4u;
	                _483[1] = vec2(uint16BitsToFloat16(u16vec2(uvec2(g_Vertices_3[_62]._member0[_1037], g_Vertices_3[_62]._member0[_1037] >> uint(16)) & uvec2(65535u))));
	                uint _1047 = _924.z / 4u;
	                _483[2] = vec2(uint16BitsToFloat16(u16vec2(uvec2(g_Vertices_3[_62]._member0[_1047], g_Vertices_3[_62]._member0[_1047] >> uint(16)) & uvec2(65535u))));
	            }
	            else
	            {
	                if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].y == 37)
	                {
	                    uint _937 = _924.x / 4u;
	                    uint _940 = g_Vertices_3[_62]._member0[_937] & 65535u;
	                    int _477;
	                    if (_940 > 32767u)
	                    {
	                        _477 = int(4294901760u | _940);
	                    }
	                    else
	                    {
	                        _477 = int(_940);
	                    }
	                    uint _953 = (g_Vertices_3[_62]._member0[_937] & 4294901760u) >> uint(16);
	                    int _476;
	                    if (_953 > 32767u)
	                    {
	                        _476 = int(4294901760u | _953);
	                    }
	                    else
	                    {
	                        _476 = int(_953);
	                    }
	                    _483[0] = vec2(max(float(_477) * 3.0518509447574615478515625e-05, -1.0), max(float(_476) * 3.0518509447574615478515625e-05, -1.0));
	                    uint _967 = _924.y / 4u;
	                    uint _970 = g_Vertices_3[_62]._member0[_967] & 65535u;
	                    int _475;
	                    if (_970 > 32767u)
	                    {
	                        _475 = int(4294901760u | _970);
	                    }
	                    else
	                    {
	                        _475 = int(_970);
	                    }
	                    uint _983 = (g_Vertices_3[_62]._member0[_967] & 4294901760u) >> uint(16);
	                    int _474;
	                    if (_983 > 32767u)
	                    {
	                        _474 = int(4294901760u | _983);
	                    }
	                    else
	                    {
	                        _474 = int(_983);
	                    }
	                    _483[1] = vec2(max(float(_475) * 3.0518509447574615478515625e-05, -1.0), max(float(_474) * 3.0518509447574615478515625e-05, -1.0));
	                    uint _997 = _924.z / 4u;
	                    uint _1000 = g_Vertices_3[_62]._member0[_997] & 65535u;
	                    int _473;
	                    if (_1000 > 32767u)
	                    {
	                        _473 = int(4294901760u | _1000);
	                    }
	                    else
	                    {
	                        _473 = int(_1000);
	                    }
	                    uint _1013 = (g_Vertices_3[_62]._member0[_997] & 4294901760u) >> uint(16);
	                    int _472;
	                    if (_1013 > 32767u)
	                    {
	                        _472 = int(4294901760u | _1013);
	                    }
	                    else
	                    {
	                        _472 = int(_1013);
	                    }
	                    _483[2] = vec2(max(float(_473) * 3.0518509447574615478515625e-05, -1.0), max(float(_472) * 3.0518509447574615478515625e-05, -1.0));
	                }
	            }
	        }
	    }
	    _482 = 0;
	    for (;;)
	    {
	        if (!(_482 < 3))
	        {
	            break;
	        }
	        vsInput[_482].vTexCoord = _483[_482];
	        _482++;
	        continue;
	    }
	    vec3 _484[3];
	    vec4 _485[3];
	    do
	    {
	        if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.y != 0)
	        {
	            ivec4 _458 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers;
	            uint _66 = uint(_458[g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.z]);
	            uint _1124 = uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.z);
	            ivec4 _456 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes;
	            ivec4 _457 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes;
	            uvec3 _1140 = (uvec3(uint(_456[_1124])) * _486) + uvec3(uint(_457[_1124]) + uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.x));
	            if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.y == 6)
	            {
	                uint _1668 = _1140.x;
	                _484[0] = vec3(g_Vertices_1[_66]._member0[_1668 / 4u], g_Vertices_1[_66]._member0[(_1668 + 4u) / 4u], g_Vertices_1[_66]._member0[(_1668 + 8u) / 4u]);
	                uint _1682 = _1140.y;
	                _484[1] = vec3(g_Vertices_1[_66]._member0[_1682 / 4u], g_Vertices_1[_66]._member0[(_1682 + 4u) / 4u], g_Vertices_1[_66]._member0[(_1682 + 8u) / 4u]);
	                uint _1696 = _1140.z;
	                _484[2] = vec3(g_Vertices_1[_66]._member0[_1696 / 4u], g_Vertices_1[_66]._member0[(_1696 + 4u) / 4u], g_Vertices_1[_66]._member0[(_1696 + 8u) / 4u]);
	            }
	            else
	            {
	                if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.y == 17)
	                {
	                    uint _1404 = _1140.x;
	                    uvec2 _1412 = uvec2(g_Vertices_3[_66]._member0[_1404 / 4u], g_Vertices_3[_66]._member0[(_1404 + 4u) / 4u]);
	                    uint _1413 = _1140.y;
	                    uvec2 _321 = uvec2(g_Vertices_3[_66]._member0[_1413 / 4u], g_Vertices_3[_66]._member0[(_1413 + 4u) / 4u]);
	                    uint _1422 = _1140.z;
	                    uvec2 _320 = uvec2(g_Vertices_3[_66]._member0[_1422 / 4u], g_Vertices_3[_66]._member0[(_1422 + 4u) / 4u]);
	                    uint _1434 = _1412.x;
	                    uint _1442 = _1412.y;
	                    vec2 _1452 = ((vec2(float(_1434 & 65535u), float((_1434 >> 16u) & 65535u)) * vec2(1.525902189314365386962890625e-05)) * 2.0) - vec2(1.0);
	                    float _1453 = _1452.x;
	                    float _1458 = (1.0 - abs(_1453)) - abs(_1452.y);
	                    vec3 _1459 = vec3(_1453, _1452.y, _1458);
	                    float _1461 = saturate(-_1458);
	                    vec2 _1467 = _1452 + mix(vec2(_1461), vec2(-_1461), greaterThanEqual(_1452, vec2(0.0)));
	                    _1459.x = _1467.x;
	                    _1459.y = _1467.y;
	                    vec3 _460 = normalize(_1459);
	                    vec2 _1474 = ((vec2(float((_1442 >> uint(1)) & 32767u), float((_1442 >> 16u) & 32767u)) * vec2(3.0518509447574615478515625e-05)) * 2.0) - vec2(1.0);
	                    float _1475 = _1474.x;
	                    float _1480 = (1.0 - abs(_1475)) - abs(_1474.y);
	                    vec3 _1481 = vec3(_1475, _1474.y, _1480);
	                    float _1483 = saturate(-_1480);
	                    vec2 _1489 = _1474 + mix(vec2(_1483), vec2(-_1483), greaterThanEqual(_1474, vec2(0.0)));
	                    _1481.x = _1489.x;
	                    _1481.y = _1489.y;
	                    vec3 _459 = normalize(_1481);
	                    float _446;
	                    if ((_1442 & 1u) != 0u)
	                    {
	                        _446 = 1.0;
	                    }
	                    else
	                    {
	                        _446 = -1.0;
	                    }
	                    _484[0] = _460;
	                    _485[0].w = _446;
	                    _485[0].x = _459.x;
	                    _485[0].y = _459.y;
	                    _485[0].z = _459.z;
	                    vec2 _1531 = ((vec2(float(_321.x & 65535u), float((_321.x >> 16u) & 65535u)) * vec2(1.525902189314365386962890625e-05)) * 2.0) - vec2(1.0);
	                    float _1532 = _1531.x;
	                    float _1537 = (1.0 - abs(_1532)) - abs(_1531.y);
	                    vec3 _1538 = vec3(_1532, _1531.y, _1537);
	                    float _1540 = saturate(-_1537);
	                    vec2 _1546 = _1531 + mix(vec2(_1540), vec2(-_1540), greaterThanEqual(_1531, vec2(0.0)));
	                    _1538.x = _1546.x;
	                    _1538.y = _1546.y;
	                    vec3 _462 = normalize(_1538);
	                    vec2 _1553 = ((vec2(float((_321.y >> uint(1)) & 32767u), float((_321.y >> 16u) & 32767u)) * vec2(3.0518509447574615478515625e-05)) * 2.0) - vec2(1.0);
	                    float _1554 = _1553.x;
	                    float _1559 = (1.0 - abs(_1554)) - abs(_1553.y);
	                    vec3 _1560 = vec3(_1554, _1553.y, _1559);
	                    float _1562 = saturate(-_1559);
	                    vec2 _1568 = _1553 + mix(vec2(_1562), vec2(-_1562), greaterThanEqual(_1553, vec2(0.0)));
	                    _1560.x = _1568.x;
	                    _1560.y = _1568.y;
	                    vec3 _461 = normalize(_1560);
	                    float _445;
	                    if ((_321.y & 1u) != 0u)
	                    {
	                        _445 = 1.0;
	                    }
	                    else
	                    {
	                        _445 = -1.0;
	                    }
	                    _484[1] = _462;
	                    _485[1].w = _445;
	                    _485[1].x = _461.x;
	                    _485[1].y = _461.y;
	                    _485[1].z = _461.z;
	                    vec2 _1610 = ((vec2(float(_320.x & 65535u), float((_320.x >> 16u) & 65535u)) * vec2(1.525902189314365386962890625e-05)) * 2.0) - vec2(1.0);
	                    float _1611 = _1610.x;
	                    float _1616 = (1.0 - abs(_1611)) - abs(_1610.y);
	                    vec3 _1617 = vec3(_1611, _1610.y, _1616);
	                    float _1619 = saturate(-_1616);
	                    vec2 _1625 = _1610 + mix(vec2(_1619), vec2(-_1619), greaterThanEqual(_1610, vec2(0.0)));
	                    _1617.x = _1625.x;
	                    _1617.y = _1625.y;
	                    vec3 _464 = normalize(_1617);
	                    vec2 _1632 = ((vec2(float((_320.y >> uint(1)) & 32767u), float((_320.y >> 16u) & 32767u)) * vec2(3.0518509447574615478515625e-05)) * 2.0) - vec2(1.0);
	                    float _1633 = _1632.x;
	                    float _1638 = (1.0 - abs(_1633)) - abs(_1632.y);
	                    vec3 _1639 = vec3(_1633, _1632.y, _1638);
	                    float _1641 = saturate(-_1638);
	                    vec2 _1647 = _1632 + mix(vec2(_1641), vec2(-_1641), greaterThanEqual(_1632, vec2(0.0)));
	                    _1639.x = _1647.x;
	                    _1639.y = _1647.y;
	                    vec3 _463 = normalize(_1639);
	                    float _444;
	                    if ((_320.y & 1u) != 0u)
	                    {
	                        _444 = 1.0;
	                    }
	                    else
	                    {
	                        _444 = -1.0;
	                    }
	                    _484[2] = _464;
	                    _485[2].w = _444;
	                    _485[2].x = _463.x;
	                    _485[2].y = _463.y;
	                    _485[2].z = _463.z;
	                    break;
	                }
	                else
	                {
	                    uint _1150 = _1140.x / 4u;
	                    vec4 _466 = _485[0];
	                    float _1165 = (float((g_Vertices_3[_66]._member0[_1150] >> 12u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _1168 = (float((g_Vertices_3[_66]._member0[_1150] >> 22u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _1172 = (1.0 - abs(_1165)) - abs(_1168);
	                    vec3 _1173 = vec3(_1165, _1168, _1172);
	                    float _1175 = saturate(-_1172);
	                    vec2 _1176 = vec2(_1165, _1168);
	                    vec2 _1182 = _1176 + mix(vec2(_1175), vec2(-_1175), greaterThanEqual(_1176, vec2(0.0)));
	                    _1173.x = _1182.x;
	                    _1173.y = _1182.y;
	                    vec3 _1187 = normalize(_1173);
	                    vec3 _465 = _1187;
	                    float _1188 = _1187.z;
	                    float _453;
	                    if (_1188 >= 0.0)
	                    {
	                        _453 = 1.0;
	                    }
	                    else
	                    {
	                        _453 = -1.0;
	                    }
	                    float _1195 = (-1.0) / (_453 + _1188);
	                    float _1196 = _1187.x;
	                    vec3 _454;
	                    vec3 _1204 = _454;
	                    _1204.x = 1.0 + (((_453 * _1196) * _1196) * _1195);
	                    _1204.y = _453 * ((_1196 * _1187.y) * _1195);
	                    _1204.z = (-_453) * _1196;
	                    _454 = _1204;
	                    float _1212 = float((g_Vertices_3[_66]._member0[_1150] >> uint(1)) & 2047u) * 0.003069460391998291015625;
	                    vec3 _1218 = (_1204 * cos(_1212)) + (cross(_1187, _1204) * sin(_1212));
	                    vec4 _1220 = _466;
	                    _1220.x = _1218.x;
	                    _1220.y = _1218.y;
	                    _1220.z = _1218.z;
	                    _466 = _1220;
	                    float _455;
	                    if ((g_Vertices_3[_66]._member0[_1150] & 1u) == 0u)
	                    {
	                        _455 = -1.0;
	                    }
	                    else
	                    {
	                        _455 = 1.0;
	                    }
	                    vec4 _1231 = _466;
	                    _1231.w = _455;
	                    _466 = _1231;
	                    _484[0] = _465;
	                    _485[0] = _1231;
	                    uint _1235 = _1140.y / 4u;
	                    vec4 _468 = _485[1];
	                    float _1250 = (float((g_Vertices_3[_66]._member0[_1235] >> 12u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _1253 = (float((g_Vertices_3[_66]._member0[_1235] >> 22u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _1257 = (1.0 - abs(_1250)) - abs(_1253);
	                    vec3 _1258 = vec3(_1250, _1253, _1257);
	                    float _1260 = saturate(-_1257);
	                    vec2 _1261 = vec2(_1250, _1253);
	                    vec2 _1267 = _1261 + mix(vec2(_1260), vec2(-_1260), greaterThanEqual(_1261, vec2(0.0)));
	                    _1258.x = _1267.x;
	                    _1258.y = _1267.y;
	                    vec3 _1272 = normalize(_1258);
	                    vec3 _467 = _1272;
	                    float _1273 = _1272.z;
	                    float _450;
	                    if (_1273 >= 0.0)
	                    {
	                        _450 = 1.0;
	                    }
	                    else
	                    {
	                        _450 = -1.0;
	                    }
	                    float _1280 = (-1.0) / (_450 + _1273);
	                    float _1281 = _1272.x;
	                    vec3 _451;
	                    vec3 _1289 = _451;
	                    _1289.x = 1.0 + (((_450 * _1281) * _1281) * _1280);
	                    _1289.y = _450 * ((_1281 * _1272.y) * _1280);
	                    _1289.z = (-_450) * _1281;
	                    _451 = _1289;
	                    float _1297 = float((g_Vertices_3[_66]._member0[_1235] >> uint(1)) & 2047u) * 0.003069460391998291015625;
	                    vec3 _1303 = (_1289 * cos(_1297)) + (cross(_1272, _1289) * sin(_1297));
	                    vec4 _1305 = _468;
	                    _1305.x = _1303.x;
	                    _1305.y = _1303.y;
	                    _1305.z = _1303.z;
	                    _468 = _1305;
	                    float _452;
	                    if ((g_Vertices_3[_66]._member0[_1235] & 1u) == 0u)
	                    {
	                        _452 = -1.0;
	                    }
	                    else
	                    {
	                        _452 = 1.0;
	                    }
	                    vec4 _1316 = _468;
	                    _1316.w = _452;
	                    _468 = _1316;
	                    _484[1] = _467;
	                    _485[1] = _1316;
	                    uint _1320 = _1140.z / 4u;
	                    vec4 _470 = _485[2];
	                    float _1335 = (float((g_Vertices_3[_66]._member0[_1320] >> 12u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _1338 = (float((g_Vertices_3[_66]._member0[_1320] >> 22u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _1342 = (1.0 - abs(_1335)) - abs(_1338);
	                    vec3 _1343 = vec3(_1335, _1338, _1342);
	                    float _1345 = saturate(-_1342);
	                    vec2 _1346 = vec2(_1335, _1338);
	                    vec2 _1352 = _1346 + mix(vec2(_1345), vec2(-_1345), greaterThanEqual(_1346, vec2(0.0)));
	                    _1343.x = _1352.x;
	                    _1343.y = _1352.y;
	                    vec3 _1357 = normalize(_1343);
	                    vec3 _469 = _1357;
	                    float _1358 = _1357.z;
	                    float _447;
	                    if (_1358 >= 0.0)
	                    {
	                        _447 = 1.0;
	                    }
	                    else
	                    {
	                        _447 = -1.0;
	                    }
	                    float _1365 = (-1.0) / (_447 + _1358);
	                    float _1366 = _1357.x;
	                    vec3 _448;
	                    vec3 _1374 = _448;
	                    _1374.x = 1.0 + (((_447 * _1366) * _1366) * _1365);
	                    _1374.y = _447 * ((_1366 * _1357.y) * _1365);
	                    _1374.z = (-_447) * _1366;
	                    _448 = _1374;
	                    float _1382 = float((g_Vertices_3[_66]._member0[_1320] >> uint(1)) & 2047u) * 0.003069460391998291015625;
	                    vec3 _1388 = (_1374 * cos(_1382)) + (cross(_1357, _1374) * sin(_1382));
	                    vec4 _1390 = _470;
	                    _1390.x = _1388.x;
	                    _1390.y = _1388.y;
	                    _1390.z = _1388.z;
	                    _470 = _1390;
	                    float _449;
	                    if ((g_Vertices_3[_66]._member0[_1320] & 1u) == 0u)
	                    {
	                        _449 = -1.0;
	                    }
	                    else
	                    {
	                        _449 = 1.0;
	                    }
	                    vec4 _1401 = _470;
	                    _1401.w = _449;
	                    _470 = _1401;
	                    _484[2] = _469;
	                    _485[2] = _1401;
	                    break;
	                }
	                break;
	            }
	        }
	        else
	        {
	            _484[0] = vec3(0.0);
	            _484[1] = vec3(0.0);
	            _484[2] = vec3(0.0);
	        }
	        if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTangentFieldInfo.y != 0)
	        {
	            ivec4 _471 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers;
	            uint _70 = uint(_471[g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTangentFieldInfo.z]);
	            uint _1724 = uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTangentFieldInfo.z);
	            ivec4 _442 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes;
	            ivec4 _443 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes;
	            uvec3 _1740 = (uvec3(uint(_442[_1724])) * _486) + uvec3(uint(_443[_1724]) + uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vTangentFieldInfo.x));
	            uint _1742 = _1740.x;
	            _485[0] = vec4(g_Vertices_1[_70]._member0[_1742 / 4u], g_Vertices_1[_70]._member0[(_1742 + 4u) / 4u], g_Vertices_1[_70]._member0[(_1742 + 8u) / 4u], g_Vertices_1[_70]._member0[(_1742 + 12u) / 4u]);
	            uint _1760 = _1740.y;
	            _485[1] = vec4(g_Vertices_1[_70]._member0[_1760 / 4u], g_Vertices_1[_70]._member0[(_1760 + 4u) / 4u], g_Vertices_1[_70]._member0[(_1760 + 8u) / 4u], g_Vertices_1[_70]._member0[(_1760 + 12u) / 4u]);
	            uint _1778 = _1740.z;
	            _485[2] = vec4(g_Vertices_1[_70]._member0[_1778 / 4u], g_Vertices_1[_70]._member0[(_1778 + 4u) / 4u], g_Vertices_1[_70]._member0[(_1778 + 8u) / 4u], g_Vertices_1[_70]._member0[(_1778 + 12u) / 4u]);
	        }
	        else
	        {
	            _485[0] = vec4(0.0);
	            _485[1] = vec4(0.0);
	            _485[2] = vec4(0.0);
	        }
	        break;
	    } while(false);
	    _482 = 0;
	    for (;;)
	    {
	        if (!(_482 < 3))
	        {
	            break;
	        }
	        vsInput[_482].vNormalOs = _484[_482];
	        vsInput[_482].vTangentUOs_flTangentVSign = _485[_482];
	        _482++;
	        continue;
	    }
	    vec4 _488[3];
	    _488[0] = vec4(0.0);
	    _488[1] = vec4(0.0);
	    _488[2] = vec4(0.0);
	    if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vColorFieldInfo.data[0].y != 0)
	    {
	        ivec4 _441 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers;
	        uint _72 = uint(_441[g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vColorFieldInfo.data[0].z]);
	        uint _1836 = uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vColorFieldInfo.data[0].z);
	        ivec4 _439 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes;
	        ivec4 _440 = g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes;
	        uvec3 _1852 = (uvec3(uint(_439[_1836])) * _486) + uvec3(uint(_440[_1836]) + uint(g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vColorFieldInfo.data[0].x));
	        if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vColorFieldInfo.data[0].y == 2)
	        {
	            uint _1902 = _1852.x;
	            _488[0] = vec4(g_Vertices_1[_72]._member0[_1902 / 4u], g_Vertices_1[_72]._member0[(_1902 + 4u) / 4u], g_Vertices_1[_72]._member0[(_1902 + 8u) / 4u], g_Vertices_1[_72]._member0[(_1902 + 12u) / 4u]);
	            uint _1919 = _1852.y;
	            _488[1] = vec4(g_Vertices_1[_72]._member0[_1919 / 4u], g_Vertices_1[_72]._member0[(_1919 + 4u) / 4u], g_Vertices_1[_72]._member0[(_1919 + 8u) / 4u], g_Vertices_1[_72]._member0[(_1919 + 12u) / 4u]);
	            uint _1936 = _1852.z;
	            _488[2] = vec4(g_Vertices_1[_72]._member0[_1936 / 4u], g_Vertices_1[_72]._member0[(_1936 + 4u) / 4u], g_Vertices_1[_72]._member0[(_1936 + 8u) / 4u], g_Vertices_1[_72]._member0[(_1936 + 12u) / 4u]);
	        }
	        else
	        {
	            if (g_Geometries_1._member0[uint(gl_InstanceCustomIndexEXT)].m_vColorFieldInfo.data[0].y == 28)
	            {
	                uint _1861 = _1852.x / 4u;
	                _488[0] = vec4(uvec4(g_Vertices_3[_72]._member0[_1861] & 255u, (g_Vertices_3[_72]._member0[_1861] & 65280u) >> uint(8), (g_Vertices_3[_72]._member0[_1861] & 16711680u) >> uint(16), (g_Vertices_3[_72]._member0[_1861] & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	                uint _1875 = _1852.y / 4u;
	                _488[1] = vec4(uvec4(g_Vertices_3[_72]._member0[_1875] & 255u, (g_Vertices_3[_72]._member0[_1875] & 65280u) >> uint(8), (g_Vertices_3[_72]._member0[_1875] & 16711680u) >> uint(16), (g_Vertices_3[_72]._member0[_1875] & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	                uint _1889 = _1852.z / 4u;
	                _488[2] = vec4(uvec4(g_Vertices_3[_72]._member0[_1889] & 255u, (g_Vertices_3[_72]._member0[_1889] & 65280u) >> uint(8), (g_Vertices_3[_72]._member0[_1889] & 16711680u) >> uint(16), (g_Vertices_3[_72]._member0[_1889] & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	            }
	        }
	    }
	    int _489 = 0;
	    for (;;)
	    {
	        if (!(_489 < 3))
	        {
	            break;
	        }
	        vsInput[_489].vBlendColorTint = _488[_489];
	        _489++;
	        continue;
	    }
	    vec2 _331 = vsInput[0].vTexCoord;
	    vec3 _437 = vsInput[0].vNormalOs;
	    vec4 _438;
	    vec4 _1979 = _438;
	    _1979.x = vsInput[0].vTangentUOs_flTangentVSign.x;
	    _1979.y = vsInput[0].vTangentUOs_flTangentVSign.y;
	    _1979.z = vsInput[0].vTangentUOs_flTangentVSign.z;
	    _1979.w = vsInput[0].vTangentUOs_flTangentVSign.w;
	    _438 = _1979;
	    PackedRtxInstanceData_t_natural_logical _1992;
	    _1992.nSrgbColor = g_instanceBuffer._member0[uint(gl_InstanceID)].nSrgbColor;
	    _1992.nTriangleGeometry = g_instanceBuffer._member0[uint(gl_InstanceID)].nTriangleGeometry;
	    _1992.nMaterialData = g_instanceBuffer._member0[uint(gl_InstanceID)].nMaterialData;
	    _1992.nMaterialFlags_nInstanceFlags = g_instanceBuffer._member0[uint(gl_InstanceID)].nMaterialFlags_nInstanceFlags;
	    _1992.fEmissiveBoost = g_instanceBuffer._member0[uint(gl_InstanceID)].fEmissiveBoost;
	    _1992.nInstanceFlags = g_instanceBuffer._member0[uint(gl_InstanceID)].nInstanceFlags;
	    _1992._pad1 = g_instanceBuffer._member0[uint(gl_InstanceID)]._pad1;
	    _1992._pad2 = g_instanceBuffer._member0[uint(gl_InstanceID)]._pad2;
	    vec4 _2003 = vec4(uvec4(_1992.nSrgbColor & 255u, (_1992.nSrgbColor & 65280u) >> uint(8), (_1992.nSrgbColor & 16711680u) >> uint(16), (_1992.nSrgbColor & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	    vec4 _436 = _2003;
	    vec3 _2004 = _2003.xyz;
	    vec3 _2005 = _2004 * vec3(0.077399380505084991455078125);
	    vec3 _2008 = pow((_2004 * vec3(0.947867333889007568359375)) + vec3(0.052132703363895416259765625), vec3(2.400000095367431640625));
	    float _433;
	    if (_2003.x <= 0.040449999272823333740234375)
	    {
	        _433 = _2005.x;
	    }
	    else
	    {
	        _433 = _2008.x;
	    }
	    float _434;
	    if (_2003.y <= 0.040449999272823333740234375)
	    {
	        _434 = _2005.y;
	    }
	    else
	    {
	        _434 = _2008.y;
	    }
	    float _435;
	    if (_2003.z <= 0.040449999272823333740234375)
	    {
	        _435 = _2005.z;
	    }
	    else
	    {
	        _435 = _2008.z;
	    }
	    vec3 _2033 = vec3(_433, _434, _435);
	    vec4 _2035 = _436;
	    _2035.x = _2033.x;
	    _2035.y = _2033.y;
	    _2035.z = _2033.z;
	    _436 = _2035;
	    vec4 _334;
	    vec4 _2042 = _334;
	    _2042.x = _2035.x;
	    _2042.y = _2035.y;
	    _2042.z = _2035.z;
	    _2042.w = _2035.w;
	    _334 = _2042;
	    mat3x4 _2053 = transpose(gl_WorldToObjectEXT);
	    mat3 _432;
	    mat3 _2056 = _432;
	    _2056[0] = _2053[0].xyz;
	    _2056[1] = _2053[1].xyz;
	    _2056[2] = _2053[2].xyz;
	    _432 = _2056;
	    vec3 _2065 = normalize(_2056 * _437.xyz);
	    vec3 _335;
	    vec3 _2067 = _335;
	    _2067.x = _2065.x;
	    _2067.y = _2065.y;
	    _2067.z = _2065.z;
	    _335 = _2067;
	    mat3x4 _2079 = transpose(gl_WorldToObjectEXT);
	    mat3 _431;
	    mat3 _2082 = _431;
	    _2082[0] = _2079[0].xyz;
	    _2082[1] = _2079[1].xyz;
	    _2082[2] = _2079[2].xyz;
	    _431 = _2082;
	    vec3 _2091 = normalize(_2082 * _438.xyz);
	    vec4 _333;
	    vec4 _2093 = _333;
	    _2093.x = _2091.x;
	    _2093.y = _2091.y;
	    _2093.z = _2091.z;
	    _2093.w = _438.w;
	    _333 = _2093;
	    vec4 _2102 = _331.xyxy;
	    vec4 _2115 = _2102;
	    _2115.x = dot(_2102.xy, _385.xy) + _385.w;
	    _2115.y = dot(_2102.xy, _384.xy) + _384.w;
	    vec2 _2123 = _2115.xy + (_383.xy * PerViewConstantBuffer_t.g_flGameTime);
	    vec4 _2125 = _2115;
	    _2125.x = _2123.x;
	    _2125.y = _2123.y;
	    vec3 _2131 = mix(vec3(1.0), _2042.xyz, vec3(_381));
	    vec4 _2133 = _2042;
	    _2133.x = _2131.x;
	    _2133.y = _2131.y;
	    _2133.z = _2131.z;
	    vec3 _2141 = _2133.xyz * _382.xyz;
	    vec4 _2143 = _2133;
	    _2143.x = _2141.x;
	    _2143.y = _2141.y;
	    _2143.z = _2141.z;
	    vec3 _319 = vec4(vsInput[0].vPositionOs.xyz, 1.0) * transpose(gl_ObjectToWorldEXT);
	    vec3 _318 = _2067;
	    vec4 _317 = _2125;
	    vec4 _316 = _2143;
	    vec4 _315 = _2093;
	    vec2 _330 = vsInput[1].vTexCoord;
	    vec3 _429 = vsInput[1].vNormalOs;
	    vec4 _430;
	    vec4 _2155 = _430;
	    _2155.x = vsInput[1].vTangentUOs_flTangentVSign.x;
	    _2155.y = vsInput[1].vTangentUOs_flTangentVSign.y;
	    _2155.z = vsInput[1].vTangentUOs_flTangentVSign.z;
	    _2155.w = vsInput[1].vTangentUOs_flTangentVSign.w;
	    _430 = _2155;
	    PackedRtxInstanceData_t_natural_logical _2168;
	    _2168.nSrgbColor = g_instanceBuffer._member0[uint(gl_InstanceID)].nSrgbColor;
	    _2168.nTriangleGeometry = g_instanceBuffer._member0[uint(gl_InstanceID)].nTriangleGeometry;
	    _2168.nMaterialData = g_instanceBuffer._member0[uint(gl_InstanceID)].nMaterialData;
	    _2168.nMaterialFlags_nInstanceFlags = g_instanceBuffer._member0[uint(gl_InstanceID)].nMaterialFlags_nInstanceFlags;
	    _2168.fEmissiveBoost = g_instanceBuffer._member0[uint(gl_InstanceID)].fEmissiveBoost;
	    _2168.nInstanceFlags = g_instanceBuffer._member0[uint(gl_InstanceID)].nInstanceFlags;
	    _2168._pad1 = g_instanceBuffer._member0[uint(gl_InstanceID)]._pad1;
	    _2168._pad2 = g_instanceBuffer._member0[uint(gl_InstanceID)]._pad2;
	    vec4 _2179 = vec4(uvec4(_2168.nSrgbColor & 255u, (_2168.nSrgbColor & 65280u) >> uint(8), (_2168.nSrgbColor & 16711680u) >> uint(16), (_2168.nSrgbColor & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	    vec4 _428 = _2179;
	    vec3 _2180 = _2179.xyz;
	    vec3 _2181 = _2180 * vec3(0.077399380505084991455078125);
	    vec3 _2184 = pow((_2180 * vec3(0.947867333889007568359375)) + vec3(0.052132703363895416259765625), vec3(2.400000095367431640625));
	    float _425;
	    if (_2179.x <= 0.040449999272823333740234375)
	    {
	        _425 = _2181.x;
	    }
	    else
	    {
	        _425 = _2184.x;
	    }
	    float _426;
	    if (_2179.y <= 0.040449999272823333740234375)
	    {
	        _426 = _2181.y;
	    }
	    else
	    {
	        _426 = _2184.y;
	    }
	    float _427;
	    if (_2179.z <= 0.040449999272823333740234375)
	    {
	        _427 = _2181.z;
	    }
	    else
	    {
	        _427 = _2184.z;
	    }
	    vec3 _2209 = vec3(_425, _426, _427);
	    vec4 _2211 = _428;
	    _2211.x = _2209.x;
	    _2211.y = _2209.y;
	    _2211.z = _2209.z;
	    _428 = _2211;
	    vec4 _337;
	    vec4 _2218 = _337;
	    _2218.x = _2211.x;
	    _2218.y = _2211.y;
	    _2218.z = _2211.z;
	    _2218.w = _2211.w;
	    _337 = _2218;
	    mat3x4 _2229 = transpose(gl_WorldToObjectEXT);
	    mat3 _424;
	    mat3 _2232 = _424;
	    _2232[0] = _2229[0].xyz;
	    _2232[1] = _2229[1].xyz;
	    _2232[2] = _2229[2].xyz;
	    _424 = _2232;
	    vec3 _2241 = normalize(_2232 * _429.xyz);
	    vec3 _338;
	    vec3 _2243 = _338;
	    _2243.x = _2241.x;
	    _2243.y = _2241.y;
	    _2243.z = _2241.z;
	    _338 = _2243;
	    mat3x4 _2255 = transpose(gl_WorldToObjectEXT);
	    mat3 _423;
	    mat3 _2258 = _423;
	    _2258[0] = _2255[0].xyz;
	    _2258[1] = _2255[1].xyz;
	    _2258[2] = _2255[2].xyz;
	    _423 = _2258;
	    vec3 _2267 = normalize(_2258 * _430.xyz);
	    vec4 _336;
	    vec4 _2269 = _336;
	    _2269.x = _2267.x;
	    _2269.y = _2267.y;
	    _2269.z = _2267.z;
	    _2269.w = _430.w;
	    _336 = _2269;
	    vec4 _2278 = _330.xyxy;
	    vec4 _2291 = _2278;
	    _2291.x = dot(_2278.xy, _385.xy) + _385.w;
	    _2291.y = dot(_2278.xy, _384.xy) + _384.w;
	    vec2 _2299 = _2291.xy + (_383.xy * PerViewConstantBuffer_t.g_flGameTime);
	    vec4 _2301 = _2291;
	    _2301.x = _2299.x;
	    _2301.y = _2299.y;
	    vec3 _2307 = mix(vec3(1.0), _2218.xyz, vec3(_381));
	    vec4 _2309 = _2218;
	    _2309.x = _2307.x;
	    _2309.y = _2307.y;
	    _2309.z = _2307.z;
	    vec3 _2317 = _2309.xyz * _382.xyz;
	    vec4 _2319 = _2309;
	    _2319.x = _2317.x;
	    _2319.y = _2317.y;
	    _2319.z = _2317.z;
	    vec3 _314 = vec4(vsInput[1].vPositionOs.xyz, 1.0) * transpose(gl_ObjectToWorldEXT);
	    vec3 _313 = _2243;
	    vec4 _312 = _2301;
	    vec4 _311 = _2319;
	    vec4 _310 = _2269;
	    vec2 _329 = vsInput[2].vTexCoord;
	    vec3 _421 = vsInput[2].vNormalOs;
	    vec4 _422;
	    vec4 _2331 = _422;
	    _2331.x = vsInput[2].vTangentUOs_flTangentVSign.x;
	    _2331.y = vsInput[2].vTangentUOs_flTangentVSign.y;
	    _2331.z = vsInput[2].vTangentUOs_flTangentVSign.z;
	    _2331.w = vsInput[2].vTangentUOs_flTangentVSign.w;
	    _422 = _2331;
	    PackedRtxInstanceData_t_natural_logical _2344;
	    _2344.nSrgbColor = g_instanceBuffer._member0[uint(gl_InstanceID)].nSrgbColor;
	    _2344.nTriangleGeometry = g_instanceBuffer._member0[uint(gl_InstanceID)].nTriangleGeometry;
	    _2344.nMaterialData = g_instanceBuffer._member0[uint(gl_InstanceID)].nMaterialData;
	    _2344.nMaterialFlags_nInstanceFlags = g_instanceBuffer._member0[uint(gl_InstanceID)].nMaterialFlags_nInstanceFlags;
	    _2344.fEmissiveBoost = g_instanceBuffer._member0[uint(gl_InstanceID)].fEmissiveBoost;
	    _2344.nInstanceFlags = g_instanceBuffer._member0[uint(gl_InstanceID)].nInstanceFlags;
	    _2344._pad1 = g_instanceBuffer._member0[uint(gl_InstanceID)]._pad1;
	    _2344._pad2 = g_instanceBuffer._member0[uint(gl_InstanceID)]._pad2;
	    vec4 _2355 = vec4(uvec4(_2344.nSrgbColor & 255u, (_2344.nSrgbColor & 65280u) >> uint(8), (_2344.nSrgbColor & 16711680u) >> uint(16), (_2344.nSrgbColor & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	    vec4 _420 = _2355;
	    vec3 _2356 = _2355.xyz;
	    vec3 _2357 = _2356 * vec3(0.077399380505084991455078125);
	    vec3 _2360 = pow((_2356 * vec3(0.947867333889007568359375)) + vec3(0.052132703363895416259765625), vec3(2.400000095367431640625));
	    float _417;
	    if (_2355.x <= 0.040449999272823333740234375)
	    {
	        _417 = _2357.x;
	    }
	    else
	    {
	        _417 = _2360.x;
	    }
	    float _418;
	    if (_2355.y <= 0.040449999272823333740234375)
	    {
	        _418 = _2357.y;
	    }
	    else
	    {
	        _418 = _2360.y;
	    }
	    float _419;
	    if (_2355.z <= 0.040449999272823333740234375)
	    {
	        _419 = _2357.z;
	    }
	    else
	    {
	        _419 = _2360.z;
	    }
	    vec3 _2385 = vec3(_417, _418, _419);
	    vec4 _2387 = _420;
	    _2387.x = _2385.x;
	    _2387.y = _2385.y;
	    _2387.z = _2385.z;
	    _420 = _2387;
	    vec4 _340;
	    vec4 _2394 = _340;
	    _2394.x = _2387.x;
	    _2394.y = _2387.y;
	    _2394.z = _2387.z;
	    _2394.w = _2387.w;
	    _340 = _2394;
	    mat3x4 _2405 = transpose(gl_WorldToObjectEXT);
	    mat3 _416;
	    mat3 _2408 = _416;
	    _2408[0] = _2405[0].xyz;
	    _2408[1] = _2405[1].xyz;
	    _2408[2] = _2405[2].xyz;
	    _416 = _2408;
	    vec3 _2417 = normalize(_2408 * _421.xyz);
	    vec3 _341;
	    vec3 _2419 = _341;
	    _2419.x = _2417.x;
	    _2419.y = _2417.y;
	    _2419.z = _2417.z;
	    _341 = _2419;
	    vec3 _2427 = vec4(vsInput[2].vPositionOs.xyz, 1.0) * transpose(gl_ObjectToWorldEXT);
	    mat3x4 _2431 = transpose(gl_WorldToObjectEXT);
	    mat3 _415;
	    mat3 _2434 = _415;
	    _2434[0] = _2431[0].xyz;
	    _2434[1] = _2431[1].xyz;
	    _2434[2] = _2431[2].xyz;
	    _415 = _2434;
	    vec3 _2443 = normalize(_2434 * _422.xyz);
	    vec4 _339;
	    vec4 _2445 = _339;
	    _2445.x = _2443.x;
	    _2445.y = _2443.y;
	    _2445.z = _2443.z;
	    _2445.w = _422.w;
	    _339 = _2445;
	    vec4 _2454 = _329.xyxy;
	    vec4 _2467 = _2454;
	    _2467.x = dot(_2454.xy, _385.xy) + _385.w;
	    _2467.y = dot(_2454.xy, _384.xy) + _384.w;
	    vec2 _2475 = _2467.xy + (_383.xy * PerViewConstantBuffer_t.g_flGameTime);
	    vec4 _2477 = _2467;
	    _2477.x = _2475.x;
	    _2477.y = _2475.y;
	    vec3 _2483 = mix(vec3(1.0), _2394.xyz, vec3(_381));
	    vec4 _2485 = _2394;
	    _2485.x = _2483.x;
	    _2485.y = _2483.y;
	    _2485.z = _2483.z;
	    vec3 _2493 = _2485.xyz * _382.xyz;
	    vec4 _2495 = _2485;
	    _2495.x = _2493.x;
	    _2495.y = _2493.y;
	    _2495.z = _2493.z;
	    vec3 _309 = _2427;
	    vec3 _308 = _2419;
	    vec3 _2520 = ((_318 * ((1.0 - attrs.barycentrics.x) - attrs.barycentrics.y)) + (_313 * attrs.barycentrics.x)) + (_2419 * attrs.barycentrics.y);
	    vec3 _342;
	    vec3 _328 = _2520;
	    vec4 _327 = ((_317 * ((1.0 - attrs.barycentrics.x) - attrs.barycentrics.y)) + (_312 * attrs.barycentrics.x)) + (_2477 * attrs.barycentrics.y);
	    vec4 _326 = ((_316 * ((1.0 - attrs.barycentrics.x) - attrs.barycentrics.y)) + (_311 * attrs.barycentrics.x)) + (_2495 * attrs.barycentrics.y);
	    vec3 _325 = _342;
	    vec4 _324 = ((_315 * ((1.0 - attrs.barycentrics.x) - attrs.barycentrics.y)) + (_310 * attrs.barycentrics.x)) + (_2445 * attrs.barycentrics.y);
	    vec3 _323 = normalize(cross(_314 - _319, _2427 - _319));
	    bool _322 = gl_HitKindEXT == 254u;
	    vec3 _368 = vec3(0.0);
	    float _367 = 0.039999999105930328369140625;
	    vec3 _366 = vec3(0.0);
	    vec3 _364 = vec3(1.0);
	    bool _363 = false;
	    vec3 _2555 = _2520.xyz;
	    vec3 _365 = _2555;
	    if (dot(_2555, _2555) >= 1.0099999904632568359375)
	    {
	        _365 = _325.xyz;
	    }
	    _367 = _377;
	    _364 = _323;
	    bool _410;
	    if (_378)
	    {
	        _410 = !_379;
	    }
	    else
	    {
	        _410 = false;
	    }
	    SPIRV_CROSS_BRANCH
	    if (_410)
	    {
	        float _411;
	        if (_322)
	        {
	            _411 = 1.0;
	        }
	        else
	        {
	            _411 = -1.0;
	        }
	        _365 *= _411;
	        if (_322)
	        {
	            _411 = 1.0;
	        }
	        else
	        {
	            _411 = -1.0;
	        }
	        _364 *= _411;
	        _363 = !_322;
	    }
	    vec3 _2587 = _365;
	    vec3 _2588 = normalize(_2587);
	    _365 = _2588;
	    vec3 _359 = _368;
	    float _358 = _367;
	    vec3 _357 = _366;
	    vec3 _356 = _2588;
	    vec3 _355 = _364;
	    bool _354 = _363;
	    vec3 _362 = textureLod(sampler2D(g_bindless_Texture2D_float4[_380], g_bindless_Sampler[_386]), _327.xy, 0.0).xyz * _326.xyz;
	    float _360 = 0.0;
	    vec4 _2612 = textureLod(sampler2D(g_bindless_Texture2D_float4[_376], g_bindless_Sampler[_387]), _327.xy, 0.0);
	    float _2613 = _2612.x;
	    float _2614 = _2612.y;
	    float _2616 = (_2613 + _2614) - 1.00392162799835205078125;
	    float _2617 = _2613 - _2614;
	    vec2 _361 = _2612.zz;
	    vec3 _408 = normalize(vec3(vec2(_2616, _2617), (1.0 - abs(_2616)) - abs(_2617)));
	    bool _406;
	    if (_378)
	    {
	        _406 = !_379;
	    }
	    else
	    {
	        _406 = false;
	    }
	    if (_406)
	    {
	        float _407;
	        if (_322)
	        {
	            _407 = 1.0;
	        }
	        else
	        {
	            _407 = -1.0;
	        }
	        _406 = _407 < 0.0;
	    }
	    else
	    {
	        _406 = false;
	    }
	    float _409;
	    if (_406)
	    {
	        _409 = -1.0;
	    }
	    else
	    {
	        _409 = 1.0;
	    }
	    float _2648 = _409;
	    vec3 _2649 = _328.xyz * _2648;
	    if (_324.w > 0.0)
	    {
	        _409 = 1.0;
	    }
	    else
	    {
	        _409 = -1.0;
	    }
	    bool _404;
	    if (_378)
	    {
	        _404 = !_379;
	    }
	    else
	    {
	        _404 = false;
	    }
	    if (_404)
	    {
	        float _405;
	        if (_322)
	        {
	            _405 = 1.0;
	        }
	        else
	        {
	            _405 = -1.0;
	        }
	        _404 = _405 < 0.0;
	    }
	    else
	    {
	        _404 = false;
	    }
	    if (!_404)
	    {
	        vec3 _2681 = _408;
	        _2681.y = -_2681.y;
	        _408 = _2681;
	    }
	    vec3 _2688 = _324.xyz * _408.x;
	    vec3 _403;
	    vec3 _2690 = _403;
	    _2690.x = _2688.x;
	    _2690.y = _2688.y;
	    _2690.z = _2688.z;
	    vec3 _2700 = _2690.xyz + ((cross(_2649.xyz, _324.xyz) * _409).xyz * _408.y);
	    vec3 _2702 = _2690;
	    _2702.x = _2700.x;
	    _2702.y = _2700.y;
	    _2702.z = _2700.z;
	    vec3 _2711 = _2702.xyz + (_2649.xyz * _408.z);
	    vec3 _2713 = _2702;
	    _2713.x = _2711.x;
	    _2713.y = _2711.y;
	    _2713.z = _2711.z;
	    _403 = _2713;
	    vec3 _353 = normalize(_2713.xyz);
	    vec3 _352 = _362;
	    vec2 _351 = _361;
	    float _350 = _360;
	    vec3 _349 = _359;
	    float _348 = _358;
	    vec3 _347 = _357;
	    vec3 _346 = _356;
	    vec3 _345 = _355;
	    bool _344 = _354;
	    vec3 _343 = _408;
	    vec4 _2746 = max(vec4((vec4(vec4(_362.xyz, 1.0).xyz, 1.0) * _374).xyz, 1.0), vec4(0.0));
	    vec3 _412;
	    if (_375)
	    {
	        _412 = max(vec4((vec4(vec4(_362.xyz, 1.0).xyz, 1.0) * _373).xyz, 1.0), vec4(0.0)).xyz;
	    }
	    else
	    {
	        _412 = _352.xyz;
	    }
	    vec3 _2756 = _352;
	    vec3 _2757 = _2756;
	    _2757.x = _412.x;
	    vec3 _2759 = _2756;
	    _2759.y = _412.y;
	    vec3 _2761 = _2756;
	    _2761.z = _412.z;
	    vec3 _2763 = _2756;
	    _2763.x = _2746.x;
	    _2763.y = _2746.y;
	    _2763.z = _2746.z;
	    _352 = _2763;
	    SPIRV_CROSS_BRANCH
	    if (_369 != 1.0)
	    {
	        vec3 _2772 = _343;
	        vec2 _2775 = _2772.yx * _369;
	        vec3 _2777 = _2772;
	        _2777.y = _2775.x;
	        _2777.x = _2775.y;
	        _343 = _2777;
	        vec3 _401 = _2777;
	        bool _399;
	        if (_378)
	        {
	            _399 = !_379;
	        }
	        else
	        {
	            _399 = false;
	        }
	        if (_399)
	        {
	            float _400;
	            if (_322)
	            {
	                _400 = 1.0;
	            }
	            else
	            {
	                _400 = -1.0;
	            }
	            _399 = _400 < 0.0;
	        }
	        else
	        {
	            _399 = false;
	        }
	        float _402;
	        if (_399)
	        {
	            _402 = -1.0;
	        }
	        else
	        {
	            _402 = 1.0;
	        }
	        float _2802 = _402;
	        vec3 _2803 = _328.xyz * _2802;
	        if (_324.w > 0.0)
	        {
	            _402 = 1.0;
	        }
	        else
	        {
	            _402 = -1.0;
	        }
	        bool _397;
	        if (_378)
	        {
	            _397 = !_379;
	        }
	        else
	        {
	            _397 = false;
	        }
	        if (_397)
	        {
	            float _398;
	            if (_322)
	            {
	                _398 = 1.0;
	            }
	            else
	            {
	                _398 = -1.0;
	            }
	            _397 = _398 < 0.0;
	        }
	        else
	        {
	            _397 = false;
	        }
	        if (!_397)
	        {
	            vec3 _2835 = _401;
	            _2835.y = -_2835.y;
	            _401 = _2835;
	        }
	        _343 = _401;
	        vec3 _2842 = _324.xyz * _401.x;
	        vec3 _396;
	        vec3 _2844 = _396;
	        _2844.x = _2842.x;
	        _2844.y = _2842.y;
	        _2844.z = _2842.z;
	        vec3 _2854 = _2844.xyz + ((cross(_2803.xyz, _324.xyz) * _402).xyz * _401.y);
	        vec3 _2856 = _2844;
	        _2856.x = _2854.x;
	        _2856.y = _2854.y;
	        _2856.z = _2854.z;
	        vec3 _2865 = _2856.xyz + (_2803.xyz * _401.z);
	        vec3 _2867 = _2856;
	        _2867.x = _2865.x;
	        _2867.y = _2865.y;
	        _2867.z = _2865.z;
	        _396 = _2867;
	        _353 = normalize(_2867.xyz);
	    }
	    float _413;
	    if (_370)
	    {
	        _413 = _372;
	    }
	    else
	    {
	        _413 = _372;
	    }
	    float _414;
	    if (_370)
	    {
	        _414 = _371;
	    }
	    else
	    {
	        _414 = _371;
	    }
	    vec2 _2886 = _351;
	    vec2 _2891 = ((_2886.xy - vec2(0.5)) * _413) + vec2(0.5);
	    vec2 _2893 = _2886;
	    _2893.x = _2891.x;
	    _2893.y = _2891.y;
	    vec2 _2899 = saturate(_2893.xy * _414);
	    vec2 _2901 = _2893;
	    _2901.x = _2899.x;
	    _2901.y = _2899.y;
	    _351 = _2901;
	    payload.nInstance = int(uint(gl_InstanceID));
	    payload.flHitT = gl_RayTmaxEXT;
	    payload.vFaceNormalWs = _345;
	    payload.vInterpolatedNormalWs = _346;
	    vec3 _394[3] = vec3[](_319, _314, _309);
	    vec3 _395[3] = vec3[](_318, _313, _308);
	    vec3 _2944 = ((_394[0] * ((1.0 - attrs.barycentrics.x) - attrs.barycentrics.y)) + (_394[1] * attrs.barycentrics.x)) + (_394[2] * attrs.barycentrics.y);
	    vec3 _388[3];
	    _388[0] = _2944 - (_395[0] * dot(_2944 - _394[0], _395[0]));
	    _388[1] = _2944 - (_395[1] * dot(_2944 - _394[1], _395[1]));
	    _388[2] = _2944 - (_395[2] * dot(_2944 - _394[2], _395[2]));
	    vec3 _2984 = ((_388[0] * ((1.0 - attrs.barycentrics.x) - attrs.barycentrics.y)) + (_388[1] * attrs.barycentrics.x)) + (_388[2] * attrs.barycentrics.y);
	    vec3 _389[3];
	    _389[0] = cross(_394[0] - _394[1], _345);
	    _389[1] = cross(_394[1] - _394[2], _345);
	    _389[2] = cross(_394[2] - _394[0], _345);
	    float _390 = dot(_2984 - _2944, _345);
	    vec3 _391 = _2984;
	    int _392 = 0;
	    for (;;)
	    {
	        bool _3000_ladder_break = false;
	        do
	        {
	            if (!(_392 < 3))
	            {
	                _3000_ladder_break = true;
	                break;
	            }
	            if (_390 > 0.00999999977648258209228515625)
	            {
	                _3000_ladder_break = true;
	                break;
	            }
	            if (dot(_389[_392], _389[_392]) == 0.0)
	            {
	                break;
	            }
	            _389[_392] = normalize(_389[_392]);
	            int _393 = 0;
	            for (;;)
	            {
	                if (!(_393 < 3))
	                {
	                    break;
	                }
	                vec3 _3038 = _395[_393] - (_389[_392] * dot(_389[_392], _395[_393]));
	                _388[_393] = _2944 - (_3038 * dot(_2944 - _394[_393], _3038));
	                _393++;
	                continue;
	            }
	            vec3 _3062 = ((_388[0] * ((1.0 - attrs.barycentrics.x) - attrs.barycentrics.y)) + (_388[1] * attrs.barycentrics.x)) + (_388[2] * attrs.barycentrics.y);
	            _390 = dot(_3062 - _2944, _345);
	            _391 = _3062;
	            break;
	        } while(false);
	        if (_3000_ladder_break)
	        {
	            break;
	        }
	        _392++;
	        continue;
	    }
	    if (!(_390 > 0.00999999977648258209228515625))
	    {
	        _391 = vec3(3.4028234663852885981170418348452e+38);
	    }
	    payload.vSmoothPositionWs = _391;
	    payload.bFlippedNormal = _344;
	    f16vec3 _3075 = f16vec3(vec3(0.0));
	    payload.material = MaterialDataMinimal_t(_3075, float16_t(0.0), f16vec3(vec3(1.0, 0.0, 1.0)), float16_t(1.0), _3075, float16_t(0.040008544921875), 0u, f16vec4(ivec4(0)));
	    payload.material.vNormalWs = f16vec3(_353);
	    payload.material.vAlbedo = f16vec3(_352);
	    payload.material.vEmissive = f16vec3(_349);
	    payload.material.flReflectance = float16_t(_348);
	    payload.material.flMetalness = float16_t(_350);
	    payload.material.flRoughness = float16_t(dot(_2901, vec2(0.5)));
	    if (any(greaterThan(_347, vec3(0.0))))
	    {
	        payload.material.nMaterialTypeAndFlags = (payload.material.nMaterialTypeAndFlags & 4294901760u) | 1u;
	        f16vec3 _3101 = f16vec3(_347);
	        payload.material.vMaterialBits.x = _3101.x;
	        payload.material.vMaterialBits.y = _3101.y;
	        payload.material.vMaterialBits.z = _3101.z;
	    }
	}
	
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
	
	BoolAttribute(BindlessResources, true);
	IntAttribute(RayTypeCount, 2);
	BoolAttribute(DoNotRenderIntoSST, F_ANIMATED_SHADOWS);
	BoolAttribute(CanBatchWithDynamicShaderConstants, true);
	Float3Attribute(LightSim_MaterialTint, g_vColorTint);
	TextureAttribute(LightSim_DiffuseAlbedoTexture, g_tColor);
	TextureAttribute(RepresentativeTexture, g_tColor);
	BoolAttribute(NeedsLightProbe, true);
	BoolAttribute(DoNotCastShadows, F_DO_NOT_CAST_SHADOWS || 0);
	BoolAttribute(SupportsMappingDimensions, true);
	BoolAttribute(renderbackfaces, F_RENDER_BACKFACES || 0);
	BoolAttribute(SupportsLightmapping, true);
	BoolAttribute(PerVertexLighting, true);
	BoolAttribute(AllowBackfaceCulling, F_RENDER_BACKFACES ? 0 : 1);
	BoolAttribute(DoubleSided, F_RENDER_BACKFACES);
	BoolAttribute(SupportsAggregateInstancing, F_FOLIAGE_ANIMATION==0);
	BoolAttribute(IgnoreFaceNormalsForLighting, true);
	
	#if (S_MODE_DEPTH == 0)
		TextureAttribute(LightSim_TintMaskTextureR, g_tTintMask);
	#endif
	#if (S_TINT_MASK == 0)
		TextureAttribute(LightSim_Opacity_A, g_tColor);
		BoolAttribute(alphatest, true);
		BoolAttribute(NoZPrepass, true);
		BoolAttribute(AlphaTestZPrepass, true);
	#endif
	#if (S_VERTEX_ANIMATION == 0)
		TextureAttribute(LightSim_TintMaskTextureR, g_tTintMask);
	#endif
	#if (S_ALPHA_TEST == 1)
		TextureAttribute(LightSim_Opacity_A, g_tColor);
		BoolAttribute(alphatest, true);
		BoolAttribute(NoZPrepass, true);
		BoolAttribute(AlphaTestZPrepass, true);
	#endif
	#if (S_ALPHA_TEST == 0)
		BoolAttribute(NoZPrepass, F_DISABLE_Z_PREPASS || 0);
	#endif
	#if (S_TINT_MASK == 1)
		TextureAttribute(LightSim_TintMaskTextureR, g_tTintMask);
	#endif
	#if (S_MODE_TOOLS_SHADING_COMPLEXITY == 0)
		TextureAttribute(LightSim_TintMaskTextureR, g_tTintMask);
	#endif
	#if (S_MODE_TOOLS_VIS == 0)
		TextureAttribute(LightSim_TintMaskTextureR, g_tTintMask);
	#endif
	#if (S_SHADER_QUALITY == 0)
		TextureAttribute(LightSim_TintMaskTextureR, g_tTintMask);
	#endif
	#if (S_FOLIAGE_ANIMATION == 0)
		TextureAttribute(LightSim_TintMaskTextureR, g_tTintMask);
	#endif
	#if (S_FOLIAGE_UV_ANIMATION == 0)
		TextureAttribute(LightSim_TintMaskTextureR, g_tTintMask);
	#endif
}
