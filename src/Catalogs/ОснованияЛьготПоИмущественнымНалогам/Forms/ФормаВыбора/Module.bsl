#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Не Параметры.Отбор.Свойство("Налог") Или Не ЗначениеЗаполнено(Параметры.Отбор.Налог) Тогда
		ВызватьИсключение НСтр("ru = 'Не поддерживается использование формы без указания налога';
								|en = 'Cannot use the form without specifying tax'");
	КонецЕсли;
	
	Налог = Параметры.Отбор.Налог;
	
	АвтоЗаголовок = Ложь;
	
	Если Налог = Перечисления.ВидыИмущественныхНалогов.НалогНаИмущество Тогда
		Заголовок = Нстр("ru = 'Основания льгот по налогу на имущество';
						|en = 'Basis for property tax reliefs'");
	ИначеЕсли Налог = Перечисления.ВидыИмущественныхНалогов.ТранспортныйНалог Тогда
		Заголовок = Нстр("ru = 'Основания льгот по транспортному налогу';
						|en = 'Relief basis for vehicle tax'");
	ИначеЕсли Налог = Перечисления.ВидыИмущественныхНалогов.ЗемельныйНалог Тогда
		Заголовок = Нстр("ru = 'Основания льгот по земельному налогу';
						|en = 'Relief basis for land value tax'");
	Иначе
		ВызватьИсключение СтрШаблон(НСтр("ru = 'Неподдерживаемый вид налога: %1';
										|en = 'Unsupported tax kind: %1'"), Налог);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "Запись_ОснованияЛьготПоИмущественнымНалогам" Тогда
		Элементы.Список.Обновить();
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, ЭтоГруппа, Параметр)
	
	Если Копирование Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Элементы.Список.Обновить();
	Элементы.Список.ТекущаяСтрока = ВыбранноеЗначение;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СоздатьЛьготуНалогНаИмущество(Команда)
	СоздатьЛьготу(ПредопределенноеЗначение("Перечисление.ВидыИмущественныхНалогов.НалогНаИмущество"));
КонецПроцедуры

&НаКлиенте
Процедура СоздатьЛьготуТранспортныйНалог(Команда)
	СоздатьЛьготу(ПредопределенноеЗначение("Перечисление.ВидыИмущественныхНалогов.ТранспортныйНалог"));
КонецПроцедуры

&НаКлиенте
Процедура СоздатьЛьготуЗемельныйНалог(Команда)
	СоздатьЛьготу(ПредопределенноеЗначение("Перечисление.ВидыИмущественныхНалогов.ЗемельныйНалог"));
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура СоздатьЛьготу(Налог)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ЗначенияЗаполнения", Новый Структура("Налог", Налог));
	ОткрытьФорму("Справочник.ОснованияЛьготПоИмущественнымНалогам.ФормаОбъекта", ПараметрыФормы, ЭтотОбъект)

КонецПроцедуры

#КонецОбласти