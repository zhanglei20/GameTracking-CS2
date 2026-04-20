//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "Wireframe for tools";
	DevShader = true;
	Version = 0;
	
	// VcsVersion: 70
	// Platform: VULKAN_SM_40
	// Programs: gs, ps, vs
}

MODES
{
	Default();
	Depth(S_MODE_DEPTH);
	ToolsUtil();
	VrForward();
	ToolsVis();
}

FEATURES
{
	Feature( F_ALPHA_TEST, 0..1, "" );
	Feature( F_TRANSLUCENT, 0..1, "" );
	Feature( F_WIREFRAME, 0..1, "" );
	Feature( F_NO_ZTEST, 0..1, "" );
	Feature( F_NO_CULLING, 0..1, "" );
}

COMMON
{
	#include "system.fxc"
}

struct VS_INPUT
{
	float4 vBlendIndices       : BLENDINDICES0  < Semantic( BlendIndices ); >;                     // D_BLEND_WEIGHT_COUNT=1, D_BLEND_WEIGHT_COUNT=2, D_BLEND_WEIGHT_COUNT=3, D_BLEND_WEIGHT_COUNT=4
	float4 vBlendWeight        : BLENDWEIGHT0   < Semantic( BlendWeight ); >;                      // D_BLEND_WEIGHT_COUNT=2, D_BLEND_WEIGHT_COUNT=3, D_BLEND_WEIGHT_COUNT=4
	float4 vColor              : COLOR0         < Semantic( Color ); >;                           
	float4 vNormalOs           : NORMAL0        < Semantic( Normal ); >;                          
	float3 vPositionOs         : POSITION0      < Semantic( PosXyz ); >;                          
	float2 vFirstLineVertPosWs : TEXCOORD0      < Semantic( uvw ); >;                              // D_THICK_LINES=0, D_FREEFORM_DEFORMATION=1, S_MOBILE=1
	float2 nInstanceIdx        : TEXCOORD13     < Semantic( InstanceTransformUv ); >;             
};

VS
{
	StaticCombo( S_MODE_DEPTH, 0..1 );
	StaticCombo( S_MOBILE, 0..1 );
	DynamicCombo( D_BLEND_WEIGHT_COUNT, 0..4 );
	DynamicCombo( D_DEPTH_BIAS, 0..1 );
	DynamicCombo( D_SNAP_TO_SCREEN_PIXELS, 0..1 );
	DynamicCombo( D_THICK_LINES, 0..1 );
	DynamicCombo( D_FREEFORM_DEFORMATION, 0..1 );
	DynamicComboRule( Allow1( D_THICK_LINES, D_SNAP_TO_SCREEN_PIXELS ) );
	
	cbuffer FFDTransforms_t < Attribute("FFDTransforms_t"); >;
	cbuffer PerViewConstantBuffer_t < Attribute("PerViewConstantBuffer_t"); >;
	bool g_bIgnoreTintAlpha < Attribute("IgnoreTintAlpha"); UiType(CheckBox); >;
	float g_flDynamicLineThickness < Default(1); Attribute("DynamicLineThickness"); UiType(Slider); >;
	StructuredBuffer g_instanceBuffer < Attribute("InstanceBuffer"); SrgbRead(false); >;
	StructuredBuffer g_transformBuffer < Attribute("TransformBuffer"); SrgbRead(false); >;
	
	// Depth Bias Amount
	float g_DepthBiasAmount < Default(0.005); UiType(Slider); UiGroup("Depth Bias Amount"); >;
	
	// Line Thickness
	float g_LineThickness < Default(1); Range(0, 8); UiType(Slider); UiGroup("Line Thickness"); >;
	
	// Override Color
	float g_OverrideColorFactor < UiType(Slider); UiGroup("Override Color"); >;
	float4 g_vOverrideColor < Default(0); UiType(Color); UiGroup("Override Color"); Expression(SrgbGammaToLinear(this)); >;
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (6176 bytes), HLSL reflection with SPIRV-Cross by KhronosGroup
	
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
	
	struct _1360
	{
	    float4 _m0[3];
	};
	
	struct _668
	{
	    _1360 _m0;
	};
	
	struct _1486
	{
	    float4 _m0[4];
	};
	
	ByteAddressBuffer g_instanceBuffer : register(t32, space0);
	ByteAddressBuffer g_transformBuffer : register(t30, space0);
	cbuffer PerViewConstantBuffer_t : register(b1, space0)
	{
	    _1486 PerViewConstantBuffer_t_1_m0 : packoffset(c0);
	    float4 PerViewConstantBuffer_t_1_m1 : packoffset(c24);
	};
	
	cbuffer _Globals_ : register(b0, space0)
	{
	    float4 _Globals_1_g_vOverrideColor : packoffset(c0);
	    float _Globals_1_g_OverrideColorFactor : packoffset(c1);
	    int _Globals_1_g_bIgnoreTintAlpha : packoffset(c2);
	};
	
	
	static float4 gl_Position;
	static float3 vPositionOs;
	static float3 vColor;
	static float3 vNormalOs;
	static float4 nInstanceIdx;
	static uint vFirstLineVertPosWs;
	static float3 output_0;
	static float4 output_1;
	static float4 output_2;
	static float4 output_3;
	static float3 output_4;
	
	struct VS_INPUT
	{
	    float3 vPositionOs : TEXCOORD0;
	    float3 vColor : TEXCOORD1;
	    float3 vNormalOs : TEXCOORD2;
	    float4 nInstanceIdx : TEXCOORD3;
	    uint vFirstLineVertPosWs : TEXCOORD4;
	};
	
	struct PS_INPUT
	{
	    float3 output_0 : TEXCOORD0;
	    float4 output_1 : TEXCOORD1;
	    float4 output_2 : TEXCOORD2;
	    float4 output_3 : TEXCOORD3;
	    float3 output_4 : TEXCOORD4;
	    float4 gl_Position : SV_Position;
	};
	
	void MainVs_inner()
	{
	    _1360 _25207;
	    [unroll]
	    for (int _1ident = 0; _1ident < 3; _1ident++)
	    {
	        _25207._m0[_1ident] = asfloat(g_transformBuffer.Load4(_1ident * 16 + g_instanceBuffer.Load(vFirstLineVertPosWs * 32 + 4) * 48 + 0));
	    }
	    float3x4 _14779 = float3x4(_25207._m0[0], _25207._m0[1], _25207._m0[2]);
	    float3 _23070 = mul(_14779, float4(vPositionOs.xyz, 1.0f));
	    float4 _21447 = PerViewConstantBuffer_t_1_m1 * 1.0f;
	    float4x4 _15571 = float4x4(float4(PerViewConstantBuffer_t_1_m0._m0[0].x, PerViewConstantBuffer_t_1_m0._m0[1].x, PerViewConstantBuffer_t_1_m0._m0[2].x, PerViewConstantBuffer_t_1_m0._m0[3].x), float4(PerViewConstantBuffer_t_1_m0._m0[0].y, PerViewConstantBuffer_t_1_m0._m0[1].y, PerViewConstantBuffer_t_1_m0._m0[2].y, PerViewConstantBuffer_t_1_m0._m0[3].y), float4(PerViewConstantBuffer_t_1_m0._m0[0].z, PerViewConstantBuffer_t_1_m0._m0[1].z, PerViewConstantBuffer_t_1_m0._m0[2].z, PerViewConstantBuffer_t_1_m0._m0[3].z), float4(PerViewConstantBuffer_t_1_m0._m0[0].w, PerViewConstantBuffer_t_1_m0._m0[1].w, PerViewConstantBuffer_t_1_m0._m0[2].w, PerViewConstantBuffer_t_1_m0._m0[3].w));
	    float4 _23875 = mul(_15571, (float4(_23070.xyz, 1.0f) + _21447).xyzw);
	    float3 _24030 = nInstanceIdx.xyz * 0.077399380505084991455078125f.xxx;
	    float3 _7676 = pow((nInstanceIdx.xyz * 0.947867333889007568359375f.xxx) + 0.052132703363895416259765625f.xxx, 2.400000095367431640625f.xxx);
	    float _21354;
	    if (nInstanceIdx.x <= 0.040449999272823333740234375f)
	    {
	        _21354 = _24030.x;
	    }
	    else
	    {
	        _21354 = _7676.x;
	    }
	    float _21355;
	    if (nInstanceIdx.y <= 0.040449999272823333740234375f)
	    {
	        _21355 = _24030.y;
	    }
	    else
	    {
	        _21355 = _7676.y;
	    }
	    float _19302;
	    if (nInstanceIdx.z <= 0.040449999272823333740234375f)
	    {
	        _19302 = _24030.z;
	    }
	    else
	    {
	        _19302 = _7676.z;
	    }
	    float4 _23628 = float4(_21354, _21355, _19302, nInstanceIdx.w);
	    float4 _23812 = float4(uint4((g_instanceBuffer.Load(vFirstLineVertPosWs * 32 + 0) & 255u), (g_instanceBuffer.Load(vFirstLineVertPosWs * 32 + 0) & 65280u) >> uint(8), (g_instanceBuffer.Load(vFirstLineVertPosWs * 32 + 0) & 16711680u) >> uint(16), (g_instanceBuffer.Load(vFirstLineVertPosWs * 32 + 0) & 4278190080u) >> uint(24))) * 0.0039215688593685626983642578125f.xxxx;
	    float3 _6253 = _23812.xyz;
	    float3 _17828 = _6253 * 0.077399380505084991455078125f.xxx;
	    float3 _7677 = pow((_6253 * 0.947867333889007568359375f.xxx) + 0.052132703363895416259765625f.xxx, 2.400000095367431640625f.xxx);
	    float _21356;
	    if (_23812.x <= 0.040449999272823333740234375f)
	    {
	        _21356 = _17828.x;
	    }
	    else
	    {
	        _21356 = _7677.x;
	    }
	    float _21357;
	    if (_23812.y <= 0.040449999272823333740234375f)
	    {
	        _21357 = _17828.y;
	    }
	    else
	    {
	        _21357 = _7677.y;
	    }
	    float _19167;
	    if (_23812.z <= 0.040449999272823333740234375f)
	    {
	        _19167 = _17828.z;
	    }
	    else
	    {
	        _19167 = _7677.z;
	    }
	    _23812.x = _21356;
	    _23812.y = _21357;
	    _23812.z = _19167;
	    float4 _21709;
	    if (_Globals_1_g_bIgnoreTintAlpha != 0)
	    {
	        float3 _15408 = _23628.xyz * abs(_23812.xyz);
	        float4 _23714 = _23628;
	        _23714.x = _15408.x;
	        _23714.y = _15408.y;
	        _23714.z = _15408.z;
	        _21709 = _23714;
	    }
	    else
	    {
	        _21709 = _23628 * abs(_23812);
	    }
	    output_0 = normalize(mul(_14779, float4(vColor.xyz, 0.0f)).xyz);
	    output_1 = lerp(_21709, _Globals_1_g_vOverrideColor, _Globals_1_g_OverrideColorFactor.xxxx);
	    output_2 = mul(_15571, (float4(mul(_14779, float4(vNormalOs, 1.0f)).xyz, 1.0f) + _21447).xyzw);
	    output_3 = _23875;
	    output_4 = _23070;
	    _23875.y = -_23875.y;
	    gl_Position = _23875;
	}
	
	PS_INPUT MainVs(VS_INPUT stage_input)
	{
	    vPositionOs = stage_input.vPositionOs;
	    vColor = stage_input.vColor;
	    vNormalOs = stage_input.vNormalOs;
	    nInstanceIdx = stage_input.nInstanceIdx;
	    vFirstLineVertPosWs = stage_input.vFirstLineVertPosWs;
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
	
	
}

GS
{
	StaticCombo( S_MODE_DEPTH, 0..1 );
	StaticCombo( S_MOBILE, 0..1 );
	DynamicCombo( D_THICK_LINES, 0..1 );
	DynamicCombo( D_DEPTH_BIAS, 0..1 );
	
	cbuffer PerViewConstantBuffer_t < Attribute("PerViewConstantBuffer_t"); >;
	
	// Depth Bias Amount
	float g_DepthBiasAmount < Default(0.005); UiType(Slider); UiGroup("Depth Bias Amount"); >;
	
	// SPIR-V reflection failed for backend HLSL:
	// Unsupported shader stage.
	// 
	// Re-attempting reflection with the GLSL backend.
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (4136 bytes), GLSL reflection with SPIRV-Cross by KhronosGroup
	// Dynamic combos: D_THICK_LINES
	
	#version 460
	layout(lines) in;
	layout(max_vertices = 4, triangle_strip) out;
	
	struct _1864
	{
	    vec4 _m0[4];
	};
	
	struct _1793
	{
	    _1864 _m0;
	    vec2 _m1;
	    vec4 _m2;
	};
	
	layout(set = 2) uniform _1793 PerViewConstantBuffer_t;
	
	layout(location = 0) in vec3 input_0[2];
	layout(location = 1) in vec3 input_1[2];
	layout(location = 2) in float input_2[2];
	layout(location = 3) in vec4 input_3[2];
	layout(location = 0) out vec3 output_0;
	layout(location = 1) out vec4 output_1;
	layout(location = 2) out vec4 output_2;
	layout(location = 3) out vec4 output_3;
	layout(location = 4) out vec3 output_4;
	
	void main()
	{
	    vec4 _21447 = PerViewConstantBuffer_t._m2 * 1.0;
	    mat4 _15571 = mat4(vec4(PerViewConstantBuffer_t._m0._m0[0].x, PerViewConstantBuffer_t._m0._m0[1].x, PerViewConstantBuffer_t._m0._m0[2].x, PerViewConstantBuffer_t._m0._m0[3].x), vec4(PerViewConstantBuffer_t._m0._m0[0].y, PerViewConstantBuffer_t._m0._m0[1].y, PerViewConstantBuffer_t._m0._m0[2].y, PerViewConstantBuffer_t._m0._m0[3].y), vec4(PerViewConstantBuffer_t._m0._m0[0].z, PerViewConstantBuffer_t._m0._m0[1].z, PerViewConstantBuffer_t._m0._m0[2].z, PerViewConstantBuffer_t._m0._m0[3].z), vec4(PerViewConstantBuffer_t._m0._m0[0].w, PerViewConstantBuffer_t._m0._m0[1].w, PerViewConstantBuffer_t._m0._m0[2].w, PerViewConstantBuffer_t._m0._m0[3].w));
	    vec4 _24240 = (vec4(input_0[0].xyz, 1.0) + _21447).xyzw * _15571;
	    vec4 _9193 = (vec4(input_0[1].xyz, 1.0) + _21447).xyzw * _15571;
	    vec2 _13645 = _9193.xy;
	    float _20176 = _9193.w;
	    vec2 _7058 = _24240.xy;
	    float _20181 = _24240.w;
	    vec2 _25108 = PerViewConstantBuffer_t._m1.xy * 2.0;
	    float _14436 = _24240.z;
	    vec2 _19809 = (normalize(vec2(1.0, -1.0) * (((_13645 / vec2(_20176)) - (_7058 / vec2(_20181))).xy / _25108).yx).xy * _25108).xy;
	    vec2 _13861 = _7058 + ((_19809 * input_2[0]) * _20181);
	    float _9979 = _13861.x;
	    vec4 _20450 = _24240;
	    _20450.x = _9979;
	    output_0 = input_1[0];
	    output_1 = input_3[0];
	    output_2 = _24240;
	    output_3 = vec4(_9979, _13861.y, _14436, _20181);
	    output_4 = input_0[0];
	    _20450.y = -_13861.y;
	    gl_Position = _20450;
	    EmitVertex();
	    float _14689 = _9193.z;
	    vec2 _13862 = _13645 + ((_19809 * input_2[1]) * _20176);
	    float _9980 = _13862.x;
	    vec4 _20451 = _9193;
	    _20451.x = _9980;
	    output_0 = input_1[1];
	    output_1 = input_3[1];
	    output_2 = _24240;
	    output_3 = vec4(_9980, _13862.y, _14689, _20176);
	    output_4 = input_0[1];
	    _20451.y = -_13862.y;
	    gl_Position = _20451;
	    EmitVertex();
	    vec2 _13863 = _7058 + ((_19809 * ((-1.0) * input_2[0])) * _20181);
	    float _9981 = _13863.x;
	    vec4 _20452 = _24240;
	    _20452.x = _9981;
	    output_0 = input_1[0];
	    output_1 = input_3[0];
	    output_2 = _24240;
	    output_3 = vec4(_9981, _13863.y, _14436, _20181);
	    output_4 = input_0[0];
	    _20452.y = -_13863.y;
	    gl_Position = _20452;
	    EmitVertex();
	    vec2 _13864 = _13645 + ((_19809 * ((-1.0) * input_2[1])) * _20176);
	    float _9982 = _13864.x;
	    vec4 _20453 = _9193;
	    _20453.x = _9982;
	    output_0 = input_1[1];
	    output_1 = input_3[1];
	    output_2 = _24240;
	    output_3 = vec4(_9982, _13864.y, _14689, _20176);
	    output_4 = input_0[1];
	    _20453.y = -_13864.y;
	    gl_Position = _20453;
	    EmitVertex();
	    EndPrimitive();
	}
	
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
}

PS
{
	StaticCombo( S_MODE_DEPTH, 0..1 );
	StaticCombo( S_ALPHA_TEST, F_ALPHA_TEST );
	StaticCombo( S_NO_ZTEST, F_NO_ZTEST );
	StaticCombo( S_TRANSLUCENT, F_TRANSLUCENT );
	StaticComboRule( Allow1( S_MODE_DEPTH, S_TRANSLUCENT ) );
	DynamicCombo( D_NO_ZTEST, 0..1 );
	DynamicCombo( D_NO_CULLING, 0..1 );
	DynamicCombo( D_THICK_LINES, 0..1 );
	DynamicCombo( D_SHADED, 0..1 );
	DynamicComboRule( Allow1( S_MODE_DEPTH, D_SHADED ) );
	
	RenderState(CullMode, None);
	RenderState(CullMode, (((None ? Back : F_WIREFRAME) ? Back : F_NO_CULLING) ? Back : None) ? None : Back);
	RenderState(CullMode, (((None ? Back : F_WIREFRAME) ? Back : F_NO_CULLING) ? Back : Back) ? None : Back);
	RenderState(FillMode, F_WIREFRAME ? Wireframe : Solid);
	cbuffer PerViewConstantBuffer_t < Attribute("PerViewConstantBuffer_t"); >;
	float g_flAlphaTestReference < Default(0.3); Range(0.01, 0.99); UiType(Slider); >;
	float g_flPatternType < Attribute("PatternType"); UiType(Slider); >;
	
	#if (S_ALPHA_TEST == 1)
		RenderState(CullMode, None);
	#endif
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (1712 bytes), HLSL reflection with SPIRV-Cross by KhronosGroup
	
	cbuffer _Globals_ : register(b0, space1)
	{
	    float _Globals_1_g_flPatternType : packoffset(c0.w);
	};
	
	cbuffer PerViewConstantBuffer_t : register(b1, space1)
	{
	    float2 PerViewConstantBuffer_t_1_m0 : packoffset(c21);
	};
	
	
	static float4 input_0;
	static float4 input_1;
	static float4 input_2;
	static float4 output_0;
	
	struct PS_INPUT
	{
	    float4 input_0 : TEXCOORD1;
	    float4 input_1 : TEXCOORD2;
	    float4 input_2 : TEXCOORD3;
	};
	
	struct PS_OUTPUT
	{
	    float4 output_0 : SV_Target0;
	};
	
	void MainPs_inner()
	{
	    bool _12885;
	    do
	    {
	        float _19321;
	        if (_Globals_1_g_flPatternType == 1.0f)
	        {
	            _19321 = 16.0f;
	        }
	        else
	        {
	            _19321 = (_Globals_1_g_flPatternType == 2.0f) ? 3.0f : 0.0f;
	        }
	        if (_19321 != 0.0f)
	        {
	            _12885 = fmod(length(float2((input_2.x / input_2.w) / PerViewConstantBuffer_t_1_m0.x, (input_2.y / input_2.w) / PerViewConstantBuffer_t_1_m0.y) - float2((input_1.x / input_1.w) / PerViewConstantBuffer_t_1_m0.x, (input_1.y / input_1.w) / PerViewConstantBuffer_t_1_m0.y)), _19321 * 2.0f) > _19321;
	            break;
	        }
	        _12885 = false;
	        break;
	    } while(false);
	    if (_12885)
	    {
	        discard;
	    }
	    output_0 = input_0;
	}
	
	PS_OUTPUT MainPs(PS_INPUT stage_input)
	{
	    input_0 = stage_input.input_0;
	    input_1 = stage_input.input_1;
	    input_2 = stage_input.input_2;
	    MainPs_inner();
	    PS_OUTPUT stage_output;
	    stage_output.output_0 = output_0;
	    return stage_output;
	}
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
}
