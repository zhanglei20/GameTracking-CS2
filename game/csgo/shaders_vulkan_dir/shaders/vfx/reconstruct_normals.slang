//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "Reconstruct Normals";
	DevShader = true;
	Version = 2;
	
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
	
	ExternalDescriptorSet g_globalLateBoundBindlessSet < Source(ExternalDescSet); Attribute("g_globalLateBoundBindlessSet"); >;
	ExternalDescriptorSet g_lightBinnerGpuSet < Source(ExternalDescSet); Attribute("g_lightBinnerGpuSet"); >;
	
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
	DynamicCombo( D_METHOD, 0..1 );
	
	cbuffer PerViewConstantBuffer_t < Attribute("PerViewConstantBuffer_t"); >;
	ExternalDescriptorSet g_globalLateBoundBindlessSet < Source(ExternalDescSet); Attribute("g_globalLateBoundBindlessSet"); >;
	ExternalDescriptorSet g_lightBinnerGpuSet < Source(ExternalDescSet); Attribute("g_lightBinnerGpuSet"); >;
	Texture2D g_tSceneDepth < Attribute("ResolvedDepth"); SrgbRead(false); >;
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (5300 bytes), HLSL reflection with SPIRV-Cross by KhronosGroup
	
	cbuffer _Globals_ : register(b0, space1)
	{
	    float4 _Globals_1_m0 : packoffset(c16);
	    float _Globals_1_m1 : packoffset(c23);
	    float _Globals_1_m2 : packoffset(c23.y);
	    float3 _Globals_1_m3 : packoffset(c26);
	    float3 _Globals_1_m4 : packoffset(c28);
	};
	
	Texture2D<float4> g_tSceneDepth : register(t30, space1);
	
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
	    float4 _20381 = g_tSceneDepth.Load(int3(int3(int2(gl_FragCoord.xy), 0).xy, 0));
	    float _7480 = _20381.x;
	    float4 _20382 = g_tSceneDepth.Load(int3(int3(int2(gl_FragCoord.xy + float2(-1.0f, 0.0f)), 0).xy, 0));
	    float _7481 = _20382.x;
	    float4 _20383 = g_tSceneDepth.Load(int3(int3(int2(gl_FragCoord.xy + float2(1.0f, 0.0f)), 0).xy, 0));
	    float _7482 = _20383.x;
	    float4 _20384 = g_tSceneDepth.Load(int3(int3(int2(gl_FragCoord.xy + float2(0.0f, -1.0f)), 0).xy, 0));
	    float _7483 = _20384.x;
	    float4 _21863 = g_tSceneDepth.Load(int3(int3(int2(gl_FragCoord.xy + float2(0.0f, 1.0f)), 0).xy, 0));
	    float _14919 = _21863.x;
	    float3 _14924 = ddx(input_0);
	    float3 _11557 = ddy(input_0);
	    float _10955 = _Globals_1_m2 - _Globals_1_m1;
	    float3 _16581 = (_Globals_1_m3.xyz + (input_0.xyz * (1.0f / (((clamp((_7480 - _Globals_1_m1) / _10955, 0.0f, 1.0f) * _Globals_1_m0.z) + _Globals_1_m0.w) * dot(_Globals_1_m4.xyz, input_0.xyz))))).xyz;
	    float3 _10970;
	    float3 _14790;
	    if (abs(_7480 - _7481) < abs(_7480 - _7482))
	    {
	        float3 _18365 = (input_0 - _14924).xyz;
	        float3 _16583 = (_Globals_1_m3.xyz + (_18365 * (1.0f / (((clamp((_7481 - _Globals_1_m1) / _10955, 0.0f, 1.0f) * _Globals_1_m0.z) + _Globals_1_m0.w) * dot(_Globals_1_m4.xyz, _18365))))).xyz;
	        float3 _13213;
	        float3 _15671;
	        if (abs(_7480 - _7483) < abs(_7480 - _14919))
	        {
	            float3 _18367 = (input_0 - _11557).xyz;
	            _13213 = (_Globals_1_m3.xyz + (_18367 * (1.0f / (((clamp((_7483 - _Globals_1_m1) / _10955, 0.0f, 1.0f) * _Globals_1_m0.z) + _Globals_1_m0.w) * dot(_Globals_1_m4.xyz, _18367))))).xyz;
	            _15671 = _16583;
	        }
	        else
	        {
	            float3 _18366 = (input_0 + _11557).xyz;
	            _13213 = _16583;
	            _15671 = (_Globals_1_m3.xyz + (_18366 * (1.0f / (((clamp((_14919 - _Globals_1_m1) / _10955, 0.0f, 1.0f) * _Globals_1_m0.z) + _Globals_1_m0.w) * dot(_Globals_1_m4.xyz, _18366))))).xyz;
	        }
	        _10970 = _13213;
	        _14790 = _15671;
	    }
	    else
	    {
	        float3 _18362 = (input_0 + _14924).xyz;
	        float3 _16582 = (_Globals_1_m3.xyz + (_18362 * (1.0f / (((clamp((_7482 - _Globals_1_m1) / _10955, 0.0f, 1.0f) * _Globals_1_m0.z) + _Globals_1_m0.w) * dot(_Globals_1_m4.xyz, _18362))))).xyz;
	        float3 _13212;
	        float3 _15670;
	        if (abs(_7480 - _7483) < abs(_7480 - _14919))
	        {
	            float3 _18364 = (input_0 - _11557).xyz;
	            _13212 = _16582;
	            _15670 = (_Globals_1_m3.xyz + (_18364 * (1.0f / (((clamp((_7483 - _Globals_1_m1) / _10955, 0.0f, 1.0f) * _Globals_1_m0.z) + _Globals_1_m0.w) * dot(_Globals_1_m4.xyz, _18364))))).xyz;
	        }
	        else
	        {
	            float3 _18363 = (input_0 + _11557).xyz;
	            _13212 = (_Globals_1_m3.xyz + (_18363 * (1.0f / (((clamp((_14919 - _Globals_1_m1) / _10955, 0.0f, 1.0f) * _Globals_1_m0.z) + _Globals_1_m0.w) * dot(_Globals_1_m4.xyz, _18363))))).xyz;
	            _15670 = _16582;
	        }
	        _10970 = _13212;
	        _14790 = _15670;
	    }
	    float3 _23652 = -normalize(cross(_14790 - _16581, _10970 - _16581));
	    output_0 = float4(((((_23652.xy / (_23652.z + 1.0f).xx) * 0.562524616718292236328125f.xx) * 0.5f) + 0.5f.xx).xy, 0.0f, 0.0f);
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
