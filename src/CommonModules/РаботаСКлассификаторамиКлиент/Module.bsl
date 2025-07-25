///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Подсистема "ИнтернетПоддержкаПользователей.РаботаСКлассификаторами".
// ОбщийМодуль.РаботаСКлассификаторамиКлиент.
//
// Клиентские процедуры и функции загрузки классификаторов:
//  - обработка событий панели Интернет-поддержка и сервисы;
//  - переход к интерактивному обновлению классификаторов;
//  - настройка автоматической загрузки обновлений классификаторов;
//  - оповещение об изменении данных классификаторов.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Формирует параматры интерактивной загрузки классификаторов.
//
// Параметры:
//  Владелец - ФормаКлиентскогоПриложения - форма которая будет установлена в качестве владельца.
//  Идентификаторы - Массив из Строка, Неопределено - идентификаторы классификаторов,
//   которые необходимо обновить.
//  ОписаниеОповещения - ОписаниеОповещения - оповещение, которое будет вызвано после закрытия формы.
//   В качестве результата оповещения передается массив из обновленных идентификаторов классификаторов.
//
// Возвращаемое значение:
//  Структура - параметры обновления классификаторов:
//   *Владелец - ФормаКлиентскогоПриложения - форма которая будет установлена в качестве владельца.
//   *Идентификаторы - Массив из Строка, Неопределено - идентификаторы классификаторов,
//     которые необходимо обновить.
//   *ОписаниеОповещения - ОписаниеОповещения - оповещение, которое будет вызвано после закрытия формы.
//     В качестве результата оповещения передается массив из обновленных идентификаторов классификаторов.
//
Функция НовыйПараметрыОбновленияКлассификаторов(
		Владелец = Неопределено,
		Идентификаторы = Неопределено,
		ОписаниеОповещения = Неопределено) Экспорт
	
	Параметры = Новый Структура;
	Параметры.Вставить("Владелец", Владелец);
	Параметры.Вставить("Идентификаторы", Идентификаторы);
	Параметры.Вставить("ОписаниеОповещения", ОписаниеОповещения);
	
	Возврат Параметры;
	
КонецФункции

// Открывает помощник обновления классификаторов.
//
// Параметры:
//  ПараметрыОбновления - Структура, Неопределено - см. НовыйПараметрыОбновленияКлассификаторов.
//
Процедура ОбновитьКлассификаторы(ПараметрыОбновления = Неопределено) Экспорт
	
	Параметры = НовыйПараметрыОбновленияКлассификаторов();
	ИдентификаторыОтбор = Новый СписокЗначений;
	
	Если ПараметрыОбновления <> Неопределено Тогда
		ЗаполнитьЗначенияСвойств(
			Параметры,
			ПараметрыОбновления);
		ИдентификаторыОтбор.ЗагрузитьЗначения(
			Параметры.Идентификаторы);
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ИдентификаторыОтбор", ИдентификаторыОтбор);
	
	ОткрытьФорму(
		"Обработка.ОбновлениеКлассификаторов.Форма.Форма",
		ПараметрыФормы,
		Параметры.Владелец,
		,
		,
		,
		Параметры.ОписаниеОповещения);
	
КонецПроцедуры

// Определяет имя события, которое будет содержать оповещение
// о завершении загрузки классификаторов.
//
// Возвращаемое значение:
//  Строка - Имя события. Может быть использовано для идентификации
//           сообщений принимающими их формами.
//
Функция ИмяСобытияОповещенияОЗагрузки() Экспорт
	
	Возврат "РаботаСКлассификаторами.ЗагруженыКлассификаторы";
	
КонецФункции

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.НастройкиПрограммы

// Обработчик события навигационной ссылки формы
// БИПДекорацияОбновлениеКлассификаторовНеВыполняетсяОбработкаНавигационнойСсылки
// на форме панели администрирования "Интернет-поддержка и сервисы"
// Библиотеки стандартных подсистем.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма панели администрирования;
//  Элемент - ЭлементФормы - поле ввода информации;
//  НавигационнаяСсылкаФорматированнойСтроки - Строка - навигационная ссылка;
//  СтандартнаяОбработка - Булево - признак стандартной обработки ссылки.
//
Процедура ИнтернетПоддержкаИСервисы_БИПДекорацияОбновлениеКлассификаторовНеВыполняетсяОбработкаНавигационнойСсылки(
		Форма,
		Элемент,
		НавигационнаяСсылкаФорматированнойСтроки,
		СтандартнаяОбработка) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	Если Не ИнтернетПоддержкаПользователейКлиент.ДоступноПодключениеИнтернетПоддержки() Тогда
		ПоказатьПредупреждение(,
			НСтр("ru = 'Для автоматического обновления классификаторов необходимо
				|подключить Интернет-поддержку пользователей.';
				|en = 'To update classifiers automatically, 
				|enable online user support.'"));
		Возврат;
	КонецЕсли;
	
	ИнтернетПоддержкаПользователейКлиент.ПодключитьИнтернетПоддержкуПользователей(
		Неопределено,
		Форма);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.НастройкиПрограммы

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Вызывается при начале работы системы из
// ИнтернетПоддержкаПользователейКлиент.ПриНачалеРаботыСистемы().
//
Процедура ПриНачалеРаботыСистемы() Экспорт
	
	ПараметрыРаботыКлиентаПриЗапуске = СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиентаПриЗапуске();
	Если Не ПараметрыРаботыКлиентаПриЗапуске.ДоступноИспользованиеРазделенныхДанных Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыИПП = ПараметрыРаботыКлиентаПриЗапуске.ИнтернетПоддержкаПользователей;
	Если ПараметрыИПП.ОповещениеОбновленияКлассификаторов Тогда
		
		ПодключитьОбработчикОжидания(
			"УведомлениеОВключенииОбновленияКлассификаторов",
			1,
			Истина);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Определяет идентификаторы и номера версий, которые содержит файла с обновлениями.
//
// Параметры:
//  ИмяФайла - Строка - расположение архива с классификаторами.
//
// Возвращаемое значение:
//  Массив - содержит идентификаторы классификаторов и номер версий.
//
Функция ВерсииКлассификаторовВФайле(ИмяФайла) Экспорт
	
	#Если Не ВебКлиент Тогда
	
	ВерсииКлассификаторов = Новый Массив;
	
	Если ОбщегоНазначенияКлиентСервер.ПолучитьРасширениеИмениФайла(ИмяФайла) <> "zip" Тогда
		Возврат ВерсииКлассификаторов;
	КонецЕсли;
	
	// АПК:574-выкл код не используется в мобильном клиенте
	
	ЧтениеZipФайла = Новый ЧтениеZipФайла(ИмяФайла);
	Для Каждого Элемент Из ЧтениеZipФайла.Элементы Цикл
		
		// Зашифрованные элементы архива не обрабатываются.
		Если Элемент.Зашифрован Тогда
			Продолжить;
		КонецЕсли;
		
		ПозицияРазделителя = СтрНайти(Элемент.ИмяБезРасширения, "_", НаправлениеПоиска.СКонца);
		
		// Если имя файла не соответствует шаблону [Идентификатор]_[Версия], подсистема не должна
		// выполнять его обработку.
		Если ПозицияРазделителя = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		Попытка
			Версия        = Число(СтрЗаменить(Сред(Элемент.ИмяБезРасширения, ПозицияРазделителя + 1), Символы.НПП, ""));
			Идентификатор = Лев(Элемент.ИмяБезРасширения, ПозицияРазделителя - 1);
		Исключение
			Версия = Неопределено;
			Идентификатор = Неопределено;
		КонецПопытки;
		
		// Если имя файла содержит не корректные данные, подсистема не должна
		// выполнять его обработку.
		Если Не ЗначениеЗаполнено(Идентификатор) Или Не ЗначениеЗаполнено(Версия) Тогда
			Продолжить;
		КонецЕсли;
		
		ОписаниеВерсии = Новый Структура;
		ОписаниеВерсии.Вставить("Идентификатор", Идентификатор);
		ОписаниеВерсии.Вставить("Версия",        Версия);
		ОписаниеВерсии.Вставить("Имя",           Элемент.Имя);
		ВерсииКлассификаторов.Добавить(ОписаниеВерсии);
		
	КонецЦикла;
	
	ЧтениеZipФайла.Закрыть();
	
	// АПК:574-вкл
	
	Возврат ВерсииКлассификаторов;
	
	#Иначе
	
	ВызватьИсключение НСтр("ru = 'Интерактивная загрузка архива с классификаторами при работе в веб-клиенте запрещена.';
							|en = 'Interactive import of archive with classifiers while working in the web client is prohibited.'");
	
	#КонецЕсли
	
КонецФункции

// Возвращает имя события для журнала регистрации
//
// Возвращаемое значение:
//  Строка - имя события.
//
Функция ИмяСобытияЖурналаРегистрации() Экспорт
	
	Возврат НСтр("ru = 'Работа с классификаторами';
				|en = 'Classifier operations'",
		ОбщегоНазначенияКлиент.КодОсновногоЯзыка());
	
КонецФункции

#КонецОбласти
