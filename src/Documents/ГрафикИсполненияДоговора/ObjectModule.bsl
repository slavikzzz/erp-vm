#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ШаблонОшибки = НСтр("ru = 'Не заполнена колонка ""Сумма"" в строке %1 списка ""График оплаты""';
						|en = 'The ""Amount"" column in the %1 line of the ""Payment schedule"" list is not filled in'");
	Для каждого Этап Из ЭтапыГрафикаОплаты Цикл
		Если Не ЗначениеЗаполнено(Этап.СуммаПлатежа) Тогда
			ТекстОшибки = СтрШаблон(ШаблонОшибки, Этап.НомерСтроки);
			ОбщегоНазначения.СообщитьПользователю(
				ТекстОшибки,
				,
				"Объект."+ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("ЭтапыГрафикаОплаты", Этап.НомерСтроки, "СуммаПлатежа"),
				,
				Отказ);
		КонецЕсли;
	КонецЦикла;
	
	Если ЭтапыГрафикаОплаты.Итог("ПроцентПлатежа") <> 100 Тогда
		ТекстОшибки = НСтр("ru = 'Процент оплаты договора по всем этапам должен быть равен ""100%""';
							|en = 'The percentage of contract payment in all stages must be ""100%""'");
		ОбщегоНазначения.СообщитьПользователю(
			ТекстОшибки,
			ЭтотОбъект,
			,
			,
			Отказ);
	КонецЕсли;
		
	Если ЭтапыГрафикаИсполненияДоговора.Итог("ПроцентИсполнения") <> 100 Тогда
		ТекстОшибки = НСтр("ru = 'Процент отгрузки договора по всем этапам должен быть равен ""100%""';
							|en = 'The percentage of contract shipment in all stages must be ""100%""'");
		ОбщегоНазначения.СообщитьПользователю(
			ТекстОшибки,
			ЭтотОбъект,
			,
			,
			Отказ);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ПроведениеДокументов.ПередЗаписьюДокумента(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	
	Если ЭтоНовый() И НЕ ЗначениеЗаполнено(Номер) Тогда
		УстановитьНовыйНомер();
	КонецЕсли;
	
	ДатаПоУмолчанию = ?(ЭтапыГрафикаИсполненияДоговора.Количество() > 0,
			ЭтапыГрафикаИсполненияДоговора[0].ДатаПоГрафику,
			?(ЗначениеЗаполнено(Дата), Дата, ТекущаяДатаСеанса()));
	
	ДатаДоговора = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Договор,"Дата");
	Если ЗначениеЗаполнено(ДатаДоговора) Тогда
		ДатаПоУмолчанию = Мин(ДатаДоговора,ДатаПоУмолчанию);
	КонецЕсли;
	
	Если Дата > ДатаПоУмолчанию Тогда
		Дата = ДатаПоУмолчанию;
	КонецЕсли;
	
	Если РежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения Тогда
		ОбъектРасчетов = Справочники.ОбъектыРасчетов.ПустаяСсылка();
	ИначеЕсли РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		ОбъектРасчетов = ОбъектыРасчетовСервер.ПолучитьОбъектРасчетовПоСсылке(Договор);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПроведениеДокументов.ПриЗаписиДокумента(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеДокументов.ОбработкаПроведенияДокумента(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеДокументов.ОбработкаУдаленияПроведенияДокумента(ЭтотОбъект, Отказ);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли