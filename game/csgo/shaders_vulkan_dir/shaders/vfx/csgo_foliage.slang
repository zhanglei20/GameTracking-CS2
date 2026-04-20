//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "Foliage Shader";
	DevShader = false;
	Version = 9;
	
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
	
	cbuffer BakedLightingConstantBuffer_t < Attribute("BakedLightingConstantBuffer_t"); >;
	cbuffer PerViewConstantBufferCsgo_t < Attribute("PerViewConstantBufferCsgo_t"); >;
	cbuffer PerViewConstantBuffer_t < Attribute("PerViewConstantBuffer_t"); >;
	ByteAddressBuffer g_animatedVertexCache < Attribute("AnimatedVertexCache"); SrgbRead(false); >;
	Texture3D g_bindless_Texture3D_float4 < Source(ExternalDescSet); SrgbRead(false); >;
	ExternalDescriptorSet g_globalLateBoundBindlessSet < Source(ExternalDescSet); Attribute("g_globalLateBoundBindlessSet"); >;
	StructuredBuffer g_instanceBuffer < Attribute("InstanceBuffer"); SrgbRead(false); >;
	ExternalDescriptorSet g_lightBinnerGpuSet < Source(ExternalDescSet); Attribute("g_lightBinnerGpuSet"); >;
	StructuredBuffer g_transformBuffer < Attribute("TransformBuffer"); SrgbRead(false); >;
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
	// cbuffer ID 4459 (name: PerViewConstantBuffer_t), member index 1 (name: _m1) cannot be expressed with either HLSL packing layout or packoffset.
	// 
	// Re-attempting reflection with the GLSL backend.
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (7424 bytes), GLSL reflection with SPIRV-Cross by KhronosGroup
	
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
	
	struct _2032
	{
	    vec4 _m0[3];
	};
	
	struct _2012
	{
	    _2032 _m0;
	};
	
	struct _533
	{
	    vec4 _m0[4];
	};
	
	layout(set = 4, binding = 32, std430) readonly buffer g_instanceBuffer
	{
	    _1125 _m0[];
	} g_instanceBuffer_1;
	
	layout(set = 4, binding = 30, std430) readonly buffer g_transformBuffer
	{
	    _2012 _m0[];
	} g_transformBuffer_1;
	
	struct _2124
	{
	    _533 _m0;
	    float _m1;
	    vec4 _m2;
	};
	
	layout(set = 0) uniform _2124 PerViewConstantBuffer_t;
	
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
	    uint _13771 = (g_instanceBuffer_1._m0[vBlendIndices]._m5 >> uint(16)) & 15u;
	    uint _21785;
	    if (_13771 == 1u)
	    {
	        _21785 = g_instanceBuffer_1._m0[vBlendIndices]._m1 + (2u + vTangentUOs_flTangentVSign.x);
	    }
	    else
	    {
	        _21785 = g_instanceBuffer_1._m0[vBlendIndices]._m1;
	    }
	    mat3x4 _17839 = mat3x4(g_transformBuffer_1._m0[_21785]._m0._m0[0], g_transformBuffer_1._m0[_21785]._m0._m0[1], g_transformBuffer_1._m0[_21785]._m0._m0[2]);
	    vec3 _21709;
	    if (_13771 > 0u)
	    {
	        _21709 = vec3(g_transformBuffer_1._m0[g_instanceBuffer_1._m0[vBlendIndices]._m1]._m0._m0[0].z);
	    }
	    else
	    {
	        _21709 = vec3(1.0);
	    }
	    vec4 _23812 = vec4(uvec4((g_instanceBuffer_1._m0[vBlendIndices]._m0 & 255u), (g_instanceBuffer_1._m0[vBlendIndices]._m0 & 65280u) >> uint(8), (g_instanceBuffer_1._m0[vBlendIndices]._m0 & 16711680u) >> uint(16), (g_instanceBuffer_1._m0[vBlendIndices]._m0 & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
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
	    vec3 _11179 = normalize(vec4(vTexCoord.xyz, 0.0) * _17839);
	    vec3 _12151 = vec4(vPositionOs.xyz * _21709.xyz, 1.0) * _17839;
	    vec4 _7227 = vBlendColorTint.xyxy;
	    _7227.x = dot(vBlendColorTint.xy, _Globals_.g_vTexCoordXform0.xy) + _Globals_.g_vTexCoordXform0.w;
	    _7227.y = dot(vBlendColorTint.xy, _Globals_.g_vTexCoordXform1.xy) + _Globals_.g_vTexCoordXform1.w;
	    vec2 _22490 = _7227.xy + (_Globals_.g_vTexCoordScrollSpeed.xy * PerViewConstantBuffer_t._m1);
	    vec4 _20488 = _7227;
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
	    vec4 _23533 = (vec4(_12151.xyz, 1.0) + (PerViewConstantBuffer_t._m2 * 1.0)).xyzw * mat4(vec4(PerViewConstantBuffer_t._m0._m0[0].x, PerViewConstantBuffer_t._m0._m0[1].x, PerViewConstantBuffer_t._m0._m0[2].x, PerViewConstantBuffer_t._m0._m0[3].x), vec4(PerViewConstantBuffer_t._m0._m0[0].y, PerViewConstantBuffer_t._m0._m0[1].y, PerViewConstantBuffer_t._m0._m0[2].y, PerViewConstantBuffer_t._m0._m0[3].y), vec4(PerViewConstantBuffer_t._m0._m0[0].z, PerViewConstantBuffer_t._m0._m0[1].z, PerViewConstantBuffer_t._m0._m0[2].z, PerViewConstantBuffer_t._m0._m0[3].z), vec4(PerViewConstantBuffer_t._m0._m0[0].w, PerViewConstantBuffer_t._m0._m0[1].w, PerViewConstantBuffer_t._m0._m0[2].w, PerViewConstantBuffer_t._m0._m0[3].w));
	    output_0 = nInstanceIdx;
	    output_1 = _12151.xyz - PerViewConstantBufferCsgo_t._m0.xyz;
	    output_2 = _11179;
	    output_3 = _20488;
	    output_4 = _23714;
	    output_5 = _11179;
	    output_6 = vec4(normalize(vec4(vNormalOs.xyz, 0.0) * _17839), vNormalOs.w);
	    output_7 = (g_instanceBuffer_1._m0[vBlendIndices]._m5) & 65535u;
	    _23533.y = -_23533.y;
	    gl_Position = _23533;
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
	StructuredBuffer g_BarnLights < Attribute("BarnLights"); SrgbRead(false); >;
	StructuredBuffer g_CullBits < Attribute("CullBits"); SrgbRead(false); >;
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
	float4x4 g_mTextureAdjust < Expression(MatrixMultiply(MatrixColorTint2(float3(1,1,1),1),MatrixColorCorrect2(float3(g_fTextureColorContrast,g_fTextureColorSaturation,g_fTextureColorBrightness),TextureAverageColor(g_tColor)))); >;
	float4x4 g_mTextureColorAdjust < Expression(MatrixMultiply(MatrixColorTint2(g_vTextureColorCorrectionTint,1),MatrixColorCorrect2(float3(g_fTextureColorContrast,g_fTextureColorSaturation,g_fTextureColorBrightness),TextureAverageColor(g_tColor)))); >;
	float4x4 g_mTransmissiveTextureAdjust < Expression(MatrixMultiply(MatrixColorTint2(float3(1,1,1),1),MatrixColorCorrect2(float3(g_fTextureColorContrast,g_fTextureColorSaturation,g_fTextureColorBrightness),TextureAverageColor(g_tTransmissiveColor)))); >;
	float4x4 g_mTransmissiveTextureColorAdjust < Expression(MatrixMultiply(MatrixColorTint2(g_vTextureColorCorrectionTint,1),MatrixColorCorrect2(float3(g_fTextureColorContrast,g_fTextureColorSaturation,g_fTextureColorBrightness),TextureAverageColor(g_tTransmissiveColor)))); >;
	int g_nToolsVisMode < Attribute("g_nToolsVisMode"); UiType(Slider); >;
	RWTexture2D<float4> g_tQuadOverdrawMutexUAV < Attribute("QuadOverdrawMutexUAV"); >;
	RWTexture2D<float4> g_tQuadOverdrawUAV < Attribute("QuadOverdrawUAV"); >;
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
	#endif
	#if (S_TRANSMISSIVE_BACKFACE_NDOTL == 0)
	#endif
	#if (S_MODE_TOOLS_VIS == 1)
	#endif
	#if (S_SHADER_QUALITY == 1)
	#endif
	#if (S_ALPHA_TEST == 1)
	#endif
	#if (S_VERTEX_ANIMATION == 0)
	#endif
	#if (S_MODE_TOOLS_SHADING_COMPLEXITY == 1)
	#endif
	
	// SPIR-V reflection failed for backend HLSL:
	// cbuffer ID 5618 (name: _Globals_), member index 19 (name: g_fTextureRoughnessContrast) cannot be expressed with either HLSL packing layout or packoffset.
	// 
	// Re-attempting reflection with the GLSL backend.
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (42336 bytes), GLSL reflection with SPIRV-Cross by KhronosGroup
	
	#version 460
	#extension GL_KHR_shader_subgroup_arithmetic : require
	
	struct anon_g_mTextureColorAdjust
	{
	    vec4 _m0[4];
	};
	
	struct _701
	{
	    vec4 _m0[3];
	};
	
	struct _912
	{
	    vec4 _m0[4];
	};
	
	struct _702
	{
	    vec4 _m0[3];
	};
	
	struct _1304
	{
	    anon_g_mTextureColorAdjust _m0[4];
	};
	
	struct _336
	{
	    anon_g_mTextureColorAdjust _m0;
	    anon_g_mTextureColorAdjust _m1;
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
	    _702 _m15;
	    vec4 _m16;
	    vec4 _m17;
	    vec4 _m18;
	    vec4 _m19;
	    vec4 _m20;
	    vec3 _m21;
	    float _m22;
	};
	
	vec3 _4;
	vec4 _5;
	
	struct _2065
	{
	    uint g_tColor;
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
	    uint g_tNormal;
	    uint g_tAmbientOcclusion;
	    float g_flVertexAmbientOcclusionAmount;
	    float g_flVertexAmbientOcclusionPower;
	    float g_flHeightGradientAmount;
	    float g_flHeightGradientPower;
	    anon_g_mTextureColorAdjust g_mTextureColorAdjust;
	    float g_fTextureRoughnessContrast;
	    float g_fTextureRoughnessBrightness;
	    float g_fTextureNormalContrast;
	};
	
	layout(set = 1) uniform _2065 _Globals_;
	
	struct _776
	{
	    ivec4 _m0;
	    ivec4 _m1;
	    ivec4 _m2;
	    uint _m3;
	    uint _m4;
	    uint _m5;
	    uint _m6;
	    uint _m7;
	    anon_g_mTextureColorAdjust _m8;
	    vec2 _m9;
	    float _m10;
	    vec4 _m11;
	    vec4 _m12;
	    vec4 _m13;
	    vec4 _m14;
	    vec4 _m15;
	    vec4 _m16;
	    anon_g_mTextureColorAdjust _m17;
	    vec4 _m18;
	    vec4 _m19;
	    vec4 _m20;
	};
	
	layout(set = 1) uniform _776 PerViewConstantBufferCsgo_t;
	
	struct _1110
	{
	    _701 _m0;
	    _912 _m1;
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
	    _1304 _m18;
	    _912 _m19;
	    uint _m20;
	    uint _m21;
	};
	
	layout(set = 3) uniform _1110 PerViewLightingConstantBufferGpu_t;
	
	struct _1194
	{
	    vec2 _m0;
	    vec2 _m1;
	    vec4 _m2;
	    vec3 _m3;
	};
	
	layout(set = 1) uniform _1194 PerViewConstantBuffer_t;
	
	layout(set = 3, binding = 30, std430) readonly buffer g_CullBits
	{
	    uint _m0[];
	} g_CullBits_1;
	
	layout(set = 3, binding = 31, std430) readonly buffer g_BarnLights
	{
	    _336 _m0[];
	} g_BarnLights_1;
	
	layout(set = 4, binding = 46) uniform texture2D g_bindless_Texture2D_float4[65536];
	layout(set = 4, binding = 29) uniform sampler undetermined[2048];
	layout(set = 4, binding = 29) uniform samplerShadow undetermined_1[2048];
	layout(set = 4, binding = 46) uniform texture3D g_bindless_Texture3D_float4[65536];
	layout(set = 4, binding = 46) uniform textureCubeArray g_bindless_TextureCubeArray_float4[65536];
	layout(set = 4, binding = 46) uniform textureCube g_bindless_TextureCube_float4[65536];
	
	layout(location = 0) in vec4 input_0;
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
	    vec4 _24079 = clamp(input_0, vec4(0.001000000047497451305389404296875), vec4(1.0));
	    vec3 _21709;
	    if (dot(input_2.xyz, input_2.xyz) >= 1.0099999904632568359375)
	    {
	        _21709 = input_5.xyz;
	    }
	    else
	    {
	        _21709 = input_2.xyz;
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
	    vec3 _10061 = input_1 + PerViewConstantBufferCsgo_t._m20.xyz;
	    vec4 _19334 = texture(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tColor], undetermined[_Globals_.g_sUserConfigAllowGlobalMipBias]), input_3.xy);
	    vec4 _19068 = texture(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tAmbientOcclusion], undetermined[_Globals_.g_sUserConfig]), vec2(input_3.xy).xy);
	    vec4 _19372 = texture(sampler2D(g_bindless_Texture2D_float4[_Globals_.g_tNormal], undetermined[_Globals_.g_sUserConfig]), input_3.xy);
	    float _16000 = _19372.x;
	    float _19720 = _19372.y;
	    float _16783 = (_16000 + _19720) - 1.00392162799835205078125;
	    float _11176 = _16000 - _19720;
	    vec3 _8418 = normalize(vec3(vec2(_16783, _11176), (1.0 - abs(_16783)) - abs(_11176)));
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
	    float _23240 = (input_6.w > 0.0) ? 1.0 : (-1.0);
	    vec3 _14435 = cross(_12631.xyz, input_6.xyz) * _23240;
	    bvec4 _24464 = notEqual(PerViewConstantBufferCsgo_t._m2, ivec4(0));
	    bool _20058 = _24464.w;
	    vec3 _7424;
	    if (_20058)
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
	        vec3 _7482 = _8418;
	        _7482.y = -_8418.y;
	        _20480 = _7482;
	    }
	    else
	    {
	        _20480 = _8418;
	    }
	    vec3 _8357 = vec3(_Globals_.g_flReflectance);
	    vec3 _21710;
	    if (_Globals_.g_fTextureNormalContrast != 1.0)
	    {
	        vec2 _8828 = _20480.yx * _Globals_.g_fTextureNormalContrast;
	        float _16674 = _8828.x;
	        vec3 _8673 = _20480;
	        _8673.y = _16674;
	        _8673.x = _8828.y;
	        bool _12887;
	        if (_14874)
	        {
	            _12887 = !(_Globals_.g_bDontFlipBackfaceNormals != 0);
	        }
	        else
	        {
	            _12887 = false;
	        }
	        bool _24328;
	        if (_12887)
	        {
	            _24328 = (gl_FrontFacing ? 1.0 : (-1.0)) < 0.0;
	        }
	        else
	        {
	            _24328 = false;
	        }
	        vec3 _9739 = input_2.xyz * (_24328 ? (-1.0) : 1.0);
	        vec3 _24682 = cross(_9739.xyz, input_6.xyz) * _23240;
	        vec3 _7425;
	        if (_20058)
	        {
	            _7425 = -_24682;
	        }
	        else
	        {
	            _7425 = _24682;
	        }
	        vec3 _20481;
	        if (!_24328)
	        {
	            vec3 _16556 = _8673;
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
	    float _22771 = _19068.x * mix(1.0, pow(_24079.w, _Globals_.g_flVertexAmbientOcclusionPower), _Globals_.g_flVertexAmbientOcclusionAmount);
	    vec3 _17892 = mix(vec3(1.0), _21710, bvec3(all(bvec3(true))));
	    vec3 _10560 = _24347.xyz;
	    vec3 _11099 = dFdx(_10560);
	    vec3 _9175 = dFdy(_10560);
	    vec3 _10347 = _11099.xyz;
	    vec3 _12420 = _9175.xyz;
	    vec2 _13392 = max(clamp((((_19372.zz - vec2(0.5)) * _Globals_.g_fTextureRoughnessContrast) + vec2(0.5)).xy * _Globals_.g_fTextureRoughnessBrightness, vec2(0.0), vec2(1.0)).xy, vec2(pow(clamp(max(dot(_10347, _10347), dot(_12420, _12420)), 0.0, 1.0), 0.333000004291534423828125)));
	    bvec4 _24465 = notEqual(PerViewConstantBufferCsgo_t._m0, ivec4(0));
	    float _21785;
	    if (_24465.x)
	    {
	        vec3 _11394 = _24347.xyz;
	        vec2 _11086 = ((floor(_11408.xy * PerViewConstantBufferCsgo_t._m10) * PerViewConstantBufferCsgo_t._m9.xy) + (PerViewConstantBufferCsgo_t._m9.xy * 0.5)).xy;
	        vec4 _18418 = textureGather(sampler2D(g_bindless_Texture2D_float4[PerViewConstantBufferCsgo_t._m5], undetermined[_Globals_.g_sCookieSampler]), _11086).xyzw - _11408.zzzz;
	        float _18579 = _18418.w;
	        float _12013 = _18418.z;
	        bool _12285 = abs(_12013) < _18579;
	        vec2 _23168;
	        if (_12285)
	        {
	            _23168 = vec2(PerViewConstantBufferCsgo_t._m9.x, 0.0);
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
	            _23169 = vec2(0.0, PerViewConstantBufferCsgo_t._m9.y);
	        }
	        else
	        {
	            _23169 = _23168;
	        }
	        vec4 _17422 = (max(vec4(dot(PerViewLightingConstantBufferGpu_t._m1._m0[0].xyz, _11394), dot(PerViewLightingConstantBufferGpu_t._m1._m0[1].xyz, _11394), dot(PerViewLightingConstantBufferGpu_t._m1._m0[2].xyz, _11394), dot(PerViewLightingConstantBufferGpu_t._m1._m0[3].xyz, _11394)).xyzw, vec4(0.0)).xyzw * PerViewLightingConstantBufferGpu_t._m2.xyzw).xyzw;
	        _21785 = (1.0 / (dot(_17422, vec4(1.0)) + PerViewLightingConstantBufferGpu_t._m3.x)) * (PerViewLightingConstantBufferGpu_t._m3.x + dot(_17422, textureLod(sampler2D(g_bindless_Texture2D_float4[PerViewConstantBufferCsgo_t._m4], undetermined[_Globals_.g_sPointClamp]), (_11086 + mix(_23169, PerViewConstantBufferCsgo_t._m9.xy, bvec2(abs(_18418.y) < (_12286 ? _15372 : _20965))).xy).xy, 0.0).xyzw));
	    }
	    else
	    {
	        _21785 = 1.0;
	    }
	    vec4 _23875 = vec4(_21710.xyz, 1.0);
	    float _21711;
	    if (PerViewLightingConstantBufferGpu_t._m11 != 0)
	    {
	        int _23989;
	        int _10191;
	        float _13136;
	        vec3 _14975;
	        int _13039 = 0;
	        for (;;)
	        {
	            if (!(_13039 < PerViewLightingConstantBufferGpu_t._m11))
	            {
	                _13136 = 1.0;
	                _14975 = vec3(0.0);
	                _10191 = -1;
	                break;
	            }
	            vec4 _18322 = vec4(input_1.xyz, 1.0) * mat4(vec4(PerViewLightingConstantBufferGpu_t._m18._m0[_13039]._m0[0].x, PerViewLightingConstantBufferGpu_t._m18._m0[_13039]._m0[1].x, PerViewLightingConstantBufferGpu_t._m18._m0[_13039]._m0[2].x, PerViewLightingConstantBufferGpu_t._m18._m0[_13039]._m0[3].x), vec4(PerViewLightingConstantBufferGpu_t._m18._m0[_13039]._m0[0].y, PerViewLightingConstantBufferGpu_t._m18._m0[_13039]._m0[1].y, PerViewLightingConstantBufferGpu_t._m18._m0[_13039]._m0[2].y, PerViewLightingConstantBufferGpu_t._m18._m0[_13039]._m0[3].y), vec4(PerViewLightingConstantBufferGpu_t._m18._m0[_13039]._m0[0].z, PerViewLightingConstantBufferGpu_t._m18._m0[_13039]._m0[1].z, PerViewLightingConstantBufferGpu_t._m18._m0[_13039]._m0[2].z, PerViewLightingConstantBufferGpu_t._m18._m0[_13039]._m0[3].z), vec4(PerViewLightingConstantBufferGpu_t._m18._m0[_13039]._m0[0].w, PerViewLightingConstantBufferGpu_t._m18._m0[_13039]._m0[1].w, PerViewLightingConstantBufferGpu_t._m18._m0[_13039]._m0[2].w, PerViewLightingConstantBufferGpu_t._m18._m0[_13039]._m0[3].w));
	            float _12779 = _18322.x;
	            if (max(abs(_12779), abs(_18322.y)) < PerViewLightingConstantBufferGpu_t._m13[_13039])
	            {
	                vec3 _19470 = vec3(_12779, _18322.yz);
	                vec2 _24804 = _19470.xy;
	                vec2 _22193 = vec2(1.0) - clamp((abs(_24804) * vec2(PerViewLightingConstantBufferGpu_t._m15)) + vec2(PerViewLightingConstantBufferGpu_t._m14), vec2(0.0), vec2(1.0));
	                vec2 _20561 = (_24804 * PerViewLightingConstantBufferGpu_t._m19._m0[_13039].zw) + PerViewLightingConstantBufferGpu_t._m19._m0[_13039].xy;
	                vec3 _20488 = _19470;
	                _20488.x = _20561.x;
	                _20488.y = _20561.y;
	                _13136 = saturate(_22193.x * _22193.y);
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
	            float _18270 = textureLod(sampler2DShadow(g_bindless_Texture2D_float4[PerViewLightingConstantBufferGpu_t._m20], undetermined_1[_Globals_.g_tShadowDepthBufferCmpSampler]), vec3(_14975.xy, saturate(_14975.z + PerViewLightingConstantBufferGpu_t._m12)), 0.0);
	            float _12501;
	            if (_13136 < 1.0)
	            {
	                float _7934;
	                if (_10191 < (PerViewLightingConstantBufferGpu_t._m11 - 1))
	                {
	                    int _15335 = _10191 + 1;
	                    vec4 _19671 = vec4(input_1.xyz, 1.0) * mat4(vec4(PerViewLightingConstantBufferGpu_t._m18._m0[_15335]._m0[0].x, PerViewLightingConstantBufferGpu_t._m18._m0[_15335]._m0[1].x, PerViewLightingConstantBufferGpu_t._m18._m0[_15335]._m0[2].x, PerViewLightingConstantBufferGpu_t._m18._m0[_15335]._m0[3].x), vec4(PerViewLightingConstantBufferGpu_t._m18._m0[_15335]._m0[0].y, PerViewLightingConstantBufferGpu_t._m18._m0[_15335]._m0[1].y, PerViewLightingConstantBufferGpu_t._m18._m0[_15335]._m0[2].y, PerViewLightingConstantBufferGpu_t._m18._m0[_15335]._m0[3].y), vec4(PerViewLightingConstantBufferGpu_t._m18._m0[_15335]._m0[0].z, PerViewLightingConstantBufferGpu_t._m18._m0[_15335]._m0[1].z, PerViewLightingConstantBufferGpu_t._m18._m0[_15335]._m0[2].z, PerViewLightingConstantBufferGpu_t._m18._m0[_15335]._m0[3].z), vec4(PerViewLightingConstantBufferGpu_t._m18._m0[_15335]._m0[0].w, PerViewLightingConstantBufferGpu_t._m18._m0[_15335]._m0[1].w, PerViewLightingConstantBufferGpu_t._m18._m0[_15335]._m0[2].w, PerViewLightingConstantBufferGpu_t._m18._m0[_15335]._m0[3].w));
	                    vec2 _20562 = (_19671.xy * PerViewLightingConstantBufferGpu_t._m19._m0[_15335].zw) + PerViewLightingConstantBufferGpu_t._m19._m0[_15335].xy;
	                    vec3 _20489;
	                    _20489.x = _20562.x;
	                    _20489.y = _20562.y;
	                    _7934 = textureLod(sampler2DShadow(g_bindless_Texture2D_float4[PerViewLightingConstantBufferGpu_t._m20], undetermined_1[_Globals_.g_tShadowDepthBufferCmpSampler]), vec3(_20489.xy, saturate(_19671.z + PerViewLightingConstantBufferGpu_t._m12)), 0.0);
	                }
	                else
	                {
	                    _7934 = 1.0;
	                }
	                _12501 = mix(_7934, _18270, _13136);
	            }
	            else
	            {
	                _12501 = _18270;
	            }
	            _19363 = _12501;
	        }
	        else
	        {
	            _19363 = 1.0;
	        }
	        float _13279 = mix(_19363, 1.0, clamp((distance(_10061.xyz, PerViewConstantBuffer_t._m3) * PerViewLightingConstantBufferGpu_t._m17) + PerViewLightingConstantBufferGpu_t._m16, 0.0, 1.0));
	        float _12502;
	        if (_24465.y)
	        {
	            _12502 = min(_13279, textureLod(sampler2D(g_bindless_Texture2D_float4[PerViewConstantBufferCsgo_t._m6], undetermined[_Globals_.g_sTrilinearClamp]), (_11408.xy * PerViewConstantBuffer_t._m2.xy).xy, 0.0).z);
	        }
	        else
	        {
	            _12502 = _13279;
	        }
	        _21711 = _12502;
	    }
	    else
	    {
	        _21711 = 1.0;
	    }
	    vec3 _9716;
	    vec3 _24878;
	    if ((dot(PerViewLightingConstantBufferGpu_t._m9.xyz, _21710.xyz) * _21711) > 0.0)
	    {
	        float _11797 = max(0.0, dot(_21710.xyz, PerViewLightingConstantBufferGpu_t._m9.xyz));
	        vec2 _9840 = max(_13392, vec2(PerViewLightingConstantBufferGpu_t._m9.w));
	        vec3 _12281 = normalize(PerViewLightingConstantBufferGpu_t._m9.xyz + (-normalize(_10061.xyz - PerViewConstantBuffer_t._m3.xyz)).xyz).xyz;
	        float _12386 = dot(_12281, mix(_17892, _21710.xyz, bvec3(all(equal(_17892, vec3(1.0))))).xyz);
	        float _19210 = max(0.0, dot(PerViewLightingConstantBufferGpu_t._m9.xyz, _12281));
	        float _9850 = _9840.x;
	        float _25211 = _9850 * _9850;
	        float _19095 = _25211 * _25211;
	        float _15346 = ((_12386 * _12386) * (_19095 - 1.0)) + 1.0;
	        vec3 _16808 = (PerViewLightingConstantBufferGpu_t._m10.xyz * _21711).xyz;
	        _9716 = ((_8357.xyz * (_19095 / (((_15346 * _15346) * (_19210 * _19210)) * ((_9850 * 4.0) + 2.0)))).xyz * _11797).xyz * _16808;
	        _24878 = PerViewLightingConstantBufferGpu_t._m4.xyz + (vec3(_11797).xyz * _16808);
	    }
	    else
	    {
	        _9716 = vec3(0.0);
	        _24878 = PerViewLightingConstantBufferGpu_t._m4.xyz;
	    }
	    bvec4 _24466 = notEqual(PerViewConstantBufferCsgo_t._m1, ivec4(0));
	    bool _20060 = _24466.x;
	    vec4 _19364;
	    if (_20060)
	    {
	        vec4 _24259 = vec4(_10061.xyz, 1.0).xyzw * mat4(vec4(PerViewConstantBufferCsgo_t._m8._m0[0].x, PerViewConstantBufferCsgo_t._m8._m0[1].x, PerViewConstantBufferCsgo_t._m8._m0[2].x, PerViewConstantBufferCsgo_t._m8._m0[3].x), vec4(PerViewConstantBufferCsgo_t._m8._m0[0].y, PerViewConstantBufferCsgo_t._m8._m0[1].y, PerViewConstantBufferCsgo_t._m8._m0[2].y, PerViewConstantBufferCsgo_t._m8._m0[3].y), vec4(PerViewConstantBufferCsgo_t._m8._m0[0].z, PerViewConstantBufferCsgo_t._m8._m0[1].z, PerViewConstantBufferCsgo_t._m8._m0[2].z, PerViewConstantBufferCsgo_t._m8._m0[3].z), vec4(PerViewConstantBufferCsgo_t._m8._m0[0].w, PerViewConstantBufferCsgo_t._m8._m0[1].w, PerViewConstantBufferCsgo_t._m8._m0[2].w, PerViewConstantBufferCsgo_t._m8._m0[3].w));
	        float _20176 = _24259.w;
	        vec2 _11414 = _24259.xy / vec2(_20176);
	        vec4 _6651;
	        _6651.x = clamp(((_11414.x + 1.0) * PerViewConstantBuffer_t._m1.x) * 0.5, 0.0, PerViewConstantBuffer_t._m1.x - 1.0);
	        _6651.y = clamp(((1.0 - _11414.y) * PerViewConstantBuffer_t._m1.y) * 0.5, 0.0, PerViewConstantBuffer_t._m1.y - 1.0);
	        _6651.w = _20176;
	        _19364 = _6651;
	    }
	    else
	    {
	        _19364 = _11408;
	    }
	    uvec2 _12083 = uvec2(_19364.xy - PerViewConstantBuffer_t._m0.xy) >> uvec2(PerViewLightingConstantBufferGpu_t._m6.x);
	    uint _10838 = PerViewLightingConstantBufferGpu_t._m5.y + (((_12083.y * PerViewLightingConstantBufferGpu_t._m6.y) + _12083.x) * PerViewLightingConstantBufferGpu_t._m5.z);
	    uint _23393 = PerViewLightingConstantBufferGpu_t._m5.x + (uint(clamp(_19364.w * PerViewLightingConstantBufferGpu_t._m7.x, 0.0, PerViewLightingConstantBufferGpu_t._m7.y)) * PerViewLightingConstantBufferGpu_t._m5.z);
	    vec3 _13137;
	    vec3 _16324;
	    _13137 = _9716;
	    _16324 = _24878;
	    uint _21567;
	    vec3 _13138;
	    vec3 _16325;
	    uint _17017 = 0u;
	    for (;;)
	    {
	        if (!(_17017 < PerViewLightingConstantBufferGpu_t._m5.z))
	        {
	            break;
	        }
	        uint _14475 = subgroupOr(g_CullBits_1._m0[_10838 + _17017] & g_CullBits_1._m0[_23393 + _17017]);
	        _13138 = _13137;
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
	                vec4 _15817 = mat4(vec4(g_BarnLights_1._m0[_12608]._m0._m0[0].x, g_BarnLights_1._m0[_12608]._m0._m0[1].x, g_BarnLights_1._m0[_12608]._m0._m0[2].x, g_BarnLights_1._m0[_12608]._m0._m0[3].x), vec4(g_BarnLights_1._m0[_12608]._m0._m0[0].y, g_BarnLights_1._m0[_12608]._m0._m0[1].y, g_BarnLights_1._m0[_12608]._m0._m0[2].y, g_BarnLights_1._m0[_12608]._m0._m0[3].y), vec4(g_BarnLights_1._m0[_12608]._m0._m0[0].z, g_BarnLights_1._m0[_12608]._m0._m0[1].z, g_BarnLights_1._m0[_12608]._m0._m0[2].z, g_BarnLights_1._m0[_12608]._m0._m0[3].z), vec4(g_BarnLights_1._m0[_12608]._m0._m0[0].w, g_BarnLights_1._m0[_12608]._m0._m0[1].w, g_BarnLights_1._m0[_12608]._m0._m0[2].w, g_BarnLights_1._m0[_12608]._m0._m0[3].w)) * vec4(input_1.xyz, 1.0);
	                vec3 _10521 = _15817.xyz / vec3(_15817.w);
	                vec4 _22905;
	                _22905.x = _10521.x;
	                _22905.y = _10521.y;
	                float _21776 = _10521.z;
	                _22905.z = _21776;
	                vec3 _21642 = _22905.xyz;
	                bool _7426;
	                if (all(greaterThan(_22905.xyz, vec3(-1.0, -1.0, 0.0))))
	                {
	                    _7426 = all(lessThan(_22905.xyz, vec3(1.0)));
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
	                    _12888 = !all(lessThanEqual(abs((mat4x3(vec3(g_BarnLights_1._m0[_12608]._m15._m0[0].x, g_BarnLights_1._m0[_12608]._m15._m0[1].x, g_BarnLights_1._m0[_12608]._m15._m0[2].x), vec3(g_BarnLights_1._m0[_12608]._m15._m0[0].y, g_BarnLights_1._m0[_12608]._m15._m0[1].y, g_BarnLights_1._m0[_12608]._m15._m0[2].y), vec3(g_BarnLights_1._m0[_12608]._m15._m0[0].z, g_BarnLights_1._m0[_12608]._m15._m0[1].z, g_BarnLights_1._m0[_12608]._m15._m0[2].z), vec3(g_BarnLights_1._m0[_12608]._m15._m0[0].w, g_BarnLights_1._m0[_12608]._m15._m0[1].w, g_BarnLights_1._m0[_12608]._m15._m0[2].w)) * vec4(input_1.xyz, 1.0)).xyz), vec3(1.0)));
	                }
	                if (_12888)
	                {
	                    _13212 = _13138;
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
	                    vec3 _10017 = g_BarnLights_1._m0[_12608]._m2.xyz - input_1.xyz;
	                    float _18345 = dot(_10017, _10017);
	                    float _17647 = sqrt(_18345);
	                    vec3 _12302 = _10017 - _16268;
	                    vec3 _10210;
	                    do
	                    {
	                        vec3 _20229 = (_10017 + _16268) - _12302;
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
	                    _11179 = _10017 / vec3(_17647);
	                    _11633 = ((_19667 * (g_BarnLights_1._m0[_12608]._m2.w / max(_18345, g_BarnLights_1._m0[_12608]._m2.w))) * clamp(g_BarnLights_1._m0[_12608]._m3.x + (g_BarnLights_1._m0[_12608]._m3.y * _17647), 0.0, 1.0)) * clamp(g_BarnLights_1._m0[_12608]._m6.x + (g_BarnLights_1._m0[_12608]._m6.y * dot(vec3((1.0 - (_23572 * g_BarnLights_1._m0[_12608]._m5.y)) - _18492, _9058 + _19825, (_14805 * g_BarnLights_1._m0[_12608]._m5.z) - (_17330 * g_BarnLights_1._m0[_12608]._m5.y)), normalize(_10210))), 0.0, 1.0);
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
	                            float _15019 = _22154.y;
	                            float _23041 = (-0.5) * g_BarnLights_1._m0[_12608]._m9.z;
	                            float _11981 = (g_BarnLights_1._m0[_12608]._m9.x * g_BarnLights_1._m0[_12608]._m9.y) * pow(max(pow(g_BarnLights_1._m0[_12608]._m9.y * _11473, _15266) + pow(g_BarnLights_1._m0[_12608]._m9.x * _15019, _15266), 1.1754943508222875079687365372222e-38), _23041);
	                            float _16524 = pow(max(pow(_11473, _15266) + pow(_15019, _15266), 1.1754943508222875079687365372222e-38), _23041);
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
	                        vec3 _20492 = _14081;
	                        _20492.x = _20564.x;
	                        _20492.y = _20564.y;
	                        _12503 = _17828.xyz * textureLod(sampler3D(g_bindless_Texture3D_float4[PerViewLightingConstantBufferGpu_t._m21], undetermined[_Globals_.g_sTrilinearWrap]), _20492.xyz, 0.0).xyz;
	                    }
	                    else
	                    {
	                        vec3 _13791 = vec3(fma(_22905.xy, vec2(0.5, -0.5), vec2(0.5)), g_BarnLights_1._m0[_12608]._m4.w);
	                        vec2 _20563 = (_13791.xy * g_BarnLights_1._m0[_12608]._m9.zw) + g_BarnLights_1._m0[_12608]._m9.xy;
	                        vec3 _20491 = _13791;
	                        _20491.x = _20563.x;
	                        _20491.y = _20563.y;
	                        _12503 = _17828.xyz * textureLod(sampler3D(g_bindless_Texture3D_float4[PerViewLightingConstantBufferGpu_t._m21], undetermined[_Globals_.g_sCookieSampler]), _20491.xyz, 0.0).xyz;
	                    }
	                    _21548 = _12503;
	                }
	                if (all(equal(_21548.xyz, vec3(0.0))))
	                {
	                    _13212 = _13138;
	                    _15670 = _16325;
	                    break;
	                }
	                vec3 _22671;
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
	                float _11798 = max(0.0, dot(_21710.xyz, _11179.xyz));
	                vec2 _9841 = max(_13392, vec2(g_BarnLights_1._m0[_12608]._m11));
	                vec3 _12282 = normalize(_11179.xyz + (-normalize(_10061.xyz - PerViewConstantBuffer_t._m3.xyz)).xyz).xyz;
	                float _12387 = dot(_12282, mix(_17892, _21710.xyz, bvec3(all(equal(_17892, vec3(1.0))))).xyz);
	                float _19211 = max(0.0, dot(_11179.xyz, _12282));
	                float _9851 = _9841.x;
	                float _25212 = _9851 * _9851;
	                float _19097 = _25212 * _25212;
	                float _15348 = ((_12387 * _12387) * (_19097 - 1.0)) + 1.0;
	                _13212 = _13138.xyz + (((_8357.xyz * (_19097 / (((_15348 * _15348) * (_19211 * _19211)) * ((_9851 * 4.0) + 2.0)))).xyz * _11798).xyz * _22671.xyz);
	                _15670 = _16325.xyz + (vec3(_11798).xyz * _22671.xyz);
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
	    float _17172 = dot(_13392.xy, vec2(0.5));
	    vec3 _6253 = _17892.xyz;
	    vec3 _17138 = normalize(_10061.xyz - PerViewConstantBuffer_t._m3.xyz);
	    float _17225 = _17172 * _17172;
	    float _20711 = saturate(1.0 - _17225);
	    vec4 _15343 = (vec4(-1.0, -0.0274999998509883880615234375, -0.572000026702880859375, 0.02199999988079071044921875) * _17172) + vec4(1.0, 0.0425000004470348358154296875, 1.03999996185302734375, -0.039999999105930328369140625);
	    float _21215 = _15343.x;
	    vec2 _24572 = (vec2(-1.03999996185302734375, 1.03999996185302734375) * ((min(_21215 * _21215, exp2((-9.27999973297119140625) * max(0.0, dot((-_17138).xyz, _6253)))) * _21215) + _15343.y)) + _15343.zw;
	    float _20339 = _24572.y;
	    vec2 _11427 = vec2(_20339, _24572.x + _20339);
	    vec3 _8745 = vec3(dot(PerViewLightingConstantBufferGpu_t._m0._m0[0].xyzw, _23875), dot(PerViewLightingConstantBufferGpu_t._m0._m0[1].xyzw, _23875), dot(PerViewLightingConstantBufferGpu_t._m0._m0[2].xyzw, _23875)).xyz;
	    vec3 _16991 = _16324.xyz + _8745;
	    vec3 _13436 = vec3(_22771 * _21785).xyz;
	    vec3 _22686 = ((_16324.xyz * vec3(_21785)).xyz + (_8745 * vec3(_21785 * _22771).xyz).xyz) * ((vec3(max(vec4((vec4(vec4((_19334.xyz * input_4.xyz).xyz, 1.0).xyz, 1.0) * mat4(vec4(_Globals_.g_mTextureColorAdjust._m0[0].x, _Globals_.g_mTextureColorAdjust._m0[1].x, _Globals_.g_mTextureColorAdjust._m0[2].x, _Globals_.g_mTextureColorAdjust._m0[3].x), vec4(_Globals_.g_mTextureColorAdjust._m0[0].y, _Globals_.g_mTextureColorAdjust._m0[1].y, _Globals_.g_mTextureColorAdjust._m0[2].y, _Globals_.g_mTextureColorAdjust._m0[3].y), vec4(_Globals_.g_mTextureColorAdjust._m0[0].z, _Globals_.g_mTextureColorAdjust._m0[1].z, _Globals_.g_mTextureColorAdjust._m0[2].z, _Globals_.g_mTextureColorAdjust._m0[3].z), vec4(_Globals_.g_mTextureColorAdjust._m0[0].w, _Globals_.g_mTextureColorAdjust._m0[1].w, _Globals_.g_mTextureColorAdjust._m0[2].w, _Globals_.g_mTextureColorAdjust._m0[3].w))).xyz, 1.0), vec4(0.0)).xyz).xyz * 1.0) * (mix(0.0, pow(_24079.x, _Globals_.g_flHeightGradientPower), _Globals_.g_flHeightGradientAmount) + 1.0)).xyz;
	    vec4 _11203 = vec4(_22686, _19334.w);
	    _11203.x = _22686.x;
	    _11203.y = _22686.y;
	    _11203.z = _22686.z;
	    vec3 _15752 = _11203.xyz + (_13137.xyz * _13436).xyz;
	    vec4 _20490 = _11203;
	    _20490.x = _15752.x;
	    _20490.y = _15752.y;
	    _20490.z = _15752.z;
	    vec3 _15734 = _20490.xyz + ((((mix(_11427.xxx, _11427.yyy, _8357) * textureLod(samplerCubeArray(g_bindless_TextureCubeArray_float4[PerViewConstantBufferCsgo_t._m7], undetermined[_Globals_.g_sTrilinearClamp]), vec4(normalize(mix(_6253, reflect(_17138.xyz, _17892.xyz).xyz, vec3(_20711 * (sqrt(_20711) + _17225)))), 0.0), PerViewLightingConstantBufferGpu_t._m8.y * sqrt(_17172)).xyz).xyz * (normalize(_16991 + vec3(0.001000000047497451305389404296875)) * clamp(length(_16991), 0.0, 1.75))).xyz * (vec3(1.0) + (normalize(_8745 + vec3(0.001000000047497451305389404296875)) * 0.5))).xyz * _13436).xyz;
	    vec4 _13888 = _20490;
	    _13888.x = _15734.x;
	    _13888.y = _15734.y;
	    _13888.z = _15734.z;
	    vec4 _6805;
	    if (_Globals_.g_bFogEnabled != 0)
	    {
	        vec3 _21493;
	        vec3 _22956 = _10061.xyz - PerViewConstantBuffer_t._m3.xyz;
	        vec3 _9057 = _22956.xyz;
	        vec3 _19340;
	        do
	        {
	            _21493 = _22956.xyz;
	            bool _12889;
	            if (dot(_21493, _21493) > PerViewConstantBufferCsgo_t._m14.x)
	            {
	                _12889 = (_10061.z * PerViewConstantBufferCsgo_t._m14.z) < PerViewConstantBufferCsgo_t._m14.y;
	            }
	            else
	            {
	                _12889 = false;
	            }
	            if (_12889)
	            {
	                vec2 _9342 = clamp(PerViewConstantBufferCsgo_t._m11.xy + (PerViewConstantBufferCsgo_t._m11.zw * vec2(length(_21493), _10061.z)), vec2(0.0), vec2(1.0));
	                float _12872 = (pow(_9342.x, PerViewConstantBufferCsgo_t._m12.x) * pow(_9342.y, PerViewConstantBufferCsgo_t._m12.y)) * PerViewConstantBufferCsgo_t._m13.w;
	                _19340 = mix(_13888.xyz, vec4(PerViewConstantBufferCsgo_t._m13.xyz, _12872).xyz, vec3(_12872));
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
	            bool _12890;
	            if (dot(_9057, _9057) > PerViewConstantBufferCsgo_t._m18.x)
	            {
	                _12890 = (PerViewConstantBufferCsgo_t._m18.z * _10061.z) < PerViewConstantBufferCsgo_t._m18.y;
	            }
	            else
	            {
	                _12890 = false;
	            }
	            if (_12890)
	            {
	                float _14602 = clamp(pow(max(0.0, (length(_21493) * PerViewConstantBufferCsgo_t._m15.y) + PerViewConstantBufferCsgo_t._m15.x), PerViewConstantBufferCsgo_t._m15.w), 0.0, 1.0) * clamp(pow(max(0.0, (_10061.z * PerViewConstantBufferCsgo_t._m16.y) + PerViewConstantBufferCsgo_t._m16.x), PerViewConstantBufferCsgo_t._m16.z), 0.0, 1.0);
	                float _8892 = saturate(_14602) * PerViewConstantBufferCsgo_t._m18.w;
	                _19341 = mix(_23944.xyz, vec4((textureLod(samplerCube(g_bindless_TextureCube_float4[PerViewConstantBufferCsgo_t._m3], undetermined[_Globals_.g_sTrilinearClamp]), normalize((mat4(vec4(PerViewConstantBufferCsgo_t._m17._m0[0].x, PerViewConstantBufferCsgo_t._m17._m0[1].x, PerViewConstantBufferCsgo_t._m17._m0[2].x, PerViewConstantBufferCsgo_t._m17._m0[3].x), vec4(PerViewConstantBufferCsgo_t._m17._m0[0].y, PerViewConstantBufferCsgo_t._m17._m0[1].y, PerViewConstantBufferCsgo_t._m17._m0[2].y, PerViewConstantBufferCsgo_t._m17._m0[3].y), vec4(PerViewConstantBufferCsgo_t._m17._m0[0].z, PerViewConstantBufferCsgo_t._m17._m0[1].z, PerViewConstantBufferCsgo_t._m17._m0[2].z, PerViewConstantBufferCsgo_t._m17._m0[3].z), vec4(PerViewConstantBufferCsgo_t._m17._m0[0].w, PerViewConstantBufferCsgo_t._m17._m0[1].w, PerViewConstantBufferCsgo_t._m17._m0[2].w, PerViewConstantBufferCsgo_t._m17._m0[3].w)) * vec4(_9057, 0.0)).xyz).xyz, PerViewConstantBufferCsgo_t._m16.w * clamp(1.0 - (_14602 * PerViewConstantBufferCsgo_t._m15.z), 0.0, 1.0)) * PerViewConstantBufferCsgo_t._m19.x).xyz, _8892).xyz, vec3(_8892));
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
	#endif
	
	// SPIR-V reflection failed for backend HLSL:
	// Unsupported builtin in HLSL: 5326
	// 
	// Re-attempting reflection with the GLSL backend.
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (71144 bytes), GLSL reflection with SPIRV-Cross by KhronosGroup
	
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
	    vec3 vBlendColorTint;
	    vec2 _m1;
	    vec3 _m2;
	    vec4 _m3;
	    uvec4 _m4;
	    uint _m5;
	    vec4 _m6;
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
	
	vec4 _295;
	
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
	    uint _368 = g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 28u) / 4u];
	    uint _367 = g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 32u) / 4u];
	    vec4 _366 = vec4(g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 112u) / 4u], g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 116u) / 4u], g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 120u) / 4u], g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 124u) / 4u]);
	    vec4 _365 = vec4(g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 128u) / 4u], g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 132u) / 4u], g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 136u) / 4u], g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 140u) / 4u]);
	    vec2 _364 = vec2(g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 144u) / 4u], g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 148u) / 4u]);
	    vec3 _363 = vec3(g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 160u) / 4u], g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 164u) / 4u], g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 168u) / 4u]);
	    float _362 = g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 172u) / 4u];
	    uint _361 = g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 180u) / 4u];
	    bool _360 = g_MaterialData_5._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 188u) / 4u] != 0;
	    bool _359 = g_MaterialData_5._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 192u) / 4u] != 0;
	    float _358 = g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 196u) / 4u];
	    uint _357 = g_MaterialData_1._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 200u) / 4u];
	    bool _356 = g_MaterialData_5._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 300u) / 4u] != 0;
	    mat4 _355 = mat4(vec4(g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 304u) / 4u], g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 320u) / 4u], g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 336u) / 4u], g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 352u) / 4u]), vec4(g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 308u) / 4u], g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 324u) / 4u], g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 340u) / 4u], g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 356u) / 4u]), vec4(g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 312u) / 4u], g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 328u) / 4u], g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 344u) / 4u], g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 360u) / 4u]), vec4(g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 316u) / 4u], g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 332u) / 4u], g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 348u) / 4u], g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 364u) / 4u]));
	    mat4 _354 = mat4(vec4(g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 368u) / 4u], g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 384u) / 4u], g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 400u) / 4u], g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 416u) / 4u]), vec4(g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 372u) / 4u], g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 388u) / 4u], g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 404u) / 4u], g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 420u) / 4u]), vec4(g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 376u) / 4u], g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 392u) / 4u], g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 408u) / 4u], g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 424u) / 4u]), vec4(g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 380u) / 4u], g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 396u) / 4u], g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 412u) / 4u], g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 428u) / 4u]));
	    float _353 = g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 564u) / 4u];
	    float _352 = g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 568u) / 4u];
	    bool _351 = g_MaterialData_5._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 572u) / 4u] != 0;
	    float _350 = g_MaterialData_3._m0[(g_instanceBuffer._m0[uint(gl_InstanceID)].nMaterialData + 576u) / 4u];
	    uvec3 _467;
	    do
	    {
	        if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes.w == 4)
	        {
	            uint _783 = (12u * uint(gl_PrimitiveID)) + uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes.w);
	            _467 = uvec3(g_Indices_1[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._m0[_783 / 4u], g_Indices_1[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._m0[(_783 + 4u) / 4u], g_Indices_1[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._m0[(_783 + 8u) / 4u]);
	            break;
	        }
	        else
	        {
	            uint _758 = (6u * uint(gl_PrimitiveID)) + uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes.w);
	            uint _759 = _758 & 4294967292u;
	            uint _760 = _759 / 4u;
	            uint _764 = (_759 + 4u) / 4u;
	            uint _769 = (g_Indices_1[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._m0[_760] & 4294901760u) >> uint(16);
	            uint _770 = g_Indices_1[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._m0[_764] & 65535u;
	            uvec3 _468;
	            if (_758 == _759)
	            {
	                _468 = uvec3(g_Indices_1[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._m0[_760] & 65535u, _769, _770);
	            }
	            else
	            {
	                _468 = uvec3(_769, _770, (g_Indices_1[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.w]._m0[_764] & 4294901760u) >> uint(16));
	            }
	            _467 = _468;
	            break;
	        }
	        break;
	    } while(false);
	    uint _798 = uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers.x);
	    uvec3 _806 = (uvec3(uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes.x)) * _467) + uvec3(uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes.x));
	    vec3 _462[3];
	    uint _808 = _806.x;
	    _462[0] = vec3(g_Vertices_1[_798]._m0[_808 / 4u], g_Vertices_1[_798]._m0[(_808 + 4u) / 4u], g_Vertices_1[_798]._m0[(_808 + 8u) / 4u]);
	    uint _822 = _806.y;
	    _462[1] = vec3(g_Vertices_1[_798]._m0[_822 / 4u], g_Vertices_1[_798]._m0[(_822 + 4u) / 4u], g_Vertices_1[_798]._m0[(_822 + 8u) / 4u]);
	    uint _836 = _806.z;
	    _462[2] = vec3(g_Vertices_1[_798]._m0[_836 / 4u], g_Vertices_1[_798]._m0[(_836 + 4u) / 4u], g_Vertices_1[_798]._m0[(_836 + 8u) / 4u]);
	    int _463 = 0;
	    VS_INPUT vsInput[3];
	    for (;;)
	    {
	        if (!(_463 < 3))
	        {
	            break;
	        }
	        vsInput[_463].vBlendColorTint = _462[_463];
	        _463++;
	        continue;
	    }
	    vec2 _464[3];
	    _464[0] = vec2(0.0);
	    _464[1] = vec2(0.0);
	    _464[2] = vec2(0.0);
	    if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].y != 0)
	    {
	        ivec4 _461 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers;
	        uint _879 = uint(_461[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].z]);
	        uint _881 = uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].z);
	        ivec4 _459 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes;
	        ivec4 _460 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes;
	        uvec3 _892 = (uvec3(uint(_459[_881])) * _467) + uvec3(uint(_460[_881]) + uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].x));
	        if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].y == 16)
	        {
	            uint _1027 = _892.x;
	            _464[0] = vec2(g_Vertices_1[_879]._m0[_1027 / 4u], g_Vertices_1[_879]._m0[(_1027 + 4u) / 4u]);
	            uint _1036 = _892.y;
	            _464[1] = vec2(g_Vertices_1[_879]._m0[_1036 / 4u], g_Vertices_1[_879]._m0[(_1036 + 4u) / 4u]);
	            uint _1045 = _892.z;
	            _464[2] = vec2(g_Vertices_1[_879]._m0[_1045 / 4u], g_Vertices_1[_879]._m0[(_1045 + 4u) / 4u]);
	        }
	        else
	        {
	            if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].y == 34)
	            {
	                uint _998 = _892.x / 4u;
	                _464[0] = vec2(uint16BitsToFloat16(u16vec2(uvec2(g_Vertices_3[_879]._m0[_998], g_Vertices_3[_879]._m0[_998] >> uint(16)) & uvec2(65535u))));
	                uint _1008 = _892.y / 4u;
	                _464[1] = vec2(uint16BitsToFloat16(u16vec2(uvec2(g_Vertices_3[_879]._m0[_1008], g_Vertices_3[_879]._m0[_1008] >> uint(16)) & uvec2(65535u))));
	                uint _1018 = _892.z / 4u;
	                _464[2] = vec2(uint16BitsToFloat16(u16vec2(uvec2(g_Vertices_3[_879]._m0[_1018], g_Vertices_3[_879]._m0[_1018] >> uint(16)) & uvec2(65535u))));
	            }
	            else
	            {
	                if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTexCoordFieldInfo.data[0].y == 37)
	                {
	                    uint _905 = _892.x / 4u;
	                    uint _909 = (g_Vertices_3[_879]._m0[_905] & 65535u);
	                    int _458;
	                    if (_909 > 32767u)
	                    {
	                        _458 = int(4294901760u | _909);
	                    }
	                    else
	                    {
	                        _458 = int(_909);
	                    }
	                    uint _922 = (g_Vertices_3[_879]._m0[_905] & 4294901760u) >> uint(16);
	                    int _457;
	                    if (_922 > 32767u)
	                    {
	                        _457 = int(4294901760u | _922);
	                    }
	                    else
	                    {
	                        _457 = int(_922);
	                    }
	                    _464[0] = vec2(max(float(_458) * 3.0518509447574615478515625e-05, -1.0), max(float(_457) * 3.0518509447574615478515625e-05, -1.0));
	                    uint _936 = _892.y / 4u;
	                    uint _940 = (g_Vertices_3[_879]._m0[_936] & 65535u);
	                    int _456;
	                    if (_940 > 32767u)
	                    {
	                        _456 = int(4294901760u | _940);
	                    }
	                    else
	                    {
	                        _456 = int(_940);
	                    }
	                    uint _953 = (g_Vertices_3[_879]._m0[_936] & 4294901760u) >> uint(16);
	                    int _455;
	                    if (_953 > 32767u)
	                    {
	                        _455 = int(4294901760u | _953);
	                    }
	                    else
	                    {
	                        _455 = int(_953);
	                    }
	                    _464[1] = vec2(max(float(_456) * 3.0518509447574615478515625e-05, -1.0), max(float(_455) * 3.0518509447574615478515625e-05, -1.0));
	                    uint _967 = _892.z / 4u;
	                    uint _971 = (g_Vertices_3[_879]._m0[_967] & 65535u);
	                    int _454;
	                    if (_971 > 32767u)
	                    {
	                        _454 = int(4294901760u | _971);
	                    }
	                    else
	                    {
	                        _454 = int(_971);
	                    }
	                    uint _984 = (g_Vertices_3[_879]._m0[_967] & 4294901760u) >> uint(16);
	                    int _453;
	                    if (_984 > 32767u)
	                    {
	                        _453 = int(4294901760u | _984);
	                    }
	                    else
	                    {
	                        _453 = int(_984);
	                    }
	                    _464[2] = vec2(max(float(_454) * 3.0518509447574615478515625e-05, -1.0), max(float(_453) * 3.0518509447574615478515625e-05, -1.0));
	                }
	            }
	        }
	    }
	    _463 = 0;
	    for (;;)
	    {
	        if (!(_463 < 3))
	        {
	            break;
	        }
	        vsInput[_463]._m1 = _464[_463];
	        _463++;
	        continue;
	    }
	    vec3 _465[3];
	    vec4 _466[3];
	    do
	    {
	        if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.y != 0)
	        {
	            ivec4 _439 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers;
	            uint _1087 = uint(_439[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.z]);
	            uint _1089 = uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.z);
	            ivec4 _437 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes;
	            ivec4 _438 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes;
	            uvec3 _1100 = (uvec3(uint(_437[_1089])) * _467) + uvec3(uint(_438[_1089]) + uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.x));
	            if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.y == 6)
	            {
	                uint _1631 = _1100.x;
	                _465[0] = vec3(g_Vertices_1[_1087]._m0[_1631 / 4u], g_Vertices_1[_1087]._m0[(_1631 + 4u) / 4u], g_Vertices_1[_1087]._m0[(_1631 + 8u) / 4u]);
	                uint _1645 = _1100.y;
	                _465[1] = vec3(g_Vertices_1[_1087]._m0[_1645 / 4u], g_Vertices_1[_1087]._m0[(_1645 + 4u) / 4u], g_Vertices_1[_1087]._m0[(_1645 + 8u) / 4u]);
	                uint _1659 = _1100.z;
	                _465[2] = vec3(g_Vertices_1[_1087]._m0[_1659 / 4u], g_Vertices_1[_1087]._m0[(_1659 + 4u) / 4u], g_Vertices_1[_1087]._m0[(_1659 + 8u) / 4u]);
	            }
	            else
	            {
	                if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vNormalFieldInfo.y == 17)
	                {
	                    uint _1364 = _1100.x;
	                    uvec2 _1372 = uvec2(g_Vertices_3[_1087]._m0[_1364 / 4u], g_Vertices_3[_1087]._m0[(_1364 + 4u) / 4u]);
	                    uint _1373 = _1100.y;
	                    uvec2 _313 = uvec2(g_Vertices_3[_1087]._m0[_1373 / 4u], g_Vertices_3[_1087]._m0[(_1373 + 4u) / 4u]);
	                    uint _1382 = _1100.z;
	                    uvec2 _312 = uvec2(g_Vertices_3[_1087]._m0[_1382 / 4u], g_Vertices_3[_1087]._m0[(_1382 + 4u) / 4u]);
	                    uint _1394 = _1372.x;
	                    uint _1403 = _1372.y;
	                    vec2 _1413 = ((vec2(float((_1394) & 65535u), float((_1394 >> 16u) & 65535u)) * vec2(1.525902189314365386962890625e-05)) * 2.0) - vec2(1.0);
	                    float _1414 = _1413.x;
	                    float _1419 = (1.0 - abs(_1414)) - abs(_1413.y);
	                    vec3 _1420 = vec3(_1414, _1413.y, _1419);
	                    float _1422 = saturate(-_1419);
	                    vec2 _1428 = _1413 + mix(vec2(_1422), vec2(-_1422), greaterThanEqual(_1413, vec2(0.0)));
	                    _1420.x = _1428.x;
	                    _1420.y = _1428.y;
	                    vec3 _447 = normalize(_1420);
	                    vec2 _1435 = ((vec2(float((_1403 >> uint(1)) & 32767u), float((_1403 >> 16u) & 32767u)) * vec2(3.0518509447574615478515625e-05)) * 2.0) - vec2(1.0);
	                    float _1436 = _1435.x;
	                    float _1441 = (1.0 - abs(_1436)) - abs(_1435.y);
	                    vec3 _1442 = vec3(_1436, _1435.y, _1441);
	                    float _1444 = saturate(-_1441);
	                    vec2 _1450 = _1435 + mix(vec2(_1444), vec2(-_1444), greaterThanEqual(_1435, vec2(0.0)));
	                    _1442.x = _1450.x;
	                    _1442.y = _1450.y;
	                    vec3 _446 = normalize(_1442);
	                    float _427;
	                    if ((_1403 & 1u) != 0u)
	                    {
	                        _427 = 1.0;
	                    }
	                    else
	                    {
	                        _427 = -1.0;
	                    }
	                    _465[0] = _447;
	                    _466[0].w = _427;
	                    _466[0].x = _446.x;
	                    _466[0].y = _446.y;
	                    _466[0].z = _446.z;
	                    vec2 _1493 = ((vec2(float((_313.x) & 65535u), float((_313.x >> 16u) & 65535u)) * vec2(1.525902189314365386962890625e-05)) * 2.0) - vec2(1.0);
	                    float _1494 = _1493.x;
	                    float _1499 = (1.0 - abs(_1494)) - abs(_1493.y);
	                    vec3 _1500 = vec3(_1494, _1493.y, _1499);
	                    float _1502 = saturate(-_1499);
	                    vec2 _1508 = _1493 + mix(vec2(_1502), vec2(-_1502), greaterThanEqual(_1493, vec2(0.0)));
	                    _1500.x = _1508.x;
	                    _1500.y = _1508.y;
	                    vec3 _449 = normalize(_1500);
	                    vec2 _1515 = ((vec2(float((_313.y >> uint(1)) & 32767u), float((_313.y >> 16u) & 32767u)) * vec2(3.0518509447574615478515625e-05)) * 2.0) - vec2(1.0);
	                    float _1516 = _1515.x;
	                    float _1521 = (1.0 - abs(_1516)) - abs(_1515.y);
	                    vec3 _1522 = vec3(_1516, _1515.y, _1521);
	                    float _1524 = saturate(-_1521);
	                    vec2 _1530 = _1515 + mix(vec2(_1524), vec2(-_1524), greaterThanEqual(_1515, vec2(0.0)));
	                    _1522.x = _1530.x;
	                    _1522.y = _1530.y;
	                    vec3 _448 = normalize(_1522);
	                    float _426;
	                    if ((_313.y & 1u) != 0u)
	                    {
	                        _426 = 1.0;
	                    }
	                    else
	                    {
	                        _426 = -1.0;
	                    }
	                    _465[1] = _449;
	                    _466[1].w = _426;
	                    _466[1].x = _448.x;
	                    _466[1].y = _448.y;
	                    _466[1].z = _448.z;
	                    vec2 _1573 = ((vec2(float((_312.x) & 65535u), float((_312.x >> 16u) & 65535u)) * vec2(1.525902189314365386962890625e-05)) * 2.0) - vec2(1.0);
	                    float _1574 = _1573.x;
	                    float _1579 = (1.0 - abs(_1574)) - abs(_1573.y);
	                    vec3 _1580 = vec3(_1574, _1573.y, _1579);
	                    float _1582 = saturate(-_1579);
	                    vec2 _1588 = _1573 + mix(vec2(_1582), vec2(-_1582), greaterThanEqual(_1573, vec2(0.0)));
	                    _1580.x = _1588.x;
	                    _1580.y = _1588.y;
	                    vec3 _451 = normalize(_1580);
	                    vec2 _1595 = ((vec2(float((_312.y >> uint(1)) & 32767u), float((_312.y >> 16u) & 32767u)) * vec2(3.0518509447574615478515625e-05)) * 2.0) - vec2(1.0);
	                    float _1596 = _1595.x;
	                    float _1601 = (1.0 - abs(_1596)) - abs(_1595.y);
	                    vec3 _1602 = vec3(_1596, _1595.y, _1601);
	                    float _1604 = saturate(-_1601);
	                    vec2 _1610 = _1595 + mix(vec2(_1604), vec2(-_1604), greaterThanEqual(_1595, vec2(0.0)));
	                    _1602.x = _1610.x;
	                    _1602.y = _1610.y;
	                    vec3 _450 = normalize(_1602);
	                    float _425;
	                    if ((_312.y & 1u) != 0u)
	                    {
	                        _425 = 1.0;
	                    }
	                    else
	                    {
	                        _425 = -1.0;
	                    }
	                    _465[2] = _451;
	                    _466[2].w = _425;
	                    _466[2].x = _450.x;
	                    _466[2].y = _450.y;
	                    _466[2].z = _450.z;
	                    break;
	                }
	                else
	                {
	                    uint _1110 = _1100.x / 4u;
	                    vec4 _441 = _466[0];
	                    float _1125 = (float((g_Vertices_3[_1087]._m0[_1110] >> 12u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _1128 = (float((g_Vertices_3[_1087]._m0[_1110] >> 22u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _1132 = (1.0 - abs(_1125)) - abs(_1128);
	                    vec3 _1133 = vec3(_1125, _1128, _1132);
	                    float _1135 = saturate(-_1132);
	                    vec2 _1136 = vec2(_1125, _1128);
	                    vec2 _1142 = _1136 + mix(vec2(_1135), vec2(-_1135), greaterThanEqual(_1136, vec2(0.0)));
	                    _1133.x = _1142.x;
	                    _1133.y = _1142.y;
	                    vec3 _1147 = normalize(_1133);
	                    vec3 _440 = _1147;
	                    float _1148 = _1147.z;
	                    float _434;
	                    if (_1148 >= 0.0)
	                    {
	                        _434 = 1.0;
	                    }
	                    else
	                    {
	                        _434 = -1.0;
	                    }
	                    float _1155 = (-1.0) / (_434 + _1148);
	                    float _1156 = _1147.x;
	                    vec3 _435;
	                    vec3 _1164 = _435;
	                    _1164.x = 1.0 + (((_434 * _1156) * _1156) * _1155);
	                    _1164.y = _434 * ((_1156 * _1147.y) * _1155);
	                    _1164.z = (-_434) * _1156;
	                    _435 = _1164;
	                    float _1172 = float((g_Vertices_3[_1087]._m0[_1110] >> uint(1)) & 2047u) * 0.003069460391998291015625;
	                    vec3 _1178 = (_1164 * cos(_1172)) + (cross(_1147, _1164) * sin(_1172));
	                    vec4 _1180 = _441;
	                    _1180.x = _1178.x;
	                    _1180.y = _1178.y;
	                    _1180.z = _1178.z;
	                    _441 = _1180;
	                    float _436;
	                    if ((g_Vertices_3[_1087]._m0[_1110] & 1u) == 0u)
	                    {
	                        _436 = -1.0;
	                    }
	                    else
	                    {
	                        _436 = 1.0;
	                    }
	                    vec4 _1191 = _441;
	                    _1191.w = _436;
	                    _441 = _1191;
	                    _465[0] = _440;
	                    _466[0] = _1191;
	                    uint _1195 = _1100.y / 4u;
	                    vec4 _443 = _466[1];
	                    float _1210 = (float((g_Vertices_3[_1087]._m0[_1195] >> 12u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _1213 = (float((g_Vertices_3[_1087]._m0[_1195] >> 22u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _1217 = (1.0 - abs(_1210)) - abs(_1213);
	                    vec3 _1218 = vec3(_1210, _1213, _1217);
	                    float _1220 = saturate(-_1217);
	                    vec2 _1221 = vec2(_1210, _1213);
	                    vec2 _1227 = _1221 + mix(vec2(_1220), vec2(-_1220), greaterThanEqual(_1221, vec2(0.0)));
	                    _1218.x = _1227.x;
	                    _1218.y = _1227.y;
	                    vec3 _1232 = normalize(_1218);
	                    vec3 _442 = _1232;
	                    float _1233 = _1232.z;
	                    float _431;
	                    if (_1233 >= 0.0)
	                    {
	                        _431 = 1.0;
	                    }
	                    else
	                    {
	                        _431 = -1.0;
	                    }
	                    float _1240 = (-1.0) / (_431 + _1233);
	                    float _1241 = _1232.x;
	                    vec3 _432;
	                    vec3 _1249 = _432;
	                    _1249.x = 1.0 + (((_431 * _1241) * _1241) * _1240);
	                    _1249.y = _431 * ((_1241 * _1232.y) * _1240);
	                    _1249.z = (-_431) * _1241;
	                    _432 = _1249;
	                    float _1257 = float((g_Vertices_3[_1087]._m0[_1195] >> uint(1)) & 2047u) * 0.003069460391998291015625;
	                    vec3 _1263 = (_1249 * cos(_1257)) + (cross(_1232, _1249) * sin(_1257));
	                    vec4 _1265 = _443;
	                    _1265.x = _1263.x;
	                    _1265.y = _1263.y;
	                    _1265.z = _1263.z;
	                    _443 = _1265;
	                    float _433;
	                    if ((g_Vertices_3[_1087]._m0[_1195] & 1u) == 0u)
	                    {
	                        _433 = -1.0;
	                    }
	                    else
	                    {
	                        _433 = 1.0;
	                    }
	                    vec4 _1276 = _443;
	                    _1276.w = _433;
	                    _443 = _1276;
	                    _465[1] = _442;
	                    _466[1] = _1276;
	                    uint _1280 = _1100.z / 4u;
	                    vec4 _445 = _466[2];
	                    float _1295 = (float((g_Vertices_3[_1087]._m0[_1280] >> 12u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _1298 = (float((g_Vertices_3[_1087]._m0[_1280] >> 22u) & 1023u) * 0.00195503421127796173095703125) - 1.0;
	                    float _1302 = (1.0 - abs(_1295)) - abs(_1298);
	                    vec3 _1303 = vec3(_1295, _1298, _1302);
	                    float _1305 = saturate(-_1302);
	                    vec2 _1306 = vec2(_1295, _1298);
	                    vec2 _1312 = _1306 + mix(vec2(_1305), vec2(-_1305), greaterThanEqual(_1306, vec2(0.0)));
	                    _1303.x = _1312.x;
	                    _1303.y = _1312.y;
	                    vec3 _1317 = normalize(_1303);
	                    vec3 _444 = _1317;
	                    float _1318 = _1317.z;
	                    float _428;
	                    if (_1318 >= 0.0)
	                    {
	                        _428 = 1.0;
	                    }
	                    else
	                    {
	                        _428 = -1.0;
	                    }
	                    float _1325 = (-1.0) / (_428 + _1318);
	                    float _1326 = _1317.x;
	                    vec3 _429;
	                    vec3 _1334 = _429;
	                    _1334.x = 1.0 + (((_428 * _1326) * _1326) * _1325);
	                    _1334.y = _428 * ((_1326 * _1317.y) * _1325);
	                    _1334.z = (-_428) * _1326;
	                    _429 = _1334;
	                    float _1342 = float((g_Vertices_3[_1087]._m0[_1280] >> uint(1)) & 2047u) * 0.003069460391998291015625;
	                    vec3 _1348 = (_1334 * cos(_1342)) + (cross(_1317, _1334) * sin(_1342));
	                    vec4 _1350 = _445;
	                    _1350.x = _1348.x;
	                    _1350.y = _1348.y;
	                    _1350.z = _1348.z;
	                    _445 = _1350;
	                    float _430;
	                    if ((g_Vertices_3[_1087]._m0[_1280] & 1u) == 0u)
	                    {
	                        _430 = -1.0;
	                    }
	                    else
	                    {
	                        _430 = 1.0;
	                    }
	                    vec4 _1361 = _445;
	                    _1361.w = _430;
	                    _445 = _1361;
	                    _465[2] = _444;
	                    _466[2] = _1361;
	                    break;
	                }
	                break;
	            }
	        }
	        else
	        {
	            _465[0] = vec3(0.0);
	            _465[1] = vec3(0.0);
	            _465[2] = vec3(0.0);
	        }
	        if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTangentFieldInfo.y != 0)
	        {
	            ivec4 _452 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers;
	            uint _1684 = uint(_452[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTangentFieldInfo.z]);
	            uint _1686 = uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTangentFieldInfo.z);
	            ivec4 _423 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes;
	            ivec4 _424 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes;
	            uvec3 _1697 = (uvec3(uint(_423[_1686])) * _467) + uvec3(uint(_424[_1686]) + uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vTangentFieldInfo.x));
	            uint _1699 = _1697.x;
	            _466[0] = vec4(g_Vertices_1[_1684]._m0[_1699 / 4u], g_Vertices_1[_1684]._m0[(_1699 + 4u) / 4u], g_Vertices_1[_1684]._m0[(_1699 + 8u) / 4u], g_Vertices_1[_1684]._m0[(_1699 + 12u) / 4u]);
	            uint _1717 = _1697.y;
	            _466[1] = vec4(g_Vertices_1[_1684]._m0[_1717 / 4u], g_Vertices_1[_1684]._m0[(_1717 + 4u) / 4u], g_Vertices_1[_1684]._m0[(_1717 + 8u) / 4u], g_Vertices_1[_1684]._m0[(_1717 + 12u) / 4u]);
	            uint _1735 = _1697.z;
	            _466[2] = vec4(g_Vertices_1[_1684]._m0[_1735 / 4u], g_Vertices_1[_1684]._m0[(_1735 + 4u) / 4u], g_Vertices_1[_1684]._m0[(_1735 + 8u) / 4u], g_Vertices_1[_1684]._m0[(_1735 + 12u) / 4u]);
	        }
	        else
	        {
	            _466[0] = vec4(0.0);
	            _466[1] = vec4(0.0);
	            _466[2] = vec4(0.0);
	        }
	        break;
	    } while(false);
	    _463 = 0;
	    for (;;)
	    {
	        if (!(_463 < 3))
	        {
	            break;
	        }
	        vsInput[_463]._m2 = _465[_463];
	        vsInput[_463]._m3 = _466[_463];
	        _463++;
	        continue;
	    }
	    vec4 _469[3];
	    _469[0] = vec4(0.0);
	    _469[1] = vec4(0.0);
	    _469[2] = vec4(0.0);
	    if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vColorFieldInfo.data[0].y != 0)
	    {
	        ivec4 _422 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nVertexAndIndexBuffers;
	        uint _1789 = uint(_422[g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vColorFieldInfo.data[0].z]);
	        uint _1791 = uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vColorFieldInfo.data[0].z);
	        ivec4 _420 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferStrideInBytes;
	        ivec4 _421 = g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_nBufferBindOffsetBytes;
	        uvec3 _1802 = (uvec3(uint(_420[_1791])) * _467) + uvec3(uint(_421[_1791]) + uint(g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vColorFieldInfo.data[0].x));
	        if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vColorFieldInfo.data[0].y == 2)
	        {
	            uint _1855 = _1802.x;
	            _469[0] = vec4(g_Vertices_1[_1789]._m0[_1855 / 4u], g_Vertices_1[_1789]._m0[(_1855 + 4u) / 4u], g_Vertices_1[_1789]._m0[(_1855 + 8u) / 4u], g_Vertices_1[_1789]._m0[(_1855 + 12u) / 4u]);
	            uint _1872 = _1802.y;
	            _469[1] = vec4(g_Vertices_1[_1789]._m0[_1872 / 4u], g_Vertices_1[_1789]._m0[(_1872 + 4u) / 4u], g_Vertices_1[_1789]._m0[(_1872 + 8u) / 4u], g_Vertices_1[_1789]._m0[(_1872 + 12u) / 4u]);
	            uint _1889 = _1802.z;
	            _469[2] = vec4(g_Vertices_1[_1789]._m0[_1889 / 4u], g_Vertices_1[_1789]._m0[(_1889 + 4u) / 4u], g_Vertices_1[_1789]._m0[(_1889 + 8u) / 4u], g_Vertices_1[_1789]._m0[(_1889 + 12u) / 4u]);
	        }
	        else
	        {
	            if (g_Geometries_1._m0[uint(gl_InstanceCustomIndexEXT)].m_vColorFieldInfo.data[0].y == 28)
	            {
	                uint _1811 = _1802.x / 4u;
	                _469[0] = vec4(uvec4((g_Vertices_3[_1789]._m0[_1811] & 255u), (g_Vertices_3[_1789]._m0[_1811] & 65280u) >> uint(8), (g_Vertices_3[_1789]._m0[_1811] & 16711680u) >> uint(16), (g_Vertices_3[_1789]._m0[_1811] & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	                uint _1826 = _1802.y / 4u;
	                _469[1] = vec4(uvec4((g_Vertices_3[_1789]._m0[_1826] & 255u), (g_Vertices_3[_1789]._m0[_1826] & 65280u) >> uint(8), (g_Vertices_3[_1789]._m0[_1826] & 16711680u) >> uint(16), (g_Vertices_3[_1789]._m0[_1826] & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	                uint _1841 = _1802.z / 4u;
	                _469[2] = vec4(uvec4((g_Vertices_3[_1789]._m0[_1841] & 255u), (g_Vertices_3[_1789]._m0[_1841] & 65280u) >> uint(8), (g_Vertices_3[_1789]._m0[_1841] & 16711680u) >> uint(16), (g_Vertices_3[_1789]._m0[_1841] & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	            }
	        }
	    }
	    int _470 = 0;
	    for (;;)
	    {
	        if (!(_470 < 3))
	        {
	            break;
	        }
	        vsInput[_470]._m6 = _469[_470];
	        _470++;
	        continue;
	    }
	    vec3 _418 = vsInput[0]._m2;
	    vec4 _419;
	    vec4 _1930 = _419;
	    _1930.x = vsInput[0]._m3.x;
	    _1930.y = vsInput[0]._m3.y;
	    _1930.z = vsInput[0]._m3.z;
	    _1930.w = vsInput[0]._m3.w;
	    _419 = _1930;
	    vec4 _1955 = vec4(uvec4((g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 255u), (g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 65280u) >> uint(8), (g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 16711680u) >> uint(16), (g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	    vec4 _417 = _1955;
	    vec3 _1956 = _1955.xyz;
	    vec3 _1957 = _1956 * vec3(0.077399380505084991455078125);
	    vec3 _1960 = pow((_1956 * vec3(0.947867333889007568359375)) + vec3(0.052132703363895416259765625), vec3(2.400000095367431640625));
	    float _414;
	    if (_1955.x <= 0.040449999272823333740234375)
	    {
	        _414 = _1957.x;
	    }
	    else
	    {
	        _414 = _1960.x;
	    }
	    float _415;
	    if (_1955.y <= 0.040449999272823333740234375)
	    {
	        _415 = _1957.y;
	    }
	    else
	    {
	        _415 = _1960.y;
	    }
	    float _416;
	    if (_1955.z <= 0.040449999272823333740234375)
	    {
	        _416 = _1957.z;
	    }
	    else
	    {
	        _416 = _1960.z;
	    }
	    vec3 _1985 = vec3(_414, _415, _416);
	    vec4 _1987 = _417;
	    _1987.x = _1985.x;
	    _1987.y = _1985.y;
	    _1987.z = _1985.z;
	    _417 = _1987;
	    vec4 _315;
	    vec4 _1994 = _315;
	    _1994.x = _1987.x;
	    _1994.y = _1987.y;
	    _1994.z = _1987.z;
	    _1994.w = _1987.w;
	    _315 = _1994;
	    mat3x4 _2005 = transpose(gl_WorldToObjectEXT);
	    mat3 _413;
	    mat3 _2008 = _413;
	    _2008[0] = _2005[0].xyz;
	    _2008[1] = _2005[1].xyz;
	    _2008[2] = _2005[2].xyz;
	    _413 = _2008;
	    vec3 _2017 = normalize(_2008 * _418.xyz);
	    vec3 _316;
	    vec3 _2019 = _316;
	    _2019.x = _2017.x;
	    _2019.y = _2017.y;
	    _2019.z = _2017.z;
	    _316 = _2019;
	    mat3x4 _2031 = transpose(gl_WorldToObjectEXT);
	    mat3 _412;
	    mat3 _2034 = _412;
	    _2034[0] = _2031[0].xyz;
	    _2034[1] = _2031[1].xyz;
	    _2034[2] = _2031[2].xyz;
	    _412 = _2034;
	    vec3 _2043 = normalize(_2034 * _419.xyz);
	    vec4 _314;
	    vec4 _2045 = _314;
	    _2045.x = _2043.x;
	    _2045.y = _2043.y;
	    _2045.z = _2043.z;
	    _2045.w = _419.w;
	    _314 = _2045;
	    vec4 _2054 = vsInput[0]._m1.xyxy;
	    vec4 _2067 = _2054;
	    _2067.x = dot(_2054.xy, _366.xy) + _366.w;
	    _2067.y = dot(_2054.xy, _365.xy) + _365.w;
	    vec2 _2075 = _2067.xy + (_364.xy * PerViewConstantBuffer_t.g_flGameTime);
	    vec4 _2077 = _2067;
	    _2077.x = _2075.x;
	    _2077.y = _2075.y;
	    vec3 _2083 = mix(vec3(1.0), _1994.xyz, vec3(_362));
	    vec4 _2085 = _1994;
	    _2085.x = _2083.x;
	    _2085.y = _2083.y;
	    _2085.z = _2083.z;
	    vec3 _2093 = _2085.xyz * _363.xyz;
	    vec4 _2095 = _2085;
	    _2095.x = _2093.x;
	    _2095.y = _2093.y;
	    _2095.z = _2093.z;
	    vec3 _311 = vec4(vsInput[0].vBlendColorTint.xyz, 1.0) * transpose(gl_ObjectToWorldEXT);
	    vec3 _310 = _2019;
	    vec4 _309 = _2077;
	    vec4 _308 = _2095;
	    vec4 _307 = _2045;
	    vec3 _410 = vsInput[1]._m2;
	    vec4 _411;
	    vec4 _2105 = _411;
	    _2105.x = vsInput[1]._m3.x;
	    _2105.y = vsInput[1]._m3.y;
	    _2105.z = vsInput[1]._m3.z;
	    _2105.w = vsInput[1]._m3.w;
	    _411 = _2105;
	    vec4 _2130 = vec4(uvec4((g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 255u), (g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 65280u) >> uint(8), (g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 16711680u) >> uint(16), (g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	    vec4 _409 = _2130;
	    vec3 _2131 = _2130.xyz;
	    vec3 _2132 = _2131 * vec3(0.077399380505084991455078125);
	    vec3 _2135 = pow((_2131 * vec3(0.947867333889007568359375)) + vec3(0.052132703363895416259765625), vec3(2.400000095367431640625));
	    float _406;
	    if (_2130.x <= 0.040449999272823333740234375)
	    {
	        _406 = _2132.x;
	    }
	    else
	    {
	        _406 = _2135.x;
	    }
	    float _407;
	    if (_2130.y <= 0.040449999272823333740234375)
	    {
	        _407 = _2132.y;
	    }
	    else
	    {
	        _407 = _2135.y;
	    }
	    float _408;
	    if (_2130.z <= 0.040449999272823333740234375)
	    {
	        _408 = _2132.z;
	    }
	    else
	    {
	        _408 = _2135.z;
	    }
	    vec3 _2160 = vec3(_406, _407, _408);
	    vec4 _2162 = _409;
	    _2162.x = _2160.x;
	    _2162.y = _2160.y;
	    _2162.z = _2160.z;
	    _409 = _2162;
	    vec4 _318;
	    vec4 _2169 = _318;
	    _2169.x = _2162.x;
	    _2169.y = _2162.y;
	    _2169.z = _2162.z;
	    _2169.w = _2162.w;
	    _318 = _2169;
	    mat3x4 _2180 = transpose(gl_WorldToObjectEXT);
	    mat3 _405;
	    mat3 _2183 = _405;
	    _2183[0] = _2180[0].xyz;
	    _2183[1] = _2180[1].xyz;
	    _2183[2] = _2180[2].xyz;
	    _405 = _2183;
	    vec3 _2192 = normalize(_2183 * _410.xyz);
	    vec3 _319;
	    vec3 _2194 = _319;
	    _2194.x = _2192.x;
	    _2194.y = _2192.y;
	    _2194.z = _2192.z;
	    _319 = _2194;
	    mat3x4 _2206 = transpose(gl_WorldToObjectEXT);
	    mat3 _404;
	    mat3 _2209 = _404;
	    _2209[0] = _2206[0].xyz;
	    _2209[1] = _2206[1].xyz;
	    _2209[2] = _2206[2].xyz;
	    _404 = _2209;
	    vec3 _2218 = normalize(_2209 * _411.xyz);
	    vec4 _317;
	    vec4 _2220 = _317;
	    _2220.x = _2218.x;
	    _2220.y = _2218.y;
	    _2220.z = _2218.z;
	    _2220.w = _411.w;
	    _317 = _2220;
	    vec4 _2229 = vsInput[1]._m1.xyxy;
	    vec4 _2242 = _2229;
	    _2242.x = dot(_2229.xy, _366.xy) + _366.w;
	    _2242.y = dot(_2229.xy, _365.xy) + _365.w;
	    vec2 _2250 = _2242.xy + (_364.xy * PerViewConstantBuffer_t.g_flGameTime);
	    vec4 _2252 = _2242;
	    _2252.x = _2250.x;
	    _2252.y = _2250.y;
	    vec3 _2258 = mix(vec3(1.0), _2169.xyz, vec3(_362));
	    vec4 _2260 = _2169;
	    _2260.x = _2258.x;
	    _2260.y = _2258.y;
	    _2260.z = _2258.z;
	    vec3 _2268 = _2260.xyz * _363.xyz;
	    vec4 _2270 = _2260;
	    _2270.x = _2268.x;
	    _2270.y = _2268.y;
	    _2270.z = _2268.z;
	    vec3 _306 = vec4(vsInput[1].vBlendColorTint.xyz, 1.0) * transpose(gl_ObjectToWorldEXT);
	    vec3 _305 = _2194;
	    vec4 _304 = _2252;
	    vec4 _303 = _2270;
	    vec4 _302 = _2220;
	    vec3 _402 = vsInput[2]._m2;
	    vec4 _403;
	    vec4 _2280 = _403;
	    _2280.x = vsInput[2]._m3.x;
	    _2280.y = vsInput[2]._m3.y;
	    _2280.z = vsInput[2]._m3.z;
	    _2280.w = vsInput[2]._m3.w;
	    _403 = _2280;
	    vec4 _2305 = vec4(uvec4((g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 255u), (g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 65280u) >> uint(8), (g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 16711680u) >> uint(16), (g_instanceBuffer._m0[uint(gl_InstanceID)].nSrgbColor & 4278190080u) >> uint(24))) * vec4(0.0039215688593685626983642578125);
	    vec4 _401 = _2305;
	    vec3 _2306 = _2305.xyz;
	    vec3 _2307 = _2306 * vec3(0.077399380505084991455078125);
	    vec3 _2310 = pow((_2306 * vec3(0.947867333889007568359375)) + vec3(0.052132703363895416259765625), vec3(2.400000095367431640625));
	    float _398;
	    if (_2305.x <= 0.040449999272823333740234375)
	    {
	        _398 = _2307.x;
	    }
	    else
	    {
	        _398 = _2310.x;
	    }
	    float _399;
	    if (_2305.y <= 0.040449999272823333740234375)
	    {
	        _399 = _2307.y;
	    }
	    else
	    {
	        _399 = _2310.y;
	    }
	    float _400;
	    if (_2305.z <= 0.040449999272823333740234375)
	    {
	        _400 = _2307.z;
	    }
	    else
	    {
	        _400 = _2310.z;
	    }
	    vec3 _2335 = vec3(_398, _399, _400);
	    vec4 _2337 = _401;
	    _2337.x = _2335.x;
	    _2337.y = _2335.y;
	    _2337.z = _2335.z;
	    _401 = _2337;
	    vec4 _321;
	    vec4 _2344 = _321;
	    _2344.x = _2337.x;
	    _2344.y = _2337.y;
	    _2344.z = _2337.z;
	    _2344.w = _2337.w;
	    _321 = _2344;
	    mat3x4 _2355 = transpose(gl_WorldToObjectEXT);
	    mat3 _397;
	    mat3 _2358 = _397;
	    _2358[0] = _2355[0].xyz;
	    _2358[1] = _2355[1].xyz;
	    _2358[2] = _2355[2].xyz;
	    _397 = _2358;
	    vec3 _2367 = normalize(_2358 * _402.xyz);
	    vec3 _322;
	    vec3 _2369 = _322;
	    _2369.x = _2367.x;
	    _2369.y = _2367.y;
	    _2369.z = _2367.z;
	    _322 = _2369;
	    vec3 _2377 = vec4(vsInput[2].vBlendColorTint.xyz, 1.0) * transpose(gl_ObjectToWorldEXT);
	    mat3x4 _2381 = transpose(gl_WorldToObjectEXT);
	    mat3 _396;
	    mat3 _2384 = _396;
	    _2384[0] = _2381[0].xyz;
	    _2384[1] = _2381[1].xyz;
	    _2384[2] = _2381[2].xyz;
	    _396 = _2384;
	    vec3 _2393 = normalize(_2384 * _403.xyz);
	    vec4 _320;
	    vec4 _2395 = _320;
	    _2395.x = _2393.x;
	    _2395.y = _2393.y;
	    _2395.z = _2393.z;
	    _2395.w = _403.w;
	    _320 = _2395;
	    vec4 _2417;
	    _2417.x = dot(vsInput[2]._m1.xyxy.xy, _366.xy) + _366.w;
	    _2417.y = dot(vsInput[2]._m1.xyxy.xy, _365.xy) + _365.w;
	    vec2 _2425 = _2417.xy + (_364.xy * PerViewConstantBuffer_t.g_flGameTime);
	    vec4 _2427;
	    _2427.x = _2425.x;
	    _2427.y = _2425.y;
	    vec3 _2433 = mix(vec3(1.0), _2344.xyz, vec3(_362));
	    vec4 _2435;
	    _2435.x = _2433.x;
	    _2435.y = _2433.y;
	    _2435.z = _2433.z;
	    vec3 _2443 = _2435.xyz * _363.xyz;
	    vec4 _2445;
	    _2445.x = _2443.x;
	    _2445.y = _2443.y;
	    _2445.z = _2443.z;
	    vec3 _301 = _2377;
	    vec3 _300 = _2369;
	    vec3 _2469 = ((_310 * ((1.0 - _22.barycentrics.x) - _22.barycentrics.y)) + (_305 * _22.barycentrics.x)) + (_2369 * _22.barycentrics.y);
	    bool _2475 = gl_HitKindEXT == 254u;
	    vec4 _2484 = ((_309 * ((1.0 - _22.barycentrics.x) - _22.barycentrics.y)) + (_304 * _22.barycentrics.x)) + (_2427 * _22.barycentrics.y);
	    vec4 _2502 = ((_307 * ((1.0 - _22.barycentrics.x) - _22.barycentrics.y)) + (_302 * _22.barycentrics.x)) + (_2395 * _22.barycentrics.y);
	    vec3 _323;
	    vec3 _349 = vec3(0.0);
	    float _348 = 0.039999999105930328369140625;
	    vec3 _347 = vec3(0.0);
	    vec3 _345 = vec3(1.0);
	    bool _344 = false;
	    vec3 _2504 = _2469.xyz;
	    vec3 _346 = _2504;
	    if (dot(_2504, _2504) >= 1.0099999904632568359375)
	    {
	        _346 = _323.xyz;
	    }
	    _348 = _358;
	    _345 = normalize(cross(_306 - _311, _2377 - _311));
	    bool _391;
	    if (_359)
	    {
	        _391 = !_360;
	    }
	    else
	    {
	        _391 = false;
	    }
	    if (_391)
	    {
	        float _392;
	        if (_2475)
	        {
	            _392 = 1.0;
	        }
	        else
	        {
	            _392 = -1.0;
	        }
	        _346 *= _392;
	        if (_2475)
	        {
	            _392 = 1.0;
	        }
	        else
	        {
	            _392 = -1.0;
	        }
	        _345 *= _392;
	        _344 = !_2475;
	    }
	    vec3 _2533 = _346;
	    vec3 _2534 = normalize(_2533);
	    _346 = _2534;
	    vec3 _340 = _349;
	    float _339 = _348;
	    vec3 _338 = _347;
	    vec3 _337 = _2534;
	    vec3 _336 = _345;
	    bool _335 = _344;
	    vec3 _343 = textureLod(sampler2D(g_bindless_Texture2D_float4[_361], g_bindless_Sampler[_367]), _2484.xy, 0.0).xyz * (((_308 * ((1.0 - _22.barycentrics.x) - _22.barycentrics.y)) + (_303 * _22.barycentrics.x)) + (_2445 * _22.barycentrics.y)).xyz;
	    float _341 = 0.0;
	    vec4 _2556 = textureLod(sampler2D(g_bindless_Texture2D_float4[_357], g_bindless_Sampler[_368]), _2484.xy, 0.0);
	    float _2557 = _2556.x;
	    float _2558 = _2556.y;
	    float _2560 = (_2557 + _2558) - 1.00392162799835205078125;
	    float _2561 = _2557 - _2558;
	    vec2 _342 = _2556.zz;
	    vec3 _389 = normalize(vec3(vec2(_2560, _2561), (1.0 - abs(_2560)) - abs(_2561)));
	    bool _387;
	    if (_359)
	    {
	        _387 = !_360;
	    }
	    else
	    {
	        _387 = false;
	    }
	    if (_387)
	    {
	        float _388;
	        if (_2475)
	        {
	            _388 = 1.0;
	        }
	        else
	        {
	            _388 = -1.0;
	        }
	        _387 = _388 < 0.0;
	    }
	    else
	    {
	        _387 = false;
	    }
	    float _390;
	    if (_387)
	    {
	        _390 = -1.0;
	    }
	    else
	    {
	        _390 = 1.0;
	    }
	    float _2590 = _390;
	    vec3 _2591 = _2469.xyz * _2590;
	    if (_2502.w > 0.0)
	    {
	        _390 = 1.0;
	    }
	    else
	    {
	        _390 = -1.0;
	    }
	    bool _385;
	    if (_359)
	    {
	        _385 = !_360;
	    }
	    else
	    {
	        _385 = false;
	    }
	    if (_385)
	    {
	        float _386;
	        if (_2475)
	        {
	            _386 = 1.0;
	        }
	        else
	        {
	            _386 = -1.0;
	        }
	        _385 = _386 < 0.0;
	    }
	    else
	    {
	        _385 = false;
	    }
	    if (!_385)
	    {
	        vec3 _2621 = _389;
	        _2621.y = -_2621.y;
	        _389 = _2621;
	    }
	    vec3 _2628 = _2502.xyz * _389.x;
	    vec3 _384;
	    vec3 _2630 = _384;
	    _2630.x = _2628.x;
	    _2630.y = _2628.y;
	    _2630.z = _2628.z;
	    vec3 _2640 = _2630.xyz + ((cross(_2591.xyz, _2502.xyz) * _390).xyz * _389.y);
	    vec3 _2642 = _2630;
	    _2642.x = _2640.x;
	    _2642.y = _2640.y;
	    _2642.z = _2640.z;
	    vec3 _2651 = _2642.xyz + (_2591.xyz * _389.z);
	    vec3 _2653 = _2642;
	    _2653.x = _2651.x;
	    _2653.y = _2651.y;
	    _2653.z = _2651.z;
	    _384 = _2653;
	    vec3 _334 = normalize(_2653.xyz);
	    vec3 _333 = _343;
	    vec2 _332 = _342;
	    float _331 = _341;
	    vec3 _330 = _340;
	    float _329 = _339;
	    vec3 _328 = _338;
	    vec3 _327 = _337;
	    vec3 _326 = _336;
	    bool _325 = _335;
	    vec3 _324 = _389;
	    vec4 _2686 = max(vec4((vec4(vec4(_343.xyz, 1.0).xyz, 1.0) * _355).xyz, 1.0), vec4(0.0));
	    vec3 _393;
	    if (_356)
	    {
	        _393 = max(vec4((vec4(vec4(_343.xyz, 1.0).xyz, 1.0) * _354).xyz, 1.0), vec4(0.0)).xyz;
	    }
	    else
	    {
	        _393 = _333.xyz;
	    }
	    vec3 _2696 = _333;
	    vec3 _2697 = _2696;
	    _2697.x = _393.x;
	    vec3 _2699 = _2696;
	    _2699.y = _393.y;
	    vec3 _2701 = _2696;
	    _2701.z = _393.z;
	    vec3 _2703 = _2696;
	    _2703.x = _2686.x;
	    _2703.y = _2686.y;
	    _2703.z = _2686.z;
	    _333 = _2703;
	    if (_350 != 1.0)
	    {
	        vec3 _2712 = _324;
	        vec2 _2715 = _2712.yx * _350;
	        vec3 _2717 = _2712;
	        _2717.y = _2715.x;
	        _2717.x = _2715.y;
	        _324 = _2717;
	        vec3 _382 = _2717;
	        bool _380;
	        if (_359)
	        {
	            _380 = !_360;
	        }
	        else
	        {
	            _380 = false;
	        }
	        if (_380)
	        {
	            float _381;
	            if (_2475)
	            {
	                _381 = 1.0;
	            }
	            else
	            {
	                _381 = -1.0;
	            }
	            _380 = _381 < 0.0;
	        }
	        else
	        {
	            _380 = false;
	        }
	        float _383;
	        if (_380)
	        {
	            _383 = -1.0;
	        }
	        else
	        {
	            _383 = 1.0;
	        }
	        float _2740 = _383;
	        vec3 _2741 = _2469.xyz * _2740;
	        if (_2502.w > 0.0)
	        {
	            _383 = 1.0;
	        }
	        else
	        {
	            _383 = -1.0;
	        }
	        bool _378;
	        if (_359)
	        {
	            _378 = !_360;
	        }
	        else
	        {
	            _378 = false;
	        }
	        if (_378)
	        {
	            float _379;
	            if (_2475)
	            {
	                _379 = 1.0;
	            }
	            else
	            {
	                _379 = -1.0;
	            }
	            _378 = _379 < 0.0;
	        }
	        else
	        {
	            _378 = false;
	        }
	        if (!_378)
	        {
	            vec3 _2771 = _382;
	            _2771.y = -_2771.y;
	            _382 = _2771;
	        }
	        _324 = _382;
	        vec3 _2778 = _2502.xyz * _382.x;
	        vec3 _377;
	        vec3 _2780 = _377;
	        _2780.x = _2778.x;
	        _2780.y = _2778.y;
	        _2780.z = _2778.z;
	        vec3 _2790 = _2780.xyz + ((cross(_2741.xyz, _2502.xyz) * _383).xyz * _382.y);
	        vec3 _2792 = _2780;
	        _2792.x = _2790.x;
	        _2792.y = _2790.y;
	        _2792.z = _2790.z;
	        vec3 _2801 = _2792.xyz + (_2741.xyz * _382.z);
	        vec3 _2803 = _2792;
	        _2803.x = _2801.x;
	        _2803.y = _2801.y;
	        _2803.z = _2801.z;
	        _377 = _2803;
	        _334 = normalize(_2803.xyz);
	    }
	    float _394;
	    if (_351)
	    {
	        _394 = _353;
	    }
	    else
	    {
	        _394 = _353;
	    }
	    float _395;
	    if (_351)
	    {
	        _395 = _352;
	    }
	    else
	    {
	        _395 = _352;
	    }
	    vec2 _2822 = _332;
	    vec2 _2827 = ((_2822.xy - vec2(0.5)) * _394) + vec2(0.5);
	    vec2 _2829 = _2822;
	    _2829.x = _2827.x;
	    _2829.y = _2827.y;
	    vec2 _2835 = saturate(_2829.xy * _395);
	    vec2 _2837 = _2829;
	    _2837.x = _2835.x;
	    _2837.y = _2835.y;
	    _332 = _2837;
	    _21._m5 = int(uint(gl_InstanceID));
	    _21._m3 = gl_RayTmaxEXT;
	    _21._m1 = _326;
	    _21._m2 = _327;
	    vec3 _369[3] = vec3[](_310, _305, _300);
	    vec3 _370[3] = vec3[](_311, _306, _301);
	    vec3 _2874 = ((_311 * ((1.0 - _22.barycentrics.x) - _22.barycentrics.y)) + (_306 * _22.barycentrics.x)) + (_301 * _22.barycentrics.y);
	    vec3 _371[3];
	    _371[0] = _2874 - (_310 * dot(_2874 - _311, _310));
	    _371[1] = _2874 - (_305 * dot(_2874 - _306, _305));
	    _371[2] = _2874 - (_300 * dot(_2874 - _301, _300));
	    vec3 _2902 = ((_371[0] * ((1.0 - _22.barycentrics.x) - _22.barycentrics.y)) + (_371[1] * _22.barycentrics.x)) + (_371[2] * _22.barycentrics.y);
	    vec3 _372[3];
	    _372[0] = cross(_311 - _306, _21._m1);
	    _372[1] = cross(_306 - _301, _21._m1);
	    _372[2] = cross(_301 - _311, _21._m1);
	    float _373 = dot(_2902 - _2874, _21._m1);
	    vec3 _374 = _2902;
	    int _375 = 0;
	    for (;;)
	    {
	        bool _2918_ladder_break = false;
	        do
	        {
	            if (!(_375 < 3))
	            {
	                _2918_ladder_break = true;
	                break;
	            }
	            if (_373 > 0.00999999977648258209228515625)
	            {
	                _2918_ladder_break = true;
	                break;
	            }
	            if (dot(_372[_375], _372[_375]) == 0.0)
	            {
	                break;
	            }
	            _372[_375] = normalize(_372[_375]);
	            int _376 = 0;
	            for (;;)
	            {
	                if (!(_376 < 3))
	                {
	                    break;
	                }
	                vec3 _2956 = _369[_376] - (_372[_375] * dot(_372[_375], _369[_376]));
	                _371[_376] = _2874 - (_2956 * dot(_2874 - _370[_376], _2956));
	                _376++;
	                continue;
	            }
	            vec3 _2980 = ((_371[0] * ((1.0 - _22.barycentrics.x) - _22.barycentrics.y)) + (_371[1] * _22.barycentrics.x)) + (_371[2] * _22.barycentrics.y);
	            _373 = dot(_2980 - _2874, _21._m1);
	            _374 = _2980;
	            break;
	        } while(false);
	        if (_2918_ladder_break)
	        {
	            break;
	        }
	        _375++;
	        continue;
	    }
	    if (!(_373 > 0.00999999977648258209228515625))
	    {
	        _374 = vec3(3.4028234663852885981170418348452e+38);
	    }
	    _21.material = _374;
	    _21._m6 = _325;
	    f16vec3 _2993 = f16vec3(vec3(0.0));
	    _21._m7 = MaterialDataMinimal_t(_2993, float16_t(0.0), f16vec3(vec3(1.0, 0.0, 1.0)), float16_t(1.0), _2993, float16_t(0.040008544921875), 0u, f16vec4(ivec4(0)));
	    _21._m7.vMaterialBits = f16vec3(_334);
	    _21._m7._m2 = f16vec3(_333);
	    _21._m7._m4 = f16vec3(_330);
	    _21._m7._m5 = float16_t(_329);
	    _21._m7._m1 = float16_t(_331);
	    _21._m7._m3 = float16_t(dot(_2837, vec2(0.5)));
	    if (any(greaterThan(_328, vec3(0.0))))
	    {
	        f16vec4 _3022 = _21._m7._m7;
	        f16vec3 _3025 = f16vec3(_328);
	        _3022.x = _3025.x;
	        _3022.y = _3025.y;
	        _3022.z = _3025.z;
	        _21._m7 = MaterialDataMinimal_t(_21._m7.vMaterialBits, _21._m7._m1, _21._m7._m2, _21._m7._m3, _21._m7._m4, _21._m7._m5, (_21._m7._m6 & 4294901760u) | 1u, _3022);
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
