// MGetKV3ClassDefaults = {
//	"m_flMinVolume": 1.000000,
//	"m_nInstancesAtMinVolume": 1,
//	"m_flMaxVolume": 1.000000,
//	"m_nInstancesAtMaxVolume": 1
//}
class CVoiceContainerStaticAdditiveSynth::CGainScalePerInstance
{
	// MPropertyFriendlyName = "Quietest Volume"
	float32 m_flMinVolume;
	// MPropertyFriendlyName = "# Instances Playing Until We Get Louder Than Quietest Volume"
	int32 m_nInstancesAtMinVolume;
	// MPropertyFriendlyName = "Loudest Volume"
	float32 m_flMaxVolume;
	// MPropertyFriendlyName = "# Instances Playing Required To Reach Loudest Volume"
	int32 m_nInstancesAtMaxVolume;
};
