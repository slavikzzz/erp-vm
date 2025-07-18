////////////////////////////////////////////////////////////////
// Модуль "НазначенияКлиент" содержит процедуры и функции для 
// работы с назначениями на клиенте.
//
////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#Область Заполнение

// Заполняет служебный реквизит "ТипНазначения" в строке по данным указанного назначения
//
// Параметры:
//  ТекущаяСтрока        - Структура - данные обрабатываемой строки.
//  КэшированныеЗначения - Структура - сохраненные значения параметров, используемых при обработке.
//  ПараметрыЗаполнения  - см. НазначенияКлиентСервер.ПараметрыЗаполнения
//
Процедура ЗаполнитьТипНазначения(ТекущаяСтрока, КэшированныеЗначения, ПараметрыЗаполнения = Неопределено) Экспорт
	
	ТипНазначения = Неопределено;
	
	Если ЗначениеЗаполнено(ТекущаяСтрока.Назначение) Тогда
		
		СвойстваНазначение = КэшированныеЗначения.СвойстваНазначений.Получить(ТекущаяСтрока.Назначение);
		
		Если СвойстваНазначение = Неопределено Тогда 
		
			ТекстИсключения = 
				НСтр("ru = 'Попытка заполнения служебного реквизита по данным указанного назначение на клиенте.';
					|en = 'Try to fill in internal attribute according to the data of the specified assignment on the client.'");
					
			ВызватьИсключение ТекстИсключения;
				
		Иначе
			ТипНазначения = СвойстваНазначение.ТипНазначения;
		КонецЕсли;
		
	КонецЕсли;
	
	ТекущаяСтрока.ТипНазначения = ТипНазначения;
	
	Если ЗначениеЗаполнено(ПараметрыЗаполнения)
	   И ТекущаяСтрока.ТипНазначения = ПараметрыЗаполнения.ТипНазначения Тогда
		
		ТекущаяСтрока[ПараметрыЗаполнения.ИмяЗаполняемогоПоля] = ?(ЗначениеЗаполнено(ПараметрыЗаполнения.ИмяПоляТЧ),
																	ТекущаяСтрока[ПараметрыЗаполнения.ИмяПоляТЧ],
																	ПараметрыЗаполнения.ЗначениеПоля);
		
	КонецЕсли;
	
КонецПроцедуры

// Заполняет назначение в строке сверх заказа в накладной по нескольким заказам, исходя из назначения по умолчанию
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма документа
//  СтрокаТаблицы - ДанныеФормыЭлементКоллекции - строка табличной части в форме документа
&НаКлиенте
Процедура ПослеУказанияЗаказаВСтроке(Форма, СтрокаТаблицы) Экспорт
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТабличныхЧастейФормыДокумента

// В табличной части формы документа актуализирует назначение по флагу Обособленно.
// 
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - Форма.
//  ТекущаяСтрока - ДанныеФормыЭлементКоллекции - Строка в которой нужно актуализировать назначение.
//  Устарело - Булево - для совместимости с НаправленияДеятельностиКлиент.ТоварыОбособленноПриИзменении
Процедура ТоварыОбособленноПриИзменении(Форма, ТекущаяСтрока, Устарело = Ложь) Экспорт
	
	Если Устарело Тогда
		ПорядокОбработкиДокумента = Форма.МетаданныеФормы;
		НазначениеПоУмолчанию = Форма.НаправленияДеятельностиКэшированныеЗначения.НазначениеПоУмолчанию;
	Иначе
		ПорядокОбработкиДокумента = Форма.НазначенияКэшированныеЗначения.ПорядокОбработкиДокумента;
		НазначениеПоУмолчанию = Форма.НазначенияКэшированныеЗначения.НазначениеПоУмолчанию;
	КонецЕсли;
	
	Служебные = ПорядокОбработкиДокумента.Служебные;
	Установить = ТекущаяСтрока[Служебные.ИмяРеквизитаОбособленно];
	ТекущаяСтрока.Назначение = ?(Установить,
		НазначениеПоУмолчанию,
		ПредопределенноеЗначение("Справочник.Назначения.ПустаяСсылка"));
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти