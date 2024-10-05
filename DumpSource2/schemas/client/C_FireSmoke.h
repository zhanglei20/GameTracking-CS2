class C_FireSmoke : public C_BaseFire
{
	int32 m_nFlameModelIndex;
	int32 m_nFlameFromAboveModelIndex;
	float32 m_flScaleRegister;
	float32 m_flScaleStart;
	float32 m_flScaleEnd;
	GameTime_t m_flScaleTimeStart;
	GameTime_t m_flScaleTimeEnd;
	float32 m_flChildFlameSpread;
	float32 m_flClipPerc;
	bool m_bClipTested;
	bool m_bFadingOut;
	TimedEvent m_tParticleSpawn;
	CFireOverlay* m_pFireOverlay;
};
