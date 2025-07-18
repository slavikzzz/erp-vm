

#Область ОбработчикиСобытийФормы


#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Загрузить(Команда)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Выберите строку';
										|en = 'Выберите строку'"));
		Возврат; 
	КонецЕсли;
	
	ДанныеСтроки = Новый Структура("Запрос, ИмяФайла, ТипСодержимого");
	ЗаполнитьЗначенияСвойств(ДанныеСтроки, ТекущиеДанные);
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"КомандаЗагрузить_ПослеВыбораФайла", 
		ЭтотОбъект, 
		ДанныеСтроки);
		
	ОперацииСФайламиЭДКОКлиент.ДобавитьФайлы(ОписаниеОповещения, УникальныйИдентификатор);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура КомандаЗагрузить_ПослеВыбораФайла(Результат, ДанныеСтроки) Экспорт
	
	Если НЕ Результат.Выполнено	Тогда
		Возврат;
	КонецЕсли;
	
	ОписанияФайлов = Результат.ОписанияФайлов;
	
	Для каждого ОписаниеФайла Из ОписанияФайлов Цикл
		ЗагрузитьФайлыНаСервере(ОписаниеФайла.Адрес, ДанныеСтроки);
	КонецЦикла; 
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ЗагрузитьФайлыНаСервере(Адрес, ДанныеСтроки)
	
	ДвДанные = ПолучитьИзВременногоХранилища(Адрес);
		
	КонтекстЭДОСервер = ДокументооборотСКО.ПолучитьОбработкуЭДО();
	КонтекстЭДОСервер.ДобавитьОтветНаЗапросИОН(
		ДанныеСтроки.Запрос, 
		ДанныеСтроки.ИмяФайла, 
		ДвДанные,
		ДвДанные.Размер(),
		ДанныеСтроки.ТипСодержимого);

	ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'Готово';
												|en = 'Готово'")); 
	
КонецПроцедуры

#КонецОбласти


