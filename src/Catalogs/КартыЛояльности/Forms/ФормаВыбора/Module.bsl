
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	Партнер                       = Параметры.Партнер;
	ПоПартнеру                    = ЗначениеЗаполнено(Параметры.Партнер);
	Элементы.ПоПартнеру.Видимость = ЗначениеЗаполнено(Параметры.Партнер);
	
	Если ЗначениеЗаполнено(Партнер) Тогда
		Элементы.ПоПартнеру.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'По партнеру ""%1""';
																									|en = 'By partner ""%1""'"), Партнер);
	КонецЕсли;
	
	ОбщегоНазначенияУТ.НастроитьПодключаемоеОборудование(ЭтаФорма);
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Партнер", Партнер, ВидСравненияКомпоновкиДанных.Равно,, ПоПартнеру);	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Владелец.Организация", Параметры.Организация, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(Параметры.Организация));
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ИнтеграцияС1СДокументооборотом
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	МенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПриОткрытииФормы(Неопределено, ЭтаФорма, "СканерШтрихкода,СчитывательМагнитныхКарт");

КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	МенеджерОборудованияКлиент.НачатьОтключениеОборудованиеПриЗакрытииФормы(Неопределено, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// ПодключаемоеОборудование
	Если Источник = "ПодключаемоеОборудование" И ВводДоступен() Тогда
		Если ИмяСобытия = "ScanData" И МенеджерОборудованияУТКлиент.ЕстьНеобработанноеСобытие() Тогда
			ОбработатьШтрихкоды(МенеджерОборудованияУТКлиент.ПреобразоватьДанныеСоСканераВМассив(Параметр));
		ИначеЕсли ИмяСобытия ="TracksData" Тогда
			ОбработатьДанныеСчитывателяМагнитныхКарт(Параметр);
		КонецЕсли;
	КонецЕсли;
	// Конец ПодключаемоеОборудование
	
	Если ИмяСобытия = "СчитанаКартаЛояльности"
		И Параметр.ФормаВладелец = УникальныйИдентификатор Тогда
		
		Элементы.Список.ТекущаяСтрока = Параметр.КартаЛояльности;
		
	КонецЕсли;
	
	Если ИмяСобытия = "Запись_КартаЛояльности" Тогда
		Элементы.Список.Обновить();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПоПартнеруПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Партнер", Партнер, ВидСравненияКомпоновкиДанных.Равно,, ПоПартнеру);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Элементы.Список);
	
КонецПроцедуры
// Конец ИнтеграцияС1СДокументооборотом

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ШтрихкодыИТорговоеОборудование

// МеханизмВнешнегоОборудования
&НаКлиенте
Процедура ОбработатьШтрихкоды(ДанныеШтрихкодов)
	
	КартыЛояльностиКлиент.ОбработатьШтрихкоды(ЭтаФорма, ДанныеШтрихкодов);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьДанныеСчитывателяМагнитныхКарт(Данные)
	
	КартыЛояльностиКлиент.ОбработатьДанныеСчитывателяМагнитныхКарт(ЭтаФорма, Данные);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
