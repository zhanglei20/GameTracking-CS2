"use strict";
/// <reference path="csgo.d.ts" />
/// <reference path="common/licenseutil.ts" />
/// <reference path="generated/items_event_current_generated_store.d.ts" />
/// <reference path="generated/items_event_current_generated_store.ts" />
var MainMenuMajorTile;
(function (MainMenuMajorTile) {
    const _m_cp = $.GetContextPanel();
    function _Init() {
        let bVisible = true;
        if (!MyPersonaAPI.IsConnectedToGC())
            bVisible = false;
        else if (LicenseUtil.GetCurrentLicenseRestrictions())
            bVisible = false;
        else if (!g_ActiveTournamentInfo.active)
            bVisible = false;
        _m_cp.SetHasClass('hidden', !bVisible);
        if (!bVisible)
            return;
        _m_cp.FindChildInLayoutFile('id-btn-open-major-hub').SetPanelEvent('onactivate', OpenMajorHub);
        _m_cp.SetHasClass('major-' + g_ActiveTournamentInfo.eventid.toString(), true);
        _m_cp.FindChildInLayoutFile('id-img-open-major-hub').SetImage('file://{images}/tournaments/backgrounds/pickem_mainmenu_promo_' + g_ActiveTournamentInfo.eventid + '.psd');
        let sRestriction = InventoryAPI.GetDecodeableRestriction("capsule");
        let bHasActualCapsulesForPurchase = false;
        _m_cp.SetHasClass('has-reduction', false);
        let tournamentEventId = NewsAPI.GetActiveTournamentEventID();
        if ((tournamentEventId !== 0)) {
            const getRandomInt = (min, max) => Math.floor(Math.random() * (max - min + 1)) + min;
            const defidxStickerItem = InventoryAPI.GetItemDefinitionIndexFromDefinitionName('sticker');
            const numSticker = 3;
            for (let i = 0; i < numSticker; i++) {
                const itemId = InventoryAPI.GetFauxItemIDFromDefAndPaintIndex(defidxStickerItem, g_ActiveTournamentTeams[getRandomInt(0, g_ActiveTournamentTeams.length - 1)].players[getRandomInt(0, 4)].stickerids[getRandomInt(0, 3)]);
                _m_cp.FindChildInLayoutFile('id-open-major-item-image-' + i).itemid = itemId;
                bHasActualCapsulesForPurchase = true;
            }
            let reduction = '';
            _m_cp.SetHasClass('has-reduction', reduction !== '' && reduction !== undefined);
            _m_cp.FindChildInLayoutFile('id-items-banner').SetDialogVariable('items-text', reduction ? $.Localize('#store_sale') : $.Localize('#mainmenu_major_hub_items'));
        }
        _m_cp.SetDialogVariable('hub-title-bar-caption', $.Localize(bHasActualCapsulesForPurchase ? '#mainmenu_major_hub' : '#mainmenu_major_hub_no_items'));
        _m_cp.SetHasClass('can-sell-items', bHasActualCapsulesForPurchase);
    }
    function OpenMajorHub() {
        UiToolkitAPI.ShowCustomLayoutPopupParameters('id-popup-major-hub', 'file://{resources}/layout/popups/popup_major_hub.xml', 'eventid=' + (g_ActiveTournamentInfo.eventid));
    }
    {
        _Init();
        $.RegisterForUnhandledEvent('PanoramaComponent_MyPersona_GcLogonNotificationReceived', _Init);
        $.RegisterForUnhandledEvent('PanoramaComponent_MyPersona_UpdateConnectionToGC', _Init);
        $.RegisterForUnhandledEvent('PanoramaComponent_Store_PriceSheetChanged', _Init);
    }
})(MainMenuMajorTile || (MainMenuMajorTile = {}));
