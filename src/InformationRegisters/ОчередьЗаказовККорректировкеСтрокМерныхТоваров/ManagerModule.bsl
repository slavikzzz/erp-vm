
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Выполняет запись в регистр.
//
// Параметры:
//  ЗаказСсылка  - ДокументСсылка - Ссылка на заказ для добавления.
//  Регистратор - Неопределено, ДокументСсылка - Регистратор
Процедура ДобавитьЗаказВОчередь(ЗаказСсылка, Регистратор = Неопределено) Экспорт
	
	Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьДопустимоеОтклонениеОтгрузкиПриемкиМерныхТоваров") Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если Не Метаданные.РегистрыСведений.ОчередьЗаказовККорректировкеСтрокМерныхТоваров.Измерения.Заказ.Тип.СодержитТип(ТипЗнч(ЗаказСсылка)) Тогда
		Возврат;
	КонецЕсли;
	
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ОчередьЗаказовККорректировкеСтрокМерныхТоваров");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	ЭлементБлокировки.УстановитьЗначение("Заказ",ЗаказСсылка);
	Блокировка.Заблокировать();
	
	МенеджерЗаписи = РегистрыСведений.ОчередьЗаказовККорректировкеСтрокМерныхТоваров.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.Заказ = ЗаказСсылка;
	МенеджерЗаписи.Прочитать();

	Если МенеджерЗаписи.Выбран() Тогда
		Возврат;
	Иначе
		МенеджерЗаписи.Заказ          = ЗаказСсылка;
		МенеджерЗаписи.ДатаДобавления = ТекущаяДатаСеанса();
		
		Попытка
			МенеджерЗаписи.Записать();
		Исключение
			
			Если ЗначениеЗаполнено(Регистратор) Тогда
				ТекстСообщения = НСтр("ru = 'Не удалось выполнить проведение документа: %Ссылка% по причине: %Причина%';
										|en = 'Cannot post document: %Ссылка%. Reason: %Причина%'");
				ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Ссылка%", Регистратор);
				ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Причина%", ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
				ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
					УровеньЖурналаРегистрации.Ошибка, Регистратор.Метаданные(), Регистратор, ТекстСообщения);
			Иначе
				ТекстСообщения = НСтр("ru = 'Не удалось добавить в очередь корректировки строк мерных товаров заказ %Заказ%';
										|en = 'Cannot add the %Заказ% order to the queue for adjustment of lines with measured goods'");
				ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Заказ%", ЗаказСсылка);
				ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
					УровеньЖурналаРегистрации.Ошибка,,, ТекстСообщения);
			КонецЕсли;
			
			ВызватьИсключение;
			
		КонецПопытки;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли