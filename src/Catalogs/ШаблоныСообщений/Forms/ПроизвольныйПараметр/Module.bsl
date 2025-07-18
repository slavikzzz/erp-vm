///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.ОписаниеТипа.Типы().Количество() > 0 Тогда
		НайденныйТипПараметра = Параметры.ОписаниеТипа.Типы()[0];
	КонецЕсли;
	
	ЗаполнитьСписокВыбораВводНаОсновании(НайденныйТипПараметра);
	
	Для каждого ПараметрИзФормы Из Параметры.СписокПараметров Цикл
		Если СтрНачинаетсяС(Параметры.ИмяПараметра, ШаблоныСообщенийКлиентСервер.ЗаголовокПроизвольныхПараметров()) Тогда
			ИмяПараметраДляПроверки = Сред(Параметры.ИмяПараметра, СтрДлина(ШаблоныСообщенийКлиентСервер.ЗаголовокПроизвольныхПараметров()) + 2);
		Иначе
			ИмяПараметраДляПроверки = Параметры.ИмяПараметра;
		КонецЕсли;
		Если ПараметрИзФормы.ИмяПараметра = ИмяПараметраДляПроверки Тогда
			Продолжить;
		КонецЕсли;
		СписокПараметров.Добавить(ПараметрИзФормы.ИмяПараметра, ПараметрИзФормы.ПредставлениеПараметра);
	КонецЦикла;
	
	Если СтрНачинаетсяС(Параметры.ИмяПараметра, ШаблоныСообщенийКлиентСервер.ЗаголовокПроизвольныхПараметров()) Тогда
		ИмяПараметра = Сред(Параметры.ИмяПараметра, СтрДлина(ШаблоныСообщенийКлиентСервер.ЗаголовокПроизвольныхПараметров()) + 2);
	Иначе
		ИмяПараметра = Параметры.ИмяПараметра;
	КонецЕсли;
	ПредставлениеПараметра = Параметры.ПредставлениеПараметра;
	ТипПараметра = Параметры.ОписаниеТипа;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ТипПараметраСтрокой(ПолноеИмяТипа)
	
	Если СтрСравнить(ПолноеИмяТипа, "Дата") = 0 Тогда
		Результат = Тип("Дата");
	ИначеЕсли СтрСравнить(ПолноеИмяТипа, "Строка") = 0 Тогда
		Результат = Тип("Строка");
	Иначе
		МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(ПолноеИмяТипа);
		Если МенеджерОбъекта <> Неопределено Тогда
			Результат = ТипЗнч(МенеджерОбъекта.ПустаяСсылка());
		КонецЕсли;
	КонецЕсли;
	
	Возврат Результат;
КонецФункции

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТипПараметраПриИзменении(Элемент)
	Если ПустаяСтрока(ПредставлениеПараметра) И ПустаяСтрока(ИмяПараметра) Тогда
		ПредставлениеПараметра = Элементы.ТипСтрокой.ТекстРедактирования;
		Позиция = СтрНайти(ТипСтрокой, ".", НаправлениеПоиска.СКонца);
		Если Позиция > 0 И Позиция < СтрДлина(ТипСтрокой) Тогда
			ИмяПараметра = Сред(ТипСтрокой, Позиция + 1);
		Иначе
			ИмяПараметра = ТипСтрокой;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	Для Каждого ПараметрИзФормы Из СписокПараметров Цикл
		Если СтрСравнить(ПараметрИзФормы.Значение, ИмяПараметра) = 0 Тогда
			ПоказатьПредупреждение(, НСтр("ru = 'Некорректное имя параметра. Параметр с таким именем уже был добавлен ранее.';
											|en = 'Placeholder name error. A placeholder with this name already exists.'"));
			Возврат;
		КонецЕсли;
		Если СтрСравнить(ПараметрИзФормы.Представление, ПредставлениеПараметра) = 0 Тогда
			ПоказатьПредупреждение(, НСтр("ru = 'Некорректное представление параметра. Параметр с таким представлением уже был добавлен ранее.';
											|en = 'Placeholder presentation error. A placeholder with this presentation already exists.'"));
			Возврат;
		КонецЕсли;
	КонецЦикла;
	
	Если НедопустимоеИмяПараметра(ИмяПараметра) ИЛИ ПустаяСтрока(ИмяПараметра) Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Некорректное имя параметра. Нельзя использовать пробелы, знаки пунктуации и другие спец. символы.';
										|en = 'Invalid placeholder name. Special characters and whitespace are not allowed.'"));
		Возврат;
	КонецЕсли;
	
	Если ПустаяСтрока(ПредставлениеПараметра) Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Некорректное представление параметра.';
										|en = 'Invalid placeholder presentation.'"));
		Возврат;
	КонецЕсли;
	
	Если ПустаяСтрока(ТипСтрокой) Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Некорректный тип параметра.';
										|en = 'Invalid placeholder type.'"));
		Возврат;
	КонецЕсли;
	
	Результат = Новый Структура("ИмяПараметра, ПредставлениеПараметра, ТипПараметра");
	ЗаполнитьЗначенияСвойств(Результат, ЭтотОбъект);
	Результат.ТипПараметра = ТипПараметраСтрокой(ТипСтрокой);
	Закрыть(Результат);
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	Закрыть(Неопределено);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Функция НедопустимоеИмяПараметра(ИмяПараметра)
	
	Попытка
		Тест = Новый Структура(ИмяПараметра, ИмяПараметра);
	Исключение
		Возврат Истина;
	КонецПопытки;
	
	Возврат ТипЗнч(Тест) <> Тип("Структура");
	
КонецФункции

&НаСервере
Процедура ЗаполнитьСписокВыбораВводНаОсновании(ТипПараметра)
	
	ПредставлениеТипа = "";
	НастройкиШаблоновСообщений = ШаблоныСообщенийСлужебныйПовтИсп.ПриОпределенииНастроек();
	Для каждого ПредметШаблона Из НастройкиШаблоновСообщений.ПредметыШаблонов Цикл
		Если СтрСравнить(ПредметШаблона.Имя, Параметры.ПолноеИмяТипаПараметраВводаНаОсновании) = 0 Тогда
			Продолжить;
		КонецЕсли;
		МетаданныеОбъекта = ОбщегоНазначения.ОбъектМетаданныхПоПолномуИмени(ПредметШаблона.Имя);
		Если МетаданныеОбъекта = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		Элементы.ТипСтрокой.СписокВыбора.Добавить(ПредметШаблона.Имя, ПредметШаблона.Представление);
		
		МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(ПредметШаблона.Имя);
		Если МенеджерОбъекта <> Неопределено Тогда
			Если ТипПараметра = ТипЗнч(МенеджерОбъекта.ПустаяСсылка()) Тогда
				ПредставлениеТипа = ПредметШаблона.Имя;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Если ТипПараметра = Тип("Строка") Тогда
		ПредставлениеТипа = НСтр("ru = 'Строка';
								|en = 'String'");
	ИначеЕсли ТипПараметра = Тип("Дата") Тогда
		ПредставлениеТипа = НСтр("ru = 'Дата';
								|en = 'Date'");
	КонецЕсли;
	
	Элементы.ТипСтрокой.СписокВыбора.Вставить(0, "Дата", НСтр("ru = 'Дата';
																|en = 'Date'"));
	Элементы.ТипСтрокой.СписокВыбора.Вставить(0, "Строка", НСтр("ru = 'Строка';
																|en = 'String'"));
	
	ТипСтрокой = ПредставлениеТипа;
	
КонецПроцедуры

#КонецОбласти

