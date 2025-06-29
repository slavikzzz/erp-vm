///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

// Возвращает реквизиты объекта, которые не рекомендуется редактировать
// с помощью обработки группового изменения реквизитов.
//
// Возвращаемое значение:
//  Массив из Строка
//
Функция РеквизитыНеРедактируемыеВГрупповойОбработке() Экспорт
	
	Результат = Новый Массив;
	
	Результат.Добавить("КраткоеПредставление");
	Результат.Добавить("Комментарий");
	Результат.Добавить("ВнешняяРоль");
	Результат.Добавить("УзелОбмена");
	
	Возврат Результат
КонецФункции

// Конец СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

// Заполнение предопределенных элементов

#КонецОбласти

#КонецОбласти

#КонецЕсли

#Область ОбработчикиСобытий

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если Пользователи.ЭтоСеансВнешнегоПользователя() Тогда
		ТекущийПользователь = ВнешниеПользователи.ТекущийВнешнийПользователь();
		ЗначениеРеквизита = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ТекущийПользователь, "ОбъектАвторизации");
		ОбъектАвторизации = ?(ЗначениеРеквизита <> Неопределено,
							  Справочники[ЗначениеРеквизита.Метаданные().Имя].ПустаяСсылка(),
							  Справочники.Пользователи.ПустаяСсылка());
	Иначе
		ОбъектАвторизации =   Справочники.Пользователи.ПустаяСсылка();
	КонецЕсли;
	
	ФрагментыТекстаПоискДляДополнительныхЯзыков = Новый Массив;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Мультиязычность") Тогда
		МодульМультиязычностьСервер = ОбщегоНазначения.ОбщийМодуль("МультиязычностьСервер");
		
		Если МодульМультиязычностьСервер.ИспользуетсяПервыйДополнительныйЯзык() Тогда
			ФрагментыТекстаПоискДляДополнительныхЯзыков.Добавить(
				"РолиИсполнителей.НаименованиеЯзык1 ПОДОБНО &СтрокаПоиска СПЕЦСИМВОЛ ""~""");
		КонецЕсли;
		
		Если МодульМультиязычностьСервер.ИспользуетсяВторойДополнительныйЯзык() Тогда
			ФрагментыТекстаПоискДляДополнительныхЯзыков.Добавить(
				"РолиИсполнителей.НаименованиеЯзык2 ПОДОБНО &СтрокаПоиска СПЕЦСИМВОЛ ""~""");
		КонецЕсли;
		
	КонецЕсли;
	
	ТекстЗапроса = "ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 20
		|	РолиИсполнителей.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.РолиИсполнителей.Назначение КАК РолиИсполнителейНазначение
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.РолиИсполнителей КАК РолиИсполнителей
		|		ПО РолиИсполнителейНазначение.Ссылка = РолиИсполнителей.Ссылка
		|ГДЕ
		|	РолиИсполнителейНазначение.ТипПользователей = &Тип
		|	И (РолиИсполнителей.Наименование ПОДОБНО &СтрокаПоиска СПЕЦСИМВОЛ ""~"" 
		|			ИЛИ &ПоискДляДополнительныхЯзыков
		|			ИЛИ РолиИсполнителей.Код ПОДОБНО &СтрокаПоиска СПЕЦСИМВОЛ ""~"")
		|	И НЕ РолиИсполнителей.Ссылка ЕСТЬ NULL";
	
	Если ФрагментыТекстаПоискДляДополнительныхЯзыков.Количество() > 0 Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ПоискДляДополнительныхЯзыков", СтрСоединить(ФрагментыТекстаПоискДляДополнительныхЯзыков, " ИЛИ "));
	Иначе
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ПоискДляДополнительныхЯзыков", "ЛОЖЬ");
	КонецЕсли;
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Тип",          ОбъектАвторизации);
	Запрос.УстановитьПараметр("СтрокаПоиска", "%" + ОбщегоНазначения.СформироватьСтрокуДляПоискаВЗапросе(Параметры.СтрокаПоиска) + "%");
	РезультатЗапроса = Запрос.Выполнить().Выбрать();
	
	ДанныеВыбора = Новый СписокЗначений;
	Пока РезультатЗапроса.Следующий() Цикл
		ДанныеВыбора.Добавить(РезультатЗапроса.Ссылка, РезультатЗапроса.Ссылка);
	КонецЦикла;
	
КонецПроцедуры

#КонецЕсли

Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка)
	
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Мультиязычность") Тогда
		МодульМультиязычностьКлиентСервер = ОбщегоНазначения.ОбщийМодуль("МультиязычностьКлиентСервер");
		МодульМультиязычностьКлиентСервер.ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка);
	КонецЕсли;
#Иначе
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.Мультиязычность") Тогда
		МодульМультиязычностьКлиентСервер = ОбщегоНазначенияКлиент.ОбщийМодуль("МультиязычностьКлиентСервер");
		МодульМультиязычностьКлиентСервер.ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка);
	КонецЕсли;
#КонецЕсли
	
КонецПроцедуры

Процедура ОбработкаПолученияПолейПредставления(Поля, СтандартнаяОбработка)
	
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Мультиязычность") Тогда
		МодульМультиязычностьКлиентСервер = ОбщегоНазначения.ОбщийМодуль("МультиязычностьКлиентСервер");
		МодульМультиязычностьКлиентСервер.ОбработкаПолученияПолейПредставления(Поля, СтандартнаяОбработка);
	КонецЕсли;
#Иначе
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.Мультиязычность") Тогда
		МодульМультиязычностьКлиентСервер = ОбщегоНазначенияКлиент.ОбщийМодуль("МультиязычностьКлиентСервер");
		МодульМультиязычностьКлиентСервер.ОбработкаПолученияПолейПредставления(Поля, СтандартнаяОбработка);
	КонецЕсли;
#КонецЕсли
	
КонецПроцедуры

#КонецОбласти

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Смотри также ОбновлениеИнформационнойБазыПереопределяемый.ПриНастройкеНачальногоЗаполненияЭлементов
// 
// Параметры:
//  Настройки - см. ОбновлениеИнформационнойБазыПереопределяемый.ПриНастройкеНачальногоЗаполненияЭлементов.Настройки
//
Процедура ПриНастройкеНачальногоЗаполненияЭлементов(Настройки) Экспорт
	
	Настройки.ПриНачальномЗаполненииЭлемента = Истина;
	
КонецПроцедуры

// Смотри также ОбновлениеИнформационнойБазыПереопределяемый.ПриНачальномЗаполненииЭлементов
// 
// Параметры:
//   КодыЯзыков - см. ОбновлениеИнформационнойБазыПереопределяемый.ПриНачальномЗаполненииЭлементов.КодыЯзыков
//   Элементы - см. ОбновлениеИнформационнойБазыПереопределяемый.ПриНачальномЗаполненииЭлементов.Элементы
//   ТабличныеЧасти - см. ОбновлениеИнформационнойБазыПереопределяемый.ПриНачальномЗаполненииЭлементов.ТабличныеЧасти
//
Процедура ПриНачальномЗаполненииЭлементов(КодыЯзыков, Элементы, ТабличныеЧасти) Экспорт
	
	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "ОтветственныйЗаКонтрольИсполнения";
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Мультиязычность") Тогда
		МодульМультиязычностьСервер = ОбщегоНазначения.ОбщийМодуль("МультиязычностьСервер");
		МодульМультиязычностьСервер.ЗаполнитьМультиязычныйРеквизит(Элемент, "Наименование",
			"ru = 'Координатор выполнения задач';
			|en = 'Task control manager'", КодыЯзыков); // @НСтр-1
	Иначе
		Элемент.Наименование = НСтр("ru = 'Координатор выполнения задач';
									|en = 'Task control manager'", ОбщегоНазначения.КодОсновногоЯзыка());
	КонецЕсли;
	
	Элемент.ИспользуетсяБезОбъектовАдресации = Истина;
	Элемент.ИспользуетсяСОбъектамиАдресации  = Истина;
	Элемент.ВнешняяРоль                      = Ложь;
	Элемент.Код                              = "000000001";
	Элемент.КраткоеПредставление             = НСтр("ru = '000000001';
													|en = '000000001'", ОбщегоНазначения.КодОсновногоЯзыка());
	Элемент.ТипыОсновногоОбъектаАдресации = ПланыВидовХарактеристик.ОбъектыАдресацииЗадач.ВсеОбъектыАдресации;
	
	Назначение = ТабличныеЧасти.Назначение.Скопировать(); // ТаблицаЗначений
	ЭлементТЧ = Назначение.Добавить();
	ЭлементТЧ.ТипПользователей = Справочники.Пользователи.ПустаяСсылка();
	Элемент.Назначение = Назначение;
	
	БизнесПроцессыИЗадачиПереопределяемый.ПриНачальномЗаполненииРолейИсполнителей(КодыЯзыков, Элементы, ТабличныеЧасти);
	
КонецПроцедуры

// Смотри также ОбновлениеИнформационнойБазыПереопределяемый.ПриНастройкеНачальногоЗаполненияЭлементов
//
// Параметры:
//  Объект                  - СправочникОбъект.РолиИсполнителей - заполняемый объект.
//  Данные                  - СтрокаТаблицыЗначений - данные заполнения объекта.
//  ДополнительныеПараметры - Структура:
//   * ПредопределенныеДанные - ТаблицаЗначений - данные заполненные в процедуре ПриНачальномЗаполненииЭлементов.
//
Процедура ПриНачальномЗаполненииЭлемента(Объект, Данные, ДополнительныеПараметры) Экспорт
	
	БизнесПроцессыИЗадачиПереопределяемый.ПриНачальномЗаполненииРолиИсполнителя(Объект, Данные, ДополнительныеПараметры);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Регистрирует к обработке в обработчике обновления
//
Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ОбновлениеИнформационнойБазы.ЗарегистрироватьПредопределенныеЭлементыДляОбновления(Параметры, Метаданные.Справочники.РолиИсполнителей);
	
КонецПроцедуры

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	НастройкиЗаполнения = ОбновлениеИнформационнойБазы.НастройкиЗаполнения();
	ОбновлениеИнформационнойБазы.ЗаполнитьЭлементыНачальнымиДанными(Параметры, Метаданные.Справочники.РолиИсполнителей, НастройкиЗаполнения);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
