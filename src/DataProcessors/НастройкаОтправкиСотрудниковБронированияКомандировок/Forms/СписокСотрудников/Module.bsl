#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	РегулярнаяОтправкаСотрудников.ПроверитьИспользуетсяАвтоматическаяОтправкаСотрудников();

	ПараметрыФормы = ЭтотОбъект.Параметры;
	ЗакрыватьПриЗакрытииВладельца = ПараметрыФормы.ЗакрыватьПриЗакрытииВладельца;
	СистемаБронирования = ПараметрыФормы.СистемаБронирования;
	ВидСписка = ПараметрыФормы.ВидСписка;
	Отправляется.Добавить(Истина);
	ПричиныОтправки.Добавить(Перечисления.ПричиныОтправкиСотрудниковБронированияКомандировок.ПоУсловию);

	Если ВидСписка = "СотрудникиОтправляемыеПоУсловию" Тогда
		Для Каждого ЭлементОтбора Из Сотрудники.КомпоновщикНастроек.Настройки.Отбор.Элементы Цикл
			Если ЭлементОтбора.Представление = "ДатаПоследнейНеудачнойОтправки"
				Или ЭлементОтбора.Представление = "ДатаПоследнейУдачнойОтправки" Тогда
				ЭлементОтбора.Использование = Ложь;
			КонецЕсли;
		КонецЦикла;
		Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Сотрудники, отправляемые в систему %1 в соответствии с настройкой по подразделениям';
				|en = 'Employees to sent to %1 system in accordance with business unit setup'"), Строка(СистемаБронирования));
	ИначеЕсли ВидСписка = "ПоследниеОтправленныеСотрудники" Тогда
		Отправляется.Добавить(Ложь);
		ПричиныОтправки.Добавить(Перечисления.ПричиныОтправкиСотрудниковБронированияКомандировок.Непосредственно);
		Для Каждого ЭлементОтбора Из Сотрудники.КомпоновщикНастроек.Настройки.Отбор.Элементы Цикл
			Если ЭлементОтбора.Представление = "ДатаПоследнейНеудачнойОтправки" Тогда
				ЭлементОтбора.Использование = Ложь;
			ИначеЕсли ЭлементОтбора.Представление = "ДатаПоследнейУдачнойОтправки" Тогда
				ЭлементОтбора.Использование = Истина;
				ЭлементОтбора.ПравоеЗначение = ПараметрыФормы.ДатаПоследнейОперации;
			КонецЕсли;
		КонецЦикла;
		Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Сотрудники, успешно отправленные в систему %1';
				|en = 'Employees successfully sent to %1 system'"), Строка(СистемаБронирования));
	ИначеЕсли ВидСписка = "ПоследниеНеотправленныеСотрудники" Тогда
		Отправляется.Добавить(Ложь);
		ПричиныОтправки.Добавить(Перечисления.ПричиныОтправкиСотрудниковБронированияКомандировок.Непосредственно);
		Для Каждого ЭлементОтбора Из Сотрудники.КомпоновщикНастроек.Настройки.Отбор.Элементы Цикл
			Если ЭлементОтбора.Представление = "ДатаПоследнейУдачнойОтправки" Тогда
				ЭлементОтбора.Использование = Ложь;
			ИначеЕсли ЭлементОтбора.Представление = "ДатаПоследнейНеудачнойОтправки" Тогда
				ЭлементОтбора.Использование = Истина;
				ЭлементОтбора.ПравоеЗначение = ПараметрыФормы.ДатаПоследнейОперации;
			КонецЕсли;
		КонецЦикла;
		Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Сотрудники, не отправленные в систему %1 из-за наличия ошибок';
				|en = 'Employees not sent to %1 system due to errors'"), Строка(СистемаБронирования));
	Иначе
		Отказ = Истина;
	КонецЕсли;

	Сотрудники.Параметры.УстановитьЗначениеПараметра("Отправляется", Отправляется);
	Сотрудники.Параметры.УстановитьЗначениеПараметра("ПричиныОтправки", ПричиныОтправки);
	Сотрудники.Параметры.УстановитьЗначениеПараметра("СистемаБронирования", СистемаБронирования);

КонецПроцедуры

&НаКлиенте
Процедура СотрудникиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)

	Если ВидСписка = "ПоследниеНеотправленныеСотрудники" Тогда

		ТекущиеДанные = Элементы.Сотрудники.ТекущиеДанные;
		Если Не ТекущиеДанные = Неопределено Тогда
			ПараметрыОткрытияФормы = Новый Структура;
			ПараметрыОткрытияФормы.Вставить("Сотрудник", ТекущиеДанные.Сотрудник);
			ПараметрыОткрытияФормы.Вставить("ОписаниеОшибки", ТекущиеДанные.Комментарий);
			ОткрытьФорму("Обработка.НастройкаОтправкиСотрудниковБронированияКомандировок.Форма.ФормаОшибки", ПараметрыОткрытияФормы, ЭтотОбъект);
		КонецЕсли

	ИначеЕсли ВидСписка = "СотрудникиОтправляемыеПоУсловию" Или ВидСписка = "ПоследниеОтправленныеСотрудники" Тогда

		ТекущиеДанные = Элементы.Сотрудники.ТекущиеДанные;
		Если Не ТекущиеДанные = Неопределено Тогда
			ПоказатьЗначение(,ТекущиеДанные.Сотрудник);
		КонецЕсли;

	КонецЕсли;

КонецПроцедуры

#КонецОбласти

