
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Ключ.Пустая() Тогда
		
		ЗначенияДляЗаполнения = Новый Структура("Организация, Ответственный, Месяц", 
			"Объект.Организация",
			"Объект.Ответственный",
			"Объект.МесяцРасчетногоПериода");
		
		ЗарплатаКадры.ЗаполнитьПервоначальныеЗначенияВФорме(ЭтаФорма, ЗначенияДляЗаполнения);
		
		ПриПолученииДанныхНаСервере();
		
	КонецЕсли;
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.Свойства
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект, ДополнительныеПараметры);
	// Конец СтандартныеПодсистемы.Свойства
	
	// ПроцессыОбработкиДокументов
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ПроцессыОбработкиДокументовЗарплата") Тогда
		МодульПроцессыОбработкиДокументовЗарплата = ОбщегоНазначения.ОбщийМодуль("ПроцессыОбработкиДокументовЗарплата");
		МодульПроцессыОбработкиДокументовЗарплата.ПриСозданииНаСервере(ЭтотОбъект, Объект);
	КонецЕсли;	
	// Конец ПроцессыОбработкиДокументов
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// СтандартныеПодсистемы.Свойства
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтотОбъект, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	ПриПолученииДанныхНаСервере();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	// ПроцессыОбработкиДокументов
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ПроцессыОбработкиДокументовЗарплата") Тогда
		МодульПроцессыОбработкиДокументовЗарплата = ОбщегоНазначения.ОбщийМодуль("ПроцессыОбработкиДокументовЗарплата");
		МодульПроцессыОбработкиДокументовЗарплата.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;	
	// Конец ПроцессыОбработкиДокументов
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	// ПроцессыОбработкиДокументов
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ПроцессыОбработкиДокументовЗарплата") Тогда
		МодульПроцессыОбработкиДокументовЗарплата = ОбщегоНазначения.ОбщийМодуль("ПроцессыОбработкиДокументовЗарплата");
		МодульПроцессыОбработкиДокументовЗарплата.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи, Отказ);
	КонецЕсли;		
	// Конец ПроцессыОбработкиДокументов
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("Запись_ОперацияУчетаПоСтраховымВзносам", ПараметрыЗаписи, Объект.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// ПроцессыОбработкиДокументов
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ПроцессыОбработкиДокументовЗарплата") Тогда
		МодульПроцессыОбработкиДокументовЗарплата = ОбщегоНазначения.ОбщийМодуль("ПроцессыОбработкиДокументовЗарплата");
		МодульПроцессыОбработкиДокументовЗарплата.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	КонецЕсли;	
	// Конец ПроцессыОбработкиДокументов
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	// ПроцессыОбработкиДокументов
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ПроцессыОбработкиДокументовЗарплата") Тогда
		МодульПроцессыОбработкиДокументовЗарплата = ОбщегоНазначенияКлиент.ОбщийМодуль("ПроцессыОбработкиДокументовЗарплатаКлиент");
		МодульПроцессыОбработкиДокументовЗарплата.ПередЗакрытием(ЭтотОбъект, Объект, Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	КонецЕсли;	
	// Конец ПроцессыОбработкиДокументов
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	ОбработатьИзменениеОрганизацииНаСервере();
КонецПроцедуры

#Область РедактированиеМесяцаСтрокой

&НаКлиенте
Процедура МесяцРасчетногоПериодаСтрокойПриИзменении(Элемент)
	
	ЗарплатаКадрыКлиент.ВводМесяцаПриИзменении(ЭтаФорма, "Объект.МесяцРасчетногоПериода", "МесяцРасчетногоПериодаСтрокой", Модифицированность);
	ОбработатьИзменениеМесяцРасчетногоПериодаНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура МесяцРасчетногоПериодаСтрокойНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения("МесяцРасчетногоПериодаСтрокойНачалоВыбораЗавершение", ЭтотОбъект);
	ЗарплатаКадрыКлиент.ВводМесяцаНачалоВыбора(ЭтаФорма, ЭтаФорма, "Объект.МесяцРасчетногоПериода", "МесяцРасчетногоПериодаСтрокой", , Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура МесяцРасчетногоПериодаСтрокойНачалоВыбораЗавершение(ЗначениеВыбрано, ДополнительныеПараметры) Экспорт 
	
	Если ЗначениеВыбрано Тогда
		ОбработатьИзменениеМесяцРасчетногоПериодаНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура МесяцРасчетногоПериодаСтрокойРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ВводМесяцаРегулирование(ЭтаФорма, "Объект.МесяцРасчетногоПериода", "МесяцРасчетногоПериодаСтрокой", Направление, Модифицированность);
	ПодключитьОбработчикОжидания("ОбработчикОжиданияМесяцРасчетногоПериодаПриИзменении", 0.3, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура МесяцРасчетногоПериодаСтрокойАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ВводМесяцаАвтоПодборТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура МесяцРасчетногоПериодаСтрокойОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ВводМесяцаОкончаниеВводаТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура СведенияОДоходахЛьготныйТерриториальныйТарифПриИзменении(Элемент)
	ДанныеТекущейСтроки = Элементы.СведенияОДоходах.ТекущиеДанные;
	ДанныеТекущейСтроки.ЯвляетсяДоходомЧленаЭкипажаСуднаПодФлагомРФ = ДанныеТекущейСтроки.ЛьготныйТерриториальныйТариф = ОбщегоНазначенияКлиент.ПредопределенныйЭлемент("Справочник.ВидыТарифовСтраховыхВзносов.ДляЧленовЭкипажейМорскихСудовПодФлагомРФ")
КонецПроцедуры

&НаКлиенте
Процедура СведенияОДоходахЯвляетсяДоходомЧленаЭкипажаСуднаПодФлагомРФПриИзменении(Элемент)
	ДанныеТекущейСтроки = Элементы.СведенияОДоходах.ТекущиеДанные;
	Если ДанныеТекущейСтроки.ЯвляетсяДоходомЧленаЭкипажаСуднаПодФлагомРФ Тогда
		ДанныеТекущейСтроки.ЛьготныйТерриториальныйТариф = ОбщегоНазначенияКлиент.ПредопределенныйЭлемент("Справочник.ВидыТарифовСтраховыхВзносов.ДляЧленовЭкипажейМорскихСудовПодФлагомРФ")
	ИначеЕсли ДанныеТекущейСтроки.ЛьготныйТерриториальныйТариф = ОбщегоНазначенияКлиент.ПредопределенныйЭлемент("Справочник.ВидыТарифовСтраховыхВзносов.ДляЧленовЭкипажейМорскихСудовПодФлагомРФ") Тогда
		ДанныеТекущейСтроки.ЛьготныйТерриториальныйТариф = ОбщегоНазначенияКлиент.ПредопределенныйЭлемент("Справочник.ВидыТарифовСтраховыхВзносов.ПустаяСсылка")
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

// СтандартныеПодсистемы.Свойства
&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

#Область ОбработчикиСобытийПроцессыОбработкиДокументов

&НаКлиенте
Процедура Подключаемый_ВыполнитьЗадачуПоОбработкеДокумента(Команда)
	// ПроцессыОбработкиДокументов
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ПроцессыОбработкиДокументовЗарплата") Тогда
		МодульПроцессыОбработкиДокументовЗарплата = ОбщегоНазначенияКлиент.ОбщийМодуль("ПроцессыОбработкиДокументовЗарплатаКлиент");
		МодульПроцессыОбработкиДокументовЗарплата.ВыполнитьЗадачу(ЭтотОбъект, Команда, Объект)
	КонецЕсли;		
	// Конец ПроцессыОбработкиДокументов
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьЗадачуПоОбработкеДокументаОповещение(Контекст, ДополнительныеПараметры) Экспорт
	ВыполнитьЗадачуПоОбработкеДокументаНаСервере(Контекст);
	ВыполнитьОбработкуОповещения(ДополнительныеПараметры, Контекст);
КонецПроцедуры

&НаСервере
Процедура ВыполнитьЗадачуПоОбработкеДокументаНаСервере(Контекст)
	// ПроцессыОбработкиДокументов
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ПроцессыОбработкиДокументовЗарплата") Тогда	
		МодульПроцессыОбработкиДокументовЗарплата = ОбщегоНазначения.ОбщийМодуль("ПроцессыОбработкиДокументовЗарплата");
		МодульПроцессыОбработкиДокументовЗарплата.ВыполнитьЗадачу(ЭтотОбъект, Контекст, Объект);
	КонецЕсли;		
	// Конец ПроцессыОбработкиДокументов
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КомментарийНаправившегоОткрытие(Элемент, СтандартнаяОбработка)
	// ПроцессыОбработкиДокументов
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ПроцессыОбработкиДокументовЗарплата") Тогда	
		МодульПроцессыОбработкиДокументовЗарплата = ОбщегоНазначенияКлиент.ОбщийМодуль("ПроцессыОбработкиДокументовЗарплатаКлиент");
		МодульПроцессыОбработкиДокументовЗарплата.КомментарийНаправившегоОткрытие(ЭтотОбъект, Элемент, СтандартнаяОбработка);
	КонецЕсли;		
	// Конец ПроцессыОбработкиДокументов
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КомментарийСледующемуНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	// ПроцессыОбработкиДокументов
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ПроцессыОбработкиДокументовЗарплата") Тогда	
		МодульПроцессыОбработкиДокументовЗарплата = ОбщегоНазначенияКлиент.ОбщийМодуль("ПроцессыОбработкиДокументовЗарплатаКлиент");
		МодульПроцессыОбработкиДокументовЗарплата.КомментарийСледующемуНачалоВыбора(ЭтотОбъект, Элемент, ДанныеВыбора, СтандартнаяОбработка);
	КонецЕсли;		
	// Конец ПроцессыОбработкиДокументов
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.Свойства 
&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

&НаКлиенте
Процедура ОбработчикОжиданияМесяцРасчетногоПериодаПриИзменении()

	ОбработатьИзменениеМесяцРасчетногоПериодаНаСервере();

КонецПроцедуры

&НаСервере
Процедура ПриПолученииДанныхНаСервере()
	
	ЗарплатаКадрыКлиентСервер.ЗаполнитьМесяцПоДате(ЭтаФорма, "Объект.МесяцРасчетногоПериода", "МесяцРасчетногоПериодаСтрокой");
	ОбработатьИзменениеМесяцРасчетногоПериодаНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьФункциональныеОпцииФормы()

	ПараметрыФО = Новый Структура;
	ПараметрыФО.Вставить("Организация", Объект.Организация);
	ПараметрыФО.Вставить("Период", НачалоДня(Объект.МесяцРасчетногоПериода));
	УстановитьПараметрыФункциональныхОпцийФормы(ПараметрыФО);

КонецПроцедуры

&НаСервере
Процедура ОбработатьИзменениеОрганизацииНаСервере()

	УстановитьФункциональныеОпцииФормы();

КонецПроцедуры

&НаСервере
Процедура ОбработатьИзменениеМесяцРасчетногоПериодаНаСервере()

	УстановитьФункциональныеОпцииФормы();
	
	УчетСтраховыхВзносов.УстановитьВидимостьКолонокТаблицыСтраховыхВзносов(ЭтаФорма, ДобавитьМесяц(Объект.МесяцРасчетногоПериода, 6), "");
	
	ЗаголовокОПС =  ?(Объект.МесяцРасчетногоПериода < УчетСтраховыхВзносов.ДатаОбъединенияВзносов(), НСтр("ru = 'ПФР на ОПС';
																											|en = 'Pension Fund for Mandatory Pension Insurance'"), НСтр("ru = 'По единому тарифу';
																																	|en = 'At joint rate'"));
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ПФРГруппа", "Заголовок", ЗаголовокОПС);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ГруппаПособияПоСоциальномуСтрахованию", "Видимость", Объект.МесяцРасчетногоПериода < УчетСтраховыхВзносов.ДатаОбъединенияВзносов());
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ГруппаПособияПоУходуЗаРебенком", "Видимость", Объект.МесяцРасчетногоПериода < УчетСтраховыхВзносов.ДатаОбъединенияВзносов());
	
КонецПроцедуры

#КонецОбласти
