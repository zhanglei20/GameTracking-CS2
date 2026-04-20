//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "Sparse Shadow Tree Compute Shader";
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
	DynamicCombo( D_UNPACK_METHOD, 0..2 );
	DynamicCombo( D_OUTPUT_DEBUG_COLOR, 0..1 );
	
	StructuredBuffer g_SST < Attribute("SparseShadowTree"); SrgbRead(false); >;
	int g_nSSTForest < Attribute("SSTForest"); UiType(Slider); >;
	int g_nSSTOutputPixelExcludeEndX < Attribute("SSTOutputPixelExcludeEndX"); UiType(Slider); >;
	int g_nSSTOutputPixelExcludeEndY < Attribute("SSTOutputPixelExcludeEndY"); UiType(Slider); >;
	int g_nSSTOutputPixelExcludeStartX < Attribute("SSTOutputPixelExcludeStartX"); UiType(Slider); >;
	int g_nSSTOutputPixelExcludeStartY < Attribute("SSTOutputPixelExcludeStartY"); UiType(Slider); >;
	int g_nSSTOutputPixelHeight < Attribute("SSTOutputPixelHeight"); UiType(Slider); >;
	int g_nSSTOutputPixelStartOffsetX < Attribute("SSTOutputPixelStartOffsetX"); UiType(Slider); >;
	int g_nSSTOutputPixelStartOffsetY < Attribute("SSTOutputPixelStartOffsetY"); UiType(Slider); >;
	int g_nSSTOutputPixelStartX < Attribute("SSTOutputPixelStartX"); UiType(Slider); >;
	int g_nSSTOutputPixelStartY < Attribute("SSTOutputPixelStartY"); UiType(Slider); >;
	int g_nSSTOutputPixelWidth < Attribute("SSTOutputPixelWidth"); UiType(Slider); >;
	int g_nSSTTileStartX < Attribute("SSTTileStartX"); UiType(Slider); >;
	int g_nSSTTileStartY < Attribute("SSTTileStartY"); UiType(Slider); >;
	int g_nSSTWidth < Attribute("SSTWidth"); UiType(Slider); >;
	RWTexture2D<float4> g_tOutColor < Attribute("SSTDebugColor"); >;
	RWTexture2D<float4> g_tOutDepth < Attribute("ShadowAtlas"); >;
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (40196 bytes), HLSL reflection with SPIRV-Cross by KhronosGroup
	
	cbuffer _Globals_ : register(b0, space0)
	{
	    uint _Globals_1_g_nSSTWidth : packoffset(c0);
	    uint _Globals_1_g_nSSTTileStartX : packoffset(c1);
	    uint _Globals_1_g_nSSTTileStartY : packoffset(c1.y);
	    uint _Globals_1_g_nSSTOutputPixelStartOffsetX : packoffset(c1.z);
	    uint _Globals_1_g_nSSTOutputPixelStartOffsetY : packoffset(c1.w);
	    uint _Globals_1_g_nSSTOutputPixelStartX : packoffset(c2);
	    uint _Globals_1_g_nSSTOutputPixelStartY : packoffset(c2.y);
	    uint _Globals_1_g_nSSTOutputPixelWidth : packoffset(c2.z);
	    uint _Globals_1_g_nSSTOutputPixelHeight : packoffset(c2.w);
	    uint _Globals_1_g_nSSTOutputPixelExcludeStartX : packoffset(c3);
	    uint _Globals_1_g_nSSTOutputPixelExcludeStartY : packoffset(c3.y);
	    uint _Globals_1_g_nSSTOutputPixelExcludeEndX : packoffset(c3.z);
	    uint _Globals_1_g_nSSTOutputPixelExcludeEndY : packoffset(c3.w);
	    uint _Globals_1_g_nSSTForest : packoffset(c4);
	};
	
	ByteAddressBuffer g_SST : register(t30, space0);
	RWTexture2D<float4> _3177 : register(u158, space0);
	
	static uint3 gl_GlobalInvocationID;
	struct SPIRV_Cross_Input
	{
	    uint3 gl_GlobalInvocationID : SV_DispatchThreadID;
	};
	
	void MainCs_inner()
	{
	    do
	    {
	        uint2 _19018 = gl_GlobalInvocationID.xy * uint2(4u, 4u);
	        uint2 _3797 = uint2(_Globals_1_g_nSSTTileStartX, _Globals_1_g_nSSTTileStartY) + (gl_GlobalInvocationID.xy / uint2(32u, 32u));
	        uint2 _15313 = _19018 + uint2(_Globals_1_g_nSSTOutputPixelStartOffsetX, _Globals_1_g_nSSTOutputPixelStartOffsetY);
	        uint _7985 = _15313.x;
	        bool _12885;
	        if (_7985 >= _Globals_1_g_nSSTOutputPixelWidth)
	        {
	            _12885 = true;
	        }
	        else
	        {
	            _12885 = _15313.y >= _Globals_1_g_nSSTOutputPixelHeight;
	        }
	        if (_12885)
	        {
	            break;
	        }
	        bool _12886;
	        if (_7985 > _Globals_1_g_nSSTOutputPixelExcludeStartX)
	        {
	            _12886 = _7985 < _Globals_1_g_nSSTOutputPixelExcludeEndX;
	        }
	        else
	        {
	            _12886 = false;
	        }
	        bool _12887;
	        if (_12886)
	        {
	            _12887 = _15313.y > _Globals_1_g_nSSTOutputPixelExcludeStartY;
	        }
	        else
	        {
	            _12887 = false;
	        }
	        bool _12888;
	        if (_12887)
	        {
	            _12888 = _15313.y < _Globals_1_g_nSSTOutputPixelExcludeEndY;
	        }
	        else
	        {
	            _12888 = false;
	        }
	        if (_12888)
	        {
	            break;
	        }
	        uint2 _15314 = _15313 + uint2(_Globals_1_g_nSSTOutputPixelStartX, _Globals_1_g_nSSTOutputPixelStartY);
	        uint _17785 = (_3797.y * _Globals_1_g_nSSTWidth) + _3797.x;
	        bool _11402;
	        uint _11518;
	        float _13174;
	        uint _14842;
	        do
	        {
	            uint _21397 = g_SST.Load(_17785 * 4 + 0);
	            bool _16054;
	            do
	            {
	                if ((_21397 & 1073741824u) != 0u)
	                {
	                    _13174 = asfloat((_21397 & 3221225471u) << uint(2));
	                    _16054 = true;
	                    break;
	                }
	                _13174 = 1.0f;
	                _16054 = false;
	                break;
	            } while(false);
	            if (_16054)
	            {
	                float4 _10876 = _13174.xxxx;
	                _3177[_15314] = _10876;
	                _3177[_15314 + uint2(1u, 0u)] = _10876;
	                _3177[_15314 + uint2(0u, 1u)] = _10876;
	                _3177[_15314 + uint2(1u, 1u)] = _10876;
	                _3177[_15314 + uint2(2u, 0u)] = _10876;
	                _3177[_15314 + uint2(3u, 0u)] = _10876;
	                _3177[_15314 + uint2(2u, 1u)] = _10876;
	                _3177[_15314 + uint2(3u, 1u)] = _10876;
	                _3177[_15314 + uint2(0u, 2u)] = _10876;
	                _3177[_15314 + uint2(1u, 2u)] = _10876;
	                _3177[_15314 + uint2(0u, 3u)] = _10876;
	                _3177[_15314 + uint2(1u, 3u)] = _10876;
	                _3177[_15314 + uint2(2u, 2u)] = _10876;
	                _3177[_15314 + uint2(3u, 2u)] = _10876;
	                _3177[_15314 + uint2(2u, 3u)] = _10876;
	                _3177[_15314 + uint2(3u, 3u)] = _10876;
	                _11518 = _Globals_1_g_nSSTForest;
	                _14842 = _17785;
	                _11402 = true;
	                break;
	            }
	            else
	            {
	                _11518 = _21397;
	                _14842 = _21397;
	                _11402 = false;
	                break;
	            }
	            break; // unreachable workaround
	        } while(false);
	        if (!_11402)
	        {
	            bool _11403;
	            float3 _11519;
	            float _13175;
	            uint _14843;
	            do
	            {
	                uint _21398 = g_SST.Load(_14842 * 4 + 0);
	                bool _16055;
	                do
	                {
	                    if ((_21398 & 1073741824u) != 0u)
	                    {
	                        _13175 = asfloat((_21398 & 3221225471u) << uint(2));
	                        _16055 = true;
	                        break;
	                    }
	                    _13175 = _13174;
	                    _16055 = false;
	                    break;
	                } while(false);
	                if (_16055)
	                {
	                    float4 _10877 = _13175.xxxx;
	                    _3177[_15314] = _10877;
	                    _3177[_15314 + uint2(1u, 0u)] = _10877;
	                    _3177[_15314 + uint2(0u, 1u)] = _10877;
	                    _3177[_15314 + uint2(1u, 1u)] = _10877;
	                    _3177[_15314 + uint2(2u, 0u)] = _10877;
	                    _3177[_15314 + uint2(3u, 0u)] = _10877;
	                    _3177[_15314 + uint2(2u, 1u)] = _10877;
	                    _3177[_15314 + uint2(3u, 1u)] = _10877;
	                    _3177[_15314 + uint2(0u, 2u)] = _10877;
	                    _3177[_15314 + uint2(1u, 2u)] = _10877;
	                    _3177[_15314 + uint2(0u, 3u)] = _10877;
	                    _3177[_15314 + uint2(1u, 3u)] = _10877;
	                    _3177[_15314 + uint2(2u, 2u)] = _10877;
	                    _3177[_15314 + uint2(3u, 2u)] = _10877;
	                    _3177[_15314 + uint2(2u, 3u)] = _10877;
	                    _3177[_15314 + uint2(3u, 3u)] = _10877;
	                    _11519 = float3(1.0f, 0.0f, 0.0f);
	                    _14843 = _14842;
	                    _11403 = true;
	                    break;
	                }
	                else
	                {
	                    uint _21970 = _14842 + 1u;
	                    float3 _13176;
	                    bool _16056;
	                    do
	                    {
	                        if ((_21398 & 2147483648u) != 0u)
	                        {
	                            _13176 = float3(float((min16float)f16tof32(min16uint(g_SST.Load(_21970 * 4 + 0) >> uint(16)))), float((min16float)f16tof32(min16uint(g_SST.Load(_21970 * 4 + 0) & 65535u))), asfloat((_21398 & 2147483647u) << uint(1)));
	                            _16056 = true;
	                            break;
	                        }
	                        _13176 = float3(1.0f, 0.0f, 0.0f);
	                        _16056 = false;
	                        break;
	                    } while(false);
	                    if (_16056)
	                    {
	                        uint2 _24337 = _19018 % uint2(128u, 128u);
	                        float4 _22821 = _13176.xxxx * float4(0.0f, 1.0f, 2.0f, 3.0f);
	                        float4 _22382 = ((_13176.z + (float(_24337.x) * _13176.x)) + (float(_24337.y) * _13176.y)).xxxx;
	                        float4 _9987 = _22382 + _22821;
	                        float4 _21802 = (_22382 + _13176.yyyy) + _22821;
	                        float4 _20890 = (_22382 + (_13176.yyyy * 2.0f)) + _22821;
	                        float4 _16200 = (_22382 + (_13176.yyyy * 3.0f)) + _22821;
	                        _3177[_15314] = _9987.x.xxxx;
	                        _3177[_15314 + uint2(1u, 0u)] = _9987.y.xxxx;
	                        _3177[_15314 + uint2(2u, 0u)] = _9987.z.xxxx;
	                        _3177[_15314 + uint2(3u, 0u)] = _9987.w.xxxx;
	                        _3177[_15314 + uint2(0u, 1u)] = _21802.x.xxxx;
	                        _3177[_15314 + uint2(1u, 1u)] = _21802.y.xxxx;
	                        _3177[_15314 + uint2(2u, 1u)] = _21802.z.xxxx;
	                        _3177[_15314 + uint2(3u, 1u)] = _21802.w.xxxx;
	                        _3177[_15314 + uint2(0u, 2u)] = _20890.x.xxxx;
	                        _3177[_15314 + uint2(1u, 2u)] = _20890.y.xxxx;
	                        _3177[_15314 + uint2(2u, 2u)] = _20890.z.xxxx;
	                        _3177[_15314 + uint2(3u, 2u)] = _20890.w.xxxx;
	                        _3177[_15314 + uint2(0u, 3u)] = _16200.x.xxxx;
	                        _3177[_15314 + uint2(1u, 3u)] = _16200.y.xxxx;
	                        _3177[_15314 + uint2(2u, 3u)] = _16200.z.xxxx;
	                        _3177[_15314 + uint2(3u, 3u)] = _16200.w.xxxx;
	                        _11519 = _13176;
	                        _14843 = _14842;
	                        _11403 = true;
	                        break;
	                    }
	                    else
	                    {
	                        uint2 _13668 = _19018 % uint2(128u, 128u);
	                        uint _21709;
	                        if (_13668.x < 64u)
	                        {
	                            _21709 = (_13668.y < 64u) ? 0u : 2u;
	                        }
	                        else
	                        {
	                            _21709 = (_13668.y < 64u) ? 1u : 3u;
	                        }
	                        uint _14382;
	                        if (_21709 == 0u)
	                        {
	                            _14382 = (_21398 >> uint(15)) & 32767u;
	                        }
	                        else
	                        {
	                            uint _12502;
	                            if (_21709 == 1u)
	                            {
	                                _12502 = _21398 & 32767u;
	                            }
	                            else
	                            {
	                                uint _12501;
	                                if (_21709 == 2u)
	                                {
	                                    _12501 = (g_SST.Load(_21970 * 4 + 0) >> uint(15)) & 32767u;
	                                }
	                                else
	                                {
	                                    _12501 = g_SST.Load(_21970 * 4 + 0) & 32767u;
	                                }
	                                _12502 = _12501;
	                            }
	                            _14382 = _12502;
	                        }
	                        _11519 = _13176;
	                        _14843 = _14382 + _11518;
	                        _11403 = false;
	                        break;
	                    }
	                    break; // unreachable workaround
	                }
	                break; // unreachable workaround
	            } while(false);
	            if (!_11403)
	            {
	                bool _11404;
	                float3 _11520;
	                float _13177;
	                uint _14844;
	                do
	                {
	                    uint _21399 = g_SST.Load(_14843 * 4 + 0);
	                    bool _16057;
	                    do
	                    {
	                        if ((_21399 & 1073741824u) != 0u)
	                        {
	                            _13177 = asfloat((_21399 & 3221225471u) << uint(2));
	                            _16057 = true;
	                            break;
	                        }
	                        _13177 = _13175;
	                        _16057 = false;
	                        break;
	                    } while(false);
	                    if (_16057)
	                    {
	                        float4 _10878 = _13177.xxxx;
	                        _3177[_15314] = _10878;
	                        _3177[_15314 + uint2(1u, 0u)] = _10878;
	                        _3177[_15314 + uint2(0u, 1u)] = _10878;
	                        _3177[_15314 + uint2(1u, 1u)] = _10878;
	                        _3177[_15314 + uint2(2u, 0u)] = _10878;
	                        _3177[_15314 + uint2(3u, 0u)] = _10878;
	                        _3177[_15314 + uint2(2u, 1u)] = _10878;
	                        _3177[_15314 + uint2(3u, 1u)] = _10878;
	                        _3177[_15314 + uint2(0u, 2u)] = _10878;
	                        _3177[_15314 + uint2(1u, 2u)] = _10878;
	                        _3177[_15314 + uint2(0u, 3u)] = _10878;
	                        _3177[_15314 + uint2(1u, 3u)] = _10878;
	                        _3177[_15314 + uint2(2u, 2u)] = _10878;
	                        _3177[_15314 + uint2(3u, 2u)] = _10878;
	                        _3177[_15314 + uint2(2u, 3u)] = _10878;
	                        _3177[_15314 + uint2(3u, 3u)] = _10878;
	                        _11520 = _11519;
	                        _14844 = _14843;
	                        _11404 = true;
	                        break;
	                    }
	                    else
	                    {
	                        uint _21971 = _14843 + 1u;
	                        float3 _13178;
	                        bool _16058;
	                        do
	                        {
	                            if ((_21399 & 2147483648u) != 0u)
	                            {
	                                _13178 = float3(float((min16float)f16tof32(min16uint(g_SST.Load(_21971 * 4 + 0) >> uint(16)))), float((min16float)f16tof32(min16uint(g_SST.Load(_21971 * 4 + 0) & 65535u))), asfloat((_21399 & 2147483647u) << uint(1)));
	                                _16058 = true;
	                                break;
	                            }
	                            _13178 = _11519;
	                            _16058 = false;
	                            break;
	                        } while(false);
	                        if (_16058)
	                        {
	                            uint2 _24338 = _19018 % uint2(64u, 64u);
	                            float4 _22822 = _13178.xxxx * float4(0.0f, 1.0f, 2.0f, 3.0f);
	                            float4 _22383 = ((_13178.z + (float(_24338.x) * _13178.x)) + (float(_24338.y) * _13178.y)).xxxx;
	                            float4 _9988 = _22383 + _22822;
	                            float4 _21803 = (_22383 + _13178.yyyy) + _22822;
	                            float4 _20891 = (_22383 + (_13178.yyyy * 2.0f)) + _22822;
	                            float4 _16201 = (_22383 + (_13178.yyyy * 3.0f)) + _22822;
	                            _3177[_15314] = _9988.x.xxxx;
	                            _3177[_15314 + uint2(1u, 0u)] = _9988.y.xxxx;
	                            _3177[_15314 + uint2(2u, 0u)] = _9988.z.xxxx;
	                            _3177[_15314 + uint2(3u, 0u)] = _9988.w.xxxx;
	                            _3177[_15314 + uint2(0u, 1u)] = _21803.x.xxxx;
	                            _3177[_15314 + uint2(1u, 1u)] = _21803.y.xxxx;
	                            _3177[_15314 + uint2(2u, 1u)] = _21803.z.xxxx;
	                            _3177[_15314 + uint2(3u, 1u)] = _21803.w.xxxx;
	                            _3177[_15314 + uint2(0u, 2u)] = _20891.x.xxxx;
	                            _3177[_15314 + uint2(1u, 2u)] = _20891.y.xxxx;
	                            _3177[_15314 + uint2(2u, 2u)] = _20891.z.xxxx;
	                            _3177[_15314 + uint2(3u, 2u)] = _20891.w.xxxx;
	                            _3177[_15314 + uint2(0u, 3u)] = _16201.x.xxxx;
	                            _3177[_15314 + uint2(1u, 3u)] = _16201.y.xxxx;
	                            _3177[_15314 + uint2(2u, 3u)] = _16201.z.xxxx;
	                            _3177[_15314 + uint2(3u, 3u)] = _16201.w.xxxx;
	                            _11520 = _13178;
	                            _14844 = _14843;
	                            _11404 = true;
	                            break;
	                        }
	                        else
	                        {
	                            uint2 _13669 = _19018 % uint2(64u, 64u);
	                            uint _21710;
	                            if (_13669.x < 32u)
	                            {
	                                _21710 = (_13669.y < 32u) ? 0u : 2u;
	                            }
	                            else
	                            {
	                                _21710 = (_13669.y < 32u) ? 1u : 3u;
	                            }
	                            uint _14383;
	                            if (_21710 == 0u)
	                            {
	                                _14383 = (_21399 >> uint(15)) & 32767u;
	                            }
	                            else
	                            {
	                                uint _12504;
	                                if (_21710 == 1u)
	                                {
	                                    _12504 = _21399 & 32767u;
	                                }
	                                else
	                                {
	                                    uint _12503;
	                                    if (_21710 == 2u)
	                                    {
	                                        _12503 = (g_SST.Load(_21971 * 4 + 0) >> uint(15)) & 32767u;
	                                    }
	                                    else
	                                    {
	                                        _12503 = g_SST.Load(_21971 * 4 + 0) & 32767u;
	                                    }
	                                    _12504 = _12503;
	                                }
	                                _14383 = _12504;
	                            }
	                            _11520 = _13178;
	                            _14844 = _14383 + _11518;
	                            _11404 = false;
	                            break;
	                        }
	                        break; // unreachable workaround
	                    }
	                    break; // unreachable workaround
	                } while(false);
	                if (!_11404)
	                {
	                    bool _11405;
	                    float3 _11521;
	                    float _13179;
	                    uint _14845;
	                    do
	                    {
	                        uint _21400 = g_SST.Load(_14844 * 4 + 0);
	                        bool _16059;
	                        do
	                        {
	                            if ((_21400 & 1073741824u) != 0u)
	                            {
	                                _13179 = asfloat((_21400 & 3221225471u) << uint(2));
	                                _16059 = true;
	                                break;
	                            }
	                            _13179 = _13177;
	                            _16059 = false;
	                            break;
	                        } while(false);
	                        if (_16059)
	                        {
	                            float4 _10879 = _13179.xxxx;
	                            _3177[_15314] = _10879;
	                            _3177[_15314 + uint2(1u, 0u)] = _10879;
	                            _3177[_15314 + uint2(0u, 1u)] = _10879;
	                            _3177[_15314 + uint2(1u, 1u)] = _10879;
	                            _3177[_15314 + uint2(2u, 0u)] = _10879;
	                            _3177[_15314 + uint2(3u, 0u)] = _10879;
	                            _3177[_15314 + uint2(2u, 1u)] = _10879;
	                            _3177[_15314 + uint2(3u, 1u)] = _10879;
	                            _3177[_15314 + uint2(0u, 2u)] = _10879;
	                            _3177[_15314 + uint2(1u, 2u)] = _10879;
	                            _3177[_15314 + uint2(0u, 3u)] = _10879;
	                            _3177[_15314 + uint2(1u, 3u)] = _10879;
	                            _3177[_15314 + uint2(2u, 2u)] = _10879;
	                            _3177[_15314 + uint2(3u, 2u)] = _10879;
	                            _3177[_15314 + uint2(2u, 3u)] = _10879;
	                            _3177[_15314 + uint2(3u, 3u)] = _10879;
	                            _11521 = _11520;
	                            _14845 = _14844;
	                            _11405 = true;
	                            break;
	                        }
	                        else
	                        {
	                            uint _21972 = _14844 + 1u;
	                            float3 _13180;
	                            bool _16060;
	                            do
	                            {
	                                if ((_21400 & 2147483648u) != 0u)
	                                {
	                                    _13180 = float3(float((min16float)f16tof32(min16uint(g_SST.Load(_21972 * 4 + 0) >> uint(16)))), float((min16float)f16tof32(min16uint(g_SST.Load(_21972 * 4 + 0) & 65535u))), asfloat((_21400 & 2147483647u) << uint(1)));
	                                    _16060 = true;
	                                    break;
	                                }
	                                _13180 = _11520;
	                                _16060 = false;
	                                break;
	                            } while(false);
	                            if (_16060)
	                            {
	                                uint2 _24339 = _19018 % uint2(32u, 32u);
	                                float4 _22823 = _13180.xxxx * float4(0.0f, 1.0f, 2.0f, 3.0f);
	                                float4 _22384 = ((_13180.z + (float(_24339.x) * _13180.x)) + (float(_24339.y) * _13180.y)).xxxx;
	                                float4 _9989 = _22384 + _22823;
	                                float4 _21804 = (_22384 + _13180.yyyy) + _22823;
	                                float4 _20892 = (_22384 + (_13180.yyyy * 2.0f)) + _22823;
	                                float4 _16202 = (_22384 + (_13180.yyyy * 3.0f)) + _22823;
	                                _3177[_15314] = _9989.x.xxxx;
	                                _3177[_15314 + uint2(1u, 0u)] = _9989.y.xxxx;
	                                _3177[_15314 + uint2(2u, 0u)] = _9989.z.xxxx;
	                                _3177[_15314 + uint2(3u, 0u)] = _9989.w.xxxx;
	                                _3177[_15314 + uint2(0u, 1u)] = _21804.x.xxxx;
	                                _3177[_15314 + uint2(1u, 1u)] = _21804.y.xxxx;
	                                _3177[_15314 + uint2(2u, 1u)] = _21804.z.xxxx;
	                                _3177[_15314 + uint2(3u, 1u)] = _21804.w.xxxx;
	                                _3177[_15314 + uint2(0u, 2u)] = _20892.x.xxxx;
	                                _3177[_15314 + uint2(1u, 2u)] = _20892.y.xxxx;
	                                _3177[_15314 + uint2(2u, 2u)] = _20892.z.xxxx;
	                                _3177[_15314 + uint2(3u, 2u)] = _20892.w.xxxx;
	                                _3177[_15314 + uint2(0u, 3u)] = _16202.x.xxxx;
	                                _3177[_15314 + uint2(1u, 3u)] = _16202.y.xxxx;
	                                _3177[_15314 + uint2(2u, 3u)] = _16202.z.xxxx;
	                                _3177[_15314 + uint2(3u, 3u)] = _16202.w.xxxx;
	                                _11521 = _13180;
	                                _14845 = _14844;
	                                _11405 = true;
	                                break;
	                            }
	                            else
	                            {
	                                uint2 _13670 = _19018 % uint2(32u, 32u);
	                                uint _21711;
	                                if (_13670.x < 16u)
	                                {
	                                    _21711 = (_13670.y < 16u) ? 0u : 2u;
	                                }
	                                else
	                                {
	                                    _21711 = (_13670.y < 16u) ? 1u : 3u;
	                                }
	                                uint _14384;
	                                if (_21711 == 0u)
	                                {
	                                    _14384 = (_21400 >> uint(15)) & 32767u;
	                                }
	                                else
	                                {
	                                    uint _12506;
	                                    if (_21711 == 1u)
	                                    {
	                                        _12506 = _21400 & 32767u;
	                                    }
	                                    else
	                                    {
	                                        uint _12505;
	                                        if (_21711 == 2u)
	                                        {
	                                            _12505 = (g_SST.Load(_21972 * 4 + 0) >> uint(15)) & 32767u;
	                                        }
	                                        else
	                                        {
	                                            _12505 = g_SST.Load(_21972 * 4 + 0) & 32767u;
	                                        }
	                                        _12506 = _12505;
	                                    }
	                                    _14384 = _12506;
	                                }
	                                _11521 = _13180;
	                                _14845 = _14384 + _11518;
	                                _11405 = false;
	                                break;
	                            }
	                            break; // unreachable workaround
	                        }
	                        break; // unreachable workaround
	                    } while(false);
	                    if (!_11405)
	                    {
	                        bool _11406;
	                        float3 _11522;
	                        float _13181;
	                        uint _14846;
	                        do
	                        {
	                            uint _21401 = g_SST.Load(_14845 * 4 + 0);
	                            bool _16061;
	                            do
	                            {
	                                if ((_21401 & 1073741824u) != 0u)
	                                {
	                                    _13181 = asfloat((_21401 & 3221225471u) << uint(2));
	                                    _16061 = true;
	                                    break;
	                                }
	                                _13181 = _13179;
	                                _16061 = false;
	                                break;
	                            } while(false);
	                            if (_16061)
	                            {
	                                float4 _10880 = _13181.xxxx;
	                                _3177[_15314] = _10880;
	                                _3177[_15314 + uint2(1u, 0u)] = _10880;
	                                _3177[_15314 + uint2(0u, 1u)] = _10880;
	                                _3177[_15314 + uint2(1u, 1u)] = _10880;
	                                _3177[_15314 + uint2(2u, 0u)] = _10880;
	                                _3177[_15314 + uint2(3u, 0u)] = _10880;
	                                _3177[_15314 + uint2(2u, 1u)] = _10880;
	                                _3177[_15314 + uint2(3u, 1u)] = _10880;
	                                _3177[_15314 + uint2(0u, 2u)] = _10880;
	                                _3177[_15314 + uint2(1u, 2u)] = _10880;
	                                _3177[_15314 + uint2(0u, 3u)] = _10880;
	                                _3177[_15314 + uint2(1u, 3u)] = _10880;
	                                _3177[_15314 + uint2(2u, 2u)] = _10880;
	                                _3177[_15314 + uint2(3u, 2u)] = _10880;
	                                _3177[_15314 + uint2(2u, 3u)] = _10880;
	                                _3177[_15314 + uint2(3u, 3u)] = _10880;
	                                _11522 = _11521;
	                                _14846 = _14845;
	                                _11406 = true;
	                                break;
	                            }
	                            else
	                            {
	                                uint _21973 = _14845 + 1u;
	                                float3 _13182;
	                                bool _16062;
	                                do
	                                {
	                                    if ((_21401 & 2147483648u) != 0u)
	                                    {
	                                        _13182 = float3(float((min16float)f16tof32(min16uint(g_SST.Load(_21973 * 4 + 0) >> uint(16)))), float((min16float)f16tof32(min16uint(g_SST.Load(_21973 * 4 + 0) & 65535u))), asfloat((_21401 & 2147483647u) << uint(1)));
	                                        _16062 = true;
	                                        break;
	                                    }
	                                    _13182 = _11521;
	                                    _16062 = false;
	                                    break;
	                                } while(false);
	                                if (_16062)
	                                {
	                                    uint2 _24340 = _19018 % uint2(16u, 16u);
	                                    float4 _22824 = _13182.xxxx * float4(0.0f, 1.0f, 2.0f, 3.0f);
	                                    float4 _22385 = ((_13182.z + (float(_24340.x) * _13182.x)) + (float(_24340.y) * _13182.y)).xxxx;
	                                    float4 _9990 = _22385 + _22824;
	                                    float4 _21805 = (_22385 + _13182.yyyy) + _22824;
	                                    float4 _20893 = (_22385 + (_13182.yyyy * 2.0f)) + _22824;
	                                    float4 _16203 = (_22385 + (_13182.yyyy * 3.0f)) + _22824;
	                                    _3177[_15314] = _9990.x.xxxx;
	                                    _3177[_15314 + uint2(1u, 0u)] = _9990.y.xxxx;
	                                    _3177[_15314 + uint2(2u, 0u)] = _9990.z.xxxx;
	                                    _3177[_15314 + uint2(3u, 0u)] = _9990.w.xxxx;
	                                    _3177[_15314 + uint2(0u, 1u)] = _21805.x.xxxx;
	                                    _3177[_15314 + uint2(1u, 1u)] = _21805.y.xxxx;
	                                    _3177[_15314 + uint2(2u, 1u)] = _21805.z.xxxx;
	                                    _3177[_15314 + uint2(3u, 1u)] = _21805.w.xxxx;
	                                    _3177[_15314 + uint2(0u, 2u)] = _20893.x.xxxx;
	                                    _3177[_15314 + uint2(1u, 2u)] = _20893.y.xxxx;
	                                    _3177[_15314 + uint2(2u, 2u)] = _20893.z.xxxx;
	                                    _3177[_15314 + uint2(3u, 2u)] = _20893.w.xxxx;
	                                    _3177[_15314 + uint2(0u, 3u)] = _16203.x.xxxx;
	                                    _3177[_15314 + uint2(1u, 3u)] = _16203.y.xxxx;
	                                    _3177[_15314 + uint2(2u, 3u)] = _16203.z.xxxx;
	                                    _3177[_15314 + uint2(3u, 3u)] = _16203.w.xxxx;
	                                    _11522 = _13182;
	                                    _14846 = _14845;
	                                    _11406 = true;
	                                    break;
	                                }
	                                else
	                                {
	                                    uint2 _13671 = _19018 % uint2(16u, 16u);
	                                    uint _21712;
	                                    if (_13671.x < 8u)
	                                    {
	                                        _21712 = (_13671.y < 8u) ? 0u : 2u;
	                                    }
	                                    else
	                                    {
	                                        _21712 = (_13671.y < 8u) ? 1u : 3u;
	                                    }
	                                    uint _14385;
	                                    if (_21712 == 0u)
	                                    {
	                                        _14385 = (_21401 >> uint(15)) & 32767u;
	                                    }
	                                    else
	                                    {
	                                        uint _12508;
	                                        if (_21712 == 1u)
	                                        {
	                                            _12508 = _21401 & 32767u;
	                                        }
	                                        else
	                                        {
	                                            uint _12507;
	                                            if (_21712 == 2u)
	                                            {
	                                                _12507 = (g_SST.Load(_21973 * 4 + 0) >> uint(15)) & 32767u;
	                                            }
	                                            else
	                                            {
	                                                _12507 = g_SST.Load(_21973 * 4 + 0) & 32767u;
	                                            }
	                                            _12508 = _12507;
	                                        }
	                                        _14385 = _12508;
	                                    }
	                                    _11522 = _13182;
	                                    _14846 = _14385 + _11518;
	                                    _11406 = false;
	                                    break;
	                                }
	                                break; // unreachable workaround
	                            }
	                            break; // unreachable workaround
	                        } while(false);
	                        if (!_11406)
	                        {
	                            bool _11407;
	                            uint _11523;
	                            float _13183;
	                            float3 _14847;
	                            do
	                            {
	                                uint _21402 = g_SST.Load(_14846 * 4 + 0);
	                                bool _16063;
	                                do
	                                {
	                                    if ((_21402 & 1073741824u) != 0u)
	                                    {
	                                        _13183 = asfloat((_21402 & 3221225471u) << uint(2));
	                                        _16063 = true;
	                                        break;
	                                    }
	                                    _13183 = _13181;
	                                    _16063 = false;
	                                    break;
	                                } while(false);
	                                if (_16063)
	                                {
	                                    float4 _10881 = _13183.xxxx;
	                                    _3177[_15314] = _10881;
	                                    _3177[_15314 + uint2(1u, 0u)] = _10881;
	                                    _3177[_15314 + uint2(0u, 1u)] = _10881;
	                                    _3177[_15314 + uint2(1u, 1u)] = _10881;
	                                    _3177[_15314 + uint2(2u, 0u)] = _10881;
	                                    _3177[_15314 + uint2(3u, 0u)] = _10881;
	                                    _3177[_15314 + uint2(2u, 1u)] = _10881;
	                                    _3177[_15314 + uint2(3u, 1u)] = _10881;
	                                    _3177[_15314 + uint2(0u, 2u)] = _10881;
	                                    _3177[_15314 + uint2(1u, 2u)] = _10881;
	                                    _3177[_15314 + uint2(0u, 3u)] = _10881;
	                                    _3177[_15314 + uint2(1u, 3u)] = _10881;
	                                    _3177[_15314 + uint2(2u, 2u)] = _10881;
	                                    _3177[_15314 + uint2(3u, 2u)] = _10881;
	                                    _3177[_15314 + uint2(2u, 3u)] = _10881;
	                                    _3177[_15314 + uint2(3u, 3u)] = _10881;
	                                    _11523 = _14846;
	                                    _14847 = _11522;
	                                    _11407 = true;
	                                    break;
	                                }
	                                else
	                                {
	                                    uint _21974 = _14846 + 1u;
	                                    float3 _13184;
	                                    bool _16064;
	                                    do
	                                    {
	                                        if ((_21402 & 2147483648u) != 0u)
	                                        {
	                                            _13184 = float3(float((min16float)f16tof32(min16uint(g_SST.Load(_21974 * 4 + 0) >> uint(16)))), float((min16float)f16tof32(min16uint(g_SST.Load(_21974 * 4 + 0) & 65535u))), asfloat((_21402 & 2147483647u) << uint(1)));
	                                            _16064 = true;
	                                            break;
	                                        }
	                                        _13184 = _11522;
	                                        _16064 = false;
	                                        break;
	                                    } while(false);
	                                    if (_16064)
	                                    {
	                                        uint2 _24341 = _19018 % uint2(8u, 8u);
	                                        float4 _22825 = _13184.xxxx * float4(0.0f, 1.0f, 2.0f, 3.0f);
	                                        float4 _22386 = ((_13184.z + (float(_24341.x) * _13184.x)) + (float(_24341.y) * _13184.y)).xxxx;
	                                        float4 _9991 = _22386 + _22825;
	                                        float4 _21806 = (_22386 + _13184.yyyy) + _22825;
	                                        float4 _20894 = (_22386 + (_13184.yyyy * 2.0f)) + _22825;
	                                        float4 _16204 = (_22386 + (_13184.yyyy * 3.0f)) + _22825;
	                                        _3177[_15314] = _9991.x.xxxx;
	                                        _3177[_15314 + uint2(1u, 0u)] = _9991.y.xxxx;
	                                        _3177[_15314 + uint2(2u, 0u)] = _9991.z.xxxx;
	                                        _3177[_15314 + uint2(3u, 0u)] = _9991.w.xxxx;
	                                        _3177[_15314 + uint2(0u, 1u)] = _21806.x.xxxx;
	                                        _3177[_15314 + uint2(1u, 1u)] = _21806.y.xxxx;
	                                        _3177[_15314 + uint2(2u, 1u)] = _21806.z.xxxx;
	                                        _3177[_15314 + uint2(3u, 1u)] = _21806.w.xxxx;
	                                        _3177[_15314 + uint2(0u, 2u)] = _20894.x.xxxx;
	                                        _3177[_15314 + uint2(1u, 2u)] = _20894.y.xxxx;
	                                        _3177[_15314 + uint2(2u, 2u)] = _20894.z.xxxx;
	                                        _3177[_15314 + uint2(3u, 2u)] = _20894.w.xxxx;
	                                        _3177[_15314 + uint2(0u, 3u)] = _16204.x.xxxx;
	                                        _3177[_15314 + uint2(1u, 3u)] = _16204.y.xxxx;
	                                        _3177[_15314 + uint2(2u, 3u)] = _16204.z.xxxx;
	                                        _3177[_15314 + uint2(3u, 3u)] = _16204.w.xxxx;
	                                        _11523 = _14846;
	                                        _14847 = _13184;
	                                        _11407 = true;
	                                        break;
	                                    }
	                                    else
	                                    {
	                                        uint2 _13672 = _19018 % uint2(8u, 8u);
	                                        uint _21713;
	                                        if (_13672.x < 4u)
	                                        {
	                                            _21713 = (_13672.y < 4u) ? 0u : 2u;
	                                        }
	                                        else
	                                        {
	                                            _21713 = (_13672.y < 4u) ? 1u : 3u;
	                                        }
	                                        uint _14386;
	                                        if (_21713 == 0u)
	                                        {
	                                            _14386 = (_21402 >> uint(15)) & 32767u;
	                                        }
	                                        else
	                                        {
	                                            uint _12510;
	                                            if (_21713 == 1u)
	                                            {
	                                                _12510 = _21402 & 32767u;
	                                            }
	                                            else
	                                            {
	                                                uint _12509;
	                                                if (_21713 == 2u)
	                                                {
	                                                    _12509 = (g_SST.Load(_21974 * 4 + 0) >> uint(15)) & 32767u;
	                                                }
	                                                else
	                                                {
	                                                    _12509 = g_SST.Load(_21974 * 4 + 0) & 32767u;
	                                                }
	                                                _12510 = _12509;
	                                            }
	                                            _14386 = _12510;
	                                        }
	                                        _11523 = _14386 + _11518;
	                                        _14847 = _13184;
	                                        _11407 = false;
	                                        break;
	                                    }
	                                    break; // unreachable workaround
	                                }
	                                break; // unreachable workaround
	                            } while(false);
	                            if (!_11407)
	                            {
	                                uint _21403 = g_SST.Load(_11523 * 4 + 0);
	                                float _13185;
	                                bool _16065;
	                                do
	                                {
	                                    if ((_21403 & 1073741824u) != 0u)
	                                    {
	                                        _13185 = asfloat((_21403 & 3221225471u) << uint(2));
	                                        _16065 = true;
	                                        break;
	                                    }
	                                    _13185 = _13183;
	                                    _16065 = false;
	                                    break;
	                                } while(false);
	                                if (_16065)
	                                {
	                                    float4 _10882 = _13185.xxxx;
	                                    _3177[_15314] = _10882;
	                                    _3177[_15314 + uint2(1u, 0u)] = _10882;
	                                    _3177[_15314 + uint2(0u, 1u)] = _10882;
	                                    _3177[_15314 + uint2(1u, 1u)] = _10882;
	                                    _3177[_15314 + uint2(2u, 0u)] = _10882;
	                                    _3177[_15314 + uint2(3u, 0u)] = _10882;
	                                    _3177[_15314 + uint2(2u, 1u)] = _10882;
	                                    _3177[_15314 + uint2(3u, 1u)] = _10882;
	                                    _3177[_15314 + uint2(0u, 2u)] = _10882;
	                                    _3177[_15314 + uint2(1u, 2u)] = _10882;
	                                    _3177[_15314 + uint2(0u, 3u)] = _10882;
	                                    _3177[_15314 + uint2(1u, 3u)] = _10882;
	                                    _3177[_15314 + uint2(2u, 2u)] = _10882;
	                                    _3177[_15314 + uint2(3u, 2u)] = _10882;
	                                    _3177[_15314 + uint2(2u, 3u)] = _10882;
	                                    _3177[_15314 + uint2(3u, 3u)] = _10882;
	                                }
	                                else
	                                {
	                                    uint _21975 = _11523 + 1u;
	                                    float3 _13186;
	                                    bool _16066;
	                                    do
	                                    {
	                                        if ((_21403 & 2147483648u) != 0u)
	                                        {
	                                            _13186 = float3(float((min16float)f16tof32(min16uint(g_SST.Load(_21975 * 4 + 0) >> uint(16)))), float((min16float)f16tof32(min16uint(g_SST.Load(_21975 * 4 + 0) & 65535u))), asfloat((_21403 & 2147483647u) << uint(1)));
	                                            _16066 = true;
	                                            break;
	                                        }
	                                        _13186 = _14847;
	                                        _16066 = false;
	                                        break;
	                                    } while(false);
	                                    if (_16066)
	                                    {
	                                        uint2 _24342 = _19018 % uint2(4u, 4u);
	                                        float4 _22826 = _13186.xxxx * float4(0.0f, 1.0f, 2.0f, 3.0f);
	                                        float4 _22387 = ((_13186.z + (float(_24342.x) * _13186.x)) + (float(_24342.y) * _13186.y)).xxxx;
	                                        float4 _9992 = _22387 + _22826;
	                                        float4 _21807 = (_22387 + _13186.yyyy) + _22826;
	                                        float4 _20895 = (_22387 + (_13186.yyyy * 2.0f)) + _22826;
	                                        float4 _16205 = (_22387 + (_13186.yyyy * 3.0f)) + _22826;
	                                        _3177[_15314] = _9992.x.xxxx;
	                                        _3177[_15314 + uint2(1u, 0u)] = _9992.y.xxxx;
	                                        _3177[_15314 + uint2(2u, 0u)] = _9992.z.xxxx;
	                                        _3177[_15314 + uint2(3u, 0u)] = _9992.w.xxxx;
	                                        _3177[_15314 + uint2(0u, 1u)] = _21807.x.xxxx;
	                                        _3177[_15314 + uint2(1u, 1u)] = _21807.y.xxxx;
	                                        _3177[_15314 + uint2(2u, 1u)] = _21807.z.xxxx;
	                                        _3177[_15314 + uint2(3u, 1u)] = _21807.w.xxxx;
	                                        _3177[_15314 + uint2(0u, 2u)] = _20895.x.xxxx;
	                                        _3177[_15314 + uint2(1u, 2u)] = _20895.y.xxxx;
	                                        _3177[_15314 + uint2(2u, 2u)] = _20895.z.xxxx;
	                                        _3177[_15314 + uint2(3u, 2u)] = _20895.w.xxxx;
	                                        _3177[_15314 + uint2(0u, 3u)] = _16205.x.xxxx;
	                                        _3177[_15314 + uint2(1u, 3u)] = _16205.y.xxxx;
	                                        _3177[_15314 + uint2(2u, 3u)] = _16205.z.xxxx;
	                                        _3177[_15314 + uint2(3u, 3u)] = _16205.w.xxxx;
	                                    }
	                                    else
	                                    {
	                                        if ((_21403 & 536870912u) != 0u)
	                                        {
	                                            uint _24813 = g_SST.Load(_21975 * 4 + 0);
	                                            uint _13655 = _11523 + 2u;
	                                            uint _6546 = g_SST.Load(_13655 * 4 + 0);
	                                            uint _13656 = _11523 + 3u;
	                                            uint _6547 = g_SST.Load(_13656 * 4 + 0);
	                                            uint _13657 = _11523 + 4u;
	                                            uint _16740 = g_SST.Load(_13657 * 4 + 0);
	                                            float4 _11451 = float((min16float)f16tof32(min16uint(_21403 & 32767u))).xxxx;
	                                            float4 _17844 = float((min16float)f16tof32(min16uint((_21403 >> uint(14)) & 32766u))).xxxx;
	                                            float4 _12210 = (_11451 * float4(float((_24813 >> uint(24)) & 255u), float((_24813 >> uint(16)) & 255u), float((_24813 >> uint(8)) & 255u), float(_24813 & 255u))) + _17844;
	                                            float4 _20116 = (_11451 * float4(float((_6546 >> uint(24)) & 255u), float((_6546 >> uint(16)) & 255u), float((_6546 >> uint(8)) & 255u), float(_6546 & 255u))) + _17844;
	                                            float4 _20117 = (_11451 * float4(float((_6547 >> uint(24)) & 255u), float((_6547 >> uint(16)) & 255u), float((_6547 >> uint(8)) & 255u), float(_6547 & 255u))) + _17844;
	                                            float4 _8748 = (_11451 * float4(float((_16740 >> uint(24)) & 255u), float((_16740 >> uint(16)) & 255u), float((_16740 >> uint(8)) & 255u), float(_16740 & 255u))) + _17844;
	                                            _3177[_15314] = _12210.x.xxxx;
	                                            _3177[_15314 + uint2(1u, 0u)] = _12210.y.xxxx;
	                                            _3177[_15314 + uint2(2u, 0u)] = _12210.z.xxxx;
	                                            _3177[_15314 + uint2(3u, 0u)] = _12210.w.xxxx;
	                                            _3177[_15314 + uint2(0u, 1u)] = _20116.x.xxxx;
	                                            _3177[_15314 + uint2(1u, 1u)] = _20116.y.xxxx;
	                                            _3177[_15314 + uint2(2u, 1u)] = _20116.z.xxxx;
	                                            _3177[_15314 + uint2(3u, 1u)] = _20116.w.xxxx;
	                                            _3177[_15314 + uint2(0u, 2u)] = _20117.x.xxxx;
	                                            _3177[_15314 + uint2(1u, 2u)] = _20117.y.xxxx;
	                                            _3177[_15314 + uint2(2u, 2u)] = _20117.z.xxxx;
	                                            _3177[_15314 + uint2(3u, 2u)] = _20117.w.xxxx;
	                                            _3177[_15314 + uint2(0u, 3u)] = _8748.x.xxxx;
	                                            _3177[_15314 + uint2(1u, 3u)] = _8748.y.xxxx;
	                                            _3177[_15314 + uint2(2u, 3u)] = _8748.z.xxxx;
	                                            _3177[_15314 + uint2(3u, 3u)] = _8748.w.xxxx;
	                                        }
	                                        else
	                                        {
	                                            uint _24812 = g_SST.Load(_21975 * 4 + 0);
	                                            uint _13648 = _11523 + 2u;
	                                            uint _6540 = g_SST.Load(_13648 * 4 + 0);
	                                            uint _13649 = _11523 + 3u;
	                                            uint _6541 = g_SST.Load(_13649 * 4 + 0);
	                                            uint _13650 = _11523 + 4u;
	                                            uint _6542 = g_SST.Load(_13650 * 4 + 0);
	                                            uint _13651 = _11523 + 5u;
	                                            uint _6543 = g_SST.Load(_13651 * 4 + 0);
	                                            uint _13652 = _11523 + 6u;
	                                            uint _6544 = g_SST.Load(_13652 * 4 + 0);
	                                            uint _13653 = _11523 + 7u;
	                                            uint _6545 = g_SST.Load(_13653 * 4 + 0);
	                                            uint _13654 = _11523 + 8u;
	                                            uint _16739 = g_SST.Load(_13654 * 4 + 0);
	                                            float4 _11450 = float((min16float)f16tof32(min16uint(_21403 & 32767u))).xxxx;
	                                            float4 _17843 = float((min16float)f16tof32(min16uint((_21403 >> uint(14)) & 32766u))).xxxx;
	                                            float4 _12209 = (_11450 * float4(float((_24812 >> uint(16)) & 65535u), float(_24812 & 65535u), float((_6540 >> uint(16)) & 65535u), float(_6540 & 65535u))) + _17843;
	                                            float4 _20114 = (_11450 * float4(float((_6541 >> uint(16)) & 65535u), float(_6541 & 65535u), float((_6542 >> uint(16)) & 65535u), float(_6542 & 65535u))) + _17843;
	                                            float4 _20115 = (_11450 * float4(float((_6543 >> uint(16)) & 65535u), float(_6543 & 65535u), float((_6544 >> uint(16)) & 65535u), float(_6544 & 65535u))) + _17843;
	                                            float4 _8747 = (_11450 * float4(float((_6545 >> uint(16)) & 65535u), float(_6545 & 65535u), float((_16739 >> uint(16)) & 65535u), float(_16739 & 65535u))) + _17843;
	                                            _3177[_15314] = _12209.x.xxxx;
	                                            _3177[_15314 + uint2(1u, 0u)] = _12209.y.xxxx;
	                                            _3177[_15314 + uint2(2u, 0u)] = _12209.z.xxxx;
	                                            _3177[_15314 + uint2(3u, 0u)] = _12209.w.xxxx;
	                                            _3177[_15314 + uint2(0u, 1u)] = _20114.x.xxxx;
	                                            _3177[_15314 + uint2(1u, 1u)] = _20114.y.xxxx;
	                                            _3177[_15314 + uint2(2u, 1u)] = _20114.z.xxxx;
	                                            _3177[_15314 + uint2(3u, 1u)] = _20114.w.xxxx;
	                                            _3177[_15314 + uint2(0u, 2u)] = _20115.x.xxxx;
	                                            _3177[_15314 + uint2(1u, 2u)] = _20115.y.xxxx;
	                                            _3177[_15314 + uint2(2u, 2u)] = _20115.z.xxxx;
	                                            _3177[_15314 + uint2(3u, 2u)] = _20115.w.xxxx;
	                                            _3177[_15314 + uint2(0u, 3u)] = _8747.x.xxxx;
	                                            _3177[_15314 + uint2(1u, 3u)] = _8747.y.xxxx;
	                                            _3177[_15314 + uint2(2u, 3u)] = _8747.z.xxxx;
	                                            _3177[_15314 + uint2(3u, 3u)] = _8747.w.xxxx;
	                                        }
	                                    }
	                                }
	                            }
	                        }
	                    }
	                }
	            }
	        }
	        break;
	    } while(false);
	}
	
	[numthreads(8, 8, 1)]
	void MainCs(SPIRV_Cross_Input stage_input)
	{
	    gl_GlobalInvocationID = stage_input.gl_GlobalInvocationID;
	    MainCs_inner();
	}
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
}
