#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Элементы.ГруппаОтправитьВТехПоддержку.Видимость = ОбщегоНазначенияБПО.ИспользуетсяСообщенияВСлужбуТехническойПоддержки()
		И ОбщегоНазначенияБПОСлужебныйВызовСервера.ЗаполненыДанныеАутентификацииПользователяИнтернетПоддержки();
			
	Элементы.ГруппаВыгрузитьВФайл.Видимость = Не ОбщегоНазначенияБПО.ЭтоМобильнаяПлатформа();
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура СписокПриПолученииДанныхНаСервере(ИмяЭлемента, Настройки, Строки)
	
	Для Каждого Строка Из Строки Цикл
		Данные = Строка.Значение.Данные;
		Данные.ВходящиеПараметры = ЛогированиеОперацийБПО.ФорматПараметраЛогирования(Данные.ВходящиеПараметры);
		Данные.ИсходящиеПараметры = ЛогированиеОперацийБПО.ФорматПараметраЛогирования(Данные.ИсходящиеПараметры);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	Ключи = Новый Массив;
	Для Каждого КлючЗаписи Из Элементы.Список.ВыделенныеСтроки Цикл
		Ключи.Добавить(КлючЗаписи);
	КонецЦикла;
	
	Если Ключи.Количество() = 1 Тогда
		Если ТипЗнч(Ключи[0]) = Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
			ВремяВыполнения = 0;
		Иначе
			ВремяВыполнения = Элемент.ТекущиеДанные.ВремяВыполнения;
		КонецЕсли;
	ИначеЕсли Ключи.Количество() > 1 Тогда
		ВремяВыполнения = ВремяВыполненияОперации(Ключи);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОтправитьВТехПоддержкуВыделенные(Команда)
	// Вставить содержимое обработчика.
	МодульСообщенияВСлужбуТехническойПоддержкиБПОКлиент = ОбщегоНазначенияБПОКлиент.ОбщийМодуль("СообщенияВСлужбуТехническойПоддержкиБПОКлиент");
	ПараметрыСообщения = МодульСообщенияВСлужбуТехническойПоддержкиБПОКлиент.ПараметрыОтправкиСообщенияОбОшибке();
	
	Сведения = СведенияДляТехподдержкиВыделенные();
	Если Сведения.Количество()>0 Тогда
	
		ПараметрыВложения = Новый Структура;
		ПараметрыВложения.Вставить("Представление", НСтр("ru = 'Операции с оборудованием.txt';
														|en = 'Операции с оборудованием.txt'"));
		ПараметрыВложения.Вставить("Данные",        СтрСоединить(Сведения, Символы.ПС));
		ПараметрыВложения.Вставить("ВидДанных",     "Текст");
		ПараметрыСообщения.ДанныеВложений.Добавить(ПараметрыВложения);
		
	КонецЕсли;
	
	ПараметрыСообщения.ТекстОшибки = НСтр("ru = 'Информация о операциях с подключаемым оборудованием';
											|en = 'Информация о операциях с подключаемым оборудованием'");
	ОписаниеОповещения = Новый ОписаниеОповещения("СообщениеВТехническуюПоддержкуЗавершение", ЭтотОбъект);
	МодульСообщенияВСлужбуТехническойПоддержкиБПОКлиент.НачатьОтправкуСообщенияОбОшибке(ОписаниеОповещения, ПараметрыСообщения);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьВТехПоддержку(Команда)
	// Вставить содержимое обработчика.
	МодульСообщенияВСлужбуТехническойПоддержкиБПОКлиент = ОбщегоНазначенияБПОКлиент.ОбщийМодуль("СообщенияВСлужбуТехническойПоддержкиБПОКлиент");
	ПараметрыСообщения = МодульСообщенияВСлужбуТехническойПоддержкиБПОКлиент.ПараметрыОтправкиСообщенияОбОшибке();
	
	Сведения = СведенияДляТехподдержки();
	Для Каждого Информация Из Сведения Цикл
	
		ПараметрыВложения = Новый Структура;
		ПараметрыВложения.Вставить("Представление", Информация.ИмяФайла);
		ПараметрыВложения.Вставить("Данные",        Информация.Данные);
		ПараметрыВложения.Вставить("ВидДанных",     "Адрес");
		ПараметрыСообщения.ДанныеВложений.Добавить(ПараметрыВложения);
		
	КонецЦикла;
	
	ПараметрыСообщения.ТекстОшибки = НСтр("ru = 'Информация о операциях с подключаемым оборудованием';
											|en = 'Информация о операциях с подключаемым оборудованием'");
	ОписаниеОповещения = Новый ОписаниеОповещения("СообщениеВТехническуюПоддержкуЗавершение", ЭтотОбъект);
	МодульСообщенияВСлужбуТехническойПоддержкиБПОКлиент.НачатьОтправкуСообщенияОбОшибке(ОписаниеОповещения, ПараметрыСообщения);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция СведенияДляТехподдержки()
	
	ИмяВременногоФайла = ПолучитьИмяВременногоФайла(".txt");
	Сведения = Новый Массив();
	Попытка
		Записи = ЗаписиПоСписку();
		ЗаписТекста = Новый ЗаписьТекста(ИмяВременногоФайла);
		Для каждого Запись Из Записи Цикл
			ЗаписТекста.ЗаписатьСтроку(СтрокаЗаписи(Запись));
		КонецЦикла;
		ЗаписТекста.Закрыть();
		МодульСообщенияВСлужбуТехническойПоддержкиБПО = 
			ОбщегоНазначенияБПО.ОбщийМодуль("СообщенияВСлужбуТехническойПоддержкиБПО");
		Сведения = МодульСообщенияВСлужбуТехническойПоддержкиБПО.ФайлВАрхивеСРазбивкой(ИмяВременногоФайла);
	Исключение
		ОписаниеОшибки = ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ОбщегоНазначенияБПО.ЗаписатьОшибкуВЖурналРегистрации(
			НСтр("ru = 'БПО.Ошибка отправки сообщения в техподдержку';
				|en = 'БПО.Ошибка отправки сообщения в техподдержку'"), 
			СтрШаблон(НСтр("ru = 'Не удается сформировать файл с операциями: %1';
							|en = 'Не удается сформировать файл с операциями: %1'"), ОписаниеОшибки),
			"Ошибка");
	КонецПопытки;
	УдалитьФайлы(ИмяВременногоФайла);
	
	Возврат Сведения;
	
КонецФункции

&НаСервере
Функция СведенияДляТехподдержкиВыделенные()
	
	Выборка = ВыделенныеЗаписи();
	Сведения = Новый Массив();
	Пока Выборка.Следующий() Цикл
		Сведения.Добавить(СтрокаЗаписи(Выборка));
	КонецЦикла;
	Возврат Сведения;
	
КонецФункции

&НаКлиенте
Процедура СообщениеВТехническуюПоддержкуЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Не ПустаяСтрока(Результат.КодОшибки) Тогда
		ОбщегоНазначенияБПОКлиент.СообщитьПользователю(Результат.СообщениеОбОшибке);
	КонецЕсли;
	
КонецПроцедуры 

&НаСервере
Функция ВыделенныеЗаписи()
	
	ТаблицаКлючей = Новый ТаблицаЗначений();
	ТаблицаКлючей.Колонки.Добавить("Дата", Новый ОписаниеТипов("Дата"));
	ТаблицаКлючей.Колонки.Добавить("НомерОперации", Новый ОписаниеТипов("Число"));
	Для Каждого КлючЗаписи Из Элементы.Список.ВыделенныеСтроки Цикл
		СтрокаТаблицы = ТаблицаКлючей.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаТаблицы, КлючЗаписи);
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ОперацииСПодключаемымОборудованием.Оборудование КАК Оборудование,
		|	ОперацииСПодключаемымОборудованием.Дата КАК Дата,
		|	ОперацииСПодключаемымОборудованием.НомерОперации КАК НомерОперации,
		|	ОперацииСПодключаемымОборудованием.ГодМесяц КАК ГодМесяц,
		|	ОперацииСПодключаемымОборудованием.ВходящиеПараметры КАК ВходящиеПараметры,
		|	ОперацииСПодключаемымОборудованием.ИсходящиеПараметры КАК ИсходящиеПараметры,
		|	ОперацииСПодключаемымОборудованием.Результат КАК Результат,
		|	ОперацииСПодключаемымОборудованием.Таймкод КАК Таймкод,
		|	ОперацииСПодключаемымОборудованием.ТипЗаписи КАК ТипЗаписи,
		|	ОперацииСПодключаемымОборудованием.ВерсияКомпонента КАК ВерсияКомпонента,
		|	ОперацииСПодключаемымОборудованием.ВерсияДрайвера КАК ВерсияДрайвера,
		|	ОперацииСПодключаемымОборудованием.Операция КАК Операция,
		|	ОперацииСПодключаемымОборудованием.ИДУстройства КАК ИДУстройства,
		|	ОперацииСПодключаемымОборудованием.ВремяВыполнения КАК ВремяВыполнения,
		|	ОперацииСПодключаемымОборудованием.РевизияИнтерфейса КАК РевизияИнтерфейса,
		|	ОперацииСПодключаемымОборудованием.Милисекунда КАК Милисекунда,
		|	ОперацииСПодключаемымОборудованием.КодОшибки КАК КодОшибки,
		|	ОперацииСПодключаемымОборудованием.ТекстОшибки КАК ТекстОшибки
		|ИЗ
		|	РегистрСведений.ОперацииСПодключаемымОборудованием КАК ОперацииСПодключаемымОборудованием
		|ГДЕ
		|	(ОперацииСПодключаемымОборудованием.Дата, ОперацииСПодключаемымОборудованием.НомерОперации) В (&ТаблицаКлючей)
		|
		|УПОРЯДОЧИТЬ ПО
		|	Дата,
		|	НомерОперации";
	
	Запрос.УстановитьПараметр("ТаблицаКлючей", ТаблицаКлючей);
	РезультатЗапроса = Запрос.Выполнить();
	Выборка = РезультатЗапроса.Выбрать();
	Возврат Выборка;
	
КонецФункции

&НаСервереБезКонтекста
Функция ВремяВыполненияОперации(Ключи)
	
	ТаблицаКлючей = Новый ТаблицаЗначений();
	ТаблицаКлючей.Колонки.Добавить("Оборудование", Новый ОписаниеТипов("СправочникСсылка.ПодключаемоеОборудование"));
	ТаблицаКлючей.Колонки.Добавить("Дата", Новый ОписаниеТипов("Дата"));
	ТаблицаКлючей.Колонки.Добавить("НомерОперации", Новый ОписаниеТипов("Число"));
	Для Каждого КлючЗаписи Из Ключи Цикл
		Если ТипЗнч(КлючЗаписи) = Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
			Продолжить;
		КонецЕсли;
		СтрокаТаблицы = ТаблицаКлючей.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаТаблицы, КлючЗаписи);
	КонецЦикла;
	
	Если ТаблицаКлючей.Количество()=0 Тогда
		Возврат 0;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ОперацииСПодключаемымОборудованием.ВремяВыполнения КАК ВремяВыполнения
		|ИЗ
		|	РегистрСведений.ОперацииСПодключаемымОборудованием КАК ОперацииСПодключаемымОборудованием
		|ГДЕ
		|	(ОперацииСПодключаемымОборудованием.Оборудование, ОперацииСПодключаемымОборудованием.Дата, ОперацииСПодключаемымОборудованием.НомерОперации) В (&ТаблицаКлючей)
		|ИТОГИ
		|	СУММА(ВремяВыполнения)
		|ПО
		|	ОБЩИЕ";
	
	Запрос.УстановитьПараметр("ТаблицаКлючей", ТаблицаКлючей);
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	ВремяВыполнения = Выборка.ВремяВыполнения / 1000;
	Возврат ВремяВыполнения;
	
КонецФункции

&НаСервере
Функция СтрокаЗаписи(Запись)
	
	ВходящиеТекст = ЛогированиеОперацийБПО.ФорматПараметраЛогирования(Запись.ВходящиеПараметры);
	ИсходящиеТекст = ЛогированиеОперацийБПО.ФорматПараметраЛогирования(Запись.ИсходящиеПараметры);
	Возврат СтрШаблон("%1 : %2; %3; [%4:%5:%6]; ""%7""; Результат: %8; %9; %10",
		Запись.Дата,
		Запись.Милисекунда,
		Запись.ТипЗаписи,
		Запись.РевизияИнтерфейса,
		Запись.ВерсияДрайвера,
		Запись.ВерсияКомпонента,
		Запись.Операция,
		Запись.Результат,
		?(ПустаяСтрока(ВходящиеТекст), "", Символы.ПС + НСтр("ru = ' - Входящие: ';
															|en = ' - Входящие: '") + Символы.ПС + СокрЛП(ВходящиеТекст)),
		?(ПустаяСтрока(ИсходящиеТекст), "", Символы.ПС + НСтр("ru = ' - Исходящие: ';
																|en = ' - Исходящие: '") + Символы.ПС + СокрЛП(ИсходящиеТекст)));
	
КонецФункции

&НаКлиенте
Процедура ВыгрузитьВФайл(Команда)
	ТекстовыйДокумет = ВыгрузитьВФайлВсеСтрокиНаСервере();
	ТекстовыйДокумет.Показать();
КонецПроцедуры

&НаСервере
Функция ЗаписиПоСписку()
	// Вставить содержимое обработчика.
	
	Схема = Элементы.Список.ПолучитьИсполняемуюСхемуКомпоновкиДанных();
	Настройки = Элементы.Список.ПолучитьИсполняемыеНастройкиКомпоновкиДанных();
	
	Поле = Настройки.Структура[0].Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
	Поле.Использование = Истина;
	Поле.Заголовок = "ВходящиеПараметры";
	Поле.Поле = Новый ПолеКомпоновкиДанных("ВходящиеПараметры");
	
	Поле = Настройки.Структура[0].Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
	Поле.Использование = Истина;
	Поле.Заголовок = "ИсходящиеПараметры";
	Поле.Поле = Новый ПолеКомпоновкиДанных("ИсходящиеПараметры");
	
	Поле = Настройки.Структура[0].Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
	Поле.Использование = Истина;
	Поле.Заголовок = "Милисекунда";
	Поле.Поле = Новый ПолеКомпоновкиДанных("Милисекунда");
	
	Поле = Настройки.Структура[0].Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
	Поле.Использование = Истина;
	Поле.Заголовок = "Дата";
	Поле.Поле = Новый ПолеКомпоновкиДанных("Дата");

	Настройки.Структура[0].Порядок.Элементы.Очистить();
	
	Поле = Настройки.Структура[0].Порядок.Элементы.Добавить(Тип("ЭлементПорядкаКомпоновкиДанных"));
	Поле.Использование = Истина;
	Поле.Поле = Новый ПолеКомпоновкиДанных("Дата");
	Поле.ТипУпорядочивания = НаправлениеСортировкиКомпоновкиДанных.Возр;
	
	Поле = Настройки.Структура[0].Порядок.Элементы.Добавить(Тип("ЭлементПорядкаКомпоновкиДанных"));
	Поле.Использование = Истина;
	Поле.Поле = Новый ПолеКомпоновкиДанных("НомерОперации");
	Поле.ТипУпорядочивания = НаправлениеСортировкиКомпоновкиДанных.Возр;
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных();
	МакетКомпоновки = КомпоновщикМакета.Выполнить(Схема, Настройки, , , Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки);
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	
	Возврат ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
КонецФункции

&НаСервере
Функция ВыгрузитьВФайлВсеСтрокиНаСервере()

	#Если Не МобильноеПриложениеСервер Тогда
	Записи = ЗаписиПоСписку();
	ТекстовыйДокумент = Новый ТекстовыйДокумент();
	Для каждого Запись Из Записи Цикл
		ТекстовыйДокумент.ДобавитьСтроку(СтрокаЗаписи(Запись));
	КонецЦикла;
	
	Возврат ТекстовыйДокумент;
	#КонецЕсли
	
КонецФункции

&НаСервере
Функция ВыгрузитьВФайлВыделенныеСтрокиНаСервере()

	#Если Не МобильноеПриложениеСервер Тогда
	Выборка = ВыделенныеЗаписи();
	ТекстовыйДокумент = Новый ТекстовыйДокумент();
	Пока Выборка.Следующий() Цикл
		ТекстовыйДокумент.ДобавитьСтроку(СтрокаЗаписи(Выборка));
	КонецЦикла;
	
	Возврат ТекстовыйДокумент;
	#КонецЕсли
	
КонецФункции

&НаКлиенте
Процедура ВыгрузитьВФайлВыделенные(Команда)
	ТекстовыйДокумет = ВыгрузитьВФайлВыделенныеСтрокиНаСервере();
	ТекстовыйДокумет.Показать();
КонецПроцедуры

#КонецОбласти
