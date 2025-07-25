#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ВидБюджета = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "ВидБюджета").Значение;
	Если Не ЗначениеЗаполнено(ВидБюджета) Тогда
		ВызватьИсключение НСтр("ru = 'Отчет предназначен для использования из вида бюджета.';
								|en = 'You can use the report from the budget profile.'");
	КонецЕсли;
	
	РежимФормирования = Перечисления.РежимыФормированияБюджетныхОтчетов.Документ;
	
	СтруктураКолонокБюджета = БюджетнаяОтчетностьРасчетКэшаСервер.КолонкиТаблицыДанных(ВидБюджета);
	СтруктураОписанияОтчета = БюджетнаяОтчетностьРасчетКэшаСервер.ОписаниеОтчета(ВидБюджета,
	                                                                             СтруктураКолонокБюджета,
	                                                                             РежимФормирования);
	ТаблицаЭлементов = БюджетнаяОтчетностьРасчетКэшаСервер.ТаблицаОперандовТребующихРасчетаДанныхЯчеек(СтруктураОписанияОтчета);
	ТаблицаЭлементов = ТаблицаЭлементов.Выгрузить();
	ТаблицаЭлементов.Колонки.Добавить("НетПроблем");
	ТаблицаЭлементов.ЗаполнитьЗначения(Ложь, "НетПроблем");
	Если Не ТаблицаЭлементов.Количество() Тогда
		ТаблицаЭлементов.Добавить().НетПроблем = Истина;
	КонецЕсли;
	
	ВнешниеНаборы = Новый Структура("ТаблицаЭлементов", ТаблицаЭлементов);
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, КомпоновщикНастроек.Настройки, ДанныеРасшифровки);
	
	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновки, ВнешниеНаборы, , Истина);
	
	ПроцессорВыводаВТабличныйДокумент = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВыводаВТабличныйДокумент.УстановитьДокумент(ДокументРезультат);
	ПроцессорВыводаВТабличныйДокумент.Вывести(ПроцессорКомпоновкиДанных);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
