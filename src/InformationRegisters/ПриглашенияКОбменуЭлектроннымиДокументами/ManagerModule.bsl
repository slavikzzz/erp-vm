
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// Параметры:
//   Ограничение - см. УправлениеДоступомПереопределяемый.ПриЗаполненииОграниченияДоступа.Ограничение.
//
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	
	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)";
	
	Ограничение.ТекстДляВнешнихПользователей =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)";
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

// СтандартныеПодсистемы.ОбновлениеВерсииИБ

// Регистрирует данные для обработчика обновления
// 
// Параметры:
//  Параметры - Структура - параметры.
//
Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт      
	
	Ключ = ""; 
	ОтработаныВсеДанные = Ложь;
	
	МетаданныеОбъекта = Метаданные.РегистрыСведений.ПриглашенияКОбменуЭлектроннымиДокументами;
	ПолноеИмяОбъекта = МетаданныеОбъекта.ПолноеИмя();
	
	ДополнительныеПараметры = ОбновлениеИнформационнойБазы.ДополнительныеПараметрыОтметкиОбработки();
	ДополнительныеПараметры.ЭтоНезависимыйРегистрСведений = Истина;
	ДополнительныеПараметры.ПолноеИмяРегистра = ПолноеИмяОбъекта;
	
	ПараметрыВыборки = Параметры.ПараметрыВыборки;
	ПараметрыВыборки.СпособВыборки = ОбновлениеИнформационнойБазы.СпособВыборкиИзмеренияНезависимогоРегистраСведений();
	ПараметрыВыборки.ПолныеИменаРегистров = ПолноеИмяОбъекта;
	
	Пока Не ОтработаныВсеДанные Цикл
		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ ПЕРВЫЕ 1000
		|	ПриглашенияКОбменуЭлектроннымиДокументами.Ключ КАК Ключ,
		|	ПриглашенияКОбменуЭлектроннымиДокументами.ИдентификаторОрганизации КАК ИдентификаторОрганизации
		|ИЗ
		|	РегистрСведений.ПриглашенияКОбменуЭлектроннымиДокументами КАК ПриглашенияКОбменуЭлектроннымиДокументами
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.УчетныеЗаписиЭДО КАК УчетныеЗаписиЭДО
		|		ПО ПриглашенияКОбменуЭлектроннымиДокументами.ИдентификаторОрганизации = УчетныеЗаписиЭДО.ИдентификаторЭДО
		|ГДЕ
		|	ПриглашенияКОбменуЭлектроннымиДокументами.Ключ > &Ключ
		|	И ПриглашенияКОбменуЭлектроннымиДокументами.Организация = ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)
		|	И НЕ ЕСТЬNULL(УчетныеЗаписиЭДО.Организация, ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)) = ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)
		|
		|УПОРЯДОЧИТЬ ПО
		|	Ключ";   
		
		Запрос.УстановитьПараметр("Ключ", Ключ);
		
		Выгрузка = Запрос.Выполнить().Выгрузить();		
		ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, Выгрузка, ДополнительныеПараметры);   
				
		КоличествоСсылок = Выгрузка.Количество();
		Если КоличествоСсылок < 1000 Тогда
			ОтработаныВсеДанные = Истина;
		КонецЕсли;
		
		Если КоличествоСсылок > 0 Тогда
			Ключ = Выгрузка[КоличествоСсылок - 1].Ключ;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Обработчик обновления.
// 
// Параметры:
//  Параметры - Структура - параметры.
//
Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	МетаданныеОбъекта = Метаданные.РегистрыСведений.ПриглашенияКОбменуЭлектроннымиДокументами;
	ПолноеИмяОбъекта = МетаданныеОбъекта.ПолноеИмя();
	ПредставлениеОбъекта = МетаданныеОбъекта.Представление();
	
	Если ОбновлениеИнформационнойБазы.ЕстьЗаблокированныеПредыдущимиОчередямиДанные(Параметры.Очередь,
			"РегистрСведений.УдалитьПриглашенияКОбменуЭлектроннымиДокументами") Тогда
		Параметры.ОбработкаЗавершена = ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(
			Параметры.Очередь, ПолноеИмяОбъекта);
		Возврат;
	КонецЕсли;

	ДанныеДляОбновления = ОбновлениеИнформационнойБазы.ДанныеДляОбновленияВМногопоточномОбработчике(Параметры);
	
	Если Не ЗначениеЗаполнено(ДанныеДляОбновления) Тогда
		Параметры.ОбработкаЗавершена = ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(
		Параметры.Очередь, ПолноеИмяОбъекта);
		Возврат;
	КонецЕсли;
		
	ОбъектовОбработано = 0;
	ПроблемныхОбъектов = 0;  
	
	ОрганизацияПоИдентификатору = 
ПриглашенияЭДОСлужебный.СоответствиеИдентификаторовОрганизаций(ДанныеДляОбновления.ВыгрузитьКолонку("ИдентификаторОрганизации"));

	Для Каждого СтрокаДанных Из ДанныеДляОбновления Цикл
		НачатьТранзакцию();
		Попытка
			
			Блокировка = Новый БлокировкаДанных;
			ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ПриглашенияКОбменуЭлектроннымиДокументами");
			ЭлементБлокировки.УстановитьЗначение("Ключ", СтрокаДанных.Ключ);
			ЭлементБлокировки.УстановитьЗначение("ИдентификаторОрганизации", СтрокаДанных.ИдентификаторОрганизации);		
			Блокировка.Заблокировать();
			
			Записать = Ложь;
			
			Набор = РегистрыСведений.ПриглашенияКОбменуЭлектроннымиДокументами.СоздатьНаборЗаписей();
			Набор.Отбор.Ключ.Установить(СтрокаДанных.Ключ);
			Набор.Отбор.ИдентификаторОрганизации.Установить(СтрокаДанных.ИдентификаторОрганизации);
			Набор.Прочитать();   
			
			Организация = ОрганизацияПоИдентификатору.Получить(СтрокаДанных.ИдентификаторОрганизации);
			Если Не ЗначениеЗаполнено(Организация) Тогда
				Организация = ИнтеграцияЭДО.ПолучитьПустуюСсылку("Организации");
			КонецЕсли;
			
			ОбновитьЗаписьРегистраПриглашений(Набор, Организация, Записать);
			
			Если Записать Тогда
				ОбновлениеИнформационнойБазы.ЗаписатьНаборЗаписей(Набор);
			Иначе
				ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(Набор);
			КонецЕсли;
			
			ОбъектовОбработано = ОбъектовОбработано + 1;
			
			ЗафиксироватьТранзакцию();
		Исключение
			ОтменитьТранзакцию(); 
			
			ПроблемныхОбъектов = ПроблемныхОбъектов + 1;  
			
			ТекстСообщения = СтрШаблон(НСтр("ru = 'Не удалось обработать набор записей регистра: %1 по причине:
				|%2';
				|en = 'Cannot process the %1 register record set due to:
				|%2'"), ПредставлениеОбъекта, ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
				УровеньЖурналаРегистрации.Ошибка, МетаданныеОбъекта, СтрокаДанных.Ключ, ТекстСообщения);
		КонецПопытки;
	КонецЦикла;        
	
	Если ОбъектовОбработано = 0 И ПроблемныхОбъектов <> 0 Тогда
		ШаблонСообщения = НСтр("ru = 'Не удалось обработать некоторые записи регистра (пропущены): %1';
								|en = 'Cannot process some register records (skipped): %1'");
		ТекстСообщения = СтрШаблон(ШаблонСообщения, ПроблемныхОбъектов);
		ВызватьИсключение ТекстСообщения;
	Иначе
		ШаблонСообщения = НСтр("ru = 'Обработана очередная порция записей регистра: %1';
								|en = 'Register records are processed: %1'");
		ТекстСообщения = СтрШаблон(ШаблонСообщения, ОбъектовОбработано);
		ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
		УровеньЖурналаРегистрации.Информация,
		МетаданныеОбъекта,, ТекстСообщения);
	КонецЕсли;

	Параметры.ПрогрессВыполнения.ОбработаноОбъектов  = 
		Параметры.ПрогрессВыполнения.ОбработаноОбъектов  + ДанныеДляОбновления.Количество();
	
	Параметры.ОбработкаЗавершена = ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(
		Параметры.Очередь, ПолноеИмяОбъекта);
	
КонецПроцедуры 
	
// Конец СтандартныеПодсистемы.ОбновлениеВерсииИБ

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	Если ВидФормы <> "ФормаЗаписи" Тогда
		Возврат;
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(Параметры, "Пригласить", Ложь) Тогда
		ОбработкаПолученияФормыОтправкиПриглашения(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	Иначе
		ОбработкаПолученияФормыЗаписи(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Функция ПредставленияПриглашений(КлючиЗаписей) Экспорт
	
	Результат = Новый Соответствие;

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПриглашенияКОбменуЭлектроннымиДокументами.Ключ КАК КлючПриглашения,
		|	ПРЕДСТАВЛЕНИЕ(УчетныеЗаписиЭДО.Организация) КАК Организация,
		|	ПриглашенияКОбменуЭлектроннымиДокументами.Наименование КАК НаименованиеКонтрагента,
		|	ПриглашенияКОбменуЭлектроннымиДокументами.ИНН КАК ИННКонтрагента,
		|	ПриглашенияКОбменуЭлектроннымиДокументами.КПП КАК КППКонтрагента,
		|	ПриглашенияКОбменуЭлектроннымиДокументами.ИдентификаторКонтрагента КАК ИдентификаторКонтрагента,
		|	ПриглашенияКОбменуЭлектроннымиДокументами.ИдентификаторОрганизации КАК ИдентификаторОрганизации
		|ИЗ
		|	РегистрСведений.ПриглашенияКОбменуЭлектроннымиДокументами КАК ПриглашенияКОбменуЭлектроннымиДокументами
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.УчетныеЗаписиЭДО КАК УчетныеЗаписиЭДО
		|		ПО ПриглашенияКОбменуЭлектроннымиДокументами.ИдентификаторОрганизации = УчетныеЗаписиЭДО.ИдентификаторЭДО
		|ГДЕ
		|	ПриглашенияКОбменуЭлектроннымиДокументами.Ключ В (&КлючиПриглашений)";
	
	КлючиПриглашений = Новый Массив;
 	Для каждого КлючЗаписи Из КлючиЗаписей Цикл
		КлючиПриглашений.Добавить(КлючЗаписи.Ключ);
	КонецЦикла;
	Запрос.УстановитьПараметр("КлючиПриглашений", КлючиПриглашений);
	
	ВыборкаДетальныеЗаписи = Запрос.Выполнить().Выбрать();
	Для Каждого КлючЗаписи Из КлючиЗаписей Цикл
		СтруктураПоиска = Новый Структура;
		СтруктураПоиска.Вставить("КлючПриглашения", КлючЗаписи.Ключ);
		Если ВыборкаДетальныеЗаписи.НайтиСледующий(СтруктураПоиска) Тогда
			ПредставлениеПриглашения = СтрШаблон(НСтр("ru = '%1 -> %2 (ИНН: %3)';
														|en = '%1 -> %2 (TIN: %3)'"), ВыборкаДетальныеЗаписи.Организация,
				ВыборкаДетальныеЗаписи.НаименованиеКонтрагента, ВыборкаДетальныеЗаписи.ИННКонтрагента);
			Результат.Вставить(КлючЗаписи, ПредставлениеПриглашения);
			ВыборкаДетальныеЗаписи.Сбросить();
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ОбработкаПолученияФормыЗаписи(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	КлючЗаписи = Неопределено;
	Если Параметры.Свойство("Ключ", КлючЗаписи) И ЗначениеЗаполнено(КлючЗаписи.Ключ) Тогда
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	ВыбраннаяФорма = "ПомощникОтправкиПриглашения";
	
КонецПроцедуры

Процедура ОбработкаПолученияФормыОтправкиПриглашения(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ВыбраннаяФорма = "ПомощникОтправкиПриглашения";
	
	Если Параметры.Контрагент = Неопределено Тогда
		Возврат;
	ИначеЕсли ТипЗнч(Параметры.Контрагент) = Тип("Массив") Тогда
		МассивКонтрагентов = Параметры.Контрагент;
		Если МассивКонтрагентов.Количество() = 0 Тогда
			Возврат;
		КонецЕсли;
	Иначе
		МассивКонтрагентов = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Параметры.Контрагент);
	КонецЕсли;
	
	МетаданныеОбъекта = МассивКонтрагентов[0].Метаданные();
	
	Если ОбщегоНазначенияБЭД.СправочникИспользуетГруппы(МетаданныеОбъекта) Тогда
		ТекстЗапроса = 
			"ВЫБРАТЬ РАЗРЕШЕННЫЕ
			|	Контрагенты.Ссылка КАК Ссылка
			|ИЗ
			|	ИмяТаблицыКонтрагенты КАК Контрагенты
			|ГДЕ
			|	Контрагенты.Ссылка В (&Контрагенты)
			|	И НЕ Контрагенты.ЭтоГруппа";
		ИмяТаблицыКонтрагенты = МетаданныеОбъекта.ПолноеИмя();
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "ИмяТаблицыКонтрагенты", ИмяТаблицыКонтрагенты);
		Запрос = Новый Запрос(ТекстЗапроса);
		Запрос.УстановитьПараметр("Контрагенты", МассивКонтрагентов);
		РезультатЗапроса = Запрос.Выполнить();
		Если РезультатЗапроса.Пустой() Тогда
			Возврат;
		КонецЕсли;
		МассивКонтрагентов = РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("Ссылка");
	КонецЕсли;
	
	Если МассивКонтрагентов.Количество() = 1 Тогда
		Параметры.Вставить("Контрагент", МассивКонтрагентов[0]);
	Иначе
		Параметры.Вставить("МассивКонтрагентов", МассивКонтрагентов);
		ВыбраннаяФорма = "ПомощникМассовойОтправкиПриглашений";
	КонецЕсли;
	
КонецПроцедуры

#Область Обновление 

Процедура ОбновитьЗаписьРегистраПриглашений(Набор, Организация, Записать)  

	Для Каждого ЗаписьОбновления Из Набор Цикл	
		Если Не ЗначениеЗаполнено(Организация)
		ИЛИ ЗначениеЗаполнено(ЗаписьОбновления.Организация) Тогда
			Продолжить;
		КонецЕсли;  
		ЗаписьОбновления.Организация = Организация;
		Записать = Истина; 
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
	
#КонецЕсли
