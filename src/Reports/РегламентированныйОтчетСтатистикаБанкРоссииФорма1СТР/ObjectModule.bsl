#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Перем ИменаРазделовИТаблицСтр;

Перем ИменаСправочниковИСсылки;

#Область СлужебныеПроцедурыИФункции

#Область ФормированиеРегламентированногоОтчета

Процедура ИнициализацияПеременныхМодуля()
	
	// В каждой группе <Имя раздела>,<Имя таблицы шаблона>.
	ИменаРазделовИТаблицСтр = "Раздел1,Rtbl1;Раздел2,Rtbl2;Раздел3,Rtbl3;Раздел4,Rtbl4;"
			+ "Раздел511,Rtbl511;Раздел512,Rtbl512;Раздел521,Rtbl521;Раздел522,Rtbl522";
	ИменаСправочниковИСсылки = Новый СписокЗначений;
	ИменаСправочниковИСсылки.Добавить("OKVED",     "ОКВЭД2", Истина); // ОКВЭД2
	ИменаСправочниковИСсылки.Добавить("OKOPF",     "F:G");            // ОКОПФ
	ИменаСправочниковИСсылки.Добавить("OKFS",      "H:I");            // ОКФС
	ИменаСправочниковИСсылки.Добавить("OKSM",      "L:M");            // КодыСтран
	ИменаСправочниковИСсылки.Добавить("OKSM2",     "N:O");            // КодыСтран2
	ИменаСправочниковИСсылки.Добавить("OKV",       "P:Q");            // КодыВалют
	ИменаСправочниковИСсылки.Добавить("OKTMO1",    "J:K");            // Территории
	
	ИменаСправочниковИСсылки.Добавить("OKTMO",     "ОКТМО", Истина);  // ОКТМО
	
КонецПроцедуры

#КонецОбласти

#Область ВыгрузкаРегламентированногоОтчета

Процедура ПрочитатьМетаданныеШаблона(МакетМетаданныхШаблона, МакетСписковВыбора, МетаданныеШаблона) Экспорт
	
	Если ТипЗнч(МетаданныеШаблона) <> Тип("Структура") Тогда
		МетаданныеШаблона = Новый Структура();
	КонецЕсли;
	
	Для Каждого Область Из МакетМетаданныхШаблона.Области Цикл
		Если Область.ТипОбласти = ТипОбластиЯчеекТабличногоДокумента.Строки Тогда
			
			ВерхОбласти  = Область.Верх;
			НизОбласти   = Область.Низ;
			ЛевоОбласти  = 1;
			ПравоОбласти = 256;
			
			Если Область.Имя = "Question_Meta" Тогда
				
				ТаблВопросовШаблона = Новый ТаблицаЗначений;
				Для НомКол = ЛевоОбласти По ПравоОбласти Цикл
					ИмяКолонки = СокрЛП(МакетМетаданныхШаблона.Область(ВерхОбласти, НомКол).Текст);
					Если ПустаяСтрока(ИмяКолонки) Тогда
						ПравоОбласти = НомКол - 1;
						Прервать;
					КонецЕсли;
					ТаблВопросовШаблона.Колонки.Добавить(ИмяКолонки, Новый ОписаниеТипов("Строка"));
				КонецЦикла;
				
				Для НомСтр = ВерхОбласти + 1 По НизОбласти Цикл
					ЗначениеОбластиВПервойКолонке = СокрЛП(МакетМетаданныхШаблона.Область(НомСтр, ЛевоОбласти).Текст);
					Если НЕ ПустаяСтрока(ЗначениеОбластиВПервойКолонке) Тогда
						ИндКолонки = 0;
						НовСтрока = ТаблВопросовШаблона.Добавить();
						Для НомКол = ЛевоОбласти По ПравоОбласти Цикл
							ЗначениеОбласти = СокрП(МакетМетаданныхШаблона.Область(НомСтр, НомКол, НомСтр, НомКол).Текст);
							НовСтрока.Установить(ИндКолонки, ЗначениеОбласти);
							ИндКолонки = ИндКолонки + 1;
						КонецЦикла;
					КонецЕсли;
				КонецЦикла;
				
				МетаданныеШаблона.Вставить(Область.Имя, ТаблВопросовШаблона);
				
			ИначеЕсли Область.Имя = "Period_Check_Meta" Тогда
				
				ТаблПроверкиПериодаШаблона = Новый ТаблицаЗначений;
				Для НомКол = ЛевоОбласти По ПравоОбласти Цикл
					ИмяКолонки = СокрЛП(МакетМетаданныхШаблона.Область(ВерхОбласти, НомКол).Текст);
					Если ПустаяСтрока(ИмяКолонки) Тогда
						ПравоОбласти = НомКол - 1;
						Прервать;
					КонецЕсли;
					ТаблПроверкиПериодаШаблона.Колонки.Добавить(ИмяКолонки, Новый ОписаниеТипов("Строка"));
				КонецЦикла;
				
				Для НомСтр = ВерхОбласти + 1 По НизОбласти Цикл
					ЗначениеОбластиВПервойКолонке = СокрЛП(МакетМетаданныхШаблона.Область(НомСтр, ЛевоОбласти).Текст);
					Если НЕ ПустаяСтрока(ЗначениеОбластиВПервойКолонке) Тогда
						ИндКолонки = 0;
						НовСтрока = ТаблПроверкиПериодаШаблона.Добавить();
						Для НомКол = ЛевоОбласти По ПравоОбласти Цикл
							ЗначениеОбласти = СокрП(МакетМетаданныхШаблона.Область(НомСтр, НомКол, НомСтр, НомКол).Текст);
							НовСтрока.Установить(ИндКолонки, ЗначениеОбласти);
							ИндКолонки = ИндКолонки + 1;
						КонецЦикла;
					КонецЕсли;
				КонецЦикла;
				
				МетаданныеШаблона.Вставить(Область.Имя, ТаблПроверкиПериодаШаблона);
				
			ИначеЕсли Область.Имя = "Survey_Meta" Тогда
				
				СписокОпросШаблона = Новый СписокЗначений;
				
				Для НомСтр = ВерхОбласти По НизОбласти Цикл
					ЗначениеОбластиВПервойКолонке = СокрЛП(МакетМетаданныхШаблона.Область(НомСтр, ЛевоОбласти).Текст);
					Если НЕ ПустаяСтрока(ЗначениеОбластиВПервойКолонке) Тогда
						ЗначениеОбластиВоВторойКолонке = СокрП(МакетМетаданныхШаблона.Область(НомСтр, ЛевоОбласти + 1).Текст);
						СписокОпросШаблона.Добавить(ЗначениеОбластиВоВторойКолонке, ЗначениеОбластиВПервойКолонке);
					КонецЕсли;
				КонецЦикла;
				
				МетаданныеШаблона.Вставить(Область.Имя, СписокОпросШаблона);
				
			ИначеЕсли Область.Имя = "KeyValuePair_Meta" Тогда
				
				СправочникиКлючИЗначение = Новый Структура;
				
				Для НомСтр = ВерхОбласти По НизОбласти Цикл
					ЗначениеОбластиВПервойКолонке = СокрЛП(МакетМетаданныхШаблона.Область(НомСтр, ЛевоОбласти).Текст);
					Если НЕ ПустаяСтрока(ЗначениеОбластиВПервойКолонке) Тогда
						ЗначениеОбластиВоВторойКолонке = СокрП(МакетМетаданныхШаблона.Область(НомСтр, ЛевоОбласти + 1).Текст);
						СпрКоординатыОбласти = РегламентированнаяОтчетностьБанкРоссии.КоординатыОбласти(ЗначениеОбластиВоВторойКолонке);
						
						ТаблСправочникКлючИЗначение = Новый ТаблицаЗначений;
						ТаблСправочникКлючИЗначение.Колонки.Добавить("Ключ",     Новый ОписаниеТипов("Строка"));
						ТаблСправочникКлючИЗначение.Колонки.Добавить("Значение", Новый ОписаниеТипов("Строка"));
						Для НомСтрСпр = ВерхОбласти По НизОбласти Цикл
							Ключ = СокрЛП(МакетМетаданныхШаблона.Область(НомСтрСпр, СпрКоординатыОбласти.Столбец1).Текст);
							Значение = СокрЛП(МакетМетаданныхШаблона.Область(НомСтрСпр, СпрКоординатыОбласти.Столбец2).Текст);
							Если НЕ ПустаяСтрока(Ключ) Тогда
								НовСтрока = ТаблСправочникКлючИЗначение.Добавить();
								НовСтрока.Ключ = Ключ;
								НовСтрока.Значение = Значение;
							Иначе
								Прервать;
							КонецЕсли;
						КонецЦикла;
						
						СправочникиКлючИЗначение.Вставить(ЗначениеОбластиВПервойКолонке, ТаблСправочникКлючИЗначение);
					Иначе
						Прервать;
					КонецЕсли;
				КонецЦикла;
				
				МетаданныеШаблона.Вставить(Область.Имя, СправочникиКлючИЗначение);
				
			ИначеЕсли Область.Имя = "NSI_Meta" Тогда
				
				СправочникиКлючИЗначение = Новый Структура;
				
				Для Каждого ЭлементИмяИСсылка Из ИменаСправочниковИСсылки Цикл
					
					ИмяСправочника   = ЭлементИмяИСсылка.Значение;
					СсылкаНаДиапазон = ЭлементИмяИСсылка.Представление;
					
					ТекМакетМетаданных = МакетМетаданныхШаблона;
					ВерхОбластиСпр = ВерхОбласти;
					НизОбластиСпр  = НизОбласти;
					НомерКолонкиКлюч = 1;
					НомерКолонкиЗначение = 2;
					Если ЭлементИмяИСсылка.Пометка Тогда // справочник загружаем из макета "СпискиВыбора*"
						Если МакетСписковВыбора = Неопределено Тогда
							Продолжить;
						КонецЕсли;
						ТекМакетМетаданных = МакетСписковВыбора;
						ОбластьСправочника = ТекМакетМетаданных.Области.Найти(СсылкаНаДиапазон);
						Если ОбластьСправочника = Неопределено Тогда
							Продолжить;
						КонецЕсли;
						ВерхОбластиСпр = ОбластьСправочника.Верх;
						НизОбластиСпр  = ОбластьСправочника.Низ;
						// Выполним следующие действия, если справочник размещен в сжатом макете.
						Ключ = СокрЛП(ТекМакетМетаданных.Область(ВерхОбластиСпр, НомерКолонкиКлюч).Текст);
						Если Лев(Ключ, 1) = "@" Тогда
							Если НРег(Прав(Ключ, 3) = "zip") Тогда
								ИмяСжатогоМакета = Сред(Ключ, 2);
								ИмяОбласти = СокрЛП(ТекМакетМетаданных.Область(ВерхОбластиСпр, НомерКолонкиЗначение).Текст);
								ТекМакетМетаданных = РаспакованныйМакетМетаданных(ИмяСжатогоМакета, ИмяОбласти, ВерхОбластиСпр, НизОбластиСпр);
							Иначе
								Продолжить;
							КонецЕсли;
						КонецЕсли;
					Иначе
						СпрКоординатыОбласти = РегламентированнаяОтчетностьБанкРоссии.КоординатыОбласти(СсылкаНаДиапазон);
						НомерКолонкиКлюч     = СпрКоординатыОбласти.Столбец1;
						НомерКолонкиЗначение = СпрКоординатыОбласти.Столбец2;
					КонецЕсли;
					
					ТаблСправочникКлючИЗначение = Новый ТаблицаЗначений;
					ТаблСправочникКлючИЗначение.Колонки.Добавить("Ключ",     Новый ОписаниеТипов("Строка"));
					ТаблСправочникКлючИЗначение.Колонки.Добавить("Значение", Новый ОписаниеТипов("Строка"));
					
					Для НомСтрСпр = ВерхОбластиСпр + 1 По НизОбластиСпр Цикл
						Ключ = СокрЛП(ТекМакетМетаданных.Область(НомСтрСпр, НомерКолонкиКлюч).Текст);
						Значение = СокрЛП(ТекМакетМетаданных.Область(НомСтрСпр, НомерКолонкиЗначение).Текст);
						Если НЕ ПустаяСтрока(Ключ) Тогда
							НовСтрока = ТаблСправочникКлючИЗначение.Добавить();
							НовСтрока.Ключ = Ключ;
							НовСтрока.Значение = Значение;
						Иначе
							Прервать;
						КонецЕсли;
					КонецЦикла;
					
					СправочникиКлючИЗначение.Вставить(ИмяСправочника, ТаблСправочникКлючИЗначение);
					
				КонецЦикла;
				
				МетаданныеШаблона.Вставить(Область.Имя, СправочникиКлючИЗначение);
				
			КонецЕсли;
			
		КонецЕсли;
	КонецЦикла;
	
	// Создадим таблицу данных листа ответов анкеты.
	ТаблОтветовШаблона = Новый ТаблицаЗначений;
	ТаблОтветовШаблона.Колонки.Добавить("ИДВопроса",      Новый ОписаниеТипов("Строка"));
	ТаблОтветовШаблона.Колонки.Добавить("ЗначениеОтвета", Новый ОписаниеТипов("Строка"));
	ТаблОтветовШаблона.Колонки.Добавить("НомСтрокиЛиста", Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(6, 0)));
	ТаблОтветовШаблона.Добавить();
	
	МетаданныеШаблона.Вставить("Answer_Meta", ТаблОтветовШаблона);
	
	// Создадим таблицу данных листа ошибок анкеты.
	ТаблОшибокШаблона = Новый ТаблицаЗначений;
	ТаблОшибокШаблона.Колонки.Добавить("АдресОшибки",    Новый ОписаниеТипов("Строка"));
	ТаблОшибокШаблона.Колонки.Добавить("МестоОшибки",    Новый ОписаниеТипов("Строка"));
	ТаблОшибокШаблона.Колонки.Добавить("ОписаниеОшибки", Новый ОписаниеТипов("Строка"));
	ТаблОшибокШаблона.Добавить();
	
	МетаданныеШаблона.Вставить("Errors_Meta", ТаблОшибокШаблона);
	
КонецПроцедуры

Процедура ПодготовитьТаблицыРазделов(Форма, МетаданныеШаблона, ИменаРазделовИТаблиц)
	
	МетаданныеШаблона.Вставить("ТаблицыРазделов", Новый Структура());
	
	Для Каждого ИмяРазделаИТаблицыСтр Из ИменаРазделовИТаблиц Цикл
		ИмяРазделаИТаблицы = СтрРазделить(ИмяРазделаИТаблицыСтр, ",");
		
		ТаблицаРаздела = Новый ТаблицаЗначений;
		ТаблицаРаздела.Колонки.Добавить("НС", Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(7,0)));
		
		МетаданныеШаблона.ТаблицыРазделов.Вставить(ИмяРазделаИТаблицы[1], ТаблицаРаздела);
		
		Для Каждого ЭлементСтруктуры Из Форма.мДанныеОтчета[ИмяРазделаИТаблицы[0]] Цикл
			
			Для НомСтр = 1 По ЭлементСтруктуры.Значение.Количество() Цикл
				ДанныеСтроки = ЭлементСтруктуры.Значение[НомСтр - 1];
				
				СтрокаНеПустая = Ложь;
				НовСтрока = ТаблицаРаздела.Добавить();
				Для Каждого ЭлементДанных Из ДанныеСтроки Цикл
					ГрафаПоказателя = СтрЗаменить(ЭлементДанных.Ключ, ЭлементСтруктуры.Ключ, "");
					Если НЕ ПустаяСтрока(ГрафаПоказателя) Тогда
						НомерГрафыПоказателя = Число(" " + ГрафаПоказателя);
						
						КоличествоКолонок = ТаблицаРаздела.Колонки.Количество();
						Если НомерГрафыПоказателя >= КоличествоКолонок Тогда
							Для НомКол = КоличествоКолонок + 1 По НомерГрафыПоказателя Цикл
								ТаблицаРаздела.Колонки.Добавить();
							КонецЦикла;
							ТаблицаРаздела.Колонки.Добавить(ЭлементДанных.Ключ);
						ИначеЕсли ПустаяСтрока(ТаблицаРаздела.Колонки[НомерГрафыПоказателя].Имя) Тогда
							ТаблицаРаздела.Колонки[НомерГрафыПоказателя].Имя = ЭлементДанных.Ключ; 
						КонецЕсли;
						
						НовСтрока[НомерГрафыПоказателя] = ЭлементДанных.Значение;
						Если ЗначениеЗаполнено(ЭлементДанных.Значение) Тогда
							СтрокаНеПустая  = Истина;
						КонецЕсли;
					КонецЕсли;
				КонецЦикла;
				
				Если НЕ СтрокаНеПустая Тогда
					ТаблицаРаздела.Удалить(НовСтрока);
				Иначе
					НовСтрока.НС = НомСтр;
				КонецЕсли;
			КонецЦикла;
			
			Прервать;
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры

Функция РаспакованныйМакетМетаданных(ИмяСжатогоМакета, ИмяОбласти, ВерхОбластиСпр, НизОбластиСпр)
	
	АрхивМакетаМетаданных = ПолучитьМакет(ИмяСжатогоМакета);
	
	Попытка
		ЧтениеАрхиваМетаданных = Новый ЧтениеZipФайла(АрхивМакетаМетаданных.ОткрытьПотокДляЧтения());
	Исключение
		ВызватьИсключение НСтр("ru = 'В макете отсутствуют сжатые данные.';
								|en = 'В макете отсутствуют сжатые данные.'");
	КонецПопытки;
	
	МакетМетаданных = Новый ТабличныйДокумент;

	ИмяВременнойПапкиZIP = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(ПолучитьИмяВременногоФайла());
	СоздатьКаталог(ИмяВременнойПапкиZIP);
	
	ИмяФайлаМакетаМетаданных = ИмяВременнойПапкиZIP + ЧтениеАрхиваМетаданных.Элементы[0].Имя;
	
	ЧтениеАрхиваМетаданных.Извлечь(ЧтениеАрхиваМетаданных.Элементы[0], ИмяВременнойПапкиZIP,
		РежимВосстановленияПутейФайловZIP.НеВосстанавливать);
	ЧтениеАрхиваМетаданных.Закрыть();
	
	МакетМетаданных.Прочитать(ИмяФайлаМакетаМетаданных);
	
	Если ЗначениеЗаполнено(ИмяОбласти) Тогда
		ОбластьСправочника = МакетМетаданных.Область(ИмяОбласти);
	Иначе
		ОбластьСправочника = МакетМетаданных.Область();
	КонецЕсли;
	ВерхОбластиСпр = ОбластьСправочника.Верх;
	НизОбластиСпр  = ОбластьСправочника.Низ;
	
	УдалитьФайлы(ИмяВременнойПапкиZIP);
	
	Возврат МакетМетаданных;
	
КонецФункции

Функция ВыполнитьПроверкуДанных(Форма, ПараметрыВыгрузки, ЕстьПредупреждения = Ложь) Экспорт
	
	СтатусПроверки = Истина;
	
	ИменаРазделовИТаблиц = СтрРазделить(ИменаРазделовИТаблицСтр, ";");
	
	ТаблВопросы = ПараметрыВыгрузки.МетаданныеШаблона["Question_Meta"];
	
	// Подготовка таблиц для обработки и контроля, добавление их в метаданные шаблона.
	ПодготовитьТаблицыРазделов(Форма, ПараметрыВыгрузки.МетаданныеШаблона, ИменаРазделовИТаблиц);
	
	// Обработаем вопросы анкеты для титульного листа.
	СтруктураДанныхТитульный = Форма.мДанныеОтчета.Титульный;
	ВопросыТитульный = ТаблВопросы.НайтиСтроки(Новый Структура("QUESTION_TYPE", "HEADER"));
	Для Каждого ТекВопрос Из ВопросыТитульный Цикл
		ИмяПоказателя = ТекВопрос["QUESTION_NAME_ID"];
		ЗначениеПоказателя = Неопределено;
		Если СтруктураДанныхТитульный.Свойство(ИмяПоказателя, ЗначениеПоказателя) Тогда
			Описание = "";
			РезультатПроверки = РегламентированнаяОтчетностьБанкРоссии.ВыполнитьПроверкуЗначения(
				Форма, ПараметрыВыгрузки, Описание, ТекВопрос, ЗначениеПоказателя);
			Если РезультатПроверки > 0 Тогда
				Если РезультатПроверки = 1 Тогда // Предупреждение
					ЕстьПредупреждения = Истина;
				ИначеЕсли РезультатПроверки = 2 Тогда // Ошибка
					СтатусПроверки = Ложь;
				КонецЕсли;
				
				МестоОшибки = "Титульный лист" + ": """ + ТекВопрос["QUESTION_TEXT"] + """";
				ТекстОшибки = Описание + Символы.ПС + Символы.Таб + "<" + МестоОшибки + ">";
				РегламентированнаяОтчетность.СообщитьВТаблицуСообщений(
					Форма, ТекстОшибки, "Титульный", ИмяПоказателя);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	// Обновим необходимые данные опроса, если существует поле "NamePeriod".
	Если СтруктураДанныхТитульный.Свойство("NamePeriod") Тогда
		ОбновитьДанныеОпросаПоПериоду(ПараметрыВыгрузки);
	КонецЕсли;
	
	// Обработаем вопросы анкеты для листов с таблицами.
	Для Каждого ИмяРазделаИТаблицыСтр Из ИменаРазделовИТаблиц Цикл
		
		ИмяРазделаИТаблицы = СтрРазделить(ИмяРазделаИТаблицыСтр, ",");
		
		ВопросыРаздела = ТаблВопросы.НайтиСтроки(
			Новый Структура("QUESTION_TYPE,QUESTION_ENTITY", "TABLE", ИмяРазделаИТаблицы[1]));
		
		ТаблицаРаздела = ПараметрыВыгрузки.МетаданныеШаблона.ТаблицыРазделов[ИмяРазделаИТаблицы[1]]; 
		КоличествоКолонокТаблицы = ТаблицаРаздела.Колонки.Количество();
		
		Для НомСтр = 1 По ТаблицаРаздела.Количество() Цикл
			ДанныеСтрокиТаблицы = ТаблицаРаздела[НомСтр - 1];
			СтрНомСтроки = Формат(ДанныеСтрокиТаблицы.НС, "ЧГ=");
			
			ВопросыРазделаИЗначения = Новый Соответствие;
			Для НомВопроса = 1 По ВопросыРаздела.Количество() Цикл
				ТекВопрос = ВопросыРаздела[НомВопроса - 1];
				
				НомКолонки = Число(" " + ТекВопрос["QUESTION_SORT"]);
				НомКолонки = ?(НомКолонки > 0, НомКолонки, НомВопроса);
				
				Если КоличествоКолонокТаблицы > НомКолонки Тогда
					Описание = "";
					ЗначениеОтвета = ДанныеСтрокиТаблицы[НомКолонки];
					
					РезультатПроверки = РегламентированнаяОтчетностьБанкРоссии.ВыполнитьПроверкуЗначения(
						Форма, ПараметрыВыгрузки, Описание, ТекВопрос, ЗначениеОтвета, НомСтр);
					Если РезультатПроверки > 0 Тогда
						Если РезультатПроверки = 1 Тогда // Предупреждение
							ЕстьПредупреждения = Истина;
						ИначеЕсли РезультатПроверки = 2 Тогда // Ошибка
							СтатусПроверки = Ложь;
						КонецЕсли;
						
						МестоОшибки = "Раздел " + Прав(ИмяРазделаИТаблицы[0], 1)
							+ " [строка " + СтрНомСтроки  + "]: """ + ТекВопрос["QUESTION_TEXT"] + """";
						ТекстОшибки = Описание + Символы.ПС + Символы.Таб + "<" + МестоОшибки + ">";
						РегламентированнаяОтчетность.СообщитьВТаблицуСообщений(Форма, ТекстОшибки, ИмяРазделаИТаблицы[0],
							ТаблицаРаздела.Колонки[НомКолонки].Имя + "_" + СтрНомСтроки);
					КонецЕсли;
					
					// Преобразовываем необязательные к заполнению числовые значения в зависимости от ограничений.
					Если РегламентированнаяОтчетностьБанкРоссии.ПреобразоватьЗначениеЕслиНеобходимо(ЗначениеОтвета, ТекВопрос) Тогда
						ДанныеСтрокиТаблицы[НомКолонки] = ЗначениеОтвета;
					КонецЕсли;
					
					ВопросыРазделаИЗначения.Вставить(ТекВопрос["QUESTION_NAME_ID"],
						Новый Структура("ИмяКолонки,Значение,Результат,Вопрос",
							ТаблицаРаздела.Колонки[НомКолонки].Имя, ЗначениеОтвета, РезультатПроверки, ТекВопрос));
				КонецЕсли;
			КонецЦикла;
			
			РезультатПроверки = ВыполнитьПроверкуСтроки(Форма, ИмяРазделаИТаблицы,
				ТаблицаРаздела, ВопросыРазделаИЗначения, ПараметрыВыгрузки, НомСтр);
			Если РезультатПроверки = 1 Тогда      // предупреждения
				ЕстьПредупреждения = Истина;
			ИначеЕсли РезультатПроверки = 2 Тогда // ошибки
				СтатусПроверки = Ложь;
			ИначеЕсли РезультатПроверки = 3 Тогда // ошибки и предупреждения
				ЕстьПредупреждения = Истина;
				СтатусПроверки = Ложь;
			КонецЕсли;
		КонецЦикла;
		
	КонецЦикла;
	
	Возврат СтатусПроверки;
	
КонецФункции

Функция ВыполнитьПроверкуСтроки(Форма, ИмяРазделаИТаблицы,
			ТаблицаРаздела, ВопросыРазделаИЗначения, ПараметрыВыгрузки, НомСтр)
	
	РезультатПроверки = 0;
	
	ДанныеСтрокиТаблицы = ТаблицаРаздела[НомСтр - 1];
	СтрНомСтроки = Формат(ДанныеСтрокиТаблицы.НС, "ЧГ=");
	
	// Проверка строки раздела 5.1.1.
	Если ИмяРазделаИТаблицы[1] = "Rtbl511" Тогда
		
		ЭлементыПолей = Новый Массив(4); // индексы полей начинаются с 4
		ЭлементыПолей.Добавить(ВопросыРазделаИЗначения["DebtStart_Rtbl511"]);
		ЭлементыПолей.Добавить(ВопросыРазделаИЗначения["Accrued_Rtbl511"]);
		ЭлементыПолей.Добавить(ВопросыРазделаИЗначения["Income_Rtbl511"]);
		ЭлементыПолей.Добавить(ВопросыРазделаИЗначения["Other_Rtbl511"]);
		ЭлементыПолей.Добавить(ВопросыРазделаИЗначения["DebtEnd_Rtbl511"]);
		
		Для НомПоля = 1 По ВопросыРазделаИЗначения.Количество() - 1 Цикл
			ЭлементыПолей.Добавить(ВопросыРазделаИЗначения[Строка(НомПоля)+ "_" + ИмяРазделаИТаблицы[1]]);
		КонецЦикла;
		
		Если ЭлементыПолей[8] <> Неопределено
		   И ЭлементыПолей[4] <> Неопределено И ЭлементыПолей[5] <> Неопределено
		   И ЭлементыПолей[6] <> Неопределено И ЭлементыПолей[7] <> Неопределено Тогда
			Если ЭлементыПолей[8].Значение
			  <> ЭлементыПолей[4].Значение + ЭлементыПолей[5].Значение
			   - ЭлементыПолей[6].Значение + ЭлементыПолей[7].Значение Тогда
				Описание = НСтр("ru = 'ОШИБКА: Не выполнено равенство: Графа 8 = Графа 4 + Графа 5 - Графа 6 + Графа 7';
								|en = 'ОШИБКА: Не выполнено равенство: Графа 8 = Графа 4 + Графа 5 - Графа 6 + Графа 7'");
				РезультатПроверки = РезультатПроверки + ?(РезультатПроверки < 2, 2, 0);
				
				ЗаписатьСообщениеОбОшибкеВСтроке(Форма, ПараметрыВыгрузки,
					ЭлементыПолей[8], Описание, ИмяРазделаИТаблицы[0], СтрНомСтроки, НомСтр);
			КонецЕсли;
		КонецЕсли;
		
	// Проверка строки раздела 5.1.2.
	ИначеЕсли ИмяРазделаИТаблицы[1] = "Rtbl512" Тогда
		
		ЭлементыПолей = Новый Массив(4); // индексы полей начинаются с 4
		ЭлементыПолей.Добавить(ВопросыРазделаИЗначения["DebtStart_Rtbl512"]);
		ЭлементыПолей.Добавить(ВопросыРазделаИЗначения["Accrued_Rtbl512"]);
		ЭлементыПолей.Добавить(ВопросыРазделаИЗначения["Income_Rtbl512"]);
		ЭлементыПолей.Добавить(ВопросыРазделаИЗначения["Other_Rtbl512"]);
		ЭлементыПолей.Добавить(ВопросыРазделаИЗначения["DebtEnd_Rtbl512"]);
		
		Если ЭлементыПолей[8] <> Неопределено
		   И ЭлементыПолей[4] <> Неопределено И ЭлементыПолей[5] <> Неопределено
		   И ЭлементыПолей[6] <> Неопределено И ЭлементыПолей[7] <> Неопределено Тогда
			Если ЭлементыПолей[8].Значение
			  <> ЭлементыПолей[4].Значение - ЭлементыПолей[5].Значение
			   + ЭлементыПолей[6].Значение - ЭлементыПолей[7].Значение Тогда
				Описание = НСтр("ru = 'ОШИБКА: Не выполнено равенство: Графа 8 = Графа 4 - Графа 5 + Графа 6 - Графа 7';
								|en = 'ОШИБКА: Не выполнено равенство: Графа 8 = Графа 4 - Графа 5 + Графа 6 - Графа 7'");
				РезультатПроверки = РезультатПроверки + ?(РезультатПроверки < 2, 2, 0);
				
				ЗаписатьСообщениеОбОшибкеВСтроке(Форма, ПараметрыВыгрузки,
					ЭлементыПолей[8], Описание, ИмяРазделаИТаблицы[0], СтрНомСтроки, НомСтр);
			КонецЕсли;
		КонецЕсли;
		
	// Проверка строки раздела 5.2.1.
	ИначеЕсли ИмяРазделаИТаблицы[1] = "Rtbl521" Тогда
		
		ЭлементыПолей = Новый Массив(4); // индексы полей начинаются с 4
		ЭлементыПолей.Добавить(ВопросыРазделаИЗначения["DebtStart_Rtbl521"]);
		ЭлементыПолей.Добавить(ВопросыРазделаИЗначения["Paid_Rtbl521"]);
		ЭлементыПолей.Добавить(ВопросыРазделаИЗначения["Income_Rtbl521"]);
		ЭлементыПолей.Добавить(ВопросыРазделаИЗначения["Other_Rtbl521"]);
		ЭлементыПолей.Добавить(ВопросыРазделаИЗначения["DebtEnd_Rtbl521"]);
		
		Если ЭлементыПолей[8] <> Неопределено
		   И ЭлементыПолей[4] <> Неопределено И ЭлементыПолей[5] <> Неопределено
		   И ЭлементыПолей[6] <> Неопределено И ЭлементыПолей[7] <> Неопределено Тогда
			Если ЭлементыПолей[8].Значение
			  <> ЭлементыПолей[4].Значение - ЭлементыПолей[5].Значение
			   + ЭлементыПолей[6].Значение - ЭлементыПолей[7].Значение Тогда
				Описание = НСтр("ru = 'ОШИБКА: Не выполнено равенство: Графа 8 = Графа 4 - Графа 5 + Графа 6 - Графа 7';
								|en = 'ОШИБКА: Не выполнено равенство: Графа 8 = Графа 4 - Графа 5 + Графа 6 - Графа 7'");
				РезультатПроверки = РезультатПроверки + ?(РезультатПроверки < 2, 2, 0);
				
				ЗаписатьСообщениеОбОшибкеВСтроке(Форма, ПараметрыВыгрузки,
					ЭлементыПолей[8], Описание, ИмяРазделаИТаблицы[0], СтрНомСтроки, НомСтр);
			КонецЕсли;
		КонецЕсли;
		
	ИначеЕсли ИмяРазделаИТаблицы[1] = "Rtbl522" Тогда
		
		ЭлементыПолей = Новый Массив(4); // индексы полей начинаются с 4
		ЭлементыПолей.Добавить(ВопросыРазделаИЗначения["DebtStart_Rtbl522"]);
		ЭлементыПолей.Добавить(ВопросыРазделаИЗначения["Paid_Rtbl522"]);
		ЭлементыПолей.Добавить(ВопросыРазделаИЗначения["Income_Rtbl522"]);
		ЭлементыПолей.Добавить(ВопросыРазделаИЗначения["Other_Rtbl522"]);
		ЭлементыПолей.Добавить(ВопросыРазделаИЗначения["DebtEnd_Rtbl522"]);
		
		Если ЭлементыПолей[8] <> Неопределено
		   И ЭлементыПолей[4] <> Неопределено И ЭлементыПолей[5] <> Неопределено
		   И ЭлементыПолей[6] <> Неопределено И ЭлементыПолей[7] <> Неопределено Тогда
			Если ЭлементыПолей[8].Значение
			  <> ЭлементыПолей[4].Значение + ЭлементыПолей[5].Значение
			   - ЭлементыПолей[6].Значение + ЭлементыПолей[7].Значение Тогда
				Описание = НСтр("ru = 'ОШИБКА: Не выполнено равенство: Графа 8 = Графа 4 + Графа 5 - Графа 6 + Графа 7';
								|en = 'ОШИБКА: Не выполнено равенство: Графа 8 = Графа 4 + Графа 5 - Графа 6 + Графа 7'");
				РезультатПроверки = РезультатПроверки + ?(РезультатПроверки < 2, 2, 0);
				
				ЗаписатьСообщениеОбОшибкеВСтроке(Форма, ПараметрыВыгрузки,
					ЭлементыПолей[8], Описание, ИмяРазделаИТаблицы[0], СтрНомСтроки, НомСтр);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Возврат РезультатПроверки;
	
КонецФункции

Процедура ВыполнитьПроверкуЗначения(РезультатПроверки, Описание,
									ВопросАнкеты,      ПараметрыВыгрузки,
									ЗначениеОтвета,    НомСтроки = 0) Экспорт
	
	Если СтрДлина(ЗначениеОтвета) = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ИмяПоказателя = ВопросАнкеты["QUESTION_NAME_ID"];
	
	Если ИмяПоказателя = "Storage_place" ИЛИ ИмяПоказателя = "Child_Storage_place" Тогда
		// Для данных вопросов можно использовать значения отсутствующие в справочнике.
		ОписаниеОш = НСтр("ru = 'Указанное значение отсутствует в справочнике';
							|en = 'Указанное значение отсутствует в справочнике'");
		Если Описание = ОписаниеОш Тогда
			Описание = "";
			РезультатПроверки = 0;
		КонецЕсли;
	КонецЕсли;
	
	Если РезультатПроверки > 0 Тогда
		Возврат;
	КонецЕсли;
	
	// Проверка титульного листа.
	Если ИмяПоказателя = "Inn" Тогда
		Если НЕ РегламентированнаяОтчетностьБанкРоссии.ИННСоответствуетТребованиям(ЗначениеОтвета) Тогда
			Описание = НСтр("ru = 'Некорректный код, проверьте правильность ввода!';
							|en = 'Некорректный код, проверьте правильность ввода!'");
			РезультатПроверки = 2;
		КонецЕсли;
	ИначеЕсли ИмяПоказателя = "Okpo" Тогда
		Если НЕ РегламентированнаяОтчетностьБанкРоссии.КодПоОКПОСоответствуетТребованиям(ЗначениеОтвета) Тогда
			Описание = НСтр("ru = 'Некорректный код, проверьте правильность ввода!';
							|en = 'Некорректный код, проверьте правильность ввода!'");
			РезультатПроверки = 2;
		КонецЕсли;
	ИначеЕсли ИмяПоказателя = "Ogrn" Тогда
		Если НЕ РегламентированнаяОтчетностьБанкРоссии.ОГРНСоответствуетТребованиям(ЗначениеОтвета) Тогда
			Описание = НСтр("ru = 'Некорректный код, проверьте правильность ввода!';
							|en = 'Некорректный код, проверьте правильность ввода!'");
			РезультатПроверки = 2;
		КонецЕсли;
	ИначеЕсли ИмяПоказателя = "FIOUser" Тогда
		Если НЕ РегламентированнаяОтчетностьБанкРоссии.НетЦифрВСтроке(ЗначениеОтвета) Тогда
			Описание = НСтр("ru = 'Значение не должно содержать цифры';
							|en = 'Значение не должно содержать цифры'");
			РезультатПроверки = 1;
		КонецЕсли;
	ИначеЕсли ИмяПоказателя = "SignFIO" Тогда
		Если НЕ РегламентированнаяОтчетностьБанкРоссии.НетЦифрВСтроке(ЗначениеОтвета) Тогда
			Описание = НСтр("ru = 'Значение не должно содержать цифры';
							|en = 'Значение не должно содержать цифры'");
			РезультатПроверки = 1;
		КонецЕсли;
	ИначеЕсли ИмяПоказателя = "EmailUser" Тогда
		Если НЕ РегламентированнаяОтчетностьБанкРоссии.АдресЭлектроннойПочтыСоответствуетТребованиям(ЗначениеОтвета) Тогда
			Описание = НСтр("ru = 'Некорректный адрес эл. почты';
							|en = 'Некорректный адрес эл. почты'");
			РезультатПроверки = 1;
		КонецЕсли;
	ИначеЕсли ИмяПоказателя = "EmailRespondent" Тогда
		Если НЕ РегламентированнаяОтчетностьБанкРоссии.АдресЭлектроннойПочтыСоответствуетТребованиям(ЗначениеОтвета) Тогда
			Описание = НСтр("ru = 'Некорректный адрес эл. почты';
							|en = 'Некорректный адрес эл. почты'");
			РезультатПроверки = 1;
		КонецЕсли;
	ИначеЕсли ИмяПоказателя = "Web" Тогда
		Если НЕ РегламентированнаяОтчетностьБанкРоссии.АдресВебСервераСоответствуетТребованиям(ЗначениеОтвета) Тогда
			Описание = НСтр("ru = 'Некорректный адрес веб сайта';
							|en = 'Некорректный адрес веб сайта'");
			РезультатПроверки = 1;
		КонецЕсли;
	ИначеЕсли ИмяПоказателя = "Phone" Тогда
		Если НЕ РегламентированнаяОтчетностьБанкРоссии.НомерТелефонаСоответствуетТребованиям(ЗначениеОтвета) Тогда
			Описание = НСтр("ru = 'Недопустимые символы в номере телефона';
							|en = 'Недопустимые символы в номере телефона'");
			РезультатПроверки = 2;
		КонецЕсли;
	ИначеЕсли ИмяПоказателя = "Fax" Тогда
		Если НЕ РегламентированнаяОтчетностьБанкРоссии.НомерТелефонаСоответствуетТребованиям(ЗначениеОтвета) Тогда
			Описание = НСтр("ru = 'Недопустимые символы в номере Факса';
							|en = 'Недопустимые символы в номере Факса'");
			РезультатПроверки = 1;
		КонецЕсли;
	ИначеЕсли ИмяПоказателя = "Razdel1" Тогда
		ТаблицаРаздела1 = ПараметрыВыгрузки.МетаданныеШаблона.ТаблицыРазделов["Rtbl1"];
		Если ЗначениеОтвета = "00" Тогда
			Если ТаблицаРаздела1.Количество() > 0 Тогда
				Описание = НСтр("ru = 'В разделе 1 присутствуют записи в таблице';
								|en = 'В разделе 1 присутствуют записи в таблице'");
				РезультатПроверки = 2;
			КонецЕсли;
		Иначе
			Если ТаблицаРаздела1.Количество() = 0 Тогда
				Описание = НСтр("ru = 'В разделе 1 отсутствуют записи в таблице';
								|en = 'В разделе 1 отсутствуют записи в таблице'");
				РезультатПроверки = 2;
			КонецЕсли;
		КонецЕсли;
	ИначеЕсли ИмяПоказателя = "Razdel2" Тогда
		ТаблицаРаздела2 = ПараметрыВыгрузки.МетаданныеШаблона.ТаблицыРазделов["Rtbl2"];
		Если ЗначениеОтвета = "00" Тогда
			Если ТаблицаРаздела2.Количество() > 0 Тогда
				Описание = НСтр("ru = 'В разделе 2 присутствуют записи в таблице';
								|en = 'В разделе 2 присутствуют записи в таблице'");
				РезультатПроверки = 2;
			КонецЕсли;
		Иначе
			Если ТаблицаРаздела2.Количество() = 0 Тогда
				Описание = НСтр("ru = 'В разделе 2 отсутствуют записи в таблице';
								|en = 'В разделе 2 отсутствуют записи в таблице'");
				РезультатПроверки = 2;
			КонецЕсли;
		КонецЕсли;
	ИначеЕсли ИмяПоказателя = "Razdel3" Тогда
		ТаблицаРаздела2 = ПараметрыВыгрузки.МетаданныеШаблона.ТаблицыРазделов["Rtbl3"];
		Если ЗначениеОтвета = "00" Тогда
			Если ТаблицаРаздела2.Количество() > 0 Тогда
				Описание = НСтр("ru = 'В разделе 3 присутствуют записи в таблице';
								|en = 'В разделе 3 присутствуют записи в таблице'");
				РезультатПроверки = 2;
			КонецЕсли;
		Иначе
			Если ТаблицаРаздела2.Количество() = 0 Тогда
				Описание = НСтр("ru = 'В разделе 3 отсутствуют записи в таблице';
								|en = 'В разделе 3 отсутствуют записи в таблице'");
				РезультатПроверки = 2;
			КонецЕсли;
		КонецЕсли;
	ИначеЕсли ИмяПоказателя = "Razdel4" Тогда
		ТаблицаРаздела2 = ПараметрыВыгрузки.МетаданныеШаблона.ТаблицыРазделов["Rtbl4"];
		Если ЗначениеОтвета = "00" Тогда
			Если ТаблицаРаздела2.Количество() > 0 Тогда
				Описание = НСтр("ru = 'В разделе 4 присутствуют записи в таблице';
								|en = 'В разделе 4 присутствуют записи в таблице'");
				РезультатПроверки = 2;
			КонецЕсли;
		Иначе
			Если ТаблицаРаздела2.Количество() = 0 Тогда
				Описание = НСтр("ru = 'В разделе 4 отсутствуют записи в таблице';
								|en = 'В разделе 4 отсутствуют записи в таблице'");
				РезультатПроверки = 2;
			КонецЕсли;
		КонецЕсли;
	ИначеЕсли ИмяПоказателя = "Razdel5" Тогда
		ТаблицаРаздела511 = ПараметрыВыгрузки.МетаданныеШаблона.ТаблицыРазделов["Rtbl511"];
		ТаблицаРаздела512 = ПараметрыВыгрузки.МетаданныеШаблона.ТаблицыРазделов["Rtbl512"];
		ТаблицаРаздела521 = ПараметрыВыгрузки.МетаданныеШаблона.ТаблицыРазделов["Rtbl521"];
		ТаблицаРаздела522 = ПараметрыВыгрузки.МетаданныеШаблона.ТаблицыРазделов["Rtbl522"];
		Если ЗначениеОтвета = "00" Тогда
			Если ТаблицаРаздела511.Количество() > 0
			 ИЛИ ТаблицаРаздела512.Количество() > 0
			 ИЛИ ТаблицаРаздела521.Количество() > 0
			 ИЛИ ТаблицаРаздела522.Количество() > 0 Тогда
				Описание = НСтр("ru = 'В разделе 5 присутствуют записи в таблице';
								|en = 'В разделе 5 присутствуют записи в таблице'");
				РезультатПроверки = 2;
			КонецЕсли;
		Иначе
			Если ТаблицаРаздела511.Количество() = 0
			   И ТаблицаРаздела512.Количество() = 0
			   И ТаблицаРаздела521.Количество() = 0
			   И ТаблицаРаздела522.Количество() = 0 Тогда
				Описание = НСтр("ru = 'В разделе 5 отсутствуют записи в таблице';
								|en = 'В разделе 5 отсутствуют записи в таблице'");
				РезультатПроверки = 2;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбновитьДанныеОпросаПоПериоду(ПараметрыВыгрузки)
	
	КодПериода = "0";
	ГодПериода = "0";
	
	КодПериодичности = Число(" " + РегламентированнаяОтчетностьБанкРоссии.ЗначениеДанныхОпросаПоКлючу(
		ПараметрыВыгрузки, "PERIODTYPE"));
	
	Если КодПериодичности > 0 Тогда
		КодПериода = Строка(ПараметрыВыгрузки.ОтчетКвартал);
		ГодПериода = Формат(ПараметрыВыгрузки.ОтчетГод, "ЧГ=");
	КонецЕсли;
	
	РегламентированнаяОтчетностьБанкРоссии.ЗаписатьДанныеОпросаПоКлючу(
		ПараметрыВыгрузки, "PERIODVALUE", КодПериода);
	РегламентированнаяОтчетностьБанкРоссии.ЗаписатьДанныеОпросаПоКлючу(
		ПараметрыВыгрузки, "PERIODYEAR", ГодПериода);
	
КонецПроцедуры

Процедура ЗаписатьСообщениеОбОшибкеВСтроке(Форма, ПараметрыВыгрузки,
		ЗначенияВопроса, Описание, ИмяРаздела, СтрНомСтр, НомСтрНовТаб)
	
	РегламентированнаяОтчетностьБанкРоссии.ЗаписатьСообщениеОбОшибке(
		ЗначенияВопроса.Вопрос, ПараметрыВыгрузки, Описание, НомСтрНовТаб);
	
	МестоОшибки = "Раздел " + Прав(ИмяРаздела, 1)
		+ " [строка " + СтрНомСтр + "]: """ + ЗначенияВопроса.Вопрос["QUESTION_TEXT"] + """";
	ТекстОшибки = Описание + Символы.ПС + Символы.Таб + "<" + МестоОшибки + ">";
	РегламентированнаяОтчетность.СообщитьВТаблицуСообщений(Форма, ТекстОшибки, ИмяРаздела,
		ЗначенияВопроса.ИмяКолонки + "_" + СтрНомСтр);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

ИнициализацияПеременныхМодуля();

#КонецЕсли