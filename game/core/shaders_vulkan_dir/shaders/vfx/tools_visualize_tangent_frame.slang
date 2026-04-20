//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "Debug shader that render normals or tangent space as lines";
	DevShader = true;
	Version = 0;
	
	// VcsVersion: 70
	// Platform: VULKAN_SM_40
	// Programs: gs, ps, vs
}

MODES
{
	ToolsWireframe(S_MODE_TOOLS_WIREFRAME);
	ToolsUtil(S_MODE_FORWARD);
}

FEATURES
{
	Feature( F_SHOW_TANGENTS, 0..1, "General" );
	Feature( F_SHOW_BENT_NORMALS, 0..1, "General" );
}

COMMON
{
	#include "system.fxc"
}

struct VS_INPUT
{
	uint4  nPackedFrame               : NORMAL0        < Semantic( CompressedTangentFrame ); >;    // D_COMPRESSED_NORMALS_AND_TANGENTS=1
	float4 vBlendIndices              : BLENDINDICES0  < Semantic( BlendIndices ); >;              // D_BLEND_WEIGHT_COUNT=1, D_BLEND_WEIGHT_COUNT=2, D_BLEND_WEIGHT_COUNT=3, D_BLEND_WEIGHT_COUNT=4
	float4 vTangentUOs_flTangentVSign : TANGENT0       < Semantic( TangentU_SignV ); >;           
	float4 vBlendWeight               : BLENDWEIGHT0   < Semantic( BlendWeight ); >;               // D_BLEND_WEIGHT_COUNT=2, D_BLEND_WEIGHT_COUNT=3, D_BLEND_WEIGHT_COUNT=4
	uint4  nVertexIndex               : TEXCOORD14     < Semantic( MorphIndex ); >;                // D_MORPH=1
	float4 vNormalOs                  : NORMAL0        < Semantic( Normal ); >;                    // D_COMPRESSED_NORMALS_AND_TANGENTS=0
	float3 vPositionOs                : POSITION0      < Semantic( PosXyz ); >;                   
	float2 nInstanceIdx               : TEXCOORD13     < Semantic( InstanceTransformUv ); >;      
};

VS
{
	StaticCombo( S_MODE_FORWARD, 0..1 );
	StaticCombo( S_MODE_TOOLS_WIREFRAME, 0..1 );
	StaticCombo( S_SHOW_TANGENTS, F_SHOW_TANGENTS );
	StaticCombo( S_SHOW_BENT_NORMALS, F_SHOW_BENT_NORMALS );
	StaticComboRule( Allow1( S_MODE_FORWARD, S_MODE_TOOLS_WIREFRAME ) );
	StaticComboRule( Allow1( S_SHOW_BENT_NORMALS, S_SHOW_BENT_NORMALS ) );
	DynamicCombo( D_BLEND_WEIGHT_COUNT, 0..4 );
	DynamicCombo( D_COMPRESSED_NORMALS_AND_TANGENTS, 0..1 );
	DynamicCombo( D_MORPH, 0..1 );
	
	cbuffer PerViewConstantBuffer_t < Attribute("PerViewConstantBuffer_t"); >;
	StructuredBuffer g_instanceBuffer < Attribute("InstanceBuffer"); SrgbRead(false); >;
	Texture2D g_tCompositeMorphTextureAtlas < Attribute("CompositeMorphTextureAtlas"); SrgbRead(false); >;
	StructuredBuffer g_transformBuffer < Attribute("TransformBuffer"); SrgbRead(false); >;
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (1724 bytes), HLSL reflection with SPIRV-Cross by KhronosGroup
	
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
	
	ByteAddressBuffer g_instanceBuffer : register(t32, space0);
	ByteAddressBuffer g_transformBuffer : register(t30, space0);
	
	static float3 vPositionOs;
	static float3 vNormalOs;
	static uint nInstanceIdx;
	static float3 output_0;
	static float3 output_1;
	
	struct VS_INPUT
	{
	    float3 vPositionOs : TEXCOORD0;
	    float3 vNormalOs : TEXCOORD1;
	    uint nInstanceIdx : TEXCOORD3;
	};
	
	struct PS_INPUT
	{
	    float3 output_0 : TEXCOORD0;
	    float3 output_1 : TEXCOORD1;
	};
	
	void MainVs_inner()
	{
	    _1150 _25207;
	    [unroll]
	    for (int _1ident = 0; _1ident < 3; _1ident++)
	    {
	        _25207._m0[_1ident] = asfloat(g_transformBuffer.Load4(_1ident * 16 + g_instanceBuffer.Load(nInstanceIdx * 32 + 4) * 48 + 0));
	    }
	    float3x4 _14437 = float3x4(_25207._m0[0], _25207._m0[1], _25207._m0[2]);
	    output_0 = mul(_14437, float4(vPositionOs.xyz, 1.0f));
	    output_1 = normalize(mul(_14437, float4(vNormalOs.xyz, 0.0f)));
	}
	
	PS_INPUT MainVs(VS_INPUT stage_input)
	{
	    vPositionOs = stage_input.vPositionOs;
	    vNormalOs = stage_input.vNormalOs;
	    nInstanceIdx = stage_input.nInstanceIdx;
	    MainVs_inner();
	    PS_INPUT stage_output;
	    stage_output.output_0 = output_0;
	    stage_output.output_1 = output_1;
	    return stage_output;
	}
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
}

GS
{
	StaticCombo( S_SHOW_TANGENTS, F_SHOW_TANGENTS );
	StaticCombo( S_SHOW_BENT_NORMALS, F_SHOW_BENT_NORMALS );
	
	cbuffer PerViewConstantBuffer_t < Attribute("PerViewConstantBuffer_t"); >;
	float g_flVectorLength < Default(1); Range(0, 1000); UiType(Slider); >;
	
	// SPIR-V reflection failed for backend HLSL:
	// Unsupported shader stage.
	// 
	// Re-attempting reflection with the GLSL backend.
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (2948 bytes), GLSL reflection with SPIRV-Cross by KhronosGroup
	
	#version 460
	layout(triangles) in;
	layout(max_vertices = 6, line_strip) out;
	
	struct _1055
	{
	    vec3 _m0;
	    vec3 _m1;
	};
	
	struct _2452
	{
	    vec4 _m0[4];
	};
	
	struct _2915
	{
	    _2452 _m0;
	    vec4 _m1;
	};
	
	layout(set = 2) uniform _2915 PerViewConstantBuffer_t;
	
	struct _985
	{
	    float _m0;
	};
	
	layout(set = 2) uniform _985 undetermined;
	
	layout(location = 0) in vec3 input_0[3];
	layout(location = 1) in vec3 input_1[3];
	layout(location = 0) out vec3 output_0;
	
	void main()
	{
	    _1055 _19582[3] = _1055[](_1055(input_0[0], input_1[0]), _1055(input_0[1], input_1[1]), _1055(input_0[2], input_1[2]));
	    int _10337;
	    int _13039 = 0;
	    for (;;)
	    {
	        if (!(_13039 < 3))
	        {
	            break;
	        }
	        vec4 _21447 = PerViewConstantBuffer_t._m1 * 1.0;
	        mat4 _15571 = mat4(vec4(PerViewConstantBuffer_t._m0._m0[0].x, PerViewConstantBuffer_t._m0._m0[1].x, PerViewConstantBuffer_t._m0._m0[2].x, PerViewConstantBuffer_t._m0._m0[3].x), vec4(PerViewConstantBuffer_t._m0._m0[0].y, PerViewConstantBuffer_t._m0._m0[1].y, PerViewConstantBuffer_t._m0._m0[2].y, PerViewConstantBuffer_t._m0._m0[3].y), vec4(PerViewConstantBuffer_t._m0._m0[0].z, PerViewConstantBuffer_t._m0._m0[1].z, PerViewConstantBuffer_t._m0._m0[2].z, PerViewConstantBuffer_t._m0._m0[3].z), vec4(PerViewConstantBuffer_t._m0._m0[0].w, PerViewConstantBuffer_t._m0._m0[1].w, PerViewConstantBuffer_t._m0._m0[2].w, PerViewConstantBuffer_t._m0._m0[3].w));
	        vec4 _23875 = (vec4(_19582[_13039]._m0.xyz, 1.0) + _21447).xyzw * _15571;
	        output_0 = vec3(0.0, 0.0, 1.0);
	        _23875.y = -_23875.y;
	        gl_Position = _23875;
	        EmitVertex();
	        vec4 _8486 = (vec4((_19582[_13039]._m0.xyz + (_19582[_13039]._m1.xyz * undetermined._m0)).xyz, 1.0) + _21447).xyzw * _15571;
	        output_0 = vec3(0.300000011920928955078125, 0.300000011920928955078125, 1.0);
	        _8486.y = -_8486.y;
	        gl_Position = _8486;
	        EmitVertex();
	        EndPrimitive();
	        _10337 = _13039 + 1;
	        _13039 = _10337;
	        continue;
	    }
	}
	
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
}

PS
{
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (372 bytes), HLSL reflection with SPIRV-Cross by KhronosGroup
	
	static float3 input_0;
	static float4 output_0;
	
	struct PS_INPUT
	{
	    float3 input_0 : TEXCOORD0;
	};
	
	struct PS_OUTPUT
	{
	    float4 output_0 : SV_Target0;
	};
	
	void MainPs_inner()
	{
	    output_0 = float4(input_0.xyz, 1.0f);
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
