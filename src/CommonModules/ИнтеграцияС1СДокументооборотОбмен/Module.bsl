////////////////////////////////////////////////////////////////////////////////
// Подсистема "Интеграция с 1С:Документооборотом"
// Модуль ИнтеграцияС1СДокументооборотОбмен, сервер, внешнее соединение
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Возвращает измененные объекты, интегрированные с 1С:Документооборотом, и готовые к выгрузке.
//
// Параметры:
//   Прокси - WSПрокси - объект для подключения к web-сервисам Документооборота.
//   УзелОбмена - ПланОбменаСсылка.ИнтеграцияС1СДокументооборотомПереопределяемый - узел, по которому нужно
//     получить изменения.
//   ОбъектыКУдалениюИзРегистрацииИзменений - Массив из ЛюбаяСсылка - неявно возвращаемое значение,
//     содержит ссылки на объекты, не требующие выгрузки, и на успешно отправленные объекты.
//
// Возвращаемое значение:
//   Массив из Структура:
//     * Объект - ЛюбаяСсылка
//     * ТипОбъектаДО - Строка
//     * ИдентификаторОбъектаДО - Строка
//     * ПравилоЗаполнения - СправочникСсылка.ПравилаИнтеграцииС1СДокументооборотом
//
Функция ЗарегистрированныеДанные(Прокси, УзелОбмена, ОбъектыКУдалениюИзРегистрацииИзменений) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	МассивДанных = Новый Массив;
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	Правила.Ссылка КАК Правило
		|ПОМЕСТИТЬ ПравилаСУсловиями
		|ИЗ
		|	Справочник.ПравилаИнтеграцииС1СДокументооборотом КАК Правила
		|ГДЕ
		|	(ВЫРАЗИТЬ(Правила.УсловиеПрименимостиПриВыгрузке КАК СТРОКА(1))) <> """"
		|
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ
		|	ПравилаЗагрузки.Ссылка
		|ИЗ
		|	Справочник.ПравилаИнтеграцииС1СДокументооборотом.ПравилаЗаполненияРеквизитовИС КАК ПравилаЗагрузки
		|ГДЕ
		|	ПравилаЗагрузки.Ключевой
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	Правила.Ссылка КАК ПравилоЗаполнения,
		|	Правила.ТипОбъектаИС КАК ТипОбъектаИС,
		|	Правила.ТипОбъектаДО КАК ТипОбъектаДО,
		|	ВЫБОР
		|		КОГДА Правила.Ссылка В
		|				(ВЫБРАТЬ
		|					ПравилаСУсловиями.Правило
		|				ИЗ
		|					ПравилаСУсловиями)
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ КАК ЕстьУсловия
		|ПОМЕСТИТЬ ПравилаЗаполнения
		|ИЗ
		|	Справочник.ПравилаИнтеграцииС1СДокументооборотом КАК Правила
		|ГДЕ
		|	НЕ Правила.Ссылка.ПометкаУдаления
		|	И Правила.ВыгружатьИзменения");
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Запрос.Выполнить();
	
	// Проверим, нужно ли получить связанные объекты.
	ИнтеграцияС1СДокументооборот.ПроверитьОбновитьДанныеСвязанныхОбъектов();
	
	Для Каждого ЭлементСоставаПланаОбмена Из УзелОбмена.Метаданные().Состав Цикл
		ЗапросИзменения = Новый Запрос;
		ЗапросИзменения.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
		
		ПолноеИмяМетаданныхЭлемента = ЭлементСоставаПланаОбмена.Метаданные.ПолноеИмя();
		ТекстЗапроса =
			"ВЫБРАТЬ
			|	ТаблицаИзменения.Ссылка КАК Объект,
			|	ЕСТЬNULL(ОбъектыИнтегрированныеС1СДокументооборотом.ИдентификаторОбъектаДО, """") КАК ИдентификаторОбъектаДО,
			|	ЕСТЬNULL(ОбъектыИнтегрированныеС1СДокументооборотом.ТипОбъектаДО, """") КАК ТипОбъектаДО,
			|	ЕСТЬNULL(ПравилаЗаполнения.ПравилоЗаполнения, НЕОПРЕДЕЛЕНО) КАК ПравилоЗаполнения,
			|	ЕСТЬNULL(ПравилаЗаполнения.ЕстьУсловия, НЕОПРЕДЕЛЕНО) КАК ЕстьУсловия
			|ИЗ
			|	&ТаблицаИзменения КАК ТаблицаИзменения
			|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ОбъектыИнтегрированныеС1СДокументооборотом КАК ОбъектыИнтегрированныеС1СДокументооборотом
			|			ЛЕВОЕ СОЕДИНЕНИЕ ПравилаЗаполнения КАК ПравилаЗаполнения
			|			ПО (ПравилаЗаполнения.ТипОбъектаИС = &ПолноеИмяМетаданныхЭлемента)
			|				И ОбъектыИнтегрированныеС1СДокументооборотом.ТипОбъектаДО = ПравилаЗаполнения.ТипОбъектаДО
			|		ПО ТаблицаИзменения.Ссылка = ОбъектыИнтегрированныеС1СДокументооборотом.Объект
			|ГДЕ
			|	ТаблицаИзменения.Узел = &Узел
			|ИТОГИ
			|	МАКСИМУМ(ИдентификаторОбъектаДО),
			|	МАКСИМУМ(ТипОбъектаДО)
			|ПО
			|	Объект";
		ЗапросИзменения.Текст = СтрЗаменить(
			ТекстЗапроса,
			"&ТаблицаИзменения",
			СтрШаблон("%1.%2",
				ПолноеИмяМетаданныхЭлемента,
				"Изменения"));
		ЗапросИзменения.УстановитьПараметр("ПолноеИмяМетаданныхЭлемента", ПолноеИмяМетаданныхЭлемента);
		ЗапросИзменения.УстановитьПараметр("Узел", УзелОбмена);
		ВыборкаОбъекты = ЗапросИзменения.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		
		Пока ВыборкаОбъекты.Следующий() Цикл
			
			Если ЗначениеЗаполнено(ВыборкаОбъекты.ИдентификаторОбъектаДО)
					И ОбъектДОПоддерживаетОбмен(ВыборкаОбъекты.ТипОбъектаДО) Тогда
				ИнтегрированныйОбъект = Новый Структура("Объект", ВыборкаОбъекты.Объект);
				ИнтегрированныйОбъект.Вставить("ТипОбъектаДО", ВыборкаОбъекты.ТипОбъектаДО);
				ИнтегрированныйОбъект.Вставить("ИдентификаторОбъектаДО", ВыборкаОбъекты.ИдентификаторОбъектаДО);
			Иначе
				// Выгружать объект не требуется.
				ОбъектыКУдалениюИзРегистрацииИзменений.Добавить(ВыборкаОбъекты.Объект);
				Продолжить;
			КонецЕсли;
			
			ВыборкаПравила = ВыборкаОбъекты.Выбрать();
			ВыборкаПравила.Следующий();
			ЕстьПодходящиеПравила = (ВыборкаПравила.Количество() = 1) И (ВыборкаПравила.ЕстьУсловия = Ложь);
			
			Если ЕстьПодходящиеПравила Тогда
				ИнтегрированныйОбъект.Вставить("ПравилоЗаполнения", ВыборкаПравила.ПравилоЗаполнения);
			Иначе
				// Требуется уточнение.
				Правила = ИнтеграцияС1СДокументооборотВызовСервера.ПодходящиеПравила(ВыборкаОбъекты.Объект);
				Если Правила.Количество() = 0 Тогда
					// Объект ИС не будет отправлен и останется в таблице регистрации изменений.
					ТекстОшибки = СтрШаблон(
						НСтр("ru = 'Объект ""%1"" (%2) зарегистрирован к обмену данными со связанным объектом в 1С:Документооборот,
							|но подходящие правила интеграции не найдены.';
							|en = 'The ""%1"" (%2) object is registered to exchange data with the related object in 1C:Document Management.
							|However, no suitable integration rules are found.'"),
						ВыборкаОбъекты.Объект,
						ТипЗнч(ВыборкаОбъекты.Объект));
					ЗаписьЖурналаРегистрации(
						ИнтеграцияС1СДокументооборотБазоваяФункциональность.ИмяСобытияЖурналаРегистрации(
							НСтр("ru = 'Отправка данных';
								|en = 'Export'", ОбщегоНазначения.КодОсновногоЯзыка())),
						УровеньЖурналаРегистрации.Ошибка,
						Метаданные.ПланыОбмена.ИнтеграцияС1СДокументооборотомПереопределяемый,
						ВыборкаОбъекты.Объект,
						ТекстОшибки);
					Продолжить;
				КонецЕсли;
				ИнтегрированныйОбъект.Вставить("ПравилоЗаполнения", Правила[0].Ссылка);
			КонецЕсли;
			
			МассивДанных.Добавить(ИнтегрированныйОбъект);
			ОбъектыКУдалениюИзРегистрацииИзменений.Добавить(ВыборкаОбъекты.Объект);
			
		КонецЦикла;
		
	КонецЦикла;
	
	МенеджерВременныхТаблиц.Закрыть();
	
	Возврат МассивДанных;
	
КонецФункции

// Получает данные из Документооборота.
//
Процедура ПолучитьДанные() Экспорт
	
	Попытка
		
		Прокси = ИнтеграцияС1СДокументооборотБазоваяФункциональностьПовтИсп.ПолучитьПрокси();
		
		ПоддерживаетсяПропускСообщенийСОшибкой =
			ИнтеграцияС1СДокументооборотБазоваяФункциональность.ДоступенФункционалВерсииСервиса("2.1.28.12.CORP");
		
		УзелДокументооборота = ИнтеграцияС1СДокументооборотБазоваяФункциональностьПовтИсп.УзелДокументооборота();
		СоставПланаОбмена = Метаданные.ПланыОбмена.ИнтеграцияС1СДокументооборотомПереопределяемый.Состав;
		
		ПрочитаныВсеСообщения = Ложь;
		НомерПоследнегоСообщения = "";
		СообщениеБылоПринято = Истина;
		ТекстОшибки = "";
		ПропускаемыеСообщения = Новый Массив;
		
		Пока Не ПрочитаныВсеСообщения Цикл
			
			Запрос = ИнтеграцияС1СДокументооборотБазоваяФункциональность.СоздатьОбъект(Прокси, "DMGetChangesRequest");
			Запрос.lastMessageID = НомерПоследнегоСообщения;
			
			Если ПоддерживаетсяПропускСообщенийСОшибкой Тогда
				Запрос.lastMessageWasReceived = СообщениеБылоПринято;
				Запрос.errorDescription = ТекстОшибки;
				
				Если СообщениеБылоПринято = Ложь
						И ПропускаемыеСообщения.Найти(НомерПоследнегоСообщения) = Неопределено Тогда
					ПропускаемыеСообщения.Добавить(НомерПоследнегоСообщения);
				КонецЕсли;
				
				ПропускаемыеСообщенияВЗапросе = Запрос.skipMessages; // СписокXDTO
				Для Каждого Элемент Из ПропускаемыеСообщения Цикл
					ПропускаемыеСообщенияВЗапросе.Добавить(Элемент);
				КонецЦикла;
			Иначе
				Если СообщениеБылоПринято = Ложь Тогда
					Прервать;
				КонецЕсли;
			КонецЕсли;
			
			Ответ = ИнтеграцияС1СДокументооборотБазоваяФункциональность.ВыполнитьЗапрос(Прокси, Запрос);
			ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПроверитьВозвратВебСервиса(Прокси, Ответ);
			
			НомерПоследнегоСообщения = Строка(Ответ.messageID);
			СообщениеБылоПринято = Истина;
			ТекстОшибки = "";
			
			Для Каждого ОбъектXDTO Из Ответ.objects Цикл
				
				Если ОбъектXDTO.objectID.type = "DMInternalDocumentTemplate"
						Или ОбъектXDTO.objectID.type = "DMIncomingDocumentTemplate"
						Или ОбъектXDTO.objectID.type = "DMOutgoingDocumentTemplate" Тогда
					Справочники.ПравилаИнтеграцииС1СДокументооборотом.ОбновитьПравилаПоШаблону(ОбъектXDTO);
					Продолжить;
				КонецЕсли;
				
				Ссылки = ИнтеграцияС1СДокументооборотБазоваяФункциональность.СсылкиПоВнешнимОбъектам(ОбъектXDTO);
				
				Для Каждого ОбъектСсылка Из Ссылки Цикл
					
					ПодходящиеПравила = ИнтеграцияС1СДокументооборотВызовСервера.ПодходящиеПравила(
						ОбъектСсылка,
						ОбъектXDTO);
					Если ПодходящиеПравила = Неопределено Или ПодходящиеПравила.Количество() = 0 Тогда
						Продолжить;
					КонецЕсли;
					Правило = ПодходящиеПравила[0].Ссылка;
					
					Если ИнтеграцияС1СДокументооборотБазоваяФункциональность.СвойствоУстановлено(ОбъектXDTO, "files") Тогда
						
						Если ОбъектXDTO.files.Количество() > 0 Тогда
							ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПриПоявленииПрисоединенныхФайловДокументооборота(
								ОбъектXDTO.objectID.ID,
								ОбъектXDTO.objectID.type,
								ОбъектСсылка,
								Истина);
						Иначе
							ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПриУдаленииПрисоединенныхФайловДокументооборота(
								ОбъектXDTO.objectID.ID,
								ОбъектXDTO.objectID.type,
								ОбъектСсылка);
						КонецЕсли;
						
					КонецЕсли;
					
					Объект = ОбъектСсылка.ПолучитьОбъект();
					
					ИсходнаяПометкаУдаления = Объект.ПометкаУдаления;
					
					Обновление = Истина;
					ТребуетсяПерепроведение = Ложь;
					ЕстьИзменения = Справочники.ПравилаИнтеграцииС1СДокументооборотом.ЗаполнитьОбъектПоОбъектуXDTO(
						Прокси,
						Объект,
						ОбъектXDTO,
						Правило,
						Обновление,
						ТребуетсяПерепроведение);
					
					Если ЕстьИзменения Тогда
						
						Попытка
							
							Если Объект.ПометкаУдаления И Не ИсходнаяПометкаУдаления Тогда
								
								МетаданныеОбъекта = Объект.Метаданные();
								Если Метаданные.Документы.Содержит(МетаданныеОбъекта)
										И МетаданныеОбъекта.Проведение = Метаданные.СвойстваОбъектов.Проведение.Разрешить
										И Объект.Проведен Тогда
									
									Действие = НСтр("ru = 'Удаление с отменой проведения';
													|en = 'Delete and cancel posting'",
										ОбщегоНазначения.КодОсновногоЯзыка());
									
									Отказ = Ложь;
									РежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения;
									ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПередЗаписьюОбъектаИС(
										Объект,
										Отказ,
										РежимЗаписи);
									Если Не Отказ Тогда
										Объект.Записать(РежимЗаписи);
									КонецЕсли;
									
								Иначе
									
									Действие = НСтр("ru = 'Удаление';
													|en = 'Delete'", ОбщегоНазначения.КодОсновногоЯзыка());
									Объект.ОбменДанными.Загрузка = Истина;
									
									Отказ = Ложь;
									ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПередЗаписьюОбъектаИС(
										Объект,
										Отказ);
									Если Не Отказ Тогда
										Объект.Записать();
									КонецЕсли;
									
								КонецЕсли;
								
							Иначе
								
								ЗаполненКорректно = Объект.ПроверитьЗаполнение();
								
								Если ЗаполненКорректно Тогда
									
									Если ТребуетсяПерепроведение Тогда
										
										Действие = НСтр("ru = 'Проведение';
														|en = 'Posting'", ОбщегоНазначения.КодОсновногоЯзыка());
										
										Отказ = Ложь;
										РежимЗаписи = РежимЗаписиДокумента.Проведение;
										РежимПроведения = РежимПроведенияДокумента.Неоперативный;
										ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПередЗаписьюОбъектаИС(
											Объект,
											Отказ,
											РежимЗаписи,
											РежимПроведения);
										Если Не Отказ Тогда
											Объект.Записать(РежимЗаписи, РежимПроведения);
										КонецЕсли;
										
									Иначе
										
										Действие = НСтр("ru = 'Запись';
														|en = 'Record'", ОбщегоНазначения.КодОсновногоЯзыка());
										Объект.ОбменДанными.Загрузка = Истина;
										
										Отказ = Ложь;
										ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПередЗаписьюОбъектаИС(
											Объект,
											Отказ);
										Если Не Отказ Тогда
											Объект.Записать();
										КонецЕсли;
										
									КонецЕсли;
									
								Иначе
									
									СообщениеБылоПринято = Ложь;
									СообщенияПользователю = ПолучитьСообщенияПользователю(Истина);
									ТекстСообщения = Новый Массив;
									ТекстСообщения.Добавить(
										СтрШаблон(НСтр("ru = 'Объект: %1';
														|en = 'Object: %1'", ОбщегоНазначения.КодОсновногоЯзыка()),
											СокрЛП(Объект)));
									ТекстСообщения.Добавить(
										НСтр("ru = 'Ошибка заполнения:';
											|en = 'Filling error:'", ОбщегоНазначения.КодОсновногоЯзыка()));
									Для Каждого СообщениеПользователю Из СообщенияПользователю Цикл
										ТекстСообщения.Добавить(СообщениеПользователю.Текст);
									КонецЦикла;
									ТекстОшибки = СтрСоединить(ТекстСообщения, Символы.ПС);
									ЗаписьЖурналаРегистрации(
										ИнтеграцияС1СДокументооборотБазоваяФункциональность.ИмяСобытияЖурналаРегистрации(
											НСтр("ru = 'Получение данных';
												|en = 'Get data'", ОбщегоНазначения.КодОсновногоЯзыка())),
										УровеньЖурналаРегистрации.Ошибка,,
										"DMGetChangesRequest",
										ТекстОшибки);
									Прервать;
									
								КонецЕсли;
								
							КонецЕсли;
							
						Исключение
							СообщениеБылоПринято = Ложь;
							ТекстОшибки = СтрШаблон(НСтр("ru = 'Действие: %1
														|%2';
														|en = 'Action: %1
														|%2'", ОбщегоНазначения.КодОсновногоЯзыка()),
								Действие,
								ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
							ЗаписьЖурналаРегистрации(
								ИнтеграцияС1СДокументооборотБазоваяФункциональность.ИмяСобытияЖурналаРегистрации(
									НСтр("ru = 'Получение данных';
										|en = 'Get data'", ОбщегоНазначения.КодОсновногоЯзыка())),
								УровеньЖурналаРегистрации.Ошибка,,
								"DMGetChangesRequest",
								ТекстОшибки);
							Прервать;
						КонецПопытки;
						
						РегистрыСведений.ОбъектыКОбновлениюПечатныхФорм.Добавить(ОбъектСсылка, Правило);
						
						Если СоставПланаОбмена.Содержит(Объект.Метаданные()) Тогда
							ПланыОбмена.УдалитьРегистрациюИзменений(УзелДокументооборота, Объект.Ссылка);
						КонецЕсли;
						
					КонецЕсли;
					
				КонецЦикла;
				
				Если СообщениеБылоПринято = Ложь Тогда
					Прервать;
				КонецЕсли;
				
			КонецЦикла;
			
			// С версии 1.4.8 выполняется обновление состояний согласования на стороне ИС.
			Если СообщениеБылоПринято И Ответ.Свойства().Получить("records") <> Неопределено Тогда
				
				Для Каждого ОбъектXDTO Из Ответ.records Цикл
					
					ЗапросСвязанныйОбъект = Новый Запрос(
						"ВЫБРАТЬ ПЕРВЫЕ 1
						|	Объект
						|ИЗ
						|	РегистрСведений.ОбъектыИнтегрированныеС1СДокументооборотом
						|ГДЕ
						|	ТипОбъектаДО = &ТипОбъектаДО
						|	И ИдентификаторОбъектаДО = &ИдентификаторОбъектаДО");
					Если ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПроверитьТип(Прокси, ОбъектXDTO, "DMApprovalStateRecord") Тогда
						ЗапросСвязанныйОбъект.УстановитьПараметр("ТипОбъектаДО", ОбъектXDTO.type);
						ЗапросСвязанныйОбъект.УстановитьПараметр("ИдентификаторОбъектаДО", ОбъектXDTO.ID);
						Выборка = ЗапросСвязанныйОбъект.Выполнить().Выбрать();
						Если Выборка.Следующий() Тогда
							Попытка
								Если ОбъектXDTO.status = Неопределено Тогда // Запись удалена (например, прерывание).
									Действие = НСтр("ru = 'Удаление статуса';
													|en = 'Delete status'", ОбщегоНазначения.КодОсновногоЯзыка());
									ИнтеграцияС1СДокументооборотБазоваяФункциональностьВызовСервера.ПриИзмененииСостоянияСогласования(
										ОбъектXDTO.ID,
										ОбъектXDTO.type,
										Неопределено,
										Ложь,
										Выборка.Объект);
								Иначе
									Действие = НСтр("ru = 'Установка статуса';
													|en = 'Set status'", ОбщегоНазначения.КодОсновногоЯзыка());
									ИдентификаторСостояния = ОбъектXDTO.status.objectID.ID;
									Состояние = Перечисления.СостоянияСогласованияВДокументообороте[ИдентификаторСостояния];
									ИнтеграцияС1СДокументооборотБазоваяФункциональностьВызовСервера.ПриИзмененииСостоянияСогласования(
										ОбъектXDTO.ID,
										ОбъектXDTO.type,
										Состояние,
										Ложь,
										Выборка.Объект,
										ОбъектXDTO.name,
										ОбъектXDTO.date);
								КонецЕсли;
							Исключение
								СообщениеБылоПринято = Ложь;
								ТекстОшибки = СтрШаблон(НСтр("ru = 'Действие: %1
															|%2';
															|en = 'Action: %1
															|%2'", ОбщегоНазначения.КодОсновногоЯзыка()),
									Действие,
									ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
								ЗаписьЖурналаРегистрации(
									ИнтеграцияС1СДокументооборотБазоваяФункциональность.ИмяСобытияЖурналаРегистрации(
										НСтр("ru = 'Получение данных';
											|en = 'Get data'", ОбщегоНазначения.КодОсновногоЯзыка())),
									УровеньЖурналаРегистрации.Ошибка,,
									"DMGetChangesRequest",
									ТекстОшибки);
								Прервать;
							КонецПопытки;
						КонецЕсли;
					КонецЕсли;
					
				КонецЦикла;
				
			КонецЕсли;
			
			ПрочитаныВсеСообщения = (Ответ.messageID = Неопределено);
			
		КонецЦикла;
		
	Исключение
		ЗаписьЖурналаРегистрации(
			ИнтеграцияС1СДокументооборотБазоваяФункциональность.ИмяСобытияЖурналаРегистрации(
				НСтр("ru = 'Получение данных';
					|en = 'Get data'",
					ОбщегоНазначения.КодОсновногоЯзыка())),
			УровеньЖурналаРегистрации.Ошибка,,
			"DMGetChangesRequest",
			ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
	
КонецПроцедуры

// Возвращает объект XDTO, содержащий обновляемые изменения объекта.
//
// Параметры:
//   Прокси - WSПрокси - объект для подключения к web-сервисам Документооборота.
//   ДанныеОбъекта - См. ИнтеграцияС1СДокументооборотОбмен.ЗарегистрированныеДанные
//   КонтрольОтправкиФайлов - см. ИнтеграцияС1СДокументооборотБазоваяФункциональность.КонтрольОтправкиФайлов
//
// Возвращаемое значение:
//   ОбъектXDTO
//
Функция ПолучитьXDTOИзмененийИзОбъекта(Прокси, ДанныеОбъекта, КонтрольОтправкиФайлов) Экспорт
	
	Если ИнтеграцияС1СДокументооборотКлиентСервер.ЭтоДокумент(ДанныеОбъекта.ТипОбъектаДО) Тогда
		
		// Получим документ с заполненными текущими подписями.
		// Веб-сервис ДО 2.1 не может однозначно определить были ли подписи целенаправленно удалены или
		// список подписей просто не был заполнен.
		Попытка
			ОбъектXDTO = ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПолучитьОбъект(
				Прокси,
				ДанныеОбъекта.ТипОбъектаДО,
				ДанныеОбъекта.ИдентификаторОбъектаДО,
				"documentType,signatures");
		Исключение
			ОбъектXDTO = ИнтеграцияС1СДокументооборотБазоваяФункциональность.СоздатьОбъект(
				Прокси,
				ДанныеОбъекта.ТипОбъектаДО);
		КонецПопытки;
		
	Иначе
		
		ОбъектXDTO = ИнтеграцияС1СДокументооборотБазоваяФункциональность.СоздатьОбъект(
			Прокси,
			ДанныеОбъекта.ТипОбъектаДО);
		
	КонецЕсли;
	
	СписокФайлов = ОбъектXDTO.files; // СписокXDTO
	
	ОбъектXDTO.name = Строка(ДанныеОбъекта.Объект);
	
	ОбъектXDTO.objectID = ИнтеграцияС1СДокументооборотБазоваяФункциональность.СоздатьObjectID(
		Прокси,
		ДанныеОбъекта.ИдентификаторОбъектаДО,
		ДанныеОбъекта.ТипОбъектаДО);
	
	СтруктураРеквизитов = ИнтеграцияС1СДокументооборот.СтруктураРеквизитовЗаполняемогоОбъектаДО(
		ДанныеОбъекта.ТипОбъектаДО);
	
	НеОбновлятьПоПравилам = Новый Массив;
	Справочники.ПравилаИнтеграцииС1СДокументооборотом.ЗаполнитьСтруктуруРеквизитовОбъектаДОПоПравилу(
		ДанныеОбъекта.Объект,
		СтруктураРеквизитов,
		ДанныеОбъекта.ПравилоЗаполнения,
		КонтрольОтправкиФайлов,
		Истина,
		НеОбновлятьПоПравилам);
	
	СоответствиеРеквизитов =
		Справочники.ПравилаИнтеграцииС1СДокументооборотом.СоответствиеСвойствXDTOиРеквизитовФормыОбъектаДО(
			ДанныеОбъекта.ТипОбъектаДО);
	
	Для Каждого СтрокаСоответствия Из СоответствиеРеквизитов Цикл
		Если НеОбновлятьПоПравилам.Найти(СтрокаСоответствия.Ключ) <> Неопределено Тогда
			Продолжить;
		КонецЕсли;
		ИнтеграцияС1СДокументооборот.ЗаполнитьСвойствоXDTOизСтруктурыРеквизитов(
			Прокси,
			ОбъектXDTO,
			СтрокаСоответствия.Ключ,
			СтруктураРеквизитов,
			СтрокаСоответствия.Значение);
	КонецЦикла;
	
	Обработки.ИнтеграцияС1СДокументооборотБазоваяФункциональность.СформироватьДополнительныеСвойства(
		Прокси,
		ОбъектXDTO,
		СтруктураРеквизитов);
	
	Если СтруктураРеквизитов.Свойство("Файлы") И СтруктураРеквизитов.Файлы.Количество() > 0 Тогда
		
		Для Каждого ПараметрыСоздания Из СтруктураРеквизитов.Файлы Цикл
			ФайлXDTO = ИнтеграцияС1СДокументооборотБазоваяФункциональность.ФайлXDTOИзПараметровСоздания(
				Прокси,
				ПараметрыСоздания);
			СписокФайлов.Добавить(ФайлXDTO);
		КонецЦикла;
		
	КонецЕсли;
	
	ОбъектXDTO.externalObject = ИнтеграцияС1СДокументооборотБазоваяФункциональность.СоздатьExternalObject(
		Прокси,
		ДанныеОбъекта.Объект);
	
	Возврат ОбъектXDTO;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ОбъектДОПоддерживаетОбмен(ТипОбъектаДО)
	
	Возврат ТипОбъектаДО = "DMInternalDocument"
		Или ТипОбъектаДО = "DMIncomingDocument"
		Или ТипОбъектаДО = "DMOutgoingDocument"
		Или ТипОбъектаДО = "DMCorrespondent";
	
КонецФункции

#КонецОбласти