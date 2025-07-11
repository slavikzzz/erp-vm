///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ОпределитьПоведениеВМобильномКлиенте();
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ЦентрМониторинга") Тогда 
		
		// Подсчитываем количество созданий формы, стандартный разделитель ".".
		Комментарий = Строка(ПолучитьСкоростьКлиентскогоСоединения());
		
		МодульЦентрМониторинга = ОбщегоНазначения.ОбщийМодуль("ЦентрМониторинга");
		МодульЦентрМониторинга.ЗаписатьОперациюБизнесСтатистики("ОбщаяФорма.ФормаВариантаОтчета", 1, Комментарий);
		
	КонецЕсли;
	
	ФормаПараметры = ВариантыОтчетов.СохраняемыеПараметрыФормыОтчета(Параметры);
	
	Если ЗначениеЗаполнено(Параметры.ПредставлениеВарианта) Тогда
		АвтоЗаголовок = Ложь;
		Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Изменение варианта отчета ""%1""';
																				|en = 'Modify report option %1'"), Параметры.ПредставлениеВарианта);
	КонецЕсли;
	
	Если Параметры.НастройкиОтчета <> Неопределено Тогда
		НастройкиОтчета = Параметры.НастройкиОтчета;
		Если НастройкиОтчета.СхемаМодифицирована Тогда
			Отчет.КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(НастройкиОтчета.АдресСхемы));
		КонецЕсли;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Параметры.ПредставлениеВарианта) Тогда
		Параметры.ПредставлениеВарианта = Параметры.ВариантНаименование;
	КонецЕсли;
	
	НастройкиКД = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(Параметры, "Вариант");
	Если НастройкиКД = Неопределено Тогда
		НастройкиКД = Отчет.КомпоновщикНастроек.Настройки;
	КонецЕсли;
	
	Параметры.Свойство("ИдентификаторЭлементаСтруктурыНастроек", ИдентификаторЭлементаСтруктурыНастроек);
	
	ПутьКЭлементуСтруктурыНастроек = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(
		Параметры, "ПутьКЭлементуСтруктурыНастроек", "");
	
	ЭлементСтруктуры = ОтчетыСервер.ЭлементНастроекПоПолномуПути(НастройкиКД, ПутьКЭлементуСтруктурыНастроек);
	Если ЭлементСтруктуры <> Неопределено Тогда
		ИдентификаторЭлементаСтруктурыНастроек = НастройкиКД.ПолучитьИдентификаторПоОбъекту(ЭлементСтруктуры);
	КонецЕсли;
	
	ВариантМодифицирован = Параметры.ВариантМодифицирован;
	ПользовательскиеНастройкиМодифицированы = Параметры.ПользовательскиеНастройкиМодифицированы;
	
	УстановитьТекущуюСтраницу();
КонецПроцедуры

&НаСервере
Процедура ПередЗагрузкойВариантаНаСервере(НовыеНастройкиКД)
	Если ТипЗнч(ФормаПараметры.Отбор) = Тип("Структура") Тогда
		ОтчетыСервер.УстановитьФиксированныеОтборы(ФормаПараметры.Отбор, НовыеНастройкиКД, НастройкиОтчета);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеПользовательскихНастроекНаСервере(Настройки)
	НовыеНастройки = Отчет.КомпоновщикНастроек.ПолучитьНастройки();
	Отчет.КомпоновщикНастроек.ЗагрузитьФиксированныеНастройки(Новый НастройкиКомпоновкиДанных);
	ОтчетыКлиентСервер.ЗагрузитьНастройки(Отчет.КомпоновщикНастроек, НовыеНастройки);
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Если ТипЗнч(ИдентификаторЭлементаСтруктурыНастроек) = Тип("ИдентификаторКомпоновкиДанных") Тогда
		ПодключитьОбработчикОжидания("УстановитьТекущуюСтроку", 0.1, Истина);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыПараметрыВывода

&НаКлиенте
Процедура КомпоновщикНастроекНастройкиПараметрыВыводаПриИзменении(Элемент)
	
	Строка = Элемент.ТекущиеДанные;
	ИдентификаторПараметра = "Заголовок";
	
	Если Строка <> Неопределено
		И Строка.Свойство("Параметр")
		И Строка.Параметр = ИдентификаторПараметра Тогда 
		
		Отчет.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.Вставить(
			"ЗаголовокУстановленИнтерактивно", ЗначениеЗаполнено(Строка.Значение));
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗакрытьИСформировать(Команда)
	Если МодальныйРежим Или РежимОткрытияОкна = РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс
		Или ВладелецФормы = Неопределено Тогда
		Закрыть(Истина);
		Возврат;
	КонецЕсли;

	РезультатВыбора = ОтчетыКлиентСервер.ПараметрыОбновленияФормыОтчета(
		ВариантыОтчетовСлужебныйКлиентСервер.ИмяСобытияФормыНастроек());
	РезультатВыбора.КомпоновщикНастроекКД = Отчет.КомпоновщикНастроек;
	РезультатВыбора.ВариантМодифицирован = ВариантМодифицирован;
	РезультатВыбора.ПользовательскиеНастройкиМодифицированы = ВариантМодифицирован Или ПользовательскиеНастройкиМодифицированы;
	РезультатВыбора.Переформировать = Истина;
	
	Если РезультатВыбора.ПользовательскиеНастройкиМодифицированы Тогда
		РезультатВыбора.СброситьПользовательскиеНастройки = Истина;
	КонецЕсли;
	
	ОповеститьОВыборе(РезультатВыбора);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОпределитьПоведениеВМобильномКлиенте()
	ЭтоМобильныйКлиент = ОбщегоНазначения.ЭтоМобильныйКлиент();
	Если Не ЭтоМобильныйКлиент Тогда 
		Возврат;
	КонецЕсли;
	
	ПоложениеКоманднойПанели = ПоложениеКоманднойПанелиФормы.Авто;
КонецПроцедуры

&НаСервере
Процедура УстановитьТекущуюСтраницу()
	Если Не ЗначениеЗаполнено(Параметры.ИмяСтраницы) Тогда
		Возврат;
	КонецЕсли;
	
	СвязиСтраниц = Новый Соответствие;
	СвязиСтраниц.Вставить("СтраницаОтборы", "СтраницаОтбора");
	СвязиСтраниц.Вставить("СтраницаВыбранныеПоляИСортировки", "СтраницаПолейВыбора");
	СвязиСтраниц.Вставить("СтраницаОформление", "СтраницаУсловногоОформления");
	
	ИмяСтраницы = СвязиСтраниц[Параметры.ИмяСтраницы];
	НайденнаяСтраница = Элементы.Найти(ИмяСтраницы);
	
	Если НайденнаяСтраница = Неопределено Тогда
		НайденнаяСтраница = Элементы.Найти(Параметры.ИмяСтраницы);
	КонецЕсли;
	
	Если НайденнаяСтраница <> Неопределено Тогда 
		Элементы.СтраницыНастроек.ТекущаяСтраница = НайденнаяСтраница;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура УстановитьТекущуюСтроку()
	Элементы.КомпоновщикНастроекНастройки.ТекущаяСтрока = ИдентификаторЭлементаСтруктурыНастроек;
КонецПроцедуры

&НаКлиенте
Процедура ПоляГруппировкиНедоступны()
	
	Элементы.СтраницыПолейГруппировки.ТекущаяСтраница = Элементы.НедоступныеНастройкиПолейГруппировки;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбранныеПоляДоступны(ЭлементСтруктуры)
	
	Если Отчет.КомпоновщикНастроек.Настройки.НаличиеВыбораУЭлемента(ЭлементСтруктуры) Тогда
		
		ЛокальныеВыбранныеПоля = Истина;
		Элементы.СтраницыПолейВыбора.ТекущаяСтраница = Элементы.НастройкиВыбранныхПолей;
		
	Иначе
		
		ЛокальныеВыбранныеПоля = Ложь;
		Элементы.СтраницыПолейВыбора.ТекущаяСтраница = Элементы.ОтключенныеНастройкиВыбранныхПолей;
		
	КонецЕсли;
	
	Элементы.ЛокальныеВыбранныеПоля.ТолькоПросмотр = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбранныеПоляНедоступны()
	
	ЛокальныеВыбранныеПоля = Ложь;
	Элементы.ЛокальныеВыбранныеПоля.ТолькоПросмотр = Истина;
	Элементы.СтраницыПолейВыбора.ТекущаяСтраница = Элементы.НедоступныеНастройкиВыбранныхПолей;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборДоступен(ЭлементСтруктуры)
	
	Если Отчет.КомпоновщикНастроек.Настройки.НаличиеОтбораУЭлемента(ЭлементСтруктуры) Тогда
		
		ЛокальныйОтбор = Истина;
		Элементы.СтраницыОтбора.ТекущаяСтраница = Элементы.НастройкиОтбора;
		
	Иначе
		
		ЛокальныйОтбор = Ложь;
		Элементы.СтраницыОтбора.ТекущаяСтраница = Элементы.ОтключенныеНастройкиОтбора;
		
	КонецЕсли;
	
	Элементы.ЛокальныйОтбор.ТолькоПросмотр = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборНедоступен()
	
	ЛокальныйОтбор = Ложь;
	Элементы.ЛокальныйОтбор.ТолькоПросмотр = Истина;
	Элементы.СтраницыОтбора.ТекущаяСтраница = Элементы.НедоступныеНастройкиОтбора;
	
КонецПроцедуры

&НаКлиенте
Процедура ПорядокДоступен(ЭлементСтруктуры)
	
	Если Отчет.КомпоновщикНастроек.Настройки.НаличиеПорядкаУЭлемента(ЭлементСтруктуры) Тогда
		
		ЛокальныйПорядок = Истина;
		Элементы.СтраницыПорядка.ТекущаяСтраница = Элементы.НастройкиПорядка;
		
	Иначе
		
		ЛокальныйПорядок = Ложь;
		Элементы.СтраницыПорядка.ТекущаяСтраница = Элементы.ОтключенныеНастройкиПорядка;
		
	КонецЕсли;
	
	Элементы.ЛокальныйПорядок.ТолькоПросмотр = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ПорядокНедоступен()
	
	ЛокальныйПорядок = Ложь;
	Элементы.ЛокальныйПорядок.ТолькоПросмотр = Истина;
	Элементы.СтраницыПорядка.ТекущаяСтраница = Элементы.НедоступныеНастройкиПорядка;
	
КонецПроцедуры

&НаКлиенте
Процедура УсловноеОформлениеДоступно(ЭлементСтруктуры)
	
	Если Отчет.КомпоновщикНастроек.Настройки.НаличиеУсловногоОформленияУЭлемента(ЭлементСтруктуры) Тогда
		
		ЛокальноеУсловноеОформление = Истина;
		Элементы.СтраницыУсловногоОформления.ТекущаяСтраница = Элементы.НастройкиУсловногоОформления;
		
	Иначе
		
		ЛокальноеУсловноеОформление = Ложь;
		Элементы.СтраницыУсловногоОформления.ТекущаяСтраница = Элементы.ОтключенныеНастройкиУсловногоОформления;
		
	КонецЕсли;
	
	Элементы.ЛокальноеУсловноеОформление.ТолькоПросмотр = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура УсловноеОформлениеНедоступно()
	
	ЛокальноеУсловноеОформление = Ложь;
	Элементы.ЛокальноеУсловноеОформление.ТолькоПросмотр = Истина;
	Элементы.СтраницыУсловногоОформления.ТекущаяСтраница = Элементы.НедоступныеНастройкиУсловногоОформления;
	
КонецПроцедуры

&НаКлиенте
Процедура ПараметрыВыводаДоступны(ЭлементСтруктуры)
	
	Если Отчет.КомпоновщикНастроек.Настройки.НаличиеПараметровВыводаУЭлемента(ЭлементСтруктуры) Тогда
		
		ЛокальныеПараметрыВывода = Истина;
		Элементы.СтраницыПараметровВывода.ТекущаяСтраница = Элементы.НастройкиПараметровВывода;
		
	Иначе
		
		ЛокальныеПараметрыВывода = Ложь;
		Элементы.СтраницыПараметровВывода.ТекущаяСтраница = Элементы.ОтключенныеНастройкиПараметровВывода;
		
	КонецЕсли;
	
	Элементы.ЛокальныеПараметрыВывода.ТолькоПросмотр = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ПараметрыВыводаНедоступны()
	
	ЛокальныеПараметрыВывода = Ложь;
	Элементы.ЛокальныеПараметрыВывода.ТолькоПросмотр = Истина;
	Элементы.СтраницыПараметровВывода.ТекущаяСтраница = Элементы.НедоступныеНастройкиПараметровВывода;
	
КонецПроцедуры

&НаКлиенте
Процедура КомпоновщикНастроекНастройкиПриАктивизацииПоля(Элемент)
	
	Перем ВыбраннаяСтраница;
	
	Если Элементы.КомпоновщикНастроекНастройки.ТекущийЭлемент.Имя = "КомпоновщикНастроекНастройкиНаличиеВыбора" Тогда
		
		ВыбраннаяСтраница = Элементы.СтраницаПолейВыбора;
		
	ИначеЕсли Элементы.КомпоновщикНастроекНастройки.ТекущийЭлемент.Имя = "КомпоновщикНастроекНастройкиНаличиеОтбора" Тогда
		
		ВыбраннаяСтраница = Элементы.СтраницаОтбора;
		
	ИначеЕсли Элементы.КомпоновщикНастроекНастройки.ТекущийЭлемент.Имя = "КомпоновщикНастроекНастройкиНаличиеПорядка" Тогда
		
		ВыбраннаяСтраница = Элементы.СтраницаПорядка;
		
	ИначеЕсли Элементы.КомпоновщикНастроекНастройки.ТекущийЭлемент.Имя = "КомпоновщикНастроекНастройкиНаличиеУсловногоОформления" Тогда
		
		ВыбраннаяСтраница = Элементы.СтраницаУсловногоОформления;
		
	ИначеЕсли Элементы.КомпоновщикНастроекНастройки.ТекущийЭлемент.Имя = "КомпоновщикНастроекНастройкиНаличиеПараметровВывода" Тогда
		
		ВыбраннаяСтраница = Элементы.СтраницаПараметровВывода;
		
	КонецЕсли;
	
	Если ВыбраннаяСтраница <> Неопределено Тогда
		
		Элементы.СтраницыНастроек.ТекущаяСтраница = ВыбраннаяСтраница;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КомпоновщикНастроекНастройкиПриАктивизацииСтроки(Элемент)
	
	ЭлементСтруктуры = Отчет.КомпоновщикНастроек.Настройки.ПолучитьОбъектПоИдентификатору(Элементы.КомпоновщикНастроекНастройки.ТекущаяСтрока);
	ТипЭлемента = ТипЗнч(ЭлементСтруктуры); 
	
	Если ТипЭлемента = Неопределено
		Или ТипЭлемента = Тип("КоллекцияЭлементовСтруктурыДиаграммыКомпоновкиДанных")
		Или ТипЭлемента = Тип("КоллекцияЭлементовСтруктурыТаблицыКомпоновкиДанных") Тогда
		
		ПоляГруппировкиНедоступны();
		ВыбранныеПоляНедоступны();
		ОтборНедоступен();
		ПорядокНедоступен();
		УсловноеОформлениеНедоступно();
		ПараметрыВыводаНедоступны();
		
	ИначеЕсли ТипЭлемента = Тип("НастройкиКомпоновкиДанных")
		Или ТипЭлемента = Тип("НастройкиВложенногоОбъектаКомпоновкиДанных") Тогда
		
		ПоляГруппировкиНедоступны();
		
		ЛокальныеВыбранныеПоля = Истина;
		Элементы.ЛокальныеВыбранныеПоля.ТолькоПросмотр = Истина;
		Элементы.СтраницыПолейВыбора.ТекущаяСтраница = Элементы.НастройкиВыбранныхПолей;
		
		ЛокальныйОтбор = Истина;
		Элементы.ЛокальныйОтбор.ТолькоПросмотр = Истина;
		Элементы.СтраницыОтбора.ТекущаяСтраница = Элементы.НастройкиОтбора;
		
		ЛокальныйПорядок = Истина;
		Элементы.ЛокальныйПорядок.ТолькоПросмотр = Истина;
		Элементы.СтраницыПорядка.ТекущаяСтраница = Элементы.НастройкиПорядка;
		
		ЛокальноеУсловноеОформление = Истина;
		Элементы.ЛокальноеУсловноеОформление.ТолькоПросмотр = Истина;
		Элементы.СтраницыУсловногоОформления.ТекущаяСтраница = Элементы.НастройкиУсловногоОформления;
		
		ЛокальныеПараметрыВывода = Истина;
		Элементы.ЛокальныеПараметрыВывода.ТолькоПросмотр = Истина;
		Элементы.СтраницыПараметровВывода.ТекущаяСтраница = Элементы.НастройкиПараметровВывода;
		
	ИначеЕсли ТипЭлемента = Тип("ГруппировкаКомпоновкиДанных")
		Или ТипЭлемента = Тип("ГруппировкаТаблицыКомпоновкиДанных")
		Или ТипЭлемента = Тип("ГруппировкаДиаграммыКомпоновкиДанных") Тогда
		
		Элементы.СтраницыПолейГруппировки.ТекущаяСтраница = Элементы.НастройкиПолейГруппировки;
		
		ВыбранныеПоляДоступны(ЭлементСтруктуры);
		ОтборДоступен(ЭлементСтруктуры);
		ПорядокДоступен(ЭлементСтруктуры);
		УсловноеОформлениеДоступно(ЭлементСтруктуры);
		ПараметрыВыводаДоступны(ЭлементСтруктуры);
		
	ИначеЕсли ТипЭлемента = Тип("ТаблицаКомпоновкиДанных")
		Или ТипЭлемента = Тип("ДиаграммаКомпоновкиДанных") Тогда
		
		ПоляГруппировкиНедоступны();
		ВыбранныеПоляДоступны(ЭлементСтруктуры);
		ОтборНедоступен();
		ПорядокНедоступен();
		УсловноеОформлениеДоступно(ЭлементСтруктуры);
		ПараметрыВыводаДоступны(ЭлементСтруктуры);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиКОтчету(Элемент)
	
	ЭлементСтруктуры = Отчет.КомпоновщикНастроек.Настройки.ПолучитьОбъектПоИдентификатору(Элементы.КомпоновщикНастроекНастройки.ТекущаяСтрока);
	НастройкиЭлемента =  Отчет.КомпоновщикНастроек.Настройки.НастройкиЭлемента(ЭлементСтруктуры);
	Элементы.КомпоновщикНастроекНастройки.ТекущаяСтрока = Отчет.КомпоновщикНастроек.Настройки.ПолучитьИдентификаторПоОбъекту(НастройкиЭлемента);
	
КонецПроцедуры

&НаКлиенте
Процедура ЛокальныеВыбранныеПоляПриИзменении(Элемент)
	
	Если ЛокальныеВыбранныеПоля Тогда
		
		Элементы.СтраницыПолейВыбора.ТекущаяСтраница = Элементы.НастройкиВыбранныхПолей;
		
	Иначе
		
		Элементы.СтраницыПолейВыбора.ТекущаяСтраница = Элементы.ОтключенныеНастройкиВыбранныхПолей;

		ЭлементСтруктуры = Отчет.КомпоновщикНастроек.Настройки.ПолучитьОбъектПоИдентификатору(Элементы.КомпоновщикНастроекНастройки.ТекущаяСтрока);
		Отчет.КомпоновщикНастроек.Настройки.ОчиститьВыборЭлемента(ЭлементСтруктуры);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЛокальныйОтборПриИзменении(Элемент)
	
	Если ЛокальныйОтбор Тогда
		
		Элементы.СтраницыОтбора.ТекущаяСтраница = Элементы.НастройкиОтбора;
		
	Иначе
		
		Элементы.СтраницыОтбора.ТекущаяСтраница = Элементы.ОтключенныеНастройкиОтбора;

		ЭлементСтруктуры = Отчет.КомпоновщикНастроек.Настройки.ПолучитьОбъектПоИдентификатору(Элементы.КомпоновщикНастроекНастройки.ТекущаяСтрока);
		Отчет.КомпоновщикНастроек.Настройки.ОчиститьОтборЭлемента(ЭлементСтруктуры);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЛокальныйПорядокПриИзменении(Элемент)
	
	Если ЛокальныйПорядок Тогда
		
		Элементы.СтраницыПорядка.ТекущаяСтраница = Элементы.НастройкиПорядка;
		
	Иначе
		
		Элементы.СтраницыПорядка.ТекущаяСтраница = Элементы.ОтключенныеНастройкиПорядка;
		
		ЭлементСтруктуры = Отчет.КомпоновщикНастроек.Настройки.ПолучитьОбъектПоИдентификатору(Элементы.КомпоновщикНастроекНастройки.ТекущаяСтрока);
		Отчет.КомпоновщикНастроек.Настройки.ОчиститьПорядокЭлемента(ЭлементСтруктуры);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЛокальноеУсловноеОформлениеПриИзменении(Элемент)

	Если ЛокальноеУсловноеОформление Тогда
		
		Элементы.СтраницыУсловногоОформления.ТекущаяСтраница = Элементы.НастройкиУсловногоОформления;
		
	Иначе
		
		Элементы.СтраницыУсловногоОформления.ТекущаяСтраница = Элементы.ОтключенныеНастройкиУсловногоОформления;
		
		ЭлементСтруктуры = Отчет.КомпоновщикНастроек.Настройки.ПолучитьОбъектПоИдентификатору(Элементы.КомпоновщикНастроекНастройки.ТекущаяСтрока);
		Отчет.КомпоновщикНастроек.Настройки.ОчиститьУсловноеОформлениеЭлемента(ЭлементСтруктуры);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЛокальныеПараметрыВыводаПриИзменении(Элемент)
	
	Если ЛокальныеПараметрыВывода Тогда
		
		Элементы.СтраницыПараметровВывода.ТекущаяСтраница = Элементы.НастройкиПараметровВывода;
		
	Иначе
		
		Элементы.СтраницыПараметровВывода.ТекущаяСтраница = Элементы.ОтключенныеНастройкиПараметровВывода;
		
		ЭлементСтруктуры = Отчет.КомпоновщикНастроек.Настройки.ПолучитьОбъектПоИдентификатору(Элементы.КомпоновщикНастроекНастройки.ТекущаяСтрока);
		Отчет.КомпоновщикНастроек.Настройки.ОчиститьПараметрыВыводаЭлемента(ЭлементСтруктуры);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
