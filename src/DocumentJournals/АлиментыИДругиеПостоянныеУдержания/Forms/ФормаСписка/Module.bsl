#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Параметры.Свойство("ДатаСобытия", ДатаСобытия);
	Параметры.Свойство("Организация", Организация);
	
	СтруктураПараметровОтбора = Новый Структура();
	ЗарплатаКадры.ДобавитьПараметрОтбора(СтруктураПараметровОтбора, "ФизическоеЛицо",
		Новый ОписаниеТипов("СправочникСсылка.ФизическиеЛица"), НСтр("ru = 'Сотрудник';
																	|en = 'Employee'"));
	ЗарплатаКадры.ДобавитьПараметрОтбора(СтруктураПараметровОтбора, "Подразделение",
		Новый ОписаниеТипов("СправочникСсылка.ПодразделенияОрганизаций"), НСтр("ru = 'Подразделение';
																				|en = 'Business unit'"));
	
	ЗарплатаКадры.ПриСозданииНаСервереФормыСДинамическимСписком(ЭтотОбъект, "Список",,
		СтруктураПараметровОтбора, "СписокКритерииОтбора");
		
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.КоманднаяПанель = Элементы.КоманднаяПанельФормы;
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// ПроцессыОбработкиДокументов
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ПроцессыОбработкиДокументовЗарплата") Тогда
		МодульПроцессыОбработкиДокументовЗарплата = ОбщегоНазначения.ОбщийМодуль("ПроцессыОбработкиДокументовЗарплата");
		МодульПроцессыОбработкиДокументовЗарплата.ПриСозданииНаСервереФормыСписка(ЭтотОбъект, "Список");
	КонецЕсли;	
	// Конец ПроцессыОбработкиДокументов
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура Подключаемый_ПараметрОтбораПриИзменении(Элемент)
	ЗарплатаКадрыКлиент.ПараметрОтбораНаФормеСДинамическимСпискомПриИзменении(ЭтотОбъект, Элемент.Имя);
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Если Параметр = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыОткрытия = Новый Структура;
	
	ЗарплатаКадрыКлиент.ДинамическийСписокПередНачаломДобавления(ЭтотОбъект, ПараметрыОткрытия, Параметр, "Сотрудник", "");
	
	Если ЗначениеЗаполнено(ДатаСобытия) Тогда
		
		Если Параметр = Тип("ДокументСсылка.ИсполнительныйЛист") Тогда
			ПараметрыОткрытия.ЗначенияЗаполнения.Вставить("ДатаДействия", ДатаСобытия);
		ИначеЕсли Параметр = Тип("ДокументСсылка.ПостоянноеУдержаниеВПользуТретьихЛиц") Тогда
			ПараметрыОткрытия.ЗначенияЗаполнения.Вставить("ДатаНачала", ДатаСобытия);
		ИначеЕсли Параметр = Тип("ДокументСсылка.УдержаниеПрофсоюзныхВзносов") Тогда
			ПараметрыОткрытия.ЗначенияЗаполнения.Вставить("ДатаНачала", ДатаСобытия);
		ИначеЕсли Параметр = Тип("ДокументСсылка.ИзменениеУсловийИсполнительногоЛиста") Тогда
			ПараметрыОткрытия.ЗначенияЗаполнения.Вставить("ДатаИзменения", ДатаСобытия);
		ИначеЕсли Параметр = Тип("ДокументСсылка.УдержаниеДобровольныхСтраховыхВзносов") Тогда
			ПараметрыОткрытия.ЗначенияЗаполнения.Вставить("ДатаНачала", ДатаСобытия);
		ИначеЕсли Параметр = Тип("ДокументСсылка.УдержаниеДобровольныхВзносовВНПФ") Тогда
			ПараметрыОткрытия.ЗначенияЗаполнения.Вставить("ДатаНачала", ДатаСобытия);
		ИначеЕсли Параметр = Тип("ДокументСсылка.УдержаниеВСчетРасчетовПоПрочимОперациям") Тогда
			ПараметрыОткрытия.ЗначенияЗаполнения.Вставить("ДатаНачала", ДатаСобытия);
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Организация) Тогда
			ПараметрыОткрытия.ЗначенияЗаполнения.Вставить("Организация", Организация);
		КонецЕсли;
		
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ЗначенияЗаполнения", ПараметрыОткрытия.ЗначенияЗаполнения);
	
	Отказ = Истина;
	ОткрытьФорму(ПараметрыОткрытия.ОписаниеФормы, ПараметрыФормы);
	
КонецПроцедуры

&НаСервере
Процедура СписокПередЗагрузкойПользовательскихНастроекНаСервере(Элемент, Настройки)
	ЗарплатаКадры.ПроверитьПользовательскиеНастройкиДинамическогоСписка(ЭтотОбъект, Настройки);
КонецПроцедуры

&НаСервере
Процедура СписокПриОбновленииСоставаПользовательскихНастроекНаСервере(СтандартнаяОбработка)
	
	ЗарплатаКадры.ПроверитьПользовательскиеНастройкиДинамическогоСписка(ЭтотОбъект, , СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

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

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура НастроитьДинамическийСписокНаСервере(ОписаниеМодификации) Экспорт
	ЗарплатаКадрыРасширенный.НастроитьДинамическийСписокПоОписаниюМодификации(ЭтаФорма, ОписаниеМодификации);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПараметрМодификацииВыбор(Элемент, ИмяПараметра, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ЗарплатаКадрыРасширенныйКлиент.ПараметрМодификацииОбработкаНавигационнойСсылки(
		ЭтотОбъект, Элемент.Родитель.Имя, ИмяПараметра);
	
КонецПроцедуры

#КонецОбласти
