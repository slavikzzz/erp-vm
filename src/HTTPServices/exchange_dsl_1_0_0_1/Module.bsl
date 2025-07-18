///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2025, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

Функция ВерсияИнтерфейса()
	
	Возврат 1;
	
КонецФункции

Функция ПолучитьВерсию_GET(Запрос)
	
	Ответ = Новый HTTPСервисОтвет(200);
	Ответ.УстановитьТелоИзСтроки(ВерсияИнтерфейса());
	Возврат Ответ;

КонецФункции

Функция ПолучитьПараметрыИБ_GET(Запрос)
	
	Ответ = Новый HTTPСервисОтвет(200);
	
	ИмяПланаОбмена = Запрос.ПараметрыЗапроса.Получить("ExchangePlanName");
	КодУзла = Запрос.ПараметрыЗапроса.Получить("NodeCode");
	ЭтоПланОбменаXDTO = Запрос.ПараметрыЗапроса.Получить("IsXDTOExchangePlan");
	
	ДополнительныеПараметры = Новый Структура;
	Если ЗначениеЗаполнено(ЭтоПланОбменаXDTO) Тогда
		ДополнительныеПараметры.Вставить("ЭтоПланОбменаXDTO", Истина);
	КонецЕсли;
	
	СообщениеОбОшибке = "";
	
	Попытка
	
		Параметры = ОбменДаннымиСервер.ПараметрыИнформационнойБазы_20(ИмяПланаОбмена, КодУзла, СообщениеОбОшибке, ДополнительныеПараметры);
	
	Исключение
		
		СообщениеОбОшибке = ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
			
		ЗаписьЖурналаРегистрации(ОбменДаннымиСервер.СобытиеЖурналаРегистрацииСозданиеОбменаДанными(),
			УровеньЖурналаРегистрации.Ошибка, , , СообщениеОбОшибке);
		
		Возврат ОтветОшибка(СообщениеОбОшибке);
		
	КонецПопытки;
	
	ТелоКакСтрока = ТранспортСообщенийОбмена.ЗначениеВJSON(Параметры);
	
	Ответ.УстановитьТелоИзСтроки(ТелоКакСтрока);
	Ответ.Заголовки.Вставить("Content-Type","text/html; charset=utf-8");
	
	Возврат Ответ;
	
КонецФункции

Функция СоздатьУзелОбмена_POST(Запрос)
	
	Ответ = Новый HTTPСервисОтвет(200);
	
	УстановитьПривилегированныйРежим(Истина);
	
	ОбменДаннымиСервер.ПроверитьИспользованиеОбменаДанными(Истина);
	
	МодульПомощникНастройки = ОбменДаннымиСервер.МодульПомощникСозданияОбменаДанными();
	
	Попытка
		
		ТелоКакСтрока = Запрос.ПолучитьТелоКакСтроку(КодировкаТекста.UTF8);
		НастройкиПодключенияИзЗапроса = ТранспортСообщенийОбмена.НастройкиПодключенияИзJSON(ТелоКакСтрока);
		НастройкиПодключенияИзЗапроса.Вставить("ИдентификаторТранспорта", "ПассивныйРежим");
		НастройкиПодключенияИзЗапроса.Вставить("НастройкиТранспорта", Новый Структура);
		
		НастройкиПодключения = ТранспортСообщенийОбменаКлиентСервер.СтруктураНастроекПодключения();
		НастройкиПодключения.ИмяПланаОбмена = НастройкиПодключенияИзЗапроса.ИмяПланаОбмена;
	
		ТранспортСообщенийОбмена.ПроверитьИЗаполнитьНастройкиПодключенияXML(НастройкиПодключения, НастройкиПодключенияИзЗапроса);
		
		МодульПомощникНастройки.ВыполнитьДействияПоНастройкеОбменаДанными(НастройкиПодключения);
		
	Исключение
		
		СообщениеОбОшибке = ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
			
		ЗаписьЖурналаРегистрации(ОбменДаннымиСервер.СобытиеЖурналаРегистрацииСозданиеОбменаДанными(),
			УровеньЖурналаРегистрации.Ошибка, , , СообщениеОбОшибке);
		
		Возврат ОтветОшибка(СообщениеОбОшибке);
		
	КонецПопытки;
	
	Возврат Ответ;
	
КонецФункции

Функция ПоместитьФайлДляСопоставления_POST(Запрос)
	
	Ответ = Новый HTTPСервисОтвет(200);
	
	ИмяПланаОбмена = Запрос.ПараметрыЗапроса.Получить("ExchangePlanName");
	КодУзла = Запрос.ПараметрыЗапроса.Получить("NodeCode");
	ИдентификаторФайла = Запрос.ПараметрыЗапроса.Получить("FileID");
	
	Попытка
		
		ОбменДаннымиОперацииВебСервисов.ПоместитьСообщениеДляСопоставленияДанных(
			ИмяПланаОбмена, КодУзла, ИдентификаторФайла);
		
	Исключение
		
		Возврат ОтветОшибка(ИнформацияОбОшибке());
		
	КонецПопытки;
		
	Возврат Ответ;
	
КонецФункции

Функция ПоместитьЧастьФайла_POST(Запрос)
	
	Ответ = Новый HTTPСервисОтвет(200);
	
	ИдентификаторСессии = Новый УникальныйИдентификатор(Запрос.ПараметрыЗапроса.Получить("SessionID"));
	НомерЧасти = Число(Запрос.ПараметрыЗапроса.Получить("PartNumber"));
	
	ДанныеЧасти = Запрос.ПолучитьТелоКакДвоичныеДанные();
	
	Попытка
		
		ОбменДаннымиОперацииВебСервисов.ПоместитьЧастьФайла(ИдентификаторСессии, НомерЧасти, ДанныеЧасти);
		
	Исключение
		
		Возврат ОтветОшибка(ИнформацияОбОшибке());
		
	КонецПопытки;
	
	Возврат Ответ;
	
КонецФункции

Функция СобратьФайлИзЧастей_POST(Запрос)
	
	Ответ = Новый HTTPСервисОтвет(200);
	
	ИдентификаторСессии = Новый УникальныйИдентификатор(Запрос.ПараметрыЗапроса.Получить("SessionID"));
	КоличествоЧастей = Число(Запрос.ПараметрыЗапроса.Получить("PartCount"));
	ИдентификаторФайла = Неопределено;
	
	Попытка
		ОбменДаннымиОперацииВебСервисов.СобратьФайлИзЧастей(ИдентификаторСессии, КоличествоЧастей, ИдентификаторФайла);
	Исключение
		Возврат ОтветОшибка(ИнформацияОбОшибке());
	КонецПопытки;
	
	Тело = Новый Структура("FileID", Строка(ИдентификаторФайла));
	ТелоКакСтрока = ТранспортСообщенийОбмена.ЗначениеВJSON(Тело);
	Ответ.УстановитьТелоИзСтроки(ТелоКакСтрока);
		
	Возврат Ответ;
	
КонецФункции

Функция ВыполнитьЗагрузкуДанных_POST(Запрос)
	
	Ответ = Новый HTTPСервисОтвет(200);
	
	ИмяПланаОбмена = Запрос.ПараметрыЗапроса.Получить("ExchangePlanName");
	КодУзла = Запрос.ПараметрыЗапроса.Получить("NodeCode");
	ИдентификаторФайла = Запрос.ПараметрыЗапроса.Получить("FileID");
	ДлительнаяОперацияРазрешена = Запрос.ПараметрыЗапроса.Получить("TimeConsumingOperationAllowed");

	ДлительнаяОперация = Неопределено;
	ИдентификаторОперации = Неопределено;
	
	Попытка 
		ОбменДаннымиОперацииВебСервисов.ВыполнитьЗагрузкуДанных(ИмяПланаОбмена, КодУзла, ИдентификаторФайла, 
			ДлительнаяОперация, ИдентификаторОперации, ДлительнаяОперацияРазрешена);
	Исключение
		Возврат ОтветОшибка(ИнформацияОбОшибке());
	КонецПопытки;
	
	Тело = Новый Структура;
	Тело.Вставить("TimeConsumingOperation", ДлительнаяОперация);
	Тело.Вставить("OperationID", ИдентификаторОперации);
	
	ТелоКакСтрока = ТранспортСообщенийОбмена.ЗначениеВJSON(Тело);
	Ответ.УстановитьТелоИзСтроки(ТелоКакСтрока);
	
	Возврат Ответ;

КонецФункции

Функция ПолучитьСостояниеДлительнойОперации_GET(Запрос)
	
	Ответ = Новый HTTPСервисОтвет(200);
	
	ИдентификаторОперации = Запрос.ПараметрыЗапроса.Получить("OperationID");
	СтрокаСообщенияОбОшибке = Неопределено;
	
	Состояние = ОбменДаннымиОперацииВебСервисов.ПолучитьСостояниеДлительнойОперации(ИдентификаторОперации, СтрокаСообщенияОбОшибке);
	
	Если ЗначениеЗаполнено(СтрокаСообщенияОбОшибке) Тогда
		Возврат ОтветОшибка(СтрокаСообщенияОбОшибке);
	КонецЕсли;
	
	Тело = Новый Структура;
	Тело.Вставить("ActionState", Состояние);
	Тело.Вставить("Message", СтрокаСообщенияОбОшибке);
	
	ТелоКакСтрока = ТранспортСообщенийОбмена.ЗначениеВJSON(Тело);
	
	Ответ.УстановитьТелоИзСтроки(ТелоКакСтрока);

	Возврат Ответ;

КонецФункции

Функция ВыполнитьВыгрузкуДанных_POST(Запрос)
	
	Ответ = Новый HTTPСервисОтвет(200);
	
	ИмяПланаОбмена = Запрос.ПараметрыЗапроса.Получить("ExchangePlanName");
	КодУзла = Запрос.ПараметрыЗапроса.Получить("NodeCode");
	ДлительнаяОперацияРазрешена = Запрос.ПараметрыЗапроса.Получить("TimeConsumingOperationAllowed");
	
	ИдентификаторФайла = Неопределено;
	ДлительнаяОперация = Неопределено;
	ИдентификаторОперации = Неопределено;
	
	Попытка
		ОбменДаннымиОперацииВебСервисов.ВыполнитьВыгрузкуДанных(ИмяПланаОбмена, КодУзла, 
			ИдентификаторФайла, ДлительнаяОперация, ИдентификаторОперации, ДлительнаяОперацияРазрешена);
	Исключение
		Возврат ОтветОшибка(ИнформацияОбОшибке());
	КонецПопытки;
	
	Тело = Новый Структура;
	Тело.Вставить("TimeConsumingOperation", ДлительнаяОперация);
	Тело.Вставить("OperationID", ИдентификаторОперации);
	Тело.Вставить("FileID", ИдентификаторФайла);

	ТелоКакСтрока = ТранспортСообщенийОбмена.ЗначениеВJSON(Тело);
	
	Ответ.УстановитьТелоИзСтроки(ТелоКакСтрока);
	
	Возврат Ответ;

КонецФункции

Функция ПодготовитьФайлДляПолучения_POST(Запрос)
	
	Ответ = Новый HTTPСервисОтвет(200);
	
	ИдентификаторФайла = Запрос.ПараметрыЗапроса.Получить("FileID");
	РазмерЧасти = Число(Запрос.ПараметрыЗапроса.Получить("BlockSize"));
	
	ИдентификаторСессии = Неопределено;
	КоличествоЧастей = Неопределено;
	
	Попытка
		ОбменДаннымиОперацииВебСервисов.ПодготовитьФайлДляПолучения(ИдентификаторФайла, РазмерЧасти, ИдентификаторСессии, КоличествоЧастей);
	Исключение
		Возврат ОтветОшибка(ИнформацияОбОшибке());
	КонецПопытки;
		
	Тело = Новый Структура;
	Тело.Вставить("SessionID", Строка(ИдентификаторСессии));
	Тело.Вставить("PartCount", КоличествоЧастей);
	
	ТелоКакСтрока = ТранспортСообщенийОбмена.ЗначениеВJSON(Тело);
	Ответ.УстановитьТелоИзСтроки(ТелоКакСтрока);
	
	Возврат Ответ;
	
КонецФункции

Функция ПолучитьЧастьФайла_GET(Запрос)
	
	Ответ = Новый HTTPСервисОтвет(200);
	
	ИдентификаторСессии = Новый УникальныйИдентификатор(Запрос.ПараметрыЗапроса.Получить("SessionID"));
	НомерЧасти = Число(Запрос.ПараметрыЗапроса.Получить("PartNumber"));
	ДанныеЧасти = Неопределено;
	
	Попытка
		ОбменДаннымиОперацииВебСервисов.ПолучитьЧастьФайла(ИдентификаторСессии, НомерЧасти, ДанныеЧасти);
	Исключение
		Возврат ОтветОшибка(ИнформацияОбОшибке());
	КонецПопытки;
		
	Ответ.УстановитьТелоИзДвоичныхДанных(ДанныеЧасти);
	
	Возврат Ответ;

КонецФункции

Функция УдалитьФайлы_DELETE(Запрос)
	
	Ответ = Новый HTTPСервисОтвет(200);
	
	ИдентификаторСессии = Новый УникальныйИдентификатор(Запрос.ПараметрыЗапроса.Получить("SessionID"));

	Попытка
		ОбменДаннымиОперацииВебСервисов.УдалитьСообщениеОбмена(ИдентификаторСессии);
	Исключение
		Возврат ОтветОшибка(ИнформацияОбОшибке());
	КонецПопытки;
		
	Возврат Ответ;

КонецФункции

Функция УдалитьУзелОбмена_DELETE(Запрос)
	
	Ответ = Новый HTTPСервисОтвет(200);
	
	ИмяПланаОбмена = Запрос.ПараметрыЗапроса.Получить("ExchangePlanName");
	КодУзла = Запрос.ПараметрыЗапроса.Получить("NodeCode");
	
	Попытка
		ОбменДаннымиОперацииВебСервисов.УдалитьУзелОбменаДанными(ИмяПланаОбмена, КодУзла);
	Исключение
		Возврат ОтветОшибка(ИнформацияОбОшибке());
	КонецПопытки;
	
	Возврат Ответ;

КонецФункции

Функция ОтветОшибка(ИнформацияОбОшибке = "")
	
	Если ТипЗнч(ИнформацияОбОшибке) = Тип("ИнформацияОбОшибке") Тогда
		СообщениеОбОшибке = ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
	КонецЕсли;
	
	Тело = Новый Структура("Message", СообщениеОбОшибке);
	ТелоКакСтрока = ТранспортСообщенийОбмена.ЗначениеВJSON(Тело);
			
	Ответ = Новый HTTPСервисОтвет(400);
	Ответ.УстановитьТелоИзСтроки(ТелоКакСтрока);
	
	КлючСообщенияЖурналаРегистрации = НСтр("ru = 'Транспорт сообщений обмена';
											|en = 'Exchange message transport'", ОбщегоНазначения.КодОсновногоЯзыка());
	ЗаписьЖурналаРегистрации(
		КлючСообщенияЖурналаРегистрации, 
		УровеньЖурналаРегистрации.Ошибка,,,
		СообщениеОбОшибке);
	Возврат Ответ;
	
КонецФункции

#КонецОбласти
