///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2025, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УзелИнформационнойБазы = ОбменДаннымиСервер.ГлавныйУзел();
	ЭтоАвтономноеРабочееМесто = ОбменДаннымиСервер.ЭтоАвтономноеРабочееМесто();
	ИмяПользователя = ПользователиИнформационнойБазы.ТекущийПользователь().Имя;
	
	Если УзелИнформационнойБазы = Неопределено Тогда
		
		ВызватьИсключение НСтр("ru = 'Эта информационная база не является распределенной или автономным рабочим местом.';
								|en = 'The infobase is not distributed or a standalone workstation.'", ОбщегоНазначения.КодОсновногоЯзыка());
		
	КонецЕсли;
	
	Если ЭтоАвтономноеРабочееМесто Тогда
		Элементы.СтраницыПараметрыПодключения.ТекущаяСтраница = Элементы.СтраницаАРМ;
		МодульАвтономнаяРабота = ОбщегоНазначения.ОбщийМодуль("АвтономнаяРабота");
		АдресДляВосстановленияПароляУчетнойЗаписи = МодульАвтономнаяРабота.АдресДляВосстановленияПароляУчетнойЗаписи();
		ДлительнаяОперацияРазрешена = Истина;
				
		Если ТранспортСообщенийОбмена.ПарольСинхронизацииДанныхЗадан(УзелИнформационнойБазы) Тогда
			ДанныеАутентификации = ТранспортСообщенийОбмена.ПарольСинхронизацииДанных(УзелИнформационнойБазы);
			Пароль = ДанныеАутентификации.Пароль;
		КонецЕсли;	
		
	КонецЕсли;
	
	ЗаполнитьИнформациюОСообщенииИзАрхиваНаСервере();
	
	НадписьИмяУзла = НСтр("ru = 'Не удалось установить обновление программы, полученное из
		|""%1"".
		|Техническую информацию см. в <a href = ""%2"">Журнале регистрации</a>.';
		|en = 'Cannot install the application update received from
		|""%1"".
		|See <a href = ""%2"">Event log</a> for technical information.'");
	Элементы.ИнформационнаяНадписьИмяУзла.Заголовок = 
		СтроковыеФункции.ФорматированнаяСтрока(НадписьИмяУзла, Строка(УзелИнформационнойБазы), "ЖурналРегистрации");
	
	УстановитьОтображениеЭлементовФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	ПодключитьОбработчикОжидания("ЗаполнитьИнформациюОСообщенииИзАрхива", 60, Ложь);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИнформационнаяНадписьИмяУзлаОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыФормы = Новый Структура;
	
	ОткрытьФорму("Обработка.ЖурналРегистрации.Форма.ЖурналРегистрации", ПараметрыФормы,,,,,,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ПродолжитьЗагрузкуСообщениемИзАрхиваПриИзменении(Элемент)
	
	Элементы.СтраницыПараметрыПодключения.Видимость = Не ПродолжитьЗагрузкуСообщениемИзАрхива;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СинхронизироватьИПродолжить(Команда)
	
	ТекстПредупреждения = "";
	ЕстьОшибки = Ложь;
	ДлительнаяОперация = Ложь;
	
	ПроверитьНеобходимостьОбновления();
	
	Если СтатусОбновления = "ОбновлениеНеТребуется" Тогда
		
		СинхронизироватьИПродолжитьБезОбновленияИБ();
		
	ИначеЕсли СтатусОбновления = "ОбновлениеИнформационнойБазы" Тогда
		
		СинхронизироватьИПродолжитьСОбновлениемИБ();
		
	ИначеЕсли СтатусОбновления = "ОбновлениеКонфигурации" Тогда
		
		ТекстПредупреждения = НСтр("ru = 'Из главного узла получены изменения, которые еще не применены.
			|Требуется открыть конфигуратор и обновить конфигурацию базы данных.';
			|en = 'Changes that have not been applied yet were received from the main node.
			|Open Designer and update the database configuration.'");
		
	КонецЕсли;
	
	Если Не ДлительнаяОперация Тогда
		
		СинхронизироватьИПродолжитьЗавершение();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НеСинхронизироватьИПродолжить(Команда)
	
	НеСинхронизироватьИПродолжитьНаСервере();
	
	Закрыть("Продолжить");
	
КонецПроцедуры

&НаКлиенте
Процедура ЗавершитьРаботу(Команда)
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ПараметрыПодключения(Команда)

	ПараметрыФормы = Новый Структура("Корреспондент", УзелИнформационнойБазы);
	
	ОткрытьФорму("Справочник.НастройкиТранспортаСообщенийОбмена.Форма.ПанельНастроекТранспорта",
		ПараметрыФормы,,,,,, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗабылиПароль(Команда)
	ТранспортСообщенийОбменаКлиент.ОткрытьИнструкциюКакИзменитьПарольСинхронизацииДанных(АдресДляВосстановленияПароляУчетнойЗаписи);
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСообщениеИзАрхива(Команда)
	
	Если Не ЗначениеЗаполнено(ПериодЗаписиАрхивногоСообщения) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Архивное сообщение отсутствует';
														|en = 'Архивное сообщение отсутствует'"));
		Возврат;
	КонецЕсли;
	
	СтруктураЗаписи = Новый Структура("Период, УзелИнформационнойБазы", ПериодЗаписиАрхивногоСообщения, УзелИнформационнойБазы);
	
	ТипЗначения = Тип("РегистрСведенийКлючЗаписи.АрхивСообщенийОбменов");
	ПараметрыЗаписи = Новый Массив(1);
	ПараметрыЗаписи[0] = СтруктураЗаписи;
	
	КлючЗаписи = Новый(ТипЗначения, ПараметрыЗаписи);
	
	ПараметрыЗаписи = Новый Структура;
	ПараметрыЗаписи.Вставить("Ключ", КлючЗаписи);
	
	ОткрытьФорму("РегистрСведений.АрхивСообщенийОбменов.Форма.ФормаЗаписи", 
		ПараметрыЗаписи,
		ЭтотОбъект,
		УникальныйИдентификатор);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// Сценарий без обновления информационной базы.

&НаКлиенте
Процедура СинхронизироватьИПродолжитьБезОбновленияИБ()
	
	ЗагрузитьСообщениеОбменаДаннымиБезОбновления();
	СинхронизироватьИПродолжитьБезОбновленияИБЗавершение();
		
КонецПроцедуры

&НаСервере
Процедура СинхронизироватьИПродолжитьБезОбновленияИБЗавершение()
	
	// Режим повтора требует включения в следующих случаях.
	// Случай 1. Получены метаданные с новой версией конфигурации, т.е. будет выполнено обновление ИБ.
	// Е если Отказ = Истина, тогда недопустимо продолжение, т.к. могут быть созданы дубли генерируемых данных,
	// - если Отказ = Ложь, тогда возможна ошибка при обновлении ИБ, возможно требующая повторной загрузки сообщения.
	// Случай 2. Получены метаданные с той же версией конфигурации, т.е. не будет выполнено обновление ИБ.
	// Е если Отказ = Истина, тогда возможна ошибка при продолжении запуска, например, из-за того, что
	//   не были загружены предопределенные элементы,
	// - если Отказ = Ложь, тогда продолжение возможно, т.к. выгрузку можно сделать позднее (если же
	//   выгрузка не выполняется успешно, тогда позднее можно получить и новое сообщение для загрузки).
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если Не ЕстьОшибки Тогда
		
		ОбменДаннымиСервер.УстановитьРежимЗагрузкиСообщенияОбменаДаннымиПередЗапуском("ЗагрузкаРазрешена", Ложь);
		
		// Если сообщение загружено успешно, тогда повторная загрузка более не требуется.
		Если Константы.ЗагрузитьСообщениеОбменаДанными.Получить() Тогда
			Константы.ЗагрузитьСообщениеОбменаДанными.Установить(Ложь);
		КонецЕсли;
		Константы.ПовторитьЗагрузкуСообщенияОбменаДаннымиПередЗапуском.Установить(Ложь);
		
		Попытка
			ВыгрузитьСообщениеПослеОбновленияИнформационнойБазы();
		Исключение
			// Если выгрузка не удалась все равно можно продолжить запуск и
			// сделать выгрузку в режиме 1С:Предприятия.
			КлючСообщенияЖурналаРегистрации = ОбменДаннымиСервер.СобытиеЖурналаРегистрацииОбменДанными();
			ЗаписьЖурналаРегистрации(КлючСообщенияЖурналаРегистрации,
				УровеньЖурналаРегистрации.Ошибка,,, ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		КонецПопытки;
		
	ИначеЕсли КонфигурацияИзменена() Тогда
		Если НЕ Константы.ЗагрузитьСообщениеОбменаДанными.Получить() Тогда
			Константы.ЗагрузитьСообщениеОбменаДанными.Установить(Истина);
		КонецЕсли;
		ТекстПредупреждения = НСтр("ru = 'Из главного узла получены изменения, которые нужно применить.
			|Требуется открыть конфигуратор и обновить конфигурацию базы данных.';
			|en = 'Changes to be applied were received from the main node.
			|Open Designer and update the database configuration.'");
	Иначе
		
		Если ОбновлениеИнформационнойБазы.НеобходимоОбновлениеИнформационнойБазы() Тогда
			ВключитьПовторениеЗагрузкиСообщенияОбменаДаннымиПередЗапуском();
		КонецЕсли;
		
		ТекстПредупреждения = НСтр("ru = 'Получение данных из главного узла завершилось с ошибками.
			|Подробности см. в журнале регистрации.';
			|en = 'Receiving data from the master node is completed with errors.
			|For more information, see the event log.'");
		
		ОбменДаннымиСервер.УстановитьРежимЗагрузкиСообщенияОбменаДаннымиПередЗапуском("ЗагрузкаРазрешена", Ложь);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ВыгрузитьСообщениеПослеОбновленияИнформационнойБазы()
	
	// После успешной загрузки и обновления ИБ режим повтора можно отключить.
	ОбменДаннымиСервер.ОтключитьПовторениеЗагрузкиСообщенияОбменаДаннымиПередЗапуском();
	
	Попытка
		Если ПолучитьФункциональнуюОпцию("ИспользоватьСинхронизациюДанных") Тогда
			
			УзелИнформационнойБазы = ОбменДаннымиСервер.ГлавныйУзел();
			
			Если УзелИнформационнойБазы <> Неопределено Тогда
				
				ВыполнитьВыгрузку = Истина;
				
				ИдентификаторТранспорта = ТранспортСообщенийОбмена.ТранспортПоУмолчанию(УзелИнформационнойБазы);
				
				Если ВыполнитьВыгрузку Тогда
					
					ДанныеАутентификации = Новый Структура;
					Если ЭтоАвтономноеРабочееМесто Тогда
						ДанныеАутентификации.Вставить("ИмяПользователя", ИмяПользователя);
						ДанныеАутентификации.Вставить("Пароль", Пароль);
					КонецЕсли;
					
					// Только выгрузка.
					Отказ = Ложь;
					
					ПараметрыОбмена = ОбменДаннымиСервер.ПараметрыОбмена();
					ПараметрыОбмена.ИдентификаторТранспорта = ИдентификаторТранспорта;
					ПараметрыОбмена.ВыполнятьЗагрузку = Ложь;
					ПараметрыОбмена.ВыполнятьВыгрузку = Истина;
					ПараметрыОбмена.ДанныеАутентификации = ДанныеАутентификации;
					ПараметрыОбмена.ИнтервалОжиданияНаСервере = 15;
						
					ОбменДаннымиСервер.ВыполнитьОбменДаннымиДляУзлаИнформационнойБазы(УзелИнформационнойБазы, ПараметрыОбмена, Отказ);
					
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;
		
	Исключение
		ЗаписьЖурналаРегистрации(ОбменДаннымиСервер.СобытиеЖурналаРегистрацииОбменДанными(),
			УровеньЖурналаРегистрации.Ошибка,,, ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьСообщениеОбменаДаннымиБезОбновления()
	
	Попытка
		ЗагрузитьСообщениеПередОбновлениемИнформационнойБазы();
	Исключение
		ЗаписьЖурналаРегистрации(ОбменДаннымиСервер.СобытиеЖурналаРегистрацииОбменДанными(),
			УровеньЖурналаРегистрации.Ошибка,,, ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ЕстьОшибки = Истина;
	КонецПопытки;
	
	УстановитьОтображениеЭлементовФормы();
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьСообщениеПередОбновлениемИнформационнойБазы()
	
	Если ОбменДаннымиСлужебный.РежимЗагрузкиСообщенияОбменаДаннымиПередЗапуском(
			"ПропуститьЗагрузкуСообщенияОбменаДаннымиПередЗапуском") Тогда
		Возврат;
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьСинхронизациюДанных") Тогда
		
		Если УзелИнформационнойБазы <> Неопределено Тогда
			
			УстановитьПривилегированныйРежим(Истина);
			ОбменДаннымиСервер.УстановитьРежимЗагрузкиСообщенияОбменаДаннымиПередЗапуском("ЗагрузкаРазрешена", Истина);
			УстановитьПривилегированныйРежим(Ложь);
			
			// Обновление правил регистрации объектов выполняем до загрузки данных.
			ОбменДаннымиСервер.ВыполнитьОбновлениеПравилДляОбменаДанными();
			
			ИдентификаторТранспорта = ТранспортСообщенийОбмена.ТранспортПоУмолчанию(УзелИнформационнойБазы);
			
			ДатаНачалаОперации = ТекущаяДатаСеанса();
			
			ДанныеАутентификации = Новый Структура;
			Если ЭтоАвтономноеРабочееМесто Тогда
				ДанныеАутентификации.Вставить("ИмяПользователя", ИмяПользователя);
				ДанныеАутентификации.Вставить("Пароль", Пароль);
			КонецЕсли;			
			
			Если ПродолжитьЗагрузкуСообщениемИзАрхива Тогда
				СохранитьСообщениеИзАрхиваВКэш();
			КонецЕсли;
						
			// Только загрузка.
			ПараметрыОбмена = ОбменДаннымиСервер.ПараметрыОбмена();
			ПараметрыОбмена.ИдентификаторТранспорта = ИдентификаторТранспорта;
			ПараметрыОбмена.ВыполнятьЗагрузку = Истина;
			ПараметрыОбмена.ВыполнятьВыгрузку = Ложь;
			
			ПараметрыОбмена.ДлительнаяОперацияРазрешена = ДлительнаяОперацияРазрешена;
			ПараметрыОбмена.ДлительнаяОперация          = ДлительнаяОперация;
			ПараметрыОбмена.ИдентификаторОперации       = ИдентификаторОперации;
			ПараметрыОбмена.ИдентификаторФайла          = ИдентификаторФайла;
			ПараметрыОбмена.ДанныеАутентификации        = ДанныеАутентификации;
			ПараметрыОбмена.ИнтервалОжиданияНаСервере   = 15;
			
			ОбменДаннымиСервер.ВыполнитьОбменДаннымиДляУзлаИнформационнойБазы(УзелИнформационнойБазы, ПараметрыОбмена, ЕстьОшибки);
			
			ДлительнаяОперацияРазрешена = ПараметрыОбмена.ДлительнаяОперацияРазрешена;
			ДлительнаяОперация          = ПараметрыОбмена.ДлительнаяОперация;
			ИдентификаторОперации       = ПараметрыОбмена.ИдентификаторОперации;
			ИдентификаторФайла          = ПараметрыОбмена.ИдентификаторФайла;
			ДанныеАутентификации        = ПараметрыОбмена.ДанныеАутентификации;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Сценарий с обновлением информационной базы.

&НаКлиенте
Процедура СинхронизироватьИПродолжитьСОбновлениемИБ()
	
	ЗагрузитьСообщениеОбменаДаннымиСОбновлением();
	СинхронизироватьИПродолжитьСОбновлениемИБЗавершение();
	
КонецПроцедуры

&НаСервере
Процедура СинхронизироватьИПродолжитьСОбновлениемИБЗавершение()
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если Не ЕстьОшибки Тогда
		
		ОбменДаннымиСервер.УстановитьРежимЗагрузкиСообщенияОбменаДаннымиПередЗапуском("ЗагрузкаРазрешена", Ложь);
		
		Если НЕ Константы.ЗагрузитьСообщениеОбменаДанными.Получить() Тогда
			Константы.ЗагрузитьСообщениеОбменаДанными.Установить(Истина);
		КонецЕсли;
		
		ОбменДаннымиСервер.УстановитьРежимЗагрузкиСообщенияОбменаДаннымиПередЗапуском(
			"ПропуститьЗагрузкуПриоритетныхДанныхПередЗапуском", Истина);
		
	ИначеЕсли КонфигурацияИзменена() Тогда
			
		Если НЕ Константы.ЗагрузитьСообщениеОбменаДанными.Получить() Тогда
			Константы.ЗагрузитьСообщениеОбменаДанными.Установить(Истина);
		КонецЕсли;
		ТекстПредупреждения = НСтр("ru = 'Из главного узла получены изменения, которые нужно применить.
			|Требуется открыть конфигуратор и обновить конфигурацию базы данных.';
			|en = 'Changes to be applied were received from the main node.
			|Open Designer and update the database configuration.'");
		
	Иначе
		
		ОбменДаннымиСервер.УстановитьРежимЗагрузкиСообщенияОбменаДаннымиПередЗапуском("ЗагрузкаРазрешена", Ложь);
		
		ВключитьПовторениеЗагрузкиСообщенияОбменаДаннымиПередЗапуском();
		
		ТекстПредупреждения = НСтр("ru = 'Получение данных из главного узла завершилось с ошибками.
			|Подробности см. в журнале регистрации.';
			|en = 'Receiving data from the master node is completed with errors.
			|For more information, see the event log.'");
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьСообщениеОбменаДаннымиСОбновлением()
	
	Попытка
		ЗагрузитьПриоритетныеДанныеВПодчиненныйУзелРИБ();
	Исключение
		ЗаписьЖурналаРегистрации(ОбменДаннымиСервер.СобытиеЖурналаРегистрацииОбменДанными(),
			УровеньЖурналаРегистрации.Ошибка,,, ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ЕстьОшибки = Истина;
	КонецПопытки;
	
	УстановитьОтображениеЭлементовФормы();
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьПриоритетныеДанныеВПодчиненныйУзелРИБ()
	
	Если ОбменДаннымиСлужебный.РежимЗагрузкиСообщенияОбменаДаннымиПередЗапуском(
			"ПропуститьЗагрузкуСообщенияОбменаДаннымиПередЗапуском") Тогда
		Возврат;
	КонецЕсли;
	
	Если ОбменДаннымиСлужебный.РежимЗагрузкиСообщенияОбменаДаннымиПередЗапуском(
			"ПропуститьЗагрузкуПриоритетныхДанныхПередЗапуском") Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	ОбменДаннымиСервер.УстановитьРежимЗагрузкиСообщенияОбменаДаннымиПередЗапуском("ЗагрузкаРазрешена", Истина);
	УстановитьПривилегированныйРежим(Ложь);
	
	ПроверитьИспользованиеСинхронизацииДанных();
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьСинхронизациюДанных") Тогда
		
		УзелИнформационнойБазы = ОбменДаннымиСервер.ГлавныйУзел();
		
		Если УзелИнформационнойБазы <> Неопределено Тогда
			
			ИдентификаторТранспорта = ТранспортСообщенийОбмена.ТранспортПоУмолчанию(УзелИнформационнойБазы);
			Если ИдентификаторТранспорта = Неопределено Тогда 
				
				Справочники.НастройкиТранспортаСообщенийОбмена.ОбработатьДанныеДляПереходаНаНовуюВерсию();
				ИдентификаторТранспорта = ТранспортСообщенийОбмена.ТранспортПоУмолчанию(УзелИнформационнойБазы);
				
			КонецЕсли;
			
			ИмяПараметра = "СтандартныеПодсистемы.ОбменДанными.ПравилаРегистрации."
				+ ОбменДаннымиПовтИсп.ПолучитьИмяПланаОбмена(УзелИнформационнойБазы);
			ПравилаРегистрацииОбновлены = СтандартныеПодсистемыСервер.ПараметрРаботыПрограммы(ИмяПараметра);
			Если ПравилаРегистрацииОбновлены = Неопределено Тогда
				ОбменДаннымиСервер.ВыполнитьОбновлениеПравилДляОбменаДанными();
			КонецЕсли;
			ПравилаРегистрацииОбновлены = СтандартныеПодсистемыСервер.ПараметрРаботыПрограммы(ИмяПараметра);
			Если ПравилаРегистрацииОбновлены = Неопределено Тогда
				ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Не выполнено обновление кэша правил регистрации данных для плана обмена ""%1""';
						|en = 'Cannot update data registration rules cache for exchange plan ""%1""'"),
					ОбменДаннымиПовтИсп.ПолучитьИмяПланаОбмена(УзелИнформационнойБазы));
			КонецЕсли;
			
			ДатаНачалаОперации = ТекущаяДатаСеанса();
			
			ДанныеАутентификации = Новый Структура;
			Если ЭтоАвтономноеРабочееМесто Тогда
				ДанныеАутентификации.Вставить("ИмяПользователя", ИмяПользователя);
				ДанныеАутентификации.Вставить("Пароль", Пароль);
			КонецЕсли;
			
			Если ПродолжитьЗагрузкуСообщениемИзАрхива Тогда
				СохранитьСообщениеИзАрхиваВКэш();
			КонецЕсли;
			
			// Загрузка только параметров работы программы.
			ПараметрыОбмена = ОбменДаннымиСервер.ПараметрыОбмена();
			ПараметрыОбмена.ИдентификаторТранспорта = ИдентификаторТранспорта;
			ПараметрыОбмена.ВыполнятьЗагрузку = Истина;
			ПараметрыОбмена.ВыполнятьВыгрузку = Ложь;
			ПараметрыОбмена.ТолькоПараметры   = Истина;
			
			ПараметрыОбмена.ДлительнаяОперацияРазрешена = ДлительнаяОперацияРазрешена;
			ПараметрыОбмена.ДлительнаяОперация          = ДлительнаяОперация;
			ПараметрыОбмена.ИдентификаторОперации       = ИдентификаторОперации;
			ПараметрыОбмена.ИдентификаторФайла          = ИдентификаторФайла;
			ПараметрыОбмена.ДанныеАутентификации         = ДанныеАутентификации;	
			ПараметрыОбмена.ИнтервалОжиданияНаСервере    = 15;
						
			ОбменДаннымиСервер.ВыполнитьОбменДаннымиДляУзлаИнформационнойБазы(УзелИнформационнойБазы, ПараметрыОбмена, ЕстьОшибки);
			
			ДлительнаяОперацияРазрешена = ПараметрыОбмена.ДлительнаяОперацияРазрешена;
			ДлительнаяОперация          = ПараметрыОбмена.ДлительнаяОперация;
			ИдентификаторОперации       = ПараметрыОбмена.ИдентификаторОперации;
			ИдентификаторФайла          = ПараметрыОбмена.ИдентификаторФайла;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Сценарий без синхронизации

&НаСервере
Процедура НеСинхронизироватьИПродолжитьНаСервере()
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если НЕ ОбновлениеИнформационнойБазы.НеобходимоОбновлениеИнформационнойБазы() Тогда
		Если Константы.ЗагрузитьСообщениеОбменаДанными.Получить() Тогда
			Константы.ЗагрузитьСообщениеОбменаДанными.Установить(Ложь);
			ОбменДаннымиСервер.ОчиститьСообщениеОбменаДаннымиИзГлавногоУзла();
		КонецЕсли;
	КонецЕсли;
	
	ОбменДаннымиСервер.УстановитьРежимЗагрузкиСообщенияОбменаДаннымиПередЗапуском(
		"ПропуститьЗагрузкуСообщенияОбменаДаннымиПередЗапуском", Истина);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Служебные процедуры и функции.

&НаСервере
Процедура ПроверитьНеобходимостьОбновления()
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если КонфигурацияИзменена() Тогда
		СтатусОбновления = "ОбновлениеКонфигурации";
	ИначеЕсли ОбновлениеИнформационнойБазы.НеобходимоОбновлениеИнформационнойБазы() Тогда
		СтатусОбновления = "ОбновлениеИнформационнойБазы";
	Иначе
		СтатусОбновления = "ОбновлениеНеТребуется";
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СинхронизироватьИПродолжитьЗавершение()
	
	УстановитьОтображениеЭлементовФормы();
	
	Если ПустаяСтрока(ТекстПредупреждения) Тогда
		ПоказатьОповещениеПользователя(НСтр("ru = 'Автономная работа';
											|en = 'Автономная работа'"),
			,
			НСтр("ru = 'Повторная синхронизация данных завершена.';
				|en = 'Повторная синхронизация данных завершена.'"),
			БиблиотекаКартинок.Информация32,
			СтатусОповещенияПользователя.Важное);
			
		Закрыть("Продолжить");
	Иначе
		ПоказатьПредупреждение(, ТекстПредупреждения);
	КонецЕсли;
	
КонецПроцедуры

// Устанавливает признак повторения загрузки при ошибке загрузки или обновления.
// Очищает хранилище сообщения обмена, полученного из главного узла РИБ.
//
&НаСервере
Процедура ВключитьПовторениеЗагрузкиСообщенияОбменаДаннымиПередЗапуском()
	
	ОбменДаннымиСервер.ОчиститьСообщениеОбменаДаннымиИзГлавногоУзла();
	
	Константы.ПовторитьЗагрузкуСообщенияОбменаДаннымиПередЗапуском.Установить(Истина);
	
КонецПроцедуры

&НаСервере
Процедура ПроверитьИспользованиеСинхронизацииДанных()
	
	Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьСинхронизациюДанных") Тогда
		
		Если ОбщегоНазначения.РазделениеВключено() Тогда
			
			ИспользоватьСинхронизациюДанных = Константы.ИспользоватьСинхронизациюДанных.СоздатьМенеджерЗначения();
			ИспользоватьСинхронизациюДанных.ДополнительныеСвойства.Вставить("ОтключитьМеханизмРегистрацииОбъектов");
			ИспользоватьСинхронизациюДанных.ОбменДанными.Загрузка = Истина;
			ИспользоватьСинхронизациюДанных.Значение = Истина;
			ИспользоватьСинхронизациюДанных.Записать();
			
		Иначе
			
			Если ОбменДаннымиСервер.ПолучитьИспользуемыеПланыОбмена().Количество() > 0 Тогда
				
				ИспользоватьСинхронизациюДанных = Константы.ИспользоватьСинхронизациюДанных.СоздатьМенеджерЗначения();
				ИспользоватьСинхронизациюДанных.ДополнительныеСвойства.Вставить("ОтключитьМеханизмРегистрацииОбъектов");
				ИспользоватьСинхронизациюДанных.ОбменДанными.Загрузка = Истина;
				ИспользоватьСинхронизациюДанных.Значение = Истина;
				ИспользоватьСинхронизациюДанных.Записать();
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтображениеЭлементовФормы()
	
	Если ОбменДаннымиСервер.ЗагрузитьСообщениеОбменаДанными()
		И ОбновлениеИнформационнойБазы.НеобходимоОбновлениеИнформационнойБазы() Тогда
		
		Элементы.ФормаНеСинхронизироватьИПродолжить.Видимость = Ложь;
		Элементы.ИнформационнаяНадписьНеСинхронизировать.Видимость = Ложь;
	Иначе
		Элементы.ФормаНеСинхронизироватьИПродолжить.Видимость = Истина;
		Элементы.ИнформационнаяНадписьНеСинхронизировать.Видимость = Истина;
	КонецЕсли;
	
	Элементы.ПанельОсновная.ТекущаяСтраница = ?(ДлительнаяОперация, Элементы.ДлительнаяОперация, Элементы.Начало);
	Элементы.ГруппаКнопокДлительнаяОперация.Видимость = ДлительнаяОперация;
	Элементы.ГруппаКнопокОсновная.Видимость = Не ДлительнаяОперация;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьИнформациюОСообщенииИзАрхива()
	
	ЗаполнитьИнформациюОСообщенииИзАрхиваНаСервере();
	
КонецПроцедуры  

&НаСервере
Процедура ЗаполнитьИнформациюОСообщенииИзАрхиваНаСервере()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	АрхивСообщенийОбменовСрезПоследних.Период КАК Период
	|ИЗ
	|	РегистрСведений.АрхивСообщенийОбменов.СрезПоследних(, УзелИнформационнойБазы = &УзелИнформационнойБазы) КАК АрхивСообщенийОбменовСрезПоследних";
	
	Запрос.УстановитьПараметр("УзелИнформационнойБазы", УзелИнформационнойБазы);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда 
		Элементы.ОткрытьСообщениеИзАрхива.Заголовок = НСтр("ru = '<Сообщение в архиве отсутствует>';
															|en = '<Сообщение в архиве отсутствует>'");
		Элементы.ПродолжитьЗагрузкуСообщениемИзАрхива.ТолькоПросмотр = Истина;
		
		ПродолжитьЗагрузкуСообщениемИзАрхива = Ложь;
		ПериодЗаписиАрхивногоСообщения = Дата(1,1,1);
	Иначе
		Выборка = РезультатЗапроса.Выбрать();
		Выборка.Следующий();
		
		Элементы.ОткрытьСообщениеИзАрхива.Заголовок = СтрШаблон(НСтр("ru = 'Архивное сообщение от %1.';
																	|en = 'Архивное сообщение от %1.'"), Формат(Выборка.Период, "ДЛФ=DT"));
		Элементы.ПродолжитьЗагрузкуСообщениемИзАрхива.ТолькоПросмотр = Ложь;
		
		ПериодЗаписиАрхивногоСообщения = Выборка.Период;
	КонецЕсли; 
	
КонецПроцедуры

&НаСервере
Процедура СохранитьСообщениеИзАрхиваВКэш()

	ОбменДаннымиСервер.СохранитьСообщениеИзАрхиваВКэш(УзелИнформационнойБазы);
	
КонецПроцедуры

#КонецОбласти