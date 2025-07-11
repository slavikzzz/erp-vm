///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	Ограничение.Текст =
	"РазрешитьЧтение
	|ГДЕ
	|	ЧтениеОбъектаРазрешено(ИсходящийДокумент)
	|;
	|РазрешитьИзменениеЕслиРазрешеноЧтение
	|ГДЕ
	|	ИзменениеОбъектаРазрешено(ИсходящийДокумент)";
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти


#Область СлужебныйПрограммныйИнтерфейс

// АПК:581-выкл. Методы могут вызываться из расширений.
// АПК:299-выкл. Методы могут вызываться из расширений.
// АПК:326-выкл. Методы поставляются комплектом и предназначены для совместного последовательного использования.
// АПК:325-выкл. Методы поставляются комплектом и предназначены для совместного последовательного использования.
// Транзакция открывается в методе НачатьЗаписьНабора, закрывается в ЗавершитьЗаписьНабора, отменяется в ОтменитьЗаписьНабора.

// Транзакционный вариант (с управляемой блокировкой) получения набора записей, соответствующего значениям измерений.
//
// Параметры:
//   ИдентификаторСообщения - Строка - Значение отбора по соответствующему измерению.
//
// Возвращаемое значение:
//   РегистрСведенийНаборЗаписей.РегистрацииЗапросовСтатусовВыплатыПособий - Если удалось установить блокировку
//       и прочитать набор записей. При необходимости, открывает свою локальную транзакцию. Для закрытия транзакции
//       следует использовать одну из терминирующих процедур: ЗавершитьЗаписьНабора, либо ОтменитьЗаписьНабора.
//   Неопределено - Если не удалось установить блокировку и прочитать набор записей.
//       Вызывать процедуры ЗавершитьЗаписьНабора, ОтменитьЗаписьНабора не требуется,
//       поскольку если перед блокировкой функции потребовалось открыть локальную транзакцию,
//       то после неудачной блокировки локальная транзакция была отменена.
//
Функция НачатьЗаписьНабора(ИдентификаторСообщения) Экспорт
	Если Не ЗначениеЗаполнено(ИдентификаторСообщения) Тогда
		Возврат Неопределено;
	КонецЕсли;
	ПолныеПраваИлиПривилегированныйРежим = Пользователи.ЭтоПолноправныйПользователь();
	Если Не ПолныеПраваИлиПривилегированныйРежим
		И Не ПравоДоступа("Изменение", Метаданные.РегистрыСведений.РегистрацииЗапросовСтатусовВыплатыПособий) Тогда
		ВызватьИсключение СтрШаблон(
			НСтр("ru = 'Недостаточно прав для изменения регистра ""%1"".';
				|en = 'Insufficient rights to change register ""%1"".'"),
			Метаданные.РегистрыСведений.РегистрацииЗапросовСтатусовВыплатыПособий.Представление());
	КонецЕсли;
	ЛокальнаяТранзакция = Не ТранзакцияАктивна();
	Если ЛокальнаяТранзакция Тогда
		НачатьТранзакцию();
	КонецЕсли;
	Попытка
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.РегистрацииЗапросовСтатусовВыплатыПособий");
		ЭлементБлокировки.УстановитьЗначение("ИдентификаторСообщения", ИдентификаторСообщения);
		Блокировка.Заблокировать();
		НаборЗаписей = СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.ИдентификаторСообщения.Установить(ИдентификаторСообщения);
		НаборЗаписей.Прочитать();
		НаборЗаписей.ДополнительныеСвойства.Вставить("ЛокальнаяТранзакция", ЛокальнаяТранзакция);
	Исключение
		Если ЛокальнаяТранзакция Тогда
			ОтменитьТранзакцию();
		КонецЕсли;
		ТекстСообщения = СтрШаблон(
			НСтр("ru = 'Не удалось изменить регистрацию запроса сведений о выплате пособия %1 по причине: %2';
				|en = 'Не удалось изменить регистрацию запроса сведений о выплате пособия %1 по причине: %2'"),
			ИдентификаторСообщения,
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ЗаписьЖурналаРегистрации(
			ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
			УровеньЖурналаРегистрации.Предупреждение,
			Метаданные.РегистрыСведений.РегистрацииЗапросовСтатусовВыплатыПособий,
			ИдентификаторСообщения,
			ТекстСообщения);
		НаборЗаписей = Неопределено;
		ВызватьИсключение;
	КонецПопытки;
	
	Возврат НаборЗаписей;
КонецФункции

// Записывает набор и фиксирует локальную транзакцию, если она была открыта в функции НачатьЗаписьНабора.
//
// Параметры:
//   НаборЗаписей - РегистрСведенийНаборЗаписей.РегистрацииЗапросовСтатусовВыплатыПособий
//
Процедура ЗавершитьЗаписьНабора(НаборЗаписей) Экспорт
	НаборЗаписей.Записать(Истина);
	ЛокальнаяТранзакция = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(НаборЗаписей.ДополнительныеСвойства, "ЛокальнаяТранзакция");
	Если ЛокальнаяТранзакция = Истина Тогда
		ЗафиксироватьТранзакцию();
	КонецЕсли;
КонецПроцедуры

// Отменяет запись набора и отменяет локальную транзакцию, если она была открыта в функции НачатьЗаписьНабора.
//
// Параметры:
//   НаборЗаписей - РегистрСведенийНаборЗаписей.РегистрацииЗапросовСтатусовВыплатыПособий
//
Процедура ОтменитьЗаписьНабора(НаборЗаписей) Экспорт
	ЛокальнаяТранзакция = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(НаборЗаписей.ДополнительныеСвойства, "ЛокальнаяТранзакция");
	Если ЛокальнаяТранзакция = Истина Тогда
		ОтменитьТранзакцию();
	КонецЕсли;
КонецПроцедуры

// АПК:326-вкл.
// АПК:325-вкл.
// АПК:299-вкл.
// АПК:581-вкл.

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

#Область СЭДО

Процедура ЗаполнитьПоДокументу(Запись, ИсходящийДокументОбъект) Экспорт
	Запись.ИсходящийДокумент   = ИсходящийДокументОбъект.Ссылка;
	Запись.ГоловнаяОрганизация = ИсходящийДокументОбъект.ГоловнаяОрганизация;
	Запись.Страхователь        = ИсходящийДокументОбъект.Страхователь;
КонецПроцедуры

// Загружает ошибку логического контроля (тип 14) полученную в ответ на документ СЭДО 84.
Процедура ЗагрузитьОшибкуСообщения84(Страхователь, ИдентификаторСообщения84, ТекстОшибки, Результат) Экспорт
	УстановитьПривилегированныйРежим(Истина);
	
	Набор = НачатьЗаписьНабора(ИдентификаторСообщения84);
	Если Набор.Количество() = 0 Тогда
		Запись = Набор.Добавить();
	Иначе
		Запись = Набор[0];
	КонецЕсли;
	Запись.ИдентификаторСообщения = ИдентификаторСообщения84;
	Запись.ГоловнаяОрганизация    = ЗарплатаКадры.ГоловнаяОрганизация(Страхователь);
	Запись.Страхователь           = Страхователь;
	Запись.ЕстьОшибкиФЛК          = Истина;
	Запись.ТекстОшибкиФЛК         = ТекстОшибки;
	ЗаполнитьСостояниеРегистрации(Запись);
	
	ЗавершитьЗаписьНабора(Набор);
КонецПроцедуры

// Загружает сообщение СЭДО 85, которое является ответом Фонда на сообщение 84.
Процедура ЗагрузитьСообщение85(Страхователь, ИдентификаторСообщения85, ТекстXML, Результат, Кэш) Экспорт
	// Пример:
	// Структура ответа на получение статусы выплаты.
	//<paymentStatusResponse responseOn="05f895d0-0152-439d-9cda-2fe679aeb3af" xmlns="http://www.fss.ru/integration/types/pvso/paymentstate/v01">
	//    <paymentStatusList>
	//        <paymentStatusDetail>
	//            <batchNo>P_7713000050_2022_05_20_141_0:1</batchNo>
	//            <socialAssistNum>141</socialAssistNum>
	//            <SNILS>10845144037</SNILS>
	//            <paymentState>1</paymentState>
	//        </paymentStatusDetail>
	//    </paymentStatusList>
	//</paymentStatusResponse>
	
	СтруктураDOM = СериализацияБЗК.СтруктураDOM(ТекстXML);
	КореньDOM = СериализацияБЗК.НайтиУзелDOMПоИмени(СтруктураDOM, "paymentStatusResponse");
	Если КореньDOM = Неопределено Тогда
		КореньDOM = СтруктураDOM.ДокументDOM;
	КонецЕсли;
	Если КореньDOM = Неопределено Тогда
		СЭДОФСС.ЗаписатьОшибкуПоискаУзла(Результат, "paymentStatusResponse");
		Возврат;
	КонецЕсли;
	
	АтрибутыКорня = СериализацияБЗК.АтрибутыЭлементаDOM(КореньDOM, "responseOn");
	ИдентификаторСообщения84 = АтрибутыКорня.responseOn;
	Если ИдентификаторСообщения84 = Неопределено Тогда
		СЭДОФСС.ЗаписатьОшибкуПоискаАтрибута(Результат, "responseOn");
		Возврат;
	ИначеЕсли Не ЗначениеЗаполнено(ИдентификаторСообщения84) Тогда
		СЭДОФСС.ЗаписатьОшибкуЗаполненностиАтрибута(Результат, "responseOn");
		Возврат;
	КонецЕсли;
	
	РеквизитыКорня = СериализацияБЗК.УзлыЭлементаDOM(КореньDOM, "paymentStatusList, errorList");
	ТаблицаСведенийОВыплатах = ТаблицаСведенийОВыплатахXML(РеквизитыКорня.paymentStatusList);
	РегистрацияТекстОшибки = ПредставлениеСпискаОшибокXML(РеквизитыКорня.errorList);
	
	Набор = НачатьЗаписьНабора(ИдентификаторСообщения84);
	Попытка
		Если Набор.Количество() = 0 Тогда
			ИсходящееСообщение = СЭДОФСС.ИсходящееСообщение(ИдентификаторСообщения84);
			Запись = Набор.Добавить();
			Запись.ИдентификаторСообщения      = ИдентификаторСообщения84;
			Запись.ДоставкаУспех               = Истина; // По факту наличия сообщения 85.
			Запись.ДоставкаДата                = ИсходящееСообщение.Дата;
			Запись.ДоставкаИдентификаторПакета = ИсходящееСообщение.ИдентификаторПакетаФСС;
			Запись.ИсходящийДокумент           = Документы.ЗапросСтатусовВыплатыПособия.НайтиПоРеквизиту("ИдентификаторСообщения",
				ИдентификаторСообщения84);
		Иначе
			Запись = Набор[0];
		КонецЕсли;
		Если Не ЗначениеЗаполнено(Запись.Страхователь) Тогда
			Запись.Страхователь = Страхователь;
		КонецЕсли;
		Если Не ЗначениеЗаполнено(Запись.ГоловнаяОрганизация) Тогда
			Запись.ГоловнаяОрганизация = ЗарплатаКадры.ГоловнаяОрганизация(Страхователь);
		КонецЕсли;
		Запись.РегистрацияУспех         = ПустаяСтрока(РегистрацияТекстОшибки);
		Запись.РегистрацияДата          = СЭДОФСС.ДатаСообщения(ИдентификаторСообщения85, Кэш);
		Запись.РегистрацияТекстОшибки   = РегистрацияТекстОшибки;
		Запись.РегистрацияИдентификатор = ИдентификаторСообщения85;
		ЗаполнитьСостояниеРегистрации(Запись);
		
		Если ТаблицаСведенийОВыплатах.Количество() > 0 Или Не ЗначениеЗаполнено(РегистрацияТекстОшибки) Тогда
			ДокументОбъект = Документы.СтатусыВыплатыПособия.СоздатьПоСообщению85(Запись, ТаблицаСведенийОВыплатах);
			Запись.РегистрацияСсылка = ДокументОбъект.Ссылка;
		КонецЕсли;
		
		ЗавершитьЗаписьНабора(Набор);
	Исключение
		ОтменитьЗаписьНабора(Набор);
		ВызватьИсключение;
	КонецПопытки;
	
	Результат.Обработано = Истина;
КонецПроцедуры

Функция ПредставлениеСпискаОшибокXML(СписокОшибокDOM) Экспорт
	// Для сообщения 321 ожидаемые поля: code,message,details.
	Если СписокОшибокDOM = Неопределено Тогда
		Возврат "";
	КонецЕсли;
	МассивСтрок = Новый Массив;
	Для Каждого ОшибкаDOM Из СписокОшибокDOM.ДочерниеУзлы Цикл
		Если ОшибкаDOM.ТипУзла <> ТипУзлаDOM.Элемент Тогда
			Продолжить;
		КонецЕсли;
		УзлыОшибки = СериализацияБЗК.УзлыЭлементаDOMСКонтролем(ОшибкаDOM, "errorCode, errorDescription");
		Код       = СериализацияБЗК.СтрокаИзXML(УзлыОшибки.errorCode);
		Сообщение = СериализацияБЗК.СтрокаИзXML(УзлыОшибки.errorDescription);
		// Все данные будут записываться в переменную Сообщение.
		Если ЗначениеЗаполнено(Сообщение) Тогда
			Массив = СтрРазделить(Сообщение, Символы.ПС + Символы.ВК, Ложь);
			Сообщение = СтрСоединить(Массив, Символы.ПС + "  ");
		КонецЕсли;
		Если ЗначениеЗаполнено(Код) Тогда
			Сообщение = СокрП(Код + ": " + Сообщение);
		КонецЕсли;
		Если УзлыОшибки.ПредставленияНеобработанныхУзловDOM.Количество() > 0 Тогда
			Необработанные = СтрСоединить(УзлыОшибки.ПредставленияНеобработанныхУзловDOM, Символы.ПС);
			Необработанные = НСтр("ru = 'Необработанные узлы сообщения:';
									|en = 'Unprocessed message nodes:'") + Символы.ПС + Необработанные;
			Сообщение = ?(ЗначениеЗаполнено(Сообщение), Сообщение + Символы.ПС + "    " + Необработанные, Необработанные);
		КонецЕсли;
		Если ЗначениеЗаполнено(Сообщение) Тогда
			МассивСтрок.Добавить(Сообщение);
		КонецЕсли;
	КонецЦикла;
	
	Возврат СтрСоединить(МассивСтрок, Символы.ПС);
КонецФункции

Функция ТаблицаСведенийОВыплатахXML(paymentStatusList) Экспорт
	МетаданныеТаблицы = Метаданные.Документы.СтатусыВыплатыПособия.ТабличныеЧасти.СведенияОВыплатах;
	ТаблицаСведенийОВыплатах = КоллекцииБЗК.ТаблицаЗначенийПоМетаданным(МетаданныеТаблицы);
	РеквизитыВыплат = СериализацияБЗК.УзлыЭлементаDOM(paymentStatusList, "paymentStatusDetail");
	ВыплатыDOM = РеквизитыВыплат.paymentStatusDetail;
	Если ВыплатыDOM <> Неопределено Тогда
		Если ТипЗнч(ВыплатыDOM) <> Тип("Массив") Тогда
			ВыплатыDOM = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ВыплатыDOM);
		КонецЕсли;
		Для Каждого ВыплатаDOM Из ВыплатыDOM Цикл
			Реквизиты = СериализацияБЗК.УзлыЭлементаDOM(ВыплатаDOM);
			СтрокаТаблицы = ТаблицаСведенийОВыплатах.Добавить();
			Если Реквизиты.Свойство("batchNo") Тогда
				ИдентификаторСтрокиРеестра = СериализацияБЗК.СтрокаИзXML(Реквизиты.batchNo);
				СтрокаТаблицы.ИдентификаторСтрокиРеестра = ИдентификаторСтрокиРеестра;
				СтрокаТаблицы.ИдентификаторРеестра = СтроковыеФункцииБЗККлиентСервер.СтрЛев(ИдентификаторСтрокиРеестра, ":");
			КонецЕсли;
			Если Реквизиты.Свойство("socialAssistNum") Тогда
				СтрокаТаблицы.НомерПроцесса = СериализацияБЗК.ЧислоИзXML(Реквизиты.socialAssistNum);
			КонецЕсли;
			Если Реквизиты.Свойство("SNILS") Тогда
				СтрокаТаблицы.СотрудникСНИЛС = СЭДОФСС.СНИЛСИзXML(Реквизиты.SNILS);
			КонецЕсли;
			Если Реквизиты.Свойство("LNCode") Тогда
				СтрокаТаблицы.НомерЛН = СериализацияБЗК.СтрокаИзXML(Реквизиты.LNCode);
			КонецЕсли;
			Если Реквизиты.Свойство("stateDate") Тогда
				СтрокаТаблицы.Дата = СериализацияБЗК.СтрокаИзXML(Реквизиты.stateDate);
			КонецЕсли;
			Если Реквизиты.Свойство("paymentSum") Тогда
				СтрокаТаблицы.Сумма = СериализацияБЗК.ЧислоИзXML(Реквизиты.paymentSum);
			КонецЕсли;
			Если Реквизиты.Свойство("paymentState") Тогда
				СтрокаТаблицы.СтатусВыплаты = СериализацияБЗК.ЧислоИзXML(Реквизиты.paymentState);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	Возврат ТаблицаСведенийОВыплатах;
КонецФункции

Функция ВозможныеСтатусы() Экспорт
	Результат = Новый ТаблицаЗначений;
	Результат.Колонки.Добавить("Статус");
	Результат.Колонки.Добавить("Зарегистрирован");
	Результат.Колонки.Добавить("Расшифровка");
	Результат.Колонки.Добавить("Состояние");
	
	// Статусы из актуальной спецификации.
	СтрокаТаблицы = Результат.Добавить();
	СтрокаТаблицы.Статус          = "0";
	СтрокаТаблицы.Зарегистрирован = Ложь;
	СтрокаТаблицы.Расшифровка     = НСтр("ru = 'Не принят Фондом';
										|en = 'Not accepted by the Fund'");
	СтрокаТаблицы.Состояние       = Перечисления.СостоянияДокументаСЭДОФСС.НеПринят;
	
	СтрокаТаблицы = Результат.Добавить();
	СтрокаТаблицы.Статус          = "1";
	СтрокаТаблицы.Зарегистрирован = Ложь;
	СтрокаТаблицы.Расшифровка     = НСтр("ru = 'Принят';
										|en = 'Accepted'");
	СтрокаТаблицы.Состояние       = Перечисления.СостоянияДокументаСЭДОФСС.Принят;
	
	СтрокаТаблицы = Результат.Добавить();
	СтрокаТаблицы.Статус          = "2";
	СтрокаТаблицы.Зарегистрирован = Истина;
	СтрокаТаблицы.Расшифровка     = НСтр("ru = 'Произошла техническая ошибка. Необходимо повторно отправить документ позже';
										|en = 'A technical error occurred. Resend the document later'");
	СтрокаТаблицы.Состояние       = Перечисления.СостоянияДокументаСЭДОФСС.НеПринят;
	
	Возврат Результат;
КонецФункции

Процедура ЗаполнитьСостояниеРегистрации(Запись) Экспорт
	Запись.Состояние = СостояниеРегистрации(Запись);
КонецПроцедуры

Функция СостояниеРегистрации(Запись)
	
	Если Не ЗначениеЗаполнено(Запись.ДоставкаДата) И Не ЗначениеЗаполнено(Запись.ДатаОтправкиОператору) Тогда
		// Не отправлен.
		Возврат Перечисления.СостоянияДокументаСЭДОФСС.ПустаяСсылка();
		
	ИначеЕсли ЗначениеЗаполнено(Запись.ДоставкаТекстОшибки) Тогда
		// Ошибка при отправке.
		Возврат Перечисления.СостоянияДокументаСЭДОФСС.ОшибкаПриОтправке;
		
	ИначеЕсли Запись.ЕстьОшибкиФЛК Тогда
		// Отправлен, получены ошибки.
		Возврат Перечисления.СостоянияДокументаСЭДОФСС.ОшибкаЛогическогоКонтроля;
		
	ИначеЕсли ЗначениеЗаполнено(Запись.РегистрацияТекстОшибки) Тогда
		// Отправлен, получены ошибки.
		Возврат Перечисления.СостоянияДокументаСЭДОФСС.НеПринят;
		
	ИначеЕсли ЗначениеЗаполнено(Запись.РегистрацияДата) Тогда
		// Успешная доставка и регистрация без ошибок.
		Возврат Перечисления.СостоянияДокументаСЭДОФСС.Принят;
		
	ИначеЕсли Запись.ОтправленОператору И Не Запись.ДоставкаУспех Тогда
		// Передан оператору для доставки.
		Возврат Перечисления.СостоянияДокументаСЭДОФСС.ОтправленОператору;
		
	Иначе
		// Отправлен - заполнена дата отправка, нет информации о статусе.
		Возврат Перечисления.СостоянияДокументаСЭДОФСС.Отправлен;
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#Область УведомлениеОСтатусеВыплатыПособия

Процедура ПередУдалениемДокументаЗапросСтатусовВыплатыПособия(ЗапросСсылка) Экспорт
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Шапка.ИдентификаторСообщения КАК ИдентификаторСообщения
	|ИЗ
	|	РегистрСведений.РегистрацииЗапросовСтатусовВыплатыПособий КАК Шапка
	|ГДЕ
	|	Шапка.ИсходящийДокумент = &ИсходящийДокумент";
	Запрос.УстановитьПараметр("ИсходящийДокумент", ЗапросСсылка);
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Набор = НачатьЗаписьНабора(Выборка.ИдентификаторСообщения);
		Если Набор = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		Набор.Очистить();
		ЗавершитьЗаписьНабора(Набор);
	КонецЦикла;
КонецПроцедуры

Процедура ПередУдалениемДокументаСтатусыВыплатыПособия(СтатусыВыплатыСсылка) Экспорт
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Шапка.ИдентификаторСообщения КАК ИдентификаторСообщения
	|ИЗ
	|	РегистрСведений.РегистрацииЗапросовСтатусовВыплатыПособий КАК Шапка
	|ГДЕ
	|	Шапка.РегистрацияСсылка = &РегистрацияСсылка";
	Запрос.УстановитьПараметр("РегистрацияСсылка", СтатусыВыплатыСсылка);
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Набор = НачатьЗаписьНабора(Выборка.ИдентификаторСообщения);
		Если Набор = Неопределено Или Набор.Количество() = 0 Тогда
			ОтменитьЗаписьНабора(Набор);
			Продолжить;
		КонецЕсли;
		Запись = Набор[0];
		Если Не ЗначениеЗаполнено(Запись.ИсходящийДокумент) Тогда
			Набор.Очистить();
		Иначе
			Запись.РегистрацияСсылка = Неопределено;
		КонецЕсли;
		ЗавершитьЗаписьНабора(Набор);
	КонецЦикла;
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли