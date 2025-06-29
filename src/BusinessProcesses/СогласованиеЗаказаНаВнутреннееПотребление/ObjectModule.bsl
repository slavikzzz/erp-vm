#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Добавляет строку с результатом согласования рецензента в тч РезультатыСогласования.
//
// Параметры:
//	ТочкаМаршрута         - ТочкаМаршрутаБизнесПроцессаСсылка.СогласованиеЗаказаНаВнутреннееПотребление - 
//	Рецензент             - СправочникСсылка.Пользователи - исполнитель задачи по согласованию
//	РезультатСогласования - ПеречислениеСсылка.РезультатыСогласования - 
//	Комментарий           - Строка - комментарий рецензента
//	ДатаИсполнения        - Дата - дата выполнения задачи по согласованию рецензентом.
//
Процедура ДобавитьРезультатСогласования(Знач ТочкаМаршрута,
	                                    Знач Рецензент,
	                                    Знач РезультатСогласования,
	                                    Знач Комментарий,
	                                    Знач ДатаИсполнения) Экспорт
	
	НоваяСтрока                       = РезультатыСогласования.Добавить();
	НоваяСтрока.ТочкаМаршрута         = ТочкаМаршрута;
	НоваяСтрока.Рецензент             = Рецензент;
	НоваяСтрока.РезультатСогласования = РезультатСогласования;
	НоваяСтрока.Комментарий           = Комментарий;
	НоваяСтрока.ДатаСогласования      = ДатаИсполнения;
	
	Если БизнесПроцессы.СогласованиеЗаказаНаВнутреннееПотребление.ИспользуетсяВерсионированиеПредмета(Предмет.Метаданные().ПолноеИмя()) Тогда
		НоваяСтрока.НомерВерсии = БизнесПроцессы.СогласованиеЗаказаНаВнутреннееПотребление.НомерПоследнейВерсииПредмета(Ссылка);
	КонецЕсли;
	
КонецПроцедуры

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом
// Параметры:
//    Таблица - см. УправлениеДоступом.ТаблицаНаборыЗначенийДоступа
Процедура ЗаполнитьНаборыЗначенийДоступа(Таблица) Экспорт
	
	// Логика ограничения:
	// Чтение:    Без ограничения.
	// Изменение: Не используется.
	
	// Чтение, Изменение: набор №0.
	Строка = Таблица.Добавить();
	Строка.ЗначениеДоступа = Перечисления.ДополнительныеЗначенияДоступа.ДоступРазрешен;
	
КонецПроцедуры 

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	// Дата согласования должна быть не меньше даты документа
	Если ЗначениеЗаполнено(ДатаСогласования) И ДатаСогласования < НачалоДня(Дата) Тогда
		
		ТекстОшибки = НСтр("ru = 'Дата согласования должна быть не меньше даты бизнес-процесса %Дата%';
							|en = 'Approval date must not be earlier than the business process date %Дата%'");
		ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Дата%", Формат(Дата,"ДЛФ=DD"));
		
		ОбщегоНазначения.СообщитьПользователю(
			ТекстОшибки,
			ЭтотОбъект,
			"ДатаСогласования",
			,
			Отказ);
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Предмет) Тогда
	
		Запрос = Новый Запрос("
			|ВЫБРАТЬ
			|	ВЫБОР
			|		КОГДА
			|			ДокументПредмет.Проведен И ДокументПредмет.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыВнутреннихЗаказов.НаСогласовании)
			|		ТОГДА
			|			ЛОЖЬ
			|		ИНАЧЕ
			|			ИСТИНА
			|	КОНЕЦ КАК ЕстьОшибкиСогласован,
			|	ВЫБОР
			|		КОГДА (НЕ ДокументПредмет.Проведен)
			|			ТОГДА ИСТИНА
			|		ИНАЧЕ ЛОЖЬ
			|	КОНЕЦ КАК ЕстьОшибкиПроведен,
			|	ДокументПредмет.ПометкаУдаления КАК ПометкаУдаления,
			|	ДокументПредмет.Ссылка КАК Предмет
			|ИЗ
			|	Документ.ЗаказНаВнутреннееПотребление КАК ДокументПредмет
			|ГДЕ
			|	ДокументПредмет.Ссылка = &Предмет
			|");
			
		Запрос.УстановитьПараметр("Предмет", Предмет);
		Выборка = Запрос.Выполнить().Выбрать();
		Выборка.Следующий();
		
		// Документ не проведен - нет смысла начинать согласование
		Если Выборка.ЕстьОшибкиПроведен Тогда
			
			ТекстОшибки = НСтр("ru = 'Согласование не может быть начато, т.к. документ %Предмет% не проведен';
								|en = 'Cannot start the approval process as the %Предмет% document is not posted'");
			ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Предмет%", Выборка.Предмет);
			
			ОбщегоНазначения.СообщитьПользователю(
				ТекстОшибки,
				ЭтотОбъект,
				"Предмет",
				,
				Отказ);
				
			Возврат;
			
		// Документ уже согласован или помечен на удаление - нет смысла начинать согласование.
		ИначеЕсли Выборка.ЕстьОшибкиСогласован Тогда
			
			ТекстОшибки = НСтр("ru = 'Документ %Предмет% не нуждается в согласовании';
								|en = 'Document %Предмет% does not require approval'");
			ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Предмет%", Выборка.Предмет);
			
			ОбщегоНазначения.СообщитьПользователю(
				ТекстОшибки,
				ЭтотОбъект,
				"Предмет",
				,
				Отказ);
				
			Возврат;
			
		ИначеЕсли Выборка.ПометкаУдаления Тогда
			
			ТекстОшибки = НСтр("ru = 'Документ %Предмет% не может быть согласован, т.к. помечен на удаление';
								|en = 'Document %Предмет% cannot be approved because it is marked for deletion'");
			ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Предмет%", Выборка.Предмет);
			
			ОбщегоНазначения.СообщитьПользователю(
				ТекстОшибки,
				ЭтотОбъект,
				"Предмет",
				,
				Отказ);
				
			Возврат;
			
		КонецЕсли;
		
		Запрос = Новый Запрос("
		|ВЫБРАТЬ ПЕРВЫЕ 1
		|	ИСТИНА КАК ЗапущеноСогласование
		|ИЗ
		|	БизнесПроцесс.СогласованиеЗаказаНаВнутреннееПотребление КАК СогласованиеЗаказаНаВнутреннееПотребление
		|ГДЕ
		|	СогласованиеЗаказаНаВнутреннееПотребление.Предмет = &Предмет
		|	И СогласованиеЗаказаНаВнутреннееПотребление.Стартован
		|	И НЕ СогласованиеЗаказаНаВнутреннееПотребление.Завершен
		|	И НЕ СогласованиеЗаказаНаВнутреннееПотребление.ПометкаУдаления");
			
		Запрос.УстановитьПараметр("Предмет", Предмет);
		
		Если НЕ Запрос.Выполнить().Пустой() Тогда
			
			ТекстОшибки = НСтр("ru = 'Согласование не может быть начато, т.к. по документу %Предмет% уже запущен процесс согласования';
								|en = 'Cannot start the approval process as it has already been started for the %Предмет% document'");
			ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Предмет%", Предмет);
			
			ОбщегоНазначения.СообщитьПользователю(
				ТекстОшибки,
				ЭтотОбъект,
				"Предмет",
				,
				Отказ);
				
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	
	Если ТипДанныхЗаполнения = Тип("Структура") Тогда
		ЗаполнитьДокументПоОтбору(ДанныеЗаполнения);
	ИначеЕсли ТипДанныхЗаполнения = Тип("ДокументСсылка.ЗаказНаВнутреннееПотребление") Тогда
		ЗаполнитьБизнесПроцессНаОснованииЗаказНаВнутреннееПотребление(ДанныеЗаполнения);
	КонецЕсли;
	
	ИнициализироватьБизнесПроцесс();
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ДатаНачала            = Дата(1,1,1);
	ДатаОкончания         = Дата(1,1,1);
	РезультатСогласования = Перечисления.РезультатыСогласования.ПустаяСсылка();
	
	РезультатыСогласования.Очистить();
	
	ИнициализироватьБизнесПроцесс();
	
КонецПроцедуры

Процедура СтартПередСтартом(ТочкаМаршрутаБизнесПроцесса, Отказ)
	
	ДатаНачала = ТекущаяДатаСеанса();
	
	Если НЕ ОбщегоНазначенияУТ.ПроверитьСогласующегоБизнесПроцесс(Справочники.РолиИсполнителей.СогласующийЗаказыНаВнутреннееПотребление) Тогда
		ТекстСообщения = НСтр("ru = 'Не указан %РольСогласующего%';
								|en = '%РольСогласующего% is not specified'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%РольСогласующего%", Справочники.РолиИсполнителей.СогласующийЗаказыНаВнутреннееПотребление);
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗавершениеПриЗавершении(ТочкаМаршрутаБизнесПроцесса, Отказ)
	
	ДатаЗавершения = ТекущаяДатаСеанса();
	
КонецПроцедуры

Процедура ОбработкаРезультатовСогласованияОбработка(ТочкаМаршрутаБизнесПроцесса)
	
	УстановитьПривилегированныйРежим(Истина);
	
	ПредметОбъект = Предмет.ПолучитьОбъект();
	
	// Документ уже согласован - ничего делать не требуется
	Если Не ПредметОбъект.ПометкаУдаления И Не (ПредметОбъект.Проведен И ПредметОбъект.Статус <> Перечисления.СтатусыВнутреннихЗаказов.НаСогласовании) Тогда
		
		Попытка
			ЗаблокироватьДанныеДляРедактирования(Предмет);
		Исключение
			
			ТекстОшибки = НСтр("ru = 'В ходе обработки результатов согласования не удалось заблокировать %Предмет%. %ОписаниеОшибки%';
								|en = 'Cannot lock %Предмет% while processing approval results. %ОписаниеОшибки%'");
			ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Предмет%",        Предмет);
			ТекстОшибки = СтрЗаменить(ТекстОшибки, "%ОписаниеОшибки%", КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
			
			ВызватьИсключение ТекстОшибки;
			
		КонецПопытки;
		
		ПредметОбъект.Согласован = Истина;
		ПредметОбъект.Статус = Перечисления.СтатусыВнутреннихЗаказов.КВыполнению;
		
		Попытка
		
			ПредметОбъект.Записать(РежимЗаписиДокумента.Проведение);
			РазблокироватьДанныеДляРедактирования(Предмет);
			
		Исключение
			
			РазблокироватьДанныеДляРедактирования(Предмет);
			
			ТекстОшибки = НСтр("ru = 'Не удалось записать %Предмет%. %ОписаниеОшибки%';
								|en = 'Cannot save %Предмет%. %ОписаниеОшибки%'");
			ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Предмет%",        Предмет);
			ТекстОшибки = СтрЗаменить(ТекстОшибки, "%ОписаниеОшибки%", КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
			
			ВызватьИсключение ТекстОшибки;
			
		КонецПопытки
		
	КонецЕсли;
		
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

Процедура ДокументСогласованПроверкаУсловия(ТочкаМаршрутаБизнесПроцесса, Результат)
	
	Результат = (РезультатСогласования = Перечисления.РезультатыСогласования.Согласовано);
	
КонецПроцедуры

Процедура ОзнакомитьсяСРезультатамиПередСозданиемЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Задача = СоздатьЗадачу(ТочкаМаршрутаБизнесПроцесса);
	Задача.Исполнитель = Автор;
	ФормируемыеЗадачи.Добавить(Задача);
	
КонецПроцедуры

Процедура СогласоватьЗаказНаВнутреннееПотреблениеПередСозданиемЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Задача = СоздатьЗадачу(ТочкаМаршрутаБизнесПроцесса);
	ФормируемыеЗадачи.Добавить(Задача);
	
КонецПроцедуры

Процедура ОзнакомитьсяСРезультатамиОбработкаПроверкиВыполнения(ТочкаМаршрутаБизнесПроцесса, Задача, Результат)
	
	Результат = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочее

Функция СоздатьЗадачу(Знач ТочкаМаршрутаБизнесПроцесса)
	
	Реквизиты = "НаименованиеЗадачи, РольИсполнителя, ОсновнойОбъектАдресации, ДополнительныйОбъектАдресации";
	ЗначенияРеквизитов = Новый Структура(Реквизиты);
	ЗаполнитьЗначенияСвойств(ЗначенияРеквизитов, ТочкаМаршрутаБизнесПроцесса, Реквизиты);
	
	Задача = Задачи.ЗадачаИсполнителя.СоздатьЗадачу();
	
	Задача.Дата                          = ТекущаяДатаСеанса();
	Задача.Автор                         = Автор;
	Задача.Наименование                  = ЗначенияРеквизитов.НаименованиеЗадачи;
	Задача.Описание                      = Наименование;
	Задача.Предмет                       = Предмет;
	Задача.Важность                      = Важность;
	Задача.РольИсполнителя               = ЗначенияРеквизитов.РольИсполнителя;
	Задача.ОсновнойОбъектАдресации       = ЗначенияРеквизитов.ОсновнойОбъектАдресации;
	Задача.ДополнительныйОбъектАдресации = ЗначенияРеквизитов.ДополнительныйОбъектАдресации;
	Задача.БизнесПроцесс                 = Ссылка;
	Задача.СрокИсполнения                = ДатаСогласования;
	Задача.ТочкаМаршрута                 = ТочкаМаршрутаБизнесПроцесса;
	
	Возврат Задача;
	
КонецФункции

Процедура ЗаполнитьБизнесПроцессНаОснованииЗаказНаВнутреннееПотребление(ДокументОснование)
	
	Запрос = Новый Запрос("
		|ВЫБРАТЬ
		|	ЗаказНаВнутреннееПотребление.Ссылка           КАК Предмет,
		|	ЗаказНаВнутреннееПотребление.Статус           КАК Статус,
		|	ВЫБОР
		|		КОГДА
		|			ЗаказНаВнутреннееПотребление.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыВнутреннихЗаказов.НаСогласовании)
		|		ТОГДА
		|			ЛОЖЬ
		|		ИНАЧЕ
		|			ИСТИНА
		|	КОНЕЦ КАК ЕстьОшибкиСтатус
		|ИЗ
		|	Документ.ЗаказНаВнутреннееПотребление КАК ЗаказНаВнутреннееПотребление
		|ГДЕ
		|	ЗаказНаВнутреннееПотребление.Ссылка = &ДокументОснование
		|");
	
	Запрос.УстановитьПараметр("ДокументОснование", ДокументОснование);
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	МассивДопустимыхСтатусов = Новый Массив();
	МассивДопустимыхСтатусов.Добавить(Перечисления.СтатусыВнутреннихЗаказов.НаСогласовании);
	
	ПараметрыПроверки = ОбщегоНазначенияУТ.ПараметрыПроверкиВозможностиВводаНаОсновании();
	ПараметрыПроверки.Статус = Выборка.Статус;
	ПараметрыПроверки.ЕстьОшибкиПроведен = Ложь;
	ПараметрыПроверки.ЕстьОшибкиСтатус = Выборка.ЕстьОшибкиСтатус;
	ПараметрыПроверки.МассивДопустимыхСтатусов = МассивДопустимыхСтатусов;
	
	ОбщегоНазначенияУТ.ПроверитьВозможностьВводаНаОснованииСПараметрами(Выборка.Предмет, ПараметрыПроверки);
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Выборка);
	
КонецПроцедуры

Процедура ЗаполнитьДокументПоОтбору(Знач ДанныеЗаполнения)
	
	Если ДанныеЗаполнения.Свойство("Предмет") Тогда
		
		ТипПредмета = ТипЗнч(ДанныеЗаполнения.Предмет);
		
		Если ТипПредмета = Тип("ДокументСсылка.ЗаказНаВнутреннееПотребление") Тогда
			ЗаполнитьБизнесПроцессНаОснованииЗаказНаВнутреннееПотребление(ДанныеЗаполнения.Предмет);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ИнициализироватьБизнесПроцесс()
	
	Автор = Пользователи.ТекущийПользователь();
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
