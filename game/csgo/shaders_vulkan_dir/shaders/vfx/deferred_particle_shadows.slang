//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "Deferred Particle Shadows";
	DevShader = true;
	Version = 0;
	
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
	float3 vPositionSs            : POSITION0  < Semantic( PosXyz ); >;                           
	float4 vCameraToFarPlaneRayWs : TEXCOORD0  < Semantic( CameraToFarPlaneRayWs ); >;            
};

VS
{
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (552 bytes), HLSL reflection with SPIRV-Cross by KhronosGroup
	
	static float4 gl_Position;
	static float3 vPositionSs;
	static float3 vCameraToFarPlaneRayWs;
	static float3 output_0;
	
	struct VS_INPUT
	{
	    float3 vPositionSs : TEXCOORD0;
	    float3 vCameraToFarPlaneRayWs : TEXCOORD1;
	};
	
	struct PS_INPUT
	{
	    float3 output_0 : TEXCOORD0;
	    float4 gl_Position : SV_Position;
	};
	
	void MainVs_inner()
	{
	    float4 _14456 = float4(vPositionSs, 1.0f);
	    output_0 = vCameraToFarPlaneRayWs;
	    _14456.y = -vPositionSs.y;
	    gl_Position = _14456;
	}
	
	PS_INPUT MainVs(VS_INPUT stage_input)
	{
	    vPositionSs = stage_input.vPositionSs;
	    vCameraToFarPlaneRayWs = stage_input.vCameraToFarPlaneRayWs;
	    MainVs_inner();
	    PS_INPUT stage_output;
	    stage_output.gl_Position = gl_Position;
	    stage_output.output_0 = output_0;
	    return stage_output;
	}
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
}

PS
{
	DynamicCombo( D_MSAA_DEPTH_BUFFER, 0..1 );
	
	cbuffer PerViewConstantBuffer_t < Attribute("PerViewConstantBuffer_t"); >;
	cbuffer SunLightShaderParamsCB < Attribute("SunLightShaderParamsCB"); >;
	Texture2D g_tGBufferDepth < Attribute("GBufferDepth"); SrgbRead(false); >;
	Texture2D g_tShadowDepthMapAtlas < Attribute("ShadowDepthMapAtlas"); SrgbRead(false); >;
	float4 g_vDepthBufferSize < Attribute("GBufferDepthSize"); UiType(VectorText); >;
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (10908 bytes), HLSL reflection with SPIRV-Cross by KhronosGroup
	
	struct _2943
	{
	    float4 _m0[4];
	};
	
	struct _1492
	{
	    _2943 _m0[4];
	};
	
	struct _2944
	{
	    float4 _m0[4];
	};
	
	static float3 _3;
	
	cbuffer PerViewConstantBuffer_t : register(b1, space1)
	{
	    float4 PerViewConstantBuffer_t_1_m0 : packoffset(c16);
	    float4 PerViewConstantBuffer_t_1_m1 : packoffset(c22);
	    float PerViewConstantBuffer_t_1_m2 : packoffset(c23);
	    float PerViewConstantBuffer_t_1_m3 : packoffset(c23.y);
	    float3 PerViewConstantBuffer_t_1_m4 : packoffset(c26);
	    float3 PerViewConstantBuffer_t_1_m5 : packoffset(c28);
	};
	
	cbuffer _Globals_ : register(b0, space1)
	{
	    float4 _Globals_1_g_vDepthBufferSize : packoffset(c0);
	};
	
	cbuffer SunLightShaderParamsCB : register(b3, space1)
	{
	    float4 SunLightShaderParamsCB_1_m0 : packoffset(c2);
	    float4 SunLightShaderParamsCB_1_m1 : packoffset(c3);
	    float4 SunLightShaderParamsCB_1_m2 : packoffset(c4);
	    _1492 SunLightShaderParamsCB_1_m3 : packoffset(c5);
	    _2944 SunLightShaderParamsCB_1_m4 : packoffset(c21);
	    int SunLightShaderParamsCB_1_m5 : packoffset(c29);
	};
	
	Texture2D<float4> g_tGBufferDepth : register(t32, space1);
	SamplerComparisonState AddressU_Clamp_AddressV_Clamp_Filter_ComparisonMinMagMipLinear : register(s14, space1);
	Texture2D<float4> g_tShadowDepthMapAtlas : register(t30, space1);
	
	static float4 gl_FragCoord;
	static float3 input_0;
	static float4 output_0;
	
	struct PS_INPUT
	{
	    float3 input_0 : TEXCOORD0;
	    float4 gl_FragCoord : SV_Position;
	};
	
	struct PS_OUTPUT
	{
	    float4 output_0 : SV_Target0;
	};
	
	void MainPs_inner()
	{
	    int3 _17020 = int3(uint3(uint2(clamp(((gl_FragCoord.xy * PerViewConstantBuffer_t_1_m1.xy).xy * _Globals_1_g_vDepthBufferSize.xy).xy, 0.0f.xx, _Globals_1_g_vDepthBufferSize.xy - 1.0f.xx)), 0u));
	    float3 _9855 = (PerViewConstantBuffer_t_1_m4.xyz + (input_0.xyz * (1.0f / (((clamp((g_tGBufferDepth.Load(int3(_17020.xy, _17020.z)).x - PerViewConstantBuffer_t_1_m2) / (PerViewConstantBuffer_t_1_m3 - PerViewConstantBuffer_t_1_m2), 0.0f, 1.0f) * PerViewConstantBuffer_t_1_m0.z) + PerViewConstantBuffer_t_1_m0.w) * dot(PerViewConstantBuffer_t_1_m5.xyz, input_0.xyz))))).xyz;
	    float _6559;
	    if (SunLightShaderParamsCB_1_m5 == 1)
	    {
	        float4 _22743 = mul(float4x4(float4(SunLightShaderParamsCB_1_m3._m0[0]._m0[0].x, SunLightShaderParamsCB_1_m3._m0[0]._m0[1].x, SunLightShaderParamsCB_1_m3._m0[0]._m0[2].x, SunLightShaderParamsCB_1_m3._m0[0]._m0[3].x), float4(SunLightShaderParamsCB_1_m3._m0[0]._m0[0].y, SunLightShaderParamsCB_1_m3._m0[0]._m0[1].y, SunLightShaderParamsCB_1_m3._m0[0]._m0[2].y, SunLightShaderParamsCB_1_m3._m0[0]._m0[3].y), float4(SunLightShaderParamsCB_1_m3._m0[0]._m0[0].z, SunLightShaderParamsCB_1_m3._m0[0]._m0[1].z, SunLightShaderParamsCB_1_m3._m0[0]._m0[2].z, SunLightShaderParamsCB_1_m3._m0[0]._m0[3].z), float4(SunLightShaderParamsCB_1_m3._m0[0]._m0[0].w, SunLightShaderParamsCB_1_m3._m0[0]._m0[1].w, SunLightShaderParamsCB_1_m3._m0[0]._m0[2].w, SunLightShaderParamsCB_1_m3._m0[0]._m0[3].w)), float4(_9855, 1.0f));
	        float _12504;
	        if (dot(clamp(_22743.xy, 0.0f.xx, 1.0f.xx) - _22743.xy, 1.0f.xx) == 0.0f)
	        {
	            float2 _13721 = ((_22743.xy * SunLightShaderParamsCB_1_m4._m0[0].zw) + SunLightShaderParamsCB_1_m4._m0[0].xy) + float2(SunLightShaderParamsCB_1_m0.zw);
	            _12504 = ((dot(g_tShadowDepthMapAtlas.GatherCmp(AddressU_Clamp_AddressV_Clamp_Filter_ComparisonMinMagMipLinear, _13721, _22743.z, int2(-2, -2)).xyzw, 0.0625f.xxxx) + dot(g_tShadowDepthMapAtlas.GatherCmp(AddressU_Clamp_AddressV_Clamp_Filter_ComparisonMinMagMipLinear, _13721, _22743.z, int2(0, -2)).xyzw, 0.0625f.xxxx)) + dot(g_tShadowDepthMapAtlas.GatherCmp(AddressU_Clamp_AddressV_Clamp_Filter_ComparisonMinMagMipLinear, _13721, _22743.z, int2(-2, 0)).xyzw, 0.0625f.xxxx)) + dot(g_tShadowDepthMapAtlas.GatherCmp(AddressU_Clamp_AddressV_Clamp_Filter_ComparisonMinMagMipLinear, _13721, _22743.z, int2(0, 0)).xyzw, 0.0625f.xxxx);
	        }
	        else
	        {
	            _12504 = 1.0f;
	        }
	        _6559 = _12504;
	    }
	    else
	    {
	        float _12503;
	        if (SunLightShaderParamsCB_1_m5 > 1)
	        {
	            int _23989;
	            int _9382;
	            float3 _11806;
	            int _13039 = 0;
	            for (;;)
	            {
	                if (!(_13039 < SunLightShaderParamsCB_1_m5))
	                {
	                    _11806 = 0.0f.xxx;
	                    _9382 = -1;
	                    break;
	                }
	                float4 _22742 = mul(float4x4(float4(SunLightShaderParamsCB_1_m3._m0[_13039]._m0[0].x, SunLightShaderParamsCB_1_m3._m0[_13039]._m0[1].x, SunLightShaderParamsCB_1_m3._m0[_13039]._m0[2].x, SunLightShaderParamsCB_1_m3._m0[_13039]._m0[3].x), float4(SunLightShaderParamsCB_1_m3._m0[_13039]._m0[0].y, SunLightShaderParamsCB_1_m3._m0[_13039]._m0[1].y, SunLightShaderParamsCB_1_m3._m0[_13039]._m0[2].y, SunLightShaderParamsCB_1_m3._m0[_13039]._m0[3].y), float4(SunLightShaderParamsCB_1_m3._m0[_13039]._m0[0].z, SunLightShaderParamsCB_1_m3._m0[_13039]._m0[1].z, SunLightShaderParamsCB_1_m3._m0[_13039]._m0[2].z, SunLightShaderParamsCB_1_m3._m0[_13039]._m0[3].z), float4(SunLightShaderParamsCB_1_m3._m0[_13039]._m0[0].w, SunLightShaderParamsCB_1_m3._m0[_13039]._m0[1].w, SunLightShaderParamsCB_1_m3._m0[_13039]._m0[2].w, SunLightShaderParamsCB_1_m3._m0[_13039]._m0[3].w)), float4(_9855, 1.0f));
	                if (dot(clamp(_22742.xy, 0.0f.xx, 1.0f.xx) - _22742.xy, 1.0f.xx) == 0.0f)
	                {
	                    float3 _23135;
	                    _23135.x = _22742.x;
	                    _23135.y = _22742.y;
	                    _11806 = _23135;
	                    _9382 = _13039;
	                    break;
	                }
	                _23989 = _13039 + 1;
	                _13039 = _23989;
	                continue;
	            }
	            float _12502;
	            if (_9382 >= 0)
	            {
	                float4 _22200 = float4(_9855, 1.0f);
	                float4 _23626 = mul(float4x4(float4(SunLightShaderParamsCB_1_m3._m0[_9382]._m0[0].x, SunLightShaderParamsCB_1_m3._m0[_9382]._m0[1].x, SunLightShaderParamsCB_1_m3._m0[_9382]._m0[2].x, SunLightShaderParamsCB_1_m3._m0[_9382]._m0[3].x), float4(SunLightShaderParamsCB_1_m3._m0[_9382]._m0[0].y, SunLightShaderParamsCB_1_m3._m0[_9382]._m0[1].y, SunLightShaderParamsCB_1_m3._m0[_9382]._m0[2].y, SunLightShaderParamsCB_1_m3._m0[_9382]._m0[3].y), float4(SunLightShaderParamsCB_1_m3._m0[_9382]._m0[0].z, SunLightShaderParamsCB_1_m3._m0[_9382]._m0[1].z, SunLightShaderParamsCB_1_m3._m0[_9382]._m0[2].z, SunLightShaderParamsCB_1_m3._m0[_9382]._m0[3].z), float4(SunLightShaderParamsCB_1_m3._m0[_9382]._m0[0].w, SunLightShaderParamsCB_1_m3._m0[_9382]._m0[1].w, SunLightShaderParamsCB_1_m3._m0[_9382]._m0[2].w, SunLightShaderParamsCB_1_m3._m0[_9382]._m0[3].w)), _22200);
	                float _15223 = _23626.z;
	                float2 _6348 = 1.0f.xx - clamp((abs(_11806.xy - 0.5f.xx) - SunLightShaderParamsCB_1_m1.z.xx) * SunLightShaderParamsCB_1_m1.w.xx, 0.0f.xx, 1.0f.xx);
	                float _7849 = 1.0f - (_6348.x * _6348.y);
	                float2 _21744 = float2(SunLightShaderParamsCB_1_m0.zw);
	                float2 _13720 = float3((_11806.xy * SunLightShaderParamsCB_1_m4._m0[_9382].zw) + SunLightShaderParamsCB_1_m4._m0[_9382].xy, _15223).xy + _21744;
	                float _13726 = ((dot(g_tShadowDepthMapAtlas.GatherCmp(AddressU_Clamp_AddressV_Clamp_Filter_ComparisonMinMagMipLinear, _13720, _15223, int2(-2, -2)).xyzw, 0.0625f.xxxx) + dot(g_tShadowDepthMapAtlas.GatherCmp(AddressU_Clamp_AddressV_Clamp_Filter_ComparisonMinMagMipLinear, _13720, _15223, int2(0, -2)).xyzw, 0.0625f.xxxx)) + dot(g_tShadowDepthMapAtlas.GatherCmp(AddressU_Clamp_AddressV_Clamp_Filter_ComparisonMinMagMipLinear, _13720, _15223, int2(-2, 0)).xyzw, 0.0625f.xxxx)) + dot(g_tShadowDepthMapAtlas.GatherCmp(AddressU_Clamp_AddressV_Clamp_Filter_ComparisonMinMagMipLinear, _13720, _15223, int2(0, 0)).xyzw, 0.0625f.xxxx);
	                float _12501;
	                if (_7849 > 0.0f)
	                {
	                    float _8523;
	                    if (_9382 < (SunLightShaderParamsCB_1_m5 - 1))
	                    {
	                        int _14126 = _9382 + 1;
	                        float4 _23706 = mul(float4x4(float4(SunLightShaderParamsCB_1_m3._m0[_14126]._m0[0].x, SunLightShaderParamsCB_1_m3._m0[_14126]._m0[1].x, SunLightShaderParamsCB_1_m3._m0[_14126]._m0[2].x, SunLightShaderParamsCB_1_m3._m0[_14126]._m0[3].x), float4(SunLightShaderParamsCB_1_m3._m0[_14126]._m0[0].y, SunLightShaderParamsCB_1_m3._m0[_14126]._m0[1].y, SunLightShaderParamsCB_1_m3._m0[_14126]._m0[2].y, SunLightShaderParamsCB_1_m3._m0[_14126]._m0[3].y), float4(SunLightShaderParamsCB_1_m3._m0[_14126]._m0[0].z, SunLightShaderParamsCB_1_m3._m0[_14126]._m0[1].z, SunLightShaderParamsCB_1_m3._m0[_14126]._m0[2].z, SunLightShaderParamsCB_1_m3._m0[_14126]._m0[3].z), float4(SunLightShaderParamsCB_1_m3._m0[_14126]._m0[0].w, SunLightShaderParamsCB_1_m3._m0[_14126]._m0[1].w, SunLightShaderParamsCB_1_m3._m0[_14126]._m0[2].w, SunLightShaderParamsCB_1_m3._m0[_14126]._m0[3].w)), _22200);
	                        float2 _20561 = (_23706.xy * SunLightShaderParamsCB_1_m4._m0[_14126].zw) + SunLightShaderParamsCB_1_m4._m0[_14126].xy;
	                        float3 _20488;
	                        _20488.x = _20561.x;
	                        _20488.y = _20561.y;
	                        float2 _11858 = _20488.xy + _21744;
	                        _8523 = ((dot(g_tShadowDepthMapAtlas.GatherCmp(AddressU_Clamp_AddressV_Clamp_Filter_ComparisonMinMagMipLinear, _11858, _23706.z, int2(-2, -2)).xyzw, 0.0625f.xxxx) + dot(g_tShadowDepthMapAtlas.GatherCmp(AddressU_Clamp_AddressV_Clamp_Filter_ComparisonMinMagMipLinear, _11858, _23706.z, int2(0, -2)).xyzw, 0.0625f.xxxx)) + dot(g_tShadowDepthMapAtlas.GatherCmp(AddressU_Clamp_AddressV_Clamp_Filter_ComparisonMinMagMipLinear, _11858, _23706.z, int2(-2, 0)).xyzw, 0.0625f.xxxx)) + dot(g_tShadowDepthMapAtlas.GatherCmp(AddressU_Clamp_AddressV_Clamp_Filter_ComparisonMinMagMipLinear, _11858, _23706.z, int2(0, 0)).xyzw, 0.0625f.xxxx);
	                    }
	                    else
	                    {
	                        _8523 = 1.0f;
	                    }
	                    _12501 = lerp(_13726, _8523, clamp(_7849, 0.0f, 1.0f));
	                }
	                else
	                {
	                    _12501 = _13726;
	                }
	                _12502 = _12501;
	            }
	            else
	            {
	                _12502 = 1.0f;
	            }
	            _12503 = _12502;
	        }
	        else
	        {
	            _12503 = 1.0f;
	        }
	        _6559 = _12503;
	    }
	    float _19133;
	    if (SunLightShaderParamsCB_1_m5 > 0)
	    {
	        _19133 = lerp(_6559, 1.0f, clamp((distance(_9855, PerViewConstantBuffer_t_1_m4) - SunLightShaderParamsCB_1_m2.x) * SunLightShaderParamsCB_1_m2.y, 0.0f, 1.0f));
	    }
	    else
	    {
	        _19133 = _6559;
	    }
	    output_0 = _19133.xxxx;
	}
	
	PS_OUTPUT MainPs(PS_INPUT stage_input)
	{
	    gl_FragCoord = stage_input.gl_FragCoord;
	    gl_FragCoord.w = 1.0 / gl_FragCoord.w;
	    input_0 = stage_input.input_0;
	    MainPs_inner();
	    PS_OUTPUT stage_output;
	    stage_output.output_0 = output_0;
	    return stage_output;
	}
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
}
