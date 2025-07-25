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
	
	МеханизмыДокумента.Добавить("НематериальныеАктивы");
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
	
	Если ТипЗнч(Документ) = Тип("ДокументОбъект.ИзменениеПараметровНМА") Тогда
		ДокументСсылка = Документ.Ссылка;
	Иначе
		ДокументСсылка = Документ;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	ТекстыЗапроса = Новый СписокЗначений;
	
	Если Не ДопПараметры.ПолучитьТекстыЗапроса Тогда
		
		ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка, ДопПараметры);
		
		ТекстЗапросаТаблицаПараметрыАмортизацииНМАБУ(ТекстыЗапроса, Регистры);
		ТекстЗапросаТаблицаПорядокУчетаНМАБУ(ТекстыЗапроса, Регистры);
		
		ТекстЗапросаТаблицаРеестрДокументов(ТекстыЗапроса, Регистры);
		ТекстЗапросаТаблицаДокументыПоНМА(ТекстыЗапроса, Регистры);
		
	КонецЕсли;
	
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

// Добавляет команду создания документа "Изменение параметров НМА".
//
// Параметры:
//  КомандыСозданияНаОсновании - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
//
Функция ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании) Экспорт
	Если ПравоДоступа("Добавление", Метаданные.Документы.ИзменениеПараметровНМА) Тогда
		КомандаСоздатьНаОсновании = КомандыСозданияНаОсновании.Добавить();
		КомандаСоздатьНаОсновании.Менеджер = Метаданные.Документы.ИзменениеПараметровНМА.ПолноеИмя();
		КомандаСоздатьНаОсновании.Представление = ОбщегоНазначенияУТ.ПредставлениеОбъекта(Метаданные.Документы.ИзменениеПараметровНМА);
		КомандаСоздатьНаОсновании.ФункциональныеОпции = "ОтображатьВнеоборотныеАктивы2_2";
		КомандаСоздатьНаОсновании.РежимЗаписи = "Проводить";
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

#Область СлужебныеПроцедурыИФункции

#Область Проведение

Функция ДополнительныеИсточникиДанныхДляДвижений(ИмяРегистра) Экспорт

	ИсточникиДанных = Новый Соответствие;

	Возврат ИсточникиДанных; 

КонецФункции

Функция АдаптированныйТекстЗапросаДвиженийПоРегистру(ИмяРегистра) Экспорт

	ТекстыЗапроса = Новый СписокЗначений;
	
	ПолноеИмяДокумента = "Документ.ИзменениеПараметровНМА";
	
	ЗначенияПараметров = ЗначенияПараметровПроведения();
	ПереопределениеРасчетаПараметров = Новый Структура;
	ПереопределениеРасчетаПараметров.Вставить("НомерНаПечать", """""");
	
	ВЗапросеЕстьИсточник = Истина;
	
	Если ИмяРегистра = "РеестрДокументов" Тогда
		
		ТекстЗапроса = ТекстЗапросаТаблицаРеестрДокументов(ТекстыЗапроса, ИмяРегистра);
		СинонимТаблицыДокумента = "";
		ВЗапросеЕстьИсточник = Ложь;
		
	ИначеЕсли ИмяРегистра = "ДокументыПоНМА" Тогда
		
		ТекстЗапроса = ТекстЗапросаТаблицаДокументыПоНМА(ТекстыЗапроса, ИмяРегистра);
		СинонимТаблицыДокумента = "ДанныеДокумента";
		
	Иначе
		ТекстИсключения = НСтр("ru = 'В документе %ПолноеИмяДокумента% не реализована адаптация текста запроса формирования движений по регистру %ИмяРегистра%.';
								|en = 'In document %ПолноеИмяДокумента%, adaptation of request for generating records of register %ИмяРегистра% is not implemented.'");
		ТекстИсключения = СтрЗаменить(ТекстИсключения, "%ПолноеИмяДокумента%", ПолноеИмяДокумента);
		ТекстИсключения = СтрЗаменить(ТекстИсключения, "%ИмяРегистра%", ИмяРегистра);
		
		ВызватьИсключение ТекстИсключения;
	КонецЕсли;
	
	Если ИмяРегистра = "РеестрДокументов"
		ИЛИ ИмяРегистра = "ДокументыПоНМА" Тогда
		
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
	|	ДанныеДокумента.Ссылка КАК Регистратор,
	|	ДанныеДокумента.Дата КАК Период,
	|	ДанныеДокумента.Номер КАК Номер,
	|	ДанныеДокумента.Организация КАК Организация,
	|	ДанныеДокумента.СпециальныйКоэффициентНУ,
	|	ДанныеДокумента.СпециальныйКоэффициентНУФлаг,
	|	ДанныеДокумента.ОтражениеАмортизационныхРасходовФлаг,
	|	ДанныеДокумента.Ответственный КАК Ответственный,
	|	ДанныеДокумента.Комментарий КАК Комментарий,
	|	ДанныеДокумента.Проведен КАК Проведен,
	|	ДанныеДокумента.ПометкаУдаления КАК ПометкаУдаления
	|ИЗ
	|	Документ.ИзменениеПараметровНМА КАК ДанныеДокумента
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
	|	ДанныеДокумента.Организация КАК Организация,
	|	ДанныеДокумента.Организация.ГоловнаяОрганизация КАК ГоловнаяОрганизация
	|
	|ПОМЕСТИТЬ ДанныеДокументаРеквизиты
	|
	|ИЗ
	|	Документ.ИзменениеПараметровНМА КАК ДанныеДокумента
	|
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Ссылка
	|";
	СписокЗапросов.Добавить(ТекстЗапроса);
	#КонецОбласти
	
	#Область ДанныеДокументаТаблицаНМА
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ТаблицаДокумента.Ссылка КАК Ссылка,
	|	ТаблицаДокумента.НематериальныйАктив КАК НематериальныйАктив,
	|	ТаблицаДокумента.НематериальныйАктив КАК ОбъектУчета
	|
	|ПОМЕСТИТЬ ДанныеДокументаТаблицаНМА
	|
	|ИЗ
	|	Документ.ИзменениеПараметровНМА.НМА КАК ТаблицаДокумента
	|
	|ГДЕ
	|	ТаблицаДокумента.Ссылка = &Ссылка
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Ссылка,
	|	НематериальныйАктив
	|";
	СписокЗапросов.Добавить(ТекстЗапроса);
	#КонецОбласти
	
	Запрос.Текст = СтрСоединить(СписокЗапросов, ОбщегоНазначения.РазделительПакетаЗапросов());
	
	Запрос.Выполнить();
	
КонецПроцедуры

Функция ЗначенияПараметровПроведения(Реквизиты = Неопределено)

	ЗначенияПараметровПроведения = Новый Структура;
	ЗначенияПараметровПроведения.Вставить("ИдентификаторМетаданных", ОбщегоНазначения.ИдентификаторОбъектаМетаданных("Документ.ИзменениеПараметровНМА"));
	ЗначенияПараметровПроведения.Вставить("ХозяйственнаяОперация", Перечисления.ХозяйственныеОперации.ИзменениеПараметровНМА);

	Если Реквизиты <> Неопределено Тогда
		ЗначенияПараметровПроведения.Вставить("НомерНаПечать", ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(Реквизиты.Номер));
	КонецЕсли; 
	
	Возврат ЗначенияПараметровПроведения;
	
КонецФункции

Процедура ТекстЗапросаТаблицаПараметрыАмортизацииНМАБУ(ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ПараметрыАмортизацииНМАБУ";
	
	Если Не ПроведениеДокументов.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат;
	КонецЕсли;
	
	ВнеоборотныеАктивыСлужебный.ТекстЗапросаТаблицаВтПараметрыАмортизацииНМАБУ(ТекстыЗапроса);
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	&Ссылка КАК Регистратор,
	|	&Период КАК Период,
	|	&Организация КАК Организация,
	|	ТаблицаНМА.НематериальныйАктив КАК НематериальныйАктив,
	|	втПараметрыАмортизацииНМАБУ.СрокПолезногоИспользованияБУ КАК СрокПолезногоИспользованияБУ,
	|	втПараметрыАмортизацииНМАБУ.СрокПолезногоИспользованияНУ КАК СрокПолезногоИспользованияНУ,
	|	втПараметрыАмортизацииНМАБУ.КоэффициентБУ КАК КоэффициентБУ,
	|	&СпециальныйКоэффициентНУ КАК СпециальныйКоэффициент
	|ИЗ
	|	Документ.ИзменениеПараметровНМА.НМА КАК ТаблицаНМА
	|
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ втПараметрыАмортизацииНМАБУ КАК втПараметрыАмортизацииНМАБУ
	|		ПО втПараметрыАмортизацииНМАБУ.НематериальныйАктив = ТаблицаНМА.НематериальныйАктив
	|
	|ГДЕ
	|	ТаблицаНМА.Ссылка = &Ссылка
	|	И &СпециальныйКоэффициентНУФлаг";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
КонецПроцедуры

Процедура ТекстЗапросаТаблицаПорядокУчетаНМАБУ(ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ПорядокУчетаНМАБУ";
	
	Если Не ПроведениеДокументов.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат;
	КонецЕсли;
	
	ВнеоборотныеАктивыСлужебный.ТекстЗапросаТаблицаВтСписокНМА(ТекстыЗапроса);
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	&Период КАК Период,
	|	ТаблицаНМА.НематериальныйАктив КАК НематериальныйАктив,
	|	&Организация КАК Организация,
	|	
	|	ПорядокУчета.СостояниеБУ КАК СостояниеБУ,
	|	ПорядокУчета.СостояниеНУ КАК СостояниеНУ,
	|
	|	ПорядокУчета.НачислятьАмортизациюБУ КАК НачислятьАмортизациюБУ,
	|	ПорядокУчета.НачислятьАмортизациюНУ КАК НачислятьАмортизациюНУ,
	|	ПорядокУчета.НалогообложениеНДС КАК НалогообложениеНДС,
	|
	|	ВЫБОР
	|		КОГДА &ОтражениеАмортизационныхРасходовФлаг
	|			ТОГДА &Ссылка
	|		ИНАЧЕ ПорядокУчета.СпособОтраженияРасходовБУ
	|	КОНЕЦ КАК СпособОтраженияРасходовБУ,
	|	ВЫБОР
	|		КОГДА &ОтражениеАмортизационныхРасходовФлаг
	|			ТОГДА &Ссылка
	|		ИНАЧЕ ПорядокУчета.СпособОтраженияРасходовНУ
	|	КОНЕЦ КАК СпособОтраженияРасходовНУ,
	|	ВЫБОР
	|		КОГДА &ОтражениеАмортизационныхРасходовФлаг
	|			ТОГДА НЕОПРЕДЕЛЕНО
	|		ИНАЧЕ ПорядокУчета.СтатьяРасходовБУ
	|	КОНЕЦ КАК СтатьяРасходовБУ,
	|	ВЫБОР
	|		КОГДА &ОтражениеАмортизационныхРасходовФлаг
	|			ТОГДА НЕОПРЕДЕЛЕНО
	|		ИНАЧЕ ПорядокУчета.АналитикаРасходовБУ
	|	КОНЕЦ КАК АналитикаРасходовБУ,
	|	ВЫБОР
	|		КОГДА &ОтражениеАмортизационныхРасходовФлаг
	|			ТОГДА НЕОПРЕДЕЛЕНО
	|		ИНАЧЕ ПорядокУчета.СтатьяРасходовНУ
	|	КОНЕЦ КАК СтатьяРасходовНУ,
	|	ВЫБОР
	|		КОГДА &ОтражениеАмортизационныхРасходовФлаг
	|			ТОГДА НЕОПРЕДЕЛЕНО
	|		ИНАЧЕ ПорядокУчета.АналитикаРасходовНУ
	|	КОНЕЦ КАК АналитикаРасходовНУ,
	|	ВЫБОР
	|		КОГДА &ОтражениеАмортизационныхРасходовФлаг
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ПорядокУчета.ПередаватьРасходыВДругуюОрганизацию
	|	КОНЕЦ КАК ПередаватьРасходыВДругуюОрганизацию,
	|	ВЫБОР
	|		КОГДА &ОтражениеАмортизационныхРасходовФлаг
	|			ТОГДА ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)
	|		ИНАЧЕ ПорядокУчета.ОрганизацияПолучательРасходов
	|	КОНЕЦ КАК ОрганизацияПолучательРасходов
	|ИЗ
	|	Документ.ИзменениеПараметровНМА.НМА КАК ТаблицаНМА
	|		
	|		ЛЕВОЕ СОЕДИНЕНИЕ
	|			РегистрСведений.ПорядокУчетаНМАБУ.СрезПоследних(
	|				&Период,
	|				Регистратор <> &Ссылка
	|				И &Организация = Организация
	|				И НематериальныйАктив В
	|						(ВЫБРАТЬ СписокНМА.НематериальныйАктив ИЗ ВтСписокНМА КАК СписокНМА)
	|			) КАК ПорядокУчета
	|		ПО
	|			ПорядокУчета.НематериальныйАктив = ТаблицаНМА.НематериальныйАктив
	|ГДЕ
	|	ТаблицаНМА.Ссылка = &Ссылка
	|	И &ОтражениеАмортизационныхРасходовФлаг";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра, Истина);
	
КонецПроцедуры

Функция ТекстЗапросаТаблицаРеестрДокументов(ТекстыЗапроса, Регистры)
	
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

Функция ТекстЗапросаТаблицаДокументыПоНМА(ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ДокументыПоНМА";
	
	Если НЕ ПроведениеДокументов.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ЕСТЬNULL(ТаблицаНМА.НомерСтроки-1, 0)   КАК НомерЗаписи,
	|	&Ссылка                                 КАК Ссылка,
	|	&Период                                 КАК Дата,
	|	&Организация                            КАК Организация,
	|	&ХозяйственнаяОперация                  КАК ХозяйственнаяОперация,
	|	&ИдентификаторМетаданных                КАК ТипСсылки,
	|	&Проведен                               КАК Проведен,
	|	&Проведен                               КАК ОтражатьВРеглУчете,
	|	ЛОЖЬ                                    КАК ОтражатьВУпрУчете,
	|	ТаблицаНМА.НематериальныйАктив          КАК НематериальныйАктив
	|ИЗ
	|	Документ.ИзменениеПараметровНМА КАК ДанныеДокумента
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ИзменениеПараметровНМА.НМА КАК ТаблицаНМА
	|		ПО ТаблицаНМА.Ссылка = ДанныеДокумента.Ссылка
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
	
	ВходящиеДанные.Вставить(Метаданные.РегистрыСведений.ПервоначальныеСведенияНМА);
	ВходящиеДанные.Вставить(Метаданные.РегистрыСведений.ПараметрыАмортизацииНМАБУ);
	
	ЗакрытиеМесяцаСервер.ПроверитьБлокировкуВходящихДанныхПриОбновленииИБ(ВходящиеДанные, ПредставлениеОперации);
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

Функция ПараметрыВыбораСтатейИАналитик(Объект) Экспорт
	
	ПараметрыВыбора = ДоходыИРасходыСервер.ПараметрыВыбораСтатьиИАналитики();
	ПараметрыВыбора.ПутьКДанным = "Объект.ОтражениеАмортизационныхРасходов";
	ПараметрыВыбора.Статья = "СтатьяРасходов";
	ПараметрыВыбора.ДоступностьПоОперации = Неопределено;
	
	ПараметрыВыбора.ВыборСтатьиРасходов = Истина;
	ПараметрыВыбора.АналитикаРасходов = "АналитикаРасходов";
	
	ПараметрыВыбора.ЭлементыФормы.Статья.Добавить("ОтражениеАмортизационныхРасходовСтатьяРасходов");
	ПараметрыВыбора.ЭлементыФормы.АналитикаРасходов.Добавить("ОтражениеАмортизационныхРасходовАналитикаРасходов");
	
	Возврат ПараметрыВыбора;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли
