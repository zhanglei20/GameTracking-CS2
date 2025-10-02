"use strict";
/// <reference path="../csgo.d.ts" />
/// <reference path="popup_capability_header.ts" />
/// <reference path="popup_inspect_action-bar.ts" />
/// <reference path="../common/iteminfo.ts" />
/// <reference path="../inspect.ts" />
var SelectItemForCapability;
(function (SelectItemForCapability) {
    let _m_cp = $.GetContextPanel();
    let _m_elItemList = _m_cp.FindChildInLayoutFile('id-popup-select-item-list');
    SelectItemForCapability.oCapabilityInfo = {
        capability: '',
        initialItemId: '',
        multiselectItemIds: {},
        multiselectItemIdsArray: [],
        popupVisible: false,
        bWorkshopItemPreview: false,
        bIsMultiSelect: false
    };
    function Init() {
        SelectItemForCapability.oCapabilityInfo.initialItemId = _m_cp.GetAttributeString('itemid', '');
        SelectItemForCapability.oCapabilityInfo.secondaryItemId = _m_cp.GetAttributeString('secondaryItemid', '');
        SelectItemForCapability.oCapabilityInfo.bWorkshopItemPreview = _m_cp.GetAttributeString("bWorkshopItemPreview", 'false') === 'true' ? true : false;
        SelectItemForCapability.oCapabilityInfo.capability = _m_cp.GetAttributeString("capability", '');
        SelectItemForCapability.oCapabilityInfo.bIsMultiSelect = (SelectItemForCapability.oCapabilityInfo.capability === "casketstore" || SelectItemForCapability.oCapabilityInfo.capability === "casketretrieve");
        SelectItemForCapability.oCapabilityInfo.popupVisible = true;
        $.DispatchEvent('CapabilityPopupIsOpen', true);
        _m_cp.FindChildInLayoutFile('id-initial-item-image').itemid = SelectItemForCapability.oCapabilityInfo.initialItemId;
        _m_elItemList.SetHasClass('inv-multi-select-allow', SelectItemForCapability.oCapabilityInfo.bIsMultiSelect);
        _m_cp.SetDialogVariable('item-name', InventoryAPI.GetItemName(SelectItemForCapability.oCapabilityInfo.initialItemId));
        _SetTitle();
        let elDropDownParent = _m_cp.FindChildInLayoutFile('id-dropdown-container');
        _AddSortDropdownToNavBar(elDropDownParent);
        _UpdateMultiSelectDisplay();
    }
    SelectItemForCapability.Init = Init;
    function _SetTitle() {
        let szPrefixString = '#inv_select_item_use_capability';
        if (SelectItemForCapability.oCapabilityInfo.capability === 'can_stattrack_swap') {
            szPrefixString = InventoryAPI.IsTool(SelectItemForCapability.oCapabilityInfo.initialItemId) ?
                '#inv_select_item_use_capability' :
                '#inv_select_item_stattrack_swap_capability';
        }
        else if (SelectItemForCapability.oCapabilityInfo.capability === 'can_collect') {
            let defName = InventoryAPI.GetItemDefinitionName(SelectItemForCapability.oCapabilityInfo.initialItemId);
            szPrefixString = (defName === 'casket') ?
                '#inv_select_item_tostoreincasket' :
                '#inv_select_casketitem_tostorethis';
        }
        else if (SelectItemForCapability.oCapabilityInfo.capability === 'casketcontents') {
            szPrefixString = '#inv_select_casketcontents';
        }
        else if (SelectItemForCapability.oCapabilityInfo.capability === 'casketretrieve') {
            szPrefixString = '#inv_select_casketretrieve';
        }
        else if (SelectItemForCapability.oCapabilityInfo.capability === 'casketstore') {
            szPrefixString = '#inv_select_casketstore';
        }
        _m_cp.SetDialogVariable('title', $.Localize(szPrefixString, _m_cp));
    }
    function _AddSortDropdownToNavBar(elDropDownParent) {
        let elDropdown = elDropDownParent.FindChildInLayoutFile('InvSortDropdown');
        let count = InventoryAPI.GetSortMethodsCount();
        for (let i = 0; i < count; i++) {
            let sort = InventoryAPI.GetSortMethodByIndex(i);
            let newEntry = $.CreatePanel('Label', elDropdown, sort, {
                class: 'DropDownMenu'
            });
            newEntry.text = $.Localize('#' + sort);
            elDropdown.AddOption(newEntry);
        }
        elDropdown.SetPanelEvent('oninputsubmit', () => UpdateSort());
        elDropdown.SetSelected(GameInterfaceAPI.GetSettingString("newest"));
    }
    function UpdateSort() {
        let elDropdown = _m_cp.FindChildInLayoutFile('InvSortDropdown');
        const sortString = (!elDropdown || !elDropdown.GetSelected()) ? 'newest' : elDropdown.GetSelected().id;
        let filterApplicationToPhantomItems = ItemInfo.IsFauxOrRentalOrPreviewTool(SelectItemForCapability.oCapabilityInfo.initialItemId) ? '' : ',is_rental:false,is_sealed:false';
        let capabilityFilter = SelectItemForCapability.oCapabilityInfo.capability + ':' + SelectItemForCapability.oCapabilityInfo.initialItemId + filterApplicationToPhantomItems;
        $.DispatchEvent('SetInventoryFilter', _m_elItemList, 'any', 'any', 'any', sortString, capabilityFilter, '');
        _ShowHideNoItemsMessage();
    }
    SelectItemForCapability.UpdateSort = UpdateSort;
    function _ShowHideNoItemsMessage() {
        let count = _m_elItemList.count;
        let elParent = _m_elItemList.GetParent();
        let elEmpty = elParent.FindChildInLayoutFile('id-select-item-empty-lister');
        if (count > 0) {
            elEmpty.visible = false;
            return;
        }
        let emptyText = '';
        elEmpty.SetDialogVariable('type', InventoryAPI.GetItemName(SelectItemForCapability.oCapabilityInfo.initialItemId));
        if ((SelectItemForCapability.oCapabilityInfo.capability === 'can_stattrack_swap') && !InventoryAPI.IsTool(SelectItemForCapability.oCapabilityInfo.initialItemId))
            emptyText = $.Localize('#inv_empty_lister_for_stattrackswap', elEmpty);
        else if (SelectItemForCapability.oCapabilityInfo.capability === 'can_collect')
            emptyText = $.Localize('#inv_empty_lister_nocaskets', elEmpty);
        else
            emptyText = $.Localize('#inv_empty_lister_for_use', elEmpty);
        elEmpty.SetDialogVariable('empty-text', emptyText);
        elEmpty.visible = true;
    }
    function _UpdateMultiSelectItemsList(itemid, bSelected) {
        if (bSelected) {
            if (!SelectItemForCapability.oCapabilityInfo.multiselectItemIds.hasOwnProperty(itemid)) {
                SelectItemForCapability.oCapabilityInfo.multiselectItemIds[itemid] = bSelected;
                SelectItemForCapability.oCapabilityInfo.multiselectItemIdsArray.push(itemid);
            }
        }
        else {
            if (SelectItemForCapability.oCapabilityInfo.multiselectItemIds.hasOwnProperty(itemid)) {
                delete SelectItemForCapability.oCapabilityInfo.multiselectItemIds[itemid];
                SelectItemForCapability.oCapabilityInfo.multiselectItemIdsArray.splice(SelectItemForCapability.oCapabilityInfo.multiselectItemIdsArray.indexOf(itemid), 1);
            }
        }
        _UpdateMultiSelectDisplay();
    }
    function _UpdateMultiSelectDisplay() {
        const elMultiSelectDisplay = _m_cp.FindChildInLayoutFile('id-popup-select-multi-item-display');
        if (!SelectItemForCapability.oCapabilityInfo.bIsMultiSelect) {
            elMultiSelectDisplay.visible = false;
            return;
        }
        SelectItemForCapability.oCapabilityInfo.capability === "";
        elMultiSelectDisplay.SetDialogVariableInt('count', SelectItemForCapability.oCapabilityInfo.multiselectItemIdsArray.length);
        _m_cp.FindChildInLayoutFile('id-popup-select-multi-item-btn').enabled = (SelectItemForCapability.oCapabilityInfo.multiselectItemIdsArray.length > 0);
        elMultiSelectDisplay.visible = true;
    }
    function ClosePopUp() {
        const callbackFunc = _m_cp.GetAttributeInt('callback', -1);
        if (callbackFunc != -1) {
            UiToolkitAPI.InvokeJSCallback(callbackFunc);
        }
        SelectItemForCapability.oCapabilityInfo.popupVisible = false;
        $.DispatchEvent('CSGOPlaySoundEffect', 'inventory_inspect_close', 'MOUSE');
        $.DispatchEvent('CapabilityPopupIsOpen', false);
        $.DispatchEvent('BlurPopupPanel', 'popup-lootlist-item-inspect-' + SelectItemForCapability.oCapabilityInfo.initialItemId, false);
        $.DispatchEvent('UIPopupButtonClicked', '');
    }
    SelectItemForCapability.ClosePopUp = ClosePopUp;
    function _OnItemTileActivated(itemTile, itemid) {
        $.DispatchEvent('CSGOPlaySoundEffect', 'inventory_item_select', 'MOUSE');
        if (SelectItemForCapability.oCapabilityInfo.capability === 'can_sticker') {
            _CapabilityCanStickerAction(SortIdsIntoToolAndItemID(itemid, SelectItemForCapability.oCapabilityInfo.initialItemId), SelectItemForCapability.oCapabilityInfo.bWorkshopItemPreview);
        }
        else if (SelectItemForCapability.oCapabilityInfo.capability === 'nameable') {
            _CapabilityNameableAction(SortIdsIntoToolAndItemID(itemid, SelectItemForCapability.oCapabilityInfo.initialItemId));
        }
        else if (SelectItemForCapability.oCapabilityInfo.capability === 'can_keychain') {
            _CapabilityCanKeychainAction(SortIdsIntoToolAndItemID(itemid, SelectItemForCapability.oCapabilityInfo.initialItemId), SelectItemForCapability.oCapabilityInfo.bWorkshopItemPreview);
        }
        else if (SelectItemForCapability.oCapabilityInfo.capability === 'remove_keychain') {
            _CapabilityRemoveKeychainAction(SortIdsIntoToolAndItemID(itemid, SelectItemForCapability.oCapabilityInfo.initialItemId));
        }
        else if (SelectItemForCapability.oCapabilityInfo.capability === 'can_patch') {
            _CapabilityCanPatchAction(SortIdsIntoToolAndItemID(itemid, SelectItemForCapability.oCapabilityInfo.initialItemId));
        }
        else if (SelectItemForCapability.oCapabilityInfo.capability === 'decodable') {
            _CapabilityDecodableAction(SortIdsIntoToolAndItemID(itemid, SelectItemForCapability.oCapabilityInfo.initialItemId));
        }
        else if (SelectItemForCapability.oCapabilityInfo.capability === 'can_stattrack_swap') {
            _CapabilityStatTrakSwapAction(SelectItemForCapability.oCapabilityInfo, itemid);
        }
        else if (SelectItemForCapability.oCapabilityInfo.capability === 'can_collect') {
            _CapabilityPutIntoCasketAction(itemid, SelectItemForCapability.oCapabilityInfo.initialItemId);
        }
        if (SelectItemForCapability.oCapabilityInfo.capability === 'casketretrieve') {
            itemTile.ToggleClass('capability_multistatus_selected');
            _UpdateMultiSelectItemsList(itemid, itemTile.BHasClass('capability_multistatus_selected'));
            return;
        }
        else if (SelectItemForCapability.oCapabilityInfo.capability === 'casketstore') {
            itemTile.ToggleClass('capability_multistatus_selected');
            _UpdateMultiSelectItemsList(itemid, itemTile.BHasClass('capability_multistatus_selected'));
            return;
        }
        ClosePopUp();
    }
    function SortIdsIntoToolAndItemID(id, initalId) {
        let bIdIsTool = InventoryAPI.IsTool(id);
        let toolId = bIdIsTool ? id : initalId;
        let itemID = bIdIsTool ? initalId : id;
        return {
            tool: toolId,
            item: itemID
        };
    }
    ;
    function _CapabilityCanStickerAction(idsToUse, bWorkshopItemPreview) {
        const workshopPreview = bWorkshopItemPreview ? 'true' : 'false';
        UiToolkitAPI.ShowCustomLayoutPopupParameters('popup-inspect-' + idsToUse.item, 'file://{resources}/layout/popups/popup_capability_can_sticker.xml', 'toolid-and-itemid=' + idsToUse.tool + ',' + idsToUse.item +
            '&' + 'asyncworktype=can_sticker' +
            '&' + 'workshopPreview=' + workshopPreview);
    }
    ;
    function _CapabilityNameableAction(idsToUse) {
        UiToolkitAPI.ShowCustomLayoutPopupParameters('popup-inspect-' + idsToUse.item, 'file://{resources}/layout/popups/popup_capability_nameable.xml', 'nametag-and-itemtoname=' + idsToUse.tool + ',' + idsToUse.item +
            '&' + 'asyncworktype=nameable');
    }
    ;
    function _CapabilityCanKeychainAction(idsToUse, bWorkshopItemPreview) {
        const workshopPreview = bWorkshopItemPreview ? 'true' : 'false';
        UiToolkitAPI.ShowCustomLayoutPopupParameters('popup-inspect-' + idsToUse.item, 'file://{resources}/layout/popups/popup_capability_can_keychain.xml', 'toolid-and-itemid=' + idsToUse.tool + ',' + idsToUse.item +
            '&' + 'asyncworktype=can_keychain' +
            '&' + 'workshopPreview=' + workshopPreview);
    }
    ;
    function _CapabilityRemoveKeychainAction(idsToUse) {
        UiToolkitAPI.ShowCustomLayoutPopupParameters('popup-inspect-' + idsToUse.item, 'file://{resources}/layout/popups/popup_capability_can_keychain.xml', 'itemid=' + idsToUse.item +
            '&' + 'asyncworktype=remove_keychain');
    }
    ;
    function _CapabilityCanPatchAction(idsToUse) {
        UiToolkitAPI.ShowCustomLayoutPopupParameters('popup-inspect-' + idsToUse.item, 'file://{resources}/layout/popups/popup_capability_can_patch.xml', 'toolid-and-itemid=' + idsToUse.tool + ',' + idsToUse.item +
            '&' + 'asyncworktype=can_patch');
    }
    ;
    function _CapabilityDecodableAction(idsToUse) {
        UiToolkitAPI.ShowCustomLayoutPopupParameters('popup-inspect-' + idsToUse.item, 'file://{resources}/layout/popups/popup_capability_decodable.xml', 'key-and-case=' + idsToUse.tool + ',' + idsToUse.item +
            '&' + 'asyncworktype=decodeable');
    }
    ;
    function _CapabilityStatTrakSwapAction(capInfo, id) {
        if (InventoryAPI.IsTool(capInfo.initialItemId)) {
            const sWorkshop = false;
            $.DispatchEvent('CSGOPlaySoundEffect', 'tab_mainmenu_inventory', 'MOUSE');
            $.DispatchEvent('ShowSelectItemForCapabilityPopup', id, capInfo.initialItemId, capInfo.capability);
            ClosePopUp();
        }
        else {
            UiToolkitAPI.ShowCustomLayoutPopupParameters('', 'file://{resources}/layout/popups/popup_capability_can_stattrack_swap.xml', 'swaptool=' + capInfo.secondaryItemId +
                '&' + 'swapitem1=' + capInfo.initialItemId +
                '&' + 'swapitem2=' + id);
        }
    }
    ;
    function _CapabilityPutIntoCasketAction(idCasket, idItem, cap) {
        $.DispatchEvent('ContextMenuEvent', '');
        if (!cap) {
            $.DispatchEvent('HideSelectItemForCapabilityPopup');
            $.DispatchEvent('UIPopupButtonClicked', '');
            $.DispatchEvent('CapabilityPopupIsOpen', false);
        }
        if (InventoryAPI.GetItemAttributeValue(idCasket, 'modification date')) {
            UiToolkitAPI.ShowCustomLayoutPopupParameters('', 'file://{resources}/layout/popups/popup_casket_operation.xml', 'op=add' +
                (cap ? '&nextcapability=' + cap : '') +
                '&spinner=1' +
                '&casket_item_id=' + idCasket +
                '&subject_item_id=' + idItem);
        }
        else {
            let fauxNameTag = InventoryAPI.GetFauxItemIDFromDefAndPaintIndex(1200, 0);
            UiToolkitAPI.ShowCustomLayoutPopupParameters('', 'file://{resources}/layout/popups/popup_capability_nameable.xml', 'nametag-and-itemtoname=' + fauxNameTag + ',' + idCasket +
                '&' + 'asyncworktype=nameable' +
                '&' + 'asyncworkitemwarningtext=#popup_newcasket_warning');
        }
    }
    ;
    function ProceedForMultiStatusCapabilityPopup() {
        let capability = SelectItemForCapability.oCapabilityInfo.capability;
        let arrItemIDs = SelectItemForCapability.oCapabilityInfo.multiselectItemIdsArray;
        if (arrItemIDs.length <= 0)
            return;
        switch (capability) {
            case 'casketretrieve':
                {
                    let strItemIDs = arrItemIDs.join(",");
                    UiToolkitAPI.ShowCustomLayoutPopupParameters('', 'file://{resources}/layout/popups/popup_casket_operation.xml', 'op=remove' +
                        '&nextcapability=batch' +
                        '&spinner=1' +
                        '&casket_item_id=' + SelectItemForCapability.oCapabilityInfo.initialItemId +
                        '&subject_item_id=' + strItemIDs);
                    break;
                }
            case 'casketstore':
                {
                    let strItemIDs = arrItemIDs.join(",");
                    UiToolkitAPI.ShowCustomLayoutPopupParameters('', 'file://{resources}/layout/popups/popup_casket_operation.xml', 'op=add' +
                        '&nextcapability=batch' +
                        '&spinner=1' +
                        '&casket_item_id=' + SelectItemForCapability.oCapabilityInfo.initialItemId +
                        '&subject_item_id=' + strItemIDs);
                    break;
                }
        }
        ClosePopUp();
    }
    SelectItemForCapability.ProceedForMultiStatusCapabilityPopup = ProceedForMultiStatusCapabilityPopup;
    function _UpdateSelectItemForCapabilityPopup(capability, itemid, bSelected) {
        if (SelectItemForCapability.oCapabilityInfo.capability !== capability)
            return false;
        if (!itemid)
            return false;
        _UpdateMultiSelectItemsList(itemid, bSelected);
        UpdateSort();
        return true;
    }
    {
        $.RegisterForUnhandledEvent("OnItemTileActivated", _OnItemTileActivated);
        $.RegisterForUnhandledEvent('UpdateSelectItemForCapabilityPopup', _UpdateSelectItemForCapabilityPopup);
    }
})(SelectItemForCapability || (SelectItemForCapability = {}));
