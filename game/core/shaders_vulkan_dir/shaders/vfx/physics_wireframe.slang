//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "Wireframe for physics model visualization";
	DevShader = true;
	Version = 0;
	
	// VcsVersion: 70
	// Platform: VULKAN_SM_40
	// Programs: ps, vs
}

MODES
{
	Default();
	Forward(S_MODE_FORWARD);
}

FEATURES
{
	Feature( F_ALPHA_TEST, 0..1, "" );
	Feature( F_DOTTED_LINE, 0..1, "" );
	Feature( F_FILL, 0..1, "" );
	Feature( F_HIDDEN_WIREFRAME, 0..1, "" );
}

COMMON
{
	#include "system.fxc"
}

struct VS_INPUT
{
	float4 vBlendIndices       : BLENDINDICES0  < Semantic( BlendIndices ); >;                     // D_BLEND_WEIGHT_COUNT=1, D_BLEND_WEIGHT_COUNT=2, D_BLEND_WEIGHT_COUNT=3, D_BLEND_WEIGHT_COUNT=4
	float4 vBlendWeight        : BLENDWEIGHT0   < Semantic( BlendWeight ); >;                      // D_BLEND_WEIGHT_COUNT=2, D_BLEND_WEIGHT_COUNT=3, D_BLEND_WEIGHT_COUNT=4
	float4 vColor              : COLOR0         < Semantic( Color ); >;                           
	float4 vFirstLineVertPosWs : TEXCOORD0      < Semantic( None ); >;                             // S_DOTTED_LINE=1
	float4 vNormalOs           : NORMAL0        < Semantic( Normal ); >;                          
	float3 vPositionOs         : POSITION0      < Semantic( PosXyz ); >;                          
	float2 nInstanceIdx        : TEXCOORD13     < Semantic( InstanceTransformUv ); >;             
};

VS
{
	StaticCombo( S_DOTTED_LINE, F_DOTTED_LINE );
	DynamicCombo( D_BLEND_WEIGHT_COUNT, 0..4 );
	
	cbuffer PerViewConstantBuffer_t < Attribute("PerViewConstantBuffer_t"); >;
	StructuredBuffer g_instanceBuffer < Attribute("InstanceBuffer"); SrgbRead(false); >;
	StructuredBuffer g_transformBuffer < Attribute("TransformBuffer"); SrgbRead(false); >;
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (2912 bytes), HLSL reflection with SPIRV-Cross by KhronosGroup
	
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
	
	struct _1150
	{
	    float4 _m0[3];
	};
	
	struct _248
	{
	    _1150 _m0;
	};
	
	struct _1276
	{
	    float4 _m0[4];
	};
	
	ByteAddressBuffer g_instanceBuffer : register(t32, space0);
	ByteAddressBuffer g_transformBuffer : register(t30, space0);
	cbuffer _Globals_ : register(b0, space0)
	{
	    _1276 _Globals_1_m0 : packoffset(c0);
	    float4 _Globals_1_m1 : packoffset(c24);
	};
	
	
	static float4 gl_Position;
	static float3 vPositionOs;
	static float4 vColor;
	static float3 vNormalOs;
	static uint nInstanceIdx;
	static float4 output_0;
	static float3 output_1;
	static float3 output_2;
	
	struct VS_INPUT
	{
	    float3 vPositionOs : TEXCOORD0;
	    float4 vColor : TEXCOORD1;
	    float3 vNormalOs : TEXCOORD3;
	    uint nInstanceIdx : TEXCOORD4;
	};
	
	struct PS_INPUT
	{
	    float4 output_0 : TEXCOORD0;
	    float3 output_1 : TEXCOORD1;
	    float3 output_2 : TEXCOORD2;
	    float4 gl_Position : SV_Position;
	};
	
	void MainVs_inner()
	{
	    _1150 _25207;
	    [unroll]
	    for (int _1ident = 0; _1ident < 3; _1ident++)
	    {
	        _25207._m0[_1ident] = asfloat(g_transformBuffer.Load4(_1ident * 16 + g_instanceBuffer.Load(nInstanceIdx * 32 + 4) * 48 + 0));
	    }
	    float3 _19956 = mul(float3x4(_25207._m0[0], _25207._m0[1], _25207._m0[2]), float4(vPositionOs.xyz, 1.0f));
	    float4 _23533 = mul(float4x4(float4(_Globals_1_m0._m0[0].x, _Globals_1_m0._m0[1].x, _Globals_1_m0._m0[2].x, _Globals_1_m0._m0[3].x), float4(_Globals_1_m0._m0[0].y, _Globals_1_m0._m0[1].y, _Globals_1_m0._m0[2].y, _Globals_1_m0._m0[3].y), float4(_Globals_1_m0._m0[0].z, _Globals_1_m0._m0[1].z, _Globals_1_m0._m0[2].z, _Globals_1_m0._m0[3].z), float4(_Globals_1_m0._m0[0].w, _Globals_1_m0._m0[1].w, _Globals_1_m0._m0[2].w, _Globals_1_m0._m0[3].w)), (float4(_19956.xyz, 1.0f) + (_Globals_1_m1 * 1.0f)).xyzw);
	    output_0 = vColor;
	    output_1 = vNormalOs;
	    output_2 = _19956;
	    _23533.y = -_23533.y;
	    gl_Position = _23533;
	}
	
	PS_INPUT MainVs(VS_INPUT stage_input)
	{
	    vPositionOs = stage_input.vPositionOs;
	    vColor = stage_input.vColor;
	    vNormalOs = stage_input.vNormalOs;
	    nInstanceIdx = stage_input.nInstanceIdx;
	    MainVs_inner();
	    PS_INPUT stage_output;
	    stage_output.gl_Position = gl_Position;
	    stage_output.output_0 = output_0;
	    stage_output.output_1 = output_1;
	    stage_output.output_2 = output_2;
	    return stage_output;
	}
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
}

PS
{
	StaticCombo( S_MODE_FORWARD, 0..1 );
	StaticCombo( S_DOTTED_LINE, F_DOTTED_LINE );
	StaticCombo( S_ALPHA_TEST, F_ALPHA_TEST );
	StaticCombo( S_HIDDEN_WIREFRAME, F_HIDDEN_WIREFRAME );
	StaticCombo( S_FILL, F_FILL );
	
	cbuffer PerViewConstantBuffer_t < Attribute("PerViewConstantBuffer_t"); >;
	RenderState(StencilRef, 1);
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (288 bytes), HLSL reflection with SPIRV-Cross by KhronosGroup
	
	static float4 input_0;
	static float4 output_0;
	
	struct PS_INPUT
	{
	    float4 input_0 : TEXCOORD0;
	};
	
	struct PS_OUTPUT
	{
	    float4 output_0 : SV_Target0;
	};
	
	void MainPs_inner()
	{
	    output_0 = input_0;
	}
	
	PS_OUTPUT MainPs(PS_INPUT stage_input)
	{
	    input_0 = stage_input.input_0;
	    MainPs_inner();
	    PS_OUTPUT stage_output;
	    stage_output.output_0 = output_0;
	    return stage_output;
	}
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
}
