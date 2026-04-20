//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "Selection overlay";
	DevShader = true;
	Version = 0;
	
	// VcsVersion: 70
	// Platform: VULKAN_SM_40
	// Programs: ps, vs
}

MODES
{
	Default();
}

FEATURES
{
	Feature( F_NO_CULLING, 0..1, "" );
}

COMMON
{
	#include "system.fxc"
}

struct VS_INPUT
{
	float4 vBlendIndices : BLENDINDICES0  < Semantic( BlendIndices ); >;                          
	float4 vBlendWeight  : BLENDWEIGHT0   < Semantic( BlendWeight ); >;                           
	float4 vColor        : COLOR0         < Semantic( Color ); >;                                 
	float3 vPositionOs   : POSITION0      < Semantic( PosXyz ); >;                                
	float2 nInstanceIdx  : TEXCOORD13     < Semantic( InstanceTransformUv ); >;                   
};

VS
{
	DynamicCombo( D_BLEND_WEIGHT_COUNT, 0..4 );
	
	cbuffer PerViewConstantBuffer_t < Attribute("PerViewConstantBuffer_t"); >;
	StructuredBuffer g_instanceBuffer < Attribute("InstanceBuffer"); SrgbRead(false); >;
	StructuredBuffer g_transformBuffer < Attribute("TransformBuffer"); SrgbRead(false); >;
	
	// OverrideColor
	float g_OverrideColorFactor < UiType(Slider); UiGroup("OverrideColor"); >;
	float4 g_vOverrideColor < UiType(Color); UiGroup("OverrideColor"); Expression(SrgbGammaToLinear(this)); >;
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (4124 bytes), HLSL reflection with SPIRV-Cross by KhronosGroup
	
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
	
	struct _982
	{
	    float4 _m0[3];
	};
	
	struct _2923
	{
	    _982 _m0;
	};
	
	struct _1108
	{
	    float4 _m0[4];
	};
	
	ByteAddressBuffer g_instanceBuffer : register(t32, space0);
	ByteAddressBuffer g_transformBuffer : register(t30, space0);
	cbuffer PerViewConstantBuffer_t : register(b1, space0)
	{
	    _1108 PerViewConstantBuffer_t_1_m0 : packoffset(c0);
	    float4 PerViewConstantBuffer_t_1_m1 : packoffset(c24);
	};
	
	cbuffer _Globals_ : register(b0, space0)
	{
	    float4 _Globals_1_g_vOverrideColor : packoffset(c0);
	    float _Globals_1_g_OverrideColorFactor : packoffset(c1);
	};
	
	
	static float4 gl_Position;
	static float3 vPositionOs;
	static float4 vColor;
	static uint nInstanceIdx;
	static float4 output_0;
	static float4 output_1;
	
	struct VS_INPUT
	{
	    float3 vPositionOs : TEXCOORD0;
	    float4 vColor : TEXCOORD1;
	    uint nInstanceIdx : TEXCOORD2;
	};
	
	struct PS_INPUT
	{
	    float4 output_0 : TEXCOORD0;
	    float4 output_1 : TEXCOORD1;
	    float4 gl_Position : SV_Position;
	};
	
	void MainVs_inner()
	{
	    _982 _25207;
	    [unroll]
	    for (int _1ident = 0; _1ident < 3; _1ident++)
	    {
	        _25207._m0[_1ident] = asfloat(g_transformBuffer.Load4(_1ident * 16 + g_instanceBuffer.Load(nInstanceIdx * 32 + 4) * 48 + 0));
	    }
	    float4 _23533 = mul(float4x4(float4(PerViewConstantBuffer_t_1_m0._m0[0].x, PerViewConstantBuffer_t_1_m0._m0[1].x, PerViewConstantBuffer_t_1_m0._m0[2].x, PerViewConstantBuffer_t_1_m0._m0[3].x), float4(PerViewConstantBuffer_t_1_m0._m0[0].y, PerViewConstantBuffer_t_1_m0._m0[1].y, PerViewConstantBuffer_t_1_m0._m0[2].y, PerViewConstantBuffer_t_1_m0._m0[3].y), float4(PerViewConstantBuffer_t_1_m0._m0[0].z, PerViewConstantBuffer_t_1_m0._m0[1].z, PerViewConstantBuffer_t_1_m0._m0[2].z, PerViewConstantBuffer_t_1_m0._m0[3].z), float4(PerViewConstantBuffer_t_1_m0._m0[0].w, PerViewConstantBuffer_t_1_m0._m0[1].w, PerViewConstantBuffer_t_1_m0._m0[2].w, PerViewConstantBuffer_t_1_m0._m0[3].w)), (float4(mul(float3x4(_25207._m0[0], _25207._m0[1], _25207._m0[2]), float4(vPositionOs.xyz, 1.0f)).xyz, 1.0f) + (PerViewConstantBuffer_t_1_m1 * 1.0f)).xyzw);
	    float3 _24030 = vColor.xyz * 0.077399380505084991455078125f.xxx;
	    float3 _7676 = pow((vColor.xyz * 0.947867333889007568359375f.xxx) + 0.052132703363895416259765625f.xxx, 2.400000095367431640625f.xxx);
	    float _21354;
	    if (vColor.x <= 0.040449999272823333740234375f)
	    {
	        _21354 = _24030.x;
	    }
	    else
	    {
	        _21354 = _7676.x;
	    }
	    float _21355;
	    if (vColor.y <= 0.040449999272823333740234375f)
	    {
	        _21355 = _24030.y;
	    }
	    else
	    {
	        _21355 = _7676.y;
	    }
	    float _19190;
	    if (vColor.z <= 0.040449999272823333740234375f)
	    {
	        _19190 = _24030.z;
	    }
	    else
	    {
	        _19190 = _7676.z;
	    }
	    output_0 = float4(lerp(float3(_21354, _21355, _19190), _Globals_1_g_vOverrideColor.xyz, _Globals_1_g_OverrideColorFactor.xxx), lerp(vColor.w, _Globals_1_g_vOverrideColor.w, _Globals_1_g_OverrideColorFactor));
	    output_1 = _23533;
	    _23533.y = -_23533.y;
	    gl_Position = _23533;
	}
	
	PS_INPUT MainVs(VS_INPUT stage_input)
	{
	    vPositionOs = stage_input.vPositionOs;
	    vColor = stage_input.vColor;
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
	
	RenderState(CullMode, F_NO_CULLING ? None : Back);
	RenderState(DepthBias, -8);
	RenderState(DepthBiasClamp, 0);
	RenderState(SlopeScaleDepthBias, 0);
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
