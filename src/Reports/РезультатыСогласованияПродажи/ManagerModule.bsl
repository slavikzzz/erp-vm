#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс

#Область КомандыПодменюОтчеты

// Добавляет команду отчета в список команд.
// 
// Параметры:
//   КомандыОтчетов - см. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.КомандыОтчетов
// Возвращаемое значение:
//   СтрокаТаблицыЗначений - новая команда отчета.
Функция ДобавитьКомандуРезультатыСогласованияЗаказаКлиента(КомандыОтчетов) Экспорт

	Если ПравоДоступа("Просмотр", Метаданные.Отчеты.РезультатыСогласованияПродажи) 
			И (ПолучитьФункциональнуюОпцию("ИспользоватьВнутреннееСогласованиеЗаказовКлиентов")
				ИЛИ ПолучитьФункциональнуюОпцию("ИспользоватьВнутреннееСогласованиеСоглашенийСКлиентами")) Тогда
		
		КомандаОтчет = КомандыОтчетов.Добавить();
		
		КомандаОтчет.Менеджер = Метаданные.Отчеты.РезультатыСогласованияПродажи.ПолноеИмя();
		КомандаОтчет.Представление = НСтр("ru = 'Результаты согласования';
											|en = 'Approval results'");
		
		КомандаОтчет.МножественныйВыбор = Истина;
		КомандаОтчет.Важность = "Обычное";
		КомандаОтчет.ФункциональныеОпции = "ИспользоватьВнутреннееСогласованиеЗаказовКлиентов";
		КомандаОтчет.ДополнительныеПараметры.Вставить("ИмяКоманды", "РезультатыСогласованияЗаказаКлиента");
		
		Возврат КомандаОтчет;
		
	КонецЕсли;

	Возврат Неопределено;

КонецФункции

// Добавляет команду отчета в список команд.
// 
// Параметры:
//   КомандыОтчетов - см. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.КомандыОтчетов
// Возвращаемое значение:
//   СтрокаТаблицыЗначений - новая команда отчета.
//
Функция ДобавитьКомандуРезультатыСогласованияПродажи(КомандыОтчетов) Экспорт

	Если ПравоДоступа("Просмотр", Метаданные.Отчеты.РезультатыСогласованияПродажи) 
			И (ПолучитьФункциональнуюОпцию("ИспользоватьВнутреннееСогласованиеЗаказовКлиентов")
				ИЛИ ПолучитьФункциональнуюОпцию("ИспользоватьВнутреннееСогласованиеСоглашенийСКлиентами")) Тогда
		
		КомандаОтчет = КомандыОтчетов.Добавить();
		
		КомандаОтчет.Менеджер = Метаданные.Отчеты.РезультатыСогласованияПродажи.ПолноеИмя();
		КомандаОтчет.Представление = НСтр("ru = 'Результаты согласования';
											|en = 'Approval results'");
		
		КомандаОтчет.МножественныйВыбор = Истина;
		КомандаОтчет.Важность = "Обычное";
		КомандаОтчет.ФункциональныеОпции = "ИспользоватьВнутреннееСогласованиеЗаказовКлиентов,ИспользоватьВнутреннееСогласованиеСоглашенийСКлиентами";
		КомандаОтчет.ДополнительныеПараметры.Вставить("ИмяКоманды", "РезультатыСогласованияПродажи");
		
		Возврат КомандаОтчет;
		
	КонецЕсли;

	Возврат Неопределено;

КонецФункции

// Добавляет команду отчета в список команд.
// 
// Параметры:
//   КомандыОтчетов - см. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.КомандыОтчетов
// Возвращаемое значение:
//   СтрокаТаблицыЗначений - новая команда отчета.
Функция ДобавитьКомандуРезультатыСогласованияСоглашенияСКлиентами(КомандыОтчетов) Экспорт

	Если ПравоДоступа("Просмотр", Метаданные.Отчеты.РезультатыСогласованияПродажи) 
			И (ПолучитьФункциональнуюОпцию("ИспользоватьВнутреннееСогласованиеЗаказовКлиентов")
				ИЛИ ПолучитьФункциональнуюОпцию("ИспользоватьВнутреннееСогласованиеСоглашенийСКлиентами")) Тогда
		
		КомандаОтчет = КомандыОтчетов.Добавить();
		
		КомандаОтчет.Менеджер = Метаданные.Отчеты.РезультатыСогласованияПродажи.ПолноеИмя();
		КомандаОтчет.Представление = НСтр("ru = 'Результаты согласования';
											|en = 'Approval results'");
		
		КомандаОтчет.МножественныйВыбор = Истина;
		КомандаОтчет.Важность = "Обычное";
		КомандаОтчет.ФункциональныеОпции = "ИспользоватьВнутреннееСогласованиеСоглашенийСКлиентами";
		КомандаОтчет.ДополнительныеПараметры.Вставить("ИмяКоманды", "РезультатыСогласованияСоглашенияСКлиентами");
		
		Возврат КомандаОтчет;
		
	КонецЕсли;

	Возврат Неопределено;

КонецФункции

#КонецОбласти

#КонецОбласти
		
#КонецЕсли