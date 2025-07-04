#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

Функция СледующаяГраницаРасчета() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ГраницаРасчета = -1;
	
	НачатьТранзакцию();
	Попытка
		
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить("Константа.ГраницаРасчетаСтруктурыЗаказов");
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
		Блокировка.Заблокировать();
		
		ГраницаРасчета = Константы.ГраницаРасчетаСтруктурыЗаказов.Получить();
		ГраницаРасчета = ГраницаРасчета + 1;
		
		Константы.ГраницаРасчетаСтруктурыЗаказов.Установить(ГраницаРасчета);
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		ОтменитьТранзакцию();
		ГраницаРасчета = -1;
		ЗаписьЖурналаРегистрации(СтруктураЗаказа.ИмяСобытияЖурналаРегистрации(), УровеньЖурналаРегистрации.Ошибка,,,
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ВызватьИсключение;
	КонецПопытки;
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат ГраницаРасчета;
	
КонецФункции

Функция ТекущаяОчередь() Экспорт

	Возврат Константы.ГраницаРасчетаСтруктурыЗаказов.Получить();
	
КонецФункции

#КонецОбласти

#КонецЕсли
