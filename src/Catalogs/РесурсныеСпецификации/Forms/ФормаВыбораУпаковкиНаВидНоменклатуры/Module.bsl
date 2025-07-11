
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Параметры.Свойство("УпаковкаЕдиницаИзмерения", УпаковкаЕдиницаИзмерения);
	
	ЗаполнитьДеревоУпаковок();
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыУпаковкиЕдиницыИзмерения

&НаКлиенте
Процедура УпаковкиЕдиницыИзмеренияВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ПроверитьЗавершитьВыбор(ВыбраннаяСтрока);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выбрать(Команда)
	
	ПроверитьЗавершитьВыбор(Элементы.УпаковкиЕдиницыИзмерения.ТекущаяСтрока);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьДеревоУпаковок()
	
	УпаковкиЕдиницыИзмерения.ПолучитьЭлементы().Очистить();
	
	Запрос = Новый Запрос;
	Запрос.Текст = Справочники.РесурсныеСпецификации.ТекстЗапросаДоступныеУпаковкиСпецификацииНаВидНоменклатуры();
	Запрос.УстановитьПараметр("ИспользоватьУпаковкиНоменклатуры", ПолучитьФункциональнуюОпцию("ИспользоватьУпаковкиНоменклатуры"));
	
	РезультатыЗапроса = Запрос.ВыполнитьПакет();
	
	// Единицы измерения
	Если НЕ РезультатыЗапроса[0].Пустой() Тогда
		
		СтрокаЕдиницыИзмерения = УпаковкиЕдиницыИзмерения.ПолучитьЭлементы().Добавить();
		СтрокаЕдиницыИзмерения.Ссылка = НСтр("ru = 'Единицы измерения';
											|en = 'Units of measure'");
		
		ВыборкаЕдиницыИзмерения = РезультатыЗапроса[0].Выбрать();
		Пока ВыборкаЕдиницыИзмерения.Следующий() Цикл
			НоваяСтрока = СтрокаЕдиницыИзмерения.ПолучитьЭлементы().Добавить();
			НоваяСтрока.Ссылка = ВыборкаЕдиницыИзмерения.Ссылка;
			УстановитьТекущуюСтрокуДерева(НоваяСтрока);
		КонецЦикла;
	
	КонецЕсли;
	
	// Упаковки
	Если НЕ РезультатыЗапроса[1].Пустой() Тогда
	
		СтрокаУпаковки = УпаковкиЕдиницыИзмерения.ПолучитьЭлементы().Добавить();
		СтрокаУпаковки.Ссылка = НСтр("ru = 'Упаковки';
									|en = 'Packaging units'");
		
		НаборыУпаковок = Новый Соответствие;
		ВыборкаУпаковки = РезультатыЗапроса[1].Выбрать(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);
		Пока ВыборкаУпаковки.Следующий() Цикл
			
			НаборУпаковок = НаборыУпаковок.Получить(ВыборкаУпаковки.НаборУпаковок);
			Если НаборУпаковок = Неопределено Тогда
				НаборУпаковок = СтрокаУпаковки.ПолучитьЭлементы().Добавить();
				НаборУпаковок.Ссылка = ВыборкаУпаковки.НаборУпаковок;
				НаборыУпаковок.Вставить(ВыборкаУпаковки.НаборУпаковок, НаборУпаковок);
			КонецЕсли;
			ДобавитьЗаписьВДеревоУпаковок(НаборУпаковок, ВыборкаУпаковки);
			
		КонецЦикла;
	
	КонецЕсли;
	
КонецПроцедуры

// Добавляет запись в дерево упаковок
// 
// Параметры:
// 	СтрокаРодитель - ДанныеФормыЭлементДерева - строка родитель:
// 	Выборка - ВыборкаИзРезультатаЗапроса - выборка:
//
&НаСервере
Процедура ДобавитьЗаписьВДеревоУпаковок(СтрокаРодитель, Выборка)
	
	НоваяСтрока = СтрокаРодитель.ПолучитьЭлементы().Добавить();
	
	ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
	
	УстановитьТекущуюСтрокуДерева(НоваяСтрока);
	
	ВыборкаВложенная = Выборка.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);
	Пока ВыборкаВложенная.Следующий() Цикл
		ДобавитьЗаписьВДеревоУпаковок(НоваяСтрока, ВыборкаВложенная);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьТекущуюСтрокуДерева(НоваяСтрока)
	
	Если УпаковкаЕдиницаИзмерения.Пустая() Тогда
		Возврат;
	КонецЕсли;
	
	Если НоваяСтрока.Ссылка = УпаковкаЕдиницаИзмерения Тогда
		Элементы.УпаковкиЕдиницыИзмерения.ТекущаяСтрока = НоваяСтрока.ПолучитьИдентификатор();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьЗавершитьВыбор(ВыбраннаяСтрока)
	
	ТекущиеДанные = УпаковкиЕдиницыИзмерения.НайтиПоИдентификатору(ВыбраннаяСтрока);
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(ТекущиеДанные.Ссылка) = Тип("Строка")
		ИЛИ ТипЗнч(ТекущиеДанные.Ссылка) = Тип("СправочникСсылка.НаборыУпаковок") Тогда
		Возврат;
	КонецЕсли;
	
	Закрыть(ТекущиеДанные.Ссылка);
	
КонецПроцедуры

#КонецОбласти