
#Область ИнформационнаяСтрока

Процедура ИнформационнаяСтрокаОбработкаНавигационнойСсылки(ЗаказНаПроизводство, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка) Экспорт

	СтандартнаяОбработка = Ложь;

	Если НавигационнаяСсылкаФорматированнойСтроки = "ОткрытьПросроченноеОбеспечение" Тогда
		
		ОткрытьФорму("Отчет.РасшифровкаПросроченныхПоОбеспечениюПозицииНоменклатурногоПлана.Форма", Новый Структура("СформироватьПриОткрытии,ЗаказНаПроизводство", Истина, ЗаказНаПроизводство));
		
		Возврат;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти