#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ДоступнаМультипредметность = ИнтеграцияС1СДокументооборотБазоваяФункциональностьПовтИсп.ДоступенФункционалВерсииСервиса("2.0.3.1");
	Элементы.СтраницыМультипредметность.ТекущаяСтраница = ?(ДоступнаМультипредметность,
		Элементы.СтраницаДоступнаМультипредметность,
		Элементы.СтраницаНедоступнаМультипредметность);
	
	ТипПроцессаXDTO = "DMComplexBusinessProcess";
	ОбъектXDTO = ИнтеграцияС1СДокументооборот.ПолучитьОбъектXDTOПроцесса(ТипПроцессаXDTO, Параметры);
	ЗаполнитьФормуИзОбъектаXDTO(ОбъектXDTO);
	
	Если Параметры.Свойство("Шаблон") Тогда
		ШаблонID = Параметры.Шаблон.ID;
		ШаблонТип = Параметры.Шаблон.type;
	КонецЕсли;
	
	УстановитьВидимостьЭлементов();
	
	ИнтеграцияС1СДокументооборотБазоваяФункциональностьПереопределяемый.ДополнительнаяОбработкаФормыБизнесПроцесса(
		ЭтотОбъект,
		Отказ,
		СтандартнаяОбработка);
	
	Элементы.ПорядокВыполненияПереключатель.СписокВыбора.Очистить();
	Элементы.ПорядокВыполненияПереключатель.СписокВыбора.Добавить("Параллельно", НСтр("ru = 'Всем сразу';
																						|en = 'To all at once'")); //@NON-NLS-1
	Элементы.ПорядокВыполненияПереключатель.СписокВыбора.Добавить("Последовательно", НСтр("ru = 'По очереди';
																							|en = 'In sequence'")); //@NON-NLS-1
	Элементы.ПорядокВыполненияПереключатель.СписокВыбора.Добавить("Смешанно", НСтр("ru = 'Смешанно';
																					|en = 'Mixed'")); //@NON-NLS-1
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если Модифицированность Тогда
		Оповещение = Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект);
		ТекстПредупреждения = "";
		ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(Оповещение, Отказ, ЗавершениеРаботы,,ТекстПредупреждения);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Изменен" И Параметр = Элементы.ПредметПредставление Тогда
		Предмет = Источник.Представление;
		
	ИначеЕсли ИмяСобытия = "Запись_ДокументооборотБизнесПроцесс" Тогда
		Если Параметр.ID = ID Тогда
			ПеречитатьПроцесс();
		КонецЕсли;
		
	ИначеЕсли (ИмяСобытия = "Документооборот_ВыбратьЗначениеИзВыпадающегоСпискаЗавершение"
				Или ИмяСобытия = "Документооборот_ВыборДанныхДляАвтоПодбора")
			И Источник = ЭтотОбъект
			И Параметр.Реквизит = "Важность" Тогда
		ИзменитьВажностьЭтапов();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ГлавнаяЗадачаПредставлениеНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ЗначениеЗаполнено(ГлавнаяЗадача) Тогда
		ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ОткрытьОбъект(ГлавнаяЗадачаТип, ГлавнаяЗадачаID, Элемент);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПредметНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ЗначениеЗаполнено(Предмет) Тогда
		ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ОткрытьОбъект(ПредметТип, ПредметID, Элемент);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПорядокВыполненияПереключательПриИзменении(Элемент)
	
	ОбработатьВыборПорядкаВыполнения();
	
КонецПроцедуры

&НаКлиенте
Процедура ВажностьНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияС1СДокументооборотКлиент.ВыбратьЗначениеИзВыпадающегоСписка("DMBusinessProcessImportance", "Важность", ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ВажностьАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		ИнтеграцияС1СДокументооборотБазоваяФункциональностьВызовСервера.ДанныеДляАвтоПодбора(
			"DMBusinessProcessImportance",
			ДанныеВыбора,
			Текст,
			СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВажностьОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		ИнтеграцияС1СДокументооборотБазоваяФункциональностьВызовСервера.ДанныеДляАвтоПодбора(
			"DMBusinessProcessImportance", ДанныеВыбора, Текст, СтандартнаяОбработка);
		
		Если ДанныеВыбора.Количество() = 1 Тогда
			ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ОбработкаВыбораДанныхДляАвтоПодбора(
				"Важность", ДанныеВыбора[0].Значение, СтандартнаяОбработка, ЭтотОбъект);
			СтандартнаяОбработка = Истина;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВажностьОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ОбработкаВыбораДанныхДляАвтоПодбора(
		"Важность",
		ВыбранноеЗначение,
		СтандартнаяОбработка,
		ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура АвторНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияС1СДокументооборотКлиент.ВыбратьПользователяИзДереваПодразделений("Автор", ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура АвторАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		ИнтеграцияС1СДокументооборотБазоваяФункциональностьВызовСервера.ДанныеДляАвтоПодбора(
			"DMUser",
			ДанныеВыбора,
			Текст,
			СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура АвторОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		ИнтеграцияС1СДокументооборотБазоваяФункциональностьВызовСервера.ДанныеДляАвтоПодбора("DMUser", ДанныеВыбора, Текст, СтандартнаяОбработка);
		
		Если ДанныеВыбора.Количество() = 1 Тогда
			ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ОбработкаВыбораДанныхДляАвтоПодбора(
				"Автор",
				ДанныеВыбора[0].Значение,
				СтандартнаяОбработка,
				ЭтотОбъект);
			СтандартнаяОбработка = Истина;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура АвторОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ОбработкаВыбораДанныхДляАвтоПодбора(
		"Автор",
		ВыбранноеЗначение,
		СтандартнаяОбработка,
		ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура КонтролерНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Оповещение = Новый ОписаниеОповещения("КонтролерНачалоВыбораЗавершение", ЭтотОбъект);
	
	ОткрытьФорму("Обработка.ИнтеграцияС1СДокументооборот.Форма.ВыборИсполнителяБизнесПроцесса",,
		ЭтотОбъект,,,, Оповещение, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура КонтролерНачалоВыбораЗавершение(Результат, ПараметрыОповещения) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Результат.Свойство("Исполнитель", Контролер);
	Результат.Свойство("ИсполнительID", КонтролерID);
	Результат.Свойство("ИсполнительТип", КонтролерТип);
	
	Результат.Свойство("ОсновнойОбъектАдресации",ОсновнойОбъектАдресацииКонтролера);
	Результат.Свойство("ОсновнойОбъектАдресацииID", ОсновнойОбъектАдресацииКонтролераID);
	Результат.Свойство("ОсновнойОбъектАдресацииТип", ОсновнойОбъектАдресацииКонтролераТип);
	
	Результат.Свойство("ДополнительныйОбъектАдресации", ДополнительныйОбъектАдресацииКонтролера);
	Результат.Свойство("ДополнительныйОбъектАдресацииID", ДополнительныйОбъектАдресацииКонтролераID);
	Результат.Свойство("ДополнительныйОбъектАдресацииТип", ДополнительныйОбъектАдресацииКонтролераТип);
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура КонтролерАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		ИнтеграцияС1СДокументооборотБазоваяФункциональностьВызовСервера.ДанныеДляАвтоПодбора(
			"DMUser;DMBusinessProcessExecutorRole",
			ДанныеВыбора,
			Текст,
			СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КонтролерОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		ИнтеграцияС1СДокументооборотБазоваяФункциональностьВызовСервера.ДанныеДляАвтоПодбора(
			"DMUser;DMBusinessProcessExecutorRole",
			ДанныеВыбора,
			Текст,
			СтандартнаяОбработка);
		
		Если ДанныеВыбора.Количество() = 1 Тогда
			Если Элемент = Элементы.Контролер Тогда
				ИнтеграцияС1СДокументооборотКлиент.ПрименитьВыборУчастникаБизнесПроцессаВПоле(
					"Контролер", "ОбъектАдресацииКонтролера",
					ДанныеВыбора[0].Значение,
					СтандартнаяОбработка,
					ЭтотОбъект);
			Иначе
				ИнтеграцияС1СДокументооборотКлиент.ПрименитьВыборУчастникаБизнесПроцессаВСписке(
					Элемент.Родитель.Родитель,
					ДанныеВыбора[0].Значение,
					СтандартнаяОбработка,
					ЭтотОбъект);
			КонецЕсли;
			СтандартнаяОбработка = Истина;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КонтролерОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ИнтеграцияС1СДокументооборотКлиент.ПрименитьВыборУчастникаБизнесПроцессаВПоле(
		"Контролер",
		"ОбъектАдресацииКонтролера",
		ВыбранноеЗначение,
		СтандартнаяОбработка,
		ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СрокДатаПриИзменении(Элемент)
	
	Если Срок = НачалоДня(Срок) Тогда
		Срок = КонецДня(Срок);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьБизнесПроцесс(Команда)
	
	РезультатЗаписи = ЗаписатьОбъект();
	
	Если РезультатЗаписи Тогда
		ИнтеграцияС1СДокументооборотКлиент.Оповестить_ЗаписьБизнесПроцесса(ЭтотОбъект, Ложь);
		Заголовок = Представление;
		Состояние(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Бизнес-процесс ""%1"" сохранен.';
				|en = 'Business process ""%1"" is saved.'"), Представление));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СтартоватьИЗакрыть(Команда)
	
	РезультатЗапуска = ПодготовитьКПередачеИСтартоватьБизнесПроцесс();
	
	Если РезультатЗапуска Тогда
		ИнтеграцияС1СДокументооборотКлиент.Оповестить_ЗаписьБизнесПроцесса(ЭтотОбъект, Истина);
		ТекстСостояния = НСтр("ru = 'Бизнес-процесс ""%Наименование%"" успешно запущен.';
								|en = 'The ""%Наименование%"" business process is started successfully.'");
		ТекстСостояния = СтрЗаменить(ТекстСостояния,"%Наименование%", Представление);
		Состояние(ТекстСостояния);
		Модифицированность = Ложь;
		Если Открыта() Тогда
			Закрыть();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоШаблону(Команда)
	
	Оповещение = Новый ОписаниеОповещения("ЗаполнитьПоШаблонуЗавершение", ЭтотОбъект);
	ИнтеграцияС1СДокументооборотКлиент.НачатьВыборШаблонаБизнесПроцесса(Оповещение, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОстановитьПроцесс(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ОстановитьПроцесс(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПрерватьПроцесс(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ПрерватьПроцесс(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПродолжитьПроцесс(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ПродолжитьПроцесс(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ЗаполнитьПоШаблонуЗавершение(РезультатВыбораШаблона, ПараметрыОповещения) Экспорт
	
	Если ТипЗнч(РезультатВыбораШаблона) = Тип("Структура") Тогда
		ЗаполнитьКарточкуПоШаблону(РезультатВыбораШаблона);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьЭлементов()
	
	Если ПорядокВыполненияID <> "Смешанно" Тогда //@NON-NLS-1
		Элементы.ЭтапыПредшественникиЭтапаСтрокой.Видимость = Ложь;
	Иначе
		Элементы.ЭтапыПредшественникиЭтапаСтрокой.Видимость = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьКарточкуПоШаблону(ДанныеШаблона)
	
	РезультатЗаполнения = ИнтеграцияС1СДокументооборотВызовСервера.ЗаполнитьБизнесПроцессПоШаблону(
		ЭтотОбъект,
		ДанныеШаблона);
	ЗаполнитьФормуИзОбъектаXDTO(РезультатЗаполнения.object);

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьФормуИзОбъектаXDTO(ОбъектXDTO)
	
	Если ОбъектXDTO.Установлено("objectID") Тогда
		ID = ОбъектXDTO.objectID.ID;
		Тип = ОбъектXDTO.objectID.type;
	КонецЕсли;
	
	Обработки.ИнтеграцияС1СДокументооборотБазоваяФункциональность.УстановитьНавигационнуюСсылку(
		ЭтотОбъект,
		ОбъектXDTO);
	Обработки.ИнтеграцияС1СДокументооборот.ЗаполнитьСтандартнуюШапкуБизнесПроцесса(ЭтотОбъект, ОбъектXDTO);
	Обработки.ИнтеграцияС1СДокументооборот.УстановитьВидимостьКомандИзмененияСостоянияПроцесса(ЭтотОбъект, ОбъектXDTO);
	Обработки.ИнтеграцияС1СДокументооборот.ЗаполнитьКонтролераВФорме(ЭтотОбъект, ОбъектXDTO);
	
	ИнтеграцияС1СДокументооборотБазоваяФункциональность.ЗаполнитьОбъектныйРеквизит(
		ЭтотОбъект,
		ОбъектXDTO.routingType,
		"ПорядокВыполнения");
	ОбработатьВыборПорядкаВыполнения();
	
	ИнтеграцияС1СДокументооборотБазоваяФункциональность.ЗаполнитьОбъектныйРеквизит(
		ЭтотОбъект,
		ОбъектXDTO.businessProcessTemplate,
		"Шаблон");
	
	Этапы.Очистить();
	Номер = 1;
	Для Каждого Этап Из ОбъектXDTO.stages Цикл
		НоваяСтрока = Этапы.Добавить();
		НоваяСтрока.НомерСтроки = Номер;
		
		НоваяСтрока.Важность = 1;
		Если ИнтеграцияС1СДокументооборотБазоваяФункциональность.СвойствоУстановлено(Этап, "importance") Тогда
			Если Этап.importance.objectID.ID = "Низкая" Тогда //@NON-NLS-1
				НоваяСтрока.Важность = 0;
			ИначеЕсли Этап.importance.objectID.ID = "Обычная" Тогда //@NON-NLS-1
				НоваяСтрока.Важность = 1;
			ИначеЕсли Этап.importance.objectID.ID = "Высокая" Тогда //@NON-NLS-1
				НоваяСтрока.Важность = 2;
			КонецЕсли;
		КонецЕсли;
		
		НоваяСтрока.ИдентификаторЭтапа = Этап.stageID;
		НоваяСтрока.ИсполнителиЭтапаСтрокой = Этап.participants;
		ИнтеграцияС1СДокументооборотБазоваяФункциональность.ЗаполнитьОбъектныйРеквизит(
			НоваяСтрока, Этап.template, "ШаблонБизнесПроцесса");
		ДополнитьИмяШаблонаПоТипуШаблона(НоваяСтрока);
		НоваяСтрока.ПредшественникиЭтапаСтрокой = Этап.stagePredecessors;
		НоваяСтрока.ПредшественникиВариантИспользования = Этап.predecessorsUseOption;
		НоваяСтрока.БезусловныйПереходКСледующемуБылВыполнен = Этап.unconditionalPassageExecuted;
		НоваяСтрока.ЗадачаВыполнена = Этап.executed;
		ИнтеграцияС1СДокументооборотБазоваяФункциональность.ЗаполнитьОбъектныйРеквизит(
			НоваяСтрока, Этап.businessProcess, "ЗапущенныйБизнесПроцесс");
		Если Этап.Установлено("businessProcess") Тогда
			НоваяСтрока.СрокВыполнения = Этап.businessProcess.dueDate;
		КонецЕсли;
		Если ЗначениеЗаполнено(НоваяСтрока.СрокВыполнения) И Не НоваяСтрока.ЗадачаВыполнена Тогда
			НоваяСтрока.Срок = СтрШаблон("%1 (%2)",
				Формат(НоваяСтрока.СрокВыполнения, НСтр("ru = 'ДФ=''dd.MM.yyyy HH:mm''';
														|en = 'DF=''MM.dd.yyyy HH:mm'''")), Этап.duration);
		Иначе
			НоваяСтрока.Срок = Этап.duration;
		КонецЕсли;
		Номер = Номер + 1;
	КонецЦикла;
	
	ПредшественникиЭтапов.Очистить();
	Для Каждого Предшественник Из ОбъектXDTO.predecessors Цикл
		НоваяСтрока = ПредшественникиЭтапов.Добавить();
		НоваяСтрока.ИдентификаторПоследователя = Предшественник.followerID;
		Если Предшественник.Установлено("predecessorID") Тогда
			НоваяСтрока.ИдентификаторПредшественника = Предшественник.predecessorID;
		КонецЕсли;
		ИнтеграцияС1СДокументооборотБазоваяФункциональность.ЗаполнитьОбъектныйРеквизит(
			НоваяСтрока, Предшественник.passageCondition, "УсловиеПерехода");
		ИнтеграцияС1СДокументооборотБазоваяФункциональность.ЗаполнитьОбъектныйРеквизит(
			НоваяСтрока, Предшественник.considerationCondition, "УсловиеРассмотрения");
		НоваяСтрока.УсловныйПереходБылВыполнен = Предшественник.passageExecuted;
	КонецЦикла;
	
	// Возможно, изменение процесса запрещено его шаблоном.
	ЗапрещеноИзменение = Ложь;
	Если ОбъектXDTO.Свойства().Получить("blockedByTemplate") <> Неопределено Тогда
		ЗапрещеноИзменение = ОбъектXDTO.blockedByTemplate;
	КонецЕсли;
	Элементы.Контролер.ТолькоПросмотр = Элементы.Контролер.ТолькоПросмотр
		Или (ЗначениеЗаполнено(КонтролерID) И ЗапрещеноИзменение);
	Элементы.СрокДата.ТолькоПросмотр = Элементы.СрокДата.ТолькоПросмотр
		Или (ЗначениеЗаполнено(Срок) И ЗапрещеноИзменение);
	Если Этапы.Количество() > 0 И ЗапрещеноИзменение Тогда
		Элементы.Этапы.ТолькоПросмотр = Истина;
		Элементы.ПорядокВыполненияПереключатель.Доступность = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ДополнитьИмяШаблонаПоТипуШаблона(СтрокаЭтапа)
	
	Дополнение = "";
	Если СтрокаЭтапа.ШаблонБизнесПроцессаТип = "DMBusinessProcessOrderTemplate"	Тогда Дополнение = НСтр("ru = 'Поручение';
																											|en = 'Instruction'");
	ИначеЕсли СтрокаЭтапа.ШаблонБизнесПроцессаТип = "DMBusinessProcessConsiderationTemplate" Тогда Дополнение = НСтр("ru = 'Рассмотрение';
																													|en = 'Review'");
	ИначеЕсли СтрокаЭтапа.ШаблонБизнесПроцессаТип = "DMBusinessProcessRegistrationTemplate" Тогда Дополнение = НСтр("ru = 'Регистрация';
																													|en = 'Registration'");
	ИначеЕсли СтрокаЭтапа.ШаблонБизнесПроцессаТип = "DMBusinessProcessApprovalTemplate" 	Тогда Дополнение = НСтр("ru = 'Согласование';
																													|en = 'Approval'");
	ИначеЕсли СтрокаЭтапа.ШаблонБизнесПроцессаТип = "DMBusinessProcessConfirmationTemplate" Тогда Дополнение = НСтр("ru = 'Утверждение';
																													|en = 'Confirmation'");
	ИначеЕсли СтрокаЭтапа.ШаблонБизнесПроцессаТип = "DMBusinessProcessPerformanceTemplate" 	Тогда Дополнение = НСтр("ru = 'Исполнение';
																														|en = 'Execution'");
	ИначеЕсли СтрокаЭтапа.ШаблонБизнесПроцессаТип = "DMBusinessProcessAcquaintanceTemplate" Тогда Дополнение = НСтр("ru = 'Ознакомление';
																													|en = 'Preview'");
	ИначеЕсли СтрокаЭтапа.ШаблонБизнесПроцессаТип = "DMCompoundBusinessProcessTemplate" 	Тогда Дополнение = НСтр("ru = 'Составной процесс';
																													|en = 'Multiple process'");
	ИначеЕсли СтрокаЭтапа.ШаблонБизнесПроцессаТип = "DMComplexBusinessProcessTemplate" 		Тогда Дополнение = НСтр("ru = 'Комплексный процесс';
																														|en = 'Complex process'");
	КонецЕсли;
	Если Не ПустаяСтрока(Дополнение) Тогда
		СтрокаЭтапа.ШаблонБизнесПроцесса = Дополнение + ": " + СтрокаЭтапа.ШаблонБизнесПроцесса;
	КонецЕсли;
		
КонецПроцедуры

&НаСервере
Процедура ОбработатьВыборПорядкаВыполнения()
	
	Если ПорядокВыполненияID <> "Смешанно" Тогда //@NON-NLS-1
		Элементы.ЭтапыПредшественникиЭтапаСтрокой.Видимость = Ложь;
	Иначе
		Элементы.ЭтапыПредшественникиЭтапаСтрокой.Видимость = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьСсылкуБизнесПроцесса(ОбъектXDTO)
	
	ID = ОбъектXDTO.objectID.ID;
	Если ОбъектXDTO.objectID.Свойства().Получить("presentation") <> Неопределено Тогда
		Представление = ОбъектXDTO.objectID.presentation;
	Иначе
		Представление = ОбъектXDTO.name;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция СоздатьОбъект(Прокси, Тип)
	
	Возврат ИнтеграцияС1СДокументооборотБазоваяФункциональность.СоздатьОбъект(Прокси, Тип);
	
КонецФункции

&НаСервере
Функция ПодготовитьКПередачеИЗаписатьБизнесПроцесс()
	
	Прокси = ИнтеграцияС1СДокументооборотБазоваяФункциональностьПовтИсп.ПолучитьПрокси();
	ОбъектXDTO = ПодготовитьБизнесПроцесс(Прокси);
	Если ЗначениеЗаполнено(ID) Тогда
		РезультатЗаписи = ИнтеграцияС1СДокументооборотБазоваяФункциональность.ЗаписатьОбъект(Прокси, ОбъектXDTO);
	Иначе
		РезультатСоздания = ИнтеграцияС1СДокументооборотБазоваяФункциональность.СоздатьНовыйОбъект(Прокси, ОбъектXDTO);
	КонецЕсли;
	
	Результат = ?(РезультатСоздания = Неопределено, РезультатЗаписи, РезультатСоздания);
	ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПроверитьВозвратВебСервиса(Прокси, Результат);
	
	Если РезультатЗаписи <> Неопределено Тогда // Запрос на запись возвращает список.
		ОбъектXDTO = Результат.objects[0];
		УстановитьСсылкуБизнесПроцесса(ОбъектXDTO);
		Обработки.ИнтеграцияС1СДокументооборот.ЗаполнитьПредметыВФорме(ЭтотОбъект, ОбъектXDTO);
	Иначе // Запрос на создание возвращает сам объект.
		ОбъектXDTO = Результат.object;
		УстановитьСсылкуБизнесПроцесса(ОбъектXDTO);
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

&НаСервере
Функция ПодготовитьКПередачеИСтартоватьБизнесПроцесс()
	
	Прокси = ИнтеграцияС1СДокументооборотБазоваяФункциональностьПовтИсп.ПолучитьПрокси();
	ОбъектXDTO = ПодготовитьБизнесПроцесс(Прокси);
	
	РезультатЗапуска = ИнтеграцияС1СДокументооборот.ЗапуститьБизнесПроцесс(Прокси, ОбъектXDTO);
	ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПроверитьВозвратВебСервиса(Прокси, РезультатЗапуска);
	
	УстановитьСсылкуБизнесПроцесса(РезультатЗапуска.businessProcess);
	
	Возврат Истина;
	
КонецФункции

&НаСервере
Функция ПодготовитьБизнесПроцесс(Прокси)
	
	ОбъектXDTO = Обработки.ИнтеграцияС1СДокументооборот.ПодготовитьШапкуБизнесПроцесса(
		Прокси, "DMComplexBusinessProcess", ЭтотОбъект);
	ЭтапыБизнесПроцесса = ОбъектXDTO.stages; //СписокXDTO
	ПредшественникиЭтаповБизнесПроцесса = ОбъектXDTO.predecessors; //СписокXDTO
	
	// Контролер.
	ДанныеКонтролер = ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиентСервер.ДанныеСсылочногоОбъектаДО(
		КонтролерID,
		КонтролерТип,
		Контролер);
	ДанныеОсновнойОбъектАдресацииКонтролера =
		ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиентСервер.ДанныеСсылочногоОбъектаДО(
			ОсновнойОбъектАдресацииКонтролераID,
			ОсновнойОбъектАдресацииКонтролераТип,
			ОсновнойОбъектАдресацииКонтролера);
	ДанныеДополнительныйОбъектАдресацииКонтролера =
		ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиентСервер.ДанныеСсылочногоОбъектаДО(
			ДополнительныйОбъектАдресацииКонтролераID,
			ДополнительныйОбъектАдресацииКонтролераТип,
			ДополнительныйОбъектАдресацииКонтролера);
	
	ОбъектXDTO.controller = ИнтеграцияС1СДокументооборот.УчастникЗадач(
		Прокси,
		ДанныеКонтролер,
		ДанныеОсновнойОбъектАдресацииКонтролера,
		ДанныеДополнительныйОбъектАдресацииКонтролера);
	
	ИнтеграцияС1СДокументооборотБазоваяФункциональность.ЗаполнитьОбъектXDTOИзОбъектногоРеквизита(
		Прокси,
		ЭтотОбъект,
		"ПорядокВыполнения",
		ОбъектXDTO.routingType,
		"DMBusinessProcessRoutingType");
	
	ИнтеграцияС1СДокументооборотБазоваяФункциональность.ЗаполнитьОбъектXDTOИзОбъектногоРеквизита(
		Прокси,
		ЭтотОбъект,
		"Шаблон",
		ОбъектXDTO.businessProcessTemplate,
		ШаблонТип);
	
	Для Каждого Этап Из Этапы Цикл
		ЭтапXDTO = СоздатьОбъект(Прокси, "DMComplexBusinessProcessStage");
		ЭтапXDTO.stageID = Строка(Этап.ИдентификаторЭтапа);
		ЭтапXDTO.participants = Этап.ИсполнителиЭтапаСтрокой;
		ЭтапXDTO.stagePredecessors = Этап.ПредшественникиЭтапаСтрокой;
		ЭтапXDTO.executed = Этап.ЗадачаВыполнена;
		Если ЗначениеЗаполнено(Этап.ЗапущенныйБизнесПроцессID) Тогда
			ЭтапXDTO.businessProcess = ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПолучитьОбъект(
				Прокси,
				Этап.ЗапущенныйБизнесПроцессТип,
				Этап.ЗапущенныйБизнесПроцессID);
		КонецЕсли;
		ЭтапXDTO.predecessorsUseOption = Этап.ПредшественникиВариантИспользования;
		ЭтапXDTO.unconditionalPassageExecuted = Этап.БезусловныйПереходКСледующемуБылВыполнен;
		
		Если Этап.Важность = 0 Тогда
			ВажностьЭтапа = НСтр("ru = 'Низкая важность';
								|en = 'Low importance'");
			ВажностьЭтапаID = "Низкая"; //@NON-NLS-1
		ИначеЕсли Этап.Важность = 1 Тогда
			ВажностьЭтапа = НСтр("ru = 'Обычная важность';
								|en = 'Normal importance'");
			ВажностьЭтапаID = "Обычная"; //@NON-NLS-1
		ИначеЕсли Этап.Важность = 2 Тогда
			ВажностьЭтапа = НСтр("ru = 'Высокая важность';
								|en = 'High importance'");
			ВажностьЭтапаID = "Высокая"; //@NON-NLS-1
		КонецЕсли;
		Если ИнтеграцияС1СДокументооборотБазоваяФункциональность.СвойствоСуществует(ЭтапXDTO, "importance") Тогда
			ЭтапXDTO.importance = ИнтеграцияС1СДокументооборотБазоваяФункциональность.СоздатьОбъект(Прокси, "DMBusinessProcessImportance");
			ЭтапXDTO.importance.name = ВажностьЭтапа;
			ЭтапXDTO.importance.objectID = ИнтеграцияС1СДокументооборотБазоваяФункциональность.СоздатьObjectID(
				Прокси,
				ВажностьЭтапаID,
				"DMBusinessProcessImportance");
		КонецЕсли;
		
		ИнтеграцияС1СДокументооборотБазоваяФункциональность.ЗаполнитьОбъектXDTOИзОбъектногоРеквизита(
			Прокси,
			Этап,
			"ШаблонБизнесПроцесса",
			ЭтапXDTO.template,
			"DMObject");
		
		ЭтапыБизнесПроцесса.Добавить(ЭтапXDTO);
	КонецЦикла;
	
	Для Каждого Предшественник Из ПредшественникиЭтапов Цикл
		
		ПредшественникXDTO = СоздатьОбъект(Прокси, "DMComplexBusinessProcessStagePredecessor");
		ПредшественникXDTO.followerID = Предшественник.ИдентификаторПоследователя;
		ПредшественникXDTO.passageExecuted = Предшественник.УсловныйПереходБылВыполнен;
		
		Если ЗначениеЗаполнено(Предшественник.ИдентификаторПредшественника) Тогда
			ПредшественникXDTO.predecessorID = Предшественник.ИдентификаторПредшественника;
		КонецЕсли;
		
		ИнтеграцияС1СДокументооборотБазоваяФункциональность.ЗаполнитьОбъектXDTOИзОбъектногоРеквизита(
			Прокси,
			Предшественник,
			"УсловиеПерехода",
			ПредшественникXDTO.passageCondition,
			"DMRoutingCondition");
		
		ИнтеграцияС1СДокументооборотБазоваяФункциональность.ЗаполнитьОбъектXDTOИзОбъектногоРеквизита(
			Прокси,
			Предшественник,
			"УсловиеРассмотрения",
			ПредшественникXDTO.considerationCondition,
			"DMPredecessorsStageConsiderationCondition");
		
		ПредшественникиЭтаповБизнесПроцесса.Добавить(ПредшественникXDTO);
	КонецЦикла;
	
	Возврат ОбъектXDTO;
	
КонецФункции

&НаКлиенте
Функция ЗаписатьОбъект() Экспорт
	
	ПодготовитьКПередачеИЗаписатьБизнесПроцесс();
	ИнтеграцияС1СДокументооборотКлиент.Оповестить_ЗаписьБизнесПроцесса(ЭтотОбъект, Ложь);
	Модифицированность = Ложь;
	
	Возврат Истина;
	
КонецФункции

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(Ответ, ПараметрыОповещения) Экспорт
	
	ЗаписатьОбъект();
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПрограммноДобавленнуюКоманду(Команда)
	
	// Вызовем обработчик команды, которая добавлена программно при создании формы на сервере.
	ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиентПереопределяемый.ВыполнитьПрограммноДобавленнуюКоманду(Команда, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьПредметОсновной(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ДобавитьПредметЗавершение", ЭтотОбъект);
	ИнтеграцияС1СДокументооборотКлиент.ДобавитьПредмет(ЭтотОбъект, "Основной", ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьПредметВспомогательный(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ДобавитьПредметЗавершение", ЭтотОбъект);
	ИнтеграцияС1СДокументооборотКлиент.ДобавитьПредмет(ЭтотОбъект, "Вспомогательный", ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьПредмет(Команда)
	
	ОткрытьПредмет();
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьПредмет(Команда)
	
	ТекущиеДанные = Элементы.Предметы.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		Предметы.Удалить(ТекущиеДанные);
		Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПредметыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОткрытьПредмет();
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьПредметЗавершение(ДобавленныеПредметы, ПараметрыОбработчика) Экспорт
	
	Если ДобавленныеПредметы = Неопределено Или ДобавленныеПредметы.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого ОписаниеПредмета Из ДобавленныеПредметы Цикл
		СтрокаПредмета = Предметы.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаПредмета, ОписаниеПредмета);
		СтрокаПредмета.Картинка = ИнтеграцияС1СДокументооборотКлиентСервер.НомерКартинкиПоРолиПредмета(
			СтрокаПредмета.РольПредмета);
	КонецЦикла;
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПредмет()
	
	ТекущиеДанные = Элементы.Предметы.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ТекущиеДанные.Ссылка) Тогда
		ПоказатьЗначение(, ТекущиеДанные.Ссылка);
		
	Иначе
		ПараметрыОповещения = Новый Структура;
		ПараметрыОповещения.Вставить("ИдентификаторСтроки", ТекущиеДанные.ПолучитьИдентификатор());
		ПараметрыОповещения.Вставить("Предмет", ТекущиеДанные.Предмет);
		ПараметрыОповещения.Вставить("ПредметID", ТекущиеДанные.ПредметID);
		ПараметрыОповещения.Вставить("ПредметТип", ТекущиеДанные.ПредметТип);
		ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ОткрытьОбъект(ТекущиеДанные.ПредметТип, ТекущиеДанные.ПредметID);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПеречитатьПроцесс()
	
	ПараметрыПолучения = Новый Структура("ID, type", ID, Тип);
	ОбъектXDTO = ИнтеграцияС1СДокументооборот.ПолучитьОбъектXDTOПроцесса(Тип, ПараметрыПолучения);
	ЗаполнитьФормуИзОбъектаXDTO(ОбъектXDTO);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьВажностьЭтапов()
	
	Если ВажностьID = "Низкая" Тогда //@NON-NLS-1
		НовоеЗначение = 0;
	ИначеЕсли ВажностьID = "Обычная" Тогда //@NON-NLS-1
		НовоеЗначение = 1;
	ИначеЕсли ВажностьID = "Высокая" Тогда //@NON-NLS-1
		НовоеЗначение = 2;
	КонецЕсли;
	
	Для Каждого Этап Из Этапы Цикл
		Этап.Важность = НовоеЗначение;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти