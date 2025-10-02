import { CSPlayerPawn, Instance } from "cs_script/point_script";

const traceFrequency = 0;
const drawDuration = 0;

/** @type {"line" | "sphere" | "box" | "bullet" | null} */
let traceType = null;
/** @type {CSPlayerPawn | undefined} */
let tracePawn = undefined;

Instance.OnScriptReload({
    before: () => {
        return { traceType, tracePawn };
    },
    after: (memory) => {
        if (memory) {
            traceType = memory.traceType;
            tracePawn = memory.tracePawn;
        }
    },
});

Instance.OnPlayerChat(({ player, text }) => {
    tracePawn = player?.GetPlayerPawn();
    if (text === "!traceline") {
        traceType = "line";
    } else if (text === "!tracesphere") {
        traceType = "sphere";
    } else if (text === "!tracebox") {
        traceType = "box";
    } else if (text === "!tracebullet") {
        traceType = "bullet";
    } else {
        traceType = null;
    }
});

Instance.SetThink(() => {
    Instance.SetNextThink(Instance.GetGameTime() + traceFrequency);
    if (!tracePawn || !tracePawn.IsValid()) return;

    const start = tracePawn.GetEyePosition();
    const forward = getForward(tracePawn.GetEyeAngles());
    const end = vectorAdd(start, vectorScale(forward, 4000));

    if (traceType === "line") {
        const result = Instance.TraceLine({ start, end, ignoreEntity: tracePawn });

        if (result.didHit) {
            Instance.DebugSphere({ center: result.end, radius: 1, duration: drawDuration, color: { r: 255, g: 0, b: 0 } });
            const normalEnd = vectorAdd(result.end, vectorScale(result.normal, 10));
            Instance.DebugLine({ start: result.end, end: normalEnd, duration: drawDuration, color: { r: 255, g: 255, b: 0 } });
        }
    } else if (traceType === "sphere") {
        const result = Instance.TraceSphere({ start, end, radius: 10, ignoreEntity: tracePawn, ignorePlayers: true });

        Instance.DebugSphere({ center: result.end, radius: 5, duration: drawDuration, color: { r: 255, g: 0, b: 0 } });
        if (result.didHit) {
            const normalStart = vectorAdd(result.end, vectorScale(result.normal, 5));
            const normalEnd = vectorAdd(normalStart, vectorScale(result.normal, 10));
            Instance.DebugLine({ start: normalStart, end: normalEnd, duration: drawDuration, color: { r: 255, g: 255, b: 0 } });
        }
    } else if (traceType === "box") {
        const mins = { x: -10, y: -10, z: -10 };
        const maxs = { x: 10, y: 10, z: 10 };

        const result = Instance.TraceBox({ start, end, mins, maxs, ignoreEntity: tracePawn });

        Instance.DebugBox({ mins: vectorAdd(result.end, mins), maxs: vectorAdd(result.end, maxs), duration: drawDuration, color: { r: 255, g: 0, b: 0 } });
        if (result.didHit) {
            const normalEnd = vectorAdd(result.end, vectorScale(result.normal, 10));
            Instance.DebugLine({ start: result.end, end: normalEnd, duration: drawDuration, color: { r: 255, g: 255, b: 0 } });
        }
    } else if (traceType === "bullet") {
        let weaponData = tracePawn.GetActiveWeapon()?.GetData();
        if (!weaponData) return;

        const end = vectorAdd(start, vectorScale(forward, weaponData.GetRange()));

        const mins = { x: -1, y: -1, z: -1 };
        const maxs = { x: 1, y: 1, z: 1 };

        const results = Instance.TraceBullet({
            start,
            end,
            shooter: tracePawn,
            damage: weaponData.GetDamage(),
            rangeModifier: weaponData.GetRangeModifier(),
            penetration: weaponData.GetPenetration(),
        });
        for (const result of results) {
            let color = { r: 255, g: 0, b: 0 };
            if (result.hitEntity.IsWorld()) {
                color = { r: 0, g: 0, b: 255 };
            } else if (result.damage < 1) {
                color = { r: 0, g: 255, b: 0 };
            } else if (result.damage < 100) {
                color.g = lerp(255, 0, result.damage / 100);
            } else if (result.damage > 100) {
                color.b = lerp(0, 255, (result.damage - 100) / 100);
            }
            Instance.DebugBox({ mins: vectorAdd(result.position, mins), maxs: vectorAdd(result.position, maxs), duration: drawDuration, color });
        }
    }
});
Instance.SetNextThink(Instance.GetGameTime());

/**
 * @param {import("cs_script/point_script").Vector} vec1
 * @param {import("cs_script/point_script").Vector} vec2
 * @returns {import("cs_script/point_script").Vector}
 */
function vectorAdd(vec1, vec2) {
    return { x: vec1.x + vec2.x, y: vec1.y + vec2.y, z: vec1.z + vec2.z };
}

/**
 * @param {import("cs_script/point_script").Vector} vec
 * @param {number} scale
 * @returns {import("cs_script/point_script").Vector}
 */
function vectorScale(vec, scale) {
    return { x: vec.x * scale, y: vec.y * scale, z: vec.z * scale };
}

/**
 * @param {import("cs_script/point_script").QAngle} angles
 * @returns {import("cs_script/point_script").Vector}
 */
function getForward(angles) {
    const pitchRadians = (angles.pitch * Math.PI) / 180;
    const yawRadians = (angles.yaw * Math.PI) / 180;
    const hScale = Math.cos(pitchRadians);
    return {
        x: Math.cos(yawRadians) * hScale,
        y: Math.sin(yawRadians) * hScale,
        z: -Math.sin(pitchRadians),
    };
}

/**
 * @param {number} a
 * @param {number} b
 * @param {number} t
 */
function lerp(a, b, t) {
    return a + (b - a) * t;
}
