
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("Подсказка", Подсказка) = Ложь Тогда
		Возврат;
	КонецЕсли;
	
	МассивСтрок = Новый Массив;

	ШаблонШапки = "<img src=""Идея"">  <b> %1 </b>%2 %3%4";
	ШапкаТекст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		ШаблонШапки, 
		Подсказка.Заголовок, 
		Символы.ПС, 
		Символы.ПС, 
		Подсказка.Содержание);
	ФорматированнаяШапка = СтроковыеФункции.ФорматированнаяСтрока(ШапкаТекст);
	МассивСтрок.Добавить(ФорматированнаяШапка);
	
	КлючСохраненияПоложенияОкна = Подсказка.Код;
	
	// Регистрация в сервисе.
	Если Подсказка.Действия.Найти("Регистрация")<> Неопределено Тогда
		
		ШаблонРегистрация = НСтр("ru = '%1%2Зарегистрироваться в сервисе 1С:Бизнес-сеть';
								|en = '%1%2Register in 1C:Business Network'");
		РегистрацияТекст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			ШаблонРегистрация, 
			Символы.ПС, 
			Символы.ПС);
		ФорматированнаяРегистрация = Новый ФорматированнаяСтрока(РегистрацияТекст,,,, "ДействиеРегистрация");
		МассивСтрок.Добавить(ФорматированнаяРегистрация);
		
	КонецЕсли;
	
	// Публикация торговых предложений.
	Если Подсказка.Действия.Найти("ПубликацияТорговыхПредложений") <> Неопределено Тогда
		
		ШаблонПубликация = НСтр("ru = '%1%2Настроить публикацию торговых предложений';
								|en = '%1%2Set up publication of selling propositions'");
		ПубликацияТекст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			ШаблонПубликация, 
			Символы.ПС, 
			Символы.ПС);
		ФорматированнаяПубликация = Новый ФорматированнаяСтрока(ПубликацияТекст,,,, "ДействиеПубликация");
		МассивСтрок.Добавить(ФорматированнаяПубликация);
		
	КонецЕсли;
		
	// Приглашение контрагентов.
	Если Подсказка.Действия.Найти("ОтправкаПриглашений") <> Неопределено Тогда
		
		ШаблонПриглашение = НСтр("ru = '%1%2Пригласить в сервис клиентов';
								|en = '%1%2Invite customers to the service'");
		ПриглашениеТекст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			ШаблонПриглашение, 
			Символы.ПС, 
			Символы.ПС);
		ФорматированноеПриглашение = Новый ФорматированнаяСтрока(ПриглашениеТекст,,,, "ДействиеПриглашение");
		МассивСтрок.Добавить(ФорматированноеПриглашение);
		
	КонецЕсли;
	
	// Поиск торговых предложений по отборам.
	Если Подсказка.Действия.Найти("ПоискПоОтборам") <> Неопределено Тогда
		
		ШаблонПоиск = НСтр("ru = '%1%2Найти торговые предложения';
							|en = '%1%2Find selling propositions'");
		ПоискТекст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			ШаблонПоиск, 
			Символы.ПС, 
			Символы.ПС);
		ФорматированныйПоискПоОтборам = Новый ФорматированнаяСтрока(ПоискТекст,,,, "ДействиеПоискПоОтборам");
		МассивСтрок.Добавить(ФорматированныйПоискПоОтборам);
		
	КонецЕсли;
	
	// Поиск торговых предложений по списку.
	Если Подсказка.Действия.Найти("ПоискПоТоварам") <> Неопределено Тогда
		
		ШаблонПоиск = НСтр("ru = '%1%2Найти торговые предложения';
							|en = '%1%2Find selling propositions'");
		ПоискТекст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			ШаблонПоиск, 
			Символы.ПС, 
			Символы.ПС);
		ФорматированныйПоискПоТоварам = Новый ФорматированнаяСтрока(ПоискТекст,,,, "ДействиеПоискПоТоварам");
		МассивСтрок.Добавить(ФорматированныйПоискПоТоварам);
		
	КонецЕсли;
	
	ТекстПредупреждения = "";
	
	Если Подсказка.Действия.Найти("ВыгрузкаШтрихкодов") <> Неопределено Тогда
		ТекстПредупреждения = НСтр("ru = 'В сервис 1С:Бизнес-сеть еще не выгружены штрихкоды по регламентному заданию.';
									|en = 'Barcodes by schedule job have not been exported to 1C:Business Network service yet.'");
	КонецЕсли;
	
	Если Не ПустаяСтрока(ТекстПредупреждения) Тогда
		Элементы.ПредупреждениеОбОшибке.Заголовок = ТекстПредупреждения;
	КонецЕсли;
	
	Элементы.Содержание.Заголовок = Новый ФорматированнаяСтрока(МассивСтрок);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СодержаниеОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	ОчиститьСообщения();
	
	СтандартнаяОбработка = Ложь;
	Если НавигационнаяСсылкаФорматированнойСтроки = "ДействиеРегистрация" Тогда
		
		// Код для совместимости, открытие должно производиться из формы контекста.
		БизнесСетьСлужебныйКлиент.ОткрытьФормуРегистрацииОрганизаций();
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "ДействиеПубликация" Тогда
		
		ТорговыеПредложенияКлиент.ОткрытьФормуПомощникаПубликации();
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "ДействиеПриглашение" Тогда
		
		Если Подсказка.РежимПоставщика Тогда
			РежимПриглашения = "Поставщики";
		ИначеЕсли Подсказка.РежимПокупателя Тогда
			РежимПриглашения = "Покупатели";
		Иначе
			РежимПриглашения = "Общий";
		КонецЕсли;
		
		ПараметрыОткрытия = Новый Структура;
		ПараметрыОткрытия.Вставить("РежимПриглашения", РежимПриглашения);
		ОткрытьФорму("Обработка.БизнесСеть.Форма.ОтправкаПриглашенийКонтрагентам", ПараметрыОткрытия);
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "ДействиеПоискПоТоварам" Тогда
		
		// Код для совместимости, открытие должно производиться из формы контекста.
		ПараметрыОткрытия = Новый Структура;
		ПараметрыОткрытия.Вставить("ПараметрыКоманды", ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ЭтотОбъект.ВладелецФормы.Объект.Ссылка));
		ТорговыеПредложенияКлиент.ОткрытьФормуПоискаПоТоварам(ПараметрыОткрытия);
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "ДействиеПоискПоОтборам" Тогда
		
		// Код для совместимости, открытие должно производиться из формы контекста.
		ПараметрыОткрытия = Новый Структура;
		ПараметрыОткрытия.Вставить("ПараметрыКоманды", ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ЭтотОбъект.ВладелецФормы.Объект.Ссылка));
		ТорговыеПредложенияКлиент.ОткрытьФормуПоискаПоОтборам(ПараметрыОткрытия);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти