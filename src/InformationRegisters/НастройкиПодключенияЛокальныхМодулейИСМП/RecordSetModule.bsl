
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого Запись Из ЭтотОбъект Цикл
		
		НастроенныеТГ = Запись.НастроенныеТоварныеГруппы.Получить();
		
		Если Не НастроенныеТГ = Неопределено
			И ТипЗнч(НастроенныеТГ) = Тип("Массив")
			И Не НастроенныеТГ.Количество()
			И Не ЗначениеЗаполнено(Запись.КоличествоДнейВыгрузкиКарточек) Тогда
			
			ТекстСообщения = НСтр("ru = 'Укажите период выгрузки кодов идентификации.';
									|en = 'Укажите период выгрузки кодов идентификации.'");
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, , , "Запись.КоличествоДнейВыгрузкиКарточек", Отказ);
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ШаблонАдресаСПортом  = "%1%2:%3";
	ШаблонАдресаБезПорта = "%1%2";
	
	ДанныеДляПроверки = ИнициализироватьТаблицуДанныхДляПроверки();
	
	Для Каждого Запись Из ЭтотОбъект Цикл
		
		Если ЗначениеЗаполнено(Запись.ПортПодключенияЛМ) Тогда
			
			Запись.АдресПодключенияЛМ = СтрШаблон(ШаблонАдресаСПортом, Формат(Запись.ЗащищенноеСоединение, "БЛ=http://; БИ=https://;"),
				Запись.СерверПодключенияЛМ,
				Формат(Запись.ПортПодключенияЛМ, "ЧГ=0;"));
				
		Иначе
			
			Запись.АдресПодключенияЛМ = СтрШаблон(ШаблонАдресаБезПорта,
				Формат(Запись.ЗащищенноеСоединение, "БЛ=http://; БИ=https://;"),
				Запись.СерверПодключенияЛМ);
				
		КонецЕсли;
		
		СтруктураПолученияПароля = РегистрыСведений.НастройкиПодключенияЛокальныхМодулейИСМП.КонструкторЗаписиВладельцаПароля();
		ЗаполнитьЗначенияСвойств(СтруктураПолученияПароля, Запись);
		
		Запись.ХешСумма = ОбщегоНазначения.КонтрольнаяСуммаСтрокой(СтруктураПолученияПароля);
		
		СтрокаПроверки = ДанныеДляПроверки.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаПроверки, Запись);
		
	КонецЦикла;
	
	ПроверитьДублиЛокальныхМодулейПоОрганизациям(ДанныеДляПроверки, Отказ);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ИнициализироватьТаблицуДанныхДляПроверки()
	
	ТаблицаДанных = Новый ТаблицаЗначений();
	
	ТаблицаДанных.Колонки.Добавить("Организация",        Метаданные.ОпределяемыеТипы.Организация.Тип);
	ТаблицаДанных.Колонки.Добавить("РабочееМесто",       Метаданные.ОпределяемыеТипы.РабочиеМестаИС.Тип);
	ТаблицаДанных.Колонки.Добавить("АдресПодключенияЛМ", ОбщегоНазначения.ОписаниеТипаСтрока(0));
	ТаблицаДанных.Колонки.Добавить("ОбменНаСервере",     Новый ОписаниеТипов("Булево"));
	
	Возврат ТаблицаДанных;
	
КонецФункции

Процедура ПроверитьДублиЛокальныхМодулейПоОрганизациям(ДанныеДляПроверки, Отказ)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ТаблицаПроверки.Организация        КАК Организация,
		|	ТаблицаПроверки.РабочееМесто       КАК РабочееМесто,
		|	ТаблицаПроверки.АдресПодключенияЛМ КАК АдресПодключенияЛМ,
		|	ТаблицаПроверки.ОбменНаСервере     КАК ОбменНаСервере
		|ПОМЕСТИТЬ ВТ_ТаблицаПроверки
		|ИЗ
		|	&ТаблицаПроверки КАК ТаблицаПроверки
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТ_ТаблицаПроверки.Организация                       КАК Организация,
		|	ВТ_ТаблицаПроверки.РабочееМесто                      КАК РабочееМесто,
		|	ВТ_ТаблицаПроверки.АдресПодключенияЛМ                КАК АдресПодключенияЛМ,
		|	ВТ_ТаблицаПроверки.ОбменНаСервере                    КАК ОбменНаСервере,
		|	НастройкиПодключенияЛокальныхМодулейИСМП.Организация КАК ОрганизацияНастроенногоПодключения
		|ИЗ
		|	РегистрСведений.НастройкиПодключенияЛокальныхМодулейИСМП КАК НастройкиПодключенияЛокальныхМодулейИСМП
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_ТаблицаПроверки КАК ВТ_ТаблицаПроверки
		|		ПО ВТ_ТаблицаПроверки.РабочееМесто = НастройкиПодключенияЛокальныхМодулейИСМП.РабочееМесто
		|		И ВЫРАЗИТЬ(ВТ_ТаблицаПроверки.АдресПодключенияЛМ КАК
		|			СТРОКА(500)) = ВЫРАЗИТЬ(НастройкиПодключенияЛокальныхМодулейИСМП.АдресПодключенияЛМ КАК СТРОКА(500))
		|		И ВТ_ТаблицаПроверки.ОбменНаСервере = НастройкиПодключенияЛокальныхМодулейИСМП.ОбменНаСервере
		|ГДЕ
		|	НастройкиПодключенияЛокальныхМодулейИСМП.Организация <> ВТ_ТаблицаПроверки.Организация";
	
	Запрос.УстановитьПараметр("ТаблицаПроверки", ДанныеДляПроверки);
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	ШаблонСообщения = НСтр("ru = 'Локальный модуль %1 уже настроен для работы организации %2.';
							|en = 'Локальный модуль %1 уже настроен для работы организации %2.'");
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		
		Если ЗначениеЗаполнено(ВыборкаДетальныеЗаписи.РабочееМесто) Тогда
			
			ШаблонПредставленияЛокальногоМодуля = НСтр("ru = '%1 (%2)';
														|en = '%1 (%2)'");
			ПредставлениеЛокальногоМодуля       = СтрШаблон(ШаблонПредставленияЛокальногоМодуля, ВыборкаДетальныеЗаписи.АдресПодключенияЛМ, ВыборкаДетальныеЗаписи.РабочееМесто);
			
		Иначе
			
			ШаблонПредставленияЛокальногоМодуля = НСтр("ru = '%1';
														|en = '%1'");
			ПредставлениеЛокальногоМодуля       = СтрШаблон(ШаблонПредставленияЛокальногоМодуля, ВыборкаДетальныеЗаписи.АдресПодключенияЛМ);
			
		КонецЕсли;
		
		ТекстСообщения = СтрШаблон(ШаблонСообщения, ПредставлениеЛокальногоМодуля, ВыборкаДетальныеЗаписи.ОрганизацияНастроенногоПодключения);
		
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,,,, Отказ);
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
