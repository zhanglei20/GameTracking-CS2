// MNetworkVarNames = "CUtlString m_strGraphName"
// MNetworkVarNames = "CUtlString m_strStateBlob"
class CPulseGameBlackboard : public C_BaseEntity
{
	// MNetworkEnable
	CUtlString m_strGraphName;
	// MNetworkEnable
	// MNetworkChangeCallback = "OnStateChanged"
	CUtlString m_strStateBlob;
};
