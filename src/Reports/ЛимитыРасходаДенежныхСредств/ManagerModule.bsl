#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс

#Область КомандыПодменюОтчеты

// Добавляет команду отчета в список команд.
// 
// Параметры:
//   КомандыОтчетов - См. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.КомандыОтчетов
//
// Возвращаемое значение:
//	СтрокаТаблицыЗначений, Неопределено - сформированная команда для вывода в подменю.
Функция ДобавитьКомандуОтчета(КомандыОтчетов) Экспорт

	Если ПолучитьФункциональнуюОпцию("ИспользоватьЛимитыРасходаДенежныхСредств") Тогда
		
		Если ПравоДоступа("Просмотр", Метаданные.Отчеты.ЛимитыРасходаДенежныхСредств)
			//++ НЕ УТ
			И Не ПолучитьФункциональнуюОпцию("ИспользоватьЛимитыРасходаДенежныхСредствБюджетирования")
			//-- НЕ УТ
			Тогда
			
			КомандаОтчет = КомандыОтчетов.Добавить();
			
			КомандаОтчет.Менеджер = Метаданные.Отчеты.ЛимитыРасходаДенежныхСредств.ПолноеИмя();
			КомандаОтчет.Представление = НСтр("ru = 'Лимиты расхода ДС';
												|en = 'Cash flow limits'");
			
			КомандаОтчет.МножественныйВыбор = Ложь;
			КомандаОтчет.Важность = "Обычное";
			КомандаОтчет.КлючВарианта = "ЛимитыРасходаДенежныхСредствКонтекст";
			
			Возврат КомандаОтчет;
			
		КонецЕсли;
		
	КонецЕсли;
	
	//++ НЕ УТ
	Если ПравоДоступа("Просмотр", Метаданные.Отчеты.ЛимитыРасходаДенежныхСредствПоДаннымБюджетирования)
		И ПолучитьФункциональнуюОпцию("ИспользоватьЛимитыРасходаДенежныхСредствБюджетирования") Тогда
		
		КомандаОтчет = КомандыОтчетов.Добавить();
		
		КомандаОтчет.Менеджер = Метаданные.Отчеты.ЛимитыРасходаДенежныхСредствПоДаннымБюджетирования.ПолноеИмя();
		КомандаОтчет.Представление = НСтр("ru = 'Лимиты расхода ДС';
											|en = 'Cash flow limits'");
		
		КомандаОтчет.МножественныйВыбор = Ложь;
		КомандаОтчет.Важность = "Обычное";
		КомандаОтчет.КлючВарианта = "ИспользованияЛимитовРасходаДенежныхСредствКонтекст";
		
		Возврат КомандаОтчет;
		
	КонецЕсли;
	//-- НЕ УТ

	Возврат Неопределено;

КонецФункции

#КонецОбласти

#КонецОбласти
		
#КонецЕсли