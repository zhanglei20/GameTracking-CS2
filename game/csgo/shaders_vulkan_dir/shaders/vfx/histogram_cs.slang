//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "Histogram";
	DevShader = true;
	Version = 0;
	
	// VcsVersion: 70
	// Platform: VULKAN_SM_50
	// Programs: cs
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

CS
{
	DynamicCombo( D_HISTOGRAM_MODE, 0..2 );
	DynamicCombo( D_MSAA_SAMPLES, 0..3 );
	DynamicCombo( D_TONEMAP_BLEND, 0..3 );
	DynamicCombo( D_DITHER_NOISE, 0..2 );
	
	cbuffer Histogram_t < Attribute("Histogram_t"); >;
	cbuffer PerViewConstantBuffer_t < Attribute("PerViewConstantBuffer_t"); >;
	RWBuffer<float4> g_bAverageLuminance < Attribute("AverageLuminance"); >;
	RWBuffer<float4> g_bHistogramBins < Attribute("HistogramBins"); >;
	float g_flDitherNoiseAmount < Attribute("DitherNoiseAmount"); UiType(Slider); >;
	float g_flExposureBiasScaleFactor < Default(1); Attribute("ExposureBiasScaleFactor"); UiType(Slider); >;
	Texture2D g_tBlueNoise < Attribute("BlueNoise"); SrgbRead(false); >;
	Texture2D g_tInput < Attribute("Input"); SrgbRead(false); >;
	RWTexture2D<float4> g_tOutput < Attribute("Output"); >;
	float4 g_vBlueNoiseDitherParams < UiType(VectorText); Expression(ATTRIBUTE[c6be84fa]); >;
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (2972 bytes), HLSL reflection with SPIRV-Cross by KhronosGroup
	
	cbuffer Histogram_t : register(b3, space0)
	{
	    uint2 Histogram_t_1_m0 : packoffset(c0);
	    float Histogram_t_1_m1 : packoffset(c0.z);
	    float Histogram_t_1_m2 : packoffset(c1);
	};
	
	RWTexture2D<float4> _5853 : register(u158, space0);
	RWBuffer<uint> _3900 : register(u159, space0);
	Texture2D<float4> g_tInput : register(t31, space0);
	
	static uint3 gl_GlobalInvocationID;
	static uint gl_LocalInvocationIndex;
	struct SPIRV_Cross_Input
	{
	    uint3 gl_GlobalInvocationID : SV_DispatchThreadID;
	    uint gl_LocalInvocationIndex : SV_GroupIndex;
	};
	
	groupshared uint _5922[256];
	
	void MainCs_inner()
	{
	    _5922[gl_LocalInvocationIndex] = 0u;
	    GroupMemoryBarrierWithGroupSync();
	    float4 _13136;
	    float3 _16324;
	    _13136 = 0.0f.xxxx;
	    _16324 = 0.0f.xxx;
	    float3 _4730;
	    int _9913;
	    float4 _10794;
	    int _17017 = 0;
	    for (;;)
	    {
	        if (!(_17017 < 1))
	        {
	            break;
	        }
	        float4 _3401 = g_tInput.Load(int3(int3(int2(gl_GlobalInvocationID.xy), 0).xy, 0), int2(0, 0));
	        float3 _22047 = _3401.xyz;
	        _4730 = _16324 + _22047;
	        float3 _23908 = clamp(_22047, 0.0f.xxx, 65504.0f.xxx);
	        float4 _13888 = _3401;
	        _13888.x = _23908.x;
	        _13888.y = _23908.y;
	        _13888.z = _23908.z;
	        _10794 = _13136.xyzw + _13888.xyzw;
	        _9913 = _17017 + 1;
	        _13136 = _10794;
	        _16324 = _4730;
	        _17017 = _9913;
	        continue;
	    }
	    bool _6459;
	    if (gl_GlobalInvocationID.x < Histogram_t_1_m0.x)
	    {
	        _6459 = gl_GlobalInvocationID.y < Histogram_t_1_m0.y;
	    }
	    else
	    {
	        _6459 = false;
	    }
	    uint _6918;
	    InterlockedAdd(_5922[uint(clamp((log2(max(dot(_16324, float3(0.2125000059604644775390625f, 0.7153999805450439453125f, 0.07209999859333038330078125f)), 0.004999999888241291046142578125f)) - Histogram_t_1_m1) * Histogram_t_1_m2, 0.0f, 1.0f) * 255.0f)], uint(int(_6459)), _6918);
	    _5853[gl_GlobalInvocationID.xy] = _13136;
	    GroupMemoryBarrierWithGroupSync();
	    if (_5922[gl_LocalInvocationIndex] > 0u)
	    {
	        uint _16104;
	        InterlockedAdd(_3900[gl_LocalInvocationIndex], _5922[gl_LocalInvocationIndex], _16104);
	    }
	}
	
	[numthreads(16, 16, 1)]
	void MainCs(SPIRV_Cross_Input stage_input)
	{
	    gl_GlobalInvocationID = stage_input.gl_GlobalInvocationID;
	    gl_LocalInvocationIndex = stage_input.gl_LocalInvocationIndex;
	    MainCs_inner();
	}
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
}
