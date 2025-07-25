///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2025, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОписаниеПеременных

Перем СообщениеОбмена Экспорт; // При получении - имя полученного файла во ВременныйКаталог. При отправке - имя файла, который необходимо отправить
Перем ВременныйКаталог Экспорт; // Временный каталог для сообщений обмена.
Перем ИдентификаторКаталога Экспорт;
Перем Корреспондент Экспорт;
Перем ИмяПланаОбмена Экспорт;
Перем ИмяПланаОбменаКорреспондента Экспорт;
Перем СообщениеОбОшибке Экспорт;
Перем СообщениеОбОшибкеЖР Экспорт;

Перем ШаблоныИменДляПолученияСообщения Экспорт;
Перем ИмяСообщенияДляОтправки Экспорт; 

#КонецОбласти

#Область ПрограммныйИнтерфейс

// См. ОбработкаОбъект.ТранспортСообщенийОбменаFILE.ОтправитьДанные
Функция ОтправитьДанные(СообщениеДляСопоставленияДанных = Ложь) Экспорт
	
	Результат = Истина;
	
	Попытка
		
		Если ВнутренняяПубликация Тогда
			
			Результат = ВнутренняяПубликация_ОтправитьСообщение(СообщениеДляСопоставленияДанных);
			
		Иначе
			
			Результат = МенеджерСервиса_ОтправитьСообщение(СообщениеДляСопоставленияДанных);
			
		КонецЕсли;
		
	Исключение
		
		ТранспортСообщенийОбмена.ИнформацияОбОшибкеВСообщения(ЭтотОбъект, ИнформацияОбОшибке());
		ТранспортСообщенийОбмена.ЗаписатьСообщениеВЖурналРегистрации(ЭтотОбъект, "ВыгрузкаДанных");
		
		Результат = Ложь;
		
	КонецПопытки;
	
	Возврат Результат;
	
КонецФункции

// См. ОбработкаОбъект.ТранспортСообщенийОбменаFILE.ПолучитьДанные
Функция ПолучитьДанные() Экспорт
	
	Попытка
		
		Если ВнутренняяПубликация Тогда 
			
			Результат = ВнутренняяПубликация_ПолучитьСообщение();
			
		Иначе
			
			Результат = МенеджерСервиса_ПолучитьСообщение();
			
		КонецЕсли;
		
	Исключение
		
		ТранспортСообщенийОбмена.ИнформацияОбОшибкеВСообщения(ЭтотОбъект, ИнформацияОбОшибке());
		ТранспортСообщенийОбмена.ЗаписатьСообщениеВЖурналРегистрации(ЭтотОбъект, "ЗагрузкаДанных");
		
		Результат = Ложь;
		
	КонецПопытки;
	
	Возврат Результат;
	
КонецФункции

// См. ОбработкаОбъект.ТранспортСообщенийОбменаFILE.ПараметрыКорреспондента
Функция ПараметрыКорреспондента(НастройкиПодключения) Экспорт
	
	Если ВнутренняяПубликация Тогда
		Результат = ВнутренняяПубликация_ПараметрыКорреспондента();
	Иначе
		Результат = МенеджерСервиса_ПараметрыКорреспондента();
	КонецЕсли;
	
	Возврат Результат;
		
КонецФункции

// См. ОбработкаОбъект.ТранспортСообщенийОбменаFILE.ПередВыгрузкойДанных
Функция ПередВыгрузкойДанных(СообщениеДляСопоставленияДанных = Ложь) Экспорт
	
	Возврат Истина;
	
КонецФункции

// См. ОбработкаОбъект.ТранспортСообщенийОбменаFILE.СохранитьНастройкиВКорреспонденте
Функция СохранитьНастройкиВКорреспонденте(НастройкиПодключения) Экспорт

	Если ВнутренняяПубликация Тогда
		Результат = ВнутренняяПубликация_СохранитьНастройкиВКорреспонденте(НастройкиПодключения);	
	Иначе
		Результат = МенеджерСервиса_СохранитьНастройкиВКорреспонденте(НастройкиПодключения);	
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// См. ОбработкаОбъект.ТранспортСообщенийОбменаFILE.ТребуетсяАутентификация
Функция ТребуетсяАутентификация() Экспорт
	
	Возврат Ложь;
	
КонецФункции

// См. ОбработкаОбъект.ТранспортСообщенийОбменаFILE.УдалитьНастройкуСинхронизацииВКорреспонденте
Функция УдалитьНастройкуСинхронизацииВКорреспонденте() Экспорт
	
	Если ВнутренняяПубликация Тогда
		
		Возврат ВнутренняяПубликация_УдалитьНастройкуСинхронизацииВКорреспонденте();
		
	Иначе
		
		Возврат Истина;
		
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ВнутренняяПубликация_ПараметрыКорреспондента()
	
	Результат = ТранспортСообщенийОбмена.СтруктураРезультатаПолученияПараметровКорреспондента();
	Результат.Вставить("ИмяПланаОбменаКорреспондента", ИмяПланаОбмена);
	
	МодульНастройкиТранспортаОбменаСообщениями = ОбщегоНазначения.ОбщийМодуль("РегистрыСведений.НастройкиТранспортаОбменаСообщениями");
	ПараметрыПодключения = МодульНастройкиТранспортаОбменаСообщениями.НастройкиТранспортаWS(КонечнаяТочкаКорреспондента);
	
	Попытка
		
		ВерсииКорреспондента = ОбменДаннымиПовтИсп.ВерсииКорреспондента(ПараметрыПодключения);
		
	Исключение
		
		ТранспортСообщенийОбмена.ИнформацияОбОшибкеВСообщения(ЭтотОбъект, ИнформацияОбОшибке());
		ТранспортСообщенийОбмена.ЗаписатьСообщениеВЖурналРегистрации(ЭтотОбъект);
		
		Результат.ПодключениеУстановлено = Ложь;
		Результат.СообщениеОбОшибке = СообщениеОбОшибке;
				
		Возврат Результат;
		
	КонецПопытки;
		
	ВерсияИнтерфейса = ОбменДаннымиВебСервис.МаксимальнаяОбщаяВерсияИнтерфейсаОбмена(ВерсииКорреспондента);
	
	Если НЕ СтрНайти("3.0.2.1, 3.0.2.2", ВерсияИнтерфейса)  Тогда
			
		СообщениеОбОшибке = НСтр("ru = 'Корреспондент не поддерживает версию интерфейса 3.0.2.x ""ОбменДанными"".
								|Для настройки подключения обновите конфигурацию корреспондента.';
								|en = 'The peer infobase does not support interface version 3.0.2.x ""ОбменДанными"".
								|To set up the connection, update the peer infobase application.'");
		
		Результат.ПодключениеРазрешено = Ложь;
		Результат.СообщениеОбОшибке = СообщениеОбОшибке;
			
		Возврат Результат;
		
	КонецЕсли;
		
	Прокси = ВнутренняяПубликация_Прокси();
	
	Если Прокси = Неопределено Тогда
		
		Результат.ПодключениеУстановлено = Ложь;
		Результат.СообщениеОбОшибке = СообщениеОбОшибке;
		
		Возврат Результат;
		
	КонецЕсли;

	ДополнительныеПараметры = Новый Структура;
	Если ОбменДаннымиПовтИсп.ЭтоПланОбменаXDTO(ИмяПланаОбмена) Тогда
		ДополнительныеПараметры.Вставить("ЭтоПланОбменаXDTO", Истина);
	КонецЕсли;
	
	КодЭтогоУзла = ПланыОбмена[ИмяПланаОбмена].ЭтотУзел().Код;
	
	ПараметрыИБ = ОбменДаннымиВебСервис.ПолучитьПараметрыИБ(
		Прокси, ИмяПланаОбмена, КодЭтогоУзла, СообщениеОбОшибке, ОбластьДанныхКорреспондента, ДополнительныеПараметры);
	
	ПараметрыКорреспондента = СериализаторXDTO.ПрочитатьXDTO(ПараметрыИБ);
	
	Если Не ПараметрыКорреспондента.ПланОбменаСуществует Тогда
		
		Текст = НСтр("ru = 'В корреспонденте не найден план обмена ""%1"".
			|Убедитесь, что
			| - выбран правильный вид приложения для настройки обмена;
			| - указан правильный адрес приложения в Интернете.';
			|en = 'Exchange plan ""%1"" is not found in the peer application.
			|Ensure that the following data is correct:
			|- The application type selected in the exchange settings.
			|- The web application address.'");
		
		СообщениеОбОшибке = СтрШаблон(Текст, ИмяПланаОбмена);
		
		Результат.ПодключениеУстановлено = Ложь;
		Результат.СообщениеОбОшибке = СообщениеОбОшибке;
		
		Возврат Результат;
		
	КонецЕсли;
	
	Результат.ПараметрыКорреспондентаПолучены = Истина;
	Результат.ПараметрыКорреспондента = ПараметрыКорреспондента;
	Результат.ИмяПланаОбменаКорреспондента = ПараметрыКорреспондента.ИмяПланаОбмена;
	Результат.ПодключениеУстановлено = Истина;
	
	Отказ = Ложь;
	СообщениеОбОшибке = "";
	
	ТранспортСообщенийОбмена.ПриПодключенииККорреспонденту(Отказ, ИмяПланаОбмена, ВерсияИнтерфейса, СообщениеОбОшибке);
		
	Если Отказ Тогда
		
		Результат.ПодключениеРазрешено = Ложь;
		Результат.СообщениеОбОшибке = СообщениеОбОшибке;
		
		Возврат Результат;
		
	КонецЕсли;
	
	ТранспортСообщенийОбмена.ПроверитьДублированиеСинхронизаций(ИмяПланаОбмена, ПараметрыКорреспондента, Результат);
	
	Результат.ПодключениеРазрешено = Истина;
	
	Возврат Результат;
	
КонецФункции

Функция ВнутренняяПубликация_СохранитьНастройкиВКорреспонденте(НастройкиПодключения)

	Прокси = ВнутренняяПубликация_Прокси();
	
	Если Прокси = Неопределено Тогда
		
		Возврат Ложь;
		
	КонецЕсли;
		
	НастройкиПодключенияКорреспондента = Новый Структура;
	Для Каждого ЭлементНастройки Из НастройкиПодключения Цикл
		НастройкиПодключенияКорреспондента.Вставить(ЭлементНастройки.Ключ);
	КонецЦикла;
	
	НастройкиПодключенияКорреспондента.ВариантРаботыМастера   = "ПродолжитьНастройкуОбменаДанными";
	НастройкиПодключенияКорреспондента.ВариантНастройкиОбмена = НастройкиПодключения.ВариантНастройкиОбмена;
	
	НастройкиПодключенияКорреспондента.ИмяПланаОбмена               = НастройкиПодключения.ИмяПланаОбменаКорреспондента;
	НастройкиПодключенияКорреспондента.ИмяПланаОбменаКорреспондента = НастройкиПодключения.ИмяПланаОбмена;
	НастройкиПодключенияКорреспондента.ФорматОбмена                 = НастройкиПодключения.ФорматОбмена;
	
	НастройкиПодключенияКорреспондента.ИспользоватьПрефиксыДляНастройкиОбмена =
		НастройкиПодключения.ИспользоватьПрефиксыДляНастройкиОбменаКорреспондента;
	
	НастройкиПодключенияКорреспондента.ИспользоватьПрефиксыДляНастройкиОбменаКорреспондента =
		НастройкиПодключения.ИспользоватьПрефиксыДляНастройкиОбмена;
	
	НастройкиПодключенияКорреспондента.ПрефиксИнформационнойБазыИсточника = НастройкиПодключения.ПрефиксИнформационнойБазыПриемника;
	НастройкиПодключенияКорреспондента.ПрефиксИнформационнойБазыПриемника = НастройкиПодключения.ПрефиксИнформационнойБазыИсточника;
	
	Если ОбменДаннымиПовтИсп.ЭтоПланОбменаXDTO(НастройкиПодключения.ИмяПланаОбмена) Тогда
		НастройкиПодключенияКорреспондента.ВерсияФорматаОбмена = НастройкиПодключения.ВерсияФорматаОбмена;
		
		ТаблицаОбъекты = ОбменДаннымиXDTOСервер.ПоддерживаемыеОбъектыФормата(
			НастройкиПодключения.ИмяПланаОбмена, "ОтправкаПолучение", НастройкиПодключения.УзелИнформационнойБазы);
		
		НастройкиПодключенияКорреспондента.ПоддерживаемыеОбъектыФормата = Новый ХранилищеЗначения(ТаблицаОбъекты, Новый СжатиеДанных(9));
	КонецЕсли;
		
	НастройкиПодключенияКорреспондента.WSКонечнаяТочкаКорреспондента = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(КонечнаяТочка, "Код");
	НастройкиПодключенияКорреспондента.WSОбластьДанныхКорреспондента = ПараметрыСеанса.ОбластьДанныхЗначение;
	НастройкиПодключения.WSКонечнаяТочкаКорреспондента = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(КонечнаяТочка, "Код");
	НастройкиПодключения.WSОбластьДанныхКорреспондента = ПараметрыСеанса.ОбластьДанныхЗначение;
			
	СтрокаНастроекПодключенияXML = Обработки.ТранспортСообщенийОбменаSM.НастройкиПодключенияВXML(НастройкиПодключения);
	
	ПараметрыПодключения = Новый Структура;
	ПараметрыПодключения.Вставить("НастройкиПодключения", НастройкиПодключенияКорреспондента);
	ПараметрыПодключения.Вставить("СтрокаПараметровXML",  СтрокаНастроекПодключенияXML);
	
	Попытка
		ОбменДаннымиВебСервис.СоздатьУзелОбмена(Прокси, ПараметрыПодключения, ОбластьДанныхКорреспондента);
	Исключение
		
		ТранспортСообщенийОбмена.ИнформацияОбОшибкеВСообщения(ЭтотОбъект, ИнформацияОбОшибке());
		ТранспортСообщенийОбмена.ЗаписатьСообщениеВЖурналРегистрации(ЭтотОбъект);
		
		Возврат Ложь;
		
	КонецПопытки;
			
	Возврат Истина;
	
КонецФункции

Функция ВнутренняяПубликация_ОтправитьСообщение(СообщениеДляСопоставленияДанных)

	Прокси = ВнутренняяПубликация_Прокси();
	
	Если Прокси = Неопределено Тогда
		
		Возврат Ложь;
		
	КонецЕсли;
	
	СтруктураНастроекОбмена = ОбменДаннымиСервер.НастройкиОбменаДляУзлаИнформационнойБазы(
		Корреспондент, Перечисления.ДействияПриОбмене.ВыгрузкаДанных, "SM");
		
	Отказ = Ложь;
	СостояниеНастройки = ОбменДаннымиВебСервис.СостояниеНастройки(
		Прокси, СтруктураНастроекОбмена, ОбластьДанныхКорреспондента, Отказ, СообщениеОбОшибке);
	
	Если Отказ Тогда
		ТранспортСообщенийОбмена.ЗаписатьСообщениеВЖурналРегистрации(ЭтотОбъект, "ВыгрузкаДанных");
		Возврат Ложь;
	КонецЕсли;
	
	ИдентификаторФайлаУИД = ОбменДаннымиВебСервис.ПоместитьФайлВХранилищеВСервисе(
		Прокси, СообщениеОбмена, 1024,, ОбластьДанныхКорреспондента);
	
	ИдентификаторФайлаСтрокой = Строка(ИдентификаторФайлаУИД);
	
	Если СообщениеДляСопоставленияДанных
		И (СостояниеНастройки.ПоддерживаетсяСопоставлениеДанных
		Или Не СостояниеНастройки.НастройкаСинхронизацииДанныхЗавершена) Тогда
		
		ОбменДаннымиВебСервис.ПоместитьСообщениеДляСопоставленияДанных(
			Прокси, СтруктураНастроекОбмена, ИдентификаторФайлаСтрокой, ОбластьДанныхКорреспондента);
		
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

Функция ВнутренняяПубликация_ПолучитьСообщение()
	
	Прокси = ВнутренняяПубликация_Прокси();
	Если Прокси = Неопределено Тогда
		
		Возврат Ложь;
		
	КонецЕсли;
	
	СтруктураНастроекОбмена = ОбменДаннымиСервер.НастройкиОбменаДляУзлаИнформационнойБазы(
		Корреспондент, Перечисления.ДействияПриОбменеВнутренняяПубликация.ЗагрузкаДанных, "SM");
		
	Отказ = Ложь;
	СостояниеНастройки = ОбменДаннымиВебСервис.СостояниеНастройки(
		Прокси, СтруктураНастроекОбмена, ОбластьДанныхКорреспондента, Отказ, СообщениеОбОшибке);
	
	Если Отказ Тогда
		
		ТранспортСообщенийОбмена.ЗаписатьСообщениеВЖурналРегистрации(ЭтотОбъект, "ЗагрузкаДанных");
		Возврат Ложь;
		
	КонецЕсли;
	
	ПараметрыОбмена = ОбменДаннымиСервер.ПараметрыОбмена();
	ОбменДаннымиВебСервис.ВыполнитьВыгрузкуДанных(Прокси, СтруктураНастроекОбмена, ПараметрыОбмена, ОбластьДанныхКорреспондента);
	
	Если ПараметрыОбмена.ДлительнаяОперация Тогда
		
		ОбменДаннымиВебСервис.ОжиданиеЗавершенияОперации(
			СтруктураНастроекОбмена, ПараметрыОбмена, Прокси, Перечисления.ДействияПриОбмене.ЗагрузкаДанных);
		
	КонецЕсли;
	
	УИДФайлаСообщения = Новый УникальныйИдентификатор(ПараметрыОбмена.ИдентификаторФайла);
	СообщениеОбмена = ОбменДаннымиВебСервис.ПолучитьФайлИзХранилищаВСервисе(
		Прокси, УИДФайлаСообщения, Корреспондент, 1024, ОбластьДанныхКорреспондента);
	
	Возврат Истина;
	
КонецФункции

Функция ВнутренняяПубликация_УдалитьНастройкуСинхронизацииВКорреспонденте()

	Прокси = ВнутренняяПубликация_Прокси();
	
	Если Прокси = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	СтруктураНастроекОбмена = ОбменДаннымиСервер.НастройкиОбменаДляУзлаИнформационнойБазы(Корреспондент, "УдалениеУзла");

	СтруктураНастроекОбмена.КлючСообщенияЖурналаРегистрации = ОбменДаннымиСервер.СобытиеЖурналаРегистрацииУдалениеОбменаДанными();
	СтруктураНастроекОбмена.ДействиеПриОбмене = Неопределено;
	
	Попытка
		ОбменДаннымиВебСервис.УдалитьУзелОбмена(Прокси, СтруктураНастроекОбмена, ОбластьДанныхКорреспондента);
	Исключение
		
		ТранспортСообщенийОбмена.ИнформацияОбОшибкеВСообщения(ЭтотОбъект, ИнформацияОбОшибке());
		ТранспортСообщенийОбмена.ЗаписатьСообщениеВЖурналРегистрации(ЭтотОбъект);
		
		Возврат Ложь;
		
	КонецПопытки;
	
	Возврат Истина;

КонецФункции

Функция МенеджерСервиса_ПараметрыКорреспондента()
	
	Результат = ТранспортСообщенийОбмена.СтруктураРезультатаПолученияПараметровКорреспондента();
	
	МодульПомощникНастройки = ОбменДаннымиСервер.МодульПомощникНастройкиСинхронизацииДанныхМеждуПриложениямиВИнтернете();
	
	Если МодульПомощникНастройки = Неопределено Тогда
		ПродолжитьОжидание = Ложь;
		Возврат Результат;
	КонецЕсли;
	
	НастройкиПодключения = Новый Структура;
	НастройкиПодключения.Вставить("ИмяПланаОбмена",              ИмяПланаОбмена);
	НастройкиПодключения.Вставить("НаименованиеКорреспондента",  НаименованиеКорреспондента);
	НастройкиПодключения.Вставить("ОбластьДанныхКорреспондента", ОбластьДанныхКорреспондента);
	
	ПродолжитьОжидание = Истина;
	
	ПараметрыОбработчика = Неопределено;
	МодульПомощникНастройки.ПриНачалеПолученияОбщихДанныхУзловКорреспондента(
		НастройкиПодключения, ПараметрыОбработчика, ПродолжитьОжидание);
		
	// Ожидание
	ПараметрыОбработчикаОжидания = Неопределено; 
	ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
	
	Пока ПродолжитьОжидание Цикл
		
		ОбменДаннымиСервер.Пауза(ПараметрыОбработчикаОжидания.ТекущийИнтервал);
		ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		
		МодульПомощникНастройки.ПриОжиданииПолученияОбщихДанныхУзловКорреспондента(ПараметрыОбработчика, ПродолжитьОжидание);	
	
	КонецЦикла;
	
	СтатусЗавершения = Неопределено;
	МодульПомощникНастройки.ПриЗавершенииПолученияОбщихДанныхУзловКорреспондента(
		ПараметрыОбработчика, СтатусЗавершения);
		
	ПараметрыОбработчика = Неопределено;
		
	Если СтатусЗавершения.Отказ Тогда
		
		СообщениеОбОшибке = СтатусЗавершения.Результат.СообщениеОбОшибке;
			
		ТранспортСообщенийОбмена.ЗаписатьСообщениеВЖурналРегистрации(ЭтотОбъект);
			
		Результат.ПодключениеУстановлено = Ложь;
		Результат.СообщениеОбОшибке = СообщениеОбОшибке;
		
	Иначе
		
		ПроверкаПодключенияВыполнена = СтатусЗавершения.Результат.ПараметрыКорреспондентаПолучены;
				
		Если ПроверкаПодключенияВыполнена Тогда
			Результат.ПодключениеУстановлено = Истина;
			Результат.ПараметрыКорреспондента = СтатусЗавершения.Результат.ПараметрыКорреспондента;
		КонецЕсли;
				
	КонецЕсли;
	
	Результат.ПодключениеРазрешено = Истина;
	
	Возврат Результат;
	
КонецФункции

Функция МенеджерСервиса_СохранитьНастройкиВКорреспонденте(НастройкиПодключения)
	
	УстановитьПривилегированныйРежим(Истина);
	
	МодульПомощникНастройки = ОбменДаннымиСервер.МодульПомощникНастройкиСинхронизацииДанныхМеждуПриложениямиВИнтернете();
	
	НастройкаXDTO = ОбменДаннымиПовтИсп.ЭтоПланОбменаXDTO(ИмяПланаОбмена);
	
	НастройкиПодключенияМС = МодульПомощникНастройки.ОписаниеНастроекПодключения(НастройкаXDTO);
		
	НастройкиПодключенияМС.ИмяПланаОбмена = НастройкиПодключения.ИмяПланаОбменаКорреспондента;
	НастройкиПодключенияМС.ИмяПланаОбменаКорреспондента = НастройкиПодключения.ИмяПланаОбмена;
	НастройкиПодключенияМС.ИдентификаторНастройки = НастройкиПодключения.ИдентификаторНастройки;
	НастройкиПодключенияМС.ФорматОбмена = НастройкиПодключения.ФорматОбмена;
	НастройкиПодключенияМС.Наименование = НастройкиПодключения.НаименованиеЭтойБазы;
	НастройкиПодключенияМС.НаименованиеКорреспондента = НастройкиПодключения.НаименованиеВторойБазы;
	НастройкиПодключенияМС.Префикс = НастройкиПодключения.ПрефиксИнформационнойБазыИсточника;
	НастройкиПодключенияМС.ПрефиксКорреспондента = НастройкиПодключения.ПрефиксИнформационнойБазыПриемника;
	НастройкиПодключенияМС.ИдентификаторИнформационнойБазыИсточника = НастройкиПодключения.ИдентификаторИнформационнойБазыИсточника;
	НастройкиПодключенияМС.ИдентификаторИнформационнойБазыПриемника = НастройкиПодключения.ИдентификаторИнформационнойБазыПриемника;
	НастройкиПодключенияМС.КонечнаяТочкаКорреспондента = КонечнаяТочкаКорреспондента;
	НастройкиПодключенияМС.ОбластьДанныхКорреспондента = ОбластьДанныхКорреспондента;
	
	Если НастройкаXDTO Тогда
		НастройкиXDTOКорреспондента = НастройкиПодключенияМС.НастройкиXDTOКорреспондента;
		НастройкиXDTOКорреспондента.ПоддерживаемыеВерсии.Добавить(НастройкиПодключения.ВерсияФорматаОбмена);
		НастройкиXDTOКорреспондента.ПоддерживаемыеОбъекты = НастройкиПодключения.ПоддерживаемыеОбъектыФорматаКорреспондента;
	КонецЕсли;
	
	// Общие данные узлов.
	
	РегистрыСведений.ОбщиеНастройкиУзловИнформационныхБаз.ОбновитьПрефиксы(
		Корреспондент,
		НастройкиПодключенияМС.Префикс,
		НастройкиПодключенияМС.ПрефиксКорреспондента);
		
	ФактическийКодКорреспондента = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Корреспондент, "Код");
		
	КодЭтогоУзла = НастройкиПодключенияМС.ИдентификаторИнформационнойБазыИсточника;
	
	// Работа с настройками транспорта.
	Параметры = Новый Структура;
	Параметры.Вставить("Корреспондент", Корреспондент);
	Параметры.Вставить("КодЭтогоУзла", КодЭтогоУзла);
	Параметры.Вставить("КодКорреспондента", НастройкиПодключенияМС.ИдентификаторИнформационнойБазыПриемника);
	Параметры.Вставить("КонечнаяТочкаКорреспондента", КонечнаяТочкаКорреспондента);
	Параметры.Вставить("ЭтоКорреспондент", Ложь);
	Параметры.Вставить("РежимСовместимостиСБСП_2_0_0", Ложь);
	Параметры.Вставить("ПсевдонимЭтогоУзла", "");
	
	ОбменДаннымиВМоделиСервиса.ОбновитьНастройкиТранспортаОбластиДанных(Параметры);
				
	ИмяПланаОбменаСообщениями = "ОбменСообщениями";
	МодульСообщенияВМоделиСервиса = ОбщегоНазначения.ОбщийМодуль("СообщенияВМоделиСервиса");
	МенеджерПланаОбменСообщениями = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени("ПланОбмена."
		+ ИмяПланаОбменаСообщениями);
		
	ПараметрыОбработчикаСессии = ПараметрыОбработчикаДлительнойОперации();
	
	УстановитьПривилегированныйРежим(Истина);
	
	НачатьТранзакцию();
	Попытка
		
		// Отправляем сообщение корреспонденту.
		Сообщение = МодульСообщенияВМоделиСервиса.НовоеСообщение(
			СообщенияОбменаДаннымиУправлениеИнтерфейс.СообщениеНастроитьОбменШаг1());
			
		Сообщение.Body.CorrespondentZone = НастройкиПодключенияМС.ОбластьДанныхКорреспондента;
		
		Сообщение.Body.ExchangePlan      = НастройкиПодключенияМС.ИмяПланаОбмена;
		Сообщение.Body.CorrespondentCode = НастройкиПодключенияМС.ИдентификаторИнформационнойБазыИсточника;
		Сообщение.Body.CorrespondentName = НастройкиПодключенияМС.Наименование;
		
		Сообщение.Body.Code     = НастройкиПодключенияМС.ИдентификаторИнформационнойБазыПриемника;
		Сообщение.Body.EndPoint = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(МенеджерПланаОбменСообщениями.ЭтотУзел(), "Код");
		
		Если ОбменДаннымиПовтИсп.ЭтоПланОбменаXDTO(НастройкиПодключенияМС.ИмяПланаОбмена) Тогда
			ВерсииФормата = ОбщегоНазначения.ВыгрузитьКолонку(
				ОбменДаннымиСервер.ЗначениеНастройкиПланаОбмена(ИмяПланаОбмена, "ВерсииФорматаОбмена"), "Ключ", Истина);
				
			ОбъектыФормата = ОбменДаннымиXDTOСервер.ПоддерживаемыеОбъектыФормата(
				ИмяПланаОбмена, "ОтправкаПолучение", Корреспондент);
			
			НастройкиXDTOКорреспондента = Новый Структура;
			НастройкиXDTOКорреспондента.Вставить("ПоддерживаемыеВерсии", ВерсииФормата);
			НастройкиXDTOКорреспондента.Вставить("ПоддерживаемыеОбъекты",
				Новый ХранилищеЗначения(ОбъектыФормата, Новый СжатиеДанных(9)));
				
			Сообщение.Body.XDTOSettings = СериализаторXDTO.ЗаписатьXDTO(НастройкиXDTOКорреспондента);
		КонецЕсли;
		
		ДополнительныеСвойства = Новый Структура;
		ДополнительныеСвойства.Вставить("Интерфейс", "3.0.1.1");
		ДополнительныеСвойства.Вставить("Префикс", НастройкиПодключенияМС.ПрефиксКорреспондента);
		ДополнительныеСвойства.Вставить("ПрефиксКорреспондента", НастройкиПодключенияМС.Префикс);
		ДополнительныеСвойства.Вставить("ИдентификаторНастройки", НастройкиПодключенияМС.ИдентификаторНастройки);
		
		Сообщение.AdditionalInfo = СериализаторXDTO.ЗаписатьXDTO(ДополнительныеСвойства);
		
		ПараметрыОбработчикаСессии.ИдентификаторОперации = ОбменДаннымиВМоделиСервиса.ОтправитьСообщение(Сообщение);
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		
		Информация = ИнформацияОбОшибке();
		
		ПараметрыОбработчикаСессии.Отказ = Истина;
		ПараметрыОбработчикаСессии.СообщениеОбОшибке = ОбработкаОшибок.КраткоеПредставлениеОшибки(Информация);
		
		СообщениеОбОшибке = ОбработкаОшибок.ПодробноеПредставлениеОшибки(Информация);
		
		ЗаписьЖурналаРегистрации(ОбменДаннымиВМоделиСервиса.СобытиеЖурналаРегистрацииНастройкаСинхронизацииДанных(),
			УровеньЖурналаРегистрации.Ошибка, , , СообщениеОбОшибке);
			
		Возврат Ложь;
			
	КонецПопытки;
		
	Если Не ПараметрыОбработчикаСессии.Отказ Тогда
		МодульСообщенияВМоделиСервиса.ДоставитьБыстрыеСообщения();
		
		ПараметрыОбработчикаСессии.ДлительнаяОперация = Истина;
		ПараметрыОбработчикаСессии.ДополнительныеПараметры.Вставить(
			"Корреспондент", Корреспондент);
	КонецЕсли;
	
	ПараметрыОбработчика = ПараметрыОбработчикаДлительнойОперации();
	ПараметрыОбработчика.ДополнительныеПараметры.Вставить("Корреспондент", Корреспондент);
	ПараметрыОбработчика.ДополнительныеПараметры.Вставить("ОжиданиеСессииОбменаСообщениямиСистемы1");
	ПараметрыОбработчика.ДополнительныеПараметры.Вставить("ПараметрыОбработчикаСессии", ПараметрыОбработчикаСессии);
	ПараметрыОбработчика.ДополнительныеПараметры.Вставить("НастройкиПодключения", НастройкиПодключенияМС);
	
	ПродолжитьОжидание = Истина;
	
	ПараметрыОбработчикаОжидания = Неопределено; 
	ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
	
	Пока ПродолжитьОжидание Цикл
		
		ОбменДаннымиСервер.Пауза(ПараметрыОбработчикаОжидания.ТекущийИнтервал);
		ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		
		МодульПомощникНастройки.ПриОжиданииСохраненияНастроекПодключения(
			ПараметрыОбработчика, ПродолжитьОжидание);
	
	КонецЦикла;
		
	Возврат Истина;
	
КонецФункции

Функция МенеджерСервиса_ОтправитьСообщение(СообщениеДляСопоставленияДанных)

	МодульНастройкиТранспортаОбменаОбластиДанных = ОбщегоНазначения.ОбщийМодуль("РегистрыСведений.НастройкиТранспортаОбменаОбластиДанных");
	НастройкиТранспортаОбластиДанных = МодульНастройкиТранспортаОбменаОбластиДанных.НастройкиТранспорта(Корреспондент);
		
	Если НастройкиТранспортаОбластиДанных.ВидТранспортаСообщенийОбменаПоУмолчанию = Перечисления.ВидыТранспортаСообщенийОбмена.FILE Тогда
		
		Транспорт = Обработки.ТранспортСообщенийОбменаFILE.Создать();
		Транспорт.КаталогОбменаИнформацией = НастройкиТранспортаОбластиДанных.FILEКаталогОбменаИнформацией;
		Транспорт.СжиматьФайлИсходящегоСообщения = НастройкиТранспортаОбластиДанных.FILEСжиматьФайлИсходящегоСообщения;
		Транспорт.ПарольАрхиваСообщенияОбмена = НастройкиТранспортаОбластиДанных.ПарольАрхиваСообщенияОбмена;
		
	ИначеЕсли НастройкиТранспортаОбластиДанных.ВидТранспортаСообщенийОбменаПоУмолчанию = Перечисления.ВидыТранспортаСообщенийОбмена.FTP Тогда 
		
		Транспорт = Обработки.ТранспортСообщенийОбменаFTP.Создать();
		Транспорт.СжиматьФайлИсходящегоСообщения = НастройкиТранспортаОбластиДанных.FTPСжиматьФайлИсходящегоСообщения;
		Транспорт.МаксимальныйДопустимыйРазмерСообщения = НастройкиТранспортаОбластиДанных.FTPСоединениеМаксимальныйДопустимыйРазмерСообщения;
		Транспорт.ПассивноеСоединение = НастройкиТранспортаОбластиДанных.FTPСоединениеПассивноеСоединение;
		Транспорт.Пользователь = НастройкиТранспортаОбластиДанных.FTPСоединениеПользователь;
		Транспорт.Порт = НастройкиТранспортаОбластиДанных.FTPСоединениеПорт;
		Транспорт.Путь = НастройкиТранспортаОбластиДанных.FTPСоединениеПуть;
		Транспорт.ПарольАрхиваСообщенияОбмена = НастройкиТранспортаОбластиДанных.ПарольАрхиваСообщенияОбмена;
		Транспорт.Пароль = НастройкиТранспортаОбластиДанных.FTPСоединениеПароль;
		
	КонецЕсли;
	
	Транспорт.Корреспондент = Корреспондент;
	Транспорт.ИмяСообщенияДляОтправки = ИмяСообщенияДляОтправки;
	Транспорт.ВременныйКаталог = ВременныйКаталог;
	Транспорт.СообщениеОбмена = СообщениеОбмена;
	
	РезультатОтправки = Транспорт.ОтправитьДанные(СообщениеДляСопоставленияДанных);
	
	Если НЕ РезультатОтправки Тогда	
		Возврат Ложь;
	КонецЕсли;
	
	Если СообщениеДляСопоставленияДанных Тогда
		
		НастройкиВыгрузки = Новый Структура;
		НастройкиВыгрузки.Вставить("Корреспондент", Корреспондент);
		НастройкиВыгрузки.Вставить("ОбластьДанныхКорреспондента", ОбластьДанныхКорреспондента);
		
		ПараметрыОбработчика = Неопределено;
		ПродолжитьОжидание = Истина;
		
		ПараметрыОбработчикаОжидания = Неопределено; 
		ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
				
		МодульПомощникИнтерактивногоОбмена = ОбменДаннымиСервер.МодульПомощникИнтерактивногоОбменаДаннымиВМоделиСервиса();
		
		МодульПомощникИнтерактивногоОбмена.ПриНачалеПомещенияДанныхДляСопоставления(
			НастройкиВыгрузки, ПараметрыОбработчика, ПродолжитьОжидание);	
		
		Пока ПродолжитьОжидание Цикл
			
			ОбменДаннымиСервер.Пауза(ПараметрыОбработчикаОжидания.ТекущийИнтервал);
			ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
			
			МодульПомощникИнтерактивногоОбмена.ПриОжиданииСессииОбменаСообщениямиСистемы(
				ПараметрыОбработчика, ПродолжитьОжидание);				
		
		КонецЦикла;
		
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

Функция МенеджерСервиса_ПолучитьСообщение()

	МодульНастройкиТранспортаОбменаОбластиДанных = ОбщегоНазначения.ОбщийМодуль("РегистрыСведений.НастройкиТранспортаОбменаОбластиДанных");
	НастройкиТранспортаОбластиДанных = МодульНастройкиТранспортаОбменаОбластиДанных.НастройкиТранспорта(Корреспондент);
		
	Если НастройкиТранспортаОбластиДанных.ВидТранспортаСообщенийОбменаПоУмолчанию = Перечисления.ВидыТранспортаСообщенийОбмена.FILE Тогда
		
		Транспорт = Обработки.ТранспортСообщенийОбменаFILE.Создать();
		Транспорт.КаталогОбменаИнформацией = НастройкиТранспортаОбластиДанных.FILEКаталогОбменаИнформацией;
		Транспорт.СжиматьФайлИсходящегоСообщения = НастройкиТранспортаОбластиДанных.FILEСжиматьФайлИсходящегоСообщения;
		Транспорт.ПарольАрхиваСообщенияОбмена = НастройкиТранспортаОбластиДанных.ПарольАрхиваСообщенияОбмена;
				
	ИначеЕсли НастройкиТранспортаОбластиДанных.ВидТранспортаСообщенийОбменаПоУмолчанию = Перечисления.ВидыТранспортаСообщенийОбмена.FTP Тогда 
		
		Транспорт = Обработки.ТранспортСообщенийОбменаFTP.Создать();
		Транспорт.СжиматьФайлИсходящегоСообщения = НастройкиТранспортаОбластиДанных.FTPСжиматьФайлИсходящегоСообщения;
		Транспорт.МаксимальныйДопустимыйРазмерСообщения = НастройкиТранспортаОбластиДанных.FTPСоединениеМаксимальныйДопустимыйРазмерСообщения;
		Транспорт.ПассивноеСоединение = НастройкиТранспортаОбластиДанных.FTPСоединениеПассивноеСоединение;
		Транспорт.Пользователь = НастройкиТранспортаОбластиДанных.FTPСоединениеПользователь;
		Транспорт.Порт = НастройкиТранспортаОбластиДанных.FTPСоединениеПорт;
		Транспорт.Путь = НастройкиТранспортаОбластиДанных.FTPСоединениеПуть;
		Транспорт.ПарольАрхиваСообщенияОбмена = НастройкиТранспортаОбластиДанных.ПарольАрхиваСообщенияОбмена;
		Транспорт.Пароль = НастройкиТранспортаОбластиДанных.FTPСоединениеПароль;
		
	КонецЕсли;
	
	Транспорт.Корреспондент = Корреспондент;
	Транспорт.СообщениеОбмена = СообщениеОбмена;
	Транспорт.ВременныйКаталог = ВременныйКаталог;
	Транспорт.ШаблоныИменДляПолученияСообщения = ШаблоныИменДляПолученияСообщения;
		
	Результат = Транспорт.ПолучитьДанные();
	СообщениеОбмена = Транспорт.СообщениеОбмена;
	
	Возврат Результат;	
		
КонецФункции

Процедура ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания) Экспорт
	
	ПараметрыОбработчикаОжидания.ТекущийИнтервал = Мин(ПараметрыОбработчикаОжидания.МаксимальныйИнтервал,
		Окр(ПараметрыОбработчикаОжидания.ТекущийИнтервал * ПараметрыОбработчикаОжидания.КоэффициентУвеличенияИнтервала, 1));
		
КонецПроцедуры

Процедура ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания) Экспорт
	
	ПараметрыОбработчикаОжидания = Новый Структура;
	ПараметрыОбработчикаОжидания.Вставить("МинимальныйИнтервал", 1);
	ПараметрыОбработчикаОжидания.Вставить("МаксимальныйИнтервал", 15);
	ПараметрыОбработчикаОжидания.Вставить("ТекущийИнтервал", 1);
	ПараметрыОбработчикаОжидания.Вставить("КоэффициентУвеличенияИнтервала", 1.4);
	
КонецПроцедуры

Функция ПараметрыОбработчикаДлительнойОперации(ФоновоеЗадание = Неопределено)
	
	ПараметрыОбработчика = Новый Структура;
	ПараметрыОбработчика.Вставить("ФоновоеЗадание",          ФоновоеЗадание);
	ПараметрыОбработчика.Вставить("Отказ",                   Ложь);
	ПараметрыОбработчика.Вставить("СообщениеОбОшибке",       "");
	ПараметрыОбработчика.Вставить("ДлительнаяОперация",      Ложь);
	ПараметрыОбработчика.Вставить("ИдентификаторОперации",   Неопределено);
	ПараметрыОбработчика.Вставить("АдресРезультата",         Неопределено);
	ПараметрыОбработчика.Вставить("ДополнительныеПараметры", Новый Структура);
	
	Возврат ПараметрыОбработчика;
	
КонецФункции

Функция ПодключениеУстановлено() Экспорт
	
	Возврат Истина;
	
КонецФункции

Функция ВнутренняяПубликация_Прокси()
	
	МодульНастройкиТранспортаОбменаСообщениями = ОбщегоНазначения.ОбщийМодуль("РегистрыСведений.НастройкиТранспортаОбменаСообщениями");
	НастройкиТранспортаWS = МодульНастройкиТранспортаОбменаСообщениями.НастройкиТранспортаWS(КонечнаяТочкаКорреспондента);

	ПараметрыПодключения = Новый Структура;
	ПараметрыПодключения.Вставить("АдресВебСервиса", НастройкиТранспортаWS.WSURLВебСервиса);
	ПараметрыПодключения.Вставить("ИмяПользователя", НастройкиТранспортаWS.WSИмяПользователя);
	ПараметрыПодключения.Вставить("Пароль", НастройкиТранспортаWS.WSПароль);
	
	Прокси = ОбменДаннымиВебСервис.WSПрокси(ПараметрыПодключения, СообщениеОбОшибке);
	
	Если Прокси = Неопределено Тогда
		ТранспортСообщенийОбмена.ЗаписатьСообщениеВЖурналРегистрации(ЭтотОбъект);
	КонецЕсли;
		
	Возврат Прокси;
	
КонецФункции	

#КонецОбласти

#Область Инициализация

ВременныйКаталог = Неопределено;
СообщениеОбмена = Неопределено;

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.';
						|en = 'Invalid object call on the client.'");
#КонецЕсли