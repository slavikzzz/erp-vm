///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОписаниеПеременных

&НаКлиенте
Перем ВсеОповещения;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	ЭтотОбъект.РольДоступнаАдминистратор = ОбработкаНовостейПовтИсп.ЭтоАдминистратор();

	Если ОбработкаНовостейПовтИсп.РазрешенаРаботаСНовостямиЧерезИнтернет() = Истина Тогда
		Элементы.ДекорацияРежимРаботыСНовостямиЧерезИнтернет_ОбновлениеКлассификаторов.Видимость = Ложь;
	КонецЕсли;

	ЭтотОбъект.ОткрытаИзОбработки_УправлениеНовостями = Параметры.ОткрытаИзОбработки_УправлениеНовостями;

	ЭтотОбъект.Список.Параметры.УстановитьЗначениеПараметра("Надпись_ТребуетсяОбновление", НСтр("ru = 'Требуется обновление';
																								|en = 'Update required'"));
	ЭтотОбъект.Список.Параметры.УстановитьЗначениеПараметра("Надпись_ДанныеАктуальны", НСтр("ru = 'Данные актуальны';
																							|en = 'Relevant data'"));
	ЭтотОбъект.Список.Параметры.УстановитьЗначениеПараметра("ПустаяДата", '00010101');

	ОбновитьИнформационныеСтроки();

	УстановитьУсловноеОформление();

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	ВсеОповещения = ОбработкаНовостейКлиент.ВсеОповещения();

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)

	// В некоторых случаях ОбработкаОповещения может вызваться раньше чем ПриОткрытии.
	// Проверим это и инициализируем ВсеОповещения заново.
	ТипФиксированнаяСтруктура = Тип("ФиксированнаяСтруктура");
	Если ТипЗнч(ВсеОповещения) <> ТипФиксированнаяСтруктура Тогда
		ВсеОповещения = ОбработкаНовостейКлиент.ВсеОповещения();
	КонецЕсли;

	// Событие не имеет отношения к новостям.
	Если НЕ ОбработкаНовостейКлиент.ЕстьКлючПоЗначению(ВсеОповещения, ИмяСобытия) Тогда
		Возврат;
	КонецЕсли;

	Если ИмяСобытия = ВсеОповещения.КлассификаторыОбновлены Тогда // Идентификатор.
		Элементы.Список.Обновить();
		ОбновитьИнформационныеСтроки();
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДекорацияТребуетсяОбновлениеССервераОбработкаНавигационнойСсылки(
			Элемент,
			НавигационнаяСсылкаФорматированнойСтроки,
			СтандартнаяОбработка)

	Если ВРег(НавигационнаяСсылкаФорматированнойСтроки) = ВРег("Update") Тогда

		СтандартнаяОбработка = Ложь;

		ОткрытьФорму(
			"Обработка.УправлениеНовостями.Форма.ФормаНастроекНовостей",
			Новый Структура("ТекущаяСтраница", "СтраницаОбновленияСтандартныхСписков"),
			ЭтотОбъект,
			"");

	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОбновитьССервера(Команда)

	ОткрытьФорму(
		"Обработка.УправлениеНовостями.Форма.ФормаНастроекНовостей",
		Новый Структура("ТекущаяСтраница", "СтраницаОбновленияСтандартныхСписков"),
		ЭтотОбъект,
		"");

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
// Процедура обновляет все информационные надписи.
//
// Параметры:
//  Нет.
//
Процедура ОбновитьИнформационныеСтроки()

	// Проверка необходимости обновления и вывод сообщения в декорации. Начало.

	ТребуетсяОбновление = Ложь;

	Запись = РегистрыСведений.ДатыОбновленияСтандартныхСписковНовостей.СоздатьМенеджерЗаписи();
	Запись.Список = "Список категорий новостей"; // Идентификатор.
	Запись.Прочитать(); // Только чтение, без последующей записи.

	Если Запись.Выбран() Тогда
		Если Запись.ТекущаяВерсияНаКлиенте >= Запись.ТекущаяВерсияНаСервере Тогда
			ТекстНадписи = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Данные актуальны и соответствуют данным с сервера от %1.';
					|en = 'Data is relevant and corresponds to the data from the server from %1.'"),
				Формат(Запись.ТекущаяВерсияНаСервере, "ДЛФ=DT"));
			ТребуетсяОбновление = Ложь;
		Иначе // Устарели
			Если Запись.ТекущаяВерсияНаКлиенте = '00010101' Тогда
				ТекстНадписи = НСтр("ru = 'Данные никогда не обновлялись с сервера,
					|а на сервере уже версия от %2.';
					|en = 'Data has never been updated from the server.
					|The version on the server is dated %2.'");
			Иначе
				ТекстНадписи = НСтр("ru = 'Последний раз данные обновлялись с сервера %1,
					|а на сервере уже версия от %2.';
					|en = 'Last time the data was updated from the server was %1 and on the server the version is from %2.
					|'");
			КонецЕсли;
			ТекстНадписи = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				ТекстНадписи,
				Формат(Запись.ТекущаяВерсияНаКлиенте, "ДЛФ=DT"),
				Формат(Запись.ТекущаяВерсияНаСервере, "ДЛФ=DT"));
			ТребуетсяОбновление = Истина;
		КонецЕсли;
	Иначе
		ТекстНадписи = НСтр("ru = 'Данные никогда не обновлялись с сервера.';
							|en = 'Data has never been updated from the server.'");
		ТребуетсяОбновление = Истина;
	КонецЕсли;

	Если ПолучитьФункциональнуюОпцию("РазрешенаРаботаСНовостямиЧерезИнтернет") = Истина Тогда
		Если (ЭтотОбъект.РольДоступнаАдминистратор = Истина) Тогда
			// Если эта форма открыта из формы обработки "Управление новостями", то
			//  не давать снова открывать форму обработки.
			Если ЭтотОбъект.ОткрытаИзОбработки_УправлениеНовостями = Истина Тогда
				Элементы.ДекорацияТребуетсяОбновлениеССервера.Заголовок = ТекстНадписи;
				Если ТребуетсяОбновление = Истина Тогда
					Элементы.ДекорацияТребуетсяОбновлениеССервера.ЦветТекста = ЦветаСтиля.ЦветОсобогоТекста;
				Иначе
					Элементы.ДекорацияТребуетсяОбновлениеССервера.ЦветТекста = ЦветаСтиля.ЦветМикротекста;
				КонецЕсли;
			Иначе
				Элементы.ДекорацияТребуетсяОбновлениеССервера.Заголовок   = Новый ФорматированнаяСтрока(
					ТекстНадписи + " ",
					Новый ФорматированнаяСтрока(
						НСтр("ru = 'Проверить обновления.';
							|en = 'Check for updates.'"),
						,
						ЦветаСтиля.ГиперссылкаЦвет,
						,
						"Update"));
			КонецЕсли;
		Иначе
			Элементы.ДекорацияТребуетсяОбновлениеССервера.Заголовок   = ТекстНадписи;
			Если ТребуетсяОбновление = Истина Тогда
				Элементы.ДекорацияТребуетсяОбновлениеССервера.ЦветТекста = ЦветаСтиля.ЦветОсобогоТекста;
			Иначе
				Элементы.ДекорацияТребуетсяОбновлениеССервера.ЦветТекста = ЦветаСтиля.ЦветМикротекста;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;

	// Проверка необходимости обновления и вывод сообщения в декорации. Конец.

КонецПроцедуры

// Процедура устанавливает условное оформление в форме.
//
// Параметры:
//  Нет.
//
&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	// 1. Автоматически заполняемые элементы - серым цветом.
		Элемент = УсловноеОформление.Элементы.Добавить();

		// Оформляемые поля
		ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
		ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Список.Имя);

		// Отбор
		ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.ЗаполняетсяАвтоматически");
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ОтборЭлемента.ПравоеЗначение = Истина;

		// Оформление
		Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветНедоступногоТекста);

		// Использование
		Элемент.Использование = Истина;

	// 2. Список, Обновление с сервера: требуется обновление
		Элемент = УсловноеОформление.Элементы.Добавить();

		// Оформляемые поля
		ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
		ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТребуетсяОбновление.Имя);

		// Отбор
		ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.ТребуетсяОбновление");
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ОтборЭлемента.ПравоеЗначение = НСтр("ru = 'Требуется обновление';
											|en = 'Update required'");

		// Оформление
		Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветОсобогоТекста);

		// Использование
		Элемент.Использование = Истина;

	// 3. Список, Обновление с сервера: данные актуальны
		Элемент = УсловноеОформление.Элементы.Добавить();

		// Оформляемые поля
		ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
		ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТребуетсяОбновление.Имя);

		// Отбор
		ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.ТребуетсяОбновление");
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ОтборЭлемента.ПравоеЗначение = НСтр("ru = 'Данные актуальны';
											|en = 'Relevant data'");

		// Оформление
		Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветМикротекста);

		// Использование
		Элемент.Использование = Истина;

	// 4. Список, Обновление с сервера: не обновляется с сервера
		Элемент = УсловноеОформление.Элементы.Добавить();

		// Оформляемые поля
		ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
		ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТребуетсяОбновление.Имя);

		// Отбор
		ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.ТребуетсяОбновление");
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;

		// Оформление
		Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветМикротекста);
		Элемент.Оформление.УстановитьЗначениеПараметра("Текст", "");
		Элемент.Оформление.УстановитьЗначениеПараметра("Отображать", Ложь);

		// Использование
		Элемент.Использование = Истина;

КонецПроцедуры

#КонецОбласти
