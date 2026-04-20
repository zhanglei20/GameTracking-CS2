//=================================================================================================
// Reconstructed with Source 2 Viewer - https://valveresourceformat.github.io
//=================================================================================================
HEADER
{
	Description = "Generates scrambled halton samples";
	DevShader = true;
	Version = 0;
	
	// VcsVersion: 70
	// Platform: VULKAN_SM_60
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
	
	cbuffer PushConstants_t < Source(ExternalDescSet); Attribute("PushConstants_t"); >;
	RWTexture3D<float4> g_RandomSamples < Attribute("g_RandomSamples"); >;
	StructuredBuffer g_ScrambledHaltonPermutations < Attribute("g_ScrambledHaltonPermutations"); SrgbRead(false); >;
	
	// Source 2 Viewer - https://valveresourceformat.github.io
	// SPIR-V source (590860 bytes), HLSL reflection with SPIRV-Cross by KhronosGroup
	
	static float _2;
	
	ByteAddressBuffer g_ScrambledHaltonPermutations : register(t30, space0);
	cbuffer _1110_3863
	{
	    uint4 _3863_m0 : packoffset(c0);
	    uint4 _3863_m1 : packoffset(c1);
	    uint4 _3863_m2 : packoffset(c2);
	};
	
	RWTexture3D<float4> _3159 : register(u158, space0);
	
	static uint3 gl_GlobalInvocationID;
	struct SPIRV_Cross_Input
	{
	    uint3 gl_GlobalInvocationID : SV_DispatchThreadID;
	};
	
	void MainCs_inner()
	{
	    uint _22467 = gl_GlobalInvocationID.x & _3863_m0.x;
	    uint _16394 = gl_GlobalInvocationID.y & _3863_m0.x;
	    uint _20351 = (_22467 << uint(16)) | (_22467 >> uint(16));
	    uint _19542 = ((_20351 & 16711935u) << uint(8)) | ((_20351 & 4278255360u) >> uint(8));
	    uint _19543 = ((_19542 & 252645135u) << uint(4)) | ((_19542 & 4042322160u) >> uint(4));
	    uint _19544 = ((_19543 & 858993459u) << uint(2)) | ((_19543 & 3435973836u) >> uint(2));
	    uint _16324;
	    _16324 = 0u;
	    uint _6216;
	    uint _9062;
	    uint _19853;
	    uint _13136 = _16394;
	    uint _17017 = 0u;
	    for (;;)
	    {
	        if (!(_17017 < _3863_m0.z))
	        {
	            break;
	        }
	        _19853 = (_16324 * 3u) + (_13136 % 3u);
	        _9062 = _13136 / 3u;
	        _6216 = _17017 + 1u;
	        _13136 = _9062;
	        _16324 = _19853;
	        _17017 = _6216;
	        continue;
	    }
	    uint _12091 = uint(((uint64_t((((_19544 & 1431655765u) << uint(1)) | ((_19544 & 2863311530u) >> uint(1))) >> (32u - _3863_m0.y)) * uint64_t(_3863_m0.w)) + (uint64_t(_16324) * uint64_t(_3863_m1.x))) % uint64_t(_3863_m1.y)) + ((_3863_m2.x + 1u) * _3863_m1.y);
	    uint _7315 = 2u * gl_GlobalInvocationID.z;
	    float _19096;
	    do
	    {
	        float _19094;
	        bool _19095;
	        switch (_7315)
	        {
	            case 0u:
	            {
	                uint _20847 = (_12091 << uint(16)) | (_12091 >> uint(16));
	                uint _19545 = ((_20847 & 16711935u) << uint(8)) | ((_20847 & 4278255360u) >> uint(8));
	                uint _19546 = ((_19545 & 252645135u) << uint(4)) | ((_19545 & 4042322160u) >> uint(4));
	                uint _19547 = ((_19546 & 858993459u) << uint(2)) | ((_19546 & 3435973836u) >> uint(2));
	                _19094 = asfloat(1065353216u | ((((_19547 & 1431655765u) << uint(1)) | ((_19547 & 2863311530u) >> uint(1))) >> uint(9))) - 1.0f;
	                _19095 = true;
	                break;
	            }
	            case 1u:
	            {
	                uint _23883 = _12091 % 243u;
	                uint _19051 = _23883 / 2u;
	                uint _19058;
	                if ((_23883 & 1u) != 0u)
	                {
	                    _19058 = g_ScrambledHaltonPermutations.Load(_19051 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _19058 = g_ScrambledHaltonPermutations.Load(_19051 * 4 + 0) & 65535u;
	                }
	                uint _9661 = (_12091 / 243u) % 243u;
	                uint _21793 = _9661 / 2u;
	                uint _19067;
	                if ((_9661 & 1u) != 0u)
	                {
	                    _19067 = g_ScrambledHaltonPermutations.Load(_21793 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _19067 = g_ScrambledHaltonPermutations.Load(_21793 * 4 + 0) & 65535u;
	                }
	                uint _25181 = (_12091 / 59049u) % 243u;
	                uint _21795 = _25181 / 2u;
	                uint _19075;
	                if ((_25181 & 1u) != 0u)
	                {
	                    _19075 = g_ScrambledHaltonPermutations.Load(_21795 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _19075 = g_ScrambledHaltonPermutations.Load(_21795 * 4 + 0) & 65535u;
	                }
	                uint _25182 = (_12091 / 14348907u) % 243u;
	                uint _21797 = _25182 / 2u;
	                uint _19083;
	                if ((_25182 & 1u) != 0u)
	                {
	                    _19083 = g_ScrambledHaltonPermutations.Load(_21797 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _19083 = g_ScrambledHaltonPermutations.Load(_21797 * 4 + 0) & 65535u;
	                }
	                _19094 = float((((_19058 * 14348907u) + (_19067 * 59049u)) + (_19075 * 243u)) + _19083) * 2.8679716934654209126165369525552e-10f;
	                _19095 = true;
	                break;
	            }
	            case 2u:
	            {
	                uint _19010 = 243u + (_12091 % 125u);
	                uint _19011 = _19010 / 2u;
	                uint _19018;
	                if ((_19010 & 1u) != 0u)
	                {
	                    _19018 = g_ScrambledHaltonPermutations.Load(_19011 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _19018 = g_ScrambledHaltonPermutations.Load(_19011 * 4 + 0) & 65535u;
	                }
	                uint _20844 = 243u + ((_12091 / 125u) % 125u);
	                uint _19022 = _20844 / 2u;
	                uint _19029;
	                if ((_20844 & 1u) != 0u)
	                {
	                    _19029 = g_ScrambledHaltonPermutations.Load(_19022 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _19029 = g_ScrambledHaltonPermutations.Load(_19022 * 4 + 0) & 65535u;
	                }
	                uint _20845 = 243u + ((_12091 / 15625u) % 125u);
	                uint _19032 = _20845 / 2u;
	                uint _19039;
	                if ((_20845 & 1u) != 0u)
	                {
	                    _19039 = g_ScrambledHaltonPermutations.Load(_19032 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _19039 = g_ScrambledHaltonPermutations.Load(_19032 * 4 + 0) & 65535u;
	                }
	                uint _20846 = 243u + ((_12091 / 1953125u) % 125u);
	                uint _19041 = _20846 / 2u;
	                uint _19048;
	                if ((_20846 & 1u) != 0u)
	                {
	                    _19048 = g_ScrambledHaltonPermutations.Load(_19041 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _19048 = g_ScrambledHaltonPermutations.Load(_19041 * 4 + 0) & 65535u;
	                }
	                _19094 = float((((_19018 * 1953125u) + (_19029 * 15625u)) + (_19039 * 125u)) + _19048) * 4.0959995395439818821614608168602e-09f;
	                _19095 = true;
	                break;
	            }
	            case 3u:
	            {
	                uint _18979 = 368u + (_12091 % 343u);
	                uint _18980 = _18979 / 2u;
	                uint _18987;
	                if ((_18979 & 1u) != 0u)
	                {
	                    _18987 = g_ScrambledHaltonPermutations.Load(_18980 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _18987 = g_ScrambledHaltonPermutations.Load(_18980 * 4 + 0) & 65535u;
	                }
	                uint _20842 = 368u + ((_12091 / 343u) % 343u);
	                uint _18991 = _20842 / 2u;
	                uint _18998;
	                if ((_20842 & 1u) != 0u)
	                {
	                    _18998 = g_ScrambledHaltonPermutations.Load(_18991 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _18998 = g_ScrambledHaltonPermutations.Load(_18991 * 4 + 0) & 65535u;
	                }
	                uint _20843 = 368u + ((_12091 / 117649u) % 343u);
	                uint _19000 = _20843 / 2u;
	                uint _19007;
	                if ((_20843 & 1u) != 0u)
	                {
	                    _19007 = g_ScrambledHaltonPermutations.Load(_19000 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _19007 = g_ScrambledHaltonPermutations.Load(_19000 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_18987 * 117649u) + (_18998 * 343u)) + _19007) * 2.47809293085765602882020175457e-08f;
	                _19095 = true;
	                break;
	            }
	            case 4u:
	            {
	                uint _18939 = 711u + (_12091 % 121u);
	                uint _18940 = _18939 / 2u;
	                uint _18947;
	                if ((_18939 & 1u) != 0u)
	                {
	                    _18947 = g_ScrambledHaltonPermutations.Load(_18940 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _18947 = g_ScrambledHaltonPermutations.Load(_18940 * 4 + 0) & 65535u;
	                }
	                uint _20839 = 711u + ((_12091 / 121u) % 121u);
	                uint _18951 = _20839 / 2u;
	                uint _18958;
	                if ((_20839 & 1u) != 0u)
	                {
	                    _18958 = g_ScrambledHaltonPermutations.Load(_18951 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _18958 = g_ScrambledHaltonPermutations.Load(_18951 * 4 + 0) & 65535u;
	                }
	                uint _20840 = 711u + ((_12091 / 14641u) % 121u);
	                uint _18960 = _20840 / 2u;
	                uint _18967;
	                if ((_20840 & 1u) != 0u)
	                {
	                    _18967 = g_ScrambledHaltonPermutations.Load(_18960 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _18967 = g_ScrambledHaltonPermutations.Load(_18960 * 4 + 0) & 65535u;
	                }
	                uint _20841 = 711u + ((_12091 / 1771561u) % 121u);
	                uint _18969 = _20841 / 2u;
	                uint _18976;
	                if ((_20841 & 1u) != 0u)
	                {
	                    _18976 = g_ScrambledHaltonPermutations.Load(_18969 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _18976 = g_ScrambledHaltonPermutations.Load(_18969 * 4 + 0) & 65535u;
	                }
	                _19094 = float((((_18947 * 1771561u) + (_18958 * 14641u)) + (_18967 * 121u)) + _18976) * 4.6650732166142461210256442427635e-09f;
	                _19095 = true;
	                break;
	            }
	            case 5u:
	            {
	                uint _18899 = 832u + (_12091 % 169u);
	                uint _18900 = _18899 / 2u;
	                uint _18907;
	                if ((_18899 & 1u) != 0u)
	                {
	                    _18907 = g_ScrambledHaltonPermutations.Load(_18900 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _18907 = g_ScrambledHaltonPermutations.Load(_18900 * 4 + 0) & 65535u;
	                }
	                uint _20836 = 832u + ((_12091 / 169u) % 169u);
	                uint _18911 = _20836 / 2u;
	                uint _18918;
	                if ((_20836 & 1u) != 0u)
	                {
	                    _18918 = g_ScrambledHaltonPermutations.Load(_18911 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _18918 = g_ScrambledHaltonPermutations.Load(_18911 * 4 + 0) & 65535u;
	                }
	                uint _20837 = 832u + ((_12091 / 28561u) % 169u);
	                uint _18920 = _20837 / 2u;
	                uint _18927;
	                if ((_20837 & 1u) != 0u)
	                {
	                    _18927 = g_ScrambledHaltonPermutations.Load(_18920 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _18927 = g_ScrambledHaltonPermutations.Load(_18920 * 4 + 0) & 65535u;
	                }
	                uint _20838 = 832u + ((_12091 / 4826809u) % 169u);
	                uint _18929 = _20838 / 2u;
	                uint _18936;
	                if ((_20838 & 1u) != 0u)
	                {
	                    _18936 = g_ScrambledHaltonPermutations.Load(_18929 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _18936 = g_ScrambledHaltonPermutations.Load(_18929 * 4 + 0) & 65535u;
	                }
	                _19094 = float((((_18907 * 4826809u) + (_18918 * 28561u)) + (_18927 * 169u)) + _18936) * 1.2258944970255924999946728348732e-09f;
	                _19095 = true;
	                break;
	            }
	            case 6u:
	            {
	                uint _18869 = 1001u + (_12091 % 289u);
	                uint _18870 = _18869 / 2u;
	                uint _18877;
	                if ((_18869 & 1u) != 0u)
	                {
	                    _18877 = g_ScrambledHaltonPermutations.Load(_18870 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _18877 = g_ScrambledHaltonPermutations.Load(_18870 * 4 + 0) & 65535u;
	                }
	                uint _20834 = 1001u + ((_12091 / 289u) % 289u);
	                uint _18881 = _20834 / 2u;
	                uint _18888;
	                if ((_20834 & 1u) != 0u)
	                {
	                    _18888 = g_ScrambledHaltonPermutations.Load(_18881 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _18888 = g_ScrambledHaltonPermutations.Load(_18881 * 4 + 0) & 65535u;
	                }
	                uint _20835 = 1001u + ((_12091 / 83521u) % 289u);
	                uint _18890 = _20835 / 2u;
	                uint _18897;
	                if ((_20835 & 1u) != 0u)
	                {
	                    _18897 = g_ScrambledHaltonPermutations.Load(_18890 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _18897 = g_ScrambledHaltonPermutations.Load(_18890 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_18877 * 83521u) + (_18888 * 289u)) + _18897) * 4.1429188968322705477476119995117e-08f;
	                _19095 = true;
	                break;
	            }
	            case 7u:
	            {
	                uint _18839 = 1290u + (_12091 % 361u);
	                uint _18840 = _18839 / 2u;
	                uint _18847;
	                if ((_18839 & 1u) != 0u)
	                {
	                    _18847 = g_ScrambledHaltonPermutations.Load(_18840 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _18847 = g_ScrambledHaltonPermutations.Load(_18840 * 4 + 0) & 65535u;
	                }
	                uint _20832 = 1290u + ((_12091 / 361u) % 361u);
	                uint _18851 = _20832 / 2u;
	                uint _18858;
	                if ((_20832 & 1u) != 0u)
	                {
	                    _18858 = g_ScrambledHaltonPermutations.Load(_18851 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _18858 = g_ScrambledHaltonPermutations.Load(_18851 * 4 + 0) & 65535u;
	                }
	                uint _20833 = 1290u + ((_12091 / 130321u) % 361u);
	                uint _18860 = _20833 / 2u;
	                uint _18867;
	                if ((_20833 & 1u) != 0u)
	                {
	                    _18867 = g_ScrambledHaltonPermutations.Load(_18860 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _18867 = g_ScrambledHaltonPermutations.Load(_18860 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_18847 * 130321u) + (_18858 * 361u)) + _18867) * 2.1255843307699251454323530197144e-08f;
	                _19095 = true;
	                break;
	            }
	            case 8u:
	            {
	                uint _18773 = 1651u + (_12091 % 23u);
	                uint _18774 = _18773 / 2u;
	                uint _18781;
	                if ((_18773 & 1u) != 0u)
	                {
	                    _18781 = g_ScrambledHaltonPermutations.Load(_18774 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _18781 = g_ScrambledHaltonPermutations.Load(_18774 * 4 + 0) & 65535u;
	                }
	                uint _20826 = 1651u + ((_12091 / 23u) % 23u);
	                uint _18785 = _20826 / 2u;
	                uint _18792;
	                if ((_20826 & 1u) != 0u)
	                {
	                    _18792 = g_ScrambledHaltonPermutations.Load(_18785 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _18792 = g_ScrambledHaltonPermutations.Load(_18785 * 4 + 0) & 65535u;
	                }
	                uint _20827 = 1651u + ((_12091 / 529u) % 23u);
	                uint _18794 = _20827 / 2u;
	                uint _18801;
	                if ((_20827 & 1u) != 0u)
	                {
	                    _18801 = g_ScrambledHaltonPermutations.Load(_18794 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _18801 = g_ScrambledHaltonPermutations.Load(_18794 * 4 + 0) & 65535u;
	                }
	                uint _20828 = 1651u + ((_12091 / 12167u) % 23u);
	                uint _18803 = _20828 / 2u;
	                uint _18810;
	                if ((_20828 & 1u) != 0u)
	                {
	                    _18810 = g_ScrambledHaltonPermutations.Load(_18803 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _18810 = g_ScrambledHaltonPermutations.Load(_18803 * 4 + 0) & 65535u;
	                }
	                uint _20829 = 1651u + ((_12091 / 279841u) % 23u);
	                uint _18812 = _20829 / 2u;
	                uint _18819;
	                if ((_20829 & 1u) != 0u)
	                {
	                    _18819 = g_ScrambledHaltonPermutations.Load(_18812 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _18819 = g_ScrambledHaltonPermutations.Load(_18812 * 4 + 0) & 65535u;
	                }
	                uint _20830 = 1651u + ((_12091 / 6436343u) % 23u);
	                uint _18821 = _20830 / 2u;
	                uint _18828;
	                if ((_20830 & 1u) != 0u)
	                {
	                    _18828 = g_ScrambledHaltonPermutations.Load(_18821 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _18828 = g_ScrambledHaltonPermutations.Load(_18821 * 4 + 0) & 65535u;
	                }
	                uint _20831 = 1651u + ((_12091 / 148035889u) % 23u);
	                uint _18830 = _20831 / 2u;
	                uint _18837;
	                if ((_20831 & 1u) != 0u)
	                {
	                    _18837 = g_ScrambledHaltonPermutations.Load(_18830 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _18837 = g_ScrambledHaltonPermutations.Load(_18830 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((((((_18781 * 148035889u) + (_18792 * 6436343u)) + (_18801 * 279841u)) + (_18810 * 12167u)) + (_18819 * 529u)) + (_18828 * 23u)) + _18837) * 2.9370078591384185529022943228483e-10f;
	                _19095 = true;
	                break;
	            }
	            case 9u:
	            {
	                uint _18716 = 1674u + (_12091 % 29u);
	                uint _18717 = _18716 / 2u;
	                uint _18724;
	                if ((_18716 & 1u) != 0u)
	                {
	                    _18724 = g_ScrambledHaltonPermutations.Load(_18717 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _18724 = g_ScrambledHaltonPermutations.Load(_18717 * 4 + 0) & 65535u;
	                }
	                uint _20821 = 1674u + ((_12091 / 29u) % 29u);
	                uint _18728 = _20821 / 2u;
	                uint _18735;
	                if ((_20821 & 1u) != 0u)
	                {
	                    _18735 = g_ScrambledHaltonPermutations.Load(_18728 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _18735 = g_ScrambledHaltonPermutations.Load(_18728 * 4 + 0) & 65535u;
	                }
	                uint _20822 = 1674u + ((_12091 / 841u) % 29u);
	                uint _18737 = _20822 / 2u;
	                uint _18744;
	                if ((_20822 & 1u) != 0u)
	                {
	                    _18744 = g_ScrambledHaltonPermutations.Load(_18737 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _18744 = g_ScrambledHaltonPermutations.Load(_18737 * 4 + 0) & 65535u;
	                }
	                uint _20823 = 1674u + ((_12091 / 24389u) % 29u);
	                uint _18746 = _20823 / 2u;
	                uint _18753;
	                if ((_20823 & 1u) != 0u)
	                {
	                    _18753 = g_ScrambledHaltonPermutations.Load(_18746 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _18753 = g_ScrambledHaltonPermutations.Load(_18746 * 4 + 0) & 65535u;
	                }
	                uint _20824 = 1674u + ((_12091 / 707281u) % 29u);
	                uint _18755 = _20824 / 2u;
	                uint _18762;
	                if ((_20824 & 1u) != 0u)
	                {
	                    _18762 = g_ScrambledHaltonPermutations.Load(_18755 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _18762 = g_ScrambledHaltonPermutations.Load(_18755 * 4 + 0) & 65535u;
	                }
	                uint _20825 = 1674u + ((_12091 / 20511149u) % 29u);
	                uint _18764 = _20825 / 2u;
	                uint _18771;
	                if ((_20825 & 1u) != 0u)
	                {
	                    _18771 = g_ScrambledHaltonPermutations.Load(_18764 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _18771 = g_ScrambledHaltonPermutations.Load(_18764 * 4 + 0) & 65535u;
	                }
	                _19094 = float((((((_18724 * 20511149u) + (_18735 * 707281u)) + (_18744 * 24389u)) + (_18753 * 841u)) + (_18762 * 29u)) + _18771) * 1.6811713132725003561063203960657e-09f;
	                _19095 = true;
	                break;
	            }
	            case 10u:
	            {
	                uint _18659 = 1703u + (_12091 % 31u);
	                uint _18660 = _18659 / 2u;
	                uint _18667;
	                if ((_18659 & 1u) != 0u)
	                {
	                    _18667 = g_ScrambledHaltonPermutations.Load(_18660 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _18667 = g_ScrambledHaltonPermutations.Load(_18660 * 4 + 0) & 65535u;
	                }
	                uint _20816 = 1703u + ((_12091 / 31u) % 31u);
	                uint _18671 = _20816 / 2u;
	                uint _18678;
	                if ((_20816 & 1u) != 0u)
	                {
	                    _18678 = g_ScrambledHaltonPermutations.Load(_18671 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _18678 = g_ScrambledHaltonPermutations.Load(_18671 * 4 + 0) & 65535u;
	                }
	                uint _20817 = 1703u + ((_12091 / 961u) % 31u);
	                uint _18680 = _20817 / 2u;
	                uint _18687;
	                if ((_20817 & 1u) != 0u)
	                {
	                    _18687 = g_ScrambledHaltonPermutations.Load(_18680 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _18687 = g_ScrambledHaltonPermutations.Load(_18680 * 4 + 0) & 65535u;
	                }
	                uint _20818 = 1703u + ((_12091 / 29791u) % 31u);
	                uint _18689 = _20818 / 2u;
	                uint _18696;
	                if ((_20818 & 1u) != 0u)
	                {
	                    _18696 = g_ScrambledHaltonPermutations.Load(_18689 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _18696 = g_ScrambledHaltonPermutations.Load(_18689 * 4 + 0) & 65535u;
	                }
	                uint _20819 = 1703u + ((_12091 / 923521u) % 31u);
	                uint _18698 = _20819 / 2u;
	                uint _18705;
	                if ((_20819 & 1u) != 0u)
	                {
	                    _18705 = g_ScrambledHaltonPermutations.Load(_18698 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _18705 = g_ScrambledHaltonPermutations.Load(_18698 * 4 + 0) & 65535u;
	                }
	                uint _20820 = 1703u + ((_12091 / 28629151u) % 31u);
	                uint _18707 = _20820 / 2u;
	                uint _18714;
	                if ((_20820 & 1u) != 0u)
	                {
	                    _18714 = g_ScrambledHaltonPermutations.Load(_18707 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _18714 = g_ScrambledHaltonPermutations.Load(_18707 * 4 + 0) & 65535u;
	                }
	                _19094 = float((((((_18667 * 28629151u) + (_18678 * 923521u)) + (_18687 * 29791u)) + (_18696 * 961u)) + (_18705 * 31u)) + _18714) * 1.126755799774059596529696136713e-09f;
	                _19095 = true;
	                break;
	            }
	            case 11u:
	            {
	                uint _18601 = 1734u + (_12091 % 37u);
	                uint _18602 = _18601 / 2u;
	                uint _18609;
	                if ((_18601 & 1u) != 0u)
	                {
	                    _18609 = g_ScrambledHaltonPermutations.Load(_18602 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _18609 = g_ScrambledHaltonPermutations.Load(_18602 * 4 + 0) & 65535u;
	                }
	                uint _20811 = 1734u + ((_12091 / 37u) % 37u);
	                uint _18613 = _20811 / 2u;
	                uint _18621;
	                if ((_20811 & 1u) != 0u)
	                {
	                    _18621 = g_ScrambledHaltonPermutations.Load(_18613 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _18621 = g_ScrambledHaltonPermutations.Load(_18613 * 4 + 0) & 65535u;
	                }
	                uint _20812 = 1734u + ((_12091 / 1369u) % 37u);
	                uint _18623 = _20812 / 2u;
	                uint _18630;
	                if ((_20812 & 1u) != 0u)
	                {
	                    _18630 = g_ScrambledHaltonPermutations.Load(_18623 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _18630 = g_ScrambledHaltonPermutations.Load(_18623 * 4 + 0) & 65535u;
	                }
	                uint _20813 = 1734u + ((_12091 / 50653u) % 37u);
	                uint _18632 = _20813 / 2u;
	                uint _18639;
	                if ((_20813 & 1u) != 0u)
	                {
	                    _18639 = g_ScrambledHaltonPermutations.Load(_18632 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _18639 = g_ScrambledHaltonPermutations.Load(_18632 * 4 + 0) & 65535u;
	                }
	                uint _20814 = 1734u + ((_12091 / 1874161u) % 37u);
	                uint _18641 = _20814 / 2u;
	                uint _18648;
	                if ((_20814 & 1u) != 0u)
	                {
	                    _18648 = g_ScrambledHaltonPermutations.Load(_18641 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _18648 = g_ScrambledHaltonPermutations.Load(_18641 * 4 + 0) & 65535u;
	                }
	                uint _20815 = 1734u + ((_12091 / 69343957u) % 37u);
	                uint _18650 = _20815 / 2u;
	                uint _18657;
	                if ((_20815 & 1u) != 0u)
	                {
	                    _18657 = g_ScrambledHaltonPermutations.Load(_18650 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _18657 = g_ScrambledHaltonPermutations.Load(_18650 * 4 + 0) & 65535u;
	                }
	                _19094 = float((((((_18609 * 69343957u) + (_18621 * 1874161u)) + (_18630 * 50653u)) + (_18639 * 1369u)) + (_18648 * 37u)) + _18657) * 3.8975311866806805483065545558929e-10f;
	                _19095 = true;
	                break;
	            }
	            case 12u:
	            {
	                uint _18550 = 1771u + (_12091 % 41u);
	                uint _18551 = _18550 / 2u;
	                uint _18558;
	                if ((_18550 & 1u) != 0u)
	                {
	                    _18558 = g_ScrambledHaltonPermutations.Load(_18551 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _18558 = g_ScrambledHaltonPermutations.Load(_18551 * 4 + 0) & 65535u;
	                }
	                uint _20807 = 1771u + ((_12091 / 41u) % 41u);
	                uint _18565 = _20807 / 2u;
	                uint _18572;
	                if ((_20807 & 1u) != 0u)
	                {
	                    _18572 = g_ScrambledHaltonPermutations.Load(_18565 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _18572 = g_ScrambledHaltonPermutations.Load(_18565 * 4 + 0) & 65535u;
	                }
	                uint _20808 = 1771u + ((_12091 / 1681u) % 41u);
	                uint _18574 = _20808 / 2u;
	                uint _18581;
	                if ((_20808 & 1u) != 0u)
	                {
	                    _18581 = g_ScrambledHaltonPermutations.Load(_18574 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _18581 = g_ScrambledHaltonPermutations.Load(_18574 * 4 + 0) & 65535u;
	                }
	                uint _20809 = 1771u + ((_12091 / 68921u) % 41u);
	                uint _18583 = _20809 / 2u;
	                uint _18590;
	                if ((_20809 & 1u) != 0u)
	                {
	                    _18590 = g_ScrambledHaltonPermutations.Load(_18583 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _18590 = g_ScrambledHaltonPermutations.Load(_18583 * 4 + 0) & 65535u;
	                }
	                uint _20810 = 1771u + ((_12091 / 2825761u) % 41u);
	                uint _18592 = _20810 / 2u;
	                uint _18599;
	                if ((_20810 & 1u) != 0u)
	                {
	                    _18599 = g_ScrambledHaltonPermutations.Load(_18592 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _18599 = g_ScrambledHaltonPermutations.Load(_18592 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((((_18558 * 2825761u) + (_18572 * 68921u)) + (_18581 * 1681u)) + (_18590 * 41u)) + _18599) * 8.631388936919393017888069152832e-09f;
	                _19095 = true;
	                break;
	            }
	            case 13u:
	            {
	                uint _18502 = 1812u + (_12091 % 43u);
	                uint _18503 = _18502 / 2u;
	                uint _18510;
	                if ((_18502 & 1u) != 0u)
	                {
	                    _18510 = g_ScrambledHaltonPermutations.Load(_18503 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _18510 = g_ScrambledHaltonPermutations.Load(_18503 * 4 + 0) & 65535u;
	                }
	                uint _20803 = 1812u + ((_12091 / 43u) % 43u);
	                uint _18514 = _20803 / 2u;
	                uint _18521;
	                if ((_20803 & 1u) != 0u)
	                {
	                    _18521 = g_ScrambledHaltonPermutations.Load(_18514 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _18521 = g_ScrambledHaltonPermutations.Load(_18514 * 4 + 0) & 65535u;
	                }
	                uint _20804 = 1812u + ((_12091 / 1849u) % 43u);
	                uint _18523 = _20804 / 2u;
	                uint _18530;
	                if ((_20804 & 1u) != 0u)
	                {
	                    _18530 = g_ScrambledHaltonPermutations.Load(_18523 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _18530 = g_ScrambledHaltonPermutations.Load(_18523 * 4 + 0) & 65535u;
	                }
	                uint _20805 = 1812u + ((_12091 / 79507u) % 43u);
	                uint _18532 = _20805 / 2u;
	                uint _18539;
	                if ((_20805 & 1u) != 0u)
	                {
	                    _18539 = g_ScrambledHaltonPermutations.Load(_18532 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _18539 = g_ScrambledHaltonPermutations.Load(_18532 * 4 + 0) & 65535u;
	                }
	                uint _20806 = 1812u + ((_12091 / 3418801u) % 43u);
	                uint _18541 = _20806 / 2u;
	                uint _18548;
	                if ((_20806 & 1u) != 0u)
	                {
	                    _18548 = g_ScrambledHaltonPermutations.Load(_18541 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _18548 = g_ScrambledHaltonPermutations.Load(_18541 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((((_18510 * 3418801u) + (_18521 * 79507u)) + (_18530 * 1849u)) + (_18539 * 43u)) + _18548) * 6.8023293664509765221737325191498e-09f;
	                _19095 = true;
	                break;
	            }
	            case 14u:
	            {
	                uint _18454 = 1855u + (_12091 % 47u);
	                uint _18455 = _18454 / 2u;
	                uint _18462;
	                if ((_18454 & 1u) != 0u)
	                {
	                    _18462 = g_ScrambledHaltonPermutations.Load(_18455 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _18462 = g_ScrambledHaltonPermutations.Load(_18455 * 4 + 0) & 65535u;
	                }
	                uint _20799 = 1855u + ((_12091 / 47u) % 47u);
	                uint _18466 = _20799 / 2u;
	                uint _18473;
	                if ((_20799 & 1u) != 0u)
	                {
	                    _18473 = g_ScrambledHaltonPermutations.Load(_18466 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _18473 = g_ScrambledHaltonPermutations.Load(_18466 * 4 + 0) & 65535u;
	                }
	                uint _20800 = 1855u + ((_12091 / 2209u) % 47u);
	                uint _18475 = _20800 / 2u;
	                uint _18482;
	                if ((_20800 & 1u) != 0u)
	                {
	                    _18482 = g_ScrambledHaltonPermutations.Load(_18475 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _18482 = g_ScrambledHaltonPermutations.Load(_18475 * 4 + 0) & 65535u;
	                }
	                uint _20801 = 1855u + ((_12091 / 103823u) % 47u);
	                uint _18484 = _20801 / 2u;
	                uint _18491;
	                if ((_20801 & 1u) != 0u)
	                {
	                    _18491 = g_ScrambledHaltonPermutations.Load(_18484 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _18491 = g_ScrambledHaltonPermutations.Load(_18484 * 4 + 0) & 65535u;
	                }
	                uint _20802 = 1855u + ((_12091 / 4879681u) % 47u);
	                uint _18493 = _20802 / 2u;
	                uint _18500;
	                if ((_20802 & 1u) != 0u)
	                {
	                    _18500 = g_ScrambledHaltonPermutations.Load(_18493 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _18500 = g_ScrambledHaltonPermutations.Load(_18493 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((((_18462 * 4879681u) + (_18473 * 103823u)) + (_18482 * 2209u)) + (_18491 * 47u)) + _18500) * 4.3602428334565956902224570512772e-09f;
	                _19095 = true;
	                break;
	            }
	            case 15u:
	            {
	                uint _18406 = 1902u + (_12091 % 53u);
	                uint _18407 = _18406 / 2u;
	                uint _18414;
	                if ((_18406 & 1u) != 0u)
	                {
	                    _18414 = g_ScrambledHaltonPermutations.Load(_18407 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _18414 = g_ScrambledHaltonPermutations.Load(_18407 * 4 + 0) & 65535u;
	                }
	                uint _20795 = 1902u + ((_12091 / 53u) % 53u);
	                uint _18418 = _20795 / 2u;
	                uint _18425;
	                if ((_20795 & 1u) != 0u)
	                {
	                    _18425 = g_ScrambledHaltonPermutations.Load(_18418 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _18425 = g_ScrambledHaltonPermutations.Load(_18418 * 4 + 0) & 65535u;
	                }
	                uint _20796 = 1902u + ((_12091 / 2809u) % 53u);
	                uint _18427 = _20796 / 2u;
	                uint _18434;
	                if ((_20796 & 1u) != 0u)
	                {
	                    _18434 = g_ScrambledHaltonPermutations.Load(_18427 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _18434 = g_ScrambledHaltonPermutations.Load(_18427 * 4 + 0) & 65535u;
	                }
	                uint _20797 = 1902u + ((_12091 / 148877u) % 53u);
	                uint _18436 = _20797 / 2u;
	                uint _18443;
	                if ((_20797 & 1u) != 0u)
	                {
	                    _18443 = g_ScrambledHaltonPermutations.Load(_18436 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _18443 = g_ScrambledHaltonPermutations.Load(_18436 * 4 + 0) & 65535u;
	                }
	                uint _20798 = 1902u + ((_12091 / 7890481u) % 53u);
	                uint _18445 = _20798 / 2u;
	                uint _18452;
	                if ((_20798 & 1u) != 0u)
	                {
	                    _18452 = g_ScrambledHaltonPermutations.Load(_18445 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _18452 = g_ScrambledHaltonPermutations.Load(_18445 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((((_18414 * 7890481u) + (_18425 * 148877u)) + (_18434 * 2809u)) + (_18443 * 53u)) + _18452) * 2.3912258839686728606466203927994e-09f;
	                _19095 = true;
	                break;
	            }
	            case 16u:
	            {
	                uint _18358 = 1955u + (_12091 % 59u);
	                uint _18359 = _18358 / 2u;
	                uint _18366;
	                if ((_18358 & 1u) != 0u)
	                {
	                    _18366 = g_ScrambledHaltonPermutations.Load(_18359 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _18366 = g_ScrambledHaltonPermutations.Load(_18359 * 4 + 0) & 65535u;
	                }
	                uint _20791 = 1955u + ((_12091 / 59u) % 59u);
	                uint _18370 = _20791 / 2u;
	                uint _18377;
	                if ((_20791 & 1u) != 0u)
	                {
	                    _18377 = g_ScrambledHaltonPermutations.Load(_18370 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _18377 = g_ScrambledHaltonPermutations.Load(_18370 * 4 + 0) & 65535u;
	                }
	                uint _20792 = 1955u + ((_12091 / 3481u) % 59u);
	                uint _18379 = _20792 / 2u;
	                uint _18386;
	                if ((_20792 & 1u) != 0u)
	                {
	                    _18386 = g_ScrambledHaltonPermutations.Load(_18379 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _18386 = g_ScrambledHaltonPermutations.Load(_18379 * 4 + 0) & 65535u;
	                }
	                uint _20793 = 1955u + ((_12091 / 205379u) % 59u);
	                uint _18388 = _20793 / 2u;
	                uint _18395;
	                if ((_20793 & 1u) != 0u)
	                {
	                    _18395 = g_ScrambledHaltonPermutations.Load(_18388 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _18395 = g_ScrambledHaltonPermutations.Load(_18388 * 4 + 0) & 65535u;
	                }
	                uint _20794 = 1955u + ((_12091 / 12117361u) % 59u);
	                uint _18397 = _20794 / 2u;
	                uint _18404;
	                if ((_20794 & 1u) != 0u)
	                {
	                    _18404 = g_ScrambledHaltonPermutations.Load(_18397 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _18404 = g_ScrambledHaltonPermutations.Load(_18397 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((((_18366 * 12117361u) + (_18377 * 205379u)) + (_18386 * 3481u)) + (_18395 * 59u)) + _18404) * 1.3987493385769766973680816590786e-09f;
	                _19095 = true;
	                break;
	            }
	            case 17u:
	            {
	                uint _18310 = 2014u + (_12091 % 61u);
	                uint _18311 = _18310 / 2u;
	                uint _18318;
	                if ((_18310 & 1u) != 0u)
	                {
	                    _18318 = g_ScrambledHaltonPermutations.Load(_18311 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _18318 = g_ScrambledHaltonPermutations.Load(_18311 * 4 + 0) & 65535u;
	                }
	                uint _20787 = 2014u + ((_12091 / 61u) % 61u);
	                uint _18322 = _20787 / 2u;
	                uint _18329;
	                if ((_20787 & 1u) != 0u)
	                {
	                    _18329 = g_ScrambledHaltonPermutations.Load(_18322 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _18329 = g_ScrambledHaltonPermutations.Load(_18322 * 4 + 0) & 65535u;
	                }
	                uint _20788 = 2014u + ((_12091 / 3721u) % 61u);
	                uint _18331 = _20788 / 2u;
	                uint _18338;
	                if ((_20788 & 1u) != 0u)
	                {
	                    _18338 = g_ScrambledHaltonPermutations.Load(_18331 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _18338 = g_ScrambledHaltonPermutations.Load(_18331 * 4 + 0) & 65535u;
	                }
	                uint _20789 = 2014u + ((_12091 / 226981u) % 61u);
	                uint _18340 = _20789 / 2u;
	                uint _18347;
	                if ((_20789 & 1u) != 0u)
	                {
	                    _18347 = g_ScrambledHaltonPermutations.Load(_18340 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _18347 = g_ScrambledHaltonPermutations.Load(_18340 * 4 + 0) & 65535u;
	                }
	                uint _20790 = 2014u + ((_12091 / 13845841u) % 61u);
	                uint _18349 = _20790 / 2u;
	                uint _18356;
	                if ((_20790 & 1u) != 0u)
	                {
	                    _18356 = g_ScrambledHaltonPermutations.Load(_18349 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _18356 = g_ScrambledHaltonPermutations.Load(_18349 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((((_18318 * 13845841u) + (_18329 * 226981u)) + (_18338 * 3721u)) + (_18347 * 61u)) + _18356) * 1.1839974556338006550504360347986e-09f;
	                _19095 = true;
	                break;
	            }
	            case 18u:
	            {
	                uint _18262 = 2075u + (_12091 % 67u);
	                uint _18263 = _18262 / 2u;
	                uint _18270;
	                if ((_18262 & 1u) != 0u)
	                {
	                    _18270 = g_ScrambledHaltonPermutations.Load(_18263 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _18270 = g_ScrambledHaltonPermutations.Load(_18263 * 4 + 0) & 65535u;
	                }
	                uint _20783 = 2075u + ((_12091 / 67u) % 67u);
	                uint _18274 = _20783 / 2u;
	                uint _18281;
	                if ((_20783 & 1u) != 0u)
	                {
	                    _18281 = g_ScrambledHaltonPermutations.Load(_18274 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _18281 = g_ScrambledHaltonPermutations.Load(_18274 * 4 + 0) & 65535u;
	                }
	                uint _20784 = 2075u + ((_12091 / 4489u) % 67u);
	                uint _18283 = _20784 / 2u;
	                uint _18290;
	                if ((_20784 & 1u) != 0u)
	                {
	                    _18290 = g_ScrambledHaltonPermutations.Load(_18283 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _18290 = g_ScrambledHaltonPermutations.Load(_18283 * 4 + 0) & 65535u;
	                }
	                uint _20785 = 2075u + ((_12091 / 300763u) % 67u);
	                uint _18292 = _20785 / 2u;
	                uint _18299;
	                if ((_20785 & 1u) != 0u)
	                {
	                    _18299 = g_ScrambledHaltonPermutations.Load(_18292 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _18299 = g_ScrambledHaltonPermutations.Load(_18292 * 4 + 0) & 65535u;
	                }
	                uint _20786 = 2075u + ((_12091 / 20151121u) % 67u);
	                uint _18301 = _20786 / 2u;
	                uint _18308;
	                if ((_20786 & 1u) != 0u)
	                {
	                    _18308 = g_ScrambledHaltonPermutations.Load(_18301 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _18308 = g_ScrambledHaltonPermutations.Load(_18301 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((((_18270 * 20151121u) + (_18281 * 300763u)) + (_18290 * 4489u)) + (_18299 * 67u)) + _18308) * 7.4067202371352891532296780496836e-10f;
	                _19095 = true;
	                break;
	            }
	            case 19u:
	            {
	                uint _18214 = 2142u + (_12091 % 71u);
	                uint _18215 = _18214 / 2u;
	                uint _18222;
	                if ((_18214 & 1u) != 0u)
	                {
	                    _18222 = g_ScrambledHaltonPermutations.Load(_18215 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _18222 = g_ScrambledHaltonPermutations.Load(_18215 * 4 + 0) & 65535u;
	                }
	                uint _20779 = 2142u + ((_12091 / 71u) % 71u);
	                uint _18226 = _20779 / 2u;
	                uint _18233;
	                if ((_20779 & 1u) != 0u)
	                {
	                    _18233 = g_ScrambledHaltonPermutations.Load(_18226 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _18233 = g_ScrambledHaltonPermutations.Load(_18226 * 4 + 0) & 65535u;
	                }
	                uint _20780 = 2142u + ((_12091 / 5041u) % 71u);
	                uint _18235 = _20780 / 2u;
	                uint _18242;
	                if ((_20780 & 1u) != 0u)
	                {
	                    _18242 = g_ScrambledHaltonPermutations.Load(_18235 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _18242 = g_ScrambledHaltonPermutations.Load(_18235 * 4 + 0) & 65535u;
	                }
	                uint _20781 = 2142u + ((_12091 / 357911u) % 71u);
	                uint _18244 = _20781 / 2u;
	                uint _18251;
	                if ((_20781 & 1u) != 0u)
	                {
	                    _18251 = g_ScrambledHaltonPermutations.Load(_18244 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _18251 = g_ScrambledHaltonPermutations.Load(_18244 * 4 + 0) & 65535u;
	                }
	                uint _20782 = 2142u + ((_12091 / 25411681u) % 71u);
	                uint _18253 = _20782 / 2u;
	                uint _18260;
	                if ((_20782 & 1u) != 0u)
	                {
	                    _18260 = g_ScrambledHaltonPermutations.Load(_18253 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _18260 = g_ScrambledHaltonPermutations.Load(_18253 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((((_18222 * 25411681u) + (_18233 * 357911u)) + (_18242 * 5041u)) + (_18251 * 71u)) + _18260) * 5.5425319889224056169041432440281e-10f;
	                _19095 = true;
	                break;
	            }
	            case 20u:
	            {
	                uint _18166 = 2213u + (_12091 % 73u);
	                uint _18167 = _18166 / 2u;
	                uint _18174;
	                if ((_18166 & 1u) != 0u)
	                {
	                    _18174 = g_ScrambledHaltonPermutations.Load(_18167 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _18174 = g_ScrambledHaltonPermutations.Load(_18167 * 4 + 0) & 65535u;
	                }
	                uint _20775 = 2213u + ((_12091 / 73u) % 73u);
	                uint _18178 = _20775 / 2u;
	                uint _18185;
	                if ((_20775 & 1u) != 0u)
	                {
	                    _18185 = g_ScrambledHaltonPermutations.Load(_18178 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _18185 = g_ScrambledHaltonPermutations.Load(_18178 * 4 + 0) & 65535u;
	                }
	                uint _20776 = 2213u + ((_12091 / 5329u) % 73u);
	                uint _18187 = _20776 / 2u;
	                uint _18194;
	                if ((_20776 & 1u) != 0u)
	                {
	                    _18194 = g_ScrambledHaltonPermutations.Load(_18187 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _18194 = g_ScrambledHaltonPermutations.Load(_18187 * 4 + 0) & 65535u;
	                }
	                uint _20777 = 2213u + ((_12091 / 389017u) % 73u);
	                uint _18196 = _20777 / 2u;
	                uint _18203;
	                if ((_20777 & 1u) != 0u)
	                {
	                    _18203 = g_ScrambledHaltonPermutations.Load(_18196 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _18203 = g_ScrambledHaltonPermutations.Load(_18196 * 4 + 0) & 65535u;
	                }
	                uint _20778 = 2213u + ((_12091 / 28398241u) % 73u);
	                uint _18205 = _20778 / 2u;
	                uint _18212;
	                if ((_20778 & 1u) != 0u)
	                {
	                    _18212 = g_ScrambledHaltonPermutations.Load(_18205 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _18212 = g_ScrambledHaltonPermutations.Load(_18205 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((((_18174 * 28398241u) + (_18185 * 389017u)) + (_18194 * 5329u)) + (_18203 * 73u)) + _18212) * 4.8237597249922714581771288067102e-10f;
	                _19095 = true;
	                break;
	            }
	            case 21u:
	            {
	                uint _18117 = 2286u + (_12091 % 79u);
	                uint _18119 = _18117 / 2u;
	                uint _18126;
	                if ((_18117 & 1u) != 0u)
	                {
	                    _18126 = g_ScrambledHaltonPermutations.Load(_18119 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _18126 = g_ScrambledHaltonPermutations.Load(_18119 * 4 + 0) & 65535u;
	                }
	                uint _20771 = 2286u + ((_12091 / 79u) % 79u);
	                uint _18130 = _20771 / 2u;
	                uint _18137;
	                if ((_20771 & 1u) != 0u)
	                {
	                    _18137 = g_ScrambledHaltonPermutations.Load(_18130 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _18137 = g_ScrambledHaltonPermutations.Load(_18130 * 4 + 0) & 65535u;
	                }
	                uint _20772 = 2286u + ((_12091 / 6241u) % 79u);
	                uint _18139 = _20772 / 2u;
	                uint _18146;
	                if ((_20772 & 1u) != 0u)
	                {
	                    _18146 = g_ScrambledHaltonPermutations.Load(_18139 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _18146 = g_ScrambledHaltonPermutations.Load(_18139 * 4 + 0) & 65535u;
	                }
	                uint _20773 = 2286u + ((_12091 / 493039u) % 79u);
	                uint _18148 = _20773 / 2u;
	                uint _18155;
	                if ((_20773 & 1u) != 0u)
	                {
	                    _18155 = g_ScrambledHaltonPermutations.Load(_18148 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _18155 = g_ScrambledHaltonPermutations.Load(_18148 * 4 + 0) & 65535u;
	                }
	                uint _20774 = 2286u + ((_12091 / 38950081u) % 79u);
	                uint _18157 = _20774 / 2u;
	                uint _18164;
	                if ((_20774 & 1u) != 0u)
	                {
	                    _18164 = g_ScrambledHaltonPermutations.Load(_18157 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _18164 = g_ScrambledHaltonPermutations.Load(_18157 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((((_18126 * 38950081u) + (_18137 * 493039u)) + (_18146 * 6241u)) + (_18155 * 79u)) + _18164) * 3.2498587154705660395848099142313e-10f;
	                _19095 = true;
	                break;
	            }
	            case 22u:
	            {
	                uint _18069 = 2365u + (_12091 % 83u);
	                uint _18070 = _18069 / 2u;
	                uint _18077;
	                if ((_18069 & 1u) != 0u)
	                {
	                    _18077 = g_ScrambledHaltonPermutations.Load(_18070 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _18077 = g_ScrambledHaltonPermutations.Load(_18070 * 4 + 0) & 65535u;
	                }
	                uint _20767 = 2365u + ((_12091 / 83u) % 83u);
	                uint _18081 = _20767 / 2u;
	                uint _18088;
	                if ((_20767 & 1u) != 0u)
	                {
	                    _18088 = g_ScrambledHaltonPermutations.Load(_18081 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _18088 = g_ScrambledHaltonPermutations.Load(_18081 * 4 + 0) & 65535u;
	                }
	                uint _20768 = 2365u + ((_12091 / 6889u) % 83u);
	                uint _18090 = _20768 / 2u;
	                uint _18097;
	                if ((_20768 & 1u) != 0u)
	                {
	                    _18097 = g_ScrambledHaltonPermutations.Load(_18090 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _18097 = g_ScrambledHaltonPermutations.Load(_18090 * 4 + 0) & 65535u;
	                }
	                uint _20769 = 2365u + ((_12091 / 571787u) % 83u);
	                uint _18099 = _20769 / 2u;
	                uint _18106;
	                if ((_20769 & 1u) != 0u)
	                {
	                    _18106 = g_ScrambledHaltonPermutations.Load(_18099 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _18106 = g_ScrambledHaltonPermutations.Load(_18099 * 4 + 0) & 65535u;
	                }
	                uint _20770 = 2365u + ((_12091 / 47458321u) % 83u);
	                uint _18108 = _20770 / 2u;
	                uint _18115;
	                if ((_20770 & 1u) != 0u)
	                {
	                    _18115 = g_ScrambledHaltonPermutations.Load(_18108 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _18115 = g_ScrambledHaltonPermutations.Load(_18108 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((((_18077 * 47458321u) + (_18088 * 571787u)) + (_18097 * 6889u)) + (_18106 * 83u)) + _18115) * 2.5386887037015526402683462947607e-10f;
	                _19095 = true;
	                break;
	            }
	            case 23u:
	            {
	                uint _18030 = 2448u + (_12091 % 89u);
	                uint _18031 = _18030 / 2u;
	                uint _18038;
	                if ((_18030 & 1u) != 0u)
	                {
	                    _18038 = g_ScrambledHaltonPermutations.Load(_18031 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _18038 = g_ScrambledHaltonPermutations.Load(_18031 * 4 + 0) & 65535u;
	                }
	                uint _20764 = 2448u + ((_12091 / 89u) % 89u);
	                uint _18042 = _20764 / 2u;
	                uint _18049;
	                if ((_20764 & 1u) != 0u)
	                {
	                    _18049 = g_ScrambledHaltonPermutations.Load(_18042 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _18049 = g_ScrambledHaltonPermutations.Load(_18042 * 4 + 0) & 65535u;
	                }
	                uint _20765 = 2448u + ((_12091 / 7921u) % 89u);
	                uint _18051 = _20765 / 2u;
	                uint _18058;
	                if ((_20765 & 1u) != 0u)
	                {
	                    _18058 = g_ScrambledHaltonPermutations.Load(_18051 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _18058 = g_ScrambledHaltonPermutations.Load(_18051 * 4 + 0) & 65535u;
	                }
	                uint _20766 = 2448u + ((_12091 / 704969u) % 89u);
	                uint _18060 = _20766 / 2u;
	                uint _18067;
	                if ((_20766 & 1u) != 0u)
	                {
	                    _18067 = g_ScrambledHaltonPermutations.Load(_18060 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _18067 = g_ScrambledHaltonPermutations.Load(_18060 * 4 + 0) & 65535u;
	                }
	                _19094 = float((((_18038 * 704969u) + (_18049 * 7921u)) + (_18058 * 89u)) + _18067) * 1.593822496204211347503587603569e-08f;
	                _19095 = true;
	                break;
	            }
	            case 24u:
	            {
	                uint _17991 = 2537u + (_12091 % 97u);
	                uint _17992 = _17991 / 2u;
	                uint _17999;
	                if ((_17991 & 1u) != 0u)
	                {
	                    _17999 = g_ScrambledHaltonPermutations.Load(_17992 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _17999 = g_ScrambledHaltonPermutations.Load(_17992 * 4 + 0) & 65535u;
	                }
	                uint _20761 = 2537u + ((_12091 / 97u) % 97u);
	                uint _18003 = _20761 / 2u;
	                uint _18010;
	                if ((_20761 & 1u) != 0u)
	                {
	                    _18010 = g_ScrambledHaltonPermutations.Load(_18003 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _18010 = g_ScrambledHaltonPermutations.Load(_18003 * 4 + 0) & 65535u;
	                }
	                uint _20762 = 2537u + ((_12091 / 9409u) % 97u);
	                uint _18012 = _20762 / 2u;
	                uint _18019;
	                if ((_20762 & 1u) != 0u)
	                {
	                    _18019 = g_ScrambledHaltonPermutations.Load(_18012 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _18019 = g_ScrambledHaltonPermutations.Load(_18012 * 4 + 0) & 65535u;
	                }
	                uint _20763 = 2537u + ((_12091 / 912673u) % 97u);
	                uint _18021 = _20763 / 2u;
	                uint _18028;
	                if ((_20763 & 1u) != 0u)
	                {
	                    _18028 = g_ScrambledHaltonPermutations.Load(_18021 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _18028 = g_ScrambledHaltonPermutations.Load(_18021 * 4 + 0) & 65535u;
	                }
	                _19094 = float((((_17999 * 912673u) + (_18010 * 9409u)) + (_18019 * 97u)) + _18028) * 1.1295696822344325482845306396484e-08f;
	                _19095 = true;
	                break;
	            }
	            case 25u:
	            {
	                uint _17952 = 2634u + (_12091 % 101u);
	                uint _17953 = _17952 / 2u;
	                uint _17960;
	                if ((_17952 & 1u) != 0u)
	                {
	                    _17960 = g_ScrambledHaltonPermutations.Load(_17953 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _17960 = g_ScrambledHaltonPermutations.Load(_17953 * 4 + 0) & 65535u;
	                }
	                uint _20758 = 2634u + ((_12091 / 101u) % 101u);
	                uint _17964 = _20758 / 2u;
	                uint _17971;
	                if ((_20758 & 1u) != 0u)
	                {
	                    _17971 = g_ScrambledHaltonPermutations.Load(_17964 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _17971 = g_ScrambledHaltonPermutations.Load(_17964 * 4 + 0) & 65535u;
	                }
	                uint _20759 = 2634u + ((_12091 / 10201u) % 101u);
	                uint _17973 = _20759 / 2u;
	                uint _17980;
	                if ((_20759 & 1u) != 0u)
	                {
	                    _17980 = g_ScrambledHaltonPermutations.Load(_17973 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _17980 = g_ScrambledHaltonPermutations.Load(_17973 * 4 + 0) & 65535u;
	                }
	                uint _20760 = 2634u + ((_12091 / 1030301u) % 101u);
	                uint _17982 = _20760 / 2u;
	                uint _17989;
	                if ((_20760 & 1u) != 0u)
	                {
	                    _17989 = g_ScrambledHaltonPermutations.Load(_17982 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _17989 = g_ScrambledHaltonPermutations.Load(_17982 * 4 + 0) & 65535u;
	                }
	                _19094 = float((((_17960 * 1030301u) + (_17971 * 10201u)) + (_17980 * 101u)) + _17989) * 9.6098027313473721733316779136658e-09f;
	                _19095 = true;
	                break;
	            }
	            case 26u:
	            {
	                uint _17913 = 2735u + (_12091 % 103u);
	                uint _17914 = _17913 / 2u;
	                uint _17921;
	                if ((_17913 & 1u) != 0u)
	                {
	                    _17921 = g_ScrambledHaltonPermutations.Load(_17914 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _17921 = g_ScrambledHaltonPermutations.Load(_17914 * 4 + 0) & 65535u;
	                }
	                uint _20755 = 2735u + ((_12091 / 103u) % 103u);
	                uint _17925 = _20755 / 2u;
	                uint _17932;
	                if ((_20755 & 1u) != 0u)
	                {
	                    _17932 = g_ScrambledHaltonPermutations.Load(_17925 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _17932 = g_ScrambledHaltonPermutations.Load(_17925 * 4 + 0) & 65535u;
	                }
	                uint _20756 = 2735u + ((_12091 / 10609u) % 103u);
	                uint _17934 = _20756 / 2u;
	                uint _17941;
	                if ((_20756 & 1u) != 0u)
	                {
	                    _17941 = g_ScrambledHaltonPermutations.Load(_17934 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _17941 = g_ScrambledHaltonPermutations.Load(_17934 * 4 + 0) & 65535u;
	                }
	                uint _20757 = 2735u + ((_12091 / 1092727u) % 103u);
	                uint _17943 = _20757 / 2u;
	                uint _17950;
	                if ((_20757 & 1u) != 0u)
	                {
	                    _17950 = g_ScrambledHaltonPermutations.Load(_17943 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _17950 = g_ScrambledHaltonPermutations.Load(_17943 * 4 + 0) & 65535u;
	                }
	                _19094 = float((((_17921 * 1092727u) + (_17932 * 10609u)) + (_17941 * 103u)) + _17950) * 8.8848697288312905584461987018585e-09f;
	                _19095 = true;
	                break;
	            }
	            case 27u:
	            {
	                uint _17874 = 2838u + (_12091 % 107u);
	                uint _17875 = _17874 / 2u;
	                uint _17882;
	                if ((_17874 & 1u) != 0u)
	                {
	                    _17882 = g_ScrambledHaltonPermutations.Load(_17875 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _17882 = g_ScrambledHaltonPermutations.Load(_17875 * 4 + 0) & 65535u;
	                }
	                uint _20752 = 2838u + ((_12091 / 107u) % 107u);
	                uint _17886 = _20752 / 2u;
	                uint _17893;
	                if ((_20752 & 1u) != 0u)
	                {
	                    _17893 = g_ScrambledHaltonPermutations.Load(_17886 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _17893 = g_ScrambledHaltonPermutations.Load(_17886 * 4 + 0) & 65535u;
	                }
	                uint _20753 = 2838u + ((_12091 / 11449u) % 107u);
	                uint _17895 = _20753 / 2u;
	                uint _17902;
	                if ((_20753 & 1u) != 0u)
	                {
	                    _17902 = g_ScrambledHaltonPermutations.Load(_17895 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _17902 = g_ScrambledHaltonPermutations.Load(_17895 * 4 + 0) & 65535u;
	                }
	                uint _20754 = 2838u + ((_12091 / 1225043u) % 107u);
	                uint _17904 = _20754 / 2u;
	                uint _17911;
	                if ((_20754 & 1u) != 0u)
	                {
	                    _17911 = g_ScrambledHaltonPermutations.Load(_17904 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _17911 = g_ScrambledHaltonPermutations.Load(_17904 * 4 + 0) & 65535u;
	                }
	                _19094 = float((((_17882 * 1225043u) + (_17893 * 11449u)) + (_17902 * 107u)) + _17911) * 7.6289516925953648751601576805115e-09f;
	                _19095 = true;
	                break;
	            }
	            case 28u:
	            {
	                uint _17835 = 2945u + (_12091 % 109u);
	                uint _17836 = _17835 / 2u;
	                uint _17843;
	                if ((_17835 & 1u) != 0u)
	                {
	                    _17843 = g_ScrambledHaltonPermutations.Load(_17836 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _17843 = g_ScrambledHaltonPermutations.Load(_17836 * 4 + 0) & 65535u;
	                }
	                uint _20749 = 2945u + ((_12091 / 109u) % 109u);
	                uint _17847 = _20749 / 2u;
	                uint _17854;
	                if ((_20749 & 1u) != 0u)
	                {
	                    _17854 = g_ScrambledHaltonPermutations.Load(_17847 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _17854 = g_ScrambledHaltonPermutations.Load(_17847 * 4 + 0) & 65535u;
	                }
	                uint _20750 = 2945u + ((_12091 / 11881u) % 109u);
	                uint _17856 = _20750 / 2u;
	                uint _17863;
	                if ((_20750 & 1u) != 0u)
	                {
	                    _17863 = g_ScrambledHaltonPermutations.Load(_17856 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _17863 = g_ScrambledHaltonPermutations.Load(_17856 * 4 + 0) & 65535u;
	                }
	                uint _20751 = 2945u + ((_12091 / 1295029u) % 109u);
	                uint _17865 = _20751 / 2u;
	                uint _17872;
	                if ((_20751 & 1u) != 0u)
	                {
	                    _17872 = g_ScrambledHaltonPermutations.Load(_17865 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _17872 = g_ScrambledHaltonPermutations.Load(_17865 * 4 + 0) & 65535u;
	                }
	                _19094 = float((((_17843 * 1295029u) + (_17854 * 11881u)) + (_17863 * 109u)) + _17872) * 7.0842514077185114729218184947968e-09f;
	                _19095 = true;
	                break;
	            }
	            case 29u:
	            {
	                uint _17796 = 3054u + (_12091 % 113u);
	                uint _17797 = _17796 / 2u;
	                uint _17804;
	                if ((_17796 & 1u) != 0u)
	                {
	                    _17804 = g_ScrambledHaltonPermutations.Load(_17797 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _17804 = g_ScrambledHaltonPermutations.Load(_17797 * 4 + 0) & 65535u;
	                }
	                uint _20746 = 3054u + ((_12091 / 113u) % 113u);
	                uint _17808 = _20746 / 2u;
	                uint _17815;
	                if ((_20746 & 1u) != 0u)
	                {
	                    _17815 = g_ScrambledHaltonPermutations.Load(_17808 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _17815 = g_ScrambledHaltonPermutations.Load(_17808 * 4 + 0) & 65535u;
	                }
	                uint _20747 = 3054u + ((_12091 / 12769u) % 113u);
	                uint _17817 = _20747 / 2u;
	                uint _17824;
	                if ((_20747 & 1u) != 0u)
	                {
	                    _17824 = g_ScrambledHaltonPermutations.Load(_17817 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _17824 = g_ScrambledHaltonPermutations.Load(_17817 * 4 + 0) & 65535u;
	                }
	                uint _20748 = 3054u + ((_12091 / 1442897u) % 113u);
	                uint _17826 = _20748 / 2u;
	                uint _17833;
	                if ((_20748 & 1u) != 0u)
	                {
	                    _17833 = g_ScrambledHaltonPermutations.Load(_17826 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _17833 = g_ScrambledHaltonPermutations.Load(_17826 * 4 + 0) & 65535u;
	                }
	                _19094 = float((((_17804 * 1442897u) + (_17815 * 12769u)) + (_17824 * 113u)) + _17833) * 6.1331864031899385736323893070221e-09f;
	                _19095 = true;
	                break;
	            }
	            case 30u:
	            {
	                uint _17757 = 3167u + (_12091 % 127u);
	                uint _17758 = _17757 / 2u;
	                uint _17765;
	                if ((_17757 & 1u) != 0u)
	                {
	                    _17765 = g_ScrambledHaltonPermutations.Load(_17758 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _17765 = g_ScrambledHaltonPermutations.Load(_17758 * 4 + 0) & 65535u;
	                }
	                uint _20743 = 3167u + ((_12091 / 127u) % 127u);
	                uint _17769 = _20743 / 2u;
	                uint _17776;
	                if ((_20743 & 1u) != 0u)
	                {
	                    _17776 = g_ScrambledHaltonPermutations.Load(_17769 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _17776 = g_ScrambledHaltonPermutations.Load(_17769 * 4 + 0) & 65535u;
	                }
	                uint _20744 = 3167u + ((_12091 / 16129u) % 127u);
	                uint _17778 = _20744 / 2u;
	                uint _17785;
	                if ((_20744 & 1u) != 0u)
	                {
	                    _17785 = g_ScrambledHaltonPermutations.Load(_17778 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _17785 = g_ScrambledHaltonPermutations.Load(_17778 * 4 + 0) & 65535u;
	                }
	                uint _20745 = 3167u + ((_12091 / 2048383u) % 127u);
	                uint _17787 = _20745 / 2u;
	                uint _17794;
	                if ((_20745 & 1u) != 0u)
	                {
	                    _17794 = g_ScrambledHaltonPermutations.Load(_17787 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _17794 = g_ScrambledHaltonPermutations.Load(_17787 * 4 + 0) & 65535u;
	                }
	                _19094 = float((((_17765 * 2048383u) + (_17776 * 16129u)) + (_17785 * 127u)) + _17794) * 3.8440148841800692025572061538696e-09f;
	                _19095 = true;
	                break;
	            }
	            case 31u:
	            {
	                uint _17718 = 3294u + (_12091 % 131u);
	                uint _17719 = _17718 / 2u;
	                uint _17726;
	                if ((_17718 & 1u) != 0u)
	                {
	                    _17726 = g_ScrambledHaltonPermutations.Load(_17719 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _17726 = g_ScrambledHaltonPermutations.Load(_17719 * 4 + 0) & 65535u;
	                }
	                uint _20740 = 3294u + ((_12091 / 131u) % 131u);
	                uint _17730 = _20740 / 2u;
	                uint _17737;
	                if ((_20740 & 1u) != 0u)
	                {
	                    _17737 = g_ScrambledHaltonPermutations.Load(_17730 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _17737 = g_ScrambledHaltonPermutations.Load(_17730 * 4 + 0) & 65535u;
	                }
	                uint _20741 = 3294u + ((_12091 / 17161u) % 131u);
	                uint _17739 = _20741 / 2u;
	                uint _17746;
	                if ((_20741 & 1u) != 0u)
	                {
	                    _17746 = g_ScrambledHaltonPermutations.Load(_17739 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _17746 = g_ScrambledHaltonPermutations.Load(_17739 * 4 + 0) & 65535u;
	                }
	                uint _20742 = 3294u + ((_12091 / 2248091u) % 131u);
	                uint _17748 = _20742 / 2u;
	                uint _17755;
	                if ((_20742 & 1u) != 0u)
	                {
	                    _17755 = g_ScrambledHaltonPermutations.Load(_17748 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _17755 = g_ScrambledHaltonPermutations.Load(_17748 * 4 + 0) & 65535u;
	                }
	                _19094 = float((((_17726 * 2248091u) + (_17737 * 17161u)) + (_17746 * 131u)) + _17755) * 3.3955860345713517745025455951691e-09f;
	                _19095 = true;
	                break;
	            }
	            case 32u:
	            {
	                uint _17679 = 3425u + (_12091 % 137u);
	                uint _17680 = _17679 / 2u;
	                uint _17687;
	                if ((_17679 & 1u) != 0u)
	                {
	                    _17687 = g_ScrambledHaltonPermutations.Load(_17680 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _17687 = g_ScrambledHaltonPermutations.Load(_17680 * 4 + 0) & 65535u;
	                }
	                uint _20737 = 3425u + ((_12091 / 137u) % 137u);
	                uint _17691 = _20737 / 2u;
	                uint _17698;
	                if ((_20737 & 1u) != 0u)
	                {
	                    _17698 = g_ScrambledHaltonPermutations.Load(_17691 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _17698 = g_ScrambledHaltonPermutations.Load(_17691 * 4 + 0) & 65535u;
	                }
	                uint _20738 = 3425u + ((_12091 / 18769u) % 137u);
	                uint _17700 = _20738 / 2u;
	                uint _17707;
	                if ((_20738 & 1u) != 0u)
	                {
	                    _17707 = g_ScrambledHaltonPermutations.Load(_17700 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _17707 = g_ScrambledHaltonPermutations.Load(_17700 * 4 + 0) & 65535u;
	                }
	                uint _20739 = 3425u + ((_12091 / 2571353u) % 137u);
	                uint _17709 = _20739 / 2u;
	                uint _17716;
	                if ((_20739 & 1u) != 0u)
	                {
	                    _17716 = g_ScrambledHaltonPermutations.Load(_17709 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _17716 = g_ScrambledHaltonPermutations.Load(_17709 * 4 + 0) & 65535u;
	                }
	                _19094 = float((((_17687 * 2571353u) + (_17698 * 18769u)) + (_17707 * 137u)) + _17716) * 2.8386881734121516274171881377697e-09f;
	                _19095 = true;
	                break;
	            }
	            case 33u:
	            {
	                uint _17640 = 3562u + (_12091 % 139u);
	                uint _17641 = _17640 / 2u;
	                uint _17648;
	                if ((_17640 & 1u) != 0u)
	                {
	                    _17648 = g_ScrambledHaltonPermutations.Load(_17641 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _17648 = g_ScrambledHaltonPermutations.Load(_17641 * 4 + 0) & 65535u;
	                }
	                uint _20734 = 3562u + ((_12091 / 139u) % 139u);
	                uint _17652 = _20734 / 2u;
	                uint _17659;
	                if ((_20734 & 1u) != 0u)
	                {
	                    _17659 = g_ScrambledHaltonPermutations.Load(_17652 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _17659 = g_ScrambledHaltonPermutations.Load(_17652 * 4 + 0) & 65535u;
	                }
	                uint _20735 = 3562u + ((_12091 / 19321u) % 139u);
	                uint _17661 = _20735 / 2u;
	                uint _17668;
	                if ((_20735 & 1u) != 0u)
	                {
	                    _17668 = g_ScrambledHaltonPermutations.Load(_17661 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _17668 = g_ScrambledHaltonPermutations.Load(_17661 * 4 + 0) & 65535u;
	                }
	                uint _20736 = 3562u + ((_12091 / 2685619u) % 139u);
	                uint _17670 = _20736 / 2u;
	                uint _17677;
	                if ((_20736 & 1u) != 0u)
	                {
	                    _17677 = g_ScrambledHaltonPermutations.Load(_17670 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _17677 = g_ScrambledHaltonPermutations.Load(_17670 * 4 + 0) & 65535u;
	                }
	                _19094 = float((((_17648 * 2685619u) + (_17659 * 19321u)) + (_17668 * 139u)) + _17677) * 2.6788027351898335837177000939846e-09f;
	                _19095 = true;
	                break;
	            }
	            case 34u:
	            {
	                uint _17601 = 3701u + (_12091 % 149u);
	                uint _17602 = _17601 / 2u;
	                uint _17609;
	                if ((_17601 & 1u) != 0u)
	                {
	                    _17609 = g_ScrambledHaltonPermutations.Load(_17602 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _17609 = g_ScrambledHaltonPermutations.Load(_17602 * 4 + 0) & 65535u;
	                }
	                uint _20731 = 3701u + ((_12091 / 149u) % 149u);
	                uint _17613 = _20731 / 2u;
	                uint _17620;
	                if ((_20731 & 1u) != 0u)
	                {
	                    _17620 = g_ScrambledHaltonPermutations.Load(_17613 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _17620 = g_ScrambledHaltonPermutations.Load(_17613 * 4 + 0) & 65535u;
	                }
	                uint _20732 = 3701u + ((_12091 / 22201u) % 149u);
	                uint _17622 = _20732 / 2u;
	                uint _17629;
	                if ((_20732 & 1u) != 0u)
	                {
	                    _17629 = g_ScrambledHaltonPermutations.Load(_17622 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _17629 = g_ScrambledHaltonPermutations.Load(_17622 * 4 + 0) & 65535u;
	                }
	                uint _20733 = 3701u + ((_12091 / 3307949u) % 149u);
	                uint _17631 = _20733 / 2u;
	                uint _17638;
	                if ((_20733 & 1u) != 0u)
	                {
	                    _17638 = g_ScrambledHaltonPermutations.Load(_17631 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _17638 = g_ScrambledHaltonPermutations.Load(_17631 * 4 + 0) & 65535u;
	                }
	                _19094 = float((((_17609 * 3307949u) + (_17620 * 22201u)) + (_17629 * 149u)) + _17638) * 2.0288730695483536692336201667786e-09f;
	                _19095 = true;
	                break;
	            }
	            case 35u:
	            {
	                uint _17562 = 3850u + (_12091 % 151u);
	                uint _17563 = _17562 / 2u;
	                uint _17570;
	                if ((_17562 & 1u) != 0u)
	                {
	                    _17570 = g_ScrambledHaltonPermutations.Load(_17563 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _17570 = g_ScrambledHaltonPermutations.Load(_17563 * 4 + 0) & 65535u;
	                }
	                uint _20728 = 3850u + ((_12091 / 151u) % 151u);
	                uint _17574 = _20728 / 2u;
	                uint _17581;
	                if ((_20728 & 1u) != 0u)
	                {
	                    _17581 = g_ScrambledHaltonPermutations.Load(_17574 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _17581 = g_ScrambledHaltonPermutations.Load(_17574 * 4 + 0) & 65535u;
	                }
	                uint _20729 = 3850u + ((_12091 / 22801u) % 151u);
	                uint _17583 = _20729 / 2u;
	                uint _17590;
	                if ((_20729 & 1u) != 0u)
	                {
	                    _17590 = g_ScrambledHaltonPermutations.Load(_17583 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _17590 = g_ScrambledHaltonPermutations.Load(_17583 * 4 + 0) & 65535u;
	                }
	                uint _20730 = 3850u + ((_12091 / 3442951u) % 151u);
	                uint _17592 = _20730 / 2u;
	                uint _17599;
	                if ((_20730 & 1u) != 0u)
	                {
	                    _17599 = g_ScrambledHaltonPermutations.Load(_17592 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _17599 = g_ScrambledHaltonPermutations.Load(_17592 * 4 + 0) & 65535u;
	                }
	                _19094 = float((((_17570 * 3442951u) + (_17581 * 22801u)) + (_17590 * 151u)) + _17599) * 1.9234998038797357367002405226231e-09f;
	                _19095 = true;
	                break;
	            }
	            case 36u:
	            {
	                uint _17523 = 4001u + (_12091 % 157u);
	                uint _17524 = _17523 / 2u;
	                uint _17531;
	                if ((_17523 & 1u) != 0u)
	                {
	                    _17531 = g_ScrambledHaltonPermutations.Load(_17524 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _17531 = g_ScrambledHaltonPermutations.Load(_17524 * 4 + 0) & 65535u;
	                }
	                uint _20725 = 4001u + ((_12091 / 157u) % 157u);
	                uint _17535 = _20725 / 2u;
	                uint _17542;
	                if ((_20725 & 1u) != 0u)
	                {
	                    _17542 = g_ScrambledHaltonPermutations.Load(_17535 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _17542 = g_ScrambledHaltonPermutations.Load(_17535 * 4 + 0) & 65535u;
	                }
	                uint _20726 = 4001u + ((_12091 / 24649u) % 157u);
	                uint _17544 = _20726 / 2u;
	                uint _17551;
	                if ((_20726 & 1u) != 0u)
	                {
	                    _17551 = g_ScrambledHaltonPermutations.Load(_17544 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _17551 = g_ScrambledHaltonPermutations.Load(_17544 * 4 + 0) & 65535u;
	                }
	                uint _20727 = 4001u + ((_12091 / 3869893u) % 157u);
	                uint _17553 = _20727 / 2u;
	                uint _17560;
	                if ((_20727 & 1u) != 0u)
	                {
	                    _17560 = g_ScrambledHaltonPermutations.Load(_17553 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _17560 = g_ScrambledHaltonPermutations.Load(_17553 * 4 + 0) & 65535u;
	                }
	                _19094 = float((((_17531 * 3869893u) + (_17542 * 24649u)) + (_17551 * 157u)) + _17560) * 1.6458920892858941442682407796383e-09f;
	                _19095 = true;
	                break;
	            }
	            case 37u:
	            {
	                uint _17484 = 4158u + (_12091 % 163u);
	                uint _17485 = _17484 / 2u;
	                uint _17492;
	                if ((_17484 & 1u) != 0u)
	                {
	                    _17492 = g_ScrambledHaltonPermutations.Load(_17485 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _17492 = g_ScrambledHaltonPermutations.Load(_17485 * 4 + 0) & 65535u;
	                }
	                uint _20722 = 4158u + ((_12091 / 163u) % 163u);
	                uint _17496 = _20722 / 2u;
	                uint _17503;
	                if ((_20722 & 1u) != 0u)
	                {
	                    _17503 = g_ScrambledHaltonPermutations.Load(_17496 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _17503 = g_ScrambledHaltonPermutations.Load(_17496 * 4 + 0) & 65535u;
	                }
	                uint _20723 = 4158u + ((_12091 / 26569u) % 163u);
	                uint _17505 = _20723 / 2u;
	                uint _17512;
	                if ((_20723 & 1u) != 0u)
	                {
	                    _17512 = g_ScrambledHaltonPermutations.Load(_17505 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _17512 = g_ScrambledHaltonPermutations.Load(_17505 * 4 + 0) & 65535u;
	                }
	                uint _20724 = 4158u + ((_12091 / 4330747u) % 163u);
	                uint _17514 = _20724 / 2u;
	                uint _17521;
	                if ((_20724 & 1u) != 0u)
	                {
	                    _17521 = g_ScrambledHaltonPermutations.Load(_17514 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _17521 = g_ScrambledHaltonPermutations.Load(_17514 * 4 + 0) & 65535u;
	                }
	                _19094 = float((((_17492 * 4330747u) + (_17503 * 26569u)) + (_17512 * 163u)) + _17521) * 1.4166074979726772653521038591862e-09f;
	                _19095 = true;
	                break;
	            }
	            case 38u:
	            {
	                uint _17445 = 4321u + (_12091 % 167u);
	                uint _17446 = _17445 / 2u;
	                uint _17453;
	                if ((_17445 & 1u) != 0u)
	                {
	                    _17453 = g_ScrambledHaltonPermutations.Load(_17446 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _17453 = g_ScrambledHaltonPermutations.Load(_17446 * 4 + 0) & 65535u;
	                }
	                uint _20719 = 4321u + ((_12091 / 167u) % 167u);
	                uint _17457 = _20719 / 2u;
	                uint _17464;
	                if ((_20719 & 1u) != 0u)
	                {
	                    _17464 = g_ScrambledHaltonPermutations.Load(_17457 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _17464 = g_ScrambledHaltonPermutations.Load(_17457 * 4 + 0) & 65535u;
	                }
	                uint _20720 = 4321u + ((_12091 / 27889u) % 167u);
	                uint _17466 = _20720 / 2u;
	                uint _17473;
	                if ((_20720 & 1u) != 0u)
	                {
	                    _17473 = g_ScrambledHaltonPermutations.Load(_17466 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _17473 = g_ScrambledHaltonPermutations.Load(_17466 * 4 + 0) & 65535u;
	                }
	                uint _20721 = 4321u + ((_12091 / 4657463u) % 167u);
	                uint _17475 = _20721 / 2u;
	                uint _17482;
	                if ((_20721 & 1u) != 0u)
	                {
	                    _17482 = g_ScrambledHaltonPermutations.Load(_17475 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _17482 = g_ScrambledHaltonPermutations.Load(_17475 * 4 + 0) & 65535u;
	                }
	                _19094 = float((((_17453 * 4657463u) + (_17464 * 27889u)) + (_17473 * 167u)) + _17482) * 1.2856834485930335176817607134581e-09f;
	                _19095 = true;
	                break;
	            }
	            case 39u:
	            {
	                uint _17406 = 4488u + (_12091 % 173u);
	                uint _17407 = _17406 / 2u;
	                uint _17414;
	                if ((_17406 & 1u) != 0u)
	                {
	                    _17414 = g_ScrambledHaltonPermutations.Load(_17407 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _17414 = g_ScrambledHaltonPermutations.Load(_17407 * 4 + 0) & 65535u;
	                }
	                uint _20716 = 4488u + ((_12091 / 173u) % 173u);
	                uint _17418 = _20716 / 2u;
	                uint _17425;
	                if ((_20716 & 1u) != 0u)
	                {
	                    _17425 = g_ScrambledHaltonPermutations.Load(_17418 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _17425 = g_ScrambledHaltonPermutations.Load(_17418 * 4 + 0) & 65535u;
	                }
	                uint _20717 = 4488u + ((_12091 / 29929u) % 173u);
	                uint _17427 = _20717 / 2u;
	                uint _17434;
	                if ((_20717 & 1u) != 0u)
	                {
	                    _17434 = g_ScrambledHaltonPermutations.Load(_17427 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _17434 = g_ScrambledHaltonPermutations.Load(_17427 * 4 + 0) & 65535u;
	                }
	                uint _20718 = 4488u + ((_12091 / 5177717u) % 173u);
	                uint _17436 = _20718 / 2u;
	                uint _17443;
	                if ((_20718 & 1u) != 0u)
	                {
	                    _17443 = g_ScrambledHaltonPermutations.Load(_17436 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _17443 = g_ScrambledHaltonPermutations.Load(_17436 * 4 + 0) & 65535u;
	                }
	                _19094 = float((((_17414 * 5177717u) + (_17425 * 29929u)) + (_17434 * 173u)) + _17443) * 1.1163889812593197348178364336491e-09f;
	                _19095 = true;
	                break;
	            }
	            case 40u:
	            {
	                uint _17367 = 4661u + (_12091 % 179u);
	                uint _17368 = _17367 / 2u;
	                uint _17375;
	                if ((_17367 & 1u) != 0u)
	                {
	                    _17375 = g_ScrambledHaltonPermutations.Load(_17368 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _17375 = g_ScrambledHaltonPermutations.Load(_17368 * 4 + 0) & 65535u;
	                }
	                uint _20713 = 4661u + ((_12091 / 179u) % 179u);
	                uint _17379 = _20713 / 2u;
	                uint _17386;
	                if ((_20713 & 1u) != 0u)
	                {
	                    _17386 = g_ScrambledHaltonPermutations.Load(_17379 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _17386 = g_ScrambledHaltonPermutations.Load(_17379 * 4 + 0) & 65535u;
	                }
	                uint _20714 = 4661u + ((_12091 / 32041u) % 179u);
	                uint _17388 = _20714 / 2u;
	                uint _17395;
	                if ((_20714 & 1u) != 0u)
	                {
	                    _17395 = g_ScrambledHaltonPermutations.Load(_17388 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _17395 = g_ScrambledHaltonPermutations.Load(_17388 * 4 + 0) & 65535u;
	                }
	                uint _20715 = 4661u + ((_12091 / 5735339u) % 179u);
	                uint _17397 = _20715 / 2u;
	                uint _17404;
	                if ((_20715 & 1u) != 0u)
	                {
	                    _17404 = g_ScrambledHaltonPermutations.Load(_17397 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _17404 = g_ScrambledHaltonPermutations.Load(_17397 * 4 + 0) & 65535u;
	                }
	                _19094 = float((((_17375 * 5735339u) + (_17386 * 32041u)) + (_17395 * 179u)) + _17404) * 9.7406471777361502972780726850033e-10f;
	                _19095 = true;
	                break;
	            }
	            case 41u:
	            {
	                uint _17328 = 4840u + (_12091 % 181u);
	                uint _17329 = _17328 / 2u;
	                uint _17336;
	                if ((_17328 & 1u) != 0u)
	                {
	                    _17336 = g_ScrambledHaltonPermutations.Load(_17329 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _17336 = g_ScrambledHaltonPermutations.Load(_17329 * 4 + 0) & 65535u;
	                }
	                uint _20710 = 4840u + ((_12091 / 181u) % 181u);
	                uint _17340 = _20710 / 2u;
	                uint _17347;
	                if ((_20710 & 1u) != 0u)
	                {
	                    _17347 = g_ScrambledHaltonPermutations.Load(_17340 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _17347 = g_ScrambledHaltonPermutations.Load(_17340 * 4 + 0) & 65535u;
	                }
	                uint _20711 = 4840u + ((_12091 / 32761u) % 181u);
	                uint _17349 = _20711 / 2u;
	                uint _17356;
	                if ((_20711 & 1u) != 0u)
	                {
	                    _17356 = g_ScrambledHaltonPermutations.Load(_17349 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _17356 = g_ScrambledHaltonPermutations.Load(_17349 * 4 + 0) & 65535u;
	                }
	                uint _20712 = 4840u + ((_12091 / 5929741u) % 181u);
	                uint _17358 = _20712 / 2u;
	                uint _17365;
	                if ((_20712 & 1u) != 0u)
	                {
	                    _17365 = g_ScrambledHaltonPermutations.Load(_17358 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _17365 = g_ScrambledHaltonPermutations.Load(_17358 * 4 + 0) & 65535u;
	                }
	                _19094 = float((((_17336 * 5929741u) + (_17347 * 32761u)) + (_17356 * 181u)) + _17365) * 9.3172047854750417172908782958984e-10f;
	                _19095 = true;
	                break;
	            }
	            case 42u:
	            {
	                uint _17289 = 5021u + (_12091 % 191u);
	                uint _17290 = _17289 / 2u;
	                uint _17297;
	                if ((_17289 & 1u) != 0u)
	                {
	                    _17297 = g_ScrambledHaltonPermutations.Load(_17290 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _17297 = g_ScrambledHaltonPermutations.Load(_17290 * 4 + 0) & 65535u;
	                }
	                uint _20707 = 5021u + ((_12091 / 191u) % 191u);
	                uint _17301 = _20707 / 2u;
	                uint _17308;
	                if ((_20707 & 1u) != 0u)
	                {
	                    _17308 = g_ScrambledHaltonPermutations.Load(_17301 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _17308 = g_ScrambledHaltonPermutations.Load(_17301 * 4 + 0) & 65535u;
	                }
	                uint _20708 = 5021u + ((_12091 / 36481u) % 191u);
	                uint _17310 = _20708 / 2u;
	                uint _17317;
	                if ((_20708 & 1u) != 0u)
	                {
	                    _17317 = g_ScrambledHaltonPermutations.Load(_17310 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _17317 = g_ScrambledHaltonPermutations.Load(_17310 * 4 + 0) & 65535u;
	                }
	                uint _20709 = 5021u + ((_12091 / 6967871u) % 191u);
	                uint _17319 = _20709 / 2u;
	                uint _17326;
	                if ((_20709 & 1u) != 0u)
	                {
	                    _17326 = g_ScrambledHaltonPermutations.Load(_17319 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _17326 = g_ScrambledHaltonPermutations.Load(_17319 * 4 + 0) & 65535u;
	                }
	                _19094 = float((((_17297 * 6967871u) + (_17308 * 36481u)) + (_17317 * 191u)) + _17326) * 7.5139183763894834555685520172119e-10f;
	                _19095 = true;
	                break;
	            }
	            case 43u:
	            {
	                uint _17250 = 5212u + (_12091 % 193u);
	                uint _17251 = _17250 / 2u;
	                uint _17258;
	                if ((_17250 & 1u) != 0u)
	                {
	                    _17258 = g_ScrambledHaltonPermutations.Load(_17251 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _17258 = g_ScrambledHaltonPermutations.Load(_17251 * 4 + 0) & 65535u;
	                }
	                uint _20704 = 5212u + ((_12091 / 193u) % 193u);
	                uint _17262 = _20704 / 2u;
	                uint _17269;
	                if ((_20704 & 1u) != 0u)
	                {
	                    _17269 = g_ScrambledHaltonPermutations.Load(_17262 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _17269 = g_ScrambledHaltonPermutations.Load(_17262 * 4 + 0) & 65535u;
	                }
	                uint _20705 = 5212u + ((_12091 / 37249u) % 193u);
	                uint _17271 = _20705 / 2u;
	                uint _17278;
	                if ((_20705 & 1u) != 0u)
	                {
	                    _17278 = g_ScrambledHaltonPermutations.Load(_17271 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _17278 = g_ScrambledHaltonPermutations.Load(_17271 * 4 + 0) & 65535u;
	                }
	                uint _20706 = 5212u + ((_12091 / 7189057u) % 193u);
	                uint _17280 = _20706 / 2u;
	                uint _17287;
	                if ((_20706 & 1u) != 0u)
	                {
	                    _17287 = g_ScrambledHaltonPermutations.Load(_17280 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _17287 = g_ScrambledHaltonPermutations.Load(_17280 * 4 + 0) & 65535u;
	                }
	                _19094 = float((((_17258 * 7189057u) + (_17269 * 37249u)) + (_17278 * 193u)) + _17287) * 7.2072686707613797807425726205111e-10f;
	                _19095 = true;
	                break;
	            }
	            case 44u:
	            {
	                uint _17210 = 5405u + (_12091 % 197u);
	                uint _17211 = _17210 / 2u;
	                uint _17218;
	                if ((_17210 & 1u) != 0u)
	                {
	                    _17218 = g_ScrambledHaltonPermutations.Load(_17211 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _17218 = g_ScrambledHaltonPermutations.Load(_17211 * 4 + 0) & 65535u;
	                }
	                uint _20701 = 5405u + ((_12091 / 197u) % 197u);
	                uint _17222 = _20701 / 2u;
	                uint _17229;
	                if ((_20701 & 1u) != 0u)
	                {
	                    _17229 = g_ScrambledHaltonPermutations.Load(_17222 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _17229 = g_ScrambledHaltonPermutations.Load(_17222 * 4 + 0) & 65535u;
	                }
	                uint _20702 = 5405u + ((_12091 / 38809u) % 197u);
	                uint _17231 = _20702 / 2u;
	                uint _17238;
	                if ((_20702 & 1u) != 0u)
	                {
	                    _17238 = g_ScrambledHaltonPermutations.Load(_17231 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _17238 = g_ScrambledHaltonPermutations.Load(_17231 * 4 + 0) & 65535u;
	                }
	                uint _20703 = 5405u + ((_12091 / 7645373u) % 197u);
	                uint _17240 = _20703 / 2u;
	                uint _17247;
	                if ((_20703 & 1u) != 0u)
	                {
	                    _17247 = g_ScrambledHaltonPermutations.Load(_17240 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _17247 = g_ScrambledHaltonPermutations.Load(_17240 * 4 + 0) & 65535u;
	                }
	                _19094 = float((((_17218 * 7645373u) + (_17229 * 38809u)) + (_17238 * 197u)) + _17247) * 6.6394950648529516001872252672911e-10f;
	                _19095 = true;
	                break;
	            }
	            case 45u:
	            {
	                uint _17171 = 5602u + (_12091 % 199u);
	                uint _17172 = _17171 / 2u;
	                uint _17179;
	                if ((_17171 & 1u) != 0u)
	                {
	                    _17179 = g_ScrambledHaltonPermutations.Load(_17172 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _17179 = g_ScrambledHaltonPermutations.Load(_17172 * 4 + 0) & 65535u;
	                }
	                uint _20698 = 5602u + ((_12091 / 199u) % 199u);
	                uint _17183 = _20698 / 2u;
	                uint _17190;
	                if ((_20698 & 1u) != 0u)
	                {
	                    _17190 = g_ScrambledHaltonPermutations.Load(_17183 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _17190 = g_ScrambledHaltonPermutations.Load(_17183 * 4 + 0) & 65535u;
	                }
	                uint _20699 = 5602u + ((_12091 / 39601u) % 199u);
	                uint _17192 = _20699 / 2u;
	                uint _17199;
	                if ((_20699 & 1u) != 0u)
	                {
	                    _17199 = g_ScrambledHaltonPermutations.Load(_17192 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _17199 = g_ScrambledHaltonPermutations.Load(_17192 * 4 + 0) & 65535u;
	                }
	                uint _20700 = 5602u + ((_12091 / 7880599u) % 199u);
	                uint _17201 = _20700 / 2u;
	                uint _17208;
	                if ((_20700 & 1u) != 0u)
	                {
	                    _17208 = g_ScrambledHaltonPermutations.Load(_17201 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _17208 = g_ScrambledHaltonPermutations.Load(_17201 * 4 + 0) & 65535u;
	                }
	                _19094 = float((((_17179 * 7880599u) + (_17190 * 39601u)) + (_17199 * 199u)) + _17208) * 6.3765775992763451540668029338121e-10f;
	                _19095 = true;
	                break;
	            }
	            case 46u:
	            {
	                uint _17132 = 5801u + (_12091 % 211u);
	                uint _17133 = _17132 / 2u;
	                uint _17140;
	                if ((_17132 & 1u) != 0u)
	                {
	                    _17140 = g_ScrambledHaltonPermutations.Load(_17133 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _17140 = g_ScrambledHaltonPermutations.Load(_17133 * 4 + 0) & 65535u;
	                }
	                uint _20695 = 5801u + ((_12091 / 211u) % 211u);
	                uint _17144 = _20695 / 2u;
	                uint _17151;
	                if ((_20695 & 1u) != 0u)
	                {
	                    _17151 = g_ScrambledHaltonPermutations.Load(_17144 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _17151 = g_ScrambledHaltonPermutations.Load(_17144 * 4 + 0) & 65535u;
	                }
	                uint _20696 = 5801u + ((_12091 / 44521u) % 211u);
	                uint _17153 = _20696 / 2u;
	                uint _17160;
	                if ((_20696 & 1u) != 0u)
	                {
	                    _17160 = g_ScrambledHaltonPermutations.Load(_17153 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _17160 = g_ScrambledHaltonPermutations.Load(_17153 * 4 + 0) & 65535u;
	                }
	                uint _20697 = 5801u + ((_12091 / 9393931u) % 211u);
	                uint _17162 = _20697 / 2u;
	                uint _17169;
	                if ((_20697 & 1u) != 0u)
	                {
	                    _17169 = g_ScrambledHaltonPermutations.Load(_17162 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _17169 = g_ScrambledHaltonPermutations.Load(_17162 * 4 + 0) & 65535u;
	                }
	                _19094 = float((((_17140 * 9393931u) + (_17151 * 44521u)) + (_17160 * 211u)) + _17169) * 5.0451043343002766050631180405617e-10f;
	                _19095 = true;
	                break;
	            }
	            case 47u:
	            {
	                uint _17093 = 6012u + (_12091 % 223u);
	                uint _17094 = _17093 / 2u;
	                uint _17101;
	                if ((_17093 & 1u) != 0u)
	                {
	                    _17101 = g_ScrambledHaltonPermutations.Load(_17094 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _17101 = g_ScrambledHaltonPermutations.Load(_17094 * 4 + 0) & 65535u;
	                }
	                uint _20692 = 6012u + ((_12091 / 223u) % 223u);
	                uint _17105 = _20692 / 2u;
	                uint _17112;
	                if ((_20692 & 1u) != 0u)
	                {
	                    _17112 = g_ScrambledHaltonPermutations.Load(_17105 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _17112 = g_ScrambledHaltonPermutations.Load(_17105 * 4 + 0) & 65535u;
	                }
	                uint _20693 = 6012u + ((_12091 / 49729u) % 223u);
	                uint _17114 = _20693 / 2u;
	                uint _17121;
	                if ((_20693 & 1u) != 0u)
	                {
	                    _17121 = g_ScrambledHaltonPermutations.Load(_17114 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _17121 = g_ScrambledHaltonPermutations.Load(_17114 * 4 + 0) & 65535u;
	                }
	                uint _20694 = 6012u + ((_12091 / 11089567u) % 223u);
	                uint _17123 = _20694 / 2u;
	                uint _17130;
	                if ((_20694 & 1u) != 0u)
	                {
	                    _17130 = g_ScrambledHaltonPermutations.Load(_17123 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _17130 = g_ScrambledHaltonPermutations.Load(_17123 * 4 + 0) & 65535u;
	                }
	                _19094 = float((((_17101 * 11089567u) + (_17112 * 49729u)) + (_17121 * 223u)) + _17130) * 4.0437145298888310662732692435384e-10f;
	                _19095 = true;
	                break;
	            }
	            case 48u:
	            {
	                uint _17053 = 6235u + (_12091 % 227u);
	                uint _17054 = _17053 / 2u;
	                uint _17061;
	                if ((_17053 & 1u) != 0u)
	                {
	                    _17061 = g_ScrambledHaltonPermutations.Load(_17054 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _17061 = g_ScrambledHaltonPermutations.Load(_17054 * 4 + 0) & 65535u;
	                }
	                uint _20689 = 6235u + ((_12091 / 227u) % 227u);
	                uint _17065 = _20689 / 2u;
	                uint _17072;
	                if ((_20689 & 1u) != 0u)
	                {
	                    _17072 = g_ScrambledHaltonPermutations.Load(_17065 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _17072 = g_ScrambledHaltonPermutations.Load(_17065 * 4 + 0) & 65535u;
	                }
	                uint _20690 = 6235u + ((_12091 / 51529u) % 227u);
	                uint _17074 = _20690 / 2u;
	                uint _17082;
	                if ((_20690 & 1u) != 0u)
	                {
	                    _17082 = g_ScrambledHaltonPermutations.Load(_17074 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _17082 = g_ScrambledHaltonPermutations.Load(_17074 * 4 + 0) & 65535u;
	                }
	                uint _20691 = 6235u + ((_12091 / 11697083u) % 227u);
	                uint _17084 = _20691 / 2u;
	                uint _17091;
	                if ((_20691 & 1u) != 0u)
	                {
	                    _17091 = g_ScrambledHaltonPermutations.Load(_17084 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _17091 = g_ScrambledHaltonPermutations.Load(_17084 * 4 + 0) & 65535u;
	                }
	                _19094 = float((((_17061 * 11697083u) + (_17072 * 51529u)) + (_17082 * 227u)) + _17091) * 3.7661404550526356160844443365932e-10f;
	                _19095 = true;
	                break;
	            }
	            case 49u:
	            {
	                uint _17013 = 6462u + (_12091 % 229u);
	                uint _17014 = _17013 / 2u;
	                uint _17022;
	                if ((_17013 & 1u) != 0u)
	                {
	                    _17022 = g_ScrambledHaltonPermutations.Load(_17014 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _17022 = g_ScrambledHaltonPermutations.Load(_17014 * 4 + 0) & 65535u;
	                }
	                uint _20686 = 6462u + ((_12091 / 229u) % 229u);
	                uint _17026 = _20686 / 2u;
	                uint _17033;
	                if ((_20686 & 1u) != 0u)
	                {
	                    _17033 = g_ScrambledHaltonPermutations.Load(_17026 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _17033 = g_ScrambledHaltonPermutations.Load(_17026 * 4 + 0) & 65535u;
	                }
	                uint _20687 = 6462u + ((_12091 / 52441u) % 229u);
	                uint _17035 = _20687 / 2u;
	                uint _17042;
	                if ((_20687 & 1u) != 0u)
	                {
	                    _17042 = g_ScrambledHaltonPermutations.Load(_17035 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _17042 = g_ScrambledHaltonPermutations.Load(_17035 * 4 + 0) & 65535u;
	                }
	                uint _20688 = 6462u + ((_12091 / 12008989u) % 229u);
	                uint _17044 = _20688 / 2u;
	                uint _17051;
	                if ((_20688 & 1u) != 0u)
	                {
	                    _17051 = g_ScrambledHaltonPermutations.Load(_17044 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _17051 = g_ScrambledHaltonPermutations.Load(_17044 * 4 + 0) & 65535u;
	                }
	                _19094 = float((((_17022 * 12008989u) + (_17033 * 52441u)) + (_17042 * 229u)) + _17051) * 3.6362857169791595879360102117062e-10f;
	                _19095 = true;
	                break;
	            }
	            case 50u:
	            {
	                uint _16355 = 6691u + (_12091 % 233u);
	                uint _17008 = _16355 / 2u;
	                uint _16362;
	                if ((_16355 & 1u) != 0u)
	                {
	                    _16362 = g_ScrambledHaltonPermutations.Load(_17008 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _16362 = g_ScrambledHaltonPermutations.Load(_17008 * 4 + 0) & 65535u;
	                }
	                uint _20683 = 6691u + ((_12091 / 233u) % 233u);
	                uint _17009 = _20683 / 2u;
	                uint _16372;
	                if ((_20683 & 1u) != 0u)
	                {
	                    _16372 = g_ScrambledHaltonPermutations.Load(_17009 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _16372 = g_ScrambledHaltonPermutations.Load(_17009 * 4 + 0) & 65535u;
	                }
	                uint _20684 = 6691u + ((_12091 / 54289u) % 233u);
	                uint _17010 = _20684 / 2u;
	                uint _16380;
	                if ((_20684 & 1u) != 0u)
	                {
	                    _16380 = g_ScrambledHaltonPermutations.Load(_17010 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _16380 = g_ScrambledHaltonPermutations.Load(_17010 * 4 + 0) & 65535u;
	                }
	                uint _20685 = 6691u + ((_12091 / 12649337u) % 233u);
	                uint _17011 = _20685 / 2u;
	                uint _16388;
	                if ((_20685 & 1u) != 0u)
	                {
	                    _16388 = g_ScrambledHaltonPermutations.Load(_17011 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _16388 = g_ScrambledHaltonPermutations.Load(_17011 * 4 + 0) & 65535u;
	                }
	                _19094 = float((((_16362 * 12649337u) + (_16372 * 54289u)) + (_16380 * 233u)) + _16388) * 3.3929406506594261827558511868119e-10f;
	                _19095 = true;
	                break;
	            }
	            case 51u:
	            {
	                uint _16319 = 6924u + (_12091 % 239u);
	                uint _17004 = _16319 / 2u;
	                uint _16327;
	                if ((_16319 & 1u) != 0u)
	                {
	                    _16327 = g_ScrambledHaltonPermutations.Load(_17004 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _16327 = g_ScrambledHaltonPermutations.Load(_17004 * 4 + 0) & 65535u;
	                }
	                uint _20680 = 6924u + ((_12091 / 239u) % 239u);
	                uint _17005 = _20680 / 2u;
	                uint _16337;
	                if ((_20680 & 1u) != 0u)
	                {
	                    _16337 = g_ScrambledHaltonPermutations.Load(_17005 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _16337 = g_ScrambledHaltonPermutations.Load(_17005 * 4 + 0) & 65535u;
	                }
	                uint _20681 = 6924u + ((_12091 / 57121u) % 239u);
	                uint _17006 = _20681 / 2u;
	                uint _16345;
	                if ((_20681 & 1u) != 0u)
	                {
	                    _16345 = g_ScrambledHaltonPermutations.Load(_17006 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _16345 = g_ScrambledHaltonPermutations.Load(_17006 * 4 + 0) & 65535u;
	                }
	                uint _20682 = 6924u + ((_12091 / 13651919u) % 239u);
	                uint _17007 = _20682 / 2u;
	                uint _16353;
	                if ((_20682 & 1u) != 0u)
	                {
	                    _16353 = g_ScrambledHaltonPermutations.Load(_17007 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _16353 = g_ScrambledHaltonPermutations.Load(_17007 * 4 + 0) & 65535u;
	                }
	                _19094 = float((((_16327 * 13651919u) + (_16337 * 57121u)) + (_16345 * 239u)) + _16353) * 3.0648439341973698901711031794548e-10f;
	                _19095 = true;
	                break;
	            }
	            case 52u:
	            {
	                uint _16283 = 7163u + (_12091 % 241u);
	                uint _17000 = _16283 / 2u;
	                uint _16290;
	                if ((_16283 & 1u) != 0u)
	                {
	                    _16290 = g_ScrambledHaltonPermutations.Load(_17000 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _16290 = g_ScrambledHaltonPermutations.Load(_17000 * 4 + 0) & 65535u;
	                }
	                uint _20677 = 7163u + ((_12091 / 241u) % 241u);
	                uint _17001 = _20677 / 2u;
	                uint _16300;
	                if ((_20677 & 1u) != 0u)
	                {
	                    _16300 = g_ScrambledHaltonPermutations.Load(_17001 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _16300 = g_ScrambledHaltonPermutations.Load(_17001 * 4 + 0) & 65535u;
	                }
	                uint _20678 = 7163u + ((_12091 / 58081u) % 241u);
	                uint _17002 = _20678 / 2u;
	                uint _16309;
	                if ((_20678 & 1u) != 0u)
	                {
	                    _16309 = g_ScrambledHaltonPermutations.Load(_17002 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _16309 = g_ScrambledHaltonPermutations.Load(_17002 * 4 + 0) & 65535u;
	                }
	                uint _20679 = 7163u + ((_12091 / 13997521u) % 241u);
	                uint _17003 = _20679 / 2u;
	                uint _16317;
	                if ((_20679 & 1u) != 0u)
	                {
	                    _16317 = g_ScrambledHaltonPermutations.Load(_17003 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _16317 = g_ScrambledHaltonPermutations.Load(_17003 * 4 + 0) & 65535u;
	                }
	                _19094 = float((((_16290 * 13997521u) + (_16300 * 58081u)) + (_16309 * 241u)) + _16317) * 2.9643656973554755040822783485055e-10f;
	                _19095 = true;
	                break;
	            }
	            case 53u:
	            {
	                uint _16249 = 7404u + (_12091 % 251u);
	                uint _16996 = _16249 / 2u;
	                uint _16255;
	                if ((_16249 & 1u) != 0u)
	                {
	                    _16255 = g_ScrambledHaltonPermutations.Load(_16996 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _16255 = g_ScrambledHaltonPermutations.Load(_16996 * 4 + 0) & 65535u;
	                }
	                uint _20674 = 7404u + ((_12091 / 251u) % 251u);
	                uint _16997 = _20674 / 2u;
	                uint _16265;
	                if ((_20674 & 1u) != 0u)
	                {
	                    _16265 = g_ScrambledHaltonPermutations.Load(_16997 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _16265 = g_ScrambledHaltonPermutations.Load(_16997 * 4 + 0) & 65535u;
	                }
	                uint _20675 = 7404u + ((_12091 / 63001u) % 251u);
	                uint _16998 = _20675 / 2u;
	                uint _16273;
	                if ((_20675 & 1u) != 0u)
	                {
	                    _16273 = g_ScrambledHaltonPermutations.Load(_16998 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _16273 = g_ScrambledHaltonPermutations.Load(_16998 * 4 + 0) & 65535u;
	                }
	                uint _20676 = 7404u + ((_12091 / 15813251u) % 251u);
	                uint _16999 = _20676 / 2u;
	                uint _16281;
	                if ((_20676 & 1u) != 0u)
	                {
	                    _16281 = g_ScrambledHaltonPermutations.Load(_16999 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _16281 = g_ScrambledHaltonPermutations.Load(_16999 * 4 + 0) & 65535u;
	                }
	                _19094 = float((((_16255 * 15813251u) + (_16265 * 63001u)) + (_16273 * 251u)) + _16281) * 2.5194460406829932708205888047814e-10f;
	                _19095 = true;
	                break;
	            }
	            case 54u:
	            {
	                uint _16225 = 7655u + (_12091 % 257u);
	                uint _16993 = _16225 / 2u;
	                uint _16231;
	                if ((_16225 & 1u) != 0u)
	                {
	                    _16231 = g_ScrambledHaltonPermutations.Load(_16993 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _16231 = g_ScrambledHaltonPermutations.Load(_16993 * 4 + 0) & 65535u;
	                }
	                uint _20672 = 7655u + ((_12091 / 257u) % 257u);
	                uint _16994 = _20672 / 2u;
	                uint _16240;
	                if ((_20672 & 1u) != 0u)
	                {
	                    _16240 = g_ScrambledHaltonPermutations.Load(_16994 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _16240 = g_ScrambledHaltonPermutations.Load(_16994 * 4 + 0) & 65535u;
	                }
	                uint _20673 = 7655u + ((_12091 / 66049u) % 257u);
	                uint _16995 = _20673 / 2u;
	                uint _16247;
	                if ((_20673 & 1u) != 0u)
	                {
	                    _16247 = g_ScrambledHaltonPermutations.Load(_16995 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _16247 = g_ScrambledHaltonPermutations.Load(_16995 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_16231 * 66049u) + (_16240 * 257u)) + _16247) * 5.891157073278918687719851732254e-08f;
	                _19095 = true;
	                break;
	            }
	            case 55u:
	            {
	                uint _16201 = 7912u + (_12091 % 263u);
	                uint _16990 = _16201 / 2u;
	                uint _16207;
	                if ((_16201 & 1u) != 0u)
	                {
	                    _16207 = g_ScrambledHaltonPermutations.Load(_16990 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _16207 = g_ScrambledHaltonPermutations.Load(_16990 * 4 + 0) & 65535u;
	                }
	                uint _20670 = 7912u + ((_12091 / 263u) % 263u);
	                uint _16991 = _20670 / 2u;
	                uint _16216;
	                if ((_20670 & 1u) != 0u)
	                {
	                    _16216 = g_ScrambledHaltonPermutations.Load(_16991 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _16216 = g_ScrambledHaltonPermutations.Load(_16991 * 4 + 0) & 65535u;
	                }
	                uint _20671 = 7912u + ((_12091 / 69169u) % 263u);
	                uint _16992 = _20671 / 2u;
	                uint _16223;
	                if ((_20671 & 1u) != 0u)
	                {
	                    _16223 = g_ScrambledHaltonPermutations.Load(_16992 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _16223 = g_ScrambledHaltonPermutations.Load(_16992 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_16207 * 69169u) + (_16216 * 263u)) + _16223) * 5.4970879403981598443351686000824e-08f;
	                _19095 = true;
	                break;
	            }
	            case 56u:
	            {
	                uint _16179 = 8175u + (_12091 % 269u);
	                uint _16987 = _16179 / 2u;
	                uint _16183;
	                if ((_16179 & 1u) != 0u)
	                {
	                    _16183 = g_ScrambledHaltonPermutations.Load(_16987 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _16183 = g_ScrambledHaltonPermutations.Load(_16987 * 4 + 0) & 65535u;
	                }
	                uint _20668 = 8175u + ((_12091 / 269u) % 269u);
	                uint _16988 = _20668 / 2u;
	                uint _16192;
	                if ((_20668 & 1u) != 0u)
	                {
	                    _16192 = g_ScrambledHaltonPermutations.Load(_16988 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _16192 = g_ScrambledHaltonPermutations.Load(_16988 * 4 + 0) & 65535u;
	                }
	                uint _20669 = 8175u + ((_12091 / 72361u) % 269u);
	                uint _16989 = _20669 / 2u;
	                uint _16199;
	                if ((_20669 & 1u) != 0u)
	                {
	                    _16199 = g_ScrambledHaltonPermutations.Load(_16989 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _16199 = g_ScrambledHaltonPermutations.Load(_16989 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_16183 * 72361u) + (_16192 * 269u)) + _16199) * 5.137396996701681928243488073349e-08f;
	                _19095 = true;
	                break;
	            }
	            case 57u:
	            {
	                uint _16175 = 8444u + (_12091 % 271u);
	                uint _16984 = _16175 / 2u;
	                uint _15365;
	                if ((_16175 & 1u) != 0u)
	                {
	                    _15365 = g_ScrambledHaltonPermutations.Load(_16984 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _15365 = g_ScrambledHaltonPermutations.Load(_16984 * 4 + 0) & 65535u;
	                }
	                uint _20666 = 8444u + ((_12091 / 271u) % 271u);
	                uint _16985 = _20666 / 2u;
	                uint _15373;
	                if ((_20666 & 1u) != 0u)
	                {
	                    _15373 = g_ScrambledHaltonPermutations.Load(_16985 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _15373 = g_ScrambledHaltonPermutations.Load(_16985 * 4 + 0) & 65535u;
	                }
	                uint _20667 = 8444u + ((_12091 / 73441u) % 271u);
	                uint _16986 = _20667 / 2u;
	                uint _15379;
	                if ((_20667 & 1u) != 0u)
	                {
	                    _15379 = g_ScrambledHaltonPermutations.Load(_16986 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _15379 = g_ScrambledHaltonPermutations.Load(_16986 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_15365 * 73441u) + (_15373 * 271u)) + _15379) * 5.0244906901752983685582876205444e-08f;
	                _19095 = true;
	                break;
	            }
	            case 58u:
	            {
	                uint _16171 = 8715u + (_12091 % 277u);
	                uint _16981 = _16171 / 2u;
	                uint _15345;
	                if ((_16171 & 1u) != 0u)
	                {
	                    _15345 = g_ScrambledHaltonPermutations.Load(_16981 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _15345 = g_ScrambledHaltonPermutations.Load(_16981 * 4 + 0) & 65535u;
	                }
	                uint _20664 = 8715u + ((_12091 / 277u) % 277u);
	                uint _16982 = _20664 / 2u;
	                uint _15353;
	                if ((_20664 & 1u) != 0u)
	                {
	                    _15353 = g_ScrambledHaltonPermutations.Load(_16982 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _15353 = g_ScrambledHaltonPermutations.Load(_16982 * 4 + 0) & 65535u;
	                }
	                uint _20665 = 8715u + ((_12091 / 76729u) % 277u);
	                uint _16983 = _20665 / 2u;
	                uint _15359;
	                if ((_20665 & 1u) != 0u)
	                {
	                    _15359 = g_ScrambledHaltonPermutations.Load(_16983 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _15359 = g_ScrambledHaltonPermutations.Load(_16983 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_15345 * 76729u) + (_15353 * 277u)) + _15359) * 4.705011136252323922235518693924e-08f;
	                _19095 = true;
	                break;
	            }
	            case 59u:
	            {
	                uint _16167 = 8992u + (_12091 % 281u);
	                uint _16978 = _16167 / 2u;
	                uint _15325;
	                if ((_16167 & 1u) != 0u)
	                {
	                    _15325 = g_ScrambledHaltonPermutations.Load(_16978 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _15325 = g_ScrambledHaltonPermutations.Load(_16978 * 4 + 0) & 65535u;
	                }
	                uint _20662 = 8992u + ((_12091 / 281u) % 281u);
	                uint _16979 = _20662 / 2u;
	                uint _15333;
	                if ((_20662 & 1u) != 0u)
	                {
	                    _15333 = g_ScrambledHaltonPermutations.Load(_16979 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _15333 = g_ScrambledHaltonPermutations.Load(_16979 * 4 + 0) & 65535u;
	                }
	                uint _20663 = 8992u + ((_12091 / 78961u) % 281u);
	                uint _16980 = _20663 / 2u;
	                uint _15339;
	                if ((_20663 & 1u) != 0u)
	                {
	                    _15339 = g_ScrambledHaltonPermutations.Load(_16980 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _15339 = g_ScrambledHaltonPermutations.Load(_16980 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_15325 * 78961u) + (_15333 * 281u)) + _15339) * 4.5069320719903771532699465751648e-08f;
	                _19095 = true;
	                break;
	            }
	            case 60u:
	            {
	                uint _16163 = 9273u + (_12091 % 283u);
	                uint _16975 = _16163 / 2u;
	                uint _15305;
	                if ((_16163 & 1u) != 0u)
	                {
	                    _15305 = g_ScrambledHaltonPermutations.Load(_16975 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _15305 = g_ScrambledHaltonPermutations.Load(_16975 * 4 + 0) & 65535u;
	                }
	                uint _20660 = 9273u + ((_12091 / 283u) % 283u);
	                uint _16976 = _20660 / 2u;
	                uint _15313;
	                if ((_20660 & 1u) != 0u)
	                {
	                    _15313 = g_ScrambledHaltonPermutations.Load(_16976 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _15313 = g_ScrambledHaltonPermutations.Load(_16976 * 4 + 0) & 65535u;
	                }
	                uint _20661 = 9273u + ((_12091 / 80089u) % 283u);
	                uint _16977 = _20661 / 2u;
	                uint _15319;
	                if ((_20661 & 1u) != 0u)
	                {
	                    _15319 = g_ScrambledHaltonPermutations.Load(_16977 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _15319 = g_ScrambledHaltonPermutations.Load(_16977 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_15305 * 80089u) + (_15313 * 283u)) + _15319) * 4.4120518793988594552502036094666e-08f;
	                _19095 = true;
	                break;
	            }
	            case 61u:
	            {
	                uint _16159 = 9556u + (_12091 % 293u);
	                uint _16972 = _16159 / 2u;
	                uint _15285;
	                if ((_16159 & 1u) != 0u)
	                {
	                    _15285 = g_ScrambledHaltonPermutations.Load(_16972 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _15285 = g_ScrambledHaltonPermutations.Load(_16972 * 4 + 0) & 65535u;
	                }
	                uint _20658 = 9556u + ((_12091 / 293u) % 293u);
	                uint _16973 = _20658 / 2u;
	                uint _15293;
	                if ((_20658 & 1u) != 0u)
	                {
	                    _15293 = g_ScrambledHaltonPermutations.Load(_16973 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _15293 = g_ScrambledHaltonPermutations.Load(_16973 * 4 + 0) & 65535u;
	                }
	                uint _20659 = 9556u + ((_12091 / 85849u) % 293u);
	                uint _16974 = _20659 / 2u;
	                uint _15299;
	                if ((_20659 & 1u) != 0u)
	                {
	                    _15299 = g_ScrambledHaltonPermutations.Load(_16974 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _15299 = g_ScrambledHaltonPermutations.Load(_16974 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_15285 * 85849u) + (_15293 * 293u)) + _15299) * 3.975548779067139548715204000473e-08f;
	                _19095 = true;
	                break;
	            }
	            case 62u:
	            {
	                uint _16155 = 9849u + (_12091 % 307u);
	                uint _16969 = _16155 / 2u;
	                uint _15264;
	                if ((_16155 & 1u) != 0u)
	                {
	                    _15264 = g_ScrambledHaltonPermutations.Load(_16969 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _15264 = g_ScrambledHaltonPermutations.Load(_16969 * 4 + 0) & 65535u;
	                }
	                uint _20656 = 9849u + ((_12091 / 307u) % 307u);
	                uint _16970 = _20656 / 2u;
	                uint _15273;
	                if ((_20656 & 1u) != 0u)
	                {
	                    _15273 = g_ScrambledHaltonPermutations.Load(_16970 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _15273 = g_ScrambledHaltonPermutations.Load(_16970 * 4 + 0) & 65535u;
	                }
	                uint _20657 = 9849u + ((_12091 / 94249u) % 307u);
	                uint _16971 = _20657 / 2u;
	                uint _15279;
	                if ((_20657 & 1u) != 0u)
	                {
	                    _15279 = g_ScrambledHaltonPermutations.Load(_16971 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _15279 = g_ScrambledHaltonPermutations.Load(_16971 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_15264 * 94249u) + (_15273 * 307u)) + _15279) * 3.4560880379785885452292859554291e-08f;
	                _19095 = true;
	                break;
	            }
	            case 63u:
	            {
	                uint _16151 = 10156u + (_12091 % 311u);
	                uint _16966 = _16151 / 2u;
	                uint _15244;
	                if ((_16151 & 1u) != 0u)
	                {
	                    _15244 = g_ScrambledHaltonPermutations.Load(_16966 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _15244 = g_ScrambledHaltonPermutations.Load(_16966 * 4 + 0) & 65535u;
	                }
	                uint _20654 = 10156u + ((_12091 / 311u) % 311u);
	                uint _16967 = _20654 / 2u;
	                uint _15252;
	                if ((_20654 & 1u) != 0u)
	                {
	                    _15252 = g_ScrambledHaltonPermutations.Load(_16967 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _15252 = g_ScrambledHaltonPermutations.Load(_16967 * 4 + 0) & 65535u;
	                }
	                uint _20655 = 10156u + ((_12091 / 96721u) % 311u);
	                uint _16968 = _20655 / 2u;
	                uint _15258;
	                if ((_20655 & 1u) != 0u)
	                {
	                    _15258 = g_ScrambledHaltonPermutations.Load(_16968 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _15258 = g_ScrambledHaltonPermutations.Load(_16968 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_15244 * 96721u) + (_15252 * 311u)) + _15258) * 3.3244418773392681032419204711914e-08f;
	                _19095 = true;
	                break;
	            }
	            case 64u:
	            {
	                uint _16147 = 10467u + (_12091 % 313u);
	                uint _16963 = _16147 / 2u;
	                uint _15224;
	                if ((_16147 & 1u) != 0u)
	                {
	                    _15224 = g_ScrambledHaltonPermutations.Load(_16963 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _15224 = g_ScrambledHaltonPermutations.Load(_16963 * 4 + 0) & 65535u;
	                }
	                uint _20652 = 10467u + ((_12091 / 313u) % 313u);
	                uint _16964 = _20652 / 2u;
	                uint _15232;
	                if ((_20652 & 1u) != 0u)
	                {
	                    _15232 = g_ScrambledHaltonPermutations.Load(_16964 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _15232 = g_ScrambledHaltonPermutations.Load(_16964 * 4 + 0) & 65535u;
	                }
	                uint _20653 = 10467u + ((_12091 / 97969u) % 313u);
	                uint _16965 = _20653 / 2u;
	                uint _15238;
	                if ((_20653 & 1u) != 0u)
	                {
	                    _15238 = g_ScrambledHaltonPermutations.Load(_16965 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _15238 = g_ScrambledHaltonPermutations.Load(_16965 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_15224 * 97969u) + (_15232 * 313u)) + _15238) * 3.2611211508992710150778293609619e-08f;
	                _19095 = true;
	                break;
	            }
	            case 65u:
	            {
	                uint _16143 = 10780u + (_12091 % 317u);
	                uint _16960 = _16143 / 2u;
	                uint _15204;
	                if ((_16143 & 1u) != 0u)
	                {
	                    _15204 = g_ScrambledHaltonPermutations.Load(_16960 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _15204 = g_ScrambledHaltonPermutations.Load(_16960 * 4 + 0) & 65535u;
	                }
	                uint _20650 = 10780u + ((_12091 / 317u) % 317u);
	                uint _16961 = _20650 / 2u;
	                uint _15212;
	                if ((_20650 & 1u) != 0u)
	                {
	                    _15212 = g_ScrambledHaltonPermutations.Load(_16961 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _15212 = g_ScrambledHaltonPermutations.Load(_16961 * 4 + 0) & 65535u;
	                }
	                uint _20651 = 10780u + ((_12091 / 100489u) % 317u);
	                uint _16962 = _20651 / 2u;
	                uint _15218;
	                if ((_20651 & 1u) != 0u)
	                {
	                    _15218 = g_ScrambledHaltonPermutations.Load(_16962 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _15218 = g_ScrambledHaltonPermutations.Load(_16962 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_15204 * 100489u) + (_15212 * 317u)) + _15218) * 3.1392229260518433875404298305511e-08f;
	                _19095 = true;
	                break;
	            }
	            case 66u:
	            {
	                uint _16139 = 11097u + (_12091 % 331u);
	                uint _16957 = _16139 / 2u;
	                uint _15184;
	                if ((_16139 & 1u) != 0u)
	                {
	                    _15184 = g_ScrambledHaltonPermutations.Load(_16957 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _15184 = g_ScrambledHaltonPermutations.Load(_16957 * 4 + 0) & 65535u;
	                }
	                uint _20648 = 11097u + ((_12091 / 331u) % 331u);
	                uint _16958 = _20648 / 2u;
	                uint _15192;
	                if ((_20648 & 1u) != 0u)
	                {
	                    _15192 = g_ScrambledHaltonPermutations.Load(_16958 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _15192 = g_ScrambledHaltonPermutations.Load(_16958 * 4 + 0) & 65535u;
	                }
	                uint _20649 = 11097u + ((_12091 / 109561u) % 331u);
	                uint _16959 = _20649 / 2u;
	                uint _15198;
	                if ((_20649 & 1u) != 0u)
	                {
	                    _15198 = g_ScrambledHaltonPermutations.Load(_16959 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _15198 = g_ScrambledHaltonPermutations.Load(_16959 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_15184 * 109561u) + (_15192 * 331u)) + _15198) * 2.7575026706472272053360939025879e-08f;
	                _19095 = true;
	                break;
	            }
	            case 67u:
	            {
	                uint _16135 = 11428u + (_12091 % 337u);
	                uint _16954 = _16135 / 2u;
	                uint _15164;
	                if ((_16135 & 1u) != 0u)
	                {
	                    _15164 = g_ScrambledHaltonPermutations.Load(_16954 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _15164 = g_ScrambledHaltonPermutations.Load(_16954 * 4 + 0) & 65535u;
	                }
	                uint _20646 = 11428u + ((_12091 / 337u) % 337u);
	                uint _16955 = _20646 / 2u;
	                uint _15172;
	                if ((_20646 & 1u) != 0u)
	                {
	                    _15172 = g_ScrambledHaltonPermutations.Load(_16955 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _15172 = g_ScrambledHaltonPermutations.Load(_16955 * 4 + 0) & 65535u;
	                }
	                uint _20647 = 11428u + ((_12091 / 113569u) % 337u);
	                uint _16956 = _20647 / 2u;
	                uint _15178;
	                if ((_20647 & 1u) != 0u)
	                {
	                    _15178 = g_ScrambledHaltonPermutations.Load(_16956 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _15178 = g_ScrambledHaltonPermutations.Load(_16956 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_15164 * 113569u) + (_15172 * 337u)) + _15178) * 2.6128246233270147058647125959396e-08f;
	                _19095 = true;
	                break;
	            }
	            case 68u:
	            {
	                uint _16131 = 11765u + (_12091 % 347u);
	                uint _16951 = _16131 / 2u;
	                uint _15144;
	                if ((_16131 & 1u) != 0u)
	                {
	                    _15144 = g_ScrambledHaltonPermutations.Load(_16951 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _15144 = g_ScrambledHaltonPermutations.Load(_16951 * 4 + 0) & 65535u;
	                }
	                uint _20644 = 11765u + ((_12091 / 347u) % 347u);
	                uint _16952 = _20644 / 2u;
	                uint _15152;
	                if ((_20644 & 1u) != 0u)
	                {
	                    _15152 = g_ScrambledHaltonPermutations.Load(_16952 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _15152 = g_ScrambledHaltonPermutations.Load(_16952 * 4 + 0) & 65535u;
	                }
	                uint _20645 = 11765u + ((_12091 / 120409u) % 347u);
	                uint _16953 = _20645 / 2u;
	                uint _15158;
	                if ((_20645 & 1u) != 0u)
	                {
	                    _15158 = g_ScrambledHaltonPermutations.Load(_16953 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _15158 = g_ScrambledHaltonPermutations.Load(_16953 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_15144 * 120409u) + (_15152 * 347u)) + _15158) * 2.3933791837293938442599028348923e-08f;
	                _19095 = true;
	                break;
	            }
	            case 69u:
	            {
	                uint _16127 = 12112u + (_12091 % 349u);
	                uint _16948 = _16127 / 2u;
	                uint _15124;
	                if ((_16127 & 1u) != 0u)
	                {
	                    _15124 = g_ScrambledHaltonPermutations.Load(_16948 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _15124 = g_ScrambledHaltonPermutations.Load(_16948 * 4 + 0) & 65535u;
	                }
	                uint _20642 = 12112u + ((_12091 / 349u) % 349u);
	                uint _16949 = _20642 / 2u;
	                uint _15132;
	                if ((_20642 & 1u) != 0u)
	                {
	                    _15132 = g_ScrambledHaltonPermutations.Load(_16949 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _15132 = g_ScrambledHaltonPermutations.Load(_16949 * 4 + 0) & 65535u;
	                }
	                uint _20643 = 12112u + ((_12091 / 121801u) % 349u);
	                uint _16950 = _20643 / 2u;
	                uint _15138;
	                if ((_20643 & 1u) != 0u)
	                {
	                    _15138 = g_ScrambledHaltonPermutations.Load(_16950 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _15138 = g_ScrambledHaltonPermutations.Load(_16950 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_15124 * 121801u) + (_15132 * 349u)) + _15138) * 2.3524677317254827357828617095947e-08f;
	                _19095 = true;
	                break;
	            }
	            case 70u:
	            {
	                uint _16123 = 12461u + (_12091 % 353u);
	                uint _16945 = _16123 / 2u;
	                uint _15104;
	                if ((_16123 & 1u) != 0u)
	                {
	                    _15104 = g_ScrambledHaltonPermutations.Load(_16945 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _15104 = g_ScrambledHaltonPermutations.Load(_16945 * 4 + 0) & 65535u;
	                }
	                uint _20640 = 12461u + ((_12091 / 353u) % 353u);
	                uint _16946 = _20640 / 2u;
	                uint _15112;
	                if ((_20640 & 1u) != 0u)
	                {
	                    _15112 = g_ScrambledHaltonPermutations.Load(_16946 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _15112 = g_ScrambledHaltonPermutations.Load(_16946 * 4 + 0) & 65535u;
	                }
	                uint _20641 = 12461u + ((_12091 / 124609u) % 353u);
	                uint _16947 = _20641 / 2u;
	                uint _15118;
	                if ((_20641 & 1u) != 0u)
	                {
	                    _15118 = g_ScrambledHaltonPermutations.Load(_16947 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _15118 = g_ScrambledHaltonPermutations.Load(_16947 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_15104 * 124609u) + (_15112 * 353u)) + _15118) * 2.2733999571755703072994947433472e-08f;
	                _19095 = true;
	                break;
	            }
	            case 71u:
	            {
	                uint _16119 = 12814u + (_12091 % 359u);
	                uint _16942 = _16119 / 2u;
	                uint _15084;
	                if ((_16119 & 1u) != 0u)
	                {
	                    _15084 = g_ScrambledHaltonPermutations.Load(_16942 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _15084 = g_ScrambledHaltonPermutations.Load(_16942 * 4 + 0) & 65535u;
	                }
	                uint _20638 = 12814u + ((_12091 / 359u) % 359u);
	                uint _16943 = _20638 / 2u;
	                uint _15092;
	                if ((_20638 & 1u) != 0u)
	                {
	                    _15092 = g_ScrambledHaltonPermutations.Load(_16943 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _15092 = g_ScrambledHaltonPermutations.Load(_16943 * 4 + 0) & 65535u;
	                }
	                uint _20639 = 12814u + ((_12091 / 128881u) % 359u);
	                uint _16944 = _20639 / 2u;
	                uint _15098;
	                if ((_20639 & 1u) != 0u)
	                {
	                    _15098 = g_ScrambledHaltonPermutations.Load(_16944 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _15098 = g_ScrambledHaltonPermutations.Load(_16944 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_15084 * 128881u) + (_15092 * 359u)) + _15098) * 2.1613075773529999423772096633911e-08f;
	                _19095 = true;
	                break;
	            }
	            case 72u:
	            {
	                uint _16115 = 13173u + (_12091 % 367u);
	                uint _16939 = _16115 / 2u;
	                uint _15064;
	                if ((_16115 & 1u) != 0u)
	                {
	                    _15064 = g_ScrambledHaltonPermutations.Load(_16939 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _15064 = g_ScrambledHaltonPermutations.Load(_16939 * 4 + 0) & 65535u;
	                }
	                uint _20636 = 13173u + ((_12091 / 367u) % 367u);
	                uint _16940 = _20636 / 2u;
	                uint _15072;
	                if ((_20636 & 1u) != 0u)
	                {
	                    _15072 = g_ScrambledHaltonPermutations.Load(_16940 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _15072 = g_ScrambledHaltonPermutations.Load(_16940 * 4 + 0) & 65535u;
	                }
	                uint _20637 = 13173u + ((_12091 / 134689u) % 367u);
	                uint _16941 = _20637 / 2u;
	                uint _15078;
	                if ((_20637 & 1u) != 0u)
	                {
	                    _15078 = g_ScrambledHaltonPermutations.Load(_16941 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _15078 = g_ScrambledHaltonPermutations.Load(_16941 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_15064 * 134689u) + (_15072 * 367u)) + _15078) * 2.0230272568255713849794119596481e-08f;
	                _19095 = true;
	                break;
	            }
	            case 73u:
	            {
	                uint _16111 = 13540u + (_12091 % 373u);
	                uint _16936 = _16111 / 2u;
	                uint _15044;
	                if ((_16111 & 1u) != 0u)
	                {
	                    _15044 = g_ScrambledHaltonPermutations.Load(_16936 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _15044 = g_ScrambledHaltonPermutations.Load(_16936 * 4 + 0) & 65535u;
	                }
	                uint _20634 = 13540u + ((_12091 / 373u) % 373u);
	                uint _16937 = _20634 / 2u;
	                uint _15052;
	                if ((_20634 & 1u) != 0u)
	                {
	                    _15052 = g_ScrambledHaltonPermutations.Load(_16937 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _15052 = g_ScrambledHaltonPermutations.Load(_16937 * 4 + 0) & 65535u;
	                }
	                uint _20635 = 13540u + ((_12091 / 139129u) % 373u);
	                uint _16938 = _20635 / 2u;
	                uint _15058;
	                if ((_20635 & 1u) != 0u)
	                {
	                    _15058 = g_ScrambledHaltonPermutations.Load(_16938 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _15058 = g_ScrambledHaltonPermutations.Load(_16938 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_15044 * 139129u) + (_15052 * 373u)) + _15058) * 1.9269633000362773600500077009201e-08f;
	                _19095 = true;
	                break;
	            }
	            case 74u:
	            {
	                uint _16107 = 13913u + (_12091 % 379u);
	                uint _16933 = _16107 / 2u;
	                uint _15024;
	                if ((_16107 & 1u) != 0u)
	                {
	                    _15024 = g_ScrambledHaltonPermutations.Load(_16933 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _15024 = g_ScrambledHaltonPermutations.Load(_16933 * 4 + 0) & 65535u;
	                }
	                uint _20632 = 13913u + ((_12091 / 379u) % 379u);
	                uint _16934 = _20632 / 2u;
	                uint _15032;
	                if ((_20632 & 1u) != 0u)
	                {
	                    _15032 = g_ScrambledHaltonPermutations.Load(_16934 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _15032 = g_ScrambledHaltonPermutations.Load(_16934 * 4 + 0) & 65535u;
	                }
	                uint _20633 = 13913u + ((_12091 / 143641u) % 379u);
	                uint _16935 = _20633 / 2u;
	                uint _15038;
	                if ((_20633 & 1u) != 0u)
	                {
	                    _15038 = g_ScrambledHaltonPermutations.Load(_16935 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _15038 = g_ScrambledHaltonPermutations.Load(_16935 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_15024 * 143641u) + (_15032 * 379u)) + _15038) * 1.8368863763384979392867535352707e-08f;
	                _19095 = true;
	                break;
	            }
	            case 75u:
	            {
	                uint _16103 = 14292u + (_12091 % 383u);
	                uint _16930 = _16103 / 2u;
	                uint _15004;
	                if ((_16103 & 1u) != 0u)
	                {
	                    _15004 = g_ScrambledHaltonPermutations.Load(_16930 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _15004 = g_ScrambledHaltonPermutations.Load(_16930 * 4 + 0) & 65535u;
	                }
	                uint _20630 = 14292u + ((_12091 / 383u) % 383u);
	                uint _16931 = _20630 / 2u;
	                uint _15012;
	                if ((_20630 & 1u) != 0u)
	                {
	                    _15012 = g_ScrambledHaltonPermutations.Load(_16931 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _15012 = g_ScrambledHaltonPermutations.Load(_16931 * 4 + 0) & 65535u;
	                }
	                uint _20631 = 14292u + ((_12091 / 146689u) % 383u);
	                uint _16932 = _20631 / 2u;
	                uint _15018;
	                if ((_20631 & 1u) != 0u)
	                {
	                    _15018 = g_ScrambledHaltonPermutations.Load(_16932 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _15018 = g_ScrambledHaltonPermutations.Load(_16932 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_15004 * 146689u) + (_15012 * 383u)) + _15018) * 1.779932823353647108888253569603e-08f;
	                _19095 = true;
	                break;
	            }
	            case 76u:
	            {
	                uint _16099 = 14675u + (_12091 % 389u);
	                uint _16927 = _16099 / 2u;
	                uint _13550;
	                if ((_16099 & 1u) != 0u)
	                {
	                    _13550 = g_ScrambledHaltonPermutations.Load(_16927 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _13550 = g_ScrambledHaltonPermutations.Load(_16927 * 4 + 0) & 65535u;
	                }
	                uint _20628 = 14675u + ((_12091 / 389u) % 389u);
	                uint _16928 = _20628 / 2u;
	                uint _14992;
	                if ((_20628 & 1u) != 0u)
	                {
	                    _14992 = g_ScrambledHaltonPermutations.Load(_16928 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _14992 = g_ScrambledHaltonPermutations.Load(_16928 * 4 + 0) & 65535u;
	                }
	                uint _20629 = 14675u + ((_12091 / 151321u) % 389u);
	                uint _16929 = _20629 / 2u;
	                uint _14998;
	                if ((_20629 & 1u) != 0u)
	                {
	                    _14998 = g_ScrambledHaltonPermutations.Load(_16929 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _14998 = g_ScrambledHaltonPermutations.Load(_16929 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_13550 * 151321u) + (_14992 * 389u)) + _14998) * 1.6988348505719841341488063335419e-08f;
	                _19095 = true;
	                break;
	            }
	            case 77u:
	            {
	                uint _16095 = 15064u + (_12091 % 397u);
	                uint _16924 = _16095 / 2u;
	                uint _13538;
	                if ((_16095 & 1u) != 0u)
	                {
	                    _13538 = g_ScrambledHaltonPermutations.Load(_16924 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _13538 = g_ScrambledHaltonPermutations.Load(_16924 * 4 + 0) & 65535u;
	                }
	                uint _20626 = 15064u + ((_12091 / 397u) % 397u);
	                uint _16925 = _20626 / 2u;
	                uint _13543;
	                if ((_20626 & 1u) != 0u)
	                {
	                    _13543 = g_ScrambledHaltonPermutations.Load(_16925 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _13543 = g_ScrambledHaltonPermutations.Load(_16925 * 4 + 0) & 65535u;
	                }
	                uint _20627 = 15064u + ((_12091 / 157609u) % 397u);
	                uint _16926 = _20627 / 2u;
	                uint _13547;
	                if ((_20627 & 1u) != 0u)
	                {
	                    _13547 = g_ScrambledHaltonPermutations.Load(_16926 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _13547 = g_ScrambledHaltonPermutations.Load(_16926 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_13538 * 157609u) + (_13543 * 397u)) + _13547) * 1.5981900247652447433210909366608e-08f;
	                _19095 = true;
	                break;
	            }
	            case 78u:
	            {
	                uint _16091 = 15461u + (_12091 % 401u);
	                uint _16921 = _16091 / 2u;
	                uint _13526;
	                if ((_16091 & 1u) != 0u)
	                {
	                    _13526 = g_ScrambledHaltonPermutations.Load(_16921 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _13526 = g_ScrambledHaltonPermutations.Load(_16921 * 4 + 0) & 65535u;
	                }
	                uint _20624 = 15461u + ((_12091 / 401u) % 401u);
	                uint _16922 = _20624 / 2u;
	                uint _13531;
	                if ((_20624 & 1u) != 0u)
	                {
	                    _13531 = g_ScrambledHaltonPermutations.Load(_16922 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _13531 = g_ScrambledHaltonPermutations.Load(_16922 * 4 + 0) & 65535u;
	                }
	                uint _20625 = 15461u + ((_12091 / 160801u) % 401u);
	                uint _16923 = _20625 / 2u;
	                uint _13535;
	                if ((_20625 & 1u) != 0u)
	                {
	                    _13535 = g_ScrambledHaltonPermutations.Load(_16923 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _13535 = g_ScrambledHaltonPermutations.Load(_16923 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_13526 * 160801u) + (_13531 * 401u)) + _13535) * 1.5508394568541916669346392154694e-08f;
	                _19095 = true;
	                break;
	            }
	            case 79u:
	            {
	                uint _16087 = 15862u + (_12091 % 409u);
	                uint _16918 = _16087 / 2u;
	                uint _13514;
	                if ((_16087 & 1u) != 0u)
	                {
	                    _13514 = g_ScrambledHaltonPermutations.Load(_16918 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _13514 = g_ScrambledHaltonPermutations.Load(_16918 * 4 + 0) & 65535u;
	                }
	                uint _20622 = 15862u + ((_12091 / 409u) % 409u);
	                uint _16919 = _20622 / 2u;
	                uint _13519;
	                if ((_20622 & 1u) != 0u)
	                {
	                    _13519 = g_ScrambledHaltonPermutations.Load(_16919 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _13519 = g_ScrambledHaltonPermutations.Load(_16919 * 4 + 0) & 65535u;
	                }
	                uint _20623 = 15862u + ((_12091 / 167281u) % 409u);
	                uint _16920 = _20623 / 2u;
	                uint _13523;
	                if ((_20623 & 1u) != 0u)
	                {
	                    _13523 = g_ScrambledHaltonPermutations.Load(_16920 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _13523 = g_ScrambledHaltonPermutations.Load(_16920 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_13514 * 167281u) + (_13519 * 409u)) + _13523) * 1.4616050592053397849667817354202e-08f;
	                _19095 = true;
	                break;
	            }
	            case 80u:
	            {
	                uint _16083 = 16271u + (_12091 % 419u);
	                uint _16915 = _16083 / 2u;
	                uint _13502;
	                if ((_16083 & 1u) != 0u)
	                {
	                    _13502 = g_ScrambledHaltonPermutations.Load(_16915 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _13502 = g_ScrambledHaltonPermutations.Load(_16915 * 4 + 0) & 65535u;
	                }
	                uint _20620 = 16271u + ((_12091 / 419u) % 419u);
	                uint _16916 = _20620 / 2u;
	                uint _13507;
	                if ((_20620 & 1u) != 0u)
	                {
	                    _13507 = g_ScrambledHaltonPermutations.Load(_16916 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _13507 = g_ScrambledHaltonPermutations.Load(_16916 * 4 + 0) & 65535u;
	                }
	                uint _20621 = 16271u + ((_12091 / 175561u) % 419u);
	                uint _16917 = _20621 / 2u;
	                uint _13511;
	                if ((_20621 & 1u) != 0u)
	                {
	                    _13511 = g_ScrambledHaltonPermutations.Load(_16917 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _13511 = g_ScrambledHaltonPermutations.Load(_16917 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_13502 * 175561u) + (_13507 * 419u)) + _13511) * 1.3594332770594519388396292924881e-08f;
	                _19095 = true;
	                break;
	            }
	            case 81u:
	            {
	                uint _16079 = 16690u + (_12091 % 421u);
	                uint _16912 = _16079 / 2u;
	                uint _13490;
	                if ((_16079 & 1u) != 0u)
	                {
	                    _13490 = g_ScrambledHaltonPermutations.Load(_16912 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _13490 = g_ScrambledHaltonPermutations.Load(_16912 * 4 + 0) & 65535u;
	                }
	                uint _20618 = 16690u + ((_12091 / 421u) % 421u);
	                uint _16913 = _20618 / 2u;
	                uint _13495;
	                if ((_20618 & 1u) != 0u)
	                {
	                    _13495 = g_ScrambledHaltonPermutations.Load(_16913 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _13495 = g_ScrambledHaltonPermutations.Load(_16913 * 4 + 0) & 65535u;
	                }
	                uint _20619 = 16690u + ((_12091 / 177241u) % 421u);
	                uint _16914 = _20619 / 2u;
	                uint _13499;
	                if ((_20619 & 1u) != 0u)
	                {
	                    _13499 = g_ScrambledHaltonPermutations.Load(_16914 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _13499 = g_ScrambledHaltonPermutations.Load(_16914 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_13490 * 177241u) + (_13495 * 421u)) + _13499) * 1.3401507459320782800205051898956e-08f;
	                _19095 = true;
	                break;
	            }
	            case 82u:
	            {
	                uint _16075 = 17111u + (_12091 % 431u);
	                uint _16909 = _16075 / 2u;
	                uint _13478;
	                if ((_16075 & 1u) != 0u)
	                {
	                    _13478 = g_ScrambledHaltonPermutations.Load(_16909 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _13478 = g_ScrambledHaltonPermutations.Load(_16909 * 4 + 0) & 65535u;
	                }
	                uint _20616 = 17111u + ((_12091 / 431u) % 431u);
	                uint _16910 = _20616 / 2u;
	                uint _13483;
	                if ((_20616 & 1u) != 0u)
	                {
	                    _13483 = g_ScrambledHaltonPermutations.Load(_16910 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _13483 = g_ScrambledHaltonPermutations.Load(_16910 * 4 + 0) & 65535u;
	                }
	                uint _20617 = 17111u + ((_12091 / 185761u) % 431u);
	                uint _16911 = _20617 / 2u;
	                uint _13487;
	                if ((_20617 & 1u) != 0u)
	                {
	                    _13487 = g_ScrambledHaltonPermutations.Load(_16911 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _13487 = g_ScrambledHaltonPermutations.Load(_16911 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_13478 * 185761u) + (_13483 * 431u)) + _13487) * 1.249016357007803890155628323555e-08f;
	                _19095 = true;
	                break;
	            }
	            case 83u:
	            {
	                uint _16071 = 17542u + (_12091 % 433u);
	                uint _16906 = _16071 / 2u;
	                uint _13466;
	                if ((_16071 & 1u) != 0u)
	                {
	                    _13466 = g_ScrambledHaltonPermutations.Load(_16906 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _13466 = g_ScrambledHaltonPermutations.Load(_16906 * 4 + 0) & 65535u;
	                }
	                uint _20614 = 17542u + ((_12091 / 433u) % 433u);
	                uint _16907 = _20614 / 2u;
	                uint _13471;
	                if ((_20614 & 1u) != 0u)
	                {
	                    _13471 = g_ScrambledHaltonPermutations.Load(_16907 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _13471 = g_ScrambledHaltonPermutations.Load(_16907 * 4 + 0) & 65535u;
	                }
	                uint _20615 = 17542u + ((_12091 / 187489u) % 433u);
	                uint _16908 = _20615 / 2u;
	                uint _13475;
	                if ((_20615 & 1u) != 0u)
	                {
	                    _13475 = g_ScrambledHaltonPermutations.Load(_16908 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _13475 = g_ScrambledHaltonPermutations.Load(_16908 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_13466 * 187489u) + (_13471 * 433u)) + _13475) * 1.2317888042900904110865667462349e-08f;
	                _19095 = true;
	                break;
	            }
	            case 84u:
	            {
	                uint _16067 = 17975u + (_12091 % 439u);
	                uint _16903 = _16067 / 2u;
	                uint _13454;
	                if ((_16067 & 1u) != 0u)
	                {
	                    _13454 = g_ScrambledHaltonPermutations.Load(_16903 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _13454 = g_ScrambledHaltonPermutations.Load(_16903 * 4 + 0) & 65535u;
	                }
	                uint _20612 = 17975u + ((_12091 / 439u) % 439u);
	                uint _16904 = _20612 / 2u;
	                uint _13459;
	                if ((_20612 & 1u) != 0u)
	                {
	                    _13459 = g_ScrambledHaltonPermutations.Load(_16904 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _13459 = g_ScrambledHaltonPermutations.Load(_16904 * 4 + 0) & 65535u;
	                }
	                uint _20613 = 17975u + ((_12091 / 192721u) % 439u);
	                uint _16905 = _20613 / 2u;
	                uint _13463;
	                if ((_20613 & 1u) != 0u)
	                {
	                    _13463 = g_ScrambledHaltonPermutations.Load(_16905 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _13463 = g_ScrambledHaltonPermutations.Load(_16905 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_13454 * 192721u) + (_13459 * 439u)) + _13463) * 1.1819698109150067466543987393379e-08f;
	                _19095 = true;
	                break;
	            }
	            case 85u:
	            {
	                uint _16063 = 18414u + (_12091 % 443u);
	                uint _16900 = _16063 / 2u;
	                uint _13442;
	                if ((_16063 & 1u) != 0u)
	                {
	                    _13442 = g_ScrambledHaltonPermutations.Load(_16900 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _13442 = g_ScrambledHaltonPermutations.Load(_16900 * 4 + 0) & 65535u;
	                }
	                uint _20610 = 18414u + ((_12091 / 443u) % 443u);
	                uint _16901 = _20610 / 2u;
	                uint _13447;
	                if ((_20610 & 1u) != 0u)
	                {
	                    _13447 = g_ScrambledHaltonPermutations.Load(_16901 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _13447 = g_ScrambledHaltonPermutations.Load(_16901 * 4 + 0) & 65535u;
	                }
	                uint _20611 = 18414u + ((_12091 / 196249u) % 443u);
	                uint _16902 = _20611 / 2u;
	                uint _13451;
	                if ((_20611 & 1u) != 0u)
	                {
	                    _13451 = g_ScrambledHaltonPermutations.Load(_16902 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _13451 = g_ScrambledHaltonPermutations.Load(_16902 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_13442 * 196249u) + (_13447 * 443u)) + _13451) * 1.1502408803210073529044166207314e-08f;
	                _19095 = true;
	                break;
	            }
	            case 86u:
	            {
	                uint _16059 = 18857u + (_12091 % 449u);
	                uint _16897 = _16059 / 2u;
	                uint _13430;
	                if ((_16059 & 1u) != 0u)
	                {
	                    _13430 = g_ScrambledHaltonPermutations.Load(_16897 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _13430 = g_ScrambledHaltonPermutations.Load(_16897 * 4 + 0) & 65535u;
	                }
	                uint _20608 = 18857u + ((_12091 / 449u) % 449u);
	                uint _16898 = _20608 / 2u;
	                uint _13435;
	                if ((_20608 & 1u) != 0u)
	                {
	                    _13435 = g_ScrambledHaltonPermutations.Load(_16898 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _13435 = g_ScrambledHaltonPermutations.Load(_16898 * 4 + 0) & 65535u;
	                }
	                uint _20609 = 18857u + ((_12091 / 201601u) % 449u);
	                uint _16899 = _20609 / 2u;
	                uint _13439;
	                if ((_20609 & 1u) != 0u)
	                {
	                    _13439 = g_ScrambledHaltonPermutations.Load(_16899 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _13439 = g_ScrambledHaltonPermutations.Load(_16899 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_13430 * 201601u) + (_13435 * 449u)) + _13439) * 1.1047421644150290376273915171623e-08f;
	                _19095 = true;
	                break;
	            }
	            case 87u:
	            {
	                uint _16055 = 19306u + (_12091 % 457u);
	                uint _16894 = _16055 / 2u;
	                uint _13418;
	                if ((_16055 & 1u) != 0u)
	                {
	                    _13418 = g_ScrambledHaltonPermutations.Load(_16894 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _13418 = g_ScrambledHaltonPermutations.Load(_16894 * 4 + 0) & 65535u;
	                }
	                uint _20606 = 19306u + ((_12091 / 457u) % 457u);
	                uint _16895 = _20606 / 2u;
	                uint _13423;
	                if ((_20606 & 1u) != 0u)
	                {
	                    _13423 = g_ScrambledHaltonPermutations.Load(_16895 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _13423 = g_ScrambledHaltonPermutations.Load(_16895 * 4 + 0) & 65535u;
	                }
	                uint _20607 = 19306u + ((_12091 / 208849u) % 457u);
	                uint _16896 = _20607 / 2u;
	                uint _13427;
	                if ((_20607 & 1u) != 0u)
	                {
	                    _13427 = g_ScrambledHaltonPermutations.Load(_16896 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _13427 = g_ScrambledHaltonPermutations.Load(_16896 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_13418 * 208849u) + (_13423 * 457u)) + _13427) * 1.0477347878179443796398118138313e-08f;
	                _19095 = true;
	                break;
	            }
	            case 88u:
	            {
	                uint _16051 = 19763u + (_12091 % 461u);
	                uint _16891 = _16051 / 2u;
	                uint _13406;
	                if ((_16051 & 1u) != 0u)
	                {
	                    _13406 = g_ScrambledHaltonPermutations.Load(_16891 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _13406 = g_ScrambledHaltonPermutations.Load(_16891 * 4 + 0) & 65535u;
	                }
	                uint _20604 = 19763u + ((_12091 / 461u) % 461u);
	                uint _16892 = _20604 / 2u;
	                uint _13411;
	                if ((_20604 & 1u) != 0u)
	                {
	                    _13411 = g_ScrambledHaltonPermutations.Load(_16892 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _13411 = g_ScrambledHaltonPermutations.Load(_16892 * 4 + 0) & 65535u;
	                }
	                uint _20605 = 19763u + ((_12091 / 212521u) % 461u);
	                uint _16893 = _20605 / 2u;
	                uint _13415;
	                if ((_20605 & 1u) != 0u)
	                {
	                    _13415 = g_ScrambledHaltonPermutations.Load(_16893 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _13415 = g_ScrambledHaltonPermutations.Load(_16893 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_13406 * 212521u) + (_13411 * 461u)) + _13415) * 1.0206977485438528674421831965446e-08f;
	                _19095 = true;
	                break;
	            }
	            case 89u:
	            {
	                uint _16047 = 20224u + (_12091 % 463u);
	                uint _16888 = _16047 / 2u;
	                uint _13394;
	                if ((_16047 & 1u) != 0u)
	                {
	                    _13394 = g_ScrambledHaltonPermutations.Load(_16888 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _13394 = g_ScrambledHaltonPermutations.Load(_16888 * 4 + 0) & 65535u;
	                }
	                uint _20602 = 20224u + ((_12091 / 463u) % 463u);
	                uint _16889 = _20602 / 2u;
	                uint _13399;
	                if ((_20602 & 1u) != 0u)
	                {
	                    _13399 = g_ScrambledHaltonPermutations.Load(_16889 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _13399 = g_ScrambledHaltonPermutations.Load(_16889 * 4 + 0) & 65535u;
	                }
	                uint _20603 = 20224u + ((_12091 / 214369u) % 463u);
	                uint _16890 = _20603 / 2u;
	                uint _13403;
	                if ((_20603 & 1u) != 0u)
	                {
	                    _13403 = g_ScrambledHaltonPermutations.Load(_16890 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _13403 = g_ScrambledHaltonPermutations.Load(_16890 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_13394 * 214369u) + (_13399 * 463u)) + _13403) * 1.007527661300855470472015440464e-08f;
	                _19095 = true;
	                break;
	            }
	            case 90u:
	            {
	                uint _16043 = 20687u + (_12091 % 467u);
	                uint _16885 = _16043 / 2u;
	                uint _13382;
	                if ((_16043 & 1u) != 0u)
	                {
	                    _13382 = g_ScrambledHaltonPermutations.Load(_16885 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _13382 = g_ScrambledHaltonPermutations.Load(_16885 * 4 + 0) & 65535u;
	                }
	                uint _20600 = 20687u + ((_12091 / 467u) % 467u);
	                uint _16886 = _20600 / 2u;
	                uint _13387;
	                if ((_20600 & 1u) != 0u)
	                {
	                    _13387 = g_ScrambledHaltonPermutations.Load(_16886 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _13387 = g_ScrambledHaltonPermutations.Load(_16886 * 4 + 0) & 65535u;
	                }
	                uint _20601 = 20687u + ((_12091 / 218089u) % 467u);
	                uint _16887 = _20601 / 2u;
	                uint _13391;
	                if ((_20601 & 1u) != 0u)
	                {
	                    _13391 = g_ScrambledHaltonPermutations.Load(_16887 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _13391 = g_ScrambledHaltonPermutations.Load(_16887 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_13382 * 218089u) + (_13387 * 467u)) + _13391) * 9.8185948260720579128246754407883e-09f;
	                _19095 = true;
	                break;
	            }
	            case 91u:
	            {
	                uint _16039 = 21154u + (_12091 % 479u);
	                uint _16882 = _16039 / 2u;
	                uint _13370;
	                if ((_16039 & 1u) != 0u)
	                {
	                    _13370 = g_ScrambledHaltonPermutations.Load(_16882 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _13370 = g_ScrambledHaltonPermutations.Load(_16882 * 4 + 0) & 65535u;
	                }
	                uint _20598 = 21154u + ((_12091 / 479u) % 479u);
	                uint _16883 = _20598 / 2u;
	                uint _13375;
	                if ((_20598 & 1u) != 0u)
	                {
	                    _13375 = g_ScrambledHaltonPermutations.Load(_16883 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _13375 = g_ScrambledHaltonPermutations.Load(_16883 * 4 + 0) & 65535u;
	                }
	                uint _20599 = 21154u + ((_12091 / 229441u) % 479u);
	                uint _16884 = _20599 / 2u;
	                uint _13379;
	                if ((_20599 & 1u) != 0u)
	                {
	                    _13379 = g_ScrambledHaltonPermutations.Load(_16884 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _13379 = g_ScrambledHaltonPermutations.Load(_16884 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_13370 * 229441u) + (_13375 * 479u)) + _13379) * 9.0989944467878558498341590166092e-09f;
	                _19095 = true;
	                break;
	            }
	            case 92u:
	            {
	                uint _16035 = 21633u + (_12091 % 487u);
	                uint _16879 = _16035 / 2u;
	                uint _13358;
	                if ((_16035 & 1u) != 0u)
	                {
	                    _13358 = g_ScrambledHaltonPermutations.Load(_16879 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _13358 = g_ScrambledHaltonPermutations.Load(_16879 * 4 + 0) & 65535u;
	                }
	                uint _20596 = 21633u + ((_12091 / 487u) % 487u);
	                uint _16880 = _20596 / 2u;
	                uint _13363;
	                if ((_20596 & 1u) != 0u)
	                {
	                    _13363 = g_ScrambledHaltonPermutations.Load(_16880 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _13363 = g_ScrambledHaltonPermutations.Load(_16880 * 4 + 0) & 65535u;
	                }
	                uint _20597 = 21633u + ((_12091 / 237169u) % 487u);
	                uint _16881 = _20597 / 2u;
	                uint _13367;
	                if ((_20597 & 1u) != 0u)
	                {
	                    _13367 = g_ScrambledHaltonPermutations.Load(_16881 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _13367 = g_ScrambledHaltonPermutations.Load(_16881 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_13358 * 237169u) + (_13363 * 487u)) + _13367) * 8.6579099445316387573257088661194e-09f;
	                _19095 = true;
	                break;
	            }
	            case 93u:
	            {
	                uint _16031 = 22120u + (_12091 % 491u);
	                uint _16876 = _16031 / 2u;
	                uint _13346;
	                if ((_16031 & 1u) != 0u)
	                {
	                    _13346 = g_ScrambledHaltonPermutations.Load(_16876 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _13346 = g_ScrambledHaltonPermutations.Load(_16876 * 4 + 0) & 65535u;
	                }
	                uint _20594 = 22120u + ((_12091 / 491u) % 491u);
	                uint _16877 = _20594 / 2u;
	                uint _13351;
	                if ((_20594 & 1u) != 0u)
	                {
	                    _13351 = g_ScrambledHaltonPermutations.Load(_16877 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _13351 = g_ScrambledHaltonPermutations.Load(_16877 * 4 + 0) & 65535u;
	                }
	                uint _20595 = 22120u + ((_12091 / 241081u) % 491u);
	                uint _16878 = _20595 / 2u;
	                uint _13355;
	                if ((_20595 & 1u) != 0u)
	                {
	                    _13355 = g_ScrambledHaltonPermutations.Load(_16878 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _13355 = g_ScrambledHaltonPermutations.Load(_16878 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_13346 * 241081u) + (_13351 * 491u)) + _13355) * 8.4480307194212400645483285188675e-09f;
	                _19095 = true;
	                break;
	            }
	            case 94u:
	            {
	                uint _16027 = 22611u + (_12091 % 499u);
	                uint _16873 = _16027 / 2u;
	                uint _13334;
	                if ((_16027 & 1u) != 0u)
	                {
	                    _13334 = g_ScrambledHaltonPermutations.Load(_16873 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _13334 = g_ScrambledHaltonPermutations.Load(_16873 * 4 + 0) & 65535u;
	                }
	                uint _20592 = 22611u + ((_12091 / 499u) % 499u);
	                uint _16874 = _20592 / 2u;
	                uint _13339;
	                if ((_20592 & 1u) != 0u)
	                {
	                    _13339 = g_ScrambledHaltonPermutations.Load(_16874 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _13339 = g_ScrambledHaltonPermutations.Load(_16874 * 4 + 0) & 65535u;
	                }
	                uint _20593 = 22611u + ((_12091 / 249001u) % 499u);
	                uint _16875 = _20593 / 2u;
	                uint _13343;
	                if ((_20593 & 1u) != 0u)
	                {
	                    _13343 = g_ScrambledHaltonPermutations.Load(_16875 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _13343 = g_ScrambledHaltonPermutations.Load(_16875 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_13334 * 249001u) + (_13339 * 499u)) + _13343) * 8.0481914466190573875792324542999e-09f;
	                _19095 = true;
	                break;
	            }
	            case 95u:
	            {
	                uint _16023 = 23110u + (_12091 % 503u);
	                uint _16870 = _16023 / 2u;
	                uint _13322;
	                if ((_16023 & 1u) != 0u)
	                {
	                    _13322 = g_ScrambledHaltonPermutations.Load(_16870 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _13322 = g_ScrambledHaltonPermutations.Load(_16870 * 4 + 0) & 65535u;
	                }
	                uint _20590 = 23110u + ((_12091 / 503u) % 503u);
	                uint _16871 = _20590 / 2u;
	                uint _13327;
	                if ((_20590 & 1u) != 0u)
	                {
	                    _13327 = g_ScrambledHaltonPermutations.Load(_16871 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _13327 = g_ScrambledHaltonPermutations.Load(_16871 * 4 + 0) & 65535u;
	                }
	                uint _20591 = 23110u + ((_12091 / 253009u) % 503u);
	                uint _16872 = _20591 / 2u;
	                uint _13331;
	                if ((_20591 & 1u) != 0u)
	                {
	                    _13331 = g_ScrambledHaltonPermutations.Load(_16872 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _13331 = g_ScrambledHaltonPermutations.Load(_16872 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_13322 * 253009u) + (_13327 * 503u)) + _13331) * 7.8577100381949094298761337995529e-09f;
	                _19095 = true;
	                break;
	            }
	            case 96u:
	            {
	                uint _16019 = 23613u + (_12091 % 509u);
	                uint _16867 = _16019 / 2u;
	                uint _13150;
	                if ((_16019 & 1u) != 0u)
	                {
	                    _13150 = g_ScrambledHaltonPermutations.Load(_16867 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _13150 = g_ScrambledHaltonPermutations.Load(_16867 * 4 + 0) & 65535u;
	                }
	                uint _20588 = 23613u + ((_12091 / 509u) % 509u);
	                uint _16868 = _20588 / 2u;
	                uint _13315;
	                if ((_20588 & 1u) != 0u)
	                {
	                    _13315 = g_ScrambledHaltonPermutations.Load(_16868 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _13315 = g_ScrambledHaltonPermutations.Load(_16868 * 4 + 0) & 65535u;
	                }
	                uint _20589 = 23613u + ((_12091 / 259081u) % 509u);
	                uint _16869 = _20589 / 2u;
	                uint _13319;
	                if ((_20589 & 1u) != 0u)
	                {
	                    _13319 = g_ScrambledHaltonPermutations.Load(_16869 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _13319 = g_ScrambledHaltonPermutations.Load(_16869 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_13150 * 259081u) + (_13315 * 509u)) + _13319) * 7.5830968171430868096649646759033e-09f;
	                _19095 = true;
	                break;
	            }
	            case 97u:
	            {
	                uint _16015 = 24122u + (_12091 % 521u);
	                uint _16864 = _16015 / 2u;
	                uint _13139;
	                if ((_16015 & 1u) != 0u)
	                {
	                    _13139 = g_ScrambledHaltonPermutations.Load(_16864 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _13139 = g_ScrambledHaltonPermutations.Load(_16864 * 4 + 0) & 65535u;
	                }
	                uint _20586 = 24122u + ((_12091 / 521u) % 521u);
	                uint _16865 = _20586 / 2u;
	                uint _13144;
	                if ((_20586 & 1u) != 0u)
	                {
	                    _13144 = g_ScrambledHaltonPermutations.Load(_16865 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _13144 = g_ScrambledHaltonPermutations.Load(_16865 * 4 + 0) & 65535u;
	                }
	                uint _20587 = 24122u + ((_12091 / 271441u) % 521u);
	                uint _16866 = _20587 / 2u;
	                uint _13147;
	                if ((_20587 & 1u) != 0u)
	                {
	                    _13147 = g_ScrambledHaltonPermutations.Load(_16866 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _13147 = g_ScrambledHaltonPermutations.Load(_16866 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_13139 * 271441u) + (_13144 * 521u)) + _13147) * 7.0710965971443329181056469678879e-09f;
	                _19095 = true;
	                break;
	            }
	            case 98u:
	            {
	                uint _16011 = 24643u + (_12091 % 523u);
	                uint _16861 = _16011 / 2u;
	                uint _13127;
	                if ((_16011 & 1u) != 0u)
	                {
	                    _13127 = g_ScrambledHaltonPermutations.Load(_16861 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _13127 = g_ScrambledHaltonPermutations.Load(_16861 * 4 + 0) & 65535u;
	                }
	                uint _20584 = 24643u + ((_12091 / 523u) % 523u);
	                uint _16862 = _20584 / 2u;
	                uint _13132;
	                if ((_20584 & 1u) != 0u)
	                {
	                    _13132 = g_ScrambledHaltonPermutations.Load(_16862 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _13132 = g_ScrambledHaltonPermutations.Load(_16862 * 4 + 0) & 65535u;
	                }
	                uint _20585 = 24643u + ((_12091 / 273529u) % 523u);
	                uint _16863 = _20585 / 2u;
	                uint _13135;
	                if ((_20585 & 1u) != 0u)
	                {
	                    _13135 = g_ScrambledHaltonPermutations.Load(_16863 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _13135 = g_ScrambledHaltonPermutations.Load(_16863 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_13127 * 273529u) + (_13132 * 523u)) + _13135) * 6.9902852395387071737786754965782e-09f;
	                _19095 = true;
	                break;
	            }
	            case 99u:
	            {
	                uint _16007 = 25166u + (_12091 % 541u);
	                uint _16858 = _16007 / 2u;
	                uint _13116;
	                if ((_16007 & 1u) != 0u)
	                {
	                    _13116 = g_ScrambledHaltonPermutations.Load(_16858 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _13116 = g_ScrambledHaltonPermutations.Load(_16858 * 4 + 0) & 65535u;
	                }
	                uint _20582 = 25166u + ((_12091 / 541u) % 541u);
	                uint _16859 = _20582 / 2u;
	                uint _13121;
	                if ((_20582 & 1u) != 0u)
	                {
	                    _13121 = g_ScrambledHaltonPermutations.Load(_16859 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _13121 = g_ScrambledHaltonPermutations.Load(_16859 * 4 + 0) & 65535u;
	                }
	                uint _20583 = 25166u + ((_12091 / 292681u) % 541u);
	                uint _16860 = _20583 / 2u;
	                uint _13124;
	                if ((_20583 & 1u) != 0u)
	                {
	                    _13124 = g_ScrambledHaltonPermutations.Load(_16860 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _13124 = g_ScrambledHaltonPermutations.Load(_16860 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_13116 * 292681u) + (_13121 * 541u)) + _13124) * 6.3155063401154620805755257606506e-09f;
	                _19095 = true;
	                break;
	            }
	            case 100u:
	            {
	                uint _16003 = 25707u + (_12091 % 547u);
	                uint _16855 = _16003 / 2u;
	                uint _13105;
	                if ((_16003 & 1u) != 0u)
	                {
	                    _13105 = g_ScrambledHaltonPermutations.Load(_16855 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _13105 = g_ScrambledHaltonPermutations.Load(_16855 * 4 + 0) & 65535u;
	                }
	                uint _20580 = 25707u + ((_12091 / 547u) % 547u);
	                uint _16856 = _20580 / 2u;
	                uint _13110;
	                if ((_20580 & 1u) != 0u)
	                {
	                    _13110 = g_ScrambledHaltonPermutations.Load(_16856 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _13110 = g_ScrambledHaltonPermutations.Load(_16856 * 4 + 0) & 65535u;
	                }
	                uint _20581 = 25707u + ((_12091 / 299209u) % 547u);
	                uint _16857 = _20581 / 2u;
	                uint _13113;
	                if ((_20581 & 1u) != 0u)
	                {
	                    _13113 = g_ScrambledHaltonPermutations.Load(_16857 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _13113 = g_ScrambledHaltonPermutations.Load(_16857 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_13105 * 299209u) + (_13110 * 547u)) + _13113) * 6.1099543202658423979301005601883e-09f;
	                _19095 = true;
	                break;
	            }
	            case 101u:
	            {
	                uint _15999 = 26254u + (_12091 % 557u);
	                uint _16852 = _15999 / 2u;
	                uint _13094;
	                if ((_15999 & 1u) != 0u)
	                {
	                    _13094 = g_ScrambledHaltonPermutations.Load(_16852 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _13094 = g_ScrambledHaltonPermutations.Load(_16852 * 4 + 0) & 65535u;
	                }
	                uint _20578 = 26254u + ((_12091 / 557u) % 557u);
	                uint _16853 = _20578 / 2u;
	                uint _13099;
	                if ((_20578 & 1u) != 0u)
	                {
	                    _13099 = g_ScrambledHaltonPermutations.Load(_16853 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _13099 = g_ScrambledHaltonPermutations.Load(_16853 * 4 + 0) & 65535u;
	                }
	                uint _20579 = 26254u + ((_12091 / 310249u) % 557u);
	                uint _16854 = _20579 / 2u;
	                uint _13102;
	                if ((_20579 & 1u) != 0u)
	                {
	                    _13102 = g_ScrambledHaltonPermutations.Load(_16854 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _13102 = g_ScrambledHaltonPermutations.Load(_16854 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_13094 * 310249u) + (_13099 * 557u)) + _13102) * 5.7867453051585471257567405700684e-09f;
	                _19095 = true;
	                break;
	            }
	            case 102u:
	            {
	                uint _15995 = 26811u + (_12091 % 563u);
	                uint _16849 = _15995 / 2u;
	                uint _13083;
	                if ((_15995 & 1u) != 0u)
	                {
	                    _13083 = g_ScrambledHaltonPermutations.Load(_16849 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _13083 = g_ScrambledHaltonPermutations.Load(_16849 * 4 + 0) & 65535u;
	                }
	                uint _20576 = 26811u + ((_12091 / 563u) % 563u);
	                uint _16850 = _20576 / 2u;
	                uint _13088;
	                if ((_20576 & 1u) != 0u)
	                {
	                    _13088 = g_ScrambledHaltonPermutations.Load(_16850 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _13088 = g_ScrambledHaltonPermutations.Load(_16850 * 4 + 0) & 65535u;
	                }
	                uint _20577 = 26811u + ((_12091 / 316969u) % 563u);
	                uint _16851 = _20577 / 2u;
	                uint _13091;
	                if ((_20577 & 1u) != 0u)
	                {
	                    _13091 = g_ScrambledHaltonPermutations.Load(_16851 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _13091 = g_ScrambledHaltonPermutations.Load(_16851 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_13083 * 316969u) + (_13088 * 563u)) + _13091) * 5.6036983941964990663109347224236e-09f;
	                _19095 = true;
	                break;
	            }
	            case 103u:
	            {
	                uint _15991 = 27374u + (_12091 % 569u);
	                uint _16846 = _15991 / 2u;
	                uint _13072;
	                if ((_15991 & 1u) != 0u)
	                {
	                    _13072 = g_ScrambledHaltonPermutations.Load(_16846 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _13072 = g_ScrambledHaltonPermutations.Load(_16846 * 4 + 0) & 65535u;
	                }
	                uint _20574 = 27374u + ((_12091 / 569u) % 569u);
	                uint _16847 = _20574 / 2u;
	                uint _13077;
	                if ((_20574 & 1u) != 0u)
	                {
	                    _13077 = g_ScrambledHaltonPermutations.Load(_16847 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _13077 = g_ScrambledHaltonPermutations.Load(_16847 * 4 + 0) & 65535u;
	                }
	                uint _20575 = 27374u + ((_12091 / 323761u) % 569u);
	                uint _16848 = _20575 / 2u;
	                uint _13080;
	                if ((_20575 & 1u) != 0u)
	                {
	                    _13080 = g_ScrambledHaltonPermutations.Load(_16848 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _13080 = g_ScrambledHaltonPermutations.Load(_16848 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_13072 * 323761u) + (_13077 * 569u)) + _13080) * 5.4282911499115016340510919690132e-09f;
	                _19095 = true;
	                break;
	            }
	            case 104u:
	            {
	                uint _15987 = 27943u + (_12091 % 571u);
	                uint _16843 = _15987 / 2u;
	                uint _13061;
	                if ((_15987 & 1u) != 0u)
	                {
	                    _13061 = g_ScrambledHaltonPermutations.Load(_16843 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _13061 = g_ScrambledHaltonPermutations.Load(_16843 * 4 + 0) & 65535u;
	                }
	                uint _20572 = 27943u + ((_12091 / 571u) % 571u);
	                uint _16844 = _20572 / 2u;
	                uint _13066;
	                if ((_20572 & 1u) != 0u)
	                {
	                    _13066 = g_ScrambledHaltonPermutations.Load(_16844 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _13066 = g_ScrambledHaltonPermutations.Load(_16844 * 4 + 0) & 65535u;
	                }
	                uint _20573 = 27943u + ((_12091 / 326041u) % 571u);
	                uint _16845 = _20573 / 2u;
	                uint _13069;
	                if ((_20573 & 1u) != 0u)
	                {
	                    _13069 = g_ScrambledHaltonPermutations.Load(_16845 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _13069 = g_ScrambledHaltonPermutations.Load(_16845 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_13061 * 326041u) + (_13066 * 571u)) + _13069) * 5.3714512837643724196823313832283e-09f;
	                _19095 = true;
	                break;
	            }
	            case 105u:
	            {
	                uint _15983 = 28514u + (_12091 % 577u);
	                uint _16840 = _15983 / 2u;
	                uint _11992;
	                if ((_15983 & 1u) != 0u)
	                {
	                    _11992 = g_ScrambledHaltonPermutations.Load(_16840 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11992 = g_ScrambledHaltonPermutations.Load(_16840 * 4 + 0) & 65535u;
	                }
	                uint _20570 = 28514u + ((_12091 / 577u) % 577u);
	                uint _16841 = _20570 / 2u;
	                uint _13055;
	                if ((_20570 & 1u) != 0u)
	                {
	                    _13055 = g_ScrambledHaltonPermutations.Load(_16841 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _13055 = g_ScrambledHaltonPermutations.Load(_16841 * 4 + 0) & 65535u;
	                }
	                uint _20571 = 28514u + ((_12091 / 332929u) % 577u);
	                uint _16842 = _20571 / 2u;
	                uint _13058;
	                if ((_20571 & 1u) != 0u)
	                {
	                    _13058 = g_ScrambledHaltonPermutations.Load(_16842 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _13058 = g_ScrambledHaltonPermutations.Load(_16842 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11992 * 332929u) + (_13055 * 577u)) + _13058) * 5.2056203792005817376775667071342e-09f;
	                _19095 = true;
	                break;
	            }
	            case 106u:
	            {
	                uint _15979 = 29091u + (_12091 % 587u);
	                uint _16837 = _15979 / 2u;
	                uint _11988;
	                if ((_15979 & 1u) != 0u)
	                {
	                    _11988 = g_ScrambledHaltonPermutations.Load(_16837 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11988 = g_ScrambledHaltonPermutations.Load(_16837 * 4 + 0) & 65535u;
	                }
	                uint _20568 = 29091u + ((_12091 / 587u) % 587u);
	                uint _16838 = _20568 / 2u;
	                uint _11990;
	                if ((_20568 & 1u) != 0u)
	                {
	                    _11990 = g_ScrambledHaltonPermutations.Load(_16838 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11990 = g_ScrambledHaltonPermutations.Load(_16838 * 4 + 0) & 65535u;
	                }
	                uint _20569 = 29091u + ((_12091 / 344569u) % 587u);
	                uint _16839 = _20569 / 2u;
	                uint _11991;
	                if ((_20569 & 1u) != 0u)
	                {
	                    _11991 = g_ScrambledHaltonPermutations.Load(_16839 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11991 = g_ScrambledHaltonPermutations.Load(_16839 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11988 * 344569u) + (_11990 * 587u)) + _11991) * 4.9440820326651646610116586089134e-09f;
	                _19095 = true;
	                break;
	            }
	            case 107u:
	            {
	                uint _15975 = 29678u + (_12091 % 593u);
	                uint _16834 = _15975 / 2u;
	                uint _11984;
	                if ((_15975 & 1u) != 0u)
	                {
	                    _11984 = g_ScrambledHaltonPermutations.Load(_16834 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11984 = g_ScrambledHaltonPermutations.Load(_16834 * 4 + 0) & 65535u;
	                }
	                uint _20566 = 29678u + ((_12091 / 593u) % 593u);
	                uint _16835 = _20566 / 2u;
	                uint _11986;
	                if ((_20566 & 1u) != 0u)
	                {
	                    _11986 = g_ScrambledHaltonPermutations.Load(_16835 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11986 = g_ScrambledHaltonPermutations.Load(_16835 * 4 + 0) & 65535u;
	                }
	                uint _20567 = 29678u + ((_12091 / 351649u) % 593u);
	                uint _16836 = _20567 / 2u;
	                uint _11987;
	                if ((_20567 & 1u) != 0u)
	                {
	                    _11987 = g_ScrambledHaltonPermutations.Load(_16836 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11987 = g_ScrambledHaltonPermutations.Load(_16836 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11984 * 351649u) + (_11986 * 593u)) + _11987) * 4.7955217574724429141497239470482e-09f;
	                _19095 = true;
	                break;
	            }
	            case 108u:
	            {
	                uint _15971 = 30271u + (_12091 % 599u);
	                uint _16831 = _15971 / 2u;
	                uint _11980;
	                if ((_15971 & 1u) != 0u)
	                {
	                    _11980 = g_ScrambledHaltonPermutations.Load(_16831 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11980 = g_ScrambledHaltonPermutations.Load(_16831 * 4 + 0) & 65535u;
	                }
	                uint _20564 = 30271u + ((_12091 / 599u) % 599u);
	                uint _16832 = _20564 / 2u;
	                uint _11982;
	                if ((_20564 & 1u) != 0u)
	                {
	                    _11982 = g_ScrambledHaltonPermutations.Load(_16832 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11982 = g_ScrambledHaltonPermutations.Load(_16832 * 4 + 0) & 65535u;
	                }
	                uint _20565 = 30271u + ((_12091 / 358801u) % 599u);
	                uint _16833 = _20565 / 2u;
	                uint _11983;
	                if ((_20565 & 1u) != 0u)
	                {
	                    _11983 = g_ScrambledHaltonPermutations.Load(_16833 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11983 = g_ScrambledHaltonPermutations.Load(_16833 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11980 * 358801u) + (_11982 * 599u)) + _11983) * 4.6528545460944314982043579220772e-09f;
	                _19095 = true;
	                break;
	            }
	            case 109u:
	            {
	                uint _15967 = 30870u + (_12091 % 601u);
	                uint _16828 = _15967 / 2u;
	                uint _11683;
	                if ((_15967 & 1u) != 0u)
	                {
	                    _11683 = g_ScrambledHaltonPermutations.Load(_16828 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11683 = g_ScrambledHaltonPermutations.Load(_16828 * 4 + 0) & 65535u;
	                }
	                uint _20562 = 30870u + ((_12091 / 601u) % 601u);
	                uint _16829 = _20562 / 2u;
	                uint _11684;
	                if ((_20562 & 1u) != 0u)
	                {
	                    _11684 = g_ScrambledHaltonPermutations.Load(_16829 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11684 = g_ScrambledHaltonPermutations.Load(_16829 * 4 + 0) & 65535u;
	                }
	                uint _20563 = 30870u + ((_12091 / 361201u) % 601u);
	                uint _16830 = _20563 / 2u;
	                uint _11979;
	                if ((_20563 & 1u) != 0u)
	                {
	                    _11979 = g_ScrambledHaltonPermutations.Load(_16830 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11979 = g_ScrambledHaltonPermutations.Load(_16830 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11683 * 361201u) + (_11684 * 601u)) + _11979) * 4.6065578018783526204060763120651e-09f;
	                _19095 = true;
	                break;
	            }
	            case 110u:
	            {
	                uint _15963 = 31471u + (_12091 % 607u);
	                uint _16825 = _15963 / 2u;
	                uint _11681;
	                if ((_15963 & 1u) != 0u)
	                {
	                    _11681 = g_ScrambledHaltonPermutations.Load(_16825 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11681 = g_ScrambledHaltonPermutations.Load(_16825 * 4 + 0) & 65535u;
	                }
	                uint _20560 = 31471u + ((_12091 / 607u) % 607u);
	                uint _16826 = _20560 / 2u;
	                uint _11682;
	                if ((_20560 & 1u) != 0u)
	                {
	                    _11682 = g_ScrambledHaltonPermutations.Load(_16826 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11682 = g_ScrambledHaltonPermutations.Load(_16826 * 4 + 0) & 65535u;
	                }
	                uint _20561 = 31471u + ((_12091 / 368449u) % 607u);
	                uint _16827 = _20561 / 2u;
	                uint _11977;
	                if ((_20561 & 1u) != 0u)
	                {
	                    _11977 = g_ScrambledHaltonPermutations.Load(_16827 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11977 = g_ScrambledHaltonPermutations.Load(_16827 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11681 * 368449u) + (_11682 * 607u)) + _11977) * 4.4713006630558993492741137742996e-09f;
	                _19095 = true;
	                break;
	            }
	            case 111u:
	            {
	                uint _15959 = 32078u + (_12091 % 613u);
	                uint _16822 = _15959 / 2u;
	                uint _11679;
	                if ((_15959 & 1u) != 0u)
	                {
	                    _11679 = g_ScrambledHaltonPermutations.Load(_16822 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11679 = g_ScrambledHaltonPermutations.Load(_16822 * 4 + 0) & 65535u;
	                }
	                uint _20558 = 32078u + ((_12091 / 613u) % 613u);
	                uint _16823 = _20558 / 2u;
	                uint _11680;
	                if ((_20558 & 1u) != 0u)
	                {
	                    _11680 = g_ScrambledHaltonPermutations.Load(_16823 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11680 = g_ScrambledHaltonPermutations.Load(_16823 * 4 + 0) & 65535u;
	                }
	                uint _20559 = 32078u + ((_12091 / 375769u) % 613u);
	                uint _16824 = _20559 / 2u;
	                uint _11975;
	                if ((_20559 & 1u) != 0u)
	                {
	                    _11975 = g_ScrambledHaltonPermutations.Load(_16824 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11975 = g_ScrambledHaltonPermutations.Load(_16824 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11679 * 375769u) + (_11680 * 613u)) + _11975) * 4.3412873296233556175138801336288e-09f;
	                _19095 = true;
	                break;
	            }
	            case 112u:
	            {
	                uint _15955 = 32691u + (_12091 % 617u);
	                uint _16819 = _15955 / 2u;
	                uint _11677;
	                if ((_15955 & 1u) != 0u)
	                {
	                    _11677 = g_ScrambledHaltonPermutations.Load(_16819 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11677 = g_ScrambledHaltonPermutations.Load(_16819 * 4 + 0) & 65535u;
	                }
	                uint _20556 = 32691u + ((_12091 / 617u) % 617u);
	                uint _16820 = _20556 / 2u;
	                uint _11678;
	                if ((_20556 & 1u) != 0u)
	                {
	                    _11678 = g_ScrambledHaltonPermutations.Load(_16820 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11678 = g_ScrambledHaltonPermutations.Load(_16820 * 4 + 0) & 65535u;
	                }
	                uint _20557 = 32691u + ((_12091 / 380689u) % 617u);
	                uint _16821 = _20557 / 2u;
	                uint _11973;
	                if ((_20557 & 1u) != 0u)
	                {
	                    _11973 = g_ScrambledHaltonPermutations.Load(_16821 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11973 = g_ScrambledHaltonPermutations.Load(_16821 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11677 * 380689u) + (_11678 * 617u)) + _11973) * 4.2573997660610984894447028636932e-09f;
	                _19095 = true;
	                break;
	            }
	            case 113u:
	            {
	                uint _15951 = 33308u + (_12091 % 619u);
	                uint _16816 = _15951 / 2u;
	                uint _11675;
	                if ((_15951 & 1u) != 0u)
	                {
	                    _11675 = g_ScrambledHaltonPermutations.Load(_16816 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11675 = g_ScrambledHaltonPermutations.Load(_16816 * 4 + 0) & 65535u;
	                }
	                uint _20554 = 33308u + ((_12091 / 619u) % 619u);
	                uint _16817 = _20554 / 2u;
	                uint _11676;
	                if ((_20554 & 1u) != 0u)
	                {
	                    _11676 = g_ScrambledHaltonPermutations.Load(_16817 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11676 = g_ScrambledHaltonPermutations.Load(_16817 * 4 + 0) & 65535u;
	                }
	                uint _20555 = 33308u + ((_12091 / 383161u) % 619u);
	                uint _16818 = _20555 / 2u;
	                uint _11971;
	                if ((_20555 & 1u) != 0u)
	                {
	                    _11971 = g_ScrambledHaltonPermutations.Load(_16818 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11971 = g_ScrambledHaltonPermutations.Load(_16818 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11675 * 383161u) + (_11676 * 619u)) + _11971) * 4.2162660029987364396220073103905e-09f;
	                _19095 = true;
	                break;
	            }
	            case 114u:
	            {
	                uint _15947 = 33927u + (_12091 % 631u);
	                uint _16813 = _15947 / 2u;
	                uint _11673;
	                if ((_15947 & 1u) != 0u)
	                {
	                    _11673 = g_ScrambledHaltonPermutations.Load(_16813 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11673 = g_ScrambledHaltonPermutations.Load(_16813 * 4 + 0) & 65535u;
	                }
	                uint _20552 = 33927u + ((_12091 / 631u) % 631u);
	                uint _16814 = _20552 / 2u;
	                uint _11674;
	                if ((_20552 & 1u) != 0u)
	                {
	                    _11674 = g_ScrambledHaltonPermutations.Load(_16814 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11674 = g_ScrambledHaltonPermutations.Load(_16814 * 4 + 0) & 65535u;
	                }
	                uint _20553 = 33927u + ((_12091 / 398161u) % 631u);
	                uint _16815 = _20553 / 2u;
	                uint _11969;
	                if ((_20553 & 1u) != 0u)
	                {
	                    _11969 = g_ScrambledHaltonPermutations.Load(_16815 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11969 = g_ScrambledHaltonPermutations.Load(_16815 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11673 * 398161u) + (_11674 * 631u)) + _11969) * 3.9802641182973275135736912488937e-09f;
	                _19095 = true;
	                break;
	            }
	            case 115u:
	            {
	                uint _15943 = 34558u + (_12091 % 641u);
	                uint _16810 = _15943 / 2u;
	                uint _11671;
	                if ((_15943 & 1u) != 0u)
	                {
	                    _11671 = g_ScrambledHaltonPermutations.Load(_16810 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11671 = g_ScrambledHaltonPermutations.Load(_16810 * 4 + 0) & 65535u;
	                }
	                uint _20550 = 34558u + ((_12091 / 641u) % 641u);
	                uint _16811 = _20550 / 2u;
	                uint _11672;
	                if ((_20550 & 1u) != 0u)
	                {
	                    _11672 = g_ScrambledHaltonPermutations.Load(_16811 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11672 = g_ScrambledHaltonPermutations.Load(_16811 * 4 + 0) & 65535u;
	                }
	                uint _20551 = 34558u + ((_12091 / 410881u) % 641u);
	                uint _16812 = _20551 / 2u;
	                uint _11967;
	                if ((_20551 & 1u) != 0u)
	                {
	                    _11967 = g_ScrambledHaltonPermutations.Load(_16812 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11967 = g_ScrambledHaltonPermutations.Load(_16812 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11671 * 410881u) + (_11672 * 641u)) + _11967) * 3.7968712618408062553498893976212e-09f;
	                _19095 = true;
	                break;
	            }
	            case 116u:
	            {
	                uint _15939 = 35199u + (_12091 % 643u);
	                uint _16807 = _15939 / 2u;
	                uint _11669;
	                if ((_15939 & 1u) != 0u)
	                {
	                    _11669 = g_ScrambledHaltonPermutations.Load(_16807 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11669 = g_ScrambledHaltonPermutations.Load(_16807 * 4 + 0) & 65535u;
	                }
	                uint _20548 = 35199u + ((_12091 / 643u) % 643u);
	                uint _16808 = _20548 / 2u;
	                uint _11670;
	                if ((_20548 & 1u) != 0u)
	                {
	                    _11670 = g_ScrambledHaltonPermutations.Load(_16808 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11670 = g_ScrambledHaltonPermutations.Load(_16808 * 4 + 0) & 65535u;
	                }
	                uint _20549 = 35199u + ((_12091 / 413449u) % 643u);
	                uint _16809 = _20549 / 2u;
	                uint _11965;
	                if ((_20549 & 1u) != 0u)
	                {
	                    _11965 = g_ScrambledHaltonPermutations.Load(_16809 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11965 = g_ScrambledHaltonPermutations.Load(_16809 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11669 * 413449u) + (_11670 * 643u)) + _11965) * 3.7615515147138012252980843186378e-09f;
	                _19095 = true;
	                break;
	            }
	            case 117u:
	            {
	                uint _15935 = 35842u + (_12091 % 647u);
	                uint _16804 = _15935 / 2u;
	                uint _11667;
	                if ((_15935 & 1u) != 0u)
	                {
	                    _11667 = g_ScrambledHaltonPermutations.Load(_16804 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11667 = g_ScrambledHaltonPermutations.Load(_16804 * 4 + 0) & 65535u;
	                }
	                uint _20546 = 35842u + ((_12091 / 647u) % 647u);
	                uint _16805 = _20546 / 2u;
	                uint _11668;
	                if ((_20546 & 1u) != 0u)
	                {
	                    _11668 = g_ScrambledHaltonPermutations.Load(_16805 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11668 = g_ScrambledHaltonPermutations.Load(_16805 * 4 + 0) & 65535u;
	                }
	                uint _20547 = 35842u + ((_12091 / 418609u) % 647u);
	                uint _16806 = _20547 / 2u;
	                uint _11963;
	                if ((_20547 & 1u) != 0u)
	                {
	                    _11963 = g_ScrambledHaltonPermutations.Load(_16806 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11963 = g_ScrambledHaltonPermutations.Load(_16806 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11667 * 418609u) + (_11668 * 647u)) + _11963) * 3.6922158663799109490355476737022e-09f;
	                _19095 = true;
	                break;
	            }
	            case 118u:
	            {
	                uint _15931 = 36489u + (_12091 % 653u);
	                uint _16801 = _15931 / 2u;
	                uint _11665;
	                if ((_15931 & 1u) != 0u)
	                {
	                    _11665 = g_ScrambledHaltonPermutations.Load(_16801 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11665 = g_ScrambledHaltonPermutations.Load(_16801 * 4 + 0) & 65535u;
	                }
	                uint _20544 = 36489u + ((_12091 / 653u) % 653u);
	                uint _16802 = _20544 / 2u;
	                uint _11666;
	                if ((_20544 & 1u) != 0u)
	                {
	                    _11666 = g_ScrambledHaltonPermutations.Load(_16802 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11666 = g_ScrambledHaltonPermutations.Load(_16802 * 4 + 0) & 65535u;
	                }
	                uint _20545 = 36489u + ((_12091 / 426409u) % 653u);
	                uint _16803 = _20545 / 2u;
	                uint _11961;
	                if ((_20545 & 1u) != 0u)
	                {
	                    _11961 = g_ScrambledHaltonPermutations.Load(_16803 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11961 = g_ScrambledHaltonPermutations.Load(_16803 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11665 * 426409u) + (_11666 * 653u)) + _11961) * 3.5913718665625538051244802772999e-09f;
	                _19095 = true;
	                break;
	            }
	            case 119u:
	            {
	                uint _15927 = 37142u + (_12091 % 659u);
	                uint _16798 = _15927 / 2u;
	                uint _11663;
	                if ((_15927 & 1u) != 0u)
	                {
	                    _11663 = g_ScrambledHaltonPermutations.Load(_16798 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11663 = g_ScrambledHaltonPermutations.Load(_16798 * 4 + 0) & 65535u;
	                }
	                uint _20542 = 37142u + ((_12091 / 659u) % 659u);
	                uint _16799 = _20542 / 2u;
	                uint _11664;
	                if ((_20542 & 1u) != 0u)
	                {
	                    _11664 = g_ScrambledHaltonPermutations.Load(_16799 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11664 = g_ScrambledHaltonPermutations.Load(_16799 * 4 + 0) & 65535u;
	                }
	                uint _20543 = 37142u + ((_12091 / 434281u) % 659u);
	                uint _16800 = _20543 / 2u;
	                uint _11959;
	                if ((_20543 & 1u) != 0u)
	                {
	                    _11959 = g_ScrambledHaltonPermutations.Load(_16800 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11959 = g_ScrambledHaltonPermutations.Load(_16800 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11663 * 434281u) + (_11664 * 659u)) + _11959) * 3.4941673998645228493842296302319e-09f;
	                _19095 = true;
	                break;
	            }
	            case 120u:
	            {
	                uint _15923 = 37801u + (_12091 % 661u);
	                uint _16795 = _15923 / 2u;
	                uint _11661;
	                if ((_15923 & 1u) != 0u)
	                {
	                    _11661 = g_ScrambledHaltonPermutations.Load(_16795 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11661 = g_ScrambledHaltonPermutations.Load(_16795 * 4 + 0) & 65535u;
	                }
	                uint _20540 = 37801u + ((_12091 / 661u) % 661u);
	                uint _16796 = _20540 / 2u;
	                uint _11662;
	                if ((_20540 & 1u) != 0u)
	                {
	                    _11662 = g_ScrambledHaltonPermutations.Load(_16796 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11662 = g_ScrambledHaltonPermutations.Load(_16796 * 4 + 0) & 65535u;
	                }
	                uint _20541 = 37801u + ((_12091 / 436921u) % 661u);
	                uint _16797 = _20541 / 2u;
	                uint _11957;
	                if ((_20541 & 1u) != 0u)
	                {
	                    _11957 = g_ScrambledHaltonPermutations.Load(_16797 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11957 = g_ScrambledHaltonPermutations.Load(_16797 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11661 * 436921u) + (_11662 * 661u)) + _11957) * 3.4625462497217540658311918377876e-09f;
	                _19095 = true;
	                break;
	            }
	            case 121u:
	            {
	                uint _15919 = 38462u + (_12091 % 673u);
	                uint _16792 = _15919 / 2u;
	                uint _11659;
	                if ((_15919 & 1u) != 0u)
	                {
	                    _11659 = g_ScrambledHaltonPermutations.Load(_16792 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11659 = g_ScrambledHaltonPermutations.Load(_16792 * 4 + 0) & 65535u;
	                }
	                uint _20538 = 38462u + ((_12091 / 673u) % 673u);
	                uint _16793 = _20538 / 2u;
	                uint _11660;
	                if ((_20538 & 1u) != 0u)
	                {
	                    _11660 = g_ScrambledHaltonPermutations.Load(_16793 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11660 = g_ScrambledHaltonPermutations.Load(_16793 * 4 + 0) & 65535u;
	                }
	                uint _20539 = 38462u + ((_12091 / 452929u) % 673u);
	                uint _16794 = _20539 / 2u;
	                uint _11955;
	                if ((_20539 & 1u) != 0u)
	                {
	                    _11955 = g_ScrambledHaltonPermutations.Load(_16794 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11955 = g_ScrambledHaltonPermutations.Load(_16794 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11659 * 452929u) + (_11660 * 673u)) + _11955) * 3.2806111160965656381449662148952e-09f;
	                _19095 = true;
	                break;
	            }
	            case 122u:
	            {
	                uint _15915 = 39135u + (_12091 % 677u);
	                uint _16789 = _15915 / 2u;
	                uint _11657;
	                if ((_15915 & 1u) != 0u)
	                {
	                    _11657 = g_ScrambledHaltonPermutations.Load(_16789 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11657 = g_ScrambledHaltonPermutations.Load(_16789 * 4 + 0) & 65535u;
	                }
	                uint _20536 = 39135u + ((_12091 / 677u) % 677u);
	                uint _16790 = _20536 / 2u;
	                uint _11658;
	                if ((_20536 & 1u) != 0u)
	                {
	                    _11658 = g_ScrambledHaltonPermutations.Load(_16790 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11658 = g_ScrambledHaltonPermutations.Load(_16790 * 4 + 0) & 65535u;
	                }
	                uint _20537 = 39135u + ((_12091 / 458329u) % 677u);
	                uint _16791 = _20537 / 2u;
	                uint _11953;
	                if ((_20537 & 1u) != 0u)
	                {
	                    _11953 = g_ScrambledHaltonPermutations.Load(_16791 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11953 = g_ScrambledHaltonPermutations.Load(_16791 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11657 * 458329u) + (_11658 * 677u)) + _11953) * 3.2228042456949879124294966459274e-09f;
	                _19095 = true;
	                break;
	            }
	            case 123u:
	            {
	                uint _15911 = 39812u + (_12091 % 683u);
	                uint _16786 = _15911 / 2u;
	                uint _11655;
	                if ((_15911 & 1u) != 0u)
	                {
	                    _11655 = g_ScrambledHaltonPermutations.Load(_16786 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11655 = g_ScrambledHaltonPermutations.Load(_16786 * 4 + 0) & 65535u;
	                }
	                uint _20534 = 39812u + ((_12091 / 683u) % 683u);
	                uint _16787 = _20534 / 2u;
	                uint _11656;
	                if ((_20534 & 1u) != 0u)
	                {
	                    _11656 = g_ScrambledHaltonPermutations.Load(_16787 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11656 = g_ScrambledHaltonPermutations.Load(_16787 * 4 + 0) & 65535u;
	                }
	                uint _20535 = 39812u + ((_12091 / 466489u) % 683u);
	                uint _16788 = _20535 / 2u;
	                uint _11951;
	                if ((_20535 & 1u) != 0u)
	                {
	                    _11951 = g_ScrambledHaltonPermutations.Load(_16788 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11951 = g_ScrambledHaltonPermutations.Load(_16788 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11655 * 466489u) + (_11656 * 683u)) + _11951) * 3.1386133692024031915934756398201e-09f;
	                _19095 = true;
	                break;
	            }
	            case 124u:
	            {
	                uint _15907 = 40495u + (_12091 % 691u);
	                uint _16783 = _15907 / 2u;
	                uint _11653;
	                if ((_15907 & 1u) != 0u)
	                {
	                    _11653 = g_ScrambledHaltonPermutations.Load(_16783 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11653 = g_ScrambledHaltonPermutations.Load(_16783 * 4 + 0) & 65535u;
	                }
	                uint _20532 = 40495u + ((_12091 / 691u) % 691u);
	                uint _16784 = _20532 / 2u;
	                uint _11654;
	                if ((_20532 & 1u) != 0u)
	                {
	                    _11654 = g_ScrambledHaltonPermutations.Load(_16784 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11654 = g_ScrambledHaltonPermutations.Load(_16784 * 4 + 0) & 65535u;
	                }
	                uint _20533 = 40495u + ((_12091 / 477481u) % 691u);
	                uint _16785 = _20533 / 2u;
	                uint _11949;
	                if ((_20533 & 1u) != 0u)
	                {
	                    _11949 = g_ScrambledHaltonPermutations.Load(_16785 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11949 = g_ScrambledHaltonPermutations.Load(_16785 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11653 * 477481u) + (_11654 * 691u)) + _11949) * 3.0308595633243839984061196446419e-09f;
	                _19095 = true;
	                break;
	            }
	            case 125u:
	            {
	                uint _15903 = 41186u + (_12091 % 701u);
	                uint _16780 = _15903 / 2u;
	                uint _11651;
	                if ((_15903 & 1u) != 0u)
	                {
	                    _11651 = g_ScrambledHaltonPermutations.Load(_16780 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11651 = g_ScrambledHaltonPermutations.Load(_16780 * 4 + 0) & 65535u;
	                }
	                uint _20530 = 41186u + ((_12091 / 701u) % 701u);
	                uint _16781 = _20530 / 2u;
	                uint _11652;
	                if ((_20530 & 1u) != 0u)
	                {
	                    _11652 = g_ScrambledHaltonPermutations.Load(_16781 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11652 = g_ScrambledHaltonPermutations.Load(_16781 * 4 + 0) & 65535u;
	                }
	                uint _20531 = 41186u + ((_12091 / 491401u) % 701u);
	                uint _16782 = _20531 / 2u;
	                uint _11947;
	                if ((_20531 & 1u) != 0u)
	                {
	                    _11947 = g_ScrambledHaltonPermutations.Load(_16782 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11947 = g_ScrambledHaltonPermutations.Load(_16782 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11651 * 491401u) + (_11652 * 701u)) + _11947) * 2.9029925130430456192698329687119e-09f;
	                _19095 = true;
	                break;
	            }
	            case 126u:
	            {
	                uint _15899 = 41887u + (_12091 % 709u);
	                uint _16777 = _15899 / 2u;
	                uint _11649;
	                if ((_15899 & 1u) != 0u)
	                {
	                    _11649 = g_ScrambledHaltonPermutations.Load(_16777 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11649 = g_ScrambledHaltonPermutations.Load(_16777 * 4 + 0) & 65535u;
	                }
	                uint _20528 = 41887u + ((_12091 / 709u) % 709u);
	                uint _16778 = _20528 / 2u;
	                uint _11650;
	                if ((_20528 & 1u) != 0u)
	                {
	                    _11650 = g_ScrambledHaltonPermutations.Load(_16778 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11650 = g_ScrambledHaltonPermutations.Load(_16778 * 4 + 0) & 65535u;
	                }
	                uint _20529 = 41887u + ((_12091 / 502681u) % 709u);
	                uint _16779 = _20529 / 2u;
	                uint _11945;
	                if ((_20529 & 1u) != 0u)
	                {
	                    _11945 = g_ScrambledHaltonPermutations.Load(_16779 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11945 = g_ScrambledHaltonPermutations.Load(_16779 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11649 * 502681u) + (_11650 * 709u)) + _11945) * 2.8058293466415307193528860807419e-09f;
	                _19095 = true;
	                break;
	            }
	            case 127u:
	            {
	                uint _15895 = 42596u + (_12091 % 719u);
	                uint _16774 = _15895 / 2u;
	                uint _11647;
	                if ((_15895 & 1u) != 0u)
	                {
	                    _11647 = g_ScrambledHaltonPermutations.Load(_16774 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11647 = g_ScrambledHaltonPermutations.Load(_16774 * 4 + 0) & 65535u;
	                }
	                uint _20526 = 42596u + ((_12091 / 719u) % 719u);
	                uint _16775 = _20526 / 2u;
	                uint _11648;
	                if ((_20526 & 1u) != 0u)
	                {
	                    _11648 = g_ScrambledHaltonPermutations.Load(_16775 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11648 = g_ScrambledHaltonPermutations.Load(_16775 * 4 + 0) & 65535u;
	                }
	                uint _20527 = 42596u + ((_12091 / 516961u) % 719u);
	                uint _16776 = _20527 / 2u;
	                uint _11943;
	                if ((_20527 & 1u) != 0u)
	                {
	                    _11943 = g_ScrambledHaltonPermutations.Load(_16776 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11943 = g_ScrambledHaltonPermutations.Load(_16776 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11647 * 516961u) + (_11648 * 719u)) + _11943) * 2.6903779204445754658081568777561e-09f;
	                _19095 = true;
	                break;
	            }
	            case 128u:
	            {
	                uint _15891 = 43315u + (_12091 % 727u);
	                uint _16771 = _15891 / 2u;
	                uint _11645;
	                if ((_15891 & 1u) != 0u)
	                {
	                    _11645 = g_ScrambledHaltonPermutations.Load(_16771 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11645 = g_ScrambledHaltonPermutations.Load(_16771 * 4 + 0) & 65535u;
	                }
	                uint _20524 = 43315u + ((_12091 / 727u) % 727u);
	                uint _16772 = _20524 / 2u;
	                uint _11646;
	                if ((_20524 & 1u) != 0u)
	                {
	                    _11646 = g_ScrambledHaltonPermutations.Load(_16772 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11646 = g_ScrambledHaltonPermutations.Load(_16772 * 4 + 0) & 65535u;
	                }
	                uint _20525 = 43315u + ((_12091 / 528529u) % 727u);
	                uint _16773 = _20525 / 2u;
	                uint _11941;
	                if ((_20525 & 1u) != 0u)
	                {
	                    _11941 = g_ScrambledHaltonPermutations.Load(_16773 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11941 = g_ScrambledHaltonPermutations.Load(_16773 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11645 * 528529u) + (_11646 * 727u)) + _11941) * 2.6025359645132084551732987165451e-09f;
	                _19095 = true;
	                break;
	            }
	            case 129u:
	            {
	                uint _15887 = 44042u + (_12091 % 733u);
	                uint _16768 = _15887 / 2u;
	                uint _11643;
	                if ((_15887 & 1u) != 0u)
	                {
	                    _11643 = g_ScrambledHaltonPermutations.Load(_16768 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11643 = g_ScrambledHaltonPermutations.Load(_16768 * 4 + 0) & 65535u;
	                }
	                uint _20522 = 44042u + ((_12091 / 733u) % 733u);
	                uint _16769 = _20522 / 2u;
	                uint _11644;
	                if ((_20522 & 1u) != 0u)
	                {
	                    _11644 = g_ScrambledHaltonPermutations.Load(_16769 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11644 = g_ScrambledHaltonPermutations.Load(_16769 * 4 + 0) & 65535u;
	                }
	                uint _20523 = 44042u + ((_12091 / 537289u) % 733u);
	                uint _16770 = _20523 / 2u;
	                uint _11939;
	                if ((_20523 & 1u) != 0u)
	                {
	                    _11939 = g_ScrambledHaltonPermutations.Load(_16770 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11939 = g_ScrambledHaltonPermutations.Load(_16770 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11643 * 537289u) + (_11644 * 733u)) + _11939) * 2.5391480029668400675291195511818e-09f;
	                _19095 = true;
	                break;
	            }
	            case 130u:
	            {
	                uint _15883 = 44775u + (_12091 % 739u);
	                uint _16765 = _15883 / 2u;
	                uint _11641;
	                if ((_15883 & 1u) != 0u)
	                {
	                    _11641 = g_ScrambledHaltonPermutations.Load(_16765 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11641 = g_ScrambledHaltonPermutations.Load(_16765 * 4 + 0) & 65535u;
	                }
	                uint _20520 = 44775u + ((_12091 / 739u) % 739u);
	                uint _16766 = _20520 / 2u;
	                uint _11642;
	                if ((_20520 & 1u) != 0u)
	                {
	                    _11642 = g_ScrambledHaltonPermutations.Load(_16766 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11642 = g_ScrambledHaltonPermutations.Load(_16766 * 4 + 0) & 65535u;
	                }
	                uint _20521 = 44775u + ((_12091 / 546121u) % 739u);
	                uint _16767 = _20521 / 2u;
	                uint _11937;
	                if ((_20521 & 1u) != 0u)
	                {
	                    _11937 = g_ScrambledHaltonPermutations.Load(_16767 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11937 = g_ScrambledHaltonPermutations.Load(_16767 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11641 * 546121u) + (_11642 * 739u)) + _11937) * 2.4778021856519671928253956139088e-09f;
	                _19095 = true;
	                break;
	            }
	            case 131u:
	            {
	                uint _15879 = 45514u + (_12091 % 743u);
	                uint _16762 = _15879 / 2u;
	                uint _11639;
	                if ((_15879 & 1u) != 0u)
	                {
	                    _11639 = g_ScrambledHaltonPermutations.Load(_16762 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11639 = g_ScrambledHaltonPermutations.Load(_16762 * 4 + 0) & 65535u;
	                }
	                uint _20518 = 45514u + ((_12091 / 743u) % 743u);
	                uint _16763 = _20518 / 2u;
	                uint _11640;
	                if ((_20518 & 1u) != 0u)
	                {
	                    _11640 = g_ScrambledHaltonPermutations.Load(_16763 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11640 = g_ScrambledHaltonPermutations.Load(_16763 * 4 + 0) & 65535u;
	                }
	                uint _20519 = 45514u + ((_12091 / 552049u) % 743u);
	                uint _16764 = _20519 / 2u;
	                uint _11935;
	                if ((_20519 & 1u) != 0u)
	                {
	                    _11935 = g_ScrambledHaltonPermutations.Load(_16764 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11935 = g_ScrambledHaltonPermutations.Load(_16764 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11639 * 552049u) + (_11640 * 743u)) + _11935) * 2.437998913862315930600743740797e-09f;
	                _19095 = true;
	                break;
	            }
	            case 132u:
	            {
	                uint _15875 = 46257u + (_12091 % 751u);
	                uint _16759 = _15875 / 2u;
	                uint _11637;
	                if ((_15875 & 1u) != 0u)
	                {
	                    _11637 = g_ScrambledHaltonPermutations.Load(_16759 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11637 = g_ScrambledHaltonPermutations.Load(_16759 * 4 + 0) & 65535u;
	                }
	                uint _20516 = 46257u + ((_12091 / 751u) % 751u);
	                uint _16760 = _20516 / 2u;
	                uint _11638;
	                if ((_20516 & 1u) != 0u)
	                {
	                    _11638 = g_ScrambledHaltonPermutations.Load(_16760 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11638 = g_ScrambledHaltonPermutations.Load(_16760 * 4 + 0) & 65535u;
	                }
	                uint _20517 = 46257u + ((_12091 / 564001u) % 751u);
	                uint _16761 = _20517 / 2u;
	                uint _11933;
	                if ((_20517 & 1u) != 0u)
	                {
	                    _11933 = g_ScrambledHaltonPermutations.Load(_16761 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11933 = g_ScrambledHaltonPermutations.Load(_16761 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11637 * 564001u) + (_11638 * 751u)) + _11933) * 2.3609139088165420616860501468182e-09f;
	                _19095 = true;
	                break;
	            }
	            case 133u:
	            {
	                uint _15871 = 47008u + (_12091 % 757u);
	                uint _16756 = _15871 / 2u;
	                uint _11635;
	                if ((_15871 & 1u) != 0u)
	                {
	                    _11635 = g_ScrambledHaltonPermutations.Load(_16756 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11635 = g_ScrambledHaltonPermutations.Load(_16756 * 4 + 0) & 65535u;
	                }
	                uint _20514 = 47008u + ((_12091 / 757u) % 757u);
	                uint _16757 = _20514 / 2u;
	                uint _11636;
	                if ((_20514 & 1u) != 0u)
	                {
	                    _11636 = g_ScrambledHaltonPermutations.Load(_16757 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11636 = g_ScrambledHaltonPermutations.Load(_16757 * 4 + 0) & 65535u;
	                }
	                uint _20515 = 47008u + ((_12091 / 573049u) % 757u);
	                uint _16758 = _20515 / 2u;
	                uint _11931;
	                if ((_20515 & 1u) != 0u)
	                {
	                    _11931 = g_ScrambledHaltonPermutations.Load(_16758 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11931 = g_ScrambledHaltonPermutations.Load(_16758 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11635 * 573049u) + (_11636 * 757u)) + _11931) * 2.3052197928308260088670067489147e-09f;
	                _19095 = true;
	                break;
	            }
	            case 134u:
	            {
	                uint _15867 = 47765u + (_12091 % 761u);
	                uint _16753 = _15867 / 2u;
	                uint _11633;
	                if ((_15867 & 1u) != 0u)
	                {
	                    _11633 = g_ScrambledHaltonPermutations.Load(_16753 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11633 = g_ScrambledHaltonPermutations.Load(_16753 * 4 + 0) & 65535u;
	                }
	                uint _20512 = 47765u + ((_12091 / 761u) % 761u);
	                uint _16754 = _20512 / 2u;
	                uint _11634;
	                if ((_20512 & 1u) != 0u)
	                {
	                    _11634 = g_ScrambledHaltonPermutations.Load(_16754 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11634 = g_ScrambledHaltonPermutations.Load(_16754 * 4 + 0) & 65535u;
	                }
	                uint _20513 = 47765u + ((_12091 / 579121u) % 761u);
	                uint _16755 = _20513 / 2u;
	                uint _11929;
	                if ((_20513 & 1u) != 0u)
	                {
	                    _11929 = g_ScrambledHaltonPermutations.Load(_16755 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11929 = g_ScrambledHaltonPermutations.Load(_16755 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11633 * 579121u) + (_11634 * 761u)) + _11929) * 2.2690600509633895853767171502113e-09f;
	                _19095 = true;
	                break;
	            }
	            case 135u:
	            {
	                uint _15863 = 48526u + (_12091 % 769u);
	                uint _16750 = _15863 / 2u;
	                uint _11631;
	                if ((_15863 & 1u) != 0u)
	                {
	                    _11631 = g_ScrambledHaltonPermutations.Load(_16750 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11631 = g_ScrambledHaltonPermutations.Load(_16750 * 4 + 0) & 65535u;
	                }
	                uint _20510 = 48526u + ((_12091 / 769u) % 769u);
	                uint _16751 = _20510 / 2u;
	                uint _11632;
	                if ((_20510 & 1u) != 0u)
	                {
	                    _11632 = g_ScrambledHaltonPermutations.Load(_16751 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11632 = g_ScrambledHaltonPermutations.Load(_16751 * 4 + 0) & 65535u;
	                }
	                uint _20511 = 48526u + ((_12091 / 591361u) % 769u);
	                uint _16752 = _20511 / 2u;
	                uint _11927;
	                if ((_20511 & 1u) != 0u)
	                {
	                    _11927 = g_ScrambledHaltonPermutations.Load(_16752 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11927 = g_ScrambledHaltonPermutations.Load(_16752 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11631 * 591361u) + (_11632 * 769u)) + _11927) * 2.1989783327569512039190158247948e-09f;
	                _19095 = true;
	                break;
	            }
	            case 136u:
	            {
	                uint _15859 = 49295u + (_12091 % 773u);
	                uint _16747 = _15859 / 2u;
	                uint _11629;
	                if ((_15859 & 1u) != 0u)
	                {
	                    _11629 = g_ScrambledHaltonPermutations.Load(_16747 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11629 = g_ScrambledHaltonPermutations.Load(_16747 * 4 + 0) & 65535u;
	                }
	                uint _20508 = 49295u + ((_12091 / 773u) % 773u);
	                uint _16748 = _20508 / 2u;
	                uint _11630;
	                if ((_20508 & 1u) != 0u)
	                {
	                    _11630 = g_ScrambledHaltonPermutations.Load(_16748 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11630 = g_ScrambledHaltonPermutations.Load(_16748 * 4 + 0) & 65535u;
	                }
	                uint _20509 = 49295u + ((_12091 / 597529u) % 773u);
	                uint _16749 = _20509 / 2u;
	                uint _11925;
	                if ((_20509 & 1u) != 0u)
	                {
	                    _11925 = g_ScrambledHaltonPermutations.Load(_16749 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11925 = g_ScrambledHaltonPermutations.Load(_16749 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11629 * 597529u) + (_11630 * 773u)) + _11925) * 2.1650177206566922905039973556995e-09f;
	                _19095 = true;
	                break;
	            }
	            case 137u:
	            {
	                uint _15855 = 50068u + (_12091 % 787u);
	                uint _16744 = _15855 / 2u;
	                uint _11627;
	                if ((_15855 & 1u) != 0u)
	                {
	                    _11627 = g_ScrambledHaltonPermutations.Load(_16744 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11627 = g_ScrambledHaltonPermutations.Load(_16744 * 4 + 0) & 65535u;
	                }
	                uint _20506 = 50068u + ((_12091 / 787u) % 787u);
	                uint _16745 = _20506 / 2u;
	                uint _11628;
	                if ((_20506 & 1u) != 0u)
	                {
	                    _11628 = g_ScrambledHaltonPermutations.Load(_16745 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11628 = g_ScrambledHaltonPermutations.Load(_16745 * 4 + 0) & 65535u;
	                }
	                uint _20507 = 50068u + ((_12091 / 619369u) % 787u);
	                uint _16746 = _20507 / 2u;
	                uint _11923;
	                if ((_20507 & 1u) != 0u)
	                {
	                    _11923 = g_ScrambledHaltonPermutations.Load(_16746 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11923 = g_ScrambledHaltonPermutations.Load(_16746 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11627 * 619369u) + (_11628 * 787u)) + _11923) * 2.0515200649384723874391056597233e-09f;
	                _19095 = true;
	                break;
	            }
	            case 138u:
	            {
	                uint _15851 = 50855u + (_12091 % 797u);
	                uint _16741 = _15851 / 2u;
	                uint _11625;
	                if ((_15851 & 1u) != 0u)
	                {
	                    _11625 = g_ScrambledHaltonPermutations.Load(_16741 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11625 = g_ScrambledHaltonPermutations.Load(_16741 * 4 + 0) & 65535u;
	                }
	                uint _20504 = 50855u + ((_12091 / 797u) % 797u);
	                uint _16742 = _20504 / 2u;
	                uint _11626;
	                if ((_20504 & 1u) != 0u)
	                {
	                    _11626 = g_ScrambledHaltonPermutations.Load(_16742 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11626 = g_ScrambledHaltonPermutations.Load(_16742 * 4 + 0) & 65535u;
	                }
	                uint _20505 = 50855u + ((_12091 / 635209u) % 797u);
	                uint _16743 = _20505 / 2u;
	                uint _11920;
	                if ((_20505 & 1u) != 0u)
	                {
	                    _11920 = g_ScrambledHaltonPermutations.Load(_16743 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11920 = g_ScrambledHaltonPermutations.Load(_16743 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11625 * 635209u) + (_11626 * 797u)) + _11920) * 1.9752632862690688853035680949688e-09f;
	                _19095 = true;
	                break;
	            }
	            case 139u:
	            {
	                uint _15847 = 51652u + (_12091 % 809u);
	                uint _16738 = _15847 / 2u;
	                uint _11623;
	                if ((_15847 & 1u) != 0u)
	                {
	                    _11623 = g_ScrambledHaltonPermutations.Load(_16738 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11623 = g_ScrambledHaltonPermutations.Load(_16738 * 4 + 0) & 65535u;
	                }
	                uint _20502 = 51652u + ((_12091 / 809u) % 809u);
	                uint _16739 = _20502 / 2u;
	                uint _11624;
	                if ((_20502 & 1u) != 0u)
	                {
	                    _11624 = g_ScrambledHaltonPermutations.Load(_16739 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11624 = g_ScrambledHaltonPermutations.Load(_16739 * 4 + 0) & 65535u;
	                }
	                uint _20503 = 51652u + ((_12091 / 654481u) % 809u);
	                uint _16740 = _20503 / 2u;
	                uint _11918;
	                if ((_20503 & 1u) != 0u)
	                {
	                    _11918 = g_ScrambledHaltonPermutations.Load(_16740 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11918 = g_ScrambledHaltonPermutations.Load(_16740 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11623 * 654481u) + (_11624 * 809u)) + _11918) * 1.8886625596792327996809035539627e-09f;
	                _19095 = true;
	                break;
	            }
	            case 140u:
	            {
	                uint _15843 = 52461u + (_12091 % 811u);
	                uint _16735 = _15843 / 2u;
	                uint _11621;
	                if ((_15843 & 1u) != 0u)
	                {
	                    _11621 = g_ScrambledHaltonPermutations.Load(_16735 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11621 = g_ScrambledHaltonPermutations.Load(_16735 * 4 + 0) & 65535u;
	                }
	                uint _20500 = 52461u + ((_12091 / 811u) % 811u);
	                uint _16736 = _20500 / 2u;
	                uint _11622;
	                if ((_20500 & 1u) != 0u)
	                {
	                    _11622 = g_ScrambledHaltonPermutations.Load(_16736 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11622 = g_ScrambledHaltonPermutations.Load(_16736 * 4 + 0) & 65535u;
	                }
	                uint _20501 = 52461u + ((_12091 / 657721u) % 811u);
	                uint _16737 = _20501 / 2u;
	                uint _11916;
	                if ((_20501 & 1u) != 0u)
	                {
	                    _11916 = g_ScrambledHaltonPermutations.Load(_16737 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11916 = g_ScrambledHaltonPermutations.Load(_16737 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11621 * 657721u) + (_11622 * 811u)) + _11916) * 1.8747241536942738093785010278225e-09f;
	                _19095 = true;
	                break;
	            }
	            case 141u:
	            {
	                uint _15839 = 53272u + (_12091 % 821u);
	                uint _16732 = _15839 / 2u;
	                uint _11619;
	                if ((_15839 & 1u) != 0u)
	                {
	                    _11619 = g_ScrambledHaltonPermutations.Load(_16732 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11619 = g_ScrambledHaltonPermutations.Load(_16732 * 4 + 0) & 65535u;
	                }
	                uint _20498 = 53272u + ((_12091 / 821u) % 821u);
	                uint _16733 = _20498 / 2u;
	                uint _11620;
	                if ((_20498 & 1u) != 0u)
	                {
	                    _11620 = g_ScrambledHaltonPermutations.Load(_16733 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11620 = g_ScrambledHaltonPermutations.Load(_16733 * 4 + 0) & 65535u;
	                }
	                uint _20499 = 53272u + ((_12091 / 674041u) % 821u);
	                uint _16734 = _20499 / 2u;
	                uint _11914;
	                if ((_20499 & 1u) != 0u)
	                {
	                    _11914 = g_ScrambledHaltonPermutations.Load(_16734 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11914 = g_ScrambledHaltonPermutations.Load(_16734 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11619 * 674041u) + (_11620 * 821u)) + _11914) * 1.8070512863843646300665568560362e-09f;
	                _19095 = true;
	                break;
	            }
	            case 142u:
	            {
	                uint _15835 = 54093u + (_12091 % 823u);
	                uint _16729 = _15835 / 2u;
	                uint _11618;
	                if ((_15835 & 1u) != 0u)
	                {
	                    _11618 = g_ScrambledHaltonPermutations.Load(_16729 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11618 = g_ScrambledHaltonPermutations.Load(_16729 * 4 + 0) & 65535u;
	                }
	                uint _20496 = 54093u + ((_12091 / 823u) % 823u);
	                uint _16730 = _20496 / 2u;
	                uint _11504;
	                if ((_20496 & 1u) != 0u)
	                {
	                    _11504 = g_ScrambledHaltonPermutations.Load(_16730 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11504 = g_ScrambledHaltonPermutations.Load(_16730 * 4 + 0) & 65535u;
	                }
	                uint _20497 = 54093u + ((_12091 / 677329u) % 823u);
	                uint _16731 = _20497 / 2u;
	                uint _11912;
	                if ((_20497 & 1u) != 0u)
	                {
	                    _11912 = g_ScrambledHaltonPermutations.Load(_16731 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11912 = g_ScrambledHaltonPermutations.Load(_16731 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11618 * 677329u) + (_11504 * 823u)) + _11912) * 1.7939090213303643395192921161652e-09f;
	                _19095 = true;
	                break;
	            }
	            case 143u:
	            {
	                uint _15831 = 54916u + (_12091 % 827u);
	                uint _16726 = _15831 / 2u;
	                uint _11617;
	                if ((_15831 & 1u) != 0u)
	                {
	                    _11617 = g_ScrambledHaltonPermutations.Load(_16726 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11617 = g_ScrambledHaltonPermutations.Load(_16726 * 4 + 0) & 65535u;
	                }
	                uint _20494 = 54916u + ((_12091 / 827u) % 827u);
	                uint _16727 = _20494 / 2u;
	                uint _11503;
	                if ((_20494 & 1u) != 0u)
	                {
	                    _11503 = g_ScrambledHaltonPermutations.Load(_16727 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11503 = g_ScrambledHaltonPermutations.Load(_16727 * 4 + 0) & 65535u;
	                }
	                uint _20495 = 54916u + ((_12091 / 683929u) % 827u);
	                uint _16728 = _20495 / 2u;
	                uint _11910;
	                if ((_20495 & 1u) != 0u)
	                {
	                    _11910 = g_ScrambledHaltonPermutations.Load(_16728 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11910 = g_ScrambledHaltonPermutations.Load(_16728 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11617 * 683929u) + (_11503 * 827u)) + _11910) * 1.7680047426082978745398577302694e-09f;
	                _19095 = true;
	                break;
	            }
	            case 144u:
	            {
	                uint _15827 = 55743u + (_12091 % 829u);
	                uint _16723 = _15827 / 2u;
	                uint _11616;
	                if ((_15827 & 1u) != 0u)
	                {
	                    _11616 = g_ScrambledHaltonPermutations.Load(_16723 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11616 = g_ScrambledHaltonPermutations.Load(_16723 * 4 + 0) & 65535u;
	                }
	                uint _20492 = 55743u + ((_12091 / 829u) % 829u);
	                uint _16724 = _20492 / 2u;
	                uint _11502;
	                if ((_20492 & 1u) != 0u)
	                {
	                    _11502 = g_ScrambledHaltonPermutations.Load(_16724 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11502 = g_ScrambledHaltonPermutations.Load(_16724 * 4 + 0) & 65535u;
	                }
	                uint _20493 = 55743u + ((_12091 / 687241u) % 829u);
	                uint _16725 = _20493 / 2u;
	                uint _11908;
	                if ((_20493 & 1u) != 0u)
	                {
	                    _11908 = g_ScrambledHaltonPermutations.Load(_16725 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11908 = g_ScrambledHaltonPermutations.Load(_16725 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11616 * 687241u) + (_11502 * 829u)) + _11908) * 1.7552392872488553621224127709866e-09f;
	                _19095 = true;
	                break;
	            }
	            case 145u:
	            {
	                uint _15823 = 56572u + (_12091 % 839u);
	                uint _16720 = _15823 / 2u;
	                uint _11615;
	                if ((_15823 & 1u) != 0u)
	                {
	                    _11615 = g_ScrambledHaltonPermutations.Load(_16720 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11615 = g_ScrambledHaltonPermutations.Load(_16720 * 4 + 0) & 65535u;
	                }
	                uint _20490 = 56572u + ((_12091 / 839u) % 839u);
	                uint _16721 = _20490 / 2u;
	                uint _11501;
	                if ((_20490 & 1u) != 0u)
	                {
	                    _11501 = g_ScrambledHaltonPermutations.Load(_16721 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11501 = g_ScrambledHaltonPermutations.Load(_16721 * 4 + 0) & 65535u;
	                }
	                uint _20491 = 56572u + ((_12091 / 703921u) % 839u);
	                uint _16722 = _20491 / 2u;
	                uint _11906;
	                if ((_20491 & 1u) != 0u)
	                {
	                    _11906 = g_ScrambledHaltonPermutations.Load(_16722 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11906 = g_ScrambledHaltonPermutations.Load(_16722 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11615 * 703921u) + (_11501 * 839u)) + _11906) * 1.6932226731825039678369648754597e-09f;
	                _19095 = true;
	                break;
	            }
	            case 146u:
	            {
	                uint _15819 = 57411u + (_12091 % 853u);
	                uint _16717 = _15819 / 2u;
	                uint _11614;
	                if ((_15819 & 1u) != 0u)
	                {
	                    _11614 = g_ScrambledHaltonPermutations.Load(_16717 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11614 = g_ScrambledHaltonPermutations.Load(_16717 * 4 + 0) & 65535u;
	                }
	                uint _20488 = 57411u + ((_12091 / 853u) % 853u);
	                uint _16718 = _20488 / 2u;
	                uint _11500;
	                if ((_20488 & 1u) != 0u)
	                {
	                    _11500 = g_ScrambledHaltonPermutations.Load(_16718 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11500 = g_ScrambledHaltonPermutations.Load(_16718 * 4 + 0) & 65535u;
	                }
	                uint _20489 = 57411u + ((_12091 / 727609u) % 853u);
	                uint _16719 = _20489 / 2u;
	                uint _11904;
	                if ((_20489 & 1u) != 0u)
	                {
	                    _11904 = g_ScrambledHaltonPermutations.Load(_16719 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11904 = g_ScrambledHaltonPermutations.Load(_16719 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11614 * 727609u) + (_11500 * 853u)) + _11904) * 1.611212607777190441993298009038e-09f;
	                _19095 = true;
	                break;
	            }
	            case 147u:
	            {
	                uint _15815 = 58264u + (_12091 % 857u);
	                uint _16714 = _15815 / 2u;
	                uint _11613;
	                if ((_15815 & 1u) != 0u)
	                {
	                    _11613 = g_ScrambledHaltonPermutations.Load(_16714 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11613 = g_ScrambledHaltonPermutations.Load(_16714 * 4 + 0) & 65535u;
	                }
	                uint _20486 = 58264u + ((_12091 / 857u) % 857u);
	                uint _16715 = _20486 / 2u;
	                uint _11499;
	                if ((_20486 & 1u) != 0u)
	                {
	                    _11499 = g_ScrambledHaltonPermutations.Load(_16715 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11499 = g_ScrambledHaltonPermutations.Load(_16715 * 4 + 0) & 65535u;
	                }
	                uint _20487 = 58264u + ((_12091 / 734449u) % 857u);
	                uint _16716 = _20487 / 2u;
	                uint _11902;
	                if ((_20487 & 1u) != 0u)
	                {
	                    _11902 = g_ScrambledHaltonPermutations.Load(_16716 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11902 = g_ScrambledHaltonPermutations.Load(_16716 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11613 * 734449u) + (_11499 * 857u)) + _11902) * 1.5887570148365171007753815501928e-09f;
	                _19095 = true;
	                break;
	            }
	            case 148u:
	            {
	                uint _15811 = 59121u + (_12091 % 859u);
	                uint _16711 = _15811 / 2u;
	                uint _11612;
	                if ((_15811 & 1u) != 0u)
	                {
	                    _11612 = g_ScrambledHaltonPermutations.Load(_16711 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11612 = g_ScrambledHaltonPermutations.Load(_16711 * 4 + 0) & 65535u;
	                }
	                uint _20484 = 59121u + ((_12091 / 859u) % 859u);
	                uint _16712 = _20484 / 2u;
	                uint _11498;
	                if ((_20484 & 1u) != 0u)
	                {
	                    _11498 = g_ScrambledHaltonPermutations.Load(_16712 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11498 = g_ScrambledHaltonPermutations.Load(_16712 * 4 + 0) & 65535u;
	                }
	                uint _20485 = 59121u + ((_12091 / 737881u) % 859u);
	                uint _16713 = _20485 / 2u;
	                uint _11900;
	                if ((_20485 & 1u) != 0u)
	                {
	                    _11900 = g_ScrambledHaltonPermutations.Load(_16713 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11900 = g_ScrambledHaltonPermutations.Load(_16713 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11612 * 737881u) + (_11498 * 859u)) + _11900) * 1.5776855377680476522073149681091e-09f;
	                _19095 = true;
	                break;
	            }
	            case 149u:
	            {
	                uint _15807 = 59980u + (_12091 % 863u);
	                uint _16708 = _15807 / 2u;
	                uint _11611;
	                if ((_15807 & 1u) != 0u)
	                {
	                    _11611 = g_ScrambledHaltonPermutations.Load(_16708 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11611 = g_ScrambledHaltonPermutations.Load(_16708 * 4 + 0) & 65535u;
	                }
	                uint _20482 = 59980u + ((_12091 / 863u) % 863u);
	                uint _16709 = _20482 / 2u;
	                uint _11497;
	                if ((_20482 & 1u) != 0u)
	                {
	                    _11497 = g_ScrambledHaltonPermutations.Load(_16709 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11497 = g_ScrambledHaltonPermutations.Load(_16709 * 4 + 0) & 65535u;
	                }
	                uint _20483 = 59980u + ((_12091 / 744769u) % 863u);
	                uint _16710 = _20483 / 2u;
	                uint _11898;
	                if ((_20483 & 1u) != 0u)
	                {
	                    _11898 = g_ScrambledHaltonPermutations.Load(_16710 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11898 = g_ScrambledHaltonPermutations.Load(_16710 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11611 * 744769u) + (_11497 * 863u)) + _11898) * 1.5558494492751151483389548957348e-09f;
	                _19095 = true;
	                break;
	            }
	            case 150u:
	            {
	                uint _15803 = 60843u + (_12091 % 877u);
	                uint _16705 = _15803 / 2u;
	                uint _11610;
	                if ((_15803 & 1u) != 0u)
	                {
	                    _11610 = g_ScrambledHaltonPermutations.Load(_16705 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11610 = g_ScrambledHaltonPermutations.Load(_16705 * 4 + 0) & 65535u;
	                }
	                uint _20480 = 60843u + ((_12091 / 877u) % 877u);
	                uint _16706 = _20480 / 2u;
	                uint _11496;
	                if ((_20480 & 1u) != 0u)
	                {
	                    _11496 = g_ScrambledHaltonPermutations.Load(_16706 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11496 = g_ScrambledHaltonPermutations.Load(_16706 * 4 + 0) & 65535u;
	                }
	                uint _20481 = 60843u + ((_12091 / 769129u) % 877u);
	                uint _16707 = _20481 / 2u;
	                uint _11896;
	                if ((_20481 & 1u) != 0u)
	                {
	                    _11896 = g_ScrambledHaltonPermutations.Load(_16707 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11896 = g_ScrambledHaltonPermutations.Load(_16707 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11610 * 769129u) + (_11496 * 877u)) + _11896) * 1.4825219940561851217353250831366e-09f;
	                _19095 = true;
	                break;
	            }
	            case 151u:
	            {
	                uint _15799 = 61720u + (_12091 % 881u);
	                uint _16702 = _15799 / 2u;
	                uint _11609;
	                if ((_15799 & 1u) != 0u)
	                {
	                    _11609 = g_ScrambledHaltonPermutations.Load(_16702 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11609 = g_ScrambledHaltonPermutations.Load(_16702 * 4 + 0) & 65535u;
	                }
	                uint _20478 = 61720u + ((_12091 / 881u) % 881u);
	                uint _16703 = _20478 / 2u;
	                uint _11495;
	                if ((_20478 & 1u) != 0u)
	                {
	                    _11495 = g_ScrambledHaltonPermutations.Load(_16703 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11495 = g_ScrambledHaltonPermutations.Load(_16703 * 4 + 0) & 65535u;
	                }
	                uint _20479 = 61720u + ((_12091 / 776161u) % 881u);
	                uint _16704 = _20479 / 2u;
	                uint _11894;
	                if ((_20479 & 1u) != 0u)
	                {
	                    _11894 = g_ScrambledHaltonPermutations.Load(_16704 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11894 = g_ScrambledHaltonPermutations.Load(_16704 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11609 * 776161u) + (_11495 * 881u)) + _11894) * 1.4624204069946244999300688505173e-09f;
	                _19095 = true;
	                break;
	            }
	            case 152u:
	            {
	                uint _15795 = 62601u + (_12091 % 883u);
	                uint _16699 = _15795 / 2u;
	                uint _11608;
	                if ((_15795 & 1u) != 0u)
	                {
	                    _11608 = g_ScrambledHaltonPermutations.Load(_16699 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11608 = g_ScrambledHaltonPermutations.Load(_16699 * 4 + 0) & 65535u;
	                }
	                uint _20476 = 62601u + ((_12091 / 883u) % 883u);
	                uint _16700 = _20476 / 2u;
	                uint _11494;
	                if ((_20476 & 1u) != 0u)
	                {
	                    _11494 = g_ScrambledHaltonPermutations.Load(_16700 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11494 = g_ScrambledHaltonPermutations.Load(_16700 * 4 + 0) & 65535u;
	                }
	                uint _20477 = 62601u + ((_12091 / 779689u) % 883u);
	                uint _16701 = _20477 / 2u;
	                uint _11892;
	                if ((_20477 & 1u) != 0u)
	                {
	                    _11892 = g_ScrambledHaltonPermutations.Load(_16701 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11892 = g_ScrambledHaltonPermutations.Load(_16701 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11608 * 779689u) + (_11494 * 883u)) + _11892) * 1.4525056712955120019614696502686e-09f;
	                _19095 = true;
	                break;
	            }
	            case 153u:
	            {
	                uint _15791 = 63484u + (_12091 % 887u);
	                uint _16696 = _15791 / 2u;
	                uint _11607;
	                if ((_15791 & 1u) != 0u)
	                {
	                    _11607 = g_ScrambledHaltonPermutations.Load(_16696 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11607 = g_ScrambledHaltonPermutations.Load(_16696 * 4 + 0) & 65535u;
	                }
	                uint _20474 = 63484u + ((_12091 / 887u) % 887u);
	                uint _16697 = _20474 / 2u;
	                uint _11493;
	                if ((_20474 & 1u) != 0u)
	                {
	                    _11493 = g_ScrambledHaltonPermutations.Load(_16697 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11493 = g_ScrambledHaltonPermutations.Load(_16697 * 4 + 0) & 65535u;
	                }
	                uint _20475 = 63484u + ((_12091 / 786769u) % 887u);
	                uint _16698 = _20475 / 2u;
	                uint _11890;
	                if ((_20475 & 1u) != 0u)
	                {
	                    _11890 = g_ScrambledHaltonPermutations.Load(_16698 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11890 = g_ScrambledHaltonPermutations.Load(_16698 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11607 * 786769u) + (_11493 * 887u)) + _11890) * 1.4329435416016167437192052602768e-09f;
	                _19095 = true;
	                break;
	            }
	            case 154u:
	            {
	                uint _15787 = 64371u + (_12091 % 907u);
	                uint _16693 = _15787 / 2u;
	                uint _11606;
	                if ((_15787 & 1u) != 0u)
	                {
	                    _11606 = g_ScrambledHaltonPermutations.Load(_16693 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11606 = g_ScrambledHaltonPermutations.Load(_16693 * 4 + 0) & 65535u;
	                }
	                uint _20472 = 64371u + ((_12091 / 907u) % 907u);
	                uint _16694 = _20472 / 2u;
	                uint _11492;
	                if ((_20472 & 1u) != 0u)
	                {
	                    _11492 = g_ScrambledHaltonPermutations.Load(_16694 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11492 = g_ScrambledHaltonPermutations.Load(_16694 * 4 + 0) & 65535u;
	                }
	                uint _20473 = 64371u + ((_12091 / 822649u) % 907u);
	                uint _16695 = _20473 / 2u;
	                uint _11888;
	                if ((_20473 & 1u) != 0u)
	                {
	                    _11888 = g_ScrambledHaltonPermutations.Load(_16695 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11888 = g_ScrambledHaltonPermutations.Load(_16695 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11606 * 822649u) + (_11492 * 907u)) + _11888) * 1.3402261522799108206527307629585e-09f;
	                _19095 = true;
	                break;
	            }
	            case 155u:
	            {
	                uint _15783 = 65278u + (_12091 % 911u);
	                uint _16690 = _15783 / 2u;
	                uint _11605;
	                if ((_15783 & 1u) != 0u)
	                {
	                    _11605 = g_ScrambledHaltonPermutations.Load(_16690 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11605 = g_ScrambledHaltonPermutations.Load(_16690 * 4 + 0) & 65535u;
	                }
	                uint _20470 = 65278u + ((_12091 / 911u) % 911u);
	                uint _16691 = _20470 / 2u;
	                uint _11491;
	                if ((_20470 & 1u) != 0u)
	                {
	                    _11491 = g_ScrambledHaltonPermutations.Load(_16691 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11491 = g_ScrambledHaltonPermutations.Load(_16691 * 4 + 0) & 65535u;
	                }
	                uint _20471 = 65278u + ((_12091 / 829921u) % 911u);
	                uint _16692 = _20471 / 2u;
	                uint _11886;
	                if ((_20471 & 1u) != 0u)
	                {
	                    _11886 = g_ScrambledHaltonPermutations.Load(_16692 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11886 = g_ScrambledHaltonPermutations.Load(_16692 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11605 * 829921u) + (_11491 * 911u)) + _11886) * 1.3226496564655576548830140382051e-09f;
	                _19095 = true;
	                break;
	            }
	            case 156u:
	            {
	                uint _15779 = 66189u + (_12091 % 919u);
	                uint _16687 = _15779 / 2u;
	                uint _11604;
	                if ((_15779 & 1u) != 0u)
	                {
	                    _11604 = g_ScrambledHaltonPermutations.Load(_16687 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11604 = g_ScrambledHaltonPermutations.Load(_16687 * 4 + 0) & 65535u;
	                }
	                uint _20468 = 66189u + ((_12091 / 919u) % 919u);
	                uint _16688 = _20468 / 2u;
	                uint _11490;
	                if ((_20468 & 1u) != 0u)
	                {
	                    _11490 = g_ScrambledHaltonPermutations.Load(_16688 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11490 = g_ScrambledHaltonPermutations.Load(_16688 * 4 + 0) & 65535u;
	                }
	                uint _20469 = 66189u + ((_12091 / 844561u) % 919u);
	                uint _16689 = _20469 / 2u;
	                uint _11884;
	                if ((_20469 & 1u) != 0u)
	                {
	                    _11884 = g_ScrambledHaltonPermutations.Load(_16689 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11884 = g_ScrambledHaltonPermutations.Load(_16689 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11604 * 844561u) + (_11490 * 919u)) + _11884) * 1.2884080469177661143476143479347e-09f;
	                _19095 = true;
	                break;
	            }
	            case 157u:
	            {
	                uint _15775 = 67108u + (_12091 % 929u);
	                uint _16684 = _15775 / 2u;
	                uint _11603;
	                if ((_15775 & 1u) != 0u)
	                {
	                    _11603 = g_ScrambledHaltonPermutations.Load(_16684 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11603 = g_ScrambledHaltonPermutations.Load(_16684 * 4 + 0) & 65535u;
	                }
	                uint _20466 = 67108u + ((_12091 / 929u) % 929u);
	                uint _16685 = _20466 / 2u;
	                uint _11489;
	                if ((_20466 & 1u) != 0u)
	                {
	                    _11489 = g_ScrambledHaltonPermutations.Load(_16685 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11489 = g_ScrambledHaltonPermutations.Load(_16685 * 4 + 0) & 65535u;
	                }
	                uint _20467 = 67108u + ((_12091 / 863041u) % 929u);
	                uint _16686 = _20467 / 2u;
	                uint _11882;
	                if ((_20467 & 1u) != 0u)
	                {
	                    _11882 = g_ScrambledHaltonPermutations.Load(_16686 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11882 = g_ScrambledHaltonPermutations.Load(_16686 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11603 * 863041u) + (_11489 * 929u)) + _11882) * 1.2472479715697204483149107545614e-09f;
	                _19095 = true;
	                break;
	            }
	            case 158u:
	            {
	                uint _15771 = 68037u + (_12091 % 937u);
	                uint _16681 = _15771 / 2u;
	                uint _11602;
	                if ((_15771 & 1u) != 0u)
	                {
	                    _11602 = g_ScrambledHaltonPermutations.Load(_16681 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11602 = g_ScrambledHaltonPermutations.Load(_16681 * 4 + 0) & 65535u;
	                }
	                uint _20464 = 68037u + ((_12091 / 937u) % 937u);
	                uint _16682 = _20464 / 2u;
	                uint _11488;
	                if ((_20464 & 1u) != 0u)
	                {
	                    _11488 = g_ScrambledHaltonPermutations.Load(_16682 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11488 = g_ScrambledHaltonPermutations.Load(_16682 * 4 + 0) & 65535u;
	                }
	                uint _20465 = 68037u + ((_12091 / 877969u) % 937u);
	                uint _16683 = _20465 / 2u;
	                uint _11880;
	                if ((_20465 & 1u) != 0u)
	                {
	                    _11880 = g_ScrambledHaltonPermutations.Load(_16683 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11880 = g_ScrambledHaltonPermutations.Load(_16683 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11602 * 877969u) + (_11488 * 937u)) + _11880) * 1.2155733086771647322166245430708e-09f;
	                _19095 = true;
	                break;
	            }
	            case 159u:
	            {
	                uint _15767 = 68974u + (_12091 % 941u);
	                uint _16678 = _15767 / 2u;
	                uint _11601;
	                if ((_15767 & 1u) != 0u)
	                {
	                    _11601 = g_ScrambledHaltonPermutations.Load(_16678 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11601 = g_ScrambledHaltonPermutations.Load(_16678 * 4 + 0) & 65535u;
	                }
	                uint _20462 = 68974u + ((_12091 / 941u) % 941u);
	                uint _16679 = _20462 / 2u;
	                uint _11487;
	                if ((_20462 & 1u) != 0u)
	                {
	                    _11487 = g_ScrambledHaltonPermutations.Load(_16679 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11487 = g_ScrambledHaltonPermutations.Load(_16679 * 4 + 0) & 65535u;
	                }
	                uint _20463 = 68974u + ((_12091 / 885481u) % 941u);
	                uint _16680 = _20463 / 2u;
	                uint _11878;
	                if ((_20463 & 1u) != 0u)
	                {
	                    _11878 = g_ScrambledHaltonPermutations.Load(_16680 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11878 = g_ScrambledHaltonPermutations.Load(_16680 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11601 * 885481u) + (_11487 * 941u)) + _11878) * 1.200137655921196255803806707263e-09f;
	                _19095 = true;
	                break;
	            }
	            case 160u:
	            {
	                uint _15763 = 69915u + (_12091 % 947u);
	                uint _16675 = _15763 / 2u;
	                uint _11600;
	                if ((_15763 & 1u) != 0u)
	                {
	                    _11600 = g_ScrambledHaltonPermutations.Load(_16675 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11600 = g_ScrambledHaltonPermutations.Load(_16675 * 4 + 0) & 65535u;
	                }
	                uint _20460 = 69915u + ((_12091 / 947u) % 947u);
	                uint _16676 = _20460 / 2u;
	                uint _11486;
	                if ((_20460 & 1u) != 0u)
	                {
	                    _11486 = g_ScrambledHaltonPermutations.Load(_16676 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11486 = g_ScrambledHaltonPermutations.Load(_16676 * 4 + 0) & 65535u;
	                }
	                uint _20461 = 69915u + ((_12091 / 896809u) % 947u);
	                uint _16677 = _20461 / 2u;
	                uint _11876;
	                if ((_20461 & 1u) != 0u)
	                {
	                    _11876 = g_ScrambledHaltonPermutations.Load(_16677 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11876 = g_ScrambledHaltonPermutations.Load(_16677 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11600 * 896809u) + (_11486 * 947u)) + _11876) * 1.1774704544720293597492855042219e-09f;
	                _19095 = true;
	                break;
	            }
	            case 161u:
	            {
	                uint _15759 = 70862u + (_12091 % 953u);
	                uint _16672 = _15759 / 2u;
	                uint _11599;
	                if ((_15759 & 1u) != 0u)
	                {
	                    _11599 = g_ScrambledHaltonPermutations.Load(_16672 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11599 = g_ScrambledHaltonPermutations.Load(_16672 * 4 + 0) & 65535u;
	                }
	                uint _20458 = 70862u + ((_12091 / 953u) % 953u);
	                uint _16673 = _20458 / 2u;
	                uint _11485;
	                if ((_20458 & 1u) != 0u)
	                {
	                    _11485 = g_ScrambledHaltonPermutations.Load(_16673 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11485 = g_ScrambledHaltonPermutations.Load(_16673 * 4 + 0) & 65535u;
	                }
	                uint _20459 = 70862u + ((_12091 / 908209u) % 953u);
	                uint _16674 = _20459 / 2u;
	                uint _11874;
	                if ((_20459 & 1u) != 0u)
	                {
	                    _11874 = g_ScrambledHaltonPermutations.Load(_16674 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11874 = g_ScrambledHaltonPermutations.Load(_16674 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11599 * 908209u) + (_11485 * 953u)) + _11874) * 1.1553703549438409936556126922369e-09f;
	                _19095 = true;
	                break;
	            }
	            case 162u:
	            {
	                uint _15755 = 71815u + (_12091 % 967u);
	                uint _16669 = _15755 / 2u;
	                uint _11598;
	                if ((_15755 & 1u) != 0u)
	                {
	                    _11598 = g_ScrambledHaltonPermutations.Load(_16669 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11598 = g_ScrambledHaltonPermutations.Load(_16669 * 4 + 0) & 65535u;
	                }
	                uint _20456 = 71815u + ((_12091 / 967u) % 967u);
	                uint _16670 = _20456 / 2u;
	                uint _11484;
	                if ((_20456 & 1u) != 0u)
	                {
	                    _11484 = g_ScrambledHaltonPermutations.Load(_16670 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11484 = g_ScrambledHaltonPermutations.Load(_16670 * 4 + 0) & 65535u;
	                }
	                uint _20457 = 71815u + ((_12091 / 935089u) % 967u);
	                uint _16671 = _20457 / 2u;
	                uint _11872;
	                if ((_20457 & 1u) != 0u)
	                {
	                    _11872 = g_ScrambledHaltonPermutations.Load(_16671 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11872 = g_ScrambledHaltonPermutations.Load(_16671 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11598 * 935089u) + (_11484 * 967u)) + _11872) * 1.1059119175982345950615126639605e-09f;
	                _19095 = true;
	                break;
	            }
	            case 163u:
	            {
	                uint _15751 = 72782u + (_12091 % 971u);
	                uint _16666 = _15751 / 2u;
	                uint _11597;
	                if ((_15751 & 1u) != 0u)
	                {
	                    _11597 = g_ScrambledHaltonPermutations.Load(_16666 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11597 = g_ScrambledHaltonPermutations.Load(_16666 * 4 + 0) & 65535u;
	                }
	                uint _20454 = 72782u + ((_12091 / 971u) % 971u);
	                uint _16667 = _20454 / 2u;
	                uint _11483;
	                if ((_20454 & 1u) != 0u)
	                {
	                    _11483 = g_ScrambledHaltonPermutations.Load(_16667 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11483 = g_ScrambledHaltonPermutations.Load(_16667 * 4 + 0) & 65535u;
	                }
	                uint _20455 = 72782u + ((_12091 / 942841u) % 971u);
	                uint _16668 = _20455 / 2u;
	                uint _11871;
	                if ((_20455 & 1u) != 0u)
	                {
	                    _11871 = g_ScrambledHaltonPermutations.Load(_16668 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11871 = g_ScrambledHaltonPermutations.Load(_16668 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11597 * 942841u) + (_11483 * 971u)) + _11871) * 1.092300805360935100907227024436e-09f;
	                _19095 = true;
	                break;
	            }
	            case 164u:
	            {
	                uint _15747 = 73753u + (_12091 % 977u);
	                uint _16663 = _15747 / 2u;
	                uint _11596;
	                if ((_15747 & 1u) != 0u)
	                {
	                    _11596 = g_ScrambledHaltonPermutations.Load(_16663 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11596 = g_ScrambledHaltonPermutations.Load(_16663 * 4 + 0) & 65535u;
	                }
	                uint _20452 = 73753u + ((_12091 / 977u) % 977u);
	                uint _16664 = _20452 / 2u;
	                uint _11482;
	                if ((_20452 & 1u) != 0u)
	                {
	                    _11482 = g_ScrambledHaltonPermutations.Load(_16664 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11482 = g_ScrambledHaltonPermutations.Load(_16664 * 4 + 0) & 65535u;
	                }
	                uint _20453 = 73753u + ((_12091 / 954529u) % 977u);
	                uint _16665 = _20453 / 2u;
	                uint _11870;
	                if ((_20453 & 1u) != 0u)
	                {
	                    _11870 = g_ScrambledHaltonPermutations.Load(_16665 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11870 = g_ScrambledHaltonPermutations.Load(_16665 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11596 * 954529u) + (_11482 * 977u)) + _11870) * 1.072299915527707980800187215209e-09f;
	                _19095 = true;
	                break;
	            }
	            case 165u:
	            {
	                uint _15745 = 74730u + (_12091 % 983u);
	                uint _16660 = _15745 / 2u;
	                uint _11595;
	                if ((_15745 & 1u) != 0u)
	                {
	                    _11595 = g_ScrambledHaltonPermutations.Load(_16660 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11595 = g_ScrambledHaltonPermutations.Load(_16660 * 4 + 0) & 65535u;
	                }
	                uint _20450 = 74730u + ((_12091 / 983u) % 983u);
	                uint _16661 = _20450 / 2u;
	                uint _11481;
	                if ((_20450 & 1u) != 0u)
	                {
	                    _11481 = g_ScrambledHaltonPermutations.Load(_16661 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11481 = g_ScrambledHaltonPermutations.Load(_16661 * 4 + 0) & 65535u;
	                }
	                uint _20451 = 74730u + ((_12091 / 966289u) % 983u);
	                uint _16662 = _20451 / 2u;
	                uint _11869;
	                if ((_20451 & 1u) != 0u)
	                {
	                    _11869 = g_ScrambledHaltonPermutations.Load(_16662 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11869 = g_ScrambledHaltonPermutations.Load(_16662 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11595 * 966289u) + (_11481 * 983u)) + _11869) * 1.0527843041785445166169665753841e-09f;
	                _19095 = true;
	                break;
	            }
	            case 166u:
	            {
	                uint _15744 = 75713u + (_12091 % 991u);
	                uint _16657 = _15744 / 2u;
	                uint _11594;
	                if ((_15744 & 1u) != 0u)
	                {
	                    _11594 = g_ScrambledHaltonPermutations.Load(_16657 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11594 = g_ScrambledHaltonPermutations.Load(_16657 * 4 + 0) & 65535u;
	                }
	                uint _20448 = 75713u + ((_12091 / 991u) % 991u);
	                uint _16658 = _20448 / 2u;
	                uint _11480;
	                if ((_20448 & 1u) != 0u)
	                {
	                    _11480 = g_ScrambledHaltonPermutations.Load(_16658 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11480 = g_ScrambledHaltonPermutations.Load(_16658 * 4 + 0) & 65535u;
	                }
	                uint _20449 = 75713u + ((_12091 / 982081u) % 991u);
	                uint _16659 = _20449 / 2u;
	                uint _11868;
	                if ((_20449 & 1u) != 0u)
	                {
	                    _11868 = g_ScrambledHaltonPermutations.Load(_16659 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11868 = g_ScrambledHaltonPermutations.Load(_16659 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11594 * 982081u) + (_11480 * 991u)) + _11868) * 1.0274933126552809881104622036219e-09f;
	                _19095 = true;
	                break;
	            }
	            case 167u:
	            {
	                uint _15743 = 76704u + (_12091 % 997u);
	                uint _16654 = _15743 / 2u;
	                uint _11593;
	                if ((_15743 & 1u) != 0u)
	                {
	                    _11593 = g_ScrambledHaltonPermutations.Load(_16654 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11593 = g_ScrambledHaltonPermutations.Load(_16654 * 4 + 0) & 65535u;
	                }
	                uint _20446 = 76704u + ((_12091 / 997u) % 997u);
	                uint _16655 = _20446 / 2u;
	                uint _11479;
	                if ((_20446 & 1u) != 0u)
	                {
	                    _11479 = g_ScrambledHaltonPermutations.Load(_16655 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11479 = g_ScrambledHaltonPermutations.Load(_16655 * 4 + 0) & 65535u;
	                }
	                uint _20447 = 76704u + ((_12091 / 994009u) % 997u);
	                uint _16656 = _20447 / 2u;
	                uint _11867;
	                if ((_20447 & 1u) != 0u)
	                {
	                    _11867 = g_ScrambledHaltonPermutations.Load(_16656 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11867 = g_ScrambledHaltonPermutations.Load(_16656 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11593 * 994009u) + (_11479 * 997u)) + _11867) * 1.0090541735507940757088363170624e-09f;
	                _19095 = true;
	                break;
	            }
	            case 168u:
	            {
	                uint _15742 = 77701u + (_12091 % 1009u);
	                uint _16651 = _15742 / 2u;
	                uint _11592;
	                if ((_15742 & 1u) != 0u)
	                {
	                    _11592 = g_ScrambledHaltonPermutations.Load(_16651 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11592 = g_ScrambledHaltonPermutations.Load(_16651 * 4 + 0) & 65535u;
	                }
	                uint _20444 = 77701u + ((_12091 / 1009u) % 1009u);
	                uint _16652 = _20444 / 2u;
	                uint _11478;
	                if ((_20444 & 1u) != 0u)
	                {
	                    _11478 = g_ScrambledHaltonPermutations.Load(_16652 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11478 = g_ScrambledHaltonPermutations.Load(_16652 * 4 + 0) & 65535u;
	                }
	                uint _20445 = 77701u + ((_12091 / 1018081u) % 1009u);
	                uint _16653 = _20445 / 2u;
	                uint _11866;
	                if ((_20445 & 1u) != 0u)
	                {
	                    _11866 = g_ScrambledHaltonPermutations.Load(_16653 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11866 = g_ScrambledHaltonPermutations.Load(_16653 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11592 * 1018081u) + (_11478 * 1009u)) + _11866) * 9.7347874206121787210577167570591e-10f;
	                _19095 = true;
	                break;
	            }
	            case 169u:
	            {
	                uint _15741 = 78710u + (_12091 % 1013u);
	                uint _16648 = _15741 / 2u;
	                uint _11591;
	                if ((_15741 & 1u) != 0u)
	                {
	                    _11591 = g_ScrambledHaltonPermutations.Load(_16648 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11591 = g_ScrambledHaltonPermutations.Load(_16648 * 4 + 0) & 65535u;
	                }
	                uint _20442 = 78710u + ((_12091 / 1013u) % 1013u);
	                uint _16649 = _20442 / 2u;
	                uint _11477;
	                if ((_20442 & 1u) != 0u)
	                {
	                    _11477 = g_ScrambledHaltonPermutations.Load(_16649 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11477 = g_ScrambledHaltonPermutations.Load(_16649 * 4 + 0) & 65535u;
	                }
	                uint _20443 = 78710u + ((_12091 / 1026169u) % 1013u);
	                uint _16650 = _20443 / 2u;
	                uint _11865;
	                if ((_20443 & 1u) != 0u)
	                {
	                    _11865 = g_ScrambledHaltonPermutations.Load(_16650 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11865 = g_ScrambledHaltonPermutations.Load(_16650 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11591 * 1026169u) + (_11477 * 1013u)) + _11865) * 9.6199237464844600253854878246784e-10f;
	                _19095 = true;
	                break;
	            }
	            case 170u:
	            {
	                uint _15740 = 79723u + (_12091 % 1019u);
	                uint _16645 = _15740 / 2u;
	                uint _11590;
	                if ((_15740 & 1u) != 0u)
	                {
	                    _11590 = g_ScrambledHaltonPermutations.Load(_16645 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11590 = g_ScrambledHaltonPermutations.Load(_16645 * 4 + 0) & 65535u;
	                }
	                uint _20440 = 79723u + ((_12091 / 1019u) % 1019u);
	                uint _16646 = _20440 / 2u;
	                uint _11476;
	                if ((_20440 & 1u) != 0u)
	                {
	                    _11476 = g_ScrambledHaltonPermutations.Load(_16646 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11476 = g_ScrambledHaltonPermutations.Load(_16646 * 4 + 0) & 65535u;
	                }
	                uint _20441 = 79723u + ((_12091 / 1038361u) % 1019u);
	                uint _16647 = _20441 / 2u;
	                uint _11864;
	                if ((_20441 & 1u) != 0u)
	                {
	                    _11864 = g_ScrambledHaltonPermutations.Load(_16647 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11864 = g_ScrambledHaltonPermutations.Load(_16647 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11590 * 1038361u) + (_11476 * 1019u)) + _11864) * 9.4509922110574962061946280300617e-10f;
	                _19095 = true;
	                break;
	            }
	            case 171u:
	            {
	                uint _15739 = 80742u + (_12091 % 1021u);
	                uint _16642 = _15739 / 2u;
	                uint _11589;
	                if ((_15739 & 1u) != 0u)
	                {
	                    _11589 = g_ScrambledHaltonPermutations.Load(_16642 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11589 = g_ScrambledHaltonPermutations.Load(_16642 * 4 + 0) & 65535u;
	                }
	                uint _20438 = 80742u + ((_12091 / 1021u) % 1021u);
	                uint _16643 = _20438 / 2u;
	                uint _11475;
	                if ((_20438 & 1u) != 0u)
	                {
	                    _11475 = g_ScrambledHaltonPermutations.Load(_16643 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11475 = g_ScrambledHaltonPermutations.Load(_16643 * 4 + 0) & 65535u;
	                }
	                uint _20439 = 80742u + ((_12091 / 1042441u) % 1021u);
	                uint _16644 = _20439 / 2u;
	                uint _11863;
	                if ((_20439 & 1u) != 0u)
	                {
	                    _11863 = g_ScrambledHaltonPermutations.Load(_16644 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11863 = g_ScrambledHaltonPermutations.Load(_16644 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11589 * 1042441u) + (_11475 * 1021u)) + _11863) * 9.3955609958840113904443569481373e-10f;
	                _19095 = true;
	                break;
	            }
	            case 172u:
	            {
	                uint _15738 = 81763u + (_12091 % 1031u);
	                uint _16639 = _15738 / 2u;
	                uint _11588;
	                if ((_15738 & 1u) != 0u)
	                {
	                    _11588 = g_ScrambledHaltonPermutations.Load(_16639 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11588 = g_ScrambledHaltonPermutations.Load(_16639 * 4 + 0) & 65535u;
	                }
	                uint _20436 = 81763u + ((_12091 / 1031u) % 1031u);
	                uint _16640 = _20436 / 2u;
	                uint _11474;
	                if ((_20436 & 1u) != 0u)
	                {
	                    _11474 = g_ScrambledHaltonPermutations.Load(_16640 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11474 = g_ScrambledHaltonPermutations.Load(_16640 * 4 + 0) & 65535u;
	                }
	                uint _20437 = 81763u + ((_12091 / 1062961u) % 1031u);
	                uint _16641 = _20437 / 2u;
	                uint _11862;
	                if ((_20437 & 1u) != 0u)
	                {
	                    _11862 = g_ScrambledHaltonPermutations.Load(_16641 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11862 = g_ScrambledHaltonPermutations.Load(_16641 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11588 * 1062961u) + (_11474 * 1031u)) + _11862) * 9.1248120170916990900877863168716e-10f;
	                _19095 = true;
	                break;
	            }
	            case 173u:
	            {
	                uint _15737 = 82794u + (_12091 % 1033u);
	                uint _16636 = _15737 / 2u;
	                uint _11587;
	                if ((_15737 & 1u) != 0u)
	                {
	                    _11587 = g_ScrambledHaltonPermutations.Load(_16636 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11587 = g_ScrambledHaltonPermutations.Load(_16636 * 4 + 0) & 65535u;
	                }
	                uint _20434 = 82794u + ((_12091 / 1033u) % 1033u);
	                uint _16637 = _20434 / 2u;
	                uint _11473;
	                if ((_20434 & 1u) != 0u)
	                {
	                    _11473 = g_ScrambledHaltonPermutations.Load(_16637 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11473 = g_ScrambledHaltonPermutations.Load(_16637 * 4 + 0) & 65535u;
	                }
	                uint _20435 = 82794u + ((_12091 / 1067089u) % 1033u);
	                uint _16638 = _20435 / 2u;
	                uint _11861;
	                if ((_20435 & 1u) != 0u)
	                {
	                    _11861 = g_ScrambledHaltonPermutations.Load(_16638 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11861 = g_ScrambledHaltonPermutations.Load(_16638 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11587 * 1067089u) + (_11473 * 1033u)) + _11861) * 9.0719148859719211941410321742296e-10f;
	                _19095 = true;
	                break;
	            }
	            case 174u:
	            {
	                uint _15736 = 83827u + (_12091 % 1039u);
	                uint _16633 = _15736 / 2u;
	                uint _11586;
	                if ((_15736 & 1u) != 0u)
	                {
	                    _11586 = g_ScrambledHaltonPermutations.Load(_16633 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11586 = g_ScrambledHaltonPermutations.Load(_16633 * 4 + 0) & 65535u;
	                }
	                uint _20432 = 83827u + ((_12091 / 1039u) % 1039u);
	                uint _16634 = _20432 / 2u;
	                uint _11472;
	                if ((_20432 & 1u) != 0u)
	                {
	                    _11472 = g_ScrambledHaltonPermutations.Load(_16634 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11472 = g_ScrambledHaltonPermutations.Load(_16634 * 4 + 0) & 65535u;
	                }
	                uint _20433 = 83827u + ((_12091 / 1079521u) % 1039u);
	                uint _16635 = _20433 / 2u;
	                uint _11860;
	                if ((_20433 & 1u) != 0u)
	                {
	                    _11860 = g_ScrambledHaltonPermutations.Load(_16635 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11860 = g_ScrambledHaltonPermutations.Load(_16635 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11586 * 1079521u) + (_11472 * 1039u)) + _11860) * 8.9156565463710535368591081351042e-10f;
	                _19095 = true;
	                break;
	            }
	            case 175u:
	            {
	                uint _15735 = 84866u + (_12091 % 1049u);
	                uint _16630 = _15735 / 2u;
	                uint _11585;
	                if ((_15735 & 1u) != 0u)
	                {
	                    _11585 = g_ScrambledHaltonPermutations.Load(_16630 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11585 = g_ScrambledHaltonPermutations.Load(_16630 * 4 + 0) & 65535u;
	                }
	                uint _20430 = 84866u + ((_12091 / 1049u) % 1049u);
	                uint _16631 = _20430 / 2u;
	                uint _11471;
	                if ((_20430 & 1u) != 0u)
	                {
	                    _11471 = g_ScrambledHaltonPermutations.Load(_16631 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11471 = g_ScrambledHaltonPermutations.Load(_16631 * 4 + 0) & 65535u;
	                }
	                uint _20431 = 84866u + ((_12091 / 1100401u) % 1049u);
	                uint _16632 = _20431 / 2u;
	                uint _11859;
	                if ((_20431 & 1u) != 0u)
	                {
	                    _11859 = g_ScrambledHaltonPermutations.Load(_16632 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11859 = g_ScrambledHaltonPermutations.Load(_16632 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11585 * 1100401u) + (_11471 * 1049u)) + _11859) * 8.6631030127293229270435404032469e-10f;
	                _19095 = true;
	                break;
	            }
	            case 176u:
	            {
	                uint _15734 = 85915u + (_12091 % 1051u);
	                uint _16627 = _15734 / 2u;
	                uint _11584;
	                if ((_15734 & 1u) != 0u)
	                {
	                    _11584 = g_ScrambledHaltonPermutations.Load(_16627 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11584 = g_ScrambledHaltonPermutations.Load(_16627 * 4 + 0) & 65535u;
	                }
	                uint _20428 = 85915u + ((_12091 / 1051u) % 1051u);
	                uint _16628 = _20428 / 2u;
	                uint _11470;
	                if ((_20428 & 1u) != 0u)
	                {
	                    _11470 = g_ScrambledHaltonPermutations.Load(_16628 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11470 = g_ScrambledHaltonPermutations.Load(_16628 * 4 + 0) & 65535u;
	                }
	                uint _20429 = 85915u + ((_12091 / 1104601u) % 1051u);
	                uint _16629 = _20429 / 2u;
	                uint _11858;
	                if ((_20429 & 1u) != 0u)
	                {
	                    _11858 = g_ScrambledHaltonPermutations.Load(_16629 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11858 = g_ScrambledHaltonPermutations.Load(_16629 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11584 * 1104601u) + (_11470 * 1051u)) + _11858) * 8.6137408317199515295214951038361e-10f;
	                _19095 = true;
	                break;
	            }
	            case 177u:
	            {
	                uint _15733 = 86966u + (_12091 % 1061u);
	                uint _16624 = _15733 / 2u;
	                uint _11583;
	                if ((_15733 & 1u) != 0u)
	                {
	                    _11583 = g_ScrambledHaltonPermutations.Load(_16624 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11583 = g_ScrambledHaltonPermutations.Load(_16624 * 4 + 0) & 65535u;
	                }
	                uint _20426 = 86966u + ((_12091 / 1061u) % 1061u);
	                uint _16625 = _20426 / 2u;
	                uint _11469;
	                if ((_20426 & 1u) != 0u)
	                {
	                    _11469 = g_ScrambledHaltonPermutations.Load(_16625 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11469 = g_ScrambledHaltonPermutations.Load(_16625 * 4 + 0) & 65535u;
	                }
	                uint _20427 = 86966u + ((_12091 / 1125721u) % 1061u);
	                uint _16626 = _20427 / 2u;
	                uint _11857;
	                if ((_20427 & 1u) != 0u)
	                {
	                    _11857 = g_ScrambledHaltonPermutations.Load(_16626 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11857 = g_ScrambledHaltonPermutations.Load(_16626 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11583 * 1125721u) + (_11469 * 1061u)) + _11857) * 8.3724732702350479485176037997007e-10f;
	                _19095 = true;
	                break;
	            }
	            case 178u:
	            {
	                uint _15732 = 88027u + (_12091 % 1063u);
	                uint _16621 = _15732 / 2u;
	                uint _11582;
	                if ((_15732 & 1u) != 0u)
	                {
	                    _11582 = g_ScrambledHaltonPermutations.Load(_16621 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11582 = g_ScrambledHaltonPermutations.Load(_16621 * 4 + 0) & 65535u;
	                }
	                uint _20424 = 88027u + ((_12091 / 1063u) % 1063u);
	                uint _16622 = _20424 / 2u;
	                uint _11468;
	                if ((_20424 & 1u) != 0u)
	                {
	                    _11468 = g_ScrambledHaltonPermutations.Load(_16622 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11468 = g_ScrambledHaltonPermutations.Load(_16622 * 4 + 0) & 65535u;
	                }
	                uint _20425 = 88027u + ((_12091 / 1129969u) % 1063u);
	                uint _16623 = _20425 / 2u;
	                uint _11856;
	                if ((_20425 & 1u) != 0u)
	                {
	                    _11856 = g_ScrambledHaltonPermutations.Load(_16623 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11856 = g_ScrambledHaltonPermutations.Load(_16623 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11582 * 1129969u) + (_11468 * 1063u)) + _11856) * 8.3253054450338481728977058082819e-10f;
	                _19095 = true;
	                break;
	            }
	            case 179u:
	            {
	                uint _15731 = 89090u + (_12091 % 1069u);
	                uint _16618 = _15731 / 2u;
	                uint _11581;
	                if ((_15731 & 1u) != 0u)
	                {
	                    _11581 = g_ScrambledHaltonPermutations.Load(_16618 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11581 = g_ScrambledHaltonPermutations.Load(_16618 * 4 + 0) & 65535u;
	                }
	                uint _20422 = 89090u + ((_12091 / 1069u) % 1069u);
	                uint _16619 = _20422 / 2u;
	                uint _11467;
	                if ((_20422 & 1u) != 0u)
	                {
	                    _11467 = g_ScrambledHaltonPermutations.Load(_16619 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11467 = g_ScrambledHaltonPermutations.Load(_16619 * 4 + 0) & 65535u;
	                }
	                uint _20423 = 89090u + ((_12091 / 1142761u) % 1069u);
	                uint _16620 = _20423 / 2u;
	                uint _11855;
	                if ((_20423 & 1u) != 0u)
	                {
	                    _11855 = g_ScrambledHaltonPermutations.Load(_16620 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11855 = g_ScrambledHaltonPermutations.Load(_16620 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11581 * 1142761u) + (_11467 * 1069u)) + _11855) * 8.1859075073964504554169252514839e-10f;
	                _19095 = true;
	                break;
	            }
	            case 180u:
	            {
	                uint _15730 = 90159u + (_12091 % 1087u);
	                uint _16615 = _15730 / 2u;
	                uint _11580;
	                if ((_15730 & 1u) != 0u)
	                {
	                    _11580 = g_ScrambledHaltonPermutations.Load(_16615 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11580 = g_ScrambledHaltonPermutations.Load(_16615 * 4 + 0) & 65535u;
	                }
	                uint _20420 = 90159u + ((_12091 / 1087u) % 1087u);
	                uint _16616 = _20420 / 2u;
	                uint _11466;
	                if ((_20420 & 1u) != 0u)
	                {
	                    _11466 = g_ScrambledHaltonPermutations.Load(_16616 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11466 = g_ScrambledHaltonPermutations.Load(_16616 * 4 + 0) & 65535u;
	                }
	                uint _20421 = 90159u + ((_12091 / 1181569u) % 1087u);
	                uint _16617 = _20421 / 2u;
	                uint _11854;
	                if ((_20421 & 1u) != 0u)
	                {
	                    _11854 = g_ScrambledHaltonPermutations.Load(_16617 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11854 = g_ScrambledHaltonPermutations.Load(_16617 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11580 * 1181569u) + (_11466 * 1087u)) + _11854) * 7.7859452218831393111031502485275e-10f;
	                _19095 = true;
	                break;
	            }
	            case 181u:
	            {
	                uint _15729 = 91246u + (_12091 % 1091u);
	                uint _16612 = _15729 / 2u;
	                uint _11579;
	                if ((_15729 & 1u) != 0u)
	                {
	                    _11579 = g_ScrambledHaltonPermutations.Load(_16612 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11579 = g_ScrambledHaltonPermutations.Load(_16612 * 4 + 0) & 65535u;
	                }
	                uint _20418 = 91246u + ((_12091 / 1091u) % 1091u);
	                uint _16613 = _20418 / 2u;
	                uint _11465;
	                if ((_20418 & 1u) != 0u)
	                {
	                    _11465 = g_ScrambledHaltonPermutations.Load(_16613 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11465 = g_ScrambledHaltonPermutations.Load(_16613 * 4 + 0) & 65535u;
	                }
	                uint _20419 = 91246u + ((_12091 / 1190281u) % 1091u);
	                uint _16614 = _20419 / 2u;
	                uint _11853;
	                if ((_20419 & 1u) != 0u)
	                {
	                    _11853 = g_ScrambledHaltonPermutations.Load(_16614 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11853 = g_ScrambledHaltonPermutations.Load(_16614 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11579 * 1190281u) + (_11465 * 1091u)) + _11853) * 7.7006195864370852177671622484922e-10f;
	                _19095 = true;
	                break;
	            }
	            case 182u:
	            {
	                uint _15728 = 92337u + (_12091 % 1093u);
	                uint _16609 = _15728 / 2u;
	                uint _11578;
	                if ((_15728 & 1u) != 0u)
	                {
	                    _11578 = g_ScrambledHaltonPermutations.Load(_16609 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11578 = g_ScrambledHaltonPermutations.Load(_16609 * 4 + 0) & 65535u;
	                }
	                uint _20416 = 92337u + ((_12091 / 1093u) % 1093u);
	                uint _16610 = _20416 / 2u;
	                uint _11464;
	                if ((_20416 & 1u) != 0u)
	                {
	                    _11464 = g_ScrambledHaltonPermutations.Load(_16610 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11464 = g_ScrambledHaltonPermutations.Load(_16610 * 4 + 0) & 65535u;
	                }
	                uint _20417 = 92337u + ((_12091 / 1194649u) % 1093u);
	                uint _16611 = _20417 / 2u;
	                uint _11852;
	                if ((_20417 & 1u) != 0u)
	                {
	                    _11852 = g_ScrambledHaltonPermutations.Load(_16611 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11852 = g_ScrambledHaltonPermutations.Load(_16611 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11578 * 1194649u) + (_11464 * 1093u)) + _11852) * 7.6584255603862061434483621269464e-10f;
	                _19095 = true;
	                break;
	            }
	            case 183u:
	            {
	                uint _15727 = 93430u + (_12091 % 1097u);
	                uint _16606 = _15727 / 2u;
	                uint _11577;
	                if ((_15727 & 1u) != 0u)
	                {
	                    _11577 = g_ScrambledHaltonPermutations.Load(_16606 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11577 = g_ScrambledHaltonPermutations.Load(_16606 * 4 + 0) & 65535u;
	                }
	                uint _20414 = 93430u + ((_12091 / 1097u) % 1097u);
	                uint _16607 = _20414 / 2u;
	                uint _11463;
	                if ((_20414 & 1u) != 0u)
	                {
	                    _11463 = g_ScrambledHaltonPermutations.Load(_16607 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11463 = g_ScrambledHaltonPermutations.Load(_16607 * 4 + 0) & 65535u;
	                }
	                uint _20415 = 93430u + ((_12091 / 1203409u) % 1097u);
	                uint _16608 = _20415 / 2u;
	                uint _11851;
	                if ((_20415 & 1u) != 0u)
	                {
	                    _11851 = g_ScrambledHaltonPermutations.Load(_16608 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11851 = g_ScrambledHaltonPermutations.Load(_16608 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11577 * 1203409u) + (_11463 * 1097u)) + _11851) * 7.5749551076143006866914220154285e-10f;
	                _19095 = true;
	                break;
	            }
	            case 184u:
	            {
	                uint _15726 = 94527u + (_12091 % 1103u);
	                uint _16603 = _15726 / 2u;
	                uint _11576;
	                if ((_15726 & 1u) != 0u)
	                {
	                    _11576 = g_ScrambledHaltonPermutations.Load(_16603 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11576 = g_ScrambledHaltonPermutations.Load(_16603 * 4 + 0) & 65535u;
	                }
	                uint _20412 = 94527u + ((_12091 / 1103u) % 1103u);
	                uint _16604 = _20412 / 2u;
	                uint _11462;
	                if ((_20412 & 1u) != 0u)
	                {
	                    _11462 = g_ScrambledHaltonPermutations.Load(_16604 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11462 = g_ScrambledHaltonPermutations.Load(_16604 * 4 + 0) & 65535u;
	                }
	                uint _20413 = 94527u + ((_12091 / 1216609u) % 1103u);
	                uint _16605 = _20413 / 2u;
	                uint _11850;
	                if ((_20413 & 1u) != 0u)
	                {
	                    _11850 = g_ScrambledHaltonPermutations.Load(_16605 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11850 = g_ScrambledHaltonPermutations.Load(_16605 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11576 * 1216609u) + (_11462 * 1103u)) + _11850) * 7.45200956497882316398317925632e-10f;
	                _19095 = true;
	                break;
	            }
	            case 185u:
	            {
	                uint _15725 = 95630u + (_12091 % 1109u);
	                uint _16600 = _15725 / 2u;
	                uint _11575;
	                if ((_15725 & 1u) != 0u)
	                {
	                    _11575 = g_ScrambledHaltonPermutations.Load(_16600 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11575 = g_ScrambledHaltonPermutations.Load(_16600 * 4 + 0) & 65535u;
	                }
	                uint _20410 = 95630u + ((_12091 / 1109u) % 1109u);
	                uint _16601 = _20410 / 2u;
	                uint _11461;
	                if ((_20410 & 1u) != 0u)
	                {
	                    _11461 = g_ScrambledHaltonPermutations.Load(_16601 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11461 = g_ScrambledHaltonPermutations.Load(_16601 * 4 + 0) & 65535u;
	                }
	                uint _20411 = 95630u + ((_12091 / 1229881u) % 1109u);
	                uint _16602 = _20411 / 2u;
	                uint _11849;
	                if ((_20411 & 1u) != 0u)
	                {
	                    _11849 = g_ScrambledHaltonPermutations.Load(_16602 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11849 = g_ScrambledHaltonPermutations.Load(_16602 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11575 * 1229881u) + (_11461 * 1109u)) + _11849) * 7.3317102389225397018890362232924e-10f;
	                _19095 = true;
	                break;
	            }
	            case 186u:
	            {
	                uint _15724 = 96739u + (_12091 % 1117u);
	                uint _16597 = _15724 / 2u;
	                uint _11574;
	                if ((_15724 & 1u) != 0u)
	                {
	                    _11574 = g_ScrambledHaltonPermutations.Load(_16597 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11574 = g_ScrambledHaltonPermutations.Load(_16597 * 4 + 0) & 65535u;
	                }
	                uint _20408 = 96739u + ((_12091 / 1117u) % 1117u);
	                uint _16598 = _20408 / 2u;
	                uint _11460;
	                if ((_20408 & 1u) != 0u)
	                {
	                    _11460 = g_ScrambledHaltonPermutations.Load(_16598 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11460 = g_ScrambledHaltonPermutations.Load(_16598 * 4 + 0) & 65535u;
	                }
	                uint _20409 = 96739u + ((_12091 / 1247689u) % 1117u);
	                uint _16599 = _20409 / 2u;
	                uint _11848;
	                if ((_20409 & 1u) != 0u)
	                {
	                    _11848 = g_ScrambledHaltonPermutations.Load(_16599 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11848 = g_ScrambledHaltonPermutations.Load(_16599 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11574 * 1247689u) + (_11460 * 1117u)) + _11848) * 7.1753059049939338365220464766026e-10f;
	                _19095 = true;
	                break;
	            }
	            case 187u:
	            {
	                uint _15723 = 97856u + (_12091 % 1123u);
	                uint _16594 = _15723 / 2u;
	                uint _11573;
	                if ((_15723 & 1u) != 0u)
	                {
	                    _11573 = g_ScrambledHaltonPermutations.Load(_16594 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11573 = g_ScrambledHaltonPermutations.Load(_16594 * 4 + 0) & 65535u;
	                }
	                uint _20406 = 97856u + ((_12091 / 1123u) % 1123u);
	                uint _16595 = _20406 / 2u;
	                uint _11459;
	                if ((_20406 & 1u) != 0u)
	                {
	                    _11459 = g_ScrambledHaltonPermutations.Load(_16595 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11459 = g_ScrambledHaltonPermutations.Load(_16595 * 4 + 0) & 65535u;
	                }
	                uint _20407 = 97856u + ((_12091 / 1261129u) % 1123u);
	                uint _16596 = _20407 / 2u;
	                uint _11847;
	                if ((_20407 & 1u) != 0u)
	                {
	                    _11847 = g_ScrambledHaltonPermutations.Load(_16596 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11847 = g_ScrambledHaltonPermutations.Load(_16596 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11573 * 1261129u) + (_11459 * 1123u)) + _11847) * 7.06091018987109464433160610497e-10f;
	                _19095 = true;
	                break;
	            }
	            case 188u:
	            {
	                uint _15722 = 98979u + (_12091 % 1129u);
	                uint _16591 = _15722 / 2u;
	                uint _11572;
	                if ((_15722 & 1u) != 0u)
	                {
	                    _11572 = g_ScrambledHaltonPermutations.Load(_16591 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11572 = g_ScrambledHaltonPermutations.Load(_16591 * 4 + 0) & 65535u;
	                }
	                uint _20404 = 98979u + ((_12091 / 1129u) % 1129u);
	                uint _16592 = _20404 / 2u;
	                uint _11458;
	                if ((_20404 & 1u) != 0u)
	                {
	                    _11458 = g_ScrambledHaltonPermutations.Load(_16592 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11458 = g_ScrambledHaltonPermutations.Load(_16592 * 4 + 0) & 65535u;
	                }
	                uint _20405 = 98979u + ((_12091 / 1274641u) % 1129u);
	                uint _16593 = _20405 / 2u;
	                uint _11846;
	                if ((_20405 & 1u) != 0u)
	                {
	                    _11846 = g_ScrambledHaltonPermutations.Load(_16593 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11846 = g_ScrambledHaltonPermutations.Load(_16593 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11572 * 1274641u) + (_11458 * 1129u)) + _11846) * 6.9489330956074013556644786149263e-10f;
	                _19095 = true;
	                break;
	            }
	            case 189u:
	            {
	                uint _15721 = 100108u + (_12091 % 1151u);
	                uint _16588 = _15721 / 2u;
	                uint _11571;
	                if ((_15721 & 1u) != 0u)
	                {
	                    _11571 = g_ScrambledHaltonPermutations.Load(_16588 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11571 = g_ScrambledHaltonPermutations.Load(_16588 * 4 + 0) & 65535u;
	                }
	                uint _20402 = 100108u + ((_12091 / 1151u) % 1151u);
	                uint _16589 = _20402 / 2u;
	                uint _11457;
	                if ((_20402 & 1u) != 0u)
	                {
	                    _11457 = g_ScrambledHaltonPermutations.Load(_16589 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11457 = g_ScrambledHaltonPermutations.Load(_16589 * 4 + 0) & 65535u;
	                }
	                uint _20403 = 100108u + ((_12091 / 1324801u) % 1151u);
	                uint _16590 = _20403 / 2u;
	                uint _11845;
	                if ((_20403 & 1u) != 0u)
	                {
	                    _11845 = g_ScrambledHaltonPermutations.Load(_16590 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11845 = g_ScrambledHaltonPermutations.Load(_16590 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11571 * 1324801u) + (_11457 * 1151u)) + _11845) * 6.5580385566477161773946136236191e-10f;
	                _19095 = true;
	                break;
	            }
	            case 190u:
	            {
	                uint _15720 = 101259u + (_12091 % 1153u);
	                uint _16585 = _15720 / 2u;
	                uint _11570;
	                if ((_15720 & 1u) != 0u)
	                {
	                    _11570 = g_ScrambledHaltonPermutations.Load(_16585 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11570 = g_ScrambledHaltonPermutations.Load(_16585 * 4 + 0) & 65535u;
	                }
	                uint _20400 = 101259u + ((_12091 / 1153u) % 1153u);
	                uint _16586 = _20400 / 2u;
	                uint _11456;
	                if ((_20400 & 1u) != 0u)
	                {
	                    _11456 = g_ScrambledHaltonPermutations.Load(_16586 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11456 = g_ScrambledHaltonPermutations.Load(_16586 * 4 + 0) & 65535u;
	                }
	                uint _20401 = 101259u + ((_12091 / 1329409u) % 1153u);
	                uint _16587 = _20401 / 2u;
	                uint _11844;
	                if ((_20401 & 1u) != 0u)
	                {
	                    _11844 = g_ScrambledHaltonPermutations.Load(_16587 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11844 = g_ScrambledHaltonPermutations.Load(_16587 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11570 * 1329409u) + (_11456 * 1153u)) + _11844) * 6.5239708080255809363734442740679e-10f;
	                _19095 = true;
	                break;
	            }
	            case 191u:
	            {
	                uint _15719 = 102412u + (_12091 % 1163u);
	                uint _16582 = _15719 / 2u;
	                uint _11569;
	                if ((_15719 & 1u) != 0u)
	                {
	                    _11569 = g_ScrambledHaltonPermutations.Load(_16582 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11569 = g_ScrambledHaltonPermutations.Load(_16582 * 4 + 0) & 65535u;
	                }
	                uint _20398 = 102412u + ((_12091 / 1163u) % 1163u);
	                uint _16583 = _20398 / 2u;
	                uint _11455;
	                if ((_20398 & 1u) != 0u)
	                {
	                    _11455 = g_ScrambledHaltonPermutations.Load(_16583 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11455 = g_ScrambledHaltonPermutations.Load(_16583 * 4 + 0) & 65535u;
	                }
	                uint _20399 = 102412u + ((_12091 / 1352569u) % 1163u);
	                uint _16584 = _20399 / 2u;
	                uint _11843;
	                if ((_20399 & 1u) != 0u)
	                {
	                    _11843 = g_ScrambledHaltonPermutations.Load(_16584 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11843 = g_ScrambledHaltonPermutations.Load(_16584 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11569 * 1352569u) + (_11455 * 1163u)) + _11843) * 6.3571259367734000989003106951714e-10f;
	                _19095 = true;
	                break;
	            }
	            case 192u:
	            {
	                uint _15718 = 103575u + (_12091 % 1171u);
	                uint _16579 = _15718 / 2u;
	                uint _11568;
	                if ((_15718 & 1u) != 0u)
	                {
	                    _11568 = g_ScrambledHaltonPermutations.Load(_16579 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11568 = g_ScrambledHaltonPermutations.Load(_16579 * 4 + 0) & 65535u;
	                }
	                uint _20396 = 103575u + ((_12091 / 1171u) % 1171u);
	                uint _16580 = _20396 / 2u;
	                uint _11454;
	                if ((_20396 & 1u) != 0u)
	                {
	                    _11454 = g_ScrambledHaltonPermutations.Load(_16580 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11454 = g_ScrambledHaltonPermutations.Load(_16580 * 4 + 0) & 65535u;
	                }
	                uint _20397 = 103575u + ((_12091 / 1371241u) % 1171u);
	                uint _16581 = _20397 / 2u;
	                uint _11842;
	                if ((_20397 & 1u) != 0u)
	                {
	                    _11842 = g_ScrambledHaltonPermutations.Load(_16581 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11842 = g_ScrambledHaltonPermutations.Load(_16581 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11568 * 1371241u) + (_11454 * 1171u)) + _11842) * 6.2277222268036780405964236706495e-10f;
	                _19095 = true;
	                break;
	            }
	            case 193u:
	            {
	                uint _15717 = 104746u + (_12091 % 1181u);
	                uint _16576 = _15717 / 2u;
	                uint _11567;
	                if ((_15717 & 1u) != 0u)
	                {
	                    _11567 = g_ScrambledHaltonPermutations.Load(_16576 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11567 = g_ScrambledHaltonPermutations.Load(_16576 * 4 + 0) & 65535u;
	                }
	                uint _20394 = 104746u + ((_12091 / 1181u) % 1181u);
	                uint _16577 = _20394 / 2u;
	                uint _11453;
	                if ((_20394 & 1u) != 0u)
	                {
	                    _11453 = g_ScrambledHaltonPermutations.Load(_16577 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11453 = g_ScrambledHaltonPermutations.Load(_16577 * 4 + 0) & 65535u;
	                }
	                uint _20395 = 104746u + ((_12091 / 1394761u) % 1181u);
	                uint _16578 = _20395 / 2u;
	                uint _11841;
	                if ((_20395 & 1u) != 0u)
	                {
	                    _11841 = g_ScrambledHaltonPermutations.Load(_16578 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11841 = g_ScrambledHaltonPermutations.Load(_16578 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11567 * 1394761u) + (_11453 * 1181u)) + _11841) * 6.0708604809889266107347793877125e-10f;
	                _19095 = true;
	                break;
	            }
	            case 194u:
	            {
	                uint _15716 = 105927u + (_12091 % 1187u);
	                uint _16573 = _15716 / 2u;
	                uint _11566;
	                if ((_15716 & 1u) != 0u)
	                {
	                    _11566 = g_ScrambledHaltonPermutations.Load(_16573 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11566 = g_ScrambledHaltonPermutations.Load(_16573 * 4 + 0) & 65535u;
	                }
	                uint _20392 = 105927u + ((_12091 / 1187u) % 1187u);
	                uint _16574 = _20392 / 2u;
	                uint _11452;
	                if ((_20392 & 1u) != 0u)
	                {
	                    _11452 = g_ScrambledHaltonPermutations.Load(_16574 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11452 = g_ScrambledHaltonPermutations.Load(_16574 * 4 + 0) & 65535u;
	                }
	                uint _20393 = 105927u + ((_12091 / 1408969u) % 1187u);
	                uint _16575 = _20393 / 2u;
	                uint _11840;
	                if ((_20393 & 1u) != 0u)
	                {
	                    _11840 = g_ScrambledHaltonPermutations.Load(_16575 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11840 = g_ScrambledHaltonPermutations.Load(_16575 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11566 * 1408969u) + (_11452 * 1187u)) + _11840) * 5.9792648610113019458367489278316e-10f;
	                _19095 = true;
	                break;
	            }
	            case 195u:
	            {
	                uint _15715 = 107114u + (_12091 % 1193u);
	                uint _16570 = _15715 / 2u;
	                uint _11565;
	                if ((_15715 & 1u) != 0u)
	                {
	                    _11565 = g_ScrambledHaltonPermutations.Load(_16570 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11565 = g_ScrambledHaltonPermutations.Load(_16570 * 4 + 0) & 65535u;
	                }
	                uint _20390 = 107114u + ((_12091 / 1193u) % 1193u);
	                uint _16571 = _20390 / 2u;
	                uint _11451;
	                if ((_20390 & 1u) != 0u)
	                {
	                    _11451 = g_ScrambledHaltonPermutations.Load(_16571 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11451 = g_ScrambledHaltonPermutations.Load(_16571 * 4 + 0) & 65535u;
	                }
	                uint _20391 = 107114u + ((_12091 / 1423249u) % 1193u);
	                uint _16572 = _20391 / 2u;
	                uint _11839;
	                if ((_20391 & 1u) != 0u)
	                {
	                    _11839 = g_ScrambledHaltonPermutations.Load(_16572 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11839 = g_ScrambledHaltonPermutations.Load(_16572 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11565 * 1423249u) + (_11451 * 1193u)) + _11839) * 5.8895027743588457269652280956507e-10f;
	                _19095 = true;
	                break;
	            }
	            case 196u:
	            {
	                uint _15714 = 108307u + (_12091 % 1201u);
	                uint _16567 = _15714 / 2u;
	                uint _11564;
	                if ((_15714 & 1u) != 0u)
	                {
	                    _11564 = g_ScrambledHaltonPermutations.Load(_16567 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11564 = g_ScrambledHaltonPermutations.Load(_16567 * 4 + 0) & 65535u;
	                }
	                uint _20388 = 108307u + ((_12091 / 1201u) % 1201u);
	                uint _16568 = _20388 / 2u;
	                uint _11450;
	                if ((_20388 & 1u) != 0u)
	                {
	                    _11450 = g_ScrambledHaltonPermutations.Load(_16568 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11450 = g_ScrambledHaltonPermutations.Load(_16568 * 4 + 0) & 65535u;
	                }
	                uint _20389 = 108307u + ((_12091 / 1442401u) % 1201u);
	                uint _16569 = _20389 / 2u;
	                uint _11838;
	                if ((_20389 & 1u) != 0u)
	                {
	                    _11838 = g_ScrambledHaltonPermutations.Load(_16569 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11838 = g_ScrambledHaltonPermutations.Load(_16569 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11564 * 1442401u) + (_11450 * 1201u)) + _11838) * 5.7725929591967428677889984101057e-10f;
	                _19095 = true;
	                break;
	            }
	            case 197u:
	            {
	                uint _15713 = 109508u + (_12091 % 1213u);
	                uint _16564 = _15713 / 2u;
	                uint _11563;
	                if ((_15713 & 1u) != 0u)
	                {
	                    _11563 = g_ScrambledHaltonPermutations.Load(_16564 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11563 = g_ScrambledHaltonPermutations.Load(_16564 * 4 + 0) & 65535u;
	                }
	                uint _20386 = 109508u + ((_12091 / 1213u) % 1213u);
	                uint _16565 = _20386 / 2u;
	                uint _11449;
	                if ((_20386 & 1u) != 0u)
	                {
	                    _11449 = g_ScrambledHaltonPermutations.Load(_16565 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11449 = g_ScrambledHaltonPermutations.Load(_16565 * 4 + 0) & 65535u;
	                }
	                uint _20387 = 109508u + ((_12091 / 1471369u) % 1213u);
	                uint _16566 = _20387 / 2u;
	                uint _11837;
	                if ((_20387 & 1u) != 0u)
	                {
	                    _11837 = g_ScrambledHaltonPermutations.Load(_16566 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11837 = g_ScrambledHaltonPermutations.Load(_16566 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11563 * 1471369u) + (_11449 * 1213u)) + _11837) * 5.6029603179297282622428610920906e-10f;
	                _19095 = true;
	                break;
	            }
	            case 198u:
	            {
	                uint _15712 = 110721u + (_12091 % 1217u);
	                uint _16561 = _15712 / 2u;
	                uint _11562;
	                if ((_15712 & 1u) != 0u)
	                {
	                    _11562 = g_ScrambledHaltonPermutations.Load(_16561 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11562 = g_ScrambledHaltonPermutations.Load(_16561 * 4 + 0) & 65535u;
	                }
	                uint _20384 = 110721u + ((_12091 / 1217u) % 1217u);
	                uint _16562 = _20384 / 2u;
	                uint _11448;
	                if ((_20384 & 1u) != 0u)
	                {
	                    _11448 = g_ScrambledHaltonPermutations.Load(_16562 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11448 = g_ScrambledHaltonPermutations.Load(_16562 * 4 + 0) & 65535u;
	                }
	                uint _20385 = 110721u + ((_12091 / 1481089u) % 1217u);
	                uint _16563 = _20385 / 2u;
	                uint _11836;
	                if ((_20385 & 1u) != 0u)
	                {
	                    _11836 = g_ScrambledHaltonPermutations.Load(_16563 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11836 = g_ScrambledHaltonPermutations.Load(_16563 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11562 * 1481089u) + (_11448 * 1217u)) + _11836) * 5.547894366131345122994389384985e-10f;
	                _19095 = true;
	                break;
	            }
	            case 199u:
	            {
	                uint _15711 = 111938u + (_12091 % 1223u);
	                uint _16558 = _15711 / 2u;
	                uint _11561;
	                if ((_15711 & 1u) != 0u)
	                {
	                    _11561 = g_ScrambledHaltonPermutations.Load(_16558 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11561 = g_ScrambledHaltonPermutations.Load(_16558 * 4 + 0) & 65535u;
	                }
	                uint _20382 = 111938u + ((_12091 / 1223u) % 1223u);
	                uint _16559 = _20382 / 2u;
	                uint _11447;
	                if ((_20382 & 1u) != 0u)
	                {
	                    _11447 = g_ScrambledHaltonPermutations.Load(_16559 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11447 = g_ScrambledHaltonPermutations.Load(_16559 * 4 + 0) & 65535u;
	                }
	                uint _20383 = 111938u + ((_12091 / 1495729u) % 1223u);
	                uint _16560 = _20383 / 2u;
	                uint _11835;
	                if ((_20383 & 1u) != 0u)
	                {
	                    _11835 = g_ScrambledHaltonPermutations.Load(_16560 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11835 = g_ScrambledHaltonPermutations.Load(_16560 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11561 * 1495729u) + (_11447 * 1223u)) + _11835) * 5.4666415838511284164269454777241e-10f;
	                _19095 = true;
	                break;
	            }
	            case 200u:
	            {
	                uint _15710 = 113161u + (_12091 % 1229u);
	                uint _16555 = _15710 / 2u;
	                uint _11560;
	                if ((_15710 & 1u) != 0u)
	                {
	                    _11560 = g_ScrambledHaltonPermutations.Load(_16555 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11560 = g_ScrambledHaltonPermutations.Load(_16555 * 4 + 0) & 65535u;
	                }
	                uint _20380 = 113161u + ((_12091 / 1229u) % 1229u);
	                uint _16556 = _20380 / 2u;
	                uint _11446;
	                if ((_20380 & 1u) != 0u)
	                {
	                    _11446 = g_ScrambledHaltonPermutations.Load(_16556 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11446 = g_ScrambledHaltonPermutations.Load(_16556 * 4 + 0) & 65535u;
	                }
	                uint _20381 = 113161u + ((_12091 / 1510441u) % 1229u);
	                uint _16557 = _20381 / 2u;
	                uint _11834;
	                if ((_20381 & 1u) != 0u)
	                {
	                    _11834 = g_ScrambledHaltonPermutations.Load(_16557 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11834 = g_ScrambledHaltonPermutations.Load(_16557 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11560 * 1510441u) + (_11446 * 1229u)) + _11834) * 5.3869664284889040573034435510635e-10f;
	                _19095 = true;
	                break;
	            }
	            case 201u:
	            {
	                uint _15709 = 114390u + (_12091 % 1231u);
	                uint _16552 = _15709 / 2u;
	                uint _11559;
	                if ((_15709 & 1u) != 0u)
	                {
	                    _11559 = g_ScrambledHaltonPermutations.Load(_16552 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11559 = g_ScrambledHaltonPermutations.Load(_16552 * 4 + 0) & 65535u;
	                }
	                uint _20378 = 114390u + ((_12091 / 1231u) % 1231u);
	                uint _16553 = _20378 / 2u;
	                uint _11445;
	                if ((_20378 & 1u) != 0u)
	                {
	                    _11445 = g_ScrambledHaltonPermutations.Load(_16553 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11445 = g_ScrambledHaltonPermutations.Load(_16553 * 4 + 0) & 65535u;
	                }
	                uint _20379 = 114390u + ((_12091 / 1515361u) % 1231u);
	                uint _16554 = _20379 / 2u;
	                uint _11833;
	                if ((_20379 & 1u) != 0u)
	                {
	                    _11833 = g_ScrambledHaltonPermutations.Load(_16554 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11833 = g_ScrambledHaltonPermutations.Load(_16554 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11559 * 1515361u) + (_11445 * 1231u)) + _11833) * 5.3607529526544794862275011837482e-10f;
	                _19095 = true;
	                break;
	            }
	            case 202u:
	            {
	                uint _15708 = 115621u + (_12091 % 1237u);
	                uint _16549 = _15708 / 2u;
	                uint _11558;
	                if ((_15708 & 1u) != 0u)
	                {
	                    _11558 = g_ScrambledHaltonPermutations.Load(_16549 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11558 = g_ScrambledHaltonPermutations.Load(_16549 * 4 + 0) & 65535u;
	                }
	                uint _20376 = 115621u + ((_12091 / 1237u) % 1237u);
	                uint _16550 = _20376 / 2u;
	                uint _11444;
	                if ((_20376 & 1u) != 0u)
	                {
	                    _11444 = g_ScrambledHaltonPermutations.Load(_16550 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11444 = g_ScrambledHaltonPermutations.Load(_16550 * 4 + 0) & 65535u;
	                }
	                uint _20377 = 115621u + ((_12091 / 1530169u) % 1237u);
	                uint _16551 = _20377 / 2u;
	                uint _11832;
	                if ((_20377 & 1u) != 0u)
	                {
	                    _11832 = g_ScrambledHaltonPermutations.Load(_16551 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11832 = g_ScrambledHaltonPermutations.Load(_16551 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11558 * 1530169u) + (_11444 * 1237u)) + _11832) * 5.2831244934381516031862702220678e-10f;
	                _19095 = true;
	                break;
	            }
	            case 203u:
	            {
	                uint _15707 = 116858u + (_12091 % 1249u);
	                uint _16546 = _15707 / 2u;
	                uint _11557;
	                if ((_15707 & 1u) != 0u)
	                {
	                    _11557 = g_ScrambledHaltonPermutations.Load(_16546 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11557 = g_ScrambledHaltonPermutations.Load(_16546 * 4 + 0) & 65535u;
	                }
	                uint _20374 = 116858u + ((_12091 / 1249u) % 1249u);
	                uint _16547 = _20374 / 2u;
	                uint _11443;
	                if ((_20374 & 1u) != 0u)
	                {
	                    _11443 = g_ScrambledHaltonPermutations.Load(_16547 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11443 = g_ScrambledHaltonPermutations.Load(_16547 * 4 + 0) & 65535u;
	                }
	                uint _20375 = 116858u + ((_12091 / 1560001u) % 1249u);
	                uint _16548 = _20375 / 2u;
	                uint _11831;
	                if ((_20375 & 1u) != 0u)
	                {
	                    _11831 = g_ScrambledHaltonPermutations.Load(_16548 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11831 = g_ScrambledHaltonPermutations.Load(_16548 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11557 * 1560001u) + (_11443 * 1249u)) + _11831) * 5.1323073568809718381089624017477e-10f;
	                _19095 = true;
	                break;
	            }
	            case 204u:
	            {
	                uint _15706 = 118107u + (_12091 % 1259u);
	                uint _16543 = _15706 / 2u;
	                uint _11556;
	                if ((_15706 & 1u) != 0u)
	                {
	                    _11556 = g_ScrambledHaltonPermutations.Load(_16543 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11556 = g_ScrambledHaltonPermutations.Load(_16543 * 4 + 0) & 65535u;
	                }
	                uint _20372 = 118107u + ((_12091 / 1259u) % 1259u);
	                uint _16544 = _20372 / 2u;
	                uint _11442;
	                if ((_20372 & 1u) != 0u)
	                {
	                    _11442 = g_ScrambledHaltonPermutations.Load(_16544 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11442 = g_ScrambledHaltonPermutations.Load(_16544 * 4 + 0) & 65535u;
	                }
	                uint _20373 = 118107u + ((_12091 / 1585081u) % 1259u);
	                uint _16545 = _20373 / 2u;
	                uint _11830;
	                if ((_20373 & 1u) != 0u)
	                {
	                    _11830 = g_ScrambledHaltonPermutations.Load(_16545 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11830 = g_ScrambledHaltonPermutations.Load(_16545 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11556 * 1585081u) + (_11442 * 1259u)) + _11830) * 5.0109810745269101062149275094271e-10f;
	                _19095 = true;
	                break;
	            }
	            case 205u:
	            {
	                uint _15705 = 119366u + (_12091 % 1277u);
	                uint _16540 = _15705 / 2u;
	                uint _11555;
	                if ((_15705 & 1u) != 0u)
	                {
	                    _11555 = g_ScrambledHaltonPermutations.Load(_16540 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11555 = g_ScrambledHaltonPermutations.Load(_16540 * 4 + 0) & 65535u;
	                }
	                uint _20370 = 119366u + ((_12091 / 1277u) % 1277u);
	                uint _16541 = _20370 / 2u;
	                uint _11441;
	                if ((_20370 & 1u) != 0u)
	                {
	                    _11441 = g_ScrambledHaltonPermutations.Load(_16541 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11441 = g_ScrambledHaltonPermutations.Load(_16541 * 4 + 0) & 65535u;
	                }
	                uint _20371 = 119366u + ((_12091 / 1630729u) % 1277u);
	                uint _16542 = _20371 / 2u;
	                uint _11829;
	                if ((_20371 & 1u) != 0u)
	                {
	                    _11829 = g_ScrambledHaltonPermutations.Load(_16542 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11829 = g_ScrambledHaltonPermutations.Load(_16542 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11555 * 1630729u) + (_11441 * 1277u)) + _11829) * 4.8020565301953865855466574430466e-10f;
	                _19095 = true;
	                break;
	            }
	            case 206u:
	            {
	                uint _15704 = 120643u + (_12091 % 1279u);
	                uint _16537 = _15704 / 2u;
	                uint _11554;
	                if ((_15704 & 1u) != 0u)
	                {
	                    _11554 = g_ScrambledHaltonPermutations.Load(_16537 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11554 = g_ScrambledHaltonPermutations.Load(_16537 * 4 + 0) & 65535u;
	                }
	                uint _20368 = 120643u + ((_12091 / 1279u) % 1279u);
	                uint _16538 = _20368 / 2u;
	                uint _11440;
	                if ((_20368 & 1u) != 0u)
	                {
	                    _11440 = g_ScrambledHaltonPermutations.Load(_16538 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11440 = g_ScrambledHaltonPermutations.Load(_16538 * 4 + 0) & 65535u;
	                }
	                uint _20369 = 120643u + ((_12091 / 1635841u) % 1279u);
	                uint _16539 = _20369 / 2u;
	                uint _11828;
	                if ((_20369 & 1u) != 0u)
	                {
	                    _11828 = g_ScrambledHaltonPermutations.Load(_16539 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11828 = g_ScrambledHaltonPermutations.Load(_16539 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11554 * 1635841u) + (_11440 * 1279u)) + _11828) * 4.7795645219395055391942150890827e-10f;
	                _19095 = true;
	                break;
	            }
	            case 207u:
	            {
	                uint _15703 = 121922u + (_12091 % 1283u);
	                uint _16534 = _15703 / 2u;
	                uint _11553;
	                if ((_15703 & 1u) != 0u)
	                {
	                    _11553 = g_ScrambledHaltonPermutations.Load(_16534 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11553 = g_ScrambledHaltonPermutations.Load(_16534 * 4 + 0) & 65535u;
	                }
	                uint _20366 = 121922u + ((_12091 / 1283u) % 1283u);
	                uint _16535 = _20366 / 2u;
	                uint _11439;
	                if ((_20366 & 1u) != 0u)
	                {
	                    _11439 = g_ScrambledHaltonPermutations.Load(_16535 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11439 = g_ScrambledHaltonPermutations.Load(_16535 * 4 + 0) & 65535u;
	                }
	                uint _20367 = 121922u + ((_12091 / 1646089u) % 1283u);
	                uint _16536 = _20367 / 2u;
	                uint _11827;
	                if ((_20367 & 1u) != 0u)
	                {
	                    _11827 = g_ScrambledHaltonPermutations.Load(_16536 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11827 = g_ScrambledHaltonPermutations.Load(_16536 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11553 * 1646089u) + (_11439 * 1283u)) + _11827) * 4.7350001697310517556616105139256e-10f;
	                _19095 = true;
	                break;
	            }
	            case 208u:
	            {
	                uint _15702 = 123205u + (_12091 % 1289u);
	                uint _16531 = _15702 / 2u;
	                uint _11552;
	                if ((_15702 & 1u) != 0u)
	                {
	                    _11552 = g_ScrambledHaltonPermutations.Load(_16531 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11552 = g_ScrambledHaltonPermutations.Load(_16531 * 4 + 0) & 65535u;
	                }
	                uint _20364 = 123205u + ((_12091 / 1289u) % 1289u);
	                uint _16532 = _20364 / 2u;
	                uint _11438;
	                if ((_20364 & 1u) != 0u)
	                {
	                    _11438 = g_ScrambledHaltonPermutations.Load(_16532 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11438 = g_ScrambledHaltonPermutations.Load(_16532 * 4 + 0) & 65535u;
	                }
	                uint _20365 = 123205u + ((_12091 / 1661521u) % 1289u);
	                uint _16533 = _20365 / 2u;
	                uint _11826;
	                if ((_20365 & 1u) != 0u)
	                {
	                    _11826 = g_ScrambledHaltonPermutations.Load(_16533 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11826 = g_ScrambledHaltonPermutations.Load(_16533 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11552 * 1661521u) + (_11438 * 1289u)) + _11826) * 4.6691861488312724759452976286411e-10f;
	                _19095 = true;
	                break;
	            }
	            case 209u:
	            {
	                uint _15701 = 124494u + (_12091 % 1291u);
	                uint _16528 = _15701 / 2u;
	                uint _11551;
	                if ((_15701 & 1u) != 0u)
	                {
	                    _11551 = g_ScrambledHaltonPermutations.Load(_16528 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11551 = g_ScrambledHaltonPermutations.Load(_16528 * 4 + 0) & 65535u;
	                }
	                uint _20362 = 124494u + ((_12091 / 1291u) % 1291u);
	                uint _16529 = _20362 / 2u;
	                uint _11437;
	                if ((_20362 & 1u) != 0u)
	                {
	                    _11437 = g_ScrambledHaltonPermutations.Load(_16529 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11437 = g_ScrambledHaltonPermutations.Load(_16529 * 4 + 0) & 65535u;
	                }
	                uint _20363 = 124494u + ((_12091 / 1666681u) % 1291u);
	                uint _16530 = _20363 / 2u;
	                uint _11825;
	                if ((_20363 & 1u) != 0u)
	                {
	                    _11825 = g_ScrambledHaltonPermutations.Load(_16530 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11825 = g_ScrambledHaltonPermutations.Load(_16530 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11551 * 1666681u) + (_11437 * 1291u)) + _11825) * 4.6475195913942002334806602448225e-10f;
	                _19095 = true;
	                break;
	            }
	            case 210u:
	            {
	                uint _15700 = 125785u + (_12091 % 1297u);
	                uint _16525 = _15700 / 2u;
	                uint _11550;
	                if ((_15700 & 1u) != 0u)
	                {
	                    _11550 = g_ScrambledHaltonPermutations.Load(_16525 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11550 = g_ScrambledHaltonPermutations.Load(_16525 * 4 + 0) & 65535u;
	                }
	                uint _20360 = 125785u + ((_12091 / 1297u) % 1297u);
	                uint _16526 = _20360 / 2u;
	                uint _11436;
	                if ((_20360 & 1u) != 0u)
	                {
	                    _11436 = g_ScrambledHaltonPermutations.Load(_16526 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11436 = g_ScrambledHaltonPermutations.Load(_16526 * 4 + 0) & 65535u;
	                }
	                uint _20361 = 125785u + ((_12091 / 1682209u) % 1297u);
	                uint _16527 = _20361 / 2u;
	                uint _11824;
	                if ((_20361 & 1u) != 0u)
	                {
	                    _11824 = g_ScrambledHaltonPermutations.Load(_16527 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11824 = g_ScrambledHaltonPermutations.Load(_16527 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11550 * 1682209u) + (_11436 * 1297u)) + _11824) * 4.5833184469934451499284477904439e-10f;
	                _19095 = true;
	                break;
	            }
	            case 211u:
	            {
	                uint _15699 = 127082u + (_12091 % 1301u);
	                uint _16522 = _15699 / 2u;
	                uint _11549;
	                if ((_15699 & 1u) != 0u)
	                {
	                    _11549 = g_ScrambledHaltonPermutations.Load(_16522 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11549 = g_ScrambledHaltonPermutations.Load(_16522 * 4 + 0) & 65535u;
	                }
	                uint _20358 = 127082u + ((_12091 / 1301u) % 1301u);
	                uint _16523 = _20358 / 2u;
	                uint _11435;
	                if ((_20358 & 1u) != 0u)
	                {
	                    _11435 = g_ScrambledHaltonPermutations.Load(_16523 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11435 = g_ScrambledHaltonPermutations.Load(_16523 * 4 + 0) & 65535u;
	                }
	                uint _20359 = 127082u + ((_12091 / 1692601u) % 1301u);
	                uint _16524 = _20359 / 2u;
	                uint _11823;
	                if ((_20359 & 1u) != 0u)
	                {
	                    _11823 = g_ScrambledHaltonPermutations.Load(_16524 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11823 = g_ScrambledHaltonPermutations.Load(_16524 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11549 * 1692601u) + (_11435 * 1301u)) + _11823) * 4.5411732707556495824974263086915e-10f;
	                _19095 = true;
	                break;
	            }
	            case 212u:
	            {
	                uint _15698 = 128383u + (_12091 % 1303u);
	                uint _16519 = _15698 / 2u;
	                uint _11548;
	                if ((_15698 & 1u) != 0u)
	                {
	                    _11548 = g_ScrambledHaltonPermutations.Load(_16519 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11548 = g_ScrambledHaltonPermutations.Load(_16519 * 4 + 0) & 65535u;
	                }
	                uint _20356 = 128383u + ((_12091 / 1303u) % 1303u);
	                uint _16520 = _20356 / 2u;
	                uint _11434;
	                if ((_20356 & 1u) != 0u)
	                {
	                    _11434 = g_ScrambledHaltonPermutations.Load(_16520 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11434 = g_ScrambledHaltonPermutations.Load(_16520 * 4 + 0) & 65535u;
	                }
	                uint _20357 = 128383u + ((_12091 / 1697809u) % 1303u);
	                uint _16521 = _20357 / 2u;
	                uint _11822;
	                if ((_20357 & 1u) != 0u)
	                {
	                    _11822 = g_ScrambledHaltonPermutations.Load(_16521 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11822 = g_ScrambledHaltonPermutations.Load(_16521 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11548 * 1697809u) + (_11434 * 1303u)) + _11822) * 4.5202938614430365760199492797256e-10f;
	                _19095 = true;
	                break;
	            }
	            case 213u:
	            {
	                uint _15697 = 129686u + (_12091 % 1307u);
	                uint _16516 = _15697 / 2u;
	                uint _11547;
	                if ((_15697 & 1u) != 0u)
	                {
	                    _11547 = g_ScrambledHaltonPermutations.Load(_16516 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11547 = g_ScrambledHaltonPermutations.Load(_16516 * 4 + 0) & 65535u;
	                }
	                uint _20354 = 129686u + ((_12091 / 1307u) % 1307u);
	                uint _16517 = _20354 / 2u;
	                uint _11433;
	                if ((_20354 & 1u) != 0u)
	                {
	                    _11433 = g_ScrambledHaltonPermutations.Load(_16517 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11433 = g_ScrambledHaltonPermutations.Load(_16517 * 4 + 0) & 65535u;
	                }
	                uint _20355 = 129686u + ((_12091 / 1708249u) % 1307u);
	                uint _16518 = _20355 / 2u;
	                uint _11821;
	                if ((_20355 & 1u) != 0u)
	                {
	                    _11821 = g_ScrambledHaltonPermutations.Load(_16518 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11821 = g_ScrambledHaltonPermutations.Load(_16518 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11547 * 1708249u) + (_11433 * 1307u)) + _11821) * 4.478918624872818554649711586535e-10f;
	                _19095 = true;
	                break;
	            }
	            case 214u:
	            {
	                uint _15696 = 130993u + (_12091 % 1319u);
	                uint _16513 = _15696 / 2u;
	                uint _11546;
	                if ((_15696 & 1u) != 0u)
	                {
	                    _11546 = g_ScrambledHaltonPermutations.Load(_16513 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11546 = g_ScrambledHaltonPermutations.Load(_16513 * 4 + 0) & 65535u;
	                }
	                uint _20352 = 130993u + ((_12091 / 1319u) % 1319u);
	                uint _16514 = _20352 / 2u;
	                uint _11432;
	                if ((_20352 & 1u) != 0u)
	                {
	                    _11432 = g_ScrambledHaltonPermutations.Load(_16514 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11432 = g_ScrambledHaltonPermutations.Load(_16514 * 4 + 0) & 65535u;
	                }
	                uint _20353 = 130993u + ((_12091 / 1739761u) % 1319u);
	                uint _16515 = _20353 / 2u;
	                uint _11820;
	                if ((_20353 & 1u) != 0u)
	                {
	                    _11820 = g_ScrambledHaltonPermutations.Load(_16515 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11820 = g_ScrambledHaltonPermutations.Load(_16515 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11546 * 1739761u) + (_11432 * 1319u)) + _11820) * 4.3577824682117238808132242411375e-10f;
	                _19095 = true;
	                break;
	            }
	            case 215u:
	            {
	                uint _15695 = 132312u + (_12091 % 1321u);
	                uint _16510 = _15695 / 2u;
	                uint _11545;
	                if ((_15695 & 1u) != 0u)
	                {
	                    _11545 = g_ScrambledHaltonPermutations.Load(_16510 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11545 = g_ScrambledHaltonPermutations.Load(_16510 * 4 + 0) & 65535u;
	                }
	                uint _20349 = 132312u + ((_12091 / 1321u) % 1321u);
	                uint _16511 = _20349 / 2u;
	                uint _11431;
	                if ((_20349 & 1u) != 0u)
	                {
	                    _11431 = g_ScrambledHaltonPermutations.Load(_16511 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11431 = g_ScrambledHaltonPermutations.Load(_16511 * 4 + 0) & 65535u;
	                }
	                uint _20350 = 132312u + ((_12091 / 1745041u) % 1321u);
	                uint _16512 = _20350 / 2u;
	                uint _11819;
	                if ((_20350 & 1u) != 0u)
	                {
	                    _11819 = g_ScrambledHaltonPermutations.Load(_16512 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11819 = g_ScrambledHaltonPermutations.Load(_16512 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11545 * 1745041u) + (_11431 * 1321u)) + _11819) * 4.3380196657061276255262782797217e-10f;
	                _19095 = true;
	                break;
	            }
	            case 216u:
	            {
	                uint _15694 = 133633u + (_12091 % 1327u);
	                uint _16507 = _15694 / 2u;
	                uint _11544;
	                if ((_15694 & 1u) != 0u)
	                {
	                    _11544 = g_ScrambledHaltonPermutations.Load(_16507 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11544 = g_ScrambledHaltonPermutations.Load(_16507 * 4 + 0) & 65535u;
	                }
	                uint _20347 = 133633u + ((_12091 / 1327u) % 1327u);
	                uint _16508 = _20347 / 2u;
	                uint _11430;
	                if ((_20347 & 1u) != 0u)
	                {
	                    _11430 = g_ScrambledHaltonPermutations.Load(_16508 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11430 = g_ScrambledHaltonPermutations.Load(_16508 * 4 + 0) & 65535u;
	                }
	                uint _20348 = 133633u + ((_12091 / 1760929u) % 1327u);
	                uint _16509 = _20348 / 2u;
	                uint _11818;
	                if ((_20348 & 1u) != 0u)
	                {
	                    _11818 = g_ScrambledHaltonPermutations.Load(_16509 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11818 = g_ScrambledHaltonPermutations.Load(_16509 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11544 * 1760929u) + (_11430 * 1327u)) + _11818) * 4.2794420784808551161404466256499e-10f;
	                _19095 = true;
	                break;
	            }
	            case 217u:
	            {
	                uint _15693 = 134960u + (_12091 % 1361u);
	                uint _16504 = _15693 / 2u;
	                uint _11543;
	                if ((_15693 & 1u) != 0u)
	                {
	                    _11543 = g_ScrambledHaltonPermutations.Load(_16504 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11543 = g_ScrambledHaltonPermutations.Load(_16504 * 4 + 0) & 65535u;
	                }
	                uint _20345 = 134960u + ((_12091 / 1361u) % 1361u);
	                uint _16505 = _20345 / 2u;
	                uint _11429;
	                if ((_20345 & 1u) != 0u)
	                {
	                    _11429 = g_ScrambledHaltonPermutations.Load(_16505 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11429 = g_ScrambledHaltonPermutations.Load(_16505 * 4 + 0) & 65535u;
	                }
	                uint _20346 = 134960u + ((_12091 / 1852321u) % 1361u);
	                uint _16506 = _20346 / 2u;
	                uint _11817;
	                if ((_20346 & 1u) != 0u)
	                {
	                    _11817 = g_ScrambledHaltonPermutations.Load(_16506 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11817 = g_ScrambledHaltonPermutations.Load(_16506 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11543 * 1852321u) + (_11429 * 1361u)) + _11817) * 3.9666653295356013586570043116808e-10f;
	                _19095 = true;
	                break;
	            }
	            case 218u:
	            {
	                uint _15692 = 136321u + (_12091 % 1367u);
	                uint _16501 = _15692 / 2u;
	                uint _11542;
	                if ((_15692 & 1u) != 0u)
	                {
	                    _11542 = g_ScrambledHaltonPermutations.Load(_16501 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11542 = g_ScrambledHaltonPermutations.Load(_16501 * 4 + 0) & 65535u;
	                }
	                uint _20343 = 136321u + ((_12091 / 1367u) % 1367u);
	                uint _16502 = _20343 / 2u;
	                uint _11428;
	                if ((_20343 & 1u) != 0u)
	                {
	                    _11428 = g_ScrambledHaltonPermutations.Load(_16502 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11428 = g_ScrambledHaltonPermutations.Load(_16502 * 4 + 0) & 65535u;
	                }
	                uint _20344 = 136321u + ((_12091 / 1868689u) % 1367u);
	                uint _16503 = _20344 / 2u;
	                uint _11816;
	                if ((_20344 & 1u) != 0u)
	                {
	                    _11816 = g_ScrambledHaltonPermutations.Load(_16503 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11816 = g_ScrambledHaltonPermutations.Load(_16503 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11542 * 1868689u) + (_11428 * 1367u)) + _11816) * 3.9146633157294274951709667220712e-10f;
	                _19095 = true;
	                break;
	            }
	            case 219u:
	            {
	                uint _15691 = 137688u + (_12091 % 1373u);
	                uint _16498 = _15691 / 2u;
	                uint _11541;
	                if ((_15691 & 1u) != 0u)
	                {
	                    _11541 = g_ScrambledHaltonPermutations.Load(_16498 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11541 = g_ScrambledHaltonPermutations.Load(_16498 * 4 + 0) & 65535u;
	                }
	                uint _20341 = 137688u + ((_12091 / 1373u) % 1373u);
	                uint _16499 = _20341 / 2u;
	                uint _11427;
	                if ((_20341 & 1u) != 0u)
	                {
	                    _11427 = g_ScrambledHaltonPermutations.Load(_16499 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11427 = g_ScrambledHaltonPermutations.Load(_16499 * 4 + 0) & 65535u;
	                }
	                uint _20342 = 137688u + ((_12091 / 1885129u) % 1373u);
	                uint _16500 = _20342 / 2u;
	                uint _11815;
	                if ((_20342 & 1u) != 0u)
	                {
	                    _11815 = g_ScrambledHaltonPermutations.Load(_16500 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11815 = g_ScrambledHaltonPermutations.Load(_16500 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11541 * 1885129u) + (_11427 * 1373u)) + _11815) * 3.863566133688323134265374392271e-10f;
	                _19095 = true;
	                break;
	            }
	            case 220u:
	            {
	                uint _15690 = 139061u + (_12091 % 1381u);
	                uint _16495 = _15690 / 2u;
	                uint _11540;
	                if ((_15690 & 1u) != 0u)
	                {
	                    _11540 = g_ScrambledHaltonPermutations.Load(_16495 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11540 = g_ScrambledHaltonPermutations.Load(_16495 * 4 + 0) & 65535u;
	                }
	                uint _20339 = 139061u + ((_12091 / 1381u) % 1381u);
	                uint _16496 = _20339 / 2u;
	                uint _11426;
	                if ((_20339 & 1u) != 0u)
	                {
	                    _11426 = g_ScrambledHaltonPermutations.Load(_16496 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11426 = g_ScrambledHaltonPermutations.Load(_16496 * 4 + 0) & 65535u;
	                }
	                uint _20340 = 139061u + ((_12091 / 1907161u) % 1381u);
	                uint _16497 = _20340 / 2u;
	                uint _11814;
	                if ((_20340 & 1u) != 0u)
	                {
	                    _11814 = g_ScrambledHaltonPermutations.Load(_16497 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11814 = g_ScrambledHaltonPermutations.Load(_16497 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11540 * 1907161u) + (_11426 * 1381u)) + _11814) * 3.7968103661079055655136471614242e-10f;
	                _19095 = true;
	                break;
	            }
	            case 221u:
	            {
	                uint _15689 = 140442u + (_12091 % 1399u);
	                uint _16492 = _15689 / 2u;
	                uint _11539;
	                if ((_15689 & 1u) != 0u)
	                {
	                    _11539 = g_ScrambledHaltonPermutations.Load(_16492 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11539 = g_ScrambledHaltonPermutations.Load(_16492 * 4 + 0) & 65535u;
	                }
	                uint _20337 = 140442u + ((_12091 / 1399u) % 1399u);
	                uint _16493 = _20337 / 2u;
	                uint _11425;
	                if ((_20337 & 1u) != 0u)
	                {
	                    _11425 = g_ScrambledHaltonPermutations.Load(_16493 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11425 = g_ScrambledHaltonPermutations.Load(_16493 * 4 + 0) & 65535u;
	                }
	                uint _20338 = 140442u + ((_12091 / 1957201u) % 1399u);
	                uint _16494 = _20338 / 2u;
	                uint _11813;
	                if ((_20338 & 1u) != 0u)
	                {
	                    _11813 = g_ScrambledHaltonPermutations.Load(_16494 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11813 = g_ScrambledHaltonPermutations.Load(_16494 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11539 * 1957201u) + (_11425 * 1399u)) + _11813) * 3.652134705767196010128827765584e-10f;
	                _19095 = true;
	                break;
	            }
	            case 222u:
	            {
	                uint _15688 = 141841u + (_12091 % 1409u);
	                uint _16489 = _15688 / 2u;
	                uint _11538;
	                if ((_15688 & 1u) != 0u)
	                {
	                    _11538 = g_ScrambledHaltonPermutations.Load(_16489 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11538 = g_ScrambledHaltonPermutations.Load(_16489 * 4 + 0) & 65535u;
	                }
	                uint _20335 = 141841u + ((_12091 / 1409u) % 1409u);
	                uint _16490 = _20335 / 2u;
	                uint _11424;
	                if ((_20335 & 1u) != 0u)
	                {
	                    _11424 = g_ScrambledHaltonPermutations.Load(_16490 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11424 = g_ScrambledHaltonPermutations.Load(_16490 * 4 + 0) & 65535u;
	                }
	                uint _20336 = 141841u + ((_12091 / 1985281u) % 1409u);
	                uint _16491 = _20336 / 2u;
	                uint _11812;
	                if ((_20336 & 1u) != 0u)
	                {
	                    _11812 = g_ScrambledHaltonPermutations.Load(_16491 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11812 = g_ScrambledHaltonPermutations.Load(_16491 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11538 * 1985281u) + (_11424 * 1409u)) + _11812) * 3.5749250781869079673924716189504e-10f;
	                _19095 = true;
	                break;
	            }
	            case 223u:
	            {
	                uint _15687 = 143250u + (_12091 % 1423u);
	                uint _16486 = _15687 / 2u;
	                uint _11537;
	                if ((_15687 & 1u) != 0u)
	                {
	                    _11537 = g_ScrambledHaltonPermutations.Load(_16486 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11537 = g_ScrambledHaltonPermutations.Load(_16486 * 4 + 0) & 65535u;
	                }
	                uint _20333 = 143250u + ((_12091 / 1423u) % 1423u);
	                uint _16487 = _20333 / 2u;
	                uint _11423;
	                if ((_20333 & 1u) != 0u)
	                {
	                    _11423 = g_ScrambledHaltonPermutations.Load(_16487 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11423 = g_ScrambledHaltonPermutations.Load(_16487 * 4 + 0) & 65535u;
	                }
	                uint _20334 = 143250u + ((_12091 / 2024929u) % 1423u);
	                uint _16488 = _20334 / 2u;
	                uint _11811;
	                if ((_20334 & 1u) != 0u)
	                {
	                    _11811 = g_ScrambledHaltonPermutations.Load(_16488 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11811 = g_ScrambledHaltonPermutations.Load(_16488 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11537 * 2024929u) + (_11423 * 1423u)) + _11811) * 3.4704455975642645171319600194693e-10f;
	                _19095 = true;
	                break;
	            }
	            case 224u:
	            {
	                uint _15686 = 144673u + (_12091 % 1427u);
	                uint _16483 = _15686 / 2u;
	                uint _11536;
	                if ((_15686 & 1u) != 0u)
	                {
	                    _11536 = g_ScrambledHaltonPermutations.Load(_16483 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11536 = g_ScrambledHaltonPermutations.Load(_16483 * 4 + 0) & 65535u;
	                }
	                uint _20331 = 144673u + ((_12091 / 1427u) % 1427u);
	                uint _16484 = _20331 / 2u;
	                uint _11422;
	                if ((_20331 & 1u) != 0u)
	                {
	                    _11422 = g_ScrambledHaltonPermutations.Load(_16484 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11422 = g_ScrambledHaltonPermutations.Load(_16484 * 4 + 0) & 65535u;
	                }
	                uint _20332 = 144673u + ((_12091 / 2036329u) % 1427u);
	                uint _16485 = _20332 / 2u;
	                uint _11810;
	                if ((_20332 & 1u) != 0u)
	                {
	                    _11810 = g_ScrambledHaltonPermutations.Load(_16485 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11810 = g_ScrambledHaltonPermutations.Load(_16485 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11536 * 2036329u) + (_11422 * 1427u)) + _11810) * 3.4413435989755214450269704684615e-10f;
	                _19095 = true;
	                break;
	            }
	            case 225u:
	            {
	                uint _15685 = 146100u + (_12091 % 1429u);
	                uint _16480 = _15685 / 2u;
	                uint _11535;
	                if ((_15685 & 1u) != 0u)
	                {
	                    _11535 = g_ScrambledHaltonPermutations.Load(_16480 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11535 = g_ScrambledHaltonPermutations.Load(_16480 * 4 + 0) & 65535u;
	                }
	                uint _20329 = 146100u + ((_12091 / 1429u) % 1429u);
	                uint _16481 = _20329 / 2u;
	                uint _11421;
	                if ((_20329 & 1u) != 0u)
	                {
	                    _11421 = g_ScrambledHaltonPermutations.Load(_16481 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11421 = g_ScrambledHaltonPermutations.Load(_16481 * 4 + 0) & 65535u;
	                }
	                uint _20330 = 146100u + ((_12091 / 2042041u) % 1429u);
	                uint _16482 = _20330 / 2u;
	                uint _11809;
	                if ((_20330 & 1u) != 0u)
	                {
	                    _11809 = g_ScrambledHaltonPermutations.Load(_16482 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11809 = g_ScrambledHaltonPermutations.Load(_16482 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11535 * 2042041u) + (_11421 * 1429u)) + _11809) * 3.4269143078802244417602196335793e-10f;
	                _19095 = true;
	                break;
	            }
	            case 226u:
	            {
	                uint _15684 = 147529u + (_12091 % 1433u);
	                uint _16477 = _15684 / 2u;
	                uint _11534;
	                if ((_15684 & 1u) != 0u)
	                {
	                    _11534 = g_ScrambledHaltonPermutations.Load(_16477 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11534 = g_ScrambledHaltonPermutations.Load(_16477 * 4 + 0) & 65535u;
	                }
	                uint _20327 = 147529u + ((_12091 / 1433u) % 1433u);
	                uint _16478 = _20327 / 2u;
	                uint _11420;
	                if ((_20327 & 1u) != 0u)
	                {
	                    _11420 = g_ScrambledHaltonPermutations.Load(_16478 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11420 = g_ScrambledHaltonPermutations.Load(_16478 * 4 + 0) & 65535u;
	                }
	                uint _20328 = 147529u + ((_12091 / 2053489u) % 1433u);
	                uint _16479 = _20328 / 2u;
	                uint _11808;
	                if ((_20328 & 1u) != 0u)
	                {
	                    _11808 = g_ScrambledHaltonPermutations.Load(_16479 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11808 = g_ScrambledHaltonPermutations.Load(_16479 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11534 * 2053489u) + (_11420 * 1433u)) + _11808) * 3.3982971991974864067742601037025e-10f;
	                _19095 = true;
	                break;
	            }
	            case 227u:
	            {
	                uint _15683 = 148962u + (_12091 % 1439u);
	                uint _16474 = _15683 / 2u;
	                uint _11533;
	                if ((_15683 & 1u) != 0u)
	                {
	                    _11533 = g_ScrambledHaltonPermutations.Load(_16474 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11533 = g_ScrambledHaltonPermutations.Load(_16474 * 4 + 0) & 65535u;
	                }
	                uint _20325 = 148962u + ((_12091 / 1439u) % 1439u);
	                uint _16475 = _20325 / 2u;
	                uint _11419;
	                if ((_20325 & 1u) != 0u)
	                {
	                    _11419 = g_ScrambledHaltonPermutations.Load(_16475 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11419 = g_ScrambledHaltonPermutations.Load(_16475 * 4 + 0) & 65535u;
	                }
	                uint _20326 = 148962u + ((_12091 / 2070721u) % 1439u);
	                uint _16476 = _20326 / 2u;
	                uint _11807;
	                if ((_20326 & 1u) != 0u)
	                {
	                    _11807 = g_ScrambledHaltonPermutations.Load(_16476 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11807 = g_ScrambledHaltonPermutations.Load(_16476 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11533 * 2070721u) + (_11419 * 1439u)) + _11807) * 3.3559660606030661256227176636457e-10f;
	                _19095 = true;
	                break;
	            }
	            case 228u:
	            {
	                uint _15682 = 150401u + (_12091 % 1447u);
	                uint _16471 = _15682 / 2u;
	                uint _11532;
	                if ((_15682 & 1u) != 0u)
	                {
	                    _11532 = g_ScrambledHaltonPermutations.Load(_16471 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11532 = g_ScrambledHaltonPermutations.Load(_16471 * 4 + 0) & 65535u;
	                }
	                uint _20323 = 150401u + ((_12091 / 1447u) % 1447u);
	                uint _16472 = _20323 / 2u;
	                uint _11418;
	                if ((_20323 & 1u) != 0u)
	                {
	                    _11418 = g_ScrambledHaltonPermutations.Load(_16472 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11418 = g_ScrambledHaltonPermutations.Load(_16472 * 4 + 0) & 65535u;
	                }
	                uint _20324 = 150401u + ((_12091 / 2093809u) % 1447u);
	                uint _16473 = _20324 / 2u;
	                uint _11806;
	                if ((_20324 & 1u) != 0u)
	                {
	                    _11806 = g_ScrambledHaltonPermutations.Load(_16473 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11806 = g_ScrambledHaltonPermutations.Load(_16473 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11532 * 2093809u) + (_11418 * 1447u)) + _11806) * 3.3006111732625242893846007063985e-10f;
	                _19095 = true;
	                break;
	            }
	            case 229u:
	            {
	                uint _15681 = 151848u + (_12091 % 1451u);
	                uint _16468 = _15681 / 2u;
	                uint _11531;
	                if ((_15681 & 1u) != 0u)
	                {
	                    _11531 = g_ScrambledHaltonPermutations.Load(_16468 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11531 = g_ScrambledHaltonPermutations.Load(_16468 * 4 + 0) & 65535u;
	                }
	                uint _20321 = 151848u + ((_12091 / 1451u) % 1451u);
	                uint _16469 = _20321 / 2u;
	                uint _11417;
	                if ((_20321 & 1u) != 0u)
	                {
	                    _11417 = g_ScrambledHaltonPermutations.Load(_16469 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11417 = g_ScrambledHaltonPermutations.Load(_16469 * 4 + 0) & 65535u;
	                }
	                uint _20322 = 151848u + ((_12091 / 2105401u) % 1451u);
	                uint _16470 = _20322 / 2u;
	                uint _11805;
	                if ((_20322 & 1u) != 0u)
	                {
	                    _11805 = g_ScrambledHaltonPermutations.Load(_16470 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11805 = g_ScrambledHaltonPermutations.Load(_16470 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11531 * 2105401u) + (_11417 * 1451u)) + _11805) * 3.2733896149217400761699536815286e-10f;
	                _19095 = true;
	                break;
	            }
	            case 230u:
	            {
	                uint _15680 = 153299u + (_12091 % 1453u);
	                uint _16465 = _15680 / 2u;
	                uint _11530;
	                if ((_15680 & 1u) != 0u)
	                {
	                    _11530 = g_ScrambledHaltonPermutations.Load(_16465 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11530 = g_ScrambledHaltonPermutations.Load(_16465 * 4 + 0) & 65535u;
	                }
	                uint _20319 = 153299u + ((_12091 / 1453u) % 1453u);
	                uint _16466 = _20319 / 2u;
	                uint _11416;
	                if ((_20319 & 1u) != 0u)
	                {
	                    _11416 = g_ScrambledHaltonPermutations.Load(_16466 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11416 = g_ScrambledHaltonPermutations.Load(_16466 * 4 + 0) & 65535u;
	                }
	                uint _20320 = 153299u + ((_12091 / 2111209u) % 1453u);
	                uint _16467 = _20320 / 2u;
	                uint _11804;
	                if ((_20320 & 1u) != 0u)
	                {
	                    _11804 = g_ScrambledHaltonPermutations.Load(_16467 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11804 = g_ScrambledHaltonPermutations.Load(_16467 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11530 * 2111209u) + (_11416 * 1453u)) + _11804) * 3.2598912458325912666623480618e-10f;
	                _19095 = true;
	                break;
	            }
	            case 231u:
	            {
	                uint _15679 = 154752u + (_12091 % 1459u);
	                uint _16462 = _15679 / 2u;
	                uint _11529;
	                if ((_15679 & 1u) != 0u)
	                {
	                    _11529 = g_ScrambledHaltonPermutations.Load(_16462 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11529 = g_ScrambledHaltonPermutations.Load(_16462 * 4 + 0) & 65535u;
	                }
	                uint _20317 = 154752u + ((_12091 / 1459u) % 1459u);
	                uint _16463 = _20317 / 2u;
	                uint _11415;
	                if ((_20317 & 1u) != 0u)
	                {
	                    _11415 = g_ScrambledHaltonPermutations.Load(_16463 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11415 = g_ScrambledHaltonPermutations.Load(_16463 * 4 + 0) & 65535u;
	                }
	                uint _20318 = 154752u + ((_12091 / 2128681u) % 1459u);
	                uint _16464 = _20318 / 2u;
	                uint _11803;
	                if ((_20318 & 1u) != 0u)
	                {
	                    _11803 = g_ScrambledHaltonPermutations.Load(_16464 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11803 = g_ScrambledHaltonPermutations.Load(_16464 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11529 * 2128681u) + (_11415 * 1459u)) + _11803) * 3.2198382848847018067317549139261e-10f;
	                _19095 = true;
	                break;
	            }
	            case 232u:
	            {
	                uint _15678 = 156211u + (_12091 % 1471u);
	                uint _16459 = _15678 / 2u;
	                uint _11528;
	                if ((_15678 & 1u) != 0u)
	                {
	                    _11528 = g_ScrambledHaltonPermutations.Load(_16459 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11528 = g_ScrambledHaltonPermutations.Load(_16459 * 4 + 0) & 65535u;
	                }
	                uint _20315 = 156211u + ((_12091 / 1471u) % 1471u);
	                uint _16460 = _20315 / 2u;
	                uint _11414;
	                if ((_20315 & 1u) != 0u)
	                {
	                    _11414 = g_ScrambledHaltonPermutations.Load(_16460 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11414 = g_ScrambledHaltonPermutations.Load(_16460 * 4 + 0) & 65535u;
	                }
	                uint _20316 = 156211u + ((_12091 / 2163841u) % 1471u);
	                uint _16461 = _20316 / 2u;
	                uint _11802;
	                if ((_20316 & 1u) != 0u)
	                {
	                    _11802 = g_ScrambledHaltonPermutations.Load(_16461 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11802 = g_ScrambledHaltonPermutations.Load(_16461 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11528 * 2163841u) + (_11414 * 1471u)) + _11802) * 3.1416799717298715677316067740321e-10f;
	                _19095 = true;
	                break;
	            }
	            case 233u:
	            {
	                uint _15677 = 157682u + (_12091 % 1481u);
	                uint _16456 = _15677 / 2u;
	                uint _11527;
	                if ((_15677 & 1u) != 0u)
	                {
	                    _11527 = g_ScrambledHaltonPermutations.Load(_16456 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11527 = g_ScrambledHaltonPermutations.Load(_16456 * 4 + 0) & 65535u;
	                }
	                uint _20313 = 157682u + ((_12091 / 1481u) % 1481u);
	                uint _16457 = _20313 / 2u;
	                uint _11413;
	                if ((_20313 & 1u) != 0u)
	                {
	                    _11413 = g_ScrambledHaltonPermutations.Load(_16457 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11413 = g_ScrambledHaltonPermutations.Load(_16457 * 4 + 0) & 65535u;
	                }
	                uint _20314 = 157682u + ((_12091 / 2193361u) % 1481u);
	                uint _16458 = _20314 / 2u;
	                uint _11801;
	                if ((_20314 & 1u) != 0u)
	                {
	                    _11801 = g_ScrambledHaltonPermutations.Load(_16458 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11801 = g_ScrambledHaltonPermutations.Load(_16458 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11527 * 2193361u) + (_11413 * 1481u)) + _11801) * 3.0784688687113259675243170931935e-10f;
	                _19095 = true;
	                break;
	            }
	            case 234u:
	            {
	                uint _15676 = 159163u + (_12091 % 1483u);
	                uint _16453 = _15676 / 2u;
	                uint _11526;
	                if ((_15676 & 1u) != 0u)
	                {
	                    _11526 = g_ScrambledHaltonPermutations.Load(_16453 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11526 = g_ScrambledHaltonPermutations.Load(_16453 * 4 + 0) & 65535u;
	                }
	                uint _20311 = 159163u + ((_12091 / 1483u) % 1483u);
	                uint _16454 = _20311 / 2u;
	                uint _11412;
	                if ((_20311 & 1u) != 0u)
	                {
	                    _11412 = g_ScrambledHaltonPermutations.Load(_16454 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11412 = g_ScrambledHaltonPermutations.Load(_16454 * 4 + 0) & 65535u;
	                }
	                uint _20312 = 159163u + ((_12091 / 2199289u) % 1483u);
	                uint _16455 = _20312 / 2u;
	                uint _11800;
	                if ((_20312 & 1u) != 0u)
	                {
	                    _11800 = g_ScrambledHaltonPermutations.Load(_16455 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11800 = g_ScrambledHaltonPermutations.Load(_16455 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11526 * 2199289u) + (_11412 * 1483u)) + _11800) * 3.066030762610694182512816041708e-10f;
	                _19095 = true;
	                break;
	            }
	            case 235u:
	            {
	                uint _15675 = 160646u + (_12091 % 1487u);
	                uint _16450 = _15675 / 2u;
	                uint _11525;
	                if ((_15675 & 1u) != 0u)
	                {
	                    _11525 = g_ScrambledHaltonPermutations.Load(_16450 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11525 = g_ScrambledHaltonPermutations.Load(_16450 * 4 + 0) & 65535u;
	                }
	                uint _20309 = 160646u + ((_12091 / 1487u) % 1487u);
	                uint _16451 = _20309 / 2u;
	                uint _11411;
	                if ((_20309 & 1u) != 0u)
	                {
	                    _11411 = g_ScrambledHaltonPermutations.Load(_16451 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11411 = g_ScrambledHaltonPermutations.Load(_16451 * 4 + 0) & 65535u;
	                }
	                uint _20310 = 160646u + ((_12091 / 2211169u) % 1487u);
	                uint _16452 = _20310 / 2u;
	                uint _11799;
	                if ((_20310 & 1u) != 0u)
	                {
	                    _11799 = g_ScrambledHaltonPermutations.Load(_16452 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11799 = g_ScrambledHaltonPermutations.Load(_16452 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11525 * 2211169u) + (_11411 * 1487u)) + _11799) * 3.0413546681096192969562252983451e-10f;
	                _19095 = true;
	                break;
	            }
	            case 236u:
	            {
	                uint _15674 = 162133u + (_12091 % 1489u);
	                uint _16447 = _15674 / 2u;
	                uint _11524;
	                if ((_15674 & 1u) != 0u)
	                {
	                    _11524 = g_ScrambledHaltonPermutations.Load(_16447 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11524 = g_ScrambledHaltonPermutations.Load(_16447 * 4 + 0) & 65535u;
	                }
	                uint _20307 = 162133u + ((_12091 / 1489u) % 1489u);
	                uint _16448 = _20307 / 2u;
	                uint _11410;
	                if ((_20307 & 1u) != 0u)
	                {
	                    _11410 = g_ScrambledHaltonPermutations.Load(_16448 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11410 = g_ScrambledHaltonPermutations.Load(_16448 * 4 + 0) & 65535u;
	                }
	                uint _20308 = 162133u + ((_12091 / 2217121u) % 1489u);
	                uint _16449 = _20308 / 2u;
	                uint _11798;
	                if ((_20308 & 1u) != 0u)
	                {
	                    _11798 = g_ScrambledHaltonPermutations.Load(_16449 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11798 = g_ScrambledHaltonPermutations.Load(_16449 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11524 * 2217121u) + (_11410 * 1489u)) + _11798) * 3.029115847041907727543730288744e-10f;
	                _19095 = true;
	                break;
	            }
	            case 237u:
	            {
	                uint _15673 = 163622u + (_12091 % 1493u);
	                uint _16444 = _15673 / 2u;
	                uint _11523;
	                if ((_15673 & 1u) != 0u)
	                {
	                    _11523 = g_ScrambledHaltonPermutations.Load(_16444 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11523 = g_ScrambledHaltonPermutations.Load(_16444 * 4 + 0) & 65535u;
	                }
	                uint _20305 = 163622u + ((_12091 / 1493u) % 1493u);
	                uint _16445 = _20305 / 2u;
	                uint _11409;
	                if ((_20305 & 1u) != 0u)
	                {
	                    _11409 = g_ScrambledHaltonPermutations.Load(_16445 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11409 = g_ScrambledHaltonPermutations.Load(_16445 * 4 + 0) & 65535u;
	                }
	                uint _20306 = 163622u + ((_12091 / 2229049u) % 1493u);
	                uint _16446 = _20306 / 2u;
	                uint _11797;
	                if ((_20306 & 1u) != 0u)
	                {
	                    _11797 = g_ScrambledHaltonPermutations.Load(_16446 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11797 = g_ScrambledHaltonPermutations.Load(_16446 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11523 * 2229049u) + (_11409 * 1493u)) + _11797) * 3.0048344368260870851372601464391e-10f;
	                _19095 = true;
	                break;
	            }
	            case 238u:
	            {
	                uint _15672 = 165115u + (_12091 % 1499u);
	                uint _16441 = _15672 / 2u;
	                uint _11522;
	                if ((_15672 & 1u) != 0u)
	                {
	                    _11522 = g_ScrambledHaltonPermutations.Load(_16441 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11522 = g_ScrambledHaltonPermutations.Load(_16441 * 4 + 0) & 65535u;
	                }
	                uint _20303 = 165115u + ((_12091 / 1499u) % 1499u);
	                uint _16442 = _20303 / 2u;
	                uint _11408;
	                if ((_20303 & 1u) != 0u)
	                {
	                    _11408 = g_ScrambledHaltonPermutations.Load(_16442 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11408 = g_ScrambledHaltonPermutations.Load(_16442 * 4 + 0) & 65535u;
	                }
	                uint _20304 = 165115u + ((_12091 / 2247001u) % 1499u);
	                uint _16443 = _20304 / 2u;
	                uint _11796;
	                if ((_20304 & 1u) != 0u)
	                {
	                    _11796 = g_ScrambledHaltonPermutations.Load(_16443 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11796 = g_ScrambledHaltonPermutations.Load(_16443 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11522 * 2247001u) + (_11408 * 1499u)) + _11796) * 2.968896517518970767923747189343e-10f;
	                _19095 = true;
	                break;
	            }
	            case 239u:
	            {
	                uint _15671 = 166614u + (_12091 % 1511u);
	                uint _16438 = _15671 / 2u;
	                uint _11521;
	                if ((_15671 & 1u) != 0u)
	                {
	                    _11521 = g_ScrambledHaltonPermutations.Load(_16438 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11521 = g_ScrambledHaltonPermutations.Load(_16438 * 4 + 0) & 65535u;
	                }
	                uint _20301 = 166614u + ((_12091 / 1511u) % 1511u);
	                uint _16439 = _20301 / 2u;
	                uint _11407;
	                if ((_20301 & 1u) != 0u)
	                {
	                    _11407 = g_ScrambledHaltonPermutations.Load(_16439 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11407 = g_ScrambledHaltonPermutations.Load(_16439 * 4 + 0) & 65535u;
	                }
	                uint _20302 = 166614u + ((_12091 / 2283121u) % 1511u);
	                uint _16440 = _20302 / 2u;
	                uint _11795;
	                if ((_20302 & 1u) != 0u)
	                {
	                    _11795 = g_ScrambledHaltonPermutations.Load(_16440 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11795 = g_ScrambledHaltonPermutations.Load(_16440 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11521 * 2283121u) + (_11407 * 1511u)) + _11795) * 2.8987218181342200296057853847742e-10f;
	                _19095 = true;
	                break;
	            }
	            case 240u:
	            {
	                uint _15670 = 168125u + (_12091 % 1523u);
	                uint _16435 = _15670 / 2u;
	                uint _11520;
	                if ((_15670 & 1u) != 0u)
	                {
	                    _11520 = g_ScrambledHaltonPermutations.Load(_16435 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11520 = g_ScrambledHaltonPermutations.Load(_16435 * 4 + 0) & 65535u;
	                }
	                uint _20299 = 168125u + ((_12091 / 1523u) % 1523u);
	                uint _16436 = _20299 / 2u;
	                uint _11406;
	                if ((_20299 & 1u) != 0u)
	                {
	                    _11406 = g_ScrambledHaltonPermutations.Load(_16436 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11406 = g_ScrambledHaltonPermutations.Load(_16436 * 4 + 0) & 65535u;
	                }
	                uint _20300 = 168125u + ((_12091 / 2319529u) % 1523u);
	                uint _16437 = _20300 / 2u;
	                uint _11794;
	                if ((_20300 & 1u) != 0u)
	                {
	                    _11794 = g_ScrambledHaltonPermutations.Load(_16437 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11794 = g_ScrambledHaltonPermutations.Load(_16437 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11520 * 2319529u) + (_11406 * 1523u)) + _11794) * 2.8307417521133970694791059941053e-10f;
	                _19095 = true;
	                break;
	            }
	            case 241u:
	            {
	                uint _15669 = 169648u + (_12091 % 1531u);
	                uint _16432 = _15669 / 2u;
	                uint _11519;
	                if ((_15669 & 1u) != 0u)
	                {
	                    _11519 = g_ScrambledHaltonPermutations.Load(_16432 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11519 = g_ScrambledHaltonPermutations.Load(_16432 * 4 + 0) & 65535u;
	                }
	                uint _20297 = 169648u + ((_12091 / 1531u) % 1531u);
	                uint _16433 = _20297 / 2u;
	                uint _11405;
	                if ((_20297 & 1u) != 0u)
	                {
	                    _11405 = g_ScrambledHaltonPermutations.Load(_16433 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11405 = g_ScrambledHaltonPermutations.Load(_16433 * 4 + 0) & 65535u;
	                }
	                uint _20298 = 169648u + ((_12091 / 2343961u) % 1531u);
	                uint _16434 = _20298 / 2u;
	                uint _11793;
	                if ((_20298 & 1u) != 0u)
	                {
	                    _11793 = g_ScrambledHaltonPermutations.Load(_16434 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11793 = g_ScrambledHaltonPermutations.Load(_16434 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11519 * 2343961u) + (_11405 * 1531u)) + _11793) * 2.7865981744312762202753219753504e-10f;
	                _19095 = true;
	                break;
	            }
	            case 242u:
	            {
	                uint _15668 = 171179u + (_12091 % 1543u);
	                uint _16429 = _15668 / 2u;
	                uint _11518;
	                if ((_15668 & 1u) != 0u)
	                {
	                    _11518 = g_ScrambledHaltonPermutations.Load(_16429 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11518 = g_ScrambledHaltonPermutations.Load(_16429 * 4 + 0) & 65535u;
	                }
	                uint _20295 = 171179u + ((_12091 / 1543u) % 1543u);
	                uint _16430 = _20295 / 2u;
	                uint _11404;
	                if ((_20295 & 1u) != 0u)
	                {
	                    _11404 = g_ScrambledHaltonPermutations.Load(_16430 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11404 = g_ScrambledHaltonPermutations.Load(_16430 * 4 + 0) & 65535u;
	                }
	                uint _20296 = 171179u + ((_12091 / 2380849u) % 1543u);
	                uint _16431 = _20296 / 2u;
	                uint _11792;
	                if ((_20296 & 1u) != 0u)
	                {
	                    _11792 = g_ScrambledHaltonPermutations.Load(_16431 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11792 = g_ScrambledHaltonPermutations.Load(_16431 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11518 * 2380849u) + (_11404 * 1543u)) + _11792) * 2.7220881104739191869157366454601e-10f;
	                _19095 = true;
	                break;
	            }
	            case 243u:
	            {
	                uint _15667 = 172722u + (_12091 % 1549u);
	                uint _16426 = _15667 / 2u;
	                uint _11517;
	                if ((_15667 & 1u) != 0u)
	                {
	                    _11517 = g_ScrambledHaltonPermutations.Load(_16426 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11517 = g_ScrambledHaltonPermutations.Load(_16426 * 4 + 0) & 65535u;
	                }
	                uint _20293 = 172722u + ((_12091 / 1549u) % 1549u);
	                uint _16427 = _20293 / 2u;
	                uint _11403;
	                if ((_20293 & 1u) != 0u)
	                {
	                    _11403 = g_ScrambledHaltonPermutations.Load(_16427 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11403 = g_ScrambledHaltonPermutations.Load(_16427 * 4 + 0) & 65535u;
	                }
	                uint _20294 = 172722u + ((_12091 / 2399401u) % 1549u);
	                uint _16428 = _20294 / 2u;
	                uint _11791;
	                if ((_20294 & 1u) != 0u)
	                {
	                    _11791 = g_ScrambledHaltonPermutations.Load(_16428 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11791 = g_ScrambledHaltonPermutations.Load(_16428 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11517 * 2399401u) + (_11403 * 1549u)) + _11791) * 2.6905785932562764628528384491801e-10f;
	                _19095 = true;
	                break;
	            }
	            case 244u:
	            {
	                uint _15666 = 174271u + (_12091 % 1553u);
	                uint _16423 = _15666 / 2u;
	                uint _11516;
	                if ((_15666 & 1u) != 0u)
	                {
	                    _11516 = g_ScrambledHaltonPermutations.Load(_16423 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11516 = g_ScrambledHaltonPermutations.Load(_16423 * 4 + 0) & 65535u;
	                }
	                uint _20291 = 174271u + ((_12091 / 1553u) % 1553u);
	                uint _16424 = _20291 / 2u;
	                uint _11402;
	                if ((_20291 & 1u) != 0u)
	                {
	                    _11402 = g_ScrambledHaltonPermutations.Load(_16424 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11402 = g_ScrambledHaltonPermutations.Load(_16424 * 4 + 0) & 65535u;
	                }
	                uint _20292 = 174271u + ((_12091 / 2411809u) % 1553u);
	                uint _16425 = _20292 / 2u;
	                uint _11790;
	                if ((_20292 & 1u) != 0u)
	                {
	                    _11790 = g_ScrambledHaltonPermutations.Load(_16425 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11790 = g_ScrambledHaltonPermutations.Load(_16425 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11516 * 2411809u) + (_11402 * 1553u)) + _11790) * 2.6698421251580839452799409627914e-10f;
	                _19095 = true;
	                break;
	            }
	            case 245u:
	            {
	                uint _15665 = 175824u + (_12091 % 1559u);
	                uint _16420 = _15665 / 2u;
	                uint _11515;
	                if ((_15665 & 1u) != 0u)
	                {
	                    _11515 = g_ScrambledHaltonPermutations.Load(_16420 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11515 = g_ScrambledHaltonPermutations.Load(_16420 * 4 + 0) & 65535u;
	                }
	                uint _20289 = 175824u + ((_12091 / 1559u) % 1559u);
	                uint _16421 = _20289 / 2u;
	                uint _11401;
	                if ((_20289 & 1u) != 0u)
	                {
	                    _11401 = g_ScrambledHaltonPermutations.Load(_16421 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11401 = g_ScrambledHaltonPermutations.Load(_16421 * 4 + 0) & 65535u;
	                }
	                uint _20290 = 175824u + ((_12091 / 2430481u) % 1559u);
	                uint _16422 = _20290 / 2u;
	                uint _11789;
	                if ((_20290 & 1u) != 0u)
	                {
	                    _11789 = g_ScrambledHaltonPermutations.Load(_16422 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11789 = g_ScrambledHaltonPermutations.Load(_16422 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11515 * 2430481u) + (_11401 * 1559u)) + _11789) * 2.6391350216314890531066339462996e-10f;
	                _19095 = true;
	                break;
	            }
	            case 246u:
	            {
	                uint _15664 = 177383u + (_12091 % 1567u);
	                uint _16417 = _15664 / 2u;
	                uint _11514;
	                if ((_15664 & 1u) != 0u)
	                {
	                    _11514 = g_ScrambledHaltonPermutations.Load(_16417 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11514 = g_ScrambledHaltonPermutations.Load(_16417 * 4 + 0) & 65535u;
	                }
	                uint _20287 = 177383u + ((_12091 / 1567u) % 1567u);
	                uint _16418 = _20287 / 2u;
	                uint _11400;
	                if ((_20287 & 1u) != 0u)
	                {
	                    _11400 = g_ScrambledHaltonPermutations.Load(_16418 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11400 = g_ScrambledHaltonPermutations.Load(_16418 * 4 + 0) & 65535u;
	                }
	                uint _20288 = 177383u + ((_12091 / 2455489u) % 1567u);
	                uint _16419 = _20288 / 2u;
	                uint _11788;
	                if ((_20288 & 1u) != 0u)
	                {
	                    _11788 = g_ScrambledHaltonPermutations.Load(_16419 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11788 = g_ScrambledHaltonPermutations.Load(_16419 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11514 * 2455489u) + (_11400 * 1567u)) + _11788) * 2.5989202456777604766102740541101e-10f;
	                _19095 = true;
	                break;
	            }
	            case 247u:
	            {
	                uint _15663 = 178950u + (_12091 % 1571u);
	                uint _16414 = _15663 / 2u;
	                uint _11513;
	                if ((_15663 & 1u) != 0u)
	                {
	                    _11513 = g_ScrambledHaltonPermutations.Load(_16414 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11513 = g_ScrambledHaltonPermutations.Load(_16414 * 4 + 0) & 65535u;
	                }
	                uint _20285 = 178950u + ((_12091 / 1571u) % 1571u);
	                uint _16415 = _20285 / 2u;
	                uint _11399;
	                if ((_20285 & 1u) != 0u)
	                {
	                    _11399 = g_ScrambledHaltonPermutations.Load(_16415 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11399 = g_ScrambledHaltonPermutations.Load(_16415 * 4 + 0) & 65535u;
	                }
	                uint _20286 = 178950u + ((_12091 / 2468041u) % 1571u);
	                uint _16416 = _20286 / 2u;
	                uint _11787;
	                if ((_20286 & 1u) != 0u)
	                {
	                    _11787 = g_ScrambledHaltonPermutations.Load(_16416 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11787 = g_ScrambledHaltonPermutations.Load(_16416 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11513 * 2468041u) + (_11399 * 1571u)) + _11787) * 2.5791191404778146534226834774017e-10f;
	                _19095 = true;
	                break;
	            }
	            case 248u:
	            {
	                uint _15662 = 180521u + (_12091 % 1579u);
	                uint _16411 = _15662 / 2u;
	                uint _11512;
	                if ((_15662 & 1u) != 0u)
	                {
	                    _11512 = g_ScrambledHaltonPermutations.Load(_16411 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11512 = g_ScrambledHaltonPermutations.Load(_16411 * 4 + 0) & 65535u;
	                }
	                uint _20283 = 180521u + ((_12091 / 1579u) % 1579u);
	                uint _16412 = _20283 / 2u;
	                uint _11398;
	                if ((_20283 & 1u) != 0u)
	                {
	                    _11398 = g_ScrambledHaltonPermutations.Load(_16412 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11398 = g_ScrambledHaltonPermutations.Load(_16412 * 4 + 0) & 65535u;
	                }
	                uint _20284 = 180521u + ((_12091 / 2493241u) % 1579u);
	                uint _16413 = _20284 / 2u;
	                uint _11786;
	                if ((_20284 & 1u) != 0u)
	                {
	                    _11786 = g_ScrambledHaltonPermutations.Load(_16413 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11786 = g_ScrambledHaltonPermutations.Load(_16413 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11512 * 2493241u) + (_11398 * 1579u)) + _11786) * 2.54011589539970827900106087327e-10f;
	                _19095 = true;
	                break;
	            }
	            case 249u:
	            {
	                uint _15661 = 182100u + (_12091 % 1583u);
	                uint _16408 = _15661 / 2u;
	                uint _11511;
	                if ((_15661 & 1u) != 0u)
	                {
	                    _11511 = g_ScrambledHaltonPermutations.Load(_16408 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11511 = g_ScrambledHaltonPermutations.Load(_16408 * 4 + 0) & 65535u;
	                }
	                uint _20281 = 182100u + ((_12091 / 1583u) % 1583u);
	                uint _16409 = _20281 / 2u;
	                uint _11397;
	                if ((_20281 & 1u) != 0u)
	                {
	                    _11397 = g_ScrambledHaltonPermutations.Load(_16409 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11397 = g_ScrambledHaltonPermutations.Load(_16409 * 4 + 0) & 65535u;
	                }
	                uint _20282 = 182100u + ((_12091 / 2505889u) % 1583u);
	                uint _16410 = _20282 / 2u;
	                uint _11785;
	                if ((_20282 & 1u) != 0u)
	                {
	                    _11785 = g_ScrambledHaltonPermutations.Load(_16410 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11785 = g_ScrambledHaltonPermutations.Load(_16410 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11511 * 2505889u) + (_11397 * 1583u)) + _11785) * 2.5209090370736930708517320454121e-10f;
	                _19095 = true;
	                break;
	            }
	            case 250u:
	            {
	                uint _15660 = 183683u + (_12091 % 1597u);
	                uint _16405 = _15660 / 2u;
	                uint _11510;
	                if ((_15660 & 1u) != 0u)
	                {
	                    _11510 = g_ScrambledHaltonPermutations.Load(_16405 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11510 = g_ScrambledHaltonPermutations.Load(_16405 * 4 + 0) & 65535u;
	                }
	                uint _20279 = 183683u + ((_12091 / 1597u) % 1597u);
	                uint _16406 = _20279 / 2u;
	                uint _11396;
	                if ((_20279 & 1u) != 0u)
	                {
	                    _11396 = g_ScrambledHaltonPermutations.Load(_16406 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11396 = g_ScrambledHaltonPermutations.Load(_16406 * 4 + 0) & 65535u;
	                }
	                uint _20280 = 183683u + ((_12091 / 2550409u) % 1597u);
	                uint _16407 = _20280 / 2u;
	                uint _11784;
	                if ((_20280 & 1u) != 0u)
	                {
	                    _11784 = g_ScrambledHaltonPermutations.Load(_16407 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11784 = g_ScrambledHaltonPermutations.Load(_16407 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11510 * 2550409u) + (_11396 * 1597u)) + _11784) * 2.4551904953540315545978955924511e-10f;
	                _19095 = true;
	                break;
	            }
	            case 251u:
	            {
	                uint _15659 = 185280u + (_12091 % 1601u);
	                uint _16402 = _15659 / 2u;
	                uint _11509;
	                if ((_15659 & 1u) != 0u)
	                {
	                    _11509 = g_ScrambledHaltonPermutations.Load(_16402 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11509 = g_ScrambledHaltonPermutations.Load(_16402 * 4 + 0) & 65535u;
	                }
	                uint _20277 = 185280u + ((_12091 / 1601u) % 1601u);
	                uint _16403 = _20277 / 2u;
	                uint _11395;
	                if ((_20277 & 1u) != 0u)
	                {
	                    _11395 = g_ScrambledHaltonPermutations.Load(_16403 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11395 = g_ScrambledHaltonPermutations.Load(_16403 * 4 + 0) & 65535u;
	                }
	                uint _20278 = 185280u + ((_12091 / 2563201u) % 1601u);
	                uint _16404 = _20278 / 2u;
	                uint _11783;
	                if ((_20278 & 1u) != 0u)
	                {
	                    _11783 = g_ScrambledHaltonPermutations.Load(_16404 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11783 = g_ScrambledHaltonPermutations.Load(_16404 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11509 * 2563201u) + (_11395 * 1601u)) + _11783) * 2.4368340678648792163585312664509e-10f;
	                _19095 = true;
	                break;
	            }
	            case 252u:
	            {
	                uint _15658 = 186881u + (_12091 % 1607u);
	                uint _16399 = _15658 / 2u;
	                uint _11508;
	                if ((_15658 & 1u) != 0u)
	                {
	                    _11508 = g_ScrambledHaltonPermutations.Load(_16399 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11508 = g_ScrambledHaltonPermutations.Load(_16399 * 4 + 0) & 65535u;
	                }
	                uint _20275 = 186881u + ((_12091 / 1607u) % 1607u);
	                uint _16400 = _20275 / 2u;
	                uint _11394;
	                if ((_20275 & 1u) != 0u)
	                {
	                    _11394 = g_ScrambledHaltonPermutations.Load(_16400 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11394 = g_ScrambledHaltonPermutations.Load(_16400 * 4 + 0) & 65535u;
	                }
	                uint _20276 = 186881u + ((_12091 / 2582449u) % 1607u);
	                uint _16401 = _20276 / 2u;
	                uint _11782;
	                if ((_20276 & 1u) != 0u)
	                {
	                    _11782 = g_ScrambledHaltonPermutations.Load(_16401 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11782 = g_ScrambledHaltonPermutations.Load(_16401 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11508 * 2582449u) + (_11394 * 1607u)) + _11782) * 2.4096408202112229446356650441885e-10f;
	                _19095 = true;
	                break;
	            }
	            case 253u:
	            {
	                uint _15657 = 188488u + (_12091 % 1609u);
	                uint _16396 = _15657 / 2u;
	                uint _11507;
	                if ((_15657 & 1u) != 0u)
	                {
	                    _11507 = g_ScrambledHaltonPermutations.Load(_16396 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11507 = g_ScrambledHaltonPermutations.Load(_16396 * 4 + 0) & 65535u;
	                }
	                uint _20273 = 188488u + ((_12091 / 1609u) % 1609u);
	                uint _16397 = _20273 / 2u;
	                uint _11393;
	                if ((_20273 & 1u) != 0u)
	                {
	                    _11393 = g_ScrambledHaltonPermutations.Load(_16397 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11393 = g_ScrambledHaltonPermutations.Load(_16397 * 4 + 0) & 65535u;
	                }
	                uint _20274 = 188488u + ((_12091 / 2588881u) % 1609u);
	                uint _16398 = _20274 / 2u;
	                uint _11781;
	                if ((_20274 & 1u) != 0u)
	                {
	                    _11781 = g_ScrambledHaltonPermutations.Load(_16398 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11781 = g_ScrambledHaltonPermutations.Load(_16398 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11507 * 2588881u) + (_11393 * 1609u)) + _11781) * 2.4006663323916654917411506175995e-10f;
	                _19095 = true;
	                break;
	            }
	            case 254u:
	            {
	                uint _15656 = 190097u + (_12091 % 1613u);
	                uint _16392 = _15656 / 2u;
	                uint _11506;
	                if ((_15656 & 1u) != 0u)
	                {
	                    _11506 = g_ScrambledHaltonPermutations.Load(_16392 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11506 = g_ScrambledHaltonPermutations.Load(_16392 * 4 + 0) & 65535u;
	                }
	                uint _20271 = 190097u + ((_12091 / 1613u) % 1613u);
	                uint _16393 = _20271 / 2u;
	                uint _11392;
	                if ((_20271 & 1u) != 0u)
	                {
	                    _11392 = g_ScrambledHaltonPermutations.Load(_16393 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11392 = g_ScrambledHaltonPermutations.Load(_16393 * 4 + 0) & 65535u;
	                }
	                uint _20272 = 190097u + ((_12091 / 2601769u) % 1613u);
	                uint _16395 = _20272 / 2u;
	                uint _11780;
	                if ((_20272 & 1u) != 0u)
	                {
	                    _11780 = g_ScrambledHaltonPermutations.Load(_16395 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11780 = g_ScrambledHaltonPermutations.Load(_16395 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11506 * 2601769u) + (_11392 * 1613u)) + _11780) * 2.3828508610712617610261077061296e-10f;
	                _19095 = true;
	                break;
	            }
	            case 255u:
	            {
	                uint _15655 = 191710u + (_12091 % 1619u);
	                uint _16389 = _15655 / 2u;
	                uint _11505;
	                if ((_15655 & 1u) != 0u)
	                {
	                    _11505 = g_ScrambledHaltonPermutations.Load(_16389 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11505 = g_ScrambledHaltonPermutations.Load(_16389 * 4 + 0) & 65535u;
	                }
	                uint _20269 = 191710u + ((_12091 / 1619u) % 1619u);
	                uint _16390 = _20269 / 2u;
	                uint _11391;
	                if ((_20269 & 1u) != 0u)
	                {
	                    _11391 = g_ScrambledHaltonPermutations.Load(_16390 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11391 = g_ScrambledHaltonPermutations.Load(_16390 * 4 + 0) & 65535u;
	                }
	                uint _20270 = 191710u + ((_12091 / 2621161u) % 1619u);
	                uint _16391 = _20270 / 2u;
	                uint _11779;
	                if ((_20270 & 1u) != 0u)
	                {
	                    _11779 = g_ScrambledHaltonPermutations.Load(_16391 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _11779 = g_ScrambledHaltonPermutations.Load(_16391 * 4 + 0) & 65535u;
	                }
	                _19094 = float(((_11505 * 2621161u) + (_11391 * 1619u)) + _11779) * 2.3564564188838232894340762868524e-10f;
	                _19095 = true;
	                break;
	            }
	            default:
	            {
	                _19094 = _2;
	                _19095 = false;
	                break;
	            }
	        }
	        if (_19095)
	        {
	            _19096 = _19094;
	            break;
	        }
	        _19096 = 0.0f;
	        break;
	    } while(false);
	    float _33363;
	    do
	    {
	        float _33359;
	        bool _33360;
	        switch (_7315 + 1u)
	        {
	            case 0u:
	            {
	                uint _33332 = (_12091 << uint(16)) | (_12091 >> uint(16));
	                uint _33337 = ((_33332 & 16711935u) << uint(8)) | ((_33332 & 4278255360u) >> uint(8));
	                uint _33342 = ((_33337 & 252645135u) << uint(4)) | ((_33337 & 4042322160u) >> uint(4));
	                uint _33347 = ((_33342 & 858993459u) << uint(2)) | ((_33342 & 3435973836u) >> uint(2));
	                _33359 = asfloat(1065353216u | ((((_33347 & 1431655765u) << uint(1)) | ((_33347 & 2863311530u) >> uint(1))) >> uint(9))) - 1.0f;
	                _33360 = true;
	                break;
	            }
	            case 1u:
	            {
	                uint _33272 = _12091 % 243u;
	                uint _33273 = _33272 / 2u;
	                uint _33283;
	                if ((_33272 & 1u) != 0u)
	                {
	                    _33283 = g_ScrambledHaltonPermutations.Load(_33273 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _33283 = g_ScrambledHaltonPermutations.Load(_33273 * 4 + 0) & 65535u;
	                }
	                uint _33286 = (_12091 / 243u) % 243u;
	                uint _33287 = _33286 / 2u;
	                uint _33297;
	                if ((_33286 & 1u) != 0u)
	                {
	                    _33297 = g_ScrambledHaltonPermutations.Load(_33287 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _33297 = g_ScrambledHaltonPermutations.Load(_33287 * 4 + 0) & 65535u;
	                }
	                uint _33300 = (_12091 / 59049u) % 243u;
	                uint _33301 = _33300 / 2u;
	                uint _33311;
	                if ((_33300 & 1u) != 0u)
	                {
	                    _33311 = g_ScrambledHaltonPermutations.Load(_33301 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _33311 = g_ScrambledHaltonPermutations.Load(_33301 * 4 + 0) & 65535u;
	                }
	                uint _33314 = (_12091 / 14348907u) % 243u;
	                uint _33315 = _33314 / 2u;
	                uint _33325;
	                if ((_33314 & 1u) != 0u)
	                {
	                    _33325 = g_ScrambledHaltonPermutations.Load(_33315 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _33325 = g_ScrambledHaltonPermutations.Load(_33315 * 4 + 0) & 65535u;
	                }
	                _33359 = float((((_33283 * 14348907u) + (_33297 * 59049u)) + (_33311 * 243u)) + _33325) * 2.8679716934654209126165369525552e-10f;
	                _33360 = true;
	                break;
	            }
	            case 2u:
	            {
	                uint _33211 = 243u + (_12091 % 125u);
	                uint _33212 = _33211 / 2u;
	                uint _33222;
	                if ((_33211 & 1u) != 0u)
	                {
	                    _33222 = g_ScrambledHaltonPermutations.Load(_33212 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _33222 = g_ScrambledHaltonPermutations.Load(_33212 * 4 + 0) & 65535u;
	                }
	                uint _33226 = 243u + ((_12091 / 125u) % 125u);
	                uint _33227 = _33226 / 2u;
	                uint _33237;
	                if ((_33226 & 1u) != 0u)
	                {
	                    _33237 = g_ScrambledHaltonPermutations.Load(_33227 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _33237 = g_ScrambledHaltonPermutations.Load(_33227 * 4 + 0) & 65535u;
	                }
	                uint _33241 = 243u + ((_12091 / 15625u) % 125u);
	                uint _33242 = _33241 / 2u;
	                uint _33252;
	                if ((_33241 & 1u) != 0u)
	                {
	                    _33252 = g_ScrambledHaltonPermutations.Load(_33242 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _33252 = g_ScrambledHaltonPermutations.Load(_33242 * 4 + 0) & 65535u;
	                }
	                uint _33256 = 243u + ((_12091 / 1953125u) % 125u);
	                uint _33257 = _33256 / 2u;
	                uint _33267;
	                if ((_33256 & 1u) != 0u)
	                {
	                    _33267 = g_ScrambledHaltonPermutations.Load(_33257 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _33267 = g_ScrambledHaltonPermutations.Load(_33257 * 4 + 0) & 65535u;
	                }
	                _33359 = float((((_33222 * 1953125u) + (_33237 * 15625u)) + (_33252 * 125u)) + _33267) * 4.0959995395439818821614608168602e-09f;
	                _33360 = true;
	                break;
	            }
	            case 3u:
	            {
	                uint _33164 = 368u + (_12091 % 343u);
	                uint _33165 = _33164 / 2u;
	                uint _33175;
	                if ((_33164 & 1u) != 0u)
	                {
	                    _33175 = g_ScrambledHaltonPermutations.Load(_33165 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _33175 = g_ScrambledHaltonPermutations.Load(_33165 * 4 + 0) & 65535u;
	                }
	                uint _33179 = 368u + ((_12091 / 343u) % 343u);
	                uint _33180 = _33179 / 2u;
	                uint _33190;
	                if ((_33179 & 1u) != 0u)
	                {
	                    _33190 = g_ScrambledHaltonPermutations.Load(_33180 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _33190 = g_ScrambledHaltonPermutations.Load(_33180 * 4 + 0) & 65535u;
	                }
	                uint _33194 = 368u + ((_12091 / 117649u) % 343u);
	                uint _33195 = _33194 / 2u;
	                uint _33205;
	                if ((_33194 & 1u) != 0u)
	                {
	                    _33205 = g_ScrambledHaltonPermutations.Load(_33195 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _33205 = g_ScrambledHaltonPermutations.Load(_33195 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_33175 * 117649u) + (_33190 * 343u)) + _33205) * 2.47809293085765602882020175457e-08f;
	                _33360 = true;
	                break;
	            }
	            case 4u:
	            {
	                uint _33102 = 711u + (_12091 % 121u);
	                uint _33103 = _33102 / 2u;
	                uint _33113;
	                if ((_33102 & 1u) != 0u)
	                {
	                    _33113 = g_ScrambledHaltonPermutations.Load(_33103 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _33113 = g_ScrambledHaltonPermutations.Load(_33103 * 4 + 0) & 65535u;
	                }
	                uint _33117 = 711u + ((_12091 / 121u) % 121u);
	                uint _33118 = _33117 / 2u;
	                uint _33128;
	                if ((_33117 & 1u) != 0u)
	                {
	                    _33128 = g_ScrambledHaltonPermutations.Load(_33118 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _33128 = g_ScrambledHaltonPermutations.Load(_33118 * 4 + 0) & 65535u;
	                }
	                uint _33132 = 711u + ((_12091 / 14641u) % 121u);
	                uint _33133 = _33132 / 2u;
	                uint _33143;
	                if ((_33132 & 1u) != 0u)
	                {
	                    _33143 = g_ScrambledHaltonPermutations.Load(_33133 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _33143 = g_ScrambledHaltonPermutations.Load(_33133 * 4 + 0) & 65535u;
	                }
	                uint _33147 = 711u + ((_12091 / 1771561u) % 121u);
	                uint _33148 = _33147 / 2u;
	                uint _33158;
	                if ((_33147 & 1u) != 0u)
	                {
	                    _33158 = g_ScrambledHaltonPermutations.Load(_33148 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _33158 = g_ScrambledHaltonPermutations.Load(_33148 * 4 + 0) & 65535u;
	                }
	                _33359 = float((((_33113 * 1771561u) + (_33128 * 14641u)) + (_33143 * 121u)) + _33158) * 4.6650732166142461210256442427635e-09f;
	                _33360 = true;
	                break;
	            }
	            case 5u:
	            {
	                uint _33040 = 832u + (_12091 % 169u);
	                uint _33041 = _33040 / 2u;
	                uint _33051;
	                if ((_33040 & 1u) != 0u)
	                {
	                    _33051 = g_ScrambledHaltonPermutations.Load(_33041 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _33051 = g_ScrambledHaltonPermutations.Load(_33041 * 4 + 0) & 65535u;
	                }
	                uint _33055 = 832u + ((_12091 / 169u) % 169u);
	                uint _33056 = _33055 / 2u;
	                uint _33066;
	                if ((_33055 & 1u) != 0u)
	                {
	                    _33066 = g_ScrambledHaltonPermutations.Load(_33056 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _33066 = g_ScrambledHaltonPermutations.Load(_33056 * 4 + 0) & 65535u;
	                }
	                uint _33070 = 832u + ((_12091 / 28561u) % 169u);
	                uint _33071 = _33070 / 2u;
	                uint _33081;
	                if ((_33070 & 1u) != 0u)
	                {
	                    _33081 = g_ScrambledHaltonPermutations.Load(_33071 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _33081 = g_ScrambledHaltonPermutations.Load(_33071 * 4 + 0) & 65535u;
	                }
	                uint _33085 = 832u + ((_12091 / 4826809u) % 169u);
	                uint _33086 = _33085 / 2u;
	                uint _33096;
	                if ((_33085 & 1u) != 0u)
	                {
	                    _33096 = g_ScrambledHaltonPermutations.Load(_33086 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _33096 = g_ScrambledHaltonPermutations.Load(_33086 * 4 + 0) & 65535u;
	                }
	                _33359 = float((((_33051 * 4826809u) + (_33066 * 28561u)) + (_33081 * 169u)) + _33096) * 1.2258944970255924999946728348732e-09f;
	                _33360 = true;
	                break;
	            }
	            case 6u:
	            {
	                uint _32993 = 1001u + (_12091 % 289u);
	                uint _32994 = _32993 / 2u;
	                uint _33004;
	                if ((_32993 & 1u) != 0u)
	                {
	                    _33004 = g_ScrambledHaltonPermutations.Load(_32994 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _33004 = g_ScrambledHaltonPermutations.Load(_32994 * 4 + 0) & 65535u;
	                }
	                uint _33008 = 1001u + ((_12091 / 289u) % 289u);
	                uint _33009 = _33008 / 2u;
	                uint _33019;
	                if ((_33008 & 1u) != 0u)
	                {
	                    _33019 = g_ScrambledHaltonPermutations.Load(_33009 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _33019 = g_ScrambledHaltonPermutations.Load(_33009 * 4 + 0) & 65535u;
	                }
	                uint _33023 = 1001u + ((_12091 / 83521u) % 289u);
	                uint _33024 = _33023 / 2u;
	                uint _33034;
	                if ((_33023 & 1u) != 0u)
	                {
	                    _33034 = g_ScrambledHaltonPermutations.Load(_33024 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _33034 = g_ScrambledHaltonPermutations.Load(_33024 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_33004 * 83521u) + (_33019 * 289u)) + _33034) * 4.1429188968322705477476119995117e-08f;
	                _33360 = true;
	                break;
	            }
	            case 7u:
	            {
	                uint _32946 = 1290u + (_12091 % 361u);
	                uint _32947 = _32946 / 2u;
	                uint _32957;
	                if ((_32946 & 1u) != 0u)
	                {
	                    _32957 = g_ScrambledHaltonPermutations.Load(_32947 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _32957 = g_ScrambledHaltonPermutations.Load(_32947 * 4 + 0) & 65535u;
	                }
	                uint _32961 = 1290u + ((_12091 / 361u) % 361u);
	                uint _32962 = _32961 / 2u;
	                uint _32972;
	                if ((_32961 & 1u) != 0u)
	                {
	                    _32972 = g_ScrambledHaltonPermutations.Load(_32962 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _32972 = g_ScrambledHaltonPermutations.Load(_32962 * 4 + 0) & 65535u;
	                }
	                uint _32976 = 1290u + ((_12091 / 130321u) % 361u);
	                uint _32977 = _32976 / 2u;
	                uint _32987;
	                if ((_32976 & 1u) != 0u)
	                {
	                    _32987 = g_ScrambledHaltonPermutations.Load(_32977 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _32987 = g_ScrambledHaltonPermutations.Load(_32977 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_32957 * 130321u) + (_32972 * 361u)) + _32987) * 2.1255843307699251454323530197144e-08f;
	                _33360 = true;
	                break;
	            }
	            case 8u:
	            {
	                uint _32839 = 1651u + (_12091 % 23u);
	                uint _32840 = _32839 / 2u;
	                uint _32850;
	                if ((_32839 & 1u) != 0u)
	                {
	                    _32850 = g_ScrambledHaltonPermutations.Load(_32840 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _32850 = g_ScrambledHaltonPermutations.Load(_32840 * 4 + 0) & 65535u;
	                }
	                uint _32854 = 1651u + ((_12091 / 23u) % 23u);
	                uint _32855 = _32854 / 2u;
	                uint _32865;
	                if ((_32854 & 1u) != 0u)
	                {
	                    _32865 = g_ScrambledHaltonPermutations.Load(_32855 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _32865 = g_ScrambledHaltonPermutations.Load(_32855 * 4 + 0) & 65535u;
	                }
	                uint _32869 = 1651u + ((_12091 / 529u) % 23u);
	                uint _32870 = _32869 / 2u;
	                uint _32880;
	                if ((_32869 & 1u) != 0u)
	                {
	                    _32880 = g_ScrambledHaltonPermutations.Load(_32870 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _32880 = g_ScrambledHaltonPermutations.Load(_32870 * 4 + 0) & 65535u;
	                }
	                uint _32884 = 1651u + ((_12091 / 12167u) % 23u);
	                uint _32885 = _32884 / 2u;
	                uint _32895;
	                if ((_32884 & 1u) != 0u)
	                {
	                    _32895 = g_ScrambledHaltonPermutations.Load(_32885 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _32895 = g_ScrambledHaltonPermutations.Load(_32885 * 4 + 0) & 65535u;
	                }
	                uint _32899 = 1651u + ((_12091 / 279841u) % 23u);
	                uint _32900 = _32899 / 2u;
	                uint _32910;
	                if ((_32899 & 1u) != 0u)
	                {
	                    _32910 = g_ScrambledHaltonPermutations.Load(_32900 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _32910 = g_ScrambledHaltonPermutations.Load(_32900 * 4 + 0) & 65535u;
	                }
	                uint _32914 = 1651u + ((_12091 / 6436343u) % 23u);
	                uint _32915 = _32914 / 2u;
	                uint _32925;
	                if ((_32914 & 1u) != 0u)
	                {
	                    _32925 = g_ScrambledHaltonPermutations.Load(_32915 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _32925 = g_ScrambledHaltonPermutations.Load(_32915 * 4 + 0) & 65535u;
	                }
	                uint _32929 = 1651u + ((_12091 / 148035889u) % 23u);
	                uint _32930 = _32929 / 2u;
	                uint _32940;
	                if ((_32929 & 1u) != 0u)
	                {
	                    _32940 = g_ScrambledHaltonPermutations.Load(_32930 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _32940 = g_ScrambledHaltonPermutations.Load(_32930 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((((((_32850 * 148035889u) + (_32865 * 6436343u)) + (_32880 * 279841u)) + (_32895 * 12167u)) + (_32910 * 529u)) + (_32925 * 23u)) + _32940) * 2.9370078591384185529022943228483e-10f;
	                _33360 = true;
	                break;
	            }
	            case 9u:
	            {
	                uint _32747 = 1674u + (_12091 % 29u);
	                uint _32748 = _32747 / 2u;
	                uint _32758;
	                if ((_32747 & 1u) != 0u)
	                {
	                    _32758 = g_ScrambledHaltonPermutations.Load(_32748 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _32758 = g_ScrambledHaltonPermutations.Load(_32748 * 4 + 0) & 65535u;
	                }
	                uint _32762 = 1674u + ((_12091 / 29u) % 29u);
	                uint _32763 = _32762 / 2u;
	                uint _32773;
	                if ((_32762 & 1u) != 0u)
	                {
	                    _32773 = g_ScrambledHaltonPermutations.Load(_32763 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _32773 = g_ScrambledHaltonPermutations.Load(_32763 * 4 + 0) & 65535u;
	                }
	                uint _32777 = 1674u + ((_12091 / 841u) % 29u);
	                uint _32778 = _32777 / 2u;
	                uint _32788;
	                if ((_32777 & 1u) != 0u)
	                {
	                    _32788 = g_ScrambledHaltonPermutations.Load(_32778 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _32788 = g_ScrambledHaltonPermutations.Load(_32778 * 4 + 0) & 65535u;
	                }
	                uint _32792 = 1674u + ((_12091 / 24389u) % 29u);
	                uint _32793 = _32792 / 2u;
	                uint _32803;
	                if ((_32792 & 1u) != 0u)
	                {
	                    _32803 = g_ScrambledHaltonPermutations.Load(_32793 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _32803 = g_ScrambledHaltonPermutations.Load(_32793 * 4 + 0) & 65535u;
	                }
	                uint _32807 = 1674u + ((_12091 / 707281u) % 29u);
	                uint _32808 = _32807 / 2u;
	                uint _32818;
	                if ((_32807 & 1u) != 0u)
	                {
	                    _32818 = g_ScrambledHaltonPermutations.Load(_32808 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _32818 = g_ScrambledHaltonPermutations.Load(_32808 * 4 + 0) & 65535u;
	                }
	                uint _32822 = 1674u + ((_12091 / 20511149u) % 29u);
	                uint _32823 = _32822 / 2u;
	                uint _32833;
	                if ((_32822 & 1u) != 0u)
	                {
	                    _32833 = g_ScrambledHaltonPermutations.Load(_32823 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _32833 = g_ScrambledHaltonPermutations.Load(_32823 * 4 + 0) & 65535u;
	                }
	                _33359 = float((((((_32758 * 20511149u) + (_32773 * 707281u)) + (_32788 * 24389u)) + (_32803 * 841u)) + (_32818 * 29u)) + _32833) * 1.6811713132725003561063203960657e-09f;
	                _33360 = true;
	                break;
	            }
	            case 10u:
	            {
	                uint _32655 = 1703u + (_12091 % 31u);
	                uint _32656 = _32655 / 2u;
	                uint _32666;
	                if ((_32655 & 1u) != 0u)
	                {
	                    _32666 = g_ScrambledHaltonPermutations.Load(_32656 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _32666 = g_ScrambledHaltonPermutations.Load(_32656 * 4 + 0) & 65535u;
	                }
	                uint _32670 = 1703u + ((_12091 / 31u) % 31u);
	                uint _32671 = _32670 / 2u;
	                uint _32681;
	                if ((_32670 & 1u) != 0u)
	                {
	                    _32681 = g_ScrambledHaltonPermutations.Load(_32671 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _32681 = g_ScrambledHaltonPermutations.Load(_32671 * 4 + 0) & 65535u;
	                }
	                uint _32685 = 1703u + ((_12091 / 961u) % 31u);
	                uint _32686 = _32685 / 2u;
	                uint _32696;
	                if ((_32685 & 1u) != 0u)
	                {
	                    _32696 = g_ScrambledHaltonPermutations.Load(_32686 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _32696 = g_ScrambledHaltonPermutations.Load(_32686 * 4 + 0) & 65535u;
	                }
	                uint _32700 = 1703u + ((_12091 / 29791u) % 31u);
	                uint _32701 = _32700 / 2u;
	                uint _32711;
	                if ((_32700 & 1u) != 0u)
	                {
	                    _32711 = g_ScrambledHaltonPermutations.Load(_32701 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _32711 = g_ScrambledHaltonPermutations.Load(_32701 * 4 + 0) & 65535u;
	                }
	                uint _32715 = 1703u + ((_12091 / 923521u) % 31u);
	                uint _32716 = _32715 / 2u;
	                uint _32726;
	                if ((_32715 & 1u) != 0u)
	                {
	                    _32726 = g_ScrambledHaltonPermutations.Load(_32716 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _32726 = g_ScrambledHaltonPermutations.Load(_32716 * 4 + 0) & 65535u;
	                }
	                uint _32730 = 1703u + ((_12091 / 28629151u) % 31u);
	                uint _32731 = _32730 / 2u;
	                uint _32741;
	                if ((_32730 & 1u) != 0u)
	                {
	                    _32741 = g_ScrambledHaltonPermutations.Load(_32731 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _32741 = g_ScrambledHaltonPermutations.Load(_32731 * 4 + 0) & 65535u;
	                }
	                _33359 = float((((((_32666 * 28629151u) + (_32681 * 923521u)) + (_32696 * 29791u)) + (_32711 * 961u)) + (_32726 * 31u)) + _32741) * 1.126755799774059596529696136713e-09f;
	                _33360 = true;
	                break;
	            }
	            case 11u:
	            {
	                uint _32563 = 1734u + (_12091 % 37u);
	                uint _32564 = _32563 / 2u;
	                uint _32574;
	                if ((_32563 & 1u) != 0u)
	                {
	                    _32574 = g_ScrambledHaltonPermutations.Load(_32564 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _32574 = g_ScrambledHaltonPermutations.Load(_32564 * 4 + 0) & 65535u;
	                }
	                uint _32578 = 1734u + ((_12091 / 37u) % 37u);
	                uint _32579 = _32578 / 2u;
	                uint _32589;
	                if ((_32578 & 1u) != 0u)
	                {
	                    _32589 = g_ScrambledHaltonPermutations.Load(_32579 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _32589 = g_ScrambledHaltonPermutations.Load(_32579 * 4 + 0) & 65535u;
	                }
	                uint _32593 = 1734u + ((_12091 / 1369u) % 37u);
	                uint _32594 = _32593 / 2u;
	                uint _32604;
	                if ((_32593 & 1u) != 0u)
	                {
	                    _32604 = g_ScrambledHaltonPermutations.Load(_32594 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _32604 = g_ScrambledHaltonPermutations.Load(_32594 * 4 + 0) & 65535u;
	                }
	                uint _32608 = 1734u + ((_12091 / 50653u) % 37u);
	                uint _32609 = _32608 / 2u;
	                uint _32619;
	                if ((_32608 & 1u) != 0u)
	                {
	                    _32619 = g_ScrambledHaltonPermutations.Load(_32609 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _32619 = g_ScrambledHaltonPermutations.Load(_32609 * 4 + 0) & 65535u;
	                }
	                uint _32623 = 1734u + ((_12091 / 1874161u) % 37u);
	                uint _32624 = _32623 / 2u;
	                uint _32634;
	                if ((_32623 & 1u) != 0u)
	                {
	                    _32634 = g_ScrambledHaltonPermutations.Load(_32624 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _32634 = g_ScrambledHaltonPermutations.Load(_32624 * 4 + 0) & 65535u;
	                }
	                uint _32638 = 1734u + ((_12091 / 69343957u) % 37u);
	                uint _32639 = _32638 / 2u;
	                uint _32649;
	                if ((_32638 & 1u) != 0u)
	                {
	                    _32649 = g_ScrambledHaltonPermutations.Load(_32639 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _32649 = g_ScrambledHaltonPermutations.Load(_32639 * 4 + 0) & 65535u;
	                }
	                _33359 = float((((((_32574 * 69343957u) + (_32589 * 1874161u)) + (_32604 * 50653u)) + (_32619 * 1369u)) + (_32634 * 37u)) + _32649) * 3.8975311866806805483065545558929e-10f;
	                _33360 = true;
	                break;
	            }
	            case 12u:
	            {
	                uint _32486 = 1771u + (_12091 % 41u);
	                uint _32487 = _32486 / 2u;
	                uint _32497;
	                if ((_32486 & 1u) != 0u)
	                {
	                    _32497 = g_ScrambledHaltonPermutations.Load(_32487 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _32497 = g_ScrambledHaltonPermutations.Load(_32487 * 4 + 0) & 65535u;
	                }
	                uint _32501 = 1771u + ((_12091 / 41u) % 41u);
	                uint _32502 = _32501 / 2u;
	                uint _32512;
	                if ((_32501 & 1u) != 0u)
	                {
	                    _32512 = g_ScrambledHaltonPermutations.Load(_32502 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _32512 = g_ScrambledHaltonPermutations.Load(_32502 * 4 + 0) & 65535u;
	                }
	                uint _32516 = 1771u + ((_12091 / 1681u) % 41u);
	                uint _32517 = _32516 / 2u;
	                uint _32527;
	                if ((_32516 & 1u) != 0u)
	                {
	                    _32527 = g_ScrambledHaltonPermutations.Load(_32517 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _32527 = g_ScrambledHaltonPermutations.Load(_32517 * 4 + 0) & 65535u;
	                }
	                uint _32531 = 1771u + ((_12091 / 68921u) % 41u);
	                uint _32532 = _32531 / 2u;
	                uint _32542;
	                if ((_32531 & 1u) != 0u)
	                {
	                    _32542 = g_ScrambledHaltonPermutations.Load(_32532 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _32542 = g_ScrambledHaltonPermutations.Load(_32532 * 4 + 0) & 65535u;
	                }
	                uint _32546 = 1771u + ((_12091 / 2825761u) % 41u);
	                uint _32547 = _32546 / 2u;
	                uint _32557;
	                if ((_32546 & 1u) != 0u)
	                {
	                    _32557 = g_ScrambledHaltonPermutations.Load(_32547 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _32557 = g_ScrambledHaltonPermutations.Load(_32547 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((((_32497 * 2825761u) + (_32512 * 68921u)) + (_32527 * 1681u)) + (_32542 * 41u)) + _32557) * 8.631388936919393017888069152832e-09f;
	                _33360 = true;
	                break;
	            }
	            case 13u:
	            {
	                uint _32409 = 1812u + (_12091 % 43u);
	                uint _32410 = _32409 / 2u;
	                uint _32420;
	                if ((_32409 & 1u) != 0u)
	                {
	                    _32420 = g_ScrambledHaltonPermutations.Load(_32410 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _32420 = g_ScrambledHaltonPermutations.Load(_32410 * 4 + 0) & 65535u;
	                }
	                uint _32424 = 1812u + ((_12091 / 43u) % 43u);
	                uint _32425 = _32424 / 2u;
	                uint _32435;
	                if ((_32424 & 1u) != 0u)
	                {
	                    _32435 = g_ScrambledHaltonPermutations.Load(_32425 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _32435 = g_ScrambledHaltonPermutations.Load(_32425 * 4 + 0) & 65535u;
	                }
	                uint _32439 = 1812u + ((_12091 / 1849u) % 43u);
	                uint _32440 = _32439 / 2u;
	                uint _32450;
	                if ((_32439 & 1u) != 0u)
	                {
	                    _32450 = g_ScrambledHaltonPermutations.Load(_32440 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _32450 = g_ScrambledHaltonPermutations.Load(_32440 * 4 + 0) & 65535u;
	                }
	                uint _32454 = 1812u + ((_12091 / 79507u) % 43u);
	                uint _32455 = _32454 / 2u;
	                uint _32465;
	                if ((_32454 & 1u) != 0u)
	                {
	                    _32465 = g_ScrambledHaltonPermutations.Load(_32455 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _32465 = g_ScrambledHaltonPermutations.Load(_32455 * 4 + 0) & 65535u;
	                }
	                uint _32469 = 1812u + ((_12091 / 3418801u) % 43u);
	                uint _32470 = _32469 / 2u;
	                uint _32480;
	                if ((_32469 & 1u) != 0u)
	                {
	                    _32480 = g_ScrambledHaltonPermutations.Load(_32470 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _32480 = g_ScrambledHaltonPermutations.Load(_32470 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((((_32420 * 3418801u) + (_32435 * 79507u)) + (_32450 * 1849u)) + (_32465 * 43u)) + _32480) * 6.8023293664509765221737325191498e-09f;
	                _33360 = true;
	                break;
	            }
	            case 14u:
	            {
	                uint _32332 = 1855u + (_12091 % 47u);
	                uint _32333 = _32332 / 2u;
	                uint _32343;
	                if ((_32332 & 1u) != 0u)
	                {
	                    _32343 = g_ScrambledHaltonPermutations.Load(_32333 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _32343 = g_ScrambledHaltonPermutations.Load(_32333 * 4 + 0) & 65535u;
	                }
	                uint _32347 = 1855u + ((_12091 / 47u) % 47u);
	                uint _32348 = _32347 / 2u;
	                uint _32358;
	                if ((_32347 & 1u) != 0u)
	                {
	                    _32358 = g_ScrambledHaltonPermutations.Load(_32348 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _32358 = g_ScrambledHaltonPermutations.Load(_32348 * 4 + 0) & 65535u;
	                }
	                uint _32362 = 1855u + ((_12091 / 2209u) % 47u);
	                uint _32363 = _32362 / 2u;
	                uint _32373;
	                if ((_32362 & 1u) != 0u)
	                {
	                    _32373 = g_ScrambledHaltonPermutations.Load(_32363 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _32373 = g_ScrambledHaltonPermutations.Load(_32363 * 4 + 0) & 65535u;
	                }
	                uint _32377 = 1855u + ((_12091 / 103823u) % 47u);
	                uint _32378 = _32377 / 2u;
	                uint _32388;
	                if ((_32377 & 1u) != 0u)
	                {
	                    _32388 = g_ScrambledHaltonPermutations.Load(_32378 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _32388 = g_ScrambledHaltonPermutations.Load(_32378 * 4 + 0) & 65535u;
	                }
	                uint _32392 = 1855u + ((_12091 / 4879681u) % 47u);
	                uint _32393 = _32392 / 2u;
	                uint _32403;
	                if ((_32392 & 1u) != 0u)
	                {
	                    _32403 = g_ScrambledHaltonPermutations.Load(_32393 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _32403 = g_ScrambledHaltonPermutations.Load(_32393 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((((_32343 * 4879681u) + (_32358 * 103823u)) + (_32373 * 2209u)) + (_32388 * 47u)) + _32403) * 4.3602428334565956902224570512772e-09f;
	                _33360 = true;
	                break;
	            }
	            case 15u:
	            {
	                uint _32255 = 1902u + (_12091 % 53u);
	                uint _32256 = _32255 / 2u;
	                uint _32266;
	                if ((_32255 & 1u) != 0u)
	                {
	                    _32266 = g_ScrambledHaltonPermutations.Load(_32256 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _32266 = g_ScrambledHaltonPermutations.Load(_32256 * 4 + 0) & 65535u;
	                }
	                uint _32270 = 1902u + ((_12091 / 53u) % 53u);
	                uint _32271 = _32270 / 2u;
	                uint _32281;
	                if ((_32270 & 1u) != 0u)
	                {
	                    _32281 = g_ScrambledHaltonPermutations.Load(_32271 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _32281 = g_ScrambledHaltonPermutations.Load(_32271 * 4 + 0) & 65535u;
	                }
	                uint _32285 = 1902u + ((_12091 / 2809u) % 53u);
	                uint _32286 = _32285 / 2u;
	                uint _32296;
	                if ((_32285 & 1u) != 0u)
	                {
	                    _32296 = g_ScrambledHaltonPermutations.Load(_32286 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _32296 = g_ScrambledHaltonPermutations.Load(_32286 * 4 + 0) & 65535u;
	                }
	                uint _32300 = 1902u + ((_12091 / 148877u) % 53u);
	                uint _32301 = _32300 / 2u;
	                uint _32311;
	                if ((_32300 & 1u) != 0u)
	                {
	                    _32311 = g_ScrambledHaltonPermutations.Load(_32301 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _32311 = g_ScrambledHaltonPermutations.Load(_32301 * 4 + 0) & 65535u;
	                }
	                uint _32315 = 1902u + ((_12091 / 7890481u) % 53u);
	                uint _32316 = _32315 / 2u;
	                uint _32326;
	                if ((_32315 & 1u) != 0u)
	                {
	                    _32326 = g_ScrambledHaltonPermutations.Load(_32316 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _32326 = g_ScrambledHaltonPermutations.Load(_32316 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((((_32266 * 7890481u) + (_32281 * 148877u)) + (_32296 * 2809u)) + (_32311 * 53u)) + _32326) * 2.3912258839686728606466203927994e-09f;
	                _33360 = true;
	                break;
	            }
	            case 16u:
	            {
	                uint _32178 = 1955u + (_12091 % 59u);
	                uint _32179 = _32178 / 2u;
	                uint _32189;
	                if ((_32178 & 1u) != 0u)
	                {
	                    _32189 = g_ScrambledHaltonPermutations.Load(_32179 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _32189 = g_ScrambledHaltonPermutations.Load(_32179 * 4 + 0) & 65535u;
	                }
	                uint _32193 = 1955u + ((_12091 / 59u) % 59u);
	                uint _32194 = _32193 / 2u;
	                uint _32204;
	                if ((_32193 & 1u) != 0u)
	                {
	                    _32204 = g_ScrambledHaltonPermutations.Load(_32194 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _32204 = g_ScrambledHaltonPermutations.Load(_32194 * 4 + 0) & 65535u;
	                }
	                uint _32208 = 1955u + ((_12091 / 3481u) % 59u);
	                uint _32209 = _32208 / 2u;
	                uint _32219;
	                if ((_32208 & 1u) != 0u)
	                {
	                    _32219 = g_ScrambledHaltonPermutations.Load(_32209 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _32219 = g_ScrambledHaltonPermutations.Load(_32209 * 4 + 0) & 65535u;
	                }
	                uint _32223 = 1955u + ((_12091 / 205379u) % 59u);
	                uint _32224 = _32223 / 2u;
	                uint _32234;
	                if ((_32223 & 1u) != 0u)
	                {
	                    _32234 = g_ScrambledHaltonPermutations.Load(_32224 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _32234 = g_ScrambledHaltonPermutations.Load(_32224 * 4 + 0) & 65535u;
	                }
	                uint _32238 = 1955u + ((_12091 / 12117361u) % 59u);
	                uint _32239 = _32238 / 2u;
	                uint _32249;
	                if ((_32238 & 1u) != 0u)
	                {
	                    _32249 = g_ScrambledHaltonPermutations.Load(_32239 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _32249 = g_ScrambledHaltonPermutations.Load(_32239 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((((_32189 * 12117361u) + (_32204 * 205379u)) + (_32219 * 3481u)) + (_32234 * 59u)) + _32249) * 1.3987493385769766973680816590786e-09f;
	                _33360 = true;
	                break;
	            }
	            case 17u:
	            {
	                uint _32101 = 2014u + (_12091 % 61u);
	                uint _32102 = _32101 / 2u;
	                uint _32112;
	                if ((_32101 & 1u) != 0u)
	                {
	                    _32112 = g_ScrambledHaltonPermutations.Load(_32102 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _32112 = g_ScrambledHaltonPermutations.Load(_32102 * 4 + 0) & 65535u;
	                }
	                uint _32116 = 2014u + ((_12091 / 61u) % 61u);
	                uint _32117 = _32116 / 2u;
	                uint _32127;
	                if ((_32116 & 1u) != 0u)
	                {
	                    _32127 = g_ScrambledHaltonPermutations.Load(_32117 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _32127 = g_ScrambledHaltonPermutations.Load(_32117 * 4 + 0) & 65535u;
	                }
	                uint _32131 = 2014u + ((_12091 / 3721u) % 61u);
	                uint _32132 = _32131 / 2u;
	                uint _32142;
	                if ((_32131 & 1u) != 0u)
	                {
	                    _32142 = g_ScrambledHaltonPermutations.Load(_32132 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _32142 = g_ScrambledHaltonPermutations.Load(_32132 * 4 + 0) & 65535u;
	                }
	                uint _32146 = 2014u + ((_12091 / 226981u) % 61u);
	                uint _32147 = _32146 / 2u;
	                uint _32157;
	                if ((_32146 & 1u) != 0u)
	                {
	                    _32157 = g_ScrambledHaltonPermutations.Load(_32147 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _32157 = g_ScrambledHaltonPermutations.Load(_32147 * 4 + 0) & 65535u;
	                }
	                uint _32161 = 2014u + ((_12091 / 13845841u) % 61u);
	                uint _32162 = _32161 / 2u;
	                uint _32172;
	                if ((_32161 & 1u) != 0u)
	                {
	                    _32172 = g_ScrambledHaltonPermutations.Load(_32162 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _32172 = g_ScrambledHaltonPermutations.Load(_32162 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((((_32112 * 13845841u) + (_32127 * 226981u)) + (_32142 * 3721u)) + (_32157 * 61u)) + _32172) * 1.1839974556338006550504360347986e-09f;
	                _33360 = true;
	                break;
	            }
	            case 18u:
	            {
	                uint _32024 = 2075u + (_12091 % 67u);
	                uint _32025 = _32024 / 2u;
	                uint _32035;
	                if ((_32024 & 1u) != 0u)
	                {
	                    _32035 = g_ScrambledHaltonPermutations.Load(_32025 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _32035 = g_ScrambledHaltonPermutations.Load(_32025 * 4 + 0) & 65535u;
	                }
	                uint _32039 = 2075u + ((_12091 / 67u) % 67u);
	                uint _32040 = _32039 / 2u;
	                uint _32050;
	                if ((_32039 & 1u) != 0u)
	                {
	                    _32050 = g_ScrambledHaltonPermutations.Load(_32040 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _32050 = g_ScrambledHaltonPermutations.Load(_32040 * 4 + 0) & 65535u;
	                }
	                uint _32054 = 2075u + ((_12091 / 4489u) % 67u);
	                uint _32055 = _32054 / 2u;
	                uint _32065;
	                if ((_32054 & 1u) != 0u)
	                {
	                    _32065 = g_ScrambledHaltonPermutations.Load(_32055 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _32065 = g_ScrambledHaltonPermutations.Load(_32055 * 4 + 0) & 65535u;
	                }
	                uint _32069 = 2075u + ((_12091 / 300763u) % 67u);
	                uint _32070 = _32069 / 2u;
	                uint _32080;
	                if ((_32069 & 1u) != 0u)
	                {
	                    _32080 = g_ScrambledHaltonPermutations.Load(_32070 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _32080 = g_ScrambledHaltonPermutations.Load(_32070 * 4 + 0) & 65535u;
	                }
	                uint _32084 = 2075u + ((_12091 / 20151121u) % 67u);
	                uint _32085 = _32084 / 2u;
	                uint _32095;
	                if ((_32084 & 1u) != 0u)
	                {
	                    _32095 = g_ScrambledHaltonPermutations.Load(_32085 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _32095 = g_ScrambledHaltonPermutations.Load(_32085 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((((_32035 * 20151121u) + (_32050 * 300763u)) + (_32065 * 4489u)) + (_32080 * 67u)) + _32095) * 7.4067202371352891532296780496836e-10f;
	                _33360 = true;
	                break;
	            }
	            case 19u:
	            {
	                uint _31947 = 2142u + (_12091 % 71u);
	                uint _31948 = _31947 / 2u;
	                uint _31958;
	                if ((_31947 & 1u) != 0u)
	                {
	                    _31958 = g_ScrambledHaltonPermutations.Load(_31948 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _31958 = g_ScrambledHaltonPermutations.Load(_31948 * 4 + 0) & 65535u;
	                }
	                uint _31962 = 2142u + ((_12091 / 71u) % 71u);
	                uint _31963 = _31962 / 2u;
	                uint _31973;
	                if ((_31962 & 1u) != 0u)
	                {
	                    _31973 = g_ScrambledHaltonPermutations.Load(_31963 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _31973 = g_ScrambledHaltonPermutations.Load(_31963 * 4 + 0) & 65535u;
	                }
	                uint _31977 = 2142u + ((_12091 / 5041u) % 71u);
	                uint _31978 = _31977 / 2u;
	                uint _31988;
	                if ((_31977 & 1u) != 0u)
	                {
	                    _31988 = g_ScrambledHaltonPermutations.Load(_31978 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _31988 = g_ScrambledHaltonPermutations.Load(_31978 * 4 + 0) & 65535u;
	                }
	                uint _31992 = 2142u + ((_12091 / 357911u) % 71u);
	                uint _31993 = _31992 / 2u;
	                uint _32003;
	                if ((_31992 & 1u) != 0u)
	                {
	                    _32003 = g_ScrambledHaltonPermutations.Load(_31993 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _32003 = g_ScrambledHaltonPermutations.Load(_31993 * 4 + 0) & 65535u;
	                }
	                uint _32007 = 2142u + ((_12091 / 25411681u) % 71u);
	                uint _32008 = _32007 / 2u;
	                uint _32018;
	                if ((_32007 & 1u) != 0u)
	                {
	                    _32018 = g_ScrambledHaltonPermutations.Load(_32008 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _32018 = g_ScrambledHaltonPermutations.Load(_32008 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((((_31958 * 25411681u) + (_31973 * 357911u)) + (_31988 * 5041u)) + (_32003 * 71u)) + _32018) * 5.5425319889224056169041432440281e-10f;
	                _33360 = true;
	                break;
	            }
	            case 20u:
	            {
	                uint _31870 = 2213u + (_12091 % 73u);
	                uint _31871 = _31870 / 2u;
	                uint _31881;
	                if ((_31870 & 1u) != 0u)
	                {
	                    _31881 = g_ScrambledHaltonPermutations.Load(_31871 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _31881 = g_ScrambledHaltonPermutations.Load(_31871 * 4 + 0) & 65535u;
	                }
	                uint _31885 = 2213u + ((_12091 / 73u) % 73u);
	                uint _31886 = _31885 / 2u;
	                uint _31896;
	                if ((_31885 & 1u) != 0u)
	                {
	                    _31896 = g_ScrambledHaltonPermutations.Load(_31886 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _31896 = g_ScrambledHaltonPermutations.Load(_31886 * 4 + 0) & 65535u;
	                }
	                uint _31900 = 2213u + ((_12091 / 5329u) % 73u);
	                uint _31901 = _31900 / 2u;
	                uint _31911;
	                if ((_31900 & 1u) != 0u)
	                {
	                    _31911 = g_ScrambledHaltonPermutations.Load(_31901 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _31911 = g_ScrambledHaltonPermutations.Load(_31901 * 4 + 0) & 65535u;
	                }
	                uint _31915 = 2213u + ((_12091 / 389017u) % 73u);
	                uint _31916 = _31915 / 2u;
	                uint _31926;
	                if ((_31915 & 1u) != 0u)
	                {
	                    _31926 = g_ScrambledHaltonPermutations.Load(_31916 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _31926 = g_ScrambledHaltonPermutations.Load(_31916 * 4 + 0) & 65535u;
	                }
	                uint _31930 = 2213u + ((_12091 / 28398241u) % 73u);
	                uint _31931 = _31930 / 2u;
	                uint _31941;
	                if ((_31930 & 1u) != 0u)
	                {
	                    _31941 = g_ScrambledHaltonPermutations.Load(_31931 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _31941 = g_ScrambledHaltonPermutations.Load(_31931 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((((_31881 * 28398241u) + (_31896 * 389017u)) + (_31911 * 5329u)) + (_31926 * 73u)) + _31941) * 4.8237597249922714581771288067102e-10f;
	                _33360 = true;
	                break;
	            }
	            case 21u:
	            {
	                uint _31793 = 2286u + (_12091 % 79u);
	                uint _31794 = _31793 / 2u;
	                uint _31804;
	                if ((_31793 & 1u) != 0u)
	                {
	                    _31804 = g_ScrambledHaltonPermutations.Load(_31794 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _31804 = g_ScrambledHaltonPermutations.Load(_31794 * 4 + 0) & 65535u;
	                }
	                uint _31808 = 2286u + ((_12091 / 79u) % 79u);
	                uint _31809 = _31808 / 2u;
	                uint _31819;
	                if ((_31808 & 1u) != 0u)
	                {
	                    _31819 = g_ScrambledHaltonPermutations.Load(_31809 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _31819 = g_ScrambledHaltonPermutations.Load(_31809 * 4 + 0) & 65535u;
	                }
	                uint _31823 = 2286u + ((_12091 / 6241u) % 79u);
	                uint _31824 = _31823 / 2u;
	                uint _31834;
	                if ((_31823 & 1u) != 0u)
	                {
	                    _31834 = g_ScrambledHaltonPermutations.Load(_31824 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _31834 = g_ScrambledHaltonPermutations.Load(_31824 * 4 + 0) & 65535u;
	                }
	                uint _31838 = 2286u + ((_12091 / 493039u) % 79u);
	                uint _31839 = _31838 / 2u;
	                uint _31849;
	                if ((_31838 & 1u) != 0u)
	                {
	                    _31849 = g_ScrambledHaltonPermutations.Load(_31839 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _31849 = g_ScrambledHaltonPermutations.Load(_31839 * 4 + 0) & 65535u;
	                }
	                uint _31853 = 2286u + ((_12091 / 38950081u) % 79u);
	                uint _31854 = _31853 / 2u;
	                uint _31864;
	                if ((_31853 & 1u) != 0u)
	                {
	                    _31864 = g_ScrambledHaltonPermutations.Load(_31854 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _31864 = g_ScrambledHaltonPermutations.Load(_31854 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((((_31804 * 38950081u) + (_31819 * 493039u)) + (_31834 * 6241u)) + (_31849 * 79u)) + _31864) * 3.2498587154705660395848099142313e-10f;
	                _33360 = true;
	                break;
	            }
	            case 22u:
	            {
	                uint _31716 = 2365u + (_12091 % 83u);
	                uint _31717 = _31716 / 2u;
	                uint _31727;
	                if ((_31716 & 1u) != 0u)
	                {
	                    _31727 = g_ScrambledHaltonPermutations.Load(_31717 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _31727 = g_ScrambledHaltonPermutations.Load(_31717 * 4 + 0) & 65535u;
	                }
	                uint _31731 = 2365u + ((_12091 / 83u) % 83u);
	                uint _31732 = _31731 / 2u;
	                uint _31742;
	                if ((_31731 & 1u) != 0u)
	                {
	                    _31742 = g_ScrambledHaltonPermutations.Load(_31732 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _31742 = g_ScrambledHaltonPermutations.Load(_31732 * 4 + 0) & 65535u;
	                }
	                uint _31746 = 2365u + ((_12091 / 6889u) % 83u);
	                uint _31747 = _31746 / 2u;
	                uint _31757;
	                if ((_31746 & 1u) != 0u)
	                {
	                    _31757 = g_ScrambledHaltonPermutations.Load(_31747 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _31757 = g_ScrambledHaltonPermutations.Load(_31747 * 4 + 0) & 65535u;
	                }
	                uint _31761 = 2365u + ((_12091 / 571787u) % 83u);
	                uint _31762 = _31761 / 2u;
	                uint _31772;
	                if ((_31761 & 1u) != 0u)
	                {
	                    _31772 = g_ScrambledHaltonPermutations.Load(_31762 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _31772 = g_ScrambledHaltonPermutations.Load(_31762 * 4 + 0) & 65535u;
	                }
	                uint _31776 = 2365u + ((_12091 / 47458321u) % 83u);
	                uint _31777 = _31776 / 2u;
	                uint _31787;
	                if ((_31776 & 1u) != 0u)
	                {
	                    _31787 = g_ScrambledHaltonPermutations.Load(_31777 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _31787 = g_ScrambledHaltonPermutations.Load(_31777 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((((_31727 * 47458321u) + (_31742 * 571787u)) + (_31757 * 6889u)) + (_31772 * 83u)) + _31787) * 2.5386887037015526402683462947607e-10f;
	                _33360 = true;
	                break;
	            }
	            case 23u:
	            {
	                uint _31654 = 2448u + (_12091 % 89u);
	                uint _31655 = _31654 / 2u;
	                uint _31665;
	                if ((_31654 & 1u) != 0u)
	                {
	                    _31665 = g_ScrambledHaltonPermutations.Load(_31655 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _31665 = g_ScrambledHaltonPermutations.Load(_31655 * 4 + 0) & 65535u;
	                }
	                uint _31669 = 2448u + ((_12091 / 89u) % 89u);
	                uint _31670 = _31669 / 2u;
	                uint _31680;
	                if ((_31669 & 1u) != 0u)
	                {
	                    _31680 = g_ScrambledHaltonPermutations.Load(_31670 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _31680 = g_ScrambledHaltonPermutations.Load(_31670 * 4 + 0) & 65535u;
	                }
	                uint _31684 = 2448u + ((_12091 / 7921u) % 89u);
	                uint _31685 = _31684 / 2u;
	                uint _31695;
	                if ((_31684 & 1u) != 0u)
	                {
	                    _31695 = g_ScrambledHaltonPermutations.Load(_31685 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _31695 = g_ScrambledHaltonPermutations.Load(_31685 * 4 + 0) & 65535u;
	                }
	                uint _31699 = 2448u + ((_12091 / 704969u) % 89u);
	                uint _31700 = _31699 / 2u;
	                uint _31710;
	                if ((_31699 & 1u) != 0u)
	                {
	                    _31710 = g_ScrambledHaltonPermutations.Load(_31700 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _31710 = g_ScrambledHaltonPermutations.Load(_31700 * 4 + 0) & 65535u;
	                }
	                _33359 = float((((_31665 * 704969u) + (_31680 * 7921u)) + (_31695 * 89u)) + _31710) * 1.593822496204211347503587603569e-08f;
	                _33360 = true;
	                break;
	            }
	            case 24u:
	            {
	                uint _31592 = 2537u + (_12091 % 97u);
	                uint _31593 = _31592 / 2u;
	                uint _31603;
	                if ((_31592 & 1u) != 0u)
	                {
	                    _31603 = g_ScrambledHaltonPermutations.Load(_31593 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _31603 = g_ScrambledHaltonPermutations.Load(_31593 * 4 + 0) & 65535u;
	                }
	                uint _31607 = 2537u + ((_12091 / 97u) % 97u);
	                uint _31608 = _31607 / 2u;
	                uint _31618;
	                if ((_31607 & 1u) != 0u)
	                {
	                    _31618 = g_ScrambledHaltonPermutations.Load(_31608 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _31618 = g_ScrambledHaltonPermutations.Load(_31608 * 4 + 0) & 65535u;
	                }
	                uint _31622 = 2537u + ((_12091 / 9409u) % 97u);
	                uint _31623 = _31622 / 2u;
	                uint _31633;
	                if ((_31622 & 1u) != 0u)
	                {
	                    _31633 = g_ScrambledHaltonPermutations.Load(_31623 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _31633 = g_ScrambledHaltonPermutations.Load(_31623 * 4 + 0) & 65535u;
	                }
	                uint _31637 = 2537u + ((_12091 / 912673u) % 97u);
	                uint _31638 = _31637 / 2u;
	                uint _31648;
	                if ((_31637 & 1u) != 0u)
	                {
	                    _31648 = g_ScrambledHaltonPermutations.Load(_31638 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _31648 = g_ScrambledHaltonPermutations.Load(_31638 * 4 + 0) & 65535u;
	                }
	                _33359 = float((((_31603 * 912673u) + (_31618 * 9409u)) + (_31633 * 97u)) + _31648) * 1.1295696822344325482845306396484e-08f;
	                _33360 = true;
	                break;
	            }
	            case 25u:
	            {
	                uint _31530 = 2634u + (_12091 % 101u);
	                uint _31531 = _31530 / 2u;
	                uint _31541;
	                if ((_31530 & 1u) != 0u)
	                {
	                    _31541 = g_ScrambledHaltonPermutations.Load(_31531 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _31541 = g_ScrambledHaltonPermutations.Load(_31531 * 4 + 0) & 65535u;
	                }
	                uint _31545 = 2634u + ((_12091 / 101u) % 101u);
	                uint _31546 = _31545 / 2u;
	                uint _31556;
	                if ((_31545 & 1u) != 0u)
	                {
	                    _31556 = g_ScrambledHaltonPermutations.Load(_31546 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _31556 = g_ScrambledHaltonPermutations.Load(_31546 * 4 + 0) & 65535u;
	                }
	                uint _31560 = 2634u + ((_12091 / 10201u) % 101u);
	                uint _31561 = _31560 / 2u;
	                uint _31571;
	                if ((_31560 & 1u) != 0u)
	                {
	                    _31571 = g_ScrambledHaltonPermutations.Load(_31561 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _31571 = g_ScrambledHaltonPermutations.Load(_31561 * 4 + 0) & 65535u;
	                }
	                uint _31575 = 2634u + ((_12091 / 1030301u) % 101u);
	                uint _31576 = _31575 / 2u;
	                uint _31586;
	                if ((_31575 & 1u) != 0u)
	                {
	                    _31586 = g_ScrambledHaltonPermutations.Load(_31576 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _31586 = g_ScrambledHaltonPermutations.Load(_31576 * 4 + 0) & 65535u;
	                }
	                _33359 = float((((_31541 * 1030301u) + (_31556 * 10201u)) + (_31571 * 101u)) + _31586) * 9.6098027313473721733316779136658e-09f;
	                _33360 = true;
	                break;
	            }
	            case 26u:
	            {
	                uint _31468 = 2735u + (_12091 % 103u);
	                uint _31469 = _31468 / 2u;
	                uint _31479;
	                if ((_31468 & 1u) != 0u)
	                {
	                    _31479 = g_ScrambledHaltonPermutations.Load(_31469 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _31479 = g_ScrambledHaltonPermutations.Load(_31469 * 4 + 0) & 65535u;
	                }
	                uint _31483 = 2735u + ((_12091 / 103u) % 103u);
	                uint _31484 = _31483 / 2u;
	                uint _31494;
	                if ((_31483 & 1u) != 0u)
	                {
	                    _31494 = g_ScrambledHaltonPermutations.Load(_31484 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _31494 = g_ScrambledHaltonPermutations.Load(_31484 * 4 + 0) & 65535u;
	                }
	                uint _31498 = 2735u + ((_12091 / 10609u) % 103u);
	                uint _31499 = _31498 / 2u;
	                uint _31509;
	                if ((_31498 & 1u) != 0u)
	                {
	                    _31509 = g_ScrambledHaltonPermutations.Load(_31499 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _31509 = g_ScrambledHaltonPermutations.Load(_31499 * 4 + 0) & 65535u;
	                }
	                uint _31513 = 2735u + ((_12091 / 1092727u) % 103u);
	                uint _31514 = _31513 / 2u;
	                uint _31524;
	                if ((_31513 & 1u) != 0u)
	                {
	                    _31524 = g_ScrambledHaltonPermutations.Load(_31514 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _31524 = g_ScrambledHaltonPermutations.Load(_31514 * 4 + 0) & 65535u;
	                }
	                _33359 = float((((_31479 * 1092727u) + (_31494 * 10609u)) + (_31509 * 103u)) + _31524) * 8.8848697288312905584461987018585e-09f;
	                _33360 = true;
	                break;
	            }
	            case 27u:
	            {
	                uint _31406 = 2838u + (_12091 % 107u);
	                uint _31407 = _31406 / 2u;
	                uint _31417;
	                if ((_31406 & 1u) != 0u)
	                {
	                    _31417 = g_ScrambledHaltonPermutations.Load(_31407 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _31417 = g_ScrambledHaltonPermutations.Load(_31407 * 4 + 0) & 65535u;
	                }
	                uint _31421 = 2838u + ((_12091 / 107u) % 107u);
	                uint _31422 = _31421 / 2u;
	                uint _31432;
	                if ((_31421 & 1u) != 0u)
	                {
	                    _31432 = g_ScrambledHaltonPermutations.Load(_31422 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _31432 = g_ScrambledHaltonPermutations.Load(_31422 * 4 + 0) & 65535u;
	                }
	                uint _31436 = 2838u + ((_12091 / 11449u) % 107u);
	                uint _31437 = _31436 / 2u;
	                uint _31447;
	                if ((_31436 & 1u) != 0u)
	                {
	                    _31447 = g_ScrambledHaltonPermutations.Load(_31437 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _31447 = g_ScrambledHaltonPermutations.Load(_31437 * 4 + 0) & 65535u;
	                }
	                uint _31451 = 2838u + ((_12091 / 1225043u) % 107u);
	                uint _31452 = _31451 / 2u;
	                uint _31462;
	                if ((_31451 & 1u) != 0u)
	                {
	                    _31462 = g_ScrambledHaltonPermutations.Load(_31452 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _31462 = g_ScrambledHaltonPermutations.Load(_31452 * 4 + 0) & 65535u;
	                }
	                _33359 = float((((_31417 * 1225043u) + (_31432 * 11449u)) + (_31447 * 107u)) + _31462) * 7.6289516925953648751601576805115e-09f;
	                _33360 = true;
	                break;
	            }
	            case 28u:
	            {
	                uint _31344 = 2945u + (_12091 % 109u);
	                uint _31345 = _31344 / 2u;
	                uint _31355;
	                if ((_31344 & 1u) != 0u)
	                {
	                    _31355 = g_ScrambledHaltonPermutations.Load(_31345 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _31355 = g_ScrambledHaltonPermutations.Load(_31345 * 4 + 0) & 65535u;
	                }
	                uint _31359 = 2945u + ((_12091 / 109u) % 109u);
	                uint _31360 = _31359 / 2u;
	                uint _31370;
	                if ((_31359 & 1u) != 0u)
	                {
	                    _31370 = g_ScrambledHaltonPermutations.Load(_31360 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _31370 = g_ScrambledHaltonPermutations.Load(_31360 * 4 + 0) & 65535u;
	                }
	                uint _31374 = 2945u + ((_12091 / 11881u) % 109u);
	                uint _31375 = _31374 / 2u;
	                uint _31385;
	                if ((_31374 & 1u) != 0u)
	                {
	                    _31385 = g_ScrambledHaltonPermutations.Load(_31375 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _31385 = g_ScrambledHaltonPermutations.Load(_31375 * 4 + 0) & 65535u;
	                }
	                uint _31389 = 2945u + ((_12091 / 1295029u) % 109u);
	                uint _31390 = _31389 / 2u;
	                uint _31400;
	                if ((_31389 & 1u) != 0u)
	                {
	                    _31400 = g_ScrambledHaltonPermutations.Load(_31390 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _31400 = g_ScrambledHaltonPermutations.Load(_31390 * 4 + 0) & 65535u;
	                }
	                _33359 = float((((_31355 * 1295029u) + (_31370 * 11881u)) + (_31385 * 109u)) + _31400) * 7.0842514077185114729218184947968e-09f;
	                _33360 = true;
	                break;
	            }
	            case 29u:
	            {
	                uint _31282 = 3054u + (_12091 % 113u);
	                uint _31283 = _31282 / 2u;
	                uint _31293;
	                if ((_31282 & 1u) != 0u)
	                {
	                    _31293 = g_ScrambledHaltonPermutations.Load(_31283 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _31293 = g_ScrambledHaltonPermutations.Load(_31283 * 4 + 0) & 65535u;
	                }
	                uint _31297 = 3054u + ((_12091 / 113u) % 113u);
	                uint _31298 = _31297 / 2u;
	                uint _31308;
	                if ((_31297 & 1u) != 0u)
	                {
	                    _31308 = g_ScrambledHaltonPermutations.Load(_31298 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _31308 = g_ScrambledHaltonPermutations.Load(_31298 * 4 + 0) & 65535u;
	                }
	                uint _31312 = 3054u + ((_12091 / 12769u) % 113u);
	                uint _31313 = _31312 / 2u;
	                uint _31323;
	                if ((_31312 & 1u) != 0u)
	                {
	                    _31323 = g_ScrambledHaltonPermutations.Load(_31313 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _31323 = g_ScrambledHaltonPermutations.Load(_31313 * 4 + 0) & 65535u;
	                }
	                uint _31327 = 3054u + ((_12091 / 1442897u) % 113u);
	                uint _31328 = _31327 / 2u;
	                uint _31338;
	                if ((_31327 & 1u) != 0u)
	                {
	                    _31338 = g_ScrambledHaltonPermutations.Load(_31328 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _31338 = g_ScrambledHaltonPermutations.Load(_31328 * 4 + 0) & 65535u;
	                }
	                _33359 = float((((_31293 * 1442897u) + (_31308 * 12769u)) + (_31323 * 113u)) + _31338) * 6.1331864031899385736323893070221e-09f;
	                _33360 = true;
	                break;
	            }
	            case 30u:
	            {
	                uint _31220 = 3167u + (_12091 % 127u);
	                uint _31221 = _31220 / 2u;
	                uint _31231;
	                if ((_31220 & 1u) != 0u)
	                {
	                    _31231 = g_ScrambledHaltonPermutations.Load(_31221 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _31231 = g_ScrambledHaltonPermutations.Load(_31221 * 4 + 0) & 65535u;
	                }
	                uint _31235 = 3167u + ((_12091 / 127u) % 127u);
	                uint _31236 = _31235 / 2u;
	                uint _31246;
	                if ((_31235 & 1u) != 0u)
	                {
	                    _31246 = g_ScrambledHaltonPermutations.Load(_31236 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _31246 = g_ScrambledHaltonPermutations.Load(_31236 * 4 + 0) & 65535u;
	                }
	                uint _31250 = 3167u + ((_12091 / 16129u) % 127u);
	                uint _31251 = _31250 / 2u;
	                uint _31261;
	                if ((_31250 & 1u) != 0u)
	                {
	                    _31261 = g_ScrambledHaltonPermutations.Load(_31251 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _31261 = g_ScrambledHaltonPermutations.Load(_31251 * 4 + 0) & 65535u;
	                }
	                uint _31265 = 3167u + ((_12091 / 2048383u) % 127u);
	                uint _31266 = _31265 / 2u;
	                uint _31276;
	                if ((_31265 & 1u) != 0u)
	                {
	                    _31276 = g_ScrambledHaltonPermutations.Load(_31266 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _31276 = g_ScrambledHaltonPermutations.Load(_31266 * 4 + 0) & 65535u;
	                }
	                _33359 = float((((_31231 * 2048383u) + (_31246 * 16129u)) + (_31261 * 127u)) + _31276) * 3.8440148841800692025572061538696e-09f;
	                _33360 = true;
	                break;
	            }
	            case 31u:
	            {
	                uint _31158 = 3294u + (_12091 % 131u);
	                uint _31159 = _31158 / 2u;
	                uint _31169;
	                if ((_31158 & 1u) != 0u)
	                {
	                    _31169 = g_ScrambledHaltonPermutations.Load(_31159 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _31169 = g_ScrambledHaltonPermutations.Load(_31159 * 4 + 0) & 65535u;
	                }
	                uint _31173 = 3294u + ((_12091 / 131u) % 131u);
	                uint _31174 = _31173 / 2u;
	                uint _31184;
	                if ((_31173 & 1u) != 0u)
	                {
	                    _31184 = g_ScrambledHaltonPermutations.Load(_31174 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _31184 = g_ScrambledHaltonPermutations.Load(_31174 * 4 + 0) & 65535u;
	                }
	                uint _31188 = 3294u + ((_12091 / 17161u) % 131u);
	                uint _31189 = _31188 / 2u;
	                uint _31199;
	                if ((_31188 & 1u) != 0u)
	                {
	                    _31199 = g_ScrambledHaltonPermutations.Load(_31189 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _31199 = g_ScrambledHaltonPermutations.Load(_31189 * 4 + 0) & 65535u;
	                }
	                uint _31203 = 3294u + ((_12091 / 2248091u) % 131u);
	                uint _31204 = _31203 / 2u;
	                uint _31214;
	                if ((_31203 & 1u) != 0u)
	                {
	                    _31214 = g_ScrambledHaltonPermutations.Load(_31204 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _31214 = g_ScrambledHaltonPermutations.Load(_31204 * 4 + 0) & 65535u;
	                }
	                _33359 = float((((_31169 * 2248091u) + (_31184 * 17161u)) + (_31199 * 131u)) + _31214) * 3.3955860345713517745025455951691e-09f;
	                _33360 = true;
	                break;
	            }
	            case 32u:
	            {
	                uint _31096 = 3425u + (_12091 % 137u);
	                uint _31097 = _31096 / 2u;
	                uint _31107;
	                if ((_31096 & 1u) != 0u)
	                {
	                    _31107 = g_ScrambledHaltonPermutations.Load(_31097 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _31107 = g_ScrambledHaltonPermutations.Load(_31097 * 4 + 0) & 65535u;
	                }
	                uint _31111 = 3425u + ((_12091 / 137u) % 137u);
	                uint _31112 = _31111 / 2u;
	                uint _31122;
	                if ((_31111 & 1u) != 0u)
	                {
	                    _31122 = g_ScrambledHaltonPermutations.Load(_31112 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _31122 = g_ScrambledHaltonPermutations.Load(_31112 * 4 + 0) & 65535u;
	                }
	                uint _31126 = 3425u + ((_12091 / 18769u) % 137u);
	                uint _31127 = _31126 / 2u;
	                uint _31137;
	                if ((_31126 & 1u) != 0u)
	                {
	                    _31137 = g_ScrambledHaltonPermutations.Load(_31127 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _31137 = g_ScrambledHaltonPermutations.Load(_31127 * 4 + 0) & 65535u;
	                }
	                uint _31141 = 3425u + ((_12091 / 2571353u) % 137u);
	                uint _31142 = _31141 / 2u;
	                uint _31152;
	                if ((_31141 & 1u) != 0u)
	                {
	                    _31152 = g_ScrambledHaltonPermutations.Load(_31142 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _31152 = g_ScrambledHaltonPermutations.Load(_31142 * 4 + 0) & 65535u;
	                }
	                _33359 = float((((_31107 * 2571353u) + (_31122 * 18769u)) + (_31137 * 137u)) + _31152) * 2.8386881734121516274171881377697e-09f;
	                _33360 = true;
	                break;
	            }
	            case 33u:
	            {
	                uint _31034 = 3562u + (_12091 % 139u);
	                uint _31035 = _31034 / 2u;
	                uint _31045;
	                if ((_31034 & 1u) != 0u)
	                {
	                    _31045 = g_ScrambledHaltonPermutations.Load(_31035 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _31045 = g_ScrambledHaltonPermutations.Load(_31035 * 4 + 0) & 65535u;
	                }
	                uint _31049 = 3562u + ((_12091 / 139u) % 139u);
	                uint _31050 = _31049 / 2u;
	                uint _31060;
	                if ((_31049 & 1u) != 0u)
	                {
	                    _31060 = g_ScrambledHaltonPermutations.Load(_31050 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _31060 = g_ScrambledHaltonPermutations.Load(_31050 * 4 + 0) & 65535u;
	                }
	                uint _31064 = 3562u + ((_12091 / 19321u) % 139u);
	                uint _31065 = _31064 / 2u;
	                uint _31075;
	                if ((_31064 & 1u) != 0u)
	                {
	                    _31075 = g_ScrambledHaltonPermutations.Load(_31065 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _31075 = g_ScrambledHaltonPermutations.Load(_31065 * 4 + 0) & 65535u;
	                }
	                uint _31079 = 3562u + ((_12091 / 2685619u) % 139u);
	                uint _31080 = _31079 / 2u;
	                uint _31090;
	                if ((_31079 & 1u) != 0u)
	                {
	                    _31090 = g_ScrambledHaltonPermutations.Load(_31080 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _31090 = g_ScrambledHaltonPermutations.Load(_31080 * 4 + 0) & 65535u;
	                }
	                _33359 = float((((_31045 * 2685619u) + (_31060 * 19321u)) + (_31075 * 139u)) + _31090) * 2.6788027351898335837177000939846e-09f;
	                _33360 = true;
	                break;
	            }
	            case 34u:
	            {
	                uint _30972 = 3701u + (_12091 % 149u);
	                uint _30973 = _30972 / 2u;
	                uint _30983;
	                if ((_30972 & 1u) != 0u)
	                {
	                    _30983 = g_ScrambledHaltonPermutations.Load(_30973 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _30983 = g_ScrambledHaltonPermutations.Load(_30973 * 4 + 0) & 65535u;
	                }
	                uint _30987 = 3701u + ((_12091 / 149u) % 149u);
	                uint _30988 = _30987 / 2u;
	                uint _30998;
	                if ((_30987 & 1u) != 0u)
	                {
	                    _30998 = g_ScrambledHaltonPermutations.Load(_30988 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _30998 = g_ScrambledHaltonPermutations.Load(_30988 * 4 + 0) & 65535u;
	                }
	                uint _31002 = 3701u + ((_12091 / 22201u) % 149u);
	                uint _31003 = _31002 / 2u;
	                uint _31013;
	                if ((_31002 & 1u) != 0u)
	                {
	                    _31013 = g_ScrambledHaltonPermutations.Load(_31003 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _31013 = g_ScrambledHaltonPermutations.Load(_31003 * 4 + 0) & 65535u;
	                }
	                uint _31017 = 3701u + ((_12091 / 3307949u) % 149u);
	                uint _31018 = _31017 / 2u;
	                uint _31028;
	                if ((_31017 & 1u) != 0u)
	                {
	                    _31028 = g_ScrambledHaltonPermutations.Load(_31018 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _31028 = g_ScrambledHaltonPermutations.Load(_31018 * 4 + 0) & 65535u;
	                }
	                _33359 = float((((_30983 * 3307949u) + (_30998 * 22201u)) + (_31013 * 149u)) + _31028) * 2.0288730695483536692336201667786e-09f;
	                _33360 = true;
	                break;
	            }
	            case 35u:
	            {
	                uint _30910 = 3850u + (_12091 % 151u);
	                uint _30911 = _30910 / 2u;
	                uint _30921;
	                if ((_30910 & 1u) != 0u)
	                {
	                    _30921 = g_ScrambledHaltonPermutations.Load(_30911 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _30921 = g_ScrambledHaltonPermutations.Load(_30911 * 4 + 0) & 65535u;
	                }
	                uint _30925 = 3850u + ((_12091 / 151u) % 151u);
	                uint _30926 = _30925 / 2u;
	                uint _30936;
	                if ((_30925 & 1u) != 0u)
	                {
	                    _30936 = g_ScrambledHaltonPermutations.Load(_30926 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _30936 = g_ScrambledHaltonPermutations.Load(_30926 * 4 + 0) & 65535u;
	                }
	                uint _30940 = 3850u + ((_12091 / 22801u) % 151u);
	                uint _30941 = _30940 / 2u;
	                uint _30951;
	                if ((_30940 & 1u) != 0u)
	                {
	                    _30951 = g_ScrambledHaltonPermutations.Load(_30941 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _30951 = g_ScrambledHaltonPermutations.Load(_30941 * 4 + 0) & 65535u;
	                }
	                uint _30955 = 3850u + ((_12091 / 3442951u) % 151u);
	                uint _30956 = _30955 / 2u;
	                uint _30966;
	                if ((_30955 & 1u) != 0u)
	                {
	                    _30966 = g_ScrambledHaltonPermutations.Load(_30956 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _30966 = g_ScrambledHaltonPermutations.Load(_30956 * 4 + 0) & 65535u;
	                }
	                _33359 = float((((_30921 * 3442951u) + (_30936 * 22801u)) + (_30951 * 151u)) + _30966) * 1.9234998038797357367002405226231e-09f;
	                _33360 = true;
	                break;
	            }
	            case 36u:
	            {
	                uint _30848 = 4001u + (_12091 % 157u);
	                uint _30849 = _30848 / 2u;
	                uint _30859;
	                if ((_30848 & 1u) != 0u)
	                {
	                    _30859 = g_ScrambledHaltonPermutations.Load(_30849 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _30859 = g_ScrambledHaltonPermutations.Load(_30849 * 4 + 0) & 65535u;
	                }
	                uint _30863 = 4001u + ((_12091 / 157u) % 157u);
	                uint _30864 = _30863 / 2u;
	                uint _30874;
	                if ((_30863 & 1u) != 0u)
	                {
	                    _30874 = g_ScrambledHaltonPermutations.Load(_30864 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _30874 = g_ScrambledHaltonPermutations.Load(_30864 * 4 + 0) & 65535u;
	                }
	                uint _30878 = 4001u + ((_12091 / 24649u) % 157u);
	                uint _30879 = _30878 / 2u;
	                uint _30889;
	                if ((_30878 & 1u) != 0u)
	                {
	                    _30889 = g_ScrambledHaltonPermutations.Load(_30879 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _30889 = g_ScrambledHaltonPermutations.Load(_30879 * 4 + 0) & 65535u;
	                }
	                uint _30893 = 4001u + ((_12091 / 3869893u) % 157u);
	                uint _30894 = _30893 / 2u;
	                uint _30904;
	                if ((_30893 & 1u) != 0u)
	                {
	                    _30904 = g_ScrambledHaltonPermutations.Load(_30894 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _30904 = g_ScrambledHaltonPermutations.Load(_30894 * 4 + 0) & 65535u;
	                }
	                _33359 = float((((_30859 * 3869893u) + (_30874 * 24649u)) + (_30889 * 157u)) + _30904) * 1.6458920892858941442682407796383e-09f;
	                _33360 = true;
	                break;
	            }
	            case 37u:
	            {
	                uint _30786 = 4158u + (_12091 % 163u);
	                uint _30787 = _30786 / 2u;
	                uint _30797;
	                if ((_30786 & 1u) != 0u)
	                {
	                    _30797 = g_ScrambledHaltonPermutations.Load(_30787 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _30797 = g_ScrambledHaltonPermutations.Load(_30787 * 4 + 0) & 65535u;
	                }
	                uint _30801 = 4158u + ((_12091 / 163u) % 163u);
	                uint _30802 = _30801 / 2u;
	                uint _30812;
	                if ((_30801 & 1u) != 0u)
	                {
	                    _30812 = g_ScrambledHaltonPermutations.Load(_30802 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _30812 = g_ScrambledHaltonPermutations.Load(_30802 * 4 + 0) & 65535u;
	                }
	                uint _30816 = 4158u + ((_12091 / 26569u) % 163u);
	                uint _30817 = _30816 / 2u;
	                uint _30827;
	                if ((_30816 & 1u) != 0u)
	                {
	                    _30827 = g_ScrambledHaltonPermutations.Load(_30817 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _30827 = g_ScrambledHaltonPermutations.Load(_30817 * 4 + 0) & 65535u;
	                }
	                uint _30831 = 4158u + ((_12091 / 4330747u) % 163u);
	                uint _30832 = _30831 / 2u;
	                uint _30842;
	                if ((_30831 & 1u) != 0u)
	                {
	                    _30842 = g_ScrambledHaltonPermutations.Load(_30832 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _30842 = g_ScrambledHaltonPermutations.Load(_30832 * 4 + 0) & 65535u;
	                }
	                _33359 = float((((_30797 * 4330747u) + (_30812 * 26569u)) + (_30827 * 163u)) + _30842) * 1.4166074979726772653521038591862e-09f;
	                _33360 = true;
	                break;
	            }
	            case 38u:
	            {
	                uint _30724 = 4321u + (_12091 % 167u);
	                uint _30725 = _30724 / 2u;
	                uint _30735;
	                if ((_30724 & 1u) != 0u)
	                {
	                    _30735 = g_ScrambledHaltonPermutations.Load(_30725 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _30735 = g_ScrambledHaltonPermutations.Load(_30725 * 4 + 0) & 65535u;
	                }
	                uint _30739 = 4321u + ((_12091 / 167u) % 167u);
	                uint _30740 = _30739 / 2u;
	                uint _30750;
	                if ((_30739 & 1u) != 0u)
	                {
	                    _30750 = g_ScrambledHaltonPermutations.Load(_30740 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _30750 = g_ScrambledHaltonPermutations.Load(_30740 * 4 + 0) & 65535u;
	                }
	                uint _30754 = 4321u + ((_12091 / 27889u) % 167u);
	                uint _30755 = _30754 / 2u;
	                uint _30765;
	                if ((_30754 & 1u) != 0u)
	                {
	                    _30765 = g_ScrambledHaltonPermutations.Load(_30755 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _30765 = g_ScrambledHaltonPermutations.Load(_30755 * 4 + 0) & 65535u;
	                }
	                uint _30769 = 4321u + ((_12091 / 4657463u) % 167u);
	                uint _30770 = _30769 / 2u;
	                uint _30780;
	                if ((_30769 & 1u) != 0u)
	                {
	                    _30780 = g_ScrambledHaltonPermutations.Load(_30770 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _30780 = g_ScrambledHaltonPermutations.Load(_30770 * 4 + 0) & 65535u;
	                }
	                _33359 = float((((_30735 * 4657463u) + (_30750 * 27889u)) + (_30765 * 167u)) + _30780) * 1.2856834485930335176817607134581e-09f;
	                _33360 = true;
	                break;
	            }
	            case 39u:
	            {
	                uint _30662 = 4488u + (_12091 % 173u);
	                uint _30663 = _30662 / 2u;
	                uint _30673;
	                if ((_30662 & 1u) != 0u)
	                {
	                    _30673 = g_ScrambledHaltonPermutations.Load(_30663 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _30673 = g_ScrambledHaltonPermutations.Load(_30663 * 4 + 0) & 65535u;
	                }
	                uint _30677 = 4488u + ((_12091 / 173u) % 173u);
	                uint _30678 = _30677 / 2u;
	                uint _30688;
	                if ((_30677 & 1u) != 0u)
	                {
	                    _30688 = g_ScrambledHaltonPermutations.Load(_30678 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _30688 = g_ScrambledHaltonPermutations.Load(_30678 * 4 + 0) & 65535u;
	                }
	                uint _30692 = 4488u + ((_12091 / 29929u) % 173u);
	                uint _30693 = _30692 / 2u;
	                uint _30703;
	                if ((_30692 & 1u) != 0u)
	                {
	                    _30703 = g_ScrambledHaltonPermutations.Load(_30693 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _30703 = g_ScrambledHaltonPermutations.Load(_30693 * 4 + 0) & 65535u;
	                }
	                uint _30707 = 4488u + ((_12091 / 5177717u) % 173u);
	                uint _30708 = _30707 / 2u;
	                uint _30718;
	                if ((_30707 & 1u) != 0u)
	                {
	                    _30718 = g_ScrambledHaltonPermutations.Load(_30708 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _30718 = g_ScrambledHaltonPermutations.Load(_30708 * 4 + 0) & 65535u;
	                }
	                _33359 = float((((_30673 * 5177717u) + (_30688 * 29929u)) + (_30703 * 173u)) + _30718) * 1.1163889812593197348178364336491e-09f;
	                _33360 = true;
	                break;
	            }
	            case 40u:
	            {
	                uint _30600 = 4661u + (_12091 % 179u);
	                uint _30601 = _30600 / 2u;
	                uint _30611;
	                if ((_30600 & 1u) != 0u)
	                {
	                    _30611 = g_ScrambledHaltonPermutations.Load(_30601 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _30611 = g_ScrambledHaltonPermutations.Load(_30601 * 4 + 0) & 65535u;
	                }
	                uint _30615 = 4661u + ((_12091 / 179u) % 179u);
	                uint _30616 = _30615 / 2u;
	                uint _30626;
	                if ((_30615 & 1u) != 0u)
	                {
	                    _30626 = g_ScrambledHaltonPermutations.Load(_30616 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _30626 = g_ScrambledHaltonPermutations.Load(_30616 * 4 + 0) & 65535u;
	                }
	                uint _30630 = 4661u + ((_12091 / 32041u) % 179u);
	                uint _30631 = _30630 / 2u;
	                uint _30641;
	                if ((_30630 & 1u) != 0u)
	                {
	                    _30641 = g_ScrambledHaltonPermutations.Load(_30631 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _30641 = g_ScrambledHaltonPermutations.Load(_30631 * 4 + 0) & 65535u;
	                }
	                uint _30645 = 4661u + ((_12091 / 5735339u) % 179u);
	                uint _30646 = _30645 / 2u;
	                uint _30656;
	                if ((_30645 & 1u) != 0u)
	                {
	                    _30656 = g_ScrambledHaltonPermutations.Load(_30646 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _30656 = g_ScrambledHaltonPermutations.Load(_30646 * 4 + 0) & 65535u;
	                }
	                _33359 = float((((_30611 * 5735339u) + (_30626 * 32041u)) + (_30641 * 179u)) + _30656) * 9.7406471777361502972780726850033e-10f;
	                _33360 = true;
	                break;
	            }
	            case 41u:
	            {
	                uint _30538 = 4840u + (_12091 % 181u);
	                uint _30539 = _30538 / 2u;
	                uint _30549;
	                if ((_30538 & 1u) != 0u)
	                {
	                    _30549 = g_ScrambledHaltonPermutations.Load(_30539 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _30549 = g_ScrambledHaltonPermutations.Load(_30539 * 4 + 0) & 65535u;
	                }
	                uint _30553 = 4840u + ((_12091 / 181u) % 181u);
	                uint _30554 = _30553 / 2u;
	                uint _30564;
	                if ((_30553 & 1u) != 0u)
	                {
	                    _30564 = g_ScrambledHaltonPermutations.Load(_30554 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _30564 = g_ScrambledHaltonPermutations.Load(_30554 * 4 + 0) & 65535u;
	                }
	                uint _30568 = 4840u + ((_12091 / 32761u) % 181u);
	                uint _30569 = _30568 / 2u;
	                uint _30579;
	                if ((_30568 & 1u) != 0u)
	                {
	                    _30579 = g_ScrambledHaltonPermutations.Load(_30569 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _30579 = g_ScrambledHaltonPermutations.Load(_30569 * 4 + 0) & 65535u;
	                }
	                uint _30583 = 4840u + ((_12091 / 5929741u) % 181u);
	                uint _30584 = _30583 / 2u;
	                uint _30594;
	                if ((_30583 & 1u) != 0u)
	                {
	                    _30594 = g_ScrambledHaltonPermutations.Load(_30584 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _30594 = g_ScrambledHaltonPermutations.Load(_30584 * 4 + 0) & 65535u;
	                }
	                _33359 = float((((_30549 * 5929741u) + (_30564 * 32761u)) + (_30579 * 181u)) + _30594) * 9.3172047854750417172908782958984e-10f;
	                _33360 = true;
	                break;
	            }
	            case 42u:
	            {
	                uint _30476 = 5021u + (_12091 % 191u);
	                uint _30477 = _30476 / 2u;
	                uint _30487;
	                if ((_30476 & 1u) != 0u)
	                {
	                    _30487 = g_ScrambledHaltonPermutations.Load(_30477 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _30487 = g_ScrambledHaltonPermutations.Load(_30477 * 4 + 0) & 65535u;
	                }
	                uint _30491 = 5021u + ((_12091 / 191u) % 191u);
	                uint _30492 = _30491 / 2u;
	                uint _30502;
	                if ((_30491 & 1u) != 0u)
	                {
	                    _30502 = g_ScrambledHaltonPermutations.Load(_30492 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _30502 = g_ScrambledHaltonPermutations.Load(_30492 * 4 + 0) & 65535u;
	                }
	                uint _30506 = 5021u + ((_12091 / 36481u) % 191u);
	                uint _30507 = _30506 / 2u;
	                uint _30517;
	                if ((_30506 & 1u) != 0u)
	                {
	                    _30517 = g_ScrambledHaltonPermutations.Load(_30507 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _30517 = g_ScrambledHaltonPermutations.Load(_30507 * 4 + 0) & 65535u;
	                }
	                uint _30521 = 5021u + ((_12091 / 6967871u) % 191u);
	                uint _30522 = _30521 / 2u;
	                uint _30532;
	                if ((_30521 & 1u) != 0u)
	                {
	                    _30532 = g_ScrambledHaltonPermutations.Load(_30522 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _30532 = g_ScrambledHaltonPermutations.Load(_30522 * 4 + 0) & 65535u;
	                }
	                _33359 = float((((_30487 * 6967871u) + (_30502 * 36481u)) + (_30517 * 191u)) + _30532) * 7.5139183763894834555685520172119e-10f;
	                _33360 = true;
	                break;
	            }
	            case 43u:
	            {
	                uint _30414 = 5212u + (_12091 % 193u);
	                uint _30415 = _30414 / 2u;
	                uint _30425;
	                if ((_30414 & 1u) != 0u)
	                {
	                    _30425 = g_ScrambledHaltonPermutations.Load(_30415 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _30425 = g_ScrambledHaltonPermutations.Load(_30415 * 4 + 0) & 65535u;
	                }
	                uint _30429 = 5212u + ((_12091 / 193u) % 193u);
	                uint _30430 = _30429 / 2u;
	                uint _30440;
	                if ((_30429 & 1u) != 0u)
	                {
	                    _30440 = g_ScrambledHaltonPermutations.Load(_30430 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _30440 = g_ScrambledHaltonPermutations.Load(_30430 * 4 + 0) & 65535u;
	                }
	                uint _30444 = 5212u + ((_12091 / 37249u) % 193u);
	                uint _30445 = _30444 / 2u;
	                uint _30455;
	                if ((_30444 & 1u) != 0u)
	                {
	                    _30455 = g_ScrambledHaltonPermutations.Load(_30445 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _30455 = g_ScrambledHaltonPermutations.Load(_30445 * 4 + 0) & 65535u;
	                }
	                uint _30459 = 5212u + ((_12091 / 7189057u) % 193u);
	                uint _30460 = _30459 / 2u;
	                uint _30470;
	                if ((_30459 & 1u) != 0u)
	                {
	                    _30470 = g_ScrambledHaltonPermutations.Load(_30460 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _30470 = g_ScrambledHaltonPermutations.Load(_30460 * 4 + 0) & 65535u;
	                }
	                _33359 = float((((_30425 * 7189057u) + (_30440 * 37249u)) + (_30455 * 193u)) + _30470) * 7.2072686707613797807425726205111e-10f;
	                _33360 = true;
	                break;
	            }
	            case 44u:
	            {
	                uint _30352 = 5405u + (_12091 % 197u);
	                uint _30353 = _30352 / 2u;
	                uint _30363;
	                if ((_30352 & 1u) != 0u)
	                {
	                    _30363 = g_ScrambledHaltonPermutations.Load(_30353 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _30363 = g_ScrambledHaltonPermutations.Load(_30353 * 4 + 0) & 65535u;
	                }
	                uint _30367 = 5405u + ((_12091 / 197u) % 197u);
	                uint _30368 = _30367 / 2u;
	                uint _30378;
	                if ((_30367 & 1u) != 0u)
	                {
	                    _30378 = g_ScrambledHaltonPermutations.Load(_30368 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _30378 = g_ScrambledHaltonPermutations.Load(_30368 * 4 + 0) & 65535u;
	                }
	                uint _30382 = 5405u + ((_12091 / 38809u) % 197u);
	                uint _30383 = _30382 / 2u;
	                uint _30393;
	                if ((_30382 & 1u) != 0u)
	                {
	                    _30393 = g_ScrambledHaltonPermutations.Load(_30383 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _30393 = g_ScrambledHaltonPermutations.Load(_30383 * 4 + 0) & 65535u;
	                }
	                uint _30397 = 5405u + ((_12091 / 7645373u) % 197u);
	                uint _30398 = _30397 / 2u;
	                uint _30408;
	                if ((_30397 & 1u) != 0u)
	                {
	                    _30408 = g_ScrambledHaltonPermutations.Load(_30398 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _30408 = g_ScrambledHaltonPermutations.Load(_30398 * 4 + 0) & 65535u;
	                }
	                _33359 = float((((_30363 * 7645373u) + (_30378 * 38809u)) + (_30393 * 197u)) + _30408) * 6.6394950648529516001872252672911e-10f;
	                _33360 = true;
	                break;
	            }
	            case 45u:
	            {
	                uint _30290 = 5602u + (_12091 % 199u);
	                uint _30291 = _30290 / 2u;
	                uint _30301;
	                if ((_30290 & 1u) != 0u)
	                {
	                    _30301 = g_ScrambledHaltonPermutations.Load(_30291 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _30301 = g_ScrambledHaltonPermutations.Load(_30291 * 4 + 0) & 65535u;
	                }
	                uint _30305 = 5602u + ((_12091 / 199u) % 199u);
	                uint _30306 = _30305 / 2u;
	                uint _30316;
	                if ((_30305 & 1u) != 0u)
	                {
	                    _30316 = g_ScrambledHaltonPermutations.Load(_30306 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _30316 = g_ScrambledHaltonPermutations.Load(_30306 * 4 + 0) & 65535u;
	                }
	                uint _30320 = 5602u + ((_12091 / 39601u) % 199u);
	                uint _30321 = _30320 / 2u;
	                uint _30331;
	                if ((_30320 & 1u) != 0u)
	                {
	                    _30331 = g_ScrambledHaltonPermutations.Load(_30321 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _30331 = g_ScrambledHaltonPermutations.Load(_30321 * 4 + 0) & 65535u;
	                }
	                uint _30335 = 5602u + ((_12091 / 7880599u) % 199u);
	                uint _30336 = _30335 / 2u;
	                uint _30346;
	                if ((_30335 & 1u) != 0u)
	                {
	                    _30346 = g_ScrambledHaltonPermutations.Load(_30336 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _30346 = g_ScrambledHaltonPermutations.Load(_30336 * 4 + 0) & 65535u;
	                }
	                _33359 = float((((_30301 * 7880599u) + (_30316 * 39601u)) + (_30331 * 199u)) + _30346) * 6.3765775992763451540668029338121e-10f;
	                _33360 = true;
	                break;
	            }
	            case 46u:
	            {
	                uint _30228 = 5801u + (_12091 % 211u);
	                uint _30229 = _30228 / 2u;
	                uint _30239;
	                if ((_30228 & 1u) != 0u)
	                {
	                    _30239 = g_ScrambledHaltonPermutations.Load(_30229 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _30239 = g_ScrambledHaltonPermutations.Load(_30229 * 4 + 0) & 65535u;
	                }
	                uint _30243 = 5801u + ((_12091 / 211u) % 211u);
	                uint _30244 = _30243 / 2u;
	                uint _30254;
	                if ((_30243 & 1u) != 0u)
	                {
	                    _30254 = g_ScrambledHaltonPermutations.Load(_30244 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _30254 = g_ScrambledHaltonPermutations.Load(_30244 * 4 + 0) & 65535u;
	                }
	                uint _30258 = 5801u + ((_12091 / 44521u) % 211u);
	                uint _30259 = _30258 / 2u;
	                uint _30269;
	                if ((_30258 & 1u) != 0u)
	                {
	                    _30269 = g_ScrambledHaltonPermutations.Load(_30259 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _30269 = g_ScrambledHaltonPermutations.Load(_30259 * 4 + 0) & 65535u;
	                }
	                uint _30273 = 5801u + ((_12091 / 9393931u) % 211u);
	                uint _30274 = _30273 / 2u;
	                uint _30284;
	                if ((_30273 & 1u) != 0u)
	                {
	                    _30284 = g_ScrambledHaltonPermutations.Load(_30274 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _30284 = g_ScrambledHaltonPermutations.Load(_30274 * 4 + 0) & 65535u;
	                }
	                _33359 = float((((_30239 * 9393931u) + (_30254 * 44521u)) + (_30269 * 211u)) + _30284) * 5.0451043343002766050631180405617e-10f;
	                _33360 = true;
	                break;
	            }
	            case 47u:
	            {
	                uint _30166 = 6012u + (_12091 % 223u);
	                uint _30167 = _30166 / 2u;
	                uint _30177;
	                if ((_30166 & 1u) != 0u)
	                {
	                    _30177 = g_ScrambledHaltonPermutations.Load(_30167 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _30177 = g_ScrambledHaltonPermutations.Load(_30167 * 4 + 0) & 65535u;
	                }
	                uint _30181 = 6012u + ((_12091 / 223u) % 223u);
	                uint _30182 = _30181 / 2u;
	                uint _30192;
	                if ((_30181 & 1u) != 0u)
	                {
	                    _30192 = g_ScrambledHaltonPermutations.Load(_30182 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _30192 = g_ScrambledHaltonPermutations.Load(_30182 * 4 + 0) & 65535u;
	                }
	                uint _30196 = 6012u + ((_12091 / 49729u) % 223u);
	                uint _30197 = _30196 / 2u;
	                uint _30207;
	                if ((_30196 & 1u) != 0u)
	                {
	                    _30207 = g_ScrambledHaltonPermutations.Load(_30197 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _30207 = g_ScrambledHaltonPermutations.Load(_30197 * 4 + 0) & 65535u;
	                }
	                uint _30211 = 6012u + ((_12091 / 11089567u) % 223u);
	                uint _30212 = _30211 / 2u;
	                uint _30222;
	                if ((_30211 & 1u) != 0u)
	                {
	                    _30222 = g_ScrambledHaltonPermutations.Load(_30212 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _30222 = g_ScrambledHaltonPermutations.Load(_30212 * 4 + 0) & 65535u;
	                }
	                _33359 = float((((_30177 * 11089567u) + (_30192 * 49729u)) + (_30207 * 223u)) + _30222) * 4.0437145298888310662732692435384e-10f;
	                _33360 = true;
	                break;
	            }
	            case 48u:
	            {
	                uint _30104 = 6235u + (_12091 % 227u);
	                uint _30105 = _30104 / 2u;
	                uint _30115;
	                if ((_30104 & 1u) != 0u)
	                {
	                    _30115 = g_ScrambledHaltonPermutations.Load(_30105 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _30115 = g_ScrambledHaltonPermutations.Load(_30105 * 4 + 0) & 65535u;
	                }
	                uint _30119 = 6235u + ((_12091 / 227u) % 227u);
	                uint _30120 = _30119 / 2u;
	                uint _30130;
	                if ((_30119 & 1u) != 0u)
	                {
	                    _30130 = g_ScrambledHaltonPermutations.Load(_30120 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _30130 = g_ScrambledHaltonPermutations.Load(_30120 * 4 + 0) & 65535u;
	                }
	                uint _30134 = 6235u + ((_12091 / 51529u) % 227u);
	                uint _30135 = _30134 / 2u;
	                uint _30145;
	                if ((_30134 & 1u) != 0u)
	                {
	                    _30145 = g_ScrambledHaltonPermutations.Load(_30135 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _30145 = g_ScrambledHaltonPermutations.Load(_30135 * 4 + 0) & 65535u;
	                }
	                uint _30149 = 6235u + ((_12091 / 11697083u) % 227u);
	                uint _30150 = _30149 / 2u;
	                uint _30160;
	                if ((_30149 & 1u) != 0u)
	                {
	                    _30160 = g_ScrambledHaltonPermutations.Load(_30150 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _30160 = g_ScrambledHaltonPermutations.Load(_30150 * 4 + 0) & 65535u;
	                }
	                _33359 = float((((_30115 * 11697083u) + (_30130 * 51529u)) + (_30145 * 227u)) + _30160) * 3.7661404550526356160844443365932e-10f;
	                _33360 = true;
	                break;
	            }
	            case 49u:
	            {
	                uint _30042 = 6462u + (_12091 % 229u);
	                uint _30043 = _30042 / 2u;
	                uint _30053;
	                if ((_30042 & 1u) != 0u)
	                {
	                    _30053 = g_ScrambledHaltonPermutations.Load(_30043 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _30053 = g_ScrambledHaltonPermutations.Load(_30043 * 4 + 0) & 65535u;
	                }
	                uint _30057 = 6462u + ((_12091 / 229u) % 229u);
	                uint _30058 = _30057 / 2u;
	                uint _30068;
	                if ((_30057 & 1u) != 0u)
	                {
	                    _30068 = g_ScrambledHaltonPermutations.Load(_30058 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _30068 = g_ScrambledHaltonPermutations.Load(_30058 * 4 + 0) & 65535u;
	                }
	                uint _30072 = 6462u + ((_12091 / 52441u) % 229u);
	                uint _30073 = _30072 / 2u;
	                uint _30083;
	                if ((_30072 & 1u) != 0u)
	                {
	                    _30083 = g_ScrambledHaltonPermutations.Load(_30073 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _30083 = g_ScrambledHaltonPermutations.Load(_30073 * 4 + 0) & 65535u;
	                }
	                uint _30087 = 6462u + ((_12091 / 12008989u) % 229u);
	                uint _30088 = _30087 / 2u;
	                uint _30098;
	                if ((_30087 & 1u) != 0u)
	                {
	                    _30098 = g_ScrambledHaltonPermutations.Load(_30088 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _30098 = g_ScrambledHaltonPermutations.Load(_30088 * 4 + 0) & 65535u;
	                }
	                _33359 = float((((_30053 * 12008989u) + (_30068 * 52441u)) + (_30083 * 229u)) + _30098) * 3.6362857169791595879360102117062e-10f;
	                _33360 = true;
	                break;
	            }
	            case 50u:
	            {
	                uint _29980 = 6691u + (_12091 % 233u);
	                uint _29981 = _29980 / 2u;
	                uint _29991;
	                if ((_29980 & 1u) != 0u)
	                {
	                    _29991 = g_ScrambledHaltonPermutations.Load(_29981 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _29991 = g_ScrambledHaltonPermutations.Load(_29981 * 4 + 0) & 65535u;
	                }
	                uint _29995 = 6691u + ((_12091 / 233u) % 233u);
	                uint _29996 = _29995 / 2u;
	                uint _30006;
	                if ((_29995 & 1u) != 0u)
	                {
	                    _30006 = g_ScrambledHaltonPermutations.Load(_29996 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _30006 = g_ScrambledHaltonPermutations.Load(_29996 * 4 + 0) & 65535u;
	                }
	                uint _30010 = 6691u + ((_12091 / 54289u) % 233u);
	                uint _30011 = _30010 / 2u;
	                uint _30021;
	                if ((_30010 & 1u) != 0u)
	                {
	                    _30021 = g_ScrambledHaltonPermutations.Load(_30011 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _30021 = g_ScrambledHaltonPermutations.Load(_30011 * 4 + 0) & 65535u;
	                }
	                uint _30025 = 6691u + ((_12091 / 12649337u) % 233u);
	                uint _30026 = _30025 / 2u;
	                uint _30036;
	                if ((_30025 & 1u) != 0u)
	                {
	                    _30036 = g_ScrambledHaltonPermutations.Load(_30026 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _30036 = g_ScrambledHaltonPermutations.Load(_30026 * 4 + 0) & 65535u;
	                }
	                _33359 = float((((_29991 * 12649337u) + (_30006 * 54289u)) + (_30021 * 233u)) + _30036) * 3.3929406506594261827558511868119e-10f;
	                _33360 = true;
	                break;
	            }
	            case 51u:
	            {
	                uint _29918 = 6924u + (_12091 % 239u);
	                uint _29919 = _29918 / 2u;
	                uint _29929;
	                if ((_29918 & 1u) != 0u)
	                {
	                    _29929 = g_ScrambledHaltonPermutations.Load(_29919 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _29929 = g_ScrambledHaltonPermutations.Load(_29919 * 4 + 0) & 65535u;
	                }
	                uint _29933 = 6924u + ((_12091 / 239u) % 239u);
	                uint _29934 = _29933 / 2u;
	                uint _29944;
	                if ((_29933 & 1u) != 0u)
	                {
	                    _29944 = g_ScrambledHaltonPermutations.Load(_29934 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _29944 = g_ScrambledHaltonPermutations.Load(_29934 * 4 + 0) & 65535u;
	                }
	                uint _29948 = 6924u + ((_12091 / 57121u) % 239u);
	                uint _29949 = _29948 / 2u;
	                uint _29959;
	                if ((_29948 & 1u) != 0u)
	                {
	                    _29959 = g_ScrambledHaltonPermutations.Load(_29949 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _29959 = g_ScrambledHaltonPermutations.Load(_29949 * 4 + 0) & 65535u;
	                }
	                uint _29963 = 6924u + ((_12091 / 13651919u) % 239u);
	                uint _29964 = _29963 / 2u;
	                uint _29974;
	                if ((_29963 & 1u) != 0u)
	                {
	                    _29974 = g_ScrambledHaltonPermutations.Load(_29964 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _29974 = g_ScrambledHaltonPermutations.Load(_29964 * 4 + 0) & 65535u;
	                }
	                _33359 = float((((_29929 * 13651919u) + (_29944 * 57121u)) + (_29959 * 239u)) + _29974) * 3.0648439341973698901711031794548e-10f;
	                _33360 = true;
	                break;
	            }
	            case 52u:
	            {
	                uint _29856 = 7163u + (_12091 % 241u);
	                uint _29857 = _29856 / 2u;
	                uint _29867;
	                if ((_29856 & 1u) != 0u)
	                {
	                    _29867 = g_ScrambledHaltonPermutations.Load(_29857 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _29867 = g_ScrambledHaltonPermutations.Load(_29857 * 4 + 0) & 65535u;
	                }
	                uint _29871 = 7163u + ((_12091 / 241u) % 241u);
	                uint _29872 = _29871 / 2u;
	                uint _29882;
	                if ((_29871 & 1u) != 0u)
	                {
	                    _29882 = g_ScrambledHaltonPermutations.Load(_29872 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _29882 = g_ScrambledHaltonPermutations.Load(_29872 * 4 + 0) & 65535u;
	                }
	                uint _29886 = 7163u + ((_12091 / 58081u) % 241u);
	                uint _29887 = _29886 / 2u;
	                uint _29897;
	                if ((_29886 & 1u) != 0u)
	                {
	                    _29897 = g_ScrambledHaltonPermutations.Load(_29887 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _29897 = g_ScrambledHaltonPermutations.Load(_29887 * 4 + 0) & 65535u;
	                }
	                uint _29901 = 7163u + ((_12091 / 13997521u) % 241u);
	                uint _29902 = _29901 / 2u;
	                uint _29912;
	                if ((_29901 & 1u) != 0u)
	                {
	                    _29912 = g_ScrambledHaltonPermutations.Load(_29902 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _29912 = g_ScrambledHaltonPermutations.Load(_29902 * 4 + 0) & 65535u;
	                }
	                _33359 = float((((_29867 * 13997521u) + (_29882 * 58081u)) + (_29897 * 241u)) + _29912) * 2.9643656973554755040822783485055e-10f;
	                _33360 = true;
	                break;
	            }
	            case 53u:
	            {
	                uint _29794 = 7404u + (_12091 % 251u);
	                uint _29795 = _29794 / 2u;
	                uint _29805;
	                if ((_29794 & 1u) != 0u)
	                {
	                    _29805 = g_ScrambledHaltonPermutations.Load(_29795 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _29805 = g_ScrambledHaltonPermutations.Load(_29795 * 4 + 0) & 65535u;
	                }
	                uint _29809 = 7404u + ((_12091 / 251u) % 251u);
	                uint _29810 = _29809 / 2u;
	                uint _29820;
	                if ((_29809 & 1u) != 0u)
	                {
	                    _29820 = g_ScrambledHaltonPermutations.Load(_29810 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _29820 = g_ScrambledHaltonPermutations.Load(_29810 * 4 + 0) & 65535u;
	                }
	                uint _29824 = 7404u + ((_12091 / 63001u) % 251u);
	                uint _29825 = _29824 / 2u;
	                uint _29835;
	                if ((_29824 & 1u) != 0u)
	                {
	                    _29835 = g_ScrambledHaltonPermutations.Load(_29825 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _29835 = g_ScrambledHaltonPermutations.Load(_29825 * 4 + 0) & 65535u;
	                }
	                uint _29839 = 7404u + ((_12091 / 15813251u) % 251u);
	                uint _29840 = _29839 / 2u;
	                uint _29850;
	                if ((_29839 & 1u) != 0u)
	                {
	                    _29850 = g_ScrambledHaltonPermutations.Load(_29840 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _29850 = g_ScrambledHaltonPermutations.Load(_29840 * 4 + 0) & 65535u;
	                }
	                _33359 = float((((_29805 * 15813251u) + (_29820 * 63001u)) + (_29835 * 251u)) + _29850) * 2.5194460406829932708205888047814e-10f;
	                _33360 = true;
	                break;
	            }
	            case 54u:
	            {
	                uint _29747 = 7655u + (_12091 % 257u);
	                uint _29748 = _29747 / 2u;
	                uint _29758;
	                if ((_29747 & 1u) != 0u)
	                {
	                    _29758 = g_ScrambledHaltonPermutations.Load(_29748 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _29758 = g_ScrambledHaltonPermutations.Load(_29748 * 4 + 0) & 65535u;
	                }
	                uint _29762 = 7655u + ((_12091 / 257u) % 257u);
	                uint _29763 = _29762 / 2u;
	                uint _29773;
	                if ((_29762 & 1u) != 0u)
	                {
	                    _29773 = g_ScrambledHaltonPermutations.Load(_29763 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _29773 = g_ScrambledHaltonPermutations.Load(_29763 * 4 + 0) & 65535u;
	                }
	                uint _29777 = 7655u + ((_12091 / 66049u) % 257u);
	                uint _29778 = _29777 / 2u;
	                uint _29788;
	                if ((_29777 & 1u) != 0u)
	                {
	                    _29788 = g_ScrambledHaltonPermutations.Load(_29778 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _29788 = g_ScrambledHaltonPermutations.Load(_29778 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_29758 * 66049u) + (_29773 * 257u)) + _29788) * 5.891157073278918687719851732254e-08f;
	                _33360 = true;
	                break;
	            }
	            case 55u:
	            {
	                uint _29700 = 7912u + (_12091 % 263u);
	                uint _29701 = _29700 / 2u;
	                uint _29711;
	                if ((_29700 & 1u) != 0u)
	                {
	                    _29711 = g_ScrambledHaltonPermutations.Load(_29701 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _29711 = g_ScrambledHaltonPermutations.Load(_29701 * 4 + 0) & 65535u;
	                }
	                uint _29715 = 7912u + ((_12091 / 263u) % 263u);
	                uint _29716 = _29715 / 2u;
	                uint _29726;
	                if ((_29715 & 1u) != 0u)
	                {
	                    _29726 = g_ScrambledHaltonPermutations.Load(_29716 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _29726 = g_ScrambledHaltonPermutations.Load(_29716 * 4 + 0) & 65535u;
	                }
	                uint _29730 = 7912u + ((_12091 / 69169u) % 263u);
	                uint _29731 = _29730 / 2u;
	                uint _29741;
	                if ((_29730 & 1u) != 0u)
	                {
	                    _29741 = g_ScrambledHaltonPermutations.Load(_29731 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _29741 = g_ScrambledHaltonPermutations.Load(_29731 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_29711 * 69169u) + (_29726 * 263u)) + _29741) * 5.4970879403981598443351686000824e-08f;
	                _33360 = true;
	                break;
	            }
	            case 56u:
	            {
	                uint _29653 = 8175u + (_12091 % 269u);
	                uint _29654 = _29653 / 2u;
	                uint _29664;
	                if ((_29653 & 1u) != 0u)
	                {
	                    _29664 = g_ScrambledHaltonPermutations.Load(_29654 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _29664 = g_ScrambledHaltonPermutations.Load(_29654 * 4 + 0) & 65535u;
	                }
	                uint _29668 = 8175u + ((_12091 / 269u) % 269u);
	                uint _29669 = _29668 / 2u;
	                uint _29679;
	                if ((_29668 & 1u) != 0u)
	                {
	                    _29679 = g_ScrambledHaltonPermutations.Load(_29669 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _29679 = g_ScrambledHaltonPermutations.Load(_29669 * 4 + 0) & 65535u;
	                }
	                uint _29683 = 8175u + ((_12091 / 72361u) % 269u);
	                uint _29684 = _29683 / 2u;
	                uint _29694;
	                if ((_29683 & 1u) != 0u)
	                {
	                    _29694 = g_ScrambledHaltonPermutations.Load(_29684 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _29694 = g_ScrambledHaltonPermutations.Load(_29684 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_29664 * 72361u) + (_29679 * 269u)) + _29694) * 5.137396996701681928243488073349e-08f;
	                _33360 = true;
	                break;
	            }
	            case 57u:
	            {
	                uint _29606 = 8444u + (_12091 % 271u);
	                uint _29607 = _29606 / 2u;
	                uint _29617;
	                if ((_29606 & 1u) != 0u)
	                {
	                    _29617 = g_ScrambledHaltonPermutations.Load(_29607 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _29617 = g_ScrambledHaltonPermutations.Load(_29607 * 4 + 0) & 65535u;
	                }
	                uint _29621 = 8444u + ((_12091 / 271u) % 271u);
	                uint _29622 = _29621 / 2u;
	                uint _29632;
	                if ((_29621 & 1u) != 0u)
	                {
	                    _29632 = g_ScrambledHaltonPermutations.Load(_29622 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _29632 = g_ScrambledHaltonPermutations.Load(_29622 * 4 + 0) & 65535u;
	                }
	                uint _29636 = 8444u + ((_12091 / 73441u) % 271u);
	                uint _29637 = _29636 / 2u;
	                uint _29647;
	                if ((_29636 & 1u) != 0u)
	                {
	                    _29647 = g_ScrambledHaltonPermutations.Load(_29637 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _29647 = g_ScrambledHaltonPermutations.Load(_29637 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_29617 * 73441u) + (_29632 * 271u)) + _29647) * 5.0244906901752983685582876205444e-08f;
	                _33360 = true;
	                break;
	            }
	            case 58u:
	            {
	                uint _29559 = 8715u + (_12091 % 277u);
	                uint _29560 = _29559 / 2u;
	                uint _29570;
	                if ((_29559 & 1u) != 0u)
	                {
	                    _29570 = g_ScrambledHaltonPermutations.Load(_29560 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _29570 = g_ScrambledHaltonPermutations.Load(_29560 * 4 + 0) & 65535u;
	                }
	                uint _29574 = 8715u + ((_12091 / 277u) % 277u);
	                uint _29575 = _29574 / 2u;
	                uint _29585;
	                if ((_29574 & 1u) != 0u)
	                {
	                    _29585 = g_ScrambledHaltonPermutations.Load(_29575 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _29585 = g_ScrambledHaltonPermutations.Load(_29575 * 4 + 0) & 65535u;
	                }
	                uint _29589 = 8715u + ((_12091 / 76729u) % 277u);
	                uint _29590 = _29589 / 2u;
	                uint _29600;
	                if ((_29589 & 1u) != 0u)
	                {
	                    _29600 = g_ScrambledHaltonPermutations.Load(_29590 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _29600 = g_ScrambledHaltonPermutations.Load(_29590 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_29570 * 76729u) + (_29585 * 277u)) + _29600) * 4.705011136252323922235518693924e-08f;
	                _33360 = true;
	                break;
	            }
	            case 59u:
	            {
	                uint _29512 = 8992u + (_12091 % 281u);
	                uint _29513 = _29512 / 2u;
	                uint _29523;
	                if ((_29512 & 1u) != 0u)
	                {
	                    _29523 = g_ScrambledHaltonPermutations.Load(_29513 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _29523 = g_ScrambledHaltonPermutations.Load(_29513 * 4 + 0) & 65535u;
	                }
	                uint _29527 = 8992u + ((_12091 / 281u) % 281u);
	                uint _29528 = _29527 / 2u;
	                uint _29538;
	                if ((_29527 & 1u) != 0u)
	                {
	                    _29538 = g_ScrambledHaltonPermutations.Load(_29528 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _29538 = g_ScrambledHaltonPermutations.Load(_29528 * 4 + 0) & 65535u;
	                }
	                uint _29542 = 8992u + ((_12091 / 78961u) % 281u);
	                uint _29543 = _29542 / 2u;
	                uint _29553;
	                if ((_29542 & 1u) != 0u)
	                {
	                    _29553 = g_ScrambledHaltonPermutations.Load(_29543 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _29553 = g_ScrambledHaltonPermutations.Load(_29543 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_29523 * 78961u) + (_29538 * 281u)) + _29553) * 4.5069320719903771532699465751648e-08f;
	                _33360 = true;
	                break;
	            }
	            case 60u:
	            {
	                uint _29465 = 9273u + (_12091 % 283u);
	                uint _29466 = _29465 / 2u;
	                uint _29476;
	                if ((_29465 & 1u) != 0u)
	                {
	                    _29476 = g_ScrambledHaltonPermutations.Load(_29466 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _29476 = g_ScrambledHaltonPermutations.Load(_29466 * 4 + 0) & 65535u;
	                }
	                uint _29480 = 9273u + ((_12091 / 283u) % 283u);
	                uint _29481 = _29480 / 2u;
	                uint _29491;
	                if ((_29480 & 1u) != 0u)
	                {
	                    _29491 = g_ScrambledHaltonPermutations.Load(_29481 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _29491 = g_ScrambledHaltonPermutations.Load(_29481 * 4 + 0) & 65535u;
	                }
	                uint _29495 = 9273u + ((_12091 / 80089u) % 283u);
	                uint _29496 = _29495 / 2u;
	                uint _29506;
	                if ((_29495 & 1u) != 0u)
	                {
	                    _29506 = g_ScrambledHaltonPermutations.Load(_29496 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _29506 = g_ScrambledHaltonPermutations.Load(_29496 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_29476 * 80089u) + (_29491 * 283u)) + _29506) * 4.4120518793988594552502036094666e-08f;
	                _33360 = true;
	                break;
	            }
	            case 61u:
	            {
	                uint _29418 = 9556u + (_12091 % 293u);
	                uint _29419 = _29418 / 2u;
	                uint _29429;
	                if ((_29418 & 1u) != 0u)
	                {
	                    _29429 = g_ScrambledHaltonPermutations.Load(_29419 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _29429 = g_ScrambledHaltonPermutations.Load(_29419 * 4 + 0) & 65535u;
	                }
	                uint _29433 = 9556u + ((_12091 / 293u) % 293u);
	                uint _29434 = _29433 / 2u;
	                uint _29444;
	                if ((_29433 & 1u) != 0u)
	                {
	                    _29444 = g_ScrambledHaltonPermutations.Load(_29434 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _29444 = g_ScrambledHaltonPermutations.Load(_29434 * 4 + 0) & 65535u;
	                }
	                uint _29448 = 9556u + ((_12091 / 85849u) % 293u);
	                uint _29449 = _29448 / 2u;
	                uint _29459;
	                if ((_29448 & 1u) != 0u)
	                {
	                    _29459 = g_ScrambledHaltonPermutations.Load(_29449 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _29459 = g_ScrambledHaltonPermutations.Load(_29449 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_29429 * 85849u) + (_29444 * 293u)) + _29459) * 3.975548779067139548715204000473e-08f;
	                _33360 = true;
	                break;
	            }
	            case 62u:
	            {
	                uint _29371 = 9849u + (_12091 % 307u);
	                uint _29372 = _29371 / 2u;
	                uint _29382;
	                if ((_29371 & 1u) != 0u)
	                {
	                    _29382 = g_ScrambledHaltonPermutations.Load(_29372 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _29382 = g_ScrambledHaltonPermutations.Load(_29372 * 4 + 0) & 65535u;
	                }
	                uint _29386 = 9849u + ((_12091 / 307u) % 307u);
	                uint _29387 = _29386 / 2u;
	                uint _29397;
	                if ((_29386 & 1u) != 0u)
	                {
	                    _29397 = g_ScrambledHaltonPermutations.Load(_29387 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _29397 = g_ScrambledHaltonPermutations.Load(_29387 * 4 + 0) & 65535u;
	                }
	                uint _29401 = 9849u + ((_12091 / 94249u) % 307u);
	                uint _29402 = _29401 / 2u;
	                uint _29412;
	                if ((_29401 & 1u) != 0u)
	                {
	                    _29412 = g_ScrambledHaltonPermutations.Load(_29402 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _29412 = g_ScrambledHaltonPermutations.Load(_29402 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_29382 * 94249u) + (_29397 * 307u)) + _29412) * 3.4560880379785885452292859554291e-08f;
	                _33360 = true;
	                break;
	            }
	            case 63u:
	            {
	                uint _29324 = 10156u + (_12091 % 311u);
	                uint _29325 = _29324 / 2u;
	                uint _29335;
	                if ((_29324 & 1u) != 0u)
	                {
	                    _29335 = g_ScrambledHaltonPermutations.Load(_29325 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _29335 = g_ScrambledHaltonPermutations.Load(_29325 * 4 + 0) & 65535u;
	                }
	                uint _29339 = 10156u + ((_12091 / 311u) % 311u);
	                uint _29340 = _29339 / 2u;
	                uint _29350;
	                if ((_29339 & 1u) != 0u)
	                {
	                    _29350 = g_ScrambledHaltonPermutations.Load(_29340 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _29350 = g_ScrambledHaltonPermutations.Load(_29340 * 4 + 0) & 65535u;
	                }
	                uint _29354 = 10156u + ((_12091 / 96721u) % 311u);
	                uint _29355 = _29354 / 2u;
	                uint _29365;
	                if ((_29354 & 1u) != 0u)
	                {
	                    _29365 = g_ScrambledHaltonPermutations.Load(_29355 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _29365 = g_ScrambledHaltonPermutations.Load(_29355 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_29335 * 96721u) + (_29350 * 311u)) + _29365) * 3.3244418773392681032419204711914e-08f;
	                _33360 = true;
	                break;
	            }
	            case 64u:
	            {
	                uint _29277 = 10467u + (_12091 % 313u);
	                uint _29278 = _29277 / 2u;
	                uint _29288;
	                if ((_29277 & 1u) != 0u)
	                {
	                    _29288 = g_ScrambledHaltonPermutations.Load(_29278 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _29288 = g_ScrambledHaltonPermutations.Load(_29278 * 4 + 0) & 65535u;
	                }
	                uint _29292 = 10467u + ((_12091 / 313u) % 313u);
	                uint _29293 = _29292 / 2u;
	                uint _29303;
	                if ((_29292 & 1u) != 0u)
	                {
	                    _29303 = g_ScrambledHaltonPermutations.Load(_29293 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _29303 = g_ScrambledHaltonPermutations.Load(_29293 * 4 + 0) & 65535u;
	                }
	                uint _29307 = 10467u + ((_12091 / 97969u) % 313u);
	                uint _29308 = _29307 / 2u;
	                uint _29318;
	                if ((_29307 & 1u) != 0u)
	                {
	                    _29318 = g_ScrambledHaltonPermutations.Load(_29308 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _29318 = g_ScrambledHaltonPermutations.Load(_29308 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_29288 * 97969u) + (_29303 * 313u)) + _29318) * 3.2611211508992710150778293609619e-08f;
	                _33360 = true;
	                break;
	            }
	            case 65u:
	            {
	                uint _29230 = 10780u + (_12091 % 317u);
	                uint _29231 = _29230 / 2u;
	                uint _29241;
	                if ((_29230 & 1u) != 0u)
	                {
	                    _29241 = g_ScrambledHaltonPermutations.Load(_29231 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _29241 = g_ScrambledHaltonPermutations.Load(_29231 * 4 + 0) & 65535u;
	                }
	                uint _29245 = 10780u + ((_12091 / 317u) % 317u);
	                uint _29246 = _29245 / 2u;
	                uint _29256;
	                if ((_29245 & 1u) != 0u)
	                {
	                    _29256 = g_ScrambledHaltonPermutations.Load(_29246 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _29256 = g_ScrambledHaltonPermutations.Load(_29246 * 4 + 0) & 65535u;
	                }
	                uint _29260 = 10780u + ((_12091 / 100489u) % 317u);
	                uint _29261 = _29260 / 2u;
	                uint _29271;
	                if ((_29260 & 1u) != 0u)
	                {
	                    _29271 = g_ScrambledHaltonPermutations.Load(_29261 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _29271 = g_ScrambledHaltonPermutations.Load(_29261 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_29241 * 100489u) + (_29256 * 317u)) + _29271) * 3.1392229260518433875404298305511e-08f;
	                _33360 = true;
	                break;
	            }
	            case 66u:
	            {
	                uint _29183 = 11097u + (_12091 % 331u);
	                uint _29184 = _29183 / 2u;
	                uint _29194;
	                if ((_29183 & 1u) != 0u)
	                {
	                    _29194 = g_ScrambledHaltonPermutations.Load(_29184 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _29194 = g_ScrambledHaltonPermutations.Load(_29184 * 4 + 0) & 65535u;
	                }
	                uint _29198 = 11097u + ((_12091 / 331u) % 331u);
	                uint _29199 = _29198 / 2u;
	                uint _29209;
	                if ((_29198 & 1u) != 0u)
	                {
	                    _29209 = g_ScrambledHaltonPermutations.Load(_29199 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _29209 = g_ScrambledHaltonPermutations.Load(_29199 * 4 + 0) & 65535u;
	                }
	                uint _29213 = 11097u + ((_12091 / 109561u) % 331u);
	                uint _29214 = _29213 / 2u;
	                uint _29224;
	                if ((_29213 & 1u) != 0u)
	                {
	                    _29224 = g_ScrambledHaltonPermutations.Load(_29214 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _29224 = g_ScrambledHaltonPermutations.Load(_29214 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_29194 * 109561u) + (_29209 * 331u)) + _29224) * 2.7575026706472272053360939025879e-08f;
	                _33360 = true;
	                break;
	            }
	            case 67u:
	            {
	                uint _29136 = 11428u + (_12091 % 337u);
	                uint _29137 = _29136 / 2u;
	                uint _29147;
	                if ((_29136 & 1u) != 0u)
	                {
	                    _29147 = g_ScrambledHaltonPermutations.Load(_29137 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _29147 = g_ScrambledHaltonPermutations.Load(_29137 * 4 + 0) & 65535u;
	                }
	                uint _29151 = 11428u + ((_12091 / 337u) % 337u);
	                uint _29152 = _29151 / 2u;
	                uint _29162;
	                if ((_29151 & 1u) != 0u)
	                {
	                    _29162 = g_ScrambledHaltonPermutations.Load(_29152 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _29162 = g_ScrambledHaltonPermutations.Load(_29152 * 4 + 0) & 65535u;
	                }
	                uint _29166 = 11428u + ((_12091 / 113569u) % 337u);
	                uint _29167 = _29166 / 2u;
	                uint _29177;
	                if ((_29166 & 1u) != 0u)
	                {
	                    _29177 = g_ScrambledHaltonPermutations.Load(_29167 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _29177 = g_ScrambledHaltonPermutations.Load(_29167 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_29147 * 113569u) + (_29162 * 337u)) + _29177) * 2.6128246233270147058647125959396e-08f;
	                _33360 = true;
	                break;
	            }
	            case 68u:
	            {
	                uint _29089 = 11765u + (_12091 % 347u);
	                uint _29090 = _29089 / 2u;
	                uint _29100;
	                if ((_29089 & 1u) != 0u)
	                {
	                    _29100 = g_ScrambledHaltonPermutations.Load(_29090 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _29100 = g_ScrambledHaltonPermutations.Load(_29090 * 4 + 0) & 65535u;
	                }
	                uint _29104 = 11765u + ((_12091 / 347u) % 347u);
	                uint _29105 = _29104 / 2u;
	                uint _29115;
	                if ((_29104 & 1u) != 0u)
	                {
	                    _29115 = g_ScrambledHaltonPermutations.Load(_29105 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _29115 = g_ScrambledHaltonPermutations.Load(_29105 * 4 + 0) & 65535u;
	                }
	                uint _29119 = 11765u + ((_12091 / 120409u) % 347u);
	                uint _29120 = _29119 / 2u;
	                uint _29130;
	                if ((_29119 & 1u) != 0u)
	                {
	                    _29130 = g_ScrambledHaltonPermutations.Load(_29120 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _29130 = g_ScrambledHaltonPermutations.Load(_29120 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_29100 * 120409u) + (_29115 * 347u)) + _29130) * 2.3933791837293938442599028348923e-08f;
	                _33360 = true;
	                break;
	            }
	            case 69u:
	            {
	                uint _29042 = 12112u + (_12091 % 349u);
	                uint _29043 = _29042 / 2u;
	                uint _29053;
	                if ((_29042 & 1u) != 0u)
	                {
	                    _29053 = g_ScrambledHaltonPermutations.Load(_29043 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _29053 = g_ScrambledHaltonPermutations.Load(_29043 * 4 + 0) & 65535u;
	                }
	                uint _29057 = 12112u + ((_12091 / 349u) % 349u);
	                uint _29058 = _29057 / 2u;
	                uint _29068;
	                if ((_29057 & 1u) != 0u)
	                {
	                    _29068 = g_ScrambledHaltonPermutations.Load(_29058 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _29068 = g_ScrambledHaltonPermutations.Load(_29058 * 4 + 0) & 65535u;
	                }
	                uint _29072 = 12112u + ((_12091 / 121801u) % 349u);
	                uint _29073 = _29072 / 2u;
	                uint _29083;
	                if ((_29072 & 1u) != 0u)
	                {
	                    _29083 = g_ScrambledHaltonPermutations.Load(_29073 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _29083 = g_ScrambledHaltonPermutations.Load(_29073 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_29053 * 121801u) + (_29068 * 349u)) + _29083) * 2.3524677317254827357828617095947e-08f;
	                _33360 = true;
	                break;
	            }
	            case 70u:
	            {
	                uint _28995 = 12461u + (_12091 % 353u);
	                uint _28996 = _28995 / 2u;
	                uint _29006;
	                if ((_28995 & 1u) != 0u)
	                {
	                    _29006 = g_ScrambledHaltonPermutations.Load(_28996 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _29006 = g_ScrambledHaltonPermutations.Load(_28996 * 4 + 0) & 65535u;
	                }
	                uint _29010 = 12461u + ((_12091 / 353u) % 353u);
	                uint _29011 = _29010 / 2u;
	                uint _29021;
	                if ((_29010 & 1u) != 0u)
	                {
	                    _29021 = g_ScrambledHaltonPermutations.Load(_29011 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _29021 = g_ScrambledHaltonPermutations.Load(_29011 * 4 + 0) & 65535u;
	                }
	                uint _29025 = 12461u + ((_12091 / 124609u) % 353u);
	                uint _29026 = _29025 / 2u;
	                uint _29036;
	                if ((_29025 & 1u) != 0u)
	                {
	                    _29036 = g_ScrambledHaltonPermutations.Load(_29026 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _29036 = g_ScrambledHaltonPermutations.Load(_29026 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_29006 * 124609u) + (_29021 * 353u)) + _29036) * 2.2733999571755703072994947433472e-08f;
	                _33360 = true;
	                break;
	            }
	            case 71u:
	            {
	                uint _28948 = 12814u + (_12091 % 359u);
	                uint _28949 = _28948 / 2u;
	                uint _28959;
	                if ((_28948 & 1u) != 0u)
	                {
	                    _28959 = g_ScrambledHaltonPermutations.Load(_28949 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _28959 = g_ScrambledHaltonPermutations.Load(_28949 * 4 + 0) & 65535u;
	                }
	                uint _28963 = 12814u + ((_12091 / 359u) % 359u);
	                uint _28964 = _28963 / 2u;
	                uint _28974;
	                if ((_28963 & 1u) != 0u)
	                {
	                    _28974 = g_ScrambledHaltonPermutations.Load(_28964 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _28974 = g_ScrambledHaltonPermutations.Load(_28964 * 4 + 0) & 65535u;
	                }
	                uint _28978 = 12814u + ((_12091 / 128881u) % 359u);
	                uint _28979 = _28978 / 2u;
	                uint _28989;
	                if ((_28978 & 1u) != 0u)
	                {
	                    _28989 = g_ScrambledHaltonPermutations.Load(_28979 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _28989 = g_ScrambledHaltonPermutations.Load(_28979 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_28959 * 128881u) + (_28974 * 359u)) + _28989) * 2.1613075773529999423772096633911e-08f;
	                _33360 = true;
	                break;
	            }
	            case 72u:
	            {
	                uint _28901 = 13173u + (_12091 % 367u);
	                uint _28902 = _28901 / 2u;
	                uint _28912;
	                if ((_28901 & 1u) != 0u)
	                {
	                    _28912 = g_ScrambledHaltonPermutations.Load(_28902 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _28912 = g_ScrambledHaltonPermutations.Load(_28902 * 4 + 0) & 65535u;
	                }
	                uint _28916 = 13173u + ((_12091 / 367u) % 367u);
	                uint _28917 = _28916 / 2u;
	                uint _28927;
	                if ((_28916 & 1u) != 0u)
	                {
	                    _28927 = g_ScrambledHaltonPermutations.Load(_28917 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _28927 = g_ScrambledHaltonPermutations.Load(_28917 * 4 + 0) & 65535u;
	                }
	                uint _28931 = 13173u + ((_12091 / 134689u) % 367u);
	                uint _28932 = _28931 / 2u;
	                uint _28942;
	                if ((_28931 & 1u) != 0u)
	                {
	                    _28942 = g_ScrambledHaltonPermutations.Load(_28932 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _28942 = g_ScrambledHaltonPermutations.Load(_28932 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_28912 * 134689u) + (_28927 * 367u)) + _28942) * 2.0230272568255713849794119596481e-08f;
	                _33360 = true;
	                break;
	            }
	            case 73u:
	            {
	                uint _28854 = 13540u + (_12091 % 373u);
	                uint _28855 = _28854 / 2u;
	                uint _28865;
	                if ((_28854 & 1u) != 0u)
	                {
	                    _28865 = g_ScrambledHaltonPermutations.Load(_28855 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _28865 = g_ScrambledHaltonPermutations.Load(_28855 * 4 + 0) & 65535u;
	                }
	                uint _28869 = 13540u + ((_12091 / 373u) % 373u);
	                uint _28870 = _28869 / 2u;
	                uint _28880;
	                if ((_28869 & 1u) != 0u)
	                {
	                    _28880 = g_ScrambledHaltonPermutations.Load(_28870 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _28880 = g_ScrambledHaltonPermutations.Load(_28870 * 4 + 0) & 65535u;
	                }
	                uint _28884 = 13540u + ((_12091 / 139129u) % 373u);
	                uint _28885 = _28884 / 2u;
	                uint _28895;
	                if ((_28884 & 1u) != 0u)
	                {
	                    _28895 = g_ScrambledHaltonPermutations.Load(_28885 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _28895 = g_ScrambledHaltonPermutations.Load(_28885 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_28865 * 139129u) + (_28880 * 373u)) + _28895) * 1.9269633000362773600500077009201e-08f;
	                _33360 = true;
	                break;
	            }
	            case 74u:
	            {
	                uint _28807 = 13913u + (_12091 % 379u);
	                uint _28808 = _28807 / 2u;
	                uint _28818;
	                if ((_28807 & 1u) != 0u)
	                {
	                    _28818 = g_ScrambledHaltonPermutations.Load(_28808 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _28818 = g_ScrambledHaltonPermutations.Load(_28808 * 4 + 0) & 65535u;
	                }
	                uint _28822 = 13913u + ((_12091 / 379u) % 379u);
	                uint _28823 = _28822 / 2u;
	                uint _28833;
	                if ((_28822 & 1u) != 0u)
	                {
	                    _28833 = g_ScrambledHaltonPermutations.Load(_28823 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _28833 = g_ScrambledHaltonPermutations.Load(_28823 * 4 + 0) & 65535u;
	                }
	                uint _28837 = 13913u + ((_12091 / 143641u) % 379u);
	                uint _28838 = _28837 / 2u;
	                uint _28848;
	                if ((_28837 & 1u) != 0u)
	                {
	                    _28848 = g_ScrambledHaltonPermutations.Load(_28838 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _28848 = g_ScrambledHaltonPermutations.Load(_28838 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_28818 * 143641u) + (_28833 * 379u)) + _28848) * 1.8368863763384979392867535352707e-08f;
	                _33360 = true;
	                break;
	            }
	            case 75u:
	            {
	                uint _28760 = 14292u + (_12091 % 383u);
	                uint _28761 = _28760 / 2u;
	                uint _28771;
	                if ((_28760 & 1u) != 0u)
	                {
	                    _28771 = g_ScrambledHaltonPermutations.Load(_28761 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _28771 = g_ScrambledHaltonPermutations.Load(_28761 * 4 + 0) & 65535u;
	                }
	                uint _28775 = 14292u + ((_12091 / 383u) % 383u);
	                uint _28776 = _28775 / 2u;
	                uint _28786;
	                if ((_28775 & 1u) != 0u)
	                {
	                    _28786 = g_ScrambledHaltonPermutations.Load(_28776 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _28786 = g_ScrambledHaltonPermutations.Load(_28776 * 4 + 0) & 65535u;
	                }
	                uint _28790 = 14292u + ((_12091 / 146689u) % 383u);
	                uint _28791 = _28790 / 2u;
	                uint _28801;
	                if ((_28790 & 1u) != 0u)
	                {
	                    _28801 = g_ScrambledHaltonPermutations.Load(_28791 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _28801 = g_ScrambledHaltonPermutations.Load(_28791 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_28771 * 146689u) + (_28786 * 383u)) + _28801) * 1.779932823353647108888253569603e-08f;
	                _33360 = true;
	                break;
	            }
	            case 76u:
	            {
	                uint _28713 = 14675u + (_12091 % 389u);
	                uint _28714 = _28713 / 2u;
	                uint _28724;
	                if ((_28713 & 1u) != 0u)
	                {
	                    _28724 = g_ScrambledHaltonPermutations.Load(_28714 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _28724 = g_ScrambledHaltonPermutations.Load(_28714 * 4 + 0) & 65535u;
	                }
	                uint _28728 = 14675u + ((_12091 / 389u) % 389u);
	                uint _28729 = _28728 / 2u;
	                uint _28739;
	                if ((_28728 & 1u) != 0u)
	                {
	                    _28739 = g_ScrambledHaltonPermutations.Load(_28729 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _28739 = g_ScrambledHaltonPermutations.Load(_28729 * 4 + 0) & 65535u;
	                }
	                uint _28743 = 14675u + ((_12091 / 151321u) % 389u);
	                uint _28744 = _28743 / 2u;
	                uint _28754;
	                if ((_28743 & 1u) != 0u)
	                {
	                    _28754 = g_ScrambledHaltonPermutations.Load(_28744 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _28754 = g_ScrambledHaltonPermutations.Load(_28744 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_28724 * 151321u) + (_28739 * 389u)) + _28754) * 1.6988348505719841341488063335419e-08f;
	                _33360 = true;
	                break;
	            }
	            case 77u:
	            {
	                uint _28666 = 15064u + (_12091 % 397u);
	                uint _28667 = _28666 / 2u;
	                uint _28677;
	                if ((_28666 & 1u) != 0u)
	                {
	                    _28677 = g_ScrambledHaltonPermutations.Load(_28667 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _28677 = g_ScrambledHaltonPermutations.Load(_28667 * 4 + 0) & 65535u;
	                }
	                uint _28681 = 15064u + ((_12091 / 397u) % 397u);
	                uint _28682 = _28681 / 2u;
	                uint _28692;
	                if ((_28681 & 1u) != 0u)
	                {
	                    _28692 = g_ScrambledHaltonPermutations.Load(_28682 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _28692 = g_ScrambledHaltonPermutations.Load(_28682 * 4 + 0) & 65535u;
	                }
	                uint _28696 = 15064u + ((_12091 / 157609u) % 397u);
	                uint _28697 = _28696 / 2u;
	                uint _28707;
	                if ((_28696 & 1u) != 0u)
	                {
	                    _28707 = g_ScrambledHaltonPermutations.Load(_28697 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _28707 = g_ScrambledHaltonPermutations.Load(_28697 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_28677 * 157609u) + (_28692 * 397u)) + _28707) * 1.5981900247652447433210909366608e-08f;
	                _33360 = true;
	                break;
	            }
	            case 78u:
	            {
	                uint _28619 = 15461u + (_12091 % 401u);
	                uint _28620 = _28619 / 2u;
	                uint _28630;
	                if ((_28619 & 1u) != 0u)
	                {
	                    _28630 = g_ScrambledHaltonPermutations.Load(_28620 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _28630 = g_ScrambledHaltonPermutations.Load(_28620 * 4 + 0) & 65535u;
	                }
	                uint _28634 = 15461u + ((_12091 / 401u) % 401u);
	                uint _28635 = _28634 / 2u;
	                uint _28645;
	                if ((_28634 & 1u) != 0u)
	                {
	                    _28645 = g_ScrambledHaltonPermutations.Load(_28635 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _28645 = g_ScrambledHaltonPermutations.Load(_28635 * 4 + 0) & 65535u;
	                }
	                uint _28649 = 15461u + ((_12091 / 160801u) % 401u);
	                uint _28650 = _28649 / 2u;
	                uint _28660;
	                if ((_28649 & 1u) != 0u)
	                {
	                    _28660 = g_ScrambledHaltonPermutations.Load(_28650 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _28660 = g_ScrambledHaltonPermutations.Load(_28650 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_28630 * 160801u) + (_28645 * 401u)) + _28660) * 1.5508394568541916669346392154694e-08f;
	                _33360 = true;
	                break;
	            }
	            case 79u:
	            {
	                uint _28572 = 15862u + (_12091 % 409u);
	                uint _28573 = _28572 / 2u;
	                uint _28583;
	                if ((_28572 & 1u) != 0u)
	                {
	                    _28583 = g_ScrambledHaltonPermutations.Load(_28573 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _28583 = g_ScrambledHaltonPermutations.Load(_28573 * 4 + 0) & 65535u;
	                }
	                uint _28587 = 15862u + ((_12091 / 409u) % 409u);
	                uint _28588 = _28587 / 2u;
	                uint _28598;
	                if ((_28587 & 1u) != 0u)
	                {
	                    _28598 = g_ScrambledHaltonPermutations.Load(_28588 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _28598 = g_ScrambledHaltonPermutations.Load(_28588 * 4 + 0) & 65535u;
	                }
	                uint _28602 = 15862u + ((_12091 / 167281u) % 409u);
	                uint _28603 = _28602 / 2u;
	                uint _28613;
	                if ((_28602 & 1u) != 0u)
	                {
	                    _28613 = g_ScrambledHaltonPermutations.Load(_28603 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _28613 = g_ScrambledHaltonPermutations.Load(_28603 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_28583 * 167281u) + (_28598 * 409u)) + _28613) * 1.4616050592053397849667817354202e-08f;
	                _33360 = true;
	                break;
	            }
	            case 80u:
	            {
	                uint _28525 = 16271u + (_12091 % 419u);
	                uint _28526 = _28525 / 2u;
	                uint _28536;
	                if ((_28525 & 1u) != 0u)
	                {
	                    _28536 = g_ScrambledHaltonPermutations.Load(_28526 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _28536 = g_ScrambledHaltonPermutations.Load(_28526 * 4 + 0) & 65535u;
	                }
	                uint _28540 = 16271u + ((_12091 / 419u) % 419u);
	                uint _28541 = _28540 / 2u;
	                uint _28551;
	                if ((_28540 & 1u) != 0u)
	                {
	                    _28551 = g_ScrambledHaltonPermutations.Load(_28541 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _28551 = g_ScrambledHaltonPermutations.Load(_28541 * 4 + 0) & 65535u;
	                }
	                uint _28555 = 16271u + ((_12091 / 175561u) % 419u);
	                uint _28556 = _28555 / 2u;
	                uint _28566;
	                if ((_28555 & 1u) != 0u)
	                {
	                    _28566 = g_ScrambledHaltonPermutations.Load(_28556 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _28566 = g_ScrambledHaltonPermutations.Load(_28556 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_28536 * 175561u) + (_28551 * 419u)) + _28566) * 1.3594332770594519388396292924881e-08f;
	                _33360 = true;
	                break;
	            }
	            case 81u:
	            {
	                uint _28478 = 16690u + (_12091 % 421u);
	                uint _28479 = _28478 / 2u;
	                uint _28489;
	                if ((_28478 & 1u) != 0u)
	                {
	                    _28489 = g_ScrambledHaltonPermutations.Load(_28479 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _28489 = g_ScrambledHaltonPermutations.Load(_28479 * 4 + 0) & 65535u;
	                }
	                uint _28493 = 16690u + ((_12091 / 421u) % 421u);
	                uint _28494 = _28493 / 2u;
	                uint _28504;
	                if ((_28493 & 1u) != 0u)
	                {
	                    _28504 = g_ScrambledHaltonPermutations.Load(_28494 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _28504 = g_ScrambledHaltonPermutations.Load(_28494 * 4 + 0) & 65535u;
	                }
	                uint _28508 = 16690u + ((_12091 / 177241u) % 421u);
	                uint _28509 = _28508 / 2u;
	                uint _28519;
	                if ((_28508 & 1u) != 0u)
	                {
	                    _28519 = g_ScrambledHaltonPermutations.Load(_28509 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _28519 = g_ScrambledHaltonPermutations.Load(_28509 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_28489 * 177241u) + (_28504 * 421u)) + _28519) * 1.3401507459320782800205051898956e-08f;
	                _33360 = true;
	                break;
	            }
	            case 82u:
	            {
	                uint _28431 = 17111u + (_12091 % 431u);
	                uint _28432 = _28431 / 2u;
	                uint _28442;
	                if ((_28431 & 1u) != 0u)
	                {
	                    _28442 = g_ScrambledHaltonPermutations.Load(_28432 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _28442 = g_ScrambledHaltonPermutations.Load(_28432 * 4 + 0) & 65535u;
	                }
	                uint _28446 = 17111u + ((_12091 / 431u) % 431u);
	                uint _28447 = _28446 / 2u;
	                uint _28457;
	                if ((_28446 & 1u) != 0u)
	                {
	                    _28457 = g_ScrambledHaltonPermutations.Load(_28447 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _28457 = g_ScrambledHaltonPermutations.Load(_28447 * 4 + 0) & 65535u;
	                }
	                uint _28461 = 17111u + ((_12091 / 185761u) % 431u);
	                uint _28462 = _28461 / 2u;
	                uint _28472;
	                if ((_28461 & 1u) != 0u)
	                {
	                    _28472 = g_ScrambledHaltonPermutations.Load(_28462 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _28472 = g_ScrambledHaltonPermutations.Load(_28462 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_28442 * 185761u) + (_28457 * 431u)) + _28472) * 1.249016357007803890155628323555e-08f;
	                _33360 = true;
	                break;
	            }
	            case 83u:
	            {
	                uint _28384 = 17542u + (_12091 % 433u);
	                uint _28385 = _28384 / 2u;
	                uint _28395;
	                if ((_28384 & 1u) != 0u)
	                {
	                    _28395 = g_ScrambledHaltonPermutations.Load(_28385 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _28395 = g_ScrambledHaltonPermutations.Load(_28385 * 4 + 0) & 65535u;
	                }
	                uint _28399 = 17542u + ((_12091 / 433u) % 433u);
	                uint _28400 = _28399 / 2u;
	                uint _28410;
	                if ((_28399 & 1u) != 0u)
	                {
	                    _28410 = g_ScrambledHaltonPermutations.Load(_28400 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _28410 = g_ScrambledHaltonPermutations.Load(_28400 * 4 + 0) & 65535u;
	                }
	                uint _28414 = 17542u + ((_12091 / 187489u) % 433u);
	                uint _28415 = _28414 / 2u;
	                uint _28425;
	                if ((_28414 & 1u) != 0u)
	                {
	                    _28425 = g_ScrambledHaltonPermutations.Load(_28415 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _28425 = g_ScrambledHaltonPermutations.Load(_28415 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_28395 * 187489u) + (_28410 * 433u)) + _28425) * 1.2317888042900904110865667462349e-08f;
	                _33360 = true;
	                break;
	            }
	            case 84u:
	            {
	                uint _28337 = 17975u + (_12091 % 439u);
	                uint _28338 = _28337 / 2u;
	                uint _28348;
	                if ((_28337 & 1u) != 0u)
	                {
	                    _28348 = g_ScrambledHaltonPermutations.Load(_28338 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _28348 = g_ScrambledHaltonPermutations.Load(_28338 * 4 + 0) & 65535u;
	                }
	                uint _28352 = 17975u + ((_12091 / 439u) % 439u);
	                uint _28353 = _28352 / 2u;
	                uint _28363;
	                if ((_28352 & 1u) != 0u)
	                {
	                    _28363 = g_ScrambledHaltonPermutations.Load(_28353 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _28363 = g_ScrambledHaltonPermutations.Load(_28353 * 4 + 0) & 65535u;
	                }
	                uint _28367 = 17975u + ((_12091 / 192721u) % 439u);
	                uint _28368 = _28367 / 2u;
	                uint _28378;
	                if ((_28367 & 1u) != 0u)
	                {
	                    _28378 = g_ScrambledHaltonPermutations.Load(_28368 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _28378 = g_ScrambledHaltonPermutations.Load(_28368 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_28348 * 192721u) + (_28363 * 439u)) + _28378) * 1.1819698109150067466543987393379e-08f;
	                _33360 = true;
	                break;
	            }
	            case 85u:
	            {
	                uint _28290 = 18414u + (_12091 % 443u);
	                uint _28291 = _28290 / 2u;
	                uint _28301;
	                if ((_28290 & 1u) != 0u)
	                {
	                    _28301 = g_ScrambledHaltonPermutations.Load(_28291 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _28301 = g_ScrambledHaltonPermutations.Load(_28291 * 4 + 0) & 65535u;
	                }
	                uint _28305 = 18414u + ((_12091 / 443u) % 443u);
	                uint _28306 = _28305 / 2u;
	                uint _28316;
	                if ((_28305 & 1u) != 0u)
	                {
	                    _28316 = g_ScrambledHaltonPermutations.Load(_28306 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _28316 = g_ScrambledHaltonPermutations.Load(_28306 * 4 + 0) & 65535u;
	                }
	                uint _28320 = 18414u + ((_12091 / 196249u) % 443u);
	                uint _28321 = _28320 / 2u;
	                uint _28331;
	                if ((_28320 & 1u) != 0u)
	                {
	                    _28331 = g_ScrambledHaltonPermutations.Load(_28321 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _28331 = g_ScrambledHaltonPermutations.Load(_28321 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_28301 * 196249u) + (_28316 * 443u)) + _28331) * 1.1502408803210073529044166207314e-08f;
	                _33360 = true;
	                break;
	            }
	            case 86u:
	            {
	                uint _28243 = 18857u + (_12091 % 449u);
	                uint _28244 = _28243 / 2u;
	                uint _28254;
	                if ((_28243 & 1u) != 0u)
	                {
	                    _28254 = g_ScrambledHaltonPermutations.Load(_28244 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _28254 = g_ScrambledHaltonPermutations.Load(_28244 * 4 + 0) & 65535u;
	                }
	                uint _28258 = 18857u + ((_12091 / 449u) % 449u);
	                uint _28259 = _28258 / 2u;
	                uint _28269;
	                if ((_28258 & 1u) != 0u)
	                {
	                    _28269 = g_ScrambledHaltonPermutations.Load(_28259 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _28269 = g_ScrambledHaltonPermutations.Load(_28259 * 4 + 0) & 65535u;
	                }
	                uint _28273 = 18857u + ((_12091 / 201601u) % 449u);
	                uint _28274 = _28273 / 2u;
	                uint _28284;
	                if ((_28273 & 1u) != 0u)
	                {
	                    _28284 = g_ScrambledHaltonPermutations.Load(_28274 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _28284 = g_ScrambledHaltonPermutations.Load(_28274 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_28254 * 201601u) + (_28269 * 449u)) + _28284) * 1.1047421644150290376273915171623e-08f;
	                _33360 = true;
	                break;
	            }
	            case 87u:
	            {
	                uint _28196 = 19306u + (_12091 % 457u);
	                uint _28197 = _28196 / 2u;
	                uint _28207;
	                if ((_28196 & 1u) != 0u)
	                {
	                    _28207 = g_ScrambledHaltonPermutations.Load(_28197 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _28207 = g_ScrambledHaltonPermutations.Load(_28197 * 4 + 0) & 65535u;
	                }
	                uint _28211 = 19306u + ((_12091 / 457u) % 457u);
	                uint _28212 = _28211 / 2u;
	                uint _28222;
	                if ((_28211 & 1u) != 0u)
	                {
	                    _28222 = g_ScrambledHaltonPermutations.Load(_28212 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _28222 = g_ScrambledHaltonPermutations.Load(_28212 * 4 + 0) & 65535u;
	                }
	                uint _28226 = 19306u + ((_12091 / 208849u) % 457u);
	                uint _28227 = _28226 / 2u;
	                uint _28237;
	                if ((_28226 & 1u) != 0u)
	                {
	                    _28237 = g_ScrambledHaltonPermutations.Load(_28227 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _28237 = g_ScrambledHaltonPermutations.Load(_28227 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_28207 * 208849u) + (_28222 * 457u)) + _28237) * 1.0477347878179443796398118138313e-08f;
	                _33360 = true;
	                break;
	            }
	            case 88u:
	            {
	                uint _28149 = 19763u + (_12091 % 461u);
	                uint _28150 = _28149 / 2u;
	                uint _28160;
	                if ((_28149 & 1u) != 0u)
	                {
	                    _28160 = g_ScrambledHaltonPermutations.Load(_28150 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _28160 = g_ScrambledHaltonPermutations.Load(_28150 * 4 + 0) & 65535u;
	                }
	                uint _28164 = 19763u + ((_12091 / 461u) % 461u);
	                uint _28165 = _28164 / 2u;
	                uint _28175;
	                if ((_28164 & 1u) != 0u)
	                {
	                    _28175 = g_ScrambledHaltonPermutations.Load(_28165 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _28175 = g_ScrambledHaltonPermutations.Load(_28165 * 4 + 0) & 65535u;
	                }
	                uint _28179 = 19763u + ((_12091 / 212521u) % 461u);
	                uint _28180 = _28179 / 2u;
	                uint _28190;
	                if ((_28179 & 1u) != 0u)
	                {
	                    _28190 = g_ScrambledHaltonPermutations.Load(_28180 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _28190 = g_ScrambledHaltonPermutations.Load(_28180 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_28160 * 212521u) + (_28175 * 461u)) + _28190) * 1.0206977485438528674421831965446e-08f;
	                _33360 = true;
	                break;
	            }
	            case 89u:
	            {
	                uint _28102 = 20224u + (_12091 % 463u);
	                uint _28103 = _28102 / 2u;
	                uint _28113;
	                if ((_28102 & 1u) != 0u)
	                {
	                    _28113 = g_ScrambledHaltonPermutations.Load(_28103 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _28113 = g_ScrambledHaltonPermutations.Load(_28103 * 4 + 0) & 65535u;
	                }
	                uint _28117 = 20224u + ((_12091 / 463u) % 463u);
	                uint _28118 = _28117 / 2u;
	                uint _28128;
	                if ((_28117 & 1u) != 0u)
	                {
	                    _28128 = g_ScrambledHaltonPermutations.Load(_28118 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _28128 = g_ScrambledHaltonPermutations.Load(_28118 * 4 + 0) & 65535u;
	                }
	                uint _28132 = 20224u + ((_12091 / 214369u) % 463u);
	                uint _28133 = _28132 / 2u;
	                uint _28143;
	                if ((_28132 & 1u) != 0u)
	                {
	                    _28143 = g_ScrambledHaltonPermutations.Load(_28133 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _28143 = g_ScrambledHaltonPermutations.Load(_28133 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_28113 * 214369u) + (_28128 * 463u)) + _28143) * 1.007527661300855470472015440464e-08f;
	                _33360 = true;
	                break;
	            }
	            case 90u:
	            {
	                uint _28055 = 20687u + (_12091 % 467u);
	                uint _28056 = _28055 / 2u;
	                uint _28066;
	                if ((_28055 & 1u) != 0u)
	                {
	                    _28066 = g_ScrambledHaltonPermutations.Load(_28056 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _28066 = g_ScrambledHaltonPermutations.Load(_28056 * 4 + 0) & 65535u;
	                }
	                uint _28070 = 20687u + ((_12091 / 467u) % 467u);
	                uint _28071 = _28070 / 2u;
	                uint _28081;
	                if ((_28070 & 1u) != 0u)
	                {
	                    _28081 = g_ScrambledHaltonPermutations.Load(_28071 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _28081 = g_ScrambledHaltonPermutations.Load(_28071 * 4 + 0) & 65535u;
	                }
	                uint _28085 = 20687u + ((_12091 / 218089u) % 467u);
	                uint _28086 = _28085 / 2u;
	                uint _28096;
	                if ((_28085 & 1u) != 0u)
	                {
	                    _28096 = g_ScrambledHaltonPermutations.Load(_28086 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _28096 = g_ScrambledHaltonPermutations.Load(_28086 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_28066 * 218089u) + (_28081 * 467u)) + _28096) * 9.8185948260720579128246754407883e-09f;
	                _33360 = true;
	                break;
	            }
	            case 91u:
	            {
	                uint _28008 = 21154u + (_12091 % 479u);
	                uint _28009 = _28008 / 2u;
	                uint _28019;
	                if ((_28008 & 1u) != 0u)
	                {
	                    _28019 = g_ScrambledHaltonPermutations.Load(_28009 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _28019 = g_ScrambledHaltonPermutations.Load(_28009 * 4 + 0) & 65535u;
	                }
	                uint _28023 = 21154u + ((_12091 / 479u) % 479u);
	                uint _28024 = _28023 / 2u;
	                uint _28034;
	                if ((_28023 & 1u) != 0u)
	                {
	                    _28034 = g_ScrambledHaltonPermutations.Load(_28024 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _28034 = g_ScrambledHaltonPermutations.Load(_28024 * 4 + 0) & 65535u;
	                }
	                uint _28038 = 21154u + ((_12091 / 229441u) % 479u);
	                uint _28039 = _28038 / 2u;
	                uint _28049;
	                if ((_28038 & 1u) != 0u)
	                {
	                    _28049 = g_ScrambledHaltonPermutations.Load(_28039 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _28049 = g_ScrambledHaltonPermutations.Load(_28039 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_28019 * 229441u) + (_28034 * 479u)) + _28049) * 9.0989944467878558498341590166092e-09f;
	                _33360 = true;
	                break;
	            }
	            case 92u:
	            {
	                uint _27961 = 21633u + (_12091 % 487u);
	                uint _27962 = _27961 / 2u;
	                uint _27972;
	                if ((_27961 & 1u) != 0u)
	                {
	                    _27972 = g_ScrambledHaltonPermutations.Load(_27962 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _27972 = g_ScrambledHaltonPermutations.Load(_27962 * 4 + 0) & 65535u;
	                }
	                uint _27976 = 21633u + ((_12091 / 487u) % 487u);
	                uint _27977 = _27976 / 2u;
	                uint _27987;
	                if ((_27976 & 1u) != 0u)
	                {
	                    _27987 = g_ScrambledHaltonPermutations.Load(_27977 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _27987 = g_ScrambledHaltonPermutations.Load(_27977 * 4 + 0) & 65535u;
	                }
	                uint _27991 = 21633u + ((_12091 / 237169u) % 487u);
	                uint _27992 = _27991 / 2u;
	                uint _28002;
	                if ((_27991 & 1u) != 0u)
	                {
	                    _28002 = g_ScrambledHaltonPermutations.Load(_27992 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _28002 = g_ScrambledHaltonPermutations.Load(_27992 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_27972 * 237169u) + (_27987 * 487u)) + _28002) * 8.6579099445316387573257088661194e-09f;
	                _33360 = true;
	                break;
	            }
	            case 93u:
	            {
	                uint _27914 = 22120u + (_12091 % 491u);
	                uint _27915 = _27914 / 2u;
	                uint _27925;
	                if ((_27914 & 1u) != 0u)
	                {
	                    _27925 = g_ScrambledHaltonPermutations.Load(_27915 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _27925 = g_ScrambledHaltonPermutations.Load(_27915 * 4 + 0) & 65535u;
	                }
	                uint _27929 = 22120u + ((_12091 / 491u) % 491u);
	                uint _27930 = _27929 / 2u;
	                uint _27940;
	                if ((_27929 & 1u) != 0u)
	                {
	                    _27940 = g_ScrambledHaltonPermutations.Load(_27930 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _27940 = g_ScrambledHaltonPermutations.Load(_27930 * 4 + 0) & 65535u;
	                }
	                uint _27944 = 22120u + ((_12091 / 241081u) % 491u);
	                uint _27945 = _27944 / 2u;
	                uint _27955;
	                if ((_27944 & 1u) != 0u)
	                {
	                    _27955 = g_ScrambledHaltonPermutations.Load(_27945 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _27955 = g_ScrambledHaltonPermutations.Load(_27945 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_27925 * 241081u) + (_27940 * 491u)) + _27955) * 8.4480307194212400645483285188675e-09f;
	                _33360 = true;
	                break;
	            }
	            case 94u:
	            {
	                uint _27867 = 22611u + (_12091 % 499u);
	                uint _27868 = _27867 / 2u;
	                uint _27878;
	                if ((_27867 & 1u) != 0u)
	                {
	                    _27878 = g_ScrambledHaltonPermutations.Load(_27868 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _27878 = g_ScrambledHaltonPermutations.Load(_27868 * 4 + 0) & 65535u;
	                }
	                uint _27882 = 22611u + ((_12091 / 499u) % 499u);
	                uint _27883 = _27882 / 2u;
	                uint _27893;
	                if ((_27882 & 1u) != 0u)
	                {
	                    _27893 = g_ScrambledHaltonPermutations.Load(_27883 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _27893 = g_ScrambledHaltonPermutations.Load(_27883 * 4 + 0) & 65535u;
	                }
	                uint _27897 = 22611u + ((_12091 / 249001u) % 499u);
	                uint _27898 = _27897 / 2u;
	                uint _27908;
	                if ((_27897 & 1u) != 0u)
	                {
	                    _27908 = g_ScrambledHaltonPermutations.Load(_27898 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _27908 = g_ScrambledHaltonPermutations.Load(_27898 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_27878 * 249001u) + (_27893 * 499u)) + _27908) * 8.0481914466190573875792324542999e-09f;
	                _33360 = true;
	                break;
	            }
	            case 95u:
	            {
	                uint _27820 = 23110u + (_12091 % 503u);
	                uint _27821 = _27820 / 2u;
	                uint _27831;
	                if ((_27820 & 1u) != 0u)
	                {
	                    _27831 = g_ScrambledHaltonPermutations.Load(_27821 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _27831 = g_ScrambledHaltonPermutations.Load(_27821 * 4 + 0) & 65535u;
	                }
	                uint _27835 = 23110u + ((_12091 / 503u) % 503u);
	                uint _27836 = _27835 / 2u;
	                uint _27846;
	                if ((_27835 & 1u) != 0u)
	                {
	                    _27846 = g_ScrambledHaltonPermutations.Load(_27836 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _27846 = g_ScrambledHaltonPermutations.Load(_27836 * 4 + 0) & 65535u;
	                }
	                uint _27850 = 23110u + ((_12091 / 253009u) % 503u);
	                uint _27851 = _27850 / 2u;
	                uint _27861;
	                if ((_27850 & 1u) != 0u)
	                {
	                    _27861 = g_ScrambledHaltonPermutations.Load(_27851 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _27861 = g_ScrambledHaltonPermutations.Load(_27851 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_27831 * 253009u) + (_27846 * 503u)) + _27861) * 7.8577100381949094298761337995529e-09f;
	                _33360 = true;
	                break;
	            }
	            case 96u:
	            {
	                uint _27773 = 23613u + (_12091 % 509u);
	                uint _27774 = _27773 / 2u;
	                uint _27784;
	                if ((_27773 & 1u) != 0u)
	                {
	                    _27784 = g_ScrambledHaltonPermutations.Load(_27774 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _27784 = g_ScrambledHaltonPermutations.Load(_27774 * 4 + 0) & 65535u;
	                }
	                uint _27788 = 23613u + ((_12091 / 509u) % 509u);
	                uint _27789 = _27788 / 2u;
	                uint _27799;
	                if ((_27788 & 1u) != 0u)
	                {
	                    _27799 = g_ScrambledHaltonPermutations.Load(_27789 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _27799 = g_ScrambledHaltonPermutations.Load(_27789 * 4 + 0) & 65535u;
	                }
	                uint _27803 = 23613u + ((_12091 / 259081u) % 509u);
	                uint _27804 = _27803 / 2u;
	                uint _27814;
	                if ((_27803 & 1u) != 0u)
	                {
	                    _27814 = g_ScrambledHaltonPermutations.Load(_27804 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _27814 = g_ScrambledHaltonPermutations.Load(_27804 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_27784 * 259081u) + (_27799 * 509u)) + _27814) * 7.5830968171430868096649646759033e-09f;
	                _33360 = true;
	                break;
	            }
	            case 97u:
	            {
	                uint _27726 = 24122u + (_12091 % 521u);
	                uint _27727 = _27726 / 2u;
	                uint _27737;
	                if ((_27726 & 1u) != 0u)
	                {
	                    _27737 = g_ScrambledHaltonPermutations.Load(_27727 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _27737 = g_ScrambledHaltonPermutations.Load(_27727 * 4 + 0) & 65535u;
	                }
	                uint _27741 = 24122u + ((_12091 / 521u) % 521u);
	                uint _27742 = _27741 / 2u;
	                uint _27752;
	                if ((_27741 & 1u) != 0u)
	                {
	                    _27752 = g_ScrambledHaltonPermutations.Load(_27742 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _27752 = g_ScrambledHaltonPermutations.Load(_27742 * 4 + 0) & 65535u;
	                }
	                uint _27756 = 24122u + ((_12091 / 271441u) % 521u);
	                uint _27757 = _27756 / 2u;
	                uint _27767;
	                if ((_27756 & 1u) != 0u)
	                {
	                    _27767 = g_ScrambledHaltonPermutations.Load(_27757 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _27767 = g_ScrambledHaltonPermutations.Load(_27757 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_27737 * 271441u) + (_27752 * 521u)) + _27767) * 7.0710965971443329181056469678879e-09f;
	                _33360 = true;
	                break;
	            }
	            case 98u:
	            {
	                uint _27679 = 24643u + (_12091 % 523u);
	                uint _27680 = _27679 / 2u;
	                uint _27690;
	                if ((_27679 & 1u) != 0u)
	                {
	                    _27690 = g_ScrambledHaltonPermutations.Load(_27680 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _27690 = g_ScrambledHaltonPermutations.Load(_27680 * 4 + 0) & 65535u;
	                }
	                uint _27694 = 24643u + ((_12091 / 523u) % 523u);
	                uint _27695 = _27694 / 2u;
	                uint _27705;
	                if ((_27694 & 1u) != 0u)
	                {
	                    _27705 = g_ScrambledHaltonPermutations.Load(_27695 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _27705 = g_ScrambledHaltonPermutations.Load(_27695 * 4 + 0) & 65535u;
	                }
	                uint _27709 = 24643u + ((_12091 / 273529u) % 523u);
	                uint _27710 = _27709 / 2u;
	                uint _27720;
	                if ((_27709 & 1u) != 0u)
	                {
	                    _27720 = g_ScrambledHaltonPermutations.Load(_27710 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _27720 = g_ScrambledHaltonPermutations.Load(_27710 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_27690 * 273529u) + (_27705 * 523u)) + _27720) * 6.9902852395387071737786754965782e-09f;
	                _33360 = true;
	                break;
	            }
	            case 99u:
	            {
	                uint _27632 = 25166u + (_12091 % 541u);
	                uint _27633 = _27632 / 2u;
	                uint _27643;
	                if ((_27632 & 1u) != 0u)
	                {
	                    _27643 = g_ScrambledHaltonPermutations.Load(_27633 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _27643 = g_ScrambledHaltonPermutations.Load(_27633 * 4 + 0) & 65535u;
	                }
	                uint _27647 = 25166u + ((_12091 / 541u) % 541u);
	                uint _27648 = _27647 / 2u;
	                uint _27658;
	                if ((_27647 & 1u) != 0u)
	                {
	                    _27658 = g_ScrambledHaltonPermutations.Load(_27648 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _27658 = g_ScrambledHaltonPermutations.Load(_27648 * 4 + 0) & 65535u;
	                }
	                uint _27662 = 25166u + ((_12091 / 292681u) % 541u);
	                uint _27663 = _27662 / 2u;
	                uint _27673;
	                if ((_27662 & 1u) != 0u)
	                {
	                    _27673 = g_ScrambledHaltonPermutations.Load(_27663 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _27673 = g_ScrambledHaltonPermutations.Load(_27663 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_27643 * 292681u) + (_27658 * 541u)) + _27673) * 6.3155063401154620805755257606506e-09f;
	                _33360 = true;
	                break;
	            }
	            case 100u:
	            {
	                uint _27585 = 25707u + (_12091 % 547u);
	                uint _27586 = _27585 / 2u;
	                uint _27596;
	                if ((_27585 & 1u) != 0u)
	                {
	                    _27596 = g_ScrambledHaltonPermutations.Load(_27586 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _27596 = g_ScrambledHaltonPermutations.Load(_27586 * 4 + 0) & 65535u;
	                }
	                uint _27600 = 25707u + ((_12091 / 547u) % 547u);
	                uint _27601 = _27600 / 2u;
	                uint _27611;
	                if ((_27600 & 1u) != 0u)
	                {
	                    _27611 = g_ScrambledHaltonPermutations.Load(_27601 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _27611 = g_ScrambledHaltonPermutations.Load(_27601 * 4 + 0) & 65535u;
	                }
	                uint _27615 = 25707u + ((_12091 / 299209u) % 547u);
	                uint _27616 = _27615 / 2u;
	                uint _27626;
	                if ((_27615 & 1u) != 0u)
	                {
	                    _27626 = g_ScrambledHaltonPermutations.Load(_27616 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _27626 = g_ScrambledHaltonPermutations.Load(_27616 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_27596 * 299209u) + (_27611 * 547u)) + _27626) * 6.1099543202658423979301005601883e-09f;
	                _33360 = true;
	                break;
	            }
	            case 101u:
	            {
	                uint _27538 = 26254u + (_12091 % 557u);
	                uint _27539 = _27538 / 2u;
	                uint _27549;
	                if ((_27538 & 1u) != 0u)
	                {
	                    _27549 = g_ScrambledHaltonPermutations.Load(_27539 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _27549 = g_ScrambledHaltonPermutations.Load(_27539 * 4 + 0) & 65535u;
	                }
	                uint _27553 = 26254u + ((_12091 / 557u) % 557u);
	                uint _27554 = _27553 / 2u;
	                uint _27564;
	                if ((_27553 & 1u) != 0u)
	                {
	                    _27564 = g_ScrambledHaltonPermutations.Load(_27554 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _27564 = g_ScrambledHaltonPermutations.Load(_27554 * 4 + 0) & 65535u;
	                }
	                uint _27568 = 26254u + ((_12091 / 310249u) % 557u);
	                uint _27569 = _27568 / 2u;
	                uint _27579;
	                if ((_27568 & 1u) != 0u)
	                {
	                    _27579 = g_ScrambledHaltonPermutations.Load(_27569 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _27579 = g_ScrambledHaltonPermutations.Load(_27569 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_27549 * 310249u) + (_27564 * 557u)) + _27579) * 5.7867453051585471257567405700684e-09f;
	                _33360 = true;
	                break;
	            }
	            case 102u:
	            {
	                uint _27491 = 26811u + (_12091 % 563u);
	                uint _27492 = _27491 / 2u;
	                uint _27502;
	                if ((_27491 & 1u) != 0u)
	                {
	                    _27502 = g_ScrambledHaltonPermutations.Load(_27492 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _27502 = g_ScrambledHaltonPermutations.Load(_27492 * 4 + 0) & 65535u;
	                }
	                uint _27506 = 26811u + ((_12091 / 563u) % 563u);
	                uint _27507 = _27506 / 2u;
	                uint _27517;
	                if ((_27506 & 1u) != 0u)
	                {
	                    _27517 = g_ScrambledHaltonPermutations.Load(_27507 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _27517 = g_ScrambledHaltonPermutations.Load(_27507 * 4 + 0) & 65535u;
	                }
	                uint _27521 = 26811u + ((_12091 / 316969u) % 563u);
	                uint _27522 = _27521 / 2u;
	                uint _27532;
	                if ((_27521 & 1u) != 0u)
	                {
	                    _27532 = g_ScrambledHaltonPermutations.Load(_27522 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _27532 = g_ScrambledHaltonPermutations.Load(_27522 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_27502 * 316969u) + (_27517 * 563u)) + _27532) * 5.6036983941964990663109347224236e-09f;
	                _33360 = true;
	                break;
	            }
	            case 103u:
	            {
	                uint _27444 = 27374u + (_12091 % 569u);
	                uint _27445 = _27444 / 2u;
	                uint _27455;
	                if ((_27444 & 1u) != 0u)
	                {
	                    _27455 = g_ScrambledHaltonPermutations.Load(_27445 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _27455 = g_ScrambledHaltonPermutations.Load(_27445 * 4 + 0) & 65535u;
	                }
	                uint _27459 = 27374u + ((_12091 / 569u) % 569u);
	                uint _27460 = _27459 / 2u;
	                uint _27470;
	                if ((_27459 & 1u) != 0u)
	                {
	                    _27470 = g_ScrambledHaltonPermutations.Load(_27460 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _27470 = g_ScrambledHaltonPermutations.Load(_27460 * 4 + 0) & 65535u;
	                }
	                uint _27474 = 27374u + ((_12091 / 323761u) % 569u);
	                uint _27475 = _27474 / 2u;
	                uint _27485;
	                if ((_27474 & 1u) != 0u)
	                {
	                    _27485 = g_ScrambledHaltonPermutations.Load(_27475 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _27485 = g_ScrambledHaltonPermutations.Load(_27475 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_27455 * 323761u) + (_27470 * 569u)) + _27485) * 5.4282911499115016340510919690132e-09f;
	                _33360 = true;
	                break;
	            }
	            case 104u:
	            {
	                uint _27397 = 27943u + (_12091 % 571u);
	                uint _27398 = _27397 / 2u;
	                uint _27408;
	                if ((_27397 & 1u) != 0u)
	                {
	                    _27408 = g_ScrambledHaltonPermutations.Load(_27398 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _27408 = g_ScrambledHaltonPermutations.Load(_27398 * 4 + 0) & 65535u;
	                }
	                uint _27412 = 27943u + ((_12091 / 571u) % 571u);
	                uint _27413 = _27412 / 2u;
	                uint _27423;
	                if ((_27412 & 1u) != 0u)
	                {
	                    _27423 = g_ScrambledHaltonPermutations.Load(_27413 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _27423 = g_ScrambledHaltonPermutations.Load(_27413 * 4 + 0) & 65535u;
	                }
	                uint _27427 = 27943u + ((_12091 / 326041u) % 571u);
	                uint _27428 = _27427 / 2u;
	                uint _27438;
	                if ((_27427 & 1u) != 0u)
	                {
	                    _27438 = g_ScrambledHaltonPermutations.Load(_27428 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _27438 = g_ScrambledHaltonPermutations.Load(_27428 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_27408 * 326041u) + (_27423 * 571u)) + _27438) * 5.3714512837643724196823313832283e-09f;
	                _33360 = true;
	                break;
	            }
	            case 105u:
	            {
	                uint _27350 = 28514u + (_12091 % 577u);
	                uint _27351 = _27350 / 2u;
	                uint _27361;
	                if ((_27350 & 1u) != 0u)
	                {
	                    _27361 = g_ScrambledHaltonPermutations.Load(_27351 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _27361 = g_ScrambledHaltonPermutations.Load(_27351 * 4 + 0) & 65535u;
	                }
	                uint _27365 = 28514u + ((_12091 / 577u) % 577u);
	                uint _27366 = _27365 / 2u;
	                uint _27376;
	                if ((_27365 & 1u) != 0u)
	                {
	                    _27376 = g_ScrambledHaltonPermutations.Load(_27366 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _27376 = g_ScrambledHaltonPermutations.Load(_27366 * 4 + 0) & 65535u;
	                }
	                uint _27380 = 28514u + ((_12091 / 332929u) % 577u);
	                uint _27381 = _27380 / 2u;
	                uint _27391;
	                if ((_27380 & 1u) != 0u)
	                {
	                    _27391 = g_ScrambledHaltonPermutations.Load(_27381 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _27391 = g_ScrambledHaltonPermutations.Load(_27381 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_27361 * 332929u) + (_27376 * 577u)) + _27391) * 5.2056203792005817376775667071342e-09f;
	                _33360 = true;
	                break;
	            }
	            case 106u:
	            {
	                uint _27303 = 29091u + (_12091 % 587u);
	                uint _27304 = _27303 / 2u;
	                uint _27314;
	                if ((_27303 & 1u) != 0u)
	                {
	                    _27314 = g_ScrambledHaltonPermutations.Load(_27304 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _27314 = g_ScrambledHaltonPermutations.Load(_27304 * 4 + 0) & 65535u;
	                }
	                uint _27318 = 29091u + ((_12091 / 587u) % 587u);
	                uint _27319 = _27318 / 2u;
	                uint _27329;
	                if ((_27318 & 1u) != 0u)
	                {
	                    _27329 = g_ScrambledHaltonPermutations.Load(_27319 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _27329 = g_ScrambledHaltonPermutations.Load(_27319 * 4 + 0) & 65535u;
	                }
	                uint _27333 = 29091u + ((_12091 / 344569u) % 587u);
	                uint _27334 = _27333 / 2u;
	                uint _27344;
	                if ((_27333 & 1u) != 0u)
	                {
	                    _27344 = g_ScrambledHaltonPermutations.Load(_27334 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _27344 = g_ScrambledHaltonPermutations.Load(_27334 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_27314 * 344569u) + (_27329 * 587u)) + _27344) * 4.9440820326651646610116586089134e-09f;
	                _33360 = true;
	                break;
	            }
	            case 107u:
	            {
	                uint _27256 = 29678u + (_12091 % 593u);
	                uint _27257 = _27256 / 2u;
	                uint _27267;
	                if ((_27256 & 1u) != 0u)
	                {
	                    _27267 = g_ScrambledHaltonPermutations.Load(_27257 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _27267 = g_ScrambledHaltonPermutations.Load(_27257 * 4 + 0) & 65535u;
	                }
	                uint _27271 = 29678u + ((_12091 / 593u) % 593u);
	                uint _27272 = _27271 / 2u;
	                uint _27282;
	                if ((_27271 & 1u) != 0u)
	                {
	                    _27282 = g_ScrambledHaltonPermutations.Load(_27272 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _27282 = g_ScrambledHaltonPermutations.Load(_27272 * 4 + 0) & 65535u;
	                }
	                uint _27286 = 29678u + ((_12091 / 351649u) % 593u);
	                uint _27287 = _27286 / 2u;
	                uint _27297;
	                if ((_27286 & 1u) != 0u)
	                {
	                    _27297 = g_ScrambledHaltonPermutations.Load(_27287 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _27297 = g_ScrambledHaltonPermutations.Load(_27287 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_27267 * 351649u) + (_27282 * 593u)) + _27297) * 4.7955217574724429141497239470482e-09f;
	                _33360 = true;
	                break;
	            }
	            case 108u:
	            {
	                uint _27209 = 30271u + (_12091 % 599u);
	                uint _27210 = _27209 / 2u;
	                uint _27220;
	                if ((_27209 & 1u) != 0u)
	                {
	                    _27220 = g_ScrambledHaltonPermutations.Load(_27210 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _27220 = g_ScrambledHaltonPermutations.Load(_27210 * 4 + 0) & 65535u;
	                }
	                uint _27224 = 30271u + ((_12091 / 599u) % 599u);
	                uint _27225 = _27224 / 2u;
	                uint _27235;
	                if ((_27224 & 1u) != 0u)
	                {
	                    _27235 = g_ScrambledHaltonPermutations.Load(_27225 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _27235 = g_ScrambledHaltonPermutations.Load(_27225 * 4 + 0) & 65535u;
	                }
	                uint _27239 = 30271u + ((_12091 / 358801u) % 599u);
	                uint _27240 = _27239 / 2u;
	                uint _27250;
	                if ((_27239 & 1u) != 0u)
	                {
	                    _27250 = g_ScrambledHaltonPermutations.Load(_27240 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _27250 = g_ScrambledHaltonPermutations.Load(_27240 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_27220 * 358801u) + (_27235 * 599u)) + _27250) * 4.6528545460944314982043579220772e-09f;
	                _33360 = true;
	                break;
	            }
	            case 109u:
	            {
	                uint _27162 = 30870u + (_12091 % 601u);
	                uint _27163 = _27162 / 2u;
	                uint _27173;
	                if ((_27162 & 1u) != 0u)
	                {
	                    _27173 = g_ScrambledHaltonPermutations.Load(_27163 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _27173 = g_ScrambledHaltonPermutations.Load(_27163 * 4 + 0) & 65535u;
	                }
	                uint _27177 = 30870u + ((_12091 / 601u) % 601u);
	                uint _27178 = _27177 / 2u;
	                uint _27188;
	                if ((_27177 & 1u) != 0u)
	                {
	                    _27188 = g_ScrambledHaltonPermutations.Load(_27178 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _27188 = g_ScrambledHaltonPermutations.Load(_27178 * 4 + 0) & 65535u;
	                }
	                uint _27192 = 30870u + ((_12091 / 361201u) % 601u);
	                uint _27193 = _27192 / 2u;
	                uint _27203;
	                if ((_27192 & 1u) != 0u)
	                {
	                    _27203 = g_ScrambledHaltonPermutations.Load(_27193 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _27203 = g_ScrambledHaltonPermutations.Load(_27193 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_27173 * 361201u) + (_27188 * 601u)) + _27203) * 4.6065578018783526204060763120651e-09f;
	                _33360 = true;
	                break;
	            }
	            case 110u:
	            {
	                uint _27115 = 31471u + (_12091 % 607u);
	                uint _27116 = _27115 / 2u;
	                uint _27126;
	                if ((_27115 & 1u) != 0u)
	                {
	                    _27126 = g_ScrambledHaltonPermutations.Load(_27116 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _27126 = g_ScrambledHaltonPermutations.Load(_27116 * 4 + 0) & 65535u;
	                }
	                uint _27130 = 31471u + ((_12091 / 607u) % 607u);
	                uint _27131 = _27130 / 2u;
	                uint _27141;
	                if ((_27130 & 1u) != 0u)
	                {
	                    _27141 = g_ScrambledHaltonPermutations.Load(_27131 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _27141 = g_ScrambledHaltonPermutations.Load(_27131 * 4 + 0) & 65535u;
	                }
	                uint _27145 = 31471u + ((_12091 / 368449u) % 607u);
	                uint _27146 = _27145 / 2u;
	                uint _27156;
	                if ((_27145 & 1u) != 0u)
	                {
	                    _27156 = g_ScrambledHaltonPermutations.Load(_27146 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _27156 = g_ScrambledHaltonPermutations.Load(_27146 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_27126 * 368449u) + (_27141 * 607u)) + _27156) * 4.4713006630558993492741137742996e-09f;
	                _33360 = true;
	                break;
	            }
	            case 111u:
	            {
	                uint _27068 = 32078u + (_12091 % 613u);
	                uint _27069 = _27068 / 2u;
	                uint _27079;
	                if ((_27068 & 1u) != 0u)
	                {
	                    _27079 = g_ScrambledHaltonPermutations.Load(_27069 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _27079 = g_ScrambledHaltonPermutations.Load(_27069 * 4 + 0) & 65535u;
	                }
	                uint _27083 = 32078u + ((_12091 / 613u) % 613u);
	                uint _27084 = _27083 / 2u;
	                uint _27094;
	                if ((_27083 & 1u) != 0u)
	                {
	                    _27094 = g_ScrambledHaltonPermutations.Load(_27084 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _27094 = g_ScrambledHaltonPermutations.Load(_27084 * 4 + 0) & 65535u;
	                }
	                uint _27098 = 32078u + ((_12091 / 375769u) % 613u);
	                uint _27099 = _27098 / 2u;
	                uint _27109;
	                if ((_27098 & 1u) != 0u)
	                {
	                    _27109 = g_ScrambledHaltonPermutations.Load(_27099 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _27109 = g_ScrambledHaltonPermutations.Load(_27099 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_27079 * 375769u) + (_27094 * 613u)) + _27109) * 4.3412873296233556175138801336288e-09f;
	                _33360 = true;
	                break;
	            }
	            case 112u:
	            {
	                uint _27021 = 32691u + (_12091 % 617u);
	                uint _27022 = _27021 / 2u;
	                uint _27032;
	                if ((_27021 & 1u) != 0u)
	                {
	                    _27032 = g_ScrambledHaltonPermutations.Load(_27022 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _27032 = g_ScrambledHaltonPermutations.Load(_27022 * 4 + 0) & 65535u;
	                }
	                uint _27036 = 32691u + ((_12091 / 617u) % 617u);
	                uint _27037 = _27036 / 2u;
	                uint _27047;
	                if ((_27036 & 1u) != 0u)
	                {
	                    _27047 = g_ScrambledHaltonPermutations.Load(_27037 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _27047 = g_ScrambledHaltonPermutations.Load(_27037 * 4 + 0) & 65535u;
	                }
	                uint _27051 = 32691u + ((_12091 / 380689u) % 617u);
	                uint _27052 = _27051 / 2u;
	                uint _27062;
	                if ((_27051 & 1u) != 0u)
	                {
	                    _27062 = g_ScrambledHaltonPermutations.Load(_27052 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _27062 = g_ScrambledHaltonPermutations.Load(_27052 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_27032 * 380689u) + (_27047 * 617u)) + _27062) * 4.2573997660610984894447028636932e-09f;
	                _33360 = true;
	                break;
	            }
	            case 113u:
	            {
	                uint _26974 = 33308u + (_12091 % 619u);
	                uint _26975 = _26974 / 2u;
	                uint _26985;
	                if ((_26974 & 1u) != 0u)
	                {
	                    _26985 = g_ScrambledHaltonPermutations.Load(_26975 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _26985 = g_ScrambledHaltonPermutations.Load(_26975 * 4 + 0) & 65535u;
	                }
	                uint _26989 = 33308u + ((_12091 / 619u) % 619u);
	                uint _26990 = _26989 / 2u;
	                uint _27000;
	                if ((_26989 & 1u) != 0u)
	                {
	                    _27000 = g_ScrambledHaltonPermutations.Load(_26990 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _27000 = g_ScrambledHaltonPermutations.Load(_26990 * 4 + 0) & 65535u;
	                }
	                uint _27004 = 33308u + ((_12091 / 383161u) % 619u);
	                uint _27005 = _27004 / 2u;
	                uint _27015;
	                if ((_27004 & 1u) != 0u)
	                {
	                    _27015 = g_ScrambledHaltonPermutations.Load(_27005 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _27015 = g_ScrambledHaltonPermutations.Load(_27005 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_26985 * 383161u) + (_27000 * 619u)) + _27015) * 4.2162660029987364396220073103905e-09f;
	                _33360 = true;
	                break;
	            }
	            case 114u:
	            {
	                uint _26927 = 33927u + (_12091 % 631u);
	                uint _26928 = _26927 / 2u;
	                uint _26938;
	                if ((_26927 & 1u) != 0u)
	                {
	                    _26938 = g_ScrambledHaltonPermutations.Load(_26928 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _26938 = g_ScrambledHaltonPermutations.Load(_26928 * 4 + 0) & 65535u;
	                }
	                uint _26942 = 33927u + ((_12091 / 631u) % 631u);
	                uint _26943 = _26942 / 2u;
	                uint _26953;
	                if ((_26942 & 1u) != 0u)
	                {
	                    _26953 = g_ScrambledHaltonPermutations.Load(_26943 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _26953 = g_ScrambledHaltonPermutations.Load(_26943 * 4 + 0) & 65535u;
	                }
	                uint _26957 = 33927u + ((_12091 / 398161u) % 631u);
	                uint _26958 = _26957 / 2u;
	                uint _26968;
	                if ((_26957 & 1u) != 0u)
	                {
	                    _26968 = g_ScrambledHaltonPermutations.Load(_26958 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _26968 = g_ScrambledHaltonPermutations.Load(_26958 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_26938 * 398161u) + (_26953 * 631u)) + _26968) * 3.9802641182973275135736912488937e-09f;
	                _33360 = true;
	                break;
	            }
	            case 115u:
	            {
	                uint _26880 = 34558u + (_12091 % 641u);
	                uint _26881 = _26880 / 2u;
	                uint _26891;
	                if ((_26880 & 1u) != 0u)
	                {
	                    _26891 = g_ScrambledHaltonPermutations.Load(_26881 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _26891 = g_ScrambledHaltonPermutations.Load(_26881 * 4 + 0) & 65535u;
	                }
	                uint _26895 = 34558u + ((_12091 / 641u) % 641u);
	                uint _26896 = _26895 / 2u;
	                uint _26906;
	                if ((_26895 & 1u) != 0u)
	                {
	                    _26906 = g_ScrambledHaltonPermutations.Load(_26896 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _26906 = g_ScrambledHaltonPermutations.Load(_26896 * 4 + 0) & 65535u;
	                }
	                uint _26910 = 34558u + ((_12091 / 410881u) % 641u);
	                uint _26911 = _26910 / 2u;
	                uint _26921;
	                if ((_26910 & 1u) != 0u)
	                {
	                    _26921 = g_ScrambledHaltonPermutations.Load(_26911 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _26921 = g_ScrambledHaltonPermutations.Load(_26911 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_26891 * 410881u) + (_26906 * 641u)) + _26921) * 3.7968712618408062553498893976212e-09f;
	                _33360 = true;
	                break;
	            }
	            case 116u:
	            {
	                uint _26833 = 35199u + (_12091 % 643u);
	                uint _26834 = _26833 / 2u;
	                uint _26844;
	                if ((_26833 & 1u) != 0u)
	                {
	                    _26844 = g_ScrambledHaltonPermutations.Load(_26834 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _26844 = g_ScrambledHaltonPermutations.Load(_26834 * 4 + 0) & 65535u;
	                }
	                uint _26848 = 35199u + ((_12091 / 643u) % 643u);
	                uint _26849 = _26848 / 2u;
	                uint _26859;
	                if ((_26848 & 1u) != 0u)
	                {
	                    _26859 = g_ScrambledHaltonPermutations.Load(_26849 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _26859 = g_ScrambledHaltonPermutations.Load(_26849 * 4 + 0) & 65535u;
	                }
	                uint _26863 = 35199u + ((_12091 / 413449u) % 643u);
	                uint _26864 = _26863 / 2u;
	                uint _26874;
	                if ((_26863 & 1u) != 0u)
	                {
	                    _26874 = g_ScrambledHaltonPermutations.Load(_26864 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _26874 = g_ScrambledHaltonPermutations.Load(_26864 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_26844 * 413449u) + (_26859 * 643u)) + _26874) * 3.7615515147138012252980843186378e-09f;
	                _33360 = true;
	                break;
	            }
	            case 117u:
	            {
	                uint _26786 = 35842u + (_12091 % 647u);
	                uint _26787 = _26786 / 2u;
	                uint _26797;
	                if ((_26786 & 1u) != 0u)
	                {
	                    _26797 = g_ScrambledHaltonPermutations.Load(_26787 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _26797 = g_ScrambledHaltonPermutations.Load(_26787 * 4 + 0) & 65535u;
	                }
	                uint _26801 = 35842u + ((_12091 / 647u) % 647u);
	                uint _26802 = _26801 / 2u;
	                uint _26812;
	                if ((_26801 & 1u) != 0u)
	                {
	                    _26812 = g_ScrambledHaltonPermutations.Load(_26802 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _26812 = g_ScrambledHaltonPermutations.Load(_26802 * 4 + 0) & 65535u;
	                }
	                uint _26816 = 35842u + ((_12091 / 418609u) % 647u);
	                uint _26817 = _26816 / 2u;
	                uint _26827;
	                if ((_26816 & 1u) != 0u)
	                {
	                    _26827 = g_ScrambledHaltonPermutations.Load(_26817 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _26827 = g_ScrambledHaltonPermutations.Load(_26817 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_26797 * 418609u) + (_26812 * 647u)) + _26827) * 3.6922158663799109490355476737022e-09f;
	                _33360 = true;
	                break;
	            }
	            case 118u:
	            {
	                uint _26739 = 36489u + (_12091 % 653u);
	                uint _26740 = _26739 / 2u;
	                uint _26750;
	                if ((_26739 & 1u) != 0u)
	                {
	                    _26750 = g_ScrambledHaltonPermutations.Load(_26740 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _26750 = g_ScrambledHaltonPermutations.Load(_26740 * 4 + 0) & 65535u;
	                }
	                uint _26754 = 36489u + ((_12091 / 653u) % 653u);
	                uint _26755 = _26754 / 2u;
	                uint _26765;
	                if ((_26754 & 1u) != 0u)
	                {
	                    _26765 = g_ScrambledHaltonPermutations.Load(_26755 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _26765 = g_ScrambledHaltonPermutations.Load(_26755 * 4 + 0) & 65535u;
	                }
	                uint _26769 = 36489u + ((_12091 / 426409u) % 653u);
	                uint _26770 = _26769 / 2u;
	                uint _26780;
	                if ((_26769 & 1u) != 0u)
	                {
	                    _26780 = g_ScrambledHaltonPermutations.Load(_26770 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _26780 = g_ScrambledHaltonPermutations.Load(_26770 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_26750 * 426409u) + (_26765 * 653u)) + _26780) * 3.5913718665625538051244802772999e-09f;
	                _33360 = true;
	                break;
	            }
	            case 119u:
	            {
	                uint _26692 = 37142u + (_12091 % 659u);
	                uint _26693 = _26692 / 2u;
	                uint _26703;
	                if ((_26692 & 1u) != 0u)
	                {
	                    _26703 = g_ScrambledHaltonPermutations.Load(_26693 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _26703 = g_ScrambledHaltonPermutations.Load(_26693 * 4 + 0) & 65535u;
	                }
	                uint _26707 = 37142u + ((_12091 / 659u) % 659u);
	                uint _26708 = _26707 / 2u;
	                uint _26718;
	                if ((_26707 & 1u) != 0u)
	                {
	                    _26718 = g_ScrambledHaltonPermutations.Load(_26708 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _26718 = g_ScrambledHaltonPermutations.Load(_26708 * 4 + 0) & 65535u;
	                }
	                uint _26722 = 37142u + ((_12091 / 434281u) % 659u);
	                uint _26723 = _26722 / 2u;
	                uint _26733;
	                if ((_26722 & 1u) != 0u)
	                {
	                    _26733 = g_ScrambledHaltonPermutations.Load(_26723 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _26733 = g_ScrambledHaltonPermutations.Load(_26723 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_26703 * 434281u) + (_26718 * 659u)) + _26733) * 3.4941673998645228493842296302319e-09f;
	                _33360 = true;
	                break;
	            }
	            case 120u:
	            {
	                uint _26645 = 37801u + (_12091 % 661u);
	                uint _26646 = _26645 / 2u;
	                uint _26656;
	                if ((_26645 & 1u) != 0u)
	                {
	                    _26656 = g_ScrambledHaltonPermutations.Load(_26646 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _26656 = g_ScrambledHaltonPermutations.Load(_26646 * 4 + 0) & 65535u;
	                }
	                uint _26660 = 37801u + ((_12091 / 661u) % 661u);
	                uint _26661 = _26660 / 2u;
	                uint _26671;
	                if ((_26660 & 1u) != 0u)
	                {
	                    _26671 = g_ScrambledHaltonPermutations.Load(_26661 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _26671 = g_ScrambledHaltonPermutations.Load(_26661 * 4 + 0) & 65535u;
	                }
	                uint _26675 = 37801u + ((_12091 / 436921u) % 661u);
	                uint _26676 = _26675 / 2u;
	                uint _26686;
	                if ((_26675 & 1u) != 0u)
	                {
	                    _26686 = g_ScrambledHaltonPermutations.Load(_26676 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _26686 = g_ScrambledHaltonPermutations.Load(_26676 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_26656 * 436921u) + (_26671 * 661u)) + _26686) * 3.4625462497217540658311918377876e-09f;
	                _33360 = true;
	                break;
	            }
	            case 121u:
	            {
	                uint _26598 = 38462u + (_12091 % 673u);
	                uint _26599 = _26598 / 2u;
	                uint _26609;
	                if ((_26598 & 1u) != 0u)
	                {
	                    _26609 = g_ScrambledHaltonPermutations.Load(_26599 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _26609 = g_ScrambledHaltonPermutations.Load(_26599 * 4 + 0) & 65535u;
	                }
	                uint _26613 = 38462u + ((_12091 / 673u) % 673u);
	                uint _26614 = _26613 / 2u;
	                uint _26624;
	                if ((_26613 & 1u) != 0u)
	                {
	                    _26624 = g_ScrambledHaltonPermutations.Load(_26614 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _26624 = g_ScrambledHaltonPermutations.Load(_26614 * 4 + 0) & 65535u;
	                }
	                uint _26628 = 38462u + ((_12091 / 452929u) % 673u);
	                uint _26629 = _26628 / 2u;
	                uint _26639;
	                if ((_26628 & 1u) != 0u)
	                {
	                    _26639 = g_ScrambledHaltonPermutations.Load(_26629 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _26639 = g_ScrambledHaltonPermutations.Load(_26629 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_26609 * 452929u) + (_26624 * 673u)) + _26639) * 3.2806111160965656381449662148952e-09f;
	                _33360 = true;
	                break;
	            }
	            case 122u:
	            {
	                uint _26551 = 39135u + (_12091 % 677u);
	                uint _26552 = _26551 / 2u;
	                uint _26562;
	                if ((_26551 & 1u) != 0u)
	                {
	                    _26562 = g_ScrambledHaltonPermutations.Load(_26552 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _26562 = g_ScrambledHaltonPermutations.Load(_26552 * 4 + 0) & 65535u;
	                }
	                uint _26566 = 39135u + ((_12091 / 677u) % 677u);
	                uint _26567 = _26566 / 2u;
	                uint _26577;
	                if ((_26566 & 1u) != 0u)
	                {
	                    _26577 = g_ScrambledHaltonPermutations.Load(_26567 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _26577 = g_ScrambledHaltonPermutations.Load(_26567 * 4 + 0) & 65535u;
	                }
	                uint _26581 = 39135u + ((_12091 / 458329u) % 677u);
	                uint _26582 = _26581 / 2u;
	                uint _26592;
	                if ((_26581 & 1u) != 0u)
	                {
	                    _26592 = g_ScrambledHaltonPermutations.Load(_26582 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _26592 = g_ScrambledHaltonPermutations.Load(_26582 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_26562 * 458329u) + (_26577 * 677u)) + _26592) * 3.2228042456949879124294966459274e-09f;
	                _33360 = true;
	                break;
	            }
	            case 123u:
	            {
	                uint _26504 = 39812u + (_12091 % 683u);
	                uint _26505 = _26504 / 2u;
	                uint _26515;
	                if ((_26504 & 1u) != 0u)
	                {
	                    _26515 = g_ScrambledHaltonPermutations.Load(_26505 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _26515 = g_ScrambledHaltonPermutations.Load(_26505 * 4 + 0) & 65535u;
	                }
	                uint _26519 = 39812u + ((_12091 / 683u) % 683u);
	                uint _26520 = _26519 / 2u;
	                uint _26530;
	                if ((_26519 & 1u) != 0u)
	                {
	                    _26530 = g_ScrambledHaltonPermutations.Load(_26520 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _26530 = g_ScrambledHaltonPermutations.Load(_26520 * 4 + 0) & 65535u;
	                }
	                uint _26534 = 39812u + ((_12091 / 466489u) % 683u);
	                uint _26535 = _26534 / 2u;
	                uint _26545;
	                if ((_26534 & 1u) != 0u)
	                {
	                    _26545 = g_ScrambledHaltonPermutations.Load(_26535 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _26545 = g_ScrambledHaltonPermutations.Load(_26535 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_26515 * 466489u) + (_26530 * 683u)) + _26545) * 3.1386133692024031915934756398201e-09f;
	                _33360 = true;
	                break;
	            }
	            case 124u:
	            {
	                uint _26457 = 40495u + (_12091 % 691u);
	                uint _26458 = _26457 / 2u;
	                uint _26468;
	                if ((_26457 & 1u) != 0u)
	                {
	                    _26468 = g_ScrambledHaltonPermutations.Load(_26458 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _26468 = g_ScrambledHaltonPermutations.Load(_26458 * 4 + 0) & 65535u;
	                }
	                uint _26472 = 40495u + ((_12091 / 691u) % 691u);
	                uint _26473 = _26472 / 2u;
	                uint _26483;
	                if ((_26472 & 1u) != 0u)
	                {
	                    _26483 = g_ScrambledHaltonPermutations.Load(_26473 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _26483 = g_ScrambledHaltonPermutations.Load(_26473 * 4 + 0) & 65535u;
	                }
	                uint _26487 = 40495u + ((_12091 / 477481u) % 691u);
	                uint _26488 = _26487 / 2u;
	                uint _26498;
	                if ((_26487 & 1u) != 0u)
	                {
	                    _26498 = g_ScrambledHaltonPermutations.Load(_26488 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _26498 = g_ScrambledHaltonPermutations.Load(_26488 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_26468 * 477481u) + (_26483 * 691u)) + _26498) * 3.0308595633243839984061196446419e-09f;
	                _33360 = true;
	                break;
	            }
	            case 125u:
	            {
	                uint _26410 = 41186u + (_12091 % 701u);
	                uint _26411 = _26410 / 2u;
	                uint _26421;
	                if ((_26410 & 1u) != 0u)
	                {
	                    _26421 = g_ScrambledHaltonPermutations.Load(_26411 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _26421 = g_ScrambledHaltonPermutations.Load(_26411 * 4 + 0) & 65535u;
	                }
	                uint _26425 = 41186u + ((_12091 / 701u) % 701u);
	                uint _26426 = _26425 / 2u;
	                uint _26436;
	                if ((_26425 & 1u) != 0u)
	                {
	                    _26436 = g_ScrambledHaltonPermutations.Load(_26426 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _26436 = g_ScrambledHaltonPermutations.Load(_26426 * 4 + 0) & 65535u;
	                }
	                uint _26440 = 41186u + ((_12091 / 491401u) % 701u);
	                uint _26441 = _26440 / 2u;
	                uint _26451;
	                if ((_26440 & 1u) != 0u)
	                {
	                    _26451 = g_ScrambledHaltonPermutations.Load(_26441 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _26451 = g_ScrambledHaltonPermutations.Load(_26441 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_26421 * 491401u) + (_26436 * 701u)) + _26451) * 2.9029925130430456192698329687119e-09f;
	                _33360 = true;
	                break;
	            }
	            case 126u:
	            {
	                uint _26363 = 41887u + (_12091 % 709u);
	                uint _26364 = _26363 / 2u;
	                uint _26374;
	                if ((_26363 & 1u) != 0u)
	                {
	                    _26374 = g_ScrambledHaltonPermutations.Load(_26364 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _26374 = g_ScrambledHaltonPermutations.Load(_26364 * 4 + 0) & 65535u;
	                }
	                uint _26378 = 41887u + ((_12091 / 709u) % 709u);
	                uint _26379 = _26378 / 2u;
	                uint _26389;
	                if ((_26378 & 1u) != 0u)
	                {
	                    _26389 = g_ScrambledHaltonPermutations.Load(_26379 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _26389 = g_ScrambledHaltonPermutations.Load(_26379 * 4 + 0) & 65535u;
	                }
	                uint _26393 = 41887u + ((_12091 / 502681u) % 709u);
	                uint _26394 = _26393 / 2u;
	                uint _26404;
	                if ((_26393 & 1u) != 0u)
	                {
	                    _26404 = g_ScrambledHaltonPermutations.Load(_26394 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _26404 = g_ScrambledHaltonPermutations.Load(_26394 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_26374 * 502681u) + (_26389 * 709u)) + _26404) * 2.8058293466415307193528860807419e-09f;
	                _33360 = true;
	                break;
	            }
	            case 127u:
	            {
	                uint _26316 = 42596u + (_12091 % 719u);
	                uint _26317 = _26316 / 2u;
	                uint _26327;
	                if ((_26316 & 1u) != 0u)
	                {
	                    _26327 = g_ScrambledHaltonPermutations.Load(_26317 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _26327 = g_ScrambledHaltonPermutations.Load(_26317 * 4 + 0) & 65535u;
	                }
	                uint _26331 = 42596u + ((_12091 / 719u) % 719u);
	                uint _26332 = _26331 / 2u;
	                uint _26342;
	                if ((_26331 & 1u) != 0u)
	                {
	                    _26342 = g_ScrambledHaltonPermutations.Load(_26332 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _26342 = g_ScrambledHaltonPermutations.Load(_26332 * 4 + 0) & 65535u;
	                }
	                uint _26346 = 42596u + ((_12091 / 516961u) % 719u);
	                uint _26347 = _26346 / 2u;
	                uint _26357;
	                if ((_26346 & 1u) != 0u)
	                {
	                    _26357 = g_ScrambledHaltonPermutations.Load(_26347 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _26357 = g_ScrambledHaltonPermutations.Load(_26347 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_26327 * 516961u) + (_26342 * 719u)) + _26357) * 2.6903779204445754658081568777561e-09f;
	                _33360 = true;
	                break;
	            }
	            case 128u:
	            {
	                uint _26269 = 43315u + (_12091 % 727u);
	                uint _26270 = _26269 / 2u;
	                uint _26280;
	                if ((_26269 & 1u) != 0u)
	                {
	                    _26280 = g_ScrambledHaltonPermutations.Load(_26270 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _26280 = g_ScrambledHaltonPermutations.Load(_26270 * 4 + 0) & 65535u;
	                }
	                uint _26284 = 43315u + ((_12091 / 727u) % 727u);
	                uint _26285 = _26284 / 2u;
	                uint _26295;
	                if ((_26284 & 1u) != 0u)
	                {
	                    _26295 = g_ScrambledHaltonPermutations.Load(_26285 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _26295 = g_ScrambledHaltonPermutations.Load(_26285 * 4 + 0) & 65535u;
	                }
	                uint _26299 = 43315u + ((_12091 / 528529u) % 727u);
	                uint _26300 = _26299 / 2u;
	                uint _26310;
	                if ((_26299 & 1u) != 0u)
	                {
	                    _26310 = g_ScrambledHaltonPermutations.Load(_26300 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _26310 = g_ScrambledHaltonPermutations.Load(_26300 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_26280 * 528529u) + (_26295 * 727u)) + _26310) * 2.6025359645132084551732987165451e-09f;
	                _33360 = true;
	                break;
	            }
	            case 129u:
	            {
	                uint _26222 = 44042u + (_12091 % 733u);
	                uint _26223 = _26222 / 2u;
	                uint _26233;
	                if ((_26222 & 1u) != 0u)
	                {
	                    _26233 = g_ScrambledHaltonPermutations.Load(_26223 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _26233 = g_ScrambledHaltonPermutations.Load(_26223 * 4 + 0) & 65535u;
	                }
	                uint _26237 = 44042u + ((_12091 / 733u) % 733u);
	                uint _26238 = _26237 / 2u;
	                uint _26248;
	                if ((_26237 & 1u) != 0u)
	                {
	                    _26248 = g_ScrambledHaltonPermutations.Load(_26238 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _26248 = g_ScrambledHaltonPermutations.Load(_26238 * 4 + 0) & 65535u;
	                }
	                uint _26252 = 44042u + ((_12091 / 537289u) % 733u);
	                uint _26253 = _26252 / 2u;
	                uint _26263;
	                if ((_26252 & 1u) != 0u)
	                {
	                    _26263 = g_ScrambledHaltonPermutations.Load(_26253 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _26263 = g_ScrambledHaltonPermutations.Load(_26253 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_26233 * 537289u) + (_26248 * 733u)) + _26263) * 2.5391480029668400675291195511818e-09f;
	                _33360 = true;
	                break;
	            }
	            case 130u:
	            {
	                uint _26175 = 44775u + (_12091 % 739u);
	                uint _26176 = _26175 / 2u;
	                uint _26186;
	                if ((_26175 & 1u) != 0u)
	                {
	                    _26186 = g_ScrambledHaltonPermutations.Load(_26176 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _26186 = g_ScrambledHaltonPermutations.Load(_26176 * 4 + 0) & 65535u;
	                }
	                uint _26190 = 44775u + ((_12091 / 739u) % 739u);
	                uint _26191 = _26190 / 2u;
	                uint _26201;
	                if ((_26190 & 1u) != 0u)
	                {
	                    _26201 = g_ScrambledHaltonPermutations.Load(_26191 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _26201 = g_ScrambledHaltonPermutations.Load(_26191 * 4 + 0) & 65535u;
	                }
	                uint _26205 = 44775u + ((_12091 / 546121u) % 739u);
	                uint _26206 = _26205 / 2u;
	                uint _26216;
	                if ((_26205 & 1u) != 0u)
	                {
	                    _26216 = g_ScrambledHaltonPermutations.Load(_26206 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _26216 = g_ScrambledHaltonPermutations.Load(_26206 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_26186 * 546121u) + (_26201 * 739u)) + _26216) * 2.4778021856519671928253956139088e-09f;
	                _33360 = true;
	                break;
	            }
	            case 131u:
	            {
	                uint _26128 = 45514u + (_12091 % 743u);
	                uint _26129 = _26128 / 2u;
	                uint _26139;
	                if ((_26128 & 1u) != 0u)
	                {
	                    _26139 = g_ScrambledHaltonPermutations.Load(_26129 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _26139 = g_ScrambledHaltonPermutations.Load(_26129 * 4 + 0) & 65535u;
	                }
	                uint _26143 = 45514u + ((_12091 / 743u) % 743u);
	                uint _26144 = _26143 / 2u;
	                uint _26154;
	                if ((_26143 & 1u) != 0u)
	                {
	                    _26154 = g_ScrambledHaltonPermutations.Load(_26144 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _26154 = g_ScrambledHaltonPermutations.Load(_26144 * 4 + 0) & 65535u;
	                }
	                uint _26158 = 45514u + ((_12091 / 552049u) % 743u);
	                uint _26159 = _26158 / 2u;
	                uint _26169;
	                if ((_26158 & 1u) != 0u)
	                {
	                    _26169 = g_ScrambledHaltonPermutations.Load(_26159 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _26169 = g_ScrambledHaltonPermutations.Load(_26159 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_26139 * 552049u) + (_26154 * 743u)) + _26169) * 2.437998913862315930600743740797e-09f;
	                _33360 = true;
	                break;
	            }
	            case 132u:
	            {
	                uint _26081 = 46257u + (_12091 % 751u);
	                uint _26082 = _26081 / 2u;
	                uint _26092;
	                if ((_26081 & 1u) != 0u)
	                {
	                    _26092 = g_ScrambledHaltonPermutations.Load(_26082 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _26092 = g_ScrambledHaltonPermutations.Load(_26082 * 4 + 0) & 65535u;
	                }
	                uint _26096 = 46257u + ((_12091 / 751u) % 751u);
	                uint _26097 = _26096 / 2u;
	                uint _26107;
	                if ((_26096 & 1u) != 0u)
	                {
	                    _26107 = g_ScrambledHaltonPermutations.Load(_26097 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _26107 = g_ScrambledHaltonPermutations.Load(_26097 * 4 + 0) & 65535u;
	                }
	                uint _26111 = 46257u + ((_12091 / 564001u) % 751u);
	                uint _26112 = _26111 / 2u;
	                uint _26122;
	                if ((_26111 & 1u) != 0u)
	                {
	                    _26122 = g_ScrambledHaltonPermutations.Load(_26112 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _26122 = g_ScrambledHaltonPermutations.Load(_26112 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_26092 * 564001u) + (_26107 * 751u)) + _26122) * 2.3609139088165420616860501468182e-09f;
	                _33360 = true;
	                break;
	            }
	            case 133u:
	            {
	                uint _26034 = 47008u + (_12091 % 757u);
	                uint _26035 = _26034 / 2u;
	                uint _26045;
	                if ((_26034 & 1u) != 0u)
	                {
	                    _26045 = g_ScrambledHaltonPermutations.Load(_26035 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _26045 = g_ScrambledHaltonPermutations.Load(_26035 * 4 + 0) & 65535u;
	                }
	                uint _26049 = 47008u + ((_12091 / 757u) % 757u);
	                uint _26050 = _26049 / 2u;
	                uint _26060;
	                if ((_26049 & 1u) != 0u)
	                {
	                    _26060 = g_ScrambledHaltonPermutations.Load(_26050 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _26060 = g_ScrambledHaltonPermutations.Load(_26050 * 4 + 0) & 65535u;
	                }
	                uint _26064 = 47008u + ((_12091 / 573049u) % 757u);
	                uint _26065 = _26064 / 2u;
	                uint _26075;
	                if ((_26064 & 1u) != 0u)
	                {
	                    _26075 = g_ScrambledHaltonPermutations.Load(_26065 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _26075 = g_ScrambledHaltonPermutations.Load(_26065 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_26045 * 573049u) + (_26060 * 757u)) + _26075) * 2.3052197928308260088670067489147e-09f;
	                _33360 = true;
	                break;
	            }
	            case 134u:
	            {
	                uint _25987 = 47765u + (_12091 % 761u);
	                uint _25988 = _25987 / 2u;
	                uint _25998;
	                if ((_25987 & 1u) != 0u)
	                {
	                    _25998 = g_ScrambledHaltonPermutations.Load(_25988 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _25998 = g_ScrambledHaltonPermutations.Load(_25988 * 4 + 0) & 65535u;
	                }
	                uint _26002 = 47765u + ((_12091 / 761u) % 761u);
	                uint _26003 = _26002 / 2u;
	                uint _26013;
	                if ((_26002 & 1u) != 0u)
	                {
	                    _26013 = g_ScrambledHaltonPermutations.Load(_26003 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _26013 = g_ScrambledHaltonPermutations.Load(_26003 * 4 + 0) & 65535u;
	                }
	                uint _26017 = 47765u + ((_12091 / 579121u) % 761u);
	                uint _26018 = _26017 / 2u;
	                uint _26028;
	                if ((_26017 & 1u) != 0u)
	                {
	                    _26028 = g_ScrambledHaltonPermutations.Load(_26018 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _26028 = g_ScrambledHaltonPermutations.Load(_26018 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_25998 * 579121u) + (_26013 * 761u)) + _26028) * 2.2690600509633895853767171502113e-09f;
	                _33360 = true;
	                break;
	            }
	            case 135u:
	            {
	                uint _25940 = 48526u + (_12091 % 769u);
	                uint _25941 = _25940 / 2u;
	                uint _25951;
	                if ((_25940 & 1u) != 0u)
	                {
	                    _25951 = g_ScrambledHaltonPermutations.Load(_25941 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _25951 = g_ScrambledHaltonPermutations.Load(_25941 * 4 + 0) & 65535u;
	                }
	                uint _25955 = 48526u + ((_12091 / 769u) % 769u);
	                uint _25956 = _25955 / 2u;
	                uint _25966;
	                if ((_25955 & 1u) != 0u)
	                {
	                    _25966 = g_ScrambledHaltonPermutations.Load(_25956 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _25966 = g_ScrambledHaltonPermutations.Load(_25956 * 4 + 0) & 65535u;
	                }
	                uint _25970 = 48526u + ((_12091 / 591361u) % 769u);
	                uint _25971 = _25970 / 2u;
	                uint _25981;
	                if ((_25970 & 1u) != 0u)
	                {
	                    _25981 = g_ScrambledHaltonPermutations.Load(_25971 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _25981 = g_ScrambledHaltonPermutations.Load(_25971 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_25951 * 591361u) + (_25966 * 769u)) + _25981) * 2.1989783327569512039190158247948e-09f;
	                _33360 = true;
	                break;
	            }
	            case 136u:
	            {
	                uint _25893 = 49295u + (_12091 % 773u);
	                uint _25894 = _25893 / 2u;
	                uint _25904;
	                if ((_25893 & 1u) != 0u)
	                {
	                    _25904 = g_ScrambledHaltonPermutations.Load(_25894 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _25904 = g_ScrambledHaltonPermutations.Load(_25894 * 4 + 0) & 65535u;
	                }
	                uint _25908 = 49295u + ((_12091 / 773u) % 773u);
	                uint _25909 = _25908 / 2u;
	                uint _25919;
	                if ((_25908 & 1u) != 0u)
	                {
	                    _25919 = g_ScrambledHaltonPermutations.Load(_25909 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _25919 = g_ScrambledHaltonPermutations.Load(_25909 * 4 + 0) & 65535u;
	                }
	                uint _25923 = 49295u + ((_12091 / 597529u) % 773u);
	                uint _25924 = _25923 / 2u;
	                uint _25934;
	                if ((_25923 & 1u) != 0u)
	                {
	                    _25934 = g_ScrambledHaltonPermutations.Load(_25924 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _25934 = g_ScrambledHaltonPermutations.Load(_25924 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_25904 * 597529u) + (_25919 * 773u)) + _25934) * 2.1650177206566922905039973556995e-09f;
	                _33360 = true;
	                break;
	            }
	            case 137u:
	            {
	                uint _25846 = 50068u + (_12091 % 787u);
	                uint _25847 = _25846 / 2u;
	                uint _25857;
	                if ((_25846 & 1u) != 0u)
	                {
	                    _25857 = g_ScrambledHaltonPermutations.Load(_25847 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _25857 = g_ScrambledHaltonPermutations.Load(_25847 * 4 + 0) & 65535u;
	                }
	                uint _25861 = 50068u + ((_12091 / 787u) % 787u);
	                uint _25862 = _25861 / 2u;
	                uint _25872;
	                if ((_25861 & 1u) != 0u)
	                {
	                    _25872 = g_ScrambledHaltonPermutations.Load(_25862 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _25872 = g_ScrambledHaltonPermutations.Load(_25862 * 4 + 0) & 65535u;
	                }
	                uint _25876 = 50068u + ((_12091 / 619369u) % 787u);
	                uint _25877 = _25876 / 2u;
	                uint _25887;
	                if ((_25876 & 1u) != 0u)
	                {
	                    _25887 = g_ScrambledHaltonPermutations.Load(_25877 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _25887 = g_ScrambledHaltonPermutations.Load(_25877 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_25857 * 619369u) + (_25872 * 787u)) + _25887) * 2.0515200649384723874391056597233e-09f;
	                _33360 = true;
	                break;
	            }
	            case 138u:
	            {
	                uint _25799 = 50855u + (_12091 % 797u);
	                uint _25800 = _25799 / 2u;
	                uint _25810;
	                if ((_25799 & 1u) != 0u)
	                {
	                    _25810 = g_ScrambledHaltonPermutations.Load(_25800 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _25810 = g_ScrambledHaltonPermutations.Load(_25800 * 4 + 0) & 65535u;
	                }
	                uint _25814 = 50855u + ((_12091 / 797u) % 797u);
	                uint _25815 = _25814 / 2u;
	                uint _25825;
	                if ((_25814 & 1u) != 0u)
	                {
	                    _25825 = g_ScrambledHaltonPermutations.Load(_25815 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _25825 = g_ScrambledHaltonPermutations.Load(_25815 * 4 + 0) & 65535u;
	                }
	                uint _25829 = 50855u + ((_12091 / 635209u) % 797u);
	                uint _25830 = _25829 / 2u;
	                uint _25840;
	                if ((_25829 & 1u) != 0u)
	                {
	                    _25840 = g_ScrambledHaltonPermutations.Load(_25830 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _25840 = g_ScrambledHaltonPermutations.Load(_25830 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_25810 * 635209u) + (_25825 * 797u)) + _25840) * 1.9752632862690688853035680949688e-09f;
	                _33360 = true;
	                break;
	            }
	            case 139u:
	            {
	                uint _25752 = 51652u + (_12091 % 809u);
	                uint _25753 = _25752 / 2u;
	                uint _25763;
	                if ((_25752 & 1u) != 0u)
	                {
	                    _25763 = g_ScrambledHaltonPermutations.Load(_25753 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _25763 = g_ScrambledHaltonPermutations.Load(_25753 * 4 + 0) & 65535u;
	                }
	                uint _25767 = 51652u + ((_12091 / 809u) % 809u);
	                uint _25768 = _25767 / 2u;
	                uint _25778;
	                if ((_25767 & 1u) != 0u)
	                {
	                    _25778 = g_ScrambledHaltonPermutations.Load(_25768 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _25778 = g_ScrambledHaltonPermutations.Load(_25768 * 4 + 0) & 65535u;
	                }
	                uint _25782 = 51652u + ((_12091 / 654481u) % 809u);
	                uint _25783 = _25782 / 2u;
	                uint _25793;
	                if ((_25782 & 1u) != 0u)
	                {
	                    _25793 = g_ScrambledHaltonPermutations.Load(_25783 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _25793 = g_ScrambledHaltonPermutations.Load(_25783 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_25763 * 654481u) + (_25778 * 809u)) + _25793) * 1.8886625596792327996809035539627e-09f;
	                _33360 = true;
	                break;
	            }
	            case 140u:
	            {
	                uint _25705 = 52461u + (_12091 % 811u);
	                uint _25706 = _25705 / 2u;
	                uint _25716;
	                if ((_25705 & 1u) != 0u)
	                {
	                    _25716 = g_ScrambledHaltonPermutations.Load(_25706 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _25716 = g_ScrambledHaltonPermutations.Load(_25706 * 4 + 0) & 65535u;
	                }
	                uint _25720 = 52461u + ((_12091 / 811u) % 811u);
	                uint _25721 = _25720 / 2u;
	                uint _25731;
	                if ((_25720 & 1u) != 0u)
	                {
	                    _25731 = g_ScrambledHaltonPermutations.Load(_25721 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _25731 = g_ScrambledHaltonPermutations.Load(_25721 * 4 + 0) & 65535u;
	                }
	                uint _25735 = 52461u + ((_12091 / 657721u) % 811u);
	                uint _25736 = _25735 / 2u;
	                uint _25746;
	                if ((_25735 & 1u) != 0u)
	                {
	                    _25746 = g_ScrambledHaltonPermutations.Load(_25736 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _25746 = g_ScrambledHaltonPermutations.Load(_25736 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_25716 * 657721u) + (_25731 * 811u)) + _25746) * 1.8747241536942738093785010278225e-09f;
	                _33360 = true;
	                break;
	            }
	            case 141u:
	            {
	                uint _25658 = 53272u + (_12091 % 821u);
	                uint _25659 = _25658 / 2u;
	                uint _25669;
	                if ((_25658 & 1u) != 0u)
	                {
	                    _25669 = g_ScrambledHaltonPermutations.Load(_25659 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _25669 = g_ScrambledHaltonPermutations.Load(_25659 * 4 + 0) & 65535u;
	                }
	                uint _25673 = 53272u + ((_12091 / 821u) % 821u);
	                uint _25674 = _25673 / 2u;
	                uint _25684;
	                if ((_25673 & 1u) != 0u)
	                {
	                    _25684 = g_ScrambledHaltonPermutations.Load(_25674 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _25684 = g_ScrambledHaltonPermutations.Load(_25674 * 4 + 0) & 65535u;
	                }
	                uint _25688 = 53272u + ((_12091 / 674041u) % 821u);
	                uint _25689 = _25688 / 2u;
	                uint _25699;
	                if ((_25688 & 1u) != 0u)
	                {
	                    _25699 = g_ScrambledHaltonPermutations.Load(_25689 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _25699 = g_ScrambledHaltonPermutations.Load(_25689 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_25669 * 674041u) + (_25684 * 821u)) + _25699) * 1.8070512863843646300665568560362e-09f;
	                _33360 = true;
	                break;
	            }
	            case 142u:
	            {
	                uint _25611 = 54093u + (_12091 % 823u);
	                uint _25612 = _25611 / 2u;
	                uint _25622;
	                if ((_25611 & 1u) != 0u)
	                {
	                    _25622 = g_ScrambledHaltonPermutations.Load(_25612 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _25622 = g_ScrambledHaltonPermutations.Load(_25612 * 4 + 0) & 65535u;
	                }
	                uint _25626 = 54093u + ((_12091 / 823u) % 823u);
	                uint _25627 = _25626 / 2u;
	                uint _25637;
	                if ((_25626 & 1u) != 0u)
	                {
	                    _25637 = g_ScrambledHaltonPermutations.Load(_25627 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _25637 = g_ScrambledHaltonPermutations.Load(_25627 * 4 + 0) & 65535u;
	                }
	                uint _25641 = 54093u + ((_12091 / 677329u) % 823u);
	                uint _25642 = _25641 / 2u;
	                uint _25652;
	                if ((_25641 & 1u) != 0u)
	                {
	                    _25652 = g_ScrambledHaltonPermutations.Load(_25642 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _25652 = g_ScrambledHaltonPermutations.Load(_25642 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_25622 * 677329u) + (_25637 * 823u)) + _25652) * 1.7939090213303643395192921161652e-09f;
	                _33360 = true;
	                break;
	            }
	            case 143u:
	            {
	                uint _25564 = 54916u + (_12091 % 827u);
	                uint _25565 = _25564 / 2u;
	                uint _25575;
	                if ((_25564 & 1u) != 0u)
	                {
	                    _25575 = g_ScrambledHaltonPermutations.Load(_25565 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _25575 = g_ScrambledHaltonPermutations.Load(_25565 * 4 + 0) & 65535u;
	                }
	                uint _25579 = 54916u + ((_12091 / 827u) % 827u);
	                uint _25580 = _25579 / 2u;
	                uint _25590;
	                if ((_25579 & 1u) != 0u)
	                {
	                    _25590 = g_ScrambledHaltonPermutations.Load(_25580 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _25590 = g_ScrambledHaltonPermutations.Load(_25580 * 4 + 0) & 65535u;
	                }
	                uint _25594 = 54916u + ((_12091 / 683929u) % 827u);
	                uint _25595 = _25594 / 2u;
	                uint _25605;
	                if ((_25594 & 1u) != 0u)
	                {
	                    _25605 = g_ScrambledHaltonPermutations.Load(_25595 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _25605 = g_ScrambledHaltonPermutations.Load(_25595 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_25575 * 683929u) + (_25590 * 827u)) + _25605) * 1.7680047426082978745398577302694e-09f;
	                _33360 = true;
	                break;
	            }
	            case 144u:
	            {
	                uint _25517 = 55743u + (_12091 % 829u);
	                uint _25518 = _25517 / 2u;
	                uint _25528;
	                if ((_25517 & 1u) != 0u)
	                {
	                    _25528 = g_ScrambledHaltonPermutations.Load(_25518 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _25528 = g_ScrambledHaltonPermutations.Load(_25518 * 4 + 0) & 65535u;
	                }
	                uint _25532 = 55743u + ((_12091 / 829u) % 829u);
	                uint _25533 = _25532 / 2u;
	                uint _25543;
	                if ((_25532 & 1u) != 0u)
	                {
	                    _25543 = g_ScrambledHaltonPermutations.Load(_25533 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _25543 = g_ScrambledHaltonPermutations.Load(_25533 * 4 + 0) & 65535u;
	                }
	                uint _25547 = 55743u + ((_12091 / 687241u) % 829u);
	                uint _25548 = _25547 / 2u;
	                uint _25558;
	                if ((_25547 & 1u) != 0u)
	                {
	                    _25558 = g_ScrambledHaltonPermutations.Load(_25548 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _25558 = g_ScrambledHaltonPermutations.Load(_25548 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_25528 * 687241u) + (_25543 * 829u)) + _25558) * 1.7552392872488553621224127709866e-09f;
	                _33360 = true;
	                break;
	            }
	            case 145u:
	            {
	                uint _25470 = 56572u + (_12091 % 839u);
	                uint _25471 = _25470 / 2u;
	                uint _25481;
	                if ((_25470 & 1u) != 0u)
	                {
	                    _25481 = g_ScrambledHaltonPermutations.Load(_25471 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _25481 = g_ScrambledHaltonPermutations.Load(_25471 * 4 + 0) & 65535u;
	                }
	                uint _25485 = 56572u + ((_12091 / 839u) % 839u);
	                uint _25486 = _25485 / 2u;
	                uint _25496;
	                if ((_25485 & 1u) != 0u)
	                {
	                    _25496 = g_ScrambledHaltonPermutations.Load(_25486 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _25496 = g_ScrambledHaltonPermutations.Load(_25486 * 4 + 0) & 65535u;
	                }
	                uint _25500 = 56572u + ((_12091 / 703921u) % 839u);
	                uint _25501 = _25500 / 2u;
	                uint _25511;
	                if ((_25500 & 1u) != 0u)
	                {
	                    _25511 = g_ScrambledHaltonPermutations.Load(_25501 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _25511 = g_ScrambledHaltonPermutations.Load(_25501 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_25481 * 703921u) + (_25496 * 839u)) + _25511) * 1.6932226731825039678369648754597e-09f;
	                _33360 = true;
	                break;
	            }
	            case 146u:
	            {
	                uint _25423 = 57411u + (_12091 % 853u);
	                uint _25424 = _25423 / 2u;
	                uint _25434;
	                if ((_25423 & 1u) != 0u)
	                {
	                    _25434 = g_ScrambledHaltonPermutations.Load(_25424 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _25434 = g_ScrambledHaltonPermutations.Load(_25424 * 4 + 0) & 65535u;
	                }
	                uint _25438 = 57411u + ((_12091 / 853u) % 853u);
	                uint _25439 = _25438 / 2u;
	                uint _25449;
	                if ((_25438 & 1u) != 0u)
	                {
	                    _25449 = g_ScrambledHaltonPermutations.Load(_25439 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _25449 = g_ScrambledHaltonPermutations.Load(_25439 * 4 + 0) & 65535u;
	                }
	                uint _25453 = 57411u + ((_12091 / 727609u) % 853u);
	                uint _25454 = _25453 / 2u;
	                uint _25464;
	                if ((_25453 & 1u) != 0u)
	                {
	                    _25464 = g_ScrambledHaltonPermutations.Load(_25454 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _25464 = g_ScrambledHaltonPermutations.Load(_25454 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_25434 * 727609u) + (_25449 * 853u)) + _25464) * 1.611212607777190441993298009038e-09f;
	                _33360 = true;
	                break;
	            }
	            case 147u:
	            {
	                uint _25376 = 58264u + (_12091 % 857u);
	                uint _25377 = _25376 / 2u;
	                uint _25387;
	                if ((_25376 & 1u) != 0u)
	                {
	                    _25387 = g_ScrambledHaltonPermutations.Load(_25377 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _25387 = g_ScrambledHaltonPermutations.Load(_25377 * 4 + 0) & 65535u;
	                }
	                uint _25391 = 58264u + ((_12091 / 857u) % 857u);
	                uint _25392 = _25391 / 2u;
	                uint _25402;
	                if ((_25391 & 1u) != 0u)
	                {
	                    _25402 = g_ScrambledHaltonPermutations.Load(_25392 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _25402 = g_ScrambledHaltonPermutations.Load(_25392 * 4 + 0) & 65535u;
	                }
	                uint _25406 = 58264u + ((_12091 / 734449u) % 857u);
	                uint _25407 = _25406 / 2u;
	                uint _25417;
	                if ((_25406 & 1u) != 0u)
	                {
	                    _25417 = g_ScrambledHaltonPermutations.Load(_25407 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _25417 = g_ScrambledHaltonPermutations.Load(_25407 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_25387 * 734449u) + (_25402 * 857u)) + _25417) * 1.5887570148365171007753815501928e-09f;
	                _33360 = true;
	                break;
	            }
	            case 148u:
	            {
	                uint _25329 = 59121u + (_12091 % 859u);
	                uint _25330 = _25329 / 2u;
	                uint _25340;
	                if ((_25329 & 1u) != 0u)
	                {
	                    _25340 = g_ScrambledHaltonPermutations.Load(_25330 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _25340 = g_ScrambledHaltonPermutations.Load(_25330 * 4 + 0) & 65535u;
	                }
	                uint _25344 = 59121u + ((_12091 / 859u) % 859u);
	                uint _25345 = _25344 / 2u;
	                uint _25355;
	                if ((_25344 & 1u) != 0u)
	                {
	                    _25355 = g_ScrambledHaltonPermutations.Load(_25345 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _25355 = g_ScrambledHaltonPermutations.Load(_25345 * 4 + 0) & 65535u;
	                }
	                uint _25359 = 59121u + ((_12091 / 737881u) % 859u);
	                uint _25360 = _25359 / 2u;
	                uint _25370;
	                if ((_25359 & 1u) != 0u)
	                {
	                    _25370 = g_ScrambledHaltonPermutations.Load(_25360 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _25370 = g_ScrambledHaltonPermutations.Load(_25360 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_25340 * 737881u) + (_25355 * 859u)) + _25370) * 1.5776855377680476522073149681091e-09f;
	                _33360 = true;
	                break;
	            }
	            case 149u:
	            {
	                uint _25282 = 59980u + (_12091 % 863u);
	                uint _25283 = _25282 / 2u;
	                uint _25293;
	                if ((_25282 & 1u) != 0u)
	                {
	                    _25293 = g_ScrambledHaltonPermutations.Load(_25283 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _25293 = g_ScrambledHaltonPermutations.Load(_25283 * 4 + 0) & 65535u;
	                }
	                uint _25297 = 59980u + ((_12091 / 863u) % 863u);
	                uint _25298 = _25297 / 2u;
	                uint _25308;
	                if ((_25297 & 1u) != 0u)
	                {
	                    _25308 = g_ScrambledHaltonPermutations.Load(_25298 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _25308 = g_ScrambledHaltonPermutations.Load(_25298 * 4 + 0) & 65535u;
	                }
	                uint _25312 = 59980u + ((_12091 / 744769u) % 863u);
	                uint _25313 = _25312 / 2u;
	                uint _25323;
	                if ((_25312 & 1u) != 0u)
	                {
	                    _25323 = g_ScrambledHaltonPermutations.Load(_25313 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _25323 = g_ScrambledHaltonPermutations.Load(_25313 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_25293 * 744769u) + (_25308 * 863u)) + _25323) * 1.5558494492751151483389548957348e-09f;
	                _33360 = true;
	                break;
	            }
	            case 150u:
	            {
	                uint _25235 = 60843u + (_12091 % 877u);
	                uint _25236 = _25235 / 2u;
	                uint _25246;
	                if ((_25235 & 1u) != 0u)
	                {
	                    _25246 = g_ScrambledHaltonPermutations.Load(_25236 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _25246 = g_ScrambledHaltonPermutations.Load(_25236 * 4 + 0) & 65535u;
	                }
	                uint _25250 = 60843u + ((_12091 / 877u) % 877u);
	                uint _25251 = _25250 / 2u;
	                uint _25261;
	                if ((_25250 & 1u) != 0u)
	                {
	                    _25261 = g_ScrambledHaltonPermutations.Load(_25251 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _25261 = g_ScrambledHaltonPermutations.Load(_25251 * 4 + 0) & 65535u;
	                }
	                uint _25265 = 60843u + ((_12091 / 769129u) % 877u);
	                uint _25266 = _25265 / 2u;
	                uint _25276;
	                if ((_25265 & 1u) != 0u)
	                {
	                    _25276 = g_ScrambledHaltonPermutations.Load(_25266 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _25276 = g_ScrambledHaltonPermutations.Load(_25266 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_25246 * 769129u) + (_25261 * 877u)) + _25276) * 1.4825219940561851217353250831366e-09f;
	                _33360 = true;
	                break;
	            }
	            case 151u:
	            {
	                uint _25188 = 61720u + (_12091 % 881u);
	                uint _25189 = _25188 / 2u;
	                uint _25199;
	                if ((_25188 & 1u) != 0u)
	                {
	                    _25199 = g_ScrambledHaltonPermutations.Load(_25189 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _25199 = g_ScrambledHaltonPermutations.Load(_25189 * 4 + 0) & 65535u;
	                }
	                uint _25203 = 61720u + ((_12091 / 881u) % 881u);
	                uint _25204 = _25203 / 2u;
	                uint _25214;
	                if ((_25203 & 1u) != 0u)
	                {
	                    _25214 = g_ScrambledHaltonPermutations.Load(_25204 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _25214 = g_ScrambledHaltonPermutations.Load(_25204 * 4 + 0) & 65535u;
	                }
	                uint _25218 = 61720u + ((_12091 / 776161u) % 881u);
	                uint _25219 = _25218 / 2u;
	                uint _25229;
	                if ((_25218 & 1u) != 0u)
	                {
	                    _25229 = g_ScrambledHaltonPermutations.Load(_25219 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _25229 = g_ScrambledHaltonPermutations.Load(_25219 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_25199 * 776161u) + (_25214 * 881u)) + _25229) * 1.4624204069946244999300688505173e-09f;
	                _33360 = true;
	                break;
	            }
	            case 152u:
	            {
	                uint _25139 = 62601u + (_12091 % 883u);
	                uint _25140 = _25139 / 2u;
	                uint _25150;
	                if ((_25139 & 1u) != 0u)
	                {
	                    _25150 = g_ScrambledHaltonPermutations.Load(_25140 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _25150 = g_ScrambledHaltonPermutations.Load(_25140 * 4 + 0) & 65535u;
	                }
	                uint _25154 = 62601u + ((_12091 / 883u) % 883u);
	                uint _25155 = _25154 / 2u;
	                uint _25165;
	                if ((_25154 & 1u) != 0u)
	                {
	                    _25165 = g_ScrambledHaltonPermutations.Load(_25155 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _25165 = g_ScrambledHaltonPermutations.Load(_25155 * 4 + 0) & 65535u;
	                }
	                uint _25169 = 62601u + ((_12091 / 779689u) % 883u);
	                uint _25170 = _25169 / 2u;
	                uint _25180;
	                if ((_25169 & 1u) != 0u)
	                {
	                    _25180 = g_ScrambledHaltonPermutations.Load(_25170 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _25180 = g_ScrambledHaltonPermutations.Load(_25170 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_25150 * 779689u) + (_25165 * 883u)) + _25180) * 1.4525056712955120019614696502686e-09f;
	                _33360 = true;
	                break;
	            }
	            case 153u:
	            {
	                uint _25092 = 63484u + (_12091 % 887u);
	                uint _25093 = _25092 / 2u;
	                uint _25103;
	                if ((_25092 & 1u) != 0u)
	                {
	                    _25103 = g_ScrambledHaltonPermutations.Load(_25093 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _25103 = g_ScrambledHaltonPermutations.Load(_25093 * 4 + 0) & 65535u;
	                }
	                uint _25107 = 63484u + ((_12091 / 887u) % 887u);
	                uint _25108 = _25107 / 2u;
	                uint _25118;
	                if ((_25107 & 1u) != 0u)
	                {
	                    _25118 = g_ScrambledHaltonPermutations.Load(_25108 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _25118 = g_ScrambledHaltonPermutations.Load(_25108 * 4 + 0) & 65535u;
	                }
	                uint _25122 = 63484u + ((_12091 / 786769u) % 887u);
	                uint _25123 = _25122 / 2u;
	                uint _25133;
	                if ((_25122 & 1u) != 0u)
	                {
	                    _25133 = g_ScrambledHaltonPermutations.Load(_25123 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _25133 = g_ScrambledHaltonPermutations.Load(_25123 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_25103 * 786769u) + (_25118 * 887u)) + _25133) * 1.4329435416016167437192052602768e-09f;
	                _33360 = true;
	                break;
	            }
	            case 154u:
	            {
	                uint _25045 = 64371u + (_12091 % 907u);
	                uint _25046 = _25045 / 2u;
	                uint _25056;
	                if ((_25045 & 1u) != 0u)
	                {
	                    _25056 = g_ScrambledHaltonPermutations.Load(_25046 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _25056 = g_ScrambledHaltonPermutations.Load(_25046 * 4 + 0) & 65535u;
	                }
	                uint _25060 = 64371u + ((_12091 / 907u) % 907u);
	                uint _25061 = _25060 / 2u;
	                uint _25071;
	                if ((_25060 & 1u) != 0u)
	                {
	                    _25071 = g_ScrambledHaltonPermutations.Load(_25061 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _25071 = g_ScrambledHaltonPermutations.Load(_25061 * 4 + 0) & 65535u;
	                }
	                uint _25075 = 64371u + ((_12091 / 822649u) % 907u);
	                uint _25076 = _25075 / 2u;
	                uint _25086;
	                if ((_25075 & 1u) != 0u)
	                {
	                    _25086 = g_ScrambledHaltonPermutations.Load(_25076 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _25086 = g_ScrambledHaltonPermutations.Load(_25076 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_25056 * 822649u) + (_25071 * 907u)) + _25086) * 1.3402261522799108206527307629585e-09f;
	                _33360 = true;
	                break;
	            }
	            case 155u:
	            {
	                uint _24998 = 65278u + (_12091 % 911u);
	                uint _24999 = _24998 / 2u;
	                uint _25009;
	                if ((_24998 & 1u) != 0u)
	                {
	                    _25009 = g_ScrambledHaltonPermutations.Load(_24999 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _25009 = g_ScrambledHaltonPermutations.Load(_24999 * 4 + 0) & 65535u;
	                }
	                uint _25013 = 65278u + ((_12091 / 911u) % 911u);
	                uint _25014 = _25013 / 2u;
	                uint _25024;
	                if ((_25013 & 1u) != 0u)
	                {
	                    _25024 = g_ScrambledHaltonPermutations.Load(_25014 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _25024 = g_ScrambledHaltonPermutations.Load(_25014 * 4 + 0) & 65535u;
	                }
	                uint _25028 = 65278u + ((_12091 / 829921u) % 911u);
	                uint _25029 = _25028 / 2u;
	                uint _25039;
	                if ((_25028 & 1u) != 0u)
	                {
	                    _25039 = g_ScrambledHaltonPermutations.Load(_25029 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _25039 = g_ScrambledHaltonPermutations.Load(_25029 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_25009 * 829921u) + (_25024 * 911u)) + _25039) * 1.3226496564655576548830140382051e-09f;
	                _33360 = true;
	                break;
	            }
	            case 156u:
	            {
	                uint _24950 = 66189u + (_12091 % 919u);
	                uint _24951 = _24950 / 2u;
	                uint _24962;
	                if ((_24950 & 1u) != 0u)
	                {
	                    _24962 = g_ScrambledHaltonPermutations.Load(_24951 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _24962 = g_ScrambledHaltonPermutations.Load(_24951 * 4 + 0) & 65535u;
	                }
	                uint _24966 = 66189u + ((_12091 / 919u) % 919u);
	                uint _24967 = _24966 / 2u;
	                uint _24977;
	                if ((_24966 & 1u) != 0u)
	                {
	                    _24977 = g_ScrambledHaltonPermutations.Load(_24967 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _24977 = g_ScrambledHaltonPermutations.Load(_24967 * 4 + 0) & 65535u;
	                }
	                uint _24981 = 66189u + ((_12091 / 844561u) % 919u);
	                uint _24982 = _24981 / 2u;
	                uint _24992;
	                if ((_24981 & 1u) != 0u)
	                {
	                    _24992 = g_ScrambledHaltonPermutations.Load(_24982 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _24992 = g_ScrambledHaltonPermutations.Load(_24982 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_24962 * 844561u) + (_24977 * 919u)) + _24992) * 1.2884080469177661143476143479347e-09f;
	                _33360 = true;
	                break;
	            }
	            case 157u:
	            {
	                uint _24903 = 67108u + (_12091 % 929u);
	                uint _24904 = _24903 / 2u;
	                uint _24914;
	                if ((_24903 & 1u) != 0u)
	                {
	                    _24914 = g_ScrambledHaltonPermutations.Load(_24904 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _24914 = g_ScrambledHaltonPermutations.Load(_24904 * 4 + 0) & 65535u;
	                }
	                uint _24918 = 67108u + ((_12091 / 929u) % 929u);
	                uint _24919 = _24918 / 2u;
	                uint _24929;
	                if ((_24918 & 1u) != 0u)
	                {
	                    _24929 = g_ScrambledHaltonPermutations.Load(_24919 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _24929 = g_ScrambledHaltonPermutations.Load(_24919 * 4 + 0) & 65535u;
	                }
	                uint _24933 = 67108u + ((_12091 / 863041u) % 929u);
	                uint _24934 = _24933 / 2u;
	                uint _24944;
	                if ((_24933 & 1u) != 0u)
	                {
	                    _24944 = g_ScrambledHaltonPermutations.Load(_24934 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _24944 = g_ScrambledHaltonPermutations.Load(_24934 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_24914 * 863041u) + (_24929 * 929u)) + _24944) * 1.2472479715697204483149107545614e-09f;
	                _33360 = true;
	                break;
	            }
	            case 158u:
	            {
	                uint _24856 = 68037u + (_12091 % 937u);
	                uint _24857 = _24856 / 2u;
	                uint _24867;
	                if ((_24856 & 1u) != 0u)
	                {
	                    _24867 = g_ScrambledHaltonPermutations.Load(_24857 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _24867 = g_ScrambledHaltonPermutations.Load(_24857 * 4 + 0) & 65535u;
	                }
	                uint _24871 = 68037u + ((_12091 / 937u) % 937u);
	                uint _24872 = _24871 / 2u;
	                uint _24882;
	                if ((_24871 & 1u) != 0u)
	                {
	                    _24882 = g_ScrambledHaltonPermutations.Load(_24872 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _24882 = g_ScrambledHaltonPermutations.Load(_24872 * 4 + 0) & 65535u;
	                }
	                uint _24886 = 68037u + ((_12091 / 877969u) % 937u);
	                uint _24887 = _24886 / 2u;
	                uint _24897;
	                if ((_24886 & 1u) != 0u)
	                {
	                    _24897 = g_ScrambledHaltonPermutations.Load(_24887 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _24897 = g_ScrambledHaltonPermutations.Load(_24887 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_24867 * 877969u) + (_24882 * 937u)) + _24897) * 1.2155733086771647322166245430708e-09f;
	                _33360 = true;
	                break;
	            }
	            case 159u:
	            {
	                uint _24801 = 68974u + (_12091 % 941u);
	                uint _24802 = _24801 / 2u;
	                uint _24812;
	                if ((_24801 & 1u) != 0u)
	                {
	                    _24812 = g_ScrambledHaltonPermutations.Load(_24802 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _24812 = g_ScrambledHaltonPermutations.Load(_24802 * 4 + 0) & 65535u;
	                }
	                uint _24816 = 68974u + ((_12091 / 941u) % 941u);
	                uint _24817 = _24816 / 2u;
	                uint _24827;
	                if ((_24816 & 1u) != 0u)
	                {
	                    _24827 = g_ScrambledHaltonPermutations.Load(_24817 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _24827 = g_ScrambledHaltonPermutations.Load(_24817 * 4 + 0) & 65535u;
	                }
	                uint _24831 = 68974u + ((_12091 / 885481u) % 941u);
	                uint _24832 = _24831 / 2u;
	                uint _24850;
	                if ((_24831 & 1u) != 0u)
	                {
	                    _24850 = g_ScrambledHaltonPermutations.Load(_24832 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _24850 = g_ScrambledHaltonPermutations.Load(_24832 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_24812 * 885481u) + (_24827 * 941u)) + _24850) * 1.200137655921196255803806707263e-09f;
	                _33360 = true;
	                break;
	            }
	            case 160u:
	            {
	                uint _24759 = 69915u + (_12091 % 947u);
	                uint _24760 = _24759 / 2u;
	                uint _24768;
	                if ((_24759 & 1u) != 0u)
	                {
	                    _24768 = g_ScrambledHaltonPermutations.Load(_24760 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _24768 = g_ScrambledHaltonPermutations.Load(_24760 * 4 + 0) & 65535u;
	                }
	                uint _24772 = 69915u + ((_12091 / 947u) % 947u);
	                uint _24773 = _24772 / 2u;
	                uint _24781;
	                if ((_24772 & 1u) != 0u)
	                {
	                    _24781 = g_ScrambledHaltonPermutations.Load(_24773 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _24781 = g_ScrambledHaltonPermutations.Load(_24773 * 4 + 0) & 65535u;
	                }
	                uint _24784 = 69915u + ((_12091 / 896809u) % 947u);
	                uint _24785 = _24784 / 2u;
	                uint _24795;
	                if ((_24784 & 1u) != 0u)
	                {
	                    _24795 = g_ScrambledHaltonPermutations.Load(_24785 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _24795 = g_ScrambledHaltonPermutations.Load(_24785 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_24768 * 896809u) + (_24781 * 947u)) + _24795) * 1.1774704544720293597492855042219e-09f;
	                _33360 = true;
	                break;
	            }
	            case 161u:
	            {
	                uint _24720 = 70862u + (_12091 % 953u);
	                uint _24721 = _24720 / 2u;
	                uint _24730;
	                if ((_24720 & 1u) != 0u)
	                {
	                    _24730 = g_ScrambledHaltonPermutations.Load(_24721 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _24730 = g_ScrambledHaltonPermutations.Load(_24721 * 4 + 0) & 65535u;
	                }
	                uint _24734 = 70862u + ((_12091 / 953u) % 953u);
	                uint _24735 = _24734 / 2u;
	                uint _24743;
	                if ((_24734 & 1u) != 0u)
	                {
	                    _24743 = g_ScrambledHaltonPermutations.Load(_24735 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _24743 = g_ScrambledHaltonPermutations.Load(_24735 * 4 + 0) & 65535u;
	                }
	                uint _24746 = 70862u + ((_12091 / 908209u) % 953u);
	                uint _24747 = _24746 / 2u;
	                uint _24755;
	                if ((_24746 & 1u) != 0u)
	                {
	                    _24755 = g_ScrambledHaltonPermutations.Load(_24747 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _24755 = g_ScrambledHaltonPermutations.Load(_24747 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_24730 * 908209u) + (_24743 * 953u)) + _24755) * 1.1553703549438409936556126922369e-09f;
	                _33360 = true;
	                break;
	            }
	            case 162u:
	            {
	                uint _24682 = 71815u + (_12091 % 967u);
	                uint _24683 = _24682 / 2u;
	                uint _24691;
	                if ((_24682 & 1u) != 0u)
	                {
	                    _24691 = g_ScrambledHaltonPermutations.Load(_24683 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _24691 = g_ScrambledHaltonPermutations.Load(_24683 * 4 + 0) & 65535u;
	                }
	                uint _24695 = 71815u + ((_12091 / 967u) % 967u);
	                uint _24696 = _24695 / 2u;
	                uint _24704;
	                if ((_24695 & 1u) != 0u)
	                {
	                    _24704 = g_ScrambledHaltonPermutations.Load(_24696 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _24704 = g_ScrambledHaltonPermutations.Load(_24696 * 4 + 0) & 65535u;
	                }
	                uint _24707 = 71815u + ((_12091 / 935089u) % 967u);
	                uint _24708 = _24707 / 2u;
	                uint _24716;
	                if ((_24707 & 1u) != 0u)
	                {
	                    _24716 = g_ScrambledHaltonPermutations.Load(_24708 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _24716 = g_ScrambledHaltonPermutations.Load(_24708 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_24691 * 935089u) + (_24704 * 967u)) + _24716) * 1.1059119175982345950615126639605e-09f;
	                _33360 = true;
	                break;
	            }
	            case 163u:
	            {
	                uint _24644 = 72782u + (_12091 % 971u);
	                uint _24645 = _24644 / 2u;
	                uint _24653;
	                if ((_24644 & 1u) != 0u)
	                {
	                    _24653 = g_ScrambledHaltonPermutations.Load(_24645 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _24653 = g_ScrambledHaltonPermutations.Load(_24645 * 4 + 0) & 65535u;
	                }
	                uint _24657 = 72782u + ((_12091 / 971u) % 971u);
	                uint _24658 = _24657 / 2u;
	                uint _24666;
	                if ((_24657 & 1u) != 0u)
	                {
	                    _24666 = g_ScrambledHaltonPermutations.Load(_24658 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _24666 = g_ScrambledHaltonPermutations.Load(_24658 * 4 + 0) & 65535u;
	                }
	                uint _24669 = 72782u + ((_12091 / 942841u) % 971u);
	                uint _24670 = _24669 / 2u;
	                uint _24678;
	                if ((_24669 & 1u) != 0u)
	                {
	                    _24678 = g_ScrambledHaltonPermutations.Load(_24670 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _24678 = g_ScrambledHaltonPermutations.Load(_24670 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_24653 * 942841u) + (_24666 * 971u)) + _24678) * 1.092300805360935100907227024436e-09f;
	                _33360 = true;
	                break;
	            }
	            case 164u:
	            {
	                uint _24606 = 73753u + (_12091 % 977u);
	                uint _24607 = _24606 / 2u;
	                uint _24615;
	                if ((_24606 & 1u) != 0u)
	                {
	                    _24615 = g_ScrambledHaltonPermutations.Load(_24607 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _24615 = g_ScrambledHaltonPermutations.Load(_24607 * 4 + 0) & 65535u;
	                }
	                uint _24619 = 73753u + ((_12091 / 977u) % 977u);
	                uint _24620 = _24619 / 2u;
	                uint _24628;
	                if ((_24619 & 1u) != 0u)
	                {
	                    _24628 = g_ScrambledHaltonPermutations.Load(_24620 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _24628 = g_ScrambledHaltonPermutations.Load(_24620 * 4 + 0) & 65535u;
	                }
	                uint _24631 = 73753u + ((_12091 / 954529u) % 977u);
	                uint _24632 = _24631 / 2u;
	                uint _24640;
	                if ((_24631 & 1u) != 0u)
	                {
	                    _24640 = g_ScrambledHaltonPermutations.Load(_24632 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _24640 = g_ScrambledHaltonPermutations.Load(_24632 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_24615 * 954529u) + (_24628 * 977u)) + _24640) * 1.072299915527707980800187215209e-09f;
	                _33360 = true;
	                break;
	            }
	            case 165u:
	            {
	                uint _24568 = 74730u + (_12091 % 983u);
	                uint _24569 = _24568 / 2u;
	                uint _24577;
	                if ((_24568 & 1u) != 0u)
	                {
	                    _24577 = g_ScrambledHaltonPermutations.Load(_24569 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _24577 = g_ScrambledHaltonPermutations.Load(_24569 * 4 + 0) & 65535u;
	                }
	                uint _24581 = 74730u + ((_12091 / 983u) % 983u);
	                uint _24582 = _24581 / 2u;
	                uint _24590;
	                if ((_24581 & 1u) != 0u)
	                {
	                    _24590 = g_ScrambledHaltonPermutations.Load(_24582 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _24590 = g_ScrambledHaltonPermutations.Load(_24582 * 4 + 0) & 65535u;
	                }
	                uint _24593 = 74730u + ((_12091 / 966289u) % 983u);
	                uint _24594 = _24593 / 2u;
	                uint _24602;
	                if ((_24593 & 1u) != 0u)
	                {
	                    _24602 = g_ScrambledHaltonPermutations.Load(_24594 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _24602 = g_ScrambledHaltonPermutations.Load(_24594 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_24577 * 966289u) + (_24590 * 983u)) + _24602) * 1.0527843041785445166169665753841e-09f;
	                _33360 = true;
	                break;
	            }
	            case 166u:
	            {
	                uint _24530 = 75713u + (_12091 % 991u);
	                uint _24531 = _24530 / 2u;
	                uint _24539;
	                if ((_24530 & 1u) != 0u)
	                {
	                    _24539 = g_ScrambledHaltonPermutations.Load(_24531 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _24539 = g_ScrambledHaltonPermutations.Load(_24531 * 4 + 0) & 65535u;
	                }
	                uint _24543 = 75713u + ((_12091 / 991u) % 991u);
	                uint _24544 = _24543 / 2u;
	                uint _24552;
	                if ((_24543 & 1u) != 0u)
	                {
	                    _24552 = g_ScrambledHaltonPermutations.Load(_24544 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _24552 = g_ScrambledHaltonPermutations.Load(_24544 * 4 + 0) & 65535u;
	                }
	                uint _24555 = 75713u + ((_12091 / 982081u) % 991u);
	                uint _24556 = _24555 / 2u;
	                uint _24564;
	                if ((_24555 & 1u) != 0u)
	                {
	                    _24564 = g_ScrambledHaltonPermutations.Load(_24556 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _24564 = g_ScrambledHaltonPermutations.Load(_24556 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_24539 * 982081u) + (_24552 * 991u)) + _24564) * 1.0274933126552809881104622036219e-09f;
	                _33360 = true;
	                break;
	            }
	            case 167u:
	            {
	                uint _24492 = 76704u + (_12091 % 997u);
	                uint _24493 = _24492 / 2u;
	                uint _24501;
	                if ((_24492 & 1u) != 0u)
	                {
	                    _24501 = g_ScrambledHaltonPermutations.Load(_24493 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _24501 = g_ScrambledHaltonPermutations.Load(_24493 * 4 + 0) & 65535u;
	                }
	                uint _24505 = 76704u + ((_12091 / 997u) % 997u);
	                uint _24506 = _24505 / 2u;
	                uint _24514;
	                if ((_24505 & 1u) != 0u)
	                {
	                    _24514 = g_ScrambledHaltonPermutations.Load(_24506 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _24514 = g_ScrambledHaltonPermutations.Load(_24506 * 4 + 0) & 65535u;
	                }
	                uint _24517 = 76704u + ((_12091 / 994009u) % 997u);
	                uint _24518 = _24517 / 2u;
	                uint _24526;
	                if ((_24517 & 1u) != 0u)
	                {
	                    _24526 = g_ScrambledHaltonPermutations.Load(_24518 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _24526 = g_ScrambledHaltonPermutations.Load(_24518 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_24501 * 994009u) + (_24514 * 997u)) + _24526) * 1.0090541735507940757088363170624e-09f;
	                _33360 = true;
	                break;
	            }
	            case 168u:
	            {
	                uint _24453 = 77701u + (_12091 % 1009u);
	                uint _24454 = _24453 / 2u;
	                uint _24462;
	                if ((_24453 & 1u) != 0u)
	                {
	                    _24462 = g_ScrambledHaltonPermutations.Load(_24454 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _24462 = g_ScrambledHaltonPermutations.Load(_24454 * 4 + 0) & 65535u;
	                }
	                uint _24466 = 77701u + ((_12091 / 1009u) % 1009u);
	                uint _24467 = _24466 / 2u;
	                uint _24475;
	                if ((_24466 & 1u) != 0u)
	                {
	                    _24475 = g_ScrambledHaltonPermutations.Load(_24467 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _24475 = g_ScrambledHaltonPermutations.Load(_24467 * 4 + 0) & 65535u;
	                }
	                uint _24479 = 77701u + ((_12091 / 1018081u) % 1009u);
	                uint _24480 = _24479 / 2u;
	                uint _24488;
	                if ((_24479 & 1u) != 0u)
	                {
	                    _24488 = g_ScrambledHaltonPermutations.Load(_24480 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _24488 = g_ScrambledHaltonPermutations.Load(_24480 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_24462 * 1018081u) + (_24475 * 1009u)) + _24488) * 9.7347874206121787210577167570591e-10f;
	                _33360 = true;
	                break;
	            }
	            case 169u:
	            {
	                uint _24414 = 78710u + (_12091 % 1013u);
	                uint _24415 = _24414 / 2u;
	                uint _24423;
	                if ((_24414 & 1u) != 0u)
	                {
	                    _24423 = g_ScrambledHaltonPermutations.Load(_24415 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _24423 = g_ScrambledHaltonPermutations.Load(_24415 * 4 + 0) & 65535u;
	                }
	                uint _24427 = 78710u + ((_12091 / 1013u) % 1013u);
	                uint _24428 = _24427 / 2u;
	                uint _24436;
	                if ((_24427 & 1u) != 0u)
	                {
	                    _24436 = g_ScrambledHaltonPermutations.Load(_24428 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _24436 = g_ScrambledHaltonPermutations.Load(_24428 * 4 + 0) & 65535u;
	                }
	                uint _24439 = 78710u + ((_12091 / 1026169u) % 1013u);
	                uint _24440 = _24439 / 2u;
	                uint _24449;
	                if ((_24439 & 1u) != 0u)
	                {
	                    _24449 = g_ScrambledHaltonPermutations.Load(_24440 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _24449 = g_ScrambledHaltonPermutations.Load(_24440 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_24423 * 1026169u) + (_24436 * 1013u)) + _24449) * 9.6199237464844600253854878246784e-10f;
	                _33360 = true;
	                break;
	            }
	            case 170u:
	            {
	                uint _24376 = 79723u + (_12091 % 1019u);
	                uint _24377 = _24376 / 2u;
	                uint _24385;
	                if ((_24376 & 1u) != 0u)
	                {
	                    _24385 = g_ScrambledHaltonPermutations.Load(_24377 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _24385 = g_ScrambledHaltonPermutations.Load(_24377 * 4 + 0) & 65535u;
	                }
	                uint _24389 = 79723u + ((_12091 / 1019u) % 1019u);
	                uint _24390 = _24389 / 2u;
	                uint _24398;
	                if ((_24389 & 1u) != 0u)
	                {
	                    _24398 = g_ScrambledHaltonPermutations.Load(_24390 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _24398 = g_ScrambledHaltonPermutations.Load(_24390 * 4 + 0) & 65535u;
	                }
	                uint _24401 = 79723u + ((_12091 / 1038361u) % 1019u);
	                uint _24402 = _24401 / 2u;
	                uint _24410;
	                if ((_24401 & 1u) != 0u)
	                {
	                    _24410 = g_ScrambledHaltonPermutations.Load(_24402 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _24410 = g_ScrambledHaltonPermutations.Load(_24402 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_24385 * 1038361u) + (_24398 * 1019u)) + _24410) * 9.4509922110574962061946280300617e-10f;
	                _33360 = true;
	                break;
	            }
	            case 171u:
	            {
	                uint _24337 = 80742u + (_12091 % 1021u);
	                uint _24338 = _24337 / 2u;
	                uint _24346;
	                if ((_24337 & 1u) != 0u)
	                {
	                    _24346 = g_ScrambledHaltonPermutations.Load(_24338 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _24346 = g_ScrambledHaltonPermutations.Load(_24338 * 4 + 0) & 65535u;
	                }
	                uint _24350 = 80742u + ((_12091 / 1021u) % 1021u);
	                uint _24351 = _24350 / 2u;
	                uint _24359;
	                if ((_24350 & 1u) != 0u)
	                {
	                    _24359 = g_ScrambledHaltonPermutations.Load(_24351 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _24359 = g_ScrambledHaltonPermutations.Load(_24351 * 4 + 0) & 65535u;
	                }
	                uint _24362 = 80742u + ((_12091 / 1042441u) % 1021u);
	                uint _24363 = _24362 / 2u;
	                uint _24372;
	                if ((_24362 & 1u) != 0u)
	                {
	                    _24372 = g_ScrambledHaltonPermutations.Load(_24363 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _24372 = g_ScrambledHaltonPermutations.Load(_24363 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_24346 * 1042441u) + (_24359 * 1021u)) + _24372) * 9.3955609958840113904443569481373e-10f;
	                _33360 = true;
	                break;
	            }
	            case 172u:
	            {
	                uint _24299 = 81763u + (_12091 % 1031u);
	                uint _24300 = _24299 / 2u;
	                uint _24308;
	                if ((_24299 & 1u) != 0u)
	                {
	                    _24308 = g_ScrambledHaltonPermutations.Load(_24300 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _24308 = g_ScrambledHaltonPermutations.Load(_24300 * 4 + 0) & 65535u;
	                }
	                uint _24312 = 81763u + ((_12091 / 1031u) % 1031u);
	                uint _24313 = _24312 / 2u;
	                uint _24321;
	                if ((_24312 & 1u) != 0u)
	                {
	                    _24321 = g_ScrambledHaltonPermutations.Load(_24313 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _24321 = g_ScrambledHaltonPermutations.Load(_24313 * 4 + 0) & 65535u;
	                }
	                uint _24324 = 81763u + ((_12091 / 1062961u) % 1031u);
	                uint _24325 = _24324 / 2u;
	                uint _24333;
	                if ((_24324 & 1u) != 0u)
	                {
	                    _24333 = g_ScrambledHaltonPermutations.Load(_24325 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _24333 = g_ScrambledHaltonPermutations.Load(_24325 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_24308 * 1062961u) + (_24321 * 1031u)) + _24333) * 9.1248120170916990900877863168716e-10f;
	                _33360 = true;
	                break;
	            }
	            case 173u:
	            {
	                uint _24261 = 82794u + (_12091 % 1033u);
	                uint _24262 = _24261 / 2u;
	                uint _24270;
	                if ((_24261 & 1u) != 0u)
	                {
	                    _24270 = g_ScrambledHaltonPermutations.Load(_24262 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _24270 = g_ScrambledHaltonPermutations.Load(_24262 * 4 + 0) & 65535u;
	                }
	                uint _24274 = 82794u + ((_12091 / 1033u) % 1033u);
	                uint _24275 = _24274 / 2u;
	                uint _24283;
	                if ((_24274 & 1u) != 0u)
	                {
	                    _24283 = g_ScrambledHaltonPermutations.Load(_24275 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _24283 = g_ScrambledHaltonPermutations.Load(_24275 * 4 + 0) & 65535u;
	                }
	                uint _24286 = 82794u + ((_12091 / 1067089u) % 1033u);
	                uint _24287 = _24286 / 2u;
	                uint _24295;
	                if ((_24286 & 1u) != 0u)
	                {
	                    _24295 = g_ScrambledHaltonPermutations.Load(_24287 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _24295 = g_ScrambledHaltonPermutations.Load(_24287 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_24270 * 1067089u) + (_24283 * 1033u)) + _24295) * 9.0719148859719211941410321742296e-10f;
	                _33360 = true;
	                break;
	            }
	            case 174u:
	            {
	                uint _24223 = 83827u + (_12091 % 1039u);
	                uint _24224 = _24223 / 2u;
	                uint _24232;
	                if ((_24223 & 1u) != 0u)
	                {
	                    _24232 = g_ScrambledHaltonPermutations.Load(_24224 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _24232 = g_ScrambledHaltonPermutations.Load(_24224 * 4 + 0) & 65535u;
	                }
	                uint _24236 = 83827u + ((_12091 / 1039u) % 1039u);
	                uint _24237 = _24236 / 2u;
	                uint _24245;
	                if ((_24236 & 1u) != 0u)
	                {
	                    _24245 = g_ScrambledHaltonPermutations.Load(_24237 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _24245 = g_ScrambledHaltonPermutations.Load(_24237 * 4 + 0) & 65535u;
	                }
	                uint _24248 = 83827u + ((_12091 / 1079521u) % 1039u);
	                uint _24249 = _24248 / 2u;
	                uint _24257;
	                if ((_24248 & 1u) != 0u)
	                {
	                    _24257 = g_ScrambledHaltonPermutations.Load(_24249 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _24257 = g_ScrambledHaltonPermutations.Load(_24249 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_24232 * 1079521u) + (_24245 * 1039u)) + _24257) * 8.9156565463710535368591081351042e-10f;
	                _33360 = true;
	                break;
	            }
	            case 175u:
	            {
	                uint _24185 = 84866u + (_12091 % 1049u);
	                uint _24186 = _24185 / 2u;
	                uint _24194;
	                if ((_24185 & 1u) != 0u)
	                {
	                    _24194 = g_ScrambledHaltonPermutations.Load(_24186 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _24194 = g_ScrambledHaltonPermutations.Load(_24186 * 4 + 0) & 65535u;
	                }
	                uint _24198 = 84866u + ((_12091 / 1049u) % 1049u);
	                uint _24199 = _24198 / 2u;
	                uint _24207;
	                if ((_24198 & 1u) != 0u)
	                {
	                    _24207 = g_ScrambledHaltonPermutations.Load(_24199 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _24207 = g_ScrambledHaltonPermutations.Load(_24199 * 4 + 0) & 65535u;
	                }
	                uint _24210 = 84866u + ((_12091 / 1100401u) % 1049u);
	                uint _24211 = _24210 / 2u;
	                uint _24219;
	                if ((_24210 & 1u) != 0u)
	                {
	                    _24219 = g_ScrambledHaltonPermutations.Load(_24211 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _24219 = g_ScrambledHaltonPermutations.Load(_24211 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_24194 * 1100401u) + (_24207 * 1049u)) + _24219) * 8.6631030127293229270435404032469e-10f;
	                _33360 = true;
	                break;
	            }
	            case 176u:
	            {
	                uint _24147 = 85915u + (_12091 % 1051u);
	                uint _24148 = _24147 / 2u;
	                uint _24156;
	                if ((_24147 & 1u) != 0u)
	                {
	                    _24156 = g_ScrambledHaltonPermutations.Load(_24148 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _24156 = g_ScrambledHaltonPermutations.Load(_24148 * 4 + 0) & 65535u;
	                }
	                uint _24160 = 85915u + ((_12091 / 1051u) % 1051u);
	                uint _24161 = _24160 / 2u;
	                uint _24169;
	                if ((_24160 & 1u) != 0u)
	                {
	                    _24169 = g_ScrambledHaltonPermutations.Load(_24161 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _24169 = g_ScrambledHaltonPermutations.Load(_24161 * 4 + 0) & 65535u;
	                }
	                uint _24172 = 85915u + ((_12091 / 1104601u) % 1051u);
	                uint _24173 = _24172 / 2u;
	                uint _24181;
	                if ((_24172 & 1u) != 0u)
	                {
	                    _24181 = g_ScrambledHaltonPermutations.Load(_24173 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _24181 = g_ScrambledHaltonPermutations.Load(_24173 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_24156 * 1104601u) + (_24169 * 1051u)) + _24181) * 8.6137408317199515295214951038361e-10f;
	                _33360 = true;
	                break;
	            }
	            case 177u:
	            {
	                uint _24109 = 86966u + (_12091 % 1061u);
	                uint _24110 = _24109 / 2u;
	                uint _24118;
	                if ((_24109 & 1u) != 0u)
	                {
	                    _24118 = g_ScrambledHaltonPermutations.Load(_24110 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _24118 = g_ScrambledHaltonPermutations.Load(_24110 * 4 + 0) & 65535u;
	                }
	                uint _24122 = 86966u + ((_12091 / 1061u) % 1061u);
	                uint _24123 = _24122 / 2u;
	                uint _24131;
	                if ((_24122 & 1u) != 0u)
	                {
	                    _24131 = g_ScrambledHaltonPermutations.Load(_24123 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _24131 = g_ScrambledHaltonPermutations.Load(_24123 * 4 + 0) & 65535u;
	                }
	                uint _24134 = 86966u + ((_12091 / 1125721u) % 1061u);
	                uint _24135 = _24134 / 2u;
	                uint _24143;
	                if ((_24134 & 1u) != 0u)
	                {
	                    _24143 = g_ScrambledHaltonPermutations.Load(_24135 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _24143 = g_ScrambledHaltonPermutations.Load(_24135 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_24118 * 1125721u) + (_24131 * 1061u)) + _24143) * 8.3724732702350479485176037997007e-10f;
	                _33360 = true;
	                break;
	            }
	            case 178u:
	            {
	                uint _24071 = 88027u + (_12091 % 1063u);
	                uint _24072 = _24071 / 2u;
	                uint _24080;
	                if ((_24071 & 1u) != 0u)
	                {
	                    _24080 = g_ScrambledHaltonPermutations.Load(_24072 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _24080 = g_ScrambledHaltonPermutations.Load(_24072 * 4 + 0) & 65535u;
	                }
	                uint _24084 = 88027u + ((_12091 / 1063u) % 1063u);
	                uint _24085 = _24084 / 2u;
	                uint _24093;
	                if ((_24084 & 1u) != 0u)
	                {
	                    _24093 = g_ScrambledHaltonPermutations.Load(_24085 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _24093 = g_ScrambledHaltonPermutations.Load(_24085 * 4 + 0) & 65535u;
	                }
	                uint _24096 = 88027u + ((_12091 / 1129969u) % 1063u);
	                uint _24097 = _24096 / 2u;
	                uint _24105;
	                if ((_24096 & 1u) != 0u)
	                {
	                    _24105 = g_ScrambledHaltonPermutations.Load(_24097 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _24105 = g_ScrambledHaltonPermutations.Load(_24097 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_24080 * 1129969u) + (_24093 * 1063u)) + _24105) * 8.3253054450338481728977058082819e-10f;
	                _33360 = true;
	                break;
	            }
	            case 179u:
	            {
	                uint _24033 = 89090u + (_12091 % 1069u);
	                uint _24034 = _24033 / 2u;
	                uint _24042;
	                if ((_24033 & 1u) != 0u)
	                {
	                    _24042 = g_ScrambledHaltonPermutations.Load(_24034 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _24042 = g_ScrambledHaltonPermutations.Load(_24034 * 4 + 0) & 65535u;
	                }
	                uint _24046 = 89090u + ((_12091 / 1069u) % 1069u);
	                uint _24047 = _24046 / 2u;
	                uint _24055;
	                if ((_24046 & 1u) != 0u)
	                {
	                    _24055 = g_ScrambledHaltonPermutations.Load(_24047 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _24055 = g_ScrambledHaltonPermutations.Load(_24047 * 4 + 0) & 65535u;
	                }
	                uint _24058 = 89090u + ((_12091 / 1142761u) % 1069u);
	                uint _24059 = _24058 / 2u;
	                uint _24067;
	                if ((_24058 & 1u) != 0u)
	                {
	                    _24067 = g_ScrambledHaltonPermutations.Load(_24059 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _24067 = g_ScrambledHaltonPermutations.Load(_24059 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_24042 * 1142761u) + (_24055 * 1069u)) + _24067) * 8.1859075073964504554169252514839e-10f;
	                _33360 = true;
	                break;
	            }
	            case 180u:
	            {
	                uint _23991 = 90159u + (_12091 % 1087u);
	                uint _23992 = _23991 / 2u;
	                uint _24000;
	                if ((_23991 & 1u) != 0u)
	                {
	                    _24000 = g_ScrambledHaltonPermutations.Load(_23992 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _24000 = g_ScrambledHaltonPermutations.Load(_23992 * 4 + 0) & 65535u;
	                }
	                uint _24004 = 90159u + ((_12091 / 1087u) % 1087u);
	                uint _24005 = _24004 / 2u;
	                uint _24017;
	                if ((_24004 & 1u) != 0u)
	                {
	                    _24017 = g_ScrambledHaltonPermutations.Load(_24005 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _24017 = g_ScrambledHaltonPermutations.Load(_24005 * 4 + 0) & 65535u;
	                }
	                uint _24020 = 90159u + ((_12091 / 1181569u) % 1087u);
	                uint _24021 = _24020 / 2u;
	                uint _24029;
	                if ((_24020 & 1u) != 0u)
	                {
	                    _24029 = g_ScrambledHaltonPermutations.Load(_24021 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _24029 = g_ScrambledHaltonPermutations.Load(_24021 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_24000 * 1181569u) + (_24017 * 1087u)) + _24029) * 7.7859452218831393111031502485275e-10f;
	                _33360 = true;
	                break;
	            }
	            case 181u:
	            {
	                uint _23952 = 91246u + (_12091 % 1091u);
	                uint _23954 = _23952 / 2u;
	                uint _23962;
	                if ((_23952 & 1u) != 0u)
	                {
	                    _23962 = g_ScrambledHaltonPermutations.Load(_23954 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _23962 = g_ScrambledHaltonPermutations.Load(_23954 * 4 + 0) & 65535u;
	                }
	                uint _23966 = 91246u + ((_12091 / 1091u) % 1091u);
	                uint _23967 = _23966 / 2u;
	                uint _23975;
	                if ((_23966 & 1u) != 0u)
	                {
	                    _23975 = g_ScrambledHaltonPermutations.Load(_23967 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _23975 = g_ScrambledHaltonPermutations.Load(_23967 * 4 + 0) & 65535u;
	                }
	                uint _23978 = 91246u + ((_12091 / 1190281u) % 1091u);
	                uint _23979 = _23978 / 2u;
	                uint _23987;
	                if ((_23978 & 1u) != 0u)
	                {
	                    _23987 = g_ScrambledHaltonPermutations.Load(_23979 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _23987 = g_ScrambledHaltonPermutations.Load(_23979 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_23962 * 1190281u) + (_23975 * 1091u)) + _23987) * 7.7006195864370852177671622484922e-10f;
	                _33360 = true;
	                break;
	            }
	            case 182u:
	            {
	                uint _23914 = 92337u + (_12091 % 1093u);
	                uint _23915 = _23914 / 2u;
	                uint _23923;
	                if ((_23914 & 1u) != 0u)
	                {
	                    _23923 = g_ScrambledHaltonPermutations.Load(_23915 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _23923 = g_ScrambledHaltonPermutations.Load(_23915 * 4 + 0) & 65535u;
	                }
	                uint _23927 = 92337u + ((_12091 / 1093u) % 1093u);
	                uint _23928 = _23927 / 2u;
	                uint _23936;
	                if ((_23927 & 1u) != 0u)
	                {
	                    _23936 = g_ScrambledHaltonPermutations.Load(_23928 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _23936 = g_ScrambledHaltonPermutations.Load(_23928 * 4 + 0) & 65535u;
	                }
	                uint _23939 = 92337u + ((_12091 / 1194649u) % 1093u);
	                uint _23940 = _23939 / 2u;
	                uint _23948;
	                if ((_23939 & 1u) != 0u)
	                {
	                    _23948 = g_ScrambledHaltonPermutations.Load(_23940 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _23948 = g_ScrambledHaltonPermutations.Load(_23940 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_23923 * 1194649u) + (_23936 * 1093u)) + _23948) * 7.6584255603862061434483621269464e-10f;
	                _33360 = true;
	                break;
	            }
	            case 183u:
	            {
	                uint _23875 = 93430u + (_12091 % 1097u);
	                uint _23876 = _23875 / 2u;
	                uint _23885;
	                if ((_23875 & 1u) != 0u)
	                {
	                    _23885 = g_ScrambledHaltonPermutations.Load(_23876 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _23885 = g_ScrambledHaltonPermutations.Load(_23876 * 4 + 0) & 65535u;
	                }
	                uint _23889 = 93430u + ((_12091 / 1097u) % 1097u);
	                uint _23890 = _23889 / 2u;
	                uint _23898;
	                if ((_23889 & 1u) != 0u)
	                {
	                    _23898 = g_ScrambledHaltonPermutations.Load(_23890 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _23898 = g_ScrambledHaltonPermutations.Load(_23890 * 4 + 0) & 65535u;
	                }
	                uint _23901 = 93430u + ((_12091 / 1203409u) % 1097u);
	                uint _23902 = _23901 / 2u;
	                uint _23910;
	                if ((_23901 & 1u) != 0u)
	                {
	                    _23910 = g_ScrambledHaltonPermutations.Load(_23902 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _23910 = g_ScrambledHaltonPermutations.Load(_23902 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_23885 * 1203409u) + (_23898 * 1097u)) + _23910) * 7.5749551076143006866914220154285e-10f;
	                _33360 = true;
	                break;
	            }
	            case 184u:
	            {
	                uint _23440 = 94527u + (_12091 % 1103u);
	                uint _23441 = _23440 / 2u;
	                uint _23449;
	                if ((_23440 & 1u) != 0u)
	                {
	                    _23449 = g_ScrambledHaltonPermutations.Load(_23441 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _23449 = g_ScrambledHaltonPermutations.Load(_23441 * 4 + 0) & 65535u;
	                }
	                uint _23453 = 94527u + ((_12091 / 1103u) % 1103u);
	                uint _23454 = _23453 / 2u;
	                uint _23462;
	                if ((_23453 & 1u) != 0u)
	                {
	                    _23462 = g_ScrambledHaltonPermutations.Load(_23454 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _23462 = g_ScrambledHaltonPermutations.Load(_23454 * 4 + 0) & 65535u;
	                }
	                uint _23464 = 94527u + ((_12091 / 1216609u) % 1103u);
	                uint _23465 = _23464 / 2u;
	                uint _23871;
	                if ((_23464 & 1u) != 0u)
	                {
	                    _23871 = g_ScrambledHaltonPermutations.Load(_23465 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _23871 = g_ScrambledHaltonPermutations.Load(_23465 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_23449 * 1216609u) + (_23462 * 1103u)) + _23871) * 7.45200956497882316398317925632e-10f;
	                _33360 = true;
	                break;
	            }
	            case 185u:
	            {
	                uint _23403 = 95630u + (_12091 % 1109u);
	                uint _23404 = _23403 / 2u;
	                uint _23412;
	                if ((_23403 & 1u) != 0u)
	                {
	                    _23412 = g_ScrambledHaltonPermutations.Load(_23404 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _23412 = g_ScrambledHaltonPermutations.Load(_23404 * 4 + 0) & 65535u;
	                }
	                uint _23416 = 95630u + ((_12091 / 1109u) % 1109u);
	                uint _23417 = _23416 / 2u;
	                uint _23425;
	                if ((_23416 & 1u) != 0u)
	                {
	                    _23425 = g_ScrambledHaltonPermutations.Load(_23417 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _23425 = g_ScrambledHaltonPermutations.Load(_23417 * 4 + 0) & 65535u;
	                }
	                uint _23427 = 95630u + ((_12091 / 1229881u) % 1109u);
	                uint _23428 = _23427 / 2u;
	                uint _23436;
	                if ((_23427 & 1u) != 0u)
	                {
	                    _23436 = g_ScrambledHaltonPermutations.Load(_23428 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _23436 = g_ScrambledHaltonPermutations.Load(_23428 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_23412 * 1229881u) + (_23425 * 1109u)) + _23436) * 7.3317102389225397018890362232924e-10f;
	                _33360 = true;
	                break;
	            }
	            case 186u:
	            {
	                uint _23366 = 96739u + (_12091 % 1117u);
	                uint _23367 = _23366 / 2u;
	                uint _23375;
	                if ((_23366 & 1u) != 0u)
	                {
	                    _23375 = g_ScrambledHaltonPermutations.Load(_23367 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _23375 = g_ScrambledHaltonPermutations.Load(_23367 * 4 + 0) & 65535u;
	                }
	                uint _23379 = 96739u + ((_12091 / 1117u) % 1117u);
	                uint _23380 = _23379 / 2u;
	                uint _23388;
	                if ((_23379 & 1u) != 0u)
	                {
	                    _23388 = g_ScrambledHaltonPermutations.Load(_23380 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _23388 = g_ScrambledHaltonPermutations.Load(_23380 * 4 + 0) & 65535u;
	                }
	                uint _23390 = 96739u + ((_12091 / 1247689u) % 1117u);
	                uint _23391 = _23390 / 2u;
	                uint _23399;
	                if ((_23390 & 1u) != 0u)
	                {
	                    _23399 = g_ScrambledHaltonPermutations.Load(_23391 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _23399 = g_ScrambledHaltonPermutations.Load(_23391 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_23375 * 1247689u) + (_23388 * 1117u)) + _23399) * 7.1753059049939338365220464766026e-10f;
	                _33360 = true;
	                break;
	            }
	            case 187u:
	            {
	                uint _23329 = 97856u + (_12091 % 1123u);
	                uint _23330 = _23329 / 2u;
	                uint _23338;
	                if ((_23329 & 1u) != 0u)
	                {
	                    _23338 = g_ScrambledHaltonPermutations.Load(_23330 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _23338 = g_ScrambledHaltonPermutations.Load(_23330 * 4 + 0) & 65535u;
	                }
	                uint _23342 = 97856u + ((_12091 / 1123u) % 1123u);
	                uint _23343 = _23342 / 2u;
	                uint _23351;
	                if ((_23342 & 1u) != 0u)
	                {
	                    _23351 = g_ScrambledHaltonPermutations.Load(_23343 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _23351 = g_ScrambledHaltonPermutations.Load(_23343 * 4 + 0) & 65535u;
	                }
	                uint _23353 = 97856u + ((_12091 / 1261129u) % 1123u);
	                uint _23354 = _23353 / 2u;
	                uint _23362;
	                if ((_23353 & 1u) != 0u)
	                {
	                    _23362 = g_ScrambledHaltonPermutations.Load(_23354 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _23362 = g_ScrambledHaltonPermutations.Load(_23354 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_23338 * 1261129u) + (_23351 * 1123u)) + _23362) * 7.06091018987109464433160610497e-10f;
	                _33360 = true;
	                break;
	            }
	            case 188u:
	            {
	                uint _23292 = 98979u + (_12091 % 1129u);
	                uint _23293 = _23292 / 2u;
	                uint _23301;
	                if ((_23292 & 1u) != 0u)
	                {
	                    _23301 = g_ScrambledHaltonPermutations.Load(_23293 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _23301 = g_ScrambledHaltonPermutations.Load(_23293 * 4 + 0) & 65535u;
	                }
	                uint _23305 = 98979u + ((_12091 / 1129u) % 1129u);
	                uint _23306 = _23305 / 2u;
	                uint _23314;
	                if ((_23305 & 1u) != 0u)
	                {
	                    _23314 = g_ScrambledHaltonPermutations.Load(_23306 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _23314 = g_ScrambledHaltonPermutations.Load(_23306 * 4 + 0) & 65535u;
	                }
	                uint _23316 = 98979u + ((_12091 / 1274641u) % 1129u);
	                uint _23317 = _23316 / 2u;
	                uint _23325;
	                if ((_23316 & 1u) != 0u)
	                {
	                    _23325 = g_ScrambledHaltonPermutations.Load(_23317 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _23325 = g_ScrambledHaltonPermutations.Load(_23317 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_23301 * 1274641u) + (_23314 * 1129u)) + _23325) * 6.9489330956074013556644786149263e-10f;
	                _33360 = true;
	                break;
	            }
	            case 189u:
	            {
	                uint _23255 = 100108u + (_12091 % 1151u);
	                uint _23256 = _23255 / 2u;
	                uint _23264;
	                if ((_23255 & 1u) != 0u)
	                {
	                    _23264 = g_ScrambledHaltonPermutations.Load(_23256 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _23264 = g_ScrambledHaltonPermutations.Load(_23256 * 4 + 0) & 65535u;
	                }
	                uint _23268 = 100108u + ((_12091 / 1151u) % 1151u);
	                uint _23269 = _23268 / 2u;
	                uint _23277;
	                if ((_23268 & 1u) != 0u)
	                {
	                    _23277 = g_ScrambledHaltonPermutations.Load(_23269 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _23277 = g_ScrambledHaltonPermutations.Load(_23269 * 4 + 0) & 65535u;
	                }
	                uint _23279 = 100108u + ((_12091 / 1324801u) % 1151u);
	                uint _23280 = _23279 / 2u;
	                uint _23288;
	                if ((_23279 & 1u) != 0u)
	                {
	                    _23288 = g_ScrambledHaltonPermutations.Load(_23280 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _23288 = g_ScrambledHaltonPermutations.Load(_23280 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_23264 * 1324801u) + (_23277 * 1151u)) + _23288) * 6.5580385566477161773946136236191e-10f;
	                _33360 = true;
	                break;
	            }
	            case 190u:
	            {
	                uint _23218 = 101259u + (_12091 % 1153u);
	                uint _23219 = _23218 / 2u;
	                uint _23227;
	                if ((_23218 & 1u) != 0u)
	                {
	                    _23227 = g_ScrambledHaltonPermutations.Load(_23219 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _23227 = g_ScrambledHaltonPermutations.Load(_23219 * 4 + 0) & 65535u;
	                }
	                uint _23231 = 101259u + ((_12091 / 1153u) % 1153u);
	                uint _23232 = _23231 / 2u;
	                uint _23240;
	                if ((_23231 & 1u) != 0u)
	                {
	                    _23240 = g_ScrambledHaltonPermutations.Load(_23232 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _23240 = g_ScrambledHaltonPermutations.Load(_23232 * 4 + 0) & 65535u;
	                }
	                uint _23242 = 101259u + ((_12091 / 1329409u) % 1153u);
	                uint _23243 = _23242 / 2u;
	                uint _23251;
	                if ((_23242 & 1u) != 0u)
	                {
	                    _23251 = g_ScrambledHaltonPermutations.Load(_23243 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _23251 = g_ScrambledHaltonPermutations.Load(_23243 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_23227 * 1329409u) + (_23240 * 1153u)) + _23251) * 6.5239708080255809363734442740679e-10f;
	                _33360 = true;
	                break;
	            }
	            case 191u:
	            {
	                uint _23181 = 102412u + (_12091 % 1163u);
	                uint _23182 = _23181 / 2u;
	                uint _23190;
	                if ((_23181 & 1u) != 0u)
	                {
	                    _23190 = g_ScrambledHaltonPermutations.Load(_23182 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _23190 = g_ScrambledHaltonPermutations.Load(_23182 * 4 + 0) & 65535u;
	                }
	                uint _23194 = 102412u + ((_12091 / 1163u) % 1163u);
	                uint _23195 = _23194 / 2u;
	                uint _23203;
	                if ((_23194 & 1u) != 0u)
	                {
	                    _23203 = g_ScrambledHaltonPermutations.Load(_23195 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _23203 = g_ScrambledHaltonPermutations.Load(_23195 * 4 + 0) & 65535u;
	                }
	                uint _23205 = 102412u + ((_12091 / 1352569u) % 1163u);
	                uint _23206 = _23205 / 2u;
	                uint _23214;
	                if ((_23205 & 1u) != 0u)
	                {
	                    _23214 = g_ScrambledHaltonPermutations.Load(_23206 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _23214 = g_ScrambledHaltonPermutations.Load(_23206 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_23190 * 1352569u) + (_23203 * 1163u)) + _23214) * 6.3571259367734000989003106951714e-10f;
	                _33360 = true;
	                break;
	            }
	            case 192u:
	            {
	                uint _23144 = 103575u + (_12091 % 1171u);
	                uint _23145 = _23144 / 2u;
	                uint _23153;
	                if ((_23144 & 1u) != 0u)
	                {
	                    _23153 = g_ScrambledHaltonPermutations.Load(_23145 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _23153 = g_ScrambledHaltonPermutations.Load(_23145 * 4 + 0) & 65535u;
	                }
	                uint _23157 = 103575u + ((_12091 / 1171u) % 1171u);
	                uint _23158 = _23157 / 2u;
	                uint _23166;
	                if ((_23157 & 1u) != 0u)
	                {
	                    _23166 = g_ScrambledHaltonPermutations.Load(_23158 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _23166 = g_ScrambledHaltonPermutations.Load(_23158 * 4 + 0) & 65535u;
	                }
	                uint _23168 = 103575u + ((_12091 / 1371241u) % 1171u);
	                uint _23169 = _23168 / 2u;
	                uint _23177;
	                if ((_23168 & 1u) != 0u)
	                {
	                    _23177 = g_ScrambledHaltonPermutations.Load(_23169 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _23177 = g_ScrambledHaltonPermutations.Load(_23169 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_23153 * 1371241u) + (_23166 * 1171u)) + _23177) * 6.2277222268036780405964236706495e-10f;
	                _33360 = true;
	                break;
	            }
	            case 193u:
	            {
	                uint _23106 = 104746u + (_12091 % 1181u);
	                uint _23107 = _23106 / 2u;
	                uint _23115;
	                if ((_23106 & 1u) != 0u)
	                {
	                    _23115 = g_ScrambledHaltonPermutations.Load(_23107 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _23115 = g_ScrambledHaltonPermutations.Load(_23107 * 4 + 0) & 65535u;
	                }
	                uint _23119 = 104746u + ((_12091 / 1181u) % 1181u);
	                uint _23120 = _23119 / 2u;
	                uint _23128;
	                if ((_23119 & 1u) != 0u)
	                {
	                    _23128 = g_ScrambledHaltonPermutations.Load(_23120 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _23128 = g_ScrambledHaltonPermutations.Load(_23120 * 4 + 0) & 65535u;
	                }
	                uint _23130 = 104746u + ((_12091 / 1394761u) % 1181u);
	                uint _23131 = _23130 / 2u;
	                uint _23140;
	                if ((_23130 & 1u) != 0u)
	                {
	                    _23140 = g_ScrambledHaltonPermutations.Load(_23131 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _23140 = g_ScrambledHaltonPermutations.Load(_23131 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_23115 * 1394761u) + (_23128 * 1181u)) + _23140) * 6.0708604809889266107347793877125e-10f;
	                _33360 = true;
	                break;
	            }
	            case 194u:
	            {
	                uint _23069 = 105927u + (_12091 % 1187u);
	                uint _23070 = _23069 / 2u;
	                uint _23078;
	                if ((_23069 & 1u) != 0u)
	                {
	                    _23078 = g_ScrambledHaltonPermutations.Load(_23070 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _23078 = g_ScrambledHaltonPermutations.Load(_23070 * 4 + 0) & 65535u;
	                }
	                uint _23082 = 105927u + ((_12091 / 1187u) % 1187u);
	                uint _23083 = _23082 / 2u;
	                uint _23091;
	                if ((_23082 & 1u) != 0u)
	                {
	                    _23091 = g_ScrambledHaltonPermutations.Load(_23083 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _23091 = g_ScrambledHaltonPermutations.Load(_23083 * 4 + 0) & 65535u;
	                }
	                uint _23093 = 105927u + ((_12091 / 1408969u) % 1187u);
	                uint _23094 = _23093 / 2u;
	                uint _23102;
	                if ((_23093 & 1u) != 0u)
	                {
	                    _23102 = g_ScrambledHaltonPermutations.Load(_23094 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _23102 = g_ScrambledHaltonPermutations.Load(_23094 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_23078 * 1408969u) + (_23091 * 1187u)) + _23102) * 5.9792648610113019458367489278316e-10f;
	                _33360 = true;
	                break;
	            }
	            case 195u:
	            {
	                uint _23032 = 107114u + (_12091 % 1193u);
	                uint _23033 = _23032 / 2u;
	                uint _23041;
	                if ((_23032 & 1u) != 0u)
	                {
	                    _23041 = g_ScrambledHaltonPermutations.Load(_23033 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _23041 = g_ScrambledHaltonPermutations.Load(_23033 * 4 + 0) & 65535u;
	                }
	                uint _23045 = 107114u + ((_12091 / 1193u) % 1193u);
	                uint _23046 = _23045 / 2u;
	                uint _23054;
	                if ((_23045 & 1u) != 0u)
	                {
	                    _23054 = g_ScrambledHaltonPermutations.Load(_23046 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _23054 = g_ScrambledHaltonPermutations.Load(_23046 * 4 + 0) & 65535u;
	                }
	                uint _23056 = 107114u + ((_12091 / 1423249u) % 1193u);
	                uint _23057 = _23056 / 2u;
	                uint _23065;
	                if ((_23056 & 1u) != 0u)
	                {
	                    _23065 = g_ScrambledHaltonPermutations.Load(_23057 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _23065 = g_ScrambledHaltonPermutations.Load(_23057 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_23041 * 1423249u) + (_23054 * 1193u)) + _23065) * 5.8895027743588457269652280956507e-10f;
	                _33360 = true;
	                break;
	            }
	            case 196u:
	            {
	                uint _22995 = 108307u + (_12091 % 1201u);
	                uint _22996 = _22995 / 2u;
	                uint _23004;
	                if ((_22995 & 1u) != 0u)
	                {
	                    _23004 = g_ScrambledHaltonPermutations.Load(_22996 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _23004 = g_ScrambledHaltonPermutations.Load(_22996 * 4 + 0) & 65535u;
	                }
	                uint _23008 = 108307u + ((_12091 / 1201u) % 1201u);
	                uint _23009 = _23008 / 2u;
	                uint _23017;
	                if ((_23008 & 1u) != 0u)
	                {
	                    _23017 = g_ScrambledHaltonPermutations.Load(_23009 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _23017 = g_ScrambledHaltonPermutations.Load(_23009 * 4 + 0) & 65535u;
	                }
	                uint _23019 = 108307u + ((_12091 / 1442401u) % 1201u);
	                uint _23020 = _23019 / 2u;
	                uint _23028;
	                if ((_23019 & 1u) != 0u)
	                {
	                    _23028 = g_ScrambledHaltonPermutations.Load(_23020 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _23028 = g_ScrambledHaltonPermutations.Load(_23020 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_23004 * 1442401u) + (_23017 * 1201u)) + _23028) * 5.7725929591967428677889984101057e-10f;
	                _33360 = true;
	                break;
	            }
	            case 197u:
	            {
	                uint _22958 = 109508u + (_12091 % 1213u);
	                uint _22959 = _22958 / 2u;
	                uint _22967;
	                if ((_22958 & 1u) != 0u)
	                {
	                    _22967 = g_ScrambledHaltonPermutations.Load(_22959 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _22967 = g_ScrambledHaltonPermutations.Load(_22959 * 4 + 0) & 65535u;
	                }
	                uint _22971 = 109508u + ((_12091 / 1213u) % 1213u);
	                uint _22972 = _22971 / 2u;
	                uint _22980;
	                if ((_22971 & 1u) != 0u)
	                {
	                    _22980 = g_ScrambledHaltonPermutations.Load(_22972 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _22980 = g_ScrambledHaltonPermutations.Load(_22972 * 4 + 0) & 65535u;
	                }
	                uint _22982 = 109508u + ((_12091 / 1471369u) % 1213u);
	                uint _22983 = _22982 / 2u;
	                uint _22991;
	                if ((_22982 & 1u) != 0u)
	                {
	                    _22991 = g_ScrambledHaltonPermutations.Load(_22983 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _22991 = g_ScrambledHaltonPermutations.Load(_22983 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_22967 * 1471369u) + (_22980 * 1213u)) + _22991) * 5.6029603179297282622428610920906e-10f;
	                _33360 = true;
	                break;
	            }
	            case 198u:
	            {
	                uint _22921 = 110721u + (_12091 % 1217u);
	                uint _22922 = _22921 / 2u;
	                uint _22930;
	                if ((_22921 & 1u) != 0u)
	                {
	                    _22930 = g_ScrambledHaltonPermutations.Load(_22922 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _22930 = g_ScrambledHaltonPermutations.Load(_22922 * 4 + 0) & 65535u;
	                }
	                uint _22934 = 110721u + ((_12091 / 1217u) % 1217u);
	                uint _22935 = _22934 / 2u;
	                uint _22943;
	                if ((_22934 & 1u) != 0u)
	                {
	                    _22943 = g_ScrambledHaltonPermutations.Load(_22935 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _22943 = g_ScrambledHaltonPermutations.Load(_22935 * 4 + 0) & 65535u;
	                }
	                uint _22945 = 110721u + ((_12091 / 1481089u) % 1217u);
	                uint _22946 = _22945 / 2u;
	                uint _22954;
	                if ((_22945 & 1u) != 0u)
	                {
	                    _22954 = g_ScrambledHaltonPermutations.Load(_22946 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _22954 = g_ScrambledHaltonPermutations.Load(_22946 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_22930 * 1481089u) + (_22943 * 1217u)) + _22954) * 5.547894366131345122994389384985e-10f;
	                _33360 = true;
	                break;
	            }
	            case 199u:
	            {
	                uint _22884 = 111938u + (_12091 % 1223u);
	                uint _22885 = _22884 / 2u;
	                uint _22893;
	                if ((_22884 & 1u) != 0u)
	                {
	                    _22893 = g_ScrambledHaltonPermutations.Load(_22885 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _22893 = g_ScrambledHaltonPermutations.Load(_22885 * 4 + 0) & 65535u;
	                }
	                uint _22897 = 111938u + ((_12091 / 1223u) % 1223u);
	                uint _22898 = _22897 / 2u;
	                uint _22906;
	                if ((_22897 & 1u) != 0u)
	                {
	                    _22906 = g_ScrambledHaltonPermutations.Load(_22898 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _22906 = g_ScrambledHaltonPermutations.Load(_22898 * 4 + 0) & 65535u;
	                }
	                uint _22908 = 111938u + ((_12091 / 1495729u) % 1223u);
	                uint _22909 = _22908 / 2u;
	                uint _22917;
	                if ((_22908 & 1u) != 0u)
	                {
	                    _22917 = g_ScrambledHaltonPermutations.Load(_22909 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _22917 = g_ScrambledHaltonPermutations.Load(_22909 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_22893 * 1495729u) + (_22906 * 1223u)) + _22917) * 5.4666415838511284164269454777241e-10f;
	                _33360 = true;
	                break;
	            }
	            case 200u:
	            {
	                uint _22847 = 113161u + (_12091 % 1229u);
	                uint _22848 = _22847 / 2u;
	                uint _22856;
	                if ((_22847 & 1u) != 0u)
	                {
	                    _22856 = g_ScrambledHaltonPermutations.Load(_22848 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _22856 = g_ScrambledHaltonPermutations.Load(_22848 * 4 + 0) & 65535u;
	                }
	                uint _22860 = 113161u + ((_12091 / 1229u) % 1229u);
	                uint _22861 = _22860 / 2u;
	                uint _22869;
	                if ((_22860 & 1u) != 0u)
	                {
	                    _22869 = g_ScrambledHaltonPermutations.Load(_22861 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _22869 = g_ScrambledHaltonPermutations.Load(_22861 * 4 + 0) & 65535u;
	                }
	                uint _22871 = 113161u + ((_12091 / 1510441u) % 1229u);
	                uint _22872 = _22871 / 2u;
	                uint _22880;
	                if ((_22871 & 1u) != 0u)
	                {
	                    _22880 = g_ScrambledHaltonPermutations.Load(_22872 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _22880 = g_ScrambledHaltonPermutations.Load(_22872 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_22856 * 1510441u) + (_22869 * 1229u)) + _22880) * 5.3869664284889040573034435510635e-10f;
	                _33360 = true;
	                break;
	            }
	            case 201u:
	            {
	                uint _22810 = 114390u + (_12091 % 1231u);
	                uint _22811 = _22810 / 2u;
	                uint _22819;
	                if ((_22810 & 1u) != 0u)
	                {
	                    _22819 = g_ScrambledHaltonPermutations.Load(_22811 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _22819 = g_ScrambledHaltonPermutations.Load(_22811 * 4 + 0) & 65535u;
	                }
	                uint _22823 = 114390u + ((_12091 / 1231u) % 1231u);
	                uint _22824 = _22823 / 2u;
	                uint _22832;
	                if ((_22823 & 1u) != 0u)
	                {
	                    _22832 = g_ScrambledHaltonPermutations.Load(_22824 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _22832 = g_ScrambledHaltonPermutations.Load(_22824 * 4 + 0) & 65535u;
	                }
	                uint _22834 = 114390u + ((_12091 / 1515361u) % 1231u);
	                uint _22835 = _22834 / 2u;
	                uint _22843;
	                if ((_22834 & 1u) != 0u)
	                {
	                    _22843 = g_ScrambledHaltonPermutations.Load(_22835 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _22843 = g_ScrambledHaltonPermutations.Load(_22835 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_22819 * 1515361u) + (_22832 * 1231u)) + _22843) * 5.3607529526544794862275011837482e-10f;
	                _33360 = true;
	                break;
	            }
	            case 202u:
	            {
	                uint _22773 = 115621u + (_12091 % 1237u);
	                uint _22774 = _22773 / 2u;
	                uint _22782;
	                if ((_22773 & 1u) != 0u)
	                {
	                    _22782 = g_ScrambledHaltonPermutations.Load(_22774 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _22782 = g_ScrambledHaltonPermutations.Load(_22774 * 4 + 0) & 65535u;
	                }
	                uint _22786 = 115621u + ((_12091 / 1237u) % 1237u);
	                uint _22787 = _22786 / 2u;
	                uint _22795;
	                if ((_22786 & 1u) != 0u)
	                {
	                    _22795 = g_ScrambledHaltonPermutations.Load(_22787 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _22795 = g_ScrambledHaltonPermutations.Load(_22787 * 4 + 0) & 65535u;
	                }
	                uint _22797 = 115621u + ((_12091 / 1530169u) % 1237u);
	                uint _22798 = _22797 / 2u;
	                uint _22806;
	                if ((_22797 & 1u) != 0u)
	                {
	                    _22806 = g_ScrambledHaltonPermutations.Load(_22798 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _22806 = g_ScrambledHaltonPermutations.Load(_22798 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_22782 * 1530169u) + (_22795 * 1237u)) + _22806) * 5.2831244934381516031862702220678e-10f;
	                _33360 = true;
	                break;
	            }
	            case 203u:
	            {
	                uint _22736 = 116858u + (_12091 % 1249u);
	                uint _22737 = _22736 / 2u;
	                uint _22745;
	                if ((_22736 & 1u) != 0u)
	                {
	                    _22745 = g_ScrambledHaltonPermutations.Load(_22737 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _22745 = g_ScrambledHaltonPermutations.Load(_22737 * 4 + 0) & 65535u;
	                }
	                uint _22749 = 116858u + ((_12091 / 1249u) % 1249u);
	                uint _22750 = _22749 / 2u;
	                uint _22758;
	                if ((_22749 & 1u) != 0u)
	                {
	                    _22758 = g_ScrambledHaltonPermutations.Load(_22750 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _22758 = g_ScrambledHaltonPermutations.Load(_22750 * 4 + 0) & 65535u;
	                }
	                uint _22760 = 116858u + ((_12091 / 1560001u) % 1249u);
	                uint _22761 = _22760 / 2u;
	                uint _22769;
	                if ((_22760 & 1u) != 0u)
	                {
	                    _22769 = g_ScrambledHaltonPermutations.Load(_22761 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _22769 = g_ScrambledHaltonPermutations.Load(_22761 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_22745 * 1560001u) + (_22758 * 1249u)) + _22769) * 5.1323073568809718381089624017477e-10f;
	                _33360 = true;
	                break;
	            }
	            case 204u:
	            {
	                uint _22699 = 118107u + (_12091 % 1259u);
	                uint _22700 = _22699 / 2u;
	                uint _22708;
	                if ((_22699 & 1u) != 0u)
	                {
	                    _22708 = g_ScrambledHaltonPermutations.Load(_22700 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _22708 = g_ScrambledHaltonPermutations.Load(_22700 * 4 + 0) & 65535u;
	                }
	                uint _22712 = 118107u + ((_12091 / 1259u) % 1259u);
	                uint _22713 = _22712 / 2u;
	                uint _22721;
	                if ((_22712 & 1u) != 0u)
	                {
	                    _22721 = g_ScrambledHaltonPermutations.Load(_22713 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _22721 = g_ScrambledHaltonPermutations.Load(_22713 * 4 + 0) & 65535u;
	                }
	                uint _22723 = 118107u + ((_12091 / 1585081u) % 1259u);
	                uint _22724 = _22723 / 2u;
	                uint _22732;
	                if ((_22723 & 1u) != 0u)
	                {
	                    _22732 = g_ScrambledHaltonPermutations.Load(_22724 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _22732 = g_ScrambledHaltonPermutations.Load(_22724 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_22708 * 1585081u) + (_22721 * 1259u)) + _22732) * 5.0109810745269101062149275094271e-10f;
	                _33360 = true;
	                break;
	            }
	            case 205u:
	            {
	                uint _22662 = 119366u + (_12091 % 1277u);
	                uint _22663 = _22662 / 2u;
	                uint _22671;
	                if ((_22662 & 1u) != 0u)
	                {
	                    _22671 = g_ScrambledHaltonPermutations.Load(_22663 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _22671 = g_ScrambledHaltonPermutations.Load(_22663 * 4 + 0) & 65535u;
	                }
	                uint _22675 = 119366u + ((_12091 / 1277u) % 1277u);
	                uint _22676 = _22675 / 2u;
	                uint _22684;
	                if ((_22675 & 1u) != 0u)
	                {
	                    _22684 = g_ScrambledHaltonPermutations.Load(_22676 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _22684 = g_ScrambledHaltonPermutations.Load(_22676 * 4 + 0) & 65535u;
	                }
	                uint _22686 = 119366u + ((_12091 / 1630729u) % 1277u);
	                uint _22687 = _22686 / 2u;
	                uint _22695;
	                if ((_22686 & 1u) != 0u)
	                {
	                    _22695 = g_ScrambledHaltonPermutations.Load(_22687 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _22695 = g_ScrambledHaltonPermutations.Load(_22687 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_22671 * 1630729u) + (_22684 * 1277u)) + _22695) * 4.8020565301953865855466574430466e-10f;
	                _33360 = true;
	                break;
	            }
	            case 206u:
	            {
	                uint _22625 = 120643u + (_12091 % 1279u);
	                uint _22626 = _22625 / 2u;
	                uint _22634;
	                if ((_22625 & 1u) != 0u)
	                {
	                    _22634 = g_ScrambledHaltonPermutations.Load(_22626 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _22634 = g_ScrambledHaltonPermutations.Load(_22626 * 4 + 0) & 65535u;
	                }
	                uint _22638 = 120643u + ((_12091 / 1279u) % 1279u);
	                uint _22639 = _22638 / 2u;
	                uint _22647;
	                if ((_22638 & 1u) != 0u)
	                {
	                    _22647 = g_ScrambledHaltonPermutations.Load(_22639 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _22647 = g_ScrambledHaltonPermutations.Load(_22639 * 4 + 0) & 65535u;
	                }
	                uint _22649 = 120643u + ((_12091 / 1635841u) % 1279u);
	                uint _22650 = _22649 / 2u;
	                uint _22658;
	                if ((_22649 & 1u) != 0u)
	                {
	                    _22658 = g_ScrambledHaltonPermutations.Load(_22650 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _22658 = g_ScrambledHaltonPermutations.Load(_22650 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_22634 * 1635841u) + (_22647 * 1279u)) + _22658) * 4.7795645219395055391942150890827e-10f;
	                _33360 = true;
	                break;
	            }
	            case 207u:
	            {
	                uint _22580 = 121922u + (_12091 % 1283u);
	                uint _22581 = _22580 / 2u;
	                uint _22589;
	                if ((_22580 & 1u) != 0u)
	                {
	                    _22589 = g_ScrambledHaltonPermutations.Load(_22581 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _22589 = g_ScrambledHaltonPermutations.Load(_22581 * 4 + 0) & 65535u;
	                }
	                uint _22593 = 121922u + ((_12091 / 1283u) % 1283u);
	                uint _22594 = _22593 / 2u;
	                uint _22602;
	                if ((_22593 & 1u) != 0u)
	                {
	                    _22602 = g_ScrambledHaltonPermutations.Load(_22594 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _22602 = g_ScrambledHaltonPermutations.Load(_22594 * 4 + 0) & 65535u;
	                }
	                uint _22604 = 121922u + ((_12091 / 1646089u) % 1283u);
	                uint _22605 = _22604 / 2u;
	                uint _22621;
	                if ((_22604 & 1u) != 0u)
	                {
	                    _22621 = g_ScrambledHaltonPermutations.Load(_22605 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _22621 = g_ScrambledHaltonPermutations.Load(_22605 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_22589 * 1646089u) + (_22602 * 1283u)) + _22621) * 4.7350001697310517556616105139256e-10f;
	                _33360 = true;
	                break;
	            }
	            case 208u:
	            {
	                uint _22543 = 123205u + (_12091 % 1289u);
	                uint _22544 = _22543 / 2u;
	                uint _22552;
	                if ((_22543 & 1u) != 0u)
	                {
	                    _22552 = g_ScrambledHaltonPermutations.Load(_22544 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _22552 = g_ScrambledHaltonPermutations.Load(_22544 * 4 + 0) & 65535u;
	                }
	                uint _22556 = 123205u + ((_12091 / 1289u) % 1289u);
	                uint _22557 = _22556 / 2u;
	                uint _22565;
	                if ((_22556 & 1u) != 0u)
	                {
	                    _22565 = g_ScrambledHaltonPermutations.Load(_22557 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _22565 = g_ScrambledHaltonPermutations.Load(_22557 * 4 + 0) & 65535u;
	                }
	                uint _22567 = 123205u + ((_12091 / 1661521u) % 1289u);
	                uint _22568 = _22567 / 2u;
	                uint _22576;
	                if ((_22567 & 1u) != 0u)
	                {
	                    _22576 = g_ScrambledHaltonPermutations.Load(_22568 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _22576 = g_ScrambledHaltonPermutations.Load(_22568 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_22552 * 1661521u) + (_22565 * 1289u)) + _22576) * 4.6691861488312724759452976286411e-10f;
	                _33360 = true;
	                break;
	            }
	            case 209u:
	            {
	                uint _22506 = 124494u + (_12091 % 1291u);
	                uint _22507 = _22506 / 2u;
	                uint _22515;
	                if ((_22506 & 1u) != 0u)
	                {
	                    _22515 = g_ScrambledHaltonPermutations.Load(_22507 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _22515 = g_ScrambledHaltonPermutations.Load(_22507 * 4 + 0) & 65535u;
	                }
	                uint _22519 = 124494u + ((_12091 / 1291u) % 1291u);
	                uint _22520 = _22519 / 2u;
	                uint _22528;
	                if ((_22519 & 1u) != 0u)
	                {
	                    _22528 = g_ScrambledHaltonPermutations.Load(_22520 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _22528 = g_ScrambledHaltonPermutations.Load(_22520 * 4 + 0) & 65535u;
	                }
	                uint _22530 = 124494u + ((_12091 / 1666681u) % 1291u);
	                uint _22531 = _22530 / 2u;
	                uint _22539;
	                if ((_22530 & 1u) != 0u)
	                {
	                    _22539 = g_ScrambledHaltonPermutations.Load(_22531 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _22539 = g_ScrambledHaltonPermutations.Load(_22531 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_22515 * 1666681u) + (_22528 * 1291u)) + _22539) * 4.6475195913942002334806602448225e-10f;
	                _33360 = true;
	                break;
	            }
	            case 210u:
	            {
	                uint _22468 = 125785u + (_12091 % 1297u);
	                uint _22469 = _22468 / 2u;
	                uint _22478;
	                if ((_22468 & 1u) != 0u)
	                {
	                    _22478 = g_ScrambledHaltonPermutations.Load(_22469 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _22478 = g_ScrambledHaltonPermutations.Load(_22469 * 4 + 0) & 65535u;
	                }
	                uint _22482 = 125785u + ((_12091 / 1297u) % 1297u);
	                uint _22483 = _22482 / 2u;
	                uint _22491;
	                if ((_22482 & 1u) != 0u)
	                {
	                    _22491 = g_ScrambledHaltonPermutations.Load(_22483 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _22491 = g_ScrambledHaltonPermutations.Load(_22483 * 4 + 0) & 65535u;
	                }
	                uint _22493 = 125785u + ((_12091 / 1682209u) % 1297u);
	                uint _22494 = _22493 / 2u;
	                uint _22502;
	                if ((_22493 & 1u) != 0u)
	                {
	                    _22502 = g_ScrambledHaltonPermutations.Load(_22494 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _22502 = g_ScrambledHaltonPermutations.Load(_22494 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_22478 * 1682209u) + (_22491 * 1297u)) + _22502) * 4.5833184469934451499284477904439e-10f;
	                _33360 = true;
	                break;
	            }
	            case 211u:
	            {
	                uint _22430 = 127082u + (_12091 % 1301u);
	                uint _22431 = _22430 / 2u;
	                uint _22439;
	                if ((_22430 & 1u) != 0u)
	                {
	                    _22439 = g_ScrambledHaltonPermutations.Load(_22431 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _22439 = g_ScrambledHaltonPermutations.Load(_22431 * 4 + 0) & 65535u;
	                }
	                uint _22443 = 127082u + ((_12091 / 1301u) % 1301u);
	                uint _22444 = _22443 / 2u;
	                uint _22452;
	                if ((_22443 & 1u) != 0u)
	                {
	                    _22452 = g_ScrambledHaltonPermutations.Load(_22444 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _22452 = g_ScrambledHaltonPermutations.Load(_22444 * 4 + 0) & 65535u;
	                }
	                uint _22454 = 127082u + ((_12091 / 1692601u) % 1301u);
	                uint _22455 = _22454 / 2u;
	                uint _22463;
	                if ((_22454 & 1u) != 0u)
	                {
	                    _22463 = g_ScrambledHaltonPermutations.Load(_22455 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _22463 = g_ScrambledHaltonPermutations.Load(_22455 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_22439 * 1692601u) + (_22452 * 1301u)) + _22463) * 4.5411732707556495824974263086915e-10f;
	                _33360 = true;
	                break;
	            }
	            case 212u:
	            {
	                uint _22392 = 128383u + (_12091 % 1303u);
	                uint _22393 = _22392 / 2u;
	                uint _22401;
	                if ((_22392 & 1u) != 0u)
	                {
	                    _22401 = g_ScrambledHaltonPermutations.Load(_22393 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _22401 = g_ScrambledHaltonPermutations.Load(_22393 * 4 + 0) & 65535u;
	                }
	                uint _22405 = 128383u + ((_12091 / 1303u) % 1303u);
	                uint _22406 = _22405 / 2u;
	                uint _22414;
	                if ((_22405 & 1u) != 0u)
	                {
	                    _22414 = g_ScrambledHaltonPermutations.Load(_22406 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _22414 = g_ScrambledHaltonPermutations.Load(_22406 * 4 + 0) & 65535u;
	                }
	                uint _22417 = 128383u + ((_12091 / 1697809u) % 1303u);
	                uint _22418 = _22417 / 2u;
	                uint _22426;
	                if ((_22417 & 1u) != 0u)
	                {
	                    _22426 = g_ScrambledHaltonPermutations.Load(_22418 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _22426 = g_ScrambledHaltonPermutations.Load(_22418 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_22401 * 1697809u) + (_22414 * 1303u)) + _22426) * 4.5202938614430365760199492797256e-10f;
	                _33360 = true;
	                break;
	            }
	            case 213u:
	            {
	                uint _22050 = 129686u + (_12091 % 1307u);
	                uint _22051 = _22050 / 2u;
	                uint _22059;
	                if ((_22050 & 1u) != 0u)
	                {
	                    _22059 = g_ScrambledHaltonPermutations.Load(_22051 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _22059 = g_ScrambledHaltonPermutations.Load(_22051 * 4 + 0) & 65535u;
	                }
	                uint _22063 = 129686u + ((_12091 / 1307u) % 1307u);
	                uint _22064 = _22063 / 2u;
	                uint _22072;
	                if ((_22063 & 1u) != 0u)
	                {
	                    _22072 = g_ScrambledHaltonPermutations.Load(_22064 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _22072 = g_ScrambledHaltonPermutations.Load(_22064 * 4 + 0) & 65535u;
	                }
	                uint _22074 = 129686u + ((_12091 / 1708249u) % 1307u);
	                uint _22075 = _22074 / 2u;
	                uint _22083;
	                if ((_22074 & 1u) != 0u)
	                {
	                    _22083 = g_ScrambledHaltonPermutations.Load(_22075 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _22083 = g_ScrambledHaltonPermutations.Load(_22075 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_22059 * 1708249u) + (_22072 * 1307u)) + _22083) * 4.478918624872818554649711586535e-10f;
	                _33360 = true;
	                break;
	            }
	            case 214u:
	            {
	                uint _22014 = 130993u + (_12091 % 1319u);
	                uint _22015 = _22014 / 2u;
	                uint _22023;
	                if ((_22014 & 1u) != 0u)
	                {
	                    _22023 = g_ScrambledHaltonPermutations.Load(_22015 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _22023 = g_ScrambledHaltonPermutations.Load(_22015 * 4 + 0) & 65535u;
	                }
	                uint _22027 = 130993u + ((_12091 / 1319u) % 1319u);
	                uint _22028 = _22027 / 2u;
	                uint _22036;
	                if ((_22027 & 1u) != 0u)
	                {
	                    _22036 = g_ScrambledHaltonPermutations.Load(_22028 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _22036 = g_ScrambledHaltonPermutations.Load(_22028 * 4 + 0) & 65535u;
	                }
	                uint _22038 = 130993u + ((_12091 / 1739761u) % 1319u);
	                uint _22039 = _22038 / 2u;
	                uint _22047;
	                if ((_22038 & 1u) != 0u)
	                {
	                    _22047 = g_ScrambledHaltonPermutations.Load(_22039 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _22047 = g_ScrambledHaltonPermutations.Load(_22039 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_22023 * 1739761u) + (_22036 * 1319u)) + _22047) * 4.3577824682117238808132242411375e-10f;
	                _33360 = true;
	                break;
	            }
	            case 215u:
	            {
	                uint _21977 = 132312u + (_12091 % 1321u);
	                uint _21978 = _21977 / 2u;
	                uint _21986;
	                if ((_21977 & 1u) != 0u)
	                {
	                    _21986 = g_ScrambledHaltonPermutations.Load(_21978 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _21986 = g_ScrambledHaltonPermutations.Load(_21978 * 4 + 0) & 65535u;
	                }
	                uint _21990 = 132312u + ((_12091 / 1321u) % 1321u);
	                uint _21991 = _21990 / 2u;
	                uint _21999;
	                if ((_21990 & 1u) != 0u)
	                {
	                    _21999 = g_ScrambledHaltonPermutations.Load(_21991 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _21999 = g_ScrambledHaltonPermutations.Load(_21991 * 4 + 0) & 65535u;
	                }
	                uint _22001 = 132312u + ((_12091 / 1745041u) % 1321u);
	                uint _22002 = _22001 / 2u;
	                uint _22010;
	                if ((_22001 & 1u) != 0u)
	                {
	                    _22010 = g_ScrambledHaltonPermutations.Load(_22002 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _22010 = g_ScrambledHaltonPermutations.Load(_22002 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_21986 * 1745041u) + (_21999 * 1321u)) + _22010) * 4.3380196657061276255262782797217e-10f;
	                _33360 = true;
	                break;
	            }
	            case 216u:
	            {
	                uint _21941 = 133633u + (_12091 % 1327u);
	                uint _21942 = _21941 / 2u;
	                uint _21950;
	                if ((_21941 & 1u) != 0u)
	                {
	                    _21950 = g_ScrambledHaltonPermutations.Load(_21942 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _21950 = g_ScrambledHaltonPermutations.Load(_21942 * 4 + 0) & 65535u;
	                }
	                uint _21954 = 133633u + ((_12091 / 1327u) % 1327u);
	                uint _21955 = _21954 / 2u;
	                uint _21963;
	                if ((_21954 & 1u) != 0u)
	                {
	                    _21963 = g_ScrambledHaltonPermutations.Load(_21955 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _21963 = g_ScrambledHaltonPermutations.Load(_21955 * 4 + 0) & 65535u;
	                }
	                uint _21965 = 133633u + ((_12091 / 1760929u) % 1327u);
	                uint _21966 = _21965 / 2u;
	                uint _21974;
	                if ((_21965 & 1u) != 0u)
	                {
	                    _21974 = g_ScrambledHaltonPermutations.Load(_21966 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _21974 = g_ScrambledHaltonPermutations.Load(_21966 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_21950 * 1760929u) + (_21963 * 1327u)) + _21974) * 4.2794420784808551161404466256499e-10f;
	                _33360 = true;
	                break;
	            }
	            case 217u:
	            {
	                uint _20944 = 134960u + (_12091 % 1361u);
	                uint _20945 = _20944 / 2u;
	                uint _20952;
	                if ((_20944 & 1u) != 0u)
	                {
	                    _20952 = g_ScrambledHaltonPermutations.Load(_20945 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _20952 = g_ScrambledHaltonPermutations.Load(_20945 * 4 + 0) & 65535u;
	                }
	                uint _21918 = 134960u + ((_12091 / 1361u) % 1361u);
	                uint _21919 = _21918 / 2u;
	                uint _21927;
	                if ((_21918 & 1u) != 0u)
	                {
	                    _21927 = g_ScrambledHaltonPermutations.Load(_21919 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _21927 = g_ScrambledHaltonPermutations.Load(_21919 * 4 + 0) & 65535u;
	                }
	                uint _21929 = 134960u + ((_12091 / 1852321u) % 1361u);
	                uint _21930 = _21929 / 2u;
	                uint _21938;
	                if ((_21929 & 1u) != 0u)
	                {
	                    _21938 = g_ScrambledHaltonPermutations.Load(_21930 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _21938 = g_ScrambledHaltonPermutations.Load(_21930 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_20952 * 1852321u) + (_21927 * 1361u)) + _21938) * 3.9666653295356013586570043116808e-10f;
	                _33360 = true;
	                break;
	            }
	            case 218u:
	            {
	                uint _20256 = 136321u + (_12091 % 1367u);
	                uint _20257 = _20256 / 2u;
	                uint _20264;
	                if ((_20256 & 1u) != 0u)
	                {
	                    _20264 = g_ScrambledHaltonPermutations.Load(_20257 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _20264 = g_ScrambledHaltonPermutations.Load(_20257 * 4 + 0) & 65535u;
	                }
	                uint _20924 = 136321u + ((_12091 / 1367u) % 1367u);
	                uint _20268 = _20924 / 2u;
	                uint _20931;
	                if ((_20924 & 1u) != 0u)
	                {
	                    _20931 = g_ScrambledHaltonPermutations.Load(_20268 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _20931 = g_ScrambledHaltonPermutations.Load(_20268 * 4 + 0) & 65535u;
	                }
	                uint _20933 = 136321u + ((_12091 / 1868689u) % 1367u);
	                uint _20934 = _20933 / 2u;
	                uint _20941;
	                if ((_20933 & 1u) != 0u)
	                {
	                    _20941 = g_ScrambledHaltonPermutations.Load(_20934 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _20941 = g_ScrambledHaltonPermutations.Load(_20934 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_20264 * 1868689u) + (_20931 * 1367u)) + _20941) * 3.9146633157294274951709667220712e-10f;
	                _33360 = true;
	                break;
	            }
	            case 219u:
	            {
	                uint _20225 = 137688u + (_12091 % 1373u);
	                uint _20226 = _20225 / 2u;
	                uint _20233;
	                if ((_20225 & 1u) != 0u)
	                {
	                    _20233 = g_ScrambledHaltonPermutations.Load(_20226 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _20233 = g_ScrambledHaltonPermutations.Load(_20226 * 4 + 0) & 65535u;
	                }
	                uint _20922 = 137688u + ((_12091 / 1373u) % 1373u);
	                uint _20237 = _20922 / 2u;
	                uint _20244;
	                if ((_20922 & 1u) != 0u)
	                {
	                    _20244 = g_ScrambledHaltonPermutations.Load(_20237 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _20244 = g_ScrambledHaltonPermutations.Load(_20237 * 4 + 0) & 65535u;
	                }
	                uint _20923 = 137688u + ((_12091 / 1885129u) % 1373u);
	                uint _20246 = _20923 / 2u;
	                uint _20253;
	                if ((_20923 & 1u) != 0u)
	                {
	                    _20253 = g_ScrambledHaltonPermutations.Load(_20246 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _20253 = g_ScrambledHaltonPermutations.Load(_20246 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_20233 * 1885129u) + (_20244 * 1373u)) + _20253) * 3.863566133688323134265374392271e-10f;
	                _33360 = true;
	                break;
	            }
	            case 220u:
	            {
	                uint _20194 = 139061u + (_12091 % 1381u);
	                uint _20195 = _20194 / 2u;
	                uint _20202;
	                if ((_20194 & 1u) != 0u)
	                {
	                    _20202 = g_ScrambledHaltonPermutations.Load(_20195 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _20202 = g_ScrambledHaltonPermutations.Load(_20195 * 4 + 0) & 65535u;
	                }
	                uint _20920 = 139061u + ((_12091 / 1381u) % 1381u);
	                uint _20206 = _20920 / 2u;
	                uint _20213;
	                if ((_20920 & 1u) != 0u)
	                {
	                    _20213 = g_ScrambledHaltonPermutations.Load(_20206 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _20213 = g_ScrambledHaltonPermutations.Load(_20206 * 4 + 0) & 65535u;
	                }
	                uint _20921 = 139061u + ((_12091 / 1907161u) % 1381u);
	                uint _20215 = _20921 / 2u;
	                uint _20222;
	                if ((_20921 & 1u) != 0u)
	                {
	                    _20222 = g_ScrambledHaltonPermutations.Load(_20215 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _20222 = g_ScrambledHaltonPermutations.Load(_20215 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_20202 * 1907161u) + (_20213 * 1381u)) + _20222) * 3.7968103661079055655136471614242e-10f;
	                _33360 = true;
	                break;
	            }
	            case 221u:
	            {
	                uint _20161 = 140442u + (_12091 % 1399u);
	                uint _20162 = _20161 / 2u;
	                uint _20170;
	                if ((_20161 & 1u) != 0u)
	                {
	                    _20170 = g_ScrambledHaltonPermutations.Load(_20162 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _20170 = g_ScrambledHaltonPermutations.Load(_20162 * 4 + 0) & 65535u;
	                }
	                uint _20918 = 140442u + ((_12091 / 1399u) % 1399u);
	                uint _20174 = _20918 / 2u;
	                uint _20181;
	                if ((_20918 & 1u) != 0u)
	                {
	                    _20181 = g_ScrambledHaltonPermutations.Load(_20174 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _20181 = g_ScrambledHaltonPermutations.Load(_20174 * 4 + 0) & 65535u;
	                }
	                uint _20919 = 140442u + ((_12091 / 1957201u) % 1399u);
	                uint _20183 = _20919 / 2u;
	                uint _20190;
	                if ((_20919 & 1u) != 0u)
	                {
	                    _20190 = g_ScrambledHaltonPermutations.Load(_20183 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _20190 = g_ScrambledHaltonPermutations.Load(_20183 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_20170 * 1957201u) + (_20181 * 1399u)) + _20190) * 3.652134705767196010128827765584e-10f;
	                _33360 = true;
	                break;
	            }
	            case 222u:
	            {
	                uint _20130 = 141841u + (_12091 % 1409u);
	                uint _20131 = _20130 / 2u;
	                uint _20138;
	                if ((_20130 & 1u) != 0u)
	                {
	                    _20138 = g_ScrambledHaltonPermutations.Load(_20131 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _20138 = g_ScrambledHaltonPermutations.Load(_20131 * 4 + 0) & 65535u;
	                }
	                uint _20915 = 141841u + ((_12091 / 1409u) % 1409u);
	                uint _20142 = _20915 / 2u;
	                uint _20149;
	                if ((_20915 & 1u) != 0u)
	                {
	                    _20149 = g_ScrambledHaltonPermutations.Load(_20142 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _20149 = g_ScrambledHaltonPermutations.Load(_20142 * 4 + 0) & 65535u;
	                }
	                uint _20916 = 141841u + ((_12091 / 1985281u) % 1409u);
	                uint _20151 = _20916 / 2u;
	                uint _20158;
	                if ((_20916 & 1u) != 0u)
	                {
	                    _20158 = g_ScrambledHaltonPermutations.Load(_20151 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _20158 = g_ScrambledHaltonPermutations.Load(_20151 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_20138 * 1985281u) + (_20149 * 1409u)) + _20158) * 3.5749250781869079673924716189504e-10f;
	                _33360 = true;
	                break;
	            }
	            case 223u:
	            {
	                uint _20099 = 143250u + (_12091 % 1423u);
	                uint _20100 = _20099 / 2u;
	                uint _20107;
	                if ((_20099 & 1u) != 0u)
	                {
	                    _20107 = g_ScrambledHaltonPermutations.Load(_20100 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _20107 = g_ScrambledHaltonPermutations.Load(_20100 * 4 + 0) & 65535u;
	                }
	                uint _20913 = 143250u + ((_12091 / 1423u) % 1423u);
	                uint _20111 = _20913 / 2u;
	                uint _20118;
	                if ((_20913 & 1u) != 0u)
	                {
	                    _20118 = g_ScrambledHaltonPermutations.Load(_20111 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _20118 = g_ScrambledHaltonPermutations.Load(_20111 * 4 + 0) & 65535u;
	                }
	                uint _20914 = 143250u + ((_12091 / 2024929u) % 1423u);
	                uint _20120 = _20914 / 2u;
	                uint _20127;
	                if ((_20914 & 1u) != 0u)
	                {
	                    _20127 = g_ScrambledHaltonPermutations.Load(_20120 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _20127 = g_ScrambledHaltonPermutations.Load(_20120 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_20107 * 2024929u) + (_20118 * 1423u)) + _20127) * 3.4704455975642645171319600194693e-10f;
	                _33360 = true;
	                break;
	            }
	            case 224u:
	            {
	                uint _20068 = 144673u + (_12091 % 1427u);
	                uint _20069 = _20068 / 2u;
	                uint _20076;
	                if ((_20068 & 1u) != 0u)
	                {
	                    _20076 = g_ScrambledHaltonPermutations.Load(_20069 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _20076 = g_ScrambledHaltonPermutations.Load(_20069 * 4 + 0) & 65535u;
	                }
	                uint _20911 = 144673u + ((_12091 / 1427u) % 1427u);
	                uint _20080 = _20911 / 2u;
	                uint _20087;
	                if ((_20911 & 1u) != 0u)
	                {
	                    _20087 = g_ScrambledHaltonPermutations.Load(_20080 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _20087 = g_ScrambledHaltonPermutations.Load(_20080 * 4 + 0) & 65535u;
	                }
	                uint _20912 = 144673u + ((_12091 / 2036329u) % 1427u);
	                uint _20089 = _20912 / 2u;
	                uint _20096;
	                if ((_20912 & 1u) != 0u)
	                {
	                    _20096 = g_ScrambledHaltonPermutations.Load(_20089 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _20096 = g_ScrambledHaltonPermutations.Load(_20089 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_20076 * 2036329u) + (_20087 * 1427u)) + _20096) * 3.4413435989755214450269704684615e-10f;
	                _33360 = true;
	                break;
	            }
	            case 225u:
	            {
	                uint _20037 = 146100u + (_12091 % 1429u);
	                uint _20038 = _20037 / 2u;
	                uint _20045;
	                if ((_20037 & 1u) != 0u)
	                {
	                    _20045 = g_ScrambledHaltonPermutations.Load(_20038 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _20045 = g_ScrambledHaltonPermutations.Load(_20038 * 4 + 0) & 65535u;
	                }
	                uint _20909 = 146100u + ((_12091 / 1429u) % 1429u);
	                uint _20049 = _20909 / 2u;
	                uint _20056;
	                if ((_20909 & 1u) != 0u)
	                {
	                    _20056 = g_ScrambledHaltonPermutations.Load(_20049 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _20056 = g_ScrambledHaltonPermutations.Load(_20049 * 4 + 0) & 65535u;
	                }
	                uint _20910 = 146100u + ((_12091 / 2042041u) % 1429u);
	                uint _20058 = _20910 / 2u;
	                uint _20065;
	                if ((_20910 & 1u) != 0u)
	                {
	                    _20065 = g_ScrambledHaltonPermutations.Load(_20058 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _20065 = g_ScrambledHaltonPermutations.Load(_20058 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_20045 * 2042041u) + (_20056 * 1429u)) + _20065) * 3.4269143078802244417602196335793e-10f;
	                _33360 = true;
	                break;
	            }
	            case 226u:
	            {
	                uint _20006 = 147529u + (_12091 % 1433u);
	                uint _20007 = _20006 / 2u;
	                uint _20014;
	                if ((_20006 & 1u) != 0u)
	                {
	                    _20014 = g_ScrambledHaltonPermutations.Load(_20007 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _20014 = g_ScrambledHaltonPermutations.Load(_20007 * 4 + 0) & 65535u;
	                }
	                uint _20907 = 147529u + ((_12091 / 1433u) % 1433u);
	                uint _20018 = _20907 / 2u;
	                uint _20025;
	                if ((_20907 & 1u) != 0u)
	                {
	                    _20025 = g_ScrambledHaltonPermutations.Load(_20018 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _20025 = g_ScrambledHaltonPermutations.Load(_20018 * 4 + 0) & 65535u;
	                }
	                uint _20908 = 147529u + ((_12091 / 2053489u) % 1433u);
	                uint _20027 = _20908 / 2u;
	                uint _20034;
	                if ((_20908 & 1u) != 0u)
	                {
	                    _20034 = g_ScrambledHaltonPermutations.Load(_20027 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _20034 = g_ScrambledHaltonPermutations.Load(_20027 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_20014 * 2053489u) + (_20025 * 1433u)) + _20034) * 3.3982971991974864067742601037025e-10f;
	                _33360 = true;
	                break;
	            }
	            case 227u:
	            {
	                uint _19975 = 148962u + (_12091 % 1439u);
	                uint _19976 = _19975 / 2u;
	                uint _19983;
	                if ((_19975 & 1u) != 0u)
	                {
	                    _19983 = g_ScrambledHaltonPermutations.Load(_19976 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _19983 = g_ScrambledHaltonPermutations.Load(_19976 * 4 + 0) & 65535u;
	                }
	                uint _20905 = 148962u + ((_12091 / 1439u) % 1439u);
	                uint _19987 = _20905 / 2u;
	                uint _19994;
	                if ((_20905 & 1u) != 0u)
	                {
	                    _19994 = g_ScrambledHaltonPermutations.Load(_19987 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _19994 = g_ScrambledHaltonPermutations.Load(_19987 * 4 + 0) & 65535u;
	                }
	                uint _20906 = 148962u + ((_12091 / 2070721u) % 1439u);
	                uint _19996 = _20906 / 2u;
	                uint _20003;
	                if ((_20906 & 1u) != 0u)
	                {
	                    _20003 = g_ScrambledHaltonPermutations.Load(_19996 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _20003 = g_ScrambledHaltonPermutations.Load(_19996 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_19983 * 2070721u) + (_19994 * 1439u)) + _20003) * 3.3559660606030661256227176636457e-10f;
	                _33360 = true;
	                break;
	            }
	            case 228u:
	            {
	                uint _19944 = 150401u + (_12091 % 1447u);
	                uint _19945 = _19944 / 2u;
	                uint _19952;
	                if ((_19944 & 1u) != 0u)
	                {
	                    _19952 = g_ScrambledHaltonPermutations.Load(_19945 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _19952 = g_ScrambledHaltonPermutations.Load(_19945 * 4 + 0) & 65535u;
	                }
	                uint _20903 = 150401u + ((_12091 / 1447u) % 1447u);
	                uint _19956 = _20903 / 2u;
	                uint _19963;
	                if ((_20903 & 1u) != 0u)
	                {
	                    _19963 = g_ScrambledHaltonPermutations.Load(_19956 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _19963 = g_ScrambledHaltonPermutations.Load(_19956 * 4 + 0) & 65535u;
	                }
	                uint _20904 = 150401u + ((_12091 / 2093809u) % 1447u);
	                uint _19965 = _20904 / 2u;
	                uint _19972;
	                if ((_20904 & 1u) != 0u)
	                {
	                    _19972 = g_ScrambledHaltonPermutations.Load(_19965 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _19972 = g_ScrambledHaltonPermutations.Load(_19965 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_19952 * 2093809u) + (_19963 * 1447u)) + _19972) * 3.3006111732625242893846007063985e-10f;
	                _33360 = true;
	                break;
	            }
	            case 229u:
	            {
	                uint _19913 = 151848u + (_12091 % 1451u);
	                uint _19914 = _19913 / 2u;
	                uint _19921;
	                if ((_19913 & 1u) != 0u)
	                {
	                    _19921 = g_ScrambledHaltonPermutations.Load(_19914 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _19921 = g_ScrambledHaltonPermutations.Load(_19914 * 4 + 0) & 65535u;
	                }
	                uint _20901 = 151848u + ((_12091 / 1451u) % 1451u);
	                uint _19925 = _20901 / 2u;
	                uint _19932;
	                if ((_20901 & 1u) != 0u)
	                {
	                    _19932 = g_ScrambledHaltonPermutations.Load(_19925 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _19932 = g_ScrambledHaltonPermutations.Load(_19925 * 4 + 0) & 65535u;
	                }
	                uint _20902 = 151848u + ((_12091 / 2105401u) % 1451u);
	                uint _19934 = _20902 / 2u;
	                uint _19941;
	                if ((_20902 & 1u) != 0u)
	                {
	                    _19941 = g_ScrambledHaltonPermutations.Load(_19934 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _19941 = g_ScrambledHaltonPermutations.Load(_19934 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_19921 * 2105401u) + (_19932 * 1451u)) + _19941) * 3.2733896149217400761699536815286e-10f;
	                _33360 = true;
	                break;
	            }
	            case 230u:
	            {
	                uint _19882 = 153299u + (_12091 % 1453u);
	                uint _19883 = _19882 / 2u;
	                uint _19890;
	                if ((_19882 & 1u) != 0u)
	                {
	                    _19890 = g_ScrambledHaltonPermutations.Load(_19883 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _19890 = g_ScrambledHaltonPermutations.Load(_19883 * 4 + 0) & 65535u;
	                }
	                uint _20899 = 153299u + ((_12091 / 1453u) % 1453u);
	                uint _19894 = _20899 / 2u;
	                uint _19901;
	                if ((_20899 & 1u) != 0u)
	                {
	                    _19901 = g_ScrambledHaltonPermutations.Load(_19894 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _19901 = g_ScrambledHaltonPermutations.Load(_19894 * 4 + 0) & 65535u;
	                }
	                uint _20900 = 153299u + ((_12091 / 2111209u) % 1453u);
	                uint _19903 = _20900 / 2u;
	                uint _19910;
	                if ((_20900 & 1u) != 0u)
	                {
	                    _19910 = g_ScrambledHaltonPermutations.Load(_19903 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _19910 = g_ScrambledHaltonPermutations.Load(_19903 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_19890 * 2111209u) + (_19901 * 1453u)) + _19910) * 3.2598912458325912666623480618e-10f;
	                _33360 = true;
	                break;
	            }
	            case 231u:
	            {
	                uint _19850 = 154752u + (_12091 % 1459u);
	                uint _19851 = _19850 / 2u;
	                uint _19859;
	                if ((_19850 & 1u) != 0u)
	                {
	                    _19859 = g_ScrambledHaltonPermutations.Load(_19851 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _19859 = g_ScrambledHaltonPermutations.Load(_19851 * 4 + 0) & 65535u;
	                }
	                uint _20897 = 154752u + ((_12091 / 1459u) % 1459u);
	                uint _19863 = _20897 / 2u;
	                uint _19870;
	                if ((_20897 & 1u) != 0u)
	                {
	                    _19870 = g_ScrambledHaltonPermutations.Load(_19863 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _19870 = g_ScrambledHaltonPermutations.Load(_19863 * 4 + 0) & 65535u;
	                }
	                uint _20898 = 154752u + ((_12091 / 2128681u) % 1459u);
	                uint _19872 = _20898 / 2u;
	                uint _19879;
	                if ((_20898 & 1u) != 0u)
	                {
	                    _19879 = g_ScrambledHaltonPermutations.Load(_19872 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _19879 = g_ScrambledHaltonPermutations.Load(_19872 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_19859 * 2128681u) + (_19870 * 1459u)) + _19879) * 3.2198382848847018067317549139261e-10f;
	                _33360 = true;
	                break;
	            }
	            case 232u:
	            {
	                uint _19819 = 156211u + (_12091 % 1471u);
	                uint _19820 = _19819 / 2u;
	                uint _19827;
	                if ((_19819 & 1u) != 0u)
	                {
	                    _19827 = g_ScrambledHaltonPermutations.Load(_19820 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _19827 = g_ScrambledHaltonPermutations.Load(_19820 * 4 + 0) & 65535u;
	                }
	                uint _20895 = 156211u + ((_12091 / 1471u) % 1471u);
	                uint _19831 = _20895 / 2u;
	                uint _19838;
	                if ((_20895 & 1u) != 0u)
	                {
	                    _19838 = g_ScrambledHaltonPermutations.Load(_19831 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _19838 = g_ScrambledHaltonPermutations.Load(_19831 * 4 + 0) & 65535u;
	                }
	                uint _20896 = 156211u + ((_12091 / 2163841u) % 1471u);
	                uint _19840 = _20896 / 2u;
	                uint _19847;
	                if ((_20896 & 1u) != 0u)
	                {
	                    _19847 = g_ScrambledHaltonPermutations.Load(_19840 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _19847 = g_ScrambledHaltonPermutations.Load(_19840 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_19827 * 2163841u) + (_19838 * 1471u)) + _19847) * 3.1416799717298715677316067740321e-10f;
	                _33360 = true;
	                break;
	            }
	            case 233u:
	            {
	                uint _19788 = 157682u + (_12091 % 1481u);
	                uint _19789 = _19788 / 2u;
	                uint _19796;
	                if ((_19788 & 1u) != 0u)
	                {
	                    _19796 = g_ScrambledHaltonPermutations.Load(_19789 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _19796 = g_ScrambledHaltonPermutations.Load(_19789 * 4 + 0) & 65535u;
	                }
	                uint _20893 = 157682u + ((_12091 / 1481u) % 1481u);
	                uint _19800 = _20893 / 2u;
	                uint _19807;
	                if ((_20893 & 1u) != 0u)
	                {
	                    _19807 = g_ScrambledHaltonPermutations.Load(_19800 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _19807 = g_ScrambledHaltonPermutations.Load(_19800 * 4 + 0) & 65535u;
	                }
	                uint _20894 = 157682u + ((_12091 / 2193361u) % 1481u);
	                uint _19809 = _20894 / 2u;
	                uint _19816;
	                if ((_20894 & 1u) != 0u)
	                {
	                    _19816 = g_ScrambledHaltonPermutations.Load(_19809 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _19816 = g_ScrambledHaltonPermutations.Load(_19809 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_19796 * 2193361u) + (_19807 * 1481u)) + _19816) * 3.0784688687113259675243170931935e-10f;
	                _33360 = true;
	                break;
	            }
	            case 234u:
	            {
	                uint _19757 = 159163u + (_12091 % 1483u);
	                uint _19758 = _19757 / 2u;
	                uint _19765;
	                if ((_19757 & 1u) != 0u)
	                {
	                    _19765 = g_ScrambledHaltonPermutations.Load(_19758 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _19765 = g_ScrambledHaltonPermutations.Load(_19758 * 4 + 0) & 65535u;
	                }
	                uint _20891 = 159163u + ((_12091 / 1483u) % 1483u);
	                uint _19769 = _20891 / 2u;
	                uint _19776;
	                if ((_20891 & 1u) != 0u)
	                {
	                    _19776 = g_ScrambledHaltonPermutations.Load(_19769 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _19776 = g_ScrambledHaltonPermutations.Load(_19769 * 4 + 0) & 65535u;
	                }
	                uint _20892 = 159163u + ((_12091 / 2199289u) % 1483u);
	                uint _19778 = _20892 / 2u;
	                uint _19785;
	                if ((_20892 & 1u) != 0u)
	                {
	                    _19785 = g_ScrambledHaltonPermutations.Load(_19778 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _19785 = g_ScrambledHaltonPermutations.Load(_19778 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_19765 * 2199289u) + (_19776 * 1483u)) + _19785) * 3.066030762610694182512816041708e-10f;
	                _33360 = true;
	                break;
	            }
	            case 235u:
	            {
	                uint _19726 = 160646u + (_12091 % 1487u);
	                uint _19727 = _19726 / 2u;
	                uint _19734;
	                if ((_19726 & 1u) != 0u)
	                {
	                    _19734 = g_ScrambledHaltonPermutations.Load(_19727 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _19734 = g_ScrambledHaltonPermutations.Load(_19727 * 4 + 0) & 65535u;
	                }
	                uint _20889 = 160646u + ((_12091 / 1487u) % 1487u);
	                uint _19738 = _20889 / 2u;
	                uint _19745;
	                if ((_20889 & 1u) != 0u)
	                {
	                    _19745 = g_ScrambledHaltonPermutations.Load(_19738 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _19745 = g_ScrambledHaltonPermutations.Load(_19738 * 4 + 0) & 65535u;
	                }
	                uint _20890 = 160646u + ((_12091 / 2211169u) % 1487u);
	                uint _19747 = _20890 / 2u;
	                uint _19754;
	                if ((_20890 & 1u) != 0u)
	                {
	                    _19754 = g_ScrambledHaltonPermutations.Load(_19747 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _19754 = g_ScrambledHaltonPermutations.Load(_19747 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_19734 * 2211169u) + (_19745 * 1487u)) + _19754) * 3.0413546681096192969562252983451e-10f;
	                _33360 = true;
	                break;
	            }
	            case 236u:
	            {
	                uint _19695 = 162133u + (_12091 % 1489u);
	                uint _19696 = _19695 / 2u;
	                uint _19703;
	                if ((_19695 & 1u) != 0u)
	                {
	                    _19703 = g_ScrambledHaltonPermutations.Load(_19696 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _19703 = g_ScrambledHaltonPermutations.Load(_19696 * 4 + 0) & 65535u;
	                }
	                uint _20887 = 162133u + ((_12091 / 1489u) % 1489u);
	                uint _19707 = _20887 / 2u;
	                uint _19714;
	                if ((_20887 & 1u) != 0u)
	                {
	                    _19714 = g_ScrambledHaltonPermutations.Load(_19707 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _19714 = g_ScrambledHaltonPermutations.Load(_19707 * 4 + 0) & 65535u;
	                }
	                uint _20888 = 162133u + ((_12091 / 2217121u) % 1489u);
	                uint _19716 = _20888 / 2u;
	                uint _19723;
	                if ((_20888 & 1u) != 0u)
	                {
	                    _19723 = g_ScrambledHaltonPermutations.Load(_19716 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _19723 = g_ScrambledHaltonPermutations.Load(_19716 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_19703 * 2217121u) + (_19714 * 1489u)) + _19723) * 3.029115847041907727543730288744e-10f;
	                _33360 = true;
	                break;
	            }
	            case 237u:
	            {
	                uint _19663 = 163622u + (_12091 % 1493u);
	                uint _19664 = _19663 / 2u;
	                uint _19671;
	                if ((_19663 & 1u) != 0u)
	                {
	                    _19671 = g_ScrambledHaltonPermutations.Load(_19664 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _19671 = g_ScrambledHaltonPermutations.Load(_19664 * 4 + 0) & 65535u;
	                }
	                uint _20885 = 163622u + ((_12091 / 1493u) % 1493u);
	                uint _19676 = _20885 / 2u;
	                uint _19683;
	                if ((_20885 & 1u) != 0u)
	                {
	                    _19683 = g_ScrambledHaltonPermutations.Load(_19676 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _19683 = g_ScrambledHaltonPermutations.Load(_19676 * 4 + 0) & 65535u;
	                }
	                uint _20886 = 163622u + ((_12091 / 2229049u) % 1493u);
	                uint _19685 = _20886 / 2u;
	                uint _19692;
	                if ((_20886 & 1u) != 0u)
	                {
	                    _19692 = g_ScrambledHaltonPermutations.Load(_19685 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _19692 = g_ScrambledHaltonPermutations.Load(_19685 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_19671 * 2229049u) + (_19683 * 1493u)) + _19692) * 3.0048344368260870851372601464391e-10f;
	                _33360 = true;
	                break;
	            }
	            case 238u:
	            {
	                uint _19632 = 165115u + (_12091 % 1499u);
	                uint _19633 = _19632 / 2u;
	                uint _19640;
	                if ((_19632 & 1u) != 0u)
	                {
	                    _19640 = g_ScrambledHaltonPermutations.Load(_19633 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _19640 = g_ScrambledHaltonPermutations.Load(_19633 * 4 + 0) & 65535u;
	                }
	                uint _20883 = 165115u + ((_12091 / 1499u) % 1499u);
	                uint _19644 = _20883 / 2u;
	                uint _19651;
	                if ((_20883 & 1u) != 0u)
	                {
	                    _19651 = g_ScrambledHaltonPermutations.Load(_19644 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _19651 = g_ScrambledHaltonPermutations.Load(_19644 * 4 + 0) & 65535u;
	                }
	                uint _20884 = 165115u + ((_12091 / 2247001u) % 1499u);
	                uint _19653 = _20884 / 2u;
	                uint _19660;
	                if ((_20884 & 1u) != 0u)
	                {
	                    _19660 = g_ScrambledHaltonPermutations.Load(_19653 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _19660 = g_ScrambledHaltonPermutations.Load(_19653 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_19640 * 2247001u) + (_19651 * 1499u)) + _19660) * 2.968896517518970767923747189343e-10f;
	                _33360 = true;
	                break;
	            }
	            case 239u:
	            {
	                uint _19601 = 166614u + (_12091 % 1511u);
	                uint _19602 = _19601 / 2u;
	                uint _19609;
	                if ((_19601 & 1u) != 0u)
	                {
	                    _19609 = g_ScrambledHaltonPermutations.Load(_19602 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _19609 = g_ScrambledHaltonPermutations.Load(_19602 * 4 + 0) & 65535u;
	                }
	                uint _20881 = 166614u + ((_12091 / 1511u) % 1511u);
	                uint _19613 = _20881 / 2u;
	                uint _19620;
	                if ((_20881 & 1u) != 0u)
	                {
	                    _19620 = g_ScrambledHaltonPermutations.Load(_19613 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _19620 = g_ScrambledHaltonPermutations.Load(_19613 * 4 + 0) & 65535u;
	                }
	                uint _20882 = 166614u + ((_12091 / 2283121u) % 1511u);
	                uint _19622 = _20882 / 2u;
	                uint _19629;
	                if ((_20882 & 1u) != 0u)
	                {
	                    _19629 = g_ScrambledHaltonPermutations.Load(_19622 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _19629 = g_ScrambledHaltonPermutations.Load(_19622 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_19609 * 2283121u) + (_19620 * 1511u)) + _19629) * 2.8987218181342200296057853847742e-10f;
	                _33360 = true;
	                break;
	            }
	            case 240u:
	            {
	                uint _19570 = 168125u + (_12091 % 1523u);
	                uint _19571 = _19570 / 2u;
	                uint _19578;
	                if ((_19570 & 1u) != 0u)
	                {
	                    _19578 = g_ScrambledHaltonPermutations.Load(_19571 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _19578 = g_ScrambledHaltonPermutations.Load(_19571 * 4 + 0) & 65535u;
	                }
	                uint _20879 = 168125u + ((_12091 / 1523u) % 1523u);
	                uint _19582 = _20879 / 2u;
	                uint _19589;
	                if ((_20879 & 1u) != 0u)
	                {
	                    _19589 = g_ScrambledHaltonPermutations.Load(_19582 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _19589 = g_ScrambledHaltonPermutations.Load(_19582 * 4 + 0) & 65535u;
	                }
	                uint _20880 = 168125u + ((_12091 / 2319529u) % 1523u);
	                uint _19591 = _20880 / 2u;
	                uint _19598;
	                if ((_20880 & 1u) != 0u)
	                {
	                    _19598 = g_ScrambledHaltonPermutations.Load(_19591 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _19598 = g_ScrambledHaltonPermutations.Load(_19591 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_19578 * 2319529u) + (_19589 * 1523u)) + _19598) * 2.8307417521133970694791059941053e-10f;
	                _33360 = true;
	                break;
	            }
	            case 241u:
	            {
	                uint _19533 = 169648u + (_12091 % 1531u);
	                uint _19534 = _19533 / 2u;
	                uint _19541;
	                if ((_19533 & 1u) != 0u)
	                {
	                    _19541 = g_ScrambledHaltonPermutations.Load(_19534 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _19541 = g_ScrambledHaltonPermutations.Load(_19534 * 4 + 0) & 65535u;
	                }
	                uint _20877 = 169648u + ((_12091 / 1531u) % 1531u);
	                uint _19551 = _20877 / 2u;
	                uint _19558;
	                if ((_20877 & 1u) != 0u)
	                {
	                    _19558 = g_ScrambledHaltonPermutations.Load(_19551 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _19558 = g_ScrambledHaltonPermutations.Load(_19551 * 4 + 0) & 65535u;
	                }
	                uint _20878 = 169648u + ((_12091 / 2343961u) % 1531u);
	                uint _19560 = _20878 / 2u;
	                uint _19567;
	                if ((_20878 & 1u) != 0u)
	                {
	                    _19567 = g_ScrambledHaltonPermutations.Load(_19560 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _19567 = g_ScrambledHaltonPermutations.Load(_19560 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_19541 * 2343961u) + (_19558 * 1531u)) + _19567) * 2.7865981744312762202753219753504e-10f;
	                _33360 = true;
	                break;
	            }
	            case 242u:
	            {
	                uint _19502 = 171179u + (_12091 % 1543u);
	                uint _19503 = _19502 / 2u;
	                uint _19510;
	                if ((_19502 & 1u) != 0u)
	                {
	                    _19510 = g_ScrambledHaltonPermutations.Load(_19503 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _19510 = g_ScrambledHaltonPermutations.Load(_19503 * 4 + 0) & 65535u;
	                }
	                uint _20875 = 171179u + ((_12091 / 1543u) % 1543u);
	                uint _19514 = _20875 / 2u;
	                uint _19521;
	                if ((_20875 & 1u) != 0u)
	                {
	                    _19521 = g_ScrambledHaltonPermutations.Load(_19514 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _19521 = g_ScrambledHaltonPermutations.Load(_19514 * 4 + 0) & 65535u;
	                }
	                uint _20876 = 171179u + ((_12091 / 2380849u) % 1543u);
	                uint _19523 = _20876 / 2u;
	                uint _19530;
	                if ((_20876 & 1u) != 0u)
	                {
	                    _19530 = g_ScrambledHaltonPermutations.Load(_19523 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _19530 = g_ScrambledHaltonPermutations.Load(_19523 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_19510 * 2380849u) + (_19521 * 1543u)) + _19530) * 2.7220881104739191869157366454601e-10f;
	                _33360 = true;
	                break;
	            }
	            case 243u:
	            {
	                uint _19471 = 172722u + (_12091 % 1549u);
	                uint _19472 = _19471 / 2u;
	                uint _19479;
	                if ((_19471 & 1u) != 0u)
	                {
	                    _19479 = g_ScrambledHaltonPermutations.Load(_19472 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _19479 = g_ScrambledHaltonPermutations.Load(_19472 * 4 + 0) & 65535u;
	                }
	                uint _20873 = 172722u + ((_12091 / 1549u) % 1549u);
	                uint _19483 = _20873 / 2u;
	                uint _19490;
	                if ((_20873 & 1u) != 0u)
	                {
	                    _19490 = g_ScrambledHaltonPermutations.Load(_19483 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _19490 = g_ScrambledHaltonPermutations.Load(_19483 * 4 + 0) & 65535u;
	                }
	                uint _20874 = 172722u + ((_12091 / 2399401u) % 1549u);
	                uint _19492 = _20874 / 2u;
	                uint _19499;
	                if ((_20874 & 1u) != 0u)
	                {
	                    _19499 = g_ScrambledHaltonPermutations.Load(_19492 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _19499 = g_ScrambledHaltonPermutations.Load(_19492 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_19479 * 2399401u) + (_19490 * 1549u)) + _19499) * 2.6905785932562764628528384491801e-10f;
	                _33360 = true;
	                break;
	            }
	            case 244u:
	            {
	                uint _19440 = 174271u + (_12091 % 1553u);
	                uint _19441 = _19440 / 2u;
	                uint _19448;
	                if ((_19440 & 1u) != 0u)
	                {
	                    _19448 = g_ScrambledHaltonPermutations.Load(_19441 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _19448 = g_ScrambledHaltonPermutations.Load(_19441 * 4 + 0) & 65535u;
	                }
	                uint _20871 = 174271u + ((_12091 / 1553u) % 1553u);
	                uint _19452 = _20871 / 2u;
	                uint _19459;
	                if ((_20871 & 1u) != 0u)
	                {
	                    _19459 = g_ScrambledHaltonPermutations.Load(_19452 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _19459 = g_ScrambledHaltonPermutations.Load(_19452 * 4 + 0) & 65535u;
	                }
	                uint _20872 = 174271u + ((_12091 / 2411809u) % 1553u);
	                uint _19461 = _20872 / 2u;
	                uint _19468;
	                if ((_20872 & 1u) != 0u)
	                {
	                    _19468 = g_ScrambledHaltonPermutations.Load(_19461 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _19468 = g_ScrambledHaltonPermutations.Load(_19461 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_19448 * 2411809u) + (_19459 * 1553u)) + _19468) * 2.6698421251580839452799409627914e-10f;
	                _33360 = true;
	                break;
	            }
	            case 245u:
	            {
	                uint _19409 = 175824u + (_12091 % 1559u);
	                uint _19410 = _19409 / 2u;
	                uint _19417;
	                if ((_19409 & 1u) != 0u)
	                {
	                    _19417 = g_ScrambledHaltonPermutations.Load(_19410 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _19417 = g_ScrambledHaltonPermutations.Load(_19410 * 4 + 0) & 65535u;
	                }
	                uint _20869 = 175824u + ((_12091 / 1559u) % 1559u);
	                uint _19421 = _20869 / 2u;
	                uint _19428;
	                if ((_20869 & 1u) != 0u)
	                {
	                    _19428 = g_ScrambledHaltonPermutations.Load(_19421 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _19428 = g_ScrambledHaltonPermutations.Load(_19421 * 4 + 0) & 65535u;
	                }
	                uint _20870 = 175824u + ((_12091 / 2430481u) % 1559u);
	                uint _19430 = _20870 / 2u;
	                uint _19437;
	                if ((_20870 & 1u) != 0u)
	                {
	                    _19437 = g_ScrambledHaltonPermutations.Load(_19430 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _19437 = g_ScrambledHaltonPermutations.Load(_19430 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_19417 * 2430481u) + (_19428 * 1559u)) + _19437) * 2.6391350216314890531066339462996e-10f;
	                _33360 = true;
	                break;
	            }
	            case 246u:
	            {
	                uint _19378 = 177383u + (_12091 % 1567u);
	                uint _19379 = _19378 / 2u;
	                uint _19386;
	                if ((_19378 & 1u) != 0u)
	                {
	                    _19386 = g_ScrambledHaltonPermutations.Load(_19379 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _19386 = g_ScrambledHaltonPermutations.Load(_19379 * 4 + 0) & 65535u;
	                }
	                uint _20867 = 177383u + ((_12091 / 1567u) % 1567u);
	                uint _19390 = _20867 / 2u;
	                uint _19397;
	                if ((_20867 & 1u) != 0u)
	                {
	                    _19397 = g_ScrambledHaltonPermutations.Load(_19390 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _19397 = g_ScrambledHaltonPermutations.Load(_19390 * 4 + 0) & 65535u;
	                }
	                uint _20868 = 177383u + ((_12091 / 2455489u) % 1567u);
	                uint _19399 = _20868 / 2u;
	                uint _19406;
	                if ((_20868 & 1u) != 0u)
	                {
	                    _19406 = g_ScrambledHaltonPermutations.Load(_19399 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _19406 = g_ScrambledHaltonPermutations.Load(_19399 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_19386 * 2455489u) + (_19397 * 1567u)) + _19406) * 2.5989202456777604766102740541101e-10f;
	                _33360 = true;
	                break;
	            }
	            case 247u:
	            {
	                uint _19347 = 178950u + (_12091 % 1571u);
	                uint _19348 = _19347 / 2u;
	                uint _19355;
	                if ((_19347 & 1u) != 0u)
	                {
	                    _19355 = g_ScrambledHaltonPermutations.Load(_19348 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _19355 = g_ScrambledHaltonPermutations.Load(_19348 * 4 + 0) & 65535u;
	                }
	                uint _20865 = 178950u + ((_12091 / 1571u) % 1571u);
	                uint _19359 = _20865 / 2u;
	                uint _19366;
	                if ((_20865 & 1u) != 0u)
	                {
	                    _19366 = g_ScrambledHaltonPermutations.Load(_19359 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _19366 = g_ScrambledHaltonPermutations.Load(_19359 * 4 + 0) & 65535u;
	                }
	                uint _20866 = 178950u + ((_12091 / 2468041u) % 1571u);
	                uint _19368 = _20866 / 2u;
	                uint _19375;
	                if ((_20866 & 1u) != 0u)
	                {
	                    _19375 = g_ScrambledHaltonPermutations.Load(_19368 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _19375 = g_ScrambledHaltonPermutations.Load(_19368 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_19355 * 2468041u) + (_19366 * 1571u)) + _19375) * 2.5791191404778146534226834774017e-10f;
	                _33360 = true;
	                break;
	            }
	            case 248u:
	            {
	                uint _19316 = 180521u + (_12091 % 1579u);
	                uint _19317 = _19316 / 2u;
	                uint _19324;
	                if ((_19316 & 1u) != 0u)
	                {
	                    _19324 = g_ScrambledHaltonPermutations.Load(_19317 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _19324 = g_ScrambledHaltonPermutations.Load(_19317 * 4 + 0) & 65535u;
	                }
	                uint _20863 = 180521u + ((_12091 / 1579u) % 1579u);
	                uint _19328 = _20863 / 2u;
	                uint _19335;
	                if ((_20863 & 1u) != 0u)
	                {
	                    _19335 = g_ScrambledHaltonPermutations.Load(_19328 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _19335 = g_ScrambledHaltonPermutations.Load(_19328 * 4 + 0) & 65535u;
	                }
	                uint _20864 = 180521u + ((_12091 / 2493241u) % 1579u);
	                uint _19337 = _20864 / 2u;
	                uint _19344;
	                if ((_20864 & 1u) != 0u)
	                {
	                    _19344 = g_ScrambledHaltonPermutations.Load(_19337 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _19344 = g_ScrambledHaltonPermutations.Load(_19337 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_19324 * 2493241u) + (_19335 * 1579u)) + _19344) * 2.54011589539970827900106087327e-10f;
	                _33360 = true;
	                break;
	            }
	            case 249u:
	            {
	                uint _19285 = 182100u + (_12091 % 1583u);
	                uint _19286 = _19285 / 2u;
	                uint _19293;
	                if ((_19285 & 1u) != 0u)
	                {
	                    _19293 = g_ScrambledHaltonPermutations.Load(_19286 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _19293 = g_ScrambledHaltonPermutations.Load(_19286 * 4 + 0) & 65535u;
	                }
	                uint _20861 = 182100u + ((_12091 / 1583u) % 1583u);
	                uint _19297 = _20861 / 2u;
	                uint _19304;
	                if ((_20861 & 1u) != 0u)
	                {
	                    _19304 = g_ScrambledHaltonPermutations.Load(_19297 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _19304 = g_ScrambledHaltonPermutations.Load(_19297 * 4 + 0) & 65535u;
	                }
	                uint _20862 = 182100u + ((_12091 / 2505889u) % 1583u);
	                uint _19306 = _20862 / 2u;
	                uint _19313;
	                if ((_20862 & 1u) != 0u)
	                {
	                    _19313 = g_ScrambledHaltonPermutations.Load(_19306 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _19313 = g_ScrambledHaltonPermutations.Load(_19306 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_19293 * 2505889u) + (_19304 * 1583u)) + _19313) * 2.5209090370736930708517320454121e-10f;
	                _33360 = true;
	                break;
	            }
	            case 250u:
	            {
	                uint _19254 = 183683u + (_12091 % 1597u);
	                uint _19255 = _19254 / 2u;
	                uint _19262;
	                if ((_19254 & 1u) != 0u)
	                {
	                    _19262 = g_ScrambledHaltonPermutations.Load(_19255 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _19262 = g_ScrambledHaltonPermutations.Load(_19255 * 4 + 0) & 65535u;
	                }
	                uint _20859 = 183683u + ((_12091 / 1597u) % 1597u);
	                uint _19266 = _20859 / 2u;
	                uint _19273;
	                if ((_20859 & 1u) != 0u)
	                {
	                    _19273 = g_ScrambledHaltonPermutations.Load(_19266 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _19273 = g_ScrambledHaltonPermutations.Load(_19266 * 4 + 0) & 65535u;
	                }
	                uint _20860 = 183683u + ((_12091 / 2550409u) % 1597u);
	                uint _19275 = _20860 / 2u;
	                uint _19282;
	                if ((_20860 & 1u) != 0u)
	                {
	                    _19282 = g_ScrambledHaltonPermutations.Load(_19275 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _19282 = g_ScrambledHaltonPermutations.Load(_19275 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_19262 * 2550409u) + (_19273 * 1597u)) + _19282) * 2.4551904953540315545978955924511e-10f;
	                _33360 = true;
	                break;
	            }
	            case 251u:
	            {
	                uint _19223 = 185280u + (_12091 % 1601u);
	                uint _19224 = _19223 / 2u;
	                uint _19231;
	                if ((_19223 & 1u) != 0u)
	                {
	                    _19231 = g_ScrambledHaltonPermutations.Load(_19224 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _19231 = g_ScrambledHaltonPermutations.Load(_19224 * 4 + 0) & 65535u;
	                }
	                uint _20857 = 185280u + ((_12091 / 1601u) % 1601u);
	                uint _19235 = _20857 / 2u;
	                uint _19242;
	                if ((_20857 & 1u) != 0u)
	                {
	                    _19242 = g_ScrambledHaltonPermutations.Load(_19235 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _19242 = g_ScrambledHaltonPermutations.Load(_19235 * 4 + 0) & 65535u;
	                }
	                uint _20858 = 185280u + ((_12091 / 2563201u) % 1601u);
	                uint _19244 = _20858 / 2u;
	                uint _19251;
	                if ((_20858 & 1u) != 0u)
	                {
	                    _19251 = g_ScrambledHaltonPermutations.Load(_19244 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _19251 = g_ScrambledHaltonPermutations.Load(_19244 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_19231 * 2563201u) + (_19242 * 1601u)) + _19251) * 2.4368340678648792163585312664509e-10f;
	                _33360 = true;
	                break;
	            }
	            case 252u:
	            {
	                uint _19192 = 186881u + (_12091 % 1607u);
	                uint _19193 = _19192 / 2u;
	                uint _19200;
	                if ((_19192 & 1u) != 0u)
	                {
	                    _19200 = g_ScrambledHaltonPermutations.Load(_19193 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _19200 = g_ScrambledHaltonPermutations.Load(_19193 * 4 + 0) & 65535u;
	                }
	                uint _20855 = 186881u + ((_12091 / 1607u) % 1607u);
	                uint _19204 = _20855 / 2u;
	                uint _19211;
	                if ((_20855 & 1u) != 0u)
	                {
	                    _19211 = g_ScrambledHaltonPermutations.Load(_19204 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _19211 = g_ScrambledHaltonPermutations.Load(_19204 * 4 + 0) & 65535u;
	                }
	                uint _20856 = 186881u + ((_12091 / 2582449u) % 1607u);
	                uint _19213 = _20856 / 2u;
	                uint _19220;
	                if ((_20856 & 1u) != 0u)
	                {
	                    _19220 = g_ScrambledHaltonPermutations.Load(_19213 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _19220 = g_ScrambledHaltonPermutations.Load(_19213 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_19200 * 2582449u) + (_19211 * 1607u)) + _19220) * 2.4096408202112229446356650441885e-10f;
	                _33360 = true;
	                break;
	            }
	            case 253u:
	            {
	                uint _19161 = 188488u + (_12091 % 1609u);
	                uint _19162 = _19161 / 2u;
	                uint _19169;
	                if ((_19161 & 1u) != 0u)
	                {
	                    _19169 = g_ScrambledHaltonPermutations.Load(_19162 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _19169 = g_ScrambledHaltonPermutations.Load(_19162 * 4 + 0) & 65535u;
	                }
	                uint _20853 = 188488u + ((_12091 / 1609u) % 1609u);
	                uint _19173 = _20853 / 2u;
	                uint _19180;
	                if ((_20853 & 1u) != 0u)
	                {
	                    _19180 = g_ScrambledHaltonPermutations.Load(_19173 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _19180 = g_ScrambledHaltonPermutations.Load(_19173 * 4 + 0) & 65535u;
	                }
	                uint _20854 = 188488u + ((_12091 / 2588881u) % 1609u);
	                uint _19182 = _20854 / 2u;
	                uint _19189;
	                if ((_20854 & 1u) != 0u)
	                {
	                    _19189 = g_ScrambledHaltonPermutations.Load(_19182 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _19189 = g_ScrambledHaltonPermutations.Load(_19182 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_19169 * 2588881u) + (_19180 * 1609u)) + _19189) * 2.4006663323916654917411506175995e-10f;
	                _33360 = true;
	                break;
	            }
	            case 254u:
	            {
	                uint _19130 = 190097u + (_12091 % 1613u);
	                uint _19131 = _19130 / 2u;
	                uint _19138;
	                if ((_19130 & 1u) != 0u)
	                {
	                    _19138 = g_ScrambledHaltonPermutations.Load(_19131 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _19138 = g_ScrambledHaltonPermutations.Load(_19131 * 4 + 0) & 65535u;
	                }
	                uint _20851 = 190097u + ((_12091 / 1613u) % 1613u);
	                uint _19142 = _20851 / 2u;
	                uint _19149;
	                if ((_20851 & 1u) != 0u)
	                {
	                    _19149 = g_ScrambledHaltonPermutations.Load(_19142 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _19149 = g_ScrambledHaltonPermutations.Load(_19142 * 4 + 0) & 65535u;
	                }
	                uint _20852 = 190097u + ((_12091 / 2601769u) % 1613u);
	                uint _19151 = _20852 / 2u;
	                uint _19158;
	                if ((_20852 & 1u) != 0u)
	                {
	                    _19158 = g_ScrambledHaltonPermutations.Load(_19151 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _19158 = g_ScrambledHaltonPermutations.Load(_19151 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_19138 * 2601769u) + (_19149 * 1613u)) + _19158) * 2.3828508610712617610261077061296e-10f;
	                _33360 = true;
	                break;
	            }
	            case 255u:
	            {
	                uint _19099 = 191710u + (_12091 % 1619u);
	                uint _19100 = _19099 / 2u;
	                uint _19107;
	                if ((_19099 & 1u) != 0u)
	                {
	                    _19107 = g_ScrambledHaltonPermutations.Load(_19100 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _19107 = g_ScrambledHaltonPermutations.Load(_19100 * 4 + 0) & 65535u;
	                }
	                uint _20849 = 191710u + ((_12091 / 1619u) % 1619u);
	                uint _19111 = _20849 / 2u;
	                uint _19118;
	                if ((_20849 & 1u) != 0u)
	                {
	                    _19118 = g_ScrambledHaltonPermutations.Load(_19111 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _19118 = g_ScrambledHaltonPermutations.Load(_19111 * 4 + 0) & 65535u;
	                }
	                uint _20850 = 191710u + ((_12091 / 2621161u) % 1619u);
	                uint _19120 = _20850 / 2u;
	                uint _19127;
	                if ((_20850 & 1u) != 0u)
	                {
	                    _19127 = g_ScrambledHaltonPermutations.Load(_19120 * 4 + 0) >> uint(16);
	                }
	                else
	                {
	                    _19127 = g_ScrambledHaltonPermutations.Load(_19120 * 4 + 0) & 65535u;
	                }
	                _33359 = float(((_19107 * 2621161u) + (_19118 * 1619u)) + _19127) * 2.3564564188838232894340762868524e-10f;
	                _33360 = true;
	                break;
	            }
	            default:
	            {
	                _33359 = _2;
	                _33360 = false;
	                break;
	            }
	        }
	        if (_33360)
	        {
	            _33363 = _33359;
	            break;
	        }
	        _33363 = 0.0f;
	        break;
	    } while(false);
	    _3159[gl_GlobalInvocationID.xyz] = float4(_19096, _33363, 0.0f, 0.0f);
	}
	
	[numthreads(8, 8, 1)]
	void MainCs(SPIRV_Cross_Input stage_input)
	{
	    gl_GlobalInvocationID = stage_input.gl_GlobalInvocationID;
	    MainCs_inner();
	}
	
	// ---------  SPIRV -> HLSL end  --------- 
	
	
}
