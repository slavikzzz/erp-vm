
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Параметры.Свойство("Организация", Организация);
	Параметры.Свойство("ВладелецЭЦПИНН", ВладелецЭЦПИНН);
	Параметры.Свойство("ВладелецЭЦПФИО", ВладелецЭЦПФИО);
	Параметры.Свойство("ВладелецЭЦПСНИЛС", ВладелецЭЦПСНИЛС);
	
	УправлениеФормой(Параметры);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УправлениеФормой(Параметры)
	
	ИзменитьОформлениеИНН(Параметры);
	ИзменитьОформлениеРеквизитовВладельца();
	
	ИзменитьОформлениеПояснения();
	ИзменитьОформлениеСсылкиВсеСертификаты();
	
КонецПроцедуры

&НаСервере
Процедура ИзменитьОформлениеСсылкиВсеСертификаты()
	
	Элементы.ВсеСертификаты.Заголовок = ОбработкаЗаявленийАбонентаКлиентСервер.СсылкаНаВсеСертификаты();
	
КонецПроцедуры

&НаСервере
Процедура ИзменитьОформлениеПояснения()
	
	СсылкаНаОрганизацию = ОбработкаЗаявленийАбонентаКлиентСервер.СсылкаНаОрганизацию(Организация);
	
	НетДанных = 
		НЕ Элементы.ВладелецЭЦПСНИЛС.Видимость
		И НЕ Элементы.ИНН.Видимость
		И НЕ Элементы.ВладелецЭЦПИНН.Видимость
		И НЕ Элементы.ВладелецЭЦПФИО.Видимость;
		
	Если НетДанных Тогда
		Элементы.Пояснение.Заголовок = НСтр("ru = 'Не найдено ни одного сертификата.';
											|en = 'Не найдено ни одного сертификата.'");
	Иначе
		Элементы.Пояснение.Заголовок = Новый ФорматированнаяСтрока(
			НСтр("ru = 'Не найдено ни одного сертификата организации ';
				|en = 'Не найдено ни одного сертификата организации '"),
			СсылкаНаОрганизацию,
			НСтр("ru = ' по данным:';
				|en = ' по данным:'"));
	КонецЕсли;
		
	Элементы.ПодсказкаMacOS.Видимость = ОбщегоНазначения.ЭтоMacOSКлиент();
	
КонецПроцедуры

&НаСервере
Процедура ИзменитьОформлениеСНИЛС()
	
	ВладелецЭЦПСНИЛС = ОбработкаЗаявленийАбонентаКлиентСервер.СНИЛСБезРазделителей(ВладелецЭЦПСНИЛС);
	Элементы.ВладелецЭЦПСНИЛС.Видимость = ЗначениеЗаполнено(ВладелецЭЦПСНИЛС);
	
КонецПроцедуры

&НаСервере
Процедура ИзменитьОформлениеИНН(Параметры)
	
	ЕстьИНН = Параметры.Свойство("ИНН", ИНН) И ЗначениеЗаполнено(ИНН);
	Элементы.ИНН.Видимость = ЕстьИНН;
	
КонецПроцедуры

&НаСервере
Процедура ИзменитьОформлениеРеквизитовВладельца()
	
	ИзменитьОформлениеСНИЛС();

	Элементы.ВладелецЭЦПИНН.Видимость = ЗначениеЗаполнено(СокрЛП(ВладелецЭЦПИНН));
	Элементы.ВладелецЭЦПФИО.Видимость = ЗначениеЗаполнено(СокрЛП(ВладелецЭЦПФИО));
	
КонецПроцедуры


#КонецОбласти