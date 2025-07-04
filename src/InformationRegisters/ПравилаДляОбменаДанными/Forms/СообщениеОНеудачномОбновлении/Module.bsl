///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Проверка, что форма открыта с нужными параметрами
	Если Не Параметры.Свойство("ИмяПланаОбмена") Тогда
		
		ВызватьИсключение НСтр("ru = 'Эта форма не предназначена для непосредственного открытия.';
								|en = 'This form is not intended for direct opening.'", ОбщегоНазначения.КодОсновногоЯзыка());
		
	КонецЕсли;
	
	ИмяПланаОбмена     = Параметры.ИмяПланаОбмена;
	
	СинонимПланаОбмена = Метаданные.ПланыОбмена[ИмяПланаОбмена].Синоним;
	
	ПравилаКонвертацииОбъектов = Перечисления.ВидыПравилДляОбменаДанными.ПравилаКонвертацииОбъектов;
	ПравилаРегистрацииОбъектов = Перечисления.ВидыПравилДляОбменаДанными.ПравилаРегистрацииОбъектов;
	
	ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Ошибка,,,
		Параметры.ПодробноеПредставлениеОшибки);
		
	Элементы.ТекстСообщенияОбОшибке.Заголовок = СтроковыеФункции.ФорматированнаяСтрока(
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Элементы.ТекстСообщенияОбОшибке.Заголовок,
			СинонимПланаОбмена,
			Параметры.КраткоеПредставлениеОшибки));
	
	ПравилаИзФайла = РегистрыСведений.ПравилаДляОбменаДанными.ИспользуютсяПравилаИзФайла(ИмяПланаОбмена, Истина);
	
	Если ПравилаИзФайла.ПравилаКонвертации И ПравилаИзФайла.ПравилаРегистрации Тогда
		ТипПравил = НСтр("ru = 'конвертации и регистрации';
						|en = 'conversions and registrations'");
	ИначеЕсли ПравилаИзФайла.ПравилаКонвертации Тогда
		ТипПравил = НСтр("ru = 'конвертации';
						|en = 'conversions'");
	ИначеЕсли ПравилаИзФайла.ПравилаРегистрации Тогда
		ТипПравил = НСтр("ru = 'регистрации';
						|en = 'registrations'");
	КонецЕсли;
	
	Элементы.ТекстПравилаИзФайла.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		Элементы.ТекстПравилаИзФайла.Заголовок, СинонимПланаОбмена, ТипПравил);
	
	ВремяНачалаОбновления = Параметры.ВремяНачалаОбновления;
	Если Параметры.ВремяОкончанияОбновления = Неопределено Тогда
		ВремяОкончанияОбновления = ТекущаяДатаСеанса();
	Иначе
		ВремяОкончанияОбновления = Параметры.ВремяОкончанияОбновления;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗавершитьРаботу(Команда)
	Закрыть(Истина);
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиВЖурналРегистрации(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ДатаНачала", ВремяНачалаОбновления);
	ПараметрыФормы.Вставить("ДатаОкончания", ВремяОкончанияОбновления);
	ПараметрыФормы.Вставить("ЗапускатьНеВФоне", Истина);
	ЖурналРегистрацииКлиент.ОткрытьЖурналРегистрации(ПараметрыФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура Перезапустить(Команда)
	Закрыть(Ложь);
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьКомплектПравил(Команда)
	
	ОбменДаннымиКлиент.ЗагрузитьПравилаСинхронизацииДанных(ИмяПланаОбмена);
	
КонецПроцедуры

#КонецОбласти