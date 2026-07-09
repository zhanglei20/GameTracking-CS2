//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "CSGO Depth Only - Used as a Mode Fallback";
	DevShader = true;
	Version = 0;
	
	// VcsVersion: 71
	// Platform: VULKAN_SM_50
	// Programs: ps, vs
}

MODES
{
	ToolsShadingComplexity();
}

FEATURES
{
	Feature( F_DISABLE_Z_BUFFERING, 0..1, "Z-Buffering" );
	Feature( F_RENDER_BACKFACES, 0..1, "2-Sided Rendering" );
	Feature( F_TRANSLUCENT, 0..1, "Translucent" );
	Feature( F_OVERLAY, 0..1, "Overlay" );
	Feature( F_ALPHA_TEST, 0..1, "Alpha Test" );
}

COMMON
{
	#include "system.fxc"
}

struct VS_INPUT
{
	float4 vBlendIndices : BLENDINDICES0  < Semantic( BlendIndices ); >;                          
	float3 vPositionOs   : POSITION0      < Semantic( PosXyz ); >;                                
	float2 nInstanceIdx  : TEXCOORD13     < Semantic( InstanceTransformUv ); >;                   
};

VS
{
	DynamicCombo( D_COMPRESSED_NORMALS_AND_TANGENTS, 0..1 );
	
	cbuffer PerViewConstantBuffer_t < Attribute("PerViewConstantBuffer_t"); >;
	ExternalDescriptorSet g_globalLateBoundBindlessSet < Source(ExternalDescSet); Attribute("g_globalLateBoundBindlessSet"); >;
	StructuredBuffer g_instanceBuffer < Attribute("InstanceBuffer"); >;
	ExternalDescriptorSet g_lightBinnerGpuSet < Source(ExternalDescSet); Attribute("g_lightBinnerGpuSet"); >;
	StructuredBuffer g_transformBuffer < Attribute("TransformBuffer"); >;
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (4280 bytes), HLSL reflection with SPIRV-Cross by KhronosGroup
	
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
	
	struct _1119
	{
	    float3x4 _m0;
	};
	
	struct _1120
	{
	    row_major float3x4 _m0;
	};
	
	ByteAddressBuffer g_instanceBuffer : register(t32, space4);
	ByteAddressBuffer g_transformBuffer : register(t30, space4);
	cbuffer PerViewConstantBuffer_t : register(b1, space0)
	{
	    column_major float4x4 PerViewConstantBuffer_t_1_m0 : packoffset(c0);
	    float4 PerViewConstantBuffer_t_1_m1 : packoffset(c24);
	    float4 PerViewConstantBuffer_t_1_m2 : packoffset(c39);
	};
	
	
	static float4 gl_Position;
	static uint vPositionOs;
	static uint4 vBlendIndices;
	static float3 nInstanceIdx;
	static float3 output_0;
	static float4 output_1;
	
	struct VS_INPUT
	{
	    float3 nInstanceIdx : TEXCOORD0;
	    uint4 vBlendIndices : TEXCOORD2;
	    uint vPositionOs : TEXCOORD3;
	};
	
	struct PS_INPUT
	{
	    float3 output_0 : TEXCOORD0;
	    float4 output_1 : TEXCOORD1;
	    float4 gl_Position : SV_Position;
	};
	
	void MainVs_inner()
	{
	    _1126 _24007;
	    _24007._m0 = g_instanceBuffer.Load(vPositionOs * 32 + 0);
	    _24007._m1 = g_instanceBuffer.Load(vPositionOs * 32 + 4);
	    _24007._m2 = g_instanceBuffer.Load(vPositionOs * 32 + 8);
	    _24007._m3 = g_instanceBuffer.Load(vPositionOs * 32 + 12);
	    _24007._m4 = g_instanceBuffer.Load(vPositionOs * 32 + 16);
	    _24007._m5 = g_instanceBuffer.Load(vPositionOs * 32 + 20);
	    _24007._m6 = g_instanceBuffer.Load(vPositionOs * 32 + 24);
	    _24007._m7 = asfloat(g_instanceBuffer.Load(vPositionOs * 32 + 28));
	    _1125 _22470;
	    _22470._m0 = _24007._m0;
	    _22470._m1 = _24007._m1;
	    _22470._m2 = _24007._m2;
	    _22470._m3 = _24007._m3;
	    _22470._m4 = _24007._m4;
	    _22470._m5 = _24007._m5;
	    _22470._m6 = _24007._m6;
	    _22470._m7 = _24007._m7;
	    float4 _23812 = float4(uint4(_22470._m0 & 255u, (_22470._m0 & 65280u) >> uint(8), (_22470._m0 & 16711680u) >> uint(16), (_22470._m0 & 4278190080u) >> uint(24))) * 0.0039215688593685626983642578125f.xxxx;
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
	    float _19302;
	    if (_23812.z <= 0.040449999272823333740234375f)
	    {
	        _19302 = _17828.z;
	    }
	    else
	    {
	        _19302 = _7676.z;
	    }
	    float4 _24700 = float4(_21354, _21355, _19302, _23812.w);
	    uint _16987 = (_22470._m5 >> uint(16)) & 15u;
	    uint _21709;
	    if (_16987 == 1u)
	    {
	        _21709 = _22470._m1 + (2u + vBlendIndices.x);
	    }
	    else
	    {
	        _21709 = _22470._m1;
	    }
	    _1120 _11578;
	    _11578._m0 = asfloat(uint3x4(g_transformBuffer.Load4(_21709 * 48 + 0), g_transformBuffer.Load4(_21709 * 48 + 16), g_transformBuffer.Load4(_21709 * 48 + 32)));
	    _1119 _21957;
	    _21957._m0 = _11578._m0;
	    float3 _22743;
	    if (_16987 > 0u)
	    {
	        _1120 _10769;
	        _10769._m0 = asfloat(uint3x4(g_transformBuffer.Load4(_22470._m1 * 48 + 0), g_transformBuffer.Load4(_22470._m1 * 48 + 16), g_transformBuffer.Load4(_22470._m1 * 48 + 32)));
	        _1119 _20228;
	        _20228._m0 = _10769._m0;
	        _22743 = _20228._m0[0].z.xxx;
	    }
	    else
	    {
	        _22743 = 1.0f.xxx;
	    }
	    float3 _12151 = mul(_21957._m0, float4(nInstanceIdx.xyz * _22743.xyz, 1.0f));
	    float4 _18237 = mul(PerViewConstantBuffer_t_1_m0, (float4(_12151.xyz, 1.0f) + (PerViewConstantBuffer_t_1_m1 * 1.0f)).xyzw);
	    float3 _13062 = _24700.xyz * PerViewConstantBuffer_t_1_m2.xyz;
	    float4 _23714 = _24700;
	    _23714.x = _13062.x;
	    _23714.y = _13062.y;
	    _23714.z = _13062.z;
	    output_0 = _12151;
	    output_1 = _23714;
	    _18237.y = -_18237.y;
	    gl_Position = _18237;
	}
	
	PS_INPUT MainVs(VS_INPUT stage_input)
	{
	    vPositionOs = stage_input.vPositionOs;
	    vBlendIndices = stage_input.vBlendIndices;
	    nInstanceIdx = stage_input.nInstanceIdx;
	    MainVs_inner();
	    PS_INPUT stage_output;
	    stage_output.gl_Position = gl_Position;
	    stage_output.output_0 = output_0;
	    stage_output.output_1 = output_1;
	    return stage_output;
	}
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
}

PS
{
	StaticCombo( S_OVERLAY, F_OVERLAY );
	StaticCombo( S_ALPHA_TEST, F_ALPHA_TEST );
	DynamicCombo( D_QUAD_OVERDRAW, 0..1 );
	
	RenderState(CullMode, F_RENDER_BACKFACES ? None : Back);
	RenderState(DepthBias, -250);
	RenderState(DepthBiasClamp, 0);
	RenderState(DepthEnable, F_DISABLE_Z_BUFFERING ? False : True);
	RenderState(DepthFunc, F_ALPHA_TEST ? Equal : LessEqual);
	RenderState(DepthWriteEnable, False);
	RenderState(DepthWriteEnable, ((False ? True : F_TRANSLUCENT) ? True : F_DISABLE_Z_BUFFERING) ? False : True);
	RenderState(SlopeScaleDepthBias, 0);
	RenderState(StencilEnable, 1);
	RenderState(StencilFunc, 5);
	RenderState(StencilRef, 1);
	ExternalDescriptorSet g_globalLateBoundBindlessSet < Source(ExternalDescSet); Attribute("g_globalLateBoundBindlessSet"); >;
	ExternalDescriptorSet g_lightBinnerGpuSet < Source(ExternalDescSet); Attribute("g_lightBinnerGpuSet"); >;
	RWTexture2D<float4> g_tQuadOverdrawMutexUAV < Attribute("QuadOverdrawMutexUAV"); >;
	RWTexture2D<float4> g_tQuadOverdrawUAV < Attribute("QuadOverdrawUAV"); >;
	float4 g_vShadingComplexity < Source(ShadingComplexity); UiType(VectorText); >;
	
	#if (S_ALPHA_TEST == 1)
		RenderState(DepthWriteEnable, False);
	#endif
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (416 bytes), HLSL reflection with SPIRV-Cross by KhronosGroup
	
	cbuffer _Globals_ : register(b0, space1)
	{
	    float4 _Globals_1_g_vShadingComplexity : packoffset(c0);
	};
	
	
	static float4 output_0;
	
	struct PS_OUTPUT
	{
	    float4 output_0 : SV_Target0;
	};
	
	void MainPs_inner()
	{
	    output_0 = _Globals_1_g_vShadingComplexity;
	}
	
	PS_OUTPUT MainPs()
	{
	    MainPs_inner();
	    PS_OUTPUT stage_output;
	    stage_output.output_0 = output_0;
	    return stage_output;
	}
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
}
