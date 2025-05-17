// MGetKV3ClassDefaults (UNKNOWN FOR PARSER)
class C_OP_RemapSpeedtoCP : public CParticleFunctionPreEmission
{
	// MPropertyFriendlyName = "input control point"
	int32 m_nInControlPointNumber;
	// MPropertyFriendlyName = "output control point"
	int32 m_nOutControlPointNumber;
	// MPropertyFriendlyName = "Output field 0-2 X/Y/Z"
	// MPropertyAttributeChoiceName = "vector_component"
	int32 m_nField;
	// MPropertyFriendlyName = "input minimum"
	float32 m_flInputMin;
	// MPropertyFriendlyName = "input maximum"
	float32 m_flInputMax;
	// MPropertyFriendlyName = "output minimum"
	float32 m_flOutputMin;
	// MPropertyFriendlyName = "output maximum"
	float32 m_flOutputMax;
	// MPropertyFriendlyName = "use delta of velocity instead of constant speed"
	bool m_bUseDeltaV;
};
