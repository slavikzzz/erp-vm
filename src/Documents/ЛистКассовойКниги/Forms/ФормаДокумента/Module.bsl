
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	ИспользоватьНесколькоКасс = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоКасс");
	ВалютаРеглУчета = ЗначениеНастроекПовтИсп.ВалютаРегламентированногоУчетаОрганизации(Объект.Организация);
	
	ЗаполнитьСписокВыбораКассовыхКниг();
	
	Если ЗначениеЗаполнено(Объект.КассоваяКнига) Тогда
		КассоваяКнигаПредставление = Строка(Объект.КассоваяКнига);
	ИначеЕсли ЗначениеЗаполнено(Объект.Организация) Тогда
		КассоваяКнигаПредставление = НСтр("ru = '<Основная кассовая книга организации>';
											|en = '<Main company cash book>'");
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		РассчитатьОстатокПоРегистрам();
	КонецЕсли;
	
	УправлениеЭлементамиФормы();
	
	// Обработчик механизма "ВерсионированиеОбъектов"
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ИнтеграцияС1СДокументооборотом

	// ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	ПараметрыЭДОПриСоздании = ОбменСКонтрагентами.ПараметрыПриСозданииНаСервере_ФормаДокумента();
	ПараметрыЭДОПриСоздании.Форма = ЭтотОбъект;
	ПараметрыЭДОПриСоздании.ДокументСсылка = Объект.Ссылка;
	ПараметрыЭДОПриСоздании.МестоРазмещенияКоманд = Элементы.ПодменюЭДО;
	ПараметрыЭДОПриСоздании.КонтроллерСостояниеЭДО = Элементы.ДекорацияСостояниеЭДО;
	ПараметрыЭДОПриСоздании.ГруппаСостояниеЭДО = Элементы.ГруппаСостояниеЭДО;
	ОбменСКонтрагентами.ПриСозданииНаСервере_ФормаДокумента(ПараметрыЭДОПриСоздании);
	// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	
	Элементы.ДекорацияСостояниеЭДО.Видимость = ПолучитьФункциональнуюОпцию("ИспользоватьОбменЭД");
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	// ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	ОбменСКонтрагентамиКлиент.ПослеЗаписи_ФормаДокумента(ЭтаФорма, ПараметрыЗаписи);
	// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами

	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульПодключаемыеКомандыКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ПодключаемыеКомандыКлиент");
		МодульПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);
	// Конец ИнтеграцияС1СДокументооборотом
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	ПараметрыОповещения = ОбменСКонтрагентамиКлиент.ПараметрыОповещенияЭДО_ФормаДокумента();
	ПараметрыОповещения.Форма = ЭтотОбъект;
	ПараметрыОповещения.ДокументСсылка = Объект.Ссылка;
	ПараметрыОповещения.КонтроллерСостояниеЭДО = Элементы.ДекорацияСостояниеЭДО;
	ПараметрыОповещения.ГруппаСостояниеЭДО = Элементы.ГруппаСостояниеЭДО;
	ОбменСКонтрагентамиКлиент.ОбработкаОповещения_ФормаДокумента(ИмяСобытия, Параметр, Источник, ПараметрыОповещения);
	// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	МодификацияКонфигурацииПереопределяемый.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	ПараметрыЭДОПриСоздании = ОбменСКонтрагентами.ПараметрыПриЧтенииНаСервере_ФормаДокумента();
	ПараметрыЭДОПриСоздании.Форма = ЭтотОбъект;
	ПараметрыЭДОПриСоздании.ДокументСсылка = Объект.Ссылка;
	ПараметрыЭДОПриСоздании.МестоРазмещенияКоманд = Элементы.ПодменюЭДО;
	ПараметрыЭДОПриСоздании.КонтроллерСостояниеЭДО = Элементы.ДекорацияСостояниеЭДО;
	ПараметрыЭДОПриСоздании.ГруппаСостояниеЭДО = Элементы.ГруппаСостояниеЭДО;
	ОбменСКонтрагентами.ПриЧтенииНаСервере_ФормаДокумента(ПараметрыЭДОПриСоздании);
	// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	ПараметрыПослеЗаписи = ОбменСКонтрагентами.ПараметрыПослеЗаписиНаСервере();
	ПараметрыПослеЗаписи.Форма = ЭтотОбъект;
	ПараметрыПослеЗаписи.ДокументСсылка = Объект.Ссылка;
	ПараметрыПослеЗаписи.КонтроллерСостояниеЭДО = Элементы.ДекорацияСостояниеЭДО;
	ПараметрыПослеЗаписи.ГруппаСостояниеЭДО = Элементы.ГруппаСостояниеЭДО;
	ОбменСКонтрагентами.ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи, ПараметрыПослеЗаписи);
	// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами

	РассчитатьОстатокПоРегистрам();
	УправлениеЭлементамиФормы();
	
	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

	// ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	ОбменСКонтрагентамиКлиент.ПриОткрытии(ЭтотОбъект);
	// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	
	ДатаПриИзмененииСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	Объект.КассовыеОрдера.Очистить();
	
	ОрганизацияПриИзмененииСервер();
	
КонецПроцедуры

&НаСервере
Процедура ОрганизацияПриИзмененииСервер()
	
	ВалютаРеглУчета = ЗначениеНастроекПовтИсп.ВалютаРегламентированногоУчетаОрганизации(Объект.Организация);
	
	ОтветственныеЛицаСервер.ПриИзмененииСвязанныхРеквизитовДокумента(Объект);
	
	Объект.КассоваяКнига = Неопределено;
	КассоваяКнигаПредставление = НСтр("ru = '<Основная кассовая книга организации>';
										|en = '<Main company cash book>'");
	
	ЗаполнитьСписокВыбораКассовыхКниг();
	
КонецПроцедуры

&НаКлиенте
Процедура КассоваяКнигаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Отбор", Новый Структура("Владелец", Объект.Организация));
	
	ОповещениеОЗакрытии = Новый ОписаниеОповещения("ВыборКассовойКниги", ЭтотОбъект);
	
	ОткрытьФорму("Справочник.КассовыеКниги.ФормаВыбора", ПараметрыФормы, ЭтаФорма,,,, ОповещениеОЗакрытии);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборКассовойКниги(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		Объект.КассоваяКнига = Результат;
		КассоваяКнигаПредставление = Строка(Объект.КассоваяКнига);
		
		Объект.КассовыеОрдера.Очистить();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КассоваяКнигаОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Объект.КассоваяКнига = Неопределено;
	КассоваяКнигаПредставление = НСтр("ru = '<Основная кассовая книга организации>';
										|en = '<Main company cash book>'");
	
	Объект.КассовыеОрдера.Очистить();
	
КонецПроцедуры

&НаКлиенте
Процедура КассоваяКнигаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Объект.КассоваяКнига = ВыбранноеЗначение;
	
	Если ВыбранноеЗначение = ПредопределенноеЗначение("Справочник.КассовыеКниги.ПустаяСсылка") Тогда
		ВыбранноеЗначение = НСтр("ru = '<Основная кассовая книга организации>';
								|en = '<Main company cash book>'");
	КонецЕсли;
	
	Объект.КассовыеОрдера.Очистить();
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияЭДОНажатие(Элемент, СтандартнаяОбработка)
	
	// ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	ОбменСКонтрагентамиКлиент.СостояниеЭДОНажатие_ФормаДокумента(ЭтотОбъект, СтандартнаяОбработка);
	// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	
КонецПроцедуры  

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДокументы

&НаКлиенте
Процедура ДокументыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле.Имя = "Документ" И ЗначениеЗаполнено(Элемент.ТекущиеДанные.Документ) Тогда
		ПоказатьЗначение(, Элемент.ТекущиеДанные.Документ);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДокументыПриАктивизацииСтроки(Элемент)
	
	УстановитьПредупреждениеПриРедактировании();
	
КонецПроцедуры

&НаКлиенте
Процедура ДокументыПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ДокументыПриИзменении(Элемент)
	
	УстановитьПредупреждениеПриРедактировании();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Объект);
КонецПроцедуры


&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры


&НаКлиенте
Процедура ЗаписатьДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Записать(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура АвтоТест_ЗаполнитьДокументы(Команда) Экспорт
	
	ПараметрыПроверки = РаботаСТабличнымиЧастямиКлиент.ПараметрыПроверкиЗаполнения();
	ПараметрыПроверки.ТабличнаяЧасть            = Объект.КассовыеОрдера;
	ПараметрыПроверки.ПроверятьРаспроведенность = Ложь;
	ПараметрыПроверки.ПроверяемыеРеквизиты.Вставить("Организация", НСтр("ru = 'Организация';
																		|en = 'Company'"));
	ПараметрыПроверки.ПроверяемыеРеквизиты.Вставить("Дата",        НСтр("ru = 'Дата';
																		|en = 'Date'"));
	Оповещение = Новый ОписаниеОповещения("АвтоТест_ЗаполнитьДокументыЗавершение", ЭтотОбъект);
	РаботаСТабличнымиЧастямиКлиент.ПроверитьВозможностьЗаполнения(ЭтаФорма, Оповещение, ПараметрыПроверки);
	
КонецПроцедуры

&НаКлиенте
Процедура АвтоТест_ЗаполнитьДокументыЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	ЗаполнитьДокументы();
	
КонецПроцедуры

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры
// Конец ИнтеграцияС1СДокументооборотом

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

// ЭлектронноеВзаимодействие.ОбменСКонтрагентами

&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуЭДО(Команда)
	
	ЭлектронноеВзаимодействиеКлиент.ВыполнитьПодключаемуюКомандуЭДО(Команда, ЭтотОбъект, Объект);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбработчикОжиданияЭДО()
	
	ОбменСКонтрагентамиКлиент.ОбработчикОжиданияЭДО(ЭтотОбъект);
	
КонецПроцедуры

// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами

&НаКлиенте
Процедура ПровестиДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Провести(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиИЗакрыть(Команда)
	
	ОбщегоНазначенияУТКлиент.ПровестиИЗакрыть(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	// Надпись в пустом поле Документ для суммы переоценки
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Документ.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.КассовыеОрдера.Документ");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.DarkGray);
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<Переоценка валютных денежных средств>';
																|en = '<Currency asset revaluation>'"));
	
	// Надпись в пустом поле Документ для суммы переоценки
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.КассоваяКнига.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.КассоваяКнига");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<Переоценка валютных денежных средств>';
																|en = '<Currency asset revaluation>'"));
	
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокВыбораКассовыхКниг()
	
	Справочники.КассовыеКниги.КассовыеКнигиОрганизации(Объект.Организация, Элементы.КассоваяКнига.СписокВыбора);
	
КонецПроцедуры

&НаСервере
Процедура РассчитатьОстатокПоРегистрам()
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	Кассы.Ссылка КАК Касса
	|ПОМЕСТИТЬ Кассы
	|ИЗ
	|	Справочник.Кассы КАК Кассы
	|ГДЕ
	|	Кассы.Владелец = &Организация
	|	И Кассы.КассоваяКнига = &КассоваяКнига
	|;
	|////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДенежныеСредстваНаличныеОстатки.СуммаРеглОстаток КАК СуммаРеглОстаток
	|ИЗ
	|	РегистрНакопления.ДенежныеСредстваНаличные.Остатки(
	|		&КонецДняГраница,
	|		Организация = &Организация
	|		И Касса В (ВЫБРАТЬ Кассы.Касса ИЗ Кассы)) КАК ДенежныеСредстваНаличныеОстатки
	|");
	
	Запрос.УстановитьПараметр("КонецДняГраница", Новый Граница(КонецДня(Объект.Дата), ВидГраницы.Включая));
	Запрос.УстановитьПараметр("НачалоДня", НачалоДня(Объект.Дата));
	Запрос.УстановитьПараметр("КонецДня", КонецДня(Объект.Дата));
	Запрос.УстановитьПараметр("Организация", Объект.Организация);
	Запрос.УстановитьПараметр("КассоваяКнига", Объект.КассоваяКнига);
	
	Результат = Запрос.ВыполнитьПакет();
	ВыборкаОстаткаНаНачалоДня = Результат[1].Выбрать();
	ВыборкаОстаткаНаНачалоДня.Следующий();
	
	СуммаКонечныйОстатокПоРегистру = ВыборкаОстаткаНаНачалоДня.СуммаРеглОстаток;
	
КонецПроцедуры

&НаСервере
Процедура УправлениеЭлементамиФормы()
	
	Элементы.КассоваяКнига.Видимость = ИспользоватьНесколькоКасс;
	
	Элементы.СуммаКонечныйОстатокПоРегистру.Видимость =
		(Объект.СуммаКонечныйОстаток <> СуммаКонечныйОстатокПоРегистру)
		И Объект.Проведен;
	
	//++ НЕ УТ
	Элементы.КорреспондирующийСчет.Видимость = Ложь;
	//-- НЕ УТ
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДокументы()
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоВалют") Тогда
		УстановитьПривилегированныйРежим(Истина);
		Документы.РасчетКурсовыхРазниц.ПереоценитьКассыОрганизации(Объект.Организация, Объект.Дата);
		УстановитьПривилегированныйРежим(Ложь);
	КонецЕсли;
	
	Объект.КассовыеОрдера.Очистить();
	
	ТекстЗапроса = 
	"
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	ДокументКассоваяКнига.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.ЛистКассовойКниги КАК ДокументКассоваяКнига
	|ГДЕ
	|	ДокументКассоваяКнига.Ссылка <> &ТекущийДокумент
	|	И ДокументКассоваяКнига.Организация = &Организация
	|	И ДокументКассоваяКнига.КассоваяКнига = &КассоваяКнига
	|	И ДокументКассоваяКнига.Проведен
	|	И НачалоПериода(ДокументКассоваяКнига.Дата, ДЕНЬ) = &ДатаНач
	|";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("ТекущийДокумент", Объект.Ссылка);
	Запрос.УстановитьПараметр("Организация", Объект.Организация);
	Запрос.УстановитьПараметр("КассоваяКнига", Объект.КассоваяКнига);
	Запрос.УстановитьПараметр("ДатаНач", НачалоДня(Объект.Дата));
	
	ЗаполнятьДокументы = Истина;
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'На дату %1 уже существует документ: %2';
				|en = 'Document already exists on date %1: %2'"),
			Объект.Дата, Выборка.Ссылка);
		ОбщегоНазначения.СообщитьПользователю(
			Текст,
			, // КлючДанных
			"Объект.Дата");
		ЗаполнятьДокументы = Ложь;
		
	КонецЦикла;
	
	Если ЗаполнятьДокументы Тогда
		
		ТекстЗапроса = "
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ДенежныеСредства.Регистратор КАК Документ,
		|	ВЫБОР
		|		КОГДА ДенежныеСредства.Регистратор ССЫЛКА Документ.ПриходныйКассовыйОрдер ТОГДА
		|			ВЫРАЗИТЬ(ДенежныеСредства.Регистратор КАК Документ.ПриходныйКассовыйОрдер).Номер
		|		КОГДА ДенежныеСредства.Регистратор ССЫЛКА Документ.РасходныйКассовыйОрдер ТОГДА
		|			ВЫРАЗИТЬ(ДенежныеСредства.Регистратор КАК Документ.РасходныйКассовыйОрдер).Номер
		|		КОГДА ДенежныеСредства.Регистратор ССЫЛКА Документ.ИнвентаризацияНаличныхДенежныхСредств
		|			ТОГДА ВЫРАЗИТЬ(ДенежныеСредства.Регистратор КАК Документ.ИнвентаризацияНаличныхДенежныхСредств).Номер
		|	КОНЕЦ КАК НомерДокумента,
		|	ВЫБОР КОГДА ДенежныеСредства.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) ТОГДА
		|		0
		|	КОГДА ДенежныеСредства.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) ТОГДА
		|		1
		|	КОНЕЦ КАК ЗначениеУпорядочивания,
		|	СУММА(
		|		ВЫБОР КОГДА ДенежныеСредства.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) ТОГДА
		|			ДенежныеСредства.Сумма
		|		ИНАЧЕ
		|			0
		|		КОНЕЦ
		|	) КАК Приход,
		|	СУММА(
		|		ВЫБОР КОГДА ДенежныеСредства.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) ТОГДА
		|			ДенежныеСредства.Сумма
		|		ИНАЧЕ
		|			0
		|		КОНЕЦ
		|	) КАК Расход,
		|	ДенежныеСредства.Касса.ВалютаДенежныхСредств КАК Валюта,
		|	МАКСИМУМ(ВЫБОР
		|				КОГДА ДенежныеСредства.ХозяйственнаяОперация <> ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ИнкассацияДенежныхСредствВБанк)
		|					ТОГДА СтатьиДДС.КорреспондирующийСчет
		|				КОГДА ДенежныеСредства.Касса.ВалютаДенежныхСредств = ДенежныеСредства.Организация.ВалютаРегламентированногоУчета
		|					ТОГДА ""57.01""
		|				ИНАЧЕ ""57.21""
		|			КОНЕЦ) КАК КорреспондирующийСчет
		|ПОМЕСТИТЬ ДокументыЛиста
		|ИЗ
		|	РегистрНакопления.ДенежныеСредстваНаличные КАК ДенежныеСредства
		|
		|	ЛЕВОЕ СОЕДИНЕНИЕ
		|		Документ.ЛистКассовойКниги.КассовыеОрдера КАК ДокументКассоваяКнига
		|	ПО
		|		ДокументКассоваяКнига.Ссылка <> &Ссылка
		|		И ДокументКассоваяКнига.Ссылка.Проведен
		|		И ДокументКассоваяКнига.Ссылка.Организация = &Организация
		|		И ДокументКассоваяКнига.Ссылка.КассоваяКнига = &КассоваяКнига
		|		И ДокументКассоваяКнига.Документ = ДенежныеСредства.Регистратор
		|
		|	ЛЕВОЕ СОЕДИНЕНИЕ
		|		Справочник.СтатьиДвиженияДенежныхСредств КАК СтатьиДДС
		|	ПО
		|		СтатьиДДС.Ссылка = ДенежныеСредства.СтатьяДвиженияДенежныхСредств
		|
		|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
		|		РегистрСведений.РеестрДокументов КАК РеестрДокументов
		|	ПО
		|		РеестрДокументов.Ссылка = ДенежныеСредства.Регистратор
		|		И НЕ РеестрДокументов.СторноИсправление
		|		И НЕ РеестрДокументов.ДополнительнаяЗапись
		|
		|ГДЕ
		|	ДенежныеСредства.Период МЕЖДУ &ДатаНачала И &ДатаОкончания
		|	И ДенежныеСредства.Организация = &Организация
		|	И ДенежныеСредства.Касса.КассоваяКнига = &КассоваяКнига
		|	И ДокументКассоваяКнига.Документ ЕСТЬ NULL
		|	И НЕ (ДенежныеСредства.Регистратор ССЫЛКА Документ.ВводОстатков
		|		ИЛИ ДенежныеСредства.Регистратор ССЫЛКА Документ.ВводОстатковДенежныхСредств)
		|	И НЕ ДенежныеСредства.ХозяйственнаяОперация В
		|		(ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.КурсовыеРазницыДСПрибыль),
		|		ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.КурсовыеРазницыДСУбыток),
		|		ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПоступлениеДенежныхСредствИзДругойКассы),
		|		ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВыдачаДенежныхСредствВДругуюКассу))
		|	
		|СГРУППИРОВАТЬ ПО
		|	ВЫБОР КОГДА ДенежныеСредства.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) ТОГДА
		|		0
		|	КОГДА ДенежныеСредства.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) ТОГДА
		|		1
		|	КОНЕЦ,
		|	ДенежныеСредства.Касса.ВалютаДенежныхСредств,
		|	ДенежныеСредства.Регистратор,
		|	ВЫБОР
		|		КОГДА ДенежныеСредства.Регистратор ССЫЛКА Документ.ПриходныйКассовыйОрдер
		|			ТОГДА ВЫРАЗИТЬ(ДенежныеСредства.Регистратор КАК Документ.ПриходныйКассовыйОрдер).Номер
		|		КОГДА ДенежныеСредства.Регистратор ССЫЛКА Документ.РасходныйКассовыйОрдер
		|			ТОГДА ВЫРАЗИТЬ(ДенежныеСредства.Регистратор КАК Документ.РасходныйКассовыйОрдер).Номер
		|		КОГДА ДенежныеСредства.Регистратор ССЫЛКА Документ.ИнвентаризацияНаличныхДенежныхСредств
		|			ТОГДА ВЫРАЗИТЬ(ДенежныеСредства.Регистратор КАК Документ.ИнвентаризацияНаличныхДенежныхСредств).Номер
		|	КОНЕЦ
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ДенежныеСредства.Регистратор КАК Документ,
		|	ВЫБОР
		|		КОГДА ДенежныеСредства.Регистратор ССЫЛКА Документ.ПриходныйКассовыйОрдер ТОГДА
		|			ВЫРАЗИТЬ(ДенежныеСредства.Регистратор КАК Документ.ПриходныйКассовыйОрдер).Номер
		|		КОГДА ДенежныеСредства.Регистратор ССЫЛКА Документ.РасходныйКассовыйОрдер ТОГДА
		|			ВЫРАЗИТЬ(ДенежныеСредства.Регистратор КАК Документ.РасходныйКассовыйОрдер).Номер
		|	КОНЕЦ КАК НомерДокумента,
		|	ВЫБОР КОГДА ДенежныеСредства.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) ТОГДА
		|		0
		|	КОГДА ДенежныеСредства.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) ТОГДА
		|		1
		|	КОНЕЦ КАК ЗначениеУпорядочивания,
		|	СУММА(
		|		ВЫБОР КОГДА ДенежныеСредства.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) ТОГДА
		|			ДенежныеСредства.Сумма
		|		ИНАЧЕ
		|			0
		|		КОНЕЦ
		|	) КАК Приход,
		|	СУММА(
		|		ВЫБОР КОГДА ДенежныеСредства.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) ТОГДА
		|			ДенежныеСредства.Сумма
		|		ИНАЧЕ
		|			0
		|		КОНЕЦ
		|	) КАК Расход,
		|	ДенежныеСредства.Касса.ВалютаДенежныхСредств КАК Валюта,
		|	МАКСИМУМ(СтатьиДДС.КорреспондирующийСчет) КАК КорреспондирующийСчет
		|ИЗ
		|	РегистрНакопления.ДенежныеСредстваНаличные КАК ДенежныеСредства
		|
		|	ЛЕВОЕ СОЕДИНЕНИЕ
		|		Документ.ЛистКассовойКниги.КассовыеОрдера КАК ДокументКассоваяКнига
		|	ПО
		|		ДокументКассоваяКнига.Ссылка <> &Ссылка
		|		И ДокументКассоваяКнига.Ссылка.Проведен
		|		И ДокументКассоваяКнига.Ссылка.Организация = &Организация
		|		И ДокументКассоваяКнига.Ссылка.КассоваяКнига = &КассоваяКнига
		|		И ДокументКассоваяКнига.Документ = ДенежныеСредства.Регистратор
		|
		|	ЛЕВОЕ СОЕДИНЕНИЕ
		|		Справочник.СтатьиДвиженияДенежныхСредств КАК СтатьиДДС
		|	ПО
		|		СтатьиДДС.Ссылка = ДенежныеСредства.СтатьяДвиженияДенежныхСредств
		|
		|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
		|		РегистрСведений.РеестрДокументов КАК РеестрДокументов
		|	ПО
		|		РеестрДокументов.Ссылка = ДенежныеСредства.Регистратор
		|		И НЕ РеестрДокументов.СторноИсправление
		|		И НЕ РеестрДокументов.ДополнительнаяЗапись
		|
		|ГДЕ
		|	ДенежныеСредства.Период МЕЖДУ &ДатаНачала И &ДатаОкончания
		|	И ДенежныеСредства.Организация = &Организация
		|	И ДенежныеСредства.Касса.КассоваяКнига = &КассоваяКнига
		|	И ДокументКассоваяКнига.Документ ЕСТЬ NULL
		|	И НЕ (ДенежныеСредства.Регистратор ССЫЛКА Документ.ВводОстатков
		|		ИЛИ ДенежныеСредства.Регистратор ССЫЛКА Документ.ВводОстатковДенежныхСредств)
		|	И ДенежныеСредства.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПоступлениеДенежныхСредствИзДругойКассы)
		|	И (ВЫРАЗИТЬ(ВЫРАЗИТЬ(ДенежныеСредства.Регистратор КАК Документ.ПриходныйКассовыйОрдер).КассаОтправитель КАК Справочник.Кассы).КассоваяКнига <> &КассоваяКнига
		|		ИЛИ ТИПЗНАЧЕНИЯ(ВЫРАЗИТЬ(ДенежныеСредства.Регистратор КАК Документ.ПриходныйКассовыйОрдер).КассаОтправитель) = ТИП(Справочник.КассыККМ))
		|	
		|СГРУППИРОВАТЬ ПО
		|	ВЫБОР КОГДА ДенежныеСредства.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) ТОГДА
		|		0
		|	КОГДА ДенежныеСредства.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) ТОГДА
		|		1
		|	КОНЕЦ,
		|	ДенежныеСредства.Касса.ВалютаДенежныхСредств,
		|	ДенежныеСредства.Регистратор
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ДенежныеСредства.Регистратор КАК Документ,
		|	ВЫБОР
		|		КОГДА ДенежныеСредства.Регистратор ССЫЛКА Документ.ПриходныйКассовыйОрдер ТОГДА
		|			ВЫРАЗИТЬ(ДенежныеСредства.Регистратор КАК Документ.ПриходныйКассовыйОрдер).Номер
		|		КОГДА ДенежныеСредства.Регистратор ССЫЛКА Документ.РасходныйКассовыйОрдер ТОГДА
		|			ВЫРАЗИТЬ(ДенежныеСредства.Регистратор КАК Документ.РасходныйКассовыйОрдер).Номер
		|	КОНЕЦ КАК НомерДокумента,
		|	ВЫБОР КОГДА ДенежныеСредства.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) ТОГДА
		|		0
		|	КОГДА ДенежныеСредства.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) ТОГДА
		|		1
		|	КОНЕЦ КАК ЗначениеУпорядочивания,
		|	СУММА(
		|		ВЫБОР КОГДА ДенежныеСредства.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) ТОГДА
		|			ДенежныеСредства.Сумма
		|		ИНАЧЕ
		|			0
		|		КОНЕЦ
		|	) КАК Приход,
		|	СУММА(
		|		ВЫБОР КОГДА ДенежныеСредства.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) ТОГДА
		|			ДенежныеСредства.Сумма
		|		ИНАЧЕ
		|			0
		|		КОНЕЦ
		|	) КАК Расход,
		|	ДенежныеСредства.Касса.ВалютаДенежныхСредств КАК Валюта,
		|	МАКСИМУМ(СтатьиДДС.КорреспондирующийСчет) КАК КорреспондирующийСчет
		|ИЗ
		|	РегистрНакопления.ДенежныеСредстваНаличные КАК ДенежныеСредства
		|
		|	ЛЕВОЕ СОЕДИНЕНИЕ
		|		Документ.ЛистКассовойКниги.КассовыеОрдера КАК ДокументКассоваяКнига
		|	ПО
		|		ДокументКассоваяКнига.Ссылка <> &Ссылка
		|		И ДокументКассоваяКнига.Ссылка.Проведен
		|		И ДокументКассоваяКнига.Ссылка.Организация = &Организация
		|		И ДокументКассоваяКнига.Ссылка.КассоваяКнига = &КассоваяКнига
		|		И ДокументКассоваяКнига.Документ = ДенежныеСредства.Регистратор
		|
		|	ЛЕВОЕ СОЕДИНЕНИЕ
		|		Справочник.СтатьиДвиженияДенежныхСредств КАК СтатьиДДС
		|	ПО
		|		СтатьиДДС.Ссылка = ДенежныеСредства.СтатьяДвиженияДенежныхСредств
		|
		|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
		|		РегистрСведений.РеестрДокументов КАК РеестрДокументов
		|	ПО
		|		РеестрДокументов.Ссылка = ДенежныеСредства.Регистратор
		|		И НЕ РеестрДокументов.СторноИсправление
		|		И НЕ РеестрДокументов.ДополнительнаяЗапись
		|
		|ГДЕ
		|	ДенежныеСредства.Период МЕЖДУ &ДатаНачала И &ДатаОкончания
		|	И ДенежныеСредства.Организация = &Организация
		|	И ДенежныеСредства.Касса.КассоваяКнига = &КассоваяКнига
		|	И ДокументКассоваяКнига.Документ ЕСТЬ NULL
		|	И НЕ (ДенежныеСредства.Регистратор ССЫЛКА Документ.ВводОстатков
		|		ИЛИ ДенежныеСредства.Регистратор ССЫЛКА Документ.ВводОстатковДенежныхСредств)
		|	И ДенежныеСредства.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВыдачаДенежныхСредствВДругуюКассу)
		|	И (ВЫРАЗИТЬ(ВЫРАЗИТЬ(ДенежныеСредства.Регистратор КАК Документ.РасходныйКассовыйОрдер).КассаПолучатель КАК Справочник.Кассы).КассоваяКнига <> &КассоваяКнига
		|		ИЛИ ТИПЗНАЧЕНИЯ(ВЫРАЗИТЬ(ДенежныеСредства.Регистратор КАК Документ.РасходныйКассовыйОрдер).КассаПолучатель) = ТИП(Справочник.КассыККМ))
		|	
		|СГРУППИРОВАТЬ ПО
		|	ВЫБОР КОГДА ДенежныеСредства.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) ТОГДА
		|		0
		|	КОГДА ДенежныеСредства.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) ТОГДА
		|		1
		|	КОНЕЦ,
		|	ДенежныеСредства.Касса.ВалютаДенежныхСредств,
		|	ДенежныеСредства.Регистратор
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|	
		|ВЫБРАТЬ
		|	НЕОПРЕДЕЛЕНО КАК Документ,
		|	"""" КАК НомерДокумента,
		|	2 КАК ЗначениеУпорядочивания,
		|	ВЫБОР КОГДА
		|		СУММА(ВЫБОР КОГДА ДенежныеСредства.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) ТОГДА
		|					ДенежныеСредства.СуммаРегл
		|				КОГДА ДенежныеСредства.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) ТОГДА
		|					-ДенежныеСредства.СуммаРегл
		|				КОНЕЦ) > 0 ТОГДА
		|		СУММА(ВЫБОР КОГДА ДенежныеСредства.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) ТОГДА
		|					ДенежныеСредства.СуммаРегл
		|				КОГДА ДенежныеСредства.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) ТОГДА
		|					-ДенежныеСредства.СуммаРегл
		|				КОНЕЦ)
		|		ИНАЧЕ 0
		|	КОНЕЦ КАК Приход,
		|	ВЫБОР КОГДА
		|		СУММА(ВЫБОР КОГДА ДенежныеСредства.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) ТОГДА
		|					ДенежныеСредства.СуммаРегл
		|				КОГДА ДенежныеСредства.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) ТОГДА
		|					-ДенежныеСредства.СуммаРегл
		|				КОНЕЦ) < 0 ТОГДА
		|		-СУММА(ВЫБОР КОГДА ДенежныеСредства.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) ТОГДА
		|					ДенежныеСредства.СуммаРегл
		|				КОГДА ДенежныеСредства.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) ТОГДА
		|					-ДенежныеСредства.СуммаРегл
		|				КОНЕЦ)
		|		ИНАЧЕ 0
		|	КОНЕЦ КАК Расход,
		|	&ВалютаРегламентированногоУчета КАК Валюта,
		|	МАКСИМУМ(СтатьиДДС.КорреспондирующийСчет) КАК КорреспондирующийСчет
		|ИЗ
		|	РегистрНакопления.ДенежныеСредстваНаличные КАК ДенежныеСредства
		|	
		|	ЛЕВОЕ СОЕДИНЕНИЕ
		|		Справочник.СтатьиДвиженияДенежныхСредств КАК СтатьиДДС
		|	ПО
		|		СтатьиДДС.Ссылка = ДенежныеСредства.СтатьяДвиженияДенежныхСредств
		|	
		|ГДЕ
		|	ДенежныеСредства.Период МЕЖДУ &ДатаНачала И &ДатаОкончания
		|	И ДенежныеСредства.СуммаРегл <> 0
		|	И ДенежныеСредства.Организация = &Организация
		|	И ДенежныеСредства.Касса.КассоваяКнига = &КассоваяКнига
		|	И НЕ (ДенежныеСредства.Регистратор ССЫЛКА Документ.ВводОстатков
		|		ИЛИ ДенежныеСредства.Регистратор ССЫЛКА Документ.ВводОстатковДенежныхСредств)
		|	И ДенежныеСредства.ХозяйственнаяОперация В (
		|		ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.КурсовыеРазницыДСПрибыль),
		|		ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.КурсовыеРазницыДСУбыток))
		|ИМЕЮЩИЕ
		|	СУММА(ВЫБОР КОГДА ДенежныеСредства.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) ТОГДА
		|			ДенежныеСредства.СуммаРегл
		|		КОГДА ДенежныеСредства.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) ТОГДА
		|			-ДенежныеСредства.СуммаРегл
		|		КОНЕЦ) <> 0
		|;
		|
		|ВЫБРАТЬ
		|	ДокументыЛиста.Документ,
		|	ДокументыЛиста.НомерДокумента,
		|	ДокументыЛиста.ЗначениеУпорядочивания,
		|	ДокументыЛиста.Валюта,
		|	ДокументыЛиста.КорреспондирующийСчет,
		|	ДокументыЛиста.Приход + СУММА(
		|		ВЫБОР КОГДА ДенежныеСредства.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) ТОГДА
		|			ДенежныеСредства.Сумма
		|		ИНАЧЕ
		|			0
		|		КОНЕЦ
		|	) КАК Приход,
		|	ДокументыЛиста.Расход + СУММА(
		|		ВЫБОР КОГДА ДенежныеСредства.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) ТОГДА
		|			ДенежныеСредства.Сумма
		|		ИНАЧЕ
		|			0
		|		КОНЕЦ
		|	) КАК Расход
		|ИЗ
		|	ДокументыЛиста
		|	
		|	ЛЕВОЕ СОЕДИНЕНИЕ
		|		РегистрСведений.РеестрДокументов КАК РеестрДокументов
		|	ПО
		|		РеестрДокументов.ИсправляемыйДокумент = ДокументыЛиста.Документ
		|		И РеестрДокументов.Проведен
		|		И НЕ РеестрДокументов.ДополнительнаяЗапись
		|	
		|		ЛЕВОЕ СОЕДИНЕНИЕ
		|			РегистрНакопления.ДенежныеСредстваНаличные КАК ДенежныеСредства
		|		ПО
		|			ДенежныеСредства.Регистратор = РеестрДокументов.Ссылка
		|			
		|СГРУППИРОВАТЬ ПО
		|	ДокументыЛиста.Документ,
		|	ДокументыЛиста.НомерДокумента,
		|	ДокументыЛиста.ЗначениеУпорядочивания,
		|	ДокументыЛиста.Валюта,
		|	ДокументыЛиста.КорреспондирующийСчет,
		|	ДокументыЛиста.Приход,
		|	ДокументыЛиста.Расход
		|	
		|УПОРЯДОЧИТЬ ПО
		|	ЗначениеУпорядочивания,
		|	НомерДокумента
		|";
		
		Запрос = Новый Запрос(ТекстЗапроса);
		Запрос.УстановитьПараметр("ДатаНачала", НачалоДня(Объект.Дата));
		Запрос.УстановитьПараметр("ДатаОкончания", КонецДня(Объект.Дата));
		Запрос.УстановитьПараметр("Организация", Объект.Организация);
		Запрос.УстановитьПараметр("КассоваяКнига", Объект.КассоваяКнига);
		Запрос.УстановитьПараметр("Ссылка", Объект.Ссылка);
		Запрос.УстановитьПараметр("ВалютаРегламентированногоУчета", ЗначениеНастроекПовтИсп.ВалютаРегламентированногоУчетаОрганизации(Объект.Организация));
		
		РезультатЗапроса = Запрос.Выполнить();
		
		Если РезультатЗапроса.Пустой() Тогда
			
			Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'На дату %1  нет документов для заполнения листа кассовой книги';
					|en = 'No documents for population of cash book sheet on date %1'"),
				Объект.Дата, Выборка.Ссылка);
			ОбщегоНазначения.СообщитьПользователю(
				Текст,
				, // КлючДанных
				"Дата");
		Иначе
			Объект.КассовыеОрдера.Загрузить(РезультатЗапроса.Выгрузить());
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПредупреждениеПриРедактировании()
	
	СтрокаТаблицы = Элементы.КассовыеОрдера.ТекущиеДанные;
	Если СтрокаТаблицы <> Неопределено Тогда
		Если ЗначениеЗаполнено(СтрокаТаблицы.Документ) Тогда
			Если ТипЗнч(СтрокаТаблицы.Документ) = Тип("ДокументСсылка.ПриходныйКассовыйОрдер") Тогда
				Элементы.Приход.ОтображениеПредупрежденияПриРедактировании = ОтображениеПредупрежденияПриРедактировании.НеОтображать;
				Элементы.Расход.ОтображениеПредупрежденияПриРедактировании = ОтображениеПредупрежденияПриРедактировании.Отображать;
			Иначе
				Элементы.Приход.ОтображениеПредупрежденияПриРедактировании = ОтображениеПредупрежденияПриРедактировании.Отображать;
				Элементы.Расход.ОтображениеПредупрежденияПриРедактировании = ОтображениеПредупрежденияПриРедактировании.НеОтображать;
			КонецЕсли;
		Иначе
			Элементы.Приход.ОтображениеПредупрежденияПриРедактировании = ОтображениеПредупрежденияПриРедактировании.Отображать;
			Элементы.Расход.ОтображениеПредупрежденияПриРедактировании = ОтображениеПредупрежденияПриРедактировании.Отображать;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ДатаПриИзмененииСервер()
	
	ОтветственныеЛицаСервер.ПриИзмененииСвязанныхРеквизитовДокумента(Объект);
	
КонецПроцедуры

#КонецОбласти
