local PingIdentifier = LibStub("AceAddon-3.0"):NewAddon("PingIdentifier", "AceTimer-3.0", "AceEvent-3.0")
_G.PingIdentifier = PingIdentifier

local f, ft


function PingIdentifier:OnInitialize()
    self.db = LibStub("AceDB-3.0"):New("PingIdentifierDB", self:CreateDB(), "Default").profile
    self.lastPingPlayerGUID = nil
    self.pingCount = {}
    self.pingText = ""

    f = CreateFrame("Frame", "PingIdentifierFrame", MiniMapPing)
    f:Hide()
    f:SetFrameStrata("TOOLTIP")
    f:SetBackdrop({bgFile="Interface\\Tooltips\\UI-Tooltip-Background", edgeFile="Interface\\Tooltips\\UI-Tooltip-Border", tile=true, edgeSize=16, tileSize=16, insets={left=5, right=5, top=5, bottom=5}})
    f:SetBackdropBorderColor(TOOLTIP_DEFAULT_COLOR.r, TOOLTIP_DEFAULT_COLOR.g, TOOLTIP_DEFAULT_COLOR.b)
    f:SetBackdropColor(TOOLTIP_DEFAULT_BACKGROUND_COLOR.r, TOOLTIP_DEFAULT_BACKGROUND_COLOR.g, TOOLTIP_DEFAULT_BACKGROUND_COLOR.b)
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
    f:SetPoint(self.anchorOpt[self.db.AnchorPosFrame], "Minimap", self.anchorOpt[self.db.AnchorPosParent], self.db.PosX, self.db.PosY)
    f:SetScale(self.db.Scale)
    f:SetAlpha(self.db.Alpha)
end

function PingIdentifier:ShowPingText(pingPlayerGUID, ...)
    if not pingPlayerGUID ~= self.lastPingPlayerGUID then
        local pingPlayerClass = UnitClass(pingPlayerGUID):upper()
        local color = RAID_CLASS_COLORS[pingPlayerClass].colorStr
        local pingPlayer = UnitName(pingPlayerGUID)
        self.pingText = "Ping: |c" .. color .. pingPlayer
    end
    if not self.pingCount[pingPlayerGUID] then
        self.pingCount[pingPlayerGUID] = 1
        ft:SetText(self.pingText)
    else
        self.pingCount[pingPlayerGUID] = self.pingCount[pingPlayerGUID] + 1
        ft:SetText(self.pingText .. " |cffffffffx" .. self.pingCount[pingPlayerGUID])
    end
    f:SetWidth(ft:GetWidth() + 16)
    f:SetHeight(ft:GetHeight() + 12)
    f:Show()
    self:CancelAllTimers()
    self:ScheduleTimer("HidePingText", self.db.DisplayTime)
    self.lastPingPlayerGUID = pingPlayerGUID
end

function PingIdentifier:HidePingText()
    f:Hide()
    self.pingCount = {}
end
