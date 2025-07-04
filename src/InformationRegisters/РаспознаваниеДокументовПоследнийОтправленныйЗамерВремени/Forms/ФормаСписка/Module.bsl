#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьРаспознаваниеДокументов") Тогда
		ВызватьИсключение НСтр("ru = 'Функциональная опция ИспользоватьРаспознаваниеДокументов отключена.';
								|en = 'The ИспользоватьРаспознаваниеДокументов functional option is disabled.'");
	КонецЕсли;
	
	ПараметрыОтправки = РегистрыСведений.РаспознаваниеДокументовПоследнийОтправленныйЗамерВремени.ПолучитьПараметры();
	
	ДатаПоследнего = ПараметрыОтправки.ДатаПоследнего;
	НомерСеанса = ПараметрыОтправки.НомерСеанса;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДатаПоследнегоПриИзменении(Элемент)
	
	ПриИзмененииНаСервере(ДатаПоследнего, НомерСеанса);
	
КонецПроцедуры

&НаКлиенте
Процедура НомерСеансаПриИзменении(Элемент)
	
	ПриИзмененииНаСервере(ДатаПоследнего, НомерСеанса);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Процедура ПриИзмененииНаСервере(ДатаПоследнего, НомерСеанса)
	
	РегистрыСведений.РаспознаваниеДокументовПоследнийОтправленныйЗамерВремени.ЗаписатьПараметры(
		ДатаПоследнего,
		НомерСеанса
	);
	
КонецПроцедуры

#КонецОбласти