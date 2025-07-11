
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	// Форму можно открыть в следующих режимах:
	// 1. В режиме настройки маршрутных карт для заданной номенклатуры.
	//    В этом режиме пользователь не может изменить номенклатуру и выбор маршрутных карт ограничен.
	//
	// 2. В режиме настройки маршрутных карт для заданной номенклатуры и маршрутной карты.
	//    В этом режиме пользователь не может изменить номенклатуру и маршрутную карту.
	//
	// 3. В режиме настройки маршрутных карт для маршрутных карт.
	//    В этом режиме пользователь не может изменить маршрутную карту и выбор номенклатуры ограничен.
	//
	// 4. В обычном режиме.
	//    В этом режиме нет ограничений.
	
	Параметры.Свойство("ДляЗаданнойНоменклатуры",    ДляЗаданнойНоменклатуры);
	Параметры.Свойство("ДляЗаданнойМаршрутнойКарты", ДляЗаданнойМаршрутнойКарты);
	
	СтруктураБыстрогоОтбора = Неопределено;
	Параметры.Свойство("СтруктураБыстрогоОтбора", СтруктураБыстрогоОтбора);
	
	ОтборыСписковКлиентСервер.ОтборПоЗначениюСпискаПриСозданииНаСервере(Список, "Номенклатура", ОтборИзделие, СтруктураБыстрогоОтбора);
	ОтборыСписковКлиентСервер.ОтборПоЗначениюСпискаПриСозданииНаСервере(Список, "Подразделение", ОтборПодразделение, СтруктураБыстрогоОтбора);
	
	Если ДляЗаданнойНоменклатуры Тогда
		
		Элементы.ОтборИзделие.ТолькоПросмотр = Истина;

	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтборПодразделениеПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, 
		"Подразделение", 
		ОтборПодразделение, 
		ВидСравненияКомпоновкиДанных.Равно,
		, 
		ЗначениеЗаполнено(ОтборПодразделение));
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборИзделиеПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, 
		"Номенклатура", 
		ОтборИзделие, 
		ВидСравненияКомпоновкиДанных.Равно,
		, 
		ЗначениеЗаполнено(ОтборИзделие));
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	
	ЗначенияЗаполнения = Новый Структура;
	ЗначенияЗаполнения.Вставить("Подразделение",   ОтборПодразделение);
	ЗначенияЗаполнения.Вставить("Номенклатура",    ОтборИзделие);
	ЗначенияЗаполнения.Вставить("МаршрутнаяКарта", ДляЗаданнойМаршрутнойКарты);
	
	ПараметрыФормы = Новый Структура("ЗначенияЗаполнения", ЗначенияЗаполнения);
	
	Если ДляЗаданнойНоменклатуры Тогда
		ОткрытьФорму("РегистрСведений.ОсновныеМаршрутныеКарты.Форма.ФормаЗаписиДляЗаданнойНоменклатуры", ПараметрыФормы); 
	Иначе
		ОткрытьФорму("РегистрСведений.ОсновныеМаршрутныеКарты.ФормаЗаписи", ПараметрыФормы); 
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПослеУдаления(Элемент)
	
	УправлениеДаннымиОбИзделияхКлиент.ОповеститьОЗаписиОсновнойМаршрутнойКарты();

КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если ДляЗаданнойНоменклатуры Тогда
		СтандартнаяОбработка = Ложь;
		ОткрытьФормуЗаписи();
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломИзменения(Элемент, Отказ)
	
	Если ДляЗаданнойНоменклатуры Тогда
		Отказ = Истина;
		ОткрытьФормуЗаписи();
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Список.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.Спецификация");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Новый ПолеКомпоновкиДанных("ДляЗаданнойСпецификации");

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ОтборСпецификация");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено;
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ГиперссылкаЦвет);

КонецПроцедуры

#Область Прочее

&НаКлиенте
Процедура ОткрытьФормуЗаписи()

	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	
	ДанныеКлючаЗаписи = Новый Структура("Номенклатура,Характеристика,Подразделение", 
									ТекущиеДанные.Номенклатура, 
									ТекущиеДанные.Характеристика, 
									ТекущиеДанные.Подразделение);
									
	МассивПараметровКонструктора = Новый Массив();
	МассивПараметровКонструктора.Добавить(ДанныеКлючаЗаписи);
	
	КлючЗаписи = Новый("РегистрСведенийКлючЗаписи.ОсновныеМаршрутныеКарты", МассивПараметровКонструктора);	
	
	ОткрытьФорму("РегистрСведений.ОсновныеМаршрутныеКарты.Форма.ФормаЗаписиДляЗаданнойНоменклатуры", Новый Структура("Ключ", КлючЗаписи));
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
