// MGetKV3ClassDefaults = {
//	"m_OutflowID": "",
//	"m_Connection":
//	{
//		"m_SourceOutflowName": "",
//		"m_nDestChunk": -1,
//		"m_nInstruction": -1
//	}
//}
class PulseNodeDynamicOutflows_t::DynamicOutflow_t
{
	CGlobalSymbol m_OutflowID;
	// MFgdFromSchemaCompletelySkipField
	CPulse_OutflowConnection m_Connection;
};
