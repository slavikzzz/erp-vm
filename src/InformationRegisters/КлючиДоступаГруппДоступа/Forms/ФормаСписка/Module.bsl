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
	
	УстановитьУсловноеОформление();
	
	ТолькоПросмотр = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВключитьВозможностьРедактирования(Команда)
	
	ТолькоПросмотр = Ложь;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	// Оформление.
	ЭлементОформления = Список.КомпоновщикНастроек.Настройки.УсловноеОформление.Элементы.Добавить();
	ЭлементОформления.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	
	ЭлементТекстаОформления = ЭлементОформления.Оформление.Элементы.Найти("Text");
	ЭлементТекстаОформления.Значение = НСтр("ru = 'Разрешенная пустая группа доступа';
											|en = 'Allowed empty access group'");
	ЭлементТекстаОформления.Использование = Истина;
	
	ЭлементОтбора = ЭлементОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ГруппаДоступа");
	ЭлементОтбора.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбора.ПравоеЗначение = Справочники.ГруппыДоступа.ПустаяСсылка();
	ЭлементОтбора.Использование  = Истина;
	
	ЭлементПоля = ЭлементОформления.Поля.Элементы.Добавить();
	ЭлементПоля.Поле = Новый ПолеКомпоновкиДанных("ГруппаДоступа");
	ЭлементПоля.Использование = Истина;
	
КонецПроцедуры

#КонецОбласти
