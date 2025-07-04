&НаКлиенте
Перем КонтекстЭДОКлиент Экспорт;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если ДокументооборотСКОКлиентСервер.ПодсистемаЦБСуществует() Тогда
		Элементы.ЭДОСНалоговымиОрганамиПФРИРосстатом.Заголовок = НСтр("ru = 'Настройки обмена с ФНС, Росстатом, ПФР и Банком России';
																		|en = 'Настройки обмена с ФНС, Росстатом, ПФР и Банком России'");
	КонецЕсли;
	Элементы.ЭДОСНалоговымиОрганамиПФРИРосстатом.Заголовок = ДокументооборотСКОКлиентСервер.ЗаменитьПФРиФССнаСФР(
		Элементы.ЭДОСНалоговымиОрганамиПФРИРосстатом.Заголовок, Истина);
	
	Элементы.ЭДОСФСС.Заголовок = ДокументооборотСКОКлиентСервер.ЗаменитьПФРиФССнаСФР(Элементы.ЭДОСФСС.Заголовок, Истина);
	
	Организация = Параметры.Организация;
	
	ИспользуетсяОднаОрганизация = РегламентированнаяОтчетностьВызовСервера.ИспользуетсяОднаОрганизация();
	
	ЕстьРеквизитОрганизацииНаименованиеСокращенное =
		(Метаданные.Справочники.Организации.Реквизиты.Найти("НаименованиеСокращенное") <> Неопределено);
	
	СвойстваОрганизации = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Организация, "Наименование"
		+ ?(ЕстьРеквизитОрганизацииНаименованиеСокращенное, ", НаименованиеСокращенное", ""), Истина);
	
	СокращенноеНаименованиеОрганизации = ?(ЕстьРеквизитОрганизацииНаименованиеСокращенное,
		?(ЗначениеЗаполнено(СвойстваОрганизации.НаименованиеСокращенное), СвойстваОрганизации.НаименованиеСокращенное,
		СвойстваОрганизации.Наименование), СвойстваОрганизации.Наименование);
	
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиентСервер.ДобавитьОрганизациюВЗаголовок(
		ЭтотОбъект.Заголовок,
		ИспользуетсяОднаОрганизация,
		СокращенноеНаименованиеОрганизации,
		НСтр("ru = 'Расширенные настройки';
			|en = 'Расширенные настройки'"));
	
	Если ОбщегоНазначения.ПодсистемаСуществует("РегламентированнаяОтчетность.ЭлектронныйДокументооборотСКонтролирующимиОрганами.ПроверкаВРЭЦ") Тогда
		Элементы.ЭДОСРЭЦ.Видимость = Истина;	
	Иначе
		Элементы.ЭДОСРЭЦ.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриОткрытииПослеПолученияКонтекстаЭДО", ЭтотОбъект);
	ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ЭДОСНалоговымиОрганамиПФРИРосстатомНажатие(Элемент)
	
	Если КонтекстЭДОКлиент = Неопределено Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстОшибкиИнициализацииКонтекстаЭДО);
	Иначе
		КонтекстЭДОКлиент.ОткрытьФормуНастройкиЭДОсФНСиПФРиРосстатомиЦБ(Организация, ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЭДОСФССНажатие(Элемент)
	
	Если КонтекстЭДОКлиент = Неопределено Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстОшибкиИнициализацииКонтекстаЭДО);
	Иначе
		КонтекстЭДОКлиент.ОткрытьФормуНастройкиЭДОсФСС(Организация, ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЭДОСРосалкогольрегулированиемНажатие(Элемент)
	
	Если КонтекстЭДОКлиент = Неопределено Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстОшибкиИнициализацииКонтекстаЭДО);
	Иначе
		КонтекстЭДОКлиент.ОткрытьФормуНастройкиЭДОсФСРАР(Организация, ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЭДОСРосприроднадзоромНажатие(Элемент)
	
	Если КонтекстЭДОКлиент = Неопределено Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстОшибкиИнициализацииКонтекстаЭДО);
	Иначе
		КонтекстЭДОКлиент.ОткрытьФормуНастройкиЭДОсРПН(Организация, ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЭДОСФТСНажатие(Элемент)
	
	Если КонтекстЭДОКлиент = Неопределено Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстОшибкиИнициализацииКонтекстаЭДО);
	Иначе
		КонтекстЭДОКлиент.ОткрытьФормуНастройкиЭДОсФТС(Организация, ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПриОткрытииПослеПолученияКонтекстаЭДО(Результат, ДополнительныеПараметры) Экспорт
	
	КонтекстЭДОКлиент 						= Результат.КонтекстЭДО;
	ТекстОшибкиИнициализацииКонтекстаЭДО 	= Результат.ТекстОшибки;
	
КонецПроцедуры

&НаКлиенте
Процедура ЭДОСРЭЦНажатие(Элемент)
	
	Если КонтекстЭДОКлиент = Неопределено Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстОшибкиИнициализацииКонтекстаЭДО);
	Иначе
		КонтекстЭДОКлиент.ОткрытьФормуНастройкиЭДОсРЭЦ(Организация, ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
