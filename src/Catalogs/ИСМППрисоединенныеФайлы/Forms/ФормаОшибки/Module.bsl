
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Документ = Параметры.Документ;
	
	ОписаниеОшибки = Справочники.ИСМППрисоединенныеФайлы.ТекстОшибкиИзПротокола(Параметры.Документ);
	
	Если ЗначениеЗаполнено(Параметры.ОписаниеОшибки) Тогда
		Если ЗначениеЗаполнено(ОписаниеОшибки) Тогда
			ОписаниеОшибки = ОписаниеОшибки + Символы.ПС;
		КонецЕсли;
		ОписаниеОшибки = ОписаниеОшибки + Параметры.ОписаниеОшибки;
	КонецЕсли;
	
	ЗаполнитьРекомендацииПользователю(ОписаниеОшибки);
	
	ОбщегоНазначенияСобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьРекомендацииПользователю(ТекстОшибки)
	
	НеУказанаСертификация = Нстр("ru = '01: Не заполнено поле ""Вид документа, подтверждающего соответствие';
								|en = '01: Не заполнено поле ""Вид документа, подтверждающего соответствие'");
	Если СтрНайти(ТекстОшибки, НеУказанаСертификация) > 0 Тогда
		
		Элементы.ОписаниеОшибки.РасширеннаяПодсказка.Заголовок = Нстр("ru = 'Рекомендация:
			|Если в документе установлен флаг ""Отчет производственной линии"", заполните поле ""Сертификация"" на закладке Основное.
			|Если флаг ""Отчет производственной линии"" не установлен, то заполните поле ""Сертификация"" в строке табличной части Товары.';
			|en = 'Рекомендация:
			|Если в документе установлен флаг ""Отчет производственной линии"", заполните поле ""Сертификация"" на закладке Основное.
			|Если флаг ""Отчет производственной линии"" не установлен, то заполните поле ""Сертификация"" в строке табличной части Товары.'");
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти