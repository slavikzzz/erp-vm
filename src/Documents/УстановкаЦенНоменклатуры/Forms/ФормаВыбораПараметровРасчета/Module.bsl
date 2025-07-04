
#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ЗагрузкаСтарыхЦен   = Параметры.ЗагрузкаСтарыхЦен;
	ОкруглениеРучныхЦен = Параметры.ОкруглениеРучныхЦен;
	РасчетПоФормулам    = Параметры.РасчетПоФормулам;
	
	ЗагрузитьВидыЦен();
	
	ТолькоВыделенныеСтроки = Параметры.ТолькоВыделенные;
	ТолькоНезаполненные    = 0;
	ДатаСтарыхЦен          = Параметры.ДатаДокумента;
	ПрименятьОкругление    = Истина;
	
	Элементы.ОК.Заголовок                                = ?(ЗагрузкаСтарыхЦен, НСтр("ru = 'Загрузить';
																					|en = 'Import'"), ?(ОкруглениеРучныхЦен, НСтр("ru = 'Округлить';
																																		|en = 'Round off'"), НСтр("ru = 'Рассчитать';
																																								|en = 'Calculate'")));
	Элементы.ВидыЦенПересчитать.Заголовок                = ?(ЗагрузкаСтарыхЦен, НСтр("ru = 'Загрузить';
																					|en = 'Import'"), ?(ОкруглениеРучныхЦен, НСтр("ru = 'Округлить';
																																		|en = 'Round off'"), НСтр("ru = 'Пересчитать';
																																								|en = 'Recalculate'")));
	Элементы.ТолькоВыделенныеСтроки.Заголовок            = ?(ОкруглениеРучныхЦен, НСтр("ru = 'Округлить строки документа';
																						|en = 'Round document lines'"), НСтр("ru = 'Пересчитать строки документа';
																																	|en = 'Recalculate document lines'"));
	Элементы.ГруппаПараметрыПересчетаСтарыхЦен.Видимость = ЗагрузкаСтарыхЦен;
	Элементы.НадписьОкругление.Видимость                 = ОкруглениеРучныхЦен;
	Элементы.ВидыЦенСпособЗаданияЦены.Видимость          = Не ЗагрузкаСтарыхЦен И Не ОкруглениеРучныхЦен;
	Элементы.ТолькоНезаполненные.Видимость               = Не ОкруглениеРучныхЦен;

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

&НаКлиенте
Процедура ВидыЦенВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если Элемент.ТекущиеДанные <> Неопределено Тогда
		ПоказатьЗначение(Неопределено, Элемент.ТекущиеДанные.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	МассивВидовЦен = Новый Массив();
	
	Для Каждого ВидЦены Из ВидыЦен Цикл
		
		Если ВидЦены.Пересчитать Тогда
			Если РасчетПоФормулам Тогда
				МассивВидовЦен.Добавить(Новый Структура("ВидЦены, Формула", ВидЦены.Ссылка, ""));
			Иначе
				МассивВидовЦен.Добавить(ВидЦены.Ссылка);
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;
	
	Результат = Новый Структура();
	Результат.Вставить("ЗагрузкаСтарыхЦен",      ЗагрузкаСтарыхЦен);
	Результат.Вставить("ОкруглениеРучныхЦен",    ОкруглениеРучныхЦен);
	Результат.Вставить("ВидыЦен",                МассивВидовЦен);
	Результат.Вставить("ТолькоВыделенныеСтроки", ТолькоВыделенныеСтроки = 1);
	Результат.Вставить("ТолькоНезаполненные",    ТолькоНезаполненные = 1);
	Результат.Вставить("РасчетПоФормулам",       РасчетПоФормулам);
	
	Если ЗагрузкаСтарыхЦен Тогда
		
		Результат.Вставить("ДатаСтарыхЦен",        КонецДня(ДатаСтарыхЦен));
		Результат.Вставить("ПроцентИзмененияЦены", ПроцентИзмененияЦены);
		Результат.Вставить("ПрименятьОкругление",  ПрименятьОкругление);
		
	КонецЕсли;
	
	Закрыть(Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура ВидыЦенВыбратьВсе(Команда)
	
	Для Каждого ВидЦены Из ВидыЦен Цикл
		Если Не ВидЦены.Пересчитать Тогда
			ВидЦены.Пересчитать = Истина;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ВидыЦенИсключитьВсе(Команда)
	
	Для Каждого ВидЦены Из ВидыЦен Цикл
		Если ВидЦены.Пересчитать Тогда
			ВидЦены.Пересчитать = Ложь;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочее

// Процедура загружает виды цен в таблицу ВидыЦен в порядке,
// соответвующим порядку в документе.
&НаСервере
Процедура ЗагрузитьВидыЦен()
	
	Запрос = Новый Запрос();
	Запрос.Текст = "ВЫБРАТЬ
	|	ВидыЦен.Ссылка КАК Ссылка,
	|	ВидыЦен.СпособЗаданияЦены КАК СпособЗаданияЦены,
	|	ВЫБОР
	|		КОГДА ВидыЦен.СпособЗаданияЦены = ЗНАЧЕНИЕ(Перечисление.СпособыЗаданияЦен.Вручную)
	|			ТОГДА 0
	|		КОГДА ВидыЦен.СпособЗаданияЦены = ЗНАЧЕНИЕ(Перечисление.СпособыЗаданияЦен.ЗаполнятьПоДаннымИБ)
	|			ТОГДА 1
	|		КОГДА ВидыЦен.СпособЗаданияЦены = ЗНАЧЕНИЕ(Перечисление.СпособыЗаданияЦен.РассчитыватьПоФормуламОтДругихВидовЦен)
	|			ТОГДА 2
	|	КОНЕЦ КАК ИндексКартинки
	|ИЗ
	|	Справочник.ВидыЦен КАК ВидыЦен
	|ГДЕ
	|	ВидыЦен.Ссылка В (&МассивВидовЦен)";
	
	Запрос.УстановитьПараметр("МассивВидовЦен", Параметры.РучныеВидыЦен);
	ТаблицаВидовЦен = Запрос.Выполнить().Выгрузить();
	
	// Для того, чтобы виды цен в списке были в том же порядке, как и на форме документа,
	// загружаем их вручную.
	Для Каждого ВидЦены Из Параметры.РучныеВидыЦен Цикл
		
		НайденныйВидЦен = ТаблицаВидовЦен.Найти(ВидЦены, "Ссылка");
		
		СтрокаВидаЦен                   = ВидыЦен.Добавить();
		СтрокаВидаЦен.Ссылка            = ВидЦены;
		СтрокаВидаЦен.СпособЗаданияЦены = НайденныйВидЦен.СпособЗаданияЦены;
		СтрокаВидаЦен.Пересчитать       = Истина;
		СтрокаВидаЦен.ИндексКартинки    = НайденныйВидЦен.ИндексКартинки;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
