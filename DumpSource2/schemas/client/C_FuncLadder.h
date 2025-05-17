// MNetworkVarNames = "Vector m_vecLadderDir"
// MNetworkVarNames = "Vector m_vecPlayerMountPositionTop"
// MNetworkVarNames = "Vector m_vecPlayerMountPositionBottom"
// MNetworkVarNames = "float m_flAutoRideSpeed"
// MNetworkVarNames = "bool m_bFakeLadder"
class C_FuncLadder : public C_BaseModelEntity
{
	// MNetworkEnable
	// MNetworkEncoder = "coord"
	Vector m_vecLadderDir;
	CUtlVector< CHandle< C_InfoLadderDismount > > m_Dismounts;
	Vector m_vecLocalTop;
	// MNetworkEnable
	// MNetworkEncoder = "coord"
	Vector m_vecPlayerMountPositionTop;
	// MNetworkEnable
	// MNetworkEncoder = "coord"
	Vector m_vecPlayerMountPositionBottom;
	// MNetworkEnable
	float32 m_flAutoRideSpeed;
	bool m_bDisabled;
	// MNetworkEnable
	bool m_bFakeLadder;
	bool m_bHasSlack;
};
