#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Версия формата выгрузки.
//
// Параметры:
//  НаДату - Дата
//  ВыбраннаяФорма - Строка
//
// Возвращаемое значение:
//   ПеречислениеСсылка.ВерсииФорматовВыгрузки
//
Функция ВерсияФорматаВыгрузки(Знач НаДату = Неопределено, ВыбраннаяФорма = Неопределено) Экспорт
	
	Возврат Перечисления.ВерсииФорматовВыгрузки.Версия500;
	
КонецФункции

// Возвращает таблицу форм отчета с реквизитами и периодами действия.
//
// Возвращаемое значение:
//   ТаблицаЗначений - Таблица форм отчета:
//     * ФормаОтчета - Строка
//     * ОписаниеОтчета - Строка
//     * ДатаНачалоДействия - Дата
//     * ДатаКонецДействия - Дата
//     * РедакцияФормы - Строка
//
Функция ТаблицаФормОтчета() Экспорт
	
	Неограниченный = '0001-01-01';
	
	ОписаниеТиповСтрока = Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(254));
	
	МассивТипов = Новый Массив;
	МассивТипов.Добавить(Тип("Дата"));
	ОписаниеТиповДата = Новый ОписаниеТипов(МассивТипов, , Новый КвалификаторыДаты(ЧастиДаты.Дата));
	
	ТаблицаФормОтчета = Новый ТаблицаЗначений;
	ТаблицаФормОтчета.Колонки.Добавить("ФормаОтчета",        ОписаниеТиповСтрока);
	ТаблицаФормОтчета.Колонки.Добавить("ОписаниеОтчета",     ОписаниеТиповСтрока, "Утверждена",  20);
	ТаблицаФормОтчета.Колонки.Добавить("ДатаНачалоДействия", ОписаниеТиповДата,   "Действует с", 5);
	ТаблицаФормОтчета.Колонки.Добавить("ДатаКонецДействия",  ОписаниеТиповДата,   "         по", 5);
	ТаблицаФормОтчета.Колонки.Добавить("РедакцияФормы",      ОписаниеТиповСтрока, "Редакция формы", 20);
	
	ФормаОтчета = ТаблицаФормОтчета.Добавить();
	ФормаОтчета.ФормаОтчета        = "ФормаОтчета2017Кв3";
	ФормаОтчета.ОписаниеОтчета     = "Финансовая отчетность в Банки";
	ФормаОтчета.РедакцияФормы      = "от 05.10.2011 № 124н.";
	ФормаОтчета.ДатаНачалоДействия = '2011-12-01';
	ФормаОтчета.ДатаКонецДействия  = Неограниченный;
	
	ФормаОтчета = ТаблицаФормОтчета.Добавить();
	ФормаОтчета.ФормаОтчета        = "ФормаОтчета2011Кв4";
	ФормаОтчета.ОписаниеОтчета     = "Утверждена приказом Минфина России от 02.07.2010 г. №66н, в ред. приказа Минфина России от 05.10.2011 № 124н.";
	ФормаОтчета.РедакцияФормы      = "от 05.10.2011 № 124н.";
	ФормаОтчета.ДатаНачалоДействия = '2011-12-01';
	ФормаОтчета.ДатаКонецДействия  = Неограниченный;
	
	Возврат ТаблицаФормОтчета;
	
КонецФункции

// Возвращает сведения об отдельных показателях регламентированного отчета.
//
// Параметры:
//   ЭкземплярРеглОтчета - ДокументСсылка.РегламентированныйОтчет
//
// Возвращаемое значение:
//   Неопределено - получение сведений из отчета не предусмотрено
//
Функция ДанныеРеглОтчета(ЭкземплярРеглОтчета) Экспорт
	
	Возврат Неопределено;
	
КонецФункции

// Возвращает дерево форм и форматов регламентированного отчета.
//
// Возвращаемое значение:
//  ДеревоЗначений:
//    * Код - Строка
//    * ДатаПриказа - Дата
//    * НомерПриказа - Строка
//    * ДатаНачалаДействия - Дата
//    * ДатаОкончанияДействия - Дата
//    * ИмяОбъекта - Строка
//    * Описание - Строка
//
Функция ДеревоФормИФорматов() Экспорт
	
	ФормыИФорматы = РегламентированнаяОтчетность.НовоеДеревоФормИФорматов();
	
	ДобавитьФормуИФорматыФормаОтчета2011Кв4(ФормыИФорматы);
	
	Возврат ФормыИФорматы;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ДобавитьФормуИФорматыФормаОтчета2011Кв4(ФормыИФорматы)
	
	ФормаОтчета = ФормыИФорматы.Строки.Добавить();
	ФормаОтчета.Код = "710099";
	ФормаОтчета.ДатаПриказа = '2015-04-06';
	ФормаОтчета.НомерПриказа = "57н-Сбербанк";
	ФормаОтчета.ИмяОбъекта = "ФормаОтчета2011Кв4";
	
	ФорматФормы = ФормаОтчета.Строки.Добавить();
	ФорматФормы.Код = "5.06";
	ФорматФормы.ДатаНачалаДействия    = ФормаОтчета.ДатаНачалаДействия;
	ФорматФормы.ДатаОкончанияДействия = ФормаОтчета.ДатаОкончанияДействия;
	
КонецПроцедуры

// Возвращает адрес информационного файла внешней компоненты банка.
// 
// Параметры:
//   Банк - СправочникСсылка.Банки
//   ПараметрыКлиента - Произвольный
// 
// Возвращаемое значение:
//   Строка
//
Функция АдресИнформационногоФайлаВнешнейКомпонентыБанка(Банк, ПараметрыКлиента) Экспорт
	
	ВремФайл = ПолучитьИмяВременногоФайла();
	ЗаписьJSON = Новый ЗаписьJSON;
	ЗаписьJSON.ОткрытьФайл(ВремФайл);
	ЗаписьJSON.ЗаписатьНачалоОбъекта();
	ЗаписьJSON.ЗаписатьИмяСвойства("bic");
	ЗаписьJSON.ЗаписатьЗначение(ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Банк, "Код"));
	
	ОтчетностьВБанкиСлужебный.ДобавитьДополнительныеПараметры(ЗаписьJSON, ПараметрыКлиента);
	
	ЗаписьJSON.ЗаписатьКонецОбъекта();
	ЗаписьJSON.Закрыть();
	
	Данные = Новый ДвоичныеДанные(ВремФайл);
	
	Попытка
		УдалитьФайлы(ВремФайл);
	Исключение
		ВидОперации = НСтр("ru = 'Удаление временного файла.';
							|en = 'Удаление временного файла.'");
		ПодробноеПредставлениеОшибки = ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ОтчетностьВБанкиСлужебныйВызовСервера.ОбработатьОшибку(ВидОперации, ПодробноеПредставлениеОшибки);
	КонецПопытки;
	
	Заголовки = Новый Соответствие;
	Заголовки.Вставить("Content-Type", "application/json");
	
	Результат = ОтчетностьВБанкиСлужебный.ОтправитьЗапросНаСервер(
		"https://reportbank.1c.ru", "/api/rest/bank/getSettings/", Заголовки, Данные, Истина, 15);
	
	ТекстСообщения = "";
	ТекстОшибки = "";
	
	Если Результат.Статус Тогда
		ДанныеОтвета = ОтчетностьВБанкиСлужебный.ДанныеИзСтрокиJSON(Результат.Тело);
		Если НЕ ДанныеОтвета = Неопределено Тогда
			Возврат ДанныеОтвета.settings.info_xml_uri;
		КонецЕсли;
		
	Иначе
		Если ЗначениеЗаполнено(Результат.Тело) Тогда
			ДанныеОтвета = ОтчетностьВБанкиСлужебный.ДанныеИзСтрокиJSON(Результат.Тело);
			Если НЕ ДанныеОтвета = Неопределено Тогда
				Если ДанныеОтвета.Свойство("errorText") Тогда
					ТекстСообщения = ДанныеОтвета.errorText;
				Иначе
					ТекстСообщения = НСтр("ru = 'Получена неизвестная ошибка с сервиса https://reportbank.1c.ru.';
											|en = 'Получена неизвестная ошибка с сервиса https://reportbank.1c.ru.'");
				КонецЕсли;
			КонецЕсли;
			ТекстОшибки = НСтр("ru = 'Ошибка получения данных с сервиса https://reportbank.1c.ru.
				|Код состояния: %1
				|%2';
				|en = 'Ошибка получения данных с сервиса https://reportbank.1c.ru.
				|Код состояния: %1
				|%2'");
			ТекстОшибки = СтрШаблон(ТекстОшибки, Результат.КодСостояния, Результат.Тело);
		Иначе
			ТекстСообщения = Результат.СообщениеОбОшибке;
			ТекстОшибки = НСтр("ru = 'Ошибка получения данных с сервиса https://reportbank.1c.ru.
				|Код состояния: %1';
				|en = 'Ошибка получения данных с сервиса https://reportbank.1c.ru.
				|Код состояния: %1'");
		КонецЕсли;
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ТекстОшибки) ИЛИ ЗначениеЗаполнено(ТекстСообщения) Тогда
		ВидОперации = НСтр("ru = 'Получения адреса внешней компоненты в сервисе https://reportbank.1c.ru.';
							|en = 'Получения адреса внешней компоненты в сервисе https://reportbank.1c.ru.'");
		ОтчетностьВБанкиСлужебныйВызовСервера.ОбработатьОшибку(ВидОперации, ТекстОшибки);
		ВызватьИсключение ТекстСообщения;
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#КонецЕсли
