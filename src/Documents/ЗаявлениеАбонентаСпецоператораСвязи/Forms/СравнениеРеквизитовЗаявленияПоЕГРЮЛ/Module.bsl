
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Адрес = Параметры.Адрес;
	ЭтоЮридическоеЛицо = Параметры.ЭтоЮридическоеЛицо;
	
	ИнициализироватьТаблицуСравнения(Адрес);
	УправлениеФормой();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОтправитьБезИсправления(Команда)
	
	Закрыть(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсправитьВЗаявлении(Команда)
	
	Если АвтоматическоеИсправлениеВозможно() Тогда
		Закрыть(Истина);
	Иначе
		Закрыть(Неопределено);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаменитьЕГРЮЛнаЕГНИП(Элемент)

	ОбработкаЗаявленийАбонентаКлиентСервер.ЗаменитьЕГРЮЛнаЕГНИП(Элемент.Заголовок, ЭтоЮридическоеЛицо);
	
КонецПроцедуры

&НаСервере
Процедура ИнициализироватьТаблицуСравнения(Адрес)
	
	Таблица = ПолучитьИзВременногоХранилища(Адрес);
	ЗначениеВРеквизитФормы(Таблица, "ТаблицаСравненияПоЕГРЮЛ");
	
КонецПроцедуры

&НаСервере
Процедура УправлениеФормой()
	
	ВозможноИсправить = АвтоматическоеИсправлениеВозможно();
	Элементы.ФормаИсправитьВЗаявлении.Видимость = ВозможноИсправить;
	
	ЗаменитьЕГРЮЛнаЕГНИП(ЭтотОбъект);
	ЗаменитьЕГРЮЛнаЕГНИП(Элементы.Текст);
	ЗаменитьЕГРЮЛнаЕГНИП(Элементы.ТаблицаСравненияРеквизитовЕГРЮЛПредставление);
	ЗаменитьЕГРЮЛнаЕГНИП(Элементы.ФормаИсправитьВЗаявлении);
	
	Если ЭтоЮридическоеЛицо Тогда
		ТекстЗамены = НСтр("ru = 'организации';
							|en = 'организации'");
	Иначе
		ТекстЗамены = НСтр("ru = 'ИП';
							|en = 'ИП'");
	КонецЕсли;
	Элементы.Текст.Заголовок = СтрШаблон(Элементы.Текст.Заголовок, ТекстЗамены);
	
КонецПроцедуры

&НаСервере
Функция АвтоматическоеИсправлениеВозможно()
	
	Возможно = Истина;
	
	Для каждого Строка Из ТаблицаСравненияПоЕГРЮЛ Цикл
		
		Если Строка.Различается И 
			ЭтоОшибкаЕГРЮЛИсправляемаяВручную(Строка.Реквизит) Тогда
				
			Возможно = Ложь;
			Прервать;
				
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Возможно;
	
КонецФункции

&НаСервере
Функция ЭтоОшибкаЕГРЮЛИсправляемаяВручную(Ошибка) Экспорт

	Возврат 
		Ошибка = ПредопределенноеЗначение("Перечисление.ПараметрыПодключенияК1СОтчетности.КодРегиона")
		ИЛИ Ошибка = ПредопределенноеЗначение("Перечисление.ПараметрыПодключенияК1СОтчетности.Город")
		ИЛИ Ошибка = ПредопределенноеЗначение("Перечисление.ПараметрыПодключенияК1СОтчетности.Улица")
		ИЛИ Ошибка = ПредопределенноеЗначение("Перечисление.ПараметрыПодключенияК1СОтчетности.ВладелецЭЦПИНН")
		ИЛИ Ошибка = ПредопределенноеЗначение("Перечисление.ПараметрыПодключенияК1СОтчетности.ВладелецЭЦПФИО");
			
КонецФункции
	
#КонецОбласти


