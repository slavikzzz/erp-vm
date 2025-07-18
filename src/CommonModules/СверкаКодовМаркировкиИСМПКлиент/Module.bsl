#Область ПрограммныйИнтерфейс

// Открывает форму результаты сверки по кодам маркировки.
// 
// Параметры:
// 	Форма - ФормаКлиентскогоПриложения - Источник события
// 	ДополнительныеПараметры - Структура - содержит даннные для отбора по номенклатуре, если форма открывается для выбранной строки товары.
//   * ДанныеВыбораПоМаркируемойПродукции - Структура.
//     ** Номенклатура - ОпределяемыйТип.Номенклатура - Номенклатура.
//     ** Характеристика - ОпределяемыйТип.ХарактеристикаНоменклатуры - Характеристика.
//     ** Представление - Строка - представление номенклатуры.
//   * СохраненВыборПоМаркируемойПродукции - Булево - истина, если требуется установить отбор по переданным данным выбора.
//
Процедура ОткрытьФормуРезультатовСверкиКодовМаркировки(Форма, ДополнительныеПараметры = Неопределено) Экспорт
	
	Отказ           = Ложь;
	ТребуетсяВопрос = Ложь;
	
	ПараметрыОткрытияФормыСверки = ПараметрыОткрытияФормыСверки(Форма);
	
	Если Не ПустаяСтрока(ПараметрыОткрытияФормыСверки.ИмяРеквизитаФормыОбъект) Тогда
		Объект = Форма[ПараметрыОткрытияФормыСверки.ИмяРеквизитаФормыОбъект];
		Если ДополнительныеПараметры <> Неопределено Тогда
			ЗаполнитьЗначенияСвойств(ПараметрыОткрытияФормыСверки, ДополнительныеПараметры);
		КонецЕсли;
		
		Если Не ПараметрыОткрытияФормыСверки.ПроверятьМодифицированность Тогда
		ИначеЕсли Объект.Ссылка.Пустая() Тогда
			ТребуетсяВопрос = Истина;
			ТекстВопроса    = НСтр("ru = 'Просмотр расхождений по кодам маркировки возможен только в записанном документе. Записать?';
									|en = 'Просмотр расхождений по кодам маркировки возможен только в записанном документе. Записать?'");
		ИначеЕсли Форма.Модифицированность Тогда
			ТребуетсяВопрос  = Истина;
			ПровестиЗаписать = ?(Объект.Проведен, НСтр("ru = 'Провести';
														|en = 'Провести'"), НСтр("ru = 'Записать';
																				|en = 'Записать'"));
			ТекстВопроса     = СтрШаблон(НСтр("ru = 'Документ был изменен. %1?';
												|en = 'Документ был изменен. %1?'"), ПровестиЗаписать);
		КонецЕсли;
	КонецЕсли;
	
	Если Отказ Тогда
		
		Возврат;
		
	ИначеЕсли ТребуетсяВопрос Тогда
		
		ПараметрыВопроса = Новый Структура();
		ПараметрыВопроса.Вставить("Форма", Форма);
		ПараметрыВопроса.Вставить("ПараметрыОткрытияФормыСверки", ПараметрыОткрытияФормыСверки);
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ОткрытьФормуРезультатыСверкиКМПриОтветеНаВопрос",
			ЭтотОбъект, ПараметрыВопроса);
		
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		
	Иначе
		
		ОткрытьФормуРезультатыСверкиКММаркируемойПродукции(Форма, ПараметрыОткрытияФормыСверки);
		
	КонецЕсли;
	
КонецПроцедуры

// Записывает документ и продолжает открытие формы результаты сверки по кодам маркировки после ответа на вопрос о модифицированности формы
// 
// Параметры:
//  РезультатВопроса - КодВозвратаДиалога - Результат ответа на вопрос.
//  ДополнительныеПараметры - Структура:
//   * Форма - ФормаКлиентскогоПриложения - Источник события.
//   * ПараметрыОткрытияФормыСверки - Структура - подготовленные параметры открытия формы сверки. (См. ПараметрыОткрытияФормыСверки).
// 
Процедура ОткрытьФормуРезультатыСверкиКМПриОтветеНаВопрос(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	Форма = ДополнительныеПараметры.Форма;
	ПараметрыОткрытияФормыСверки = ДополнительныеПараметры.ПараметрыОткрытияФормыСверки;
	
	Объект = Форма[ПараметрыОткрытияФормыСверки.ИмяРеквизитаФормыОбъект];
	
	СтандартнаяОбработка = Ложь;
	ДействиеПослеЗаписи = Новый ОписаниеОповещения("ОткрытьФормуРезультатыСверкиКМПослеЗаписиОбъекта", ЭтотОбъект, ДополнительныеПараметры);
	ИнтеграцияИСКлиентПереопределяемый.ВыполнитьЗаписьОбъектаВФорме(Форма, Объект, ДействиеПослеЗаписи, СтандартнаяОбработка);
	
	Если Не СтандартнаяОбработка Тогда
		Возврат;
	КонецЕсли;
	
	РезультатЗаписи = Ложь;
	Если Объект.Проведен Тогда
		Если Форма.ПроверитьЗаполнение() Тогда
			РезультатЗаписи = Форма.Записать(Новый Структура("РежимЗаписи", РежимЗаписиДокумента.Проведение));
		КонецЕсли;
	Иначе
		РезультатЗаписи = Форма.Записать(Новый Структура("РежимЗаписи", РежимЗаписиДокумента.Запись));
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(ДействиеПослеЗаписи, РезультатЗаписи);
	
КонецПроцедуры

// Открывает форму результаты сверки по кодам маркировки после записи документа.
// 
// Параметры:
//  РезультатЗаписи - Булево - Истина, если запись документа выполнена без ошибок.
//  ДополнительныеПараметры - Структура:
//   * Форма - ФормаКлиентскогоПриложения - Источник события.
//   * ПараметрыОткрытияФормыСверки - Структура - подготовленные параметры открытия формы сверки. (См. ПараметрыОткрытияФормыСверки).
// 
Процедура ОткрытьФормуРезультатыСверкиКМПослеЗаписиОбъекта(РезультатЗаписи, ДополнительныеПараметры) Экспорт
	
	Если Не РезультатЗаписи Тогда
		Возврат;
	КонецЕсли;
	
	Форма = ДополнительныеПараметры.Форма;
	ПараметрыОткрытияФормыСверки = ДополнительныеПараметры.ПараметрыОткрытияФормыСверки;
	
	ОткрытьФормуРезультатыСверкиКММаркируемойПродукции(Форма, ПараметрыОткрытияФормыСверки);
	
КонецПроцедуры

// Предназначена для открытия формы результаты сверки по кодам маркировки.
// 
// Параметры:
//   * Форма - ФормаКлиентскогоПриложения - форма прикладного документа или общая форма, в который встраивается функциональность библиотеки ГосИС.
//   * ПараметрыОткрытияФормыСверки - Структура - (См. ПараметрыОткрытияФормыСверкиИПодбора).
//
Процедура ОткрытьФормуРезультатыСверкиКММаркируемойПродукции(Форма, Знач ПараметрыОткрытияФормыСверки) Экспорт

	ОчиститьСообщения();
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("РедактированиеФормыНедоступно",        ПараметрыОткрытияФормыСверки.РедактированиеФормыНедоступно);
	ПараметрыФормы.Вставить("ДанныеВыбораПоМаркируемойПродукции",   ПараметрыОткрытияФормыСверки.ДанныеВыбораПоМаркируемойПродукции);
	ПараметрыФормы.Вставить("СохраненВыборПоМаркируемойПродукции",  ПараметрыОткрытияФормыСверки.СохраненВыборПоМаркируемойПродукции);
	ПараметрыФормы.Вставить("ПроверкаЭлектронногоДокумента",        ПараметрыОткрытияФормыСверки.ПроверкаЭлектронногоДокумента);
	ПараметрыФормы.Вставить("ДоступноСогласованиеРасхождений",      ПараметрыОткрытияФормыСверки.ДоступноСогласованиеРасхождений);
	ПараметрыФормы.Вставить("ВосстановитьПоДаннымПроверкиПодбора",  ПараметрыОткрытияФормыСверки.ВосстановитьПоДаннымПроверкиПодбора);
	ПараметрыФормы.Вставить("ЗаголовокФормы",                       ПараметрыОткрытияФормыСверки.ЗаголовокФормы);
	
	ПараметрыФормы.Вставить("ИмяТабличнойЧастиШтрихкодыУпаковокФакт",        ПараметрыОткрытияФормыСверки.ИмяТабличнойЧастиШтрихкодыУпаковокФакт);
	ПараметрыФормы.Вставить("ИмяТабличнойЧастиШтрихкодыУпаковокРасхождения", ПараметрыОткрытияФормыСверки.ИмяТабличнойЧастиШтрихкодыУпаковокРасхождения);
	
	Объект = Форма[ПараметрыОткрытияФормыСверки.ИмяРеквизитаФормыОбъект];
	
	ПараметрыФормы.Вставить("ПроверяемыйДокумент",    Объект.Ссылка);
	ПараметрыФормы.Вставить("Организация",            Объект[ПараметрыОткрытияФормыСверки.ИмяРеквизитаОрганизация]);
	ПараметрыФормы.Вставить("ИдентификаторВладельца", Форма.УникальныйИдентификатор);
	
	Отказ = Ложь;
	
	СверкаКодовМаркировкиИСМПКлиентПереопределямый.ПередОткрытиемФормыРезультатыСверкиКодовМаркировки(
		Форма, ПараметрыОткрытияФормыСверки, ПараметрыФормы, Отказ);
	
	Если Отказ Тогда
		Возврат;
	Иначе
		ИмяФормыПроверкиИПодбора = "Обработка.РезультатыСверкиКодовМаркировкиТОРГ2.Форма.РезультатыСверки";
		ОткрытьФорму(ИмяФормыПроверкиИПодбора,
			ПараметрыФормы,
			Форма,
			Форма.УникальныйИдентификатор, , ,
			ПараметрыОткрытияФормыСверки.ОписаниеОповещенияПриЗакрытии,
			РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Предназначена для установки параметров открытия формы результаты сверки кодов маркировки.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма прикладного документа или общая форма, в который встраивается функциональность библиотеки ГосИС:
// 
// Возвращаемое значение
//  * ПараметрыОткрытия - Структура - значения, используемые для управления открытием формы сверки кодов маркировки продукции.
//  ** ИмяРеквизитаФормыОбъект              - Строка - имя реквизита формы документа, содержащего объект документа.
//  ** ИмяРеквизитаОрганизация              - Строка - имя реквизита документа или реквизита формы, содержащего организацию
//  ** ИмяРеквизитаДокументОснования        - Строка - имя реквизита документа, содержащего его основание. Если основания нет, должен быть пустой строкой.
//  ** ИмяКоллекцииДокументыОснование       - Строка - имя коллекции документа, содержащей его основания. Если основания нет, должен быть пустой строкой.
//  ** ВосстановитьПоДаннымПроверкиПодбора  - Булево - признак загрузки результатов сверки по данным проверки и подбора. Устанавливать Истина, для документа расхождений, созданного из формы проверки и подбора.
//  ** ДоступноСогласованиеРасхождений      - Булево - признак доступности колонки и действия "Признать расхождения".
//  ** РедактированиеФормыНедоступно        - Булево - признак недоступности редактирования формы, из которой открывается форма проверки
//  ** ОписаниеОповещенияПриЗакрытии        - ОписаниеОповещения - описание процедуры, которая будет вызвана после закрытия формы проверки
//  ** ПроверятьМодифицированность          - Булево - признак необходимости записи документа перед открытием формы сверки
//  ** ПроверкаЭлектронногоДокумента        - Булево - признак режима проверки входящего электронного документа.
//  ** ДанныеВыбораПоМаркируемойПродукции   - Структура - Структура сохраненного выбора по данным номенклатуры.
//  ** СохраненВыборПоМаркируемойПродукции  - Булево - Истина, если сохранен выбор по маркируемой продукции.
//  ** ЗаголовокФормы                       - Строка - заголовок открываемой формы.
//  ** ИмяТабличнойЧастиШтрихкодыУпаковокФакт - Строка - имя табличной части документа, содержащей фактические данные о принятых штрихкодах.
//  ** ИмяТабличнойЧастиШтрихкодыУпаковокРасхождения - Строка - имя табличной части документа, содержащей данные о расхождениях поступивших штрихкодах.
//
Функция ПараметрыОткрытияФормыСверки(Форма)
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("ИмяРеквизитаФормыОбъект",             "Объект");
	ПараметрыОткрытия.Вставить("ИмяРеквизитаОрганизация",             "Организация");
	ПараметрыОткрытия.Вставить("ИмяРеквизитаДокументОснования",       "");
	ПараметрыОткрытия.Вставить("ИмяКоллекцииДокументыОснование",      "");
	ПараметрыОткрытия.Вставить("РедактированиеФормыНедоступно",       Ложь);
	ПараметрыОткрытия.Вставить("ПроверятьМодифицированность",         Истина);
	ПараметрыОткрытия.Вставить("ПроверкаЭлектронногоДокумента",       Ложь);
	ПараметрыОткрытия.Вставить("ДанныеВыбораПоМаркируемойПродукции",  Неопределено);
	ПараметрыОткрытия.Вставить("СохраненВыборПоМаркируемойПродукции", Ложь);
	ПараметрыОткрытия.Вставить("ЗаголовокФормы",                      "Результаты сверки кодов маркировки");
	ПараметрыОткрытия.Вставить("ДоступноСогласованиеРасхождений",     Ложь);
	ПараметрыОткрытия.Вставить("ВосстановитьПоДаннымПроверкиПодбора", Ложь);
	ПараметрыОткрытия.Вставить("ИдентификаторВладельца",              "");	
	ПараметрыОткрытия.Вставить("ИмяТабличнойЧастиШтрихкодыУпаковокФакт", "");
	ПараметрыОткрытия.Вставить("ИмяТабличнойЧастиШтрихкодыУпаковокРасхождения", "");
	
	ПараметрыЗакрытия = Новый Структура;
	ПараметрыЗакрытия.Вставить("Форма",                   Форма);
	
	ОповещениеПриЗакрытии = Новый ОписаниеОповещения("ПриЗакрытииФормыСверкиКодовМаркировки",
		ЭтотОбъект, ПараметрыЗакрытия);
		
	ПараметрыОткрытия.Вставить("ОписаниеОповещенияПриЗакрытии", ОповещениеПриЗакрытии);
	
	ПриУстановкеПараметровОткрытияФормыСверкиКодовМаркировки(Форма, ПараметрыОткрытия);
	
	Возврат ПараметрыОткрытия;
	
КонецФункции

// Заполняет параметры открытия, переданные во втором параметре, формы результаты сверки кодов маркировки.
// 
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма прикладного документа или общая форма, в который встраивается функциональность библиотеки ГосИС.
//  ПараметрыОткрытия - Структура - заполняемые параметры открытия формы сверки (См. ПараметрыОткрытияФормыСверки).
// 
Процедура ПриУстановкеПараметровОткрытияФормыСверкиКодовМаркировки(Форма, ПараметрыОткрытия)
	
	СверкаКодовМаркировкиИСМПКлиентПереопределямый.ПриУстановкеПараметровОткрытияФормыСверкиКодовМаркировки(Форма, ПараметрыОткрытия);
	
КонецПроцедуры

// Выполняет специфичные действия после закрытия форм сверки кодов маркировки в зависимости от точки вызова.
//
// Параметры:
//  РезультатЗакрытия - Произвольный - результат закрытия формы проверки и подбора.
//  ДополнительныеПараметры - Структура - структура с реквизитом Форма (управляемая форма из которой происходил вызов).
//
Процедура ПриЗакрытииФормыСверкиКодовМаркировки(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	СверкаКодовМаркировкиИСМПКлиентПереопределямый.ПриЗакрытииФормыСверкиКодовМаркировки(РезультатЗакрытия, ДополнительныеПараметры);
	
КонецПроцедуры

#КонецОбласти