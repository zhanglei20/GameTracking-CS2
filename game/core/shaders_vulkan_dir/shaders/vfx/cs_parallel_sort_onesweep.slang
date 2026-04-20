//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "Sort something on the GPU.";
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
	DynamicCombo( D_PASS, 0..4 );
	DynamicCombo( D_16_BIT_KEYS, 0..1 );
	DynamicComboRule( Requires( D_16_BIT_KEYS, D_PASS=1 ) );
	
	RWStructuredBuffer b_alt < Attribute("AltSortBuffer"); >;
	RWStructuredBuffer b_altPayload < Attribute("AltPayloadBuffer"); >;
	RWStructuredBuffer b_globalHist < Attribute("GlobalHistBuffer"); >;
	RWStructuredBuffer b_index < Attribute("PassIndexBuffer"); >;
	RWStructuredBuffer b_passHist < Attribute("PassHistBuffer"); >;
	RWStructuredBuffer b_sort < Attribute("SortBuffer"); >;
	RWStructuredBuffer b_sortPayload < Attribute("PayloadBuffer"); >;
	StructuredBuffer g_constantBuffer < Attribute("DispatchArgBuffer"); SrgbRead(false); >;
	cbuffer g_consts < Source(ExternalDescSet); Attribute("g_consts"); >;
	cbuffer g_consts < Source(ExternalDescSet); Attribute("g_consts"); >;
	RWStructuredBuffer g_dispatchBuffer < Attribute("DispatchArgBuffer"); >;
	int g_nFixedKeyCount < Attribute("FixedKeyCount"); UiType(Slider); >;
	int g_nKeyCountBufferOffset < Attribute("NumKeysIndex"); UiType(Slider); >;
	int g_nPartitionSize < Attribute("PartitionSize"); UiType(Slider); >;
	int g_nRadixPasses < Attribute("RadixPasses"); UiType(Slider); >;
	RWStructuredBuffer g_numKeysBuffer < Attribute("NumKeysBuffer"); >;
	
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (1968 bytes), HLSL reflection with SPIRV-Cross by KhronosGroup
	
	struct _990
	{
	    uint _m0;
	    uint _m1;
	};
	
	struct _417
	{
	    _990 _m0[4];
	};
	
	struct _1002
	{
	    uint _m0;
	    uint _m1;
	    uint _m2;
	};
	
	struct _1281
	{
	    _1002 _m0[4];
	};
	
	struct _2601
	{
	    _417 _m0;
	    _1281 _m1;
	};
	
	ByteAddressBuffer g_constantBuffer : register(t30, space0);
	RWByteAddressBuffer undetermined : register(u162, space0);
	globallycoherent RWByteAddressBuffer undetermined_1 : register(u164, space0);
	globallycoherent RWByteAddressBuffer undetermined_2 : register(u163, space0);
	cbuffer _981_4645
	{
	    uint _4645_m0 : packoffset(c0);
	};
	
	
	static uint3 gl_GlobalInvocationID;
	struct SPIRV_Cross_Input
	{
	    uint3 gl_GlobalInvocationID : SV_DispatchThreadID;
	};
	
	void MainCs_inner()
	{
	    uint _19822 = g_constantBuffer.Load(_4645_m0 * 8 + 4) * 1024u;
	    uint _4283;
	    uint _13039 = gl_GlobalInvocationID.x;
	    for (;;)
	    {
	        if (!(_13039 < _19822))
	        {
	            break;
	        }
	        undetermined_2.Store(_13039 * 4 + 0, 0u);
	        _4283 = _13039 + 65536u;
	        _13039 = _4283;
	        continue;
	    }
	    if (gl_GlobalInvocationID.x < 1024u)
	    {
	        undetermined.Store(gl_GlobalInvocationID.x * 4 + 0, 0u);
	    }
	    if (gl_GlobalInvocationID.x < 4u)
	    {
	        undetermined_1.Store(gl_GlobalInvocationID.x * 4 + 0, 0u);
	    }
	}
	
	[numthreads(256, 1, 1)]
	void MainCs(SPIRV_Cross_Input stage_input)
	{
	    gl_GlobalInvocationID = stage_input.gl_GlobalInvocationID;
	    MainCs_inner();
	}
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
}
