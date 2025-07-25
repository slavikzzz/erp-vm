
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Склад     = Параметры.Склад;
	Помещение = Параметры.Помещение;
	
	ОбновитьДанныеФормы();

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОформитьМеню("Заблокированные");
	
	СформироватьПредставлениеОтбораСклад();
	СформироватьПредставлениеОтбораПомещение();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ВРег(ИсточникВыбора.ИмяФормы) = ВРег("Справочник.Склады.Форма.ФормаВыбораМРМ") Тогда
		
		Склад = ВыбранноеЗначение;
		Помещение = Неопределено;
		СформироватьПредставлениеОтбораСклад();
		СформироватьПредставлениеОтбораПомещение();
		ОбновитьДанныеФормы();
		
	КонецЕсли;
	
	Если ВРег(ИсточникВыбора.ИмяФормы) = ВРег("Справочник.СкладскиеПомещения.Форма.ФормаВыбораМРМ") Тогда
		
		Помещение = ВыбранноеЗначение;
		СформироватьПредставлениеОтбораПомещение();
		ОбновитьДанныеФормы();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПерейтиВРазделЗаблокированные(Команда)
	ОформитьМеню("Заблокированные");
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиВРазделВсеЯчейки(Команда)
	ОформитьМеню("ВсеЯчейки");
КонецПроцедуры

&НаКлиенте
Процедура ОтборыОткрытьСклад(Команда)
	
	ПараметрыОткрытияФормы = Новый Структура;
	ПараметрыОткрытияФормы.Вставить("РежимВыбора", Истина);
	ПараметрыОткрытияФормы.Вставить("МножественныйВыбор", Ложь);
	ПараметрыОткрытияФормы.Вставить("ЗакрыватьПриВыборе", Истина);
	ПараметрыОткрытияФормы.Вставить("ВыборГруппИЭлементов", ИспользованиеГруппИЭлементов.Элементы);
		
	ОткрытьФорму(
		"Справочник.Склады.Форма.ФормаВыбораМРМ",
		ПараметрыОткрытияФормы,
		ЭтаФорма,,,,,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры
	
&НаКлиенте
Процедура ОтборыОткрытьПомещение(Команда)
	
	ПараметрыОткрытияФормы = Новый Структура;
	ПараметрыОткрытияФормы.Вставить("РежимВыбора", Истина);
	ПараметрыОткрытияФормы.Вставить("МножественныйВыбор", Ложь);
	ПараметрыОткрытияФормы.Вставить("ЗакрыватьПриВыборе", Истина);
	
	Отбор = Новый Структура();
	Отбор.Вставить("Владелец", Склад);
	
	ПараметрыОткрытияФормы.Вставить("Отбор", Отбор);
	
	ОткрытьФорму(
		"Справочник.СкладскиеПомещения.Форма.ФормаВыбораМРМ",
		ПараметрыОткрытияФормы,
		ЭтаФорма,,,,,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);

КонецПроцедуры
	
&НаКлиенте
Процедура ОтборыОчиститьСклад(Команда)
	
	Склад = Неопределено;
	СформироватьПредставлениеОтбораСклад();
	СформироватьПредставлениеОтбораПомещение();
	ОбновитьДанныеФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборыОчиститьПомещение(Команда)

	Помещение = Неопределено;
	СформироватьПредставлениеОтбораПомещение();
	ОбновитьДанныеФормы(); 
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаблокированныеЯчейкиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Описание = Новый ОписаниеОповещения("ОбновитьФорму", ЭтаФорма);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Ячейка", Элементы.ЗаблокированныеЯчейки.ТекущиеДанные.Ячейка);
	ПараметрыФормы.Вставить("ТипБлокировки", Элементы.ЗаблокированныеЯчейки.ТекущиеДанные.ТипБлокировки);
	
	ОткрытьФорму(
	"Обработка.МобильноеРабочееМестоКладовщика.Форма.БлокировкаЯчейки",ПараметрыФормы,
	ЭтаФорма,,,,Описание,
	РежимОткрытияОкнаФормы.Независимый);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОформитьМеню(ИмяВкладки)
	
	Элементы.РамкаЗаблокированные.Картинка = БиблиотекаКартинок.РамкаМенюБелая;
	Элементы.КомандаЗаблокированные.ЦветТекста = WebЦвета.ТемноСерый;
	
	Элементы.РамкаВсеЯчейки.Картинка = БиблиотекаКартинок.РамкаМенюБелая;
	Элементы.КомандаВсеЯчейки.ЦветТекста = WebЦвета.ТемноСерый;
	
	Если ИмяВкладки = "Заблокированные" Тогда
		
		Элементы.КомандаЗаблокированные.ЦветТекста = WebЦвета.Черный;
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаЗаблокированные;
		Элементы.РамкаЗаблокированные.Картинка = БиблиотекаКартинок.РамкаМенюЧерная;
		
	ИначеЕсли ИмяВкладки = "ВсеЯчейки" Тогда
		
		Элементы.КомандаВсеЯчейки.ЦветТекста = WebЦвета.Черный;
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаВсеЯчейки;
		Элементы.РамкаВсеЯчейки.Картинка = БиблиотекаКартинок.РамкаМенюЧерная;
		
	КонецЕсли;
	
	СформироватьЗаголовкиКомандМеню();
	
КонецПроцедуры

&НаСервере
Процедура СформироватьЗаголовкиКомандМеню()
	Элементы.КомандаЗаблокированные.Заголовок = СтрШаблон(НСтр("ru = 'Заблокированные (%1)';
																|en = 'Blocked (%1)'"), ЗаблокированныеЯчейки.Количество());
	Элементы.КомандаВсеЯчейки.Заголовок = СтрШаблон(НСтр("ru = 'Все ячейки';
														|en = 'All storage bins'"));
КонецПроцедуры

&НаСервере
Процедура ОбновитьДанныеФормы()
	
	ЗаполнитьСписокЗаблокированныхЯчеек();
	
	Ячейки.Отбор.Элементы.Очистить();
	
	ЭлементОтбора = Ячейки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Владелец");
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбора.Использование = Истина;
	ЭлементОтбора.ПравоеЗначение = Склад;
	
	ЭлементОтбора = Ячейки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Помещение");
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбора.Использование = Истина;
	ЭлементОтбора.ПравоеЗначение = Помещение;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьФорму(Результат = Неопределено, ДополнительныеПараметры = Неопределено) Экспорт
	
	ОбновитьФормуНаСервере(Результат);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьФормуНаСервере(Результат = Неопределено)
	
	ОбновитьДанныеФормы();
	СформироватьПредставлениеОтбораСклад();
	СформироватьПредставлениеОтбораПомещение();
	СформироватьЗаголовкиКомандМеню();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокЗаблокированныхЯчеек()
	
	Запрос = Обработки.МобильноеРабочееМестоКладовщика.СписокБлокировок();
	
	Если НЕ Помещение.Пустая() Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "И &УсловиеПомещение", "И БлокировкиСкладскихЯчеек.Ячейка.Помещение = &Помещение");
		Запрос.УстановитьПараметр("Помещение", Помещение);
	Иначе
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "И &УсловиеПомещение", "");
	КонецЕсли;

	Запрос.УстановитьПараметр("Склад", Склад);
	
	ТаблицаБлокировок = Запрос.Выполнить().Выгрузить();
	
	ЗаблокированныеЯчейки.Загрузить(ТаблицаБлокировок);
	
	СформироватьЗаголовкиКомандМеню();

КонецПроцедуры

&НаСервере
Процедура СформироватьПредставлениеОтбораСклад()
	
	ПредставленияОтборов = "";
	Если ЗначениеЗаполнено(Склад) Тогда
		ПредставленияОтборов = Склад;
		Элементы.КомандаОтборыОткрыть.ЦветТекста = WebЦвета.Черный;
		Элементы.КомандаОтборыОчистить.Видимость = Истина;
		Элементы.РамкаОтборыОткрыть.Картинка = БиблиотекаКартинок.РамкаМенюЧерная;
	Иначе
		ПредставленияОтборов = НСтр("ru = 'Выбрать склад';
									|en = 'Select a warehouse'");
		Элементы.КомандаОтборыОткрыть.ЦветТекста = WebЦвета.ТемноСерый;
		Элементы.КомандаОтборыОчистить.Видимость = Ложь;
		Элементы.РамкаОтборыОткрыть.Картинка = БиблиотекаКартинок.РамкаМенюСерая;
	КонецЕсли;
	
	Если Склад["ЭтоГруппа"] = Истина Тогда
		ИспользоватьСкладскиеПомещения = Ложь;
	Иначе
		ИспользоватьСкладскиеПомещения = Склад["ИспользоватьСкладскиеПомещения"];
	КонецЕсли;
	Элементы.ГруппаКомандаОтборыОткрыть2.Видимость    = ИспользоватьСкладскиеПомещения;
	Элементы.КомандаОтборыОчиститьПомещение.Видимость = ИспользоватьСкладскиеПомещения;
	
	Элементы.КомандаОтборыОткрыть.Заголовок = ПредставленияОтборов;
	
КонецПроцедуры

&НаСервере
Процедура СформироватьПредставлениеОтбораПомещение()
	
	ПредставленияОтборов = "";
	Если ЗначениеЗаполнено(Помещение) Тогда
		ПредставленияОтборов = Помещение;
		Элементы.КомандаОтборыОткрытьПомещение.ЦветТекста = WebЦвета.Черный;
		Элементы.КомандаОтборыОчиститьПомещение.Видимость = Истина;
		Элементы.РамкаОтборыОткрыть2.Картинка = БиблиотекаКартинок.РамкаМенюЧерная;
	Иначе
		ПредставленияОтборов = НСтр("ru = 'Выбрать помещение';
									|en = 'Select a wareroom'");
		Элементы.КомандаОтборыОткрытьПомещение.ЦветТекста = WebЦвета.ТемноСерый;
		Элементы.КомандаОтборыОчиститьПомещение.Видимость = Ложь;
		Элементы.РамкаОтборыОткрыть2.Картинка = БиблиотекаКартинок.РамкаМенюСерая;
	КонецЕсли;
	
	Элементы.КомандаОтборыОткрытьПомещение.Заголовок = ПредставленияОтборов;
	
КонецПроцедуры

&НаКлиенте
Процедура Сканировать(Команда)
	
	СтандартнаяОбработка = Ложь;
	
	Описание = Новый ОписаниеОповещения("РезультатПоискаЯчейки", ЭтаФорма);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ТипПоиска", "ПоискЯчейки");
	ПараметрыФормы.Вставить("Склад", Склад);
	ПараметрыФормы.Вставить("Помещение", Помещение);
	
	ОткрытьФорму(
	"Обработка.МобильноеРабочееМестоКладовщика.Форма.СканированиеШтрихкода",ПараметрыФормы,
	ЭтаФорма,,,,Описание,
	РежимОткрытияОкнаФормы.Независимый);
	
КонецПроцедуры

&НаКлиенте
Процедура РезультатПоискаЯчейки(Результат = Неопределено, ДополнительныеПараметры = Неопределено) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Описание = Новый ОписаниеОповещения("ОбновитьФорму", ЭтаФорма);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Ячейка", Результат);
	ПараметрыФормы.Вставить("ТипБлокировки", Неопределено);
	
	ОткрытьФорму(
	"Обработка.МобильноеРабочееМестоКладовщика.Форма.БлокировкаЯчейки",ПараметрыФормы,
	ЭтаФорма,,,,Описание,
	РежимОткрытияОкнаФормы.Независимый);
	
КонецПроцедуры

&НаКлиенте
Процедура ЯчейкиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Описание = Новый ОписаниеОповещения("ОбновитьФорму", ЭтаФорма);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Ячейка", Элемент.ТекущаяСтрока);
	
	ОткрытьФорму(
	"Обработка.МобильноеРабочееМестоКладовщика.Форма.БлокировкаЯчейки",ПараметрыФормы,
	ЭтаФорма,,,,Описание,
	РежимОткрытияОкнаФормы.Независимый);

КонецПроцедуры

#КонецОбласти
