

#Область ОписаниеПеременных

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СписокОрганизаций = Параметры.СписокОрганизаций;
	
	ИнициализироватьОрганизации(СписокОрганизаций);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВыбратьВсе(Команда)
	
	Для Каждого Стр Из ВсеОрганизации Цикл 
		Стр.Пометка = Истина;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьВыделение(Команда)
	
	Для Каждого Стр Из ВсеОрганизации Цикл 
		Стр.Пометка = Ложь;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выбрать(Команда)
	
	СписокОрганизаций = Новый СписокЗначений;
	Для каждого Строка Из ВсеОрганизации Цикл
		Если Строка.Пометка Тогда
			СписокОрганизаций.Добавить(Строка.Значение, Строка.Представление);
		КонецЕсли;
	КонецЦикла;
	
	Закрыть(СписокОрганизаций);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ИнициализироватьОрганизации(СписокОрганизаций)

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	Организации.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.Организации КАК Организации
		|ГДЕ
		|	НЕ Организации.ПометкаУдаления
		|	И Организации.УчетнаяЗаписьОбмена В(&ТекущиеУчетныеЗаписи)";
	
	ТекущиеУчетныеЗаписи = ДокументооборотСКО.ТекущиеУчетныеЗаписиНалогоплательщика();
	Запрос.УстановитьПараметр("ТекущиеУчетныеЗаписи", ТекущиеУчетныеЗаписи);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Пометка = СписокОрганизаций.НайтиПоЗначению(Выборка.Ссылка) <> Неопределено;
		ВсеОрганизации.Добавить(Выборка.Ссылка, Строка(Выборка.Ссылка), Пометка);
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

