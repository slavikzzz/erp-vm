#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КодВЭДНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ОткрытьФормуСпискаЗначенийСтроковогоРеквизита(Элемент, 
		СтандартнаяОбработка, "КодВЭДПеречняДолжностейДляБронированияГраждан", НСтр("ru = 'Код ВЭД';
																					|en = 'Foreign economic activity code'"), НСтр("ru = 'Код ВЭД';
																											|en = 'Foreign economic activity code'"));
	
КонецПроцедуры

&НаКлиенте
Процедура КодВЭДОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Строка") Тогда
		Объект.КодВЭД = ВыбранноеЗначение;
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура КодВЭДАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ПодборЗначенияСтроковогоРеквизита(Текст, ДанныеВыбора, СтандартнаяОбработка, "КодВЭДПеречняДолжностейДляБронированияГраждан");
	
КонецПроцедуры

&НаКлиенте
Процедура КодДолжностиНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ОткрытьФормуСпискаЗначенийСтроковогоРеквизита(Элемент, 
		СтандартнаяОбработка, "КодДолжностиПеречняДолжностейДляБронированияГраждан", НСтр("ru = 'Код должности';
																							|en = 'Job title code'"), НСтр("ru = 'Код должности';
																														|en = 'Job title code'"));
	
КонецПроцедуры

&НаКлиенте
Процедура КодДолжностиОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Строка") Тогда
		Объект.КодДолжности = ВыбранноеЗначение;
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура КодДолжностиАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ПодборЗначенияСтроковогоРеквизита(Текст, ДанныеВыбора, СтандартнаяОбработка, "КодДолжностиПеречняДолжностейДляБронированияГраждан");
	
КонецПроцедуры

#КонецОбласти
