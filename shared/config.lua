return {
    colors = {
        innocent = Color3.fromRGB(0, 255, 0),
        murderer = Color3.fromRGB(255, 0, 0),
        sheriff   = Color3.fromRGB(0, 100, 255),
    },
    cooldowns = {
        autoShoot = 0.3,
        autoKillAll = 1,
        autoFling = 2,
    },
    themes = {
        "Linux",
    },
    -- Whether to attempt running the adonisbypass script at startup.
    -- Set to false to disable automatic bypass execution.
    RunBypass = true,
}