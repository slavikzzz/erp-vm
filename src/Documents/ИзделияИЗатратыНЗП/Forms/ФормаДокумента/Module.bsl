#Область ОписаниеПеременных

&НаКлиенте
Перем КэшированныеЗначения;

&НаКлиенте
Перем ТекущиеДанныеИдентификатор;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);

	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПриЧтенииСозданииНаСервере();
		Объект.Автор = Пользователи.ТекущийПользователь();
	КонецЕсли;
	
	Заголовок = Документы.ИзделияИЗатратыНЗП.ПредставлениеДокумента(Объект, ТекущаяДатаСеанса());
	
	НачалоПроизводства = НачалоМесяца(?(ЗначениеЗаполнено(Объект.Дата), Объект.Дата, ТекущаяДатаСеанса()));
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ИнтеграцияС1СДокументооборотом
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// Обработчик механизма "ДатыЗапретаИзменения"
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	ПриЧтенииСозданииНаСервере();
	
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	МодификацияКонфигурацииПереопределяемый.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	НадписьПериод = ПредставлениеПериода(НачалоМесяца(Объект.Дата), КонецМесяца(Объект.Дата), "ДЛФ=D");
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если НоменклатураКлиент.ЭтоУказаниеСерий(ИсточникВыбора) Тогда
		НоменклатураКлиент.ОбработатьУказаниеСерии(ЭтаФорма, ПараметрыУказанияСерий.МатериалыИУслуги, ВыбранноеЗначение);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);
	// Конец ИнтеграцияС1СДокументооборотом
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ЗаполнитьСлужебныеРеквизитыПоНоменклатуре();
	
	Заголовок = Документы.ИзделияИЗатратыНЗП.ПредставлениеДокумента(Объект);
	
	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульПодключаемыеКомандыКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ПодключаемыеКомандыКлиент");
		МодульПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СпецификацияПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Объект.Спецификация) Тогда
		ЗаполнитьКоличествоУпаковкуПоСпецификацииНаСервере();
	Иначе
		Объект.Упаковка = ПредопределенноеЗначение("Справочник.УпаковкиЕдиницыИзмерения.ПустаяСсылка");
		Объект.Количество = Объект.КоличествоУпаковок;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КоличествоУпаковокПриИзменении(Элемент)
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПересчитатьКоличествоЕдиниц");
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(Объект, СтруктураДействий, КэшированныеЗначения);
	
КонецПроцедуры

&НаКлиенте
Процедура НазначениеПриИзменении(Элемент)

	НайденныеСтроки = Объект.МатериалыИУслуги.НайтиСтроки(Новый Структура("Обособленный", Истина));
	
	Для Каждого Строка Из НайденныеСтроки Цикл
		Строка.Назначение = Объект.Назначение;
		Строка.Обособленный = ЗначениеЗаполнено(Объект.Назначение);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	
	НадписьПериод = ПредставлениеПериода(НачалоМесяца(Объект.Дата), КонецМесяца(Объект.Дата), "ДЛФ=D");
	
	ДатаПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура НоменклатураПриИзменении(Элемент)
	НоменклатураПриИзмененииСервер();
КонецПроцедуры

&НаКлиенте
Процедура ПодразделениеПриИзменении(Элемент)
	ПроверитьСпецификацию();
КонецПроцедуры

&НаКлиенте
Процедура ХарактеристикаПриИзменении(Элемент)
	ПроверитьСпецификацию();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыМатериалыИУслуги

&НаКлиенте
Процедура МатериалыИУслугиНоменклатураПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.МатериалыИУслуги.ТекущиеДанные;
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПроверитьХарактеристикуПоВладельцу", ТекущиеДанные.Характеристика);
	СтруктураДействий.Вставить("ПроверитьЗаполнитьУпаковкуПоВладельцу", ТекущиеДанные.Упаковка);
	СтруктураДействий.Вставить("ПересчитатьКоличествоЕдиниц");
	СтруктураДействий.Вставить("ЗаполнитьПризнакТипНоменклатуры", Новый Структура("Номенклатура", "ТипНоменклатуры"));
	
	ПараметрыПроверкиСерий = Новый Структура("Склад, ПараметрыУказанияСерий", ТекущиеДанные.Подразделение, ПараметрыУказанияСерий.МатериалыИУслуги);
	СтруктураДействий.Вставить("ПроверитьСериюРассчитатьСтатус", ПараметрыПроверкиСерий);
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущиеДанные, СтруктураДействий, КэшированныеЗначения);
	
КонецПроцедуры

&НаКлиенте
Процедура МатериалыИУслугиКоличествоУпаковокПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.МатериалыИУслуги.ТекущиеДанные;
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПересчитатьКоличествоЕдиниц");
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущиеДанные, СтруктураДействий, КэшированныеЗначения);
	
КонецПроцедуры

&НаКлиенте
Процедура МатериалыИУслугиУпаковкаПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.МатериалыИУслуги.ТекущиеДанные;
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПересчитатьКоличествоЕдиниц");
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущиеДанные, СтруктураДействий, КэшированныеЗначения);
	
КонецПроцедуры

&НаКлиенте
Процедура МатериалыИУслугиОбособленныйПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.МатериалыИУслуги.ТекущиеДанные;
	
	ТекущаяСтрока.Назначение = ?(ТекущаяСтрока.Обособленный, Объект.Назначение, ПредопределенноеЗначение("Справочник.Назначения.ПустаяСсылка"));
	
КонецПроцедуры

&НаКлиенте
Процедура МатериалыИУслугиСерияПриИзменении(Элемент)

	ТекущаяСтрока = Элементы.МатериалыИУслуги.ТекущиеДанные;
	
	ВыбранноеЗначение = НоменклатураКлиентСервер.ВыбраннаяСерия();
	ВыбранноеЗначение.Значение                   = ТекущаяСтрока.Серия;
	ВыбранноеЗначение.ИдентификаторТекущейСтроки = ТекущаяСтрока.ПолучитьИдентификатор();
	
	НоменклатураКлиент.ОбработатьУказаниеСерии(ЭтаФорма, ПараметрыУказанияСерий.МатериалыИУслуги, ВыбранноеЗначение);
	
КонецПроцедуры

&НаКлиенте
Процедура МатериалыИУслугиПодразделениеПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.МатериалыИУслуги.ТекущиеДанные;
	
	СтруктураДействий = Новый Структура;
	
	ПараметрыПроверкиСерий = Новый Структура("Склад, ПараметрыУказанияСерий", ТекущиеДанные.Подразделение, ПараметрыУказанияСерий.МатериалыИУслуги);
	СтруктураДействий.Вставить("ПроверитьСериюРассчитатьСтатус", ПараметрыПроверкиСерий);
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущиеДанные, СтруктураДействий, КэшированныеЗначения);
	
КонецПроцедуры

&НаКлиенте
Процедура МатериалыИУслугиСерияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОткрытьПодборСерий(Элемент.ТекстРедактирования, Элементы.МатериалыИУслуги.ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура МатериалыИУслугиПослеУдаления(Элемент)
	
	НеобходимоОбновитьСтатусыСерий = НоменклатураКлиент.НеобходимоОбновитьСтатусыСерий(Элемент, КэшированныеЗначения, ПараметрыУказанияСерий.МатериалыИУслуги, Истина);
	Если НеобходимоОбновитьСтатусыСерий Тогда
		НоменклатураКлиент.ОбновитьКешированныеЗначенияДляУчетаСерий(Элемент, КэшированныеЗначения, ПараметрыУказанияСерий.МатериалыИУслуги);
	КонецЕсли;
	
	МатериалыИУслугиПослеУдаленияНаСервере(НеобходимоОбновитьСтатусыСерий, КэшированныеЗначения);
	
КонецПроцедуры

&НаКлиенте
Процедура МатериалыИУслугиПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	СкладыКлиент.ОбновитьКешированныеЗначения(Элемент, КэшированныеЗначения, ПараметрыУказанияСерий.МатериалыИУслуги, Копирование);
КонецПроцедуры

&НаКлиенте
Процедура МатериалыИУслугиПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	Если ОтменаРедактирования Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элементы.МатериалыИУслуги.ТекущиеДанные;
	
	Если НоменклатураКлиент.НеобходимоОбновитьСтатусыСерий(Элемент, КэшированныеЗначения, ПараметрыУказанияСерий.МатериалыИУслуги) Тогда
		
		ТекущаяСтрокаИдентификатор = ТекущиеДанные.ПолучитьИдентификатор();
		
		ЗаполнитьСтатусыУказанияСерийПриОкончанииРедактированияСтрокиТЧ(ТекущаяСтрокаИдентификатор, КэшированныеЗначения, "МатериалыИУслуги");
		НоменклатураКлиент.ОбновитьКешированныеЗначенияДляУчетаСерий(Элемент,КэшированныеЗначения,ПараметрыУказанияСерий.МатериалыИУслуги);
		
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Объект);
КонецПроцедуры


&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры


&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура ЗаписатьДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Записать(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьМатериалы(Команда)
	
	Если Не ПроверитьЗаполнениеРеквизитов() Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьНаСервере("МатериалыИУслуги");
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьТрудозатраты(Команда)
	
	Если Не ПроверитьЗаполнениеРеквизитов() Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьНаСервере("Трудозатраты");
КонецПроцедуры

&НаКлиенте
Процедура ПровестиДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Провести(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиИЗакрыть(Команда)
	
	ОбщегоНазначенияУТКлиент.ПровестиИЗакрыть(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаУказатьСерииМатериалыИУслуги(Команда)
	
	ОткрытьПодборСерий();
	
КонецПроцедуры

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры
// Конец ИнтеграцияС1СДокументооборотом

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()
	
	ПараметрыУказанияСерий = Новый ФиксированнаяСтруктура(Документы.ИзделияИЗатратыНЗП.ПараметрыУказанияСерий(Объект));
	
	УстановитьВидимостьЭлементовСерий();
	
	ХарактеристикиИспользуются = Справочники.Номенклатура.ХарактеристикиИспользуются(Объект.Номенклатура);
	Элементы.Характеристика.Доступность = ХарактеристикиИспользуются;
	
	Элементы.Упаковка.Видимость = ЗначениеЗаполнено(Объект.Упаковка);
	Элементы.НоменклатураЕдиницаИзмерения.Видимость = Не ЗначениеЗаполнено(Объект.Упаковка);
	
	ПараметрыВыбораСпецификаций = УправлениеДаннымиОбИзделиях.ПараметрыВыбораСпецификаций(Объект, Документы.ИзделияИЗатратыНЗП);
	УправлениеДаннымиОбИзделияхКлиентСервер.УстановитьПараметрыВыбораСпецификаций(Элементы.Спецификация, ПараметрыВыбораСпецификаций);
	
	ЗаполнитьСлужебныеРеквизитыПоНоменклатуре();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	// Стандартное оформление формы.
	#Область СтандартноеОформление
	НоменклатураСервер.УстановитьУсловноеОформлениеХарактеристикНоменклатуры(ЭтаФорма, 
																			 "МатериалыИУслугиХарактеристика",
																		     "Объект.МатериалыИУслуги.ХарактеристикиИспользуются");
																			 
	НоменклатураСервер.УстановитьУсловноеОформлениеЕдиницИзмерения(ЭтаФорма,
																   "МатериалыИУслугиНоменклатураЕдиницаИзмерения",
																   "Объект.МатериалыИУслуги.Упаковка");

	#КонецОбласти
	
	НоменклатураСервер.УстановитьУсловноеОформлениеСерийНоменклатуры(ЭтаФорма, Ложь, "МатериалыИУслугиСерия", "Объект.МатериалыИУслуги.СтатусУказанияСерий", "Объект.МатериалыИУслуги.ТипНоменклатуры");
	НоменклатураСервер.УстановитьУсловноеОформлениеСтатусовУказанияСерий(ЭтаФорма, Ложь, "МатериалыИУслугиСтатусУказанияСерий", "Объект.МатериалыИУслуги.СтатусУказанияСерий");

	// Признак обособленного материала не отображается, если назначение не заполнено.
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.МатериалыИУслугиОбособленный.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.Назначение");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;

	Элемент.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНаСервере(ИмяТЧ)
	
	ДанныеПоНоменклатуре = Справочники.РесурсныеСпецификации.ДанныеОсновногоИзделияСпецификации(Объект.Спецификация, Объект.Номенклатура, Объект.Характеристика);
	ДанныеПоНоменклатуре.НачалоПроизводства = Объект.Дата;
	
	Если ДанныеПоНоменклатуре.Количество = Неопределено Тогда
		Если ИмяТЧ = "МатериалыИУслуги" Тогда
			Объект.МатериалыИУслуги.Очистить();
		КонецЕсли;
		Если ИмяТЧ = "Трудозатраты" Тогда
			Объект.Трудозатраты.Очистить();
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	Коэффициент = Объект.Количество / ДанныеПоНоменклатуре.Количество;
	
	ПараметрыВыборки = Справочники.РесурсныеСпецификации.ПараметрыВыборкиДанных(
		"МатериалыИУслуги, Трудозатраты",
		,
		Перечисления.ВариантыЗаполненияОбеспеченияПроизводства.ПоНастройкамПередачиВПроизводство);
	ПараметрыВыборки.ОкруглятьКоличествоШтучныхТоваров = Ложь;
	
	ТабличныеЧасти = Справочники.РесурсныеСпецификации.ДанныеСпецификацииСПолуфабрикатами(ДанныеПоНоменклатуре, Ложь, ПараметрыВыборки);
	
	Если ИмяТЧ = "МатериалыИУслуги" Тогда
		
		Объект.МатериалыИУслуги.Загрузить(ТабличныеЧасти.МатериалыИУслуги);
		
		Для Каждого Строка Из Объект.МатериалыИУслуги Цикл
			Строка.Количество = Строка.Количество * Коэффициент;
			Строка.КоличествоУпаковок = Строка.КоличествоУпаковок * Коэффициент;
		КонецЦикла;
		
		ЗаполнитьСлужебныеРеквизитыПоНоменклатуре();
		
		НоменклатураСервер.ЗаполнитьСтатусыУказанияСерий(Объект, ПараметрыУказанияСерий.МатериалыИУслуги);
		
	КонецЕсли;
	
	Если ИмяТЧ = "Трудозатраты" Тогда
		
		Объект.Трудозатраты.Загрузить(ТабличныеЧасти.Трудозатраты);
		
		Для Каждого Строка Из Объект.Трудозатраты Цикл
			Строка.Количество = Строка.Количество * Коэффициент;
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьКоличествоУпаковкуПоСпецификацииНаСервере()
	
	ДанныеИзделия = Справочники.РесурсныеСпецификации.ДанныеОсновногоИзделияСпецификации(Объект.Спецификация, Объект.Номенклатура);
	
	ЗаполнитьЗначенияСвойств(Объект, ДанныеИзделия, "Количество,КоличествоУпаковок,Упаковка");
	
КонецПроцедуры

&НаКлиенте
Функция ПроверитьЗаполнениеРеквизитов()
	
	ЕстьОшибкиЗаполнения = Ложь;
	
	Если Не ЗначениеЗаполнено(Объект.Номенклатура) Тогда
		
		ТекстСообщения = НСтр("ru = 'Поле ""Изделие"" не заполнено';
								|en = 'Product is not filled in'");
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстСообщения,
			,
			"Объект.Номенклатура",
			, ЕстьОшибкиЗаполнения);
		
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.Спецификация) Тогда
		
		ТекстСообщения = НСтр("ru = 'Поле ""Спецификация"" не заполнено';
								|en = '""Bill of materials"" is required'");
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстСообщения,
			,
			"Объект.Спецификация",
			, ЕстьОшибкиЗаполнения);
		
	КонецЕсли;
		
	Если Не ЗначениеЗаполнено(Объект.КоличествоУпаковок) Тогда
		
		ТекстСообщения = НСтр("ru = 'Поле ""Количество"" не заполнено';
								|en = '""Quantity"" is not filled in'");
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстСообщения,
			,
			"Объект.КоличествоУпаковок",
			, ЕстьОшибкиЗаполнения);
		
		КонецЕсли;
		
	Возврат Не ЕстьОшибкиЗаполнения;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьСлужебныеРеквизитыПоНоменклатуре()
	
	ПараметрыЗаполненияРеквизитов = Новый Структура;
	ПараметрыЗаполненияРеквизитов.Вставить("ЗаполнитьПризнакХарактеристикиИспользуются",
		Новый Структура("Номенклатура", "ХарактеристикиИспользуются"));
	
	ПараметрыЗаполненияРеквизитов.Вставить("ЗаполнитьПризнакТипНоменклатуры",
		Новый Структура("Номенклатура", "ТипНоменклатуры"));
	
	НоменклатураСервер.ЗаполнитьСлужебныеРеквизитыПоНоменклатуреВКоллекции(Объект.МатериалыИУслуги, ПараметрыЗаполненияРеквизитов);
	
КонецПроцедуры

&НаСервере
Процедура ПроверитьСпецификацию()
	
	ДанныеОбИзделии = УправлениеДаннымиОбИзделияхКлиентСервер.СтруктураДанныхОбИзделииДляВыбораСпецификации();
	ДанныеОбИзделии.Номенклатура           = Объект.Номенклатура;
	ДанныеОбИзделии.Характеристика         = Объект.Характеристика;
	ДанныеОбИзделии.НачалоПроизводства     = Объект.Дата;
	ДанныеОбИзделии.ТекущаяСпецификация    = Объект.Спецификация;
	
	ДанныеСпецификации = УправлениеДаннымиОбИзделияхВызовСервера.СпецификацияИзделия(
		ДанныеОбИзделии,
		ПараметрыВыбораСпецификаций);
	
	Если ДанныеСпецификации = Неопределено Тогда
		Объект.Спецификация = Неопределено;
	Иначе
		Если ДанныеСпецификации.Спецификация <> Объект.Спецификация Тогда
			Объект.Спецификация = ДанныеСпецификации.Спецификация;
			ЗаполнитьКоличествоУпаковкуПоСпецификацииНаСервере();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ДатаПриИзмененииНаСервере()
	
	НачалоПроизводства = НачалоМесяца(?(ЗначениеЗаполнено(Объект.Дата), Объект.Дата, ТекущаяДатаСеанса()));
	
	ОбновитьЗаголовокНаСервере();
	
	ПроверитьСпецификацию();
	
КонецПроцедуры

&НаСервере
Процедура НоменклатураПриИзмененииСервер()
	ПроверитьСпецификацию();
	
	ХарактеристикиИспользуются = Справочники.Номенклатура.ХарактеристикиИспользуются(Объект.Номенклатура);
	Элементы.Характеристика.Доступность = ХарактеристикиИспользуются;
КонецПроцедуры

#Область Серии

&НаСервере
Процедура УстановитьВидимостьЭлементовСерий()
	
	Элементы.МатериалыИУслугиСтатусУказанияСерий.Видимость = ПараметрыУказанияСерий.МатериалыИУслуги.ИспользоватьСерииНоменклатуры;
	Элементы.МатериалыИУслугиСерия.Видимость = ПараметрыУказанияСерий.МатериалыИУслуги.УчитыватьСебестоимостьПоСериям;
	Элементы.МатериалыИУслугиУказатьСерииМатериалыИУслуги.Видимость = ПараметрыУказанияСерий.МатериалыИУслуги.ИспользоватьСерииНоменклатуры;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПодборСерий(Текст = "", ТекущиеДанные = Неопределено)
	
	Если НоменклатураКлиент.ДляУказанияСерийНуженСерверныйВызов(ЭтаФорма, ПараметрыУказанияСерий.МатериалыИУслуги, Текст, ТекущиеДанные) Тогда
		ТекстИсключения = НСтр("ru = 'Ошибка при попытке указать серии - в этом документе для указания серий не нужен серверный вызов.';
								|en = 'An error occurred when attempting to specify batch. No server call is required to specify batch in this document.'");
		ВызватьИсключение ТекстИсключения;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура МатериалыИУслугиПослеУдаленияНаСервере(НеобходимоОбновитьСтатусыСерий, КэшированныеЗначения)

	Если НеобходимоОбновитьСтатусыСерий Тогда
		ЗаполнитьСтатусыУказанияСерийПриОкончанииРедактированияСтрокиТЧ(Неопределено, КэшированныеЗначения, "МатериалыИУслуги");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСтатусыУказанияСерийПриОкончанииРедактированияСтрокиТЧ(ТекущаяСтрокаИдентификатор, КэшированныеЗначения, ИмяТЧ)
	
	НоменклатураСервер.ЗаполнитьСтатусыУказанияСерийПриОкончанииРедактированияСтрокиТЧ(Объект,
		ПараметрыУказанияСерий.МатериалыИУслуги, ТекущаяСтрокаИдентификатор, КэшированныеЗначения);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьЗаголовокНаСервере()
	Заголовок = Документы.ИзделияИЗатратыНЗП.ПредставлениеДокумента(Объект);
КонецПроцедуры

#КонецОбласти

#КонецОбласти
