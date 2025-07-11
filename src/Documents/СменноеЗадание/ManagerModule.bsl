#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс

// Конструктор структуры, которая используется для заполнения новых документов.
// 
// Возвращаемое значение:
//  Структура - структура с ключами:
//		* Дата - Дата -
//		* Подразделение - СправочникСсылка.СтруктураПредприятия -
//		* Смена - СправочникСсылка.Календари -
//		* ЗаполнитьИсполнителейИзПрошлойСмены - Булево -
//
Функция ДанныеЗаполнения() Экспорт
	
	Результат = Новый Структура;
	
	Результат.Вставить("Дата");
	Результат.Вставить("Подразделение");
	Результат.Вставить("Смена");
	Результат.Вставить("Участок");
	Результат.Вставить("ЗаполнитьИсполнителейИзПрошлойСмены", Ложь);
	
	Возврат Результат;
	
КонецФункции

// Создает и заполняет новые документы.
//
// Параметры:
//  МассивДанныхЗаполнения - Массив - массив с данными заполнения (см. ДанныеЗаполнения).
// 
// Возвращаемое значение:
//  Массив из ДокументСсылка.СменноеЗадание - ссылки на созданные документы.
//
Функция СоздатьЗадания(МассивДанныхЗаполнения) Экспорт
	
	Ссылки = Новый Массив;
		
	НачатьТранзакцию();
	
	Попытка
		
		Для каждого ДанныеЗаполнения Из МассивДанныхЗаполнения Цикл
			
			Объект = Документы.СменноеЗадание.СоздатьДокумент();
			
			Объект.Заполнить(ДанныеЗаполнения);
			
			Объект.Записать(РежимЗаписиДокумента.Проведение);
			
			Ссылки.Добавить(Объект.Ссылка);
			
		КонецЦикла;
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		
		ЗаписьЖурналаРегистрации(
			НСтр("ru = 'Сменные задания';
				|en = 'Shift tasks'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка,
			Метаданные.Документы.СменноеЗадание,,
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		
		ВызватьИсключение НСтр("ru = 'Не удалось создать сменные задания';
								|en = 'Cannot create shift tasks'");
		
	КонецПопытки;
	
	Возврат Ссылки;
	
КонецФункции

// Добавляет нового исполнителя в документ.
//
// Параметры:
//  Ссылка		 - ДокументСсылка.СменноеЗадание - ссылка на документ.
//  Исполнители	 - Массив - значения с типом СправочникСсылка.Бригады, СправочникСсылка.ФизическиеЛица.
//
Процедура ДобавитьИсполнителей(Ссылка, Исполнители) Экспорт
	
	Попытка
		
		Объект = Ссылка.ПолучитьОбъект();
		Объект.Заблокировать();
		
		Для каждого Исполнитель Из Исполнители Цикл
			Объект.Исполнители.Добавить().Исполнитель = Исполнитель;
		КонецЦикла;
		
		Объект.Записать(РежимЗаписиДокумента.Запись);
		
	Исключение
		
		ЗаписьЖурналаРегистрации(
			НСтр("ru = 'Сменные задания';
				|en = 'Shift tasks'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка,
			Ссылка.Метаданные(),
			Ссылка,
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		
		ВызватьИсключение СтрШаблон(НСтр("ru = 'Не удалось добавить исполнителей в документ %1';
										|en = 'Cannot add assignees to the %1 document'"), Ссылка);
		
	КонецПопытки;
	
КонецПроцедуры

// Удаляет исполнителя из документа.
//
// Параметры:
//  Ссылка		 - ДокументСсылка.СменноеЗадание - ссылка на документ.
//  Исполнитель	 - СправочникСсылка.Бригады, СправочникСсылка.ФизическиеЛица - исполнитель.
//
Процедура УдалитьИсполнителя(Ссылка, Исполнитель) Экспорт
	
	Попытка
		
		Объект = Ссылка.ПолучитьОбъект();
		Объект.Заблокировать();
		
		Строка = Объект.Исполнители.Найти(Исполнитель, "Исполнитель");
		
		Если Строка <> Неопределено Тогда
			
			Объект.Исполнители.Удалить(Строка);
			Объект.Записать(РежимЗаписиДокумента.Запись);
			
		КонецЕсли;
		
	Исключение
		
		ЗаписьЖурналаРегистрации(
			НСтр("ru = 'Сменные задания';
				|en = 'Shift tasks'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка,
			Ссылка.Метаданные(),
			Ссылка,
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		
		ВызватьИсключение СтрШаблон(НСтр("ru = 'Не удалось удалить исполнителя из документа %1';
										|en = 'Cannot delete an assignee from the %1 document'"), Ссылка);
		
	КонецПопытки;
	
КонецПроцедуры

// Устанавливает статус документу
//
// Параметры:
//		Ссылка - ДокументСсылка.СменноеЗадание - ссылка на документ
//		Статус - ПеречислениеСсылка.СтатусыСменныхЗаданий - статус
//
Процедура УстановитьСтатус(Ссылка, Статус) Экспорт
	
	ОписаниеЗамера = ОценкаПроизводительности.НачатьЗамерДлительнойОперации("Документ.СменноеЗадание.УстановитьСтатус");
	
	УстановитьСтатусВнутриЗамераВремени(Ссылка, Статус);
	
	ОценкаПроизводительности.ЗакончитьЗамерДлительнойОперации(ОписаниеЗамера, КоличествоОпераций(Ссылка, Статус));
	
КонецПроцедуры

#Область Команды

// Определяет список команд создания на основании.
//
// Параметры:
//  КомандыСозданияНаОсновании - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
//  Параметры - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.Параметры
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСозданияНаОсновании, Параметры) Экспорт
	
	Команда = Документы.ВыработкаСотрудников.ДобавитьКомандуСоздатьНаОснованииСозданиеВыработкиСотрудников(КомандыСозданияНаОсновании);
	Если Команда = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.ИмяФормы = "Документ.СменноеЗадание.Форма.ФормаДокумента" 
		Или Параметры.ИмяФормы = "Обработка.ФормированиеСменныхЗаданий.РабочееМесто" Тогда

			Команда.ТипПараметра = Новый ОписаниеТипов ("ДокументСсылка.СменноеЗадание, ДокументСсылка.ПроизводственнаяОперация2_2");
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СтандартныеПодсистемы

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

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
	|	ЗначениеРазрешено(Подразделение)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

// СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

// Возвращает реквизиты объекта, которые не рекомендуется редактировать
// с помощью обработки группового изменения реквизитов.
//
// Возвращаемое значение:
//  Массив из Строка
//
Функция РеквизитыНеРедактируемыеВГрупповойОбработке() Экспорт
	
	НеРедактируемыеРеквизиты = Новый Массив;
	НеРедактируемыеРеквизиты.Добавить("Статус");
	НеРедактируемыеРеквизиты.Добавить("Подразделение");
	НеРедактируемыеРеквизиты.Добавить("Участок");
	НеРедактируемыеРеквизиты.Добавить("Смена");
	
	Возврат НеРедактируемыеРеквизиты;
	
КонецФункции

// Конец СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - см. УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	// Сменное задание
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "СменноеЗадание";
	КомандаПечати.Представление = НСтр("ru = 'Сменное задание';
										|en = 'Shift task'");
	КомандаПечати.ПроверкаПроведенияПередПечатью = Ложь;
	КомандаПечати.Порядок = 1;
	
	// Сменное задание по исполнителям
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "СменноеЗаданиеПоИсполнителям";
	КомандаПечати.Представление = НСтр("ru = 'Сменное задание (по исполнителям)';
										|en = 'Shift task (by assignees)'");
	КомандаПечати.ПроверкаПроведенияПередПечатью = Ложь;
	КомандаПечати.Порядок = 2;
	
	// Сменное задание по рабочим центрам
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "СменноеЗаданиеПоРабочимЦентрам";
	КомандаПечати.Представление = НСтр("ru = 'Сменное задание (по рабочим центрам)';
										|en = 'Shift task (by work centers)'");
	КомандаПечати.ПроверкаПроведенияПередПечатью = Ложь;
	КомандаПечати.Порядок = 3;
	
КонецПроцедуры

// Формирует печатные формы.
//
// Параметры:
//  МассивОбъектов - см. УправлениеПечатьюПереопределяемый.ПриПечати.МассивОбъектов
//  ПараметрыПечати - см. УправлениеПечатьюПереопределяемый.ПриПечати.ПараметрыПечати
//  КоллекцияПечатныхФорм - см. УправлениеПечатьюПереопределяемый.ПриПечати.КоллекцияПечатныхФорм
//  ОбъектыПечати - см. УправлениеПечатьюПереопределяемый.ПриПечати.ОбъектыПечати
//  ПараметрыВывода - см. УправлениеПечатьюПереопределяемый.ПриПечати.ПараметрыВывода
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "СменноеЗадание") Тогда
		
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм,
			"СменноеЗадание",
			НСтр("ru = 'Сменное задание';
				|en = 'Shift task'"),
			СформироватьПечатнуюФормуСменноеЗадание(МассивОбъектов, ОбъектыПечати, ПараметрыПечати));
		
	КонецЕсли;
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "СменноеЗаданиеПоИсполнителям") Тогда
		
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм,
			"СменноеЗаданиеПоИсполнителям",
			НСтр("ru = 'Сменное задание (по исполнителям)';
				|en = 'Shift task (by assignees)'"),
			СформироватьПечатнуюФормуСменноеЗадание(МассивОбъектов, ОбъектыПечати, ПараметрыПечати, "Исполнитель"));
		
	КонецЕсли;
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "СменноеЗаданиеПоРабочимЦентрам") Тогда
		
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм,
			"СменноеЗаданиеПоРабочимЦентрам",
			НСтр("ru = 'Сменное задание (по рабочим центрам)';
				|en = 'Shift task (by work centers)'"),
			СформироватьПечатнуюФормуСменноеЗадание(МассивОбъектов, ОбъектыПечати, ПараметрыПечати, "РабочийЦентр"));
		
	КонецЕсли;
	
	ФормированиеПечатныхФорм.ЗаполнитьПараметрыОтправки(
		ПараметрыВывода.ПараметрыОтправки,
		МассивОбъектов,
		КоллекцияПечатныхФорм);	
	
КонецПроцедуры

Функция СформироватьПечатнуюФормуСменноеЗадание(МассивОбъектов, ОбъектыПечати, ПараметрыПечати, ВариантГруппировки="")
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.АвтоМасштаб = Истина;
	ТабличныйДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
	ТабличныйДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_СменноеЗадание"+ВариантГруппировки;
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.СменноеЗадание.ПФ_MXL_СменноеЗадание");
	
	Таблица = СменноеЗаданиеДанныеПечатнойФормы(МассивОбъектов, ВариантГруппировки);
	НомерСтроки = 0;
	ВариантГруппировкиОбратный = ?(ПустаяСтрока(ВариантГруппировки),
		"",
		?(ВариантГруппировки = "Исполнитель", "РабочийЦентр", "Исполнитель"));
	
	Для Индекс = 0 По Таблица.Количество()-1 Цикл
		
		Строка = Таблица[Индекс];
		
		Если Индекс = 0
			ИЛИ Строка.Ссылка <> Таблица[Индекс-1].Ссылка
			ИЛИ НЕ ПустаяСтрока(ВариантГруппировки) И Строка[ВариантГруппировки] <> Таблица[Индекс-1][ВариантГруппировки] Тогда
			
			Если Индекс <> 0 Тогда
				ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
			КонецЕсли;
			
			НомерСтроки = 0;
			
			Формируется = Строка.Статус = Перечисления.СтатусыСменныхЗаданий.Формируется;
			ИменаОбластей = ИменаОбластей(НЕ ПустаяСтрока(ВариантГруппировки), Формируется);
			
			// Заголовок
			Область = Макет.ПолучитьОбласть("Заголовок");
	    	Область.Параметры.Номер = ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(Строка.Номер, Ложь, Истина);
			Область.Параметры.Дата	= Формат(Строка.Дата, "ДЛФ=D");
			
			ШтрихкодированиеПечатныхФорм.ВывестиШтрихкодВТабличныйДокумент(
				ТабличныйДокумент, Макет, Область, Строка.Ссылка);
			
			ТабличныйДокумент.Вывести(Область);
			
	    	// Шапка
			Если ПустаяСтрока(ВариантГруппировки) Тогда
				Область = Макет.ПолучитьОбласть("Шапка");
			Иначе
				Область = Макет.ПолучитьОбласть("ШапкаСГруппировкой");
				Область.Параметры.Группировка = ?(ВариантГруппировки = "Исполнитель",
					НСтр("ru = 'Исполнитель:';
						|en = 'Assignee:'", ОбщегоНазначения.КодОсновногоЯзыка()),
					НСтр("ru = 'Рабочий центр:';
						|en = 'Work center:'", ОбщегоНазначения.КодОсновногоЯзыка()));
				Область.Параметры.ЗначениеГруппировки = Строка[ВариантГруппировки];
				Область.Параметры.ЗначениеГруппировкиПредставление = Строка[ПредставлениеВариантаГруппировки(ВариантГруппировки)];
			КонецЕсли;
			
			Область.Параметры.Заполнить(Строка);
	    	ТабличныйДокумент.Вывести(Область);
	
			// Шапка таблицы
			Область = Макет.ПолучитьОбласть(ИменаОбластей.ШапкаТаблицы);
			Если НЕ ПустаяСтрока(ВариантГруппировки) Тогда
				Область.Параметры.Группировка = ?(ВариантГруппировки = "Исполнитель",
					НСтр("ru = 'Рабочий центр:';
						|en = 'Work center:'", ОбщегоНазначения.КодОсновногоЯзыка()),
					НСтр("ru = 'Исполнитель:';
						|en = 'Assignee:'", ОбщегоНазначения.КодОсновногоЯзыка()));
			КонецЕсли;
		
			ТабличныйДокумент.Вывести(Область);
			
		КонецЕсли;
		
		// Строка
		Если Строка.ЕстьОперация Тогда
			
			НомерСтроки = НомерСтроки + 1;
			Область = Макет.ПолучитьОбласть(ИменаОбластей.СтрокаТаблицы);
			
			Область.Параметры.Заполнить(Строка);
			Область.Параметры.НомерСтроки = НомерСтроки;
			Если ЗначениеЗаполнено(ВариантГруппировки) Тогда
				Область.Параметры.ЗначениеГруппировки = Строка[ВариантГруппировкиОбратный];
				Область.Параметры.ЗначениеГруппировкиПредставление = Строка[ПредставлениеВариантаГруппировки(ВариантГруппировкиОбратный)];
			КонецЕсли;
			
			ТабличныйДокумент.Вывести(Область);
			
		КонецЕсли;
		
		// Подвал
		Если Индекс = Таблица.Количество()-1
			ИЛИ Строка.Ссылка <> Таблица[Индекс+1].Ссылка
			ИЛИ НЕ ПустаяСтрока(ВариантГруппировки) И Строка[ВариантГруппировки] <> Таблица[Индекс+1][ВариантГруппировки] Тогда
			
			ТабличныйДокумент.Вывести(Макет.ПолучитьОбласть("ПодвалТаблицы"));
			
		КонецЕсли;
		
	КонецЦикла;
	
	Если ПривилегированныйРежим() Тогда
		УстановитьПривилегированныйРежим(Ложь);
	КонецЕсли;
		
	Возврат ТабличныйДокумент;
		
КонецФункции

Функция ПредставлениеВариантаГруппировки(ВариантГруппировки)
	
	Если ВариантГруппировки = "Исполнитель" Тогда
		Возврат "ИсполнительПредставление"
	ИначеЕсли ВариантГруппировки = "РабочийЦентр" Тогда
		Возврат "РабочийЦентрПредставление"
	Иначе
		Возврат "Представление"
	КонецЕсли;
	
КонецФункции

Функция ИменаОбластей(Группировка, Формируется)
	
	СтруктураВозврата = Новый Структура("СтрокаТаблицы, ШапкаТаблицы");
	Если Группировка И Формируется Тогда
		СтруктураВозврата.СтрокаТаблицы = "СтрокаТаблицыГруппировкаФормируется";
		СтруктураВозврата.ШапкаТаблицы = "ШапкаТаблицыГруппировкаФормируется";
	ИначеЕсли Не Группировка И Формируется Тогда
		СтруктураВозврата.СтрокаТаблицы = "СтрокаТаблицыФормируется";
		СтруктураВозврата.ШапкаТаблицы = "ШапкаТаблицыФормируется";
	ИначеЕсли Группировка И Не Формируется Тогда
		СтруктураВозврата.СтрокаТаблицы = "СтрокаТаблицыГруппировка";
		СтруктураВозврата.ШапкаТаблицы = "ШапкаТаблицыГруппировка";
	Иначе
		СтруктураВозврата.СтрокаТаблицы = "СтрокаТаблицы";
		СтруктураВозврата.ШапкаТаблицы = "ШапкаТаблицы";
	КонецЕсли;
	
	Возврат СтруктураВозврата;
	
КонецФункции

// Возвращает данные для формирования печатной формы.
//
// Параметры:
//  МассивОбъектов - Массив - Массив ссылок на объекты которые нужно распечатать.
//  ВариантГруппировки - Строка - Имя реквизита для группировки данных.
//
// Возвращаемое значение:
//  ТаблицаЗначений - где:
//   * Ссылка - ДокументСсылка.СменноеЗадание -
//
Функция СменноеЗаданиеДанныеПечатнойФормы(МассивОбъектов, ВариантГруппировки)
	
	ТекстЗапроса = 
		"ВЫБРАТЬ
		|	Задание.Ссылка                      КАК Ссылка,
		|	Задание.Номер                       КАК Номер,
		|	Задание.Дата                        КАК Дата,
		|	Задание.Статус                      КАК Статус,
		|	Задание.Подразделение               КАК Подразделение,
		|	Задание.Подразделение.Представление КАК ПодразделениеПредставление,
		|	Задание.Смена                       КАК Смена,
		|	Задание.Смена.Представление         КАК СменаПредставление,
		|
		|	ЕСТЬNULL(Операции.РабочийЦентр, ЗНАЧЕНИЕ(Справочник.РабочиеЦентры.ПустаяСсылка)) КАК РабочийЦентр,
		|	ЕСТЬNULL(Операции.РабочийЦентр.Представление, """")                              КАК РабочийЦентрПредставление,
		|
		|	ВЫБОР
		|		КОГДА Операции.Исполнитель ЕСТЬ NULL
		|			ИЛИ Операции.Исполнитель В (НЕОПРЕДЕЛЕНО, ЗНАЧЕНИЕ(Справочник.Бригады.ПустаяСсылка))
		|			ТОГДА ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка)
		|		ИНАЧЕ Операции.Исполнитель
		|	КОНЕЦ                            КАК Исполнитель,
		|	ВЫБОР
		|		КОГДА Операции.Исполнитель ЕСТЬ NULL
		|			ИЛИ Операции.Исполнитель В (НЕОПРЕДЕЛЕНО, ЗНАЧЕНИЕ(Справочник.Бригады.ПустаяСсылка))
		|			ТОГДА """"
		|		ИНАЧЕ Операции.Исполнитель.Представление
		|	КОНЕЦ                            КАК ИсполнительПредставление,
		|
		|	НЕ Операции.Ссылка ЕСТЬ NULL     КАК ЕстьОперация,
		|
		|	Операции.Операция                КАК Операция,
		|	Операции.Наименование            КАК ОперацияПредставление,
		|	Операции.ВремяВыполнения         КАК Время,
		|	Операции.ВремяВыполненияЕдИзм    КАК ВремяЕдиницаИзмерения,
		|	Операции.Ссылка                  КАК ПроизводственнаяОперацияСсылка,
		|	Операции.Номер                   КАК ПроизводственнаяОперацияНомер,
		|
		|	Операции.Количество - Операции.КоличествоОтменено КАК КоличествоПлан,
		|	Операции.КоличествоФакт                           КАК КоличествоФакт
		|ИЗ
		|	Документ.СменноеЗадание КАК Задание
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ПроизводственнаяОперация2_2 КАК Операции
		|		ПО Задание.Ссылка = Операции.СменноеЗадание
		|ГДЕ
		|	Задание.Ссылка В(&МассивОбъектов)
		|	И Задание.Статус <> &СтатусФормируется
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	Задание.Ссылка,
		|	Задание.Номер,
		|	Задание.Дата,
		|	Задание.Статус,
		|	Задание.Подразделение,
		|	Задание.Подразделение.Представление,
		|	Задание.Смена,
		|	Задание.Смена.Представление,
		|
		|	ЕСТЬNULL(Операции.РабочийЦентр, ЗНАЧЕНИЕ(Справочник.РабочиеЦентры.ПустаяСсылка)),
		|	ЕСТЬNULL(Операции.РабочийЦентр.Представление, """"),
		|
		|	ВЫБОР
		|		КОГДА Операции.Исполнитель ЕСТЬ NULL
		|			ИЛИ Операции.Исполнитель В (НЕОПРЕДЕЛЕНО, ЗНАЧЕНИЕ(Справочник.Бригады.ПустаяСсылка))
		|			ТОГДА ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка)
		|		ИНАЧЕ Операции.Исполнитель
		|	КОНЕЦ,
		|	ВЫБОР
		|		КОГДА Операции.Исполнитель ЕСТЬ NULL
		|			ИЛИ Операции.Исполнитель В (НЕОПРЕДЕЛЕНО, ЗНАЧЕНИЕ(Справочник.Бригады.ПустаяСсылка))
		|			ТОГДА """"
		|		ИНАЧЕ Операции.Исполнитель.Представление
		|	КОНЕЦ,
		|
		|	НЕ Операции.Операция ЕСТЬ NULL,
		|
		|	Операции.Операция,
		|	Операции.Операция.Представление,
		|	&ОперацииВремяВыполнения,
		|	Операции.ВремяЕдИзм,
		|	Операции.Количество,
		|	0,
		|	НЕОПРЕДЕЛЕНО,
		|	НЕОПРЕДЕЛЕНО
		|ИЗ
		|	Документ.СменноеЗадание КАК Задание
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ОперацииКСозданиюСменныхЗаданий КАК Операции
		|		ПО Задание.Ссылка = Операции.СменноеЗадание
		|ГДЕ
		|	Задание.Ссылка В(&МассивОбъектов)
		|	И Задание.Статус = &СтатусФормируется";
	
	Если ПустаяСтрока(ВариантГруппировки) Тогда
		ТекстЗапроса = ТекстЗапроса + " УПОРЯДОЧИТЬ ПО Ссылка, Операция АВТОУПОРЯДОЧИВАНИЕ";
	Иначе
		ТекстЗапроса = ТекстЗапроса + " УПОРЯДОЧИТЬ ПО Ссылка, " + ВариантГруппировки + ", Операция АВТОУПОРЯДОЧИВАНИЕ";
	КонецЕсли;
	
	ТекстЗапроса = СтрЗаменить(
		ТекстЗапроса,
		"&ОперацииВремяВыполнения",
		РегистрыСведений.ОперацииКСозданиюСменныхЗаданий.ТекстЗапросаВремяОперации("Операции"));
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	Запрос.УстановитьПараметр("СтатусФормируется", Перечисления.СтатусыСменныхЗаданий.Формируется);	
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

#КонецОбласти

#Область Прочее

// Параметры:
// 	Параметры - Структура - 
// 	АдресХранилища - УникальныйИдентификатор - 
Процедура УстановитьСтатусВФоне(Параметры, АдресХранилища) Экспорт
	
	Попытка
		
		УстановитьСтатус(Параметры.Ссылка, Параметры.Статус);
		
	Исключение
		
		ПоместитьВоВременноеХранилище(
			Новый Структура("Сообщения", ПолучитьСообщенияПользователю()),
			АдресХранилища);
		
		ВызватьИсключение КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
		
	КонецПопытки;
	
КонецПроцедуры

Процедура УстановитьСтатусВнутриЗамераВремени(Ссылка, Статус)
	
	НачатьТранзакцию();
	
	Попытка
		
		БлокировкаДанных = Новый БлокировкаДанных;
		
		ЭлементБлокировки = БлокировкаДанных.Добавить("Документ.СменноеЗадание");
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
		ЭлементБлокировки.УстановитьЗначение("Ссылка", Ссылка);
		
		ЭлементБлокировки = БлокировкаДанных.Добавить("Документ.ПроизводственнаяОперация2_2");
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
		ЭлементБлокировки.УстановитьЗначение("СменноеЗадание", Ссылка);
		
		БлокировкаДанных.Заблокировать();
		
		// Установка статуса
		Объект = Ссылка.ПолучитьОбъект();
		Объект.Заблокировать();
		Объект.Статус = Статус;
		Объект.Записать();
		
		// Изменение регистра и производственных операций
		Если Статус = Перечисления.СтатусыСменныхЗаданий.Формируется Тогда
			
			РегистрыСведений.ОперацииКСозданиюСменныхЗаданий.ДокументыВРегистр(
				Ссылка);
			
		ИначеЕсли Статус = Перечисления.СтатусыСменныхЗаданий.Сформировано Тогда
			
			РегистрыСведений.ОперацииКСозданиюСменныхЗаданий.РегистрВДокументы(
				Ссылка,
				Перечисления.СтатусыПроизводственныхОпераций.Создана);
			
		ИначеЕсли Статус = Перечисления.СтатусыСменныхЗаданий.Закрыто Тогда
			
			РегистрыСведений.ОперацииКСозданиюСменныхЗаданий.РегистрВДокументы(
				Ссылка,
				Перечисления.СтатусыПроизводственныхОпераций.Выполнена);
			
		КонецЕсли;
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		
		ЗаписьЖурналаРегистрации(
			НСтр("ru = 'Сменные задания';
				|en = 'Shift tasks'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка,
			Ссылка.Метаданные(),
			Ссылка,
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		
		ВызватьИсключение СтрШаблон(НСтр("ru = 'Не удалось установить статус %1 документу %2';
										|en = 'Cannot set status %1 to document %2'"), Статус, Ссылка);
		
	КонецПопытки;
	
КонецПроцедуры

Функция КоличествоОпераций(Ссылка, Статус)
	
	Запрос = Новый Запрос;
	
	Если Статус = Перечисления.СтатусыСменныхЗаданий.Формируется Тогда
		
		Запрос.Текст =
			"ВЫБРАТЬ
			|	СУММА(1) КАК КоличествоОпераций
			|ИЗ
			|	РегистрСведений.ОперацииКСозданиюСменныхЗаданий КАК Операции
			|ГДЕ
			|	Операции.СменноеЗадание = &Ссылка
			|
			|ИМЕЮЩИЕ
			|	СУММА(1) ЕСТЬ НЕ NULL";
		
	Иначе
		
		Запрос.Текст =
			"ВЫБРАТЬ
			|	СУММА(1) КАК КоличествоОпераций
			|ИЗ
			|	Документ.ПроизводственнаяОперация2_2 КАК Операции
			|ГДЕ
			|	Операции.СменноеЗадание = &Ссылка
			|
			|ИМЕЮЩИЕ
			|	СУММА(1) ЕСТЬ НЕ NULL";
		
	КонецЕсли;
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		
		Возврат Выборка.КоличествоОпераций;
		
	Иначе
		
		Возврат 0;
		
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли
