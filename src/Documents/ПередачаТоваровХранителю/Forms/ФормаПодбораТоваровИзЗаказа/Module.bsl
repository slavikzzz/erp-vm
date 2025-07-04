#Область ОписаниеПеременных

&НаКлиенте
Перем КэшированныеЗначения; // Используется механизмом обработки изменения реквизитов ТЧ.

&НаКлиенте
Перем ВыполняетсяЗакрытие;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ПередачаПоЗаказам = Параметры.ПередачаПоЗаказам;
	ЗаказКлиента      = Параметры.ЗаказКлиента;
	ВалютаДокумента   = Параметры.ВалютаДокумента;
	НачатаОтгрузка    = НакладныеСервер.ЕстьРасходныйОрдерДляЗаказовНаОтгрузку(Параметры.Документ);
	
	ИспользоватьОрдернуюСхемуПриОтгрузке     = Параметры.ОрдернаяСхемаПриОтгрузке;
	АдресТоваровПередачиВоВременномХранилище = Параметры.АдресТоваровПередачиВоВременномХранилище;
	
	СначалаОрдера = 
		Константы.ПорядокОформленияНакладныхРасходныхОрдеров.Получить() = Перечисления.ПорядокОформленияНакладныхРасходныхОрдеров.СначалаОрдера;
		
	Обработчик = Документы.ПередачаТоваровХранителю.ОбработчикДействий(Параметры.ХозяйственнаяОперация);
	
	ИспользоватьЗаказыКлиентов              = Обработчик.ИспользоватьЗаказыКлиентов();
	ИспользоватьПередачуПоНесколькимЗаказам = Обработчик.ИспользоватьРеализациюПоНесколькимЗаказам();
	
	ПоОрдеру = СначалаОрдера
				И ИспользоватьОрдернуюСхемуПриОтгрузке;
	
	Элементы.ПоОрдеру.Видимость          = ИспользоватьЗаказыКлиентов
											И ИспользоватьОрдернуюСхемуПриОтгрузке;
	Элементы.ЗаказКлиента.Видимость      = ПередачаПоЗаказам
											И ИспользоватьПередачуПоНесколькимЗаказам;
	Элементы.ПередачаПоЗаказу.Видимость  = ПередачаПоЗаказам
											И ИспользоватьПередачуПоНесколькимЗаказам;
	Элементы.ПередачаПоЗаказам.Видимость = ПередачаПоЗаказам
											И ИспользоватьПередачуПоНесколькимЗаказам;
	Элементы.НадписьЗаголовокЗаказыКлиентов.Видимость = ПередачаПоЗаказам
														И ИспользоватьПередачуПоНесколькимЗаказам;
	
	ЗаполнитьТаблицуТоваров(Параметры.Документ, Параметры.ВалютаДокумента);
	УстановитьЗаголовокЗаполнитьПоЗаказамОрдерам();
	ПодборТоваровКлиентСервер.СформироватьЗаголовокФормыПодбора(
		Заголовок, ?(ЗначениеЗаполнено(Параметры.Заголовок), Параметры.Заголовок, Параметры.Документ));
	
	ИменаПараметровУказанияСерий = Документы.ПередачаТоваровХранителю.ИменаРеквизитовДляЗаполненияПараметровУказанияСерий();
	ПараметрыОбъекта = Новый Структура(ИменаПараметровУказанияСерий);
	ЗаполнитьЗначенияСвойств(ПараметрыОбъекта, Параметры);
	
	ПараметрыУказанияСерий = НоменклатураСервер.ПараметрыУказанияСерий(ПараметрыОбъекта,
																		Документы.ПередачаТоваровХранителю);
	Элементы.ТаблицаТоваровСерия.Видимость = ПараметрыУказанияСерий.ИспользоватьСерииНоменклатуры;
	
	ЕстьСобирающиесяТовары = ТаблицаТоваров.Итог("УчетСобирается") > 0;
	
	Элементы.ТаблицаТоваровГруппаВОрдерах.Видимость = ИспользоватьОрдернуюСхемуПриОтгрузке;
	Элементы.ТаблицаТоваровКоличествоСобирается.Видимость = ЕстьСобирающиесяТовары;
	
	Элементы.ДекорацияИнфо.Видимость = ЕстьСобирающиесяТовары;
	Элементы.ДекорацияИнформацияЕстьСобирающиесяТовары.Видимость = ЕстьСобирающиесяТовары;
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)

	Если Не ВыполняетсяЗакрытие
		И Модифицированность
		И Не ЗавершениеРаботы Тогда
		
		Отказ = Истина;
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект);
		ТекстВопроса       = НСтр("ru = 'Данные были изменены. Перенести изменения в документ?';
									|en = 'The data was modified. Migrate the changes to the document?'");
		
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНетОтмена);
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		
		Модифицированность  = Ложь;
		ВыполняетсяЗакрытие = Истина;
		
		ПеренестиТоварыВДокумент();
		
	ИначеЕсли РезультатВопроса = КодВозвратаДиалога.Нет Тогда
		
		Модифицированность  = Ложь;
		ВыполняетсяЗакрытие = Истина;
		
		Закрыть();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПоОрдеруПриИзменении(Элемент)
	
	ПерезаполнитьКоличествоПодобрано();
	
КонецПроцедуры

&НаКлиенте
Процедура ПоЗаказамПриИзменении(Элемент)
	
	ПриИзмененииПоЗаказам();
	
КонецПроцедуры

&НаКлиенте
Процедура НадписьЗаголовокЗаказыКлиентовНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекстЗаголовка = НСтр("ru = 'Заказы клиентов (%КоличествоДокументов%)';
							|en = 'Sales orders (%КоличествоДокументов%)'");
	
	ПараметрыФормы = Новый Структура("СписокДокументов, Заголовок", СписокЗаказов, ТекстЗаголовка);
	
	ОткрытьФорму("ОбщаяФорма.ПросмотрСпискаДокументов", ПараметрыФормы, ЭтаФорма, , , , Неопределено,
		РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТовары

&НаКлиенте
Процедура ТаблицаТоваровВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Элементы.ТаблицаТоваров.ТекущиеДанные <> Неопределено Тогда
		Если Поле.Имя = "ТаблицаТоваровЗаказКлиента" Тогда
			ПоказатьЗначение(Неопределено, Элементы.ТаблицаТоваров.ТекущиеДанные.ЗаказКлиента);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаТоваровКоличествоУпаковокПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.ТаблицаТоваров.ТекущиеДанные;
	
	СтруктураДействий = Новый Структура;
	ДобавитьВСтруктуруДействияПриИзмененииКоличестваУпаковок(СтруктураДействий);
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	
	ТекущаяСтрока.РасхождениеНакладная = ТекущаяСтрока.КоличествоУпаковок - ТекущаяСтрока.КоличествоУпаковокВНакладной;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПеренестиВДокументВыполнить()
	
	ПеренестиТоварыВДокумент();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьТоварыВыполнить()
	
	ВыбратьВсеТоварыНаСервере(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсключитьТоварыВыполнить()
	
	ВыбратьВсеТоварыНаСервере(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	// Установка условного оформления на табличную часть 'Товары'
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТаблицаТоваров.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ТаблицаТоваров.ПрисутствуетВДокументе");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ПоЗаказам");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.Gray);
	
	// Установка условного оформления для элемента 'КоличествоУпаковокВЗаказе' табличной части 'Товары'
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТаблицаТоваровКоличествоУпаковокВЗаказе.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ПоОрдеру");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветФона", ЦветаСтиля.ЦветФонаПолностьюОбеспечен);
	
	// Установка условного оформления для элемента 'КоличествоУпаковокВОрдере' табличной части 'Товары'
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТаблицаТоваровКоличествоУпаковокВОрдере.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ПоОрдеру");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветФона", ЦветаСтиля.ЦветФонаПолностьюОбеспечен);
	
	// Установка условного оформления для элементов Единицы измерения и Упаковки табличной части 'Товары'
	НоменклатураСервер.УстановитьУсловноеОформлениеЕдиницИзмерения(ЭтаФорма, "ТаблицаТоваровНоменклатураЕдиницаИзмерения",
		"ТаблицаТоваров.Упаковка");
	
	// Установка условного оформления для элемента 'ЗаказКлиента' табличной части 'Товары'
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТаблицаТоваровЗаказКлиента.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ТаблицаТоваров.ЗаказКлиента");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ГиперссылкаЦвет);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицуТоваров(Документ, ВалютаДокумента)
	
	ТоварыПередачи = ПолучитьИзВременногоХранилища(АдресТоваровПередачиВоВременномХранилище);
	
	ДанныеОтбора = Новый Структура;
	ДанныеОтбора.Вставить("Ссылка",      Параметры.Документ);
	ДанныеОтбора.Вставить("Дата",        Параметры.Дата);
	ДанныеОтбора.Вставить("Партнер",     Параметры.Партнер);
	ДанныеОтбора.Вставить("Контрагент",  Параметры.Контрагент);
	ДанныеОтбора.Вставить("Соглашение",  Параметры.Соглашение);
	ДанныеОтбора.Вставить("Организация", Параметры.Организация);
	ДанныеОтбора.Вставить("Склад",       Параметры.Склад);
	ДанныеОтбора.Вставить("Договор",     Параметры.Договор);
	ДанныеОтбора.Вставить("Валюта",      Параметры.ВалютаДокумента);
	ДанныеОтбора.Вставить("Сделка",      Параметры.Сделка);
	ДанныеОтбора.Вставить("ХозяйственнаяОперация",     Параметры.ХозяйственнаяОперация);
	ДанныеОтбора.Вставить("НаправлениеДеятельности",   Параметры.НаправлениеДеятельности);
	ДанныеОтбора.Вставить("ВернутьМногооборотнуюТару", Параметры.ВернутьМногооборотнуюТару);
	ДанныеОтбора.Вставить("ТоварыПередачи",            ТоварыПередачи);
	ДанныеОтбора.Вставить("ХозяйственнаяОперация",     Параметры.ХозяйственнаяОперация);
	
	ПараметрыЗаполнения = Новый Структура("ОтображатьСообщение, ПодборПоЗаказамОрдерам", Ложь, Истина);
	
	Документы.ПередачаТоваровХранителю.ЗаполнитьПоОстаткамЗаказов(ДанныеОтбора, ТаблицаТоваров, Параметры.Склад,
		Неопределено, ПараметрыЗаполнения);
	
	ЗаказыСервер.УстановитьПризнакиПрисутствияСтрокиВДокументе(ТаблицаТоваров, "ЗаказКлиента", Параметры.МассивКодовСтрок);
	
	ПерезаполнитьКоличествоПодобрано(Истина, ТоварыПередачи);
	
КонецПроцедуры

&НаСервере
Процедура ПерезаполнитьКоличествоПодобрано(СЗаполнением = Ложь, ТоварыПередачи = Неопределено)
	
	Если СЗаполнением Тогда
		
		ОбновитьИнформациюПоЗаказам(ТоварыПередачи);
		
		ПоЗаказам = ?(СписокЗаказов.Количество() > 0, Истина, ЗначениеЗаполнено(ЗаказКлиента))
					Или НачатаОтгрузка;
		
		УстановитьОтборПоЗаказам();
		
		СтруктураПоиска = Новый Структура("Номенклатура, Характеристика, Серия, ЗаказКлиента, КодСтроки, Склад");
	КонецЕсли;
	
	СтруктураДействий = Новый Структура;
	ДобавитьВСтруктуруДействияПриИзмененииКоличестваУпаковок(СтруктураДействий);
	
	МассивУдаляемыхСтрок = Новый Массив;
	
	Для Каждого ТекСтрока Из ТаблицаТоваров Цикл
		
		КоличествоУпаковок = ТекСтрока.КоличествоУпаковок;
		
		ТекСтрока.Количество         = ?(ПоОрдеру, ТекСтрока.КоличествоВОрдере,         ТекСтрока.КоличествоВЗаказе);
		ТекСтрока.КоличествоУпаковок = ?(ПоОрдеру, ТекСтрока.КоличествоУпаковокВОрдере, ТекСтрока.КоличествоУпаковокВЗаказе);
		
		Если ТекСтрока.КоличествоУпаковок <> КоличествоУпаковок Тогда
			ОбработкаТабличнойЧастиСервер.ОбработатьСтрокуТЧ(ТекСтрока, СтруктураДействий, Неопределено);
		КонецЕсли;
		
		Если СЗаполнением Тогда
			
			ЗаполнитьЗначенияСвойств(СтруктураПоиска, ТекСтрока);
			Строки = ТоварыПередачи.НайтиСтроки(СтруктураПоиска);
			
			Если Строки.Количество() > 0 Тогда
				
				СтрокаПередачи = Строки.Получить(0);
				ЗаполнитьЗначенияСвойств(ТекСтрока, СтрокаПередачи, ,"ВидЦены, Цена, Количество, КоличествоУпаковок");
				
				Если ТекСтрока.КоличествоУпаковок <> СтрокаПередачи.КоличествоУпаковок Тогда
					ОбработкаТабличнойЧастиСервер.ОбработатьСтрокуТЧ(ТекСтрока, СтруктураДействий, Неопределено);
				КонецЕсли;
				
				ТекСтрока.ПрисутствуетВДокументе = Истина;
				
				ТекСтрока.КоличествоВНакладной         = СтрокаПередачи.Количество;
				ТекСтрока.КоличествоУпаковокВНакладной = СтрокаПередачи.КоличествоУпаковок;
				
				ТоварыПередачи.Удалить(СтрокаПередачи);
				
			КонецЕсли;
			
		КонецЕсли;
		
		Если СписокЗаказов.НайтиПоЗначению(ТекСтрока.ЗаказКлиента) <> Неопределено
			Или ТекСтрока.ЗаказКлиента = ЗаказКлиента
			Или Не ЗначениеЗаполнено(ТекСтрока.ЗаказКлиента) Тогда
			
			ТекСтрока.ЗаказИзНакладной = Истина;
			
		КонецЕсли;
		
		ТекСтрока.РасхождениеНакладная = ТекСтрока.КоличествоУпаковок - ТекСтрока.КоличествоУпаковокВНакладной;
		
		Если ТекСтрока.РасхождениеНакладная <> 0
			И ((ТекСтрока.ЗаказИзНакладной
					И ПоЗаказам)
				Или Не ПоЗаказам) Тогда
			
			ТекСтрока.СтрокаВыбрана = Истина;
			
		Иначе
			ТекСтрока.СтрокаВыбрана = Ложь;
		КонецЕсли;
		
		Если СЗаполнением Тогда
			
			Если (ТекСтрока.КоличествоУпаковокВНакладной = ТекСтрока.КоличествоУпаковокВЗаказе
					Или Не ЗначениеЗаполнено(ТекСтрока.ЗаказКлиента))
				И (ТекСтрока.КоличествоУпаковокВНакладной = ТекСтрока.КоличествоУпаковокВОрдере
					Или Не ТекСтрока.ОрдернаяСхемаПриОтгрузке) Тогда
				
				МассивУдаляемыхСтрок.Добавить(ТаблицаТоваров.Индекс(ТекСтрока));
				
			КонецЕсли;
			
		КонецЕсли;
		
		ТекСтрока.УчетСобирается = Число(Не ЗначениеЗаполнено(ТекСтрока.ЗаказКлиента)
											И ТекСтрока.КоличествоСобирается > 0);
		
	КонецЦикла;
	
	ИндексЭлементаМассива = МассивУдаляемыхСтрок.Количество() - 1;
	
	Пока ИндексЭлементаМассива >= 0 Цикл
		ТаблицаТоваров.Удалить(МассивУдаляемыхСтрок[ИндексЭлементаМассива]);
		
		ИндексЭлементаМассива = ИндексЭлементаМассива - 1;
	КонецЦикла;
	
	Если СЗаполнением Тогда
		
		Для Каждого ТекСтрока Из ТоварыПередачи Цикл
			
			СтрокаТовары = ТаблицаТоваров.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаТовары, ТекСтрока, ,"Количество, КоличествоУпаковок");
			
			СтрокаТовары.СтрокаВыбрана          = Истина;
			СтрокаТовары.ЗаказИзНакладной       = Истина;
			СтрокаТовары.ПрисутствуетВДокументе = Истина;
			
			СтрокаТовары.КоличествоВНакладной         = ТекСтрока.Количество;
			СтрокаТовары.КоличествоУпаковокВНакладной = ТекСтрока.КоличествоУпаковок;
			
			СтрокаТовары.РасхождениеНакладная = -СтрокаТовары.КоличествоУпаковокВНакладной;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьИнформациюПоЗаказам(ТоварыПередачи)
	
	ПараметрыОбновления = ЗаказыСервер.ПараметрыОбновленияИнформацииПоЗаказамВФорме();
	
	ПараметрыОбновления.ИмяРеквизитаСписокЗаказов         = "СписокЗаказов";
	ПараметрыОбновления.ПутьЗаказаВШапке                  = "ЗаказКлиента";
	ПараметрыОбновления.ИмяНадписиЗаголовка               = "НадписьЗаголовокЗаказы";
	ПараметрыОбновления.ИмяЗаказаВТабличнойЧасти          = "ЗаказКлиента";
	ПараметрыОбновления.ИспользоватьЗаказыВТабличнойЧасти = ИспользоватьПередачуПоНесколькимЗаказам;
	
	ЗаказыСервер.ОбновитьИнформациюПоЗаказамВФорме(ЭтаФорма, ТоварыПередачи, ПараметрыОбновления);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборПоЗаказам()
	
	Если ПоЗаказам Тогда
		Элементы.ТаблицаТоваров.ОтборСтрок = Новый ФиксированнаяСтруктура("ЗаказИзНакладной", Истина);
	Иначе
		Элементы.ТаблицаТоваров.ОтборСтрок = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ДобавитьВСтруктуруДействияПриИзмененииКоличестваУпаковок(СтруктураДействий)
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПересчитатьКоличествоЕдиниц");
	СтруктураДействий.Вставить("ПересчитатьСумму");
	
КонецПроцедуры

&НаСервере
Процедура УстановитьЗаголовокЗаполнитьПоЗаказамОрдерам()
	
	Если Не ИспользоватьОрдернуюСхемуПриОтгрузке
		И ИспользоватьЗаказыКлиентов Тогда
		
		ЗаголовокЗаполнить = НСтр("ru = 'Подбор товаров по заказам';
									|en = 'Pick goods by orders'");
		
	ИначеЕсли ИспользоватьОрдернуюСхемуПриОтгрузке
		И Не ИспользоватьЗаказыКлиентов Тогда
		
		ЗаголовокЗаполнить = НСтр("ru = 'Подбор товаров по ордерам';
									|en = 'Pick goods by notes'");
		
	Иначе
		ЗаголовокЗаполнить = НСтр("ru = 'Подбор товаров по заказам/ордерам';
									|en = 'Pick by Order/Goods issue'");
	КонецЕсли;
	
	Заголовок = ЗаголовокЗаполнить;
	
КонецПроцедуры

&НаКлиенте
Процедура ПеренестиТоварыВДокумент()
	
	Отказ = Ложь;
	
	// Снятие модифицированности, т.к. перед закрытием признак проверяется.
	Модифицированность = Ложь;
	
	Если Не ИспользоватьПередачуПоНесколькимЗаказам Тогда
		Отказ = ПроверитьВыборНесколькихЗаказов();
	КонецЕсли;
	
	Если Отказ Тогда
		ПоказатьПредупреждение(,НСтр("ru = 'Нельзя выбрать товары больше, чем по одному заказу.';
									|en = 'You cannot select more goods than against one order.'"));
		
		Возврат;
	КонецЕсли;
	
	РезультатПодбора = Новый Структура("АдресТоваровВХранилище", ПоместитьТоварыВХранилище());
	
	Закрыть();
	
	ОповеститьОВыборе(РезультатПодбора);
	
КонецПроцедуры

&НаСервере
Функция ПроверитьВыборНесколькихЗаказов()
	
	ПервыйЗаказКлиента = Неопределено;
	
	ОтборСтрок      = Новый Структура("СтрокаВыбрана", Истина);
	ВыбранныеСтроки = ТаблицаТоваров.НайтиСтроки(ОтборСтрок);
	
	Для Каждого ТекСтрока Из ВыбранныеСтроки Цикл
		
		Если ТекСтрока.СтрокаВыбрана Тогда
			
			Если ЗначениеЗаполнено(ПервыйЗаказКлиента)
				И ЗначениеЗаполнено(ТекСтрока.ЗаказКлиента)
				И ПервыйЗаказКлиента <> ТекСтрока.ЗаказКлиента Тогда
				
				Возврат Истина;
				
			КонецЕсли;
			
			ПервыйЗаказКлиента = ТекСтрока.ЗаказКлиента;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Ложь;
	
КонецФункции

&НаСервере
Функция ПоместитьТоварыВХранилище()
	
	// Формирование таблицы для возврата в документ.
	ОтборСтрок = Новый Структура("СтрокаВыбрана", Истина);
	ТаблицаВыбранныхТоваров = ТаблицаТоваров.Выгрузить(ОтборСтрок);
	
	АдресТоваровВХранилище = ПоместитьВоВременноеХранилище(ТаблицаВыбранныхТоваров);
	
	Возврат АдресТоваровВХранилище;
	
КонецФункции

&НаСервере
Процедура ПриИзмененииПоЗаказам()
	
	УстановитьОтборПоЗаказам();
	
	Если ПоЗаказам Тогда
		СброситьВыборСтрокНеИзНакладной();
	Иначе
		УстановитьВыборСтрокНеИзНакладной();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СброситьВыборСтрокНеИзНакладной()
	
	СтруктураПоиска = Новый Структура("СтрокаВыбрана", Истина);
	ТоварыПодобрано = ТаблицаТоваров.НайтиСтроки(СтруктураПоиска);
	
	Для Каждого СтрокаПодобрано Из ТоварыПодобрано Цикл
		СтрокаПодобрано.СтрокаВыбрана = СтрокаПодобрано.ЗаказИзНакладной;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВыборСтрокНеИзНакладной()
	
	СтруктураПоиска = Новый Структура("СтрокаВыбрана", Ложь);
	ТоварыПодобрано = ТаблицаТоваров.НайтиСтроки(СтруктураПоиска);
	
	Для Каждого СтрокаПодобрано Из ТоварыПодобрано Цикл
		Если СтрокаПодобрано.РасхождениеНакладная <> 0 Тогда
			СтрокаПодобрано.СтрокаВыбрана = Истина;
		Иначе
			СтрокаПодобрано.СтрокаВыбрана = Ложь;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ВыбратьВсеТоварыНаСервере(ЗначениеВыбора = Истина)
	
	ОтборСтрок    = Новый Структура("СтрокаВыбрана", Не ЗначениеВыбора);
	СтрокиТоваров = ТаблицаТоваров.НайтиСтроки(ОтборСтрок);
	
	Для Каждого СтрокаТаблицы Из СтрокиТоваров Цикл
		
		Если ПоЗаказам
			И Не СтрокаТаблицы.ЗаказИзНакладной Тогда
			
			СтрокаТаблицы.СтрокаВыбрана = Ложь;
			
		Иначе
			СтрокаТаблицы.СтрокаВыбрана = ЗначениеВыбора;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область Инициализация

ВыполняетсяЗакрытие = Ложь;

#КонецОбласти