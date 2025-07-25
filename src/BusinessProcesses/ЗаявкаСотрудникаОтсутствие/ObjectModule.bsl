#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступом.ЗаполнитьНаборыЗначенийДоступа.
//
// Параметры:
//   Таблица - см. УправлениеДоступом.ТаблицаНаборыЗначенийДоступа
//
Процедура ЗаполнитьНаборыЗначенийДоступа(Таблица) Экспорт
	ЗаполнитьНаборыЗначенийДоступаПоУмолчанию(Таблица);	
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытий

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий бизнес-процесса.

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Если ДанныеЗаполнения <> Неопределено Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
		Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") И ДанныеЗаполнения.Свойство("ФизическоеЛицо") Тогда
			ПричиныОтсутствий = Перечисления.ПричиныОтсутствийЗаявокКабинетСотрудника;
			Если ПричинаОтсутствия = ПричиныОтсутствий.ЛичныеДела Тогда 
				Наименование = СтрШаблон(НСтр("ru = 'Заявка на отсутствие по личным делам %1';
												|en = 'Request for absence due to personal reasons %1'"), Строка(ДанныеЗаполнения.ФизическоеЛицо));
			ИначеЕсли ПричинаОтсутствия = ПричиныОтсутствий.ДниУходаЗаДетьмиИнвалидами Тогда
				Наименование = СтрШаблон(НСтр("ru = 'Заявка на отсутствие по уходу за детьми инвалидами %1';
												|en = 'Request for absence for disabled child care %1'"), Строка(ДанныеЗаполнения.ФизическоеЛицо));
			ИначеЕсли ПричинаОтсутствия = ПричиныОтсутствий.Командировка Тогда
				Наименование = СтрШаблон(НСтр("ru = 'Заявка на отсутствие из-за командировки %1';
												|en = 'Request for absence due to business trip %1'"), Строка(ДанныеЗаполнения.ФизическоеЛицо));
			ИначеЕсли ПричинаОтсутствия = ПричиныОтсутствий.ЛичныеДела Тогда
				Наименование = СтрШаблон(НСтр("ru = 'Заявка на отсутствие по личный обстоятельствам %1';
												|en = 'Request for absence due to personal circumstances %1'"), Строка(ДанныеЗаполнения.ФизическоеЛицо));
			ИначеЕсли ПричинаОтсутствия = ПричиныОтсутствий.Опоздание Тогда
				Наименование = СтрШаблон(НСтр("ru = 'Уведомление об опоздании %1';
												|en = 'Late attendance notification %1'"), Строка(ДанныеЗаполнения.ФизическоеЛицо));
			ИначеЕсли ПричинаОтсутствия = ПричиныОтсутствий.Отгул Тогда
				Наименование = СтрШаблон(НСтр("ru = 'Заявка на отгул %1';
												|en = 'Request for day off %1'"), Строка(ДанныеЗаполнения.ФизическоеЛицо));
			ИначеЕсли ПричинаОтсутствия = ПричиныОтсутствий.ОтпускПоУходуЗаРебенком Тогда
				Наименование = СтрШаблон(НСтр("ru = 'Заявка на отсутствие по уходу за ребенком %1';
												|en = 'Request for absence for child care %1'"), Строка(ДанныеЗаполнения.ФизическоеЛицо));
			Иначе
				Наименование = СтрШаблон(НСтр("ru = 'Заявка на отсутствие %1';
												|en = 'Request for absence %1'"), Строка(ДанныеЗаполнения.ФизическоеЛицо));
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	ПричиныОтсутствийЗаявокКабинетСотрудника = Перечисления.ПричиныОтсутствийЗаявокКабинетСотрудника;
	ЭтоОпоздание = (ПричинаОтсутствия = ПричиныОтсутствийЗаявокКабинетСотрудника.Опоздание);
	ЭтоЛичныеДела = (ПричинаОтсутствия = ПричиныОтсутствийЗаявокКабинетСотрудника.ЛичныеДела);
	ДействиеНеТребуется = ЭтоОпоздание ИЛИ ЭтоЛичныеДела;
	
	Если Автор <> Неопределено И Не Автор.Пустая() Тогда
		АвторСтрокой = Строка(Автор);
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	ГруппаИсполнителейЗадач = ?(ТипЗнч(Исполнитель) = Тип("СправочникСсылка.РолиИсполнителей"),
		БизнесПроцессыИЗадачиСервер.ГруппаИсполнителейЗадач(Исполнитель, ОсновнойОбъектАдресации, ДополнительныйОбъектАдресации),
		Исполнитель);
	УстановитьПривилегированныйРежим(Ложь);
	
	Если НЕ ЭтоНовый() И ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "Предмет") <> Предмет Тогда
		ИзменитьПредметЗадач();
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	ДатаЗавершения = '00010101000000';	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий элементов карты маршрута.

// Параметры:
// 	ТочкаМаршрутаБизнесПроцесса - ТочкаМаршрутаБизнесПроцессаСсылка.Задание - 
// 	ФормируемыеЗадачи - Массив из ЗадачаОбъект - 
// 	Отказ - Булево - 
// 
Процедура ВыполнитьПриСозданииЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, Отказ)
	
	Записать();
	
	// Устанавливаем реквизиты адресации и доп. реквизиты для каждой задачи.
	Для каждого Задача Из ФормируемыеЗадачи Цикл
		
		Задача.Автор = Автор;
		Задача.АвторСтрокой = Строка(Автор);
		Если ТипЗнч(Исполнитель) = Тип("СправочникСсылка.РолиИсполнителей") Тогда
			Задача.РольИсполнителя = Исполнитель;
			Задача.ОсновнойОбъектАдресации = ОсновнойОбъектАдресации;
			Задача.ДополнительныйОбъектАдресации = ДополнительныйОбъектАдресации;
			Задача.Исполнитель = Неопределено;
		Иначе	
			Задача.Исполнитель = Исполнитель;
		КонецЕсли;
		Задача.Наименование = НаименованиеЗадачиДляВыполнения();
		Задача.СрокИсполнения = СрокИсполненияЗадачиДляВыполнения();
		Задача.Важность = Важность;
		Задача.Предмет = Предмет;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ВыполнитьПередСозданиемЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, СтандартнаяОбработка)
	Если Предмет = Неопределено Или Предмет.Пустая() Тогда
		Возврат;
	КонецЕсли;	
КонецПроцедуры

Процедура ЗавершениеПриЗавершении(ТочкаМаршрутаБизнесПроцесса, Отказ)
	ДатаЗавершения = БизнесПроцессыИЗадачиСервер.ДатаЗавершенияБизнесПроцесса(Ссылка);
	Выполнено = Истина;
	Записать();	
КонецПроцедуры

Процедура СогласоватьЗаявкуПриВыполнении(ТочкаМаршрутаБизнесПроцесса, Задача, Отказ)
	ЗадачаОбъект = Задача.ПолучитьОбъект();
	ЗадачаОбъект.ВыполнитьЗадачу();
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Функция ДоступноВыполнение() Экспорт
	
	ДоступноВыполнение = БизнесПроцессыЗаявокСотрудников.ДоступноВыполнение(ЭтотОбъект, Отсутствия.Выгрузить());
	ДоступноВыполнение = ДоступноВыполнение Или ДействиеНеТребуется;
	
	ПричиныОтсутствия = Перечисления.ПричиныОтсутствийЗаявокКабинетСотрудника;
	Если ПричинаОтсутствия = ПричиныОтсутствия.Командировка Тогда
		ДоступноВыполнение = (Не ПолучитьФункциональнуюОпцию("ИспользоватьОплатуКомандировок")) Или ДоступноВыполнение;
	ИначеЕсли ПричинаОтсутствия = ПричиныОтсутствия.Отгул Тогда
		ДоступноВыполнение = (Не ПолучитьФункциональнуюОпцию("ИспользоватьОтгулы")) Или ДоступноВыполнение;
	ИначеЕсли ПричинаОтсутствия = ПричиныОтсутствия.ДниУходаЗаДетьмиИнвалидами Тогда
		ДоступноВыполнение = (Не ПолучитьФункциональнуюОпцию("ИспользоватьРасчетЗарплатыРасширенная")) Или ДоступноВыполнение;
	КонецЕсли;
	
	СвязанныеЗаявки = БизнесПроцессыЗаявокСотрудников.СвязанныеЗаявкиСотрудника(Ссылка, ИдентификаторЗаявки);
	Если СвязанныеЗаявки.Количество() = 0 Тогда
		Возврат ДоступноВыполнение;
	КонецЕсли;
	
	Для Каждого СтрокаТЗ Из СвязанныеЗаявки Цикл
		ДоступноВыполнение = ДоступноВыполнение И (СтрокаТЗ.СостояниеЗаявки <> Перечисления.СостоянияЗаявокКабинетСотрудника.Отказ);
	КонецЦикла;
	
	Возврат ДоступноВыполнение;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ИзменитьПредметЗадач()

	УстановитьПривилегированныйРежим(Истина);
	НачатьТранзакцию();
	Попытка
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить("Задача.ЗадачаИсполнителя");
		ЭлементБлокировки.УстановитьЗначение("БизнесПроцесс", Ссылка);
		Блокировка.Заблокировать();
		
		Запрос = Новый Запрос(
			"ВЫБРАТЬ
			|	Задачи.Ссылка КАК Ссылка
			|ИЗ
			|	Задача.ЗадачаИсполнителя КАК Задачи
			|ГДЕ
			|	Задачи.БизнесПроцесс = &БизнесПроцесс");

		Запрос.УстановитьПараметр("БизнесПроцесс", Ссылка);
		ВыборкаДетальныеЗаписи = Запрос.Выполнить().Выбрать();
		
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			ЗадачаОбъект = ВыборкаДетальныеЗаписи.Ссылка.ПолучитьОбъект(); // ЗадачаОбъект
			ЗадачаОбъект.Выполнена = Ложь;
			ЗадачаОбъект.Предмет = Предмет;
			// Не выполняем предварительную блокировку данных для редактирования, т.к.
			// Это изменение имеет более высокий приоритет над открытыми формами задач.
			ЗадачаОбъект.Записать();
		КонецЦикла;
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;

КонецПроцедуры 

Функция НаименованиеЗадачиДляВыполнения()
	Возврат Наименование;		
КонецФункции

Функция СрокИсполненияЗадачиДляВыполнения()
	Возврат СрокИсполнения;		
КонецФункции

Процедура ЗаполнитьНаборыЗначенийДоступаПоУмолчанию(Таблица)
	
	// Логика ограничения по умолчанию для
	// - чтения:    Автор ИЛИ Исполнитель (с учетом адресации) ИЛИ Проверяющий (с учетом адресации)
	// - изменения: Автор.
	
	// Если предмет не задан (т.е. бизнес-процесс без основания), тогда предмет не участвует в логике ограничения.
	
	// Чтение, Изменение: набор № 1.
	Строка = Таблица.Добавить();
	Строка.НомерНабора     = 1;
	Строка.Чтение          = Истина;
	Строка.Изменение       = Истина;
	Строка.ЗначениеДоступа = Автор;
	
	// Чтение: набор № 2.
	Строка = Таблица.Добавить();
	Строка.НомерНабора     = 2;
	Строка.Чтение          = Истина;
	Строка.ЗначениеДоступа = ГруппаИсполнителейЗадач;
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.';
						|en = 'Invalid object call on the client.'");
#КонецЕсли