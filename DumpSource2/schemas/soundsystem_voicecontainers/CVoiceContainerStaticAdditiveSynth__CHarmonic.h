// MGetKV3ClassDefaults (UNKNOWN FOR PARSER)
class CVoiceContainerStaticAdditiveSynth::CHarmonic
{
	// MPropertyFriendlyName = "Waveform"
	EWaveform m_nWaveform;
	// MPropertyFriendlyName = "Note"
	EMidiNote m_nFundamental;
	// MPropertyFriendlyName = "Octave"
	int32 m_nOctave;
	// MPropertyFriendlyName = "Cents To Detune ( -100:100 )"
	float32 m_flCents;
	// MPropertyFriendlyName = "Phase ( 0 - 1 )"
	float32 m_flPhase;
	// MPropertyFriendlyName = "Envelope (Relative to Tone Envelope)"
	CPiecewiseCurve m_curve;
	CVoiceContainerStaticAdditiveSynth::CGainScalePerInstance m_volumeScaling;
};
