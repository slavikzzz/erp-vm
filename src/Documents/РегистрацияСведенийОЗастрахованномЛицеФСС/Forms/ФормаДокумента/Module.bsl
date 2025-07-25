#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Объект.Ссылка.Пустая() Тогда
		ВызватьИсключение НСтр("ru = 'Регистрации загружаются в автоматическом режиме';
								|en = 'Registrations are imported automatically'");
	КонецЕсли;
	
	ТолькоПросмотр = Истина;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.Свойства
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	ДополнительныеПараметры.Вставить("ИмяЭлементаКоманднойПанели", "ОсновнаяКоманднаяПанель");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект, ДополнительныеПараметры);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	ТолькоПросмотр = Истина;
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	ОбновитьЭлементыФормы();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	Если ЗначениеЗаполнено(Объект.РегистрацияСтатус)
		И Элементы.РегистрацияСтатус.СписокВыбора.НайтиПоЗначению(Объект.РегистрацияСтатус) = Неопределено Тогда
		Представление = СтрШаблон(НСтр("ru = 'Неизвестный статус регистрации: %1';
										|en = 'Unknown registration status: %1'"), Объект.РегистрацияСтатус);
		Элементы.РегистрацияСтатус.СписокВыбора.Добавить(Объект.РегистрацияСтатус, Представление);
	КонецЕсли;
	
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
	
	Если ИмяСобытия = "Запись_СведенияОЗастрахованномЛицеФСС"
		И (Источник = Объект.ДокументОснование Или Не ЗначениеЗаполнено(Источник)) Тогда
		ПодключитьОбработчикОжиданияПрочитать();
		
	ИначеЕсли ИмяСобытия = СЭДОФССКлиент.ИмяСобытияПослеПолученияСообщенийОтФСС()
		Или ИмяСобытия = СЭДОФССКлиент.ИмяСобытияПослеОтправкиПодтвержденияПолучения() Тогда
		ПодключитьОбработчикОжиданияПрочитать();
		
	ИначеЕсли ИмяСобытия = "Запись_РезультатыРегистрацииСведенийОЗастрахованномЛицеФСС"
		И (Источник = Объект.Ссылка Или Не ЗначениеЗаполнено(Источник)) Тогда
		ПодключитьОбработчикОжиданияПрочитать();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Запись_РегистрацияСведенийОЗастрахованномЛицеФСС", ПараметрыЗаписи, Объект.Ссылка);
	СЭДОФССКлиент.ОповеститьОНеобходимостиОбновитьТекущиеДела();
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПоясняющаяНадписьВШапкеОбработкаНавигационнойСсылки(Элемент, Адрес, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ОткрытьФорму("Документ.СведенияОЗастрахованномЛицеФСС.ФормаОбъекта", Новый Структура("Ключ", Объект.ДокументОснование));
КонецПроцедуры

&НаКлиенте
Процедура ВключитьВозможностьРедактирования(Команда)
	ТолькоПросмотр = Не ТолькоПросмотр;
	Элементы.Состояние.Вид = ВидПоляФормы.ПолеВвода;
	ОбновитьЭлементыФормы();
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовТаблицыФормы

#КонецОбласти


#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ДоставкаИдентификаторТекстXML(Команда)
	СЭДОФССКлиент.ПоказатьТекстXML(Объект.ДоставкаИдентификатор);
КонецПроцедуры

&НаКлиенте
Процедура РегистрацияИдентификаторТекстXML(Команда)
	СЭДОФССКлиент.ПоказатьТекстXML(Объект.РегистрацияИдентификатор);
КонецПроцедуры

&НаКлиенте
Процедура НесоответствиеИдентификаторТекстXML(Команда)
	СЭДОФССКлиент.ПоказатьТекстXML(Объект.НесоответствиеИдентификатор);
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

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

&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.Свойства") Тогда
		МодульУправлениеСвойствамиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("УправлениеСвойствамиКлиент");
		МодульУправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

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

&НаКлиенте
Процедура ПодключитьОбработчикОжиданияПрочитать()
	ОтключитьОбработчикОжидания("ОбработчикОжиданияПрочитать");
	ПодключитьОбработчикОжидания("ОбработчикОжиданияПрочитать", 0.2, Истина);
КонецПроцедуры

&НаКлиенте
Процедура ОбработчикОжиданияПрочитать()
	Если Не Модифицированность Тогда
		Прочитать();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ОбновитьЭлементыФормы()
	Элементы.ВключитьВозможностьРедактирования.Пометка = Не ТолькоПросмотр;
	
	Элементы.ДоставкаИдентификаторТекстXML.Видимость       = ЗначениеЗаполнено(Объект.ДоставкаИдентификатор);
	Элементы.РегистрацияИдентификаторТекстXML.Видимость    = ЗначениеЗаполнено(Объект.РегистрацияИдентификатор);
	Элементы.НесоответствиеИдентификаторТекстXML.Видимость = ЗначениеЗаполнено(Объект.НесоответствиеИдентификатор);
	
	Элементы.Ответственный.Видимость = Не ТолькоПросмотр Или ЗначениеЗаполнено(Объект.Ответственный);
	Элементы.Комментарий.Видимость   = Не ТолькоПросмотр Или ЗначениеЗаполнено(Объект.Комментарий);
	
	Элементы.ГруппаСлужебныеПоля.Видимость = Не ТолькоПросмотр;
	Элементы.РезультатРегистрацииГруппа.Видимость = Не ТолькоПросмотр
		Или Объект.Зарегистрирован
		Или (Не Объект.ЕстьОшибкиЛогическогоКонтроля
			И Не Объект.ЕстьНесоответствия);
	Элементы.ГруппаНесоответствие.Видимость = Не ТолькоПросмотр
		Или Объект.ЕстьНесоответствия;
	Элементы.ОшибкиЛогическогоКонтроляГруппа.Видимость = Не ТолькоПросмотр
		Или Объект.ЕстьОшибкиЛогическогоКонтроля;
	
	ОтправленОператору = (Объект.ОтправленОператору Или ЗначениеЗаполнено(Объект.ДатаОтправкиОператору));
	Элементы.ОтправленОператору.Видимость          = Не ТолькоПросмотр Или ОтправленОператору;
	Элементы.ДатаОтправкиОператору.Видимость       = Не ТолькоПросмотр Или ОтправленОператору;
	Элементы.ДоставкаИдентификаторПакета.Видимость = Не ТолькоПросмотр Или ОтправленОператору
		Или ЗначениеЗаполнено(Объект.ДоставкаИдентификаторПакета);
	
	ДоставкаТекстОшибкиКоличество = 0;
	Если Элементы.РезультатОтправкиГруппа.Видимость Тогда
		Если ЗначениеЗаполнено(Объект.ДоставкаТекстОшибки) Или Не ТолькоПросмотр Тогда
			ДоставкаТекстОшибкиКоличество = СтрЧислоСтрок(Объект.ДоставкаТекстОшибки);
			Элементы.ДоставкаТекстОшибки.Видимость = Истина;
			Элементы.ДоставкаТекстОшибки.Высота = Мин(Макс(ДоставкаТекстОшибкиКоличество, 2), 4);
		Иначе
			Элементы.ДоставкаТекстОшибки.Видимость = Ложь;
		КонецЕсли;
	КонецЕсли;
	ОшибкиЛогическогоКонтроляКоличество = 0;
	Если Элементы.ОшибкиЛогическогоКонтроляГруппа.Видимость Тогда
		Если ЗначениеЗаполнено(Объект.ОшибкиЛогическогоКонтроля) Или Не ТолькоПросмотр Тогда
			ОшибкиЛогическогоКонтроляКоличество = СтрЧислоСтрок(Объект.ОшибкиЛогическогоКонтроля);
			Элементы.ОшибкиЛогическогоКонтроля.Видимость = Истина;
			Элементы.ОшибкиЛогическогоКонтроля.Высота = Мин(Макс(ОшибкиЛогическогоКонтроляКоличество, 2), 4);
		Иначе
			Элементы.ОшибкиЛогическогоКонтроля.Видимость = Ложь;
		КонецЕсли;
	КонецЕсли;
	РегистрацияПротоколКоличество = 0;
	Если Элементы.РезультатРегистрацииГруппа.Видимость Тогда
		Если ЗначениеЗаполнено(Объект.РегистрацияПротокол) Или Не ТолькоПросмотр Тогда
			РегистрацияПротоколКоличество = СтрЧислоСтрок(Объект.РегистрацияПротокол);
			Элементы.РегистрацияПротокол.Видимость = Истина;
			Элементы.РегистрацияПротокол.Высота = Мин(Макс(РегистрацияПротоколКоличество, 2), 4);
		Иначе
			Элементы.РегистрацияПротокол.Видимость = Ложь;
		КонецЕсли;
	КонецЕсли;
	НесоответствиеПротоколКоличество = 0;
	Если Элементы.ГруппаНесоответствие.Видимость Тогда
		Если ЗначениеЗаполнено(Объект.НесоответствиеПротокол) Или Не ТолькоПросмотр Тогда
			НесоответствиеПротоколКоличество = СтрЧислоСтрок(Объект.НесоответствиеПротокол);
			Элементы.НесоответствиеПротокол.Видимость = Истина;
			Элементы.НесоответствиеПротокол.Высота = Мин(Макс(НесоответствиеПротоколКоличество, 2), 4);
		Иначе
			Элементы.НесоответствиеПротокол.Видимость = Ложь;
			Элементы.НесоответствиеПротокол.Высота = 0;
		КонецЕсли;
	КонецЕсли;
	
	Если РежимОткрытияОкна = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца Тогда
		Элементы.КнопкаЗакрытьВШапке.Видимость = Ложь;
		Элементы.КоманднаяПанельПодвал.Видимость = Истина;
		КнопкаЗакрыть = Элементы.КнопкаЗакрытьВПодвале;
		ОбратныйИндекс = КоманднаяПанель.ПодчиненныеЭлементы.Количество();
		ПредыдущийЭлемент = Неопределено;
		Пока ОбратныйИндекс > 0 Цикл
			ОбратныйИндекс = ОбратныйИндекс - 1;
			Элемент = КоманднаяПанель.ПодчиненныеЭлементы[ОбратныйИндекс];
			Элементы.Переместить(Элемент, Элементы.КоманднаяПанельПослеНадписи, ПредыдущийЭлемент);
			ПредыдущийЭлемент = Элемент;
		КонецЦикла;
	Иначе
		Элементы.КнопкаЗакрытьВШапке.Видимость = Истина;
		Элементы.КоманднаяПанельПодвал.Видимость = Ложь;
		КнопкаЗакрыть = Элементы.КнопкаЗакрытьВШапке;
	КонецЕсли;
	
	Если Объект.Состояние = Перечисления.СостоянияДокументаСЭДОФСС.Отправлен
		Или Объект.Состояние = Перечисления.СостоянияДокументаСЭДОФСС.ОтправленОператору Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы,
			"ПроверитьНаличиеОтвета",
			"КнопкаПоУмолчанию",
			Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы,
			"ПроверитьНаличиеОтвета",
			"ТолькоВоВсехДействиях",
			Ложь);
	Иначе
		КнопкаЗакрыть.КнопкаПоУмолчанию = Истина;
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы,
			"ПроверитьНаличиеОтвета",
			"ТолькоВоВсехДействиях",
			Истина);
	КонецЕсли;
	
	КлючСохраненияПоложенияОкна = 
		?(Объект.Состояние.Пустая(), "", ОбщегоНазначения.ИмяЗначенияПеречисления(Объект.Состояние))
		+ ?(ТолькоПросмотр, "1", "0")
		+ ?(Объект.Зарегистрирован, Формат(РегистрацияПротоколКоличество, "ЧН=; ЧГ="), "-")
		+ ?(Объект.ЕстьНесоответствия, Формат(НесоответствиеПротоколКоличество, "ЧН=; ЧГ="), "-")
		+ ?(Объект.ЕстьОшибкиЛогическогоКонтроля, Формат(ОшибкиЛогическогоКонтроляКоличество, "ЧН=; ЧГ="), "-")
		+ ?(Элементы.РезультатОтправкиГруппа.Видимость, Формат(ДоставкаТекстОшибкиКоличество, "ЧН=; ЧГ="), "-")
		+ ?(ЗначениеЗаполнено(Объект.Ответственный), "1", "0")
		+ ?(Элементы.КоманднаяПанельПодвал.Видимость, "1", "0");
	
КонецПроцедуры

#КонецОбласти
