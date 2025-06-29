
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	УстановитьУсловноеОформление();
	
	УстановитьПараметрыСпискаДокументов();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НачалоПериодаПриИзменении(Элемент)
	УстановитьПараметрыСпискаДокументов();
КонецПроцедуры

&НаКлиенте
Процедура КонецПериодаПриИзменении(Элемент)
	УстановитьПараметрыСпискаДокументов();
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	УстановитьПараметрыСпискаДокументов();
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентПриИзменении(Элемент)
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		СписокДокументов, "Контрагент", Контрагент, ВидСравненияКомпоновкиДанных.Равно, , ЗначениеЗаполнено(Контрагент));
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписокДокументов

&НаКлиенте
Процедура СписокДокументовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.СписокДокументов.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено ИЛИ Поле = Элементы.СписокДокументовРегистратор Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеОперации = Новый Структура("Регистратор, Организация, ТипЗапасов,
		|Контрагент, КодОперации, ОтражениеВОтчетности, ВидДокумента, Расширенная");
	ЗаполнитьЗначенияСвойств(ДанныеОперации, ТекущиеДанные);
	
	АдресВХранилище = ПоместитьТаблицуРедактируемыхОперацийВХранилище(ДанныеОперации);
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("ДанныеОперации", ДанныеОперации);
	ПараметрыОткрытия.Вставить("АдресВХранилище", АдресВХранилище);
	
	ПараметрыОповещения = Новый Структура;
	ПараметрыОповещения.Вставить("Операция", Элементы.СписокДокументов.ТекущаяСтрока);
	ПараметрыОповещения.Вставить("АдресВХранилище", АдресВХранилище);
	
	ОткрытьФорму(
		"Обработка.ЖурналДокументовПрослеживаемости.Форма.РедактированиеОперации", ПараметрыОткрытия, ЭтотОбъект,,,,
		Новый ОписаниеОповещения("РедактированиеОперацииЗавершение", ЭтотОбъект, ПараметрыОповещения),
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура УстановитьПериод(Команда)
	
	Оповещение = Новый ОписаниеОповещения("УстановитьПериодЗавершение", ЭтотОбъект);
	
	ОбщегоНазначенияУТКлиент.РедактироватьПериод(
		ЭтотОбъект, Новый Структура("ДатаНачала, ДатаОкончания", "НачалоПериода", "КонецПериода"), Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПериодЗавершение(РезультатВыбора, ДопПараметры) Экспорт
	
	Если РезультатВыбора = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПараметрыСпискаДокументов();
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьКодОперации(Команда)
	
	ПараметрыОповещения = Новый Структура;
	ПараметрыОповещения.Вставить("ИмяРеквизита", "КодОперации");
	ПараметрыОповещения.Вставить("Операции", Элементы.СписокДокументов.ВыделенныеСтроки);
	
	ОписаниеОповещенияОЗакрытии = Новый ОписаниеОповещения(
		"ГрупповоеИзменениеОперацийЗавершение", ЭтотОбъект, ПараметрыОповещения);
	
	ОткрытьФорму("Справочник.КодыОперацийПрослеживаемости.ФормаВыбора",, ЭтотОбъект,,,,
		ОписаниеОповещенияОЗакрытии, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьВидДокумента(Команда)
	
	ПараметрыОповещения = Новый Структура;
	ПараметрыОповещения.Вставить("ИмяРеквизита", "ТипДокументаВПрослеживаемости");
	ПараметрыОповещения.Вставить("Операции", Элементы.СписокДокументов.ВыделенныеСтроки);
	
	ОписаниеОповещенияОЗакрытии = Новый ОписаниеОповещения(
		"ГрупповоеИзменениеОперацийЗавершение", ЭтотОбъект, ПараметрыОповещения);
	
	ОткрытьФорму("Справочник.ТипыДокументов.ФормаВыбора",, ЭтотОбъект,,,,
		ОписаниеОповещенияОЗакрытии, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьРучныеКорректировки(Команда)
	ОтменитьРучныеКорректировкиНаСервере();
	Элементы.СписокДокументов.Обновить();
КонецПроцедуры

&НаСервере
Процедура ОтменитьРучныеКорректировкиНаСервере()
	МассивДокументов = Новый Массив;
	Для Каждого СтрокаТаблицы Из Элементы.СписокДокументов.ВыделенныеСтроки Цикл
		МассивДокументов.Добавить(СтрокаТаблицы.Регистратор);
	КонецЦикла;
	ПрослеживаемостьУП.ОтменитьРучныеКорректировкиОпераций(МассивДокументов);
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьОтчетКнигаПокупок(Команда)
	
	ПараметрыОтчета = Новый Структура;
	ПараметрыОтчета.Вставить("Организация", Организация);
	ПараметрыОтчета.Вставить("НачалоПериода", НачалоПериода);
	ПараметрыОтчета.Вставить("КонецПериода", КонецПериода);
	
	ОткрытьФорму("Отчет.КнигаПокупок.ФормаОбъекта",
		Новый Структура("ПараметрыЗаполненияФормы", ПараметрыОтчета));
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьОтчетКнигаПродаж(Команда)
	
	ПараметрыОтчета = Новый Структура;
	ПараметрыОтчета.Вставить("Организация", Организация);
	ПараметрыОтчета.Вставить("НачалоПериода", НачалоПериода);
	ПараметрыОтчета.Вставить("КонецПериода", КонецПериода);
	
	ОткрытьФорму("Отчет.КнигаПродаж.ФормаОбъекта",
		Новый Структура("ПараметрыЗаполненияФормы", ПараметрыОтчета));
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьОтчетЖурналУчетаСчетовФактур(Команда)
	
	ПараметрыОтчета = Новый Структура;
	ПараметрыОтчета.Вставить("Организация", Организация);
	ПараметрыОтчета.Вставить("НачалоПериода", НачалоПериода);
	ПараметрыОтчета.Вставить("КонецПериода", КонецПериода);
	
	ОткрытьФорму("Отчет.ЖурналУчетаСчетовФактур.ФормаОбъекта",
		Новый Структура("ПараметрыЗаполненияФормы", ПараметрыОтчета));
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьОтчетДекларацияПоНДС(Команда)
	
	ВидОтчета = НСтр("ru = 'Декларация по НДС';
					|en = 'VAT declaration'");
	ОткрытьСписокРегламентированныхОтчетов(ВидОтчета);
		
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьОтчетОбОперацияхСТоварамиПодлежащимиПрослеживаемости(Команда)

	ВидОтчета = НСтр("ru = 'Отчет об операциях с товарами, подлежащими прослеживаемости';
					|en = 'Report on operations with goods to be traced'");
	ОткрытьСписокРегламентированныхОтчетов(ВидОтчета);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОткрытьСписокРегламентированныхОтчетов(Знач ВидОтчета)
	
	ПараметрыОткрытия = Новый Структура;
	Если НЕ ЗначениеЗаполнено(НачалоПериода) ИЛИ НЕ ЗначениеЗаполнено(КонецПериода) Тогда
		ТекущаяДата = ОбщегоНазначенияКлиент.ДатаСеанса();
		ПараметрыОткрытия.Вставить("НачалоПериода", НачалоГода(ТекущаяДата));
		ПараметрыОткрытия.Вставить("КонецПериода", КонецГода(ТекущаяДата));
	ИначеЕсли НачалоКвартала(НачалоПериода) = НачалоКвартала(КонецПериода) Тогда
		ПараметрыОткрытия.Вставить("НачалоПериода", НачалоКвартала(НачалоПериода));
		ПараметрыОткрытия.Вставить("КонецПериода", КонецКвартала(КонецПериода));
	Иначе
		ПараметрыОткрытия.Вставить("НачалоПериода", НачалоГода(НачалоПериода));
		ПараметрыОткрытия.Вставить("КонецПериода", КонецГода(КонецПериода));
	КонецЕсли;
	ПараметрыОткрытия.Вставить("ПериодОтчета", ПредставлениеПериода(ПараметрыОткрытия.НачалоПериода, ПараметрыОткрытия.КонецПериода, "ФП=Истина"));
	
	ПараметрыОткрытия.Вставить("Раздел",    ПредопределенноеЗначение("Перечисление.СтраницыЖурналаОтчетность.Отчеты"));
	ПараметрыОткрытия.Вставить("ВидОтчета", ВидОтчета);
	ПараметрыОткрытия.Вставить("Организация", Организация);
	
	Форма = ОткрытьФорму("ОбщаяФорма.РегламентированнаяОтчетность", ПараметрыОткрытия, , "1С-Отчетность");
	Форма.Организация = ПараметрыОткрытия.Организация;
	Форма.ПериодОтчета = ПараметрыОткрытия.ПериодОтчета;
	Форма.ВидОтчета = ПараметрыОткрытия.ВидОтчета;
	Форма.НачалоПериода = НачалоКвартала(НачалоПериода);
	Форма.КонецПериода = КонецКвартала(КонецПериода);
	
	ОтборДинамическогоСписка = Форма.Отчеты.КомпоновщикНастроек.Настройки.Отбор;
	ОтборДинамическогоСписка.Элементы.Очистить();
	
	ОтборВидОтчета        = ОтборДинамическогоСписка.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборОрганизация      = ОтборДинамическогоСписка.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборДатаНачала       = ОтборДинамическогоСписка.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборДатаОкончания1   = ОтборДинамическогоСписка.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборДатаОкончания2   = ОтборДинамическогоСписка.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	
	ОтборВидОтчета.ЛевоеЗначение      = Новый ПолеКомпоновкиДанных("НаименованиеОтчета");
	ОтборОрганизация.ЛевоеЗначение    = Новый ПолеКомпоновкиДанных("Организация");
	ОтборДатаНачала.ЛевоеЗначение     = Новый ПолеКомпоновкиДанных("ДатаНачала");
	ОтборДатаОкончания1.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДатаОкончания");
	ОтборДатаОкончания2.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДатаОкончания");
	
	Если НЕ ЗначениеЗаполнено(ПараметрыОткрытия.Организация) Тогда
		ОтборОрганизация.Использование = Ложь;
	Иначе
		ОтборОрганизация.Использование  = Истина;
		ОтборОрганизация.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
		ОтборОрганизация.ПравоеЗначение = ПараметрыОткрытия.Организация;
	КонецЕсли;
	
	ОтборВидОтчета.Использование  = Истина;
	ОтборВидОтчета.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ОтборВидОтчета.ПравоеЗначение = ПараметрыОткрытия.ВидОтчета;
	
	ОтборДатаНачала.Использование      = Истина;
	ОтборДатаНачала.ВидСравнения       = ВидСравненияКомпоновкиДанных.БольшеИлиРавно;
	ОтборДатаНачала.ПравоеЗначение     = НачалоГода(ПараметрыОткрытия.НачалоПериода);
	
	ОтборДатаОкончания1.Использование  = Истина;
	ОтборДатаОкончания1.ВидСравнения   = ВидСравненияКомпоновкиДанных.Больше;
	ОтборДатаОкончания1.ПравоеЗначение = ПараметрыОткрытия.НачалоПериода;
	
	ОтборДатаОкончания2.Использование  = Истина;
	ОтборДатаОкончания2.ВидСравнения   = ВидСравненияКомпоновкиДанных.МеньшеИлиРавно;
	ОтборДатаОкончания2.ПравоеЗначение = ПараметрыОткрытия.КонецПериода;
	
	ОтборДинамическогоСписка.ИдентификаторПользовательскойНастройки = Строка(Новый УникальныйИдентификатор);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	СтандартныеПодсистемыСервер.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "СписокДокументов.Дата");
	
	//
	
	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СписокДокументовОрганизация.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Организация");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено;

	Элемент.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);
	
	//
	
	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СписокДокументовКонтрагент.Имя);
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СписокДокументовКодОперации.Имя);
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СписокДокументовВидДокумента.Имя);
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СписокДокументовОтражениеВОтчетности.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СписокДокументов.Расширенная");
	ОтборЭлемента.ПравоеЗначение = Истина;

	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<Несколько значений>';
																|en = '<Multiple values>'"));
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаПодсказкиВвода);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьПараметрыСпискаДокументов()
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(СписокДокументов, "Организация", Организация);
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(СписокДокументов, "ПоВсемОрганизациям", НЕ ЗначениеЗаполнено(Организация));
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(СписокДокументов, "НачалоПериода", НачалоПериода);
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(СписокДокументов, "КонецПериода", ?(ЗначениеЗаполнено(КонецПериода), КонецПериода, КонецДня(Дата(3999, 12, 31))));
	
КонецПроцедуры

&НаСервере
Функция ПодготовитьТаблицуРедактируемыхОпераций(ДанныеОперации)
	
	Если ДанныеОперации.Расширенная Тогда
		НаборЗаписей = РегистрыСведений.ОперацииСПрослеживаемымиТоварамиРасширенный.СоздатьНаборЗаписей();
	Иначе
		НаборЗаписей = РегистрыСведений.ОперацииСПрослеживаемымиТоварами.СоздатьНаборЗаписей();
	КонецЕсли;
	НаборЗаписей.Отбор.Регистратор.Установить(ДанныеОперации.Регистратор);
	НаборЗаписей.Прочитать();
	
	ТаблицаОпераций = НаборЗаписей.Выгрузить();
	ТаблицаОпераций.Колонки.Добавить("ИдентификаторЗаписи", Новый ОписаниеТипов("УникальныйИдентификатор"));
	Если ДанныеОперации.Расширенная Тогда
		ТаблицаОпераций.Колонки.Добавить("ТипЗапасов", Новый ОписаниеТипов("ПеречислениеСсылка.ТипыЗапасов"));
	КонецЕсли;
	
	Если ДанныеОперации.Расширенная Тогда
	     ВидыЗапасовОпераций = ОбщегоНазначения.ЗначениеРеквизитаОбъектов(ТаблицаОпераций.ВыгрузитьКолонку("ВидЗапасов") ,"ТипЗапасов"); 
	КонецЕсли;	 
	
	Для Каждого СтрокаТаблицы Из ТаблицаОпераций Цикл
		СтрокаТаблицы.ИдентификаторЗаписи = Новый УникальныйИдентификатор;
		Если ДанныеОперации.Расширенная Тогда
			СтрокаТаблицы.ТипЗапасов = ВидыЗапасовОпераций[СтрокаТаблицы.ВидЗапасов];
		КонецЕсли;
	КонецЦикла;
	
	Возврат ТаблицаОпераций;
	
КонецФункции

&НаСервере
Функция ПоместитьТаблицуРедактируемыхОперацийВХранилище(ДанныеОперации)
	
	ТаблицаОпераций = ПодготовитьТаблицуРедактируемыхОпераций(ДанныеОперации);
	Возврат ПоместитьВоВременноеХранилище(ТаблицаОпераций, УникальныйИдентификатор);
	
КонецФункции

&НаКлиенте
Процедура РедактированиеОперацииЗавершение(Результат, СвойстваОперации) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	РедактированиеОперацииНаСервере(СвойстваОперации.Операция, Результат, СвойстваОперации.АдресВХранилище);
	
	Элементы.СписокДокументов.Обновить();
	
КонецПроцедуры

&НаСервере
Процедура РедактированиеОперацииНаСервере(Операция, ЗначенияРеквизитов, АдресВХранилище = "")
	
	Таблица = ПолучитьИзВременногоХранилища(АдресВХранилище);
	Для Каждого СтрокаТаблицы Из Таблица Цикл
		НовыеЗначения = ЗначенияРеквизитов[СтрокаТаблицы.ИдентификаторЗаписи];
		Если НовыеЗначения = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		ЗаполнитьЗначенияСвойств(СтрокаТаблицы, НовыеЗначения);
	КонецЦикла;
	
	НачатьТранзакцию();
	
	Попытка
		
		Блокировка = Новый БлокировкаДанных;
		
		Если Операция.Расширенная Тогда
			ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ОперацииСПрослеживаемымиТоварамиРасширенный.НаборЗаписей");
		Иначе
			ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ОперацииСПрослеживаемымиТоварами.НаборЗаписей");
		КонецЕсли;
		ЭлементБлокировки.УстановитьЗначение("Регистратор", Операция.Регистратор);
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
		Блокировка.Заблокировать();
		
		Если Операция.Расширенная Тогда
			НаборЗаписей = РегистрыСведений.ОперацииСПрослеживаемымиТоварамиРасширенный.СоздатьНаборЗаписей();
		Иначе
			НаборЗаписей = РегистрыСведений.ОперацииСПрослеживаемымиТоварами.СоздатьНаборЗаписей();
		КонецЕсли;
		НаборЗаписей.Отбор.Регистратор.Установить(Операция.Регистратор);
		НаборЗаписей.Загрузить(Таблица);
		НаборЗаписей.Записать();
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		ВызватьИсключение;
		
	КонецПопытки;
	
КонецПроцедуры

&НаКлиенте
Процедура ГрупповоеИзменениеОперацийЗавершение(Результат, ПараметрыРедактирования) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЗначенияРеквизитов = Новый Структура;
	ЗначенияРеквизитов.Вставить(ПараметрыРедактирования.ИмяРеквизита, Результат);
	ЗначенияРеквизитов.Вставить("РучноеРедактирование", Истина);
	
	ГрупповоеИзменениеОперацийНаСервере(ПараметрыРедактирования.Операции, ЗначенияРеквизитов);
	
	Элементы.СписокДокументов.Обновить();
	
КонецПроцедуры

&НаСервере
Процедура ГрупповоеИзменениеОперацийНаСервере(Операции, ЗначенияРеквизитов)
	
	Регистраторы = Новый ТаблицаЗначений;
	Регистраторы.Колонки.Добавить("Ссылка");
	
	Для Каждого Операция Из Операции Цикл
		Регистраторы.Добавить().Ссылка = Операция.Регистратор;
	КонецЦикла;
	
	Регистраторы.Свернуть("Ссылка");
	
	НачатьТранзакцию();
	
	Попытка
		
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ОперацииСПрослеживаемымиТоварами.НаборЗаписей");
		ЭлементБлокировки.ИсточникДанных = Регистраторы;
		ЭлементБлокировки.ИспользоватьИзИсточникаДанных("Регистратор", "Ссылка");
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
		ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ОперацииСПрослеживаемымиТоварамиРасширенный.НаборЗаписей");
		ЭлементБлокировки.ИсточникДанных = Регистраторы;
		ЭлементБлокировки.ИспользоватьИзИсточникаДанных("Регистратор", "Ссылка");
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
		Блокировка.Заблокировать();
		
		Для Каждого Операция Из Операции Цикл
			
			Если Операция.Расширенная Тогда
				НаборЗаписей = РегистрыСведений.ОперацииСПрослеживаемымиТоварамиРасширенный.СоздатьНаборЗаписей();
			Иначе
				НаборЗаписей = РегистрыСведений.ОперацииСПрослеживаемымиТоварами.СоздатьНаборЗаписей();
			КонецЕсли;
			НаборЗаписей.Отбор.Регистратор.Установить(Операция.Регистратор);
			НаборЗаписей.Прочитать();
			
			Для Каждого Запись Из НаборЗаписей Цикл
				Если Запись.Организация = Операция.Организация
					И ((Операция.Расширенная И Запись.ВидЗапасов.ТипЗапасов = Операция.ТипЗапасов)
						ИЛИ (НЕ Операция.Расширенная И Запись.ТипЗапасов = Операция.ТипЗапасов)) Тогда
					ЗаполнитьЗначенияСвойств(Запись, ЗначенияРеквизитов);
				КонецЕсли;
			КонецЦикла;
			
			НаборЗаписей.Записать();
			
		КонецЦикла;
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		ВызватьИсключение;
		
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти