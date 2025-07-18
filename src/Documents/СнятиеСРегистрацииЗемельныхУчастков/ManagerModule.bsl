#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область Команды

// Добавляет команду создания документа "Отмена регистрации земельных участков".
// 
// Параметры:
//  КомандыСозданияНаОсновании - ТаблицаЗначений - - :
// * Идентификатор - Строка - 
// * Представление - Строка - 
// * Важность - Строка - 
// * Порядок - Число - 
// * Картинка - Картинка - 
// * ТипПараметра - ОписаниеТипов - 
// * ВидимостьВФормах - Строка - 
// * ФункциональныеОпции - Строка - 
// * УсловияВидимости - Массив из Структура - 
// * ИзменяетВыбранныеОбъекты - Булево - 
// * МножественныйВыбор - Булево, Неопределено - 
// * РежимЗаписи - Строка - 
// * ТребуетсяРаботаСФайлами - Булево - 
// * Менеджер - Строка - 
// * ИмяФормы - Строка - 
// * ПараметрыФормы - Неопределено, ФиксированнаяСтруктура - 
// * Обработчик - Строка - 
// * ДополнительныеПараметры - ФиксированнаяСтруктура - 
// - См. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
// 
// Возвращаемое значение:
//  Неопределено, СтрокаТаблицыЗначений - Добавить команду создать на основании:
// * Идентификатор - Строка - 
// * Представление - Строка - 
// * Важность - Строка - 
// * Порядок - Число - 
// * Картинка - Картинка - 
// * ТипПараметра - ОписаниеТипов - 
// * ВидимостьВФормах - Строка - 
// * ФункциональныеОпции - Строка - 
// * УсловияВидимости - Массив из Структура - 
// * ИзменяетВыбранныеОбъекты - Булево - 
// * МножественныйВыбор - Булево, Неопределено - 
// * РежимЗаписи - Строка - 
// * ТребуетсяРаботаСФайлами - Булево - 
// * Менеджер - Строка - 
// * ИмяФормы - Строка - 
// * ПараметрыФормы - Неопределено, ФиксированнаяСтруктура - 
// * Обработчик - Строка - 
// * ДополнительныеПараметры - ФиксированнаяСтруктура - 
Функция ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании) Экспорт
	
	Если ПравоДоступа("Добавление", Метаданные.Документы.СнятиеСРегистрацииЗемельныхУчастков) Тогда
		КомандаСоздатьНаОсновании = КомандыСозданияНаОсновании.Добавить();
		КомандаСоздатьНаОсновании.Менеджер = Метаданные.Документы.СнятиеСРегистрацииЗемельныхУчастков.ПолноеИмя();
		КомандаСоздатьНаОсновании.Представление = ОбщегоНазначенияУТ.ПредставлениеОбъекта(Метаданные.Документы.СнятиеСРегистрацииЗемельныхУчастков);
		КомандаСоздатьНаОсновании.РежимЗаписи = "Проводить";
		Возврат КомандаСоздатьНаОсновании;
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

#КонецОбласти

#Область Проведение

// Описывает учетные механизмы используемые в документе для регистрации в механизме проведения.
//
// Параметры:
//  МеханизмыДокумента - Массив из Строка - список имен учетных механизмов, для которых будет выполнена
//              регистрация в механизме проведения.
//
Процедура ЗарегистрироватьУчетныеМеханизмы(МеханизмыДокумента) Экспорт
	
	МеханизмыДокумента.Добавить("ИмущественныеНалоги");
	МеханизмыДокумента.Добавить("ОсновныеСредства");
	МеханизмыДокумента.Добавить("РеестрДокументов");
	
КонецПроцедуры

// Возвращает таблицы для движений, необходимые для проведения документа по регистрам учетных механизмов.
//
// Параметры:
//  Документ - ДокументСсылка, ДокументОбъект - ссылка на документ или объект, по которому необходимо получить данные
//  Регистры - Структура - список имен регистров, для которых необходимо получить таблицы
//  ДопПараметры - Структура - дополнительные параметры для получения данных, определяющие контекст проведения.
//
// Возвращаемое значение:
//  Структура - коллекция элементов:
//     * Таблица<ИмяРегистра> - ТаблицаЗначений - таблица данных для отражения в регистр.
//
Функция ДанныеДокументаДляПроведения(Документ, Регистры, ДопПараметры = Неопределено) Экспорт
	
	Если ДопПараметры = Неопределено Тогда
		ДопПараметры = ПроведениеДокументов.ДопПараметрыИнициализироватьДанныеДокументаДляПроведения();
	КонецЕсли;
	
	Если ТипЗнч(Документ) = Тип("ДокументОбъект.СнятиеСРегистрацииЗемельныхУчастков") Тогда
		ДокументСсылка = Документ.Ссылка;
	Иначе
		ДокументСсылка = Документ;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	ТекстыЗапроса = Новый СписокЗначений;
	
	Если Не ДопПараметры.ПолучитьТекстыЗапроса Тогда
		
		ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка, ДопПараметры);
		
		ТекстЗапросаТаблицаПараметрыНачисленияЗемельногоНалога(ТекстыЗапроса, Регистры);
		ТекстЗапросаТаблицаРеестрДокументов(Запрос, ТекстыЗапроса, Регистры);
		ТекстЗапросаТаблицаДокументыПоОС(Запрос, ТекстыЗапроса, Регистры);
		
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
	
	ЗначенияПараметровПроведения = ЗначенияПараметровПроведения();
	Для каждого КлючИЗначение Из ЗначенияПараметровПроведения Цикл
		Запрос.УстановитьПараметр(КлючИЗначение.Ключ, КлючИЗначение.Значение);
	КонецЦикла;
	
	ТекстыЗапроса = Новый СписокЗначений;
	ТекстЗапросаТаблицаПараметрыНачисленияЗемельногоНалога(ТекстыЗапроса, Неопределено);
	
	ТаблицыДвижений = ПроведениеДокументов.ИнициализироватьДанныеДокументаДляПроведения(Запрос, ТекстыЗапроса);
	
	Возврат ТаблицыДвижений;
	
КонецФункции

#КонецОбласти

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт
	Возврат;
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
	
	ПолноеИмяДокумента = "Документ.СнятиеСРегистрацииЗемельныхУчастков";
	
	ЗначенияПараметров = ЗначенияПараметровПроведения();
	ПереопределениеРасчетаПараметров = Новый Структура;
	ПереопределениеРасчетаПараметров.Вставить("НомерНаПечать", """""");
	
	ВЗапросеЕстьИсточник = Истина;
	
	Если ИмяРегистра = "РеестрДокументов" Тогда
		
		ТекстЗапроса = ТекстЗапросаТаблицаРеестрДокументов(Запрос, ТекстыЗапроса, ИмяРегистра);
		СинонимТаблицыДокумента = "ДанныеДокумента";
		
	ИначеЕсли ИмяРегистра = "ДокументыПоОС" Тогда
		
		ТекстЗапроса = ТекстЗапросаТаблицаДокументыПоОС(Запрос, ТекстыЗапроса, ИмяРегистра);
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
	|	ДанныеДокумента.Организация КАК Организация,
	|	ДанныеДокумента.Период КАК Период,
	|	ДанныеДокумента.Номер КАК Номер
	|ИЗ
	|	ДанныеДокументаРеквизиты КАК ДанныеДокумента";
	
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
	|	Документ.СнятиеСРегистрацииЗемельныхУчастков КАК СписокДокументов
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
	|	ДанныеДокумента.Ссылка КАК Ссылка,
	|	ДанныеДокумента.Организация КАК Организация,
	|	ДанныеДокумента.Дата КАК Период,
	|	ДанныеДокумента.Номер КАК Номер,
	|	ДанныеДокумента.ПометкаУдаления КАК ПометкаУдаления,
	|	ДанныеДокумента.Проведен КАК Проведен,
	|	ДанныеДокумента.Комментарий КАК Комментарий,
	|	ДанныеДокумента.Ответственный КАК Ответственный,
	|	ДанныеДокумента.СнятиеСРегистрацииСПрошлойДаты КАК СнятиеСРегистрацииСПрошлойДаты,
	|	КОНЕЦПЕРИОДА(ДанныеДокумента.ДатаСнятияСРегистрации, ДЕНЬ) КАК ДатаСнятияСРегистрации
	|
	|ПОМЕСТИТЬ ДанныеДокументаРеквизиты
	|
	|ИЗ
	|	Документ.СнятиеСРегистрацииЗемельныхУчастков КАК ДанныеДокумента
	|
	|ГДЕ
	|	ДанныеДокумента.Ссылка В (
	|		ВЫБРАТЬ
	|			ВтСписокДокументов.Ссылка
	|		ИЗ
	|			ВтСписокДокументов КАК ВтСписокДокументов)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Ссылка
	|";
	СписокЗапросов.Добавить(ТекстЗапроса);
	#КонецОбласти
	
	#Область ДанныеДокументаТаблицаОС
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ТаблицаДокумента.Ссылка КАК Ссылка,
	|	ТаблицаДокумента.НомерСтроки КАК НомерСтроки,
	|	ТаблицаДокумента.ОсновноеСредство КАК ОсновноеСредство
	|
	|ПОМЕСТИТЬ ДанныеДокументаТаблицаОС
	|
	|ИЗ
	|	Документ.СнятиеСРегистрацииЗемельныхУчастков.ОС КАК ТаблицаДокумента
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
	ЗначенияПараметровПроведения.Вставить("ИдентификаторМетаданных", ОбщегоНазначения.ИдентификаторОбъектаМетаданных("Документ.СнятиеСРегистрацииЗемельныхУчастков"));
	ЗначенияПараметровПроведения.Вставить("ХозяйственнаяОперация", Перечисления.ХозяйственныеОперации.СнятиеСРегистрацииЗемельныхУчастков);

	Если Реквизиты <> Неопределено Тогда
		ЗначенияПараметровПроведения.Вставить("НомерНаПечать", ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(Реквизиты.Номер));
	КонецЕсли; 
	
	Возврат ЗначенияПараметровПроведения;
	
КонецФункции

Процедура ТекстЗапросаТаблицаПараметрыНачисленияЗемельногоНалога(ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ПараметрыНачисленияЗемельногоНалога";
	
	Если Не ПроведениеДокументов.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат;
	КонецЕсли;
	
	ВнеоборотныеАктивыЛокализация.ТекстЗапросаТаблицаВтПараметрыНачисленияЗемельногоНалога(ТекстыЗапроса);
	
	ВнеоборотныеАктивыЛокализация.ТекстЗапросаТаблицаВтПараметрыНачисленияЗемельногоНалога(
		ТекстыЗапроса,, "ВтПараметрыНачисленияТранспортногоНалога_СУчетомИсправлений", Истина);
	
	Текст = 
	"ВЫБРАТЬ
	|	ДанныеДокумента.Ссылка КАК Регистратор,
	|	НАЧАЛОПЕРИОДА(ДанныеДокумента.Период, ДЕНЬ) КАК Период,
	|	ДАТАВРЕМЯ(1,1,1) КАК ДатаИсправления,
	|
	|	ДанныеДокумента.Организация КАК Организация,
	|	ТабличнаяЧастьДокумента.ОсновноеСредство КАК ОсновноеСредство,
	|	
	|	ЛОЖЬ КАК ВключатьВНалоговуюБазу,
	|
	|	ПараметрыНачисленияЗемельногоНалога.ДатаРегистрацииПравНаОбъектНедвижимости КАК ДатаРегистрацииПравНаОбъектНедвижимости,
	|	ПараметрыНачисленияЗемельногоНалога.ДоляВПравеОбщейСобственностиЗнаменатель КАК ДоляВПравеОбщейСобственностиЗнаменатель,
	|	ПараметрыНачисленияЗемельногоНалога.ДоляВПравеОбщейСобственностиЧислитель КАК ДоляВПравеОбщейСобственностиЧислитель,
	|	ПараметрыНачисленияЗемельногоНалога.ДоляНеОблагаемойНалогомПлощадиЗнаменатель КАК ДоляНеОблагаемойНалогомПлощадиЗнаменатель,
	|	ПараметрыНачисленияЗемельногоНалога.ДоляНеОблагаемойНалогомПлощадиЧислитель КАК ДоляНеОблагаемойНалогомПлощадиЧислитель,
	|	ПараметрыНачисленияЗемельногоНалога.ЖилищноеСтроительство КАК ЖилищноеСтроительство,
	|	ПараметрыНачисленияЗемельногоНалога.КадастроваяСтоимость КАК КадастроваяСтоимость,
	|	ПараметрыНачисленияЗемельногоНалога.КадастровыйНомер КАК КадастровыйНомер,
	|	ПараметрыНачисленияЗемельногоНалога.КБК КАК КБК,
	|	ПараметрыНачисленияЗемельногоНалога.КодКатегорииЗемель КАК КодКатегорииЗемель,
	|	ПараметрыНачисленияЗемельногоНалога.КодПоОКАТО КАК КодПоОКАТО,
	|	ПараметрыНачисленияЗемельногоНалога.КодПоОКТМО КАК КодПоОКТМО,
	|	ПараметрыНачисленияЗемельногоНалога.НалоговаяСтавка КАК НалоговаяСтавка,
	|	ПараметрыНачисленияЗемельногоНалога.НалоговыйОрган КАК НалоговыйОрган,
	|	ПараметрыНачисленияЗемельногоНалога.НеОблагаемаяНалогомСумма КАК НеОблагаемаяНалогомСумма,
	|	ПараметрыНачисленияЗемельногоНалога.ОбщаяСобственность КАК ОбщаяСобственность,
	|	ПараметрыНачисленияЗемельногоНалога.ПостановкаНаУчетВНалоговомОргане КАК ПостановкаНаУчетВНалоговомОргане,
	|	ПараметрыНачисленияЗемельногоНалога.СниженнаяНалоговаяСтавка КАК СниженнаяНалоговаяСтавка,
	|	ПараметрыНачисленияЗемельногоНалога.СуммаУменьшенияСуммыНалога КАК СуммаУменьшенияСуммыНалога,
	|	// До 2020 года.
	|	ПараметрыНачисленияЗемельногоНалога.ДатаНачалаПроектированияДо2008 КАК ДатаНачалаПроектированияДо2008,
	|	ПараметрыНачисленияЗемельногоНалога.КодНалоговойЛьготыОсвобождениеОтНалогообложенияПоСтатье395До2020 
	|											КАК КодНалоговойЛьготыОсвобождениеОтНалогообложенияПоСтатье395До2020,
	|	ПараметрыНачисленияЗемельногоНалога.КодНалоговойЛьготыУменьшениеНалоговойБазыПоСтатье391До2020 
	|											КАК КодНалоговойЛьготыУменьшениеНалоговойБазыПоСтатье391До2020,
	|	ПараметрыНачисленияЗемельногоНалога.НалоговаяЛьготаПоНалоговойБазеДо2020 КАК НалоговаяЛьготаПоНалоговойБазеДо2020,
	|	ПараметрыНачисленияЗемельногоНалога.ПроцентУменьшенияСуммыНалогаДо2020 КАК ПроцентУменьшенияСуммыНалогаДо2020,
	|	ПараметрыНачисленияЗемельногоНалога.УменьшениеНалоговойБазыНаСуммуДо2020 КАК УменьшениеНалоговойБазыНаСуммуДо2020,
	|	ПараметрыНачисленияЗемельногоНалога.УменьшениеНалоговойБазыПоСтатье391До2020 КАК УменьшениеНалоговойБазыПоСтатье391До2020,
	|	// С 2020 года.
	|	ПараметрыНачисленияЗемельногоНалога.ОснованиеЛьготыПоНалоговойБазе КАК ОснованиеЛьготыПоНалоговойБазе,
	|	ПараметрыНачисленияЗемельногоНалога.НачалоДействияЛьготыПоНалоговойБазе КАК НачалоДействияЛьготыПоНалоговойБазе,
	|	ПараметрыНачисленияЗемельногоНалога.ОкончаниеДействияЛьготыПоНалоговойБазе КАК ОкончаниеДействияЛьготыПоНалоговойБазе,
	|	ПараметрыНачисленияЗемельногоНалога.ОснованиеЛьготыСнижениеСтавки КАК ОснованиеЛьготыСнижениеСтавки,
	|	ПараметрыНачисленияЗемельногоНалога.НачалоДействияЛьготыСнижениеСтавки КАК НачалоДействияЛьготыСнижениеСтавки,
	|	ПараметрыНачисленияЗемельногоНалога.ОкончаниеДействияЛьготыСнижениеСтавки КАК ОкончаниеДействияЛьготыСнижениеСтавки,
	|	ПараметрыНачисленияЗемельногоНалога.ОснованиеЛьготыСнижениеСуммыНалога КАК ОснованиеЛьготыСнижениеСуммыНалога,
	|	ПараметрыНачисленияЗемельногоНалога.НачалоДействияЛьготыСнижениеСуммыНалога КАК НачалоДействияЛьготыСнижениеСуммыНалога,
	|	ПараметрыНачисленияЗемельногоНалога.ОкончаниеДействияЛьготыСнижениеСуммыНалога КАК ОкончаниеДействияЛьготыСнижениеСуммыНалога,
	|
	|	ЗНАЧЕНИЕ(Перечисление.ВидЗаписиОРегистрации.СнятиеСРегистрационногоУчета) КАК ВидЗаписи
	|
	|ИЗ
	|	ДанныеДокументаРеквизиты КАК ДанныеДокумента
	|
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ДанныеДокументаТаблицаОС КАК ТабличнаяЧастьДокумента
	|		ПО ДанныеДокумента.Ссылка = ТабличнаяЧастьДокумента.Ссылка
	|
	|		ЛЕВОЕ СОЕДИНЕНИЕ втПараметрыНачисленияЗемельногоНалога КАК ПараметрыНачисленияЗемельногоНалога
	|		ПО ПараметрыНачисленияЗемельногоНалога.Ссылка = ТабличнаяЧастьДокумента.Ссылка
	|			И ПараметрыНачисленияЗемельногоНалога.ОсновноеСредство = ТабличнаяЧастьДокумента.ОсновноеСредство
	|
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВтПараметрыНачисленияТранспортногоНалога_СУчетомИсправлений КАК ДанныеРегистраПоследнее
	|		ПО ДанныеРегистраПоследнее.Ссылка = ТабличнаяЧастьДокумента.Ссылка
	|			И ДанныеРегистраПоследнее.ОсновноеСредство = ТабличнаяЧастьДокумента.ОсновноеСредство
	|
	|ГДЕ
	|	(НЕ ДанныеДокумента.СнятиеСРегистрацииСПрошлойДаты
	|		ИЛИ ЕСТЬNULL(ДанныеРегистраПоследнее.Период, ДАТАВРЕМЯ(1,1,1)) < ДанныеДокумента.Период)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ДанныеДокумента.Ссылка КАК Регистратор,
	|	ДанныеДокумента.ДатаСнятияСРегистрации КАК Период,
	|	ДанныеДокумента.Период КАК ДатаИсправления,
	|
	|	ДанныеДокумента.Организация КАК Организация,
	|	ТабличнаяЧастьДокумента.ОсновноеСредство КАК ОсновноеСредство,
	|	
	|	ЛОЖЬ КАК ВключатьВНалоговуюБазу,
	|
	|	ПараметрыНачисленияЗемельногоНалога.ДатаРегистрацииПравНаОбъектНедвижимости КАК ДатаРегистрацииПравНаОбъектНедвижимости,
	|	ПараметрыНачисленияЗемельногоНалога.ДоляВПравеОбщейСобственностиЗнаменатель КАК ДоляВПравеОбщейСобственностиЗнаменатель,
	|	ПараметрыНачисленияЗемельногоНалога.ДоляВПравеОбщейСобственностиЧислитель КАК ДоляВПравеОбщейСобственностиЧислитель,
	|	ПараметрыНачисленияЗемельногоНалога.ДоляНеОблагаемойНалогомПлощадиЗнаменатель КАК ДоляНеОблагаемойНалогомПлощадиЗнаменатель,
	|	ПараметрыНачисленияЗемельногоНалога.ДоляНеОблагаемойНалогомПлощадиЧислитель КАК ДоляНеОблагаемойНалогомПлощадиЧислитель,
	|	ПараметрыНачисленияЗемельногоНалога.ЖилищноеСтроительство КАК ЖилищноеСтроительство,
	|	ПараметрыНачисленияЗемельногоНалога.КадастроваяСтоимость КАК КадастроваяСтоимость,
	|	ПараметрыНачисленияЗемельногоНалога.КадастровыйНомер КАК КадастровыйНомер,
	|	ПараметрыНачисленияЗемельногоНалога.КБК КАК КБК,
	|	ПараметрыНачисленияЗемельногоНалога.КодКатегорииЗемель КАК КодКатегорииЗемель,
	|	ПараметрыНачисленияЗемельногоНалога.КодПоОКАТО КАК КодПоОКАТО,
	|	ПараметрыНачисленияЗемельногоНалога.КодПоОКТМО КАК КодПоОКТМО,
	|	ПараметрыНачисленияЗемельногоНалога.НалоговаяСтавка КАК НалоговаяСтавка,
	|	ПараметрыНачисленияЗемельногоНалога.НалоговыйОрган КАК НалоговыйОрган,
	|	ПараметрыНачисленияЗемельногоНалога.НеОблагаемаяНалогомСумма КАК НеОблагаемаяНалогомСумма,
	|	ПараметрыНачисленияЗемельногоНалога.ОбщаяСобственность КАК ОбщаяСобственность,
	|	ПараметрыНачисленияЗемельногоНалога.ПостановкаНаУчетВНалоговомОргане КАК ПостановкаНаУчетВНалоговомОргане,
	|	ПараметрыНачисленияЗемельногоНалога.СниженнаяНалоговаяСтавка КАК СниженнаяНалоговаяСтавка,
	|	ПараметрыНачисленияЗемельногоНалога.СуммаУменьшенияСуммыНалога КАК СуммаУменьшенияСуммыНалога,
	|	// До 2020 года.
	|	ПараметрыНачисленияЗемельногоНалога.ДатаНачалаПроектированияДо2008 КАК ДатаНачалаПроектированияДо2008,
	|	ПараметрыНачисленияЗемельногоНалога.КодНалоговойЛьготыОсвобождениеОтНалогообложенияПоСтатье395До2020 
	|											КАК КодНалоговойЛьготыОсвобождениеОтНалогообложенияПоСтатье395До2020,
	|	ПараметрыНачисленияЗемельногоНалога.КодНалоговойЛьготыУменьшениеНалоговойБазыПоСтатье391До2020 
	|											КАК КодНалоговойЛьготыУменьшениеНалоговойБазыПоСтатье391До2020,
	|	ПараметрыНачисленияЗемельногоНалога.НалоговаяЛьготаПоНалоговойБазеДо2020 КАК НалоговаяЛьготаПоНалоговойБазеДо2020,
	|	ПараметрыНачисленияЗемельногоНалога.ПроцентУменьшенияСуммыНалогаДо2020 КАК ПроцентУменьшенияСуммыНалогаДо2020,
	|	ПараметрыНачисленияЗемельногоНалога.УменьшениеНалоговойБазыНаСуммуДо2020 КАК УменьшениеНалоговойБазыНаСуммуДо2020,
	|	ПараметрыНачисленияЗемельногоНалога.УменьшениеНалоговойБазыПоСтатье391До2020 КАК УменьшениеНалоговойБазыПоСтатье391До2020,
	|	// С 2020 года.
	|	ПараметрыНачисленияЗемельногоНалога.ОснованиеЛьготыПоНалоговойБазе КАК ОснованиеЛьготыПоНалоговойБазе,
	|	ПараметрыНачисленияЗемельногоНалога.НачалоДействияЛьготыПоНалоговойБазе КАК НачалоДействияЛьготыПоНалоговойБазе,
	|	ПараметрыНачисленияЗемельногоНалога.ОкончаниеДействияЛьготыПоНалоговойБазе КАК ОкончаниеДействияЛьготыПоНалоговойБазе,
	|	ПараметрыНачисленияЗемельногоНалога.ОснованиеЛьготыСнижениеСтавки КАК ОснованиеЛьготыСнижениеСтавки,
	|	ПараметрыНачисленияЗемельногоНалога.НачалоДействияЛьготыСнижениеСтавки КАК НачалоДействияЛьготыСнижениеСтавки,
	|	ПараметрыНачисленияЗемельногоНалога.ОкончаниеДействияЛьготыСнижениеСтавки КАК ОкончаниеДействияЛьготыСнижениеСтавки,
	|	ПараметрыНачисленияЗемельногоНалога.ОснованиеЛьготыСнижениеСуммыНалога КАК ОснованиеЛьготыСнижениеСуммыНалога,
	|	ПараметрыНачисленияЗемельногоНалога.НачалоДействияЛьготыСнижениеСуммыНалога КАК НачалоДействияЛьготыСнижениеСуммыНалога,
	|	ПараметрыНачисленияЗемельногоНалога.ОкончаниеДействияЛьготыСнижениеСуммыНалога КАК ОкончаниеДействияЛьготыСнижениеСуммыНалога,
	|	
	|	ЗНАЧЕНИЕ(Перечисление.ВидЗаписиОРегистрации.СнятиеСРегистрационногоУчета) КАК ВидЗаписи
	|
	|ИЗ
	|	ДанныеДокументаРеквизиты КАК ДанныеДокумента
	|
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ДанныеДокументаТаблицаОС КАК ТабличнаяЧастьДокумента
	|		ПО ДанныеДокумента.Ссылка = ТабличнаяЧастьДокумента.Ссылка
	|
	|		ЛЕВОЕ СОЕДИНЕНИЕ втПараметрыНачисленияЗемельногоНалога КАК ПараметрыНачисленияЗемельногоНалога
	|		ПО ПараметрыНачисленияЗемельногоНалога.Ссылка = ТабличнаяЧастьДокумента.Ссылка
	|			И ПараметрыНачисленияЗемельногоНалога.ОсновноеСредство = ТабличнаяЧастьДокумента.ОсновноеСредство
	|ГДЕ
	|	ДанныеДокумента.СнятиеСРегистрацииСПрошлойДаты
	|";
	
	ТекстыЗапроса.Добавить(Текст, ИмяРегистра);
	
КонецПроцедуры

Функция ТекстЗапросаТаблицаРеестрДокументов(Запрос, ТекстыЗапроса, Регистры)
	
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
	|	Документ.СнятиеСРегистрацииЗемельныхУчастков КАК ДанныеДокумента
	|
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка
	|";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаТаблицаДокументыПоОС(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ДокументыПоОС";
	
	Если НЕ ПроведениеДокументов.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ЕСТЬNULL(ТаблицаОС.НомерСтроки-1, 0)    КАК НомерЗаписи,
	|	ДанныеДокумента.Ссылка                  КАК Ссылка,
	|	ДанныеДокумента.Дата                    КАК Дата,
	|	ДанныеДокумента.Организация             КАК Организация,
	|	ДанныеДокумента.Проведен                КАК Проведен,
	|	&ХозяйственнаяОперация                  КАК ХозяйственнаяОперация,
	|	&ИдентификаторМетаданных                КАК ТипСсылки,
	|	ИСТИНА                                  КАК ОтражатьВРеглУчете,
	|	ЛОЖЬ                                    КАК ОтражатьВУпрУчете,
	|	ТаблицаОС.ОсновноеСредство              КАК ОсновноеСредство,
	|	ДанныеДокумента.СнятиеСРегистрацииСПрошлойДаты КАК ЭтоИсправление,
	|
	|	ВЫБОР
	|		КОГДА ДанныеДокумента.СнятиеСРегистрацииСПрошлойДаты
	|			ТОГДА ДанныеДокумента.ДатаСнятияСРегистрации
	|		ИНАЧЕ ДАТАВРЕМЯ(1,1,1)
	|	КОНЕЦ КАК НачалоПериодаИсправления,
	|
	|	ВЫБОР
	|		КОГДА ДанныеДокумента.СнятиеСРегистрацииСПрошлойДаты
	|			ТОГДА КОНЕЦПЕРИОДА(ДанныеДокумента.Дата, МЕСЯЦ)
	|		ИНАЧЕ ДАТАВРЕМЯ(1,1,1)
	|	КОНЕЦ КАК КонецПериодаИсправления
	|
	|ИЗ
	|	Документ.СнятиеСРегистрацииЗемельныхУчастков КАК ДанныеДокумента
	|
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.СнятиеСРегистрацииЗемельныхУчастков.ОС КАК ТаблицаОС
	|		ПО ТаблицаОС.Ссылка = ДанныеДокумента.Ссылка
	|
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка
	|";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

#КонецОбласти

#Область Печать

// Заполняет список команд печати.
//
// Параметры:
//   КомандыПечати - см. УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	
	
КонецПроцедуры

#КонецОбласти

#Область БлокировкаПриОбновленииИБ

Процедура ПроверитьБлокировкуВходящихДанныхПриОбновленииИБ(ПредставлениеОперации) Экспорт
	
	ВходящиеДанные = Новый Соответствие;
	
	ЗакрытиеМесяцаСервер.ПроверитьБлокировкуВходящихДанныхПриОбновленииИБ(ВходящиеДанные, ПредставлениеОперации);
	
КонецПроцедуры

#КонецОбласти

#Область СтандартныеПодсистемы

// Определяет список команд создания на основании.
//
// Параметры:
//  КомандыСозданияНаОсновании - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
//  Параметры - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.Параметры
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСозданияНаОсновании, Параметры) Экспорт
	
	Возврат; //В дальнейшем будет добавлен код команд
	
КонецПроцедуры

// Определяет список команд отчетов.
//
// Параметры:
//   КомандыОтчетов - См. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.КомандыОтчетов
//   Параметры - См. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.Параметры
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры) Экспорт
	
	
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
