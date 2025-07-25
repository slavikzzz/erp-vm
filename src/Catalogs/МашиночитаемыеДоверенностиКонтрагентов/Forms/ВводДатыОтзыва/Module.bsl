#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ДатаОтзыва = ТекущаяДатаСеанса();
	
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ВладелецФормы.ИмяФормы = "Справочник.МашиночитаемыеДоверенностиОрганизаций.Форма.ФормаПросмотра" 
		ИЛИ ВладелецФормы.ИмяФормы = "Справочник.МашиночитаемыеДоверенностиОрганизаций.Форма.ФормаСписка"
		ИЛИ ВладелецФормы.ИмяФормы = "Справочник.МЧД003.Форма.ФормаПросмотра" Тогда
		
		ТекстЗаголовка = НСтр(
			"ru = 'Пометка доверенности отозванной не позволит ее использовать при подписании документов.';
			|en = 'If you mark the authorization letter as revoked, you will not be able to use it when signing documents.'");
		Элементы.Декорация.Заголовок = ТекстЗаголовка;	
	
	КонецЕсли;
	
КонецПроцедуры

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПометитьОтозванной(Команда)
	
	Закрыть(ДатаОтзыва);
	
КонецПроцедуры

#КонецОбласти