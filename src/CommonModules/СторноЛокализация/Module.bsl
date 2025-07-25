
#Область ПрограммныйИнтерфейс

#Область Проведение

// Процедура дополняет тексты запросов проведения документа.
//
// Параметры:
//  Запрос - Запрос - Общий запрос проведения документа.
//  ТекстыЗапроса - СписокЗначений - Список текстов запроса проведения.
//  Регистры - Строка, Структура - Список регистров проведения документа через запятую или в ключах структуры.
//
Процедура ДополнитьТекстыЗапросовПроведения(Запрос, ТекстыЗапроса, Регистры) Экспорт
	
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

// Вызывается из соответствующего обработчика документа
//
// Параметры:
//  Объект - ДокументОбъект.Сторно - Обрабатываемый документ.
//  Отказ - Булево - Признак проведения документа.
//                   Если в теле процедуры-обработчика установить данному параметру значение Истина,
//                   то проведение документа выполнено не будет.
//  РежимПроведения - РежимПроведенияДокумента - В данный параметр передается текущий режим проведения.
//
Процедура ОбработкаПроведения(Объект, Отказ, РежимПроведения) Экспорт
	
	Возврат;
	
КонецПроцедуры

// Вызывается из соответствующего обработчика документа
//
// Параметры:
//  Объект - ДокументОбъект.Сторно - Обрабатываемый объект
//  Отказ - Булево - Если в теле процедуры-обработчика установить данному параметру значение Истина,
//                   то будет выполнен отказ от продолжения работы после выполнения проверки заполнения.
//  ПроверяемыеРеквизиты - Массив - Массив путей к реквизитам, для которых будет выполнена проверка заполнения.
//
Процедура ОбработкаПроверкиЗаполнения(Объект, Отказ, ПроверяемыеРеквизиты) Экспорт
	
	Возврат;
	
КонецПроцедуры

// Вызывается из соответствующего обработчика документа
//
// Параметры:
//  Объект - ДокументОбъект.Сторно - Обрабатываемый объект.
//  ДанныеЗаполнения - Произвольный - Значение, которое используется как основание для заполнения.
//  СтандартнаяОбработка - Булево - В данный параметр передается признак выполнения стандартной (системной) обработки события.
//
Процедура ОбработкаЗаполнения(Объект, ДанныеЗаполнения, СтандартнаяОбработка) Экспорт
	
	Возврат;
	
КонецПроцедуры

// Вызывается из соответствующего обработчика документа
//
// Параметры:
//  Объект - ДокументОбъект.Сторно - Обрабатываемый объект
//  Отказ - Булево - Признак отказа от записи.
//                   Если в теле процедуры-обработчика установить данному параметру значение Истина,
//                   то запись выполнена не будет и будет вызвано исключение.
//
Процедура ОбработкаУдаленияПроведения(Объект, Отказ) Экспорт
	
	Возврат;
	
КонецПроцедуры

// Вызывается из соответствующего обработчика документа
//
// Параметры:
//  Объект - ДокументОбъект.Сторно - Обрабатываемый объект
//  Отказ - Булево - Признак отказа от записи.
//                   Если в теле процедуры-обработчика установить данному параметру значение Истина,
//                   то запись выполнена не будет и будет вызвано исключение.
//  РежимЗаписи - РежимЗаписиДокумента - В параметр передается текущий режим записи документа. Позволяет определить в теле процедуры режим записи.
//  РежимПроведения - РежимПроведенияДокумента - В данный параметр передается текущий режим проведения.
//
Процедура ПередЗаписью(Объект, Отказ, РежимЗаписи, РежимПроведения) Экспорт
	
	//++ Локализация
	
	//++ НЕ УТ
	
	ПрослеживаемостьУП.ДобавитьСвойствоЗаписыватьВРасширенныйРегистр(Объект, Ложь);
	
	//-- НЕ УТ

	//-- Локализация
	
	Возврат;
	
КонецПроцедуры

// Вызывается из соответствующего обработчика документа
//
// Параметры:
//  Объект - ДокументОбъект.Сторно - Обрабатываемый объект
//  Отказ - Булево - Признак отказа от записи.
//                   Если в теле процедуры-обработчика установить данному параметру значение Истина, то запись выполнена не будет и будет вызвано исключение.
//
Процедура ПриЗаписи(Объект, Отказ) Экспорт
	
	Возврат;
	
КонецПроцедуры

#КонецОбласти

#Область ПодключаемыеКоманды

// Определяет список команд создания на основании.
//
// Параметры:
//	КомандыСозданияНаОсновании - См. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
//	Параметры - См. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.Параметры
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСозданияНаОсновании, Параметры) Экспорт
	
	Возврат;
	
КонецПроцедуры

// Определяет список команд отчетов.
//
// Параметры:
//	КомандыСозданияНаОсновании - См. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
//	Параметры - См. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.Параметры
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры) Экспорт
	
	Возврат;
	
КонецПроцедуры

// Заполняет список команд печати.
//
// Параметры:
//   КомандыПечати - см. УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	//++ Локализация

	//++ НЕ УТ
	Если ПравоДоступа("Просмотр", Метаданные.РегистрыБухгалтерии.Хозрасчетный) Тогда
		КомандаПечати = КомандыПечати.Добавить();
		КомандаПечати.Идентификатор = "БухгалтерскаяСправка";
		КомандаПечати.Представление = НСтр("ru = 'Бухгалтерская справка (регл. учет)';
											|en = 'Accounting statement (compl. accounting)'");
		КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
		КомандаПечати.МенеджерПечати = "Обработка.ПечатьБухгалтерскойСправки";
		КомандаПечати.ФункциональныеОпции = Метаданные.ФункциональныеОпции.ИспользоватьИсправлениеДокументов.Имя;
		КомандаПечати.ДополнительныеПараметры.Вставить("ПолеСодержаниеОперации", "СторнируемыйДокумент");
		КомандаПечати.ДополнительныеПараметры.Вставить("ТипДокумента", "Сторно");
		КомандаПечати.ДополнительныеПараметры.Вставить("КомментарийСодержания", НСтр("ru = 'Сторно документа:';
																					|en = 'Document storno:'"));
	КонецЕсли;
	//-- НЕ УТ

	//-- Локализация
	
КонецПроцедуры

#КонецОбласти

#Область Печать

// Формирует печатные формы.
//
// Параметры:
//  МассивОбъектов  - Массив из ДокументСсылка.Сторно - ссылки на объекты, которые нужно распечатать;
//  ПараметрыПечати - Структура - дополнительные настройки печати;
//  КоллекцияПечатныхФорм - ТаблицаЗначений - сформированные табличные документы (выходной параметр)
//  ОбъектыПечати         - СписокЗначений  - значение - ссылка на объект;
//                                            представление - имя области в которой был выведен объект (выходной параметр);
//  ПараметрыВывода       - Структура       - дополнительные параметры сформированных табличных документов (выходной параметр).
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Возврат;
	
КонецПроцедуры


#КонецОбласти

//++ НЕ УТ

#Область ПроводкиРегУчета

// Функция возвращает текст запроса для отражения документа в регламентированном учете.
//
// Возвращаемое значение:
//	Строка - Текст запроса
//
Функция ТекстОтраженияВРеглУчете() Экспорт
	
	//++ Локализация
	//-- Локализация

	ТекстыОтражения = Новый Массив;
	
	//++ Локализация
	
	ТекстыОтражения.Добавить(ТекстСторноПроизводственныхЗатрат());
	
	//-- Локализация
	
	Возврат СтрСоединить(ТекстыОтражения, ОбщегоНазначенияУТ.РазделительЗапросовВОбъединении());
	
КонецФункции

// Функция возвращает текст запроса дополнительных временных таблиц,
// необходимых для отражения в регламентированном учете
//
// Возвращаемое значение:
//   Строка - сформированный текст запроса.
//
Функция ТекстЗапросаВТОтраженияВРеглУчете() Экспорт
	
	//++ Локализация
	//-- Локализация
	ТекстыЗапроса = Новый Массив;
	
	//++ Локализация
	
	#Область СторноПроизводственныхЗатрат
	
	ТекстыЗапросовСторноПроизводственныхЗатрат = Новый Массив;
	
	#Область СторноНезавершенногоПроизводства
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ДанныеРегистра.Регистратор КАК Ссылка,
	|	ДанныеРегистра.ИдентификаторФинЗаписи КАК ИдентификаторФинЗаписи,
	|	ДанныеРегистра.ГруппаПродукции КАК ГруппаПродукции,
	|	ДанныеРегистра.Подразделение КАК Подразделение,
	|	ЕСТЬNULL(СпрПартииПроизводства.НаправлениеДеятельности,
	|		ЗНАЧЕНИЕ(Справочник.НаправленияДеятельности.ПустаяСсылка)) КАК НаправлениеДеятельности,
	|	НЕОПРЕДЕЛЕНО КАК СтатьяРасходов,
	|	НЕОПРЕДЕЛЕНО КАК ТипЗатрат,
	|	СУММА(ДанныеРегистра.СтоимостьРегл) КАК Сумма,
	|	СУММА(ДанныеРегистра.СтоимостьУпр) КАК СуммаУпр,
	|	СУММА(ДанныеРегистра.ПостояннаяРазница) КАК СуммаПР,
	|	СУММА(ДанныеРегистра.ВременнаяРазница) КАК СуммаВР
	|ПОМЕСТИТЬ ВТСторноПроизводственныхЗатрат
	|ИЗ
	|	ДокументыКОтражению КАК ДокументыКОтражению
	|	
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.ПрочиеРасходыНезавершенногоПроизводства КАК ДанныеРегистра
	|	ПО ДокументыКОтражению.Ссылка = ДанныеРегистра.Регистратор
	|	
	|	ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ПартииПроизводства КАК СпрПартииПроизводства
	|	ПО СпрПартииПроизводства.Ссылка = ДанныеРегистра.ПартияПроизводства
	|
	|ГДЕ
	|	ДанныеРегистра.Активность
	|	И ДанныеРегистра.НастройкаХозяйственнойОперации = ЗНАЧЕНИЕ(Справочник.НастройкиХозяйственныхОпераций.СторноПроизводственныхЗатрат)
	|
	|СГРУППИРОВАТЬ ПО
	|	ДанныеРегистра.Регистратор,
	|	ДанныеРегистра.ИдентификаторФинЗаписи,
	|	ДанныеРегистра.ГруппаПродукции,
	|	ДанныеРегистра.Подразделение,
	|	СпрПартииПроизводства.НаправлениеДеятельности";
	
	ТекстыЗапросовСторноПроизводственныхЗатрат.Добавить(ТекстЗапроса);
	
	#КонецОбласти
	
	#Область СторноСебестоимости
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ДанныеРегистра.Регистратор КАК Ссылка,
	|	ДанныеРегистра.ИдентификаторФинЗаписи КАК ИдентификаторФинЗаписи,
	|	ВЫБОР
	|		КОГДА &ПартионныйУчетВерсии22 И ДанныеРегистра.Период >= НАЧАЛОПЕРИОДА(&ДатаПереходаНаПартионныйУчетВерсии22, МЕСЯЦ)
	|			И ТИПЗНАЧЕНИЯ(ДанныеРегистра.АналитикаФинансовогоУчета) = ТИП(Справочник.ГруппыАналитическогоУчетаНоменклатуры)
	|			ТОГДА ДанныеРегистра.АналитикаФинансовогоУчета
	|		КОГДА НЕ &АналитическийУчетПоГруппамПродукции
	|			ТОГДА ЗНАЧЕНИЕ(Справочник.ГруппыАналитическогоУчетаНоменклатуры.ПустаяСсылка)
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.ГруппыАналитическогоУчетаНоменклатуры.ПустаяСсылка)
	|	КОНЕЦ КАК ГруппаПродукции,
	|	ВЫБОР
	|		КОГДА ДанныеРегистра.АналитикаУчетаНоменклатуры.ТипМестаХранения = ЗНАЧЕНИЕ(Перечисление.ТипыМестХранения.Склад)
	|		ТОГДА ДанныеРегистра.АналитикаУчетаНоменклатуры.СкладскаяТерритория.Подразделение
	|		КОГДА ДанныеРегистра.АналитикаУчетаНоменклатуры.ТипМестаХранения = ЗНАЧЕНИЕ(Перечисление.ТипыМестХранения.Подразделение)
	|		ТОГДА ДанныеРегистра.АналитикаУчетаНоменклатуры.Подразделение
	|	ИНАЧЕ НЕОПРЕДЕЛЕНО КОНЕЦ КАК Подразделение,
	|	ЕСТЬNULL(СпрПартииПроизводства.НаправлениеДеятельности,
	|		ЗНАЧЕНИЕ(Справочник.НаправленияДеятельности.ПустаяСсылка)) КАК НаправлениеДеятельности,
	|	НЕОПРЕДЕЛЕНО КАК СтатьяРасходов,
	|	НЕОПРЕДЕЛЕНО КАК ТипЗатрат,
	|	СУММА(ДанныеРегистра.СтоимостьРегл + ДанныеРегистра.ДопРасходыРегл + ДанныеРегистра.ТрудозатратыРегл + ДанныеРегистра.ПостатейныеПостоянныеРегл
	|		+ ДанныеРегистра.ПостатейныеПеременныеРегл + ДанныеРегистра.СтоимостьЗабалансоваяРегл) КАК Сумма,
	|	СУММА(ДанныеРегистра.СтоимостьУпр + ДанныеРегистра.ДопРасходыУпр + ДанныеРегистра.ТрудозатратыУпр
	|		+ ДанныеРегистра.ПостатейныеПостоянныеУпр + ДанныеРегистра.ПостатейныеПеременныеУпр) КАК СуммаУпр,
	|	СУММА(ДанныеРегистра.ПостояннаяРазница) КАК СуммаПР,
	|	СУММА(ДанныеРегистра.ВременнаяРазница) КАК СуммаВР
	|ИЗ
	|	ДокументыКОтражению КАК ДокументыКОтражению
	|	
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.СебестоимостьТоваров КАК ДанныеРегистра
	|	ПО ДокументыКОтражению.Ссылка = ДанныеРегистра.Регистратор
	|	
	|	ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ПартииПроизводства КАК СпрПартииПроизводства
	|	ПО СпрПартииПроизводства.Ссылка = ДанныеРегистра.Партия
	|
	|ГДЕ
	|	ДанныеРегистра.Активность
	|	И ДанныеРегистра.НастройкаХозяйственнойОперации = ЗНАЧЕНИЕ(Справочник.НастройкиХозяйственныхОпераций.СторноПроизводственныхЗатрат)
	|	И ДанныеРегистра.Организация <> ЗНАЧЕНИЕ(Справочник.Организации.УправленческаяОрганизация)
	|
	|СГРУППИРОВАТЬ ПО
	|	ДанныеРегистра.Регистратор,
	|	ДанныеРегистра.ИдентификаторФинЗаписи,
	|	ВЫБОР
	|		КОГДА &ПартионныйУчетВерсии22 И ДанныеРегистра.Период >= НАЧАЛОПЕРИОДА(&ДатаПереходаНаПартионныйУчетВерсии22, МЕСЯЦ)
	|			И ТИПЗНАЧЕНИЯ(ДанныеРегистра.АналитикаФинансовогоУчета) = ТИП(Справочник.ГруппыАналитическогоУчетаНоменклатуры)
	|			ТОГДА ДанныеРегистра.АналитикаФинансовогоУчета
	|		КОГДА НЕ &АналитическийУчетПоГруппамПродукции
	|			ТОГДА ЗНАЧЕНИЕ(Справочник.ГруппыАналитическогоУчетаНоменклатуры.ПустаяСсылка)
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.ГруппыАналитическогоУчетаНоменклатуры.ПустаяСсылка)
	|	КОНЕЦ,
	|	ВЫБОР
	|		КОГДА ДанныеРегистра.АналитикаУчетаНоменклатуры.ТипМестаХранения = ЗНАЧЕНИЕ(Перечисление.ТипыМестХранения.Склад)
	|		ТОГДА ДанныеРегистра.АналитикаУчетаНоменклатуры.СкладскаяТерритория.Подразделение
	|		КОГДА ДанныеРегистра.АналитикаУчетаНоменклатуры.ТипМестаХранения = ЗНАЧЕНИЕ(Перечисление.ТипыМестХранения.Подразделение)
	|		ТОГДА ДанныеРегистра.АналитикаУчетаНоменклатуры.Подразделение
	|	ИНАЧЕ НЕОПРЕДЕЛЕНО КОНЕЦ,
	|	СпрПартииПроизводства.НаправлениеДеятельности";
	
	ТекстыЗапросовСторноПроизводственныхЗатрат.Добавить(ТекстЗапроса);
	
	#КонецОбласти
	
	#Область СторноТрудозатрат
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ДанныеРегистра.Регистратор КАК Ссылка,
	|	ДанныеРегистра.ИдентификаторФинЗаписи КАК ИдентификаторФинЗаписи,
	|	ДанныеРегистра.ГруппаПродукции КАК ГруппаПродукции,
	|	ДанныеРегистра.Подразделение КАК Подразделение,
	|	ЕСТЬNULL(СпрПартииПроизводства.НаправлениеДеятельности,
	|		ЗНАЧЕНИЕ(Справочник.НаправленияДеятельности.ПустаяСсылка)) КАК НаправлениеДеятельности,
	|	НЕОПРЕДЕЛЕНО КАК СтатьяРасходов,
	|	НЕОПРЕДЕЛЕНО КАК ТипЗатрат,
	|	СУММА(ДанныеРегистра.СтоимостьРегл) КАК Сумма,
	|	СУММА(ДанныеРегистра.Стоимость) КАК СуммаУпр,
	|	СУММА(ДанныеРегистра.ПостояннаяРазница) КАК СуммаПР,
	|	СУММА(ДанныеРегистра.ВременнаяРазница) КАК СуммаВР
	|ИЗ
	|	ДокументыКОтражению КАК ДокументыКОтражению
	|	
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.ТрудозатратыНезавершенногоПроизводства КАК ДанныеРегистра
	|	ПО ДокументыКОтражению.Ссылка = ДанныеРегистра.Регистратор
	|	
	|	ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ПартииПроизводства КАК СпрПартииПроизводства
	|	ПО СпрПартииПроизводства.Ссылка = ДанныеРегистра.ПартияПроизводства
	|
	|ГДЕ
	|	ДанныеРегистра.Активность
	|	И ДанныеРегистра.НастройкаХозяйственнойОперации = ЗНАЧЕНИЕ(Справочник.НастройкиХозяйственныхОпераций.СторноПроизводственныхЗатрат)
	|
	|СГРУППИРОВАТЬ ПО
	|	ДанныеРегистра.Регистратор,
	|	ДанныеРегистра.ИдентификаторФинЗаписи,
	|	ДанныеРегистра.ГруппаПродукции,
	|	ДанныеРегистра.Подразделение,
	|	СпрПартииПроизводства.НаправлениеДеятельности";
	
	ТекстыЗапросовСторноПроизводственныхЗатрат.Добавить(ТекстЗапроса);
	
	#КонецОбласти
	
	ТекстЗапроса = СтрСоединить(ТекстыЗапросовСторноПроизводственныхЗатрат, ОбщегоНазначенияУТ.РазделительЗапросовВОбъединении());
	
	ТекстЗапроса = ТекстЗапроса + "
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Ссылка,
	|	ИдентификаторФинЗаписи";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса);
	
	#КонецОбласти
	
	// Добавим пустой запрос, для того чтобы последний запрос тоже заканчивался на разделитель пакета запросов:
	ТекстыЗапроса.Добавить("");
	
	//-- Локализация
	
	ТекстЗапроса = СтрСоединить(ТекстыЗапроса, ОбщегоНазначения.РазделительПакетаЗапросов());
	Возврат ТекстЗапроса;
	
КонецФункции

#КонецОбласти

//-- НЕ УТ

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

//++ Локализация

//++ НЕ УТ
#Область ПроводкиРеглУчета

Функция ТекстСторноПроизводственныхЗатрат()
	
	ТекстЗапроса = "
	|ВЫБРАТЬ //// Сторно производственных затрат (Дт 2х :: Кт 2х)
	|	ПрочиеРасходы.Регистратор КАК Ссылка,
	|	ПрочиеРасходы.Период КАК Период,
	|	ПрочиеРасходы.Организация КАК Организация,
	|	НЕОПРЕДЕЛЕНО КАК ИдентификаторСтроки,
	|
	|	ПрочиеРасходы.СуммаРегл КАК Сумма,
	|	ПрочиеРасходы.СуммаУпр КАК СуммаУУ,
	|
	|	ЗНАЧЕНИЕ(Перечисление.ВидыСчетовРеглУчета.Расходы) КАК ВидСчетаДт,
	|	ПрочиеРасходы.СтатьяРасходов КАК АналитикаУчетаДт,
	|	ПрочиеРасходы.Подразделение КАК МестоУчетаДт,
	|
	|	ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка) КАК ВалютаДт,
	|	ПрочиеРасходы.Подразделение КАК ПодразделениеДт,
	|	ПрочиеРасходы.НаправлениеДеятельности КАК НаправлениеДеятельностиДт,
	|
	|	ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ПустаяСсылка) КАК СчетДт,
	|
	|	ПрочиеРасходы.СтатьяРасходов КАК СубконтоДт1,
	|	ПрочиеРасходы.АналитикаРасходов КАК СубконтоДт2,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыЗатратРегл.Прочее) КАК СубконтоДт3,
	|
	|	0 КАК ВалютнаяСуммаДт,
	|	0 КАК КоличествоДт,
	|	ПрочиеРасходы.СуммаРегл - ПрочиеРасходы.ПостояннаяРазница - ПрочиеРасходы.ВременнаяРазница КАК СуммаНУДт,
	|	ПрочиеРасходы.ПостояннаяРазница КАК СуммаПРДт,
	|	ПрочиеРасходы.ВременнаяРазница КАК СуммаВРДт,
	|
	|	ЗНАЧЕНИЕ(Перечисление.ВидыСчетовРеглУчета.Производство) КАК ВидСчетаКт,
	|	СторноПроизводственныхЗатрат.ГруппаПродукции КАК АналитикаУчетаКт,
	|	СторноПроизводственныхЗатрат.Подразделение КАК МестоУчетаКт,
	|
	|	ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка) КАК ВалютаКт,
	|	СторноПроизводственныхЗатрат.Подразделение КАК ПодразделениеКт,
	|	СторноПроизводственныхЗатрат.НаправлениеДеятельности КАК НаправлениеДеятельностиКт,
	|
	|	ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ПустаяСсылка) КАК СчетКт,
	|
	|	СторноПроизводственныхЗатрат.СтатьяРасходов КАК СубконтоКт1,
	|	СторноПроизводственныхЗатрат.ГруппаПродукции КАК СубконтоКт2,
	|	СторноПроизводственныхЗатрат.ТипЗатрат КАК СубконтоКт3,
	|
	|	0 КАК ВалютнаяСуммаКт,
	|	0 КАК КоличествоКт,
	|	ПрочиеРасходы.СуммаРегл - ПрочиеРасходы.ПостояннаяРазница - ПрочиеРасходы.ВременнаяРазница КАК СуммаНУКт,
	|	ПрочиеРасходы.ПостояннаяРазница КАК СуммаПРКт,
	|	ПрочиеРасходы.ВременнаяРазница КАК СуммаВРКт,
	|	""Сторно производственных затрат"" КАК Содержание
	|
	|ИЗ
	|	ДокументыКОтражению КАК ДокументыКОтражению
	|	
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		РегистрНакопления.ПрочиеРасходы КАК ПрочиеРасходы
	|	ПО
	|		ДокументыКОтражению.Ссылка = ПрочиеРасходы.Регистратор
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		ВТСторноПроизводственныхЗатрат КАК СторноПроизводственныхЗатрат
	|	ПО
	|		СторноПроизводственныхЗатрат.Ссылка = ПрочиеРасходы.Регистратор
	|		И СторноПроизводственныхЗатрат.ИдентификаторФинЗаписи = ПрочиеРасходы.ИдентификаторФинЗаписи
	|ГДЕ
	|	ПрочиеРасходы.Активность
	|	И ПрочиеРасходы.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|	И ПрочиеРасходы.НастройкаХозяйственнойОперации = ЗНАЧЕНИЕ(Справочник.НастройкиХозяйственныхОпераций.СторноПроизводственныхЗатрат)
	|";
	
	Возврат ТекстЗапроса;

КонецФункции

#КонецОбласти
//-- НЕ УТ

//-- Локализация

#КонецОбласти
