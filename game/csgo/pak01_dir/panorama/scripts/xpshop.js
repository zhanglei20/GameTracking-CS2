"use strict";
/// <reference path="csgo.d.ts" />
/// <reference path="inspect.ts" />
/// <reference path="mainmenu_store_fullscreen.ts" />
/// <reference path="common/prime_button_action.ts" />
/// <reference path="popups/popup_acknowledge_item.ts" />
/// <reference path="common/icon.ts" />
/// <reference path="xpshop_track.ts" />
/// <reference path="particle_controls.ts" />
var XpShop;
(function (XpShop) {
    const m_tileWidth = 260;
    const m_tileHeight = 120;
    const m_keychainTileWidth = 180;
    const m_keychainTileHeight = m_keychainTileWidth - 10;
    const m_stickerTileWidth = 160;
    const m_elContentPanel = $.GetContextPanel().FindChildInLayoutFile('id-xpshop-content');
    let m_nTrack;
    let m_nPass;
    let m_activeTracks = 0;
    let m_showTimeoutScheduleHandle;
    const m_passDefName = 'XpShopTicket1';
    const m_passId = InventoryAPI.GetFauxItemIDFromDefAndPaintIndex(InventoryAPI.GetItemDefinitionIndexFromDefinitionName(m_passDefName), 0);
    let m_CameraSettingsPerWeapon = [
        { type: 'weapon_awp', camera: '1' },
        { type: 'weapon_aug', camera: '2' },
        { type: 'weapon_sg556', camera: '0' },
        { type: 'weapon_ssg08', camera: '1' },
        { type: 'weapon_ak47', camera: '0' },
        { type: 'weapon_m4a1_silencer', camera: '1' },
        { type: 'weapon_famas', camera: '0' },
        { type: 'weapon_g3sg1', camera: '1' },
        { type: 'weapon_galilar', camera: '2' },
        { type: 'weapon_m4a1', camera: '0' },
        { type: 'weapon_scar20', camera: '1' },
        { type: 'weapon_mp5sd', camera: '0' },
        { type: 'weapon_mac10', camera: '5' },
        { type: 'weapon_xm1014', camera: '2' },
        { type: 'weapon_m249', camera: '1' },
        { type: 'weapon_ump45', camera: '0' },
        { type: 'weapon_bizon', camera: '2' },
        { type: 'weapon_mag7', camera: '2' },
        { type: 'weapon_nova', camera: '1' },
        { type: 'weapon_sawedoff', camera: '2' },
        { type: 'weapon_negev', camera: '1' },
        { type: 'weapon_p90', camera: '3' },
        { type: 'weapon_mp9', camera: '5' },
        { type: 'weapon_mp7', camera: '5' },
        { type: 'weapon_usp_silencer', camera: '4' },
        { type: 'weapon_cz75a', camera: '6' },
        { type: 'weapon_elite', camera: '5' },
        { type: 'weapon_tec9', camera: '5' },
        { type: 'weapon_revolver', camera: '6' },
        { type: 'weapon_fiveseven', camera: '7' },
        { type: 'weapon_p250', camera: '7' },
        { type: 'weapon_glock', camera: '7' },
        { type: 'weapon_deagle', camera: '6' },
        { type: 'weapon_hkp2000', camera: '6' },
        { type: 'weapon_c4', camera: '2' },
        { type: 'weapon_taser', camera: '5' },
    ];
    function Init() {
        m_nTrack = MissionsAPI.GetSeasonalOperationXpShopIndex();
        if (!m_nTrack || m_nTrack === 0) {
            return;
        }
        _MakeShowMainTilesNavBtn();
        _SetUpTracks();
        _UpdateShopGoods(m_nTrack);
        let elBtn = $.GetContextPanel().FindChildInLayoutFile('id-nav-show-main-tiles-btn');
        $.DispatchEvent("Activated", elBtn, "mouse");
    }
    XpShop.Init = Init;
    function InventoryUpdate() {
        if (!m_elContentPanel || !$.GetContextPanel().IsValid()) {
            return;
        }
        _CancelTimeoutForRewardItem();
        _SetUpTracks();
        let elBtn = $.GetContextPanel().FindChildInLayoutFile('id-xpshop-top-nav').Children().filter(entry => entry.checked === true)[0];
        if (elBtn && elBtn.IsValid()) {
            $.DispatchEvent("Activated", elBtn, "mouse");
        }
        else {
            _MakeShowMainTilesNavBtn();
            $.DispatchEvent("Activated", $.GetContextPanel().FindChildInLayoutFile('id-nav-show-main-tiles-btn'), "mouse");
        }
    }
    XpShop.InventoryUpdate = InventoryUpdate;
    function _SetUpTracks() {
        let bHasPrime = FriendsListAPI.GetFriendPrimeEligible(MyPersonaAPI.GetXuid());
        let oXpShopTrackProgress = InventoryAPI.GetCacheTypeElementJSOByIndex('XpShop', 0);
        let elTracks = $.GetContextPanel().FindChildInLayoutFile('id-xpshop-tracks');
        let elUpsell = $.GetContextPanel().FindChildInLayoutFile('id-xpshop-upsell');
        let btnUpsell = $.GetContextPanel().FindChildInLayoutFile('id-xpshop-upsell-btn');
        let elUpsellInfo = $.GetContextPanel().FindChildInLayoutFile('id-xpshop-info');
        let elBalance = $.GetContextPanel().FindChildInLayoutFile('id-xpshop-balance');
        let elMorePassesBtn = $.GetContextPanel().FindChildInLayoutFile('id-xpshop-more-passes-btn');
        elTracks.SetDialogVariable('pass', InventoryAPI.GetItemName(m_passId));
        elTracks.SetDialogVariableInt('max-stars', StoreAPI.GetXpShopMaxTrackLevel());
        const bHasStarPointsBalance = (bHasPrime && oXpShopTrackProgress && oXpShopTrackProgress.redeemable_balance >= 0);
        const numStarPointsBalance = bHasStarPointsBalance ? oXpShopTrackProgress.redeemable_balance : 0;
        elBalance.SetDialogVariableInt('redeemable-points', numStarPointsBalance);
        elBalance.Data().balance = numStarPointsBalance;
        if (!bHasPrime) {
            elTracks.SetDialogVariable('upsell-text', $.Localize('#elevated_status_ad_xpshop', elTracks));
            elTracks.SetDialogVariable('upsell-btn-text', $.Localize('#elevated_status_btn_no_price', elTracks));
            elUpsellInfo.visible = false;
            btnUpsell.SetPanelEvent('onactivate', () => {
                $.DispatchEvent("CSGOPlaySoundEffect", "UIPanorama.loadout_sector_select", "MOUSE");
                let elNavBtn = $.GetContextPanel().GetParent().GetParent().FindChildInLayoutFile('id-store-nav-home');
                $.DispatchEvent("Activated", elNavBtn, "mouse");
                elNavBtn.checked = true;
            });
            elUpsell.SetHasClass('hide', false);
            elMorePassesBtn.SetHasClass('hide', true);
            elBalance.SetHasClass('hide', true);
        }
        else {
            AcknowledgeItems.GetItemsByType([m_passDefName], true);
            InventoryAPI.SetInventorySortAndFilters('inv_sort_age', false, 'item_definition:' + m_passDefName, '', '');
            m_nPass = InventoryAPI.GetInventoryCount();
            let elActiveTracks = $.GetContextPanel().FindChildInLayoutFile('id-xpshop-active-tracks');
            const bHasXpShopTracksOrBalance = oXpShopTrackProgress && (oXpShopTrackProgress.xp_tracks.length > 0 || oXpShopTrackProgress.redeemable_balance > 0);
            if (m_nPass > 0 || bHasXpShopTracksOrBalance) {
                let passIndex = 0;
                m_activeTracks = 0;
                let numPassesStillPossibleToBuy = 0;
                const numXpShopMaxTracks = StoreAPI.GetXpShopMaxTracks();
                let numPassesFullyCompleted = 0;
                for (let i = 0; i < numXpShopMaxTracks; i++) {
                    if (oXpShopTrackProgress && oXpShopTrackProgress.xp_tracks[i]) {
                        const bIsMax = oXpShopTrackProgress.xp_tracks[i] / StoreAPI.GetXpShopStarXp() >= StoreAPI.GetXpShopMaxTrackLevel();
                        if (bIsMax)
                            ++numPassesFullyCompleted;
                    }
                }
                elActiveTracks.SetHasClass('hide', false);
                for (let i = 0; i < numXpShopMaxTracks; i++) {
                    let elTrack = CreateTrack(elActiveTracks, i);
                    elTrack.visible = false;
                    let elActivateBtn = elTrack.FindChildInLayoutFile('id-xpshop-pass-activate-btn');
                    elActivateBtn.SetHasClass('hidden', true);
                    let oSettings;
                    if (oXpShopTrackProgress && oXpShopTrackProgress.xp_tracks[i]) {
                        let bIsMax = oXpShopTrackProgress.xp_tracks[i] / StoreAPI.GetXpShopStarXp() >= StoreAPI.GetXpShopMaxTrackLevel();
                        let trackValue = parseInt(oXpShopTrackProgress.xp_tracks[i]);
                        let nStarsEarned = trackValue > 0 ? Math.floor(trackValue / StoreAPI.GetXpShopStarXp()) : 0;
                        let elTrackProgress = elTrack.FindChildInLayoutFile('id-xpshop-active-tracks-progress-icons');
                        elTrackProgress.Children().forEach((element, idx) => {
                            element.SetHasClass('complete', idx < nStarsEarned);
                        });
                        oSettings = {
                            xpshop_track_frame_panel: elTrack,
                            xpshop_track_value: trackValue,
                        };
                        elTrack.visible = true;
                        XpShopTrack.XpShopInit(oSettings);
                        m_activeTracks++;
                        elTrack.SetPanelEvent('onmouseover', () => {
                            if (!bIsMax) {
                                UiToolkitAPI.ShowTextTooltip(elTrack.id, '#xpshop_track_tooltip');
                            }
                        });
                        elTrack.SetPanelEvent('onmouseout', () => {
                            UiToolkitAPI.HideTextTooltip();
                        });
                        if (bIsMax) {
                            elActivateBtn.SetHasClass('hidden', false);
                            elActivateBtn.SwitchClass('type', 'clear-pass-btn');
                            elActivateBtn.SetDialogVariable('action-text', $.Localize('#xpshop_popup_clear_track_title', elActivateBtn));
                            elActivateBtn.SetDialogVariableInt('completed_tracks_count', numPassesFullyCompleted);
                            const strMessageTitle = $.Localize('#xpshop_popup_clear_n_tracks', elActivateBtn);
                            const strMessageText = $.Localize('#xpshop_popup_clear_n_tracks_text', elActivateBtn);
                            elActivateBtn.SetPanelEvent('onactivate', () => {
                                UiToolkitAPI.ShowGenericPopupOkCancel(strMessageTitle, strMessageText, '', () => {
                                    StoreAPI.AckXpShopCompletedTracks();
                                }, () => { });
                            });
                        }
                    }
                    else if (m_nPass > 0 && passIndex < m_nPass) {
                        let passToActivate = InventoryAPI.GetInventoryItemIDByIndex(passIndex);
                        passIndex++;
                        oSettings = {
                            xpshop_track_frame_panel: elTrack,
                            xpshop_track_value: 0,
                        };
                        XpShopTrack.XpShopInit(oSettings);
                        let elTrackProgress = elTrack.FindChildInLayoutFile('id-xpshop-active-tracks-progress-icons');
                        elTrackProgress.Children().forEach((element) => {
                            element.SetHasClass('complete', false);
                        });
                        elTrack.visible = true;
                        elActivateBtn.SetHasClass('hidden', false);
                        elActivateBtn.SwitchClass('type', 'activate-pass-btn');
                        elActivateBtn.SetDialogVariable('action-text', $.Localize('#xpshop_pass_activate', elActivateBtn));
                        elActivateBtn.SetPanelEvent('onactivate', () => {
                            XpShopTrack.PlayActivateParticles(oSettings);
                            elActivateBtn.SetHasClass('hidden', true);
                            elTrack.TriggerClass('xpshop-activate-pass-anim');
                            $.DispatchEvent("CSGOPlaySoundEffect", "UI.XP.Star.Full", "MOUSE");
                            $.Schedule(.75, () => {
                                InventoryAPI.UseTool(passToActivate, '');
                                elTrack.FindChildInLayoutFile('id-xpshop-pass-how-to').TriggerClass('xpshop-active-pass__how-to-anim');
                            });
                        });
                    }
                    else {
                        ++numPassesStillPossibleToBuy;
                    }
                }
                elUpsell.SetHasClass('hide', true);
                elBalance.SetHasClass('hide', false);
                elMorePassesBtn.SetHasClass('hide', numPassesStillPossibleToBuy <= 0);
                elMorePassesBtn.text = $.Localize('#xpshop_pass_extra_pass', elActiveTracks);
                elMorePassesBtn.SetPanelEvent('onactivate', () => {
                    _OpenPurchasePassPopup();
                    $.DispatchEvent("CSGOPlaySoundEffect", "UIPanorama.loadout_sector_select", "MOUSE");
                });
                $.GetContextPanel().FindChildInLayoutFile('id-xpshop-active-tracks-container').SetHasClass('five-tracks', numPassesStillPossibleToBuy === 0);
            }
            else {
                elTracks.SetDialogVariable('upsell-text', $.Localize('#xpshop_upsell_desc', elTracks));
                elTracks.SetDialogVariable('upsell-btn-text', $.Localize('#xpshop_upsell_btn', elTracks));
                elUpsellInfo.FindChild('id-xpshop-info-btn')?.SetPanelEvent('onactivate', () => SteamOverlayAPI.OpenUrlInOverlayOrExternalBrowser('https://store.steampowered.com/sale/armory'));
                elUpsell.FindChildInLayoutFile('id-xpshop-upsell-image').itemid = m_passId;
                btnUpsell.SetPanelEvent('onactivate', () => {
                    $.DispatchEvent("CSGOPlaySoundEffect", "UIPanorama.loadout_sector_select", "MOUSE");
                    _OpenPurchasePassPopup();
                });
                elActiveTracks.SetHasClass('hide', true);
                elUpsell.SetHasClass('hide', false);
                elMorePassesBtn.SetHasClass('hide', true);
                elBalance.SetHasClass('hide', true);
            }
        }
    }
    function _OpenPurchasePassPopup() {
        UiToolkitAPI.ShowCustomLayoutPopupParameters('', 'file://{resources}/layout/popups/popup_inventory_inspect.xml', 'itemid=' + m_passId
            + '&' +
            'inspectonly=false'
            + '&' +
            'asyncworkitemwarning=no'
            + '&' +
            'storeitemid=' + m_passId);
    }
    function CreateTrack(elTracks, index) {
        const sNamePrefix = 'active-track-';
        let elTrack = elTracks.FindChildInLayoutFile(sNamePrefix + index);
        if (!elTrack) {
            elTrack = $.CreatePanel('Panel', elTracks, sNamePrefix + index);
            elTrack.BLoadLayoutSnippet('shop-ticket');
            elTrack.style.tooltipPosition = "bottom";
            elTrack.style.tooltipBodyPosition = "50% 0%";
            let elProgress = elTrack.FindChildInLayoutFile('id-xpshop-active-tracks-progress');
            elProgress.BLoadLayout('file://{resources}/layout/xpshop_track.xml', true, false);
            elProgress.hittest = false;
            elProgress.hittestchildren = false;
            let elParent = elTrack.FindChildInLayoutFile('id-xpshop-active-tracks-progress-icons');
            for (let i = 0; i < StoreAPI.GetXpShopMaxTrackLevel(); i++) {
                let elIcon = $.CreatePanel('Panel', elParent, '');
                elIcon.BLoadLayoutSnippet('shop-pass-star');
            }
        }
        return elTrack;
    }
    function _UpdateShopGoods(m_nTrack) {
        let nCount = MissionsAPI.GetSeasonalOperationRedeemableGoodsCount(m_nTrack);
        for (let i = 0; i < nCount; i++) {
            let ShopEntry = {
                ui_order: 0,
                nav_order: 0,
                ui_image: "",
                ui_set_image: "",
                ui_image_thumbnail: "",
                item_name: "",
                callout: "",
                item_name_groups: "",
                points: '',
                limited_until: '',
                ui_show_new_tag: ''
            };
            for (let key in ShopEntry) {
                let field_value = MissionsAPI.GetSeasonalOperationRedeemableGoodsSchema(m_nTrack, i, key);
                //@ts-ignore
                ShopEntry[key] = field_value;
            }
            ShopEntry.shop_index = i;
            if (ShopEntry.item_name.startsWith('lootlist:')) {
                ShopEntry.entry_type = 'lootlist';
                ShopEntry.lootlist = _GetLootListForReward(ShopEntry.item_name);
                ShopEntry.lootlist_item_type = ItemInfo.IsWeapon(ShopEntry.lootlist[0]) ? 'weapon' : ItemInfo.IsKeychain(ShopEntry.lootlist[0]) ? 'keychain' : 'sticker';
                ShopEntry.tile_width = ShopEntry.lootlist_item_type === 'keychain' ?
                    m_keychainTileWidth : ShopEntry.lootlist_item_type === 'sticker' ?
                    m_stickerTileWidth : m_tileWidth;
                ShopEntry.tile_height = ShopEntry.lootlist_item_type === 'weapon' ? m_tileHeight : ShopEntry.lootlist_item_type === 'keychain' ? m_keychainTileHeight : ShopEntry.tile_width;
                ShopEntry.on_item_activate = _OpenFullScreenInspectItem;
                let strSetName = InventoryAPI.GetTag(ShopEntry.lootlist[0], 'ItemSet');
                ShopEntry.ui_set_image = strSetName ? strSetName : ShopEntry.ui_set_image;
                if (ShopEntry.limited_until)
                    ShopEntry.suffix_loc_string = '_limitedtime';
            }
            else if (ShopEntry.item_name.startsWith('crate_')) {
                ShopEntry.entry_type = 'crate';
                ShopEntry.suffix_loc_string = '_crate';
                let nDefinitionIndex = InventoryAPI.GetItemDefinitionIndexFromDefinitionName(ShopEntry.item_name);
                let idCrate = InventoryAPI.GetFauxItemIDFromDefAndPaintIndex(nDefinitionIndex, 0);
                ShopEntry.lootlist = [idCrate];
                ShopEntry.lootlist_item_type = 'crate';
                let strSetName = InventoryAPI.GetTag(InventoryAPI.GetLootListItemIdByIndex(idCrate, 0), 'ItemSet');
                ShopEntry.ui_set_image = strSetName ? strSetName : '';
                ShopEntry.on_item_activate = OpenFullscreenInspect;
            }
            _MakeShopTile(ShopEntry);
            _MakeNavButton(ShopEntry);
        }
        let elParent = $.GetContextPanel().FindChildInLayoutFile('id-xpshop-top-nav');
        let aNavButtons = elParent.Children();
        aNavButtons.forEach((element, idx) => {
            if (element.Data().ui_order) {
                if (element.Data().ui_order === '1') {
                    elParent.MoveChildBefore(element, aNavButtons[1]);
                }
            }
        });
    }
    function _GetLootListForReward(rewardId) {
        var count = InventoryAPI.GetLootListItemsCount(rewardId);
        var itemsList = [];
        if (!count) {
            itemsList.push(rewardId);
        }
        else {
            for (var i = 0; i < count; i++) {
                var itemId = InventoryAPI.GetLootListItemIdByIndex(rewardId, i);
                itemsList.push(itemId);
            }
        }
        return itemsList;
    }
    ;
    function _MakeShopTile(ShopEntry) {
        let elTile = m_elContentPanel.FindChildInLayoutFile(ShopEntry.item_name);
        if (!elTile) {
            let elRow = m_elContentPanel.FindChildInLayoutFile('id-xpshop-row-' + ShopEntry.ui_order);
            elTile = $.CreatePanel('Button', elRow, ShopEntry.item_name);
            elTile.BLoadLayoutSnippet('shop-tile');
            elTile.SetPanelEvent('onactivate', () => {
                let elBtn = $.GetContextPanel().FindChildInLayoutFile('id-xpshop-top-nav').Children().filter(entry => ShopEntry.item_name + '-nav' === entry.id)[0];
                if (elBtn && elBtn.IsValid()) {
                    $.DispatchEvent("Activated", elBtn, "mouse");
                }
            });
            if (ShopEntry.ui_set_image) {
                const elImage = elTile.FindChildInLayoutFile('id-xpshop-tile-icon');
                IconUtil.SetupFallbackItemSetIcon(elImage, ShopEntry.ui_set_image);
                IconUtil.SetItemSetSVGImage(elImage, ShopEntry.ui_set_image);
            }
            if (ShopEntry.limited_until) {
                let elPanelLimitedTimer = elTile.FindChildInLayoutFile('id-xpshop-tile-limitedtimer');
                elPanelLimitedTimer.RemoveClass('hidden');
                let numDaysRemaining = StoreAPI.GetSecondsUntilTimestamp(parseInt(ShopEntry.limited_until));
                numDaysRemaining = Math.floor(numDaysRemaining / (24 * 3600));
                elPanelLimitedTimer.SetDialogVariableInt('daysremaining', numDaysRemaining);
                let strTimer = $.Localize((numDaysRemaining > 0) ? '#SFUI_Store_Offer_Days_Remaining' : '#SFUI_Store_Last_Chance', elPanelLimitedTimer);
                elPanelLimitedTimer.SetDialogVariable('limitedtimeleft', strTimer);
            }
            elTile.style.backgroundImage = 'url("file://{images}/' + ShopEntry.ui_image_thumbnail + '.png")';
            elTile.style.backgroundPosition = '50% 50%';
            elTile.style.backgroundSize = 'cover';
            if (ShopEntry.lootlist?.length === 1) {
                if (ShopEntry.limited_until) {
                    let elLimitedCarousel = $.CreatePanel('Carousel', elTile, '');
                    elLimitedCarousel.BLoadLayoutSnippet('limited-item-carousel');
                    elLimitedCarousel.hittest = false;
                    elLimitedCarousel.hittestchildren = false;
                }
                else {
                    elTile.FindChildInLayoutFile('id-xpshop-tile-single-image').itemid = ShopEntry.lootlist[0];
                }
            }
            else if (ShopEntry.lootlist && ShopEntry.lootlist.length > 1) {
                let elCarousel = elTile.FindChildInLayoutFile('id-xpshop-tile-carousel');
                let elPanel;
                const numItemsPerTile = (ShopEntry.lootlist_item_type === "keychain" || ShopEntry.lootlist_item_type === "sticker") ? 4 : 1;
                let numScrollingTilesToAdd = (ShopEntry.lootlist_item_type === "keychain" || ShopEntry.lootlist_item_type === "sticker") ? Math.floor((ShopEntry.lootlist.length + numItemsPerTile - 1) / numItemsPerTile) : 6;
                let shuffledArray = [...ShopEntry.lootlist];
                shuffledArray.sort((a, b) => 0.5 - Math.random());
                for (let iScrollingTile = 0; iScrollingTile < numScrollingTilesToAdd; ++iScrollingTile) {
                    for (let iTileItem = 0; iTileItem < numItemsPerTile; ++iTileItem) {
                        if (ShopEntry.lootlist_item_type === "keychain" || ShopEntry.lootlist_item_type === "sticker") {
                            let entry = shuffledArray[((iScrollingTile * numScrollingTilesToAdd) + iTileItem) % shuffledArray.length];
                            if (iTileItem === 0) {
                                elPanel = $.CreatePanel('Panel', elCarousel, '', { class: 'xpshop__item-tile__carousel-multi-image' });
                            }
                            let elImage = $.CreatePanel('ItemImage', elPanel, '', { itemid: entry, class: 'carousel-image-' + iTileItem });
                            elImage.SetHasClass('sticker', ShopEntry.lootlist_item_type === "sticker" ? true : false);
                        }
                        else {
                            let entry = shuffledArray[iScrollingTile];
                            $.CreatePanel('ItemImage', elCarousel, '', { itemid: entry });
                        }
                    }
                }
            }
        }
        elTile.FindChildInLayoutFile('id-new-item-tag').SetHasClass('hidden', !XpShop.ShouldShowNewTagForShopEntry(ShopEntry));
        elTile.SetDialogVariable('name', ShopEntry.callout ? $.Localize(ShopEntry.callout) : ShopEntry.item_name);
        elTile.SetDialogVariable('points', ShopEntry.points);
        return elTile;
    }
    let jsTooltipDelayHandle = null;
    function _UpdateInspectGrid(ShopEntry) {
        m_elContentPanel.SetHasClass('xpshop-grids-visible', true);
        let elInspectContainer = m_elContentPanel.FindChildInLayoutFile('id-xpshop-inspect-container');
        let elGrid = elInspectContainer.FindChildInLayoutFile(ShopEntry.item_name + '-grid');
        if (!elGrid) {
            elGrid = $.CreatePanel('Panel', elInspectContainer, ShopEntry.item_name + '-grid');
            elGrid.BLoadLayoutSnippet('shop-grid');
            elGrid.SetDialogVariable('name', ShopEntry.callout ? $.Localize(ShopEntry.callout) : ShopEntry.item_name);
            elGrid.SetDialogVariable('cost_stars', ShopEntry.points);
            elGrid.SetDialogVariable('desc-text', $.Localize('#xpshop_redeem_item_desc' + (ShopEntry.suffix_loc_string ? ShopEntry.suffix_loc_string : ''), elGrid));
            elGrid.SetDialogVariable('use-text', $.Localize('#xpshop_redeem_use_stars', elGrid));
            elGrid.SetDialogVariable('confirm-text', $.Localize('#xpshop_redeem_use_confirm_item' + (ShopEntry.suffix_loc_string ? ShopEntry.suffix_loc_string : ''), elGrid));
            let elRedeemBar = elGrid.FindChildInLayoutFile('id-xpshop-item-redeem-bar');
            let elConfirmBar = elGrid.FindChildInLayoutFile('id-xpshop-item-confirm-bar');
            _SetUpRedeemBar(elRedeemBar, elConfirmBar, ShopEntry);
            _SetUpConfirmBar(elRedeemBar, elConfirmBar, ShopEntry);
            _SetWarningText(elGrid, ShopEntry);
            let elTilesContainer = elGrid.FindChildInLayoutFile('id-xpshop-grid-tiles');
            ShopEntry.lootlist?.forEach((itemId, idx) => {
                let elShopTile = CreateShopTile(elTilesContainer, itemId, ShopEntry);
                let elModel = elShopTile.FindChild('id-grid-item-model');
                if (ShopEntry.entry_type === 'crate') {
                    elShopTile.AddClass('crate-item');
                    let elLootlistItems = elShopTile.FindChildInLayoutFile('id-xpshop-crate-lootlist');
                    elModel = elShopTile.FindChildInLayoutFile('ItemPreviewPanel');
                    ;
                    $.Schedule(.25, () => elModel.TransitionToCamera('cam_case_open', 1));
                    if (!elLootlistItems) {
                        elLootlistItems = $.CreatePanel('Panel', elShopTile, 'id-xpshop-crate-lootlist-' + itemId, { class: 'xpshop__crate-lootlist' });
                        elLootlistItems.style.backgroundImage = 'url("file://{images}/' + ShopEntry.ui_image_thumbnail + '.png")';
                        elLootlistItems.style.backgroundPosition = '50% 50%';
                        elLootlistItems.style.backgroundSize = 'clip_then_cover';
                        elLootlistItems.style.backgroundImgOpacity = '.6';
                        $.CreatePanel('Panel', elLootlistItems, '', { class: 'xpshop__crate-lootlist__bg' });
                        let textString = $.Localize('#xpshop_lootlist_info', elGrid);
                        $.CreatePanel('Label', elLootlistItems, '', { class: 'xpshop__crate-lootlist__label', html: 'true', text: textString });
                        let elLootlistItemTiles = $.CreatePanel('Panel', elLootlistItems, '', { class: 'xpshop__crate-lootlist__tiles' });
                        let aCrateLootlist = _GetLootListForReward(itemId);
                        aCrateLootlist.forEach((id, idx) => {
                            let elItem = $.CreatePanel('Button', elLootlistItemTiles, id, { class: 'xpshop__crate-lootlist__item-tile' });
                            elItem.BLoadLayoutSnippet('crate-lootlist-item');
                            let elImage = elItem.FindChildInLayoutFile('id-crate-lootlits-item-image');
                            let elRarity = elItem.FindChildInLayoutFile('id-crate-lootlits-item-rarity');
                            if (id !== '0') {
                                elImage.itemid = id;
                                let color = InventoryAPI.GetItemRarityColor(id);
                                if (color) {
                                    elRarity.style.backgroundColor = color;
                                }
                                elItem.SetPanelEvent('onactivate', () => {
                                    $.DispatchEvent("LootlistItemPreview", id, itemId);
                                });
                            }
                            else {
                                let unusualItemImagePath = InventoryAPI.GetLootListUnusualItemImage(itemId) + ".png";
                                elImage.SetImage("file://{images}/" + unusualItemImagePath);
                                elRarity.visible = false;
                                elItem.enabled = false;
                            }
                        });
                    }
                    return;
                }
                if (ShopEntry.lootlist?.length === 1) {
                    return;
                }
                elModel.SetActiveItem(0);
                elModel.SetItemItemId(itemId, '');
                elModel.hittest = false;
                let nRenderInterval = 10;
                elModel.SetRenderInterval(nRenderInterval);
                let bUseNarrowZoom = false;
                if (ShopEntry.item_name === 'lootlist:keychain_pack_kc_missinglink_lootlist' ||
                    (InventoryAPI.GetLoadoutCategory(itemId) == 'secondary' && elShopTile.Data().defName !== 'weapon_usp_silencer') ||
                    elShopTile.Data().defName === 'weapon_taser' ||
                    elShopTile.Data().defName === 'weapon_mp7' ||
                    elShopTile.Data().defName === 'weapon_mp9' ||
                    elShopTile.Data().defName === 'weapon_mac10' ||
                    (ShopEntry.item_name === 'lootlist:keychain_pack_kc_weapon_01_lootlist' &&
                        (idx === 5 || idx === 13 || idx === 14 || idx === 15))) {
                    bUseNarrowZoom = true;
                }
                elShopTile.SetPanelEvent('onmouseover', () => {
                    jsTooltipDelayHandle = $.Schedule(.2, () => {
                        jsTooltipDelayHandle = null;
                        _EnableRotateOnModel(elModel, ShopEntry.lootlist_item_type);
                        elModel.SetRenderInterval(0);
                        $.Schedule(.2, () => { elModel.hittest = true; });
                        _DarkenTiles(elTilesContainer, elShopTile);
                        _SetZoomInSizeAndPosition(ShopEntry, elShopTile, bUseNarrowZoom);
                    });
                });
                elShopTile.SetPanelEvent('onmouseout', () => {
                    _DisableRotateOnModel(elModel);
                    _DarkenTiles(elTilesContainer);
                    elModel.hittest = false;
                    elModel.SetRenderInterval(nRenderInterval);
                    ResetSizeAndPosition(ShopEntry, elShopTile);
                    if (jsTooltipDelayHandle) {
                        $.CancelScheduled(jsTooltipDelayHandle);
                        jsTooltipDelayHandle = null;
                    }
                });
            });
            $.Schedule(.15, () => PlaceTiles(elTilesContainer, ShopEntry));
        }
        else {
            $.Schedule(.1, () => PlaceTiles(elGrid.FindChildInLayoutFile('id-xpshop-grid-tiles'), ShopEntry));
            _SetUpRedeemBar(elGrid.FindChildInLayoutFile('id-xpshop-item-redeem-bar'), elGrid.FindChildInLayoutFile('id-xpshop-item-confirm-bar'), ShopEntry);
            if (ShopEntry.lootlist && ShopEntry.lootlist_item_type === 'weapon' && ShopEntry.lootlist.length == 1) {
                let elLimitedItem = elGrid.FindChildInLayoutFile(ShopEntry.lootlist[0]);
                if (elLimitedItem && elLimitedItem.IsValid()) {
                    InspectModelImage.Init(elLimitedItem, ShopEntry.lootlist[0]);
                }
            }
        }
        _UpdateVisibleInspectGrid(elInspectContainer, ShopEntry.item_name + '-grid');
    }
    function _DeleteInspectGrid() {
        if (!m_nTrack || m_nTrack === 0) {
            return;
        }
        let nCount = MissionsAPI.GetSeasonalOperationRedeemableGoodsCount(m_nTrack);
        for (let i = 0; i < nCount; i++) {
            let item_name = MissionsAPI.GetSeasonalOperationRedeemableGoodsSchema(m_nTrack, i, 'item_name');
            let elInspectContainer = m_elContentPanel.FindChildInLayoutFile('id-xpshop-inspect-container');
            let elGrid = elInspectContainer.FindChildInLayoutFile(item_name + '-grid');
            if (elGrid) {
                elGrid.DeleteAsync(1.0);
            }
        }
    }
    function _SetUpRedeemBar(elRedeemBar, elConfirmBar, ShopEntry) {
        let RedeemBtn = elRedeemBar.FindChildInLayoutFile('id-xpshop-item-redeem-btn-' + ShopEntry.shop_index);
        if (!RedeemBtn) {
            RedeemBtn = $.CreatePanel('Button', elRedeemBar, 'id-xpshop-item-redeem-btn-' + ShopEntry.shop_index);
            RedeemBtn.BLoadLayoutSnippet('redeem-button');
        }
        let elBalance = $.GetContextPanel().FindChildInLayoutFile('id-xpshop-balance');
        RedeemBtn.SetDialogVariable('pass', InventoryAPI.GetItemName(m_passId));
        RedeemBtn.SetDialogVariableInt('max-stars', StoreAPI.GetXpShopMaxTrackLevel());
        RedeemBtn.enabled = (ShopEntry.points !== undefined &&
            ShopEntry.points !== '' &&
            elBalance.Data().balance &&
            (elBalance.Data().balance >= parseInt(ShopEntry.points))) ? true : false;
        RedeemBtn.SetPanelEvent('onactivate', () => {
            elRedeemBar.SetHasClass('hidden', true);
            elConfirmBar.SetHasClass('hidden', false);
            elConfirmBar.FindChildInLayoutFile('id-xpshop-item-redeem-confirm').enabled = true;
            elConfirmBar.FindChildInLayoutFile('id-xpshop-item-redeem-cancel').enabled = true;
        });
        RedeemBtn.SetPanelEvent('onmouseover', () => {
            let nStarsNeeded = m_activeTracks > 0 ? (parseInt(ShopEntry.points) - elBalance.Data().balance) : 0;
            RedeemBtn.SetDialogVariableInt('stars_needed', nStarsNeeded);
            let strToolTip = (m_activeTracks < 1) ? '#xpshop_redeem_need_pass_tooltip' :
                nStarsNeeded > 0 ? $.Localize('#xpshop_redeem_not_enough_stars', RedeemBtn) : '';
            if (strToolTip === '') {
                return;
            }
            UiToolkitAPI.ShowTextTooltip(RedeemBtn.id, strToolTip);
        });
        RedeemBtn.SetPanelEvent('onmouseout', () => {
            UiToolkitAPI.HideTextTooltip();
        });
        if (ShopEntry.ui_set_image) {
            const elImage = elRedeemBar.FindChildInLayoutFile('id-xpshop-item-redeem-icon');
            IconUtil.SetupFallbackItemSetIcon(elImage, ShopEntry.ui_set_image);
            IconUtil.SetItemSetSVGImage(elImage, ShopEntry.ui_set_image);
        }
        _ResetToRewardsBar(elRedeemBar, elConfirmBar);
    }
    function _SetUpConfirmBar(elRedeemBar, elConfirmBar, ShopEntry) {
        elConfirmBar.FindChildInLayoutFile('id-xpshop-item-redeem-cancel').SetPanelEvent('onactivate', () => {
            _ResetToRewardsBar(elRedeemBar, elConfirmBar);
        });
        if (ShopEntry.ui_set_image) {
            const elImage = elConfirmBar.FindChildInLayoutFile('id-xpshop-item-confirm-icon');
            IconUtil.SetupFallbackItemSetIcon(elImage, ShopEntry.ui_set_image);
            IconUtil.SetItemSetSVGImage(elImage, ShopEntry.ui_set_image);
        }
        elConfirmBar.FindChildInLayoutFile('id-xpshop-item-redeem-confirm').SetPanelEvent('onactivate', () => {
            MissionsAPI.ActionRedeemOperationGoods(m_nTrack, ShopEntry.shop_index);
            elConfirmBar.FindChildInLayoutFile('id-xpshop-item-redeem-confirm').enabled = false;
            elConfirmBar.FindChildInLayoutFile('id-xpshop-item-redeem-cancel').enabled = false;
            $.GetContextPanel().SetHasClass('waiting-for-redeem', true);
            _StartRedeemParticles();
            $.DispatchEvent("CSGOPlaySoundEffect", "UI.XP.Star.Spend", "MOUSE");
            m_showTimeoutScheduleHandle = $.Schedule(5, () => {
                $.DispatchEvent("Activated", elConfirmBar.FindChildInLayoutFile('id-xpshop-item-redeem-cancel'), "mouse");
                $.GetContextPanel().SetHasClass('waiting-for-redeem', false);
                _StopRedeemParticles();
                let elBtn = $.GetContextPanel().FindChildInLayoutFile('id-nav-show-main-tiles-btn');
                $.DispatchEvent("Activated", elBtn, "mouse");
                UiToolkitAPI.ShowGenericPopupOk($.Localize('#SFUI_SteamConnectionErrorTitle'), $.Localize('#SFUI_InvError_Item_Not_Given'), '', () => { });
            });
        });
    }
    function _ResetToRewardsBar(elRedeemBar, elConfirmBar) {
        elRedeemBar.SetHasClass('hidden', false);
        elConfirmBar.SetHasClass('hidden', true);
    }
    function _SetWarningText(elGrid, ShopEntry) {
        let warningText = '';
        let elWarning = elGrid.FindChildInLayoutFile('id-xpshop-item-warning');
        elWarning.SetHasClass('hidden', true);
        if (ShopEntry.entry_type !== 'crate') {
            return;
        }
        if (ShopEntry.lootlist) {
            let keyId = InventoryAPI.GetAssociatedItemIdByIndex(ShopEntry.lootlist[0], 0);
            elGrid.SetDialogVariable('keyname', InventoryAPI.GetItemName(keyId));
            elGrid.SetDialogVariable('casename', InventoryAPI.GetItemName(ShopEntry.lootlist[0]));
        }
        warningText = $.Localize('#xpshop_key_warning', elGrid);
        elWarning.SetHasClass('hidden', false);
        elGrid.SetDialogVariable('warning', warningText);
    }
    function _StartRedeemParticles() {
        const elRedeemFx = $.GetContextPanel().FindChildInLayoutFile('id-redeem-wait-particle');
        const HColor = [0, 255, 212];
        elRedeemFx.StartParticles();
        elRedeemFx.SetControlPoint(16, HColor[0], HColor[1], HColor[2]);
    }
    function _StopRedeemParticles() {
        const elRedeemFx = $.GetContextPanel().FindChildInLayoutFile('id-redeem-wait-particle');
        if (elRedeemFx !== null) {
            elRedeemFx.StopParticlesWithEndcaps();
        }
    }
    function _EnableRotateOnModel(elModel, lootlist_item_type = '') {
        if (lootlist_item_type === "sticker") {
            elModel.SetRotationLimits(50, 50);
        }
        else {
            elModel.SetRotationLimits(360, 360);
        }
        elModel.SetAutoRotateAmount(30, 20);
        elModel.SetAutoRotatePeriod(8, 8);
    }
    function _DisableRotateOnModel(elModel) {
        elModel.SetRotationLimits(0, 0);
        elModel.SetAutoRotateAmount(0, 0);
        elModel.SetAutoRotatePeriod(0, 0);
        elModel.SetRotation(0, 0, 0);
    }
    function _SetZoomInSizeAndPosition(ShopEntry, elShopTile, bUseNarrowZoom) {
        let baseWidth = ShopEntry.tile_width;
        let baseHeight = ShopEntry.tile_height;
        let zoomWidth = bUseNarrowZoom ? baseWidth : baseWidth * 2.0;
        let zoomHeight = baseHeight * 2.0;
        elShopTile.style.height = zoomHeight + 'px';
        elShopTile.style.width = zoomWidth + 'px';
        let tilePosX = Math.floor(elShopTile.actualxoffset / elShopTile.actualuiscale_x);
        let initialXTranslate = zoomWidth === baseWidth ? 0 : (baseWidth / 2);
        let sideOffset = 20;
        let contentPanelWidth = Math.floor(m_elContentPanel.actuallayoutwidth / m_elContentPanel.actualuiscale_x);
        let finalXTranslate = 0;
        if (tilePosX - initialXTranslate < m_elContentPanel.actualxoffset / m_elContentPanel.actualuiscale_x) {
            finalXTranslate = ((tilePosX) - sideOffset) * -1;
        }
        else if (((tilePosX - initialXTranslate) + zoomWidth) > contentPanelWidth) {
            finalXTranslate = (tilePosX - (contentPanelWidth - (zoomWidth + sideOffset))) * -1;
        }
        else {
            finalXTranslate = initialXTranslate * -1;
        }
        let tilePosY = Math.floor(elShopTile.actualyoffset / elShopTile.actualuiscale_y);
        let initialYTranslate = (baseHeight / 2);
        let finalYTranslate = 0;
        let contentPanelHeight = Math.floor(m_elContentPanel.actuallayoutheight / m_elContentPanel.actualuiscale_y);
        let bottomOffset = 64;
        if ((tilePosY + zoomHeight) > (contentPanelHeight - 40)) {
            finalYTranslate = (tilePosY - (contentPanelHeight - zoomHeight)) + bottomOffset;
        }
        else {
            finalYTranslate = initialYTranslate;
        }
        elShopTile.style.transform = 'translateX(' + finalXTranslate + 'px) translateY(' + (finalYTranslate * -1) + 'px)';
    }
    function ResetSizeAndPosition(ShopEntry, elShopTile) {
        elShopTile.style.width = (ShopEntry.tile_width) + 'px';
        elShopTile.style.height = (ShopEntry.tile_height) + 'px';
        elShopTile.style.transform = 'translateX(0px) translateY(0px)';
    }
    function PlaceTiles(elTilesContainer, ShopEntry) {
        if (ShopEntry.lootlist?.length === 1) {
            return;
        }
        let nRows = 0;
        let nTileY = 0;
        let itemsPerRow = ShopEntry.lootlist_item_type === 'weapon' ? 4 : ShopEntry.lootlist_item_type === 'sticker' ? 7 : 6;
        let contentPanelWidth = Math.floor(elTilesContainer.actuallayoutwidth / elTilesContainer.actualuiscale_x);
        let contentPanelHeight = Math.floor(elTilesContainer.actuallayoutheight / elTilesContainer.actualuiscale_y);
        let tileWidth = ShopEntry.tile_width;
        let tileHeight = ShopEntry.tile_height;
        let aChildren = elTilesContainer.Children();
        let xOffset = (contentPanelWidth - (tileWidth * itemsPerRow)) / 2;
        let yOffset = (contentPanelHeight - (tileHeight * (aChildren.length / itemsPerRow))) / 2;
        aChildren.forEach((element, idx) => {
            if (idx % itemsPerRow === 0) {
                nTileY = tileHeight * nRows;
                nRows++;
            }
            element.style.x = (idx % itemsPerRow * tileWidth) + xOffset + 'px';
            element.style.y = (nTileY + yOffset) + 'px';
        });
    }
    function CreateShopTile(elTilesContainer, itemId, ShopEntry) {
        let sStyle = 'xpshop__inspect-grid__tile';
        let mapName = ShopEntry.lootlist?.length === 1 ? GameInterfaceAPI.GetSettingString('ui_inspect_bkgnd_map') + '_vanity' : "ui/xpshop_item";
        let elPanel = $.CreatePanel('CSGOBlurTarget', elTilesContainer, itemId, { class: sStyle });
        if (ShopEntry.lootlist?.length === 1) {
            elPanel.SetHasClass('single-item', true);
        }
        else {
            elPanel.style.width = (ShopEntry.tile_width) + 'px';
            elPanel.style.height = (ShopEntry.tile_height) + 'px';
        }
        if (ShopEntry.lootlist?.length === 1) {
            InspectModelImage.Init(elPanel, itemId);
        }
        else {
            const defName = InventoryAPI.GetItemDefinitionName(itemId);
            elPanel.Data().defName = defName;
            let cameraData = m_CameraSettingsPerWeapon.find(({ type }) => type === defName);
            let cameraSuffix = cameraData !== undefined ? cameraData.camera : '0';
            let camera = 'camera_' + ShopEntry.lootlist_item_type + '_' + cameraSuffix;
            MakeMapItemPreviewPanel(elPanel, camera, mapName, ShopEntry);
        }
        MakeShopTileInfoElements(elPanel, itemId, ShopEntry);
        return elPanel;
    }
    function MakeMapItemPreviewPanel(elPanel, camera, mapName, ShopEntry) {
        return $.CreatePanel('MapItemPreviewPanel', elPanel, 'id-grid-item-model', {
            class: 'xpshop__inspect-grid__tile__model',
            "require-composition-layer": "true",
            'transparent-background': true,
            'disable-depth-of-field': true,
            camera: camera,
            player: "false",
            map: mapName,
            initial_entity: 'item',
            active_item_idx: 0,
            mouse_rotate: "true",
            rotation_limit_x: "0",
            rotation_limit_y: "0",
            auto_rotate_x: "0",
            auto_rotate_y: "0",
            auto_rotate_period_x: "0",
            auto_rotate_period_y: "0",
            auto_recenter: true,
            hittest: "true",
            hide_while_waiting_for_composite_materials: "false"
        });
    }
    function MakeShopTileInfoElements(elPanel, itemId, ShopEntry) {
        let sTitleStyle = 'xpshop__inspect-grid__tile__label';
        $.CreatePanel('Label', elPanel, '', { text: InventoryAPI.GetItemName(itemId), class: sTitleStyle });
        let elRarity = $.CreatePanel('Panel', elPanel, '', { class: 'xpshop__inspect-grid__tile__rarity' });
        let color = InventoryAPI.GetItemRarityColor(itemId);
        if (!color)
            elRarity.visible = false;
        else
            elRarity.style.backgroundColor = color;
        let Btn = $.CreatePanel('Button', elPanel, '', { class: 'xpshop__inspect-grid__tile__inspect-btn' });
        $.CreatePanel('Image', Btn, '').SetImage('file://{images}/icons/ui/zoom_in.svg');
        Btn.SetPanelEvent('onactivate', () => {
            if (ShopEntry.on_item_activate) {
                ShopEntry.on_item_activate(ShopEntry, itemId);
            }
        });
        if (ShopEntry.lootlist?.length === 1 && ShopEntry.limited_until) {
            let elHint = $.CreatePanel('Panel', elPanel, 'id-xpshop-limited-item-tooltip-loc');
            elHint.BLoadLayoutSnippet('limited-item-variety');
            elHint.SetPanelEvent('onmouseover', () => {
                UiToolkitAPI.ShowCustomLayoutTooltip('id-xpshop-limited-item-tooltip-loc', 'id-xpshop-limited-item-tooltip', 'file://{resources}/layout/tooltips/tooltip_limited_item_variation.xml');
            });
            elHint.SetPanelEvent('onmouseout', () => {
                UiToolkitAPI.HideCustomLayoutTooltip('id-xpshop-limited-item-tooltip');
            });
            elHint.AddClass('xpshop-preview-variety');
        }
    }
    function OpenFullscreenInspect(ShopEntry) {
        let nDefinitionIndex = InventoryAPI.GetItemDefinitionIndexFromDefinitionName(ShopEntry.item_name);
        let id = InventoryAPI.GetFauxItemIDFromDefAndPaintIndex(nDefinitionIndex, 0);
        UiToolkitAPI.ShowCustomLayoutPopupParameters('popup-inspect-' + id, 'file://{resources}/layout/popups/popup_capability_decodable.xml', 'key-and-case=' + '' + ',' + id +
            '&' + 'asyncworkitemwarning=no' +
            '&' + 'asyncforcehide=true' +
            '&' + 'inspectonly=true' +
            '&' + 'asyncworktype=decodeable' +
            '&' + 'onlyclosepurchasebar=true');
    }
    function _OpenFullScreenInspectItem(ShopEntry, itemId) {
        let nameOverride = ShopEntry.callout ? ShopEntry.callout : ShopEntry.item_name;
        $.DispatchEvent("LootlistItemPreview", itemId, ShopEntry.item_name + ',,,' + nameOverride);
    }
    function _DarkenTiles(elItemsContainer, SelectedPanel = null) {
        elItemsContainer.Children().forEach(element => {
            if (element && element.IsValid()) {
                element.SetHasClass('darken', element.id !== SelectedPanel?.id && SelectedPanel !== null);
            }
        });
    }
    function _UpdateVisibleInspectGrid(elParent, id) {
        elParent.Children().forEach(element => {
            element.SetHasClass('show', (element.id === id));
        });
    }
    function _MakeShowMainTilesNavBtn() {
        let elParent = $.GetContextPanel().FindChildInLayoutFile('id-xpshop-top-nav');
        let elBtn = elParent.FindChildInLayoutFile('id-nav-show-main-tiles-btn');
        if (!elBtn) {
            elBtn = $.CreatePanel('RadioButton', elParent, 'id-nav-show-main-tiles-btn', { group: 'xpshop-nav' });
            elBtn.BLoadLayoutSnippet('shop-nav');
            elBtn.FindChild('id-xpshop-nav-btn-img').SetImage('file://{images}/icons/ui/xpshop_tiles.svg');
            elBtn.SetPanelEvent('onactivate', () => {
                let elParent = $.GetContextPanel().FindChildInLayoutFile('id-xpshop-content');
                elParent.SetHasClass('xpshop-grids-visible', false);
            });
        }
    }
    function ShouldShowNewTagForShopEntry(ShopEntry) {
        if (ShopEntry.ui_show_new_tag) {
            let numSecondsRemaining = StoreAPI.GetSecondsUntilTimestamp(parseInt(ShopEntry.ui_show_new_tag));
            return (numSecondsRemaining > 0);
        }
        return false;
    }
    XpShop.ShouldShowNewTagForShopEntry = ShouldShowNewTagForShopEntry;
    function _MakeNavButton(ShopEntry) {
        let elParent = $.GetContextPanel().FindChildInLayoutFile('id-xpshop-top-nav');
        let elBtn = elParent.FindChildInLayoutFile(ShopEntry.item_name + '-nav');
        if (!elBtn) {
            elBtn = $.CreatePanel('RadioButton', elParent, ShopEntry.item_name + '-nav', { group: 'xpshop-nav' });
            elBtn.BLoadLayoutSnippet('shop-nav');
            elBtn.SetPanelEvent('onactivate', () => _UpdateInspectGrid(ShopEntry));
            elBtn.Data().ui_order = ShopEntry.ui_order;
            if (ShopEntry.ui_set_image) {
                const elImage = elBtn.FindChild('id-xpshop-nav-btn-img');
                IconUtil.SetupFallbackItemSetIcon(elImage, ShopEntry.ui_set_image);
                IconUtil.SetItemSetSVGImage(elImage, ShopEntry.ui_set_image);
            }
        }
    }
    function _CancelTimeoutForRewardItem() {
        _StopRedeemParticles();
        $.GetContextPanel().SetHasClass('waiting-for-redeem', false);
        if (m_showTimeoutScheduleHandle) {
            $.CancelScheduled(m_showTimeoutScheduleHandle);
            m_showTimeoutScheduleHandle = null;
        }
    }
    function _OnHideMainMenu() {
        _CancelTimeoutForRewardItem();
        _DeleteInspectGrid();
    }
    function _OnHidePauseMenu() {
        _CancelTimeoutForRewardItem();
        _DeleteInspectGrid();
    }
    $.RegisterForUnhandledEvent('UpdateXpShop', InventoryUpdate);
    $.RegisterForUnhandledEvent('CSGOHideMainMenu', _OnHideMainMenu);
    $.RegisterForUnhandledEvent('CSGOHidePauseMenu', _OnHidePauseMenu);
})(XpShop || (XpShop = {}));
