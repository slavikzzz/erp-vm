#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("Автотест") Тогда
		Возврат;
	КонецЕсли;
	
	Дата = Параметры.ДатаНачалаАренды;
	Арендатор = Параметры.Арендатор;
	Договор = Параметры.Договор;
	ОсновноеСредство = Параметры.ОсновноеСредство;
	СлужебныеПараметрыФормы = ОбщегоНазначения.СкопироватьРекурсивно(Параметры.СлужебныеПараметрыФормы, Истина);
	СтавкаНДС = СлужебныеПараметрыФормы.РеквизитыДоговора.СтавкаНДС;
	Ссылка = Параметры.Ссылка;
	ОтображатьГрафикПроцентовИзРегистра = Параметры.ОтображатьГрафикПроцентовИзРегистра;
	
	ВалютаДокументаПредставление = СлужебныеПараметрыФормы.РеквизитыДоговора.ВалютаВзаиморасчетовПредставление;
	
	ЗагрузитьГрафики(Параметры.ГрафикиДоговора);
	
	Если ТипЗнч(Ссылка) <> Тип("ДокументСсылка.ВводОстатковИнвестицииВАренду") Тогда
		СтрокиОС = ТаблицаОС.НайтиСтроки(Новый Структура("ОсновноеСредство", ОсновноеСредство));
		Для Каждого СтрокаОС Из СтрокиОС Цикл
			ГрафикНачисленияПроцентовВведенВручную = СтрокаОС.ГрафикНачисленияПроцентовВведенВручную;
		КонецЦикла;
	Иначе
		ГрафикНачисленияПроцентовВведенВручную = Истина;
	КонецЕсли;
	
	ЗаполнитьНадписьОтборы();
	
	НастроитьЗависимыеЭлементыФормыНаКлиентеНаСервере(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	НастроитьЗависимыеЭлементыФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения("ПоказатьПодтверждениеЗакрытияФормыЗавершение", ЭтотОбъект);
	ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(Оповещение, Отказ, ЗавершениеРаботы,, ТекстПредупреждения);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	УчетАрендованныхОС.ПроверитьГрафик(
		ГрафикОплатУслуг, 
		"ГрафикОплатУслуг", 
		"УслугаПоАренде", 
		Отказ);
		
	УчетАрендованныхОС.ПроверитьГрафик(
		ГрафикНачисленияУслуг, 
		"ГрафикНачисленияУслуг", 
		"УслугаПоАренде", 
		Отказ);

	УчетАрендованныхОС.ПроверитьГрафик(
		ГрафикНачисленияПроцентов, 
		"ГрафикНачисленияПроцентов", 
		"Проценты", 
		Отказ);
		
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ГрафикНачисленияПроцентовВведенВручнуюПриИзменении(Элемент)
	
	НастроитьЗависимыеЭлементыФормыНаКлиентеНаСервере(ЭтотОбъект, Элемент.Имя);
	
	СтрокиОС = ТаблицаОС.НайтиСтроки(Новый Структура("ОсновноеСредство", ОсновноеСредство));
	Для Каждого СтрокаОС Из СтрокиОС Цикл
		СтрокаОС.ГрафикНачисленияПроцентовВведенВручную = ГрафикНачисленияПроцентовВведенВручную;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыГрафикОплатУслуг

&НаКлиенте
Процедура ГрафикОплатУслугПриИзменении(Элемент)
	ОбновитьИтоги(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ГрафикОплатУслугУслугаПоАрендеПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ГрафикОплатУслуг.ТекущиеДанные;
	ТекущиеДанные.УслугаПоАрендеНДС = РассчитатьСуммуНДС(ТекущиеДанные.УслугаПоАренде);
	
КонецПроцедуры

&НаКлиенте
Процедура ГрафикОплатУслугДатаПриИзменении(Элемент)
	
	ПриИзмененииДатыГрафика(Элемент.Родитель.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура ГрафикОплатУслугПередУдалением(Элемент, Отказ)
		
	ГрафикПередУдалением(Элемент, Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура ГрафикОплатУслугПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, ЭтоГруппа, Параметр)
	
	ГрафикПередНачаломДобавления(Элемент, Отказ, Копирование);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыГрафикНачисленияУслуг

&НаКлиенте
Процедура ГрафикНачисленияУслугПриИзменении(Элемент)
	ОбновитьИтоги(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ГрафикНачисленияУслугУслугаПоАрендеПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ГрафикНачисленияУслуг.ТекущиеДанные;
	ТекущиеДанные.УслугаПоАрендеНДС = РассчитатьСуммуНДС(ТекущиеДанные.УслугаПоАренде);
	
КонецПроцедуры

&НаКлиенте
Процедура ГрафикНачисленияУслугДатаПриИзменении(Элемент)
	
	ПриИзмененииДатыГрафика(Элемент.Родитель.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура ГрафикНачисленияУслугПередУдалением(Элемент, Отказ)
		
	ГрафикПередУдалением(Элемент, Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура ГрафикНачисленияУслугПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, ЭтоГруппа, Параметр)

	ГрафикПередНачаломДобавления(Элемент, Отказ, Копирование);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыГрафикНачисленияПроцентов

&НаКлиенте
Процедура ГрафикНачисленияПроцентовПриИзменении(Элемент)
	ОбновитьИтоги(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ГрафикНачисленияПроцентовДатаПриИзменении(Элемент)
		
	ПриИзмененииДатыГрафика(Элемент.Родитель.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура ГрафикНачисленияПроцентовПередУдалением(Элемент, Отказ)
	
	ГрафикПередУдалением(Элемент, Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура ГрафикНачисленияПроцентовПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, ЭтоГруппа, Параметр)
	
	ГрафикПередНачаломДобавления(Элемент, Отказ, Копирование);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗавершитьРедактирование(Команда)
	
	ОчиститьСообщения();

	Если НЕ ПроверитьЗаполнение() Тогда
		ТекстВопроса = НСтр("ru = 'Не заполнены обязательные поля.
							|Можно завершить редактирование или продолжить редактирование.';
							|en = 'Some of the required fields are not filled in.
							|You can choose to finish editing or continue.'");
		СписокКнопок = Новый СписокЗначений;
		СписокКнопок.Добавить(КодВозвратаДиалога.Да, НСтр("ru = 'Завершить редактирование';
															|en = 'Finish editing'"));
		СписокКнопок.Добавить(КодВозвратаДиалога.Нет, НСтр("ru = 'Продолжить редактирование';
															|en = 'Continue editing'"));
		ОписаниеОповещения = Новый ОписаниеОповещения("ЗавершитьРедактированиеЗавершение", ЭтотОбъект);
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, СписокКнопок,, КодВозвратаДиалога.Да);
	Иначе
		ЗавершитьРедактированиеЗавершение(КодВозвратаДиалога.Да, Неопределено);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьСуммы_ГрафикОплат(Команда)
	
	ЗаполнитьСуммыВГрафике("ГрафикОплатУслуг");
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьСуммы_ГрафикНачислений(Команда)
	
	ЗаполнитьСуммыВГрафике("ГрафикНачисленияУслуг");
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьГрафик_ГрафикОплат(Команда)
	
	ЗагрузитьГрафик("ГрафикОплатУслуг");
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьГрафик_ГрафикНачислений(Команда)
	
	ЗагрузитьГрафик("ГрафикНачисленияУслуг");
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьГрафик_ГрафикПроцентов(Команда)
	
	ЗагрузитьГрафик("ГрафикНачисленияПроцентов");
	
КонецПроцедуры

&НаКлиенте
Процедура Перезаполнить(Команда)
	
	ЗаполнитьГрафик();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ЗаполнитьСуммыВГрафике(ИмяТаблицы)
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИмяТаблицы", ИмяТаблицы);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ЗаполнитьСуммыВГрафикеЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	
	ТекущиеДанные = Элементы[ИмяТаблицы].ТекущиеДанные;
	СуммаЗаполнения = ?(ТекущиеДанные = Неопределено, 0, ТекущиеДанные.УслугаПоАренде);

	ТекстПодсказки = НСтр("ru = 'Введите сумму';
							|en = 'Enter the amount'");
	ОписаниеТипов = Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(31, 2, ДопустимыйЗнак.Неотрицательный));
	
	ПоказатьВводЗначения(ОписаниеОповещения, СуммаЗаполнения, ТекстПодсказки, ОписаниеТипов);

КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()

	#Область УслугаПоАренде
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Оплата_УслугаПоАренде_Итого.Имя);
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Начисление_УслугаПоАренде_Итого.Имя);
	
	ГруппаОтбора = Элемент.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбора.Использование = Истина;
	ГруппаОтбора.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;
	
	ОтборЭлемента = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Оплата_УслугаПоАренде_Итого");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеРавно;
	ОтборЭлемента.ПравоеЗначение = Новый ПолеКомпоновкиДанных("Начисление_УслугаПоАренде_Итого");
	
	ОтборЭлемента = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Авансы_Итого");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветОсобогоТекста);
	#КонецОбласти
	
	#Область НДС
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Оплата_НДС_Итого.Имя);
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Начисление_НДС_Итого.Имя);
	
	ГруппаОтбора = Элемент.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбора.Использование = Истина;
	ГруппаОтбора.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;
	
	ОтборЭлемента = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Оплата_НДС_Итого");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеРавно;
	ОтборЭлемента.ПравоеЗначение = Новый ПолеКомпоновкиДанных("Начисление_НДС_Итого");
	
	ОтборЭлемента = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Авансы_Итого");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветОсобогоТекста);
	#КонецОбласти
	
	#Область ГрафикОплат
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ГрафикОплатУслуг.Имя);
	
	ГруппаОтбора = Элемент.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбора.Использование = Истина;
	ГруппаОтбора.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;
	
	ОтборЭлемента = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ГрафикОплатУслуг.Дата");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Меньше;
	ОтборЭлемента.ПравоеЗначение = Новый ПолеКомпоновкиДанных("Дата");
	
	ОтборЭлемента = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ГрафикОплатУслуг.Дата");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветНедоступногоТекста);
	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	#КонецОбласти
	
	#Область ГрафикНачислений
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ГрафикНачисленияУслуг.Имя);
	
	ГруппаОтбора = Элемент.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбора.Использование = Истина;
	ГруппаОтбора.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;
	
	ОтборЭлемента = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ГрафикНачисленияУслуг.Дата");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Меньше;
	ОтборЭлемента.ПравоеЗначение = Новый ПолеКомпоновкиДанных("Дата");
	
	ОтборЭлемента = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ГрафикНачисленияУслуг.Дата");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветНедоступногоТекста);
	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	#КонецОбласти
	
	#Область ГрафикПроцентов
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ГрафикНачисленияПроцентов.Имя);
	
	ГруппаОтбора = Элемент.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбора.Использование = Истина;
	ГруппаОтбора.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;
	
	ОтборЭлемента = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ГрафикНачисленияПроцентов.Дата");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Меньше;
	ОтборЭлемента.ПравоеЗначение = Новый ПолеКомпоновкиДанных("Дата");
	
	ОтборЭлемента = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ГрафикНачисленияПроцентов.Дата");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветНедоступногоТекста);
	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	#КонецОбласти
	
КонецПроцедуры

&НаСервере
Функция ПоместитьГрафикиВХранилище() 
	
	ОбновитьОбщиеГрафики();
	
	ГрафикОплатУслугОбщий.Сортировать("ОсновноеСредство, Дата");
	ГрафикНачисленияУслугОбщий.Сортировать("ОсновноеСредство, Дата");
	ГрафикНачисленияПроцентовОбщий.Сортировать("ОсновноеСредство, Дата");
	
	ГрафикиДоговора = Новый Структура;
	ГрафикиДоговора.Вставить("ГрафикОплатУслуг", ГрафикОплатУслугОбщий.Выгрузить());
	ГрафикиДоговора.Вставить("ГрафикНачисленияУслуг", ГрафикНачисленияУслугОбщий.Выгрузить());
	ГрафикиДоговора.Вставить("ГрафикНачисленияПроцентов", ГрафикНачисленияПроцентовОбщий.Выгрузить());
	ГрафикиДоговора.Вставить("ТаблицаОС", ТаблицаОС.Выгрузить());
	
	Возврат ПоместитьВоВременноеХранилище(ГрафикиДоговора, УникальныйИдентификатор);
	
КонецФункции

&НаСервере
Процедура ОбновитьОбщиеГрафики()

	НайденныеСтрокиПоОС = ГрафикОплатУслугОбщий.НайтиСтроки(Новый Структура("ОсновноеСредство", ОсновноеСредство));
	Для Каждого НайденнаяСтрока Из НайденныеСтрокиПоОС Цикл
		ГрафикОплатУслугОбщий.Удалить(НайденнаяСтрока);
	КонецЦикла;
	
	НайденныеСтрокиПоОС = ГрафикНачисленияУслугОбщий.НайтиСтроки(Новый Структура("ОсновноеСредство", ОсновноеСредство));
	Для Каждого НайденнаяСтрока Из НайденныеСтрокиПоОС Цикл
		ГрафикНачисленияУслугОбщий.Удалить(НайденнаяСтрока);
	КонецЦикла;
	
	Если ГрафикНачисленияПроцентовВведенВручную Тогда
		НайденныеСтрокиПоОС = ГрафикНачисленияПроцентовОбщий.НайтиСтроки(Новый Структура("ОсновноеСредство", ОсновноеСредство));
		Для Каждого НайденнаяСтрока Из НайденныеСтрокиПоОС Цикл
			ГрафикНачисленияПроцентовОбщий.Удалить(НайденнаяСтрока);
		КонецЦикла;
	КонецЕсли;
	
	Для Каждого ТекущаяСтрокаГрафика Из ГрафикОплатУслуг Цикл
		СтрокаГрафикаОплат = ГрафикОплатУслугОбщий.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаГрафикаОплат, ТекущаяСтрокаГрафика);
		СтрокаГрафикаОплат.ОсновноеСредство = ОсновноеСредство;
	КонецЦикла;
	
	Для Каждого ТекущаяСтрокаГрафика Из ГрафикНачисленияУслуг Цикл
		СтрокаГрафикаОплат = ГрафикНачисленияУслугОбщий.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаГрафикаОплат, ТекущаяСтрокаГрафика);
		СтрокаГрафикаОплат.ОсновноеСредство = ОсновноеСредство;
	КонецЦикла;
	
	Если ГрафикНачисленияПроцентовВведенВручную Тогда
		Для Каждого ТекущаяСтрокаГрафика Из ГрафикНачисленияПроцентов Цикл
			СтрокаГрафикаОплат = ГрафикНачисленияПроцентовОбщий.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаГрафикаОплат, ТекущаяСтрокаГрафика);
			СтрокаГрафикаОплат.ОсновноеСредство = ОсновноеСредство;
		КонецЦикла;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ЗавершитьРедактированиеЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;

	Модифицированность = Ложь;

	Закрыть(ПоместитьГрафикиВХранилище());
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьПодтверждениеЗакрытияФормыЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	ЗавершитьРедактирование(Неопределено);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьИтоги(Форма)
	
	Оплата_УслугаПоАренде_Итого = 0;
	Оплата_НДС_Итого = 0;
	Начисление_УслугаПоАренде_Итого = 0;
	Начисление_НДС_Итого = 0;
	Проценты_Итого = 0;
	Авансы_Итого = 0;
	
	Оплата_УслугаПоАренде_ДоИзменения = 0;
	Оплата_УслугаПоАренде_НДС_ДоИзменения = 0;
	Начисление_УслугаПоАренде_ДоИзменения = 0;
	Начисление_УслугаПоАренде_НДС_ДоИзменения = 0;
	
	Для Каждого СтрокаГрафика Из Форма.ГрафикОплатУслуг Цикл
		Если СтрокаГрафика.Дата < Форма.Дата Тогда
			Оплата_УслугаПоАренде_ДоИзменения = Оплата_УслугаПоАренде_ДоИзменения + СтрокаГрафика.УслугаПоАренде;
			Оплата_УслугаПоАренде_НДС_ДоИзменения = Оплата_УслугаПоАренде_НДС_ДоИзменения + СтрокаГрафика.УслугаПоАрендеНДС;
			Продолжить;
		КонецЕсли;
		Оплата_УслугаПоАренде_Итого = Оплата_УслугаПоАренде_Итого + СтрокаГрафика.УслугаПоАренде;
		Оплата_НДС_Итого = Оплата_НДС_Итого + СтрокаГрафика.УслугаПоАрендеНДС;
	КонецЦикла;
	
	Для Каждого СтрокаГрафика Из Форма.ГрафикНачисленияУслуг Цикл
		Если СтрокаГрафика.Дата < Форма.Дата Тогда
			Начисление_УслугаПоАренде_ДоИзменения = Начисление_УслугаПоАренде_ДоИзменения + СтрокаГрафика.УслугаПоАренде;
			Начисление_УслугаПоАренде_НДС_ДоИзменения = Начисление_УслугаПоАренде_НДС_ДоИзменения + СтрокаГрафика.УслугаПоАрендеНДС;
			Продолжить;
		КонецЕсли;
		Начисление_УслугаПоАренде_Итого = Начисление_УслугаПоАренде_Итого + СтрокаГрафика.УслугаПоАренде;
		Начисление_НДС_Итого = Начисление_НДС_Итого + СтрокаГрафика.УслугаПоАрендеНДС;
	КонецЦикла;
	
	Для Каждого СтрокаГрафика Из Форма.ГрафикНачисленияПроцентов Цикл
		Если СтрокаГрафика.Дата < Форма.Дата Тогда
			Продолжить;
		КонецЕсли;
		Проценты_Итого = Проценты_Итого + СтрокаГрафика.Проценты;
	КонецЦикла;
	
	Если Оплата_УслугаПоАренде_ДоИзменения <> Начисление_УслугаПоАренде_ДоИзменения Тогда
		Остаток = Оплата_УслугаПоАренде_ДоИзменения - Начисление_УслугаПоАренде_ДоИзменения;
		Начисление_УслугаПоАренде_Итого = Начисление_УслугаПоАренде_Итого - Остаток;
	КонецЕсли;
	
	Если Оплата_УслугаПоАренде_НДС_ДоИзменения <> Начисление_УслугаПоАренде_НДС_ДоИзменения Тогда
		Остаток = Оплата_УслугаПоАренде_НДС_ДоИзменения - Начисление_УслугаПоАренде_НДС_ДоИзменения;
		Начисление_НДС_Итого = Начисление_НДС_Итого - Остаток;
	КонецЕсли;
	
	Форма.Оплата_УслугаПоАренде_Итого = Оплата_УслугаПоАренде_Итого;
	Форма.Оплата_НДС_Итого = Оплата_НДС_Итого;
	Форма.Начисление_УслугаПоАренде_Итого = Начисление_УслугаПоАренде_Итого;
	Форма.Начисление_НДС_Итого = Начисление_НДС_Итого;
	Форма.Проценты_Итого = Проценты_Итого;
	Форма.Авансы_Итого =
		Начисление_УслугаПоАренде_Итого - Начисление_НДС_Итого - Оплата_УслугаПоАренде_Итого + Оплата_НДС_Итого;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьСуммыВГрафикеЗавершение(Значение, ДополнительныеПараметры) Экспорт
	
	Если Значение <> Неопределено Тогда
		
		ИмяТаблицы = ДополнительныеПараметры.ИмяТаблицы;
		
		Для Каждого ВыделеннаяСтрокаУслуг Из Элементы[ИмяТаблицы].ВыделенныеСтроки Цикл
			
			СтрокаУслуг = ЭтотОбъект[ИмяТаблицы].НайтиПоИдентификатору(ВыделеннаяСтрокаУслуг);
			Если СтрокаУслуг.Дата < Дата Тогда
				Продолжить;
			КонецЕсли;
			СтрокаУслуг["УслугаПоАренде"] = Значение;
			СтрокаУслуг["УслугаПоАрендеНДС"] = УчетНДСУПКлиентСервер.РассчитатьСуммуНДС(Значение, СтавкаНДС, Истина);
			Модифицированность = Истина;
			
		КонецЦикла;
		
		Если Модифицированность Тогда 
			ОбновитьИтоги(ЭтотОбъект);
		КонецЕсли;

	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция РассчитатьСуммуНДС(СуммаСНДС)
	
	ТекПроцентНДС = УчетНДСУПКлиентСервер.ЗначениеСтавкиНДС(СтавкаНДС);
	Возврат УчетНДСУПКлиентСервер.РассчитатьСуммуНДС(СуммаСНДС, ТекПроцентНДС, Истина);
	
КонецФункции

&НаКлиенте
Процедура НастроитьЗависимыеЭлементыФормы(Знач ИзмененныеРеквизиты = "")
	
	СтруктураИзмененныхРеквизитов = Новый Структура(ИзмененныеРеквизиты);
	
	ОбновитьВсе = СтруктураИзмененныхРеквизитов.Количество() = 0;
	
	Если ОбновитьВсе Тогда
		
		Если ТипЗнч(ВладелецФормы) = Тип("ФормаКлиентскогоПриложения") Тогда
			ЗначениеСвойства = НЕ (ВладелецФормы.ИмяФормы = "ОбщаяФорма.ЗаполнениеГрафиковДоходнойАренды");
			Элементы.Перезаполнить_ГрафикОплат.Доступность = ЗначениеСвойства;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНадписьОтборы()

	СтрокаШаблона = НСтр("ru = 'Договор: %1, Объект эксплуатации: %2';
						|en = 'Contract: %1, asset: %2'");
	НадписьОтборы = СтрШаблон(СтрокаШаблона, Строка(Договор), Строка(ОсновноеСредство));

КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьГрафик(ИмяГрафика)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ИмяГрафика", ИмяГрафика);
	ПараметрыФормы.Вставить("УникальныйИдентификаторВладельца", УникальныйИдентификатор);
	ПараметрыФормы.Вставить("ЕстьОбеспечительныйПлатеж", Ложь);
	ПараметрыФормы.Вставить("ЕстьВыкупПредметовАренды", Ложь);
	
	ОткрытьФорму("Справочник.ДоговорыАренды.Форма.ЗагрузкаГрафикаОплатИНачислений",
		ПараметрыФормы,
		ЭтотОбъект,,,,
		Новый ОписаниеОповещения("ЗагрузитьГрафикЗавершение", ЭтотОбъект, ИмяГрафика),
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьГрафикЗавершение(РезультатЗакрытия, ИмяГрафика) Экспорт
	
	Если ТипЗнч(РезультатЗакрытия) = Тип("Строка") 
		И ЭтоАдресВременногоХранилища(РезультатЗакрытия) Тогда
			
		ЗагрузитьГрафикЗавершениеНаСервере(РезультатЗакрытия, ИмяГрафика);
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ЗагрузитьГрафикЗавершениеНаСервере(Знач АдресРезультата, Знач ИмяГрафика)
	
	ТаблицаГрафика = ПолучитьИзВременногоХранилища(АдресРезультата); // - ТаблицаЗначений
	ТаблицаПриемник = ЭтотОбъект[ИмяГрафика];
	
	МассивУдаляемыхСтрок = Новый Массив;
	Для Каждого СтрокаГрафика Из ТаблицаПриемник Цикл
		Если СтрокаГрафика.Дата >= Дата Тогда
			МассивУдаляемыхСтрок.Добавить(СтрокаГрафика);
		КонецЕсли;
	КонецЦикла;
	Для Каждого УдаляемаяСтрока Из МассивУдаляемыхСтрок Цикл
		ТаблицаПриемник.Удалить(УдаляемаяСтрока);
	КонецЦикла;
	
	Для Каждого СтрокаГрафика Из ТаблицаГрафика Цикл
		Если СтрокаГрафика.Дата > Дата Тогда
			НоваяСтрокаГрафика = ТаблицаПриемник.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрокаГрафика, СтрокаГрафика);
		КонецЕсли;
	КонецЦикла;
	ТаблицаПриемник.Сортировать("Дата");
	
	УчетАрендованныхОС.ЗаполнитьСуммыНДСВГрафикахДоходнойАренды(ГрафикОплатУслуг, ГрафикНачисленияУслуг, СтавкаНДС, Дата);
	
	ОбновитьИтоги(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьГрафик()
	
	Если НЕ ЗначениеЗаполнено(ОсновноеСредство) Тогда
		Возврат;
	КонецЕсли;
	
	ЗаблокироватьДанныеФормыДляРедактирования();
	
	АдресГрафиков = ПоместитьГрафикиВХранилищеДляЗаполнения();
	
	ВыбранныеОС = Новый Массив;
	ВыбранныеОС.Добавить(ОсновноеСредство);
	
	УчетАрендованныхОСКлиент.ОткрытьЗаполнениеГрафиковДоходнойАренды(
		ЭтотОбъект,
		ЭтотОбъект,
		ВыбранныеОС,
		АдресГрафиков,
		Новый ОписаниеОповещения("ЗаполнитьГрафикОплатИНачисленийЗавершение", ЭтотОбъект));
		
КонецПроцедуры
	
&НаСервере
Функция ПоместитьГрафикиВХранилищеДляЗаполнения()
	
	ОбновитьОбщиеГрафики();

	ГрафикиДоговора = Новый Структура;
	ГрафикиДоговора.Вставить("ГрафикНачисленияУслуг", ГрафикНачисленияУслугОбщий.Выгрузить());
	ГрафикиДоговора.Вставить("ГрафикОплатУслуг", ГрафикОплатУслугОбщий.Выгрузить());
	ГрафикиДоговора.Вставить("ГрафикНачисленияПроцентов", ГрафикНачисленияПроцентовОбщий.Выгрузить());
	ГрафикиДоговора.Вставить("ТаблицаОС", ТаблицаОС.Выгрузить());

	Адрес = ПоместитьВоВременноеХранилище(ГрафикиДоговора, УникальныйИдентификатор);
	
	Возврат Адрес;
	
КонецФункции

&НаКлиенте
Процедура ЗаполнитьГрафикОплатИНачисленийЗавершение(РезультатЗакрытия, ДопПараметры) Экспорт

	Если НЕ ЭтоАдресВременногоХранилища(РезультатЗакрытия) Тогда
		Возврат
	КонецЕсли;

	ЗаполнитьГрафикОплатИНачисленийЗавершениеНаСервере(РезультатЗакрытия);

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьГрафикОплатИНачисленийЗавершениеНаСервере(Знач РезультатЗакрытия)
	
	Модифицированность = Истина;

	ЗагрузитьГрафики(РезультатЗакрытия);
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьГрафики(АдресГрафиков)
	
	ГрафикиДоговора = ПолучитьИзВременногоХранилища(АдресГрафиков);
	
	ГрафикОплатУслугОбщий.Загрузить(ГрафикиДоговора.ГрафикОплатУслуг);
	ГрафикНачисленияУслугОбщий.Загрузить(ГрафикиДоговора.ГрафикНачисленияУслуг);
	ГрафикНачисленияПроцентовОбщий.Загрузить(ГрафикиДоговора.ГрафикНачисленияПроцентов);
	
	ТаблицаОС.Загрузить(ГрафикиДоговора.ТаблицаОС);
	
	ГрафикОплатУслуг.Очистить();
	ГрафикНачисленияУслуг.Очистить();
	ГрафикНачисленияПроцентов.Очистить();
	
	НайденныеСтрокиПоОС = ГрафикОплатУслугОбщий.НайтиСтроки(Новый Структура("ОсновноеСредство", ОсновноеСредство));
	Для Каждого НайденнаяСтрока Из НайденныеСтрокиПоОС Цикл
		СтрокаОплаты = ГрафикОплатУслуг.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаОплаты, НайденнаяСтрока);
	КонецЦикла;
	
	НайденныеСтрокиПоОС = ГрафикНачисленияУслугОбщий.НайтиСтроки(Новый Структура("ОсновноеСредство", ОсновноеСредство));
	Для Каждого НайденнаяСтрока Из НайденныеСтрокиПоОС Цикл
		СтрокаНачисления = ГрафикНачисленияУслуг.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаНачисления, НайденнаяСтрока);
	КонецЦикла;
	
	ГрафикЗаполненИзРегистра = Ложь;
	Если ОтображатьГрафикПроцентовИзРегистра И НЕ ГрафикНачисленияПроцентовВведенВручную Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ГрафикНачисленияПроцентовПоДоходнойАренде.Дата,
		|	ГрафикНачисленияПроцентовПоДоходнойАренде.Проценты
		|ИЗ
		|	РегистрСведений.ГрафикНачисленияПроцентовПоДоходнойАренде КАК ГрафикНачисленияПроцентовПоДоходнойАренде
		|ГДЕ
		|	ГрафикНачисленияПроцентовПоДоходнойАренде.Регистратор = &Регистратор
		|	И ГрафикНачисленияПроцентовПоДоходнойАренде.ОсновноеСредство = &ОсновноеСредство";
		Запрос.УстановитьПараметр("Регистратор", Ссылка);
		Запрос.УстановитьПараметр("ОсновноеСредство", ОсновноеСредство);
		РезультатЗапроса = Запрос.Выполнить();
		
		Если НЕ РезультатЗапроса.Пустой() Тогда
			ГрафикЗаполненИзРегистра = Истина;
			Выборка = РезультатЗапроса.Выбрать();
			Пока Выборка.Следующий() Цикл
				СтрокаПроцентов = ГрафикНачисленияПроцентов.Добавить();
				ЗаполнитьЗначенияСвойств(СтрокаПроцентов, Выборка);
			КонецЦикла;
		КонецЕсли;
		
	КонецЕсли;
	
	Если НЕ ГрафикЗаполненИзРегистра Тогда
		НайденныеСтрокиПоОС = ГрафикНачисленияПроцентовОбщий.НайтиСтроки(Новый Структура("ОсновноеСредство", ОсновноеСредство));
		Для Каждого НайденнаяСтрока Из НайденныеСтрокиПоОС Цикл
			СтрокаПроцентов = ГрафикНачисленияПроцентов.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаПроцентов, НайденнаяСтрока);
		КонецЦикла;
	КонецЕсли;
	
	ОбновитьИтоги(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура НастроитьЗависимыеЭлементыФормыНаКлиентеНаСервере(Знач Форма, Знач ИзмененныеРеквизиты = "")
	
	СтруктураИзмененныхРеквизитов = Новый Структура(ИзмененныеРеквизиты);
	
	ОбновитьВсе = СтруктураИзмененныхРеквизитов.Количество() = 0;
	
	Элементы = Форма.Элементы;
	
	Если ОбновитьВсе Тогда
		
		ГрафикВсегдаВводитсяВручную = ТипЗнч(Форма.Ссылка) = Тип("ДокументСсылка.ВводОстатковИнвестицииВАренду");
		Элементы.ГрафикНачисленияПроцентовВведенВручную.Доступность = НЕ ГрафикВсегдаВводитсяВручную;
		
	КонецЕсли;
	
	Если СтруктураИзмененныхРеквизитов.Свойство("ГрафикНачисленияПроцентовВведенВручную")
		ИЛИ ОбновитьВсе Тогда
			
		РедактированиеГрафикаДоступно = 
			Форма.ГрафикНачисленияПроцентовВведенВручную
			И НЕ Форма.ТолькоПросмотр;
		
		Элементы.ГрафикНачисленияПроцентов.ТолькоПросмотр = НЕ РедактированиеГрафикаДоступно;
		Элементы.ГрафикНачисленияПроцентовЗагрузитьГрафик_ГрафикПроцентов.Доступность = РедактированиеГрафикаДоступно;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииДатыГрафика(ИмяГрафика)
	
	Если НЕ ЗначениеЗаполнено(ИмяГрафика) Тогда
		Возврат;
	КонецЕсли;

	ТекущиеДанные = Элементы[ИмяГрафика].ТекущиеДанные;
	
	ОчиститьСообщения();
	
	Если ТекущиеДанные <> Неопределено
		И ЗначениеЗаполнено(ТекущиеДанные.Дата)
		И ТекущиеДанные.Дата < Дата Тогда
		ТекстПредупреждения = 
			СтрШаблон(НСтр("ru = 'Дата графика не должна быть меньше даты документа: %1.';
							|en = 'The schedule date cannot be earlier than the document date: %1.'"), Формат(Дата, "ДЛФ=D"));
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстПредупреждения,, ИмяГрафика);
		ТекущиеДанные.Дата = '00010101';
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ГрафикПередУдалением(Элемент, Отказ)
	
	ТекущиеДанные = Элемент.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено
		И ЗначениеЗаполнено(ТекущиеДанные.Дата)
		И ТекущиеДанные.Дата < Дата Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ГрафикПередНачаломДобавления(Элемент, Отказ, Копирование)
	
	Если Копирование И Элемент.ТекущиеДанные.Дата < Дата Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти