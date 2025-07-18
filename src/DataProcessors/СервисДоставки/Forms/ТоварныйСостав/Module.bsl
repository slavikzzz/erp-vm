#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Параметры.Свойство("ТипГрузоперевозки", ТипГрузоперевозки);
	
	Если Не ЗначениеЗаполнено(ТипГрузоперевозки) Тогда
		
		ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'Не выбран тип грузоперевозки';
													|en = 'Cargo transportation type is not selected'"));
		Отказ = Истина;
		Возврат;
		
	ИначеЕсли Не СервисДоставки.ТипГрузоперевозкиДоступен(ТипГрузоперевозки) Тогда
		
		ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'Выбранный тип грузоперевозки не доступен';
													|en = 'The selected cargo transportation type is not available'"));
		
		Отказ = Истина;
		Возврат;
		
	КонецЕсли;
	
	Параметры.Свойство("НаложенныйПлатежВидОплаты", НаложенныйПлатежВидОплаты);
	
	НастроитьФормуПоТипуГрузоперевозки();
	
	ТоварныйСостав.Загрузить(Параметры.ТоварныйСостав.Выгрузить());
	
	УстановитьУсловноеОформление();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗакрытьФорму(Команда)
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура НастроитьФормуПоТипуГрузоперевозки()
	
	Заголовок = СтрШаблон(НСтр("ru = '%1: Товарный состав';
								|en = '%1: Item list'"),
		СервисДоставкиКлиентСервер.ПредставлениеТипаГрузоперевозки(ТипГрузоперевозки));
	
	Это1СДоставка = ТипГрузоперевозки = СервисДоставкиКлиентСервер.ТипГрузоперевозкиСервис1СДоставка();

	Элементы.ТоварныйСоставИННВладельцаГруза.Видимость = Не Это1СДоставка;
	Элементы.ТоварныйСоставАртикул.Видимость = Не Это1СДоставка;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	Если НаложенныйПлатежВидОплаты > 0 Тогда
		
		ОбязательныеРеквизиты = "ТоварныйСоставАртикул, ТоварныйСоставСтавкаНДС, ТоварныйСоставИННВладельцаГруза";
		КоллекцияРеквизитов = Новый Структура(ОбязательныеРеквизиты);
		
		Для каждого Элем Из КоллекцияРеквизитов Цикл
			
			ИмяЭлемента = Элем.Ключ;
			ИмяКолонки = СтрЗаменить(ИмяЭлемента,"ТоварныйСостав","");
			
			ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
			ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
			ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(ИмяЭлемента);
			ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
			ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("ТоварныйСостав.%1",ИмяКолонки));
			ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
			ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Истина);
			
			ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
			ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
			ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(ИмяЭлемента);
			ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
			ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("ТоварныйСостав.%1",ИмяКолонки));
			ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено;
			ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);
			
		КонецЦикла; 
		
	КонецЕсли; 

КонецПроцедуры

#КонецОбласти
