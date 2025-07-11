#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Период = НачалоМесяца(ТекущаяДатаСеанса());
	КоличествоМесяцев = 3;
	
	#Область Отборы
	
	СтруктураБыстрогоОтбора = Неопределено;
	Параметры.Свойство("СтруктураБыстрогоОтбора", СтруктураБыстрогоОтбора);
	
	ОтборыСписковКлиентСервер.ОтборПоЗначениюСпискаПриСозданииНаСервере(Список, "Организация", Организация, СтруктураБыстрогоОтбора);
	ОтборыСписковКлиентСервер.ОтборПоЗначениюСпискаПриСозданииНаСервере(Список, "Подразделение", Подразделение, СтруктураБыстрогоОтбора);
	
	#КонецОбласти
	
	#Область УниверсальныеМеханизмы
	
	ТекущиеДелаПереопределяемый.ПриСозданииНаСервере(ЭтаФорма, Список);
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПриСозданииНаСервере(ЭтаФорма, Элементы.ГлобальныеКоманды);
	// Конец ИнтеграцияС1СДокументооборотом

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

	// СтандартныеПодсистемы.ПодключаемыеКоманды
	
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	#КонецОбласти
	
	МесяцСтрока = ОбщегоНазначенияУТКлиентСервер.ПолучитьПредставлениеПериодаРегистрации(ТекущаяДатаСеанса());	
	ЗаполнитьНормативы();
	
КонецПроцедуры

&НаСервере
Процедура ПередЗагрузкойДанныхИзНастроекНаСервере(Настройки)
	
	ТекущиеДелаПереопределяемый.ПередЗагрузкойДанныхИзНастроекНаСервере(ЭтаФорма, Настройки);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	Перем СтруктураОтборов;
	
	Если Параметры.Свойство("СтруктураОтборов", СтруктураОтборов) Тогда
		
		Если СтруктураОтборов.Свойство("Подразделение") Тогда
			Настройки.Вставить("Подразделение", СтруктураОтборов.Подразделение)
		КонецЕсли;
		
		Если СтруктураОтборов.Свойство("Организация") Тогда
			Настройки.Вставить("Организация", СтруктураОтборов.Организация)
		КонецЕсли;
		
	КонецЕсли;
	
	ОтборыСписковКлиентСервер.ОтборПоЗначениюСпискаПриЗагрузкеИзНастроек(Список, "Подразделение", Подразделение, СтруктураБыстрогоОтбора, Настройки);
	ОтборыСписковКлиентСервер.ОтборПоЗначениюСпискаПриЗагрузкеИзНастроек(Список, "Организация", Организация, СтруктураБыстрогоОтбора, Настройки);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПодразделениеОтборПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Подразделение", Подразделение, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(Подразделение));
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияОтборПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Организация", Организация, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(Организация));
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияКУстановкеПриИзменении(Элемент)

	ЗаполнитьНормативы();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборСостояниеПриИзменении(Элемент)
	
	ЗаполнитьНормативы();
	
КонецПроцедуры

&НаКлиенте
Процедура МесяцСтрокаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения("МесяцСтрокаНачалоВыбораЗавершение", ЭтотОбъект);
	ОбщегоНазначенияУТКлиент.НачалоВыбораПредставленияПериодаРегистрации(Элемент, СтандартнаяОбработка, Период, ЭтаФорма, Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура МесяцСтрокаНачалоВыбораЗавершение(ВыбранныйПериод, ДополнительныеПараметры) Экспорт 
	
	Если ВыбранныйПериод <> Неопределено Тогда
		
		Период = ВыбранныйПериод;
		МесяцСтрока = ОбщегоНазначенияУТКлиент.ПолучитьПредставлениеПериодаРегистрации(Период);
		
	КонецЕсли;
	
	ЗаполнитьНормативы();
	
КонецПроцедуры

&НаКлиенте
Процедура МесяцСтрокаРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Период = ДобавитьМесяц(Период, Направление);
	МесяцСтрока = ОбщегоНазначенияУТКлиент.ПолучитьПредставлениеПериодаРегистрации(Период);
	
	ЗаполнитьНормативы();
	
КонецПроцедуры

&НаКлиенте
Процедура МесяцСтрокаОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура КоличествоМесяцевПриИзменении(Элемент)
	
	ЗаполнитьНормативы();
	
КонецПроцедуры

&НаКлиенте
Процедура НормативыКУстановкеВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущиеДанные = НормативыКУстановке.НайтиПоИдентификатору(ВыбраннаяСтрока);
	
	Если ЗначениеЗаполнено(ТекущиеДанные.Ссылка) Тогда
		ПоказатьЗначение(, ТекущиеДанные.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийСписков

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


#Область Универсальные

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Элементы.Список);
	
КонецПроцедуры
// Конец ИнтеграцияС1СДокументооборотом

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
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

&НаКлиенте
Процедура НормативыПроизводственныхРасходов(Команда)
	
	Если Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.КУстановке Тогда
		
		ТекущиеДанные = Элементы.НормативыКУстановке.ТекущиеДанные;
		ПараметрПериод = Новый СтандартныйПериод(ДобавитьМесяц(Период, -КоличествоМесяцев), КонецМесяца(Период));
		
	Иначе
		
		ТекущиеДанные = Элементы.Список.ТекущиеДанные;
		КонецПериода = ТекущиеДанные.ДатаОкончанияДействия;
		Если Не ЗначениеЗаполнено(КонецПериода) Тогда
			КонецПериода = КонецГода(ТекущиеДанные.ДатаНачалаДействия);
		КонецЕсли;
		
		ПараметрПериод = Новый СтандартныйПериод(ТекущиеДанные.ДатаНачалаДействия, КонецПериода);
		
	КонецЕсли;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Отбор = Новый Структура;
	Отбор.Вставить("СтандартныйПериод", ПараметрПериод);
	Отбор.Вставить("Организация", ТекущиеДанные.Организация);
	Отбор.Вставить("Подразделение", ТекущиеДанные.Подразделение);
	
	ПараметрыФормы = Новый Структура("КлючВарианта, КлючНазначенияИспользования, Отбор, СформироватьПриОткрытии, ВидимостьКомандВариантовОтчетов");
	ПараметрыФормы.Вставить("КлючНазначенияИспользования",		Неопределено);
	ПараметрыФормы.Вставить("Отбор",							Отбор);
	ПараметрыФормы.Вставить("СформироватьПриОткрытии",			Истина);
	ПараметрыФормы.Вставить("ВидимостьКомандВариантовОтчетов",	Ложь);
	
	ОткрытьФорму("Отчет.ПлановыеИФактическиеНормативыПроизводственныхРасходов.Форма", ПараметрыФормы);
	
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура УстановитьНормативы(Команда)
	
	ТекущиеДанные = Элементы.НормативыКУстановке.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыЗаполнения = Новый Структура;
	ПараметрыЗаполнения.Вставить("Организация", ТекущиеДанные.Организация);
	ПараметрыЗаполнения.Вставить("Подразделение", ТекущиеДанные.Подразделение);
	ПараметрыЗаполнения.Вставить("ДатаНачалаДействия", Период);
	ПараметрыЗаполнения.Вставить("КоличествоМесяцев", КоличествоМесяцев);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ЗначенияЗаполнения", ПараметрыЗаполнения);
	
	ОткрытьФорму("Документ.УстановкаНормативовПроизводственныхРасходов.Форма.ФормаДокумента", ПараметрыФормы);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();
	
	СтандартныеПодсистемыСервер.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "Список", "Дата");
	
	// Нормативы просрочены.
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.НормативыКУстановкеЗавершение.Имя);
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.НормативыКУстановкеСостояниеНормативов.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("НормативыКУстановке.СостояниеНормативов");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = "Просрочены";
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.Красный);
	
	// Нормативы бессрочны.
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.НормативыКУстановкеЗавершение.Имя);
	
	ГруппаОтбораИ = Элемент.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбораИ.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;
	
	ОтборЭлемента = ГруппаОтбораИ.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("НормативыКУстановке.СостояниеНормативов");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = "Установлены";
	
	ОтборЭлемента = ГруппаОтбораИ.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("НормативыКУстановке.ОкончаниеДействия");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'Бессрочно';
																|en = 'Permanent'"));
	
	// Представление состояния "Не установлены".
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.НормативыКУстановкеСостояниеНормативов.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("НормативыКУстановке.СостояниеНормативов");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = "НеУстановлены";
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'Не установлены';
																|en = 'Not set'"));
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНормативы()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ПрочиеРасходыОбороты.Организация КАК Организация,
		|	ПрочиеРасходыОбороты.Подразделение КАК Подразделение
		|ПОМЕСТИТЬ Расходы
		|ИЗ
		|	РегистрНакопления.ПрочиеРасходыНезавершенногоПроизводства.Обороты(
		|			&НачалоПериода,
		|			&ОкончаниеПериода,
		|			,
		|			СтатьяРасходов.ВариантРаспределенияРасходовУпр = ЗНАЧЕНИЕ(Перечисление.ВариантыРаспределенияРасходов.НаПроизводственныеЗатраты)
		|				И (Организация = &Организация
		|					ИЛИ &ПоВсемОрганизациям)) КАК ПрочиеРасходыОбороты
		|ГДЕ
		|	ПрочиеРасходыОбороты.СтоимостьПриход > 0
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	МАКСИМУМ(Нормативы.Дата) КАК Дата,
		|	Нормативы.Организация КАК Организация,
		|	Нормативы.Подразделение КАК Подразделение
		|ПОМЕСТИТЬ МаксимальныеДатыУстановкиНормативов
		|ИЗ
		|	Документ.УстановкаНормативовПроизводственныхРасходов КАК Нормативы
		|ГДЕ
		|	Нормативы.ДатаНачалаДействия <= &Период
		|	И НЕ Нормативы.ПометкаУдаления
		|	И (Нормативы.Организация = &Организация
		|			ИЛИ &ПоВсемОрганизациям)
		|
		|СГРУППИРОВАТЬ ПО
		|	Нормативы.Организация,
		|	Нормативы.Подразделение
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	МаксимальныеДатыУстановкиНормативов.Организация КАК Организация,
		|	МаксимальныеДатыУстановкиНормативов.Подразделение КАК Подразделение,
		|	МАКСИМУМ(Нормативы.Ссылка) КАК Ссылка
		|ПОМЕСТИТЬ АктуальныеДокументыНормативов
		|ИЗ
		|	МаксимальныеДатыУстановкиНормативов КАК МаксимальныеДатыУстановкиНормативов
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.УстановкаНормативовПроизводственныхРасходов КАК Нормативы
		|		ПО МаксимальныеДатыУстановкиНормативов.Дата = Нормативы.Дата
		|			И МаксимальныеДатыУстановкиНормативов.Организация = Нормативы.Организация
		|			И МаксимальныеДатыУстановкиНормативов.Подразделение = Нормативы.Подразделение
		|			И (НЕ Нормативы.ПометкаУдаления)
		|
		|СГРУППИРОВАТЬ ПО
		|	МаксимальныеДатыУстановкиНормативов.Организация,
		|	МаксимальныеДатыУстановкиНормативов.Подразделение
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ЕСТЬNULL(АктуальныеДокументыПоПериодам.Организация, Расходы.Организация) КАК Организация,
		|	ЕСТЬNULL(АктуальныеДокументыПоПериодам.Подразделение, Расходы.Подразделение) КАК Подразделение,
		|	ЕСТЬNULL(УстановкаНормативовПроизводственныхРасходов.ДатаОкончанияДействия, ДАТАВРЕМЯ(1, 1, 1)) КАК ОкончаниеДействия,
		|	ВЫБОР
		|		КОГДА УстановкаНормативовПроизводственныхРасходов.ДатаОкончанияДействия ЕСТЬ NULL
		|			ТОГДА ""НеУстановлены""
		|		КОГДА УстановкаНормативовПроизводственныхРасходов.ДатаОкончанияДействия < &Период
		|				И НЕ УстановкаНормативовПроизводственныхРасходов.ДатаОкончанияДействия = ДАТАВРЕМЯ(1, 1, 1)
		|			ТОГДА ""Просрочены""
		|		ИНАЧЕ ""Установлены""
		|	КОНЕЦ КАК СостояниеНормативов,
		|	ВЫБОР
		|		КОГДА Расходы.Организация ЕСТЬ NULL
		|			ТОГДА ЛОЖЬ
		|		ИНАЧЕ ИСТИНА
		|	КОНЕЦ КАК ЕстьРасходы,
		|	УстановкаНормативовПроизводственныхРасходов.Ссылка КАК Ссылка
		|ИЗ
		|	Расходы КАК Расходы
		|		ПОЛНОЕ СОЕДИНЕНИЕ АктуальныеДокументыНормативов КАК АктуальныеДокументыПоПериодам
		|		ПО Расходы.Организация = АктуальныеДокументыПоПериодам.Организация
		|			И Расходы.Подразделение = АктуальныеДокументыПоПериодам.Подразделение
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.УстановкаНормативовПроизводственныхРасходов КАК УстановкаНормативовПроизводственныхРасходов
		|		ПО АктуальныеДокументыПоПериодам.Ссылка = УстановкаНормативовПроизводственныхРасходов.Ссылка
		|ГДЕ
		|	(ВЫБОР
		|				КОГДА УстановкаНормативовПроизводственныхРасходов.ДатаОкончанияДействия ЕСТЬ NULL
		|					ТОГДА ""НеУстановлены""
		|				КОГДА УстановкаНормативовПроизводственныхРасходов.ДатаОкончанияДействия < &Период
		|						И НЕ УстановкаНормативовПроизводственныхРасходов.ДатаОкончанияДействия = ДАТАВРЕМЯ(1, 1, 1)
		|					ТОГДА ""Просрочены""
		|				ИНАЧЕ ""Установлены""
		|			КОНЕЦ = &Состояние
		|			ИЛИ &ПоВсемСостояниям)";
	
	Запрос.УстановитьПараметр("Период", Период);
	Запрос.УстановитьПараметр("НачалоПериода", ДобавитьМесяц(Период, -КоличествоМесяцев));
	Запрос.УстановитьПараметр("ОкончаниеПериода", Новый Граница(КонецМесяца(Период), ВидГраницы.Включая));
	Запрос.УстановитьПараметр("Организация", ОтборОрганизацияКУстановке);
	Запрос.УстановитьПараметр("ПоВсемОрганизациям", Не ЗначениеЗаполнено(ОтборОрганизацияКУстановке));
	Запрос.УстановитьПараметр("Состояние", ОтборСостояние);
	Запрос.УстановитьПараметр("ПоВсемСостояниям", Не ЗначениеЗаполнено(ОтборСостояние));
	
	НормативыКУстановке.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры

#КонецОбласти
