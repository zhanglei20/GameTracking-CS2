class CBeam : public CBaseModelEntity
{
	float32 m_flFrameRate;
	float32 m_flHDRColorScale;
	GameTime_t m_flFireTime;
	float32 m_flDamage;
	uint8 m_nNumBeamEnts;
	CStrongHandle< InfoForResourceTypeIMaterial2 > m_hBaseMaterial;
	CStrongHandle< InfoForResourceTypeIMaterial2 > m_nHaloIndex;
	BeamType_t m_nBeamType;
	uint32 m_nBeamFlags;
	CHandle< CBaseEntity >[10] m_hAttachEntity;
	AttachmentHandle_t[10] m_nAttachIndex;
	float32 m_fWidth;
	float32 m_fEndWidth;
	float32 m_fFadeLength;
	float32 m_fHaloScale;
	float32 m_fAmplitude;
	float32 m_fStartFrame;
	float32 m_fSpeed;
	float32 m_flFrame;
	BeamClipStyle_t m_nClipStyle;
	bool m_bTurnedOff;
	Vector m_vecEndPos;
	CHandle< CBaseEntity > m_hEndEntity;
	int32 m_nDissolveType;
};