#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого Строка Из ЭтотОбъект Цикл
		Если ЗначениеЗаполнено(Строка.СрокДействияСправки) Тогда
			Строка.ДействуетДо = КонецДня(Строка.СрокДействияСправки) + 1;
		Иначе
			Строка.ДействуетДо = ""
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.';
						|en = 'Invalid object call on the client.'");
#КонецЕсли