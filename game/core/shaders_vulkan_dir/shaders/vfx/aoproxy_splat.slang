//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "Splat Ambient Occlusion Proxies";
	DevShader = true;
	Version = 1;
	
	// VcsVersion: 70
	// Platform: VULKAN_SM_50
	// Programs: ps, vs
}

MODES
{
	Default();
}

FEATURES
{
}

COMMON
{
	#include "system.fxc"
}

struct VS_INPUT
{
	float3 vPositionOs : POSITION0  < Semantic( PosXyz ); >;                                      
};

VS
{
	
	cbuffer AoProxyConstantBuffer_t < Attribute("AoProxyConstantBuffer_t"); >;
	cbuffer PerViewConstantBuffer_t < Attribute("PerViewConstantBuffer_t"); >;
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (3424 bytes), HLSL reflection with SPIRV-Cross by KhronosGroup
	
	struct _2817
	{
	    float4 _m0[20];
	};
	
	struct _2697
	{
	    int4 _m0[20];
	};
	
	struct _2691
	{
	    float4 _m0[4];
	};
	
	cbuffer AoProxyConstantBuffer_t : register(b1, space0)
	{
	    _2817 AoProxyConstantBuffer_t_1_m0 : packoffset(c5);
	    _2817 AoProxyConstantBuffer_t_1_m1 : packoffset(c25);
	    _2817 AoProxyConstantBuffer_t_1_m2 : packoffset(c45);
	    _2697 AoProxyConstantBuffer_t_1_m3 : packoffset(c65);
	};
	
	cbuffer _Globals_ : register(b0, space0)
	{
	    _2691 _Globals_1_m0 : packoffset(c0);
	    float4 _Globals_1_m1 : packoffset(c24);
	    float3 _Globals_1_m2 : packoffset(c26);
	};
	
	
	static float4 gl_Position;
	static int gl_InstanceIndex;
	static int gl_BaseInstanceARB;
	cbuffer SPIRV_Cross_VertexInfo
	{
	    int SPIRV_Cross_BaseVertex;
	    int SPIRV_Cross_BaseInstance;
	};
	
	static float3 vPositionOs;
	static float4 output_0;
	static float3 output_1;
	static float3 output_2;
	static float output_3;
	static uint3 output_4;
	
	struct VS_INPUT
	{
	    float3 vPositionOs : TEXCOORD0;
	    uint gl_InstanceIndex : SV_InstanceID;
	};
	
	struct PS_INPUT
	{
	    float4 output_0 : TEXCOORD0;
	    float3 output_1 : TEXCOORD1;
	    float3 output_2 : TEXCOORD2;
	    float output_3 : TEXCOORD3;
	    nointerpolation uint3 output_4 : TEXCOORD4;
	    float4 gl_Position : SV_Position;
	};
	
	void MainVs_inner()
	{
	    uint _24589 = uint(gl_InstanceIndex - gl_BaseInstanceARB);
	    float3 _9948 = lerp(AoProxyConstantBuffer_t_1_m0._m0[_24589].xyz, AoProxyConstantBuffer_t_1_m1._m0[_24589].xyz, vPositionOs.xyz * 2.0f).xyz;
	    float4 _23609 = mul(float4x4(float4(_Globals_1_m0._m0[0].x, _Globals_1_m0._m0[1].x, _Globals_1_m0._m0[2].x, _Globals_1_m0._m0[3].x), float4(_Globals_1_m0._m0[0].y, _Globals_1_m0._m0[1].y, _Globals_1_m0._m0[2].y, _Globals_1_m0._m0[3].y), float4(_Globals_1_m0._m0[0].z, _Globals_1_m0._m0[1].z, _Globals_1_m0._m0[2].z, _Globals_1_m0._m0[3].z), float4(_Globals_1_m0._m0[0].w, _Globals_1_m0._m0[1].w, _Globals_1_m0._m0[2].w, _Globals_1_m0._m0[3].w)), (float4(_9948, 1.0f) + (_Globals_1_m1 * 1.0f)).xyzw);
	    float3 _23026 = 2.0f.xxx / (AoProxyConstantBuffer_t_1_m1._m0[_24589].xyz - AoProxyConstantBuffer_t_1_m0._m0[_24589].xyz);
	    output_0 = float4(((AoProxyConstantBuffer_t_1_m0._m0[_24589].xyz + AoProxyConstantBuffer_t_1_m1._m0[_24589].xyz) * (-0.5f)) * _23026.xyz, AoProxyConstantBuffer_t_1_m2._m0[_24589].x);
	    output_1 = _23026;
	    output_2 = _9948 - _Globals_1_m2.xyz;
	    output_3 = AoProxyConstantBuffer_t_1_m1._m0[_24589].w;
	    output_4 = uint3(AoProxyConstantBuffer_t_1_m3._m0[_24589].xyz);
	    _23609.y = -_23609.y;
	    gl_Position = _23609;
	}
	
	PS_INPUT MainVs(VS_INPUT stage_input)
	{
	    gl_InstanceIndex = int(stage_input.gl_InstanceIndex);
	    gl_BaseInstanceARB = SPIRV_Cross_BaseInstance;
	    vPositionOs = stage_input.vPositionOs;
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
	
	
}

PS
{
	StaticCombo( S_REVERSE_DEPTH_BUFFER, 0..1 );
	
	cbuffer AoProxyConstantBuffer_t < Attribute("AoProxyConstantBuffer_t"); >;
	cbuffer PerViewConstantBuffer_t < Attribute("PerViewConstantBuffer_t"); >;
	Texture2D g_tSceneDepth < Attribute("SceneDepth"); SrgbRead(false); >;
	Texture3D g_tTextureAoConeLUT < Channel(R, None(TextureAoConeLUT), Linear); OutputFormat(ATI1N); SrgbRead(false); >;
	
	// LUT
	CreateInputTexture2D(TextureAoConeLUT, Linear, 8, "", "_lut_z000", "LUT", Default4(1, 1, 1, 0));
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (9696 bytes), HLSL reflection with SPIRV-Cross by KhronosGroup
	
	struct _1276
	{
	    float4 _m0[4];
	};
	
	struct _2646
	{
	    float4 _m0[3];
	};
	
	struct _532
	{
	    _2646 _m0[106];
	};
	
	struct _2688
	{
	    float4 _m0[106];
	};
	
	cbuffer _Globals_ : register(b0, space1)
	{
	    float4 _Globals_1_m0 : packoffset(c16);
	    float _Globals_1_m1 : packoffset(c23);
	    float _Globals_1_m2 : packoffset(c23.y);
	    float3 _Globals_1_m3 : packoffset(c26);
	    float3 _Globals_1_m4 : packoffset(c28);
	};
	
	cbuffer AoProxyConstantBuffer_t : register(b1, space1)
	{
	    _1276 AoProxyConstantBuffer_t_1_m0 : packoffset(c0);
	    float4 AoProxyConstantBuffer_t_1_m1 : packoffset(c4);
	    _532 AoProxyConstantBuffer_t_1_m2 : packoffset(c85);
	    _2688 AoProxyConstantBuffer_t_1_m3 : packoffset(c403);
	};
	
	Texture2D<float4> g_tSceneDepth : register(t31, space1);
	Texture3D<float4> g_tTextureAoConeLUT : register(t30, space1);
	SamplerState AddressU_Clamp_AddressV_Clamp_AddressW_Clamp_Filter_MinMagLinearMipPoint : register(s14, space1);
	
	static float4 gl_FragCoord;
	static uint3 input_0;
	static float3 input_1;
	static float3 input_2;
	static float4 input_3;
	static float input_4;
	static float4 output_0;
	
	struct PS_INPUT
	{
	    float4 input_3 : TEXCOORD0;
	    float3 input_2 : TEXCOORD1;
	    float3 input_1 : TEXCOORD2;
	    float input_4 : TEXCOORD3;
	    nointerpolation uint3 input_0 : TEXCOORD4;
	    float4 gl_FragCoord : SV_Position;
	};
	
	struct PS_OUTPUT
	{
	    float4 output_0 : SV_Target0;
	};
	
	void MainPs_inner()
	{
	    float3 _10889 = (_Globals_1_m3.xyz + (input_1.xyz * (1.0f / (((clamp((g_tSceneDepth.Load(int3(int3(int2(gl_FragCoord.xy).xy, 0).xy, 0)).x - _Globals_1_m1) / (_Globals_1_m2 - _Globals_1_m1), 0.0f, 1.0f) * _Globals_1_m0.z) + _Globals_1_m0.w) * dot(_Globals_1_m4.xyz, input_1.xyz))))).xyz;
	    float3 _11842 = mad(_10889, input_2.xyz, input_3.xyz);
	    float3 _3852 = 1.0f.xxx - abs(_11842);
	    float _4208 = clamp(3.0f * min(_3852.x, min(_3852.y, _3852.z)), 0.0f, 1.0f) * clamp(2.7999999523162841796875f - (2.0f * length(_11842)), 0.0f, 1.0f);
	    if ((_4208 - 0.00999999977648258209228515625f) < 0.0f)
	    {
	        discard;
	    }
	    int _16648 = int(input_0.x);
	    int _12017 = int(input_0.y);
	    float4 _13155;
	    _13155 = 1.0f.xxxx;
	    float4 _16164;
	    int _21531;
	    int _16208 = _16648;
	    for (;;)
	    {
	        if (!(_16208 < _12017))
	        {
	            break;
	        }
	        float4x3 _21989 = float4x3(float3(AoProxyConstantBuffer_t_1_m2._m0[_16208]._m0[0].x, AoProxyConstantBuffer_t_1_m2._m0[_16208]._m0[1].x, AoProxyConstantBuffer_t_1_m2._m0[_16208]._m0[2].x), float3(AoProxyConstantBuffer_t_1_m2._m0[_16208]._m0[0].y, AoProxyConstantBuffer_t_1_m2._m0[_16208]._m0[1].y, AoProxyConstantBuffer_t_1_m2._m0[_16208]._m0[2].y), float3(AoProxyConstantBuffer_t_1_m2._m0[_16208]._m0[0].z, AoProxyConstantBuffer_t_1_m2._m0[_16208]._m0[1].z, AoProxyConstantBuffer_t_1_m2._m0[_16208]._m0[2].z), float3(AoProxyConstantBuffer_t_1_m2._m0[_16208]._m0[0].w, AoProxyConstantBuffer_t_1_m2._m0[_16208]._m0[1].w, AoProxyConstantBuffer_t_1_m2._m0[_16208]._m0[2].w));
	        float3 _17090 = mul(float4(_10889, 1.0f), _21989);
	        float3 _17194 = _17090.xyz;
	        float _8132 = rsqrt(dot(_17194, _17194));
	        float3 _16478 = (_17090.xyz * (-_8132)).xyz;
	        _16164 = _13155.xyzw * float4(g_tTextureAoConeLUT.Sample(AddressU_Clamp_AddressV_Clamp_AddressW_Clamp_Filter_MinMagLinearMipPoint, float3(mad(dot(normalize(mul(AoProxyConstantBuffer_t_1_m0._m0[0].xyzw, _21989).xyz).xyz, _16478), 0.5f, 0.5f), _8132, AoProxyConstantBuffer_t_1_m1.x)).x, g_tTextureAoConeLUT.Sample(AddressU_Clamp_AddressV_Clamp_AddressW_Clamp_Filter_MinMagLinearMipPoint, float3(mad(dot(normalize(mul(AoProxyConstantBuffer_t_1_m0._m0[1].xyzw, _21989).xyz).xyz, _16478), 0.5f, 0.5f), _8132, AoProxyConstantBuffer_t_1_m1.y)).x, g_tTextureAoConeLUT.Sample(AddressU_Clamp_AddressV_Clamp_AddressW_Clamp_Filter_MinMagLinearMipPoint, float3(mad(dot(normalize(mul(AoProxyConstantBuffer_t_1_m0._m0[2].xyzw, _21989).xyz).xyz, _16478), 0.5f, 0.5f), _8132, AoProxyConstantBuffer_t_1_m1.z)).x, g_tTextureAoConeLUT.Sample(AddressU_Clamp_AddressV_Clamp_AddressW_Clamp_Filter_MinMagLinearMipPoint, float3(mad(dot(normalize(mul(AoProxyConstantBuffer_t_1_m0._m0[3].xyzw, _21989).xyz).xyz, _16478), 0.5f, 0.5f), _8132, AoProxyConstantBuffer_t_1_m1.w)).x).xyzw;
	        _21531 = _16208 + 1;
	        _13155 = _16164;
	        _16208 = _21531;
	        continue;
	    }
	    int _23852 = int(input_0.z);
	    float4 _13156;
	    _13156 = _13155.xyzw;
	    float4 _16165;
	    int _21532;
	    int _16209 = _12017;
	    for (;;)
	    {
	        if (!(_16209 < _23852))
	        {
	            break;
	        }
	        float4x3 _21990 = float4x3(float3(AoProxyConstantBuffer_t_1_m2._m0[_16209]._m0[0].x, AoProxyConstantBuffer_t_1_m2._m0[_16209]._m0[1].x, AoProxyConstantBuffer_t_1_m2._m0[_16209]._m0[2].x), float3(AoProxyConstantBuffer_t_1_m2._m0[_16209]._m0[0].y, AoProxyConstantBuffer_t_1_m2._m0[_16209]._m0[1].y, AoProxyConstantBuffer_t_1_m2._m0[_16209]._m0[2].y), float3(AoProxyConstantBuffer_t_1_m2._m0[_16209]._m0[0].z, AoProxyConstantBuffer_t_1_m2._m0[_16209]._m0[1].z, AoProxyConstantBuffer_t_1_m2._m0[_16209]._m0[2].z), float3(AoProxyConstantBuffer_t_1_m2._m0[_16209]._m0[0].w, AoProxyConstantBuffer_t_1_m2._m0[_16209]._m0[1].w, AoProxyConstantBuffer_t_1_m2._m0[_16209]._m0[2].w));
	        float3 _15779 = mul(float4(_10889, 1.0f), _21990);
	        float3 _20220 = (clamp(_15779.xyz, -AoProxyConstantBuffer_t_1_m3._m0[_16209].xyz, AoProxyConstantBuffer_t_1_m3._m0[_16209].xyz) * 0.89999997615814208984375f) - _15779.xyz;
	        float3 _10134 = abs(_20220);
	        float _23212 = 1.0f / (1.0f + (dot(_10134 / ((_10134.x + _10134.y) + _10134.z).xxx, 3.1415927410125732421875f.xxx / (AoProxyConstantBuffer_t_1_m3._m0[_16209].yzx * AoProxyConstantBuffer_t_1_m3._m0[_16209].zxy).xyz) * length(_20220)));
	        float3 _16479 = normalize(_20220).xyz;
	        _16165 = _13156.xyzw * float4(g_tTextureAoConeLUT.Sample(AddressU_Clamp_AddressV_Clamp_AddressW_Clamp_Filter_MinMagLinearMipPoint, float3(mad(dot(normalize(mul(AoProxyConstantBuffer_t_1_m0._m0[0].xyzw, _21990).xyz).xyz, _16479), 0.5f, 0.5f), _23212, AoProxyConstantBuffer_t_1_m1.x)).x, g_tTextureAoConeLUT.Sample(AddressU_Clamp_AddressV_Clamp_AddressW_Clamp_Filter_MinMagLinearMipPoint, float3(mad(dot(normalize(mul(AoProxyConstantBuffer_t_1_m0._m0[1].xyzw, _21990).xyz).xyz, _16479), 0.5f, 0.5f), _23212, AoProxyConstantBuffer_t_1_m1.y)).x, g_tTextureAoConeLUT.Sample(AddressU_Clamp_AddressV_Clamp_AddressW_Clamp_Filter_MinMagLinearMipPoint, float3(mad(dot(normalize(mul(AoProxyConstantBuffer_t_1_m0._m0[2].xyzw, _21990).xyz).xyz, _16479), 0.5f, 0.5f), _23212, AoProxyConstantBuffer_t_1_m1.z)).x, g_tTextureAoConeLUT.Sample(AddressU_Clamp_AddressV_Clamp_AddressW_Clamp_Filter_MinMagLinearMipPoint, float3(mad(dot(normalize(mul(AoProxyConstantBuffer_t_1_m0._m0[3].xyzw, _21990).xyz).xyz, _16479), 0.5f, 0.5f), _23212, AoProxyConstantBuffer_t_1_m1.w)).x).xyzw;
	        _21532 = _16209 + 1;
	        _13156 = _16165;
	        _16209 = _21532;
	        continue;
	    }
	    output_0 = lerp(1.0f.xxxx, _13156.xyzw, ((_4208 * input_3.w) * input_4).xxxx);
	}
	
	PS_OUTPUT MainPs(PS_INPUT stage_input)
	{
	    gl_FragCoord = stage_input.gl_FragCoord;
	    gl_FragCoord.w = 1.0 / gl_FragCoord.w;
	    input_0 = stage_input.input_0;
	    input_1 = stage_input.input_1;
	    input_2 = stage_input.input_2;
	    input_3 = stage_input.input_3;
	    input_4 = stage_input.input_4;
	    MainPs_inner();
	    PS_OUTPUT stage_output;
	    stage_output.output_0 = output_0;
	    return stage_output;
	}
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
	
	BoolAttribute(decal, true);
	BoolAttribute(ambientocclusionproxy, true);
	
}
