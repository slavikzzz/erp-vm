
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	// Обработчик механизма "Свойства"
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект, ДополнительныеПараметры);
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПриЧтенииСозданииНаСервере();
		Объект.ДатаВыполнения = НачалоДня(ТекущаяДатаСеанса());
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ИнтеграцияС1СДокументооборотом
	
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
	
	ПриЧтенииСозданииНаСервере();
	
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);

	МодификацияКонфигурацииПереопределяемый.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// Обработчик механизма "Свойства"
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);

	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);

	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);
	// Конец ИнтеграцияС1СДокументооборотом
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// Обработчик механизма "Свойства"
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтотОбъект, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Запись_ПоручениеЭкспедитору", ПараметрыЗаписи, Объект.Ссылка);

	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);

	// СтандартныеПодсистемы.ПодключаемыеКоманды
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульПодключаемыеКомандыКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ПодключаемыеКомандыКлиент");
		МодульПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементов

&НаКлиенте
Процедура СпособДоставкиПриИзменении(Элемент)
	СпособДоставкиПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура НадписьОснованиеНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если Объект.Основания.Количество() = 1 Тогда
		ПоказатьЗначение(,Объект.Основания[0].Основание);
	Иначе
	
		Основания = Новый Массив;
		Для Каждого Стр Из Объект.Основания Цикл
			Основания.Добавить(Стр.Основание);
		КонецЦикла;
		
		ОткрытьФорму("ОбщаяФорма.СписокПроизвольныхОбъектовУП",
			Новый Структура("МассивДокументов,ЗаголовокФормы", Основания, НСтр("ru = 'Основания поручения экспедитору';
																				|en = 'Base delivery requests'")),,,,,,
			РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура АдресПриИзменении(Элемент)
	
	ДоставкаТоваровКлиент.ПриИзмененииПредставленияАдреса(
	    Элемент,
		Объект.АдресДоставки,
		Объект.АдресДоставкиЗначенияПолей);
	
КонецПроцедуры

&НаКлиенте
Процедура АдресДоставкиОчистка(Элемент, СтандартнаяОбработка)
	
	ДоставкаТоваровКлиент.ОчиститьПредставлениеАдреса(
		Объект.АдресДоставки,
		Объект.АдресДоставкиЗначенияПолей);
	
КонецПроцедуры

&НаКлиенте
Процедура АдресНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ИменаРеквизитовАдресовДоставки = ДоставкаТоваровКлиентСервер.ИменаРеквизитовАдресовДоставки("АдресДоставки");
	
	ДоставкаТоваровКлиент.ОткрытьФормуВыбораАдресаИОбработатьРезультат(
		Элемент,
		Объект,
		ИменаРеквизитовАдресовДоставки,
		СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПунктПриИзменении(Элемент)
	ПунктПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура АдресПунктаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ДоставкаТоваровКлиент.ПриИзмененииПредставленияАдреса(
	    Элемент,
		Объект.АдресДоставки,
		Объект.АдресДоставкиЗначенияПолей);
	
	Если ДоставкаТоваровКлиентСервер.ДопИнфоИзмененоПользователем(Элементы, Объект)
			И ВыбранноеЗначение.Свойство("ДополнительнаяИнформацияПоДоставке") Тогда
		ЗаполнитьЗначенияСвойств(Объект, ВыбранноеЗначение, , "ДополнительнаяИнформацияПоДоставке");
	Иначе
		ЗаполнитьЗначенияСвойств(Объект, ВыбранноеЗначение);
	КонецЕсли;
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ПунктНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПоказатьВыборИзСписка(Новый ОписаниеОповещения("ПунктНачалоВыбораНачалоВыбораЗавершение", ЭтотОбъект), СписокВыбораПунктов, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	
	Если Объект.ДатаВыполнения < Объект.Дата Тогда
		Объект.ДатаВыполнения = Объект.Дата;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Объект);
КонецПроцедуры


&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры


&НаКлиенте
Процедура ДополнитьИнформациюПоДоставкеКонтактами(Команда)
	ДополнитьИнформациюПоДоставкеКонтактамиНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ДополнитьОписаниеОснованиями(Команда)
	ДополнитьОписаниеОснованиямиНаСервере();
КонецПроцедуры

// СтандартныеПодсистемы.Свойства
&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры

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

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры
// Конец ИнтеграцияС1СДокументооборотом

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

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

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()
	
	Если Не ЗначениеЗаполнено(Объект.Ответственный) Тогда
		Объект.Ответственный = ПользователиКлиентСервер.ТекущийПользователь();
	КонецЕсли;
	
	СписокВыбораПунктов.Очистить();
	Если ПравоДоступа("Чтение", Метаданные.Справочники.Партнеры) Тогда
		СписокВыбораПунктов.Добавить(НСтр("ru = '<выбрать партнера>';
											|en = '<select a partner>'"));
	КонецЕсли;
	СписокВыбораПунктов.Добавить(НСтр("ru = '<выбрать подразделение>';
										|en = '<select a business unit>'"));
	СписокВыбораПунктов.Добавить(НСтр("ru = '<выбрать склад>';
										|en = '<select a warehouse>'"));
	СписокВыбораПунктов.Добавить(НСтр("ru = '<ввести произвольный текст>';
										|en = '<enter custom text>'"));
	
	Если Объект.Основания.Количество() > 0 Тогда
		ДанныеОснований = Документы.ПоручениеЭкспедитору.ДанныеОснований(Объект.Основания.Выгрузить().ВыгрузитьКолонку("Основание"));
		
		Для Каждого Значение Из ДанныеОснований.Пункты Цикл
			Если ТипЗнч(Значение) = Тип("Строка") Тогда
				ПредставлениеОбъекта = НСтр("ru = 'Текст';
											|en = 'Text'");
			Иначе
				ПредставлениеОбъекта = Значение.Метаданные().ПредставлениеОбъекта;
			КонецЕсли;
			
			ПредставлениеЗначения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = '%1: %2';
																								|en = '%1: %2'"),
				ПредставлениеОбъекта, Значение);
			СписокВыбораПунктов.Добавить(Значение, ПредставлениеЗначения);
		КонецЦикла;
		Элементы.Склад.СписокВыбора.ЗагрузитьЗначения(ДанныеОснований.Склады);
		Элементы.КонтактноеЛицо.СписокВыбора.ЗагрузитьЗначения(ДанныеОснований.Контакты);
	Иначе
		Элементы.НадписьОснование.Видимость = Ложь;
	КонецЕсли;
	
	ДоставкаТоваров.ПриЧтенииСозданииРаспоряженийНаСервере(Элементы, Объект);
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка)
		И Не ЗначениеЗаполнено(Объект.АдресДоставки)
		И ЗначениеЗаполнено(Объект.Пункт)
		И Элементы.АдресПункта.СписокВыбора.Количество() > 0 Тогда
		
		ПерваяСтруктураВСписке = Элементы.АдресПункта.СписокВыбора[0].Значение;
		ЗаполнитьЗначенияСвойств(Объект, ПерваяСтруктураВСписке);
		
	КонецЕсли;
	
	УстановитьДоступностьЭлементов();
	ОтобразитьОснование();
	СпособДоставкиПриИзмененииНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура СпособДоставкиПриИзмененииНаСервере()
	
	Если Объект.СпособДоставки = Перечисления.СпособыДоставки.ПоручениеЭкспедиторуСоСклада Тогда
		Элементы.ЗаголовокОткуда.Видимость = Истина;
		Элементы.ОтступОткуда.Видимость    = Истина;
		Элементы.Склад.Видимость           = Истина;
		Элементы.ЗаголовокСклад.Видимость  = Истина;
		Элементы.ЗаголовокОткуда.Заголовок = НСтр("ru = 'Откуда';
													|en = 'From'");
		Элементы.ЗаголовокКуда.Заголовок   = НСтр("ru = 'Куда';
													|en = 'To'");
	ИначеЕсли Объект.СпособДоставки = Перечисления.СпособыДоставки.ПоручениеЭкспедиторуНаСклад Тогда
		Элементы.ЗаголовокОткуда.Видимость = Истина;
		Элементы.ОтступОткуда.Видимость    = Истина;
		Элементы.Склад.Видимость           = Истина;
		Элементы.ЗаголовокСклад.Видимость  = Истина;
		Элементы.ЗаголовокОткуда.Заголовок = НСтр("ru = 'Куда';
													|en = 'To'");
		Элементы.ЗаголовокКуда.Заголовок   = НСтр("ru = 'Откуда';
													|en = 'From'");
	Иначе
		Элементы.ЗаголовокОткуда.Видимость = Ложь;
		Элементы.ОтступОткуда.Видимость    = Ложь;
		Элементы.Склад.Видимость           = Ложь;
		Элементы.ЗаголовокСклад.Видимость  = Ложь;
		Элементы.ЗаголовокКуда.Заголовок   = НСтр("ru = 'Где';
													|en = 'Where'");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОтобразитьОснование()
	Если Объект.Основания.Количество() = 0 Тогда
		Элементы.НадписьОснование.Заголовок = НСтр("ru = 'Основание';
													|en = 'Base document'");
		НадписьОснование = НСтр("ru = '<Добавить>';
								|en = '<Add>'");
	ИначеЕсли Объект.Основания.Количество() = 1 Тогда
		Элементы.НадписьОснование.Заголовок = НСтр("ru = 'Основание';
													|en = 'Base document'");
		НадписьОснование = Строка(Объект.Основания[0].Основание);
	Иначе
		Элементы.НадписьОснование.Заголовок = НСтр("ru = 'Основания';
													|en = 'Base documents'");
		НадписьОснование = НСтр("ru = 'Всего документов: %Количество%';
								|en = 'Total documents: %Количество%'");
		НадписьОснование = СтрЗаменить(НадписьОснование, "%Количество%", Объект.Основания.Количество());
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ДополнитьИнформациюПоДоставкеКонтактамиНаСервере()
	ДоставкаТоваров.ДополнитьИнформациюПоДоставкеКонтактами(Объект);
КонецПроцедуры

&НаСервере
Процедура ДополнитьОписаниеОснованиямиНаСервере()
	Основания = Объект.Основания.Выгрузить().ВыгрузитьКолонку("Основание");
	ОснованияПоТипам = ОбщегоНазначенияУТ.РазложитьМассивСсылокПоТипам(Основания);
	Для Каждого КлючИЗначение Из ОснованияПоТипам Цикл
		ТекстОснование = Строка(КлючИЗначение.Ключ) + ": ";
		Если КлючИЗначение.Ключ = Тип("Строка") Тогда
			ТекстОснование = КлючИЗначение.Значение + ".";
		Иначе
			Реквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъектов(КлючИЗначение.Значение, "Номер, Дата");
			ТекстОснование = Строка(КлючИЗначение.Ключ) + ?(КлючИЗначение.Значение.Количество()>1,": "," ");
			Для Каждого КлючИЗначениеРеквизитов Из Реквизиты Цикл
				ТекстНомерИДата = НСтр("ru = '%Номер% от %Дата%,';
										|en = '%Номер% dated %Дата%,'") + " ";
				ТекстНомерИДата = СтрЗаменить(ТекстНомерИДата, "%Номер%",
					ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(КлючИЗначениеРеквизитов.Значение.Номер));
				ТекстНомерИДата = СтрЗаменить(ТекстНомерИДата, "%Дата%",
					Формат(КлючИЗначениеРеквизитов.Значение.Дата,"ДФ=dd.MM.yy"));
				ТекстОснование = ТекстОснование + ТекстНомерИДата;
			КонецЦикла;
			ТекстОснование = Лев(ТекстОснование, СтрДлина(ТекстОснование)-2) + ".";
		КонецЕсли;
		Если СтрНайти(Объект.ОсобыеУсловияПеревозкиОписание, ТекстОснование) = 0 Тогда
			Если Не ПустаяСтрока(Объект.ОсобыеУсловияПеревозкиОписание) Тогда
				Объект.ОсобыеУсловияПеревозкиОписание = Объект.ОсобыеУсловияПеревозкиОписание + Символы.ПС;
			КонецЕсли;
			Объект.ОсобыеУсловияПеревозкиОписание = Объект.ОсобыеУсловияПеревозкиОписание + ТекстОснование;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура ПунктПриИзмененииНаСервере()
	
	Элементы.АдресПункта.СписокВыбора.Очистить();
	ПустыеРеквизиты = ДоставкаТоваровКлиентСервер.ПолучитьПустуюСтруктуруРеквизитовДоставки(Объект);
	ЗаполнитьЗначенияСвойств(Объект, ПустыеРеквизиты,,"СпособДоставки,ДополнительнаяИнформацияПоДоставке");
	
	Если ЗначениеЗаполнено(Объект.Пункт) Тогда
		
		ДоставкаТоваров.ЗаполнитьСпискиВыбораАдресовПолучателяОтправителя(Элементы, Объект);
		Если Элементы.АдресПункта.СписокВыбора.Количество() > 0 Тогда
			ПерваяСтруктураВСписке = Элементы.АдресПункта.СписокВыбора[0].Значение;
			
			Если ДоставкаТоваровКлиентСервер.ДопИнфоИзмененоПользователем(Элементы, Объект) Тогда
				ЗаполнитьЗначенияСвойств(Объект, ПерваяСтруктураВСписке,
					"АдресДоставки, АдресДоставкиЗначенияПолей, ЗонаДоставки, ВремяДоставкиС, ВремяДоставкиПо");
			Иначе
				ЗаполнитьЗначенияСвойств(Объект, ПерваяСтруктураВСписке);
			КонецЕсли;
			
		КонецЕсли;
				
	КонецЕсли;
	
	ПроверитьЗаполнитьКонтактноеЛицо();
	
	УстановитьДоступностьЭлементов();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьДоступностьЭлементов()
	
	Элементы.КонтактноеЛицо.Доступность = (ТипЗнч(Объект.Пункт) = Тип("СправочникСсылка.Партнеры"));
	Элементы.ДополнитьИнформациюПоДоставкеКонтактами.Доступность =
		(ТипЗнч(Объект.Пункт) <> Тип("СправочникСсылка.СтруктураПредприятия")
		И ТипЗнч(Объект.Пункт) <> Тип("Строка"));
	Элементы.ДополнитьОписаниеОснованиями.Доступность = (Объект.Основания.Количество() > 0);
	
КонецПроцедуры

&НаСервере
Процедура ПроверитьЗаполнитьКонтактноеЛицо()
	
	Если ТипЗнч(Объект.Пункт) <> Тип("СправочникСсылка.Партнеры") Тогда
		Объект.КонтактноеЛицо = Справочники.КонтактныеЛицаПартнеров.ПустаяСсылка();
		Возврат;
	КонецЕсли;
	ПартнерыИКонтрагенты.ЗаполнитьКонтактноеЛицоПартнераПоУмолчанию(Объект.Пункт, Объект.КонтактноеЛицо);
	
КонецПроцедуры

&НаКлиенте
Процедура ПунктНачалоВыбораНачалоВыбораЗавершение(ВыбранныйЭлемент, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныйЭлемент = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ВыбранноеЗначение = ВыбранныйЭлемент.Значение;
	ОписаниеОповещения = Новый ОписаниеОповещения("ПослеВыбораПункта",ЭтотОбъект);
	Если ВыбранноеЗначение = Неопределено Тогда
		Возврат;
	ИначеЕсли ВыбранноеЗначение = НСтр("ru = '<выбрать партнера>';
										|en = '<select a partner>'") Тогда
		ОткрытьФорму("Справочник.Партнеры.Форма.ФормаВыбора",            ,ЭтаФорма,,,,ОписаниеОповещения,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);	
	ИначеЕсли ВыбранноеЗначение = НСтр("ru = '<выбрать подразделение>';
										|en = '<select a business unit>'") Тогда
		ОткрытьФорму("Справочник.СтруктураПредприятия.Форма.ФормаВыбора",,ЭтаФорма,,,,ОписаниеОповещения,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	ИначеЕсли ВыбранноеЗначение = НСтр("ru = '<выбрать склад>';
										|en = '<select a warehouse>'") Тогда
		ОткрытьФорму("Справочник.Склады.Форма.ФормаВыбора",              ,ЭтаФорма,,,,ОписаниеОповещения,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	ИначеЕсли ВыбранноеЗначение = НСтр("ru = '<ввести произвольный текст>';
										|en = '<enter custom text>'") Тогда
		Объект.Пункт = "";
	Иначе
		Объект.Пункт = ВыбранноеЗначение;
	КонецЕсли;
	
	ПунктПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеВыбораПункта(ВыбранноеЗначение, ДополнительныеПараметры) Экспорт
	
	Если ВыбранноеЗначение = Неопределено Тогда
		Возврат;
	КонецЕсли;
	Объект.Пункт = ВыбранноеЗначение;	
	ПунктПриИзмененииНаСервере();
	
КонецПроцедуры

#КонецОбласти
