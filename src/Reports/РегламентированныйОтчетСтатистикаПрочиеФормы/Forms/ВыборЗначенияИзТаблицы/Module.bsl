#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ТаблицаЗначений.Количество() > 0 Тогда
		
		Элементы.ТаблицаЗначений.ТекущаяСтрока = ИдентификаторНайденнойСтроки;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.НаимКолонкиКод) Тогда
		
		Элементы.ТаблицаЗначенийКод.Заголовок = Параметры.НаимКолонкиКод;
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.НаимКолонкиНазвание) Тогда
		
		Элементы.ТаблицаЗначенийНазвание.Заголовок = Параметры.НаимКолонкиНазвание;
		
	КонецЕсли;
		
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТаблицаЗначений

&НаКлиенте
Процедура ТаблицаЗначенийВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Закрыть(Элементы.ТаблицаЗначений.ТекущиеДанные.ПолучитьИдентификатор());
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выбрать(Команда)
	
	Если Элементы.ТаблицаЗначений.ТекущиеДанные <> Неопределено Тогда
		Закрыть(Элементы.ТаблицаЗначений.ТекущиеДанные.ПолучитьИдентификатор());
	Иначе
		Закрыть(Неопределено);
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти
