
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// Позволяет указать объекты метаданных, для которых задана логика ограничения доступа к данным.
//
// Параметры:
//   Ограничение - см. УправлениеДоступомПереопределяемый.ПриЗаполненииОграниченияДоступа.Ограничение.
//
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
		"РазрешитьЧтениеИзменение
		|ГДЕ
		|	ЗначениеРазрешено(УчетнаяЗаписьМаркетплейса.Организация)";
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ОбновлениеИнформационнойБазы

// см. ОбновлениеИнформационнойБазыБСП.ПриДобавленииОбработчиковОбновления
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Процедура = "РегистрыСведений.СоответствияОбъектовМаркетплейсов.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	Обработчик.Версия = "2.5.17.32";
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Идентификатор = Новый УникальныйИдентификатор("8c02ad93-1913-42bc-9ab5-8968164132cb");   
	Обработчик.Многопоточный = Истина;
	Обработчик.ПроцедураЗаполненияДанныхОбновления = "РегистрыСведений.СоответствияОбъектовМаркетплейсов.ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию";
	Обработчик.ПроцедураПроверки = "ОбновлениеИнформационнойБазы.ДанныеОбновленыНаНовуюВерсиюПрограммы";
	Обработчик.Комментарий = НСтр("ru = 'Устанавливает признак принадлежности склада к схеме работы FBS или к RealFBS в регистре сведений ""Соответствия объектов маркетплейсов"".
										|Данные о схеме работы получаются из сервиса Ozon.';
										|en = 'Indicates that the FBS or RealFBS work schema is set for the warehouse in the ""Marketplace object mappings"" information register.
										|Data on the work schema is received from Ozon.'");
	
	Читаемые = Новый Массив;
	Читаемые.Добавить(Метаданные.РегистрыСведений.СоответствияОбъектовМаркетплейсов.ПолноеИмя());
	Обработчик.ЧитаемыеОбъекты = СтрСоединить(Читаемые, ",");
	
	Изменяемые = Новый Массив;
	Изменяемые.Добавить(Метаданные.РегистрыСведений.СоответствияОбъектовМаркетплейсов.ПолноеИмя());
	Обработчик.ИзменяемыеОбъекты = СтрСоединить(Изменяемые, ",");
	
	Блокируемые = Новый Массив;
	Блокируемые.Добавить(Метаданные.РегистрыСведений.СоответствияОбъектовМаркетплейсов.ПолноеИмя());
	Обработчик.БлокируемыеОбъекты = СтрСоединить(Блокируемые, ","); 
	
КонецПроцедуры

// Параметры:
// 	Параметры - см. ОбновлениеИнформационнойБазы.ОсновныеПараметрыОтметкиКОбработке
//
Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт   
		
	ПараметрыВыборки = Параметры.ПараметрыВыборки;
	ПараметрыВыборки.ПолныеИменаРегистров = "РегистрСведений.СоответствияОбъектовМаркетплейсов";
	ПараметрыВыборки.СпособВыборки = ОбновлениеИнформационнойБазы.СпособВыборкиИзмеренияНезависимогоРегистраСведений();
	
	ДополнительныеПараметры = ОбновлениеИнформационнойБазы.ДополнительныеПараметрыОтметкиОбработки();
	ДополнительныеПараметры.Вставить("ЭтоНезависимыйРегистрСведений", Истина);
	ДополнительныеПараметры.Вставить("ПолноеИмяРегистра", "РегистрСведений.СоответствияОбъектовМаркетплейсов");
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	СоответствияОбъектов.УчетнаяЗаписьМаркетплейса КАК УчетнаяЗаписьМаркетплейса,
	               |	СоответствияОбъектов.ВидОбъектаМаркетплейса КАК ВидОбъектаМаркетплейса,
	               |	СоответствияОбъектов.ИдентификаторОбъектаМаркетплейса КАК ИдентификаторОбъектаМаркетплейса,
	               |	СоответствияОбъектов.ИдентификаторВладельцаОбъектаМаркетплейса КАК ИдентификаторВладельцаОбъектаМаркетплейса,
	               |	СоответствияОбъектов.Объект1С КАК Объект1С
	               |ИЗ
	               |	РегистрСведений.СоответствияОбъектовМаркетплейсов КАК СоответствияОбъектов
	               |ГДЕ
	               |	СоответствияОбъектов.ВидОбъектаМаркетплейса = ЗНАЧЕНИЕ(Перечисление.ВидыОбъектовМаркетплейсов.Склад)
	               |	И СоответствияОбъектов.УчетнаяЗаписьМаркетплейса.ВидМаркетплейса = ЗНАЧЕНИЕ(Перечисление.ВидыМаркетплейсов.МаркетплейсOzon)
	               |	И НЕ СоответствияОбъектов.УчетнаяЗаписьМаркетплейса.ПометкаУдаления
	               |	И НЕ СоответствияОбъектов.ИспользуетсяДляСхемыРаботыFBS
	               |	И НЕ СоответствияОбъектов.ИспользуетсяДляСхемыРаботыDBS"; 
	
	ТаблицаРегистра = Запрос.Выполнить().Выгрузить();
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, ТаблицаРегистра, ДополнительныеПараметры);
	
КонецПроцедуры

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
		
	МетаданныеОбъекта = Метаданные.РегистрыСведений.СоответствияОбъектовМаркетплейсов;
	ПолноеИмяРегистра  = МетаданныеОбъекта.ПолноеИмя();
	
	Если Не ОбновлениеИнформационнойБазы.ЕстьДанныеДляОбработки(Параметры.Очередь, ПолноеИмяРегистра) Тогда
		Параметры.ОбработкаЗавершена = Истина;
		Возврат;
	КонецЕсли;
		
	ТаблицаОбновляемыеДанные = ОбновлениеИнформационнойБазы.ДанныеДляОбновленияВМногопоточномОбработчике(Параметры); 
	КопияТаблицыОбновляемыеДанные = ТаблицаОбновляемыеДанные.Скопировать();
	КопияТаблицыОбновляемыеДанные.Свернуть("УчетнаяЗаписьМаркетплейса",);
	УчетныеЗаписи = КопияТаблицыОбновляемыеДанные.ВыгрузитьКолонку("УчетнаяЗаписьМаркетплейса");
	ТаблицаСкладовИзСервиса = Новый ТаблицаЗначений;   
	ТаблицаСкладовИзСервиса.Колонки.Добавить("ИдентификаторОбъектаМаркетплейса", Новый ОписаниеТипов("Строка"));
	ТаблицаСкладовИзСервиса.Колонки.Добавить("rFBS",  Новый ОписаниеТипов("Булево"));

	Для Каждого УчетнаяЗапись Из УчетныеЗаписи Цикл
		МассивСкладовПоУчетнойЗаписи = ИнтеграцияСМаркетплейсомOzonСервер.СкладыИзСервиса(УчетнаяЗапись);
		Если МассивСкладовПоУчетнойЗаписи<>Неопределено	Тогда
			Для Каждого СкладУчетнойЗаписи Из МассивСкладовПоУчетнойЗаписи Цикл  
				НоваяСтрока = ТаблицаСкладовИзСервиса.Добавить();
				НоваяСтрока.ИдентификаторОбъектаМаркетплейса = СкладУчетнойЗаписи.ИдентификаторОбъектаМаркетплейса;
				НоваяСтрока.rFBS = СкладУчетнойЗаписи.ЭтоRealFBS;
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого Строка Из ТаблицаОбновляемыеДанные Цикл
		
		НаборЗаписей = Неопределено;
		НачатьТранзакцию();
		Попытка
			Блокировка = Новый БлокировкаДанных();
			
			ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.СоответствияОбъектовМаркетплейсов");
			ЭлементБлокировки.УстановитьЗначение("УчетнаяЗаписьМаркетплейса", Строка.УчетнаяЗаписьМаркетплейса);
			ЭлементБлокировки.УстановитьЗначение("ВидОбъектаМаркетплейса", Строка.ВидОбъектаМаркетплейса);
			ЭлементБлокировки.УстановитьЗначение("ИдентификаторОбъектаМаркетплейса", Строка.ИдентификаторОбъектаМаркетплейса);  
			ЭлементБлокировки.УстановитьЗначение("ИдентификаторВладельцаОбъектаМаркетплейса", Строка.ИдентификаторВладельцаОбъектаМаркетплейса);  
			ЭлементБлокировки.УстановитьЗначение("Объект1С", Строка.Объект1С);

			Блокировка.Заблокировать();        
			
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Разделяемый;
			
			НаборЗаписей = СоздатьНаборЗаписей();
			НаборЗаписей.Отбор.УчетнаяЗаписьМаркетплейса.Установить(Строка.УчетнаяЗаписьМаркетплейса);
			НаборЗаписей.Отбор.ВидОбъектаМаркетплейса.Установить(Строка.ВидОбъектаМаркетплейса);
			НаборЗаписей.Отбор.ИдентификаторОбъектаМаркетплейса.Установить(Строка.ИдентификаторОбъектаМаркетплейса);
			НаборЗаписей.Отбор.ИдентификаторВладельцаОбъектаМаркетплейса.Установить(Строка.ИдентификаторВладельцаОбъектаМаркетплейса);  
			НаборЗаписей.Отбор.Объект1С.Установить(Строка.Объект1С);
			
			СтрокаТаблицы = ТаблицаСкладовИзСервиса.Найти(Строка.ИдентификаторОбъектаМаркетплейса, "ИдентификаторОбъектаМаркетплейса");
			
			НаборЗаписей.Прочитать();
			
			Для Каждого Запись Из НаборЗаписей Цикл
				
				Запись.ИспользуетсяДляСхемыРаботыFBO = Ложь;
				
				Если СтрокаТаблицы<>Неопределено Тогда
					Запись.ИспользуетсяДляСхемыРаботыFBS = Не СтрокаТаблицы.rFBS;
					Запись.ИспользуетсяДляСхемыРаботыDBS = СтрокаТаблицы.rFBS;
				КонецЕсли;
				
			КонецЦикла;
			ОбновлениеИнформационнойБазы.ЗаписатьНаборЗаписей(НаборЗаписей);
			ЗафиксироватьТранзакцию();
			
		Исключение
			ОтменитьТранзакцию();
			Если НаборЗаписей = Неопределено Тогда
				НаборЗаписей = СоздатьНаборЗаписей();
				НаборЗаписей.Отбор.УчетнаяЗаписьМаркетплейса.Установить(Строка.УчетнаяЗаписьМаркетплейса);
				НаборЗаписей.Отбор.ВидОбъектаМаркетплейса.Установить(Строка.ВидОбъектаМаркетплейса);
				НаборЗаписей.Отбор.ИдентификаторОбъектаМаркетплейса.Установить(Строка.ИдентификаторОбъектаМаркетплейса);
				НаборЗаписей.Отбор.ИдентификаторВладельцаОбъектаМаркетплейса.Установить(Строка.ИдентификаторВладельцаОбъектаМаркетплейса);
				НаборЗаписей.Отбор.Объект1С.Установить(Строка.Объект1С);
			КонецЕсли;
			ОбновлениеИнформационнойБазыУТ.СообщитьОНеудачнойОбработке(ИнформацияОбОшибке(), НаборЗаписей);
		КонецПопытки;
		
	КонецЦикла;
	Параметры.ОбработкаЗавершена = Не ОбновлениеИнформационнойБазы.ЕстьДанныеДляОбработки(Параметры.Очередь, ПолноеИмяРегистра);
		
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
