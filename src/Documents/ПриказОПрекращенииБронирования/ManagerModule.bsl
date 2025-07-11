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
	|	ДляВсехСтрок( ЗначениеРазрешено(ФизическиеЛица.ФизическоеЛицо, NULL КАК ИСТИНА)
	|	) И ЗначениеРазрешено(Организация)";
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

#Область ОбработчикиПравилРегистрации

// См. ЗарплатаКадрыРасширенныйСинхронизацияДанных.ШаблонОбработчика
Процедура ПриЗаполненииНастроекОбработчиковПравилРегистрации(Настройки) Экспорт
	ВоинскийУчет.ДляОтбораПоОрганизации(Настройки);
	ВоинскийУчет.ДляОбъектаСПрисоединеннымиФайлами(Настройки);
КонецПроцедуры

#КонецОбласти

// Возвращает описание состава документа
//
// Возвращаемое значение:
//  Структура - см. ЗарплатаКадрыСоставДокументов.НовоеОписаниеСоставаОбъекта.
Функция ОписаниеСоставаОбъекта() Экспорт
	
	МетаданныеДокумента = Метаданные.Документы.ПриказОПрекращенииБронирования;
	Возврат ЗарплатаКадрыСоставДокументов.ОписаниеСоставаОбъектаПоМетаданнымФизическиеЛицаВТабличныхЧастях(МетаданныеДокумента);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Обработчик = "УправлениеПечатьюБЗККлиент.ВыполнитьКомандуПечати";
	КомандаПечати.Идентификатор = "ПФ_MXL_СписокРаботниковБронированиеКоторыхПрекращено";
	КомандаПечати.Представление = НСтр("ru = 'Список работников';
										|en = 'Список работников'");
	КомандаПечати.Порядок = 10;
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Обработчик = "УправлениеПечатьюБЗККлиент.ВыполнитьКомандуПечати";
	КомандаПечати.Идентификатор = "ПФ_MXL_ВыпискаИзПриказаОПрекращенииБронирования";
	КомандаПечати.Представление = НСтр("ru = 'Выписка из приказа о прекращении бронирования';
										|en = 'Выписка из приказа о прекращении бронирования'");
	КомандаПечати.Порядок = 20;
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	
КонецПроцедуры

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт	
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПФ_MXL_СписокРаботниковБронированиеКоторыхПрекращено") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм, 
			"ПФ_MXL_СписокРаботниковБронированиеКоторыхПрекращено", 
			НСтр("ru = 'Список работников';
				|en = 'Список работников'"), 
			ПечатнаяФормаСписокРаботниковБронированиеКоторыхПрекращено(МассивОбъектов, ОбъектыПечати));
	ИначеЕсли УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПФ_MXL_ВыпискаИзПриказаОПрекращенииБронирования") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм, 
			"ПФ_MXL_ВыпискаИзПриказаОПрекращенииБронирования", 
			НСтр("ru = 'Выписка из приказа о прекращении бронирования';
				|en = 'Выписка из приказа о прекращении бронирования'"), 
			ПечатнаяФормаВыпискаИзПриказаОПрекращенииБронирования(МассивОбъектов, ОбъектыПечати));
	КонецЕсли;
	
КонецПроцедуры

Функция ПечатнаяФормаСписокРаботниковБронированиеКоторыхПрекращено(МассивОбъектов, ОбъектыПечати)
	
	ДокументРезультат = Новый ТабличныйДокумент;
	ДокументРезультат.КлючПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ЕФС_1";
	ДокументРезультат.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
	
	ВыборкаПоШапкеДокумента = ЗапросПоШапкеДляПечати(МассивОбъектов).Выбрать();
	ВыборкаПоРаботникам = ЗапросПоСотрудникамДляПечати(МассивОбъектов).Выбрать();
	
	Пока ВыборкаПоШапкеДокумента.СледующийПоЗначениюПоля("Ссылка") Цикл 
		
		Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.ПриказОПрекращенииБронирования.ПФ_MXL_СписокРаботниковБронированиеКоторыхПрекращено");
		
		НачалоФормы = ДокументРезультат.ВысотаТаблицы + 1;
		
		ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок");
		ОбластьШапка = Макет.ПолучитьОбласть("Шапка");
		ОбластьСтрокаТаблицы = Макет.ПолучитьОбласть("СтрокаТаблицы");
		ОбластьСубъектРФ = Макет.ПолучитьОбласть("СубъектРФ");
		ОбластьВоенкомат = Макет.ПолучитьОбласть("Военкомат");
		
		ОбластьЗаголовок.Параметры.ДатаПриказа = Формат(ВыборкаПоШапкеДокумента.Дата, "ДЛФ=Д");
		ОбластьЗаголовок.Параметры.НомерПриказа = ЗарплатаКадрыОтчеты.НомерНаПечать(ВыборкаПоШапкеДокумента.Номер);
		ОбластьЗаголовок.Параметры.НаименованиеОрганизации = ВыборкаПоШапкеДокумента.НаименованиеОрганизации;
		
		ДокументРезультат.Вывести(ОбластьЗаголовок);
		ДокументРезультат.Вывести(ОбластьШапка);
		
		ВыборкаПоРаботникам.Сбросить();
		
		Если ВыборкаПоРаботникам.НайтиСледующий(Новый Структура("Ссылка", ВыборкаПоШапкеДокумента.Ссылка)) Тогда
			
			НомерСтроки = 1;
			ВыборкаПоРаботникам.СледующийПоЗначениюПоля("Ссылка");
			
			Пока ВыборкаПоРаботникам.СледующийПоЗначениюПоля("СубъектРФ") Цикл
				
				ОбластьСубъектРФ.Параметры.НаименованиеСубъектаРФ = ВыборкаПоРаботникам.СубъектРФ;
				
				ВыводимыеОбласти = Новый Массив;
				ВыводимыеОбласти.Добавить(ОбластьСубъектРФ);
				
				Если Не ОбщегоНазначения.ПроверитьВыводТабличногоДокумента(ДокументРезультат, ВыводимыеОбласти) Тогда
					ДокументРезультат.ВывестиГоризонтальныйРазделительСтраниц();
				КонецЕсли;
				
				ДокументРезультат.Вывести(ОбластьСубъектРФ);
				
				Пока ВыборкаПоРаботникам.СледующийПоЗначениюПоля("Военкомат") Цикл 
					
					ОбластьВоенкомат.Параметры.НаименованиеВоенкомата = Строка(ВыборкаПоРаботникам.Военкомат); 
					ОбластьВоенкомат.Параметры.АдресВоенкомата = ВыборкаПоРаботникам.АдресВоенкомата; 
					
					ВыводимыеОбласти = Новый Массив;
					ВыводимыеОбласти.Добавить(ОбластьВоенкомат);
					
					Если Не ОбщегоНазначения.ПроверитьВыводТабличногоДокумента(ДокументРезультат, ВыводимыеОбласти) Тогда
						ДокументРезультат.ВывестиГоризонтальныйРазделительСтраниц();
					КонецЕсли;
					
					ДокументРезультат.Вывести(ОбластьВоенкомат);
					
					Пока ВыборкаПоРаботникам.Следующий() Цикл
						
						ПаспортныеДанные = "";
						Если ЗначениеЗаполнено(ВыборкаПоРаботникам.ДокументСерия) Тогда 
							ПаспортныеДанные = ВыборкаПоРаботникам.ДокументСерия;
						КонецЕсли;
						Если ЗначениеЗаполнено(ВыборкаПоРаботникам.ДокументНомер) Тогда 
							ПаспортныеДанные = ПаспортныеДанные + ?(ЗначениеЗаполнено(ПаспортныеДанные), " ", "") + ВыборкаПоРаботникам.ДокументНомер;
						КонецЕсли;
						Если ЗначениеЗаполнено(ВыборкаПоРаботникам.ДокументДатаВыдачи) Тогда 
							ПаспортныеДанные = ПаспортныеДанные + ?(ЗначениеЗаполнено(ПаспортныеДанные), ", ", "") + Формат(ВыборкаПоРаботникам.ДокументДатаВыдачи, "ДЛФ=Д");
						КонецЕсли;
						
			    		ЗаполнитьЗначенияСвойств(ОбластьСтрокаТаблицы.Параметры, ВыборкаПоРаботникам);
						ОбластьСтрокаТаблицы.Параметры.НомерСтроки = НомерСтроки;
						ОбластьСтрокаТаблицы.Параметры.ПаспортныеДанные = ПаспортныеДанные;
						
						ВыводимыеОбласти = Новый Массив;
						ВыводимыеОбласти.Добавить(ОбластьСтрокаТаблицы);
						
						Если Не ОбщегоНазначения.ПроверитьВыводТабличногоДокумента(ДокументРезультат, ВыводимыеОбласти) Тогда
							ДокументРезультат.ВывестиГоризонтальныйРазделительСтраниц();
						КонецЕсли;
						
						ДокументРезультат.Вывести(ОбластьСтрокаТаблицы);
						НомерСтроки = НомерСтроки + 1;
						
					КонецЦикла;
					
				КонецЦикла;
				
			КонецЦикла;
			
		КонецЕсли;
		
	    ДокументРезультат.ВывестиГоризонтальныйРазделительСтраниц();
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ДокументРезультат, НачалоФормы, ОбъектыПечати, ВыборкаПоШапкеДокумента.Ссылка);
		
	КонецЦикла;
	
	Возврат ДокументРезультат;
	
КонецФункции

Функция ПечатнаяФормаВыпискаИзПриказаОПрекращенииБронирования(МассивОбъектов, ОбъектыПечати)
	
	ДокументРезультат = Новый ТабличныйДокумент;
	ДокументРезультат.КлючПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ЕФС_1";
	ДокументРезультат.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
	
	ВыборкаПоШапкеДокумента = ЗапросПоШапкеДляПечати(МассивОбъектов).Выбрать();
	ВыборкаПоРаботникам = ЗапросПоСотрудникамДляПечати(МассивОбъектов).Выбрать();
	
	Пока ВыборкаПоШапкеДокумента.СледующийПоЗначениюПоля("Ссылка") Цикл 
		
		Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.ПриказОПрекращенииБронирования.ПФ_MXL_ВыпискаИзПриказаОПрекращенииБронирования");
		
		ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок");
		ОбластьШапка = Макет.ПолучитьОбласть("Шапка");
		ОбластьСтрокаТаблицы = Макет.ПолучитьОбласть("СтрокаТаблицы");
		ОбластьПодвал = Макет.ПолучитьОбласть("Подвал");
		
		ВыборкаПоРаботникам.Сбросить();
		
		Если ВыборкаПоРаботникам.НайтиСледующий(Новый Структура("Ссылка", ВыборкаПоШапкеДокумента.Ссылка)) Тогда
			
			ВыборкаПоРаботникам.СледующийПоЗначениюПоля("Ссылка");
			
			Пока ВыборкаПоРаботникам.СледующийПоЗначениюПоля("Военкомат") Цикл 
				
				ОбластьЗаголовок.Параметры.НаименованиеОрганизации = ВыборкаПоШапкеДокумента.НаименованиеОрганизации;
				Если ЗначениеЗаполнено(ВыборкаПоШапкеДокумента.ИНН) Тогда 
					ОбластьЗаголовок.Параметры.НаименованиеОрганизации = ВыборкаПоШапкеДокумента.НаименованиеОрганизации + НСтр("ru = ' ИНН ';
																																|en = ' ИНН '") + ВыборкаПоШапкеДокумента.ИНН;
				КонецЕсли;
				ОбластьЗаголовок.Параметры.НаименованиеВоенкомата = Строка(ВыборкаПоРаботникам.Военкомат);
				
				ДокументРезультат.Вывести(ОбластьЗаголовок);
				ДокументРезультат.Вывести(ОбластьШапка);
				
				НачалоФормы = ДокументРезультат.ВысотаТаблицы + 1;
				НомерСтроки = 1;
				
				Пока ВыборкаПоРаботникам.Следующий() Цикл
					
					ПаспортныеДанные = "";
					Если ЗначениеЗаполнено(ВыборкаПоРаботникам.ДокументСерия) Тогда 
						ПаспортныеДанные = ВыборкаПоРаботникам.ДокументСерия;
					КонецЕсли;
					Если ЗначениеЗаполнено(ВыборкаПоРаботникам.ДокументНомер) Тогда 
						ПаспортныеДанные = ПаспортныеДанные + ?(ЗначениеЗаполнено(ПаспортныеДанные), " ", "") + ВыборкаПоРаботникам.ДокументНомер;
					КонецЕсли;
					Если ЗначениеЗаполнено(ВыборкаПоРаботникам.ДокументДатаВыдачи) Тогда 
						ПаспортныеДанные = ПаспортныеДанные + ?(ЗначениеЗаполнено(ПаспортныеДанные), ", ", "") + Формат(ВыборкаПоРаботникам.ДокументДатаВыдачи, "ДЛФ=Д");
					КонецЕсли;
					
					ЗаполнитьЗначенияСвойств(ОбластьСтрокаТаблицы.Параметры, ВыборкаПоРаботникам);
					ОбластьСтрокаТаблицы.Параметры.НомерСтроки = НомерСтроки;
					ОбластьСтрокаТаблицы.Параметры.ПаспортныеДанные = ПаспортныеДанные;
					
					ВыводимыеОбласти = Новый Массив;
					ВыводимыеОбласти.Добавить(ОбластьСтрокаТаблицы);
					
					Если Не ОбщегоНазначения.ПроверитьВыводТабличногоДокумента(ДокументРезультат, ВыводимыеОбласти) Тогда
						ДокументРезультат.ВывестиГоризонтальныйРазделительСтраниц();
					КонецЕсли;
					
					ДокументРезультат.Вывести(ОбластьСтрокаТаблицы);
					НомерСтроки = НомерСтроки + 1;
					
				КонецЦикла;
				
				ЗаполнитьЗначенияСвойств(ОбластьПодвал.Параметры, ВыборкаПоШапкеДокумента);
				ОбластьПодвал.Параметры.ДатаПриказа = Формат(ВыборкаПоШапкеДокумента.Дата, "ДЛФ=Д");
				
				ВыводимыеОбласти = Новый Массив;
				ВыводимыеОбласти.Добавить(ОбластьПодвал);
				
				Если Не ОбщегоНазначения.ПроверитьВыводТабличногоДокумента(ДокументРезультат, ВыводимыеОбласти) Тогда
					ДокументРезультат.ВывестиГоризонтальныйРазделительСтраниц();
				КонецЕсли;
				
				ДокументРезультат.Вывести(ОбластьПодвал);
				
				ДокументРезультат.ВывестиГоризонтальныйРазделительСтраниц();
				УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ДокументРезультат, НачалоФормы, ОбъектыПечати, ВыборкаПоШапкеДокумента.Ссылка);
				
			КонецЦикла; 
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ДокументРезультат;
	
КонецФункции

Функция ЗапросПоШапкеДляПечати(МассивСсылок)
	
	Запрос = Новый Запрос;
	
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("МассивСсылок", МассивСсылок);
	
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ПриказОПрекращенииБронирования.Дата КАК Дата,
		|	ПриказОПрекращенииБронирования.Номер КАК Номер,
		|	ПриказОПрекращенииБронирования.Организация КАК Организация,
		|	ПриказОПрекращенииБронирования.Ссылка КАК Ссылка,
		|	ПриказОПрекращенииБронирования.Руководитель КАК Руководитель,
		|	ПриказОПрекращенииБронирования.ДолжностьРуководителя КАК ДолжностьРуководителя
		|ПОМЕСТИТЬ ВТДанныеДокументов
		|ИЗ
		|	Документ.ПриказОПрекращенииБронирования КАК ПриказОПрекращенииБронирования
		|ГДЕ
		|	ПриказОПрекращенииБронирования.Ссылка В(&МассивСсылок)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ДанныеДокументов.Организация КАК СтруктурнаяЕдиница,
		|	ДанныеДокументов.Дата КАК Период
		|ПОМЕСТИТЬ ВТОрганизацииПериоды
		|ИЗ
		|	ВТДанныеДокументов КАК ДанныеДокументов";
	
	Запрос.Выполнить();
	
	ИменаПолейОтветственныхЛиц = Новый Массив;
	ИменаПолейОтветственныхЛиц.Добавить("Руководитель");
	ЗарплатаКадры.СоздатьВТФИООтветственныхЛиц(Запрос.МенеджерВременныхТаблиц, Истина, ИменаПолейОтветственныхЛиц, "ВТДанныеДокументов");
	
	ЗарплатаКадрыОбщиеНаборыДанных.СоздатьВТИмяРегистраСрезПоследних(
		"ИсторияРегистрацийВНалоговомОргане",
		Запрос.МенеджерВременныхТаблиц,
		Истина,
		ЗарплатаКадрыОбщиеНаборыДанных.ОписаниеФильтраДляСоздатьВТИмяРегистра(
			"ВТОрганизацииПериоды",
			"СтруктурнаяЕдиница"));
	
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ДанныеДокументов.Дата КАК Дата,
		|	ДанныеДокументов.Номер КАК Номер,
		|	ДанныеДокументов.Организация КАК Организация,
		|	ДанныеДокументов.Ссылка КАК Ссылка,
		|	ДанныеДокументов.Руководитель КАК Руководитель,
		|	ДанныеДокументов.ДолжностьРуководителя КАК ДолжностьРуководителя,
		|	ВЫБОР
		|		КОГДА ПОДСТРОКА(Организации.НаименованиеПолное, 1, 10) <> """"
		|			ТОГДА Организации.НаименованиеПолное
		|		ИНАЧЕ Организации.Наименование
		|	КОНЕЦ КАК НаименованиеОрганизации,
		|	Организации.НаименованиеПолное КАК НаименованиеПолное,
		|	Организации.НаименованиеСокращенное КАК НаименованиеСокращенное,
		|	Организации.ИНН КАК ИНН,
		|	ИсторияРегистрацийВНалоговомОрганеСрезПоследних.Период КАК ПериодРегистрации,
		|	ЕСТЬNULL(РегистрацииВНалоговомОргане.Ссылка, ЗНАЧЕНИЕ(Справочник.РегистрацииВНалоговомОргане.ПустаяСсылка)) КАК РегистрацияВНалоговомОргане,
		|	ЕСТЬNULL(РегистрацииВНалоговомОргане.КПП, """") КАК КПП,
		|	ЕСТЬNULL(РегистрацииВНалоговомОргане.НаименованиеИФНС, """") КАК НаименованиеИФНС,
		|	ЕСТЬNULL(РегистрацииВНалоговомОргане.КодПоОКАТО, """") КАК ОКАТО,
		|	ФИООтветственныхЛиц.РасшифровкаПодписи КАК РуководительРасшифровкаПодписи
		|ИЗ
		|	ВТДанныеДокументов КАК ДанныеДокументов
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Организации КАК Организации
		|		ПО ДанныеДокументов.Организация = Организации.Ссылка
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТФИООтветственныхЛиц КАК ФИООтветственныхЛиц
		|		ПО ДанныеДокументов.Руководитель = ФИООтветственныхЛиц.ФизическоеЛицо
		|			И ДанныеДокументов.Ссылка = ФИООтветственныхЛиц.Ссылка
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТИсторияРегистрацийВНалоговомОрганеСрезПоследних КАК ИсторияРегистрацийВНалоговомОрганеСрезПоследних
		|			ЛЕВОЕ СОЕДИНЕНИЕ Справочник.РегистрацииВНалоговомОргане КАК РегистрацииВНалоговомОргане
		|			ПО ИсторияРегистрацийВНалоговомОрганеСрезПоследних.РегистрацияВНалоговомОргане = РегистрацииВНалоговомОргане.Ссылка
		|		ПО ДанныеДокументов.Организация = ИсторияРегистрацийВНалоговомОрганеСрезПоследних.СтруктурнаяЕдиница
		|			И ДанныеДокументов.Дата = ИсторияРегистрацийВНалоговомОрганеСрезПоследних.Период
		|
		|УПОРЯДОЧИТЬ ПО
		|	ДанныеДокументов.Дата,
		|	Ссылка";
	
	Возврат Запрос.Выполнить();
	
КонецФункции

Функция ЗапросПоСотрудникамДляПечати(МассивСсылок)
	
	Запрос = Новый Запрос;
	
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("МассивСсылок", МассивСсылок);
	
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	Сотрудники.Ссылка КАК Ссылка,
		|	Сотрудники.НомерСтроки КАК НомерСтроки,
		|	Сотрудники.Сотрудник КАК Сотрудник,
		|	Сотрудники.Сотрудник.Наименование КАК ФИОПолные,
		|	Сотрудники.Пол КАК Пол,
		|	Сотрудники.ДатаРождения КАК ДатаРождения,
		|	Сотрудники.ДокументСерия КАК ДокументСерия,
		|	Сотрудники.ДокументНомер КАК ДокументНомер,
		|	Сотрудники.ДокументДатаВыдачи КАК ДокументДатаВыдачи,
		|	Сотрудники.СтраховойНомерПФР КАК СтраховойНомерПФР,
		|	Сотрудники.Военкомат КАК Военкомат,
		|	Сотрудники.ВУС КАК ВУС,
		|	Сотрудники.Примечание КАК Примечание
		|ПОМЕСТИТЬ ВТДанныеДокументов
		|ИЗ
		|	Документ.ПриказОПрекращенииБронирования.Сотрудники КАК Сотрудники
		|ГДЕ
		|	Сотрудники.Ссылка В(&МассивСсылок)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ДанныеДокументов.Военкомат КАК Военкомат
		|ПОМЕСТИТЬ ВТВоенкоматыДокумента
		|ИЗ
		|	ВТДанныеДокументов КАК ДанныеДокументов
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ВоенкоматыДокумента.Военкомат КАК Военкомат,
		|	Военкоматы.АдресВнутреннееПредставление КАК Адрес
		|ИЗ
		|	ВТВоенкоматыДокумента КАК ВоенкоматыДокумента
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Военкоматы КАК Военкоматы
		|		ПО ВоенкоматыДокумента.Военкомат = Военкоматы.Ссылка";
	
	РегионыВоенкоматов = Новый ТаблицаЗначений;
	РегионыВоенкоматов.Колонки.Добавить("Военкомат", Новый ОписаниеТипов("СправочникСсылка.Военкоматы"));
	РегионыВоенкоматов.Колонки.Добавить("СубъектРФ", Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(100)));
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ДанныеВоенкомата = РегионыВоенкоматов.Добавить();
		ДанныеВоенкомата.Военкомат = Выборка.Военкомат;
		Если ЗначениеЗаполнено(Выборка.Адрес) Тогда 
			ДанныеВоенкомата.СубъектРФ = РаботаСАдресами.РегионАдресаКонтактнойИнформации(Выборка.Адрес);
		КонецЕсли;
	КонецЦикла;
	
	Запрос.УстановитьПараметр("РегионыВоенкоматов", РегионыВоенкоматов);
	
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	РегионыВоенкоматов.Военкомат КАК Военкомат,
		|	РегионыВоенкоматов.СубъектРФ КАК СубъектРФ
		|ПОМЕСТИТЬ ВТРегионыВоенкоматов
		|ИЗ
		|	&РегионыВоенкоматов КАК РегионыВоенкоматов
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ДанныеДокументов.Ссылка КАК Ссылка,
		|	ДанныеДокументов.Сотрудник КАК Сотрудник,
		|	ДанныеДокументов.Сотрудник.Наименование КАК ФИОПолные,
		|	ДанныеДокументов.Пол КАК Пол,
		|	ДанныеДокументов.ДатаРождения КАК ДатаРождения,
		|	ДанныеДокументов.ДокументСерия КАК ДокументСерия,
		|	ДанныеДокументов.ДокументНомер КАК ДокументНомер,
		|	ДанныеДокументов.ДокументДатаВыдачи КАК ДокументДатаВыдачи,
		|	ДанныеДокументов.СтраховойНомерПФР КАК СтраховойНомерПФР,
		|	ЕСТЬNULL(РегионыВоенкоматов.СубъектРФ, """") КАК СубъектРФ,
		|	ДанныеДокументов.Военкомат КАК Военкомат,
		|	Военкоматы.Адрес КАК АдресВоенкомата,
		|	ДанныеДокументов.ВУС КАК ВУС,
		|	ДанныеДокументов.Примечание КАК Примечание
		|ИЗ
		|	ВТДанныеДокументов КАК ДанныеДокументов
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТРегионыВоенкоматов КАК РегионыВоенкоматов
		|		ПО ДанныеДокументов.Военкомат = РегионыВоенкоматов.Военкомат
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Военкоматы КАК Военкоматы
		|		ПО ДанныеДокументов.Военкомат = Военкоматы.Ссылка
		|
		|УПОРЯДОЧИТЬ ПО
		|	Ссылка,
		|	СубъектРФ,
		|	Военкомат,
		|	ДанныеДокументов.НомерСтроки";
	
	Возврат Запрос.Выполнить();
	
КонецФункции

#КонецОбласти

#КонецЕсли