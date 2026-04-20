//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "Compacts indirect draw requests";
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
	DynamicCombo( D_DEBUG_OUTPUT_STATS, 0..1 );
	DynamicCombo( D_WAVEOPS, 0..1 );
	
	RWBuffer<float4> g_Counts < Attribute("CompactedCounts"); >;
	RWStructuredBuffer g_GlobalStats < Attribute("GlobalStats"); >;
	Buffer g_Input < Attribute("InputDraws"); SrgbRead(false); >;
	RWBuffer<float4> g_Output < Attribute("OutputDraws"); >;
	StructuredBuffer g_Requests < Attribute("CompactionRequests"); SrgbRead(false); >;
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (3000 bytes), HLSL reflection with SPIRV-Cross by KhronosGroup
	
	struct _990
	{
	    uint _m0;
	    uint _m1;
	};
	
	ByteAddressBuffer g_Requests : register(t30, space0);
	RWBuffer<uint> _3229 : register(u159, space0);
	Buffer<uint4> undetermined : register(t31, space0);
	RWBuffer<uint> _4783 : register(u158, space0);
	
	static uint3 gl_LocalInvocationID;
	static uint3 gl_GlobalInvocationID;
	struct SPIRV_Cross_Input
	{
	    uint3 gl_LocalInvocationID : SV_GroupThreadID;
	    uint3 gl_GlobalInvocationID : SV_DispatchThreadID;
	};
	
	groupshared uint _5866[4];
	
	void MainCs_inner()
	{
	    uint _24425 = g_Requests.Load(gl_GlobalInvocationID.x * 8 + 0);
	    uint _19512 = _24425 >> uint(8);
	    uint _23353 = g_Requests.Load(gl_GlobalInvocationID.x * 8 + 4);
	    uint _6021 = _24425 & 255u;
	    bool _20621 = gl_LocalInvocationID.y == 0u;
	    if (_20621)
	    {
	        _5866[gl_LocalInvocationID.x] = 0u;
	    }
	    GroupMemoryBarrierWithGroupSync();
	    uint _4283;
	    uint _13039 = gl_LocalInvocationID.y;
	    for (;;)
	    {
	        if (!(_13039 < _6021))
	        {
	            break;
	        }
	        uint _18763 = (_19512 + _13039) * 5u;
	        uint4 _8527 = undetermined.Load(int(_18763));
	        uint _7919 = _8527.x;
	        uint4 _8603 = undetermined.Load(int(_18763 + 1u));
	        uint _8120 = _8603.x;
	        if ((_7919 * _8120) != 0u)
	        {
	            uint _3233;
	            InterlockedAdd(_5866[gl_LocalInvocationID.x], 1u, _3233);
	            uint _25189 = (_23353 + _3233) * 5u;
	            _4783[_25189] = _7919.x;
	            _4783[_25189 + 1u] = _8120.x;
	            _4783[_25189 + 2u] = undetermined.Load(int(_18763 + 2u)).x.x;
	            _4783[_25189 + 3u] = undetermined.Load(int(_18763 + 3u)).x.x;
	            _4783[_25189 + 4u] = undetermined.Load(int(_18763 + 4u)).x.x;
	        }
	        _4283 = _13039 + 16u;
	        _13039 = _4283;
	        continue;
	    }
	    GroupMemoryBarrierWithGroupSync();
	    bool _12885;
	    if (_20621)
	    {
	        _12885 = _6021 != 0u;
	    }
	    else
	    {
	        _12885 = false;
	    }
	    if (_12885)
	    {
	        _3229[_23353] = _5866[gl_LocalInvocationID.x].x;
	    }
	}
	
	[numthreads(4, 16, 1)]
	void MainCs(SPIRV_Cross_Input stage_input)
	{
	    gl_LocalInvocationID = stage_input.gl_LocalInvocationID;
	    gl_GlobalInvocationID = stage_input.gl_GlobalInvocationID;
	    MainCs_inner();
	}
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
}
