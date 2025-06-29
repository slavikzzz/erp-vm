//++ Устарело_Производство21
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	//++ НЕ УТКА
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Параметры.Свойство("НаправлениеВыпуска", НаправлениеВыпуска);
	
	ЗаполнитьТаблицуТоваров(); // Данные отбора возьмет из Параметры
	ПодборТоваровКлиентСервер.СформироватьЗаголовокФормыПодбора(Заголовок, Параметры.Документ);
	
	ВидимостьОтбораПоРЦ = (НЕ Параметры.Подразделение.Пустая());
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ОтборРабочийЦентр", "Видимость", ВидимостьОтбораПоРЦ);
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	//-- НЕ УТКА
	
	Возврат; // пустой обработчик
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	//++ НЕ УТКА
	
	Если Модифицированность Тогда
		
		Если ЗавершениеРаботы Тогда
			Отказ = Истина;
			ТекстПредупреждения = НСтр("ru = 'Данные в форме были изменены.
											|Можно продолжить работу и сохранить изменения, 
											|либо завершить работу без сохранения изменений.';
											|en = 'Data in the form was changed. 
											|You can continue working and save the changes
											|or close the form without saving changes.'");
			Возврат;
		КонецЕсли; 
	
		Отказ = Истина;
		ТекстВопроса = НСтр("ru = 'Данные были изменены. Перенести изменения в документ?';
							|en = 'The data was modified. Migrate the changes to the document?'");
		ОписаниеОповещения = Новый ОписаниеОповещения("ОбработкаПередЗакрытием", ЭтотОбъект);
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНетОтмена);
		
	КонецЕсли;
	//-- НЕ УТКА
	
	Возврат; // пустой обработчик
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтборРабочийЦентрПриИзменении(Элемент)
	
	//++ НЕ УТКА
	ЗаполнитьТаблицуТоваров(); // Данные отбора возьмет из Параметры

	//-- НЕ УТКА
	
	Возврат; // пустой обработчик
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТаблицаТоваров

&НаКлиенте
Процедура ТаблицаТоваровВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	//++ НЕ УТКА
	Если Элементы.ТаблицаТоваров.ТекущиеДанные <> Неопределено Тогда
		Если Поле.Имя = "Распоряжение" Тогда
			СтандартнаяОбработка = Ложь;
			ПоказатьЗначение(,Элементы.ТаблицаТоваров.ТекущиеДанные.Распоряжение);
		КонецЕсли;
	КонецЕсли;
	//-- НЕ УТКА
	
	Возврат; // пустой обработчик
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПеренестиВДокумент(Команда)
	
	//++ НЕ УТКА
	ПеренестиСтрокиВДокумент();
	//-- НЕ УТКА
	
	Возврат; // пустой обработчик
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьСтроки(Команда)
	
	//++ НЕ УТКА
	ВыбратьВсеСтрокиНаСервере(Истина);
	//-- НЕ УТКА
	
	Возврат; // пустой обработчик
	
КонецПроцедуры

&НаКлиенте
Процедура ИсключитьСтроки(Команда)
	
	//++ НЕ УТКА
	ВыбратьВсеСтрокиНаСервере(Ложь);
	//-- НЕ УТКА
	
	Возврат; // пустой обработчик
	
КонецПроцедуры

//++ НЕ УТКА

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

//-- НЕ УТКА

#КонецОбласти

//++ НЕ УТКА

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	НоменклатураСервер.УстановитьУсловноеОформлениеЕдиницИзмерения(ЭтаФорма, "НоменклатураЕдиницаИзмерения", "ТаблицаТоваров.Упаковка");
	
	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТаблицаТоваров.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ТаблицаТоваров.ПрисутствуетВДокументе");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.Gray);

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Распоряжение.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ТаблицаТоваров.Распоряжение");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено;
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ГиперссылкаЦвет);

	//
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Склад.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("НаправлениеВыпуска");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.ХозяйственныеОперации.ВыпускПродукцииВПодразделение;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);
	
	//
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Подразделение.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("НаправлениеВыпуска");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.ХозяйственныеОперации.ВыпускПродукцииНаСклад;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);

	//
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Назначение.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ТаблицаТоваров.Назначение");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<без назначения>';
																|en = '<No assignment>'"));

КонецПроцедуры

&НаСервере
Процедура ВыбратьВсеСтрокиНаСервере(ЗначениеВыбора = Истина)
	
	Для Каждого СтрокаТаблицы Из ТаблицаТоваров.НайтиСтроки(Новый Структура("СтрокаВыбрана", Не ЗначениеВыбора)) Цикл
		
		СтрокаТаблицы.СтрокаВыбрана = ЗначениеВыбора;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ПоместитьСтрокиВХранилище()
	
	// Формирование таблицы для возврата в документ.
	ТаблицаВыбранныхСтрок = ТаблицаТоваров.Выгрузить(Новый Структура("СтрокаВыбрана", Истина));
	
	АдресТоваровВХранилище = ПоместитьВоВременноеХранилище(ТаблицаВыбранныхСтрок);
	
	Возврат АдресТоваровВХранилище;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьТаблицуТоваров()
	
	ДанныеОтбора = Новый Структура();
	
	Если ЗначениеЗаполнено(Параметры.Документ) Тогда
		ДанныеОтбора.Вставить("Ссылка", Параметры.Документ);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.Организация) Тогда
		ДанныеОтбора.Вставить("Организация", Параметры.Организация);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.Подразделение) Тогда
		ДанныеОтбора.Вставить("Подразделение", Параметры.Подразделение);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.Склад) Тогда
		ДанныеОтбора.Вставить("Склад", Параметры.Склад);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.НаправлениеВыпуска) Тогда
		ДанныеОтбора.Вставить("НаправлениеВыпуска", Параметры.НаправлениеВыпуска);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ОтборРабочийЦентр) Тогда
		ДанныеОтбора.Вставить("РабочийЦентр", ОтборРабочийЦентр);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.НаправлениеДеятельности) Тогда
		ДанныеОтбора.Вставить("НаправлениеДеятельности", Параметры.НаправлениеДеятельности);
	КонецЕсли;
	
	Распоряжение = Параметры.Распоряжение;
	
	Если ЗначениеЗаполнено(Распоряжение) Тогда
		МассивРаспоряжений = Новый Массив;
		МассивРаспоряжений.Добавить(Распоряжение);
	Иначе
		МассивРаспоряжений = Неопределено;
	КонецЕсли;
	
	Результат = Документы.ВыпускПродукции.РезультатЗапросаПоРаспоряжениямНаВыпускПродукции(ДанныеОтбора, Неопределено, МассивРаспоряжений);
	
	ТаблицаТоваров.Загрузить(Результат.Выгрузить());
	
	ЗаказыСервер.УстановитьПризнакиПрисутствияСтрокиВДокументе(ТаблицаТоваров, "Распоряжение", Параметры.МассивКодовСтрок);
	
КонецПроцедуры

&НаКлиенте
Процедура ПеренестиСтрокиВДокумент()
	
	АдресТоваровВХранилище = ПоместитьСтрокиВХранилище();
	
	Модифицированность = Ложь;
	Закрыть();
	
	ОповеститьОВыборе(АдресТоваровВХранилище);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаПередЗакрытием(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Отмена Тогда
		Возврат;
	КонецЕсли;
	
	Модифицированность = Ложь;
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		ПеренестиСтрокиВДокумент();
	Иначе
		Закрыть();
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

//-- НЕ УТКА

//-- Устарело_Производство21