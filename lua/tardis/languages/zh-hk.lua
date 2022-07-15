-- Traditional Chinese

local T = {}
T.Code = "zh-HK"
T.Name = "繁體中文"
T.Phrases = {
    ["Common.Error"] = "錯誤",

    ["Templates.MissingTemplate"] = "未找到模板 %s，%s 內部所需",

    ["Destination.LockedReadyToMat"] = "目標鎖定，准備降落",
    ["Destination.FailedSetDestinationMaybeTransitioning"] = "未能設置目標，可能轉換中",
    ["Destination.LockedDemat"] = "目標鎖定，起飛……",
    ["Destination.FailedDemat"] = "去物質化失敗",
    ["Destination.LockedReadyToDemat"] = "目標鎖定，准備起飛",
    ["Destination.FailedSetDestination"] = "未能設置目標",

    ["Flight.WarnPhyslockEngaged"] = "警告：物理鎖定已啟動",
    ["Flight.NameIsThePilot"] = "%s 系飛行員",
    ["Flight.NameIsNowThePilot"] = "%s 依家系飛行員",
    ["Flight.YouAreNowThePilot"] = "你依家系飛行員",
    ["Flight.NoLongerPilot"] = "你不再系飛行員了",

    ["HADS.Triggered"] = "敵對活動位移系統（H.A.D.S）已被觸發！",
    ["HADS.UnderAttack"] = "你嘅塔迪斯遭到攻擊！",
    ["HADS.DematError"] = "有嘢阻止了 H.A.D.S 使塔迪斯去物質化！",
    ["HADS.Mat"] = "你嘅塔迪斯系度降落",

    ["Health.RepairActivated"] = "呢架塔迪斯已啟動自我修復。請離開內部",
    ["Health.RepairCancelled"] = "自我修復已被攞消",
    ["Health.RepairFinished"] = "你嘅塔迪斯已完成自我修復",
    ["Health.Repairing"] = "呢架塔迪斯系度修復。將喺 %d 秒內完成",

    ["Lock.Locked"] = "呢架塔迪斯已上鎖",

    ["Music.Stopped"] = "停止播放",
    ["Music.Playing"] = "播放：%s",
    ["Music.Loading"] = "加載音樂中……",

    ["ThirdPerson.KeyHint"] = "提示：使用 “%s + %s” 鍵進入第三人稱",
}

TARDIS:AddLanguage(T)
