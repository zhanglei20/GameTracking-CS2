// MGetKV3ClassDefaults (UNKNOWN FOR PARSER)
// MPulseEditorIsControlFlowNode
class CPulseCell_WaitForCursorsWithTagBase : public CPulseCell_BaseYieldingInflow
{
	// MPropertyDescription = "Any extra waiting cursors will be terminated. -1 for infinite cursors."
	int32 m_nCursorsAllowedToWait;
	CPulse_ResumePoint m_WaitComplete;
};
