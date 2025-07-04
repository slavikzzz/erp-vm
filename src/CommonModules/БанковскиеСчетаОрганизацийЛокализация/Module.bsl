
#Область ПрограммныйИнтерфейс

#Область ОбработчикиСобытий

// Вызывается из соответствующего обработчика документа
//
// Параметры:
//  Объект - ДокументОбъект - Обрабатываемый объект.
//  ДанныеЗаполнения - Произвольный - Значение, которое используется как основание для заполнения.
//  СтандартнаяОбработка - Булево - В данный параметр передается признак выполнения стандартной (системной) обработки события.
//
Процедура ОбработкаЗаполнения(Объект, ДанныеЗаполнения, СтандартнаяОбработка) Экспорт
	
	//++ Локализация
	Если Не ПолучитьФункциональнуюОпцию("ПоддержкаПлатежейРФ") Тогда
		Возврат;
	КонецЕсли;
	
	Если ДанныеЗаполнения = Неопределено Тогда
		ДанныеЗаполнения = Новый Структура;
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьОбменСБанками") Тогда
		ДанныеЗаполнения.Вставить("ИспользоватьПрямойОбменСБанком", Истина);
		ДанныеЗаполнения.Вставить("ИспользоватьОбменСБанком", Ложь);
	КонецЕсли;
	//-- Локализация
	
	Возврат;
	
КонецПроцедуры

// Вызывается из соответствующего обработчика документа
//
// Параметры:
//  Объект - СправочникОбъект.БанковскиеСчетаОрганизаций - Обрабатываемый объект
//  Отказ - Булево - Если в теле процедуры-обработчика установить данному параметру значение Истина,
//                   то будет выполнен отказ от продолжения работы после выполнения проверки заполнения.
//  ПроверяемыеРеквизиты - Массив из Строка - Массив путей к реквизитам, для которых будет выполнена проверка заполнения.
//
Процедура ОбработкаПроверкиЗаполнения(Объект, Отказ, ПроверяемыеРеквизиты) Экспорт
	
	//++ Локализация
	ТекстОшибки = "";
	Если Не Объект.ЭтоГруппа
		И Не Объект.ИностранныйБанк
		И Объект.ТипСчета <> Перечисления.ТипыБанковскихСчетов.Прочий
		И Не ДенежныеСредстваКлиентСерверЛокализация.ПроверитьКорректностьНомераСчета(Объект.НомерСчета,, ТекстОшибки) Тогда
		ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, Объект, "НомерСчета",, Отказ);
	КонецЕсли;
	
	НепроверяемыеРеквизиты = Новый Массив;
	
	Дополнительно = Новый Структура;
	//++ НЕ УТ
	Дополнительно.Вставить("ПоддержкаПлатежей275ФЗ", ПолучитьФункциональнуюОпцию("ПоддержкаБанковскогоИКазначейскогоСопровожденияГосконтрактов"));
	//-- НЕ УТ
	
	НастройкиПолей = ДенежныеСредстваСервер.ИнициализироватьНастройкиПолейФормы();
	НастройкиПолейФормы(НастройкиПолей);
	СвойстваЭлементов = ДенежныеСредстваКлиентСервер.СвойстваЭлементовФормы(Объект, НастройкиПолей,,, Дополнительно);
	ДенежныеСредстваСервер.ОтключитьПроверкуЗаполненияРеквизитовОбъекта(СвойстваЭлементов, НепроверяемыеРеквизиты);
	
	//++ НЕ УТ
	Если ЗначениеЗаполнено(Объект.НаправлениеДеятельности) Тогда
		
		ОшибкаТипаНаправленияДеятельности = Ложь;
		ПроверяемоеЗначение = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.НаправлениеДеятельности, "ТипНаправленияДеятельности");
		
		Если Объект.СчетПоГосконтракту Тогда
			ОшибкаТипаНаправленияДеятельности =
				Не (ПроверяемоеЗначение = Перечисления.ТипыНаправленийДеятельности.ГосударственныйКонтракт
				ИЛИ ПроверяемоеЗначение = Перечисления.ТипыНаправленийДеятельности.КонтрактГОЗ);
		ИначеЕсли Не Объект.СчетПоГосконтракту
				И Не Объект.ОтдельныйСчетГОЗ Тогда
			ОшибкаТипаНаправленияДеятельности = ПроверяемоеЗначение <> Перечисления.ТипыНаправленийДеятельности.ИнаяДеятельность;
		КонецЕсли;
			
		Если ОшибкаТипаНаправленияДеятельности Тогда
			
			ТекстСообщения = НСтр("ru = 'Тип направления деятельности не соответствует установленным настройкам счета.';
									|en = 'Line of business type does not match the configured account settings.'");
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, Объект, "НаправлениеДеятельности", , Отказ);
			
		КонецЕсли;
		
	КонецЕсли;
	//-- НЕ УТ
	
	Если Объект.ТипСчета = Перечисления.ТипыБанковскихСчетов.Казначейский Тогда
		ДенежныеСредстваСерверЛокализация.ПроверитьЛицевойСчетКазначейскогоСопровождения(Объект);
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, НепроверяемыеРеквизиты);
	//-- Локализация
	
	Возврат;
	
КонецПроцедуры

// Вызывается из соответствующего обработчика документа
//
// Параметры:
//  Объект - ДокументОбъект - Обрабатываемый объект
//  Отказ - Булево - Признак отказа от записи.
//                   Если в теле процедуры-обработчика установить данному параметру значение Истина,
//                   то запись выполнена не будет и будет вызвано исключение.
//
Процедура ПередЗаписью(Объект, Отказ) Экспорт
	
	//++ Локализация
	ЭтоКазначейскийСчет = Объект.ТипСчета = Перечисления.ТипыБанковскихСчетов.Казначейский;
		
	Если Не ЭтоКазначейскийСчет Тогда
		Объект.СчетПоГосконтракту = ЭтоКазначейскийСчет;
		Объект.РазделЛицевогоСчета = "";
		Объект.НомерЛицевогоСчета = "";
	КонецЕсли;
	
	Объект.РазделЛицевогоСчета = ?(Объект.СчетПоГосконтракту, Объект.РазделЛицевогоСчета, "");
	Объект.НомерЛицевогоСчета = ?(ЭтоКазначейскийСчет, Объект.НомерЛицевогоСчета, "");
	//-- Локализация
	
КонецПроцедуры

// Вызывается из соответствующего обработчика документа
//
// Параметры:
//  Объект - ДокументОбъект - Обрабатываемый объект
//  Отказ - Булево - Признак отказа от записи.
//                   Если в теле процедуры-обработчика установить данному параметру значение Истина, то запись выполнена не будет и будет вызвано исключение.
//
Процедура ПриЗаписи(Объект, Отказ) Экспорт
	
	
КонецПроцедуры

// Вызывается из соответствующего обработчика документа
//
// Параметры:
//  Объект - СправочникОбъект - Обрабатываемый объект
//  ОбъектКопирования - СправочникОбъект - Исходный справочник, который является источником копирования.
//
Процедура ПриКопировании(Объект, ОбъектКопирования) Экспорт
	
	Если Объект.СчетПоГосконтракту Тогда
		Объект.НаправлениеДеятельности = Справочники.НаправленияДеятельности.ПустаяСсылка();
		Объект.РазделЛицевогоСчета = "";
	КонецЕсли;
	
	Объект.СчетПоГосконтракту = Ложь;
	
КонецПроцедуры

#КонецОбласти

#Область ПодключаемыеКоманды

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - см. УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	//++ Локализация

	//++ НЕ УТ
	НовКоманда = КомандыПечати.Добавить();
	НовКоманда.Идентификатор = "ПФ_MXL_ЗаявлениеЛицевогоСчета_ru";
	НовКоманда.Представление = Нстр("ru = 'Заявление на резервирование/открытие (закрытие) л/с';
									|en = 'Application to reserve/open (terminate) a personal account'");
	НовКоманда.ЗаголовокФормы = Нстр("ru = 'Печать заявления на резервирование/открытие (закрытие) лицевого счета';
									|en = 'Print an application to reserve/open (terminate) a personal account'");
	НовКоманда.Обработчик = "ДенежныеСредстваКлиентЛокализация.ВыбратьВариантЗаявления";
	НовКоманда.ФункциональныеОпции = "ПоддержкаБанковскогоИКазначейскогоСопровожденияГосконтрактов";
	ПодключаемыеКоманды.ДобавитьУсловиеВидимостиКоманды(НовКоманда, "СчетПоГосконтракту", Истина);
	//-- НЕ УТ

	//-- Локализация
	Возврат;
	
КонецПроцедуры

#КонецОбласти

#Область Печать

// Формирует печатные формы.
//
// Параметры:
//  МассивОбъектов  - Массив из СправочникСсылка.БанковскиеСчетаОрганизаций - ссылки на объекты, которые нужно распечатать;
//  ПараметрыПечати - Структура - дополнительные настройки печати;
//  КоллекцияПечатныхФорм - ТаблицаЗначений - сформированные табличные документы (выходной параметр)
//  ОбъектыПечати         - СписокЗначений из СправочникСсылка.БанковскиеСчетаОрганизаций - значение - ссылка на объект;
//                                            представление - имя области в которой был выведен объект (выходной параметр);
//  ПараметрыВывода       - Структура       - дополнительные параметры сформированных табличных документов (выходной параметр).
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт

	//++ Локализация

	//++ НЕ УТ
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПФ_MXL_ЗаявлениеЛицевогоСчета_ru") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм,
			"ПФ_MXL_ЗаявлениеЛицевогоСчета_ru",
			НСтр("ru = 'Заявление на резервирование/открытие (закрытие) лицевого счета';
				|en = 'Application to reserve/open (terminate) a personal account'"),
			ПечатьЗаявления(МассивОбъектов, ОбъектыПечати, ПараметрыПечати.ВариантЗаявления),
			,
			"Справочник.БанковскиеСчетаОрганизаций.ПФ_MXL_ЗаявлениеЛицевогоСчета_ru");
	КонецЕсли;
	//-- НЕ УТ

	//-- Локализация

КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции
//++ Локализация

// Определяет свойства полей формы в зависимости от данных
// 
// Параметры:
//  Настройки - см. ДенежныеСредстваСервер.ИнициализироватьНастройкиПолейФормы.
// 
Процедура НастройкиПолейФормы(Настройки) Экспорт
	
	Финансы = ФинансоваяОтчетностьСервер;

	Элемент = Настройки.Добавить();
	Элемент.Поля.Добавить("ГосударственныйКонтракт");
	Финансы.НовыйОтбор(Элемент.Условие, "ОтдельныйСчетГОЗ", Истина);
	Финансы.НовыйОтбор(Элемент.Условие, "ИностранныйБанк", Ложь);
	Элемент.Свойства.Вставить("Доступность");
	Элемент.Свойства.Вставить("АвтоОтметкаНезаполненного");
	
	Элемент = Настройки.Добавить();
	Элемент.Поля.Добавить("ГруппаГосударственныеКонтракты");
	Финансы.НовыйОтбор(Элемент.Условие, "ИностранныйБанк", Ложь);
	Элемент.Свойства.Вставить("Видимость");
	
	Элемент = Настройки.Добавить();
	Элемент.Поля.Добавить("ОтдельныйСчетГОЗ");
	Элемент.Поля.Добавить("ГосударственныйКонтракт");
	ГруппаИЛИ = Финансы.НовыйОтбор(Элемент.Условие, , , Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаИЛИ.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;
	Финансы.НовыйОтбор(ГруппаИЛИ, "ТипСчета", Перечисления.ТипыБанковскихСчетов.Транзитный);
	Финансы.НовыйОтбор(ГруппаИЛИ, "ТипСчета", Перечисления.ТипыБанковскихСчетов.Казначейский);
	Элемент.Свойства.Вставить("Видимость", Ложь);
	
	Элемент = Настройки.Добавить();
	Элемент.Поля.Добавить("ЗаголовокТранзитныйСчет");
	Элемент.Поля.Добавить("ВвестиТранзитныйСчет");
	Финансы.НовыйОтбор(Элемент.Условие, "Дополнительно.ТранзитныйСчетЗадан", Ложь);
	Финансы.НовыйОтбор(Элемент.Условие, "ТипСчета", Перечисления.ТипыБанковскихСчетов.Расчетный);
	Финансы.НовыйОтбор(Элемент.Условие, "ИностранныйБанк", Ложь);
	Финансы.НовыйОтбор(Элемент.Условие, "Дополнительно.ВалютныйСчет", Истина);
	Финансы.НовыйОтбор(Элемент.Условие, "Дополнительно.ИспользоватьВалютныеПлатежи", Истина);
	Элемент.Свойства.Вставить("Видимость");
	
	Элемент = Настройки.Добавить();
	Элемент.Поля.Добавить("ТранзитныйСчет");
	Финансы.НовыйОтбор(Элемент.Условие, "Дополнительно.ТранзитныйСчетЗадан", Истина);
	Финансы.НовыйОтбор(Элемент.Условие, "ТипСчета", Перечисления.ТипыБанковскихСчетов.Расчетный);
	Финансы.НовыйОтбор(Элемент.Условие, "ИностранныйБанк", Ложь);
	Финансы.НовыйОтбор(Элемент.Условие, "Дополнительно.ВалютныйСчет", Истина);
	Финансы.НовыйОтбор(Элемент.Условие, "Дополнительно.ИспользоватьВалютныеПлатежи", Истина);
	Элемент.Свойства.Вставить("Видимость");
	
	Элемент = Настройки.Добавить();
	Элемент.Поля.Добавить("НомерЛицевогоСчета");
	Элемент.Поля.Добавить("СчетПоГосконтракту");
	Элемент.Поля.Добавить("НаправлениеДеятельностиКазначейскогоСчета");
	Финансы.НовыйОтбор(Элемент.Условие, "ТипСчета", Перечисления.ТипыБанковскихСчетов.Казначейский);
	Элемент.Свойства.Вставить("Видимость");
	
	Элемент = Настройки.Добавить();
	Элемент.Поля.Добавить("ЭтоIBAN");
	Элемент.Поля.Добавить("НаправлениеДеятельности");
	Элемент.Поля.Добавить("ФорматОбмена");
	Финансы.НовыйОтбор(Элемент.Условие, "ТипСчета", Перечисления.ТипыБанковскихСчетов.Казначейский);
	Элемент.Свойства.Вставить("Видимость", Ложь);
	
	Элемент = Настройки.Добавить();
	Элемент.Поля.Добавить("РазделЛицевогоСчета");
	Финансы.НовыйОтбор(Элемент.Условие, "ТипСчета", Перечисления.ТипыБанковскихСчетов.Казначейский);
	Финансы.НовыйОтбор(Элемент.Условие, "СчетПоГосконтракту", Истина);
	Элемент.Свойства.Вставить("Видимость");
	
	// Печать платежных поручений
	Элемент = Настройки.Добавить();
	Элемент.Поля.Добавить("ТекстКорреспондента");
	Финансы.НовыйОтбор(Элемент.Условие, "Дополнительно.ИспользоватьТекстКорреспондента", Истина);
	Элемент.Свойства.Вставить("Доступность");
	
	Элемент = Настройки.Добавить();
	Элемент.Поля.Добавить("ВариантВыводаМесяца");
	Финансы.НовыйОтбор(Элемент.Условие, "ИностранныйБанк", Ложь);
	Финансы.НовыйОтбор(Элемент.Условие, "Дополнительно.ВалютныйСчет", Ложь);
	Элемент.Свойства.Вставить("Видимость");
	
	Элемент = Настройки.Добавить();
	Элемент.Поля.Добавить("ВыводитьСуммуБезКопеек");
	Финансы.НовыйОтбор(Элемент.Условие, "Дополнительно.ВалютныйСчет", Ложь);
	Элемент.Свойства.Вставить("Видимость");
	
	// Обмен с банком
	Элемент = Настройки.Добавить();
	Элемент.Поля.Добавить("РежимОбменаКлиентБанка");
	Финансы.НовыйОтбор(Элемент.Условие, "ОбменСБанкомВключен", Истина);
	Элемент.Свойства.Вставить("Доступность");
	
	Элемент = Настройки.Добавить();
	Элемент.Поля.Добавить("РежимОбменаПрямойОбмен");
	Финансы.НовыйОтбор(Элемент.Условие, "ОбменСБанкомВключен", Истина);
	Финансы.НовыйОтбор(Элемент.Условие, "РучноеИзменениеРеквизитовБанка", Ложь);
	Элемент.Свойства.Вставить("Доступность");
	
	Элемент = Настройки.Добавить();
	Элемент.Поля.Добавить("ДекорацияПояснениеИспользованиеПрямогоОбменаДаннымиСБанком");
	Элемент.Поля.Добавить("ДекорацияОтступИспользованиеПрямогоОбменаДаннымиСБанком");
	Финансы.НовыйОтбор(Элемент.Условие, "Дополнительно.ДиректБанкНастроен", Ложь);
	Элемент.Свойства.Вставить("Видимость");
	
	Элемент = Настройки.Добавить();
	Элемент.Поля.Добавить("ДекорацияСоглашениеЭД");
	Элемент.Поля.Добавить("ДекорацияДобавитьСоглашениеЭД");
	Элемент.Поля.Добавить("ДекорацияНетПравСоглашениеЭД");
	Финансы.НовыйОтбор(Элемент.Условие, "ОбменСБанкомВключен", Истина);
	Финансы.НовыйОтбор(Элемент.Условие, "ИспользоватьПрямойОбменСБанком", Истина);
	Элемент.Свойства.Вставить("Доступность");
	
	Элемент = Настройки.Добавить();
	Элемент.Поля.Добавить("БИКБанка");
	Финансы.НовыйОтбор(Элемент.Условие, "СтранаБанка", Справочники.СтраныМира.Россия);
	Элемент.Свойства.Вставить("Заголовок", НСтр("ru = 'БИК';
												|en = 'BIC'"));
	
КонецПроцедуры

//++ НЕ УТ

Функция ПечатьЗаявления(МассивОбъектов, ОбъектыПечати, ВариантЗаявления)

	Макет = УправлениеПечатью.МакетПечатнойФормы(
		"Справочник.БанковскиеСчетаОрганизаций.ПФ_MXL_ЗаявлениеЛицевогоСчета_ru");
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "ПараметрыПечати_ЗаявлениеЛицевогоСчета";
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	БанковскиеСчетаОрганизаций.Ссылка КАК Ссылка,
		|	Организации.Ссылка КАК Организация,
		|	Организации.НаименованиеПолное КАК ОрганизацияНаименование,
		|	ЕСТЬNULL(КлассификаторБанков.Наименование, """") КАК ТОФКНаименование,
		|	БанковскиеСчетаОрганизаций.НомерСчета КАК НомерСчета,
		|	ЕСТЬNULL(ГосударственныеКонтракты.НомерИГК, """") КАК ИдентификаторГосконтракта,
		|	БанковскиеСчетаОрганизаций.НомерЛицевогоСчета КАК ЛицевойСчет,
		|	ЕСТЬNULL(НаправленияДеятельности.НомерКонтракта, """") КАК НомерКонтракта,
		|	ЕСТЬNULL(НаправленияДеятельности.ДатаЗаключенияКонтракта, """") КАК ДатаКонтракта,
		|	ЕСТЬNULL(ГосударственныеКонтракты.Контрагент.НаименованиеПолное, """") КАК НаименованиеЗаказчика,
		|	ЕСТЬNULL(ГосударственныеКонтракты.Контрагент.ИНН, """") КАК ИННЗаказчика
		|ИЗ
		|	Справочник.БанковскиеСчетаОрганизаций КАК БанковскиеСчетаОрганизаций
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Организации КАК Организации
		|		ПО БанковскиеСчетаОрганизаций.Владелец = Организации.Ссылка
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КлассификаторБанков КАК КлассификаторБанков
		|		ПО БанковскиеСчетаОрганизаций.Банк = КлассификаторБанков.Ссылка
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.НаправленияДеятельности КАК НаправленияДеятельности
		|		ПО БанковскиеСчетаОрганизаций.НаправлениеДеятельности = НаправленияДеятельности.Ссылка
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ГосударственныеКонтракты КАК ГосударственныеКонтракты
		|		ПО НаправленияДеятельности.ГосударственныйКонтракт = ГосударственныеКонтракты.Ссылка
		|ГДЕ
		|	БанковскиеСчетаОрганизаций.Ссылка В(&Ссылка)";
	
	Запрос.УстановитьПараметр("Ссылка", МассивОбъектов);
	
	РезультатЗапроса = Запрос.Выполнить().Выбрать();
	
	Пока РезультатЗапроса.Следующий() Цикл
		
		Если ТабличныйДокумент.ВысотаТаблицы > 0 Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		ОсновныеПоказателиОрганизации = "НаименованиеПолное,АдресОрганизацииПолный,ИНН,КПП,АдресЭлектроннойПочтыОрганизации,РуководительФИО,БухгалтерФИО,УполномоченныйПредставительФИО,РуководительДолжность";
		СведенияОбОрганизации = ОрганизацииСервер.СведенияОбОрганизации(РезультатЗапроса.Организация, ОсновныеПоказателиОрганизации);
		
		ОтветственныеЛица = ОтветственныеЛицаСервер.ПолучитьОтветственныеЛицаОрганизации(РезультатЗапроса.Организация);
		
		ПараметрыНаПечать = Новый Структура;
		ПараметрыНаПечать.Вставить("Дата", Формат(ТекущаяДатаСеанса(), НСтр("ru = 'ДФ=dd.MM.yyyy';
																			|en = 'DF=MM/dd/yyyy'")));
		ПараметрыНаПечать.Вставить("ДатаЗаголовок", Формат(ТекущаяДатаСеанса(), НСтр("ru = 'ДФ=''«dd» MMMM yyyy''';
																					|en = 'DF=''MMMM dd yyyy'''")));
		ПараметрыНаПечать.Вставить("ОрганизацияНаименование", СведенияОбОрганизации.НаименованиеПолное);
		ПараметрыНаПечать.Вставить("АдресОрганизации", СведенияОбОрганизации.АдресОрганизацииПолный);
		ПараметрыНаПечать.Вставить("ИНН", СведенияОбОрганизации.ИНН);
		ПараметрыНаПечать.Вставить("КПП", СведенияОбОрганизации.КПП);
		ПараметрыНаПечать.Вставить("EmailОрганизации", СведенияОбОрганизации.АдресЭлектроннойПочтыОрганизации);
		ПараметрыНаПечать.Вставить("ТОФКНаименование", РезультатЗапроса.ТОФКНаименование);
		ПараметрыНаПечать.Вставить("ВариантЗаявления", НРег(ВариантЗаявления));
		ПараметрыНаПечать.Вставить("НаименованиеЗаказчика", РезультатЗапроса.НаименованиеЗаказчика);
		ПараметрыНаПечать.Вставить("ИННЗаказчика", РезультатЗапроса.ИННЗаказчика);
		
		Если ВариантЗаявления = "Открытие" Тогда
			
			ПараметрыНаПечать.Вставить("Открытие", Истина);
			ПараметрыНаПечать.Вставить("НомерСчетаОткрытие", РезультатЗапроса.ЛицевойСчет);
			ПараметрыНаПечать.Вставить("НаименованиеОснования", НСтр("ru = 'Государственный контракт';
																	|en = 'State contract'"));
			ПараметрыНаПечать.Вставить("НомерКонтракта", РезультатЗапроса.НомерКонтракта);
			ПараметрыНаПечать.Вставить("ДатаКонтракта", РезультатЗапроса.ДатаКонтракта);
			ПараметрыНаПечать.Вставить("ИдентификаторГосконтракта", РезультатЗапроса.ИдентификаторГосконтракта);
			
		ИначеЕсли ВариантЗаявления = "Закрытие" Тогда
			
			ПараметрыНаПечать.Вставить("Закрытие", Истина);
			ПараметрыНаПечать.Вставить("НомерСчетаЗакрытие", РезультатЗапроса.ЛицевойСчет);
			ПараметрыНаПечать.Вставить("НаименованиеЗаказчика", "");
			ПараметрыНаПечать.Вставить("ИННЗаказчика", "");
			
		Иначе
			ПараметрыНаПечать.Вставить("Резервирование", ВариантЗаявления = "Резервирование");
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ОтветственныеЛица.Руководитель) Тогда
			РуководительОрганизации = ФизическиеЛицаУТ.ФамилияИнициалыФизЛица(ОтветственныеЛица.Руководитель);
			РуководительДолжность = ОтветственныеЛица.РуководительДолжность;
		Иначе
			РуководительОрганизации = ФизическиеЛицаУТ.ФамилияИнициалыФизЛица(ОтветственныеЛица.УполномоченныйПредставитель);
			РуководительДолжность = ОтветственныеЛица.УполномоченныйПредставительДолжность;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ОтветственныеЛица.ГлавныйБухгалтер) Тогда
			ГлавныйБухгалтерОрганизации = ФизическиеЛицаУТ.ФамилияИнициалыФизЛица(ОтветственныеЛица.ГлавныйБухгалтер);
			ГлавныйБухгалтерДолжность = ОтветственныеЛица.ГлавныйБухгалтерДолжность;
		Иначе
			ГлавныйБухгалтерОрганизации = ФизическиеЛицаУТ.ФамилияИнициалыФизЛица(ОтветственныеЛица.УполномоченныйПредставитель);
			ГлавныйБухгалтерДолжность = ОтветственныеЛица.УполномоченныйПредставительДолжность;
		КонецЕсли;
		
		ПараметрыНаПечать.Вставить("РуководительОрганизации", РуководительОрганизации);
		ПараметрыНаПечать.Вставить("ГлавныйБухгалтерОрганизации", ГлавныйБухгалтерОрганизации);
		ПараметрыНаПечать.Вставить("РуководительДолжность", РуководительДолжность);
		ПараметрыНаПечать.Вставить("ГлавныйБухгалтерДолжность", ГлавныйБухгалтерДолжность);
		
		ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок");
		ТабличныйДокумент.Вывести(ОбластьЗаголовок);
		
		МассивОбластей = Новый Массив;
		МассивОбластей.Добавить("Шапка");
		МассивОбластей.Добавить("ДанныеЗаявления");
		МассивОбластей.Добавить("Подвал");
		
		Для каждого ТекущаяОбласть Из МассивОбластей Цикл
		
			ОбластьМакета = Макет.ПолучитьОбласть(ТекущаяОбласть);
			ОбластьМакета.Параметры.Заполнить(ПараметрыНаПечать);
			ТабличныйДокумент.Вывести(ОбластьМакета);
		
		КонецЦикла;
		
		ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		
		ОбластьОборот = Макет.ПолучитьОбласть("Оборот");
		ТабличныйДокумент.Вывести(ОбластьОборот);
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, РезультатЗапроса.Ссылка);
		
	КонецЦикла;
	
	Возврат ТабличныйДокумент;

КонецФункции

//-- НЕ УТ

//-- Локализация

#КонецОбласти
