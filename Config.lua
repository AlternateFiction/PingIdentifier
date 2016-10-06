local PI = _G.PingIdentifier

-- key is the returned value from the options panel 
-- value is the displayed value in the options panel
PI.anchorOpt = {
    TOP = "TOP",
    BOTTOM = "BOTTOM",
    LEFT = "LEFT",
    RIGHT = "RIGHT",
}


-- create shallow copy of table (taken from AceDB-3.0.lua)
local function copyTable(src, dest)
    if type(dest) ~= "table" then dest = {} end
    if type(src) == "table" then
        for k,v in pairs(src) do
            if type(v) == "table" then
                -- try to index the key first so that the metatable creates the defaults, if set, and use that table
                v = copyTable(v, dest[k])
            end
            dest[k] = v
        end
    end
    return dest
end

local function CreateDb()
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
            return PI.activeDb[info[#info]]
        end,
        set = function(info, value)
            PI.activeDb[info[#info]] = value
            PI:ScheduleTimer(function() PI:UpdateScreen() PI:ShowPingText("player") end, 0.1)
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



function PI:InitConfig()
    self.db = LibStub("AceDB-3.0"):New("PingIdentifierDB", CreateDb(), "Default").profile
    self.activeDb = copyTable(self.db)
    LibStub("AceConfig-3.0"):RegisterOptionsTable(self.name, CreateConfig)
    local f = LibStub("AceConfigDialog-3.0"):AddToBlizOptions(self.name)
    self:Hook(f, "okay", "SaveOptions", true)
    self:Hook(f, "cancel", "DiscardOptions", true)
    self:Hook(f, "default", "ResetOptions", true)
end

function PI:SaveOptions()
    -- if we use copyTable we mess up the metatables
    for k,v in pairs(self.activeDb) do
        self.db[k] = v
    end
end

function PI:DiscardOptions()
    self.activeDb = copyTable(self.db)
end

function PI:ResetOptions()
    self.activeDb = CreateDb().profile
    LibStub("AceConfigRegistry-3.0"):NotifyChange(self.name) -- refresh dialog
end

function PI:OpenOptions()
    InterfaceOptionsFrame_OpenToCategory(self.name)
end

SlashCmdList[PI.name:upper()] = PI.OpenOptions
_G["SLASH_"..PI.name:upper().."1"] = "/"..PI.name
