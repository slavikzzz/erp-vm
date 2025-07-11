
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);

	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПриЧтенииСозданииНаСервере();
	КонецЕсли;
	
	// подсистема запрета редактирования ключевых реквизитов объектов	
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтаФорма);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.УправлениеДоступом

	ПриЧтенииСозданииНаСервере();	

	МодификацияКонфигурацииПереопределяемый.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	УстановитьДоступность();
	УстановитьПараметрыФункциональныхОпцийФормы(Новый Структура("Склад, Помещение", Объект.Владелец, Объект.Ссылка));
	
	// подсистема запрета редактирования ключевых реквизитов объектов	
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтаФорма);
	
	Если Объект.НастройкаАдресногоХранения = Перечисления.НастройкиАдресногоХранения.ЯчейкиОстатки
		 И Не ПолучитьФункциональнуюОпцию("ИспользоватьУпаковкиНоменклатуры") Тогда
   		 ОповещатьОбОтключенныхУпаковках = Истина;
	КонецЕсли;

	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	НеобходимоОбновлятьИнтерфейс = Ложь;
	
	Для Каждого СтрСтруктуры Из КешРеквизитов Цикл
		Если Объект[СтрСтруктуры.Ключ] <> СтрСтруктуры.Значение Тогда
			НеобходимоОбновлятьИнтерфейс = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если НеобходимоОбновлятьИнтерфейс Тогда
		ОбновитьИнтерфейс();
		
		КешРеквизитовСтруктура = Новый Структура;
		КешРеквизитовСтруктура.Вставить("ИспользованиеРабочихУчастков",Объект.ИспользованиеРабочихУчастков);
		КешРеквизитовСтруктура.Вставить("НастройкаАдресногоХранения",Объект.НастройкаАдресногоХранения);
		
		КешРеквизитов = Новый ФиксированнаяСтруктура(КешРеквизитовСтруктура);
	КонецЕсли;
	
	Если ОповещатьОбОтключенныхУпаковках Тогда
		ТекстСообщения = НСтр("ru = 'В настройках учета отключено использование упаковок номенклатуры. Оприходовать товар на склад
		|с хранением остатков в разрезе ячеек без указания упаковок невозможно.';
		|en = 'Usage of item packages is disabled in the accounting settings. Specify the package in the goods receipt 
		|because bins management is enabled in the warehouse.'");
		ПоказатьПредупреждение(, ТекстСообщения);
	КонецЕсли;

	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульПодключаемыеКомандыКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ПодключаемыеКомандыКлиент");
		МодульПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)

	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НастройкаАдресногоХраненияПриИзменении(Элемент)
	
	НастройкаАдресногоХраненияПриИзмененииСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкаАдресногоХраненияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТипСклада = ОбщегоНазначенияУТВызовСервера.ЗначениеРеквизитаОбъекта(Объект.Владелец, "ТипСклада");
	
	ДанныеВыбора = Новый СписокЗначений;
	ДанныеВыбора.Добавить(ПредопределенноеЗначение("Перечисление.НастройкиАдресногоХранения.НеИспользовать"));
	ДанныеВыбора.Добавить(ПредопределенноеЗначение("Перечисление.НастройкиАдресногоХранения.ЯчейкиСправочно"));
	Если ТипСклада <> ПредопределенноеЗначение("Перечисление.ТипыСкладов.РозничныйМагазин") Тогда
		ДанныеВыбора.Добавить(ПредопределенноеЗначение("Перечисление.НастройкиАдресногоХранения.ЯчейкиОстатки"));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкаАдресногоХраненияОчистка(Элемент, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

// Обработчик команды, создаваемой механизмом запрета редактирования ключевых реквизитов.
//
&НаКлиенте
Процедура Подключаемый_РазрешитьРедактированиеРеквизитовОбъекта(Команда)

	Если Не Объект.Ссылка.Пустая() Тогда
		ОткрытьФорму("Справочник.СкладскиеПомещения.Форма.РазблокированиеРеквизитов",,,,,, 
			Новый ОписаниеОповещения("Подключаемый_РазрешитьРедактированиеРеквизитовОбъектаЗавершение", ЭтотОбъект), 
			РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_РазрешитьРедактированиеРеквизитовОбъектаЗавершение(Результат, ДополнительныеПараметры) Экспорт
    
    Если ТипЗнч(Результат) = Тип("Массив") И Результат.Количество() > 0 Тогда
        
        ЗапретРедактированияРеквизитовОбъектовКлиент.УстановитьДоступностьЭлементовФормы(ЭтаФорма, Результат);
        
    КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура НастройкиАдресныхСкладов(Команда)
	
	СтруктураИзмерений = Новый Структура;
	СтруктураИзмерений.Вставить("Склад", Объект.Владелец);
	СтруктураИзмерений.Вставить("Помещение", Объект.Ссылка);
	МассивПараметровКонструктора = Новый Массив();
	МассивПараметровКонструктора.Добавить(СтруктураИзмерений);
	КлючЗаписи = Новый("РегистрСведенийКлючЗаписи.НастройкиАдресныхСкладов", МассивПараметровКонструктора);
	ПараметрыФормы = Новый Структура("Ключ", КлючЗаписи);
	ОткрытьФорму("РегистрСведений.НастройкиАдресныхСкладов.ФормаЗаписи", ПараметрыФормы, ЭтаФорма,,);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()
	УстановитьПараметрыФункциональныхОпцийФормы(Новый Структура("Склад, Помещение", Объект.Владелец, Объект.Ссылка));
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		КешРеквизитовСтруктура = Новый Структура;
		КешРеквизитовСтруктура.Вставить("НастройкаАдресногоХранения",Объект.НастройкаАдресногоХранения);
	Иначе
		КешРеквизитовСтруктура = Новый Структура;
		КешРеквизитовСтруктура.Вставить("НастройкаАдресногоХранения",Неопределено);
	КонецЕсли;
	
	КешРеквизитов = Новый ФиксированнаяСтруктура(КешРеквизитовСтруктура);
	
	// подсистема запрета редактирования ключевых реквизитов объектов	
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтаФорма);
	
	УстановитьДоступность();
	
КонецПроцедуры

&НаСервере
Процедура НастройкаАдресногоХраненияПриИзмененииСервер()
	
	Если Объект.НастройкаАдресногоХранения = Перечисления.НастройкиАдресногоХранения.НеИспользовать Тогда
		Объект.ИспользованиеРабочихУчастков = Перечисления.ИспользованиеСкладскихРабочихУчастков.НеИспользовать
	КонецЕсли;
	
	УстановитьДоступность();
	
	Если НЕ (Объект.НастройкаАдресногоХранения = Перечисления.НастройкиАдресногоХранения.ЯчейкиОстатки)
		ИЛИ НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Возврат;
	КонецЕсли;
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("Склад", Объект.Владелец);
	Запрос.УстановитьПараметр("Помещение", Объект.Ссылка);
	Запрос.Текст = Справочники.Склады.ТекстЗапросаПоДокументамЗависящимОтИспользованияАдресногоХранения(Истина);
	
	УстановитьПривилегированныйРежим(Истина);
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	Если ЗначениеЗаполнено(Выборка.Дата) Тогда
		РекомендуемаяДата = Выборка.Дата + 60 * 60 * 24;
		Объект.ДатаНачалаАдресногоХраненияОстатков = Макс(ТекущаяДатаСеанса(), РекомендуемаяДата);
	Иначе
		Элементы.ДатаНачалаАдресногоХраненияОстатков.ТолькоПросмотр = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьДоступность()
	
	ТипСклада = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.Владелец, "ТипСклада");
	
	Элементы.ИспользованиеРабочихУчастков.Доступность = (Объект.НастройкаАдресногоХранения = Перечисления.НастройкиАдресногоХранения.ЯчейкиОстатки
														Или Объект.НастройкаАдресногоХранения = Перечисления.НастройкиАдресногоХранения.ЯчейкиСправочно)
														И (НЕ ТипСклада = Перечисления.ТипыСкладов.РозничныйМагазин);
	Элементы.НастройкаАдресногоХранения.ТолькоПросмотр = Объект.НастройкаАдресногоХранения = Перечисления.НастройкиАдресногоХранения.ЯчейкиОстатки
			И Элементы.НастройкаАдресногоХранения.ТолькоПросмотр;
	
	Если Объект.НастройкаАдресногоХранения = Перечисления.НастройкиАдресногоХранения.ЯчейкиОстатки Тогда
		Элементы.СтраницыНастроекАдресныхСкладов.ТекущаяСтраница = Элементы.СтраницаГиперСсылка;
		Элементы.СтраницыДатаНачалаАдресногоХраненияОстатков.ТекущаяСтраница = Элементы.СтраницаДатаНачалаАдресногоХраненияОстатковДата;
	Иначе
		Элементы.СтраницыНастроекАдресныхСкладов.ТекущаяСтраница = Элементы.СтраницаПустая;
		Элементы.СтраницыДатаНачалаАдресногоХраненияОстатков.ТекущаяСтраница = Элементы.СтраницаДатаНачалаАдресногоХраненияОстатковПустая;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
