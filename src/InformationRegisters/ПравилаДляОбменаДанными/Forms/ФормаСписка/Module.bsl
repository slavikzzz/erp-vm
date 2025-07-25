///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("ПланыОбменаСПравиламиИзФайла") Тогда
		
		Элементы.ИсточникПравил.Видимость = Ложь;
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список,
			"ИсточникПравил",
			Перечисления.ИсточникиПравилДляОбменаДанными.Файл,
			ВидСравненияКомпоновкиДанных.Равно);
		
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПередУдалением(Элемент, Отказ)
	Отказ = Истина;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОбновитьВсеТиповыеПравила(Команда)
	
	ОбновитьВсеТиповыеПравилаНаСервере();
	Элементы.Список.Обновить();
	
	ПоказатьОповещениеПользователя(НСтр("ru = 'Обновление правил успешно завершено.';
										|en = 'The rule update is completed.'"));
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОбновитьВсеТиповыеПравилаНаСервере()
	
	ОбменДаннымиСервер.ВыполнитьОбновлениеПравилДляОбменаДанными();
	
	ОбновитьПовторноИспользуемыеЗначения();
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьТиповыеПравила(Команда)
	ИспользоватьТиповыеПравилаНаСервере();
	Элементы.Список.Обновить();
	ПоказатьОповещениеПользователя(НСтр("ru = 'Обновление правил успешно завершено.';
										|en = 'The rule update is completed.'"));
КонецПроцедуры

&НаСервере
Процедура ИспользоватьТиповыеПравилаНаСервере()
	
	Для Каждого Запись Из Элементы.Список.ВыделенныеСтроки Цикл
		МенеджерЗаписи = РегистрыСведений.ПравилаДляОбменаДанными.СоздатьМенеджерЗаписи();
		ЗаполнитьЗначенияСвойств(МенеджерЗаписи, Запись);
		МенеджерЗаписи.Прочитать();
		МенеджерЗаписи.ИсточникПравил = Перечисления.ИсточникиПравилДляОбменаДанными.МакетКонфигурации;
		ЕстьОшибки = Ложь;
		РегистрыСведений.ПравилаДляОбменаДанными.ЗагрузитьПравила(ЕстьОшибки, МенеджерЗаписи);
		Если Не ЕстьОшибки Тогда
			МенеджерЗаписи.Записать();
		КонецЕсли;
	КонецЦикла;
	
	ОбменДаннымиСлужебный.СброситьКэшМеханизмаРегистрацииОбъектов();
	ОбновитьПовторноИспользуемыеЗначения();
	
КонецПроцедуры

#КонецОбласти
