#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// Позволяет указать объекты метаданных, для которых задана логика ограничения доступа к данным.
//
// Параметры:
//   Ограничение - см. УправлениеДоступомПереопределяемый.ПриЗаполненииОграниченияДоступа.Ограничение.
//
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	
	Ограничение.Текст =
		"РазрешитьЧтениеИзменение
		|ГДЕ
		|	ЗначениеРазрешено(УчетнаяЗаписьМаркетплейса.Организация)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура УстановитьПредставлениеЗаписи(Запись) Экспорт

	ОграничениеОтключено = НСтр("ru = 'Настройка ограничения выгрузки не используется';
								|en = 'The export restriction setting is not used'");
	ТекстОграничения1 = НСтр("ru = 'Остаток недоступен к выгрузке';
							|en = 'The balance is unavailable for export'");
	ТекстОграничения2 = НСтр("ru = 'К выгрузке доступно %1 % от учетного количества остатка номенклатуры';
							|en = 'You can export %1% of the accounted stock balance quantity'");
	ТекстОграничения3 = НСтр("ru = 'Из выгружаемого остатка номенклатуры исключается страховой запас в количестве %1 ед.';
							|en = 'Safety stock in the amount of %1 items is excluded from the stock balance to export'");
	ТекстОграничения4 = НСтр("ru = 'К выгрузке доступно %1 % от учетного количества остатка номенклатуры, но с обеспечением страхового запаса в количестве %2 ед. остатка номенклатуры';
							|en = 'You can export %1% of the accounted stock balance if you provide safety stock in the amount of %2 items of the stock balance'");

	Если Не Запись.Используется Тогда
		ПредставлениеОграничения = ОграничениеОтключено;
	ИначеЕсли Запись.ПроцентОстатка = 100 И ЗначениеЗаполнено(Запись.СтраховойЗапас) Тогда
		ПредставлениеОграничения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстОграничения3, Запись.СтраховойЗапас);
	ИначеЕсли ЗначениеЗаполнено(Запись.ПроцентОстатка) И ЗначениеЗаполнено(Запись.СтраховойЗапас) Тогда
		ПредставлениеОграничения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстОграничения4, Запись.ПроцентОстатка, Запись.СтраховойЗапас);
	ИначеЕсли ЗначениеЗаполнено(Запись.ПроцентОстатка) Тогда
		ПредставлениеОграничения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстОграничения2, Запись.ПроцентОстатка);
	Иначе
		ПредставлениеОграничения = ТекстОграничения1;
	КонецЕсли;

	Запись.ПредставлениеОграничения = ПредставлениеОграничения;

КонецПроцедуры

#КонецОбласти

#КонецЕсли
