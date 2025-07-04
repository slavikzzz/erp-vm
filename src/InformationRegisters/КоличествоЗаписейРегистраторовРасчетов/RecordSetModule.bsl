#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	МетаданныеРегистра = Метаданные();
	ИзмеренияРегистра = МетаданныеРегистра.Измерения;
	
	Для каждого Запись Из ЭтотОбъект Цикл
		
		Для Каждого Измерение Из ИзмеренияРегистра Цикл
			
			Если Не ЗначениеЗаполнено(Запись[Измерение.Имя]) И Измерение.ЗапрещатьНезаполненныеЗначения Тогда
				
				ТекстИсключения = НСтр("ru = 'Не заполнено значение поля ""%1""';
										|en = 'Не заполнено значение поля ""%1""'");
				ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстИсключения,
					Измерение.Представление());
					
			КонецЕсли;
			
		КонецЦикла;
		
		Если Не ЗначениеЗаполнено(Запись.КоличествоЗаписей) Тогда
			ТекстИсключения = НСтр("ru = 'Не заполнено значение поля ""%1""';
									|en = 'Не заполнено значение поля ""%1""'");
			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстИсключения,
				МетаданныеРегистра.Ресурсы.КоличествоЗаписей.Представление());
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли