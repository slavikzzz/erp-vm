&НаКлиенте
Перем КонтекстЭДОКлиент;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ТекстЗаголовка = НСтр("ru = 'Уведомление о прекращении полномочий представителя ПФР';
							|en = 'Уведомление о прекращении полномочий представителя ПФР'");
	ЭтаФорма.Заголовок = ДокументооборотСКОКлиентСервер.ЗаменитьПФРиФССнаСФР(ТекстЗаголовка, Истина);
	
	ИнициализироватьДанные(Параметры);
	УстановитьОтборПоОрганизации();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриОткрытииЗавершение", ЭтотОбъект);
	ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекущиеДанные = Элемент.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда

		Ссылка = ТекущиеДанные.Ссылка;
		
		Если Поле.Имя = "СтатусОтправки" Тогда
			КонтекстЭДОКлиент.ПоказатьФормуСтатусовОтправкиИзСписка(Элемент);
		ИначеЕсли Поле.Имя = "ЕстьКритическиеОшибкиОтправки" И ТекущиеДанные.ЕстьКритическиеОшибкиОтправки Тогда
			КонтекстЭДОКлиент.ПоказатьКритическиеОшибкиПоСсылке(Ссылка);
		Иначе
			ПоказатьЗначение(,Ссылка);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры


#КонецОбласти

#Область ОбработчикиКомандФормы

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПриОткрытииЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	КонтекстЭДОКлиент = Результат.КонтекстЭДО;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборПоОрганизации()

	Если ЗначениеЗаполнено(Организация) Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список, 
			"Организация", 
			Организация,
			ВидСравненияКомпоновкиДанных.Равно,
			,
			ЗначениеЗаполнено(Организация), 
			РежимОтображенияЭлементаНастройкиКомпоновкиДанных.БыстрыйДоступ,
			Строка(Новый УникальныйИдентификатор));
			
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ИнициализироватьДанные(Параметры)

	Если Параметры.Свойство("Организация") Тогда
		Организация = Параметры.Организация;
	КонецЕсли;
		
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры

&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Элементы.Список);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти
