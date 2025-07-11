
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Параметры.Свойство("ИдентификаторАккаунта", ИдентификаторАккаунта);
	 
	Если Не ЗначениеЗаполнено(ИдентификаторАккаунта) Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	ДанныеАвторизации = ИнтеграцияСЯндексМаркетСервер.ДанныеАвторизацииПоИдентификаторуАккаунта(ИдентификаторАккаунта);  
	
	Если ТипЗнч(ДанныеАвторизации) = Тип("Структура")
		 И ДанныеАвторизации.Свойство("access_token") 
		 И ДанныеАвторизации.Свойство("access_token_expires")
		 И ДанныеАвторизации.Свойство("refresh_token") Тогда
		НаименованиеАккаунта = ДанныеАвторизации.login;
		СрокЖизниТокена      = ДанныеАвторизации.access_token_expires;
		
		Если ТипЗнч(СрокЖизниТокена) = Тип("Дата") Тогда
			Если СрокЖизниТокена > ТекущаяДатаСеанса() Тогда
				Элементы.Обновить.Видимость       = Ложь;
				Элементы.Очистить.Видимость       = Истина;
				Элементы.Отмена.КнопкаПоУмолчанию = Истина;
				
				Элементы.СтрокаИнформации.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Для аккаунта ""%1"" актуальна авторизация на Яндекс Маркет до %2';
						|en = 'For account ""%1"", authorization on Yandex.Market is valid until %2'"),
					НаименованиеАккаунта,
					Формат(СрокЖизниТокена, "ДЛФ=DT"));
					
			Иначе
				Элементы.Обновить.Видимость         = Истина;
				Элементы.Обновить.КнопкаПоУмолчанию = Истина;
				Элементы.Очистить.Видимость         = Ложь;
				
				Элементы.СтрокаИнформации.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Для аккаунта ""%1"" авторизация на Яндекс Маркет не актуальна.';
						|en = 'For account ""%1"", authorization on Yandex.Market is invalid.'"),
					НаименованиеАккаунта);
				Возврат;
			КонецЕсли;
		КонецЕсли;
		
	Иначе
		Элементы.Обновить.Видимость       = Истина;
		Элементы.Очистить.Видимость       = Ложь;
		Элементы.Отмена.КнопкаПоУмолчанию = Истина;
		
		Элементы.СтрокаИнформации.ЦветТекста = ЦветаСтиля.ЦветПустойГиперссылки;
		Элементы.СтрокаИнформации.Заголовок  = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Для аккаунта ""%1"" не найдены настройки авторизации.';
				|en = 'For account ""%1"", authorization settings are not found.'"),
			ИдентификаторАккаунта);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)

	Если ИмяСобытия = "ЯндексМаркет_ПодключениеКСервису" Тогда
		Если Параметр = ИдентификаторАккаунта Тогда
			Закрыть(ИдентификаторАккаунта);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура УстановитьНастройки(Команда)
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("ИдентификаторАккаунта", ИдентификаторАккаунта);
	
	ОткрытьФорму("Обработка.ПанельАдминистрированияПродажиЯндексМаркет.Форма.ПодключениеКСервису", 
		ПараметрыОткрытия, 
		ЭтотОбъект, 
		Истина,,,
		, 
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьНастройки(Команда)
	
	ОповещениеОЗавершении = Новый ОписаниеОповещения("ОчиститьНастройкиЗавершение", ЭтотОбъект);
	ПоказатьВопрос(ОповещениеОЗавершении, 
		НСтр("ru = 'Настройки авторизации будут удалены без возможности восстановления. Для продолжения работы на площадке под текущим аккаунтом будет необходимо получить новые настройки.
				   |Вы действительно хотите очистить настройки?';
				   |en = 'The authorization settings will be permanently deleted. To continue operations on the trading platform under the current account, get new settings.
				   |Are you sure you want to reset the settings?'"), 
		РежимДиалогаВопрос.ДаНет, 
		, 
		КодВозвратаДиалога.Нет, 
		НСтр("ru = 'Яндекс Маркет';
			|en = 'Yandex.Market'"), 
		КодВозвратаДиалога.Нет);
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть(Неопределено);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОчиститьНастройкиЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт 
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		ОчиститьНастройкиНаСервере();
		Оповестить("ЯндексМаркет_ОчиститьНастройкиПодключения", ИдентификаторАккаунта);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОчиститьНастройкиНаСервере()  
	
	ИнтеграцияСЯндексМаркетСервер.УдалитьДанныеАвторизации(ИдентификаторАккаунта);
	
	Элементы.Очистить.Видимость          = Ложь;
	Элементы.СтрокаИнформации.ЦветТекста = ЦветаСтиля.ЦветПустойГиперссылки;
	Элементы.СтрокаИнформации.Заголовок  = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Для аккаунта ""%1"" удалены настройки авторизации.';
			|en = 'For account ""%1"", the authorization settings are deleted.'"),
		НаименованиеАккаунта);
	
КонецПроцедуры

#КонецОбласти
