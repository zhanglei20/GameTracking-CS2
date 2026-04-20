//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "Smoke Volume Depth";
	DevShader = true;
	Version = 1;
	
	// VcsVersion: 70
	// Platform: VULKAN_SM_50
	// Programs: ps, vs
}

MODES
{
	Depth();
}

FEATURES
{
}

COMMON
{
	#include "system.fxc"
}

struct VS_INPUT
{
	float4 vPositionPs          : POSITION0  < Semantic( position ); >;                           
	float4 vCameraToEyeRayWs    : TEXCOORD0  < Semantic( CameraToEyeWs ); >;                      
	float4 vCameraToNearPlaneWs : TEXCOORD1  < Semantic( CameraToNearPlaneRayWs ); >;             
};

VS
{
	
	ExternalDescriptorSet g_globalLateBoundBindlessSet < Source(ExternalDescSet); Attribute("g_globalLateBoundBindlessSet"); >;
	ExternalDescriptorSet g_lightBinnerGpuSet < Source(ExternalDescSet); Attribute("g_lightBinnerGpuSet"); >;
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (728 bytes), HLSL reflection with SPIRV-Cross by KhronosGroup
	
	static float4 gl_Position;
	static float2 vPositionPs;
	static float3 vCameraToEyeRayWs;
	static float3 vCameraToNearPlaneWs;
	static float3 output_0;
	static float3 output_1;
	
	struct VS_INPUT
	{
	    float2 vPositionPs : TEXCOORD0;
	    float3 vCameraToNearPlaneWs : TEXCOORD1;
	    float3 vCameraToEyeRayWs : TEXCOORD2;
	};
	
	struct PS_INPUT
	{
	    float3 output_0 : TEXCOORD0;
	    float3 output_1 : TEXCOORD1;
	    float4 gl_Position : SV_Position;
	};
	
	void MainVs_inner()
	{
	    float4 _14437 = float4(vPositionPs, 0.0f, 1.0f);
	    _14437.y = -vPositionPs.y;
	    gl_Position = _14437;
	    output_0 = vCameraToEyeRayWs;
	    output_1 = normalize(vCameraToNearPlaneWs);
	}
	
	PS_INPUT MainVs(VS_INPUT stage_input)
	{
	    vPositionPs = stage_input.vPositionPs;
	    vCameraToEyeRayWs = stage_input.vCameraToEyeRayWs;
	    vCameraToNearPlaneWs = stage_input.vCameraToNearPlaneWs;
	    MainVs_inner();
	    PS_INPUT stage_output;
	    stage_output.gl_Position = gl_Position;
	    stage_output.output_0 = output_0;
	    stage_output.output_1 = output_1;
	    return stage_output;
	}
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
}

PS
{
	DynamicCombo( D_SMOKE_NEW_VISUALS, 0..1 );
	
	cbuffer PerViewConstantBufferCsgo_t < Attribute("PerViewConstantBufferCsgo_t"); >;
	cbuffer PerViewConstantBuffer_t < Attribute("PerViewConstantBuffer_t"); >;
	cbuffer PerViewLightingConstantBufferGpu_t < Attribute("PerViewLightingConstantBufferGpu_t"); >;
	cbuffer SmokeConstantBuffer_t < Attribute("SmokeConstantBuffer_t"); >;
	bool g_bAnimateEdge < Attribute("bAnimateEdge"); UiType(CheckBox); >;
	float g_flDepthBias < Attribute("flDepthBias"); UiType(Slider); >;
	ExternalDescriptorSet g_globalLateBoundBindlessSet < Source(ExternalDescSet); Attribute("g_globalLateBoundBindlessSet"); >;
	ExternalDescriptorSet g_lightBinnerGpuSet < Source(ExternalDescSet); Attribute("g_lightBinnerGpuSet"); >;
	Texture2D g_tBlueNoise < Attribute("BlueNoise"); SrgbRead(false); >;
	Texture3D g_tSmokeNoiseTex < Channel(AGGB, None(TextureNoise), Linear); OutputFormat(RGBA8888); SrgbRead(false); >;
	Texture3D g_tSmokeVolumeTexA_Atlas < Attribute("SmokeVolumeTexA_Atlas"); SrgbRead(false); >;
	
	// Noise
	CreateInputTexture2D(TextureNoise, Srgb, 8, "", "_z0000", "Noise", Default4(1, 1, 1, 1));
	
	
	// SPIR-V reflection failed for backend HLSL:
	// cbuffer ID 4023 (name: SmokeConstantBuffer_t), member index 6 (name: _m6) cannot be expressed with either HLSL packing layout or packoffset.
	// 
	// Re-attempting reflection with the GLSL backend.
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (13364 bytes), GLSL reflection with SPIRV-Cross by KhronosGroup
	
	#version 460
	#extension GL_EXT_samplerless_texture_functions : require
	
	struct _1570
	{
	    vec4 _m0[16];
	};
	
	struct _1696
	{
	    vec4 _m0[5];
	};
	
	struct _1822
	{
	    vec4 _m0[2];
	};
	
	struct _2181
	{
	    vec4 _m0[4];
	};
	
	float _4;
	
	struct _571
	{
	    _1570 _m0;
	    _1570 _m1;
	    _1570 _m2;
	    _1570 _m3;
	    _1696 _m4;
	    _1822 _m5;
	    float _m6;
	    uint _m7;
	};
	
	layout(set = 1) uniform _571 SmokeConstantBuffer_t;
	
	struct _2489
	{
	    _2181 _m0;
	    float _m1;
	    vec4 _m2;
	    vec3 _m3;
	};
	
	layout(set = 1) uniform _2489 PerViewConstantBuffer_t;
	
	struct _998
	{
	    int g_bAnimateEdge;
	    float g_flDepthBias;
	};
	
	layout(set = 1) uniform _998 _Globals_;
	
	struct _995
	{
	    ivec2 _m0;
	};
	
	layout(set = 1) uniform _995 PerViewConstantBufferCsgo_t;
	
	layout(set = 1, binding = 43) uniform texture3D g_tSmokeVolumeTexA_Atlas;
	layout(set = 1, binding = 18) uniform sampler g_sTrilinearClamp;
	layout(set = 1, binding = 30) uniform texture2D g_tBlueNoise;
	
	layout(location = 0) in vec3 input_0;
	layout(location = 1) in vec3 input_1;
	
	void main()
	{
	    uint _21547 = uint(SmokeConstantBuffer_t._m0._m0[0].w);
	    vec3 _17114;
	    _17114 = vec3(0.0);
	    uint _4743;
	    uint _11056;
	    float _13142;
	    float _13143;
	    vec3 _14880;
	    vec3 _14891;
	    float _16306;
	    uint _18360;
	    float _13136 = 0.0;
	    float _16305;
	    uint _17017 = 0u;
	    uint _17133 = 0u;
	    for (;;)
	    {
	        if (!(_17017 < _21547))
	        {
	            _13143 = _13136;
	            _14880 = _17114;
	            _11056 = _17133;
	            break;
	        }
	        vec3 _23296 = vec3(1.0) / input_1;
	        vec3 _8251 = _23296 * (SmokeConstantBuffer_t._m0._m0[_17017].xyz - input_0);
	        vec3 _6243 = _23296 * (SmokeConstantBuffer_t._m1._m0[_17017].xyz - input_0);
	        vec3 _7415 = min(_6243, _8251);
	        vec3 _13037 = max(_6243, _8251);
	        vec2 _11253 = max(_7415.xx, _7415.yz);
	        float _12676 = max(_11253.x, _11253.y);
	        vec2 _16933 = min(_13037.xx, _13037.yz);
	        float _14150 = min(_16933.x, _16933.y);
	        if (!(_12676 > _14150))
	        {
	            float _14952 = max(0.0, _12676);
	            vec3 _12822 = (input_0 + (input_1 * _14952)) - SmokeConstantBuffer_t._m2._m0[_17017].xyz;
	            bool _3259 = SmokeConstantBuffer_t._m3._m0[_17017].x > 1.0;
	            vec3 _11967;
	            if (!_3259)
	            {
	                _11967 = _12822 * mix(2.0, 1.0, saturate(SmokeConstantBuffer_t._m3._m0[_17017].z * 2.0));
	            }
	            else
	            {
	                _11967 = _12822;
	            }
	            vec3 _20183 = clamp((_11967 + vec3(320.0)) * vec3(0.0500000007450580596923828125), vec3(0.0), vec3(31.0));
	            uint _14719 = uint(SmokeConstantBuffer_t._m2._m0[_17017].w);
	            vec3 _13139;
	            float _23381;
	            do
	            {
	                ivec3 _12244 = ivec3(sign(input_1));
	                vec3 _8653 = input_1 + (vec3(equal(input_1, vec3(0.0))) * 9.9999997473787516355514526367188e-06);
	                vec3 _11212 = abs(vec3(1.0) / _8653);
	                vec3 _13137;
	                vec3 _16324;
	                _13137 = (((vec3(greaterThan(_12244, ivec3(0))) - fract(_20183)) * vec3(_12244)) + (vec3(equal(_12244, ivec3(0))) * (_14150 - _14952))) * _11212;
	                _16324 = _20183;
	                uint _14723;
	                vec3 _23259;
	                vec3 _24030;
	                float _16343;
	                bool _16863;
	                uint _17018 = 0u;
	                for (;;)
	                {
	                    if (!(_17018 < 32u))
	                    {
	                        _13139 = _20183;
	                        _16343 = _16305;
	                        _16863 = false;
	                        break;
	                    }
	                    vec3 _20391 = _16324 * vec3(0.03125);
	                    vec3 _23497 = saturate(_20391);
	                    if (any(notEqual(_23497, _20391)))
	                    {
	                        _13139 = _20183;
	                        _16343 = 0.0;
	                        _16863 = true;
	                        break;
	                    }
	                    float _23661 = 34.0 * float(_14719);
	                    _23497.x = (_23661 + (_23497.x * 32.0)) * 0.0018450184725224971771240234375;
	                    vec4 _11487 = textureLod(sampler3D(g_tSmokeVolumeTexA_Atlas, g_sTrilinearClamp), _23497.xyz, 0.0);
	                    vec2 _20693 = vec2(SmokeConstantBuffer_t._m3._m0[_17017].y);
	                    vec2 _7714 = mix(_11487.xz, _11487.yw, _20693);
	                    float _16428 = max(_7714.x, _7714.y);
	                    if (_16428 > 0.100000001490116119384765625)
	                    {
	                        float _13138;
	                        vec3 _16325;
	                        _13138 = _16428;
	                        _16325 = _16324;
	                        float _9828;
	                        int _14722;
	                        vec3 _18040;
	                        int _17019 = 0;
	                        for (;;)
	                        {
	                            if (!(_17019 < 4))
	                            {
	                                break;
	                            }
	                            _18040 = _16325 + (_8653 * 0.800000011920928955078125);
	                            vec3 _15154 = _18040 * vec3(0.03125);
	                            vec3 _8236 = saturate(_15154);
	                            if (any(notEqual(_8236, _15154)))
	                            {
	                                break;
	                            }
	                            _8236.x = (_23661 + (_8236.x * 32.0)) * 0.0018450184725224971771240234375;
	                            vec4 _11488 = textureLod(sampler3D(g_tSmokeVolumeTexA_Atlas, g_sTrilinearClamp), _8236.xyz, 0.0);
	                            vec2 _6350 = mix(_11488.xz, _11488.yw, _20693);
	                            vec3 _14830 = _18040 + ((vec3(0.300000011920928955078125, -0.4000000059604644775390625, -0.5) * PerViewConstantBuffer_t._m1) * 1.440000057220458984375);
	                            _9828 = _13138 + ((max(_6350.x, _6350.y) * 2.0) * clamp(abs(((sin(_14830.x * 1.2200000286102294921875) * 0.88999998569488525390625) + (sin(_14830.y * 1.16999995708465576171875) * 0.430000007152557373046875)) + (sin(_14830.z * 3.0) * 0.20000000298023223876953125)), 0.0, 1.0));
	                            _14722 = _17019 + 1;
	                            _13138 = _9828;
	                            _16325 = _18040;
	                            _17019 = _14722;
	                            continue;
	                        }
	                        _13139 = _16324;
	                        _16343 = saturate(_13138);
	                        _16863 = true;
	                        break;
	                    }
	                    vec3 _16849 = vec3(lessThanEqual(_13137, min(_13137.yzx, _13137.zxy)));
	                    vec3 _16703 = _16849 * _13137;
	                    _24030 = _20183 + (_8653 * ((_16703.x + _16703.y) + _16703.z));
	                    _23259 = _13137 + (_16849 * _11212);
	                    _14723 = _17018 + 2u;
	                    _13137 = _23259;
	                    _16324 = _24030;
	                    _17018 = _14723;
	                    continue;
	                }
	                if (_16863)
	                {
	                    _23381 = _16343;
	                    break;
	                }
	                _23381 = 0.0;
	                break;
	            } while(false);
	            vec3 _13141;
	            uint _16381;
	            float _16479;
	            if (_23381 > 0.0)
	            {
	                float _3914 = (_23381 + 0.300000011920928955078125) * clamp(SmokeConstantBuffer_t._m3._m0[_17017].z + (0.5 * float(_3259)), 0.0, 1.0);
	                uint _10837;
	                vec3 _14747;
	                if (_17133 == 0u)
	                {
	                    vec3 _13818 = (((_13139 * 20.0) - vec3(320.0)) + SmokeConstantBuffer_t._m2._m0[int(_17017)].xyz) + ((-input_1) * 5.0);
	                    vec3 _12683;
	                    if (dot(input_1, normalize(_13818 - PerViewConstantBuffer_t._m3)) < 0.0)
	                    {
	                        _12683 = input_0 + (input_1 * 5.0);
	                    }
	                    else
	                    {
	                        _12683 = _13818;
	                    }
	                    _10837 = _17133 | (1u << (_17017 * 2u));
	                    _14747 = _12683;
	                }
	                else
	                {
	                    _10837 = _17133;
	                    _14747 = _17114;
	                }
	                int _12734 = int(_17017);
	                float _11659;
	                if (SmokeConstantBuffer_t._m7 > 0u)
	                {
	                    vec3 _13140;
	                    float _16326;
	                    _13140 = _14747;
	                    _16326 = 1.0;
	                    uint _8896;
	                    float _10913;
	                    vec3 _17551;
	                    uint _17020 = 0u;
	                    for (;;)
	                    {
	                        bool _7956_ladder_break = false;
	                        do
	                        {
	                            if (!(_17020 < SmokeConstantBuffer_t._m7))
	                            {
	                                _7956_ladder_break = true;
	                                break;
	                            }
	                            if ((uint(SmokeConstantBuffer_t._m5._m0[_17020 / 4u][_17020 % 4u]) & (1u << uint(SmokeConstantBuffer_t._m3._m0[_12734].w))) == 0u)
	                            {
	                                _10913 = _16326;
	                                _17551 = _13140;
	                                break;
	                            }
	                            float _10810 = SmokeConstantBuffer_t._m6 - SmokeConstantBuffer_t._m4._m0[_17020].w;
	                            float _13213;
	                            vec3 _15671;
	                            if (_10810 < (SmokeConstantBuffer_t._m3._m0[_12734].x - 0.4000000059604644775390625))
	                            {
	                                float _13668 = distance(_13140, SmokeConstantBuffer_t._m4._m0[_17020].xyz);
	                                float _13212;
	                                vec3 _15670;
	                                if (_13668 < 250.0)
	                                {
	                                    float _16611 = pow(1.0 - smoothstep(0.0, 2.0, _10810), 128.0);
	                                    _13212 = min(_16326, max(smoothstep(200.0, 240.0, _13668 + (_16611 * 250.0)) + pow(smoothstep(0.5, 5.0, _10810), 1.7999999523162841796875), 0.0));
	                                    _15670 = mix(_13140, SmokeConstantBuffer_t._m4._m0[_17020].xyz, vec3(((1.0 - smoothstep(100.0, 250.0, _13668)) * step(_10810 * 1250.0, _13668)) * (1.0 - _16611)));
	                                }
	                                else
	                                {
	                                    _13212 = _16326;
	                                    _15670 = _13140;
	                                }
	                                _13213 = _13212;
	                                _15671 = _15670;
	                            }
	                            else
	                            {
	                                _13213 = _16326;
	                                _15671 = _13140;
	                            }
	                            _10913 = _13213;
	                            _17551 = _15671;
	                            break;
	                        } while(false);
	                        if (_7956_ladder_break)
	                        {
	                            break;
	                        }
	                        _8896 = _17020 + 1u;
	                        _13140 = _17551;
	                        _16326 = _10913;
	                        _17020 = _8896;
	                        continue;
	                    }
	                    _11659 = mix(_3914 * 0.0199999995529651641845703125, _3914, _16326);
	                }
	                else
	                {
	                    _11659 = _3914;
	                }
	                float _5523 = _13136 + mix(_11659, clamp((_11659 - 0.699999988079071044921875) * 10.0, 0.0, 1.0), SmokeConstantBuffer_t._m3._m0[_17017].z);
	                if (_5523 > 1.0)
	                {
	                    _13143 = saturate(_5523);
	                    _14880 = _14747;
	                    _11056 = _10837;
	                    break;
	                }
	                _13141 = _14747;
	                _16381 = _10837;
	                _16479 = _5523;
	            }
	            else
	            {
	                _13141 = _17114;
	                _16381 = _17133;
	                _16479 = _13136;
	            }
	            _13142 = _16479;
	            _16306 = _23381;
	            _14891 = _13141;
	            _18360 = _16381;
	        }
	        else
	        {
	            _13142 = _13136;
	            _16306 = _16305;
	            _14891 = _17114;
	            _18360 = _17133;
	        }
	        _4743 = _17017 + 1u;
	        _13136 = _13142;
	        _16305 = _16306;
	        _17114 = _14891;
	        _17133 = _18360;
	        _17017 = _4743;
	        continue;
	    }
	    if (_11056 == 0u)
	    {
	        discard;
	    }
	    vec4 _23913 = (vec4((_14880 + vec3(-4.0)).xyz, 1.0) + (PerViewConstantBuffer_t._m2 * 1.0)).xyzw * mat4(vec4(PerViewConstantBuffer_t._m0._m0[0].x, PerViewConstantBuffer_t._m0._m0[1].x, PerViewConstantBuffer_t._m0._m0[2].x, PerViewConstantBuffer_t._m0._m0[3].x), vec4(PerViewConstantBuffer_t._m0._m0[0].y, PerViewConstantBuffer_t._m0._m0[1].y, PerViewConstantBuffer_t._m0._m0[2].y, PerViewConstantBuffer_t._m0._m0[3].y), vec4(PerViewConstantBuffer_t._m0._m0[0].z, PerViewConstantBuffer_t._m0._m0[1].z, PerViewConstantBuffer_t._m0._m0[2].z, PerViewConstantBuffer_t._m0._m0[3].z), vec4(PerViewConstantBuffer_t._m0._m0[0].w, PerViewConstantBuffer_t._m0._m0[1].w, PerViewConstantBuffer_t._m0._m0[2].w, PerViewConstantBuffer_t._m0._m0[3].w));
	    if ((fma(_13143, 2.0, -1.5) + fract(texelFetch(g_tBlueNoise, ivec3(ivec2(gl_FragCoord.xy) & PerViewConstantBufferCsgo_t._m0, 0).xy, 0).y + ((PerViewConstantBuffer_t._m1 * 0.61803400516510009765625) * float(_Globals_.g_bAnimateEdge != 0)))) < 0.0)
	    {
	        discard;
	    }
	    gl_FragDepth = (_23913.z / _23913.w) + (_Globals_.g_flDepthBias * 0.100000001490116119384765625);
	}
	
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
}
