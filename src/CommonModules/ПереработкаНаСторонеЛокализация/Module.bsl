////////////////////////////////////////////////////////////////////////////////
// Подсистема "Переработка на стороне".
// 
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#Область ГруппыЗатрат

// Выводит сообщения об ошибках заполнения групп затрат
// 
// Параметры:
// 	Выборка - ВыборкаИзРезультатаЗапроса
// 	ПредставлениеГруппЗатрат - Соответствие
// 	Отказ - Булево
//
Процедура СообщитьОшибкиЗаполненияГруппЗатрат(Выборка, ПредставлениеГруппЗатрат, Отказ) Экспорт
	
	//++ Локализация
	
	ШаблонНеУказанПрослеживаемыйМатериал =
		НСтр("ru = 'Для группы затрат ""%1"" основным материалом должен быть указан материал, прослеживаемый по РНПТ, так как в ней указано изделие, прослеживаемое по РНПТ.';
			|en = 'For the group of the ""%1"" costs, the material specified as the main one must be traceable by goods batch registration number as the group contains a finished product which is traceable by goods batch registration number.'");
	
	Если Выборка.ТипПроверки = "НеУказанПрослеживаемыйМатериал" Тогда
		
		ТекстСообщения =
			СтрШаблон(
				ШаблонНеУказанПрослеживаемыйМатериал,
				ПредставлениеГруппЗатрат[Выборка.НомерГруппыЗатрат]);
		
		ОбщегоНазначения.СообщитьПользователю(
			ТекстСообщения,,
			Выборка.ИмяТаблицы,
			"Объект",
			Отказ);
		
	КонецЕсли;
	
	//-- Локализация
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти