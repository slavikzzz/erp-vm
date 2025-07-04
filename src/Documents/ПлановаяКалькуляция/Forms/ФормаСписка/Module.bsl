
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Перем Основание;
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "Номенклатура", Справочники.Номенклатура.ПустаяСсылка());
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "Спецификация", Справочники.РесурсныеСпецификации.ПустаяСсылка());
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "ЗаказНаПроизводство", Документы.ЗаказНаПроизводство.ПустаяСсылка());
	
	Параметры.Свойство("РежимВыбора", Элементы.Список.РежимВыбора);
		
	Если Параметры.Свойство("Основание", Основание) И ЗначениеЗаполнено(Основание) Тогда
		
		// Форма открывается из карточки номенклатуры, спецификации или заказа
		ТипОснования = ТипЗнч(Основание);
		
		Если ТипОснования = Тип("СправочникСсылка.РесурсныеСпецификации") Тогда
			Спецификация = Основание;
			УстановитьОтборПоСпецификации();
			Элементы.ОтборСпецификация.Видимость = Элементы.Список.РежимВыбора;
		ИначеЕсли ТипОснования = Тип("СправочникСсылка.Номенклатура") Тогда
			Номенклатура = Основание;
			УстановитьОтборПоНоменклатуре();
			Элементы.ОтборНоменклатура.Видимость = Элементы.Список.РежимВыбора;
		ИначеЕсли ТипОснования = Тип("ДокументСсылка.ЗаказНаПроизводство") Тогда
			ЗаказНаПроизводство = Основание;
			УстановитьОтборПоЗаказуНаПроизводство();
		КонецЕсли;
		
		НеЗагружатьНастройки = Истина;
	КонецЕсли;
	
	Если Параметры.Свойство("Период") Тогда
		УстановитьОтборПоПериодуДействия(Параметры.Период);
	КонецЕсли;
	
	Параметры.Отбор.Свойство("Статус", Статус);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	

	СтандартныеПодсистемыСервер.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "Список.Дата", Элементы.Дата.Имя);

	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ИнтеграцияС1СДокументооборотом
	
КонецПроцедуры

&НаСервере
Процедура ПередЗагрузкойДанныхИзНастроекНаСервере(Настройки)
	
	Если НеЗагружатьНастройки Тогда
		Настройки.Удалить("Статус");
		Настройки.Удалить("Номенклатура");
		Настройки.Удалить("Ответственный");
		Настройки.Удалить("Спецификация");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	Если НеЗагружатьНастройки Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьОтборПоСтатусу();
	УстановитьОтборПоНоменклатуре();
	УстановитьОтборПоСпецификации();
	УстановитьОтборПоОтветственному();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтборСтатусПриИзменении(Элемент)
	
	УстановитьОтборПоСтатусу();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборНоменклатураПриИзменении(Элемент)
	
	УстановитьОтборПоНоменклатуре();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборСпецификацияПриИзменении(Элемент)
	
	УстановитьОтборПоСпецификации();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОтветственныйПриИзменении(Элемент)
	
	УстановитьОтборПоОтветственному();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Перем ПараметрыФормы;
	
	Если Не Копирование Тогда
		
		Если ЗначениеЗаполнено(Спецификация) Тогда
			
			МассивОбъектов = Новый Массив;
			МассивОбъектов.Добавить(Спецификация);
			
			ЗначенияЗаполнения = Новый Структура("МассивОбъектов, ТипОснования", МассивОбъектов, Тип("СправочникСсылка.РесурсныеСпецификации"));
			ПараметрыФормы = Новый Структура("ЗначенияЗаполнения", ЗначенияЗаполнения);
			
		ИначеЕсли ЗначениеЗаполнено(Номенклатура) Тогда
			МассивОбъектов = Новый Массив;
			МассивОбъектов.Добавить(Номенклатура);
			
			ЗначенияЗаполнения = Новый Структура("МассивОбъектов, ТипОснования", МассивОбъектов, Тип("СправочникСсылка.Номенклатура"));
			ПараметрыФормы = Новый Структура("ЗначенияЗаполнения", ЗначенияЗаполнения);
			
		ИначеЕсли ЗначениеЗаполнено(ЗаказНаПроизводство) Тогда
			
			ЗначенияЗаполнения = Новый Структура("ОбъектКалькуляции", ПредопределенноеЗначение("Перечисление.ОбъектыКалькуляции.ЗаказНаПроизводство"));
			ПараметрыФормы = Новый Структура("ЗначенияЗаполнения", ЗначенияЗаполнения);
			
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ПараметрыФормы) Тогда
			Отказ = Истина;
			ОткрытьФорму("Документ.ПлановаяКалькуляция.ФормаОбъекта", ПараметрыФормы);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Элементы.Список);
КонецПроцедуры


&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры


&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Элементы.Список);
	
КонецПроцедуры
// Конец ИнтеграцияС1СДокументооборотом

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьОтборПоСтатусу()
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"Статус",
		Статус,
		ВидСравненияКомпоновкиДанных.Равно,
		, // Представление - автоматически
		ЗначениеЗаполнено(Статус));
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборПоНоменклатуре()
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"Номенклатура",
		Номенклатура,
		ВидСравненияКомпоновкиДанных.Равно,
		, // Представление - автоматически
		ЗначениеЗаполнено(Номенклатура));
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "Номенклатура", Номенклатура);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборПоСпецификации()
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"Спецификация",
		Спецификация,
		ВидСравненияКомпоновкиДанных.Равно,
		, // Представление - автоматически
		ЗначениеЗаполнено(Спецификация));
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "Спецификация", Спецификация);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборПоОтветственному()
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"Ответственный",
		Ответственный,
		ВидСравненияКомпоновкиДанных.Равно,
		, // Представление - автоматически
		ЗначениеЗаполнено(Ответственный));
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборПоЗаказуНаПроизводство()
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"ЗаказНаПроизводство",
		ЗаказНаПроизводство,
		ВидСравненияКомпоновкиДанных.Равно,
		, // Представление - автоматически
		ЗначениеЗаполнено(ЗаказНаПроизводство));
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "ЗаказНаПроизводство", ЗаказНаПроизводство);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборПоПериодуДействия(Период)
	
	ГруппаОтбораИ = ОбщегоНазначенияКлиентСервер.СоздатьГруппуЭлементовОтбора(Список.Отбор.Элементы,
		, // Представление - автоматически.
		ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ);
	ГруппаОтбораИли = ОбщегоНазначенияКлиентСервер.СоздатьГруппуЭлементовОтбора(ГруппаОтбораИ,
		, // Представление - автоматически.
		ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли);
		
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
		ГруппаОтбораИ, "ДатаНачалаДействия", 
		НачалоДня(Период), 
		ВидСравненияКомпоновкиДанных.Меньше);
		
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(
		ГруппаОтбораИли, "ДатаОкончанияДействия", 
		ВидСравненияКомпоновкиДанных.БольшеИлиРавно, 
		НачалоДня(Период));
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(
		ГруппаОтбораИли, "ДатаОкончанияДействия", 
		ВидСравненияКомпоновкиДанных.НеЗаполнено);
	
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти
