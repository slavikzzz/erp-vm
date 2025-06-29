
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область Команды

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
	МеханизмыДокумента.Добавить("ОсновныеСредства");
	МеханизмыДокумента.Добавить("РеестрДокументов");
	МеханизмыДокумента.Добавить("УчетПрочихАктивовПассивов");
	МеханизмыДокумента.Добавить("УчетДоходовРасходов");
	МеханизмыДокумента.Добавить("ОборотныеРегистрыУправленческогоУчета");
	
	ПереоценкаОСЛокализация.ЗарегистрироватьУчетныеМеханизмы(МеханизмыДокумента);
	
КонецПроцедуры

#КонецОбласти

// Определяет список команд создания на основании.
//
// Параметры:
//  КомандыСозданияНаОсновании - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
//  Параметры - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.Параметры
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСозданияНаОсновании, Параметры) Экспорт
	
	Команда = ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании);
	Если Команда <> Неопределено Тогда
		Команда.ВидимостьВФормах = "ФормаСписка";
	КонецЕсли;
	
	ПереоценкаОСЛокализация.ДобавитьКомандыСозданияНаОсновании(КомандыСозданияНаОсновании, Параметры);

КонецПроцедуры

// Добавляет команду создания документа "Переоценка ОС".
//
// Параметры:
//  КомандыСозданияНаОсновании - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
//  Порядок - Число - Порядок команды в меню.
//
// Возвращаемое значение:
//	СтрокаТаблицыЗначений - добавленная команда
//
Функция ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании, Порядок = 0) Экспорт
	
	Если ПравоДоступа("Добавление", Метаданные.Документы.ПереоценкаОС2_4) Тогда
		
		КомандаСоздатьНаОсновании = КомандыСозданияНаОсновании.Добавить();
		КомандаСоздатьНаОсновании.Менеджер = Метаданные.Документы.ПереоценкаОС2_4.ПолноеИмя();
		КомандаСоздатьНаОсновании.Представление = ОбщегоНазначенияУТ.ПредставлениеОбъекта(Метаданные.Документы.ПереоценкаОС2_4);
		КомандаСоздатьНаОсновании.ФункциональныеОпции = "ИспользоватьВнеоборотныеАктивы2_4";
		КомандаСоздатьНаОсновании.РежимЗаписи = "Проводить";
		КомандаСоздатьНаОсновании.Порядок = Порядок;
		
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
	
	ПереоценкаОСЛокализация.ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры);

КонецПроцедуры

#КонецОбласти

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

// СтандартныеПодсистемы.УправлениеДоступом

// Параметры:
//   Ограничение - см. УправлениеДоступомПереопределяемый.ПриЗаполненииОграниченияДоступа.Ограничение.
//
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#Область Проведение

// Возвращает таблицы для движений, необходимые для проведения документа по регистрам учетных механизмов.
//
// Параметры:
//  Документ - ДокументСсылка, ДокументОбъект - ссылка на документ или объект, по которому необходимо получить данные
//  Регистры - Структура - список имен регистров, для которых необходимо получить таблицы
//  ДопПараметры - Структура - дополнительные параметры для получения данных, определяющие контекст проведения.
//
// Возвращаемое значение:
//  Структура:
//     * Ключ - Строка - Имя таблицы.
//     * Значение - ТаблицаЗначений - таблица данных для отражения в регистр.
//
Функция ДанныеДокументаДляПроведения(Документ, Регистры, ДопПараметры = Неопределено) Экспорт
	
	Если ДопПараметры = Неопределено Тогда
		ДопПараметры = ПроведениеДокументов.ДопПараметрыИнициализироватьДанныеДокументаДляПроведения();
	КонецЕсли;
	
	Если ТипЗнч(Документ) = Тип("ДокументОбъект.ПереоценкаОС2_4") Тогда
		ДокументСсылка = Документ.Ссылка;
	Иначе
		ДокументСсылка = Документ;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	ТекстыЗапроса = Новый СписокЗначений;
	
	Если Не ДопПараметры.ПолучитьТекстыЗапроса Тогда

		ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка, ДопПараметры);
	
		ТекстыЗапроса = Новый СписокЗначений;
		
		ТекстЗапросаТаблицаРеестрДокументов(ТекстыЗапроса, Регистры);
		ТекстЗапросаТаблицаДокументыПоОС(ТекстыЗапроса, Регистры);
		
		//++ НЕ УТКА
		ВнеоборотныеАктивыСлужебный.ТекстЗапросаТаблицаОтражениеДокументовВМеждународномУчете(ТекстыЗапроса, Регистры);
		//-- НЕ УТКА
		
		ПереоценкаОСЛокализация.ДополнитьТекстыЗапросовПроведения(Запрос, ТекстыЗапроса, Регистры);
	
	КонецЕсли;
	
	ТаблицыДвижений = ПроведениеДокументов.ИнициализироватьДанныеДокументаДляПроведения(Запрос, ТекстыЗапроса, ДопПараметры);
	
	Возврат ТаблицыДвижений;
	
КонецФункции

// Формирует таблицы движений при отложенном проведении.
//
// Параметры:
//  МенеджерВременныхТаблиц - МенеджерВременныхТаблиц - Содержит временные таблицы, которые используются при формировании движений.
//
// Возвращаемое значение:
//  см. ПроведениеДокументов.ИнициализироватьДанныеДокументаДляПроведения
//
Функция ТаблицыОтложенногоФормированияДвижений(МенеджерВременныхТаблиц) Экспорт

	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	ПолучитьДанныеДокумента(Запрос);
	
	РасчетСебестоимостиПрикладныеАлгоритмы.ЗаполнитьПараметрыИнициализацииПоПериодам(Запрос, Запрос.Параметры,, "ВтСписокДокументов");

	ЗначенияПараметровПроведения = ЗначенияПараметровПроведения();
	Для каждого КлючИЗначение Из ЗначенияПараметровПроведения Цикл
		Запрос.УстановитьПараметр(КлючИЗначение.Ключ, КлючИЗначение.Значение);
	КонецЦикла;
		
	ТекстыЗапроса = Новый СписокЗначений;
	
	ВнеоборотныеАктивыСлужебный.ТекстыЗапросаПриПереоценке(Запрос, ТекстыЗапроса, "ОС", Неопределено);
	ТекстЗапросаТаблицаПараметрыАмортизацииОСБУ(ТекстыЗапроса, Неопределено);
	ТекстЗапросаТаблицаПараметрыАмортизацииОСУУ(ТекстыЗапроса, Неопределено);
	
	//++ НЕ УТКА
	ВнеоборотныеАктивыСлужебный.ТекстЗапросаТаблицаОтражениеДокументовВМеждународномУчете(ТекстыЗапроса, Неопределено);
	//-- НЕ УТКА
	
	ПереоценкаОСЛокализация.ТаблицыОтложенногоФормированияДвижений(ТекстыЗапроса);

	ТаблицыДвижений = ПроведениеДокументов.ИнициализироватьДанныеДокументаДляПроведения(Запрос, ТекстыЗапроса);
	
	Возврат ТаблицыДвижений;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Проведение

Функция ДополнительныеИсточникиДанныхДляДвижений(ИмяРегистра) Экспорт
	
	ИсточникиДанных = Новый Соответствие;
	Возврат ИсточникиДанных;
	
КонецФункции

Функция АдаптированныйТекстЗапросаДвиженийПоРегистру(ИмяРегистра) Экспорт

	ТекстыЗапроса = Новый СписокЗначений;
	
	ПолноеИмяДокумента = "Документ.ПереоценкаОС2_4";
	
	ЗначенияПараметров = ЗначенияПараметровПроведения();
	ПереопределениеРасчетаПараметров = Новый Структура;
	ПереопределениеРасчетаПараметров.Вставить("НомерНаПечать", """""");
	
	ВЗапросеЕстьИсточник = Истина;
	
	Если ИмяРегистра = "РеестрДокументов" Тогда
		
		ТекстЗапроса = ТекстЗапросаТаблицаРеестрДокументов(ТекстыЗапроса, ИмяРегистра);
		СинонимТаблицыДокумента = "ДанныеДокумента";
		
	ИначеЕсли ИмяРегистра = "ДокументыПоОС" Тогда
		
		ТекстЗапроса = ТекстЗапросаТаблицаДокументыПоОС(ТекстыЗапроса, ИмяРегистра);
		СинонимТаблицыДокумента = "ДанныеДокумента";
		
	Иначе
		ТекстИсключения = НСтр("ru = 'В документе %ПолноеИмяДокумента% не реализована адаптация текста запроса формирования движений по регистру %ИмяРегистра%.';
								|en = 'In document %ПолноеИмяДокумента%, adaptation of request for generating records of register %ИмяРегистра% is not implemented.'");
		ТекстИсключения = СтрЗаменить(ТекстИсключения, "%ПолноеИмяДокумента%", ПолноеИмяДокумента);
		ТекстИсключения = СтрЗаменить(ТекстИсключения, "%ИмяРегистра%", ИмяРегистра);
		
		ВызватьИсключение ТекстИсключения;
	КонецЕсли;
	
	Если ИмяРегистра = "РеестрДокументов"
		ИЛИ ИмяРегистра = "ДокументыПоОС" Тогда
		
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

Процедура ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка, ДопПараметры)
	
	ПроведениеДокументов.ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка, ДопПараметры);

	СформироватьТаблицуВтСписокДокументов(Запрос);
	ПолучитьДанныеДокумента(Запрос);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ДанныеДокумента.Период КАК Период,
	|	ДанныеДокумента.Номер КАК Номер
	|ИЗ
	|	ДанныеДокументаРеквизиты КАК ДанныеДокумента
	|";
	
	Результат = Запрос.Выполнить();
	Реквизиты = Результат.Выбрать();
	Реквизиты.Следующий();
	
	Для Каждого Колонка Из Результат.Колонки Цикл
		Запрос.УстановитьПараметр(Колонка.Имя, Реквизиты[Колонка.Имя]);
	КонецЦикла;
	
	ЗначенияПараметровПроведения = ЗначенияПараметровПроведения(Реквизиты);
	Для каждого КлючИЗначение Из ЗначенияПараметровПроведения Цикл
		Запрос.УстановитьПараметр(КлючИЗначение.Ключ, КлючИЗначение.Значение);
	КонецЦикла; 
	
	РасчетСебестоимостиПрикладныеАлгоритмы.ЗаполнитьПараметрыИнициализации(Запрос, Реквизиты);
	
КонецПроцедуры

Процедура СформироватьТаблицуВтСписокДокументов(Запрос)
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СписокДокументов.Ссылка КАК Ссылка,
	|	СписокДокументов.Организация КАК Организация,
	|	СписокДокументов.Дата КАК Период
	|
	|ПОМЕСТИТЬ ВтСписокДокументов
	|
	|ИЗ
	|	Документ.ПереоценкаОС2_4 КАК СписокДокументов
	|
	|ГДЕ
	|	СписокДокументов.Ссылка = &Ссылка
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Ссылка
	|";
	
	Запрос.Выполнить();
	
КонецПроцедуры

Процедура ПолучитьДанныеДокумента(Запрос)
	
	СписокЗапросов = Новый Массив;
	
	#Область ДанныеДокументаРеквизиты
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ДанныеДокумента.Ссылка              КАК Ссылка,
	|	ДанныеДокумента.Дата                КАК Период,
	|	ДанныеДокумента.Номер               КАК Номер,
	|	ДанныеДокумента.Организация         КАК Организация,
	|	ДанныеДокумента.Ответственный       КАК Ответственный,
	|	ДанныеДокумента.Комментарий         КАК Комментарий,
	|	ДанныеДокумента.Проведен            КАК Проведен,
	|	ДанныеДокумента.ПометкаУдаления     КАК ПометкаУдаления,
	|	ДанныеДокумента.ОтражатьВРеглУчете  КАК ОтражатьВРеглУчете,
	|	ДанныеДокумента.ОтражатьВУпрУчете   КАК ОтражатьВУпрУчете,
	|	ДанныеДокумента.Подразделение       КАК Подразделение,
	|	ДанныеДокумента.СтатьяДоходов       КАК СтатьяДоходов,
	|	ДанныеДокумента.АналитикаДоходов    КАК АналитикаДоходов,
	|	ДанныеДокумента.СтатьяРасходов      КАК СтатьяРасходов,
	|	ДанныеДокумента.АналитикаРасходов   КАК АналитикаРасходов,
	|	ДанныеДокумента.СобытиеОС           КАК СобытиеОС,
	|	ЕСТЬNULL(ДанныеДокумента.СтатьяРасходов.ПринятиеКналоговомуУчету, ИСТИНА) КАК ПринятиеКНалоговомуУчету,
	|	ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПереоценкаОС) КАК ХозяйственнаяОперация
	|
	|ПОМЕСТИТЬ ДанныеДокументаРеквизиты
	|
	|ИЗ
	|	Документ.ПереоценкаОС2_4 КАК ДанныеДокумента
	|
	|ГДЕ
	|	ДанныеДокумента.Ссылка В (
	|		ВЫБРАТЬ
	|			ВтСписокДокументов.Ссылка
	|		ИЗ
	|			ВтСписокДокументов КАК ВтСписокДокументов)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Ссылка";
	
	
	СписокЗапросов.Добавить(ТекстЗапроса);
	#КонецОбласти
	
	#Область ДанныеДокументаТаблицаОС
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ТаблицаДокумента.Ссылка КАК Ссылка,
	|	ТаблицаДокумента.Ссылка.Организация КАК Организация,
	|	ТаблицаДокумента.ИдентификаторСтроки КАК ИдентификаторСтроки,
	|	ТаблицаДокумента.ОсновноеСредство КАК ОбъектУчета,
	|	ТаблицаДокумента.ОсновноеСредство КАК ОсновноеСредство,
	|	ТаблицаДокумента.СтоимостьУУ КАК СтоимостьУУ,
	|	ТаблицаДокумента.СтоимостьБУ КАК СтоимостьБУ
	|
	|ПОМЕСТИТЬ ДанныеДокументаТаблицаОС
	|
	|ИЗ
	|	Документ.ПереоценкаОС2_4.ОС КАК ТаблицаДокумента
	|
	|ГДЕ
	|	ТаблицаДокумента.Ссылка В (
	|		ВЫБРАТЬ
	|			ВтСписокДокументов.Ссылка
	|		ИЗ
	|			ВтСписокДокументов КАК ВтСписокДокументов)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Ссылка,
	|	ОсновноеСредство
	|";
	СписокЗапросов.Добавить(ТекстЗапроса);
	#КонецОбласти
	
	Запрос.Текст = СтрСоединить(СписокЗапросов, ОбщегоНазначения.РазделительПакетаЗапросов());
	Запрос.Выполнить();
	
КонецПроцедуры

Функция ЗначенияПараметровПроведения(Реквизиты = Неопределено)
	
	ЗначенияПараметровПроведения = Новый Структура;
	ЗначенияПараметровПроведения.Вставить("ИдентификаторМетаданных", ОбщегоНазначения.ИдентификаторОбъектаМетаданных("Документ.ПереоценкаОС2_4"));
	ЗначенияПараметровПроведения.Вставить("НазваниеДокумента", НСтр("ru = 'Переоценка ОС';
																	|en = 'Revaluate fixed assets'"));
	ЗначенияПараметровПроведения.Вставить("СтатьяАП_ОС", ПланыВидовХарактеристик.СтатьиАктивовПассивов.ОсновныеСредства);
	ЗначенияПараметровПроведения.Вставить("ХозяйственнаяОперация", Перечисления.ХозяйственныеОперации.ПереоценкаОС);
	ЗначенияПараметровПроведения.Вставить("НастройкаХозяйственнойОперации", Справочники.НастройкиХозяйственныхОпераций.ПереоценкаОС);
	ЗначенияПараметровПроведения.Вставить("ВедетсяРегламентированныйУчетВНА", ВнеоборотныеАктивыСлужебный.ВедетсяРегламентированныйУчетВНА());
	
	ЗначенияПараметровПроведения.Вставить("ХО_УвеличениеНакопленнойАмортизации", Перечисления.ХозяйственныеОперации.УвеличениеНакопленнойАмортизацииОС);
	ЗначенияПараметровПроведения.Вставить("НастройкаХО_УвеличениеНакопленнойАмортизации", Справочники.НастройкиХозяйственныхОпераций.УвеличениеНакопленнойАмортизацииОС);

	ЗначенияПараметровПроведения.Вставить("ХО_УменьшениеНакопленнойАмортизации", Перечисления.ХозяйственныеОперации.УменьшениеНакопленнойАмортизацииОС);
	ЗначенияПараметровПроведения.Вставить("НастройкаХО_УменьшениеНакопленнойАмортизации", Справочники.НастройкиХозяйственныхОпераций.УменьшениеНакопленнойАмортизацииОС);
	
	Если Реквизиты <> Неопределено Тогда
		ЗначенияПараметровПроведения.Вставить("НомерНаПечать", ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(Реквизиты.Номер));
		ЗначенияПараметровПроведения.Вставить("КонецДня", Новый Граница(КонецДня(Реквизиты.Период), ВидГраницы.Включая));
	КонецЕсли;
	
	Возврат ЗначенияПараметровПроведения;
	
КонецФункции

Функция ТекстЗапросаТаблицаДокументыПоОС(ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ДокументыПоОС";
	
	Если НЕ ПроведениеДокументов.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ЕСТЬNULL(ТаблицаОС.НомерСтроки-1, 0)            КАК НомерЗаписи,
	|	ДанныеДокумента.Ссылка                          КАК Ссылка,
	|	ДанныеДокумента.Дата                            КАК Дата,
	|	ДанныеДокумента.Организация                     КАК Организация,
	|	ДанныеДокумента.Подразделение                   КАК Подразделение,
	|	ДанныеДокумента.Проведен                        КАК Проведен,
	|	&ХозяйственнаяОперация                          КАК ХозяйственнаяОперация,
	|	&ИдентификаторМетаданных                        КАК ТипСсылки,
	|	ДанныеДокумента.ОтражатьВРеглУчете              КАК ОтражатьВРеглУчете,
	|	ДанныеДокумента.ОтражатьВУпрУчете               КАК ОтражатьВУпрУчете,
	|	ДанныеДокумента.СобытиеОС                       КАК СобытиеОС,
	|	ТаблицаОС.ОсновноеСредство                      КАК ОсновноеСредство
	|
	|ИЗ
	|	Документ.ПереоценкаОС2_4 КАК ДанныеДокумента
	|
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ПереоценкаОС2_4.ОС КАК ТаблицаОС
	|		ПО ДанныеДокумента.Ссылка = ТаблицаОС.Ссылка
	|
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка
	|";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаТаблицаРеестрДокументов(ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "РеестрДокументов";
	
	Если НЕ ПроведениеДокументов.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ДанныеДокумента.Ссылка                  КАК Ссылка,
	|	ДанныеДокумента.Дата                    КАК ДатаДокументаИБ,
	|	ДанныеДокумента.Номер                   КАК НомерДокументаИБ,
	|	&ИдентификаторМетаданных                КАК ТипСсылки,
	|	ДанныеДокумента.Организация             КАК Организация,
	|	&ХозяйственнаяОперация                  КАК ХозяйственнаяОперация,
	|	НЕОПРЕДЕЛЕНО                            КАК НаправлениеДеятельности,
	|	ДанныеДокумента.Подразделение           КАК Подразделение,
	|	ДанныеДокумента.Ответственный           КАК Ответственный,
	|	ДанныеДокумента.Комментарий             КАК Комментарий,
	|	ДанныеДокумента.Проведен                КАК Проведен,
	|	ДанныеДокумента.ПометкаУдаления         КАК ПометкаУдаления,
	|	ЛОЖЬ                                    КАК ДополнительнаяЗапись,
	|	ДанныеДокумента.Дата                    КАК ДатаПервичногоДокумента,
	|	&НомерНаПечать                          КАК НомерПервичногоДокумента,
	|	ЛОЖЬ                                    КАК СторноИсправление,
	|	НЕОПРЕДЕЛЕНО                            КАК СторнируемыйДокумент,
	|	НЕОПРЕДЕЛЕНО                            КАК ИсправляемыйДокумент,
	|	ДанныеДокумента.Дата                    КАК ДатаОтраженияВУчете,
	|	НЕОПРЕДЕЛЕНО                            КАК Приоритет
	|
	|ИЗ
	|	Документ.ПереоценкаОС2_4 КАК ДанныеДокумента
	|
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка
	|";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

Процедура ТекстЗапросаТаблицаПараметрыАмортизацииОСБУ(ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ПараметрыАмортизацииОСБУ";
	
	Если НЕ ПроведениеДокументов.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат;
	КонецЕсли;
	
	ВнеоборотныеАктивыСлужебный.ТекстЗапросаТаблицаВтПараметрыАмортизацииОСБУ(ТекстыЗапроса);
	
	ТекстЗапроса = ПереоценкаОСЛокализация.ТекстЗапросаТаблицаПараметрыАмортизацииОСБУ();
	
	Если ТекстЗапроса = Неопределено Тогда
		
		ТекстЗапроса =
		"ВЫБРАТЬ
		|	ДанныеДокумента.Ссылка       КАК Регистратор,
		|	ДанныеДокумента.Период       КАК Период,
		|	ДанныеДокумента.Организация  КАК Организация,
		|	ТаблицаОС.ОсновноеСредство   КАК ОсновноеСредство,
		
		|	ВЫБОР 
				// Если была модернизация, то для расчета амортизации берется остаточная стоимость
		|		КОГДА ПараметрыАмортизацииОСБУ.СрокПолезногоИспользованияБУ <> ПараметрыАмортизацииОСБУ.СрокИспользованияДляВычисленияАмортизации
		|			ТОГДА ТаблицаОС.СтоимостьБУ 
		|					- (ЕСТЬNULL(ТаблицаПереоценки.НакопленнаяАмортизацияБУ, 0)
		|						+ ЕСТЬNULL(ТаблицаПереоценки.СуммаДооценкиАмортизацииБУ, 0)
		|						- ЕСТЬNULL(ТаблицаПереоценки.СуммаУценкиАмортизацииБУ, 0))
		|		ИНАЧЕ ПараметрыАмортизацииОСБУ.СтоимостьДляВычисленияАмортизации 
		|				+ ЕСТЬNULL(ТаблицаПереоценки.СуммаДооценкиСтоимостиБУ, 0)
		|				- ЕСТЬNULL(ТаблицаПереоценки.СуммаУценкиСтоимостиБУ, 0)
		|	КОНЕЦ КАК СтоимостьДляВычисленияАмортизации,
		|
		|	ПараметрыАмортизацииОСБУ.ДатаПоследнегоИзменения              КАК ДатаПоследнегоИзменения,
		|	ПараметрыАмортизацииОСБУ.СрокПолезногоИспользованияБУ         КАК СрокПолезногоИспользованияБУ,
		|	ПараметрыАмортизацииОСБУ.КоэффициентУскорения                 КАК КоэффициентУскорения,
		|	ПараметрыАмортизацииОСБУ.ЛиквидационнаяСтоимость              КАК ЛиквидационнаяСтоимость,
		|
		|	ПараметрыАмортизацииОСБУ.ОбъемПродукцииРаботДляВычисленияАмортизации КАК ОбъемПродукцииРаботДляВычисленияАмортизации,
		|	ПараметрыАмортизацииОСБУ.СрокИспользованияДляВычисленияАмортизации КАК СрокИспользованияДляВычисленияАмортизации
		|
		|ИЗ
		|	ДанныеДокументаРеквизиты КАК ДанныеДокумента
		|
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ДанныеДокументаТаблицаОС КАК ТаблицаОС
		|		ПО ДанныеДокумента.Ссылка = ТаблицаОС.Ссылка
		|
		|		ЛЕВОЕ СОЕДИНЕНИЕ ТаблицаПереоценки КАК ТаблицаПереоценки
		|		ПО ТаблицаПереоценки.Ссылка = ТаблицаОС.Ссылка
		|			И ТаблицаПереоценки.ОсновноеСредство = ТаблицаОС.ОсновноеСредство
		|
		|		ЛЕВОЕ СОЕДИНЕНИЕ втПараметрыАмортизацииОСБУ КАК ПараметрыАмортизацииОСБУ
		|		ПО ПараметрыАмортизацииОСБУ.Ссылка = ТаблицаОС.Ссылка
		|			И ПараметрыАмортизацииОСБУ.ОсновноеСредство = ТаблицаОС.ОсновноеСредство
		|
		|ГДЕ
		|	ДанныеДокумента.ОтражатьВРеглУчете";
				
	КонецЕсли;
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
КонецПроцедуры

Процедура ТекстЗапросаТаблицаПараметрыАмортизацииОСУУ(ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ПараметрыАмортизацииОСУУ";
	
	Если НЕ ПроведениеДокументов.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат;
	КонецЕсли;

	ВнеоборотныеАктивыСлужебный.ТекстЗапросаТаблицаВтПараметрыАмортизацииОСУУ(ТекстыЗапроса);
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ДанныеДокумента.Ссылка       КАК Регистратор,
	|	ДанныеДокумента.Период       КАК Период,
	|	ДанныеДокумента.Организация  КАК Организация,
	|	ТаблицаОС.ОсновноеСредство   КАК ОсновноеСредство,
	|
	|	ПараметрыАмортизацииОСУУ.ДатаПоследнегоИзменения     КАК ДатаПоследнегоИзменения,
	|	ПараметрыАмортизацииОСУУ.СрокИспользования           КАК СрокИспользования,
	|	ПараметрыАмортизацииОСУУ.КоэффициентУскорения        КАК КоэффициентУскорения,
	|	ПараметрыАмортизацииОСУУ.МетодНачисленияАмортизации  КАК МетодНачисленияАмортизации,
	|	ПараметрыАмортизацииОСУУ.ЛиквидационнаяСтоимость     КАК ЛиквидационнаяСтоимость,
	|	ПараметрыАмортизацииОСУУ.ЛиквидационнаяСтоимостьРегл КАК ЛиквидационнаяСтоимостьРегл,
	|
	|	ПараметрыАмортизацииОСУУ.ОбъемПродукцииРаботДляВычисленияАмортизации КАК ОбъемПродукцииРаботДляВычисленияАмортизации,
	|	ПараметрыАмортизацииОСУУ.СрокИспользованияДляВычисленияАмортизации КАК СрокИспользованияДляВычисленияАмортизации,
	|
	|	ВЫБОР 
			// Если была модернизация, то для расчета амортизации берется остаточная стоимость
	|		КОГДА ПараметрыАмортизацииОСУУ.СрокИспользования <> ПараметрыАмортизацииОСУУ.СрокИспользованияДляВычисленияАмортизации
	|			ТОГДА ТаблицаОС.СтоимостьУУ 
	|					- (ЕСТЬNULL(ТаблицаПереоценки.НакопленнаяАмортизацияУУ, 0)
	|						+ ЕСТЬNULL(ТаблицаПереоценки.СуммаДооценкиАмортизацииУУ, 0)
	|						- ЕСТЬNULL(ТаблицаПереоценки.СуммаУценкиАмортизацииУУ, 0))
	|		ИНАЧЕ ПараметрыАмортизацииОСУУ.СтоимостьДляВычисленияАмортизации 
	|				+ ЕСТЬNULL(ТаблицаПереоценки.СуммаДооценкиСтоимостиУУ, 0)
	|				- ЕСТЬNULL(ТаблицаПереоценки.СуммаУценкиСтоимостиУУ, 0)
	|	КОНЕЦ КАК СтоимостьДляВычисленияАмортизации,
	|
	|	ВЫБОР 
	|		КОГДА &ВедетсяРегламентированныйУчетВНА
	|			ТОГДА 0
			// Если была модернизация, то для расчета амортизации берется остаточная стоимость
	|		КОГДА ПараметрыАмортизацииОСУУ.СрокИспользования <> ПараметрыАмортизацииОСУУ.СрокИспользованияДляВычисленияАмортизации
	|			ТОГДА ТаблицаОС.СтоимостьБУ 
	|					- (ЕСТЬNULL(ТаблицаПереоценки.НакопленнаяАмортизацияБУ, 0)
	|						+ ЕСТЬNULL(ТаблицаПереоценки.СуммаДооценкиАмортизацииБУ, 0)
	|						- ЕСТЬNULL(ТаблицаПереоценки.СуммаУценкиАмортизацииБУ, 0))
	|		ИНАЧЕ ПараметрыАмортизацииОСУУ.СтоимостьДляВычисленияАмортизациирегл 
	|				+ ЕСТЬNULL(ТаблицаПереоценки.СуммаДооценкиСтоимостиБУ, 0)
	|				- ЕСТЬNULL(ТаблицаПереоценки.СуммаУценкиСтоимостиБУ, 0)
	|	КОНЕЦ КАК СтоимостьДляВычисленияАмортизацииРегл
	|
	|ИЗ
	|	ДанныеДокументаРеквизиты КАК ДанныеДокумента
	|
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ДанныеДокументаТаблицаОС КАК ТаблицаОС
	|		ПО ДанныеДокумента.Ссылка = ТаблицаОС.Ссылка
	|
	|		ЛЕВОЕ СОЕДИНЕНИЕ ТаблицаПереоценки КАК ТаблицаПереоценки
	|		ПО ТаблицаПереоценки.ОсновноеСредство = ТаблицаОС.ОсновноеСредство
	|
	|		ЛЕВОЕ СОЕДИНЕНИЕ втПараметрыАмортизацииОСУУ КАК ПараметрыАмортизацииОСУУ
	|		ПО (ПараметрыАмортизацииОСУУ.Организация = ТаблицаОС.Организация)
	|			И (ПараметрыАмортизацииОСУУ.ОсновноеСредство = ТаблицаОС.ОсновноеСредство)
	|
	|ГДЕ
	|	ДанныеДокумента.ОтражатьВУпрУчете
	|";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
КонецПроцедуры

#КонецОбласти

#Область ПроведениеПоРеглУчету

Функция ТекстЗапросаВТОтраженияВРеглУчете() Экспорт

	Возврат ПереоценкаОСЛокализация.ТекстЗапросаВТОтраженияВРеглУчете();

КонецФункции

Функция ТекстОтраженияВРеглУчете() Экспорт

	Возврат ПереоценкаОСЛокализация.ТекстОтраженияВРеглУчете();

КонецФункции

#КонецОбласти

#Область Печать

// Заполняет список команд печати.
//
// Параметры:
//   КомандыПечати - см. УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	ПереоценкаОСЛокализация.ДобавитьКомандыПечати(КомандыПечати);

КонецПроцедуры

#КонецОбласти

#Область ОбновлениеРегистров

// Формирует таблицу движений регистра "ПараметрыАмортизацииОСБУ".
// Используется в обработчике обновления регистра.
// 
// Параметры:
//  Регистратор - ДокументСсылка.ПереоценкаОС2_4 -
//  ТекстыЗапроса - СписокЗначений -
// 
// Возвращаемое значение:
//  ТаблицаЗначений - Таблица регистра
Функция ОбновитьТаблицуПараметрыАмортизацииОСБУ(Регистратор, ТекстыЗапроса) Экспорт
		
	Запрос = Новый Запрос;
	ЗаполнитьПараметрыИнициализации(Запрос, Регистратор, Неопределено);
	
	// Нужно сформировать временные таблицы, которые используются в запросе.
	ВнеоборотныеАктивыСлужебный.ТекстЗапросаТаблицаВтСписокОС(ТекстыЗапроса);

	#Область ТаблицаПереоценки
	ИмяТаблицы = "ТаблицаПереоценки";
	Если НЕ ПроведениеДокументов.ЕстьТаблицаЗапроса(ИмяТаблицы, ТекстыЗапроса) Тогда
		ТекстЗапроса = 
		"ВЫБРАТЬ
		|	&Ссылка КАК Ссылка,
		|	ДанныеРегистра.ОсновноеСредство КАК ОсновноеСредство,
		|
		|	0 КАК НакопленнаяАмортизацияБУ,
		|
		|	ВЫБОР
		|		КОГДА ДанныеРегистра.СрокПолезногоИспользованияБУ <> ДанныеРегистра.СрокИспользованияДляВычисленияАмортизации
		|			ТОГДА ТаблицаОС.СтоимостьБУ - ДанныеРегистра.СтоимостьДляВычисленияАмортизации
		|		ИНАЧЕ ДанныеРегистра.СтоимостьДляВычисленияАмортизации - ЕСТЬNULL(ПараметрыАмортизацииОСБУ.СтоимостьДляВычисленияАмортизации, 0)
		|	КОНЕЦ КАК СуммаДооценкиАмортизацииБУ,
		|
		|	ВЫБОР
		|		КОГДА ДанныеРегистра.СрокПолезногоИспользованияБУ <> ДанныеРегистра.СрокИспользованияДляВычисленияАмортизации
		|			ТОГДА 0
		|		ИНАЧЕ ДанныеРегистра.СтоимостьДляВычисленияАмортизации - ЕСТЬNULL(ПараметрыАмортизацииОСБУ.СтоимостьДляВычисленияАмортизации, 0)
		|	КОНЕЦ КАК СуммаДооценкиСтоимостиБУ,
		|
		|	ВЫБОР
		|		КОГДА ДанныеРегистра.СрокПолезногоИспользованияБУ <> ДанныеРегистра.СрокИспользованияДляВычисленияАмортизации
		|			ТОГДА ДанныеРегистра.СтоимостьДляВычисленияАмортизацииЦФ
		|		ИНАЧЕ 0
		|	КОНЕЦ КАК ТекущаяСтоимостьЦФ,
		|
		|	ВЫБОР
		|		КОГДА ДанныеРегистра.СрокПолезногоИспользованияБУ <> ДанныеРегистра.СрокИспользованияДляВычисленияАмортизации
		|			ТОГДА 0
		|		ИНАЧЕ ЕСТЬNULL(ПараметрыАмортизацииОСБУ.СтоимостьДляВычисленияАмортизацииЦФ, 0) - ДанныеРегистра.СтоимостьДляВычисленияАмортизацииЦФ
		|	КОНЕЦ КАК СуммаУценкиСтоимостиЦФ,
		|
		|	0 КАК СуммаУценкиАмортизацииБУ,
		|	0 КАК СуммаУценкиСтоимостиБУ,
		|	0 КАК НакопленнаяАмортизацияЦФ,
		|	0 КАК СуммаУценкиАмортизацииЦФ
		|
		|ПОМЕСТИТЬ ТаблицаПереоценки
		|
		|ИЗ
		|	Документ.ПереоценкаОС2_4.ОС КАК ТаблицаОС
		|
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ПараметрыАмортизацииОСБУ КАК ДанныеРегистра
		|		ПО ДанныеРегистра.Регистратор = ТаблицаОС.Ссылка
		|			И ДанныеРегистра.ОсновноеСредство = ТаблицаОС.ОсновноеСредство
		|
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПараметрыАмортизацииОСБУ.СрезПоследних(
		|				&Период,
		|				Регистратор <> &Ссылка
		|					И ДатаИсправления = ДАТАВРЕМЯ(1,1,1)
		|					И &Организация = Организация
		|					И ОсновноеСредство В
		|						(ВЫБРАТЬ СписокОС.ОсновноеСредство ИЗ втСписокОС КАК СписокОС)) КАК ПараметрыАмортизацииОСБУ
		|		ПО (ПараметрыАмортизацииОСБУ.Организация = &Организация)
		|			И (ПараметрыАмортизацииОСБУ.ОсновноеСредство = ТаблицаОС.ОсновноеСредство)
		|
		|ГДЕ
		|	ТаблицаОС.Ссылка = &Ссылка";
		ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяТаблицы);
	КонецЕсли;
	#КонецОбласти
	
	ТекстЗапросаТаблицаПараметрыАмортизацииОСБУ(ТекстыЗапроса, Неопределено);
	
	МассивЗапросов = Новый Массив;
	Для Каждого ЭлементСписка Из ТекстыЗапроса Цикл
		МассивЗапросов.Добавить(ЭлементСписка.Значение);
	КонецЦикла;
	Запрос.Текст = СтрСоединить(МассивЗапросов, ОбщегоНазначения.РазделительПакетаЗапросов());
	Запрос.УстановитьПараметр("Ссылка", Регистратор);
	
	ТаблицаРегистра = Запрос.Выполнить().Выгрузить();
		
	Возврат ТаблицаРегистра;
	
КонецФункции

#КонецОбласти

#Область Прочее

Функция ПараметрыВыбораСтатейИАналитик() Экспорт
	
	ПараметрыВыбораСтатьиИАналитики = Новый Массив;
	
	// СтатьяРасходов
	ПараметрыВыбора = ДоходыИРасходыСервер.ПараметрыВыбораСтатьиИАналитики();
	ПараметрыВыбора.ПутьКДанным = "Объект";
	ПараметрыВыбора.Статья = "СтатьяРасходов";
	ПараметрыВыбора.ДоступностьПоОперации = Неопределено;
	
	ПараметрыВыбора.ВыборСтатьиРасходов = Истина;
	ПараметрыВыбора.АналитикаРасходов = "АналитикаРасходов";
	
	ПараметрыВыбора.ЭлементыФормы.Статья.Добавить("СтатьяРасходов");
	ПараметрыВыбора.ЭлементыФормы.АналитикаРасходов.Добавить("АналитикаРасходов");
	
	ПараметрыВыбораСтатьиИАналитики.Добавить(ПараметрыВыбора);
	
	// СтатьяДоходов
	ПараметрыВыбора = ДоходыИРасходыСервер.ПараметрыВыбораСтатьиИАналитики();
	ПараметрыВыбора.ПутьКДанным = "Объект";
	ПараметрыВыбора.Статья = "СтатьяДоходов";
	ПараметрыВыбора.ДоступностьПоОперации = Неопределено;
	
	ПараметрыВыбора.ВыборСтатьиДоходов = Истина;
	ПараметрыВыбора.АналитикаДоходов = "АналитикаДоходов";
	
	ПараметрыВыбора.ЭлементыФормы.Статья.Добавить("СтатьяДоходов");
	ПараметрыВыбора.ЭлементыФормы.АналитикаДоходов.Добавить("АналитикаДоходов");
	
	ПараметрыВыбораСтатьиИАналитики.Добавить(ПараметрыВыбора);
	
	Возврат ПараметрыВыбораСтатьиИАналитики;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли
