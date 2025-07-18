///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Настройки = СверкаВзаиморасчетовСБПc2b.НастройкеСверкиВзаиморасчетов();
	Если Настройки.ИспользоватьДокументСверки Тогда
		УстановитьУсловноеОформление();
	Иначе
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаСообщениеОбОшибке;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Результат = ОпределитьДоступностьСверки(ВыбраннаяСтрока);
	Если Результат.Доступна Тогда
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Ключ", ВыбраннаяСтрока);
		
		ОткрытьФорму(
			"Документ.СверкаВзаиморасчетовСБПc2b.ФормаОбъекта",
			ПараметрыФормы,
			ЭтотОбъект,
			ЭтотОбъект.УникальныйИдентификатор);
		
	Иначе
		ПоказатьПредупреждение(Неопределено, Результат.Сообщение);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Создать(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"СоздатьЗавершение",
		ЭтотОбъект);
	
	ОткрытьФорму(
		"Документ.СверкаВзаиморасчетовСБПc2b.Форма.ФормаНоваяСверка",
		,
		ЭтотОбъект,
		ЭтотОбъект.УникальныйИдентификатор,
		,
		,
		ОписаниеОповещения);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Функция ОпределитьДоступностьСверки(Знач СверкаВзаиморасчетов)
	
	Результат = Новый Структура;
	Результат.Вставить("Доступна",  Ложь);
	Результат.Вставить("Сообщение", "");
	Состояние = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(
		СверкаВзаиморасчетов,
		"Состояние");
	
	Если Состояние = Перечисления.СостояниеСверкиВзаиморасчетовСБПc2b.Готовится
		И ПереводыСБПc2b.ПереводыСБПДоступны() Тогда
		
		СверкаВзаиморасчетовСБПc2b.СлужебнаяПроверкаГотовностиСверкиВзаиморасчетовСБПc2b(
			СверкаВзаиморасчетов);
		Состояние = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(
			СверкаВзаиморасчетов,
			"Состояние");
		
	КонецЕсли;
	
	Если Состояние = Перечисления.СостояниеСверкиВзаиморасчетовСБПc2b.Готовится Тогда
		Результат.Доступна = Ложь;
		Результат.Сообщение = НСтр("ru = 'На текущий момент подготовка сверки взаиморасчетов не завершена. Повторите попытку позже.';
									|en = 'AR/AP reconciliation preparation is not completed. Try again later.'")
	ИначеЕсли Состояние = Перечисления.СостояниеСверкиВзаиморасчетовСБПc2b.ОшибкаПодготовки Тогда
		Результат.Доступна = Ложь;
		Результат.Сообщение = НСтр("ru = 'Сверка взаиморасчетов не может быть открыта для просмотра
				|в связи с ошибкой подготовки отчета.';
				|en = 'Cannot view the AR/AP reconciliation
				|due to the report preparation error.'")
	Иначе
		Результат.Доступна = Истина;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура СоздатьЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Элементы.Список.Обновить();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	Элемент.Использование = Истина;
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветФона", ЦветаСтиля.ЦветФонаНекорректногоЗначенияБИП);
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Список.Имя);
	
	ГруппаОтбораПроверена = Элемент.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	
	ОтборЭлемента = ГруппаОтбораПроверена.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.Проверена");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;
	
	ОтборЭлемента = ГруппаОтбораПроверена.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.Состояние");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.СостояниеСверкиВзаиморасчетовСБПc2b.Подготовлена;
	
	ГруппаОтбораСуммы = ГруппаОтбораПроверена.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбораСуммы.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;
	
	ОтборЭлемента = ГруппаОтбораСуммы.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.СуммаОплатКорректна");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;
	
	ОтборЭлемента = ГруппаОтбораСуммы.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.СуммаВозвратовКорректна");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;
	
КонецПроцедуры

#КонецОбласти
