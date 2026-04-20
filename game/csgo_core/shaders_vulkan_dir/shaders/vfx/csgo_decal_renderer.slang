//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "Render decals to UV space - Used as a Mode Fallback";
	DevShader = true;
	Version = 1;
	
	// VcsVersion: 70
	// Platform: VULKAN_SM_60
	// Programs: ps, vs
}

MODES
{
	Decals();
}

FEATURES
{
	Feature( F_SUPPORTS_DECALS, 0..1, "Blood Decals" );
}

COMMON
{
	#include "system.fxc"
}

struct VS_INPUT
{
	float4 vBlendIndices  : BLENDINDICES0  < Semantic( BlendIndices ); >;                          // D_CS_VERTEX_ANIMATION=0
	uint4  nPackedFrame   : NORMAL0        < Semantic( CompressedTangentFrame ); >;               
	float4 vNormalOs      : NORMAL0        < Semantic( Normal ); >;                               
	float3 vPositionOs    : POSITION0      < Semantic( PosXyz ); >;                                // D_CS_VERTEX_ANIMATION=0
	float2 vTextureCoords : TEXCOORD0      < Semantic( LowPrecisionUv ); >;                       
	float2 vTexCoord2     : TEXCOORD1      < Semantic( LowPrecisionUv1 ); >;                      
	float2 nInstanceIdx   : TEXCOORD13     < Semantic( InstanceTransformUv ); >;                  
};

VS
{
	StaticCombo( S_SUPPORTS_DECALS, F_SUPPORTS_DECALS );
	DynamicCombo( D_COMPRESSED_NORMALS_AND_TANGENTS, 0..1 );
	DynamicCombo( D_CS_VERTEX_ANIMATION, 0..1 );
	
	ByteAddressBuffer g_animatedVertexCache < Attribute("AnimatedVertexCache"); SrgbRead(false); >;
	bool g_bProjectToBackfaces < Attribute("g_bProjectToBackfaces"); UiType(CheckBox); >;
	float g_flDecalSize < Default(4); Range(1, 32); Attribute("g_flDecalSize"); UiType(Slider); >;
	ExternalDescriptorSet g_globalLateBoundBindlessSet < Source(ExternalDescSet); Attribute("g_globalLateBoundBindlessSet"); >;
	StructuredBuffer g_instanceBuffer < Attribute("InstanceBuffer"); SrgbRead(false); >;
	ExternalDescriptorSet g_lightBinnerGpuSet < Source(ExternalDescSet); Attribute("g_lightBinnerGpuSet"); >;
	StructuredBuffer g_transformBuffer < Attribute("TransformBuffer"); SrgbRead(false); >;
	float3 g_vBasisXAxis < Attribute("g_vBasisXAxis"); UiType(VectorText); >;
	float3 g_vBasisYAxis < Attribute("g_vBasisYAxis"); UiType(VectorText); >;
	float3 g_vBasisZAxis < Attribute("g_vBasisZAxis"); UiType(VectorText); >;
	float3 g_vDecalCenter < Attribute("g_vDecalCenter"); UiType(VectorText); >;
	
	// SPIR-V reflection failed for backend HLSL:
	// cbuffer ID 5618 (name: _Globals_), member index 0 (name: g_vDecalCenter) cannot be expressed with either HLSL packing layout or packoffset.
	// 
	// Re-attempting reflection with the GLSL backend.
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (4312 bytes), GLSL reflection with SPIRV-Cross by KhronosGroup
	
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
	
	float _3;
	
	layout(set = 4, binding = 32, std430) readonly buffer g_instanceBuffer
	{
	    _1125 _m0[];
	} g_instanceBuffer_1;
	
	layout(set = 4, binding = 30, std430) readonly buffer g_transformBuffer
	{
	    _1844 _m0[];
	} g_transformBuffer_1;
	
	struct _1258
	{
	    vec3 g_vDecalCenter;
	    vec3 g_vBasisXAxis;
	    vec3 g_vBasisYAxis;
	    vec3 g_vBasisZAxis;
	    int g_bProjectToBackfaces;
	    float g_flDecalSize;
	};
	
	layout(set = 0) uniform _1258 _Globals_;
	
	layout(location = 0) in vec3 vPositionOs;
	layout(location = 1) in vec2 vTextureCoords;
	layout(location = 2) in vec2 vTexCoord2;
	layout(location = 3) in uint vNormalOs;
	layout(location = 4) in vec3 vBlendIndices;
	layout(location = 5) in uvec4 nInstanceIdx;
	layout(location = 0) out vec3 output_0;
	layout(location = 1) out vec4 output_1;
	layout(location = 2) out vec3 output_2;
	layout(location = 3) out vec3 output_3;
	layout(location = 4) out float output_4;
	layout(location = 5) out float output_5;
	
	void main()
	{
	    uint _13771 = (g_instanceBuffer_1._m0[vNormalOs]._m5 >> uint(16)) & 15u;
	    uint _21785;
	    if (_13771 == 1u)
	    {
	        _21785 = g_instanceBuffer_1._m0[vNormalOs]._m1 + (2u + nInstanceIdx.x);
	    }
	    else
	    {
	        _21785 = g_instanceBuffer_1._m0[vNormalOs]._m1;
	    }
	    mat3x4 _17839 = mat3x4(g_transformBuffer_1._m0[_21785]._m0._m0[0], g_transformBuffer_1._m0[_21785]._m0._m0[1], g_transformBuffer_1._m0[_21785]._m0._m0[2]);
	    vec3 _22743;
	    if (_13771 > 0u)
	    {
	        _22743 = vec3(g_transformBuffer_1._m0[g_instanceBuffer_1._m0[vNormalOs]._m1]._m0._m0[0].z);
	    }
	    else
	    {
	        _22743 = vec3(1.0);
	    }
	    vec3 _15246 = vec4(vPositionOs.xyz * _22743.xyz, 1.0) * _17839;
	    vec3 _14331 = normalize(vec4(vBlendIndices.xyz, 0.0) * _17839);
	    vec4 _7126 = vec4((vTexCoord2.x * 2.0) - 1.0, _3, 0.0, 1.0);
	    vec3 _5221 = _15246.xyz - _Globals_.g_vDecalCenter.xyz;
	    vec3 _16498 = vec3(dot(_5221, _Globals_.g_vBasisXAxis), dot(_5221, _Globals_.g_vBasisYAxis), dot(_5221, _Globals_.g_vBasisZAxis)) * (1.5 / _Globals_.g_flDecalSize);
	    float _5247 = -dot(_14331, _Globals_.g_vBasisZAxis);
	    float _9057;
	    if (_Globals_.g_bProjectToBackfaces != 0)
	    {
	        _9057 = abs(_5247);
	    }
	    else
	    {
	        _9057 = _5247;
	    }
	    output_0 = _15246;
	    output_1 = vec4(vTextureCoords, vTexCoord2);
	    output_2 = (_16498 * 0.5) + vec3(0.5);
	    output_3 = _14331;
	    output_4 = saturate(_9057 * 2.0);
	    output_5 = clamp(1.0 - length(_16498), 0.0, 1.0);
	    _7126.y = 1.0 - (vTexCoord2.y * 2.0);
	    gl_Position = _7126;
	}
	
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
}

PS
{
	StaticCombo( S_SUPPORTS_DECALS, F_SUPPORTS_DECALS );
	DynamicCombo( D_FIRST_FRAME, 0..1 );
	
	ExternalDescriptorSet g_globalLateBoundBindlessSet < Source(ExternalDescSet); Attribute("g_globalLateBoundBindlessSet"); >;
	ExternalDescriptorSet g_lightBinnerGpuSet < Source(ExternalDescSet); Attribute("g_lightBinnerGpuSet"); >;
	Texture2D g_tDecals < Attribute("BloodDefaultImpact"); SrgbRead(false); >;
	Texture2D g_tPreviousRT < Attribute("g_tPreviousRT"); SrgbRead(false); >;
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (1364 bytes), HLSL reflection with SPIRV-Cross by KhronosGroup
	// Static combos: S_SUPPORTS_DECALS
	
	Texture2D<float4> g_tPreviousRT : register(t30, space1);
	SamplerState AddressU_Clamp_AddressV_Clamp : register(s21, space1);
	Texture2D<float4> g_tDecals : register(t31, space1);
	SamplerState g_sTrilinearClamp : register(s17, space1);
	
	static float4 input_0;
	static float3 input_1;
	static float input_2;
	static float4 output_0;
	
	struct PS_INPUT
	{
	    float4 input_0 : TEXCOORD1;
	    float3 input_1 : TEXCOORD2;
	    float input_2 : TEXCOORD4;
	};
	
	struct PS_OUTPUT
	{
	    float4 output_0 : SV_Target0;
	};
	
	void MainPs_inner()
	{
	    float4 _22794 = g_tPreviousRT.Sample(AddressU_Clamp_AddressV_Clamp, input_0.zw);
	    float4 _3401 = g_tDecals.Sample(g_sTrilinearClamp, clamp(input_1.xy, 0.0f.xx, 1.0f.xx).xy);
	    output_0 = float4(_22794.xy, max(_22794.z, _3401.x * input_2), _22794.w + (_3401.y * input_2));
	}
	
	PS_OUTPUT MainPs(PS_INPUT stage_input)
	{
	    input_0 = stage_input.input_0;
	    input_1 = stage_input.input_1;
	    input_2 = stage_input.input_2;
	    MainPs_inner();
	    PS_OUTPUT stage_output;
	    stage_output.output_0 = output_0;
	    return stage_output;
	}
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
	#if (S_SUPPORTS_DECALS == 1)
		IntAttribute(DecalRtEncoding, 0);
	#endif
}
