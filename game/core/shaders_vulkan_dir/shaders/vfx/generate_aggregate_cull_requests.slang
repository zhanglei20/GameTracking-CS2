//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "Generates aggregate meshlet culling requests for fragments";
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
	DynamicCombo( D_SUPPORTS_MESH_SHADER, 0..1 );
	
	RWStructuredBuffer g_CullRequests < Attribute("CullRequests"); >;
	RWBuffer<float4> g_DrawArgs < Attribute("FragmentDrawArgs"); >;
	RWStructuredBuffer g_MSIndirectDispatchArgs < Attribute("MSIndirectDispatchArgs"); >;
	StructuredBuffer g_Requests < Attribute("GenCullRequests"); SrgbRead(false); >;
	int g_nNumRequests < Attribute("NumRequests"); UiType(Slider); >;
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (2840 bytes), HLSL reflection with SPIRV-Cross by KhronosGroup
	
	struct _1080
	{
	    uint _m0;
	    uint _m1;
	    uint _m2;
	    uint _m3;
	    uint _m4;
	    uint _m5;
	    uint _m6;
	};
	
	struct _1017
	{
	    uint _m0;
	    uint _m1;
	    uint _m2;
	    uint _m3;
	};
	
	cbuffer _Globals_ : register(b0, space0)
	{
	    uint _Globals_1_g_nNumRequests : packoffset(c0);
	};
	
	ByteAddressBuffer g_Requests : register(t30, space0);
	RWByteAddressBuffer undetermined : register(u158, space0);
	RWBuffer<uint> _4767 : register(u159, space0);
	
	static uint3 gl_LocalInvocationID;
	static uint3 gl_GlobalInvocationID;
	struct SPIRV_Cross_Input
	{
	    uint3 gl_LocalInvocationID : SV_GroupThreadID;
	    uint3 gl_GlobalInvocationID : SV_DispatchThreadID;
	};
	
	void MainCs_inner()
	{
	    if (gl_GlobalInvocationID.x < _Globals_1_g_nNumRequests)
	    {
	        uint _5232;
	        uint _13039 = gl_LocalInvocationID.y;
	        for (;;)
	        {
	            if (!(_13039 < g_Requests.Load(gl_GlobalInvocationID.x * 28 + 4)))
	            {
	                break;
	            }
	            uint _17363 = g_Requests.Load(gl_GlobalInvocationID.x * 28 + 8);
	            uint _24369 = g_Requests.Load(gl_GlobalInvocationID.x * 28 + 16);
	            uint _24370 = g_Requests.Load(gl_GlobalInvocationID.x * 28 + 24);
	            uint _13724 = g_Requests.Load(gl_GlobalInvocationID.x * 28 + 12) + _13039;
	            undetermined.Store(_13724 * 16 + 0, g_Requests.Load(gl_GlobalInvocationID.x * 28 + 0) + _13039);
	            undetermined.Store(_13724 * 16 + 4, _17363);
	            undetermined.Store(_13724 * 16 + 8, _24369);
	            undetermined.Store(_13724 * 16 + 12, _24370);
	            _5232 = _13039 + 32u;
	            _13039 = _5232;
	            continue;
	        }
	        if (gl_LocalInvocationID.y == 0u)
	        {
	            uint _18611 = g_Requests.Load(gl_GlobalInvocationID.x * 28 + 8);
	            uint _20432 = _18611 * 5u;
	            _4767[_20432] = uint4(0u, 0u, 0u, 0u).x;
	            _4767[_20432 + 1u] = uint4(1u, 1u, 1u, 1u).x;
	            _4767[_20432 + 2u] = g_Requests.Load(gl_GlobalInvocationID.x * 28 + 16).x;
	            _4767[_20432 + 3u] = g_Requests.Load(gl_GlobalInvocationID.x * 28 + 20).x;
	            _4767[_20432 + 4u] = g_Requests.Load(gl_GlobalInvocationID.x * 28 + 24).x;
	        }
	    }
	}
	
	[numthreads(1, 32, 1)]
	void MainCs(SPIRV_Cross_Input stage_input)
	{
	    gl_LocalInvocationID = stage_input.gl_LocalInvocationID;
	    gl_GlobalInvocationID = stage_input.gl_GlobalInvocationID;
	    MainCs_inner();
	}
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
}
