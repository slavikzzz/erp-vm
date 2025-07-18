#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция ТаблицаСоответствияВидовНалогов() Экспорт
	
	ТаблицаСоответствия = Новый ТаблицаЗначений;
	
	МетаданныеСправочника = Метаданные.Справочники.ВидыНалоговыхОбязательств;
	ТаблицаСоответствия.Колонки.Добавить("ВидНалога",                                Новый ОписаниеТипов("ПеречислениеСсылка.ВидыНалогов"));
	ТаблицаСоответствия.Колонки.Добавить("ВидНалоговогоОбязательства",               Новый ОписаниеТипов("СправочникСсылка.ВидыНалоговыхОбязательств"));
	ТаблицаСоответствия.Колонки.Добавить("КодВидаНалоговогоОбязательства",           МетаданныеСправочника.СтандартныеРеквизиты.Код.Тип);
	ТаблицаСоответствия.Колонки.Добавить("ПредставлениеВидаНалоговогоОбязательства", МетаданныеСправочника.СтандартныеРеквизиты.Наименование.Тип);
	
	Макет = ПолучитьМакет("СоответствиеВидовНалогов");
	
	ОбластьСоответствиеВидовНалогов  = Макет.Область("СоответствиеВидовНалогов");
	НомерПервойСтрокиВидовНалогов    = ОбластьСоответствиеВидовНалогов.Верх;
	НомерПоследнейСтрокиВидовНалогов = ОбластьСоответствиеВидовНалогов.Низ;
	
	НомерКолонкиВидНалогаУчет    = Макет.Область("ВидНалога").Лево;
	НомерКолонкиКодВидаНалогаФНС = Макет.Область("КодВидаНалоговогоОбязательства").Лево;
	
	Для НомерСтроки = НомерПервойСтрокиВидовНалогов По НомерПоследнейСтрокиВидовНалогов Цикл
		ВидНалогаСтр = ТекстЯчейкиТабличногоДокумента(Макет, НомерСтроки, НомерКолонкиВидНалогаУчет);
		Если Не ЗначениеЗаполнено(ВидНалогаСтр) Тогда
			Продолжить;
		КонецЕсли;
		ВидНалога= ЗначениеПеречисленияВидовНалогов(ВидНалогаСтр);
		Если Не ЗначениеЗаполнено(ВидНалога) Тогда
			Продолжить;
		КонецЕсли;
		СтрокаСоответствия = ТаблицаСоответствия.Добавить();
		СтрокаСоответствия.ВидНалога                      = ВидНалога;
		СтрокаСоответствия.КодВидаНалоговогоОбязательства = ТекстЯчейкиТабличногоДокумента(Макет, НомерСтроки, НомерКолонкиКодВидаНалогаФНС);
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТаблицаСоответствия", ТаблицаСоответствия);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТаблицаСоответствия.ВидНалога КАК ВидНалога,
	|	ТаблицаСоответствия.КодВидаНалоговогоОбязательства КАК КодВидаНалоговогоОбязательства
	|ПОМЕСТИТЬ ВТТаблицаСоответствия
	|ИЗ
	|	&ТаблицаСоответствия КАК ТаблицаСоответствия
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТТаблицаСоответствия.ВидНалога КАК ВидНалога,
	|	ЕСТЬNULL(ВидыНалоговыхОбязательств.Ссылка, ЗНАЧЕНИЕ(Справочник.ВидыНалоговыхОбязательств.ПустаяСсылка)) КАК ВидНалоговогоОбязательства
	|ИЗ
	|	ВТТаблицаСоответствия КАК ВТТаблицаСоответствия
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВидыНалоговыхОбязательств КАК ВидыНалоговыхОбязательств
	|		ПО ВТТаблицаСоответствия.КодВидаНалоговогоОбязательства = ВидыНалоговыхОбязательств.Код
	|			И (НЕ ВидыНалоговыхОбязательств.Ликвидирован)
	|			И (НЕ ВидыНалоговыхОбязательств.Аннулирован)
	|			И (НЕ ВидыНалоговыхОбязательств.ПометкаУдаления)
	|
	|СГРУППИРОВАТЬ ПО
	|	ВТТаблицаСоответствия.ВидНалога,
	|	ЕСТЬNULL(ВидыНалоговыхОбязательств.Ссылка, ЗНАЧЕНИЕ(Справочник.ВидыНалоговыхОбязательств.ПустаяСсылка))";
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

Функция ВидНалоговогоОбязательстваГоспошлина() Экспорт
	
	КодВидаНО = "07";
	ВидНО = НайтиПоКоду(КодВидаНО);
	
	Возврат ВидНО;
	
КонецФункции

Функция ВидНалоговогоОбязательстваПроценты() Экспорт
	
	КодВидаНО = "54";
	ВидНО = НайтиПоКоду(КодВидаНО);
	
	Возврат ВидНО;
	
КонецФункции

Функция ВидНалоговогоОбязательстваПени() Экспорт
	
	КодВидаНО = "53";
	ВидНО = НайтиПоКоду(КодВидаНО);
	
	Возврат ВидНО;
	
КонецФункции

Функция ВидНалоговогоОбязательстваШтрафы() Экспорт
	
	КодВидаНО = "55";
	ВидНО = НайтиПоКоду(КодВидаНО);
	
	Возврат ВидНО;
	
КонецФункции

Функция ВидНалоговогоОбязательстваНДС() Экспорт
	
	КодВидаНО = "01";
	ВидНО = НайтиПоКоду(КодВидаНО);
	
	Возврат ВидНО;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ТекстЯчейкиТабличногоДокумента(ТабличныйДокумент, НомерСтроки, НомерКолонки)
	
	Возврат СокрЛП(ТабличныйДокумент.Область("R" + Формат(НомерСтроки, "ЧГ=0") + "C" + Формат(НомерКолонки, "ЧГ=0")).Текст);
	
КонецФункции

Функция ЗначениеПеречисленияВидовНалогов(ИмяПеречисления)
	
	Попытка
		Возврат Перечисления.ВидыНалогов[ИмяПеречисления];
	Исключение
		Возврат Неопределено;
	КонецПопытки;
	
КонецФункции

#КонецОбласти

#КонецЕсли