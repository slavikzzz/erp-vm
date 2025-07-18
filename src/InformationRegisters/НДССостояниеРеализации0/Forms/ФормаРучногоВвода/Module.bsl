#Область ОписаниеПеременных

&НаКлиенте
Перем ВыполняетсяЗакрытие;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	Документ 			= Параметры.Документ;
	Организация 		= Параметры.Организация;
	Состояние			= Параметры.Состояние;
	ДатаПодтверждения 	= Параметры.ДатаПодтверждения;
	СтавкаНДС 			= Параметры.СтавкаНДС;
	Комментарий 		= Параметры.Комментарий;
	ТекущийПериод		= Параметры.ТекущийПериод;
	
	Если Состояние = Перечисления.НДССостоянияРеализация0.ПодтверждениеНеТребуется Тогда
		ТолькоПросмотр = Истина;
		Элементы.Состояние.СписокВыбора.Добавить(Перечисления.НДССостоянияРеализация0.ПодтверждениеНеТребуется);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьВидимость();
		
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если Модифицированность И ЗавершениеРаботы Тогда
		Отказ = Истина;
		ВыполняетсяЗакрытие = Истина;
		ТекстПредупреждения = НСтр("ru = 'Данные были изменены. Вы уверены, что хотите продолжить закрытие без сохранения изменений?';
									|en = 'Data was changed. Are you sure you want to continue closing without saving the changes?'");
	КонецЕсли;
		
	Если Не ВыполняетсяЗакрытие И Модифицированность Тогда
        Отказ = Истина;
		ПоказатьВопрос(Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект), НСтр("ru = 'Данные были изменены. Перенести изменения?';
																								|en = 'Data has changed. Transfer the changes?'"), РежимДиалогаВопрос.ДаНетОтмена);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    Ответ = РезультатВопроса;
    
    Если Ответ = КодВозвратаДиалога.Да Тогда
        ВыполняетсяЗакрытие = Истина;
        СохранитьРезультат();
    ИначеЕсли Ответ = КодВозвратаДиалога.Нет Тогда
        ВыполняетсяЗакрытие = Истина;
		Модифицированность = Ложь;
        Закрыть(Неопределено);
    КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

&НаКлиенте
Процедура Сохранить(Команда)
	
	СохранитьРезультат();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ПриИзмененииРеквизитов

&НаКлиенте
Процедура СостояниеПриИзменении(Элемент)
	
	Если Состояние = ПредопределенноеЗначение("Перечисление.НДССостоянияРеализация0.НеПодтвержденаРеализация0") Тогда
		СтавкаНДС = УчетНДСУПВызовСервера.СтавкаНДСПоУмолчанию(Организация, НачалоКвартала(ТекущийПериод));
		ДатаПодтверждения = КонецКвартала(ТекущийПериод);
	ИначеЕсли Состояние = ПредопределенноеЗначение("Перечисление.НДССостоянияРеализация0.ПодтвержденаРеализация0") Тогда
		СтавкаНДС = ПредопределенноеЗначение("Справочник.СтавкиНДС.ПустаяСсылка");
		ДатаПодтверждения = КонецКвартала(ТекущийПериод);
	Иначе
		ДатаПодтверждения = '00010101';
	КонецЕсли;
	
	УстановитьВидимость();
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаКлиенте
Процедура УстановитьВидимость()
	
	Если Состояние = ПредопределенноеЗначение("Перечисление.НДССостоянияРеализация0.НеПодтвержденаРеализация0") Тогда
		Элементы.СтавкаНДС.Видимость 			= Истина;
		Элементы.ДатаПодтверждения.Видимость 	= Истина;
	ИначеЕсли Состояние = ПредопределенноеЗначение("Перечисление.НДССостоянияРеализация0.ПодтвержденаРеализация0") Тогда
		Элементы.СтавкаНДС.Видимость 			= Ложь;
		Элементы.ДатаПодтверждения.Видимость 	= Истина;
	ИначеЕсли Состояние = ПредопределенноеЗначение("Перечисление.НДССостоянияРеализация0.ПодтверждениеНеТребуется") Тогда
		Элементы.СтавкаНДС.Видимость 			= Ложь;
		Элементы.ДатаПодтверждения.Видимость 	= Истина;
	Иначе
		Элементы.СтавкаНДС.Видимость 			= Ложь;
		Элементы.ДатаПодтверждения.Видимость 	= Ложь;
	КонецЕсли;	
		
КонецПроцедуры		

&НаКлиенте
Процедура СохранитьРезультат()
	
	Результат = Новый Структура("Состояние, СтавкаНДС, Комментарий", Состояние, СтавкаНДС, Комментарий);
	
	Модифицированность = Ложь;
	
	ОповеститьОВыборе(Результат);
	
КонецПроцедуры	

#КонецОбласти

#КонецОбласти

#Область Инициализация

ВыполняетсяЗакрытие = Ложь;

#КонецОбласти