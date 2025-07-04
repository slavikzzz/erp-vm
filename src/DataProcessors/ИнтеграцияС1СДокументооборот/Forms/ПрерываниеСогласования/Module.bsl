#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("ПовторныйЗапуск") Тогда
		Заголовок = НСтр("ru = 'Повторный запуск согласования';
						|en = 'Restart approval'");
		Элементы.ГруппаПредупреждение.ТекущаяСтраница = Элементы.ГруппаПредупреждениеПовторныйЗапуск;
	КонецЕсли;
	
	Прокси = ИнтеграцияС1СДокументооборотБазоваяФункциональностьПовтИсп.ПолучитьПрокси();
	Запрос = ИнтеграцияС1СДокументооборотБазоваяФункциональность.СоздатьОбъект(Прокси, "DMGetApprovalSheetRequest");
	Запрос.object = ИнтеграцияС1СДокументооборотБазоваяФункциональность.СоздатьОбъект(Прокси, Параметры.Предмет.type);
	Запрос.object.objectID = ИнтеграцияС1СДокументооборотБазоваяФункциональность.СоздатьObjectID(
		Прокси,
		Параметры.Предмет.ID,
		Параметры.Предмет.type);
	Запрос.object.name = Параметры.Предмет.name;
	Ответ = ИнтеграцияС1СДокументооборотБазоваяФункциональность.ВыполнитьЗапрос(Прокси, Запрос);
	ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПроверитьВозвратВебСервиса(Прокси, Ответ);
	
	Для Каждого Пункт Из Ответ.items Цикл
		Если Пункт.result = "Согласовано" Тогда
			СтрокаЛиста = ЛистСогласования.Добавить();
			СтрокаЛиста.ФИО = Пункт.name;
			СтрокаЛиста.Должность = Пункт.position;
			СтрокаЛиста.Дата = Пункт.date;
			СтрокаЛиста.Результат = Пункт.result;
			СтрокаЛиста.Примечание = Пункт.comment;
		КонецЕсли;
	КонецЦикла;
	
	Если ЛистСогласования.Количество() = 0 Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	ЛистСогласования.Сортировать("Дата, ФИО");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаПрервать(Команда)
	
	Закрыть(КодВозвратаДиалога.ОК);
	
КонецПроцедуры

#КонецОбласти