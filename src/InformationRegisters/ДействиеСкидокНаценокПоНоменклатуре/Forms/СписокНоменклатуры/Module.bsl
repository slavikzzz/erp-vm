
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ИсточникДействия = Параметры.Источник;
	
	АвтоЗаголовок = Ложь;
	Если ТипЗнч(ИсточникДействия) = Тип("СправочникСсылка.УсловияПредоставленияСкидокНаценок") Тогда
		Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Номенклатура, по которой проверяется условие ""%1""';
				|en = 'Items in which condition ""%1"" is checked'"), ИсточникДействия);
	Иначе
		Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Номенклатура, на которую предоставляется скидка (наценка) ""%1""';
				|en = 'Items to which discount (markup) ""%1"" is provided'"), ИсточникДействия);
	КонецЕсли;
	ДатаСреза = ТекущаяДатаСеанса();
	ВариантОтображения = "ТолькоДействующие";
	
	Элементы.ФормаЗакрыть.Видимость = ТипЗнч(ИсточникДействия) = Тип("СправочникСсылка.СкидкиНаценки")
		Или ТипЗнч(ИсточникДействия) = Тип("СправочникСсылка.УсловияПредоставленияСкидокНаценок");
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
		Товары,
		"ТекущаяДата",
		ДатаСреза,
		Истина);
		
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
		Товары,
		"СкидкаНаценка",
		ИсточникДействия,
		Истина);
		
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
		Товары.Отбор,
		"Статус",
		ПредопределенноеЗначение("Перечисление.СтатусыДействияСкидок.Действует"),
		ВидСравненияКомпоновкиДанных.Равно,
		,
		ЗначениеЗаполнено(ВариантОтображения));
		
	Элементы.УстановитьСтатусДействует.Видимость = ПравоДоступа("Изменение", Метаданные.РегистрыСведений.ДействиеСкидокНаценокПоНоменклатуре);
	Элементы.УстановитьСтатусНеДействует.Видимость = ПравоДоступа("Изменение", Метаданные.РегистрыСведений.ДействиеСкидокНаценокПоНоменклатуре);
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

// Параметры:
// 	ИмяСобытия - Строка - Имя события
// 	Параметр - Структура - со свойствами:
// 		* Источник - Массив из СправочникСсылка.СкидкиНаценки - 
// 	Источник - ФормаКлиентскогоПриложения - Источник события
&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_ДействиеСкидокНаценокПоНоменклатуре" И Параметр.Источник.Найти(ИсточникДействия) <> Неопределено Тогда
		ОбновитьТаблицуТоваров();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ИсточникВыбора.ИмяФормы = "Обработка.ПодборТоваровВДокументПродажи.Форма.Форма" Тогда
		
		МассивТовары = ОбработкаВыбораПодборНаСервере(ВыбранноеЗначение);
		
		Если МассивТовары.Количество() > 0 Тогда
			ОткрытьФормуИзмененияСтатуса(
				МассивТовары,
				ИсточникДействия,
				ПредопределенноеЗначение("Перечисление.СтатусыДействияСкидок.Действует"));
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВариантОтображенияПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
		Товары.Отбор,
		"Статус",
		ПредопределенноеЗначение("Перечисление.СтатусыДействияСкидок.Действует"),
		ВидСравненияКомпоновкиДанных.Равно,
		,
		ЗначениеЗаполнено(ВариантОтображения));
	
	ОбновитьТаблицуТоваров();
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаСрезаПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
		Товары,
		"ТекущаяДата",
		ДатаСреза,
		Истина);
		
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
		Товары,
		"СкидкаНаценка",
		ИсточникДействия,
		Истина);
	
	ОбновитьТаблицуТоваров();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ИсторияДействияСкидкиНаценки(Команда)
	
	СкидкиНаценкиКлиент.ОткрытьФормуИсторииИзмененияСтатуса(ЭтотОбъект, ИсточникДействия);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусДействует(Команда)
	
	СкидкиНаценкиКлиент.ОткрытьФормуУстановкиСтатуса(
		ЭтотОбъект,
		ПредопределенноеЗначение("Перечисление.СтатусыДействияСкидок.Действует"), 
		ИсточникДействия);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусНеДействует(Команда)
	
	СкидкиНаценкиКлиент.ОткрытьФормуУстановкиСтатуса(
		ЭтотОбъект,
		ПредопределенноеЗначение("Перечисление.СтатусыДействияСкидок.НеДействует"),
		ИсточникДействия);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтотОбъект, Команда);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодобратьТовары(Команда)
	
	ВариантыРасчетаЦеныНабора = Новый Массив;
	ВариантыРасчетаЦеныНабора.Добавить(ПредопределенноеЗначение("Перечисление.ВариантыРасчетаЦенНаборов.ПустаяСсылка"));
	ВариантыРасчетаЦеныНабора.Добавить(ПредопределенноеЗначение("Перечисление.ВариантыРасчетаЦенНаборов.ЦенаЗадаетсяЗаНаборРаспределяетсяПоДолям"));
	ВариантыРасчетаЦеныНабора.Добавить(ПредопределенноеЗначение("Перечисление.ВариантыРасчетаЦенНаборов.ЦенаЗадаетсяЗаНаборРаспределяетсяПоЦенам"));
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("РежимПодбораБезКоличественныхПараметров", Истина);
	ПараметрыФормы.Вставить("РежимПодбораБезСуммовыхПараметров",       Истина);
	ПараметрыФормы.Вставить("СкрыватьКолонкуВидЦены",                  Истина);
	ПараметрыФормы.Вставить("СкрыватьКомандуЦеныНоменклатуры",         Истина);
	ПараметрыФормы.Вставить("СкрыватьКомандуОстаткиНаСкладах",         Истина);
	ПараметрыФормы.Вставить("СкрыватьКнопкуЗапрашиватьКоличество",     Истина);
	ПараметрыФормы.Вставить("Документ",                                ПредопределенноеЗначение("Документ.УстановкаЦенНоменклатуры.ПустаяСсылка"));
	ПараметрыФормы.Вставить("Заголовок",                               НСтр("ru = 'Подбор товаров';
																			|en = 'Pick goods'"));
	ПараметрыФормы.Вставить("Дата",                                    ДатаСреза);
	ПараметрыФормы.Вставить("НеРазбиватьНаборыПоКомплектующим",        Истина);
	ПараметрыФормы.Вставить("ОтборПоВариантуРасчетаЦенНаборов",        ВариантыРасчетаЦеныНабора);
	
	ОткрытьФорму("Обработка.ПодборТоваровВДокументПродажи.Форма", ПараметрыФормы, ЭтаФорма, УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьФорму(Команда)
	Закрыть();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();
	
	СкидкиНаценкиСервер.УстановитьУсловноеОформлениеФормыИсточникаДействияСкидок(УсловноеОформление, Элементы, "Товары");

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_СписокПриАктивизацииСтроки()
	
	//ТекущиеДанные = Элементы.СкидкиНаценки.ТекущиеДанные;
	//СкидкаНаценка = ?(ТекущиеДанные = Неопределено ИЛИ ТекущиеДанные.ЭтоГруппа, Неопределено, ТекущиеДанные.СкидкаНаценка);
	//
	//Если СкидкаНаценка <> АктивизированнаяСкидкаНаценка Тогда
	//	ОбновитьИспользованиеСкидокНаценок(СкидкаНаценка);
	//	АктивизированнаяСкидкаНаценка = ?(ТекущиеДанные = Неопределено, Неопределено, ТекущиеДанные.СкидкаНаценка);
	//КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьТаблицуТоваров()
	
	Элементы.Товары.Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуИзмененияСтатуса(ПозицияНоменклатуры, Источник, Статус)
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("ДатаНачала", ДатаСреза);
	ПараметрыОткрытия.Вставить("ПозицияНоменклатуры", ПозицияНоменклатуры);
	ПараметрыОткрытия.Вставить("Источник", Источник);
	ПараметрыОткрытия.Вставить("Статус", Статус);
	
	ОткрытьФорму(
		"Справочник.СкидкиНаценки.Форма.УстановкаСтатусаДействия",
		ПараметрыОткрытия,
		ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Функция ОбработкаВыбораПодборНаСервере(ВыбранноеЗначение)
	
	ТаблицаТоваров = ПолучитьИзВременногоХранилища(ВыбранноеЗначение.АдресТоваровВХранилище);
	
	МассивТовары = Новый Массив;
	Для Каждого СтрокаТЧ Из ТаблицаТоваров Цикл
		НоваяСтрока = Новый Структура;
		НоваяСтрока.Вставить("Номенклатура", СтрокаТЧ.Номенклатура);
		НоваяСтрока.Вставить("Характеристика", СтрокаТЧ.Характеристика);
		МассивТовары.Добавить(НоваяСтрока);
	КонецЦикла;
	
	Возврат МассивТовары;
	
КонецФункции

#КонецОбласти
