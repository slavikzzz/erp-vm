#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ДоступнаМультипредметность = ИнтеграцияС1СДокументооборотБазоваяФункциональностьПовтИсп.ДоступенФункционалВерсииСервиса("2.0.3.1");
	Элементы.СтраницыМультипредметность.ТекущаяСтраница = ?(ДоступнаМультипредметность,
		Элементы.СтраницаДоступнаМультипредметность,
		Элементы.СтраницаНедоступнаМультипредметность);
	
	ТипПроцессаXDTO = "DMBusinessProcessApproval";
	ОбъектXDTO = ИнтеграцияС1СДокументооборот.ПолучитьОбъектXDTOПроцесса(ТипПроцессаXDTO, Параметры);
	ЗаполнитьФормуИзОбъектаXDTO(ОбъектXDTO);
	
	Если Параметры.Свойство("Шаблон") Тогда
		ШаблонID = Параметры.Шаблон.ID;
		ШаблонТип = Параметры.Шаблон.type;
	КонецЕсли;
	
	Если Параметры.Свойство("taskID") Тогда
		Заголовок = НСтр("ru = 'Повтор согласования';
						|en = 'Repeat approval  '");
		ПоложениеКоманднойПанели = ПоложениеКоманднойПанелиФормы.Нет;
		ТолькоПросмотр = Ложь;
		Элементы.ГруппаПовторСогласования.Видимость = Истина;
		Элементы.Комментарий.Видимость = Истина;
		Элементы.ОК.КнопкаПоУмолчанию = Истина;
		Элементы.ГруппаИнфо.Видимость = Ложь;
		Элементы.ГлавнаяЗадачаПредставление.Видимость = Ложь;
		Элементы.ГруппаНаименование.Видимость = Ложь;
		Элементы.СтраницыМультипредметность.Видимость = Ложь;
		Элементы.СрокИсполненияДней.ТолькоПросмотр = Ложь;
		Элементы.СрокИсполненияЧасов.ТолькоПросмотр = Ложь;
		Элементы.АвторПредставление.Видимость = Ложь;
	КонецЕсли;
	
	Элементы.ВариантСогласованияПредставление.ТолькоПросмотр = ТолькоПросмотр;
	
	ИнтеграцияС1СДокументооборотБазоваяФункциональностьПереопределяемый.ДополнительнаяОбработкаФормыБизнесПроцесса(
		ЭтотОбъект,
		Отказ,
		СтандартнаяОбработка);
	
	Элементы.ВариантСогласованияПредставление.СписокВыбора.Очистить();
	Элементы.ВариантСогласованияПредставление.СписокВыбора.Добавить("Параллельно", НСтр("ru = 'Всем сразу';
																						|en = 'To all at once'")); //@NON-NLS-1
	Элементы.ВариантСогласованияПредставление.СписокВыбора.Добавить("Последовательно", НСтр("ru = 'По очереди';
																							|en = 'In sequence'")); //@NON-NLS-1
	Элементы.ВариантСогласованияПредставление.СписокВыбора.Добавить("Смешанно", НСтр("ru = 'Смешанно';
																					|en = 'Mixed'")); //@NON-NLS-1
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ЗаполнитьШаг(Исполнители);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если Модифицированность Тогда
		Оповещение = Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект);
		ТекстПредупреждения = "";
		ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(
			Оповещение,
			Отказ,
			ЗавершениеРаботы,,
			ТекстПредупреждения);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Изменен" И Параметр = Элементы.ПредметПредставление Тогда
		Предмет = Источник.Представление;
	ИначеЕсли ИмяСобытия = "Документооборот_ВыбратьЗначениеИзВыпадающегоСпискаЗавершение" И Источник = ЭтотОбъект Тогда
		Если Параметр.Реквизит = "ПорядокСогласования" Тогда
			ЗаполнитьШаг(Исполнители);
		КонецЕсли;
	ИначеЕсли ИмяСобытия = "Запись_ДокументооборотБизнесПроцесс" Тогда
		Если Параметр.ID = ID Тогда
			ПеречитатьПроцесс();
		КонецЕсли;
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
Процедура ВариантСогласованияПредставлениеПриИзменении(Элемент)
	
	Если ВариантСогласованияID <> "Смешанно" Тогда //@NON-NLS-1
		Элементы.ИсполнителиШаг.Видимость = Ложь;
		Элементы.ИсполнителиПорядокСогласования.Видимость = Ложь;
	Иначе
		Элементы.ИсполнителиШаг.Видимость = Истина;
		Элементы.ИсполнителиПорядокСогласования.Видимость = Истина;
		ЗаполнитьШаг(Исполнители);
	КонецЕсли;
	
	Если ВариантСогласованияID <> "Параллельно" Тогда //@NON-NLS-1
		Элементы.ИсполнителиГруппаПеремещение.Видимость = Истина;
	Иначе
		Элементы.ИсполнителиГруппаПеремещение.Видимость = Ложь;
	КонецЕсли;
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура УчастникБизнесПроцессаАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание,
		СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		ИнтеграцияС1СДокументооборотБазоваяФункциональностьВызовСервера.ДанныеДляАвтоПодбора(
			"DMUser;DMBusinessProcessExecutorRole",
			ДанныеВыбора,
			Текст,
			СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УчастникБизнесПроцессаОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных,
		СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		
		ИнтеграцияС1СДокументооборотБазоваяФункциональностьВызовСервера.ДанныеДляАвтоПодбора(
			"DMUser;DMBusinessProcessExecutorRole",
			ДанныеВыбора,
			Текст,
			СтандартнаяОбработка);
		Если ДанныеВыбора.Количество() = 1 Тогда
			ИнтеграцияС1СДокументооборотКлиент.ПрименитьВыборУчастникаБизнесПроцессаВСписке(
				Элемент.Родитель.Родитель,
				ДанныеВыбора[0].Значение,
				СтандартнаяОбработка, ЭтотОбъект);
			СтандартнаяОбработка = Истина;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УчастникБизнесПроцессаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ИнтеграцияС1СДокументооборотКлиент.ПрименитьВыборУчастникаБизнесПроцессаВСписке(
		Элемент.Родитель.Родитель, ВыбранноеЗначение, СтандартнаяОбработка, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ВажностьНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияС1СДокументооборотКлиент.ВыбратьЗначениеИзВыпадающегоСписка(
		"DMBusinessProcessImportance", "Важность", ЭтотОбъект);
	
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
		"Важность", ВыбранноеЗначение, СтандартнаяОбработка, ЭтотОбъект);
	
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
				"Автор", ДанныеВыбора[0].Значение, СтандартнаяОбработка, ЭтотОбъект);
			СтандартнаяОбработка = Истина;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура АвторОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ОбработкаВыбораДанныхДляАвтоПодбора(
		"Автор", ВыбранноеЗначение, СтандартнаяОбработка, ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыИсполнители

&НаКлиенте
Процедура ИсполнителиИсполнительНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Оповещение = Новый ОписаниеОповещения("ИсполнителиИсполнительНачалоВыбораЗавершение", ЭтотОбъект);
	
	ОткрытьФорму("Обработка.ИнтеграцияС1СДокументооборот.Форма.ВыборИсполнителяБизнесПроцесса",,
		ЭтотОбъект,,,, Оповещение, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнителиИсполнительНачалоВыбораЗавершение(Результат, ПараметрыОповещения) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элементы.Исполнители.ТекущиеДанные;
	
	Результат.Свойство("Исполнитель", ТекущиеДанные.Исполнитель);
	Результат.Свойство("ИсполнительID", ТекущиеДанные.ИсполнительID);
	Результат.Свойство("ИсполнительТип", ТекущиеДанные.ИсполнительТип);
	
	Результат.Свойство("ОсновнойОбъектАдресации", ТекущиеДанные.ОсновнойОбъектАдресации);
	Результат.Свойство("ОсновнойОбъектАдресацииID", ТекущиеДанные.ОсновнойОбъектАдресацииID);
	Результат.Свойство("ОсновнойОбъектАдресацииТип", ТекущиеДанные.ОсновнойОбъектАдресацииТип);
	
	Результат.Свойство("ДополнительныйОбъектАдресации", ТекущиеДанные.ДополнительныйОбъектАдресации);
	Результат.Свойство("ДополнительныйОбъектАдресацииID", ТекущиеДанные.ДополнительныйОбъектАдресацииID);
	Результат.Свойство("ДополнительныйОбъектАдресацииТип", ТекущиеДанные.ДополнительныйОбъектАдресацииТип);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнителиПорядокСогласованияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияС1СДокументооборотКлиент.ВыбратьЗначениеИзВыпадающегоСписка(
		"DMApprovalOrder", "ПорядокСогласования", ЭтотОбъект,, Истина, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнителиПорядокСогласованияАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		ИнтеграцияС1СДокументооборотБазоваяФункциональностьВызовСервера.ДанныеДляАвтоПодбора(
			"DMApprovalOrder",
			ДанныеВыбора,
			Текст,
			СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнителиПорядокСогласованияОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		ИнтеграцияС1СДокументооборотБазоваяФункциональностьВызовСервера.ДанныеДляАвтоПодбора("DMApprovalOrder", ДанныеВыбора, Текст, СтандартнаяОбработка);
		
		Если ДанныеВыбора.Количество() = 1 Тогда
			ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ОбработкаВыбораДанныхДляАвтоПодбора(
				"ПорядокСогласования", ДанныеВыбора[0].Значение, СтандартнаяОбработка, ЭтотОбъект, Истина, Элемент);
			ЗаполнитьШаг(Исполнители);
			СтандартнаяОбработка = Истина;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнителиПорядокСогласованияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ОбработкаВыбораДанныхДляАвтоПодбора(
		"ПорядокСогласования", ВыбранноеЗначение, СтандартнаяОбработка, ЭтотОбъект, Истина, Элемент);
	ЗаполнитьШаг(Исполнители);
	
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
		
		// Универсальное оповещение.
		ИнтеграцияС1СДокументооборотКлиент.Оповестить_ЗаписьБизнесПроцесса(ЭтотОбъект, Истина);
		// Оповещение пользователя.
		ТекстСостояния = НСтр("ru = 'Бизнес-процесс ""%Наименование%"" успешно запущен.';
								|en = 'The ""%Наименование%"" business process is started successfully.'");
		ТекстСостояния = СтрЗаменить(ТекстСостояния,"%Наименование%", Представление);
		Состояние(ТекстСостояния);
		
		Модифицированность = Ложь;
		Если Открыта() Тогда
			Закрыть(Истина);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоШаблону(Команда)
	
	Оповещение = Новый ОписаниеОповещения("ЗаполнитьПоШаблонуЗавершение", ЭтотОбъект);
	ИнтеграцияС1СДокументооборотКлиент.НачатьВыборШаблонаБизнесПроцесса(Оповещение, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть(Новый Структура("Успешно, Комментарий", Ложь, Комментарий));
	
КонецПроцедуры

&НаКлиенте
Процедура ОК(Команда)
	
	Если Не ЗначениеЗаполнено(Комментарий) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(
			НСтр("ru = 'Не заполнен комментарий';
				|en = 'Comment is not filled in'"),,
			"Комментарий");
		Возврат;
	КонецЕсли;
	
	Если ПодготовитьКПередачеИЗаписатьБизнесПроцесс() Тогда
		Модифицированность = Ложь;
		Закрыть(Новый Структура("Успешно, Комментарий", Истина, Комментарий));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПереместитьВниз(Команда)
	
	ИндексТекущегоЭлементаКоллекции = Исполнители.Индекс(
		Элементы.Исполнители.ТекущиеДанные);
	КоличествоЭлементовКоллекции = Исполнители.Количество();
	Если ИндексТекущегоЭлементаКоллекции < КоличествоЭлементовКоллекции - 1 Тогда
		Исполнители.Сдвинуть(ИндексТекущегоЭлементаКоллекции, 1);
	КонецЕсли;
	ЗаполнитьШаг(Исполнители);
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ПереместитьВверх(Команда)
	ИндексТекущегоЭлементаКоллекции = Исполнители.Индекс(
		Элементы.Исполнители.ТекущиеДанные);
	Если ИндексТекущегоЭлементаКоллекции > 0 Тогда
		Исполнители.Сдвинуть(ИндексТекущегоЭлементаКоллекции, -1);
	КонецЕсли;
	Модифицированность = Истина;
	ЗаполнитьШаг(Исполнители);
	
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
Процедура ЗаполнитьКарточкуПоШаблону(ДанныеШаблона)
	
	РезультатЗаполнения = ИнтеграцияС1СДокументооборотВызовСервера.ЗаполнитьБизнесПроцессПоШаблону(
		ЭтотОбъект, ДанныеШаблона);
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
	
	ИнтеграцияС1СДокументооборотБазоваяФункциональность.ЗаполнитьОбъектныйРеквизит(
		ЭтотОбъект, ОбъектXDTO.approvalType, "ВариантСогласования");
	
	Исполнители.Очистить();
	Для Каждого Исполнитель Из ОбъектXDTO.Performers Цикл
		НоваяСтрока = Исполнители.Добавить();
		Обработки.ИнтеграцияС1СДокументооборот.ЗаполнитьИсполнителяВФорме(НоваяСтрока, Исполнитель);
		ИнтеграцияС1СДокументооборотБазоваяФункциональность.ЗаполнитьОбъектныйРеквизит(
			НоваяСтрока, Исполнитель.approvalOrder, "ПорядокСогласования")
	КонецЦикла;
	
	Если ВариантСогласованияID <> "Смешанно" Тогда //@NON-NLS-1
		Элементы.ИсполнителиШаг.Видимость = Ложь;
		Элементы.ИсполнителиПорядокСогласования.Видимость = Ложь;
	Иначе
		Элементы.ИсполнителиШаг.Видимость = Истина;
		Элементы.ИсполнителиПорядокСогласования.Видимость = Истина;
	КонецЕсли;
	
	Если ВариантСогласованияID <> "Параллельно" Тогда //@NON-NLS-1
		Элементы.ИсполнителиГруппаПеремещение.Видимость = Истина;
	Иначе
		Элементы.ИсполнителиГруппаПеремещение.Видимость = Ложь;
	КонецЕсли;
	
	СрокИсполненияДней = ОбъектXDTO.durationDays;
	СрокИсполненияЧасов = ОбъектXDTO.durationHours;
	
	// Возможно, изменение процесса запрещено его шаблоном.
	ЗапрещеноИзменение = Ложь;
	Если ОбъектXDTO.Свойства().Получить("blockedByTemplate") <> Неопределено Тогда
		ЗапрещеноИзменение = ОбъектXDTO.blockedByTemplate;
	КонецЕсли;
	Элементы.СрокИсполненияДней.ТолькоПросмотр = Элементы.СрокИсполненияДней.ТолькоПросмотр
		Или (ЗначениеЗаполнено(СрокИсполненияДней) И ЗапрещеноИзменение);
	Элементы.СрокИсполненияЧасов.ТолькоПросмотр = Элементы.СрокИсполненияЧасов.ТолькоПросмотр
		Или (ЗначениеЗаполнено(СрокИсполненияЧасов) И ЗапрещеноИзменение);
	Если Исполнители.Количество() > 0 И ЗапрещеноИзменение Тогда
		Элементы.Исполнители.ТолькоПросмотр = Истина;
		Элементы.ИсполнителиПереместитьВверх.Доступность = Ложь;
		Элементы.ИсполнителиПереместитьВниз.Доступность = Ложь;
		Элементы.ВариантСогласованияПредставление.Доступность = Ложь;
	КонецЕсли;
	
КонецПроцедуры

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
		Прокси,
		"DMBusinessProcessApproval",
		ЭтотОбъект,
		"Срок");
	ИсполнителиПроцесса = ОбъектXDTO.performers; // СписокXDTO
	
	// Специфика Согласования
	ОбъектXDTO.durationDays = СрокИсполненияДней;
	ОбъектXDTO.durationHours = СрокИсполненияЧасов;
	
	ИнтеграцияС1СДокументооборотБазоваяФункциональность.ЗаполнитьОбъектXDTOИзОбъектногоРеквизита(
		Прокси,
		ЭтотОбъект,
		"ВариантСогласования",
		ОбъектXDTO.approvalType,
		"DMApprovalType");
	
	Для Каждого Строка Из Исполнители Цикл
		
		ДанныеИсполнитель = ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиентСервер.ДанныеСсылочногоОбъектаДО(
			Строка.ИсполнительID,
			Строка.ИсполнительТип,
			Строка.Исполнитель);
		ДанныеОсновнойОбъект = ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиентСервер.ДанныеСсылочногоОбъектаДО(
			Строка.ОсновнойОбъектАдресацииID,
			Строка.ОсновнойОбъектАдресацииТип,
			Строка.ОсновнойОбъектАдресации);
		ДанныеДополнительныйОбъект = ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиентСервер.ДанныеСсылочногоОбъектаДО(
			Строка.ДополнительныйОбъектАдресацииID,
			Строка.ДополнительныйОбъектАдресацииТип,
			Строка.ДополнительныйОбъектАдресации);
		
		Исполнитель = ИнтеграцияС1СДокументооборот.УчастникПроцессаСогласование(
			Прокси,
			ДанныеИсполнитель,
			ДанныеОсновнойОбъект,
			ДанныеДополнительныйОбъект);
		
		ИсполнителиПроцесса.Добавить(Исполнитель);
		
		ИнтеграцияС1СДокументооборотБазоваяФункциональность.ЗаполнитьОбъектXDTOИзОбъектногоРеквизита(
			Прокси,
			Строка,
			"ПорядокСогласования",
			Исполнитель.approvalOrder,
			"DMApprovalOrder",
			Истина);
		
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
Процедура ЗаполнитьШаг(Таблица)
	
	Для Каждого Строка Из Таблица Цикл
		Строка.Шаг = 0;
	КонецЦикла;
	
	КоличествоСтрок = Таблица.Количество();
	Для Инд = 0 По КоличествоСтрок - 1 Цикл
		
		Строка = Таблица[Инд];
		Если Не ЗначениеЗаполнено(Строка.ПорядокСогласованияID) Тогда
			Прервать;
		КонецЕсли;
		
		Если Инд = 0 Тогда
			Строка.Шаг = 1;
			Продолжить;
		КонецЕсли;
		
		ПредыдущаяСтрока = Таблица[Инд-1];
		Если Строка.ПорядокСогласованияID = "ВместеСПредыдущим" Тогда //@NON-NLS-1
			Строка.Шаг = ПредыдущаяСтрока.Шаг;
		ИначеЕсли Строка.ПорядокСогласованияID = "ПослеПредыдущего" Тогда //@NON-NLS-1
			Строка.Шаг = ПредыдущаяСтрока.Шаг + 1;
		КонецЕсли;
		
	КонецЦикла;
	
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
	ИнтеграцияС1СДокументооборотКлиент.ДобавитьПредмет(
		ЭтотОбъект, "Основной", ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьПредметВспомогательный(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ДобавитьПредметЗавершение", ЭтотОбъект);
	ИнтеграцияС1СДокументооборотКлиент.ДобавитьПредмет(
		ЭтотОбъект, "Вспомогательный", ОписаниеОповещения);
	
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
		ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ОткрытьОбъект(
			ТекущиеДанные.ПредметТип, ТекущиеДанные.ПредметID);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПеречитатьПроцесс()
	
	ПараметрыПолучения = Новый Структура("ID, type", ID, Тип);
	ОбъектXDTO = ИнтеграцияС1СДокументооборот.ПолучитьОбъектXDTOПроцесса(Тип, ПараметрыПолучения);
	ЗаполнитьФормуИзОбъектаXDTO(ОбъектXDTO);
	
КонецПроцедуры

#КонецОбласти