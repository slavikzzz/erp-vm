///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОписаниеПеременных

&НаКлиенте
Перем ОтчетОбОшибке;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Переход в режим открытия формы повторной синхронизации данных перед запуском
	// с двумя вариантами "Синхронизировать и продолжить" и "Продолжить".
	Если Параметры.ИнформацияОбОшибке <> Неопределено Тогда
		КраткоеПредставлениеОшибки   = ОбработкаОшибок.КраткоеПредставлениеОшибки(Параметры.ИнформацияОбОшибке);
		ПодробноеПредставлениеОшибки = ОбработкаОшибок.ПодробноеПредставлениеОшибки(Параметры.ИнформацияОбОшибке);
	КонецЕсли;
	Если ЗначениеЗаполнено(ПодробноеПредставлениеОшибки)
	   И ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ОбменДанными")
	   И ОбщегоНазначения.ЭтоПодчиненныйУзелРИБ() Тогда
		МодульОбменДаннымиСервер = ОбщегоНазначения.ОбщийМодуль("ОбменДаннымиСервер");
		МодульОбменДаннымиСервер.ВключитьПовторениеЗагрузкиСообщенияОбменаДаннымиПередЗапуском();
	КонецЕсли;
	
	ИнформацияОбОшибке = Параметры.ИнформацияОбОшибке;
	
	Если ЗначениеЗаполнено(ПодробноеПредставлениеОшибки) Тогда
		ЖурналРегистрации.ДобавитьСообщениеДляЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Ошибка,
			, , ПодробноеПредставлениеОшибки);
	КонецЕсли;
	
	ТекстСообщенияОбОшибке = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Приложение не было обновлено на новую версию по причине:
		|
		|%1';
		|en = 'The application was not updated to a new version due to:
		|
		|%1'"),
		КраткоеПредставлениеОшибки);
	
	Элементы.ТекстСообщенияОбОшибке.Заголовок = ТекстСообщенияОбОшибке;
	
	ВремяНачалаОбновления = Параметры.ВремяНачалаОбновления;
	ВремяОкончанияОбновления = ТекущаяДатаСеанса();
	
	Если Не Пользователи.ЭтоПолноправныйПользователь(, Истина) Тогда
		Элементы.ФормаОткрытьВнешнююОбработку.Видимость = Ложь;
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ПрофилиБезопасности") Тогда
		МодульРаботаВБезопасномРежиме = ОбщегоНазначения.ОбщийМодуль("РаботаВБезопасномРежиме");
		ИспользуютсяПрофилиБезопасности = МодульРаботаВБезопасномРежиме.ИспользуютсяПрофилиБезопасности();
	Иначе
		ИспользуютсяПрофилиБезопасности = Ложь;
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ОбновлениеКонфигурации") Тогда
		МодульОбновлениеКонфигурации = ОбщегоНазначения.ОбщийМодуль("ОбновлениеКонфигурации");
		КаталогСкрипта = МодульОбновлениеКонфигурации.КаталогСкрипта();
	КонецЕсли;
	
	Элементы.ФормаПроверитьНаличиеИсправлений.Видимость = ОбновлениеИнформационнойБазыСлужебный.ДоступнаРучнаяПроверкаНаличияИсправления();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Не ПустаяСтрока(КаталогСкрипта) Тогда
		МодульОбновлениеКонфигурацииКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ОбновлениеКонфигурацииКлиент");
		МодульОбновлениеКонфигурацииКлиент.ЗаписатьФайлПротоколаОшибкиИЗавершитьРаботу(КаталогСкрипта, 
			ПодробноеПредставлениеОшибки);
	КонецЕсли;
	
	Если ИнформацияОбОшибке <> Неопределено Тогда
		ОтчетОбОшибке = Новый ОтчетОбОшибке(ИнформацияОбОшибке);
		СтандартныеПодсистемыКлиент.НастроитьВидимостьИЗаголовокСсылкиОтправкиОтчетаОбОшибке(Элементы.СформироватьОтчетОбОшибке, ИнформацияОбОшибке, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	Если ОтчетОбОшибке <> Неопределено Тогда
		СтандартныеПодсистемыКлиент.ОтправитьОтчетОбОшибке(ОтчетОбОшибке, ИнформацияОбОшибке, Истина);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПоказатьСведенияОРезультатахОбновленияНажатие(Элемент)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ДатаНачала", ВремяНачалаОбновления);
	ПараметрыФормы.Вставить("ДатаОкончания", ВремяОкончанияОбновления);
	ПараметрыФормы.Вставить("ЗапускатьНеВФоне", Истина);
	
	ОткрытьФорму("Обработка.ЖурналРегистрации.Форма.ЖурналРегистрации", ПараметрыФормы,,,,,, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗавершитьРаботу(Команда)
	Закрыть(Истина);
КонецПроцедуры

&НаКлиенте
Процедура ПерезагрузитьПрограмму(Команда)
	Закрыть(Ложь);
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьВнешнююОбработку(Команда)
	
	ОбработкаПродолжения = Новый ОписаниеОповещения("ОткрытьВнешнююОбработкуПослеПодтвержденияБезопасности", ЭтотОбъект);
	ОткрытьФорму("Обработка.РезультатыОбновленияПрограммы.Форма.ПредупреждениеБезопасности",,,,,, ОбработкаПродолжения);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьВнешнююОбработкуПослеПодтвержденияБезопасности(Результат, ДополнительныеПараметры) Экспорт
	Если Результат <> Истина Тогда
		Возврат;
	КонецЕсли;
	
	Если ИспользуютсяПрофилиБезопасности Тогда
		
		МодульРаботаВБезопасномРежимеКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("РаботаВБезопасномРежимеКлиент");
		МодульРаботаВБезопасномРежимеКлиент.ОткрытьВнешнююОбработкуИлиОтчет(ЭтотОбъект);
		Возврат;
		
	КонецЕсли;
	
	Оповещение = Новый ОписаниеОповещения("ОткрытьВнешнююОбработкуЗавершение", ЭтотОбъект);
	ПараметрыЗагрузки = ФайловаяСистемаКлиент.ПараметрыЗагрузкиФайла();
	ПараметрыЗагрузки.ИдентификаторФормы = УникальныйИдентификатор;
	ПараметрыЗагрузки.Диалог.Фильтр = НСтр("ru = 'Внешняя обработка';
											|en = 'External data processor'") + "(*.epf)|*.epf";
	ПараметрыЗагрузки.Диалог.МножественныйВыбор = Ложь;
	ПараметрыЗагрузки.Диалог.Заголовок = НСтр("ru = 'Выберите внешнюю обработку';
												|en = 'Select external data processor'");
	ФайловаяСистемаКлиент.ЗагрузитьФайл(Оповещение, ПараметрыЗагрузки);
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьВнешнююОбработкуЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если ТипЗнч(Результат) = Тип("Структура") Тогда
		ИмяВнешнейОбработки = ПодключитьВнешнююОбработку(Результат.Хранение);
		ОткрытьФорму(ИмяВнешнейОбработки + ".Форма");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьНаличиеИсправлений(Команда)
	Результат = ДоступныеИсправленияНаСервере();
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПроверитьДоступныеИсправленияПродолжение", ЭтотОбъект, Результат);
	ОбновлениеИнформационнойБазыКлиент.ОбработатьРезультатРучнойПроверкиДоступныхПатчей(Результат, ОписаниеОповещения);
КонецПроцедуры

&НаКлиенте
Процедура СформироватьОтчетОбОшибкеНажатие(Элемент)
	СтандартныеПодсистемыКлиент.ПоказатьОтчетОбОшибке(ОтчетОбОшибке);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ДоступныеИсправленияНаСервере()
	Возврат ОбновлениеИнформационнойБазыСлужебный.ДоступныеДляУстановкиИсправления();
КонецФункции

&НаКлиенте
Процедура ПроверитьДоступныеИсправленияПродолжение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Результат.Значение = КодВозвратаДиалога.Нет Тогда
		Возврат;
	КонецЕсли;
	
	ДлительнаяОперация    = ЗапускУстановкиИсправлений();
	ПараметрыОжидания     = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ОповещениеОЗавершении = Новый ОписаниеОповещения("ОбработатьРезультатРучнойУстановкиПатчей", ОбновлениеИнформационнойБазыКлиент, ДополнительныеПараметры);
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, ОповещениеОЗавершении, ПараметрыОжидания);
	
КонецПроцедуры

&НаСервере
Функция ЗапускУстановкиИсправлений()
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияФункции(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Установка доступных исправлений после ошибки обновления.';
															|en = 'Installing patches'");
	Возврат ДлительныеОперации.ВыполнитьФункцию(ПараметрыВыполнения, "ПолучениеОбновленийПрограммы.ЗагрузитьИУстановитьИсправления");
	
КонецФункции

&НаСервере
Функция ПодключитьВнешнююОбработку(АдресВоВременномХранилище)
	
	Если Не Пользователи.ЭтоПолноправныйПользователь(, Истина) Тогда
		ВызватьИсключение НСтр("ru = 'Недостаточно прав доступа.';
								|en = 'Insufficient access rights.'");
	КонецЕсли;
	
	// АПК:552-выкл сценарий ремонта базы при ошибках обновления для полноправного администратора.
	// АПК:556-выкл
	Менеджер = ВнешниеОбработки;
	ИмяОбработки = Менеджер.Подключить(АдресВоВременномХранилище, , Ложь,
		ОбщегоНазначения.ОписаниеЗащитыБезПредупреждений());
	Возврат Менеджер.Создать(ИмяОбработки, Ложь).Метаданные().ПолноеИмя();
	// АПК:556-вкл
	// АПК:552-вкл
	
КонецФункции

#КонецОбласти
