#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс

#Область КомандыПодменюОтчеты

// Добавляет команду отчета в список команд.
// 
// Параметры:
//   КомандыОтчетов - см. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.КомандыОтчетов
// Возвращаемое значение:
//	СтрокаТаблицыЗначений - описание команды отчета.
Функция ДобавитьКомандуОтчета(КомандыОтчетов) Экспорт
	
	Если ПравоДоступа("Просмотр", Метаданные.Отчеты.БазаРаспределенияМатериаловИРабот) Тогда
		
		КомандаОтчет = КомандыОтчетов.Добавить();
		
		КомандаОтчет.Идентификатор               = Метаданные.Отчеты.БазаРаспределенияМатериаловИРабот.ПолноеИмя();
		КомандаОтчет.Менеджер                    = "Отчет.БазаРаспределенияМатериаловИРабот";
		КомандаОтчет.Представление               = НСтр("ru = 'Распределение материала (работы)';
														|en = 'Material (work) allocation'");
		
		КомандаОтчет.МножественныйВыбор          = Ложь;
		КомандаОтчет.Важность                    = "Обычное";
		КомандаОтчет.ФункциональныеОпции         = "ИспользоватьУправлениеПроизводством2_2";
		КомандаОтчет.РежимЗаписи                 = "НеЗаписывать";
		КомандаОтчет.КлючВарианта                = "РаспределениеМатериала";
		
		Возврат КомандаОтчет;
		
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

// Добавляет команду отчета в список команд.
// 
// Параметры:
//   КомандыОтчетов - см. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.КомандыОтчетов
// Возвращаемое значение:
//	СтрокаТаблицыЗначений - описание команды отчета.
Функция ДобавитьКомандуРаспределениеВозвратногоОтхода(КомандыОтчетов) Экспорт
	
	Если ПравоДоступа("Просмотр", Метаданные.Отчеты.БазаРаспределенияМатериаловИРабот) Тогда
		
		КомандаОтчет = КомандыОтчетов.Добавить();
		
		КомандаОтчет.Идентификатор               = Метаданные.Отчеты.БазаРаспределенияМатериаловИРабот.ПолноеИмя();
		КомандаОтчет.Менеджер                    = "Отчет.БазаРаспределенияМатериаловИРабот";
		КомандаОтчет.Представление               = НСтр("ru = 'Распределение возвратного отхода';
														|en = 'Recyclable waste allocation'");
		
		КомандаОтчет.МножественныйВыбор          = Ложь;
		КомандаОтчет.Важность                    = "Обычное";
		КомандаОтчет.ФункциональныеОпции         = "ИспользоватьУправлениеПроизводством2_2";
		КомандаОтчет.РежимЗаписи                 = "Проводить";
		КомандаОтчет.КлючВарианта                = "РаспределениеМатериала";
		
		Возврат КомандаОтчет;
		
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

#КонецОбласти

#КонецОбласти
		
#КонецЕсли