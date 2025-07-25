#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	// Обработчик подсистемы "Свойства"
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Объект", Объект);
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	ДополнительныеПараметры.Вставить("ОтложеннаяИнициализация", Истина);
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтаФорма, ДополнительныеПараметры);
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПриЧтенииСозданииНаСервере();
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ИнтеграцияС1СДокументооборотом
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	СформироватьСпискиВыбора();
	
	ЗаполнитьСписокОснований();
	
	Элементы.ГруппаКомментарий.Картинка = ОбщегоНазначенияКлиентСервер.КартинкаКомментария(Объект.Комментарий);
	
	// СтандартныеПодсистемы.РаботаСФайлами
	ПараметрыГиперссылки = РаботаСФайлами.ГиперссылкаФайлов();
	ПараметрыГиперссылки.Размещение = "КоманднаяПанель";
	РаботаСФайлами.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыГиперссылки);
	// Конец СтандартныеПодсистемы.РаботаСФайлами

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	Если ТипЗнч(Пользователи.АвторизованныйПользователь()) = Тип("СправочникСсылка.ВнешниеПользователи") Тогда
		Возврат;
	КонецЕсли;
	
	// Обработчик механизма "ДатыЗапретаИзменения"
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	ЗаполнитьЗависимыеОтДокументовОснованийРеквизитыФормы();
	
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	ПриЧтенииСозданииНаСервере();
	
	СобытияФорм.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	СобытияФормКлиент.ПередЗаписью(ЭтотОбъект, Отказ, ПараметрыЗаписи);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// Обработчик механизма "Свойства"
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
	
	Элементы.ГруппаКомментарий.Картинка = ОбщегоНазначенияКлиентСервер.КартинкаКомментария(Объект.Комментарий);
	
	ОбновитьИнформациюПоДокументамОснованиям();
	
	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Запись_ТаможеннаяДекларацияЭкспорт", ПараметрыЗаписи, Объект.Ссылка);
	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульПодключаемыеКомандыКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ПодключаемыеКомандыКлиент");
		МодульПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.РаботаСФайлами
	РаботаСФайламиКлиент.ПриОткрытии(ЭтотОбъект, Отказ);
	// Конец СтандартныеПодсистемы.РаботаСФайлами

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// Подсистема "Свойства"
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтаФорма, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	
	// СтандартныеПодсистемы.РаботаСФайлами
	РаботаСФайламиКлиент.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия);
	// Конец СтандартныеПодсистемы.РаботаСФайлами

КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтаФорма, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ОрганизацияПриИзмененииНаСервере();
	
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


// СтандартныеПодсистемы.РаботаСФайлами
&НаКлиенте
Процедура Подключаемый_КомандаПанелиПрисоединенныхФайлов(Команда)
	 РаботаСФайламиКлиент.КомандаУправленияПрисоединеннымиФайлами(ЭтотОбъект, Команда);
КонецПроцедуры
// Конец СтандартныеПодсистемы.РаботаСФайлами

// СтандартныеПодсистемы.РаботаСФайлами
&НаКлиенте
Процедура Подключаемый_ПолеПредпросмотраПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка)
	 РаботаСФайламиКлиент.ПолеПредпросмотраПроверкаПеретаскивания(ЭтотОбъект, Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка);
КонецПроцедуры
// Конец СтандартныеПодсистемы.РаботаСФайлами

// СтандартныеПодсистемы.РаботаСФайлами
&НаКлиенте
Процедура Подключаемый_ПолеПредпросмотраПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка)
	 РаботаСФайламиКлиент.ПолеПредпросмотраПеретаскивание(ЭтотОбъект, Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка);
КонецПроцедуры
// Конец СтандартныеПодсистемы.РаботаСФайлами

// СтандартныеПодсистемы.РаботаСФайлами
&НаКлиенте
Процедура Подключаемый_ПолеПредпросмотраНажатие(Элемент, СтандартнаяОбработка)
	 РаботаСФайламиКлиент.ПолеПредпросмотраНажатие(ЭтотОбъект, Элемент, СтандартнаяОбработка);
КонецПроцедуры
// Конец СтандартныеПодсистемы.РаботаСФайлами

&НаКлиенте
Процедура КодОперацииНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Заголовок",          НСтр("ru = 'Выбор кода операции';
														|en = 'Select an operation code'"));
	ПараметрыФормы.Вставить("ТаблицаЗначений",    КодыОперации);
	ПараметрыФормы.Вставить("СтруктураДляПоиска", Новый Структура("Код", Объект.КодОперации));
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыборКодаОперацииЗавершение", ЭтотОбъект);
	ОткрытьФорму("Обработка.ОбщиеОбъектыРеглОтчетности.Форма.ФормаВыбораЗначенияИзТаблицы",
		ПараметрыФормы,
		ЭтотОбъект,
		УникальныйИдентификатор, , ,
		ОписаниеОповещения,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
КонецПроцедуры

&НаКлиенте
Процедура ВыборКодаОперацииЗавершение(РезультатВыбора, ДопПараметры) Экспорт
	
	Если РезультатВыбора = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Объект.КодОперации = РезультатВыбора.Код;
	
КонецПроцедуры

&НаКлиенте
Процедура КодТСНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ПараметрВводаПоля = РегламентированнаяОтчетностьКлиентСервер.НайтиСвойстваПоказателя(ЭтаФорма, "КодТС");
	
	Если ПараметрВводаПоля <> Неопределено И ПараметрВводаПоля.ТаблицаЗначений.Количество() > 0 Тогда
		
		Показатель = ПараметрВводаПоля.Показатель;
		ТекстПриВыборе = ПараметрВводаПоля.ТекстПриВыборе;
		КопироватьДанныеФормы(ПараметрВводаПоля.ТаблицаЗначений, ТЗВыбора);
		
		ВвестиПоказатель("СопроводительныеДокументы", Показатель, ТекстПриВыборе, ТЗВыбора, СтандартнаяОбработка);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВидДокументаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ПараметрВводаПоля = РегламентированнаяОтчетностьКлиентСервер.НайтиСвойстваПоказателя(ЭтаФорма, "ВидДокумента");
	
	Если ПараметрВводаПоля <> Неопределено И ПараметрВводаПоля.ТаблицаЗначений.Количество() > 0 Тогда
		
		Показатель = ПараметрВводаПоля.Показатель;
		ТекстПриВыборе = ПараметрВводаПоля.ТекстПриВыборе;
		КопироватьДанныеФормы(ПараметрВводаПоля.ТаблицаЗначений, ТЗВыбора);
		
		ВвестиПоказатель("СопроводительныеДокументы", Показатель, ТекстПриВыборе, ТЗВыбора, СтандартнаяОбработка);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДокументыОснованияПредставлениеОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылка, СтандартнаяОбработка)
	
	Если НавигационнаяСсылка = "ПодобратьДокументыОснования" Тогда
		СтандартнаяОбработка = Ложь;
		ПодобратьДокументыОснования();
	ИначеЕсли НавигационнаяСсылка = "ИзменитьДокументыОснования" Тогда
		СтандартнаяОбработка = Ложь;
		ИзменитьДокументыОснования();
	КонецЕсли;
	
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

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры
// Конец ИнтеграцияС1СДокументооборотом

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

// СтандартныеПодсистемы.Свойства
&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
    УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

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

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.Свойства

&НаСервере
Процедура СвойстваВыполнитьОтложеннуюИнициализацию()
	УправлениеСвойствами.ЗаполнитьДополнительныеРеквизитыВФорме(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

// Конец СтандартныеПодсистемы.Свойства

#Область ПриИзмененииРеквизитов

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()
	
	ОчиститьДокументыОснования();
	
КонецПроцедуры

#КонецОбласти

#Область ДокументыОснования

&НаСервере
Процедура ЗаполнитьПараметрыТаможеннойДекларацииЭкспортПоОснованию()
	
	Если Объект.ДокументыОснования.Количество() > 0 Тогда
	
		ДокументОбъект = РеквизитФормыВЗначение("Объект");
		ДокументОбъект.ЗаполнитьПараметрыТаможеннойДекларацииЭкспортПоОснованию();
		ЗначениеВРеквизитФормы(ДокументОбъект, "Объект");
	
	КонецЕсли;
	
	ЗаполнитьЗависимыеОтДокументовОснованийРеквизитыФормы();
	
	ОбновитьИнформациюПоДокументамОснованиям();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьИнформациюПоДокументамОснованиям()
	
	МассивСтрок = Новый Массив;
	
	КоличествоДокументов = Объект.ДокументыОснования.Количество();
	
	Если КоличествоДокументов = 0 Тогда
		
		Если ЕстьПравоНаРедактирование Тогда
			
			МассивСтрок.Добавить(Новый ФорматированнаяСтрока(
				НСтр("ru = 'Не выбраны';
					|en = 'Not selected'"), ,
				WebЦвета.Кирпичный, ,
				"ПодобратьДокументыОснования"));
			
		Иначе
			
			МассивСтрок.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'Не выбраны';
																	|en = 'Not selected'"), , WebЦвета.Кирпичный));
			
		КонецЕсли;
		
	Иначе
		
		Если КоличествоДокументов = 1 Тогда
			
			ПервыйДокумент = Объект.ДокументыОснования[0].ДокументОснование;
			МассивСтрок.Добавить(Новый ФорматированнаяСтрока(
				Строка(ПервыйДокумент), , ЦветаСтиля.ГиперссылкаЦвет, , ПолучитьНавигационнуюСсылку(ПервыйДокумент)));
			
		Иначе
			
			ПредставлениеДокументов = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Всего документов: %1';
					|en = 'Total documents: %1'"),
				КоличествоДокументов);
			
			МассивСтрок.Добавить(Новый ФорматированнаяСтрока(
				ПредставлениеДокументов, , ЦветаСтиля.ГиперссылкаЦвет, , "ИзменитьДокументыОснования"));
			
		КонецЕсли;
		
		Если ЕстьПравоНаРедактирование Тогда
			
			МассивСтрок.Добавить("   ");
			МассивСтрок.Добавить(Новый ФорматированнаяСтрока(
				НСтр("ru = '<Подбор>';
					|en = '<Select>'"), ,
				ЦветаСтиля.ГиперссылкаЦвет, ,
				"ПодобратьДокументыОснования"));
			
		КонецЕсли;
		
	КонецЕсли;
	
	ДокументыОснованияПредставление = Новый ФорматированнаяСтрока(МассивСтрок);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьДокументыОснования()
	
	СтруктураПараметров = ПараметрыПодборДокументовОснований();
	
	СтруктураПараметров.Вставить("ТолькоПросмотр", Не ЕстьПравоНаРедактирование);
	
	Оповещение = Новый ОписаниеОповещения("ИзменитьДокументыОснованияЗавершение", ЭтаФорма);
	
	ОткрытьФорму("Документ.ТаможеннаяДекларацияЭкспорт.Форма.ФормаДокументыОснования",
		СтруктураПараметров,
		ЭтаФорма, , , ,
		Оповещение,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьДокументыОснованияЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		ОбработкаИзмененияСпискаДокументовОснований(Результат);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПодобратьДокументыОснования()
	
	СтруктураПараметров = ПараметрыПодборДокументовОснований();
	
	Оповещение = Новый ОписаниеОповещения("ПодобратьДокументыОснованияЗавершение", ЭтаФорма);
	
	ОткрытьФорму("Документ.ТаможеннаяДекларацияЭкспорт.Форма.ПодборОснований",
		СтруктураПараметров,
		ЭтаФорма, , , ,
		Оповещение,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодобратьДокументыОснованияЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		ОбработкаИзмененияСпискаДокументовОснований(Результат);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаИзмененияСпискаДокументовОснований(ИзмененныйСписокОснований)
	
	Если ОбщегоНазначенияКлиентСервер.СпискиЗначенийИдентичны(ИзмененныйСписокОснований, СписокОснований) 
		И ИзмененныйСписокОснований.Количество() = СписокОснований.Количество() Тогда
		Возврат;
	КонецЕсли;
	
	Модифицированность = Истина;
	
	Объект.ДокументыОснования.Очистить();
	Объект.ДокументОснование = Неопределено;
	
	СписокОснований = ИзмененныйСписокОснований;
	
	Если СписокОснований.Количество() > 0 Тогда
		
		Для Каждого СтрокаСписка Из СписокОснований Цикл
			СтрокаТаблицы = Объект.ДокументыОснования.Добавить();
			СтрокаТаблицы.ДокументОснование = СтрокаСписка.Значение;
		КонецЦикла;
		
		Если Не ЗначениеЗаполнено(Объект.ДокументОснование) Тогда 
			Объект.ДокументОснование = СтрокаТаблицы.ДокументОснование;
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(Объект.Организация) Тогда 
			Объект.Организация = Объект.ДокументОснование.Организация;
		КонецЕсли;
		
	КонецЕсли;
	
	ЗаполнитьПараметрыТаможеннойДекларацииЭкспортПоОснованию();
	
КонецПроцедуры

&НаКлиенте
Функция ПараметрыПодборДокументовОснований()
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("СписокПодобранныхОснований",  СписокОснований);
	СтруктураПараметров.Вставить("ТаможеннаяДекларацияЭкспорт", Объект.Ссылка);
	СтруктураПараметров.Вставить("Организация",     Объект.Организация);
	
	Возврат СтруктураПараметров;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьЗависимыеОтДокументовОснованийРеквизитыФормы()
	
	СписокОснований.Очистить();
	
	Если Объект.ДокументыОснования.Количество() > 0 Тогда
		
		ПервыйДокумент = Объект.ДокументыОснования[0].ДокументОснование;
		ТаблицаОснований = Объект.ДокументыОснования.Выгрузить();
		СписокОснований.ЗагрузитьЗначения(ТаблицаОснований.ВыгрузитьКолонку("ДокументОснование"));
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОчиститьДокументыОснования()
	
	Объект.ДокументОснование = Неопределено;
	Объект.ДокументыОснования.Очистить();
	
	ЗаполнитьЗависимыеОтДокументовОснованийРеквизитыФормы();
	ОбновитьИнформациюПоДокументамОснованиям();
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()
	
	ИспользоватьНесколькоОрганизаций     = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций");
	
	ЕстьПравоНаРедактирование = ПравоДоступа("Изменение", Метаданные.Документы.СчетФактураВыданный);
	
	ОбновитьИнформациюПоДокументамОснованиям();
	
КонецПроцедуры

&НаСервере
Процедура СформироватьСпискиВыбора()
	
	МакетСоставаПоказателей = Отчеты.РегламентированныйОтчетРеестрНДСПриложение5.ПолучитьМакет("СпискиВыбора2015Кв4");
	
	КоллекцияСписковВыбора = Новый Структура;
	Для Каждого Область Из МакетСоставаПоказателей.Области Цикл
		Если Область.ТипОбласти = ТипОбластиЯчеекТабличногоДокумента.Строки Тогда
			ВерхОбласти = Область.Верх;
			НизОбласти  = Область.Низ;
			Коды = Новый ТаблицаЗначений;
			Коды.Колонки.Добавить("Код");
			Коды.Колонки.Добавить("Название");
			Коды.Колонки.Добавить("РезультатПроверки");
			Для НомерСтроки = ВерхОбласти По НизОбласти Цикл
				КодПоказателя = СокрП(МакетСоставаПоказателей.Область(НомерСтроки, 1).Текст);
				Если КодПоказателя <> "###" Тогда
					НовСтрока = Коды.Добавить();
					НовСтрока.Код               = КодПоказателя;
					НовСтрока.Название          = СокрП(МакетСоставаПоказателей.Область(НомерСтроки, 2).Текст);
					НовСтрока.РезультатПроверки = СокрП(МакетСоставаПоказателей.Область(НомерСтроки, 3).Текст);
				КонецЕсли;
			КонецЦикла;
			КоллекцияСписковВыбора.Вставить(Область.Имя, Коды);
		КонецЕсли;
	КонецЦикла;
	
	Если КоллекцияСписковВыбора.Свойство("ВидыДокумента") Тогда
		СписокВыбора = Элементы.ВидДокумента.СписокВыбора;
		СписокВыбора.Очистить();
		Для Каждого ВидДокумента Из КоллекцияСписковВыбора.ВидыДокумента Цикл
			Если НЕ ЗначениеЗаполнено(ВидДокумента.Код) Тогда
				Продолжить;
			КонецЕсли;
			СписокВыбора.Добавить(ВидДокумента.Код, ВидДокумента.Код + " - " + ВидДокумента.Название);
		КонецЦикла;
	КонецЕсли;
	
	Если КоллекцияСписковВыбора.Свойство("КодыВидаТС") Тогда
		СписокВыбора = Элементы.КодТС.СписокВыбора;
		СписокВыбора.Очистить();
		Для Каждого КодТС Из КоллекцияСписковВыбора.КодыВидаТС Цикл
			Если НЕ ЗначениеЗаполнено(КодТС.Код) Тогда
				Продолжить;
			КонецЕсли;
			СписокВыбора.Добавить(КодТС.Код, КодТС.Код + " - " + КодТС.Название);
		КонецЦикла;
	КонецЕсли;
	
	Если КоллекцияСписковВыбора.Свойство("КодыОпераций") Тогда
		Для Каждого КодОперации Из КоллекцияСписковВыбора.КодыОпераций Цикл
			Если НЕ ЗначениеЗаполнено(КодОперации.Код) Тогда
				Продолжить;
			КонецЕсли;
			ЗаполнитьЗначенияСвойств(КодыОперации.Добавить(), КодОперации);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВвестиПоказатель(ИмяЭлемента, Показатель, ТекстВыбора, ТаблицаВыбора, СтандартнаяОбработка, КолонкаПоиска = "Код") Экспорт
	
	Если ТаблицаВыбора = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	
	ТекущаяСтрока = Неопределено;
	Если ТипЗнч(Объект[ИмяЭлемента]) = Тип("ДанныеФормыКоллекция") Тогда
		ТекущаяСтрока = Элементы[ИмяЭлемента].ТекущаяСтрока;
	КонецЕсли;
	
	Если ТекущаяСтрока = Неопределено Тогда
		ИсходноеЗначение = Объект[ИмяЭлемента];
	Иначе
		ИсходноеЗначение = Объект[ИмяЭлемента][ТекущаяСтрока][Показатель];
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Заголовок",          ТекстВыбора);
	ПараметрыФормы.Вставить("ТаблицаЗначений",    ТаблицаВыбора);
	ПараметрыФормы.Вставить("СтруктураДляПоиска", Новый Структура(КолонкаПоиска, ИсходноеЗначение));
	
	ДополнительныеПараметры = Новый Структура("Показатель, КолонкаПоиска, ИмяЭлемента, ТекущаяСтрока");
	ДополнительныеПараметры.Показатель = Показатель;
	ДополнительныеПараметры.КолонкаПоиска = КолонкаПоиска;
	ДополнительныеПараметры.ИмяЭлемента = ИмяЭлемента;
	Если ТекущаяСтрока <> Неопределено Тогда
		ДополнительныеПараметры.ТекущаяСтрока = Элементы[ИмяЭлемента].ТекущаяСтрока;
	КонецЕсли;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ВвестиПоказательЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	ОткрытьФорму("Обработка.ОбщиеОбъектыРеглОтчетности.Форма.ФормаВыбораЗначенияИзТаблицы", ПараметрыФормы, ЭтаФорма,,,, ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ВвестиПоказательЗавершение(РезультатВыбора, ДополнительныеПараметры) Экспорт
	
	Показатель = ДополнительныеПараметры.Показатель;
	КолонкаПоиска = ДополнительныеПараметры.КолонкаПоиска;
	ИмяЭлемента = ДополнительныеПараметры.ИмяЭлемента;
	ТекущаяСтрока = ДополнительныеПараметры.ТекущаяСтрока;
	
	Если РезультатВыбора = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Модифицированность = Истина;
	Если ТипЗнч(Объект[ИмяЭлемента]) = Тип("ДанныеФормыКоллекция") Тогда
		Объект[ИмяЭлемента][ТекущаяСтрока][Показатель] = РезультатВыбора[КолонкаПоиска];
	Иначе
		Объект[ИмяЭлемента] = РезультатВыбора[КолонкаПоиска];
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СтраницыПриСменеСтраницы(Элемент, ТекущаяСтраница)
	
	// СтандартныеПодсистемы.Свойства
	Если ТекущаяСтраница.Имя = "ГруппаДополнительныеРеквизиты"
		И Не ЭтотОбъект.ПараметрыСвойств.ВыполненаОтложеннаяИнициализация Тогда
		СвойстваВыполнитьОтложеннуюИнициализацию();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокОснований()
	
	СписокОснований.Очистить();
	Для каждого Строка Из Объект.ДокументыОснования Цикл
		СписокОснований.Добавить(Строка.ДокументОснование);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
