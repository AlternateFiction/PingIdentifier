local PingIdentifier = LibStub("AceAddon-3.0"):NewAddon("PingIdentifier", "AceEvent-3.0", "AceHook-3.0", "AceTimer-3.0")
_G.PingIdentifier = PingIdentifier

local f, ft


function PingIdentifier:OnInitialize()
    self:InitConfig()
    self.ping = {
        lastUnit = "",
        count = {},
        playerText = "",
    }

    f = CreateFrame("Frame", "PingIdentifierFrame", MiniMapPing)
    f:Hide()
    f:SetFrameStrata("TOOLTIP")
    f:SetBackdrop({bgFile="Interface\\Tooltips\\UI-Tooltip-Background", edgeFile="Interface\\Tooltips\\UI-Tooltip-Border", tile=true, edgeSize=16, tileSize=16, insets={left=5, right=5, top=5, bottom=5}})
    f:SetBackdropColor(TOOLTIP_DEFAULT_BACKGROUND_COLOR.r, TOOLTIP_DEFAULT_BACKGROUND_COLOR.g, TOOLTIP_DEFAULT_BACKGROUND_COLOR.b)
    f:SetBackdropBorderColor(TOOLTIP_DEFAULT_COLOR.r, TOOLTIP_DEFAULT_COLOR.g, TOOLTIP_DEFAULT_COLOR.b)
    ft = f:CreateFontString("PingIdentifierFrameText", "ARTWORK", "GameFontNormalSmall")
    ft:SetPoint("CENTER", 0, 0)

    self:RegisterEvent("MINIMAP_PING")
    self:UpdateScreen()
end

function PingIdentifier:MINIMAP_PING(event, unit, ...)
    self:ShowPingText(unit)
end

function PingIdentifier:UpdateScreen()
    f:ClearAllPoints()
    f:SetPoint(self.db.AnchorPosFrame, "Minimap", self.db.AnchorPosParent, self.db.PosX, self.db.PosY)
    f:SetScale(self.db.Scale)
    f:SetAlpha(self.db.Alpha)
end

function PingIdentifier:ShowPingText(unit)
    if not unit then return end
    local prefixText, countText = "", ""

    if self.db.PingPrefix then
        prefixText = "Ping: "
    end

    if unit ~= self.ping.lastUnit then
        local _, class = UnitClass(unit)
        local color = RAID_CLASS_COLORS[class].colorStr
        local name = UnitName(unit)
        self.ping.playerText = "|c" .. color .. name .. "|r"
    end

    if not self.ping.count[unit] then
        self.ping.count[unit] = 1
    else
        self.ping.count[unit] = self.ping.count[unit] + 1
        countText = " |cffffffffx" .. self.ping.count[unit] .. "|r"
    end

    ft:SetText(prefixText .. self.ping.playerText .. countText)
    f:SetWidth(ft:GetWidth() + 16)
    f:SetHeight(ft:GetHeight() + 12)
    f:Show()

    self:CancelAllTimers()
    self:ScheduleTimer("HidePingText", self.db.DisplayTime)
    self.ping.lastUnit = unit
end

function PingIdentifier:HidePingText()
    f:Hide()
    self.ping.count = {}
end
