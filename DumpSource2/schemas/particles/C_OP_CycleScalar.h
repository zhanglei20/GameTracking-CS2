// MGetKV3ClassDefaults (UNKNOWN FOR PARSER)
class C_OP_CycleScalar : public CParticleFunctionOperator
{
	// MPropertyFriendlyName = "destination scalar field"
	// MPropertyAttributeChoiceName = "particlefield_scalar"
	ParticleAttributeIndex_t m_nDestField;
	// MPropertyFriendlyName = "Value at start of cycle"
	float32 m_flStartValue;
	// MPropertyFriendlyName = "Value at end of cycle"
	float32 m_flEndValue;
	// MPropertyFriendlyName = "Cycle time"
	float32 m_flCycleTime;
	// MPropertyFriendlyName = "Do not repeat cycle"
	bool m_bDoNotRepeatCycle;
	// MPropertyFriendlyName = "Synchronize particles"
	bool m_bSynchronizeParticles;
	// MPropertyFriendlyName = "Scale Start/End Control Point"
	int32 m_nCPScale;
	// MPropertyFriendlyName = "start scale control point field"
	// MPropertyAttributeChoiceName = "vector_component"
	int32 m_nCPFieldMin;
	// MPropertyFriendlyName = "end scale control point field"
	// MPropertyAttributeChoiceName = "vector_component"
	int32 m_nCPFieldMax;
	// MPropertyFriendlyName = "set value method"
	ParticleSetMethod_t m_nSetMethod;
};
