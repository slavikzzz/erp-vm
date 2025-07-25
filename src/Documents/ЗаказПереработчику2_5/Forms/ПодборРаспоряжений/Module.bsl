
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ЗапрещенВыборНовыхЭтапов = Параметры.ЗапрещенВыборНовыхЭтапов;
	РаспоряженияЗаказа = Параметры.РаспоряженияЗаказа;
	
	Если ЗначениеЗаполнено(Параметры.Организация) Тогда
		Элементы.РаспоряженияОрганизация.Видимость = Ложь;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.Партнер) Тогда
		Элементы.РаспоряженияПартнер.Видимость = Ложь;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.Подразделение) Тогда
		Элементы.РаспоряженияПодразделение.Видимость = Ложь;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.ЗакупкаПодДеятельность) Тогда
		Элементы.РаспоряженияЗакупкаПодДеятельность.Видимость = Ложь;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.НаправлениеДеятельности) Тогда
		Элементы.РаспоряженияНаправлениеДеятельности.Видимость = Ложь;
	КонецЕсли;
	
	Если Параметры.ТолькоПросмотр Тогда
		Элементы.РаспоряженияПеренестиВДокумент.Доступность = Ложь;
		Элементы.РаспоряженияВыбратьВсе.Доступность = Ложь;
		Элементы.РаспоряженияСнятьВсе.Доступность = Ложь;
		Элементы.Распоряжения.ТолькоПросмотр = Истина;
	ИначеЕсли Параметры.ЗапрещенВыборНовыхЭтапов Тогда
		Элементы.РаспоряженияВыбратьВсе.Доступность = Ложь;
		Элементы.ОтборПериод.Видимость = Ложь;
	КонецЕсли; 
	
	ЗаполнитьРаспоряжения();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтборПериодПриИзменении(Элемент)
	ЗаполнитьРаспоряжения();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыРаспоряжения

&НаКлиенте
Процедура РаспоряженияВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле = Элементы.РаспоряженияРаспоряжениеПредставление Тогда
		СтандартнаяОбработка = Ложь;
		ТекущиеДанные = Элементы.Распоряжения.ТекущиеДанные;
		ПоказатьЗначение(, ТекущиеДанные.Распоряжение);
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПеренестиВДокумент(Команда)
	
	СтруктураПоиска = Новый Структура("Пометка", Истина);
	СписокСтрок = Распоряжения.НайтиСтроки(СтруктураПоиска);
	
	ДанныеЗаполнения = ПереработкаНаСторонеКлиент.ДанныеДляФормированияЗаказовПереработчикам2_5(СписокСтрок);
	
	Если ДанныеЗаполнения <> Неопределено Тогда
		Закрыть(ДанныеЗаполнения);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьВсе(Команда)
	
	Для каждого ТекущиеДанные Из Распоряжения Цикл
		ТекущиеДанные.Пометка = Истина;
	КонецЦикла; 
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьВсе(Команда)
	
	Для каждого ТекущиеДанные Из Распоряжения Цикл
		ТекущиеДанные.Пометка = Ложь;
	КонецЦикла; 
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	НоменклатураСервер.УстановитьУсловноеОформлениеХарактеристикНоменклатуры(
		ЭтаФорма,
		"РаспоряженияХарактеристика",
		"Распоряжения.ХарактеристикиИспользуются");
	
	// Партнер не указан
	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.РаспоряженияПартнер.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Распоряжения.Партнер");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;

	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<не указан>';
																|en = '<not specified>'"));
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветНедоступногоТекста);
	
	// Дата начала просрочена
	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.РаспоряженияНачало.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Распоряжения.ДатаЗапускаПросрочена");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветОсобогоТекста);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьРаспоряжения()
	
	Распоряжения.Очистить();
	
	ТекстЗапроса = 
	// Этапы, указанные в заказе
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ИСТИНА КАК Пометка,
	|	ДокЭтапПроизводства.Ссылка КАК Распоряжение,
	|	ДокЭтапПроизводства.Номер КАК РаспоряжениеНомер,
	|	ДокЭтапПроизводства.Дата КАК РаспоряжениеДата,
	|	ДокЭтапПроизводства.Организация КАК Организация,
	|	ДокЭтапПроизводства.Подразделение КАК Подразделение,
	|	ДокЭтапПроизводства.ВыпускПодДеятельность КАК ЗакупкаПодДеятельность,
	|	&Партнер КАК Партнер,
	|	ДокЭтапПроизводства.ПартияПроизводства.ОсновноеИзделиеНоменклатура КАК Номенклатура,
	|	ДокЭтапПроизводства.ПартияПроизводства.ОсновноеИзделиеХарактеристика КАК Характеристика,
	|	ВЫБОР
	|		КОГДА &ПланируютсяЭтапыПроизводства
	|				И НЕ ЭтапыПроизводства.ЭтапПроизводства ЕСТЬ NULL
	|			ТОГДА ЭтапыПроизводства.НачалоЭтапа
	|		КОГДА НормативныйГрафикСтруктурыЗаказа.Начало ЕСТЬ НЕ NULL
	|			ТОГДА НормативныйГрафикСтруктурыЗаказа.Начало
	|		ИНАЧЕ ДОБАВИТЬКДАТЕ(ДокЭтапПроизводства.Распоряжение.НачатьНеРанее, СЕКУНДА, ЕСТЬNULL(НормативныйЭтапыПроизводства.ДлительностьДоЗапуска, 0))
	|	КОНЕЦ КАК Начало,
	|	ДокЭтапПроизводства.НаименованиеЭтапа КАК ЭтапПредставление,
	|	ДокЭтапПроизводства.Спецификация.Представление КАК СпецификацияПредставление,
	|	ЕСТЬNULL(ДокЭтапПроизводства.Спецификация.МногоэтапныйПроизводственныйПроцесс, ЛОЖЬ) КАК МногоэтапныйПроизводственныйПроцесс,
	|	ВЫБОР
	|		КОГДА &ПланируютсяЭтапыПроизводства
	|				И НЕ ЭтапыПроизводства.ЭтапПроизводства ЕСТЬ NULL
	|			ТОГДА ЭтапыПроизводства.НачалоЭтапа < &ТекущаяДата
	|		КОГДА НормативныйГрафикСтруктурыЗаказа.Начало ЕСТЬ НЕ NULL
	|			ТОГДА НормативныйГрафикСтруктурыЗаказа.Начало < &ТекущаяДата
	|		ИНАЧЕ ДОБАВИТЬКДАТЕ(ДокЭтапПроизводства.Распоряжение.НачатьНеРанее, СЕКУНДА, ЕСТЬNULL(НормативныйЭтапыПроизводства.ДлительностьДоЗапуска, 0)) < &ТекущаяДата
	|	КОНЕЦ КАК ДатаЗапускаПросрочена,
	|	ДокЭтапПроизводства.НаправлениеДеятельности КАК НаправлениеДеятельности,
	|	ДокЭтапПроизводства.ВариантПриемкиТоваров КАК ВариантПриемкиТоваров,
	|	ДокЭтапПроизводства.ДинамическаяСтруктура КАК ДинамическаяСтруктура
	|ИЗ
	|	Документ.ЭтапПроизводства2_2 КАК ДокЭтапПроизводства
	|	
	|	ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ГрафикЭтаповПроизводства2_2 КАК ЭтапыПроизводства
	|	ПО (ЭтапыПроизводства.ЭтапПроизводства = ДокЭтапПроизводства.Ссылка)
	|		И (ЭтапыПроизводства.СтатусГрафика = &СтатусГрафика)
	|	
	|	ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НормативныйГрафикЭтаповПроизводства КАК НормативныйЭтапыПроизводства
	|	ПО ДокЭтапПроизводства.Ссылка = НормативныйЭтапыПроизводства.ЭтапПроизводства
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НормативныйГрафикСтруктурыЗаказа КАК НормативныйГрафикСтруктурыЗаказа
	|	ПО ДокЭтапПроизводства.Ссылка = НормативныйГрафикСтруктурыЗаказа.Этап
	|
	|ГДЕ
	|	ДокЭтапПроизводства.Ссылка В(&РаспоряженияЗаказа)
	|	И ДокЭтапПроизводства.ПроизводствоНаСтороне
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	// Этапы, не указанные в заказе
	|ВЫБРАТЬ
	|	ЛОЖЬ КАК Пометка,
	|	ДокЭтапПроизводства.Ссылка,
	|	ДокЭтапПроизводства.Номер,
	|	ДокЭтапПроизводства.Дата,
	|	ДокЭтапПроизводства.Организация КАК Организация,
	|	ДокЭтапПроизводства.Подразделение,
	|	ДокЭтапПроизводства.ВыпускПодДеятельность КАК ЗакупкаПодДеятельность,
	|	ДокЭтапПроизводства.Этап.Партнер,
	|	ДокЭтапПроизводства.ПартияПроизводства.ОсновноеИзделиеНоменклатура КАК Номенклатура,
	|	ДокЭтапПроизводства.ПартияПроизводства.ОсновноеИзделиеХарактеристика КАК Характеристика,
	|	ВЫБОР
	|		КОГДА &ПланируютсяЭтапыПроизводства
	|				И НЕ ЭтапыПроизводства.ЭтапПроизводства ЕСТЬ NULL
	|			ТОГДА ЭтапыПроизводства.НачалоЭтапа
	|		КОГДА НормативныйГрафикСтруктурыЗаказа.Начало ЕСТЬ НЕ NULL
	|			ТОГДА НормативныйГрафикСтруктурыЗаказа.Начало
	|		ИНАЧЕ ДОБАВИТЬКДАТЕ(ДокЭтапПроизводства.Распоряжение.НачатьНеРанее, СЕКУНДА, ЕСТЬNULL(НормативныйЭтапыПроизводства.ДлительностьДоЗапуска, 0))
	|	КОНЕЦ,
	|	ДокЭтапПроизводства.НаименованиеЭтапа,
	|	ДокЭтапПроизводства.Спецификация.Представление,
	|	ЕСТЬNULL(ДокЭтапПроизводства.Спецификация.МногоэтапныйПроизводственныйПроцесс, ЛОЖЬ),
	|	ВЫБОР
	|		КОГДА &ПланируютсяЭтапыПроизводства
	|				И НЕ ЭтапыПроизводства.ЭтапПроизводства ЕСТЬ NULL
	|			ТОГДА ЭтапыПроизводства.НачалоЭтапа < &ТекущаяДата
	|		КОГДА НормативныйГрафикСтруктурыЗаказа.Начало ЕСТЬ НЕ NULL
	|			ТОГДА НормативныйГрафикСтруктурыЗаказа.Начало < &ТекущаяДата
	|		ИНАЧЕ ДОБАВИТЬКДАТЕ(ДокЭтапПроизводства.Распоряжение.НачатьНеРанее, СЕКУНДА, ЕСТЬNULL(НормативныйЭтапыПроизводства.ДлительностьДоЗапуска, 0)) < &ТекущаяДата
	|	КОНЕЦ,
	|	ДокЭтапПроизводства.НаправлениеДеятельности,
	|	ДокЭтапПроизводства.ВариантПриемкиТоваров КАК ВариантПриемкиТоваров,
	|	ДокЭтапПроизводства.ДинамическаяСтруктура КАК ДинамическаяСтруктура
	|ИЗ
	|	Документ.ЭтапПроизводства2_2 КАК ДокЭтапПроизводства
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ГрафикЭтаповПроизводства2_2 КАК ЭтапыПроизводства
	|		ПО (ЭтапыПроизводства.ЭтапПроизводства = ДокЭтапПроизводства.Ссылка)
	|			И (ЭтапыПроизводства.СтатусГрафика = &СтатусГрафика)
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НормативныйГрафикЭтаповПроизводства КАК НормативныйЭтапыПроизводства
	|		ПО ДокЭтапПроизводства.Ссылка = НормативныйЭтапыПроизводства.ЭтапПроизводства
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НормативныйГрафикСтруктурыЗаказа КАК НормативныйГрафикСтруктурыЗаказа
	|		ПО ДокЭтапПроизводства.Ссылка = НормативныйГрафикСтруктурыЗаказа.Этап
	|ГДЕ
	|	НЕ &ЗапрещенВыборНовыхЭтапов
	|	И НЕ ДокЭтапПроизводства.Ссылка В (&РаспоряженияЗаказа)
	|	И НЕ ДокЭтапПроизводства.Статус В
	|		(ЗНАЧЕНИЕ(Перечисление.СтатусыЭтаповПроизводства2_2.Формируется),
	|		ЗНАЧЕНИЕ(Перечисление.СтатусыЭтаповПроизводства2_2.Сформирован))
	|	И ДокЭтапПроизводства.ПроизводствоНаСтороне
	|	И ДокЭтапПроизводства.Проведен
	|	И (&ДатаНачала = ДАТАВРЕМЯ(1, 1, 1)
	|			ИЛИ ВЫБОР
	|				КОГДА &ПланируютсяЭтапыПроизводства
	|						И НЕ ЭтапыПроизводства.ЭтапПроизводства ЕСТЬ NULL
	|					ТОГДА ЭтапыПроизводства.НачалоЭтапа
	|				ИНАЧЕ ДОБАВИТЬКДАТЕ(ДокЭтапПроизводства.Распоряжение.НачатьНеРанее, СЕКУНДА, ЕСТЬNULL(НормативныйЭтапыПроизводства.ДлительностьДоЗапуска, 0))
	|			КОНЕЦ >= &ДатаНачала)
	|	И (&ДатаОкончания = ДАТАВРЕМЯ(1, 1, 1)
	|			ИЛИ ВЫБОР
	|				КОГДА &ПланируютсяЭтапыПроизводства
	|						И НЕ ЭтапыПроизводства.ЭтапПроизводства ЕСТЬ NULL
	|					ТОГДА ЭтапыПроизводства.НачалоЭтапа
	|				ИНАЧЕ ДОБАВИТЬКДАТЕ(ДокЭтапПроизводства.Распоряжение.НачатьНеРанее, СЕКУНДА, ЕСТЬNULL(НормативныйЭтапыПроизводства.ДлительностьДоЗапуска, 0))
	|			КОНЕЦ <= &ДатаОкончания)
	|	И (ДокЭтапПроизводства.ЗаказПереработчику = НЕОПРЕДЕЛЕНО
	|			ИЛИ ДокЭтапПроизводства.ЗаказПереработчику = &ЗаказПереработчика)
	|	И (&Организация = ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)
	|			ИЛИ ДокЭтапПроизводства.Организация = &Организация)
	|	И (&Партнер = ЗНАЧЕНИЕ(Справочник.Партнеры.ПустаяСсылка)
	|			ИЛИ ДокЭтапПроизводства.Этап.Партнер = &Партнер
	|			ИЛИ ЕСТЬNULL(ДокЭтапПроизводства.Этап.Партнер, ЗНАЧЕНИЕ(Справочник.Партнеры.ПустаяСсылка)) = ЗНАЧЕНИЕ(Справочник.Партнеры.ПустаяСсылка))
	|	И (&Подразделение = ЗНАЧЕНИЕ(Справочник.СтруктураПредприятия.ПустаяСсылка)
	|			ИЛИ ДокЭтапПроизводства.Подразделение = &Подразделение)
	|	И (&ЗакупкаПодДеятельность = ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ПустаяСсылка)
	|			ИЛИ ДокЭтапПроизводства.ВыпускПодДеятельность = &ЗакупкаПодДеятельность)
	|	И (&НаправлениеДеятельности = ЗНАЧЕНИЕ(Справочник.НаправленияДеятельности.ПустаяСсылка)
	|			ИЛИ ДокЭтапПроизводства.НаправлениеДеятельности = &НаправлениеДеятельности)
	|	И (&ДинамическаяСтруктура = НЕОПРЕДЕЛЕНО
	|			ИЛИ ДокЭтапПроизводства.ДинамическаяСтруктура = &ДинамическаяСтруктура)
	|";
	
	ШаблонРаспоряжения = НСтр("ru = 'Этап № %1 от %2 (%3)';
								|en = 'Stage No. %1 dated %2 (%3)'");
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("ТекущаяДата",					ТекущаяДатаСеанса());
	Запрос.УстановитьПараметр("ЗаказПереработчика",				Параметры.ЗаказПереработчика);
	Запрос.УстановитьПараметр("Организация",					Параметры.Организация);
	Запрос.УстановитьПараметр("Партнер",						Параметры.Партнер);
	Запрос.УстановитьПараметр("Подразделение",					Параметры.Подразделение);
	Запрос.УстановитьПараметр("НаправлениеДеятельности",		Параметры.НаправлениеДеятельности);
	Запрос.УстановитьПараметр("ЗакупкаПодДеятельность",			Параметры.ЗакупкаПодДеятельность);
	Запрос.УстановитьПараметр("ЗапрещенВыборНовыхЭтапов",		ЗапрещенВыборНовыхЭтапов);
	Запрос.УстановитьПараметр("ДатаНачала",						ОтборПериод.ДатаНачала);
	Запрос.УстановитьПараметр("ДатаОкончания",					ОтборПериод.ДатаОкончания);
	Запрос.УстановитьПараметр("СтатусГрафика",					РегистрыСведений.ГрафикЭтаповПроизводства2_2.СтатусРабочийГрафик());
	Запрос.УстановитьПараметр("РаспоряженияЗаказа",				РаспоряженияЗаказа.ВыгрузитьЗначения());
	Запрос.УстановитьПараметр("ПланируютсяЭтапыПроизводства",	УправлениеПроизводством.ИспользуетсяГрафикПроизводства());
	Запрос.УстановитьПараметр("ДинамическаяСтруктура",			Параметры.ДинамическаяСтруктура);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		ДанныеСтроки = Распоряжения.Добавить();
		ЗаполнитьЗначенияСвойств(ДанныеСтроки, Выборка);
		
		СпецификацияСтрока =
			УправлениеДаннымиОбИзделияхКлиентСервер.ПредставлениеЭтапа(
				Выборка.СпецификацияПредставление,
				Выборка.ЭтапПредставление,
				Выборка.МногоэтапныйПроизводственныйПроцесс);
		
		Если Не ЗначениеЗаполнено(СпецификацияСтрока) Тогда
			СпецификацияСтрока = НСтр("ru = 'без спецификации';
										|en = 'without bill of materials'");
		КонецЕсли;
		
		ДанныеСтроки.РаспоряжениеПредставление =
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				ШаблонРаспоряжения,
				ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(Выборка.РаспоряжениеНомер, Ложь, Истина),
				Формат(Выборка.РаспоряжениеДата, "ДЛФ=D"),
				СпецификацияСтрока);
		
	КонецЦикла;
	
	Распоряжения.Сортировать("Пометка Убыв, Начало");
	
КонецПроцедуры

#КонецОбласти
