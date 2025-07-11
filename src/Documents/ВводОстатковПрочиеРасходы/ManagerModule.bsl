#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает параметры выбора статей и аналитик.
// 
// Возвращаемое значение:
// 	Структура - Параметры выбора статей и аналитик (См. ДоходыИРасходыСервер.ПараметрыВыбораСтатьиИАналитики).
//
Функция ПараметрыВыбораСтатейИАналитик() Экспорт
	
	ПараметрыВыбораСтатейИАналитик = Новый Массив;
	
	#Область ПрочиеРасходы
	
	// СтатьяРасходов
	ПараметрыВыбора = ДоходыИРасходыСервер.ПараметрыВыбораСтатьиИАналитики();
	ПараметрыВыбора.ПутьКДанным           = "Объект.ПрочиеРасходы";
	ПараметрыВыбора.Статья                = "СтатьяРасходов";
	ПараметрыВыбора.ДоступностьПоОперации = Неопределено;
	ПараметрыВыбора.ВыборСтатьиРасходов   = Истина;
	ПараметрыВыбора.АналитикаРасходов     = "АналитикаРасходов";
	
	ПараметрыВыбора.ЭлементыФормы.Статья.Добавить("ПрочиеРасходыСтатьяРасходов");
	ПараметрыВыбора.ЭлементыФормы.АналитикаРасходов.Добавить("ПрочиеРасходыАналитикаРасходов");
	
	ПараметрыВыбораСтатейИАналитик.Добавить(ПараметрыВыбора);
	
	#КонецОбласти
	
	Возврат ПараметрыВыбораСтатейИАналитик;
	
КонецФункции

#Область Проведение

// Возвращает таблицы для движений, необходимые для проведения документа по регистрам учетных механизмов.
//
// Параметры:
//  Документ - ДокументСсылка, ДокументОбъект - ссылка на документ или объект, по которому необходимо получить данные
//  Регистры - Структура - список имен регистров, для которых необходимо получить таблицы
//  ДопПараметры - Структура - дополнительные параметры для получения данных, определяющие контекст проведения.
//
// Возвращаемое значение:
//  Структура - коллекция элементов:
//     Таблица<ИмяРегистра> - таблица данных для отражения в регистр.
//
Функция ДанныеДокументаДляПроведения(Документ, Регистры, ДопПараметры = Неопределено) Экспорт
	
	Если ТипЗнч(Документ) = Тип("ДокументОбъект.ВводОстатковПрочиеРасходы") Тогда
		ДокументСсылка = Документ.Ссылка;
	Иначе
		ДокументСсылка = Документ;
	КонецЕсли;
	
	////////////////////////////////////////////////////////////////////////////
	// Создадим запрос инициализации движений
	
	Запрос = Новый Запрос;
	ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка);
	
	////////////////////////////////////////////////////////////////////////////
	// Сформируем текст запроса
	
	ТекстыЗапроса = Новый СписокЗначений;
	ТекстЗапросаТаблицаПрочиеРасходы(Запрос, ТекстыЗапроса, Регистры);
	ТекстЗапросаТаблицаПартииПрочихРасходов(Запрос, ТекстыЗапроса, Регистры);
	ТекстЗапросаТаблицаРеестрДокументов(Запрос, ТекстыЗапроса, Регистры);
	
	ВводОстатковЛокализация.ВводОстатковПрочиеРасходыДополнитьТекстыЗапросовПроведения(Запрос, ТекстыЗапроса, Регистры);
	
	ПроведениеДокументов.ДобавитьЗапросыСторноДвижений(Запрос, ТекстыЗапроса, Регистры, ПустаяСсылка().Метаданные());
	
	////////////////////////////////////////////////////////////////////////////
	// Получим таблицы для движений
	
	Возврат ПроведениеДокументов.ИнициализироватьДанныеДокументаДляПроведения(Запрос, ТекстыЗапроса, ДопПараметры);
	
КонецФункции

// Описывает учетные механизмы используемые в документе для регистрации в механизме проведения.
//
// Параметры:
//  МеханизмыДокумента - Массив - список имен учетных механизмов, для которых будет выполнена
//              регистрация в механизме проведения.
//
Процедура ЗарегистрироватьУчетныеМеханизмы(МеханизмыДокумента) Экспорт
	
	МеханизмыДокумента.Добавить("УчетПрочихАктивовПассивов");
	МеханизмыДокумента.Добавить("УчетДоходовРасходов");
	МеханизмыДокумента.Добавить("СебестоимостьИПартионныйУчет");
	МеханизмыДокумента.Добавить("РеестрДокументов");
	МеханизмыДокумента.Добавить("ИсправлениеДокументов");
	//++ НЕ УТКА
	МеханизмыДокумента.Добавить("МеждународныйУчет");
	//-- НЕ УТКА
	
	ВводОстатковЛокализация.ВводОстатковПрочиеРасходыЗарегистрироватьУчетныеМеханизмы(МеханизмыДокумента);
	
КонецПроцедуры

#КонецОбласти

#Область СозданиеНаОсновании

// Определяет список команд создания на основании.
//
// Параметры:
//  КомандыСозданияНаОсновании - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
//  Параметры - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.Параметры
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСозданияНаОсновании, Параметры) Экспорт
	
	БизнесПроцессы.Задание.ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании);
	Обработки.СправочноеРазмещениеНоменклатуры.ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании);
	ВводОстатковЛокализация.ДобавитьКомандыСозданияНаОсновании(КомандыСозданияНаОсновании, Параметры);
	ИсправлениеДокументов.ДобавитьКомандыСозданияНаОсновании(КомандыСозданияНаОсновании, ПустаяСсылка().Метаданные());
	
КонецПроцедуры

#КонецОбласти

#Область Отчеты

// Определяет список команд отчетов.
//
// Параметры:
//   КомандыОтчетов - См. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.КомандыОтчетов
//   Параметры - См. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.Параметры
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры) Экспорт
	ВводОстатковЛокализация.ВводОстатковПрочиеРасходыДобавитьКомандыОтчетов(КомандыОтчетов, Параметры);
КонецПроцедуры

#КонецОбласти

//++ НЕ УТ
#Область ПроведениеРегламентированныйУчет

// Функция возвращает текст запроса для отражения документа в регламентированном учете.
//
// Возвращаемое значение:
//	Строка - Текст запроса
//
Функция ТекстОтраженияВРеглУчете() Экспорт
	Возврат ВводОстатковЛокализация.ВводОстатковПрочиеРасходыТекстОтраженияВРеглУчете();
КонецФункции

// Функция возвращает текст запроса дополнительных временных таблиц,
// необходимых для отражения в регламентированном учете.
//
// Возвращаемое значение:
//  Строка - Содержащая текст запроса временных таблиц для отражения в регл. учете.
//
Функция ТекстЗапросаВТОтраженияВРеглУчете() Экспорт
	Возврат ВводОстатковЛокализация.ВводОстатковПрочиеРасходыТекстЗапросаВТОтраженияВРеглУчете();
КонецФункции

#КонецОбласти

#Область ЗаполнениеПоДаннымОперативногоУчета

// Возвращает таблицу значения для заполнения документа ввода остатков данными, полученными по данным оперативного учета.
// 
// Параметры:
// 	Дата - Дата - Дата, на которую формируются остатки.
// 	ХозяйственнаяОперация - ПеречислениеСсылка.ХозяйственныеОперации - Хозяйственная операция, для которой выбираются остатки
// 	Организации - Массив - Массив, содержащий элементы типа СправочникСсылка.Организации, для которых выбираются остатки.
// 	ДополнительныйОтбор - Структура - Структура, содержащая ключ и значение дополнительного отбора.
// 	ПараметрыЗаполненияОстатков - Структура - Структура, содержащая дополнительные параметры необходимые, для заполнения остатков.
// Возвращаемое значение:
// 	ТаблицаЗначений, Неопределено - Если для данной хозяйственной операции есть данные, для нее возвращается таблица значений с значениями заполнения.
//
Функция ОстаткиПоТипуОперации(Дата, ХозяйственнаяОперация, Организации, ДополнительныйОтбор = Неопределено, ПараметрыЗаполненияОстатков = Неопределено) Экспорт
	
	ДатаОстатков = Новый Граница(Дата, ВидГраницы.Включая);
	
	Если ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВводОстатковПрочихРасходов Тогда
		
		Возврат ОстаткиПоПрочимРасходам(ДатаОстатков, Организации, ДополнительныйОтбор);
		
	КонецЕсли;
	
КонецФункции

// Возвращает массив в котором содержатся имена полей при изменении которых, необходимо генерировать новый документ ввода остатков.
// 
// Параметры:
// 	ХозяйственнаяОперация - ПеречислениеСсылка.ХозяйственныеОперации - Хозяйственная операция, для которой определяются ключевые поля.
// Возвращаемое значение:
// 	Массив - Массив содержащий имена полей.
//
Функция КлючевыеПоляРеглУчетаПоТипуОперации(ХозяйственнаяОперация) Экспорт
	
	МассивКлючевыхПолей = Новый Массив;
	МассивКлючевыхПолей.Добавить("Организация");
	МассивКлючевыхПолей.Добавить("Подразделение");
	
	Возврат МассивКлючевыхПолей;
	
КонецФункции

#КонецОбласти
//-- НЕ УТ

#Область ДляВызоваИзДругихПодсистем

// Добавляет команду создания документа на основании.
//
// Параметры:
//  КомандыСозданияНаОсновании - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
//  Параметры - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.Параметры
//
// Возвращаемое значение:
//	КомандаФормы - добавляемая команда.
//
Функция ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании) Экспорт
	
	Возврат СозданиеНаОсновании.ДобавитьКомандуСозданияНаОсновании(КомандыСозданияНаОсновании, Метаданные.Документы.ВводОстатковПрочиеРасходы);
	
КонецФункции

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

#Область ИнициализацияДокументаИПараметровДокумента

// Инициализация параметры регистрации счетов фактур полученных
//  Параметры:
//    ДанныеОбъекта - ДокументОбъект.ВводОстатковПрочиеРасходы - Объект документа ввода остатков
//
//  Возвращаемое значение:
//    См. УчетНДСУПКлиентСервер.ПараметрыЗаполненияВидаДеятельностиНДС
Функция ИнициализироватьПараметрыВидовДеятельностиНДС(ДанныеОбъекта) Экспорт
	
	ПараметрыЗаполнения = УчетНДСУПКлиентСервер.ПараметрыЗаполненияВидаДеятельностиНДС();
	ПараметрыЗаполнения.Организация             = ДанныеОбъекта.Организация;
	ПараметрыЗаполнения.Дата                    = ДанныеОбъекта.Дата;
	ПараметрыЗаполнения.ПриобретениеТоваров     = Истина;
	
	Возврат ПараметрыЗаполнения;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)

	ВыбраннаяОперация = Неопределено;
	
	Если Параметры.Свойство("Ключ") И ЗначениеЗаполнено(Параметры.Ключ) Тогда
		ВыбраннаяОперация = Параметры.Ключ.ХозяйственнаяОперация;
	ИначеЕсли Параметры.Свойство("ЗначенияЗаполнения") Тогда
		Параметры.ЗначенияЗаполнения.Свойство("ХозяйственнаяОперация", ВыбраннаяОперация);
	ИначеЕсли Параметры.Свойство("ЗначениеКопирования") Тогда
		ВыбраннаяОперация = ОбщегоНазначенияУТВызовСервера.ЗначениеРеквизитаОбъекта(Параметры.ЗначениеКопирования,"ХозяйственнаяОперация");
	ИначеЕсли Параметры.Свойство("ОтборПоТипамОпераций") И Параметры.ОтборПоТипамОпераций.Количество() = 1 Тогда
		ВыбраннаяОперация = Параметры.ОтборПоТипамОпераций[0].Значение;
		ЗначенияЗаполнения = Новый Структура;
		ЗначенияЗаполнения.Вставить("ХозяйственнаяОперация", ВыбраннаяОперация);
		Параметры.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
		Если Параметры.Свойство("Организация") Тогда
			ЗначенияЗаполнения.Вставить("Организация", Параметры.Организация);
		КонецЕсли;
		Если Параметры.Свойство("ОтражатьВОперативномУчете") Тогда
			ЗначенияЗаполнения.Вставить("ОтражатьВОперативномУчете", Параметры.ОтражатьВОперативномУчете);
		КонецЕсли;
		Если Параметры.Свойство("ОтражатьСебестоимость") Тогда
			ЗначенияЗаполнения.Вставить("ОтражатьСебестоимость", Параметры.ОтражатьСебестоимость);
		КонецЕсли;
		Если Параметры.Свойство("ОтражатьВБУиНУ") Тогда
			ЗначенияЗаполнения.Вставить("ОтражатьВБУиНУ", Параметры.ОтражатьВБУиНУ);
		КонецЕсли;
		Если Параметры.Свойство("ОтражатьВУУ") Тогда
			ЗначенияЗаполнения.Вставить("ОтражатьВУУ", Параметры.ОтражатьВУУ);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПолученияПолейПредставления(Поля, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Поля.Добавить("Ссылка");
	Поля.Добавить("Номер");
	Поля.Добавить("Дата");
	Поля.Добавить("ХозяйственнаяОперация");
	
КонецПроцедуры

Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если Данные.Ссылка <> Неопределено Тогда
		Представление = ВводОстатковВызовСервера.ЗаголовокДокументаВводОстатковПоХозяйственнойОперации(Данные.Ссылка,
			Данные.Номер,
			Данные.Дата,
			Данные.ХозяйственнаяОперация);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

#Область Проведение

Процедура ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка)
	
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.Текст = "ВЫБРАТЬ
		|	ДанныеДокумента.Дата КАК Период,
		|	ДанныеДокумента.Номер КАК Номер,
		|	ДанныеДокумента.Ссылка КАК Ссылка,
		|	ДанныеДокумента.Организация КАК Организация,
		|	ДанныеДокумента.Валюта КАК Валюта,
		|	ДанныеДокумента.Подразделение КАК Подразделение,
		|	ДанныеДокумента.Подразделение.ВариантОбособленногоУчетаТоваров КАК ВариантОбособленногоУчетаТоваров,
		|	ДанныеДокумента.ХозяйственнаяОперация КАК ХозяйственнаяОперация,
		|	ДанныеДокумента.ОтражатьВОперативномУчете КАК ОтражатьВОперативномУчете,
		|	ДанныеДокумента.ОтражатьВБУиНУ КАК ОтражатьВБУиНУ,
		|	ДанныеДокумента.ОтражатьВУУ КАК ОтражатьВУУ,
		|	ДанныеДокумента.Ответственный КАК Ответственный,
		|	ВЫРАЗИТЬ(ДанныеДокумента.Комментарий КАК СТРОКА(100)) КАК Комментарий,
		|	ДанныеДокумента.ПометкаУдаления КАК ПометкаУдаления,
		|	ДанныеДокумента.Проведен КАК Проведен,
		|	ДанныеДокумента.ОтражатьСебестоимость КАК ОтражатьСебестоимость,
		|	ДанныеДокумента.Исправление КАК Исправление,
		|	ДанныеДокумента.СторнируемыйДокумент КАК СторнируемыйДокумент,
		|	ДанныеДокумента.ИсправляемыйДокумент КАК ИсправляемыйДокумент,
		|	НастройкиХозяйственныхОпераций.Ссылка КАК НастройкаХозяйственнойОперации,
		|	СУММА(ЕСТЬNULL(ДанныеТабличнойЧастиПрочиеРасходы.Сумма, 0)) КАК СуммаДокумента
		|ИЗ
		|	Документ.ВводОстатковПрочиеРасходы КАК ДанныеДокумента
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ВводОстатковПрочиеРасходы.ПрочиеРасходы КАК ДанныеТабличнойЧастиПрочиеРасходы
		|		ПО ДанныеДокумента.Ссылка = ДанныеТабличнойЧастиПрочиеРасходы.Ссылка
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.НастройкиХозяйственныхОпераций КАК НастройкиХозяйственныхОпераций
		|		ПО ДанныеДокумента.ХозяйственнаяОперация = НастройкиХозяйственныхОпераций.ХозяйственнаяОперация
		|ГДЕ
		|	ДанныеДокумента.Ссылка = &Ссылка
		|
		|СГРУППИРОВАТЬ ПО
		|	ДанныеДокумента.Дата,
		|	ДанныеДокумента.Номер,
		|	ДанныеДокумента.Ссылка,
		|	ДанныеДокумента.Организация,
		|	ДанныеДокумента.Валюта,
		|	ДанныеДокумента.Подразделение,
		|	ДанныеДокумента.ХозяйственнаяОперация,
		|	ДанныеДокумента.ОтражатьВОперативномУчете,
		|	ДанныеДокумента.ОтражатьВБУиНУ,
		|	ДанныеДокумента.ОтражатьВУУ,
		|	ДанныеДокумента.Ответственный,
		|	ВЫРАЗИТЬ(ДанныеДокумента.Комментарий КАК СТРОКА(100)),
		|	ДанныеДокумента.ПометкаУдаления,
		|	ДанныеДокумента.Проведен,
		|	ДанныеДокумента.Исправление,
		|	ДанныеДокумента.СторнируемыйДокумент,
		|	ДанныеДокумента.ИсправляемыйДокумент,
		|	ДанныеДокумента.ОтражатьСебестоимость,
		|	НастройкиХозяйственныхОпераций.Ссылка";
	
	Реквизиты = Запрос.Выполнить().Выбрать();
	Реквизиты.Следующий();

	Запрос.УстановитьПараметр("Период", Реквизиты.Период);
	Запрос.УстановитьПараметр("Номер",  Реквизиты.Номер);
	
	Запрос.УстановитьПараметр("Организация",                    Реквизиты.Организация);
	Запрос.УстановитьПараметр("Подразделение",                  Реквизиты.Подразделение);
	Запрос.УстановитьПараметр("ХозяйственнаяОперация",          Реквизиты.ХозяйственнаяОперация);
	Запрос.УстановитьПараметр("ВалютаРегламентированногоУчета", ЗначениеНастроекПовтИсп.ВалютаРегламентированногоУчетаОрганизации(Реквизиты.Организация));
	Запрос.УстановитьПараметр("ВалютаУправленческогоУчета",     Константы.ВалютаУправленческогоУчета.Получить());
	Запрос.УстановитьПараметр("ОтражатьВОперативномУчете",      Реквизиты.ОтражатьВОперативномУчете);
	Запрос.УстановитьПараметр("ОтражатьВБУиНУ",                 Реквизиты.ОтражатьВБУиНУ);
	Запрос.УстановитьПараметр("ОтражатьВУУ",                    Реквизиты.ОтражатьВУУ);
	Запрос.УстановитьПараметр("Комментарий",                    Реквизиты.Комментарий);
	Запрос.УстановитьПараметр("Проведен",                       Реквизиты.Проведен);
	Запрос.УстановитьПараметр("Валюта",                         Реквизиты.Валюта);
	Запрос.УстановитьПараметр("ПометкаУдаления",                Реквизиты.ПометкаУдаления);
	Запрос.УстановитьПараметр("Ответственный",                  Реквизиты.Ответственный);
	Запрос.УстановитьПараметр("СуммаДокумента",                 Реквизиты.СуммаДокумента);
	Запрос.УстановитьПараметр("ПустоеНазначение",               Справочники.Назначения.ПустаяСсылка());
	Запрос.УстановитьПараметр("Исправление",                    Реквизиты.Исправление);
	Запрос.УстановитьПараметр("СторнируемыйДокумент",           Реквизиты.СторнируемыйДокумент);
	Запрос.УстановитьПараметр("ИсправляемыйДокумент",           Реквизиты.ИсправляемыйДокумент);
	Запрос.УстановитьПараметр("НастройкаХозяйственнойОперации", Реквизиты.НастройкаХозяйственнойОперации);
	Запрос.УстановитьПараметр("ИдентификаторМетаданных", 
		ОбщегоНазначения.ИдентификаторОбъектаМетаданных("Документ." + Метаданные.Документы.ВводОстатковПрочиеРасходы.Имя));
	Запрос.УстановитьПараметр("ОтражатьСебестоимость",
		Реквизиты.ОтражатьСебестоимость
		И РасчетСебестоимостиПовтИсп.ФормироватьДвиженияПоРегистрамСебестоимости(НачалоМесяца(Реквизиты.Период), Истина));
	
	ПараметрыУчетаПоОрганизации = УчетНДСУП.ПараметрыУчетаПоОрганизации(Реквизиты.Организация, Реквизиты.Период);
	Запрос.УстановитьПараметр("НалогообложениеОрганизации",     ПараметрыУчетаПоОрганизации.ОсновноеНалогообложениеНДСПродажи);
	
	РасчетСебестоимостиПрикладныеАлгоритмы.ЗаполнитьПараметрыИнициализации(Запрос, Реквизиты);
	
КонецПроцедуры

Функция ТекстЗапросаВтТаблицаАналитикУчетаПартий(Запрос, ТекстыЗапроса)
	
	// Создадим временную таблицу "ВтТаблицаАналитикУчетаПартий"
	
	ТекстВыборкаПоляАналитик = "ВЫБРАТЬ
		|	""ПрочиеРасходы""                                                       КАК ИмяТабличнойЧасти,
		|	ТаблицаДокумента.НомерСтроки                                            КАК НомерСтроки,
		|	ЗНАЧЕНИЕ(Справочник.Партнеры.ПустаяСсылка)                              КАК Поставщик,
		|	ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка)                           КАК Контрагент,
		|	ТаблицаДокумента.СтавкаНДС                                              КАК СтавкаНДС,
		|	ВЫБОР КОГДА ЕСТЬNULL(Статьи.ВариантРаздельногоУчетаНДС, НЕОПРЕДЕЛЕНО) =
		|	  ЗНАЧЕНИЕ(Перечисление.ВариантыРаздельногоУчетаНДС.Распределение) 
		|		ТОГДА ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ОпределяетсяРаспределением)
		|		КОГДА ДанныеДокумента.ВидДеятельностиНДС <> ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ПустаяСсылка)
		|			ТОГДА ДанныеДокумента.ВидДеятельностиНДС
		|		ИНАЧЕ &НалогообложениеОрганизации
		|	КОНЕЦ                                                                   КАК НалогообложениеНДС,
		|	Статьи.ВидЦенностиНДС                                                   КАК ВидЦенности,
		|	0                                                                       КАК КодСтроки
		|ПОМЕСТИТЬ ВТПоляАналитикУчетаПартий
		|ИЗ
		|	Документ.ВводОстатковПрочиеРасходы.ПрочиеРасходы КАК ТаблицаДокумента
		|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ВводОстатковПрочиеРасходы КАК ДанныеДокумента
		|		ПО ДанныеДокумента.Ссылка = ТаблицаДокумента.Ссылка
		|	ЛЕВОЕ СОЕДИНЕНИЕ ПланВидовХарактеристик.СтатьиРасходов КАК Статьи
		|		ПО ТаблицаДокумента.СтатьяРасходов = Статьи.Ссылка
		|ГДЕ
		|	ТаблицаДокумента.Ссылка = &Ссылка
		|";
	
	ТекстЗапроса = Справочники.КлючиАналитикиУчетаПартий.ТекстЗапросаВтТаблицаАналитикУчетаПартий(ТекстВыборкаПоляАналитик, Запрос, ТекстыЗапроса);
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаВтДанныеРасходы(Запрос, ТекстыЗапроса)
	
	ИмяРегистра = "ВтДанныеРасходы";
	
	Если НЕ ПроведениеДокументов.ЕстьТаблицаЗапроса("ВтТаблицаАналитикУчетаПартий", ТекстыЗапроса) Тогда
		ТекстЗапросаВтТаблицаАналитикУчетаПартий(Запрос, ТекстыЗапроса);
	КонецЕсли; 
	
	ТекстЗапросаУчетнаяПолитикаПоНДД = РасчетСебестоимостиЛокализация.ТекстЗапросаНастроекНДД("", 
		"ВводОстатковПрочиеРасходы_ТекстЗапросаВтДанныеРасходы");
	ТекстыЗапроса.Добавить(ТекстЗапросаУчетнаяПолитикаПоНДД, ИмяРегистра);
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Документ.Организация                               КАК Организация,
	|	Документ.Дата                                      КАК Дата,
	|	ДанныеДокументаРасходы.НомерСтроки                 КАК НомерСтроки,
	|	Документ.Подразделение                             КАК Подразделение,
	|	ДанныеДокументаРасходы.НаправлениеДеятельности     КАК НаправлениеДеятельности,
	|	ДанныеДокументаРасходы.СтатьяРасходов              КАК СтатьяРасходов,
	|	ДанныеДокументаРасходы.АналитикаРасходов           КАК АналитикаРасходов,
	|	ДанныеДокументаРасходы.Ссылка                      КАК ДокументПоступленияРасходов,
	|	ДанныеДокументаРасходы.ИдентификаторСтроки         КАК ИдентификаторСтроки,
	|
	|	ТаблицаАналитикУчетаПартий.ВидЦенности			   КАК ВидЦенности,
	|	ТаблицаАналитикУчетаПартий.НалогообложениеНДС	   КАК ВидДеятельностиНДС,
	|	ТаблицаАналитикУчетаПартий.АналитикаУчетаПартий    КАК АналитикаУчетаПартий,
	|
	|	ДанныеДокументаРасходы.Сумма                       КАК Сумма,
	|	ДанныеДокументаРасходы.СуммаБезНДС                 КАК СуммаБезНДС,
	|	ДанныеДокументаРасходы.СуммаРегл                   КАК СуммаРегл,
	|	ДанныеДокументаРасходы.НДСРегл                     КАК НДСРегл,
	|	ДанныеДокументаРасходы.СуммаПР                     КАК СуммаПР,
	|	ДанныеДокументаРасходы.СуммаВР                     КАК СуммаВР,
	|	ВЫБОР
	|		КОГДА ДанныеДокументаРасходы.СтатьяРасходов.ПризнаютсяВРасходахНДД
	|			 И ЕСТЬNULL(УчетнаяПолитикаПоНДД.ПлательщикНДД, ЛОЖЬ)
	|			 И Документ.ОтражатьНДД
	|			ТОГДА ДанныеДокументаРасходы.СуммаНДД
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК СуммаНДД
	|
	|ПОМЕСТИТЬ ВтДанныеРасходы
	|ИЗ
	|	Документ.ВводОстатковПрочиеРасходы.ПрочиеРасходы КАК ДанныеДокументаРасходы
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		Документ.ВводОстатковПрочиеРасходы КАК Документ
	|	ПО
	|		ДанныеДокументаРасходы.Ссылка = Документ.Ссылка
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		ПланВидовХарактеристик.СтатьиРасходов КАК СтатьиРасходов
	|	ПО
	|		ДанныеДокументаРасходы.СтатьяРасходов = СтатьиРасходов.Ссылка
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ ВтТаблицаАналитикУчетаПартий КАК ТаблицаАналитикУчетаПартий
	|	ПО ТаблицаАналитикУчетаПартий.НомерСтроки 		= ДанныеДокументаРасходы.НомерСтроки
	|	 И ТаблицаАналитикУчетаПартий.ИмяТабличнойЧасти = ""ПрочиеРасходы""
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ УчетнаяПолитикаПоНДД КАК УчетнаяПолитикаПоНДД
	|	ПО Документ.Организация = УчетнаяПолитикаПоНДД.Организация
	|
	|ГДЕ
	|	ДанныеДокументаРасходы.Ссылка = &Ссылка
	|	И &ОтражатьСебестоимость";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаТаблицаВтИсходныеПрочиеРасходы(Запрос, ТекстыЗапроса)
	
	ИмяРегистра = "ВтИсходныеПрочиеРасходы";
	
	Если Не ПроведениеДокументов.ЕстьТаблицаЗапроса("ВтДанныеРасходы", ТекстыЗапроса) Тогда
		ТекстЗапросаВтДанныеРасходы(Запрос, ТекстыЗапроса);
	КонецЕсли;
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)  КАК ВидДвижения,
	|	ВтДанныеРасходы.Дата                    КАК Период,
	|	ВтДанныеРасходы.Организация             КАК Организация,
	|	ВтДанныеРасходы.Подразделение           КАК Подразделение,
	|	ВтДанныеРасходы.НаправлениеДеятельности КАК НаправлениеДеятельности,
	|	ВтДанныеРасходы.СтатьяРасходов          КАК СтатьяРасходов,
	|	ВтДанныеРасходы.АналитикаРасходов       КАК АналитикаРасходов,
	|	ВтДанныеРасходы.ВидДеятельностиНДС      КАК ВидДеятельностиНДС,
	|
	|	ВтДанныеРасходы.Сумма                   КАК СуммаСНДС,
	|	ВтДанныеРасходы.СуммаБезНДС             КАК СуммаБезНДС,
	|	ВтДанныеРасходы.СуммаБезНДС             КАК СуммаБезНДСУпр,
	|
	|	ВтДанныеРасходы.СуммаРегл
	|		+ ВтДанныеРасходы.НДСРегл           КАК СуммаСНДСРегл,
	|	ВтДанныеРасходы.СуммаРегл               КАК СуммаБезНДСРегл,
	|	ВтДанныеРасходы.СуммаПР                 КАК ПостояннаяРазница,
	|	ВтДанныеРасходы.СуммаВР                 КАК ВременнаяРазница,
	|	ВтДанныеРасходы.СуммаНДД                КАК СуммаНДД,
	|	НЕОПРЕДЕЛЕНО                            КАК ХозяйственнаяОперация,
	|	НЕОПРЕДЕЛЕНО                            КАК АналитикаУчетаНоменклатуры,
	|	ВтДанныеРасходы.ИдентификаторСтроки     КАК ИдентификаторФинЗаписи,
	|	&НастройкаХозяйственнойОперации         КАК НастройкаХозяйственнойОперации
	|
	|ПОМЕСТИТЬ ВтИсходныеПрочиеРасходы
	|ИЗ
	|	ВтДанныеРасходы КАК ВтДанныеРасходы
	|
	|ГДЕ
	|	&ОтражатьВОперативномУчете
	|";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаТаблицаВтПрочиеРасходы(Запрос, ТекстыЗапроса)
	
	ИмяРегистра = "ВтПрочиеРасходы";
	
	Если Не ПроведениеДокументов.ЕстьТаблицаЗапроса("ВтИсходныеПрочиеРасходы", ТекстыЗапроса) Тогда
		ТекстЗапросаТаблицаВтИсходныеПрочиеРасходы(Запрос, ТекстыЗапроса);
	КонецЕсли;
	
	ДополнительныеПоля = "";
	
	РасчетСебестоимостиЛокализация.ДобавитьДополнительныеПоляПоНДД(ДополнительныеПоля);
	
	ТекстЗапроса = РегистрыНакопления.ПрочиеРасходы.ТекстЗапросаТаблицаВтПрочиеРасходы(ДополнительныеПоля);
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
	
	ДополнительныеПоля = "";
	
	РасчетСебестоимостиЛокализация.ДобавитьДополнительныеПоляПоНДД(ДополнительныеПоля);
	
	ТекстЗапроса = РегистрыНакопления.ПрочиеРасходы.ТекстЗапросаТаблицаПрочиеРасходы(ДополнительныеПоля);
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаТаблицаВтИсходныеПартииПрочихРасходов(Запрос, ТекстыЗапроса)
	
	ИмяРегистра = "ВтИсходныеПартииПрочихРасходов";
	
	Если Не ПроведениеДокументов.ЕстьТаблицаЗапроса("ВтДанныеРасходы", ТекстыЗапроса) Тогда
		ТекстЗапросаВтДанныеРасходы(Запрос, ТекстыЗапроса);
	КонецЕсли;
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)      КАК ВидДвижения,
	|	ВтДанныеРасходы.Дата                        КАК Период,
	|	ВтДанныеРасходы.Организация                 КАК Организация,
	|	ВтДанныеРасходы.Подразделение               КАК Подразделение,
	|	ВтДанныеРасходы.НаправлениеДеятельности     КАК НаправлениеДеятельности,
	|	ВтДанныеРасходы.СтатьяРасходов              КАК СтатьяРасходов,
	|	ВтДанныеРасходы.АналитикаРасходов           КАК АналитикаРасходов,
	|	НЕОПРЕДЕЛЕНО                                КАК АналитикаАктивовПассивов,
	|	ВтДанныеРасходы.ДокументПоступленияРасходов КАК ДокументПоступленияРасходов,
	|	ВтДанныеРасходы.АналитикаУчетаПартий        КАК АналитикаУчетаПартий,
	|	НЕОПРЕДЕЛЕНО                                КАК АналитикаУчетаНоменклатуры,
	|	ВтДанныеРасходы.ВидДеятельностиНДС          КАК ВидДеятельностиНДС,
	|
	|	ВтДанныеРасходы.Сумма                       КАК Стоимость,
	|	ВтДанныеРасходы.СуммаБезНДС                 КАК СтоимостьБезНДС,
	|	ВтДанныеРасходы.Сумма
	|		- ВтДанныеРасходы.СуммаБезНДС           КАК НДСУпр,
	|	ВтДанныеРасходы.СуммаРегл                   КАК СтоимостьРегл,
	|	ВтДанныеРасходы.НДСРегл                     КАК НДСРегл,
	|	ВтДанныеРасходы.СуммаПР                     КАК ПостояннаяРазница,
	|	ВтДанныеРасходы.СуммаВР                     КАК ВременнаяРазница,
	|
	|	НЕОПРЕДЕЛЕНО                                КАК ХозяйственнаяОперация,
	|	ВтДанныеРасходы.ИдентификаторСтроки         КАК ИдентификаторФинЗаписи,
	|	&НастройкаХозяйственнойОперации             КАК НастройкаХозяйственнойОперации
	|
	|ПОМЕСТИТЬ ВтИсходныеПартииПрочихРасходов
	|ИЗ
	|	ВтДанныеРасходы КАК ВтДанныеРасходы
	|
	|ГДЕ
	|	&ОтражатьВОперативномУчете
	|";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаТаблицаВтПартииПрочихРасходов(Запрос, ТекстыЗапроса)
	
	ИмяРегистра = "ВтПартииПрочихРасходов";
	
	Если Не ПроведениеДокументов.ЕстьТаблицаЗапроса("ВтИсходныеПартииПрочихРасходов", ТекстыЗапроса) Тогда
		ТекстЗапросаТаблицаВтИсходныеПартииПрочихРасходов(Запрос, ТекстыЗапроса);
	КонецЕсли;
	
	ТекстЗапроса = РегистрыНакопления.ПартииПрочихРасходов.ТекстЗапросаТаблицаВтПартииПрочихРасходов();
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаТаблицаПартииПрочихРасходов(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ПартииПрочихРасходов";
	
	Если Не ПроведениеДокументов.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	Если Не ПроведениеДокументов.ЕстьТаблицаЗапроса("ВтПартииПрочихРасходов", ТекстыЗапроса) Тогда
		ТекстЗапросаТаблицаВтПартииПрочихРасходов(Запрос, ТекстыЗапроса);
	КонецЕсли;
	
	ТекстЗапроса = РегистрыНакопления.ПартииПрочихРасходов.ТекстЗапросаТаблицаПартииПрочихРасходов();
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаТаблицаРеестрДокументов(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "РеестрДокументов";
	
	Если Не ПроведениеДокументов.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	ТекстЗапроса = "ВЫБРАТЬ
	|	&ИдентификаторМетаданных КАК ТипСсылки,
	|	&ХозяйственнаяОперация КАК ХозяйственнаяОперация,
	|	&Организация КАК Организация,
	|	НЕОПРЕДЕЛЕНО КАК Партнер,
	|	НЕОПРЕДЕЛЕНО КАК МестоХранения,
	|	НЕОПРЕДЕЛЕНО КАК Контрагент,
	|	НЕОПРЕДЕЛЕНО КАК Подразделение,
	|	&Период КАК ДатаДокументаИБ,
	|	&Ссылка КАК Ссылка,
	|	&Номер КАК НомерДокументаИБ,
	|	НЕОПРЕДЕЛЕНО КАК Статус,
	|	&Ответственный КАК Ответственный,
	|	ЛОЖЬ КАК ДополнительнаяЗапись,
	|	НЕОПРЕДЕЛЕНО КАК Дополнительно,
	|	&Комментарий КАК Комментарий,
	|	&Проведен КАК Проведен,
	|	&ПометкаУдаления КАК ПометкаУдаления,
	|	НЕОПРЕДЕЛЕНО КАК ДатаПервичногоДокумента,
	|	НЕОПРЕДЕЛЕНО КАК НомерПервичногоДокумента,
	|	СУММА(ЕСТЬNULL(ДанныеТабличнойЧастиПрочиеРасходы.Сумма, 0)) КАК Сумма,
	|	&Валюта КАК Валюта,
	|	НЕОПРЕДЕЛЕНО КАК Договор,
	|	НЕОПРЕДЕЛЕНО КАК НаправлениеДеятельности,
	|	&Исправление КАК СторноИсправление,
	|	&СторнируемыйДокумент КАК СторнируемыйДокумент,
	|	&ИсправляемыйДокумент КАК ИсправляемыйДокумент,
	|	&Период КАК ДатаОтраженияВУчете,
	|	НЕОПРЕДЕЛЕНО КАК Приоритет
	|ИЗ
	|	Документ.ВводОстатковПрочиеРасходы КАК ДанныеДокумента
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ВводОстатковПрочиеРасходы.ПрочиеРасходы КАК ДанныеТабличнойЧастиПрочиеРасходы
	|		ПО ДанныеДокумента.Ссылка = ДанныеТабличнойЧастиПрочиеРасходы.Ссылка
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка
	|СГРУППИРОВАТЬ ПО
	|	ДанныеДокумента.Ссылка";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция АдаптированныйТекстЗапросаДвиженийПоРегистру(ИмяРегистра) Экспорт
	
	Запрос = Новый Запрос;
	ТекстыЗапроса = Новый СписокЗначений;
	
	ПолноеИмяДокумента = "Документ.ВводОстатковПрочиеРасходы";
	
	ЗначенияПараметров = Новый Структура;
	ЗначенияПараметров.Вставить("ИдентификаторМетаданных", ОбщегоНазначения.ИдентификаторОбъектаМетаданных(Метаданные.Документы.ВводОстатковПрочиеРасходы));
	
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
			ТекстЗапроса, ПолноеИмяДокумента, СинонимТаблицыДокумента, Истина);
	Иначе
		ТекстЗапроса = ОбновлениеИнформационнойБазыУТ.АдаптироватьЗапросМеханизмаПроведения(
			ТекстЗапроса, ПолноеИмяДокумента, СинонимТаблицыДокумента);
	КонецЕсли;
	
	Результат = ОбновлениеИнформационнойБазыУТ.РезультатАдаптацииЗапроса();
	Результат.ТекстЗапроса = ТекстЗапроса;
	Результат.ЗначенияПараметров = ЗначенияПараметров;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область Прочее

// Определяет видимость группы формы, содержащей флажки видов учета.
// Используется в формах, в которых доступны все виды учета.
//
// Параметры:
//  Объект - ДокументОбъект.ВводОстатковПрочиеРасходы - Документ для которого неободимо вычислить показ группы
//
// Возвращаемое значение:
//	 Булево - Флаг, который сигнализирует о том, показывать или нет группу на форме
// 
Функция ВидимостьГруппУчета(Объект) Экспорт
	
	ВидимостьГруппУчета = ПолучитьФункциональнуюОпцию("ИспользоватьРеглУчет")
		ИЛИ РасчетСебестоимостиПовтИсп.ФормироватьДвиженияПоРегистрамСебестоимости(НачалоМесяца(Объект.Дата), Истина);
	
	Возврат ВидимостьГруппУчета;
	
КонецФункции


#КонецОбласти

#Область Печать

// Заполняет список команд печати.
//
// Параметры:
//   КомандыПечати - см. УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	ВводОстатковЛокализация.ВводОстатковПрочиеРасходыДобавитьКомандыПечати(КомандыПечати);
	
КонецПроцедуры

// Формирует печатные формы.
//
// Параметры:
//  МассивОбъектов  - Массив    - ссылки на объекты, которые нужно распечатать;
//  ПараметрыПечати - Структура - дополнительные настройки печати;
//  КоллекцияПечатныхФорм - ТаблицаЗначений - сформированные табличные документы (выходной параметр)
//  ОбъектыПечати         - СписокЗначений  - значение - ссылка на объект;
//                                            представление - имя области в которой был выведен объект (выходной параметр);
//  ПараметрыВывода       - Структура       - дополнительные параметры сформированных табличных документов (выходной параметр).
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
КонецПроцедуры

#КонецОбласти

//++ НЕ УТ

#Область СлужебныеПроцедурыЗаполненияПоДаннымОперативногоУчета

Функция ОстаткиПоПрочимРасходам(ДатаОстатков, МассивОрганизаций, ДопОтбор)
	
	Запрос = Новый Запрос("ВЫБРАТЬ
		|	""ПрочиеРасходы"" КАК ЗаполняемаяТабличнаяЧасть,
		|	ПрочиеРасходыОстатки.Организация КАК Организация,
		|	ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВводОстатковПрочихРасходов) КАК ХозяйственнаяОперация,
		|	ПрочиеРасходыОстатки.Подразделение,
		|	ПрочиеРасходыОстатки.НаправлениеДеятельности,
		|	ПрочиеРасходыОстатки.СтатьяРасходов,
		|	ПрочиеРасходыОстатки.АналитикаРасходов,
		|	СУММА(ПрочиеРасходыОстатки.СуммаРеглОстаток) КАК СуммаРегл,
		|	СУММА(ПрочиеРасходыОстатки.ПостояннаяРазницаОстаток) КАК СуммаПР,
		|	СУММА(ПрочиеРасходыОстатки.ВременнаяРазницаОстаток) КАК СуммаВР,
		|	СУММА(ПрочиеРасходыОстатки.СуммаБезНДСОстаток) КАК СуммаБезНДС,
		|	СУММА(ПрочиеРасходыОстатки.СуммаОстаток) КАК Сумма
		|ИЗ
		|	РегистрНакопления.ПрочиеРасходы.Остатки(&Дата, Организация В (&МассивОрганизаций) И &УсловиеПодразделения) КАК ПрочиеРасходыОстатки
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ПланВидовХарактеристик.СтатьиРасходов КАК СтатьиРасходов
		|		ПО ПрочиеРасходыОстатки.СтатьяРасходов = СтатьиРасходов.Ссылка
		|
		|СГРУППИРОВАТЬ ПО
		|	ПрочиеРасходыОстатки.Организация,
		|	ПрочиеРасходыОстатки.Подразделение,
		|	ПрочиеРасходыОстатки.НаправлениеДеятельности,
		|	ПрочиеРасходыОстатки.СтатьяРасходов,
		|	ПрочиеРасходыОстатки.АналитикаРасходов	
		|
		|ИМЕЮЩИЕ
		|	СУММА(ПрочиеРасходыОстатки.СуммаРеглОстаток) > 0
		|
		|УПОРЯДОЧИТЬ ПО
		|	Организация");
	
	Запрос.Параметры.Вставить("МассивОрганизаций", МассивОрганизаций);
	Запрос.Параметры.Вставить("Дата", ДатаОстатков);
	
	Если ЗначениеЗаполнено(ДопОтбор) Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст , "&УсловиеПодразделения", "Подразделение = &Подразделение");
		Запрос.Параметры.Вставить("Подразделение", ДопОтбор.Подразделение);
	Иначе
		Запрос.Текст = СтрЗаменить(Запрос.Текст , "&УсловиеПодразделения", "ИСТИНА");
	КонецЕсли;
	
	Результат = Запрос.Выполнить().Выгрузить();
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

//-- НЕ УТ

#КонецОбласти

#КонецЕсли
