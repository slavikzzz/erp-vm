
#Область ПрограммныйИнтерфейс

// Задает настройки размещения вариантов отчетов в панели отчетов.
//
// Параметры:
//  Настройки - Коллекция - настройки отчетов и вариантов отчетов конфигурации.
//
Процедура НастроитьВариантыОтчетов(Настройки) Экспорт
	
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ДвиженияМеждуРегистрамиЕГАИС);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ДвиженияПоСправке2ЕГАИС);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ИнформацияОбОрганизацииЕГАИС);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.НеобработанныеТТНЕГАИС);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ОбработанныеЧекиЕГАИС);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ОстаткиАлкогольнойПродукцииЕГАИС);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.СводныйОтчетЕГАИС);
	
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.АнализРасхожденийПриДвиженииАлкогольнойПродукции);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.АнализРасхожденийПриПоступленииАлкогольнойПродукции);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.АнализРасхожденийПриОтгрузкеАлкогольнойПродукции);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает Истина в случае наличия расхождений между полученными данными и данными ИБ. Ложь - в противном случае.
// 
// Параметры:
//  ДокументСсылка - ДокументСсылка.ОтчетЕГАИС - отчет, для которого нужно проверить наличие расхождений.
//  ИмяОтчета - Строка - Имя отчета
// 
// Возвращаемое значение:
//  Булево - признак наличия расхождений.
//  
Функция ЕстьРасхожденияВПолученныхДанных(ДокументСсылка, ИмяОтчета) Экспорт
	
	Отчет = Отчеты[ИмяОтчета].Создать();
	
	НастройкиОтчета = Отчет.КомпоновщикНастроек.ПолучитьНастройки();
	НастройкиОтчета.ПараметрыДанных.УстановитьЗначениеПараметра("ОтчетЕГАИС", ДокументСсылка);
	
	Если ЗначениеПараметраКомпоновкиДанных(НастройкиОтчета, "ТолькоОтклонения") <> Неопределено Тогда
		НастройкиОтчета.ПараметрыДанных.УстановитьЗначениеПараметра("ТолькоОтклонения", Истина);
	КонецЕсли;
	
	НастройкиОтчета.ДополнительныеСвойства.Вставить("ИмяОтчета", ИмяОтчета);
	
	ВнешниеНаборыДанных = Неопределено;
	ПриКомпоновкеРезультата(НастройкиОтчета, ВнешниеНаборыДанных);
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	
	ДанныеРасшифровки = Неопределено;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(Отчет.СхемаКомпоновкиДанных, НастройкиОтчета, ДанныеРасшифровки,, Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	
	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновки, ВнешниеНаборыДанных, ДанныеРасшифровки, Истина);
	
	ПроцессорВыводаВТабличныйДокумент = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	ТаблицаОтчета = ПроцессорВыводаВТабличныйДокумент.Вывести(ПроцессорКомпоновкиДанных);
	
	Возврат ТаблицаОтчета.Количество() <> 0;
	
КонецФункции

// Возвращает таблицу расхождений между полученными данными и данными ИБ.
// 
// Параметры:
//  ДокументСсылка - ДокументСсылка.ОтчетЕГАИС - отчет, для которого нужно проверить наличие расхождений.
//  ИмяОтчета - Строка - Имя отчета
// 
// Возвращаемое значение:
//  Булево - признак наличия расхождений.
//  
Функция РасхожденияВПолученныхДанных(ДокументСсылка, ИмяОтчета) Экспорт
	
	Отчет = Отчеты[ИмяОтчета].Создать();
	
	КомпоновщикНастроек = Отчет.КомпоновщикНастроек;
	КомпоновщикНастроек.ЗагрузитьНастройки(Отчет.СхемаКомпоновкиДанных.ВариантыНастроек[Отчет.ИндексВариантаРасхождений()].Настройки);
	НастройкиОтчета = КомпоновщикНастроек.ПолучитьНастройки();
	НастройкиОтчета.ПараметрыДанных.УстановитьЗначениеПараметра("ОтчетЕГАИС", ДокументСсылка);
	
	Если ЗначениеПараметраКомпоновкиДанных(НастройкиОтчета, "ТолькоОтклонения") <> Неопределено Тогда
		НастройкиОтчета.ПараметрыДанных.УстановитьЗначениеПараметра("ТолькоОтклонения", Истина);
	КонецЕсли;
	
	НастройкиОтчета.ДополнительныеСвойства.Вставить("ИмяОтчета", ИмяОтчета);
	
	ВнешниеНаборыДанных = Неопределено;
	ПриКомпоновкеРезультата(НастройкиОтчета, ВнешниеНаборыДанных);
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	
	ДанныеРасшифровки = Неопределено;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(Отчет.СхемаКомпоновкиДанных, НастройкиОтчета, ДанныеРасшифровки,, Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	
	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновки, ВнешниеНаборыДанных, ДанныеРасшифровки, Истина);
	
	ПроцессорВыводаВТабличныйДокумент = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	ТаблицаОтчета = ПроцессорВыводаВТабличныйДокумент.Вывести(ПроцессорКомпоновкиДанных);
	
	Возврат ТаблицаОтчета;
	
КонецФункции

// Возвращает значение параметра компоновки данных.
// 
// Параметры:
//  НастройкиОтчета - НастройкиКомпоновкиДанных - формируемые настройки отчета,
//  ИмяПараметра - Строка - имя параметра, значение которого требуется получить.
// 
// Возвращаемое значение:
//  Неопределено, Произвольный - Значение параметра компоновки данных
//  
Функция ЗначениеПараметраКомпоновкиДанных(НастройкиОтчета, ИмяПараметра) Экспорт
	
	Параметр = НастройкиОтчета.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных(ИмяПараметра));
	
	Если Параметр <> Неопределено Тогда
		Возврат Параметр.Значение;
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

// Вызывается при выполнении отчета с помощью метода СкомпоноватьРезультат.
// 
// Параметры:
//  НастройкиОтчета - НастройкиКомпоновкиДанных - Настройки отчета
//  ВнешниеНаборыДанных - Неопределено - Внешние наборы данных
Процедура ПриКомпоновкеРезультата(НастройкиОтчета, ВнешниеНаборыДанных = Неопределено) Экспорт
	
	Перем ИмяОтчета, ДанныеИнформационнойБазы;
	
	Если НЕ НастройкиОтчета.ДополнительныеСвойства.Свойство("ИмяОтчета", ИмяОтчета) Тогда
		Возврат;
	КонецЕсли;
	
	СписокОтчетов    = ЗначениеПараметраКомпоновкиДанных(НастройкиОтчета, "ОтчетЕГАИС");
	ТолькоОтклонения = ?(ЗначениеПараметраКомпоновкиДанных(НастройкиОтчета, "ТолькоОтклонения") = Истина, Истина, Ложь);
	
	Если ИмяОтчета = Метаданные.Отчеты.ИнформацияОбОрганизацииЕГАИС.Имя Тогда
		ДанныеИнформационнойБазы = Отчеты.ИнформацияОбОрганизацииЕГАИС.ДанныеИнформационнойБазы(СписокОтчетов);
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
			НастройкиОтчета.Отбор,
			"ДополнительныйОтборОтклонения",
			Истина,
			ВидСравненияКомпоновкиДанных.Равно,
			?(ТолькоОтклонения, НСтр("ru = 'Реквизиты, с отличающимися значениями в информационной базе и в ЕГАИС';
									|en = 'Реквизиты, с отличающимися значениями в информационной базе и в ЕГАИС'"), НСтр("ru = 'Все реквизиты';
																														|en = 'Все реквизиты'")));
	КонецЕсли;
	
	Если ИмяОтчета = Метаданные.Отчеты.НеобработанныеТТНЕГАИС.Имя Тогда
		НастройкиОтчета.ПараметрыДанных.УстановитьЗначениеПараметра("ВсеТребующиеДействия", Документы.ТТНВходящаяЕГАИС.ВсеТребующиеДействия());
	КонецЕсли;
	
	Если ИмяОтчета = Метаданные.Отчеты.ОбработанныеЧекиЕГАИС.Имя Тогда
		ДанныеИнформационнойБазы = Отчеты.ОбработанныеЧекиЕГАИС.ДанныеИнформационнойБазы(СписокОтчетов);
		
		Если ТолькоОтклонения Тогда
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
				НастройкиОтчета.Отбор,
				"Отклонение",
				0,
				ВидСравненияКомпоновкиДанных.НеРавно,
				НСтр("ru = 'Только отклонения между данными информационной базы и ЕГАИС';
					|en = 'Только отклонения между данными информационной базы и ЕГАИС'"));
		КонецЕсли;
	КонецЕсли;
	
	Если ИмяОтчета = Метаданные.Отчеты.ОстаткиАлкогольнойПродукцииЕГАИС.Имя Тогда
		ДанныеИнформационнойБазы = Отчеты.ОстаткиАлкогольнойПродукцииЕГАИС.ДанныеИнформационнойБазы(СписокОтчетов);
		
		Если ТолькоОтклонения Тогда
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
				НастройкиОтчета.Отбор,
				"Отклонение",
				0,
				ВидСравненияКомпоновкиДанных.НеРавно,
				НСтр("ru = 'Только отклонения между данными информационной базы и ЕГАИС';
					|en = 'Только отклонения между данными информационной базы и ЕГАИС'"));
		КонецЕсли;
	КонецЕсли;
	
	Если ДанныеИнформационнойБазы <> Неопределено Тогда
		ВнешниеНаборыДанных = Новый Структура;
		ВнешниеНаборыДанных.Вставить("ДанныеИнформационнойБазы" + ИмяОтчета, ДанныеИнформационнойБазы);
	КонецЕсли;
	
КонецПроцедуры

//Переопределяемая область данных прикладных документов отчетов о расхождениях при оформлении
//
//Возвращаемое значение:
//   Строка - типовая часть запроса, которую требуется переопределять
//
Функция ШаблонПолученияКоличестваЕГАИСИзНоменклатуры() Экспорт
	
	Возврат
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	&ПустаяНоменклатура КАК Номенклатура,
	|	&ПустаяХарактеристика КАК Характеристика,
	|	1 КАК ОбъемДАЛ
	|ПОМЕСТИТЬ НоменклатураПереопределяемый
	|;
	|
	|";
	
КонецФункции

#КонецОбласти