
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Номенклатура = Параметры.Номенклатура;
	ВидЦены = Параметры.ВидЦены;
	Склад = Параметры.Склад;
	Цена = Параметры.Цена;
	Дата = Параметры.Дата;
	Упаковка = Параметры.Упаковка;
	Организация = Параметры.Организация;
	
	СтруктураНоменклатуры = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Номенклатура, "ЕдиницаИзмерения, ИспользоватьУпаковки");
	
	Если Упаковка.Пустая()
		И СтруктураНоменклатуры.ИспользоватьУпаковки Тогда 
		Упаковка = ПодборТоваровВызовСервера.ПолучитьУпаковкуХранения(Номенклатура);
	КонецЕсли;
	
	СтараяУпаковка = Упаковка;
	
	Если СтруктураНоменклатуры.ИспользоватьУпаковки Тогда
		Элементы.Упаковка.ПодсказкаВвода = СтруктураНоменклатуры.ЕдиницаИзмерения;
	КонецЕсли;
	
	Номенклатура   = Параметры.Номенклатура;
	Характеристика = Параметры.Характеристика;
	
	ТипНоменклатуры = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Номенклатура, "ТипНоменклатуры");
	
	Валюта = Параметры.Валюта;
	
	КоличествоУпаковок = 1;
	
	Элементы.ВидЦены.ТолькоПросмотр     = НЕ Параметры.РедактироватьВидЦены;
	Элементы.ВидЦены.ПропускатьПриВводе = НЕ Параметры.РедактироватьВидЦены;
	Элементы.Цена.ТолькоПросмотр        = НЕ Параметры.РедактироватьЦену;
	Элементы.Цена.ПропускатьПриВводе    = НЕ Параметры.РедактироватьЦену;
	
	НаименованиеТовара = "" + Параметры.Номенклатура + ?(ЗначениеЗаполнено(Параметры.Характеристика), " (" + Параметры.Характеристика + ")","");
	
	Если Параметры.СкрытьЦену Тогда
		Элементы.Цена.Видимость    = Ложь;
		Элементы.Валюта.Видимость  = Ложь;
		Элементы.ВидЦены.Видимость = Ложь;
		ЭтаФорма.АвтоЗаголовок     = Ложь;
		ЭтаФорма.Заголовок         = НСтр("ru = 'Ввод количества';
											|en = 'Enter quantity'");
	КонецЕсли;
	
	НоменклатураНаборУпаковок = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Номенклатура, "НаборУпаковок");
	Элементы.Упаковка.Видимость         = ЗначениеЗаполнено(НоменклатураНаборУпаковок);
	Элементы.ЕдиницаИзмерения.Видимость = Не ЗначениеЗаполнено(НоменклатураНаборУпаковок);
	
	ИспользоватьСкладскиеПомещения = (ПолучитьФункциональнуюОпцию("ИспользоватьСкладскиеПомещения") И ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Склад, "ИспользоватьСкладскиеПомещения"));
	
	Если ИспользоватьСкладскиеПомещения Тогда
		Помещение = СкладыСервер.ПомещениеДляНоменклатуры(Новый Структура("Склад, Номенклатура, Характеристика", Склад, Номенклатура, Характеристика));
	Иначе
		Элементы.Помещение.Видимость = Ложь;
	КонецЕсли;

	Если ТипНоменклатуры = ПредопределенноеЗначение("Перечисление.ТипыНоменклатуры.Набор") Тогда
		РассчитатьПараметрыНабора();
	КонецЕсли;

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	УстановитьВидимостьКоличествоЕдиницХранения();

	ОбновитьКоличество();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура УпаковкаПриИзменении(Элемент)
	
	УпаковкаПриИзмененииНаСервере(СтараяУпаковка);
	СтараяУпаковка = Упаковка;
	
КонецПроцедуры

&НаКлиенте
Процедура УпаковкаОчистка(Элемент, СтандартнаяОбработка)
	
	УпаковкаПриИзмененииНаСервере(СтараяУпаковка);
	СтараяУпаковка = Упаковка;
	
КонецПроцедуры

&НаКлиенте
Процедура ВидЦеныПриИзменении(Элемент)
	
	ВидЦеныПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ЦенаПриИзменении(Элемент)
	
	ВидЦены = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура КоличествоУпаковокПриИзменении(Элемент)
	
	ОбновитьКоличество();
	
КонецПроцедуры

&НаКлиенте
Процедура КоличествоПриИзменении(Элемент)
	
	ОбновитьКоличествоУпаковок();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	Отказ = Ложь;
	Если КоличествоУпаковок = 0 Тогда
		
		ОчиститьСообщения();
		
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = НСтр("ru = 'Не заполнено количество';
								|en = 'Quantity is not filled in'");
		Сообщение.Поле = "КоличествоУпаковок";
		Сообщение.Сообщить();
		
		Отказ = Истина;
		
	КонецЕсли;
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипНоменклатуры = ПредопределенноеЗначение("Перечисление.ТипыНоменклатуры.Набор") Тогда
		
		ПодобранныеТовары = ПодобранныеТовары();
		
	Иначе
		
		ПодобранныеТовары = Новый Массив;
		
		ПараметрыТовара = Новый Структура;
		ПараметрыТовара.Вставить("Номенклатура", Номенклатура);        
		ПараметрыТовара.Вставить("Характеристика", Характеристика);
		ПараметрыТовара.Вставить("Упаковка", Упаковка);
		ПараметрыТовара.Вставить("Цена", Цена);
		ПараметрыТовара.Вставить("ВидЦены", ВидЦены);
		ПараметрыТовара.Вставить("КоличествоУпаковок", КоличествоУпаковок);
		ПараметрыТовара.Вставить("Склад", Склад);
		ПараметрыТовара.Вставить("Помещение", Помещение);
		ПараметрыТовара.Вставить("Номенклатура", Номенклатура);
		
		ПодобранныеТовары.Добавить(ПараметрыТовара);
		
	КонецЕсли;
	
	Закрыть(ПодобранныеТовары);
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть(Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура Округлить(Команда)
	
	Количество = Окр(Количество, 0, РежимОкругления.Окр15как20);
	ОбновитьКоличествоУпаковок();
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.НоменклатураЕдиницаИзмерения.Имя);
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Количество.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("УказаноДробноеКоличествоВБазовыхЕдиницах");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ПоясняющийОшибкуТекст);

КонецПроцедуры

#Область ПриИзмененииРеквизитов

&НаСервере
Процедура УпаковкаПриИзмененииНаСервере(СтараяУпаковка)
	
	УстановитьВидимостьКоличествоЕдиницХранения();
	ОбновитьКоличество();
	
	Цена = Цена * 
		Справочники.УпаковкиЕдиницыИзмерения.КоэффициентУпаковки(Упаковка, Номенклатура) /
		Справочники.УпаковкиЕдиницыИзмерения.КоэффициентУпаковки(СтараяУпаковка, Номенклатура);
	
КонецПроцедуры

&НаСервере
Процедура ВидЦеныПриИзмененииНаСервере()
	
	Запрос = Новый Запрос("
		|ВЫБРАТЬ
		|	ВЫРАЗИТЬ(ЦеныНоменклатурыСрезПоследних.Цена * КурсыСрезПоследних.Курс / КурсыСрезПоследних.Кратность
		|		/ КурсыСрезПоследнихВалютаЦены.Курс * КурсыСрезПоследнихВалютаЦены.Кратность
		|		* ЕСТЬNULL(&ТекстЗапросаКоэффициентУпаковки1, 1)
		|		/ ЕСТЬNULL(&ТекстЗапросаКоэффициентУпаковки2, 1) КАК ЧИСЛО(31,2)) КАК Цена
		|ИЗ
		|	РегистрСведений.ЦеныНоменклатуры.СрезПоследних(КОНЕЦПЕРИОДА(&Дата, ДЕНЬ), Номенклатура = &Номенклатура
		|		И Характеристика = &Характеристика И ВидЦены = &ВидЦены)
		|	КАК ЦеныНоменклатурыСрезПоследних
		|ЛЕВОЕ СОЕДИНЕНИЕ
		|	РегистрСведений.ОтносительныеКурсыВалют.СрезПоследних(&Дата, БазоваяВалюта = &БазоваяВалюта) КАК КурсыСрезПоследних
		|ПО
		|	КурсыСрезПоследних.Валюта = ЦеныНоменклатурыСрезПоследних.Валюта
		|ЛЕВОЕ СОЕДИНЕНИЕ
		|	РегистрСведений.ОтносительныеКурсыВалют.СрезПоследних(&Дата, Валюта = &Валюта И БазоваяВалюта = &БазоваяВалюта) КАК КурсыСрезПоследнихВалютаЦены
		|ПО
		|	ИСТИНА
		|");
		
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ТекстЗапросаКоэффициентУпаковки1",
		Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаКоэффициентаУпаковки(
			"ВЫРАЗИТЬ(&Упаковка КАК Справочник.УпаковкиЕдиницыИзмерения)",
			"ВЫРАЗИТЬ(&Номенклатура КАК Справочник.Номенклатура"));
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ТекстЗапросаКоэффициентУпаковки2",
		Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаКоэффициентаУпаковки(
			"ЦеныНоменклатурыСрезПоследних.Упаковка",
			"ВЫРАЗИТЬ(&Номенклатура КАК Справочник.Номенклатура"));
	
	Запрос.УстановитьПараметр("ВидЦены"        ,ВидЦены);
	Запрос.УстановитьПараметр("Дата"           ,Дата);
	Запрос.УстановитьПараметр("Номенклатура"   ,Номенклатура);
	Запрос.УстановитьПараметр("Характеристика" ,Характеристика);
	Запрос.УстановитьПараметр("Упаковка"       ,Упаковка);
	Запрос.УстановитьПараметр("Валюта"         ,Валюта);
	Запрос.УстановитьПараметр("БазоваяВалюта", ЗначениеНастроекПовтИсп.ВалютаРегламентированногоУчетаОрганизации(Организация));
	
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Если ЗначениеЗаполнено(Выборка.Цена) Тогда
			Цена = Выборка.Цена;
		Иначе
			Цена = 0;
		КонецЕсли;
	Иначе
		Цена = 0;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Наборы

&НаСервере
Функция ПодобранныеТовары()
	
	ПараметрыВариантаКомплектацииНоменклатуры = НаборыВызовСервера.ПараметрыВариантаКомплектацииНоменклатуры(
		Номенклатура,
		Характеристика);
		
	Если Не ЗначениеЗаполнено(ПараметрыВариантаКомплектацииНоменклатуры) Тогда
		Возврат Новый Массив;
	КонецЕсли;
	
	ВариантКомплектацииНоменклатуры = ПараметрыВариантаКомплектацииНоменклатуры.ВариантКомплектацииНоменклатуры;
	
	ПараметрыКомплектующих = Новый Структура;
	ПараметрыКомплектующих.Вставить("НоменклатураНабора",              Номенклатура);
	ПараметрыКомплектующих.Вставить("ХарактеристикаНабора",            Характеристика);
	ПараметрыКомплектующих.Вставить("ВариантКомплектацииНоменклатуры", ВариантКомплектацииНоменклатуры);
	ПараметрыКомплектующих.Вставить("ВидЦены", ВидЦены);
	ПараметрыКомплектующих.Вставить("Валюта", Валюта);
	
	ПараметрыКомплектующих.Вставить("Склад", Склад);
	ПараметрыКомплектующих.Вставить("КоличествоУпаковок", КоличествоУпаковок);
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Дата",    Дата);
	ДополнительныеПараметры.Вставить("Валюта",  Валюта);
	ДополнительныеПараметры.Вставить("Цена",    Цена);
	ДополнительныеПараметры.Вставить("ВидЦены", ВидЦены);
	ДополнительныеПараметры.Вставить("Соглашение", Неопределено);
	ДополнительныеПараметры.Вставить("Организация", Организация);
	ПодобранныеТовары = НаборыВызовСервера.Комплектующие(ПараметрыКомплектующих, ДополнительныеПараметры);
	
	Возврат ПодобранныеТовары;
	
КонецФункции

&НаСервере
Процедура РассчитатьПараметрыНабора()
	
	ПараметрыВариантаКомплектацииНоменклатуры = НаборыВызовСервера.ПараметрыВариантаКомплектацииНоменклатуры(
		Номенклатура,
		Характеристика);
		
	Если Не ЗначениеЗаполнено(ПараметрыВариантаКомплектацииНоменклатуры) Тогда
		Возврат;
	КонецЕсли;
	
	ВариантКомплектацииНоменклатуры = ПараметрыВариантаКомплектацииНоменклатуры.ВариантКомплектацииНоменклатуры;
	
	Если ПараметрыВариантаКомплектацииНоменклатуры.ВариантРасчетаЦеныНабора = Перечисления.ВариантыРасчетаЦенНаборов.РассчитываетсяИзЦенКомплектующих Тогда
		ПодобранныеТовары = ПодобранныеТовары();
		Цена = 0;
		Для Каждого СтрокаТЧ Из ПодобранныеТовары Цикл
			Цена = Цена + СтрокаТЧ.Цена * СтрокаТЧ.КоличествоУпаковок;
		КонецЦикла;
		Элементы.Цена.Доступность = Ложь;
	Иначе
		Элементы.Цена.Доступность = Истина;
	КонецЕсли;
	
	Элементы.Упаковка.Видимость         = Ложь;
	Элементы.ЕдиницаИзмерения.Видимость = Истина;
	
КонецПроцедуры

#КонецОбласти

&НаСервере
Процедура ОбновитьКоличество()
	
	Количество = КоличествоУпаковок*Справочники.УпаковкиЕдиницыИзмерения.КоэффициентУпаковки(Упаковка, Номенклатура);
	УстановитьВидимостьОкруглить();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьКоличествоУпаковок()
	
	КоличествоУпаковок = Количество/Справочники.УпаковкиЕдиницыИзмерения.КоэффициентУпаковки(Упаковка, Номенклатура);
	УстановитьВидимостьОкруглить();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьКоличествоЕдиницХранения()
	
	ЕдиницаИзмеренияТипИзмеряемойВеличины = "";
	УпаковкаТипИзмеряемойВеличины = "";
	ЕдиницаМерная = Справочники.УпаковкиЕдиницыИзмерения.ЭтоМернаяЕдиница(ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Номенклатура, "ЕдиницаИзмерения"),
																			ЕдиницаИзмеренияТипИзмеряемойВеличины);
																			
	УпаковкаМерная = Справочники.УпаковкиЕдиницыИзмерения.ЭтоМернаяЕдиница(Упаковка,
																			УпаковкаТипИзмеряемойВеличины);
	Если ЕдиницаМерная
		И УпаковкаТипИзмеряемойВеличины <> ЕдиницаИзмеренияТипИзмеряемойВеличины
		И УпаковкаТипИзмеряемойВеличины <> "Упаковка"
		И УпаковкаТипИзмеряемойВеличины <> ""
		Или ЕдиницаИзмеренияТипИзмеряемойВеличины = "КоличествоШтук" 
		И УпаковкаМерная Тогда 
		
		Элементы.Количество.Видимость = Истина;
		Элементы.НоменклатураЕдиницаИзмерения.Видимость = Истина;
		Элементы.ДекорацияКоличествоОкруглить.Видимость = Ложь;
		
	Иначе
		
		Элементы.Количество.Видимость = Ложь;
		Элементы.НоменклатураЕдиницаИзмерения.Видимость = Ложь;
		Элементы.ДекорацияКоличествоОкруглить.Видимость = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьОкруглить()
	
	Если Количество <> Цел(Количество) И Элементы.Количество.Видимость И Не ЕдиницаМерная Тогда
		УказаноДробноеКоличествоВБазовыхЕдиницах = Истина;
		Элементы.Округлить.Видимость = Истина;
	Иначе
		УказаноДробноеКоличествоВБазовыхЕдиницах = Ложь;
		Элементы.Округлить.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
