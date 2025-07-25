/////////////////////////////////////////////////////////////////////////////////////////
// СопоставлениеНоменклатурыКонтрагентовКлиент: 
// механизм сопоставления номенклатуры контрагентов с номенклатурой информационной базы.
//
////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#Область РаботаСоСправочникомНоменклатураКонтрагентов

// Открывает форму выбора справочника НоменклатураКонтрагентов.
//
// Параметры:
//  ПараметрыФормы      - Структура                  - параметры формы.
//  ВладелецФормы       - ФормаКлиентскогоПриложения - владелец формы.
//  ОповещениеОЗакрытии - ОписаниеОповещения         - оповещения, которое необходимо выполнить после закрытия формы.
//  РежимОткрытияОкна   - РежимОткрытияОкнаФормы     - режим, в котором необходимо открыть окно формы.
//
Процедура ОткрытьФормуВыбораНоменклатурыКонтрагентов(Знач ПараметрыФормы,
		Знач ВладелецФормы = Неопределено, Знач ОповещениеОЗакрытии = Неопределено, Знач РежимОткрытияОкна = Неопределено) Экспорт
		
	ОткрытьФорму("Справочник.НоменклатураКонтрагентов.Форма.ФормаВыбора",
		ПараметрыФормы, ВладелецФормы, , , , ОповещениеОЗакрытии, РежимОткрытияОкна);
		
КонецПроцедуры

// Открывает форму списка справочника НоменклатураКонтрагентов.
//
// Параметры:
//  ПараметрыОтбора     - Структура                  - параметры отбора формы.
//  ВладелецФормы       - ФормаКлиентскогоПриложения - владелец формы.
//  ОповещениеОЗакрытии - ОписаниеОповещения         - оповещения, которое необходимо выполнить после закрытия формы.
//  РежимОткрытияОкна   - РежимОткрытияОкнаФормы     - режим, в котором необходимо открыть окно формы.
//
Процедура ОткрытьФормуСпискаНоменклатурыКонтрагентов(Знач ПараметрыОтбора,
		Знач ВладелецФормы = Неопределено, Знач ОповещениеОЗакрытии = Неопределено, Знач РежимОткрытияОкна = Неопределено) Экспорт
	
	ОткрытьФорму("Справочник.НоменклатураКонтрагентов.Форма.ФормаСписка",
		ПараметрыОтбора, ВладелецФормы, , , , ОповещениеОЗакрытии, РежимОткрытияОкна);

КонецПроцедуры

// Возвращает список актуальной номенклатуры контрагента с учетом фильтра по владельцу, номенклатуре, характеристике, упаковке.
//
// Параметры:
//  ВладелецНоменклатуры - ОпределяемыйТип.ВладелецНоменклатурыБЭД       - владелец, для которого необходимо сформировать список выбора.
//  Номенклатура         - ОпределяемыйТип.НоменклатураБЭД               - номенклатура предприятия для фильтрации номенклатуры контрагента.
//  Характеристика       - ОпределяемыйТип.ХарактеристикаНоменклатурыБЭД - характеристика номенклатуры предприятия
//                                                                         для фильтрации номенклатуры контрагента.
//  Упаковка             - ОпределяемыйТип.УпаковкаНоменклатурыБЭД       - упаковка номенклатуры предприятия
//                                                                         для фильтрации номенклатуры контрагента.
//
// Возвращаемое значение:
//   Массив из СправочникСсылка.НоменклатураКонтрагентов - номенклатура контрагента, подходящая под условия фильтрации.
//
Функция СформироватьСписокВыбораНоменклатурыКонтрагента(Знач ВладелецНоменклатуры, Знач Номенклатура, Знач Характеристика, Знач Упаковка) Экспорт

	Возврат СопоставлениеНоменклатурыКонтрагентовСлужебныйВызовСервера.СформироватьСписокВыбораНоменклатурыКонтрагента(
		ВладелецНоменклатуры, Номенклатура, Характеристика, Упаковка);
	
КонецФункции

#КонецОбласти

//++ Локализация

#Область РаботаСОбработкойСопоставлениеНоменклатурыБЭД

// Открывает форму сопоставления номенклатуры контрагентов и информационной базы.
//
// Параметры:
//  НоменклатураКонтрагентов     - Массив    - набор номенклатуры контрагентов для сопоставления. 
//                                             См. СопоставлениеНоменклатурыКонтрагентовКлиентСервер.НоваяНоменклатураКонтрагента.
//  Настройки                    - Структура - настройки сопоставления номенклатуры:
//   * РазрешитьСохранение - Булево                     - признак разрешения сохранения результатов сопоставления в базе. По умолчанию Истина.
//                                                        Если установить Ложь, то команды сохранения сопоставления будут недоступны.
//                                                        Получить результат сопоставления можно только после закрытия формы
//                                                        в процедуре, указанной через параметр ОповещениеОЗакрытии.
//   * РежимОткрытияОкна   - РежимОткрытияОкнаФормы     - режим открытия формы сопоставления. По умолчанию Независимый.
//   * Заголовок           - Строка                     - заголовок формы сопоставления номенклатуры. По умолчанию "Сопоставление номенклатуры".
//   * ВладелецФормы       - ФормаКлиентскогоПриложения - владелец открываемой формы, которому будет отправлено оповещение о выборе.
//   * ОграничениеТипаНоменклатуры          - ОписаниеТипов - позволяет ограничить типы справочников, используемые при сопоставлении. 
//											  Значение по умолчанию - ОпределяемыйТип.НоменклатураБЭД.
//   * ОтключитьПоискПоНатуральнымКлючам    - Булево - признак отключения поиска соответствий по натуральным ключам. По умолчанию Ложь.
//   * ОтключитьПоискПоШтрихкодамКомбинаций - Булево - признак отключения поиска по штрихкодам. По умолчанию Ложь.
//   * ОтключитьПоискПоСловарю              - Булево - признак отключения поиска по словарю. По умолчанию Ложь.
//   * ТочностьПоискаПоУмолчанию            - Число  - точность поиска по умолчанию. По умолчанию 50.
//   * ВидимостьКолонокСопоставления        - см. СопоставлениеНоменклатурыКонтрагентовКлиентСервер.НовыеНастройкиВидимостиКолонокСопоставления.
//   * ДополнительныеРеквизитыСопоставления - Массив из см. СопоставлениеНоменклатурыКонтрагентовКлиентСервер.НовыйДополнительныйРеквизитСопоставления.
//   * ДополнительныеПараметрыПоиска        - Произвольный - контекст сопоставления, используемый в переопределяемом коде. 
//  ОповещениеОЗакрытии        - ОписаниеОповещения - описание процедуры, которая будет вызвана после закрытии формы с параметрами:
//   * Сопоставление           - Массив, Неопределено - результат сопоставления, состоящий из структур:
//    ** НоменклатураКонтрагента - Структура - номенклатура контрагента. См. СопоставлениеНоменклатурыКонтрагентовКлиентСервер.НоваяНоменклатураКонтрагента.
//    ** НоменклатураИБ          - Структура - номенклатура ИБ. См. СопоставлениеНоменклатурыКонтрагентовКлиентСервер.НоваяНоменклатураИнформационнойБазы.
//   * ДополнительныеПараметры - Произвольный         - значение, которое было указано при создании объекта ОписаниеОповещения.
//
Процедура ОткрытьСопоставлениеНоменклатуры(Знач НоменклатураКонтрагентов, Знач Настройки = Неопределено, Знач ОповещениеОЗакрытии = Неопределено) Экспорт
	
	Если ТипЗнч(НоменклатураКонтрагентов) <> Тип("Массив") Тогда
		НоменклатураКонтрагентов = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(НоменклатураКонтрагентов);
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(НоменклатураКонтрагентов) Тогда
		ТекстСообщения = НСтр("ru = 'Данные для сопоставления номенклатуры отсутствуют.';
								|en = 'Data for product mapping is missing.'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
		Возврат;
	КонецЕсли;
	
	ИсполняемыеНастройки = Новый Структура;
	ИсполняемыеНастройки.Вставить("РазрешитьСохранение", Истина);
	ИсполняемыеНастройки.Вставить("РежимОткрытияОкна"  , РежимОткрытияОкнаФормы.Независимый);
	ИсполняемыеНастройки.Вставить("Заголовок"          , Неопределено);
	ИсполняемыеНастройки.Вставить("ВладелецФормы"      , Неопределено);
	
	ПараметрыФормы = Новый Структура;
	
	Если Настройки <> Неопределено Тогда
		ЗаполнитьЗначенияСвойств(ИсполняемыеНастройки, Настройки);
		
		Если Настройки.Свойство("ОграничениеТипаНоменклатуры") Тогда
			ПараметрыФормы.Вставить("ОграничениеТипаНоменклатуры", Настройки.ОграничениеТипаНоменклатуры);
		КонецЕсли;
		Если Настройки.Свойство("ОтключитьПоискПоНатуральнымКлючам") Тогда
			ПараметрыФормы.Вставить("ОтключитьПоискПоНатуральнымКлючам", Настройки.ОтключитьПоискПоНатуральнымКлючам);
		КонецЕсли;
		Если Настройки.Свойство("ОтключитьПоискПоШтрихкодамКомбинаций") Тогда
			ПараметрыФормы.Вставить("ОтключитьПоискПоШтрихкодамКомбинаций", Настройки.ОтключитьПоискПоШтрихкодамКомбинаций);
		КонецЕсли;
		Если Настройки.Свойство("ОтключитьПоискПоСловарю") Тогда
			ПараметрыФормы.Вставить("ОтключитьПоискПоСловарю", Настройки.ОтключитьПоискПоСловарю);
		КонецЕсли;
		Если Настройки.Свойство("ТочностьПоискаПоУмолчанию") Тогда
			ПараметрыФормы.Вставить("ТочностьПоискаПоУмолчанию", Настройки.ТочностьПоискаПоУмолчанию);
		КонецЕсли;
		Если Настройки.Свойство("ВидимостьКолонокСопоставления") Тогда
			ВидимостьКолонокСопоставления = СопоставлениеНоменклатурыКонтрагентовКлиентСервер.НовыеНастройкиВидимостиКолонокСопоставления();
			ЗаполнитьЗначенияСвойств(ВидимостьКолонокСопоставления, Настройки.ВидимостьКолонокСопоставления);
			ПараметрыФормы.Вставить("ВидимостьКолонокСопоставления", ВидимостьКолонокСопоставления);
		КонецЕсли;
		Если Настройки.Свойство("ДополнительныеРеквизитыСопоставления") Тогда
			ПараметрыФормы.Вставить("ДополнительныеРеквизитыСопоставления", Настройки.ДополнительныеРеквизитыСопоставления);
		КонецЕсли;
		Если Настройки.Свойство("ДополнительныеПараметрыПоиска") Тогда
			ПараметрыФормы.Вставить("ДополнительныеПараметрыПоиска", Настройки.ДополнительныеПараметрыПоиска);
		КонецЕсли;
	КонецЕсли;
	
	ПараметрыФормы.Вставить("НоменклатураКонтрагентов", НоменклатураКонтрагентов);
	ПараметрыФормы.Вставить("РазрешитьСохранение", ИсполняемыеНастройки.РазрешитьСохранение);
	Если ЗначениеЗаполнено(ИсполняемыеНастройки.Заголовок) Тогда
		ПараметрыФормы.Вставить("Заголовок", ИсполняемыеНастройки.Заголовок);
	КонецЕсли;
			
	ОткрытьФорму("Обработка.СопоставлениеНоменклатурыБЭД.Форма.Форма", 
		ПараметрыФормы, ИсполняемыеНастройки.ВладелецФормы, , , , ОповещениеОЗакрытии, ИсполняемыеНастройки.РежимОткрытияОкна);
		
КонецПроцедуры

#КонецОбласти

#Область РаботаСРегистромНоменклатураКонтрагентовБЭД

// Открывает форму выбора регистра сведений номенклатуры контрагента.
// Форма открывается в режиме блокирования окна владельца (параметр ВладелецФормы).
// При осуществлении выбора в форме, владельцу будет отправлено оповещение о выборе со значением, представляющим структуру:
//  * НоменклатураКонтрагента - Структура - выбранная номенклатура контрагента. 
//                                         См. СопоставлениеНоменклатурыКонтрагентовКлиентСервер.НоваяНоменклатураКонтрагента.
//  * НоменклатураИБ - Структура - номенклатура информационной базы, соответствующая выбранной номенклатуре контрагента.
//                                 См. СопоставлениеНоменклатурыКонтрагентовКлиентСервер.НоваяНоменклатураИнформационнойБазы.
//
// Параметры:
//  ВладелецНоменклатуры - ОпределяемыйТип.ВладелецНоменклатурыБЭД - значение для отбора номенклатуры по владельцу.
//  ВладелецФормы - Форма, ФормаКлиентскогоПриложения, ПолеФормы - владелец открываемой формы, которому будет отправлено оповещение о выборе.
//  Идентификатор - Строка - идентификатор номенклатуры, на которой нужно спозиционировать текущую строку списка.
//
Процедура ОткрытьВыборНоменклатурыКонтрагента(Знач ВладелецНоменклатуры, Знач ВладелецФормы, Знач Идентификатор = Неопределено) Экспорт
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Владелец", ВладелецНоменклатуры);
	ПараметрыФормы.Вставить("РежимВыбора", Истина);
	ПараметрыФормы.Вставить("ЗакрыватьПриВыборе", Истина);
	ПараметрыФормы.Вставить("ЗакрыватьПриЗакрытииВладельца", Истина);
	
	Если ЗначениеЗаполнено(Идентификатор) Тогда
		ЗначенияКлюча = Новый Структура("Владелец,Идентификатор", ВладелецНоменклатуры, Идентификатор);
		ПараметрыКлюча = Новый Массив;
		ПараметрыКлюча.Добавить(ЗначенияКлюча);
		КлючЗаписи = Новый(Тип("РегистрСведенийКлючЗаписи.НоменклатураКонтрагентовБЭД"), ПараметрыКлюча);
		ПараметрыФормы.Вставить("ТекущаяСтрока", КлючЗаписи);
	КонецЕсли;
	
	ОткрытьФорму("РегистрСведений.НоменклатураКонтрагентовБЭД.Форма.ФормаВыбора",
		ПараметрыФормы, ВладелецФормы,,,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

// Открывает форму списка регистра сведений номенклатуры контрагентов.
//
Процедура ОткрытьСписокНоменклатурыКонтрагентов() Экспорт
	
	ОткрытьФорму("РегистрСведений.НоменклатураКонтрагентовБЭД.ФормаСписка");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормыДокументов

// Обработчик событий при изменении ключевых реквизитов документа в шапке документа.
//
// Параметры:
//  ФормаДокумента - ФормаКлиентскогоПриложения - форма документа.
//
Процедура ПриИзмененииКлючевыхРеквизитовДокумента(ФормаДокумента) Экспорт
	
	ПараметрыНоменклатурыКонтрагентаБЭД = ФормаДокумента.ПараметрыНоменклатурыКонтрагентаБЭД;
	
	ФормаИнициализирована = Ложь;
	
	Если ПараметрыНоменклатурыКонтрагентаБЭД.ИспользуетсяОбменEDI Тогда
		ОбщийМодульДокументыEDIИнтеграцияКлиентСервер = ОбщегоНазначенияКлиент.ОбщийМодуль("ДокументыEDIИнтеграцияКлиентСервер");
		ФормаИнициализирована = ОбщийМодульДокументыEDIИнтеграцияКлиентСервер.ФормаИнициализирована(ФормаДокумента);
	КонецЕсли;
	
	Если Не ФормаИнициализирована
		Или ЗначениеЗаполнено(ПараметрыНоменклатурыКонтрагентаБЭД.ВариантУказанияНоменклатурыВДокументе) Тогда
		Возврат;
	КонецЕсли;
	
	Объект         = ФормаДокумента.Объект;
	ДокументСсылка = Объект.Ссылка;
	Контрагент     = Объект[ПараметрыНоменклатурыКонтрагентаБЭД.ИмяРеквизитаКонтрагент];
	Организация    = Объект[ПараметрыНоменклатурыКонтрагентаБЭД.ИмяРеквизитаОрганизация];
	
	ПараметрыНоменклатурыКонтрагентаБЭД.ПоследняяНастройкаВариантаУказанияНоменклатуры =
		СопоставлениеНоменклатурыКонтрагентовСлужебныйВызовСервера.ПоследняяНастройкаВариантаУказанияНоменклатуры(ДокументСсылка, Контрагент, Организация);
		
	СопоставлениеНоменклатурыКонтрагентовСлужебныйКлиент.ИзменитьНаФормеДокументаПометкуКомандыУчитыватьНоменклатуруВладельца(ФормаДокумента);
	
КонецПроцедуры

#КонецОбласти

//-- Локализация

#КонецОбласти