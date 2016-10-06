local PI = _G.PingIdentifier

-- key is the returned value from the options panel 
-- value is the displayed value in the options panel
PI.anchorOpt = {
    TOP = "TOP",
    BOTTOM = "BOTTOM",
    LEFT = "LEFT",
    RIGHT = "RIGHT",
}


function PI:CreateDB()
    return {
        profile = {
            Scale = 1,
            Alpha = 1,
            PosX = 0,
            PosY = 0,
            AnchorPosFrame = "TOP",
            AnchorPosParent = "BOTTOM",
            DisplayTime = 5,
            PingPrefix = true,
        }
    }
end

local function CreateConfig()
    return {
        type = "group",
        name = PI.name,
        order = 1,
        get = function(info)
            return PI.db[info[#info]]
        end,
        set = function(info, value)
            PI:ScheduleTimer(function() PI:UpdateScreen() PI:ShowPingText("player") end, 0.1)
            PI.db[info[#info]] = value
        end,
        args = {
            GroupGeneral = {
                type = "group",
                name = "Display Options",
                order = 1,
                inline = true,
                args = {
                    AnchorPosFrame = {
                        type = "select",
                        style = "dropdown",
                        name = "Frame anchor point",
                        desc = "Which point of the notification to pin to the minimap.",
                        order = 1,
                        values = PI.anchorOpt,
                    },
                    AnchorPosParent = {
                        type = "select",
                        style = "dropdown",
                        name = "Minimap anchor point",
                        desc = "Which point of the minimap to pin the notification to.",
                        order = 4,
                        values = PI.anchorOpt,
                    },
                    Scale = {
                        type = "range",
                        name = "Scale",
                        desc = "Size multiplier of the notification.",
                        order = 2,
                        softMin = 0.1,
                        softMax = 3,
                        step = 0.1,
                    },
                    Alpha = {
                        type = "range",
                        name = "Alpha",
                        desc = "Opacity of the notification.",
                        order = 5,
                        min = 0,
                        max = 1,
                        step = 0.1,
                        isPercent = true,
                    },
                    PosX = {
                        type = "range",
                        name = "Offset X",
                        desc = "Horizontal adjustment of the notification.",
                        order = 3,
                        softMin = -100,
                        softMax = 100,
                        step = 1,
                    },
                    PosY = {
                        type = "range",
                        name = "Offset Y",
                        desc = "Vertical adjustment of the notification.",
                        order = 6,
                        softMin = -100,
                        softMax = 100,
                        step = 1,
                    },
                    DisplayTime = {
                        type = "range",
                        name = "Duration",
                        desc = "Number of seconds the notification is shown.",
                        order = 7,
                        softMin = 1,
                        softMax = 20,
                        step = 1,
                        width = "double",
                    },
                    PingPrefix = {
                        type = "toggle",
                        name = "Ping prefix",
                        desc = "Show the text \"Ping:\" in front of the name of the player who pinged the minimap.",
                        order = 8,
                    },
                },
            },
        },
    }
end

function PI:OpenOptions()
    InterfaceOptionsFrame_OpenToCategory(PI.name)
end

LibStub("AceConfig-3.0"):RegisterOptionsTable(PI.name, CreateConfig)
LibStub("AceConfigDialog-3.0"):AddToBlizOptions(PI.name)
SlashCmdList[PI.name:upper()] = PI.OpenOptions
_G["SLASH_"..PI.name:upper().."1"] = "/"..PI.name
