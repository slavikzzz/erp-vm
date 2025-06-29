
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураБыстрогоОтбора = Неопределено;
	Параметры.Свойство("СтруктураБыстрогоОтбора", СтруктураБыстрогоОтбора);
	
	ОтборыСписковКлиентСервер.ОтборПоЗначениюСпискаПриСозданииНаСервере(Список, "Ответственный", Ответственный, СтруктураБыстрогоОтбора);
	
	ОбновитьРаспоряженияНаСервере();
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец ИнтеграцияС1СДокументооборотом
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	ОтборыСписковКлиентСервер.ОтборПоЗначениюСпискаПриЗагрузкеИзНастроек(Список, "Ответственный", Ответственный, СтруктураБыстрогоОтбора, Настройки);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОтветственныйПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Ответственный", Ответственный, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(Ответственный));
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодРаспоряженийПриИзменении(Элемент)
	
	ПрименитьОтборРаспоряжений();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборРаспоряженийКлассПриИзменении(Элемент)
	
	ПрименитьОтборРаспоряжений();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборРаспоряженийЭксплуатирующееПодразделениеПриИзменении(Элемент)
	
	ПрименитьОтборРаспоряжений();
	
КонецПроцедуры

&НаКлиенте
Процедура РаспоряженияВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле = Элементы.РаспоряженияПредставление Тогда
		ПоказатьЗначение(Неопределено, Распоряжения.НайтиПоИдентификатору(ВыбраннаяСтрока).ОбъектЭксплуатации);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура СоздатьРегистрациюНаработок(Команда)
	
	СоздатьРегистрациюНаработокПоСпискуРаспоряжений();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьРаспоряжения(Команда)
	ОбновитьРаспоряженияНаСервере();
КонецПроцедуры

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(
		Команда,
		ЭтотОбъект,
		Элементы.Список);
	
КонецПроцедуры
// Конец ИнтеграцияС1СДокументооборотом

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
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.РаспоряженияПредставление.Имя);
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.РаспоряженияПоказательНаработки.Имя);
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.РаспоряженияДнейПросрочено.Имя);
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.РаспоряженияДатаПоследнейРегистрации.Имя);
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.РаспоряженияДатаСледующейРегистрации.Имя);
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.РаспоряженияКласс.Имя);
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.РаспоряженияЭксплуатирующееПодразделение.Имя);
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.РаспоряженияПериодичность.Имя);
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.РаспоряженияВидПериодичности.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Распоряжения.Просрочено");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ПросроченныеДанныеЦвет);
	
	СтандартныеПодсистемыСервер.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "Список.Дата", Элементы.Дата.Имя);
	
КонецПроцедуры 

&НаКлиенте
Процедура СоздатьРегистрациюНаработокПоСпискуРаспоряжений()
	
	ТекущиеДанные = Элементы.Распоряжения.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		
		ТекстПредупреждения = НСтр("ru = 'Команда не может быть выполнена для указанного объекта';
									|en = 'Cannot execute the command for the specified object'");
		ПоказатьПредупреждение(Неопределено, ТекстПредупреждения);
		Возврат;
		
	КонецЕсли;
	
	ПоляСтруктурыРаспоряжений = "ОбъектЭксплуатации, ПоказательНаработки";
	
	Если Элементы.Распоряжения.ВыделенныеСтроки.Количество() = 0 Тогда
		
		ТекстПредупреждения = НСтр("ru = 'Команда не может быть выполнена для указанного объекта';
									|en = 'Cannot execute the command for the specified object'");
		ПоказатьПредупреждение(Неопределено, ТекстПредупреждения);
		Возврат;
		
	Иначе
		
		МассивРаспоряжений = Новый Массив();
		
		Для Каждого Строка Из Элементы.Распоряжения.ВыделенныеСтроки Цикл
		
			Если ТипЗнч(Строка) = Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
				Продолжить;
			КонецЕсли;
			
			СтруктураРаспоряжения = Новый Структура(ПоляСтруктурыРаспоряжений);
			ЗаполнитьЗначенияСвойств(СтруктураРаспоряжения, Распоряжения.НайтиПоИдентификатору(Строка));
			МассивРаспоряжений.Добавить(СтруктураРаспоряжения);
			
		КонецЦикла;
		
		Если МассивРаспоряжений.Количество() = 0 Тогда
			
			ТекстПредупреждения = НСтр("ru = 'Команда не может быть выполнена для указанного объекта';
										|en = 'Cannot execute the command for the specified object'");
			ПоказатьПредупреждение(Неопределено, ТекстПредупреждения);
			Возврат;
			
		КонецЕсли;
		
		ОчиститьСообщения();
		
		ПараметрыОснования = Новый Структура();
		ПараметрыОснования.Вставить("ДокументОснование", МассивРаспоряжений);
		
		ОткрытьФорму(
			"Документ.НаработкаОбъектовЭксплуатации.Форма.ФормаДокумента",
			Новый Структура("Основание", ПараметрыОснования));
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПрименитьОтборРаспоряжений()
	
	СтруктураОтбора = Новый Структура;
	
	Если ЗначениеЗаполнено(ПериодРаспоряжений) Тогда
		Если ПериодРаспоряжений = 1 Тогда
			СтруктураОтбора.Вставить("Просрочено", Истина);
		ИначеЕсли ПериодРаспоряжений = 2 Тогда
			СтруктураОтбора.Вставить("ЭтотДень", Истина);
		ИначеЕсли ПериодРаспоряжений = 3 Тогда
			СтруктураОтбора.Вставить("ЭтаНеделя", Истина);
		ИначеЕсли ПериодРаспоряжений = 4 Тогда
			СтруктураОтбора.Вставить("ЭтотМесяц", Истина);
		КонецЕсли;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ОтборРаспоряженийКласс) Тогда
		СтруктураОтбора.Вставить("Класс", ОтборРаспоряженийКласс);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ОтборРаспоряженийЭксплуатирующееПодразделение) Тогда
		СтруктураОтбора.Вставить("ЭксплуатирующееПодразделение", ОтборРаспоряженийЭксплуатирующееПодразделение);
	КонецЕсли;
	
	Элементы.Распоряжения.ОтборСтрок = Новый ФиксированнаяСтруктура(СтруктураОтбора);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьРаспоряженияНаСервере()
	
	Запрос = Новый Запрос(ТекстЗапросаРаспоряжений());
	
	СпособыНачисленияАмортизации = Новый Массив;
	СпособыНачисленияАмортизации.Добавить(Перечисления.СпособыНачисленияАмортизацииОС.ПропорциональноОбъемуПродукции);
	СпособыНачисленияАмортизации.Добавить(Перечисления.СпособыНачисленияАмортизацииОС.ПоЕНАОФНа1000кмПробега);
	
	Запрос.УстановитьПараметр("СпособыНачисленияАмортизации", СпособыНачисленияАмортизации);
	Запрос.УстановитьПараметр("ТекущаяДата", ТекущаяДатаСеанса());
	Запрос.УстановитьПараметр("ИспользоватьУправлениеРемонтами", ПолучитьФункциональнуюОпцию("ИспользоватьУправлениеРемонтами"));
	Запрос.УстановитьПараметр("ИспользоватьУзлыОбъектовЭксплуатации", ПолучитьФункциональнуюОпцию("ИспользоватьУзлыОбъектовЭксплуатации"));
	Запрос.УстановитьПараметр("ИспользуетсяУправлениеВНА_2_4", ВнеоборотныеАктивы.ИспользуетсяУправлениеВНА_2_4());
	
	УстановитьПривилегированныйРежим(Истина);
	Распоряжения.Загрузить(Запрос.Выполнить().Выгрузить());
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

&НаСервере
Функция ТекстЗапросаРаспоряжений()
	
	МассивЗапросов = Новый Массив;
	
	ТекстЗапроса = РегистрацияНаработокЛокализация.ТекстЗапросаПоказателиРегл();
	
	Если ТекстЗапроса = Неопределено Тогда
		
		ТекстЗапроса =
		"ВЫБРАТЬ
		|	ПорядокУчетаОСБУ.ОсновноеСредство КАК ОсновноеСредство
		|ПОМЕСТИТЬ СписокПоНаработке
		|ИЗ
		|	РегистрСведений.ПараметрыАмортизацииОСУУ.СрезПоследних(&ТекущаяДата, ДатаИсправления = ДАТАВРЕМЯ(1,1,1)) КАК ПорядокУчетаОСБУ
		|ГДЕ
		|	ПорядокУчетаОСБУ.МетодНачисленияАмортизации В(&СпособыНачисленияАмортизации)
		|	И &ИспользуетсяУправлениеВНА_2_4
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	ОсновноеСредство
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ПорядокУчетаОСУУ.ОсновноеСредство КАК ОсновноеСредство
		|ПОМЕСТИТЬ ПринятыеКУчетуОС
		|ИЗ
		|	РегистрСведений.ПорядокУчетаОСУУ.СрезПоследних(
		|			&ТекущаяДата,
		|			ДатаИсправления = ДАТАВРЕМЯ(1,1,1)
		|				И ОсновноеСредство В
		|					(ВЫБРАТЬ
		|						СписокПоНаработке.ОсновноеСредство
		|					ИЗ
		|						СписокПоНаработке)) КАК ПорядокУчетаОСУУ
		|ГДЕ
		|	ПорядокУчетаОСУУ.Состояние = ЗНАЧЕНИЕ(Перечисление.СостоянияОС.ПринятоКУчету)
		|	И ВЫБОР
		|			КОГДА &ИспользоватьУправлениеРемонтами
		|				ТОГДА ПорядокУчетаОСУУ.ОсновноеСредство.Статус В (ЗНАЧЕНИЕ(Перечисление.СтатусыОбъектовЭксплуатации.ВЭксплуатации))
		|			ИНАЧЕ ИСТИНА
		|		КОНЕЦ
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	ОсновноеСредство
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ПорядокУчетаОС.ОсновноеСредство КАК ОбъектЭксплуатации,
		|	ПРЕДСТАВЛЕНИЕ(ПорядокУчетаОС.ОсновноеСредство) КАК Представление,
		|	ПорядокУчетаОС.ПоказательНаработки КАК ПоказательНаработки,
		|	1 КАК Периодичность,
		|	1 КАК ВидПериодичности
		|ПОМЕСТИТЬ ПоказателиРегл
		|ИЗ
		|	РегистрСведений.ПорядокУчетаОС.СрезПоследних(
		|			&ТекущаяДата,
		|			ДатаИсправления = ДАТАВРЕМЯ(1,1,1)
		|				И ОсновноеСредство В
		|					(ВЫБРАТЬ
		|						ПринятыеКУчетуОС.ОсновноеСредство
		|					ИЗ
		|						ПринятыеКУчетуОС)) КАК ПорядокУчетаОС
		|ГДЕ
		|	ПорядокУчетаОС.ПоказательНаработки <> ЗНАЧЕНИЕ(Справочник.ПоказателиНаработки.ПустаяСсылка)";
		
	КонецЕсли; 
	
	МассивЗапросов.Добавить(ТекстЗапроса);

	ТекстЗапроса = "
	//++ НЕ УТКА
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Объекты.Ссылка КАК ОбъектЭксплуатации,
	|	ПРЕДСТАВЛЕНИЕ(Объекты.Ссылка) КАК Представление,
	|	ПоказателиНаработкиКласса.ПоказательНаработки КАК ПоказательНаработки,
	|	ПоказателиНаработкиКласса.ПериодичностьРегистрации КАК Периодичность,
	|	0 КАК ВидПериодичности,
	|	ПоказателиНаработкиКласса.РегистрироватьОтИсточника КАК РегистрироватьОтИсточника
	|ПОМЕСТИТЬ ПоказателиРем
	|ИЗ
	|	Справочник.ОбъектыЭксплуатации КАК Объекты
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.КлассыОбъектовЭксплуатации.ПоказателиНаработки КАК ПоказателиНаработкиКласса
	|		ПО Объекты.Класс = ПоказателиНаработкиКласса.Ссылка
	|ГДЕ
	|	ПоказателиНаработкиКласса.ПериодичностьРегистрации <> 0
	|	И Объекты.Статус В (ЗНАЧЕНИЕ(Перечисление.СтатусыОбъектовЭксплуатации.ВЭксплуатации))
	|	И &ИспользоватьУправлениеРемонтами
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	Узлы.Ссылка,
	|	Узлы.Принадлежность,
	|	ПоказателиНаработкиКласса.ПоказательНаработки,
	|	ПоказателиНаработкиКласса.ПериодичностьРегистрации,
	|	0,
	|	ПоказателиНаработкиКласса.РегистрироватьОтИсточника
	|ИЗ
	|	Справочник.УзлыОбъектовЭксплуатации КАК Узлы
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.КлассыОбъектовЭксплуатации.ПоказателиНаработки КАК ПоказателиНаработкиКласса
	|		ПО Узлы.Класс = ПоказателиНаработкиКласса.Ссылка
	|ГДЕ
	|	ПоказателиНаработкиКласса.ПериодичностьРегистрации <> 0
	|	И Узлы.Владелец <> ЗНАЧЕНИЕ(Справочник.ОбъектыЭксплуатации.ПустаяСсылка)
	|	И Узлы.Статус В (ЗНАЧЕНИЕ(Перечисление.СтатусыОбъектовЭксплуатации.ВЭксплуатации))
	|	И &ИспользоватьУзлыОбъектовЭксплуатации
	|;
	//-- НЕ УТКА
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПоказателиРегл.ОбъектЭксплуатации КАК ОбъектЭксплуатации,
	|	ПоказателиРегл.Представление КАК Представление,
	|	ПоказателиРегл.ПоказательНаработки КАК ПоказательНаработки,
	|	ПоказателиРегл.Периодичность КАК ПериодичностьРегистрации,
	|	ПоказателиРегл.ВидПериодичности КАК ВидПериодичности
	|ПОМЕСТИТЬ Показатели
	|ИЗ
	|	ПоказателиРегл КАК ПоказателиРегл
	//++ НЕ УТКА
	|		ЛЕВОЕ СОЕДИНЕНИЕ ПоказателиРем КАК ПоказателиРем
	|		ПО ПоказателиРегл.ОбъектЭксплуатации = ПоказателиРем.ОбъектЭксплуатации
	|			И ПоказателиРегл.ПоказательНаработки = ПоказателиРем.ПоказательНаработки
	|ГДЕ
	|	ПоказателиРем.ОбъектЭксплуатации ЕСТЬ NULL 
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ПоказателиРем.ОбъектЭксплуатации,
	|	ПоказателиРем.Представление,
	|	ПоказателиРем.ПоказательНаработки,
	|	ПоказателиРем.Периодичность,
	|	ПоказателиРем.ВидПериодичности
	|ИЗ
	|	ПоказателиРем КАК ПоказателиРем
	|ГДЕ
	|	НЕ ПоказателиРем.РегистрироватьОтИсточника
	//-- НЕ УТКА
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Показатели.ОбъектЭксплуатации,
	|	Показатели.Представление,
	|	Показатели.ПоказательНаработки,
	|	ЕСТЬNULL(НаработкиСрезПоследних.Период, НЕОПРЕДЕЛЕНО) КАК ДатаПоследнейРегистрации,
	|	ВЫБОР
	|		КОГДА НаработкиСрезПоследних.Период ЕСТЬ NULL 
	|			ТОГДА &ТекущаяДата
	|		КОГДА Показатели.ВидПериодичности = 1
	|			ТОГДА ДОБАВИТЬКДАТЕ(НаработкиСрезПоследних.Период, МЕСЯЦ, Показатели.ПериодичностьРегистрации)
	|		ИНАЧЕ ДОБАВИТЬКДАТЕ(НаработкиСрезПоследних.Период, ДЕНЬ, Показатели.ПериодичностьРегистрации)
	|	КОНЕЦ КАК ДатаСледующейРегистрации,
	|	ВЫБОР
	|		КОГДА НаработкиСрезПоследних.Период ЕСТЬ NULL 
	|			ТОГДА 0
	|		КОГДА Показатели.ВидПериодичности = 1
	|			ТОГДА РАЗНОСТЬДАТ(ДОБАВИТЬКДАТЕ(НаработкиСрезПоследних.Период, МЕСЯЦ, Показатели.ПериодичностьРегистрации), &ТекущаяДата, ДЕНЬ)
	|		ИНАЧЕ РАЗНОСТЬДАТ(ДОБАВИТЬКДАТЕ(НаработкиСрезПоследних.Период, ДЕНЬ, Показатели.ПериодичностьРегистрации), &ТекущаяДата, ДЕНЬ)
	|	КОНЕЦ КАК ДнейПросрочено,
	|	Показатели.ОбъектЭксплуатации.Класс КАК Класс,
	|	Показатели.ОбъектЭксплуатации.ЭксплуатирующееПодразделение КАК ЭксплуатирующееПодразделение,
	|	Показатели.ПериодичностьРегистрации КАК Периодичность,
	|	Показатели.ВидПериодичности
	|ПОМЕСТИТЬ Распоряжения
	|ИЗ
	|	Показатели КАК Показатели
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НаработкиОбъектовЭксплуатации.СрезПоследних(
	|				&ТекущаяДата,
	|				(ОбъектЭксплуатации, ПоказательНаработки) В
	|					(ВЫБРАТЬ
	|						Показатели.ОбъектЭксплуатации,
	|						Показатели.ПоказательНаработки
	|					ИЗ
	|						Показатели КАК Показатели)) КАК НаработкиСрезПоследних
	|		ПО Показатели.ОбъектЭксплуатации = НаработкиСрезПоследних.ОбъектЭксплуатации
	|			И Показатели.ПоказательНаработки = НаработкиСрезПоследних.ПоказательНаработки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Распоряжения.ОбъектЭксплуатации,
	|	Распоряжения.Представление,
	|	Распоряжения.ПоказательНаработки,
	|	Распоряжения.ДатаПоследнейРегистрации,
	|	Распоряжения.ДатаСледующейРегистрации,
	|	Распоряжения.ДнейПросрочено,
	|	Распоряжения.Класс,
	|	Распоряжения.ЭксплуатирующееПодразделение,
	|	Распоряжения.Периодичность,
	|	Распоряжения.ВидПериодичности,
	|	ВЫБОР
	|		КОГДА Распоряжения.ДнейПросрочено > 0
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК Просрочено,
	|	ВЫБОР
	|		КОГДА НАЧАЛОПЕРИОДА(Распоряжения.ДатаСледующейРегистрации, ДЕНЬ) = НАЧАЛОПЕРИОДА(&ТекущаяДата, ДЕНЬ)
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ЭтотДень,
	|	ВЫБОР
	|		КОГДА НАЧАЛОПЕРИОДА(Распоряжения.ДатаСледующейРегистрации, НЕДЕЛЯ) = НАЧАЛОПЕРИОДА(&ТекущаяДата, НЕДЕЛЯ)
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ЭтаНеделя,
	|	ВЫБОР
	|		КОГДА НАЧАЛОПЕРИОДА(Распоряжения.ДатаСледующейРегистрации, МЕСЯЦ) = НАЧАЛОПЕРИОДА(&ТекущаяДата, МЕСЯЦ)
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ЭтотМесяц
	|ИЗ
	|	Распоряжения КАК Распоряжения";
	
	МассивЗапросов.Добавить(ТекстЗапроса);
	
	ТекстЗапроса = СтрСоединить(МассивЗапросов, ОбщегоНазначения.РазделительПакетаЗапросов());
	
	Возврат ТекстЗапроса;
	
КонецФункции

#КонецОбласти
