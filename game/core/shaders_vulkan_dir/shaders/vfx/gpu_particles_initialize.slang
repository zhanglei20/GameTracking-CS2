//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "Initialize operators for new GPU particles";
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
	DynamicCombo( D_OUTPUT_DEBUG_STATS, 0..1 );
	
	StructuredBuffer g_PerFrameSimulation < Attribute("PerFrameSimulation"); SrgbRead(false); >;
	RWStructuredBuffer g_SystemDefinition < Attribute("SystemDefinition"); >;
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (2324 bytes), HLSL reflection with SPIRV-Cross by KhronosGroup
	
	struct _1002
	{
	    uint _m0;
	    uint _m1;
	    uint _m2;
	};
	
	struct _27
	{
	    _1002 _m0;
	    uint _m1;
	    uint _m2;
	    uint _m3;
	    uint _m4;
	    uint _m5;
	};
	
	struct _2494
	{
	    float4 _m0[32];
	};
	
	struct _2704
	{
	    float4 _m0[4];
	};
	
	struct _105
	{
	    _2704 _m0[4];
	};
	
	struct _2824
	{
	    float _m0;
	    _2494 _m1;
	    _105 _m2;
	    uint _m3;
	};
	
	static uint _3;
	
	RWByteAddressBuffer undetermined : register(u158, space0);
	ByteAddressBuffer g_PerFrameSimulation : register(t32, space0);
	
	static uint3 gl_LocalInvocationID;
	static uint3 gl_GlobalInvocationID;
	struct SPIRV_Cross_Input
	{
	    uint3 gl_LocalInvocationID : SV_GroupThreadID;
	    uint3 gl_GlobalInvocationID : SV_DispatchThreadID;
	};
	
	void MainCs_inner()
	{
	    do
	    {
	        if (gl_GlobalInvocationID.x >= g_PerFrameSimulation.Load(772))
	        {
	            break;
	        }
	        uint4 _18439 = WaveActiveBallot(true);
	        uint _19665 = countbits(_18439.x) + countbits(_18439.y) + countbits(_18439.z) + countbits(_18439.w);
	        uint _13002;
	        if (WaveIsFirstLane())
	        {
	            uint _24340;
	            undetermined.InterlockedAdd(28, uint(int(_19665)), _24340);
	            uint _9620;
	            undetermined.InterlockedMin(28, undetermined.Load(24) - 1u, _9620);
	            uint _12901;
	            undetermined.InterlockedMin(0, (undetermined.Load(28) + 31u) / 32u, _12901);
	            _13002 = _24340;
	        }
	        else
	        {
	            _13002 = _3;
	        }
	        if ((WaveReadLaneFirst(_13002) + gl_LocalInvocationID.x) >= undetermined.Load(24))
	        {
	            break;
	        }
	        break;
	    } while(false);
	}
	
	[numthreads(32, 1, 1)]
	void MainCs(SPIRV_Cross_Input stage_input)
	{
	    gl_LocalInvocationID = stage_input.gl_LocalInvocationID;
	    gl_GlobalInvocationID = stage_input.gl_GlobalInvocationID;
	    MainCs_inner();
	}
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
}
