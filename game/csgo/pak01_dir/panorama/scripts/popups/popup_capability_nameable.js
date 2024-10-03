"use strict";
/// <reference path="../csgo.d.ts" />
/// <reference path="../inspect.ts" />
/// <reference path="popup_inspect_async-bar.ts" />
/// <reference path="popup_inspect_purchase-bar.ts" />
/// <reference path="popup_capability_header.ts" />
/// <reference path="popup_acknowledge_item.ts" />
var CapabilityNameable;
(function (CapabilityNameable) {
    let m_Inspectpanel = $.GetContextPanel();
    let m_elTextEntry = $.GetContextPanel().FindChildInLayoutFile('NameableTextEntry');
    let m_elRemoveConfirm = $.GetContextPanel().FindChildInLayoutFile('NameableRemoveConfirm');
    let m_elValidBtn = $.GetContextPanel().FindChildInLayoutFile('NameableValidBtn');
    let m_elRemoveBtn = $.GetContextPanel().FindChildInLayoutFile('NameableRemoveBtn');
    let m_toolId = '';
    let m_itemIdRealOwned = '';
    let m_itemIdCreatedTemp = '';
    let m_strOriginalItemName = '';
    function Init() {
        let strMsg = $.GetContextPanel().GetAttributeString("nametag-and-itemtoname", "(not found)");
        let idList = strMsg.split(',');
        m_toolId = idList[0];
        m_itemIdRealOwned = idList[1];
        if (ItemInfo.IsWeapon(m_itemIdRealOwned)) {
            m_itemIdCreatedTemp = InventoryAPI.CreateTempCombinedItemWithTool(m_itemIdRealOwned, _GetNameTagFauxItemID());
        }
        else {
            m_itemIdCreatedTemp = m_itemIdRealOwned;
        }
        m_strOriginalItemName = InventoryAPI.HasCustomName(m_itemIdRealOwned) ? InventoryAPI.GetItemNameCustomized(m_itemIdRealOwned) : '';
        let defName = InventoryAPI.GetItemDefinitionName(m_itemIdRealOwned);
        $.GetContextPanel().SetHasClass('isstorageunit', (defName === 'casket'));
        _SetUpPanelElements();
        $.DispatchEvent('CapabilityPopupIsOpen', true);
    }
    CapabilityNameable.Init = Init;
    ;
    function _GetNameTagFauxItemID() {
        let nameTagStoreId = InventoryAPI.GetItemDefinitionIndexFromDefinitionName("Name Tag");
        let fakeItem = InventoryAPI.GetFauxItemIDFromDefAndPaintIndex(nameTagStoreId, 0);
        return fakeItem;
    }
    function _SetItemModel(id) {
        let elItemModelImagePanel = $.GetContextPanel().FindChildInLayoutFile('PopUpInspectModelOrImage');
        InspectModelImage.Init(elItemModelImagePanel, id);
        elItemModelImagePanel.AddClass('popup-inspect-modelpanel_darken');
        let elNameTagModel = $.GetContextPanel().FindChildInLayoutFile('id-inspect-nametag-model');
        if (elNameTagModel && elNameTagModel.IsValid()) {
            elNameTagModel.TransitionToCamera('cam_nametag', 1.0);
            elNameTagModel.SetItemModel('weapons/models/shared/nametag/nametag_module.vmdl');
            elNameTagModel.SetItemLabel('');
        }
    }
    ;
    function _RefreshItemPresentationWithUpdatedName(bNameTagModelVisible, strTextForTempItem) {
        if (m_itemIdCreatedTemp === m_itemIdRealOwned)
            return;
        let elItemModelImagePanel = $.GetContextPanel().FindChildInLayoutFile('PopUpInspectModelOrImage');
        if (elItemModelImagePanel && elItemModelImagePanel.IsValid()) {
            let elItemPanel = elItemModelImagePanel.FindChildInLayoutFile('ItemPreviewPanel');
            if (elItemPanel && elItemPanel.IsValid()) {
                elItemPanel.RefreshWeaponItemNameTag(m_itemIdCreatedTemp, strTextForTempItem);
            }
        }
        let elNameTagModel = $.GetContextPanel().FindChildInLayoutFile('id-inspect-nametag-model');
        if (elNameTagModel && elNameTagModel.IsValid()) {
            elNameTagModel.visible = bNameTagModelVisible;
        }
    }
    function _SetUpPanelElements() {
        if (!m_toolId) {
            $.GetContextPanel().SetAttributeString('asyncworkitemwarning', 'no');
        }
        else {
            $.GetContextPanel().SetAttributeString('toolid', m_toolId);
        }
        _SetUpAsyncActionBar(m_itemIdRealOwned);
        _ShowPurchase(m_toolId);
        _SetupHeader(m_itemIdRealOwned);
        _SetItemModel(m_itemIdCreatedTemp);
        let noTool = (m_toolId === '');
        let hasName = InventoryAPI.HasCustomName(m_itemIdRealOwned);
        _SetUpButtonStates(m_itemIdRealOwned, hasName, noTool);
        _UpdateAcceptState(false);
    }
    ;
    function _SetUpAsyncActionBar(itemId) {
        let elAsyncActionBarPanel = $.GetContextPanel().FindChildInLayoutFile('PopUpInspectAsyncBar');
        InspectAsyncActionBar.Init(elAsyncActionBarPanel, itemId, _GetSettingCallback, _AsyncActionPerformedCallback);
    }
    ;
    function _ShowPurchase(toolId) {
        let elPurchase = $.GetContextPanel().FindChildInLayoutFile('PopUpInspectPurchaseBar');
        let fakeItem = '';
        if (!toolId) {
            fakeItem = _GetNameTagFauxItemID();
            $.GetContextPanel().SetAttributeString('purchaseItemId', fakeItem);
        }
        InspectPurchaseBar.Init(elPurchase, fakeItem, _GetSettingCallback);
    }
    ;
    function _SetupHeader(itemId) {
        let elCapabilityHeaderPanel = $.GetContextPanel().FindChildInLayoutFile('PopUpCapabilityHeader');
        CapabilityHeader.Init(elCapabilityHeaderPanel, itemId, _GetSettingCallback);
    }
    function _GetSettingCallback(settingname, defaultvalue) {
        return m_Inspectpanel.GetAttributeString(settingname, defaultvalue);
    }
    ;
    function _AsyncActionPerformedCallback() {
        m_Inspectpanel.FindChildInLayoutFile('NameableRemoveConfirm').enabled = false;
        m_Inspectpanel.FindChildInLayoutFile('NameableValidBtn').enabled = false;
    }
    ;
    function _SetUpButtonStates(itemId, hasName, noTool) {
        let elAsyncActionBarPanel = $.GetContextPanel().FindChildInLayoutFile('PopUpInspectAsyncBar');
        InspectAsyncActionBar.EnableDisableOkBtn(elAsyncActionBarPanel, false);
        m_elValidBtn.SetHasClass('hidden', noTool);
        m_elValidBtn.SetPanelEvent('onactivate', () => {
            $.DispatchEvent("CSGOPlaySoundEffect", "rename_select", "MOUSE");
            InspectAsyncActionBar.EnableDisableOkBtn(elAsyncActionBarPanel, true);
            m_elTextEntry.enabled = false;
            m_elRemoveBtn.SetHasClass('hidden', false);
            m_elValidBtn.SetHasClass('hidden', true);
            _UpdateAcceptState(true);
        });
        m_elRemoveBtn.SetPanelEvent('onactivate', _RemoveButtonAction);
        m_elRemoveConfirm.SetPanelEvent('onactivate', _OnRemoveConfirm.bind(undefined, itemId));
        const defName = InventoryAPI.GetItemDefinitionName(itemId);
        m_elRemoveConfirm.SetHasClass('hidden', !hasName || defName === 'casket' || defName === 'pet');
        m_elTextEntry.SetFocus();
        m_elTextEntry.SetMaxChars(20);
        m_elTextEntry.text = _SetDefaultTextForTextEntry(hasName, itemId);
    }
    ;
    function _RemoveButtonAction() {
        let elAsyncActionBarPanel = $.GetContextPanel().FindChildInLayoutFile('PopUpInspectAsyncBar');
        InspectAsyncActionBar.EnableDisableOkBtn(elAsyncActionBarPanel, false);
        m_elTextEntry.enabled = true;
        m_elTextEntry.SetFocus();
        m_elRemoveBtn.SetHasClass('hidden', true);
        m_elValidBtn.SetHasClass('hidden', false);
        m_elTextEntry.text = '';
        if (m_itemIdCreatedTemp !== m_itemIdRealOwned) {
            InventoryAPI.SetNameToolString(m_strOriginalItemName, '');
            _RefreshItemPresentationWithUpdatedName(true, m_strOriginalItemName);
        }
    }
    function _SetDefaultTextForTextEntry(hasName, itemId) {
        if (m_elTextEntry.text !== '') {
            return m_elTextEntry.text;
        }
        if (!hasName) {
            return '';
        }
        let nameWithQuotes = InventoryAPI.GetItemName(itemId);
        if (nameWithQuotes && nameWithQuotes.length > 4
            && nameWithQuotes[0] == "'" && nameWithQuotes[1] == "'"
            && nameWithQuotes[nameWithQuotes.length - 1] == "'" && nameWithQuotes[nameWithQuotes.length - 2] == "'") {
            return nameWithQuotes.substr(2, nameWithQuotes.length - 4);
        }
        else {
            return nameWithQuotes;
        }
    }
    ;
    function _OnRemoveConfirm(itemId) {
        let temp = UiToolkitAPI.ShowGenericPopupOkCancel($.Localize('#popup_nameable_remove_confirm_title'), $.Localize('#tooltip_nameable_remove'), '', () => {
            InventoryAPI.ClearCustomName(itemId);
            ClosePopup();
            $.DispatchEvent('HideSelectItemForCapabilityPopup');
        }, () => { });
    }
    ;
    function OnEntryChanged() {
        let elNameTagModel = $.GetContextPanel().FindChildInLayoutFile('id-inspect-nametag-model');
        if (elNameTagModel && elNameTagModel.IsValid()) {
            elNameTagModel.SetItemLabel(m_elTextEntry.text);
            $.DispatchEvent("CSGOPlaySoundEffect", "rename_teletype", "MOUSE");
            _UpdateAcceptState(false);
        }
    }
    CapabilityNameable.OnEntryChanged = OnEntryChanged;
    ;
    function _UpdateAcceptState(bApplyToItem) {
        if (m_itemIdCreatedTemp === m_itemIdRealOwned)
            bApplyToItem = false;
        let isValid = InventoryAPI.SetNameToolString(m_elTextEntry.text, '');
        m_elValidBtn.enabled = isValid;
        m_elValidBtn.SetPanelEvent('onmouseover', () => {
            if (!isValid)
                UiToolkitAPI.ShowTextTooltip('NameableValidBtn', '#tooltip_nameable_invalid');
        });
        m_elValidBtn.SetPanelEvent('onmouseout', () => {
            UiToolkitAPI.HideTextTooltip();
        });
        if (bApplyToItem) {
            _RefreshItemPresentationWithUpdatedName(false, m_elTextEntry.text);
        }
    }
    ;
    function _NameTagAcquired(ItemId) {
        if (m_toolId === '') {
            if (ItemInfo.IsNameTag(ItemId)) {
                m_toolId = ItemId;
                $.DispatchEvent('HideStoreStatusPanel');
                _SetUpPanelElements();
                _AcknowlegeNameTags();
            }
        }
    }
    ;
    function _AcknowlegeNameTags() {
        let bShouldAcknowledge = true;
        AcknowledgeItems.GetItemsByType(['name tag'], bShouldAcknowledge);
    }
    ;
    function ClosePopup() {
        let elAsyncActionBarPanel = $.GetContextPanel().FindChildInLayoutFile('PopUpInspectAsyncBar');
        let elPurchase = $.GetContextPanel().FindChildInLayoutFile('PopUpInspectPurchaseBar');
        if (!elAsyncActionBarPanel.BHasClass('hidden')) {
            InspectAsyncActionBar.OnEventToClose();
        }
        else if (!elPurchase.BHasClass('hidden')) {
            InspectPurchaseBar.ClosePopup();
        }
    }
    CapabilityNameable.ClosePopup = ClosePopup;
    ;
    $.RegisterForUnhandledEvent('PanoramaComponent_Store_PurchaseCompleted', _NameTagAcquired);
    $.RegisterForUnhandledEvent('CSGOShowMainMenu', Init);
    $.RegisterForUnhandledEvent('PopulateLoadingScreen', ClosePopup);
})(CapabilityNameable || (CapabilityNameable = {}));
