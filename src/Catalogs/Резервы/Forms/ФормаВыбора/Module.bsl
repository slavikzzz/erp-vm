
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если КлючНазначенияИспользования = "РезервыПоОплатеТруда" Тогда
		Заголовок = НСтр("ru = 'Оценочные обязательства и резервы на оплату труда';
						|en = 'Provisions and payroll funds'");
		АвтоЗаголовок = Ложь;
	КонецЕсли;
	
	СобытияФорм.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти
