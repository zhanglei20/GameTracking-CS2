// MGetKV3ClassDefaults = {
//	"m_bUseReference": true,
//	"m_sounds":
//	[
//	],
//	"m_pSounds":
//	[
//	]
//}
// MPropertyFriendlyName = "Sound Array "
// MPropertyDescription = "Reference to list of vsnd files or other containers."
class CSoundContainerReferenceArray
{
	// MPropertyFriendlyName = "Use Vsnd File"
	bool m_bUseReference;
	// MPropertySuppressExpr = "m_bUseReference == 0"
	// MPropertyFriendlyName = "Vsnd File"
	CUtlVector< CStrongHandle< InfoForResourceTypeCVoiceContainerBase > > m_sounds;
	// MPropertySuppressExpr = "m_bUseReference == 1"
	// MPropertyFriendlyName = "Vsnd Container"
	CUtlVector< CVoiceContainerBase* > m_pSounds;
};
