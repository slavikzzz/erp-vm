#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если НЕ ПравоДоступа("Чтение", Метаданные.Справочники.УпаковкиВЕТИС) Тогда
		ВызватьИсключение Нстр("ru = 'Нет прав на просмотр справочника упаковок';
								|en = 'Нет прав на просмотр справочника упаковок'");
	КонецЕсли;
	
	ТолькоПросмотр = Истина;
	
	Если Параметры.Свойство("Ключ")
		И ЗначениеЗаполнено(Параметры.Ключ) Тогда
		
		СправочникОбъект = Параметры.Ключ.ПолучитьОбъект();
		ЗначениеВРеквизитФормы(СправочникОбъект, "Объект");
		Элементы.Загрузить.Видимость = Ложь;
		
	ИначеЕсли Параметры.Свойство("ЗначенияЗаполнения") Тогда
		
		ЗаполнитьЗначенияСвойств(Объект, Параметры.ЗначенияЗаполнения);
		Элементы.Загрузить.Видимость = ПравоДоступа("Добавление", Метаданные.Справочники.УпаковкиВЕТИС);
		
	Иначе
		
		ВызватьИсключение НСтр("ru = 'В форму должен быть передан либо параметр ""Ключ"", либо параметр ""Значения заполнения""';
								|en = 'В форму должен быть передан либо параметр ""Ключ"", либо параметр ""Значения заполнения""'");
		
	КонецЕсли;
	
	ОбщегоНазначенияСобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Загрузить(Команда)
	
	Оповестить("Запись_УпаковкиВЕТИС", ЗагрузитьУпаковкиВЕТИСНаСервере());
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ЗагрузитьУпаковкиВЕТИСНаСервере()
	
	СправочникОбъект = РеквизитФормыВЗначение("Объект");
	СправочникОбъект.Записать();
	
	Возврат СправочникОбъект.Ссылка;

КонецФункции

#КонецОбласти


