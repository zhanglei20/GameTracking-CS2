// MPropertyArrayElementNameKey = "m_name"
// MVDataAnonymousNode
// MVDataOutlinerNameExpr = "m_name"
// MGetKV3ClassDefaults = {
//	"m_name": "",
//	"m_launchSyncType": "eSndBeatLaunchSyncTypeReset",
//	"m_flSyncPriority": 0.000000,
//	"m_timeSignature":
//	{
//		"nNumerator": 4,
//		"nDenominator": 4
//	},
//	"m_flLength": 4.000000,
//	"m_bLooping": false,
//	"m_launchSyncEventType": "eSndBeatEventTypeBeat",
//	"m_flSyncBeatMult": 1.000000,
//	"m_playEventType": "eSndBeatEventTypeBeat",
//	"m_flPlayBeatMult": 1.000000,
//	"m_keyType": "eSndBeatPatternTypeNone",
//	"m_vecPatternKeys":
//	[
//	],
//	"m_vecPatternFloats":
//	[
//	],
//	"m_vecPatternSndEvts":
//	[
//	],
//	"m_vecPatternMidi":
//	[
//	]
//}
class CSndBeatPattern
{
	// MPropertyFriendlyName = "Pattern Name"
	CUtlString m_name;
	// MPropertyFriendlyName = "Pattern Launch Type"
	SndBeatLaunchSyncType_t m_launchSyncType;
	// MPropertyFriendlyName = "Pattern Launch Priority"
	float32 m_flSyncPriority;
	// MPropertyFriendlyName = "Time Signature"
	SndBeatTimeSignature_t m_timeSignature;
	// MPropertyFriendlyName = "Length (beats)"
	float32 m_flLength;
	// MPropertyFriendlyName = "Looping"
	bool m_bLooping;
	// MPropertyFriendlyName = "Launch Track Event Type"
	// MPropertyGroupName = "Launch Track"
	SndBeatEventType_t m_launchSyncEventType;
	// MPropertySuppressExpr = "m_launchSyncEventType == eSndBeatPatternTypeKeys"
	// MPropertyGroupName = "Launch Track"
	// MPropertyFriendlyName = "Launch Track Beat/Bar/Phrase/Length Multiplier"
	float32 m_flSyncBeatMult;
	// MPropertyGroupName = "Playback Track"
	// MPropertyFriendlyName = "Play Track Event Type"
	SndBeatEventType_t m_playEventType;
	// MPropertyGroupName = "Playback Track"
	// MPropertyFriendlyName = "Play Track Beat/Bar/Phrase/Length Multiplier"
	float32 m_flPlayBeatMult;
	// MPropertyFriendlyName = "Key Type"
	SndBeatKeyType_t m_keyType;
	// MPropertySuppressExpr = "m_keyType != eSndBeatPatternTypeKeys"
	CUtlVector< SndBeatEventKeys_t > m_vecPatternKeys;
	// MPropertySuppressExpr = "m_keyType != eSndBeatPatternTypeKeyedFloats"
	CUtlVector< SndBeatEventKeyedFloats_t > m_vecPatternFloats;
	// MPropertySuppressExpr = "m_keyType != eSndBeatPatternTypeKeyedSndEvts"
	CUtlVector< SndBeatEventKeyedSndEvts_t > m_vecPatternSndEvts;
	// MPropertySuppressExpr = "m_keyType != eSndBeatPatternTypeKeyedMidi"
	CUtlVector< SndBeatEventKeyedMidiNotes_t > m_vecPatternMidi;
};
