class CTakeDamageInfo
{
	Vector m_vecDamageForce;
	Vector m_vecDamagePosition;
	Vector m_vecReportedPosition;
	Vector m_vecDamageDirection;
	CHandle< C_BaseEntity > m_hInflictor;
	CHandle< C_BaseEntity > m_hAttacker;
	CHandle< C_BaseEntity > m_hAbility;
	float32 m_flDamage;
	float32 m_flTotalledDamage;
	float32 m_flTotalledDamageAbsorbed;
	DamageTypes_t m_bitsDamageType;
	int32 m_iDamageCustom;
	AmmoIndex_t m_iAmmoType;
	float32 m_flOriginalDamage;
	bool m_bShouldBleed;
	bool m_bShouldSpark;
	float32 m_flDamageAbsorbed;
	TakeDamageFlags_t m_nDamageFlags;
	int32 m_nNumObjectsPenetrated;
	float32 m_flFriendlyFireDamageReductionRatio;
	HSCRIPT m_hScriptInstance;
	bool m_bInTakeDamageFlow;
};
