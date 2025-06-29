
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.ПланПроизводства) Тогда
		
		АвтоЗаголовок = Ложь;
		
		Реквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
			Параметры.ПланПроизводства,
			"Номер, Дата");
		
		Заголовок = СтрШаблон(
			НСтр("ru = 'Отмененные корректировки плана производства %1 от %2';
				|en = 'Canceled production plan adjusting entries %1 dated %2'"),
			Реквизиты.Номер,
			Формат(Реквизиты.Дата, "ДЛФ=DT"));
		
	КонецЕсли;
	
	Элементы.Назначение.Видимость = Параметры.ПоказыватьНазначение;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Ключ", ВыбраннаяСтрока);
	ПараметрыФормы.Вставить("ПоказыватьНазначение", Элементы.Назначение.Видимость);
	
	ОткрытьФорму(
		"РегистрСведений.ОтменаКорректировокПланаПроизводства.Форма.ФормаЗаписиПросмотр",
		ПараметрыФормы,
		ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПослеУдаления(Элемент)
	
	ПараметрыОповещения = Новый Структура("ПланПроизводства", Параметры.ПланПроизводства);
	
	Если ВладелецФормы <> Неопределено Тогда
		Оповестить("ОтменаКорректировокПланаПроизводства", ПараметрыОповещения, ВладелецФормы.УникальныйИдентификатор);
	Иначе
		Оповестить("ОтменаКорректировокПланаПроизводства", ПараметрыОповещения);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
