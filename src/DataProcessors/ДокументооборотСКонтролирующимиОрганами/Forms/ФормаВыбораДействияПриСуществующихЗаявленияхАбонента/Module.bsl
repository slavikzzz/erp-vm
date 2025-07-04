
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ИмяОрганизации = Параметры.ИмяОрганизации;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Элементы.ТекстСообщения.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'По организации %1 заявление на подключение уже сформировано';
																									|en = 'По организации %1 заявление на подключение уже сформировано'"),ИмяОрганизации);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗакрытьФорму(Команда)
	Закрыть(2);
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСписокЗаявлений(Команда)
	
	Закрыть(0);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗапуститьМастер(Команда)
	Закрыть(1);
КонецПроцедуры

#КонецОбласти
