// MNetworkExcludeByName = "m_flexWeight"
// MNetworkExcludeByName = "m_blinktoggle"
// MNetworkIncludeByName = "m_nNextThinkTick"
// MNetworkExcludeByUserGroup = "m_flPoseParameter"
// MNetworkExcludeByUserGroup = "m_flCycle"
// MNetworkExcludeByUserGroup = "overlay_vars"
// MNetworkUserGroupProxy = "CBasePlayerWeapon"
// MNetworkVarNames = "GameTick_t m_nNextPrimaryAttackTick"
// MNetworkVarNames = "float32 m_flNextPrimaryAttackTickRatio"
// MNetworkVarNames = "GameTick_t m_nNextSecondaryAttackTick"
// MNetworkVarNames = "float32 m_flNextSecondaryAttackTickRatio"
// MNetworkVarNames = "int32 m_iClip1"
// MNetworkVarNames = "int32 m_iClip2"
// MNetworkVarNames = "int m_pReserveAmmo"
class CBasePlayerWeapon : public CEconEntity
{
	// MNetworkEnable
	// MNetworkUserGroup = "LocalWeaponExclusive"
	GameTick_t m_nNextPrimaryAttackTick;
	// MNetworkEnable
	// MNetworkUserGroup = "LocalWeaponExclusive"
	float32 m_flNextPrimaryAttackTickRatio;
	// MNetworkEnable
	// MNetworkUserGroup = "LocalWeaponExclusive"
	GameTick_t m_nNextSecondaryAttackTick;
	// MNetworkEnable
	// MNetworkUserGroup = "LocalWeaponExclusive"
	float32 m_flNextSecondaryAttackTickRatio;
	// MNetworkEnable
	// MNetworkSerializer = "minusone"
	// MNetworkPriority = 32
	int32 m_iClip1;
	// MNetworkEnable
	// MNetworkSerializer = "minusone"
	// MNetworkUserGroup = "LocalWeaponExclusive"
	int32 m_iClip2;
	// MNetworkEnable
	// MNetworkUserGroup = "LocalWeaponExclusive"
	int32[2] m_pReserveAmmo;
	CEntityIOOutput m_OnPlayerUse;
};
