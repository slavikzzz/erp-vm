
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
	
	Если ТипЗнч(Документ) = Тип("ДокументОбъект.ИзменениеСпособаОтраженияИмущественныхНалогов") Тогда
		ДокументСсылка = Документ.Ссылка;
	Иначе
		ДокументСсылка = Документ;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	ТекстыЗапроса = Новый СписокЗначений;
	
	Если Не ДопПараметры.ПолучитьТекстыЗапроса Тогда
		
		ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка, ДопПараметры);
		
		СпособыОтраженияРасходовПоИмущественнымНалогам(ТекстыЗапроса, Регистры);
		ТекстЗапросаТаблицаРеестрДокументов(Запрос, ТекстыЗапроса, Регистры);
		ТекстЗапросаТаблицаДокументыПоОС(Запрос, ТекстыЗапроса, Регистры);
		
	КонецЕсли;
	
	Возврат ПроведениеДокументов.ИнициализироватьДанныеДокументаДляПроведения(Запрос, ТекстыЗапроса, ДопПараметры);
	
КонецФункции

#КонецОбласти

#Область ДляВызоваИзДругихПодсистем

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

#Область СлужебныйПрограммныйИнтерфейс


// Возвращает список ОС, которые не соответствуют виду налога.
// 
// Возвращаемое значение:
// 	Массив из СправочникСсылка.ОбъектыЭксплуатации - Список ОС.
Функция ОсновныеСредстваКоторыеНеСоответствуютВидуНалога(ВидНалога, СписокОС, Дата, Организация) Экспорт

	Если НЕ ЗначениеЗаполнено(ВидНалога) Тогда
		Возврат Новый Массив;
	КонецЕсли; 
	
	ТекстЗапроса = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ОбъектыЭксплуатации.Ссылка КАК Ссылка,
	|	ОбъектыЭксплуатации.Наименование КАК Наименование,
	|	ОбъектыЭксплуатации.ГруппаОС КАК ГруппаОС,
	|	ПорядокУчетаОСБУ.АмортизационнаяГруппа КАК АмортизационнаяГруппа,
	|	ПорядокУчетаОСБУ.НедвижимоеИмущество КАК НедвижимоеИмущество
	|ПОМЕСТИТЬ ОбъектыЭксплуатации
	|ИЗ
	|	Справочник.ОбъектыЭксплуатации КАК ОбъектыЭксплуатации
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПорядокУчетаОСБУ.СрезПоследних(
	|				&ДатаСведений,
	|				ДатаИсправления = ДАТАВРЕМЯ(1,1,1)
	|					И Организация = &Организация
	|					И ОсновноеСредство В (&СписокОС)) КАК ПорядокУчетаОСБУ
	|		ПО (ПорядокУчетаОСБУ.ОсновноеСредство = ОбъектыЭксплуатации.Ссылка)
	|ГДЕ
	|	ОбъектыЭксплуатации.Ссылка В(&СписокОС)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ОбъектыЭксплуатации.Ссылка КАК Ссылка,
	|	ОбъектыЭксплуатации.Наименование КАК Наименование,
	|	ОбъектыЭксплуатации.ГруппаОС КАК ГруппаОС,
	|	ОбъектыЭксплуатации.АмортизационнаяГруппа КАК АмортизационнаяГруппа
	|ИЗ
	|	ОбъектыЭксплуатации КАК ОбъектыЭксплуатации
	|ГДЕ
	|	НЕ &УсловияОтбораПоВидуНалога";
	
	
	ТекстУсловияОтбораПоВидуНалога = ВнеоборотныеАктивыЛокализация.УсловияОтбораПоВидуНалога(
			"ОбъектыЭксплуатации", 
			"ЕСТЬNULL(ОбъектыЭксплуатации.АмортизационнаяГруппа, НЕОПРЕДЕЛЕНО)",
			"ОбъектыЭксплуатации.НедвижимоеИмущество");
	
	ТекстЗапроса = СтрЗаменить(
					ТекстЗапроса, 
					"&УсловияОтбораПоВидуНалога", 
					ТекстУсловияОтбораПоВидуНалога);
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("ВидНалога", ВидНалога);
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("СписокОС", СписокОС);
	Запрос.УстановитьПараметр("ДатаСведений", Дата);
	Запрос.УстановитьПараметр("ИспользуетсяУправлениеВНА_2_4", ВнеоборотныеАктивы.ИспользуетсяУправлениеВНА_2_4(Дата));
	
	Результат = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	
	Возврат Результат;

КонецФункции

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
	
	ПолноеИмяДокумента = "Документ.ИзменениеСпособаОтраженияИмущественныхНалогов";
	
	ЗначенияПараметров = ЗначенияПараметровПроведения();
	ПереопределениеРасчетаПараметров = Новый Структура;
	ПереопределениеРасчетаПараметров.Вставить("НомерНаПечать", """""");
	
	ВЗапросеЕстьИсточник = Истина;
	
	Если ИмяРегистра = "РеестрДокументов" Тогда
		
		ТекстЗапроса = ТекстЗапросаТаблицаРеестрДокументов(Запрос, ТекстыЗапроса, ИмяРегистра);
		СинонимТаблицыДокумента = "";
		ВЗапросеЕстьИсточник = Ложь;
		
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
	
	ПолучитьДанныеДокумента(Запрос);

	Запрос.Текст =
	"ВЫБРАТЬ
	|	ДанныеДокумента.Ссылка,
	|	ДанныеДокумента.Номер,
	|	ДанныеДокумента.Дата КАК Период,
	|	ДанныеДокумента.Организация,
	|	ДанныеДокумента.ВидНалога,
	|	ДанныеДокумента.Ответственный,
	|	ДанныеДокумента.ПометкаУдаления,
	|	ДанныеДокумента.Проведен,
	|	ДанныеДокумента.Комментарий
	|ИЗ
	|	Документ.ИзменениеСпособаОтраженияИмущественныхНалогов КАК ДанныеДокумента
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
	
КонецПроцедуры

Процедура ПолучитьДанныеДокумента(Запрос)
	
	СписокЗапросов = Новый Массив;
	
	#Область ДанныеДокументаРеквизиты
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ДанныеДокумента.Ссылка КАК Ссылка,
	|	ДанныеДокумента.Дата КАК Период,
	|	ДанныеДокумента.Номер КАК Номер,
	|	ДанныеДокумента.Организация КАК Организация
	|
	|ПОМЕСТИТЬ ДанныеДокументаРеквизиты
	|
	|ИЗ
	|	Документ.ИзменениеСпособаОтраженияИмущественныхНалогов КАК ДанныеДокумента
	|
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка
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
	|	ТаблицаДокумента.ОсновноеСредство КАК ОсновноеСредство,
	|	ТаблицаДокумента.ОсновноеСредство КАК ОбъектУчета
	|
	|ПОМЕСТИТЬ ДанныеДокументаТаблицаОС
	|
	|ИЗ
	|	Документ.ИзменениеСпособаОтраженияИмущественныхНалогов.ОС КАК ТаблицаДокумента
	|
	|ГДЕ
	|	ТаблицаДокумента.Ссылка = &Ссылка
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
	ЗначенияПараметровПроведения.Вставить("ИдентификаторМетаданных", ОбщегоНазначения.ИдентификаторОбъектаМетаданных("Документ.ИзменениеСпособаОтраженияИмущественныхНалогов"));
	ЗначенияПараметровПроведения.Вставить("ХозяйственнаяОперация", Перечисления.ХозяйственныеОперации.ИзменениеСпособаОтраженияИмущественныхНалогов);

	Если Реквизиты <> Неопределено Тогда
		ЗначенияПараметровПроведения.Вставить("НомерНаПечать", ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(Реквизиты.Номер));
		ЗначенияПараметровПроведения.Вставить("ИспользуетсяУправлениеВНА_2_4", ВнеоборотныеАктивы.ИспользуетсяУправлениеВНА_2_4(Реквизиты.Период));
	КонецЕсли; 
	
	Возврат ЗначенияПараметровПроведения;
	
КонецФункции

Функция СпособыОтраженияРасходовПоИмущественнымНалогам(ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "СпособыОтраженияРасходовПоИмущественнымНалогам";
	
	Если Не ПроведениеДокументов.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	ВнеоборотныеАктивыСлужебный.ТекстЗапросаТаблицаВтПорядокУчетаОСБУ(ТекстыЗапроса);
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	&Период КАК Период,
	|	ТабличнаяЧастьДокумента.ОсновноеСредство КАК ОсновноеСредство,
	|	&Организация КАК Организация,
	|	ЗНАЧЕНИЕ(Перечисление.ВидыИмущественныхНалогов.НалогНаИмущество) КАК ВидНалога,
	|	ИСТИНА КАК СпособОтраженияРасходовЗаданДокументом,
	|	&Ссылка КАК СпособОтраженияРасходов
	|ИЗ
	|	Документ.ИзменениеСпособаОтраженияИмущественныхНалогов.ОС КАК ТабличнаяЧастьДокумента
	|		ЛЕВОЕ СОЕДИНЕНИЕ втПорядокУчетаОСБУ КАК втПорядокУчетаОСБУ
	|		ПО втПорядокУчетаОСБУ.ОсновноеСредство = ТабличнаяЧастьДокумента.ОсновноеСредство
	|ГДЕ
	|	ТабличнаяЧастьДокумента.Ссылка = &Ссылка
	|	И &ВидНалога В (ЗНАЧЕНИЕ(Перечисление.ВидыИмущественныхНалогов.НалогНаИмущество), ЗНАЧЕНИЕ(Перечисление.ВидыИмущественныхНалогов.ПустаяСсылка))
	|	И ТабличнаяЧастьДокумента.ОсновноеСредство.ГруппаОС <> ЗНАЧЕНИЕ(Перечисление.ГруппыОС.ЗемельныеУчастки)
	|	И (&Период < ДАТАВРЕМЯ(2019, 1, 1)
	|		ИЛИ втПорядокУчетаОСБУ.НедвижимоеИмущество)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	&Период КАК Период,
	|	ТабличнаяЧастьДокумента.ОсновноеСредство КАК ОсновноеСредство,
	|	&Организация КАК Организация,
	|	ЗНАЧЕНИЕ(Перечисление.ВидыИмущественныхНалогов.ТранспортныйНалог) КАК ВидНалога,
	|	ИСТИНА КАК СпособОтраженияРасходовЗаданДокументом,
	|	&Ссылка КАК СпособОтраженияРасходов
	|ИЗ
	|	Документ.ИзменениеСпособаОтраженияИмущественныхНалогов.ОС КАК ТабличнаяЧастьДокумента
	|ГДЕ
	|	ТабличнаяЧастьДокумента.Ссылка = &Ссылка
	|	И &ВидНалога В (ЗНАЧЕНИЕ(Перечисление.ВидыИмущественныхНалогов.ТранспортныйНалог), ЗНАЧЕНИЕ(Перечисление.ВидыИмущественныхНалогов.ПустаяСсылка))
	|	И ТабличнаяЧастьДокумента.ОсновноеСредство.ГруппаОС В (
	|			ЗНАЧЕНИЕ(Перечисление.ГруппыОС.ТранспортныеСредства),
	|			ЗНАЧЕНИЕ(Перечисление.ГруппыОС.МашиныИОборудование)
	|		)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	&Период КАК Период,
	|	ТабличнаяЧастьДокумента.ОсновноеСредство КАК ОсновноеСредство,
	|	&Организация КАК Организация,
	|	ЗНАЧЕНИЕ(Перечисление.ВидыИмущественныхНалогов.ЗемельныйНалог) КАК ВидНалога,
	|	ИСТИНА КАК СпособОтраженияРасходовЗаданДокументом,
	|	&Ссылка КАК СпособОтраженияРасходов
	|ИЗ
	|	Документ.ИзменениеСпособаОтраженияИмущественныхНалогов.ОС КАК ТабличнаяЧастьДокумента
	|ГДЕ
	|	ТабличнаяЧастьДокумента.Ссылка = &Ссылка
	|	И &ВидНалога В (ЗНАЧЕНИЕ(Перечисление.ВидыИмущественныхНалогов.ЗемельныйНалог), ЗНАЧЕНИЕ(Перечисление.ВидыИмущественныхНалогов.ПустаяСсылка))
	|	И ТабличнаяЧастьДокумента.ОсновноеСредство.ГруппаОС = ЗНАЧЕНИЕ(Перечисление.ГруппыОС.ЗемельныеУчастки)";
	
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
	|	&Ссылка                                 КАК Ссылка,
	|	&Период                                 КАК ДатаДокументаИБ,
	|	&Номер                                  КАК НомерДокументаИБ,
	|	&ИдентификаторМетаданных                КАК ТипСсылки,
	|	&Организация                            КАК Организация,
	|	&ХозяйственнаяОперация                  КАК ХозяйственнаяОперация,
	|	&Ответственный                          КАК Ответственный,
	|	&Комментарий                            КАК Комментарий,
	|	&Проведен                               КАК Проведен,
	|	&ПометкаУдаления                        КАК ПометкаУдаления,
	|	ЛОЖЬ                                    КАК ДополнительнаяЗапись,
	|	&Период                                 КАК ДатаПервичногоДокумента,
	|	&НомерНаПечать                          КАК НомерПервичногоДокумента,
	|	ЛОЖЬ                                    КАК СторноИсправление,
	|	НЕОПРЕДЕЛЕНО                            КАК СторнируемыйДокумент,
	|	НЕОПРЕДЕЛЕНО                            КАК ИсправляемыйДокумент,
	|	&Период                                 КАК ДатаОтраженияВУчете,
	|	НЕОПРЕДЕЛЕНО                            КАК Приоритет";
	
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
	|	&Ссылка                                 КАК Ссылка,
	|	&Период                                 КАК Дата,
	|	&Организация                            КАК Организация,
	|	&Проведен                               КАК Проведен,
	|	&ХозяйственнаяОперация                  КАК ХозяйственнаяОперация,
	|	&ИдентификаторМетаданных                КАК ТипСсылки,
	|	ИСТИНА                                  КАК ОтражатьВРеглУчете,
	|	ЛОЖЬ                                    КАК ОтражатьВУпрУчете,
	|	ТаблицаОС.ОсновноеСредство              КАК ОсновноеСредство
	|ИЗ
	|	Документ.ИзменениеСпособаОтраженияИмущественныхНалогов КАК ДанныеДокумента
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ИзменениеСпособаОтраженияИмущественныхНалогов.ОС КАК ТаблицаОС
	|		ПО ТаблицаОС.Ссылка = ДанныеДокумента.Ссылка
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка";
	
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

Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт
	
	Возврат; //В дальнейшем будет добавлен код настроек версионирования
	
КонецПроцедуры

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

#Область Прочее

Функция ПараметрыВыбораСтатейИАналитик() Экспорт
	
	ПараметрыВыбора = ДоходыИРасходыСервер.ПараметрыВыбораСтатьиИАналитики();
	ПараметрыВыбора.ПутьКДанным = "Объект.ОтражениеРасходов";
	ПараметрыВыбора.Статья = "СтатьяРасходов";
	
	ПараметрыВыбора.ВыборСтатьиРасходов = Истина;
	ПараметрыВыбора.АналитикаРасходов = "АналитикаРасходов";
	
	ПараметрыВыбора.ЭлементыФормы.Статья.Добавить("ОтражениеРасходовСтатьяРасходов");
	ПараметрыВыбора.ЭлементыФормы.АналитикаРасходов.Добавить("ОтражениеРасходовАналитикаРасходов");
	
	Возврат ПараметрыВыбора;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли
