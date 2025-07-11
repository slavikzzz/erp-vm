#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс

#Область КомандыПодменюОтчеты

// Добавляет команду отчета в список команд.
// 
// Параметры:
// 	КомандыОтчетов - см. ПодключаемыеКомандыПереопределяемый.ПриОпределенииКомандПодключенныхКОбъекту.Команды
// Возвращаемое значение:
// 	Неопределено, СтрокаТаблицыЗначений - описание добавленной команды.
//
Функция ДобавитьКомандуОтчета(КомандыОтчетов) Экспорт

	Если ПравоДоступа("Просмотр", Метаданные.Отчеты.КонтрольПередачиСырьяИМатериаловПереработчику) Тогда
		
		КомандаОтчет = КомандыОтчетов.Добавить();
		
		КомандаОтчет.Менеджер = Метаданные.Отчеты.КонтрольПередачиСырьяИМатериаловПереработчику.ПолноеИмя();
		КомандаОтчет.Представление = НСтр("ru = 'Контроль передачи сырья и материалов';
											|en = 'Control of raw and consumable materials transfer'");
		
		КомандаОтчет.МножественныйВыбор = Ложь;
		КомандаОтчет.Важность = "Обычное";
		КомандаОтчет.КлючВарианта = "КонтрольПередачиСырьяИМатериаловПереработчикуКонтекст";
		
		Возврат КомандаОтчет;
		
	КонецЕсли;

	Возврат Неопределено;

КонецФункции


#КонецОбласти

#КонецОбласти
		
#КонецЕсли