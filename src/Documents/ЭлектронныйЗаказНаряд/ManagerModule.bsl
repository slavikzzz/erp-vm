#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка)
	
	Номер = Данные.Номер;
	Направление = "";
	Если ЗначениеЗаполнено(Данные.Ссылка) Тогда
		РеквизитыСсылки = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Данные.Ссылка, "ТитулФрахтователяПорядковыйНомерЗаказНаряда,ЭтоВходящий", Истина);
		Если ЗначениеЗаполнено(РеквизитыСсылки.ТитулФрахтователяПорядковыйНомерЗаказНаряда) Тогда
			Номер = РеквизитыСсылки.ТитулФрахтователяПорядковыйНомерЗаказНаряда;
		КонецЕсли;
		Если ЗначениеЗаполнено(РеквизитыСсылки.ЭтоВходящий) Тогда
			Направление = ?(РеквизитыСсылки.ЭтоВходящий, " (входящий)", "");
		КонецЕсли;
	КонецЕсли;
	Дата = Формат(Данные.Дата, "ДФ=dd.MM.yyyy");
	Представление = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru = 'Электронный заказ-наряд%1 № %2 от %3';
							|en = 'Электронный заказ-наряд%1 № %2 от %3'"), Направление, Номер, Дата);
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецЕсли
