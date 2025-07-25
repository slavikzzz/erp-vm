
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	СформироватьСпискиВыбора();
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Объект.ЛистДекларации = "02";
		ПриЧтенииСозданииНаСервере();
	КонецЕсли;
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПриЧтенииСозданииНаСервере();
	
	СобытияФорм.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура КодМестаПредставленияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Заголовок",          НСтр("ru = 'Выбор кода операции';
														|en = 'Select an operation code'"));
	ПараметрыФормы.Вставить("ТаблицаЗначений",    КодыМестаПредставления);
	ПараметрыФормы.Вставить("СтруктураДляПоиска", Новый Структура("Код", Объект.КодМестаПредставления));
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыборКодаМестаПредставленияЗавершение", ЭтотОбъект);
	ОткрытьФорму("Обработка.ОбщиеОбъектыРеглОтчетности.Форма.ФормаВыбораЗначенияИзТаблицы",
		ПараметрыФормы,
		ЭтотОбъект,
		УникальныйИдентификатор, , ,
		ОписаниеОповещения,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
КонецПроцедуры

&НаКлиенте
Процедура ЛистДекларацииПриИзменении(Элемент)
	
	Объект.ПризнакНалогоплательщика = "";
	Объект.КодВидаДохода = "";
	Объект.НомерДокумента = "";
	УправлениеЭлементамиФормы(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПризнакНалогоплательщикаПриИзменении(Элемент)
	
	Объект.НомерДокумента = "";
	УправлениеЭлементамиФормы(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()
	
	Места = КодыМестаПредставления.НайтиСтроки(Новый Структура("Код", Объект.КодМестаПредставления));
	Если Места.Количество() Тогда
		НаименованиеМестаПредставления = Места[0].Название;
	КонецЕсли;
	
	УправлениеЭлементамиФормы(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеЭлементамиФормы(Форма)
	
	Форма.Элементы.ПризнакНалогоплательщика.Доступность = (Форма.Объект.ЛистДекларации = "02");
	Форма.Элементы.НомерДокумента.Доступность = (Форма.Объект.ЛистДекларации = "02") И (Форма.Объект.ПризнакНалогоплательщика = "03");
	Форма.Элементы.КодВидаДохода04.Доступность = (Форма.Объект.ЛистДекларации = "04");
	Форма.Элементы.КодВидаОперации05.Доступность = (Форма.Объект.ЛистДекларации = "05");
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборКодаМестаПредставленияЗавершение(РезультатВыбора, ДопПараметры) Экспорт
	
	Если РезультатВыбора = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Объект.КодМестаПредставления = РезультатВыбора.Код;
	НаименованиеМестаПредставления = РезультатВыбора.Название;
	
КонецПроцедуры

&НаСервере
Процедура СформироватьСпискиВыбора()
	
	МакетСоставаПоказателей = ПолучитьМакетСоставаПоказателей();
	
	КоллекцияСписковВыбора = Новый Структура;
	Для Каждого Область Из МакетСоставаПоказателей.Области Цикл
		Если Область.ТипОбласти = ТипОбластиЯчеекТабличногоДокумента.Строки
			И (Область.Имя = "ПризнакиНП_Лист02"
			Или Область.Имя = "ВидыДохода_Лист04"
			Или Область.Имя = "ВидыОпераций"
			Или Область.Имя = "МестаПредставления") Тогда
			
			ВерхОбласти = Область.Верх;
			НизОбласти  = Область.Низ;
			Коды = Новый ТаблицаЗначений;
			Коды.Колонки.Добавить("Код");
			Коды.Колонки.Добавить("Название");
			Для НомерСтроки = ВерхОбласти По НизОбласти Цикл
				КодПоказателя = СокрП(МакетСоставаПоказателей.Область(НомерСтроки, 1).Текст);
				Если КодПоказателя <> "###" Тогда
					НовСтрока = Коды.Добавить();
					НовСтрока.Код               = КодПоказателя;
					НовСтрока.Название          = СокрП(МакетСоставаПоказателей.Область(НомерСтроки, 2).Текст);
				КонецЕсли;
			КонецЦикла;
			КоллекцияСписковВыбора.Вставить(Область.Имя, Коды);
		КонецЕсли;
	КонецЦикла;
	
	Если КоллекцияСписковВыбора.Свойство("ПризнакиНП_Лист02") Тогда
		СписокВыбора = Элементы.ПризнакНалогоплательщика.СписокВыбора;
		СписокВыбора.Очистить();
		Для Каждого ПризнакНП Из КоллекцияСписковВыбора.ПризнакиНП_Лист02 Цикл
			Если НЕ ЗначениеЗаполнено(ПризнакНП.Код) Тогда
				Продолжить;
			КонецЕсли;
			СписокВыбора.Добавить(ПризнакНП.Код, ПризнакНП.Код + " - " + ПризнакНП.Название);
		КонецЦикла;
	КонецЕсли;
	
	Если КоллекцияСписковВыбора.Свойство("ВидыДохода_Лист04") Тогда
		СписокВыбора = Элементы.КодВидаДохода04.СписокВыбора;
		СписокВыбора.Очистить();
		Для Каждого ВидДохода Из КоллекцияСписковВыбора.ВидыДохода_Лист04 Цикл
			Если НЕ ЗначениеЗаполнено(ВидДохода.Код) Тогда
				Продолжить;
			КонецЕсли;
			СписокВыбора.Добавить(ВидДохода.Код, ВидДохода.Код + " - " + ВидДохода.Название);
		КонецЦикла;
	КонецЕсли;
	
	Если КоллекцияСписковВыбора.Свойство("ВидыОпераций") Тогда
		СписокВыбора = Элементы.КодВидаОперации05.СписокВыбора;
		СписокВыбора.Очистить();
		Для Каждого ВидДохода Из КоллекцияСписковВыбора.ВидыОпераций Цикл
			Если НЕ ЗначениеЗаполнено(ВидДохода.Код) Тогда
				Продолжить;
			КонецЕсли;
			СписокВыбора.Добавить(ВидДохода.Код, ВидДохода.Код + " - " + ВидДохода.Название);
		КонецЦикла;
	КонецЕсли;
	
	Если КоллекцияСписковВыбора.Свойство("МестаПредставления") Тогда
		Для Каждого Место Из КоллекцияСписковВыбора.МестаПредставления Цикл
			Если НЕ ЗначениеЗаполнено(Место.Код) Тогда
				Продолжить;
			КонецЕсли;
			ЗаполнитьЗначенияСвойств(КодыМестаПредставления.Добавить(), Место);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьМакетСоставаПоказателей()
	
	МакетыОтчета = Метаданные.Отчеты.РегламентированныйОтчетПрибыль.Макеты;
	
	ИмяМакета = Метаданные.Отчеты.РегламентированныйОтчетПрибыль.Макеты.СпискиВыбора2013Кв4.Имя; // По умолчанию берем самый ранний список
	Год = 0;
	Квартал = 0;
	
	Для Каждого Макет Из МакетыОтчета Цикл
		Если СтрНайти(Макет.Имя, "СпискиВыбора") <> 0 Тогда
			ГодСписка = СтроковыеФункцииКлиентСервер.СтрокаВЧисло(Сред(Макет.Имя, 13, 4));
			КварталСписка = СтроковыеФункцииКлиентСервер.СтрокаВЧисло(Сред(Макет.Имя, 19, 1));
			
			Если ГодСписка >= Год И КварталСписка > Квартал Тогда
				ИмяМакета = Макет.Имя;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	МакетСоставаПоказателей = Отчеты.РегламентированныйОтчетПрибыль.ПолучитьМакет(ИмяМакета);
	Возврат МакетСоставаПоказателей;
	
КонецФункции

#КонецОбласти
