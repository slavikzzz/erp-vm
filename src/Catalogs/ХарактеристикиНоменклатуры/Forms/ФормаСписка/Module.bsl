
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	Если Параметры.Свойство("Отбор") И Параметры.Отбор.Свойство("Владелец") Тогда

		Владелец            = Параметры.Отбор.Владелец;
		ВладелецДляОтбора   = Неопределено;
		ОбщиеХарактеристики = Неопределено;

		Если ТипЗнч(Владелец) = Тип("СправочникСсылка.Номенклатура") Тогда

			ВладелецИспользованиеХарактеристик = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Владелец, "ИспользованиеХарактеристик");

			Если ВладелецИспользованиеХарактеристик = Перечисления.ВариантыИспользованияХарактеристикНоменклатуры.ИндивидуальныеДляНоменклатуры Тогда
				ВладелецДляОтбора = Владелец;
				ОбщиеХарактеристики = Ложь;
			ИначеЕсли ВладелецИспользованиеХарактеристик = Перечисления.ВариантыИспользованияХарактеристикНоменклатуры.ОбщиеДляВидаНоменклатуры Тогда
				ВладелецДляОтбора = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Владелец, "ВидНоменклатуры");
				ОбщиеХарактеристики = Истина;
			ИначеЕсли ВладелецИспользованиеХарактеристик = Перечисления.ВариантыИспользованияХарактеристикНоменклатуры.ОбщиеСДругимВидомНоменклатуры Тогда
				ВладелецДляОтбора = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Владелец, "ВладелецХарактеристик");
				ОбщиеХарактеристики = Истина;
			КонецЕсли;

			Номенклатура = Владелец;
			
		ИначеЕсли ТипЗнч(Владелец) = Тип("СправочникСсылка.ВидыНоменклатуры") Тогда

			ВладелецИспользованиеХарактеристик = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Владелец, "ИспользованиеХарактеристик");

			Если ВладелецИспользованиеХарактеристик = Перечисления.ВариантыИспользованияХарактеристикНоменклатуры.ОбщиеДляВидаНоменклатуры Тогда
				ВладелецДляОтбора = Владелец;
				ОбщиеХарактеристики = Истина;
			ИначеЕсли ВладелецИспользованиеХарактеристик = Перечисления.ВариантыИспользованияХарактеристикНоменклатуры.ОбщиеСДругимВидомНоменклатуры Тогда
				ВладелецДляОтбора = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Владелец, "ВладелецХарактеристик");
				ОбщиеХарактеристики = Истина;
			КонецЕсли;

		КонецЕсли;

		Если ВладелецДляОтбора = Неопределено Тогда

			ТекстЗаголовка = НСтр("ru = 'Для элемента: ""%Владелец%"" характеристики не используются';
									|en = 'Variants are not used for item: ""%Владелец%""'");
			ТекстЗаголовка = СтрЗаменить(ТекстЗаголовка, "%Владелец%", Строка(Владелец));

			АвтоЗаголовок = Ложь;
			Заголовок     = ТекстЗаголовка;

			Элементы.Список.ТолькоПросмотр = Истина;
		Иначе
			
			ТекстЗаголовка = НСтр("ru = 'Характеристики номенклатуры (%Владелец%)';
									|en = 'Item variants (%Владелец%)'");
			ТекстЗаголовка = СтрЗаменить(ТекстЗаголовка, "%Владелец%", Строка(ВладелецДляОтбора));

			АвтоЗаголовок = Ложь;
			Заголовок     = ТекстЗаголовка;
			
		КонецЕсли;

		Если ОбщиеХарактеристики = Истина Тогда
			Элементы.ДекорацияПредупреждение.Видимость = Истина;
			Элементы.ДекорацияПредупреждение.Заголовок = Элементы.ДекорацияПредупреждение.Заголовок + " """ + Строка(ВладелецДляОтбора) + """";
		Иначе
			Элементы.ДекорацияПредупреждение.Видимость = Ложь;
		КонецЕсли;
		
		Параметры.Отбор.Владелец = ВладелецДляОтбора;

	КонецЕсли;

	Если ЗначениеЗаполнено(Номенклатура) Тогда
		ТипНоменклатуры = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Номенклатура, "ТипНоменклатуры");
		ПоказатьСоставНабора = (ТипНоменклатуры = Перечисления.ТипыНоменклатуры.Набор) И ПолучитьФункциональнуюОпцию("ИспользоватьНаборы"); 
	Иначе
		ПоказатьСоставНабора = Ложь;
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "Номенклатура", Номенклатура, Истина);
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "ПоказатьСоставНабора", ПоказатьСоставНабора, Истина);
	Элементы.СоставНабора.Видимость = ПоказатьСоставНабора;
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	// СтандартныеПодсистемы.БазоваяФункциональность
	МультиязычностьСервер.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.БазоваяФункциональность
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_ХарактеристикиНоменклатуры" 
		И ЗначениеЗаполнено(Источник) Тогда
		Элементы.Список.ТекущаяСтрока = Источник;
	КонецЕсли;
	
	Если ИмяСобытия = "Запись_ВариантыКомплектацииНоменклатуры" Тогда
		Элементы.Список.Обновить();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле = Элементы.СоставНабора Тогда
		
		СтандартнаяОбработка = Ложь;
		
		ОсновнаяКомплектация = НаборыВызовСервера.ВариантКомплектацииНоменклатурыПоУмолчанию(
			Владелец,
			Элементы.Список.ТекущиеДанные.Ссылка);
		
		ПараметрыФормы = Неопределено;
		Если НЕ ЗначениеЗаполнено(ОсновнаяКомплектация) Тогда
			Отбор = Новый Структура;
			Отбор.Вставить("Владелец", Владелец);
			Отбор.Вставить("Характеристика", Элементы.Список.ТекущиеДанные.Ссылка);
			ПараметрыФормы = Новый Структура("Отбор", Отбор);
		Иначе
			ПараметрыФормы = Новый Структура("Ключ", ОсновнаяКомплектация);
		КонецЕсли;
		
		ОткрытьФорму("Справочник.ВариантыКомплектацииНоменклатуры.Форма.СоставНабора",
			ПараметрыФормы);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	Если Не Копирование 
		И Не ЗначениеЗаполнено(Владелец) Тогда
		ТекстПредупреждения = НСтр("ru = 'Для создания характеристик список нужно открывать из формы вида номенклатуры или номенклатуры.';
									|en = 'To create variants, the list should be opened from the form of item kind or products.'");
		ПоказатьПредупреждение(,ТекстПредупреждения);
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Если Не Копирование	И Не Группа Тогда
		Отказ = Истина;
		Если ТипЗнч(Владелец) = Тип("СправочникСсылка.Номенклатура") Тогда
			ВидНоменклатуры = ОбщегоНазначенияУТВызовСервера.ЗначениеРеквизитаОбъекта(Владелец, "ВидНоменклатуры");
		Иначе
			ВидНоменклатуры = Владелец;
		КонецЕсли;
		СтруктураПараметров = Новый Структура("ВидНоменклатуры, Владелец, Номенклатура", ВидНоменклатуры, Владелец, Номенклатура);
		ОткрытьФорму("Справочник.ХарактеристикиНоменклатуры.Форма.ФормаЭлемента",  СтруктураПараметров, ЭтаФорма);
	ИначеЕсли Копирование
		И Не Группа Тогда
		Отказ = Истина;
		ТекущиеДанные = Элементы.Список.ТекущиеДанные;
		СтруктураПараметров = Новый Структура("ЗначениеКопирования, Номенклатура", ТекущиеДанные.Ссылка, Номенклатура);
		ОткрытьФорму("Справочник.ХарактеристикиНоменклатуры.Форма.ФормаЭлемента",  СтруктураПараметров, ЭтаФорма);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции


&НаСервереБезКонтекста
Процедура СписокПриПолученииДанныхНаСервере(ИмяЭлемента, Настройки, Строки)
	
	ПоказатьСоставНабора = Настройки.ПараметрыДанных.Элементы.Найти("ПоказатьСоставНабора");
	
	Если ПоказатьСоставНабора = Неопределено
		Или Не ПоказатьСоставНабора.Значение Тогда
		Возврат;
	КонецЕсли;
	
	ОтображаемыеХарактеристики = Строки.ПолучитьКлючи();
	Номенклатура = Настройки.ПараметрыДанных.Элементы.Найти("Номенклатура");
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	КОЛИЧЕСТВО(ВариантыКомплектацииНоменклатурыТовары.НомерСтроки) КАК КоличествоКомплектующих,
	|	ВариантыКомплектацииНоменклатурыТовары.Ссылка.Характеристика КАК Характеристика
	|ИЗ
	|	Справочник.ВариантыКомплектацииНоменклатуры.Товары КАК ВариантыКомплектацииНоменклатурыТовары
	|ГДЕ
	|	ВариантыКомплектацииНоменклатурыТовары.Ссылка.Характеристика В (&ОтображаемыеХарактеристики)
	|	И ВариантыКомплектацииНоменклатурыТовары.Ссылка.Владелец = &Номенклатура
	|
	|СГРУППИРОВАТЬ ПО
	|	ВариантыКомплектацииНоменклатурыТовары.Ссылка.Характеристика";
	
	Запрос.УстановитьПараметр("ОтображаемыеХарактеристики", ОтображаемыеХарактеристики);
	Запрос.УстановитьПараметр("Номенклатура", Номенклатура.Значение);
	
	ИнформацияПоКомплектующим = Запрос.Выполнить().Выгрузить();
	
	Для Каждого КлючЗначение Из Строки Цикл
		
		НайденныеСтроки = ИнформацияПоКомплектующим.НайтиСтроки(Новый Структура("Характеристика", КлючЗначение.Ключ));
		
		Если НайденныеСтроки.Количество() = 0 Тогда
			КоличествоКомплектующих = 0;
		Иначе
			КоличествоКомплектующих = НайденныеСтроки[0].КоличествоКомплектующих;
		КонецЕсли;
		
		Если КоличествоКомплектующих > 0 Тогда
			ТекстКомплектующих = СтрокаСЧислом(
				НСтр("ru = ';%1 комплектующая;;%1 комплектующие;%1 комплектующих;%1 комплектующие';
					|en = ';%1 component;;%1 components;%1 components;%1 components'"),
				КоличествоКомплектующих,
				ВидЧисловогоЗначения.Количественное);
		Иначе
			ТекстКомплектующих = НСтр("ru = 'Настроить';
										|en = 'Customize'");
		КонецЕсли;
		
		ОформляемаяСтрока = КлючЗначение.Значение;
		
		ОформляемаяСтрока.Данные.СоставНабора = ТекстКомплектующих;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти