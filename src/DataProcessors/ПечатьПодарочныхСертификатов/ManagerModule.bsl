#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

#Область Печать

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	СтруктураТипов = ОбщегоНазначенияУТ.СоответствиеМассивовПоТипамОбъектов(МассивОбъектов);;
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПодарочныйСертификат") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм,
			"ПодарочныйСертификат",
			НСтр("ru = 'Подарочный сертификат';
				|en = 'Gift card'"),
			СформироватьПечатнуюФормуПодарочногоСертификата(СтруктураТипов, ОбъектыПечати, ПараметрыПечати));
	КонецЕсли;
	
КонецПроцедуры

Функция СформироватьПечатнуюФормуПодарочногоСертификата(СтруктураТипов, ОбъектыПечати, ПараметрыПечати)
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ПодарочныйСертификат";
	
	НомерТипаДокумента = 0;
	
	Для Каждого СтруктураОбъектов Из СтруктураТипов Цикл
		
		Если НЕ (СтруктураОбъектов.Ключ = "Документ.РеализацияПодарочныхСертификатов"
			Или СтруктураОбъектов.Ключ = "Справочник.ПодарочныеСертификаты") Тогда
			Продолжить;
		КонецЕсли;
		
		НомерТипаДокумента = НомерТипаДокумента + 1;
		Если НомерТипаДокумента > 1 Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(СтруктураОбъектов.Ключ);
		ДанныеДляПечати = МенеджерОбъекта.ПолучитьДанныеДляПечатнойФормыПодарочныйСертификат(ПараметрыПечати, СтруктураОбъектов.Значение);
		
		ЗаполнитьТабличныйДокументПодарочныйСертификат(ТабличныйДокумент, ДанныеДляПечати, ОбъектыПечати);
		
	КонецЦикла;
	
	Возврат ТабличныйДокумент;
	
КонецФункции

Процедура ЗаполнитьТабличныйДокументПодарочныйСертификат(ТабличныйДокумент, ДанныеДляПечати, ОбъектыПечати)
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Обработка.ПечатьПодарочныхСертификатов.ПФ_MXL_ПодарочныйСертификат");
	
	Эталон = Обработки.ПечатьЭтикетокИЦенников.ПолучитьМакет("Эталон");
	РисунокКвадрат = Эталон.Рисунки.Квадрат100Пикселей; // РисунокТабличногоДокумента
	КоличествоМиллиметровВПикселе = РисунокКвадрат.Высота / 100;
	
	ПервыйДокумент = Истина;
	
	РезультатЗапроса = ДанныеДляПечати.РезультатЗапроса; // РезультатЗапроса
	Выборка = РезультатЗапроса.Выбрать(); 
	Пока Выборка.Следующий() Цикл
		
		Если Не ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		ПервыйДокумент = Ложь;
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		// Выводим шапку накладной.
		ОбластьМакета = Макет.ПолучитьОбласть("ПодарочныйСертификат");
		ЗаполнитьЗначенияСвойств(ОбластьМакета.Параметры, Выборка);
		
		Если ОбщегоНазначенияУТКлиентСервер.ЕстьРеквизитОбъекта(ОбластьМакета.Рисунки, "КартинкаШтрихкода") Тогда
			
			Если ЗначениеЗаполнено(Выборка.Штрихкод) И СтрДлина(Выборка.Штрихкод) = 13 Тогда
				
				ПараметрыШтрихкода = Новый Структура;
				ПараметрыШтрихкода.Вставить("Ширина",           Окр(ОбластьМакета.Рисунки.КартинкаШтрихкода.Ширина / КоличествоМиллиметровВПикселе));
				ПараметрыШтрихкода.Вставить("Высота",           Окр(ОбластьМакета.Рисунки.КартинкаШтрихкода.Высота / КоличествоМиллиметровВПикселе));
				ПараметрыШтрихкода.Вставить("Штрихкод",         Выборка.Штрихкод);
				ПараметрыШтрихкода.Вставить("ТипВходныхДанных", 0); // Штрихкод - это строка
				ПараметрыШтрихкода.Вставить("ТипКода",          1); // EAN13
				ПараметрыШтрихкода.Вставить("ОтображатьТекст",  Истина);
				ПараметрыШтрихкода.Вставить("РазмерШрифта",     8);
				
				ОбластьМакета.Рисунки.КартинкаШтрихкода.Картинка = ГенерацияШтрихкода.ИзображениеШтрихкода(ПараметрыШтрихкода).Картинка;
				
			Иначе
				ОбластьМакета.Рисунки.Удалить(ОбластьМакета.Рисунки.КартинкаШтрихкода);
			КонецЕсли;
			
		КонецЕсли;
		
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, Выборка.Ссылка);
		
	КонецЦикла;
	
КонецПроцедуры // ЗаполнитьТабличныйДокументТоварныйЧек()

#КонецОбласти

#КонецОбласти

#КонецЕсли
