
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураДанных = Параметры.СтруктураДанных;
	
	Если СтруктураДанных.Свойство("ТолькоПросмотрФормы") И СтруктураДанных.ТолькоПросмотрФормы Тогда
		Элементы.ПредставительЮЛ_НаимОрг.ТолькоПросмотр = Истина;
		Элементы.ПредставительЮЛ_ИНН.ТолькоПросмотр 	= Истина;
		Элементы.ПредставительЮЛ_КПП.ТолькоПросмотр 	= Истина;
		Элементы.ПредставительЮЛ_ОГРН.ТолькоПросмотр 	= Истина;
		Элементы.ФормаКнопкаСохранить.Доступность 		= Ложь;
	КонецЕсли;
	
	Если СтруктураДанных <> Неопределено Тогда
		ПредставительЮЛ_НаимОрг 	= СтруктураДанных.ПредставительЮЛ_НаимОрг;
		ПредставительЮЛ_ИНН 		= СтруктураДанных.ПредставительЮЛ_ИНН;
		ПредставительЮЛ_КПП 		= СтруктураДанных.ПредставительЮЛ_КПП;
		ПредставительЮЛ_ОГРН 		= СтруктураДанных.ПредставительЮЛ_ОГРН;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Сохранить(Команда)
	
	Если НЕ СохранениеВозможно() Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураДанных = Новый Структура;
	СтруктураДанных.Вставить("ПредставительЮЛ_НаимОрг", 	ПредставительЮЛ_НаимОрг);
	СтруктураДанных.Вставить("ПредставительЮЛ_ИНН", 		ПредставительЮЛ_ИНН);
	СтруктураДанных.Вставить("ПредставительЮЛ_КПП", 		ПредставительЮЛ_КПП);
	СтруктураДанных.Вставить("ПредставительЮЛ_ОГРН", 		ПредставительЮЛ_ОГРН);
	
	Закрыть(СтруктураДанных);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Функция СохранениеВозможно()
	
	Отказ = Ложь;
	
	ОчиститьСообщения();
	
	Если НЕ ЗначениеЗаполнено(ПредставительЮЛ_НаимОрг) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Не задано наименование организации.';
														|en = 'Не задано наименование организации.'"),,
			"ПредставительЮЛ_НаимОрг",, Отказ);
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ПредставительЮЛ_ИНН) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Не задан ИНН организации.';
														|en = 'Не задан ИНН организации.'"),,
			"ПредставительЮЛ_ИНН",, Отказ);
	ИначеЕсли НЕ РегламентированнаяОтчетностьВызовСервера.ИННСоответствуетТребованиямНаСервере(
		ПредставительЮЛ_ИНН, Ложь) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Указан некорректный ИНН организации.';
														|en = 'Указан некорректный ИНН организации.'"),,
			"ПредставительЮЛ_ИНН",, Отказ);
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ПредставительЮЛ_КПП) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Не задан КПП организации.';
														|en = 'Не задан КПП организации.'"),,
			"ПредставительЮЛ_КПП",, Отказ);
	ИначеЕсли СтрДлина(СокрЛП(ПредставительЮЛ_КПП)) <> 9 Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Указан некорректный КПП организации.';
														|en = 'Указан некорректный КПП организации.'"),,
			"ПредставительЮЛ_КПП",, Отказ);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ПредставительЮЛ_ОГРН) И СтрДлина(СокрЛП(ПредставительЮЛ_ОГРН)) <> 13 Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Указан некорректный ОГРН организации.';
														|en = 'Указан некорректный ОГРН организации.'"),,
			"ПредставительЮЛ_ОГРН",, Отказ);
	КонецЕсли;
	
	Возврат НЕ Отказ;
	
КонецФункции

#КонецОбласти
