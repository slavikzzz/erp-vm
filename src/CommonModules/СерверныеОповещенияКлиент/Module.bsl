///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Проверка завершения периодического ожидания для обработчиков
// события ПередПериодическойОтправкойДанныхКлиентаНаСервер.
//
// Параметры:
//  ИмяСчетчика   - Строка - например, "СтандартныеПодсистемы.ЦентрМониторинга".
//  ВремяОжидания - Число - количество секунд ожидания до срабатывания счетчика.
//  ПервыйРаз     - Булево - если Истина, то возвращает Истина после инициализации.
//  ДатаСеанса    - Дата - возвращаемое значение (если требуется нестандартный счетчик).
//
// Возвращаемое значение:
//  Булево - Истина, если закончилось время с последнего отсчета и начат новый отсчет.
//
// Пример:
//	ИмяСчетчика = "СтандартныеПодсистемы.ЦентрМониторинга";
//	Если Не СерверныеОповещенияКлиент.ЗакончилосьВремяОжидания(ИмяСчетчика) Тогда
//		Возврат;
//	КонецЕсли;
//
Функция ЗакончилосьВремяОжидания(ИмяСчетчика, ВремяОжидания = 1200, ПервыйРаз = Ложь, ДатаСеанса = '00010101') Экспорт
	
	СостояниеПолучения = СостояниеПолучения();
	ДатаСеанса = СостояниеПолучения.ТекущаяДатаСеансаДляПроверкиСчетчиковОжидания;
	Если Не ЗначениеЗаполнено(ИмяСчетчика) Тогда
		Возврат Ложь;
	КонецЕсли;
	СчетчикиОжидания = СостояниеПолучения.СчетчикиОжидания;
	
	ПоследняяДата = СчетчикиОжидания.Получить(ИмяСчетчика);
	Если ПоследняяДата = Неопределено Тогда
		СчетчикиОжидания.Вставить(ИмяСчетчика, ДатаСеанса);
		Возврат ПервыйРаз;
	КонецЕсли;
	
	Если ПоследняяДата + ВремяОжидания > ДатаСеанса Тогда
		Возврат Ложь;
	КонецЕсли;
	
	СчетчикиОжидания.Вставить(ИмяСчетчика, ДатаСеанса);
	Возврат Истина;
	
КонецФункции

// Регистрирует ошибку в журнале регистрации, пойманную в обработчиках событий
// ПередПериодическойОтправкойДанныхКлиентаНаСервер и
// ПослеПериодическогоПолученияДанныхКлиентаНаСервере.
//
// Параметры:
//  ИнформацияОбОшибке - ИнформацияОбОшибке
//
// Пример:
//	МоментНачала = ТекущаяУниверсальнаяДатаВМиллисекундах();
//	Попытка
//		Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ЦентрМониторинга") Тогда
//			МодульЦентрМониторингаКлиентСлужебный = ОбщегоНазначенияКлиент.ОбщийМодуль("ЦентрМониторингаКлиентСлужебный");
//			МодульЦентрМониторингаКлиентСлужебный.ПередПериодическойОтправкойДанныхКлиентаНаСервер(Параметры);
//		КонецЕсли;
//	Исключение
//		СерверныеОповещенияКлиент.ОбработатьОшибку(ИнформацияОбОшибке());
//	КонецПопытки;
//	СерверныеОповещенияКлиент.ДобавитьПоказатель(МоментНачала,
//		"ЦентрМониторингаКлиентСлужебный.ПередПериодическойОтправкойДанныхКлиентаНаСервер");
//
Процедура ОбработатьОшибку(ИнформацияОбОшибке) Экспорт
	
	ЖурналРегистрацииКлиент.ДобавитьСообщениеДляЖурналаРегистрации(
		НСтр("ru = 'Серверные оповещения.Ошибка получения или обработки оповещений';
			|en = 'Server notifications.Error getting or processing notifications'",
			ОбщегоНазначенияКлиент.КодОсновногоЯзыка()),
		"Ошибка",
		ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке));
	
КонецПроцедуры

// Добавляет показатель производительности в обработчиках событий
// ПередПериодическойОтправкойДанныхКлиентаНаСервер и
// ПослеПериодическогоПолученияДанныхКлиентаНаСервере.
//
// Параметры:
//  МоментНачала - Число - ТекущаяУниверсальнаяДатаВМиллисекундах перед вызовом процедуры.
//  ИмяПроцедуры - Строка - полное имя вызываемой процедуры
//
// Пример:
//	МоментНачала = ТекущаяУниверсальнаяДатаВМиллисекундах();
//	Попытка
//		Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ЦентрМониторинга") Тогда
//			МодульЦентрМониторингаКлиентСлужебный = ОбщегоНазначенияКлиент.ОбщийМодуль("ЦентрМониторингаКлиентСлужебный");
//			МодульЦентрМониторингаКлиентСлужебный.ПередПериодическойОтправкойДанныхКлиентаНаСервер(Параметры);
//		КонецЕсли;
//	Исключение
//		СерверныеОповещенияКлиент.ОбработатьОшибку(ИнформацияОбОшибке());
//	КонецПопытки;
//	СерверныеОповещенияКлиент.ДобавитьПоказатель(МоментНачала,
//		"ЦентрМониторингаКлиентСлужебный.ПередПериодическойОтправкойДанныхКлиентаНаСервер");
//
Процедура ДобавитьПоказатель(МоментНачала, ИмяПроцедуры) Экспорт
	
	Показатели = ПараметрыПриложения.Получить(ИмяПараметраВложенныхПоказателей());
	ДобавитьОсновнойПоказатель(Показатели, МоментНачала, ИмяПроцедуры, , Истина);
	
КонецПроцедуры

#Область ДляВызоваИзДругихПодсистем

// Возвращает строковый уникальный ключ текущего сеанса,
// полученный из свойств сеанса НачалоСеанса и НомерСеанса.
//
// Возвращаемое значение:
//   см. СерверныеОповещения.КлючСеанса
//
Функция КлючСеанса() Экспорт
	
	Возврат СостояниеПолучения().КлючСеанса;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Параметры:
//  Интервал - Число
//  ПолучитьСейчас - Булево - если указать Истина, тогда при очередной проверке
//                     будет серверный вызов с получением накопленных оповещений.
//
Процедура ПодключитьОбработчикПроверкиПолученияСерверныхОповещений(Интервал = 1, ПолучитьСейчас = Ложь) Экспорт
	
	Если Интервал < 1 Тогда
		Интервал = 1;
	ИначеЕсли Интервал > 60 Тогда
		Интервал = 60;
	КонецЕсли;
	
	Если ПолучитьСейчас Тогда
		СостояниеПолучения().ПолучитьСейчас = Истина;
	КонецЕсли;
	
	ПодключитьОбработчикОжидания("ОбработчикПроверкиПолученияСерверныхОповещений", Интервал);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий подсистем конфигурации.

// См. ОбщегоНазначенияКлиентПереопределяемый.ПередНачаломРаботыСистемы.
Процедура ПередНачаломРаботыСистемы(Параметры) Экспорт
	
	ПараметрыКлиента = СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиентаПриЗапуске();
	
	Если Не ПараметрыКлиента.Свойство("СерверныеОповещения") Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыСерверныхОповещений = ПараметрыКлиента.СерверныеОповещения; // см. СерверныеОповещения.ПараметрыСерверныхОповещенийЭтогоСеанса
	СостояниеПолучения = СостояниеПолучения();
	ЗаполнитьЗначенияСвойств(СостояниеПолучения, ПараметрыСерверныхОповещений);
	Параметры.ПолученныеПараметрыКлиента.Вставить("СерверныеОповещения");
	Параметры.КоличествоПолученныхПараметровКлиента = Параметры.КоличествоПолученныхПараметровКлиента + 1;
	
	ДатаСеанса = ОбщегоНазначенияКлиент.ДатаСеанса();
	СостояниеПолучения.ДатаОбновленияСостояния = ДатаСеанса;
	СостояниеПолучения.ДатаПоследнегоПолученияСообщения = ДатаСеанса;
	СостояниеПолучения.ДатаПоследнегоСерверногоВызова = ДатаСеанса;
	СостояниеПолучения.ЧислоСекундВыравниванияДатыСчетчиковОжидания = Секунда(ДатаСеанса);
	СостояниеПолучения.ТекущаяДатаСеансаДляПроверкиСчетчиковОжидания = ДатаСеанса;
	
	СостояниеПолучения.ПроверкаРазрешена = Истина;
	ПодключитьОбработчикПроверкиПолученияСерверныхОповещений();
	
КонецПроцедуры

// См. ОбщегоНазначенияКлиентПереопределяемый.ПослеНачалаРаботыСистемы.
Процедура ПослеНачалаРаботыСистемы() Экспорт
	
	СостояниеПолучения = СостояниеПолучения();
	СостояниеПолучения.ПериодическаяОтправкаДанныхРазрешена = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПроверитьПолучитьСерверныеОповещения() Экспорт
	
	МоментНачала = ТекущаяУниверсальнаяДатаВМиллисекундах();
	СостояниеПолучения = СостояниеПолучения();
	Показатели = ?(СостояниеПолучения.РегистрироватьПоказатели, Новый Массив, Неопределено);
	Если Показатели <> Неопределено Тогда
		Если ПараметрыПриложения = Неопределено Тогда
			ПараметрыПриложения = Новый Соответствие;
		КонецЕсли;
		ПараметрыПриложения.Вставить(ИмяПараметраВложенныхПоказателей(), Новый Массив);
	КонецЕсли;
	
	Попытка
		ПроверитьПолучитьСерверныеОповещенияСПоказателями(СостояниеПолучения, Показатели);
	Исключение
		СерверныеВызовыРазрешены = Истина;
		Попытка
			СтандартныеПодсистемыВызовСервера.ИмяОбъектаМетаданных(Тип("Неопределено"));
		Исключение
			СерверныеВызовыРазрешены = Ложь;
		КонецПопытки;
		Если Не СерверныеВызовыРазрешены Тогда
			ПодключитьОбработчикПроверкиПолученияСерверныхОповещений(15);
			Возврат;
		КонецЕсли;
		ВызватьИсключение;
	КонецПопытки;
	
	ДобавитьОсновнойПоказатель(Показатели, МоментНачала,
		"СерверныеОповещенияКлиент.ПроверитьПолучитьСерверныеОповещения", Истина);
	
КонецПроцедуры

Процедура ПроверитьПолучитьСерверныеОповещенияСПоказателями(СостояниеПолучения, Показатели);
	
	Если Не СостояниеПолучения.ПроверкаРазрешена Тогда
		Возврат;
	КонецЕсли;
	
	ДополнительныеПараметры = Новый Соответствие;
	ТекущаяДатаСеанса = ОбщегоНазначенияКлиент.ДатаСеанса();
	СостояниеПолучения.ТекущаяДатаСеансаДляПроверкиСчетчиковОжидания = НачалоМинуты(ТекущаяДатаСеанса)
		+ СостояниеПолучения.ЧислоСекундВыравниванияДатыСчетчиковОжидания
		- ?(Секунда(ТекущаяДатаСеанса) < СостояниеПолучения.ЧислоСекундВыравниванияДатыСчетчиковОжидания, 60, 0);
	
	Интервал = 60;
	ОбсужденияАктивны =
		СостояниеПолучения.ПериодическаяОтправкаДанныхРазрешена
		И (СостояниеПолучения.УведомленияКлиентаДоступны
		   Или СостояниеПолучения.СистемаВзаимодействийПодключена
		     И СостояниеПолучения.ОбработчикНовыхЛичныхСообщенийПодключен
		     И СостояниеПолучения.ДатаПоследнегоПолученияСообщения + 60 > ТекущаяДатаСеанса);
	
	МоментНачала = ТекущаяУниверсальнаяДатаВМиллисекундах();
	Попытка
		ДлительныеОперацииКлиент.ПередПериодическойОтправкойДанныхКлиентаНаСервер(ДополнительныеПараметры,
			ОбсужденияАктивны, Интервал);
	Исключение
		ОбработатьОшибку(ИнформацияОбОшибке());
	КонецПопытки;
	ДобавитьОсновнойПоказатель(Показатели, МоментНачала,
		"ДлительныеОперацииКлиент.ПередПериодическойОтправкойДанныхКлиентаНаСервер");
	
	МоментНачала = ТекущаяУниверсальнаяДатаВМиллисекундах();
	ОповещенияПолучены = ОповещенияПолучены(СостояниеПолучения);
	ДобавитьОсновнойПоказатель(Показатели, МоментНачала, "СерверныеОповещенияКлиент.ОповещенияПолучены");
	
	ИмяКлючаПараметровОбсуждений = "СтандартныеПодсистемы.БазоваяФункциональность.СерверныеОповещения.ИдентификаторыОбсуждений";
	ПериодическаяОтправкаДанных = ЗакончилосьВремяОжидания(
		"СтандартныеПодсистемы.БазоваяФункциональность.СерверныеОповещения.ПериодическаяОтправкаДанных",
		СостояниеПолучения.МинимальныйИнтервалПериодическойОтправкиДанных * 60);
	
	Если ПериодическаяОтправкаДанных Тогда
		Если СостояниеПолучения.ПериодическаяОтправкаДанныхРазрешена Тогда
			МоментНачала = ТекущаяУниверсальнаяДатаВМиллисекундах();
			Попытка
				ИнтеграцияПодсистемБСПКлиент.ПередПериодическойОтправкойДанныхКлиентаНаСервер(
					ДополнительныеПараметры);
			Исключение
				ОбработатьОшибку(ИнформацияОбОшибке());
			КонецПопытки;
			ДобавитьОсновнойПоказатель(Показатели, МоментНачала,
				"ИнтеграцияПодсистемБСПКлиент.ПередПериодическойОтправкойДанныхКлиентаНаСервер");
			
			МоментНачала = ТекущаяУниверсальнаяДатаВМиллисекундах();
			Попытка
				ОбщегоНазначенияКлиентПереопределяемый.ПередПериодическойОтправкойДанныхКлиентаНаСервер(
					ДополнительныеПараметры);
			Исключение
				ОбработатьОшибку(ИнформацияОбОшибке());
			КонецПопытки;
			ДобавитьОсновнойПоказатель(Показатели, МоментНачала,
				"ОбщегоНазначенияКлиентПереопределяемый.ПередПериодическойОтправкойДанныхКлиентаНаСервер");
		КонецЕсли;
		
		МоментНачала = ТекущаяУниверсальнаяДатаВМиллисекундах();
		Попытка
			Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ЗавершениеРаботыПользователей") Тогда
				МодульСоединенияИБКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("СоединенияИБКлиент");
				МодульСоединенияИБКлиент.ПередПериодическойОтправкойДанныхКлиентаНаСервер(ДополнительныеПараметры,
					ОповещенияПолучены);
			КонецЕсли;
		Исключение
			ОбработатьОшибку(ИнформацияОбОшибке());
		КонецПопытки;
		ДобавитьОсновнойПоказатель(Показатели, МоментНачала,
			"СоединенияИБКлиент.ПередПериодическойОтправкойДанныхКлиентаНаСервер");
		
		Если СостояниеПолучения.СеансАдминистратораСервиса Тогда
			ИмяПараметра = "СтандартныеПодсистемы.БазоваяФункциональность.СерверныеОповещения.УдалениеУстаревшихОповещений";
			Если ЗакончилосьВремяОжидания(ИмяПараметра) Тогда
				ДополнительныеПараметры.Вставить(ИмяПараметра, Истина);
			КонецЕсли;
		КонецЕсли;
		
		Если СостояниеПолучения.ИдентификаторЛичногоОбсуждения = Неопределено
		   И СостояниеПолучения.СистемаВзаимодействийПодключена
		   И ЗакончилосьВремяОжидания(ИмяКлючаПараметровОбсуждений, 300, Истина) Тогда
			
			ДополнительныеПараметры.Вставить(ИмяКлючаПараметровОбсуждений, Истина);
		КонецЕсли;
	КонецЕсли;
	
	Если СостояниеПолучения.ДатаПоследнегоСерверногоВызова + 60 < ТекущаяДатаСеанса Тогда
		СообщенияДляЖурналаРегистрации = ПараметрыПриложения["СтандартныеПодсистемы.СообщенияДляЖурналаРегистрации"];
	КонецЕсли;
	
	Если ОповещенияПолучены
	   И Не СостояниеПолучения.ПолучитьСейчас
	   И Не ЗначениеЗаполнено(ДополнительныеПараметры)
	   И Не ЗначениеЗаполнено(СообщенияДляЖурналаРегистрации) Тогда
		
		ПодключитьОбработчикПроверкиПолученияСерверныхОповещений(Интервал);
		Возврат;
	КонецЕсли;
	
	ПараметрыОбщегоВызова = НовыеПараметрыОбщегоСерверногоВызова();
	ПараметрыОбщегоВызова.ДатаПоследнегоОповещения = СостояниеПолучения.ДатаПоследнегоОповещения;
	Если ЗначениеЗаполнено(ДополнительныеПараметры) Тогда
		ПараметрыОбщегоВызова.Вставить("ДополнительныеПараметры", ДополнительныеПараметры);
	КонецЕсли;
	Если ПериодическаяОтправкаДанных Тогда
		ПараметрыОбщегоВызова.Вставить("ПериодическаяОтправкаДанных",
			СостояниеПолучения.ПериодическаяОтправкаДанныхРазрешена);
	КонецЕсли;
	НовыеСообщения = ПараметрыПриложения["СтандартныеПодсистемы.СообщенияДляЖурналаРегистрации"];
	Если ЗначениеЗаполнено(НовыеСообщения) Тогда
		ПараметрыОбщегоВызова.Вставить("СообщенияДляЖурналаРегистрации", НовыеСообщения);
	КонецЕсли;
	Если Показатели <> Неопределено Тогда
		ПараметрыОбщегоВызова.Вставить("РегистрироватьПоказатели", Истина);
	КонецЕсли;
	
	МоментНачала = ТекущаяУниверсальнаяДатаВМиллисекундах();
	РезультатОбщегоВызова = СерверныеОповещенияСлужебныйВызовСервера.НедоставленныеСерверныеОповещенияСеанса(
		ПараметрыОбщегоВызова);
	ДобавитьОсновнойПоказатель(Показатели, МоментНачала,
		"СерверныеОповещенияСлужебныйВызовСервера.НедоставленныеСерверныеОповещенияСеанса");
	
	Если НовыеСообщения <> Неопределено Тогда
		НовыеСообщения.Очистить();
	КонецЕсли;
	
	Если РезультатОбщегоВызова.Свойство("Показатели") Тогда
		ОбщегоНазначенияКлиентСервер.ДополнитьМассив(Показатели, РезультатОбщегоВызова.Показатели);
	КонецЕсли;
	
	Если РезультатОбщегоВызова.Свойство("СерверныеОповещения") Тогда
		МоментНачала = ТекущаяУниверсальнаяДатаВМиллисекундах();
		Для Каждого СерверноеОповещение Из РезультатОбщегоВызова.СерверныеОповещения Цикл
			ОбработатьСерверноеОповещениеНаКлиенте(СостояниеПолучения, СерверноеОповещение);
		КонецЦикла;
		ДобавитьОсновнойПоказатель(Показатели, МоментНачала,
			"СерверныеОповещенияКлиент.ОбработатьСерверноеОповещениеНаКлиенте");
	КонецЕсли;
	СостояниеПолучения.ПолучитьСейчас = Ложь;
	
	ДополнительныеРезультаты = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(РезультатОбщегоВызова,
		"ДополнительныеРезультаты", Новый Соответствие);
	
	МоментНачала = ТекущаяУниверсальнаяДатаВМиллисекундах();
	Попытка
		ДлительныеОперацииКлиент.ПослеПериодическогоПолученияДанныхКлиентаНаСервере(
			ДополнительныеРезультаты, ОбсужденияАктивны, Интервал);
	Исключение
		ОбработатьОшибку(ИнформацияОбОшибке());
	КонецПопытки;
	ДобавитьОсновнойПоказатель(Показатели, МоментНачала,
		"ДлительныеОперацииКлиент.ПослеПериодическогоПолученияДанныхКлиентаНаСервере");
	
	Если ПериодическаяОтправкаДанных Тогда
		Если СостояниеПолучения.ПериодическаяОтправкаДанныхРазрешена Тогда
			МоментНачала = ТекущаяУниверсальнаяДатаВМиллисекундах();
			Попытка
				ИнтеграцияПодсистемБСПКлиент.ПослеПериодическогоПолученияДанныхКлиентаНаСервере(
					ДополнительныеРезультаты);
			Исключение
				ОбработатьОшибку(ИнформацияОбОшибке());
			КонецПопытки;
			ДобавитьОсновнойПоказатель(Показатели, МоментНачала,
				"ИнтеграцияПодсистемБСПКлиент.ПослеПериодическогоПолученияДанныхКлиентаНаСервере");
			
			МоментНачала = ТекущаяУниверсальнаяДатаВМиллисекундах();
			Попытка
				ОбщегоНазначенияКлиентПереопределяемый.ПослеПериодическогоПолученияДанныхКлиентаНаСервере(
					ДополнительныеРезультаты);
			Исключение
				ОбработатьОшибку(ИнформацияОбОшибке());
			КонецПопытки;
			ДобавитьОсновнойПоказатель(Показатели, МоментНачала,
				"ОбщегоНазначенияКлиентПереопределяемый.ПослеПериодическогоПолученияДанныхКлиентаНаСервере");
		КонецЕсли;
		
		МоментНачала = ТекущаяУниверсальнаяДатаВМиллисекундах();
		Попытка
			Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ЗавершениеРаботыПользователей") Тогда
				МодульСоединенияИБКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("СоединенияИБКлиент");
				МодульСоединенияИБКлиент.ПослеПериодическогоПолученияДанныхКлиентаНаСервере(
					ДополнительныеРезультаты);
			КонецЕсли;
		Исключение
			ОбработатьОшибку(ИнформацияОбОшибке());
		КонецПопытки;
		ДобавитьОсновнойПоказатель(Показатели, МоментНачала,
			"СоединенияИБКлиент.ПослеПериодическогоПолученияДанныхКлиентаНаСервере");
		
		ИдентификаторыОбсуждений = ДополнительныеРезультаты.Получить(ИмяКлючаПараметровОбсуждений);
		Если ИдентификаторыОбсуждений <> Неопределено Тогда
			ЗаполнитьЗначенияСвойств(СостояниеПолучения, ИдентификаторыОбсуждений);
			МоментНачала = ТекущаяУниверсальнаяДатаВМиллисекундах();
			ПодключитьОбработчикНовыхСообщений(СостояниеПолучения);
			ДобавитьОсновнойПоказатель(Показатели, МоментНачала,
				"СерверныеОповещенияКлиент.ПодключитьОбработчикНовыхСообщений");
		КонецЕсли;
		
		Если РезультатОбщегоВызова.Свойство("СистемаВзаимодействийПодключена") Тогда
			СостояниеПолучения.СистемаВзаимодействийПодключена = РезультатОбщегоВызова.СистемаВзаимодействийПодключена;
		КонецЕсли;
	КонецЕсли;
	
	Если РезультатОбщегоВызова.Свойство("ДатаПоследнегоОповещения") Тогда
		СостояниеПолучения.ДатаПоследнегоОповещения = РезультатОбщегоВызова.ДатаПоследнегоОповещения;
	КонецЕсли;
	Если РезультатОбщегоВызова.Свойство("МинимальныйПериодПроверки") Тогда
		СостояниеПолучения.МинимальныйПериод = РезультатОбщегоВызова.МинимальныйПериодПроверки;
	КонецЕсли;
	СостояниеПолучения.ДатаОбновленияСостояния = ОбщегоНазначенияКлиент.ДатаСеанса();
	СостояниеПолучения.ДатаПоследнегоСерверногоВызова = СостояниеПолучения.ДатаОбновленияСостояния;
	
	Если Интервал > СостояниеПолучения.МинимальныйПериод Тогда
		Интервал = СостояниеПолучения.МинимальныйПериод;
	КонецЕсли;
	
	ПодключитьОбработчикПроверкиПолученияСерверныхОповещений(Интервал);
	
КонецПроцедуры

Процедура ДобавитьОсновнойПоказатель(Показатели, МоментНачала, ИмяПроцедуры,
			Общий = Ложь, Вложенный = Ложь, Длительность = 0)
	
	Если Показатели = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Длительность = ТекущаяУниверсальнаяДатаВМиллисекундах() - МоментНачала;
	Если Не Общий И Не ЗначениеЗаполнено(Длительность) Тогда
		Возврат;
	КонецЕсли;
	
	Текст = Формат(Длительность / 1000, "ЧЦ=6; ЧДЦ=3; ЧН=000,000; ЧВН=") + " " + ИмяПроцедуры;
	
	Если Общий Тогда
		Показатели.Вставить(0, Текст);
		ЗаписатьПоказатели(Показатели, Длительность);
		Возврат;
	Иначе
		Показатели.Добавить("  " + Текст);
	КонецЕсли;
	
	Если Вложенный Тогда
		Возврат;
	КонецЕсли;
	
	ВложенныеПоказатели = ПараметрыПриложения.Получить(ИмяПараметраВложенныхПоказателей());
	Для Каждого ВложенныйПоказатель Из ВложенныеПоказатели Цикл
		Показатели.Добавить("  " + ВложенныйПоказатель);
	КонецЦикла;
	ВложенныеПоказатели.Очистить();
	
КонецПроцедуры

Функция ИмяПараметраВложенныхПоказателей()
	Возврат "СтандартныеПодсистемы.БазоваяФункциональность.СерверныеОповещения.Показатели";
КонецФункции

Процедура ЗаписатьПоказатели(Показатели, ОбщаяДлительность)
	
	Комментарий = СтрСоединить(Показатели, Символы.ПС);
	ИмяМетодаВызоваСервера = "СерверныеОповещенияСлужебныйВызовСервера.НедоставленныеСерверныеОповещенияСеанса";
	
	Если ОбщаяДлительность < 50
	   И СтрНайти(Комментарий, ИмяМетодаВызоваСервера) = 0 Тогда
		Возврат;
	КонецЕсли;
	
	СерверныеОповещенияСлужебныйВызовСервера.ЗаписатьПоказателиПроизводительности(Комментарий);
	
КонецПроцедуры

Процедура ОбработатьСерверноеОповещениеНаКлиенте(СостояниеПолучения, СерверноеОповещение)
	
	Если ОповещениеУжеПолучено(СостояниеПолучения, СерверноеОповещение) Тогда
		Возврат;
	КонецЕсли;
	
	ИмяОповещения = СерверноеОповещение.ИмяОповещения;
	Результат     = СерверноеОповещение.Результат;
	
	Если ИмяОповещения = "СтандартныеПодсистемы.БазоваяФункциональность.СерверныеОповещения.РегистрироватьПоказатели" Тогда
		СостояниеПолучения.РегистрироватьПоказатели = (Результат = Истина);
		Возврат;
	ИначеЕсли ИмяОповещения = "СтандартныеПодсистемы.БазоваяФункциональность.СерверныеОповещения.СистемаВзаимодействийПодключена" Тогда
		СостояниеПолучения.СистемаВзаимодействийПодключена = (Результат = Истина);
		Возврат;
	КонецЕсли;
	
	Оповещение = СостояниеПолучения.Оповещения.Получить(ИмяОповещения);
	Если Оповещение = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	МодульОбработки = ОбщегоНазначенияКлиент.ОбщийМодуль(Оповещение.ИмяМодуляПолучения);
	Попытка
		МодульОбработки.ПриПолученииСерверногоОповещения(ИмяОповещения, Результат);
	Исключение
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Процедура ""%1"" не выполнена по причине:
			           |%2';
			           |en = 'Cannot execute the ""%1"" procedure due to:
			           |%2'"),
			Оповещение.ИмяМодуляПолучения + ".ПриПолученииСерверногоОповещения",
			ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке));
		ЖурналРегистрацииКлиент.ДобавитьСообщениеДляЖурналаРегистрации(
			НСтр("ru = 'Серверные оповещения.Ошибка обработки полученного оповещения';
				|en = 'Server notifications.An error occurred when processing the received message'",
				ОбщегоНазначенияКлиент.КодОсновногоЯзыка()),
			"Ошибка",
			ТекстОшибки);
	КонецПопытки;
	
КонецПроцедуры

Функция ОповещенияПолучены(СостояниеПолучения)
	
	ПодключитьОбработчикНовыхСообщений(СостояниеПолучения);
	
	Граница = СостояниеПолучения.ДатаОбновленияСостояния + СостояниеПолучения.МинимальныйПериод;
	
	Запас = Граница - ОбщегоНазначенияКлиент.ДатаСеанса();
	
	Если Запас > 0 Тогда
		Возврат Истина;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

// См. НовоеСостояниеПолучения
Функция СостояниеПолучения() Экспорт
	
	ИмяПараметраПриложения = "СтандартныеПодсистемы.БазоваяФункциональность.СерверныеОповещения";
	СостояниеПолучения = ПараметрыПриложения.Получить(ИмяПараметраПриложения);
	Если СостояниеПолучения = Неопределено Тогда
		СостояниеПолучения = НовоеСостояниеПолучения();
		ПараметрыПриложения.Вставить(ИмяПараметраПриложения, СостояниеПолучения);
	КонецЕсли;
	
	Возврат СостояниеПолучения;
	
КонецФункции

// Возвращаемое значение:
//  Структура:
//   * ДатаПоследнегоОповещения - Дата
//   * ДополнительныеПараметры - Соответствие
//   * СообщенияДляЖурналаРегистрации - Неопределено, СписокЗначений
//   * ПериодическаяОтправкаДанных - Булево
//   * РегистрироватьПоказатели - Булево
//
Функция НовыеПараметрыОбщегоСерверногоВызова() Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("ДатаПоследнегоОповещения",  '00010101');
	
	Возврат Результат;
	
КонецФункции

// Возвращаемое значение:
//  Структура:
//   * ПроверкаРазрешена - Булево - устанавливается Истина в процедуре ПередНачаломРаботыСистемы.
//   * РегистрироватьПоказатели - Булево
//   * СеансАдминистратораСервиса - Булево
//   * ПериодическаяОтправкаДанныхРазрешена - Булево - устанавливается Истина в процедуре ПослеНачалаРаботыСистемы.
//   * МинимальныйИнтервалПериодическойОтправкиДанных - см. СерверныеОповещения.МинимальныйИнтервалПериодическойОтправкиДанных
//   * КлючСеанса - см. СерверныеОповещения.КлючСеанса
//   * ИдентификаторПользователяИБ - УникальныйИдентификатор
//   * ДатаОбновленияСостояния - Дата
//   * ДатаПоследнегоПолученияСообщения - Дата
//   * МинимальныйПериод - Число - число секунд.
//   * ДатаПоследнегоОповещения - Дата
//   * Оповещения - см. ОбщегоНазначенияПереопределяемый.ПриДобавленииСерверныхОповещений.Оповещения
//   * ПолученныеОповещения - Массив из Строка - строки уникальных идентификаторов полученных сообщений.
//   * УведомленияКлиентаДоступны - Булево
//   * СистемаВзаимодействийПодключена - Булево
//   * ИдентификаторЛичногоОбсуждения - Неопределено - обсуждение недоступно.
//                                    - ИдентификаторОбсужденияСистемыВзаимодействия - идентификатор
//        обсуждения "СерверныеОповещения <Идентификатор пользователя ИБ>".
//
//   * ИдентификаторОбщегоОбсуждения - Неопределено - обсуждение недоступно.
//                                   - ИдентификаторОбсужденияСистемыВзаимодействия - идентификатор
//        обсуждения "СерверныеОповещения".
//   * ОбработчикНовыхЛичныхСообщенийПодключен - Булево
//   * ОбработчикНовыхОбщихСообщенийПодключен - Булево
//   * ДатаПоследнегоСерверногоВызова - Дата
//   * ТекущаяДатаСеансаДляПроверкиСчетчиковОжидания - Дата
//   * ЧислоСекундВыравниванияДатыСчетчиковОжидания - Число
//   * СчетчикиОжидания - Соответствие из КлючИЗначение:
//      ** Ключ - Строка - имя счетчика
//      ** Значение - Дата - последнее срабатывание счетчика
//   * ПолучитьСейчас - Булево - если Истина, то серверный вызов будет безусловно.
//
Функция НовоеСостояниеПолучения()
	
	Состояние = Новый Структура;
	Состояние.Вставить("ПроверкаРазрешена", Ложь);
	Состояние.Вставить("РегистрироватьПоказатели", Ложь);
	Состояние.Вставить("СеансАдминистратораСервиса", Ложь);
	Состояние.Вставить("ПериодическаяОтправкаДанныхРазрешена", Ложь);
	Состояние.Вставить("МинимальныйИнтервалПериодическойОтправкиДанных", 1);
	Состояние.Вставить("КлючСеанса", "");
	Состояние.Вставить("ИдентификаторПользователяИБ",
		ОбщегоНазначенияКлиентСервер.ПустойУникальныйИдентификатор());
	Состояние.Вставить("ДатаОбновленияСостояния", '00010101');
	Состояние.Вставить("ДатаПоследнегоПолученияСообщения", '00010101');
	Состояние.Вставить("МинимальныйПериод", 60);
	Состояние.Вставить("ДатаПоследнегоОповещения", '00010101');
	Состояние.Вставить("Оповещения", Новый Соответствие);
	Состояние.Вставить("ПолученныеОповещения", Новый Массив);
	Состояние.Вставить("УведомленияКлиентаДоступны",
		СерверныеОповещенияСлужебныйКлиентСервер.УведомленияКлиентаДоступны());
	Состояние.Вставить("СистемаВзаимодействийПодключена", Ложь);
	Состояние.Вставить("ИдентификаторЛичногоОбсуждения", Неопределено);
	Состояние.Вставить("ИдентификаторОбщегоОбсуждения", Неопределено);
	Состояние.Вставить("ОбработчикНовыхЛичныхСообщенийПодключен", Ложь);
	Состояние.Вставить("ОбработчикНовыхОбщихСообщенийПодключен", Ложь);
	Состояние.Вставить("ДатаПоследнегоСерверногоВызова", '00010101');
	Состояние.Вставить("ТекущаяДатаСеансаДляПроверкиСчетчиковОжидания", '00010101');
	Состояние.Вставить("ЧислоСекундВыравниванияДатыСчетчиковОжидания", 0);
	Состояние.Вставить("СчетчикиОжидания", Новый Соответствие);
	Состояние.Вставить("ПолучитьСейчас", Ложь);
	
	Возврат Состояние;
	
КонецФункции

Процедура ПодключитьОбработчикНовыхСообщений(СостояниеПолучения)
	
	Контекст = Новый Структура("СостояниеПолучения", СостояниеПолучения);
	
	Если СостояниеПолучения.УведомленияКлиентаДоступны Тогда
		МенеджерУведомленийКлиента().ПодключитьОбработчик(
			СерверныеОповещенияСлужебныйКлиентСервер.КлючУведомленийСерверныхОповещений(),
			Новый ОписаниеОповещения("ПриПолученииНовогоУведомленияКлиента", ЭтотОбъект, Контекст,
				"ПриОшибкеПолученияНовогоУведомленияКлиента", ЭтотОбъект));
		Возврат;
	КонецЕсли;
	
	Если СостояниеПолучения.ИдентификаторЛичногоОбсуждения <> Неопределено
	   И Не СостояниеПолучения.ОбработчикНовыхЛичныхСообщенийПодключен Тогда
		
		Попытка
			СистемаВзаимодействия.НачатьПодключениеОбработчикаНовыхСообщений(
				Новый ОписаниеОповещения("ПослеПодключенияОбработчикаНовыхЛичныхСообщений", ЭтотОбъект, Контекст,
					"ПослеОшибкиПодключенияОбработчикаНовыхЛичныхСообщений", ЭтотОбъект),
				СостояниеПолучения.ИдентификаторЛичногоОбсуждения,
				Новый ОписаниеОповещения("ПриПолученииНовогоЛичногоСообщенияСистемыВзаимодействия", ЭтотОбъект, Контекст,
					"ПриОшибкеПолученияНовогоЛичногоСообщенияСистемыВзаимодействия", ЭтотОбъект),
				Неопределено);
		Исключение
			ПослеОшибкиПодключенияОбработчикаНовыхЛичныхСообщений(ИнформацияОбОшибке(), Ложь, Контекст);
		КонецПопытки;
	КонецЕсли;
	
	Если СостояниеПолучения.ИдентификаторОбщегоОбсуждения <> Неопределено
	   И Не СостояниеПолучения.ОбработчикНовыхОбщихСообщенийПодключен Тогда
		
		Попытка
			СистемаВзаимодействия.НачатьПодключениеОбработчикаНовыхСообщений(
				Новый ОписаниеОповещения("ПослеПодключенияОбработчикаНовыхОбщихСообщений", ЭтотОбъект, Контекст,
					"ПослеОшибкиПодключенияОбработчикаНовыхОбщихСообщений", ЭтотОбъект),
				СостояниеПолучения.ИдентификаторОбщегоОбсуждения,
				Новый ОписаниеОповещения("ПриПолученииНовогоОбщегоСообщенияСистемыВзаимодействия", ЭтотОбъект, Контекст,
					"ПриОшибкеПолученияНовогоОбщегоСообщенияСистемыВзаимодействия", ЭтотОбъект),
				Неопределено);
		Исключение
			ПослеОшибкиПодключенияОбработчикаНовыхОбщихСообщений(ИнформацияОбОшибке(), Ложь, Контекст);
		КонецПопытки;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПослеПодключенияОбработчикаНовыхЛичныхСообщений(Контекст) Экспорт
	
	Контекст.СостояниеПолучения.ОбработчикНовыхЛичныхСообщенийПодключен = Истина;
	
КонецПроцедуры

Процедура ПослеОшибкиПодключенияОбработчикаНовыхЛичныхСообщений(ИнформацияОбОшибке, СтандартнаяОбработка, Контекст) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	ЖурналРегистрацииКлиент.ДобавитьСообщениеДляЖурналаРегистрации(
		НСтр("ru = 'Серверные оповещения.Ошибка подключения обработчика новых личных сообщений';
			|en = 'Server notifications.An error occurred when connecting the handler of new personal messages'",
			ОбщегоНазначенияКлиент.КодОсновногоЯзыка()),
		"Ошибка",
		ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке));
	
КонецПроцедуры

Процедура ПриПолученииНовогоЛичногоСообщенияСистемыВзаимодействия(Сообщение, Контекст) Экспорт
	
	ПриПолученииНовогоСообщенияСистемыВзаимодействия(Сообщение, Контекст);
	
КонецПроцедуры

Процедура ПриОшибкеПолученияНовогоЛичногоСообщенияСистемыВзаимодействия(ИнформацияОбОшибке, СтандартнаяОбработка, Контекст) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	ЖурналРегистрацииКлиент.ДобавитьСообщениеДляЖурналаРегистрации(
		НСтр("ru = 'Серверные оповещения.Ошибка получения нового личного сообщения';
			|en = 'Server notifications.An error occurred when receiving a new personal message'",
			ОбщегоНазначенияКлиент.КодОсновногоЯзыка()),
		"Ошибка",
		ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке));
	
КонецПроцедуры

Процедура ПослеПодключенияОбработчикаНовыхОбщихСообщений(Контекст) Экспорт
	
	Контекст.СостояниеПолучения.ОбработчикНовыхОбщихСообщенийПодключен = Истина;
	
КонецПроцедуры

Процедура ПослеОшибкиПодключенияОбработчикаНовыхОбщихСообщений(ИнформацияОбОшибке, СтандартнаяОбработка, Контекст) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	ЖурналРегистрацииКлиент.ДобавитьСообщениеДляЖурналаРегистрации(
		НСтр("ru = 'Серверные оповещения.Ошибка подключения обработчика новых общих сообщений';
			|en = 'Server notifications.An error occurred when connecting the handler of new common messages'",
			ОбщегоНазначенияКлиент.КодОсновногоЯзыка()),
		"Ошибка",
		ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке));
	
КонецПроцедуры

Процедура ПриПолученииНовогоОбщегоСообщенияСистемыВзаимодействия(Сообщение, Контекст) Экспорт
	
	ПриПолученииНовогоСообщенияСистемыВзаимодействия(Сообщение, Контекст);
	
КонецПроцедуры

Процедура ПриОшибкеПолученияНовогоОбщегоСообщенияСистемыВзаимодействия(ИнформацияОбОшибке, СтандартнаяОбработка, Контекст) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	ЖурналРегистрацииКлиент.ДобавитьСообщениеДляЖурналаРегистрации(
		НСтр("ru = 'Серверные оповещения.Ошибка получения нового общего сообщения';
			|en = 'Server notifications.An error occurred when receiving a new common message'",
			ОбщегоНазначенияКлиент.КодОсновногоЯзыка()),
		"Ошибка",
		ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке));
	
КонецПроцедуры

// Параметры:
//  Сообщение - СообщениеСистемыВзаимодействия
//  Контекст  - Структура:
//    * СостояниеПолучения - см. НовоеСостояниеПолучения
//
Процедура ПриПолученииНовогоСообщенияСистемыВзаимодействия(Сообщение, Контекст)
	
	СостояниеПолучения = Контекст.СостояниеПолучения;
	
	Если Не СостояниеПолучения.ПроверкаРазрешена
	 Или ПараметрыПриложения = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СостояниеПолучения.ДатаПоследнегоПолученияСообщения = ОбщегоНазначенияКлиент.ДатаСеанса();
	
	Попытка
		Данные = Сообщение.Данные; // См. СерверныеОповещения.НовыеДанныеСообщения
	Исключение
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		Описание = Новый Структура;
		Описание.Вставить("Дата", Сообщение.Дата);
		Описание.Вставить("Идентификатор", Строка(Сообщение.Идентификатор));
		Описание.Вставить("Обсуждение", Строка(Сообщение.Обсуждение));
		Описание.Вставить("Текст", СокрЛП(Сообщение.Текст));
		Описание.Вставить("ПодробноеПредставлениеОшибки",
			ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке));
		СерверныеОповещенияСлужебныйВызовСервера.ЗарегистрироватьОшибкуПолученияДанныхИзСообщения(Описание);
		Возврат;
	КонецПопытки;
	
	ПриПолученииСерверногоОповещения(Данные, СостояниеПолучения);
	
КонецПроцедуры

Процедура ПриПолученииСерверногоОповещения(Данные, СостояниеПолучения)
	
	Если ТипЗнч(Данные) <> Тип("Структура")
	 Или Не Данные.Свойство("ИмяОповещения") Тогда
		Возврат;
	КонецЕсли;
	
	Если Данные.ИмяОповещения <> "НетСерверныхОповещений" Тогда
		Если Данные.Адресаты <> Неопределено Тогда
			КлючиСеансов = Данные.Адресаты.Получить(СостояниеПолучения.ИдентификаторПользователяИБ);
			Если ТипЗнч(КлючиСеансов) <> Тип("Массив")
			 Или КлючиСеансов.Найти(СостояниеПолучения.КлючСеанса) = Неопределено
			   И КлючиСеансов.Найти("*") = Неопределено Тогда
				Возврат;
			КонецЕсли;
		КонецЕсли;
		ОбработатьСерверноеОповещениеНаКлиенте(СостояниеПолучения, Данные);
		Если Не Данные.ОтправленоИзОчереди Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	ДатаПоследнегоОповещения = Данные.Ошибки.Получить(СостояниеПолучения.ИдентификаторПользователяИБ);
	Если ДатаПоследнегоОповещения = Неопределено Тогда
		ДатаПоследнегоОповещения = Данные.Ошибки.Получить("ВсеПользователи");
		Если ДатаПоследнегоОповещения = Неопределено Тогда
			ДатаПоследнегоОповещения = Данные.ДатаДобавления;
			СостояниеПолучения.ДатаОбновленияСостояния = ОбщегоНазначенияКлиент.ДатаСеанса();
		КонецЕсли;
	КонецЕсли;
	Если СостояниеПолучения.ДатаПоследнегоОповещения < ДатаПоследнегоОповещения Тогда
		СостояниеПолучения.ДатаПоследнегоОповещения = ДатаПоследнегоОповещения;
	КонецЕсли;
	
КонецПроцедуры

Функция ОповещениеУжеПолучено(СостояниеПолучения, СерверноеОповещение)
	
	Если СерверноеОповещение.ДатаДобавления < СостояниеПолучения.ДатаПоследнегоОповещения Тогда
		Возврат Истина;
	КонецЕсли;
	
	ПолученныеОповещения = СостояниеПолучения.ПолученныеОповещения;
	
	Если ПолученныеОповещения.Найти(СерверноеОповещение.ИдентификаторОповещения) <> Неопределено Тогда
		Возврат Истина;
	КонецЕсли;
	
	ПолученныеОповещения.Добавить(СерверноеОповещение.ИдентификаторОповещения);
	Если ПолученныеОповещения.Количество() > 100 Тогда
		ПолученныеОповещения.Удалить(0);
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

// Уведомления клиента

Процедура ПриПолученииНовогоУведомленияКлиента(Данные, Контекст) Экспорт
	
	СостояниеПолучения = Контекст.СостояниеПолучения;
	
	Если Не СостояниеПолучения.ПроверкаРазрешена
	 Или ПараметрыПриложения = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СостояниеПолучения.ДатаПоследнегоПолученияСообщения = ОбщегоНазначенияКлиент.ДатаСеанса();
	
	ПриПолученииСерверногоОповещения(Данные, СостояниеПолучения);
	
КонецПроцедуры

Процедура ПриОшибкеПолученияНовогоУведомленияКлиента(ИнформацияОбОшибке, СтандартнаяОбработка, Контекст) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	ЖурналРегистрацииКлиент.ДобавитьСообщениеДляЖурналаРегистрации(
		НСтр("ru = 'Серверные оповещения.Ошибка получения нового уведомления клиента';
			|en = 'Серверные оповещения.Ошибка получения нового уведомления клиента'",
			ОбщегоНазначенияКлиент.КодОсновногоЯзыка()),
		"Ошибка",
		ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке));
	
КонецПроцедуры

Функция МенеджерУведомленийКлиента()
	
	// АПК:488-выкл Поддержка новых возможностей платформы (исполняемый код безопасен)
	Возврат Вычислить("УведомленияКлиента")
	// АПК:488-вкл
	
КонецФункции

#КонецОбласти
