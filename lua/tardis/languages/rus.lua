-- English

local T = {}
T.Code = "rus"
T.Name = "Russian"
T.Phrases = {
    ["Common.Error"] = "ОШИБКА",
    ["Common.TARDIS"] = "ТАРДИС",
    ["Common.Interface"] = "Интерфейс ТАРДИС",
    ["Common.OK"] = "Ок",
    ["Common.Cancel"] = "Отмена",
    ["Common.Yes"] = "Да",
    ["Common.No"] = "Нет",
    ["Common.DontAskAgain"] = "Не спрашивать ещё раз",
    ["Common.Save"] = "Сохранить",
    ["Common.Set"] = "Установить",
    ["Common.Load"] = "Загрузить",
    ["Common.Reset"] = "Сбросить",
    ["Common.New"] = "Новый",
    ["Common.Remove"] = "Убрать",
    ["Common.Update"] = "Обновить",
    ["Common.Delete"] = "Удалить",
    ["Common.Default"] = "Стандартный",
    ["Common.PowerDisabled"] = "Питание отключено",
    ["Common.PowerDisabledControl"] = "Питание отключено. Это не работает",
    ["Common.Enabled.Lower"] = "- включено",
    ["Common.Disabled.Lower"] = "- выключено",
    ["Common.Opened.Lower"] = "открыты",
    ["Common.Closed.Lower"] = "закрыты",
    ["Common.Locked.Lower"] = "заперты",
    ["Common.Unlocked.Lower"] = "разблокированы",
    ["Common.Engaged.Lower"] = "включен",
    ["Common.Disengaged.Lower"] = "выключен",
    ["Common.NotYetImplemented"] = "Это ещё не осуществленно",
    ["Common.UnknownError"] = "Неопознанная ошибка",
    ["Common.DoorsNotInstalled"] = "Аддон Doors не установлен!",
    ["Common.EnterTextInput"] = "Ввести текст",
    ["Common.NotInTARDIS"] = "Вы не находитесь в ТАРДИС",
    ["Common.ControlSequencesEnabledWarning"] = "Последовательное управление включено. Используйте последовательность рычагов",
    ["Common.Loading"] = "Загрузка...",
    ["Common.UnsavedChanges"] = "Несохранённые изменения",
    ["Common.UnsavedChangesWarning"] = "У вас есть несохранённые изменения. Не хотите их сохранить?",

    ["Templates.MissingTemplate"] = "Не удалось найти шаблон %s требуемый для интерьера %s",

    ["Destination.LockedReadyToMat"] = "Маршрут построен. ТАРДИС готова к материализации!",
    ["Destination.FailedSetDestinationMaybeTransitioning"] = "Ошибка ввода координат",
    ["Destination.LockedDemat"] = "Маршрут построен, ТАРДИС дематериализуется!",
    ["Destination.FailedDemat"] = "Не получилось дематериализоваться",
    ["Destination.LockedReadyToDemat"] = "Маршрут построен, ТАРДИС готова к дематериализации!",
    ["Destination.FailedSetDestination"] = "Ошибка установления маршрута",

    ["Flight.WarnPhyslockEngaged"] = "ПРЕДУПРЕЖДЕНИЕ: Физическая оболочка зафиксирована",
    ["Flight.NameIsThePilot"] = "%s является пилотом",
    ["Flight.NameIsNowThePilot"] = "%s теперь пилот",
    ["Flight.YouAreNowThePilot"] = "Теперь вы пилотируете ТАРДИС",
    ["Flight.NoLongerPilot"] = "Вы больше не пилотируете ТАРДИС",
    ["Flight.DoorOpenNoBoost"] = "Ускорение не работает с открытыми дверями.",

    ["HADS.Triggered"] = "С.П.О.В.Д. было запущено!",
    ["HADS.UnderAttack"] = "Твоя ТАРДИС подверглась атаке!",
    ["HADS.DematError"] = "Что-то остановило С.П.О.В.Д. от премещения ТАРДИС!",
    ["HADS.Mat"] = "Ваша ТАРДИС материализуется..",

    ["Health.RepairActivated"] = "ТАРДИС была поставлена на само-восстановление. Покиньте интерьер.",
    ["Health.RepairCancelled"] = "Само-восстановление было отменено",
    ["Health.RepairFinished"] = "Ваша ТАРДИС закончила само-восстановление",
    ["Health.Repairing"] = "ТАРДИС само-восстанавливается. Осталось %d секунд",

    ["Lock.Locked"] = "Эта ТАРДИС заперта",

    ["Music.Stopped"] = "Музыка остановлена",
    ["Music.Playing"] = "Проигрывается: %s",
    ["Music.Loading"] = "Загрузка музыки...",
    ["Music.LoadFailed"] = "ОШИБКА: Не получилось загрузить (%s)",
    ["Music.LoadFailedResponse"] = "ОШИБКА: Не получилось загрузить ответный интерфейс",
    ["Music.LoadFailedResolve"] = "ОШИБКА: Не получилось распознать URL (%s)",
    ["Music.LoadFailedMissingId"] = "ОШИБКА: Не получилось найти ID видео в ссылке",
    ["Music.LoadFailedBass"] = "ОШИБКА: Не получилось загрузить музыку (ID ошибки: %s, %s)",

    ["Prompts.LightingOverride"] = "Эта ТАРДИС рекомендует Альтернативное Освещение,которое у вас отключено. Включить его?(Это можно изменить в настройках ТАРДИС позже)",
    ["Prompts.LOD"] = "Интерьер ТАРДИС может потребовать высокую детализацию моделей, включить её сейчас?",

    ["Redecorate.Failed"] = "Ошибка редекорации: не получилось поставить замену.",

    ["ThirdPerson.KeyHint"] = "ПОДСКАЗКА: Используйте '%s + %s' для управления ТАРДИС от 3-ого лица",

    ["Vortex.ModelMissing"] = "ПРЕДУПРЕЖДЕНИЕ: Ошибочная модель Временной Воронки",

    ["Security.PartUseDenied"] = "Эта ТАРДИС использует Изоморфную Защиту, вам нельзя использовать её управление",

    ["Spin.Changed"] = "Направление вращения экстерьера - %s",
    ["Spin.Directions.AntiClockwise"] = "против часовой стрелки",
    ["Spin.Directions.None"] = "отсутствует",
    ["Spin.Directions.Clockwise"] = "по часовой стрелке",

    ["TimeDistortionGenerator.Starting"] = "Запуск искажатора времени ...",
    ["TimeDistortionGenerator.Disabled"] = "Искажатор времени выключен",
    ["TimeDistortionGenerator.Enabled"] = "Искажатор времени включён",
    ["TimeDistortionGenerator.Distortions"] = "ПРЕДУПРЕЖДЕНИЕ: Что создаёт временные искажения внутри ТАРДИС",

    ["MenuOptions.SectionReset"] = "Настройки ТАРДИС со стороны клиента \"%s\" были изменены. Вам нужно заново создать ТАРДИС для их применения.",
    ["MenuOptions.ConfirmSectionReset"] = "Сбросить настройки со стороны клиента \"%s\"? Это нельзя отменить.",
    ["MenuOptions.SectionResetThisSection"] = "Сбросить настройки (в этой секции)",
    ["MenuOptions.ResetAllSettings"] = "Сбросить все настройки",
    ["MenuOptions.ResetClientsideSettings"] = "Сбросить все настройки со стороны клиента",
    ["MenuOptions.ConfirmResetSettings"] = "Сбросить все настройки со стороны клиента? Это нельзя отменить.",
    ["MenuOptions.ResetSettingsConfirmation"] = "Настройки ТАРДИС со стороны клиента. Вам нужно заново создать ТАРДИС для их применения.",

    ["Settings.Sections.GUI"] = "Графический интерфейс",

    ["Settings.Sections.GUI.OldGUI"] = "Использовать старый интерфейс",
    ["Settings.Sections.GUI.OldGUI.Description"] = "Использовать старый 2D интерфейс без картинок вместо нового",
    
    ["Settings.Sections.GUI.BigPopup"] = "Большой экранный интерфейс",
    ["Settings.Sections.GUI.BigPopup.Description"] = "Стоит ли экранный интерфейс для нового интерфейса быть больше?",
    
    ["Settings.Sections.GUI.ScreenRows"] = "Ряды интерфейса (монитор ТАРДИС)",
    ["Settings.Sections.GUI.ScreenRows.Description"] = "Сколько рядов стоит использовать экранный интерфейс?",
    
    ["Settings.Sections.GUI.ScreenOverrideRows"] = "Отмена рядов для интерфейса",
    ["Settings.Sections.GUI.ScreenOverrideRows.Description"] = "Стоят ли настройки интерьера для рядов кнопок быть выключаемыми?",
    
    ["Settings.Sections.GUI.PopupRows"] = "Ряды интерфейса (на экране)",
    ["Settings.Sections.GUI.PopupRows.Description"] = "Сколько рядов стоит использовать экранный интерфейс?",
    
    ["Settings.Sections.GUI.Theme"] = "Тема Интерфейса",
    ["Settings.Sections.GUI.Theme.Description"] = "Тема для интерфейса пользователя",

    ["Settings.Sections.Performance"] = "Производительность",
    
    ["Settings.Sections.Performance.LightingOverride"] = "Альтернативное освещение",
    ["Settings.Sections.Performance.LightingOverride.Description"] = "Улучшенное освещение интерьера не зависящее от атмосферы карты.\nМожет вызвать проблемы с производительностью на слабых устройствах.",
    
    ["Settings.Sections.Performance.Portals"] = "Использование Порталов",
    ["Settings.Sections.Performance.Portals.Description"] = "Используется ли эффект больше внутри, чем снаружи. Отключение может заметно увеличить производительность.",
    
    ["Settings.Sections.Performance.DoorCloseDistance"] = "Дистанция закрытия дверей",
    ["Settings.Sections.Performance.DoorCloseDistance.Description"] = "Дистанция с которой двери автоматически закрываются",
    
    ["Settings.Sections.Performance.DynamicExteriorLight"] = "Динамическое освещение экстерьера",
    ["Settings.Sections.Performance.DynamicExteriorLight.Description"] = "Стоит ли экстерьер излучать динамическое освещение в  темноте?",

    ["Settings.Sections.Performance.ProjectedDoorExteriorLight"] = "Свет из дверей экстерьера",
    ["Settings.Sections.Performance.ProjectedDoorExteriorLight.Description"] = "Стоит ли излучаться свет из дверей, когда они открыты?",

    ["Settings.Sections.Performance.BreakdownEffects"] = "Эффекты взрывов",
    ["Settings.Sections.Performance.BreakdownEffects.Description"] = "Стоит ли ТАРДИС использовать взрывные эффекты и искры при некоторых ситцациях(смерть,принудительный телепорт)?",

    ["Settings.Sections.Exterior"] = "Экстерьер(внешняя оболочка)",

    ["Settings.Sections.Exterior.Light"] = "Свет экстерьера",
    
    ["Settings.Sections.Exterior.Light.EnableColorOverride"] = "Включить пользовательский цвет",
    ["Settings.Sections.Exterior.Light.EnableColorOverride.Description"] = "Использование пользовательского цвета экстерьера",

    ["Settings.Sections.Exterior.Light.ColorOverride"] = "Color Override",
    ["Settings.Sections.Exterior.Light.ColorOverride.Description"] = "The override color of the exterior light",

    ["Settings.Sections.Exterior.Light.AlwaysOn"] = "Exterior Light Always On",
    ["Settings.Sections.Exterior.Light.AlwaysOn.Description"] = "Should the exterior light always be lit?",

    ["Settings.Sections.Exterior.ProjectedLight"] = "Projected light",

    ["Settings.Sections.Exterior.ProjectedLight.EnableBrightnessOverride"] = "Включить пользовательскую яркость",
    ["Settings.Sections.Exterior.ProjectedLight.EnableBrightnessOverride.Description"] = "Использование пользовательской яркости световой проекции",

    ["Settings.Sections.Exterior.ProjectedLight.EnableColorOverride"] = "Включить пользовательсий цвет",
    ["Settings.Sections.Exterior.ProjectedLight.EnableColorOverride.Description"] = "Использование пользовательского цвета световой проекции",

    ["Settings.Sections.Exterior.ProjectedLight.EnableDistanceOverride"] = "Включить пользовательское расстояние",
    ["Settings.Sections.Exterior.ProjectedLight.EnableDistanceOverride.Description"] = "Использование пользовательского расстояния псветовой проекции",

    ["Settings.Sections.Exterior.ProjectedLight.BrightnessOverride"] = "Изменение яркости",
    ["Settings.Sections.Exterior.ProjectedLight.BrightnessOverride.Description"] = "Override brightness of projected light",

    ["Settings.Sections.Exterior.ProjectedLight.DistanceOverride"] = "Изменение расстояния",
    ["Settings.Sections.Exterior.ProjectedLight.DistanceOverride.Description"] = "Изменение расстояния излучаемого света",

    ["Settings.Sections.Exterior.ProjectedLight.ColorOverride"] = "Пользовательский цвет",
    ["Settings.Sections.Exterior.ProjectedLight.ColorOverride.Description"] = "Override color of projected light",

    ["Settings.Sections.Global"] = "Продвинутые настройки(для админов)",

    ["Settings.Sections.Global.EnableHealth"] = "Включение запаса здоровья",
    ["Settings.Sections.Global.EnableHealth.Description"] = "Стоит ли ТАРДИС иметь здоровье и получать урон?",

    ["Settings.Sections.Global.MaxHealth"] = "Максимальное здоровье",
    ["Settings.Sections.Global.MaxHealth.Description"] = "Максимальное кол-во здоровья которое имеет ТАРДИС",

    ["Settings.Sections.Global.BoostSpeed"] = "Значение ускорения",
    ["Settings.Sections.Global.BoostSpeed.Description"] = "Изменение скорости ТАРДИС при задействовании кнопки Ускорения(по стандарту-shift) ",

    ["Settings.Sections.Misc"] = "Разное",

    ["Settings.Sections.Misc.NotificationType"] = "Тип уведомлений(подсказок)",
    ["Settings.Sections.Misc.NotificationType.Description"] = "Какой используется тип уведомлений?",
    ["Settings.Sections.Misc.NotificationType.Types.Disabled"] = "Никакой",
    ["Settings.Sections.Misc.NotificationType.Types.ConsoleLog"] = "Консольная откладка",
    ["Settings.Sections.Misc.NotificationType.Types.Chat"] = "Чат",
    ["Settings.Sections.Misc.NotificationType.Types.Inbuilt"] = "Встроенные уведомления(Из Garry's Mod)",

    ["Settings.Sections.Misc.EnableControlSequences"] = "Включение последовательного управления",
    ["Settings.Sections.Misc.EnableControlSequences.Description"] = "Стоит ли использовать последовательное управление или 'продвинутый режим' ?",
    
    ["Settings.Sections.Misc.IsomorphicSecurityDefault"] = "Изоморфная защита по стандарту?",
    ["Settings.Sections.Misc.IsomorphicSecurityDefault.Description"] = "Никто(игроки) не может пользоваться вашей ТАРДИС по стандарту",
    
    ["Settings.Sections.Misc.Teleport"] = "Телепортация",

    ["Settings.Sections.Misc.Teleport.AutoCloseDoors"] = "Автоматическое закрытие дверей при телепортации",
    ["Settings.Sections.Misc.Teleport.AutoCloseDoors.Description"] = "Стоит ли ТАРДИС закрывать двери при дематериализации?",

    ["Settings.Sections.Misc.Teleport.DestinationDematOnSet"] = "Координаты - Телепортация при установке",
    ["Settings.Sections.Misc.Teleport.DestinationDematOnSet.Description"] = "Стоит ли ТАРДИС дематериализвоаться как только были зафиксированы координат?",

    ["Settings.Sections.Misc.Teleport.ShowVortex"] = "Показывать Временную Воронку?",
    ["Settings.Sections.Misc.Teleport.ShowVortex.Description"] = "Использовать текстуру воронки при полёте в ней?",
    
    ["Settings.Sections.Misc.Flight"] = "Полёт",

    ["Settings.Sections.Misc.Flight.StopSpinningOpenDoor"] = "Не крутиться с открытыми дверями",
    ["Settings.Sections.Misc.Flight.StopSpinningOpenDoor.Description"] = "Стоит ли ТАРДИС не крутиться по оси с открытами дверями в полёте?",

    ["Settings.Sections.Misc.Flight.DisableBoostOpenDoor"] = "Отключение ускорения с открытыми дверями",
    ["Settings.Sections.Misc.Flight.DisableBoostOpenDoor.Description"] = "Стоит ли ТАРДИС запретить ускорение с открытами дверями в полёте?",

    ["Settings.Sections.Misc.Flight.UseWalkKeyThirdPerson"] = "Использование двух кнопок для входа в 3-е лицо",
    ["Settings.Sections.Misc.Flight.UseWalkKeyThirdPerson.Description"] = "Стоит ли нажимать кнопку 'медленной ходьбы'(ALT-по стандарту) вместе с 'использовать' (E-по стандарту? для вхождения в 3-е лицо ТАРДИС?" ,

    ["Settings.Sections.Misc.Tips"] = "Подсказки",

    ["Settings.Sections.Misc.Tips.Enabled"] = "Подсказки",
    ["Settings.Sections.Misc.Tips.Enabled.Description"] = "Стоит ли использовать подсказки для элементов управления ТАРДИС?",

    ["Settings.Sections.Misc.Tips.Style"] = "Стиль подсказок",
    ["Settings.Sections.Misc.Tips.Style.Description"] = "Какой стиль подсказок вы хотите использовать?",

    ["Settings.Sections.Misc.Spawning"] = "Создание(спавн) ТАРДИС",

    ["Settings.Sections.Misc.Spawning.PreferClassicDoor"] = "Предпочитать классические двери в интерьере",
    ["Settings.Sections.Misc.Spawning.PreferClassicDoor.Description"] = "Классические(большие) двери ТАРДИС будут спавниться по стандарту",

    ["Settings.Sections.Misc.Spawning.RandomizeSkins"] = "Случайные экстерьеры(скины)",
    ["Settings.Sections.Misc.Spawning.RandomizeSkins.Description"] = "Каждый раз будут спавниться случайные версии экстерьера",

    ["Settings.Sections.Misc.Spawning.UseWinterSkins"] = "Использование зимних скинов",
    ["Settings.Sections.Misc.Spawning.UseWinterSkins.Description"] = "Могут ли при включенных случайных скинах появляться зимние",
    
    ["Settings.Sections.SoundsAndMusic"] = "Звуки и Музыка",

    ["Settings.Sections.SoundsAndMusic.Sounds"] = "Звуки",

    ["Settings.Sections.SoundsAndMusic.Sounds.All"] = "Все звуки",
    ["Settings.Sections.SoundsAndMusic.Sounds.All.Description"] = "Заглушить все выбираемые звуки",

    ["Settings.Sections.SoundsAndMusic.Sounds.ExternalHum"] = "Внутренние звуки снаружи",
    ["Settings.Sections.SoundsAndMusic.Sounds.ExternalHum.Description"] = "Будут ли слышны внутренние звуки ТАРДИС(hum) снаружи интерьера",

    ["Settings.Sections.SoundsAndMusic.Sounds.Cloak"] = "Невидимость",
    ["Settings.Sections.SoundsAndMusic.Sounds.Cloak.Description"] = "Проигрываются ли звуки при входе и выходе в невидимотсь",

    ["Settings.Sections.SoundsAndMusic.Sounds.Door"] = "Звук двери",
    ["Settings.Sections.SoundsAndMusic.Sounds.Door.Description"] = "Использование звуков дверей",

    ["Settings.Sections.SoundsAndMusic.Sounds.FlightExternal"] = "Звук полёта снаружи",
    ["Settings.Sections.SoundsAndMusic.Sounds.FlightExternal.Description"] = "Можно ли слышать звук полёта снаружи ТАРДИС",

    ["Settings.Sections.SoundsAndMusic.Sounds.Lock"] = "Звук блокировки дверей",
    ["Settings.Sections.SoundsAndMusic.Sounds.Lock.Description"] = "Стоит ли ТАРДИС воспроизводить звук при блокировке(разблокировке) дверей",

    ["Settings.Sections.SoundsAndMusic.Sounds.Teleport"] = "Звук телепортации",
    ["Settings.Sections.SoundsAndMusic.Sounds.Teleport.Description"] = "Можно ли услышать звук телепортации ТАРДИС",

    ["Settings.Sections.SoundsAndMusic.Sounds.CloisterBells"] = "Монастырные Колокола",
    ["Settings.Sections.SoundsAndMusic.Sounds.CloisterBells.Description"] = "Можно ли услышать звук предупреждающих колоклов",

    ["Settings.Sections.SoundsAndMusic.Sounds.FlightInternal"] = "Звук полёта внутри",
    ["Settings.Sections.SoundsAndMusic.Sounds.FlightInternal.Description"] = "Можно ли слышать звук полёта внутри ТАРДИС",

    ["Settings.Sections.SoundsAndMusic.Sounds.Idle"] = "Внутренний шум",
    ["Settings.Sections.SoundsAndMusic.Sounds.Idle.Description"] = "Можно ли услышать обычный шум ТАРДИС или нет",

    ["Settings.Sections.SoundsAndMusic.Music"] = "Музыка",

    ["Settings.Sections.SoundsAndMusic.Music.Enabled"] = "Включена",
    ["Settings.Sections.SoundsAndMusic.Music.Enabled.Description"] = "Проигрывается музыка или нет",

    ["Settings.Sections.SoundsAndMusic.Music.Volume"] = "Громкость",
    ["Settings.Sections.SoundsAndMusic.Music.Volume.Description"] = "Громкость музыки",

    ["Settings.Sections.SoundsAndMusic.Music.StopOnExit"] = "Сброс при выходе",
    ["Settings.Sections.SoundsAndMusic.Music.StopOnExit.Description"] = "Останавливается ли музыка при выходе из ТАРДИС",

    ["Settings.Sections.Binds"] = "Клавиши",

    ["Settings.Sections.Other"] = "Другое",

    ["Binds.Key"] = "Клавиша",
    ["Binds.Invalid"] = "Несуществует",
    ["Binds.AnyKey"] = "Нажмите клавишу",

    ["Binds.Sections.ThirdPerson"] = "3-е лицо",
    ["Binds.Sections.ThirdPerson.ToggleCloak"] = "Переключение Невидимости",
    ["Binds.Sections.ThirdPerson.Destination"] = "Координаты",
    ["Binds.Sections.ThirdPerson.Destination.Description"] = "Войти в режим выбора координат",
    ["Binds.Sections.ThirdPerson.ToggleFlight"] = "Переключение",
    ["Binds.Sections.ThirdPerson.ToggleFloat"] = "Переключение Анти-Гравов",
    ["Binds.Sections.ThirdPerson.ToggleFloat.Description"] = "Позволяет ТАРДИС летать игнорируя законы гравитации",
    ["Binds.Sections.ThirdPerson.TogglePhyslock"] = "Преключение ФизЛок",
    ["Binds.Sections.ThirdPerson.TogglePhyslock.Description"] = "Зафиксировать физическую оболочку ТАРДИС в одном положении",
    ["Binds.Sections.ThirdPerson.ToggleDoor"] = "Переключение дверей",
    ["Binds.Sections.ThirdPerson.OpenScreen"] = "Открыть Монитор ТАРДИС",
    ["Binds.Sections.ThirdPerson.OpenScreen.Description"] = "Включает монитор ТАРДИС на экране",

    ["Binds.Sections.Destination"] = "Точка Назначения",
    ["Binds.Sections.Destination.Forward"] = "Вперёд",
    ["Binds.Sections.Destination.Backward"] = "Назад",
    ["Binds.Sections.Destination.Left"] = "Влево",
    ["Binds.Sections.Destination.Right"] = "Вправо",
    ["Binds.Sections.Destination.Up"] = "Вверх",
    ["Binds.Sections.Destination.Down"] = "Вниз",
    ["Binds.Sections.Destination.Boost"] = "Ускорение",
    ["Binds.Sections.Destination.Boost.Description"] = "Зажимайте эту клавишу для ускорения во время выбирания точки назначения",
    ["Binds.Sections.Destination.Slow"] = "Замедление",
    ["Binds.Sections.Destination.Slow.Description"] = "Зажимайте эту клавишу для замедления перемещения",
    ["Binds.Sections.Destination.Rotate"] = "Поворот",
    ["Binds.Sections.Destination.Rotate.Description"] = "Зажимайте эту клавишу с клавишей Ускорения и клавишей Вправо или Влево для вращения экстерьера",
    ["Binds.Sections.Destination.SnapToFloor"] = "Переместиться на Пол",
    ["Binds.Sections.Destination.SnapToFloor.Description"] = "Нажмите эту кнопку чтобы переместиться на ближайший пол",
    
    ["Binds.Sections.Flight"] = "Полёт",
    ["Binds.Sections.Flight.Forward"] = "Вперёд",
    ["Binds.Sections.Flight.Backward"] = "Назад",
    ["Binds.Sections.Flight.Left"] = "Влево",
    ["Binds.Sections.Flight.Right"] = "Вправо",
    ["Binds.Sections.Flight.Up"] = "Вверх",
    ["Binds.Sections.Flight.Down"] = "Вниз",
    ["Binds.Sections.Flight.Boost"] = "Ускорение",
    ["Binds.Sections.Flight.Boost.Description"] = "Зажимайте эту клавишу во время полёта для ускорения",
    ["Binds.Sections.Flight.Rotate"] = "Поворот",
    ["Binds.Sections.Flight.Rotate.Description"] = "Зажимайте эту клавишу и Вправо или Влево для поворота экстерьера",
    ["Binds.Sections.Flight.SpinDirection"] = "Направление поворота",
    ["Binds.Sections.Flight.SpinDirection.Description"] = "Меняет то куда вращается ТАРДИС во время полёта",
    
    ["Binds.Sections.Float"] = "Анти-Гравы",
    ["Binds.Sections.Float.Forward"] = "Вперёд",
    ["Binds.Sections.Float.Backward"] = "Назад",
    ["Binds.Sections.Float.Left"] = "Влево",
    ["Binds.Sections.Float.Right"] = "Вправо",
    ["Binds.Sections.Float.Boost"] = "Ускорение",
    ["Binds.Sections.Float.Boost.Description"] = "Зажимайте эту клавишу для ускорения поворота",
    ["Binds.Sections.Float.Rotate"] = "Поворот",
    ["Binds.Sections.Float.Rotate.Description"] = "Зажимайте эту клавишу и Вправо или Влево для поворота по вертикальной оси",
    ["Binds.Sections.Float.Brake"] = "Тормоз",
    ["Binds.Sections.Float.Brake.Description"] = "Зажимайте эту клавишу чтобы замедлить вращение",
    
    ["Binds.Sections.Teleport"] = "Телепорт",
    ["Binds.Sections.Teleport.Demat"] = "Дематериализация",
    ["Binds.Sections.Teleport.Mat"] = "Материализация",
    ["Binds.Sections.Teleport.Set"] = "Установить",

    ["Controls.Cloak"] = "Невидимость",
    ["Controls.Cloak.Tip"] = "Механизм Невидимости",
    ["Controls.Cloak.Status"] = "Невидимость",
    ["Controls.Cloak.FailedToggle"] = "Не получилось переключить Невидимость",

    ["Controls.Coordinates.Tip"] = "Координаты",

    ["Controls.Destination"] = "Пункт Назначения",
    ["Controls.Destination.Tip"] = "Выбор Пункта Назначения",

    ["Controls.Door"] = "Двери",
    ["Controls.Door.Tip"] = "Переключатель дверей",
    ["Controls.Door.Status"] = "Двери",
    ["Controls.Door.UsingEmergencyPower"] = "Используется аварийная энергия для открытия дверей...",
    ["Controls.Door.NoSwitch"] = "Преключатель дверей не работает",
    ["Controls.Door.FailedOpen"] = "Не получилось открыть дверь",
    ["Controls.Door.FailedClose"] = "Не получилось зыкрыть дверь",
    ["Controls.Door.Locked"] = "Двери заперты",

    ["Controls.DoorLock"] = "Дверной ",
    ["Controls.DoorLock.Tip"] = "Дверной замок",
    ["Controls.DoorLock.NotWorking"] = "Дистанционный замок не работает",
    ["Controls.DoorLock.UsingEmergencyPower"] = "Используется аварийная энергия для отпирания замка...",
    ["Controls.DoorLock.FailedToggle"] = "Не получилось использовать ",

    ["Controls.EngineRelease"] = "Реализатор Двигателя",
    ["Controls.EngineRelease.Tip"] = "Реализатор Двигателя",
    ["Controls.EngineRelease.ForceDemat"] = "Принудительная дематериализация",
    ["Controls.EngineRelease.FailedDemat"] = "Не получилось дематериализоваться",

    ["Controls.FastReturn"] = "Быстрое Возвращение",
    ["Controls.FastReturn.Tip"] = "Протокол Быстрого Возврата",
    ["Controls.FastReturn.Activated"] = "Протокол Быстрого Возврата был задействован",
    ["Controls.FastReturn.Failed"] = "Не получилось задействовать Протокол Быстрого Возврата",

    ["Controls.Flight"] = "Режим полёта",
    ["Controls.Flight.Tip"] = "Режим Полёта",
    ["Controls.Flight.Status"] = "Режим полёта",
    ["Controls.Flight.FailedToggle"] = "Не получилось переключить Режим полёта",

    ["Controls.Float"] = "Анти-Гравы",
    ["Controls.Float.Tip"] = "Анти-Гравы",
    ["Controls.Float.Status"] = "Анти-Гравы",
    ["Controls.Float.FailedToggle"] = "Не получилось переключить Анти-Гравы",

    ["Controls.HADS"] = "С.П.О.В.Д.",
    ["Controls.HADS.Tip"] = "С.П.О.В.Д.",
    ["Controls.HADS.Status"] = "Система Перемещения От Враждебных Действий",

    ["Controls.Handbrake"] = "Ручной Тормоз",
    ["Controls.Handbrake.Tip"] = "Ручной Тормоз",
    ["Controls.Handbrake.Status"] = "Ручной Тормоз",
    ["Controls.Handbrake.FailedToggle"] = "Не получилось переключить Ручной Тормоз",

    ["Controls.InteriorLights.Tip"] = "Свет",

    ["Controls.Isomorphic"] = "Изоморфная Защита",
    ["Controls.Isomorphic.Tip"] = "Система Изоморфной Защиты",
    ["Controls.Isomorphic.Status"] = "Изоморфная Защита",
    ["Controls.Isomorphic.FailedToggle"] = "Не получилось переключить Изоморфную Защиту",
    ["Controls.Isomorphic.NotCreator"] = "Эта ТАРДИС вам не пренадлежит",
    ["Controls.Isomorphic.SingleplayerWarning"] = "ПРЕДУПРЕЖДЕНИЕ: Изоморфная Защита не имеет использования в одиночной игре",

    ["Controls.Music.Tip"] = "Музыка",

    ["Controls.Physlock"] = "ФизЛок",
    ["Controls.Physlock.Tip"] = "Механизм Физической Блокировки",
    ["Controls.Physlock.Status"] = "Механизм Физической Блокировки",
    ["Controls.Physlock.FailedToggle"] = "Не получилось переключить Механизм Физической Блокировки",

    ["Controls.Power"] = "Энергия",
    ["Controls.Power.Tip"] = "Переключатель Энергии",
    ["Controls.Power.Status"] = "Энергия",
    ["Controls.Power.FailedToggle"] = "Не получилось переключить энергию",

    ["Controls.RandomCoords.Tip"] = "Случайная Точка Назначения",
    ["Controls.RandomCoords.Selected"] = "Случайная Точка Назначения была выбрана",
    
    ["Controls.Redecorate"] = "Редекорация",
    ["Controls.Redecorate.Tip"] = "Редекорация",
    ["Controls.Redecorate.Status"] = "Редекорация",
    ["Controls.Redecorate.FailedToggle"] = "Не удалось переключить Редекорацию",
    ["Controls.Redecorate.RandomInteriorWarning"] = "ПРЕДУПРЕЖДЕНИЕ: Был выбран случайный интерьер. Правый клик по нему в Меню Создания для выбора.",
    ["Controls.Redecorate.NotCreator"] = "Вы не можете изменить интерьер чужой ТАРДИС",

    ["Controls.Repair"] = "Само-Восстановление",
    ["Controls.Repair.Tip"] = "Само-Восстановление",
    ["Controls.Repair.FailedToggle"] = "Не получилось переключить Само-Восстановление",

    ["Controls.Scanner.Tip"] = "Сканер",

    ["Controls.Shields.Tip"] = "Щиты",

    ["Controls.SonicDispenser.Tip"] = "Заряжатель Звуковых Устройств",
    ["Controls.SonicDispenser.MissingAddon"] = "У вас не установлен аддон 'Sonic Screwdriver'. Установите его для работы этой функции.",
    ["Controls.SonicDispenser.Dispensed"] = "Звуковая Отвёртка была выпущена",
    ["Controls.SonicDispenser.Equipped"] = "Звуковая Отвёртка была взята",
    ["Controls.SonicDispenser.AlreadyEquipped"] = "Вы уже держите звуковое устройтво",

    ["Controls.SpinCycle"] = "Направление Вращения",
    ["Controls.SpinCycle.Tip"] = "Направление Вращения",

    ["Controls.SpinSwitch.Tip"] = "Переключение Вращения",
    ["Controls.SpinSwitch.ChangedDisabled"] = "Вращение выключено, но его напрвление - %s",

    ["Controls.SpinToggle.Tip"] = "Вращение",
    ["Controls.SpinToggle.Status"] = "Вращение",

    ["Controls.Stabilizers.Tip"] = "Стабилизаторы",

    ["Controls.Teleport"] = "Телепорт",
    ["Controls.Teleport.Tip"] = "Пространственно-Временной Дроссель",
    ["Controls.Teleport.Mat"] = "ТАРДИС Матереализуется",
    ["Controls.Teleport.FailedMat"] = "Не получилось материализоваться",
    ["Controls.Teleport.Demat"] = "ТАРДИС Дематереализуется",
    ["Controls.Teleport.FailedDematDoorsOpen"] = "ТАРДИС не может замкнуть карман пространства-времени. Закройте двери!",
    ["Controls.Teleport.FailedDematHandbrake"] = "Ручной Тормоз мешает ТАРДИС дематериализоваться!",
    ["Controls.Teleport.FailedDemat"] = "Не получилось дематериализоваться",

    ["Controls.ThirdPersonCareful.Tip"] = "Ручное Управление Полётом",

    ["Controls.ThirdPerson"] = "Управление Полётом",
    ["Controls.ThirdPerson.Tip"] = "Ручное Управление Полётом",

    ["Controls.ToggleScreens"] = "Переключатель Монитора",
    ["Controls.ToggleScreens.Tip"] = "Переключатель Монитора",
    ["Controls.ToggleScreens.Status"] = "Внутренние Мониторы",
    ["Controls.ToggleScreens.FailedToggle"] = "Не получилось переключить внутренние мониторы",

    ["Controls.VirtualConsole.Tip"] = "Виртуальная Консоль",

    ["Controls.VortexFlight"] = "Полёт в Воронке",
    ["Controls.VortexFlight.Tip"] = "Полёт по Временной Воронке",
    ["Controls.VortexFlight.Status"] = "Полёт в Воронке",
    ["Controls.VortexFlight.FailedToggle"] = "Не получилось переключить Полёт в Воронке",

    ["Parts.DefaultAtomAccelerator.Text"] = "Изменение Полярности Оболочки",
    ["Parts.DefaultDematCircuit.Text"] = "Контур Дематериализации",
    ["Parts.DefaultDirectionalPointer.Text"] = "Изменение Направления",
    ["Parts.DefaultGramophone.Text"] = "Грамофон",
    ["Parts.DefaultHelmic.Text"] = "Темпоральный Регулятор",
    ["Parts.DefaultScreen.Text"] = "Монитор",
    ["Parts.DefaultWibblyLever.Text"] = "Шатающийся Рычаг",

    ["Parts.Door.Locked"] = "Двери Заперты",

    ["Interiors.DefaultTTCapsule"] = "ТТ Капсула Стандартная",
    
    ["Interiors.Default"] = "Стандартный",
    ["Interiors.Default.Versions.TTCapsule"] = "Версия ТТ Капсулы",

    ["Themes.Default"] = "Стандарт",
    ["Themes.Transparent"] = "Прозрачная",
    ["Themes.TextOnly"] = "Только текст",

    ["TipStyles.Default"] = "Стандарт(установленные интерьером)",
    ["TipStyles.Classic"] = "Классические(legacy)",
    ["TipStyles.WhiteOnBlue"] = "Белое на Синем",
    ["TipStyles.WhiteOnGrey"] = "Белое на Сером",

    ["Screens.Common.Back"] = "Назад",
    ["Screens.Common.Menu"] = "Меню",
    ["Screens.Common.Exit"] = "Выход",
    ["Screens.Common.Popup"] = "На экран",
    ["Screens.Common.CurrentPage"] = "Страница %d of %d",

    ["Screens.Coordinates"] = "Координаты",
    ["Screens.Coordinates.Saved"] = "Локации сохранены",
    ["Screens.Coordinates.Loaded"] = "Локации загружены",
    ["Screens.Coordinates.NoDestinationSet"] = "Маршрут не установлен",
    ["Screens.Coordinates.SelectManually"] = "Выбор вручную",
    ["Screens.Coordinates.X"] = "X",
    ["Screens.Coordinates.Y"] = "Y",
    ["Screens.Coordinates.Z"] = "Z",
    ["Screens.Coordinates.Pitch"] = "Тангаж",
    ["Screens.Coordinates.Yaw"] = "Рысканье",
    ["Screens.Coordinates.Roll"] = "Крен",
    ["Screens.Coordinates.Name"] = "Имя",
    ["Screens.Coordinates.Unnamed"] = "Безымянные",
    ["Screens.Coordinates.CurrentSetDestination"] = "Установленные координаты",
    ["Screens.Coordinates.RandomGround"] = "Случайные(поверхность)",
    ["Screens.Coordinates.Random"] = "Случайные",
    ["Screens.Coordinates.RandomLocationGround"] = "Случайная позиция на поверхности",
    ["Screens.Coordinates.RandomLocation"] = "Случайная позиция",
    ["Screens.Coordinates.GetCurrentPosition"] = "Использовать текущую позицию",
    ["Screens.Coordinates.NameNewLocationFromInputs"] = "Введите имя новой локации (Будет использоваться информация из ввода)",
    ["Screens.Coordinates.NameNewLocation"] = "Введите имя новой локации",
    ["Screens.Coordinates.NewLocation"] = "Новая Локация",
    ["Screens.Coordinates.NewLocationUseCurrentPos"] = "Использовать текущую позицию и поворот?\nВыбор '%s' будет использовать информацию на вводе",
    ["Screens.Coordinates.RemoveLocation"] = "Удалить Локацию",
    ["Screens.Coordinates.ConfirmRemoveLocation"] = "Это удалит локацию НАВСЕГДА!Вы уверены?",

    ["Screens.Music"] = "Музыка",
    ["Screens.Music.MissingName"] = "Вы должны уточнить имя музыки для её добавления",
    ["Screens.Music.MissingUrl"] = "Вы должны уточнить URL музыки для её добавления",
    ["Screens.Music.Conflict"] = "Музыка с таким именем уже существует",
    ["Screens.Music.CannotRemoveDefault"] = "Вы не можете удалить стандартный набор музыки",
    ["Screens.Music.DeleteNoSelection"] = "Вы не выбрали музыку для удаления",
    ["Screens.Music.NoChoice"] = "Музыка не была выбрана",
    ["Screens.Music.DefaultLoadError"] = "Ошибка проигрывания стандартной музыки: %s",
    ["Screens.Music.UnableToDecodeList"] = "Невозможно декодировать лист",
    ["Screens.Music.CustomAdded"] = "Дополнительная музыка '%s' добавлено: %s",
    ["Screens.Music.CustomRemoved"] = "Дополнительная музыка '%s' удалено: %s",
    ["Screens.Music.DefaultMusic"] = "Стандартный набор музыки",
    ["Screens.Music.CustomMusic"] = "Дополнительная музыка",
    ["Screens.Music.UrlPlaceholder"] = "Введите URL музыки",
    ["Screens.Music.NamePlaceholder"] = "Введите имя музыки",
    ["Screens.Music.PlayStop"] = "Проиграть / Остановить",
    ["Screens.Music.DeleteConfirm"] = "Вы уверены, что хотите удалить \"%s\" из списка музыки? Это действие необратимо",

    ["Screens.Scanner"] = "Сканер",
    ["Screens.Scanner.Front"] = "Перед",
    ["Screens.Scanner.Back"] = "Зад",
    ["Screens.Scanner.Left"] = "Лево",
    ["Screens.Scanner.Right"] = "Право",

    ["Screens.VirtualConsole"] = "Виртуальная Консоль",
    ["Screens.VirtualConsole.Old.TogglePower"] = "Переключить энергию",
    ["Screens.VirtualConsole.Old.Repair"] = "Восстановить ТАРДИС",
    ["Screens.VirtualConsole.Old.FastRemat"] = "Быстрый ремат",
    ["Screens.VirtualConsole.Old.Physlock"] = "ФизЛок",
    ["Screens.VirtualConsole.Old.FastReturn"] = "Быстрый Возврат",
    ["Screens.VirtualConsole.Old.HADS"] = "С.П.О.В.Д.",
    ["Screens.VirtualConsole.Old.CloseDoor"] = "Закрыть дверь",
    ["Screens.VirtualConsole.Old.OpenDoor"] = "Открыть дверь",
    ["Screens.VirtualConsole.Old.UnlockDoor"] = "Разблокировать дверь",
    ["Screens.VirtualConsole.Old.LockDoor"] = "Заблокировать дверь",
    ["Screens.VirtualConsole.Old.DoorClosing"] = "Двери закрываются",
    ["Screens.VirtualConsole.Old.DoorOpening"] = "Двери открываются",
    ["Screens.VirtualConsole.Old.LockUnlocking"] = "Замок: Отперт",
    ["Screens.VirtualConsole.Old.LockLocking"] = "Замок: Заперт",

    ["Spawnmenu.RedecorationSelected"] = "Интерьер ТАРДИС был выбран. Используйте Редекорацию внутри ТАРДИС для применения",
    ["Spawnmenu.RedecorationSelectedRestart"] = "Интерьер ТАРДИС был выбран. Используйте Редекорацию ещё раз для применения",
    ["Spawnmenu.SelectForRedecoration"] = "Выбрать для Редекорации",
    ["Spawnmenu.ReloadGame"] = "Перезайдите для применения изменений",
    ["Spawnmenu.FavoritesUpdated"] = "Избранные интерьеры были обновлены",
    ["Spawnmenu.ClassicDoorsVersion"] = "Версия с Классическими дверями:",
    ["Spawnmenu.DoubleDoorsVersion"] = "Версия с двумя дверями:",
    ["Spawnmenu.AlternativeVersions"] = "Альтернативные версии:",
    ["Spawnmenu.CustomVersions"] = "Дополнительные версии:",
    ["Spawnmenu.VersionOptions.Default"] = "Стандартная",
    ["Spawnmenu.VersionOptions.Random"] = "Случайная",
    ["Spawnmenu.VersionOptions.RandomOriginal"] = "Случайная (из оригинальных версий)",
    ["Spawnmenu.VersionOptions.RandomOriginalAndCustom"] = "Случайная (из оригинальных версий и legacy)",
    ["Spawnmenu.Spawn"] = "Создать",
    ["Spawnmenu.Settings"] = "Настройки",
    ["Spawnmenu.PreferredVersion"] = "Предпочитаемая версия",
    ["Spawnmenu.PreferredDoorType"] = "Предпочитаемый стиль дверей",
    ["Spawnmenu.PreferredDoorType.Default"] = "Стандарт (в настройках ТАРДИС)",
    ["Spawnmenu.PreferredDoorType.Random"] = "Случайный",
    ["Spawnmenu.PreferredDoorType.Classic"] = "Классические двери",
    ["Spawnmenu.PreferredDoorType.Double"] = "Двойные двери",
    ["Spawnmenu.AddToFavourites"] = "Добавить в избранные(понадобиться перезапуск)",
    ["Spawnmenu.RemoveFromFavourites"] = "Убрать из избранных(понадобиться перезапуск)",
    ["Spawnmenu.Category"] = "Доктор Кто - ТАРДИС",
    ["Spawnmenu.RedecorationExclude"] = "Убрать из случайной Редекорации",
    ["Spawnmenu.ResetSettings"] = "Сбросить настройки",

    ["Settings.NoPermissionGlobalSettings"] = "У вас нет полномочий для изменения глобальных настроек",

    ["Wiremod.Inputs.Demat"] = "Дематериализовать ТАРДИС",
    ["Wiremod.Inputs.Mat"] = "Материализовать ТАРДИС",
    ["Wiremod.Inputs.Pos"] = "X,Y,Z: Позиция Телепортации",
    ["Wiremod.Inputs.Ang"] = "X,Y,Z: Угол Телепортации",

    ["Wiremod.Outputs.Health"] = "Здоровье ТАРДИС",
}

TARDIS:AddLanguage(T)