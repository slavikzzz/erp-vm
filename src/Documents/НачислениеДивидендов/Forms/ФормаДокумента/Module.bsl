
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	// Обработчик подсистемы "Свойства"
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Объект", Объект);
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтаФорма, ДополнительныеПараметры);
	
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПриЧтенииСозданииНаСервере();
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьЗаявкиНаРасходованиеДенежныхСредств")
		И НЕ РольДоступна("ДобавлениеИзменениеЗаявокНаРасходДС") И НЕ РольДоступна("ПолныеПрава") Тогда
		Элементы.ЮридическиеЛицаЮридическиеЛицаВвестиЗаявкуНаПеречисление.Доступность = Ложь;
		Элементы.ФизическиеЛицаФизическиеЛицаВвестиЗаявкуНаПеречисление.Доступность = Ложь;
	КонецЕсли;
	
	Если НЕ РольДоступна("ДобавлениеИзменениеДокументовПоБанку") И НЕ РольДоступна("ПолныеПрава") Тогда
		Элементы.ЮридическиеЛицаЮридическиеЛицаВвестиСписание.Доступность = Ложь;
		Элементы.ФизическиеЛицаФизическиеЛицаВвестиСписание.Доступность = Ложь;
	КонецЕсли;
	
	Если НЕ РольДоступна("ДобавлениеИзменениеДокументовПоКассе") И НЕ РольДоступна("ПолныеПрава") Тогда
		Элементы.ЮридическиеЛицаЮридическиеЛицаВвестиРасходныйОрдер.Доступность = Ложь;
		Элементы.ФизическиеЛицаФизическиеЛицаВвестиРасходныйОрдер.Доступность = Ложь;
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ИнтеграцияС1СДокументооборотом
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	ПриЧтенииСозданииНаСервере();	
	
	СобытияФорм.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтаФорма, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	// Обработчик подсистемы "Свойства"
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект);
	
	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);
	// Конец ИнтеграцияС1СДокументооборотом
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом

	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);
	
	СобытияФорм.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	
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

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	// Подсистема "Свойства"
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтаФорма, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	
	СобытияФормКлиент.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыФизическиеЛица

&НаКлиенте
Процедура ФизическиеЛицаФизическоеЛицоПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ФизическиеЛица.ТекущиеДанные;
	
	Если ИспользоватьНачислениеЗарплаты И ЗначениеЗаполнено(ТекущиеДанные.ФизическоеЛицо) Тогда
		ФизическоеЛицоПриИзмененииНаСервере(ТекущиеДанные.ПолучитьИдентификатор());
	Иначе
		
		ТекущиеДанные.ПрочийАкционер = Ложь;
		ТекущиеДанные.СтавкаНДФЛ = СтавкаФизЛицаКонтрагента(ТекущиеДанные.ФизическоеЛицо);
		
	КонецЕсли;
	
	ТекущиеДанные.Контрагент = ПредопределенноеЗначение("Справочник.Контрагенты.ПустаяСсылка");
	СтруктураДействий = Новый Структура("НДФЛ, КВыплатеФизическомуЛицу");
	ПересчитатьСтроку(СтруктураДействий, ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура ФизическиеЛицаПрочийАкционерПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ФизическиеЛица.ТекущиеДанные;
	
	Если Не ТекущиеДанные.ПрочийАкционер Тогда
		ТекущиеДанные.Контрагент = ПредопределенноеЗначение("Справочник.Контрагенты.ПустаяСсылка");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ФизическиеЛицаНачисленоПриИзменении(Элемент)
	ТекущиеДанные = Элементы.ФизическиеЛица.ТекущиеДанные;
	СтруктураДействий = Новый Структура("НДФЛ, КВыплатеФизическомуЛицу");
	ПересчитатьСтроку(СтруктураДействий, ТекущиеДанные);
КонецПроцедуры

&НаКлиенте
Процедура ФизическиеЛицаСтавкаНДФЛПриИзменении(Элемент)
	ТекущиеДанные = Элементы.ФизическиеЛица.ТекущиеДанные;
	СтруктураДействий = Новый Структура("НДФЛ, КВыплатеФизическомуЛицу");
	ПересчитатьСтроку(СтруктураДействий, ТекущиеДанные);
КонецПроцедуры

&НаКлиенте
Процедура ФизическиеЛицаНДФЛПриИзменении(Элемент)
	ТекущиеДанные = Элементы.ФизическиеЛица.ТекущиеДанные;
	СтруктураДействий = Новый Структура("КВыплатеФизическомуЛицу");
	ПересчитатьСтроку(СтруктураДействий, ТекущиеДанные);
КонецПроцедуры

&НаКлиенте
Процедура ФизическиеЛицаНДФЛСПревышенияПриИзменении(Элемент)
	ТекущиеДанные = Элементы.ФизическиеЛица.ТекущиеДанные;
	СтруктураДействий = Новый Структура("КВыплатеФизическомуЛицу");
	ПересчитатьСтроку(СтруктураДействий, ТекущиеДанные);
КонецПроцедуры

&НаКлиенте
Процедура ФизическиеЛицаВычетПоНДФЛПриИзменении(Элемент)
	ТекущиеДанные = Элементы.ФизическиеЛица.ТекущиеДанные;
	СтруктураДействий = Новый Структура("НДФЛ, КВыплатеФизическомуЛицу");
	ПересчитатьСтроку(СтруктураДействий, ТекущиеДанные);
КонецПроцедуры

&НаКлиенте
Процедура ФизическиеЛицаНалогНаПрибыльКЗачетуПриИзменении(Элемент)
	ТекущиеДанные = Элементы.ФизическиеЛица.ТекущиеДанные;
	СтруктураДействий = Новый Структура("КВыплатеФизическомуЛицу");
	ПересчитатьСтроку(СтруктураДействий, ТекущиеДанные);
КонецПроцедуры

&НаКлиенте
Процедура ФизическиеЛицаКВыплатеПриИзменении(Элемент)
	ТекущиеДанные = Элементы.ФизическиеЛица.ТекущиеДанные;
	СтруктураДействий = Новый Структура("НДФЛ, НачисленоФизическомуЛицу");
	ПересчитатьСтроку(СтруктураДействий, ТекущиеДанные);
КонецПроцедуры

&НаКлиенте
Процедура ФизическиеЛицаПриИзменении(Элемент)
	ОбновитьИтоги();
КонецПроцедуры

&НаКлиенте
Процедура ФизическиеЛицаПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока Тогда
		ТекущиеДанные = Элементы.ФизическиеЛица.ТекущиеДанные;
		ТекущиеДанные.СтавкаНДФЛ = ПредопределенноеЗначение("Перечисление.НДФЛСтавки.Ставка13");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыЮридическиеЛица

&НаКлиенте
Процедура ЮридическиеЛицаКонтрагентПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ЮридическиеЛица.ТекущиеДанные;
	
	НоваяСтавка = СтавкаФизЛицаКонтрагента(ТекущиеДанные.Контрагент);
	
	Если ТекущиеДанные.СтавкаНалогаНаПрибыль <> НоваяСтавка Тогда
		ТекущиеДанные.СтавкаНалогаНаПрибыль = НоваяСтавка;
		СтруктураДействий = Новый Структура("НалогНаПрибыль, КВыплатеЮридическомуЛицу");
		ПересчитатьСтроку(СтруктураДействий, ТекущиеДанные);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЮридическиеЛицаПриИзменении(Элемент)
	ОбновитьИтоги();
КонецПроцедуры

&НаКлиенте
Процедура ЮридическиеЛицаПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока Тогда
		ТекущиеДанные = Элементы.ЮридическиеЛица.ТекущиеДанные;
		ТекущиеДанные.СтавкаНалогаНаПрибыль = 13;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЮридическиеЛицаНачисленоПриИзменении(Элемент)
	ТекущиеДанные = Элементы.ЮридическиеЛица.ТекущиеДанные;
	СтруктураДействий = Новый Структура("НалогНаПрибыль, КВыплатеЮридическомуЛицу");
	ПересчитатьСтроку(СтруктураДействий, ТекущиеДанные);
КонецПроцедуры

&НаКлиенте
Процедура ЮридическиеЛицаСтавкаНалогаНаПрибыльПриИзменении(Элемент)
	ТекущиеДанные = Элементы.ЮридическиеЛица.ТекущиеДанные;
	СтруктураДействий = Новый Структура("НалогНаПрибыль, КВыплатеЮридическомуЛицу");
	ПересчитатьСтроку(СтруктураДействий, ТекущиеДанные);
КонецПроцедуры

&НаКлиенте
Процедура ЮридическиеЛицаНалогНаПрибыльПриИзменении(Элемент)
	ТекущиеДанные = Элементы.ЮридическиеЛица.ТекущиеДанные;
	СтруктураДействий = Новый Структура("КВыплатеЮридическомуЛицу");
	ПересчитатьСтроку(СтруктураДействий, ТекущиеДанные);
КонецПроцедуры

&НаКлиенте
Процедура ЮридическиеЛицаКВыплатеПриИзменении(Элемент)
	ТекущиеДанные = Элементы.ЮридическиеЛица.ТекущиеДанные;
	СтруктураДействий = Новый Структура("НалогНаПрибыль, НачисленоЮридическомуЛицу");
	ПересчитатьСтроку(СтруктураДействий, ТекущиеДанные);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды


// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды


&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
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
Процедура ПровестиДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Провести(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиИЗакрыть(Команда)
	
	ОбщегоНазначенияУТКлиент.ПровестиИЗакрыть(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ФизическиеЛицаВвестиЗаявкуНаПеречисление(Команда)
	СоздатьЗаявкуНаПеречислениеДенежныхСредств("ФизическиеЛица");
КонецПроцедуры

&НаКлиенте
Процедура ЮридическиеЛицаВвестиЗаявкуНаПеречисление(Команда)
	СоздатьЗаявкуНаПеречислениеДенежныхСредств("ЮридическиеЛица");
КонецПроцедуры

&НаКлиенте
Процедура ФизическиеЛицаВвестиРасходныйОрдер(Команда)
	ВвестиПлатежныйДокумент("ФизическиеЛица", "РасходныйКассовыйОрдер");
КонецПроцедуры

&НаКлиенте
Процедура ЮридическиеЛицаВвестиРасходныйОрдер(Команда)
	ВвестиПлатежныйДокумент("ЮридическиеЛица", "РасходныйКассовыйОрдер");
КонецПроцедуры

&НаКлиенте
Процедура ФизическиеЛицаВвестиСписание(Команда)
	ВвестиПлатежныйДокумент("ФизическиеЛица", "СписаниеБезналичныхДенежныхСредств");
КонецПроцедуры

&НаКлиенте
Процедура ЮридическиеЛицаВвестиСписание(Команда)
	ВвестиПлатежныйДокумент("ЮридическиеЛица", "СписаниеБезналичныхДенежныхСредств");
КонецПроцедуры

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры
// Конец ИнтеграцияС1СДокументооборотом

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.Свойства

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

// Конец СтандартныеПодсистемы.Свойства

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	// Не облагается НДФЛ
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ФизическиеЛицаСтавкаНДФЛ.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.ФизическиеЛица.СтавкаНДФЛ");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'Не облагается';
																|en = 'Not subject'"));
	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);
	
	// Не облагается налог на прибыль
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ЮридическиеЛицаСтавкаНалогаНаПрибыль.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.ЮридическиеЛица.СтавкаНалогаНаПрибыль");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'Не облагается';
																|en = 'Not subject'"));
	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);
	
	// Сотрудник организации
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ФизическиеЛицаКонтрагент.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.ФизическиеЛица.ПрочийАкционер");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);
	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	
	// Представление ставки налога на прибыль.
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ЮридическиеЛицаСтавкаНалогаНаПрибыль.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.ЮридическиеЛица.СтавкаНалогаНаПрибыль");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = 12;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", "12%");
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ЮридическиеЛицаСтавкаНалогаНаПрибыль.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.ЮридическиеЛица.СтавкаНалогаНаПрибыль");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = 13;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", "13%");
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ЮридическиеЛицаСтавкаНалогаНаПрибыль.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.ЮридическиеЛица.СтавкаНалогаНаПрибыль");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = 15;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", "15%");
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ЮридическиеЛицаСтавкаНалогаНаПрибыль.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.ЮридическиеЛица.СтавкаНалогаНаПрибыль");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = 5;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", "5%");
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ЮридическиеЛицаСтавкаНалогаНаПрибыль.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.ЮридическиеЛица.СтавкаНалогаНаПрибыль");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = 10;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", "10%");
	
	// Видимость полей вычета/зачета НДФЛ
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ФизическиеЛицаВычетПоНДФЛ.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.ДатаВыплаты");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.БольшеИлиРавно;
	ОтборЭлемента.ПравоеЗначение = УчетНДФЛ.ПараметрыРасчетаНДФЛПоПрогрессивнойШкале().НачалоРасчетаНДФЛПоПрогрессивнойШкале;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ФизическиеЛицаНалогНаПрибыльКЗачету.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.ДатаВыплаты");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Меньше;
	ОтборЭлемента.ПравоеЗначение = УчетНДФЛ.ПараметрыРасчетаНДФЛПоПрогрессивнойШкале().НачалоРасчетаНДФЛПоПрогрессивнойШкале;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()
	
	Ставки = Новый Соответствие();
	Ставки.Вставить(Перечисления.НДФЛСтавки.ПустаяСсылка(), 0);
	Ставки.Вставить(Перечисления.НДФЛСтавки.Ставка13, 0.13);
	Ставки.Вставить(Перечисления.НДФЛСтавки.Ставка15, 0.15);
	
	ЗначенияСтавок = Новый ФиксированноеСоответствие(Ставки);
	
	ИспользоватьНачислениеЗарплаты = ПолучитьФункциональнуюОпцию("ИспользоватьНачислениеЗарплаты");
	
	ОбновитьИтоги();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьИтоги()
	
	ВсегоПоДокументу = Объект.ФизическиеЛица.Итог("Начислено") + Объект.ЮридическиеЛица.Итог("Начислено");
	
КонецПроцедуры

&НаКлиенте
Процедура ПересчитатьСтроку(Действия, ДанныеСтроки)
	
	Если Действия.Свойство("НачисленоФизическомуЛицу") Тогда
		ДанныеСтроки.Начислено = (ДанныеСтроки.КВыплате + ДанныеСтроки.КВыплате * ЗначенияСтавок[ДанныеСтроки.СтавкаНДФЛ]) / (1 + ЗначенияСтавок[ДанныеСтроки.СтавкаНДФЛ]);
	КонецЕсли;
	
	Если Действия.Свойство("НачисленоЮридическомуЛицу") Тогда
		ДанныеСтроки.Начислено = ДанныеСтроки.КВыплате / (1 - ДанныеСтроки.СтавкаНалогаНаПрибыль / 100);
	КонецЕсли;
	
	Если Действия.Свойство("НДФЛ") Тогда
		Если ДанныеСтроки.СтавкаНДФЛ = ПредопределенноеЗначение("Перечисление.НДФЛСтавки.Ставка13") Тогда
			НДФЛ = РассчитатьНДФЛАкционераНаСервере(Объект.ДатаВыплаты, Объект.Организация, ДанныеСтроки.ФизическоеЛицо, ДанныеСтроки.Начислено, ДанныеСтроки.ВычетПоНДФЛ, Объект.Ссылка);
			ЗаполнитьЗначенияСвойств(ДанныеСтроки, НДФЛ);
		Иначе
			ДанныеСтроки.НДФЛ = Окр(Окр((ДанныеСтроки.Начислено - ДанныеСтроки.ВычетПоНДФЛ) * ЗначенияСтавок[ДанныеСтроки.СтавкаНДФЛ], 2));
			ДанныеСтроки.НДФЛСПревышения = 0;
		КонецЕсли;
	КонецЕсли;
	
	Если Действия.Свойство("НалогНаПрибыль") Тогда
		ДанныеСтроки.НалогНаПрибыль = Окр(Окр(ДанныеСтроки.Начислено * ДанныеСтроки.СтавкаНалогаНаПрибыль / 100, 2));
	КонецЕсли;
	
	Если Действия.Свойство("КВыплатеФизическомуЛицу") Тогда
		ДанныеСтроки.КВыплате = ДанныеСтроки.Начислено - ДанныеСтроки.НДФЛ - ДанныеСтроки.НДФЛСПревышения + ДанныеСтроки.НалогНаПрибыльКЗачету;
	КонецЕсли;
	
	Если Действия.Свойство("КВыплатеЮридическомуЛицу") Тогда
		ДанныеСтроки.КВыплате = ДанныеСтроки.Начислено - ДанныеСтроки.НалогНаПрибыль;
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция РассчитатьНДФЛАкционераНаСервере(ДатаВыплаты, Организация, ФизическоеЛицо, Начислено, ВычетПоНДФЛ, Ссылка)
	
	Возврат УчетНДФЛ.НалогСДивидендовАкционера(ДатаВыплаты, Организация, ФизическоеЛицо, Начислено, ВычетПоНДФЛ,, Ссылка);
	
КонецФункции

&НаСервере
Процедура ФизическоеЛицоПриИзмененииНаСервере(Идентификатор)
	
	ДанныеСтроки = Объект.ФизическиеЛица.НайтиПоИдентификатору(Идентификатор);
	ДатаПолученияДанных = ?(ЗначениеЗаполнено(Объект.ДатаВыплаты), Объект.ДатаВыплаты, ТекущаяДатаСеанса());
	
	Сотрудники = КадровыйУчет.ОсновныеСотрудникиФизическихЛиц(
		ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ДанныеСтроки.ФизическоеЛицо),
		Истина,
		Объект.Организация,
		ДатаПолученияДанных);
	
	Если Сотрудники.Количество() > 0 И ЗначениеЗаполнено(Сотрудники[0].Сотрудник) Тогда
		ДанныеСтроки.ПрочийАкционер = Ложь;
	Иначе
		ДанныеСтроки.ПрочийАкционер = Истина;
	КонецЕсли;
	
	ДанныеСтроки.СтавкаНДФЛ = СтавкаФизЛицаКонтрагента(ДанныеСтроки.ФизическоеЛицо);
	
КонецПроцедуры

&НаСервере
Функция СтавкаФизЛицаКонтрагента(ФизлицоКонтрагент)
	
	Если ТипЗнч(ФизлицоКонтрагент) = Тип("СправочникСсылка.ФизическиеЛица") Тогда
		
		УстановитьПривилегированныйРежим(Истина);
		ДанныеФизЛицаКонтрагента = КадровыйУчет.КадровыеДанныеФизическихЛиц(
			Истина,
			ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ФизлицоКонтрагент),
			"СтатусНалогоплательщика",
			Объект.Дата);
			
		Если ДанныеФизЛицаКонтрагента.Количество() > 0
			И ДанныеФизЛицаКонтрагента[0].СтатусНалогоплательщика = Справочники.СтатусыНалогоплательщиковПоНДФЛ.Нерезидент Тогда
			Возврат Перечисления.НДФЛСтавки.Ставка15;
		КонецЕсли;
		
		Возврат Перечисления.НДФЛСтавки.Ставка13;
		
	Иначе
		
		ЮрФизЛицо = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ФизлицоКонтрагент, "ЮрФизЛицо");
		
		Если ЮрФизЛицо = Перечисления.ЮрФизЛицо.ЮрЛицоНеРезидент Тогда
			Возврат 15;
		КонецЕсли;
		
		Возврат 13;
		
	КонецЕсли;
	
	
КонецФункции

&НаКлиенте
Процедура СоздатьЗаявкуНаПеречислениеДенежныхСредств(ИмяТаблицы)
	
	ТекущиеДанные = Элементы[ИмяТаблицы].ТекущиеДанные;
	
	Если Не ПроверитьВозможностьОформленияВыплат(ТекущиеДанные) Тогда
		Возврат;
	КонецЕсли;
	
	Основание = Новый Структура();
	Основание.Вставить("ДокументОснование",         Объект.Ссылка);
	Основание.Вставить("Контрагент",                ТекущиеДанные.Контрагент);
	Основание.Вставить("СуммаДокумента",            ТекущиеДанные.КВыплате);
	Основание.Вставить("Сумма",                     ТекущиеДанные.КВыплате);
	Основание.Вставить("Организация",               Объект.Организация);
	Основание.Вставить("ХозяйственнаяОперация",     ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ПрочаяВыдачаДенежныхСредств"));
	Основание.Вставить("ФормаОплатыНаличная",       Истина);
	Основание.Вставить("ФормаОплатыБезналичная",    Истина);
	Основание.Вставить("СтатьяРасходов",            ПредопределенноеЗначение("ПланВидовХарактеристик.СтатьиАктивовПассивов.ПрибылиИУбытки"));
	Основание.Вставить("ЖелательнаяДатаПлатежа",    Объект.ДатаВыплаты);
	
	Если ИмяТаблицы = "ФизическиеЛица" И Не ТекущиеДанные.ПрочийАкционер Тогда
		Основание.Вставить("СчетУчета",             ПредопределенноеЗначение("ПланСчетов.Хозрасчетный.РасчетыСПерсоналомПоОплатеТруда"));
		Основание.Вставить("Субконто1",             ТекущиеДанные.ФизическоеЛицо);
	Иначе
		Основание.Вставить("СчетУчета",             ПредопределенноеЗначение("ПланСчетов.Хозрасчетный.РасчетыПоВыплатеДоходов"));
		Основание.Вставить("Субконто1",             ТекущиеДанные.Контрагент);
	КонецЕсли;

	ОткрытьФорму("Документ.ЗаявкаНаРасходованиеДенежныхСредств.ФормаОбъекта", Новый Структура("Основание", Основание));
	
КонецПроцедуры

&НаКлиенте
Процедура ВвестиПлатежныйДокумент(ИмяТаблицы, ИмяДокумента)
	
	ТекущиеДанные = Элементы[ИмяТаблицы].ТекущиеДанные;
	
	Если Не ПроверитьВозможностьОформленияВыплат(ТекущиеДанные) Тогда
		Возврат;
	КонецЕсли;
	
	Основание = Новый Структура();
	Основание.Вставить("ДокументОснование",         Объект.Ссылка);
	Основание.Вставить("Контрагент",                ТекущиеДанные.Контрагент);
	Основание.Вставить("Валюта",                    Объект.Валюта);
	Основание.Вставить("СуммаДокумента",            ТекущиеДанные.КВыплате);
	Основание.Вставить("Сумма",                     ТекущиеДанные.КВыплате);
	Основание.Вставить("Организация",               Объект.Организация);
	Основание.Вставить("ХозяйственнаяОперация",     ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ПрочаяВыдачаДенежныхСредств"));
	Основание.Вставить("СтатьяРасходов",            ПредопределенноеЗначение("ПланВидовХарактеристик.СтатьиАктивовПассивов.ПрибылиИУбытки"));
	
	Если ИмяТаблицы = "ФизическиеЛица" И Не ТекущиеДанные.ПрочийАкционер Тогда
		Основание.Вставить("СчетУчета",             ПредопределенноеЗначение("ПланСчетов.Хозрасчетный.РасчетыСПерсоналомПоОплатеТруда"));
		Основание.Вставить("Субконто1",             ТекущиеДанные.ФизическоеЛицо);
	Иначе
		Основание.Вставить("СчетУчета",             ПредопределенноеЗначение("ПланСчетов.Хозрасчетный.РасчетыПоВыплатеДоходов"));
		Основание.Вставить("Субконто1",             ТекущиеДанные.Контрагент);
	КонецЕсли;
	
	ОткрытьФорму("Документ."+ ИмяДокумента + ".ФормаОбъекта", Новый Структура("Основание", Основание));
	
КонецПроцедуры

&НаКлиенте
Функция ПроверитьВозможностьОформленияВыплат(ТекущиеДанные)
	
	Если ТекущиеДанные = Неопределено Тогда
		ТекстПредупреждения = НСтр("ru = 'Команда не может быть выполнена для указанного объекта';
									|en = 'Cannot execute the command for the specified object'");
		ПоказатьПредупреждение(, ТекстПредупреждения);
		Возврат Ложь;
	КонецЕсли;
	
	НепроведенныеДокументы = ОбщегоНазначенияВызовСервера.ПроверитьПроведенностьДокументов(ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Объект.Ссылка));
	
	Если НепроведенныеДокументы.Количество() > 0 Тогда
		ТекстПредупреждения = НСтр("ru = 'Оформление выплат возможно только на основании проведенного документа';
									|en = 'Payments can be registered only based on the posted document'");
		ПоказатьПредупреждение(, ТекстПредупреждения);
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	
	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтаФорма);
	
КонецПроцедуры

// СтандартныеПодсистемы.Свойства
&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

#КонецОбласти
