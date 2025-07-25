#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьБыстрыйОтборСервер();
	
	ОбщегоНазначенияСобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

#Область ОтборПоОрганизации

&НаКлиенте
Процедура ОтборОрганизацииПриИзменении(Элемент)
	
	ИнтеграцияЗЕРНОКлиент.ОбработатьВыборОрганизаций(ЭтотОбъект, Организации, Ложь, "Отбор");
	ЗаполнитьУчитываемыеВидыПродукции();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацииНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияЗЕРНОКлиент.ОткрытьФормуВыбораОрганизаций(ЭтотОбъект, "Отбор", , ОповещениеВыбораОрганизаций());
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацииОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияЗЕРНОКлиент.ОбработатьВыборОрганизаций(ЭтотОбъект, Неопределено, Ложь, "Отбор");
	ЗаполнитьУчитываемыеВидыПродукции();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацииОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияЗЕРНОКлиент.ОбработатьВыборОрганизаций(ЭтотОбъект, ВыбранноеЗначение, Ложь, "Отбор");
	ЗаполнитьУчитываемыеВидыПродукции();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияПриИзменении(Элемент)
	
	ИнтеграцияЗЕРНОКлиент.ОбработатьВыборОрганизаций(ЭтотОбъект, Организация, Ложь, "Отбор");
	ЗаполнитьУчитываемыеВидыПродукции();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияЗЕРНОКлиент.ОткрытьФормуВыбораОрганизаций(ЭтотОбъект, "Отбор", , ОповещениеВыбораОрганизаций());
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияЗЕРНОКлиент.ОбработатьВыборОрганизаций(ЭтотОбъект, Неопределено, Ложь, "Отбор");
	ЗаполнитьУчитываемыеВидыПродукции();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияЗЕРНОКлиент.ОбработатьВыборОрганизаций(ЭтотОбъект, ВыбранноеЗначение, Ложь, "Отбор");
	ЗаполнитьУчитываемыеВидыПродукции();
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СохранитьИЗакрыть(Команда)
	СохранитьИЗакрытьНаСервере();
	Закрыть();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ОтборПоОрганизации

&НаКлиенте
Функция ОповещениеВыбораОрганизаций()
	
	Возврат Новый ОписаниеОповещения("ПослеВыбораОрганизации", ЭтотОбъект);
	
КонецФункции

&НаКлиенте
Процедура ПослеВыбораОрганизации(Результат, ДополнительныеПараметры) Экспорт
	
	ЗаполнитьУчитываемыеВидыПродукции();
	
КонецПроцедуры

#КонецОбласти

&НаСервере
Процедура УстановитьБыстрыйОтборСервер()
	
	Параметры.Свойство("Организации", Организации);
	
	ЗаполнитьУчитываемыеВидыПродукции();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьУчитываемыеВидыПродукции()
	
	СохраненныеУчитываемыеВидыПродукции = Неопределено;
	УчитываемыеВидыПродукции.Очистить();
	
	АдресТаблицы = ИнтеграцияЗЕРНО.ПараметрыОптимизации().УчитываемыеВидыПродукции;
	Если Не ПустаяСтрока(АдресТаблицы) Тогда
		СохраненныеУчитываемыеВидыПродукции = ПолучитьИзВременногоХранилища(АдресТаблицы);
	КонецЕсли;
	
	Если СохраненныеУчитываемыеВидыПродукции = Неопределено
			Или ТипЗнч(СохраненныеУчитываемыеВидыПродукции) <> Тип("ТаблицаЗначений") Тогда
		
		ВсеОрганизации = ОбщегоНазначенияИС.ДоступныеОрганизации();
		
		Для Каждого СтрокаОрганизация Из ВсеОрганизации Цикл
			
			НоваяСтрока = УчитываемыеВидыПродукции.Добавить();
			НоваяСтрока.Организация = СтрокаОрганизация.Значение;
			
		КонецЦикла;
		
		Возврат;
	КонецЕсли;
	
	Если Организации.Количество() = 0 Тогда
		
		УчитываемыеВидыПродукции.Загрузить(СохраненныеУчитываемыеВидыПродукции);
		
		Возврат;
	КонецЕсли;
	
	Для Каждого Строка Из СохраненныеУчитываемыеВидыПродукции Цикл
		
		Для Каждого СтрокаОрганизация Из Организации Цикл
			
			Если Строка.Организация <> СтрокаОрганизация.Значение Тогда
				Продолжить;
			КонецЕсли;
			
			ЗаполнитьЗначенияСвойств(УчитываемыеВидыПродукции.Добавить(), Строка);
			
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура СохранитьИЗакрытьНаСервере()
	
	НачатьТранзакцию();
	
	Попытка
		
		ПараметрыОптимизации = ИнтеграцияЗЕРНО.ПараметрыОптимизации();
		
		АдресТаблицы = ИнтеграцияЗЕРНО.ПараметрыОптимизации().УчитываемыеВидыПродукции;
		
		СохраненныеУчитываемыеВидыПродукции = ПолучитьИзВременногоХранилища(АдресТаблицы);
		ТаблицаУчитываемыеВидыПродукции = УчитываемыеВидыПродукции.Выгрузить();
		
		Если СохраненныеУчитываемыеВидыПродукции = Неопределено 
			Или ТипЗнч(СохраненныеУчитываемыеВидыПродукции) <> Тип("ТаблицаЗначений") Тогда
			СохраненныеУчитываемыеВидыПродукции = ТаблицаУчитываемыеВидыПродукции;
		Иначе
			Для Каждого Строка Из ТаблицаУчитываемыеВидыПродукции Цикл
				
				Отбор = Новый Структура("Организация, Подразделение", Строка.Организация, Строка.Подразделение);
				МассивСохраненные = СохраненныеУчитываемыеВидыПродукции.НайтиСтроки(Отбор);
				
				Если МассивСохраненные.Количество() = 0 Тогда
					Отбор = Новый Структура("Организация", Строка.Организация);
					МассивКУдалению = СохраненныеУчитываемыеВидыПродукции.НайтиСтроки(Отбор);
					Для Каждого СтрокаКУдалению Из МассивКУдалению Цикл
						СохраненныеУчитываемыеВидыПродукции.Удалить(СтрокаКУдалению);
					КонецЦикла;
					СтрокаДляОбновления = СохраненныеУчитываемыеВидыПродукции.Добавить();
				Иначе
					СтрокаДляОбновления = МассивСохраненные[0];
				КонецЕсли;
				ЗаполнитьЗначенияСвойств(СтрокаДляОбновления, Строка);
			КонецЦикла;
		КонецЕсли;
		
		ПараметрыОптимизации.УчитываемыеВидыПродукции = СохраненныеУчитываемыеВидыПродукции;
		
		ИнтеграцияЗЕРНОСлужебный.ЗаписатьПараметрыОптимизации(ПараметрыОптимизации);
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		ИнфрмацияОшибки = ИнформацияОбОшибке();
		ЗаписьЖурналаРегистрации(
			НСтр("ru = 'Выполнение операции';
				|en = 'Выполнение операции'", ОбщегоНазначения.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка,,,
			ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнфрмацияОшибки));
		
		ВызватьИсключение;
		
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти