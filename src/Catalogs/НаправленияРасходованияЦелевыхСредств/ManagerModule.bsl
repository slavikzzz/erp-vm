#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ОбновлениеИнформационнойБазы

// см. ОбновлениеИнформационнойБазыБСП.ПриДобавленииОбработчиковОбновления
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт

	Обработчик = Обработчики.Добавить();
	Обработчик.Процедура = "Справочники.НаправленияРасходованияЦелевыхСредств.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	Обработчик.Версия = "2.5.15.15";
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Идентификатор = Новый УникальныйИдентификатор("887af335-a9e1-4a1b-b8d2-935b81e1c8fe");
	Обработчик.ПроцедураЗаполненияДанныхОбновления = "Справочники.НаправленияРасходованияЦелевыхСредств.ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию";
	Обработчик.ПроцедураПроверки = "Справочники.НаправленияРасходованияЦелевыхСредств.ДанныеОбновленыНаНовуюВерсиюПрограммы";
	Обработчик.Комментарий = НСтр("ru = 'Заполнение усеченного описания статей расходования целевых средств';
									|en = 'Fill the shortened details of items of spending target funds'");
	Обработчик.Многопоточный = Истина;
	
	Читаемые = Новый Массив;
	Читаемые.Добавить(Метаданные.Справочники.НаправленияРасходованияЦелевыхСредств.ПолноеИмя());
	Обработчик.ЧитаемыеОбъекты = СтрСоединить(Читаемые, ",");
	
	Изменяемые = Новый Массив;
	Изменяемые.Добавить(Метаданные.Справочники.НаправленияРасходованияЦелевыхСредств.ПолноеИмя());
	Обработчик.ИзменяемыеОбъекты = СтрСоединить(Изменяемые, ",");
	
	Блокируемые = Новый Массив;
	Блокируемые.Добавить(Метаданные.Справочники.НаправленияРасходованияЦелевыхСредств.ПолноеИмя());
	Обработчик.БлокируемыеОбъекты = СтрСоединить(Блокируемые, ",");

КонецПроцедуры

// Определяет и регистрирует элементы справочника для обновления.
// 
// Параметры:
// 	Параметры - см. ОбновлениеИнформационнойБазы.ОсновныеПараметрыОтметкиКОбработке
//
Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ПараметрыВыборки = Параметры.ПараметрыВыборки;
	ПараметрыВыборки.ПолныеИменаОбъектов = "Справочник.НаправленияРасходованияЦелевыхСредств";
	ПараметрыВыборки.СпособВыборки = ОбновлениеИнформационнойБазы.СпособВыборкиСсылки();
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	НаправленияРасходованияЦелевыхСредств.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.НаправленияРасходованияЦелевыхСредств КАК НаправленияРасходованияЦелевыхСредств
	|ГДЕ
	|	НаправленияРасходованияЦелевыхСредств.ОписаниеСокращенное = """"
	|	И НЕ НаправленияРасходованияЦелевыхСредств.ЭтоГруппа
	|	И (ВЫРАЗИТЬ(НаправленияРасходованияЦелевыхСредств.Описание КАК СТРОКА(1024))) <> """"";
	
	ТаблицаСтатей = Запрос.Выполнить().Выгрузить();
	СписокСтатей = ТаблицаСтатей.ВыгрузитьКолонку("Ссылка");
	
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, СписокСтатей);
	
КонецПроцедуры

// Обработчик обновления.
// 
// Параметры:
//  Параметры - Структура - параметры.
//
Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ВыбранныеДанные = ОбновлениеИнформационнойБазы.ДанныеДляОбновленияВМногопоточномОбработчике(Параметры);
	
	ОбъектовОбработано = 0;
	ПроблемныхОбъектов = 0;
	
	Для Каждого Данные Из ВыбранныеДанные Цикл
		
		НачатьТранзакцию();
		
		Попытка
			
			Записать = Ложь;
			
			Блокировка = Новый БлокировкаДанных;
			ЭлементБлокировки = Блокировка.Добавить("Справочник.НаправленияРасходованияЦелевыхСредств");
			ЭлементБлокировки.УстановитьЗначение("Ссылка", Данные.Ссылка);
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
			Блокировка.Заблокировать();
			
			СправочникОбъект = Данные.Ссылка.ПолучитьОбъект();
			
			Если СправочникОбъект <> Неопределено Тогда
				
				Если СправочникОбъект.Описание <> "" Тогда
					
					СправочникОбъект.ОписаниеСокращенное = Сред(СправочникОбъект.Описание, 1, 1000);
					Записать = Истина;
					
				КонецЕсли;
				
			КонецЕсли;
			
			Если Записать Тогда
				ОбновлениеИнформационнойБазы.ЗаписатьОбъект(СправочникОбъект);
			Иначе
				ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(Данные.Ссылка);
			КонецЕсли;
			
			ОбъектовОбработано = ОбъектовОбработано + 1;
			ЗафиксироватьТранзакцию();
			
		Исключение
			
			ОтменитьТранзакцию();
			ПроблемныхОбъектов = ПроблемныхОбъектов + 1;
			ОбновлениеИнформационнойБазыУТ.СообщитьОНеудачнойОбработке(ИнформацияОбОшибке(), Данные.Ссылка);
			
		КонецПопытки;
	КонецЦикла;

	Параметры.ОбработкаЗавершена = ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(
		Параметры.Очередь, "Справочник.НаправленияРасходованияЦелевыхСредств");
	
	Если ОбъектовОбработано = 0 И ПроблемныхОбъектов <> 0 Тогда
		
		ШаблонСообщения = НСтр("ru = 'Не удалось заполнить усеченное описание в справочнике ""Направления расходования целевых средств"" (пропущены): %1';
								|en = 'Cannot fill the shortened details in the ""Expense directions of target funds"" catalog (skipped): %1'");
		ТекстСообщения = СтрШаблон(ШаблонСообщения, ПроблемныхОбъектов);
		ВызватьИсключение ТекстСообщения;
		
	Иначе
		
		ШаблонСообщения = НСтр("ru = 'Обработана порция статей расходования целевых средств: %1';
								|en = 'A batch of items of spending target funds is processed: %1'");
		ТекстСообщения = СтрШаблон(ШаблонСообщения, ОбъектовОбработано);
		ЗаписьЖурналаРегистрации(
			ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
			УровеньЖурналаРегистрации.Информация, , ,
			ТекстСообщения);
		
	КонецЕсли;

КонецПроцедуры

// Возвращает признак, что объект обновлен и доступен для изменения
// 
// Параметры:
//  МетаданныеИОтбор - см. ОбновлениеИнформационнойБазы.МетаданныеИОтборПоДанным.
// 
// Возвращаемое значение:
//  см. ОбновлениеИнформационнойБазы.ДанныеОбновленыНаНовуюВерсиюПрограммы.
//
Функция ДанныеОбновленыНаНовуюВерсиюПрограммы(МетаданныеИОтбор) Экспорт
	
	Возврат ОбновлениеИнформационнойБазы.ДанныеОбновленыНаНовуюВерсиюПрограммы(МетаданныеИОтбор);
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияПолейПредставления(Поля, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Поля.Добавить("Наименование");
	Поля.Добавить("ЭтоГруппа");
	Поля.Добавить("ОписаниеСокращенное");
	
КонецПроцедуры

Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка)
	
	Если Не Данные.ЭтоГруппа Тогда
		Представление = Сред(СтрШаблон("%1, %2", Данные.Наименование, Данные.ОписаниеСокращенное), 1, 1024);
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти