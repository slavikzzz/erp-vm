
#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПродолжитьВыполнение(Команда)
	
	ЭтаФорма.Закрыть(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ТекстПредупрежденияОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
//++ Устарело_Производство21

//++ НЕ УТКА
	Если НавигационнаяСсылкаФорматированнойСтроки = "#ПереходНаУправлениеПроизводствомВерсии22" Тогда
		
		ОткрытьФорму("Обработка.ПереходНаУправлениеПроизводствомВерсии22.Форма.Форма");
		
	КонецЕсли;
//-- НЕ УТКА

//-- Устарело_Производство21
	
	ЭтаФорма.Закрыть(Ложь);
	
КонецПроцедуры

#КонецОбласти
