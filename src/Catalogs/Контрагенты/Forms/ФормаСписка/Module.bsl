
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ПартнерыИКонтрагентыЛокализация.УстановитьСвойстваДинамическогоСпискаКонтрагенты(ЭтаФорма);
		
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
		Список,
		"ПредставлениеОбособленногоПодразделения",
		НСтр("ru = 'Обособленное подразделение';
			|en = 'Branch office'"));
	
	ИспользоватьПартнеровКакКонтрагентов = ПолучитьФункциональнуюОпцию("ИспользоватьПартнеровКакКонтрагентов");
	ДоступноДобавлениеПартнеров = ПравоДоступа("Добавление", Метаданные.Справочники.Партнеры);
	
	Если ИспользоватьПартнеровКакКонтрагентов Тогда
		ТолькоПросмотр = Истина;
	КонецЕсли;
	
	МожноРедактировать = ПравоДоступа("Редактирование", Метаданные.Справочники.Контрагенты);
	Элементы.ФормаИзменитьВыделенные.Видимость                 = МожноРедактировать;
	Элементы.СписокКонтекстноеМенюИзменитьВыделенные.Видимость = МожноРедактировать;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПриСозданииНаСервере(ЭтаФорма, Элементы.ГруппаГлобальныеКоманды);
	// Конец ИнтеграцияС1СДокументооборотом
	
	// ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	ПараметрыПриСозданииНаСервере = ОбменСКонтрагентами.ПараметрыПриСозданииНаСервере_ФормаСписка();
	ПараметрыПриСозданииНаСервере.Форма = ЭтотОбъект;
	ПараметрыПриСозданииНаСервере.МестоРазмещенияКоманд = Элементы.КомандыЭДО;
	ОбменСКонтрагентами.ПриСозданииНаСервере_ФормаСписка(ПараметрыПриСозданииНаСервере);
	// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами

	ПартнерыИКонтрагентыЛокализация.ПриСозданииНаСервереФормаСпискаКонтрагент(ЭтаФорма, Отказ, СтандартнаяОбработка);
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	// Команды1СПАРКРиски
	СПАРКРиски.ДобавитьПодключаемыеКомандыКонтрагента(ЭтотОбъект, Список, Элементы.ПодменюСПАРК);
	// Конец Команды1СПАРКРиски
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	// ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	ОбменСКонтрагентамиКлиент.ПриОткрытии(ЭтотОбъект);
	// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	// ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	ПараметрыОповещенияЭДО = ОбменСКонтрагентамиКлиент.ПараметрыОповещенияЭДО_ФормаСписка();
	ПараметрыОповещенияЭДО.Форма = ЭтотОбъект;
	ПараметрыОповещенияЭДО.ИмяДинамическогоСписка = "Список";
	ОбменСКонтрагентамиКлиент.ОбработкаОповещения_ФормаСписка(ИмяСобытия, Параметр, Источник, ПараметрыОповещенияЭДО);
	// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если МожноРедактировать
		И Поле = Элементы.ГоловнойКонтрагент Тогда
		
		ТекущиеДанные = Элемент.ТекущиеДанные;
		Если ТекущиеДанные.ОбособленноеПодразделение И Не ЗначениеЗаполнено(ТекущиеДанные.ГоловнойКонтрагент) Тогда
			
			СтандартнаяОбработка = Ложь;
			
			ПараметрыЗаполнения = Новый Структура;
			ПартнерыИКонтрагентыЛокализацияКлиентСервер.ДополнитьПараметрыЗаполнитьГоловногоКонтрагента(ПараметрыЗаполнения, ТекущиеДанные);
			ПараметрыЗаполнения.Вставить("Контрагент", ТекущиеДанные.Ссылка);
			ПараметрыЗаполнения.Вставить("Партнер",    ТекущиеДанные.Партнер);
			ПараметрыЗаполнения.Вставить("ИспользоватьПартнеровКакКонтрагентов", ИспользоватьПартнеровКакКонтрагентов);
			
			Оповещение = Новый ОписаниеОповещения("ЗаполнитьГоловногоКонтрагентаЗавершение", ЭтотОбъект);
			ПартнерыИКонтрагентыКлиент.ЗаполнитьГоловногоКонтрагента(ЭтотОбъект, ПараметрыЗаполнения, Истина, Оповещение);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	ОбменСКонтрагентамиКлиент.ПриАктивизацииСтроки_ФормаСписка(ЭтотОбъект);
	// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ИзменитьВыделенные(Команда)
	
	ГрупповоеИзменениеОбъектовКлиент.ИзменитьВыделенные(Элементы.Список);
	
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

// ЭлектронноеВзаимодействие.ОбменСКонтрагентами
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуЭДО(Команда)
	
	ЭлектронноеВзаимодействиеКлиент.ВыполнитьПодключаемуюКомандуЭДО(Команда, ЭтотОбъект, Элементы.Список);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбработчикОжиданияЭДО()
	
	ОбменСКонтрагентамиКлиент.ОбработчикОжиданияЭДО(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКомандыЭДО()
	ОбменСКонтрагентамиКлиент.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	ПартнерыИКонтрагенты.УстановитьОформлениеГоловногоКонтрагентаВСписке(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьГоловногоКонтрагентаЗавершение(ВыбранноеЗначение, ДополнительныеПараметры) Экспорт
	
	Если ВыбранноеЗначение <> Неопределено Тогда
		Элементы.Список.Обновить();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Локализация

// ИнтернетПоддержкаПользователей.СПАРКРиски
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду1СПАРКРиски(Команда)
	СПАРКРискиКлиент.ВыполнитьПодключаемуюКоманду(Команда, ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец ИнтернетПоддержкаПользователей.СПАРКРиски

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Элементы.Список);
	
КонецПроцедуры
// Конец ИнтеграцияС1СДокументооборотом

#КонецОбласти