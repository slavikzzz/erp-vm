#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

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
//     Таблица<ИмяРегистра> - ТаблицаЗначений - таблица данных для отражения в регистр.
//
Функция ДанныеДокументаДляПроведения(Документ, Регистры, ДопПараметры = Неопределено) Экспорт
	
	Если ТипЗнч(Документ) = Тип("ДокументОбъект.ВводОстатковТМЦВЭксплуатации") Тогда
		ДокументСсылка = Документ.Ссылка;
	Иначе
		ДокументСсылка = Документ;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка);
	
	ТекстыЗапроса = Новый СписокЗначений;
	
	ТекстЗапросаТаблицаТМЦВЭксплуатации(Запрос, ТекстыЗапроса, Регистры);
	ТекстЗапросаТаблицаСтоимостьТМЦВЭксплуатации(Запрос, ТекстыЗапроса, Регистры);
	
	ТекстЗапросаТаблицаРеестрДокументов(Запрос, ТекстыЗапроса, Регистры);

	ВводОстатковТМЦВЭксплуатацииЛокализация.ДополнитьТекстыЗапросовПроведения(Запрос, ТекстыЗапроса, Регистры);
	
	ПроведениеДокументов.ДобавитьЗапросыСторноДвижений(Запрос, ТекстыЗапроса, Регистры, ПустаяСсылка().Метаданные());
	
	ТаблицыДвижений = ПроведениеДокументов.ИнициализироватьДанныеДокументаДляПроведения(Запрос, ТекстыЗапроса, ДопПараметры);
	
	Возврат ТаблицыДвижений;
	
КонецФункции

// Описывает учетные механизмы используемые в документе для регистрации в механизме проведения.
//
// Параметры:
//  МеханизмыДокумента - Массив - список имен учетных механизмов, для которых будет выполнена
//              регистрация в механизме проведения.
//
Процедура ЗарегистрироватьУчетныеМеханизмы(МеханизмыДокумента) Экспорт
	
	МеханизмыДокумента.Добавить("ТМЦВЭксплуатации");
	МеханизмыДокумента.Добавить("РеестрДокументов");
	МеханизмыДокумента.Добавить("ИсправлениеДокументов");

	//++ НЕ УТКА
	МеханизмыДокумента.Добавить("МеждународныйУчет");
	//-- НЕ УТКА
	
	ВводОстатковТМЦВЭксплуатацииЛокализация.ЗарегистрироватьУчетныеМеханизмы(МеханизмыДокумента);
	
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
	
	ИсправлениеДокументов.ДобавитьКомандыСозданияНаОсновании(КомандыСозданияНаОсновании, ПустаяСсылка().Метаданные());
	
	ВводОстатковЛокализация.ДобавитьКомандыСозданияНаОсновании(КомандыСозданияНаОсновании, Параметры);
	
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
	
	ВводОстатковЛокализация.ВводОстатковТМЦВЭксплуатацииДобавитьКомандыОтчетов(КомандыОтчетов, Параметры);

КонецПроцедуры

#КонецОбласти

//++ НЕ УТ

#Область ПроведениеПоРеглУчету

// Функция возвращает текст запроса для отражения документа в регламентированном учете.
//
// Возвращаемое значение:
//	Строка - Текст запроса
//
Функция ТекстОтраженияВРеглУчете() Экспорт

	Возврат ВводОстатковТМЦВЭксплуатацииЛокализация.ТекстОтраженияВРеглУчете();

КонецФункции

// Функция возвращает текст запроса дополнительных временных таблиц,
// необходимых для отражения в регламентированном учете
//
// Возвращаемое значение:
//  Строка - Содержащая текст запроса временных таблиц для отражения в регл. учете.
//
Функция ТекстЗапросаВТОтраженияВРеглУчете() Экспорт

	Возврат "";

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
	Возврат Неопределено;
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
	Возврат МассивКлючевыхПолей;
	
КонецФункции

#КонецОбласти

//-- НЕ УТ

#Область Серии

// Имена реквизитов, от значений которых зависят параметры указания серий
//
//	Возвращаемое значение:
//		Строка - имена реквизитов, перечисленные через запятую.
//
Функция ИменаРеквизитовДляЗаполненияПараметровУказанияСерий() Экспорт
	
	ИменаРеквизитов = "Дата";
	
	Возврат ИменаРеквизитов;
	
КонецФункции

// Возвращает параметры указания серий для товаров, указанных в документе.
//
// Параметры:
//  Объект - Структура - структура значений реквизитов объекта, необходимых для заполнения параметров указания серий.
//
// Возвращаемое значение:
//  Структура - состав полей задается в функции НоменклатураКлиентСервер.ПараметрыУказанияСерий.
//
Функция ПараметрыУказанияСерий(Объект) Экспорт
	
	ПараметрыУказанияСерий = НоменклатураКлиентСервер.ПараметрыУказанияСерий();
	ПараметрыУказанияСерий.ПолноеИмяОбъекта = "Документ.ВводОстатковТМЦВЭксплуатации";
	
	ПараметрыУказанияСерий.ИспользоватьСерииНоменклатуры = ПолучитьФункциональнуюОпцию("ИспользоватьСерииНоменклатурыСклад", Новый Структура());
	ПараметрыУказанияСерий.УчитыватьСебестоимостьПоСериям = ПараметрыУказанияСерий.ИспользоватьСерииНоменклатуры;
	
	ПараметрыУказанияСерий.СкладскиеОперации.Добавить(Перечисления.СкладскиеОперации.ВводОстатков);
	
	ПараметрыУказанияСерий.РегистрироватьСерии = Ложь;
	
	ПараметрыУказанияСерий.ЭтоНакладная = Истина;
	ПараметрыУказанияСерий.Дата = Объект.Дата;
	ПараметрыУказанияСерий.ИмяПоляСклад = Неопределено;
	ПараметрыУказанияСерий.ИмяТЧТовары = "ТМЦВЭксплуатации";
	ПараметрыУказанияСерий.ИмяТЧСерии = "ТМЦВЭксплуатации";
	
	ПараметрыУказанияСерий.ИменаПолейСтатусУказанияСерий.Добавить("СтатусУказанияСерий");
	
	Возврат ПараметрыУказанияСерий;
	
КонецФункции

// Возвращает текст запроса для расчета статусов указания серий
// 
// Параметры:
//	ПараметрыУказанияСерий - см. ПараметрыУказанияСерий
//		
// Возвращаемое значение:
//	Строка - текст запроса.
//
Функция ТекстЗапросаЗаполненияСтатусовУказанияСерий(ПараметрыУказанияСерий) Экспорт
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	Товары.Номенклатура КАК Номенклатура,
	|	Товары.Характеристика КАК Характеристика,
	|	Товары.Серия КАК Серия,
	|	Товары.Количество КАК Количество,
	|	Товары.СтатусУказанияСерий КАК СтатусУказанияСерий,
	|	Товары.НомерСтроки КАК НомерСтроки
	|ПОМЕСТИТЬ Товары
	|ИЗ
	|	&Товары КАК Товары
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Товары.Номенклатура,
	|	Товары.Характеристика,
	|	Товары.Серия,
	|	ВЫРАЗИТЬ(Товары.Номенклатура КАК Справочник.Номенклатура).ВидНоменклатуры КАК ВидНоменклатуры,
	|	СУММА(Товары.Количество) КАК Количество
	|ПОМЕСТИТЬ ТоварыДляЗапроса
	|ИЗ
	|	Товары КАК Товары
	|
	|СГРУППИРОВАТЬ ПО
	|	Товары.Номенклатура,
	|	Товары.Характеристика,
	|	Товары.Серия,
	|	ВЫРАЗИТЬ(Товары.Номенклатура КАК Справочник.Номенклатура).ВидНоменклатуры
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Товары.НомерСтроки КАК НомерСтроки,
	|	Товары.СтатусУказанияСерий КАК СтарыйСтатусУказанияСерий,
	|
	|	ВЫБОР
	|		КОГДА ТоварыДляЗапроса.ВидНоменклатуры.ПолитикаУчетаСерий ЕСТЬ NULL
	|			ТОГДА 0
	|		КОГДА ТоварыДляЗапроса.ВидНоменклатуры.ПолитикаУчетаСерий.УчитыватьСерииТМЦВЭксплуатации
	|			ТОГДА
	|				ВЫБОР
	|					КОГДА Товары.Серия <> ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
	|						ТОГДА 18
	|					ИНАЧЕ 17
	|				КОНЕЦ
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК СтатусУказанияСерий
	|
	|ПОМЕСТИТЬ Статусы
	|
	|ИЗ
	|	Товары КАК Товары
	|
	|		ЛЕВОЕ СОЕДИНЕНИЕ ТоварыДляЗапроса КАК ТоварыДляЗапроса
	|		ПО Товары.Номенклатура = ТоварыДляЗапроса.Номенклатура
	|			И Товары.Характеристика = ТоварыДляЗапроса.Характеристика
	|			И Товары.Серия = ТоварыДляЗапроса.Серия
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Статусы.НомерСтроки КАК НомерСтроки,
	|	Статусы.СтатусУказанияСерий КАК СтатусУказанияСерий
	|ИЗ
	|	Статусы КАК Статусы
	|ГДЕ
	|	Статусы.СтатусУказанияСерий <> Статусы.СтарыйСтатусУказанияСерий
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки";
	
	Возврат ТекстЗапроса;
	
КонецФункции

#КонецОбласти

#Область ДляВызоваИзДругихПодсистем

// Для использования в процедуре ДобавитьКомандыСозданияНаОсновании других модулей менеджеров объектов.
// Добавляет в список команд создания на основании этот объект.
//
// Параметры:
//  КомандыСозданияНаОсновании - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
//
// Возвращаемое значение:
//  СтрокаТаблицыЗначений, Неопределено - описание добавленной команды.
//
Функция ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании) Экспорт
	
	Возврат СозданиеНаОсновании.ДобавитьКомандуСозданияНаОсновании(КомандыСозданияНаОсновании, Метаданные.Документы.ВводОстатковТМЦВЭксплуатации);
	
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

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Проведение

Функция АдаптированныйТекстЗапросаДвиженийПоРегистру(ИмяРегистра) Экспорт
	
	Запрос = Новый Запрос;
	ТекстыЗапроса = Новый СписокЗначений;
	
	ПолноеИмяДокумента = "Документ.ВводОстатковТМЦВЭксплуатации";
	
	ЗначенияПараметров = Новый Структура;
	ЗначенияПараметров.Вставить("ИдентификаторМетаданных", ОбщегоНазначения.ИдентификаторОбъектаМетаданных(Метаданные.Документы.ВводОстатковТМЦВЭксплуатации));
	
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

Функция ДополнительныеИсточникиДанныхДляДвижений(ИмяРегистра) Экспорт
	
	ИсточникиДанных = Новый Соответствие;
	Возврат ИсточникиДанных; 
	
КонецФункции

Процедура ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка)
	
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ДанныеДокумента.Дата КАК Период,
	|	ДанныеДокумента.Номер КАК Номер,
	|	ДанныеДокумента.Ссылка КАК Ссылка,
	|	ДанныеДокумента.Организация КАК Организация,
	|	ДанныеДокумента.Подразделение КАК Подразделение,
	|	ДанныеДокумента.Подразделение.ВариантОбособленногоУчетаТоваров КАК ВариантОбособленногоУчетаТоваров,
	|	ДанныеДокумента.ХозяйственнаяОперация КАК ХозяйственнаяОперация,
	|	ДанныеДокумента.ОтражатьВОперативномУчете КАК ОтражатьВОперативномУчете,
	|	ДанныеДокумента.ОтражатьВБУиНУ КАК ОтражатьВБУиНУ,
	|	ДанныеДокумента.ОтражатьВУУ КАК ОтражатьВУУ,
	|	ДанныеДокумента.Ответственный КАК Ответственный,
	|	ДанныеДокумента.Комментарий КАК Комментарий,
	|	ДанныеДокумента.ПометкаУдаления КАК ПометкаУдаления,
	|	ДанныеДокумента.Проведен КАК Проведен,
	|	ДанныеДокумента.Исправление КАК Исправление,
	|	ДанныеДокумента.СторнируемыйДокумент КАК СторнируемыйДокумент,
	|	ДанныеДокумента.ИсправляемыйДокумент КАК ИсправляемыйДокумент
	|ИЗ
	|	Документ.ВводОстатковТМЦВЭксплуатации КАК ДанныеДокумента
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка";
	
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

Функция ЗначенияПараметровПроведения(Реквизиты = Неопределено)

	ЗначенияПараметровПроведения = Новый Структура;
	ЗначенияПараметровПроведения.Вставить("ИдентификаторМетаданных", ОбщегоНазначения.ИдентификаторОбъектаМетаданных("Документ.ВводОстатковТМЦВЭксплуатации"));
	ЗначенияПараметровПроведения.Вставить("ПустоеНазначение", Справочники.Назначения.ПустаяСсылка());
	ЗначенияПараметровПроведения.Вставить("ВалютаУправленческогоУчета", Константы.ВалютаУправленческогоУчета.Получить());
	
	Если Реквизиты <> Неопределено Тогда
		
		ВалютаРегламентированногоУчета = ЗначениеНастроекПовтИсп.ВалютаРегламентированногоУчетаОрганизации(Реквизиты.Организация);
		
		ЗначенияПараметровПроведения.Вставить("ВалютаРегламентированногоУчета", ВалютаРегламентированногоУчета);
			
		КоэффициентПересчетаВВалютуУпр = РаботаСКурсамиВалютУТ.ПолучитьКоэффициентПересчетаИзВалютыВВалюту(
			ВалютаРегламентированногоУчета, Константы.ВалютаУправленческогоУчета.Получить(), Реквизиты.Период);
			
		ЗначенияПараметровПроведения.Вставить("КоэффициентПересчетаВВалютуУпр", КоэффициентПересчетаВВалютуУпр);
			
	КонецЕсли; 
	
	Возврат ЗначенияПараметровПроведения;
	
КонецФункции

Функция ТекстЗапросаТаблицаРеестрДокументов(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "РеестрДокументов";
	
	Если Не ПроведениеДокументов.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	&ИдентификаторМетаданных КАК ТипСсылки,
	|	&ХозяйственнаяОперация КАК ХозяйственнаяОперация,
	|	&Организация КАК Организация,
	|	НЕОПРЕДЕЛЕНО КАК Партнер,
	|	НЕОПРЕДЕЛЕНО КАК МестоХранения,
	|	НЕОПРЕДЕЛЕНО КАК Контрагент,
	|	&Подразделение КАК Подразделение,
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
	|	НЕОПРЕДЕЛЕНО КАК Договор,
	|	НЕОПРЕДЕЛЕНО КАК НаправлениеДеятельности,
	|	&Исправление КАК СторноИсправление,
	|	&СторнируемыйДокумент КАК СторнируемыйДокумент,
	|	&ИсправляемыйДокумент КАК ИсправляемыйДокумент,
	|	&Период КАК ДатаОтраженияВУчете,
	|	НЕОПРЕДЕЛЕНО КАК Приоритет
	|ИЗ
	|	Документ.ВводОстатковТМЦВЭксплуатации КАК ДанныеДокумента
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаТаблицаТМЦВЭксплуатации(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ТМЦВЭксплуатации";
	
	Если Не ПроведениеДокументов.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	&Период                        КАК Период,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) КАК ВидДвижения,
	|	
	|	&Организация                      КАК Организация,
	|	&Подразделение                    КАК Подразделение,
	|	Таблица.ФизическоеЛицо            КАК ФизическоеЛицо,
	|	Таблица.Номенклатура              КАК Номенклатура,
	|	Таблица.Характеристика            КАК Характеристика,
	|	Таблица.Серия                     КАК Серия,
	|	Таблица.НомерГТД                  КАК НомерГТД,
	|	Таблица.Партия                    КАК Партия,
	|	Таблица.НаправлениеДеятельности   КАК НаправлениеДеятельности,
	|	Таблица.ИнвентарныйНомер          КАК ИнвентарныйНомер,
	|	
	|	Таблица.Количество       КАК Количество,
	|	Таблица.КоличествоПоРНПТ КАК КоличествоПоРНПТ
	|ИЗ
	|	Документ.ВводОстатковТМЦВЭксплуатации.ТМЦВЭксплуатации КАК Таблица
	|	
	|ГДЕ
	|	Таблица.Ссылка = &Ссылка
	|	И &ОтражатьВОперативномУчете";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

Процедура ТекстЗапросаТаблицаСтоимостьТМЦВЭксплуатации(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "СтоимостьТМЦВЭксплуатации";
	
	Если Не ПроведениеДокументов.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат;
	КонецЕсли;
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	&Период                           КАК Период,
	|	&Организация                      КАК Организация,
	|	Таблица.Номенклатура              КАК Номенклатура,
	|	Таблица.Характеристика            КАК Характеристика,
	|	Таблица.Серия                     КАК Серия,
	|	Таблица.ИнвентарныйНомер          КАК ИнвентарныйНомер,
	|	Таблица.Партия                    КАК Партия,
	|	Таблица.ИдентификаторСтроки       КАК ИдентификаторСтроки,
	|	
	|	Таблица.Количество                КАК Количество,
	|	Таблица.ПервоначальнаяСумма       КАК СтоимостьРегл,
	|	Таблица.ПервоначальнаяСуммаУпр    КАК СтоимостьУпр
	|
	|ИЗ
	|	Документ.ВводОстатковТМЦВЭксплуатации.ТМЦВЭксплуатации КАК Таблица
	|	
	|ГДЕ
	|	Таблица.Ссылка = &Ссылка
	|	И &ОтражатьВОперативномУчете";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
КонецПроцедуры

#КонецОбласти

#Область Печать

// Заполняет список команд печати.
//
// Параметры:
//   КомандыПечати - см. УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
		
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

#Область Прочее

// Возвращает параметры выбора статей и аналитик.
// 
// Возвращаемое значение:
//  см. ДоходыИРасходыСервер.ПараметрыВыбораСтатьиИАналитики
//
Функция ПараметрыВыбораСтатейИАналитик(Дата) Экспорт
	
	ПараметрыВыбора = ДоходыИРасходыСервер.ПараметрыВыбораСтатьиИАналитики();
	
	ПараметрыВыбора.ДоступностьПоОперации = Ложь; 
	//++ НЕ УТ
	ПараметрыВыбора.ДоступностьПоОперации =  
			Дата <> '000101010000'
			И НачалоМесяца(Дата) < НачалоМесяца(РеглУчетКлиентСервер.НачалоПримененияФСБУ5_2019());
	//-- НЕ УТ
			
	ПараметрыВыбора.ПутьКДанным = "Объект.ТМЦВЭксплуатации";
	ПараметрыВыбора.Статья = "СтатьяРасходов";
	ПараметрыВыбора.ДоступностьПоОперации = Неопределено;
	ПараметрыВыбора.ВыборСтатьиРасходов = Истина;
	ПараметрыВыбора.АналитикаРасходов = "АналитикаРасходов";
	
	ПараметрыВыбора.ЭлементыФормы.Статья.Добавить("ТМЦВЭксплуатацииСтатьяРасходов");
	ПараметрыВыбора.ЭлементыФормы.АналитикаРасходов.Добавить("ТМЦВЭксплуатацииАналитикаРасходов");
	
	Возврат ПараметрыВыбора;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли
