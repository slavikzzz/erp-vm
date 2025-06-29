
#Область СлужебныеПроцедурыИФункции

Функция ТипыЭлектронныхДокументовГИСМТ() Экспорт
	ТипДокумента = Новый Массив;
	ТипДокумента.Добавить(ПредопределенноеЗначение("Перечисление.ТипыДокументовГИСМТ.УПД"));
	ТипДокумента.Добавить(ПредопределенноеЗначение("Перечисление.ТипыДокументовГИСМТ.УПДИсправительный"));
	ТипДокумента.Добавить(ПредопределенноеЗначение("Перечисление.ТипыДокументовГИСМТ.УКД"));
	ТипДокумента.Добавить(ПредопределенноеЗначение("Перечисление.ТипыДокументовГИСМТ.УКДИсправительный"));
	Возврат ТипДокумента;
КонецФункции

Функция ДопустимыеЗначенияСтатусаДокументаВСервисе() Экспорт
	СтатусыДокументаВСервисе = Новый Массив;
	СтатусыДокументаВСервисе.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыДокументовИСМП.Проверен"));
	СтатусыДокументаВСервисе.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыДокументовИСМП.Обрабатывается"));
	СтатусыДокументаВСервисе.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыДокументовИСМП.ЕстьОшибки"));
	Возврат СтатусыДокументаВСервисе;
КонецФункции

Функция ЗаголовокКомандыПроверкаОтключена(ПроверкаОтключена) Экспорт
	
	Если ПроверкаОтключена Тогда
		ТекстКомандыОтключитьПроверку = НСтр("ru = 'Включить проверку';
											|en = 'Включить проверку'");
	Иначе
		ТекстКомандыОтключитьПроверку = НСтр("ru = 'Отключить проверку';
											|en = 'Отключить проверку'");
	КонецЕсли;
	
	Возврат ТекстКомандыОтключитьПроверку;
	
КонецФункции

#КонецОбласти