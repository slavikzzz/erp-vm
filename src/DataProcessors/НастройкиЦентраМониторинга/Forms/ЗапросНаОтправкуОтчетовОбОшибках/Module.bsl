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
	ПараметрыДляПолучения = Новый Структура("ИнформацияОДампах, ВариантыДампов, ВариантыДамповОдобренные");
	ПараметрыЦентраМониторинга = ЦентрМониторингаСлужебный.ПолучитьПараметрыЦентраМониторинга(ПараметрыДляПолучения);
	ИнформацияОДампах = ПараметрыЦентраМониторинга.ИнформацияОДампах;
	Элементы.ИнформацияОДампах.Высота = СтрЧислоСтрок(ИнформацияОДампах);
	ДанныеОДампах = Новый Структура;
	ДанныеОДампах.Вставить("ВариантыДампов", ПараметрыЦентраМониторинга.ВариантыДампов);
	ДанныеОДампах.Вставить("ВариантыДамповОдобренные", ПараметрыЦентраМониторинга.ВариантыДамповОдобренные);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Да(Команда)
	Ответ = Новый Структура;
	Ответ.Вставить("Согласовано", Истина);
	Ответ.Вставить("ИнформацияОДампах", ИнформацияОДампах);
	Ответ.Вставить("НеСпрашиватьБольше", НеСпрашиватьБольше);
	Ответ.Вставить("ВариантыДампов", ДанныеОДампах.ВариантыДампов);
	Ответ.Вставить("ВариантыДамповОдобренные", ДанныеОДампах.ВариантыДамповОдобренные);	
	УстановитьПараметрыЦентраМониторинга(Ответ);
	Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура Нет(Команда)
	Ответ = Новый Структура;
	Ответ.Вставить("Согласовано", Ложь);
	Ответ.Вставить("НеСпрашиватьБольше", НеСпрашиватьБольше);
	УстановитьПараметрыЦентраМониторинга(Ответ);
	Закрыть();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Процедура УстановитьПараметрыЦентраМониторинга(Ответ)
	
	НовыеПараметры = Новый Структура;
	
	Если Ответ.Согласовано Тогда
		
		// Пользователь не хочет, чтобы его спрашивали.
		Если Ответ.НеСпрашиватьБольше Тогда
			НовыеПараметры.Вставить("СпрашиватьПередОтправкой", Ложь);
		КонецЕсли;
		
		// Запросим текущие параметры, т.к. они могли поменяться.
		ПараметрыДляПолучения = Новый Структура("ИнформацияОДампах, ВариантыДампов");
		ПараметрыЦентраМониторинга = ЦентрМониторингаСлужебный.ПолучитьПараметрыЦентраМониторинга(ПараметрыДляПолучения);
		
		// Добавляем к одобренным дампам те, что согласовал пользователь.
		НовыеПараметры.Вставить("ВариантыДамповОдобренные", Ответ.ВариантыДамповОдобренные);
		Для Каждого Запись Из Ответ.ВариантыДампов Цикл
			НовыеПараметры.ВариантыДамповОдобренные.Вставить(Запись.Ключ, Запись.Значение);
			ПараметрыЦентраМониторинга.ВариантыДампов.Удалить(Запись.Ключ);
		КонецЦикла;
		
		НовыеПараметры.Вставить("ВариантыДампов", ПараметрыЦентраМониторинга.ВариантыДампов);
		
		// Очищаем параметры.
		Если Ответ.ИнформацияОДампах = ПараметрыЦентраМониторинга.ИнформацияОДампах Тогда
			НовыеПараметры.Вставить("ИнформацияОДампах", "");	
		КонецЕсли;
		
	Иначе
		
		// Пользователь не хочет, чтобы его спрашивали и вообще не хочет ничего отправлять.
		Если Ответ.НеСпрашиватьБольше Тогда
			НовыеПараметры.Вставить("ОтправлятьФайлыДампов", 0);
			НовыеПараметры.Вставить("РезультатОтправки", НСтр("ru = 'Пользователь отказал в предоставлении полных дампов.';
																|en = 'User refused to submit full dumps.'"));
			// Согласовывать больше нечего, очищаем параметры.
			НовыеПараметры.Вставить("ИнформацияОДампах", "");
			НовыеПараметры.Вставить("ВариантыДампов", Новый Соответствие);
		КонецЕсли;
		
	КонецЕсли;    
	
	ЦентрМониторингаСлужебный.УстановитьПараметрыЦентраМониторингаВнешнийВызов(НовыеПараметры);
	
КонецПроцедуры

#КонецОбласти
