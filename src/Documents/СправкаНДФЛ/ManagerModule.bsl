#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс

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

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)
	|	И ЗначениеРазрешено(Сотрудник)";
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает описание состава документа
//
// Возвращаемое значение:
//  Структура - см. ЗарплатаКадрыСоставДокументов.НовоеОписаниеСоставаОбъекта.
Функция ОписаниеСоставаОбъекта() Экспорт
	Возврат ЗарплатаКадрыСоставДокументов.ОписаниеСоставаОбъектаФизическоеЛицоВШапке("Сотрудник", "");
КонецФункции

// Создает структуру для проверки данных физических лиц.
// 
// Возвращаемое значение:
//   Структура -параметры для проверки данных физических лиц:
//    * Ссылка 							- Неопределено - ссылка на документ, из которого происходит проверка.
//    * ПроверяемыеДанные 				- Неопределено - данные, требующие проверки.
//    * ДатаДокумента 					- Неопределено.
//    * ПутьКДаннымФизическогоЛица 		- Неопределено - строка с элементом хранения данных о физическом лице.
//    * НомерСтроки 					- Неопределено.
//    * ПроверятьАдрес 					- Булево - выполнять ли блок проверки адресов.
//    * ОшибкиДокумента 				- Неопределено - будет передаваться массив, содержащий накопленные ошибки.
Функция ПараметрыПроверкиДанныхФизическихЛиц() Экспорт
	
	ПараметрыПроверкиДанныхФизическихЛиц = Новый Структура;
	ПараметрыПроверкиДанныхФизическихЛиц.Вставить("Ссылка");
	ПараметрыПроверкиДанныхФизическихЛиц.Вставить("ПроверяемыеДанные");
	ПараметрыПроверкиДанныхФизическихЛиц.Вставить("ДатаДокумента");
	ПараметрыПроверкиДанныхФизическихЛиц.Вставить("ПутьКДаннымФизическогоЛица");
	ПараметрыПроверкиДанныхФизическихЛиц.Вставить("НомерСтроки", Неопределено);
	ПараметрыПроверкиДанныхФизическихЛиц.Вставить("ПроверятьАдрес", Истина);
	ПараметрыПроверкиДанныхФизическихЛиц.Вставить("ОшибкиДокумента", Неопределено);
	
	Возврат ПараметрыПроверкиДанныхФизическихЛиц;
	
КонецФункции

// Проверяет переданные данные по физическому лицу
//
// Параметры:
//  ПараметрыПроверкиДанныхФизическихЛиц - см. СправкаНДФЛ.ПараметрыПроверкиДанныхФизическихЛиц.
//  Отказ                                - Булево - флаг наличия ошибок.
Процедура ПроверитьДанныеФизическогоЛица(ПараметрыПроверкиДанныхФизическихЛиц, Отказ) Экспорт
	
	Если ПараметрыПроверкиДанныхФизическихЛиц.ОшибкиДокумента = Неопределено Тогда
		ПараметрыПроверкиДанныхФизическихЛиц.ОшибкиДокумента = Новый Массив;
	КонецЕсли;
	
	Ошибки = Новый Соответствие;
	
	ПравилаПроверки = ПравилаПроверкиДанныхФизическогоЛица(
	ПараметрыПроверкиДанныхФизическихЛиц.ПроверяемыеДанные.Гражданство, 
	ПараметрыПроверкиДанныхФизическихЛиц.ДатаДокумента);
	
	ДанныеФизическогоЛицаДляПроверки = ДанныеФизическогоЛицаДляПроверки(
	ПараметрыПроверкиДанныхФизическихЛиц.ПроверяемыеДанные);
	
	ФизическиеЛицаЗарплатаКадры.ПроверитьДанныеФизическогоЛица(
		ДанныеФизическогоЛицаДляПроверки,
		ПравилаПроверки,
		Ошибки);
	
	Если ПараметрыПроверкиДанныхФизическихЛиц.НомерСтроки <> Неопределено Тогда
		ПутьКДанным = ПараметрыПроверкиДанныхФизическихЛиц.ПутьКДаннымФизическогоЛица 
		+ "[" + Формат(ПараметрыПроверкиДанныхФизическихЛиц.НомерСтроки - 1, "ЧН=0; ЧГ=") + "].";
	ИначеЕсли Не ПустаяСтрока(ПараметрыПроверкиДанныхФизическихЛиц.ПутьКДаннымФизическогоЛица) Тогда
		ПутьКДанным = ПараметрыПроверкиДанныхФизическихЛиц.ПутьКДаннымФизическогоЛица + ".";
	Иначе
		ПутьКДанным = ПараметрыПроверкиДанныхФизическихЛиц.ПутьКДаннымФизическогоЛица;
	КонецЕсли;
	
	Для Каждого ОшибкиПоФизЛицу Из Ошибки Цикл
		Для Каждого ОшибкаДанныхФизическогоЛица Из ОшибкиПоФизЛицу.Значение Цикл
			
				ОбщегоНазначения.СообщитьПользователю(
					ОшибкаДанныхФизическогоЛица.ТекстОшибки,
					ПараметрыПроверкиДанныхФизическихЛиц.Ссылка,
					ПутьКДанным + ОшибкаДанныхФизическогоЛица.ПолеФормы,,
					Отказ);
					ПараметрыПроверкиДанныхФизическихЛиц.ОшибкиДокумента.Добавить(
					ОшибкаДанныхФизическогоЛица.ТекстОшибки);
					
		КонецЦикла;
	КонецЦикла;
	
	Если Не ЗначениеЗаполнено(ПараметрыПроверкиДанныхФизическихЛиц.ПроверяемыеДанные.СтатусНалогоплательщика) Тогда
		ТекстОшибки = СтрШаблон(
						НСтр("ru = 'Сотрудник %1: не заполнено поле ""Статус налогоплательщика""';
							|en = 'Employee %1: the ""Taxpayer status"" field is not filled in'"),
						ПараметрыПроверкиДанныхФизическихЛиц.ПроверяемыеДанные.СотрудникНаименование);
		
		ОбщегоНазначения.СообщитьПользователю(
			ТекстОшибки,
			ПараметрыПроверкиДанныхФизическихЛиц.Ссылка,
			ПутьКДанным + "СтатусНалогоплательщика",,
			Отказ);
			ПараметрыПроверкиДанныхФизическихЛиц.ОшибкиДокумента.Добавить(ТекстОшибки);
	КонецЕсли;
	
	// Адреса
	Если ПараметрыПроверкиДанныхФизическихЛиц.ПроверятьАдрес Тогда
		Если Не ЗначениеЗаполнено(ПараметрыПроверкиДанныхФизическихЛиц.ПроверяемыеДанные.Адрес) 
			И Не ЗначениеЗаполнено(ПараметрыПроверкиДанныхФизическихЛиц.ПроверяемыеДанные.АдресЗарубежом) Тогда
			Если ПараметрыПроверкиДанныхФизическихЛиц.ПроверяемыеДанные.Гражданство = Справочники.СтраныМира.Россия Тогда 
				ШаблонОшибки = НСтр("ru = 'Сотрудник %1: не указан адрес в РФ.';
									|en = 'Employee %1: address in the Russian Federation is not specified.'");
			Иначе
				ШаблонОшибки = НСтр("ru = 'Сотрудник %1: для физического лица нерезидента или иностранца должен быть заполнен ""Адрес зарубежом"".';
									|en = 'Employee %1: the ""Address abroad"" field must be filled in for a non-resident individual or foreigner.'");
			КонецЕсли;
			ТекстОшибки = СтрШаблон(ШаблонОшибки, ПараметрыПроверкиДанныхФизическихЛиц.ПроверяемыеДанные.СотрудникНаименование); 
			
			ОбщегоНазначения.СообщитьПользователю(
				ТекстОшибки,
				ПараметрыПроверкиДанныхФизическихЛиц.Ссылка,
				ПутьКДанным + "АдресЗаРубежом",,
				Отказ);
			ПараметрыПроверкиДанныхФизическихЛиц.ОшибкиДокумента.Добавить(ТекстОшибки);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Формирует печатную форму справки 2-НДФЛ.
//
// Параметры:
// 		МассивОбъектов - Массив - содержит ДокументСсылка.СправкаНДФЛ
// 		ОбъектыПечати - СписокЗначений - может быть пустой
//
// Возвращаемое значение:
// 		ТабличныйДокумент
//
Функция СформироватьПечатнуюФорму2НДФЛ(МассивОбъектов, ОбъектыПечати) Экспорт
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	ДанныеНА = УчетНДФЛ.СправкиНДФЛДанныеДляПечати(МассивОбъектов);
	ТаблицыДокумента = ТаблицыДанныхДокументаДляПечати(МассивОбъектов);
	
	Возврат УчетНДФЛ.СформироватьПечатнуюФорму2НДФЛ(ОбъектыПечати, МассивОбъектов, ДанныеНА, ТаблицыДокумента.Сотрудники, ТаблицыДокумента.СведенияОДоходах, ТаблицыДокумента.СведенияОВычетах, ТаблицыДокумента.СведенияОбУведомлениях);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПравилаПроверкиДанныхФизическогоЛица(Гражданство, ДатаДокумента)
	
	Правила = Новый Массив;
	
	ФизическиеЛицаЗарплатаКадры.ДобавитьПравилоПроверки(
		Правила,
		"ИНН",
		"ИНН",
		НСтр("ru = 'ИНН';
			|en = 'TIN'"),
		Ложь);
	
	ФизическиеЛицаЗарплатаКадры.ДобавитьПравилоПроверкиФИО(
		Правила,
		"Фамилия",
		"Имя",
		"Отчество",
		"Гражданство",
		НСтр("ru = 'ФИО';
			|en = 'Full name'"));
	
	ФизическиеЛицаЗарплатаКадры.ДобавитьПравилоПроверкиДатыРождения(
		Правила,
		"ДатаРождения",
		НСтр("ru = 'Дата рождения';
			|en = 'Date of birth'"),
		ДатаДокумента,
		Истина);
	
	ФизическиеЛицаЗарплатаКадры.ДобавитьПравилоПроверкиУдостоверенияЛичности(
		Правила,
		"ВидДокумента",
		"СерияДокумента",
		"НомерДокумента",
		"ДатаВыдачи",
		"КемВыдан",
		НСтр("ru = 'Документ удостоверяющий личность';
			|en = 'Identity document'"),
		Истина,
		Истина,
		Ложь);
	
	Возврат Правила;
	
КонецФункции

Функция ДанныеФизическогоЛицаДляПроверки(ПроверяемыеДанные)
	
	ДанныеФизическогоЛицаДляПроверки = Новый Структура;
	ДанныеФизическогоЛицаДляПроверки.Вставить("ФизическоеЛицо", ПроверяемыеДанные.Сотрудник);
	ДанныеФизическогоЛицаДляПроверки.Вставить("Наименование", ПроверяемыеДанные.СотрудникНаименование);
	ДанныеФизическогоЛицаДляПроверки.Вставить("Фамилия");
	ДанныеФизическогоЛицаДляПроверки.Вставить("Имя");
	ДанныеФизическогоЛицаДляПроверки.Вставить("Отчество");
	ДанныеФизическогоЛицаДляПроверки.Вставить("ИНН");
	ДанныеФизическогоЛицаДляПроверки.Вставить("Адрес");
	ДанныеФизическогоЛицаДляПроверки.Вставить("ВидДокумента");
	ДанныеФизическогоЛицаДляПроверки.Вставить("СерияДокумента");
	ДанныеФизическогоЛицаДляПроверки.Вставить("НомерДокумента");
	ДанныеФизическогоЛицаДляПроверки.Вставить("Гражданство");
	ДанныеФизическогоЛицаДляПроверки.Вставить("ДатаРождения");
	ДанныеФизическогоЛицаДляПроверки.Вставить("АдресЗарубежом");
	ДанныеФизическогоЛицаДляПроверки.Вставить("ДатаВыдачи");
	ДанныеФизическогоЛицаДляПроверки.Вставить("КемВыдан");
	
	ЗаполнитьЗначенияСвойств(ДанныеФизическогоЛицаДляПроверки, ПроверяемыеДанные);
	
	Возврат ДанныеФизическогоЛицаДляПроверки;
	
КонецФункции

Функция  ОписаниеПодписейДокумента() Экспорт 

	ОписаниеПодписей = ПодписиДокументов.ОписаниеТаблицыПодписей();

	ОписаниеПодписиРуководитель = ПодписиДокументов.ОписаниеРеквизитовПодписанта();
	ОписаниеПодписиРуководитель.ФизическоеЛицо = "СправкуПодписал";
	ОписаниеПодписиРуководитель.Должность = "ДолжностьПодписавшегоЛица";
	ОписаниеПодписиРуководитель.ОснованиеПодписи = "ОснованиеПодписи";

	ПереопределяемыеИмена = Новый Соответствие;
	ПереопределяемыеИмена.Вставить("Руководитель", ОписаниеПодписиРуководитель);

	ПодписиДокументов.ДобавитьОписаниеПодписейОрганизации(
		ОписаниеПодписей,
		"Руководитель",
		ПереопределяемыеИмена);

Возврат ОписаниеПодписей;

КонецФункции

#Область ПроцедурыИФункцииПечати

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	// Справка о доходах (2-НДФЛ)
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Обработчик = "УправлениеПечатьюБЗККлиент.ВыполнитьКомандуПечати";
	КомандаПечати.Идентификатор = "Форма2НДФЛ";
	КомандаПечати.Представление = НСтр("ru = 'Справка о доходах (2-НДФЛ)';
										|en = 'Income statement (2-NDFL)'");
	КомандаПечати.ПроверкаПроведенияПередПечатью = Ложь;
	
КонецПроцедуры

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Отказ = Ложь;
		
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "Форма2НДФЛ") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "Форма2НДФЛ", "Форма 2НДФЛ", СформироватьПечатнуюФорму2НДФЛ(МассивОбъектов, ОбъектыПечати));
	КонецЕсли;
	
КонецПроцедуры

Функция ТаблицыДанныхДокументаДляПечати(Ссылка)
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СправкаНДФЛ.Ссылка КАК Ссылка,
	|	СправкаНДФЛ.ВерсияДанных КАК ВерсияДанных,
	|	СправкаНДФЛ.ПометкаУдаления КАК ПометкаУдаления,
	|	СправкаНДФЛ.Номер КАК Номер,
	|	СправкаНДФЛ.Дата КАК Дата,
	|	СправкаНДФЛ.Проведен КАК Проведен,
	|	СправкаНДФЛ.НалоговыйПериод КАК НалоговыйПериод,
	|	СправкаНДФЛ.Организация КАК Организация,
	|	СправкаНДФЛ.СправкуПодписал КАК СправкуПодписал,
	|	СправкаНДФЛ.ДолжностьПодписавшегоЛица КАК ДолжностьПодписавшегоЛица,
	|	СправкаНДФЛ.СпособФормирования КАК СпособФормирования,
	|	СправкаНДФЛ.Сотрудник КАК Сотрудник,
	|	СправкаНДФЛ.Сотрудник.Наименование КАК СотрудникНаименование,
	|	СправкаНДФЛ.ИНН КАК ИНН,
	|	СправкаНДФЛ.Номер КАК НомерСправки,
	|	СправкаНДФЛ.РегистрацияВНалоговомОргане КАК РегистрацияВНалоговомОргане,
	|	СправкаНДФЛ.Фамилия КАК Фамилия,
	|	СправкаНДФЛ.Имя КАК Имя,
	|	СправкаНДФЛ.Отчество КАК Отчество,
	|	СправкаНДФЛ.Адрес КАК Адрес,
	|	СправкаНДФЛ.ВидДокумента КАК ВидДокумента,
	|	СправкаНДФЛ.СерияДокумента КАК СерияДокумента,
	|	СправкаНДФЛ.НомерДокумента КАК НомерДокумента,
	|	СправкаНДФЛ.СтранаВыдачиДокумента КАК СтранаВыдачиДокумента,
	|	СправкаНДФЛ.Гражданство КАК Гражданство,
	|	СправкаНДФЛ.ИННвСтранеГражданства КАК ИННвСтранеГражданства,
	|	СправкаНДФЛ.ДатаРождения КАК ДатаРождения,
	|	СправкаНДФЛ.СтатусНалогоплательщика КАК СтатусНалогоплательщика,
	|	СправкаНДФЛ.Ответственный КАК Ответственный,
	|	СправкаНДФЛ.Комментарий КАК Комментарий,
	|	СправкаНДФЛ.АдресЗаРубежом КАК АдресЗаРубежом,
	|	СправкаНДФЛ.ОбщаяСуммаДоходаПоСтавке13 КАК ОбщаяСуммаДоходаПоСтавке13,
	|	СправкаНДФЛ.ОблагаемаяСуммаДоходаПоСтавке13 КАК ОблагаемаяСуммаДоходаПоСтавке13,
	|	СправкаНДФЛ.ИсчисленоПоСтавке13 КАК ИсчисленоПоСтавке13,
	|	СправкаНДФЛ.УдержаноПоСтавке13 КАК УдержаноПоСтавке13,
	|	СправкаНДФЛ.ЗадолженностьПоСтавке13 КАК ЗадолженностьПоСтавке13,
	|	СправкаНДФЛ.ИзлишнеУдержаноПоСтавке13 КАК ИзлишнеУдержаноПоСтавке13,
	|	СправкаНДФЛ.ПеречисленоПоСтавке13 КАК ПеречисленоПоСтавке13,
	|	СправкаНДФЛ.ОбщаяСуммаДоходаПоСтавке30 КАК ОбщаяСуммаДоходаПоСтавке30,
	|	СправкаНДФЛ.ОблагаемаяСуммаДоходаПоСтавке30 КАК ОблагаемаяСуммаДоходаПоСтавке30,
	|	СправкаНДФЛ.ИсчисленоПоСтавке30 КАК ИсчисленоПоСтавке30,
	|	СправкаНДФЛ.УдержаноПоСтавке30 КАК УдержаноПоСтавке30,
	|	СправкаНДФЛ.ЗадолженностьПоСтавке30 КАК ЗадолженностьПоСтавке30,
	|	СправкаНДФЛ.ИзлишнеУдержаноПоСтавке30 КАК ИзлишнеУдержаноПоСтавке30,
	|	СправкаНДФЛ.ПеречисленоПоСтавке30 КАК ПеречисленоПоСтавке30,
	|	СправкаНДФЛ.ОбщаяСуммаДоходаПоСтавке9 КАК ОбщаяСуммаДоходаПоСтавке9,
	|	СправкаНДФЛ.ОблагаемаяСуммаДоходаПоСтавке9 КАК ОблагаемаяСуммаДоходаПоСтавке9,
	|	СправкаНДФЛ.ИсчисленоПоСтавке9 КАК ИсчисленоПоСтавке9,
	|	СправкаНДФЛ.УдержаноПоСтавке9 КАК УдержаноПоСтавке9,
	|	СправкаНДФЛ.ЗадолженностьПоСтавке9 КАК ЗадолженностьПоСтавке9,
	|	СправкаНДФЛ.ИзлишнеУдержаноПоСтавке9 КАК ИзлишнеУдержаноПоСтавке9,
	|	СправкаНДФЛ.ПеречисленоПоСтавке9 КАК ПеречисленоПоСтавке9,
	|	СправкаНДФЛ.ОбщаяСуммаДоходаПоСтавке15 КАК ОбщаяСуммаДоходаПоСтавке15,
	|	СправкаНДФЛ.ОблагаемаяСуммаДоходаПоСтавке15 КАК ОблагаемаяСуммаДоходаПоСтавке15,
	|	СправкаНДФЛ.ИсчисленоПоСтавке15 КАК ИсчисленоПоСтавке15,
	|	СправкаНДФЛ.УдержаноПоСтавке15 КАК УдержаноПоСтавке15,
	|	СправкаНДФЛ.ЗадолженностьПоСтавке15 КАК ЗадолженностьПоСтавке15,
	|	СправкаНДФЛ.ИзлишнеУдержаноПоСтавке15 КАК ИзлишнеУдержаноПоСтавке15,
	|	СправкаНДФЛ.ПеречисленоПоСтавке15 КАК ПеречисленоПоСтавке15,
	|	СправкаНДФЛ.ОбщаяСуммаДоходаПоСтавке18 КАК ОбщаяСуммаДоходаПоСтавке18,
	|	СправкаНДФЛ.ОблагаемаяСуммаДоходаПоСтавке18 КАК ОблагаемаяСуммаДоходаПоСтавке18,
	|	СправкаНДФЛ.ИсчисленоПоСтавке18 КАК ИсчисленоПоСтавке18,
	|	СправкаНДФЛ.УдержаноПоСтавке18 КАК УдержаноПоСтавке18,
	|	СправкаНДФЛ.ЗадолженностьПоСтавке18 КАК ЗадолженностьПоСтавке18,
	|	СправкаНДФЛ.ИзлишнеУдержаноПоСтавке18 КАК ИзлишнеУдержаноПоСтавке18,
	|	СправкаНДФЛ.ПеречисленоПоСтавке18 КАК ПеречисленоПоСтавке18,
	|	СправкаНДФЛ.ОбщаяСуммаДоходаПоСтавке20 КАК ОбщаяСуммаДоходаПоСтавке20,
	|	СправкаНДФЛ.ОблагаемаяСуммаДоходаПоСтавке20 КАК ОблагаемаяСуммаДоходаПоСтавке20,
	|	СправкаНДФЛ.ИсчисленоПоСтавке20 КАК ИсчисленоПоСтавке20,
	|	СправкаНДФЛ.УдержаноПоСтавке20 КАК УдержаноПоСтавке20,
	|	СправкаНДФЛ.ЗадолженностьПоСтавке20 КАК ЗадолженностьПоСтавке20,
	|	СправкаНДФЛ.ИзлишнеУдержаноПоСтавке20 КАК ИзлишнеУдержаноПоСтавке20,
	|	СправкаНДФЛ.ПеречисленоПоСтавке20 КАК ПеречисленоПоСтавке20,
	|	СправкаНДФЛ.ОбщаяСуммаДоходаПоСтавке22 КАК ОбщаяСуммаДоходаПоСтавке22,
	|	СправкаНДФЛ.ОблагаемаяСуммаДоходаПоСтавке22 КАК ОблагаемаяСуммаДоходаПоСтавке22,
	|	СправкаНДФЛ.ИсчисленоПоСтавке22 КАК ИсчисленоПоСтавке22,
	|	СправкаНДФЛ.УдержаноПоСтавке22 КАК УдержаноПоСтавке22,
	|	СправкаНДФЛ.ЗадолженностьПоСтавке22 КАК ЗадолженностьПоСтавке22,
	|	СправкаНДФЛ.ИзлишнеУдержаноПоСтавке22 КАК ИзлишнеУдержаноПоСтавке22,
	|	СправкаНДФЛ.ПеречисленоПоСтавке22 КАК ПеречисленоПоСтавке22,
	|	СправкаНДФЛ.ОбщаяСуммаДоходаПоСтавке35 КАК ОбщаяСуммаДоходаПоСтавке35,
	|	СправкаНДФЛ.ОблагаемаяСуммаДоходаПоСтавке35 КАК ОблагаемаяСуммаДоходаПоСтавке35,
	|	СправкаНДФЛ.ИсчисленоПоСтавке35 КАК ИсчисленоПоСтавке35,
	|	СправкаНДФЛ.УдержаноПоСтавке35 КАК УдержаноПоСтавке35,
	|	СправкаНДФЛ.ЗадолженностьПоСтавке35 КАК ЗадолженностьПоСтавке35,
	|	СправкаНДФЛ.ИзлишнеУдержаноПоСтавке35 КАК ИзлишнеУдержаноПоСтавке35,
	|	СправкаНДФЛ.ПеречисленоПоСтавке35 КАК ПеречисленоПоСтавке35,
	|	СправкаНДФЛ.ОбщаяСуммаДоходаПоСтавке5 КАК ОбщаяСуммаДоходаПоСтавке5,
	|	СправкаНДФЛ.ОблагаемаяСуммаДоходаПоСтавке5 КАК ОблагаемаяСуммаДоходаПоСтавке5,
	|	СправкаНДФЛ.ИсчисленоПоСтавке5 КАК ИсчисленоПоСтавке5,
	|	СправкаНДФЛ.УдержаноПоСтавке5 КАК УдержаноПоСтавке5,
	|	СправкаНДФЛ.ЗадолженностьПоСтавке5 КАК ЗадолженностьПоСтавке5,
	|	СправкаНДФЛ.ИзлишнеУдержаноПоСтавке5 КАК ИзлишнеУдержаноПоСтавке5,
	|	СправкаНДФЛ.ПеречисленоПоСтавке5 КАК ПеречисленоПоСтавке5,
	|	СправкаНДФЛ.ОбщаяСуммаДоходаПоСтавке10 КАК ОбщаяСуммаДоходаПоСтавке10,
	|	СправкаНДФЛ.ОблагаемаяСуммаДоходаПоСтавке10 КАК ОблагаемаяСуммаДоходаПоСтавке10,
	|	СправкаНДФЛ.ИсчисленоПоСтавке10 КАК ИсчисленоПоСтавке10,
	|	СправкаНДФЛ.УдержаноПоСтавке10 КАК УдержаноПоСтавке10,
	|	СправкаНДФЛ.ЗадолженностьПоСтавке10 КАК ЗадолженностьПоСтавке10,
	|	СправкаНДФЛ.ИзлишнеУдержаноПоСтавке10 КАК ИзлишнеУдержаноПоСтавке10,
	|	СправкаНДФЛ.ПеречисленоПоСтавке10 КАК ПеречисленоПоСтавке10,
	|	СправкаНДФЛ.ЗачтеноАвансовыхПлатежейПоСтавке5 КАК ЗачтеноАвансовыхПлатежейПоСтавке5,
	|	СправкаНДФЛ.ЗачтеноАвансовыхПлатежейПоСтавке9 КАК ЗачтеноАвансовыхПлатежейПоСтавке9,
	|	СправкаНДФЛ.ЗачтеноАвансовыхПлатежейПоСтавке10 КАК ЗачтеноАвансовыхПлатежейПоСтавке10,
	|	СправкаНДФЛ.ЗачтеноАвансовыхПлатежейПоСтавке13 КАК ЗачтеноАвансовыхПлатежейПоСтавке13,
	|	СправкаНДФЛ.ЗачтеноАвансовыхПлатежейПоСтавке35 КАК ЗачтеноАвансовыхПлатежейПоСтавке35,
	|	СправкаНДФЛ.ЗачтеноАвансовыхПлатежейПоСтавке30 КАК ЗачтеноАвансовыхПлатежейПоСтавке30,
	|	СправкаНДФЛ.ЗачтеноАвансовыхПлатежейПоСтавке15 КАК ЗачтеноАвансовыхПлатежейПоСтавке15,
	|	СправкаНДФЛ.ЗачтеноАвансовыхПлатежейПоСтавке18 КАК ЗачтеноАвансовыхПлатежейПоСтавке18,
	|	СправкаНДФЛ.ЗачтеноАвансовыхПлатежейПоСтавке20 КАК ЗачтеноАвансовыхПлатежейПоСтавке20,
	|	СправкаНДФЛ.ЗачтеноАвансовыхПлатежейПоСтавке22 КАК ЗачтеноАвансовыхПлатежейПоСтавке22,
	|	СправкаНДФЛ.НомерУведомленияАвансовыеПлатежи КАК НомерУведомленияАвансовыеПлатежи,
	|	СправкаНДФЛ.ДатаУведомленияАвансовыеПлатежи КАК ДатаУведомленияАвансовыеПлатежи,
	|	СправкаНДФЛ.КодНалоговогоОрганаУведомленияАвансовыеПлатежи КАК КодНалоговогоОрганаУведомленияАвансовыеПлатежи,
	|	СправкаНДФЛ.ЗачтеноАвансовыхПлатежейПоСтавке3 КАК ЗачтеноАвансовыхПлатежейПоСтавке3,
	|	СправкаНДФЛ.ОбщаяСуммаДоходаПоСтавке3 КАК ОбщаяСуммаДоходаПоСтавке3,
	|	СправкаНДФЛ.ОблагаемаяСуммаДоходаПоСтавке3 КАК ОблагаемаяСуммаДоходаПоСтавке3,
	|	СправкаНДФЛ.ИсчисленоПоСтавке3 КАК ИсчисленоПоСтавке3,
	|	СправкаНДФЛ.УдержаноПоСтавке3 КАК УдержаноПоСтавке3,
	|	СправкаНДФЛ.ЗадолженностьПоСтавке3 КАК ЗадолженностьПоСтавке3,
	|	СправкаНДФЛ.ИзлишнеУдержаноПоСтавке3 КАК ИзлишнеУдержаноПоСтавке3,
	|	СправкаНДФЛ.ПеречисленоПоСтавке3 КАК ПеречисленоПоСтавке3,
	|	СправкаНДФЛ.ЗачтеноАвансовыхПлатежейПоСтавке6 КАК ЗачтеноАвансовыхПлатежейПоСтавке6,
	|	СправкаНДФЛ.ОбщаяСуммаДоходаПоСтавке6 КАК ОбщаяСуммаДоходаПоСтавке6,
	|	СправкаНДФЛ.ОблагаемаяСуммаДоходаПоСтавке6 КАК ОблагаемаяСуммаДоходаПоСтавке6,
	|	СправкаНДФЛ.ИсчисленоПоСтавке6 КАК ИсчисленоПоСтавке6,
	|	СправкаНДФЛ.УдержаноПоСтавке6 КАК УдержаноПоСтавке6,
	|	СправкаНДФЛ.ЗадолженностьПоСтавке6 КАК ЗадолженностьПоСтавке6,
	|	СправкаНДФЛ.ИзлишнеУдержаноПоСтавке6 КАК ИзлишнеУдержаноПоСтавке6,
	|	СправкаНДФЛ.ПеречисленоПоСтавке6 КАК ПеречисленоПоСтавке6,
	|	СправкаНДФЛ.ЗачтеноАвансовыхПлатежейПоСтавке7 КАК ЗачтеноАвансовыхПлатежейПоСтавке7,
	|	СправкаНДФЛ.ОбщаяСуммаДоходаПоСтавке7 КАК ОбщаяСуммаДоходаПоСтавке7,
	|	СправкаНДФЛ.ОблагаемаяСуммаДоходаПоСтавке7 КАК ОблагаемаяСуммаДоходаПоСтавке7,
	|	СправкаНДФЛ.ИсчисленоПоСтавке7 КАК ИсчисленоПоСтавке7,
	|	СправкаНДФЛ.УдержаноПоСтавке7 КАК УдержаноПоСтавке7,
	|	СправкаНДФЛ.ЗадолженностьПоСтавке7 КАК ЗадолженностьПоСтавке7,
	|	СправкаНДФЛ.ИзлишнеУдержаноПоСтавке7 КАК ИзлишнеУдержаноПоСтавке7,
	|	СправкаНДФЛ.ПеречисленоПоСтавке7 КАК ПеречисленоПоСтавке7,
	|	СправкаНДФЛ.ЗачтеноАвансовыхПлатежейПоСтавке12 КАК ЗачтеноАвансовыхПлатежейПоСтавке12,
	|	СправкаНДФЛ.ОбщаяСуммаДоходаПоСтавке12 КАК ОбщаяСуммаДоходаПоСтавке12,
	|	СправкаНДФЛ.ОблагаемаяСуммаДоходаПоСтавке12 КАК ОблагаемаяСуммаДоходаПоСтавке12,
	|	СправкаНДФЛ.ИсчисленоПоСтавке12 КАК ИсчисленоПоСтавке12,
	|	СправкаНДФЛ.УдержаноПоСтавке12 КАК УдержаноПоСтавке12,
	|	СправкаНДФЛ.ЗадолженностьПоСтавке12 КАК ЗадолженностьПоСтавке12,
	|	СправкаНДФЛ.ИзлишнеУдержаноПоСтавке12 КАК ИзлишнеУдержаноПоСтавке12,
	|	СправкаНДФЛ.ПеречисленоПоСтавке12 КАК ПеречисленоПоСтавке12,
	|	СправкаНДФЛ.СуммаДоходаНеудержанногоПоСтавке13 КАК СуммаДоходаНеудержанногоПоСтавке13,
	|	СправкаНДФЛ.СуммаДоходаНеудержанногоПоСтавке30 КАК СуммаДоходаНеудержанногоПоСтавке30,
	|	СправкаНДФЛ.СуммаДоходаНеудержанногоПоСтавке9 КАК СуммаДоходаНеудержанногоПоСтавке9,
	|	СправкаНДФЛ.СуммаДоходаНеудержанногоПоСтавке15 КАК СуммаДоходаНеудержанногоПоСтавке15,
	|	СправкаНДФЛ.СуммаДоходаНеудержанногоПоСтавке18 КАК СуммаДоходаНеудержанногоПоСтавке18,
	|	СправкаНДФЛ.СуммаДоходаНеудержанногоПоСтавке20 КАК СуммаДоходаНеудержанногоПоСтавке20,
	|	СправкаНДФЛ.СуммаДоходаНеудержанногоПоСтавке22 КАК СуммаДоходаНеудержанногоПоСтавке22,
	|	СправкаНДФЛ.СуммаДоходаНеудержанногоПоСтавке35 КАК СуммаДоходаНеудержанногоПоСтавке35,
	|	СправкаНДФЛ.СуммаДоходаНеудержанногоПоСтавке5 КАК СуммаДоходаНеудержанногоПоСтавке5,
	|	СправкаНДФЛ.СуммаДоходаНеудержанногоПоСтавке10 КАК СуммаДоходаНеудержанногоПоСтавке10,
	|	СправкаНДФЛ.СуммаДоходаНеудержанногоПоСтавке3 КАК СуммаДоходаНеудержанногоПоСтавке3,
	|	СправкаНДФЛ.СуммаДоходаНеудержанногоПоСтавке6 КАК СуммаДоходаНеудержанногоПоСтавке6,
	|	СправкаНДФЛ.СуммаДоходаНеудержанногоПоСтавке7 КАК СуммаДоходаНеудержанногоПоСтавке7,
	|	СправкаНДФЛ.СуммаДоходаНеудержанногоПоСтавке12 КАК СуммаДоходаНеудержанногоПоСтавке12,
	|	СправкаНДФЛ.НалогНаПрибыльДляДивидендовПоСтавке13 КАК НалогНаПрибыльДляДивидендовПоСтавке13,
	|	СправкаНДФЛ.НалогНаПрибыльДляДивидендовПоСтавке30 КАК НалогНаПрибыльДляДивидендовПоСтавке30,
	|	СправкаНДФЛ.НалогНаПрибыльДляДивидендовПоСтавке9 КАК НалогНаПрибыльДляДивидендовПоСтавке9,
	|	СправкаНДФЛ.НалогНаПрибыльДляДивидендовПоСтавке15 КАК НалогНаПрибыльДляДивидендовПоСтавке15,
	|	СправкаНДФЛ.НалогНаПрибыльДляДивидендовПоСтавке18 КАК НалогНаПрибыльДляДивидендовПоСтавке18,
	|	СправкаНДФЛ.НалогНаПрибыльДляДивидендовПоСтавке20 КАК НалогНаПрибыльДляДивидендовПоСтавке20,
	|	СправкаНДФЛ.НалогНаПрибыльДляДивидендовПоСтавке22 КАК НалогНаПрибыльДляДивидендовПоСтавке22,
	|	СправкаНДФЛ.НалогНаПрибыльДляДивидендовПоСтавке35 КАК НалогНаПрибыльДляДивидендовПоСтавке35,
	|	СправкаНДФЛ.НалогНаПрибыльДляДивидендовПоСтавке5 КАК НалогНаПрибыльДляДивидендовПоСтавке5,
	|	СправкаНДФЛ.НалогНаПрибыльДляДивидендовПоСтавке10 КАК НалогНаПрибыльДляДивидендовПоСтавке10,
	|	СправкаНДФЛ.НалогНаПрибыльДляДивидендовПоСтавке3 КАК НалогНаПрибыльДляДивидендовПоСтавке3,
	|	СправкаНДФЛ.НалогНаПрибыльДляДивидендовПоСтавке6 КАК НалогНаПрибыльДляДивидендовПоСтавке6,
	|	СправкаНДФЛ.НалогНаПрибыльДляДивидендовПоСтавке7 КАК НалогНаПрибыльДляДивидендовПоСтавке7,
	|	СправкаНДФЛ.НалогНаПрибыльДляДивидендовПоСтавке12 КАК НалогНаПрибыльДляДивидендовПоСтавке12,
	|	СправкаНДФЛ.НалогСДивидендовУплаченныйЗаРубежомПоСтавке13 КАК НалогСДивидендовУплаченныйЗаРубежомПоСтавке13,
	|	СправкаНДФЛ.НалогСДивидендовУплаченныйЗаРубежомПоСтавке30 КАК НалогСДивидендовУплаченныйЗаРубежомПоСтавке30,
	|	СправкаНДФЛ.НалогСДивидендовУплаченныйЗаРубежомПоСтавке9 КАК НалогСДивидендовУплаченныйЗаРубежомПоСтавке9,
	|	СправкаНДФЛ.НалогСДивидендовУплаченныйЗаРубежомПоСтавке15 КАК НалогСДивидендовУплаченныйЗаРубежомПоСтавке15,
	|	СправкаНДФЛ.НалогСДивидендовУплаченныйЗаРубежомПоСтавке18 КАК НалогСДивидендовУплаченныйЗаРубежомПоСтавке18,
	|	СправкаНДФЛ.НалогСДивидендовУплаченныйЗаРубежомПоСтавке20 КАК НалогСДивидендовУплаченныйЗаРубежомПоСтавке20,
	|	СправкаНДФЛ.НалогСДивидендовУплаченныйЗаРубежомПоСтавке22 КАК НалогСДивидендовУплаченныйЗаРубежомПоСтавке22,
	|	СправкаНДФЛ.НалогСДивидендовУплаченныйЗаРубежомПоСтавке35 КАК НалогСДивидендовУплаченныйЗаРубежомПоСтавке35,
	|	СправкаНДФЛ.НалогСДивидендовУплаченныйЗаРубежомПоСтавке5 КАК НалогСДивидендовУплаченныйЗаРубежомПоСтавке5,
	|	СправкаНДФЛ.НалогСДивидендовУплаченныйЗаРубежомПоСтавке10 КАК НалогСДивидендовУплаченныйЗаРубежомПоСтавке10,
	|	СправкаНДФЛ.НалогСДивидендовУплаченныйЗаРубежомПоСтавке3 КАК НалогСДивидендовУплаченныйЗаРубежомПоСтавке3,
	|	СправкаНДФЛ.НалогСДивидендовУплаченныйЗаРубежомПоСтавке6 КАК НалогСДивидендовУплаченныйЗаРубежомПоСтавке6,
	|	СправкаНДФЛ.НалогСДивидендовУплаченныйЗаРубежомПоСтавке7 КАК НалогСДивидендовУплаченныйЗаРубежомПоСтавке7,
	|	СправкаНДФЛ.НалогСДивидендовУплаченныйЗаРубежомПоСтавке12 КАК НалогСДивидендовУплаченныйЗаРубежомПоСтавке12
	|ИЗ
	|	Документ.СправкаНДФЛ КАК СправкаНДФЛ
	|ГДЕ
	|	СправкаНДФЛ.Ссылка В(&Ссылка)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СправкаНДФЛСведенияОДоходах.Ссылка КАК Ссылка,
	|	СправкаНДФЛСведенияОДоходах.НомерСтроки КАК НомерСтроки,
	|	СправкаНДФЛСведенияОДоходах.МесяцНалоговогоПериода КАК МесяцНалоговогоПериода,
	|	СправкаНДФЛСведенияОДоходах.КодДохода КАК КодДохода,
	|	СправкаНДФЛСведенияОДоходах.СуммаДохода КАК СуммаДохода,
	|	СправкаНДФЛСведенияОДоходах.КодВычета КАК КодВычета,
	|	СправкаНДФЛСведенияОДоходах.СуммаВычета КАК СуммаВычета,
	|	СправкаНДФЛСведенияОДоходах.Ссылка.Номер КАК НомерСправки,
	|	СправкаНДФЛСведенияОДоходах.Ссылка.Сотрудник КАК Сотрудник,
	|	СправкаНДФЛСведенияОДоходах.Ставка КАК Ставка
	|ИЗ
	|	Документ.СправкаНДФЛ.СведенияОДоходах КАК СправкаНДФЛСведенияОДоходах
	|ГДЕ
	|	СправкаНДФЛСведенияОДоходах.Ссылка В(&Ссылка)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СправкаНДФЛСведенияОВычетах.Ссылка КАК Ссылка,
	|	СправкаНДФЛСведенияОВычетах.НомерСтроки КАК НомерСтроки,
	|	СправкаНДФЛСведенияОВычетах.КодВычета КАК КодВычета,
	|	СправкаНДФЛСведенияОВычетах.СуммаВычета КАК СуммаВычета,
	|	СправкаНДФЛСведенияОВычетах.Ссылка.Номер КАК НомерСправки,
	|	СправкаНДФЛСведенияОВычетах.Ссылка.Сотрудник КАК Сотрудник,
	|	СправкаНДФЛСведенияОВычетах.Ставка КАК Ставка
	|ИЗ
	|	Документ.СправкаНДФЛ.СведенияОВычетах КАК СправкаНДФЛСведенияОВычетах
	|ГДЕ
	|	СправкаНДФЛСведенияОВычетах.Ссылка В(&Ссылка)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СправкаНДФЛУведомленияНОоПравеНаВычеты.Ссылка КАК Ссылка,
	|	СправкаНДФЛУведомленияНОоПравеНаВычеты.НомерСтроки КАК НомерСтроки,
	|	СправкаНДФЛУведомленияНОоПравеНаВычеты.Ссылка.Номер КАК НомерСправки,
	|	СправкаНДФЛУведомленияНОоПравеНаВычеты.Ссылка.Сотрудник КАК Сотрудник,
	|	СправкаНДФЛУведомленияНОоПравеНаВычеты.ДатаУведомления КАК ДатаУведомления,
	|	СправкаНДФЛУведомленияНОоПравеНаВычеты.НомерУведомления КАК НомерУведомления,
	|	СправкаНДФЛУведомленияНОоПравеНаВычеты.КодНалоговогоОрганаУведомления КАК КодНалоговогоОрганаУведомления,
	|	СправкаНДФЛУведомленияНОоПравеНаВычеты.ГруппаВычета КАК ГруппаВычета
	|ИЗ
	|	Документ.СправкаНДФЛ.УведомленияНОоПравеНаВычеты КАК СправкаНДФЛУведомленияНОоПравеНаВычеты
	|ГДЕ
	|	СправкаНДФЛУведомленияНОоПравеНаВычеты.Ссылка В(&Ссылка)";
	
	Результаты = Запрос.ВыполнитьПакет();
	
	Сотрудники = Результаты[0].Выгрузить();
	
	Для Каждого СтрокаТаблицы Из Сотрудники Цикл
		СтрокаТаблицы.НомерСправки = НомерСправкиБезПрефиксов(СтрокаТаблицы.НомерСправки);
	КонецЦикла;
	
	СведенияОДоходах = Результаты[1].Выгрузить();
	
	Для Каждого СтрокаТаблицы Из СведенияОДоходах Цикл
		СтрокаТаблицы.НомерСправки =  НомерСправкиБезПрефиксов(СтрокаТаблицы.НомерСправки);
	КонецЦикла;
	
	СведенияОВычетах = Результаты[2].Выгрузить();
	
	Для Каждого СтрокаТаблицы Из СведенияОВычетах Цикл
		СтрокаТаблицы.НомерСправки =  НомерСправкиБезПрефиксов(СтрокаТаблицы.НомерСправки);
	КонецЦикла;
	
	СведенияОбУведомлениях = Результаты[3].Выгрузить();
	Для Каждого СтрокаТаблицы Из СведенияОбУведомлениях Цикл
		СтрокаТаблицы.НомерСправки =  НомерСправкиБезПрефиксов(СтрокаТаблицы.НомерСправки);
	КонецЦикла;
	
	Возврат Новый Структура("Сотрудники, СведенияОДоходах, СведенияОВычетах, СведенияОбУведомлениях", Сотрудники, СведенияОДоходах, СведенияОВычетах, СведенияОбУведомлениях);
	
КонецФункции

Функция НомерСправкиБезПрефиксов(НомерДокумента)
	Возврат ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(НомерДокумента, Истина, Истина);
КонецФункции


#КонецОбласти

#Область ПервоначальноеЗаполнениеИОбновлениеИнформационнойБазы

Процедура ПроставитьСтавкуВТаблицеВычетов(ПараметрыОбновления = Неопределено) Экспорт

	// АПК:1327-выкл используется при начальном заполнении ИБ.
	// АПК:1328-выкл используется при начальном заполнении ИБ.
	
	Запрос = Новый Запрос;
	
	ТекстЗапроса = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ ПЕРВЫЕ 1000
	|	СправкаНДФЛСведенияОВычетах.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.СправкаНДФЛ.СведенияОВычетах КАК СправкаНДФЛСведенияОВычетах
	|ГДЕ
	|	СправкаНДФЛСведенияОВычетах.СуммаВычета <> 0
	|	И СправкаНДФЛСведенияОВычетах.Ставка = ЗНАЧЕНИЕ(Перечисление.НДФЛСтавки.ПустаяСсылка)
	|
	|УПОРЯДОЧИТЬ ПО
	|	СправкаНДФЛСведенияОВычетах.Ссылка.Дата УБЫВ";
	Если ПараметрыОбновления = НеОпределено Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, " ПЕРВЫЕ 1000", "");
	КонецЕсли;
	Запрос.Текст = ТекстЗапроса; 
	РезультатЗапроса = Запрос.Выполнить();
	
	ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.УстановитьПараметрОбновления(ПараметрыОбновления, "ОбработкаЗавершена", Ложь);
	Если РезультатЗапроса.Пустой() Тогда
		ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.УстановитьПараметрОбновления(ПараметрыОбновления, "ОбработкаЗавершена", Истина);
		Возврат;
	КонецЕсли;
	
	ВыборкаДокументов = РезультатЗапроса.Выбрать();
	Пока ВыборкаДокументов.Следующий() Цикл
		
		Если Не ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.ПодготовитьОбновлениеДанных(ПараметрыОбновления, "Документ.СправкаНДФЛ", "Ссылка", ВыборкаДокументов.Ссылка) Тогда
			Продолжить;
		КонецЕсли;
		
		// Обновление документа.
		ДокументОбъект = ВыборкаДокументов.Ссылка.ПолучитьОбъект();
		Для каждого СтрокаДокумента Из ДокументОбъект.СведенияОВычетах Цикл
			Если СтрокаДокумента.СуммаВычета = 0 Или ЗначениеЗаполнено(СтрокаДокумента.Ставка) Тогда
				Продолжить;
			КонецЕсли;
			СтрокаДокумента.Ставка = Перечисления.НДФЛСтавки.Ставка13;
		КонецЦикла;
		ОбновлениеИнформационнойБазы.ЗаписатьОбъект(ДокументОбъект);
		ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.ЗавершитьОбновлениеДанных(ПараметрыОбновления);
		
	КонецЦикла;
	
	// АПК:1327-вкл
	// АПК:1328-вкл
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли