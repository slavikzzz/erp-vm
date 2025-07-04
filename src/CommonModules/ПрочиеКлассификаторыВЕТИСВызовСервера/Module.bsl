
#Область ПрограммныйИнтерфейс

#Область ЕдиницыИзмерения

// Возвращает единицу измерения по идентификатору.
//
// Параметры:
//  Идентификатор - ОпределяемыйТип.УникальныйИдентификаторИС - Идентификатор.
//  ПараметрыОбмена - см. ИнтеграцияВЕТИС.ПараметрыОбмена
// Возвращаемое значение:
//  см. ИнтеграцияВЕТИС.ВыполнитьЗапросЭлементаКлассификатора
//
Функция ЕдиницаИзмеренияПоGUID(Идентификатор, ПараметрыОбмена = Неопределено) Экспорт
	
	Запрос = ЗапросЭлементаКлассификатораЕдиницИзмеренияПоИдентификаторуXML(
		ИнтеграцияВЕТИС.ИмяИдентификатораОбъекта(), Идентификатор);
	
	РезультатВыполненияЗапроса = ИнтеграцияВЕТИС.ВыполнитьЗапросЭлементаКлассификатора(Запрос,, ПараметрыОбмена);
	
	Возврат РезультатВыполненияЗапроса;
	
КонецФункции

// Возвращает единицу измерения по идентификатору.
//
// Параметры:
//  Идентификатор - ОпределяемыйТип.УникальныйИдентификаторИС - Идентификатор.
//  ПараметрыОбмена - см. ИнтеграцияВЕТИС.ПараметрыОбмена
// Возвращаемое значение:
// см. ИнтеграцияВЕТИС.ВыполнитьЗапросЭлементаКлассификатора
//
Функция ЕдиницаИзмеренияПоUUID(Идентификатор, ПараметрыОбмена = Неопределено) Экспорт
	
	Запрос = ЗапросЭлементаКлассификатораЕдиницИзмеренияПоИдентификаторуXML(
		ИнтеграцияВЕТИС.ИмяИдентификатораВерсии(), Идентификатор);
	
	РезультатВыполненияЗапроса = ИнтеграцияВЕТИС.ВыполнитьЗапросЭлементаКлассификатора(Запрос,, ПараметрыОбмена);
	
	Возврат РезультатВыполненияЗапроса;
	
КонецФункции

// Возвращает список единиц измерения.
//
// Параметры:
//  НомерСтраницы - Число - Номер страницы.
//  ХозяйствующийСубъект - СправочникСсылка.ХозяйствующиеСубъектыВЕТИС
//
// Возвращаемое значение:
//  см. ИнтеграцияВЕТИС.ВыполнитьЗапросЭлементовКлассификатора
//
Функция СписокЕдиницИзмерения(НомерСтраницы = 1, ХозяйствующийСубъект = Неопределено) Экспорт
	
	Запрос = ЗапросЭлементовКлассификатораЕдиницИзмеренияXML(НомерСтраницы);
	
	РезультатВыполненияЗапроса = ИнтеграцияВЕТИС.ВыполнитьЗапросЭлементовКлассификатора(Запрос, ХозяйствующийСубъект);
	
	Возврат РезультатВыполненияЗапроса;
	
КонецФункции

// Возвращает список измененных за период элементов единиц измерения.
//
// Параметры:
//  Интервал - Структура - Структура со свойствами:
// * НачалоПериода - Дата - Дата начала периода.
// * КонецПериода - Дата - Дата окончания периода.
//  НомерСтраницы - Число - Номер страницы.
//  КоличествоЭлементовНаСтранице - Неопределено - Количество элементов на странице
//  ПараметрыОбмена - Неопределено - Параметры обмена
//
// Возвращаемое значение:
// см. ИнтеграцияВЕТИС.ВыполнитьЗапросЭлементовКлассификатора
//
Функция ИсторияИзмененийЕдиницИзмерения(Интервал, НомерСтраницы = 1,
	КоличествоЭлементовНаСтранице = Неопределено, ПараметрыОбмена = Неопределено) Экспорт
	
	Запрос = ЗапросИзмененныхЭлементовКлассификатораЕдиницИзмеренияXML(Интервал, НомерСтраницы, КоличествоЭлементовНаСтранице);
	
	РезультатВыполненияЗапроса = ИнтеграцияВЕТИС.ВыполнитьЗапросЭлементовКлассификатора(Запрос,, ПараметрыОбмена);
	
	Возврат РезультатВыполненияЗапроса;
	
КонецФункции

// Возвращает таблицу доступных единиц измерения для различных видов продукции.
// 
// Возвращаемое значение:
//  ТаблицаЗначений - Единицы измерения продукции:
// * ТипПродукцииGUID - ОпределяемыйТип.УникальныйИдентификаторИС
// * ТипПродукции - ОпределяемыйТип.СтрокаВЕТИС
// * ПродукцияGUID - ОпределяемыйТип.УникальныйИдентификаторИС
// * Продукция - ОпределяемыйТип.СтрокаВЕТИС
// * ВидПродукцииGUID - ОпределяемыйТип.УникальныйИдентификаторИС
// * ВидПродукции - ОпределяемыйТип.СтрокаВЕТИС
// * ГруппаЕдиницИзмерения - ОпределяемыйТип.СтрокаВЕТИС
// * ЕдиницаИзмеренияGUID - ОпределяемыйТип.УникальныйИдентификаторИС
// * ЕдиницаИзмерения - ОпределяемыйТип.СтрокаВЕТИС
// * ЕдиницаИзмеренияСсылка - СправочникСсылка.ЕдиницыИзмеренияВЕТИС - 
Функция ЕдиницыИзмеренияПродукции() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	Т.Ссылка КАК Ссылка,
	|	Т.Идентификатор КАК Идентификатор
	|ИЗ
	|	Справочник.ЕдиницыИзмеренияВЕТИС КАК Т";
	
	ТаблицаСсылок = Запрос.Выполнить().Выгрузить();
	
	Таблица = Новый ТаблицаЗначений;
	Таблица.Колонки.Добавить("ТипПродукцииGUID",       Метаданные.ОпределяемыеТипы.УникальныйИдентификаторИС.Тип);
	Таблица.Колонки.Добавить("ТипПродукции",           Метаданные.ОпределяемыеТипы.СтрокаВЕТИС.Тип);
	Таблица.Колонки.Добавить("ПродукцияGUID",          Метаданные.ОпределяемыеТипы.УникальныйИдентификаторИС.Тип);
	Таблица.Колонки.Добавить("Продукция",              Метаданные.ОпределяемыеТипы.СтрокаВЕТИС.Тип);
	Таблица.Колонки.Добавить("ВидПродукцииGUID",       Метаданные.ОпределяемыеТипы.УникальныйИдентификаторИС.Тип);
	Таблица.Колонки.Добавить("ВидПродукции",           Метаданные.ОпределяемыеТипы.СтрокаВЕТИС.Тип);
	Таблица.Колонки.Добавить("ГруппаЕдиницИзмерения",  Метаданные.ОпределяемыеТипы.СтрокаВЕТИС.Тип);
	Таблица.Колонки.Добавить("ЕдиницаИзмеренияGUID",   Метаданные.ОпределяемыеТипы.УникальныйИдентификаторИС.Тип);
	Таблица.Колонки.Добавить("ЕдиницаИзмерения",       Метаданные.ОпределяемыеТипы.СтрокаВЕТИС.Тип);
	Таблица.Колонки.Добавить("ЕдиницаИзмеренияСсылка", Новый ОписаниеТипов("СправочникСсылка.ЕдиницыИзмеренияВЕТИС"));
	
	Макет = Обработки.КлассификаторыВЕТИС.ПолучитьМакет("КлассификаторЕдиницыИзмеренияПродукции");
	КоличествоСтрок = Макет.ВысотаТаблицы;
	
	Для НомерСтроки = 2 По КоличествоСтрок Цикл
		
		ЕдиницаИзмеренияGUID = СокрЛП(Макет.Область("R" + НомерСтроки + "C9" ).Текст);
		НайденнаяСтрока      = ТаблицаСсылок.Найти(ЕдиницаИзмеренияGUID, "Идентификатор");
		
		Если ЗначениеЗаполнено(НайденнаяСтрока) Тогда
			ЕдиницаИзмеренияСсылка = НайденнаяСтрока.Ссылка;
		ИначеЕсли ПравоДоступа("Добавление", Метаданные.Справочники.ЕдиницыИзмеренияВЕТИС) Тогда
			ЕдиницаИзмеренияСсылка = ИнтеграцияВЕТИС.ЕдиницаИзмерения(ЕдиницаИзмеренияGUID, Неопределено);
		Иначе
			Продолжить;
		КонецЕсли;
		
		НоваяСтрока = Таблица.Добавить();
		
		НоваяСтрока.ЕдиницаИзмеренияGUID   = ЕдиницаИзмеренияGUID;
		НоваяСтрока.ЕдиницаИзмеренияСсылка = ЕдиницаИзмеренияСсылка;
		
		НоваяСтрока.ТипПродукцииGUID       = СокрЛП(Макет.Область("R" + НомерСтроки + "C2" ).Текст);
		НоваяСтрока.ТипПродукции           = СокрЛП(Макет.Область("R" + НомерСтроки + "C3" ).Текст);
		НоваяСтрока.ПродукцияGUID          = СокрЛП(Макет.Область("R" + НомерСтроки + "C4" ).Текст);
		НоваяСтрока.Продукция              = СокрЛП(Макет.Область("R" + НомерСтроки + "C5" ).Текст);
		НоваяСтрока.ВидПродукцииGUID       = СокрЛП(Макет.Область("R" + НомерСтроки + "C6" ).Текст);
		НоваяСтрока.ВидПродукции           = СокрЛП(Макет.Область("R" + НомерСтроки + "C7" ).Текст);
		НоваяСтрока.ГруппаЕдиницИзмерения  = СокрЛП(Макет.Область("R" + НомерСтроки + "C8" ).Текст);
		НоваяСтрока.ЕдиницаИзмерения       = СокрЛП(Макет.Область("R" + НомерСтроки + "C10").Текст);
		
	КонецЦикла;
	
	Таблица.Индексы.Добавить("ТипПродукцииGUID,ПродукцияGUID,ВидПродукцииGUID");
	
	Возврат Таблица;
	
КонецФункции

#КонецОбласти

#Область Цели

// Возвращает назначение груза по идентификатору.
//
// Параметры:
//  Идентификатор - ОпределяемыйТип.УникальныйИдентификаторИС - Идентификатор.
//  ПараметрыОбмена - см. ИнтеграцияВЕТИС.ПараметрыОбмена
// Возвращаемое значение:
//  см. ИнтеграцияВЕТИС.ВыполнитьЗапросЭлементаКлассификатора
//
Функция ЦельПоGUID(Идентификатор, ПараметрыОбмена = Неопределено) Экспорт
	
	Запрос = ЗапросЭлементаКлассификатораЦелейПоИдентификаторуXML(
		ИнтеграцияВЕТИС.ИмяИдентификатораОбъекта(), Идентификатор);
	
	РезультатВыполненияЗапроса = ИнтеграцияВЕТИС.ВыполнитьЗапросЭлементаКлассификатора(Запрос,, ПараметрыОбмена);
	
	Возврат РезультатВыполненияЗапроса;
	
КонецФункции

// Возвращает цель по идентификатору.
//
// Параметры:
//  Идентификатор - ОпределяемыйТип.УникальныйИдентификаторИС - Идентификатор.
//  ПараметрыОбмена - см. ИнтеграцияВЕТИС.ПараметрыОбмена
// Возвращаемое значение:
//  см. ИнтеграцияВЕТИС.ВыполнитьЗапросЭлементаКлассификатора
//
Функция ЦельПоUUID(Идентификатор, ПараметрыОбмена = Неопределено) Экспорт
	
	Запрос = ЗапросЭлементаКлассификатораЦелейПоИдентификаторуXML(
		ИнтеграцияВЕТИС.ИмяИдентификатораВерсии(), Идентификатор);
	
	РезультатВыполненияЗапроса = ИнтеграцияВЕТИС.ВыполнитьЗапросЭлементаКлассификатора(Запрос,, ПараметрыОбмена);
	
	Возврат РезультатВыполненияЗапроса;
	
КонецФункции

// Возвращает список целей.
//
// Параметры:
//  НомерСтраницы - Число - Номер страницы.
//
// Возвращаемое значение:
// см. ИнтеграцияВЕТИС.ВыполнитьЗапросЭлементовКлассификатора
//
Функция СписокЦелей(НомерСтраницы = 1) Экспорт
	
	Запрос = ЗапросЭлементовКлассификатораЦелейXML(НомерСтраницы);
	
	РезультатВыполненияЗапроса = ИнтеграцияВЕТИС.ВыполнитьЗапросЭлементовКлассификатора(Запрос);
	
	Возврат РезультатВыполненияЗапроса;
	
КонецФункции

// Возвращает список измененных за период целей.
//
// Параметры:
//  Интервал - Структура - Структура со свойствами:
// * НачалоПериода - Дата - Дата начала периода.
// * КонецПериода - Дата - Дата окончания периода.
//  НомерСтраницы - Число - Номер страницы.
//  КоличествоЭлементовНаСтранице - Неопределено - Количество элементов на странице
//  ПараметрыОбмена - см. ИнтеграцияВЕТИС.ПараметрыОбмена
//
// Возвращаемое значение:
// см. ИнтеграцияВЕТИС.ВыполнитьЗапросЭлементовКлассификатора
//
Функция ИсторияИзмененийЦелей(Интервал, НомерСтраницы = 1,
	КоличествоЭлементовНаСтранице = Неопределено, ПараметрыОбмена = Неопределено) Экспорт
	
	Запрос = ЗапросИзмененныхЭлементовКлассификатораЦелейXML(Интервал, НомерСтраницы, КоличествоЭлементовНаСтранице);
	
	РезультатВыполненияЗапроса = ИнтеграцияВЕТИС.ВыполнитьЗапросЭлементовКлассификатора(Запрос,, ПараметрыОбмена);
	
	Возврат РезультатВыполненияЗапроса;
	
КонецФункции

#КонецОбласти

#Область ОрганизационноПравовыеФормы

// Организационно правовые формы.
// 
// Возвращаемое значение:
//  ТаблицаЗначений - Организационно правовые формы:
// * Код - ОпределяемыйТип.СтрокаВЕТИС
// * GUID - ОпределяемыйТип.УникальныйИдентификаторИС
// * Наименование - ОпределяемыйТип.СтрокаВЕТИС
Функция ОрганизационноПравовыеФормы() Экспорт
	
	Таблица = Новый ТаблицаЗначений;
	Таблица.Колонки.Добавить("Код",          Метаданные.ОпределяемыеТипы.СтрокаВЕТИС.Тип);
	Таблица.Колонки.Добавить("GUID",         Метаданные.ОпределяемыеТипы.УникальныйИдентификаторИС.Тип);
	Таблица.Колонки.Добавить("Наименование", Метаданные.ОпределяемыеТипы.СтрокаВЕТИС.Тип);
	
	Макет = Обработки.КлассификаторыВЕТИС.ПолучитьМакет("КлассификаторОКОНХ");
	КоличествоСтрок = Макет.ВысотаТаблицы;
	
	Для НомерСтроки = 2 По КоличествоСтрок Цикл
		
		НоваяСтрока = Таблица.Добавить();
		
		НоваяСтрока.Код          = СокрЛП(Макет.Область("R" + НомерСтроки + "C1").Текст);
		НоваяСтрока.GUID         = СокрЛП(Макет.Область("R" + НомерСтроки + "C2").Текст);
		НоваяСтрока.Наименование = СокрЛП(Макет.Область("R" + НомерСтроки + "C3").Текст);
		
	КонецЦикла;
	
	Возврат Таблица;
	
КонецФункции

#КонецОбласти

#Область ВидыДеятельностиПредприятий

// Виды деятельности предприятий.
// 
// Возвращаемое значение:
//  ТаблицаЗначений - Виды деятельности предприятий:
// * GUID - ОпределяемыйТип.УникальныйИдентификаторИС
// * Наименование - ОпределяемыйТип.СтрокаВЕТИС
Функция ВидыДеятельностиПредприятий() Экспорт
	
	Таблица = Новый ТаблицаЗначений;
	Таблица.Колонки.Добавить("GUID",         Метаданные.ОпределяемыеТипы.УникальныйИдентификаторИС.Тип);
	Таблица.Колонки.Добавить("Наименование", Метаданные.ОпределяемыеТипы.СтрокаВЕТИС.Тип);
	
	Макет = Обработки.КлассификаторыВЕТИС.ПолучитьМакет("КлассификаторВидовДеятельностиПредприятий");
	КоличествоСтрок = Макет.ВысотаТаблицы;
	
	Для НомерСтроки = 2 По КоличествоСтрок Цикл
		
		НоваяСтрока = Таблица.Добавить();
		
		НоваяСтрока.GUID         = СокрЛП(Макет.Область("R" + НомерСтроки + "C1").Текст);
		НоваяСтрока.Наименование = СокрЛП(Макет.Область("R" + НомерСтроки + "C2").Текст);
		
	КонецЦикла;
	
	Возврат Таблица;
	
КонецФункции

#КонецОбласти

#Область СтраныМира

// Страны мира.
// 
// Возвращаемое значение:
//  ТаблицаЗначений - Страны мира:
// * КодАльфа2  - ОпределяемыйТип.СтрокаВЕТИС
// * КодАльфа3 - ОпределяемыйТип.СтрокаВЕТИС
// * GUID - ОпределяемыйТип.УникальныйИдентификаторИС
// * Наименование - ОпределяемыйТип.СтрокаВЕТИС 
Функция СтраныМира() Экспорт
	
	Таблица = Новый ТаблицаЗначений;
	Таблица.Колонки.Добавить("КодАльфа2",    Метаданные.ОпределяемыеТипы.СтрокаВЕТИС.Тип);
	Таблица.Колонки.Добавить("КодАльфа3",    Метаданные.ОпределяемыеТипы.СтрокаВЕТИС.Тип);
	Таблица.Колонки.Добавить("GUID",         Метаданные.ОпределяемыеТипы.УникальныйИдентификаторИС.Тип);
	Таблица.Колонки.Добавить("Наименование", Метаданные.ОпределяемыеТипы.СтрокаВЕТИС.Тип);
	
	Макет = Обработки.КлассификаторыВЕТИС.ПолучитьМакет("КлассификаторСтранМира");
	КоличествоСтрок = Макет.ВысотаТаблицы;
	
	Для НомерСтроки = 2 По КоличествоСтрок Цикл
		
		НоваяСтрока = Таблица.Добавить();
		
		НоваяСтрока.КодАльфа2    = СокрЛП(Макет.Область("R" + НомерСтроки + "C1").Текст);
		НоваяСтрока.КодАльфа3    = СокрЛП(Макет.Область("R" + НомерСтроки + "C2").Текст);
		НоваяСтрока.GUID         = СокрЛП(Макет.Область("R" + НомерСтроки + "C3").Текст);
		НоваяСтрока.Наименование = СокрЛП(Макет.Область("R" + НомерСтроки + "C4").Текст);
		
	КонецЦикла;
	
	Возврат Таблица;
	
КонецФункции

// Данные страны мира.
// 
// Параметры:
//  Страна - СправочникСсылка.СтраныМира
//  СтраныМира - СправочникСсылка.СтраныМира - Страны мира
// 
// Возвращаемое значение:
//  Структура - Данные страны мира:
// * Идентификатор - ОпределяемыйТип.УникальныйИдентификаторИС - 
// * Наименование - ОпределяемыйТип.СтрокаВЕТИС - 
Функция ДанныеСтраныМира(Страна, СтраныМира = Неопределено) Экспорт
	
	КодАльфа2 = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Страна, "КодАльфа2");
	
	Если СтраныМира = Неопределено Тогда
		ТаблицаСтранМира = СтраныМира();
	Иначе
		ТаблицаСтранМира = СтраныМира;
	КонецЕсли;
	
	СтрокаТЧ = ТаблицаСтранМира.Найти(КодАльфа2, "КодАльфа2");
	
	Если СтрокаТЧ = Неопределено Тогда
		ВызватьИсключение НСтр("ru = 'Внутренняя ошибка поиска данных стран мира';
								|en = 'Внутренняя ошибка поиска данных стран мира'");
	КонецЕсли;
	
	ВозвращаемоеЗначение = Новый Структура;
	ВозвращаемоеЗначение.Вставить("Идентификатор", СтрокаТЧ.GUID);
	ВозвращаемоеЗначение.Вставить("Наименование",  СтрокаТЧ.Наименование);
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

#КонецОбласти

#Область Заболевания

// Возвращает назначение груза по идентификатору.
//
// Параметры:
//  Идентификатор - ОпределяемыйТип.УникальныйИдентификаторИС - Идентификатор.
//  ПараметрыОбмена - см. ИнтеграцияВЕТИС.ПараметрыОбмена
// Возвращаемое значение:
//  см. ИнтеграцияВЕТИС.ВыполнитьЗапросЭлементаКлассификатора
//
Функция ЗаболеваниеПоGUID(Идентификатор, ПараметрыОбмена = Неопределено) Экспорт
	
	Запрос = ЗапросЭлементаКлассификатораЗаболеванийПоИдентификаторуXML(
		ИнтеграцияВЕТИС.ИмяИдентификатораОбъекта(), Идентификатор);
		
	РезультатВыполненияЗапроса = ИнтеграцияВЕТИС.ВыполнитьЗапросЭлементаКлассификатора(Запрос,, ПараметрыОбмена);
	
	Возврат РезультатВыполненияЗапроса;
	
КонецФункции

// Возвращает цель по идентификатору.
//
// Параметры:
//  Идентификатор - ОпределяемыйТип.УникальныйИдентификаторИС - Идентификатор.
//  ПараметрыОбмена - см. ИнтеграцияВЕТИС.ПараметрыОбмена
// Возвращаемое значение:
//  см. ИнтеграцияВЕТИС.ВыполнитьЗапросЭлементаКлассификатора
//
Функция ЗаболеваниеПоUUID(Идентификатор, ПараметрыОбмена = Неопределено) Экспорт
	
	Запрос = ЗапросЭлементаКлассификатораЗаболеванийПоИдентификаторуXML(
		ИнтеграцияВЕТИС.ИмяИдентификатораВерсии(), Идентификатор);
	
	РезультатВыполненияЗапроса = ИнтеграцияВЕТИС.ВыполнитьЗапросЭлементаКлассификатора(Запрос,, ПараметрыОбмена);
	
	Возврат РезультатВыполненияЗапроса;
	
КонецФункции

// Возвращает список заболеваний.
//
// Параметры:
//  НомерСтраницы - Число - Номер страницы.
//
// Возвращаемое значение:
//  см. ИнтеграцияВЕТИС.ВыполнитьЗапросЭлементаКлассификатора
//
Функция СписокЗаболеваний(НомерСтраницы = 1) Экспорт
	
	Запрос = ЗапросЭлементовКлассификатораЗаболеванийXML(НомерСтраницы);
	
	РезультатВыполненияЗапроса = ИнтеграцияВЕТИС.ВыполнитьЗапросЭлементовКлассификатора(Запрос);
	
	Возврат РезультатВыполненияЗапроса;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ЗапросЭлементаКлассификатораЕдиницИзмеренияПоИдентификаторуXML(ИмяИдентификатора, ЗначениеИдентификатора)
	
	ПараметрыЗапроса = ИнтеграцияВЕТИСКлиентСервер.ПараметрыЗапросаЭлементаКлассификатора();
	ПараметрыЗапроса.ИмяМетода        = "getUnitBy" + ТРег(ИмяИдентификатора);
	ПараметрыЗапроса.ПространствоИмен = Метаданные.ПакетыXDTO.СправочникиВЕТИС.ПространствоИмен;
	ПараметрыЗапроса.Сервис           = Перечисления.СервисыВЕТИС.ПрочиеКлассификаторы;
	ПараметрыЗапроса.ИмяЭлемента      = "unit";
	ПараметрыЗапроса.Представление    = СтрШаблон(НСтр("ru = 'запрос единицы измерения по идентификатору %1 %2';
														|en = 'запрос единицы измерения по идентификатору %1 %2'"), ИмяИдентификатора, ЗначениеИдентификатора);
	
	#Область ТекстаСообщенияXML
	
	ИмяМетода        = ПараметрыЗапроса.ИмяМетода;
	ПространствоИмен = ПараметрыЗапроса.ПространствоИмен;
	
	ИмяПакета = ИмяМетода + "Request";
	
	Запрос = РаботаСXMLИС.ОбъектXDTOПоИмениСвойства(ПространствоИмен, ИмяПакета);
	Запрос[ИмяИдентификатора] = ЗначениеИдентификатора;
	
	ТекстСообщенияXML = ИнтеграцияВЕТИС.ОбъектXDTOВXML(Запрос, ПространствоИмен, ИмяПакета);
	
	#КонецОбласти
	
	ПараметрыЗапроса.ТекстСообщенияXML = ТекстСообщенияXML;
	
	Возврат ПараметрыЗапроса;
	
КонецФункции

Функция ЗапросЭлементовКлассификатораЕдиницИзмеренияXML(НомерСтраницы, КоличествоЭлементовНаСтранице = Неопределено)
	
	ПараметрыЗапроса = ИнтеграцияВЕТИСКлиентСервер.ПараметрыЗапросаЭлементовКлассификатора();
	ПараметрыЗапроса.ИмяМетода        = "getUnitList";
	ПараметрыЗапроса.ПространствоИмен = Метаданные.ПакетыXDTO.СправочникиВЕТИС.ПространствоИмен;
	ПараметрыЗапроса.Сервис           = Перечисления.СервисыВЕТИС.ПрочиеКлассификаторы;
	ПараметрыЗапроса.НомерСтраницы    = НомерСтраницы;
	ПараметрыЗапроса.ИмяЭлемента      = "unit";
	ПараметрыЗапроса.ИмяСписка        = "unitList";
	ПараметрыЗапроса.Представление    = НСтр("ru = 'запрос списка единиц измерения';
											|en = 'запрос списка единиц измерения'");
	
	Если КоличествоЭлементовНаСтранице = Неопределено Тогда
		КоличествоЭлементовНаСтранице = ИнтеграцияВЕТИСКлиентСервер.РазмерСтраницы();
	КонецЕсли;
	ПараметрыЗапроса.КоличествоЭлементовНаСтранице = КоличествоЭлементовНаСтранице;
	
	#Область ТекстаСообщенияXML
	
	ИмяМетода        = ПараметрыЗапроса.ИмяМетода;
	ПространствоИмен = ПараметрыЗапроса.ПространствоИмен;
	
	ИмяПакета = ИмяМетода + "Request";
	
	Запрос = РаботаСXMLИС.ОбъектXDTOПоИмениСвойства(ПространствоИмен, ИмяПакета);
	
	ИнтеграцияВЕТИС.УстановитьПараметрыСтраницы(Запрос, НомерСтраницы);
	
	ТекстСообщенияXML = ИнтеграцияВЕТИС.ОбъектXDTOВXML(Запрос, ПространствоИмен, ИмяПакета);
	
	#КонецОбласти
	
	ПараметрыЗапроса.ТекстСообщенияXML = ТекстСообщенияXML;
	
	Возврат ПараметрыЗапроса;
	
КонецФункции

Функция ЗапросИзмененныхЭлементовКлассификатораЕдиницИзмеренияXML(Интервал, НомерСтраницы, КоличествоЭлементовНаСтранице = Неопределено)
	
	ПараметрыЗапроса = ИнтеграцияВЕТИСКлиентСервер.ПараметрыЗапросаЭлементовКлассификатора();
	ПараметрыЗапроса.ИмяМетода        = "getUnitChangesList";
	ПараметрыЗапроса.ПространствоИмен = Метаданные.ПакетыXDTO.СправочникиВЕТИС.ПространствоИмен;
	ПараметрыЗапроса.Сервис           = Перечисления.СервисыВЕТИС.ПрочиеКлассификаторы;
	ПараметрыЗапроса.НомерСтраницы    = НомерСтраницы;
	ПараметрыЗапроса.ИмяЭлемента      = "unit";
	ПараметрыЗапроса.ИмяСписка        = "unitList";
	ПараметрыЗапроса.Представление    = НСтр("ru = 'запрос измененных элементов единиц измерения';
											|en = 'запрос измененных элементов единиц измерения'");
	
	Если КоличествоЭлементовНаСтранице = Неопределено Тогда
		КоличествоЭлементовНаСтранице = ИнтеграцияВЕТИСКлиентСервер.РазмерСтраницы();
	КонецЕсли;
	ПараметрыЗапроса.КоличествоЭлементовНаСтранице = КоличествоЭлементовНаСтранице;
	
	#Область ТекстаСообщенияXML
	
	ХранилищеВременныхДат = Новый Соответствие;
	
	ИмяМетода        = ПараметрыЗапроса.ИмяМетода;
	ПространствоИмен = ПараметрыЗапроса.ПространствоИмен;
	
	ИмяПакета = ИмяМетода + "Request";
	
	Запрос = РаботаСXMLИС.ОбъектXDTOПоИмениСвойства(ПространствоИмен, ИмяПакета);
	
	ИнтеграцияВЕТИС.УстановитьПараметрыСтраницы(Запрос, НомерСтраницы, КоличествоЭлементовНаСтранице);
	
	ИнтеграцияВЕТИС.УстановитьИнтервалЗапросаИзменений(Запрос, Интервал, ХранилищеВременныхДат);
	
	ТекстСообщенияXML = ИнтеграцияВЕТИС.ОбъектXDTOВXML(Запрос, ПространствоИмен, ИмяПакета);
	ТекстСообщенияXML = ИнтеграцияИС.ПреобразоватьВременныеДаты(ХранилищеВременныхДат, ТекстСообщенияXML);
	
	#КонецОбласти
	
	ПараметрыЗапроса.ТекстСообщенияXML = ТекстСообщенияXML;
	
	Возврат ПараметрыЗапроса;
	
КонецФункции


Функция ЗапросЭлементаКлассификатораЦелейПоИдентификаторуXML(ИмяИдентификатора, ЗначениеИдентификатора)
	
	ПараметрыЗапроса = ИнтеграцияВЕТИСКлиентСервер.ПараметрыЗапросаЭлементаКлассификатора();
	ПараметрыЗапроса.ИмяМетода        = "getPurposeBy" + ТРег(ИмяИдентификатора);
	ПараметрыЗапроса.ПространствоИмен = Метаданные.ПакетыXDTO.СправочникиВЕТИС.ПространствоИмен;
	ПараметрыЗапроса.Сервис           = Перечисления.СервисыВЕТИС.ПрочиеКлассификаторы;
	ПараметрыЗапроса.ИмяЭлемента      = "purpose";
	ПараметрыЗапроса.Представление    = СтрШаблон(НСтр("ru = 'запрос цели по идентификатору %1 %2';
														|en = 'запрос цели по идентификатору %1 %2'"), ИмяИдентификатора, ЗначениеИдентификатора);
	
	#Область ТекстаСообщенияXML
	
	ИмяМетода        = ПараметрыЗапроса.ИмяМетода;
	ПространствоИмен = ПараметрыЗапроса.ПространствоИмен;
	
	ИмяПакета = ИмяМетода + "Request";
	
	Запрос = РаботаСXMLИС.ОбъектXDTOПоИмениСвойства(ПространствоИмен, ИмяПакета);
	Запрос[ИмяИдентификатора] = ЗначениеИдентификатора;
	
	ТекстСообщенияXML = ИнтеграцияВЕТИС.ОбъектXDTOВXML(Запрос, ПространствоИмен, ИмяПакета);
	
	#КонецОбласти
	
	ПараметрыЗапроса.ТекстСообщенияXML = ТекстСообщенияXML;
	
	Возврат ПараметрыЗапроса;
	
КонецФункции

Функция ЗапросЭлементовКлассификатораЦелейXML(НомерСтраницы, КоличествоЭлементовНаСтранице = Неопределено)
	
	ПараметрыЗапроса = ИнтеграцияВЕТИСКлиентСервер.ПараметрыЗапросаЭлементовКлассификатора();
	ПараметрыЗапроса.ИмяМетода        = "getPurposeList";
	ПараметрыЗапроса.ПространствоИмен = Метаданные.ПакетыXDTO.СправочникиВЕТИС.ПространствоИмен;
	ПараметрыЗапроса.Сервис           = Перечисления.СервисыВЕТИС.ПрочиеКлассификаторы;
	ПараметрыЗапроса.НомерСтраницы    = НомерСтраницы;
	ПараметрыЗапроса.ИмяЭлемента      = "purpose";
	ПараметрыЗапроса.ИмяСписка        = "purposeList";
	ПараметрыЗапроса.Представление    = НСтр("ru = 'запрос списка целей';
											|en = 'запрос списка целей'");
	
	Если КоличествоЭлементовНаСтранице = Неопределено Тогда
		КоличествоЭлементовНаСтранице = ИнтеграцияВЕТИСКлиентСервер.РазмерСтраницы();
	КонецЕсли;
	ПараметрыЗапроса.КоличествоЭлементовНаСтранице = КоличествоЭлементовНаСтранице;
	
	#Область ТекстаСообщенияXML
	
	ИмяМетода        = ПараметрыЗапроса.ИмяМетода;
	ПространствоИмен = ПараметрыЗапроса.ПространствоИмен;
	
	ИмяПакета = ИмяМетода + "Request";
	
	Запрос = РаботаСXMLИС.ОбъектXDTOПоИмениСвойства(ПространствоИмен, ИмяПакета);
	
	ИнтеграцияВЕТИС.УстановитьПараметрыСтраницы(Запрос, НомерСтраницы);
	
	ТекстСообщенияXML = ИнтеграцияВЕТИС.ОбъектXDTOВXML(Запрос, ПространствоИмен, ИмяПакета);
	
	#КонецОбласти
	
	ПараметрыЗапроса.ТекстСообщенияXML = ТекстСообщенияXML;
	
	Возврат ПараметрыЗапроса;
	
КонецФункции

Функция ЗапросИзмененныхЭлементовКлассификатораЦелейXML(Интервал, НомерСтраницы, КоличествоЭлементовНаСтранице = Неопределено)
	
	ПараметрыЗапроса = ИнтеграцияВЕТИСКлиентСервер.ПараметрыЗапросаЭлементовКлассификатора();
	ПараметрыЗапроса.ИмяМетода        = "getPurposeChangesList";
	ПараметрыЗапроса.ПространствоИмен = Метаданные.ПакетыXDTO.СправочникиВЕТИС.ПространствоИмен;
	ПараметрыЗапроса.Сервис           = Перечисления.СервисыВЕТИС.ПрочиеКлассификаторы;
	ПараметрыЗапроса.НомерСтраницы    = НомерСтраницы;
	ПараметрыЗапроса.ИмяЭлемента      = "purpose";
	ПараметрыЗапроса.ИмяСписка        = "purposeList";
	ПараметрыЗапроса.Представление    = НСтр("ru = 'запрос измененных элементов списка целей';
											|en = 'запрос измененных элементов списка целей'");
	
	Если КоличествоЭлементовНаСтранице = Неопределено Тогда
		КоличествоЭлементовНаСтранице = ИнтеграцияВЕТИСКлиентСервер.РазмерСтраницы();
	КонецЕсли;
	ПараметрыЗапроса.КоличествоЭлементовНаСтранице = КоличествоЭлементовНаСтранице;
	
	#Область ТекстаСообщенияXML
	
	ХранилищеВременныхДат = Новый Соответствие;
	
	ИмяМетода        = ПараметрыЗапроса.ИмяМетода;
	ПространствоИмен = ПараметрыЗапроса.ПространствоИмен;
	
	ИмяПакета = ИмяМетода + "Request";
	
	Запрос = РаботаСXMLИС.ОбъектXDTOПоИмениСвойства(ПространствоИмен, ИмяПакета);
	
	ИнтеграцияВЕТИС.УстановитьПараметрыСтраницы(Запрос, НомерСтраницы, КоличествоЭлементовНаСтранице);
	
	ИнтеграцияВЕТИС.УстановитьИнтервалЗапросаИзменений(Запрос, Интервал, ХранилищеВременныхДат);
	
	ТекстСообщенияXML = ИнтеграцияВЕТИС.ОбъектXDTOВXML(Запрос, ПространствоИмен, ИмяПакета);
	ТекстСообщенияXML = ИнтеграцияИС.ПреобразоватьВременныеДаты(ХранилищеВременныхДат, ТекстСообщенияXML);
	
	#КонецОбласти
	
	ПараметрыЗапроса.ТекстСообщенияXML = ТекстСообщенияXML;
	
	Возврат ПараметрыЗапроса;
	
КонецФункции

Функция ЗапросЭлементаКлассификатораЗаболеванийПоИдентификаторуXML(ИмяИдентификатора, ЗначениеИдентификатора)
	
	ПараметрыЗапроса = ИнтеграцияВЕТИСКлиентСервер.ПараметрыЗапросаЭлементаКлассификатора();
	ПараметрыЗапроса.ИмяМетода        = "getDiseaseBy" + ТРег(ИмяИдентификатора);
	ПараметрыЗапроса.ПространствоИмен = Метаданные.ПакетыXDTO.СправочникиВЕТИС.ПространствоИмен;
	ПараметрыЗапроса.Сервис           = Перечисления.СервисыВЕТИС.ПрочиеКлассификаторы;
	ПараметрыЗапроса.ИмяЭлемента      = "disease";
	ПараметрыЗапроса.Представление    = СтрШаблон(НСтр("ru = 'запрос заболевания по идентификатору %1 %2';
														|en = 'запрос заболевания по идентификатору %1 %2'"), ИмяИдентификатора, ЗначениеИдентификатора);
	
	#Область ТекстаСообщенияXML
	
	ИмяМетода        = ПараметрыЗапроса.ИмяМетода;
	ПространствоИмен = ПараметрыЗапроса.ПространствоИмен;
	
	ИмяПакета = ИмяМетода + "Request";
	
	Запрос = РаботаСXMLИС.ОбъектXDTOПоИмениСвойства(ПространствоИмен, ИмяПакета);
	Запрос[ИмяИдентификатора] = ЗначениеИдентификатора;
	
	ТекстСообщенияXML = ИнтеграцияВЕТИС.ОбъектXDTOВXML(Запрос, ПространствоИмен, ИмяПакета);
	
	#КонецОбласти
	
	ПараметрыЗапроса.ТекстСообщенияXML = ТекстСообщенияXML;
	
	Возврат ПараметрыЗапроса;
	
КонецФункции

Функция ЗапросЭлементовКлассификатораЗаболеванийXML(НомерСтраницы, КоличествоЭлементовНаСтранице = Неопределено)
	
	ПараметрыЗапроса = ИнтеграцияВЕТИСКлиентСервер.ПараметрыЗапросаЭлементовКлассификатора();
	ПараметрыЗапроса.ИмяМетода        = "getDiseaseList";
	ПараметрыЗапроса.ПространствоИмен = Метаданные.ПакетыXDTO.СправочникиВЕТИС.ПространствоИмен;
	ПараметрыЗапроса.Сервис           = Перечисления.СервисыВЕТИС.ПрочиеКлассификаторы;
	ПараметрыЗапроса.НомерСтраницы    = НомерСтраницы;
	ПараметрыЗапроса.ИмяЭлемента      = "disease";
	ПараметрыЗапроса.ИмяСписка        = "diseaseList";
	ПараметрыЗапроса.Представление    = НСтр("ru = 'запрос списка заболеваний';
											|en = 'запрос списка заболеваний'");
	
	Если КоличествоЭлементовНаСтранице = Неопределено Тогда
		КоличествоЭлементовНаСтранице = ИнтеграцияВЕТИСКлиентСервер.РазмерСтраницы();
	КонецЕсли;
	ПараметрыЗапроса.КоличествоЭлементовНаСтранице = КоличествоЭлементовНаСтранице;
	
	#Область ТекстаСообщенияXML
	
	ИмяМетода        = ПараметрыЗапроса.ИмяМетода;
	ПространствоИмен = ПараметрыЗапроса.ПространствоИмен;
	
	ИмяПакета = ИмяМетода + "Request";
	
	Запрос = РаботаСXMLИС.ОбъектXDTOПоИмениСвойства(ПространствоИмен, ИмяПакета);
	
	ИнтеграцияВЕТИС.УстановитьПараметрыСтраницы(Запрос, НомерСтраницы);
	
	ТекстСообщенияXML = ИнтеграцияВЕТИС.ОбъектXDTOВXML(Запрос, ПространствоИмен, ИмяПакета);
	
	#КонецОбласти
	
	ПараметрыЗапроса.ТекстСообщенияXML = ТекстСообщенияXML;
	
	Возврат ПараметрыЗапроса;
	
КонецФункции

#КонецОбласти