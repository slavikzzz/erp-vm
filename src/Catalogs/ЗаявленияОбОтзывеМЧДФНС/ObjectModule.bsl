#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	Если ПометкаУдаления ИЛИ Ссылка.ПометкаУдаления Тогда
		Возврат;
	КонецЕсли;
	
	Наименование = НСтр("ru = 'Заявление об отзыве машиночитаемой доверенности (ФНС)';
						|en = 'Заявление об отзыве машиночитаемой доверенности (ФНС)'")
		+ ?(ЗначениеЗаполнено(НомерДоверенности) ИЛИ ЗначениеЗаполнено(РегистрационныйНомерДоверенности),
			" " + НСтр("ru = '№';
						|en = '№'") + ?(ЗначениеЗаполнено(НомерДоверенности), НомерДоверенности,
			РегистрационныйНомерДоверенности), "")
		+ ?(ЗначениеЗаполнено(ДатаВыдачи), " " + НСтр("ru = 'от';
														|en = 'от'") + " "
		+ Формат(ДатаВыдачи, "ДФ='дд.ММ.гггг'") + " " + НСтр("ru = 'г.';
															|en = 'г.'"), "");
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли