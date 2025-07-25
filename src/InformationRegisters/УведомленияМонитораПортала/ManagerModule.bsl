///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// Возвращает уведомления сервисов портала 1С:ИТС.
//
// Возвращаемое значение:
//  Соответствие из КлючИЗначение - уведомления сервисов:
//    *Ключ - Строка - Идентификатор сервиса;
//    *Значение - Массив - уведомления сервиса.
//
Функция УведомленияПортала1СИТС() Экспорт
	
	Результат = Новый Соответствие;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	УведомленияМонитораПортала.ИдентификаторСервиса КАК ИдентификаторСервиса,
		|	УведомленияМонитораПортала.ИдентификаторОпции КАК ИдентификаторОпции,
		|	УведомленияМонитораПортала.ВидУведомления КАК ВидУведомления,
		|	УведомленияМонитораПортала.СтраницаСервиса КАК СтраницаСервиса,
		|	УведомленияМонитораПортала.ДатаОкончания КАК ДатаОкончания,
		|	УведомленияМонитораПортала.ДополнительныеПараметры КАК ДополнительныеПараметры
		|ИЗ
		|	РегистрСведений.УведомленияМонитораПортала КАК УведомленияМонитораПортала
		|ИТОГИ ПО
		|	ИдентификаторСервиса";
	
	
	НачатьТранзакцию();
	Попытка
		// Не устанавливаем управляемую блокировку, чтобы другие сеансы могли изменять значение пока эта транзакция активна.
		УстановитьПривилегированныйРежим(Истина);
		РезультатЗапроса = Запрос.Выполнить();
		УстановитьПривилегированныйРежим(Ложь);
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Результат;
	КонецЕсли;
	
	ВыборкаСервис = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаСервис.Следующий() Цикл
		
		ДанныеСервиса = Новый Массив;
		
		Выборка = ВыборкаСервис.Выбрать();
		Пока Выборка.Следующий() Цикл
			
			ДанныеВидаУведомления = Новый Структура;
			ДанныеВидаУведомления.Вставить("ИдентификаторСервиса",    Выборка.ИдентификаторСервиса);
			ДанныеВидаУведомления.Вставить("ИдентификаторОпции",      Выборка.ИдентификаторОпции);
			ДанныеВидаУведомления.Вставить("ВидУведомления",          Выборка.ВидУведомления);
			ДанныеВидаУведомления.Вставить("СтраницаСервиса",         Выборка.СтраницаСервиса);
			ДанныеВидаУведомления.Вставить("ДатаОкончания",           Выборка.ДатаОкончания);
			ДанныеВидаУведомления.Вставить("ДополнительныеПараметры", Выборка.ДополнительныеПараметры.Получить());
			
			ДанныеСервиса.Добавить(ДанныеВидаУведомления);
			
		КонецЦикла;
		
		Результат.Вставить(ВыборкаСервис.ИдентификаторСервиса, ДанныеСервиса);
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Возвращает уведомления сервиса портала 1С:ИТС.
//
// Параметры:
//   ИдентификаторСервиса - Строка - идентификатор сервиса.
//
// Возвращаемое значение:
//   Массив - уведомления сервиса.
//
Функция УведомленияСервисаПортала1СИТС(ИдентификаторСервиса) Экспорт
	
	Результат = Новый Массив;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	УведомленияМонитораПортала.ИдентификаторСервиса КАК ИдентификаторСервиса,
		|	УведомленияМонитораПортала.ИдентификаторОпции КАК ИдентификаторОпции,
		|	УведомленияМонитораПортала.ВидУведомления КАК ВидУведомления,
		|	УведомленияМонитораПортала.СтраницаСервиса КАК СтраницаСервиса,
		|	УведомленияМонитораПортала.ДатаОкончания КАК ДатаОкончания,
		|	УведомленияМонитораПортала.ДополнительныеПараметры КАК ДополнительныеПараметры
		|ИЗ
		|	РегистрСведений.УведомленияМонитораПортала КАК УведомленияМонитораПортала
		|ГДЕ
		|	УведомленияМонитораПортала.ИдентификаторСервиса = &ИдентификаторСервиса";
	
	Запрос.УстановитьПараметр("ИдентификаторСервиса", ИдентификаторСервиса);
	
	НачатьТранзакцию();
	Попытка
		// Не устанавливаем управляемую блокировку, чтобы другие сеансы могли изменять значение пока эта транзакция активна.
		УстановитьПривилегированныйРежим(Истина);
		РезультатЗапроса = Запрос.Выполнить();
		УстановитьПривилегированныйРежим(Ложь);
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Результат;
	КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		
		ДанныеВидаУведомления = Новый Структура;
		ДанныеВидаУведомления.Вставить("ИдентификаторСервиса",    Выборка.ИдентификаторСервиса);
		ДанныеВидаУведомления.Вставить("ИдентификаторОпции",      Выборка.ИдентификаторОпции);
		ДанныеВидаУведомления.Вставить("ВидУведомления",          Выборка.ВидУведомления);
		ДанныеВидаУведомления.Вставить("СтраницаСервиса",         Выборка.СтраницаСервиса);
		ДанныеВидаУведомления.Вставить("ДатаОкончания",           Выборка.ДатаОкончания);
		ДанныеВидаУведомления.Вставить("ДополнительныеПараметры", Выборка.ДополнительныеПараметры.Получить());
		
		Результат.Добавить(ДанныеВидаУведомления);
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Обновляет данные полученных уведомлений.
//
// Параметры:
//  ДанныеОпций - Массив из Структура - данные для записи в кэш.
//
Процедура Обновить(ДанныеОпций) Экспорт
	
	БлокировкаУстановлена = Ложь;
	
	УстановитьПривилегированныйРежим(Истина);
	
	НачатьТранзакцию();
	Попытка
		
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.УведомленияМонитораПортала");
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
		Блокировка.Заблокировать();
		
		Набор = СоздатьНаборЗаписей();
		Для Каждого ДанныеОпцииСервиса Из ДанныеОпций Цикл
			Запись = Набор.Добавить();
			ЗаполнитьЗначенияСвойств(
				Запись,
				ДанныеОпцииСервиса);
		КонецЦикла;
		Набор.Записать();
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		ИнформацияОбОшибке = ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
			МониторПортала1СИТС.ЗаписатьИнформациюВЖурналРегистрации(
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Не удалось обновить данные опций сервисов портала 1С:ИТС по причине:
						|%1';
						|en = 'Cannot update option data of 1C:ITS Portal services. Reason:
						|%1'"),
					ИнформацияОбОшибке));
		
		ВызватьИсключение;
		
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли