#Область ОписаниеПеременных

&НаКлиенте
Перем ОбновитьИнтерфейс;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	// Обновление состояния элементов
	УстановитьДоступность();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	ОбновитьИнтерфейсПрограммы();
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ЗначенияПоУмолчанию = Новый Структура;

	НастройкиСистемыЛокализация.ПриЧтенииНаСервере_Продажи(ЭтаФорма);
	ОбщегоНазначенияУТКлиентСервер.СохранитьЗначенияДоИзменения(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
// Обработчик оповещения формы.
//
// Параметры:
//	ИмяСобытия - Строка - обрабатывается только событие Запись_НаборКонстант, генерируемое панелями администрирования.
//	Параметр   - Структура - содержит имена констант, подчиненных измененной константе, "вызвавшей" оповещение.
//	Источник   - Строка - имя измененной константы, "вызвавшей" оповещение.
//
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия <> "Запись_НаборКонстант" Тогда
		Возврат; // такие событие не обрабатываются
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИспользоватьМобильноеПриложение1СЗаказыКлиентовПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьНастройкиPushУведомленийМобильногоПриложения1СЗаказы(Команда)
	ОткрытьФорму("ПланОбмена.МобильноеПриложениеЗаказыКлиентов.Форма.ФормаГлавногоУзла",, ЭтотОбъект,,,,,РежимОткрытияОкнаФормы.Независимый);
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСписокУстройствСМобильнымПриложением1CЗаказы(Команда)
	ПараметрыФормы = Новый Структура("НеОтображатьЭтотУзел", Истина);
	ОткрытьФорму("ПланОбмена.МобильноеПриложениеЗаказыКлиентов.ФормаСписка", ПараметрыФормы, ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьНастройкиСинхронизацииРеквизитовОбъектов1СЗаказы(Команда)
	ОткрытьФорму("ПланОбмена.МобильноеПриложениеЗаказыКлиентов.Форма.ФормаНастройкиРеквизитовОбмена",, ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ПодсказкаОМобильномПриложенииНажатие(Элемент)
	ПараметрыФормы = Новый Структура("ИмяМакетаОписания, НазваниеПриложения", 
		"ОписаниеМобильногоПриложенияЗаказы", НСтр("ru = '1С:Заказы';
													|en = '1C:Orders'"));
	ОткрытьФорму("ОбщаяФорма.ОписаниеМобильногоПриложения", ПараметрыФормы, ЭтаФорма,,,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Клиент

&НаКлиенте
Процедура Подключаемый_ПриИзмененииРеквизита(Элемент, ОбновлятьИнтерфейс = Истина, ВнешнееИзменение = Ложь)
	
	КонстантаИмя = ПриИзмененииРеквизитаСервер(Элемент.Имя);
	
	Если ОбновлятьИнтерфейс Тогда
		ОбновитьИнтерфейс = Истина;
		ПодключитьОбработчикОжидания("ОбновитьИнтерфейсПрограммы", 2, Истина);
	КонецЕсли;
	
	Если КонстантаИмя <> "" Тогда
		Оповестить("Запись_НаборКонстант", Новый Структура, КонстантаИмя);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИнтерфейсПрограммы()
	
	Если ОбновитьИнтерфейс = Истина Тогда
		ОбновитьИнтерфейс = Ложь;
		ОбщегоНазначенияКлиент.ОбновитьИнтерфейсПрограммы();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ВызовСервера

&НаСервере
Функция ПриИзмененииРеквизитаСервер(ИмяЭлемента)
	
	РеквизитПутьКДанным = Элементы[ИмяЭлемента].ПутьКДанным;
	
	КонстантаИмя = СохранитьЗначениеРеквизита(РеквизитПутьКДанным,  Новый Структура);
	
	УстановитьДоступность(РеквизитПутьКДанным);
	
	ОбновитьПовторноИспользуемыеЗначения();
	
	Возврат КонстантаИмя;
	
КонецФункции

#КонецОбласти

#Область Сервер

&НаСервере
Функция СохранитьЗначениеРеквизита(РеквизитПутьКДанным, Результат)
	
	// Сохранение значений реквизитов, не связанных с константами напрямую (в отношении один-к-одному).
	Если РеквизитПутьКДанным = "" Тогда
		Возврат "";
	КонецЕсли;
	
	// Определение имени константы.
	КонстантаИмя = "";
	Если СтрНачинаетсяС(НРег(РеквизитПутьКДанным), НРег("НаборКонстант.")) Тогда
		// Если путь к данным реквизита указан через "НаборКонстант".
		ЧастиИмени = СтрРазделить(РеквизитПутьКДанным, ".");
		КонстантаИмя = ЧастиИмени[1];
	КонецЕсли;
	
	// Сохранения значения константы.
	Если КонстантаИмя <> "" Тогда
		КонстантаМенеджер = Константы[КонстантаИмя];
		КонстантаЗначение = НаборКонстант[КонстантаИмя];
		
		Если КонстантаМенеджер.Получить() <> КонстантаЗначение Тогда
			КонстантаМенеджер.Установить(КонстантаЗначение);
		КонецЕсли;
		
		Если НастройкиСистемыПовтИсп.ЕстьПодчиненныеКонстанты(КонстантаИмя, КонстантаЗначение) Тогда
			ЭтаФорма.Прочитать();
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат КонстантаИмя;
	
КонецФункции

&НаСервере
Процедура УстановитьДоступность(РеквизитПутьКДанным = "")
	
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьМобильноеПриложение1СЗаказыКлиентов" ИЛИ РеквизитПутьКДанным = "" Тогда
		
		ЗначениеКонстанты = НаборКонстант.ИспользоватьМобильноеПриложение1СЗаказыКлиентов;
		Элементы.ОткрытьСписокУстройствСМобильнымПриложением1СЗаказы.Доступность = ЗначениеКонстанты;
		Элементы.ОткрытьНастройкиPushУведомленийМобильногоПриложения1СЗаказы.Доступность = ЗначениеКонстанты;
		Элементы.ОткрытьНастройкиСинхронизацииРеквизитовОбъектов1СЗаказы.Доступность = ЗначениеКонстанты;
		УстановитьДоступность("НаборКонстант.ИспользоватьЗаказыКлиентов");
	КонецЕсли;
	
КонецПроцедуры


#КонецОбласти

#КонецОбласти
