#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает значения по умолчанию для ресурсов регистра.
// Имена ключей структуры должны строго соответствовать именам ресурсов регистра.
// 
// Параметры:
// Возвращаемое значение:
// 	Структура - структура значений ресурсов регистра.
Функция ЗначенияПоУмолчанию() Экспорт
	СтруктураЗначений = Новый Структура;
	
	СтруктураЗначений.Вставить("ИспользуетсяТрудНаемныхРаботников", Ложь);
	//++ НЕ УТ
	СтруктураЗначений.Вставить("БазаРаспределенияРасходовПоВидамДеятельности", Перечисления.БазыРаспределенияКосвенныхРасходовПоВидамДеятельности.ДоходыОтРеализации);
	СтруктураЗначений.Вставить("ИспользуетсяТрудНаемныхРаботников", Истина);
	//-- НЕ УТ

	СтруктураЗначений.Вставить("СтавкаНалогаУСН", 6);
	СтруктураЗначений.Вставить("ИспользуетсяТрудНаемныхРаботниковНеТребуетОбновления", Истина);
	СтруктураЗначений.Вставить("ПрименяетсяУСНДоходыМинусРасходы", Ложь);
	СтруктураЗначений.Вставить("ОбъектНалогообложенияУСН", Перечисления.ОбъектыНалогообложенияПоУСН.Доходы);
	СтруктураЗначений.Вставить("УчетнаяПолитикаСуществует", Ложь);
	СтруктураЗначений.Вставить("РаздельныйУчетТоваров", Ложь);
	
	Возврат СтруктураЗначений
КонецФункции

// Возращает текст запроса по данным регистра.
// 
// Возвращаемое значение:
// 	Строка - Текст запроса.
Функция ТекстЗапросаДействующиеПараметрыНалоговУчетныхПолитик() Экспорт
	ТекстЗапроса = "
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ВЫБОР КОГДА ТаблицаСрезПоследних.Период ЕСТЬ NULL Тогда
	|		ЛОЖЬ
	|	ИНАЧЕ
	|		ИСТИНА
	|	КОНЕЦ КАК УчетнаяПолитикаСуществует,
	|	ТаблицаСрезПоследних.Период КАК Период,
	|	ГоловныеОрганизации.ОбособленноеПодразделение КАК Организация,
	|	ТаблицаСрезПоследних.СтавкаНалогаУСН КАК СтавкаНалогаУСН,
	|	ТаблицаСрезПоследних.ОбъектНалогообложенияУСН КАК ОбъектНалогообложенияУСН,
	|	ТаблицаСрезПоследних.ПрименяетсяУСНДоходыМинусРасходы КАК ПрименяетсяУСНДоходыМинусРасходы,
	|	ТаблицаСрезПоследних.БазаРаспределенияРасходовПоВидамДеятельности КАК БазаРаспределенияРасходовПоВидамДеятельности,
	|	ТаблицаСрезПоследних.РаздельныйУчетТоваров КАК РаздельныйУчетТоваров,
	|	ТаблицаСрезПоследних.ИспользуетсяТрудНаемныхРаботников КАК ИспользуетсяТрудНаемныхРаботников
	|ИЗ
	|	ВтГоловныеОрганизации КАК ГоловныеОрганизации
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НастройкиУчетаУСН.СрезПоследних(&Период, Организация В
	|			(ВЫБРАТЬ
	|				ГоловныеОрганизации.Организация
	|			ИЗ
	|				ВтГоловныеОрганизации КАК ГоловныеОрганизации)) КАК ТаблицаСрезПоследних
	|		ПО ГоловныеОрганизации.Организация = ТаблицаСрезПоследних.Организация
	|";
	
	Возврат ТекстЗапроса
	
КонецФункции

// Формирует текстовое описание установленных параметров.
// 
// Параметры:
// 	Организация - СправочникСсылка.Организации - ссылка на организацию.
// 	ДатаДействия - Дата - период действия настроек.
// 	ДействующиеНастройки - Структура - действующие параметры учетной политики.
// Возвращаемое значение:
// 	Строка - Описание действующих параметров строкой.
Функция ОписаниеДействующихПараметров(Организация, ДатаДействия = Неопределено, ДействующиеНастройки = Неопределено) Экспорт
	
	Если ДействующиеНастройки = Неопределено Тогда
		ДействующиеНастройки = НастройкиНалоговУчетныхПолитик.ДействующиеПараметрыНалоговУчетныхПолитикНаДату(
			"НастройкиУчетаУСН",
			Организация,
			ДатаДействия,
			Ложь);
	КонецЕсли;
	
	ДействующиеПараметрыНалогобложения = НастройкиНалоговУчетныхПолитик.ДействующиеПараметрыНалоговУчетныхПолитикНаДату("НастройкиСистемыНалогообложения",
		Организация,
		КонецКвартала(ТекущаяДатаСеанса()),
		Истина);
	ПрименяетсяЕНВД = Ложь;
	Если ЗначениеЗаполнено(ДействующиеПараметрыНалогобложения) Тогда
		ПрименяетсяЕНВД = ДействующиеПараметрыНалогобложения.ПрименяетсяЕНВД;
	КонецЕсли;
	СтрокаШаблон = "%1: %2." + Символы.ПС;
	Если НЕ ЗначениеЗаполнено(ДействующиеНастройки) Тогда
		СтрокаОписанияНастроек = НСтр("ru = 'Не заданы параметры.';
										|en = 'Parameters are not specified.'");
		Возврат СтрокаОписанияНастроек;
	КонецЕсли;
	СтрокаОписанияНастроек = СтрШаблон(СтрокаШаблон,
			НСтр("ru = 'Объект налогообложения УСН';
				|en = 'STS taxation object'"),
			ДействующиеНастройки.ОбъектНалогообложенияУСН);
	
	СтрокаОписанияНастроек = СтрокаОписанияНастроек 
		+ СтрШаблон(СтрокаШаблон, 
			НСтр("ru = 'Налоговая ставка';
				|en = 'Tax rate'"),
			Строка(ДействующиеНастройки.СтавкаНалогаУСН)+"%");
			
	//++ НЕ УТ
	
	Если ПрименяетсяЕНВД Тогда
		СтрокаОписанияНастроек = СтрокаОписанияНастроек + СтрШаблон(СтрокаШаблон, 
			НСтр("ru = 'База распределения расходов по видам деятельности';
				|en = 'Expense allocation base according to activity categories'"),
			ДействующиеНастройки.БазаРаспределенияРасходовПоВидамДеятельности);
	КонецЕсли;
	
	СтрокаОписанияНастроек = СтрокаОписанияНастроек 
		+ СтрШаблон(СтрокаШаблон, 
			НСтр("ru = 'Раздельный учет товаров';
				|en = 'Separate accounting of goods'"),
			Строка(ДействующиеНастройки.РаздельныйУчетТоваров));
	
	СтрокаОписанияНастроек = СтрокаОписанияНастроек 
		+ СтрШаблон(СтрокаШаблон, 
			НСтр("ru = 'Используется труд наемных работников';
				|en = 'Hired workers are employed'"),
			Строка(ДействующиеНастройки.ИспользуетсяТрудНаемныхРаботников));
	
	//-- НЕ УТ
	
	Возврат СтрокаОписанияНастроек
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

#КонецЕсли
