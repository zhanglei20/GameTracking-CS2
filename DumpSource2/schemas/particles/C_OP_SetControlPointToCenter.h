// MGetKV3ClassDefaults (UNKNOWN FOR PARSER)
class C_OP_SetControlPointToCenter : public CParticleFunctionPreEmission
{
	// MPropertyFriendlyName = "control point number to set"
	int32 m_nCP1;
	// MPropertyFriendlyName = "center offset"
	// MVectorIsCoordinate
	Vector m_vecCP1Pos;
	// MPropertyFriendlyName = "use average particle position"
	// MVectorIsCoordinate
	bool m_bUseAvgParticlePos;
	// MPropertyFriendlyName = "set parent"
	ParticleParentSetMode_t m_nSetParent;
};
