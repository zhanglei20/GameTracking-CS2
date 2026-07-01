"use strict";
/// <reference path="../csgo.d.ts" />
/// <reference path="../common/licenseutil.ts" />
/// <reference path="../common/eventutil.ts" />
/// <reference path="../common/store_items.ts" />
/// <reference path="../common/shopping_cart.ts" />
/// <reference path="../common/add_major_tokens_anim.ts" />
/// <reference path="../common/formattext.ts" />
/// <reference path="../generated/items_event_current_generated_store.d.ts" />
/// <reference path="../generated/items_event_current_generated_store.ts" />
/// <reference path="../popups/popup_acknowledge_item.ts" />
/// <reference path="../itemtile_store.ts" />
/// <reference path="../common/unique_random_number.ts"/>
var PopupMajorStore;
(function (PopupMajorStore) {
    const defidxStickerItem = InventoryAPI.GetItemDefinitionIndexFromDefinitionName('sticker');
    const defidxKeyChainItem = InventoryAPI.GetItemDefinitionIndexFromDefinitionName('keychain');
    const _teamRegionData = [
        { teamid: 89, region: 'eu' },
        { teamid: 12, region: 'eu' },
        { teamid: 142, region: 'eu' },
        { teamid: 135, region: 'eu' },
        { teamid: 139, region: 'eu' },
        { teamid: 106, region: 'eu' },
        { teamid: 81, region: 'eu' },
        { teamid: 60, region: 'eu' },
        { teamid: 59, region: 'eu' },
        { teamid: 0, region: 'eu' },
        { teamid: 119, region: 'eu' },
        { teamid: 115, region: 'eu' },
        { teamid: 137, region: 'eu' },
        { teamid: 69, region: 'eu' },
        { teamid: 135, region: 'eu' },
        { teamid: 95, region: 'eu' },
        { teamid: 0, region: 'eu' },
        { teamid: 85, region: 'am' },
        { teamid: 112, region: 'am' },
        { teamid: 102, region: 'am' },
        { teamid: 126, region: 'am' },
        { teamid: 140, region: 'am' },
        { teamid: 87, region: 'am' },
        { teamid: 104, region: 'am' },
        { teamid: 0, region: 'am' },
        { teamid: 80, region: 'am' },
        { teamid: 48, region: 'am' },
        { teamid: 122, region: 'as' },
        { teamid: 74, region: 'as' },
        { teamid: 127, region: 'as' },
        { teamid: 0, region: 'as' },
        { teamid: 132, region: 'as' }
    ];
    let m_activeMain = null;
    const m_overlayStack = [];
    PopupMajorStore.UpdateAnimationTimer = 5;
    function ClosePopup() {
        $.GetContextPanel().SetReadyForDisplay(false);
        CancelRefreshSubscription($.GetContextPanel());
        CancelRefreshTimerUpdate($.GetContextPanel());
        UiToolkitAPI.HideTextTooltip();
        UiToolkitAPI.HideTitleTextTooltip();
        $.DispatchEvent('CSGOPlaySoundEffect', 'inventory_inspect_close', 'MOUSE');
        $.DispatchEvent('UIPopupButtonClicked', '');
        $.DispatchEvent('ContextMenuEvent', '');
    }
    PopupMajorStore.ClosePopup = ClosePopup;
    function ReadyForDisplay() {
        if (!MyPersonaAPI.IsConnectedToGC()) {
            ClosePopup();
            return;
        }
        let eventId = g_ActiveTournamentInfo.eventid ? g_ActiveTournamentInfo.eventid : -1;
        if (eventId < 0) {
            ClosePopup();
            return;
        }
        const cp = $.GetContextPanel();
        cp.Data().aFlatStickersData = [];
        cp.Data().aFlatKeyChainData = [];
        $.RegisterForUnhandledEvent('PanoramaComponent_MyPersona_GcLogonNotificationReceived', ReadyForDisplay);
        $.RegisterForUnhandledEvent('PanoramaComponent_MyPersona_UpdateConnectionToGC', ReadyForDisplay);
        $.RegisterForUnhandledEvent('PanoramaComponent_Store_VolatileShopSubscribe', (...args) => { OnVolatileShopSubscribe(...args, cp); });
        _SubscribeForAllTournamentItems();
    }
    function Init() {
        let cp = $.GetContextPanel();
        if (!MyPersonaAPI.IsConnectedToGC()) {
            ClosePopup();
            return;
        }
        let eventId = g_ActiveTournamentInfo.eventid ? g_ActiveTournamentInfo.eventid : -1;
        if (eventId < 0) {
            ClosePopup();
            return;
        }
        cp.Data().arrAwaitingPricesheets = [];
        if (!MissionsAPI.GetSeasonalOperationFauxCreditsCost(g_ActiveTournamentInfo.credits_id, InventoryAPI.GetFauxItemIDFromDefAndPaintIndex(defidxStickerItem, g_ActiveTournamentInfo.stickerids[0])))
            cp.Data().arrAwaitingPricesheets.push(g_ActiveTournamentInfo.itemid_dynamic_stickers);
        let nStickerIdChampion = 0;
        g_ActiveTournamentTeams.forEach((tt) => {
            tt.champions.forEach((tcp) => {
                if (tcp.stickerids.length > 0)
                    nStickerIdChampion = tcp.stickerids[0];
            });
        });
        if (nStickerIdChampion && !MissionsAPI.GetSeasonalOperationFauxCreditsCost(g_ActiveTournamentInfo.credits_id, InventoryAPI.GetFauxItemIDFromDefAndPaintIndex(defidxStickerItem, nStickerIdChampion)))
            cp.Data().arrAwaitingPricesheets.push(g_ActiveTournamentInfo.itemid_champion_stickers);
        g_ActiveTournamentHighlights.forEach((thg) => {
            if (!MissionsAPI.GetSeasonalOperationFauxCreditsCost(g_ActiveTournamentInfo.credits_id, InventoryAPI.GetFauxItemIDFromDefAndPaintIndex(defidxKeyChainItem, thg.highlights[0].kc_highlight)))
                cp.Data().arrAwaitingPricesheets.push(thg.itemid_dynamic_shop);
        });
        if (!cp.Data().loadDataTimeoutHandler && (cp.Data().arrAwaitingPricesheets.length > 0)) {
            $.GetContextPanel().SetHasClass('data-loading', true);
            _PushOverlay(cp, 'id-major-store-loading');
            cp.Data().loadDataTimeoutHandler = $.Schedule(5, () => {
                UiToolkitAPI.ShowGenericPopupOk($.Localize('#SFUI_SteamConnectionErrorTitle'), $.Localize('#SFUI_Steam_Error_LinkUnexpected'), '', () => $.DispatchEvent('HideContentPanel'));
                ClosePopup();
            });
            return;
        }
        cp.SetHasClass('major-' + eventId, true);
        if (!cp.Data().contextMenuCallbackHandle)
            cp.Data().contextMenuCallbackHandle = UiToolkitAPI.RegisterJSCallback(OnSearchContextMenuCallBack);
        cp.FindChildInLayoutFile('id-major-store-container-inner').AddClass('show');
        PriceRefreshTimerUpdate(cp);
        _UpdateStickerData(cp);
        _UpdateKeyChainsData(cp);
        _SetUpTitleBar(cp, eventId);
        _SetUpTeamsBanner(cp);
        _SetUpPopularityBanner(cp);
        _SetUpBookmarkItemsBanner(cp);
        _SetUpOrgBanners(cp);
        _SetUpKeyChainsBanner(cp);
        _SetUpChampionsBanner(cp);
        _VariousButtonActionsAndEvents(cp);
        _SetUpFilterPanel(cp);
        _ShowMainPanel(cp, 'id-major-store-banners');
        _UpdateBalance(cp);
        ShoppingCart.cart.subscribeToUpdates(cp, 'cart-counter', () => {
            const numItems = ShoppingCart.cart.getTotalItems();
            cp.SetDialogVariableInt('cart-count', numItems);
            cp.SetDialogVariableInt('cart-value', ShoppingCart.cart.getTotalPrice());
            cp.FindChildInLayoutFile('id-major-store-cart-info').SetHasClass('show', numItems > 0);
            cp.FindChildInLayoutFile('id-major-store-cart-info').TriggerClass('update-count');
        });
    }
    PopupMajorStore.Init = Init;
    function OnVolatileShopSubscribe(nContainerDef, bNewPricesParsed, cp) {
        if (cp.Data().loadDataTimeoutHandler) {
            cp.Data().arrAwaitingPricesheets = cp.Data().arrAwaitingPricesheets.filter((xx) => xx != nContainerDef);
            if (cp.Data().arrAwaitingPricesheets.length > 0) {
                return;
            }
            $.CancelScheduled(cp.Data().loadDataTimeoutHandler);
            cp.Data().loadDataTimeoutHandler = null;
            _PopOverlay();
            Init();
            return;
        }
        RefreshSubscription(cp);
        PriceRefreshTimerUpdate(cp);
        if (bNewPricesParsed) {
            if (nContainerDef == g_ActiveTournamentInfo.itemid_dynamic_stickers || nContainerDef == g_ActiveTournamentInfo.itemid_champion_stickers) {
                _UpdateStickerData(cp);
            }
            else if (g_ActiveTournamentDynamicContainers.includes(nContainerDef)) {
                _UpdateKeyChainsData(cp);
            }
            cp.Data().stopTileUpdate = false;
            _UpdateVisiblePanel(cp, true);
            $.Schedule(1, () => { cp.Data().stopTileUpdate = true; });
            ShoppingCart.cart.syncPrices((itemId) => {
                const item = cp.Data().aFlatStickersData.find(i => i.itemId === itemId);
                return item ? item.price : undefined;
            });
        }
    }
    function _UpdateVisiblePanel(cp, bDisableScroll = false) {
        if (m_activeMain?.id === 'id-major-store-single-view') {
            const elPanel = cp.FindChildInLayoutFile('id-major-store-single-view');
            if (elPanel.Data().SingleViewDisplayedStickers) {
                _SetUpSingleView(cp, elPanel.Data().SingleViewDisplayedStickers);
            }
        }
        else if (m_activeMain?.id === 'id-major-store-team-view') {
            const elPanel = cp.FindChildInLayoutFile('id-major-store-team-view');
            if (elPanel.Data().DisplayedTeam) {
                _SetUpTeamView(cp, elPanel.Data().DisplayedTeam);
            }
        }
        else if (m_activeMain?.id === 'id-major-store-keychains') {
            _SetUpKeyChainsPage(cp);
        }
        else if (m_activeMain?.id === 'id-major-store-banners') {
            _SetUpPopularityBanner(cp);
            _SetUpBookmarkItemsBanner(cp);
            _SetUpKeyChainsBanner(cp);
            _SetUpChampionsBanner(cp);
        }
        else if (m_activeMain?.id === 'id-major-store-content') {
            _UpdateItemsList({ cp, bDisableScroll });
        }
    }
    function GetNewMarketPrice(itemId) {
        const item = $.GetContextPanel().Data().aFlatStickersData.find(i => i.itemId === itemId);
        return item ? item.price : undefined;
    }
    PopupMajorStore.GetNewMarketPrice = GetNewMarketPrice;
    function _SubscribeForAllTournamentItems() {
        g_ActiveTournamentDynamicContainers.forEach((id) => StoreAPI.VolatileShopSubscribe(id, true));
    }
    function GetSecondsUntilPendingPriceUpdateForAllTournamentItems() {
        let nSeconds = 0;
        g_ActiveTournamentDynamicContainers.forEach((id) => {
            const nThisPricesheet = StoreAPI.GetSecondsUntilPendingPriceUpdate(id);
            if (nThisPricesheet > 0) {
                if ((nSeconds <= 0) || (nThisPricesheet < nSeconds))
                    nSeconds = nThisPricesheet;
            }
        });
        return nSeconds;
    }
    PopupMajorStore.GetSecondsUntilPendingPriceUpdateForAllTournamentItems = GetSecondsUntilPendingPriceUpdateForAllTournamentItems;
    function RefreshSubscription(cp) {
        if (!cp || !cp.IsValid())
            return;
        CancelRefreshSubscription(cp);
        _SubscribeForAllTournamentItems();
        cp.Data().refreshSubscriptionHandle = $.Schedule(150, () => RefreshSubscription(cp));
    }
    PopupMajorStore.RefreshSubscription = RefreshSubscription;
    function CancelRefreshSubscription(cp) {
        if (cp.Data().refreshSubscriptionHandle) {
            $.CancelScheduled(cp.Data().refreshSubscriptionHandle);
            cp.Data().refreshSubscriptionHandle = null;
        }
    }
    PopupMajorStore.CancelRefreshSubscription = CancelRefreshSubscription;
    function PriceRefreshTimerUpdate(cp) {
        if (!cp || !cp.IsValid())
            return;
        CancelRefreshTimerUpdate(cp);
        const nSeconds = GetSecondsUntilPendingPriceUpdateForAllTournamentItems();
        const elRefresh = cp.FindChildInLayoutFile('id-major-store-refresh');
        const timer = cp.FindChildInLayoutFile('id-major-store-refresh-time');
        timer.text = $.Localize("#major_store_prices_updated");
        if (nSeconds <= 0) {
            CancelRefreshTimerUpdate(cp);
            elRefresh.SetPanelEvent('onmouseover', () => {
                UiToolkitAPI.ShowTextTooltip('id-major-store-refresh', '#major_store_prices_updated_tooltip');
            });
            elRefresh.SetPanelEvent('onmouseout', () => {
                UiToolkitAPI.HideTextTooltip();
            });
            elRefresh.SetHasClass('alert', false);
            return;
        }
        elRefresh.SetPanelEvent('onmouseover', () => {
            UiToolkitAPI.ShowTextTooltip('id-major-store-refresh', '#major_store_refesh_tooltip');
        });
        elRefresh.SetPanelEvent('onmouseout', () => {
            UiToolkitAPI.HideTextTooltip();
        });
        elRefresh.SetHasClass('alert', true);
        timer.SetDialogVariable('timer', FormatText.SecondsToDDHHMMSSWithSymbolSeperator(nSeconds));
        timer.text = nSeconds > 1 ?
            $.Localize('#major_store_refresh_timer', timer) :
            $.Localize('#major_store_refresh_soon');
        cp.Data().priceRefreshHandler = $.Schedule(1, () => PriceRefreshTimerUpdate(cp));
    }
    PopupMajorStore.PriceRefreshTimerUpdate = PriceRefreshTimerUpdate;
    function CancelRefreshTimerUpdate(cp) {
        if (cp.Data().priceRefreshHandler) {
            $.CancelScheduled(cp.Data().priceRefreshHandler);
            cp.Data().priceRefreshHandler = null;
        }
    }
    PopupMajorStore.CancelRefreshTimerUpdate = CancelRefreshTimerUpdate;
    function _UpdateStickerData(cp) {
        const MapStickers = MapDataById(cp.Data().aFlatStickersData);
        g_ActiveTournamentTeams.forEach(team => {
            team.stickerids.forEach(id => {
                const oData = {
                    rawId: id,
                    isPlayer: false,
                    isOrg: false,
                    teamId: team.teamid,
                    team: team.team,
                    isChampion: false
                };
                _UpdateWithCurrentData(cp.Data().aFlatStickersData, MapStickers.get(id), oData, _GetStickerData);
            });
            team.players.forEach(player => {
                player.stickerids.forEach(id => {
                    const oData = {
                        rawId: id,
                        isPlayer: true,
                        isOrg: false,
                        teamId: team.teamid,
                        team: team.team,
                        playerCode: player.code,
                        isChampion: false
                    };
                    _UpdateWithCurrentData(cp.Data().aFlatStickersData, MapStickers.get(id), oData, _GetStickerData);
                });
            });
            team.champions.forEach(player => {
                player.stickerids.forEach(id => {
                    const oData = {
                        rawId: id,
                        isPlayer: true,
                        isOrg: false,
                        teamId: team.teamid,
                        team: team.team,
                        playerCode: player.code,
                        isChampion: true
                    };
                    _UpdateWithCurrentData(cp.Data().aFlatStickersData, MapStickers.get(id), oData, _GetStickerData);
                });
            });
        });
        const aOrgStickers = g_ActiveTournamentInfo.stickerids;
        aOrgStickers.forEach((id, idx) => {
            const oData = {
                rawId: id,
                isPlayer: false,
                isOrg: true,
                playerCode: g_ActiveTournamentInfo.location + ' ' + g_ActiveTournamentInfo.organization
            };
            _UpdateWithCurrentData(cp.Data().aFlatStickersData, MapStickers.get(id), oData, _GetStickerData);
        });
        const prices = cp.Data().aFlatStickersData.map(i => i.price);
        const min = prices.length ? Math.min(...prices) : 0;
        const max = prices.length ? Math.max(...prices) : 0;
        cp.Data().minPrice = min;
        cp.Data().maxPrice = max;
    }
    function _UpdateKeyChainsData(cp) {
        const highlights = g_ActiveTournamentHighlights;
        const mapKeyChains = MapDataById(cp.Data().aFlatKeyChainData);
        highlights.forEach(group => {
            group.highlights.forEach(kc => {
                const oData = {
                    group_id: group.group_id,
                    itemid_dynamic_shop: group.itemid_dynamic_shop,
                    stage: group.stage,
                    kc_highlight: kc.kc_highlight,
                    teamid1: kc.teamid1,
                    teamid2: kc.teamid2,
                    map_name: kc.map_name,
                    name: kc.title,
                    desc: kc.desc,
                };
                _UpdateWithCurrentData(cp.Data().aFlatKeyChainData, mapKeyChains.get(kc.kc_highlight), oData, _GetKeyChainData);
            });
        });
    }
    function MapDataById(savedFlatData) {
        const oldStickersData = new Map();
        if (savedFlatData && savedFlatData.length > 0) {
            for (let i = 0; i < savedFlatData.length; i++) {
                oldStickersData.set(('rawId' in savedFlatData[i]) ? savedFlatData[i].rawId : savedFlatData[i].kc_highlight, savedFlatData[i]);
            }
        }
        return oldStickersData;
    }
    function _UpdateWithCurrentData(aFlatStoredData, savedItemData, oData, _funcGetData) {
        if (savedItemData) {
            const livePrice = _GetCurrentPriceForItem(savedItemData.itemId);
            if (livePrice !== undefined && savedItemData.price !== undefined) {
                if (savedItemData.price !== livePrice)
                    savedItemData.oldPrice = savedItemData.price;
                savedItemData.price = livePrice;
                savedItemData.popularity = _GetCurrentTrendData(savedItemData.itemId, 'trend');
                const weeklyLow = _GetCurrentTrendData(savedItemData.itemId, 'low');
                const weeklyHigh = _GetCurrentTrendData(savedItemData.itemId, 'high');
                savedItemData.weeklyLow = weeklyLow;
                savedItemData.weeklyHigh = weeklyHigh;
                savedItemData.weeklyPctReductionFromHigh = (weeklyHigh > livePrice)
                    ? ((weeklyHigh - livePrice) * 100.0 / weeklyHigh) : 0.0;
            }
        }
        else {
            aFlatStoredData.push(_funcGetData(oData));
        }
    }
    function _GetStickerData(oData) {
        const itemId = InventoryAPI.GetFauxItemIDFromDefAndPaintIndex(defidxStickerItem, oData.rawId);
        const numRarity = InventoryAPI.GetItemRarity(itemId);
        const teamInRegion = ('teamId' in oData) ? _teamRegionData.filter(team => team.teamid === oData.teamId) : [];
        const teamRegion = (teamInRegion.length > 0) ? teamInRegion[0].region : '';
        const livePrice = _GetCurrentPriceForItem(itemId);
        const weeklyLow = _GetCurrentTrendData(itemId, 'low');
        const weeklyHigh = _GetCurrentTrendData(itemId, 'high');
        const weeklyPctReductionFromHigh = (weeklyHigh > livePrice)
            ? ((weeklyHigh - livePrice) * 100.0 / weeklyHigh) : 0.0;
        return {
            isPlayer: oData.isPlayer,
            isOrg: ('isOrg' in oData) ? oData.isOrg : false,
            rawId: oData.rawId,
            teamName: $.Localize('#CSGO_TeamID_' + oData.teamId),
            teamId: oData.teamId,
            teamTag: oData.team,
            playerCode: ('playerCode' in oData) ? oData.playerCode : '',
            realName: oData.isPlayer ? $.Localize('#SFUI_ProPlayer_' + oData.playerCode) : '',
            itemId: itemId,
            price: livePrice,
            rarity: numRarity,
            rarityLookup: $.Localize('#major_store_filter_type_' + numRarity),
            name: InventoryAPI.GetItemName(itemId),
            displayName: ItemInfo.GetFormattedName(itemId),
            popularity: _GetCurrentTrendData(itemId, 'trend'),
            weeklyLow: weeklyLow,
            weeklyHigh: weeklyHigh,
            weeklyPctReductionFromHigh: weeklyPctReductionFromHigh,
            teamRegion: teamRegion,
            champion: oData.isChampion
        };
    }
    function _GetKeyChainData(oData) {
        const itemId = InventoryAPI.GetFauxItemIDFromDefAndPaintIndex(defidxKeyChainItem, oData.kc_highlight);
        const livePrice = _GetCurrentPriceForItem(itemId);
        const weeklyLow = _GetCurrentTrendData(itemId, 'low');
        const weeklyHigh = _GetCurrentTrendData(itemId, 'high');
        const weeklyPctReductionFromHigh = (weeklyHigh > livePrice)
            ? ((weeklyHigh - livePrice) * 100.0 / weeklyHigh) : 0.0;
        return {
            group_id: oData.group_id,
            itemid_dynamic_shop: oData.itemid_dynamic_shop,
            kc_highlight: oData.kc_highlight,
            displayName: ItemInfo.GetFormattedName(itemId),
            stage: oData.stage,
            teamid1: oData.teamid1,
            teamid2: oData.teamid2,
            map_name: oData.map_name,
            desc: $.Localize(oData.desc),
            itemId: itemId,
            price: livePrice,
            name: $.Localize(oData.name),
            popularity: _GetCurrentTrendData(itemId, 'trend'),
            weeklyLow: weeklyLow,
            weeklyHigh: weeklyHigh,
            weeklyPctReductionFromHigh: weeklyPctReductionFromHigh
        };
    }
    function _GetCurrentPriceForItem(itemId) {
        return MissionsAPI.GetSeasonalOperationFauxCreditsCost(g_ActiveTournamentInfo.credits_id, itemId);
    }
    function _GetCurrentTrendData(itemId, szField) {
        return MissionsAPI.GetSeasonalOperationFauxItemTrend(g_ActiveTournamentInfo.credits_id, itemId, szField);
    }
    function UnreadyForDisplay() {
    }
    function _VariousButtonActionsAndEvents(cp) {
        cp.FindChildInLayoutFile('id-major-store-container').AddBlurPanel(cp.FindChildInLayoutFile('id-major-store-filters-panel'));
        cp.FindChildInLayoutFile('id-major-store-container').AddBlurPanel(cp.FindChildInLayoutFile('id-major-store-loading'));
        cp.FindChildInLayoutFile('id-major-store-container').AddBlurPanel(cp.FindChildInLayoutFile('id-major-store-search-results'));
        cp.FindChildInLayoutFile('id-list-large-icons').SetPanelEvent('onactivate', () => {
            _MakeDelayedLoadList(cp);
        });
        cp.FindChildInLayoutFile('id-list-small-icons').SetPanelEvent('onactivate', () => {
            _MakeDelayedLoadList(cp);
        });
        cp.FindChildInLayoutFile('id-list-large-icons').checked = true;
        cp.FindChildInLayoutFile('id-major-store-sort-dropdown').SetPanelEvent('oninputsubmit', () => {
            _UpdateItemsList({ cp });
        });
        cp.FindChildInLayoutFile('id-major-store-content-home-btn').SetPanelEvent('onactivate', () => {
            _OnActivateClearAll(cp);
            _ShowMainPanel(cp, 'id-major-store-banners');
        });
        cp.FindChildInLayoutFile('id-major-store-team-view-home-btn').SetPanelEvent('onactivate', () => {
            _OnActivateClearAll(cp);
            _ShowMainPanel(cp, 'id-major-store-banners');
        });
        cp.FindChildInLayoutFile('id-major-store-single-view-back-btn').SetPanelEvent('onactivate', () => {
            _OnActivateClearAll(cp);
            _ShowMainPanel(cp, 'id-major-store-team-view');
        });
        cp.FindChildInLayoutFile('id-popup-major-store-back-btn').SetPanelEvent('onactivate', () => {
            _OnActivateClearAll(cp);
            _ShowMainPanel(cp, 'id-major-store-banners');
        });
        cp.FindChildInLayoutFile('id-major-store-balance').SetPanelEvent('onmouseover', () => {
            cp.FindChildInLayoutFile('id-major-store-balance').SetDialogVariable('local-price', StoreAPI.GetStoreItemTokensBundlePrice('' + g_ActiveTournamentInfo.itemid_charge, 100, ''));
            const tooltip = $.Localize('#major_store_balance_tooltip', cp.FindChildInLayoutFile('id-major-store-balance'));
            UiToolkitAPI.ShowTitleTextTooltip('id-major-store-balance', '#CSGO_TournamentPass_' + g_ActiveTournamentInfo.location + '_credits', tooltip);
        });
        cp.FindChildInLayoutFile('id-major-store-balance').SetPanelEvent('onmouseout', () => {
            UiToolkitAPI.HideTitleTextTooltip();
        });
        cp.FindChildInLayoutFile('id-major-store-receipt').SetPanelEvent('onmouseover', () => {
            UiToolkitAPI.ShowTextTooltip('id-major-store-receipt', '#major_store_balance_receipt');
        });
        cp.FindChildInLayoutFile('id-major-store-receipt').SetPanelEvent('onmouseout', () => {
            UiToolkitAPI.HideTextTooltip();
        });
        cp.FindChildInLayoutFile('id-major-store-receipt').SetPanelEvent('onactivate', () => {
            SteamOverlayAPI.OpenUrlInOverlayOrExternalBrowser("https://" + SteamOverlayAPI.GetSteamCommunityURL() + "/my/gcpd/" + SteamOverlayAPI.GetAppID() + "/?tab=creditsaudit");
        });
        function _Callback() {
            _UpdateBalance(cp);
        }
        ;
        const callback = UiToolkitAPI.RegisterJSCallback(_Callback);
        cp.FindChildInLayoutFile('id-major-store-cart-btn').SetPanelEvent('onactivate', () => {
            $.DispatchEvent("CSGOPlaySoundEffect", "UIPanorama.loadout_sector_select", "MOUSE");
            const popupPanel = UiToolkitAPI.ShowCustomLayoutPopupParameters('id-popup-shopping-cart-checkout', 'file://{resources}/layout/popups/popup_shopping_cart_checkout.xml', '&callback=' + callback);
            popupPanel.Data().eventId = cp.Data().eventId;
        });
        cp.FindChildInLayoutFile('id-major-store-cart-btn').SetPanelEvent('onmouseover', () => {
            UiToolkitAPI.ShowTextTooltip('id-major-store-cart-btn', '#major_store_checkout_empty_desc');
        });
        cp.FindChildInLayoutFile('id-major-store-cart-btn').SetPanelEvent('onmouseout', () => {
            UiToolkitAPI.HideTextTooltip();
        });
        const elSearchBox = cp.FindChildInLayoutFile('id-major-store-search-box');
        elSearchBox.SetPanelEvent('ontextentrychange', () => {
            _Debounce(cp, 'textDebounceTimeoutHandle', .3, () => { _ShowSearchResults(cp, _GetItemsForSearch(cp, elSearchBox.text)); });
        });
        elSearchBox.SetPanelEvent('ontextentrysubmit', () => {
            _ShowSearchResults(cp, _GetItemsForSearch(cp, elSearchBox.text));
        });
        cp.FindChildInLayoutFile('id-major-store-see-all-teams-btn').SetPanelEvent('onactivate', () => {
            _OnActivateClearAll(cp);
            _ShowMainPanel(cp, 'id-major-store-content');
            const elDropDown = cp.FindChildInLayoutFile('id-major-store-sort-dropdown');
            elDropDown.SetSelected('weekly-high-low');
        });
        cp.FindChildInLayoutFile('id-major-store-see-all-popular-btn').SetPanelEvent('onactivate', () => {
            _OnActivateClearAll(cp);
            cp.Data().useBookMarkList = false;
            _ShowMainPanel(cp, 'id-major-store-content');
            const elDropDown = cp.FindChildInLayoutFile('id-major-store-sort-dropdown');
            elDropDown.SetSelected('popularity-high-low');
        });
        cp.FindChildInLayoutFile('id-major-store-see-all-bookmarked-btn').SetPanelEvent('onactivate', () => {
            _OnActivateClearAll(cp);
            cp.Data().useBookMarkList = true;
            _ShowMainPanel(cp, 'id-major-store-content');
        });
        cp.FindChildInLayoutFile('id-major-store-see-all-keychains-btn').SetPanelEvent('onactivate', () => {
            _OnActivateClearAll(cp);
            _ShowMainPanel(cp, 'id-major-store-keychains');
        });
        cp.FindChildInLayoutFile('id-major-store-filters-panel').SetPanelEvent('onactivate', () => {
        });
        cp.FindChildInLayoutFile('id-major-store-search-results').SetPanelEvent('onactivate', () => {
        });
        const elFloatingFilterPanel = cp.FindChildInLayoutFile('id-major-fullscreen-filter');
        cp.FindChildInLayoutFile('id-major-store-sort-filter-btn').SetPanelEvent('onactivate', () => {
            elFloatingFilterPanel.visible = true;
            _PushOverlay(cp, 'id-major-fullscreen-filter');
        });
        cp.FindChildInLayoutFile('id-major-fullscreen-filter-btn').SetPanelEvent('onactivate', () => {
            _PopOverlay();
        });
        cp.FindChildInLayoutFile('id-major-fullscreen-text-search-btn').SetPanelEvent('onactivate', () => {
            _PopOverlay();
        });
        cp.FindChildInLayoutFile('id-major-store-filters-close').SetPanelEvent('onactivate', () => {
            _PopOverlay();
        });
        function fnOnPropertyTransitionEndEvent(panel, propertyName) {
            if (elFloatingFilterPanel === panel && propertyName === 'opacity') {
                if (elFloatingFilterPanel.visible === true && !panel.BIsTransparent()) {
                    return true;
                }
                if (propertyName === 'opacity') {
                    if (elFloatingFilterPanel.visible === true && elFloatingFilterPanel.BIsTransparent()) {
                        elFloatingFilterPanel.visible = false;
                        return true;
                    }
                }
                return false;
            }
        }
        $.RegisterEventHandler('PropertyTransitionEnd', elFloatingFilterPanel, fnOnPropertyTransitionEndEvent);
        AddMajorTokensAnim.SetTransitionEndEvent(cp.FindChildInLayoutFile('id-major-store-add-tokens'));
        const elBookmark = cp.FindChildInLayoutFile('id-major-store-banners-bookmarks');
        $.RegisterEventHandler('PropertyTransitionEnd', elBookmark, (panel, propertyName) => {
            if (elBookmark.id === panel.id && propertyName === 'opacity') {
                if (elBookmark.visible === true && elBookmark.BIsTransparent()) {
                    elBookmark.visible = false;
                    return true;
                }
            }
            return false;
        });
    }
    function _MakeDelayedLoadList(cp) {
        let lister = cp.FindChildInLayoutFile('id-major-store-items-lister');
        const btn = cp.FindChildInLayoutFile('id-list-large-icons');
        const selectedBtn = btn.GetSelectedButton();
        const snippetType = selectedBtn.GetAttributeString('data-type', '');
        if (lister && lister.IsValid() && snippetType == lister.GetAttributeString('data-type', '')) {
            _UpdateItemsList({ cp });
            return;
        }
        if (lister)
            lister.DeleteAsync(0);
        lister = $.CreatePanel('JSDelayLoadList', cp.FindChildInLayoutFile('id-major-store-content-page'), 'id-major-store-items-lister');
        lister.BLoadLayoutSnippet(snippetType);
        $.Schedule(.15, () => _UpdateItemsList({ cp }));
    }
    function _SetUpTitleBar(cp, eventId) {
        cp.SetDialogVariable('tournament_name', $.Localize('#CSGO_Tournament_Event_NameShort_' + eventId));
        cp.FindChildInLayoutFile('id-major-store-major-logo').SetImage('file://{images}/tournaments/events/tournament_logo_' + eventId + '.svg');
    }
    function _SetUpTeamsBanner(cp) {
        const teams = g_ActiveTournamentTeams;
        const elParent = cp.FindChildInLayoutFile('id-major-store-banner-teams');
        teams.forEach(team => {
            const elPanel = $.CreatePanel('Button', elParent, '');
            elPanel.BLoadLayoutSnippet('banner-team-box');
            elPanel.FindChildInLayoutFile('id-team-icon').SetImage('file://{images}/tournaments/teams/' + team.team + '.svg');
            elPanel.FindChildInLayoutFile('id-team-icon-blur').SetImage('file://{images}/tournaments/teams/' + team.team + '.svg');
            elPanel.SetDialogVariable('name', $.Localize('#CSGO_TeamID_' + team.teamid));
            elPanel.style.backgroundPosition = Math.floor(Math.random() * 100) + '% 50%';
            elPanel.SetPanelEvent('onactivate', () => {
                _SetUpTeamView(cp, team);
                _ShowMainPanel(cp, 'id-major-store-team-view');
                $.DispatchEvent('CSGOPlaySoundEffect', 'UIPanorama.submenu_leveloptions_select', 'MOUSE');
            });
        });
    }
    function _SetUpPopularityBanner(cp) {
        const aSorted = cp.Data().aFlatStickersData.toSorted((a, b) => {
            if (a.popularity != b.popularity)
                return b.popularity - a.popularity;
            else if (a.price != b.price)
                return b.price - a.price;
            else
                return a.rawId - b.rawId;
        });
        const numToShow = 40;
        const elParent = cp.FindChildInLayoutFile('id-major-store-banner-popular');
        const numTilesPerPage = 5;
        let numPages = 0;
        let elCarouselPage = null;
        for (let i = 0; i < numToShow; i++) {
            if (i % numTilesPerPage === 0) {
                elCarouselPage = elParent.FindChildInLayoutFile('id-major-store-carousel-page-' + numPages);
                if (!elCarouselPage) {
                    elCarouselPage = $.CreatePanel('Panel', elParent, 'id-major-store-carousel-page-' + numPages, { class: 'popup-major-store__banner__popular_page elCarouselPage' });
                }
                numPages++;
            }
            if (elCarouselPage) {
                let elPanel = elCarouselPage.FindChildInLayoutFile('id-carousel-sticker' + i);
                if (!elPanel) {
                    elPanel = $.CreatePanel('Panel', elCarouselPage, 'id-carousel-sticker' + i);
                    elPanel.BLoadLayoutSnippet('banner-popular-entry');
                }
                elPanel.SetDialogVariableInt('position', i + 1);
                aSorted[i].popularityRank = i;
                const elTile = elPanel.FindChildInLayoutFile('id-popular-tile');
                _UpdateTile(cp, elTile, aSorted, i);
            }
        }
    }
    function _GetBookmarkedItemsList(cp) {
        const itemsMap = new Map();
        for (const sticker of cp.Data().aFlatStickersData) {
            itemsMap.set(sticker.rawId.toString(), sticker);
        }
        for (const keyChain of cp.Data().aFlatKeyChainData) {
            itemsMap.set(keyChain.kc_highlight.toString(), keyChain);
        }
        const aDefIndexes = GameInterfaceAPI.GetSettingString('cl_major_store_watch_list').split(',');
        return aDefIndexes.map(defIndex => itemsMap.get(defIndex)).filter((item) => item !== undefined).reverse();
    }
    function _SetUpBookmarkItemsBanner(cp) {
        const aSorted = _GetBookmarkedItemsList(cp);
        if (aSorted.length < 1) {
            cp.FindChildInLayoutFile('id-major-store-banners-bookmarks').SetHasClass('show', false);
            cp.FindChildInLayoutFile('id-major-store-bookmark-hint').visible = true;
            return;
        }
        cp.FindChildInLayoutFile('id-major-store-banners-bookmarks').SetHasClass('show', true);
        cp.FindChildInLayoutFile('id-major-store-banners-bookmarks').visible = true;
        cp.FindChildInLayoutFile('id-major-store-bookmark-hint').visible = false;
        const elParent = cp.FindChildInLayoutFile('id-major-store-banner-bookmarked');
        const numTilesPerPage = 8;
        const totalPages = Math.ceil(aSorted.length / numTilesPerPage);
        for (let i = 0; i < totalPages; i++) {
            let elCarouselPage = elParent.FindChildInLayoutFile('id-major-store-carousel-page-' + i);
            if (!elCarouselPage) {
                elCarouselPage = $.CreatePanel('Panel', elParent, 'id-major-store-carousel-page-' + i, { class: 'popup-major-store__banner__popular_page' });
                elCarouselPage.SetHasClass('small', true);
                elCarouselPage.SetHasClass('banner-bookmark', true);
            }
            const startIndex = i * numTilesPerPage;
            for (let j = 0; j < numTilesPerPage; j++) {
                let stickerIndex = startIndex + j;
                let elPanel = elCarouselPage.FindChildInLayoutFile('id-carousel-sticker' + stickerIndex);
                if (!elPanel) {
                    elPanel = $.CreatePanel('Panel', elCarouselPage, 'id-carousel-sticker' + stickerIndex);
                }
                elPanel.BLoadLayoutSnippet('store-tile');
                if (aSorted[stickerIndex]) {
                    const bIsSticker = 'rawId' in aSorted[stickerIndex];
                    elPanel.SetHasClass('keychain', !bIsSticker);
                    if (bIsSticker)
                        _UpdateTile(cp, elPanel, aSorted, stickerIndex);
                    else
                        _UpdateKeyChainsTile(cp, elPanel, aSorted, stickerIndex);
                    elPanel.SetHasClass('hidden', false);
                    elPanel.enabled = true;
                    elPanel.hittest = true;
                }
                else {
                    elPanel.SetHasClass('keychain', false);
                    elPanel.SetHasClass('hidden', true);
                    elPanel.enabled = false;
                    elPanel.hittest = false;
                }
            }
        }
        if (elParent.Children().length > totalPages) {
            const numPanelsToDelete = elParent.Children().length - totalPages;
            const numPagesMade = elParent.Children().length - 1;
            for (let i = numPagesMade; i > (numPagesMade - numPanelsToDelete); i--) {
                elParent.Children()[i].DeleteAsync(0);
            }
        }
    }
    function _IsItemBookmarked(defidx) {
        return GameInterfaceAPI.GetSettingString('cl_major_store_watch_list').split(',').includes(defidx.toString());
    }
    function _UpdateBookmarkSetting(cp, reusePanel, defidx) {
        const aItemIds = GameInterfaceAPI.GetSettingString('cl_major_store_watch_list').split(',');
        const idIndex = aItemIds.findIndex(id => id === defidx.toString());
        if (idIndex === -1) {
            aItemIds.push(defidx.toString());
        }
        else {
            aItemIds.splice(idIndex, 1);
        }
        GameInterfaceAPI.SetSettingString('cl_major_store_watch_list', aItemIds.length > 0 ? aItemIds.join(',') : "");
        if (m_activeMain?.id === 'id-major-store-banners') {
            _SetUpBookmarkItemsBanner(cp);
            _SetUpKeyChainsBanner(cp);
            _SetUpPopularityBanner(cp);
            _SetUpChampionsBanner(cp);
        }
        if (cp.Data().useBookMarkList) {
            _UpdateItemsList({ cp, bDisableScoll: true });
        }
    }
    function _SetUpOrgBanners(cp) {
        cp.SetDialogVariable('org-name', g_ActiveTournamentInfo.organization);
        const elParent = cp.FindChildInLayoutFile('id-major-store-banner-org-stickers');
        const aFilteredStickers = cp.Data().aFlatStickersData.filter(sticker => (sticker.isOrg === true));
        aFilteredStickers.forEach((sticker, idx) => {
            let elPanel = elParent.FindChildInLayoutFile('id-org-sticker-' + idx);
            if (!elPanel) {
                elPanel = $.CreatePanel('Panel', elParent, 'id-org-sticker-' + idx);
                elPanel.BLoadLayoutSnippet('store-tile');
            }
            _UpdateTile(cp, elPanel, aFilteredStickers, idx);
        });
    }
    function _SetUpKeyChainsBanner(cp) {
        const elBanner = cp.FindChildInLayoutFile('id-banner-keychains');
        const elCarouselNav = cp.FindChildInLayoutFile('id-carousel-nav-keychains');
        const aKeyChains = cp.Data().aFlatKeyChainData;
        if (aKeyChains.length <= 1) {
            elBanner.visible = false;
            elCarouselNav.visible = false;
            return;
        }
        const itemsMap = new Map();
        for (const item of aKeyChains) {
            itemsMap.set(item.kc_highlight.toString(), item);
        }
        const randomGen = new UniqueRandomUtils.UniqueRandomGenerator(0, 9);
        let aKeyChainsForBanner = [];
        const numItemsFromEachStage = 9;
        g_ActiveTournamentHighlights.forEach(group => {
            randomGen.reset();
            for (let i = 0; i < numItemsFromEachStage; i++) {
                const numRandom = randomGen.next();
                const keyChain = group.highlights[numRandom];
                aKeyChainsForBanner.push(itemsMap.get(keyChain.kc_highlight.toString()));
            }
        });
        elBanner.visible = true;
        elCarouselNav.visible = true;
        function shuffleArray(array) {
            for (let i = array.length - 1; i > 0; i--) {
                const j = Math.floor(Math.random() * (i + 1));
                [array[i], array[j]] = [array[j], array[i]];
            }
            return array;
        }
        shuffleArray(aKeyChainsForBanner);
        const numToShow = aKeyChainsForBanner.length - 1;
        const elParent = cp.FindChildInLayoutFile('id-major-store-banner-keychains');
        const numTilesPerPage = 5;
        let numPages = 0;
        let elCarouselPage = null;
        for (let i = 0; i < numToShow; i++) {
            if (i % numTilesPerPage === 0) {
                elCarouselPage = elParent.FindChildInLayoutFile('id-major-store-carousel-page-' + numPages);
                if (!elCarouselPage) {
                    elCarouselPage = $.CreatePanel('Panel', elParent, 'id-major-store-carousel-page-' + numPages, { class: 'popup-major-store__banner__popular_page' });
                }
                numPages++;
            }
            if (elCarouselPage) {
                let elPanel = elCarouselPage.FindChildInLayoutFile('id-carousel-keychain' + i);
                if (!elPanel) {
                    elPanel = $.CreatePanel('Panel', elCarouselPage, 'id-carousel-keychain' + i);
                    elPanel.BLoadLayoutSnippet('store-tile');
                    elPanel.SetHasClass('keychain', true);
                    elPanel.SetHasClass('keychain-banner', true);
                }
                _UpdateKeyChainsTile(cp, elPanel, aKeyChainsForBanner, i);
            }
        }
    }
    function _SetUpChampionsBanner(cp) {
        const elBanner = cp.FindChildInLayoutFile('id-banner-champions');
        const elCarouselNav = cp.FindChildInLayoutFile('id-carousel-nav-champions');
        const aChamps = cp.Data().aFlatStickersData.toSorted((a, b) => {
            if (a.popularity != b.popularity)
                return b.popularity - a.popularity;
            else if (a.price != b.price)
                return b.price - a.price;
            else
                return a.rawId - b.rawId;
        }).filter(sticker => sticker.champion);
        if (aChamps.length < 1) {
            elBanner.visible = false;
            elCarouselNav.visible = false;
            return;
        }
        elBanner.visible = true;
        elCarouselNav.visible = true;
        const numToShow = aChamps.length;
        const elParent = cp.FindChildInLayoutFile('id-major-store-banner-champions');
        const numTilesPerPage = 8;
        let numPages = 0;
        let elCarouselPage = null;
        for (let i = 0; i < numToShow; i++) {
            if (i % numTilesPerPage === 0) {
                elCarouselPage = elParent.FindChildInLayoutFile('id-major-store-carousel-page-' + numPages);
                if (!elCarouselPage) {
                    elCarouselPage = $.CreatePanel('Panel', elParent, 'id-major-store-carousel-page-' + numPages, { class: 'popup-major-store__banner__popular_page banner-bookmark small' });
                }
                numPages++;
            }
            if (elCarouselPage) {
                let elPanel = elCarouselPage.FindChildInLayoutFile('id-carousel-champs' + i);
                if (!elPanel) {
                    elPanel = $.CreatePanel('Panel', elCarouselPage, 'id-carousel-champs' + i);
                    elPanel.BLoadLayoutSnippet('store-tile');
                }
                _UpdateTile(cp, elPanel, aChamps, i);
            }
        }
    }
    function _SetUpTeamView(cp, team) {
        const elPanel = cp.FindChildInLayoutFile('id-major-store-team-view');
        elPanel.Data().DisplayedTeam = team;
        const teamName = $.Localize('#CSGO_TeamID_' + team.teamid);
        elPanel.SetDialogVariable('team-name', teamName);
        const elTilesContainer = cp.FindChildInLayoutFile('id-major-store-team-tiles');
        const numTiles = 6;
        const randomGen = new UniqueRandomUtils.UniqueRandomGenerator(0, 7);
        for (let i = 0; i < numTiles; i++) {
            const elPackTile = elTilesContainer.FindChildInLayoutFile('sticker-pack-' + i);
            const elPackLabel = elPackTile.FindChildInLayoutFile('team-pack-major');
            elPackLabel.SetDialogVariableLocString('event-name', '#CSGO_Tournament_Event_Location_' + g_ActiveTournamentInfo.eventid);
            elPackLabel.text = $.Localize('#major_store_team_stickers-made', elPackLabel);
            const elBg = elPackTile.FindChildInLayoutFile('team-pack-bg-logo');
            elBg.SetImage('file://{images}/tournaments/teams/' + team.team + '.svg');
            elPackTile.SetDialogVariable('title', i === 0 ? teamName : team.players[i - 1].nick);
            elPackTile.SetHasClass('player', i > 0);
            const elStickerContainer = elPackTile.FindChildInLayoutFile('team-pack-icons');
            const getRandomInt = (min, max) => Math.floor(Math.random() * (max - min + 1)) + min;
            const createRandomizer = (pool) => () => pool.splice(Math.floor(Math.random() * pool.length), 1)[0];
            randomGen.reset();
            let xpos = 0;
            let prices = [];
            const stickers = i === 0 ?
                cp.Data().aFlatStickersData.filter(sticker => (!sticker.isPlayer && sticker.teamId === team.teamid)) :
                cp.Data().aFlatStickersData.filter(sticker => (sticker.isPlayer && sticker.playerCode === team.players[i - 1].code));
            stickers.forEach((id, idx) => {
                prices.push(stickers[idx].price);
                let sticker = elStickerContainer.FindChild('pack-sticker' + idx);
                if (!sticker)
                    sticker = $.CreatePanel('ItemImage', elStickerContainer, 'pack-sticker' + idx, { scaling: 'stretch-to-fit-preserve-aspect' });
                sticker.itemid = stickers[idx].itemId;
                const zIndex = randomGen.next();
                const rotationSetting = zIndex == 3 ? getRandomInt(-15, 15) : getRandomInt(-95, 85);
                if (idx % 4 === 0) {
                    xpos = 0;
                }
                sticker.style.transform = 'rotateZ(' + rotationSetting + 'deg) translateY(-' + getRandomInt(8, 30) + 'px) translateX(' + getRandomInt(xpos, xpos + 35) + 'px)';
                xpos = xpos + 50;
                sticker.style.zIndex = ((idx === stickers.length - 1) && (stickers[idx].champion)) ? '9;' : zIndex + ';';
                sticker.style.brightness = zIndex === 0 ? '.5' : zIndex === 1 ? '.7' : zIndex === 2 ? '.8' : zIndex === 3 ? '1.1' : '1';
            });
            elStickerContainer.Children().forEach((sticker, index) => { if (index >= stickers.length) {
                sticker.DeleteAsync(0);
            } });
            elPackTile.SetDialogVariableInt('low-price', Math.min(...prices));
            elPackTile.SetDialogVariableInt('high-price', Math.max(...prices));
            elPackTile.SetPanelEvent('onactivate', () => {
                _ShowMainPanel(cp, 'id-major-store-single-view');
                _SetUpSingleView(cp, stickers);
                $.DispatchEvent('CSGOPlaySoundEffect', 'UIPanorama.submenu_leveloptions_select', 'MOUSE');
            });
        }
    }
    function _SetUpSingleView(cp, aStickers) {
        const elPanel = cp.FindChildInLayoutFile('id-major-store-single-view');
        elPanel.SetDialogVariable('team-name', aStickers[0].isPlayer ? aStickers[0].playerCode : $.Localize('#CSGO_TeamID_' + aStickers[0].teamId));
        const numTiles = aStickers.length;
        const elParent = elPanel.FindChildInLayoutFile('id-major-store-single-tiles');
        for (let i = 0; i < numTiles; i++) {
            let elPackTile = elParent.FindChildInLayoutFile('sticker-single-' + i);
            if (!elPackTile) {
                elPackTile = $.CreatePanel('ItemImage', elParent, 'sticker-single-' + i);
                elPackTile.BLoadLayoutSnippet('store-tile');
            }
            _UpdateTile(cp, elPackTile, aStickers, i);
        }
        elParent.Children().forEach((sticker, index) => { if (index >= aStickers.length) {
            sticker.DeleteAsync(0);
        } });
        elPanel.Data().SingleViewDisplayedStickers = aStickers;
    }
    function GetFakeStickers() {
        const fakeItems = ['4295199751', '4295199753'];
        return fakeItems[Math.floor(Math.random() * (1 - 0 + 1)) + 0];
    }
    function _UpdateBalance(cp) {
        const idxLookup = InventoryAPI.GetCacheTypeElementIndexByKey('SeasonalOperations', g_ActiveTournamentInfo.credits_id);
        let nRedeemableBalance = 0;
        if (g_ActiveTournamentInfo.credits_id == InventoryAPI.GetCacheTypeElementFieldByIndex('SeasonalOperations', idxLookup, 'season_value')) {
            nRedeemableBalance = InventoryAPI.GetCacheTypeElementFieldByIndex('SeasonalOperations', idxLookup, 'redeemable_balance');
            nRedeemableBalance = (nRedeemableBalance === null || nRedeemableBalance === undefined) ? 0 : nRedeemableBalance;
        }
        if (cp.Data().activatedCredits > 0) {
            const elNotification = cp.FindChildInLayoutFile('id-major-store-add-tokens');
            _PushOverlay(cp, 'id-major-store-add-tokens');
            const tempBalance = nRedeemableBalance - cp.Data().activatedCredits;
            cp.SetDialogVariableInt('balance', tempBalance);
            function CallAtEndAnimation() {
                _PopOverlay();
                cp.FindChildInLayoutFile('id-major-store-balance').TriggerClass('popup-major-store__top-bar__balance-anim');
                cp.SetDialogVariableInt('balance', nRedeemableBalance);
            }
            AddMajorTokensAnim.StartAnim(elNotification, cp.FindChildInLayoutFile('id-major-store-balance'), cp.Data().activatedCredits, CallAtEndAnimation);
            cp.Data().activatedCredits = 0;
        }
        else {
            cp.SetDialogVariableInt('balance', nRedeemableBalance);
        }
    }
    function _PreSetFilters(cp, filterId) {
        const elFilterPanel = cp.FindChildInLayoutFile('id-major-store-filters-panel');
        elFilterPanel.FindChildInLayoutFile(filterId).checked = true;
    }
    function _UpdateItemsList(oSettings) {
        const elParent = oSettings.cp.FindChildInLayoutFile('id-major-store-content-page');
        let elLister = elParent.FindChildInLayoutFile('id-major-store-items-lister');
        if (!elLister)
            return;
        const filteredList = _GetFilteredSortedIds(oSettings);
        elLister.SetLoadListItemFunction((elLister, nPanelIdx, reusePanel) => {
            const bIsSticker = 'rawId' in filteredList[nPanelIdx];
            if (!reusePanel || !reusePanel.IsValid()) {
                reusePanel = $.CreatePanel('Panel', elLister, '');
                reusePanel.BLoadLayoutSnippet('store-tile');
            }
            if (bIsSticker) {
                _UpdateTile(oSettings.cp, reusePanel, filteredList, nPanelIdx);
            }
            else {
                _UpdateKeyChainsTile(oSettings.cp, reusePanel, filteredList, nPanelIdx);
            }
            reusePanel.SetHasClass('keychain', !bIsSticker);
            return reusePanel;
        });
        elLister.UpdateListItems(filteredList.length);
        oSettings.cp.SetDialogVariableInt('item-count', filteredList.length);
        if (!oSettings.bDisableScroll)
            elLister.ScrollToTop();
    }
    function _UpdateFilterSettings(cp) {
        const elDropDown = cp.FindChildInLayoutFile('id-major-store-sort-dropdown');
        let numFiltersSelected = 0;
        const elNavBarFiltersParent = cp.FindChildInLayoutFile('id-major-store-filters-active');
        elNavBarFiltersParent.Children().forEach(btn => btn.DeleteAsync(0));
        let priceFilter = { min: 0, max: 0 };
        const aTeams = _GetFilteredTeams(cp);
        if (aTeams.length > 0) {
            aTeams.forEach(selectedBtn => {
                numFiltersSelected++;
                _MakeNavBarFilterButton(cp, elNavBarFiltersParent, selectedBtn, '#CSGO_TeamID_' + selectedBtn.Data().teamid, "id-filter-active-r-" + selectedBtn.Data().teamid);
            });
        }
        const aRarities = _GetFilteredRarities(cp);
        if (aRarities.length > 0) {
            aRarities.forEach(selectedBtn => {
                numFiltersSelected++;
                _MakeNavBarFilterButton(cp, elNavBarFiltersParent, selectedBtn, '#major_store_filter_type_' + selectedBtn.Data().rarity, "id-filter-active-r-" + selectedBtn.Data().rarity);
            });
        }
        const btnTeamOnly = cp.FindChildInLayoutFile('id-major-store-filter-team');
        if (btnTeamOnly.checked && btnTeamOnly.enabled) {
            numFiltersSelected++;
            _MakeNavBarFilterButton(cp, elNavBarFiltersParent, btnTeamOnly, '#major_store_filter_type_team_only', "id-filter-active-t-only");
        }
        const btnPlayerOnly = cp.FindChildInLayoutFile('id-major-store-filter-player');
        if (btnPlayerOnly.checked && btnPlayerOnly.enabled) {
            numFiltersSelected++;
            _MakeNavBarFilterButton(cp, elNavBarFiltersParent, btnPlayerOnly, '#major_store_filter_type_player_only', "id-filter-active-p-only");
        }
        const btnKeyChainsOnly = cp.FindChildInLayoutFile('id-major-store-filter-keychains').FindChildInLayoutFile('id-slider-btn');
        if (btnKeyChainsOnly.checked && btnKeyChainsOnly.enabled) {
            numFiltersSelected++;
            _MakeNavBarFilterButton(cp, elNavBarFiltersParent, btnKeyChainsOnly, '#major_store_filter_type_keychains_only', "id-filter-active-k-only");
        }
        const elSearchBox = cp.FindChildInLayoutFile('id-major-store-search-box');
        if (elSearchBox.text) {
            numFiltersSelected++;
            const elActiveFilterBtn = $.CreatePanel('Button', elNavBarFiltersParent, 'id-filter-active-search-txt');
            elActiveFilterBtn.BLoadLayoutSnippet('active-filter-button');
            elActiveFilterBtn.SetDialogVariable('search-text', elSearchBox.text);
            elActiveFilterBtn.SetDialogVariable('name', $.Localize('#major_store_filter_type_search_text', elActiveFilterBtn));
            elNavBarFiltersParent.MoveChildBefore(elActiveFilterBtn, elNavBarFiltersParent.Children()[0]);
            elActiveFilterBtn.SetPanelEvent('onactivate', () => {
                _ClearTextSearch(cp);
                _UpdateItemsList({ cp });
                elActiveFilterBtn.DeleteAsync(0);
            });
        }
        cp.FindChildInLayoutFile('id-filter-active-clear_all').visible = numFiltersSelected > 1;
        cp.FindChildInLayoutFile('id-major-store-filters-clear').visible = numFiltersSelected > 1;
        let sortDirection = 'asc';
        let sortType = elDropDown.GetSelected().id || 'weekly-high-low';
        switch (sortType) {
            case 'price-high-low':
                sortDirection = 'desc';
                sortType = 'price';
            case 'price-low-high':
                sortType = 'price';
                break;
            case 'popularity-high-low':
                sortDirection = 'desc';
                sortType = 'popularity';
                break;
            case 'popularity-low-high':
                sortType = 'popularity';
                break;
            case 'weekly-high-low':
                sortDirection = 'desc';
                sortType = 'weeklyPctReductionFromHigh';
                break;
            case 'weekly-low-high':
                sortType = 'weeklyPctReductionFromHigh';
                break;
        }
        return btnKeyChainsOnly.checked
            ? {
                selectedTeamIds: aTeams.flatMap(team => team.Data().teamid).filter(x => false),
                sort: sortType,
                rarity: aRarities.flatMap(panel => panel.Data().rarity).filter(x => false),
                teamsOnly: false,
                playersOnly: false,
                keyChainsOnly: true,
                sortDirection: sortDirection,
                price: priceFilter,
                searchText: elSearchBox.text
            }
            : {
                selectedTeamIds: aTeams.flatMap(team => team.Data().teamid),
                sort: sortType,
                rarity: aRarities.flatMap(panel => panel.Data().rarity),
                teamsOnly: btnTeamOnly.checked,
                playersOnly: btnPlayerOnly.checked,
                keyChainsOnly: false,
                sortDirection: sortDirection,
                price: priceFilter,
                searchText: elSearchBox.text
            };
    }
    function _MakeNavBarFilterButton(cp, elParent, selectedFilterBtn, locString, idForBtn) {
        const elActiveFilterBtn = $.CreatePanel('Button', elParent, idForBtn);
        elActiveFilterBtn.BLoadLayoutSnippet('active-filter-button');
        elActiveFilterBtn.SetDialogVariable('name', $.Localize(locString, selectedFilterBtn));
        elActiveFilterBtn.SetPanelEvent('onactivate', () => {
            selectedFilterBtn.checked = false;
            if (elActiveFilterBtn.id === 'id-filter-active-k-only') {
                const elFilterPanel = cp.FindChildInLayoutFile('id-major-store-filters-panel');
                elFilterPanel.FindChildrenWithClassTraverse('major-filter-panel__toggle').forEach(btn => {
                    btn.enabled = true;
                });
                const elDropDown = cp.FindChildInLayoutFile('id-major-store-sort-dropdown');
                elDropDown.SetSelected('weekly-high-low');
            }
            _UpdateItemsList({ cp });
            elActiveFilterBtn.DeleteAsync(0);
        });
    }
    function _OnActivateClearAll(cp, doNotClearSearch = false) {
        const elFilterPanel = cp.FindChildInLayoutFile('id-major-store-filters-panel');
        elFilterPanel.FindChildInLayoutFile('id-major-store-filter-keychains').FindChildInLayoutFile('id-slider-btn').checked = false;
        elFilterPanel.FindChildrenWithAttributeTraverse('filter-button').forEach(btn => { btn.checked = false, btn.enabled = true; });
        if (!cp.Data().useBookMarkList) {
            cp.Data().useBookMarkList = false;
        }
        if (!doNotClearSearch) {
            _ClearTextSearch(cp);
        }
        const elDropDown = cp.FindChildInLayoutFile('id-major-store-sort-dropdown');
        elDropDown.SetSelected('weekly-high-low');
    }
    function _ClearTextSearch(cp) {
        const elSearchBox = cp.FindChildInLayoutFile('id-major-store-search-box');
        elSearchBox.ClearSelection();
        elSearchBox.text = '';
    }
    function _SetUpKeyChainsPage(cp) {
        cp.Data().aFlatKeyChainData;
        const elParent = cp.FindChildInLayoutFile('id-major-store-keychains');
        const numStages = g_ActiveTournamentHighlights.length;
        for (let i = numStages - 1; i >= 0; --i) {
            const stage = g_ActiveTournamentHighlights[i];
            let elPanel = elParent.FindChildInLayoutFile('id-keychains-stage-' + stage.group_id);
            if (!elPanel) {
                elPanel = $.CreatePanel('Panel', elParent, 'id-keychains-stage-' + stage.group_id);
                elPanel.BLoadLayoutSnippet('keychain-section');
                elPanel.SetDialogVariable('stage-title', $.Localize('#CSGO_Tournament_Event_Stage_' + stage.stage));
            }
            const keyChains = cp.Data().aFlatKeyChainData.filter((keychain) => keychain.stage === stage.stage);
            const elContainer = elPanel.FindChildInLayoutFile('id-keychains-container');
            keyChains.forEach((keychain, idx) => {
                let elTile = elParent.FindChildInLayoutFile('id-keychain-' + keychain.kc_highlight);
                if (!elTile) {
                    elTile = $.CreatePanel('Panel', elContainer, 'id-keychain-' + keychain.kc_highlight);
                    elTile.BLoadLayoutSnippet('store-tile');
                    elTile.SetHasClass('keychain', true);
                    elTile.SetHasClass('keychain-banner', true);
                }
                _UpdateKeyChainsTile(cp, elTile, keyChains, idx);
            });
        }
    }
    function _UpdateTile(cp, reusePanel, filteredList, nPanelIdx) {
        const stickerData = filteredList[nPanelIdx];
        reusePanel.SetDialogVariable('title', stickerData.isPlayer ?
            stickerData.playerCode :
            stickerData.isOrg ?
                g_ActiveTournamentInfo.organization :
                stickerData.teamName);
        _UpdatePriceAnimOnTile(stickerData, reusePanel, cp);
        _SetPriceDataOnTile(stickerData, reusePanel);
        _ShoppingCartControlsOnTile(stickerData, reusePanel);
        _UpdateBookmarkOnTile(stickerData.rawId, reusePanel, cp);
        reusePanel.FindChildInLayoutFile('id-store-item-rarity').SetImage('file://{images}/icons/ui/sticker_rarity_' + stickerData.rarity + '.svg');
        reusePanel.SwitchClass('rarity', 'rarity-' + stickerData.rarity);
        reusePanel.FindChildInLayoutFile('id-store-item-rarity-bar').style.washColor = InventoryAPI.GetItemRarityColor(stickerData.itemId);
        reusePanel.SetHasClass('is-final', false);
        reusePanel.FindChildInLayoutFile('id-store-item-hot-trend').SetHasClass('show', stickerData.popularityRank < 40);
        reusePanel.SetHasClass('is-player', stickerData.isPlayer);
        reusePanel.FindChildInLayoutFile('id-store-item-image').itemid = stickerData.itemId;
        reusePanel.FindChildInLayoutFile('id-store-item-team-logo').SetImage(stickerData.isOrg ?
            'file://{images}/tournaments/events/tournament_logo_' + g_ActiveTournamentInfo.eventid + '.svg' :
            'file://{images}/tournaments/teams/' + stickerData.teamTag + '.svg');
        const MapPanel = reusePanel.FindChildInLayoutFile('id-store-item-model');
        MapPanel.SetCamera('camera_weapon_7');
        MapPanel.SetActiveItem(0);
        MapPanel.SetItemItemId(stickerData.itemId, '');
        MapPanel.SetRotationLimits(60, 45);
        MapPanel.SetAutoRotateAmount(20, -2);
        MapPanel.SetAutoRotatePeriod(6, 6);
        let nRenderInterval = 1;
        MapPanel.SetRenderInterval(nRenderInterval);
        reusePanel.FindChildInLayoutFile('id-inspect-sticker').SetPanelEvent('onactivate', () => {
            _OpenFullscreenInspect(cp, stickerData);
        });
    }
    function _UpdateKeyChainsTile(cp, reusePanel, filteredList, nPanelIdx) {
        const keychainData = filteredList[nPanelIdx];
        reusePanel.SetDialogVariable('title', keychainData.name);
        _UpdatePriceAnimOnTile(keychainData, reusePanel, cp);
        _SetPriceDataOnTile(keychainData, reusePanel);
        _ShoppingCartControlsOnTile(keychainData, reusePanel);
        _UpdateBookmarkOnTile(keychainData.kc_highlight, reusePanel, cp);
        reusePanel.FindChildInLayoutFile('id-store-item-hot-trend').SetHasClass('show', false);
        reusePanel.SetHasClass('is-player', false);
        reusePanel.SetHasClass('is-final', keychainData.stage === 97);
        reusePanel.SetDialogVariable('stage', $.Localize('#CSGO_Tournament_Event_Stage_' + keychainData.stage));
        reusePanel.FindChildInLayoutFile('id-store-item-image').itemid = keychainData.itemId;
        reusePanel.FindChildInLayoutFile('id-store-item-team-1').SetImage('file://{images}/tournaments/teams/' + PredictionsAPI.GetTeamTag(keychainData.teamid1) + '.svg');
        reusePanel.FindChildInLayoutFile('id-store-item-team-2').SetImage('file://{images}/tournaments/teams/' + PredictionsAPI.GetTeamTag(keychainData.teamid2) + '.svg');
        reusePanel.FindChildInLayoutFile('id-store-item-team-bg-1').SetImage('file://{images}/tournaments/teams/' + PredictionsAPI.GetTeamTag(keychainData.teamid1) + '.svg');
        reusePanel.FindChildInLayoutFile('id-store-item-team-bg-2').SetImage('file://{images}/tournaments/teams/' + PredictionsAPI.GetTeamTag(keychainData.teamid2) + '.svg');
        reusePanel.SetPanelEvent('onmouseover', () => {
            if (jsTooltipDelayHandle) {
                $.CancelScheduled(jsTooltipDelayHandle);
                jsTooltipDelayHandle = null;
            }
            jsTooltipDelayHandle = $.Schedule(.4, () => {
                {
                    _ShowVideoClip(reusePanel, keychainData.itemId);
                }
            });
        });
        reusePanel.SetPanelEvent('onmouseout', () => {
            if (jsTooltipDelayHandle) {
                $.CancelScheduled(jsTooltipDelayHandle);
                jsTooltipDelayHandle = null;
            }
            _HideVideoClip(reusePanel, keychainData.itemId);
        });
        reusePanel.FindChildInLayoutFile('id-inspect-sticker').SetPanelEvent('onactivate', () => {
            _OpenFullscreenInspect(cp, keychainData);
        });
    }
    let jsTooltipDelayHandle = null;
    function _ShowVideoClip(elPanel, itemId) {
        const reelId = InventoryAPI.GetItemAttributeValue(itemId, '{uint32}keychain slot 0 highlight');
        if (reelId) {
            const reelJson = InventoryAPI.BuildHighlightReelSchemaJSON(reelId);
            const reelSchemaDef = JSON.parse(reelJson);
            const videoPlayerContainer = elPanel.FindChildTraverse('id-store-item-movie-container');
            const videoPlayer = elPanel.FindChildTraverse('id-store-item-movie');
            if (videoPlayerContainer && videoPlayer) {
                videoPlayerContainer.AddClass('play');
                videoPlayer.AddClass('play');
                videoPlayer.SetMovie(reelSchemaDef["url_480p"]);
                videoPlayer.Play();
            }
        }
    }
    function _HideVideoClip(elPanel, itemId) {
        if (InventoryAPI.GetItemAttributeValue(itemId, '{uint32}keychain slot 0 highlight')) {
            const videoPlayerContainer = elPanel.FindChildTraverse('id-store-item-movie-container');
            const videoPlayer = elPanel.FindChildTraverse('id-store-item-movie');
            if (videoPlayerContainer && videoPlayer) {
                videoPlayerContainer.RemoveClass('play');
                videoPlayer.RemoveClass('play');
                videoPlayer.Stop();
            }
        }
    }
    function _UpdatePriceAnimOnTile(stickerData, reusePanel, cp) {
        const elChange = reusePanel.FindChildInLayoutFile('id-store-item-price-change');
        if (stickerData.oldPrice !== undefined && stickerData.oldPrice !== stickerData.price) {
            const nDifference = stickerData.price - stickerData.oldPrice;
            reusePanel.SetDialogVariableInt('price-change', Math.abs(nDifference));
            elChange.SetHasClass('show-change', false);
            elChange.SwitchClass('direction', stickerData.price > stickerData.oldPrice ? 'higher' : 'lower');
            if (cp.Data().stopTileUpdate) {
                elChange.SetHasClass('show-change', true);
            }
            else {
                reusePanel.FindChildInLayoutFile('id-store-item-price-loading').visible = true;
                $.Schedule(1, () => {
                    reusePanel.FindChildInLayoutFile('id-store-item-price-loading').visible = false;
                    elChange.SetHasClass('show-change', true);
                });
            }
        }
        else
            elChange.SetHasClass('show-change', false);
    }
    function _SetPriceDataOnTile(stickerData, reusePanel) {
        reusePanel.SetDialogVariableInt('price', stickerData.price);
        reusePanel.SetDialogVariableInt('weeklyLow', stickerData.weeklyLow);
        reusePanel.SetDialogVariableInt('weeklyHigh', stickerData.weeklyHigh);
        let posDot = (stickerData.weeklyHigh > stickerData.weeklyLow)
            ? ((stickerData.price - stickerData.weeklyLow) / (stickerData.weeklyHigh - stickerData.weeklyLow)) * 100
            : 100;
        posDot = Math.floor(Math.max(0, Math.min(96, posDot)));
        reusePanel.FindChildInLayoutFile('id-store-item-price-pos').style.transform = 'translateX(' + posDot + '%)';
    }
    function _ShoppingCartControlsOnTile(stickerData, reusePanel) {
        const shopItem = { id: stickerData.itemId, name: stickerData.displayName, price: stickerData.price, oldPrice: stickerData.oldPrice };
        ShoppingCart.cart.subscribeToUpdates(reusePanel, 'tile-counter', () => {
            const quantityInCart = ShoppingCart.cart.getItemQuantity(stickerData.itemId);
            reusePanel.SetHasClass('show-quantity', quantityInCart > 0);
            reusePanel.SetDialogVariableInt('quantity', quantityInCart);
        });
        reusePanel.FindChildInLayoutFile('id-store-item-add-to-cart-btn').SetPanelEvent('onactivate', () => {
            ShoppingCart.cart.addItem(shopItem);
            if (ShoppingCart.cart.getItemQuantity(stickerData.itemId) >= 10 || ShoppingCart.cart.getTotalItems() >= 100) {
                $.DispatchEvent('CSGOPlaySoundEffect', 'UIPanorama.buymenu_failure', 'MOUSE');
                return;
            }
            $.DispatchEvent('CSGOPlaySoundEffect', 'UIPanorama.generic_button_press', 'MOUSE');
        });
        reusePanel.FindChildInLayoutFile('id-store-item-remove-from-cart-btn').SetPanelEvent('onactivate', () => {
            ShoppingCart.cart.decrementItem(shopItem.id);
            $.DispatchEvent('CSGOPlaySoundEffect', 'UIPanorama.generic_button_press', 'MOUSE');
        });
    }
    function _UpdateBookmarkOnTile(defidx, reusePanel, cp) {
        const elBookmark = reusePanel.FindChildInLayoutFile('id-store-item-bookmark');
        elBookmark.checked = _IsItemBookmarked(defidx);
        elBookmark.SetPanelEvent('onactivate', () => {
            _UpdateBookmarkSetting(cp, reusePanel, defidx);
        });
    }
    function _OpenFullscreenInspect(cp, itemData) {
        function _Callback() {
            _UpdateVisiblePanel(cp);
        }
        ;
        const callback = UiToolkitAPI.RegisterJSCallback(_Callback);
        const elPanel = UiToolkitAPI.ShowCustomLayoutPopup('', 'file://{resources}/layout/popups/popup_inventory_inspect.xml');
        let oSettings = {
            item_id: itemData.itemId,
            inspect_only: true,
            hide_all_action_items: true,
            price_in_tokens: itemData.price,
            sticker_def_index: 'rawId' in itemData ? itemData.rawId : itemData.kc_highlight,
            callback_handle: callback
        };
        elPanel.Data().oSettings = oSettings;
    }
    function _GetFilteredSortedIds(oSettings) {
        let aFilteredStickers;
        let bNoFilter = true;
        const cp = oSettings.cp;
        const FilterSortSettings = _UpdateFilterSettings(cp);
        const btnKeyChainsToggle = cp.FindChildInLayoutFile('id-major-store-filter-keychains').FindChildInLayoutFile('id-slider-btn');
        const elSearchBox = cp.FindChildInLayoutFile('id-major-store-search-box');
        if (elSearchBox.text) {
            const searchResults = _GetItemsForSearch(cp, elSearchBox.text);
            aFilteredStickers = btnKeyChainsToggle.checked ? searchResults.keychainResults : searchResults.stickerResults;
            bNoFilter = false;
        }
        else if (cp.Data().useBookMarkList) {
            aFilteredStickers = _GetBookmarkedItemsList(cp);
        }
        else {
            aFilteredStickers = aFilteredStickers = btnKeyChainsToggle.checked ? cp.Data().aFlatKeyChainData : cp.Data().aFlatStickersData;
        }
        if (FilterSortSettings.selectedTeamIds.length > 0) {
            bNoFilter = false;
            aFilteredStickers = aFilteredStickers.filter(sticker => FilterSortSettings.selectedTeamIds.includes(sticker.teamId));
        }
        if (FilterSortSettings.playersOnly || FilterSortSettings.teamsOnly || FilterSortSettings.keyChainsOnly) {
            bNoFilter = false;
            aFilteredStickers = aFilteredStickers.filter(sticker => (('kc_highlight' in sticker) && FilterSortSettings.keyChainsOnly) ||
                (!('kc_highlight' in sticker) && sticker.isPlayer && FilterSortSettings.playersOnly) ||
                (!('kc_highlight' in sticker) && !sticker.isPlayer && FilterSortSettings.teamsOnly));
        }
        if (FilterSortSettings.rarity.length > 0) {
            bNoFilter = false;
            aFilteredStickers = aFilteredStickers.filter(sticker => FilterSortSettings.rarity.includes(sticker.rarity));
        }
        cp.FindChildInLayoutFile('id-major-store-content').SetHasClass('no-filters', bNoFilter);
        if (FilterSortSettings.sort !== 'default') {
            const nSortDirection = ((FilterSortSettings.sortDirection === 'asc') ? 1 : -1);
            const filterSetting = FilterSortSettings.sort;
            return [...aFilteredStickers].sort((a, b) => {
                let aField = a[filterSetting];
                let bField = b[filterSetting];
                if (filterSetting === 'name') {
                    aField = aField.toLowerCase();
                    bField = bField.toLowerCase();
                }
                if (aField != bField)
                    return ((aField < bField) ? -1 : 1) * nSortDirection;
                if (a.popularity != b.popularity)
                    return b.popularity - a.popularity;
                else if (a.price != b.price)
                    return b.price - a.price;
                else
                    return a.rawId - b.rawId;
            });
        }
        ;
        return aFilteredStickers;
    }
    function _GetFilteredTeams(cp) {
        const elFilterPanel = cp.FindChildInLayoutFile('id-major-store-filters-panel');
        let elTeams = elFilterPanel.FindChildInLayoutFile('id-major-store-filter-section-teams');
        return [...elTeams.Children().filter(panel => panel.checked && panel.enabled)];
    }
    function _GetFilteredRarities(cp) {
        const elFilterPanel = cp.FindChildInLayoutFile('id-major-store-filters-panel');
        let elRarities = elFilterPanel.FindChildInLayoutFile('id-major-store-filter-rarities');
        return elRarities.Children().filter(panel => panel.checked && panel.enabled);
    }
    function _SetUpFilterPanel(cp) {
        const elFilterPanel = cp.FindChildInLayoutFile('id-major-store-filters-panel');
        g_ActiveTournamentTeams.forEach((team, i) => {
            const elParent = elFilterPanel.FindChildInLayoutFile('id-major-store-filter-section-teams');
            let elTeam = elParent.FindChildInLayoutFile(g_ActiveTournamentTeams[i].team);
            if (!elTeam) {
                elTeam = $.CreatePanel('ToggleButton', elParent, g_ActiveTournamentTeams[i].team);
                elTeam.BLoadLayoutSnippet('filter-team-btn');
                elTeam.Data().team = g_ActiveTournamentTeams[i].team;
                elTeam.Data().teamid = g_ActiveTournamentTeams[i].teamid;
                elTeam.SetAttributeString('filter-button', 'true');
                elTeam.SetPanelEvent('onactivate', () => {
                    _UpdateItemsList({ cp });
                });
                elTeam.FindChildInLayoutFile('id-filter-icon').SetImage('file://{images}/tournaments/teams/' + g_ActiveTournamentTeams[i].team + '.svg');
                elTeam.FindChildInLayoutFile('id-filter-icon-blur').SetImage('file://{images}/tournaments/teams/' + g_ActiveTournamentTeams[i].team + '.svg');
            }
        });
        const aRarities = [3, 4, 5, 6];
        aRarities.forEach((r, index) => {
            const rarityBtn = elFilterPanel.FindChildInLayoutFile('id-major-store-filter-rarity-' + r);
            if (rarityBtn) {
                rarityBtn.SetDialogVariable('rarity', $.Localize('#major_store_filter_type_' + r));
                rarityBtn.FindChildInLayoutFile('id-filter-icon').SetImage('file://{images}/icons/ui/sticker_rarity_' + r + '.svg');
                rarityBtn.FindChildInLayoutFile('id-filter-icon-blur').SetImage('file://{images}/icons/ui/sticker_rarity_' + r + '.svg');
                rarityBtn.Data().rarity = r;
                rarityBtn.SetPanelEvent('onactivate', () => {
                    _UpdateItemsList({ cp });
                });
            }
        });
        elFilterPanel.FindChildInLayoutFile('id-major-store-filter-team').SetPanelEvent('onactivate', () => {
            _UpdateItemsList({ cp });
        });
        elFilterPanel.FindChildInLayoutFile('id-major-store-filter-player').SetPanelEvent('onactivate', () => {
            _UpdateItemsList({ cp });
        });
        const btnKeyChainsOnly = elFilterPanel.FindChildInLayoutFile('id-major-store-filter-keychains').FindChildInLayoutFile('id-slider-btn');
        btnKeyChainsOnly.SetDialogVariable('slide_toggle_text', $.Localize('#major_store_filter_info_keychains'));
        btnKeyChainsOnly.SetPanelEvent('onactivate', () => {
            _EnableDisableFilterPanelBtns(cp, btnKeyChainsOnly.checked);
            _UpdateItemsList({ cp });
        });
        const elClearBtn = elFilterPanel.FindChildInLayoutFile('id-major-store-filters-clear');
        elClearBtn.SetDialogVariable('name', $.Localize('#major_store_filter_type_clear_all'));
        elClearBtn.SetPanelEvent('onactivate', () => {
            _OnActivateClearAll(cp, false);
            _UpdateItemsList({ cp });
        });
        const elClearAllNavBtn = cp.FindChildInLayoutFile('id-filter-active-clear_all');
        elClearAllNavBtn.SetDialogVariable('name', $.Localize('#major_store_filter_type_clear_all'));
        elClearAllNavBtn.AddClass('clear-all');
        elClearAllNavBtn.visible = false;
        elClearAllNavBtn.SetPanelEvent('onactivate', () => {
            _OnActivateClearAll(cp, false);
            _UpdateItemsList({ cp });
            elClearAllNavBtn.visible = false;
        });
    }
    function _EnableDisableFilterPanelBtns(cp, btnKeyChainsOnly) {
        cp.FindChildrenWithClassTraverse('major-filter-panel__toggle').forEach(btn => {
            btn.enabled = !btnKeyChainsOnly;
        });
        const elDropDown = cp.FindChildInLayoutFile('id-major-store-sort-dropdown');
        elDropDown.SetSelected('weekly-high-low');
    }
    function _Debounce(cp, handleName, delay, fnAction) {
        if (cp.Data()[handleName]) {
            $.CancelScheduled(cp.Data()[handleName]);
            cp.Data()[handleName] = null;
        }
        cp.Data()[handleName] = $.Schedule(delay, fnAction);
    }
    function _GetItemsForSearch(cp, searchTxt) {
        const tokens = searchTxt.toLowerCase().trim().split(/\s+/).filter(t => t.length > 0);
        let stickerResults = [];
        let keychainResults = [];
        if (tokens.length === 0)
            return { stickerResults, keychainResults };
        const stickers = cp.Data().aFlatStickersData;
        const keychains = cp.Data().aFlatKeyChainData;
        const lowerTokens = tokens.map(t => t.toLowerCase());
        stickerResults = stickers.map(sticker => {
            let totalScore = 0;
            const hasMatch = lowerTokens.every(token => {
                let tokenScore = 0;
                const nick = sticker.playerCode.toLowerCase();
                const tag = (sticker.teamTag) ? sticker.teamTag.toLowerCase() : '';
                const rarity = sticker.rarityLookup.toLowerCase();
                const team = (sticker.teamName) ? sticker.teamName.toLowerCase() : '';
                const real = (sticker.realName) ? sticker.realName.toLowerCase() : '';
                if (nick === token || nick.startsWith(token))
                    tokenScore = 100;
                else if (nick.includes(token))
                    tokenScore = 80;
                else if (tag.includes(token))
                    tokenScore = 60;
                else if (rarity.includes(token))
                    tokenScore = 40;
                else if (team.includes(token) || real.includes(token))
                    tokenScore = 20;
                totalScore += tokenScore;
                return tokenScore > 0;
            });
            return { sticker, score: totalScore, isValid: hasMatch };
        })
            .filter(result => result.isValid)
            .sort((a, b) => b.score - a.score)
            .map(result => result.sticker);
        keychainResults = keychains.map(item => {
            let totalScore = 0;
            const hasMatch = lowerTokens.every(token => {
                let tokenScore = 0;
                const name = item.name ? item.name.toLowerCase() : '';
                const stage = item.stage ? $.Localize('#CSGO_Tournament_Event_Stage_' + item.stage).toLowerCase() : '';
                const team1 = item.teamid1 ? $.Localize('#CSGO_TeamID_' + item.teamid1).toLowerCase() : '';
                const team2 = item.teamid2 ? $.Localize('#CSGO_TeamID_' + item.teamid2).toLowerCase() : '';
                const mapName = item.map_name ? item.map_name.toLowerCase() : '';
                if (name === token || name.startsWith(token))
                    tokenScore = 100;
                else if (name.includes(token))
                    tokenScore = 80;
                else if (mapName.includes(token))
                    tokenScore = 60;
                else if (stage.includes(token))
                    tokenScore = 40;
                else if (team1.includes(token) || team2.includes(token))
                    tokenScore = 20;
                totalScore += tokenScore;
                return tokenScore > 0;
            });
            return { item, score: totalScore, isValid: hasMatch };
        })
            .filter(result => result.isValid)
            .sort((a, b) => b.score - a.score)
            .map(result => result.item);
        return { stickerResults, keychainResults };
    }
    function _ShowSearchResults(cp, oItems) {
        const elTextSearchFlyout = cp.FindChildInLayoutFile('id-major-fullscreen-text-search');
        const elResultsPanel = elTextSearchFlyout.FindChildInLayoutFile('id-search-list');
        elResultsPanel.Children().forEach(result => {
            result.DeleteAsync(0);
        });
        if (oItems.stickerResults.length < 1 && oItems.keychainResults.length < 1) {
            _PopOverlay();
            return;
        }
        cp.Data().useBookMarkList = false;
        _PushOverlay(cp, 'id-major-fullscreen-text-search');
        if (oItems.stickerResults.length > 0) {
            const elSection = $.CreatePanel('Panel', elResultsPanel, 'id-results-stickers', { class: 'major-search-results__section' });
            if (oItems.stickerResults.length > 1) {
                _MakeShowSearchResultsBtn(cp, elSection, oItems.stickerResults.length);
            }
            const elListParent = $.CreatePanel('Panel', elSection, '', { class: 'major-search-results__list' });
            oItems.stickerResults.forEach(item => {
                _MakeSearchTile(cp, elListParent, item);
            });
        }
        if (oItems.stickerResults.length > 0 && oItems.keychainResults.length > 0)
            $.CreatePanel('Panel', elResultsPanel, '', { class: 'major-search-results__section__separator' });
        if (oItems.keychainResults.length > 0) {
            const elSection = $.CreatePanel('Panel', elResultsPanel, 'id-results-keychains', { class: 'major-search-results__section' });
            if (oItems.keychainResults.length > 1) {
                _MakeShowSearchResultsBtn(cp, elSection, oItems.keychainResults.length);
            }
            const elListParent = $.CreatePanel('Panel', elSection, '', { class: 'major-search-results__list' });
            oItems.keychainResults.forEach(item => {
                _MakeSearchTile(cp, elListParent, item);
            });
        }
    }
    function _MakeShowSearchResultsBtn(cp, elSection, count) {
        const elPanel = $.CreatePanel('Button', elSection, '');
        elPanel.SetDialogVariableInt('results-count', count);
        elPanel.BLoadLayoutSnippet('search-result-show-all');
        elPanel.SetDialogVariable('search-text', cp.FindChildInLayoutFile('id-major-store-search-box').text);
        const bIsKeychains = elSection.id !== 'id-results-stickers';
        elPanel.FindChildInLayoutFile('id-results-btn-label').text = $.Localize(bIsKeychains ? '#major_store_search_see_all_keychains' : '#major_store_search_see_all_stickers', elPanel);
        elPanel.SetPanelEvent('onactivate', () => {
            _OnActivateClearAll(cp, true);
            _PopOverlay();
            cp.FindChildInLayoutFile('id-major-store-filter-keychains').FindChildInLayoutFile('id-slider-btn').checked = bIsKeychains;
            _EnableDisableFilterPanelBtns(cp, bIsKeychains);
            if (m_activeMain?.id === 'id-major-store-content') {
                _UpdateItemsList({ cp });
            }
            else
                _ShowMainPanel(cp, 'id-major-store-content');
        });
    }
    function _MakeSearchTile(cp, elSection, item) {
        const bIsSticker = ('rawId' in item);
        const elTile = $.CreatePanel('Button', elSection, '');
        elTile.BLoadLayoutSnippet('search-result');
        elTile.FindChildInLayoutFile('id-result-icon').itemid = item.itemId;
        item.displayName.SetOnLabel(elTile.FindChildInLayoutFile('id-result-name'));
        elTile.SetDialogVariableInt('price', item.price);
        elTile.FindChildInLayoutFile('id-result-inspect').SetPanelEvent('onactivate', () => {
            _OpenFullscreenInspect(cp, item);
            _PopOverlay();
        });
        const elBookmark = elTile.FindChildInLayoutFile('id-store-item-bookmark');
        elBookmark.checked = _IsItemBookmarked(bIsSticker ? item.rawId : item.kc_highlight);
        elBookmark.SetPanelEvent('onactivate', () => {
            _UpdateBookmarkSetting(cp, elTile, bIsSticker ? item.rawId : item.kc_highlight);
        });
    }
    function OnSearchContextMenuCallBack(msg) {
    }
    function _ShowMainPanel(cp, panelId) {
        let nextPanel = cp.FindChildInLayoutFile(panelId);
        if (!nextPanel || nextPanel === m_activeMain)
            return;
        if (m_activeMain && m_activeMain.IsValid()) {
            if (m_activeMain.id === 'id-major-store-single-view' && panelId !== 'id-major-store-content') {
                nextPanel = cp.FindChildInLayoutFile('id-major-store-team-view');
                nextPanel.RemoveClass('hidden');
                m_activeMain = nextPanel;
            }
            if (panelId == 'id-major-store-banners') {
                _SetUpBookmarkItemsBanner(cp);
                _SetUpPopularityBanner(cp);
            }
            if (panelId == 'id-major-store-content') {
                _MakeDelayedLoadList(cp);
            }
            if (panelId == 'id-major-store-keychains') {
                _SetUpKeyChainsPage(cp);
            }
            m_activeMain.AddClass('hidden');
        }
        nextPanel.RemoveClass('hidden');
        m_activeMain = nextPanel;
        cp.FindChildInLayoutFile('id-popup-major-store-close-btn').visible = m_activeMain.id == 'id-major-store-banners';
        _UpdateBackButton(cp);
        $.DispatchEvent('CSGOPlaySoundEffect', 'inventory_inspect_close', 'MOUSE');
    }
    function _UpdateBackButton(cp) {
        const btn = cp.FindChildInLayoutFile('id-popup-major-store-back-btn');
        btn.visible = !('id-major-store-banners' === m_activeMain?.id);
    }
    function _PushOverlay(cp, panelId) {
        const overlay = $.GetContextPanel().FindChildTraverse(panelId);
        if (!overlay || m_overlayStack.includes(overlay))
            return;
        m_overlayStack.push(overlay);
        overlay.RemoveClass('hidden');
    }
    function _PopOverlay() {
        const topOverlay = m_overlayStack.pop();
        if (topOverlay && topOverlay.IsValid()) {
            topOverlay.AddClass('hidden');
            return true;
        }
        return false;
    }
    function OnCancelPressed() {
        if (m_overlayStack.includes($.GetContextPanel().FindChildInLayoutFile('id-major-store-loading'))) {
            return true;
        }
        if (m_overlayStack.length > 0) {
            const topOverlay = m_overlayStack.pop();
            $.GetContextPanel().FindChildTraverse(topOverlay.id).AddClass('hidden');
            return true;
        }
        if (m_activeMain?.IsValid() && m_activeMain && m_activeMain.id !== 'id-major-store-banners') {
            _ShowMainPanel($.GetContextPanel(), 'id-major-store-banners');
            return true;
        }
        ClosePopup();
        return true;
    }
    PopupMajorStore.OnCancelPressed = OnCancelPressed;
    {
        $.RegisterEventHandler('ReadyForDisplay', $.GetContextPanel(), ReadyForDisplay);
        $.RegisterEventHandler('UnreadyForDisplay', $.GetContextPanel(), UnreadyForDisplay);
        $.GetContextPanel().RegisterForReadyEvents(true);
        if ($.GetContextPanel().BReadyForDisplay()) {
            ReadyForDisplay();
        }
    }
})(PopupMajorStore || (PopupMajorStore = {}));
