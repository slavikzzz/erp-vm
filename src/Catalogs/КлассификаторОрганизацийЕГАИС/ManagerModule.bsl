#Область ОбработчикиСобытий

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	Если ОбщегоНазначенияЕГАИС.ЭтоРасширеннаяВерсияГосИС() Тогда
		МодульИнтеграцияЕГАИСВызовСервера = ОбщегоНазначения.ОбщийМодуль("ИнтеграцияЕГАИСВызовСервера");
		МодульИнтеграцияЕГАИСВызовСервера.ПриПолученииФормыСправочника(
			"КлассификаторОрганизацийЕГАИС",
			ВидФормы,
			Параметры,
			ВыбраннаяФорма,
			ДополнительнаяИнформация,
			СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры

#КонецЕсли

Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка)
	
	Если Данные.Наименование = "" Тогда
		СтандартнаяОбработка = Ложь;
		Представление = СтрШаблон(НСтр("ru = '<Новая организация (%1)>';
										|en = '<Новая организация (%1)>'"), Данные.Код);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПолученияПолейПредставления(Поля, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Поля.Добавить("Наименование");
	Поля.Добавить("Код");
	
КонецПроцедуры

#КонецОбласти

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Рассчитывает сопоставлены ли данные ЕГАИС с данными информационной базы.
//
// Параметры:
//  ТорговыйОбъект - ОпределяемыйТип.ТорговыйОбъектЕГАИС - Склад или партнер.
//  ОрганизацияКонтрагент - ОпределяемыйТип.ОрганизацияКонтрагентГосИС - Организация или контрагент.
//  СоответствуетОрганизации - Булево - классификатор соответствует организации
// 
// Возвращаемое значение:
//  Булево - Признак выполненного сопоставления.
//
Функция РассчитатьСопоставлено(ТорговыйОбъект, ОрганизацияКонтрагент, СоответствуетОрганизации) Экспорт
	
	Сопоставлено = Ложь;
	
	Если СоответствуетОрганизации Тогда
		
		Если ЗначениеЗаполнено(ТорговыйОбъект) И ЗначениеЗаполнено(ОрганизацияКонтрагент) Тогда
			Сопоставлено = Истина;
		КонецЕсли;
		
	Иначе
		
		Если ЗначениеЗаполнено(ОрганизацияКонтрагент)
			И (ЗначениеЗаполнено(ТорговыйОбъект) ИЛИ Не РаботаСКонтрагентамиЕГАИС.ИспользоватьТорговыеОбъектыКонтрагентов()) Тогда
			Сопоставлено = Истина;
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Сопоставлено;
	
КонецФункции

// Возвращает ссылку на элемент классификатора организаций ЕГАИС по переданным параметрам.
//
// Параметры:
//  Организация - ОпределяемыйТип.ОрганизацияКонтрагентГосИС - ссылка на собственную организацию или контрагента,
//  ТорговыйОбъект - ОпределяемыйТип.ТорговыйОбъектЕГАИС - ссылка на собственный торговый объект или партнера,
//  СоответствуетОрганизации - Булево - если Истина, то будут отобраны только элементы, являющиеся собственными юр. лицами,
//  ТолькоСопоставленные - Булево - если Истина, то будут выбраны только корректно сопоставленные элементы.
//
// Возвращаемое значение:
//  СправочникСсылка.КлассификаторОрганизацийЕГАИС - найденная организация,
//  Неопределено - организация с переданными параметрами не найдена.
//
Функция ОрганизацияЕГАИСПоОрганизацииИТорговомуОбъекту(Организация, ТорговыйОбъект, СоответствуетОрганизации = Истина, ТолькоСопоставленные = Истина) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Контрагент"              , Организация);
	Запрос.УстановитьПараметр("ТорговыйОбъект"          , ТорговыйОбъект);
	Запрос.УстановитьПараметр("СоответствуетОрганизации", СоответствуетОрганизации);
	Запрос.УстановитьПараметр("ТолькоСопоставленные"    , ТолькоСопоставленные);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	КлассификаторОрганизацийЕГАИС.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.КлассификаторОрганизацийЕГАИС КАК КлассификаторОрганизацийЕГАИС
	|ГДЕ
	|	НЕ КлассификаторОрганизацийЕГАИС.ПометкаУдаления
	|	И КлассификаторОрганизацийЕГАИС.Контрагент = &Контрагент
	|	И КлассификаторОрганизацийЕГАИС.ТорговыйОбъект = &ТорговыйОбъект
	|	И КлассификаторОрганизацийЕГАИС.СоответствуетОрганизации = &СоответствуетОрганизации
	|	И ВЫБОР
	|			КОГДА &ТолькоСопоставленные
	|				ТОГДА КлассификаторОрганизацийЕГАИС.Сопоставлено
	|			ИНАЧЕ ИСТИНА
	|		КОНЕЦ";
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат РезультатЗапроса.Выгрузить()[0].Ссылка;
	
КонецФункции

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ВЫБОР КОГДА Сопоставлено И СоответствуетОрганизации Тогда ЗначениеРазрешено(Контрагент)
	|	КОГДА Сопоставлено И НЕ СоответствуетОрганизации Тогда ЗначениеРазрешено(ТорговыйОбъект)
	|	ИНАЧЕ ИСТИНА КОНЕЦ ";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает массив ссылок на элементы классификатора организаций ЕГАИС по переданному ИНН.
//
// Параметры:
//  ИНН - Строка - ИНН организации
//
// Возвращаемое значение:
//  Массив Из СправочникСсылка.КлассификаторОрганизацийЕГАИС - найденные организации
//
Функция ОрганизацииЕГАИСпоИНН(ИНН) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ИНН", ИНН);
	
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	КлассификаторОрганизацийЕГАИС.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.КлассификаторОрганизацийЕГАИС КАК КлассификаторОрганизацийЕГАИС
	|ГДЕ
	|	НЕ КлассификаторОрганизацийЕГАИС.ПометкаУдаления
	|	И КлассификаторОрганизацийЕГАИС.ИНН = &ИНН
	|";
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("Ссылка");
	
КонецФункции

#Область ОбновлениеИнформационнойБазы

Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	КлассификаторОрганизацийЕГАИС.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.КлассификаторОрганизацийЕГАИС КАК КлассификаторОрганизацийЕГАИС
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.УдалитьФорматыОбменаЕГАИС КАК ФорматыОбменаЕГАИС
	|		ПО КлассификаторОрганизацийЕГАИС.Код = ФорматыОбменаЕГАИС.ИдентификаторФСРАР
	|ГДЕ
	|	КлассификаторОрганизацийЕГАИС.ФорматОбмена <> ФорматыОбменаЕГАИС.ФорматОбмена";
	
	МассивСсылок = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, МассивСсылок);
	
КонецПроцедуры

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ПолноеИмяОбъекта = "Справочник.КлассификаторОрганизацийЕГАИС";
	МетаданныеОбъекта = Метаданные.Справочники.КлассификаторОрганизацийЕГАИС;
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Результат = ОбновлениеИнформационнойБазы.СоздатьВременнуюТаблицуСсылокДляОбработки(Параметры.Очередь, ПолноеИмяОбъекта, МенеджерВременныхТаблиц);
	
	Если НЕ Результат.ЕстьДанныеДляОбработки Тогда
		Параметры.ОбработкаЗавершена = Истина;
		Возврат;
	КонецЕсли;
	Если НЕ Результат.ЕстьЗаписиВоВременнойТаблице Тогда
		Параметры.ОбработкаЗавершена = Ложь;
		Возврат;
	КонецЕсли;
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ВЫРАЗИТЬ(ВТСсылкиДляОбработки.Ссылка КАК Справочник.КлассификаторОрганизацийЕГАИС) КАК Ссылка
	|ПОМЕСТИТЬ СсылкиДляОбработки
	|ИЗ
	|	&ВТСсылкиДляОбработки КАК ВТСсылкиДляОбработки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СсылкиДляОбработки.Ссылка,
	|	ЕСТЬNULL(ФорматыОбменаЕГАИС.ФорматОбмена, ЗНАЧЕНИЕ(Перечисление.ФорматыОбменаЕГАИС.ПустаяСсылка)) КАК ФорматОбменаИзНастроек,
	|	ЕСТЬNULL(ФорматыОбменаЕГАИС.ИдентификаторФСРАР, НЕОПРЕДЕЛЕНО) КАК ИдентификаторФСРАР
	|ИЗ
	|	СсылкиДляОбработки КАК СсылкиДляОбработки
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.УдалитьФорматыОбменаЕГАИС КАК ФорматыОбменаЕГАИС
	|		ПО СсылкиДляОбработки.Ссылка.Код = ФорматыОбменаЕГАИС.ИдентификаторФСРАР";
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ВТСсылкиДляОбработки", Результат.ИмяВременнойТаблицы);
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		НачатьТранзакцию();
		Попытка
			
			Если Выборка.ИдентификаторФСРАР = Неопределено Тогда
				ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(Выборка.Ссылка,, Параметры.Очередь);
				ЗафиксироватьТранзакцию();
				Продолжить;
			КонецЕсли;
			
			Блокировка = Новый БлокировкаДанных;
			
			ЭлементБлокировки = Блокировка.Добавить(ПолноеИмяОбъекта);
			ЭлементБлокировки.УстановитьЗначение("Ссылка", Выборка.Ссылка);
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
			
			ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.УдалитьФорматыОбменаЕГАИС");
			ЭлементБлокировки.УстановитьЗначение("ИдентификаторФСРАР", Выборка.ИдентификаторФСРАР);
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
			
			Блокировка.Заблокировать();
			
			ОрганизацияЕГАИС = Выборка.Ссылка.ПолучитьОбъект();
			
			Если ОрганизацияЕГАИС = Неопределено Тогда
				ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(Выборка.Ссылка,, Параметры.Очередь);
				ЗафиксироватьТранзакцию();
				Продолжить;
			КонецЕсли;
			
			Если Выборка.ФорматОбменаИзНастроек = ОрганизацияЕГАИС.ФорматОбмена Тогда
				ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(Выборка.Ссылка,, Параметры.Очередь);
				ЗафиксироватьТранзакцию();
				Продолжить;
			КонецЕсли;
			
			ОрганизацияЕГАИС.ФорматОбмена = Выборка.ФорматОбменаИзНастроек;
			
			ОбновлениеИнформационнойБазы.ЗаписатьОбъект(ОрганизацияЕГАИС);
			
			ЗафиксироватьТранзакцию();
			
		Исключение
			
			ОтменитьТранзакцию();
			ТекстСообщения = НСтр("ru = 'Не удалось обработать справочник: %Справочник% по причине: %Причина%';
									|en = 'Не удалось обработать справочник: %Справочник% по причине: %Причина%'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Справочник%", Выборка.Ссылка);
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Причина%", ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
			                         УровеньЖурналаРегистрации.Предупреждение,
			                         МетаданныеОбъекта,
			                         Выборка.Ссылка,
			                         ТекстСообщения);
			
		КонецПопытки;
		
	КонецЦикла;
	
	Параметры.ОбработкаЗавершена = НЕ ОбновлениеИнформационнойБазы.ЕстьДанныеДляОбработки(Параметры.Очередь, ПолноеИмяОбъекта);
	
КонецПроцедуры

Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаФорматОбмена3(Параметры) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	КлассификаторОрганизацийЕГАИС.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.КлассификаторОрганизацийЕГАИС КАК КлассификаторОрганизацийЕГАИС
	|ГДЕ
	|	КлассификаторОрганизацийЕГАИС.ФорматОбмена <> ЗНАЧЕНИЕ(Перечисление.ФорматыОбменаЕГАИС.V3)";
	
	МассивСсылок = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, МассивСсылок);
	
КонецПроцедуры

Процедура УстановитьФорматОбмена3(Параметры) Экспорт
	
	ПолноеИмяОбъекта = "Справочник.КлассификаторОрганизацийЕГАИС";
	МетаданныеОбъекта = Метаданные.Справочники.КлассификаторОрганизацийЕГАИС;
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Результат = ОбновлениеИнформационнойБазы.СоздатьВременнуюТаблицуСсылокДляОбработки(Параметры.Очередь, ПолноеИмяОбъекта, МенеджерВременныхТаблиц);
	
	Если НЕ Результат.ЕстьДанныеДляОбработки Тогда
		Параметры.ОбработкаЗавершена = Истина;
		Возврат;
	КонецЕсли;
	Если НЕ Результат.ЕстьЗаписиВоВременнойТаблице Тогда
		Параметры.ОбработкаЗавершена = Ложь;
		Возврат;
	КонецЕсли;
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ВТСсылкиДляОбработки.Ссылка КАК Ссылка
	|ИЗ
	|	&ВТСсылкиДляОбработки КАК ВТСсылкиДляОбработки";
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ВТСсылкиДляОбработки", Результат.ИмяВременнойТаблицы);
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		НачатьТранзакцию();
		Попытка
			
			Блокировка = Новый БлокировкаДанных;
			
			ЭлементБлокировки = Блокировка.Добавить(ПолноеИмяОбъекта);
			ЭлементБлокировки.УстановитьЗначение("Ссылка", Выборка.Ссылка);
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
			
			Блокировка.Заблокировать();
			
			ОрганизацияЕГАИС = Выборка.Ссылка.ПолучитьОбъект();
			
			Если ОрганизацияЕГАИС = Неопределено Тогда
				ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(Выборка.Ссылка,, Параметры.Очередь);
				ЗафиксироватьТранзакцию();
				Продолжить;
			КонецЕсли;
			
			Если ОрганизацияЕГАИС.ФорматОбмена = Перечисления.ФорматыОбменаЕГАИС.V3 Тогда
				ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(Выборка.Ссылка,, Параметры.Очередь);
				ЗафиксироватьТранзакцию();
				Продолжить;
			КонецЕсли;
			
			ОрганизацияЕГАИС.ФорматОбмена = Перечисления.ФорматыОбменаЕГАИС.V3;
			
			ОбновлениеИнформационнойБазы.ЗаписатьОбъект(ОрганизацияЕГАИС);
			
			ЗафиксироватьТранзакцию();
			
		Исключение
			
			ОтменитьТранзакцию();
			ТекстСообщения = НСтр("ru = 'Не удалось обработать справочник: %Справочник% по причине: %Причина%';
									|en = 'Не удалось обработать справочник: %Справочник% по причине: %Причина%'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Справочник%", Выборка.Ссылка);
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Причина%", ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
			                         УровеньЖурналаРегистрации.Предупреждение,
			                         МетаданныеОбъекта,
			                         Выборка.Ссылка,
			                         ТекстСообщения);
			
		КонецПопытки;
		
	КонецЦикла;
	
	Параметры.ОбработкаЗавершена = НЕ ОбновлениеИнформационнойБазы.ЕстьДанныеДляОбработки(Параметры.Очередь, ПолноеИмяОбъекта);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли