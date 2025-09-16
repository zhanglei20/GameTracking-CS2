import { Instance, BaseModelEntity } from "cs_script/point_script";

// mdl 1 - models/de_overpass/construction/ladder/ladder_stand_open_1.vmdl
// mdl 2 - models/de_overpass/overpass_bike/bike_01.vmdl
// mdl 3 - models/generic/terrace_set_01/terrace_chair_01.vmdl

let bGlowing = false;

function GetProp() {
    const ent = Instance.FindEntityByName("mdlchange.prop_dyn");
	if ( ent instanceof BaseModelEntity )
		return ent;
}
function Init() {
    const prop = GetProp();
    if (prop) {
        prop.Unglow();
    }
}
Instance.OnActivate(Init);
Instance.OnReload(Init);

let scale = 1.0;
Instance.OnScriptInput("ScaleUp", () => {
    const prop = GetProp();
    if (prop) {
        scale *= 1.25;
        prop.SetModelScale(scale);
    }
});

Instance.OnScriptInput("ScaleDown", () => {
    const prop = GetProp();
    if (prop) {
        scale /= 1.25;
        prop.SetModelScale(scale);
    }
});

Instance.OnScriptInput("SetModelVar1", () => {
    const prop = GetProp();
    if (prop) {
        prop.SetModel("models/de_overpass/construction/ladder/ladder_stand_open_1.vmdl");
		bGlowing = false;
        prop.Unglow();
    }
});

Instance.OnScriptInput("SetModelVar2", () => {
    const prop = GetProp();
    if (prop) {
        prop.SetModel("models/de_overpass/overpass_bike/bike_01.vmdl");
		bGlowing = false;
        prop.Unglow();
    }
});

Instance.OnScriptInput("SetModelVar3", () => {
    const prop = GetProp();
    if (prop) {
        prop.SetModel("models/generic/terrace_set_01/terrace_chair_01.vmdl");
		bGlowing = false;
        prop.Unglow();
    }
});

Instance.OnScriptInput("GlowToggle", () => {
    const prop = GetProp();
    if (prop) {
        bGlowing = !bGlowing;
        if (bGlowing) prop.Glow();
        else prop.Unglow();
    }
});
