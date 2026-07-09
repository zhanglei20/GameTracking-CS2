//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "A shader for untextured and unlit meshes";
	DevShader = true;
	Version = 0;
	
	// VcsVersion: 71
	// Platform: VULKAN_SM_50
	// Programs: ps, vs
}

MODES
{
	Default();
	VrForward();
	Depth("depth_only.vfx");
	ProjectionDepth("depth_only.vfx");
	Forward();
	ToolsWireframe(S_MODE_TOOLS_WIREFRAME);
}

FEATURES
{
	Feature( F_MORPH_SUPPORTED, 0..1, "Morph" );
	Feature( F_IGNOREZ, 0..1, "Destalpha and depth" );
	Feature( F_WRITE_TO_DESTALPHA, 0..1, "Destalpha and depth" );
	Feature( F_PREMULTIPLY_BY_ALPHA_AND_ACCUMULATE_ONE_MINUS_ALPHA, 0..1, "Destalpha and depth" );
	Feature( F_DISABLE_Z_WRITE, 0..1, "Destalpha and depth" );
	Feature( F_DISABLE_STENCIL_WRITE, 0..1, "Disable writing to the stencil buffer if bound" );
}

COMMON
{
	#include "system.fxc"
}

struct VS_INPUT
{
	float4 vBlendIndices : BLENDINDICES0  < Semantic( BlendIndices ); >;                           // D_BLEND_WEIGHT_COUNT=1, D_BLEND_WEIGHT_COUNT=2, D_BLEND_WEIGHT_COUNT=3, D_BLEND_WEIGHT_COUNT=4
	float4 vBlendWeight  : BLENDWEIGHT0   < Semantic( BlendWeight ); >;                            // D_BLEND_WEIGHT_COUNT=2, D_BLEND_WEIGHT_COUNT=3, D_BLEND_WEIGHT_COUNT=4
	uint4  nVertexIndex  : TEXCOORD14     < Semantic( MorphIndex ); >;                             // D_MORPH=1
	float3 vPositionOs   : POSITION0      < Semantic( PosXyz ); >;                                
	float2 nInstanceIdx  : TEXCOORD13     < Semantic( InstanceTransformUv ); >;                   
};

VS
{
	StaticCombo( S_MODE_TOOLS_WIREFRAME, 0..1 );
	StaticCombo( S_MORPH_SUPPORTED, F_MORPH_SUPPORTED );
	DynamicCombo( D_BLEND_WEIGHT_COUNT, 0..4 );
	DynamicCombo( D_COMPRESSED_NORMALS_AND_TANGENTS, 0..1 );
	DynamicCombo( D_MORPH, 0..1 );
	DynamicComboRule( Requires( D_MORPH, S_MORPH_SUPPORTED ) );
	
	cbuffer PerViewConstantBuffer_t < Attribute("PerViewConstantBuffer_t"); >;
	StructuredBuffer g_instanceBuffer < Attribute("InstanceBuffer"); >;
	Texture2D g_tCompositeMorphTextureAtlas < Attribute("CompositeMorphTextureAtlas"); SrgbRead(false); >;
	StructuredBuffer g_transformBuffer < Attribute("TransformBuffer"); >;
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (3660 bytes), HLSL reflection with SPIRV-Cross by KhronosGroup
	
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
	
	struct _1126
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
	
	struct _1119
	{
	    float3x4 _m0;
	};
	
	struct _1120
	{
	    row_major float3x4 _m0;
	};
	
	ByteAddressBuffer g_instanceBuffer : register(t32, space0);
	ByteAddressBuffer g_transformBuffer : register(t30, space0);
	cbuffer PerViewConstantBuffer_t : register(b1, space0)
	{
	    column_major float4x4 PerViewConstantBuffer_t_1_m0 : packoffset(c0);
	    float4 PerViewConstantBuffer_t_1_m1 : packoffset(c17);
	    float4 PerViewConstantBuffer_t_1_m2 : packoffset(c24);
	};
	
	
	static float4 gl_Position;
	static float gl_ClipDistance[1];
	static uint vPositionOs;
	static float3 nInstanceIdx;
	static float3 output_0;
	static float4 output_1;
	
	struct VS_INPUT
	{
	    float3 nInstanceIdx : TEXCOORD0;
	    uint vPositionOs : TEXCOORD4;
	};
	
	struct PS_INPUT
	{
	    float3 output_0 : TEXCOORD0;
	    float4 output_1 : TEXCOORD1;
	    float4 gl_Position : SV_Position;
	    float gl_ClipDistance0 : SV_ClipDistance0;
	};
	
	void MainVs_inner()
	{
	    _1126 _24007;
	    _24007._m0 = g_instanceBuffer.Load(vPositionOs * 32 + 0);
	    _24007._m1 = g_instanceBuffer.Load(vPositionOs * 32 + 4);
	    _24007._m2 = g_instanceBuffer.Load(vPositionOs * 32 + 8);
	    _24007._m3 = g_instanceBuffer.Load(vPositionOs * 32 + 12);
	    _24007._m4 = g_instanceBuffer.Load(vPositionOs * 32 + 16);
	    _24007._m5 = g_instanceBuffer.Load(vPositionOs * 32 + 20);
	    _24007._m6 = g_instanceBuffer.Load(vPositionOs * 32 + 24);
	    _24007._m7 = asfloat(g_instanceBuffer.Load(vPositionOs * 32 + 28));
	    _1125 _22470;
	    _22470._m0 = _24007._m0;
	    _22470._m1 = _24007._m1;
	    _22470._m2 = _24007._m2;
	    _22470._m3 = _24007._m3;
	    _22470._m4 = _24007._m4;
	    _22470._m5 = _24007._m5;
	    _22470._m6 = _24007._m6;
	    _22470._m7 = _24007._m7;
	    float4 _23812 = float4(uint4(_22470._m0 & 255u, (_22470._m0 & 65280u) >> uint(8), (_22470._m0 & 16711680u) >> uint(16), (_22470._m0 & 4278190080u) >> uint(24))) * 0.0039215688593685626983642578125f.xxxx;
	    float3 _6253 = _23812.xyz;
	    float3 _17828 = _6253 * 0.077399380505084991455078125f.xxx;
	    float3 _7676 = pow((_6253 * 0.947867333889007568359375f.xxx) + 0.052132703363895416259765625f.xxx, 2.400000095367431640625f.xxx);
	    float _21354;
	    if (_23812.x <= 0.040449999272823333740234375f)
	    {
	        _21354 = _17828.x;
	    }
	    else
	    {
	        _21354 = _7676.x;
	    }
	    float _21355;
	    if (_23812.y <= 0.040449999272823333740234375f)
	    {
	        _21355 = _17828.y;
	    }
	    else
	    {
	        _21355 = _7676.y;
	    }
	    float _19302;
	    if (_23812.z <= 0.040449999272823333740234375f)
	    {
	        _19302 = _17828.z;
	    }
	    else
	    {
	        _19302 = _7676.z;
	    }
	    _1120 _8152;
	    _8152._m0 = asfloat(uint3x4(g_transformBuffer.Load4(_22470._m1 * 48 + 0), g_transformBuffer.Load4(_22470._m1 * 48 + 16), g_transformBuffer.Load4(_22470._m1 * 48 + 32)));
	    _1119 _19848;
	    _19848._m0 = _8152._m0;
	    float3 _19937 = mul(_19848._m0, float4(nInstanceIdx.xyz, 1.0f));
	    float4 _18256 = mul(PerViewConstantBuffer_t_1_m0, (float4(_19937.xyz, 1.0f) + (PerViewConstantBuffer_t_1_m2 * 1.0f)).xyzw);
	    output_0 = _19937;
	    output_1 = float4(_21354, _21355, _19302, _23812.w);
	    _18256.y = -_18256.y;
	    gl_Position = _18256;
	    gl_ClipDistance[0] = dot(float4(_19937.xyz, 1.0f), PerViewConstantBuffer_t_1_m1.xyzw);
	}
	
	PS_INPUT MainVs(VS_INPUT stage_input)
	{
	    vPositionOs = stage_input.vPositionOs;
	    nInstanceIdx = stage_input.nInstanceIdx;
	    MainVs_inner();
	    PS_INPUT stage_output;
	    stage_output.gl_Position = gl_Position;
	    stage_output.gl_ClipDistance0.x = gl_ClipDistance[0];
	    stage_output.output_0 = output_0;
	    stage_output.output_1 = output_1;
	    return stage_output;
	}
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
}

PS
{
	StaticCombo( S_MODE_TOOLS_WIREFRAME, 0..1 );
	StaticCombo( S_PREMULTIPLY_BY_ALPHA_AND_ACCUMULATE_ONE_MINUS_ALPHA, F_PREMULTIPLY_BY_ALPHA_AND_ACCUMULATE_ONE_MINUS_ALPHA );
	
	RenderState(BlendEnable, True);
	RenderState(ColorWriteEnable0, F_WRITE_TO_DESTALPHA ? All : 7);
	RenderState(DepthFunc, F_IGNOREZ ? Always : LessEqual);
	RenderState(DepthWriteEnable, F_DISABLE_Z_WRITE ? False : True);
	RenderState(DstBlend, One);
	cbuffer PerViewConstantBuffer_t < Attribute("PerViewConstantBuffer_t"); >;
	RenderState(SrcBlend, One);
	RenderState(SrcBlendAlpha, Zero);
	RenderState(StencilEnable, F_DISABLE_STENCIL_WRITE ? 0 : 1);
	RenderState(StencilPassOp, 2);
	RenderState(StencilRef, 1);
	
	// Color
	float3 g_vColorTint < Default3(1, 1, 1); UiType(Color); UiGroup("Color"); >;
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (1064 bytes), HLSL reflection with SPIRV-Cross by KhronosGroup
	
	static float4 _1;
	
	cbuffer _Globals_ : register(b0, space1)
	{
	    float3 _Globals_1_g_vColorTint : packoffset(c0.y);
	};
	
	cbuffer PerViewConstantBuffer_t : register(b1, space1)
	{
	    float PerViewConstantBuffer_t_1_m0 : packoffset(c18);
	};
	
	
	static float4 input_0;
	static float4 output_0;
	
	struct PS_INPUT
	{
	    float4 input_0 : TEXCOORD1;
	};
	
	struct PS_OUTPUT
	{
	    float4 output_0 : SV_Target0;
	};
	
	void MainPs_inner()
	{
	    float3 _13043 = _Globals_1_g_vColorTint.xyz * input_0.xyz;
	    float4 _13888;
	    _13888.x = _13043.x;
	    _13888.y = _13043.y;
	    _13888.z = _13043.z;
	    output_0 = float4(_13888.xyz * PerViewConstantBuffer_t_1_m0, input_0.w);
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
	
	
	
	BoolAttribute(SupportsMappingDimensions, true);
	
}
