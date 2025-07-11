#Область ОписаниеПеременных

&НаКлиенте
Перем КэшированныеЗначения; //используется механизмом обработки изменения реквизитов ТЧ

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление(); 
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПриЧтенииСозданииНаСервере();
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	УстановитьДоступностьКомандБуфераОбмена();
	
	СобытияФорм.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
	// СтандартныеПодсистемы.Свойства
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Объект", Объект);
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	ДополнительныеПараметры.Вставить("ОтложеннаяИнициализация", Истина);
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект, ДополнительныеПараметры);
	// Конец СтандартныеПодсистемы.Свойства
	
	// Обработчик механизма "Назначения"
	Справочники.Назначения.ФормаДокументаПриСозданииНаСервере(ЭтотОбъект);
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.ТорговоеОборудование
	ОбщегоНазначенияУТ.НастроитьПодключаемоеОборудование(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ТорговоеОборудование
	
	// СтандартныеПодсистемы.РаботаСФайлами
	ПараметрыГиперссылки = РаботаСФайлами.ГиперссылкаФайлов();
	ПараметрыГиперссылки.Размещение = "КоманднаяПанель";
	РаботаСФайлами.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыГиперссылки);
	// Конец СтандартныеПодсистемы.РаботаСФайлами
	
	ИсправлениеДокументов.ПриСозданииНаСервере(ЭтотОбъект, Элементы.СтрокаИсправление);

	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец ИнтеграцияС1СДокументооборотом
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	ПриЧтенииСозданииНаСервере();
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	СобытияФорм.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	ИсправлениеДокументов.ПриЧтенииНаСервере(ЭтотОбъект, Элементы.СтрокаИсправление);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.ТорговоеОборудование
	МенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПриОткрытииФормы(Неопределено, ЭтотОбъект, "СканерШтрихкода");
	// Конец СтандартныеПодсистемы.ТорговоеОборудование
	
	// СтандартныеПодсистемы.РаботаСФайлами
	РаботаСФайламиКлиент.ПриОткрытии(ЭтотОбъект, Отказ);
	// Конец СтандартныеПодсистемы.РаботаСФайлами

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец ИнтеграцияС1СДокументооборотом
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Запись_АктВыполненныхВнутреннихРабот");
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульПодключаемыеКомандыКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ПодключаемыеКомандыКлиент");
		МодульПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	ИсправлениеДокументовКлиент.ПослеЗаписи(Объект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	// СтандартныеПодсистемы.ТорговоеОборудование
	МенеджерОборудованияКлиент.НачатьОтключениеОборудованиеПриЗакрытииФормы(Неопределено, ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ТорговоеОборудование
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если Окно <> Неопределено Тогда
		Окно.Активизировать();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// СтандартныеПодсистемы.Свойства
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтотОбъект, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.ПодключаемоеОборудование
	Если Источник = "ПодключаемоеОборудование" И ВводДоступен() Тогда
		Если ИмяСобытия = "ScanData" И МенеджерОборудованияУТКлиент.ЕстьНеобработанноеСобытие() Тогда
			ОбработатьШтрихкоды(МенеджерОборудованияУТКлиент.ПреобразоватьДанныеСоСканераВМассив(Параметр));
		КонецЕсли;
	КонецЕсли;
	
	// Неизвестные штрихкоды
	Если Источник = "ПодключаемоеОборудование"
		И ИмяСобытия = "НеизвестныеШтрихкоды"
		И Параметр.ФормаВладелец = УникальныйИдентификатор Тогда
		
		КэшированныеЗначения.Штрихкоды.Очистить();
		ДанныеШтрихкодов = Новый Массив;
		Для Каждого ПолученныйШтрихкод Из Параметр.ПолученыНовыеШтрихкоды Цикл
			ДанныеШтрихкодов.Добавить(ПолученныйШтрихкод);
		КонецЦикла;
		Для Каждого ПолученныйШтрихкод Из Параметр.ЗарегистрированныеШтрихкоды Цикл
			ДанныеШтрихкодов.Добавить(ПолученныйШтрихкод);
		КонецЦикла;
		
		ОбработатьШтрихкоды(ДанныеШтрихкодов);
		
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ПодключаемоеОборудование
	
	Если ИмяСобытия = "КопированиеСтрокВБуферОбмена" Тогда
		
		УстановитьДоступностьКомандБуфераОбменаНаКлиенте();
		
	КонецЕсли;
	
	СобытияФормКлиент.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	
	// СтандартныеПодсистемы.РаботаСФайлами
	РаботаСФайламиКлиент.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия);
	// Конец СтандартныеПодсистемы.РаботаСФайлами
	
	ИсправлениеДокументовКлиент.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	ОбеспечениеВДокументахСервер.ПроверитьЗапуститьФоновоеЗаданиеРаспределенияЗапасов();
	
	СобытияФорм.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	
	ДатаПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ХозяйственнаяОперацияПриИзменении(Элемент)
	
	Если Не ХозОперацияДоИзменения = Объект.ХозяйственнаяОперация Тогда
		ХозяйственнаяОперацияПриИзмененииНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПолучательПриИзменении(Элемент)
	ОрганизацияПолучательПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	ОрганизацияПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура НаправлениеДеятельностиПриИзменении(Элемент)
	НаправлениеДеятельностиПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ГруппаСтраницыПриСменеСтраницы(Элемент, ТекущаяСтраница)
	
	// СтандартныеПодсистемы.Свойства
	Если ЭтотОбъект.ПараметрыСвойств.Свойство(ТекущаяСтраница.Имя)
		И Не ЭтотОбъект.ПараметрыСвойств.ВыполненаОтложеннаяИнициализация Тогда
		
		СвойстваВыполнитьОтложеннуюИнициализацию();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства

КонецПроцедуры

&НаКлиенте
Процедура ПеремещениеПодДеятельностьОчистка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура СтрокаИсправлениеОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	ИсправлениеДокументовКлиент.СтрокаИсправлениеОбработкаНавигационныйСсылки(ЭтотОбъект, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка);
	
КонецПроцедуры


#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТовары

&НаКлиенте
Процедура ТоварыОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ТоварыОбработкаВыбораПодбораНаСервере(ВыбранноеЗначение);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыНоменклатураПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	
	СтруктураДействий = Новый Структура;
	
	ДобавитьВСтруктуруДействияПриИзмененииНоменклатуры(ТекущаяСтрока, ЭтотОбъект, СтруктураДействий);
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыХарактеристикаПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;

	СтруктураДействий = Новый Структура;
	
	СтруктураДействий.Вставить("ХарактеристикаПриИзмененииПереопределяемый", Новый Структура("ИмяФормы",
		ИмяФормы));
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды


// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды


// СтандартныеПодсистемы.РаботаСФайлами
&НаКлиенте
Процедура Подключаемый_КомандаПанелиПрисоединенныхФайлов(Команда)
	 РаботаСФайламиКлиент.КомандаУправленияПрисоединеннымиФайлами(ЭтотОбъект, Команда);
КонецПроцедуры
// Конец СтандартныеПодсистемы.РаботаСФайлами

// СтандартныеПодсистемы.РаботаСФайлами
&НаКлиенте
Процедура Подключаемый_ПолеПредпросмотраПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка)
	 РаботаСФайламиКлиент.ПолеПредпросмотраПроверкаПеретаскивания(ЭтотОбъект, Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка);
КонецПроцедуры
// Конец СтандартныеПодсистемы.РаботаСФайлами

// СтандартныеПодсистемы.РаботаСФайлами
&НаКлиенте
Процедура Подключаемый_ПолеПредпросмотраПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка)
	 РаботаСФайламиКлиент.ПолеПредпросмотраПеретаскивание(ЭтотОбъект, Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка);
КонецПроцедуры
// Конец СтандартныеПодсистемы.РаботаСФайлами

// СтандартныеПодсистемы.РаботаСФайлами
&НаКлиенте
Процедура Подключаемый_ПолеПредпросмотраНажатие(Элемент, СтандартнаяОбработка)
	 РаботаСФайламиКлиент.ПолеПредпросмотраНажатие(ЭтотОбъект, Элемент, СтандартнаяОбработка);
КонецПроцедуры
// Конец СтандартныеПодсистемы.РаботаСФайлами

#Область СтандартныеПодсистемы

// СтандартныеПодсистемы.Свойства
&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(Команда)
	
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтотОбъект, Команда);
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

#КонецОбласти

#Область РаботаСБуферомОбмена

&НаКлиенте
Процедура СкопироватьСтроки(Команда)
	
	Если РаботаСТабличнымиЧастямиКлиент.ВыбранаСтрокаДляВыполненияКоманды(Элементы.Товары) Тогда
		СкопироватьСтрокиНаСервере();
		РаботаСТабличнымиЧастямиКлиент.ОповеститьПользователяОКопированииСтрок(Элементы.Товары.ВыделенныеСтроки.Количество());
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВставитьСтроки(Команда)
	
	КоличествоТоваровДоВставки = Объект.Товары.Количество();
	
	ПолучитьСтрокиИзБуфераОбменаНаСервере();
	
	КоличествоВставленных = Объект.Товары.Количество() - КоличествоТоваровДоВставки;
	РаботаСТабличнымиЧастямиКлиент.ОповеститьПользователяОВставкеСтрок(КоличествоВставленных);
	
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура РазбитьСтроку(Команда)
	
	ПараметрыРазбиенияСтроки = РаботаСТабличнымиЧастямиКлиент.ПараметрыРазбиенияСтроки();
	ПараметрыРазбиенияСтроки.РазрешитьНулевоеКоличество = Ложь;
	ПараметрыРазбиенияСтроки.ИмяПоляКоличество = "Количество";
	
	РаботаСТабличнымиЧастямиКлиент.РазбитьСтроку(Объект.Товары, Элементы.Товары,, ПараметрыРазбиенияСтроки);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодобратьТовары(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ЗакрыватьПриВыборе", Ложь);
	
	МассивТиповНоменклатуры = Новый Массив();
	МассивТиповНоменклатуры.Добавить(ПредопределенноеЗначение("Перечисление.ТипыНоменклатуры.Работа"));
	
	ДоступныеТипыНоменклатуры = Новый ФиксированныйМассив(МассивТиповНоменклатуры);
	ПараметрыФормы.Вставить("Отбор", Новый Структура("ТипНоменклатуры", ДоступныеТипыНоменклатуры));
	
	ОткрытьФорму("Справочник.Номенклатура.Форма.ФормаВыбора", 
			ПараметрыФормы,
			Элементы.Товары,
			УникальныйИдентификатор,,,,
			РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);

КонецПроцедуры

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтотОбъект, Объект);
	
КонецПроцедуры
// Конец ИнтеграцияС1СДокументооборотом

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()
	
	ЗаполнитьСписокОпераций();
	ЗаполнитьСлужебныеРеквизитыФормы();
	ХозяйственнаяОперацияПриИзмененииНаСервере();
	
	НаправленияДеятельностиСервер.ПриЧтенииСозданииНаСервере(ЭтотОбъект);
	
	АктуализироватьПеремещениеПодДеятельность(Ложь);
	
КонецПроцедуры

#Область СтандартныеПодсистемы

// СтандартныеПодсистемы.Свойства

&НаСервере
Процедура СвойстваВыполнитьОтложеннуюИнициализацию()
	УправлениеСвойствами.ЗаполнитьДополнительныеРеквизитыВФорме(ЭтотОбъект);
КонецПроцедуры

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

#КонецОбласти

#Область ОФормление

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();
	
	#Область НоменклатураХарактеристика

	НоменклатураСервер.УстановитьУсловноеОформлениеХарактеристикНоменклатуры(ЭтотОбъект, 
		"Характеристика",
		"Объект.Товары.ХарактеристикиИспользуются");
		
	#КонецОбласти

КонецПроцедуры

#КонецОбласти

#Область РаботаСБуферомОбмена

&НаСервере
Процедура СкопироватьСтрокиНаСервере()
	
	РаботаСТабличнымиЧастями.СкопироватьСтрокиВБуферОбмена(Объект.Товары, Элементы.Товары.ВыделенныеСтроки);
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьСтрокиИзБуфераОбменаНаСервере()
	
	ПараметрыОтбора = Новый Соответствие;
	ПараметрыОтбора.Вставить("Номенклатура.ТипНоменклатуры", ПредопределенноеЗначение("Перечисление.ТипыНоменклатуры.Работа"));
	
	Колонки = "Номенклатура,Характеристика,Количество,Подразделение,ГруппаПродукции";
	
	ТаблицаСтрок = РаботаСТабличнымиЧастями.СтрокиИзБуфераОбмена(ПараметрыОтбора, Колонки);
	
	Если Не ЗначениеЗаполнено(ТаблицаСтрок) Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураДействий = Новый Структура;
	
	КэшированныеЗначения = ОбработкаТабличнойЧастиКлиентСервер.ПолучитьСтруктуруКэшируемыеЗначения();
	
	МассивСтрок = Новый Массив;
	Для Каждого СтрокаТовара Из ТаблицаСтрок Цикл
		
		ТекущаяСтрока = Объект.Товары.Добавить();
		ЗаполнитьЗначенияСвойств(ТекущаяСтрока, СтрокаТовара);
		
		ДобавитьВСтруктуруДействияПриИзмененииНоменклатуры(
			ТекущаяСтрока,
			ЭтотОбъект,
			СтруктураДействий);
		
		ОбработкаТабличнойЧастиСервер.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
		МассивСтрок.Добавить(ТекущаяСтрока.ПолучитьИдентификатор());
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьДоступностьКомандБуфераОбмена()
	
	МассивЭлементов = Новый Массив();
	МассивЭлементов.Добавить("ТоварыВставитьСтроки");
	
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементовФормы(Элементы, МассивЭлементов, "Доступность",
		РаботаСТабличнымиЧастями.ЕстьСтрокиВБуфереОбмена());
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДоступностьКомандБуфераОбменаНаКлиенте()
	
	МассивЭлементов = Новый Массив();
	МассивЭлементов.Добавить("ТоварыВставитьСтроки");
	
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементовФормы(Элементы, МассивЭлементов, "Доступность", Истина);
	
КонецПроцедуры

#КонецОбласти

#Область Штрихкодирование

&НаКлиенте
Процедура ПоискПоШтрихкодуЗавершение(ДанныхШтрихкода, ДополнительныеПараметры) Экспорт
	
	ОбработатьШтрихкоды(ДанныхШтрихкода);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьШтрихкоды(ДанныеШтрихкодов)
	
	Если Не ШтрихкодированиеНоменклатурыКлиент.ШтрихкодыВалидны(ДанныеШтрихкодов) Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураДействийСДобавленнымиСтроками = Новый Структура;
	ДобавитьВСтруктуруДействияПриИзмененииНоменклатуры(Неопределено, ЭтотОбъект, СтруктураДействийСДобавленнымиСтроками);
	
	СтруктураДействийСИзмененнымиСтроками = Новый Структура;
	
	СтруктураДействий = ШтрихкодированиеНоменклатурыКлиент.ПараметрыОбработкиШтрихкодов();
	
	СтруктураДействий.Штрихкоды                              = ДанныеШтрихкодов;
	СтруктураДействий.СтруктураДействийСДобавленнымиСтроками = СтруктураДействийСДобавленнымиСтроками;
	СтруктураДействий.СтруктураДействийСИзмененнымиСтроками  = СтруктураДействийСИзмененнымиСтроками;
	СтруктураДействий.ИзменятьКоличество                     = Истина;
	СтруктураДействий.ТолькоРаботы                           = Истина;
	СтруктураДействий.ИмяКолонкиКоличество                   = "Количество";
	СтруктураДействий.НеИспользоватьУпаковки                 = Истина;
	
	ОбработатьШтрихкодыСервер(СтруктураДействий, КэшированныеЗначения);
	ШтрихкодированиеНоменклатурыКлиент.ОбработатьНеизвестныеШтрихкоды(СтруктураДействий, КэшированныеЗначения, ЭтотОбъект);
	
	Если СтруктураДействий.ТекущаяСтрока <> Неопределено Тогда
		Элементы.Товары.ТекущаяСтрока = СтруктураДействий.ТекущаяСтрока;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьШтрихкодыСервер(СтруктураПараметровДействия, КэшированныеЗначения)
	
	ШтрихкодированиеНоменклатурыСервер.ОбработатьШтрихкоды(ЭтотОбъект, Объект, СтруктураПараметровДействия, КэшированныеЗначения);
	
КонецПроцедуры

#КонецОбласти

#Область ПриИзмененииРеквизитов

&НаСервере
Процедура ДатаПриИзмененииНаСервере()
	
	АктуализироватьПеремещениеПодДеятельность();
	
КонецПроцедуры

&НаСервере
Процедура ХозяйственнаяОперацияПриИзмененииНаСервере()
	
	Если НЕ ЗначениеЗаполнено(Объект.ХозяйственнаяОперация) Тогда
		Объект.ХозяйственнаяОперация = Элементы.ХозяйственнаяОперация.СписокВыбора[0].Значение;
	КонецЕсли; 
	
	Если Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПриемПередачаРаботМеждуПодразделениями Тогда
		Элементы.Организация.Заголовок = НСтр("ru = 'Организация';
												|en = 'Company'");
		Элементы.ОрганизацияПолучатель.Видимость = Ложь;
	Иначе
		Элементы.Организация.Заголовок = НСтр("ru = 'Организация-отправитель';
												|en = 'Performing company'");
		Элементы.ОрганизацияПолучатель.Видимость = Истина;
	КонецЕсли;
	
	АктуализироватьПеремещениеПодДеятельность();
	
	ХозОперацияДоИзменения = Объект.ХозяйственнаяОперация;
	
КонецПроцедуры

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()
	
	АктуализироватьПеремещениеПодДеятельность();
	
КонецПроцедуры

&НаСервере
Процедура ОрганизацияПолучательПриИзмененииНаСервере()
	
	АктуализироватьПеремещениеПодДеятельность();
	
КонецПроцедуры

&НаСервере
Процедура НаправлениеДеятельностиПриИзмененииНаСервере()
	
	НаправленияДеятельностиСервер.ПриИзмененииНаправленияДеятельности(ЭтотОбъект);
	АктуализироватьПеремещениеПодДеятельность();
	
КонецПроцедуры

&НаСервере
Процедура АктуализироватьПеремещениеПодДеятельность(Заполнить = Истина)
	
	ПараметрыЗаполнения = Документы.АктВыполненныхВнутреннихРабот.ПараметрыЗаполненияВидаДеятельностиНДС(Объект);
	Если Заполнить Тогда
		УчетНДСУП.ЗаполнитьВидДеятельностиНДС(
			Объект.ПеремещениеПодДеятельность,
			ПараметрыЗаполнения,
			УчетНДСКэшированныеЗначенияПараметров);
	КонецЕсли;
	
	УчетНДСУП.ЗаполнитьСписокВыбораВидаДеятельностиНДС(
		Элементы.ПеремещениеПодДеятельность,
		Объект.ПеремещениеПодДеятельность,
		ПараметрыЗаполнения,
		УчетНДСКэшированныеЗначенияПараметров);
	
КонецПроцедуры

#КонецОбласти

#Область ДействияПриИзмененииСтрокТаблицыТоваров

&НаСервере
Процедура ТоварыОбработкаВыбораПодбораНаСервере(ВыбранноеЗначение)

	Если ТипЗнч(ВыбранноеЗначение) = Тип("Массив") Тогда
		СписокТоваров = ВыбранноеЗначение;
	Иначе
		СписокТоваров = Новый Массив;
		СписокТоваров.Добавить(ВыбранноеЗначение);
	КонецЕсли;
	
	СтруктураДействий = Новый Структура;
	
	КэшированныеЗначения = ОбработкаТабличнойЧастиКлиентСервер.ПолучитьСтруктуруКэшируемыеЗначения();
	
	МассивСтрок = Новый Массив;
	Для Каждого СтрокаТовара Из СписокТоваров Цикл
		
		ТекущаяСтрока = Объект.Товары.Добавить();
		ТекущаяСтрока.Номенклатура = СтрокаТовара;
		
		ДобавитьВСтруктуруДействияПриИзмененииНоменклатуры(
				ТекущаяСтрока, 
				ЭтотОбъект, 
				СтруктураДействий);
				
		ОбработкаТабличнойЧастиСервер.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
		
		МассивСтрок.Добавить(ТекущаяСтрока.ПолучитьИдентификатор());
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ДобавитьВСтруктуруДействияПриИзмененииНоменклатуры(ТекущаяСтрока, Форма, СтруктураДействий)

	Если Не ТекущаяСтрока = Неопределено Тогда
		СтруктураДействий.Вставить("ПроверитьХарактеристикуПоВладельцу", ТекущаяСтрока.Характеристика);
	КонецЕсли;
	
	СтруктураДействий.Вставить("ЗаполнитьПризнакАртикул", Новый Структура("Номенклатура", "Артикул"));
	
	СтруктураДействий.Вставить("ЗаполнитьПризнакХарактеристикиИспользуются",
											Новый Структура("Номенклатура", "ХарактеристикиИспользуются"));
	СтруктураДействий.Вставить("ЗаполнитьПризнакАртикул",
											Новый Структура("Номенклатура", "Артикул"));
	СтруктураДействий.Вставить("ЗаполнитьПризнакТипНоменклатуры",
											Новый Структура("Номенклатура", "ТипНоменклатуры"));
	
	СтруктураДействий.Вставить("НоменклатураПриИзмененииПереопределяемый", Новый Структура("ИмяФормы, ИмяТабличнойЧасти",
		Форма.ИмяФормы));
	
КонецПроцедуры

#КонецОбласти

&НаСервере
Процедура ЗаполнитьСлужебныеРеквизитыФормы()
	
	ХозОперацияДоИзменения = Объект.ХозяйственнаяОперация;
	
	ПараметрыЗаполненияРеквизитов = Новый Структура;
	ПараметрыЗаполненияРеквизитов.Вставить("ЗаполнитьПризнакХарактеристикиИспользуются",
											Новый Структура("Номенклатура", "ХарактеристикиИспользуются"));
	ПараметрыЗаполненияРеквизитов.Вставить("ЗаполнитьПризнакАртикул",
											Новый Структура("Номенклатура", "Артикул"));
	ПараметрыЗаполненияРеквизитов.Вставить("ЗаполнитьПризнакТипНоменклатуры",
											Новый Структура("Номенклатура", "ТипНоменклатуры"));
											
	НоменклатураСервер.ЗаполнитьСлужебныеРеквизитыПоНоменклатуреВКоллекции(Объект.Товары, ПараметрыЗаполненияРеквизитов);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокОпераций()
	
	Элементы.ХозяйственнаяОперация.СписокВыбора.Очистить();
	СписокОпераций = Документы.АктВыполненныхВнутреннихРабот.СписокОпераций();
	Для каждого ЭлементКоллекции Из СписокОпераций Цикл
		Элементы.ХозяйственнаяОперация.СписокВыбора.Добавить(ЭлементКоллекции.Значение, ЭлементКоллекции.Представление);
	КонецЦикла;

КонецПроцедуры

&НаКлиенте
Процедура ПоискПоШтрихкоду(Команда)
	
	ОчиститьСообщения();
	Оповещение = Новый ОписаниеОповещения("ПоискПоШтрихкодуЗавершение", ЭтотОбъект);
	ШтрихкодированиеНоменклатурыКлиент.ПоказатьВводШтрихкода(Оповещение);
	
КонецПроцедуры

#КонецОбласти
