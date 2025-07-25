#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область Проведение

// Описывает учетные механизмы используемые в документе для регистрации в механизме проведения.
//
// Параметры:
//  МеханизмыДокумента - Массив - список имен учетных механизмов, для которых будет выполнена
//              регистрация в механизме проведения.
//
Процедура ЗарегистрироватьУчетныеМеханизмы(МеханизмыДокумента) Экспорт
	
	МеханизмыДокумента.Добавить("НСИПроизводства");
	
КонецПроцедуры

// Возвращает таблицы для движений, необходимые для проведения документа по регистрам учетных механизмов.
//
// Параметры:
//  Документ - ДокументСсылка, ДокументОбъект - ссылка на документ или объект, по которому необходимо получить данные
//  Регистры - Структура - список имен регистров, для которых необходимо получить таблицы
//  ДопПараметры - Структура - дополнительные параметры для получения данных, определяющие контекст проведения.
//
// Возвращаемое значение:
//  см. ПроведениеДокументов.ИнициализироватьДанныеДокументаДляПроведения
//
Функция ДанныеДокументаДляПроведения(Документ, Регистры, ДопПараметры = Неопределено) Экспорт
	
	Если ДопПараметры = Неопределено Тогда
		ДопПараметры = ПроведениеДокументов.ДопПараметрыИнициализироватьДанныеДокументаДляПроведения();
	КонецЕсли;
	
	Если ТипЗнч(Документ) = Тип("ДокументОбъект.РазрешениеНаЗаменуМатериалов") Тогда
		ДокументСсылка = Документ.Ссылка;
	Иначе
		ДокументСсылка = Документ;
	КонецЕсли;
	
	Запрос			= Новый Запрос;
	ТекстыЗапроса	= Новый СписокЗначений;
	
	Если Не ДопПараметры.ПолучитьТекстыЗапроса Тогда
		////////////////////////////////////////////////////////////////////////////
		// Создадим запрос инициализации движений
		
		ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка);
		
		////////////////////////////////////////////////////////////////////////////
		// Сформируем текст запроса
		
		ТекстЗапросаТаблицаАналогиМатериалов(Запрос, ТекстыЗапроса, Регистры);
	КонецЕсли;
	
	////////////////////////////////////////////////////////////////////////////
	// Получим таблицы для движений
	
	Возврат ПроведениеДокументов.ИнициализироватьДанныеДокументаДляПроведения(Запрос, ТекстыЗапроса, ДопПараметры);
	
КонецФункции

#КонецОбласти

// Определяет список команд создания на основании.
//
// Параметры:
//  КомандыСозданияНаОсновании - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
//  Параметры - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.Параметры
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСозданияНаОсновании, Параметры) Экспорт
	
	
	
КонецПроцедуры

// Добавляет команду создания документа "Разрешение на замену материалов".
//
// Параметры:
//  КомандыСозданияНаОсновании - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
//
// Возвращаемое значение:
//  СтрокаТаблицыЗначений, Неопределено -
//
Функция ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании) Экспорт
	
	Если ПравоДоступа("Добавление", Метаданные.Документы.РазрешениеНаЗаменуМатериалов) Тогда
		
		КомандаСоздатьНаОсновании = КомандыСозданияНаОсновании.Добавить();
		КомандаСоздатьНаОсновании.Менеджер = Метаданные.Документы.РазрешениеНаЗаменуМатериалов.ПолноеИмя();
		КомандаСоздатьНаОсновании.Представление = ОбщегоНазначенияУТ.ПредставлениеОбъекта(Метаданные.Документы.РазрешениеНаЗаменуМатериалов);
		КомандаСоздатьНаОсновании.РежимЗаписи = "Проводить";
		КомандаСоздатьНаОсновании.ФункциональныеОпции = "ИспользоватьАналогиМатериалов";
		
		Возврат КомандаСоздатьНаОсновании;
		
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

// Определяет список команд отчетов.
//
// Параметры:
//   КомандыОтчетов - См. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.КомандыОтчетов
//   Параметры - См. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.Параметры
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры) Экспорт
	
	
	
КонецПроцедуры

// Заполняет список команд печати.
//
// Параметры:
//   КомандыПечати - см. УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Проведение

Функция ДополнительныеИсточникиДанныхДляДвижений(ИмяРегистра) Экспорт

	ИсточникиДанных = Новый Соответствие;

	Возврат ИсточникиДанных; 

КонецФункции

Процедура ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка)
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	РазрешениеНаЗаменуМатериалов.НаправлениеДеятельности КАК НаправлениеДеятельности,
	|	РазрешениеНаЗаменуМатериалов.ЗаказНаПроизводство КАК ЗаказНаПроизводство,
	|	РазрешениеНаЗаменуМатериалов.Спецификация КАК Спецификация,
	|	РазрешениеНаЗаменуМатериалов.Этап КАК Этап,
	|	РазрешениеНаЗаменуМатериалов.Изделие КАК Изделие,
	|	РазрешениеНаЗаменуМатериалов.ХарактеристикаИзделия КАК ХарактеристикаИзделия,
	|	РазрешениеНаЗаменуМатериалов.ЗаказКлиента КАК ЗаказКлиента,
	|	РазрешениеНаЗаменуМатериалов.ДатаНачалаДействия КАК ДатаНачалаДействия,
	|	РазрешениеНаЗаменуМатериалов.ДатаОкончанияДействия КАК ДатаОкончанияДействия,
	|	РазрешениеНаЗаменуМатериалов.Статус КАК Статус,
	|	РазрешениеНаЗаменуМатериалов.Подразделение КАК Подразделение
	|ИЗ
	|	Документ.РазрешениеНаЗаменуМатериалов КАК РазрешениеНаЗаменуМатериалов
	|ГДЕ
	|	РазрешениеНаЗаменуМатериалов.Ссылка = &Ссылка";
	
	Реквизиты = Запрос.Выполнить().Выбрать();
	Реквизиты.Следующий();
	
	Запрос.УстановитьПараметр("Статус",                    Реквизиты.Статус);
	Запрос.УстановитьПараметр("ЗаказНаПроизводство",       Реквизиты.ЗаказНаПроизводство);
	Запрос.УстановитьПараметр("Спецификация",              Реквизиты.Спецификация);
	Запрос.УстановитьПараметр("Этап",                      Реквизиты.Этап);
	Запрос.УстановитьПараметр("Изделие",                   Реквизиты.Изделие);
	Запрос.УстановитьПараметр("ХарактеристикаИзделия",     Реквизиты.ХарактеристикаИзделия);
	Запрос.УстановитьПараметр("ЗаказКлиента",              Реквизиты.ЗаказКлиента);
	Запрос.УстановитьПараметр("ДатаНачалаДействия",        Реквизиты.ДатаНачалаДействия);
	Запрос.УстановитьПараметр("ДатаОкончанияДействия",     Реквизиты.ДатаОкончанияДействия);
	Запрос.УстановитьПараметр("Подразделение",             Реквизиты.Подразделение);
	Запрос.УстановитьПараметр("НаправлениеДеятельности",   Реквизиты.НаправлениеДеятельности);
	
КонецПроцедуры

Функция ТекстЗапросаТаблицаАналогиМатериалов(Запрос, ТекстыЗапроса, Регистры)

	ИмяРегистра = "АналогиМатериалов";
	
	Если НЕ ПроведениеДокументов.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли; 
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	&НаправлениеДеятельности КАК НаправлениеДеятельности,	
	|	&ЗаказНаПроизводство КАК ЗаказНаПроизводство,
	|	&Спецификация КАК Спецификация,
	|	&Этап КАК Этап,
	|	&Изделие КАК Изделие,
	|	&ХарактеристикаИзделия КАК ХарактеристикаИзделия,
	|	&ЗаказКлиента КАК ЗаказКлиента,
	|	&ДатаНачалаДействия КАК Период,
	|	&ДатаОкончанияДействия КАК ПериодЗавершения,
	|	&Подразделение КАК Подразделение,
	|	РазрешениеНаЗаменуМатериаловМатериалы.Номенклатура КАК Материал,
	|	РазрешениеНаЗаменуМатериаловМатериалы.Характеристика КАК ХарактеристикаМатериала,
	|	РазрешениеНаЗаменуМатериаловМатериалы.КоличествоУпаковок КАК КоличествоУпаковокМатериала,
	|	РазрешениеНаЗаменуМатериаловМатериалы.Упаковка КАК УпаковкаМатериала,
	|	РазрешениеНаЗаменуМатериаловМатериалы.ИдентификаторСтроки КАК ИдентификаторСтроки,
	|	РазрешениеНаЗаменуМатериаловАналоги.Номенклатура КАК Аналог,
	|	РазрешениеНаЗаменуМатериаловАналоги.Характеристика КАК ХарактеристикаАналога,
	|	РазрешениеНаЗаменуМатериаловАналоги.КоличествоУпаковок КАК КоличествоУпаковокАналога,
	|	РазрешениеНаЗаменуМатериаловАналоги.Упаковка КАК УпаковкаАналога
	|ИЗ
	|	Документ.РазрешениеНаЗаменуМатериалов.Материалы КАК РазрешениеНаЗаменуМатериаловМатериалы,
	|	Документ.РазрешениеНаЗаменуМатериалов.Аналоги КАК РазрешениеНаЗаменуМатериаловАналоги
	|ГДЕ
	|	РазрешениеНаЗаменуМатериаловАналоги.Ссылка = &Ссылка
	|	И РазрешениеНаЗаменуМатериаловМатериалы.Ссылка = &Ссылка
	|	И &Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыРазрешенийНаЗаменуМатериалов.Утверждено)";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

#КонецОбласти

#Область Прочее

Функция ТекстЗапросаДинамическогоСпискаРазрешенийНаЗаменуМатериалов() Экспорт
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ОсновнаяТаблица.Ссылка КАК Ссылка,
	|	ОсновнаяТаблица.ВерсияДанных КАК ВерсияДанных,
	|	ОсновнаяТаблица.ПометкаУдаления КАК ПометкаУдаления,
	|	ОсновнаяТаблица.Номер КАК Номер,
	|	ОсновнаяТаблица.Дата КАК Дата,
	|	ОсновнаяТаблица.Проведен КАК Проведен,
	|	ОсновнаяТаблица.ЗаказНаПроизводство КАК ЗаказНаПроизводство,
	|	ОсновнаяТаблица.Спецификация КАК Спецификация,
	|	ОсновнаяТаблица.Изделие КАК Изделие,
	|	ОсновнаяТаблица.ХарактеристикаИзделия КАК ХарактеристикаИзделия,
	|	ОсновнаяТаблица.ЗаказКлиента КАК ЗаказКлиента,
	|	ОсновнаяТаблица.ДатаНачалаДействия КАК ДатаНачалаДействия,
	|	ОсновнаяТаблица.ДатаОкончанияДействия КАК ДатаОкончанияДействия,
	|	ОсновнаяТаблица.Статус КАК Статус,
	|	ОсновнаяТаблица.УказаниеПоПрименению КАК УказаниеПоПрименению,
	|	ОсновнаяТаблица.Ответственный КАК Ответственный,
	|	ОсновнаяТаблица.Подразделение КАК Подразделение,
	|	ОсновнаяТаблица.НаправлениеДеятельности КАК НаправлениеДеятельности
	|ИЗ
	|	Документ.РазрешениеНаЗаменуМатериалов КАК ОсновнаяТаблица
	|";
	
	Возврат ТекстЗапроса;
	
КонецФункции

// Устанавливает отбор по номенклатуре в динамическом списке.
//
// Параметры:
//  Список       - ДинамическийСписок - оформляемый динамический список.
//  Номенклатура - СправочникСсылка.Номенклатура - номенклатура отбора.
//  Назначение   - ПеречислениеСсылка.ИспользованиеНоменклатурыВНСИПроизводства - назначение отбора.
//
Процедура УстановитьОтборПоНоменклатуреВДинамическомСпискеРазрешенийНаЗаменуМатериалов(Список, Номенклатура, Назначение = Неопределено) Экспорт
	
	ОтборПоНоменклатуре = ОбщегоНазначенияКлиентСервер.СоздатьГруппуЭлементовОтбора(
		Список.КомпоновщикНастроек.ФиксированныеНастройки.Отбор.Элементы,
		НСтр("ru = 'Отбор по номенклатуре';
			|en = 'Filter by items'"),
		ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли);
	
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(
		ОтборПоНоменклатуре,
		"Ссылка.Изделие",
		ВидСравненияКомпоновкиДанных.Равно,
		Номенклатура,
		,
		ЗначениеЗаполнено(Номенклатура) И (НЕ ЗначениеЗаполнено(Назначение) ИЛИ Назначение = Перечисления.ИспользованиеНоменклатурыВНСИПроизводства.Изделие));
	
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(
		ОтборПоНоменклатуре,
		"Ссылка.Материалы.Номенклатура",
		ВидСравненияКомпоновкиДанных.Равно,
		Номенклатура,
		,
		ЗначениеЗаполнено(Номенклатура) И (НЕ ЗначениеЗаполнено(Назначение) ИЛИ Назначение = Перечисления.ИспользованиеНоменклатурыВНСИПроизводства.Материал));
	
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(
		ОтборПоНоменклатуре,
		"Ссылка.Аналоги.Номенклатура",
		ВидСравненияКомпоновкиДанных.Равно,
		Номенклатура,
		,
		ЗначениеЗаполнено(Номенклатура) И (НЕ ЗначениеЗаполнено(Назначение) ИЛИ Назначение = Перечисления.ИспользованиеНоменклатурыВНСИПроизводства.Аналог));
	
КонецПроцедуры

#КонецОбласти

#Область ОбновлениеИнформационнойБазы

Функция АдаптированныйТекстЗапросаДвиженийПоРегистру(ИмяРегистра) Экспорт

	Запрос = Новый Запрос;
	ТекстыЗапроса = Новый СписокЗначений;
	
	ПолноеИмяДокумента = "Документ.РазрешениеНаЗаменуМатериалов";
	СинонимТаблицыДокумента = "РазрешениеНаЗаменуМатериаловМатериалы";
	
	Если ИмяРегистра = "АналогиМатериалов" Тогда
		
		ТекстЗапроса = ТекстЗапросаТаблицаАналогиМатериалов(Запрос, ТекстыЗапроса, ИмяРегистра);
		
	Иначе
		
		ТекстИсключения = НСтр("ru = 'В документе %ПолноеИмяДокумента% не реализована адаптация текста запроса формирования движений по регистру %ИмяРегистра%.';
								|en = 'In document %ПолноеИмяДокумента%, adaptation of request for generating records of register %ИмяРегистра% is not implemented.'");
		ТекстИсключения = СтрЗаменить(ТекстИсключения, "%ПолноеИмяДокумента%", ПолноеИмяДокумента);
		ТекстИсключения = СтрЗаменить(ТекстИсключения, "%ИмяРегистра%", ИмяРегистра);
		
		ВызватьИсключение ТекстИсключения;
		
	КонецЕсли;
	
	Результат = ОбновлениеИнформационнойБазыУТ.РезультатАдаптацииЗапроса();
	Результат.ТекстЗапроса = ОбновлениеИнформационнойБазыУТ.АдаптироватьЗапросМеханизмаПроведения(
									ТекстЗапроса, ПолноеИмяДокумента, СинонимТаблицыДокумента);
	
	Возврат Результат;
	
КонецФункции	

#КонецОбласти

#КонецОбласти

#КонецЕсли
