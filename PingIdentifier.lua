local PingIdentifier = LibStub("AceAddon-3.0"):NewAddon("PingIdentifier", "AceEvent-3.0", "AceHook-3.0", "AceTimer-3.0")
_G.PingIdentifier = PingIdentifier

local f, ft


function PingIdentifier:OnInitialize()
    self:InitConfig()
    self.ping = {
        lastPlayerId = nil,
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

function PingIdentifier:MINIMAP_PING(event, ...)
    self:ShowPingText(...)
end

function PingIdentifier:UpdateScreen()
    f:ClearAllPoints()
    f:SetPoint(self.activeDb.AnchorPosFrame, "Minimap", self.activeDb.AnchorPosParent, self.activeDb.PosX, self.activeDb.PosY)
    f:SetScale(self.activeDb.Scale)
    f:SetAlpha(self.activeDb.Alpha)
end

function PingIdentifier:ShowPingText(playerId, ...)
    local prefixText, countText = "", ""
    if self.activeDb.PingPrefix then
        prefixText = "Ping: "
    end
    if not playerId ~= self.ping.lastPlayerId then
        local _, class = UnitClass(playerId)
        local color = RAID_CLASS_COLORS[class].colorStr
        local name = UnitName(playerId)
        self.ping.playerText = "|c" .. color .. name .. "|r"
    end
    if not self.ping.count[playerId] then
        self.ping.count[playerId] = 1
    else
        self.ping.count[playerId] = self.ping.count[playerId] + 1
        countText = " |cffffffffx" .. self.ping.count[playerId] .. "|r"
    end
    ft:SetText(prefixText .. self.ping.playerText .. countText)
    f:SetWidth(ft:GetWidth() + 16)
    f:SetHeight(ft:GetHeight() + 12)
    f:Show()
    self:CancelAllTimers()
    self:ScheduleTimer("HidePingText", self.activeDb.DisplayTime)
    self.ping.lastPlayerId = playerId
end

function PingIdentifier:HidePingText()
    f:Hide()
    self.ping.count = {}
end
