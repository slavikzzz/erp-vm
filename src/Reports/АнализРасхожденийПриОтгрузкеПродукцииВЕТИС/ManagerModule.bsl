#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс

#Область КомандыПодменюОтчеты

// Добавляет команду отчета в список команд.
// 
// Параметры:
//   КомандыОтчетов - ТаблицаЗначений - состав полей см. в функции МенюОтчеты.СоздатьКоллекциюКомандОтчетов.
//
// Возвращаемое значение:
//   СтрокаТаблицыЗначений, Неопределено - в зависимости от факта добавления отчета
//
Функция ДобавитьКомандуОтчета(КомандыОтчетов) Экспорт

	Если ПравоДоступа("Просмотр", Метаданные.Отчеты.АнализРасхожденийПриОтгрузкеПродукцииВЕТИС) Тогда
		
		КомандаОтчет = КомандыОтчетов.Добавить();
		
		КомандаОтчет.Менеджер = Метаданные.Отчеты.АнализРасхожденийПриОтгрузкеПродукцииВЕТИС.ПолноеИмя();
		КомандаОтчет.Представление = НСтр("ru = 'Расхождения при оформлении исходящей транспортной операции ВетИС';
											|en = 'Расхождения при оформлении исходящей транспортной операции ВетИС'");
		КомандаОтчет.МножественныйВыбор = Истина;
		КомандаОтчет.Важность = "Обычное";
		КомандаОтчет.ДополнительныеПараметры.Вставить("ИмяКоманды", "АнализРасхожденийПриОтгрузкеПродукцииВЕТИС");
		КомандаОтчет.ФункциональныеОпции = "ВестиУчетПодконтрольныхТоваровВЕТИС";
		КомандаОтчет.КлючВарианта = "ОсновнойКонтекст";
		КомандаОтчет.ЕстьУсловияВидимости = Истина;
		
		ПодключаемыеКоманды.ДобавитьУсловиеВидимостиКоманды(КомандаОтчет, "ДокументОснование",, ВидСравненияКомпоновкиДанных.Заполнено);
		
		Возврат КомандаОтчет;
		
	КонецЕсли;

	Возврат Неопределено;

КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли