#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает таблицу для конвертации ОКВЭД в ОКВЭД2.
//
// Возвращаемое значение:
//	ТаблицаЗначений - Содержит колонки:
//		* КодОКВЭД - Строка - Код ОКВЭД.
//		* КодОКВЭД2 - Строка - Код ОКВЭД2.
//
Функция ТаблицаКонвертацииОКВЭД_ОКВЭД2() Экспорт
	
	ТекстКонвертации = Справочники.КлассификаторОКВЭД2.ПолучитьМакет("КонвертацияОКВЭД_ОКВЭД2").ПолучитьТекст();
	
	ЧтениеXML = Новый ЧтениеXML;
	ЧтениеXML.УстановитьСтроку(ТекстКонвертации);
	
	Если Не ЧтениеXML.Прочитать() Тогда
		ВызватьИсключение НСтр("ru = 'Пустой XML';
								|en = 'The XML file is empty.'");
	ИначеЕсли ЧтениеXML.Имя <> "КонвертацияОКВЭД_ОКВЭД2" Тогда
		ВызватьИсключение НСтр("ru = 'Ошибка в структуре XML';
								|en = 'XML file format error.'");
	КонецЕсли;
	
	ТаблицаКонвертацииОКВЭД_ОКВЭД2 = Новый ТаблицаЗначений;
	ТаблицаКонвертацииОКВЭД_ОКВЭД2.Колонки.Добавить("КодОКВЭД",   Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(8)));
	ТаблицаКонвертацииОКВЭД_ОКВЭД2.Колонки.Добавить("КодОКВЭД2",  Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(8)));
	
	Пока ЧтениеXML.Прочитать() Цикл
		
		ИмяУзла = ЧтениеXML.Имя;
		
		Если ЧтениеXML.ТипУзла = ТипУзлаXML.КонецЭлемента Тогда
			Если ИмяУзла = "КонвертацияОКВЭД_ОКВЭД2" Тогда
				Прервать;
			КонецЕсли;
		КонецЕсли;
		
		Если ЧтениеXML.ТипУзла = ТипУзлаXML.НачалоЭлемента Тогда
			
			Если ИмяУзла = "Элемент" Тогда
				
				ТекущаяСтрока = ТаблицаКонвертацииОКВЭД_ОКВЭД2.Добавить();
				ТекущаяСтрока.КодОКВЭД   = ЧтениеXML.ПолучитьАтрибут("КодОКВЭД");
				ТекущаяСтрока.КодОКВЭД2  = ЧтениеXML.ПолучитьАтрибут("КодОКВЭД2");
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	ЧтениеXML.Закрыть();
	
	Возврат ТаблицаКонвертацииОКВЭД_ОКВЭД2;
	
КонецФункции

// Функция ищет по коду элементы в справочнике Классификатор ОКВЭД2.
//  Если их нет, то создает элементы справочника в соответствии с классификатором.
//
// Параметры:
//  Код - Строка(10) - Строка с кодом ОКВЭД2,
//  РежимОбновления - Булево, Истина - признак записи объекта через метод ОбновлениеИнформационнойБазы.ЗаписатьОбъект().
// 
// Возвращаемое значение:
//  Ссылка - ссылка на элемент классификатора или Неопределено, если такого кода нет в ОКВЭД2.
//
Функция НайтиСоздатьЭлементКлассификатораОКВЭД2(Код, РежимОбновления = Ложь) Экспорт
	
	СуществующийЭлемент = Справочники.КлассификаторОКВЭД2.НайтиПоКоду(Код);
	Если Не ЗначениеЗаполнено(СуществующийЭлемент) Тогда
		
		ТаблицаКлассификатора = КлассификаторОКВЭД2();
		ТаблицаКлассификатора.Индексы.Добавить("Код");
		
		СтруктураПоиска = Новый Структура("Код",Код);
		НайденныеСтроки = ТаблицаКлассификатора.НайтиСтроки(СтруктураПоиска);
		
		Если НайденныеСтроки.Количество() = 1 Тогда
			СвойстваЭлемента = НайденныеСтроки[0];
			
			СправочникОбъект = Справочники.КлассификаторОКВЭД2.СоздатьЭлемент();
			
			СправочникОбъект.Наименование            = СвойстваЭлемента.Наименование;
			СправочникОбъект.НаименованиеПолное      = СвойстваЭлемента.Наименование;
			СправочникОбъект.Код                     = СвойстваЭлемента.Код;
			
			Если РежимОбновления Тогда
				ОбновлениеИнформационнойБазы.ЗаписатьОбъект(СправочникОбъект);
			Иначе
				СправочникОбъект.Записать();
			КонецЕсли;
			
			Возврат СправочникОбъект.Ссылка;
			
		Иначе
			Возврат Неопределено;
		КонецЕсли;
	Иначе
		Возврат СуществующийЭлемент;
	КонецЕсли;
		
КонецФункции

// Возвращает пустую таблицу для поиска в классификаторе ОКВЭД2.
//
// Возвращаемое значение:
//  ТаблицаЗначений - таблица для поиска в классификаторе ОКВЭД2.
//
Функция НовыйТаблицаДляПоискаОКВЭД() Экспорт
	
	Схема = Справочники.Организации.ПолучитьМакет("ОтборОКВЭД");
	
	ТаблицаДляОтбораОКВЭД = Новый ТаблицаЗначений();
	
	Для Каждого Поле Из Схема.НаборыДанных.ОКВЭД.Поля Цикл
		ТаблицаДляОтбораОКВЭД.Колонки.Добавить(Поле.Поле, Поле.ТипЗначения);
	КонецЦикла;
	
	Возврат ТаблицаДляОтбораОКВЭД;
	
КонецФункции

// Возвращает таблицу классификатора ОКВЭД2.
//
// Параметры:
//  ТолькоДоступныеДляВыбора - Булево - В таблицу будут включены только те строки, которые можно выбрать для вида деятельности организации.
// 
// Возвращаемое значение:
//  Таблица - Таблица классификатора ОКВЭД2.
//
Функция КлассификаторОКВЭД2(ТолькоДоступныеДляВыбора = Ложь) Экспорт
	
	КлассификаторОКВЭД2 = НовыйТаблицаДляПоискаОКВЭД();
	// Если выбираются только доступные для выбора,
	// то добавлять отдельную колонку "ДоступенДляВыбора" не имеет смысла,
	// т.к. все строки в результате будут доступны для выбора.
	Если НЕ ТолькоДоступныеДляВыбора Тогда
		КлассификаторОКВЭД2.Колонки.Добавить("ДоступенДляВыбора", Новый ОписаниеТипов("Булево"));
	КонецЕсли;
	
	Макет = Справочники.Организации.ПолучитьМакет("ОКВЭД2");
	
	ТекущаяОбласть = Макет.Области.Найти("Классификатор");
	
	Если НЕ ТекущаяОбласть = Неопределено Тогда
		
		Для НомерСтр = ТекущаяОбласть.Верх По ТекущаяОбласть.Низ Цикл
			
			КодПоказателя = СокрП(Макет.Область(НомерСтр, 1).Текст);
			Название      = СокрП(Макет.Область(НомерСтр, 2).Текст);
			
			Если КодПоказателя = "###" Тогда
				Прервать;
			ИначеЕсли ПустаяСтрока(КодПоказателя) Тогда
				Продолжить;
			Иначе
				
				ДоступенДляВыбора = КодОКВЭД2ДоступенДляВыбора(КодПоказателя);
				Если ТолькоДоступныеДляВыбора
					И НЕ ДоступенДляВыбора Тогда
					Продолжить;
				КонецЕсли;
				
				НоваяСтрока = КлассификаторОКВЭД2.Добавить();
				НоваяСтрока.Код                 = КодПоказателя;
				НоваяСтрока.Наименование        = Название;
				НоваяСтрока.ПредставлениеПоиска = ВРЕГ(КодПоказателя + " " + Название);
				Если НЕ ТолькоДоступныеДляВыбора Тогда
					НоваяСтрока.ДоступенДляВыбора = ДоступенДляВыбора;
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
	Возврат КлассификаторОКВЭД2;
	
КонецФункции

// Возвращает таблицу ОКВЭД2 с наложенным фильтром по СтрокаПоиска.
// Строка классификатора ОКВЭД включается в результат, если содержит все слова из СтрокаПоиска.
// 
// Параметры:
//  СтрокаПоиска         - Строка - Фильтр для отбора строк классификатора ОКВЭД2.
//  СписокВыбранныхКодов - СписокЗначений - Список, который содержит значения выбранных кодов ОКВЭД.
//  КлассификаторОКВЭД   - ТаблицаЗначений - Таблица классификатора ОКВЭД2. Структуру см. в НовыйТаблицаДляПоискаОКВЭД().
// 
// Возвращаемое значение:
//  Таблица - Таблица классификатора ОКВЭД2 с наложенным отбором по СтрокаПоиска с колонками:
//    - Код          - Строка - Код из классификатора ОКВЭД2
//    - Наименование - Строка - Наименование из классификатора ОКВЭД2
//    - Выбран       - Булево - Истина, если код содержится в СписокВыбранныхКодов.
//
Функция НайтиВКлассификатореОКВЭД2(СтрокаПоиска, СписокВыбранныхКодов, КлассификаторОКВЭД) Экспорт
	
	СхемаКомпоновки = Справочники.Организации.ПолучитьМакет("ОтборОКВЭД");
	
	КомпоновщикНастроек = Новый КомпоновщикНастроекКомпоновкиДанных;
	КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(СхемаКомпоновки));
	КомпоновщикНастроек.ЗагрузитьНастройки(СхемаКомпоновки.НастройкиПоУмолчанию);
	
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "ВыбранныеОКВЭД", СписокВыбранныхКодов);
	
	Отбор = КомпоновщикНастроек.Настройки.Отбор;
	Слова = СтрРазделить(ВРег(СтрЗаменить(СтрокаПоиска, """", "")), " ", Ложь);
	Для Каждого Слово ИЗ Слова Цикл
		БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(Отбор, "ПредставлениеПоиска", СокрЛП(Слово), ВидСравненияКомпоновкиДанных.Содержит);
	КонецЦикла;
	
	НастройкиДляКомпоновкиМакета = КомпоновщикНастроек.ПолучитьНастройки();
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновки, НастройкиДляКомпоновкиМакета, , , Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	
	ВнешниеНаборы = Новый Структура("ТаблицаОКВЭД", КлассификаторОКВЭД);
	
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, ВнешниеНаборы);
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	РезультатЗапроса = ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
	Возврат РезультатЗапроса;
	
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Функция КодОКВЭД2ДоступенДляВыбора(Код)
	
	КоличествоЦифрВКоде = СтрДлина(СтрЗаменить(Код, ".", ""));
	Возврат КоличествоЦифрВКоде >= 4;
	
КонецФункции

#КонецОбласти

#КонецЕсли