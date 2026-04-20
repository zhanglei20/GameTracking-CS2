//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "Additive light";
	DevShader = false;
	Version = 1;
	
	// VcsVersion: 70
	// Platform: VULKAN_SM_50
	// Programs: ps, psrs, vs
}

MODES
{
	CsgoForward();
	ToolsVis(S_MODE_TOOLS_VIS);
	ToolsWireframe("csgo_tools_wireframe.vfx");
	ToolsShadingComplexity("csgo_tools_shading_complexity.vfx");
}

FEATURES
{
	Feature( F_DO_NOT_CAST_SHADOWS, 0..1, "Rendering" );
	Feature( F_RENDER_BACKFACES, 0..1, "Rendering" );
	Feature( F_DISABLE_Z_BUFFERING, 0..1, "Z-Buffering" );
	Feature( F_DISABLE_Z_PREPASS, 0..1, "Z-Buffering" );
}

COMMON
{
	#include "system.fxc"
}

struct VS_INPUT
{
	float4 vBlendIndices : BLENDINDICES0  < Semantic( BlendIndices ); >;                           // D_CS_VERTEX_ANIMATION=0
	uint4  nPackedFrame  : NORMAL0        < Semantic( CompressedTangentFrame ); >;                
	float4 vNormalOs     : NORMAL0        < Semantic( Normal ); >;                                
	float3 vPositionOs   : POSITION0      < Semantic( PosXyz ); >;                                 // D_CS_VERTEX_ANIMATION=0
	float2 vTexCoord     : TEXCOORD0      < Semantic( LowPrecisionUv ); >;                        
	float2 nInstanceIdx  : TEXCOORD13     < Semantic( InstanceTransformUv ); >;                   
};

VS
{
	StaticCombo( S_MODE_TOOLS_VIS, 0..1 );
	DynamicCombo( D_COMPRESSED_NORMALS_AND_TANGENTS, 0..1 );
	DynamicCombo( D_CS_VERTEX_ANIMATION, 0..1 );
	
	cbuffer PerViewConstantBufferCsgo_t < Attribute("PerViewConstantBufferCsgo_t"); >;
	cbuffer PerViewConstantBuffer_t < Attribute("PerViewConstantBuffer_t"); >;
	ByteAddressBuffer g_animatedVertexCache < Attribute("AnimatedVertexCache"); SrgbRead(false); >;
	ExternalDescriptorSet g_globalLateBoundBindlessSet < Source(ExternalDescSet); Attribute("g_globalLateBoundBindlessSet"); >;
	StructuredBuffer g_instanceBuffer < Attribute("InstanceBuffer"); SrgbRead(false); >;
	ExternalDescriptorSet g_lightBinnerGpuSet < Source(ExternalDescSet); Attribute("g_lightBinnerGpuSet"); >;
	StructuredBuffer g_transformBuffer < Attribute("TransformBuffer"); SrgbRead(false); >;
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (5508 bytes), HLSL reflection with SPIRV-Cross by KhronosGroup
	
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
	
	struct _1612
	{
	    float4 _m0[3];
	};
	
	struct _1172
	{
	    _1612 _m0;
	};
	
	struct _113
	{
	    float4 _m0[4];
	};
	
	ByteAddressBuffer g_instanceBuffer : register(t32, space4);
	ByteAddressBuffer g_transformBuffer : register(t30, space4);
	cbuffer PerViewConstantBuffer_t : register(b1, space0)
	{
	    _113 PerViewConstantBuffer_t_1_m0 : packoffset(c0);
	    float4 PerViewConstantBuffer_t_1_m1 : packoffset(c24);
	};
	
	cbuffer PerViewConstantBufferCsgo_t : register(b3, space0)
	{
	    float4 PerViewConstantBufferCsgo_t_1_m0 : packoffset(c35);
	};
	
	
	static float4 gl_Position;
	static float3 vPositionOs;
	static float2 vTexCoord;
	static float3 vNormalOs;
	static uint4 vBlendIndices;
	static uint nInstanceIdx;
	static float3 output_0;
	static float3 output_1;
	static float4 output_2;
	static float4 output_3;
	static uint output_4;
	
	struct VS_INPUT
	{
	    float3 vPositionOs : TEXCOORD0;
	    float2 vTexCoord : TEXCOORD1;
	    float3 vNormalOs : TEXCOORD2;
	    uint4 vBlendIndices : TEXCOORD3;
	    uint nInstanceIdx : TEXCOORD4;
	};
	
	struct PS_INPUT
	{
	    float3 output_0 : TEXCOORD0;
	    float3 output_1 : TEXCOORD1;
	    float4 output_2 : TEXCOORD2;
	    centroid float4 output_3 : TEXCOORD3;
	    nointerpolation uint output_4 : TEXCOORD4;
	    float4 gl_Position : SV_Position;
	};
	
	void MainVs_inner()
	{
	    uint _13771 = (g_instanceBuffer.Load(nInstanceIdx * 32 + 20) >> uint(16)) & 15u;
	    uint _21785;
	    if (_13771 == 1u)
	    {
	        _21785 = g_instanceBuffer.Load(nInstanceIdx * 32 + 4) + (2u + vBlendIndices.x);
	    }
	    else
	    {
	        _21785 = g_instanceBuffer.Load(nInstanceIdx * 32 + 4);
	    }
	    _1612 _25207;
	    [unroll]
	    for (int _2ident = 0; _2ident < 3; _2ident++)
	    {
	        _25207._m0[_2ident] = asfloat(g_transformBuffer.Load4(_2ident * 16 + _21785 * 48 + 0));
	    }
	    float3x4 _17839 = float3x4(_25207._m0[0], _25207._m0[1], _25207._m0[2]);
	    float3 _21709;
	    if (_13771 > 0u)
	    {
	        _1612 _25208;
	        [unroll]
	        for (int _3ident = 0; _3ident < 3; _3ident++)
	        {
	            _25208._m0[_3ident] = asfloat(g_transformBuffer.Load4(_3ident * 16 + g_instanceBuffer.Load(nInstanceIdx * 32 + 4) * 48 + 0));
	        }
	        _21709 = _25208._m0[0].z.xxx;
	    }
	    else
	    {
	        _21709 = 1.0f.xxx;
	    }
	    float4 _23812 = float4(uint4((g_instanceBuffer.Load(nInstanceIdx * 32 + 0) & 255u), (g_instanceBuffer.Load(nInstanceIdx * 32 + 0) & 65280u) >> uint(8), (g_instanceBuffer.Load(nInstanceIdx * 32 + 0) & 16711680u) >> uint(16), (g_instanceBuffer.Load(nInstanceIdx * 32 + 0) & 4278190080u) >> uint(24))) * 0.0039215688593685626983642578125f.xxxx;
	    float3 _6253 = _23812.xyz;
	    float3 _17828 = _6253 * 0.077399380505084991455078125f.xxx;
	    float3 _7676 = pow((_6253 * 0.947867333889007568359375f.xxx) + 0.052132703363895416259765625f.xxx, 2.400000095367431640625f.xxx);
	    float _21354;
	    if (_23812.x <= 0.040449999272823333740234375f)
	    {
	        _21354 = _17828.x;
	    }
	    else
	    {
	        _21354 = _7676.x;
	    }
	    float _21355;
	    if (_23812.y <= 0.040449999272823333740234375f)
	    {
	        _21355 = _17828.y;
	    }
	    else
	    {
	        _21355 = _7676.y;
	    }
	    float _14124;
	    if (_23812.z <= 0.040449999272823333740234375f)
	    {
	        _14124 = _17828.z;
	    }
	    else
	    {
	        _14124 = _7676.z;
	    }
	    float3 _12151 = mul(_17839, float4(vPositionOs.xyz * _21709.xyz, 1.0f));
	    float4 _23875 = mul(float4x4(float4(PerViewConstantBuffer_t_1_m0._m0[0].x, PerViewConstantBuffer_t_1_m0._m0[1].x, PerViewConstantBuffer_t_1_m0._m0[2].x, PerViewConstantBuffer_t_1_m0._m0[3].x), float4(PerViewConstantBuffer_t_1_m0._m0[0].y, PerViewConstantBuffer_t_1_m0._m0[1].y, PerViewConstantBuffer_t_1_m0._m0[2].y, PerViewConstantBuffer_t_1_m0._m0[3].y), float4(PerViewConstantBuffer_t_1_m0._m0[0].z, PerViewConstantBuffer_t_1_m0._m0[1].z, PerViewConstantBuffer_t_1_m0._m0[2].z, PerViewConstantBuffer_t_1_m0._m0[3].z), float4(PerViewConstantBuffer_t_1_m0._m0[0].w, PerViewConstantBuffer_t_1_m0._m0[1].w, PerViewConstantBuffer_t_1_m0._m0[2].w, PerViewConstantBuffer_t_1_m0._m0[3].w)), (float4(_12151.xyz, 1.0f) + (PerViewConstantBuffer_t_1_m1 * 1.0f)).xyzw);
	    output_0 = _12151.xyz - PerViewConstantBufferCsgo_t_1_m0.xyz;
	    output_1 = normalize(mul(_17839, float4(vNormalOs.xyz, 0.0f)));
	    output_2 = vTexCoord.xyxy;
	    output_3 = float4(_21354, _21355, _14124, _23812.w);
	    output_4 = (g_instanceBuffer.Load(nInstanceIdx * 32 + 20)) & 65535u;
	    _23875.y = -_23875.y;
	    gl_Position = _23875;
	}
	
	PS_INPUT MainVs(VS_INPUT stage_input)
	{
	    vPositionOs = stage_input.vPositionOs;
	    vTexCoord = stage_input.vTexCoord;
	    vNormalOs = stage_input.vNormalOs;
	    vBlendIndices = stage_input.vBlendIndices;
	    nInstanceIdx = stage_input.nInstanceIdx;
	    MainVs_inner();
	    PS_INPUT stage_output;
	    stage_output.gl_Position = gl_Position;
	    stage_output.output_0 = output_0;
	    stage_output.output_1 = output_1;
	    stage_output.output_2 = output_2;
	    stage_output.output_3 = output_3;
	    stage_output.output_4 = output_4;
	    return stage_output;
	}
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
	
	BoolAttribute(CanBatchWithDynamicShaderConstants, true);
	
}

PS
{
	StaticCombo( S_MODE_TOOLS_VIS, 0..1 );
	DynamicCombo( D_MBOIT_PASS1, 0..1 );
	DynamicCombo( D_MBOIT_PASS2, 0..1 );
	DynamicCombo( D_MBOIT_4_MOMENTS, 0..1 );
	DynamicComboRule( Allow1( D_MBOIT_PASS1, D_MBOIT_PASS2 ) );
	DynamicComboRule( Requires( D_MBOIT_4_MOMENTS, D_MBOIT_PASS1, D_MBOIT_PASS2 ) );
	
	cbuffer PerViewConstantBufferCsgo_t < Attribute("PerViewConstantBufferCsgo_t"); >;
	cbuffer PerViewConstantBuffer_t < Attribute("PerViewConstantBuffer_t"); >;
	ExternalDescriptorSet g_globalLateBoundBindlessSet < Source(ExternalDescSet); Attribute("g_globalLateBoundBindlessSet"); >;
	ExternalDescriptorSet g_lightBinnerGpuSet < Source(ExternalDescSet); Attribute("g_lightBinnerGpuSet"); >;
	Texture2D g_tExtra_Moment < Attribute("moments_extra"); SrgbRead(true); >;
	TextureCube g_tFogCubeTexture < Attribute("CubemapFogTexture"); SrgbRead(true); >;
	Texture2D g_tMoments < Attribute("moments"); SrgbRead(true); >;
	Texture2D g_tZeroth_Moment < Attribute("zeroth_moment"); SrgbRead(true); >;
	
	// Color
	float3 g_vRadiance < Default3(1, 1, 1); UiType(Color); UiGroup("Color,10/20"); >;
	
	// SPIR-V reflection failed for backend HLSL:
	// cbuffer ID 5618 (name: _Globals_), member index 0 (name: g_vRadiance) cannot be expressed with either HLSL packing layout or packoffset.
	// 
	// Re-attempting reflection with the GLSL backend.
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (4944 bytes), GLSL reflection with SPIRV-Cross by KhronosGroup
	
	#version 460
	
	struct _1024
	{
	    vec4 _m0[4];
	};
	
	struct _1007
	{
	    vec3 g_vRadiance;
	};
	
	layout(set = 1) uniform _1007 _Globals_;
	
	struct _1261
	{
	    ivec4 _m0;
	    vec4 _m1;
	    vec4 _m2;
	    vec4 _m3;
	    vec4 _m4;
	    vec4 _m5;
	    _1024 _m6;
	    vec4 _m7;
	    vec4 _m8;
	    vec4 _m9;
	};
	
	layout(set = 1) uniform _1261 PerViewConstantBufferCsgo_t;
	
	struct _1008
	{
	    vec3 _m0;
	};
	
	layout(set = 1) uniform _1008 PerViewConstantBuffer_t;
	
	layout(set = 1, binding = 42) uniform textureCube g_tFogCubeTexture;
	layout(set = 1, binding = 17) uniform sampler g_sTrilinearClamp;
	
	layout(location = 0) in vec3 input_0;
	layout(location = 0) out vec4 output_0;
	
	void main()
	{
	    vec4 _13745 = vec4(_Globals_.g_vRadiance, 1.0);
	    vec3 _5578 = input_0 + PerViewConstantBufferCsgo_t._m9.xyz;
	    vec3 _3895 = _5578 - PerViewConstantBuffer_t._m0.xyz;
	    bvec4 _24464 = notEqual(PerViewConstantBufferCsgo_t._m0, ivec4(0));
	    vec4 _22475;
	    if (_24464.y)
	    {
	        vec2 _9342 = clamp(PerViewConstantBufferCsgo_t._m1.xy + (PerViewConstantBufferCsgo_t._m1.zw * vec2(length(_3895.xyz), _5578.z)), vec2(0.0), vec2(1.0));
	        float _12872 = (pow(_9342.x, PerViewConstantBufferCsgo_t._m2.x) * pow(_9342.y, PerViewConstantBufferCsgo_t._m2.y)) * PerViewConstantBufferCsgo_t._m3.w;
	        float _12020 = 1.0 - _12872;
	        _22475 = vec4(mix(vec4(PerViewConstantBufferCsgo_t._m3.xyz, _12872).xyz, _13745.xyz, vec3(_12020)), _12020);
	    }
	    else
	    {
	        _22475 = _13745;
	    }
	    vec4 _6805;
	    if (_24464.z)
	    {
	        float _14602 = clamp(pow(max(0.0, (length(_3895.xyz) * PerViewConstantBufferCsgo_t._m4.y) + PerViewConstantBufferCsgo_t._m4.x), PerViewConstantBufferCsgo_t._m4.w), 0.0, 1.0) * clamp(pow(max(0.0, (_5578.z * PerViewConstantBufferCsgo_t._m5.y) + PerViewConstantBufferCsgo_t._m5.x), PerViewConstantBufferCsgo_t._m5.z), 0.0, 1.0);
	        float _13668 = saturate(_14602) * PerViewConstantBufferCsgo_t._m7.w;
	        float _23286 = 1.0 - _13668;
	        _6805 = vec4(mix(vec4((textureLod(samplerCube(g_tFogCubeTexture, g_sTrilinearClamp), normalize((mat4(vec4(PerViewConstantBufferCsgo_t._m6._m0[0].x, PerViewConstantBufferCsgo_t._m6._m0[1].x, PerViewConstantBufferCsgo_t._m6._m0[2].x, PerViewConstantBufferCsgo_t._m6._m0[3].x), vec4(PerViewConstantBufferCsgo_t._m6._m0[0].y, PerViewConstantBufferCsgo_t._m6._m0[1].y, PerViewConstantBufferCsgo_t._m6._m0[2].y, PerViewConstantBufferCsgo_t._m6._m0[3].y), vec4(PerViewConstantBufferCsgo_t._m6._m0[0].z, PerViewConstantBufferCsgo_t._m6._m0[1].z, PerViewConstantBufferCsgo_t._m6._m0[2].z, PerViewConstantBufferCsgo_t._m6._m0[3].z), vec4(PerViewConstantBufferCsgo_t._m6._m0[0].w, PerViewConstantBufferCsgo_t._m6._m0[1].w, PerViewConstantBufferCsgo_t._m6._m0[2].w, PerViewConstantBufferCsgo_t._m6._m0[3].w)) * vec4(_3895, 0.0)).xyz).xyz, PerViewConstantBufferCsgo_t._m5.w * clamp(1.0 - (_14602 * PerViewConstantBufferCsgo_t._m4.z), 0.0, 1.0)) * PerViewConstantBufferCsgo_t._m8.x).xyz, _13668).xyz, _22475.xyz, vec3(_23286)), _22475.w * _23286);
	    }
	    else
	    {
	        _6805 = _22475;
	    }
	    output_0 = _6805;
	}
	
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
	
	BoolAttribute(AllowBackfaceCulling, F_RENDER_BACKFACES ? 0 : 1);
	BoolAttribute(translucent, true);
	BoolAttribute(NeedsLightProbe, true);
	
	
	// PSRS
	
	RenderState(BackStencilFunc, F_RENDER_BACKFACES ? 5 : 7);
	RenderState(CullMode, F_RENDER_BACKFACES ? None : Front);
	RenderState(CullMode, F_RENDER_BACKFACES ? None : Back);
	RenderState(DepthEnable, F_DISABLE_Z_BUFFERING ? False : True);
	RenderState(DepthWriteEnable, F_DISABLE_Z_BUFFERING ? False : True);
	RenderState(StencilEnable, 1);
	RenderState(StencilFunc, 5);
	RenderState(StencilReadMask, 1);
	RenderState(StencilRef, 3);
	RenderState(StencilWriteMask, 254);
	
}
