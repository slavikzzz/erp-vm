///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОписаниеПеременных

&НаКлиенте
Перем ОбновитьИнтерфейс;	// Булево

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЭтоАдминистраторСистемы   = Пользователи.ЭтоПолноправныйПользователь(, Истина);
	РазделениеВключено        = ОбщегоНазначения.РазделениеВключено();
	ЭтоАвтономноеРабочееМесто = ОбщегоНазначения.ЭтоАвтономноеРабочееМесто();
	
	НастройкиПрограммы.ИнтернетПоддержкаИСервисыПриСозданииНаСервере(
		ЭтотОбъект,
		Отказ,
		СтандартнаяОбработка);
	
	// Локализация
	Элементы.ИспользоватьСервисСклоненияMorpher.РасширеннаяПодсказка.Заголовок = СтроковыеФункции.ФорматированнаяСтрока(
		НСтр("ru = 'Разрешить использование внешнего сервиса <a href=""http://www.morpher.ru"">Морфер</a> для получения альтернативного варианта склонения представлений объектов в падежах (требуется подключение к Интернет).
		|Если внешний сервис не используется, склонение представлений выполняется с применением встроенных возможностей приложения.';
		|en = 'Allow usage of <a href=""http://www.morpher.ru"">Morpher</a> declension service to get an alternative object presentation declension in grammar cases (Internet connection is required).
		|If the external service is not used, presentation declension is carried out using the built-in functionality.'"));
	// Конец Локализация
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	НастройкиПрограммыКлиент.ИнтернетПоддержкаИСервисыПриОткрытии(ЭтотОбъект, Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	НастройкиПрограммыКлиент.ИнтернетПоддержкаИСервисыОбработкаОповещения(
		ЭтотОбъект,
		ИмяСобытия,
		Параметр,
		Источник);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	ОбновитьИнтерфейсПрограммы();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИспользоватьВебСервисАдресовПриИзменении(Элемент)
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.НастройкиПрограммы") Тогда
		ПриИзмененииИспользованияВебСервисАдресов(ИспользоватьВебСервисАдресов);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РазрешитьОтправлятьДанныеПриИзменении(Элемент)
	
	ПриИзмененииРежимаОтправкиДанныхВЦентрМониторинга(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура РазрешитьОтправлятьДанныеСтороннемуПриИзменении(Элемент)
	
	ПриИзмененииРежимаОтправкиДанныхВЦентрМониторинга(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗапретитьОтправлятьДанныеПриИзменении(Элемент)
	
	ПриИзмененииРежимаОтправкиДанныхВЦентрМониторинга(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ЦентрМониторингаАдресСервисаПриИзменении(Элемент)
	
	ЦентрМониторингаАдресСервисаПриИзмененииНаСервере(Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьСервисСклоненияMorpherПриИзменении(Элемент)
	
	ПриИзмененииКонстантыНаСервере("ИспользоватьСервисСклоненияMorpher");
	НастройкиПрограммыКлиент.ИнтернетПоддержкаИСервисыПриИзмененииКонстанты(
		ЭтотОбъект,
		Элемент);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗагрузкаАдресногоКлассификатора(Команда)
	
	НастройкиПрограммыКлиент.ИнтернетПоддержкаИСервисыЗагрузкаАдресногоКлассификатора(
		ЭтотОбъект,
		Команда);
	
КонецПроцедуры

&НаКлиенте
Процедура ОчисткаАдресныхСведений(Команда)
	
	НастройкиПрограммыКлиент.ИнтернетПоддержкаИСервисыОчисткаАдресныхСведений(
		ЭтотОбъект,
		Команда);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузкаКурсовВалют(Команда)
	
	НастройкиПрограммыКлиент.ИнтернетПоддержкаИСервисыЗагрузкаКурсовВалют(
		ЭтотОбъект,
		Команда);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодключитьОтключитьОбсуждения(Команда)
	
	НастройкиПрограммыКлиент.ИнтернетПоддержкаИСервисыПодключитьОтключитьОбсуждения(
		ЭтотОбъект,
		Команда);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбсужденияНастроитьИнтеграциюСВнешнимиСистемами(Команда)
	
	НастройкиПрограммыКлиент.ИнтернетПоддержкаИСервисыПоказатьНастройкуИнтеграцииСВнешнимиСистемами(
		ЭтотОбъект,
		Команда);
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкаДоступаКСервисуMorpher(Команда)
	
	НастройкиПрограммыКлиент.ИнтернетПоддержкаИСервисыНастройкаДоступаКСервисуMorpher(
		ЭтотОбъект,
		Команда);
	
КонецПроцедуры

&НаКлиенте
Процедура ЦентрМониторингаНастройки(Команда)
	
	НастройкиПрограммыКлиент.ИнтернетПоддержкаИСервисыЦентрМониторингаНастройки(
		ЭтотОбъект,
		Команда);
	
КонецПроцедуры

&НаКлиенте
Процедура ЦентрМониторингаОтправитьКонтактнуюИнформацию(Команда)
	
	НастройкиПрограммыКлиент.ИнтернетПоддержкаИСервисыЦентрМониторингаОтправитьКонтактнуюИнформацию(
		ЭтотОбъект,
		Команда);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьВнешниеКомпоненты(Команда)
	
	НастройкиПрограммыКлиент.ИнтернетПоддержкаИСервисыОткрытьВнешниеКомпоненты(
		ЭтотОбъект,
		Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// Вызов сервера

&НаСервере
Процедура ПриИзмененииКонстантыНаСервере(ИмяКонстанты)
	
	НастройкиПрограммы.ИнтернетПоддержкаИСервисыПриИзмененииКонстанты(
		ЭтотОбъект,
		ИмяКонстанты,
		ЭтотОбъект[ИмяКонстанты]);
	
КонецПроцедуры

&НаСервере
Процедура РазрешитьОтправлятьДанныеПриИзмененииНаСервере(ИмяЭлемента, ПараметрыОперации)
	
	НастройкиПрограммы.ИнтернетПоддержкаИСервисыРазрешитьОтправлятьДанныеПриИзменении(
		ЭтотОбъект,
		Элементы[ИмяЭлемента],
		ПараметрыОперации);
	
КонецПроцедуры

&НаСервере
Процедура ЦентрМониторингаАдресСервисаПриИзмененииНаСервере(ИмяЭлемента)
	
	НастройкиПрограммы.ИнтернетПоддержкаИСервисыЦентрМониторингаАдресСервисаПриИзменении(
		ЭтотОбъект,
		Элементы[ИмяЭлемента]);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ПриИзмененииИспользованияВебСервисАдресов(ИспользоватьВебСервисАдресов)
	
	НастройкиПрограммы.ИнтернетПоддержкаИСервисыУстановитьИспользованиеВебСервиса(ИспользоватьВебСервисАдресов);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Клиент

&НаКлиенте
Процедура ПриИзмененииРежимаОтправкиДанныхВЦентрМониторинга(Элемент)
	
	ПараметрыЦентраМониторинга = Новый Структура();
	РазрешитьОтправлятьДанныеПриИзмененииНаСервере(Элемент.Имя, ПараметрыЦентраМониторинга);
	НастройкиПрограммыКлиент.ИнтернетПоддержкаИСервисыРазрешитьОтправлятьДанныеПриИзменении(
		ЭтотОбъект,
		Элемент,
		ПараметрыЦентраМониторинга);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИнтерфейсПрограммы()
	
	Если ОбновитьИнтерфейс = Истина Тогда
		ОбновитьИнтерфейс = Ложь;
		ОбщегоНазначенияКлиент.ОбновитьИнтерфейсПрограммы();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
