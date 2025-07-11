////////////////////////////////////////////////////////////////////////////////
// Процедуры подсистемы "Внеоборотные активы", предназначенные для локализации.
// 
////////////////////////////////////////////////////////////////////////////////

//++ Локализация

#Область СлужебныеПроцедурыИФункции

#Область Налоги

Функция ПредставлениеДокументаПерерасчетИмущественныхНалогов(Реквизиты) Экспорт
	
	Представление = НСтр("ru = 'Перерасчет имущественных налогов %1';
						|en = 'Recalculation of property taxes %1'");
	
	ПредставлениеНомерДата = НСтр("ru = '(создание)';
									|en = '(Create)'");
	Если ЗначениеЗаполнено(Реквизиты.Ссылка) Тогда
		ПредставлениеНомерДата = СтрШаблон(НСтр("ru = '%1 от %2';
												|en = '%1, created on %2'"), Реквизиты.Номер, Реквизиты.Дата);
	КонецЕсли;
	
	Если Реквизиты.ВидНалога = Перечисления.ВидыИмущественныхНалогов.НалогНаИмущество Тогда
		Представление = НСтр("ru = 'Перерасчет налога на имущество %1';
							|en = 'Recalculation of property tax %1'");
	ИначеЕсли Реквизиты.ВидНалога = Перечисления.ВидыИмущественныхНалогов.ТранспортныйНалог Тогда
		Представление = НСтр("ru = 'Перерасчет транспортного налога %1';
							|en = 'Recalculation of vehicle tax %1'");
	ИначеЕсли Реквизиты.ВидНалога = Перечисления.ВидыИмущественныхНалогов.ЗемельныйНалог Тогда
		Представление = НСтр("ru = 'Перерасчет земельного налога %1';
							|en = 'Recalculation of land value tax %1'");
	КонецЕсли;
	
	Возврат СтрШаблон(Представление, ПредставлениеНомерДата);
	
КонецФункции

#КонецОбласти

#КонецОбласти

//-- Локализация