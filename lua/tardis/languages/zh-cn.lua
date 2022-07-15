-- Simplified Chinese

local T = {}
T.Code = "zh-CN"
T.Name = "简体中文"
T.Phrases = {
    ["Common.Error"] = "错误",

    ["Templates.MissingTemplate"] = "未找到模板 %s，%s 内部所需 ",

    ["Destination.LockedReadyToMat"] = "目的地锁定，准备降落",
    ["Destination.FailedSetDestinationMaybeTransitioning"] = "未能设定目的地，可能转换中",
    ["Destination.LockedDemat"] = "目的地锁定，起飞中……",
    ["Destination.FailedDemat"] = "去物质化失败",
    ["Destination.LockedReadyToDemat"] = "目的地锁定，准备起飞",
    ["Destination.FailedSetDestination"] = "未能设定目的地",

    ["Flight.WarnPhyslockEngaged"] = "警告：物理锁定已启动",
    ["Flight.NameIsThePilot"] = "%s 是飞行员",
    ["Flight.NameIsNowThePilot"] = "%s 现在是飞行员",
    ["Flight.YouAreNowThePilot"] = "你现在是飞行员",
    ["Flight.NoLongerPilot"] = "你不再是飞行员了",

    ["HADS.Triggered"] = "敌对活动位移系统（H.A.D.S）已被触发！",
    ["HADS.UnderAttack"] = "你的塔迪斯遭到攻击！",
    ["HADS.DematError"] = "有东西阻止了 H.A.D.S 让塔迪斯去物质化！",
    ["HADS.Mat"] = "你的塔迪斯正在降落",

    ["Health.RepairActivated"] = "这架塔迪斯已启动自我修复。请离开内部",
    ["Health.RepairCancelled"] = "自我修复已被取消",
    ["Health.RepairFinished"] = "你的塔迪斯已完成自我修复",
    ["Health.Repairing"] = "这架塔迪斯正在修复。将在 %d 秒内完成",

    ["Lock.Locked"] = "这架塔迪斯已上锁",

    ["Music.Stopped"] = "停止播放",
    ["Music.Playing"] = "播放：%s",
    ["Music.Loading"] = "加载音乐中……",

    ["ThirdPerson.KeyHint"] = "提示：使用 “%s + %s” 键进入第三人称",
}

TARDIS:AddLanguage(T)
