///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Обработчики подписок на события.

// Добавление полей, на основании которых будет формироваться представление бизнес-процесса.
//
// Параметры:
//  МенеджерОбъекта      - БизнесПроцессМенеджер - менеджер бизнес процесса.
//  Поля                 - Массив - поля, из которых формируется представление бизнес-процесса.
//  СтандартнаяОбработка - Булево - если установить Ложь, то стандартная обработка заполнения не будет
//                                  выполнена.
//
Процедура ОбработкаПолученияПолейПредставленияБизнесПроцесса(МенеджерОбъекта, Поля, СтандартнаяОбработка) Экспорт
	
	Поля.Добавить("Наименование");
	Поля.Добавить("Дата");
	СтандартнаяОбработка = Ложь;

КонецПроцедуры

// АПК:547-выкл Вызывается в подписке на событие ПолучитьПредставлениеБизнесПроцесса

// Обработка получения представления бизнес-процесса на основании полей данных.
//
// Параметры:
//  МенеджерОбъекта      - БизнесПроцессМенеджер - менеджер бизнес процесса.
//  Данные               - Структура - поля, из которых формируется представление бизнес процесса: 
//  Представление        - Строка - представление бизнес процесса.
//  СтандартнаяОбработка - Булево - если установить Ложь, то стандартная обработка заполнения не будет
//                                  выполнена.
//
Процедура ОбработкаПолученияПредставленияБизнесПроцесса(МенеджерОбъекта, Данные, Представление, СтандартнаяОбработка) Экспорт
	
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ТолстыйКлиентУправляемоеПриложение Или ВнешнееСоединение Тогда
	Дата = Формат(Данные.Дата, ?(ПолучитьФункциональнуюОпцию("ИспользоватьДатуИВремяВСрокахЗадач"), "ДЛФ=DT", "ДЛФ=D"));
	Представление = Метаданные.НайтиПоТипу(ТипЗнч(МенеджерОбъекта)).Представление();
#Иначе	
	Дата = Формат(Данные.Дата, "ДЛФ=D");
	Представление = НСтр("ru = 'Бизнес-процесс';
						|en = 'Business process'");
#КонецЕсли
	
	ПредставлениеБизнесПроцесса(МенеджерОбъекта, Данные, Дата, Представление, СтандартнаяОбработка);
	
КонецПроцедуры

// АПК:547-вкл Вызывается в подписке на событие ПолучитьПредставлениеБизнесПроцесса

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Обработка получения представления бизнес процесса на основание полей данных.
//
// Параметры:
//  МенеджерОбъекта      - БизнесПроцессМенеджер - менеджер бизнес процесса.
//  Данные               - Структура - поля, из которых формируется представление бизнес процесса, где:
//   * Наименование      - Строка - наименование бизнес-процесса.
//  Дата                 - Дата   - дата создания бизнес процесса.
//  Представление        - Строка - представление бизнес процесса.
//  СтандартнаяОбработка - Булево - если установить Ложь, то стандартная обработка заполнения не будет
//                                  выполнена.
//
Процедура ПредставлениеБизнесПроцесса(МенеджерОбъекта, Данные, Дата, Представление, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ШаблонПредставления  = НСтр("ru = '%1 от %2 (%3)';
								|en = '%1, started on %2 (%3)'");
	Наименование         = ?(ПустаяСтрока(Данные.Наименование), НСтр("ru = 'Без описания';
																	|en = 'No details'"), Данные.Наименование);
	
	Представление = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонПредставления, Наименование, Дата, Представление);
	
КонецПроцедуры

#КонецОбласти