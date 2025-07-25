#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	ПравоИзменения = ПравоДоступа("Изменение", Метаданные.РегистрыСведений.СтавкиНДСНоменклатуры);
	Элементы.СтавкиНДСНоменклатурыДобавить.Видимость = ПравоИзменения;
	Элементы.СтавкиНДСНоменклатурыУдалить.Видимость = ПравоИзменения;
	
	Номенклатура = Параметры.Номенклатура;
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьМногострановойУчет") Тогда
		Страна = ЗначениеНастроекКлиентСерверПовтИсп.ОсновнаяСтрана();
	КонецЕсли;
	
	СтавкаНДС = РегистрыСведений.СтавкиНДСНоменклатуры.АктуальнаяСтавкаНДСНоменклатурыПоОсновнойСтране(Номенклатура);
	
	ПрочитатьСтавкиНДСНоменклатуры();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если Не ЗавершениеРаботы Тогда
		СтавкаАктуализирована = ЗначениеЗаполнено(АктуальнаяСтавкаНДС)
								И СтавкаНДС <> АктуальнаяСтавкаНДС;
		
		ОповеститьОВыборе(СтавкаАктуализирована);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_СтавкиНДСНоменклатуры"
		И Источник.Номенклатура = Номенклатура Тогда
		
		ПрочитатьСтавкиНДСНоменклатуры();
		
		Если Параметр.Свойство("ЭтоАктуальнаяСтавка")
			И Параметр.ЭтоАктуальнаяСтавка Тогда
			
			СтавкаНДС = АктуальнаяСтавкаНДС;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура СтавкиНДСНоменклатурыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущиеДанные =  СтавкиНДСНоменклатуры.НайтиПоИдентификатору(ВыбраннаяСтрока);
	
	Отбор = Новый Структура();
	Отбор.Вставить("Номенклатура", Номенклатура);
	Отбор.Вставить("Страна", ТекущиеДанные.Страна);
	Отбор.Вставить("Период", ТекущиеДанные.Период);
	
	ПараметрыФормы = Новый Структура;
	
	Если ТекущиеДанные.ОсновнаяСтавка Тогда
		Отбор.Вставить("СтавкаНДС", ТекущиеДанные.СтавкаНДС);
		ПараметрыФормы = Новый Структура();
		ПараметрыФормы.Вставить("ЗначенияЗаполнения", Отбор);
	Иначе
		
		ПроверитьУстановитьПустуюСтрануВОтборе(Отбор);
		
		МассивОтбор = Новый Массив;
		МассивОтбор.Добавить(Отбор);
		КлючЗаписи = Новый("РегистрСведенийКлючЗаписи.СтавкиНДСНоменклатуры", МассивОтбор);
		ПараметрыФормы.Вставить("Ключ", КлючЗаписи);
	КонецЕсли;
	
	ОткрытьФорму("РегистрСведений.СтавкиНДСНоменклатуры.Форма.ФормаЗаписи", 
				ПараметрыФормы, ЭтотОбъект, , , , , РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры

&НаКлиенте
Процедура ПериодПриИзменении(Элемент)
	ПрочитатьСтавкиНДСНоменклатуры();
КонецПроцедуры

&НаКлиенте
Процедура СтранаПриИзменении(Элемент)
	ПрочитатьСтавкиНДСНоменклатуры();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Удалить(Команда)
	
	ТекущаяСтрока = Элементы.СтавкиНДСНоменклатуры.ТекущиеДанные;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ТекущаяСтрока.ОсновнаяСтавка Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Удаление основной ставки НДС запрещено';
														|en = 'Cannot delete the main VAT rate'"));
		Возврат;
	КонецЕсли;
	
	Если СтавкиНДСНоменклатуры.Количество() = 1 Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Удаление единственной записи запрещено';
														|en = 'Cannot delete the only record'"));
		Возврат;
	КонецЕсли;
	
	СтараяСтавкаНДС = АктуальнаяСтавкаНДС;
	
	Отбор = Новый Структура();
	Отбор.Вставить("Период", ТекущаяСтрока.Период);
	Отбор.Вставить("Номенклатура", Номенклатура);
	Отбор.Вставить("Страна", ТекущаяСтрока.Страна);
	
	УдалитьЗаписьСервер(Отбор);
	
	Если СтараяСтавкаНДС <> АктуальнаяСтавкаНДС Тогда
		ПараметрыОповещения = Новый Структура("ЭтоАктуальнаяСтавка", Истина);
		СтруктураИсточник = Новый Структура("Номенклатура", Номенклатура);
		Оповестить("Запись_СтавкиНДСНоменклатуры", ПараметрыОповещения, СтруктураИсточник);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Обновить(Команда)
	ПрочитатьСтавкиНДСНоменклатуры();
КонецПроцедуры

&НаКлиенте
Процедура Добавить(Команда)
	
	Отбор = Новый Структура();
	Отбор.Вставить("Номенклатура", Номенклатура);
	Если ЗначениеЗаполнено(Страна) Тогда
		Отбор.Вставить("Страна", Страна);
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("ЗначенияЗаполнения", Отбор);
	
	ОткрытьФорму("РегистрСведений.СтавкиНДСНоменклатуры.Форма.ФормаЗаписи", 
				ПараметрыФормы, ЭтотОбъект, , , , , РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СтавкиНДСНоменклатурыСтавкаНДС.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СтавкиНДСНоменклатуры.ОсновнаяСтавка");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.НезаполненноеПолеТаблицы);
	
	//
	
	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СтавкиНДСНоменклатурыПериод.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СтавкиНДСНоменклатуры.Период");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Дата("19800101");

	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'Начальное значение';
																|en = 'Initial value'"));
	
КонецПроцедуры

&НаСервере
Процедура ПрочитатьСтавкиНДСНоменклатуры()
	
	ТаблицаСтавокНДС = РегистрыСведений.СтавкиНДСНоменклатуры.ТаблицаСтавокНДСНоменклатуры(Номенклатура, Страна, Период);
	СтавкиНДСНоменклатуры.Загрузить(ТаблицаСтавокНДС);
	
	АктуальнаяСтавкаНДС = РегистрыСведений.СтавкиНДСНоменклатуры.АктуальнаяСтавкаНДСНоменклатурыПоОсновнойСтране(
							Номенклатура);
	
КонецПроцедуры

&НаСервере
Процедура УдалитьЗаписьСервер(Отбор)
	
	НаборЗаписей = РегистрыСведений.СтавкиНДСНоменклатуры.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Период.Установить(Отбор.Период);
	НаборЗаписей.Отбор.Номенклатура.Установить(Отбор.Номенклатура);
	НаборЗаписей.Отбор.Страна.Установить(Отбор.Страна);
	
	НаборЗаписей.Прочитать();
	
	Если НаборЗаписей.Количество() = 0 Тогда
		НаборЗаписей = РегистрыСведений.СтавкиНДСНоменклатуры.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Период.Установить(Отбор.Период);
		НаборЗаписей.Отбор.Номенклатура.Установить(Отбор.Номенклатура);
	КонецЕсли;
	
	НаборЗаписей.Очистить();
	НаборЗаписей.Записать();
	
	ПрочитатьСтавкиНДСНоменклатуры();
	
КонецПроцедуры

&НаСервере
Процедура ПроверитьУстановитьПустуюСтрануВОтборе(Отбор)
	
	НаборЗаписей = РегистрыСведений.СтавкиНДСНоменклатуры.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Период.Установить(Отбор.Период);
	НаборЗаписей.Отбор.Номенклатура.Установить(Отбор.Номенклатура);
	НаборЗаписей.Отбор.Страна.Установить(Отбор.Страна);
	
	НаборЗаписей.Прочитать();
	
	Если НаборЗаписей.Количество() = 0 Тогда
		Отбор.Страна = Справочники.СтраныМира.ПустаяСсылка();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
