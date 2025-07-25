////////////////////////////////////////////////////////////////////////////////
// СотрудникиВызовСервера: методы, обслуживающие работу формы сотрудника.
//  
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

Функция СообщениеОКонфликтеВидаЗанятостиНовогоСотрудникаССуществующими(Сотрудник, ФизическоеЛицо, Организация, ВидЗанятости, ДатаПриема) Экспорт
	 Возврат СотрудникиФормы.СообщениеОКонфликтеВидаЗанятостиНовогоСотрудникаССуществующими(Сотрудник, ФизическоеЛицо, Организация, ВидЗанятости, ДатаПриема);
КонецФункции

Функция ПолучитьВидЗанятостиДляНовогоСотрудника(Знач Сотрудник, Знач Организация, Знач ФизическоеЛицо = Неопределено) Экспорт
	Возврат СотрудникиФормы.ПолучитьВидЗанятостиДляНовогоСотрудника(Сотрудник, Организация, ФизическоеЛицо);
КонецФункции

Функция ПохожиеФизическиеЛица(ПараметрыПоиска) Экспорт
	Возврат СотрудникиФормы.ПохожиеФизическиеЛица(ПараметрыПоиска);
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ОбработчикиСобытийМодуляМенеджера

Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка) Экспорт
	
	СотрудникиВнутренний.ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

Функция ПараметрыОткрытияСогласияНаОбработкуПерсональныхДанных(Сотрудник) Экспорт
	
	ПараметрыОткрытия = Новый Структура;
	
	КадровыеДанные = КадровыйУчет.КадровыеДанныеСотрудников(Истина, Сотрудник, "Организация, ФизическоеЛицо");
	Если КадровыеДанные.Количество() > 0 Тогда
		ПараметрыОткрытия.Вставить("Организация", КадровыеДанные[0].Организация);
		ПараметрыОткрытия.Вставить("Субъект", КадровыеДанные[0].ФизическоеЛицо);
	КонецЕсли;
	
	Возврат ПараметрыОткрытия;
	
КонецФункции

Функция ЗаблокироватьФизическоеЛицоПриРедактированииНаСервере(ФизическоеЛицоСсылка, ФизическоеЛицоВерсияДанных, ФормаУникальныйИдентификатор) Экспорт
	Возврат СотрудникиФормы.ЗаблокироватьФизическоеЛицоПриРедактированииНаСервере(ФизическоеЛицоСсылка, ФизическоеЛицоВерсияДанных, ФормаУникальныйИдентификатор);
КонецФункции

Функция ЗаблокироватьСотрудникаПриРедактированииНаСервере(СотрудникСсылка, СотрудникВерсияДанных, ФормаУникальныйИдентификатор) Экспорт
	
	Возврат СотрудникиФормы.ЗаблокироватьСотрудникаПриРедактированииНаСервере(СотрудникСсылка, СотрудникВерсияДанных, ФормаУникальныйИдентификатор);
	
КонецФункции

Функция ИННИСНИЛСУникальны(ИНН, СНИЛС) Экспорт
	
	Запрос = Новый Запрос;
	
	Запрос.Текст =
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ФизическиеЛица.Ссылка
		|ИЗ
		|	Справочник.ФизическиеЛица КАК ФизическиеЛица
		|ГДЕ
		|	ФизическиеЛица.ИНН = &ИНН
		|	И &ИНН <> """"
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ ПЕРВЫЕ 1
		|	ФизическиеЛица.Ссылка
		|ИЗ
		|	Справочник.ФизическиеЛица КАК ФизическиеЛица
		|ГДЕ
		|	ФизическиеЛица.СтраховойНомерПФР = &СНИЛС
		|	И &СНИЛС <> """"";
		
	Запрос.УстановитьПараметр("ИНН", ИНН);
	Запрос.УстановитьПараметр("СНИЛС", СокрЛП(СтрЗаменить(СНИЛС, "-", "")));
	
	УстановитьПривилегированныйРежим(Истина);
	
	РезультатПроверкиУникальности =  Запрос.Выполнить().Пустой();
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат РезультатПроверкиУникальности;
	
КонецФункции

Функция ФизическиеЛицаСотрудников(Знач Сотрудники) Экспорт
	
	Если ТипЗнч(Сотрудники) = Тип("Массив") Тогда
		СписокСотрудников = Сотрудники;
	Иначе
		СписокСотрудников = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Сотрудники);
	КонецЕсли;
	
	Возврат КадровыйУчет.ФизическиеЛицаСотрудников(СписокСотрудников);
	
КонецФункции

Функция ДоступенВыборСтраныВыдачиДокумента(ВидДокумента) Экспорт 
	
	Если Не ЗначениеЗаполнено(ВидДокумента) Тогда 
		Возврат Ложь;
	КонецЕсли;
	
	КодВидаДокумента = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВидДокумента, "КодМВД");
	
	СписокКодов = Новый Массив;
	СписокКодов.Добавить("01");
	СписокКодов.Добавить("02");
	СписокКодов.Добавить("03");
	СписокКодов.Добавить("04");
	СписокКодов.Добавить("05");
	СписокКодов.Добавить("06");
	СписокКодов.Добавить("07");
	СписокКодов.Добавить("08");
	СписокКодов.Добавить("09");
	СписокКодов.Добавить("11");
	СписокКодов.Добавить("12");
	СписокКодов.Добавить("13");
	СписокКодов.Добавить("14");
	СписокКодов.Добавить("15");
	СписокКодов.Добавить("18");
	СписокКодов.Добавить("21");
	СписокКодов.Добавить("22");
	СписокКодов.Добавить("24");
	СписокКодов.Добавить("26");
	СписокКодов.Добавить("27");
	
	Возврат СписокКодов.Найти(КодВидаДокумента) = Неопределено;
	
КонецФункции

Функция ДлительнаяОперацияЗаполненияИсторииВзаимоотношенийНаСервере(ИдентификаторФормы, ФизическиеЛица) Экспорт
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(ИдентификаторФормы);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Заполнение истории взаимоотношений физических лиц';
															|en = 'Filling in the history of relationships between individuals'");
	
	Возврат ДлительныеОперации.ВыполнитьФункцию(
		ПараметрыВыполнения, "СотрудникиФормы.ИсторияВзаимоотношенийСКомпанией", ФизическиеЛица);

КонецФункции

#КонецОбласти
