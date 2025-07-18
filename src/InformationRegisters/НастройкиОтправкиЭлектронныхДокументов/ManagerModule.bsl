
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Отправитель)";
	
	Ограничение.ТекстДляВнешнихПользователей =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Отправитель)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

// СтандартныеПодсистемы.ОбновлениеВерсииИБ

// Регистрация данные к обработке для перехода на новую версию.
// 
// Параметры:
//  Параметры - См. ОбновлениеИнформационнойБазы.ОсновныеПараметрыОтметкиКОбработке
Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	МетаданныеОбъекта = Метаданные.РегистрыСведений.НастройкиОтправкиЭлектронныхДокументов;
	ПолноеИмяРегистра = МетаданныеОбъекта.ПолноеИмя();

	ДополнительныеПараметры = ОбновлениеИнформационнойБазы.ДополнительныеПараметрыОтметкиОбработки();
	ДополнительныеПараметры.ЭтоНезависимыйРегистрСведений = Истина;
	ДополнительныеПараметры.ПолноеИмяРегистра = ПолноеИмяРегистра;

	ПараметрыВыборки = Параметры.ПараметрыВыборки;
	ПараметрыВыборки.СпособВыборки        = ОбновлениеИнформационнойБазы.СпособВыборкиИзмеренияНезависимогоРегистраСведений();
	ПараметрыВыборки.ПолныеИменаРегистров = ПолноеИмяРегистра;

	ДанныеКОбработке = Новый ТаблицаЗначений;
	ДанныеКОбработке.Колонки.Добавить("Отправитель", МетаданныеОбъекта.Измерения.Отправитель.Тип);
	ДанныеКОбработке.Колонки.Добавить("Получатель", МетаданныеОбъекта.Измерения.Получатель.Тип);

	Выборка = ВыборкаДанныхКОбработкеДляПереходаНаНовуюВерсию();
	Пока Выборка.Следующий() Цикл
		НоваяЗапись = ДанныеКОбработке.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяЗапись, Выборка);
	КонецЦикла;

	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, ДанныеКОбработке, ДополнительныеПараметры);
	
КонецПроцедуры

// Обработать данные для перехода на новую версию.
// 
// Параметры:
//  Параметры - См. ОбновлениеИнформационнойБазы.ОсновныеПараметрыОтметкиКОбработке
Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	МетаданныеОбъекта = Метаданные.РегистрыСведений.НастройкиОтправкиЭлектронныхДокументов;
	ПолноеИмяОбъекта = МетаданныеОбъекта.ПолноеИмя();
	
	ВыборкаДанных = ОбновлениеИнформационнойБазы.ДанныеДляОбновленияВМногопоточномОбработчике(Параметры);
	Если Не ЗначениеЗаполнено(ВыборкаДанных) Тогда
		Параметры.ОбработкаЗавершена = ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(
			Параметры.Очередь, ПолноеИмяОбъекта);
		Возврат;
	КонецЕсли;
	
	РезультатСвертки = ОбработатьДанныеДляСворачиванияДублей(ВыборкаДанных);
	ОбработаноОбъектов = РезультатСвертки.ОбработаноОбъектов;
	ПроблемныхОбъектов = РезультатСвертки.ПроблемныхОбъектов;
	
	Если ОбработаноОбъектов = 0 И ПроблемныхОбъектов <> 0 Тогда
		ШаблонСообщения = НСтр("ru = 'Не удалось обработать некоторые настройки отправки электронных документов (пропущены): %1';
								|en = 'Cannot process some electronic document sending settings (skipped): %1'");
		ТекстСообщения = СтрШаблон(ШаблонСообщения, ПроблемныхОбъектов);
		ВызватьИсключение ТекстСообщения;
	Иначе
		ШаблонСообщения = НСтр("ru = 'Обработана очередная порция настроек отправки электронных документов: %1';
								|en = 'Another set of electronic document sending settings is processed: %1'");
		ТекстСообщения = СтрШаблон(ШаблонСообщения, ОбработаноОбъектов);
		ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
			УровеньЖурналаРегистрации.Информация,
			МетаданныеОбъекта,, ТекстСообщения);
	КонецЕсли;
	
	Параметры.ПрогрессВыполнения.ОбработаноОбъектов =
		Параметры.ПрогрессВыполнения.ОбработаноОбъектов + ОбработаноОбъектов;
	
	Параметры.ОбработкаЗавершена = ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(
		Параметры.Очередь, ПолноеИмяОбъекта);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ОбновлениеВерсииИБ

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Возвращаемое значение:
//  ВыборкаИзРезультатаЗапроса:
// * Отправитель - См. РегистрСведений.НастройкиОтправкиЭлектронныхДокументов.Отправитель
// * Получатель - См. РегистрСведений.НастройкиОтправкиЭлектронныхДокументов.Получатель
Функция ВыборкаДанныхКОбработкеДляПереходаНаНовуюВерсию()

	УсловияОтбораДанныхКОбработке = Новый Массив;
	ПараметрыЗапроса = Новый Структура;
	ДобавитьУсловиеОтбораЗаписейСОшибочнымЗначенимПоляДоговор(УсловияОтбораДанныхКОбработке, ПараметрыЗапроса);

	ШаблонЗапроса = "ВЫБРАТЬ РАЗЛИЧНЫЕ
					|	Отправитель,
					|	Получатель
					|ИЗ
					|	РегистрСведений.НастройкиОтправкиЭлектронныхДокументов
					|ГДЕ
					|	&УсловиеОтбора";
	Запрос = Новый Запрос;
	Если ЗначениеЗаполнено(УсловияОтбораДанныхКОбработке) Тогда
		УсловиеОтбораСтрокой = СтрСоединить(УсловияОтбораДанныхКОбработке, " ИЛИ ");
	Иначе
		УсловиеОтбораСтрокой = "ЛОЖЬ";
	КонецЕсли;
	Запрос.Текст = СтрЗаменить(ШаблонЗапроса, "&УсловиеОтбора", УсловиеОтбораСтрокой);
	Для Каждого ИмяИЗначение Из ПараметрыЗапроса Цикл
		Запрос.УстановитьПараметр(ИмяИЗначение.Ключ, ИмяИЗначение.Значение);
	КонецЦикла;

	Возврат Запрос.Выполнить().Выбрать();

КонецФункции

// Параметры:
//  УсловияОтбораДанныхКОбработке - Массив Из Строка
//  ПараметрыЗапроса - Структура Из КлючИЗначение
Процедура ДобавитьУсловиеОтбораЗаписейСОшибочнымЗначенимПоляДоговор(УсловияОтбораДанныхКОбработке, ПараметрыЗапроса)

	ПустыеЗначения = ОбменСКонтрагентамиИнтеграция.ВсеПустыеЗначенияДоговораСКонтрагентомЭДО();
	ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПустыеЗначения, Неопределено);
	ВозможноДублированиеЗаписей = ПустыеЗначения.Количество() > 1;

	Если ВозможноДублированиеЗаписей Тогда
		УсловияОтбораДанныхКОбработке.Добавить("Договор В (&ПустыеЗначенияСОшибкой)");
		ПараметрыЗапроса.Вставить("ПустыеЗначенияСОшибкой", ПустыеЗначения);
	КонецЕсли;

КонецПроцедуры

// Параметры:
//  КлючиКОбработке - ТаблицаЗначений:
// * Отправитель - См. РегистрСведений.НастройкиОтправкиЭлектронныхДокументов.Отправитель
// * Получатель - См. РегистрСведений.НастройкиОтправкиЭлектронныхДокументов.Получатель
// 
// Возвращаемое значение:
//  ВыборкаИзРезультатаЗапроса:
// * Отправитель - См. РегистрСведений.НастройкиОтправкиЭлектронныхДокументов.Отправитель
// * Получатель - См. РегистрСведений.НастройкиОтправкиЭлектронныхДокументов.Получатель
// * Договор - См. РегистрСведений.НастройкиОтправкиЭлектронныхДокументов.Договор
Функция ВыборкаЗаписейДублейИзмеренияДоговор(КлючиКОбработке)
	Запрос = Новый Запрос;
	ПустойДоговор = ОбменСКонтрагентамиИнтеграция.ВсеПустыеЗначенияДоговораСКонтрагентомЭДО();
	Запрос.УстановитьПараметр("ПустойДоговор", ПустойДоговор);
	Запрос.УстановитьПараметр("КлючиКОбработке", КлючиКОбработке);
	Запрос.Текст = "ВЫБРАТЬ
				   |	Отправитель,
				   |	Получатель
				   |ПОМЕСТИТЬ КлючиКОбработке
				   |ИЗ
				   |	&КлючиКОбработке КАК КлючиКОбработке
				   |;
				   |
				   |ВЫБРАТЬ
				   |	НастройкиОтправкиЭлектронныхДокументов.Отправитель,
				   |	НастройкиОтправкиЭлектронныхДокументов.Получатель,
				   |	НастройкиОтправкиЭлектронныхДокументов.Договор
				   |ИЗ
				   |	РегистрСведений.НастройкиОтправкиЭлектронныхДокументов КАК НастройкиОтправкиЭлектронныхДокументов
				   |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ КлючиКОбработке КАК КлючиКОбработке
				   |		ПО НастройкиОтправкиЭлектронныхДокументов.Отправитель = КлючиКОбработке.Отправитель
				   |		И НастройкиОтправкиЭлектронныхДокументов.Получатель = КлючиКОбработке.Получатель
				   |		И НастройкиОтправкиЭлектронныхДокументов.Договор В (&ПустойДоговор)
				   |
				   |УПОРЯДОЧИТЬ ПО
				   |	НастройкиОтправкиЭлектронныхДокументов.Отправитель,
				   |	НастройкиОтправкиЭлектронныхДокументов.Получатель,
				   |	НастройкиОтправкиЭлектронныхДокументов.ДатаНачалаДействия,
				   |	ВЫБОР
				   |		КОГДА НастройкиОтправкиЭлектронныхДокументов.Договор = НЕОПРЕДЕЛЕНО
				   |			ТОГДА 2
				   |		ИНАЧЕ 1
				   |	КОНЕЦ
				   |	";
	Возврат Запрос.Выполнить().Выбрать();
КонецФункции

Функция ОбработатьДанныеДляСворачиванияДублей(КлючиКОбработке)
	
	ОбработаноОбъектов = 0;
	ПроблемныхОбъектов = 0;
	МетаданныеОбъекта = Метаданные.РегистрыСведений.НастройкиОтправкиЭлектронныхДокументов;
	
	ДетальныеЗаписи = ВыборкаЗаписейДублейИзмеренияДоговор(КлючиКОбработке);
	ПустойДоговор = ОбменСКонтрагентамиИнтеграция.ВсеПустыеЗначенияДоговораСКонтрагентомЭДО();
	
	Отбор = Новый Структура("Отправитель, Получатель");
	
	Наборы = Новый Структура;
	Наборы.Вставить("НовыйОсновной", СоздатьНаборЗаписей());
	Наборы.Вставить("ОсновнойДляОчистки", СоздатьНаборЗаписей());
	Наборы.Вставить("НовыйСвязанный", РегистрыСведений.НастройкиОтправкиЭлектронныхДокументовПоВидам.СоздатьНаборЗаписей());
	Наборы.Вставить("СвязанныйДляОчистки", РегистрыСведений.НастройкиОтправкиЭлектронныхДокументовПоВидам.СоздатьНаборЗаписей());
	
	Для Каждого ИмяИНабор Из Наборы Цикл
		Если ИмяИНабор.Ключ = "НовыйОсновной" Тогда
			Продолжить;
		КонецЕсли;
		ИмяИНабор.Значение.ОбменДанными.Загрузка = Истина;
	КонецЦикла;
	
	Для Каждого Ключ Из КлючиКОбработке Цикл
		ДетальныеЗаписи.Сбросить();
		ЗаполнитьЗначенияСвойств(Отбор, Ключ);
		Если ДетальныеЗаписи.НайтиСледующий(Отбор) Тогда
			Для Каждого ИмяИЗначениеИзмерения Из Отбор Цикл
				Для Каждого НазначениеИНаборЗаписей Из Наборы Цикл
					НазначениеИНаборЗаписей.Значение.Отбор[ИмяИЗначениеИзмерения.Ключ].Установить(ИмяИЗначениеИзмерения.Значение);
				КонецЦикла;
			КонецЦикла;
			Блокировка = Новый БлокировкаДанных;
			ЭлементБлокировкиОсновногоНабора = Блокировка.Добавить("РегистрСведений.НастройкиОтправкиЭлектронныхДокументов");
			ЭлементБлокировкиОсновногоНабора.УстановитьЗначение("Отправитель", Отбор.Отправитель);
			ЭлементБлокировкиОсновногоНабора.УстановитьЗначение("Получатель", Отбор.Получатель);
			ЭлементБлокировкиОсновногоНабора.Режим = РежимБлокировкиДанных.Исключительный;
			ЭлементБлокировкиСвязанногоНабора = Блокировка.Добавить("РегистрСведений.НастройкиОтправкиЭлектронныхДокументовПоВидам");
			ЭлементБлокировкиСвязанногоНабора.УстановитьЗначение("Отправитель", Отбор.Отправитель);
			ЭлементБлокировкиСвязанногоНабора.УстановитьЗначение("Получатель", Отбор.Получатель);
			ЭлементБлокировкиСвязанногоНабора.Режим = РежимБлокировкиДанных.Исключительный;
			НачатьТранзакцию();
			Попытка
				Блокировка.Заблокировать();
				Наборы.НовыйОсновной.Отбор.Договор.Установить(ДетальныеЗаписи.Договор);
				Наборы.НовыйОсновной.Прочитать();
				Наборы.НовыйСвязанный.Отбор.Договор.Установить(ДетальныеЗаписи.Договор);
				Наборы.НовыйСвязанный.Прочитать();
				Для Каждого Вариант Из ПустойДоговор Цикл
					Наборы.ОсновнойДляОчистки.Отбор.Договор.Установить(Вариант);
					Наборы.ОсновнойДляОчистки.Записать();
					Наборы.СвязанныйДляОчистки.Отбор.Договор.Установить(Вариант);
					Наборы.СвязанныйДляОчистки.Записать();
				КонецЦикла;
				
				Наборы.НовыйОсновной.Отбор.Договор.Значение = Неопределено;
				Наборы.НовыйСвязанный.Отбор.Договор.Значение = Неопределено;
				Для Каждого Запись Из Наборы.НовыйОсновной Цикл
					Запись.Договор = Неопределено;
				КонецЦикла;
				Для Каждого Запись Из Наборы.НовыйСвязанный Цикл
					Запись.Договор = Неопределено;
				КонецЦикла;
				
				Наборы.НовыйСвязанный.Записать();
				ОбновлениеИнформационнойБазы.ЗаписатьНаборЗаписей(Наборы.НовыйОсновной);
				
				ОбработаноОбъектов = ОбработаноОбъектов + 1;
				ЗафиксироватьТранзакцию();
			Исключение
				ОтменитьТранзакцию();
				ПроблемныхОбъектов = ПроблемныхОбъектов + 1;
				СтруктураКлючаЗаписи = ОбщегоНазначения.СтрокаТаблицыЗначенийВСтруктуру(Ключ);
				КлючЗаписиСтрокой = ОбщегоНазначенияБЭДКлиентСервер.СтруктураВСтроку(СтруктураКлючаЗаписи);
				ТекстСообщения = СтрШаблон(НСтр("ru = 'Не удалось обработать настройки отправки электронных документов для: %1 по причине:
					|%2';
					|en = 'Cannot process electronic document sending settings for: %1 due to:
					|%2'"), Ключ.Отправитель, ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
				ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
					УровеньЖурналаРегистрации.Ошибка, МетаданныеОбъекта, КлючЗаписиСтрокой, ТекстСообщения);
			КонецПопытки;
		КонецЕсли;
	КонецЦикла;
	Возврат НовыйРезультатОбработки(ОбработаноОбъектов, ПроблемныхОбъектов);
	
КонецФункции

Функция НовыйРезультатОбработки(ОбработаноОбъектов, ПроблемныхОбъектов)
	Возврат Новый ФиксированнаяСтруктура("ОбработаноОбъектов, ПроблемныхОбъектов", ОбработаноОбъектов, ПроблемныхОбъектов);
КонецФункции

#КонецОбласти

#КонецЕсли