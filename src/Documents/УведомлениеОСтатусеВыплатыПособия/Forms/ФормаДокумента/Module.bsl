///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Ключ.Пустая() Тогда
		ВызватьИсключение СтрШаблон(
			НСтр("ru = '%1 загружаются в автоматическом режиме';
				|en = '%1 are imported automatically'"),
			РеквизитФормыВЗначение("Объект").Метаданные().ПредставлениеСписка);
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ИсторияИзменений",
		"Видимость",
		СЭДОФСС.ЕстьПравоПросмотраЖурнала());
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.Свойства
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект, ДополнительныеПараметры);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	ПриПолученииДанныхНаСервере(ТекущийОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// СтандартныеПодсистемы.Свойства
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтотОбъект, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
	Если ИмяСобытия = "Запись_БольничныйЛист"
		Или ИмяСобытия = "Запись_ОтпускПоУходуЗаРебенком"
		Или ИмяСобытия = "Запись_Отпуск"
		Или ИмяСобытия = СЭДОФССКлиент.ИмяСобытияПослеПолученияСообщенийОтФСС()
		Или ИмяСобытия = СЭДОФССКлиент.ИмяСобытияПослеОтправкиПодтвержденияПолучения() Тогда
		Если Модифицированность Тогда
			ОбновитьВторичныеДанныеИВидимостьДоступность();
		Иначе
			Прочитать();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	ФиксацияЗаполнитьИдентификаторыФиксТЧ(ЭтотОбъект);
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ФиксацияВторичныхДанныхВДокументахКлиентСервер.СохранитьРеквизитыФормыФикс(ЭтотОбъект, ТекущийОбъект);
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	ФиксацияЗаполнитьРеквизитыФормыФикс(ТекущийОбъект);
	ФиксацияВторичныхДанныхВДокументахФормы.УстановитьОбъектЗафиксирован(ЭтотОбъект);
	
	ОбновитьЭлементыФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Запись_ОтказВВозмещенииВыплатРодителямДетейИнвалидов", ПараметрыЗаписи, Объект.Ссылка);
	СЭДОФССКлиент.ОповеститьОНеобходимостиОбновитьТекущиеДела();
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(Элемент.ТекстРедактирования, ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура НадписьТребуетсяПодтверждениеОбработкаНавигационнойСсылки(Элемент, Адрес, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	Если Не Записать() Тогда
		Возврат;
	КонецЕсли;
	МассивСсылок = Новый Массив;
	МассивСсылок.Добавить(Объект.Ссылка);
	СЭДОФССКлиент.ОтправитьПодтверждениеПолучения(МассивСсылок);
КонецПроцедуры

&НаКлиенте
Процедура ОбработанПриИзменении(Элемент)
	ОбработанПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ИдентификаторСтрокиРеестраПриИзменении(Элемент)
	ИдентификаторСтрокиРеестраПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура НомерПроцессаПриИзменении(Элемент)
	НомерПроцессаПриИзмененииНаСервере();
КонецПроцедуры


#КонецОбласти


#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПолучитьИзФСС(Команда)
	Если Модифицированность И Не Записать() Тогда
		Возврат;
	КонецЕсли;
	СЭДОФССКлиент.ПолучитьСообщенияИзФСС(Объект.Страхователь);
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	Если Записать() Тогда
		Закрыть();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВключитьВозможностьРедактирования(Команда)
	ВключитьВозможностьРедактированияНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьВторичныеДанные(Команда)
	Если ВозможностьОбновленияВторичныхДанных() Тогда
		ОбновитьВторичныеДанныеНаСервере();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьИсправления(Команда)
	Если ВозможностьОбновленияВторичныхДанных() Тогда
		ОтменитьВсеИсправленияНаСервере();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВопросВПоддержку(Команда)
	
	ВопросВПоддержку = ПодготовитьВопросВПоддержку();
	
	//   *КодОшибки - Строка - идентификатор ошибки при отправки:
	//   *СообщениеОбОшибке - Строка, ФорматированнаяСтрока - сообщение об ошибке для пользователя;
	//   *URLСтраницы - Строка - URL страницы отправки сообщения.
	Если Не ЗначениеЗаполнено(ВопросВПоддержку.КодОшибки) Тогда
		ПараметрыОткрытия = Новый Структура;
		ПараметрыОткрытия.Вставить("ЗаголовокОкна", НСтр("ru = 'Отправка сообщения в службу технической поддержки';
														|en = 'Send a message to technical support.'"));
		ИнтернетПоддержкаПользователейКлиент.ОткрытьВебСтраницуСДополнительнымиПараметрами(
			ВопросВПоддержку.URLСтраницы,
			ПараметрыОткрытия);
	Иначе
		ИнформированиеПользователяКлиент.ПоказатьПодробности(ВопросВПоддержку.СообщениеОбОшибке);
	КонецЕсли;
	
КонецПроцедуры

// СтандартныеПодсистемы.Свойства
&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.Свойства") Тогда
		МодульУправлениеСвойствамиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("УправлениеСвойствамиКлиент");
		МодульУправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

#Область Форма

&НаСервере
Процедура ПриПолученииДанныхНаСервере(ТекущийОбъект)
	
	// Первичная инициализация.
	Если Элементы.СтатусВыплаты.СписокВыбора.Количество() = 0 Тогда
		СЭДОФСС.СписокВыбораТиповУведомлений(Элементы.СтатусВыплаты.СписокВыбора, Объект.СтатусВыплаты);
		СЭДОФСС.СписокВыбораТиповУведомлений(Элементы.СтатусВыплатыПоТегам.СписокВыбора, Объект.СтатусВыплатыПоТегам);
		Для Каждого ЭлементСписка Из Элементы.ВидПособияЧислом.СписокВыбора Цикл
			ЭлементСписка.Представление = Строка(ЭлементСписка.Значение) + " - " + ЭлементСписка.Представление;
		КонецЦикла;
	КонецЕсли;
	
	ЗаполнитьСсылкиСвязанныхДокументов();
	
	ФиксацияВторичныхДанныхВДокументахФормы.ИнициализироватьМеханизмФиксацииРеквизитов(ЭтотОбъект, ТекущийОбъект);
	ФиксацияВторичныхДанныхВДокументахФормы.ПодключитьОбработчикиФиксацииИзмененийРеквизитов(ЭтотОбъект, ФиксацияБыстрыйПоискРеквизитов());
	ОбновитьВторичныеДанныеИВидимостьДоступность();
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСсылкиСвязанныхДокументов()
	
	СвязанныеДокументы = СвязанныеДокументы();
	ПредшествующееУведомление       = СвязанныеДокументы.УведомлениеДо;
	СледующееУведомление            = СвязанныеДокументы.УведомлениеПосле;
	ДокументПоИдентификаторуРеестра = СвязанныеДокументы.ИсходящийДокументПоИдентификаторуРеестра;
	ДокументПоНомеруПроцесса        = СвязанныеДокументы.ВходящийДокументПоНомеруПроцесса;
	
КонецПроцедуры

&НаСервере
Функция СвязанныеДокументы()
	Результат = Новый Структура("УведомлениеДо, УведомлениеПосле,
	|ИсходящийДокументПоИдентификаторуРеестра, ВходящийДокументПоНомеруПроцесса");
	
	Если Не ЗначениеЗаполнено(Объект.ГоловнаяОрганизация) Тогда
		Возврат Результат;
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Объект.НомерПроцесса)
		И Не ЗначениеЗаполнено(Объект.ИдентификаторСтрокиРеестра) Тогда
		Возврат Результат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ГоловнаяОрганизация", Объект.ГоловнаяОрганизация);
	Запрос.УстановитьПараметр("Ссылка", Объект.Ссылка);
	МассивТекстов = Новый Массив;
	Если ЗначениеЗаполнено(Объект.НомерПроцесса) Тогда
		Текст =
		"ВЫБРАТЬ
		|	Уведомление.Ссылка КАК Ссылка,
		|	Уведомление.СтатусВыплаты КАК СтатусВыплаты,
		|	Уведомление.Дата КАК Дата,
		|	Уведомление.ДатаСообщения КАК ДатаСообщения
		|ИЗ
		|	Документ.УведомлениеОСтатусеВыплатыПособия КАК Уведомление
		|ГДЕ
		|	Уведомление.НомерПроцесса = &НомерПроцесса
		|	И Уведомление.ГоловнаяОрганизация = &ГоловнаяОрганизация
		|	И Уведомление.Ссылка <> &Ссылка";
		МассивТекстов.Добавить(Текст);
		Запрос.УстановитьПараметр("НомерПроцесса", Объект.НомерПроцесса);
	КонецЕсли;
	Если ЗначениеЗаполнено(Объект.ИдентификаторСтрокиРеестра) Тогда
		Текст =
		"ВЫБРАТЬ
		|	Уведомление.Ссылка КАК Ссылка,
		|	Уведомление.СтатусВыплаты КАК СтатусВыплаты,
		|	Уведомление.Дата КАК Дата,
		|	Уведомление.ДатаСообщения КАК ДатаСообщения
		|ИЗ
		|	Документ.УведомлениеОСтатусеВыплатыПособия КАК Уведомление
		|ГДЕ
		|	Уведомление.ИдентификаторСтрокиРеестра = &ИдентификаторСтрокиРеестра
		|	И Уведомление.ГоловнаяОрганизация = &ГоловнаяОрганизация
		|	И Уведомление.Ссылка <> &Ссылка";
		МассивТекстов.Добавить(Текст);
		Запрос.УстановитьПараметр("ИдентификаторСтрокиРеестра", Объект.ИдентификаторСтрокиРеестра);
	КонецЕсли;
	Соединитель =
	"
	|
	|ОБЪЕДИНИТЬ
	|
	|";
	Запрос.Текст = СтрСоединить(МассивТекстов, Соединитель);
	
	Если ЗначениеЗаполнено(Объект.ИдентификаторРеестра) Тогда
		Запрос.Текст = Запрос.Текст
		+ ЗарплатаКадрыОбщиеНаборыДанных.РазделительЗапросов()
		+
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	Регистрации.ИсходящийДокумент КАК ИсходящийДокумент,
		|	Регистрации.РегистрацияНомерРеестра КАК РегистрацияНомерРеестра,
		|	Регистрации.РегистрацияДата КАК РегистрацияДата
		|ИЗ
		|	РегистрСведений.РегистрацииОтветовНаЗапросыФССДляРасчетаПособий КАК Регистрации
		|ГДЕ
		|	Регистрации.ГоловнаяОрганизация = &ГоловнаяОрганизация
		|	И Регистрации.РегистрацияНомерРеестра = &ИдентификаторРеестра
		|
		|УПОРЯДОЧИТЬ ПО
		|	Регистрации.РегистрацияДата УБЫВ";
		Запрос.УстановитьПараметр("ИдентификаторРеестра", Объект.ИдентификаторРеестра);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.НомерПроцесса) Тогда
		Запрос.Текст = Запрос.Текст
		+ ЗарплатаКадрыОбщиеНаборыДанных.РазделительЗапросов()
		+
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ВходящийЗапросФСС.Ссылка КАК Ссылка,
		|	ВходящийЗапросФСС.ПометкаУдаления КАК ПометкаУдаления,
		|	ВходящийЗапросФСС.ДатаСообщения КАК ДатаСообщения
		|ИЗ
		|	Документ.ВходящийЗапросФССДляРасчетаПособия КАК ВходящийЗапросФСС
		|ГДЕ
		|	ВходящийЗапросФСС.ГоловнаяОрганизация = &ГоловнаяОрганизация
		|	И ВходящийЗапросФСС.НомерПроцесса = &НомерПроцесса
		|
		|УПОРЯДОЧИТЬ ПО
		|	ПометкаУдаления,
		|	ДатаСообщения УБЫВ";
	КонецЕсли;
	
	РезультатыЗапроса = Запрос.ВыполнитьПакет();
	ИндексПредшествующейТаблицы = -1;
	
	Таблица1 = СледующаяТаблицаИзРезультатовЗапроса(РезультатыЗапроса, ИндексПредшествующейТаблицы);
	Таблица1.Свернуть("Ссылка, СтатусВыплаты, Дата, ДатаСообщения");
	Таблица1.Сортировать("ДатаСообщения, Дата, Ссылка");
	Для Каждого СтрокаТаблицы Из Таблица1 Цикл
		Если СтрокаТаблицы.ДатаСообщения < Объект.ДатаСообщения Тогда
			Результат.УведомлениеДо = СтрокаТаблицы.Ссылка;
		ИначеЕсли СтрокаТаблицы.ДатаСообщения > Объект.ДатаСообщения Тогда
			Результат.УведомлениеПосле = СтрокаТаблицы.Ссылка;
			Прервать;
		ИначеЕсли СтрокаТаблицы.Дата < Объект.Дата Тогда
			Результат.УведомлениеДо = СтрокаТаблицы.Ссылка;
		ИначеЕсли СтрокаТаблицы.Дата > Объект.Дата Тогда
			Результат.УведомлениеПосле = СтрокаТаблицы.Ссылка;
			Прервать;
		ИначеЕсли Строка(СтрокаТаблицы.Ссылка) < Строка(Объект.Ссылка) Тогда
			Результат.УведомлениеДо = СтрокаТаблицы.Ссылка;
		ИначеЕсли Строка(СтрокаТаблицы.Ссылка) > Строка(Объект.Ссылка) Тогда
			Результат.УведомлениеПосле = СтрокаТаблицы.Ссылка;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если ЗначениеЗаполнено(Объект.ИдентификаторРеестра) Тогда
		Таблица2 = СледующаяТаблицаИзРезультатовЗапроса(РезультатыЗапроса, ИндексПредшествующейТаблицы);
		Если Таблица2.Количество() > 0 Тогда
			Результат.ИсходящийДокументПоИдентификаторуРеестра = Таблица2[0].ИсходящийДокумент;
		КонецЕсли;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.НомерПроцесса) Тогда
		Таблица3 = СледующаяТаблицаИзРезультатовЗапроса(РезультатыЗапроса, ИндексПредшествующейТаблицы);
		Если Таблица3.Количество() > 0 Тогда
			Результат.ВходящийДокументПоНомеруПроцесса = Таблица3[0].Ссылка;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Результат;
КонецФункции

&НаСервереБезКонтекста
Функция СледующаяТаблицаИзРезультатовЗапроса(РезультатыЗапроса, ИндексПредшествующейТаблицы)
	ИндексПредшествующейТаблицы = ИндексПредшествующейТаблицы + 1;
	Возврат РезультатыЗапроса[ИндексПредшествующейТаблицы].Выгрузить();
КонецФункции

&НаСервере
Процедура ОбновитьЭлементыФормы()
	ПравоИзменения   = (Элементы.Найти("ФормаПровести") <> Неопределено);
	ПравоПолученияЭД = СЭДОФСС.ЕстьПравоПолучения();
	ПравоОтправкиЭД  = СЭДОФСС.ЕстьПравоОтправки();
	
	// Кнопки командной панели.
	Если ПравоИзменения Тогда
		Если Объект.Загружен Тогда
			Элементы.ФормаПровестиИЗакрыть.КнопкаПоУмолчанию = Истина;
		Иначе
			Элементы.ФормаПровестиИЗакрыть.КнопкаПоУмолчанию = Ложь;
		КонецЕсли;
	КонецЕсли;
	Кнопка = Элементы.Найти("ФормаПовторноПолучитьИзФСС");
	Если Кнопка <> Неопределено Тогда
		Кнопка.Видимость = ПравоИзменения И ПравоПолученияЭД;
		Если Объект.Загружен Тогда
			Кнопка.Заголовок = "";
			Кнопка.КнопкаПоУмолчанию = Ложь;
			Кнопка.ПоложениеВКоманднойПанели = ПоложениеКнопкиВКоманднойПанели.ВДополнительномПодменю;
		Иначе
			Кнопка.Заголовок = НСтр("ru = 'Получить из СФР';
									|en = 'Get from the Social Insurance Fund of Russia'");
			Кнопка.КнопкаПоУмолчанию = Истина;
			Кнопка.ПоложениеВКоманднойПанели = ПоложениеКнопкиВКоманднойПанели.Авто;
		КонецЕсли;
	КонецЕсли;
	
	// Подтверждение получения.
	Если Не Объект.Загружен Тогда
		ТекущаяСтраница = Элементы.ГруппаТребуетсяПолучить;
	ИначеЕсли Не Объект.ТребуетсяПодтверждение Тогда
		ТекущаяСтраница = Элементы.ГруппаНетПодтвержденияПолучения;
	ИначеЕсли ЗначениеЗаполнено(Объект.ДатаОтправкиПодтверждения) Тогда
		Если Объект.ПодтверждениеПолученоСФР Тогда
			ТекущаяСтраница = Элементы.ГруппаПодтверждениеОтправленоИПолучено;
			Элементы.НадписьПодтверждениеОтправленоИПолучено.Заголовок = СтрШаблон(
				НСтр("ru = 'Подтверждение получения отправлено %1 и получено СФР.';
					|en = 'Подтверждение получения отправлено %1 и получено СФР.'"),
				Формат(Объект.ДатаОтправкиПодтверждения, "ДЛФ=D"));
		Иначе
			ТекущаяСтраница = Элементы.ГруппаПодтверждениеОтправленоНоНеПолучено;
			Элементы.НадписьПодтверждениеОтправленоНоНеПолучено.Заголовок = СтрШаблон(
				НСтр("ru = 'Подтверждение получения отправлено %1.';
					|en = 'Подтверждение получения отправлено %1.'"),
				Формат(Объект.ДатаОтправкиПодтверждения, "ДЛФ=D"));
		КонецЕсли;
	Иначе
		ТекущаяСтраница = Элементы.ГруппаТребуетсяПодтверждение;
	КонецЕсли;
	Элементы.СтраницыПодтвержденияПолучения.ТекущаяСтраница = ТекущаяСтраница;
	
	Элементы.ФизическоеЛицо.Видимость = Объект.Загружен;
	Элементы.ВидПособияЧислом.Видимость = Объект.Загружен;
	Элементы.НомерПроцесса.Видимость = Объект.Загружен;
	Элементы.ИдентификаторСтрокиРеестра.Видимость = Объект.Загружен;
	Элементы.Начислено.Видимость = Объект.Загружен;
	Элементы.Выплачено.Видимость = Объект.Загружен;
	Элементы.Удержано.Видимость = Объект.Загружен;
	Элементы.СтатусПлатежа.Видимость = Объект.Загружен;
	Элементы.Пояснения.Видимость = Объект.Загружен;
	Элементы.Обработан.Видимость = Объект.Загружен И Объект.ТребуетсяОбработать;
	
	Элементы.СтраховательНаименование.Видимость = ЗначениеЗаполнено(Объект.СтраховательНаименование);
	
	ЕстьПериод = ЗначениеЗаполнено(Объект.НачалоПериода) Или ЗначениеЗаполнено(Объект.КонецПериода);
	Элементы.НачалоПериода.Видимость = ЕстьПериод;
	Элементы.КонецПериода.Видимость = ЕстьПериод;
	
	// Обновление группы "Связанные документы".
	Элементы.ДокументПоНомеруПроцесса.Видимость = ЗначениеЗаполнено(ДокументПоНомеруПроцесса);
	Элементы.ДокументПоИдентификаторуРеестра.Видимость = ЗначениеЗаполнено(ДокументПоИдентификаторуРеестра);
	Элементы.ПредшествующееУведомление.Видимость = ЗначениеЗаполнено(ПредшествующееУведомление);
	Элементы.СледующееУведомление.Видимость = ЗначениеЗаполнено(СледующееУведомление);
	
	// Обновление фиксируемых реквизитов.
	ФиксацияВторичныхДанныхВДокументахКлиентСервер.ОбновитьФорму(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область Команды

&НаСервере
Процедура ВключитьВозможностьРедактированияНаСервере()
	Для Каждого Элемент Из Элементы Цикл
		Если (ТипЗнч(Элемент) = Тип("ПолеФормы")
				Или ТипЗнч(Элемент) = Тип("ГруппаФормы")
				Или ТипЗнч(Элемент) = Тип("ТаблицаФормы"))
			И Элемент.ТолькоПросмотр Тогда
			Элемент.ТолькоПросмотр = Ложь;
		КонецЕсли;
	КонецЦикла;
	
	Прочитать();
КонецПроцедуры

#КонецОбласти

#Область ЭлементыШапки

&НаСервере
Процедура ОбработанПриИзмененииНаСервере()
	ЗафиксироватьИзменениеРеквизита("Обработан");
	Если Не ЭтотОбъект["ОтветственныйФикс"] Тогда
		Объект.Ответственный = Пользователи.ТекущийПользователь();
	КонецЕсли;
	ФиксацияВторичныхДанныхВДокументахФормы.УстановитьОбъектЗафиксирован(ЭтотОбъект);
	ОбновитьЭлементыФормы();
КонецПроцедуры

&НаСервере
Процедура ОбновитьВторичныеДанныеИВидимостьДоступность()
	ОбновитьВторичныеДанныеНаСервере();
	ОбновитьЭлементыФормы();
КонецПроцедуры

#КонецОбласти

#Область ПодключаемыеКоманды

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#Область Свойства

// СтандартныеПодсистемы.Свойства
&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

#КонецОбласти

#Область ФиксацияВторичныхДанныхВДокументах

&НаСервереБезКонтекста
Функция Менеджер()
	Возврат Документы.ОтказВВозмещенииВыплатРодителямДетейИнвалидов;
КонецФункции

&НаСервере
Функция ОбъектЗафиксирован() Экспорт
	Возврат Менеджер().ОбъектЗафиксирован(Объект);
КонецФункции

&НаКлиенте
Функция ВозможностьОбновленияВторичныхДанных()
	Если Объект.Обработан Тогда
		Текст = НСтр("ru = 'Необходимо отключить флажок ""Документ обработан""';
					|en = 'Необходимо отключить флажок ""Документ обработан""'");
		СообщенияБЗККлиентСервер.СообщитьВФорме(Текст, "Обработан", "Объект", ЭтотОбъект);
		Возврат Ложь;
	КонецЕсли;
	Возврат Истина;
КонецФункции

&НаСервере
Процедура ОбновитьВторичныеДанныеНаСервере()
	Если ФиксацияВторичныхДанныхВДокументахКлиентСервер.ОбъектФормыЗафиксирован(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	ФиксацияЗаполнитьИдентификаторыФиксТЧ(ЭтотОбъект);
	ДокументОбъект = РеквизитФормыВЗначение("Объект");
	ФиксацияВторичныхДанныхВДокументахКлиентСервер.СохранитьРеквизитыФормыФикс(ЭтотОбъект, ДокументОбъект);
	
	ПараметрыФиксации = ЭтотОбъект["ПараметрыФиксацииВторичныхДанных"];
	ДокументИзменен = ДокументОбъект.ОбновитьВторичныеДанные(ПараметрыФиксации);
	
	Если ДокументИзменен Тогда
		Если ТолькоПросмотр Или Не ПравоДоступа("Изменение", ДокументОбъект.Метаданные()) Тогда
			ФиксацияВторичныхДанныхВДокументахФормы.ВывестиПредупреждениеОНаличииИзмененийВИсходныхДанныхКоторыеНельзяПрименить(
				ЭтотОбъект);
		Иначе
			Если Не ДокументОбъект.ЭтоНовый() Тогда
				ФиксацияВторичныхДанныхВДокументахФормы.УстановитьМодифицированность(ЭтотОбъект, Истина);
			КонецЕсли;
			ЗначениеВРеквизитФормы(ДокументОбъект, "Объект");
			ФиксацияЗаполнитьРеквизитыФормыФикс(Объект);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ФиксацияОписаниеФормы(ПараметрыФиксацииВторичныхДанных) Экспорт
	ОписаниеФормы = ФиксацияВторичныхДанныхВДокументахФормы.ОписаниеФормы();
	
	ОписаниеЭлементовФормы = Новый Соответствие();
	ОписаниеЭлементаФормы = ФиксацияВторичныхДанныхВДокументахФормы.ОписаниеЭлементаФормы();
	ОписаниеЭлементаФормы.ПрефиксПути = "Объект";
	Для Каждого ОписаниеФиксацииРеквизита Из ПараметрыФиксацииВторичныхДанных.ОписаниеФиксацииРеквизитов Цикл
		ОписаниеЭлементовФормы.Вставить(ОписаниеФиксацииРеквизита.Ключ, ОписаниеЭлементаФормы);
	КонецЦикла;
	ОписаниеФормы.Вставить("ОписаниеЭлементовФормы", ОписаниеЭлементовФормы);
	
	ОписаниеФормы.Вставить("ФормаРедактируетсяПослеФиксации", Ложь);
	Возврат ОписаниеФормы;
КонецФункции

&НаСервере
Функция ФиксацияБыстрыйПоискРеквизитов()
	БыстрыйПоискРеквизитов = Новый Соответствие; // Ключ - имя элемента, значение - имя реквизита.
	
	ПараметрыФиксации = ЭтотОбъект["ПараметрыФиксацииВторичныхДанных"];
	Для Каждого КлючИЗначение Из ПараметрыФиксации.ОписаниеФиксацииРеквизитов Цикл
		ИмяРеквизита = КлючИЗначение.Значение.ИмяРеквизита;
		//Если Элементы.Найти(ИмяРеквизита) <> Неопределено Тогда
		//	БыстрыйПоискРеквизитов.Вставить(ИмяРеквизита, ИмяРеквизита);
		//ИначеЕсли Элементы.Найти(КлючИЗначение.Ключ) <> Неопределено Тогда
		//	БыстрыйПоискРеквизитов.Вставить(КлючИЗначение.Ключ, ИмяРеквизита);
		//КонецЕсли;
		Если Элементы.Найти(КлючИЗначение.Ключ) <> Неопределено Тогда
			БыстрыйПоискРеквизитов.Вставить(КлючИЗначение.Ключ, КлючИЗначение);
		ИначеЕсли Элементы.Найти(ИмяРеквизита) <> Неопределено Тогда
			БыстрыйПоискРеквизитов.Вставить(ИмяРеквизита, КлючИЗначение);
		КонецЕсли;
	КонецЦикла;
	
	Возврат БыстрыйПоискРеквизитов;
КонецФункции

&НаСервере
Процедура ФиксацияЗаполнитьРеквизитыФормыФикс(ТекущийОбъект)
	ФиксацияВторичныхДанныхВДокументахФормы.ЗаполнитьРеквизитыФормыФикс(ЭтотОбъект, ТекущийОбъект);
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ФиксацияЗаполнитьИдентификаторыФиксТЧ(Форма)
	ФиксацияВторичныхДанныхВДокументахКлиентСервер.ЗаполнитьИдентификаторыСтрок(Форма);
КонецПроцедуры

&НаСервере
Процедура ОтменитьВсеИсправленияНаСервере()
	ФиксацияВторичныхДанныхВДокументахКлиентСервер.ОчиститьФиксациюИзменений(ЭтотОбъект, Объект);
	ФиксацияЗаполнитьРеквизитыФормыФикс(Объект);
	ОбновитьВторичныеДанныеИВидимостьДоступность();
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ЗафиксироватьИзменениеРеквизитаВФорме(Элемент, СтандартнаяОбработка = Ложь) Экспорт
	ОписаниеЭлементов = ФиксацияБыстрыйПоискРеквизитов();
	ФиксацияВторичныхДанныхВДокументахКлиентСервер.Подключаемый_ЗафиксироватьИзменениеРеквизитаВФорме(ЭтотОбъект, Элемент, ОписаниеЭлементов);
	ОбновитьЭлементыФормы();
КонецПроцедуры

&НаСервере
Процедура ЗафиксироватьИзменениеРеквизита(Имя)
	ОписаниеЭлементов = ФиксацияБыстрыйПоискРеквизитов();
	ФиксацияВторичныхДанныхВДокументахКлиентСервер.Подключаемый_ЗафиксироватьИзменениеРеквизитаВФорме(
		ЭтотОбъект,
		Элементы[Имя],
		ОписаниеЭлементов);
	ФиксацияВторичныхДанныхВДокументахКлиентСервер.СброситьФиксациюИзмененийРеквизитовПоОснованиюЗаполнения(
		ЭтотОбъект,
		Имя);
КонецПроцедуры

#КонецОбласти

#Область Поддержка

&НаСервере
Функция ПодготовитьВопросВПоддержку()
	ДокументОбъект = РеквизитФормыВЗначение("Объект");
	Вложения = Новый Массив;
	Возврат СЭДОФСС.ПодготовитьВопросВПоддержку(ДокументОбъект, Вложения);
КонецФункции

#КонецОбласти

&НаСервере
Процедура ИдентификаторСтрокиРеестраПриИзмененииНаСервере()
	Объект.ИдентификаторРеестра = Документы.УведомлениеОСтатусеВыплатыПособия.ИдентификаторРеестра(
		Объект.ИдентификаторСтрокиРеестра);
	ПриПолученииДанныхНаСервере("Объект");
КонецПроцедуры

&НаСервере
Процедура НомерПроцессаПриИзмененииНаСервере()
	ПриПолученииДанныхНаСервере("Объект");
КонецПроцедуры

#КонецОбласти
