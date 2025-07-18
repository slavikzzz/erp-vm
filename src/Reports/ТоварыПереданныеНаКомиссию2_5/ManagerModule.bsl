#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс

#Область КомандыПодменюОтчеты

// Добавляет команду отчета в список команд.
// 
// Параметры:
//   КомандыОтчетов - см. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.КомандыОтчетов
// Возвращаемое значение:
// 	СтрокаТаблицыЗначений
Функция ДобавитьКомандуОтчета(КомандыОтчетов) Экспорт

	Если ПравоДоступа("Просмотр", Метаданные.Отчеты.ТоварыПереданныеНаКомиссию2_5) 
			И ПолучитьФункциональнуюОпцию("ТолькоКомиссионныеПродажи25") Тогда
		
		КомандаОтчет = КомандыОтчетов.Добавить();
		
		КомандаОтчет.Менеджер = Метаданные.Отчеты.ТоварыПереданныеНаКомиссию2_5.ПолноеИмя();
		КомандаОтчет.Представление = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Товары, переданные на комиссию (версия %1)';
				|en = 'Consignment sales stock (version %1)'"),
			КомиссионнаяТорговляСервер.ПостфиксСхемыКомиссии25());
		
		КомандаОтчет.МножественныйВыбор = Ложь;
		КомандаОтчет.Важность = "Обычное";
		КомандаОтчет.КлючВарианта = "ТоварыПереданныеНаКомиссию";
		КомандаОтчет.ЕстьУсловияВидимости = Истина;
		
		ПодключаемыеКоманды.ДобавитьУсловиеВидимостиКоманды(КомандаОтчет,
			"ХозяйственнаяОперация",
			Перечисления.ХозяйственныеОперации.РеализацияЧерезКомиссионера, 
			ВидСравненияКомпоновкиДанных.НеРавно);
		
		Возврат КомандаОтчет;
		
	КонецЕсли;

	Возврат Неопределено;

КонецФункции

#КонецОбласти

#КонецОбласти
		
#КонецЕсли