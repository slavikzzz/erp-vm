#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Списки) Экспорт

	Списки.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ОбновлениеИнформационнойБазы

// см. ОбновлениеИнформационнойБазыБСП.ПриДобавленииОбработчиковОбновления
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт

	Обработчик = Обработчики.Добавить();
	Обработчик.Процедура = "РегистрыСведений.НастройкаПереходаНаФСБУ5.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	Обработчик.Версия = "2.5.13.40";
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Идентификатор = Новый УникальныйИдентификатор("cc609310-b77f-4c9e-8af3-fc639b764e53");
	Обработчик.ПроцедураЗаполненияДанныхОбновления = "РегистрыСведений.НастройкаПереходаНаФСБУ5.ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию";
	Обработчик.ПроцедураПроверки = "ОбновлениеИнформационнойБазы.ДанныеОбновленыНаНовуюВерсиюПрограммы";
	Обработчик.Порядок = Перечисления.ПорядокОбработчиковОбновления.Критичный;
	Обработчик.Комментарий = НСтр("ru = 'Обновляет регистр ""Настройка перехода на ФСБУ 5"":
								  |- заполняет новый регистр на основании учетной политики бух. учета.';
								  |en = 'Updates the ""Set up transition to the Russian GAAP (FSBU) 5"" register:
								  |- Fills the new register based on the accounting policy.'");
	
	Читаемые = Новый Массив;
	Читаемые.Добавить(Метаданные.РегистрыСведений.НастройкаПереходаНаФСБУ5.ПолноеИмя());
	Читаемые.Добавить(Метаданные.РегистрыСведений.УчетнаяПолитикаБухУчета.ПолноеИмя());
	Обработчик.ЧитаемыеОбъекты = СтрСоединить(Читаемые, ",");
	
	Изменяемые = Новый Массив;
	Изменяемые.Добавить(Метаданные.РегистрыСведений.НастройкаПереходаНаФСБУ5.ПолноеИмя());
	Обработчик.ИзменяемыеОбъекты = СтрСоединить(Изменяемые, ",");
	
	Блокируемые = Новый Массив;
	Блокируемые.Добавить(Метаданные.РегистрыСведений.НастройкаПереходаНаФСБУ5.ПолноеИмя());
	Обработчик.БлокируемыеОбъекты = СтрСоединить(Блокируемые, ",");

КонецПроцедуры

Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ДополнительныеПараметры = ОбновлениеИнформационнойБазы.ДополнительныеПараметрыОтметкиОбработки();
	ДополнительныеПараметры.ЭтоНезависимыйРегистрСведений = Истина;
	ДополнительныеПараметры.ПолноеИмяРегистра = "РегистрСведений.НастройкаПереходаНаФСБУ5";
	
	Запрос = Новый Запрос;
	
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ТаблицаИсточник.Организация.ГоловнаяОрганизация КАК Организация
	|ИЗ
	|	РегистрСведений.УчетнаяПолитикаБухУчета КАК ТаблицаИсточник
	|
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НастройкаПереходаНаФСБУ5 КАК ТаблицаПолучатель
	|		ПО ТаблицаПолучатель.Организация = ТаблицаИсточник.Организация
	|ГДЕ
	|	ТаблицаИсточник.УдалитьСписатьСтоимостьТМЦВЭксплуатации
	|	И ТаблицаПолучатель.Организация ЕСТЬ NULL
	|
	|	И НЕ ИСТИНА В (
	|		ВЫБРАТЬ ПЕРВЫЕ 1
	|			ИСТИНА
	|		ИЗ
	|			РегистрСведений.НастройкаПереходаНаФСБУ5 КАК ТаблицаПолучатель)
	|";
	
	Данные = Запрос.Выполнить().Выгрузить();
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, Данные, ДополнительныеПараметры);
	
КонецПроцедуры

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	МетаданныеОбъекта = Метаданные.РегистрыСведений.НастройкаПереходаНаФСБУ5;
	ПолноеИмяОбъекта = МетаданныеОбъекта.ПолноеИмя();

	Выборка = ОбновлениеИнформационнойБазы.ВыбратьИзмеренияНезависимогоРегистраСведенийДляОбработки(Параметры.Очередь, ПолноеИмяОбъекта);
	
	Пока Выборка.Следующий() Цикл
		
		НачатьТранзакцию();
		
		Попытка
			
			Блокировка = Новый БлокировкаДанных;

			ЭлементБлокировки = Блокировка.Добавить(ПолноеИмяОбъекта);
			ЭлементБлокировки.УстановитьЗначение("Организация", Выборка.Организация);
			
			ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.УчетнаяПолитикаБухУчета");
			ЭлементБлокировки.УстановитьЗначение("Организация", Выборка.Организация);
			
			Блокировка.Заблокировать();
			
			НаборЗаписей = СоздатьНаборЗаписей();
			НаборЗаписей.Отбор.Организация.Установить(Выборка.Организация);
			НаборЗаписей.Прочитать();
			
			Если НаборЗаписей.Количество() = 0 Тогда
				
				ТекстЗапроса = 
				"ВЫБРАТЬ
				|	МИНИМУМ(УчетнаяПолитикаБухУчета.Период) КАК Период
				|ИЗ
				|	РегистрСведений.УчетнаяПолитикаБухУчета КАК УчетнаяПолитикаБухУчета
				|ГДЕ
				|	УчетнаяПолитикаБухУчета.Организация = &Организация
				|	И УчетнаяПолитикаБухУчета.УдалитьСписатьСтоимостьТМЦВЭксплуатации
				|
				|	И НЕ ИСТИНА В (
				|		ВЫБРАТЬ ПЕРВЫЕ 1
				|			ИСТИНА
				|		ИЗ
				|			РегистрСведений.НастройкаПереходаНаФСБУ5 КАК ТаблицаПолучатель)
				|";
				
				Запрос = Новый Запрос(ТекстЗапроса);
				Запрос.УстановитьПараметр("Организация", Выборка.Организация);
				
				Результат = Запрос.Выполнить();
				ВыборкаИсточник = Результат.Выбрать();
				
				Если ВыборкаИсточник.Следующий() 
					И ЗначениеЗаполнено(ВыборкаИсточник.Период) Тогда
				
					ЗаписьРегистра = НаборЗаписей.Добавить();
					ЗаписьРегистра.Организация = Выборка.Организация;
					ЗаписьРегистра.ГодСписанияСтоимости = Год(ВыборкаИсточник.Период);
					
				КонецЕсли;

			КонецЕсли;
			
			Если НаборЗаписей.Модифицированность() Тогда
				ОбновлениеИнформационнойБазы.ЗаписатьДанные(НаборЗаписей);
			Иначе
				ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(НаборЗаписей);
			КонецЕсли;
			
			ЗафиксироватьТранзакцию();
			
		Исключение
			
			ОтменитьТранзакцию();
			
			ПредставлениеОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
			
			ТекстСообщения = НСтр("ru = 'Не удалось записать данные в регистр %ИмяРегистра% по причине: %Причина%';
									|en = 'Cannot write data to register %ИмяРегистра%. Reason: %Причина%'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Причина%", ПредставлениеОшибки);
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ИмяРегистра%", ПолноеИмяОбъекта);
			
			ЗаписьЖурналаРегистрации(
				ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), 
				УровеньЖурналаРегистрации.Предупреждение,
				МетаданныеОбъекта, 
				Неопределено, 
				ТекстСообщения);
			
			ВызватьИсключение;
			
		КонецПопытки;
		
	КонецЦикла;
	
	Параметры.ОбработкаЗавершена = НЕ ОбновлениеИнформационнойБазы.ЕстьДанныеДляОбработки(Параметры.Очередь, ПолноеИмяОбъекта);
	
КонецПроцедуры
 
#КонецОбласти

#КонецОбласти

#КонецЕсли
