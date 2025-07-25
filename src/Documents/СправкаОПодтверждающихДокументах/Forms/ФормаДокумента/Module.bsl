
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПриЧтенииСозданииНаСервере();
	КонецЕсли;
	
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ИнтеграцияС1СДокументооборотом
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Объект", Объект);
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтаФорма, ДополнительныеПараметры);
	
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
	
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	ПриЧтенииСозданииНаСервере();
	
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	СобытияФорм.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтаФорма, Отказ, ПроверяемыеРеквизиты);
	
	Если Не ПереключательСписка Тогда
		ДокументОбъект = РеквизитФормыВЗначение("Объект");
		ДокументОбъект.ДополнительныеСвойства.Вставить("ПодтверждающиеДокументыБезРазбиения", Истина);
		
		Если Не ДокументОбъект.ПроверитьЗаполнение() Тогда
			Отказ = Истина;
		КонецЕсли;
		
		ПроверяемыеРеквизиты.Очистить();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	
	// СтандартныеПодсистемы.РаботаСФайлами
	РаботаСФайламиКлиент.ПриОткрытии(ЭтотОбъект, Отказ);
	// Конец СтандартныеПодсистемы.РаботаСФайлами

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект);
	
	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);
	// Конец ИнтеграцияС1СДокументооборотом
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтаФорма, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	
	Если ИмяСобытия = "Запись_Файл" Тогда
		ОбновитьНадписьФайлыДляПередачиВБанк();
	КонецЕсли;
	
	СобытияФормКлиент.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	
	// СтандартныеПодсистемы.РаботаСФайлами
	РаботаСФайламиКлиент.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия);
	// Конец СтандартныеПодсистемы.РаботаСФайлами

КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Запись_СправкаОПодтверждающихДокументах", ПараметрыЗаписи, Объект.Ссылка);
	
	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульПодключаемыеКомандыКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ПодключаемыеКомандыКлиент");
		МодульПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДоговорПриИзменении(Элемент)
	
	ДоговорПриИзмененииНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ДоговорПриИзмененииНаСервере()
	
	Если ЗначениеЗаполнено(Объект.Договор) Тогда
		Объект.Контрагент = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.Договор, "Контрагент");
	Иначе
		Объект.Контрагент = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПереключательСпискаПриИзменении(Элемент)
	
	Если Не ПереключательСписка Тогда
		Если Объект.ПодтверждающиеДокументы.Количество() = 0 Тогда
			НоваяСтрока = Объект.ПодтверждающиеДокументы.Добавить();
			Элементы.ПодтверждающиеДокументы.ТекущаяСтрока = НоваяСтрока.ПолучитьИдентификатор();
		ИначеЕсли Объект.ПодтверждающиеДокументы.Количество() = 1 Тогда
			Если Элементы.ПодтверждающиеДокументы.ТекущаяСтрока = Неопределено Тогда
				Элементы.ПодтверждающиеДокументы.ТекущаяСтрока = Объект.ПодтверждающиеДокументы[0].ПолучитьИдентификатор();
				ПодтверждающийДокументЗаполнен = ЗначениеЗаполнено(Объект.ПодтверждающиеДокументы[0].ПодтверждающийДокумент);
				Корректировка = Объект.ПодтверждающиеДокументы[0].ПризнакКорректировки;
				НастроитьЗависимыеЭлементыФормы();
			КонецЕсли;
		ИначеЕсли Объект.ПодтверждающиеДокументы.Количество() > 1 Тогда
			ОчиститьСообщения();
			ТекстСообщения = НСтр("ru = 'Переключение в режим без разбиения невозможно, если в списке подтверждающих документов введено более одной строки!';
									|en = 'Cannot switch to no split mode if more than one line is entered into the list of justification documents.'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
			ПереключательСписка = 1;
		КонецЕсли;
	КонецЕсли;
	
	Если ПереключательСписка Тогда
		Элементы.СтраницыПодтверждающиеДокументы.ТекущаяСтраница = Элементы.СтраницаСписком;
	Иначе
		Элементы.СтраницыПодтверждающиеДокументы.ТекущаяСтраница = Элементы.СтраницаБезРазбиения;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НадписьФайлыДляПередачиВБанкНажатие(Элемент)
	
	ДенежныеСредстваКлиентЛокализация.ОткрытьФормуСпискаФайловДляПередачиВБанк(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТабличнойЧасти

&НаКлиенте
Процедура ПодтверждающиеДокументыБезРазбиенияПодтверждающийДокументПриИзменении(Элемент)
	
	СтрокаТЧ = Объект.ПодтверждающиеДокументы[0];
	
	ПодтверждающийДокументЗаполнен = ЗначениеЗаполнено(СтрокаТЧ.ПодтверждающийДокумент);
	Если ПодтверждающийДокументЗаполнен Тогда
		СтрокаТЧ.НомерДокумента = Неопределено;
		СтрокаТЧ.ДатаДокумента = Неопределено;
		ПодтверждающиеДокументыБезРазбиенияПодтверждающийДокументПриИзмененииНаСервере();
	КонецЕсли;
	
	НастроитьЗависимыеЭлементыФормы("ПодтверждающийДокументЗаполнен");
	
КонецПроцедуры

&НаКлиенте
Процедура ПодтверждающиеДокументыБезРазбиенияПризнакКорректировкиПриИзменении(Элемент)
	
	СтрокаТЧ = Объект.ПодтверждающиеДокументы[0];
	
	Корректировка = СтрокаТЧ.ПризнакКорректировки;
	
	НастроитьЗависимыеЭлементыФормы("Корректировка");
	
КонецПроцедуры

&НаСервере
Процедура ПодтверждающиеДокументыБезРазбиенияПодтверждающийДокументПриИзмененииНаСервере()
	
	СтрокаТЧ = Объект.ПодтверждающиеДокументы[0];
	
	Реквизиты = СтрокаТЧ.ПодтверждающийДокумент.Метаданные().Реквизиты;
	Если Реквизиты.Найти("СуммаДокумента") <> Неопределено И Реквизиты.Найти("Валюта") <> Неопределено Тогда
		РеквизитыДокумента = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
			СтрокаТЧ.ПодтверждающийДокумент, Новый Структура("СуммаДокумента, ВалютаДокумента",, "Валюта"));
		ЗаполнитьЗначенияСвойств(СтрокаТЧ, РеквизитыДокумента);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПодтверждающиеДокументыБезРазбиенияКодВидаДокументаПриИзменении(Элемент)
	
	ЗначениеКода = Объект.ПодтверждающиеДокументы[0].КодВидаДокумента;
	
	Если ЗначениеЗаполнено(ЗначениеКода) Тогда
		Элементы.ПодтверждающиеДокументыБезРазбиенияКодВидаДокумента.Подсказка =
			Сред(СписокКодовВидаДокумента.НайтиПоЗначению(ЗначениеКода).Представление, СтрДлина(ЗначениеКода) + 4);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

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
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

// ЭлектронноеВзаимодействие.ОбменСКонтрагентами

&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуЭДО(Команда)
	ЭлектронноеВзаимодействиеКлиент.ВыполнитьПодключаемуюКомандуЭДО(Команда, ЭтаФорма, Объект);
КонецПроцедуры

// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами

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
	
	НастройкиПолейФормы = Документы.СправкаОПодтверждающихДокументах.НастройкиПолейФормы();
	ЗначениеВРеквизитФормы(НастройкиПолейФормы, "НастройкиПолей");
	ЗависимостиПолейФормы = ДенежныеСредстваСервер.ЗависимостиПолейФормы(НастройкиПолейФормы);
	ЗначениеВРеквизитФормы(ЗависимостиПолейФормы, "ЗависимостиПолей");
	
	ОбновитьНадписьФайлыДляПередачиВБанк();
	
	ДенежныеСредстваСервер.ИнициализироватьТабличнуюЧасть(ЭтаФорма, "ПодтверждающиеДокументы", ПереключательСписка);
	
	Если ПереключательСписка Тогда
		Элементы.СтраницыПодтверждающиеДокументы.ТекущаяСтраница = Элементы.СтраницаСписком;
	Иначе
		Элементы.СтраницыПодтверждающиеДокументы.ТекущаяСтраница = Элементы.СтраницаБезРазбиения;
	КонецЕсли;
	
	ЗаполнитьСписокКодовВидаДокумента();
	Элементы.ПодтверждающиеДокументыБезРазбиенияКодВидаДокумента.СписокВыбора.Очистить();
	Элементы.ПодтверждающиеДокументыКодВидаДокумента.СписокВыбора.Очистить();
	Для каждого ЭлементСписка Из СписокКодовВидаДокумента Цикл
		Элементы.ПодтверждающиеДокументыБезРазбиенияКодВидаДокумента.СписокВыбора.Добавить(ЭлементСписка.Значение,
			?(СтрДлина(ЭлементСписка.Представление) > 100, Лев(ЭлементСписка.Представление, 100) + "...", ЭлементСписка.Представление));
		Элементы.ПодтверждающиеДокументыКодВидаДокумента.СписокВыбора.Добавить(ЭлементСписка.Значение,
			?(СтрДлина(ЭлементСписка.Представление) > 100, Лев(ЭлементСписка.Представление, 100) + "...", ЭлементСписка.Представление));
	КонецЦикла;
	
	Если Не ПереключательСписка
		И Объект.ПодтверждающиеДокументы.Количество() = 1 Тогда
		
		ПодтверждающийДокументЗаполнен = ЗначениеЗаполнено(Объект.ПодтверждающиеДокументы[0].ПодтверждающийДокумент);
		Корректировка = Объект.ПодтверждающиеДокументы[0].ПризнакКорректировки;
		
		КодВидаДокумента = Объект.ПодтверждающиеДокументы[0].КодВидаДокумента;
		Если ЗначениеЗаполнено(КодВидаДокумента) Тогда
			Элементы.ПодтверждающиеДокументыБезРазбиенияКодВидаДокумента.Подсказка =
				Сред(СписокКодовВидаДокумента.НайтиПоЗначению(КодВидаДокумента).Представление, СтрДлина(КодВидаДокумента) + 4);
		КонецЕсли;
	КонецЕсли;
	
	СписокРеквизитов = Новый Массив;
	Для каждого Элемент Из Метаданные.Документы.СправкаОПодтверждающихДокументах.ТабличныеЧасти.ПодтверждающиеДокументы.Реквизиты Цикл
		СписокРеквизитов.Добавить(Элемент.Имя);
	КонецЦикла;
	РеквизитыТаблицыПодтверждающихДокументов = СтрСоединить(СписокРеквизитов, ",");
	
	НастроитьЗависимыеЭлементыФормыНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокКодовВидаДокумента()
	
	СписокКодовВидаДокумента.Очистить();
	СписокКодовВидаДокумента.Добавить("01_3", "01_3 - " + НСтр("ru = 'О вывозе с территории Российской Федерации товаров с оформлением декларации на товары или документов, указанных в подпункте 9.1.1 пункта 9.1 настоящей Инструкции, за исключением документов с кодом 03_3';
																|en = 'On goods import into the territory of the Russian Federation with the registered goods declaration or documents specified in subclause 9.1.1 of clause 9.1 of the present Instruction, other than documents with code 03_3'"));
	СписокКодовВидаДокумента.Добавить("01_4", "01_4 - " + НСтр("ru = 'О ввозе на территорию Российской Федерации товаров с оформлением декларации на товары или документов, указанных в подпункте 9.1.1 пункта 9.1 настоящей Инструкции, за исключением документов с кодом 03_4';
																|en = 'On goods import into the territory of the Russian Federation with the registered goods declaration or documents specified in subclause 9.1.1 of clause 9.1 of the present Instruction, other than documents with code 03_4'"));
	СписокКодовВидаДокумента.Добавить("02_3", "02_3 - " + НСтр("ru = 'Об отгрузке (передаче покупателю, перевозчику) товаров при их вывозе с территории Российской Федерации без оформления декларации на товары или документов, указанных в подпункте 9.1.1 пункта 9.1 настоящей Инструкции, за исключением документов с кодом 03_3';
																|en = 'On goods shipment (transfer by a seller or carrier) during their export from the territory of the Russian Federation without the registered goods declaration or documents specified in subclause 9.1.1 of clause 9.1 of the present Instruction, other than documents with code 03_3'"));
	СписокКодовВидаДокумента.Добавить("02_4", "02_4 - " + НСтр("ru = 'О получении (передаче продавцом, перевозчиком) товаров при их ввозе на территорию Российской Федерации без оформления декларации на товары или документов, указанных в подпункте 9.1.1 пункта 9.1 настоящей Инструкции, за исключением документов с кодом 03_4';
																|en = 'On goods receipt (transfer by a seller or carrier) during their import into the territory of the Russian Federation without the registered goods declaration or documents specified in subclause 9.1.1 of clause 9.1 of the present Instruction, other than documents with code 03_4'"));
	СписокКодовВидаДокумента.Добавить("03_3", "03_3 - " + НСтр("ru = 'О передаче резидентом товаров и оказании услуг нерезиденту по контрактам, указанным в подпункте 5.1.2 пункта 5.1 настоящей Инструкции';
																|en = 'On transferring goods and providing services by a resident to a non-resident under the contracts specified in paragraph 5.1 subparagraph 5.1.2 of the present Instruction'"));
	СписокКодовВидаДокумента.Добавить("03_4", "03_4 - " + НСтр("ru = 'О получении резидентом товаров и услуг от нерезидента по контрактам, указанным в подпункте 5.1.2 пункта 5.1настоящей Инструкции';
																|en = 'On receiving goods and services by a resident from a non-resident under the contracts specified in paragraph 5.1 subparagraph 5.1.2 of the present Instruction'"));
	СписокКодовВидаДокумента.Добавить("04_3", "04_3 - " + НСтр("ru = 'О выполненных резидентом работах, оказанных услугах, переданных информации и результатах интеллектуальной деятельности, в том числе исключительных прав на них, о переданном резидентом в аренду движимом и (или) недвижимом имуществе, за исключением документов с кодами 03_3 и 15_3';
																|en = 'On works performed by a resident, services provided, information and intellectual activity results transferred, including the exclusive rights to these results, as well as on movable property and (or) real estate rented out by the resident, except for documents with codes 03_3 and 15_3'"));
	СписокКодовВидаДокумента.Добавить("04_4", "04_4 - " + НСтр("ru = 'О выполненных нерезидентом работах оказанных услугах, переданных информации и результатах интеллектуальной деятельности, в том числе исключительных прав на них, о переданном нерезидентом в аренду движимом и (или) недвижимом имуществе, за исключением документов с кодами 03_4 и 15_4';
																|en = 'On works performed by a non-resident, services provided, information and intellectual activity results transferred, including the exclusive rights to these results, as well as on movable property and (or) real estate rented out by the non-resident, except for documents with codes 03_4 and 15_4'"));
	СписокКодовВидаДокумента.Добавить("05_3", "05_3 - " + НСтр("ru = 'О прощении резидентом долга(основной долг) нерезиденту по кредитному договору';
																|en = 'On forgiveness of non-resident debt (principal debt) under the credit contract by a resident'"));
	СписокКодовВидаДокумента.Добавить("05_4", "05_4 - " + НСтр("ru = 'О прощении нерезидентом долга (основной долг) резиденту по кредитному договору';
																|en = 'On forgiveness of resident debt (principal debt) under the credit contract by a non-resident'"));
	СписокКодовВидаДокумента.Добавить("06_3", "06_3 - " + НСтр("ru = 'О зачете встречных однородных требований, при котором обязательства нерезидента по возврату основного долга по кредитному договору прекращаются полностью или изменяются обязательства (снижается сумма основного долга)';
																|en = 'On setting off similar counter-complaints within which the non-resident obligations to repay the principal debt under the credit contract are completely terminated or changed (principal debt amount reduces)'"));
	СписокКодовВидаДокумента.Добавить("06_4", "06_4 - " + НСтр("ru = 'О зачете встречных однородных требований, при котором обязательства резидента по возврату основного долга по кредитному договору прекращаются полностью или изменяются обязательства (снижается сумма основного долга)';
																|en = 'On setting off similar counter-complaints within which the resident obligations to repay the principal debt under the credit contract are completely terminated or changed (principal debt amount reduces)'"));
	СписокКодовВидаДокумента.Добавить("07_3", "07_3 - " + НСтр("ru = 'Об уступке резидентом требования к должнику-нерезиденту по возврату основного долга по кредитному договору иному лицу - нерезиденту способом, отличным от расчетов';
																|en = 'On resident''s cession of demand to a non-resident debtor of principal debt refund under the loan agreement in favor of another non-resident otherwise than by settlements'"));
	СписокКодовВидаДокумента.Добавить("07_4", "07_4 - " + НСтр("ru = 'Об уступке нерезидентом требования к должнику-резиденту по возврату основного долга по кредитному договору в пользу иного лица - резидента способом, отличным от расчетов';
																|en = 'On cession of demand of a non-resident to a resident debtor of principal debt refund under the loan agreement in favor of another resident in a way different from settlements'"));
	СписокКодовВидаДокумента.Добавить("08_3", "08_3 - " + НСтр("ru = 'О переводе нерезидентом своего долга по возврату основного долга по кредитному договору на иное лицо - резидента способом, отличным от расчетов';
																|en = 'On transferring the non-resident obligation to repay the principal debt under the credit contract to another person - a resident otherwise than by settlements'"));
	СписокКодовВидаДокумента.Добавить("08_4", "08_4 - " + НСтр("ru = 'О переводе резидентом своего долга по возврату основного долга по кредитному договору на иное лицо - нерезидента способом, отличным от расчетов';
																|en = 'On transferring the resident obligation to repay the principal debt under the credit contract to another person - a non-resident otherwise than by settlements'"));
	СписокКодовВидаДокумента.Добавить("09_3", "09_3 - " + НСтр("ru = 'О прекращении обязательств или об изменении (снижении суммы) обязательств нерезидента по кредитному договору в связи с новацией (заменой первоначального обязательства должника-нерезидента другим обязательством), за исключением новации, осуществляемой посредством передачи должником-нерезидентом резиденту векселя или иных ценных бумаг';
																|en = 'On termination or change (amount decrease) of non-resident obligations  under the credit contract due to the novation (replacement of the initial non-resident debtor obligation by another obligation), except for the novation within which the non-resident debtor transfers a bill of exchange or other securities to a resident'"));
	СписокКодовВидаДокумента.Добавить("09_4", "09_4 - " + НСтр("ru = 'О прекращении обязательств или об изменении (снижении суммы) обязательств резидента по кредитному договору в связи с новацией (заменой первоначального обязательства должника-резидента другим обязательством), за исключением новации, осуществляемой посредством передачи должником-резидентом нерезиденту векселя или иных ценных бумаг';
																|en = 'On termination or change (amount decrease) of resident obligations  under the credit contract due to the novation (replacement of the initial resident debtor obligation by another obligation), except for the novation within which the resident debtor transfers a bill of exchange or other securities to a non-resident'"));
	СписокКодовВидаДокумента.Добавить("10_3", "10_3 - " + НСтр("ru = 'О прекращении обязательств или об изменении (снижении суммы) обязательств нерезидента, связанных с оплатой товаров (работ, услуг, переданных информации и результатов интеллектуальной деятельности, в том числе исключительных прав на них, с арендой движимого и (или) недвижимого имущества ) по контракту или с возвратом нерезидентом основного долга по кредитному договору посредством передачи нерезидентом резиденту векселя или иных ценных бумаг';
																|en = 'On termination or change (amount decrease) of non-resident liabilities  related to payment of goods (works, services, transferred information and intellectual activity results, including exclusive rights to them), lease of movable and real property under the contract or repayment of principal debt under the credit contract due to transfer of a bill of exchange or other securities from the non-resident to a resident'"));
	СписокКодовВидаДокумента.Добавить("10_4", "10_4 - " + НСтр("ru = 'О прекращении обязательств или об изменении (снижении суммы) обязательств резидента, связанных с оплатой товаров (работ, услуг, переданной информации и результатов интеллектуальной деятельности, в том числе исключительных прав на них, с арендой движимого и (или) недвижимого имущества) по контракту или с возвратом резидентом основного долга по кредитному договору посредством передачи резидентом нерезиденту векселя или иных ценных бумаг';
																|en = 'On termination or change (amount decrease) of resident liabilities  related to payment of goods (works, services, transferred information and intellectual activity results, including exclusive rights to them), lease of movable and real property under the contract or repayment of principal debt under the credit contract due to transfer of a bill of exchange or other securities from the resident to a non-resident'"));
	СписокКодовВидаДокумента.Добавить("11_3", "11_3 - " + НСтр("ru = 'О полном или частичном исполнении обязательств по возврату основного долга нерезидента по кредитному договору иным лицом-резидентом';
																|en = 'On partial or complete fulfillment of obligations to repay the non-resident principal debt under the credit contract by another person which is a resident'"));
	СписокКодовВидаДокумента.Добавить("11_4", "11_4 - " + НСтр("ru = 'О полном или частичном исполнении обязательств по возврату основного долга резидента по кредитному договору третьим лицом-нерезидентом';
																|en = 'On partial or complete fulfillment of obligations to repay the resident principal debt under the credit contract by a third party which is a non-resident'"));
	СписокКодовВидаДокумента.Добавить("12_3", "12_3 - " + НСтр("ru = 'Об изменении обязательств (увеличении задолженности по основному долгу) резидента перед нерезидентом по кредитному договору';
																|en = 'On change of resident obligations (principal debt increase) to a non-resident under the credit contract'"));
	СписокКодовВидаДокумента.Добавить("12_4", "12_4 - " + НСтр("ru = 'Об изменении обязательств (увеличении задолженности по основному долгу) нерезидента перед резидентом по кредитному договору';
																|en = 'On change of non-resident obligations (principal debt increase) to a resident under the credit contract'"));
	СписокКодовВидаДокумента.Добавить("13_3", "13_3 - " + НСтр("ru = 'Об иных способах исполнения (изменения, прекращения) обязательств нерезидента перед резидентом по контракту (кредитному договору), включая возврат нерезидентом ранее полученных товаров, за исключением иных кодов видов подтверждающих документов, указанных в настоящей таблице';
																|en = 'On other methods of fulfillment (change, termination) of non-resident liabilities to a resident under the contract (credit contract), including return of goods previously received by a non-resident, except for other kind codes of justification documents specified in the present table'"));
	СписокКодовВидаДокумента.Добавить("13_4", "13_4 - " + НСтр("ru = 'Об иных способах исполнения (изменения, прекращения) обязательств резидента перед нерезидентом по контракту (кредитному договору), включая возврат резидентом ранее полученных товаров, за исключением иных кодов видов подтверждающих документов, указанных в настоящей таблице';
																|en = 'On other methods of fulfillment (termination, end) of resident liabilities to a non-resident under the contract (credit contract), including return of goods previously received by a resident, except for other kind codes of justification documents specified in the present table'"));
	СписокКодовВидаДокумента.Добавить("15_3", "15_3 - " + НСтр("ru = 'О переданном резидентом в финансовую аренду (лизинг) имуществе';
																|en = 'On fixed asset transferred by a resident to financial lease'"));
	СписокКодовВидаДокумента.Добавить("15_4", "15_4 - " + НСтр("ru = 'О переданном нерезидентом в финансовую аренду (лизинг) имуществе';
																|en = 'On fixed asset transferred by a non-resident to financial lease'"));
	СписокКодовВидаДокумента.Добавить("16_3", "16_3 - " + НСтр("ru = 'Об удержании банками банковских комиссий за перевод денежных средств, причитающихся резиденту по контракту (кредитному договору), либо из сумм возвращаемых денежных средств, ранее переведенных нерезиденту по контракту (кредитному договору)';
																|en = 'On bank fees charged by banks for transfer of funds due to a resident under the contract (credit contract) or from the refunded amounts previously transferred to a non-resident under the contract (credit contract)'"));
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаСервере
Процедура ОбновитьНадписьФайлыДляПередачиВБанк()
	
	Элементы.НадписьФайлыДляПередачиВБанк.Заголовок =
		ДенежныеСредстваСерверЛокализация.НадписьФайлыДляПередачиВБанк(Объект.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьЗависимыеЭлементыФормы(ИзмененныйРеквизит = "")
	
	ДенежныеСредстваКлиентСервер.НастроитьЭлементыФормы(ЭтаФорма, ИзмененныйРеквизит, РеквизитыФормы(ЭтаФорма));
	
КонецПроцедуры

&НаСервере
Процедура НастроитьЗависимыеЭлементыФормыНаСервере(ИзмененныйРеквизит = "")
	
	ДенежныеСредстваКлиентСервер.НастроитьЭлементыФормы(ЭтаФорма, ИзмененныйРеквизит, РеквизитыФормы(ЭтаФорма));
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция РеквизитыФормы(Форма)
	
	РеквизитыФормы = Новый Структура;
	РеквизитыФормы.Вставить("ПодтверждающийДокументЗаполнен");
	РеквизитыФормы.Вставить("Корректировка");
	
	ЗаполнитьЗначенияСвойств(РеквизитыФормы, Форма);
	
	Возврат РеквизитыФормы;
	
КонецФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	//
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ПодтверждающиеДокументыНомерДокумента.Имя);
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ПодтверждающиеДокументыДатаДокумента.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.ПодтверждающиеДокументы.ПодтверждающийДокумент");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	
	//
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ПодтверждающиеДокументыДатаДокумента.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.ПодтверждающиеДокументы.ПризнакКорректировки");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	
КонецПроцедуры

#КонецОбласти
