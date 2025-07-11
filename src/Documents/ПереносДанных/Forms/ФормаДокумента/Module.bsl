
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Ключ.Пустая() Тогда
		
		ЗначенияДляЗаполнения = Новый Структура("Организация, Ответственный, Месяц", 
		"Объект.Организация",
		"Объект.Ответственный",
		"Объект.ПериодРегистрации");
		ЗарплатаКадры.ЗаполнитьПервоначальныеЗначенияВФорме(ЭтаФорма, ЗначенияДляЗаполнения);
		
		ЗарплатаКадрыКлиентСервер.ЗаполнитьМесяцПоДате(ЭтаФорма, "Объект.ПериодРегистрации", "МесяцНачисленияСтрокой");
		ЗарплатаКадрыРасширенный.УстановитьНаименованиеПервичногоДокумента(Объект);
		ЗарплатаКадрыРасширенныйКлиентСервер.УстановитьОтображениеРеквизитовПервичногоДокумента(ЭтотОбъект);
		
	КонецЕсли;
	
	// Обработчик подсистемы "ВерсионированиеОбъектов".
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	ПоказатьРегистры();
	
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

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	ЗарплатаКадрыКлиентСервер.ЗаполнитьМесяцПоДате(ЭтаФорма, "Объект.ПериодРегистрации", "МесяцНачисленияСтрокой");
	ЗарплатаКадрыРасширенныйКлиентСервер.УстановитьОтображениеРеквизитовПервичногоДокумента(ЭтотОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
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

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("ЗаписьДокумента", Объект.Ссылка);
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

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	ПерерасчетЗарплаты.РегистрацияПерерасчетовПоПредварительнымДаннымВФоне(ТекущийОбъект.Ссылка);
	ЗарплатаКадрыРасширенныйКлиентСервер.УстановитьОтображениеРеквизитовПервичногоДокумента(ЭтотОбъект);
	
	// ПроцессыОбработкиДокументов
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ПроцессыОбработкиДокументовЗарплата") Тогда
		МодульПроцессыОбработкиДокументовЗарплата = ОбщегоНазначения.ОбщийМодуль("ПроцессыОбработкиДокументовЗарплата");
		МодульПроцессыОбработкиДокументовЗарплата.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	КонецЕсли;	
	// Конец ПроцессыОбработкиДокументов
	
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
	
&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры
	
#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

#Область РедактированиеМесяцаСтрокой

&НаКлиенте
Процедура МесяцНачисленияСтрокойПриИзменении(Элемент)
	
	ЗарплатаКадрыКлиент.ВводМесяцаПриИзменении(ЭтаФорма, "Объект.ПериодРегистрации", "МесяцНачисленияСтрокой", Модифицированность);
	
КонецПроцедуры

&НаКлиенте
Процедура МесяцНачисленияСтрокойНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ВводМесяцаНачалоВыбора(ЭтаФорма, ЭтаФорма, "Объект.ПериодРегистрации", "МесяцНачисленияСтрокой");
	
КонецПроцедуры

&НаКлиенте
Процедура МесяцНачисленияСтрокойРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ВводМесяцаРегулирование(ЭтаФорма, "Объект.ПериодРегистрации", "МесяцНачисленияСтрокой", Направление, Модифицированность);
	
КонецПроцедуры

&НаКлиенте
Процедура МесяцНачисленияСтрокойАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ВводМесяцаАвтоПодборТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура МесяцНачисленияСтрокойОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ВводМесяцаОкончаниеВводаТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	ЗарплатаКадрыРасширенныйКлиентСервер.УстановитьОтображениеРеквизитовПервичногоДокумента(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура НомерПриИзменении(Элемент)
	ЗарплатаКадрыРасширенныйКлиентСервер.УстановитьОтображениеРеквизитовПервичногоДокумента(ЭтотОбъект);
КонецПроцедуры

#Область РеквизитыПервичногоДокумента

&НаКлиенте
Процедура НаименованиеПервичногоДокументаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ОткрытьФормуСпискаЗначенийСтроковогоРеквизита(Элемент, 
		СтандартнаяОбработка, "ПервичныйДокумент", НСтр("ru = 'Первичные документы';
														|en = 'Source documents'"), НСтр("ru = 'Первичный документ';
																							|en = 'Source document'"));
		
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеПервичногоДокументаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Строка") Тогда
		Объект.НаименованиеПервичногоДокумента = ВыбранноеЗначение;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура НаименованиеПервичногоДокументаАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ПодборЗначенияСтроковогоРеквизита(Текст, ДанныеВыбора, СтандартнаяОбработка, "ПервичныйДокумент");
КонецПроцедуры

&НаКлиенте
Процедура ДатаПервичногоДокументаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	Оповещение = Новый ОписаниеОповещения("ДатаПервичногоДокументаНачалоВыбораЗавершение", ЭтотОбъект);
	ПоказатьВводДаты(Оповещение, ?(ЗначениеЗаполнено(Объект.ДатаПервичногоДокумента), Объект.ДатаПервичногоДокумента, Объект.Дата), НСтр("ru = 'Дата первичного документа';
																																		|en = 'Source document date'"), ЧастиДаты.Дата);
КонецПроцедуры

&НаКлиенте
Процедура ДатаПервичногоДокументаНачалоВыбораЗавершение(Дата, ДополнительныеПараметры) Экспорт
	
	Если ЗначениеЗаполнено(Дата) Тогда
		Объект.ДатаПервичногоДокумента = Дата;
		ДатаПервичногоДокументаПредставление = Формат(Дата,"ДФ=dd.MM.yyyy");
		Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаПервичногоДокументаОчистка(Элемент, СтандартнаяОбработка)
	Объект.ДатаПервичногоДокумента = Дата(1,1,1);
	Модифицированность = Истина;
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура НастройкаСоставаРегистров(Команда)
	
	СписокИспользуемыхРегистров = Новый СписокЗначений;
	
	Для Каждого Строка Из Объект.ТаблицаРегистров Цикл
		СписокИспользуемыхРегистров.Добавить(Строка.Имя);
	КонецЦикла;
	
	Оповещение = Новый ОписаниеОповещения("НастройкаСоставаРегистровЗавершение", ЭтотОбъект);
	ОткрытьФорму("Документ.ПереносДанных.Форма.ФормаВыбораРегистра",
		Новый Структура("СписокИспользуемыхРегистров", СписокИспользуемыхРегистров), , , , , 
		Оповещение, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкаСоставаРегистровЗавершение(Результат, ДополнительныеПараметры) Экспорт 
	
	Если ТипЗнч(Результат) = Тип("СписокЗначений") Тогда
		ОбработатьИзменениеРегистров(Результат);
	КонецЕсли;
	
КонецПроцедуры

// СтандартныеПодсистемы.Свойства
&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

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

&НаСервере
Функция СоздатьСтраницу(ИмяСтраницы, Заголовок, Родитель)
	
	НовыйЭлемент = Элементы.Добавить(ИмяСтраницы, Тип("ГруппаФормы"), Родитель);
	НовыйЭлемент.Вид                      = ВидГруппыФормы.Страница;
	НовыйЭлемент.Заголовок                = Заголовок;
	НовыйЭлемент.РастягиватьПоВертикали   = Истина;
	НовыйЭлемент.РастягиватьПоГоризонтали = Истина;
	
	Возврат НовыйЭлемент;
	
КонецФункции

&НаСервере
Функция ПолучитьИмяСтраницыРегистра(ИмяРегистра)
	
	Возврат "Страница" + ИмяРегистра;
	
КонецФункции

&НаСервере
Процедура УдалитьСтраницуРегистра(ИмяРегистра)
	
	Элементы.Удалить(Элементы.Найти(ПолучитьИмяСтраницыРегистра(ИмяРегистра)));
	
КонецПроцедуры

&НаСервере
Функция СоздатьСвязиПараметровВыбора(ИсходныйМассив, ПутьКДанным)
	
	НовыйМассив = Новый Массив;
	Для Каждого Элемент Из ИсходныйМассив Цикл
		
		НовыйМассив.Добавить(Новый СвязьПараметраВыбора(Элемент.Имя, ПутьКДанным + "." + Элемент.ПутьКДанным, Элемент.ИзменениеЗначения));
		
	КонецЦикла;
	
	Возврат Новый ФиксированныйМассив(НовыйМассив);
	
КонецФункции

&НаСервере
// Процедура создает таблицу формы.
//
Функция СоздатьТаблицуФормыРегистра(ИмяРегистра, КолонкиТаблицы, Родитель)
	
	ТаблицаФормы = Элементы.Добавить("ТаблицаДвижений" + ИмяРегистра, Тип("ТаблицаФормы"), Родитель);
	ТаблицаФормы.ПутьКДанным      = "Объект.Движения." + ИмяРегистра;
	Родитель.ПутьКДаннымЗаголовка = ТаблицаФормы.ПутьКДанным + ".КоличествоСтрок";
	
	МассивДобавленныхПолей = Новый Массив;
	Для Каждого Колонка Из КолонкиТаблицы Цикл
		
		ПолеФормы = Элементы.Добавить(ТаблицаФормы.Имя + Колонка.Имя, Тип("ПолеФормы"), ТаблицаФормы);
		ПолеФормы.ПутьКДанным           = ТаблицаФормы.ПутьКДанным + "." + Колонка.Имя;
		ПолеФормы.Заголовок             = Колонка.Заголовок;
		ПолеФормы.Вид                   = ВидПоляФормы.ПолеВвода;
		
		МассивДобавленныхПолей.Добавить(ПолеФормы);
		
	КонецЦикла;
	
	Счетчик = 0;
	Для Каждого ПолеФормы Из МассивДобавленныхПолей Цикл
		
		Если КолонкиТаблицы[Счетчик].СвязиПараметровВыбора <> Неопределено И  КолонкиТаблицы[Счетчик].СвязиПараметровВыбора.Количество() > 0 Тогда
			
			ПолеФормы.СвязиПараметровВыбора = СоздатьСвязиПараметровВыбора(КолонкиТаблицы[Счетчик].СвязиПараметровВыбора,
				"Элементы." + ТаблицаФормы.Имя + ".ТекущиеДанные");
			
		КонецЕсли;
		
		Если КолонкиТаблицы[Счетчик].ПараметрыВыбора <> Неопределено Тогда
			ПолеФормы.ПараметрыВыбора = КолонкиТаблицы[Счетчик].ПараметрыВыбора;
		КонецЕсли;
		
		Счетчик = Счетчик + 1;
		
	КонецЦикла;
	
	Возврат ТаблицаФормы;
	
КонецФункции

&НаСервере
// Функция создает таблицу значений по регистру.
//
Функция СоздатьМассивПолейРегистра(МенеджерРегистра, МетаданныеРегистра)
	
	ТаблицаРегистра = МенеджерРегистра.СоздатьНаборЗаписей().ВыгрузитьКолонки();
	ТаблицаРегистра.Колонки.Удалить("Регистратор");
	Если ТаблицаРегистра.Колонки.Найти("МоментВремени") <> Неопределено Тогда
		ТаблицаРегистра.Колонки.Удалить("МоментВремени");
	КонецЕсли;
	
	МассивКолонок = Новый Массив;
	Для Каждого Колонка Из ТаблицаРегистра.Колонки Цикл
		
		ИнформацияОКолонке = Новый Структура("Имя, Заголовок, СвязиПараметровВыбора,ПараметрыВыбора",
		Колонка.Имя);
		
		МассивКолонок.Добавить(ИнформацияОКолонке);
		
	КонецЦикла;
	
	// Обновление заголовков колонок таблицы по синонимам полей регистра.
	МассивПолейРегистра = Новый Массив;
	МассивПолейРегистра.Добавить("Измерения");
	МассивПолейРегистра.Добавить("Ресурсы");
	МассивПолейРегистра.Добавить("Реквизиты");
	
	Для Каждого ВидПоля Из МассивПолейРегистра Цикл
		Для Каждого Поле Из МетаданныеРегистра[ВидПоля] Цикл
			Для Каждого ЭлементМассива Из МассивКолонок Цикл
				
				Если ЭлементМассива.Имя = Поле.Имя Тогда
					
					ЭлементМассива.Заголовок             = Поле.Синоним;
					ЭлементМассива.СвязиПараметровВыбора = Поле.СвязиПараметровВыбора;
					
					Если Поле.Тип.СодержитТип(Тип("СправочникСсылка.Сотрудники")) Тогда
						ПараметрыВыбораПоля = Новый Массив;
						ПараметрыВыбораПоля.Добавить(Новый ПараметрВыбора("Отбор.ПоказыватьДоговорниковГПХ", Истина));
						ЭлементМассива.ПараметрыВыбора = Новый ФиксированныйМассив(ПараметрыВыбораПоля);
					КонецЕсли;
					
				КонецЕсли;
				
			КонецЦикла;
		КонецЦикла;
	КонецЦикла;
	
	Возврат МассивКолонок;
	
КонецФункции

&НаСервере
// Процедура управляет созданием таблицы на форме для регистра.
//
Процедура ПоказатьТаблицуРегистраНаСтранице(Знач СтрокаТЧ)
	
	Если Метаданные.РегистрыРасчета.Найти(СтрокаТЧ.Имя) <> Неопределено Тогда
		
		СтраницаРегистра      = Элементы.НастройкаРегистровРасчета;
		МенеджерРегистра      = РегистрыРасчета[СтрокаТЧ.Имя];
		МетаданныеРегистра    = Метаданные.РегистрыРасчета[СтрокаТЧ.Имя];
		РегистрИмеетПолеПериод= Ложь;
		
	ИначеЕсли Метаданные.РегистрыНакопления.Найти(СтрокаТЧ.Имя) <> Неопределено Тогда
		
		СтраницаРегистра      = Элементы.НастройкаРегистровНакопления;
		МенеджерРегистра      = РегистрыНакопления[СтрокаТЧ.Имя];
		МетаданныеРегистра    = Метаданные.РегистрыНакопления[СтрокаТЧ.Имя];
		РегистрИмеетПолеПериод= Истина;
		
	ИначеЕсли Метаданные.РегистрыСведений.Найти(СтрокаТЧ.Имя) <> Неопределено Тогда
		
		СтраницаРегистра      = Элементы.НастройкаРегистровСведений;
		МенеджерРегистра      = РегистрыСведений[СтрокаТЧ.Имя];
		МетаданныеРегистра    = Метаданные.РегистрыСведений[СтрокаТЧ.Имя];
		
		РегистрИмеетПолеПериод = МетаданныеРегистра.ПериодичностьРегистраСведений 
		<> Метаданные.СвойстваОбъектов.ПериодичностьРегистраСведений.Непериодический;
		
	Иначе
		
		Возврат;
		
	КонецЕсли;
	
	МассивКолонок = СоздатьМассивПолейРегистра(МенеджерРегистра, МетаданныеРегистра);
	
	СтраницаДляРегистра = СоздатьСтраницу(ПолучитьИмяСтраницыРегистра(СтрокаТЧ.Имя),
		МетаданныеРегистра.Синоним, СтраницаРегистра);
	
	ТаблицаФормы = СоздатьТаблицуФормыРегистра(СтрокаТЧ.Имя, МассивКолонок, СтраницаДляРегистра);
	
	Если РегистрИмеетПолеПериод Тогда
		ТаблицаФормы.УстановитьДействие("ПриНачалеРедактирования", "Подключаемый_ТаблицаПриНачалеРедактирования");
	КонецЕсли;
	
КонецПроцедуры

// Подключаемый обработчик события "ПриНачалеРедактирования" таблицы формы.
//
&НаКлиенте
Процедура Подключаемый_ТаблицаПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока Тогда
		Элемент.ТекущиеДанные.Период = Объект.Дата;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПоказатьРегистры()
	
	ПоказыватьФлагНалогСОтсроченнойУплатой = Ложь;
	СтрокаРегистров = "СведенияОДоходахНДФЛ,РасчетыНалогоплательщиковСБюджетомПоНДФЛ,РасчетыНалоговыхАгентовСБюджетомПоНДФЛ";
	Для Каждого СтрокаТаб Из Объект.ТаблицаРегистров Цикл
		ПоказатьТаблицуРегистраНаСтранице(СтрокаТаб);
		ПоказыватьФлагНалогСОтсроченнойУплатой = (СтрНайти(СтрокаРегистров,СтрокаТаб.Имя)>0);
	КонецЦикла;
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "НалогСОтсроченнойУплатой", "Видимость" , ПоказыватьФлагНалогСОтсроченнойУплатой);
	
КонецПроцедуры

&НаСервере
// Процедура служит для включения/исключение регистров из списка редактируемых.
//
Процедура ОбработатьИзменениеРегистров(СписокРегистров)
	
	Для Каждого Элемент Из СписокРегистров Цикл
		
		// Нужно добавить новый регистр.
		Если Элемент.Пометка Тогда
			
			СтрокаТЧ = Объект.ТаблицаРегистров.Добавить();
			СтрокаТЧ.Имя = Элемент.Значение;
			
			ПоказатьТаблицуРегистраНаСтранице(СтрокаТЧ);
			
		Иначе
			
			Для Каждого Строка Из Объект.ТаблицаРегистров.НайтиСтроки(Новый Структура("Имя", Элемент.Значение)) Цикл
				Объект.ТаблицаРегистров.Удалить(Строка);
			КонецЦикла;
			
			Объект.Движения[Элемент.Значение].Очистить();
			УдалитьСтраницуРегистра(Элемент.Значение);
			
		КонецЕсли;
		
	КонецЦикла;
	
	Модифицированность = Истина;
	
КонецПроцедуры

#КонецОбласти
