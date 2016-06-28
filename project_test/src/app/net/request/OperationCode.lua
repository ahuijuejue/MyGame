OperationCode=
	{
	VersionProcess = 10000,
	LoginProcess = 10001,
	SelectZoneProcess = 10002,
	ShowMainFrameProcess = 10003,
	OpenShopProcess = 10004,
	BuyShopGoodsProcess = 10005,
	HandRefreshShopProcess = 10006,
	DianJinRequestProcess = 10007,
	DianJinStartProcess = 10008,
	BuyPowerRequestProcess = 10009,
	BuyPowerStartProcess = 10010,
	MaillGetListProcess = 10011,
	MailReadProcess = 10012,
	GetServerListProcess = 10013,
	OpenBeiBaoProcess = 10014,
	OpenHeroListProcess = 10015,
	OpenSkillFrameProcess = 10016,
	UpHeroSkillLevelProcess = 10017,
	XiangQianHeroNameChipProcess = 10018,
	JieSuoHeroNameProcess = 10019,
	JuexingRongHeBaoshiProcess = 10020,
	JueXingHeroProcess = 10021,
	OpenJueXingFrameProcess = 10022,
	UseYaoShuiProcess = 10023,
	OpenEquipFrameProcess = 10024,
	QiangHuaEquipProcess = 10025,
	JinjieEquipProcess = 10026,
	BeginUseEquipProcess = 10027,
	ReplaceEquipProcess = 10028,
	AssemblyEquipProcess = 10029,
	UnloadEquipProcess = 10030,
	SummonHeroProcess = 10031,
	SellGoodsProcess = 10032,
	OneGoldChoukaProcess = 10033,
	TenGoldChoukaProcess = 10034,
	OneDiamondChoukaProcess = 10035,
	TenDiamondChoukaProcess = 10036,
	OpenChoukaFrameProcess = 10037,
	FinishTaskProcess = 10039,
	SealProcess = 10040,
	EveryDaySignProcess = 10041,
	GetTotalSignRewardProcess = 10042,
	OpenSignFrameProcess = 10043,
	GetCityInfoProcess = 10044,
	CityQiangHuaProcess = 10045,
	GetCityQiangHuaCostProcess = 10046,
	CityUpStarProcess = 10047,
	UseItemProcess = 10050,
	UpTailsStarProcess = 10051,
	ArenaInfoProcess = 10052,
	ArenaBeginProcess = 10053,
	ClearArenaCoolProcess = 10054,
	ExchangeArenaScoreProcess = 10055,
	ShowBattleReportProcess = 10056,
	BuyJingjiTimesProcess = 10057,
	RefreshOppnentListProcess = 10058,
	SaveJingjiResultProcess = 10059,
	SaveJingjiDefenseProcess = 10060,
	RankingShowProcess = 10061,
	SaveTailsFormationProcess = 10062,
	GetSevenDayRewardProcess = 10063,
	NewComerGuideProcess = 10064,
	UpdateTeamNameProcess = 10065,
	UpdateTeamSrcProcess = 10066,
	OneKeyJuexingRongHeBaoshiProcess = 10067,
	BuySkillPowerStartProcess = 10068,
	SystemNoticeProcess = 11001,
	GiftExchangeProcess = 11002,
	DownLineProcess = 11003,
	HeartProcess = 11004,
	ChatHeartProcess = 11005,
	RecieveRunMsgProcess = 11007,
	RecieveChatMsgProcess = 11009,
	UserRegistProcess = 12001,
	ModifyUserInfoProcess = 12002,
	EnterChapterProcess = 20001,
	BeginBattleProcess = 20003,
	SaveBattleResultProcess = 20004,
	SaoDangProcess = 20005,
	BuyBattleTimesProcess = 20006,
	GetBuyBattleTimeCostProcess = 20007,
	OpenTrialsProcess = 20008,
	GetShanDuoLaRewardProcess = 20009,
	GetSpiritHomeRewardProcess = 20010,
	GetWuLaoFengRewardProcess = 20011,
	SelectAincradTeamProcess = 20012,
	SelectAincradTeamProcess = 20012,
	OpenAincradBoxProcess = 20013,
	ResetAincradProcess = 20014,
	GetAincradRewardProcess = 20015,
	SelectAincradBuffProcess = 20016,
	OpenAincradProcess = 20017,
	SelectAincradOppnentListProcess = 20018,
	SaveAincradBattleResultProcess = 20019,
	OpenChapterBoxProcess = 20020,
	OpenTreeWorldProcess = 20021,
	RefreshTreeWorldHeroListProcess = 20022,
	TreeWorldSelectHeroProcess = 20023,
	EndTreeWorldAndRewardProcess = 20024,
	SaveTreeWorldGuankaProcess = 20025,
	OpenRiYueZhuiProcess = 20026,
	UpdateZhuijiEnemyProcess = 20027,
	SaveZhuijiResultProcess = 20028,
	BuyZhuijiPowerProcess = 20029,
	GenerateOrderIdProcess = 20030,
	VipBuyGiftProcess = 20031,
	SecretChoukaProcess = 20032,
	CommonRankingShowProcess = 20033,
	FirstRechargeProcess = 20034,
	SendChatMsgProcess = 20036,
	NavigateProcess = 20037,
	DecomposeProcess = 20038,
	ShowExchangeItemsProcess = 20039,
	FinishActivityProcess = 30001,
	GetNDayEndRewardProcess = 30002,
	FinishGeneralActivityProcess = 30003,
	CreateUnionProcess = 30004,
	SearchUnionProcess = 30005,
	ShowUnionInfoProcess = 30006,
	SHowUnionByPageProcess = 30007,
	ApplyUnionProcess = 30008,
	UnionSignProcess = 30010,
	SecedeUnionProcess = 30011,
	ApproveJoinProcess = 30012,
	UnionEliminateProcess = 30013,
	SecedeUnionProcess = 30011,
	ModifyUnionInfoProcess = 30015,
	AppointUnionProcess = 30016,
	ShowUnionLogProcess = 30017,
	ModifyUnionSetUpProcess = 30019,
	SendUnionMailProcess = 30020,
	NoticeUnionMemberProcess = 30021,
	ShowUnionRandomProcess = 30101,
	ShowUnionMembersProcess = 30102,
	UnionCombatResultProcess = 30103,
	SendMercenaryProcess = 30104,
	CallBackMercenaryProcess = 30105,
	UnionCombatTimeProcess = 30106,
	ShowTeamDefenseInfoProcess = 30107,
	OnearmBunditProcess = 31002,
	OpenCardActProcess = 31003,
	GetSevenRechargeAwardProcess = 31004,
	PurchaseFundProcess = 31005,
	FreshOpenCardProcess = 31006,
	GodOfFortuneProcess = 31007,
	TeamRechargeInfoProcess = 40000,
	TeamRechargeProcess = 50000,
	}

function GetOperationCodeName( code )
	if code == 10000 then
		return "VersionResponse"
	elseif  code == 10001 then
		return "LoginResponse"
	elseif  code == 10002 then
		return "SelectZoneResponse"
	elseif  code == 10003 then
		return "ShowMainFrameResponse"
	elseif  code == 10004 then
		return "OpenShopResponse"
	elseif  code == 10005 then
		return "BuyShopGoodsResponse"
	elseif  code == 10006 then
		return "HandRefreshShopResponse"
	elseif  code == 10007 then
		return "DianJinRequestResponse"
	elseif  code == 10008 then
		return "DianJinStartResponse"
	elseif  code == 10009 then
		return "BuyPowerRequestResponse"
	elseif  code == 10010 then
		return "BuyPowerStartResponse"
	elseif  code == 10011 then
		return "MaillGetListResponse"
	elseif  code == 10012 then
		return "MailReadResponse"
	elseif  code == 10013 then
		return "GetServerListResponse"
	elseif  code == 10014 then
		return "OpenBeiBaoResponse"
	elseif  code == 10015 then
		return "OpenHeroListResponse"
	elseif  code == 10016 then
		return "OpenSkillFrameResponse"
	elseif  code == 10017 then
		return "UpHeroSkillLevelResponse"
	elseif  code == 10018 then
		return "XiangQianHeroNameChipResponse"
	elseif  code == 10019 then
		return "JieSuoHeroNameResponse"
	elseif  code == 10020 then
		return "JuexingRongHeBaoshiResponse"
	elseif  code == 10021 then
		return "JueXingHeroResponse"
	elseif  code == 10022 then
		return "OpenJueXingFrameResponse"
	elseif  code == 10023 then
		return "UseYaoShuiResponse"
	elseif  code == 10024 then
		return "OpenEquipFrameResponse"
	elseif  code == 10025 then
		return "QiangHuaEquipResponse"
	elseif  code == 10026 then
		return "JinjieEquipResponse"
	elseif  code == 10027 then
		return "BeginUseEquipResponse"
	elseif  code == 10028 then
		return "ReplaceEquipResponse"
	elseif  code == 10029 then
		return "AssemblyEquipResponse"
	elseif  code == 10030 then
		return "UnloadEquipResponse"
	elseif  code == 10031 then
		return "SummonHeroResponse"
	elseif  code == 10032 then
		return "SellGoodsResponse"
	elseif  code == 10033 then
		return "OneGoldChoukaResponse"
	elseif  code == 10034 then
		return "TenGoldChoukaResponse"
	elseif  code == 10035 then
		return "OneDiamondChoukaReponse"
	elseif  code == 10036 then
		return "TenDiamondChoukaResponse"
	elseif  code == 10037 then
		return "OpenChoukaFrameReponse"
	elseif  code == 10039 then
		return "FinishTaskResponse"
	elseif  code == 10040 then
		return "SealResponse"
	elseif  code == 10041 then
		return "EveryDaySignResponse"
	elseif  code == 10042 then
		return "GetTotalSignRewardResponse"
	elseif  code == 10043 then
		return "OpenSignFrameResponse"
	elseif  code == 10044 then
		return "GetCityInfoResponse"
	elseif  code == 10045 then
		return "CityQiangHuaResponse"
	elseif  code == 10046 then
		return "GetCityQiangHuaCostResponse"
	elseif  code == 10047 then
		return "CityUpStarReponse"
	elseif  code == 10050 then
		return "UseItemResponse"
	elseif  code == 10051 then
		return "UpTailsStarResponse"
	elseif  code == 10052 then
		return "ArenaInfoResponse"
	elseif  code == 10053 then
		return "ArenaBeginResponse"
	elseif  code == 10054 then
		return "ClearArenaCoolResponse"
	elseif  code == 10055 then
		return "ExchangeArenaScoreResponse"
	elseif  code == 10056 then
		return "ShowBattleReportResponse"
	elseif  code == 10057 then
		return "BuyJingjiTimesResponse"
	elseif  code == 10058 then
		return "RefreshOppnentListResponse"
	elseif  code == 10059 then
		return "SaveJingjiResulResponse"
	elseif  code == 10060 then
		return "SaveJingjiDefenseResponse"
	elseif  code == 10061 then
		return "RankingShowResponse"
	elseif  code == 10062 then
		return "SaveTailsFormationResponse"
	elseif  code == 10063 then
		return "GetSevenDayRewardResponse"
	elseif  code == 10064 then
		return "NewComerGuideResponse"
	elseif  code == 10065 then
		return "UpdateTeamNameResponse"
	elseif  code == 10066 then
		return "UpdateTeamSrcResponse"
	elseif  code == 10067 then
		return "OneKeyJuexingRongHeBaoshiResponse"
	elseif  code == 10068 then
		return "BuySkillPowerStartResponse"
	elseif  code == 11001 then
		return "SystemNoticeResponse"
	elseif  code == 11002 then
		return "GiftExchangeResponse"
	elseif  code == 11003 then
		return "DownLineResponse"
	elseif  code == 11004 then
		return "HeartResponse"
	elseif  code == 11005 then
		return "ChatHeartResponse"
	elseif  code == 11007 then
		return "RecieveRunMsgResponse"
	elseif  code == 11009 then
		return "RecieveChatMsgResponse"
	elseif  code == 12001 then
		return "UserRegistResponse"
	elseif  code == 12002 then
		return "ModifyUserInfoResponse"
	elseif  code == 20001 then
		return "EnterChapterResponse"
	elseif  code == 20003 then
		return "BeginBattleResponse"
	elseif  code == 20004 then
		return "SaveBattleResultResponse"
	elseif  code == 20005 then
		return "SaoDangResponse"
	elseif  code == 20006 then
		return "BuyBattleTimesResponse"
	elseif  code == 20007 then
		return "GetBuyBattleTimeCostResponse"
	elseif  code == 20008 then
		return "OpenTrialsResponse"
	elseif  code == 20009 then
		return "GetShanDuoLaRewardResponse"
	elseif  code == 20010 then
		return "GetSpiritHomeRewardResponse"
	elseif  code == 20011 then
		return "GetWuLaoFengRewardResponse"
	elseif  code == 20012 then
		return "SelectAincradTeamResponse"
	elseif  code == 20012 then
		return "SelectAincradTeamResponse"
	elseif  code == 20013 then
		return "OpenAincradBoxResponse"
	elseif  code == 20014 then
		return "ResetAincradResponse"
	elseif  code == 20015 then
		return "GetAincradRewardResponse"
	elseif  code == 20016 then
		return "SelectAincradBuffResponse"
	elseif  code == 20017 then
		return "OpenAincradResponse"
	elseif  code == 20018 then
		return "SelectAincradOppnentListResponse"
	elseif  code == 20019 then
		return "SaveAincradBattleResultResponse"
	elseif  code == 20020 then
		return "OpenChapterBoxResponse"
	elseif  code == 20021 then
		return "OpenTreeWorldResponse"
	elseif  code == 20022 then
		return "RefreshTreeWorldHeroListResponse"
	elseif  code == 20023 then
		return "TreeWorldSelectHeroResponse"
	elseif  code == 20024 then
		return "EndTreeWorldAndRewardResponse"
	elseif  code == 20025 then
		return "SaveTreeWorldGuankaResponse"
	elseif  code == 20026 then
		return "OpenRiYueZhuiResponse"
	elseif  code == 20027 then
		return "UpdateZhuijiEnemyResponse"
	elseif  code == 20028 then
		return "SaveZhuijiResultResponse"
	elseif  code == 20029 then
		return "BuyZhuijiPowerResponse"
	elseif  code == 20030 then
		return "GenerateOrderIdResponse"
	elseif  code == 20031 then
		return "VipBuyGiftResponse"
	elseif  code == 20032 then
		return "SecretChoukaResponse"
	elseif  code == 20033 then
		return "CommonRankingShowResponse"
	elseif  code == 20034 then
		return "FirstRechargeResponse"
	elseif  code == 20036 then
		return "SendChatMsgResponse"
	elseif  code == 20037 then
		return "NavigateResponse"
	elseif  code == 20038 then
		return "DecomposeResponse"
	elseif  code == 20039 then
		return "ShowExchangeItemsResponse"
	elseif  code == 30001 then
		return "FinishActivityResponse"
	elseif  code == 30002 then
		return "GetNDayEndRewardResponse"
	elseif  code == 30003 then
		return "FinishGeneralActivityResponse"
	elseif  code == 30004 then
		return "CreateUnionResponse"
	elseif  code == 30005 then
		return "SearchUnionResponse"
	elseif  code == 30006 then
		return "ShowUnionInfoResponse"
	elseif  code == 30007 then
		return "SHowUnionByPageResponse"
	elseif  code == 30008 then
		return "ApplyUnionResponse"
	elseif  code == 30010 then
		return "UnionSignResponse"
	elseif  code == 30011 then
		return "SecedeUnionResponse"
	elseif  code == 30012 then
		return "ApproveJoinResponse"
	elseif  code == 30013 then
		return "UnionEliminateResponse"
	elseif  code == 30011 then
		return "SecedeUnionResponse"
	elseif  code == 30015 then
		return "ModifyUnionInfoResponse"
	elseif  code == 30016 then
		return "AppointUnionResponse"
	elseif  code == 30017 then
		return "ShowUnionLogResponse"
	elseif  code == 30019 then
		return "ModifyUnionSetUpResponse"
	elseif  code == 30020 then
		return "SendUnionMailResponse"
	elseif  code == 30021 then
		return "NoticeUnionMemberResponse"
	elseif  code == 30101 then
		return "ShowUnionRandomResponse"
	elseif  code == 30102 then
		return "ShowUnionMembersResponse"
	elseif  code == 30103 then
		return "UnionCombatResultResponse"
	elseif  code == 30104 then
		return "SendMercenaryResponse"
	elseif  code == 30105 then
		return "CallBackMercenaryResponse"
	elseif  code == 30106 then
		return "UnionCombatTimeResponse"
	elseif  code == 30107 then
		return "ShowTeamDefenseInfoResponse"
	elseif  code == 31002 then
		return "OnearmBunditResponse"
	elseif  code == 31003 then
		return "OpenCardActResponse"
	elseif  code == 31004 then
		return "GetSevenRechargeAwardResponse"
	elseif  code == 31005 then
		return "PurchaseFundResponse"
	elseif  code == 31006 then
		return "FreshOpenCardResponse"
	elseif  code == 31007 then
		return "GodOfFortuneResponse"
	elseif  code == 40000 then
		return "TeamRechargeInfoResponse"
	elseif  code == 50000 then
		return "TeamRechargeResponse"
	 end
end