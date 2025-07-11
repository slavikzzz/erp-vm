///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОписаниеПеременных

&НаКлиенте
Перем ПрограммноеЗакрытие;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	РежимФормы = "Смена";
	Если ЗначениеЗаполнено(Параметры.РежимФормы) Тогда
		РежимФормы = Параметры.РежимФормы;
	КонецЕсли;
	
	ПояснениеОперации = Параметры.ПояснениеОперации;
	Обязательно = Параметры.Обязательно;
	НастройкиПользователя = Параметры.НастройкиПользователя;
	СкрыватьПароль = Истина;
	
	КлючСохраненияПоложенияОкна = "НастройкиФормы_" + РежимФормы;
	ПодготовитьФорму();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	СервисКриптографииDSSСлужебныйКлиент.ПриОткрытииФормы(ЭтотОбъект, ПрограммноеЗакрытие);
	ПодключитьОбработчикОжидания("ОбновитьРазмерыФормы", 0.2, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если СервисКриптографииDSSСлужебныйКлиент.ПередЗакрытиемФормы(
			ЭтотОбъект,
			Отказ,
			ПрограммноеЗакрытие,
			ЗавершениеРаботы) Тогда
		ЗакрытьФорму();
	КонецЕсли;	
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НовыйПарольНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОткрытьВидимостьЭлемента("НовыйПароль");
	
КонецПроцедуры

&НаКлиенте
Процедура СтарыйПарольНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОткрытьВидимостьЭлемента("СтарыйПароль");
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверочныйПарольНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОткрытьВидимостьЭлемента("ПроверочныйПароль");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	КодЯзыка = СервисКриптографииDSSСлужебныйКлиент.КодЯзыка();
	
	Если НовыйПароль = ПроверочныйПароль
		И Обязательно
		И НЕ ЗначениеЗаполнено(НовыйПароль) Тогда
		СервисКриптографииDSSСлужебныйКлиент.ВывестиОшибку(Неопределено, 
			НСтр("ru = 'Необходимо указать новый пин-код';
				|en = 'Specify a new PIN'", КодЯзыка));
	ИначеЕсли НовыйПароль = ПроверочныйПароль
			И НЕ ЗначениеЗаполнено(НовыйПароль) Тогда
		ЗадатьВопросОСбросеПинКода();
	ИначеЕсли НовыйПароль = ПроверочныйПароль Тогда
		ЗакрытьФорму(ПодготовитьРезультат(Истина));
	Иначе
		СервисКриптографииDSSСлужебныйКлиент.ВывестиОшибку(Неопределено, 
			НСтр("ru = 'Новый пин-код и его подтверждение не совпадают';
				|en = 'New PIN and its confirmation do not match'", КодЯзыка));
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	ЗакрытьФорму();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ЗадатьВопросОСбросеПинКода()
	
	ОповещениеСледующее = Новый ОписаниеОповещения("ЗадатьВопросОСбросеПинКодаЗавершение", ЭтотОбъект);
	
	СписокКоманд = Новый СписокЗначений;
	СписокКоманд.Добавить("ОК", НСтр("ru = 'Сбросить';
									|en = 'Reset'"), Истина);
	СписокКоманд.Добавить("Отмена", НСтр("ru = 'Отмена';
										|en = 'Cancel'"));
	
	ТекстВопроса = НСтр("ru = 'Сбросить пин-код для доступа к сертификату?';
						|en = 'Reset the PIN to access the certificate?'");
	
	СервисКриптографииDSSСлужебныйКлиент.ВывестиВопрос(
		ОповещениеСледующее,
		ТекстВопроса,
		СписокКоманд);
				
КонецПроцедуры

&НаКлиенте
Процедура ЗадатьВопросОСбросеПинКодаЗавершение(РезультатВыбора, ДополнительныеПараметры) Экспорт
	
	Если РезультатВыбора.Выполнено И РезультатВыбора.Результат = "ОК" Тогда
		ЗакрытьФорму(ПодготовитьРезультат(Истина));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ПодготовитьРезультат(Подтвердили = Ложь)
	
	ОтветПользователя = СервисКриптографииDSSКлиент.ОтветСервисаПоУмолчанию(Истина);
	ОтветПользователя.Выполнено = Подтвердили;
	ОтветПользователя.Вставить("Результат", ЗакрытьДанныеПользователя(СтарыйПароль));
	ОтветПользователя.Вставить("НовыйПинКод", ЗакрытьДанныеПользователя(НовыйПароль));
	ОтветПользователя.Вставить("Сохранить", Сохранить);
	
	Если НЕ ОтветПользователя.Выполнено Тогда
		СервисКриптографииDSSСлужебныйКлиент.СформироватьОтказАутентификации(ОтветПользователя);
	КонецЕсли;
	
	Возврат ОтветПользователя;
	
КонецФункции

&НаКлиенте
Процедура ЗакрытьФорму(ПараметрыЗакрытия = Неопределено)
	
	ПрограммноеЗакрытие = Истина;
	
	Если ПараметрыЗакрытия = Неопределено Тогда
		ПараметрыЗакрытия = ПодготовитьРезультат();
	КонецЕсли;
	
	Закрыть(ПараметрыЗакрытия);
	
КонецПроцедуры	

&НаКлиенте
Процедура ОткрытьВидимостьЭлемента(ИмяЭлемента)
	
	ЭлементПароля = Элементы[ИмяЭлемента];
	Если ЭлементПароля.РежимПароля Тогда
		Элементы[ИмяЭлемента].КартинкаКнопкиВыбора = КартинкаОткрыть;
		ЭтотОбъект[ИмяЭлемента] = Элементы[ИмяЭлемента].ТекстРедактирования;
		ЭлементПароля.РежимПароля = Ложь;
		Если СкрыватьПароль Тогда
			ПодключитьОбработчикОжидания("ПодключаемыйОтключитьВидимостьПароля", 2, Истина);
		КонецЕсли;
	ИначеЕсли СкрыватьПароль Тогда
		ЭлементПароля.РежимПароля = Истина;
		Элементы[ИмяЭлемента].КартинкаКнопкиВыбора = КартинкаЗакрыть;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПодключаемыйОтключитьВидимостьПароля()
	
	МассивЭлементов = Новый Массив;
	МассивЭлементов.Добавить("СтарыйПароль");
	МассивЭлементов.Добавить("НовыйПароль");
	МассивЭлементов.Добавить("ПроверочныйПароль");
	
	Для каждого СтрокаМассива Из МассивЭлементов Цикл
		ЭлементФормы = Элементы[СтрокаМассива];
		Если НЕ ЭлементФормы.РежимПароля Тогда
			ЭлементФормы.КартинкаКнопкиВыбора = КартинкаЗакрыть;
			ЭлементФормы.РежимПароля = Истина;
		КонецЕсли;	
	КонецЦикла;	
	
КонецПроцедуры

&НаКлиенте
Функция ЗакрытьДанныеПользователя(ВведенноеЗначение) 
	
	ПризнакКонфиденциальности = СервисКриптографииDSSКлиентСервер.ПолучитьПолеСтруктуры(НастройкиПользователя, "ПризнакКонфиденциальности", 1);
	
	Если ЗначениеЗаполнено(ВведенноеЗначение) Тогда
		Результат = СервисКриптографииDSSКлиент.ПодготовитьОбъектПароля(ВведенноеЗначение, ПризнакКонфиденциальности);
	Иначе
		Результат = СервисКриптографииDSSКлиентСервер.ОбъектПароля("", 3);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура ПодготовитьФорму()
	
	КартинкаОткрыть = СервисКриптографииDSS.ПолучитьКартинкуПодсистемы("ВводимыеСимволыСкрыты");
	КартинкаЗакрыть = СервисКриптографииDSS.ПолучитьКартинкуПодсистемы("ВводимыеСимволыВидны");
	КодЯзыка = СервисКриптографииDSSСлужебный.КодЯзыка();
	
	Если РежимФормы = "Установка" Тогда
		Элементы.ГруппаСтарыйПароль.Видимость = Ложь;
		Элементы.ГруппаСохранить.Видимость = Ложь;
		Заголовок = НСтр("ru = 'Установка нового пин-кода';
						|en = 'Set a new PIN'", КодЯзыка);
	Иначе
		Заголовок = НСтр("ru = 'Смена пин-кода';
						|en = 'Change PIN'", КодЯзыка);
	КонецЕсли;	
	
	Элементы.СтарыйПароль.КартинкаКнопкиВыбора = КартинкаЗакрыть;
	Элементы.НовыйПароль.КартинкаКнопкиВыбора = КартинкаЗакрыть;
	Элементы.ПроверочныйПароль.КартинкаКнопкиВыбора = КартинкаЗакрыть;
	Элементы.ГруппаПояснениеОперации.Видимость = ЗначениеЗаполнено(ПояснениеОперации);
	
КонецПроцедуры	

&НаКлиенте
Процедура ОбновитьРазмерыФормы()
	
	Элементы.ГруппаНовыйПароль.Видимость = НЕ Элементы.ГруппаНовыйПароль.Видимость;
	Элементы.ГруппаНовыйПароль.Видимость = НЕ Элементы.ГруппаНовыйПароль.Видимость;
	
КонецПроцедуры

#КонецОбласти

