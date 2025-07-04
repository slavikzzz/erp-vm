///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// Отправляет SMS через МТС.
//
// Параметры:
//  НомераПолучателей - Массив - номера получателей в формате +7ХХХХХХХХХХ (строкой);
//  Текст             - Строка - текст сообщения, длиной не более 1000 символов;
//  ИмяОтправителя 	  - Строка - имя отправителя, которое будет отображаться вместо номера входящего SMS;
//  Логин             - Строка - логин пользователя услуги отправки sms;
//  Пароль            - Строка - пароль пользователя услуги отправки sms.
//
// Возвращаемое значение:
//   см. ОтправкаSMS.ОтправитьSMS.
//
Функция ОтправитьSMS(НомераПолучателей, Текст, ИмяОтправителя, Логин, Знач Пароль) Экспорт
	
	Получатели = Новый Массив;
	Для Каждого Элемент Из НомераПолучателей Цикл
		НомерПолучателя = ФорматироватьНомер(Элемент);
		Если Получатели.Найти(НомерПолучателя) = Неопределено Тогда
			Получатели.Добавить(НомерПолучателя);
		КонецЕсли;
	КонецЦикла;
	
	СпособАвторизации = СпособАвторизации();
	
	Если СпособАвторизации = СпособАвторизацииПоЛогинуИПаролюМаркетолог() Тогда
		Возврат ОтправитьSMSМаркетолог(Получатели, Текст, ИмяОтправителя, Логин, Пароль);
	КонецЕсли;
	
	Возврат ОтправитьSMSКоммуникатор(Получатели, Текст, ИмяОтправителя, Логин, Пароль);
	
КонецФункции

// Возвращает текстовое представление статуса доставки сообщения.
//
// Параметры:
//  ИдентификаторСообщения - Строка - идентификатор, присвоенный sms при отправке.
//  НастройкиОтправкиSMS   - см. ОтправкаSMS.НастройкиОтправкиSMS.
//
// Возвращаемое значение:
//   см. ОтправкаSMS.СтатусДоставки.
//
Функция СтатусДоставки(ИдентификаторСообщения, НастройкиОтправкиSMS) Экспорт
	
	Если СпособАвторизации() = СпособАвторизацииПоЛогинуИПаролюМаркетолог() Тогда
		Возврат СтатусДоставкиМаркетолог(ИдентификаторСообщения, НастройкиОтправкиSMS);
	КонецЕсли;
	
	Результат = "Ошибка";
	
	ПараметрыЗапроса = Новый Структура;
	ПараметрыЗапроса.Вставить("messageID", ИдентификаторСообщения);
	ПараметрыЗапроса.Вставить("login", НастройкиОтправкиSMS.Логин);
	
	Если ЗначениеЗаполнено(НастройкиОтправкиSMS.Логин) Тогда
		ПараметрыЗапроса.Вставить("password", ОбщегоНазначения.КонтрольнаяСуммаСтрокой(НастройкиОтправкиSMS.Пароль));
	Иначе
		ПараметрыЗапроса.Вставить("password", "");
	КонецЕсли;
	
	HTTPЗапрос = ОтправкаSMS.ПодготовитьHTTPЗапрос(АдресРесурсаКоммуникатор() + "GetMessageStatus", ПараметрыЗапроса, Истина);
	
	РезультатЗапроса = ВыполнитьЗапрос(АдресСервераКоммуникатор(), HTTPЗапрос);
	Если Не РезультатЗапроса.ЗапросВыполнен Тогда
		Возврат Результат;
	КонецЕсли;
	
	ДокументDOM = ДокументDOM(РезультатЗапроса.ОтветСервера);
	Разыменователь = ДокументDOM.СоздатьРазыменовательПИ();
	
	НайденныйЭлемент = ДокументDOM.ВычислитьВыражениеXPath("/xmlns:ArrayOfDeliveryInfo/xmlns:DeliveryInfo/xmlns:DeliveryStatus",
		ДокументDOM, Разыменователь).ПолучитьСледующий();
		
	Если НайденныйЭлемент = Неопределено Тогда
		Возврат Результат;
	КонецЕсли;
	
	Результат = СтатусДоставкиSMS(НайденныйЭлемент.ТекстовоеСодержимое);
	Возврат Результат;
	
КонецФункции

Функция ФорматироватьНомер(Номер)
	Результат = "";
	ДопустимыеСимволы = "1234567890";
	Для Позиция = 1 По СтрДлина(Номер) Цикл
		Символ = Сред(Номер,Позиция,1);
		Если СтрНайти(ДопустимыеСимволы, Символ) > 0 Тогда
			Результат = Результат + Символ;
		КонецЕсли;
	КонецЦикла;
	Возврат Результат;
КонецФункции

Функция СтатусДоставкиSMS(СтатусСтрокой)
	СоответствиеСтатусов = Новый Соответствие;
	
	// Коммуникатор
	СоответствиеСтатусов.Вставить("Pending", "НеОтправлялось");
	СоответствиеСтатусов.Вставить("Sending", "Отправляется");
	СоответствиеСтатусов.Вставить("Sent", "Отправлено");
	СоответствиеСтатусов.Вставить("NotSent", "НеОтправлено");
	СоответствиеСтатусов.Вставить("Delivered", "Доставлено");
	СоответствиеСтатусов.Вставить("NotDelivered", "НеДоставлено");
	СоответствиеСтатусов.Вставить("TimedOut", "НеДоставлено");
	
	// Маркетолог
	СоответствиеСтатусов.Вставить(200, "Отправлено");
	СоответствиеСтатусов.Вставить(201, "НеОтправлено");
	СоответствиеСтатусов.Вставить(202, "Отправлено"); // Частично отправлено
	СоответствиеСтатусов.Вставить(300, "Доставлено");
	СоответствиеСтатусов.Вставить(302, "Доставлено"); // Частично доставлено
	СоответствиеСтатусов.Вставить(301, "НеДоставлено");
		
	Результат = СоответствиеСтатусов[СтатусСтрокой];
	Возврат ?(Результат = Неопределено, "Ошибка", Результат);
КонецФункции

Функция ОписанияОшибок()
	ОписанияОшибок = Новый Соответствие;

	// Коммуникатор
	ОписанияОшибок.Вставить("SYSTEM_FAILURE", НСтр("ru = 'Временная проблема на стороне МТС.';
													|en = 'Temporary issue on MTS side.'"));
	ОписанияОшибок.Вставить("TOO_MANY_PARAMETERS", НСтр("ru = 'Превышено максимальное число параметров.';
														|en = 'Too many parameters.'"));
	ОписанияОшибок.Вставить("INCORRECT_PASSWORD", НСтр("ru = 'Предоставленные логин/пароль не верны.';
														|en = 'Invalid username or password.'"));
	ОписанияОшибок.Вставить("MSID_FORMAT_ERROR", НСтр("ru = 'Формат номера неверный.';
														|en = 'Invalid number format.'"));
	ОписанияОшибок.Вставить("MESSAGE_FORMAT_ERROR", НСтр("ru = 'Ошибка в формате сообщения.';
														|en = 'Message format error.'"));
	ОписанияОшибок.Вставить("WRONG_ID", НСтр("ru = 'Передан неверный идентификатор.';
											|en = 'Invalid ID.'"));
	ОписанияОшибок.Вставить("MESSAGE_HANDLING_ERROR", НСтр("ru = 'Ошибка в обработке сообщения';
															|en = 'Message processing error.'"));
	ОписанияОшибок.Вставить("NO_SUCH_SUBSCRIBER", НСтр("ru = 'Данный абонент не зарегистрирован в Услуге в учетной записи клиента (или еще не дал подтверждение).';
														|en = 'The subscriber is not registered in the client account of the Service (or has not confirmed it yet).'"));
	ОписанияОшибок.Вставить("TEST_LIMIT_EXCEEDED", НСтр("ru = 'Превышен лимит по количеству сообщений в тестовой эксплуатации.';
														|en = 'Message limit exceeded in test environment.'"));
	ОписанияОшибок.Вставить("TRUSTED_LIMIT_EXCEEDED", НСтр("ru = 'Превышен лимит по количеству сообщений для абонентов, которые были добавлены без подтверждения.';
															|en = 'Message limit exceeded for subscribers added without confirmation.'"));
	ОписанияОшибок.Вставить("IP_NOT_ALLOWED", НСтр("ru = 'Доступ к сервису с данного IP невозможен (список допустимых IP-адресов можно указывается при подключении услуги).';
													|en = 'Cannot access the service from this IP address (the list of allowed IP addressed is specified when you subscribe to the service).'"));
	ОписанияОшибок.Вставить("MAX_LENGTH_EXCEEDED", НСтр("ru = 'Превышена максимальная длина сообщения (1000 символов).';
														|en = 'Message length exceeded (1000 characters).'"));
	ОписанияОшибок.Вставить("OPERATION_NOT_ALLOWED", НСтр("ru = 'Пользователь услуги не имеет прав на выполнение данной операции.';
															|en = 'The service user has no rights to perform the operation.'"));
	ОписанияОшибок.Вставить("EMPTY_MESSAGE_NOT_ALLOWED", НСтр("ru = 'Отправка пустых сообщений не допускается.';
																|en = 'Sending blank messages is not allowed.'"));
	ОписанияОшибок.Вставить("ACCOUNT_IS_BLOCKED", НСтр("ru = 'Учетная запись заблокирована, отправка сообщений не возможна.';
														|en = 'Account locked. Cannot send messages.'"));
	ОписанияОшибок.Вставить("OBJECT_ALREADY_EXISTS", НСтр("ru = 'Список рассылки с указанным названием уже существует в рамках компании.';
															|en = 'Distribution rule with this name already exists.'"));
	ОписанияОшибок.Вставить("MSID_IS_IN_BLACKLIST", НСтр("ru = 'Номер абонента находится в черном списке, отправка сообщений запрещена.';
														|en = 'Subscriber number is in the black list. Cannot send messages.'"));
	ОписанияОшибок.Вставить("MSIDS_ARE_IN_BLACKLIST", НСтр("ru = 'Все указанные номера абонентов находятся в черном списке, отправка сообщений запрещена.';
															|en = 'All specified subscriber numbers are in the black list. Cannot send messages.'"));
	ОписанияОшибок.Вставить("TIME_IS_IN_THE_PAST", НСтр("ru = 'Переданное время в прошлом.';
														|en = 'The specified time has passed.'"));
	
	// Маркетолог
	ОписанияОшибок.Вставить(806, НСтр("ru = 'Не указан получатель сообщения.';
										|en = 'Message recipient is not specified.'"));
	ОписанияОшибок.Вставить(807, НСтр("ru = 'Некорректный номер получателя.';
										|en = 'Incorrect recipient number.'"));
	ОписанияОшибок.Вставить(802, НСтр("ru = 'Неверный логин или пароль.';
										|en = 'Invalid credentials.'"));
	ОписанияОшибок.Вставить(803, НСтр("ru = 'Превышен лимит на отправку сообщений. Допускается до 10 SMS в секунду.';
										|en = 'You have exceeded the limit to send messages. You can send up to 10 text messages per second only.'"));
	ОписанияОшибок.Вставить(804, НСтр("ru = 'Не указан текст сообщения.';
										|en = 'Message text is not specified.'"));
	ОписанияОшибок.Вставить(805, НСтр("ru = 'Использование шаблонов недоступно.';
										|en = 'You cannot use templates.'"));
	ОписанияОшибок.Вставить(808, НСтр("ru = 'Указанный шаблон не найден.';
										|en = 'The specified template is not found.'"));
	ОписанияОшибок.Вставить(401, НСтр("ru = 'Ключ доступа не указан или неверный.';
										|en = 'Access key is not specified or is incorrect.'"));
	ОписанияОшибок.Вставить(602, НСтр("ru = 'Отсутствует обязательный параметр в тексте запроса.';
										|en = 'The required parameter is missing from the request text.'"));
	
	Возврат ОписанияОшибок;
КонецФункции

Функция ОписаниеОшибкиПоКоду(Знач КодОшибки)
	КодОшибки = СокрЛП(КодОшибки);
	ОписанияОшибок = ОписанияОшибок();
	ТекстСообщения = ОписанияОшибок[КодОшибки];
	Если ТекстСообщения = Неопределено Тогда
		ТекстСообщения = НСтр("ru = 'Отказ выполнения операции.';
								|en = 'Operation failed'") + Символы.ПС
			+ КодОшибки;
	КонецЕсли;
	Возврат ТекстСообщения;
КонецФункции

// Возвращает список разрешений для отправки SMS с использованием всех доступных провайдеров.
//
// Возвращаемое значение:
//  Массив
//
Функция Разрешения() Экспорт
	Протокол = "HTTPS";
	Адрес = АдресСервераМаркетолог();
	Порт = Неопределено;
	Описание = НСтр("ru = 'Отправка SMS через МТС.';
					|en = 'Text messaging via MTS.'");
	
	МодульРаботаВБезопасномРежиме = ОбщегоНазначения.ОбщийМодуль("РаботаВБезопасномРежиме");
	
	Разрешения = Новый Массив;
	Разрешения.Добавить(
		МодульРаботаВБезопасномРежиме.РазрешениеНаИспользованиеИнтернетРесурса(Протокол, Адрес, Порт, Описание));
	
	Возврат Разрешения;
КонецФункции

Функция ВыполнитьЗапрос(Знач АдресСервера, Знач HTTPЗапрос, Знач Пользователь = Неопределено, Знач Пароль = Неопределено)
	
	Результат = Новый Структура;
	Результат.Вставить("ЗапросВыполнен", Ложь);
	Результат.Вставить("ОтветСервера", "");
	
	HTTPОтвет = Неопределено;
	
	Попытка
		Соединение = Новый HTTPСоединение(АдресСервера, , Пользователь, Пароль, ПолучениеФайловИзИнтернета.ПолучитьПрокси("https"),
			60, ОбщегоНазначенияКлиентСервер.НовоеЗащищенноеСоединение());
			
		HTTPОтвет = Соединение.ОтправитьДляОбработки(HTTPЗапрос);
	Исключение
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Отправка SMS';
										|en = 'Text messaging'", ОбщегоНазначения.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка, , , ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
	
	Если HTTPОтвет <> Неопределено Тогда
		Если HTTPОтвет.КодСостояния <> 200 Тогда
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Запрос ""%1"" не выполнен. Код состояния: %2.';
					|en = 'Request failed: %1. Status code: %2.'"), HTTPЗапрос.АдресРесурса, HTTPОтвет.КодСостояния) + Символы.ПС
				+ HTTPОтвет.ПолучитьТелоКакСтроку();
			ЗаписьЖурналаРегистрации(НСтр("ru = 'Отправка SMS';
											|en = 'Text messaging'", ОбщегоНазначения.КодОсновногоЯзыка()),
				УровеньЖурналаРегистрации.Ошибка, , , ТекстОшибки);
		КонецЕсли;
		
		Результат.ЗапросВыполнен = HTTPОтвет.КодСостояния = 200;
		Результат.ОтветСервера = HTTPОтвет.ПолучитьТелоКакСтроку();
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Процедура ПриОпределенииНастроек(Настройки) Экспорт
	
	Настройки.АдресОписанияУслугиВИнтернете = "https://marketolog.mts.ru/";
	Настройки.ПриОпределенииСпособовАвторизации = Истина;
	Настройки.ПриОпределенииПолейАвторизации = Истина;
	
КонецПроцедуры

Процедура ПриОпределенииСпособовАвторизации(СпособыАвторизации) Экспорт
	
	СпособыАвторизации.Очистить();
	СпособыАвторизации.Добавить(СпособАвторизацииПоЛогинуИПаролюМаркетолог(), НСтр("ru = 'По логину и паролю (МТС Маркетолог)';
																					|en = 'Username and password authentication (MTS Marketolog)'"));
	
КонецПроцедуры

Процедура ПриОпределенииПолейАвторизации(СпособыАвторизации) Экспорт
	
	ПоляАвторизации = Новый СписокЗначений;
	ПоляАвторизации.Добавить("Пароль", НСтр("ru = 'Ключ API';
											|en = 'API key'"));
	
	СпособыАвторизации.Вставить("ПоКлючу", ПоляАвторизации);
	
	ПоляАвторизации = Новый СписокЗначений;
	ПоляАвторизации.Добавить("Логин", НСтр("ru = 'Логин';
											|en = 'Username'"));
	ПоляАвторизации.Добавить("Пароль", НСтр("ru = 'Пароль';
											|en = 'Password'"));

	СпособыАвторизации.Вставить(СпособАвторизацииПоЛогинуИПаролюМаркетолог(), ПоляАвторизации);
	
КонецПроцедуры

Функция ДокументDOM(Строка)
	
	ЧтениеXML = Новый ЧтениеXML;
	ЧтениеXML.УстановитьСтроку(Строка);
	ПостроительDOM = Новый ПостроительDOM;
	ДокументDOM = ПостроительDOM.Прочитать(ЧтениеXML);
	ЧтениеXML.Закрыть();
	
	Возврат ДокументDOM;
	
КонецФункции

Функция ОтправитьSMSКоммуникатор(Получатели, Текст, ИмяОтправителя, Логин, Знач Пароль)
	
	Результат = Новый Структура("ОтправленныеСообщения,ОписаниеОшибки", Новый Массив, "");
	
	ПараметрыЗапроса = Новый Структура;
	ПараметрыЗапроса.Вставить("msids", Получатели);
	ПараметрыЗапроса.Вставить("message", Текст);
	ПараметрыЗапроса.Вставить("naming", ИмяОтправителя);
	ПараметрыЗапроса.Вставить("login", Логин);
	
	Если ЗначениеЗаполнено(Логин) Тогда
		ПараметрыЗапроса.Вставить("password", ОбщегоНазначения.КонтрольнаяСуммаСтрокой(Пароль));
	Иначе
		ПараметрыЗапроса.Вставить("password", "");
	КонецЕсли;		
	
	HTTPЗапрос = ОтправкаSMS.ПодготовитьHTTPЗапрос(АдресРесурсаКоммуникатор() + "SendMessages", ПараметрыЗапроса, Истина);
	
	РезультатЗапроса = ВыполнитьЗапрос(АдресСервераКоммуникатор(), HTTPЗапрос);
	Если Не РезультатЗапроса.ЗапросВыполнен Тогда
		Результат.ОписаниеОшибки = ОписаниеОшибкиПоКоду(РезультатЗапроса.ОтветСервера);
		Возврат Результат;
	КонецЕсли;
	
	ДокументDOM = ДокументDOM(РезультатЗапроса.ОтветСервера);
	Разыменователь = ДокументDOM.СоздатьРазыменовательПИ();
	
	ОтправленныеСообщения = ДокументDOM.ВычислитьВыражениеXPath("/xmlns:ArrayOfSendMessageIDs/xmlns:SendMessageIDs",
		ДокументDOM, Разыменователь);
	
	Сообщение = ОтправленныеСообщения.ПолучитьСледующий();
	Пока Сообщение <> Неопределено Цикл
		НомерПолучателя = ДокументDOM.ВычислитьВыражениеXPath("xmlns:Msid", Сообщение, Разыменователь).ПолучитьСледующий().ТекстовоеСодержимое;
		ИдентификаторСообщения = ДокументDOM.ВычислитьВыражениеXPath("xmlns:MessageID", Сообщение, Разыменователь).ПолучитьСледующий().ТекстовоеСодержимое;
		
		Результат.ОтправленныеСообщения.Добавить(Новый Структура("НомерПолучателя,ИдентификаторСообщения",
			"+" +  НомерПолучателя, Формат(ИдентификаторСообщения, "ЧГ=")));
		
		Сообщение = ОтправленныеСообщения.ПолучитьСледующий();
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Функция ОтправитьSMSМаркетолог(Знач Получатели, Знач Текст, Знач ИмяОтправителя, Знач Логин, Знач Пароль)
	
	ТекстЗапроса = ТекстЗапросаМаркетолог(Получатели, Текст, ИмяОтправителя);
	HTTPЗапрос = HTTPЗапросМаркетолог(АдресРесурсаМаркетолог(Получатели.Количество() >= 10) + "messages", ТекстЗапроса);
	РезультатЗапроса = ВыполнитьЗапрос(АдресСервераМаркетолог(), HTTPЗапрос, Логин, Пароль);
	Результат = Новый Структура("ОтправленныеСообщения,ОписаниеОшибки", Новый Массив, "");
	
	ТекстОтвета = СокрЛП(РезультатЗапроса.ОтветСервера);
	Ответ = Новый Соответствие;
	Если СтрНачинаетсяС(ТекстОтвета, "{") И СтрЗаканчиваетсяНа(ТекстОтвета, "}") Тогда
		Ответ = ОбщегоНазначения.JSONВЗначение(ТекстОтвета);
	КонецЕсли;

	КодОшибки = Ответ["code"];
	Если КодОшибки = Неопределено И Не РезультатЗапроса.ЗапросВыполнен Тогда
		КодОшибки = 1;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(КодОшибки) Тогда
		Результат.ОписаниеОшибки = ОписаниеОшибкиПоКоду(КодОшибки);
		Возврат Результат;
	КонецЕсли;
	
	Сообщения = Ответ["messages"];
	Если Сообщения = Неопределено Тогда
		Результат.ОписаниеОшибки = НСтр("ru = 'Не удалось разобрать ответ сервера.';
										|en = 'Cannot parse the server response.'");
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Отправка SMS';
										|en = 'Text messaging'", ОбщегоНазначения.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка, , , Результат.ОписаниеОшибки + Символы.ПС + Символы.ПС + ТекстОтвета);
		Возврат Результат;
	КонецЕсли;
	
	Для Каждого Сообщение Из Сообщения Цикл
		НомерПолучателя = Сообщение["msisdn"];
		ИдентификаторСообщения = Сообщение["message_id"];
		
		ОписаниеСообщения = Новый Структура;
		ОписаниеСообщения.Вставить("НомерПолучателя", "+" + НомерПолучателя);
		ОписаниеСообщения.Вставить("ИдентификаторСообщения", ИдентификаторСообщения);
		
		Результат.ОтправленныеСообщения.Добавить(ОписаниеСообщения);
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Функция СтатусДоставкиМаркетолог(ИдентификаторСообщения, НастройкиОтправкиSMS)
	
	Результат = "Ошибка";
	
	ПараметрыЗапроса = Новый Структура;
	МассивИдентификаторов = Новый Массив;
	МассивИдентификаторов.Добавить(ИдентификаторСообщения);
	ПараметрыЗапроса.Вставить("msg_ids", МассивИдентификаторов);

	ТекстЗапроса = ОбщегоНазначения.ЗначениеВJSON(Новый Структура("msg_ids", ПараметрыЗапроса.msg_ids));
	HTTPЗапрос = HTTPЗапросМаркетолог(АдресРесурсаМаркетолог() + "messages/info", ТекстЗапроса);
	
	РезультатЗапроса = ВыполнитьЗапрос(АдресСервераМаркетолог(), HTTPЗапрос, НастройкиОтправкиSMS.Логин, НастройкиОтправкиSMS.Пароль);	
	Если Не РезультатЗапроса.ЗапросВыполнен Тогда
		Возврат Результат;
	КонецЕсли;
	
	Ответ = ОбщегоНазначения.JSONВЗначение(РезультатЗапроса.ОтветСервера, "event_at");
	СтатусыСообщений = Ответ["events_info"];
	
	Если СтатусыСообщений = Неопределено Тогда
		Возврат Результат;
	КонецЕсли;
	
	КодСостояния = Неопределено;
	Для Каждого СтатусыСообщения Из СтатусыСообщений Цикл
		Если СтатусыСообщения["key"] = ИдентификаторСообщения Тогда
			ВремяСобытия = '000101010000';
			Для Каждого ОписаниеСтатуса Из СтатусыСообщения["events_info"] Цикл
				Если ВремяСобытия < ОписаниеСтатуса["event_at"] Тогда
					КодСостояния = ОписаниеСтатуса["status"];
					ВремяСобытия = ОписаниеСтатуса["event_at"];
				КонецЕсли;
			КонецЦикла;
			Прервать;
		КонецЕсли;
	КонецЦикла;	
	
	Если КодСостояния = Неопределено Тогда
		Возврат Результат;
	КонецЕсли;
	
	Результат = СтатусДоставкиSMS(КодСостояния);
	Возврат Результат;
	
КонецФункции

Функция HTTPЗапросМаркетолог(ИмяМетода, ТекстЗапроса)
	
	Заголовки = Новый Соответствие;
	Заголовки.Вставить("Content-type", "application/json");
	
	HTTPЗапрос = Новый HTTPЗапрос(ИмяМетода, Заголовки);
	HTTPЗапрос.УстановитьТелоИзСтроки(ТекстЗапроса);
	
	Возврат HTTPЗапрос;
	
КонецФункции

Функция ТекстЗапросаМаркетолог(Получатели, Текст, ИмяОтправителя)
	
	ОписанияПолучателей = Новый Массив;
	Для Каждого Получатель Из Получатели Цикл
		ОписаниеПолучателя = Новый Структура;
		ОписаниеПолучателя.Вставить("msisdn", Получатель);
		ОписаниеПолучателя.Вставить("message_id", УникальныйИдентификатор());
		ОписанияПолучателей.Добавить(ОписаниеПолучателя); 
	КонецЦикла;
	
	Сообщение = Новый Структура;
	Сообщение.Вставить("content", Новый Структура("short_text", Текст));
	Сообщение.Вставить("to", ОписанияПолучателей);
	
	Сообщения = Новый Массив;
	Сообщения.Добавить(Сообщение);

	ПараметрыОтправки = Новый Структура;
	
	Если ЗначениеЗаполнено(ИмяОтправителя) Тогда
		ПараметрыОтправки.Вставить("from", Новый Структура("sms_address", ИмяОтправителя));
	КонецЕсли;
	
	ОписаниеЗапроса = Новый Структура;
	ОписаниеЗапроса.Вставить("messages", Сообщения);
	
	Если ЗначениеЗаполнено(ПараметрыОтправки) Тогда
		ОписаниеЗапроса.Вставить("options", ПараметрыОтправки);
	КонецЕсли;
	
	ТекстЗапроса = ОбщегоНазначения.ЗначениеВJSON(ОписаниеЗапроса);
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция УникальныйИдентификатор()
	
	УникальныйИдентификатор = Строка(Новый УникальныйИдентификатор);
	Возврат Лев(СтрЗаменить(УникальныйИдентификатор, "-", ""), 20);
	
КонецФункции

Функция АдресСервераКоммуникатор()
	
	Возврат "api.mcommunicator.ru";
	
КонецФункции

Функция АдресРесурсаКоммуникатор()
	
	Возврат "/m2m/m2m_api.asmx/";
	
КонецФункции

Функция АдресСервераМаркетолог()
	
	Возврат "omnichannel.mts.ru";
	
КонецФункции

Функция АдресРесурсаМаркетолог(ДляОтправкиБольшогоКоличестваSMS = Ложь)
	
	Если ДляОтправкиБольшогоКоличестваSMS Тогда
		Возврат "/http-api/v1/b/";
	КонецЕсли;
	
	Возврат "/http-api/v1/";
	
КонецФункции

Функция СпособАвторизации()
	
	Возврат СпособАвторизацииПоЛогинуИПаролюМаркетолог();
	
КонецФункции

Функция СпособАвторизацииПоЛогинуИПаролюМаркетолог()
	
	Возврат "ПоЛогинуИПаролюМаркетолог";
	
КонецФункции

#КонецОбласти
