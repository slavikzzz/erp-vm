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
	
	МеханизмыДокумента.Добавить("Взаиморасчеты");
	
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
//
Функция ДанныеДокументаДляПроведения(Документ, Регистры, ДопПараметры = Неопределено) Экспорт
	
	Если ДопПараметры = Неопределено Тогда
		ДопПараметры = ПроведениеДокументов.ДопПараметрыИнициализироватьДанныеДокументаДляПроведения();
	КонецЕсли;
	
	Если ТипЗнч(Документ) = Тип("ДокументОбъект.ГрафикИсполненияДоговора") Тогда
		ДокументСсылка = Документ.Ссылка;
	Иначе
		ДокументСсылка = Документ;
	КонецЕсли;
	
	Запрос			= Новый Запрос;
	ТекстыЗапроса	= Новый СписокЗначений;
	
	ПолучитьДанныеДокумента(Запрос, ДокументСсылка);
	
	Если Не ДопПараметры.ПолучитьТекстыЗапроса Тогда
		////////////////////////////////////////////////////////////////////////////
		// Создадим запрос инициализации движений
		
		ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка);
		
		////////////////////////////////////////////////////////////////////////////
		// Сформируем текст запроса
	КонецЕсли;
	
	ДобавитьТекстыОтраженияВзаиморасчетов(Запрос, ТекстыЗапроса, Регистры);
	
	////////////////////////////////////////////////////////////////////////////
	// Получим таблицы для движений
	
	Возврат ПроведениеДокументов.ИнициализироватьДанныеДокументаДляПроведения(Запрос, ТекстыЗапроса, ДопПараметры);
	
КонецФункции

#КонецОбласти

// Формирует представление документа
//
// Параметры:
// 		Ссылка - ДокументСсылка.ГрафикИсполненияДоговора - документ, для которого формируется представление.
//
// Возвращаемое значение:
// 		ФорматированнаяСтрока - Представление графика.
//
Функция ПредставлениеГрафика(Ссылка) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	МассивСтрок = Новый Массив;
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	График.ДатаПлатежа КАК Дата
	|ИЗ
	|	Документ.ГрафикИсполненияДоговора.ЭтапыГрафикаОплаты КАК График
	|
	|ГДЕ
	|	График.Ссылка.Проведен
	|	И График.Ссылка = &Ссылка
	|	И График.СуммаПлатежа <> 0
	|;
	|///////////////////////////////////////////////////
	|
	|ВЫБРАТЬ
	|	График.ДатаПоГрафику КАК Дата
	|ИЗ
	|	Документ.ГрафикИсполненияДоговора.ЭтапыГрафикаИсполненияДоговора КАК График
	|
	|ГДЕ
	|	График.Ссылка.Проведен
	|	И График.Ссылка = &Ссылка
	|	И График.СуммаИсполнения <> 0
	|;
	|///////////////////////////////////////////////////
	|");
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Результат = Запрос.ВыполнитьПакет();
	
	Если Результат[0].Пустой() И Результат[1].Пустой() Тогда
		
		МассивСтрок.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'Не задан';
																|en = 'Not specified'"),, WebЦвета.Кирпичный));
		
	Иначе
		
		СтрокаИсполнение = ""; СтрокаИсполнениеНеЗадано = "";
		ТипДоговора = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "Договор.ТипДоговора");
		Если ТипДоговора = Перечисления.ТипыДоговоров.СПокупателем
			//++ Устарело_Переработка24
			Или ТипДоговора = Перечисления.ТипыДоговоров.СДавальцем
			//-- Устарело_Переработка24
			Или ТипДоговора = Перечисления.ТипыДоговоров.СДавальцем2_5 Тогда
			
			СтрокаИсполнение = НСтр("ru = 'Отгрузка';
									|en = 'Shipment'");
			СтрокаИсполнениеНеЗадано = НСтр("ru = 'Отгрузка не задана';
											|en = 'Shipment is not specified'");
			
		ИначеЕсли ТипДоговора = Перечисления.ТипыДоговоров.СПоставщиком
			Или ТипДоговора = Перечисления.ТипыДоговоров.Импорт
			//++ Устарело_Переработка24
			Или ТипДоговора = Перечисления.ТипыДоговоров.СПереработчиком
			//-- Устарело_Переработка24
			Или ТипДоговора = Перечисления.ТипыДоговоров.СПереработчиком2_5 
			Или ТипДоговора = Перечисления.ТипыДоговоров.СПереработчиком2_5_ЕАЭС Тогда
			
			СтрокаИсполнение = НСтр("ru = 'Поступление';
									|en = 'Receipt'");
			СтрокаИсполнениеНеЗадано = НСтр("ru = 'Поступление не задано';
											|en = 'Receipt is not set'");
		КонецЕсли;
		
		Выборка = Результат[0].Выбрать();
		КоличествоОплат = Выборка.Количество();
		Если КоличествоОплат = 0 Тогда
			МассивСтрок.Добавить(НСтр("ru = 'Оплата не задана';
										|en = 'Payment is not specified'"));
		ИначеЕсли КоличествоОплат = 1 Тогда
			Выборка.Следующий();
			МассивСтрок.Добавить(СтрШаблон(НСтр("ru = 'Оплата %1';
												|en = 'Payment %1'"), Формат(Выборка.Дата, "ДЛФ=Д") ));
		Иначе
			ТекстЭтапа = ОбщегоНазначенияУТКлиентСервер.СклонениеСлова(
				КоличествоОплат,
				НСтр("ru = 'этапы';
					|en = 'stages'"), НСтр("ru = 'этапа';
										|en = 'stage'"), НСтр("ru = 'этапов';
															|en = 'steps'"), НСтр("ru = 'м';
																					|en = 'm'"));
			МассивСтрок.Добавить(СтрШаблон(НСтр("ru = 'Оплата в %1';
												|en = 'Payment to %1'"), Формат(КоличествоОплат, "ЧН=0")) + " " + ТекстЭтапа);
		КонецЕсли;
		
		МассивСтрок.Добавить("; ");
		
		Выборка = Результат[1].Выбрать();
		КоличествоИсполнений = Выборка.Количество();
		Если КоличествоИсполнений = 0 Тогда
			МассивСтрок.Добавить(СтрокаИсполнениеНеЗадано);
		ИначеЕсли КоличествоИсполнений = 1 Тогда
			Выборка.Следующий();
			МассивСтрок.Добавить(СтрШаблон(НСтр("ru = '%1 %2';
												|en = '%1 %2'"), СтрокаИсполнение, Формат(Выборка.Дата, "ДЛФ=Д")));
		Иначе
			ТекстЭтапа = ОбщегоНазначенияУТКлиентСервер.СклонениеСлова(
				КоличествоИсполнений,
				НСтр("ru = 'этапы';
					|en = 'stages'"), НСтр("ru = 'этапа';
										|en = 'stage'"), НСтр("ru = 'этапов';
															|en = 'steps'"), НСтр("ru = 'м';
																					|en = 'm'"));
			МассивСтрок.Добавить(СтрШаблон(НСтр("ru = '%1 в %2';
												|en = '%1 in %2'"), СтрокаИсполнение, Формат(КоличествоИсполнений, "ЧН=0")) + " " + ТекстЭтапа);
		КонецЕсли;
	КонецЕсли;
	
	Возврат Новый ФорматированнаяСтрока(МассивСтрок);
	
КонецФункции

// Процедура устанавливает пометку на удаление для найденного документа
//
// Параметры:
//    Договор - СправочникСсылка.ДоговорыКонтрагентов - Договор, график которого должен быть помечен на удаление.
//    ПометкаУдаления - Булево - Признак установки пометки на удаление.
//
Процедура УстановитьПометкуУдаления(Договор, ПометкаУдаления) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Ссылка = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Договор, "ГрафикИсполненияДоговора");
	
	Если ЗначениеЗаполнено(Ссылка) Тогда
		Ссылка.ПолучитьОбъект().УстановитьПометкуУдаления(ПометкаУдаления);
	КонецЕсли;
	
КонецПроцедуры

// Осуществляет инициализацию структуры состояния выполнения договора
//
// Возвращаемое значение:
// 		Структура - Структура состояния.
//
Функция СтруктураСостояниеВыполненияДокумента() Экспорт
	
	СтруктураСостояние = Отчеты.СостояниеВыполненияДокументов.ИнициализироватьСтруктуруСостояниеВыполненияДокумента();
	
	СтруктураСостояние.Вставить("ВыводитьТаблицуРасчетыСКлиентами", 1);
	СтруктураСостояние.Вставить("ВыводитьТаблицуРасчетыСПоставщиками", 2);
	СтруктураСостояние.Вставить("ЭтоДоговор", Истина);
	
	Возврат СтруктураСостояние;
	
КонецФункции

#Область Отчеты

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

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияПолейПредставления(Поля, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Поля.Добавить("Договор");
	
КонецПроцедуры

Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Представление = НСтр("ru = 'График исполнения договора';
						|en = 'Contract schedule'") + " " + Данные.Договор;
	
КонецПроцедуры

#КонецОбласти

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

#Область Проведение

Процедура ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка)
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ДанныеДокумента.Дата                                     КАК Период,
	|	ДанныеДокумента.Номер                                    КАК Номер,
	|	ДанныеДокумента.Договор                                  КАК Договор,
	|	ДанныеДокумента.Договор.Организация                      КАК Организация,
	|	ДанныеДокумента.Договор.Контрагент                       КАК Контрагент,
	|	ДанныеДокумента.Договор.Партнер                          КАК Партнер,
	|	ДанныеДокумента.Договор.НаправлениеДеятельности          КАК НаправлениеДеятельности,
	|	ДанныеДокумента.Договор.ВалютаВзаиморасчетов             КАК Валюта,
	|	ДанныеДокумента.Договор.ТипДоговора                      КАК ТипДоговора
	|ИЗ
	|	Документ.ГрафикИсполненияДоговора КАК ДанныеДокумента
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка";
	
	Результат = Запрос.Выполнить();
	Реквизиты = Результат.Выбрать();
	Реквизиты.Следующий();
	
	Для Каждого Колонка Из Результат.Колонки Цикл
		Запрос.УстановитьПараметр(Колонка.Имя, Реквизиты[Колонка.Имя]);
	КонецЦикла;
	
КонецПроцедуры

Процедура ПолучитьДанныеДокумента(Запрос, ДокументСсылка)
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	ГрафикИсполненияДоговораЭтапыГрафикаОплаты.Ссылка                        КАК Ссылка,
	|	ГрафикИсполненияДоговораЭтапыГрафикаОплаты.Ссылка.ГрафикЧастичноИсполнен КАК ГрафикЧастичноИсполнен,
	|	ГрафикИсполненияДоговораЭтапыГрафикаОплаты.НомерСтроки                   КАК НомерСтроки,
	|	ГрафикИсполненияДоговораЭтапыГрафикаОплаты.ВариантОплаты                 КАК ВариантОплаты,
	|	ГрафикИсполненияДоговораЭтапыГрафикаОплаты.ДатаПлатежа                   КАК ДатаПлатежа,
	|	ГрафикИсполненияДоговораЭтапыГрафикаОплаты.ПроцентПлатежа                КАК ПроцентПлатежа,
	|	ГрафикИсполненияДоговораЭтапыГрафикаОплаты.СуммаПлатежа                  КАК СуммаПлатежа,
	|	ГрафикИсполненияДоговораЭтапыГрафикаОплаты.ВариантОтсчета                КАК ВариантОтсчета,
	|	ГрафикИсполненияДоговораЭтапыГрафикаОплаты.Сдвиг                         КАК Сдвиг,
	|	ГрафикИсполненияДоговораЭтапыГрафикаОплаты.УжеОплачено                   КАК УжеОплачено
	|ИЗ
	|	Документ.ГрафикИсполненияДоговора.ЭтапыГрафикаОплаты КАК ГрафикИсполненияДоговораЭтапыГрафикаОплаты
	|ГДЕ
	|	ГрафикИсполненияДоговораЭтапыГрафикаОплаты.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЕСТЬNULL(СУММА(ГрафикИсполненияДоговораЭтапыГрафикаИсполненияДоговора.СуммаИсполнения), 0) КАК Сумма
	|ИЗ
	|	Документ.ГрафикИсполненияДоговора.ЭтапыГрафикаИсполненияДоговора КАК
	|		ГрафикИсполненияДоговораЭтапыГрафикаИсполненияДоговора
	|ГДЕ
	|	ГрафикИсполненияДоговораЭтапыГрафикаИсполненияДоговора.Ссылка = &Ссылка
	|	И НЕ ГрафикИсполненияДоговораЭтапыГрафикаИсполненияДоговора.УжеОтгружено";
	
	Результат = Запрос.ВыполнитьПакет();
	ГрафикОплаты = Результат[0].Выгрузить();
	ВыборкаСуммаОтгрузки = Результат[1].Выбрать();
	СуммаКОплате = 0;
	Если ВыборкаСуммаОтгрузки.Следующий() Тогда
		СуммаКОплате = ВыборкаСуммаОтгрузки.Сумма;
	КонецЕсли;
	
	Если СуммаКОплате < ГрафикОплаты.Итог("СуммаПлатежа") Тогда
		Индекс = ГрафикОплаты.Количество();
		Пока Индекс > 0 Цикл
			Индекс = Индекс - 1;
			Если Не ГрафикОплаты[Индекс].ГрафикЧастичноИсполнен Тогда
				Прервать;
			КонецЕсли;
			ГрафикОплаты[Индекс].СуммаПлатежа = Мин(ГрафикОплаты[Индекс].СуммаПлатежа, СуммаКОплате);
			СуммаКОплате = СуммаКОплате - ГрафикОплаты[Индекс].СуммаПлатежа;
		КонецЦикла;
	КонецЕсли;
	
	Запрос.УстановитьПараметр("ТаблицаГрафикОплаты", ГрафикОплаты);
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.Текст = "
		|ВЫБРАТЬ
		|	ГрафикОплаты.Ссылка,
		|	ГрафикОплаты.НомерСтроки,
		|	ГрафикОплаты.ВариантОплаты,
		|	ГрафикОплаты.ДатаПлатежа,
		|	ГрафикОплаты.ПроцентПлатежа,
		|	ГрафикОплаты.СуммаПлатежа,
		|	ГрафикОплаты.ВариантОтсчета,
		|	ГрафикОплаты.Сдвиг,
		|	ГрафикОплаты.УжеОплачено
		|ПОМЕСТИТЬ ДанныеДокументаТаблицаЭтапыГрафикаОплаты
		|ИЗ
		|	&ТаблицаГрафикОплаты КАК ГрафикОплаты
		|ГДЕ
		|	ГрафикОплаты.СуммаПлатежа > 0";
		
	Запрос.Выполнить();
	
КонецПроцедуры

Функция ДополнительныеИсточникиДанныхДляДвижений(ИмяРегистра) Экспорт

	ИсточникиДанных = Новый Соответствие;

	Возврат ИсточникиДанных; 

КонецФункции

Процедура ДобавитьТекстыОтраженияВзаиморасчетов(Запрос, ТекстыЗапроса, Регистры)
	
	#Область НаправленияДеятельности
	
	ИмяРегистра = "ВременнаяТаблицаНаправленияДеятельности";
	
	ТекстЗапросаНаправленияДеятельности = 
		"ВЫБРАТЬ
		|	ДанныеДокументаШапка.ОбъектРасчетов КАК ОбъектРасчетов
		|ИЗ
		|	Документ.ГрафикИсполненияДоговора КАК ДанныеДокументаШапка
		|ГДЕ
		|	ДанныеДокументаШапка.Ссылка В (&Ссылка)";
		
	ТекстЗапросаНаправленияДеятельности = ВзаиморасчетыСервер.ПолучитьТаблицуНаправленийДеятельности(ТекстЗапросаНаправленияДеятельности);

	ТекстыЗапроса.Добавить(ТекстЗапросаНаправленияДеятельности, ИмяРегистра);
	
	#КонецОбласти
	
	#Область РасчетыСКлиентами
	
	ТекстПланыОплат =
		"ВЫБРАТЬ
		|	Таблица.Ссылка                                                           КАК Ссылка,
		|	Договоры.Организация                                                     КАК Организация,
		|	Договоры.Партнер                                                         КАК Партнер,
		|	
		|	Таблица.Ссылка.ОбъектРасчетов                                            КАК ОбъектРасчетов,
		|	Таблица.Ссылка.Дата                                                      КАК ДатаРегистратора,
		|	Таблица.Ссылка.Номер                                                     КАК НомерРегистратора,
		|	Договоры.ВалютаВзаиморасчетов                                            КАК ВалютаВзаиморасчетов,
		|	Договоры.ВалютаВзаиморасчетов                                            КАК ВалютаДокумента,
		|	ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПланированиеПоЗаказуКлиента) КАК ХозяйственнаяОперация,
		|	
		|	Таблица.ДатаПлатежа                                                      КАК ДатаПлатежа,
		|	Таблица.ВариантОплаты                                                    КАК ВариантОплаты,
		|	Таблица.СуммаПлатежа                                                     КАК КОплате,
		|		
		|	ВЫБОР
		|		КОГДА Таблица.ВариантОплаты = ЗНАЧЕНИЕ(Перечисление.ВариантыКонтроляОплатыКлиентом.ПредоплатаДоОтгрузки)
		|			ТОГДА ЛОЖЬ
		|		ИНАЧЕ ИСТИНА
		|	КОНЕЦ                                                                    КАК ИсключатьПриКонтроле
		|	
		|ИЗ
		|	ДанныеДокументаТаблицаЭтапыГрафикаОплаты КАК Таблица
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ДоговорыКонтрагентов КАК Договоры
		|		ПО Договоры.Ссылка = Таблица.Ссылка.Договор
		|			И Договоры.ТипДоговора В (ЗНАЧЕНИЕ(Перечисление.ТипыДоговоров.СПокупателем),
		//++ Устарело_Переработка24
		|									ЗНАЧЕНИЕ(Перечисление.ТипыДоговоров.СДавальцем),
		//-- Устарело_Переработка24
		|									ЗНАЧЕНИЕ(Перечисление.ТипыДоговоров.СДавальцем2_5))
		|ГДЕ
		|	Таблица.Ссылка В (&Ссылка)";
	
	ТекстПланыОтгрузок =
		"ВЫБРАТЬ
		|	Таблица.Ссылка                                                           КАК Ссылка,
		|	Договоры.Организация                                                     КАК Организация,
		|	Договоры.Партнер                                                         КАК Партнер,
		|	
		|	Таблица.Ссылка.ОбъектРасчетов                                            КАК ОбъектРасчетов,
		|	Таблица.Ссылка.Дата                                                      КАК ДатаРегистратора,
		|	Таблица.Ссылка.Номер                                                     КАК НомерРегистратора,
		|	Договоры.ПорядокРасчетов                                                 КАК ПорядокРасчетов,
		|	Договоры.ВалютаВзаиморасчетов                                            КАК ВалютаВзаиморасчетов,
		|	Договоры.ВалютаВзаиморасчетов                                            КАК ВалютаДокумента,
		|	ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПланированиеПоЗаказуКлиента) КАК ХозяйственнаяОперация,
		|	
		|	КОНЕЦПЕРИОДА(Таблица.ДатаПоГрафику, ДЕНЬ)                                КАК ДатаОтгрузки,
		|	Таблица.СуммаИсполнения                                                  КАК УвеличитьКОтгрузке
		|	
		|ИЗ
		|	Документ.ГрафикИсполненияДоговора.ЭтапыГрафикаИсполненияДоговора КАК Таблица
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ДоговорыКонтрагентов КАК Договоры
		|			ПО Договоры.Ссылка = Таблица.Ссылка.Договор
		|				И Договоры.ТипДоговора В (ЗНАЧЕНИЕ(Перечисление.ТипыДоговоров.СПокупателем),
		//++ Устарело_Переработка24
		|											ЗНАЧЕНИЕ(Перечисление.ТипыДоговоров.СДавальцем),
		//-- Устарело_Переработка24
		|											ЗНАЧЕНИЕ(Перечисление.ТипыДоговоров.СДавальцем2_5))
		|ГДЕ
		|	Таблица.Ссылка В (&Ссылка)
		|	И НЕ Таблица.УжеОтгружено";
	
	ВзаиморасчетыСервер.ПроведениеГрафикаИсполненияДоговораСКлиентом(Запрос, ТекстыЗапроса, Регистры, ТекстПланыОплат, ТекстПланыОтгрузок);
	ВзаиморасчетыСервер.ПроведениеРасчетыСКлиентамиПланОплат(Запрос, ТекстыЗапроса, Регистры, ТекстПланыОплат);
	ВзаиморасчетыСервер.ПроведениеРасчетыСКлиентамиПланОтгрузок(Запрос, ТекстыЗапроса, Регистры, ТекстПланыОтгрузок, Истина);
	
	#КонецОбласти
	
	#Область РасчетыСПоставщиками
	
	ТекстПланыОплат =
		"ВЫБРАТЬ
		|	Таблица.Ссылка                                                              КАК Ссылка,
		|	
		|	Договоры.Организация                                                        КАК Организация,
		|	Договоры.Партнер                                                            КАК Партнер,
		|	Договоры.Контрагент                                                         КАК Контрагент,
		|	Договоры.Ссылка                                                             КАК Договор,
		|	Договоры.НаправлениеДеятельности                                            КАК НаправлениеДеятельности,
		|	
		|	Таблица.Ссылка.ОбъектРасчетов                                               КАК ОбъектРасчетов,
		|	Таблица.Ссылка.Дата                                                         КАК ДатаРегистратора,
		|	Таблица.Ссылка.Номер                                                        КАК НомерРегистратора,
		|	Договоры.ВалютаВзаиморасчетов                                               КАК ВалютаВзаиморасчетов,
		|	Договоры.ВалютаВзаиморасчетов                                               КАК ВалютаДокумента,
		|	ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПланированиеПоЗаказуПоставщику) КАК ХозяйственнаяОперация,
		|	
		|	Таблица.ДатаПлатежа                                                         КАК ДатаПлатежа,
		|	Таблица.ВариантОплаты                                                       КАК ВариантОплаты,
		|	Таблица.СуммаПлатежа                                                        КАК КОплате
		|	
		|ИЗ
		|	ДанныеДокументаТаблицаЭтапыГрафикаОплаты КАК Таблица
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ДоговорыКонтрагентов КАК Договоры
		|		ПО Договоры.Ссылка = Таблица.Ссылка.Договор
		|			И Договоры.ТипДоговора В (ЗНАЧЕНИЕ(Перечисление.ТипыДоговоров.СПоставщиком),
		|										ЗНАЧЕНИЕ(Перечисление.ТипыДоговоров.Импорт),
		//++ Устарело_Переработка24
		|										ЗНАЧЕНИЕ(Перечисление.ТипыДоговоров.СПереработчиком),
		//-- Устарело_Переработка24
		|										ЗНАЧЕНИЕ(Перечисление.ТипыДоговоров.СПереработчиком2_5),
		|										ЗНАЧЕНИЕ(Перечисление.ТипыДоговоров.СПереработчиком2_5_ЕАЭС))
		|ГДЕ
		|	Таблица.Ссылка В (&Ссылка)";
	
	ТекстПланыПоставок = 
		"ВЫБРАТЬ
		|	Таблица.Ссылка                                                              КАК Ссылка,
		|	Договоры.Организация                                                        КАК Организация,
		|	Договоры.Партнер                                                            КАК Партнер,
		|	
		|	Таблица.Ссылка.ОбъектРасчетов                                               КАК ОбъектРасчетов,
		|	Таблица.Ссылка.Дата                                                         КАК ДатаРегистратора,
		|	Таблица.Ссылка.Номер                                                        КАК НомерРегистратора,
		|	Договоры.ПорядокРасчетов                                                 КАК ПорядокРасчетов,
		|	Договоры.ВалютаВзаиморасчетов                                               КАК ВалютаВзаиморасчетов,
		|	Договоры.ВалютаВзаиморасчетов                                               КАК ВалютаДокумента,
		|	ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПланированиеПоЗаказуПоставщику) КАК ХозяйственнаяОперация,
		|	
		|	Таблица.ДатаПоГрафику                                                       КАК ДатаПоступления,
		|	Таблица.СуммаИсполнения                                                     КАК УвеличитьКПоступлению
		|ИЗ
		|	Документ.ГрафикИсполненияДоговора.ЭтапыГрафикаИсполненияДоговора КАК Таблица
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ДоговорыКонтрагентов КАК Договоры
		|		ПО Договоры.Ссылка = Таблица.Ссылка.Договор
		|			И Договоры.ТипДоговора В (ЗНАЧЕНИЕ(Перечисление.ТипыДоговоров.СПоставщиком),
		|										ЗНАЧЕНИЕ(Перечисление.ТипыДоговоров.Импорт),
		//++ Устарело_Переработка24
		|										ЗНАЧЕНИЕ(Перечисление.ТипыДоговоров.СПереработчиком),
		//-- Устарело_Переработка24
		|										ЗНАЧЕНИЕ(Перечисление.ТипыДоговоров.СПереработчиком2_5),
		|										ЗНАЧЕНИЕ(Перечисление.ТипыДоговоров.СПереработчиком2_5_ЕАЭС))
		|ГДЕ
		|	Таблица.Ссылка В (&Ссылка)
		|	И НЕ Таблица.УжеОтгружено";
	
	ВзаиморасчетыСервер.ПроведениеГрафикаИсполненияДоговораСПоставщиком(Запрос, ТекстыЗапроса, Регистры, ТекстПланыОплат, ТекстПланыПоставок);
	ВзаиморасчетыСервер.ПроведениеРасчетыСПоставщикамиПланОплат(Запрос, ТекстыЗапроса, Регистры, ТекстПланыОплат);
	ВзаиморасчетыСервер.ПроведениеРасчетыСПоставщикамиПланПоставок(Запрос, ТекстыЗапроса, Регистры, ТекстПланыПоставок, Истина);
	
	#КонецОбласти
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
