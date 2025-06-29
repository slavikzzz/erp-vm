
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Если Не ПроизводствоВызовСервера.ИспользуетсяПроизводство22() Тогда
		ВызватьИсключение НСтр("ru = 'Формирование заказов материалов по потребностям доступно только при использовании управления производством версии 2.2.';
								|en = 'Generating demand-driven material orders is only available when using production management version 2.2.'");
	КонецЕсли;
	
	Параметры = Новый Структура("ОтборПоТипуОбеспечения", ПредопределенноеЗначение("Перечисление.ТипыОбеспечения.Перемещение"));
	
	ОткрытьФорму("Обработка.ОбеспечениеПотребностей.Форма", Параметры, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность);
	
КонецПроцедуры
