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
	
	//++ НЕ УТКА
	МеханизмыДокумента.Добавить("МеждународныйУчет");
	//-- НЕ УТКА
	МеханизмыДокумента.Добавить("ОперативныйУчетТоваровОрганизаций");
	МеханизмыДокумента.Добавить("РеестрДокументов");
	МеханизмыДокумента.Добавить("СебестоимостьИПартионныйУчет");
	
	ИсправлениеРазвернутогоСальдоТоваровОрганизацийЛокализация.ЗарегистрироватьУчетныеМеханизмы(МеханизмыДокумента);
	
КонецПроцедуры

Функция ДанныеДокументаДляПроведения(Документ, Регистры, ДопПараметры = Неопределено) Экспорт
	
	Если ДопПараметры = Неопределено Тогда
		ДопПараметры = ПроведениеДокументов.ДопПараметрыИнициализироватьДанныеДокументаДляПроведения();
	КонецЕсли;
	
	Если ТипЗнч(Документ) = Тип("ДокументОбъект.ИсправлениеРазвернутогоСальдоТоваровОрганизаций") Тогда
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
		
		ТекстЗапросаТаблицаТоварыОрганизаций(Запрос, ТекстыЗапроса, Регистры);
		ТекстЗапросаТаблицаДатыПоступленияТоваровОрганизаций(Запрос, ТекстыЗапроса, Регистры);
		ТекстЗапросаТаблицаРеестрДокументов(Запрос, ТекстыЗапроса, Регистры);
		
		РасчетСебестоимостиПроведениеДокументов.ОтразитьВМеханизмеУчетаЗатратИСебестоимости(ДокументСсылка, Запрос, ТекстыЗапроса, Регистры);
		
		ИсправлениеРазвернутогоСальдоТоваровОрганизацийЛокализация.ДополнитьТекстыЗапросовПроведения(Запрос, ТекстыЗапроса, Регистры);
	КонецЕсли;
	
	////////////////////////////////////////////////////////////////////////////
	// Получим таблицы для движений
	
	Возврат ПроведениеДокументов.ИнициализироватьДанныеДокументаДляПроведения(Запрос, ТекстыЗапроса, ДопПараметры);
	
КонецФункции

#КонецОбласти

//++ НЕ УТ

// Функция возвращает текст запроса для отражения документа в регламентированном учете.
//
// Возвращаемое значение:
//	Строка - Текст запроса
//
Функция ТекстОтраженияВРеглУчете() Экспорт

	Возврат ИсправлениеРазвернутогоСальдоТоваровОрганизацийЛокализация.ТекстОтраженияВРеглУчете();

КонецФункции

// Функция возвращает текст запроса дополнительных временных таблиц,
// необходимых для отражения в регламентированном учете.
//
// Возвращаемое значение:
//	Строка - текст запроса создания временных таблиц.
//
Функция ТекстЗапросаВТОтраженияВРеглУчете() Экспорт

	Возврат ИсправлениеРазвернутогоСальдоТоваровОрганизацийЛокализация.ТекстЗапросаВТОтраженияВРеглУчете();

КонецФункции

//-- НЕ УТ

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Проведение

Функция ТекстЗапросаТаблицаТоварыОрганизаций(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ТоварыОрганизаций";
	
	Если НЕ ПроведениеДокументов.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	Если НЕ ПроведениеДокументов.ЕстьТаблицаЗапроса("ВтТаблицаИсправлений", ТекстыЗапроса) Тогда
		ТекстЗапросаВтТаблицаИсправлений(Запрос, ТекстыЗапроса);
	КонецЕсли;
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ТаблицаИсправлений.НомерСтроки КАК НомерСтроки,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) КАК ВидДвижения,
	|	&Период КАК Период,
	|	&Организация КАК Организация,
	|	ТаблицаИсправлений.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|	НЕОПРЕДЕЛЕНО КАК КорАналитикаУчетаНоменклатуры,
	|	ТаблицаИсправлений.Номенклатура КАК Номенклатура,
	|	ТаблицаИсправлений.Характеристика КАК Характеристика,
	|	ТаблицаИсправлений.ВидЗапасовОприходования КАК ВидЗапасов,
	|	ТаблицаИсправлений.НомерГТДОприходования КАК НомерГТД,
	|	ТаблицаИсправлений.ВидЗапасовОприходования КАК КорВидЗапасов,
	|	ТаблицаИсправлений.Количество КАК Количество,
	|	ТаблицаИсправлений.КоличествоПоРНПТ КАК КоличествоПоРНПТ,
	|	&ХозяйственнаяОперация КАК ХозяйственнаяОперация,
	|	НЕОПРЕДЕЛЕНО КАК СтатьяРасходов,
	|	НЕОПРЕДЕЛЕНО КАК АналитикаРасходов,
	|	НЕОПРЕДЕЛЕНО КАК ДокументРеализации,
	|	&Организация КАК ОрганизацияОтгрузки,
	|	НЕОПРЕДЕЛЕНО КАК НалогообложениеНДС,
	|	ЛОЖЬ КАК Первичное
	|ИЗ
	|	ВтТаблицаИсправлений КАК ТаблицаИсправлений
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ТаблицаИсправлений.НомерСтроки,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход),
	|	&Период,
	|	&Организация,
	|	ТаблицаИсправлений.АналитикаУчетаНоменклатуры,
	|	ТаблицаИсправлений.АналитикаУчетаНоменклатуры,
	|	ТаблицаИсправлений.Номенклатура,
	|	ТаблицаИсправлений.Характеристика,
	|	ТаблицаИсправлений.ВидЗапасовСписания,
	|	ТаблицаИсправлений.НомерГТДСписания,
	|	ТаблицаИсправлений.ВидЗапасовСписания,
	|	ТаблицаИсправлений.Количество,
	|	ТаблицаИсправлений.КоличествоПоРНПТ,
	|	&ХозяйственнаяОперация,
	|	НЕОПРЕДЕЛЕНО,
	|	НЕОПРЕДЕЛЕНО,
	|	НЕОПРЕДЕЛЕНО,
	|	&Организация,
	|	НЕОПРЕДЕЛЕНО,
	|	ЛОЖЬ
	|ИЗ
	|	ВтТаблицаИсправлений КАК ТаблицаИсправлений
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаВтТаблицаИсправлений(Запрос, ТекстыЗапроса)
	
	ИмяРегистра = "ВтТаблицаИсправлений";
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ТаблицаТовары.Ссылка 							КАК Ссылка,
	|	ТаблицаТовары.НомерСтроки 						КАК НомерСтроки,
	|	ТаблицаТовары.АналитикаУчетаНоменклатуры 		КАК АналитикаУчетаНоменклатуры,
	|	КлючиБезНазначения.КлючАналитики				КАК АналитикаУчетаНоменклатурыБезНазначения,
	|	КлючиАналитикиУчетаНоменклатуры.Номенклатура 	КАК Номенклатура,
	|	КлючиАналитикиУчетаНоменклатуры.Характеристика 	КАК Характеристика,
	|	КлючиАналитикиУчетаНоменклатуры.Серия 			КАК Серия,
	|	КлючиАналитикиУчетаНоменклатуры.МестоХранения 	КАК Склад,
	|	КлючиАналитикиУчетаНоменклатуры.Назначение 		КАК Назначение,
	|	ТаблицаТовары.НомерГТДОприходования 			КАК НомерГТДОприходования,
	|	ТаблицаТовары.ВидЗапасовОприходования 			КАК ВидЗапасовОприходования,
	|	ТаблицаТовары.НомерГТДСписания 					КАК НомерГТДСписания,
	|	ТаблицаТовары.ВидЗапасовСписания 				КАК ВидЗапасовСписания,
	// Тип запасов в ВидЗапасовОприходования и ВидЗапасовСписания должны быть идентичны
	|	ВидыЗапасов.ТипЗапасов 							КАК ТипЗапасов,
	|	ВЫБОР 
	|		КОГДА ВидыЗапасов.ТипЗапасов = ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.КомиссионныйТовар)
	|			ТОГДА ЗНАЧЕНИЕ(Перечисление.РазделыУчетаСебестоимостиТоваров.ТоварыПринятыеНаКомиссию)
	|		КОГДА ВидыЗапасов.ТипЗапасов = ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.МатериалДавальца)
	|			ТОГДА ЗНАЧЕНИЕ(Перечисление.РазделыУчетаСебестоимостиТоваров.МатериалыПринятыеВПереработку)
	|		КОГДА ВидыЗапасов.ТипЗапасов = ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.ПолуфабрикатДавальца)
	|			ТОГДА ЗНАЧЕНИЕ(Перечисление.РазделыУчетаСебестоимостиТоваров.ТоварыПринятыеНаОтветхранение)
	|		КОГДА ВидыЗапасов.ТипЗапасов = ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.ТоварНаХраненииСПравомПродажи)
	|			ТОГДА ЗНАЧЕНИЕ(Перечисление.РазделыУчетаСебестоимостиТоваров.ТоварыНаХраненииСПравомПродажи)
	|		ИНАЧЕ ВЫБОР КОГДА КлючиАналитикиУчетаНоменклатуры.СкладскаяТерритория.ЦеховаяКладовая
	|		 ИЛИ КлючиАналитикиУчетаНоменклатуры.ТипМестаХранения = ЗНАЧЕНИЕ(Перечисление.ТипыМестХранения.Подразделение)
	|			ТОГДА ЗНАЧЕНИЕ(Перечисление.РазделыУчетаСебестоимостиТоваров.ПроизводственныеЗатраты)
	|			ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.РазделыУчетаСебестоимостиТоваров.ТоварыНаСкладах)
	|		КОНЕЦ
	|	КОНЕЦ 											КАК РазделУчета,
	|	ТаблицаТовары.Количество 						КАК Количество,
	|	ВЫБОР
	|		КОГДА НЕ &ИспользоватьУчетПрослеживаемыхИмпортныхТоваров
	|				ИЛИ НАЧАЛОПЕРИОДА(&Период, МЕСЯЦ) < &ДатаНачалаУчетаПрослеживаемыхИмпортныхТоваров
	|			ТОГДА 0
	|		ИНАЧЕ ТаблицаТовары.КоличествоПоРНПТ
	|	КОНЕЦ											КАК КоличествоПоРНПТ,
	|	ТаблицаТовары.КоличествоПолучено 				КАК КоличествоПолучено,
	|	ТаблицаТовары.КоличествоКСписанию 				КАК КоличествоКСписанию,
	|	ТаблицаТовары.ИдентификаторСтроки               КАК ИдентификаторСтроки
	|ПОМЕСТИТЬ ВтТаблицаИсправлений
	|ИЗ
	|	Документ.ИсправлениеРазвернутогоСальдоТоваровОрганизаций.Исправления КАК ТаблицаТовары
	|	ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КлючиАналитикиУчетаНоменклатуры КАК КлючиАналитикиУчетаНоменклатуры
	|		ПО ТаблицаТовары.АналитикаУчетаНоменклатуры = КлючиАналитикиУчетаНоменклатуры.Ссылка
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ВидыЗапасов КАК ВидыЗапасов
	|		ПО ТаблицаТовары.ВидЗапасовОприходования = ВидыЗапасов.Ссылка
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.АналитикаУчетаНоменклатуры КАК КлючиБезНазначения
	|	ПО КлючиБезНазначения.Номенклатура = ТаблицаТовары.АналитикаУчетаНоменклатуры.Номенклатура
	|		И КлючиБезНазначения.Характеристика = ТаблицаТовары.АналитикаУчетаНоменклатуры.Характеристика
	//++ НЕ УТ 
	|		И ЗНАЧЕНИЕ(Справочник.СтатьиКалькуляции.ПустаяСсылка) = КлючиБезНазначения.СтатьяКалькуляции
	//-- НЕ УТ
	|		И КлючиБезНазначения.Серия = ТаблицаТовары.АналитикаУчетаНоменклатуры.Серия
	|		И КлючиБезНазначения.МестоХранения = ТаблицаТовары.АналитикаУчетаНоменклатуры.МестоХранения
	|		И КлючиБезНазначения.Назначение = ЗНАЧЕНИЕ(Справочник.Назначения.ПустаяСсылка)
	|ГДЕ
	|	ТаблицаТовары.Ссылка = &Ссылка";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаТаблицаДатыПоступленияТоваровОрганизаций(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ДатыПоступленияТоваровОрганизаций";
	
	Если НЕ ПроведениеДокументов.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли; 
	
	Если НЕ ПроведениеДокументов.ЕстьТаблицаЗапроса("ВтТаблицаИсправлений", ТекстыЗапроса) Тогда
		ТекстЗапросаВтТаблицаИсправлений(Запрос, ТекстыЗапроса);
	КонецЕсли; 
	
	ТекстЗапроса = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	&Период КАК ДатаПоступления,
	|	ТаблицаИсправлений.Номенклатура КАК Номенклатура,
	|	ТаблицаИсправлений.Характеристика КАК Характеристика,
	|	ТаблицаИсправлений.Серия КАК Серия,
	|	ТаблицаИсправлений.Назначение КАК Назначение,
	|	ТаблицаИсправлений.ВидЗапасовОприходования КАК ВидЗапасов,
	|	ТаблицаИсправлений.НомерГТДОприходования КАК НомерГТД
	|ИЗ
	|	ВтТаблицаИсправлений КАК ТаблицаИсправлений
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ДатыПоступленияТоваровОрганизаций КАК ПоступленияТоваров
	|		ПО ТаблицаИсправлений.ВидЗапасовОприходования = ПоступленияТоваров.ВидЗапасов
	|			И ТаблицаИсправлений.Номенклатура = ПоступленияТоваров.Номенклатура
	|			И ТаблицаИсправлений.Характеристика = ПоступленияТоваров.Характеристика
	|			И ТаблицаИсправлений.Серия = ПоступленияТоваров.Серия
	|			И ТаблицаИсправлений.Назначение = ПоступленияТоваров.Назначение
	|			И ТаблицаИсправлений.НомерГТДОприходования = ПоступленияТоваров.НомерГТД
	|ГДЕ
	|	(ПоступленияТоваров.ДатаПоступления ЕСТЬ NULL
	|			ИЛИ ПоступленияТоваров.ДатаПоступления < &Период)
	|
	|УПОРЯДОЧИТЬ ПО
	|	ТаблицаИсправлений.ВидЗапасовОприходования,
	|	ТаблицаИсправлений.Номенклатура,
	|	ТаблицаИсправлений.Характеристика,
	|	ТаблицаИсправлений.Серия,
	|	ТаблицаИсправлений.Назначение,
	|	ТаблицаИсправлений.НомерГТДОприходования";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаТаблицаРеестрДокументов(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "РеестрДокументов";
	
	Если НЕ ПроведениеДокументов.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	&Ссылка КАК Ссылка,
	|	&Период КАК ДатаДокументаИБ,
	|	&Номер КАК НомерДокументаИБ,
	|	&ИдентификаторМетаданных КАК ТипСсылки,
	|	&Организация КАК Организация,
	|	&ХозяйственнаяОперация КАК ХозяйственнаяОперация,
	|	НЕОПРЕДЕЛЕНО КАК Партнер,
	|	НЕОПРЕДЕЛЕНО КАК Контрагент,
	|	НЕОПРЕДЕЛЕНО КАК Договор,
	|	НЕОПРЕДЕЛЕНО КАК НаправлениеДеятельности,
	|	НЕОПРЕДЕЛЕНО КАК МестоХранения,
	|	НЕОПРЕДЕЛЕНО КАК Подразделение,
	|	&Ответственный КАК Ответственный,
	|	&Комментарий КАК Комментарий,
	|	НЕОПРЕДЕЛЕНО КАК Валюта,
	|	0 КАК Сумма,
	|	НЕОПРЕДЕЛЕНО КАК Статус,
	|	&Проведен КАК Проведен,
	|	&ПометкаУдаления КАК ПометкаУдаления,
	|	ЛОЖЬ КАК ДополнительнаяЗапись,
	|	НЕОПРЕДЕЛЕНО КАК Дополнительно,
	|	&Период КАК ДатаПервичногоДокумента,
	|	&Номер КАК НомерПервичногоДокумента,
	|	ЛОЖЬ КАК СторноИсправление,
	|	НЕОПРЕДЕЛЕНО КАК СторнируемыйДокумент,
	|	НЕОПРЕДЕЛЕНО КАК ИсправляемыйДокумент,
	|	&Период КАК ДатаОтраженияВУчете,
	|	НЕОПРЕДЕЛЕНО КАК Приоритет";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция АдаптированныйТекстЗапросаДвиженийПоРегистру(ИмяРегистра) Экспорт
	
	Запрос = Новый Запрос;
	ТекстыЗапроса = Новый СписокЗначений;
	
	ПолноеИмяДокумента      = "Документ.ИсправлениеРазвернутогоСальдоТоваровОрганизаций";
	СинонимТаблицыДокумента = "";
	ВЗапросеЕстьИсточник    = Истина;
	
	ЗначенияПараметров = Новый Структура();
	ЗначенияПараметров.Вставить("ИдентификаторМетаданных",
		ОбщегоНазначения.ИдентификаторОбъектаМетаданных(ПолноеИмяДокумента));
		
	ПереопределениеРасчетаПараметров = Новый Структура;
	ПереопределениеРасчетаПараметров.Вставить(
		"ХозяйственнаяОперация", "ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.КорректировкаОбособленногоУчета)");
	
	Если ИмяРегистра = "РеестрДокументов" Тогда
		
		ТекстЗапроса = ТекстЗапросаТаблицаРеестрДокументов(Запрос, ТекстыЗапроса, ИмяРегистра);
		ВЗапросеЕстьИсточник = Ложь;
		
	Иначе
		ТекстИсключения = НСтр("ru = 'В документе %ПолноеИмяДокумента% не реализована адаптация текста запроса формирования движений по регистру %ИмяРегистра%.';
								|en = 'In document %ПолноеИмяДокумента%, adaptation of request for generating records of register %ИмяРегистра% is not implemented.'");
		ТекстИсключения = СтрЗаменить(ТекстИсключения, "%ПолноеИмяДокумента%", ПолноеИмяДокумента);
		ТекстИсключения = СтрЗаменить(ТекстИсключения, "%ИмяРегистра%", ИмяРегистра);
		
		ВызватьИсключение ТекстИсключения;
	КонецЕсли;
	
	Если ИмяРегистра = "РеестрДокументов" Тогда
		
		ТекстЗапроса = ОбновлениеИнформационнойБазыУТ.АдаптироватьЗапросПроведенияПоНезависимомуРегистру(
			ТекстЗапроса,
			ПолноеИмяДокумента,
			СинонимТаблицыДокумента,
			ВЗапросеЕстьИсточник,
			ПереопределениеРасчетаПараметров);
		
	Иначе
		
		ТекстЗапроса = ОбновлениеИнформационнойБазыУТ.АдаптироватьЗапросМеханизмаПроведения(
			ТекстЗапроса,
			ПолноеИмяДокумента,
			СинонимТаблицыДокумента,
			ПереопределениеРасчетаПараметров);
		
	КонецЕсли;
	
	Результат = ОбновлениеИнформационнойБазыУТ.РезультатАдаптацииЗапроса();
	Результат.ЗначенияПараметров = ЗначенияПараметров;
	Результат.ТекстЗапроса = ТекстЗапроса;
	
	Возврат Результат;
	
КонецФункции

Процедура ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка)
	
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ДанныеДокумента.Ссылка КАК Ссылка,
	|	ДанныеДокумента.Дата КАК Период,
	|	ДанныеДокумента.Организация КАК Организация,
	|	ДанныеДокумента.Комментарий КАК Комментарий,
	|	ДанныеДокумента.Номер КАК Номер,
	|	ДанныеДокумента.ПометкаУдаления КАК ПометкаУдаления,
	|	ДанныеДокумента.Проведен КАК Проведен,
	|	ДанныеДокумента.Ответственный КАК Ответственный
	|ИЗ
	|	Документ.ИсправлениеРазвернутогоСальдоТоваровОрганизаций КАК ДанныеДокумента
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка";
	
	Реквизиты = Запрос.Выполнить().Выбрать();
	Реквизиты.Следующий();
	
	Запрос.УстановитьПараметр("Период", 				Реквизиты.Период);
	Запрос.УстановитьПараметр("Ссылка", 				Реквизиты.Ссылка);
	Запрос.УстановитьПараметр("Организация", 			Реквизиты.Организация);
	Запрос.УстановитьПараметр("Номер", 					Реквизиты.Номер);
	Запрос.УстановитьПараметр("Комментарий", 			Реквизиты.Комментарий);
	Запрос.УстановитьПараметр("ПометкаУдаления", 		Реквизиты.ПометкаУдаления);
	Запрос.УстановитьПараметр("Проведен", 				Реквизиты.Проведен);
	Запрос.УстановитьПараметр("Ответственный", 			Реквизиты.Ответственный);
	Запрос.УстановитьПараметр("ХозяйственнаяОперация", 	Перечисления.ХозяйственныеОперации.КорректировкаОбособленногоУчета);
	Запрос.УстановитьПараметр("НастройкаХозяйственнойОперации", Справочники.НастройкиХозяйственныхОпераций.КорректировкаОбособленногоУчета);
	Запрос.УстановитьПараметр("ИдентификаторМетаданных", 
		ОбщегоНазначения.ИдентификаторОбъектаМетаданных("Документ.ИсправлениеРазвернутогоСальдоТоваровОрганизаций"));
	
	РасчетСебестоимостиПрикладныеАлгоритмы.ЗаполнитьПараметрыИнициализации(Запрос, Реквизиты);
	УчетПрослеживаемыхТоваровЛокализация.УстановитьПараметрыИспользованияУчетаПрослеживаемыхТоваров(Запрос);
	
КонецПроцедуры

#Область ПартионныйУчет

Функция ОписаниеРегистровУчетаЗатратИСебестоимости(Документ) Экспорт
	
	ОписаниеРегистров = Новый Массив;
	ОписаниеРегистров.Добавить(Метаданные.РегистрыНакопления.СебестоимостьТоваров);
	
	Возврат ОписаниеРегистров;
	
КонецФункции

Функция УстановитьДополнительныеПараметрыОперацийУчетаЗатратИСебестоимости(Документ, Запрос = Неопределено) Экспорт
	
	ДополнительныеПараметры = Новый Массив;
	
	Если Запрос <> Неопределено Тогда
		// Нет дополнительных параметров.
	КонецЕсли;
	
	Возврат ДополнительныеПараметры;
	
КонецФункции

Функция СформироватьДополнительныеТаблицыОперацийУчетаЗатратИСебестоимости(Документ, Запрос = Неопределено, ТекстыЗапроса = Неопределено) Экспорт
	
	ДополнительныеТаблицы = Новый Массив;
	ДополнительныеТаблицы.Добавить("ВтТаблицаИсправлений");
	
	Если Запрос <> Неопределено Тогда
	
		Если НЕ ПроведениеДокументов.ЕстьТаблицаЗапроса(ДополнительныеТаблицы[0], ТекстыЗапроса) Тогда
			ТекстЗапросаВтТаблицаИсправлений(Запрос, ТекстыЗапроса);
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат ДополнительныеТаблицы;
	
КонецФункции

Функция ОписаниеОперацийУчетаСебестоимости(Документ) Экспорт
	
	ОписаниеОпераций = Новый Массив;
	
	#Область Перемещение_Товар
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	// Описание документа
	|	ТаблицаДокумента.Дата 	КАК Период,
	|	ТаблицаДокумента.Ссылка КАК Ссылка,
	|	НЕОПРЕДЕЛЕНО 			КАК КорректируемыйДокумент,
	|
	// Поля учета номенклатуры
	|	ТаблицаДокумента.Организация 					 КАК Организация,
	|	ТаблицаВидыЗапасов.АналитикаУчетаНоменклатуры 	 КАК АналитикаУчетаНоменклатуры,
	|	ТаблицаВидыЗапасов.ВидЗапасовСписания			 КАК ВидЗапасов,
	|	НЕОПРЕДЕЛЕНО 			 						 КАК ВидДеятельностиНДС,
	|	НЕОПРЕДЕЛЕНО 		 							 КАК ВидДеятельностиНДСДокумента,
	|
	// Корреспондирующие поля
	|	НЕОПРЕДЕЛЕНО                                     КАК КорОрганизация,
	|	НЕОПРЕДЕЛЕНО 									 КАК КорПартия,
	|	ТаблицаВидыЗапасов.АналитикаУчетаНоменклатуры 	 КАК КорАналитикаУчетаНоменклатуры,
	|	ТаблицаВидыЗапасов.ВидЗапасовОприходования		 КАК КорВидЗапасов,
	|
	// Поля аналитики финансового учета
	|	НЕОПРЕДЕЛЕНО 						КАК Сделка,
	|	НЕОПРЕДЕЛЕНО						КАК Подразделение,
	|	ТаблицаДокумента.Ответственный		КАК Менеджер,
	|	НЕОПРЕДЕЛЕНО 						КАК ГруппаПродукции,
	|
	// Количественные и суммовые показатели
	|	ТаблицаВидыЗапасов.Количество 			КАК Количество,
	|	ТаблицаВидыЗапасов.ИдентификаторСтроки	КАК ИдентификаторСтроки,
	|
	// Прочие поля
	|	ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.КорректировкаОбособленногоУчета) КАК ХозяйственнаяОперация,
	|	ТаблицаВидыЗапасов.ИдентификаторСтроки 										 КАК ИдентификаторФинЗаписи,
	|	&НастройкаХозяйственнойОперации												 КАК НастройкаХозяйственнойОперации
	|
	|ИЗ
	|	Документ.ИсправлениеРазвернутогоСальдоТоваровОрганизаций КАК ТаблицаДокумента
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВтТаблицаИсправлений КАК ТаблицаВидыЗапасов
	|		ПО ИСТИНА
	|ГДЕ
	|	ТаблицаДокумента.Ссылка В (&Ссылка)
	|	И ТаблицаВидыЗапасов.Количество <> 0
	|	И ТаблицаВидыЗапасов.ВидЗапасовСписания <> ТаблицаВидыЗапасов.ВидЗапасовОприходования
	|";
	
	РасчетСебестоимостиПроведениеДокументов.ДобавитьОписаниеОперацииДляОтраженияВУчетеСебестоимости(
		ОписаниеОпераций,
		Перечисления.ОперацииУчетаСебестоимости.Перемещение,
		ТекстЗапроса);
		
	#КонецОбласти
	
	Возврат ОписаниеОпераций;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецОбласти

#КонецЕсли
