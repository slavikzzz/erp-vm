// @strict-types


#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Добавить объект к расчету статусов.
// 
// Параметры:
//  Основание - ОпределяемыйТип.ОснованиеСтатусыОформленияДокументовИС 
Процедура ДобавитьОснование(Знач Основание) Экспорт
	
	Набор = СоздатьНаборЗаписей();
	Набор.Отбор.Основание.Установить(Основание);
	Набор.Добавить().Основание = Основание;
	УстановитьПривилегированныйРежим(Истина);
	Набор.Записать();
	
КонецПроцедуры

// Удалить объекты по которым выполнен расчет статусов.
// 
// Параметры:
//  Основания - Массив Из ОпределяемыйТип.ОснованиеСтатусыОформленияДокументовИС - Основания
Процедура УдалитьОснования(Знач Основания) Экспорт
	
	Набор = СоздатьНаборЗаписей();
	УстановитьПривилегированныйРежим(Истина);
	Для Каждого Основание Из Основания Цикл
		Набор.Отбор.Основание.Установить(Основание);
		Набор.Записать();
	КонецЦикла;
	
КонецПроцедуры

// Возвращает накопленные в регистре данные, сгруппированные по типам.
// 
// Возвращаемое значение:
//  ВыборкаИзРезультатаЗапроса - Выборка объектов к расчету
Функция ВыборкаОбъектовКРасчету() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СтатусыОформленияКРасчетуИС.Основание КАК Основание,
	|	ТИПЗНАЧЕНИЯ(СтатусыОформленияКРасчетуИС.Основание) КАК ТипОснования
	|ИЗ
	|	РегистрСведений.СтатусыОформленияКРасчетуИС КАК СтатусыОформленияКРасчетуИС
	|ИТОГИ
	|ПО
	|	ТипОснования";
	
	Возврат Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
КонецФункции

// Текст надписи в объекте.
// 
// Параметры:
//  Основание - ОпределяемыйТип.ОснованиеСтатусыОформленияДокументовИС - объект ссылкой
// 
// Возвращаемое значение:
//  ФорматированнаяСтрока - текст надписи по общему состоянию статуса
Функция ТекстНадписиВОбъекте(Основание) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Основание", Основание);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СтатусыОформленияКРасчетуИС.Основание КАК Основание
	|ИЗ
	|	РегистрСведений.СтатусыОформленияКРасчетуИС КАК СтатусыОформленияКРасчетуИС
	|ГДЕ
	|	СтатусыОформленияКРасчетуИС.Основание = &Основание";
	УстановитьПривилегированныйРежим(Истина);
	ТребуетсяРасчетСтатусов = Не Запрос.Выполнить().Пустой();
	Если ТребуетсяРасчетСтатусов Тогда
		Возврат Новый ФорматированнаяСтрока(НСтр("ru = 'Ожидается расчет статусов оформления';
												|en = 'Ожидается расчет статусов оформления'"));
	КонецЕсли;
	Возврат "";
	
КонецФункции

#КонецОбласти

#КонецЕсли
