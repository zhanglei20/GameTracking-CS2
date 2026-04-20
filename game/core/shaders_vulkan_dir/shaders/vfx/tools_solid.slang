//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "Solid/stripes/checkerboard for tools";
	DevShader = true;
	Version = 0;
	
	// VcsVersion: 70
	// Platform: VULKAN_SM_40
	// Programs: ps, vs
}

MODES
{
	Default();
	ToolsUtil();
}

FEATURES
{
	Feature( F_ALPHA_TEST, 0..1, "" );
	Feature( F_PHONG, 0..1, "" );
	Feature( F_UNLIT, 0..1, "" );
	Feature( F_TRANSLUCENT, 0..1, "" );
	Feature( F_NO_ZTEST, 0..1, "" );
	Feature( F_NO_CULLING, 0..1, "" );
	Feature( F_WIREFRAME, 0..1, "" );
}

COMMON
{
	#include "system.fxc"
}

struct VS_INPUT
{
	float4 vBlendIndices : BLENDINDICES0  < Semantic( BlendIndices ); >;                          
	float4 vBlendWeight  : BLENDWEIGHT0   < Semantic( BlendWeight ); >;                           
	float4 vColor        : COLOR0         < Semantic( Color ); >;                                 
	float4 vNormalOs     : NORMAL0        < Semantic( Normal ); >;                                
	float3 vPositionOs   : POSITION0      < Semantic( PosXyz ); >;                                
	float2 nInstanceIdx  : TEXCOORD13     < Semantic( InstanceTransformUv ); >;                   
};

VS
{
	DynamicCombo( D_BLEND_WEIGHT_COUNT, 0..4 );
	DynamicCombo( D_DEPTH_BIAS, 0..1 );
	DynamicCombo( D_SNAP_TO_SCREEN_PIXELS, 0..1 );
	
	cbuffer PerViewConstantBuffer_t < Attribute("PerViewConstantBuffer_t"); >;
	bool g_bIgnoreTintAlpha < Attribute("IgnoreTintAlpha"); UiType(CheckBox); >;
	StructuredBuffer g_instanceBuffer < Attribute("InstanceBuffer"); SrgbRead(false); >;
	StructuredBuffer g_transformBuffer < Attribute("TransformBuffer"); SrgbRead(false); >;
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (4968 bytes), HLSL reflection with SPIRV-Cross by KhronosGroup
	
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
	
	struct _1192
	{
	    float4 _m0[3];
	};
	
	struct _332
	{
	    _1192 _m0;
	};
	
	struct _1318
	{
	    float4 _m0[4];
	};
	
	ByteAddressBuffer g_instanceBuffer : register(t32, space0);
	ByteAddressBuffer g_transformBuffer : register(t30, space0);
	cbuffer PerViewConstantBuffer_t : register(b1, space0)
	{
	    _1318 PerViewConstantBuffer_t_1_m0 : packoffset(c0);
	    float4 PerViewConstantBuffer_t_1_m1 : packoffset(c24);
	};
	
	cbuffer _Globals_ : register(b0, space0)
	{
	    int _Globals_1_g_bIgnoreTintAlpha : packoffset(c0);
	};
	
	
	static float4 gl_Position;
	static float3 vPositionOs;
	static float3 vColor;
	static float4 vNormalOs;
	static uint nInstanceIdx;
	static float3 output_0;
	static float4 output_1;
	static float4 output_2;
	static float3 output_3;
	
	struct VS_INPUT
	{
	    float3 vPositionOs : TEXCOORD0;
	    float3 vColor : TEXCOORD1;
	    float4 vNormalOs : TEXCOORD2;
	    uint nInstanceIdx : TEXCOORD3;
	};
	
	struct PS_INPUT
	{
	    float3 output_0 : TEXCOORD0;
	    float4 output_1 : TEXCOORD1;
	    float4 output_2 : TEXCOORD2;
	    float3 output_3 : TEXCOORD3;
	    float4 gl_Position : SV_Position;
	};
	
	void MainVs_inner()
	{
	    _1192 _25207;
	    [unroll]
	    for (int _1ident = 0; _1ident < 3; _1ident++)
	    {
	        _25207._m0[_1ident] = asfloat(g_transformBuffer.Load4(_1ident * 16 + g_instanceBuffer.Load(nInstanceIdx * 32 + 4) * 48 + 0));
	    }
	    float3x4 _14779 = float3x4(_25207._m0[0], _25207._m0[1], _25207._m0[2]);
	    float3 _23051 = mul(_14779, float4(vPositionOs.xyz, 1.0f));
	    float4 _23533 = mul(float4x4(float4(PerViewConstantBuffer_t_1_m0._m0[0].x, PerViewConstantBuffer_t_1_m0._m0[1].x, PerViewConstantBuffer_t_1_m0._m0[2].x, PerViewConstantBuffer_t_1_m0._m0[3].x), float4(PerViewConstantBuffer_t_1_m0._m0[0].y, PerViewConstantBuffer_t_1_m0._m0[1].y, PerViewConstantBuffer_t_1_m0._m0[2].y, PerViewConstantBuffer_t_1_m0._m0[3].y), float4(PerViewConstantBuffer_t_1_m0._m0[0].z, PerViewConstantBuffer_t_1_m0._m0[1].z, PerViewConstantBuffer_t_1_m0._m0[2].z, PerViewConstantBuffer_t_1_m0._m0[3].z), float4(PerViewConstantBuffer_t_1_m0._m0[0].w, PerViewConstantBuffer_t_1_m0._m0[1].w, PerViewConstantBuffer_t_1_m0._m0[2].w, PerViewConstantBuffer_t_1_m0._m0[3].w)), (float4(_23051.xyz, 1.0f) + (PerViewConstantBuffer_t_1_m1 * 1.0f)).xyzw);
	    float4 _13069 = vNormalOs;
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
	    float _19167;
	    if (_23812.z <= 0.040449999272823333740234375f)
	    {
	        _19167 = _17828.z;
	    }
	    else
	    {
	        _19167 = _7676.z;
	    }
	    _23812.x = _21354;
	    _23812.y = _21355;
	    _23812.z = _19167;
	    float4 _22252;
	    if (_Globals_1_g_bIgnoreTintAlpha != 0)
	    {
	        float3 _15408 = _13069.xyz * abs(_23812.xyz);
	        float4 _23714 = _13069;
	        _23714.x = _15408.x;
	        _23714.y = _15408.y;
	        _23714.z = _15408.z;
	        _22252 = _23714;
	    }
	    else
	    {
	        _22252 = _13069 * abs(_23812);
	    }
	    output_0 = normalize(mul(_14779, float4(vColor.xyz, 0.0f)));
	    output_1 = _22252;
	    output_2 = _23533;
	    output_3 = _23051;
	    _23533.y = -_23533.y;
	    gl_Position = _23533;
	}
	
	PS_INPUT MainVs(VS_INPUT stage_input)
	{
	    vPositionOs = stage_input.vPositionOs;
	    vColor = stage_input.vColor;
	    vNormalOs = stage_input.vNormalOs;
	    nInstanceIdx = stage_input.nInstanceIdx;
	    MainVs_inner();
	    PS_INPUT stage_output;
	    stage_output.gl_Position = gl_Position;
	    stage_output.output_0 = output_0;
	    stage_output.output_1 = output_1;
	    stage_output.output_2 = output_2;
	    stage_output.output_3 = output_3;
	    return stage_output;
	}
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
}

PS
{
	StaticCombo( S_ALPHA_TEST, F_ALPHA_TEST );
	StaticCombo( S_PHONG, F_PHONG );
	StaticCombo( S_UNLIT, F_UNLIT );
	StaticCombo( S_TRANSLUCENT, F_TRANSLUCENT );
	StaticCombo( S_NO_ZTEST, F_NO_ZTEST );
	StaticCombo( S_NO_CULLING, F_NO_CULLING );
	DynamicCombo( D_NO_ZTEST, 0..1 );
	
	RenderState(CullMode, None);
	RenderState(FillMode, F_WIREFRAME ? Wireframe : Solid);
	cbuffer PerViewConstantBuffer_t < Attribute("PerViewConstantBuffer_t"); >;
	RenderState(StencilRef, 1);
	float g_flAlphaTestReference < Default(0.3); Range(0.01, 0.99); UiType(Slider); >;
	float g_flPatternType < Attribute("PatternType"); UiType(Slider); >;
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (2360 bytes), HLSL reflection with SPIRV-Cross by KhronosGroup
	
	static float2 _2;
	
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
	static float4 output_0;
	
	struct PS_INPUT
	{
	    float4 input_0 : TEXCOORD1;
	    float4 input_1 : TEXCOORD2;
	};
	
	struct PS_OUTPUT
	{
	    float4 output_0 : SV_Target0;
	};
	
	void MainPs_inner()
	{
	    bool _11267;
	    do
	    {
	        bool _17421 = _Globals_1_g_flPatternType == 1.0f;
	        float _19321;
	        if (_17421)
	        {
	            _19321 = 6.0f;
	        }
	        else
	        {
	            _19321 = (_Globals_1_g_flPatternType == 2.0f) ? 4.0f : 0.0f;
	        }
	        float _8821 = (input_1.x / input_1.w) / PerViewConstantBuffer_t_1_m0.x;
	        float2 _22624;
	        _22624.x = _8821;
	        float2 _20366;
	        if (_8821 < 0.0f)
	        {
	            float2 _10180 = _22624;
	            _10180.x = (_8821 * (-1.0f)) + _19321;
	            _20366 = _10180;
	        }
	        else
	        {
	            _20366 = _22624;
	        }
	        float _20881 = (input_1.y / input_1.w) / PerViewConstantBuffer_t_1_m0.y;
	        float2 _22625 = _20366;
	        _22625.y = _20881;
	        float2 _12885;
	        if (_20881 < 0.0f)
	        {
	            float2 _10181 = _22625;
	            _10181.y = (_20881 * (-1.0f)) + _19321;
	            _12885 = _10181;
	        }
	        else
	        {
	            _12885 = _22625;
	        }
	        if (_17421)
	        {
	            float2 _9303 = _12885;
	            _9303.y = 0.0f;
	            _11267 = fmod(length(_9303), _19321 * 2.0f) > _19321;
	            break;
	        }
	        else
	        {
	            if (_Globals_1_g_flPatternType == 2.0f)
	            {
	                float _10166 = _19321 * 2.0f;
	                bool _21205 = fmod(_12885.x, _10166) > _19321;
	                bool _15931 = fmod(_12885.y, _10166) > _19321;
	                bool _16648 = _21205 ? _15931 : false;
	                bool _12502;
	                if (!_16648)
	                {
	                    bool _12501;
	                    if (!_21205)
	                    {
	                        _12501 = !_15931;
	                    }
	                    else
	                    {
	                        _12501 = false;
	                    }
	                    _12502 = _12501;
	                }
	                else
	                {
	                    _12502 = _16648;
	                }
	                _11267 = _12502;
	                break;
	            }
	            else
	            {
	                _11267 = false;
	                break;
	            }
	            break; // unreachable workaround
	        }
	        break; // unreachable workaround
	    } while(false);
	    if (_11267)
	    {
	        discard;
	    }
	    output_0 = input_0;
	}
	
	PS_OUTPUT MainPs(PS_INPUT stage_input)
	{
	    input_0 = stage_input.input_0;
	    input_1 = stage_input.input_1;
	    MainPs_inner();
	    PS_OUTPUT stage_output;
	    stage_output.output_0 = output_0;
	    return stage_output;
	}
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
}
