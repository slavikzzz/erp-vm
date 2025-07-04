
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СвойстваСписка = ОбщегоНазначения.СтруктураСвойствДинамическогоСписка();
	СвойстваСписка.ОсновнаяТаблица = "РегистрСведений.НДССостояниеРеализации0.СрезПоследних";
	СвойстваСписка.ДинамическоеСчитываниеДанных = Истина;
	СвойстваСписка.ТекстЗапроса = ПолучитьТекстЗапросаСписок();
	ОбщегоНазначения.УстановитьСвойстваДинамическогоСписка(Элементы.Список, СвойстваСписка);
	
	УстановитьУсловноеОформление();
	УстановитьЗначенияПоУмолчанию();
	ОбновитьДанныеФормы();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПолеСсылка =  Список.КомпоновщикНастроек.Настройки.Выбор.ДоступныеПоляВыбора.НайтиПоле(Новый ПолеКомпоновкиДанных("Ссылка"));
	Если ПолеСсылка <> Неопределено Тогда
		СписокТипов = ПолеСсылка.Тип;
		ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
		ПараметрыРазмещения.Источники = СписокТипов;
		ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_СчетФактураНаНеподтвержденнуюРеализацию0" Тогда
		Элементы.Список.Обновить();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НачалоПериодаПриИзменении(Элемент)
	
	НачалоПериода = НачалоКвартала(НачалоПериода);
	КонецПериода = КонецКвартала(НачалоПериода);

	ОбновитьДанныеФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура КонецПериодаПриИзменении(Элемент)

	КонецПериода = КонецКвартала(КонецПериода);
	НачалоПериода = НачалоКвартала(КонецПериода);
	
	ОбновитьДанныеФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура СостояниеОтборПриИзменении(Элемент)
	
	ОбновитьДанныеФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентОтборПриИзменении(Элемент)
	
	ОбновитьДанныеФормы();
	
КонецПроцедуры
 
&НаКлиенте
Процедура ОрганизацияОтборПриИзменении(Элемент)

	ОбновитьДанныеФормы();

КонецПроцедуры

&НаКлиенте
Процедура КонецПериодаОчистка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если Поле.Имя = "СписокДокументРеализации" Тогда
		ОткрытьТекущийДокументРеализации();
	ИначеЕсли Поле.Имя = "СписокСчетФактураНаНеподтвержденнуюРеализацию0" Тогда
		ОткрытьТекущийСчетФактуруНаНеподтвержденнуюСтавку0();
	ИначеЕсли Поле.Имя = "ТаможеннаяДекларация" Тогда
		ОткрытьТекущийТаможеннаяДекларацияЭкспорт();
	Иначе
		ОткрытьТекущуюФормуЗаписи();
	КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура СписокОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ВыбранноеЗначение <> Неопределено Тогда 
		ЗаполнитьИзФормыРучногоВвода(ВыбранноеЗначение)
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийКомандФормы

&НаКлиенте
Процедура ВыбратьПериод(Команда)
	
	ПараметрыВыбора = Новый Структура("НачалоПериода,КонецПериода", НачалоПериода, КонецПериода);
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыбратьПериодЗавершение", ЭтотОбъект);
	ОткрытьФорму("ОбщаяФорма.ВыборСтандартногоПериода", ПараметрыВыбора, Элементы.ВыбратьПериод, , , , ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодтвержденаСтавкаНДС(Команда)
	
	ТекущееСостояние = ПредопределенноеЗначение("Перечисление.НДССостоянияРеализация0.ПодтвержденаРеализация0");
	ПодтверждениеСтавкиНДС(ТекущееСостояние);
	
КонецПроцедуры

&НаКлиенте
Процедура НеподтвержденаСтавкаНДС(Команда)
	
	ТекущееСостояние = ПредопределенноеЗначение("Перечисление.НДССостоянияРеализация0.НеПодтвержденаРеализация0");
	ПодтверждениеСтавкиНДС(ТекущееСостояние);
	
КонецПроцедуры

&НаКлиенте
Процедура ОжидаетсяПодтверждение(Команда)
	
	ТекущееСостояние = ПредопределенноеЗначение("Перечисление.НДССостоянияРеализация0.ОжидаетсяПодтверждение");
	ПодтверждениеСтавкиНДС(ТекущееСостояние);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуЗаписи(Команда)
	
	ОткрытьТекущуюФормуЗаписи();
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьДокументРеализации(Команда)
	
	ОткрытьТекущийДокументРеализации();
	
КонецПроцедуры

&НаКлиенте
Процедура СборВедется(Команда)
	
//++ НЕ УТ
	УстановитьСостояниеСбораДокументов(Ложь);
//-- НЕ УТ
	Возврат;// в УТ11 обработчик пустой
	
КонецПроцедуры

&НаКлиенте
Процедура СборЗавершен(Команда)
	
//++ НЕ УТ
	УстановитьСостояниеСбораДокументов(Истина);
//-- НЕ УТ
	Возврат;// в УТ11 обработчик пустой
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ПриИзмененииРеквизитов

&НаСервере
Процедура ОбновитьДанныеФормы()
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "КонецПериода", КонецПериода);
		
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список,"Состояние",
		Состояние, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(Состояние));
		
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Организация",
		Организация, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(Организация));
		
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Контрагент",
		Контрагент, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(Контрагент));
		
	//++ НЕ УТ
	Элементы.ГруппаСборДокументов.Видимость = Истина;
	//-- НЕ УТ
КонецПроцедуры

#КонецОбласти

#Область ПриРегистрацииПодтверждения

&НаКлиенте
Процедура ПодтверждениеСтавкиНДС(ТекущееСостояние)
	
	ОчиститьСообщения();
	
	СписокДокументов = Элементы.Список.ВыделенныеСтроки;
	
	Если СписокДокументов = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого Строка Из СписокДокументов Цикл
		
		ДанныеСтроки = Элементы.Список.ДанныеСтроки(Строка);
		Если ДанныеСтроки.Состояние = ПредопределенноеЗначение("Перечисление.НДССостоянияРеализация0.ПодтверждениеНеТребуется") Тогда
			ТекстСообщений = СтрШаблон(
				               НСтр("ru = 'На основании ""%1"" введен документ ""Сторно"". Изменение состояния недостунно.';
									|en = 'The Storno document was entered based on ""%1"". Cannot change status.'"),
				               ДанныеСтроки.ДокументРеализации);
			ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщений);
			Продолжить;
		КонецЕсли;
		
		ПараметрыПодтверждения = ПараметрыПодтвержденияСтавкиНДС();
		ПараметрыПодтверждения.ТекущееСостояние = ТекущееСостояние;
		ЗаполнитьЗначенияСвойств(ПараметрыПодтверждения, ДанныеСтроки);
		
		ПодтверждениеСтавкиНДССервер(ПараметрыПодтверждения);
		
	КонецЦикла;
	
	Элементы.Список.Обновить();
	
КонецПроцедуры	

&НаСервере
Процедура ПодтверждениеСтавкиНДССервер(ПараметрыПодтверждения)
	
	УстановитьПривилегированныйрежим(Истина);
	
	Регистратор           = ПараметрыПодтверждения.Регистратор;
	ДокументРеализации    = ПараметрыПодтверждения.ДокументРеализации;
	ТекущееСостояние      = ПараметрыПодтверждения.ТекущееСостояние;
	СтавкаНДС             = ПараметрыПодтверждения.СтавкаНДС;
	Комментарий           = ПараметрыПодтверждения.Комментарий;
	ОрганизацияРеализации = ПараметрыПодтверждения.Организация;
	КонтрагентРеализации  = ПараметрыПодтверждения.Контрагент;
	СчетФактура           = ПараметрыПодтверждения.СчетФактураНаНеподтвержденнуюРеализацию0;
	
	НаборЗаписей = РегистрыСведений.НДССостояниеРеализации0.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Регистратор.Значение = Регистратор;
	НаборЗаписей.Прочитать();
	
	Если ТекущееСостояние = Перечисления.НДССостоянияРеализация0.ПодтвержденаРеализация0 Тогда
		СтавкаНДС = Справочники.СтавкиНДС.ПустаяСсылка();
		ДатаПодтверждения = КонецДня(КонецПериода);
	ИначеЕсли ТекущееСостояние = Перечисления.НДССостоянияРеализация0.НеПодтвержденаРеализация0 Тогда
		СтавкаНДС = ?(СтавкаНДС = Неопределено, УчетНДСУП.СтавкаНДСПоУмолчанию(ОрганизацияРеализации, НачалоПериода), СтавкаНДС);
		ДатаПодтверждения = КонецДня(КонецПериода);;
	Иначе
		СтавкаНДС = Справочники.СтавкиНДС.ПустаяСсылка();
		ДатаПодтверждения = '00010101000000';
	КонецЕсли;
	
	ПерезаписатьДокумент = Ложь;
	ФормироватьПроводки = Ложь;
	
	Для Каждого СтрокаНабора Из НаборЗаписей Цикл
		
		Если СтрокаНабора.Организация <> ОрганизацияРеализации
			ИЛИ СтрокаНабора.ДокументРеализации <> ДокументРеализации
			ИЛИ СтрокаНабора.Контрагент <> КонтрагентРеализации Тогда
			Продолжить;
		КонецЕсли;
			
		Если СтрокаНабора.Состояние <> ТекущееСостояние Тогда
			Если СтрокаНабора.Состояние = Перечисления.НДССостоянияРеализация0.НеПодтвержденаРеализация0 
				Или ТекущееСостояние = Перечисления.НДССостоянияРеализация0.НеПодтвержденаРеализация0 Тогда
				ФормироватьПроводки = Истина;
			КонецЕсли;
			СтрокаНабора.Состояние = ТекущееСостояние;
			ПерезаписатьДокумент = Истина;
		КонецЕсли;
		
		Если СтрокаНабора.ДатаПодтверждения <> ДатаПодтверждения Тогда
			СтрокаНабора.ДатаПодтверждения = ДатаПодтверждения;
			ПерезаписатьДокумент = Истина;
		КонецЕсли;
		
		Если СтрокаНабора.СтавкаНДС <> СтавкаНДС Тогда
			СтрокаНабора.СтавкаНДС = СтавкаНДС;
			ПерезаписатьДокумент = Истина;
		КонецЕсли;
		
		Если СтрокаНабора.Комментарий <> Комментарий Тогда
			СтрокаНабора.Комментарий = Комментарий;
		КонецЕсли;
		
	КонецЦикла;
	
	Если ПерезаписатьДокумент И ТипЗнч(ДокументРеализации) = Тип("ДокументСсылка.ПервичныйДокумент") Тогда
		ПерезаписатьДокумент = Ложь;
	КонецЕсли;
	
	НачатьТранзакцию();
	
	Попытка
		НаборЗаписей.Записать();
		Если ТекущееСостояние = Перечисления.НДССостоянияРеализация0.НеПодтвержденаРеализация0 Тогда
			ВыписатьСчетФактуруНаНеподтвержденныеСтавки(СчетФактура, ДокументРеализации, ОрганизацияРеализации, ДатаПодтверждения); 
		КонецЕсли;
		Если ПерезаписатьДокумент Тогда
			ДокументыРеализацииСКорректировками = Документы.СчетФактураВыданный.КорректировкиДокументаОснования(ДокументРеализации, ДатаПодтверждения);
			Для Каждого ДокументРеализацииКорректировки Из ДокументыРеализацииСКорректировками Цикл
				РегистрыСведений.НДССостояниеРеализации0.ОтразитьДокументПоПодтверждениюСтавки0(
					ДокументРеализацииКорректировки,
					ДатаПодтверждения,
					ОрганизацияРеализации,
					ФормироватьПроводки);
			КонецЦикла;
		КонецЕсли;
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
	
КонецПроцедуры	

#КонецОбласти

//++ НЕ УТ
#Область ИзменениеСостоянияСбораПодтверждающихДокументов

&НаКлиенте
Процедура УстановитьСостояниеСбораДокументов(НовоеСостояние)
	
	ОчиститьСообщения();
	
	СписокДокументов = Элементы.Список.ВыделенныеСтроки;
	
	Если СписокДокументов = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого Строка Из СписокДокументов Цикл
		
		ДанныеСтроки = Элементы.Список.ДанныеСтроки(Строка);
		Если ЗначениеЗаполнено(ДанныеСтроки.ТаможеннаяДекларация) Тогда
			УстановитьСостояниеСбораДокументовСервер(ДанныеСтроки.ТаможеннаяДекларация, НовоеСостояние);
		КонецЕсли;
		
	КонецЦикла;
	
	Элементы.Список.Обновить();
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура УстановитьСостояниеСбораДокументовСервер(ТаможеннаяДекларация, НовоеСостояние)
	
	Документы.ТаможеннаяДекларацияЭкспорт.УстановитьСостояниеСбораСопроводительныхДокументов(
		ТаможеннаяДекларация,
		НовоеСостояние);
	
КонецПроцедуры
#КонецОбласти
//-- НЕ УТ

#Область Прочее

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СписокСтавкаНДС.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.Состояние");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.НДССостоянияРеализация0.ПодтвержденаРеализация0;
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.СтавкаНДС");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Справочники.СтавкиНДС.ПустаяСсылка();
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '0%';
																|en = '0%'"));
	
	//
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СписокСчетФактураНаНеподтвержденнуюРеализацию0.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.СчетФактураНаНеподтвержденнуюРеализацию0");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	
	ОтборГруппаИЛИ = Элемент.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ОтборГруппаИЛИ.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;
	
	ОтборЭлемента = ОтборГруппаИЛИ.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.Состояние");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеРавно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.НДССостоянияРеализация0.НеПодтвержденаРеализация0;
	
	ОтборЭлемента = ОтборГруппаИЛИ.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.ДатаПодтверждения");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Меньше;
	ОтборЭлемента.ПравоеЗначение = Дата(2014, 10, 01);
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<не требуется>';
																|en = '<not required>'"));
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.НезаполненноеПолеТаблицы);
	
	//
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СписокСчетФактураНаНеподтвержденнуюРеализацию0.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.СчетФактураНаНеподтвержденнуюРеализацию0");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.Состояние");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.НДССостоянияРеализация0.НеПодтвержденаРеализация0;
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.ДатаПодтверждения");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.БольшеИлиРавно;
	ОтборЭлемента.ПравоеЗначение = Дата(2014, 10, 01);
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<требуется выписать>';
																|en = '<it is required to issue>'"));
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ПросроченныеДанныеЦвет);
	
	//

КонецПроцедуры

&НаСервере
Процедура УстановитьЗначенияПоУмолчанию()
	
	Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	НачалоПериода = НачалоКвартала(ТекущаяДатаСеанса());
	КонецПериода = КонецКвартала(ТекущаяДатаСеанса());
	
КонецПроцедуры

	

&НаКлиенте
Процедура ВыбратьПериодЗавершение(РезультатВыбора, ДопПараметры) Экспорт
	
	Если РезультатВыбора = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ЗаполнитьЗначенияСвойств(ЭтаФорма, РезультатВыбора, "НачалоПериода,КонецПериода");
	НачалоПериода = НачалоКвартала(НачалоПериода);
	КонецПериода = КонецКвартала(НачалоПериода);
	
	ОбновитьДанныеФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьИзФормыРучногоВвода(ВыбранноеЗначение)
	
	ТекущаяСтрока = Элементы.Список.ТекущиеДанные;	
	
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат
	КонецЕсли;
	
	ПараметрыПодтверждения = ПараметрыПодтвержденияСтавкиНДС();
	ПараметрыПодтверждения.ТекущееСостояние   = ВыбранноеЗначение.Состояние;
	ПараметрыПодтверждения.ДокументРеализации = ТекущаяСтрока.ДокументРеализации;
	ПараметрыПодтверждения.Регистратор        = ТекущаяСтрока.Регистратор;
	ПараметрыПодтверждения.СтавкаНДС          = ВыбранноеЗначение.СтавкаНДС;
	ПараметрыПодтверждения.Комментарий        = ВыбранноеЗначение.Комментарий;
	ПараметрыПодтверждения.Организация        = ТекущаяСтрока.Организация;
	ПараметрыПодтверждения.Контрагент         = ТекущаяСтрока.Контрагент;
	ПараметрыПодтверждения.СчетФактураНаНеподтвержденнуюРеализацию0 = ТекущаяСтрока.СчетФактураНаНеподтвержденнуюРеализацию0;
	
	ПодтверждениеСтавкиНДССервер(ПараметрыПодтверждения);
	
	Элементы.Список.Обновить();
	
КонецПроцедуры	

&НаКлиенте
Процедура ОткрытьТекущуюФормуЗаписи()
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат
	КонецЕсли;	
	
	ПараметрыПодбора = Новый Структура();
	ПараметрыПодбора.Вставить("Документ",			ТекущиеДанные.ДокументРеализации);
	ПараметрыПодбора.Вставить("Организация",		ТекущиеДанные.Организация);
	ПараметрыПодбора.Вставить("Состояние",			ТекущиеДанные.Состояние);
	ПараметрыПодбора.Вставить("ДатаПодтверждения",	ТекущиеДанные.ДатаПодтверждения);
	ПараметрыПодбора.Вставить("ТекущийПериод",		КонецДня(КонецПериода));
	ПараметрыПодбора.Вставить("СтавкаНДС",			ТекущиеДанные.СтавкаНДС);
	ПараметрыПодбора.Вставить("Комментарий",		ТекущиеДанные.Комментарий);
	
	ОткрытьФорму("РегистрСведений.НДССостояниеРеализации0.Форма.ФормаРучногоВвода", ПараметрыПодбора, Элементы.Список);
	
КонецПроцедуры	

&НаКлиенте
Процедура ОткрытьТекущийДокументРеализации()
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат
	КонецЕсли;
	
	ПоказатьЗначение(Неопределено, ТекущиеДанные.ДокументРеализации);
	
КонецПроцедуры	


// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура ОткрытьТекущийСчетФактуруНаНеподтвержденнуюСтавку0()
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат
	КонецЕсли;
	
	ПоказатьЗначение(Неопределено, ТекущиеДанные.СчетФактураНаНеподтвержденнуюРеализацию0);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьТекущийТаможеннаяДекларацияЭкспорт()
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат
	КонецЕсли;
	
	ПоказатьЗначение(Неопределено, ТекущиеДанные.ТаможеннаяДекларация);
	
КонецПроцедуры

&НаСервере
Процедура ВыписатьСчетФактуруНаНеподтвержденныеСтавки(СчетФактура, ДокументОснование, Организация, Дата)
	
	ДанныеЗаполнения = Новый Структура;
	ДанныеЗаполнения.Вставить("ДокументОснование", ДокументОснование);
	ДанныеЗаполнения.Вставить("Организация",       Организация);
	Если Дата >= Дата(2024, 1, 1) Тогда
		ДанныеЗаполнения.Вставить("Дата", Дата);
	Иначе
		ДанныеЗаполнения.Вставить("Дата", Мин(Дата, ТекущаяДатаСеанса()));
	КонецЕсли;
	
	Если ЗначениеЗаполнено(СчетФактура) Тогда
		СчетФактураВыданный = СчетФактура.ПолучитьОбъект();
	Иначе
		СчетФактураВыданный = Документы.СчетФактураНаНеподтвержденнуюРеализацию0.СоздатьДокумент();
	КонецЕсли;
	СчетФактураВыданный.Заполнить(ДанныеЗаполнения);
	СчетФактураВыданный.Записать(РежимЗаписиДокумента.Проведение);
	
КонецПроцедуры 

&НаКлиентеНаСервереБезКонтекста
Функция ПараметрыПодтвержденияСтавкиНДС()
	
	ПараметрыПодтверждения = Новый Структура;
	ПараметрыПодтверждения.Вставить("Регистратор");
	ПараметрыПодтверждения.Вставить("Период");
	ПараметрыПодтверждения.Вставить("ТекущееСостояние");
	ПараметрыПодтверждения.Вставить("ДокументРеализации");
	ПараметрыПодтверждения.Вставить("Организация");
	ПараметрыПодтверждения.Вставить("Контрагент");
	ПараметрыПодтверждения.Вставить("СтавкаНДС");
	ПараметрыПодтверждения.Вставить("Комментарий");
	ПараметрыПодтверждения.Вставить("СчетФактураНаНеподтвержденнуюРеализацию0");
	
	Возврат ПараметрыПодтверждения;
	
КонецФункции

&НаСервере
Функция ПолучитьТекстЗапросаСписок()
	
	Возврат 
	"ВЫБРАТЬ
	|	НДССостояниеРеализации0.Регистратор,
	|	НДССостояниеРеализации0.Период,
	|	НДССостояниеРеализации0.НомерСтроки,
	|	НДССостояниеРеализации0.Активность,
	|	НДССостояниеРеализации0.Организация,
	|	НДССостояниеРеализации0.ДокументРеализации,
	|	НДССостояниеРеализации0.ДатаРеализации,
	|	НДССостояниеРеализации0.Контрагент,
	//++ НЕ УТ
	|	ТаможеннаяДекларацияОснования.Ссылка КАК ТаможеннаяДекларация,
	|	ТаможеннаяДекларацияДокумент.СборСопроводительныхДокументовЗавершен КАК СопроводительныеДокументы,
	//-- НЕ УТ
	|	НДССостояниеРеализации0.Состояние,
	|	НДССостояниеРеализации0.СтавкаНДС,
	|	НДССостояниеРеализации0.ДатаПодтверждения,
	|	НДССостояниеРеализации0.Комментарий,
	|	СчетФактураВыданный.Ссылка КАК СчетФактураНаНеподтвержденнуюРеализацию0,
	|	СчетФактураВыданный.Ссылка КАК Ссылка
	|ИЗ
	|	РегистрСведений.НДССостояниеРеализации0.СрезПоследних(&КонецПериода) КАК НДССостояниеРеализации0
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.СчетФактураНаНеподтвержденнуюРеализацию0 КАК СчетФактураВыданный
	|		ПО НДССостояниеРеализации0.ДокументРеализации = СчетФактураВыданный.ДокументОснование
	|			И (НЕ СчетФактураВыданный.ПометкаУдаления)
	//++ НЕ УТ
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ТаможеннаяДекларацияЭкспорт.ДокументыОснования КАК ТаможеннаяДекларацияОснования
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ТаможеннаяДекларацияЭкспорт КАК ТаможеннаяДекларацияДокумент
	|			ПО ТаможеннаяДекларацияОснования.Ссылка = ТаможеннаяДекларацияДокумент.Ссылка
	|				И (ТаможеннаяДекларацияДокумент.Проведен)
	|		ПО (ТаможеннаяДекларацияОснования.ДокументОснование = НДССостояниеРеализации0.ДокументРеализации)
	//-- НЕ УТ
	|";
	
КонецФункции

#КонецОбласти

#КонецОбласти
