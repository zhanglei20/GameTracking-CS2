// MGetKV3ClassDefaults (UNKNOWN FOR PARSER)
class C_OP_NoiseEmitter : public CParticleFunctionEmitter
{
	// MPropertyFriendlyName = "emission duration"
	float32 m_flEmissionDuration;
	// MPropertyFriendlyName = "emission start time"
	float32 m_flStartTime;
	// MPropertyFriendlyName = "scale emission to used control points"
	// MParticleMaxVersion = 1
	float32 m_flEmissionScale;
	// MPropertyFriendlyName = "emission count scale control point"
	int32 m_nScaleControlPoint;
	// MPropertyFriendlyName = "emission count scale control point field"
	// MPropertyAttributeChoiceName = "vector_component"
	int32 m_nScaleControlPointField;
	// MPropertyFriendlyName = "world noise scale control point"
	int32 m_nWorldNoisePoint;
	// MPropertyFriendlyName = "absolute value"
	bool m_bAbsVal;
	// MPropertyFriendlyName = "invert absolute value"
	bool m_bAbsValInv;
	// MPropertyFriendlyName = "time coordinate offset"
	float32 m_flOffset;
	// MPropertyFriendlyName = "emission minimum"
	float32 m_flOutputMin;
	// MPropertyFriendlyName = "emission maximum"
	float32 m_flOutputMax;
	// MPropertyFriendlyName = "time noise coordinate scale"
	float32 m_flNoiseScale;
	// MPropertyFriendlyName = "world spatial noise coordinate scale"
	float32 m_flWorldNoiseScale;
	// MPropertyFriendlyName = "spatial coordinate offset"
	// MVectorIsCoordinate
	Vector m_vecOffsetLoc;
	// MPropertyFriendlyName = "world time noise coordinate scale"
	float32 m_flWorldTimeScale;
};
