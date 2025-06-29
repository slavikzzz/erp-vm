
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Ссылка = Параметры.Ссылка;
	ПоказыватьФотоТоваров = Параметры.ПоказыватьФотоТоваров;
	
	ЗаполнитьФорму();
	УстановитьУсловноеОформление();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// ПодключаемоеОборудование
	Если Источник = "ПодключаемоеОборудование" И ВводДоступен() Тогда
		
		Если ИмяСобытия = "ScanData" И МенеджерОборудованияУТКлиент.ЕстьНеобработанноеСобытие() Тогда
			
			// Преобразуем предварительно к ожидаемому формату
			Если Параметр[1] = Неопределено Тогда
				Штрихкод = Параметр[0];
			Иначе
				Штрихкод = Параметр[1][1];
			КонецЕсли;
			
			ПараметрыКарточкаТовара = НайтиТоварСервер(Штрихкод);
			
			Если НЕ ЗначениеЗаполнено(ПараметрыКарточкаТовара.Номенклатура) Тогда
				
				ТекстОшибки = СтрШаблон(НСтр("ru = 'Не найдена номенклатура со штрихкодом: %1';
											|en = 'Item with a barcode is not found: %1'"), Штрихкод);
				ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстОшибки);
				
				Возврат;
			КонецЕсли;
			
			Описание = Новый ОписаниеОповещения("ОбновитьФорму", ЭтаФорма);
			
			ПараметрыФормы = Новый Структура;
			ПараметрыФормы.Вставить("Номенклатура", ПараметрыКарточкаТовара.Номенклатура);
			ПараметрыФормы.Вставить("Характеристика", ПараметрыКарточкаТовара.Характеристика);
			ПараметрыФормы.Вставить("Упаковка", ПараметрыКарточкаТовара.Упаковка);
			ПараметрыФормы.Вставить("Количество", ПараметрыКарточкаТовара.Количество);
			ПараметрыФормы.Вставить("Режим", "Пересчет");
			ПараметрыФормы.Вставить("НомерСтроки", 0);
			ПараметрыФормы.Вставить("Склад", Склад);
			ПараметрыФормы.Вставить("Помещение", Помещение);
			ПараметрыФормы.Вставить("ЭтоСканирование", Истина);
			ПараметрыФормы.Вставить("ПоказыватьФотоТоваров", ПоказыватьФотоТоваров);
			
			ОткрытьФорму(
			"Обработка.МобильноеРабочееМестоКладовщика.Форма.КарточкаТовара",ПараметрыФормы,
			ЭтаФорма,,,,Описание,
			РежимОткрытияОкнаФормы.Независимый);
			
		КонецЕсли;
		
	КонецЕсли;
	
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Информация(Команда)
	
	Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы["СтраницаИнформация"];
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Описание = Новый ОписаниеОповещения("ОбновитьФорму", ЭтаФорма);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Номенклатура", Элемент.ТекущиеДанные.Номенклатура);
	ПараметрыФормы.Вставить("Характеристика", Элемент.ТекущиеДанные.Характеристика);
	ПараметрыФормы.Вставить("Серия", Элемент.ТекущиеДанные.Серия);
	ПараметрыФормы.Вставить("Назначение", Элемент.ТекущиеДанные.Назначение);
	ПараметрыФормы.Вставить("Упаковка", Элемент.ТекущиеДанные.Упаковка);
	ПараметрыФормы.Вставить("Количество", Элемент.ТекущиеДанные.КоличествоУпаковокФакт);
	ПараметрыФормы.Вставить("Режим", "РедактированиеПересчет");
	ПараметрыФормы.Вставить("НомерСтроки", Элемент.ТекущаяСтрока);
	ПараметрыФормы.Вставить("Склад", Склад);
	ПараметрыФормы.Вставить("Помещение", Помещение);
	ПараметрыФормы.Вставить("Ячейка", Элемент.ТекущиеДанные.Ячейка);
	ПараметрыФормы.Вставить("ПоказыватьФотоТоваров", ПоказыватьФотоТоваров);
	
	ОткрытьФорму(
	"Обработка.МобильноеРабочееМестоКладовщика.Форма.КарточкаТовара",ПараметрыФормы,
	ЭтаФорма,,,,Описание,
	РежимОткрытияОкнаФормы.Независимый);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакончитьПересчет(Команда)
	
	СписокЗначений = Новый СписокЗначений;
	СписокЗначений.Добавить("Завершить", НСтр("ru = 'Завершить';
												|en = 'Finish'"));
	СписокЗначений.Добавить("Продолжить", НСтр("ru = 'Продолжить';
												|en = 'Continue'"));
	
	Оповещение = Новый ОписаниеОповещения("ПослеЗакрытияВопроса", ЭтотОбъект);
	ПоказатьВопрос(Оповещение, НСтр("ru = 'Закончить пересчет?';
									|en = 'Finish recount?'"), СписокЗначений, 0);
	
КонецПроцедуры

&НаКлиенте
Процедура Сканировать(Команда)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыФормы = Новый Структура;
	Если ИспользоватьАдресноеХранение Тогда 
		ПараметрыФормы.Вставить("ТипПоиска", "ПоискЯчейки");
		Описание = Новый ОписаниеОповещения("РезультатПоискаЯчейки", ЭтаФорма);
	Иначе
		ПараметрыФормы.Вставить("ТипПоиска", "ПоискНоменклатуры");
		Описание = Новый ОписаниеОповещения("РезультатСканирования", ЭтаФорма);
	КонецЕсли;
	ПараметрыФормы.Вставить("Склад", Склад);
	ПараметрыФормы.Вставить("Помещение", Помещение);
	ПараметрыФормы.Вставить("ДокументСсылка", Ссылка);
	ПараметрыФормы.Вставить("Режим", "Пересчет");
	
	ОткрытьФорму(
	"Обработка.МобильноеРабочееМестоКладовщика.Форма.СканированиеШтрихкода",ПараметрыФормы,
	ЭтаФорма,,,,Описание,
	РежимОткрытияОкнаФормы.Независимый);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТоварыКоличествоУпаковокРазница.Имя);
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Товары.КоличествоУпаковокРазница");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеРавно;
	ОтборЭлемента.ПравоеЗначение = 0;
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаПроблема);
	
	Элементы.ТоварыЯчейка.Видимость = ИспользоватьАдресноеХранение;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьФорму()
	
	СтруктураДокумента = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Ссылка, "Склад, Комментарий, Помещение");
	
	Склад       = СтруктураДокумента.Склад;
	Комментарий = СтруктураДокумента.Комментарий;
	Помещение   = СтруктураДокумента.Помещение;
	
	СвойстваСклада = Обработки.МобильноеРабочееМестоКладовщика.СвойстваСклада(Склад);
	
	ИспользоватьАдресноеХранение            = СвойстваСклада.ИспользоватьАдресноеХранение;
	ИспользоватьСкладскиеПомещения          = СвойстваСклада.ИспользоватьСкладскиеПомещения;
	
	Если СвойстваСклада.ИспользоватьСкладскиеПомещения Тогда
		СтруктураПомещения = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Помещение, "ИспользоватьАдресноеХранение");
		ИспользоватьАдресноеХранение = СтруктураПомещения.ИспользоватьАдресноеХранение;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПересчетТоваровТовары.Количество КАК Количество,
		|	ПересчетТоваровТовары.КоличествоФакт КАК КоличествоФакт,
		|	ПересчетТоваровТовары.КоличествоУпаковок КАК КоличествоУпаковок,
		|	ПересчетТоваровТовары.КоличествоУпаковокФакт КАК КоличествоУпаковокФакт,
		|	ПересчетТоваровТовары.Номенклатура КАК Номенклатура,
		|	ВЫБОР
		|		КОГДА ПересчетТоваровТовары.Упаковка = ЗНАЧЕНИЕ(Справочник.УпаковкиЕдиницыИзмерения.ПустаяСсылка)
		|			ТОГДА ПересчетТоваровТовары.Номенклатура.ЕдиницаИзмерения
		|		ИНАЧЕ ПересчетТоваровТовары.Упаковка
		|	КОНЕЦ КАК Упаковка,
		|	ПересчетТоваровТовары.Характеристика КАК Характеристика,
		|	ПересчетТоваровТовары.Назначение КАК Назначение,
		|	ПересчетТоваровТовары.Серия КАК Серия,
		|	ПересчетТоваровТовары.СтатусУказанияСерий КАК СтатусУказанияСерий,
		|	ПересчетТоваровТовары.КоличествоУпаковокФакт - ПересчетТоваровТовары.КоличествоУпаковок КАК КоличествоУпаковокРазница,
		|	ПересчетТоваровТовары.КоличествоФакт - ПересчетТоваровТовары.Количество КАК КоличествоРазница,
		|	ПересчетТоваровТовары.Ячейка КАК Ячейка
		|ИЗ
		|	Документ.ПересчетТоваров.Товары КАК ПересчетТоваровТовары
		|ГДЕ
		|	ПересчетТоваровТовары.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Товары.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьФорму(Результат = Неопределено, ДополнительныеПараметры = Неопределено) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОбновитьФормуНаСервере(Результат);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьФормуНаСервере(Результат)
	
	СтруктураПоиска = Новый Структура;
	СтруктураПоиска.Вставить("Номенклатура", Результат.Номенклатура);
	СтруктураПоиска.Вставить("Характеристика", Результат.Характеристика);
	СтруктураПоиска.Вставить("Серия", Результат.Серия);
	СтруктураПоиска.Вставить("Упаковка", Результат.Упаковка);
	СтруктураПоиска.Вставить("Назначение", Результат.Назначение);
	СтруктураПоиска.Вставить("Ячейка", Результат.Ячейка);
	
	КоэффициентУпаковки = Справочники.УпаковкиЕдиницыИзмерения.КоэффициентУпаковки(Результат.Упаковка, Результат.Номенклатура);
	
	РезультатПоиска = Товары.НайтиСтроки(СтруктураПоиска);
	Если РезультатПоиска.Количество() > 0 Тогда
		
		Если Результат.Режим = "Пересчет" Тогда
			РезультатПоиска[0].КоличествоУпаковокФакт = РезультатПоиска[0].КоличествоУпаковокФакт + Результат.КоличествоУпаковок;
		Иначе
			РезультатПоиска[0].КоличествоУпаковокФакт = Результат.КоличествоУпаковок;
		КонецЕсли;
		РезультатПоиска[0].КоличествоФакт = РезультатПоиска[0].КоличествоУпаковокФакт * КоэффициентУпаковки;
		
		РезультатПоиска[0].КоличествоУпаковокРазница = РезультатПоиска[0].КоличествоУпаковокФакт - РезультатПоиска[0].КоличествоУпаковок;
		РезультатПоиска[0].КоличествоРазница = РезультатПоиска[0].КоличествоУпаковокРазница * КоэффициентУпаковки;
		
	Иначе
		
		НоваяСтрока = Товары.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Результат,,"КоличествоУпаковок");
		НоваяСтрока.КоличествоУпаковокФакт = Результат.КоличествоУпаковок;
		НоваяСтрока.КоличествоФакт = Результат.КоличествоУпаковок * КоэффициентУпаковки;
		НоваяСтрока.КоличествоУпаковокРазница = - Результат.КоличествоУпаковок;
		НоваяСтрока.КоличествоФакт = Результат.КоличествоУпаковок * КоэффициентУпаковки;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ЗакончитьПересчетНаСервере()
	
	ДокументОбъект = Ссылка.ПолучитьОбъект();
	
	ДокументОбъект.Статус      = Перечисления.СтатусыПересчетовТоваров.Выполнено;
	ДокументОбъект.Помещение   = Помещение;
	ДокументОбъект.Комментарий = Комментарий;
	ДокументОбъект.Исполнитель = Исполнитель;
	
	ДокументОбъект.Товары.Очистить();
	
	Если ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Склад, "ИспользоватьСкладскиеПомещения")
		И Помещение.Пустая() Тогда
		
		СообщениеПользователю = Новый СообщениеПользователю;
		СообщениеПользователю.Текст = НСтр("ru = 'Не выбрано помещение';
											|en = 'Wareroom is not selected'");
		СообщениеПользователю.Сообщить();
		
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы["СтраницаИнформация"];
		
		Возврат Ложь;
		
	КонецЕсли;
		
	Для Каждого Строка Из Товары Цикл
		
		НоваяСтрока = ДокументОбъект.Товары.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Строка);
		Если Строка.КоличествоУпаковокРазница <> 0 Тогда
			НоваяСтрока.ИзлишекПорча = Истина;
		КонецЕсли;
		
	КонецЦикла;
	
	Попытка
		ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение);
	Исключение
		ДокументОбъект.Записать(РежимЗаписиДокумента.Запись);
	КонецПопытки;
	
	Возврат Истина;
	
КонецФункции

&НаСервереБезКонтекста
Функция НайтиТоварСервер(Штрихкод)
	
	Возврат Обработки.МобильноеРабочееМестоКладовщика.НайтиТоварПоШК(Штрихкод);
	
КонецФункции

&НаКлиенте
Процедура ПослеЗакрытияВопроса(Результат, Параметры) Экспорт
	
	Если Результат = "Завершить" Тогда
		
		ПриемкаЗавершена = ЗакончитьПересчетНаСервере();
		
		Если ПриемкаЗавершена Тогда
			Закрыть();
		КонецЕсли;
		
	Иначе
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РезультатСканирования(Результат = Неопределено, ДополнительныеПараметры = Неопределено) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Описание = Новый ОписаниеОповещения("ОбновитьФорму", ЭтаФорма);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Номенклатура", Результат.Номенклатура);
	ПараметрыФормы.Вставить("Характеристика", Результат.Характеристика);
	Если Результат.Свойство("Серия") Тогда
		ПараметрыФормы.Вставить("Серия", Результат.Серия);
	Иначе
		ПараметрыФормы.Вставить("Серия", ПустаяСерия);
	КонецЕсли;
	ПараметрыФормы.Вставить("Упаковка", Результат.Упаковка);
	ПараметрыФормы.Вставить("Количество", 1);
	ПараметрыФормы.Вставить("Режим", "Пересчет");
	ПараметрыФормы.Вставить("НомерСтроки", 0);
	ПараметрыФормы.Вставить("Склад", Склад);
	ПараметрыФормы.Вставить("Помещение", Помещение);
	ПараметрыФормы.Вставить("ПоказыватьФотоТоваров", ПоказыватьФотоТоваров);
	
	ОткрытьФорму(
	"Обработка.МобильноеРабочееМестоКладовщика.Форма.КарточкаТовара",ПараметрыФормы,
	ЭтаФорма,,,,Описание,
	РежимОткрытияОкнаФормы.Независимый);
	
КонецПроцедуры


&НаКлиенте
Процедура РезультатПоискаЯчейки(Результат = Неопределено, ДополнительныеПараметры = Неопределено) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Описание = Новый ОписаниеОповещения("ЗавершитьРазмещениеВЯчейку", ЭтаФорма);
	
	ТоварыВЯчейке = Новый Массив;
	
	Для Каждого Строка Из Товары Цикл
		
		Если Строка.Ячейка = Результат Тогда
			
			Структура = СтруктураТоваров();
			ЗаполнитьЗначенияСвойств(Структура, Строка);
			Структура.КоличествоУпаковокРазмещено = Строка.КоличествоУпаковокФакт;
			
			ТоварыВЯчейке.Добавить(Структура);
			
		КонецЕсли;
		
	КонецЦикла;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Ячейка",      Результат);
	ПараметрыФормы.Вставить("Товары",      ТоварыВЯчейке);
	ПараметрыФормы.Вставить("Склад",       Склад);
	ПараметрыФормы.Вставить("Помещение",   Помещение);
	ПараметрыФормы.Вставить("ТипОперации", 4);
	ПараметрыФормы.Вставить("ПоказыватьФотоТоваров", ПоказыватьФотоТоваров);
	
	ОткрытьФорму(
	"Обработка.МобильноеРабочееМестоКладовщика.Форма.РазмещениеВЯчейки",ПараметрыФормы,
	ЭтаФорма,,,,Описание,
	РежимОткрытияОкнаФормы.Независимый);
	
КонецПроцедуры


&НаКлиенте
Процедура ЗавершитьРазмещениеВЯчейку(Результат = Неопределено, ДополнительныеПараметры = Неопределено) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого СтрокаЯчейки Из Результат.МассивРазмещений Цикл
		
		СтрокаЯчейки.Вставить("Режим", Результат.Режим);
		ОбновитьФормуНаСервере(СтрокаЯчейки);
		
	КонецЦикла;
	
КонецПроцедуры


&НаКлиенте
Функция СтруктураТоваров()
	
	Структура = Новый Структура;
	Структура.Вставить("Номенклатура","");
	Структура.Вставить("Характеристика","");
	Структура.Вставить("Серия","");
	Структура.Вставить("Упаковка","");
	Структура.Вставить("КоличествоУпаковок","");
	Структура.Вставить("Назначение","");
	Структура.Вставить("КоличествоУпаковокРазмещено","");
	
	Возврат Структура;
	
КонецФункции

#КонецОбласти
