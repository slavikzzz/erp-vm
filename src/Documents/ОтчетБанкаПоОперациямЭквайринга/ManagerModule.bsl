#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Формирует описание реквизитов объекта, заполняемых по статистике их использования.
//
// Параметры:
//  ОписаниеРеквизитов - Структура - описание реквизитов, для которых необходимо получить значения по статистике
//
//
Процедура ЗадатьОписаниеЗаполняемыхРеквизитовПоСтатистике(ОписаниеРеквизитов) Экспорт
	
	ЗаполнениеОбъектовПоСтатистике.ДобавитьОписаниеЗаполняемыхРеквизитов(ОписаниеРеквизитов, "Организация, Подразделение");
	
	Параметры = ЗаполнениеОбъектовПоСтатистике.ПараметрыЗаполняемыхРеквизитов();
	Параметры.РазрезыСбораСтатистики.ИспользоватьВсегда = "Организация";
	Параметры.ЗаполнятьПриУсловии.ПоляОбъектаЗаполнены = "Организация";
	ЗаполнениеОбъектовПоСтатистике.ДобавитьОписаниеЗаполняемыхРеквизитов(ОписаниеРеквизитов, "ДоговорЭквайринга", Параметры);
	
	Параметры = ЗаполнениеОбъектовПоСтатистике.ПараметрыЗаполняемыхРеквизитов();
	Параметры.РазрезыСбораСтатистики.ИспользоватьВсегда = "ДоговорЭквайринга";
	Параметры.ЗаполнятьПриУсловии.ПоляОбъектаЗаполнены = "ДоговорЭквайринга";
	ЗаполнениеОбъектовПоСтатистике.ДобавитьОписаниеЗаполняемыхРеквизитов(ОписаниеРеквизитов, "СтатьяРасходов", Параметры);
	
	Параметры = ЗаполнениеОбъектовПоСтатистике.ПараметрыЗаполняемыхРеквизитов();
	Параметры.РазрезыСбораСтатистики.ИспользоватьВсегда = "СтатьяРасходов";
	Параметры.ЗаполнятьПриУсловии.ПоляОбъектаЗаполнены = "СтатьяРасходов";
	ЗаполнениеОбъектовПоСтатистике.ДобавитьОписаниеЗаполняемыхРеквизитов(ОписаниеРеквизитов, "АналитикаРасходов", Параметры);
	
	Параметры = ЗаполнениеОбъектовПоСтатистике.ПараметрыЗаполняемыхРеквизитов();
	Параметры.РазрезыСбораСтатистики.ИспользоватьТолькоЗаполненные = "Организация, Подразделение";
	ЗаполнениеОбъектовПоСтатистике.ДобавитьОписаниеЗаполняемыхРеквизитов(
		ОписаниеРеквизитов, "Ответственный", Параметры);
	
КонецПроцедуры

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
	МеханизмыДокумента.Добавить("ОборотныеРегистрыУправленческогоУчета");
	МеханизмыДокумента.Добавить("РеестрДокументов");
	МеханизмыДокумента.Добавить("СуммыДокументовВВалютахУчета");
	МеханизмыДокумента.Добавить("УчетДенежныхСредств");
	МеханизмыДокумента.Добавить("УчетДоходовРасходов");
	МеханизмыДокумента.Добавить("УчетПрочихАктивовПассивов");
	МеханизмыДокумента.Добавить("ИсправлениеДокументов");
	
	ОтчетБанкаПоОперациямЭквайрингаЛокализация.ЗарегистрироватьУчетныеМеханизмы(МеханизмыДокумента);
	
КонецПроцедуры

// Возвращает таблицы для движений, необходимые для проведения документа по регистрам учетных механизмов.
//
// Параметры:
//  Документ - ДокументСсылка, ДокументОбъект - ссылка на документ или объект, по которому необходимо получить данные
//  Регистры - Структура - список имен регистров, для которых необходимо получить таблицы
//  ДопПараметры - Структура - дополнительные параметры для получения данных, определяющие контекст проведения.
//
// Возвращаемое значение:
//  - СписокЗначений - содержит тексты запросов и их имена, возвращается, если свойство ПолучитьТекстыЗапроса параметра
//  					ДопПараметры имеет значение Истина.
//  - Структура - содержит таблицы данных для загрузки в регистры.
//
Функция ДанныеДокументаДляПроведения(Документ, Регистры, ДопПараметры = Неопределено) Экспорт
	
	Если ДопПараметры = Неопределено Тогда
		ДопПараметры = ПроведениеДокументов.ДопПараметрыИнициализироватьДанныеДокументаДляПроведения();
	КонецЕсли;
	
	Если ТипЗнч(Документ) = Тип("ДокументОбъект.ОтчетБанкаПоОперациямЭквайринга") Тогда
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
		СформироватьСуммыДокументаВВалютахУчета(Запрос, ТекстыЗапроса, Регистры);
		
		ТекстЗапросаРасчетыПоЭквайрингу(Запрос, ТекстыЗапроса, Регистры);
		ТекстЗапросаДенежныеСредстваВПути(Запрос, ТекстыЗапроса, Регистры);
		ТекстЗапросаТаблицаПрочиеРасходы(Запрос, ТекстыЗапроса, Регистры);
		ТекстЗапросаТаблицаПрочиеАктивыПассивы(Запрос, ТекстыЗапроса, Регистры);
		ТекстЗапросаТаблицаДвиженияДенежныеСредстваДоходыРасходы(Запрос, ТекстыЗапроса, Регистры);
		ТекстЗапросаТаблицаРеестрДокументов(Запрос, ТекстыЗапроса, Регистры);
		
		// Выполение запроса и выгрузка полученных таблиц для формирования движений
		ОтчетБанкаПоОперациямЭквайрингаЛокализация.ДополнитьТекстыЗапросовПроведения(Запрос, ТекстыЗапроса, Регистры);
	КонецЕсли;
	
	ПроведениеДокументов.ДобавитьЗапросыСторноДвижений(Запрос, ТекстыЗапроса, Регистры, ПустаяСсылка().Метаданные());
	
	////////////////////////////////////////////////////////////////////////////
	// Получим таблицы для движений
	
	Возврат ПроведениеДокументов.ИнициализироватьДанныеДокументаДляПроведения(Запрос, ТекстыЗапроса, ДопПараметры);
	
КонецФункции

#КонецОбласти

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет список команд создания на основании.
//
// Параметры:
//  КомандыСозданияНаОсновании - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
//  Параметры - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.Параметры
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСозданияНаОсновании, Параметры) Экспорт
	
	БизнесПроцессы.Задание.ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании);
	
	ИсправлениеДокументов.ДобавитьКомандыСозданияНаОсновании(КомандыСозданияНаОсновании, ПустаяСсылка().Метаданные());
	
	ОтчетБанкаПоОперациямЭквайрингаЛокализация.ДобавитьКомандыСозданияНаОсновании(КомандыСозданияНаОсновании, Параметры);

КонецПроцедуры

// Добавляет команду создания документа "Отчет банка по эквайрингу".
//
// Параметры:
//  КомандыСозданияНаОсновании - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
//
// Возвращаемое значение:
//  - СтрокаТаблицыЗначений - строка данных, определяющая параметры команды ввода на основании.
//  - Неопределено - если нет права на создание документа "Отчет банка по эквайрингу".
//
Функция ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании) Экспорт
	Если ПравоДоступа("Добавление", Метаданные.Документы.ОтчетБанкаПоОперациямЭквайринга) Тогда
		КомандаСоздатьНаОсновании = КомандыСозданияНаОсновании.Добавить();
		КомандаСоздатьНаОсновании.Менеджер = Метаданные.Документы.ОтчетБанкаПоОперациямЭквайринга.ПолноеИмя();
		КомандаСоздатьНаОсновании.Представление = ОбщегоНазначенияУТ.ПредставлениеОбъекта(Метаданные.Документы.ОтчетБанкаПоОперациямЭквайринга);
		КомандаСоздатьНаОсновании.РежимЗаписи = "Проводить";
		КомандаСоздатьНаОсновании.ФункциональныеОпции = "ИспользоватьОплатуПлатежнымиКартами";
	

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
	
	ОтчетБанкаПоОперациямЭквайрингаЛокализация.ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры);

КонецПроцедуры

// Заполняет список команд печати.
//
// Параметры:
//   КомандыПечати - см. УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт

	ОтчетБанкаПоОперациямЭквайрингаЛокализация.ДобавитьКомандыПечати(КомандыПечати);

КонецПроцедуры

// Определяет свойства полей формы в зависимости от данных
//
// Параметры:
//	Настройки - ТаблицаЗначений - таблица с колонками:
//		* Поля - Массив - поля, для которых определяются настройки отображения
//		* Условие - ОтборКомпоновкиДанных - условия применения настройки
//		* Свойства - Структура - имена и значения свойств
//
Процедура ЗаполнитьНастройкиПолейФормы(Настройки) Экспорт
	
	Финансы = ФинансоваяОтчетностьСервер;
	Операции = Перечисления.ХозяйственныеОперации;
	
	// 
	Элемент = Настройки.Добавить();
	Элемент.Поля.Добавить("СтраницаПокупки");
	Элемент.Поля.Добавить("СтраницаВозвраты");
	Элемент.Поля.Добавить("СуммаПокупок");
	Элемент.Поля.Добавить("СуммаВозвратов");
	Финансы.НовыйОтбор(Элемент.Условие, "ДетальнаяСверкаТранзакций", Истина);
	Элемент.Свойства.Вставить("Видимость");
	
	// 
	Элемент = Настройки.Добавить();
	Элемент.Поля.Добавить("СтраницаКомиссия");
	Элемент.Поля.Добавить("СуммаКомиссии");
	Финансы.НовыйОтбор(Элемент.Условие, "ОтражатьКомиссию", Истина);
	Элемент.Свойства.Вставить("Видимость");
	
	// НадписьВалюта
	Элемент = Настройки.Добавить();
	Элемент.Поля.Добавить("НадписьВалютаКомиссия");
	Финансы.НовыйОтбор(Элемент.Условие, "Дополнительно.ИспользоватьНесколькоВалют", Ложь);
	Элемент.Свойства.Вставить("Видимость");
	
	// ЭквайринговыйТерминал
	Элемент = Настройки.Добавить();
	Элемент.Поля.Добавить("ПокупкиЭквайринговыйТерминал");
	Элемент.Поля.Добавить("ВозвратыЭквайринговыйТерминал");
	Финансы.НовыйОтбор(Элемент.Условие, "Дополнительно.ИспользуютсяЭквайринговыеТерминалы", Истина);
	Элемент.Свойства.Вставить("Видимость");
	
	// КодАвторизации
	Элемент = Настройки.Добавить();
	Элемент.Поля.Добавить("ПокупкиКодАвторизации");
	Элемент.Поля.Добавить("ВозвратыКодАвторизации");
	Финансы.НовыйОтбор(Элемент.Условие,
		"Дополнительно.СпособПроведенияПлатежа",
		Перечисления.СпособыПроведенияПлатежей.СистемаБыстрыхПлатежей,,
		ВидСравненияКомпоновкиДанных.НеРавно);
	Элемент.Свойства.Вставить("Видимость");
	
	// ИдентификаторОплатыСБП
	Элемент = Настройки.Добавить();
	Элемент.Поля.Добавить("ПокупкиИдентификаторОплатыСБП");
	Элемент.Поля.Добавить("ВозвратыИдентификаторОплатыСБП");
	Финансы.НовыйОтбор(Элемент.Условие,
		"Дополнительно.СпособПроведенияПлатежа",
		Перечисления.СпособыПроведенияПлатежей.СистемаБыстрыхПлатежей,,
		ВидСравненияКомпоновкиДанных.Равно);
	Элемент.Свойства.Вставить("Видимость");
	
КонецПроцедуры

// Возвращает параметры выбора статей в документе.
// 
// Возвращаемое значение:
// 	Массив - Массив параметров настройки счетов учета (См. ДоходыИРасходыСервер.ПараметрыВыбораСтатьиИАналитики)
//
Функция ПараметрыВыбораСтатейИАналитик() Экспорт
	
	МассивПаметровВыбора = Новый Массив;
	
	#Область СтатьяРасходов
	ПараметрыВыбора = ДоходыИРасходыСервер.ПараметрыВыбораСтатьиИАналитики();
	ПараметрыВыбора.ПутьКДанным = "Объект";
	ПараметрыВыбора.Статья = "СтатьяРасходов";
	ПараметрыВыбора.ТипСтатьи = "ТипСтатьи";
	ПараметрыВыбора.ЭлементыФормы.Статья.Добавить("СтатьяРасходов");
	
	#Область АналитикаРасходов
	ПараметрыВыбора.ВыборСтатьиРасходов = Истина;
	ПараметрыВыбора.АналитикаРасходов = "АналитикаРасходов";
	ПараметрыВыбора.ЭлементыФормы.АналитикаРасходов.Добавить("АналитикаРасходов");
	#КонецОбласти
	
	МассивПаметровВыбора.Добавить(ПараметрыВыбора);
	#КонецОбласти
		
	Возврат МассивПаметровВыбора;
	
КонецФункции

//++ НЕ УТ

// Функция возвращает текст запроса для отражения документа в регламентированном учете.
//
// Возвращаемое значение:
//	Строка - Текст запроса
//
Функция ТекстОтраженияВРеглУчете() Экспорт

	Возврат ОтчетБанкаПоОперациямЭквайрингаЛокализация.ТекстОтраженияВРеглУчете();

КонецФункции

// Функция возвращает текст запроса дополнительных временных таблиц,
// необходимых для отражения в регламентированном учете.
//
// Возвращаемое значение:
//	Строка - текст запроса создания временных таблиц.
//
Функция ТекстЗапросаВТОтраженияВРеглУчете() Экспорт

	Возврат ОтчетБанкаПоОперациямЭквайрингаЛокализация.ТекстЗапросаВТОтраженияВРеглУчете();

КонецФункции

//-- НЕ УТ

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// Параметры:
//   Ограничение - см. УправлениеДоступомПереопределяемый.ПриЗаполненииОграниченияДоступа.Ограничение.
//
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)
	|	И ЗначениеРазрешено(Подразделение)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Проведение

Функция ДополнительныеИсточникиДанныхДляДвижений(ИмяРегистра) Экспорт

	ИсточникиДанных = Новый Соответствие;

	Возврат ИсточникиДанных; 

КонецФункции

Функция АдаптированныйТекстЗапросаДвиженийПоРегистру(ИмяРегистра) Экспорт
	
	Запрос = Новый Запрос;
	ТекстыЗапроса = Новый СписокЗначений;
	ПереопределениеРасчетаПараметров = Новый Структура;
	СинонимТаблицыДокумента = "";
	
	ПолноеИмяДокумента = "Документ.ОтчетБанкаПоОперациямЭквайринга";
	
	Если ИмяРегистра = "РеестрДокументов" Тогда
		
		ТекстЗапроса = ТекстЗапросаТаблицаРеестрДокументов(Запрос, ТекстыЗапроса, ИмяРегистра);
		СинонимТаблицыДокумента = "ДанныеДокумента";
		
	Иначе
		ТекстИсключения = НСтр("ru = 'В документе %ПолноеИмяДокумента% не реализована адаптация текста запроса формирования движений по регистру %ИмяРегистра%.';
								|en = 'In document %ПолноеИмяДокумента%, adaptation of request for generating records of register %ИмяРегистра% is not implemented.'");
		ТекстИсключения = СтрЗаменить(ТекстИсключения, "%ПолноеИмяДокумента%", ПолноеИмяДокумента);
		ТекстИсключения = СтрЗаменить(ТекстИсключения, "%ИмяРегистра%", ИмяРегистра);
		ВызватьИсключение ТекстИсключения;
	КонецЕсли;
	
	Если ИмяРегистра = "РеестрДокументов" Тогда
		ТекстЗапроса = ОбновлениеИнформационнойБазыУТ.АдаптироватьЗапросПроведенияПоНезависимомуРегистру(
			ТекстЗапроса, ПолноеИмяДокумента, СинонимТаблицыДокумента, Истина, ПереопределениеРасчетаПараметров);
	Иначе
		ТекстЗапроса = ОбновлениеИнформационнойБазыУТ.АдаптироватьЗапросМеханизмаПроведения(
			ТекстЗапроса, ПолноеИмяДокумента, СинонимТаблицыДокумента);
	КонецЕсли;
	
	Результат = ОбновлениеИнформационнойБазыУТ.РезультатАдаптацииЗапроса();
	Результат.ЗначенияПараметров = ЗначенияПараметровПроведения();
	Результат.ТекстЗапроса = ТекстЗапроса;
	
	Возврат Результат;
	
КонецФункции

Процедура ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка)
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ДанныеДокумента.Ссылка                           КАК Ссылка,
	|	ДанныеДокумента.Дата                             КАК Период,
	|	ДанныеДокумента.Номер                            КАК Номер,
	|	ДанныеДокумента.Валюта                           КАК Валюта,
	|	ДанныеДокумента.Организация                      КАК Организация,
	|	ДанныеДокумента.Организация.ВалютаРегламентированногоУчета КАК ВалютаРегламентированногоУчета,
	|	ДанныеДокумента.Автор                            КАК Автор,
	|	ДанныеДокумента.ДоговорЭквайринга                КАК ДоговорЭквайринга,
	|	ДанныеДокумента.ДоговорЭквайринга.БанковскийСчет КАК БанковскийСчет,
	|	ДанныеДокумента.ДоговорЭквайринга.Контрагент     КАК Эквайер,
	|	ДанныеДокумента.ДоговорЭквайринга.ДетальнаяСверкаТранзакций     КАК ДетальнаяСверкаТранзакций,	
	|	ДанныеДокумента.ДоговорЭквайринга.СтатьяДвиженияДенежныхСредствПоступлениеОплаты КАК СтатьяДвиженияДенежныхСредствПоступлениеОплаты,
	|	ДанныеДокумента.ДоговорЭквайринга.СтатьяДвиженияДенежныхСредствВозврат КАК СтатьяДвиженияДенежныхСредствВозврат,
	|	ДанныеДокумента.Подразделение                    КАК Подразделение,
	|	ДанныеДокумента.СуммаКомиссии                    КАК СуммаКомиссии,
	|	ДанныеДокумента.СуммаДокумента                   КАК СуммаДокумента,
	|	ДанныеДокумента.Исправление                      КАК Исправление,
	|	ДанныеДокумента.СторнируемыйДокумент             КАК СторнируемыйДокумент,
	|	ДанныеДокумента.ИсправляемыйДокумент             КАК ИсправляемыйДокумент,
	|	ДанныеДокумента.ПометкаУдаления                  КАК ПометкаУдаления,
	|	ДанныеДокумента.Проведен                         КАК Проведен
	|ИЗ
	|	Документ.ОтчетБанкаПоОперациямЭквайринга КАК ДанныеДокумента
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка
	|";
	
	Результат = Запрос.Выполнить();
	Реквизиты = Результат.Выбрать();
	Реквизиты.Следующий();
	
	Для Каждого Колонка Из Результат.Колонки Цикл
		Запрос.УстановитьПараметр(Колонка.Имя, Реквизиты[Колонка.Имя]);
	КонецЦикла;
	
	Для каждого КлючИЗначение Из ЗначенияПараметровПроведения(Реквизиты) Цикл
		Запрос.УстановитьПараметр(КлючИЗначение.Ключ, КлючИЗначение.Значение);
	КонецЦикла;
	
	Запрос.УстановитьПараметр("НастройкаХозяйственнойОперации", Справочники.НастройкиХозяйственныхОпераций.ОтчетБанкаПоОперациямЭквайринга);
	
	РасчетСебестоимостиПрикладныеАлгоритмы.ЗаполнитьПараметрыИнициализации(Запрос, Реквизиты);
	
КонецПроцедуры

Функция ЗначенияПараметровПроведения(Реквизиты = Неопределено)
	
	Значения = Новый Структура;
	Значения.Вставить("ИдентификаторМетаданных",                         ОбщегоНазначения.ИдентификаторОбъектаМетаданных("Документ.ОтчетБанкаПоОперациямЭквайринга"));
	Значения.Вставить("ХозяйственнаяОперация",                           Перечисления.ХозяйственныеОперации.ОтчетБанкаПоОперациямЭквайринга);
	Значения.Вставить("ВалютаУправленческогоУчета",                      Константы.ВалютаУправленческогоУчета.Получить());
	
	Если Реквизиты <> Неопределено Тогда
		Коэффициенты = РаботаСКурсамивалютУТ.ПолучитьКоэффициентыПересчетаВалюты(
			Реквизиты.Валюта, Неопределено, Реквизиты.Период, Реквизиты.Организация);
			
		Значения.Вставить("КоэффициентПересчетаВВалютуУпр",              Коэффициенты.КоэффициентПересчетаВВалютуУпр);
		Значения.Вставить("КоэффициентПересчетаВВалютуРегл",             Коэффициенты.КоэффициентПересчетаВВалютуРегл);
		Значения.Вставить("НомерНаПечать",                               ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(Реквизиты.Номер));
	КонецЕсли;
	
	Возврат Значения;
	
КонецФункции

Функция ТекстЗапросаРасчетыПоЭквайрингу(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "РасчетыПоЭквайрингу";
	
	Если НЕ ПроведениеДокументов.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	Платежи.НомерСтроки КАК НомерСтроки,
	|	&Период КАК Период,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) КАК ВидДвижения,
	|	
	|	Платежи.ДатаПлатежа КАК ДатаПлатежа,
	|	Платежи.ЭквайринговыйТерминал КАК ЭквайринговыйТерминал,
	|	&ДоговорЭквайринга КАК Договор,
	|	&Организация КАК Организация,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыДенежныхСредствПоЭквайрингу.ПоступлениеПоПлатежнойКарте) КАК ТипДенежныхСредств,
	|	&Валюта КАК Валюта,
	|	
	|	ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ОтчетБанкаПоОперациямЭквайринга) КАК ХозяйственнаяОперация,
	|	&СтатьяДвиженияДенежныхСредствПоступлениеОплаты КАК СтатьяДвиженияДенежныхСредств,
	|	Платежи.КодАвторизации КАК КодАвторизации,
	|	Платежи.НомерПлатежнойКарты КАК НомерПлатежнойКарты,
	|	
	|	Платежи.Сумма КАК Сумма
	|	
	|ИЗ
	|	Документ.ОтчетБанкаПоОперациямЭквайринга.Покупки КАК Платежи
	|	
	|ГДЕ
	|	Платежи.Ссылка = &Ссылка
	|	И &ДетальнаяСверкаТранзакций = ИСТИНА	
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	Платежи.НомерСтроки КАК НомерСтроки,
	|	&Период КАК Период,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) КАК ВидДвижения,
	|	
	|	Платежи.ДатаПлатежа КАК ДатаПлатежа,
	|	Платежи.ЭквайринговыйТерминал КАК ЭквайринговыйТерминал,
	|	&ДоговорЭквайринга КАК Договор,
	|	&Организация КАК Организация,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыДенежныхСредствПоЭквайрингу.СписаниеПоПлатежнойКарте) КАК ТипДенежныхСредств,
	|	&Валюта КАК Валюта,
	|	
	|	ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ОтчетБанкаПоОперациямЭквайринга) КАК ХозяйственнаяОперация,
	|	&СтатьяДвиженияДенежныхСредствВозврат КАК СтатьяДвиженияДенежныхСредств,
	|	Платежи.КодАвторизации КАК КодАвторизации,
	|	Платежи.НомерПлатежнойКарты КАК НомерПлатежнойКарты,
	|	
	|	Платежи.Сумма КАК Сумма
	|	
	|ИЗ
	|	Документ.ОтчетБанкаПоОперациямЭквайринга.Возвраты КАК Платежи
	|	
	|ГДЕ
	|	Платежи.Ссылка = &Ссылка
	|	И &ДетальнаяСверкаТранзакций = ИСТИНА
	|	
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки
	|";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаДенежныеСредстваВПути(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ДенежныеСредстваВПути";
	
	Если НЕ ПроведениеДокументов.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)                                               КАК ВидДвижения,
	|	ДанныеДокумента.Дата                                                                 КАК Период,
	|	
	|	ДанныеДокумента.Организация                                                          КАК Организация,
	|	ДанныеДокумента.ДоговорЭквайринга.БанковскийСчет                                     КАК Получатель,
	|	НЕОПРЕДЕЛЕНО                                                                         КАК Отправитель,
	|	ЗНАЧЕНИЕ(Перечисление.ВидыПереводовДенежныхСредств.ПоступлениеОтБанкаПоЭквайрингу)   КАК ВидПереводаДенежныхСредств,
	|	ДанныеДокумента.ДоговорЭквайринга.Контрагент                                         КАК Контрагент,
	|	ДанныеДокумента.ДоговорЭквайринга                                                    КАК Договор,
	|	ДанныеДокумента.Валюта                                                               КАК Валюта,
	|	
	|	ДанныеДокумента.СуммаКомиссии                                                               КАК Сумма,
	|	ВЫРАЗИТЬ(ДанныеДокумента.СуммаКомиссии * &КоэффициентПересчетаВВалютуУпр КАК ЧИСЛО(31,2))   КАК СуммаУпр,
	|	ВЫРАЗИТЬ(ДанныеДокумента.СуммаКомиссии * &КоэффициентПересчетаВВалютуРегл  КАК ЧИСЛО(31,2)) КАК СуммаРегл,
	|	
	|	ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.КомиссияПоЭквайрингу)                    КАК ХозяйственнаяОперация,
	|	ДанныеДокумента.ДоговорЭквайринга.СтатьяДвиженияДенежныхСредствКомиссия              КАК СтатьяДвиженияДенежныхСредств,
	|	
	|	ДанныеДокумента.ИдентификаторДокумента                                               КАК ИдентификаторФинЗаписи,
	|	ЗНАЧЕНИЕ(Справочник.НастройкиХозяйственныхОпераций.ОтчетБанкаПоОперациямЭквайринга)             КАК НастройкаХозяйственнойОперации 
	|	
	|ИЗ
	|	Документ.ОтчетБанкаПоОперациямЭквайринга КАК ДанныеДокумента
	|	
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка
	|	И ДанныеДокумента.СуммаКомиссии <> 0
	|	И ДанныеДокумента.ОтражатьКомиссию
	|";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаТаблицаВтИсходныеПрочиеРасходы(Запрос, ТекстыЗапроса) Экспорт
	
	ИмяРегистра = "ВтИсходныеПрочиеРасходы";
	
	СформироватьСуммыДокументаВВалютахУчета(Запрос, ТекстыЗапроса);
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	ДанныеДокумента.Дата КАК Период,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) КАК ВидДвижения,
	|	ДанныеДокумента.Организация КАК Организация,
	|	ДанныеДокумента.ДоговорЭквайринга.НаправлениеДеятельности КАК НаправлениеДеятельности,
	|	ДанныеДокумента.СтатьяРасходов КАК СтатьяРасходов,
	|	ДанныеДокумента.АналитикаРасходов КАК АналитикаРасходов,
	|	ДанныеДокумента.Подразделение КАК Подразделение,
	|	НЕОПРЕДЕЛЕНО КАК ВидДеятельностиНДС,
	|	
		// Рассчитаем сумму в валюте управленческого учета.
	|	ВЫРАЗИТЬ(ДанныеДокумента.СуммаКомиссии * &КоэффициентПересчетаВВалютуУпр КАК ЧИСЛО(31,2)) КАК СуммаСНДС,
	|	ВЫРАЗИТЬ(ДанныеДокумента.СуммаКомиссии * &КоэффициентПересчетаВВалютуУпр КАК ЧИСЛО(31,2)) КАК СуммаБезНДС,
	|	ВЫРАЗИТЬ(ДанныеДокумента.СуммаКомиссии * &КоэффициентПересчетаВВалютуУпр КАК ЧИСЛО(31,2)) КАК СуммаБезНДСУпр,
	|
	|	ЕСТЬNULL(СуммыДокументовВВалютахУчета.СуммаБезНДСРегл, ДанныеДокумента.СуммаКомиссии) КАК СуммаСНДСРегл,
	|	ЕСТЬNULL(СуммыДокументовВВалютахУчета.СуммаБезНДСРегл, ДанныеДокумента.СуммаКомиссии) КАК СуммаБезНДСРегл,
	|	0 КАК ПостояннаяРазница,
	|	0 КАК ВременнаяРазница,
	|	ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.КомиссияПоЭквайрингу) КАК ХозяйственнаяОперация,
	|	НЕОПРЕДЕЛЕНО КАК АналитикаУчетаНоменклатуры,
	|	
	|	ДанныеДокумента.ИдентификаторДокумента КАК ИдентификаторФинЗаписи,
	|	&НастройкаХозяйственнойОперации        КАК НастройкаХозяйственнойОперации 
	|
	|ПОМЕСТИТЬ ВтИсходныеПрочиеРасходы
	|ИЗ
	|	Документ.ОтчетБанкаПоОперациямЭквайринга КАК ДанныеДокумента
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		втСуммыДокументовВВалютахУчета КАК СуммыДокументовВВалютахУчета
	|	ПО
	|		СуммыДокументовВВалютахУчета.Ссылка = ДанныеДокумента.Ссылка
	|		И СуммыДокументовВВалютахУчета.ИдентификаторСтроки = ""1""
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка
	|	И ДанныеДокумента.СуммаКомиссии <> 0
	|	И ДанныеДокумента.ОтражатьКомиссию
	|";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаТаблицаВтПрочиеРасходы(Запрос, ТекстыЗапроса) Экспорт
	
	ИмяРегистра = "ВтПрочиеРасходы";
	
	Если Не ПроведениеДокументов.ЕстьТаблицаЗапроса("ВтИсходныеПрочиеРасходы", ТекстыЗапроса) Тогда
		ТекстЗапросаТаблицаВтИсходныеПрочиеРасходы(Запрос, ТекстыЗапроса);
	КонецЕсли;
	
	ТекстЗапроса = РегистрыНакопления.ПрочиеРасходы.ТекстЗапросаТаблицаВтПрочиеРасходы();
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаТаблицаПрочиеРасходы(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ПрочиеРасходы";
	
	Если НЕ ПроведениеДокументов.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	Если Не ПроведениеДокументов.ЕстьТаблицаЗапроса("ВтПрочиеРасходы", ТекстыЗапроса) Тогда
		ТекстЗапросаТаблицаВтПрочиеРасходы(Запрос, ТекстыЗапроса);
	КонецЕсли;
	
	ТекстЗапроса = РегистрыНакопления.ПрочиеРасходы.ТекстЗапросаТаблицаПрочиеРасходы();
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаТаблицаДвиженияДенежныеСредстваДоходыРасходы(Запрос, ТекстыЗапроса, Регистры)

	ИмяРегистра = "ДвиженияДенежныеСредстваДоходыРасходы";
	
	Если НЕ ПроведениеДокументов.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	&Период КАК Период,
	|	Значение(Перечисление.ХозяйственныеОперации.КомиссияПоЭквайрингу) КАК ХозяйственнаяОперация,
	|	ДанныеДокумента.Организация КАК Организация,
	|	ДанныеДокумента.ДоговорЭквайринга.БанковскийСчет.Подразделение КАК Подразделение,
	|	ДанныеДокумента.ДоговорЭквайринга.БанковскийСчет.НаправлениеДеятельности КАК НаправлениеДеятельностиДС,
	|	ДанныеДокумента.Подразделение КАК ПодразделениеДоходовРасходов,
	|
	|	ДанныеДокумента.ДоговорЭквайринга КАК ДенежныеСредства,
	|	Значение(Перечисление.ТипыДенежныхСредств.ДенежныеСредстваУЭквайера) КАК ТипДенежныхСредств,
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(ДанныеДокумента.ДоговорЭквайринга.СтатьяДвиженияДенежныхСредствКомиссия, ЗНАЧЕНИЕ(Справочник.СтатьиДвиженияДенежныхСредств.ПустаяСсылка)) = ЗНАЧЕНИЕ(Справочник.СтатьиДвиженияДенежныхСредств.ПустаяСсылка) ТОГДА
	|			ЗНАЧЕНИЕ(Справочник.СтатьиДвиженияДенежныхСредств.ОплатаПоставщику)
	|		ИНАЧЕ
	|			ДанныеДокумента.ДоговорЭквайринга.СтатьяДвиженияДенежныхСредствКомиссия
	|	КОНЕЦ КАК СтатьяДвиженияДенежныхСредств,
	|	ДанныеДокумента.Валюта КАК Валюта,
	|
	|	ДанныеДокумента.ДоговорЭквайринга.НаправлениеДеятельности КАК НаправлениеДеятельностиСтатьи,
	|	ДанныеДокумента.СтатьяРасходов КАК СтатьяДоходовРасходов,
	|	НЕОПРЕДЕЛЕНО КАК АналитикаДоходов,
	|	ДанныеДокумента.АналитикаРасходов КАК АналитикаРасходов,
	|
	|	ВЫРАЗИТЬ(ДанныеДокумента.СуммаКомиссии * &КоэффициентПересчетаВВалютуУпр КАК ЧИСЛО(31,2)) КАК Сумма,
	|	ВЫРАЗИТЬ(ДанныеДокумента.СуммаКомиссии * &КоэффициентПересчетаВВалютуРегл КАК ЧИСЛО(31,2)) КАК СуммаРегл,
	|	ДанныеДокумента.СуммаКомиссии КАК СуммаВВалюте,
	|
	|	НЕОПРЕДЕЛЕНО КАК ИсточникГФУДенежныхСредств,
	|	ДанныеДокумента.СтатьяРасходов КАК ИсточникГФУДоходовРасходов
	|
	|ИЗ
	|	Документ.ОтчетБанкаПоОперациямЭквайринга КАК ДанныеДокумента
	|
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка
	|	И ДанныеДокумента.СуммаКомиссии <> 0
	|";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);

	Возврат ТекстЗапроса;

КонецФункции

Процедура СформироватьСуммыДокументаВВалютахУчета(Запрос, ТекстыЗапроса, Регистры = Неопределено) Экспорт
	
	ТекстЗапросаДанных = "
	|ВЫБРАТЬ
	|	""ОтчетБанкаПоОперациямЭквайринга"" КАК ИсточникДанных,
	|	ЛОЖЬ КАК РаспределятьОбщуюСумму,
	|	ТаблицаДокумента.Ссылка КАК Ссылка,
	|	ТаблицаДокумента.Дата КАК Дата,
	|	ТаблицаДокумента.Организация КАК Организация,
	|	ТаблицаДокумента.Валюта КАК ВалютаДокумента,
	|	НЕОПРЕДЕЛЕНО КАК ВалютаВзаиморасчетов,
	|	НЕОПРЕДЕЛЕНО КАК ПериодБазыНДС,
	|	ТаблицаДокумента.Дата КАК ДатаКурса,
	|
	|	0 КАК НомерСтроки,
	|	""1"" КАК ИдентификаторСтроки,
	|	ТаблицаДокумента.СуммаКомиссии КАК СуммаБезНДС,
	|	НЕОПРЕДЕЛЕНО КАК СтавкаНДС,
	|	0 КАК СуммаНДС,
	|	0 КАК СуммаВзаиморасчетов,
	|	0 КАК СуммаНДСВзаиморасчетов,
	|	0 КАК СуммаБезНДСРегл,
	|	0 КАК СуммаБезНДСУпр,
	|
	|	ЛОЖЬ КАК ОтражаетсяВРасчетах,
	|	НЕОПРЕДЕЛЕНО КАК ОбъектРасчетов,
	|	ЛОЖЬ КАК ПересчитыватьПоДаннымРасчетов
	|ИЗ
	|	Документ.ОтчетБанкаПоОперациямЭквайринга КАК ТаблицаДокумента
	|
	|ГДЕ
	|	ТаблицаДокумента.Ссылка В (&Ссылка)
	|";
	
	РегистрыСведений.СуммыДокументовВВалютахУчета.СформироватьПоДаннымДокумента(
		Запрос, ТекстыЗапроса, Регистры, ТекстЗапросаДанных);

КонецПроцедуры

Функция ТекстЗапросаТаблицаПрочиеАктивыПассивы(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ПрочиеАктивыПассивы";
	
	Если НЕ ПроведениеДокументов.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	Если Не ПроведениеДокументов.ЕстьТаблицаЗапроса("ВтПрочиеРасходы", ТекстыЗапроса) Тогда
		ТекстЗапросаТаблицаВтПрочиеРасходы(Запрос, ТекстыЗапроса);
	КонецЕсли;
	
	ТекстЗапроса = РегистрыНакопления.ПрочиеАктивыПассивы.ТекстЗапросаТаблицаПрочиеАктивыПассивы(Ложь);
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаТаблицаРеестрДокументов(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "РеестрДокументов";
	
	Если НЕ ПроведениеДокументов.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	&ИдентификаторМетаданных                КАК ТипСсылки,
	|	&ХозяйственнаяОперация                  КАК ХозяйственнаяОперация,
	|	&Организация                            КАК Организация,
	|	НЕОПРЕДЕЛЕНО                            КАК Партнер,
	|	ДанныеДокумента.ДоговорЭквайринга.БанковскийСчет КАК МестоХранения,
	|	ДанныеДокумента.ДоговорЭквайринга.Контрагент     КАК Контрагент,
	|	&Подразделение                          КАК Подразделение,
	|	&Период                                 КАК ДатаДокументаИБ,
	|	&Ссылка                                 КАК Ссылка,
	
	|	&Номер                                  КАК НомерДокументаИБ,
	|	НЕОПРЕДЕЛЕНО                            КАК Статус,
	|	НЕОПРЕДЕЛЕНО                            КАК Ответственный,
	|	&Автор                                  КАК Автор,
	|	ЛОЖЬ                                    КАК ДополнительнаяЗапись,
	|	НЕОПРЕДЕЛЕНО                            КАК Дополнительно,
	|	НЕОПРЕДЕЛЕНО                            КАК Комментарий,
	|	&Проведен                               КАК Проведен,
	|	&ПометкаУдаления                        КАК ПометкаУдаления,
	|	&Период                                 КАК ДатаПервичногоДокумента,
	|	&НомерНаПечать                          КАК НомерПервичногоДокумента,
	|	&СуммаДокумента                         КАК Сумма,
	|	&Валюта                                 КАК Валюта,
	|	&ДоговорЭквайринга                      КАК Договор,
	|	НЕОПРЕДЕЛЕНО                            КАК НаправлениеДеятельности,
	|	&Исправление                            КАК СторноИсправление,
	|	&СторнируемыйДокумент                   КАК СторнируемыйДокумент,
	|	&ИсправляемыйДокумент                   КАК ИсправляемыйДокумент,
	|	&Период                                 КАК ДатаОтраженияВУчете,
	|	НЕОПРЕДЕЛЕНО                            КАК Приоритет
	|ИЗ
	|	Документ.ОтчетБанкаПоОперациямЭквайринга КАК ДанныеДокумента
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка
	|";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

#КонецОбласти

// Определяет состав документов и хозяйственных операций, доступных для отображения в рабочем месте.
//
// Параметры:
//  ХозяйственныеОперацииИДокументы	 - ТаблицаЗначений - таблица значений с колонками:
//     * ХозяйственнаяОперация					 - ПеречислениеСсылка.ХозяйственныеОперации
//     * ИдентификаторОбъектаМетаданных			 - СправочникСсылка.ИдентификаторыОбъектовМетаданных
//     * Отбор									 - Булево
//     * ДокументПредставление					 - Строка
//     * ПолноеИмяДокумента						 - Строка
//     * Накладная								 - Булево
//     * ИспользуетсяРаспоряжение				 - Булево
//     * ИспользуютсяСтатусы					 - Булево
//     * ПоНесколькимЗаказам					 - Булево
//     * ПриходныйОрдерНевозможен				 - Булево
//     * РазделятьДокументыПоПодразделению		 - Булево
//     * ПолноеИмяНакладной						 - Строка
//     * КлючНазначенияИспользования			 - Строка
//     * ПравоДоступаДобавление					 - Булево
//     * ПравоДоступаИзменение					 - Булево
//     * ЗаголовокРабочегоМеста					 - Строка
//     * ИменаЭлементовСУправляемойВидимостью	 - Строка
//     * ИменаЭлементовРабочегоМеста			 - Строка
//     * ИменаОтображаемыхЭлементов				 - Строка
//     * МенеджерРасчетаГиперссылкиКОформлению	 - Строка
// 
// Возвращаемое значение:
//   - ТаблицаЗначений - таблица значений с колонками:
//     * ХозяйственнаяОперация					 - ПеречислениеСсылка.ХозяйственныеОперации
//     * ИдентификаторОбъектаМетаданных			 - СправочникСсылка.ИдентификаторыОбъектовМетаданных
//     * Отбор									 - Булево
//     * ДокументПредставление					 - Строка
//     * ПолноеИмяДокумента						 - Строка
//     * Накладная								 - Булево
//     * ИспользуетсяРаспоряжение				 - Булево
//     * ИспользуютсяСтатусы					 - Булево
//     * ПоНесколькимЗаказам					 - Булево
//     * ПриходныйОрдерНевозможен				 - Булево
//     * РазделятьДокументыПоПодразделению		 - Булево
//     * ПолноеИмяНакладной						 - Строка
//     * КлючНазначенияИспользования			 - Строка
//     * ПравоДоступаДобавление					 - Булево
//     * ПравоДоступаИзменение					 - Булево
//     * ЗаголовокРабочегоМеста					 - Строка
//     * ИменаЭлементовСУправляемойВидимостью	 - Строка
//     * ИменаЭлементовРабочегоМеста			 - Строка
//     * ИменаОтображаемыхЭлементов				 - Строка
//     * МенеджерРасчетаГиперссылкиКОформлению	 - Строка.
//
//
Функция ИнициализироватьХозяйственныеОперацииИДокументы(ХозяйственныеОперацииИДокументы) Экспорт
	
	ПолноеИмяДокумента = Метаданные.Документы.ОтчетБанкаПоОперациямЭквайринга.ПолноеИмя();
	
	Строка = ХозяйственныеОперацииИДокументы.Добавить();
	Строка.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПустаяСсылка();
	Строка.ИдентификаторОбъектаМетаданных = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(ПолноеИмяДокумента);
	Строка.ПолноеИмяДокумента = ПолноеИмяДокумента;
	Строка.КлючНазначенияИспользования = "Отчет банка по операциям эквайринга";
	Строка.ЗаголовокРабочегоМеста = НСтр("ru = 'Отчет банка по операциям эквайринга';
										|en = 'Merchant statement'");
	Строка.Порядок = 1;
	Строка.ДобавитьКнопкуСоздать = Истина;
	Строка.ПравоДоступаДобавление = ПравоДоступа("Добавление", Метаданные.Документы.ОтчетБанкаПоОперациямЭквайринга);;
	Строка.ПравоДоступаИзменение = ПравоДоступа("Изменение", Метаданные.Документы.ОтчетБанкаПоОперациямЭквайринга);;
	Строка.Отбор = Истина;
	
	Возврат ХозяйственныеОперацииИДокументы;
	
КонецФункции

#КонецОбласти

#КонецЕсли
