#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	ЗарплатаКадрыОтчеты.ПриКомпоновкеРезультатаВТабличныйДокумент(
		ЭтотОбъект, ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка, Ложь, Отчеты.ДокументыКЭДОСОтказами.ВнешниеНаборыДанных());
	
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

Процедура ИнициализироватьОтчет(КлючВарианта = Неопределено) Экспорт
	
	НаборДанныеДокументовКЭДО = СхемаКомпоновкиДанных.НаборыДанных.Найти("ДанныеДокументовКЭДО");
	Если НаборДанныеДокументовКЭДО <> Неопределено Тогда
		ПолеВидОснования = НаборДанныеДокументовКЭДО.Поля.Найти("СсылкаНаОбъект.ВидОснования");
		Если ПолеВидОснования <> Неопределено Тогда
			СписокВыбора = Новый СписокЗначений;
			Для Каждого ТипСПечатнымиФормами Из Метаданные.ОпределяемыеТипы.ОбъектСПечатнымиФормами.Тип.Типы() Цикл
				Если ТипСПечатнымиФормами = Тип("ДокументСсылка.ДокументКадровогоЭДО") Тогда
					СписокВыбора.Добавить(ТипСПечатнымиФормами, НСтр("ru = 'Внешний документ';
																	|en = 'Внешний документ'"));
				Иначе
					СписокВыбора.Добавить(ТипСПечатнымиФормами, Строка(ТипСПечатнымиФормами));
				КонецЕсли;
			КонецЦикла;
			СписокВыбора.СортироватьПоПредставлению();
			ПолеВидОснования.УстановитьДоступныеЗначения(СписокВыбора);
		КонецЕсли;
	КонецЕсли;
	
	
КонецПроцедуры

// Для общей формы "Форма отчета" подсистемы "Варианты отчетов".
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	
	Настройки.События.ПередЗагрузкойНастроекВКомпоновщик = Истина;
	
КонецПроцедуры

// Вызывается перед загрузкой новых настроек. Используется для изменения схемы компоновки.
//
Процедура ПередЗагрузкойНастроекВКомпоновщик(Контекст, КлючСхемы, КлючВарианта, НовыеНастройкиКД, НовыеПользовательскиеНастройкиКД) Экспорт
	
	Если КлючСхемы <> "СхемаИнициализирована" Тогда
		
		ИнициализироватьОтчет();
		ОтчетыСервер.ПодключитьСхему(ЭтотОбъект, Контекст, СхемаКомпоновкиДанных, КлючСхемы);
		
		КлючСхемы = "СхемаИнициализирована";
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.';
						|en = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли