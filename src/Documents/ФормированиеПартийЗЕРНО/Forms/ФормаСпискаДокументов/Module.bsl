#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ОбработатьИПроверитьПереданныеПараметры();
	
	УстановитьБыстрыйОтборСервер();
	
	Настройки = ИнтеграцияИС.НастройкиФормыСпискаДокументов();
	Настройки.ТипыКОформлению = Метаданные.ОпределяемыеТипы.ДокументыЗЕРНОПоддерживающиеСтатусыОформления;
	Настройки.ТипыКОбмену     = Метаданные.ОпределяемыеТипы.ДокументыЗЕРНО;
	Настройки.КОформлению = "СписокКОформлению,СписокКОформлениюГосмониторинг"; 
	СобытияФормЗЕРНО.ПриСозданииНаСервереФормыСпискаДокументов(ЭтотОбъект, Настройки);
	
	ИнтеграцияЗЕРНО.ЗаполнитьСписокВыбораДальнейшееДействие(
		Элементы.СтраницаОформленоОтборДальнейшееДействие.СписокВыбора, ВсеТребующиеДействия(), ВсеТребующиеОжидания());
	
	НастроитьВидимостьДоступностьЭлементовСервер();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	ОбщегоНазначенияСобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
	ОбщегоНазначенияИС.УстановитьПризнакПравоИзмененияФормыСписка(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = СобытияФормЗЕРНОКлиент.ИмяСобытияИзмененаНастройкаАвтоматическогоОбмена() Тогда
		НастроитьДоступностьКомандыВыполнитьОбмен();
	КонецЕсли;
	
	ОбменДаннымиИСКлиент.ОбработкаОповещенияВФормеСпискаДокументовИС(
		ЭтотОбъект,
		ИнтеграцияЗЕРНОКлиентСервер.ИмяПодсистемы(),
		ИмяСобытия,
		Параметр,
		Источник);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СтраницаОформленоОтборСтатусПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, "Статус", Статус, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(Статус));
	
КонецПроцедуры

&НаКлиенте
Процедура СтраницаОформленоОтборДальнейшееДействиеПриИзменении(Элемент)
	
	УстановитьОтборПоДальнейшемуДействиюСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура СтраницаОформленоОтборОтветственныйПриИзменении(Элемент)
	
	ОтветственныйОтборПриИзменении();
	
КонецПроцедуры

&НаКлиенте
Процедура ОформленоОрганизацииНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ВыборОрганизацииЗавершение = Новый ОписаниеОповещения("ВыборОрганизацииЗавершение", ЭтотОбъект);
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияЗЕРНОКлиент.ОткрытьФормуВыбораОрганизаций(ЭтотОбъект, "Оформлено",, ВыборОрганизацииЗавершение);
	
КонецПроцедуры

&НаКлиенте
Процедура ОформленоОрганизацииПриИзменении(Элемент)
	
	ИнтеграцияЗЕРНОКлиент.ОбработатьВыборОрганизаций(ЭтотОбъект, Организации, Истина, "Оформлено");
	НастроитьДоступностьКомандыВыполнитьОбмен();
	
КонецПроцедуры

&НаКлиенте
Процедура ОформленоОрганизацииОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияЗЕРНОКлиент.ОбработатьВыборОрганизаций(ЭтотОбъект, Неопределено, Истина, "Оформлено");
	НастроитьДоступностьКомандыВыполнитьОбмен();
	
КонецПроцедуры

&НаКлиенте
Процедура ОформленоОрганизацииОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ИнтеграцияЗЕРНОКлиент.ОбработатьВыборОрганизаций(ЭтотОбъект, ВыбранноеЗначение, Истина, "Оформлено");
	НастроитьДоступностьКомандыВыполнитьОбмен();
	
КонецПроцедуры

&НаКлиенте
Процедура ОформленоОрганизацияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ВыборОрганизацииЗавершение = Новый ОписаниеОповещения("ВыборОрганизацииЗавершение", ЭтотОбъект);
	СтандартнаяОбработка = Ложь;
	ИнтеграцияЗЕРНОКлиент.ОткрытьФормуВыбораОрганизаций(ЭтотОбъект, "Оформлено",, ВыборОрганизацииЗавершение);
	
КонецПроцедуры

&НаКлиенте
Процедура ОформленоОрганизацияПриИзменении(Элемент)
	
	ИнтеграцияЗЕРНОКлиент.ОбработатьВыборОрганизаций(ЭтотОбъект, Организация, Истина, "Оформлено");
	НастроитьДоступностьКомандыВыполнитьОбмен();
	
КонецПроцедуры

&НаКлиенте
Процедура ОформленоОрганизацияОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияЗЕРНОКлиент.ОбработатьВыборОрганизаций(ЭтотОбъект, Неопределено, Истина, "Оформлено");
	НастроитьДоступностьКомандыВыполнитьОбмен();
	
КонецПроцедуры

&НаКлиенте
Процедура ОформленоОрганизацияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ИнтеграцияЗЕРНОКлиент.ОбработатьВыборОрганизаций(ЭтотОбъект, ВыбранноеЗначение, Истина, "Оформлено");
	НастроитьДоступностьКомандыВыполнитьОбмен();
	
КонецПроцедуры

&НаКлиенте
Процедура КОформлениюОрганизацииПриИзменении(Элемент)
	
	ИнтеграцияЗЕРНОКлиент.ОбработатьВыборОрганизаций(ЭтотОбъект, Организации, Истина, "КОформлению");
	НастроитьДоступностьКомандыВыполнитьОбмен();
	
КонецПроцедуры

&НаКлиенте
Процедура КОформлениюОрганизацииОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияЗЕРНОКлиент.ОбработатьВыборОрганизаций(ЭтотОбъект, Неопределено, Истина, "КОформлению");
	НастроитьДоступностьКомандыВыполнитьОбмен();
	
КонецПроцедуры

&НаКлиенте
Процедура КОформлениюОрганизацииОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияЗЕРНОКлиент.ОбработатьВыборОрганизаций(ЭтотОбъект, ВыбранноеЗначение, Истина, "КОформлению");
	
КонецПроцедуры

&НаКлиенте
Процедура КОформлениюОрганизацииНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ВыборОрганизацииЗавершение = Новый ОписаниеОповещения("ВыборОрганизацииЗавершение", ЭтотОбъект);
	СтандартнаяОбработка = Ложь;
	ИнтеграцияЗЕРНОКлиент.ОткрытьФормуВыбораОрганизаций(ЭтотОбъект, "КОформлению",, ВыборОрганизацииЗавершение);
	
КонецПроцедуры

&НаКлиенте
Процедура КОформлениюОрганизацияПриИзменении(Элемент)
	
	ИнтеграцияЗЕРНОКлиент.ОбработатьВыборОрганизаций(ЭтотОбъект, Организация, Истина, "КОформлению");
	НастроитьДоступностьКомандыВыполнитьОбмен();
	
КонецПроцедуры

&НаКлиенте
Процедура КОформлениюОрганизацияОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияЗЕРНОКлиент.ОбработатьВыборОрганизаций(ЭтотОбъект, Неопределено, Истина, "КОформлению");
	НастроитьДоступностьКомандыВыполнитьОбмен();
	
КонецПроцедуры

&НаКлиенте
Процедура КОформлениюОрганизацияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияЗЕРНОКлиент.ОбработатьВыборОрганизаций(ЭтотОбъект, ВыбранноеЗначение, Истина, "КОформлению");
	
КонецПроцедуры

&НаКлиенте
Процедура КОформлениюОрганизацияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияЗЕРНОКлиент.ОткрытьФормуВыбораОрганизаций(ЭтотОбъект, "КОформлению");
	
КонецПроцедуры

&НаКлиенте
Процедура СтраницаКОформлениюОтборОтветственныйПриИзменении(Элемент)
	
	ОтветственныйОтборПриИзменении();
	
КонецПроцедуры

&НаКлиенте
Процедура КОформлениюГосмониторингОрганизацииПриИзменении(Элемент)
	
	ИнтеграцияЗЕРНОКлиент.ОбработатьВыборОрганизаций(ЭтотОбъект, Организации, Истина, "КОформлениюГосмониторинг");
	НастроитьДоступностьКомандыВыполнитьОбмен();
	
КонецПроцедуры

&НаКлиенте
Процедура КОформлениюГосмониторингОрганизацииОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияЗЕРНОКлиент.ОбработатьВыборОрганизаций(ЭтотОбъект, Неопределено, Истина, "КОформлениюГосмониторинг");
	НастроитьДоступностьКомандыВыполнитьОбмен();
	
КонецПроцедуры

&НаКлиенте
Процедура КОформлениюГосмониторингОрганизацииОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияЗЕРНОКлиент.ОбработатьВыборОрганизаций(ЭтотОбъект, ВыбранноеЗначение, Истина, "КОформлениюГосмониторинг");
	
КонецПроцедуры

&НаКлиенте
Процедура КОформлениюГосмониторингОрганизацииНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ВыборОрганизацииЗавершение = Новый ОписаниеОповещения("ВыборОрганизацииЗавершение", ЭтотОбъект);
	СтандартнаяОбработка = Ложь;
	ИнтеграцияЗЕРНОКлиент.ОткрытьФормуВыбораОрганизаций(ЭтотОбъект, "КОформлениюГосмониторинг",, ВыборОрганизацииЗавершение);
	
КонецПроцедуры

&НаКлиенте
Процедура КОформлениюГосмониторингОрганизацияПриИзменении(Элемент)
	
	ИнтеграцияЗЕРНОКлиент.ОбработатьВыборОрганизаций(ЭтотОбъект, Организация, Истина, "КОформлениюГосмониторинг");
	НастроитьДоступностьКомандыВыполнитьОбмен();
	
КонецПроцедуры

&НаКлиенте
Процедура КОформлениюГосмониторингОрганизацияОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияЗЕРНОКлиент.ОбработатьВыборОрганизаций(ЭтотОбъект, Неопределено, Истина, "КОформлениюГосмониторинг");
	НастроитьДоступностьКомандыВыполнитьОбмен();
	
КонецПроцедуры

&НаКлиенте
Процедура КОформлениюГосмониторингОрганизацияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияЗЕРНОКлиент.ОбработатьВыборОрганизаций(ЭтотОбъект, ВыбранноеЗначение, Истина, "КОформлениюГосмониторинг");
	
КонецПроцедуры

&НаКлиенте
Процедура КОформлениюГосмониторингОрганизацияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияЗЕРНОКлиент.ОткрытьФормуВыбораОрганизаций(ЭтотОбъект, "КОформлениюГосмониторинг");
	
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

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписокКОформлению

&НаКлиенте
Процедура СписокКОформлениюВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ИнтеграцияИСКлиент.ОткрытьРаспоряжение(Элементы.СписокКОформлению, СтандартнаяОбработка);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписокКОформлениюГосмониторинг

&НаКлиенте
Процедура СписокКОформлениюГосмониторингВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ИнтеграцияИСКлиент.ОткрытьРаспоряжение(Элементы.СписокКОформлениюГосмониторинг, СтандартнаяОбработка);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыполнитьОбмен(Команда)
	
	ИнтеграцияЗЕРНОКлиент.ВыполнитьОбмен(
		ЭтотОбъект,
		ИнтеграцияЗЕРНОКлиент.ОрганизацииДляОбмена(ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура ПередатьДанные(Команда)
	
	ИнтеграцияЗЕРНОКлиент.ПодготовитьСообщенияКПередаче(
		Элементы.Список, ПредопределенноеЗначение("Перечисление.ДальнейшиеДействияПоВзаимодействиюЗЕРНО.ПередайтеДанные"));
	
КонецПроцедуры

&НаКлиенте
Процедура АрхивироватьДокументы(Команда)
	
	ОбщегоНазначенияИСКлиент.АрхивироватьДокументы(ЭтотОбъект, Элементы.Список, ИнтеграцияЗЕРНОКлиент);
	
КонецПроцедуры

&НаКлиенте
Процедура Оформить(Команда)
	
	ОчиститьСообщения();
	
	Если Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаКОформлению Тогда
	
		Если Не ОбщегоНазначенияИСКлиент.ВыборСтрокиСпискаКорректен(Элементы.СписокКОформлению) Тогда
			Возврат;
		КонецЕсли;
		
		ИнтеграцияЗЕРНОКлиент.ОткрытьФормуСозданияДокумента(
			ОбщегоНазначенияИСКлиентСервер.ИмяОбъектаИзИмениФормы(ЭтотОбъект),
			Элементы.СписокКОформлению.ТекущиеДанные.ДокументОснование,
			ЭтотОбъект);
	Иначе
		Если НЕ ОбщегоНазначенияИСКлиент.ВыборСтрокиСпискаКорректен(Элементы.СписокКОформлениюГосмониторинг, Ложь) Тогда
			Возврат;
		КонецЕсли;
		МассивИсследований = Новый Массив;
		Для Каждого ИдентификаторСтроки Из Элементы.СписокКОформлениюГосмониторинг.ВыделенныеСтроки Цикл
			МассивИсследований.Добавить(Элементы.СписокКОформлениюГосмониторинг.ДанныеСтроки(ИдентификаторСтроки).ДокументОснование);
		КонецЦикла;
		Если НЕ ВозможностьВводаФормированияПартии(МассивИсследований) Тогда
			Возврат;
		КонецЕсли;
		
		ОткрытьФорму("Документ.ФормированиеПартийЗЕРНО.ФормаОбъекта",
			Новый Структура("Основание",МассивИсследований), ЭтотОбъект);
	КонецЕсли;		
	
КонецПроцедуры

&НаКлиенте
Процедура АрхивироватьОснования(Команда)
	
	Если Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаКОформлению Тогда
		ИнтеграцияИСКлиент.АрхивироватьРаспоряжения(ЭтотОбъект, Элементы.СписокКОформлению, ИнтеграцияЗЕРНОКлиент,
			ПредопределенноеЗначение("Документ.ФормированиеПартийЗЕРНО.ПустаяСсылка"));
	Иначе
		ИнтеграцияИСКлиент.АрхивироватьРаспоряжения(ЭтотОбъект, Элементы.СписокКОформлениюГосмониторинг, ИнтеграцияЗЕРНОКлиент,
			ПредопределенноеЗначение("Документ.ФормированиеПартийЗЕРНО.ПустаяСсылка"));
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьВыделенные(Команда)
	
	ГрупповоеИзменениеОбъектовКлиент.ИзменитьВыделенные(Элементы.Список);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьРезультатыИсследованийСОтбором(Команда)
	
	ЗапросРеестраИсследованийЗавершение = Новый ОписаниеОповещения("Подключаемый_ЗапросРеестраИсследованийЗавершение", ЭтотОбъект);
	
	ПараметрыФормы = ИнтеграцияЗЕРНОСлужебныйКлиент.ПараметрыОткрытияФормыЗапросаСправочника();
	ПараметрыФормы.СсылкаНаОбъект = ПредопределенноеЗначение("Справочник.РезультатыИсследованийЗЕРНО.ПустаяСсылка");
	ПараметрыФормы.ВидЗапроса     = 2;
	ПараметрыФормы.ТипЗапроса     = "РезультатыИсследований";
	
	Если ЗначениеЗаполнено(Организация) Тогда
		ПараметрыФормы.Организация = Организация;
	КонецЕсли;
	
	ИнтеграцияЗЕРНОСлужебныйКлиент.ОткрытьФормуЗапросаСправочника(ПараметрыФормы, ЭтотОбъект, ЗапросРеестраИсследованийЗавершение);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьИзмененияРезультатовИсследований(Команда)
	
	ИмяЗапросаЗЕРНО = ПредопределенноеЗначение("Перечисление.ИмяЗапросаЗЕРНО.РезультатыИсследований");
	ИнтеграцияЗЕРНОКлиент.ЗагрузитьИзменения(ЭтотОбъект, Организации.ВыгрузитьЗначения(), ИмяЗапросаЗЕРНО);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьАктыОтбораПробСОтбором(Команда)
	
	ЗапросАктовОтбораПробЗавершение = Новый ОписаниеОповещения("Подключаемый_ЗапросАктовОтбораПробЗавершение", ЭтотОбъект);
	
	ПараметрыФормы = ИнтеграцияЗЕРНОСлужебныйКлиент.ПараметрыОткрытияФормыЗапросаСправочника();
	ПараметрыФормы.ВидЗапроса     = 2;
	ПараметрыФормы.ТипЗапроса     = "АктыОтбораПроб";
	Если Элементы.Список.ТекущаяСтрока = Неопределено Тогда
		ПараметрыФормы.СсылкаНаОбъект = ПредопределенноеЗначение("Справочник.АктыОтбораПробЗЕРНО.ПустаяСсылка");
	Иначе
		ПараметрыФормы.СсылкаНаОбъект = Элементы.Список.ТекущаяСтрока;
	КонецЕсли;
	Если ЗначениеЗаполнено(Организация) Тогда
		ПараметрыФормы.Организация = Организация;
	КонецЕсли;
	
	ИнтеграцияЗЕРНОСлужебныйКлиент.ОткрытьФормуЗапросаСправочника(ПараметрыФормы, ЭтотОбъект, ЗапросАктовОтбораПробЗавершение);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьИзмененияАктовОтбораПроб(Команда)
	
	ИмяЗапросаЗЕРНО = ПредопределенноеЗначение("Перечисление.ИмяЗапросаЗЕРНО.АктыОтбораПроб");
	ИнтеграцияЗЕРНОКлиент.ЗагрузитьИзменения(ЭтотОбъект, Организации.ВыгрузитьЗначения(), ИмяЗапросаЗЕРНО);
	
КонецПроцедуры

#Область ПодключаемыеКоманды

//@skip-warning
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

//@skip-warning
&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

//@skip-warning
&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

//@skip-warning
&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормИСКлиентПереопределяемый.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	// Ошибки
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Статус.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(Элементы.Статус.ПутьКДанным);
	ОтборЭлемента.ВидСравнения  = ВидСравненияКомпоновкиДанных.ВСписке;
	
	СписокСтатусов = Новый СписокЗначений;
	СписокСтатусов.ЗагрузитьЗначения(Документы.ФормированиеПартийЗЕРНО.СтатусыОшибок());
	ОтборЭлемента.ПравоеЗначение = СписокСтатусов;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.СтатусОбработкиОшибкаПередачиГосИС);
	
	// Требуется ожидание
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Статус.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(Элементы.ДальнейшееДействие.ПутьКДанным);
	ОтборЭлемента.ВидСравнения  = ВидСравненияКомпоновкиДанных.ВСписке;
	
	СписокДействий = Новый СписокЗначений;
	СписокДействий.ЗагрузитьЗначения(Документы.ФормированиеПартийЗЕРНО.ВсеТребующиеОжидания());
	ОтборЭлемента.ПравоеЗначение = СписокДействий;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.СтатусОбработкиПередаетсяГосИС);
	
	// Даты
	СтандартныеПодсистемыСервер.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "Список.Дата", Элементы.Дата.Имя);
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьИПроверитьПереданныеПараметры();
	
	Элементы.Список.РежимВыбора = Параметры.РежимВыбора;
	
	Если Параметры.МножественныйВыбор <> Неопределено Тогда
		Элементы.Список.МножественныйВыбор = Параметры.МножественныйВыбор;
	КонецЕсли;
	
	Если Параметры.РежимВыбора Тогда
		Элементы.СтраницаКОформлению.Видимость = Ложь;
		Элементы.Страницы.ОтображениеСтраниц   = ОтображениеСтраницФормы.Нет;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборОрганизацииЗавершение(ВыбранноеЗначение, ДополнительныеПараметры) Экспорт
	
	Если ВыбранноеЗначение = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	НастроитьДоступностьКомандыВыполнитьОбмен();
	
КонецПроцедуры

#Область ОтборДальнейшиеДействия

// Возвращает массив дальнейших действий с документом, требующих участия пользователя
// 
// Возвращаемое значение:
// 	Массив из ПеречислениеСсылка.ДальнейшиеДействияПоВзаимодействиюЗЕРНО - Массив дальшейних действий
//
&НаСервереБезКонтекста
Функция ВсеТребующиеДействия()
	
	Возврат Документы.ФормированиеПартийЗЕРНО.ВсеТребующиеДействия();
	
КонецФункции

&НаСервереБезКонтекста
Функция ВсеТребующиеОжидания()
	
	Возврат Документы.ФормированиеПартийЗЕРНО.ВсеТребующиеОжидания();
	
КонецФункции

&НаСервере
Процедура УстановитьОтборПоДальнейшемуДействиюСервер()
	
	ИнтеграцияЗЕРНО.УстановитьОтборПоДальнейшемуДействию(
		Список, ДальнейшееДействие, ВсеТребующиеДействия(), ВсеТребующиеОжидания());
	
КонецПроцедуры

&НаСервере
Процедура УстановитьБыстрыйОтборСервер()
	
	СтруктураБыстрогоОтбора = Неопределено;
	Параметры.Свойство("СтруктураБыстрогоОтбора", СтруктураБыстрогоОтбора);
	
	Если СтруктураБыстрогоОтбора <> Неопределено Тогда
		
		СтруктураБыстрогоОтбора.Свойство("Организация", Организация);
		СтруктураБыстрогоОтбора.Свойство("Организации", Организации);
		
		Если ЗначениеЗаполнено(Организации) Тогда
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список,                         "Организация", Организации,,, Истина);
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(СписокКОформлению,              "Организация", Организации,,, Истина);
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(СписокКОформлениюГосмониторинг, "Организация", Организации,,, Истина);
			ОрганизацииПредставление = Строка(Организации);
		КонецЕсли;
		
		ИнтеграцияИС.ОтборПоЗначениюСпискаПриСозданииНаСервере(Список,            "Ответственный", Ответственный, СтруктураБыстрогоОтбора);
		ИнтеграцияИС.ОтборПоЗначениюСпискаПриСозданииНаСервере(СписокКОформлению, "Ответственный", Ответственный, СтруктураБыстрогоОтбора);
		
	КонецЕсли;
	
	ЗаполнитьСписокВыбораОрганизацииПоСохраненнымНастройкам();
	
	Если ИнтеграцияЗЕРНО.НеобходимОтборПоДальнейшемуДействиюПриСозданииНаСервере(ДальнейшееДействие, СтруктураБыстрогоОтбора) Тогда
		УстановитьОтборПоДальнейшемуДействиюСервер();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура НастроитьВидимостьДоступностьЭлементовСервер()
	
	Если НЕ ПравоДоступа("Добавление", Метаданные.Документы.ФормированиеПартийЗЕРНО) Тогда
		Элементы.СтраницаКОформлению.Видимость = Ложь;
	ИначеЕсли Параметры.ОткрытьРаспоряжения Тогда
		Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаКОформлению;
	КонецЕсли;
	
	НастроитьДоступностьКомандыВыполнитьОбмен();
	
КонецПроцедуры

&НаСервере
Процедура НастроитьДоступностьКомандыВыполнитьОбмен()
	
	СобытияФормЗЕРНО.ДоступностьКомандыВыполнитьОбмен(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

//@skip-warning
&НаКлиенте
Процедура Подключаемый_ВыполнитьОбменОбработкаОжидания()

	ИнтеграцияЗЕРНОСлужебныйКлиент.ПродолжитьВыполнениеОбмена(ЭтотОбъект);

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокВыбораОрганизацииПоСохраненнымНастройкам()
	
	СобытияФормЗЕРНО.ЗаполнитьСписокВыбораОрганизацииПоСохраненнымНастройкам(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ЗапросРеестраИсследованийЗавершение(Результат, ДополнительныеПараметры) Экспорт

	Элементы.СписокКОформлениюГосмониторинг.Обновить();

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ЗапросАктовОтбораПробЗавершение(Результат, ДополнительныеПараметры) Экспорт

	Элементы.Список.Обновить();

КонецПроцедуры

&НаКлиенте
Процедура ОтветственныйОтборПриИзменении()
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, "Ответственный", Ответственный, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(Ответственный));
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		СписокКОформлению, "Ответственный", Ответственный, ВидСравненияКомпоновкиДанных.Равно, , ЗначениеЗаполнено(Ответственный));
	
КонецПроцедуры

#КонецОбласти

#Область ПодготовкаВводаНаОсновании

&НаКлиенте
Функция ВозможностьВводаФормированияПартии(Знач ВыделенныеСтроки)
	
	Если ВыделенныеСтроки = Неопределено Тогда
		Возврат Ложь;
	ИначеЕсли ВыделенныеСтроки.Количество() = 0 Тогда
		Возврат Ложь;
	ИначеЕсли ВыделенныеСтроки.Количество() = 1 Тогда
		Возврат Истина;
	КонецЕсли;
	
	ДанныеОтбора = Новый Структура("Товаропроизводитель");
	ПерваяЗаписьОбработана = Ложь;
		
	РеквизитыИсследований = ОбщегоНазначенияИСВызовСервера.ЗначенияРеквизитовОбъектов(ВыделенныеСтроки, "Товаропроизводитель");
	
	Для Каждого ВыделеннаяСтрока Из ВыделенныеСтроки Цикл
		ТоваропроизводительСтроки = РеквизитыИсследований[ВыделеннаяСтрока].Товаропроизводитель;
		Если Не ПерваяЗаписьОбработана Тогда
			Товаропроизводитель = ТоваропроизводительСтроки;
			ПерваяЗаписьОбработана = Истина;
			Продолжить;
		КонецЕсли;
		Для Каждого КлючИЗначение Из ДанныеОтбора Цикл
			Если ТоваропроизводительСтроки <> Товаропроизводитель Тогда
				ОбщегоНазначенияКлиент.СообщитьПользователю(
					НСтр("ru = 'Различаются ключевые реквизиты исследований. Выделенные строки должны быть включены в различные документы формирования партий';
						|en = 'Различаются ключевые реквизиты исследований. Выделенные строки должны быть включены в различные документы формирования партий'"),,"СписокКОформлениюГосмониторинг");
				Возврат Ложь;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	Возврат Истина;
	
КонецФункции

#КонецОбласти

#КонецОбласти