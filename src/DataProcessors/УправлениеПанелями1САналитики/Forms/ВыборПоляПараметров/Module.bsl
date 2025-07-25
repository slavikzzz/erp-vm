#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ТекстПодсказки = НСтр("ru = 'Выборку из виртуальной таблицы ""%1"" можно ограничить периодом, определяемым ее параметрами.
	| Для автоматической установки значений параметров в ""1С:Аналитике"" необходимо выбрать поле с типом Дата, фильтры для которого будут определять диапазон дат для виртуальной таблицы.
	| Для таблиц оборотов в ""1С:Аналитике"" также можно будет устанавливать значение периодичности.';
	|en = 'You can restrict the selection from the ""%1"" virtual table by the period determined by its parameters.
	|To set parameter values automatically in 1C:Analytics, select the field with the ""Date"" type whose filters will determine the range of dates for the virtual table.
	|You can also set the periodicity value for the turnover tables in 1C:Analytics.'");
	
	ЗаголовокНадписиПодсказки = СтрШаблон(ТекстПодсказки, Параметры.ПсевдонимТаблицы);
	Элементы.НадписьПодсказка.Заголовок = ЗаголовокНадписиПодсказки;
	
	Для Каждого Элемент Из Параметры.СписокВыбораПоляПараметров Цикл
		Элементы.ПолеПараметров.СписокВыбора.Добавить(Элемент.Значение);
	КонецЦикла;
	
	Если Параметры.СписокВыбораПоляПараметров.НайтиПоЗначению(Параметры.ЗначениеПоляПараметров) <> Неопределено Тогда
		ПолеПараметров = Параметры.ЗначениеПоляПараметров;
	Иначе
		Элементы.КнопкаУстановить.Доступность = Ложь;
	КонецЕсли

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПолеПараметровПриИзменении(Элемент)
	
	Элементы.КнопкаУстановить.Доступность = ЗначениеЗаполнено(ПолеПараметров);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Установить(Команда)
	
	Закрыть(ПолеПараметров);
	
КонецПроцедуры

#КонецОбласти