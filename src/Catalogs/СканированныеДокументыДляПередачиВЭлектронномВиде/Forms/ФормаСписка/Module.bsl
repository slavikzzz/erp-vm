
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Параметры.Свойство("Организация", ОтборОрганизация);
	Параметры.Свойство("ОткрытьВРежимеВыбора", ОткрытьВРежимеВыбора);
	
	Если ОткрытьВРежимеВыбора Тогда
		Элементы.СписокОрганизация.Видимость = Ложь;
	Иначе
		Элементы.ФормаВыбрать.Видимость = Ложь;
		Элементы.ОтборОрганизация.Видимость = Ложь;
	КонецЕсли;
		
	УстановитьОтборы();
	
	ДобавитьНовости();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// ИнтернетПоддержкаПользователей.Новости.ПриОткрытии
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.Новости") Тогда
		
		МодульОбработкаНовостейКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ОбработкаНовостейКлиент");
		
		МодульОбработкаНовостейКлиент.КонтекстныеНовости_ПриОткрытии(ЭтаФорма);
		
	КонецЕсли;
	// Конец ИнтернетПоддержкаПользователей.Новости.ПриОткрытии
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись сканированного документа" Тогда
		Элементы.Список.Обновить();
	КонецЕсли;
	
	// ИнтернетПоддержкаПользователей.Новости.ОбработкаОповещения
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.Новости") Тогда
		
		МодульОбработкаНовостейКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ОбработкаНовостейКлиент");
		
		МодульОбработкаНовостейКлиент.КонтекстныеНовости_ОбработкаОповещения(ЭтаФорма, ИмяСобытия, Параметр, Источник);
		
	КонецЕсли;
	// Конец ИнтернетПоддержкаПользователей.Новости.ОбработкаОповещения

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если ОткрытьВРежимеВыбора Тогда
		СтандартнаяОбработка = Ложь;
		ВыбратьИсточникПоТекущейСтроке();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выбрать(Команда)
	
	ВыбратьИсточникПоТекущейСтроке();
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьЭлемент(Команда)
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("Организация", ОтборОрганизация);
	ПараметрыФормы = Новый Структура("ЗначенияЗаполнения", СтруктураПараметров);
	ОткрытьФорму("Справочник.СканированныеДокументыДляПередачиВЭлектронномВиде.ФормаОбъекта", ПараметрыФормы, ЭтотОбъект);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ВыбратьИсточникПоТекущейСтроке()
	
	МассивВыбранныхДокументов = ОписаниеВыбранныхСтрок();
	ОповеститьОВыборе(МассивВыбранныхДокументов);
	
КонецПроцедуры

&НаСервере
Функция ОписаниеВыбранныхСтрок()
	
	МассивВыбранныхДокументов = Новый Массив;
	
	Для каждого ВыделеннаяСтрока Из Элементы.Список.ВыделенныеСтроки Цикл
		
		СтруктураСвойств = Новый Структура;
		
		СтруктураСвойств.Вставить("ВыбранныйДокумент", 	ВыделеннаяСтрока.Ссылка);
		СтруктураСвойств.Вставить("ВидДокументаФНС", 	ВыделеннаяСтрока.ВидДокумента);
		
		МассивВыбранныхДокументов.Добавить(СтруктураСвойств);
				
	КонецЦикла;
	
	Возврат МассивВыбранныхДокументов;
	
КонецФункции

&НаСервере
Процедура ДобавитьНовости()
	
	// ИнтернетПоддержкаПользователей.Новости.КонтекстныеНовости_ПриСозданииНаСервере
	Если ОбщегоНазначения.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.Новости") Тогда
		
		ИдентификаторыСобытийПриОткрытии = "ПриОткрытии";
		
		МодульОбработкаНовостей = ОбщегоНазначения.ОбщийМодуль("ОбработкаНовостей");
		
		МодульОбработкаНовостей.КонтекстныеНовости_ПриСозданииНаСервере(
			ЭтаФорма,
			"БП.Справочник.СканированныеДокумДляПередачиВЭлВиде",
			"ФормаВыбора",
			,
			НСтр("ru = 'Новости: Сканированные документы для передачи в электронном виде';
				|en = 'Новости: Сканированные документы для передачи в электронном виде'"),
			Ложь,
			Новый Структура("ПолучатьНовостиНаСервере, ХранитьМассивНовостейТолькоНаСервере", Истина, Ложь),
			ИдентификаторыСобытийПриОткрытии);
		
	КонецЕсли;
	
	// Конец ИнтернетПоддержкаПользователей.Новости.КонтекстныеНовости_ПриСозданииНаСервере
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборы()
	
	Если ЗначениеЗаполнено(ОтборОрганизация) Тогда
		Список.Параметры.УстановитьЗначениеПараметра("Организация",  ОтборОрганизация);
	Иначе
		Список.Параметры.УстановитьЗначениеПараметра("Организация",  Справочники.Организации.ПустаяСсылка());
	КонецЕсли;
	
	Список.Параметры.УстановитьЗначениеПараметра("ОткрытьВРежимеВыбора",  ОткрытьВРежимеВыбора);
	
КонецПроцедуры

#КонецОбласти

#Область Новости

&НаКлиенте
// Процедура показывает новости, требующие прочтения (важные и очень важные)
//
// Параметры:
//  Нет
//
Процедура Подключаемый_ПоказатьНовостиТребующиеПрочтенияПриОткрытии()

	// ИнтернетПоддержкаПользователей.Новости.Подключаемый_ПоказатьНовостиТребующиеПрочтенияПриОткрытии
	ИдентификаторыСобытийПриОткрытии = "ПриОткрытии";
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.Новости") Тогда
		
		МодульОбработкаНовостейКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ОбработкаНовостейКлиент");
		
		МодульОбработкаНовостейКлиент.КонтекстныеНовости_ПоказатьНовостиТребующиеПрочтенияПриОткрытии(ЭтаФорма, ИдентификаторыСобытийПриОткрытии);
		
	КонецЕсли;
	// Конец ИнтернетПоддержкаПользователей.Новости.Подключаемый_ПоказатьНовостиТребующиеПрочтенияПриОткрытии

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаКомандыНовости(Команда)

	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.Новости") Тогда
		
		МодульОбработкаНовостейКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ОбработкаНовостейКлиент");
		
		МодульОбработкаНовостейКлиент.КонтекстныеНовости_ОбработкаКомандыНовости(ЭтаФорма, Команда);
		
	КонецЕсли;

КонецПроцедуры

#КонецОбласти
