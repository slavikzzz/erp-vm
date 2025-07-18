
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Не БизнесСеть.ЕстьПравоПросмотраПрофиляОрганизации() Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Параметры.Свойство("ИНН",    ПрофильИНН);
	Параметры.Свойство("КПП",    ПрофильКПП);
	Параметры.Свойство("Ссылка", Ссылка);
	
	Если Параметры.Свойство("Реквизиты") Тогда
		ЗаполнитьРеквизитыПрофиля(Параметры.Реквизиты);
	Иначе
		ПолучитьДанныеСервиса(Отказ);
	КонецЕсли;
	
	Если ПрофильКПП = "0" Тогда
		ПрофильКПП = "";
	КонецЕсли;

	Если ЗначениеЗаполнено(ПрофильИНН) И НЕ ЗначениеЗаполнено(Ссылка) Тогда
		ОбменСКонтрагентамиПереопределяемый.СсылкаНаОбъектПоИННКПП("Контрагенты", ПрофильИНН, ПрофильКПП, Ссылка);
	КонецЕсли;
	
	Если Метаданные.ОпределяемыеТипы.Организация.Тип.СодержитТип(ТипЗнч(Ссылка)) Тогда
		Элементы.Ссылка.Заголовок = НСтр("ru = 'Организация';
										|en = 'Company'");
	Иначе
		Элементы.Ссылка.Заголовок = НСтр("ru = 'Контрагент';
										|en = 'Counterparty'");
	КонецЕсли;
	
	УстановитьВидимостьДоступность();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТорговыеПредложенияНажатие(Элемент)
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ЭлектронноеВзаимодействие.ТорговыеПредложения") Тогда
		
		// Команда вызова метода доступна только при встраивании подсистемы "Торговые предложения".
		ОтборКонтрагент = Новый Структура();
		ОтборКонтрагент.Вставить("Ссылка",                          Ссылка);
		ОтборКонтрагент.Вставить("ИНН",                             ПрофильИНН);
		ОтборКонтрагент.Вставить("КПП",                             ПрофильКПП);
		ОтборКонтрагент.Вставить("Наименование",                    ПрофильНаименование);
		
		ПараметрыОткрытия = Новый Структура("Контрагент", ОтборКонтрагент);
		
		ОчиститьСообщения();
		
		ОбщийМодульТорговыеПредложенияКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ТорговыеПредложенияКлиент");
		ОбщийМодульТорговыеПредложенияКлиент.ОткрытьФормуПоискаПоОтборам(ПараметрыОткрытия);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьКонтрагентаНажатие(Элемент)
	
	СоздатьКонтрагентаНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПолучитьДанныеСервиса(Отказ)
	
	ДополнительныеПараметры = БизнесСетьКлиентСервер.ОписаниеИдентификацииОрганизацииКонтрагентов();
	ДополнительныеПараметры.Ссылка = Ссылка;
	ДополнительныеПараметры.ИНН = ПрофильИНН;
	ДополнительныеПараметры.КПП = ПрофильКПП;
	Результат = БизнесСетьВызовСервера.ПолучитьРеквизитыУчастника(ДополнительныеПараметры, Отказ, Истина);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьРеквизитыПрофиля(Результат);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьРеквизитыПрофиля(Источник)
	
	Источник.Свойство("ДатаРегистрации",  ПрофильДатаРегистрации);
	Источник.Свойство("Наименование",     ПрофильНаименование);
	Источник.Свойство("ИНН",              ПрофильИНН);
	Источник.Свойство("КПП",              ПрофильКПП);
	Источник.Свойство("НаименованиеЕГРН", ПрофильНаименованиеЕГРН);
	Источник.Свойство("Адрес",            ПрофильАдрес);
	Источник.Свойство("ОГРН",             ПрофильОГРН);
	Источник.Свойство("Сайт",             ПрофильСайт);
	Источник.Свойство("Телефон",          ПрофильТелефон);
	Источник.Свойство("ЭлектроннаяПочта", ПрофильЭлектроннаяПочта);
	Источник.Свойство("КоличествоТорговыхПредложений", ПрофильКоличествоТорговыхПредложений);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьДоступность()
	
	Элементы.Ссылка.Видимость                   = ЗначениеЗаполнено(Ссылка);
	Элементы.ГруппаНовогоКонтрагента.Видимость  = Не ЗначениеЗаполнено(Ссылка);
	Элементы.ПрофильКПП.Видимость               = ЗначениеЗаполнено(ПрофильКПП);
	Элементы.ПрофильОГРН.Видимость              = ЗначениеЗаполнено(ПрофильОГРН);
	Элементы.ПрофильАдрес.Видимость             = ЗначениеЗаполнено(ПрофильАдрес);
	Элементы.ПрофильТелефон.Видимость           = ЗначениеЗаполнено(ПрофильТелефон);
	Элементы.ПрофильЭлектроннаяПочта.Видимость  = ЗначениеЗаполнено(ПрофильЭлектроннаяПочта);
	Элементы.ПрофильСайт.Видимость              = ЗначениеЗаполнено(ПрофильСайт);
	Элементы.ПрофильДатаРегистрации.Видимость   = ЗначениеЗаполнено(ПрофильДатаРегистрации);
	Элементы.ПрофильНаименованиеЕГРН.Видимость  = ЗначениеЗаполнено(ПрофильНаименованиеЕГРН);
	
	Заголовок = НСтр("ru = '%1 (профиль участника 1С:Бизнес-сеть)';
					|en = '%1 (1C:Business Network participant account)'");
	Заголовок = СтрШаблон(Заголовок, ПрофильНаименование);
	
	// ЭлектронноеВзаимодействие.ТорговыеПредложения
	ЕстьТорговыеПредложения = ОбщегоНазначения.ПодсистемаСуществует("ЭлектронноеВзаимодействие.ТорговыеПредложения");
	
	Элементы.ТорговыеПредложения.Видимость =
		ЗначениеЗаполнено(ПрофильКоличествоТорговыхПредложений) И ЕстьТорговыеПредложения;
		
	ПредставлениеКоличества = "";
	
	Если ПрофильКоличествоТорговыхПредложений > 0 И ПрофильКоличествоТорговыхПредложений < 10000 Тогда
		ПредставлениеКоличества = Строка(ПрофильКоличествоТорговыхПредложений);
	ИначеЕсли ПрофильКоличествоТорговыхПредложений >= 10000 Тогда
		ПредставлениеКоличества = СтрШаблон("%1+", ПрофильКоличествоТорговыхПредложений);
	КонецЕсли;
		
	Если ЗначениеЗаполнено(ПредставлениеКоличества) Тогда
		Элементы.ТорговыеПредложения.Заголовок =
			СтрШаблон(НСтр("ru = 'Открыть торговые предложения (%1)';
							|en = 'Open selling propositions (%1)'"), ПредставлениеКоличества);
	КонецЕсли;
	// Конец ЭлектронноеВзаимодействие.ТорговыеПредложения
	
КонецПроцедуры

&НаСервере
Процедура СоздатьКонтрагентаНаСервере()
	
	Отказ = Ложь;
	
	Реквизиты = Новый Структура;
	Реквизиты.Вставить("ИНН", ПрофильИНН);
	Реквизиты.Вставить("КПП", ПрофильКПП);
	Реквизиты.Вставить("Наименование", ПрофильНаименование);
	БизнесСетьПереопределяемый.СоздатьКонтрагентаПоРеквизитам(Реквизиты, Ссылка, Отказ);
	
	Если Не Отказ Тогда
		УстановитьВидимостьДоступность();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
