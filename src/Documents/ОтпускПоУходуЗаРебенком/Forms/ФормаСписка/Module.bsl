
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.РежимВыбора Тогда
		Элементы.Список.РежимВыбора = Истина;
	КонецЕсли;
	
	Если Параметры.РежимВыбора Тогда
		КлючНазначенияИспользования = "РежимВыбора";
		КлючСохраненияПоложенияОкна = КлючНазначенияИспользования;
		АвтоматическоеСохранениеДанныхВНастройках = АвтоматическоеСохранениеДанныхФормыВНастройках.НеИспользовать;
	КонецЕсли;
	
	Если Параметры.Отбор.Свойство("Организация") Тогда
		Если ЗначениеЗаполнено(Параметры.Отбор.Организация) И Не ЗначениеЗаполнено(Организация) Тогда
			Организация = Параметры.Отбор.Организация;
		КонецЕсли;
		Параметры.Отбор.Удалить("Организация");
	КонецЕсли;
	Если ЗначениеЗаполнено(Организация) Тогда
		Организации.Добавить(Организация);
	КонецЕсли;
	Если Параметры.Отбор.Свойство("ФизическоеЛицо") Тогда
		Если ТипЗнч(Параметры.Отбор.ФизическоеЛицо) = Тип("СправочникСсылка.ФизическиеЛица")
			И ЗначениеЗаполнено(Параметры.Отбор.ФизическоеЛицо)
			И Не ЗначениеЗаполнено(ФизическоеЛицо) Тогда
			ФизическоеЛицо = Параметры.Отбор.ФизическоеЛицо;
		КонецЕсли;
		Параметры.Отбор.Удалить("ФизическоеЛицо");
	КонецЕсли;
	Если Параметры.Отбор.Свойство("Сотрудник") Тогда
		Если ЗначениеЗаполнено(Параметры.Отбор.Сотрудник) И Не ЗначениеЗаполнено(ФизическоеЛицо) Тогда
			Если ТипЗнч(Параметры.Отбор.Сотрудник) = Тип("СправочникСсылка.Сотрудники") Тогда
				ФизическоеЛицо = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Параметры.Отбор.Сотрудник, "ФизическоеЛицо");
			ИначеЕсли ТипЗнч(Параметры.Отбор.Сотрудник) = Тип("СправочникСсылка.ФизическиеЛица") Тогда
				ФизическоеЛицо = Параметры.Отбор.Сотрудник;
			КонецЕсли;
		КонецЕсли;
		Параметры.Отбор.Удалить("Сотрудник");
	КонецЕсли;
	
	МногофункциональныеДокументыБЗКФормы.УстановитьВидимостьКомандыУтвердитьВСписке(ЭтотОбъект);
	ЗарплатаКадрыРасширенный.УстановитьУсловноеОформлениеСпискаМногофункциональныхДокументов(ЭтаФорма);
	
	// Обработчик подсистемы "ВерсионированиеОбъектов".
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.КоманднаяПанель = Элементы.КоманднаяПанельФормы;
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	ЗарплатаКадры.ПриСозданииНаСервереФормыСДинамическимСписком(ЭтотОбъект, "Список");
	
	// СтандартныеПодсистемы.КонтрольВеденияУчета
	КонтрольВеденияУчетаБЗК.ПриСозданииНаСервереФормыСписка(ЭтотОбъект, "Список");
	// Конец СтандартныеПодсистемы.КонтрольВеденияУчета
	
	// БлокировкаИзмененияОбъектов
	БлокировкаИзмененияОбъектов.ПриСозданииНаСервереФормыСписка(ЭтотОбъект, Элементы.КоманднаяПанельФормы);
	// Конец БлокировкаИзмененияОбъектов
	
	// КадровыйЭДО
	КадровыйЭДО.ПриСозданииНаСервереФормыСписка(ЭтотОбъект, Список);
	// Конец КадровыйЭДО
	
	// ИнтеграцияС1СДокументооборотом
	Если ОбщегоНазначения.ПодсистемаСуществует("ИнтеграцияС1СДокументооборотом") Тогда
		МодульИнтеграцияС1СДокументооборотБазоваяФункциональность = ОбщегоНазначения.ОбщийМодуль(
			"ИнтеграцияС1СДокументооборотБазоваяФункциональность");
		МодульИнтеграцияС1СДокументооборотБазоваяФункциональность.ПриСозданииНаСервере(ЭтотОбъект);
	КонецЕсли;
	// Конец ИнтеграцияС1СДокументооборотом
	
	// СтандартныеПодсистемы.УчетОригиналовПервичныхДокументов
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УчетОригиналовПервичныхДокументов") Тогда
		МодульУчетОригиналовПервичныхДокументов = ОбщегоНазначения.ОбщийМодуль("УчетОригиналовПервичныхДокументов");
		МодульУчетОригиналовПервичныхДокументов.ПриСозданииНаСервере_ФормаСписка(ЭтотОбъект, Элементы.Список, Элементы.Комментарий);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УчетОригиналовПервичныхДокументов
	
	// ПроцессыОбработкиДокументов
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ПроцессыОбработкиДокументовЗарплата") Тогда
		МодульПроцессыОбработкиДокументовЗарплата = ОбщегоНазначения.ОбщийМодуль("ПроцессыОбработкиДокументовЗарплата");
		МодульПроцессыОбработкиДокументовЗарплата.ПриСозданииНаСервереФормыСписка(ЭтотОбъект, "Список");
	КонецЕсли;
	// Конец ПроцессыОбработкиДокументов
	
	ПоказыватьОрганизации = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизацийЗарплатаКадрыБазовая");
	Если ПоказыватьОрганизации Тогда
		ЗаполнитьСписокВыбораГоловныхОрганизаций();
		Количество = Элементы.ГоловнаяОрганизация.СписокВыбора.Количество();
		Если Количество > 1 И ЕстьФилиалы() Тогда
			ПоказыватьГоловныеОрганизации = Истина;
		КонецЕсли;
	Иначе
		Элементы.ОтборОрганизацияГруппа.Видимость = Ложь;
		Элементы.ОтборОрганизацииГруппа.Видимость  = Ложь;
		ОрганизацияПоУмолчанию = Справочники.Организации.ОрганизацияПоУмолчанию();
		Если ЗначениеЗаполнено(ОрганизацияПоУмолчанию) Тогда
			Организации.Добавить(ОрганизацияПоУмолчанию);
		КонецЕсли;
	КонецЕсли;
	
	Если Не ПоказыватьГоловныеОрганизации Тогда
		Элементы.ОтборГоловнаяОрганизацияГруппа.Видимость = Ложь;
	КонецЕсли;
	
	Если Не ОбщегоНазначенияБЗК.ЕстьСохраненныеНастройкиФормы(ЭтотОбъект) Тогда
		ПослеЗагрузкиВсехНастроекФормыНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗагрузкойДанныхИзНастроекНаСервере(Настройки)
	// Если форма открыта в сценарии выбора или в сценарии текущих дел, то настройки не загружаются.
	Если ЗначениеЗаполнено(КлючНазначенияИспользования) Тогда
		Настройки.Очистить();
		Возврат;
	КонецЕсли;
	// Организации загружаются только в том случае, если они видны и отсутствуют в предустановленных (контекстных) фильтрах.
	Если ПоказыватьОрганизации И Не ЗначениеЗаполнено(ГоловнаяОрганизация) И Организации.Количество() = 0 Тогда
		Если ПоказыватьГоловныеОрганизации Тогда
			ГоловнаяОрганизация = Настройки["ГоловнаяОрганизация"];
		КонецЕсли;
		ИспользоватьСписокОрганизаций = Настройки["ИспользоватьСписокОрганизаций"];
		// Представления могли измениться, поэтому в список загружаются только значения.
		ОрганизацииИзНастроек = Настройки["Организации"];
		Если ТипЗнч(ОрганизацииИзНастроек) = Тип("СписокЗначений") Тогда
			Организации.ЗагрузитьЗначения(ОрганизацииИзНастроек.ВыгрузитьЗначения());
		КонецЕсли;
		СписокОрганизацийДляВыбораИзНастроек = Настройки["СписокОрганизацийДляВыбора"];
		Если ТипЗнч(СписокОрганизацийДляВыбораИзНастроек) = Тип("СписокЗначений") Тогда
			СписокОрганизацийДляВыбора.ЗагрузитьЗначения(СписокОрганизацийДляВыбораИзНастроек.ВыгрузитьЗначения());
		КонецЕсли;
		Если Не ИспользоватьСписокОрганизаций И Организации.Количество() > 0 Тогда
			Организация = Организации[0].Значение;
		КонецЕсли;
	КонецЕсли;
	Настройки.Удалить("Организация");
	Настройки.Удалить("Организации");
	Настройки.Удалить("СписокОрганизацийДляВыбора");
	Настройки.Удалить("ГоловнаяОрганизация");
	Настройки.Удалить("ИспользоватьСписокОрганизаций");
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	ПослеЗагрузкиВсехНастроекФормыНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// КадровыйЭДО
	КадровыйЭДОКлиент.ОбработкаОповещенияВФормеСписка(
		ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	// Конец КадровыйЭДО
	
	// СтандартныеПодсистемы.УчетОригиналовПервичныхДокументов
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.УчетОригиналовПервичныхДокументов") Тогда
		МодульУчетОригиналовПервичныхДокументовКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("УчетОригиналовПервичныхДокументовКлиент");
		МодульУчетОригиналовПервичныхДокументовКлиент.ОбработчикОповещенияФормаСписка(ИмяСобытия, ЭтотОбъект, Элементы.Список);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УчетОригиналовПервичныхДокументов
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ГоловнаяОрганизацияПриИзменении(Элемент)
	Организация = Неопределено;
	Организации.Очистить();
	ОбновитьФорму();
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	Организации.Очистить();
	Если ЗначениеЗаполнено(Организация) Тогда
		Организации.Добавить(Организация);
	КонецЕсли;
	ОбновитьФорму();
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацииПредставлениеНажатие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ВыбратьОрганизации();
КонецПроцедуры

&НаКлиенте
Процедура ФизическоеЛицоПриИзменении(Элемент)
	ОбновитьФорму();
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	ЗарплатаКадрыРасширенныйКлиентСервер.УстановитьДоступностьКомандыУтвердитьВМногофункциональныхДокументах(ЭтаФорма);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервере
Процедура СписокПередЗагрузкойПользовательскихНастроекНаСервере(Элемент, Настройки)
	ЗарплатаКадры.ПроверитьПользовательскиеНастройкиДинамическогоСписка(ЭтотОбъект, Настройки);
КонецПроцедуры

&НаСервере
Процедура СписокПриОбновленииСоставаПользовательскихНастроекНаСервере(СтандартнаяОбработка)
	
	ЗарплатаКадры.ПроверитьПользовательскиеНастройкиДинамическогоСписка(ЭтотОбъект, , СтандартнаяОбработка);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура СписокПриПолученииДанныхНаСервере(ИмяЭлемента, Настройки, Строки)
	
	// СтандартныеПодсистемы.КонтрольВеденияУчета
	КонтрольВеденияУчетаБЗК.ПриПолученииДанныхНаСервере(Настройки, Строки);
	// Конец СтандартныеПодсистемы.КонтрольВеденияУчета
	
	// КадровыйЭДО
	КадровыйЭДО.СписокПриПолученииДанныхНаСервере(ИмяЭлемента, Настройки, Строки);
	// Конец КадровыйЭДО
	
	// СтандартныеПодсистемы.УчетОригиналовПервичныхДокументов
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УчетОригиналовПервичныхДокументов") Тогда
		МодульУчетОригиналовПервичныхДокументов = ОбщегоНазначения.ОбщийМодуль("УчетОригиналовПервичныхДокументов");
		МодульУчетОригиналовПервичныхДокументов.ПриПолученииДанныхНаСервере(Строки);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УчетОригиналовПервичныхДокументов
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыбратьНасколькоФилиалов(Команда)
	Организации.Очистить();
	Если ЗначениеЗаполнено(Организация) Тогда
		Организации.Добавить(Организация);
	КонецЕсли;
	ВыбратьОрганизации();
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьСписокФилиалов(Команда)
	Организации.Очистить();
	ОбновитьФорму();
КонецПроцедуры

&НаКлиенте
Процедура ВернутьсяКВыборуОдногоФилиала(Команда)
	ИспользоватьСписокОрганизаций = Ложь;
	Если Организации.Количество() > 0 Тогда
		Организация = Организации[0].Значение;
	Иначе
		Организация = Неопределено;
	КонецЕсли;
	ОрганизацияПриИзменении(Неопределено);
КонецПроцедуры

&НаКлиенте
Процедура Утвердить(Команда)
	
	ЗарплатаКадрыРасширенныйКлиент.УтвердитьВыделенныеМногофункциональныеДокументы(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

#Область РасширениеСобытийФормы

&НаСервере
Процедура ПослеЗагрузкиВсехНастроекФормыНаСервере()
	Если Не ЗначениеЗаполнено(Организация) Тогда
		ЗначенияДляЗаполнения = Новый Структура("Организация", "Организация");
		ЗарплатаКадры.ЗаполнитьПервоначальныеЗначенияВФорме(ЭтотОбъект, ЗначенияДляЗаполнения);
		Если ЗначениеЗаполнено(Организация) Тогда
			Организации.Добавить(Организация);
		КонецЕсли;
	КонецЕсли;
	ОбновитьФорму();
КонецПроцедуры

#КонецОбласти

#Область ПодключаемыеКоманды

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры

&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Элементы.Список);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#Область УчетОригиналовПервичныхДокументов

// СтандартныеПодсистемы.УчетОригиналовПервичныхДокументов
&НаКлиенте
Процедура Подключаемый_ОбновитьКомандыСостоянияОригинала()
	
	ОбновитьКомандыСостоянияОригинала()
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьКомандыСостоянияОригинала()
	
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	
КонецПроцедуры
//Конец СтандартныеПодсистемы.УчетОригиналовПервичныхДокументов

#КонецОбласти

#Область КонтрольВеденияУчета

// СтандартныеПодсистемы.КонтрольВеденияУчета
&НаКлиенте
Процедура Подключаемый_Выбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка) Экспорт
	
	КонтрольВеденияУчетаКлиентБЗК.ОткрытьОтчетПоПроблемамИзСписка(ЭтотОбъект, "Список", Поле, СтандартнаяОбработка);
	
	// СтандартныеПодсистемы.УчетОригиналовПервичныхДокументов
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.УчетОригиналовПервичныхДокументов") Тогда
		МодульУчетОригиналовПервичныхДокументовКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("УчетОригиналовПервичныхДокументовКлиент");
		МодульУчетОригиналовПервичныхДокументовКлиент.СписокВыбор(Поле.Имя, ЭтотОбъект, Элементы.Список, СтандартнаяОбработка);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УчетОригиналовПервичныхДокументов
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.КонтрольВеденияУчета

#КонецОбласти

#Область ИнтеграцияС1СДокументооборотом

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ИнтеграцияС1СДокументооборотом") Тогда
		МодульИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль(
			"ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент");
		МодульИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(
			Команда,
			ЭтотОбъект,
			Элементы.Список);
	КонецЕсли;
	
КонецПроцедуры
// Конец ИнтеграцияС1СДокументооборотом

#КонецОбласти

#Область БлокировкаИзмененияОбъектов

// БлокировкаИзмененияОбъектов
&НаКлиенте
Процедура Подключаемый_РазблокироватьОбъекты(Команда)
	БлокировкаИзмененияОбъектовКлиент.РазблокироватьОбъектыСписка(ЭтотОбъект, Список, Элементы.Список.ВыделенныеСтроки);
КонецПроцедуры
// Конец БлокировкаИзмененияОбъектов

#КонецОбласти

#Область Форма

&НаСервере
Процедура ЗаполнитьСписокВыбораГоловныхОрганизаций()
	СписокВыбора = Элементы.ГоловнаяОрганизация.СписокВыбора;
	СписокВыбора.Очистить();
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Организации.Ссылка КАК Значение,
	|	Организации.Представление КАК Представление
	|ИЗ
	|	Справочник.Организации КАК Организации
	|ГДЕ
	|	Организации.Ссылка = Организации.ГоловнаяОрганизация";
	Таблица = Запрос.Выполнить().Выгрузить();
	Для Каждого СтрокаТаблицы Из Таблица Цикл
		ЗаполнитьЗначенияСвойств(СписокВыбора.Добавить(), СтрокаТаблицы);
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура ОбновитьФорму()
	ОбновитьЭлементыФормы();
	ОбновитьПараметрыСписка();
	Элементы.Список.Обновить();
КонецПроцедуры

&НаСервере
Процедура ОбновитьЭлементыФормы()
	
	Если Не ПоказыватьОрганизации Тогда
		Возврат;
	КонецЕсли;
	
	СвязиПараметровВыбора = Новый Массив;
	Если ЗначениеЗаполнено(ГоловнаяОрганизация) Тогда
		СвязиПараметровВыбора.Добавить(Новый СвязьПараметраВыбора("Отбор.ГоловнаяОрганизация", "ГоловнаяОрганизация"));
	КонецЕсли;
	Элементы.Организация.СвязиПараметровВыбора = Новый ФиксированныйМассив(СвязиПараметровВыбора);
	
	Если ИспользоватьСписокОрганизаций Тогда
		Элементы.ОтборОрганизацияГруппа.Видимость = Ложь;
		Элементы.ОтборОрганизацииГруппа.Видимость  = Истина;
		ПредставлениеСписка = СЭДОФСС.ПредставлениеСписка(Организации, 100);
		Если ПустаяСтрока(ПредставлениеСписка) Тогда
			ПредставлениеСписка = НСтр("ru = '<Все>';
										|en = '<All>'");
			Элементы.ОчиститьСписокФилиалов.Видимость = Ложь;
		Иначе
			Элементы.ОчиститьСписокФилиалов.Видимость = Истина;
		КонецЕсли;
	Иначе
		Элементы.ОтборОрганизацияГруппа.Видимость = Истина;
		Элементы.ОтборОрганизацииГруппа.Видимость = Ложь;
		ПредставлениеСписка = "";
	КонецЕсли;
	Элементы.ФилиалыПредставление.Заголовок = ПредставлениеСписка;
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЕстьФилиалы()
	УстановитьПривилегированныйРежим(Истина);
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	1 КАК Поле1
	|ИЗ
	|	Справочник.Организации КАК Организации
	|ГДЕ
	|	Организации.ГоловнаяОрганизация <> Организации.Ссылка
	|	И Организации.ГоловнаяОрганизация <> ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)";
	Возврат Не Запрос.Выполнить().Пустой();
КонецФункции

#КонецОбласти

#Область Список

&НаСервере
Процедура ОбновитьПараметрыСписка()
	
	ОтборКД = Список.КомпоновщикНастроек.Настройки.Отбор;
	
	Если ПоказыватьГоловныеОрганизации Тогда
		Если ИдентификаторОтбораГоловнаяОрганизация = Неопределено Тогда
			ЭлементОтбораКД = Неопределено;
		Иначе
			ЭлементОтбораКД = ОтборКД.ПолучитьОбъектПоИдентификатору(ИдентификаторОтбораГоловнаяОрганизация);
		КонецЕсли;
		Если ТипЗнч(ЭлементОтбораКД) <> Тип("ЭлементОтбораКомпоновкиДанных")
			Или СтрСравнить(ЭлементОтбораКД.ЛевоеЗначение, "ГоловнаяОрганизация") <> 0 Тогда
			ЭлементОтбораКД = ЗапросыБЗК.ДобавитьНедоступныйОтбор(ОтборКД, "ГоловнаяОрганизация", "=", ГоловнаяОрганизация);
			ИдентификаторОтбораГоловнаяОрганизация = ОтборКД.ПолучитьИдентификаторПоОбъекту(ЭлементОтбораКД);
		КонецЕсли;
		ЭлементОтбораКД.Использование  = ЗначениеЗаполнено(ГоловнаяОрганизация);
		ЭлементОтбораКД.ПравоеЗначение = ГоловнаяОрганизация;
		Элементы.СписокГоловнаяОрганизация.Видимость = Не ЭлементОтбораКД.Использование;
	КонецЕсли;
	
	Если ПоказыватьОрганизации Тогда
		Если ИдентификаторОтбораОрганизация = Неопределено Тогда
			ЭлементОтбораКД = Неопределено;
		Иначе
			ЭлементОтбораКД = ОтборКД.ПолучитьОбъектПоИдентификатору(ИдентификаторОтбораОрганизация);
		КонецЕсли;
		Если ТипЗнч(ЭлементОтбораКД) <> Тип("ЭлементОтбораКомпоновкиДанных")
			Или СтрСравнить(ЭлементОтбораКД.ЛевоеЗначение, "Организация") <> 0 Тогда
			ЭлементОтбораКД = ЗапросыБЗК.ДобавитьНедоступныйОтбор(ОтборКД, "Организация", "=", Организация);
			ИдентификаторОтбораОрганизация = ОтборКД.ПолучитьИдентификаторПоОбъекту(ЭлементОтбораКД);
		КонецЕсли;
		Количество = Организации.Количество();
		Если Количество = 0 Тогда
			ЭлементОтбораКД.Использование  = Ложь;
			Элементы.СписокОрганизация.Видимость = Истина;
		ИначеЕсли Количество = 1 Тогда
			ЭлементОтбораКД.Использование  = Истина;
			ЭлементОтбораКД.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
			ЭлементОтбораКД.ПравоеЗначение = Организации[0].Значение;
			Элементы.СписокОрганизация.Видимость         = Ложь;
			Элементы.СписокГоловнаяОрганизация.Видимость = Ложь;
		Иначе
			ЭлементОтбораКД.Использование  = Истина;
			ЭлементОтбораКД.ВидСравнения   = ВидСравненияКомпоновкиДанных.ВСписке;
			ЭлементОтбораКД.ПравоеЗначение = Организации;
			Элементы.СписокОрганизация.Видимость = Истина;
		КонецЕсли;
	КонецЕсли;
	
	Если ИдентификаторОтбораФизическоеЛицо = Неопределено Тогда
		ЭлементОтбораКД = Неопределено;
	Иначе
		ЭлементОтбораКД = ОтборКД.ПолучитьОбъектПоИдентификатору(ИдентификаторОтбораФизическоеЛицо);
	КонецЕсли;
	Если ТипЗнч(ЭлементОтбораКД) <> Тип("ЭлементОтбораКомпоновкиДанных")
		Или СтрСравнить(ЭлементОтбораКД.ЛевоеЗначение, "ФизическоеЛицо") <> 0 Тогда
		ЭлементОтбораКД = ЗапросыБЗК.ДобавитьНедоступныйОтбор(ОтборКД, "ФизическоеЛицо", "=", ФизическоеЛицо);
		ИдентификаторОтбораФизическоеЛицо = ОтборКД.ПолучитьИдентификаторПоОбъекту(ЭлементОтбораКД);
	КонецЕсли;
	ЭлементОтбораКД.Использование  = ЗначениеЗаполнено(ФизическоеЛицо);
	ЭлементОтбораКД.ПравоеЗначение = ФизическоеЛицо;
	
КонецПроцедуры

#КонецОбласти

#Область Организации

&НаКлиенте
Процедура ВыбратьОрганизации()
	ПараметрыВыбора = Новый Массив;
	Если ЗначениеЗаполнено(ГоловнаяОрганизация) Тогда
		ПараметрыВыбора.Добавить(Новый ПараметрВыбора("Отбор.ГоловнаяОрганизация", ГоловнаяОрганизация));
	КонецЕсли;
	Для Каждого ЭлементСписка Из Организации Цикл
		Если СписокОрганизацийДляВыбора.НайтиПоЗначению(ЭлементСписка.Значение) = Неопределено Тогда
			ЗаполнитьЗначенияСвойств(СписокОрганизацийДляВыбора.Добавить(), ЭлементСписка);
		КонецЕсли;
	КонецЦикла;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Отмеченные", Организации);
	ПараметрыФормы.Вставить("ЗначенияДляВыбора", СписокОрганизацийДляВыбора);
	ПараметрыФормы.Вставить("ЗначенияДляВыбораЗаполнены", Истина);
	ПараметрыФормы.Вставить("ОграничиватьВыборУказаннымиЗначениями", Ложь);
	ПараметрыФормы.Вставить("БыстрыйВыбор", Ложь);
	ПараметрыФормы.Вставить("Представление", НСтр("ru = 'Организации';
													|en = 'Companies'"));
	ПараметрыФормы.Вставить("ПараметрыВыбора", ПараметрыВыбора);
	ПараметрыФормы.Вставить("ОписаниеТипов", Организации.ТипЗначения);
	
	Если СписокОрганизацийДляВыбора.Количество() = 0 Тогда
		ПараметрыФормы.БыстрыйВыбор = Истина;
		ПараметрыФормы.ЗначенияДляВыбораЗаполнены = Ложь;
	КонецЕсли;
	
	Режим = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
	
	Обработчик = Новый ОписаниеОповещения("ПослеВыбораОрганизаций", ЭтотОбъект);
	
	ОткрытьФорму("ОбщаяФорма.ВводЗначенийСпискомСФлажками", ПараметрыФормы, ЭтотОбъект, , , , Обработчик, Режим);
КонецПроцедуры

&НаКлиенте
Процедура ПослеВыбораОрганизаций(РезультатВыбора, ПустойПараметр) Экспорт
	Если ТипЗнч(РезультатВыбора) <> Тип("СписокЗначений") Тогда
		Возврат;
	КонецЕсли;
	СписокОрганизацийДляВыбора = РезультатВыбора;
	ИспользоватьСписокОрганизаций = Истина;
	Организации.Очистить();
	Для Каждого ЭлементСписка Из РезультатВыбора Цикл
		Если ЭлементСписка.Пометка Тогда
			ЗаполнитьЗначенияСвойств(Организации.Добавить(), ЭлементСписка);
		КонецЕсли;
	КонецЦикла;
	ОбновитьФорму();
КонецПроцедуры

#КонецОбласти

#КонецОбласти
