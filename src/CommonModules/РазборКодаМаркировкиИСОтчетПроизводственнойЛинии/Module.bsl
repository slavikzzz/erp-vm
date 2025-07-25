
#Область СлужебныйПрограммныйИнтерфейс

#Область ОтчетПроизводственнойЛинии

// Выполняет нормализацию значений штрихкодов
// Параметры:
//  ДанныеОтчетаПроизводственнойЛинии - ТаблицаЗначений - Таблица значений штрихкодов упаковок:
//   * ЗначениеШтрихкода - Строка - значение штрихкода
//   * ЗначениеШтрихкодаУпаковки - Строка - значение штрихкода
//   * ФорматBase64 - Булево - Штрихкод закодирован по алгоритму BASE64.
//  ВидПродукции - ПеречислениеСсылка.ВидыПродукцииИС - фильтр по виду продукции.
//  ПараметрыОбработки - Структура - настройки обработки кодов маркировки:
//   * ПроверятьАлфавитКодовМаркировки - Булево
//   * ВосстанавливатьСтруктуруКодаМаркировки - Булево
//   
// Возвращаемое значение:
//  Структура:
//   * ОбработанныеДанныеОтчета - См. ИнициализацияСостоянияОбработкиКодовМаркировки
//   * ЕстьОшибки - Булево - Признак наличия ошибки в ОбработанныеДанныеОтчета
//   * ИменаГруппКолонок - Массив из Строка - Имена групп колонок (ЗначениеШтрихкода, ЗначениеШтрихкодаУпаковки)
//   * ГруппыКолонок - Массив из Структура - Содержит строковое представление колонок для ИменаГруппКолонок:
//     ** КодМаркировки - Строка
//     ** НормализованныйКодМаркировки - Строка
//     ** ПолныйКодМаркировки - Строка
//     ** ТипШтрихкода - Строка
//     ** ВидУпаковки - Строка
//     ** EAN - Строка
//     ** GTIN - Строка
//     ** КоличествоПотребительскихУпаковок - Строка
//     ** ТекстОшибки - Строка
Функция НормализоватьДанныеОтчетаПроизводственнойЛинии(ДанныеОтчетаПроизводственнойЛинии, ВидПродукции, ПараметрыОбработки) Экспорт
	
	ПараметрыНормализации = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ПараметрыОбработки, "ПараметрыНормализации");
	Если ПараметрыНормализации = Неопределено Тогда
		ПараметрыНормализации = РазборКодаМаркировкиИССлужебныйКлиентСервер.ПараметрыНормализацииКодаМаркировки();
	КонецЕсли;
	
	ПользовательскиеПараметрыРазбораКодаМаркировки = РазборКодаМаркировкиИССлужебныйКлиентСервер.ПользовательскиеПараметрыРазбораКодаМаркировки();
	ПользовательскиеПараметрыРазбораКодаМаркировки.ПроверятьАлфавитЭлементов = ПараметрыОбработки.ПроверятьАлфавитКодовМаркировки;
	ПользовательскиеПараметрыРазбораКодаМаркировки.РасширеннаяДетализация    = Истина;
	ПользовательскиеПараметрыРазбораКодаМаркировки.ВалидироватьШтрихкодЛогистическойУпаковкиGS1128СОшибками = Ложь;
	
	НастройкиРазбора = Новый Структура;
	НастройкиРазбора.Вставить("Кеш",              РазборКодаМаркировкиИССлужебныйКлиентСервер.ИнициализироватьНастройкиИспользующиеРезультатыПредыдущихРазборов());
	НастройкиРазбора.Вставить("Общие",            РазборКодаМаркировкиИССлужебный.НастройкиРазбораКодаМаркировки(ВидПродукции));
	НастройкиРазбора.Вставить("Пользовательские", ПользовательскиеПараметрыРазбораКодаМаркировки);
	
	ПараметрыРазбора = Новый Структура;
	ПараметрыРазбора.Вставить("ВидПродукции", ВидПродукции);
	ПараметрыРазбора.Вставить("НастройкиРазбора", НастройкиРазбора);
	ПараметрыРазбора.Вставить("КешДанныхРазбора", Новый Соответствие);
	ПараметрыРазбора.Вставить("ПараметрыНормализации", ПараметрыНормализации);
	ПараметрыРазбора.Вставить("ВосстанавливатьСтруктуруКодаМаркировки", ПараметрыОбработки.ВосстанавливатьСтруктуруКодаМаркировки);
	
	ПараметрыНормализацииПрочее = РазборКодаМаркировкиИССлужебныйКлиентСервер.ПараметрыНормализацииКодаМаркировки();
	ПараметрыНормализацииПрочее.НачинаетсяСоСкобки = Ложь;
	ПараметрыРазбора.Вставить("ПараметрыНормализацииПрочее", ПараметрыНормализацииПрочее);

	ОбработанныеДанныеОтчетаПроизводственнойЛинии = ИнициализацияСостоянияОбработкиКодовМаркировки();
	
	ИменаГруппКолонок = Новый Массив;
	Если ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ПараметрыОбработки, "ОбрабатыватьЗначенияШтрихкодУпаковок", Истина) Тогда
		ИменаГруппКолонок.Добавить("ЗначениеШтрихкодаУпаковки");
	КонецЕсли;
	ИменаГруппКолонок.Добавить("ЗначениеШтрихкода");
	
	ГруппыКолонок = Новый Массив;
	Для Каждого ИмяГруппыКолонок Из ИменаГруппКолонок Цикл
		
		Если ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ПараметрыОбработки, "КодыМаркировкиНормализованы", Ложь) Тогда
			ИмяКолонкиКодМаркировки = "Нормализованное" + ИмяГруппыКолонок;
		Иначе
			ИмяКолонкиКодМаркировки = ИмяГруппыКолонок;
		КонецЕсли;
		
		ИменаКолонок = Новый Структура;
		ИменаКолонок.Вставить("КодМаркировки",                ИмяКолонкиКодМаркировки);
		ИменаКолонок.Вставить("НормализованныйКодМаркировки", "Нормализованное" + ИмяГруппыКолонок);
		ИменаКолонок.Вставить("ПолныйКодМаркировки",          "Полное"          + ИмяГруппыКолонок);
		ИменаКолонок.Вставить("ТипШтрихкода",                 ИмяГруппыКолонок  + "ТипШтрихкода");
		ИменаКолонок.Вставить("ВидУпаковки",                  ИмяГруппыКолонок  + "ВидУпаковки");
		ИменаКолонок.Вставить("EAN",                          ИмяГруппыКолонок  + "EAN");
		ИменаКолонок.Вставить("GTIN",                         ИмяГруппыКолонок  + "GTIN");
		ИменаКолонок.Вставить("КоличествоВложенныхЕдиниц",    ИмяГруппыКолонок  + "КоличествоВложенныхЕдиниц");
		ИменаКолонок.Вставить("ТекстОшибки",                  "ТекстОшибки"     + ИмяГруппыКолонок);
		ИменаКолонок.Вставить("ДанныеРазбора",                "ДанныеРазбора"   + ИмяГруппыКолонок);
		ИменаКолонок.Вставить("ЭтоКолонкаУпаковки",           ?(ИмяГруппыКолонок = "ЗначениеШтрихкодаУпаковки", Истина, Ложь));
		ИменаКолонок.Вставить("КодДляПередачиИСМП",           ИмяГруппыКолонок + "КодДляПередачиИСМП");
		
		ГруппыКолонок.Добавить(ИменаКолонок);
		
	КонецЦикла;
	
	ЕстьОшибки = Ложь;
	
	Для Каждого ИсходнаяСтрока Из ДанныеОтчетаПроизводственнойЛинии Цикл
		
		Строка = ОбработанныеДанныеОтчетаПроизводственнойЛинии.Добавить();
		Строка.ИсходнаяСтрока = ИсходнаяСтрока;
		
		ВозможнаГрупповаяУпаковкаИлиНабор = Ложь;
		
		Для Каждого ИменаКолонок Из ГруппыКолонок Цикл
			
			ИсходныйКодМаркировки = ИсходнаяСтрока[ИменаКолонок.КодМаркировки];
			
			Если Не ЗначениеЗаполнено(ИсходныйКодМаркировки) Тогда
				Продолжить;
			КонецЕсли;
			
			Если ИсходнаяСтрока.ФорматBase64 Тогда
				КодМаркировки = ШтрихкодированиеОбщегоНазначенияИСКлиентСервер.Base64ВШтрихкод(ИсходныйКодМаркировки);
			Иначе
				КодМаркировки = ИсходныйКодМаркировки;
			КонецЕсли;
			
			Результат = ОбработатьКодМаркировкиДляОтчетаОНанесении(КодМаркировки, ПараметрыРазбора);
			Если Результат.Разобран Тогда
				
				Строка.ИсходнаяСтрока[ИменаКолонок.НормализованныйКодМаркировки] = Результат.НормализованныйКодМаркировки;
				Строка[ИменаКолонок.ТипШтрихкода]                                = Результат.ТипШтрихкода;
				Строка[ИменаКолонок.ВидУпаковки]                                 = Результат.ВидУпаковки;
				Строка[ИменаКолонок.EAN]                                         = Результат.EAN;
				Строка[ИменаКолонок.GTIN]                                        = Результат.GTIN;
				Строка[ИменаКолонок.ДанныеРазбора]                               = Результат.ДанныеРазбора;

				Если Результат.Свойство("КодДляПередачиИСМП") Тогда
					Строка[ИменаКолонок.КодДляПередачиИСМП] = Результат.КодДляПередачиИСМП;
				КонецЕсли;
				
				Если ИменаКолонок.ЭтоКолонкаУпаковки Тогда
					ВозможнаГрупповаяУпаковкаИлиНабор = Не ЗначениеЗаполнено(Результат.ВидУпаковки);
				ИначеЕсли ВозможнаГрупповаяУпаковкаИлиНабор
					И Не ЗначениеЗаполнено(Результат.ВидУпаковки) Тогда
					Строка[ИменаКолонок.ВидУпаковки] = Перечисления.ВидыУпаковокИС.Потребительская;
				КонецЕсли;
				
			КонецЕсли;
			
			Если Результат.ЕстьОшибки Тогда
				
				Строка.ЕстьОшибки = Истина;
				Строка.ИсходнаяСтрока[ИменаКолонок.ТекстОшибки] = Результат.ТекстОшибки;
				
				ЕстьОшибки = Истина;
				
				Продолжить;
			КонецЕсли;
			
			Если Результат.МаркируемаяУпаковка Тогда
				Строка[ИменаКолонок.ПолныйКодМаркировки] = Результат.ПолныйКодМаркировки;
			ИначеЕсли Результат.КоличествоВложенныхЕдиниц <> Неопределено Тогда
				Строка[ИменаКолонок.КоличествоВложенныхЕдиниц] = Результат.КоличествоВложенныхЕдиниц;
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
	
	УникальныеGTIN = Новый Соответствие;
	СписокGTIN     = Новый Массив;
	
	Для Каждого СтрокаДанных Из ОбработанныеДанныеОтчетаПроизводственнойЛинии Цикл
		
		ИсходнаяСтрока = СтрокаДанных.ИсходнаяСтрока;
		
		Для Каждого ИменаКолонок Из ГруппыКолонок Цикл
			
			GTIN = СтрокаДанных[ИменаКолонок.GTIN];
			
			Если УникальныеGTIN[GTIN] <> Неопределено Тогда
				Продолжить;
			КонецЕсли;
			
			ВидУпаковки = СтрокаДанных[ИменаКолонок.ВидУпаковки];
			
			Если Не ЗначениеЗаполнено(ВидУпаковки) Тогда
				СписокGTIN.Добавить(GTIN);
				УникальныеGTIN.Вставить(GTIN, Истина);
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
	
	Если СписокGTIN.Количество() > 0 Тогда
		
		ОписанияGTIN = РегистрыСведений.ОписаниеGTINИС.ПолучитьОписание(СписокGTIN);
		
		Для Каждого СтрокаДанных Из ОбработанныеДанныеОтчетаПроизводственнойЛинии Цикл
			
			ИсходнаяСтрока = СтрокаДанных.ИсходнаяСтрока;
			
			Для Каждого ИменаКолонок Из ГруппыКолонок Цикл
				
				Если Не ЗначениеЗаполнено(СтрокаДанных[ИменаКолонок.ВидУпаковки]) Тогда

					GTIN = СтрокаДанных[ИменаКолонок.GTIN];

					Если УникальныеGTIN[GTIN] = Неопределено Тогда
						Продолжить;
					КонецЕсли;

					ОписаниеGTIN = ОписанияGTIN[GTIN];

					Если ОписаниеGTIN <> Неопределено Тогда
						СтрокаДанных[ИменаКолонок.ВидУпаковки] = ОписаниеGTIN.ВидУпаковки;
					КонецЕсли;

				КонецЕсли;
				
			КонецЦикла;
			
		КонецЦикла;
		
	КонецЕсли;
	
	РезультатОбработкиДанныхОтчета = Новый Структура;
	РезультатОбработкиДанныхОтчета.Вставить("ИменаГруппКолонок",        ИменаГруппКолонок);
	РезультатОбработкиДанныхОтчета.Вставить("ГруппыКолонок",            ГруппыКолонок);
	РезультатОбработкиДанныхОтчета.Вставить("ЕстьОшибки",               ЕстьОшибки);
	РезультатОбработкиДанныхОтчета.Вставить("ОбработанныеДанныеОтчета", ОбработанныеДанныеОтчетаПроизводственнойЛинии);
	
	Возврат РезультатОбработкиДанныхОтчета;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ИнициализацияСостоянияОбработкиКодовМаркировки()
	
	ДанныеШтрихкодов = Новый ТаблицаЗначений;
	ДанныеШтрихкодов.Колонки.Добавить("ИсходнаяСтрока");
	ДанныеШтрихкодов.Колонки.Добавить("ЕстьОшибки", Новый ОписаниеТипов("Булево"));
	
	ДанныеШтрихкодов.Колонки.Добавить("ПолноеЗначениеШтрихкода",       Новый ОписаниеТипов("Строка",,,, Новый КвалификаторыСтроки(200)));
	ДанныеШтрихкодов.Колонки.Добавить("ЗначениеШтрихкодаТипШтрихкода", Новый ОписаниеТипов("ПеречислениеСсылка.ТипыШтрихкодов"));
	ДанныеШтрихкодов.Колонки.Добавить("ЗначениеШтрихкодаВидУпаковки",  Новый ОписаниеТипов("ПеречислениеСсылка.ВидыУпаковокИС"));
	ДанныеШтрихкодов.Колонки.Добавить("ЗначениеШтрихкодаEAN",          Метаданные.ОпределяемыеТипы.GTIN.Тип);
	ДанныеШтрихкодов.Колонки.Добавить("ЗначениеШтрихкодаGTIN",         Метаданные.ОпределяемыеТипы.GTIN.Тип);
	ДанныеШтрихкодов.Колонки.Добавить("ЗначениеШтрихкодаКоличествоВложенныхЕдиниц", ОбщегоНазначения.ОписаниеТипаЧисло(15));
	
	ДанныеШтрихкодов.Колонки.Добавить("ПолноеЗначениеШтрихкодаУпаковки",       Новый ОписаниеТипов("Строка",,,, Новый КвалификаторыСтроки(200)));
	ДанныеШтрихкодов.Колонки.Добавить("ЗначениеШтрихкодаУпаковкиТипШтрихкода", Новый ОписаниеТипов("ПеречислениеСсылка.ТипыШтрихкодов"));
	ДанныеШтрихкодов.Колонки.Добавить("ЗначениеШтрихкодаУпаковкиВидУпаковки",  Новый ОписаниеТипов("ПеречислениеСсылка.ВидыУпаковокИС"));
	ДанныеШтрихкодов.Колонки.Добавить("ЗначениеШтрихкодаУпаковкиEAN",          Метаданные.ОпределяемыеТипы.GTIN.Тип);
	ДанныеШтрихкодов.Колонки.Добавить("ЗначениеШтрихкодаУпаковкиGTIN",         Метаданные.ОпределяемыеТипы.GTIN.Тип);
	ДанныеШтрихкодов.Колонки.Добавить("ЗначениеШтрихкодаУпаковкиКоличествоВложенныхЕдиниц", ОбщегоНазначения.ОписаниеТипаЧисло(15));
	
	ДанныеШтрихкодов.Колонки.Добавить("ДанныеРазбораЗначениеШтрихкода", Новый ОписаниеТипов("Структура"));
	ДанныеШтрихкодов.Колонки.Добавить("ДанныеРазбораЗначениеШтрихкодаУпаковки", Новый ОписаниеТипов("Структура"));

	ДанныеШтрихкодов.Колонки.Добавить("ЗначениеШтрихкодаКодДляПередачиИСМП", Новый ОписаниеТипов("Строка",,,, Новый КвалификаторыСтроки(200)));
	ДанныеШтрихкодов.Колонки.Добавить("ЗначениеШтрихкодаУпаковкиКодДляПередачиИСМП", Новый ОписаниеТипов("Строка",,,, Новый КвалификаторыСтроки(200)));

	Возврат ДанныеШтрихкодов;
	
КонецФункции

Функция ОбработатьКодМаркировкиДляОтчетаОНанесении(КодМаркировки, ПараметрыРазбора)
	
	Результат = ПараметрыРазбора.КешДанныхРазбора[КодМаркировки];
	
	Если Результат <> Неопределено Тогда
		Возврат Результат;
	КонецЕсли;
	
	ДлинаКодаМаркировки    = СтрДлина(КодМаркировки);
	СодержитРазделительGS  = НайтиНедопустимыеСимволыXML(КодМаркировки) > 0;
	
	ПримечаниеКРезультатуРазбора = Неопределено;
	ДанныеРазбора = РазборКодаМаркировкиИССлужебный.РазобратьКодМаркировкиИспользуяПредыдущиеРезультаты(
		КодМаркировки,
		ПараметрыРазбора.НастройкиРазбора.Кеш,
		ПараметрыРазбора.ВидПродукции,
		ПримечаниеКРезультатуРазбора,
		ПараметрыРазбора.НастройкиРазбора.Общие,
		ПараметрыРазбора.НастройкиРазбора.Пользовательские);
	
	Если ДанныеРазбора = Неопределено Тогда
		
		ТекстОшибки = СтрШаблон(
			НСтр("ru = 'Не удалось разобрать код маркировки:
			|%1';
			|en = 'Не удалось разобрать код маркировки:
			|%1'"),
			ПримечаниеКРезультатуРазбора.ТекстОшибки);
		
		Результат = Новый Структура;
		Результат.Вставить("ЕстьОшибки",  Истина);
		Результат.Вставить("ТекстОшибки", ТекстОшибки);
		Результат.Вставить("Разобран",    Ложь);
		
		ПараметрыРазбора.КешДанныхРазбора[КодМаркировки] = Результат;
		
		Возврат Результат;
		
	КонецЕсли;
	
	КодДляПередачиИСМП = РазборКодаМаркировкиИССлужебныйКлиентСервер.НормализоватьКодМаркировки(
		ДанныеРазбора, ПараметрыРазбора.ВидПродукции, ПараметрыРазбора.ПараметрыНормализацииПрочее);

	Результат = Новый Структура;
	Результат.Вставить("ЕстьОшибки",                   Ложь);
	Результат.Вставить("ТекстОшибки",                  "");
	Результат.Вставить("Разобран",                     Истина);
	Результат.Вставить("ВидУпаковки",                  ДанныеРазбора.ВидУпаковки);
	Результат.Вставить("ТипШтрихкода",                 ДанныеРазбора.ТипШтрихкода);
	Результат.Вставить("НормализованныйКодМаркировки", ДанныеРазбора.НормализованныйКодМаркировки);
	Результат.Вставить("МаркируемаяУпаковка",          Ложь);
	Результат.Вставить("ПолныйКодМаркировки",          "");
	Результат.Вставить("EAN",                          "");
	Результат.Вставить("GTIN",                         "");
	Результат.Вставить("КоличествоВложенныхЕдиниц",    Неопределено);
	Результат.Вставить("ДанныеРазбора",                ДанныеРазбора);
	Результат.Вставить("КодДляПередачиИСМП",           КодДляПередачиИСМП);

	ПараметрыРазбора.КешДанныхРазбора[КодМаркировки] = Результат;
	
	Если ДанныеРазбора.ВидУпаковки = Перечисления.ВидыУпаковокИС.Логистическая Тогда
		
		Если ДанныеРазбора.ТипШтрихкода = Перечисления.ТипыШтрихкодов.GS1_128
			И ДанныеРазбора.Детализация.ЭтоНеФормализованныйКодМаркировки Тогда
			
			Результат.EAN                       = ДанныеРазбора.СоставКодаМаркировки.EAN;
			Результат.GTIN                      = ДанныеРазбора.СоставКодаМаркировки.GTIN;
			Результат.КоличествоВложенныхЕдиниц = ДанныеРазбора.СоставКодаМаркировки.КоличествоВложенныхЕдиниц;
			
		КонецЕсли;
		
		Возврат Результат
		
	КонецЕсли;
	
	Если Не (ДанныеРазбора.ВидУпаковки = Перечисления.ВидыУпаковокИС.Потребительская
		Или ШтрихкодированиеОбщегоНазначенияИСКлиентСервер.ВозможнаГрупповаяУпаковкаИлиНабор(
			ДанныеРазбора.ВидУпаковки, ДанныеРазбора)) Тогда
		
		// Логистическая упаковка
		
		Возврат Результат;
		
	КонецЕсли;
	
	Результат.МаркируемаяУпаковка = Истина;
	Результат.EAN                 = ДанныеРазбора.СоставКодаМаркировки.EAN;
	Результат.GTIN                = ДанныеРазбора.СоставКодаМаркировки.GTIN;
	
	ДетализацияРазбора = ДанныеРазбора.Детализация;
	
	Если Не ЗначениеЗаполнено(ДанныеРазбора.Детализация.ШаблонРазбораКодаМаркировки) Тогда
		
		Результат.ЕстьОшибки  = Истина;
		Результат.ТекстОшибки = НСтр("ru = 'Не удалось определить шаблон кода маркировки';
									|en = 'Не удалось определить шаблон кода маркировки'");
		
		Возврат Результат;
		
	КонецЕсли;
	
	ДанныеШаблонаКМ  = ПараметрыРазбора.НастройкиРазбора.Общие.ШаблоныКодовМаркировки.Найти(ДетализацияРазбора.ШаблонРазбораКодаМаркировки, "Шаблон");
	ЭталоннаяДлинаКМ = ДанныеШаблонаКМ["Длина" + ДетализацияРазбора.ИмяСвойстваПозиции];
	
	Если ЭталоннаяДлинаКМ <> ДлинаКодаМаркировки
		И Не ((ПараметрыРазбора.ВидПродукции = Перечисления.ВидыПродукцииИС.КреслаКоляски
				Или ПараметрыРазбора.ВидПродукции = Перечисления.ВидыПродукцииИС.ТехническиеСредстваРеабилитации
				Или ПараметрыРазбора.ВидПродукции = Перечисления.ВидыПродукцииИС.МедицинскиеИзделия
				Или ПараметрыРазбора.ВидПродукции = Перечисления.ВидыПродукцииИС.МедицинскиеИзделия20)
			И ЭталоннаяДлинаКМ < ДлинаКодаМаркировки) Тогда
		
		// Код маркировки был модифицирован в методе разбора,
		// для дальнейшей обработки этот код не подходит
		
		Результат.ЕстьОшибки  = Истина;
		Результат.ТекстОшибки = НСтр("ru = 'Длина кода маркировки не соответствует длине шаблона';
									|en = 'Длина кода маркировки не соответствует длине шаблона'");
		
		Возврат Результат;
		
	КонецЕсли;
	
	ЕстьОшибки        = Ложь;
	СообщенияОбОшибке = Новый Массив;
	
	ВключаетКриптоХвост = ДанныеРазбора.СоставКодаМаркировки.ВключаетКриптоХвост;
	
	ВосстановитьСтруктуруКодаМаркировки  = Ложь;
	ПолныйКодМаркировки                  = Неопределено;
	ШаблонКодаМаркировкиНеПоддерживается = Ложь;
	Если ВключаетКриптоХвост Тогда
		Если ДетализацияРазбора.ВключаетИдентификаторыПрименения Тогда
			Если СодержитРазделительGS Тогда
				ПолныйКодМаркировки = КодМаркировки;
			Иначе
				ВосстановитьСтруктуруКодаМаркировки  = ПараметрыРазбора.ВосстанавливатьСтруктуруКодаМаркировки;
				ШаблонКодаМаркировкиНеПоддерживается = Не ПараметрыРазбора.ВосстанавливатьСтруктуруКодаМаркировки;
			КонецЕсли;
		Иначе
			ПолныйКодМаркировки = КодМаркировки;
		КонецЕсли;
	КонецЕсли;
	
	Если ШаблонКодаМаркировкиНеПоддерживается Тогда
		// Нельзя восстанавливать GS в коде маркировки
		ЕстьОшибки = Истина;
		СообщенияОбОшибке.Добавить(
			НСтр("ru = 'Формат кода маркировки некорректный:
			          |В структуре кода маркировки отсутствуют разделители GS';
			          |en = 'Формат кода маркировки некорректный:
			          |В структуре кода маркировки отсутствуют разделители GS'"));
	КонецЕсли;
	
	Если ВосстановитьСтруктуруКодаМаркировки Тогда
		
		ПолныйКодМаркировки = РазборКодаМаркировкиИССлужебныйКлиентСервер.ПолныйКодМаркировкиИзЗначенийЭлементов(
			ДетализацияРазбора.ЗначенияЭлементовКодаМаркировки,
			ДетализацияРазбора.ОписаниеЭлементовКодаМаркировки,
			ПараметрыРазбора.НастройкиРазбора.Общие.ИдентификаторыПримененияСРазделителемGS);
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ПолныйКодМаркировки) Тогда
		Результат.ПолныйКодМаркировки = ШтрихкодированиеОбщегоНазначенияИСКлиентСервер.ШтрихкодВBase64(ПолныйКодМаркировки);
	КонецЕсли;
	
	Если ЕстьОшибки Тогда
		Результат.ЕстьОшибки  = Истина;
		Результат.ТекстОшибки = СтрСоединить(СообщенияОбОшибке, Символы.ПС);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

