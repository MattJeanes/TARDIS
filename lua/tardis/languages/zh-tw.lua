-- Traditional Chinese

local T = {}
T.Code = "zh-TW"
T.Name = "繁體中文"
T.Phrases = {
    ["Common.Error"] = "錯誤",
    ["Common.TARDIS"] = "塔迪斯",
    ["Common.Interface"] = "塔迪斯界面",
    ["Common.OK"] = "確定",
    ["Common.Cancel"] = "取消",
    ["Common.Yes"] = "是",
    ["Common.No"] = "否",
    ["Common.DontAskAgain"] = "不再詢問",
    ["Common.Save"] = "保存",
    ["Common.Set"] = "設定",
    ["Common.Load"] = "加載",
    ["Common.Reset"] = "復位",
    ["Common.New"] = "新建",
    ["Common.Remove"] = "移除",
    ["Common.Update"] = "更新",
    ["Common.Delete"] = "刪除",
    ["Common.Default"] = "預設",
    ["Common.PowerDisabled"] = "能源已關閉",
    ["Common.PowerDisabledControl"] = "能源已關閉，此裝置停用",
    ["Common.Enabled.Lower"] = "啓用",
    ["Common.Disabled.Lower"] = "禁用",
    ["Common.Opened.Lower"] = "已打開",
    ["Common.Closed.Lower"] = "已關閉",
    ["Common.Locked.Lower"] = "已上鎖",
    ["Common.Unlocked.Lower"] = "已解鎖",
    ["Common.Engaged.Lower"] = "已閉合",
    ["Common.Disengaged.Lower"] = "已釋放",
    ["Common.NotYetImplemented"] = "此項功能未實現",
    ["Common.UnknownError"] = "未知錯誤",
    ["Common.DoorsNotInstalled"] = "「Doors」 插件未安裝",
    ["Common.EnterTextInput"] = "輸入文本輸入",
    ["Common.NotInTARDIS"] = "您不在塔迪斯中",
    ["Common.ControlSequencesEnabledWarning"] = "控製序列已啟用，你必須使用序列",
    ["Common.Loading"] = "加載中……",
    ["Common.UnsavedChanges"] = "未保存的更改",
    ["Common.UnsavedChangesWarning"] = "您有未保存的更改，是否要保存它們？",

    ["Templates.MissingTemplate"] = "未找到模板 %s，%s 內部所需",

    ["Destination.LockedReadyToMat"] = "目標鎖定，準備降落",
    ["Destination.FailedSetDestinationMaybeTransitioning"] = "未能設置目標，可能轉換中",
    ["Destination.LockedDemat"] = "目標鎖定，起飛……",
    ["Destination.FailedDemat"] = "去物質化失敗",
    ["Destination.LockedReadyToDemat"] = "目標鎖定，準備起飛",
    ["Destination.FailedSetDestination"] = "未能設置目標",

    ["Flight.WarnPhyslockEngaged"] = "警告：物理鎖定已啟動",
    ["Flight.NameIsThePilot"] = "%s 是飛行員",
    ["Flight.NameIsNowThePilot"] = "%s 現在是飛行員",
    ["Flight.YouAreNowThePilot"] = "你現在是飛行員",
    ["Flight.NoLongerPilot"] = "你不再是飛行員了",
    ["Flight.DoorOpenNoBoost"] = "門打開時無法加速",

    ["HADS.Triggered"] = "敵對活動位移系統（H.A.D.S）已被觸發！",
    ["HADS.UnderAttack"] = "你的塔迪斯遭到攻擊！",
    ["HADS.DematError"] = "有東西阻止了 H.A.D.S 讓塔迪斯去物質化！",
    ["HADS.Mat"] = "你的塔迪斯正在降落",

    ["Health.RepairActivated"] = "這架塔迪斯已啟動自我修復。請離開內部",
    ["Health.RepairCancelled"] = "自我修復已被取消",
    ["Health.RepairFinished"] = "你的塔迪斯已完成自我修復",
    ["Health.Repairing"] = "這架塔迪斯正在修復。將在 %d 秒內完成",

    ["Lock.Locked"] = "這架塔迪斯已上鎖",

    ["Music.Stopped"] = "停止播放",
    ["Music.Playing"] = "播放：%s",
    ["Music.Loading"] = "加載音樂中……",
    ["Music.LoadFailed"] = "錯誤：加載失敗（%s） ",
    ["Music.LoadFailedResponse"] = "錯誤：加載API響應失敗",
    ["Music.LoadFailedResolve"] = "錯誤：解析URL失敗（%s）",
    ["Music.LoadFailedMissingId"] = "錯誤：無法在URL中找到視頻ID",
    ["Music.LoadFailedBass"] = "錯誤：加載歌曲失敗（錯誤ID：%s，%s）",

    ["Prompts.LightingOverride"] = "此塔迪斯建議您啟用照明覆蓋，是否啟用？這可以稍後在塔迪斯設置中更改",
    ["Prompts.LOD"] = "塔迪斯內部可能需要高精細模型，現在更改？",

    ["Redecorate.Failed"] = "重裝修失敗：生成替代失敗",
    
    ["ThirdPerson.KeyHint"] = "提示：使用 「%s + %s」 鍵進入第三人稱",

    ["Vortex.ModelMissing"] = "警告：旋渦模型無效 - 已禁用旋渦，你錯過了一個依賴嗎？",

    ["Security.ControlUseDenied"] = "這架塔迪斯使用了同構安全協議。您不能操控她",

    ["Spin.Changed"] = "自旋方向已設為 %s",
    ["Spin.Directions.AntiClockwise"] = "逆時針",
    ["Spin.Directions.None"] = "無",
    ["Spin.Directions.Clockwise"] = "順時針",

    ["TimeDistortionGenerator"] = "時間失真發生器",
    ["TimeDistortionGenerator.Instructions"] = "造成時間扭曲，擾亂 TARDIS 引擎，並阻止其起飛或著陸",
    ["TimeDistortionGenerator.Starting"] = "啟動時扭曲發生器…",
    ["TimeDistortionGenerator.Disabled"] = "時間扭曲發生器已禁用",
    ["TimeDistortionGenerator.Enabled"] = "時間扭曲發生器已啟用",
    ["TimeDistortionGenerator.Distortions"] = "警告：塔迪斯內部有東西在造成時間扭曲",

    ["MenuOptions.SectionReset"] = "塔迪斯客戶端設置\"%s\"已被恢復，您可能需要重新生成塔迪斯以應用所有更改",
    ["MenuOptions.ConfirmSectionReset"] = "恢復\"%s\"部分的客戶端設置？此步驟無法撤銷！",
    ["MenuOptions.SectionResetThisSection"] = "恢復設置（此部分）",
    ["MenuOptions.ResetAllSettings"] = "恢復所有設置",
    ["MenuOptions.ResetClientsideSettings"] = "恢復客戶端設置",
    ["MenuOptions.ConfirmResetSettings"] = "恢復所有客戶端設置？此步驟無法撤銷！",
    ["MenuOptions.ResetSettingsConfirmation"] = "塔迪斯客戶端設置已被恢復，您可能需要重新生成塔迪斯以應用所有更改",

    ["Settings.Sections.GUI"] = "用戶界面", -- NOD --

    ["Settings.Sections.GUI.OldGUI"] = "舊界面",
    ["Settings.Sections.GUI.OldGUI.Description"] = "使用沒有圖片的舊界面",
    
    ["Settings.Sections.GUI.BigPopup"] = "更大界面的彈出框",
    ["Settings.Sections.GUI.BigPopup.Description"] = "更大的可視化界面彈出框",
    
    ["Settings.Sections.GUI.ScreenRows"] = "界面行（屏幕）",
    ["Settings.Sections.GUI.ScreenRows.Description"] = "屏幕上的可視化界面有多少行按鈕",
    
    ["Settings.Sections.GUI.ScreenOverrideRows"] = "界面行覆蓋",
    ["Settings.Sections.GUI.ScreenOverrideRows.Description"] = "是否覆蓋按鈕行的內部設置",
    
    ["Settings.Sections.GUI.PopupRows"] = "界面行（彈出框）",
    ["Settings.Sections.GUI.PopupRows.Description"] = "彈出框中的可視化界面有多少行按鈕",
    
    ["Settings.Sections.GUI.Theme"] = "界面主題",
    ["Settings.Sections.GUI.Theme.Description"] = "用戶界面的主題",

    ["Settings.Sections.Performance"] = "性能",
    
    ["Settings.Sections.Performance.LightingOverride"] = "照明覆蓋",
    ["Settings.Sections.Performance.LightingOverride.Description"] = "更好的室內照明。但可能導致低端系統的性能下降",
    
    ["Settings.Sections.Performance.Portals"] = "啟用傳送門",
    ["Settings.Sections.Performance.Portals.Description"] = "不管傳送門是否會顯示，如果對幀率有顯著影響，關閉此項",
    
    ["Settings.Sections.Performance.DoorCloseDistance"] = "門關閉的距離",
    ["Settings.Sections.Performance.DoorCloseDistance.Description"] = "門自動關閉的距離",
    
    ["Settings.Sections.Performance.DynamicExteriorLight"] = "動態外部光源",
    ["Settings.Sections.Performance.DynamicExteriorLight.Description"] = "外部是否發出動態光源",

    ["Settings.Sections.Performance.ProjectedDoorExteriorLight"] = "門外光源投影",
    ["Settings.Sections.Performance.ProjectedDoorExteriorLight.Description"] = "當門打開時，光線是否從門裏照射出來",

    ["Settings.Sections.Performance.BreakdownEffects"] = "損壞特效",
    ["Settings.Sections.Performance.BreakdownEffects.Description"] = "塔迪斯在緊急情況下是否發出閃光和爆炸效果",

    ["Settings.Sections.Exterior"] = "外部",

    ["Settings.Sections.Exterior.Light"] = "外部照明",
    
    ["Settings.Sections.Exterior.Light.EnableColorOverride"] = "啟用顏色覆蓋",
    ["Settings.Sections.Exterior.Light.EnableColorOverride.Description"] = "是否啟用外部燈光顏色覆蓋",

    ["Settings.Sections.Exterior.Light.ColorOverride"] = "顏色覆蓋",
    ["Settings.Sections.Exterior.Light.ColorOverride.Description"] = "外部燈光的覆蓋顏色",

    ["Settings.Sections.Exterior.Light.AlwaysOn"] = "外部燈光常亮",
    ["Settings.Sections.Exterior.Light.AlwaysOn.Description"] = "外部燈光是否常亮",

    ["Settings.Sections.Exterior.ProjectedLight"] = "光源投射",

    ["Settings.Sections.Exterior.ProjectedLight.EnableBrightnessOverride"] = "啟用亮度覆蓋",
    ["Settings.Sections.Exterior.ProjectedLight.EnableBrightnessOverride.Description"] = "是否啟用投射光亮度覆蓋",

    ["Settings.Sections.Exterior.ProjectedLight.EnableColorOverride"] = "啟用顏色覆蓋",
    ["Settings.Sections.Exterior.ProjectedLight.EnableColorOverride.Description"] = "是否啟用投射光顏色覆蓋",

    ["Settings.Sections.Exterior.ProjectedLight.EnableDistanceOverride"] = "啟用光距覆蓋",
    ["Settings.Sections.Exterior.ProjectedLight.EnableDistanceOverride.Description"] = "是否啟用投射光光距覆蓋",

    ["Settings.Sections.Exterior.ProjectedLight.BrightnessOverride"] = "亮度覆蓋",
    ["Settings.Sections.Exterior.ProjectedLight.BrightnessOverride.Description"] = "覆蓋投射光的亮度",

    ["Settings.Sections.Exterior.ProjectedLight.DistanceOverride"] = "光距覆蓋",
    ["Settings.Sections.Exterior.ProjectedLight.DistanceOverride.Description"] = "覆蓋投射光光距",

    ["Settings.Sections.Exterior.ProjectedLight.ColorOverride"] = "顏色覆蓋",
    ["Settings.Sections.Exterior.ProjectedLight.ColorOverride.Description"] = "覆蓋投射光的顏色",

    ["Settings.Sections.Global"] = "管理員選項",

    ["Settings.Sections.Global.EnableHealth"] = "啟用生命值",
    ["Settings.Sections.Global.EnableHealth.Description"] = "塔迪斯是否有生命值並會受到傷害",

    ["Settings.Sections.Global.MaxHealth"] = "最大生命值",
    ["Settings.Sections.Global.MaxHealth.Description"] = "塔迪斯的最大生命值",

    ["Settings.Sections.Global.BoostSpeed"] = "加速速度",
    ["Settings.Sections.Global.BoostSpeed.Description"] = "按下加速鍵後，塔迪斯的加速速度",

    ["Settings.Sections.Misc"] = "雜項",

    ["Settings.Sections.Misc.NotificationType"] = "通知類型",
    ["Settings.Sections.Misc.NotificationType.Description"] = "正在使用的通知類型",
    ["Settings.Sections.Misc.NotificationType.Types.Disabled"] = "禁用",
    ["Settings.Sections.Misc.NotificationType.Types.ConsoleLog"] = "操縱臺日誌",
    ["Settings.Sections.Misc.NotificationType.Types.Chat"] = "聊天通知",
    ["Settings.Sections.Misc.NotificationType.Types.Inbuilt"] = "內置通知",

    ["Settings.Sections.Misc.EnableControlSequences"] = "啟用控製序列",
    ["Settings.Sections.Misc.EnableControlSequences.Description"] = "是否啟用控製序列（以前的高級模式）",
    
    ["Settings.Sections.Misc.IsomorphicSecurityDefault"] = "預設啟用同構安全",
    ["Settings.Sections.Misc.IsomorphicSecurityDefault.Description"] = "預設其他人是否可以操作你的塔迪斯",
    
    ["Settings.Sections.Misc.Teleport"] = "傳送",

    ["Settings.Sections.Misc.Teleport.AutoCloseDoors"] = "起飛時自動關門",
    ["Settings.Sections.Misc.Teleport.AutoCloseDoors.Description"] = "塔迪斯是否在起飛前自動關門",

    ["Settings.Sections.Misc.Teleport.DestinationDematOnSet"] = "目標設定既起飛",
    ["Settings.Sections.Misc.Teleport.DestinationDematOnSet.Description"] = "塔迪斯是否在設定目標後立即起飛",

    ["Settings.Sections.Misc.Teleport.ShowVortex"] = "顯示時間漩渦",
    ["Settings.Sections.Misc.Teleport.ShowVortex.Description"] = "漩渦飛行時是否顯示漩渦",
    
    ["Settings.Sections.Misc.Flight"] = "飛行",

    ["Settings.Sections.Misc.Flight.StopSpinningOpenDoor"] = "開門時停止自旋",
    ["Settings.Sections.Misc.Flight.StopSpinningOpenDoor.Description"] = "在飛行中開門時，塔迪斯是否停止旋轉",

    ["Settings.Sections.Misc.Flight.DisableBoostOpenDoor"] = "開門時禁用加速",
    ["Settings.Sections.Misc.Flight.DisableBoostOpenDoor.Description"] = "在飛行中開門時，塔迪斯是否禁用加速功能",

    ["Settings.Sections.Misc.Flight.UseWalkKeyThirdPerson"] = "使用行走鍵進入第三人稱",
    ["Settings.Sections.Misc.Flight.UseWalkKeyThirdPerson.Description"] = "在操縱臺按下使用鍵（預設為「E」）時，是否按下行走鍵（預設為「ALT」）以進入第三人稱",

    ["Settings.Sections.Misc.Tips"] = "提示",

    ["Settings.Sections.Misc.Tips.Enabled"] = "提示",
    ["Settings.Sections.Misc.Tips.Enabled.Description"] = "塔迪斯操縱臺上是否顯示提示",

    ["Settings.Sections.Misc.Tips.Style"] = "提示風格",
    ["Settings.Sections.Misc.Tips.Style.Description"] = "塔迪斯提示所使用的風格",

    ["Settings.Sections.Misc.Spawning"] = "生成塔迪斯",

    ["Settings.Sections.Misc.Spawning.PreferClassicDoor"] = "經典門內飾",
    ["Settings.Sections.Misc.Spawning.PreferClassicDoor.Description"] = "是否預設生成經典門版本的內飾（雙層門）",

    ["Settings.Sections.Misc.Spawning.RandomizeSkins"] = "隨機皮膚",
    ["Settings.Sections.Misc.Spawning.RandomizeSkins.Description"] = "生成塔迪斯時是否隨機皮膚",

    ["Settings.Sections.Misc.Spawning.UseWinterSkins"] = "使用冬季皮膚",
    ["Settings.Sections.Misc.Spawning.UseWinterSkins.Description"] = "隨機皮膚時是否會使用冬季皮膚",

    ["Settings.Sections.Misc.Language"] = "語",
    ["Settings.Sections.Misc.Language.Description"] = "插件的語言，對於任何缺失的翻譯回退到英語",
    ["Settings.Sections.Misc.Language.Default"] = "遊戲語言",

    ["Settings.Sections.SoundsAndMusic"] = "音效與音樂",

    ["Settings.Sections.SoundsAndMusic.Sounds"] = "音效",

    ["Settings.Sections.SoundsAndMusic.Sounds.All"] = "全部音效",
    ["Settings.Sections.SoundsAndMusic.Sounds.All.Description"] = "讓您輕松靜音所有的聲音",

    ["Settings.Sections.SoundsAndMusic.Sounds.ExternalHum"] = "外部的嗡嗡聲",
    ["Settings.Sections.SoundsAndMusic.Sounds.ExternalHum.Description"] = "是否能聽到塔迪斯外部的嗡嗡聲（如果存在）",

    ["Settings.Sections.SoundsAndMusic.Sounds.Cloak"] = "隱形音效",
    ["Settings.Sections.SoundsAndMusic.Sounds.Cloak.Description"] = "是否播放塔迪斯隱形音效",

    ["Settings.Sections.SoundsAndMusic.Sounds.Door"] = "門音效",
    ["Settings.Sections.SoundsAndMusic.Sounds.Door.Description"] = "開關門時是否發出聲音",

    ["Settings.Sections.SoundsAndMusic.Sounds.FlightExternal"] = "飛行模式音效（外部）",
    ["Settings.Sections.SoundsAndMusic.Sounds.FlightExternal.Description"] = "是否在外部播放飛行音效",

    ["Settings.Sections.SoundsAndMusic.Sounds.Lock"] = "鎖定音效",
    ["Settings.Sections.SoundsAndMusic.Sounds.Lock.Description"] = "開關鎖時是否發出聲音",

    ["Settings.Sections.SoundsAndMusic.Sounds.Teleport"] = "傳送音效",
    ["Settings.Sections.SoundsAndMusic.Sounds.Teleport.Description"] = "傳送時是否發出聲音",

    ["Settings.Sections.SoundsAndMusic.Sounds.CloisterBells"] = "修道院鐘聲",
    ["Settings.Sections.SoundsAndMusic.Sounds.CloisterBells.Description"] = "緊急狀況下是否響起修道院鐘聲",

    ["Settings.Sections.SoundsAndMusic.Sounds.FlightInternal"] = "飛行模式音效（內部）",
    ["Settings.Sections.SoundsAndMusic.Sounds.FlightInternal.Description"] = "是否在內部播放飛行音效",

    ["Settings.Sections.SoundsAndMusic.Sounds.Idle"] = "空閑音效",
    ["Settings.Sections.SoundsAndMusic.Sounds.Idle.Description"] = "是否在內部播放空閑音效",

    ["Settings.Sections.SoundsAndMusic.Music"] = "音樂",

    ["Settings.Sections.SoundsAndMusic.Music.Enabled"] = "啟用",
    ["Settings.Sections.SoundsAndMusic.Music.Enabled.Description"] = "是否能通過屏幕播放音樂",

    ["Settings.Sections.SoundsAndMusic.Music.Volume"] = "音量",
    ["Settings.Sections.SoundsAndMusic.Music.Volume.Description"] = "通過屏幕播放的音樂的音量",

    ["Settings.Sections.SoundsAndMusic.Music.StopOnExit"] = "退出時停止",
    ["Settings.Sections.SoundsAndMusic.Music.StopOnExit.Description"] = "離開塔迪斯時是否停止播放音樂",

    ["Settings.Sections.Binds"] = "鍵綁定",

    ["Settings.Sections.Other"] = "其他",

    ["Binds.Key"] = "鍵",
    ["Binds.Invalid"] = "無效",
    ["Binds.AnyKey"] = "按下任意鍵",

    ["Binds.Sections.ThirdPerson"] = "第三人稱",
    ["Binds.Sections.ThirdPerson.ToggleCloak"] = "切換隱形",
    ["Binds.Sections.ThirdPerson.Destination"] = "目標",
    ["Binds.Sections.ThirdPerson.Destination.Description"] = "輸入目標選擇狀態",
    ["Binds.Sections.ThirdPerson.ToggleFlight"] = "切換飛行",
    ["Binds.Sections.ThirdPerson.ToggleFloat"] = "切換漂浮",
    ["Binds.Sections.ThirdPerson.ToggleFloat.Description"] = "讓塔迪斯像沒有重力一樣飛行",
    ["Binds.Sections.ThirdPerson.TogglePhyslock"] = "切換物理鎖定",
    ["Binds.Sections.ThirdPerson.TogglePhyslock.Description"] = "讓塔迪斯在空間中不可移動",
    ["Binds.Sections.ThirdPerson.ToggleDoor"] = "切換門",
    ["Binds.Sections.ThirdPerson.OpenScreen"] = "打開屏幕",
    ["Binds.Sections.ThirdPerson.OpenScreen.Description"] = "切換HUD屏幕",

    ["Binds.Sections.Destination"] = "目標",
    ["Binds.Sections.Destination.Forward"] = "前",
    ["Binds.Sections.Destination.Backward"] = "後",
    ["Binds.Sections.Destination.Left"] = "左",
    ["Binds.Sections.Destination.Right"] = "右",
    ["Binds.Sections.Destination.Up"] = "上",
    ["Binds.Sections.Destination.Down"] = "下",
    ["Binds.Sections.Destination.Boost"] = "加速",
    ["Binds.Sections.Destination.Boost.Description"] = "按住此鍵以加速移動",
    ["Binds.Sections.Destination.Slow"] = "減速",
    ["Binds.Sections.Destination.Slow.Description"] = "按住此鍵以減速移動",
    ["Binds.Sections.Destination.Rotate"] = "旋轉",
    ["Binds.Sections.Destination.Rotate.Description"] = "按住加速鍵同時使用左和右以旋轉",
    ["Binds.Sections.Destination.SnapToFloor"] = "對齊到地面",
    ["Binds.Sections.Destination.SnapToFloor.Description"] = "按下此鍵對齊到最近的地面",
    
    ["Binds.Sections.Flight"] = "飛行",
    ["Binds.Sections.Flight.Forward"] = "前",
    ["Binds.Sections.Flight.Backward"] = "後",
    ["Binds.Sections.Flight.Left"] = "左",
    ["Binds.Sections.Flight.Right"] = "右",
    ["Binds.Sections.Flight.Up"] = "上",
    ["Binds.Sections.Flight.Down"] = "下",
    ["Binds.Sections.Flight.Boost"] = "加速",
    ["Binds.Sections.Flight.Boost.Description"] = "飛行時按住此鍵以加速",
    ["Binds.Sections.Flight.Rotate"] = "旋轉",
    ["Binds.Sections.Flight.Rotate.Description"] = "按住此鍵+左/右以旋轉",
    ["Binds.Sections.Flight.SpinDirection"] = "自旋方向",
    ["Binds.Sections.Flight.SpinDirection.Description"] = "改變塔迪斯飛行時自旋的方向",
    
    ["Binds.Sections.Float"] = "漂浮",
    ["Binds.Sections.Float.Forward"] = "前",
    ["Binds.Sections.Float.Backward"] = "後",
    ["Binds.Sections.Float.Left"] = "左",
    ["Binds.Sections.Float.Right"] = "右",
    ["Binds.Sections.Float.Boost"] = "加速",
    ["Binds.Sections.Float.Boost.Description"] = "漂浮時按住此鍵以加速旋轉",
    ["Binds.Sections.Float.Rotate"] = "旋轉",
    ["Binds.Sections.Float.Rotate.Description"] = "按住此鍵同時使用左和右來偏航",
    ["Binds.Sections.Float.Brake"] = "製動",
    ["Binds.Sections.Float.Brake.Description"] = "漂浮時按住此鍵以減慢旋轉",
    
    ["Binds.Sections.Teleport"] = "傳送",
    ["Binds.Sections.Teleport.Demat"] = "起飛",
    ["Binds.Sections.Teleport.Mat"] = "降落",
    ["Binds.Sections.Teleport.Set"] = "設定",

    ["Controls.Cloak"] = "隱形",
    ["Controls.Cloak.Tip"] = "隱形裝置",
    ["Controls.Cloak.Status"] = "隱形",
    ["Controls.Cloak.FailedToggle"] = "切換隱形失敗",

    ["Controls.Coordinates.Tip"] = "坐標",

    ["Controls.Destination"] = "目標",
    ["Controls.Destination.Tip"] = "目標設定",

    ["Controls.Door"] = "門",
    ["Controls.Door.Tip"] = "門切換",
    ["Controls.Door.Status"] = "門",
    ["Controls.Door.UsingEmergencyPower"] = "使用緊急能源開門……",
    ["Controls.Door.NoSwitch"] = "門開關無效",
    ["Controls.Door.FailedOpen"] = "開門失敗",
    ["Controls.Door.FailedClose"] = "關門失敗",
    ["Controls.Door.Locked"] = "門已上鎖",

    ["Controls.DoorLock"] = "門鎖",
    ["Controls.DoorLock.Tip"] = "門鎖",
    ["Controls.DoorLock.NotWorking"] = "門鎖無效",
    ["Controls.DoorLock.UsingEmergencyPower"] = "使用緊急能源解鎖……",
    ["Controls.DoorLock.FailedToggle"] = "開解鎖失敗",

    ["Controls.EngineRelease"] = "引擎製動",
    ["Controls.EngineRelease.Tip"] = "引擎製動",
    ["Controls.EngineRelease.ForceDemat"] = "強製起飛已觸發",
    ["Controls.EngineRelease.FailedDemat"] = "起飛失敗",

    ["Controls.FastReturn"] = "快速返回",
    ["Controls.FastReturn.Tip"] = "快速返回協議",
    ["Controls.FastReturn.Activated"] = "快速返回協議以啟動",
    ["Controls.FastReturn.Failed"] = "快速返回協議啟動失敗",

    ["Controls.Flight"] = "飛行模式",
    ["Controls.Flight.Tip"] = "飛行模式",
    ["Controls.Flight.Status"] = "飛行模式",
    ["Controls.Flight.FailedToggle"] = "切換飛行模式失敗",

    ["Controls.Float"] = "反重力",
    ["Controls.Float.Tip"] = "反重力",
    ["Controls.Float.Status"] = "反重力",
    ["Controls.Float.FailedToggle"] = "切換反重力失敗",

    ["Controls.HADS"] = "敵對活動位移系統",
    ["Controls.HADS.Tip"] = "敵對活動位移系統",
    ["Controls.HADS.Status"] = "敵對活動位移系統",

    ["Controls.Handbrake"] = "時間轉子手剎",
    ["Controls.Handbrake.Tip"] = "時間轉子手剎",
    ["Controls.Handbrake.Status"] = "時間轉子手剎",
    ["Controls.Handbrake.FailedToggle"] = "切換時間轉子手剎失敗",

    ["Controls.InteriorLights.Tip"] = "燈光",

    ["Controls.Isomorphic"] = "同構安全",
    ["Controls.Isomorphic.Tip"] = "同構安全系統",
    ["Controls.Isomorphic.Status"] = "同構安全",
    ["Controls.Isomorphic.FailedToggle"] = "切換同構安全系統失敗",
    ["Controls.Isomorphic.NotCreator"] = "這不是您的塔迪斯",
    ["Controls.Isomorphic.SingleplayerWarning"] = "警告：同構安全在單人遊戲中無效",

    ["Controls.Music.Tip"] = "音樂",

    ["Controls.Physlock"] = "物理鎖定",
    ["Controls.Physlock.Tip"] = "鎖定機製",
    ["Controls.Physlock.Status"] = "鎖定機製",
    ["Controls.Physlock.FailedToggle"] = "切換物理鎖定機製失敗",

    ["Controls.Power"] = "能源",
    ["Controls.Power.Tip"] = "能源",
    ["Controls.Power.Status"] = "能源",
    ["Controls.Power.FailedToggle"] = "切換能源失敗",

    ["Controls.RandomCoords.Tip"] = "隨機發生器",
    ["Controls.RandomCoords.Selected"] = "已設定隨機目標",
    
    ["Controls.Redecorate"] = "重裝修",
    ["Controls.Redecorate.Tip"] = "重裝修",
    ["Controls.Redecorate.Status"] = "重裝修",
    ["Controls.Redecorate.FailedToggle"] = "啟用重裝修失敗",
    ["Controls.Redecorate.RandomInteriorWarning"] = "警告：已隨機選擇新的內飾。右擊生成菜單手動選擇",
    ["Controls.Redecorate.NotCreator"] = "您不能重裝修其他人的塔迪斯",

    ["Controls.Repair"] = "自我修復",
    ["Controls.Repair.Tip"] = "自我修復",
    ["Controls.Repair.FailedToggle"] = "切換自我修復失敗",

    ["Controls.Scanner.Tip"] = "監視器",

    ["Controls.Shields.Tip"] = "護盾",

    ["Controls.SonicDispenser.Tip"] = "音速充電口",
    ["Controls.SonicDispenser.MissingAddon"] = "您沒有安裝 Sonic Screwdriver 插件，安裝它來使此部件工作",
    ["Controls.SonicDispenser.Dispensed"] = "音速起子已被分配",
    ["Controls.SonicDispenser.Equipped"] = "音速起子已經配備",
    ["Controls.SonicDispenser.AlreadyEquipped"] = "您已經有音速起子了",

    ["Controls.SpinCycle"] = "自旋方向",
    ["Controls.SpinCycle.Tip"] = "自旋",

    ["Controls.SpinSwitch.Tip"] = "自旋方向",
    ["Controls.SpinSwitch.ChangedDisabled"] = "自旋已被禁用，但自旋方向設置為 %s",

    ["Controls.SpinToggle.Tip"] = "切換自旋",
    ["Controls.SpinToggle.Status"] = "自旋",

    ["Controls.Stabilizers.Tip"] = "飛行穩定器",

    ["Controls.Teleport"] = "傳送",
    ["Controls.Teleport.Tip"] = "時空節流閥",
    ["Controls.Teleport.Mat"] = "降落……",
    ["Controls.Teleport.FailedMat"] = "降落失敗",
    ["Controls.Teleport.Demat"] = "起飛……",
    ["Controls.Teleport.FailedDematDoorsOpen"] = "無法在門打開時起飛",
    ["Controls.Teleport.FailedDematHandbrake"] = "時間轉子手剎已閉合，無法起飛",
    ["Controls.Teleport.FailedDemat"] = "起飛失敗",

    ["Controls.ThirdPersonCareful.Tip"] = "手動飛行控製",

    ["Controls.ThirdPerson"] = "飛行控製",
    ["Controls.ThirdPerson.Tip"] = "手動飛行控製",

    ["Controls.ToggleScreens"] = "切換屏幕",
    ["Controls.ToggleScreens.Tip"] = "切換屏幕",
    ["Controls.ToggleScreens.Status"] = "內部屏幕",
    ["Controls.ToggleScreens.FailedToggle"] = "切換內部屏幕失敗",

    ["Controls.VirtualConsole.Tip"] = "虛擬操縱臺",

    ["Controls.VortexFlight"] = "漩渦飛行",
    ["Controls.VortexFlight.Tip"] = "漩渦飛行",
    ["Controls.VortexFlight.Status"] = "漩渦飛行",
    ["Controls.VortexFlight.FailedToggle"] = "切換漩渦飛行失敗",

    ["Parts.DefaultAtomAccelerator.Text"] = "原子加速器",
    ["Parts.DefaultDematCircuit.Text"] = "去物質化電路",
    ["Parts.DefaultDirectionalPointer.Text"] = "定向指針",
    ["Parts.DefaultGramophone.Text"] = "留聲機",
    ["Parts.DefaultHelmic.Text"] = "赫爾米克調節器",
    ["Parts.DefaultScreen.Text"] = "監控器",
    ["Parts.DefaultWibblyLever.Text"] = "Wibbly控製桿",
    
    ["Parts.Door.Locked"] = "門已上鎖",
    
    ["Interiors.DefaultTTCapsule"] = "TT時間艙 預設",
    
    ["Interiors.Default"] = "預設",
    ["Interiors.Default.Versions.TTCapsule"] = "TT時間艙版本",
    
    ["Themes.Default"] = "預設",
    ["Themes.Transparent"] = "透明",
    ["Themes.TextOnly"] = "僅文字",

    ["TipStyles.Default"] = "預設（取決內飾）",
    ["TipStyles.Classic"] = "經典",
    ["TipStyles.WhiteOnBlue"] = "藍底白字",
    ["TipStyles.WhiteOnGrey"] = "白底藍字",
    
    ["Screens.Common.Back"] = "返回",
    ["Screens.Common.Menu"] = "菜單",
    ["Screens.Common.Exit"] = "退出",
    ["Screens.Common.Popup"] = "彈出窗",
    ["Screens.Common.CurrentPage"] = "第%d頁，共%d頁",
    
    ["Screens.Coordinates"] = "坐標",
    ["Screens.Coordinates.Saved"] = "位置已保存",
    ["Screens.Coordinates.Loaded"] = "位置已加載",
    ["Screens.Coordinates.NoDestinationSet"] = "無目標設定",
    ["Screens.Coordinates.SelectManually"] = "手動選擇",
    ["Screens.Coordinates.X"] = "X",
    ["Screens.Coordinates.Y"] = "Y",
    ["Screens.Coordinates.Z"] = "Z",
    ["Screens.Coordinates.Pitch"] = "俯仰",
    ["Screens.Coordinates.Yaw"] = "偏航",
    ["Screens.Coordinates.Roll"] = "翻滾",
    ["Screens.Coordinates.Name"] = "名稱",
    ["Screens.Coordinates.Unnamed"] = "未命名",
    ["Screens.Coordinates.CurrentSetDestination"] = "當前設定目標",
    ["Screens.Coordinates.RandomGround"] = "隨機（地面）",
    ["Screens.Coordinates.Random"] = "隨機",
    ["Screens.Coordinates.RandomLocationGround"] = "地面隨機位置",
    ["Screens.Coordinates.RandomLocation"] = "隨機位置",
    ["Screens.Coordinates.GetCurrentPosition"] = "獲取當前位置",
    ["Screens.Coordinates.NameNewLocationFromInputs"] = "輸入新位置的名稱（將使用輸入的信息）",
    ["Screens.Coordinates.NameNewLocation"] = "輸入新位置的名稱",
    ["Screens.Coordinates.NewLocation"] = "新位置",
    ["Screens.Coordinates.NewLocationUseCurrentPos"] = "使用當前TARDIS位置和旋轉？\n選擇'%s'將使用輸入的信息",
    ["Screens.Coordinates.RemoveLocation"] = "移除位置",
    ["Screens.Coordinates.ConfirmRemoveLocation"] = "這將永久刪除所選位置！你確定嗎？",

    ["Screens.Music"] = "音樂",
    ["Screens.Music.MissingName"] = "您需要指定自定義曲目的名稱來添加它",
    ["Screens.Music.MissingUrl"] = "您需要指定自定義音軌的URL來添加它",
    ["Screens.Music.Conflict"] = "同名的音樂曲目已經存在",
    ["Screens.Music.CannotRemoveDefault"] = "無法刪除預加載的音樂",
    ["Screens.Music.DeleteNoSelection"] = "沒有選擇移除任何東西",
    ["Screens.Music.NoChoice"] = "沒有選擇音樂",
    ["Screens.Music.DefaultLoadError"] = "加載預加載音樂錯誤：%s",
    ["Screens.Music.UnableToDecodeList"] = "無法解碼列表",
    ["Screens.Music.CustomAdded"] = "自定義曲目'%s'已添加：%s",
    ["Screens.Music.CustomRemoved"] = "自定義曲目'%s'已移除：%s",
    ["Screens.Music.DefaultMusic"] = "預加載音樂",
    ["Screens.Music.CustomMusic"] = "自定義曲目",
    ["Screens.Music.UrlPlaceholder"] = "輸入音樂URL",
    ["Screens.Music.NamePlaceholder"] = "輸入自定義曲目名稱",
    ["Screens.Music.PlayStop"] = "播放/停止",
    ["Screens.Music.DeleteConfirm"] = "您確定要從音樂列表中刪除\"%s\"嗎？此步驟無法撤銷！",

    ["Screens.Scanner"] = "監視器",
    ["Screens.Scanner.Front"] = "前",
    ["Screens.Scanner.Back"] = "後",
    ["Screens.Scanner.Left"] = "左",
    ["Screens.Scanner.Right"] = "右",
    
    ["Screens.VirtualConsole"] = "虛擬操縱臺",
    ["Screens.VirtualConsole.Old.TogglePower"] = "切換能源",
    ["Screens.VirtualConsole.Old.Repair"] = "修復塔迪斯",
    ["Screens.VirtualConsole.Old.FastRemat"] = "快速實現",
    ["Screens.VirtualConsole.Old.Physlock"] = "物理鎖定",
    ["Screens.VirtualConsole.Old.FastReturn"] = "快速返回",
    ["Screens.VirtualConsole.Old.HADS"] = "HADS",
    ["Screens.VirtualConsole.Old.CloseDoor"] = "關門",
    ["Screens.VirtualConsole.Old.OpenDoor"] = "開門",
    ["Screens.VirtualConsole.Old.UnlockDoor"] = "門解鎖",
    ["Screens.VirtualConsole.Old.LockDoor"] = "門上鎖",
    ["Screens.VirtualConsole.Old.DoorClosing"] = "門關閉",
    ["Screens.VirtualConsole.Old.DoorOpening"] = "門打開",
    ["Screens.VirtualConsole.Old.LockUnlocking"] = "鎖：解鎖中",
    ["Screens.VirtualConsole.Old.LockLocking"] = "鎖：上鎖中",
    
    ["Spawnmenu.RedecorationSelected"] = "塔迪斯內部裝飾選定，請在您的塔迪斯中啟用重裝修",
    ["Spawnmenu.RedecorationSelectedRestart"] = "塔迪斯內部裝飾選定，重新啟動重裝修以應用更改",
    ["Spawnmenu.SelectForRedecoration"] = "選擇重裝修",
    ["Spawnmenu.ReloadGame"] = "重新加載遊戲以應用更改",
    ["Spawnmenu.FavoritesUpdated"] = "收藏夾已更新",
    ["Spawnmenu.ClassicDoorsVersion"] = "經典門版本：",
    ["Spawnmenu.DoubleDoorsVersion"] = "雙層門版本：",
    ["Spawnmenu.AlternativeVersions"] = "選擇版本：",
    ["Spawnmenu.CustomVersions"] = "自定義版本：",
    ["Spawnmenu.VersionOptions.Default"] = "預設",
    ["Spawnmenu.VersionOptions.Random"] = "隨機",
    ["Spawnmenu.VersionOptions.RandomOriginal"] = "隨機（原始版本）",
    ["Spawnmenu.VersionOptions.RandomOriginalAndCustom"] = "隨機（原始和自定義版本）",
    ["Spawnmenu.Spawn"] = "生成",
    ["Spawnmenu.Settings"] = "設置",
    ["Spawnmenu.PreferredVersion"] = "首選的版本",
    ["Spawnmenu.PreferredDoorType"] = "首選的門的類型",
    ["Spawnmenu.PreferredDoorType.Default"] = "預設（在塔迪斯設置中配置）",
    ["Spawnmenu.PreferredDoorType.Random"] = "隨機",
    ["Spawnmenu.PreferredDoorType.Classic"] = "經典門",
    ["Spawnmenu.PreferredDoorType.Double"] = "雙層門",
    ["Spawnmenu.AddToFavourites"] = "添加到收藏夾（需要重新加載）",
    ["Spawnmenu.RemoveFromFavourites"] = "從收藏夾中移除（需要重新加載）",
    ["Spawnmenu.Category"] = "神秘博士 - 塔迪斯",
    ["Spawnmenu.CategoryTools"] = "神秘博士 - TARDIS 工具",
    ["Spawnmenu.RedecorationExclude"] = "排除在隨機重裝修外",
    ["Spawnmenu.ResetSettings"] = "恢復預設設置",
    
    ["Settings.NoPermissionGlobalSettings"] = "您沒有權限編輯全局設置",

    ["Wiremod.Inputs.Demat"] = "使塔迪斯起飛",
    ["Wiremod.Inputs.Mat"] = "使塔迪斯降落",
    ["Wiremod.Inputs.Pos"] = "X,Y,Z：傳送位置",
    ["Wiremod.Inputs.Ang"] = "X,Y,Z：傳送角度",

    ["Wiremod.Outputs.Health"] = "塔迪斯生命值",
}

TARDIS:AddLanguage(T)