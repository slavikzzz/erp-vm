
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.КоманднаяПанель = Элементы.ФормаКоманднаяПанель;
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	УстановитьУсловноеОформление();
	УстановитьОтображениеСписка(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
		
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

КонецПроцедуры

&НаСервереБезКонтекста
Процедура СписокПриПолученииДанныхНаСервере(ИмяЭлемента, Настройки, Строки)
	
	ТекущаяВерсияDTO = Неопределено;
	Для Каждого Строка Из Строки Цикл
		Если Строка.Значение.Данные.Предопределенный Тогда
			Если ТекущаяВерсияDTO = Неопределено Тогда
				ТекущаяВерсияDTO = Справочники.ШаблоныДокументов.ПорядокВерсии(
					Справочники.ШаблоныДокументов.ТекущаяВерсияШаблонов());
			КонецЕсли;
			ТекущаяВерсия = Справочники.ШаблоныДокументов.ПорядокВерсии(Строка.Значение.Данные.Версия);
			ВерсииШаблона = Справочники.ШаблоныДокументов.ПредопределенныеВерсииШаблонов(Строка.Значение.Данные.ИмяПредопределенныхДанных);
			Для Каждого СтрокаВерсии Из ВерсииШаблона Цикл
				Если ТекущаяВерсия < СтрокаВерсии.ПорядокВерсий
					И СтрокаВерсии.ПорядокВерсий <= ТекущаяВерсияDTO Тогда
					
					Строка.Значение.Данные.НоваяВерсия = Истина;
					Прервать;
				Иначе
					Прервать;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПоказыватьШаблоныВАрхиве(Команда)
	
	Элементы.ФормаПоказыватьШаблоныВАрхиве.Пометка =
		Не Элементы.ФормаПоказыватьШаблоныВАрхиве.Пометка;
	
	УстановитьОтображениеСписка(ЭтотОбъект);
	
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

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтображениеСписка(УправляемаяФорма)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		УправляемаяФорма.Список, "ВАрхиве", Ложь, ВидСравненияКомпоновкиДанных.Равно, , Не УправляемаяФорма.Элементы.ФормаПоказыватьШаблоныВАрхиве.Пометка);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	ТекущийШрифт = Элементы.Список.Шрифт;
	ЗачеркнутыйШрифт = Новый Шрифт(ТекущийШрифт,,,,,,Истина,);
	
	ЭлементОформления = УсловноеОформление.Элементы.Добавить();
	ЭлементОформления.Представление = НСтр("ru = 'Зачеркивать не используемые шаблоны.';
											|en = 'Cross out unused templates.'");
	
	ОтборЭлемента = ЭлементОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.ВАрхиве");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("Шрифт",ЗачеркнутыйШрифт);
	
	ОформляемоеПоле = ЭлементОформления.Поля.Элементы.Добавить(); 
	ОформляемоеПоле.Поле = Новый ПолеКомпоновкиДанных("Список");
	
КонецПроцедуры

#КонецОбласти
