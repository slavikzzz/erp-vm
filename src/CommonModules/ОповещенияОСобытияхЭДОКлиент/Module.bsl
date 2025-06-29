//@strict-types

#Область СлужебныйПрограммныйИнтерфейс

// Подключить оповещения о новых электронных документах.
// 
// Параметры:
//  Включить - Булево
//  ДоступноОповещениеОСобытиях - Булево
//  Интервал - Число
//
Процедура ПодключитьОповещенияОНовыхЭлектронныхДокументах(Включить = Истина,
	ДоступноОповещениеОСобытиях = Неопределено, Интервал = 15) Экспорт

	Если Включить Тогда
		ПодключитьОбработчикОповещенияОНовыхДокументах(ДоступноОповещениеОСобытиях, Интервал);
	Иначе
		ОтключитьОбработчикОповещенияОНовыхДокументах();
	КонецЕсли;

КонецПроцедуры

// Оповещает формы о наличии новых документов.
//
Процедура ПроверитьНаличиеНовыхЭлектронныхДокументовВСервисе1СЭДО() Экспорт

	// Для сохранения совместимости. Единственное место, где для определения событий делается серверный вызов
	//@skip-check object-deprecated
	ЕстьСобытияЭДО = ОповещенияОСобытияхЭДОВызовСервера.ЕстьСобытияЭДО();
	ИмяПараметра = ПараметрПриложения_ЕстьНовыеДокументы();
	ПараметрыПриложения.Вставить(ИмяПараметра, ЕстьСобытияЭДО);
	ОповеститьОНовыхДокументахЭДО(ЕстьСобытияЭДО);
	ПодключитьОповещенияОНовыхЭлектронныхДокументах(Истина, Истина, 60);

КонецПроцедуры

// Есть новые документы.
// 
// Возвращаемое значение:
//  Булево
//
Функция ЕстьНовыеДокументы() Экспорт
	ИмяПараметра = ПараметрПриложения_ЕстьНовыеДокументы();
	Если ПараметрыПриложения[ИмяПараметра] = Неопределено Тогда
		ПараметрыПриложения.Вставить(ИмяПараметра, Ложь);
	КонецЕсли;
	ЕстьНовыеДокументы = ПараметрыПриложения[ИмяПараметра]; // Булево
	Возврат ЕстьНовыеДокументы;
КонецФункции

#Область ДляВызоваИзДругихПодсистем

// ЭлектронноеВзаимодействие.ОбменСКонтрагентами.Синхронизация

// См. СинхронизацияЭДОКлиент.ПослеНачалаРаботыСистемы
//
Процедура ПослеНачалаРаботыСистемы() Экспорт

	ПодключитьОбработчикДействияЧерезСистемуВзаимодействия();

	ПараметрыРаботы = СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиентаПриЗапуске();

#Если Не МобильныйКлиент Тогда
	ПараметрРаботыКлиента_ДоступноОповещениеОСобытиях = ОповещенияОСобытияхЭДОКлиентСервер.ПараметрРаботыКлиентаПриЗапуске_ДоступноОповещениеОСобытиях();
	Если ПараметрыРаботы.Свойство(ПараметрРаботыКлиента_ДоступноОповещениеОСобытиях) Тогда
		ПодключитьОповещенияОНовыхЭлектронныхДокументах(Истина,
			ПараметрыРаботы[ПараметрРаботыКлиента_ДоступноОповещениеОСобытиях]);
	КонецЕсли;
#КонецЕсли

	ПараметрРаботыКлиента_ЕстьНовыеДокументыЭДО = ОповещенияОСобытияхЭДОКлиентСервер.ПараметрРаботыКлиентаПриЗапуске_ЕстьНовыеДокументы();
	Если ПараметрыРаботы.Свойство(ПараметрРаботыКлиента_ЕстьНовыеДокументыЭДО) Тогда
		ПараметрПриложения_ЕстьНовыеДокументы = ПараметрПриложения_ЕстьНовыеДокументы();
		ПараметрыПриложения.Вставить(ПараметрПриложения_ЕстьНовыеДокументы,
			ПараметрыРаботы[ПараметрРаботыКлиента_ЕстьНовыеДокументыЭДО]);
		ОповеститьОНовыхДокументахЭДО(ПараметрыРаботы[ПараметрРаботыКлиента_ЕстьНовыеДокументыЭДО]);
	КонецЕсли;

КонецПроцедуры

// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами.Синхронизация

// СтандартныеПодсистемы.БазоваяФункциональность

// См. СтандартныеПодсистемыКлиент.ПриПолученииСерверногоОповещения.
//
Процедура ПриПолученииСерверногоОповещения(ИмяОповещения, Результат) Экспорт

	Если ИмяОповещения = ОповещенияОСобытияхЭДОКлиентСервер.ИмяОповещенияОНовыхДокументах() Тогда
		ИмяПараметра = ПараметрПриложения_ЕстьНовыеДокументы();
		ПараметрыПриложения.Вставить(ИмяПараметра, Результат);
		ОповеститьОНовыхДокументахЭДО(Результат);
	КонецЕсли;

КонецПроцедуры

// Конец СтандартныеПодсистемы.БазоваяФункциональность

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПодключитьОбработчикОповещенияОНовыхДокументах(ДоступноОповещениеОСобытиях = Неопределено, Интервал = 60)

	Если ДоступноОповещениеОСобытиях = Неопределено Тогда
		ДоступноОповещениеОСобытиях = ОповещенияОСобытияхЭДОВызовСервера.ДоступноОповещениеОСобытияхЭДО();
	КонецЕсли;

	Если Не ДоступноОповещениеОСобытиях Тогда
		Возврат;
	КонецЕсли;

	ПодключитьОбработчикОжидания(ОбработчикОповещенияОНовыхДокументах(), Интервал, Истина);

КонецПроцедуры

Процедура ОтключитьОбработчикОповещенияОНовыхДокументах()
	
	ОтключитьОбработчикОжидания(ОбработчикОповещенияОНовыхДокументах());
	
КонецПроцедуры

Функция ОбработчикОповещенияОНовыхДокументах()
	
	Возврат "ПроверитьНаличиеНовыхЭлектронныхДокументов";
	
КонецФункции

Процедура ПриНажатииНаОповещениеОНовыхДокументах(ДополнительныеПараметры) Экспорт
	
	ИнтерфейсДокументовЭДОКлиент.ОткрытьТекущиеДелаЭДО();
	
КонецПроцедуры

Процедура ПодключитьОбработчикДействияЧерезСистемуВзаимодействия()
	
	Если Не СистемаВзаимодействия.ИнформационнаяБазаЗарегистрирована() Тогда
		Возврат;
	КонецЕсли;
	
	Оповещение = Новый ОписаниеОповещения("ПриНажатииГиперссылкуВСообщенииБотаЭДО", ЭтотОбъект);
	СистемаВзаимодействия.ПодключитьОбработчикДействияСообщения(Оповещение);
	
КонецПроцедуры

Процедура ПриНажатииГиперссылкуВСообщенииБотаЭДО(Сообщение, Действие, ДополнительныеПараметры) Экспорт
	
	Если Действие = "СинхронизироватьЭДО" Тогда
		Оповестить("ВыполнитьСинхронизацию");
	ИначеЕсли Действие = "ПодписатьЭД" Или Действие = "ОтклоненАннулированЭД" Тогда
		Если ТипЗнч(Сообщение.Данные) <> Тип("Структура") Тогда
			ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Неверный формат данных сообщения чата';
															|en = 'Incorrect format of the chat message data'"));
			Возврат; 
		КонецЕсли;
		
		ИнтерфейсДокументовЭДОКлиент.ОткрытьЭлектронныйДокументСообщенияЭДО(Сообщение.Данные.ЭлектронныйДокумент);
			
	ИначеЕсли Действие = "ОткрытьЭД" Тогда
		ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку(Сообщение.Данные);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОповеститьОНовыхДокументахЭДО(ЕстьНовыеДокументы)

	Если ЕстьНовыеДокументы Тогда
		ДействиеПриНажатии = Новый ОписаниеОповещения("ПриНажатииНаОповещениеОНовыхДокументах", ЭтотОбъект);
		ЗаголовокОповещения = НСтр("ru = 'Сервис 1С-ЭДО';
									|en = '1C:EDI service'");
		ТекстОповещения = НСтр("ru = 'Доступны к получению новые документы';
								|en = 'New documents are available for retrieval'");

		ПоказатьОповещениеПользователя(ЗаголовокОповещения, ДействиеПриНажатии, ТекстОповещения,
			БиблиотекаКартинок.ЭмблемаСервиса1СЭДО, СтатусОповещенияПользователя.Важное,
			"ОповещениеОНовыхДокументахЭДО");
	КонецЕсли;

	ИмяСобытия = ОповещенияОСобытияхЭДОКлиентСервер.ИмяОповещенияОНовыхДокументах();
	Оповестить(ИмяСобытия);

КонецПроцедуры

// Имя параметра приложения, хранящего статус наличия новых документов.
// 
// Возвращаемое значение:
//  Строка
//
Функция ПараметрПриложения_ЕстьНовыеДокументы()
	Возврат "ЭлектронноеВзаимодействие.ОбменСКонтрагентами.ЕстьНовыеДокументы";
КонецФункции

#КонецОбласти