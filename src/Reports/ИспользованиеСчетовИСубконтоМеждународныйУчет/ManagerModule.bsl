#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс

#Область КомандыПодменюОтчеты

// Добавляет команду отчета в список команд.
//  См. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.КомандыОтчетов
// 
// Параметры:
//   КомандыОтчетов - См. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.КомандыОтчетов
// 
// Возвращаемое значение:
//  Неопределено, СтрокаТаблицыЗначений - Добавить команду отчета
//
Функция ДобавитьКомандуОтчета(КомандыОтчетов) Экспорт

	Если ПравоДоступа("Просмотр", Метаданные.Отчеты.ИспользованиеСчетовИСубконтоМеждународныйУчет) 
			И ПолучитьФункциональнуюОпцию("ИспользоватьМеждународныйФинансовыйУчет") Тогда
		
		КомандаОтчет = КомандыОтчетов.Добавить();
		
		КомандаОтчет.Менеджер = Метаданные.Отчеты.ИспользованиеСчетовИСубконтоМеждународныйУчет.ПолноеИмя();
		КомандаОтчет.Представление = НСтр("ru = 'Использование счета';
											|en = 'Use account'");
		
		КомандаОтчет.МножественныйВыбор = Ложь;
		КомандаОтчет.Важность = "Обычное";
		КомандаОтчет.ПараметрыФормы = Новый Структура("КлючПользовательскихНастроек", "ИспользованиеСчетаКонтекстныйОтчет");
		КомандаОтчет.КлючВарианта = "ИспользованиеСчетаКонтекст";
		
		Возврат КомандаОтчет;
		
	КонецЕсли;

	Возврат Неопределено;

КонецФункции

#КонецОбласти

#КонецОбласти
		
#КонецЕсли