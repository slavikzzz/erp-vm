
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыОтбора = Новый Структура("УзелОбъекта", ПараметрКоманды);
	ПараметрыФормы = Новый Структура("Отбор", ПараметрыОтбора);
	
	ОткрытьФорму(
		"РегистрСведений.ПодчиненияУзловОбъектовЭксплуатации.ФормаСписка",
		ПараметрыФормы,
		ПараметрыВыполненияКоманды.Источник,
		ПараметрыВыполненияКоманды.Уникальность,
		ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры
