#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ТолькоПросмотр = Не Пользователи.ЭтоПолноправныйПользователь();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СвернутьДвижения(Команда)
	
	СвернутьДвиженияНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура СвернутьДвиженияНаСервере()
	
	СтруктураЗаказаСлужебный.СверткаРегистров();
	
	Элементы.Список.Обновить();
	
КонецПроцедуры

#КонецОбласти
