///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОписаниеПеременных

// Хранение контекста взаимодействия с сервисом
&НаКлиенте
Перем КонтекстВзаимодействия Экспорт;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	МестоЗапуска = Параметры.МестоЗапуска;
	
	// Заполнение формы необходимыми параметрами.
	ЗаполнитьФорму();
	
	Если КлиентскоеПриложение.ТекущийВариантИнтерфейса() = ВариантИнтерфейсаКлиентскогоПриложения.Такси Тогда
		Элементы.ГруппаЗаголовкаРегНомера.Отображение = ОтображениеОбычнойГруппы.Нет;
		Элементы.ГруппаКонтентаРегНомер.Отображение = ОтображениеОбычнойГруппы.Нет;
	КонецЕсли;
	
	Если Не ОбщегоНазначения.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.СообщенияВСлужбуТехническойПоддержки") Тогда
		Элементы.ПояснениеКЗаголовкуРегНомер.Заголовок
			= НСтр("ru = 'Укажите регистрационный номер продукта, с которым вы сейчас работаете.';
					|en = 'Specify a registration number of the product you are working with.'");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Подключение1СТакскомКлиент.ОбработатьОткрытиеФормы(КонтекстВзаимодействия, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если НЕ ПрограммноеЗакрытие Тогда
		Подключение1СТакскомКлиент.ЗавершитьБизнесПроцесс(КонтекстВзаимодействия, ЗавершениеРаботы);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НадписьВыходаПользователяРегНомерНажатие(Элемент)
	
	Подключение1СТакскомКлиент.ОбработатьВыходПользователя(КонтекстВзаимодействия, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокЗарегистрированныхПродуктовРегНомерНажатие(Элемент)
	
	ИнтернетПоддержкаПользователейКлиент.ОткрытьЛичныйКабинетПользователя();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗарегистрироватьПродуктРегНомерНажатие(Элемент)
	
	ПараметрыЗапроса = Новый Массив;
	ПараметрыЗапроса.Добавить(Новый Структура("Имя, Значение", "registerProduct", "true"));
	
	Подключение1СТакскомКлиент.ОбработкаКомандСервиса(КонтекстВзаимодействия, ЭтотОбъект, ПараметрыЗапроса);
	
КонецПроцедуры

&НаКлиенте
Процедура ПояснениеКЗаголовкуРегНомерОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "TechSupport" Тогда
		
		СтандартнаяОбработка = Ложь;
		
		ТекстСообщения =
			НСтр("ru = 'Не получается ввести регистрационный номер программного продукта.';
				|en = 'Cannot enter registration number of the software product.'");
			
		Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.СообщенияВСлужбуТехническойПоддержки") Тогда
			
			МодульСообщенияВСлужбуТехническойПоддержкиКлиентСервер =
				ОбщегоНазначенияКлиент.ОбщийМодуль("СообщенияВСлужбуТехническойПоддержкиКлиентСервер");
			ДанныеСообщения = МодульСообщенияВСлужбуТехническойПоддержкиКлиентСервер.ДанныеСообщения();
			ДанныеСообщения.Получатель = "webIts";
			ДанныеСообщения.Тема       = НСтр("ru = 'Интернет-поддержка. Ввод регистрационного номера.';
												|en = 'Online support. Enter registration number.'");
			ДанныеСообщения.Сообщение  = ТекстСообщения;
			
			МодульСообщенияВСлужбуТехническойПоддержкиКлиент =
				ОбщегоНазначенияКлиент.ОбщийМодуль("СообщенияВСлужбуТехническойПоддержкиКлиент");
			МодульСообщенияВСлужбуТехническойПоддержкиКлиент.ОтправитьСообщение(
				ДанныеСообщения);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОКРегНомер(Команда)
	
	Если НЕ ЗаполнениеПолейКорректно() Тогда
		Возврат;
	КонецЕсли;
	
	Подключение1СТакскомКлиентСервер.ЗаписатьПараметрКонтекста(
		КонтекстВзаимодействия.КСКонтекст,
		"regnumber",
		РегистрационныйНомерРегНомер);
	
	ПараметрыЗапроса = Новый Массив;
	ПараметрыЗапроса.Добавить(Новый Структура("Имя, Значение", "regnumber", РегистрационныйНомерРегНомер));
	
	Подключение1СТакскомКлиент.ОбработкаКомандСервиса(КонтекстВзаимодействия, ЭтотОбъект, ПараметрыЗапроса);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Выполняет начальное заполнение полей формы
&НаСервере
Процедура ЗаполнитьФорму()
	
	ЗаголовокПользователя = НСтр("ru = 'Логин:';
								|en = 'Login:'") + " " + Параметры.login;
	
	Элементы.НадписьЛогинаПользователяРегНомер.Заголовок = ЗаголовокПользователя;
	РегистрационныйНомерРегНомер = Параметры.regNumber;
	
	СохранятьПароль = Истина;
	
КонецПроцедуры

&НаКлиенте
Функция ЗаполнениеПолейКорректно()
	
	Результат = Истина;
	
	Если ПустаяСтрока(РегистрационныйНомерРегНомер) Тогда
		
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = НСтр("ru = 'Не заполнено поле ""Регистрационный номер""';
								|en = 'Registration number is not filled in'");
		Сообщение.Поле  = "РегистрационныйНомерРегНомер";
		Сообщение.Сообщить();
		
		Результат = Ложь;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти
