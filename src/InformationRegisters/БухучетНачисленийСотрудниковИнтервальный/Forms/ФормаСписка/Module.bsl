
#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПерезаполнитьРегистр(Команда)
	ПерезаполнитьРегистрНаСервере();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПерезаполнитьРегистрНаСервере()
	
	НаборЗаписей = РегистрыСведений.БухучетНачисленийСотрудниковИнтервальный.СоздатьНаборЗаписей();
	НаборЗаписей.ОбменДанными.Загрузка = Истина;
	НаборЗаписей.Записать();
	
	РегистрыСведений.БухучетНачисленийСотрудников.ЗаполнитьИнтервальныйРегистр();
	
	Элементы.Список.Обновить();
	
КонецПроцедуры

#КонецОбласти
