// MGetKV3ClassDefaults = {
//	"_class": "CPulseCell_InlineNodeSkipSelector",
//	"m_nEditorNodeID": -1,
//	"m_nFlowNodeID": -1,
//	"m_bAnd": false,
//	"m_PassOutflow":
//	{
//		"m_Outflows":
//		[
//		]
//	},
//	"m_FailOutflow":
//	{
//		"m_SourceOutflowName": "",
//		"m_nDestChunk": -1,
//		"m_nInstruction": -1
//	}
//}
// MPulseCellMethodBindings (UNKNOWN FOR PARSER)
// MPulseFunctionHiddenInTool
class CPulseCell_InlineNodeSkipSelector : public CPulseCell_BaseFlow
{
	PulseDocNodeID_t m_nFlowNodeID;
	bool m_bAnd;
	PulseSelectorOutflowList_t m_PassOutflow;
	CPulse_OutflowConnection m_FailOutflow;
};
