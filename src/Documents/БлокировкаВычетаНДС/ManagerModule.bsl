#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Определяет список команд отчетов.
//
// Параметры:
//   КомандыОтчетов - См. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.КомандыОтчетов
//   Параметры - См. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.Параметры
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры) Экспорт
	
КонецПроцедуры

// Заполняет список команд печати.
//
// Параметры:
//   КомандыПечати - см. УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	Возврат;
	
КонецПроцедуры

#Область ДляВызоваИзДругихПодсистем

// Определяет список команд создания на основании.
//
// Параметры:
//  КомандыСозданияНаОсновании - ТаблицаЗначений - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.
//  Параметры - Структура - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСозданияНаОсновании, Параметры) Экспорт
	
	БизнесПроцессы.Задание.ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании);
	
КонецПроцедуры

// Для использования в процедуре ДобавитьКомандыСозданияНаОсновании других модулей менеджеров объектов.
// Добавляет в список команд создания на основании этот объект.
//
// Параметры:
//  КомандыСозданияНаОсновании - ТаблицаЗначений - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.
//
// Возвращаемое значение:
//  СтрокаТаблицыЗначений, Неопределено - описание добавленной команды.
//
Функция ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании) Экспорт
	
	Возврат СозданиеНаОсновании.ДобавитьКомандуСозданияНаОсновании(КомандыСозданияНаОсновании, Метаданные.Документы.БлокировкаВычетаНДС);
	
КонецФункции

// СтандартныеПодсистемы.УправлениеДоступом

// Параметры:
//   Ограничение - см. УправлениеДоступомПереопределяемый.ПриЗаполненииОграниченияДоступа.Ограничение.
//
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#КонецЕсли

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияПолейПредставления(Поля, СтандартнаяОбработка)
	
	Поля.Добавить("Номер");
	Поля.Добавить("Дата");
	Поля.Добавить("Состояние");
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если Данные.Состояние = Перечисления.СостоянияБлокировкиВычетаНДС.Установлена Тогда
		ПредставлениеОперации = НСтр("ru = 'Установка блокировки вычета НДС %1 от %2';
									|en = 'Set VAT deduction lock %1 from %2'");
	Иначе
		ПредставлениеОперации = НСтр("ru = 'Снятие блокировки вычета НДС %1 от %2';
									|en = 'Unlock %1 VAT deduction dated %2'");
	КонецЕсли;
	
	Представление = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ПредставлениеОперации, Данные.Номер, Данные.Дата);
	
КонецПроцедуры

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	Если ВидФормы = "ФормаОбъекта" Тогда
		
		Если (Параметры.Свойство("Основание")
			И ЗначениеЗаполнено(Параметры.Основание)) Тогда
			
			Параметры.Вставить("Организация",  Параметры.Основание.Организация);
			Параметры.Вставить("КонецПериода", КонецМесяца(Параметры.Основание.Дата));
			СтандартнаяОбработка = Ложь;
			ВыбраннаяФорма = "ФормаПодбораУстановкаБлокировки";
		
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
