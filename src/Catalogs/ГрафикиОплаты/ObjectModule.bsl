#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если Этапы.Итог("ПроцентПлатежа") <> 100 Тогда
		
		ТекстОшибки = НСтр("ru = 'Процент платежей по всем этапам должен быть равен 100%';
							|en = 'Payment percentage at all stages should be equal to 100 %'");
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстОшибки,
			ЭтотОбъект,
			"Этапы",
			,
			Отказ);
		
	КонецЕсли;
	
	Если Этапы.Итог("ПроцентЗалогаЗаТару") <> 100 И Этапы.Итог("ПроцентЗалогаЗаТару") <> 0 Тогда
		
		ТекстОшибки = НСтр("ru = 'Процент залога за тару по всем этапам должен быть равен 100% или 0%';
							|en = 'Percentage of the packaging deposit at all stages should be equal to 100% or 0%'");
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстОшибки,
			ЭтотОбъект,
			"Этапы",
			,
			Отказ);
		
	КонецЕсли;
	
	НепроверяемыеРеквизиты = Новый Массив;
	НепроверяемыеРеквизиты.Добавить("Этапы.ПроцентПлатежа");
	НепроверяемыеРеквизиты.Добавить("Этапы.ПроцентЗалогаЗаТару");
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, НепроверяемыеРеквизиты);
	Для Каждого ЭтапОплаты Из Этапы Цикл
		
		Если Не ЗначениеЗаполнено(ЭтапОплаты.ПроцентПлатежа) И Не ЗначениеЗаполнено(ЭтапОплаты.ПроцентЗалогаЗаТару) Тогда
			
			ТекстОшибки = НСтр("ru = 'В строке для этапа должен быть указан процент платежа или процент залога за тару';
								|en = 'Percentage of payment or packaging deposit should be specified in the line for the step'");
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстОшибки,
				ЭтотОбъект,
				"Этапы[" + ЭтапОплаты.НомерСтроки + "]",
				,
				Отказ);
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	// Проверим наличие только кредитных этапов оплаты в графике.
	ТолькоКредитныеЭтапыВГрафике = Истина;
	Для Каждого СтрокаТаблицы Из Этапы Цикл
		Если СтрокаТаблицы.ВариантОплаты <> Перечисления.ВариантыКонтроляОплатыКлиентом.КредитСдвиг
			И СтрокаТаблицы.ВариантОплаты <> Перечисления.ВариантыКонтроляОплатыКлиентом.КредитПослеОтгрузки Тогда
			ТолькоКредитныеЭтапыВГрафике = Ложь;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если ТолькоКредитныеЭтапы <> ТолькоКредитныеЭтапыВГрафике Тогда
		ТолькоКредитныеЭтапы = ТолькоКредитныеЭтапыВГрафике;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
