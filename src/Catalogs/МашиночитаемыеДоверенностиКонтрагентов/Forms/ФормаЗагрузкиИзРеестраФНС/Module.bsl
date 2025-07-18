
#Область ОбработчикиСобытийЭлементовШапкиФормы
	
&НаКлиенте
Процедура КонтрагентПриИзменении(Элемент)
	
	ИННДоверителя = ИННКонтрагента(Контрагент);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Загрузить(Команда)
	
	Если НЕ ПроверитьЗаполнениеРеквизитов() Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураДанных = Новый Структура;
	СтруктураДанных.Вставить("НомерДоверенности", 	НомерДоверенности);
	СтруктураДанных.Вставить("ИННДоверителя", 		ИННДоверителя);
	
	Закрыть(СтруктураДанных);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Функция ПроверитьЗаполнениеРеквизитов()
	
	Отказ = Ложь;
	
	ОчиститьСообщения();
	
	Если Не ПроверитьЗаполнение() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ИННДоверителя) Тогда
		ТекстСообщения = НСтр("ru = 'Не задан ИНН контрагента.';
								|en = 'Counterparty TIN is not specified.'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения, , "Контрагент", , Отказ);
	КонецЕсли;

	Возврат НЕ Отказ;
	
КонецФункции

&НаСервереБезКонтекста
Функция ИННКонтрагента(Знач Контрагент)
	
	Результат = "";
	Если ЗначениеЗаполнено(Контрагент) Тогда	
		Результат = ИнтеграцияЭДО.ДанныеЮрФизЛица(Контрагент).ИНН;	
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти