#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ПодборТоваровКлиентСервер.СформироватьЗаголовокФормыПодбора(Заголовок, Параметры.Документ);
	Параметры.Свойство("Организация", Организация);
	Параметры.Свойство("Подразделение", Подразделение);
	Параметры.Свойство("Назначение", Назначение);
	Параметры.Свойство("Дата", Дата);
	Параметры.Свойство("Документ", Документ);
	Параметры.Свойство("НаправлениеДеятельности", НаправлениеДеятельности);
	МассивКодовСтрок = Новый ФиксированныйМассив(Параметры.МассивКодовСтрок);
	
	ЗаполнитьТаблицуТоваров();
	УстановитьВидимость();
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если Модифицированность Тогда
		
		Если ЗавершениеРаботы Тогда
			
			ТекстПредупреждения = НСтр("ru = 'Данные были изменены.
				|Перед завершением работы рекомендуется сохранить изменения,
				|иначе измененные данные будут утеряны.';
				|en = 'Data has changed.
				|Save the changes before exiting, 
				|otherwise the changed data will be lost.'");
			
			Возврат;
			
		Иначе
			
			Отказ = Истина;
			ТекстВопроса       = НСтр("ru = 'Данные были изменены. Перенести изменения в документ?';
										|en = 'The data was modified. Migrate the changes to the document?'");
			ОписаниеОповещения = Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект);
			
			ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНетОтмена);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		ПеренестиСтрокиВДокумент();
	ИначеЕсли РезультатВопроса = КодВозвратаДиалога.Нет Тогда
		Модифицированность = Ложь;
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПеренестиВДокумент(Команда)
	
	ПеренестиСтрокиВДокумент();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьСтроки(Команда)

	ОтметитьСтроки(Истина);

КонецПроцедуры

&НаКлиенте
Процедура ИсключитьСтроки(Команда)

	ОтметитьСтроки(Ложь);

КонецПроцедуры

&НаКлиенте
Процедура РазвернутьПоДокументамВыпуска(Команда)
	
	РазвернутьТаблицуВыпуска = Не РазвернутьТаблицуВыпуска;
	Элементы.ТаблицаТоварыРазвернутьПоДокументамВыпуска.Пометка = РазвернутьТаблицуВыпуска;
	СвернутьРазвернутьТЧ("ТаблицаТовары", РазвернутьТаблицуВыпуска);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

&НаКлиенте
Процедура ТаблицаТоварыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Элементы.ТаблицаТовары.ТекущиеДанные <> Неопределено Тогда
		Если Поле.Имя = "ТаблицаТоварыДокументВыпуска" Тогда
			ПоказатьЗначение(Неопределено, Элементы.ТаблицаТовары.ТекущиеДанные.ДокументВыпуска);
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ТаблицаТоварыСтрокаВыбранаПриИзменении(Элемент)
	
	Если Не РазвернутьТаблицуВыпуска Тогда
		КолонкиПоиска = "Спецификация, Номенклатура, Характеристика, Назначение, Серия, Упаковка, ЕдиницаИзмерения, Подразделение";
		СтруктураОтбора = Новый Структура(КолонкиПоиска);
	Иначе
		КолонкиПоиска = "Спецификация, Номенклатура, Характеристика, Назначение, Серия, Упаковка, ЕдиницаИзмерения, Подразделение, ДокументВыпуска, КодСтроки";
		СтруктураОтбора = Новый Структура(КолонкиПоиска);
	КонецЕсли;
	ЗаполнитьЗначенияСвойств(СтруктураОтбора, Элементы.ТаблицаТовары.ТекущиеДанные);
	
	НайденныеСтроки = ТаблицаТовары.НайтиСтроки(СтруктураОтбора);
	Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл
		Если НЕ НайденнаяСтрока.ПрисутствуетВДокументе Тогда
			НайденнаяСтрока.СтрокаВыбрана = Элементы.ТаблицаТовары.ТекущиеДанные.СтрокаВыбрана;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПодразделениеПриИзменении(Элемент)
	
	Если Подразделение <> ПодразделениеПрежнее Тогда
		ЗаполнитьТаблицуТоваров();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПодразделениеОчистка(Элемент, СтандартнаяОбработка)
	
	ПодразделениеПрежнее = Подразделение;

КонецПроцедуры

&НаКлиенте
Процедура СпецификацияПриИзменении(Элемент)
	
	Если Спецификация <> СпецификацияПрежняя Тогда
		ЗаполнитьТаблицуТоваров();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СпецификацияОчистка(Элемент, СтандартнаяОбработка)
	
	СпецификацияПрежняя = Спецификация;

КонецПроцедуры

&НаКлиенте
Процедура ПодразделениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ПодразделениеПрежнее = Подразделение;
	
КонецПроцедуры

&НаКлиенте
Процедура СпецификацияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СпецификацияПрежняя = Спецификация;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	//
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТаблицаТовары.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ТаблицаТоварыСвернутая.ПрисутствуетВДокументе");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.Gray);
	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	
	//
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТаблицаТоварыДокументВыпуска.Имя);
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ГиперссылкаЦвет);
	
	//
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТаблицаТоварыДокументВыпуска.Имя);
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТаблицаТоварыКодСтроки.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("РазвернутьТаблицуВыпуска");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;

	Элемент.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТаблицаТоварыПредставлениеДокументаВыпуска.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("РазвернутьТаблицуВыпуска");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	Элемент.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);
	
	//
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТаблицаТоварыПредставлениеДокументаВыпуска.Имя);
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ПоясняющийТекст);

	//
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТаблицаТоварыДокументВыпуска.Имя);
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТаблицаТоварыКодСтроки.Имя);

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ГиперссылкаЦвет);
	
	//
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТаблицаТоварыСпецификация.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ТаблицаТоварыСвернутая.Спецификация");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ТекстЗапрещеннойЯчейкиЦвет);
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<без спецификации>';
																|en = '<without bill of materials>'"));
	
КонецПроцедуры

#Область Прочее

&НаСервере
Функция ПоместитьТоварыВХранилище()
	
	ПараметрыОтбора = Новый Структура();
	ПараметрыОтбора.Вставить("СтрокаВыбрана", Истина);
	
	ВыбранныеТовары = Новый Структура();
	ВыбранныеТовары.Вставить("Товары", ТаблицаТовары.Выгрузить(ПараметрыОтбора));
	
	АдресВХранилище = ПоместитьВоВременноеХранилище(ВыбранныеТовары);
	
	Возврат АдресВХранилище;
	
КонецФункции

&НаКлиенте
Процедура ПеренестиСтрокиВДокумент()
	
	Модифицированность = Ложь;
	АдресВХранилище    = ПоместитьТоварыВХранилище();
	
	Закрыть();
	
	СтруктураПередаваемыхДанных = Новый Структура();
	СтруктураПередаваемыхДанных.Вставить("ВыполняемаяОперация",              "ПодборВыходныхИзделий");
	СтруктураПередаваемыхДанных.Вставить("АдресВХранилище",                  АдресВХранилище);
	СтруктураПередаваемыхДанных.Вставить("РазвернутьВыпускиБезРаспоряжения", РазвернутьТаблицуВыпуска);
	
	ОповеститьОВыборе(СтруктураПередаваемыхДанных);
	
КонецПроцедуры

&НаСервере
Процедура ОтметитьСтроки(Значение)

	Если Не РазвернутьТаблицуВыпуска Тогда
		КолонкиПоиска = "Спецификация, Номенклатура, Характеристика, Назначение, Серия, Упаковка, ЕдиницаИзмерения, Подразделение";
		СтруктураОтбора = Новый Структура(КолонкиПоиска);
	Иначе
		КолонкиПоиска = "Спецификация, Номенклатура, Характеристика, Назначение, Серия, Упаковка, ЕдиницаИзмерения, Подразделение, ДокументВыпуска, КодСтроки";
		СтруктураОтбора = Новый Структура(КолонкиПоиска);
	КонецЕсли;
	
	Для Каждого СтрокаТЧ Из ТаблицаТоварыСвернутая.НайтиСтроки(Новый Структура("СтрокаВыбрана", Не Значение)) Цикл

		СтрокаТЧ.СтрокаВыбрана = Значение;
		
		ЗаполнитьЗначенияСвойств(СтруктураОтбора, СтрокаТЧ);
		
		НайденныеСтроки = ТаблицаТовары.НайтиСтроки(СтруктураОтбора);
		Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл
			Если НЕ НайденнаяСтрока.ПрисутствуетВДокументе Тогда
				НайденнаяСтрока.СтрокаВыбрана = СтрокаТЧ.СтрокаВыбрана;
			КонецЕсли;
		КонецЦикла;

	КонецЦикла;

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицуТоваров()
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	ВыпускПродукцииТовары.Спецификация,
	|	ВыпускПродукцииТовары.Номенклатура,
	|	ВыпускПродукцииТовары.Характеристика,
	|	ВыпускПродукцииТовары.Назначение,
	|	ВыпускПродукцииТовары.Серия,
	|	ВыпускПродукцииТовары.Упаковка, 
	|	ВыпускПродукцииТовары.Номенклатура.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	ВыпускПродукцииТовары.КоличествоУпаковок,
	|	ВыпускПродукции.Ссылка КАК ДокументВыпуска,
	|	ВыпускПродукцииТовары.КодСтроки,
	|	ВыпускПродукции.Подразделение
	|ИЗ
	|	Документ.ВыпускПродукции.Товары КАК ВыпускПродукцииТовары
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ВыпускПродукции КАК ВыпускПродукции
	|		ПО ВыпускПродукцииТовары.Ссылка = ВыпускПродукции.Ссылка
	|			И (ВыпускПродукцииТовары.ТипСтоимости = ЗНАЧЕНИЕ(Перечисление.ТипыСтоимостиВыходныхИзделий.Рассчитывается))
	|			И (ВыпускПродукции.Дата МЕЖДУ &ДатаНачала И &ДатаОкончания)
	|			И ВыпускПродукции.Организация = &Организация
	|			И (ВыпускПродукции.Подразделение = &Подразделение ИЛИ &ПоВсемПодразделениям)
	|			И (ВыпускПродукцииТовары.Спецификация = &Спецификация ИЛИ &ПоВсемСпецификациям)
	|			И (ВыпускПродукцииТовары.Назначение = &Назначение ИЛИ &ПоВсемНазначениям)
	|			И (ВыпускПродукцииТовары.Назначение.НаправлениеДеятельности = &НаправлениеДеятельности ИЛИ &ПоВсемНаправлениямДеятельности)
	|			И НЕ ВыпускПродукции.ВыпускПоРаспоряжениям
	|			И ВыпускПродукции.Проведен");
	
	Запрос.УстановитьПараметр("ДатаНачала", ?(ЗначениеЗаполнено(Дата), НачалоМесяца(Дата), НачалоМесяца(ТекущаяДатаСеанса())));
	Запрос.УстановитьПараметр("ДатаОкончания", ?(ЗначениеЗаполнено(Дата), КонецМесяца(Дата), КонецМесяца(ТекущаяДатаСеанса())));
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Подразделение", Подразделение);
	Запрос.УстановитьПараметр("ПоВсемПодразделениям", НЕ ЗначениеЗаполнено(Подразделение));
	Запрос.УстановитьПараметр("Спецификация", Спецификация);
	Запрос.УстановитьПараметр("ПоВсемСпецификациям", НЕ ЗначениеЗаполнено(Спецификация));
	Запрос.УстановитьПараметр("Назначение", Назначение);
	Запрос.УстановитьПараметр("ПоВсемНазначениям", НЕ ЗначениеЗаполнено(Назначение));
	Запрос.УстановитьПараметр("НаправлениеДеятельности", НаправлениеДеятельности);
	Запрос.УстановитьПараметр("ПоВсемНаправлениямДеятельности", Не ЗначениеЗаполнено(НаправлениеДеятельности));
	
	Выборка = Запрос.Выполнить().Выбрать();
	ТаблицаТовары.Очистить();
	ТаблицаТоварыСвернутая.Очистить();
	
	Пока Выборка.Следующий() Цикл
		ЗаполнитьЗначенияСвойств(ТаблицаТовары.Добавить(), Выборка);
	КонецЦикла;
	
	УстановитьПризнакиПрисутствияСтрокиВДокументе(ТаблицаТовары, "ДокументВыпуска", МассивКодовСтрок);
	
	СвернутьРазвернутьТЧ("ТаблицаТовары", РазвернутьТаблицуВыпуска);
	
КонецПроцедуры

&НаСервере
Процедура СвернутьРазвернутьТЧ(ИмяТЧ, Развернуть = Ложь)
	
	Если Не Развернуть Тогда
		
		КолонкиГруппировок = "Спецификация, Номенклатура, Характеристика, Назначение, Серия, Упаковка, ЕдиницаИзмерения, Подразделение";
		КолонкиСуммирования = "КоличествоУпаковок";
		
		ТаблицаЗначений = ЭтаФорма[ИмяТЧ].Выгрузить(,КолонкиГруппировок + ", " + КолонкиСуммирования); // ТаблицаЗначений
		ТаблицаЗначений.Свернуть(КолонкиГруппировок, КолонкиСуммирования);
		
		ЭтаФорма[ИмяТЧ + "Свернутая"].Загрузить(ТаблицаЗначений);
		
		СтруктураОтбора = Новый Структура(КолонкиГруппировок);
		ШаблонПредставления = НСтр("ru = 'Всего документов: %1';
									|en = 'Total documents: %1'");
		
		Для Каждого Строка Из ЭтаФорма[ИмяТЧ + "Свернутая"] Цикл
			
			ЗаполнитьЗначенияСвойств(СтруктураОтбора, Строка);
			НайденныеСтроки = ЭтаФорма[ИмяТЧ].НайтиСтроки(СтруктураОтбора);
			КоличествоВыбранныхСтрок = 0;
			КоличествоСтрокПрисутствующихВДокументе = 0;
			Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл
				Если НайденнаяСтрока.СтрокаВыбрана Тогда
					КоличествоВыбранныхСтрок = КоличествоВыбранныхСтрок + 1;
				КонецЕсли;
				Если НайденнаяСтрока.ПрисутствуетВДокументе Тогда
					КоличествоСтрокПрисутствующихВДокументе = КоличествоСтрокПрисутствующихВДокументе + 1;
				КонецЕсли;
			КонецЦикла;
			
			Строка.СтрокаВыбрана = (НайденныеСтроки.Количество() = КоличествоВыбранныхСтрок);
			Строка.ПрисутствуетВДокументе = (НайденныеСтроки.Количество() = КоличествоСтрокПрисутствующихВДокументе);
			
			Строка.ПредставлениеДокументаВыпуска = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				ШаблонПредставления,
				НайденныеСтроки.Количество());
			
		КонецЦикла;
	
	Иначе
		
		ЭтаФорма[ИмяТЧ + "Свернутая"].Загрузить(ЭтаФорма[ИмяТЧ].Выгрузить());
		
	КонецЕсли;
	
	ЗаполнитьСлужебныеРеквизитыПоНоменклатуре(ИмяТЧ);
	ЗаполнитьСлужебныеРеквизитыПоНоменклатуре(ИмяТЧ + "Свернутая");

	НомерСтроки = 1;
	Для Каждого Строка Из ТаблицаТоварыСвернутая Цикл
		Строка.НомерСтроки = НомерСтроки;
		НомерСтроки = НомерСтроки + 1;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСлужебныеРеквизитыПоНоменклатуре(ИмяТЧ)
	
	ПараметрыЗаполненияРеквизитов = Новый Структура;
	ПараметрыЗаполненияРеквизитов.Вставить("ЗаполнитьПризнакХарактеристикиИспользуются",
		Новый Структура("Номенклатура", "ХарактеристикиИспользуются"));
	
	ПараметрыЗаполненияРеквизитов.Вставить("ЗаполнитьПризнакТипНоменклатуры",
		Новый Структура("Номенклатура", "ТипНоменклатуры"));
	
	НоменклатураСервер.ЗаполнитьСлужебныеРеквизитыПоНоменклатуреВКоллекции(ЭтаФорма[ИмяТЧ], ПараметрыЗаполненияРеквизитов);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьПризнакиПрисутствияСтрокиВДокументе(ТаблицаТовары, ИмяЗаказаВТабличнойЧасти, МассивКодовСтрок, ИмяРеквизитаКодСтроки = "КодСтроки")

	Для Каждого СтрокаТаб Из ТаблицаТовары Цикл
	
		СтрокаТаб.ПрисутствуетВДокументе = Ложь;
		
		Для Каждого ТекСтрока Из МассивКодовСтрок Цикл
			
			Если ТекСтрока[ИмяРеквизитаКодСтроки] = СтрокаТаб[ИмяРеквизитаКодСтроки] 
				И ТекСтрока[ИмяЗаказаВТабличнойЧасти] = СтрокаТаб[ИмяЗаказаВТабличнойЧасти] Тогда
				
				СтрокаТаб.ПрисутствуетВДокументе = Истина;
				Прервать;
				
			КонецЕсли;
			
		КонецЦикла;
		
		СтрокаТаб.СтрокаВыбрана = СтрокаТаб.ПрисутствуетВДокументе;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимость()
	
	Если (ТипЗнч(Документ) = Тип("ДокументСсылка.РаспределениеПроизводственныхЗатрат")) Тогда
		
		Элементы.Подразделение.Видимость =Ложь;
		Элементы.Спецификация.Заголовок = НСтр("ru = 'Показывать продукцию, выпущенную по спецификации';
												|en = 'Show the products released by bill of materials'");
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти