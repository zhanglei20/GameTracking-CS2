"use strict";
/// <reference path="csgo.d.ts" />
/// <reference path="common/iteminfo.ts" />
/// <reference path="notification/notification_equip.ts" />
/// <reference path="popups/popup_acknowledge_item.ts" />
/// <reference path="mainmenu_inventory_search.ts" />
var InventoryPanel;
(function (InventoryPanel) {
    let _m_activeCategory;
    let _m_elInventoryMain = $.GetContextPanel().FindChildInLayoutFile('InventoryMain');
    let _m_elSelectItemForCapabilityPopup = $.GetContextPanel().FindChildInLayoutFile('SelectItemForCapabilityPopup');
    let _m_elInventorySearch = $.GetContextPanel().FindChildInLayoutFile('InvSearchPanel');
    let _m_elInventoryNavBar = $.GetContextPanel().FindChildInLayoutFile('id-navbar-tabs');
    let _m_isCapabliltyPopupOpen = false;
    let _m_InventoryUpdatedHandler = null;
    let _m_bFilterRentals = false;
    let _m_HiddenContentClassname = 'mainmenu-content--hidden';
    function _Init() {
        if (!_m_InventoryUpdatedHandler) {
            _m_InventoryUpdatedHandler = $.RegisterForUnhandledEvent('PanoramaComponent_MyPersona_InventoryUpdated', _InventoryUpdated);
        }
        _RunEveryTimeInventoryIsShown();
        _CreateCategoriesNavBar();
        _InitMarketLink();
        _InitXrayBtn();
        _LoadEquipNotification();
        _ShowHideRentalTab();
    }
    function _RunEveryTimeInventoryIsShown() {
        _OnShowAcknowledgePanel();
        if (!MyPersonaAPI.IsInventoryValid() || !MyPersonaAPI.IsConnectedToGC()) {
            UiToolkitAPI.ShowGenericPopupOk($.Localize('#SFUI_SteamConnectionErrorTitle'), $.Localize('#SFUI_Steam_Error_LinkUnexpected'), '', () => $.DispatchEvent('HideContentPanel'));
        }
    }
    function _CreateCategoriesNavBar() {
        let aCategories = StripEmptyStringsFromArray(InventoryAPI.GetCategories().split(','));
        let elCategoryBtns = _CreateCatagoryBtns(aCategories);
        _CreateSubmenusAndListerPanelsForEachCategory(aCategories, _CreateInventoryContentPanel());
        $.DispatchEvent("Activated", elCategoryBtns.FindChildInLayoutFile(aCategories[0]), "mouse");
        elCategoryBtns.Children()[0].checked = true;
    }
    function _CreateCatagoryBtns(aCategories) {
        let elPanel = $.GetContextPanel().FindChildInLayoutFile('id-navbar-tabs-catagory-btns-container');
        for (let category of aCategories) {
            let elBtn = elPanel.FindChildInLayoutFile(category);
            if (!elBtn) {
                elBtn = $.CreatePanel('RadioButton', elPanel, category, {
                    class: 'content-navbar__tabs__btn', group: 'inv-top-nav'
                });
                let tag = category;
                let metaData = _GetMetadata(tag, '', '');
                let nameToken = _GetValueForKeyFromMetadata('nametoken', metaData);
                $.CreatePanel('Label', elBtn, '', {
                    text: '#' + nameToken
                });
                elBtn.SetAttributeString('tag', tag);
                elBtn.Data().tag = tag;
                elBtn.SetPanelEvent('onactivate', () => NavigateToTab(tag));
            }
        }
        return elPanel;
    }
    function _CreateInventoryContentPanel() {
        return $.CreatePanel('Panel', _m_elInventoryMain, 'InventoryMenuContent', {
            class: 'inv-category__list-container'
        });
    }
    function _CreateSubmenusAndListerPanelsForEachCategory(aCategories, elParent) {
        for (let tag of aCategories) {
            if (tag) {
                let subCategories = StripEmptyStringsFromArray(InventoryAPI.GetSubCategories(tag).split(','));
                let elCategory = $.CreatePanel('Panel', elParent, tag, {
                    class: 'inv-category'
                });
                _AddTransitionEventToPanel(elCategory);
                let elNavBar = _CreateNavBar(tag, elCategory);
                if (subCategories.length > 1) {
                    _MakeNavBarButtons(elNavBar, subCategories, (subCategory) => {
                        _UpdateFilterRentalBtnInCategoryVisibility(tag, subCategory);
                        _UpdateActiveInventoryList();
                    });
                }
                _AddSortDropdownToNavBar(elNavBar.GetParent(), false);
                if (tag === 'any' || tag === 'inv_group_equipment') {
                    _AddFilterToNavBar(elNavBar.GetParent());
                }
                $.CreatePanel('InventoryItemList', elCategory, tag + '-List');
            }
        }
    }
    function _AddTransitionEventToPanel(newPanel) {
        // @ts-ignore
        newPanel.OnPropertyTransitionEndEvent = (panelName, propertyName) => {
            if (newPanel.id === panelName && propertyName === 'opacity') {
                if (newPanel.visible === true && newPanel.BIsTransparent()) {
                    newPanel.visible = false;
                    return true;
                }
            }
            return false;
        };
        // @ts-ignore
        $.RegisterEventHandler('PropertyTransitionEnd', newPanel, newPanel.OnPropertyTransitionEndEvent);
    }
    function _CreateNavBar(idForNavBar, elParent) {
        let elNavBar = $.CreatePanel('Panel', elParent, idForNavBar + '-NavBarParent', {
            class: 'content-navbar__tabs content-navbar__tabs--dark content-navbar__tabs--noflow'
        });
        let elNavBarButtonsContainer = $.CreatePanel('Panel', elNavBar, idForNavBar + '-NavBar', {
            class: 'content-navbar__tabs__center-container'
        });
        elNavBarButtonsContainer.SetAttributeString('data-type', idForNavBar);
        return elNavBarButtonsContainer;
    }
    function _MakeNavBarButtons(elNavBar, listOfTags, onActivate) {
        let groupName = elNavBar.id;
        for (let tag of listOfTags) {
            let elButton = $.CreatePanel('RadioButton', elNavBar, tag + 'Btn', {
                group: groupName,
                class: 'content-navbar__tabs__btn'
            });
            let metaData = {};
            let catagory = elNavBar.GetAttributeString('data-type', '');
            if (catagory === "InvCategories")
                metaData = _GetMetadata(tag, '', '');
            else
                metaData = _GetMetadata(catagory, tag, '');
            let nameToken = _GetValueForKeyFromMetadata('nametoken', metaData);
            if (!nameToken) {
                nameToken = _GetValueForKeyFromMetadata('nameprefix', metaData);
                if (nameToken !== '')
                    nameToken = nameToken + tag;
            }
            if (nameToken) {
                $.CreatePanel('Label', elButton, '', {
                    text: '#' + nameToken
                });
            }
            else {
                let icon = _GetValueForKeyFromMetadata('usetournamenticons', metaData);
                if (icon) {
                    let imageIndex = tag.replace(/^\D+/g, '');
                    $.CreatePanel('Image', elButton, '', {
                        src: 'file://{images}/tournaments/events/tournament_logo_' + imageIndex + '.svg',
                        textureheight: '48',
                        scaling: 'stretch-to-fit-preserve-aspect'
                    });
                    nameToken = 'CSGO_Tournament_Event_NameShort_' + imageIndex;
                    elButton.SetPanelEvent('onmouseover', () => UiToolkitAPI.ShowTextTooltip(elButton.id, nameToken));
                    elButton.SetPanelEvent('onmouseout', () => UiToolkitAPI.HideTextTooltip());
                }
            }
            if (onActivate)
                elButton.SetPanelEvent('onactivate', () => onActivate(tag));
            elButton.SetAttributeString('data-type', tag);
            elButton.SetAttributeString('nice-name', nameToken);
        }
        elNavBar.GetChild(0).checked = true;
    }
    function _UpdateActiveInventoryList() {
        if (_m_activeCategory === "tradeup") {
            return;
        }
        let activePanel = _m_elInventoryMain.FindChildInLayoutFile(_m_activeCategory);
        _UpdateActiveItemList(_GetActiveCategoryLister(activePanel), _m_activeCategory, _GetSelectedSubCategory(activePanel), _GetSelectedSort(activePanel), _GetFilterRentedItemsSetting(activePanel));
    }
    function NavigateToTab(category) {
        if (_m_activeCategory !== category) {
            if (_m_activeCategory) {
                if (_m_activeCategory === 'tradeup') {
                    _UpdateCraftingPanelVisibility(false);
                }
                else if (_m_activeCategory === 'search') {
                    _UpdateSearchPanelVisibility(false);
                }
                else {
                    let panelToHide = _m_elInventoryMain.FindChildInLayoutFile(_m_activeCategory);
                    panelToHide.RemoveClass('Active');
                }
            }
            _m_activeCategory = category;
            if (category === "tradeup") {
                _UpdateCraftingPanelVisibility(true);
                $.GetContextPanel().FindChildInLayoutFile('InvCraftingBtn').checked = true;
            }
            else if (_m_activeCategory === 'search') {
                _UpdateSearchPanelVisibility(true);
                $.GetContextPanel().FindChildInLayoutFile('InvSearchPanel').checked = true;
            }
            else {
                let activePanel = _m_elInventoryMain.FindChildInLayoutFile(category);
                activePanel.AddClass('Active');
                activePanel.visible = true;
                activePanel.SetReadyForDisplay(true);
                _m_activeCategory = category;
                _UpdateFilterRentalBtnInCategoryVisibility(category);
                _UpdateActiveItemList(_GetActiveCategoryLister(activePanel), category, _GetSelectedSubCategory(activePanel), _GetSelectedSort(activePanel), _GetFilterRentedItemsSetting(activePanel));
            }
        }
    }
    InventoryPanel.NavigateToTab = NavigateToTab;
    function _AddSortDropdownToNavBar(elNavBar, bIsCapabliltyPopup) {
        let elDropdown = elNavBar.FindChildInLayoutFile('InvSortDropdown');
        if (!elDropdown) {
            let elDropdownParent = $.CreatePanel('Panel', elNavBar, 'InvExtraNavOptions', { class: 'overflow-noclip' });
            elDropdownParent.BLoadLayoutSnippet('InvSortDropdownSnippet');
            elDropdown = elDropdownParent.FindChildInLayoutFile('InvSortDropdown');
            let count = InventoryAPI.GetSortMethodsCount();
            for (let i = 0; i < count; i++) {
                let sort = InventoryAPI.GetSortMethodByIndex(i);
                let newEntry = $.CreatePanel('Label', elDropdownParent, sort, {
                    class: 'DropDownMenu'
                });
                newEntry.text = $.Localize('#' + sort);
                elDropdown.AddOption(newEntry);
            }
            if (!bIsCapabliltyPopup) {
                elDropdown.SetPanelEvent('oninputsubmit', () => _UpdateSort(elDropdown));
            }
            elDropdown.SetSelected(GameInterfaceAPI.GetSettingString("cl_inventory_saved_sort2"));
        }
    }
    function _AddFilterToNavBar(elNavBar) {
        let elFilter = elNavBar.FindChildInLayoutFile('InvFilterRentedItems');
        if (!elFilter) {
            let elFilter = $.CreatePanel('ToggleButton', elNavBar, 'InvFilterRentedItems', { class: 'overflow-noclip' });
            elFilter.BLoadLayoutSnippet('InvFilterRentedItemsSnippet');
            elFilter.SetPanelEvent('onactivate', () => {
                let activePanel = _m_elInventoryMain.FindChildInLayoutFile(_m_activeCategory);
                let elDropdown = elNavBar.FindChildInLayoutFile('InvSortDropdown');
                let dropdownSetting = elDropdown ? elDropdown.GetSelected().id : '';
                elFilter.checked = !_m_bFilterRentals;
                _m_bFilterRentals = elFilter.checked;
                let filterSetting = elFilter.checked ? 'is_rental:false' : '';
                _UpdateActiveItemList(_GetActiveCategoryLister(activePanel), _m_activeCategory, _GetSelectedSubCategory(activePanel), dropdownSetting, filterSetting);
            });
        }
    }
    function _GetFilterRentedItemsSetting(activePanel) {
        if (activePanel) {
            let elFilterBtn = activePanel.FindChildInLayoutFile('InvFilterRentedItems');
            return (elFilterBtn && elFilterBtn.checked) ? 'is_rental:false' : '';
        }
        return '';
    }
    function _UpdateFilterRentalBtnInCategoryVisibility(category, subCategory = '') {
        let elNavBtn = $.GetContextPanel().FindChildInLayoutFile(category + '-NavBarParent');
        if (!elNavBtn || !elNavBtn.IsValid()) {
            return;
        }
        let elFilterBtn = elNavBtn.FindChildInLayoutFile('InvFilterRentedItems');
        if (!elFilterBtn || !elFilterBtn.IsValid()) {
            return;
        }
        elFilterBtn.SetHasClass('hide', (category !== 'any' && category !== 'inv_group_equipment') ||
            !InventoryAPI.CategoryContainsItems('rentals') ||
            (subCategory === 'customplayer' ||
                subCategory === 'misc' ||
                subCategory === 'clothing_hands' ||
                subCategory === 'musickit'));
        if (!elFilterBtn.BHasClass('hide')) {
            elFilterBtn.checked = _m_bFilterRentals;
        }
    }
    function _UpdateSort(elDropdown) {
        let activePanel = _m_elInventoryMain.FindChildInLayoutFile(_m_activeCategory);
        if (activePanel) {
            _UpdateActiveItemList(_GetActiveCategoryLister(activePanel), _m_activeCategory, _GetSelectedSubCategory(activePanel), elDropdown.GetSelected().id, _GetFilterRentedItemsSetting(activePanel));
            if (typeof elDropdown.GetSelected().id === "string" && elDropdown.GetSelected().id !== GameInterfaceAPI.GetSettingString("cl_inventory_saved_sort2")) {
                GameInterfaceAPI.SetSettingString("cl_inventory_saved_sort2", elDropdown.GetSelected().id);
                GameInterfaceAPI.ConsoleCommand("host_writeconfig");
            }
        }
    }
    function _ShowHideXrayBtn() {
        let elXrayBtnContainer = $.GetContextPanel().FindChildInLayoutFile("InvXrayBtnContainer");
        let xrayRewardId = ItemInfo.GetItemsInXray().reward;
        let sRestriction = InventoryAPI.GetDecodeableRestriction('capsule');
        elXrayBtnContainer.visible = xrayRewardId !== '' &&
            xrayRewardId !== undefined &&
            xrayRewardId !== null &&
            (sRestriction === 'xray' || !InventoryAPI.IsFauxItemID(xrayRewardId));
    }
    function _InitMarketLink() {
        let elMarketLink = $.GetContextPanel().FindChildInLayoutFile("InvMarketBtn");
        if (MyPersonaAPI.GetLauncherType() === "perfectworld") {
            elMarketLink.SetHasClass('hide', true);
            return;
        }
        elMarketLink.SetHasClass('hide', false);
        elMarketLink.SetPanelEvent('onactivate', onActivate);
        let appId = SteamOverlayAPI.GetAppID();
        let communityUrl = SteamOverlayAPI.GetSteamCommunityURL();
        function onActivate() {
            SteamOverlayAPI.OpenURL(communityUrl + "/market/search?q=&appid=" + appId + "&lock_appid=" + appId);
        }
    }
    function _InitXrayBtn() {
        _ShowHideXrayBtn();
        let elXrayBtn = $.GetContextPanel().FindChildInLayoutFile("InvXrayBtnContainer");
        elXrayBtn.SetPanelEvent('onactivate', () => {
            let oData = ItemInfo.GetItemsInXray();
            let keyId = ItemInfo.GetKeyForCaseInXray(oData.case);
            $.DispatchEvent("ShowXrayCasePopup", keyId, oData.case, false);
        });
    }
    function _GotoTradeUpPanel() {
        NavigateToTab('tradeup');
    }
    function _HideInventoryMainListers() {
        if (_m_activeCategory === "search") {
            $('#InvSearchPanel').AddClass(_m_HiddenContentClassname);
        }
        else if (_m_activeCategory === "tradeup") {
            $('#InvCraftingPanel').AddClass(_m_HiddenContentClassname);
        }
        else {
            _m_elInventoryMain.AddClass(_m_HiddenContentClassname);
        }
    }
    function _ShowInventoryMainListers() {
        if (_m_activeCategory === "search") {
            $('#InvSearchPanel').RemoveClass(_m_HiddenContentClassname);
        }
        else if (_m_activeCategory === "tradeup") {
            $('#InvCraftingPanel').RemoveClass(_m_HiddenContentClassname);
        }
        else {
            _m_elInventoryMain.RemoveClass(_m_HiddenContentClassname);
        }
    }
    function _UpdateCraftingPanelVisibility(bShow) {
        let elCrafting = $('#InvCraftingPanel');
        if (bShow) {
            if (elCrafting.BHasClass(_m_HiddenContentClassname)) {
                elCrafting.RemoveClass(_m_HiddenContentClassname);
                elCrafting.SetFocus();
                CloseSelectItemForCapabilityPopup();
                $.GetContextPanel().FindChildTraverse('Crafting-Items').SetReadyForDisplay(true);
                $.GetContextPanel().FindChildTraverse('Crafting-Ingredients').SetReadyForDisplay(true);
                let RecipeId = InventoryAPI.GetTradeUpContractItemID();
                let strCraftingFilter = InventoryAPI.GetItemAttributeValue(RecipeId, "recipe filter");
                InventoryAPI.ClearCraftIngredients();
                InventoryAPI.SetCraftTarget(Number(strCraftingFilter));
                $.DispatchEvent('UpdateTradeUpPanel');
            }
        }
        else {
            elCrafting.AddClass(_m_HiddenContentClassname);
            _m_elInventoryMain.SetFocus();
            $.GetContextPanel().FindChildTraverse('Crafting-Items').SetReadyForDisplay(false);
            $.GetContextPanel().FindChildTraverse('Crafting-Ingredients').SetReadyForDisplay(false);
            InventoryAPI.ClearCraftIngredients();
            return true;
        }
    }
    function _UpdateCraftingPanelContentsIfCrafting() {
        let elCrafting = $('#InvCraftingPanel');
        if (!elCrafting.BHasClass(_m_HiddenContentClassname)) {
            $.DispatchEvent('UpdateTradeUpPanel');
        }
    }
    function _UpdateSearchPanelVisibility(bShow) {
        let elSearch = $('#InvSearchPanel');
        if (bShow) {
            if (elSearch.BHasClass(_m_HiddenContentClassname)) {
                elSearch.RemoveClass(_m_HiddenContentClassname);
                elSearch.SetFocus();
                CloseSelectItemForCapabilityPopup();
            }
        }
        else {
            elSearch.AddClass(_m_HiddenContentClassname);
            _m_elInventoryMain.SetFocus();
            return true;
        }
    }
    function _ClosePopups() {
        // @ts-ignore
        if (_m_elInventoryMain.updatePlayerEquipSlotChangedHandler) {
            // @ts-ignore
            $.UnregisterForUnhandledEvent('PanoramaComponent_Loadout_EquipSlotChanged', _m_elInventoryMain.updatePlayerEquipSlotChangedHandler);
            // @ts-ignore
            _m_elInventoryMain.updatePlayerEquipSlotChangedHandler = null;
        }
        if (_m_InventoryUpdatedHandler) {
            $.UnregisterForUnhandledEvent('PanoramaComponent_MyPersona_InventoryUpdated', _m_InventoryUpdatedHandler);
            _m_InventoryUpdatedHandler = null;
        }
        if (!_m_elSelectItemForCapabilityPopup.BHasClass(_m_HiddenContentClassname)) {
            CloseSelectItemForCapabilityPopup();
            return true;
        }
        return false;
    }
    function _GetActiveCategoryLister(activePanel) {
        if (activePanel) {
            let elList = activePanel.FindChildInLayoutFile(_m_activeCategory + '-List');
            return (elList) ? elList : null;
        }
        return null;
    }
    function _GetSelectedSort(activePanel) {
        let elDropdown = null;
        if (activePanel) {
            elDropdown = activePanel.FindChildInLayoutFile('InvSortDropdown');
        }
        return (elDropdown) ? elDropdown.GetSelected().id : '';
    }
    function _GetSelectedSubCategoryPanel(activePanel) {
        if (!activePanel || !activePanel.IsValid()) {
            return null;
        }
        let elSubCategoryNavBar = activePanel.FindChildInLayoutFile(_m_activeCategory + '-NavBar');
        if (!elSubCategoryNavBar) {
            return null;
        }
        let tabs = elSubCategoryNavBar.Children();
        tabs = tabs.filter(e => e.checked);
        return tabs;
    }
    function _GetSelectedSubCategory(activePanel) {
        let tabs = _GetSelectedSubCategoryPanel(activePanel);
        return (tabs && tabs.length > 0) ? tabs[0].GetAttributeString('data-type', 'any') : 'any';
    }
    function StripEmptyStringsFromArray(dataRaw) {
        return dataRaw.filter(v => v !== '');
    }
    function _GetValueForKeyFromMetadata(key, metaData) {
        if (metaData.hasOwnProperty(key))
            return metaData[key];
        return '';
    }
    function _GetMetadata(category, subCategory, group) {
        return JSON.parse(InventoryAPI.GetInventoryStructureJSON(category, subCategory, group));
    }
    function _IsSearchActivePanel(category) {
        return category === 'InvSearchPanel';
    }
    function _UpdateActiveItemList(elListerToUpdate, category, subCategory, sortString, capabilityFilter) {
        if (!elListerToUpdate || !subCategory || !category) {
            return;
        }
        if (_IsSearchActivePanel(category)) {
            InventorySearch.UpdateItemList();
            return;
        }
        $.DispatchEvent('SetInventoryFilter', elListerToUpdate, category, subCategory, 'any', sortString, capabilityFilter, '');
        _ShowHideNoItemsMessage(elListerToUpdate, capabilityFilter);
    }
    function _ShowHideNoItemsMessage(elLister, capabilityFilter) {
        let count = elLister.count;
        let elParent = elLister.GetParent();
        let elEmpty = elParent.FindChildInLayoutFile('JsInvEmptyLister');
        if (count > 0) {
            if (elEmpty) {
                elEmpty.DeleteAsync(0.0);
            }
            return;
        }
        let elNewEmpty = elParent.FindChildInLayoutFile('JsInvEmptyLister');
        if (!elNewEmpty) {
            elNewEmpty = $.CreatePanel('Panel', elParent, 'JsInvEmptyLister');
            elNewEmpty.BLoadLayoutSnippet('InvEmptyLister');
            elParent.MoveChildBefore(elNewEmpty, elLister);
        }
        let activePanel = _m_elInventoryMain.FindChildInLayoutFile(_m_activeCategory);
        let elSubCat = _GetSelectedSubCategoryPanel(activePanel);
        let elLabel = elNewEmpty.FindChildInLayoutFile('JsInvEmptyListerLabel');
        if ((capabilityFilter != '') && (_SelectedCapabilityInfo.initialItemId != '')) {
            elLabel.SetDialogVariable('type', InventoryAPI.GetItemName(_SelectedCapabilityInfo.initialItemId));
            if ((_SelectedCapabilityInfo.capability === 'can_stattrack_swap') && !InventoryAPI.IsTool(_SelectedCapabilityInfo.initialItemId))
                elLabel.text = $.Localize('#inv_empty_lister_for_stattrackswap', elLabel);
            else if (_SelectedCapabilityInfo.capability === 'can_collect')
                elLabel.text = $.Localize('#inv_empty_lister_nocaskets', elLabel);
            else
                elLabel.text = $.Localize('#inv_empty_lister_for_use', elLabel);
        }
        else {
            const str = $.Localize("#" + elSubCat[0].GetAttributeString('nice-name', ''));
            elLabel.SetDialogVariable('type', str);
            elLabel.text = $.Localize('#inv_empty_lister', elLabel);
        }
    }
    function _OnReadyForDisplay() {
        _RunEveryTimeInventoryIsShown();
        _UpdateActiveInventoryList();
        _ShowHideRentalTab();
        _UpdateCraftingPanelContentsIfCrafting();
        // @ts-ignore
        if (!_m_elInventoryMain.updatePlayerEquipSlotChangedHandler) {
            // @ts-ignore
            _m_elInventoryMain.updatePlayerEquipSlotChangedHandler = $.RegisterForUnhandledEvent('PanoramaComponent_Loadout_EquipSlotChanged', _ShowNotification);
        }
        if (!_m_InventoryUpdatedHandler) {
            _m_InventoryUpdatedHandler = $.RegisterForUnhandledEvent('PanoramaComponent_MyPersona_InventoryUpdated', _InventoryUpdated);
        }
    }
    function _InventoryUpdated() {
        _ShowHideXrayBtn();
        _ShowHideRentalTab();
        _UpdateFilterRentalBtnInCategoryVisibility(_m_activeCategory);
        _UpdateCraftingPanelContentsIfCrafting();
        if ($.GetContextPanel().BHasClass(_m_HiddenContentClassname) || _m_isCapabliltyPopupOpen)
            return;
        _OnShowAcknowledgePanel();
        if (!_m_elInventorySearch.BHasClass(_m_HiddenContentClassname)) {
            InventorySearch.UpdateItemList();
        }
        else if (_m_activeCategory) {
            _UpdateActiveInventoryList();
        }
    }
    function _OnShowAcknowledgePanel() {
        let itemsToAcknowledge = AcknowledgeItems.GetItems();
        if (itemsToAcknowledge.length > 0) {
            $.DispatchEvent('ShowAcknowledgePopup', '', '');
        }
    }
    let _SelectedCapabilityInfo = {
        capability: '',
        initialItemId: '',
        secondaryItemId: '',
        multiselectItemIds: {},
        multiselectItemIdsArray: [],
        popupVisible: false,
        bWorkshopItemPreview: false
    };
    function GetCapabilityInfo() {
        return _SelectedCapabilityInfo;
    }
    InventoryPanel.GetCapabilityInfo = GetCapabilityInfo;
    function _PromptShowSelectItemForCapabilityPopup(titletxt, messagetxt, capability, itemid, itemid2) {
        UiToolkitAPI.ShowGenericPopupOkCancel($.Localize(titletxt), $.Localize(messagetxt), '', () => $.DispatchEvent("ShowSelectItemForCapabilityPopup", capability, itemid, itemid2), () => { });
    }
    function _ShowSelectItemForCapability(capability, itemid, itemid2, bWorkshopItemPreview) {
        $.DispatchEvent('CSGOPlaySoundEffect', 'tab_mainmenu_inventory', 'MOUSE');
        _m_elSelectItemForCapabilityPopup.RemoveClass(_m_HiddenContentClassname);
        _m_elSelectItemForCapabilityPopup.SetFocus();
        _HideInventoryMainListers();
        _m_elInventoryNavBar.SetHasClass('collapse', true);
        _SelectedCapabilityInfo.capability = capability;
        _SelectedCapabilityInfo.initialItemId = itemid;
        _SelectedCapabilityInfo.secondaryItemId = itemid2;
        _SelectedCapabilityInfo.multiselectItemIds = {};
        _SelectedCapabilityInfo.multiselectItemIdsArray = [];
        _SelectedCapabilityInfo.popupVisible = true;
        _SelectedCapabilityInfo.bWorkshopItemPreview = bWorkshopItemPreview;
        let elDropDownParent = _m_elSelectItemForCapabilityPopup.FindChildInLayoutFile('CapabilityPopupSortContainer');
        _AddSortDropdownToNavBar(elDropDownParent, true);
        let elDropdown = elDropDownParent.FindChildInLayoutFile('InvSortDropdown');
        elDropdown.SetPanelEvent('oninputsubmit', () => _UpdatePopup(itemid, capability));
        _UpdatePopup(itemid, capability);
    }
    function _ShowSelectItemForCapabilityPopup(capability, itemid, itemid2) {
        _ShowSelectItemForCapability(capability, itemid, itemid2, false);
    }
    function _ShowSelectItemForWorkshopPreviewCapability(capability, itemid, itemid2) {
        _ShowSelectItemForCapability(capability, itemid, itemid2, true);
    }
    function CloseSelectItemForCapabilityPopup() {
        $.DispatchEvent('CSGOPlaySoundEffect', 'inventory_inspect_close', 'MOUSE');
        _m_elInventoryNavBar.SetHasClass('collapse', false);
        if (_m_elSelectItemForCapabilityPopup.BHasClass(_m_HiddenContentClassname)) {
            return;
        }
        _m_elSelectItemForCapabilityPopup.AddClass(_m_HiddenContentClassname);
        _m_elInventoryMain.SetFocus();
        _SelectedCapabilityInfo.popupVisible = false;
        _ShowInventoryMainListers();
        return true;
    }
    InventoryPanel.CloseSelectItemForCapabilityPopup = CloseSelectItemForCapabilityPopup;
    function _UpdatePopup(id, capability) {
        let elList = _m_elSelectItemForCapabilityPopup.FindChildInLayoutFile('ItemListForCapability');
        if (!elList)
            elList = $.CreatePanel('InventoryItemList', _m_elSelectItemForCapabilityPopup, 'ItemListForCapability');
        elList.SetHasClass('inv-multi-select-allow', capability === "casketstore" || capability === "casketretrieve");
        let filterApplicationToPhantomItems = ItemInfo.IsFauxOrRentalOrPreviewTool(id) ? '' : ',is_rental:false,is_sealed:false';
        let capabilityFilter = capability + ':' + id + filterApplicationToPhantomItems;
        _UpdateActiveItemList(elList, 'any', 'any', _GetSelectedSort(_m_elSelectItemForCapabilityPopup.FindChildInLayoutFile('CapabilityPopupSortContainer')), capabilityFilter);
        _SetUpCasketPopup(capability, elList);
        _SetCapabilityPopupTitle(id, capability);
    }
    function _SetUpCasketPopup(capability, elList) {
        let elActionBar = _m_elSelectItemForCapabilityPopup.FindChildInLayoutFile('CapabilityPopupActionBar');
        if (capability === "casketstore" || capability === "casketretrieve") {
            elList.SetAttributeInt("capability_multistatus_selected", 1);
            if (!elActionBar) {
                elActionBar = $.CreatePanel('Panel', _m_elSelectItemForCapabilityPopup, 'CapabilityPopupActionBar', { class: "content-controls-actions-bar" });
                elActionBar.BLoadLayoutSnippet('CapabilityActionBar');
            }
            elList.SetHasClass('inv-item-list-fill-height-flow', true);
            _UpdateMultiSelectDisplay(elActionBar.FindChildInLayoutFile('CapabilityPopupMultiStatus'));
        }
        else {
            elList.SetAttributeInt("capability_multistatus_selected", 0);
            if (elActionBar) {
                elActionBar.DeleteAsync(0.0);
            }
            elList.SetHasClass('inv-item-list-fill-height-flow', false);
        }
    }
    function _SetCapabilityPopupTitle(id, capability) {
        let elPrefixString = _m_elSelectItemForCapabilityPopup.FindChildInLayoutFile('CapPrefixItemLabel');
        let szPrefixString = '#inv_select_item_use';
        if (capability === 'can_stattrack_swap') {
            szPrefixString = InventoryAPI.IsTool(id) ?
                '#inv_select_item_use' :
                '#inv_select_item_stattrack_swap';
        }
        else if (capability === 'can_collect') {
            let defName = InventoryAPI.GetItemDefinitionName(id);
            szPrefixString = (defName === 'casket') ?
                '#inv_select_item_tostoreincasket' :
                '#inv_select_casketitem_tostorethis';
        }
        else if (capability === 'casketcontents') {
            szPrefixString = '#inv_select_casketcontents';
        }
        else if (capability === 'casketretrieve') {
            szPrefixString = '#inv_select_casketretrieve';
        }
        else if (capability === 'casketstore') {
            szPrefixString = '#inv_select_casketstore';
        }
        elPrefixString.text = szPrefixString;
        let elImage = _m_elSelectItemForCapabilityPopup.FindChildInLayoutFile('CapItemImage');
        elImage.itemid = id;
        let elLabel = _m_elSelectItemForCapabilityPopup.FindChildInLayoutFile('CapItemName');
        elLabel.text = InventoryAPI.GetItemName(id);
    }
    function _UpdateSelectItemForCapabilityPopup(capability, itemid, bSelected) {
        if (!_m_elSelectItemForCapabilityPopup || !_m_elSelectItemForCapabilityPopup.IsValid())
            return false;
        let elMultiItemPortion = _m_elSelectItemForCapabilityPopup.FindChildInLayoutFile('CapabilityPopupMultiStatus');
        if (!elMultiItemPortion || !elMultiItemPortion.IsValid())
            return false;
        if (_SelectedCapabilityInfo.capability !== capability)
            return false;
        if (!itemid)
            return false;
        if (bSelected) {
            if (!_SelectedCapabilityInfo.multiselectItemIds.hasOwnProperty(itemid)) {
                _SelectedCapabilityInfo.multiselectItemIds[itemid] = bSelected;
                _SelectedCapabilityInfo.multiselectItemIdsArray.push(itemid);
            }
        }
        else {
            if (_SelectedCapabilityInfo.multiselectItemIds.hasOwnProperty(itemid)) {
                delete _SelectedCapabilityInfo.multiselectItemIds[itemid];
                _SelectedCapabilityInfo.multiselectItemIdsArray.splice(_SelectedCapabilityInfo.multiselectItemIdsArray.indexOf(itemid), 1);
            }
        }
        _UpdateMultiSelectDisplay(elMultiItemPortion);
        return true;
    }
    function _UpdateMultiSelectDisplay(elMultiItemPortion) {
        elMultiItemPortion.SetDialogVariableInt('count', _SelectedCapabilityInfo.multiselectItemIdsArray.length);
        elMultiItemPortion.FindChildInLayoutFile('CapabilityPopupMultiStatusBtn').enabled = (_SelectedCapabilityInfo.multiselectItemIdsArray.length > 0);
    }
    function ProceedForMultiStatusCapabilityPopup() {
        let capability = _SelectedCapabilityInfo.capability;
        let arrItemIDs = _SelectedCapabilityInfo.multiselectItemIdsArray;
        CloseSelectItemForCapabilityPopup();
        $.DispatchEvent('ContextMenuEvent', '');
        $.DispatchEvent('HideSelectItemForCapabilityPopup');
        $.DispatchEvent('UIPopupButtonClicked', '');
        $.DispatchEvent('CapabilityPopupIsOpen', false);
        if (arrItemIDs.length <= 0)
            return;
        switch (capability) {
            case 'casketretrieve':
                {
                    let strItemIDs = arrItemIDs.join(",");
                    UiToolkitAPI.ShowCustomLayoutPopupParameters('', 'file://{resources}/layout/popups/popup_casket_operation.xml', 'op=remove' +
                        '&nextcapability=batch' +
                        '&spinner=1' +
                        '&casket_item_id=' + _SelectedCapabilityInfo.initialItemId +
                        '&subject_item_id=' + strItemIDs);
                    break;
                }
            case 'casketstore':
                {
                    let strItemIDs = arrItemIDs.join(",");
                    UiToolkitAPI.ShowCustomLayoutPopupParameters('', 'file://{resources}/layout/popups/popup_casket_operation.xml', 'op=add' +
                        '&nextcapability=batch' +
                        '&spinner=1' +
                        '&casket_item_id=' + _SelectedCapabilityInfo.initialItemId +
                        '&subject_item_id=' + strItemIDs);
                    break;
                }
        }
    }
    InventoryPanel.ProceedForMultiStatusCapabilityPopup = ProceedForMultiStatusCapabilityPopup;
    function _SetIsCapabilityPopUpOpen(isOpen) {
        _m_isCapabliltyPopupOpen = isOpen;
        if (isOpen === false) {
            _InventoryUpdated();
        }
    }
    function _ShowDeleteItemConfirmation(id) {
        UiToolkitAPI.ShowGenericPopupYesNo('#inv_context_delete', '#inv_confirm_delete_desc', "", () => _DeleteItemAnim(id), () => { });
    }
    function _DeleteItemAnim(id) {
        let activePanel = _m_elInventoryMain.FindChildInLayoutFile(_m_activeCategory);
        let elList = _GetActiveCategoryLister(activePanel);
        let childrenList = elList.Children();
        for (let element of childrenList) {
            if (id === element.GetAttributeString('itemid', '0')) {
                element.AddClass('delete');
            }
        }
        $.Schedule(.3, () => InventoryAPI.DeleteItem(id));
    }
    function _ShowUseItemOnceConfirmationPopup(id) {
        let pPopup = UiToolkitAPI.ShowGenericPopupYesNo('#inv_context_useitem', '#inv_confirm_useitem_desc', "", () => InventoryAPI.UseTool(id, ''), () => { });
        if (pPopup != null) {
            pPopup.SetDialogVariable('type', InventoryAPI.GetItemName(id));
        }
    }
    function _LoadEquipNotification() {
        let elParent = $.GetContextPanel().FindChildInLayoutFile('InventoryMainContainer');
        let elNotification = $.CreatePanel('Panel', elParent, 'InvNotificationEquip');
        elNotification.BLoadLayout('file://{resources}/layout/notification/notification_equip.xml', false, false);
    }
    function _ShowNotification(team, slot, oldItemId, newItemId, bNew) {
        if (!bNew || _m_isCapabliltyPopupOpen || $.GetContextPanel().BHasClass(_m_HiddenContentClassname)) {
            return;
        }
        let elNotification = $.GetContextPanel().FindChildInLayoutFile('InvNotificationEquip');
        EquipNotification.ShowEquipNotification(elNotification, slot, newItemId);
    }
    function UpdateItemListCallback() {
        if (_SelectedCapabilityInfo.popupVisible === true && _SelectedCapabilityInfo.capability) {
            _UpdatePopup(_SelectedCapabilityInfo.initialItemId, _SelectedCapabilityInfo.capability);
        }
    }
    InventoryPanel.UpdateItemListCallback = UpdateItemListCallback;
    function _ShowHideRentalTab() {
        let elNavBarBtnsContainer = $.GetContextPanel().FindChildInLayoutFile('id-navbar-tabs-catagory-btns-container');
        if (elNavBarBtnsContainer) {
            let elNavBarRentalsBtn = elNavBarBtnsContainer.FindChild('rentals');
            if (elNavBarRentalsBtn) {
                let bInventoryContainsRentals = InventoryAPI.CategoryContainsItems('rentals');
                if (!bInventoryContainsRentals && _m_activeCategory === 'rentals') {
                    let elNavBarEverythingBtn = elNavBarBtnsContainer.FindChild('any');
                    if (elNavBarEverythingBtn) {
                        elNavBarEverythingBtn.checked = true;
                        NavigateToTab('any');
                    }
                }
                elNavBarRentalsBtn.SetHasClass('hide', !bInventoryContainsRentals);
            }
        }
    }
    {
        _Init();
        let elJsInventory = $('#JsInventory');
        $.RegisterEventHandler('ReadyForDisplay', elJsInventory, _OnReadyForDisplay);
        $.RegisterEventHandler('UnreadyForDisplay', elJsInventory, _ClosePopups);
        $.RegisterEventHandler('Cancelled', elJsInventory, _ClosePopups);
        $.RegisterForUnhandledEvent('PromptShowSelectItemForCapabilityPopup', _PromptShowSelectItemForCapabilityPopup);
        $.RegisterForUnhandledEvent('ShowSelectItemForCapabilityPopup', _ShowSelectItemForCapabilityPopup);
        $.RegisterForUnhandledEvent('UpdateSelectItemForCapabilityPopup', _UpdateSelectItemForCapabilityPopup);
        $.RegisterForUnhandledEvent('HideSelectItemForCapabilityPopup', CloseSelectItemForCapabilityPopup);
        $.RegisterForUnhandledEvent('CapabilityPopupIsOpen', _SetIsCapabilityPopUpOpen);
        $.RegisterForUnhandledEvent('RefreshActiveInventoryList', _InventoryUpdated);
        $.RegisterForUnhandledEvent('ShowDeleteItemConfirmationPopup', _ShowDeleteItemConfirmation);
        $.RegisterForUnhandledEvent('ShowUseItemOnceConfirmationPopup', _ShowUseItemOnceConfirmationPopup);
        $.RegisterForUnhandledEvent('PanoramaComponent_Inventory_CraftIngredientAdded', () => NavigateToTab('tradeup'));
        $.RegisterForUnhandledEvent('ShowSelectItemForWorkshopPreviewCapability', _ShowSelectItemForWorkshopPreviewCapability);
        $.RegisterForUnhandledEvent('ShowTradeUpPanel', _GotoTradeUpPanel);
    }
})(InventoryPanel || (InventoryPanel = {}));
