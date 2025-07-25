#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область Проведение

// Формирует параметры для проведения документа по регистрам учетного механизма через общий механизм проведения.
//
// Параметры:
//  Документ - ДокументОбъект - записываемый документ
//  Свойства - См. ПроведениеДокументов.СвойстваДокумента
//
// Возвращаемое значение:
//  Структура - См. ПроведениеДокументов.ПараметрыУчетногоМеханизма
//
Функция ПараметрыДляПроведенияДокумента(Документ, Свойства) Экспорт
	
	Параметры = ПроведениеДокументов.ПараметрыУчетногоМеханизма();
	
	// Проведение
	Если Свойства.РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		
		Параметры.ПодчиненныеРегистры.Добавить(Метаданные.РегистрыНакопления.ДенежныеСредстваУПодотчетныхЛиц);
		
	КонецЕсли;
	
	// Контроль
	Если Свойства.РежимЗаписи <> РежимЗаписиДокумента.Запись Тогда
		
		Параметры.КонтрольныеРегистрыЗаданий.Добавить(Метаданные.РегистрыНакопления.ДенежныеСредстваУПодотчетныхЛиц);
		
	КонецЕсли;
	// Контроль даты запрета
	Если Свойства.РежимЗаписи <> РежимЗаписиДокумента.Запись Тогда
		Параметры.КонтрольныеРегистрыДатаЗапрета.Добавить(Метаданные.РегистрыНакопления.ДенежныеСредстваУПодотчетныхЛиц);
	КонецЕсли;
	Возврат Параметры;
	
КонецФункции

// Возвращает тексты запросов для сторнирования движений при исправлении документов
// 
// Параметры:
// 	МетаданныеДокумента - ОбъектМетаданныхДокумент - Метаданные документа, который проводится.
// 
// Возвращаемое значение:
// 	Соответствие - Соответствие полного имени регистра тексту запроса сторнирования
//
Функция ТекстыЗапросовСторнирования(МетаданныеДокумента) Экспорт
	
	ДвиженияДокумента = МетаданныеДокумента.Движения; 

	ТекстыЗапросов = Новый Соответствие();
	
	МетаданныеРегистра = Метаданные.РегистрыНакопления.ДенежныеСредстваУПодотчетныхЛиц;
	Если ДвиженияДокумента.Содержит(МетаданныеРегистра) Тогда
		ТекстыЗапросов.Вставить(МетаданныеРегистра.ПолноеИмя(),
			ПроведениеДокументов.ТекстСторнирующегоЗапроса(
				МетаданныеРегистра, МетаданныеДокумента));
	КонецЕсли;
	
	Возврат ТекстыЗапросов;
	
КонецФункции

// Процедура формирования движений по регистру.
//
// Параметры:
//	ТаблицыДляДвижений - Структура - таблицы данных документа
//	Движения - КоллекцияДвижений - коллекция наборов записей движений документа
//	Отказ - Булево - признак отказа от проведения документа.
//
Процедура ОтразитьДвижения(ТаблицыДляДвижений, Движения, Отказ) Экспорт
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ПроведениеДокументов.ОтразитьДвижения(ТаблицыДляДвижений, Движения, "ДенежныеСредстваУПодотчетныхЛиц");
	
КонецПроцедуры

// Дополняет текст запроса механизма проверки даты запрета по таблице изменений.
// 
// Параметры:
// 	Запрос - Запрос - используется для установки параметров запроса.
// 
// Возвращаемое значение:
//	Соответствие - соответствие имен таблиц изменения регистров и текстов запросов.
//	
Функция ТекстыЗапросовКонтрольДатыЗапретаПоТаблицеИзменений(Запрос) Экспорт

	СоответствиеТекстовЗапросов = Новый Соответствие();
	СоответствиеТекстовЗапросов.Вставить("ТаблицаИзмененийДенежныеСредстваУПодотчетныхЛиц", 
		РегистрыНакопления.ДенежныеСредстваУПодотчетныхЛиц.ТекстЗапросаКонтрольДатыЗапрета(Запрос));
	Возврат СоответствиеТекстовЗапросов;
	
КонецФункции

// Собирает структуру из текстов запросов для дальнейшей проверки даты запрета.
// 
// Параметры:
// 	Запрос - Запрос - Запрос по проверке даты запрета, можно установить параметры
// Возвращаемое значение:
// 	Структура - см. ЗакрытиеМесяцаСервер.ИнициализироватьСтруктуруТекстовЗапросов
Функция ТекстЗапросаКонтрольДатыЗапрета(Запрос) Экспорт
	ИмяРегистра = Метаданные.РегистрыНакопления.ДенежныеСредстваУПодотчетныхЛиц.Имя;
	ИмяТаблицыИзменений = "ТаблицаИзмененийДенежныеСредстваУПодотчетныхЛиц"; 
	СтруктураТекстовЗапросов = ПроведениеДокументов.ШаблонТекстЗапросаКонтрольДатыЗапрета(Запрос, 
		ИмяРегистра, 
		ИмяТаблицыИзменений, 
		"ФинансовыйКонтур");
	Возврат СтруктураТекстовЗапросов

КонецФункции

#КонецОбласти

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// Параметры:
//   Ограничение - см. УправлениеДоступомПереопределяемый.ПриЗаполненииОграниченияДоступа.Ограничение.
//
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(ПодотчетноеЛицо)
	|	И ЗначениеРазрешено(Организация)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

//++ НЕ УТ

// Заполняет параметры отражения движений регистра в финансовом учете
//
// Параметры:
//  МетаданныеРегистра - ОбъектМетаданныхРегистрНакопления - Метаданные регистра накопления
//  РегистрацияКОтражению - Булево - Признак получения параметров для регистрации к отражению в учете
//
// Возвращаемое значение:
// 	см. ФинансовыйУчетПоДаннымБалансовыхРегистров.ПараметрыОтраженияДвиженийВФинансовомУчете
//
Функция ПараметрыОтраженияДвиженийВФинансовомУчете(МетаданныеРегистра = Неопределено, РегистрацияКОтражению = Ложь) Экспорт
	
	ПараметрыОтражения = ФинансовыйУчетПоДаннымБалансовыхРегистров.ПараметрыОтраженияДвиженийВФинансовомУчете(РегистрацияКОтражению);
	
	Если РегистрацияКОтражению Тогда
		Возврат ПараметрыОтражения;
	КонецЕсли;
	
	ПараметрыОтражения.ПутьКДаннымИдентификаторСтроки = "ИдентификаторФинЗаписи";
	ПараметрыОтражения.ПутьКДаннымПодразделение = "Подразделение";
	//++ НЕ УТКА
	ПараметрыОтражения.ПутьКДаннымМестоУчета = "Подразделение";
	//-- НЕ УТКА
	ПараметрыОтражения.ПутьКДаннымВалюта = "Валюта";
	ПараметрыОтражения.РесурсыУпр.Добавить("СуммаУпр");
	ПараметрыОтражения.РесурсыРегл.Добавить("СуммаРегл");
	ПараметрыОтражения.РесурсыВал.Добавить("Сумма");
	ПараметрыОтражения.ТипДанныхУчета = Перечисления.ТипыДанныхУчета.ДенежныеСредства;
	ПараметрыОтражения.СтруктураАналитики = ОбщегоНазначения.СкопироватьРекурсивно(ИсточникиДанныхПовтИсп.СтруктураАналитикиПоТипуДанныхУчета(ПараметрыОтражения.ТипДанныхУчета));
	ПараметрыОтражения.СтруктураАналитики.ДенежныеСредства.ПутьКДанным = "ПодотчетноеЛицо";
	ПараметрыОтражения.СтруктураАналитики.ТипДенежныхСредств.Вставить("Значение", Перечисления.ТипыДенежныхСредств.ДенежныеСредстваУПодотчетногоЛица);
	ПараметрыОтражения.СтруктураАналитики.СтатьяКалькуляции.Вставить("Значение", Справочники.СтатьиКалькуляции.ПустаяСсылка());
	//++ Локализация
	ПараметрыОтражения.СтруктураАналитики.ТипПлатежаФЗ275.Вставить("Значение", Справочники.ТипыПлатежейФЗ275.ПустаяСсылка());
	ПараметрыОтражения.СтруктураАналитики.СтатьяЦелевыхСредств.Вставить("Значение", Неопределено);
	//-- Локализация
	
	Если МетаданныеРегистра = Неопределено Тогда
		МетаданныеРегистра = СоздатьНаборЗаписей().Метаданные();
	КонецЕсли;
	
	ФинансовыйУчетПоДаннымБалансовыхРегистров.ЗаполнитьПараметрыОтраженияПоМетаданнымРегистра(ПараметрыОтражения, МетаданныеРегистра);
	
	Возврат ПараметрыОтражения;
	
КонецФункции

//-- НЕ УТ

#КонецОбласти

//Выполняет очистку цели выдачи денежных средств подотчетнику
//
// Параметры:
//	Параметры - Структура - параметры обработчика ожидания
//	УникальныйИдентификатор - УникальныйИдентификатор - идентификатор обработчика ожидания.
//
Процедура ОчиститьЦелиВыдачиДенежныхСредствПодотчетнику(Параметры, УникальныйИдентификатор) Экспорт
	
	НачатьТранзакцию();
	
	Попытка
		
		БлокировкаУстановлена = Ложь;	
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить("РегистрНакопления.ДенежныеСредстваУПодотчетныхЛиц");
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
		Блокировка.Заблокировать();
		БлокировкаУстановлена = Истина;
			
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ДенежныеСредстваУПодотчетныхЛиц.Регистратор КАК Регистратор
		|ИЗ
		|	РегистрНакопления.ДенежныеСредстваУПодотчетныхЛиц КАК ДенежныеСредстваУПодотчетныхЛиц
		|ГДЕ
		|	НЕ ДенежныеСредстваУПодотчетныхЛиц.ЦельВыдачи = ЗНАЧЕНИЕ(Справочник.СтатьиДвиженияДенежныхСредств.ПустаяСсылка)";
		
		Результат = Запрос.Выполнить();
		Если Результат.Пустой() Тогда
			Возврат;
		КонецЕсли;
		
		НаборЗаписей = РегистрыНакопления.ДенежныеСредстваУПодотчетныхЛиц.СоздатьНаборЗаписей();
		НаборЗаписей.ОбменДанными.Загрузка = Истина;
		Выборка = Результат.Выбрать();
			
		Пока Выборка.Следующий() Цикл
			
			НаборЗаписей.Отбор.Регистратор.Значение = Выборка.Регистратор;
			НаборЗаписей.Прочитать();
			
			Для Каждого ЗаписьНабора Из НаборЗаписей Цикл
				ЗаписьНабора.ЦельВыдачи = Справочники.СтатьиДвиженияДенежныхСредств.ПустаяСсылка();
			КонецЦикла;
			
			НаборЗаписей.Записать();
				
		КонецЦикла;
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
			
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Выполнение очистки цели выдачи денежных средств подотчетнику';
										|en = 'Cleaning the purpose of issuing cash to the advance holder'"),
		        УровеньЖурналаРегистрации.Ошибка,
		        ,
		        ,
		        ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		
		Если Не БлокировкаУстановлена Тогда
			ТекстИсключения = НСтр("ru = 'Не удалось выполнить операцию.
			|Необходимо запустить в монопольном режиме.';
			|en = 'The operation failed.
			|Run it in exclusive mode.'");
			ВызватьИсключение ТекстИсключения;
		КонецЕсли;
		
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ОбновлениеИнформационнойБазы

// см. ОбновлениеИнформационнойБазыБСП.ПриДобавленииОбработчиковОбновления
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт

	Обработчик = Обработчики.Добавить();
	Обработчик.Процедура = "РегистрыНакопления.ДенежныеСредстваУПодотчетныхЛиц.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	Обработчик.Версия = "11.5.17.183";
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Идентификатор = Новый УникальныйИдентификатор("592693f6-c5c9-4225-a994-becfddefe62b");
	Обработчик.Многопоточный = Истина;
	Обработчик.ПроцедураЗаполненияДанныхОбновления = "РегистрыНакопления.ДенежныеСредстваУПодотчетныхЛиц.ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию";
	Обработчик.ПроцедураПроверки = "ОбновлениеИнформационнойБазы.ДанныеОбновленыНаНовуюВерсиюПрограммы";
	Обработчик.Порядок = Перечисления.ПорядокОбработчиковОбновления.Некритичный;
	Обработчик.Комментарий = НСтр("ru = 'Устанавливает время записей для документов ""Бронирование"".';
									|en = 'Устанавливает время записей для документов ""Бронирование"".'");
	
	Читаемые = Новый Массив;
	Читаемые.Добавить(Метаданные.РегистрыНакопления.ДенежныеСредстваУПодотчетныхЛиц.ПолноеИмя());
	Читаемые.Добавить(Метаданные.РегистрыНакопления.РасчетыСПоставщикамиПоСрокам.ПолноеИмя());
	Обработчик.ЧитаемыеОбъекты = СтрСоединить(Читаемые, ",");
	
	Изменяемые = Новый Массив;
	Изменяемые.Добавить(Метаданные.РегистрыНакопления.ДенежныеСредстваУПодотчетныхЛиц.ПолноеИмя());
	Обработчик.ИзменяемыеОбъекты = СтрСоединить(Изменяемые, ",");
	
	Блокируемые = Новый Массив;
	Блокируемые.Добавить(Метаданные.РегистрыНакопления.ДенежныеСредстваУПодотчетныхЛиц.ПолноеИмя());
	Обработчик.БлокируемыеОбъекты = СтрСоединить(Блокируемые, ",");
	
КонецПроцедуры

// Параметры:
// 	Параметры - см. ОбновлениеИнформационнойБазы.ОсновныеПараметрыОтметкиКОбработке
//
Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ПолноеИмяРегистра	= "РегистрНакопления.ДенежныеСредстваУПодотчетныхЛиц";
	
	ПараметрыВыборки = Параметры.ПараметрыВыборки;
	ПараметрыВыборки.ПолныеИменаРегистров = ПолноеИмяРегистра;
	ПараметрыВыборки.ПоляУпорядочиванияПриРаботеПользователей.Добавить("Период УБЫВ");
	ПараметрыВыборки.ПоляУпорядочиванияПриОбработкеДанных.Добавить("Период УБЫВ");
	ПараметрыВыборки.СпособВыборки = ОбновлениеИнформационнойБазы.СпособВыборкиРегистраторыРегистра();
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	// Исправить время движений документов ""Бронирование""
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ДенежныеСредстваУПодотчетныхЛиц.Регистратор КАК Ссылка
	|ИЗ
	|	РегистрНакопления.ДенежныеСредстваУПодотчетныхЛиц КАК ДенежныеСредстваУПодотчетныхЛиц
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.Бронирование КАК Бронирование
	|	ПО ДенежныеСредстваУПодотчетныхЛиц.Регистратор = Бронирование.Ссылка
	|ГДЕ
	|	&НоваяАрхитектураВзаиморасчетов
	|	И ГОД(ДенежныеСредстваУПодотчетныхЛиц.Период) = ГОД(Бронирование.Дата)
	|	И МЕСЯЦ(ДенежныеСредстваУПодотчетныхЛиц.Период) = МЕСЯЦ(Бронирование.Дата)
	|	И ДЕНЬ(ДенежныеСредстваУПодотчетныхЛиц.Период) = ДЕНЬ(Бронирование.Дата)
	|	И (ЧАС(ДенежныеСредстваУПодотчетныхЛиц.Период) <> ЧАС(Бронирование.Дата)
	|		ИЛИ МИНУТА(ДенежныеСредстваУПодотчетныхЛиц.Период) <> МИНУТА(Бронирование.Дата)
	|		ИЛИ СЕКУНДА(ДенежныеСредстваУПодотчетныхЛиц.Период) <> СЕКУНДА(Бронирование.Дата))
	|";
	Запрос.УстановитьПараметр("НоваяАрхитектураВзаиморасчетов", ПолучитьФункциональнуюОпцию("НоваяАрхитектураВзаиморасчетов"));
	
	Регистраторы = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	ОбновлениеИнформационнойБазы.ОтметитьРегистраторыКОбработке(Параметры, Регистраторы, ПолноеИмяРегистра);
	
КонецПроцедуры

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт

	МетаданныеРегистра = Метаданные.РегистрыНакопления.ДенежныеСредстваУПодотчетныхЛиц;
	ПолноеИмяРегистра = МетаданныеРегистра.ПолноеИмя();
	
	ОбновляемыеДанные = ОбновлениеИнформационнойБазы.ДанныеДляОбновленияВМногопоточномОбработчике(Параметры);
	Если ОбновляемыеДанные.Количество() = 0 Тогда
		Параметры.ОбработкаЗавершена = ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(Параметры.Очередь, ПолноеИмяРегистра);
		Возврат;
	КонецЕсли;
	
	СписокОписаний = Новый Массив;
	СписокОписаний.Добавить(НСтр("ru = 'Не удалось установить время записей для документов ""Бронирование"" в регистре накопления ""Денежные средства у подотчетных лиц"".';
								|en = 'Не удалось установить время записей для документов ""Бронирование"" в регистре накопления ""Денежные средства у подотчетных лиц"".'"));
	
	Для Каждого СтрокаТаблицы Из ОбновляемыеДанные Цикл
		
		ПроблемныйРегистратор = СтрокаТаблицы.Регистратор;
		ПричинаИсключения = "";
		Рекомендация = "";
		
		НачатьТранзакцию();
		
		Попытка
			
			ПричинаИсключения = "Блокировка";
			
			Блокировка = Новый БлокировкаДанных;
			
			ЭлементБлокировки = Блокировка.Добавить(ПолноеИмяРегистра + ".НаборЗаписей");
			ЭлементБлокировки.УстановитьЗначение("Регистратор", ПроблемныйРегистратор);
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
			
			Блокировка.Заблокировать();
				
			ПричинаИсключения = "ПлохиеДанные";
			Рекомендация = НСтр("ru = 'Перепроведите документ вручную.';
								|en = 'Перепроведите документ вручную.'");
			
			НаборЗаписей = РегистрыНакопления.ДенежныеСредстваУПодотчетныхЛиц.СоздатьНаборЗаписей();
			НаборЗаписей.Отбор.Регистратор.Установить(ПроблемныйРегистратор);
			НаборЗаписей.Прочитать();
			
			#Область ИсправлениеВремениОперацииБронирования
			ДатаДокумента = Дата(1,1,1);
			Если ТипЗнч(ПроблемныйРегистратор) = Тип("ДокументСсылка.Бронирование") Тогда
				ДатаДокумента = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ПроблемныйРегистратор, "Дата");
			КонецЕсли;
			#КонецОбласти
			
			Для Каждого Запись Из НаборЗаписей Цикл
				
				#Область ИсправлениеВремениОперацииБронирования
				Если ТипЗнч(Запись.Регистратор) = Тип("ДокументСсылка.Бронирование")
					И ЗначениеЗаполнено(ДатаДокумента) Тогда
					РегистрыНакопления.РасчетыСПоставщиками.ПроверитьИУстановитьВремяПериодаЗаписи(Запись, ДатаДокумента);
				КонецЕсли;
				#КонецОбласти
				
			КонецЦикла;
			
			ПричинаИсключения = "Запись";
			
			Если НаборЗаписей.Модифицированность() Тогда
				ОбновлениеИнформационнойБазы.ЗаписатьНаборЗаписей(НаборЗаписей);
			Иначе
				ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(НаборЗаписей);
			КонецЕсли;
			
			ЗафиксироватьТранзакцию();
			
		Исключение
			
			ОтменитьТранзакцию();
			ОбновлениеИнформационнойБазыУТ.СообщитьОНеудачнойОбработке(ИнформацияОбОшибке(), ПроблемныйРегистратор);
			
			Если ПричинаИсключения = "ПлохиеДанные" Тогда
				
				ОбновлениеИнформационнойБазы.ЗарегистрироватьПроблемуСДанными(ПроблемныйРегистратор, Рекомендация, Параметры);
				
			ИначеЕсли ПричинаИсключения = "Запись" Тогда
				
				ВызватьИсключение СтрСоединить(СписокОписаний, Символы.ПС);
				
			КонецЕсли;
			
		КонецПопытки;
	
	КонецЦикла;
	
	Параметры.ОбработкаЗавершена = ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(Параметры.Очередь, ПолноеИмяРегистра);

КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
