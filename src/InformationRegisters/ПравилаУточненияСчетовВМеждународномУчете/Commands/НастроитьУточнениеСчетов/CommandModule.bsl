
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыФормы = Новый Структура("ГруппаФинансовогоУчета", ПараметрКоманды);
	ОткрытьФорму("РегистрСведений.ПравилаУточненияСчетовВМеждународномУчете.Форма.НастройкаУточненияСчетов",
				 ПараметрыФормы,
				 ПараметрыВыполненияКоманды.Источник,
				 ПараметрыВыполненияКоманды.Уникальность,
				 ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры

#КонецОбласти