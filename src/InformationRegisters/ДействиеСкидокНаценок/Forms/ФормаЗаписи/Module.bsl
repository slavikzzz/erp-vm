
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Запись, ЭтотОбъект);
	
	ДанныеФормы = Новый Структура;
	ДанныеФормы.Вставить("Источник");
	ДанныеФормы.Вставить("СкидкаНаценка");
	
	Если Параметры.Ключ.Источник <> Неопределено Тогда
		ДанныеФормы.Источник = Параметры.Ключ.Источник;
	КонецЕсли;
	Если Параметры.ЗначенияЗаполнения.Свойство("Источник")
		И Параметры.ЗначенияЗаполнения.Источник <> Неопределено Тогда
		ДанныеФормы.Источник = Параметры.ЗначенияЗаполнения.Источник;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.Ключ.СкидкаНаценка) Тогда
		ДанныеФормы.СкидкаНаценка = Параметры.Ключ.СкидкаНаценка;
	КонецЕсли;
	Если Параметры.ЗначенияЗаполнения.Свойство("СкидкаНаценка")
		И ЗначениеЗаполнено(Параметры.ЗначенияЗаполнения.СкидкаНаценка) Тогда
		ДанныеФормы.СкидкаНаценка = Параметры.ЗначенияЗаполнения.СкидкаНаценка;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ДанныеФормы.Источник) Или ДанныеФормы.Источник = Справочники.Склады.ПустаяСсылка() Тогда
		Элементы.Источник.ТолькоПросмотр = Истина;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ДанныеФормы.СкидкаНаценка) Или ДанныеФормы.Источник = Справочники.Склады.ПустаяСсылка() Тогда
		Элементы.СкидкаНаценка.ТолькоПросмотр = Истина;
	КонецЕсли;
	
	Если Элементы.Источник.ТолькоПросмотр И Элементы.СкидкаНаценка.ТолькоПросмотр Тогда
		Элементы.СтраницыСкидкаНаценка.ТекущаяСтраница = Элементы.СтраницаРедактированиеЗапрещено;
	КонецЕсли;
	
	Если Элементы.Источник.ТолькоПросмотр Тогда
		
		Если ТипЗнч(ДанныеФормы.Источник) = Тип("СправочникСсылка.Склады") Тогда
			Элементы.ИсточникГиперСсылка.Заголовок = НСтр("ru = 'Склад';
															|en = 'Warehouse'");
		ИначеЕсли ТипЗнч(ДанныеФормы.Источник) = Тип("СправочникСсылка.СоглашенияСКлиентами") Тогда
			Элементы.ИсточникГиперСсылка.Заголовок = НСтр("ru = 'Соглашение';
															|en = 'Agreement'");
		ИначеЕсли ТипЗнч(ДанныеФормы.Источник) = Тип("СправочникСсылка.ВидыКартЛояльности") Тогда
			Элементы.ИсточникГиперСсылка.Заголовок = НСтр("ru = 'Вид карты лояльности';
															|en = 'Loyalty card kind'");
		КонецЕсли;
		
		Если ДанныеФормы.Источник = Справочники.Склады.ПустаяСсылка() Тогда
			Элементы.ИсточникГиперСсылка.Видимость = Ложь;
			Элементы.Источник.Видимость = Ложь;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	МассивСкидкиНаценки = Новый Массив;
	МассивИсточники = Новый Массив;
	
	МассивСкидкиНаценки.Добавить(Запись.СкидкаНаценка);
	МассивИсточники.Добавить(Запись.Источник);
	
	Параметр = Новый Структура;
	Параметр.Вставить("СкидкаНаценка", МассивСкидкиНаценки);
	Параметр.Вставить("Источник", МассивИсточники);
	
	Оповестить("Запись_ДействиеСкидокНаценок", Параметр, ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если Не ЗначениеЗаполнено(ТекущийОбъект.Ответственный) Тогда
		ТекущийОбъект.Ответственный = Пользователи.ТекущийПользователь();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти