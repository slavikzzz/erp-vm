
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ОценкаПроизводительностиКлиент.ЗамерВремени(
		"ОбщиеКоманды.ОтчетыДавальцуМеждуОрганизациямиКОформлению");
	
	ПараметрыФормы = Новый Структура("КлючНазначенияИспользования", "ДокументыИнтеркампани");
	
	ОткрытьФорму(
		"Документ.ОтчетДавальцуМеждуОрганизациями.Форма.ФормаРабочееМесто",
		ПараметрыФормы,
		ПараметрыВыполненияКоманды.Источник,
		"ДокументыИнтеркампани",
		ПараметрыВыполненияКоманды.Окно,
		ПараметрыВыполненияКоманды.НавигационнаяСсылка);
	
КонецПроцедуры

#КонецОбласти