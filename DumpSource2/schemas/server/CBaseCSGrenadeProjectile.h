class CBaseCSGrenadeProjectile : public CBaseGrenade
{
	VectorWS m_vInitialPosition;
	Vector m_vInitialVelocity;
	int32 m_nBounces;
	CStrongHandle< InfoForResourceTypeIParticleSystemDefinition > m_nExplodeEffectIndex;
	int32 m_nExplodeEffectTickBegin;
	VectorWS m_vecExplodeEffectOrigin;
	GameTime_t m_flSpawnTime;
	uint8 m_unOGSExtraFlags;
	bool m_bDetonationRecorded;
	uint16 m_nItemIndex;
	VectorWS m_vecOriginalSpawnLocation;
	GameTime_t m_flLastBounceSoundTime;
	RotationVector m_vecGrenadeSpin;
	Vector m_vecLastHitSurfaceNormal;
	int32 m_nTicksAtZeroVelocity;
	bool m_bHasEverHitEnemy;
};
