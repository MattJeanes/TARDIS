-- Simplified Chinese

local T = {}
T.Code = "zh-CN"
T.Name = "简体中文"
T.Phrases = {
    ["Common.Error"] = "错误",
    ["Common.TARDIS"] = "塔迪斯",
    ["Common.Interface"] = "塔迪斯界面",
    ["Common.OK"] = "确定",
    ["Common.Cancel"] = "取消",
    ["Common.Yes"] = "是",
    ["Common.No"] = "否",
    ["Common.DontAskAgain"] = "不再询问",
    ["Common.Save"] = "保存",
    ["Common.Set"] = "设定",
    ["Common.Load"] = "加载",
    ["Common.Reset"] = "复位",
    ["Common.New"] = "新建",
    ["Common.Remove"] = "移除",
    ["Common.Update"] = "更新",
    ["Common.Delete"] = "删除",
    ["Common.Default"] = "默认",
    ["Common.PowerDisabled"] = "能源已关闭",
    ["Common.PowerDisabledControl"] = "能源已关闭，此项不工作", This doesn't work",
    ["Common.Enabled.Lower"] = "启用",
    ["Common.Disabled.Lower"] = "禁用",
    ["Common.Opened.Lower"] = "已打开",
    ["Common.Closed.Lower"] = "已关闭",
    ["Common.Locked.Lower"] = "已上锁",
    ["Common.Unlocked.Lower"] = "已解锁",
    ["Common.Disengaged.Lower"] = "已释放",
    ["Common.Engaged.Lower"] = "已闭合",
    ["Common.NotYetImplemented"] = "此功能未实现",
    ["Common.UnknownError"] = "未知错误",
    ["Common.DoorsNotInstalled"] = "“Doors” 插件未安装",
    ["Common.EnterTextInput"] = "输入文本输入",
    ["Common.NotInTARDIS"] = "您不在塔迪斯中",
    ["Common.ControlSequencesEnabledWarning"] = "控制序列已启用，您必须使用序列", You must use the sequence",
    ["Common.Loading"] = "加载中……",
    ["Common.UnsavedChanges"] = "未保存的更改",
    ["Common.UnsavedChangesWarning"] = "您有未保存的更改，是否要保存它们？",

    ["Templates.MissingTemplate"] = "未找到模板 %s，%s 内部所需",

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
    ["Flight.DoorOpenNoBoost"] = "门打开时无法加速",

    ["HADS.Triggered"] = "敌对活动位移系统（H.A.D.S）已被触发！", has been triggered!",
    ["HADS.UnderAttack"] = "你的塔迪斯遭到攻击！",
    ["HADS.DematError"] = "有东西阻止了 H.A.D.S 让塔迪斯去物质化！", from dematerialising the TARDIS!",
    ["HADS.Mat"] = "你的塔迪斯正在降落",

    ["Health.RepairFinished"] = "你的塔迪斯已完成自我修复", Please vacate the interior",
    ["Health.RepairCancelled"] = "自我修复已被取消",
    ["Health.RepairActivated"] = "这架塔迪斯已启动自我修复。请离开内部",
    ["Health.Repairing"] = "这架塔迪斯正在修复。将在 %d 秒内完成", It will be done in %d seconds",

    ["Lock.Locked"] = "这架塔迪斯已上锁",

    ["Music.Stopped"] = "停止播放",
    ["Music.Playing"] = "播放：%s",
    ["Music.Loading"] = "加载音乐中……",
    ["Music.LoadFailed"] = "错误：加载失败（%s） ",
    ["Music.LoadFailedResponse"] = "错误：加载API响应失败",
    ["Music.LoadFailedResolve"] = "错误：解析URL失败（%s）",
    ["Music.LoadFailedMissingId"] = "错误：无法在URL中找到视频ID",
    ["Music.LoadFailedBass"] = "错误：加载歌曲失败（错误ID：%s，%s）",

    ["Prompts.LightingOverride"] = "此塔迪斯建议您启用照明覆盖，是否启用？这可以稍后在塔迪斯设置中更改", Enable now? This can be changed in TARDIS settings later",
    ["Prompts.LOD"] = "塔迪斯内部可能需要高精细模型，现在更改？",

    ["Redecorate.Failed"] = "重装修失败：生成替代失败",

    ["ThirdPerson.KeyHint"] = "提示：使用 “%s + %s” 键进入第三人称",

    ["Vortex.ModelMissing"] = "警告：旋涡模型无效 - 已禁用旋涡，你错过了一个依赖吗？",

    ["Controls.Isomorphic"] = "同构安全", You may not use any controls",

    ["Spin.Changed"] = "自旋方向已设为 %s",
    ["Spin.Directions.AntiClockwise"] = "逆时针",
    ["Spin.Directions.None"] = "无",
    ["Spin.Directions.Clockwise"] = "顺时针",

    ["TimeDistortionGenerator"] = "时间失真发生器",
    ["TimeDistortionGenerator.Instructions"] = "造成时间扭曲，扰乱 TARDIS 引擎，并阻止其起飞或着陆",
    ["TimeDistortionGenerator.Starting"] = "启动时扭曲发生器…",
    ["TimeDistortionGenerator.Disabled"] = "时间扭曲发生器已禁用",
    ["TimeDistortionGenerator.Enabled"] = "时间扭曲发生器已启用",
    ["TimeDistortionGenerator.Distortions"] = "警告：塔迪斯内部有东西在造成时间扭曲",

    ["MenuOptions.ResetClientsideSettings"] = "恢复客户端设置", ["MenuOptions.SectionReset"] = "塔迪斯客户端设置\"%s\"已被恢复，您可能需要重新生成塔迪斯以应用所有更改",
    ["MenuOptions.ConfirmSectionReset"] = "恢复\"%s\"部分的客户端设置？此步骤无法撤销！", This cannot be undone.",
    ["MenuOptions.SectionResetThisSection"] = "恢复设置（此部分）",
    ["MenuOptions.ResetAllSettings"] = "恢复所有设置",
    ["MenuOptions.ConfirmResetSettings"] = "恢复所有客户端设置？此步骤无法撤销！",
    ["MenuOptions.ResetSettingsConfirmation"] = "塔迪斯客户端设置已被恢复，您可能需要重新生成塔迪斯以应用所有更改", This cannot be undone.",
    ["Spawnmenu.ResetSettings"] = "恢复默认设置", You may need to respawn the TARDIS for all changes to apply.",

    ["Settings.Sections.GUI.ScreenRows"] = "界面行（屏幕）",

    ["Settings.Sections.GUI.OldGUI"] = "使用旧的界面",
    ["Settings.Sections.GUI.OldGUI.Description"] = "使用没有图片的旧界面来代替新的",
    
    ["Settings.Sections.GUI.BigPopup"] = "更大界面的弹出框",
    ["Settings.Sections.GUI.BigPopup.Description"] = "新的可视化界面的弹出框是否更大",
    
    ["Settings.Sections.GUI.ScreenOverrideRows"] = "界面行覆盖",
    ["Settings.Sections.GUI.ScreenRows.Description"] = "屏幕上的可视化界面应该有多少行按钮",
    
    ["Settings.Sections.GUI.ScreenOverrideRows.Description"] = "是否覆盖按钮行的内部设置",
    ["Settings.Sections.GUI.PopupRows.Description"] = "弹出框中的可视化界面应该有多少行按钮",
    
    ["Settings.Sections.GUI.PopupRows"] = "界面行（弹出框）",
    ["Settings.Sections.GUI.Theme.Description"] = "用户界面的主题",
    
    ["Settings.Sections.GUI.Theme"] = "界面主题",
    ["Settings.Sections.GUI"] = "用户界面", -- NOD --

    ["Settings.Sections.Performance"] = "性能",
    
    ["Settings.Sections.Performance.LightingOverride"] = "照明覆盖",
    ["Settings.Sections.Performance.LightingOverride.Description"] = "更好的室内照明。但可能导致低端系统的性能下降",
    
    ["Settings.Sections.Performance.Portals"] = "启用传送门",
    ["Settings.Sections.Performance.Portals.Description"] = "不管传送门是否会显示，如果对帧率有显著影响，关闭此项",
    
    ["Settings.Sections.Performance.DoorCloseDistance"] = "门关闭的距离",
    ["Settings.Sections.Performance.DoorCloseDistance.Description"] = "门自动关闭的距离",
    
    ["Settings.Sections.Performance.DynamicExteriorLight"] = "动态外部光源",
    ["Settings.Sections.Performance.DynamicExteriorLight.Description"] = "外部是否发出动态光源",

    ["Settings.Sections.Performance.ProjectedDoorExteriorLight"] = "门外光源投影",
    ["Settings.Sections.Performance.ProjectedDoorExteriorLight.Description"] = "当门打开时，光线是否从门里照射出来",

    ["Settings.Sections.Performance.BreakdownEffects"] = "损坏特效",
    ["Settings.Sections.Performance.BreakdownEffects.Description"] = "塔迪斯在紧急情况下是否发出闪光和爆炸效果",

    ["Settings.Sections.Exterior"] = "外部",

    ["Settings.Sections.Exterior.Light"] = "外部照明",
    
    ["Settings.Sections.Exterior.Light.EnableColorOverride"] = "启用颜色覆盖",
    ["Settings.Sections.Exterior.Light.EnableColorOverride.Description"] = "是否启用外部灯光颜色覆盖",

    ["Settings.Sections.Exterior.Light.ColorOverride"] = "颜色覆盖",
    ["Settings.Sections.Exterior.Light.ColorOverride.Description"] = "外部灯光的覆盖颜色",

    ["Settings.Sections.Exterior.Light.AlwaysOn"] = "外部灯光常亮",
    ["Settings.Sections.Exterior.Light.AlwaysOn.Description"] = "外部灯光是否常亮",

    ["Settings.Sections.Exterior.ProjectedLight"] = "光源投射",

    ["Settings.Sections.Exterior.ProjectedLight.EnableBrightnessOverride"] = "启用亮度覆盖",
    ["Settings.Sections.Exterior.ProjectedLight.EnableBrightnessOverride.Description"] = "是否启用投射光亮度覆盖",

    ["Settings.Sections.Exterior.ProjectedLight.EnableColorOverride"] = "启用颜色覆盖",
    ["Settings.Sections.Exterior.ProjectedLight.EnableColorOverride.Description"] = "是否启用投射光颜色覆盖",

    ["Settings.Sections.Exterior.ProjectedLight.EnableDistanceOverride"] = "启用光距覆盖",
    ["Settings.Sections.Exterior.ProjectedLight.EnableDistanceOverride.Description"] = "是否启用投射光光距覆盖",

    ["Settings.Sections.Exterior.ProjectedLight.BrightnessOverride"] = "亮度覆盖",
    ["Settings.Sections.Exterior.ProjectedLight.BrightnessOverride.Description"] = "覆盖投射光的亮度",

    ["Settings.Sections.Exterior.ProjectedLight.DistanceOverride"] = "光距覆盖",
    ["Settings.Sections.Exterior.ProjectedLight.DistanceOverride.Description"] = "覆盖投射光光距",

    ["Settings.Sections.Exterior.ProjectedLight.ColorOverride"] = "颜色覆盖",
    ["Settings.Sections.Exterior.ProjectedLight.ColorOverride.Description"] = "覆盖投射光的颜色",

    ["Settings.Sections.Global"] = "管理员选项",

    ["Settings.Sections.Global.EnableHealth"] = "启用生命值",
    ["Settings.Sections.Global.EnableHealth.Description"] = "塔迪斯是否有生命值并会受到伤害",

    ["Settings.Sections.Global.MaxHealth"] = "最大生命值",
    ["Settings.Sections.Global.MaxHealth.Description"] = "塔迪斯的最大生命值",

    ["Settings.Sections.Global.BoostSpeed"] = "加速速度",
    ["Settings.Sections.Global.BoostSpeed.Description"] = "按下加速键后，塔迪斯的加速速度",

    ["Settings.Sections.Misc"] = "杂项",

    ["Settings.Sections.Misc.NotificationType"] = "通知类型",
    ["Settings.Sections.Misc.NotificationType.Description"] = "正在使用的通知类型",
    ["Settings.Sections.Misc.NotificationType.Types.Disabled"] = "禁用",
    ["Settings.Sections.Misc.NotificationType.Types.ConsoleLog"] = "控制台日志",
    ["Settings.Sections.Misc.NotificationType.Types.Chat"] = "聊天通知",
    ["Settings.Sections.Misc.NotificationType.Types.Inbuilt"] = "内置通知",

    ["Settings.Sections.Misc.EnableControlSequences"] = "启用控制序列",
    ["Settings.Sections.Misc.EnableControlSequences.Description"] = "是否启用控制序列（以前的高级模式）",
    
    ["Settings.Sections.Misc.IsomorphicSecurityDefault"] = "默认启用同构安全",
    ["Settings.Sections.Misc.IsomorphicSecurityDefault.Description"] = "默认其他人是否可以操作你的塔迪斯",
    
    ["Settings.Sections.Misc.Teleport"] = "传送",

    ["Settings.Sections.Misc.Teleport.AutoCloseDoors"] = "起飞时自动关门",
    ["Settings.Sections.Misc.Teleport.AutoCloseDoors.Description"] = "塔迪斯是否在起飞前自动关门",

    ["Settings.Sections.Misc.Teleport.DestinationDematOnSet"] = "目的地设定既起飞",
    ["Settings.Sections.Misc.Teleport.DestinationDematOnSet.Description"] = "塔迪斯是否在设定目的地后立即起飞",

    ["Settings.Sections.Misc.Teleport.ShowVortex"] = "显示时间漩涡",
    ["Settings.Sections.Misc.Teleport.ShowVortex.Description"] = "漩涡飞行时是否显示漩涡",
    
    ["Settings.Sections.Misc.Flight"] = "飞行",

    ["Settings.Sections.Misc.Flight.StopSpinningOpenDoor"] = "开门时停止自旋",
    ["Settings.Sections.Misc.Flight.StopSpinningOpenDoor.Description"] = "在飞行中开门时，塔迪斯是否停止旋转",

    ["Settings.Sections.Misc.Flight.DisableBoostOpenDoor"] = "开门时禁用加速",
    ["Settings.Sections.Misc.Flight.DisableBoostOpenDoor.Description"] = "在飞行中开门时，塔迪斯是否禁用加速功能",

    ["Settings.Sections.Misc.Flight.UseWalkKeyThirdPerson"] = "使用行走键进入第三人称",
    ["Settings.Sections.Misc.Flight.UseWalkKeyThirdPerson.Description"] = "在控制台按下使用键（默认为“E”）时，是否按下行走键（默认为“ALT”）以进入第三人称",

    ["Settings.Sections.Misc.Tips"] = "提示",

    ["Settings.Sections.Misc.Tips.Enabled"] = "提示",
    ["Settings.Sections.Misc.Tips.Enabled.Description"] = "塔迪斯控制台上是否显示提示",

    ["Settings.Sections.Misc.Tips.Style"] = "提示风格",
    ["Settings.Sections.Misc.Tips.Style.Description"] = "塔迪斯提示所使用的风格",

    ["Settings.Sections.Misc.Spawning"] = "生成塔迪斯",

    ["Settings.Sections.Misc.Spawning.PreferClassicDoor"] = "经典门内饰",
    ["Settings.Sections.Misc.Spawning.PreferClassicDoor.Description"] = "是否默认生成经典门版本的内饰（双层门）",

    ["Settings.Sections.Misc.Spawning.RandomizeSkins"] = "随机皮肤",
    ["Settings.Sections.Misc.Spawning.RandomizeSkins.Description"] = "生成塔迪斯时是否随机皮肤",

    ["Settings.Sections.Misc.Spawning.UseWinterSkins"] = "使用冬季皮肤",
    ["Settings.Sections.Misc.Spawning.UseWinterSkins.Description"] = "随机皮肤时是否会使用冬季皮肤",

    ["Settings.Sections.Misc.Language"] = "语",
    ["Settings.Sections.Misc.Language.Description"] = "插件的语言，对于任何缺失的翻译回退到英语",
    ["Settings.Sections.Misc.Language.Default"] = "游戏语言",
    
    ["Settings.Sections.SoundsAndMusic.Music"] = "音乐",

    ["Settings.Sections.SoundsAndMusic.Sounds"] = "音效",

    ["Settings.Sections.SoundsAndMusic.Sounds.All"] = "全部音效",
    ["Settings.Sections.SoundsAndMusic.Sounds.All.Description"] = "让您轻松静音所有的声音",

    ["Settings.Sections.SoundsAndMusic.Sounds.ExternalHum"] = "外部的嗡嗡声",
    ["Settings.Sections.SoundsAndMusic.Sounds.ExternalHum.Description"] = "是否能听到塔迪斯外部的嗡嗡声（如果存在）",

    ["Settings.Sections.SoundsAndMusic.Sounds.Cloak"] = "隐形音效",
    ["Settings.Sections.SoundsAndMusic.Sounds.Cloak.Description"] = "是否播放塔迪斯隐形音效",

    ["Settings.Sections.SoundsAndMusic.Sounds.Door"] = "门音效",
    ["Settings.Sections.SoundsAndMusic.Sounds.Door.Description"] = "开关门时是否发出声音",

    ["Settings.Sections.SoundsAndMusic.Sounds.FlightExternal"] = "飞行模式音效（外部）",
    ["Settings.Sections.SoundsAndMusic.Sounds.FlightExternal.Description"] = "是否在外部播放飞行音效",

    ["Settings.Sections.SoundsAndMusic.Sounds.Lock"] = "锁定音效",
    ["Settings.Sections.SoundsAndMusic.Sounds.Lock.Description"] = "开关锁时是否发出声音",

    ["Settings.Sections.SoundsAndMusic.Sounds.Teleport"] = "传送音效",
    ["Settings.Sections.SoundsAndMusic.Sounds.Teleport.Description"] = "传送时是否发出声音",

    ["Settings.Sections.SoundsAndMusic.Sounds.CloisterBells"] = "修道院钟声",
    ["Settings.Sections.SoundsAndMusic.Sounds.Idle.Description"] = "是否在内部播放空闲音效",

    ["Settings.Sections.SoundsAndMusic.Sounds.FlightInternal"] = "飞行模式音效（内部）",
    ["Settings.Sections.SoundsAndMusic.Sounds.FlightInternal.Description"] = "是否在内部播放飞行音效",

    ["Settings.Sections.SoundsAndMusic.Sounds.Idle"] = "空闲音效",
    ["Settings.Sections.SoundsAndMusic.Sounds.CloisterBells.Description"] = "紧急状况下是否响起修道院钟声",

    ["Settings.Sections.SoundsAndMusic"] = "音效与音乐",

    ["Settings.Sections.SoundsAndMusic.Music.Enabled"] = "启用",
    ["Settings.Sections.SoundsAndMusic.Music.Enabled.Description"] = "是否能通过屏幕播放音乐",

    ["Settings.Sections.SoundsAndMusic.Music.Volume"] = "音量",
    ["Settings.Sections.SoundsAndMusic.Music.Volume.Description"] = "通过屏幕播放的音乐的音量",

    ["Settings.Sections.SoundsAndMusic.Music.StopOnExit"] = "退出时停止",
    ["Settings.Sections.SoundsAndMusic.Music.StopOnExit.Description"] = "离开塔迪斯时是否停止播放音乐",

    ["Settings.Sections.Binds"] = "键绑定",

    ["Settings.Sections.Other"] = "其他",

    ["Binds.Key"] = "键",
    ["Binds.Invalid"] = "无效",
    ["Binds.AnyKey"] = "按下任意键",

    ["Binds.Sections.ThirdPerson"] = "第三人称",
    ["Binds.Sections.ThirdPerson.ToggleCloak"] = "切换隐形",
    ["Binds.Sections.ThirdPerson.Destination"] = "目的地",
    ["Binds.Sections.ThirdPerson.Destination.Description"] = "输入目标选择状态",
    ["Binds.Sections.ThirdPerson.ToggleFlight"] = "切换飞行",
    ["Binds.Sections.ThirdPerson.ToggleFloat"] = "切换漂浮",
    ["Binds.Sections.ThirdPerson.ToggleFloat.Description"] = "让塔迪斯像没有重力一样飞行",
    ["Binds.Sections.ThirdPerson.TogglePhyslock"] = "切换物理锁定",
    ["Binds.Sections.ThirdPerson.TogglePhyslock.Description"] = "让塔迪斯在空间中不可移动",
    ["Binds.Sections.ThirdPerson.ToggleDoor"] = "切换门",
    ["Binds.Sections.ThirdPerson.OpenScreen"] = "打开屏幕",
    ["Binds.Sections.ThirdPerson.OpenScreen.Description"] = "切换HUD屏幕",

    ["Binds.Sections.Destination"] = "目的地",
    ["Binds.Sections.Destination.Forward"] = "前",
    ["Binds.Sections.Destination.Backward"] = "后",
    ["Binds.Sections.Destination.Left"] = "左",
    ["Binds.Sections.Destination.Right"] = "右",
    ["Binds.Sections.Destination.Up"] = "上",
    ["Binds.Sections.Destination.Down"] = "下",
    ["Binds.Sections.Destination.Boost"] = "加速",
    ["Binds.Sections.Destination.Boost.Description"] = "按住此键以加速移动",
    ["Binds.Sections.Destination.Slow"] = "减速",
    ["Binds.Sections.Destination.Slow.Description"] = "按住此键以减速移动",
    ["Binds.Sections.Destination.Rotate"] = "旋转",
    ["Binds.Sections.Flight.Rotate.Description"] = "按住此键+左/右以旋转",
    ["Binds.Sections.Destination.SnapToFloor"] = "对齐到地面",
    ["Binds.Sections.Destination.SnapToFloor.Description"] = "按下此键对齐到最近的地面",
    
    ["Binds.Sections.Flight"] = "飞行",
    ["Binds.Sections.Flight.Forward"] = "前",
    ["Binds.Sections.Flight.Backward"] = "后",
    ["Binds.Sections.Flight.Left"] = "左",
    ["Binds.Sections.Flight.Right"] = "右",
    ["Binds.Sections.Flight.Up"] = "上",
    ["Binds.Sections.Flight.Down"] = "下",
    ["Binds.Sections.Flight.Boost"] = "加速",
    ["Binds.Sections.Flight.Boost.Description"] = "飞行时按住此键以加速",
    ["Binds.Sections.Flight.Rotate"] = "旋转",
    ["Binds.Sections.Float.Rotate.Description"] = "按住此键同时使用左和右来偏航",
    ["Binds.Sections.Flight.SpinDirection"] = "自旋方向",
    ["Binds.Sections.Flight.SpinDirection.Description"] = "改变塔迪斯飞行时自旋的方向",
    
    ["Binds.Sections.Float"] = "漂浮",
    ["Binds.Sections.Float.Forward"] = "前",
    ["Binds.Sections.Float.Backward"] = "后",
    ["Binds.Sections.Float.Left"] = "左",
    ["Binds.Sections.Float.Right"] = "右",
    ["Binds.Sections.Float.Boost"] = "加速",
    ["Binds.Sections.Float.Boost.Description"] = "漂浮时按住此键以加速旋转",
    ["Binds.Sections.Float.Rotate"] = "旋转",
    ["Binds.Sections.Destination.Rotate.Description"] = "按住加速键同时使用左和右以旋转",
    ["Binds.Sections.Float.Brake"] = "制动",
    ["Binds.Sections.Float.Brake.Description"] = "漂浮时按住此键以减慢旋转",
    
    ["Binds.Sections.Teleport"] = "传送",
    ["Binds.Sections.Teleport.Demat"] = "起飞",
    ["Binds.Sections.Teleport.Mat"] = "降落",
    ["Binds.Sections.Teleport.Set"] = "设定",

    ["Controls.Cloak"] = "隐形",
    ["Controls.Cloak.Tip"] = "隐形装置",
    ["Controls.Cloak.Status"] = "隐形",
    ["Controls.Cloak.FailedToggle"] = "切换隐形失败",

    ["Controls.Coordinates.Tip"] = "坐标",

    ["Controls.Destination"] = "目的地",
    ["Controls.Destination.Tip"] = "目的地设定",

    ["Controls.Door"] = "门",
    ["Controls.Door.Tip"] = "门切换",
    ["Controls.Door.Status"] = "门",
    ["Controls.Door.UsingEmergencyPower"] = "使用紧急能源开门……",
    ["Controls.Door.NoSwitch"] = "门开关无效",
    ["Controls.Door.FailedOpen"] = "开门失败",
    ["Controls.Door.FailedClose"] = "关门失败",
    ["Controls.Door.Locked"] = "门已上锁",

    ["Controls.DoorLock"] = "门锁",
    ["Controls.DoorLock.Tip"] = "门锁",
    ["Controls.DoorLock.NotWorking"] = "门锁无效",
    ["Controls.DoorLock.UsingEmergencyPower"] = "使用紧急能源解锁……",
    ["Controls.DoorLock.FailedToggle"] = "开解锁失败",

    ["Controls.EngineRelease"] = "引擎制动",
    ["Controls.EngineRelease.Tip"] = "引擎制动",
    ["Controls.EngineRelease.ForceDemat"] = "强制起飞已触发",
    ["Controls.EngineRelease.FailedDemat"] = "起飞失败",

    ["Controls.FastReturn"] = "快速返回",
    ["Controls.FastReturn.Tip"] = "快速返回协议",
    ["Controls.FastReturn.Activated"] = "快速返回协议以启动",
    ["Controls.FastReturn.Failed"] = "快速返回协议启动失败",

    ["Controls.Flight"] = "飞行模式",
    ["Controls.Flight.Tip"] = "飞行模式",
    ["Controls.Flight.Status"] = "飞行模式",
    ["Controls.Flight.FailedToggle"] = "切换飞行模式失败",

    ["Controls.Float"] = "反重力",
    ["Controls.Float.Tip"] = "反重力",
    ["Controls.Float.Status"] = "反重力",
    ["Controls.Float.FailedToggle"] = "切换反重力失败",

    ["Controls.HADS"] = "敌对活动位移系统",
    ["Controls.SpinCycle.Tip"] = "自旋",
    ["Controls.HADS.Status"] = "敌对活动位移系统",

    ["Controls.Handbrake"] = "时间转子手刹",
    ["Controls.Handbrake.Tip"] = "时间转子手刹",
    ["Controls.Handbrake.Status"] = "时间转子手刹",
    ["Controls.Handbrake.FailedToggle"] = "切换时间转子手刹失败",

    ["Controls.InteriorLights.Tip"] = "灯光",

    ["Controls.Isomorphic.Status"] = "同构安全",
    ["Controls.Isomorphic.Tip"] = "同构安全系统",
    ["Controls.Isomorphic.FailedToggle"] = "切换同构安全系统失败",
    ["Controls.Redecorate.FailedToggle"] = "启用重装修失败",
    ["Controls.Isomorphic.NotCreator"] = "这不是您的塔迪斯",
    ["Controls.Isomorphic.SingleplayerWarning"] = "警告：同构安全在单人游戏中无效",

    ["Controls.Music.Tip"] = "音乐",

    ["Controls.Physlock"] = "物理锁定",
    ["Controls.Physlock.Tip"] = "锁定机制",
    ["Controls.Physlock.Status"] = "锁定机制",
    ["Controls.Physlock.FailedToggle"] = "切换物理锁定机制失败",

    ["Controls.Power"] = "能源",
    ["Controls.Power.Tip"] = "能源",
    ["Controls.Power.Status"] = "能源",
    ["Controls.Power.FailedToggle"] = "切换能源失败",

    ["Controls.RandomCoords.Tip"] = "随机发生器",
    ["Controls.RandomCoords.Selected"] = "已设定随机目的地",
    
    ["Controls.Redecorate"] = "重装修",
    ["Controls.Redecorate.Tip"] = "重装修",
    ["Controls.Redecorate.Status"] = "重装修",
    ["Controls.Repair.FailedToggle"] = "切换自我修复失败",
    ["Controls.Redecorate.RandomInteriorWarning"] = "警告：已随机选择新的内饰。右击生成菜单手动选择", ["Spawnmenu.AlternativeVersions"] = "选择版本：",
    ["Controls.Redecorate.NotCreator"] = "您不能重装修其他人的塔迪斯",

    ["Controls.Repair"] = "自我修复",
    ["Controls.Repair.Tip"] = "自我修复",
    ["Controls.VortexFlight.FailedToggle"] = "切换漩涡飞行失败",

    ["Controls.Scanner.Tip"] = "监视器",

    ["Controls.Shields.Tip"] = "护盾",

    ["Controls.SonicDispenser.Tip"] = "音速充电口",
    ["Controls.SonicDispenser.MissingAddon"] = "您没有安装 Sonic Screwdriver 插件，安装它来使这个部件工作", Install it for this part to work",
    ["Controls.SonicDispenser.Dispensed"] = "音速起子已被分配",
    ["Controls.SonicDispenser.Equipped"] = "音速起子已经配备",
    ["Controls.SonicDispenser.AlreadyEquipped"] = "您已经有音速起子了",

    ["Controls.SpinCycle"] = "自旋方向",
    ["Controls.SpinToggle.Tip"] = "切换自旋",

    ["Controls.SpinSwitch.Tip"] = "自旋方向",
    ["Controls.SpinSwitch.ChangedDisabled"] = "自旋已被禁用，但自旋方向设置为 %s",

    ["Controls.SpinToggle.Status"] = "自旋",
    ["Controls.ToggleScreens.Status"] = "内部屏幕",

    ["Controls.Stabilizers.Tip"] = "飞行稳定器",

    ["Controls.Teleport"] = "传送",
    ["Controls.Teleport.Tip"] = "时空节流阀",
    ["Controls.Teleport.Mat"] = "降落……",
    ["Controls.Teleport.FailedMat"] = "降落失败",
    ["Controls.Teleport.Demat"] = "起飞……",
    ["Controls.Teleport.FailedDematDoorsOpen"] = "无法在门打开时起飞",
    ["Controls.Teleport.FailedDematHandbrake"] = "时间转子手刹已闭合，无法起飞", Cannot dematerialise",
    ["Controls.Teleport.FailedDemat"] = "起飞失败",

    ["Controls.ThirdPersonCareful.Tip"] = "手动飞行控制",

    ["Controls.ThirdPerson"] = "飞行控制",
    ["Controls.ThirdPerson.Tip"] = "手动飞行控制",

    ["Controls.ToggleScreens"] = "切换屏幕",
    ["Controls.ToggleScreens.Tip"] = "切换屏幕",
    ["Controls.ToggleScreens.FailedToggle"] = "切换内部屏幕失败",
    ["Screens.VirtualConsole.Old.TogglePower"] = "切换能源",

    ["Controls.VirtualConsole.Tip"] = "虚拟控制台",

    ["Controls.VortexFlight"] = "漩涡飞行",
    ["Controls.VortexFlight.Tip"] = "漩涡飞行",
    ["Controls.VortexFlight.Status"] = "漩涡飞行",
    ["Parts.DefaultWibblyLever.Text"] = "Wibbly控制杆",

    ["Parts.DefaultAtomAccelerator.Text"] = "原子加速器",
    ["Parts.DefaultDematCircuit.Text"] = "去物质化电路",
    ["Parts.DefaultDirectionalPointer.Text"] = "定向指针",
    ["Parts.DefaultGramophone.Text"] = "留声机",
    ["Parts.DefaultHelmic.Text"] = "赫尔米克调节器",
    ["Parts.DefaultScreen.Text"] = "监控器",
    ["Interiors.Default"] = "默认",

    ["Parts.Door.Locked"] = "门已上锁",

    ["Interiors.DefaultTTCapsule"] = "TT时间舱 默认",
    
    ["TipStyles.Default"] = "默认（取决内饰）",
    ["Interiors.Default.Versions.TTCapsule"] = "TT时间舱版本",

    ["Themes.Default"] = "默认",
    ["Themes.Transparent"] = "透明",
    ["Themes.TextOnly"] = "仅文字",

    ["Spawnmenu.PreferredDoorType.Default"] = "默认（在塔迪斯设置中配置）",
    ["TipStyles.Classic"] = "经典",
    ["TipStyles.WhiteOnBlue"] = "蓝底白字",
    ["TipStyles.WhiteOnGrey"] = "白底蓝字",

    ["Screens.Common.Back"] = "返回",
    ["Screens.Common.Menu"] = "菜单",
    ["Screens.Common.Exit"] = "退出",
    ["Screens.Common.Popup"] = "弹出窗",
    ["Screens.Common.CurrentPage"] = "第%d页，共%d页",

    ["Screens.Coordinates"] = "坐标",
    ["Screens.Coordinates.Saved"] = "位置已保存",
    ["Screens.Coordinates.Loaded"] = "位置已加载",
    ["Screens.Coordinates.NoDestinationSet"] = "无目的地设定",
    ["Screens.Coordinates.SelectManually"] = "手动选择",
    ["Screens.Coordinates.X"] = "X",
    ["Screens.Coordinates.Y"] = "Y",
    ["Screens.Coordinates.Z"] = "Z",
    ["Screens.Coordinates.Pitch"] = "俯仰",
    ["Screens.Coordinates.Yaw"] = "偏航",
    ["Screens.Coordinates.Roll"] = "翻滚",
    ["Screens.Coordinates.Name"] = "名称",
    ["Screens.Coordinates.Unnamed"] = "未命名",
    ["Screens.Coordinates.CurrentSetDestination"] = "当前设定目的地",
    ["Screens.Coordinates.RandomGround"] = "随机（地面）",
    ["Screens.Coordinates.Random"] = "随机",
    ["Screens.Coordinates.RandomLocationGround"] = "地面随机位置",
    ["Screens.Coordinates.RandomLocation"] = "随机位置",
    ["Screens.Coordinates.GetCurrentPosition"] = "获取当前位置",
    ["Screens.Coordinates.NameNewLocationFromInputs"] = "输入新位置的名称（将使用输入的信息）",
    ["Screens.Coordinates.NameNewLocation"] = "输入新位置的名称",
    ["Screens.Coordinates.NewLocation"] = "新位置",
    ["Screens.Coordinates.NewLocationUseCurrentPos"] = "使用当前TARDIS位置和旋转？\n选择'%s'将使用输入的信息",
    ["Screens.Coordinates.RemoveLocation"] = "移除位置",
    ["Screens.Coordinates.ConfirmRemoveLocation"] = "这将永久删除所选位置！你确定吗？", Are you sure?",

    ["Screens.Music"] = "音乐",
    ["Screens.Music.MissingName"] = "您需要指定自定义曲目的名称来添加它",
    ["Screens.Music.MissingUrl"] = "您需要指定自定义音轨的URL来添加它",
    ["Screens.Music.Conflict"] = "同名的音乐曲目已经存在",
    ["Screens.Music.CannotRemoveDefault"] = "无法删除预加载的音乐",
    ["Screens.Music.DeleteNoSelection"] = "没有选择移除任何东西",
    ["Screens.Music.NoChoice"] = "没有选择音乐",
    ["Screens.Music.DefaultLoadError"] = "加载预加载音乐错误：%s",
    ["Screens.Music.UnableToDecodeList"] = "无法解码列表",
    ["Screens.Music.CustomAdded"] = "自定义曲目'%s'已添加：%s",
    ["Screens.Music.CustomRemoved"] = "自定义曲目'%s'已移除：%s",
    ["Screens.Music.DefaultMusic"] = "预加载音乐",
    ["Screens.Music.CustomMusic"] = "自定义曲目",
    ["Screens.Music.UrlPlaceholder"] = "输入音乐URL",
    ["Screens.Music.NamePlaceholder"] = "输入自定义曲目名称",
    ["Screens.Music.PlayStop"] = "播放/停止",
    ["Screens.Music.DeleteConfirm"] = "您确定要从音乐列表中删除\"%s\"吗？此步骤无法撤销！", This cannot be undone",

    ["Screens.Scanner"] = "监视器",
    ["Screens.Scanner.Front"] = "前",
    ["Screens.Scanner.Back"] = "后",
    ["Screens.Scanner.Left"] = "左",
    ["Screens.Scanner.Right"] = "右",

    ["Screens.VirtualConsole"] = "虚拟控制台",
    ["Screens.VirtualConsole.Old.CloseDoor"] = "关门",
    ["Screens.VirtualConsole.Old.Repair"] = "修复塔迪斯",
    ["Screens.VirtualConsole.Old.FastRemat"] = "快速实现",
    ["Screens.VirtualConsole.Old.Physlock"] = "物理锁定",
    ["Screens.VirtualConsole.Old.FastReturn"] = "快速返回",
    ["Screens.VirtualConsole.Old.HADS"] = "HADS",
    ["Screens.VirtualConsole.Old.OpenDoor"] = "开门",
    ["Screens.VirtualConsole.Old.DoorOpening"] = "门打开",
    ["Screens.VirtualConsole.Old.UnlockDoor"] = "门解锁",
    ["Screens.VirtualConsole.Old.LockDoor"] = "门上锁",
    ["Screens.VirtualConsole.Old.DoorClosing"] = "门关闭",
    ["Screens.VirtualConsole.Old.LockLocking"] = "锁：上锁中",
    ["Screens.VirtualConsole.Old.LockUnlocking"] = "锁：解锁中",
    ["Screens.VirtualConsole.Old.LockLocking"] = "Lock: Locking",

    ["Spawnmenu.RedecorationSelected"] = "塔迪斯内部装饰选定，请在您的塔迪斯中启用重装修", ["Spawnmenu.RedecorationSelectedRestart"] = "塔迪斯内部装饰选定，重新启动重装修以应用更改",
    ["Spawnmenu.SelectForRedecoration"] = "选择重装修", ["Spawnmenu.RedecorationExclude"] = "排除在随机重装修外",
    ["Spawnmenu.Spawn"] = "生成",
    ["Spawnmenu.ReloadGame"] = "重新加载游戏以应用更改",
    ["Spawnmenu.FavoritesUpdated"] = "收藏夹已更新",
    ["Spawnmenu.ClassicDoorsVersion"] = "经典门版本：",
    ["Spawnmenu.DoubleDoorsVersion"] = "双层门版本：",
    ["Spawnmenu.CustomVersions"] = "自定义版本：",
    ["Spawnmenu.VersionOptions.RandomOriginalAndCustom"] = "随机（原始和自定义版本）",
    ["Spawnmenu.VersionOptions.Default"] = "默认",
    ["Spawnmenu.VersionOptions.Random"] = "随机",
    ["Spawnmenu.VersionOptions.RandomOriginal"] = "随机（原始版本）",
    ["Spawnmenu.PreferredDoorType.Random"] = "随机",
    ["Spawnmenu.Settings"] = "设置",
    ["Spawnmenu.PreferredVersion"] = "首选的版本",
    ["Spawnmenu.PreferredDoorType"] = "首选的门的类型",
    ["Spawnmenu.PreferredDoorType.Double"] = "双层门",
    ["Spawnmenu.PreferredDoorType.Classic"] = "经典门",
    ["Spawnmenu.Category"] = "神秘博士 - 塔迪斯",
    ["Spawnmenu.AddToFavourites"] = "添加到收藏夹（需要重新加载）",
    ["Spawnmenu.PreferredDoorType.Double"] = "Double doors",
    ["Spawnmenu.RemoveFromFavourites"] = "从收藏夹中移除（需要重新加载）",
    ["Spawnmenu.RemoveFromFavourites"] = "Remove from favorites (reload required)",
    ["Spawnmenu.CategoryTools"] = "神秘博士 - TARDIS 工具",
    ["Spawnmenu.CategoryTools"] = "Doctor Who - TARDIS Tools",
    ["Spawnmenu.RedecorationExclude"] = "Exclude from random redecoration",
    ["Spawnmenu.ResetSettings"] = "Reset settings",

    ["Settings.NoPermissionGlobalSettings"] = "您没有权限编辑全局设置",

    ["Wiremod.Inputs.Demat"] = "使塔迪斯起飞",
    ["Wiremod.Inputs.Mat"] = "使塔迪斯降落",
    ["Wiremod.Inputs.Pos"] = "X,Y,Z：传送位置",
    ["Wiremod.Inputs.Ang"] = "X,Y,Z：传送角度",

    ["Wiremod.Outputs.Health"] = "塔迪斯生命值",
}

TARDIS:AddLanguage(T)
