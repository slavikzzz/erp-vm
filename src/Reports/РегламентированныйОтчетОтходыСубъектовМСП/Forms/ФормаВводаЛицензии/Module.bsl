
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Контрагент = СокрЛП(ВРег(Параметры.Контрагент));
	
	Если ПустаяСтрока(Контрагент) Тогда 
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Для Каждого Лицензия Из Параметры.ДанныеЛицензий Цикл
		Если Лицензия.КомуВыдано = Контрагент Тогда 
			НоваяСтрока = ТаблицаЗначений.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, Лицензия);
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры

&НаКлиенте
Процедура Записать(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ЗаписатьЗавершение", ЭтотОбъект);
	ВыполнитьОбработкуОповещения(ОписаниеОповещения, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьЗавершение(Ответ, ДополнительныеПараметры) Экспорт

	Если Ответ = КодВозвратаДиалога.Нет Тогда 
		Возврат;
	КонецЕсли;
	
	Если ТаблицаЗначений.Количество() = 0 Тогда 
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = НСтр("ru = 'Не выбрана лицензия';
								|en = 'Не выбрана лицензия'");
		Сообщение.Сообщить();
		Возврат;
	КонецЕсли;
	
	Если ПустаяСтрока(Элементы.ТаблицаЗначений.ТекущиеДанные.НомерДокумента)
		Или ПустаяСтрока(Элементы.ТаблицаЗначений.ТекущиеДанные.КтоВыдал) Тогда 
		
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = НСтр("ru = 'Поля ""Номер"" и ""Выдал"" являются обязательными для заполнения.';
								|en = 'Поля ""Номер"" и ""Выдал"" являются обязательными для заполнения.'");
		Сообщение.Сообщить();
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Элементы.ТаблицаЗначений.ТекущиеДанные.ДатаВыдачи)
		Или Не ЗначениеЗаполнено(Элементы.ТаблицаЗначений.ТекущиеДанные.ДатаНачалаДействия) Тогда
		
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = НСтр("ru = 'Поля ""Дата выдачи"" и ""Начало действия"" являются обязательными для заполнения.';
								|en = 'Поля ""Дата выдачи"" и ""Начало действия"" являются обязательными для заполнения.'");
		Сообщение.Сообщить();
		Возврат;
	КонецЕсли;
	
	Результат = Новый Структура;
	Результат.Вставить("ТаблицаЛицензий", ТаблицаЗначений);
	Результат.Вставить("ТекущиеДанные", Элементы.ТаблицаЗначений.ТекущиеДанные);
	Закрыть(Результат);
	
КонецПроцедуры	

&НаКлиенте
Процедура ТаблицаЗначенийПриИзменении(Элемент)
	ТекущиеДанные = Элементы.ТаблицаЗначений.ТекущиеДанные;
	Если ПустаяСтрока(ТекущиеДанные.LIC_ID) Тогда
		ТекущиеДанные.КомуВыдано = Контрагент;
		ТекущиеДанные.LIC_ID = СтрЗаменить(Новый УникальныйИдентификатор, "-", "");
	КонецЕсли;
КонецПроцедуры

#КонецОбласти