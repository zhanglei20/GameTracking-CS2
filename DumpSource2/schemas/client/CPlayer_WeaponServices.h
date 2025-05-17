// MNetworkVarNames = "CHandle< C_BasePlayerWeapon > m_hMyWeapons"
// MNetworkVarNames = "CHandle< CBasePlayerWeapon> m_hActiveWeapon"
// MNetworkVarNames = "CHandle< CBasePlayerWeapon> m_hLastWeapon"
// MNetworkVarNames = "uint16 m_iAmmo"
class CPlayer_WeaponServices : public CPlayerPawnComponent
{
	// MNetworkEnable
	C_NetworkUtlVectorBase< CHandle< C_BasePlayerWeapon > > m_hMyWeapons;
	// MNetworkEnable
	CHandle< C_BasePlayerWeapon > m_hActiveWeapon;
	// MNetworkEnable
	// MNetworkUserGroup = "LocalPlayerExclusive"
	CHandle< C_BasePlayerWeapon > m_hLastWeapon;
	// MNetworkEnable
	uint16[32] m_iAmmo;
};
