
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СтруктураДанных = Параметры.СтруктураДанных;
	
	Если СтруктураДанных.Свойство("ТолькоПросмотрФормы") И СтруктураДанных.ТолькоПросмотрФормы Тогда
		Элементы.ДоверительЮЛ_РоссийскаяОрганизация.ТолькоПросмотр 	= Истина;
		Элементы.ДоверительЮЛ_НаимОрг.ТолькоПросмотр 				= Истина;
		Элементы.ДоверительЮЛ_ИНН.ТолькоПросмотр 					= Истина;
		Элементы.ДоверительЮЛ_КПП.ТолькоПросмотр 					= Истина;
		Элементы.ДоверительЮЛ_ОГРН.ТолькоПросмотр 					= Истина;
		Элементы.ДоверительЮЛ_СтрРег.ТолькоПросмотр 				= Истина;
		Элементы.ДоверительЮЛ_Адр.ТолькоПросмотр 					= Истина;
		Элементы.ДоверительЮЛ_НаимРегОрг.ТолькоПросмотр 			= Истина;
		Элементы.ДоверительЮЛ_РегНомер.ТолькоПросмотр 				= Истина;
		Элементы.ДоверительФЛ_Удостоверение.ТолькоПросмотр 			= Истина;
		Элементы.ДоверительФЛ_ИНН.ТолькоПросмотр 					= Истина;
		Элементы.ДоверительФЛ_Гражданство.ТолькоПросмотр 			= Истина;
		Элементы.ДоверительФЛ_ДатаРождения.ТолькоПросмотр 			= Истина;
		Элементы.ДоверительФЛ_Пол.ТолькоПросмотр 					= Истина;
		Элементы.ДоверительФЛ_МестоРожд.ТолькоПросмотр 				= Истина;
		Элементы.ДоверительФЛ_ОГРН.ТолькоПросмотр 					= Истина;
		Элементы.ДоверительФЛ_СНИЛС.ТолькоПросмотр 					= Истина;
		Элементы.ФормаКнопкаСохранить.Доступность 					= Ложь;
	КонецЕсли;
	
	Доверитель_ЮридическоеЛицо = (СтруктураДанных = Неопределено ИЛИ СтруктураДанных.Доверитель_ЮридическоеЛицо);
	ДоверительЮЛ_РоссийскаяОрганизация = (СтруктураДанных = Неопределено
		ИЛИ СтруктураДанных.ДоверительЮЛ_РоссийскаяОрганизация);
	
	Если СтруктураДанных <> Неопределено Тогда
		ДоверительЮЛ_НаимОрг 				= СтруктураДанных.ДоверительЮЛ_НаимОрг;
		ДоверительЮЛ_ИНН 					= СтруктураДанных.ДоверительЮЛ_ИНН;
		ДоверительЮЛ_КПП 					= СтруктураДанных.ДоверительЮЛ_КПП;
		ДоверительЮЛ_ОГРН 					= СтруктураДанных.ДоверительЮЛ_ОГРН;
		ДоверительЮЛ_СтрРег 				= СтруктураДанных.ДоверительЮЛ_СтрРег;
		ДоверительЮЛ_НаимРегОрг 			= СтруктураДанных.ДоверительЮЛ_НаимРегОрг;
		ДоверительЮЛ_РегНомер 				= СтруктураДанных.ДоверительЮЛ_РегНомер;
		ДоверительЮЛ_Адр 					= СтруктураДанных.ДоверительЮЛ_Адр;
		ДоверительЮЛ_АдрXML 				= СтруктураДанных.ДоверительЮЛ_АдрXML;
		ДоверительФЛ_Фамилия 				= СтруктураДанных.ДоверительФЛ_Фамилия;
		ДоверительФЛ_Имя 					= СтруктураДанных.ДоверительФЛ_Имя;
		ДоверительФЛ_Отчество 				= СтруктураДанных.ДоверительФЛ_Отчество;
		ДоверительФЛ_ИНН 					= СтруктураДанных.ДоверительФЛ_ИНН;
		ДоверительФЛ_ОГРН 					= СтруктураДанных.ДоверительФЛ_ОГРН;
		ДоверительФЛ_СНИЛС 					= СтруктураДанных.ДоверительФЛ_СНИЛС;
		ДоверительФЛ_Гражданство 			= СтруктураДанных.ДоверительФЛ_Гражданство;
		ДоверительФЛ_Пол 					= СтруктураДанных.ДоверительФЛ_Пол;
		ДоверительФЛ_ДатаРождения 			= СтруктураДанных.ДоверительФЛ_ДатаРождения;
		ДоверительФЛ_МестоРожд 				= СтруктураДанных.ДоверительФЛ_МестоРожд;
	КонецЕсли;
	
	УправлениеЭУ(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДоверительЮЛ_ИностраннаяОрганизацияПриИзменении(Элемент)
	УправлениеЭУ(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ДоверительЮЛ_АдрНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ДоверительЮЛ_АдрНачалоВыбораЗавершение", ЭтотОбъект);
	ВидКИЮрАдресОрганизации = ПредопределенноеЗначение("Справочник.ВидыКонтактнойИнформации.ЮрАдресОрганизации");
	ПараметрыФормы = УправлениеКонтактнойИнформациейКлиент.ПараметрыФормыКонтактнойИнформации(
		ВидКИЮрАдресОрганизации, ДоверительЮЛ_АдрXML);
	
	УправлениеКонтактнойИнформациейКлиент.ОткрытьФормуКонтактнойИнформации(ПараметрыФормы, , ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ДоверительЮЛ_АдрОчистка(Элемент, СтандартнаяОбработка)
	
	ДоверительЮЛ_АдрXML = "";
	ДоверительЮЛ_Адр = "";
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ДоверительФЛ_УдостоверениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтруктураДанных = Новый Структура;
	СтруктураДанных.Вставить("ДокументВид", 				ДоверительФЛ_ВидДок);
	СтруктураДанных.Вставить("ДокументСерия", 				ДоверительФЛ_СерДок);
	СтруктураДанных.Вставить("ДокументНомер", 				ДоверительФЛ_НомДок);
	СтруктураДанных.Вставить("ДокументДатаВыдачи", 			ДоверительФЛ_ДатаДок);
	СтруктураДанных.Вставить("ДокументКемВыдан", 			ДоверительФЛ_ВыдДок);
	СтруктураДанных.Вставить("ДокументКодПодразделения", 	ДоверительФЛ_КодВыдДок);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ДоверительФЛ_УдостоверениеНачалоВыбораЗавершение", ЭтотОбъект);
	СтруктураПараметров = Новый Структура("СтруктураДанных", СтруктураДанных);
	ОткрытьФорму("Справочник.МашиночитаемыеДоверенностиОрганизаций.Форма.ФормаВводаУдостоверения",
		СтруктураПараметров, ЭтотОбъект, , , , ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ДоверительФЛ_УдостоверениеОчистка(Элемент, СтандартнаяОбработка)
	
	ДоверительФЛ_ВидДок 	= "";
	ДоверительФЛ_СерДок 	= "";
	ДоверительФЛ_НомДок 	= "";
	ДоверительФЛ_ДатаДок 	= Неопределено;
	ДоверительФЛ_ВыдДок 	= "";
	ДоверительФЛ_КодВыдДок 	= "";
	
	ДоверительФЛ_Удостоверение = "";
	
	Модифицированность = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Сохранить(Команда)
	
	Если НЕ СохранениеВозможно() Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураДанных = Новый Структура;
	СтруктураДанных.Вставить("ДоверительЮЛ_РоссийскаяОрганизация", 	ДоверительЮЛ_РоссийскаяОрганизация);
	СтруктураДанных.Вставить("ДоверительЮЛ_НаимОрг", 				ДоверительЮЛ_НаимОрг);
	СтруктураДанных.Вставить("ДоверительЮЛ_ИНН", 					ДоверительЮЛ_ИНН);
	СтруктураДанных.Вставить("ДоверительЮЛ_КПП", 					ДоверительЮЛ_КПП);
	СтруктураДанных.Вставить("ДоверительЮЛ_ОГРН", 					ДоверительЮЛ_ОГРН);
	СтруктураДанных.Вставить("ДоверительЮЛ_СтрРег", 				ДоверительЮЛ_СтрРег);
	СтруктураДанных.Вставить("ДоверительЮЛ_НаимРегОрг", 			ДоверительЮЛ_НаимРегОрг);
	СтруктураДанных.Вставить("ДоверительЮЛ_РегНомер", 				ДоверительЮЛ_РегНомер);
	СтруктураДанных.Вставить("ДоверительЮЛ_Адр", 					ДоверительЮЛ_Адр);
	СтруктураДанных.Вставить("ДоверительЮЛ_АдрXML", 				ДоверительЮЛ_АдрXML);
	СтруктураДанных.Вставить("ДоверительФЛ_Фамилия", 				ДоверительФЛ_Фамилия);
	СтруктураДанных.Вставить("ДоверительФЛ_Имя", 					ДоверительФЛ_Имя);
	СтруктураДанных.Вставить("ДоверительФЛ_Отчество", 				ДоверительФЛ_Отчество);
	СтруктураДанных.Вставить("ДоверительФЛ_ВидДок", 				ДоверительФЛ_ВидДок);
	СтруктураДанных.Вставить("ДоверительФЛ_СерДок", 				ДоверительФЛ_СерДок);
	СтруктураДанных.Вставить("ДоверительФЛ_НомДок", 				ДоверительФЛ_НомДок);
	СтруктураДанных.Вставить("ДоверительФЛ_ДатаДок", 				ДоверительФЛ_ДатаДок);
	СтруктураДанных.Вставить("ДоверительФЛ_ВыдДок", 				ДоверительФЛ_ВыдДок);
	СтруктураДанных.Вставить("ДоверительФЛ_КодВыдДок", 				ДоверительФЛ_КодВыдДок);
	СтруктураДанных.Вставить("ДоверительФЛ_ИНН", 					ДоверительФЛ_ИНН);
	СтруктураДанных.Вставить("ДоверительФЛ_ОГРН", 					ДоверительФЛ_ОГРН);
	СтруктураДанных.Вставить("ДоверительФЛ_СНИЛС", 					ДоверительФЛ_СНИЛС);
	СтруктураДанных.Вставить("ДоверительФЛ_Гражданство", 			ДоверительФЛ_Гражданство);
	СтруктураДанных.Вставить("ДоверительФЛ_Пол", 					ДоверительФЛ_Пол);
	СтруктураДанных.Вставить("ДоверительФЛ_ДатаРождения", 			ДоверительФЛ_ДатаРождения);
	СтруктураДанных.Вставить("ДоверительФЛ_МестоРожд", 				ДоверительФЛ_МестоРожд);
	
	Закрыть(СтруктураДанных);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеЭУ(Форма)
	
	Форма.Элементы.ГруппаЛевая.Видимость = Форма.Доверитель_ЮридическоеЛицо;
	Форма.Элементы.ГруппаПравая.Видимость = НЕ Форма.Доверитель_ЮридическоеЛицо
		ИЛИ НЕ Форма.ДоверительЮЛ_РоссийскаяОрганизация;
	Форма.Элементы.ГруппаПравая.Заголовок = ?(Форма.Доверитель_ЮридическоеЛицо
		И НЕ Форма.ДоверительЮЛ_РоссийскаяОрганизация,
		НСтр("ru = 'Руководитель обособленного подразделения';
			|en = 'Branch office manager'"), НСтр("ru = 'Индивидуальный предприниматель';
																		|en = 'Individual entrepreneur'"));
	
	Форма.Элементы.ДоверительЮЛ_НаимОрг.ПоложениеЗаголовка = ?(Форма.Доверитель_ЮридическоеЛицо
		И НЕ Форма.ДоверительЮЛ_РоссийскаяОрганизация,
		ПоложениеЗаголовкаЭлементаФормы.Верх, ПоложениеЗаголовкаЭлементаФормы.Авто);
	Форма.Элементы.ДоверительЮЛ_Адр.ПоложениеЗаголовка = ?(Форма.Доверитель_ЮридическоеЛицо
		И НЕ Форма.ДоверительЮЛ_РоссийскаяОрганизация,
		ПоложениеЗаголовкаЭлементаФормы.Верх, ПоложениеЗаголовкаЭлементаФормы.Авто);
	Форма.Элементы.ДоверительЮЛ_СтрРег.Видимость = НЕ Форма.ДоверительЮЛ_РоссийскаяОрганизация;
	Форма.Элементы.ДоверительЮЛ_НаимРегОрг.Видимость = НЕ Форма.ДоверительЮЛ_РоссийскаяОрганизация;
	Форма.Элементы.ДоверительЮЛ_РегНомер.Видимость = НЕ Форма.ДоверительЮЛ_РоссийскаяОрганизация;
	
	Форма.Элементы.ДоверительФЛ_Удостоверение.ПоложениеЗаголовка = ?(Форма.Доверитель_ЮридическоеЛицо,
		ПоложениеЗаголовкаЭлементаФормы.Верх, ПоложениеЗаголовкаЭлементаФормы.Авто);
	Форма.Элементы.ДоверительФЛ_СНИЛС.Видимость = НЕ Форма.Доверитель_ЮридическоеЛицо;
	Форма.Элементы.ДоверительФЛ_ОГРН.Видимость = НЕ Форма.Доверитель_ЮридическоеЛицо;
	Форма.Элементы.ДоверительФЛ_Удостоверение.Видимость = НЕ Форма.Доверитель_ЮридическоеЛицо;
	Форма.Элементы.ДоверительФЛ_Пол.Видимость = Форма.Доверитель_ЮридическоеЛицо
		И НЕ Форма.ДоверительЮЛ_РоссийскаяОрганизация;
	Форма.Элементы.ДоверительФЛ_ДатаРождения.АвтоОтметкаНезаполненного = Форма.Доверитель_ЮридическоеЛицо
		И НЕ Форма.ДоверительЮЛ_РоссийскаяОрганизация;
	Форма.Элементы.ДоверительФЛ_ДатаРождения.АвтоВыборНезаполненного = Форма.Доверитель_ЮридическоеЛицо
		И НЕ Форма.ДоверительЮЛ_РоссийскаяОрганизация;
	
КонецПроцедуры

&НаКлиенте
Функция СохранениеВозможно()
	
	Отказ = Ложь;
	
	ОчиститьСообщения();
	
	Если Доверитель_ЮридическоеЛицо И НЕ ЗначениеЗаполнено(ДоверительЮЛ_НаимОрг) Тогда
		ТекстСообщения = НСтр("ru = 'Не задано наименование организации.';
								|en = 'Company name is not specified.'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения, , "ДоверительЮЛ_НаимОрг", , Отказ);
	КонецЕсли;
	
	Возврат НЕ Отказ;
	
КонецФункции

&НаКлиенте
Процедура ДоверительЮЛ_АдрНачалоВыбораЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ДоверительЮЛ_АдрXML = Результат.КонтактнаяИнформация;
	ДоверительЮЛ_Адр = ПредставлениеКонтактнойИнформации(Результат.КонтактнаяИнформация);
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ДоверительФЛ_УдостоверениеНачалоВыбораЗавершение(РезультатВыбора, ДополнительныеПараметры) Экспорт
	
	Если НЕ ЗначениеЗаполнено(РезультатВыбора) Тогда
		Возврат;
	КонецЕсли;
	
	ДоверительФЛ_ВидДок 	= РезультатВыбора.ДокументВид;
	ДоверительФЛ_СерДок 	= РезультатВыбора.ДокументСерия;
	ДоверительФЛ_НомДок 	= РезультатВыбора.ДокументНомер;
	ДоверительФЛ_ДатаДок 	= РезультатВыбора.ДокументДатаВыдачи;
	ДоверительФЛ_ВыдДок 	= РезультатВыбора.ДокументКемВыдан;
	ДоверительФЛ_КодВыдДок 	= РезультатВыбора.ДокументКодПодразделения;
	
	ДоверительФЛ_Удостоверение = ПолучитьПредставлениеУдостоверение(РезультатВыбора);
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Функция ДобавитьРеквизит(Текст, ДобСтрока, Префикс)
	
	Если ЗначениеЗаполнено(ДобСтрока) Тогда
		Текст = Текст + Префикс + ДобСтрока;
	КонецЕсли;
	
	Возврат Текст;
	
КонецФункции

&НаКлиенте
Функция ПолучитьПредставлениеУдостоверение(СтрокаУдостоверения)
	
	Удостоверение = "";
	ВариантЗаполнения =
	(ТипЗнч(СтрокаУдостоверения) = Тип("Структура")
		ИЛИ ТипЗнч(СтрокаУдостоверения) = Тип("ФиксированнаяСтруктура"))
		И СтрокаУдостоверения.Свойство("ДокументВид")
		И СтрокаУдостоверения.Свойство("ДокументСерия")
		И СтрокаУдостоверения.Свойство("ДокументНомер")
		И СтрокаУдостоверения.Свойство("ДокументДатаВыдачи")
		И СтрокаУдостоверения.Свойство("ДокументКемВыдан")
		И СтрокаУдостоверения.Свойство("ДокументКодПодразделения");
		
	Если ВариантЗаполнения Тогда
		
		ВидДок = СтрокаУдостоверения.ДокументВид;
		СерДок = СтрокаУдостоверения.ДокументСерия;
		НомДок = СтрокаУдостоверения.ДокументНомер;
		ДатаДок = СтрокаУдостоверения.ДокументДатаВыдачи;
		ВыдДок = СтрокаУдостоверения.ДокументКемВыдан;
		КодВыдДок = СтрокаУдостоверения.ДокументКодПодразделения;
		
	Иначе
		
		ВидДок = СтрокаУдостоверения.ВидДок;
		СерДок = СтрокаУдостоверения.СерДок;
		НомДок = СтрокаУдостоверения.НомДок;
		ДатаДок = СтрокаУдостоверения.ДатаДок;
		ВыдДок = СтрокаУдостоверения.ВыдДок;
		КодВыдДок = СтрокаУдостоверения.КодВыдДок;
		
	КонецЕсли;
	
	ДобавитьРеквизит(Удостоверение, ВидДок, 					"");
	ДобавитьРеквизит(Удостоверение, СерДок, 					" ");
	ДобавитьРеквизит(Удостоверение, НомДок, 					" " + НСтр("ru = '№';
																			|en = 'No.'"));
	ДобавитьРеквизит(Удостоверение, Формат(ДатаДок, "ДЛФ=ДД"), 	" " + НСтр("ru = 'выдан';
																				|en = 'issued'") + " ");
	ДобавитьРеквизит(Удостоверение, ВыдДок, 					" ");
	ДобавитьРеквизит(Удостоверение, КодВыдДок, 					", " + НСтр("ru = 'код подразделения';
																				|en = 'department code'") + ":");
	
	Возврат Удостоверение;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПредставлениеКонтактнойИнформации(КонтактнаяИнформация)
	
	Возврат УправлениеКонтактнойИнформацией.ПредставлениеКонтактнойИнформации(КонтактнаяИнформация);
	
КонецФункции

#КонецОбласти
