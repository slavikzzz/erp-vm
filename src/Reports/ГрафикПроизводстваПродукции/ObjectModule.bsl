//++ Устарело_Производство21
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	// Строковые литералы
	КомпоновкаДанныхКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "ЕдиницаИзмеренияЭтапа", НСтр("ru = 'единиц/партий';
																										|en = 'units/batches'"));
	КомпоновкаДанныхКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "ОбозначениеЭтап", НСтр("ru = 'Этап';
																								|en = 'Stage'"));
	КомпоновкаДанныхКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "ОбозначениеПродукция", НСтр("ru = 'Продукция';
																										|en = 'Products'"));
	КомпоновкаДанныхКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "ОбозначениеПолуфабрикат", НСтр("ru = 'Полуфабрикат';
																										|en = 'Semi-finished product'"));
	КомпоновкаДанныхКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "ОбозначениеПобочнаяПродукция", НСтр("ru = 'Побочная продукция';
																												|en = 'Side products'"));
	КомпоновкаДанныхКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "Итого", НСтр("ru = 'Итого';
																						|en = 'Total'"));
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
//-- Устарело_Производство21