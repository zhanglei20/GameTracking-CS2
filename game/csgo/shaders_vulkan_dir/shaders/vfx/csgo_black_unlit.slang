//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "Just renders black";
	DevShader = false;
	Version = 1;
	
	// VcsVersion: 70
	// Platform: VULKAN_SM_50
	// Programs: ps, psrs, vs
}

MODES
{
	CsgoForward();
	Depth("csgo_depth_only.vfx");
	ToolsVis(S_MODE_TOOLS_VIS);
	ToolsWireframe("csgo_tools_wireframe.vfx");
}

FEATURES
{
	Feature( F_DO_NOT_CAST_SHADOWS, 0..1, "Shadows" );
	Feature( F_RENDER_BACKFACES, 0..1, "2-Sided Rendering" );
	Feature( F_DONT_FLIP_BACKFACE_NORMALS, 0..1, "2-Sided Rendering" );
	Feature( F_DISABLE_Z_BUFFERING, 0..1, "Z-Buffering" );
	Feature( F_DISABLE_Z_PREPASS, 0..1, "Z-Prepass" );
	FeatureRule( Requires( F_DONT_FLIP_BACKFACE_NORMALS, F_RENDER_BACKFACES ), "Only applies to backfaces" );
}

COMMON
{
	#include "system.fxc"
}

struct VS_INPUT
{
	float4 vBlendIndices : BLENDINDICES0  < Semantic( BlendIndices ); >;                           // D_CS_VERTEX_ANIMATION=0
	uint4  nPackedFrame  : NORMAL0        < Semantic( CompressedTangentFrame ); >;                
	float4 vNormalOs     : NORMAL0        < Semantic( Normal ); >;                                
	float3 vPositionOs   : POSITION0      < Semantic( PosXyz ); >;                                 // D_CS_VERTEX_ANIMATION=0
	float2 vTexCoord     : TEXCOORD0      < Semantic( LowPrecisionUv ); >;                        
	float2 nInstanceIdx  : TEXCOORD13     < Semantic( InstanceTransformUv ); >;                   
};

VS
{
	StaticCombo( S_MODE_TOOLS_VIS, 0..1 );
	DynamicCombo( D_COMPRESSED_NORMALS_AND_TANGENTS, 0..1 );
	DynamicCombo( D_CS_VERTEX_ANIMATION, 0..1 );
	
	cbuffer PerViewConstantBufferCsgo_t < Attribute("PerViewConstantBufferCsgo_t"); >;
	cbuffer PerViewConstantBuffer_t < Attribute("PerViewConstantBuffer_t"); >;
	ByteAddressBuffer g_animatedVertexCache < Attribute("AnimatedVertexCache"); SrgbRead(false); >;
	ExternalDescriptorSet g_globalLateBoundBindlessSet < Source(ExternalDescSet); Attribute("g_globalLateBoundBindlessSet"); >;
	StructuredBuffer g_instanceBuffer < Attribute("InstanceBuffer"); SrgbRead(false); >;
	ExternalDescriptorSet g_lightBinnerGpuSet < Source(ExternalDescSet); Attribute("g_lightBinnerGpuSet"); >;
	StructuredBuffer g_transformBuffer < Attribute("TransformBuffer"); SrgbRead(false); >;
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (5620 bytes), HLSL reflection with SPIRV-Cross by KhronosGroup
	
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
	
	struct _1612
	{
	    float4 _m0[3];
	};
	
	struct _1172
	{
	    _1612 _m0;
	};
	
	struct _113
	{
	    float4 _m0[4];
	};
	
	ByteAddressBuffer g_instanceBuffer : register(t32, space4);
	ByteAddressBuffer g_transformBuffer : register(t30, space4);
	cbuffer PerViewConstantBuffer_t : register(b1, space0)
	{
	    _113 PerViewConstantBuffer_t_1_m0 : packoffset(c0);
	    float4 PerViewConstantBuffer_t_1_m1 : packoffset(c24);
	};
	
	cbuffer PerViewConstantBufferCsgo_t : register(b3, space0)
	{
	    float4 PerViewConstantBufferCsgo_t_1_m0 : packoffset(c35);
	};
	
	
	static float4 gl_Position;
	static float3 vPositionOs;
	static float2 vTexCoord;
	static float3 vNormalOs;
	static uint4 vBlendIndices;
	static uint nInstanceIdx;
	static float3 output_0;
	static float3 output_1;
	static float4 output_2;
	static float4 output_3;
	static uint output_4;
	
	struct VS_INPUT
	{
	    float3 vPositionOs : TEXCOORD0;
	    float2 vTexCoord : TEXCOORD1;
	    float3 vNormalOs : TEXCOORD2;
	    uint4 vBlendIndices : TEXCOORD3;
	    uint nInstanceIdx : TEXCOORD4;
	};
	
	struct PS_INPUT
	{
	    float3 output_0 : TEXCOORD0;
	    float3 output_1 : TEXCOORD1;
	    float4 output_2 : TEXCOORD2;
	    centroid float4 output_3 : TEXCOORD3;
	    nointerpolation uint output_4 : TEXCOORD4;
	    float4 gl_Position : SV_Position;
	};
	
	void MainVs_inner()
	{
	    uint _13771 = (g_instanceBuffer.Load(nInstanceIdx * 32 + 20) >> uint(16)) & 15u;
	    uint _21785;
	    if (_13771 == 1u)
	    {
	        _21785 = g_instanceBuffer.Load(nInstanceIdx * 32 + 4) + (2u + vBlendIndices.x);
	    }
	    else
	    {
	        _21785 = g_instanceBuffer.Load(nInstanceIdx * 32 + 4);
	    }
	    _1612 _25207;
	    [unroll]
	    for (int _2ident = 0; _2ident < 3; _2ident++)
	    {
	        _25207._m0[_2ident] = asfloat(g_transformBuffer.Load4(_2ident * 16 + _21785 * 48 + 0));
	    }
	    float3x4 _17839 = float3x4(_25207._m0[0], _25207._m0[1], _25207._m0[2]);
	    float3 _21709;
	    if (_13771 > 0u)
	    {
	        _1612 _25208;
	        [unroll]
	        for (int _3ident = 0; _3ident < 3; _3ident++)
	        {
	            _25208._m0[_3ident] = asfloat(g_transformBuffer.Load4(_3ident * 16 + g_instanceBuffer.Load(nInstanceIdx * 32 + 4) * 48 + 0));
	        }
	        _21709 = _25208._m0[0].z.xxx;
	    }
	    else
	    {
	        _21709 = 1.0f.xxx;
	    }
	    float4 _23812 = float4(uint4((g_instanceBuffer.Load(nInstanceIdx * 32 + 0) & 255u), (g_instanceBuffer.Load(nInstanceIdx * 32 + 0) & 65280u) >> uint(8), (g_instanceBuffer.Load(nInstanceIdx * 32 + 0) & 16711680u) >> uint(16), (g_instanceBuffer.Load(nInstanceIdx * 32 + 0) & 4278190080u) >> uint(24))) * 0.0039215688593685626983642578125f.xxxx;
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
	    float _14124;
	    if (_23812.z <= 0.040449999272823333740234375f)
	    {
	        _14124 = _17828.z;
	    }
	    else
	    {
	        _14124 = _7676.z;
	    }
	    float _9851 = _23812.w;
	    float4 _20063 = float4(_21354, _21355, _14124, _9851);
	    _20063.w = _9851 * asfloat(g_instanceBuffer.Load(nInstanceIdx * 32 + 28));
	    float3 _12151 = mul(_17839, float4(vPositionOs.xyz * _21709.xyz, 1.0f));
	    float4 _23875 = mul(float4x4(float4(PerViewConstantBuffer_t_1_m0._m0[0].x, PerViewConstantBuffer_t_1_m0._m0[1].x, PerViewConstantBuffer_t_1_m0._m0[2].x, PerViewConstantBuffer_t_1_m0._m0[3].x), float4(PerViewConstantBuffer_t_1_m0._m0[0].y, PerViewConstantBuffer_t_1_m0._m0[1].y, PerViewConstantBuffer_t_1_m0._m0[2].y, PerViewConstantBuffer_t_1_m0._m0[3].y), float4(PerViewConstantBuffer_t_1_m0._m0[0].z, PerViewConstantBuffer_t_1_m0._m0[1].z, PerViewConstantBuffer_t_1_m0._m0[2].z, PerViewConstantBuffer_t_1_m0._m0[3].z), float4(PerViewConstantBuffer_t_1_m0._m0[0].w, PerViewConstantBuffer_t_1_m0._m0[1].w, PerViewConstantBuffer_t_1_m0._m0[2].w, PerViewConstantBuffer_t_1_m0._m0[3].w)), (float4(_12151.xyz, 1.0f) + (PerViewConstantBuffer_t_1_m1 * 1.0f)).xyzw);
	    output_0 = _12151.xyz - PerViewConstantBufferCsgo_t_1_m0.xyz;
	    output_1 = normalize(mul(_17839, float4(vNormalOs.xyz, 0.0f)));
	    output_2 = vTexCoord.xyxy;
	    output_3 = _20063;
	    output_4 = (g_instanceBuffer.Load(nInstanceIdx * 32 + 20)) & 65535u;
	    _23875.y = -_23875.y;
	    gl_Position = _23875;
	}
	
	PS_INPUT MainVs(VS_INPUT stage_input)
	{
	    vPositionOs = stage_input.vPositionOs;
	    vTexCoord = stage_input.vTexCoord;
	    vNormalOs = stage_input.vNormalOs;
	    vBlendIndices = stage_input.vBlendIndices;
	    nInstanceIdx = stage_input.nInstanceIdx;
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
	
	
	
	BoolAttribute(CanBatchWithDynamicShaderConstants, true);
	BoolAttribute(SupportsAggregateInstancing, true);
	
}

PS
{
	StaticCombo( S_MODE_TOOLS_VIS, 0..1 );
	
	cbuffer PerViewConstantBufferCsgo_t < Attribute("PerViewConstantBufferCsgo_t"); >;
	cbuffer PerViewConstantBuffer_t < Attribute("PerViewConstantBuffer_t"); >;
	bool g_bHighlightDeprecated < Attribute("g_bHighlightDeprecated"); UiType(CheckBox); >;
	bool g_bIsDeprecated < Attribute("bIsDeprecated"); UiType(CheckBox); >;
	float g_fToolsVisHeightTint < Default(0.9); Attribute("g_fToolsVisHeightTint"); UiType(Slider); >;
	float g_fToolsVisMaxHeightRange < Default(1); Attribute("g_fToolsVisMaxHeightRange"); UiType(Slider); >;
	ExternalDescriptorSet g_globalLateBoundBindlessSet < Source(ExternalDescSet); Attribute("g_globalLateBoundBindlessSet"); >;
	ExternalDescriptorSet g_lightBinnerGpuSet < Source(ExternalDescSet); Attribute("g_lightBinnerGpuSet"); >;
	int g_nToolsVisMode < Attribute("g_nToolsVisMode"); UiType(Slider); >;
	TextureCube g_tFogCubeTexture < Attribute("CubemapFogTexture"); SrgbRead(true); >;
	float3 g_vFlatOverlayColor < Default2(1, 0); Attribute("FlatOverlayColor"); UiType(VectorText); >;
	float4 g_vShaderIDColor < Source(ShaderIDColor); UiType(VectorText); >;
	
	// Fog
	bool g_bFogEnabled < Default(1); UiType(CheckBox); UiGroup("Fog"); >;
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (5560 bytes), HLSL reflection with SPIRV-Cross by KhronosGroup
	
	struct _1444
	{
	    float4 _m0[4];
	};
	
	cbuffer PerViewConstantBufferCsgo_t : register(b3, space1)
	{
	    float4 PerViewConstantBufferCsgo_t_1_m0 : packoffset(c23);
	    float4 PerViewConstantBufferCsgo_t_1_m1 : packoffset(c24);
	    float4 PerViewConstantBufferCsgo_t_1_m2 : packoffset(c25);
	    float4 PerViewConstantBufferCsgo_t_1_m3 : packoffset(c26);
	    float4 PerViewConstantBufferCsgo_t_1_m4 : packoffset(c27);
	    float4 PerViewConstantBufferCsgo_t_1_m5 : packoffset(c28);
	    _1444 PerViewConstantBufferCsgo_t_1_m6 : packoffset(c29);
	    float4 PerViewConstantBufferCsgo_t_1_m7 : packoffset(c33);
	    float4 PerViewConstantBufferCsgo_t_1_m8 : packoffset(c34);
	    float4 PerViewConstantBufferCsgo_t_1_m9 : packoffset(c35);
	};
	
	cbuffer _Globals_ : register(b0, space1)
	{
	    int _Globals_1_g_bFogEnabled : packoffset(c0.z);
	};
	
	cbuffer PerViewConstantBuffer_t : register(b1, space1)
	{
	    float3 PerViewConstantBuffer_t_1_m0 : packoffset(c26);
	};
	
	TextureCube<float4> g_tFogCubeTexture : register(t42, space1);
	SamplerState g_sTrilinearClamp : register(s17, space1);
	
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
	    float3 _10061 = input_0 + PerViewConstantBufferCsgo_t_1_m9.xyz;
	    float4 _6805;
	    if (_Globals_1_g_bFogEnabled != 0)
	    {
	        float3 _21493;
	        float3 _13858 = _10061.xyz - PerViewConstantBuffer_t_1_m0.xyz;
	        float3 _10784 = _13858.xyz;
	        float3 _19340;
	        do
	        {
	            _21493 = _13858.xyz;
	            bool _12885;
	            if (dot(_21493, _21493) > PerViewConstantBufferCsgo_t_1_m3.x)
	            {
	                _12885 = (_10061.z * PerViewConstantBufferCsgo_t_1_m3.z) < PerViewConstantBufferCsgo_t_1_m3.y;
	            }
	            else
	            {
	                _12885 = false;
	            }
	            if (_12885)
	            {
	                float2 _9342 = clamp(PerViewConstantBufferCsgo_t_1_m0.xy + (PerViewConstantBufferCsgo_t_1_m0.zw * float2(length(_21493), _10061.z)), 0.0f.xx, 1.0f.xx);
	                float _12872 = (pow(_9342.x, PerViewConstantBufferCsgo_t_1_m1.x) * pow(_9342.y, PerViewConstantBufferCsgo_t_1_m1.y)) * PerViewConstantBufferCsgo_t_1_m2.w;
	                _19340 = lerp(0.0f.xxx, float4(PerViewConstantBufferCsgo_t_1_m2.xyz, _12872).xyz, _12872.xxx);
	                break;
	            }
	            _19340 = 0.0f.xxx;
	            break;
	        } while(false);
	        float4 _23944 = float4(0.0f, 0.0f, 0.0f, 1.0f);
	        _23944.x = _19340.x;
	        _23944.y = _19340.y;
	        _23944.z = _19340.z;
	        float3 _19341;
	        do
	        {
	            bool _12886;
	            if (dot(_10784, _10784) > PerViewConstantBufferCsgo_t_1_m7.x)
	            {
	                _12886 = (PerViewConstantBufferCsgo_t_1_m7.z * _10061.z) < PerViewConstantBufferCsgo_t_1_m7.y;
	            }
	            else
	            {
	                _12886 = false;
	            }
	            if (_12886)
	            {
	                float _14602 = clamp(pow(max(0.0f, (length(_21493) * PerViewConstantBufferCsgo_t_1_m4.y) + PerViewConstantBufferCsgo_t_1_m4.x), PerViewConstantBufferCsgo_t_1_m4.w), 0.0f, 1.0f) * clamp(pow(max(0.0f, (_10061.z * PerViewConstantBufferCsgo_t_1_m5.y) + PerViewConstantBufferCsgo_t_1_m5.x), PerViewConstantBufferCsgo_t_1_m5.z), 0.0f, 1.0f);
	                float _8892 = clamp(_14602, 0.0f, 1.0f) * PerViewConstantBufferCsgo_t_1_m7.w;
	                _19341 = lerp(_23944.xyz, float4((g_tFogCubeTexture.SampleLevel(g_sTrilinearClamp, normalize(mul(float4(_10784, 0.0f), float4x4(float4(PerViewConstantBufferCsgo_t_1_m6._m0[0].x, PerViewConstantBufferCsgo_t_1_m6._m0[1].x, PerViewConstantBufferCsgo_t_1_m6._m0[2].x, PerViewConstantBufferCsgo_t_1_m6._m0[3].x), float4(PerViewConstantBufferCsgo_t_1_m6._m0[0].y, PerViewConstantBufferCsgo_t_1_m6._m0[1].y, PerViewConstantBufferCsgo_t_1_m6._m0[2].y, PerViewConstantBufferCsgo_t_1_m6._m0[3].y), float4(PerViewConstantBufferCsgo_t_1_m6._m0[0].z, PerViewConstantBufferCsgo_t_1_m6._m0[1].z, PerViewConstantBufferCsgo_t_1_m6._m0[2].z, PerViewConstantBufferCsgo_t_1_m6._m0[3].z), float4(PerViewConstantBufferCsgo_t_1_m6._m0[0].w, PerViewConstantBufferCsgo_t_1_m6._m0[1].w, PerViewConstantBufferCsgo_t_1_m6._m0[2].w, PerViewConstantBufferCsgo_t_1_m6._m0[3].w))).xyz).xyz, PerViewConstantBufferCsgo_t_1_m5.w * clamp(1.0f - (_14602 * PerViewConstantBufferCsgo_t_1_m4.z), 0.0f, 1.0f)) * PerViewConstantBufferCsgo_t_1_m8.x).xyz, _8892).xyz, _8892.xxx);
	                break;
	            }
	            _19341 = _23944.xyz;
	            break;
	        } while(false);
	        _23944.x = _19341.x;
	        _23944.y = _19341.y;
	        _23944.z = _19341.z;
	        _6805 = _23944;
	    }
	    else
	    {
	        _6805 = float4(0.0f, 0.0f, 0.0f, 1.0f);
	    }
	    output_0 = _6805;
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
	
	
	
	BoolAttribute(unlit, true);
	
	
	// PSRS
	
	RenderState(BackStencilFunc, F_RENDER_BACKFACES ? 5 : 7);
	RenderState(CullMode, F_RENDER_BACKFACES ? None : Front);
	RenderState(CullMode, F_RENDER_BACKFACES ? None : Back);
	RenderState(DepthEnable, F_DISABLE_Z_BUFFERING ? False : True);
	RenderState(DepthWriteEnable, F_DISABLE_Z_BUFFERING ? False : True);
	RenderState(StencilEnable, 1);
	RenderState(StencilFunc, 5);
	RenderState(StencilReadMask, 1);
	RenderState(StencilRef, 3);
	RenderState(StencilWriteMask, 254);
	
}
