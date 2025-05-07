"use strict";
/// <reference path="csgo.d.ts" />
/// <reference path="common/formattext.ts" />
/// <reference path="common/iteminfo.ts" />
/// <reference path="itemtile_store.ts" />
var RankUpRedemptionStore;
(function (RankUpRedemptionStore) {
    let m_redeemableBalance = 0;
    let m_timeStamp = -1;
    let m_timeoutScheduleHandle;
    let m_profileCustomizationHandler;
    let m_profileUpdateHandler;
    let m_registered = false;
    let m_schTimer;
    function _msg(text) {
    }
    function RegisterForInventoryUpdate() {
        if (m_registered)
            return;
        m_registered = true;
        _UpdateStoreState();
        CheckForPopulateItems();
        m_profileUpdateHandler = $.RegisterForUnhandledEvent('PanoramaComponent_MyPersona_InventoryUpdated', OnInventoryUpdated);
        m_profileCustomizationHandler = $.RegisterForUnhandledEvent('PanoramaComponent_Inventory_ItemCustomizationNotification', OnItemCustomization);
        $.GetContextPanel().RegisterForReadyEvents(true);
        $.RegisterEventHandler('ReadyForDisplay', $.GetContextPanel(), () => {
            _msg("READY FOR DISPLAY");
            _UpdateStoreState();
            CheckForPopulateItems(true);
            if (!m_profileUpdateHandler) {
                m_profileUpdateHandler = $.RegisterForUnhandledEvent('PanoramaComponent_MyPersona_InventoryUpdated', OnInventoryUpdated);
            }
            if (!m_profileCustomizationHandler) {
                m_profileCustomizationHandler = $.RegisterForUnhandledEvent('PanoramaComponent_Inventory_ItemCustomizationNotification', OnItemCustomization);
            }
        });
        $.RegisterEventHandler('UnreadyForDisplay', $.GetContextPanel(), () => {
            _msg("UN-READY FOR DISPLAY");
            if (m_schTimer) {
                $.CancelScheduled(m_schTimer);
                m_schTimer = null;
            }
            if (m_profileUpdateHandler) {
                $.UnregisterForUnhandledEvent('PanoramaComponent_MyPersona_InventoryUpdated', m_profileUpdateHandler);
                m_profileUpdateHandler = null;
            }
            if (m_profileCustomizationHandler) {
                $.UnregisterForUnhandledEvent('PanoramaComponent_Inventory_ItemCustomizationNotification', m_profileCustomizationHandler);
                m_profileCustomizationHandler = null;
            }
        });
    }
    ;
    function CheckForPopulateItems(bFirstTime = false, claimedItemId = '') {
        const objStore = GetPersonalStore();
        const genTime = objStore ? objStore.generation_time : 0;
        if (genTime != m_timeStamp || claimedItemId) {
            if (genTime != m_timeStamp) {
                m_timeStamp = genTime;
                GameInterfaceAPI.SetSettingString('cl_redemption_reset_timestamp', genTime);
            }
            PopulateItems(bFirstTime, claimedItemId);
        }
    }
    function _CreateItemPanel(itemId, index, bFirstTime, claimedItemId = '') {
        const bNoDropsEarned = itemId === '-';
        if (itemId !== '-' && (!InventoryAPI.IsItemInfoValid(itemId) || !InventoryAPI.IsValidItemID(itemId))) {
            _msg('item ' + itemId + ' is invalid');
            return;
        }
        const elItemContainer = $.GetContextPanel().FindChildTraverse('jsRrsItemContainer');
        let elGhostItem = elItemContainer.FindChildInLayoutFile('itemdrop-' + itemId);
        elGhostItem = $.CreatePanel('Panel', elItemContainer, 'itemdrop-' + index + '-' + itemId);
        elGhostItem.BLoadLayout('file://{resources}/layout/itemtile_store.xml', false, false);
        _AddTileToBlurPanel(elGhostItem);
        const oItemData = {
            id: itemId,
            isDropItem: true,
            noDropsEarned: bNoDropsEarned,
        };
        ItemTileStore.Init(elGhostItem, oItemData);
        elGhostItem.Data().itemid = itemId;
        elGhostItem.Data().cost = 1;
        elGhostItem.Data().index = index;
        if (bNoDropsEarned)
            return;
        _OnGhostItemActivate(elGhostItem, itemId);
    }
    function _AddTileToBlurPanel(elGhostItem) {
        let parent = elGhostItem;
        let newParent;
        let count = 0;
        while (newParent = parent.GetParent()) {
            if (newParent.id === 'id-rewards-background') {
                let blurTarget = newParent.FindChildInLayoutFile('id-rewards-background-blur');
                blurTarget.AddBlurPanel(elGhostItem);
                break;
            }
            if (count > 5)
                break;
            parent = newParent;
            count++;
        }
    }
    function _OnGhostItemActivate(elGhostItem, itemId) {
        if (!InventoryAPI.IsClaimedItem(itemId)) {
            elGhostItem.SetPanelEvent('onactivate', () => _OnItemSelected(elGhostItem));
            const elInspect = elGhostItem.FindChildTraverse('id-itemtile-store-inspect-btn');
            elInspect.SetPanelEvent('onactivate', () => {
                if (ItemInfo.ItemHasCapability(itemId, 'decodable') && !InventoryAPI.IsTool(itemId)) {
                    UiToolkitAPI.ShowCustomLayoutPopupParameters('popup-inspect-' + itemId, 'file://{resources}/layout/popups/popup_capability_decodable.xml', 'key-and-case=' + '' + ',' + itemId +
                        '&' + 'asyncworkitemwarning=no' +
                        '&' + 'inspectonly=true' +
                        '&' + 'asyncworktype=decodeable' +
                        '&' + 'onlyclosepurchasebar=true');
                }
                else {
                    UiToolkitAPI.ShowCustomLayoutPopupParameters('', 'file://{resources}/layout/popups/popup_inventory_inspect.xml', 'itemid=' + itemId +
                        '&' + 'inspectonly=true' +
                        '&' + 'showallitemactions=false' +
                        '&' + 'allowsave=false' +
                        'none');
                }
            });
        }
    }
    function GetPersonalStore() {
        let oStore = InventoryAPI.GetCacheTypeElementJSOByIndex("PersonalStore", 0);
        return oStore;
    }
    function PopulateItems(bFirstTime = false, claimedItemId = '') {
        _msg('PopulateItems');
        _msg('claimedItemId:' + claimedItemId);
        const objStore = InventoryAPI.GetPersonalStore();
        $.GetContextPanel().RemoveClass('waiting');
        if (bFirstTime) {
            $.GetContextPanel().TriggerClass('reveal-store');
        }
        const elItemContainer = $.GetContextPanel().FindChildTraverse('jsRrsItemContainer');
        let aSelectedItems = [];
        elItemContainer.Children().forEach(element => {
            if (element.BHasClass('selected')) {
                aSelectedItems.push(element.Data().index);
            }
        });
        elItemContainer.RemoveAndDeleteChildren();
        if (objStore) {
            const arrItemIds = objStore.items;
            for (let i = 0; i < arrItemIds.length; i++) {
                _CreateItemPanel(arrItemIds[i], i, bFirstTime, claimedItemId);
            }
        }
        _UpdateAllItemStyles();
        elItemContainer.Children().forEach((element, idx) => {
            if (claimedItemId) {
                aSelectedItems.forEach(selectedIndex => {
                    if (idx === selectedIndex) {
                        element.TriggerClass('reveal-anim');
                        $.DispatchEvent('CSGOPlaySoundEffect', 'UIPanorama.gift_claim', '');
                    }
                });
            }
        });
    }
    function _UpdateTime() {
        let secRemaining = StoreAPI.GetSecondsUntilXpRollover();
        $.GetContextPanel().SetDialogVariable('time-to-week-rollover', (secRemaining > 0) ? FormatText.SecondsToSignificantTimeString(secRemaining) : '');
        const xpBonuses = MyPersonaAPI.GetActiveXpBonuses();
        const bEligibleForCarePackage = xpBonuses.split(',').includes('2');
        if (bEligibleForCarePackage) {
            $.GetContextPanel().SetDialogVariable('frame-desc-text', $.Localize('#rankup_redemption_store_refresh', $.GetContextPanel()));
        }
        else {
            $.GetContextPanel().SetDialogVariable('frame-desc-text', $.Localize('#rankup_redemption_store_rollover_wait', $.GetContextPanel()));
        }
        m_schTimer = $.Schedule(30, _UpdateTime);
    }
    function _UpdateStoreState() {
        const objStore = GetPersonalStore();
        m_redeemableBalance = objStore ? objStore.redeemable_balance : 0;
        const elClaimButton = $.GetContextPanel().FindChildTraverse('jsRrsClaimButton');
        elClaimButton.enabled = m_redeemableBalance !== 0;
        elClaimButton.SetHasClass('hide', m_redeemableBalance === 0);
        if (m_redeemableBalance <= 0) {
            _CloseStore(objStore ? true : false);
        }
        else {
            _EnableStore();
        }
        _SetXpProgress();
        _UpdateTime();
    }
    function OnItemCustomization(numericType, type, itemid) {
        _msg('OnItemCustomization ' + numericType + ' ' + type + ' ' + itemid);
        if (type !== 'free_reward_redeemed')
            return;
        if (m_timeoutScheduleHandle) {
            $.CancelScheduled(m_timeoutScheduleHandle);
            m_timeoutScheduleHandle = null;
        }
        CheckForPopulateItems(false, itemid);
    }
    function OnInventoryUpdated() {
        _UpdateStoreState();
        _msg('OnInventoryUpdated ');
        CheckForPopulateItems();
    }
    function _GetSelectedItems() {
        let arrItems = [];
        const elItemContainer = $.GetContextPanel().FindChildTraverse('jsRrsItemContainer');
        for (let panel of elItemContainer.Children()) {
            if (panel.BHasClass('selected')) {
                arrItems.push({ item_id: panel.Data().itemid, cost: panel.Data().cost });
            }
        }
        return arrItems;
    }
    function _CalcPendingBalance() {
        return _GetSelectedItems().reduce((sum, item) => sum + item.cost, 0);
    }
    function _OnItemSelected(elPanel) {
        const elItemContainer = $.GetContextPanel().FindChildTraverse('jsRrsItemContainer');
        let aItemIds = _GetSelectedItems();
        if ((_CalcPendingBalance() + elPanel.Data().cost) <= m_redeemableBalance) {
            elPanel.SetHasClass('selected', !elPanel.BHasClass('selected'));
            if (!elPanel.BHasClass('selected')) {
                $.DispatchEvent('CSGOPlaySoundEffect', 'UIPanorama.gift_select', 'MOUSE');
            }
            else {
                $.DispatchEvent('CSGOPlaySoundEffect', 'UIPanorama.gift_deselect', 'MOUSE');
            }
        }
        else {
            if (aItemIds.find(element => element.item_id === elPanel.Data().itemid)) {
                elPanel.SetHasClass('selected', !elPanel.BHasClass('selected'));
                if (!elPanel.BHasClass('selected')) {
                    $.DispatchEvent('CSGOPlaySoundEffect', 'UIPanorama.gift_select', 'MOUSE');
                }
                else {
                    $.DispatchEvent('CSGOPlaySoundEffect', 'UIPanorama.gift_deselect', 'MOUSE');
                }
            }
        }
        for (let element of elItemContainer.Children()) {
            const bCantAffordClicked = !elPanel.BHasClass('selected') && _CalcPendingBalance() + elPanel.Data().cost > m_redeemableBalance;
            if (bCantAffordClicked) {
                if (element.BHasClass('selected')) {
                    element.TriggerClass('pulse-me');
                    $.DispatchEvent('CSGOPlaySoundEffect', 'UIPanorama.buymenu_failure', 'MOUSE');
                }
            }
        }
        _UpdateAllItemStyles();
    }
    function _UpdateAllItemStyles() {
        const elItemContainer = $.GetContextPanel().FindChildTraverse('jsRrsItemContainer');
        for (let element of elItemContainer.Children()) {
            const bCantAfford = !element.BHasClass('selected') && !element.BHasClass('item-claimed') && _CalcPendingBalance() + element.Data().cost > m_redeemableBalance;
            element.SetHasClass('cant-afford', bCantAfford);
            element.SetHasClass('disabled', bCantAfford || element.BHasClass('item-claimed'));
        }
    }
    function _CloseStore(bHasStore) {
        _EnableDisableStorePanels(false);
        $.GetContextPanel().AddClass('store-closed');
        if (bHasStore) {
            $.GetContextPanel().SetDialogVariable('frame-badge-text', $.Localize('#rankup_redemption_store_closed', $.GetContextPanel()));
        }
        else {
            $.GetContextPanel().SetDialogVariable('frame-badge-text', $.Localize('#rankup_redemption_store_earn_xp', $.GetContextPanel()));
        }
    }
    function _EnableStore() {
        _msg('_EnableStore ');
        $.GetContextPanel().RemoveClass('waiting');
        $.GetContextPanel().RemoveClass('store-closed');
        $.GetContextPanel().SetDialogVariableInt('redeemable_balance', m_redeemableBalance);
        $.GetContextPanel().SetDialogVariable('frame-badge-text', $.Localize('#rankup_redemption_store_directive', $.GetContextPanel()));
        _EnableDisableStorePanels(true);
    }
    function _EnableDisableStorePanels(enableStore) {
        _msg('_enableStore ' + enableStore);
        $.GetContextPanel().Children().forEach(elPanel => {
            elPanel.enabled = enableStore;
        });
        const elItemContainer = $.GetContextPanel().FindChildTraverse('jsRrsItemContainer');
        for (let panel of elItemContainer.Children()) {
            panel.hittest = enableStore;
            panel.hittestchildren = enableStore;
        }
    }
    function _PulseItems() {
        const elItemContainer = $.GetContextPanel().FindChildTraverse('jsRrsItemContainer');
        for (let panel of elItemContainer.Children()) {
            if (!panel.BHasClass('item-claimed')) {
                panel.TriggerClass('pulse-me');
                $.DispatchEvent('CSGOPlaySoundEffect', 'UIPanorama.buymenu_failure', 'MOUSE');
            }
        }
    }
    function OnRedeem() {
        if (_GetSelectedItems().length === 0) {
            _PulseItems();
            return;
        }
        let szItemList = _GetSelectedItems().map(item => item.item_id).join(',');
        StoreAPI.StoreRedeemFreeRewards(szItemList);
        $.GetContextPanel().AddClass('waiting');
        _EnableDisableStorePanels(true);
        m_timeoutScheduleHandle = $.Schedule(10, _RedemptionTimedOut);
    }
    RankUpRedemptionStore.OnRedeem = OnRedeem;
    function _RedemptionTimedOut() {
        m_timeoutScheduleHandle = null;
        UiToolkitAPI.ShowGenericPopup($.Localize('#rankup_redemption_store_timeout_title'), $.Localize('#rankup_redemption_store_timeout_desc'), '');
        _EnableStore();
    }
    function _SetXpProgress() {
        const currentPoints = FriendsListAPI.GetFriendXp(MyPersonaAPI.GetXuid());
        const pointsPerLevel = MyPersonaAPI.GetXpPerLevel();
        let elXpBarInner = $.GetContextPanel().FindChildInLayoutFile('JsPlayerXpBarInner');
        let percentComplete = (currentPoints / pointsPerLevel) * 100;
        elXpBarInner.style.width = percentComplete + '%';
        elXpBarInner.GetParent().visible = true;
        const xpBonuses = MyPersonaAPI.GetActiveXpBonuses();
        const bEligibleForCarePackage = xpBonuses.split(',').includes('2');
        $.GetContextPanel().SetHasClass('care-package-eligible', bEligibleForCarePackage);
        const currentLvl = FriendsListAPI.GetFriendLevel(MyPersonaAPI.GetXuid());
        let elRankIcon = $.GetContextPanel().FindChildInLayoutFile('JsPlayerXpIcon');
        elRankIcon.SetImage('file://{images}/icons/xp/level' + currentLvl + '.png');
        if (bEligibleForCarePackage) {
            $.GetContextPanel().SetDialogVariable('frame-desc-text', $.Localize('#rankup_redemption_store_refresh', $.GetContextPanel()));
        }
        else {
            $.GetContextPanel().SetDialogVariable('frame-desc-text', $.Localize('#rankup_redemption_store_rollover_wait', $.GetContextPanel()));
        }
    }
    {
        $.GetContextPanel().RegisterForReadyEvents(true);
        RegisterForInventoryUpdate();
    }
})(RankUpRedemptionStore || (RankUpRedemptionStore = {}));
