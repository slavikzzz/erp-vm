#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);

КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	СтатьиРасходов.ТипЗначения КАК ТипЗначения
	|ИЗ
	|	ПланВидовХарактеристик.СтатьиРасходов КАК СтатьиРасходов
	|ГДЕ
	|	СтатьиРасходов.Ссылка = &СтатьяРасходов
	|");
	
	Запрос.УстановитьПараметр("СтатьяРасходов", Владелец);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		ТипЗначенияАналитикиРасходов = Выборка.ТипЗначения;
	Иначе
		ТипЗначенияАналитикиРасходов = Неопределено;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Владелец) И НЕ ТипЗначенияАналитикиРасходов.СодержитТип(Тип("СправочникСсылка.ПрочиеРасходы")) Тогда
		Текст = НСтр("ru = 'Необходимо указать статью расходов с аналитикой ""Прочие расходы""';
					|en = 'Specify an expense item with the ""Extended expense dimensions""'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			Текст,
			ЭтотОбъект,
			"Владелец",
			,
			Отказ);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
