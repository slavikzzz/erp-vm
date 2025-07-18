
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ЭтоУТ = ПолучитьФункциональнуюОпцию("УправлениеТорговлей");
	ИспользуетсяПередачаВФинАренду = Ложь;
	//++ НЕ УТ
	ИспользуетсяПередачаВФинАренду = ПолучитьФункциональнуюОпцию("ИспользуетсяПередачаВАрендуСубарендуПоФСБУ25");
	//-- НЕ УТ
	ИспользуетсяРеглУчет = ПолучитьФункциональнуюОпцию("ИспользоватьРеглУчет");
	ЛокализацияРФ = ПолучитьФункциональнуюОпцию("ЛокализацияРФ");
	Элементы.КорреспондирующийСчет.Видимость = Ложь;
	Если ЭтоУТ Или НЕ ЛокализацияРФ Или НЕ ИспользуетсяРеглУчет Тогда
		Элементы.КорреспондирующийСчет.Видимость = Истина;
		Элементы.КорреспондирующийСчет.Маска = ОбменДаннымиСобытияУТУП.МаскаСчета();
		Если НЕ ЛокализацияРФ Тогда
			Элементы.КорреспондирующийСчет.КнопкаВыпадающегоСписка = Ложь;
		КонецЕсли;
	КонецЕсли;
	
	// Обработчик подсистемы "Свойства"
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Объект", Объект);
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтаФорма, ДополнительныеПараметры);
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	// СтандартныеПодсистемы.БазоваяФункциональность
	МультиязычностьСервер.ПриСозданииНаСервере(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.БазоваяФункциональность
		
	УстановитьВидимостьПолей();
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьРеглУчет") Тогда
		Элементы.СтраницаРегламентированныйУчет.Видимость = Ложь;
		Элементы.ГруппаСтраницы.ОтображениеСтраниц = ОтображениеСтраницФормы.Нет;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПриЧтенииСозданииНаСервере();
	КонецЕсли;
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец ИнтеграцияС1СДокументооборотом
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// Подсистема "Свойства"
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтаФорма, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	
	//++ НЕ УТ
	НастройкаСчетовУчетаКлиент.ЗаконченаНастройкаСчетовУчета(ЭтотОбъект, ИмяСобытия, Параметр);
	//-- НЕ УТ
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПриЧтенииСозданииНаСервере();
	
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	// СтандартныеПодсистемы.БазоваяФункциональность
	МультиязычностьСервер.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.БазоваяФункциональность	
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если ПустаяСтрока(ТипЗначения) Тогда
		ТекстСообщения = НСтр("ru = 'В поле ""Аналитика доходов"" не выбрано ни одного вида аналитики';
								|en = 'No dimension kind is selected in the ""Income dimension"" field'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстСообщения,
			, // ОбъектИлиСсылка
			"ТипЗначения",
			, // ПутьКДанным
			Отказ);
	КонецЕсли;
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// Обработчик подсистемы "Свойства"
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект);
	
	// СтандартныеПодсистемы.БазоваяФункциональность
	МультиязычностьСервер.ПередЗаписьюНаСервере(ТекущийОбъект);
	// Конец СтандартныеПодсистемы.БазоваяФункциональность	
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПередЗаписьюНаСервере(
		ЭтотОбъект,
		ТекущийОбъект,
		ПараметрыЗаписи);
	// Конец ИнтеграцияС1СДокументооборотом
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	// СтандартныеПодсистемы.БазоваяФункциональность
	МультиязычностьСервер.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.БазоваяФункциональность
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ТипЗначенияПриИзменении(Элемент)
	
	Если Не ПустаяСтрока(ТипЗначения) Тогда
		Объект.ТипЗначения = Новый ОписаниеТипов(ТипЗначения);
	КонецЕсли;
	
	//++ НЕ УТ
	Если ТипЗначения = "СправочникСсылка.ОбъектыЭксплуатации"
		Или ТипЗначения = "СправочникСсылка.НематериальныеАктивы" Тогда
		Объект.КонтролироватьЗаполнениеАналитики = Истина;
		Элементы.КонтролироватьЗаполнениеАналитики.Доступность = ИспользуетсяПередачаВФинАренду;
	Иначе
		Элементы.КонтролироватьЗаполнениеАналитики.Доступность = Истина;
	КонецЕсли;
	//-- НЕ УТ
	Возврат; // Обработчик используется только в УТ
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииРеквизитаЛокализации(Элемент)
	
	СтатьиДоходовКлиентЛокализация.ПриИзмененииРеквизита(Элемент.Имя, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОкончанииИзмененияРеквизитаЛокализации(ИмяЭлемента, Параметры = Неопределено) Экспорт
	
	Если Параметры.ТребуетсяВызовСервера Тогда
		ПриОкончанииИзмененияРевизитаЛокализацииНаСервере(ИмяЭлемента);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриОкончанииИзмененияРевизитаЛокализацииНаСервере(ИмяЭлемента)
	
	СтатьиДоходовЛокализация.ПриИзмененииРеквизита(ИмяЭлемента, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_Открытие(Элемент, СтандартнаяОбработка)
	// СтандартныеПодсистемы.БазоваяФункциональность
	МультиязычностьКлиент.ПриОткрытии(ЭтотОбъект, Объект, Элемент, СтандартнаяОбработка);
	// Конец СтандартныеПодсистемы.БазоваяФункциональность
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры

// Процедура - обработчик выполнения команды.
//
// Параметры:
//	Команда - КомандаФормы - команда формы.
//
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуЛокализации(Команда)
	
	СтатьиДоходовКлиентЛокализация.ВыполнитьКоманду(Команда.Имя, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПродолжитьВыполнениеКомандыЛокализации(ИмяКоманды, Параметры) Экспорт
	
	Если Параметры.ТребуетсяВызовСервера Тогда
		ВыполнитьКомандуЛокализацииНаСервере(ИмяКоманды);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ВыполнитьКомандуЛокализацииНаСервере(ИмяКоманды)
	
	СтатьиДоходовЛокализация.ВыполнитьКоманду(ИмяКоманды, ЭтаФорма);
	
КонецПроцедуры

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(
		Команда,
		ЭтотОбъект,
		Объект);
	
КонецПроцедуры
// Конец ИнтеграцияС1СДокументооборотом

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	
	ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Объект);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	
	ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
	
КонецПроцедуры

&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
	
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Объект);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.Свойства

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

// Конец СтандартныеПодсистемы.Свойства

#Область УправлениеЭлементамиФормы

&НаСервере
Процедура УстановитьВидимостьТиповЗначенийАналитики()
	
	МассивИсключаемыхТипов = Новый Массив;
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьЗаказыПоставщикам") Тогда
		МассивИсключаемыхТипов.Добавить("ДокументСсылка.ЗаказПоставщику");
	КонецЕсли;
	
	Если Не ПолучитьФункциональнуюОпцию("ФормироватьФинансовыйРезультат") Тогда
		МассивИсключаемыхТипов.Добавить("СправочникСсылка.НаправленияДеятельности");
	КонецЕсли;
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоВалют") Тогда
		МассивИсключаемыхТипов.Добавить("ПеречислениеСсылка.АналитикаКурсовыхРазниц");
	КонецЕсли;
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьПодразделения") Тогда
		МассивИсключаемыхТипов.Добавить("СправочникСсылка.СтруктураПредприятия");
	КонецЕсли;
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций") Тогда
		МассивИсключаемыхТипов.Добавить("СправочникСсылка.Организации");
	КонецЕсли;
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьДоговорыКредитовИДепозитов") Тогда
		МассивИсключаемыхТипов.Добавить("СправочникСсылка.ДоговорыКредитовИДепозитов");
	КонецЕсли;
	
	Для Каждого ИсключаемыйТип Из МассивИсключаемыхТипов Цикл
		ЭлементСписка = Элементы.ТипЗначения.СписокВыбора.НайтиПоЗначению(ИсключаемыйТип);
		Если ЭлементСписка <> Неопределено И ТипЗначения <> ИсключаемыйТип Тогда
			Элементы.ТипЗначения.СписокВыбора.Удалить(ЭлементСписка);
		КонецЕсли;
	КонецЦикла;
		
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьПолей()

	Если Объект.Ссылка = ПланыВидовХарактеристик.СтатьиДоходов.ВыручкаОтПродаж Тогда
		Элементы.СпособРаспределения.Видимость = Ложь;
	КонецЕсли;
	
	//++ НЕ УТ
	ДоходыПоАктивам = (ТипЗначения = "СправочникСсылка.ОбъектыЭксплуатации")
				  ИЛИ (ТипЗначения = "СправочникСсылка.НематериальныеАктивы");
	
	Элементы.КонтролироватьЗаполнениеАналитики.Доступность = Не ДоходыПоАктивам Или ИспользуетсяПередачаВФинАренду;
	//-- НЕ УТ
	
КонецПроцедуры

#КонецОбласти

#Область Свойства

&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтаФорма);
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()
	
	СтатьиДоходовЛокализация.ПриЧтенииСозданииНаСервере(ЭтотОбъект);
	ЗаполнитьСписокВидовАналитикДоходов();
	УстановитьТипЗначения();
	
	//++ НЕ УТ
	Если Не ВнеоборотныеАктивы.ИспользуетсяУправлениеВНА() Тогда
		Список = Элементы.ТипЗначения.СписокВыбора;
		Список.Удалить(Список.НайтиПоЗначению("СправочникСсылка.ОбъектыЭксплуатации"));
		Список.Удалить(Список.НайтиПоЗначению("СправочникСсылка.НематериальныеАктивы"));
	КонецЕсли;
	//-- НЕ УТ
	
КонецПроцедуры

&НаСервере
Процедура УстановитьТипЗначения()

	СписокТиповЗначений = Новый СписокЗначений;
	СписокТиповЗначений.Добавить("СправочникСсылка.Организации");
	СписокТиповЗначений.Добавить("СправочникСсылка.СтруктураПредприятия");
	СписокТиповЗначений.Добавить("СправочникСсылка.НаправленияДеятельности");
	СписокТиповЗначений.Добавить("СправочникСсылка.Партнеры");
	СписокТиповЗначений.Добавить("ДокументСсылка.ЗаказПоставщику");
	СписокТиповЗначений.Добавить("СправочникСсылка.ДоговорыКредитовИДепозитов");
	СписокТиповЗначений.Добавить("ПеречислениеСсылка.АналитикаКурсовыхРазниц");
	//++ НЕ УТ
	СписокТиповЗначений.Добавить("СправочникСсылка.ОбъектыЭксплуатации");
	СписокТиповЗначений.Добавить("СправочникСсылка.НематериальныеАктивы");
	//-- НЕ УТ
	СписокТиповЗначений.Добавить("СправочникСсылка.Номенклатура");

	Для Каждого ЭлементСписка Из СписокТиповЗначений Цикл
		Если Объект.ТипЗначения.СодержитТип(Тип(ЭлементСписка.Значение)) Тогда
			ТипЗначения = ЭлементСписка.Значение;
			Прервать;
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокВидовАналитикДоходов()
	
	СписокВыбора = Элементы.ТипЗначения.СписокВыбора;
	СписокВыбора.Очистить();
	
	СписокВыбора.Добавить("СправочникСсылка.Организации", 				НСтр("ru = 'Организация';
																				|en = 'Company'"));
	СписокВыбора.Добавить("СправочникСсылка.СтруктураПредприятия", 		НСтр("ru = 'Подразделение';
																				|en = 'Business unit'"));
	СписокВыбора.Добавить("СправочникСсылка.НаправленияДеятельности", 	НСтр("ru = 'Направление деятельности';
																				|en = 'Line of business'"));
	СписокВыбора.Добавить("СправочникСсылка.Партнеры",					НСтр("ru = 'Поставщик';
																				|en = 'Vendor'"));
	СписокВыбора.Добавить("ДокументСсылка.ЗаказПоставщику", 			НСтр("ru = 'Заказ поставщику';
																			|en = 'Purchase order'"));
	СписокВыбора.Добавить("СправочникСсылка.ДоговорыКредитовИДепозитов",НСтр("ru = 'Договор кредита (депозита)';
																			|en = 'Loan (deposit) contract'"));
	СписокВыбора.Добавить("ПеречислениеСсылка.АналитикаКурсовыхРазниц", НСтр("ru = 'Виды курсовых разниц';
																			|en = 'Exchange difference types'"));
	//++ НЕ УТ
	СписокВыбора.Добавить("СправочникСсылка.ОбъектыЭксплуатации", 		НСтр("ru = 'Объекты эксплуатации';
																				|en = 'Assets'"));
	СписокВыбора.Добавить("СправочникСсылка.НематериальныеАктивы", 		НСтр("ru = 'НМА / НИОКР';
																				|en = 'Intangible assets / R&D'"));
	//-- НЕ УТ
	СписокВыбора.Добавить("СправочникСсылка.Номенклатура", 				НСтр("ru = 'Номенклатура';
																				|en = 'Items'"));
	
	УстановитьВидимостьТиповЗначенийАналитики();
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
