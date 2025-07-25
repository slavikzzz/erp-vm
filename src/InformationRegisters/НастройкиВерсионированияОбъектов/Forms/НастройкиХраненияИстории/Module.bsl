///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьТипыОбъектовВДеревеЗначений();
	ЗаполнитьСпискиВыбора();
	
	Элементы.Очистить.Видимость = Ложь;
	Элементы.Расписание.Заголовок = ТекущееРасписание();
	
	Если Не ОбщегоНазначения.РазделениеВключено() Тогда
		АвтоматическиУдалятьУстаревшиеВерсии = АвтоматическаяОчисткаВключена();
		Элементы.Расписание.Доступность = АвтоматическиУдалятьУстаревшиеВерсии;
		Элементы.НастроитьРасписание.Доступность = АвтоматическиУдалятьУстаревшиеВерсии;
	КонецЕсли;
	
	Элементы.УдалениеВерсийПоРасписанию.Видимость = Не ОбщегоНазначения.РазделениеВключено();
	Элементы.ИнформацияОбУстаревшихВерсиях.Заголовок = ТекстСостоянияПодсчет();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ОбновитьИнформациюОбУстаревшихВерсиях();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДеревоОбъектовМетаданных

&НаКлиенте
Процедура ДеревоОбъектовМетаданныхПередНачаломИзменения(Элемент, Отказ)
	
	Если Элемент.ТекущиеДанные.ПолучитьРодителя() = Неопределено Тогда
		Отказ = Истина;
	КонецЕсли;
	
	Если Элемент.ТекущийЭлемент = Элементы.ВариантВерсионирования Тогда
		ЗаполнитьСписокВыбора(Элементы.ДеревоОбъектовМетаданных.ТекущийЭлемент);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкаПриИзменении(Элемент)
	ТекущиеДанные = Элементы.ДеревоОбъектовМетаданных.ТекущиеДанные;
	ЗаписатьТекущиеНастройкиПоОбъекту(ТекущиеДанные.ТипОбъекта, ТекущиеДанные.ВариантВерсионирования, ТекущиеДанные.СрокХраненияВерсий);
	ОбновитьИнформациюОбУстаревшихВерсиях();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура УстановитьВариантВерсионированияНеВерсионировать(Команда)
	
	УстановитьВариантВерсионированияДляВыделенныхСтрок(
		ПредопределенноеЗначение("Перечисление.ВариантыВерсионированияОбъектов.НеВерсионировать"));	
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьРежимВерсионированияПриЗаписи(Команда)
	
	УстановитьВариантВерсионированияДляВыделенныхСтрок(
		ПредопределенноеЗначение("Перечисление.ВариантыВерсионированияОбъектов.ВерсионироватьПриЗаписи"));	
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьВариантВерсионированияПриПроведении(Команда)
	
	Если ВыбранТипДокументовБезВозможностиПроведения() Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Документам, которые не могут быть проведены, установлен режим версионирования ""Версионировать при записи"".';
										|en = 'Documents that cannot be posted are applied with the ""on write"" versioning mode.'"));
	КонецЕсли;
	
	УстановитьВариантВерсионированияДляВыделенныхСтрок(
		ПредопределенноеЗначение("Перечисление.ВариантыВерсионированияОбъектов.ВерсионироватьПриПроведении"));	
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьНастройкиПоУмолчанию(Команда)
	
	УстановитьВариантВерсионированияДляВыделенныхСтрок(Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура Обновить(Команда)
	ЗаполнитьТипыОбъектовВДеревеЗначений();
	ОбновитьИнформациюОбУстаревшихВерсиях();
	Для Каждого Элемент Из ДеревоОбъектовМетаданных.ПолучитьЭлементы() Цикл
		Элементы.ДеревоОбъектовМетаданных.Развернуть(Элемент.ПолучитьИдентификатор(), Истина);
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура Очистить(Команда)
	ПрерватьФоновоеЗадание();
	ЗапуститьРегламентноеЗадание();
	НачатьОбновлениеИнформацииОбУстаревшихВерсиях();
	ПодключитьОбработчикОжидания("ПроверитьВыполнениеФоновогоЗадания", 2, Истина);
КонецПроцедуры

&НаКлиенте
Процедура ЗаПоследнююНеделю(Команда)
	УстановитьСрокХраненияВерсийДляВыбранныхОбъектов(
		ПредопределенноеЗначение("Перечисление.СрокиХраненияВерсий.ЗаПоследнююНеделю"));
	ОбновитьИнформациюОбУстаревшихВерсиях();
КонецПроцедуры

&НаКлиенте
Процедура ЗаПоследнийМесяц(Команда)
	УстановитьСрокХраненияВерсийДляВыбранныхОбъектов(
		ПредопределенноеЗначение("Перечисление.СрокиХраненияВерсий.ЗаПоследнийМесяц"));
	ОбновитьИнформациюОбУстаревшихВерсиях();
КонецПроцедуры

&НаКлиенте
Процедура ЗаПоследниеТриМесяца(Команда)
	УстановитьСрокХраненияВерсийДляВыбранныхОбъектов(
		ПредопределенноеЗначение("Перечисление.СрокиХраненияВерсий.ЗаПоследниеТриМесяца"));
	ОбновитьИнформациюОбУстаревшихВерсиях();
КонецПроцедуры

&НаКлиенте
Процедура ЗаПоследниеШестьМесяцев(Команда)
	УстановитьСрокХраненияВерсийДляВыбранныхОбъектов(
		ПредопределенноеЗначение("Перечисление.СрокиХраненияВерсий.ЗаПоследниеШестьМесяцев"));
	ОбновитьИнформациюОбУстаревшихВерсиях();
КонецПроцедуры

&НаКлиенте
Процедура ЗаПоследнийГод(Команда)
	УстановитьСрокХраненияВерсийДляВыбранныхОбъектов(
		ПредопределенноеЗначение("Перечисление.СрокиХраненияВерсий.ЗаПоследнийГод"));
	ОбновитьИнформациюОбУстаревшихВерсиях();
КонецПроцедуры

&НаКлиенте
Процедура Бессрочно(Команда)
	УстановитьСрокХраненияВерсийДляВыбранныхОбъектов(
		ПредопределенноеЗначение("Перечисление.СрокиХраненияВерсий.Бессрочно"));
	ОбновитьИнформациюОбУстаревшихВерсиях();
КонецПроцедуры

&НаКлиенте
Процедура ВерсионироватьПриСтарте(Команда)
	УстановитьВариантВерсионированияДляВыделенныхСтрок(
		ПредопределенноеЗначение("Перечисление.ВариантыВерсионированияОбъектов.ВерсионироватьПриСтарте"));
КонецПроцедуры

&НаКлиенте
Процедура НастроитьРасписание(Команда)
	ДиалогРасписания = Новый ДиалогРасписанияРегламентногоЗадания(ТекущееРасписание());
	ОписаниеОповещения = Новый ОписаниеОповещения("НастроитьРасписаниеЗавершение", ЭтотОбъект);
	ДиалогРасписания.Показать(ОписаниеОповещения);
КонецПроцедуры

&НаКлиенте
Процедура КоличествоИОбъемХранимыхВерсийОбъектов(Команда)
	ОткрытьФорму("Отчет.АнализВерсийОбъектов.ФормаОбъекта");
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ЗаполнитьСписокВыбора(Элемент)
	
	СтрокаДерева = Элементы.ДеревоОбъектовМетаданных.ТекущиеДанные;
	
	Элемент.СписокВыбора.Очистить();
	
	Если СтрокаДерева.КлассОбъекта = "КлассДокументы" И СтрокаДерева.Проводится Тогда
		СписокВыбора = СписокВыбораДокументы;
	ИначеЕсли СтрокаДерева.КлассОбъекта = "КлассБизнесПроцессы" Тогда
		СписокВыбора = СписокВыбораБизнесПроцессы;
	Иначе
		СписокВыбора = СписокВыбораСправочники;
	КонецЕсли;
	
	Для Каждого ЭлементСписка Из СписокВыбора Цикл
		Элемент.СписокВыбора.Добавить(ЭлементСписка.Значение);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТипыОбъектовВДеревеЗначений()
	
	НастройкиВерсионирования = ТекущиеНастройкиВерсионирования();
	
	ДеревоОМ = РеквизитФормыВЗначение("ДеревоОбъектовМетаданных");
	ДеревоОМ.Строки.Очистить();
	
	// Тип параметра команды ИсторияИзменений содержит состав объектов для которых 
	// применяется версионирование.
	МассивТипов = Метаданные.ОбщиеКоманды.ИсторияИзменений.ТипПараметраКоманды.Типы();
	ЕстьБизнесПроцессы = Ложь;
	ВсеСправочники = Справочники.ТипВсеСсылки();
	ВсеДокументы = Документы.ТипВсеСсылки();
	УзелСправочники = Неопределено;
	УзелДокументы = Неопределено;
	УзелБизнесПроцессы = Неопределено;
	
	Для Каждого Тип Из МассивТипов Цикл
		Если Тип = Тип("СправочникСсылка.ИдентификаторыОбъектовМетаданных") Тогда
			Продолжить;
		КонецЕсли;
		Если ВсеСправочники.СодержитТип(Тип) Тогда
			Если УзелСправочники = НеОпределено Тогда
				УзелСправочники = ДеревоОМ.Строки.Добавить();
				УзелСправочники.СинонимНаименованияОбъекта = НСтр("ru = 'Справочники';
																	|en = 'Catalogs'");
				УзелСправочники.КлассОбъекта = "01КлассСправочникиКорень";
				УзелСправочники.КодКартинки = 2;
			КонецЕсли;
			НоваяСтрокаТаблицы = УзелСправочники.Строки.Добавить();
			НоваяСтрокаТаблицы.КодКартинки = 19;
			НоваяСтрокаТаблицы.КлассОбъекта = "КлассСправочники";
		ИначеЕсли ВсеДокументы.СодержитТип(Тип) Тогда
			Если УзелДокументы = НеОпределено Тогда
				УзелДокументы = ДеревоОМ.Строки.Добавить();
				УзелДокументы.СинонимНаименованияОбъекта = НСтр("ru = 'Документы';
																|en = 'Documents'");
				УзелДокументы.КлассОбъекта = "02КлассДокументыКорень";
				УзелДокументы.КодКартинки = 3;
			КонецЕсли;
			НоваяСтрокаТаблицы = УзелДокументы.Строки.Добавить();
			НоваяСтрокаТаблицы.КодКартинки = 20;
			НоваяСтрокаТаблицы.КлассОбъекта = "КлассДокументы";
		ИначеЕсли БизнесПроцессы.ТипВсеСсылки().СодержитТип(Тип) Тогда
			Если УзелБизнесПроцессы = Неопределено Тогда
				УзелБизнесПроцессы = ДеревоОМ.Строки.Добавить();
				УзелБизнесПроцессы.СинонимНаименованияОбъекта = НСтр("ru = 'Бизнес-процессы';
																	|en = 'Business processes'");
				УзелБизнесПроцессы.КлассОбъекта = "03БизнесПроцессыКорень";
				УзелБизнесПроцессы.ТипОбъекта = "БизнесПроцессы";
			КонецЕсли;
			НоваяСтрокаТаблицы = УзелБизнесПроцессы.Строки.Добавить();
			НоваяСтрокаТаблицы.КлассОбъекта = "КлассБизнесПроцессы";
			ЕстьБизнесПроцессы = Истина;
		ИначеЕсли ПланыСчетов.ТипВсеСсылки().СодержитТип(Тип) Тогда
			ИмяГруппы = "04ПланыСчетовКорень";
			ПредставлениеГруппы = НСтр("ru = 'Планы счетов';
										|en = 'Charts of accounts'");
			ТипОбъектовГруппы = "ПланыСчетов";
			Группа = ДеревоОМ.Строки.Найти(ИмяГруппы, "КлассОбъекта");
			Если Группа = Неопределено Тогда
				Группа = ДеревоОМ.Строки.Добавить();
				Группа.СинонимНаименованияОбъекта = ПредставлениеГруппы;
				Группа.КлассОбъекта = ИмяГруппы;
				Группа.ТипОбъекта = ТипОбъектовГруппы;
			КонецЕсли;
			НоваяСтрокаТаблицы = Группа.Строки.Добавить();
			НоваяСтрокаТаблицы.КлассОбъекта = "КлассПланыСчетов";
		ИначеЕсли ПланыВидовХарактеристик.ТипВсеСсылки().СодержитТип(Тип) Тогда
			ИмяГруппы = "05ПланыВидовХарактеристикКорень";
			ПредставлениеГруппы = НСтр("ru = 'Планы видов характеристик';
										|en = 'Charts of characteristic types'");
			ТипОбъектовГруппы = "ПланыВидовХарактеристик";
			Группа = ДеревоОМ.Строки.Найти(ИмяГруппы, "КлассОбъекта");
			Если Группа = Неопределено Тогда
				Группа = ДеревоОМ.Строки.Добавить();
				Группа.СинонимНаименованияОбъекта = ПредставлениеГруппы;
				Группа.КлассОбъекта = ИмяГруппы;
				Группа.ТипОбъекта = ТипОбъектовГруппы;
			КонецЕсли;
			НоваяСтрокаТаблицы = Группа.Строки.Добавить();
			НоваяСтрокаТаблицы.КлассОбъекта = "КлассПланыВидовХарактеристик";
		ИначеЕсли ПланыВидовРасчета.ТипВсеСсылки().СодержитТип(Тип) Тогда
			ИмяГруппы = "06ПланыВидовРасчетаКорень";
			ПредставлениеГруппы = НСтр("ru = 'Планы видов расчета';
										|en = 'Charts of calculation types'");
			ТипОбъектовГруппы = "ПланыВидовРасчета";
			Группа = ДеревоОМ.Строки.Найти(ИмяГруппы, "КлассОбъекта");
			Если Группа = Неопределено Тогда
				Группа = ДеревоОМ.Строки.Добавить();
				Группа.СинонимНаименованияОбъекта = ПредставлениеГруппы;
				Группа.КлассОбъекта = ИмяГруппы;
				Группа.ТипОбъекта = ТипОбъектовГруппы;
			КонецЕсли;
			НоваяСтрокаТаблицы = Группа.Строки.Добавить();
			НоваяСтрокаТаблицы.КлассОбъекта = "КлассПланыВидовРасчета";
		КонецЕсли;
		МетаданныеОбъекта = Метаданные.НайтиПоТипу(Тип);
		НоваяСтрокаТаблицы.ТипОбъекта = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(Тип);
		НоваяСтрокаТаблицы.СинонимНаименованияОбъекта = МетаданныеОбъекта.Синоним;
		
		НайденныеНастройки = НастройкиВерсионирования.НайтиСтроки(Новый Структура("ТипОбъекта", НоваяСтрокаТаблицы.ТипОбъекта));
		Если НайденныеНастройки.Количество() > 0 Тогда
			НоваяСтрокаТаблицы.ВариантВерсионирования = НайденныеНастройки[0].ВариантВерсионирования;
			НоваяСтрокаТаблицы.СрокХраненияВерсий = НайденныеНастройки[0].СрокХраненияВерсий;
			Если Не ЗначениеЗаполнено(НайденныеНастройки[0].СрокХраненияВерсий) Тогда
				НоваяСтрокаТаблицы.СрокХраненияВерсий = Перечисления.СрокиХраненияВерсий.Бессрочно;
			КонецЕсли;
		Иначе
			НоваяСтрокаТаблицы.ВариантВерсионирования = Перечисления.ВариантыВерсионированияОбъектов.НеВерсионировать;
			НоваяСтрокаТаблицы.СрокХраненияВерсий = Перечисления.СрокиХраненияВерсий.Бессрочно;
		КонецЕсли;
		
		Если НоваяСтрокаТаблицы.КлассОбъекта = "КлассДокументы" Тогда
			НоваяСтрокаТаблицы.Проводится = ? (МетаданныеОбъекта.Проведение = Метаданные.СвойстваОбъектов.Проведение.Разрешить, Истина, Ложь);
		КонецЕсли;
	КонецЦикла;
	ДеревоОМ.Строки.Сортировать("КлассОбъекта");
	Для Каждого УзелВерхнегоУровня Из ДеревоОМ.Строки Цикл
		УзелВерхнегоУровня.Строки.Сортировать("СинонимНаименованияОбъекта");
	КонецЦикла;
	ЗначениеВРеквизитФормы(ДеревоОМ, "ДеревоОбъектовМетаданных");
	
	Элементы.ФормаВерсионироватьПриСтарте.Видимость = ЕстьБизнесПроцессы;
КонецПроцедуры

&НаКлиенте
Функция ВыбранТипДокументовБезВозможностиПроведения()
	
	Для Каждого ИдентификаторСтроки Из Элементы.ДеревоОбъектовМетаданных.ВыделенныеСтроки Цикл
		ЭлементДерева = ДеревоОбъектовМетаданных.НайтиПоИдентификатору(ИдентификаторСтроки);
		Если ЭлементДерева.КлассОбъекта = "КлассДокументы" И Не ЭлементДерева.Проводится Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Ложь;
	
КонецФункции

&НаСервере
Процедура УстановитьВариантВерсионированияДляВыделенныхСтрок(Знач ВариантВерсионирования)
	
	Для Каждого ИдентификаторСтроки Из Элементы.ДеревоОбъектовМетаданных.ВыделенныеСтроки Цикл
		ЭлементДерева = ДеревоОбъектовМетаданных.НайтиПоИдентификатору(ИдентификаторСтроки);
		Если ЭлементДерева.ПолучитьРодителя() = Неопределено Тогда 
			Для Каждого ПодчиненныйЭлементДерева Из ЭлементДерева.ПолучитьЭлементы() Цикл
				УстановитьВариантВерсионированияДляЭлементаДерева(ПодчиненныйЭлементДерева, ВариантВерсионирования);
			КонецЦикла;
		Иначе
			УстановитьВариантВерсионированияДляЭлементаДерева(ЭлементДерева, ВариантВерсионирования);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВариантВерсионированияДляЭлементаДерева(ЭлементДерева, Знач ВариантВерсионирования)
	
	Если ВариантВерсионирования = Неопределено Тогда
		Если ЭлементДерева.КлассОбъекта = "КлассДокументы" Тогда
			ВариантВерсионирования = Перечисления.ВариантыВерсионированияОбъектов.ВерсионироватьПриПроведении;
		ИначеЕсли ЭлементДерева.ПолучитьРодителя().ТипОбъекта = "БизнесПроцессы" Тогда
			ВариантВерсионирования = Перечисления.ВариантыВерсионированияОбъектов.ВерсионироватьПриСтарте;
		Иначе
			ВариантВерсионирования = Перечисления.ВариантыВерсионированияОбъектов.НеВерсионировать;
		КонецЕсли;
	КонецЕсли;
	
	Если ВариантВерсионирования = Перечисления.ВариантыВерсионированияОбъектов.ВерсионироватьПриПроведении
		И Не ЭлементДерева.Проводится 
		Или ВариантВерсионирования = Перечисления.ВариантыВерсионированияОбъектов.ВерсионироватьПриСтарте
		И ЭлементДерева.КлассОбъекта <> "КлассБизнесПроцессы" Тогда
			ВариантВерсионирования = Перечисления.ВариантыВерсионированияОбъектов.ВерсионироватьПриЗаписи;
	КонецЕсли;
	
	ЭлементДерева.ВариантВерсионирования = ВариантВерсионирования;
	
	ЗаписатьТекущиеНастройкиПоОбъекту(ЭлементДерева.ТипОбъекта, ВариантВерсионирования, ЭлементДерева.СрокХраненияВерсий);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьСрокХраненияВерсийДляВыбранныхОбъектов(СрокХраненияВерсий)
	
	Для Каждого ИдентификаторСтроки Из Элементы.ДеревоОбъектовМетаданных.ВыделенныеСтроки Цикл
		ЭлементДерева = ДеревоОбъектовМетаданных.НайтиПоИдентификатору(ИдентификаторСтроки);
		Если ЭлементДерева.ПолучитьРодителя() = Неопределено Тогда
			Для Каждого ПодчиненныйЭлементДерева Из ЭлементДерева.ПолучитьЭлементы() Цикл
				УстановитьСрокХраненияВерсийДляВыбранногоОбъекта(ПодчиненныйЭлементДерева, СрокХраненияВерсий);
			КонецЦикла;
		Иначе
			УстановитьСрокХраненияВерсийДляВыбранногоОбъекта(ЭлементДерева, СрокХраненияВерсий);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьСрокХраненияВерсийДляВыбранногоОбъекта(ВыбранныйОбъект, СрокХраненияВерсий)
	
	ВыбранныйОбъект.СрокХраненияВерсий = СрокХраненияВерсий;
	ЗаписатьТекущиеНастройкиПоОбъекту(ВыбранныйОбъект.ТипОбъекта, ВыбранныйОбъект.ВариантВерсионирования, СрокХраненияВерсий);
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьТекущиеНастройкиПоОбъекту(ТипОбъекта, ВариантВерсионирования, СрокХраненияВерсий)
	ВерсионированиеОбъектов.ЗаписатьНастройкуВерсионированияПоОбъекту(ТипОбъекта, ВариантВерсионирования, СрокХраненияВерсий);
КонецПроцедуры

&НаСервере
Функция ТекущиеНастройкиВерсионирования()
	УстановитьПривилегированныйРежим(Истина);
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	НастройкиВерсионированияОбъектов.ТипОбъекта КАК ТипОбъекта,
	|	НастройкиВерсионированияОбъектов.Вариант КАК ВариантВерсионирования,
	|	НастройкиВерсионированияОбъектов.СрокХраненияВерсий КАК СрокХраненияВерсий
	|ИЗ
	|	РегистрСведений.НастройкиВерсионированияОбъектов КАК НастройкиВерсионированияОбъектов";
	Запрос = Новый Запрос(ТекстЗапроса);
	Возврат Запрос.Выполнить().Выгрузить();
КонецФункции

&НаКлиенте
Процедура НастроитьРасписаниеЗавершение(Расписание, ДополнительныеПараметры) Экспорт
	Если Расписание = Неопределено Тогда
		Возврат;
	КонецЕсли;
	УстановитьПараметрРегламентногоЗадания("Расписание", Расписание);
	Элементы.Расписание.Заголовок = Расписание;
КонецПроцедуры

&НаСервере
Функция ТекущееРасписание()
	Возврат ПолучитьПараметрРегламентногоЗадания("Расписание", Новый РасписаниеРегламентногоЗадания);
КонецФункции

&НаКлиенте
Процедура АвтоматическиУдалятьУстаревшиеВерсииПриИзменении(Элемент)
	УстановитьПараметрРегламентногоЗадания("Использование", АвтоматическиУдалятьУстаревшиеВерсии);
	Элементы.Расписание.Доступность = АвтоматическиУдалятьУстаревшиеВерсии;
	Элементы.НастроитьРасписание.Доступность = АвтоматическиУдалятьУстаревшиеВерсии;
КонецПроцедуры

&НаСервере
Процедура УстановитьПараметрРегламентногоЗадания(ИмяПараметра, ЗначениеПараметра)
	
	ПараметрыЗадания = Новый Структура;
	ПараметрыЗадания.Вставить("Метаданные", Метаданные.РегламентныеЗадания.ОчисткаУстаревшихВерсийОбъектов);
	
	УстановитьПривилегированныйРежим(Истина);
	
	СписокЗаданий = РегламентныеЗаданияСервер.НайтиЗадания(ПараметрыЗадания);

	ПараметрыЗадания = Новый Структура(ИмяПараметра, ЗначениеПараметра);
	Для Каждого Задание Из СписокЗаданий Цикл
		РегламентныеЗаданияСервер.ИзменитьЗадание(Задание, ПараметрыЗадания);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьПараметрРегламентногоЗадания(ИмяПараметра, ЗначениеПоУмолчанию)
	ПараметрыЗадания = Новый Структура;
	ПараметрыЗадания.Вставить("Метаданные", Метаданные.РегламентныеЗадания.ОчисткаУстаревшихВерсийОбъектов);
	
	УстановитьПривилегированныйРежим(Истина);
	
	СписокЗаданий = РегламентныеЗаданияСервер.НайтиЗадания(ПараметрыЗадания);
	Для Каждого Задание Из СписокЗаданий Цикл
		Возврат Задание[ИмяПараметра];
	КонецЦикла;
	
	Возврат ЗначениеПоУмолчанию;
КонецФункции

&НаКлиенте
Процедура ПроверитьВыполнениеФоновогоЗадания()
	Если ЗначениеЗаполнено(ИдентификаторФоновогоЗадания) И Не ЗаданиеВыполнено(ИдентификаторФоновогоЗадания) Тогда
		ПодключитьОбработчикОжидания("ПроверитьВыполнениеФоновогоЗадания", 5, Истина);
	Иначе
		ИдентификаторФоновогоЗадания = "";
		Если ТекущееФоновоеЗадание = "Подсчет" Тогда
			ВывестиИнформациюОбУстаревшихВерсиях();
			Возврат;
		КонецЕсли;
		ТекущееФоновоеЗадание = "";
		ОбновитьИнформациюОбУстаревшихВерсиях();
	КонецЕсли;
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(ИдентификаторФоновогоЗадания)
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторФоновогоЗадания);
КонецФункции

&НаСервереБезКонтекста
Процедура ОтменитьВыполнениеЗадания(ИдентификаторФоновогоЗадания)
	Если ЗначениеЗаполнено(ИдентификаторФоновогоЗадания) Тогда 
		ДлительныеОперации.ОтменитьВыполнениеЗадания(ИдентификаторФоновогоЗадания);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ЗапуститьРегламентноеЗадание()
	
	РегламентноеЗаданиеМетаданные = Метаданные.РегламентныеЗадания.ОчисткаУстаревшихВерсийОбъектов;
	
	Отбор = Новый Структура;
	ИмяМетода = РегламентноеЗаданиеМетаданные.ИмяМетода;
	Отбор.Вставить("ИмяМетода", ИмяМетода);
	
	Отбор.Вставить("Состояние", СостояниеФоновогоЗадания.Активно);
	ФоновыеЗаданияОчистки = ФоновыеЗадания.ПолучитьФоновыеЗадания(Отбор);
	Если ФоновыеЗаданияОчистки.Количество() > 0 Тогда
		ИдентификаторФоновогоЗадания = ФоновыеЗаданияОчистки[0].УникальныйИдентификатор;
	Иначе
		ПараметрыЗадания = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
		ПараметрыЗадания.НаименованиеФоновогоЗадания = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Запуск вручную: %1';
																													|en = 'Manual start: %1'"), РегламентноеЗаданиеМетаданные.Синоним);
		РезультатЗадания = ДлительныеОперации.ВыполнитьПроцедуру(ПараметрыЗадания, РегламентноеЗаданиеМетаданные.ИмяМетода);
		Если ЗначениеЗаполнено(РезультатЗадания.ИдентификаторЗадания) Тогда
			ИдентификаторФоновогоЗадания = РезультатЗадания.ИдентификаторЗадания;
		КонецЕсли;
	КонецЕсли;
	
	ТекущееФоновоеЗадание = "Очистка";
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИнформациюОбУстаревшихВерсиях()
	ОтключитьОбработчикОжидания("НачатьОбновлениеИнформацииОбУстаревшихВерсиях");
	Если ТекущееФоновоеЗадание = "Подсчет" И ЗначениеЗаполнено(ИдентификаторФоновогоЗадания) Тогда
		ПрерватьФоновоеЗадание();
	КонецЕсли;
	ПодключитьОбработчикОжидания("НачатьОбновлениеИнформацииОбУстаревшихВерсиях", 2, Истина);
КонецПроцедуры

&НаКлиенте
Процедура ПрерватьФоновоеЗадание()
	ОтменитьВыполнениеЗадания(ИдентификаторФоновогоЗадания);
	ОтключитьОбработчикОжидания("ПроверитьВыполнениеФоновогоЗадания");
	ТекущееФоновоеЗадание = "";
	ИдентификаторФоновогоЗадания = "";
КонецПроцедуры

&НаКлиенте
Процедура НачатьОбновлениеИнформацииОбУстаревшихВерсиях()
	
	Элементы.Очистить.Видимость = ТекущееФоновоеЗадание <> "Очистка";
	Если ЗначениеЗаполнено(ИдентификаторФоновогоЗадания) Тогда
		Если ТекущееФоновоеЗадание = "Подсчет" Тогда
			Элементы.ИнформацияОбУстаревшихВерсиях.Заголовок = ТекстСостоянияПодсчет();
		Иначе
			Элементы.ИнформацияОбУстаревшихВерсиях.Заголовок = ТекстСостоянияОчистка();
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	Элементы.ИнформацияОбУстаревшихВерсиях.Заголовок = ТекстСостоянияПодсчет();
	ДлительнаяОперация = ВыполнитьПоискУстаревшихВерсий();
	
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриЗавершенииОперацииПоискаУстаревшихВерсий", ЭтотОбъект);
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, ОписаниеОповещения, ПараметрыОжидания);
	
КонецПроцедуры

// Параметры:
//  Результат - см. ДлительныеОперацииКлиент.НовыйРезультатДлительнойОперации
//  ДополнительныеПараметры - Неопределено
//
&НаКлиенте
Процедура ПриЗавершенииОперацииПоискаУстаревшихВерсий(Результат, ДополнительныеПараметры) Экспорт
	
	ИдентификаторФоновогоЗадания = "";
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Результат.Статус = "Ошибка" Тогда
		СтандартныеПодсистемыКлиент.ВывестиИнформациюОбОшибке(
			Результат.ИнформацияОбОшибке);
		Возврат;
	КонецЕсли;

	ВывестиИнформациюОбУстаревшихВерсиях();
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ТекстСостоянияПодсчет()
	Возврат НСтр("ru = 'Поиск устаревших версий...';
				|en = 'Searching for outdated versions…'");
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ТекстСостоянияОчистка()
	Возврат НСтр("ru = 'Выполняется очистка устаревших версий...';
				|en = 'Cleaning up outdated versions…'");
КонецФункции

&НаСервере
Функция ВыполнитьПоискУстаревшихВерсий()
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Поиск устаревших версий объектов';
															|en = 'Search for outdated versions'");
	
	ДлительнаяОперация = ДлительныеОперации.ВыполнитьФункцию(ПараметрыВыполнения,
		"ВерсионированиеОбъектов.ИнформацияОбУстаревшихВерсиях");
	
	ТекущееФоновоеЗадание = "Подсчет";
	ИдентификаторФоновогоЗадания = ДлительнаяОперация.ИдентификаторЗадания;
	АдресРезультата = ДлительнаяОперация.АдресРезультата;
	
	Возврат ДлительнаяОперация;
	
КонецФункции

&НаКлиенте
Процедура ВывестиИнформациюОбУстаревшихВерсиях()
	
	ИнформацияОбУстаревшихВерсиях = ПолучитьИзВременногоХранилища(АдресРезультата);
	Если ИнформацияОбУстаревшихВерсиях = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Элементы.Очистить.Видимость = ИнформацияОбУстаревшихВерсиях.РазмерДанных > 0;
	Если ИнформацияОбУстаревшихВерсиях.РазмерДанных > 0 Тогда
		Элементы.ИнформацияОбУстаревшихВерсиях.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Всего устаревших версий: %1 (%2)';
				|en = 'Total outdated versions: %1 (%2)'"),
			ИнформацияОбУстаревшихВерсиях.КоличествоВерсий,
			ИнформацияОбУстаревшихВерсиях.РазмерДанныхСтрокой);
	Иначе
		Элементы.ИнформацияОбУстаревшихВерсиях.Заголовок = НСтр("ru = 'Всего устаревших версий: нет';
																|en = 'Total outdated versions: none'");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСпискиВыбора()
	
	СписокВыбораСправочники = Новый СписокЗначений;
	СписокВыбораСправочники.Добавить(Перечисления.ВариантыВерсионированияОбъектов.ВерсионироватьПриЗаписи);
	СписокВыбораСправочники.Добавить(Перечисления.ВариантыВерсионированияОбъектов.НеВерсионировать);
	
	СписокВыбораДокументы = Новый СписокЗначений;
	СписокВыбораДокументы.Добавить(Перечисления.ВариантыВерсионированияОбъектов.ВерсионироватьПриЗаписи);
	СписокВыбораДокументы.Добавить(Перечисления.ВариантыВерсионированияОбъектов.ВерсионироватьПриПроведении);
	СписокВыбораДокументы.Добавить(Перечисления.ВариантыВерсионированияОбъектов.НеВерсионировать);
	
	СписокВыбораБизнесПроцессы = Новый СписокЗначений;
	СписокВыбораБизнесПроцессы.Добавить(Перечисления.ВариантыВерсионированияОбъектов.ВерсионироватьПриЗаписи);
	СписокВыбораБизнесПроцессы.Добавить(Перечисления.ВариантыВерсионированияОбъектов.ВерсионироватьПриСтарте);
	СписокВыбораБизнесПроцессы.Добавить(Перечисления.ВариантыВерсионированияОбъектов.НеВерсионировать);
	
КонецПроцедуры

&НаСервере
Функция АвтоматическаяОчисткаВключена()
	Возврат ПолучитьПараметрРегламентногоЗадания("Использование", Ложь);
КонецФункции

#КонецОбласти
