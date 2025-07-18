////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Механизм расчета статусов оформления документов САТУРН.
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Для добавления нового документа-основания к документу САТУРН надо
//   - добавить ссылочный тип документа в определяемый тип с именем Основание<ИмяДокументаСАТУРН>
//   - добавить ссылочный тип документа в определяемый тип с именем ОснованиеСтатусыОформленияДокументовСАТУРН
//   - добавить объектный тип документа в определяемый тип с именем ОснованиеСтатусыОформленияДокументовСАТУРНОбъект
//
//   - дополнить процедуры общего модуля РасчетСтатусовОформленияСАТУРНПереопределяемый
//     - ПриОпределенииИменРеквизитовДокументаДляРасчетаСтатусаОформленияДокументаСАТУРН()
//     - ПриОпределенииТекстаЗапросаДляРасчетаСтатусаОформленияДокументаСАТУРН()
//
// Для подключения документа САТУРН к этому механизму нужно:
//   - добавить его ссылочный тип в определяемый тип ДокументыСАТУРНПоддерживающиеСтатусыОформления
//   - добавить его объектный тип в определяемый тип ДокументыСАТУРНПоддерживающиеСтатусыОформленияОбъект
//   - добавить его объектный тип в определяемый тип ОснованиеСтатусыОформленияДокументовСАТУРНОбъект
//
//   - добавить в документ реквизит с именем ДокументОснование
//   - создать определяемый тип с именем Основание<ИмяДокументаСАТУРН>
//     - заполнить этот тип ссылочными типами документов-оснований
//
//   - добавить типы из определяемого типа Основание<ИмяДокументаСАТУРН> в ОснованиеСтатусыОформленияДокументовСАТУРН
//   - добавить соответствующие ссылочным объектные типы из определяемого типа Основание<ИмяДокументаСАТУРН>
//      в ОснованиеСтатусыОформленияДокументовСАТУРНОбъект
//
//   - дополнить процедуры общего модуля РасчетСтатусовОформленияСАТУРНПереопределяемый
//     - ПриОпределенииИменРеквизитовДокументаДляРасчетаСтатусаОформленияДокументаСАТУРН()
//     - ПриОпределенииТекстаЗапросаДляРасчетаСтатусаОформленияДокументаСАТУРН()
//
#Область ПрограммныйИнтерфейс

#Область ОбработчикиПодписокНаСобытияСАТУРН

// Обработчик подписки на событие "Перед записью" документов САТУРН, поддерживающих статусы оформления.
// 
// Параметры:
//   Источник        - ОпределяемыйТип.ДокументыСАТУРНПоддерживающиеСтатусыОформленияОбъект - записываемый объект
//   Отказ           - Булево - параметр, определяющий будет ли записываться объект
//   РежимЗаписи     - РежимЗаписиДокумента     - не используется
//   РежимПроведения - РежимПроведенияДокумента - не используется
//
Процедура РассчитатьСтатусОформленияСАТУРНПередЗаписьюДокументаОбработчик(Источник, Отказ, РежимЗаписи, РежимПроведения) Экспорт
	
	РасчетСтатусовОформленияИС.ПередЗаписьюДокумента("ВестиУчетПестицидовАгрохимикатовТукосмесейСАТУРН", Источник, Отказ);
	
КонецПроцедуры

// Обработчик подписки на событие "При записи" документов САТУРН, поддерживающих статусы оформления, и их документов-оснований.
//
// Параметры:
//   Источник - ОпределяемыйТип.ОснованиеСтатусыОформленияДокументовСАТУРНОбъект - записываемый объект.
//   Отказ    - Булево - параметр, определяющий будет ли записываться объект.
//
Процедура РассчитатьСтатусОформленияСАТУРНПриЗаписиДокументаОбработчик(Источник, Отказ) Экспорт
	
	РасчетСтатусовОформленияИС.ПриЗаписиДокумента("ВестиУчетПестицидовАгрохимикатовТукосмесейСАТУРН", Источник, Отказ, РасчетСтатусовОформленияСАТУРН);
	
	Если Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ПересчетСтатусов

// Рассчитывает статусы оформления документов и записывает их в регистр сведений СтатусыОформленияДокументовСАТУРН.
//   ВАЖНО: все элементы массива Источники должны иметь одинаковый тип.
//
// Параметры:
//   Источники - Массив из ОпределяемыйТип.ДокументыСАТУРНПоддерживающиеСтатусыОформления,
//                         ОпределяемыйТип.ОснованиеСтатусыОформленияДокументовСАТУРН - источники события.
//
Процедура РассчитатьСтатусыОформленияДокументов(Источники) Экспорт
	
	Если Не РасчетСтатусовОформленияИС.РассчитатьДляДокументов("ВестиУчетПестицидовАгрохимикатовТукосмесейСАТУРН", Источники, РасчетСтатусовОформленияСАТУРН) Тогда
		Возврат;
	КонецЕсли;
	
	РассчитатьСтатусыОформленияИмпортируемыхПартий(Источники);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйнтерфейс

#Область ФункцииОбщегоМеханизма

//Возвращает признак, что документ САТУРН поддерживает статусы оформления (по метаданным)
//
//Параметры:
//   Источник - Произвольный - проверяемый объект
//
//Возвращаемое значение:
//   Булево - это документ САТУРН поддерживающий статус оформления
//
Функция ЭтоДокументПоддерживающийСтатусОформления(Источник) Экспорт
	
	Возврат Метаданные.ОпределяемыеТипы.ДокументыСАТУРНПоддерживающиеСтатусыОформленияОбъект.Тип.СодержитТип(ТипЗнч(Источник))
		ИЛИ Метаданные.ОпределяемыеТипы.ДокументыСАТУРНПоддерживающиеСтатусыОформления.Тип.СодержитТип(ТипЗнч(Источник));
	
КонецФункции

//Возвращает признак, что проверяемый объект может являться основанием для документа САТУРН (по метаданным)
//
//Параметры:
//   Источник - Произвольный - проверяемый объект
//
//Возвращаемое значение:
//   Булево - это документ-основание для документа САТУРН.
//
Функция ЭтоДокументОснование(Источник) Экспорт
	
	Возврат ТипОснование().СодержитТип(ТипЗнч(Источник));
	
КонецФункции

//См. РасчетСтатусовОформленияИС.ИменаДокументовДляДокументаОснования.
//
//Возвращаемое значение:
//   Массив Из Строка - .
//
Функция ИменаДокументовДляДокументаОснования(ДокументОснование) Экспорт
	
	Если ТипЗнч(ДокументОснование) = Тип("СправочникСсылка.ИмпортируемаяПартияСАТУРН") Тогда
		Имена = Новый Массив;
		Имена.Добавить(Метаданные.Документы.ИмпортПродукцииСАТУРН.Имя);
	Иначе
		Имена = РасчетСтатусовОформленияИС.ИменаДокументовДляДокументаОснования(ДокументОснование, ТипДокумент());
	КонецЕсли;
	Возврат Имена;
	
КонецФункции

//Реквизиты регистра "Статусы оформления документов САТУРН"
//
//Возвращаемое значение:
//   Массив Из ОбъектМетаданных - реквизиты.
//
Функция МетаРеквизиты() Экспорт
	
	Возврат Метаданные.РегистрыСведений.СтатусыОформленияДокументовСАТУРН.Реквизиты;
	
КонецФункции

//Описание типов (документов) являющихся основаниями для оформления документов САТУРН.
//
//Возвращаемое значение:
//   ОписаниеТипов - тип основание.
//
Функция ТипОснование() Экспорт
	
	Возврат Метаданные.ОпределяемыеТипы.ОснованиеСтатусыОформленияДокументовСАТУРН.Тип;
	
КонецФункции

//Описание типов (документов) САТУРН поддерживающих статус оформления.
//
//Возвращаемое значение:
//   ОписаниеТипов - тип документы САТУРН.
//
Функция ТипДокумент() Экспорт
	
	Возврат Метаданные.ОпределяемыеТипы.ДокументыСАТУРНПоддерживающиеСтатусыОформления.Тип;
	
КонецФункции

#КонецОбласти

#Область Статусы

// Рассчитывает статус оформления документа и записывает его в регистр сведений СтатусыОформленияДокументовСАТУРН.
//
// Параметры:
//   Источник - ОпределяемыйТип.ДокументыСАТУРНПоддерживающиеСтатусыОформления, ОпределяемыйТип.ОснованиеСтатусыОформленияДокументовСАТУРН, ОпределяемыйТип.ОснованиеСтатусыОформленияДокументовСАТУРНОбъект - источник события расчета статуса.
//
Процедура РассчитатьСтатусОформленияДокумента(Источник) Экспорт
	
	Если Не РасчетСтатусовОформленияИС.РассчитатьДляДокумента("ВестиУчетПестицидовАгрохимикатовТукосмесейСАТУРН", Источник, РасчетСтатусовОформленияСАТУРН) Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

// Возвращает структуру с именами ключевых реквизитов документа-основания для документа САТУРН.
//   Значения этих реквизитов будут записаны в регистр сведений СтатусыОформленияДокументовСАТУРН.
//   Способ определения значения реквизита:
//     * Строка - имя реквизита документа-основания из которого следует взять значение (при обращении через
//     точку будет выполнено обращение к реквизиту первой строки одноименной ТЧ или к реквизиту реквизита основания);
//     * Произвольный - в т.ч. пустая строка - значение заполнения не зависящее от основания.
//
// Параметры:
//   МетаданныеОснования     - ОбъектМетаданных - метаданные документа-основания из ОпределяемыйТип.ОснованиеСтатусыОформленияДокументовСАТУРН
//   МетаданныеДокументаСАТУРН - ОбъектМетаданных - метаданные документа из ОпределяемыйТип.ДокументыСАТУРНПоддерживающиеСтатусыОформления
//
// Возвращаемое значение:
//   Структура - имена реквизитов (в качестве типа приведен тип соответствующего реквизита):
//     * Проведен      - Булево - документ-основание проведен.
//     * Дата          - Дата   - дата основания.
//     * Номер         - Строка - номер основания.
//     * Ответственный - ОпределяемыйТип.Пользователь - пользователь, оформивший документ-основание; значение по умолчанию "Ответственный".
//     * Контрагент    - ОпределяемыйТип.ОрганизацияКонтрагентГосИС - организация в документе-основании; значение по умолчанию "Организация".
//
Функция РеквизитыДляРасчета(МетаданныеОснования, МетаданныеДокументаСАТУРН) Экспорт

	Реквизиты = Новый Структура;

	// Стандартные реквизиты
	Реквизиты.Вставить("Проведен", "Проведен");
	Реквизиты.Вставить("Дата",     "Дата");
	Реквизиты.Вставить("Номер",    "Номер");
	// Переопределяемые реквизиты
	Реквизиты.Вставить("Ответственный", "Ответственный");
	Реквизиты.Вставить("Контрагент",    "Организация");
	//Дополнительно для Импортируемой партии
	Реквизиты.Вставить("ПометкаУдаления", "");
	Реквизиты.Вставить("Статус",          "");
	
	РасчетСтатусовОформленияСАТУРНПереопределяемый.ПриОпределенииИменРеквизитовДляРасчетаСтатусаОформления(МетаданныеОснования, МетаданныеДокументаСАТУРН, Реквизиты);
	
	Если МетаданныеОснования = Метаданные.Справочники.ИмпортируемаяПартияСАТУРН Тогда
		
		Реквизиты.Номер         = "Идентификатор";
		Реквизиты.Проведен      = "";
		Реквизиты.Дата          = "ДатаВвоза";
		Реквизиты.Контрагент    = "";
		Реквизиты.Ответственный = "";
		// Дополнительно
		Реквизиты.ПометкаУдаления = "ПометкаУдаления";
		Реквизиты.Статус          = "Статус";
		
	ИначеЕсли МетаданныеОснования = Метаданные.Документы.ПланПримененияСАТУРН Тогда
		
		Реквизиты.Контрагент                        = "";
		
	КонецЕсли;
	
	Возврат Реквизиты;
	
КонецФункции

//Позволяет определить текст и параметры запроса выборки данных из документов-основания для расчета статуса оформления. 
//
//Параметры:
//   МетаданныеОснования - ОбъектМетаданных - метаданные документа из ОпределяемыйТип.Основание<Имя документа САТУРН>.
//   МетаданныеДокументаСАТУРН - ОбъектМетаданных - метаданные документа из ОпределяемыйТип.ДокументыСАТУРНПоддерживающиеСтатусыОформления.
//   ТекстЗапроса - Строка - текст запроса выборки данных, который надо определить.
//   ПараметрыЗапроса - Структура - дополнительные параметры запроса, требуемые для выполнения запроса 
//       конкретного документа; при необходимости можно дополнить данную структуру.
//
Процедура ПриОпределенииЗапросаТоварыДокументаОснования(МетаданныеОснования, МетаданныеДокументаСАТУРН,
	ТекстЗапроса, ПараметрыЗапроса) Экспорт
	
	Если МетаданныеОснования = Метаданные.Справочники.ИмпортируемаяПартияСАТУРН Тогда
		
		ТекстЗапроса =
		"ВЫБРАТЬ
		|	ИмпортируемаяПартияСАТУРН.Ссылка             КАК Ссылка,
		|	ИСТИНА                                       КАК ЭтоДвижениеПриход,
		|	НЕОПРЕДЕЛЕНО                                 КАК Номенклатура,
		|	НЕОПРЕДЕЛЕНО                                 КАК Характеристика,
		|	НЕОПРЕДЕЛЕНО                                 КАК Серия,
		|	ИмпортируемаяПартияСАТУРН.КоличествоУпаковок КАК Количество
		|	
		|ПОМЕСТИТЬ %1
		|ИЗ
		|	Справочник.ИмпортируемаяПартияСАТУРН КАК ИмпортируемаяПартияСАТУРН
		|ГДЕ
		|	ИмпортируемаяПартияСАТУРН.Ссылка В (&МассивДокументов)
		|	И НЕ ИмпортируемаяПартияСАТУРН.ПометкаУдаления";
		
	КонецЕсли;
	РасчетСтатусовОформленияСАТУРНПереопределяемый.ПриОпределенииТекстаЗапросаДляРасчетаСтатусаОформления(
		МетаданныеОснования, МетаданныеДокументаСАТУРН, ТекстЗапроса, ПараметрыЗапроса);
	
КонецПроцедуры

// Определяет текущий статус оформления документов САТУРН.
//
//Параметры:
//   МассивДокументов        - Массив Из ОпределяемыйТип.ОснованиеСтатусыОформленияДокументовСАТУРН - документы-основание для документа САТУРН
//   МетаданныеДокументаСАТУРН - ОбъектМетаданных - метаданные документа из ОпределяемыйТип.ДокументыСАТУРНПоддерживающиеСтатусыОформления
//   МенеджерВТ              - МенеджерВременныхТаблиц - (см. СформироватьТаблицуТоварыДокументовОснования)
//
// Возвращаемое значение:
//   Соответствие - 
//     Ключ     - элемент параметра МассивДокументов
//     Значение - Структура с полями:
//       СтатусОформления         - статус оформления объекта,
//       ДополнительнаяИнформация - информация для отладки.
//
Функция ОпределитьСтатусыОформленияДокументов(МассивДокументов, МетаданныеДокументаСАТУРН, МенеджерВТ) Экспорт
	
	ДокументОснование = МассивДокументов[0];
	ТипОснования = ТипЗнч(ДокументОснование);
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВТ;
	Запрос.УстановитьПараметр("МассивДокументов", МассивДокументов);
	Запрос.УстановитьПараметр("ОтборСтрокОформленныеТовары", Истина);
	Запрос.УстановитьПараметр("ПустаяСерия", ИнтеграцияИС.НезаполненныеЗначенияОпределяемогоТипа("СерияНоменклатуры"));
	
	Если ТипОснования = Тип("СправочникСсылка.ИмпортируемаяПартияСАТУРН") Тогда
		
		ШаблонЗапросаВТОформленныеДокументы =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ТаблицаДокументы.Ссылка           КАК Ссылка,
		|	ТаблицаТовары.ИмпортируемаяПартия КАК ДокументОснование
		|ПОМЕСТИТЬ ОформленныеДокументы%1
		|ИЗ
		|	Документ.%1.Товары КАК ТаблицаТовары
		|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.%1 КАК ТаблицаДокументы
		|		ПО ТаблицаДокументы.Ссылка = ТаблицаТовары.Ссылка
		|	ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СтатусыДокументовСАТУРН КАК Статусы
		|		ПО Статусы.Документ = ТаблицаДокументы.Ссылка
		|ГДЕ
		|	ТаблицаТовары.ИмпортируемаяПартия В (&МассивДокументов)
		|	И ТаблицаДокументы.Проведен
		|	И НЕ Статусы.Статус В (&КонечныеСтатусы%1)
		|ИНДЕКСИРОВАТЬ ПО
		|	Ссылка";
		
	ИначеЕсли МетаданныеДокументаСАТУРН = Метаданные.Документы.АктИнвентаризацииСАТУРН
		Или МетаданныеДокументаСАТУРН = Метаданные.Документы.АктПримененияСАТУРН
		Или МетаданныеДокументаСАТУРН = Метаданные.Документы.ПроизводственнаяОперацияСАТУРН
		Или МетаданныеДокументаСАТУРН = Метаданные.Документы.ЗапросОстатковПартийСАТУРН
		Или МетаданныеДокументаСАТУРН = Метаданные.Документы.НакладнаяСАТУРН Тогда
		
		ШаблонЗапросаВТОформленныеДокументы =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ТаблицаДокументы.Ссылка КАК Ссылка,
		|	ТаблицаДокументы.ДокументОснование КАК ДокументОснование
		|ПОМЕСТИТЬ ОформленныеДокументы%1
		|ИЗ
		|	Документ.%1 КАК ТаблицаДокументы
		|	ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СтатусыДокументовСАТУРН КАК Статусы
		|		ПО Статусы.Документ = ТаблицаДокументы.Ссылка
		|		И Статусы.ИдентификаторСтроки = """"
		|ГДЕ
		|	ТаблицаДокументы.ДокументОснование В (&МассивДокументов)
		|	И ТаблицаДокументы.Проведен
		|	И НЕ Статусы.Статус В (&КонечныеСтатусы%1)
		|ИНДЕКСИРОВАТЬ ПО
		|	Ссылка";
		
	Иначе
		
		ШаблонЗапросаВТОформленныеДокументы =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ТаблицаДокументы.Ссылка КАК Ссылка,
		|	ТаблицаДокументы.ДокументОснование КАК ДокументОснование
		|ПОМЕСТИТЬ ОформленныеДокументы%1
		|ИЗ
		|	Документ.%1 КАК ТаблицаДокументы
		|	ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СтатусыДокументовСАТУРН КАК Статусы
		|		ПО Статусы.Документ = ТаблицаДокументы.Ссылка
		|		И Статусы.ИдентификаторСтроки = """"
		|ГДЕ
		|	ТаблицаДокументы.ДокументОснование В (&МассивДокументов)
		|	И ТаблицаДокументы.Проведен
		|	И НЕ Статусы.Статус В (&КонечныеСтатусы%1)
		|ИНДЕКСИРОВАТЬ ПО
		|	Ссылка
		|;
		|////////////////////////////////////////////////////////////////////////////////
		|
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ТаблицаДокументы.Ссылка КАК Ссылка,
		|	ТаблицаДокументы.ДокументОснование КАК ДокументОснование,
		|	Статусы.ИдентификаторСтроки КАК ИдентификаторСтроки
		|ПОМЕСТИТЬ ОформленныеДокументыКроме%1
		|ИЗ
		|	Документ.%1 КАК ТаблицаДокументы
		|	ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СтатусыДокументовСАТУРН КАК Статусы
		|		ПО Статусы.Документ = ТаблицаДокументы.Ссылка
		|		И Статусы.ИдентификаторСтроки <> """"
		|ГДЕ
		|	ТаблицаДокументы.ДокументОснование В (&МассивДокументов)
		|	И ТаблицаДокументы.Проведен
		|	И Статусы.Статус В (&КонечныеСтатусы%1)
		|ИНДЕКСИРОВАТЬ ПО
		|	Ссылка";
		
	КонецЕсли;
	
	Если МетаданныеДокументаСАТУРН = Метаданные.Документы.АктИнвентаризацииСАТУРН
		Или МетаданныеДокументаСАТУРН = Метаданные.Документы.АктПримененияСАТУРН
		Или МетаданныеДокументаСАТУРН = Метаданные.Документы.НакладнаяСАТУРН
		Или МетаданныеДокументаСАТУРН = Метаданные.Документы.ПроизводственнаяОперацияСАТУРН Тогда
			
		ШаблонЗапросаОформленныеТовары = "
		|
		|	ОБЪЕДИНИТЬ ВСЕ
		|
		|	ВЫБРАТЬ
		|		ОформленныеДокументы.ДокументОснование КАК ДокументОснование,
		|		%3 КАК ЭтоДвижениеПриход,
		|		ОформленныеТовары.Номенклатура   КАК Номенклатура,
		|		ОформленныеТовары.Характеристика КАК Характеристика,
		|		0                                КАК План,
		|		ОформленныеТовары.Количество     КАК Факт
		|	ИЗ
		|		Документ.%1.%2 КАК ОформленныеТовары
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ОформленныеДокументы%1 КАК ОформленныеДокументы
		|			ПО ОформленныеТовары.Ссылка = ОформленныеДокументы.Ссылка
		|";
			
	Иначе
		
		ШаблонЗапросаОформленныеТовары = "
		|
		|	ОБЪЕДИНИТЬ ВСЕ
		|
		|	ВЫБРАТЬ
		|		ОформленныеДокументы.ДокументОснование КАК ДокументОснование,
		|		%3 КАК ЭтоДвижениеПриход,
		|		ОформленныеТовары.Номенклатура   КАК Номенклатура,
		|		ОформленныеТовары.Характеристика КАК Характеристика,
		|		0                                КАК План,
		|		ОформленныеТовары.Количество     КАК Факт
		|	ИЗ
		|		Документ.%1.%2 КАК ОформленныеТовары
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ОформленныеДокументы%1 КАК ОформленныеДокументы
		|			ПО ОформленныеТовары.Ссылка = ОформленныеДокументы.Ссылка
		|		ЛЕВОЕ СОЕДИНЕНИЕ ОформленныеДокументыКроме%1 КАК ОформленныеДокументыКроме
		|			ПО ОформленныеТовары.Ссылка = ОформленныеДокументыКроме.Ссылка
		|			И ОформленныеТовары.Идентификатор = ОформленныеДокументыКроме.ИдентификаторСтроки
		|	ГДЕ
		|		ОформленныеДокументыКроме.ИдентификаторСтроки ЕСТЬ NULL
		|";
		
	КонецЕсли;
	
	ШаблонРазделительЗапросов = "
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|";
	
	ТекстЗапросаВТОформленныеДокументы = "";
	ТекстЗапросаОформленныеТовары = "";
	
	ИмяДокументаСАТУРН = МетаданныеДокументаСАТУРН.Имя;
	
	ЭтоДвижениеПриход = "ЛОЖЬ";
	Если МетаданныеДокументаСАТУРН = Метаданные.Документы.АктИнвентаризацииСАТУРН
		ИЛИ МетаданныеДокументаСАТУРН = Метаданные.Документы.ИмпортПродукцииСАТУРН
		ИЛИ МетаданныеДокументаСАТУРН = Метаданные.Документы.ПроизводственнаяОперацияСАТУРН Тогда
		ЭтоДвижениеПриход = "ИСТИНА";
	КонецЕсли;
	
	ТекстЗапросаВТОформленныеДокументы = СтрШаблон(ШаблонЗапросаВТОформленныеДокументы, ИмяДокументаСАТУРН) + ШаблонРазделительЗапросов;
	
	Если ТипОснования = Тип("СправочникСсылка.ИмпортируемаяПартияСАТУРН") Тогда
		
		ТекстЗапросаОформленныеТовары = ТекстЗапросаОформленныеТовары;
		
	Иначе
		
		ТекстЗапросаОформленныеТовары = СтрШаблон(ШаблонЗапросаОформленныеТовары, ИмяДокументаСАТУРН, "Товары", ЭтоДвижениеПриход);
	
	КонецЕсли;
	
	Запрос.УстановитьПараметр("КонечныеСтатусы" + ИмяДокументаСАТУРН, Документы[ИмяДокументаСАТУРН].КонечныеСтатусы());
	
	ЧастиЗапроса = Новый Массив;
	ЧастиЗапроса.Добавить(ТекстЗапросаВТОформленныеДокументы);
	
	ЧастиЗапроса.Добавить(СтрШаблон("
		|ВЫБРАТЬ
		|	ТоварыКОформлению.ДокументОснование КАК ДокументОснование,
		|	ТоварыКОформлению.ЭтоДвижениеПриход КАК ЭтоДвижениеПриход,
		|	ТоварыКОформлению.Номенклатура      КАК Номенклатура,
		|	ТоварыКОформлению.Характеристика    КАК Характеристика,
		|	СУММА(ТоварыКОформлению.План)       КАК План,
		|	СУММА(ТоварыКОформлению.Факт)       КАК Факт
		|ПОМЕСТИТЬ Результат
		|ИЗ
		|	(ВЫБРАТЬ
		|		Товары.Ссылка 			 КАК ДокументОснование,
		|		Товары.ЭтоДвижениеПриход КАК ЭтоДвижениеПриход,
		|		Товары.Номенклатура      КАК Номенклатура,
		|		Товары.Характеристика    КАК Характеристика,
		|		Товары.Количество        КАК План,
		|		0                        КАК Факт
		|	ИЗ
		|		%1 КАК Товары
		|", РасчетСтатусовОформленияИС.ИмяВременнойТаблицыДляВыборкиДанныхДокумента()));
	ЧастиЗапроса.Добавить(ТекстЗапросаОформленныеТовары);
	ЧастиЗапроса.Добавить("
		|	) КАК ТоварыКОформлению
		|СГРУППИРОВАТЬ ПО
		|	ТоварыКОформлению.ДокументОснование,
		|	ТоварыКОформлению.ЭтоДвижениеПриход,
		|	ТоварыКОформлению.Номенклатура,
		|	ТоварыКОформлению.Характеристика
		|");
	ЧастиЗапроса.Добавить(ШаблонРазделительЗапросов);
	ЧастиЗапроса.Добавить("
		|ВЫБРАТЬ
		|	Т.ДокументОснование КАК ДокументОснование,
		|	МАКСИМУМ(ВЫБОР КОГДА Т.Факт > 0 И Т.План > 0 	   ТОГДА ИСТИНА ИНАЧЕ ЛОЖЬ КОНЕЦ) КАК ЕстьОформленныеТовары,
		|	МАКСИМУМ(ВЫБОР КОГДА Т.Факт >= 0 И Т.План > Т.Факт ТОГДА ИСТИНА ИНАЧЕ ЛОЖЬ КОНЕЦ) КАК ЕстьНеОформленныеТовары,
		|	МАКСИМУМ(ВЫБОР КОГДА Т.План <= Т.Факт 			   ТОГДА ИСТИНА ИНАЧЕ ЛОЖЬ КОНЕЦ) КАК ЕстьПолностьюОформленныеТовары,
		|	МАКСИМУМ(ВЫБОР КОГДА Т.План < Т.Факт 			   ТОГДА ИСТИНА ИНАЧЕ ЛОЖЬ КОНЕЦ) КАК ЕстьОшибкиОформления
		|ПОМЕСТИТЬ РезультатПоДокументам
		|ИЗ
		|	Результат КАК Т
		|СГРУППИРОВАТЬ ПО
		|	Т.ДокументОснование");
	ЧастиЗапроса.Добавить(ШаблонРазделительЗапросов);
	ЧастиЗапроса.Добавить("
		|ВЫБРАТЬ
		|	Т.ДокументОснование КАК ДокументОснование,
		|	ВЫБОР
		|		КОГДА Т.ЕстьОшибкиОформления
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.СтатусыОформленияДокументовГосИС.ЕстьОшибкиОформления)
		|		КОГДА Т.ЕстьПолностьюОформленныеТовары И НЕ Т.ЕстьНеОформленныеТовары
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.СтатусыОформленияДокументовГосИС.Оформлено)
		|		КОГДА Т.ЕстьПолностьюОформленныеТовары И Т.ЕстьНеОформленныеТовары
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.СтатусыОформленияДокументовГосИС.ОформленоЧастично)
		|		КОГДА Т.ЕстьОформленныеТовары
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.СтатусыОформленияДокументовГосИС.ОформленоЧастично)
		|		ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.СтатусыОформленияДокументовГосИС.НеОформлено)
		|	КОНЕЦ КАК СтатусОформления
		|ИЗ
		|	РезультатПоДокументам КАК Т");
	
	Запрос.Текст = СтрСоединить(ЧастиЗапроса);
	
	// Получим данные и определим статус оформления документа САТУРН.
	
	СтатусОформления = Новый Структура(
		"СтатусОформления, ДополнительнаяИнформация",
		Перечисления.СтатусыОформленияДокументовГосИС.НеОформлено,
		Неопределено);
	
	Результат = ИнтеграцияИСКлиентСервер.МассивВСоответствие(МассивДокументов, СтатусОформления);
	
	УстановитьПривилегированныйРежим(Истина);
	Выборка   = Запрос.Выполнить().Выбрать();
	УстановитьПривилегированныйРежим(Ложь);
	
	Запрос.Текст = "ВЫБРАТЬ * ИЗ Результат КАК Т ГДЕ Т.ДокументОснование = &ДокументОснование";
	
	Пока Выборка.Следующий() Цикл
		
		Запрос.УстановитьПараметр("ДокументОснование", Выборка.ДокументОснование);
		
		// Сохраним данные, использовавшиеся для расчета статуса.
		УстановитьПривилегированныйРежим(Истина);
		ТаблицаДляРасчетаСтатуса = Запрос.Выполнить().Выгрузить();
		УстановитьПривилегированныйРежим(Ложь);
	
		ТаблицаДляРасчетаСтатуса.Колонки.ЭтоДвижениеПриход.Заголовок = НСтр("ru = 'Приходное движение';
																			|en = 'Приходное движение'");
		ТаблицаДляРасчетаСтатуса.Колонки.План.Заголовок              = НСтр("ru = 'По документу-основанию';
																			|en = 'По документу-основанию'");
		ТаблицаДляРасчетаСтатуса.Колонки.Факт.Заголовок              = НСтр("ru = 'По документу САТУРН';
																			|en = 'По документу САТУРН'");
		
		ДополнительнаяИнформация = Новый ХранилищеЗначения(ТаблицаДляРасчетаСтатуса, Новый СжатиеДанных(9));
		
		СтатусОформления = Новый Структура(
			"СтатусОформления, ДополнительнаяИнформация",
			Выборка.СтатусОформления,
			ДополнительнаяИнформация);
		
		Результат.Вставить(Выборка.ДокументОснование, СтатусОформления);
		
	КонецЦикла;
	
	Возврат Результат;

КонецФункции

//Служебная. Рассчитывает и записывает статусы оформления. Специфика САТУРН.
//
//Параметры:
//   ТаблицаРеквизитов - ТаблицаЗначений - собранные общим механизмом реквизиты для записи статуса
//
Процедура ЗаписатьДляОснований(ТаблицаРеквизитов) Экспорт

	// Запишем статус оформления документа САТУРН.
	РасчетСтатусовОформленияИС.ЗаписатьСтатусОформленияДокументов(
		ТаблицаРеквизитов,
		РегистрыСведений.СтатусыОформленияДокументовСАТУРН,
		РасчетСтатусовОформленияСАТУРН);

КонецПроцедуры

//Возвращает признак необходимости записи в регистр "Статусы оформления документов САТУРН"
//
//Параметры:
//   ДокументОснование  - ОпределяемыйТип.ОснованиеСтатусыОформленияДокументовСАТУРН - записываемый в регистр документ-основание.
//   Реквизиты - См. РеквизитыДляРасчета - влияющие на запись значения реквизитов основания.
//   КоличествоСтрокДокументовОснования - Соответствие - количество строк основания требующих оформления.
//   ДополнительныеПараметры - Неопределено - не используется в подсистеме
//
//Возвращаемое значение:
//   Булево - признак необходимости записи
//
Функция ТребуетсяОформление(ДокументОснование, Реквизиты, КоличествоСтрокДокументовОснования, ДополнительныеПараметры = Неопределено) Экспорт
	
	Если ТипЗнч(ДокументОснование) = Тип("СправочникСсылка.ИмпортируемаяПартияСАТУРН") Тогда
		
		Если Реквизиты.ПометкаУдаления
			ИЛИ Реквизиты.Статус <> Перечисления.СтатусыОбъектовСАТУРН.Черновик Тогда
			Возврат Ложь;
		КонецЕсли;
	Иначе
		Если НЕ Реквизиты.Проведен Тогда
			Возврат Ложь;
		КонецЕсли;
	КонецЕсли;
	
	Возврат ЗначениеЗаполнено(КоличествоСтрокДокументовОснования[ДокументОснование]);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

//Рассчитывает статусы Импортируемых партий, указанных в документе ИмпортПродукцииСАТУРН.
//   Специфика САТУРН.
//
//Параметры:
//   Источник - ДокументОбъект.ИмпортПродукцииСАТУРН, ДокументСсылка.ИмпортПродукцииСАТУРН, Массив из ДокументСсылка.ИмпортПродукцииСАТУРН - объект, содержащий данные об импортируемой партии.
//
Процедура РассчитатьСтатусыОформленияИмпортируемыхПартий(Источник)
	
	Если ТипЗнч(Источник) = Тип("ДокументОбъект.ИмпортПродукцииСАТУРН") Тогда
		
		ТаблицаИмпортируемыхПартий = Источник.Товары.Выгрузить(, "ИмпортируемаяПартия");
		ТаблицаИмпортируемыхПартий.Свернуть("ИмпортируемаяПартия", "");
		
		ПустыеИмпортируемыеПартии = ТаблицаИмпортируемыхПартий.НайтиСтроки(
			Новый Структура("ИмпортируемаяПартия", Справочники.ИмпортируемаяПартияСАТУРН.ПустаяСсылка()));
		
		Для Каждого СтрокаТаблицы Из ПустыеИмпортируемыеПартии Цикл
			ТаблицаИмпортируемыхПартий.Удалить(СтрокаТаблицы);
		КонецЦикла;
		
	Иначе
		
		Если ТипЗнч(Источник) = Тип("Массив") И ЗначениеЗаполнено(Источник) Тогда
			ИсточникСсылка = Источник[0];
		Иначе
			ИсточникСсылка = Источник;
		КонецЕсли;
		
		Если ТипЗнч(ИсточникСсылка) <> Тип("ДокументСсылка.ИмпортПродукцииСАТУРН") Тогда
			Возврат;
		КонецЕсли;
		
		Если ТипЗнч(Источник) = Тип("Массив") Тогда
			МассивДокументов = Источник;
		Иначе
			МассивДокументов = Новый Массив;
			МассивДокументов.Добавить(Источник);
		КонецЕсли;
		
		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	Товары.ИмпортируемаяПартия КАК ИмпортируемаяПартия
		|ИЗ
		|	Документ.ИмпортПродукцииСАТУРН.Товары КАК Товары
		|ГДЕ
		|	Товары.Ссылка В (&МассивДокументов)
		|	И Товары.ИмпортируемаяПартия <> ЗНАЧЕНИЕ(Справочник.ИмпортируемаяПартияСАТУРН.ПустаяСсылка)";
		
		Запрос.УстановитьПараметр("МассивДокументов", МассивДокументов);
		
		УстановитьПривилегированныйРежим(Истина);
		ТаблицаИмпортируемыеПартии = Запрос.Выполнить().Выгрузить();
		УстановитьПривилегированныйРежим(Ложь);
		
	КонецЕсли;
	
	РасчетСтатусовОформленияИС.РассчитатьОбщая(
		ТаблицаИмпортируемыеПартии.ВыгрузитьКолонку("ИмпортируемаяПартия"), Неопределено, РасчетСтатусовОформленияСАТУРН);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
