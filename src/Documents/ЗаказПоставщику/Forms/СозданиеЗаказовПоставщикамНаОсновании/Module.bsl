#Область ОписаниеПеременных

&НаКлиенте
Перем КэшированныеЗначения; //используется механизмом обработки изменения реквизитов ТЧ

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ДокументОснование  = Параметры.ДокументОснование;
	
	РеквизитыОснования = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДокументОснование,
		"Представление,ДатаОтгрузки,НеОтгружатьЧастями");
	
	Заголовок = РеквизитыОснования.Представление;
	ДатаОтгрузки = ?(РеквизитыОснования.НеОтгружатьЧастями, РеквизитыОснования.ДатаОтгрузки, Неопределено);
	ОбособленныйЗаказ = Документы.ЗаказКлиента.ОбособленноеОбеспечение(ДокументОснование);
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	ЗаполнитьТовары();
	РассчитатьКоличествоЗаказов();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_ЗаказПоставщику" Тогда

		Ссылка = ОбщегоНазначенияУТВызовСервера.ЗначениеРеквизитаОбъекта(Источник, "Ссылка");
		ОбновитьСостоянияЗаказов(Ссылка);

	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы 

&НаКлиенте
Процедура ТолькоСтрокиЗаказаКОбеспечениюПриИзменении(Элемент)
	
	ОчиститьСообщения();
	ЗаполнитьТовары();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыЗаказы

&НаКлиенте
Процедура ЗаказыПриИзменении(Элемент)
	ОбеспечениеВДокументахКлиент.ПроверитьЗапуститьФоновоеЗаданиеРаспределенияЗапасов();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

&НаКлиенте
Процедура ТоварыВыбранПриИзменении(Элемент)
	РассчитатьКоличествоЗаказов();
КонецПроцедуры

&НаКлиенте
Процедура ТоварыПоставщикПриИзменении(Элемент)
	РассчитатьКоличествоЗаказов();
КонецПроцедуры

&НаКлиенте
Процедура ТоварыКоличествоУпаковокПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПересчитатьКоличествоЕдиниц");
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыбратьСтрокиВыполнить()

	Для Каждого Товар Из Товары Цикл
		Товар.Выбран = Истина;
	КонецЦикла;

	РассчитатьКоличествоЗаказов();

КонецПроцедуры

&НаКлиенте
Процедура ИсключитьСтрокиВыполнить()

	Для Каждого Товар Из Товары Цикл
		Товар.Выбран = Ложь;
	КонецЦикла;

	РассчитатьКоличествоЗаказов();

КонецПроцедуры

&НаКлиенте
Процедура СоздатьЗаказы(Команда)

	ОчиститьСообщения();

	Если Товары.Количество() = 0 Тогда

		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Отсутствуют строки для формирования заказов!';
																|en = 'To create a Purchase Order, add at least one item.'"));

	ИначеЕсли КоличествоЗаказов = 0 И Товары.Количество() > 0 Тогда

		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru = 'Для формирования заказов необходимо указать поставщиков и отметить хотя бы одну строку!';
					|en = 'To create Purchase Orders, select at least one item and choose vendors.'"),
				,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Товары", 1, "Выбран"),
				,);
	Иначе

		ПередСозданиемЗаказовСервер();

	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ЗаказыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ОткрытьФорму("Документ.ЗаказПоставщику.ФормаОбъекта", Новый Структура("Ключ", Элемент.ТекущиеДанные.Ссылка), ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоставщика(Команда)
	
	СтруктураОтбора = Новый Структура("Поставщик", Истина);
	СтруктураПараметров = Новый Структура("Отбор,Поставщик", СтруктураОтбора, Истина);	
	
	КолвоВыбранных = КоличествоВыбранныхСтрокТовары();
	
	ОчиститьСообщения();
	
	Если КолвоВыбранных = 0 И Товары.Количество()>0 Тогда 
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Для заполнения поставщиков выберите хотя бы одну строку!';
																|en = 'To populate vendors, select at least one item.'"),
				,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Товары", 1, "Выбран"),
				,);
	ИначеЕсли Товары.Количество()=0 И КолвоВыбранных=0 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Отсутствуют строки для заполнения поставщиков!';
																|en = 'To populate vendors, add at least one item.'"));
	Иначе
		ВыбранныйПоставщик = Неопределено;

		ОткрытьФорму("Справочник.Партнеры.ФормаВыбора", СтруктураПараметров, ЭтаФорма,,,, Новый ОписаниеОповещения("ЗаполнитьПоставщикаЗавершение", ЭтотОбъект), РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
        Возврат;
	КонецЕсли;
	
	ЗаполнитьПоставщикаФрагмент(ВыбранныйПоставщик);
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоставщикаЗавершение(Результат, ДополнительныеПараметры) Экспорт
    
    ВыбранныйПоставщик = Результат;
    
    ЗаполнитьПоставщикаФрагмент(ВыбранныйПоставщик);

КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоставщикаФрагмент(Знач ВыбранныйПоставщик)
    
    Перем СтрокаТовар;
    
    Если ЗначениеЗаполнено(ВыбранныйПоставщик) Тогда
        Для Каждого СтрокаТовар Из Товары Цикл
            Если СтрокаТовар.Выбран Тогда
                СтрокаТовар.Поставщик = ВыбранныйПоставщик;
            КонецЕсли; 
        КонецЦикла;
    КонецЕсли;
    РассчитатьКоличествоЗаказов();

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
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТоварыПоставщик.Имя);

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТоварыКоличествоУпаковок.Имя);

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТоварыУпаковка.Имя);

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТоварыНоменклатураЕдиницаИзмерения.Имя);

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТоварыСклад.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Товары.Выбран");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.НезаполненноеПолеТаблицы);
	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);
	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТоварыПоставщик.Имя);

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТоварыКоличествоУпаковок.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Товары.Выбран");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Ложь);

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТоварыПоставщик.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Товары.Поставщик");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<укажите поставщика>';
																|en = '<Specify Vendor>'"));

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТоварыПоставщик.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Товары.Поставщик");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Товары.Выбран");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.НезаполненноеПолеТаблицы);
	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Истина);

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТоварыКоличествоУпаковок.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Товары.КоличествоУпаковок");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Товары.Выбран");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Истина);

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТовары()
	
	ПараметрыСоздания = Документы.ЗаказПоставщику.ПараметрыСозданияНаОснованииОбеспечивающегоЗаказа();
	МенеджерДокумента = ОбщегоНазначения.МенеджерОбъектаПоСсылке(ДокументОснование);
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	МенеджерДокумента.ТоварыДокументаДляСозданияОбеспечивающегоЗаказа(
		ДокументОснование,
		ПараметрыСоздания,
		МенеджерВременныхТаблиц);
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("ТолькоСтрокиЗаказаКОбеспечению", ТолькоСтрокиЗаказаКОбеспечению);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Таб.НомерСтроки КАК НомерСтроки,
	|	Таб.Номенклатура КАК Номенклатура,
	|	Таб.Характеристика КАК Характеристика,
	|	Таб.Склад КАК Склад,
	|	Таб.Подразделение КАК Подразделение,
	|	Таб.Назначение КАК Назначение,
	|	Таб.Упаковка КАК Упаковка,
	|	Таб.КоличествоЕдиницПоДокументу КАК Количество,
	|	Таб.КоличествоПоДокументу КАК КоличествоУпаковок
	|ПОМЕСТИТЬ ТаблицаТовары
	|ИЗ
	|	ТоварыДокумента КАК Таб
	|ГДЕ
	|	НЕ &ТолькоСтрокиЗаказаКОбеспечению
	|		ИЛИ Таб.ВариантОбеспечения В(
	|			ЗНАЧЕНИЕ(Перечисление.ВариантыОбеспечения.КОбеспечению),
	|			ЗНАЧЕНИЕ(Перечисление.ВариантыОбеспечения.РезервироватьПоМереПоступления))
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Номенклатура,
	|	Характеристика
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Поступления.Номенклатура КАК Номенклатура,
	|	Поступления.Характеристика КАК Характеристика,
	|	МАКСИМУМ(Поступления.Ссылка.Дата) КАК Дата
	|ПОМЕСТИТЬ ПослПоступления
	|ИЗ
	|	ТаблицаТовары КАК ТоварыОснования
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ПриобретениеТоваровУслуг.Товары КАК Поступления
	|		ПО ТоварыОснования.Номенклатура = Поступления.Номенклатура
	|			И ТоварыОснования.Характеристика = Поступления.Характеристика
	|ГДЕ
	|	ТоварыОснования.КоличествоУпаковок > 0
	|
	|СГРУППИРОВАТЬ ПО
	|	Поступления.Номенклатура,
	|	Поступления.Характеристика
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Поступления.Номенклатура КАК Номенклатура,
	|	Поступления.Характеристика КАК Характеристика,
	|	МАКСИМУМ(Поступления.Ссылка.Дата) КАК Дата,
	|	МАКСИМУМ(Поступления.Ссылка) КАК Ссылка
	|ПОМЕСТИТЬ ПослПоступленияСсылкой
	|ИЗ
	|	Документ.ПриобретениеТоваровУслуг.Товары КАК Поступления
	|ГДЕ
	|	(Поступления.Номенклатура, Поступления.Характеристика, Поступления.Ссылка.Дата) В
	|			(ВЫБРАТЬ
	|				ПослПоступления.Номенклатура КАК Номенклатура,
	|				ПослПоступления.Характеристика КАК Характеристика,
	|				ПослПоступления.Дата КАК Дата
	|			ИЗ
	|				ПослПоступления)
	|
	|СГРУППИРОВАТЬ ПО
	|	Поступления.Номенклатура,
	|	Поступления.Характеристика
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Поступления.Номенклатура КАК Номенклатура,
	|	Поступления.Характеристика КАК Характеристика,
	|	МАКСИМУМ(Поступления.Ссылка.Дата) КАК Дата
	|ПОМЕСТИТЬ ПредПослПоступления
	|ИЗ
	|	ПослПоступленияСсылкой КАК ПослПоступленияСсылкой
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ПриобретениеТоваровУслуг.Товары КАК Поступления
	|		ПО ПослПоступленияСсылкой.Номенклатура = Поступления.Номенклатура
	|			И ПослПоступленияСсылкой.Характеристика = Поступления.Характеристика
	|			И ПослПоступленияСсылкой.Ссылка <> Поступления.Ссылка
	|
	|СГРУППИРОВАТЬ ПО
	|	Поступления.Номенклатура,
	|	Поступления.Характеристика
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Поступления.Номенклатура КАК Номенклатура,
	|	Поступления.Характеристика КАК Характеристика,
	|	МАКСИМУМ(Поступления.Ссылка.Дата) КАК Дата,
	|	МАКСИМУМ(Поступления.Ссылка) КАК Ссылка
	|ПОМЕСТИТЬ ПредПослПоступленияСсылкой
	|ИЗ
	|	Документ.ПриобретениеТоваровУслуг.Товары КАК Поступления
	|ГДЕ
	|	(Поступления.Номенклатура, Поступления.Характеристика, Поступления.Ссылка.Дата) В
	|			(ВЫБРАТЬ
	|				ПредПослПоступления.Номенклатура КАК Номенклатура,
	|				ПредПослПоступления.Характеристика КАК Характеристика,
	|				ПредПослПоступления.Дата КАК Дата
	|			ИЗ
	|				ПредПослПоступления)
	|
	|СГРУППИРОВАТЬ ПО
	|	Поступления.Номенклатура,
	|	Поступления.Характеристика
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Поступления.Номенклатура КАК Номенклатура,
	|	Поступления.Характеристика КАК Характеристика,
	|	МАКСИМУМ(Поступления.Ссылка.Дата) КАК Дата
	|ПОМЕСТИТЬ ПервыеПоступления
	|ИЗ
	|	ПредПослПоступленияСсылкой КАК ПредПослПоступленияСсылкой
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ПриобретениеТоваровУслуг.Товары КАК Поступления
	|		ПО ПредПослПоступленияСсылкой.Номенклатура = Поступления.Номенклатура
	|			И ПредПослПоступленияСсылкой.Характеристика = Поступления.Характеристика
	|			И ПредПослПоступленияСсылкой.Дата > Поступления.Ссылка.Дата
	|
	|СГРУППИРОВАТЬ ПО
	|	Поступления.Номенклатура,
	|	Поступления.Характеристика
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Поступления.Номенклатура КАК Номенклатура,
	|	Поступления.Характеристика КАК Характеристика,
	|	МАКСИМУМ(Поступления.Ссылка.Дата) КАК Дата,
	|	МАКСИМУМ(Поступления.Ссылка) КАК Ссылка
	|ПОМЕСТИТЬ ПервыеПоступленияСсылкой
	|ИЗ
	|	Документ.ПриобретениеТоваровУслуг.Товары КАК Поступления
	|ГДЕ
	|	(Поступления.Номенклатура, Поступления.Характеристика, Поступления.Ссылка.Дата) В
	|			(ВЫБРАТЬ
	|				ПервыеПоступления.Номенклатура КАК Номенклатура,
	|				ПервыеПоступления.Характеристика КАК Характеристика,
	|				ПервыеПоступления.Дата КАК Дата
	|			ИЗ
	|				ПервыеПоступления)
	|
	|СГРУППИРОВАТЬ ПО
	|	Поступления.Номенклатура,
	|	Поступления.Характеристика
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПервыеПоступленияСсылкой.Номенклатура КАК Номенклатура,
	|	ПервыеПоступленияСсылкой.Характеристика КАК Характеристика,
	|	МАКСИМУМ(ПервыеПоступленияСсылкой.Ссылка.Партнер) КАК Партнер,
	|	МАКСИМУМ(ПослПоступленияСсылкой.Ссылка.Партнер) КАК Партнер1,
	|	МАКСИМУМ(ПредПослПоступленияСсылкой.Ссылка.Партнер) КАК Партнер2
	|ПОМЕСТИТЬ ВТПоставщики
	|ИЗ
	|	ПервыеПоступленияСсылкой КАК ПервыеПоступленияСсылкой
	|		ПОЛНОЕ СОЕДИНЕНИЕ ПослПоступленияСсылкой КАК ПослПоступленияСсылкой
	|			ПОЛНОЕ СОЕДИНЕНИЕ ПредПослПоступленияСсылкой КАК ПредПослПоступленияСсылкой
	|			ПО ПослПоступленияСсылкой.Номенклатура = ПредПослПоступленияСсылкой.Номенклатура
	|				И ПослПоступленияСсылкой.Характеристика = ПредПослПоступленияСсылкой.Характеристика
	|		ПО (ПослПоступленияСсылкой.Характеристика = ПредПослПоступленияСсылкой.Характеристика)
	|			И ПервыеПоступленияСсылкой.Номенклатура = ПослПоступленияСсылкой.Номенклатура
	|
	|СГРУППИРОВАТЬ ПО
	|	ПервыеПоступленияСсылкой.Номенклатура,
	|	ПервыеПоступленияСсылкой.Характеристика
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Товары.НомерСтроки КАК НомерСтроки,
	|	Товары.Номенклатура КАК Номенклатура,
	|	Товары.Характеристика КАК Характеристика,
	|	ЕСТЬNULL(СтавкиНДСНоменклатуры.СтавкаНДС, ЕСТЬNULL(ОсновныеСтавкиНДС.СтавкаНДС,
	|		ЗНАЧЕНИЕ(Справочник.СтавкиНДС.ПустаяСсылка))) КАК СтавкаНДС,
	|	Товары.Склад КАК Склад,
	|	Товары.Подразделение КАК Подразделение,
	|	ВЫБОР КОГДА Товары.Номенклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Услуга) ТОГДА
	|			ИСТИНА
	|		ИНАЧЕ
	|			ЛОЖЬ
	|		КОНЕЦ КАК СписатьНаРасходы,
	|	Товары.Назначение КАК Назначение,
	|	Товары.Упаковка КАК Упаковка,
	|	Товары.Количество КАК Количество,
	|	Товары.КоличествоУпаковок КАК КоличествоУпаковок,
	|	ВЫБОР
	|		КОГДА Поставщики.Партнер = Поставщики.Партнер1
	|				ИЛИ Поставщики.Партнер = Поставщики.Партнер2
	|			ТОГДА Поставщики.Партнер
	|		ИНАЧЕ ВЫБОР
	|				КОГДА Поставщики.Партнер1 = Поставщики.Партнер2
	|					ТОГДА Поставщики.Партнер1
	|			КОНЕЦ
	|	КОНЕЦ КАК Поставщик
	|ИЗ
	|	ТаблицаТовары КАК Товары
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТПоставщики КАК Поставщики
	|		ПО Товары.Номенклатура = Поставщики.Номенклатура
	|			И Товары.Характеристика = Поставщики.Характеристика
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СтавкиНДСНоменклатуры.СрезПоследних(&Период,
	|			Страна = &СтранаРегистрации ИЛИ Страна = ЗНАЧЕНИЕ(Справочник.СтраныМира.ПустаяСсылка)) КАК СтавкиНДСНоменклатуры
	|		ПО Товары.Номенклатура = СтавкиНДСНоменклатуры.Номенклатура
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ОсновныеСтавкиНДС.СрезПоследних(&Период, Страна = &СтранаРегистрации) КАК ОсновныеСтавкиНДС
	|		ПО (ИСТИНА)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Товары.НомерСтроки";
	
	ЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДокументОснование, "Дата,Организация");
	Запрос.УстановитьПараметр("Период", ЗначенияРеквизитов.Дата);
	Запрос.УстановитьПараметр("СтранаРегистрации", ЗначениеНастроекКлиентСерверПовтИсп.СтранаРегистрацииОрганизации(ЗначенияРеквизитов.Организация));
	
	УстановитьПривилегированныйРежим(Истина);
	Товары.Загрузить(Запрос.Выполнить().Выгрузить());
	
	Если Товары.Количество() = 0 Тогда
		
		ТекстОшибки = НСтр("ru = 'Нет товаров, доступных для заполнения.';
							|en = 'No available items to populate.'");
		ОбщегоНазначения.СообщитьПользователю(ТекстОшибки);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура РассчитатьКоличествоЗаказов()
	Если ПолучитьФункциональнуюОпцию("ИспользоватьСкладыВТабличнойЧастиДокументовЗакупки") Тогда
		Выбрано = Товары.Выгрузить(Новый Структура("Выбран", Истина), "Поставщик");
		Выбрано.Свернуть("Поставщик");
	Иначе
		Выбрано = Товары.Выгрузить(Новый Структура("Выбран", Истина), "Поставщик,Склад");
		Выбрано.Свернуть("Поставщик,Склад");
	КонецЕсли;
	
	Количество = Выбрано.Количество();
	
	Для каждого текСтрока Из Выбрано Цикл
		Если НЕ ЗначениеЗаполнено(текСтрока.Поставщик) И Количество>0 Тогда
			Количество = Количество-1;
		КонецЕсли;
	КонецЦикла;
	КоличествоЗаказов = Количество;
КонецПроцедуры

&НаСервере
Процедура ПередСозданиемЗаказовСервер()
	
	ЕстьРеквизитШапкиСклад = ОбщегоНазначения.ЕстьРеквизитОбъекта("Склад", ДокументОснование.Метаданные());
	
	Если ЕстьРеквизитШапкиСклад Тогда
	
		РеквизитыЗаполнения = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДокументОснование,
																			"Организация, Склад");
		ЭтоГруппа = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(РеквизитыЗаполнения.Склад,
																		"ЭтоГруппа");
		ИспользованиеСкладов = ИспользоватьСкладыВТабличнойЧасти();
		
		Если ИспользованиеСкладов.ИспользуютсяСкладыЗакупки И ИспользованиеСкладов.ИспользуютсяСкладыПродажи Тогда

			Поставщики = Товары.Выгрузить(Новый Структура("Выбран", Истина), "Поставщик");
			Поставщики.Свернуть("Поставщик");

		ИначеЕсли Не ИспользованиеСкладов.ИспользуютсяСкладыЗакупки И ИспользованиеСкладов.ИспользуютсяСкладыПродажи Тогда

			Если ЭтоГруппа Тогда

				Поставщики = Товары.Выгрузить(Новый Структура("Выбран", Истина), "Поставщик,Склад");
				Поставщики.Свернуть("Поставщик,Склад");

			Иначе

				Поставщики = Товары.Выгрузить(Новый Структура("Выбран", Истина), "Поставщик");
				Поставщики.Свернуть("Поставщик");

			КонецЕсли;
		ИначеЕсли ИспользованиеСкладов.ИспользуютсяСкладыЗакупки И НЕ ИспользованиеСкладов.ИспользуютсяСкладыПродажи Тогда

			Поставщики = Товары.Выгрузить(Новый Структура("Выбран", Истина), "Поставщик");
			Поставщики.Свернуть("Поставщик");

		ИначеЕсли Не ИспользованиеСкладов.ИспользуютсяСкладыЗакупки И Не ИспользованиеСкладов.ИспользуютсяСкладыПродажи Тогда

			Поставщики = Товары.Выгрузить(Новый Структура("Выбран", Истина), "Поставщик");
			Поставщики.Свернуть("Поставщик");

		КонецЕсли;
	
	Иначе
		
		Поставщики = Товары.Выгрузить(Новый Структура("Выбран", Истина), "Поставщик,Склад");
		Поставщики.Свернуть("Поставщик, Склад");
		
	КонецЕсли;
	
	КоличествоОшибок =0;
	
	Для ТекИндекс = 0 По Товары.Количество()-1 Цикл
		
		Если Товары[ТекИндекс].Поставщик = Справочники.Партнеры.ПустаяСсылка() И Товары[ТекИндекс].Выбран = Истина Тогда
			
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Не заполнена колонка ""Поставщик"" в строке %1 списка ""Товары""';
					|en = 'The ""Vendor"" column in line %1 of the ""Goods"" list is not filled in'"),
				ТекИндекс+1);
			
			ОбщегоНазначения.СообщитьПользователю(
				ТекстОшибки,
				,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Товары", ТекИндекс+1, "Поставщик"));

			КоличествоОшибок = КоличествоОшибок + 1;

		КонецЕсли;
	КонецЦикла;
	
	Если КоличествоОшибок =0 Тогда

		СоздатьЗаказыСервер(Поставщики);

	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СоздатьЗаказыСервер(Поставщики)
	
	Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаЗаказы;
	
	ИспользованиеСкладов = ИспользоватьСкладыВТабличнойЧасти();
	
	ДанныеДокументаОснования = СтруктураДокументаОснованияНаСервере(ИспользованиеСкладов);

	ДатаЗаказов = ТекущаяДатаСеанса();
	Для Каждого ТекСтрока Из Поставщики Цикл

		Заказ = Документы.ЗаказПоставщику.СоздатьДокумент();
		Заказ.Дата = ДатаЗаказов;
		
		Отбор = Новый Структура;
		Отбор.Вставить("Поставщик", ТекСтрока.Поставщик);
		Отбор.Вставить("Выбран",    Истина);
		Если Поставщики.Колонки.Количество()=2 Тогда
			Отбор.Вставить("Склад", ТекСтрока.Склад);
		КонецЕсли;
		
		СтрокиТовары = Товары.НайтиСтроки(Отбор);
		Для Каждого СтрокаТовар Из СтрокиТовары Цикл

			ЗаполнитьЗначенияСвойств(Заказ.Товары.Добавить(), СтрокаТовар);

		КонецЦикла;
		
		Заказ.Партнер = ТекСтрока.Поставщик;
		ПартнерыИКонтрагенты.ЗаполнитьКонтрагентаПартнераПоУмолчанию(ТекСтрока.Поставщик, Заказ.Контрагент);

		Заказ.Заполнить(ДанныеДокументаОснования);
		Если Поставщики.Колонки.Количество() = 2 Тогда
			Заказ.Склад = ТекСтрока.Склад;
		КонецЕсли;
		
		НоменклатураПартнеровСервер.ЗаполнитьНоменклатуруПартнераПоНоменклатуреВТаблице(Заказ.Товары,ТекСтрока.Поставщик);
		Заказ.Записать(РежимЗаписиДокумента.Запись);

		СтрокаЗаказов = Заказы.Добавить();
		СтрокаЗаказов.Ссылка   = Заказ.Ссылка;
		СтрокаЗаказов.Картинка = 2;
	
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция СтруктураДокументаОснованияНаСервере(ИспользованиеСкладов)
	
	ЕстьРеквизитШапкиСклад = ОбщегоНазначения.ЕстьРеквизитОбъекта("Склад", ДокументОснование.Метаданные());

	СтруктураПолей = Новый Структура;
	СтруктураПолей.Вставить("Организация", "Организация");
	СтруктураПолей.Вставить("Подразделение", "Подразделение");
	СтруктураПолей.Вставить("ДокументОснование", "Ссылка");
	СтруктураПолей.Вставить("НаправлениеДеятельности");
	
	Если ЕстьРеквизитШапкиСклад Тогда
		СтруктураПолей.Вставить("Склад", "Склад");
		СтруктураПолей.Вставить("Сделка", "Сделка");
		СтруктураПолей.Вставить("СкладЭтоГруппа", "Склад.ЭтоГруппа");
		СтруктураПолей.Вставить("Приоритет", "Приоритет");
	КонецЕсли;
	
	РеквизитыЗаполнения = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДокументОснование, СтруктураПолей);
	
	Если ЕстьРеквизитШапкиСклад Тогда
		
		СкладЭтоГруппа = РеквизитыЗаполнения.СкладЭтоГруппа;
		
		Если Не ИспользованиеСкладов.ИспользуютсяСкладыЗакупки Тогда
			
			Если СкладЭтоГруппа Тогда
				
				СтрокаПолей = "Организация, ДокументОснование, Подразделение, Сделка, Приоритет, НаправлениеДеятельности";
				
			Иначе
				
				СтрокаПолей = "Организация, ДокументОснование, Подразделение, Склад, Сделка, Приоритет, НаправлениеДеятельности";
				
			КонецЕсли;
			
		Иначе
			
			СтрокаПолей = "Организация, ДокументОснование, Подразделение, Склад, Сделка, Приоритет, НаправлениеДеятельности";
			
		КонецЕсли;
		
	Иначе
		
		СтрокаПолей = "Организация, ДокументОснование, Подразделение, НаправлениеДеятельности";
		
	КонецЕсли;	
		
	РеквизитыОснования = Новый Структура(СтрокаПолей);
	ЗаполнитьЗначенияСвойств(РеквизитыОснования, РеквизитыЗаполнения, СтрокаПолей);

	Возврат РеквизитыОснования;

КонецФункции 

&НаСервере
Процедура ОбновитьСостоянияЗаказов(СсылкаНаЗаказ)
	
	НайденнаяСтрока = Заказы.НайтиСтроки (Новый Структура("Ссылка",СсылкаНаЗаказ));
	
	Если НайденнаяСтрока.Количество() = 0 Тогда
		Возврат
	КонецЕсли;
	
	РеквизитыЗаказа = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(СсылкаНаЗаказ,"ПометкаУдаления,Проведен");
	
	Если РеквизитыЗаказа.ПометкаУдаления Тогда
		НайденнаяСтрока[0].Картинка = 1;
	ИначеЕсли РеквизитыЗаказа.Проведен Тогда
		НайденнаяСтрока[0].Картинка = 0;
	Иначе
		НайденнаяСтрока[0].Картинка = 2;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ИспользоватьСкладыВТабличнойЧасти()
	
	ИспользованиеСкладов = Новый Структура("ИспользуютсяСкладыЗакупки, ИспользуютсяСкладыПродажи",
							ПолучитьФункциональнуюОпцию("ИспользоватьСкладыВТабличнойЧастиДокументовЗакупки"),
							ПолучитьФункциональнуюОпцию("ИспользоватьСкладыВТабличнойЧастиДокументовПродажи"));
	
	Возврат ИспользованиеСкладов;
	
КонецФункции

&НаСервере
Функция КоличествоВыбранныхСтрокТовары()

	Возврат Товары.Выгрузить(Новый Структура("Выбран", Истина)).Количество();

КонецФункции 

#КонецОбласти
