#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Если Количество() > 0 Тогда
		
		Запись = ЭтотОбъект[0];
		
		ТекущаяЗапись = РегистрыСведений.НастройкиСтатистикиПерсонала.СоздатьМенеджерЗаписи();
		ТекущаяЗапись.Организация = Запись.Организация;
		ТекущаяЗапись.Прочитать();
		
		Если Не ЗначениеЗаполнено(ТекущаяЗапись.ИспользоватьОтчетностьМониторингаРаботниковСоциальнойСферы)
			Или ТекущаяЗапись.ИспользоватьОтчетностьМониторингаРаботниковСоциальнойСферы <> Запись.ИспользоватьОтчетностьМониторингаРаботниковСоциальнойСферы Тогда
			
			ДополнительныеСвойства.Вставить("ОбновитьСвойстваДолжностей", Истина);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Если ДополнительныеСвойства.Свойство("ОбновитьСвойстваДолжностей")
		И ДополнительныеСвойства.ОбновитьСвойстваДолжностей Тогда
		
		РегистрыСведений.СтрокиОтчетностиМониторингаРаботниковСоциальнойСферы.ОбновитьПодключаемыеХарактеристики(
			ЭтотОбъект[0].ИспользоватьОтчетностьМониторингаРаботниковСоциальнойСферы);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.';
						|en = 'Invalid object call on the client.'");
#КонецЕсли