
#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗагрузкаСтарыхЦен   = Параметры.ЗагрузкаСтарыхЦен;
	ОкруглениеРучныхЦен = Параметры.ОкруглениеРучныхЦен;
	
	ЗагрузитьВидыЦен();
	
	ТолькоВыделенныеСтроки = Параметры.ТолькоВыделенные;
	ТолькоНезаполненные    = 0;
	ДатаСтарыхЦен          = Параметры.ДатаДокумента;
	ПрименятьОкругление    = Истина;
	
	Элементы.ОК.Заголовок                     = НСтр("ru = 'Загрузить';
													|en = 'Import'");
	Элементы.ВидыЦенПересчитать.Заголовок     = НСтр("ru = 'Загрузить';
													|en = 'Import'");
	Элементы.ТолькоВыделенныеСтроки.Заголовок = НСтр("ru = 'Загрузить строки документа';
													|en = 'Import document lines'");                       

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыВидыЦен

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
			МассивВидовЦен.Добавить(ВидЦены.Ссылка);
		КонецЕсли;
		
	КонецЦикла;
	
	Результат = Новый Структура();
	Результат.Вставить("ВидыЦен",                МассивВидовЦен);
	Результат.Вставить("ТолькоВыделенныеСтроки", ТолькоВыделенныеСтроки = 1);
	
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
	
	ИспользуетсяЦенообразование25 = ЦенообразованиеВызовСервера.ИспользуетсяЦенообразование25();   
	Запрос = Новый Запрос();    
	Если ИспользуетсяЦенообразование25 Тогда 
		Запрос.Текст = "ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ВидыЦен.Ссылка            КАК Ссылка,  
		|	МАКСИМУМ(ЕСТЬNULL(ЦеныНоменклатуры25.Период,ДАТАВРЕМЯ(1,1,1))) КАК ДатаОбновленияЦены,
		|	1 КАК ИндексКартинки
		|ИЗ
		|	Справочник.ВидыЦен КАК ВидыЦен
		|		ЛЕВОЕ СОЕДИНЕНИЕ
		|	    РегистрСведений.ЦеныНоменклатуры25.СрезПоследних КАК ЦеныНоменклатуры25
		|		ПО ВидыЦен.Ссылка = ЦеныНоменклатуры25.ВидЦены
		|ГДЕ
		|	ВидыЦен.Ссылка В(&МассивВидовЦен)
		|	И ВидыЦен.СпособЗаданияЦены = ЗНАЧЕНИЕ(Перечисление.СпособыЗаданияЦен.ЗагружаетсяИзЯндексМаркет)
		|СГРУППИРОВАТЬ ПО ВидыЦен.Ссылка";
	Иначе 
		Запрос.Текст = "ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ВидыЦен.Ссылка            КАК Ссылка,  
		|	МАКСИМУМ(ЕСТЬNULL(ЦеныНоменклатуры.Период,ДАТАВРЕМЯ(1,1,1))) КАК ДатаОбновленияЦены,
		|	1 КАК ИндексКартинки
		|ИЗ
		|	Справочник.ВидыЦен КАК ВидыЦен
		|		ЛЕВОЕ СОЕДИНЕНИЕ
		|	    РегистрСведений.ЦеныНоменклатуры.СрезПоследних КАК ЦеныНоменклатуры
		|		ПО ВидыЦен.Ссылка = ЦеныНоменклатуры.ВидЦены
		|ГДЕ
		|	ВидыЦен.Ссылка В(&МассивВидовЦен)
		|	И ВидыЦен.СпособЗаданияЦены = ЗНАЧЕНИЕ(Перечисление.СпособыЗаданияЦен.ЗагружаетсяИзЯндексМаркет)
		|СГРУППИРОВАТЬ ПО ВидыЦен.Ссылка";

	КонецЕсли;
		
	Запрос.УстановитьПараметр("МассивВидовЦен", Параметры.РучныеВидыЦен);
	ТаблицаВидовЦен = Запрос.Выполнить().Выгрузить();
	
	// Для того, чтобы виды цен в списке были в том же порядке, как и на форме документа,
	// загружаем их вручную.
	Для Каждого ВидЦены Из Параметры.РучныеВидыЦен Цикл
		
		НайденныйВидЦен = ТаблицаВидовЦен.Найти(ВидЦены, "Ссылка");
		
		Если НайденныйВидЦен<>Неопределено Тогда
		
			СтрокаВидаЦен                   = ВидыЦен.Добавить();
			СтрокаВидаЦен.Ссылка            = ВидЦены;
			СтрокаВидаЦен.ДатаОбновленияЦены = НайденныйВидЦен.ДатаОбновленияЦены;
			СтрокаВидаЦен.Пересчитать       = Истина;
			СтрокаВидаЦен.ИндексКартинки    = НайденныйВидЦен.ИндексКартинки;
		
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
