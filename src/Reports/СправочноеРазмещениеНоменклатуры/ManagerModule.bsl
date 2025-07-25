#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс

#Область КомандыПодменюОтчеты

// Добавляет команду отчета в список команд.
// 
// Параметры:
//   КомандыОтчетов - См. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.КомандыОтчетов
//
// Возвращаемое значение:
//  Неопределено, СтрокаТаблицыЗначений - команда отчета
Функция ДобавитьКомандуОтчета(КомандыОтчетов) Экспорт

	Если ПравоДоступа("Просмотр", Метаданные.Отчеты.СправочноеРазмещениеНоменклатуры) 
			И ПолучитьФункциональнуюОпцию("ИспользоватьАдресноеХранениеСправочно") Тогда
		
		КомандаОтчет = КомандыОтчетов.Добавить();
		
		КомандаОтчет.Менеджер = Метаданные.Отчеты.СправочноеРазмещениеНоменклатуры.ПолноеИмя();
		КомандаОтчет.Представление = НСтр("ru = 'Размещение номенклатуры по ячейкам';
											|en = 'Inventory put-away'");
		
		КомандаОтчет.МножественныйВыбор = Ложь;
		КомандаОтчет.Важность = "Обычное";
		КомандаОтчет.КлючВарианта = "РазмещениеНоменклатурыПоЯчейкамСправочноКонтекст";
		
		Возврат КомандаОтчет;
		
	КонецЕсли;

	Возврат Неопределено;

КонецФункции

#КонецОбласти

#КонецОбласти
		
#КонецЕсли