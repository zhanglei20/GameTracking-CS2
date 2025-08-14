// MGetKV3ClassDefaults = {
//	"m_flCameraBias": 0.000000,
//	"m_nCPin": -1,
//	"m_flProxyRadius": 1.000000,
//	"m_flInputMin": 0.000000,
//	"m_flInputMax": 1.000000,
//	"m_flInputPixelVisFade": 0.250000,
//	"m_flNoPixelVisibilityFallback": 1.000000,
//	"m_flDistanceInputMin": 0.000000,
//	"m_flDistanceInputMax": 0.000000,
//	"m_flDotInputMin": 0.000000,
//	"m_flDotInputMax": 0.000000,
//	"m_bDotCPAngles": true,
//	"m_bDotCameraAngles": false,
//	"m_flAlphaScaleMin": 0.000000,
//	"m_flAlphaScaleMax": 1.000000,
//	"m_flRadiusScaleMin": 1.000000,
//	"m_flRadiusScaleMax": 1.000000,
//	"m_flRadiusScaleFOVBase": 0.000000,
//	"m_bRightEye": false
//}
class CParticleVisibilityInputs
{
	// MPropertyFriendlyName = "camera depth bias"
	float32 m_flCameraBias;
	// MPropertyFriendlyName = "input control point number"
	int32 m_nCPin;
	// MPropertyFriendlyName = "input proxy radius"
	// MPropertySuppressExpr = "m_nCPin == -1"
	float32 m_flProxyRadius;
	// MPropertyFriendlyName = "input proxy pixel visibility minimum"
	// MPropertySuppressExpr = "m_nCPin == -1"
	float32 m_flInputMin;
	// MPropertyFriendlyName = "input proxy pixel visibility maximum"
	// MPropertySuppressExpr = "m_nCPin == -1"
	float32 m_flInputMax;
	// MPropertyFriendlyName = "input proxy pixel visibility fade out time"
	// MPropertySuppressExpr = "m_nCPin == -1"
	float32 m_flInputPixelVisFade;
	// MPropertyFriendlyName = "input proxy unsupported hardware fallback value"
	// MPropertySuppressExpr = "m_nCPin == -1"
	float32 m_flNoPixelVisibilityFallback;
	// MPropertyFriendlyName = "input distance minimum"
	// MPropertySuppressExpr = "m_nCPin == -1"
	float32 m_flDistanceInputMin;
	// MPropertyFriendlyName = "input distance maximum"
	// MPropertySuppressExpr = "m_nCPin == -1"
	float32 m_flDistanceInputMax;
	// MPropertyFriendlyName = "input dot minimum"
	// MPropertySuppressExpr = "m_nCPin == -1"
	float32 m_flDotInputMin;
	// MPropertyFriendlyName = "input dot maximum"
	// MPropertySuppressExpr = "m_nCPin == -1"
	float32 m_flDotInputMax;
	// MPropertyFriendlyName = "input dot use CP angles"
	// MPropertySuppressExpr = "m_nCPin == -1"
	bool m_bDotCPAngles;
	// MPropertyFriendlyName = "input dot use Camera angles"
	// MPropertySuppressExpr = "m_nCPin == -1"
	bool m_bDotCameraAngles;
	// MPropertyFriendlyName = "output alpha scale minimum"
	// MPropertySuppressExpr = "m_nCPin == -1"
	float32 m_flAlphaScaleMin;
	// MPropertyFriendlyName = "output alpha scale maximum"
	// MPropertySuppressExpr = "m_nCPin == -1"
	float32 m_flAlphaScaleMax;
	// MPropertyFriendlyName = "output radius scale minimum"
	// MPropertySuppressExpr = "m_nCPin == -1"
	float32 m_flRadiusScaleMin;
	// MPropertyFriendlyName = "output radius scale maximum"
	// MPropertySuppressExpr = "m_nCPin == -1"
	float32 m_flRadiusScaleMax;
	// MPropertyFriendlyName = "output radius FOV scale base"
	// MPropertySuppressExpr = "m_nCPin == -1"
	float32 m_flRadiusScaleFOVBase;
	// MPropertyFriendlyName = "vr camera right eye"
	// MParticleAdvancedField
	bool m_bRightEye;
};
