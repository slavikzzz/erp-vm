
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Ключ.Пустая() Тогда
		
		// Создается новый документ.
		Объект.Статус = Перечисления.СтатусыЛистковСообщения.НеВрученСотруднику;
		
		ЗначенияДляЗаполнения = Новый Структура("Организация, Ответственный", "Объект.Организация", "Объект.Ответственный");
		ЗарплатаКадры.ЗаполнитьПервоначальныеЗначенияВФорме(ЭтаФорма, ЗначенияДляЗаполнения);
		
		ПриПолученииДанныхНаСервере("Объект");
		
		Если ЗначениеЗаполнено(Объект.Сотрудник) Тогда
			ОбновитьВторичныеДанныеДокумента();
		КонецЕсли; 
		
	КонецЕсли;
	
	// Обработчик подсистемы "ВерсионированиеОбъектов".
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
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
	
	// ИнтеграцияС1СДокументооборотом
	Если ОбщегоНазначения.ПодсистемаСуществует("ИнтеграцияС1СДокументооборотом") Тогда
		МодульИнтеграцияС1СДокументооборотБазоваяФункциональность = ОбщегоНазначения.ОбщийМодуль(
			"ИнтеграцияС1СДокументооборотБазоваяФункциональность");
		МодульИнтеграцияС1СДокументооборотБазоваяФункциональность.ПриСозданииНаСервере(ЭтотОбъект);
	КонецЕсли;
	// Конец ИнтеграцияС1СДокументооборотом
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПриПолученииДанныхНаСервере(ТекущийОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// ПроцессыОбработкиДокументов
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ПроцессыОбработкиДокументовЗарплата") Тогда
		МодульПроцессыОбработкиДокументовЗарплата = ОбщегоНазначения.ОбщийМодуль("ПроцессыОбработкиДокументовЗарплата");
		МодульПроцессыОбработкиДокументовЗарплата.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;	
	// Конец ПроцессыОбработкиДокументов
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ФиксацияВторичныхДанныхВДокументахКлиентСервер.СохранитьРеквизитыФормыФикс(ЭтаФорма, ТекущийОбъект);
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	// ПроцессыОбработкиДокументов
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ПроцессыОбработкиДокументовЗарплата") Тогда
		МодульПроцессыОбработкиДокументовЗарплата = ОбщегоНазначения.ОбщийМодуль("ПроцессыОбработкиДокументовЗарплата");
		МодульПроцессыОбработкиДокументовЗарплата.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи, Отказ);
	КонецЕсли;		
	// Конец ПроцессыОбработкиДокументов
	
	// ИнтеграцияС1СДокументооборотом
	Если ОбщегоНазначения.ПодсистемаСуществует("ИнтеграцияС1СДокументооборотом") Тогда
		МодульИнтеграцияС1СДокументооборотБазоваяФункциональность = ОбщегоНазначения.ОбщийМодуль(
			"ИнтеграцияС1СДокументооборотБазоваяФункциональность");
		МодульИнтеграцияС1СДокументооборотБазоваяФункциональность.ПередЗаписьюНаСервере(
			ЭтотОбъект,
			ТекущийОбъект,
			ПараметрыЗаписи);
	КонецЕсли;
	// Конец ИнтеграцияС1СДокументооборотом
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	ФиксацияУстановитьОбъектЗафиксирован();
	УстановитьДоступностьЭлементов(ЭтаФорма);
	
	// ПроцессыОбработкиДокументов
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ПроцессыОбработкиДокументовЗарплата") Тогда
		МодульПроцессыОбработкиДокументовЗарплата = ОбщегоНазначения.ОбщийМодуль("ПроцессыОбработкиДокументовЗарплата");
		МодульПроцессыОбработкиДокументовЗарплата.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	КонецЕсли;	
	// Конец ПроцессыОбработкиДокументов
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("Запись_ЛистокСообщенияДляВоенкомата", ПараметрыЗаписи, Объект.Ссылка);
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
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры
	
#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	
	ОбновитьВторичныеДанныеДокумента();
	
КонецПроцедуры

&НаКлиенте
Процедура СотрудникПриИзменении(Элемент)
	
	ОбновитьВторичныеДанныеДокумента();
	
КонецПроцедуры

&НаКлиенте
Процедура ЛистокВыданПриИзменении(Элемент)
	
	УстановитьСтатус(ЛистокВыдан);
	
КонецПроцедуры

&НаКлиенте
Процедура КорешокЛисткаПолученПриИзменении(Элемент)
	
	ИндексСобытия = ?(КорешокЛисткаПолучен, 2, 1);
	
	УстановитьСтатус(ИндексСобытия);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.Свойства
&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

&НаКлиенте
Процедура ОтменитьВсеИсправления(Команда)
	
	ОтменитьВсеИсправленияНаСервере();
	
	УстановитьИнфонадписьИсправления(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура РедактироватьКарточкуСотрудника(Команда)
	
	Если ЗначениеЗаполнено(Объект.Сотрудник) Тогда
		ПараметрыФормы = Новый Структура("Ключ", Объект.Сотрудник);
		ОткрытьФорму("Справочник.Сотрудники.ФормаОбъекта", ПараметрыФормы);
	КонецЕсли;	
	
КонецПроцедуры

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

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ИнтеграцияС1СДокументооборотом") Тогда
		МодульИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль(
			"ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент");
		МодульИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(
			Команда,
			ЭтотОбъект,
			Объект);
	КонецЕсли;
	
КонецПроцедуры
// Конец ИнтеграцияС1СДокументооборотом

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
Процедура ПриПолученииДанныхНаСервере(ТекущийОбъект)
	
	ФиксацияВторичныхДанныхВДокументахФормы.ИнициализироватьМеханизмФиксацииРеквизитов(ЭтаФорма, ТекущийОбъект);
	ФиксацияВторичныхДанныхВДокументахФормы.ПодключитьОбработчикиФиксацииИзмененийРеквизитов(ЭтотОбъект, ФиксацияЭлементыОбработчикаЗафиксироватьИзменение());

	ОбновитьВторичныеДанныеДокумента();
	ФиксацияОбновитьФиксациюВФорме();
	
	ПрочитатьДанные();
	
	УстановитьЗначенияРеквизитовПоСтатусу(ЭтаФорма);
	
	УстановитьИнфонадписьИсправления(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ПрочитатьДанные()
	
	ФизическоеЛицоСсылка = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.Сотрудник, "ФизическоеЛицо");
	
	СведенияОСемье = Документы.ЛистокСообщенияДляВоенкомата.СведенияОСоставеСемьи(ФизическоеЛицоСсылка);
	
	Если ЗначениеЗаполнено(СведенияОСемье.СоставСемьиПолный) Тогда 
		ЭтаФорма.СоставСемьиСправочно = НСтр("ru = 'Состав семьи по карточке Т-2';
											|en = 'Family structure according to T-2 card'") + ": " + Символы.ПС + СведенияОСемье.СоставСемьиПолный;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатус(ИндексСобытия)
	
	Если ИндексСобытия = 2 Тогда 
		Объект.Статус = ПредопределенноеЗначение("Перечисление.СтатусыЛистковСообщения.ПредъявленКорешок");
	ИначеЕсли ИндексСобытия = 1 Тогда 
		Объект.Статус = ПредопределенноеЗначение("Перечисление.СтатусыЛистковСообщения.ВрученСотруднику");
	Иначе 
		Объект.Статус = ПредопределенноеЗначение("Перечисление.СтатусыЛистковСообщения.НеВрученСотруднику");
	КонецЕсли;
	
	УстановитьЗначенияРеквизитовПоСтатусу(ЭтаФорма);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьЗначенияРеквизитовПоСтатусу(Форма)
	
	Если Форма.Объект.Статус = ПредопределенноеЗначение("Перечисление.СтатусыЛистковСообщения.ПредъявленКорешок") Тогда 
		
		Форма.КорешокЛисткаПолучен = Истина;
		Форма.ЛистокВыдан = 1;
		
		Если Форма.Объект.ПричинаНевручения <> "" Тогда 
			Форма.Объект.ПричинаНевручения = "";
		КонецЕсли;
		
	ИначеЕсли Форма.Объект.Статус =  ПредопределенноеЗначение("Перечисление.СтатусыЛистковСообщения.ВрученСотруднику") Тогда 
		
		Форма.КорешокЛисткаПолучен = Ложь;
		Форма.ЛистокВыдан = 1;
		
		Если Форма.Объект.ПричинаНевручения <> "" Тогда 
			Форма.Объект.ПричинаНевручения = "";
		КонецЕсли;
		
	Иначе
		
		Форма.КорешокЛисткаПолучен = Ложь;
		Форма.ЛистокВыдан = 0;
		
		Если Форма.Объект.ДатаВрученияСотруднику <> '00010101' Тогда 
			Форма.Объект.ДатаВрученияСотруднику = '00010101';
		КонецЕсли;
		
	КонецЕсли;
	
	УстановитьДоступностьЭлементов(Форма);
	
КонецПроцедуры	

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДоступностьЭлементов(Форма)
	
	Если Форма.Объект.Статус = ПредопределенноеЗначение("Перечисление.СтатусыЛистковСообщения.НеВрученСотруднику") Тогда 
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Форма.Элементы, "ДатаВрученияСотруднику", "Доступность", Ложь);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Форма.Элементы, "ПричинаНевручения", "Доступность", Истина);
	Иначе 
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Форма.Элементы, "ДатаВрученияСотруднику", "Доступность", Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Форма.Элементы, "ПричинаНевручения", "Доступность", Ложь);
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Форма.Элементы, "Шапка", "ТолькоПросмотр", Форма.Объект.Проведен);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Форма.Элементы, "СтраницаСведенияОСотруднике", "ТолькоПросмотр", Форма.Объект.Проведен);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Форма.Элементы, "ОтветственныйЗаВУР", "ТолькоПросмотр", Форма.Объект.Проведен);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Форма.Элементы, "Ответственный", "ТолькоПросмотр", Форма.Объект.Проведен);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Форма.Элементы, "ОтменитьВсеИсправления", "Доступность", Не Форма.Объект.Проведен);

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьИнфонадписьИсправления(Форма)

	ФиксируемыеПоля = ИменаФиксируемыхПолей();
	
	ЕстьЗафиксированныеДанные = Ложь;
	Для Каждого ИмяПоля Из ФиксируемыеПоля Цикл
		Если Форма[ИмяПоля + "Фикс"] Тогда	
			ЕстьЗафиксированныеДанные = Истина;
		КонецЕсли;	
	КонецЦикла;	
	
	Если ЕстьЗафиксированныеДанные Тогда
		ТекстПодсказки = НСтр("ru = 'Выделенные жирным шрифтом данные были зафиксированы в документе и могут отличаться от данных в карточке сотрудника.';
								|en = 'The data shown in bold type was recorded in the document and may differ from information in the employee card.'");	
		ЗарплатаКадрыКлиентСервер.УстановитьРасширеннуюПодсказкуЭлементуФормы(Форма, "ОтменитьВсеИсправления", ТекстПодсказки);
		Форма.ИнфоНадписьИсправленияКрасным = Истина;
	Иначе						   
		ТекстПодсказки = НСтр("ru = 'Данные о гражданине заполняются по личной карточке автоматически.';
								|en = 'Person data is filled in automatically according to the employee data card.'");
		ЗарплатаКадрыКлиентСервер.УстановитьРасширеннуюПодсказкуЭлементуФормы(Форма, "ОтменитьВсеИсправления", ТекстПодсказки);
		Форма.ИнфоНадписьИсправленияКрасным = Ложь;
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ИменаФиксируемыхПолей() Экспорт
	
	ЗаполняемыеПоля = Новый Массив;
	ЗаполняемыеПоля.Добавить("Подразделение");
	ЗаполняемыеПоля.Добавить("ДатаРождения");
	ЗаполняемыеПоля.Добавить("Звание");
	ЗаполняемыеПоля.Добавить("ВУС");
	ЗаполняемыеПоля.Добавить("Образование");
	ЗаполняемыеПоля.Добавить("Должность");
	ЗаполняемыеПоля.Добавить("АдресМестаПроживанияПредставление");
	ЗаполняемыеПоля.Добавить("СемейноеПоложение");
	ЗаполняемыеПоля.Добавить("СоставСемьи");
	ЗаполняемыеПоля.Добавить("ОтветственныйЗаВУР");
	
	Возврат ЗаполняемыеПоля;
	
КонецФункции	

#КонецОбласти

#Область МеханизмФиксацииИзменений

&НаСервере
Функция ФиксацияОписаниеФормы(ПараметрыФиксацииВторичныхДанных) Экспорт
	
	ОписаниеФормы = ФиксацияВторичныхДанныхВДокументахФормы.ОписаниеФормы();
	
	ОписаниеЭлементовФормы = Новый Соответствие();
	ОписаниеЭлементаФормы = ФиксацияВторичныхДанныхВДокументахФормы.ОписаниеЭлементаФормы();
	
	ОписаниеЭлементаФормы.ПрефиксПути = "Объект";
	
	Для каждого ОписаниеФиксацииРеквизита Из ПараметрыФиксацииВторичныхДанных.ОписаниеФиксацииРеквизитов Цикл
		ОписаниеЭлементовФормы.Вставить(ОписаниеФиксацииРеквизита.Ключ, ОписаниеЭлементаФормы);
	КонецЦикла;
	
	ОписаниеФормы.Вставить("ОписаниеЭлементовФормы", ОписаниеЭлементовФормы);
	
	Возврат ОписаниеФормы;
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ФиксацияЭлементыОбработчикаЗафиксироватьИзменение()
	
	ОписаниеЭлементов = Новый Соответствие;
	ОписаниеЭлементов.Вставить("АдресМестаПроживанияПредставление",	"АдресМестаПроживанияПредставление");
	ОписаниеЭлементов.Вставить("Подразделение",						"Подразделение");
	ОписаниеЭлементов.Вставить("Должность",							"Должность");
	ОписаниеЭлементов.Вставить("Звание",							"Звание");
	ОписаниеЭлементов.Вставить("ВУС",								"ВУС");
	ОписаниеЭлементов.Вставить("ДатаРождения",						"ДатаРождения");
	ОписаниеЭлементов.Вставить("СемейноеПоложение",					"СемейноеПоложение");
	ОписаниеЭлементов.Вставить("Образование",						"Образование");
	ОписаниеЭлементов.Вставить("СоставСемьи",						"СоставСемьи");
	ОписаниеЭлементов.Вставить("ОтветственныйЗаВУР",				"ОтветственныйЗаВУР");

	Возврат	ОписаниеЭлементов
КонецФункции

&НаСервере
Процедура ФиксСброситьФиксациюИзмененийРеквизитовПоОснованиюЗаполнения(ОснованиеЗаполнения, ТекущаяСтрока = 0)
	ФиксацияВторичныхДанныхВДокументахКлиентСервер.СброситьФиксациюИзмененийРеквизитовПоОснованиюЗаполнения(ЭтаФорма, ОснованиеЗаполнения)
КонецПроцедуры

&НаСервере
Процедура ОчиститьФиксациюИзменений()
	ФиксСброситьФиксациюИзмененийРеквизитовПоОснованиюЗаполнения("Сотрудник");
КонецПроцедуры

&НаСервере
Процедура ФиксацияОбновитьФиксациюВФорме()
	ФиксацияВторичныхДанныхВДокументахКлиентСервер.ОбновитьФорму(ЭтаФорма);
КонецПроцедуры

&НаСервере
Процедура ОтменитьВсеИсправленияНаСервере()

	ОчиститьФиксациюИзменений();
	ОбновитьВторичныеДанныеДокумента();
	ФиксацияОбновитьФиксациюВФорме();	
	
КонецПроцедуры

&НаСервере
Процедура ФиксацияЗаполнитьРеквизитыФормыФикс(ТекущийОбъект)
	ФиксацияВторичныхДанныхВДокументахФормы.ЗаполнитьРеквизитыФормыФикс(ЭтаФорма, ТекущийОбъект);
КонецПроцедуры	

&НаКлиентеНаСервереБезКонтекста
Процедура ФиксацияЗаполнитьИдентификаторыФиксТЧ(Форма)
	ФиксацияВторичныхДанныхВДокументахКлиентСервер.ЗаполнитьИдентификаторыСтрок(Форма);
КонецПроцедуры

&НаСервере
Процедура ФиксацияСохранитьРеквизитыФормыФикс(Форма, ТекущийОбъект)   
	ФиксацияВторичныхДанныхВДокументахКлиентСервер.СохранитьРеквизитыФормыФикс(Форма, ТекущийОбъект);
КонецПроцедуры

&НаСервере
Функция ФиксацияПодготовленныйДокумент()
	
	ФиксацияЗаполнитьИдентификаторыФиксТЧ(ЭтаФорма);
	ПодготовленныйДокумент = РеквизитФормыВЗначение("Объект");
	ФиксацияСохранитьРеквизитыФормыФикс(ЭтаФорма, ПодготовленныйДокумент);
	
	Возврат ПодготовленныйДокумент;
КонецФункции 

&НаСервере
Процедура ОбновитьВторичныеДанныеДокумента(ДанныеОрганизации = Истина, ДанныеСотрудника = Истина) Экспорт
	
	Если ФиксацияВторичныхДанныхВДокументахКлиентСервер.ОбъектФормыЗафиксирован(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Документ = ФиксацияПодготовленныйДокумент();
	
	Если Документ.ОбновитьВторичныеДанныеДокумента(ДанныеОрганизации, ДанныеСотрудника) Тогда
		Если НЕ Документ.ЭтоНовый() Тогда
			ФиксацияВторичныхДанныхВДокументахФормы.УстановитьМодифицированность(ЭтотОбъект, Истина);	
		КонецЕсли;		
		ЗначениеВРеквизитФормы(Документ, "Объект");
		ФиксацияЗаполнитьРеквизитыФормыФикс(Объект);
	КонецЕсли;
	
	
КонецПроцедуры

&НаСервере
Функция ОбъектЗафиксирован() Экспорт
	ДокументОбъект = РеквизитФормыВЗначение("Объект");
	
	Возврат ДокументОбъект.ОбъектЗафиксирован();
КонецФункции

&НаКлиенте
Процедура Подключаемый_ЗафиксироватьИзменениеРеквизитаВФорме(Элемент, СтандартнаяОбработка = Ложь) Экспорт
	ФиксацияВторичныхДанныхВДокументахКлиентСервер.Подключаемый_ЗафиксироватьИзменениеРеквизитаВФорме(ЭтаФорма, Элемент, ФиксацияЭлементыОбработчикаЗафиксироватьИзменение());
КонецПроцедуры

&НаСервере
Процедура ФиксацияУстановитьОбъектЗафиксирован();
	 ФиксацияВторичныхДанныхВДокументахФормы.УстановитьОбъектЗафиксирован(ЭтаФорма);
КонецПроцедуры

#КонецОбласти
