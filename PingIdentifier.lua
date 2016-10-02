PingIdentifier = CreateFrame("Frame", nil, UIParent)
PingIdentifier.Frame = PingIdentifierFrame
PingIdentifier.FrameText = PingIdentifierFrameText
LibStub("AceTimer-3.0"):Embed(PingIdentifier)

function PingIdentifier:OnInitialize()
    self.lastPingPlayerGUID = nil
    self.pingCount = {}
    self.pingText = ""

    self:SetScript("OnEvent", function (self, ...) self:OnEvent(...) end)
    self:RegisterEvent("MINIMAP_PING")
    self.Frame:SetScale(0.8)
    self.Frame:SetAlpha(1)
    self:UpdateScreen()
end

function PingIdentifier:UpdateScreen()
    self.Frame:ClearAllPoints()
    self.Frame:SetPoint("TOP", "Minimap", "BOTTOM", 0, 5)
end

function PingIdentifier:OnEvent(event, pingPlayerGUID, ...)
    if not pingPlayerGUID ~= self.lastPingPlayerGUID then
        local pingPlayerClass = UnitClass(pingPlayerGUID):upper()
        local color = RAID_CLASS_COLORS[pingPlayerClass].colorStr
        local pingPlayer = UnitName(pingPlayerGUID)
        self.pingText = "Ping: |c" .. color .. pingPlayer
    end
    if not self.pingCount[pingPlayerGUID] then
        self.pingCount[pingPlayerGUID] = 1
        self.FrameText:SetText(self.pingText)
    else
        self.pingCount[pingPlayerGUID] = self.pingCount[pingPlayerGUID] + 1
        self.FrameText:SetText(self.pingText .. " |cffffffffx" .. self.pingCount[pingPlayerGUID])
    end
    self.Frame:SetWidth(self.FrameText:GetWidth() + 16)
    self.Frame:SetHeight(self.FrameText:GetHeight() + 12)
    self.Frame:Show()
    self:CancelAllTimers()
    self:ScheduleTimer("HidePingText", 5)
    self.lastPingPlayerGUID = pingPlayerGUID
end

function PingIdentifier:HidePingText()
    self.Frame:Hide()
    self.pingCount = {}
end

PingIdentifier:OnInitialize()
