// Механизм расчета статусов оформления документов ВЕТИС.
// 
// Для добавления нового документа-основания к документу ВЕТИС надо
//	- добавить ссылочный тип документа в определяемый тип с именем Основание<ИмяДокументаВЕТИС>
//	- добавить ссылочный тип документа в определяемый тип с именем ОснованиеСтатусыОформленияДокументовВЕТИС
//	- добавить объектный тип документа в определяемый тип с именем ОснованиеСтатусыОформленияДокументовВЕТИСОбъект
//
//	- дополнить процедуры общего модуля РасчетСтатусовОформленияВЕТИСПереопределяемый
//		- ПриОпределенииИменРеквизитовДокументаДляРасчетаСтатусаОформленияДокументаВЕТИС()
//		- ПриОпределенииТекстаЗапросаДляРасчетаСтатусаОформленияДокументаВЕТИС()
//
// Для подключения документа ВЕТИС к этому механизму нужно:
//	- добавить его ссылочный тип в определяемый тип ДокументыВЕТИСПоддерживающиеСтатусыОформления
//	- добавить его объектный тип в определяемый тип ДокументыВЕТИСПоддерживающиеСтатусыОформленияОбъект
//	- добавить его объектный тип в определяемый тип ОснованиеСтатусыОформленияДокументовВЕТИСОбъект
//
//	- добавить в документ реквизит с именем ДокументОснования
//	- создать определяемый тип с именем Основание<ИмяДокументаВЕТИС>
//		- заполнить этот тип ссылочными типами документов-оснований
//
//	- добавить типы из определяемого типа Основание<ИмяДокументаВЕТИС> в ОснованиеСтатусыОформленияДокументовВЕТИС
//	- добавить соответствующие ссылочным объектные типы из определяемого типа Основание<ИмяДокументаВЕТИС>
//	   в ОснованиеСтатусыОформленияДокументовВЕТИСОбъект
//
//	- дополнить процедуры общего модуля РасчетСтатусовОформленияВЕТИСПереопределяемый
//		- ПриОпределенииИменРеквизитовДокументаДляРасчетаСтатусаОформленияДокументаВЕТИС()
//		- ПриОпределенииТекстаЗапросаДляРасчетаСтатусаОформленияДокументаВЕТИС()
//

#Область ПрограммныйИнтерфейс

#Область ОбработчикиПодписокНаСобытия

//Обработчик подписки на событие "Перед записью" документов ВЕТИС, поддерживающих статусы оформления.
//
//Параметры:
//   Источник        - ОпределяемыйТип.ДокументыВЕТИСПоддерживающиеСтатусыОформленияОбъект - записываемый объект
//   Отказ           - Булево - параметр, определяющий будет ли записываться объект
//   РежимЗаписи     - РежимЗаписиДокумента - режим записи документа
//   РежимПроведения - РежимПроведенияДокумента - режим проведения документа
//
Процедура РассчитатьСтатусОформленияВЕТИСПередЗаписьюДокументаОбработчик(Источник, Отказ, РежимЗаписи, РежимПроведения) Экспорт
	
	РасчетСтатусовОформленияИС.ПередЗаписьюДокумента("ВестиУчетПодконтрольныхТоваровВЕТИС", Источник, Отказ);
	
КонецПроцедуры

//Обработчик подписки на событие "При записи" документов ВЕТИС, поддерживающих статусы оформления, и их документов-оснований.
//
//Параметры:
//   Источник - ОпределяемыйТип.ОснованиеСтатусыОформленияДокументовВЕТИСОбъект - записываемый объект
//   Отказ    - Булево - параметр, определяющий будет ли записываться объект
//
Процедура РассчитатьСтатусОформленияВЕТИСПриЗаписиДокументаОбработчик(Источник, Отказ) Экспорт
	
	РасчетСтатусовОформленияИС.ПриЗаписиДокумента("ВестиУчетПодконтрольныхТоваровВЕТИС", Источник, Отказ, РасчетСтатусовОформленияВЕТИС);
	
КонецПроцедуры

#КонецОбласти

#Область ПересчетСтатусов

//Рассчитывает статусы оформления документов и записывает их в регистр сведений СтатусыОформленияДокументовВЕТИС.
//  ВАЖНО: все элементы массива Источники должны иметь одинаковый тип.
//
//Параметры:
//   Источники - ОпределяемыйТип.ДокументыВЕТИСПоддерживающиеСтатусыОформления,
//               ОпределяемыйТип.ОснованиеСтатусыОформленияДокументовВЕТИС,
//               Массив из ОпределяемыйТип.ДокументыВЕТИСПоддерживающиеСтатусыОформления,
//               Массив Из ОпределяемыйТип.ОснованиеСтатусыОформленияДокументовВЕТИС - источники событий.
//
Процедура РассчитатьСтатусыОформленияВЕТИС(Знач Источники) Экспорт
	
	Если Не РасчетСтатусовОформленияИС.РассчитатьДляДокументов("ВестиУчетПодконтрольныхТоваровВЕТИС", Источники, РасчетСтатусовОформленияВЕТИС) Тогда
		Возврат;
	КонецЕсли;
	
	РассчитатьСтатусыОформленияВСД(Источники);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

#Область ФункцииОбщегоМеханизма

//Возвращает признак, что документ ВетИС поддерживает статусы оформления (по метаданным)
//
//Параметры:
//   Источник - Произвольный - проверяемый объект
//
//Возвращаемое значение:
//   Булево - это документ ВетИС поддерживающий статус оформления
//
Функция ЭтоДокументПоддерживающийСтатусОформления(Источник) Экспорт
	
	Возврат Метаданные.ОпределяемыеТипы.ДокументыВЕТИСПоддерживающиеСтатусыОформленияОбъект.Тип.СодержитТип(ТипЗнч(Источник))
		ИЛИ Метаданные.ОпределяемыеТипы.ДокументыВЕТИСПоддерживающиеСтатусыОформления.Тип.СодержитТип(ТипЗнч(Источник));
	
КонецФункции

//Возвращает признак, что проверяемый объект может являться основанием для документа ВетИС (по метаданным)
//
//Параметры:
//   Источник - Произвольный - проверяемый объект
//
//Возвращаемое значение:
//   Булево - это документ-основание для документа ВетИС.
//
Функция ЭтоДокументОснование(Источник) Экспорт
	
	Возврат ТипОснование().СодержитТип(ТипЗнч(Источник));
	
КонецФункции

// См. РасчетСтатусовОформленияИС.ИменаДокументовДляДокументаОснования.
// 
// Параметры:
//  ДокументОснование - ДокументСсылка, СправочникСсылка - Документ основание
// 
// Возвращаемое значение:
//  Массив из Строка - имена метаданных доступных оснований.
Функция ИменаДокументовДляДокументаОснования(ДокументОснование) Экспорт
	
	Если ТипЗнч(ДокументОснование) = Тип("СправочникСсылка.ВетеринарноСопроводительныйДокументВЕТИС") Тогда
		Имена = Новый Массив;
		Имена.Добавить(Метаданные.Документы.ВходящаяТранспортнаяОперацияВЕТИС.Имя);
	Иначе
		Имена = РасчетСтатусовОформленияИС.ИменаДокументовДляДокументаОснования(ДокументОснование, ТипДокумент());
	КонецЕсли;
	
	ИндексВходящаяТТН  = Имена.Найти(Метаданные.Документы.ВходящаяТранспортнаяОперацияВЕТИС.Имя);
	ИндексИсходящаяТТН = Имена.Найти(Метаданные.Документы.ИсходящаяТранспортнаяОперацияВЕТИС.Имя);
	
	// Упорядочим входящую и исходящую операции по приоритету - сначала входящая, потом исходящая
	Если ИндексВходящаяТТН <> Неопределено И ИндексИсходящаяТТН <> Неопределено 
		И ИндексВходящаяТТН > ИндексИсходящаяТТН Тогда
		
		Имена.Удалить(ИндексИсходящаяТТН);
		Имена.Добавить(Метаданные.Документы.ИсходящаяТранспортнаяОперацияВЕТИС.Имя);
		
	КонецЕсли;
	
	Возврат Имена;
	
КонецФункции

//Реквизиты регистра "Статусы оформления документов ВетИС"
//
//Возвращаемое значение:
//   Массив Из ОбъектМетаданных - реквизиты.
//
Функция МетаРеквизиты() Экспорт
	
	Возврат Метаданные.РегистрыСведений.СтатусыОформленияДокументовВЕТИС.Реквизиты;
	
КонецФункции

//Описание типов (документов) являющихся основаниями для оформления документов ВетИС.
//
//Возвращаемое значение:
//   ОписаниеТипов - тип основание.
//
Функция ТипОснование() Экспорт
	
	Возврат Метаданные.ОпределяемыеТипы.ОснованиеСтатусыОформленияДокументовВЕТИС.Тип;
	
КонецФункции

//Описание типов (документов) ВетИС поддерживающих статус оформления.
//
//Возвращаемое значение:
//   ОписаниеТипов - тип документы ВетИС.
//
Функция ТипДокумент() Экспорт
	
	Возврат Метаданные.ОпределяемыеТипы.ДокументыВЕТИСПоддерживающиеСтатусыОформления.Тип;
	
КонецФункции

#КонецОбласти

#Область Статусы

//Возвращает структуру с именами ключевых реквизитов документа-основания для документа ВЕТИС.
//  Значения этих реквизитов будут записаны в регистр сведений СтатусыОформленияДокументовВЕТИС.
//
//Параметры:
//   МетаданныеОснования      - ОбъектМетаданныхДокумент - метаданные документа-основание из ОпределяемыйТип.ОснованиеСтатусыОформленияДокументовВЕТИС
//   МетаданныеДокументаВЕТИС - ОбъектМетаданныхДокумент - метаданные документа из ОпределяемыйТип.ДокументыВЕТИСПоддерживающиеСтатусыОформления
//
//Возвращаемое значение:
//   Структура - имена реквизитов влияющих на поля и запись статусов оформления.
//      Проведен, Дата, Номер - стандартные реквизиты документа-основания, переопределять их как правило не требуется,
//      Ответственный - пользователь, оформивший документ-основание,
//      Контрагент - организация, от имени которой оформлен документ-основание,
//      ТорговыйОбъект, ПроизводственныйОбъект - "место", в котором совершена операция документа-основание,
//      ПометкаУдаления,Статус - используются для когда основанием является ветеринарно-сопроводительный документ.
//   Если в качестве значения реквизита указана непустая строка - то это имя реквизита документа-основания,
//      из которого следует взять значение, иначе значение заполнения.
//   Полный состав полей:
//    * Проведен               - Строка.
//    * Дата                   - Строка.
//    * Номер                  - Строка.
//    * Ответственный          - Строка.
//    * Контрагент             - Строка.
//    * ТорговыйОбъект         - Строка.
//    * ПроизводственныйОбъект - Строка.
//    * ПометкаУдаления        - Строка.
//    * Статус                 - Строка.
//
Функция РеквизитыДляРасчета(МетаданныеОснования, МетаданныеДокументаВЕТИС) Экспорт
	
	Реквизиты = Новый Структура;
	
	// Стандартные реквизиты
	Реквизиты.Вставить("Проведен", "Проведен");
	Реквизиты.Вставить("Дата",     "Дата");
	Реквизиты.Вставить("Номер",    "Номер");
	// Переопределяемые реквизиты
	Реквизиты.Вставить("Ответственный", "Ответственный");
	Реквизиты.Вставить("Контрагент",    "Организация");
	Реквизиты.Вставить("ПометкаУдаления", "");
	Реквизиты.Вставить("Статус",          "");
	// Реквизит, который будет транслирован в один из двух реквизитов, в зависимости от типа его значения.
	Реквизиты.Вставить("ТорговыйИлиПроизводственныйОбъект", "Склад");
	
	РасчетСтатусовОформленияВЕТИСПереопределяемый.ПриОпределенииИменРеквизитовДокументаДляРасчетаСтатусаОформленияДокументаВЕТИС(
		МетаданныеОснования,
		МетаданныеДокументаВЕТИС,
		Реквизиты);
	
	// Запишем значение реквизита ТорговыйИлиПроизводственныйОбъект в два реквизита регистра статусов: ТорговыйОбъект и ПроизводственныйОбъект
	// При записи в регистр один из них (тот, который имеет неподходящий тип) будет приведен платформой к пустому значению.
	Реквизиты.Вставить("ТорговыйОбъект",         Реквизиты.ТорговыйИлиПроизводственныйОбъект);
	Реквизиты.Вставить("ПроизводственныйОбъект", Реквизиты.ТорговыйИлиПроизводственныйОбъект);
	
	Реквизиты.Удалить("ТорговыйИлиПроизводственныйОбъект");
	
	Если МетаданныеОснования = Метаданные.Справочники.ВетеринарноСопроводительныйДокументВЕТИС Тогда
		Реквизиты.ПометкаУдаления = "ПометкаУдаления";
		Реквизиты.Статус          = "Статус";
		Реквизиты.Номер           = "";
		Реквизиты.Проведен        = "";
		Реквизиты.Контрагент      = "";
		Реквизиты.ТорговыйОбъект  = "";
		Реквизиты.ПроизводственныйОбъект =  "";
		Реквизиты.Ответственный   = "";
	КонецЕсли;
		
	Возврат Реквизиты;
	
КонецФункции

//Рассчитывает статус оформления документа и записывает его в регистр сведений СтатусыОформленияДокументовВЕТИС.
//
//Параметры:
//   Источник - ОпределяемыйТип.ДокументыВЕТИСПоддерживающиеСтатусыОформления, ОпределяемыйТип.ОснованиеСтатусыОформленияДокументовВЕТИС, ОпределяемыйТип.ОснованиеСтатусыОформленияДокументовВЕТИСОбъект - источник необходимости расчета статуса.
//
Процедура РассчитатьСтатусОформленияДокумента(Источник) Экспорт
	
	Если Не РасчетСтатусовОформленияИС.РассчитатьДляДокумента("ВестиУчетПодконтрольныхТоваровВЕТИС", Источник, РасчетСтатусовОформленияВЕТИС) Тогда
		Возврат;
	КонецЕсли;
	
	РассчитатьСтатусыОформленияВСД(Источник);
	
КонецПроцедуры

//Служебная. Дорабатывает полученную таблицу реквизитов и записывает статусы оформления. Специфика ВетИС.
//
//Параметры:
//   ТаблицаРеквизитов - ТаблицаЗначений - собранные общим механизмом реквизиты для записи статуса
//
Процедура ЗаписатьДляОснований(ТаблицаРеквизитов) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТаблицаРеквизитов", ТаблицаРеквизитов.Скопировать(,"ДокументОснование,Документ,Контрагент,ТорговыйОбъект,ПроизводственныйОбъект"));
	Запрос.УстановитьПараметр("ПустойТорговыйОбъект", ИнтеграцияИС.НезаполненныеЗначенияОпределяемогоТипа("ТорговыйОбъектВЕТИС"));
	Запрос.УстановитьПараметр("ПустойПроизводственныйОбъект", ИнтеграцияИС.НезаполненныеЗначенияОпределяемогоТипа("ПроизводственныйОбъектИС"));
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Т.ДокументОснование,
	|	Т.Документ,
	|	Т.Контрагент,
	|	Т.ТорговыйОбъект,
	|	Т.ПроизводственныйОбъект
	|ПОМЕСТИТЬ ТаблицаКЗаписиСтатуса
	|ИЗ
	|	&ТаблицаРеквизитов КАК Т
	|;
	|
	|/////////////////////////////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Субъект.Ссылка КАК ХозяйствующийСубъект,
	|	СубъектПредприятия.Предприятие КАК Предприятие,
	|	Субъект.Контрагент КАК Контрагент,
	|	СубъектПредприятия.ТорговыйОбъект КАК ТорговыйОбъект,
	|	СубъектПредприятия.ПроизводственныйОбъект КАК ПроизводственныйОбъект
	|ПОМЕСТИТЬ ВТПредприятия
	|ИЗ
	|	Справочник.ХозяйствующиеСубъектыВЕТИС КАК Субъект
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ХозяйствующиеСубъектыВЕТИС.Предприятия КАК СубъектПредприятия
	|		ПО Субъект.Ссылка = СубъектПредприятия.Ссылка
	|ГДЕ
	|	НЕ Субъект.ПометкаУдаления
	|	И СубъектПредприятия.Предприятие <> ЗНАЧЕНИЕ(Справочник.ПредприятияВЕТИС.ПустаяСсылка)
	|	И (СубъектПредприятия.ТорговыйОбъект НЕ В (&ПустойТорговыйОбъект)
	|			ИЛИ СубъектПредприятия.ПроизводственныйОбъект НЕ В (&ПустойПроизводственныйОбъект))
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Т.ДокументОснование КАК ДокументОснование
	|ИЗ
	|	(ВЫБРАТЬ
	|		Т.ДокументОснование КАК ДокументОснование,
	|		Предприятия.ХозяйствующийСубъект КАК ХозяйствующийСубъект,
	|		Предприятия.Предприятие КАК Предприятие,
	|		Т.Документ = ЗНАЧЕНИЕ(Документ.ВходящаяТранспортнаяОперацияВЕТИС.ПустаяСсылка) КАК Приход,
	|		Т.Документ = ЗНАЧЕНИЕ(Документ.ИсходящаяТранспортнаяОперацияВЕТИС.ПустаяСсылка) КАК Расход
	|	ИЗ
	|		ТаблицаКЗаписиСтатуса КАК Т
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТПредприятия КАК Предприятия
	|			ПО Т.Контрагент = Предприятия.Контрагент
	|				И (Т.ТорговыйОбъект = Предприятия.ТорговыйОбъект
	|						И Т.ТорговыйОбъект НЕ В (&ПустойТорговыйОбъект)
	|					ИЛИ Т.ПроизводственныйОбъект = Предприятия.ПроизводственныйОбъект
	|						И Т.ПроизводственныйОбъект НЕ В (&ПустойПроизводственныйОбъект))) КАК Т
	|
	|СГРУППИРОВАТЬ ПО
	|	Т.ДокументОснование,
	|	Т.ХозяйствующийСубъект,
	|	Т.Предприятие
	|ИМЕЮЩИЕ
	|	МАКСИМУМ(Т.Приход) И МАКСИМУМ(Т.Расход)";
	
	УстановитьПривилегированныйРежим(Истина);
	НеОформлятьДокументы = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("ДокументОснование");
	УстановитьПривилегированныйРежим(Ложь);
	
	// Запишем статус оформления документа ВЕТИС.
	РасчетСтатусовОформленияИС.ЗаписатьСтатусОформленияДокументов(
		ТаблицаРеквизитов,
		РегистрыСведений.СтатусыОформленияДокументовВЕТИС,
		РасчетСтатусовОформленияВЕТИС,
		НеОформлятьДокументы);
	
КонецПроцедуры

//Возвращает признак необходимости записи в регистр "Статусы оформления документов ВетИС"
//
//Параметры:
//   ДокументОснование  - ОпределяемыйТип.ОснованиеСтатусыОформленияДокументовВЕТИС - записываемый в регистр документ-основание.
//   Реквизиты - См. РеквизитыДляРасчета
//   КоличествоСтрокДокументовОснования - Соответствие - количество строк основания требующих оформления.
//   НеОформлятьДокументы - Массив Из ОпределяемыйТип.ОснованиеСтатусыОформленияДокументовВЕТИС - элементы по которым оформление не требуется
//
//Возвращаемое значение:
//   Булево - признак необходимости записи
//
Функция ТребуетсяОформление(ДокументОснование, Реквизиты, КоличествоСтрокДокументовОснования, НеОформлятьДокументы) Экспорт
	
	Если ТипЗнч(ДокументОснование) = Тип("СправочникСсылка.ВетеринарноСопроводительныйДокументВЕТИС") И
		(Реквизиты.ПометкаУдаления
			ИЛИ Реквизиты.Статус <> Перечисления.СтатусыВетеринарныхДокументовВЕТИС.Оформлен) Тогда
		
		Возврат Ложь;
		
	ИначеЕсли ТипЗнч(ДокументОснование) <> Тип("СправочникСсылка.ВетеринарноСопроводительныйДокументВЕТИС")
		И НЕ Реквизиты.Проведен Тогда
		
		Возврат Ложь;
		
	ИначеЕсли ЗначениеЗаполнено(НеОформлятьДокументы)
		И НеОформлятьДокументы.Найти(ДокументОснование) <> Неопределено Тогда
		
		Возврат Ложь;
		
	КонецЕсли;
	
	Возврат ЗначениеЗаполнено(КоличествоСтрокДокументовОснования[ДокументОснование]);
	
КонецФункции

//Определяет текущий статус оформления документов ВЕТИС.
//   Особенности статуса оформления по сериям:
//     * Считается, что по одной номенклатуре в документе-основании серии либо указаны по всем строкам, либо отсутствуют.
//     * В случае, если в документе-основании серии не указаны, а в документе ВетИС указаны - это не ошибка оформления.
//   Возвращаемое соответствие в качестве ключей содержит ссылки на документы по которым происходит расчет, 
//     а в качестве значений - структуру с полями:
//     * СтатусОформления         - статус оформления объекта
//     * ДополнительнаяИнформация - информация для отладки.
//
// Параметры:
//   МассивДокументов         - Массив Из ОпределяемыйТип.ОснованиеСтатусыОформленияДокументовВЕТИС - документы-основание для документа ВЕТИС
//   МетаданныеДокументаВЕТИС - ОбъектМетаданныхДокумент - метаданные документа из ОпределяемыйТип.ДокументыВЕТИСПоддерживающиеСтатусыОформления
//   МенеджерВТ               - МенеджерВременныхТаблиц - (см. РасчетСтатусовОформленияИС.СформироватьТаблицуТоварыДокументовОснования)
//
//Возвращаемое значение:
//   Соответствие - расчетные статусы оформления документов.
//
Функция ОпределитьСтатусыОформленияДокументов(МассивДокументов, МетаданныеДокументаВЕТИС, МенеджерВТ) Экспорт
	
	ДокументОснование = МассивДокументов[0];
	ТипОснования = ТипЗнч(ДокументОснование);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("МассивДокументов", МассивДокументов);
	Запрос.УстановитьПараметр("ОтборСтрокОформленныеТовары", Истина);
	Запрос.УстановитьПараметр("ПустаяСерия", ИнтеграцияИС.НезаполненныеЗначенияОпределяемогоТипа("СерияНоменклатурыВЕТИС"));
	// Таблица товаров сформирована ранее
	Запрос.МенеджерВременныхТаблиц = МенеджерВТ;
	
	// Соберем текст запроса выборки данных для определения статуса оформления документа ВЕТИС.
	Если ТипОснования = Тип("СправочникСсылка.ВетеринарноСопроводительныйДокументВЕТИС") Тогда
		
		ШаблонЗапросаВТОформленныеДокументы =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ТаблицаДокументы.Ссылка КАК Ссылка,
		|	ТаблицаТовары.ВетеринарноСопроводительныйДокумент КАК ДокументОснование
		|ПОМЕСТИТЬ ОформленныеДокументы%1
		|ИЗ
		|	Документ.%1.Товары КАК ТаблицаТовары
		|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.%1 КАК ТаблицаДокументы
		|		ПО ТаблицаДокументы.Ссылка = ТаблицаТовары.Ссылка
		|	ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СтатусыДокументовВЕТИС КАК Статусы
		|		ПО Статусы.Документ = ТаблицаДокументы.Ссылка
		|ГДЕ
		|	ТаблицаТовары.ВетеринарноСопроводительныйДокумент В (&МассивДокументов)
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
		|	ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СтатусыДокументовВЕТИС КАК Статусы
		|		ПО Статусы.Документ = ТаблицаДокументы.Ссылка
		|ГДЕ
		|	ТаблицаДокументы.ДокументОснование В (&МассивДокументов)
		|	И ТаблицаДокументы.Проведен
		|	И НЕ Статусы.Статус В (&КонечныеСтатусы%1)
		|ИНДЕКСИРОВАТЬ ПО
		|	Ссылка";
		
	КонецЕсли;
	
	ШаблонЗапросаОформленныеТоварыПоВСД = "
	|
	|	ОБЪЕДИНИТЬ ВСЕ
	|
	|	ВЫБРАТЬ РАЗЛИЧНЫЕ
	|		ОформленныеДокументы.ДокументОснование КАК ДокументОснование,
	|		%2 КАК ЭтоДвижениеПриход,
	|		НЕОПРЕДЕЛЕНО КАК Номенклатура,
	|		НЕОПРЕДЕЛЕНО КАК Характеристика,
	|		НЕОПРЕДЕЛЕНО КАК Серия,
	|		0			 КАК План,
	|		1 			 КАК Факт
	|	ИЗ
	|		Документ.%1 КАК ОформленныеТовары
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ОформленныеДокументы%1 КАК ОформленныеДокументы
	|			ПО ОформленныеТовары.Ссылка = ОформленныеДокументы.Ссылка";
	
	ШаблонЗапросаОформленныеТовары = "
	|
	|	ОБЪЕДИНИТЬ ВСЕ
	|
	|	ВЫБРАТЬ
	|		ОформленныеДокументы.ДокументОснование КАК ДокументОснование,
	|		%3 КАК ЭтоДвижениеПриход,
	|		ОформленныеТовары.Номенклатура   КАК Номенклатура,
	|		ОформленныеТовары.Характеристика КАК Характеристика,
	|		ВЫБОР
	|			КОГДА ТоварыКОформлениюССериями.Номенклатура ЕСТЬ NULL ТОГДА НЕОПРЕДЕЛЕНО
	|			ИНАЧЕ ОформленныеТовары.Серия КОНЕЦ КАК Серия,
	|		0                                КАК План,
	|		ВЫБОР КОГДА ОформленныеТовары.%4 < 0 ТОГДА -1 ИНАЧЕ 1 КОНЕЦ * ОформленныеТовары.%4 КАК Факт
	|	ИЗ
	|		Документ.%1.%2 КАК ОформленныеТовары
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ОформленныеДокументы%1 КАК ОформленныеДокументы
	|			ПО ОформленныеТовары.Ссылка = ОформленныеДокументы.Ссылка
	|			И &ОтборСтрокОформленныеТовары
	|		ЛЕВОЕ СОЕДИНЕНИЕ ТоварыКОформлениюССериями КАК ТоварыКОформлениюССериями
	|			ПО ОформленныеДокументы.ДокументОснование = ТоварыКОформлениюССериями.ДокументОснование
	|			И ОформленныеТовары.Номенклатура = ТоварыКОформлениюССериями.Номенклатура
	|			И ОформленныеТовары.Характеристика = ТоварыКОформлениюССериями.Характеристика
	|";
	
	ШаблонЗапросаОформленныеТоварыСУточнениями = "
	|
	|	ОБЪЕДИНИТЬ ВСЕ
	|
	|	ВЫБРАТЬ
	|		ОформленныеДокументы.ДокументОснование КАК ДокументОснование,
	|		%3 КАК ЭтоДвижениеПриход,
	|		ОформленныеТовары.Номенклатура   КАК Номенклатура,
	|		ОформленныеТовары.Характеристика КАК Характеристика,
	|		ВЫБОР
	|			КОГДА ТоварыКОформлениюССериями.Номенклатура ЕСТЬ NULL ТОГДА НЕОПРЕДЕЛЕНО
	|			ИНАЧЕ ОформленныеТовары.Серия КОНЕЦ КАК Серия,
	|		0                                КАК План,
	|		ВЫБОР КОГДА ОформленныеТовары.%4 < 0 ТОГДА -1 ИНАЧЕ 1 КОНЕЦ * ОформленныеТовары.%4 КАК Факт
	|	ИЗ
	|		Документ.%1.%2 КАК ОформленныеТовары
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ОформленныеДокументы%1 КАК ОформленныеДокументы
	|			ПО ОформленныеТовары.Ссылка = ОформленныеДокументы.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.%1.ТоварыУточнение КАК ОформленныеТоварыУточнение
	|			ПО ОформленныеТовары.Ссылка = ОформленныеТоварыУточнение.Ссылка
	|				И ОформленныеТоварыУточнение.Количество <> 0
	|				И ОформленныеТовары.ИдентификаторСтроки = ОформленныеТоварыУточнение.ИдентификаторСтроки
	|		ЛЕВОЕ СОЕДИНЕНИЕ ТоварыКОформлениюССериями КАК ТоварыКОформлениюССериями
	|			ПО ОформленныеДокументы.ДокументОснование = ТоварыКОформлениюССериями.ДокументОснование
	|			И ОформленныеТовары.Номенклатура = ТоварыКОформлениюССериями.Номенклатура
	|			И ОформленныеТовары.Характеристика = ТоварыКОформлениюССериями.Характеристика
	|	ГДЕ
	|		ОформленныеТоварыУточнение.ИдентификаторСтроки ЕСТЬ NULL
	|
	|	ОБЪЕДИНИТЬ ВСЕ
	|
	|	ВЫБРАТЬ
	|		ОформленныеДокументы.ДокументОснование    КАК ДокументОснование,
	|		%3 КАК ЭтоДвижениеПриход,
	|		ОформленныеТоварыУточнение.Номенклатура   КАК Номенклатура,
	|		ОформленныеТоварыУточнение.Характеристика КАК Характеристика,
	|		ВЫБОР
	|			КОГДА ТоварыКОформлениюССериями.Номенклатура ЕСТЬ NULL ТОГДА НЕОПРЕДЕЛЕНО
	|			ИНАЧЕ ОформленныеТоварыУточнение.Серия КОНЕЦ КАК Серия,
	|		0                                         КАК План,
	|		ОформленныеТоварыУточнение.Количество     КАК Факт
	|	ИЗ
	|		Документ.%1.%2Уточнение КАК ОформленныеТоварыУточнение
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ОформленныеДокументы%1 КАК ОформленныеДокументы
	|			ПО ОформленныеТоварыУточнение.Ссылка = ОформленныеДокументы.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ ТоварыКОформлениюССериями КАК ТоварыКОформлениюССериями
	|			ПО ОформленныеДокументы.ДокументОснование = ТоварыКОформлениюССериями.ДокументОснование
	|			И ОформленныеТоварыУточнение.Номенклатура = ТоварыКОформлениюССериями.Номенклатура
	|			И ОформленныеТоварыУточнение.Характеристика = ТоварыКОформлениюССериями.Характеристика
	|";
	
	ШаблонРазделительЗапросов = "
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|";
	
	ТекстЗапросаВТОформленныеДокументы = "";
	ТекстЗапросаОформленныеТовары = "";
	
	ИмяДокументаВЕТИС   = МетаданныеДокументаВЕТИС.Имя;
	
	Если МетаданныеДокументаВЕТИС = Метаданные.Документы.ИсходящаяТранспортнаяОперацияВЕТИС Тогда
		ЭтоДвижениеПриход = "ЛОЖЬ";
	ИначеЕсли МетаданныеДокументаВЕТИС = Метаданные.Документы.ИнвентаризацияПродукцииВЕТИС Тогда
		ЭтоДвижениеПриход =
			"ВЫБОР КОГДА ОформленныеТовары.Операция = ЗНАЧЕНИЕ(Перечисление.ОперацииИнвентаризацииПродукцииВЕТИС.Добавление)
			|		ИЛИ (ОформленныеТовары.Операция = ЗНАЧЕНИЕ(Перечисление.ОперацииИнвентаризацииПродукцииВЕТИС.Изменение) И ОформленныеТовары.КоличествоИзменение > 0) ТОГДА ИСТИНА ИНАЧЕ ЛОЖЬ КОНЕЦ";
	Иначе
		ЭтоДвижениеПриход = "ИСТИНА";
	КонецЕсли;
		
	ТекстЗапросаВТОформленныеДокументы = ТекстЗапросаВТОформленныеДокументы
		+ СтрШаблон(ШаблонЗапросаВТОформленныеДокументы, ИмяДокументаВЕТИС)
		+ ШаблонРазделительЗапросов;
	
	Если ТипОснования = Тип("СправочникСсылка.ВетеринарноСопроводительныйДокументВЕТИС") Тогда
		
		ТекстЗапросаОформленныеТовары = ТекстЗапросаОформленныеТовары
			+ СтрШаблон(ШаблонЗапросаОформленныеТоварыПоВСД, ИмяДокументаВЕТИС, ЭтоДвижениеПриход);
		
	Иначе
		
		ТекстЗапросаОформленныеТовары = ТекстЗапросаОформленныеТовары
			+ СтрШаблон(
				?(МетаданныеДокументаВЕТИС = Метаданные.Документы.ВходящаяТранспортнаяОперацияВЕТИС,
					ШаблонЗапросаОформленныеТоварыСУточнениями,
					ШаблонЗапросаОформленныеТовары),
				ИмяДокументаВЕТИС,
				"Товары",
				ЭтоДвижениеПриход,
				?(МетаданныеДокументаВЕТИС = Метаданные.Документы.ИнвентаризацияПродукцииВЕТИС,
					"КоличествоИзменение",
					"Количество"));
		
	КонецЕсли;
	
	Если МетаданныеДокументаВЕТИС = Метаданные.Документы.ПроизводственнаяОперацияВЕТИС Тогда
		
		ТекстЗапросаОформленныеТовары = ТекстЗапросаОформленныеТовары
			+ СтрШаблон(
				ШаблонЗапросаОформленныеТовары,
				ИмяДокументаВЕТИС,
				"Сырье",
				"ЛОЖЬ",
				"Количество");
		
	ИначеЕсли МетаданныеДокументаВЕТИС = Метаданные.Документы.ИсходящаяТранспортнаяОперацияВЕТИС Тогда
		
		ТекстЗапросаОформленныеТовары = СтрЗаменить(ТекстЗапросаОформленныеТовары,
			"&ОтборСтрокОформленныеТовары", 
			"ЕСТЬNULL(ОформленныеТовары.ВетеринарноСопроводительныйДокумент.Статус, ЗНАЧЕНИЕ(Перечисление.СтатусыВетеринарныхДокументовВЕТИС.ПустаяСсылка)) <> ЗНАЧЕНИЕ(Перечисление.СтатусыВетеринарныхДокументовВЕТИС.Аннулирован)");
		
	КонецЕсли;
	
	Запрос.УстановитьПараметр(
		"КонечныеСтатусы" + ИмяДокументаВЕТИС,
		Документы[ИмяДокументаВЕТИС].КонечныеСтатусы());
	
	ЧастиЗапроса = Новый Массив;
	ЧастиЗапроса.Добавить(ТекстЗапросаВТОформленныеДокументы);
	
	ЧастиЗапроса.Добавить(СтрШаблон("
		|ВЫБРАТЬ
		|	Товары.Ссылка         КАК ДокументОснование,
		|	Товары.Номенклатура   КАК Номенклатура,
		|	Товары.Характеристика КАК Характеристика
		|ПОМЕСТИТЬ ТоварыКОформлениюССериями
		|ИЗ 
		|	%1 КАК Товары
		|ГДЕ
		|	Товары.Серия НЕ В (&ПустаяСерия)
		|СГРУППИРОВАТЬ ПО
		|	Товары.Ссылка,
		|	Товары.Номенклатура,
		|	Товары.Характеристика
		|;
		|", РасчетСтатусовОформленияИС.ИмяВременнойТаблицыДляВыборкиДанныхДокумента()));
		
	ЧастиЗапроса.Добавить(СтрШаблон("
		|ВЫБРАТЬ
		|	ТоварыКОформлению.ДокументОснование КАК ДокументОснование,
		|	ТоварыКОформлению.ЭтоДвижениеПриход КАК ЭтоДвижениеПриход,
		|	ТоварыКОформлению.Номенклатура      КАК Номенклатура,
		|	ТоварыКОформлению.Характеристика    КАК Характеристика,
		|	ТоварыКОформлению.Серия             КАК Серия,
		|	СУММА(ТоварыКОформлению.План)       КАК План,
		|	СУММА(ТоварыКОформлению.Факт)       КАК Факт
		|ПОМЕСТИТЬ Результат
		|ИЗ
		|	(ВЫБРАТЬ
		|		Товары.Ссылка 			 КАК ДокументОснование,
		|		Товары.ЭтоДвижениеПриход КАК ЭтоДвижениеПриход,
		|		Товары.Номенклатура      КАК Номенклатура,
		|		Товары.Характеристика    КАК Характеристика,
		|		ВЫБОР
		|			КОГДА ТоварыКОформлениюССериями.Номенклатура ЕСТЬ NULL ТОГДА НЕОПРЕДЕЛЕНО
		|			ИНАЧЕ Товары.Серия КОНЕЦ КАК Серия,
		|		Товары.Количество        КАК План,
		|		0                        КАК Факт
		|	ИЗ
		|		%1 КАК Товары
		|		ЛЕВОЕ СОЕДИНЕНИЕ ТоварыКОформлениюССериями КАК ТоварыКОформлениюССериями
		|			ПО Товары.Ссылка = ТоварыКОформлениюССериями.ДокументОснование
		|			И Товары.Номенклатура = ТоварыКОформлениюССериями.Номенклатура
		|			И Товары.Характеристика = ТоварыКОформлениюССериями.Характеристика
		|
		|", РасчетСтатусовОформленияИС.ИмяВременнойТаблицыДляВыборкиДанныхДокумента()));
	
	ЧастиЗапроса.Добавить(ТекстЗапросаОформленныеТовары);
	ЧастиЗапроса.Добавить("
		|	) КАК ТоварыКОформлению
		|СГРУППИРОВАТЬ ПО
		|	ТоварыКОформлению.ДокументОснование,
		|	ТоварыКОформлению.ЭтоДвижениеПриход,
		|	ТоварыКОформлению.Номенклатура,
		|	ТоварыКОформлению.Характеристика,
		|	ТоварыКОформлению.Серия
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
	
	// Получим данные и определим статус оформления документа ВЕТИС.
	
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
		ТаблицаДляРасчетаСтатуса.Колонки.План.Заголовок 			 = НСтр("ru = 'По документу-основанию';
																			|en = 'По документу-основанию'");
		ТаблицаДляРасчетаСтатуса.Колонки.Факт.Заголовок 			 = НСтр("ru = 'По документу ВетИС';
																			|en = 'По документу ВетИС'");
		
		ДополнительнаяИнформация = Новый ХранилищеЗначения(ТаблицаДляРасчетаСтатуса, Новый СжатиеДанных(9));
		
		СтатусОформления = Новый Структура(
			"СтатусОформления, ДополнительнаяИнформация",
			Выборка.СтатусОформления,
			ДополнительнаяИнформация);
		
		Результат.Вставить(Выборка.ДокументОснование, СтатусОформления);
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

//Позволяет определить текст и параметры запроса выборки данных из документов-основания для расчета статуса оформления. 
//
//Параметры:
//   МетаданныеОснования - ОбъектМетаданных - метаданные документа из ОпределяемыйТип.Основание<Имя документа ВЕТИС>.
//   МетаданныеДокументаВЕТИС - ОбъектМетаданных - метаданные документа из ОпределяемыйТип.ДокументыВЕТИСПоддерживающиеСтатусыОформления.
//   ТекстЗапроса - Строка - текст запроса выборки данных, который надо определить.
//   ПараметрыЗапроса - Структура - дополнительные параметры запроса, требуемые для выполнения запроса 
//       конкретного документа; при необходимости можно дополнить данную структуру.
//
Процедура ПриОпределенииЗапросаТоварыДокументаОснования(МетаданныеОснования, МетаданныеДокументаВЕТИС,
	ТекстЗапроса, ПараметрыЗапроса) Экспорт
	
	Если МетаданныеОснования = Метаданные.Справочники.ВетеринарноСопроводительныйДокументВЕТИС Тогда
		
		ТекстЗапроса =
		"ВЫБРАТЬ
		|	ВСД.Ссылка   КАК Ссылка,
		|	ИСТИНА       КАК ЭтоДвижениеПриход,
		|	НЕОПРЕДЕЛЕНО КАК Номенклатура,
		|	НЕОПРЕДЕЛЕНО КАК Характеристика,
		|	НЕОПРЕДЕЛЕНО КАК Серия,
		|	1            КАК Количество
		|ПОМЕСТИТЬ %1
		|ИЗ
		|	Справочник.ВетеринарноСопроводительныйДокументВЕТИС КАК ВСД
		|ГДЕ
		|	ВСД.Ссылка В (&МассивДокументов)
		|	И ВСД.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыВетеринарныхДокументовВЕТИС.Оформлен)
		|	И НЕ ВСД.ПометкаУдаления";
		
	КонецЕсли;
	
	РасчетСтатусовОформленияВЕТИСПереопределяемый.ПриОпределенииТекстаЗапросаДляРасчетаСтатусаОформленияДокументаВЕТИС(
		МетаданныеОснования, МетаданныеДокументаВЕТИС, ТекстЗапроса, ПараметрыЗапроса);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

//Рассчитывает статусы ветеринарных сопроводительных документов, указанных во входящей транспортной операции.
//   Специфика ВетИС.
//
//Параметры:
//   Источник - ДокументОбъект.ВходящаяТранспортнаяОперацияВЕТИС, ДокументСсылка.ВходящаяТранспортнаяОперацияВЕТИС, Массив из ДокументСсылка.ВходящаяТранспортнаяОперацияВЕТИС - объект, содержащий данные о ВСД.
//
Процедура РассчитатьСтатусыОформленияВСД(Источник)
	
	Если ТипЗнч(Источник) = Тип("ДокументОбъект.ВходящаяТранспортнаяОперацияВЕТИС") Тогда
		
		ТаблицаВСД = Источник.Товары.Выгрузить(, "ВетеринарноСопроводительныйДокумент");
		ТаблицаВСД.Свернуть("ВетеринарноСопроводительныйДокумент", "");
		
		ПустыеВСД = ТаблицаВСД.НайтиСтроки(
			Новый Структура("ВетеринарноСопроводительныйДокумент", Справочники.ВетеринарноСопроводительныйДокументВЕТИС.ПустаяСсылка()));
		
		Для Каждого СтрокаТаблицы Из ПустыеВСД Цикл
			ТаблицаВСД.Удалить(СтрокаТаблицы);
		КонецЦикла;
		
	Иначе
		
		Если ТипЗнч(Источник) = Тип("Массив") И ЗначениеЗаполнено(Источник) Тогда
			ИсточникСсылка = Источник[0];
		Иначе
			ИсточникСсылка = Источник;
		КонецЕсли;
		
		Если ТипЗнч(ИсточникСсылка) <> Тип("ДокументСсылка.ВходящаяТранспортнаяОперацияВЕТИС") Тогда
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
		|	Товары.ВетеринарноСопроводительныйДокумент КАК ВетеринарноСопроводительныйДокумент
		|ИЗ
		|	Документ.ВходящаяТранспортнаяОперацияВЕТИС.Товары КАК Товары
		|ГДЕ
		|	Товары.Ссылка В (&МассивДокументов)
		|	И Товары.ВетеринарноСопроводительныйДокумент <> ЗНАЧЕНИЕ(Справочник.ВетеринарноСопроводительныйДокументВЕТИС.ПустаяСсылка)";
		
		Запрос.УстановитьПараметр("МассивДокументов", МассивДокументов);
		
		УстановитьПривилегированныйРежим(Истина);
		ТаблицаВСД = Запрос.Выполнить().Выгрузить();
		УстановитьПривилегированныйРежим(Ложь);
		
	КонецЕсли;
	
	РасчетСтатусовОформленияИС.РассчитатьОбщая(
		ТаблицаВСД.ВыгрузитьКолонку("ВетеринарноСопроводительныйДокумент"), Неопределено, РасчетСтатусовОформленияВЕТИС);
	
КонецПроцедуры

#КонецОбласти
