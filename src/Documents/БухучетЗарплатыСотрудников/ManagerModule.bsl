#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов


#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ДляВсехСтрок( ЗначениеРазрешено(ФизическиеЛица.ФизическоеЛицо, NULL КАК ИСТИНА)
	|	) И ЗначениеРазрешено(Организация)";
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

// СтандартныеПодсистемы.Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "ПФ_MXL_СправкаОБухучетеЗарплатыСотрудников";
	КомандаПечати.Представление = НСтр("ru = 'Справка о регистрации бухучета заработка сотрудников';
										|en = 'Information sheet of registering employee earnings accounting'");
	КомандаПечати.МенеджерПечати = "Документ.БухучетЗарплатыСотрудников";
	КомандаПечати.Обработчик = "УправлениеПечатьюБЗККлиент.ВыполнитьКомандуПечати";
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.Печать


#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

#Область ОбработчикиПравилРегистрации

// См. ЗарплатаКадрыРасширенныйСинхронизацияДанных.ШаблонОбработчика
Процедура ПриЗаполненииНастроекОбработчиковПравилРегистрации(Настройки) Экспорт
	ЗарплатаКадрыРасширенныйСинхронизацияДанных.ДляОтбораПоОрганизации(Настройки);
	ЗарплатаКадрыРасширенныйСинхронизацияДанных.ДляОбъектаСПрисоединеннымиФайлами(Настройки);
КонецПроцедуры

#КонецОбласти

// Возвращает описание состава документа
//
// Возвращаемое значение:
//  Структура - см. ЗарплатаКадрыСоставДокументов.НовоеОписаниеСоставаОбъекта.
Функция ОписаниеСоставаОбъекта() Экспорт
	
	МетаданныеДокумента = Метаданные.Документы.БухучетЗарплатыСотрудников;
	Возврат ЗарплатаКадрыСоставДокументов.ОписаниеСоставаОбъектаПоМетаданнымФизическиеЛицаВТабличныхЧастях(МетаданныеДокумента);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции
	

#Область Печать

// Формирует печатные формы
//
// Параметры:
//  (входные)
//    МассивОбъектов  - Массив    - ссылки на объекты, которые нужно распечатать;
//    ПараметрыПечати - Структура - дополнительные настройки печати;
//  (выходные)
//   КоллекцияПечатныхФорм - ТаблицаЗначений - сформированные табличные документы.
//   ОбъектыПечати         - СписокЗначений  - значение - ссылка на объект;
//                                             представление - имя области в которой был выведен объект;
//   ПараметрыВывода       - Структура       - дополнительные параметры сформированных табличных документов.
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПФ_MXL_СправкаОБухучетеЗарплатыСотрудников") Тогда
		
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм,
			"ПФ_MXL_СправкаОБухучетеЗарплатыСотрудников",
			НСтр("ru = 'Справка о регистрации бухучета зарплаты сотрудников';
				|en = 'Information sheet of registering employee payroll accounting'"),
			ПечатьСправки(МассивОбъектов, ОбъектыПечати),
			,
			"Документ.БухучетЗарплатыСотрудников.ПФ_MXL_СправкаОБухучетеЗарплатыСотрудников");
			
	КонецЕсли;
						
КонецПроцедуры

Функция ПечатьСправки(МассивОбъектов, ОбъектыПечати)
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_БухучетЗарплатыСотрудников_СправкаОБухучетеЗарплатыСотрудников";
	ТабличныйДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Портрет;
	ТабличныйДокумент.АвтоМасштаб = Истина;
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.БухучетЗарплатыСотрудников.ПФ_MXL_СправкаОБухучетеЗарплатыСотрудников");
	
	ПодбираетсяАвтоматически = НСтр("ru = '<подбирается автоматически>';
									|en = '<picked automatically>'");
	ИспользоватьСтатьиФинансирования = ПолучитьФункциональнуюОпцию("ИспользоватьСтатьиФинансированияЗарплатаРасширенный");

	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	Запрос.УстановитьПараметр("ИспользоватьСтатьиФинансирования", ИспользоватьСтатьиФинансирования);
	Запрос.УстановитьПараметр("ПодбираетсяАвтоматически", ПодбираетсяАвтоматически);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Сотрудники.Ссылка КАК Ссылка,
	|	Сотрудники.Ссылка.Организация КАК Организация,
	|	Сотрудники.Ссылка.Подразделение КАК Подразделение,
	|	Сотрудники.Ссылка.Организация.НаименованиеПолное КАК НазваниеОрганизации,
	|	Сотрудники.Ссылка.Ответственный КАК Ответственный,
	|	Сотрудники.Сотрудник КАК Сотрудник,
	|	ВЫБОР
	|		КОГДА &ИспользоватьСтатьиФинансирования
	|			ТОГДА ВЫБОР
	|					КОГДА Сотрудники.СтатьяФинансирования = ЗНАЧЕНИЕ(Справочник.СтатьиФинансированияЗарплата.ПустаяСсылка)
	|						ТОГДА &ПодбираетсяАвтоматически
	|					ИНАЧЕ Сотрудники.СтатьяФинансирования
	|				КОНЕЦ
	|		ИНАЧЕ """"
	|	КОНЕЦ КАК СтатьяФинансирования,
	|	ВЫБОР
	|		КОГДА Сотрудники.СпособОтраженияЗарплатыВБухучете = ЗНАЧЕНИЕ(Справочник.СпособыОтраженияЗарплатыВБухучете.ПустаяСсылка)
	|			ТОГДА &ПодбираетсяАвтоматически
	|		ИНАЧЕ Сотрудники.СпособОтраженияЗарплатыВБухучете
	|	КОНЕЦ КАК СпособОтражения,
	|	Сотрудники.ОтношениеКЕНВД КАК ЕНВД,
	|	Сотрудники.Ссылка.Дата КАК Дата,
	|	Сотрудники.Ссылка.Номер КАК Номер,
	|	Сотрудники.Сотрудник.Наименование КАК СотрудникНаименование,
	|	Сотрудники.НомерСтроки КАК НомерСтроки,
	|	ВЫБОР
	|		КОГДА Сотрудники.Ссылка.РазныеДатыДляСотрудников
	|			ТОГДА Сотрудники.ДатаНачала
	|		ИНАЧЕ Сотрудники.Ссылка.ДатаНачала
	|	КОНЕЦ КАК ДатаНачала,
	|	ВЫБОР
	|		КОГДА Сотрудники.Ссылка.РазныеДатыДляСотрудников
	|			ТОГДА Сотрудники.ДатаОкончания
	|		ИНАЧЕ Сотрудники.Ссылка.ДатаОкончания
	|	КОНЕЦ КАК ДатаОкончания
	|ИЗ
	|	Документ.БухучетЗарплатыСотрудников.Сотрудники КАК Сотрудники
	|ГДЕ
	|	Сотрудники.Ссылка В(&МассивОбъектов)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Ссылка,
	|	Номер";

	Выборка = Запрос.Выполнить().Выбрать();
	
	ПервыйДокумент = Истина;
	
	ОбластьШапка = Макет.ПолучитьОбласть("Шапка");
	ОбластьПодвал = Макет.ПолучитьОбласть("Подвал");

	Пока Выборка.СледующийПоЗначениюПоля("Ссылка") Цикл
		
		ИспользуетсяЕНВД = ОтражениеЗарплатыВБухучете.ИспользуетсяЕНВД(Выборка.Дата);
		ИмяОбластиЗаголовок = "Заголовок";
		ИмяОбластиСтрока = "Строка";
		Если ИспользоватьСтатьиФинансирования Тогда
			ИмяОбластиЗаголовок = СтрШаблон("%1%2", ИмяОбластиЗаголовок, "СФ");
			ИмяОбластиСтрока 	= СтрШаблон("%1%2", ИмяОбластиСтрока, "СФ");
		КонецЕсли;
		
		ОбластьЗаголовокТаблицы = Макет.ПолучитьОбласть(ИмяОбластиЗаголовок);
		ОбластьСтрокаСотрудник 	= Макет.ПолучитьОбласть(ИмяОбластиСтрока);
		
		Если Не ПервыйДокумент Тогда
			// Все документы нужно выводить на разных страницах.
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		ПервыйДокумент = Ложь;
		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		ОбластьШапка.Параметры.НазваниеОрганизации 	= Выборка.НазваниеОрганизации;
		ОбластьШапка.Параметры.Подразделение 		= Выборка.Подразделение;
		ОбластьШапка.Параметры.ДатаДокумента 		= Формат(Выборка.Дата, "ДЛФ=D");
		ОбластьШапка.Параметры.НомерДокумента 		= ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(Выборка.Номер, Истина, Истина);

		ТабличныйДокумент.Вывести(ОбластьШапка);
		ТабличныйДокумент.Вывести(ОбластьЗаголовокТаблицы);
		
		Пока Выборка.СледующийПоЗначениюПоля("НомерСтроки") Цикл
			ЗаполнитьЗначенияСвойств(ОбластьСтрокаСотрудник.Параметры, Выборка);
			ТабличныйДокумент.Вывести(ОбластьСтрокаСотрудник);
		КонецЦикла;
		
		ТабличныйДокумент.Вывести(ОбластьПодвал);
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, Выборка.Ссылка);
		
	КонецЦикла;
	
	Возврат ТабличныйДокумент;
	
КонецФункции

#КонецОбласти

#КонецОбласти


#КонецЕсли