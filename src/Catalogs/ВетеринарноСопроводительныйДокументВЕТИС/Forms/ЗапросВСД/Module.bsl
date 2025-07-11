
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ЗаполнитьИменаСтраниц();
	
	ХозяйствующийСубъект = Параметры.ХозяйствующийСубъект;
	Предприятие          = Параметры.Предприятие;
	
	Если ЗначениеЗаполнено(Параметры.Идентификатор) Тогда
		
		СтрокаТЧ = ИсходящиеЗапросы.Добавить();
		СтрокаТЧ.НомерСтроки   = ИсходящиеЗапросы.Количество();
		СтрокаТЧ.Идентификатор = Параметры.Идентификатор;
		
	КонецЕсли;
	
	ПоддерживаемыеТипыПодключаемогоОборудования = "СканерШтрихкода";
	ОбщегоНазначенияИС.НастроитьПодключаемоеОборудование(ЭтотОбъект, ПоддерживаемыеТипыПодключаемогоОборудования);
	
	СтраницыФормы = Элементы.ГруппаСтраницы;
	СтраницыФормы.ТекущаяСтраница = СтраницыФормы.ПодчиненныеЭлементы[ИменаСтраниц[0]];
	
	УстановитьТекущуюСтраницуНавигации(ЭтотОбъект);
	
	ЦветГиперссылки = ЦветаСтиля.ЦветГиперссылкиГосИС;
	ЦветПроблема    = ЦветаСтиля.ЦветТекстаПроблемаГосИС;
	
	Если Параметры.ВидЗапроса <> Неопределено Тогда
		ВидЗапроса = Параметры.ВидЗапроса;
	Иначе
		ВидЗапроса = 1;
	КонецЕсли;
	
	Элементы.СтраницыВидЗапроса.ТекущаяСтраница = 
		?(ВидЗапроса = 1, Элементы.СтраницаЗапросПоИдентификатору, Элементы.СтраницаЗапросСДаты);
	
	НастроитьЗависимыеЭлементыФормы(ЭтотОбъект);
	
	ОбщегоНазначенияСобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОповещениеПриПодключении = Новый ОписаниеОповещения("ПодключитьОборудованиеЗавершение", ЭтотОбъект);
	МенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПриОткрытииФормы(
		ОповещениеПриПодключении,
		ЭтотОбъект,
		ПоддерживаемыеТипыПодключаемогоОборудования);
		
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	ОповещениеПриОтключении = Новый ОписаниеОповещения("ОтключитьОборудованиеЗавершение", ЭтотОбъект);
	МенеджерОборудованияКлиент.НачатьОтключениеОборудованиеПриЗакрытииФормы(ОповещениеПриОтключении, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ВнешнееСобытие(Источник, Событие, Данные)
	
	Если Не ЭтотОбъект.ВводДоступен() Тогда
		Возврат;
	КонецЕсли;
	
	ОписаниеСобытия = Новый Структура;
	ОписаниеСобытия.Вставить("Источник", Источник);
	ОписаниеСобытия.Вставить("Событие" , Событие);
	ОписаниеСобытия.Вставить("Данные"  , Данные);
	
	Результат = МенеджерОборудованияКлиент.ПолучитьСобытиеОтУстройства(ОписаниеСобытия);
	
	Если Результат <> Неопределено
		И Результат.Источник = "ПодключаемоеОборудование"
		И Результат.ИмяСобытия = "ScanData"
		И Найти(ЭтотОбъект.ПоддерживаемыеТипыПодключаемогоОборудования, "СканерШтрихкода") > 0 Тогда
		
		Если Результат.Параметр[1] = Неопределено Тогда
			Штрихкод = Результат.Параметр[0];    // Достаем штрихкод из основных данных
		Иначе
			Штрихкод = Результат.Параметр[1][1]; // Достаем штрихкод из дополнительных данных
		КонецЕсли;
		
		Если СтроковыеФункцииКлиентСервер.ЭтоУникальныйИдентификатор(Штрихкод) Тогда
			
			СтрокаТЧ = ИсходящиеЗапросы.Добавить();
			СтрокаТЧ.НомерСтроки   = ИсходящиеЗапросы.Количество();
			СтрокаТЧ.Идентификатор = Штрихкод;
			
		Иначе
			
			Идентификатор = ИдентификаторИзШтрихкода(Штрихкод);
			
			Если Идентификатор <> Неопределено Тогда
				
				СтрокаТЧ = ИсходящиеЗапросы.Добавить();
				СтрокаТЧ.НомерСтроки   = ИсходящиеЗапросы.Количество();
				СтрокаТЧ.Идентификатор = Идентификатор;
				
			Иначе
				
				ОбщегоНазначенияКлиент.СообщитьПользователю(
					СтрШаблон(
						НСтр("ru = 'Из штрихкода %1 не удалось получить идентификатор ВСД';
							|en = 'Из штрихкода %1 не удалось получить идентификатор ВСД'"), Штрихкод));
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаДалее(Команда)
	
	ОчиститьСообщения();
	
	Если Не ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	СтраницыФормы  = Элементы.ГруппаСтраницы;
	ИндексСтраницы = ИменаСтраниц.Найти(СтраницыФормы.ТекущаяСтраница.Имя);
	
	Если ИменаСтраниц[ИндексСтраницы + 1] = "СтраницаЗапросОшибка" И ПустаяСтрока(ТекстОшибка) Тогда
		СтраницыФормы.ТекущаяСтраница = СтраницыФормы.ПодчиненныеЭлементы[ИменаСтраниц[ИндексСтраницы + 2]];
	Иначе
		СтраницыФормы.ТекущаяСтраница = СтраницыФормы.ПодчиненныеЭлементы[ИменаСтраниц[ИндексСтраницы + 1]];
	КонецЕсли;
	
	ГруппаСтраницыПриСменеСтраницы(СтраницыФормы, СтраницыФормы.ТекущаяСтраница);
	
КонецПроцедуры


&НаКлиенте
Процедура КомандаНазад(Команда)
	
	СтраницыФормы  = Элементы.ГруппаСтраницы;
	ИндексСтраницы = ИменаСтраниц.Найти(СтраницыФормы.ТекущаяСтраница.Имя);
	
	Если ИменаСтраниц[ИндексСтраницы - 1] = "СтраницаЗапросОшибка" И ПустаяСтрока(ТекстОшибка) Тогда
		СтраницыФормы.ТекущаяСтраница = СтраницыФормы.ПодчиненныеЭлементы[ИменаСтраниц[ИндексСтраницы - 2]];
	Иначе
		СтраницыФормы.ТекущаяСтраница = СтраницыФормы.ПодчиненныеЭлементы[ИменаСтраниц[ИндексСтраницы - 1]];
	КонецЕсли;
	
	ГруппаСтраницыПриСменеСтраницы(СтраницыФормы, СтраницыФормы.ТекущаяСтраница);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаВНачало(Команда)
	
	СтраницыФормы = Элементы.ГруппаСтраницы;
	СтраницыФормы.ТекущаяСтраница = СтраницыФормы.ПодчиненныеЭлементы[ИменаСтраниц[0]];
	
	ГруппаСтраницыПриСменеСтраницы(СтраницыФормы, СтраницыФормы.ТекущаяСтраница);
	
КонецПроцедуры

&НаКлиенте
Процедура ТекстОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если СтрНачинаетсяС(НавигационнаяСсылкаФорматированнойСтроки, "ОткрытьИсходящееСообщение") Тогда
		
		ПоказатьЗначение(, ИсходящееСообщение);
		
	ИначеЕсли СтрНачинаетсяС(НавигационнаяСсылкаФорматированнойСтроки, "ОткрытьВходящееСообщение") Тогда
		
		ПоказатьЗначение(, ВходящееСообщение);
		
	ИначеЕсли СтрНачинаетсяС(НавигационнаяСсылкаФорматированнойСтроки, "ОткрытьРезультат") Тогда
	
		ЗагруженныеВСД = Новый Массив;
		Для Каждого СтрокаТЧ Из ВходящиеСообщения Цикл
			Если ЗначениеЗаполнено(СтрокаТЧ.ВСД) Тогда
				ЗагруженныеВСД.Добавить(СтрокаТЧ.ВСД);
			КонецЕсли;
		КонецЦикла;
		
		ПараметрыОтбора = Новый Структура;
		ПараметрыОтбора.Вставить("Ссылка", ЗагруженныеВСД);
		
		ОткрытьФорму(
			"Справочник.ВетеринарноСопроводительныйДокументВЕТИС.ФормаСписка",
			Новый Структура("Отбор", ПараметрыОтбора),
			ЭтотОбъект,,,,,
			РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
	ИначеЕсли СтрНачинаетсяС(НавигационнаяСсылкаФорматированнойСтроки, "ОткрытьИсходящиеСообщения") Тогда
		
		МассивСообщений = Новый Массив;
		Для Каждого СтрокаТЧ Из ИсходящиеСообщения Цикл
			Если ЗначениеЗаполнено(СтрокаТЧ.ИсходящееСообщение) Тогда
				МассивСообщений.Добавить(СтрокаТЧ.ИсходящееСообщение);
			КонецЕсли;
		КонецЦикла;
		
		ПараметрыОтбора = Новый Структура;
		ПараметрыОтбора.Вставить("Ссылка", МассивСообщений);
		
		ОткрытьФорму(
			"Справочник.ВЕТИСПрисоединенныеФайлы.ФормаСписка",
			Новый Структура("Отбор", ПараметрыОтбора),
			ЭтотОбъект,,,,,
			РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
	ИначеЕсли СтрНачинаетсяС(НавигационнаяСсылкаФорматированнойСтроки, "ОткрытьВходящиеСообщения") Тогда
		
		МассивСообщений = Новый Массив;
		Для Каждого СтрокаТЧ Из ВходящиеСообщения Цикл
			Если ЗначениеЗаполнено(СтрокаТЧ.ВходящееСообщение) Тогда
				МассивСообщений.Добавить(СтрокаТЧ.ВходящееСообщение);
			КонецЕсли;
		КонецЦикла;
		
		ПараметрыОтбора = Новый Структура;
		ПараметрыОтбора.Вставить("Ссылка", МассивСообщений);
		
		ОткрытьФорму(
			"Справочник.ВЕТИСПрисоединенныеФайлы.ФормаСписка",
			Новый Структура("Отбор", ПараметрыОтбора),
			ЭтотОбъект,,,,,
			РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
	Иначе
		
		ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку(НавигационнаяСсылкаФорматированнойСтроки);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьИзВнешнегоФайла(Команда)
	
	ОткрытьФорму(
		"Справочник.ВетеринарноСопроводительныйДокументВЕТИС.Форма.ЗагрузкаИдентификаторовВСДИзВнешнихФайлов",,
		ЭтотОбъект,,,,
		Новый ОписаниеОповещения("ОбработатьРезультатЗагрузкиВСДИзВнешнегоФайла", ЭтотОбъект));
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ГруппаСтраницыПриСменеСтраницы(Элемент, ТекущаяСтраница)
	
	УстановитьТекущуюСтраницуНавигации(ЭтотОбъект);
	
	Если ТекущаяСтраница = Элемент.ПодчиненныеЭлементы.СтраницаЗапросОжидание Тогда
		ВыполнениеЗаявкиВЕТИСНачало();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИдентификаторыВСДПриИзменении(Элемент)
	
	ИнтеграцияВЕТИСКлиент.ПронумероватьТаблицу(ЭтотОбъект, "ИсходящиеЗапросы");
	
КонецПроцедуры

&НаКлиенте
Процедура ИдентификаторыВСДИдентификаторОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	Идентификатор = НРег(СтрЗаменить(Текст, "-", ""));
	Если СтрДлина(Идентификатор) = 32 Тогда
		
		// Приведение к шаблону "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"
		Идентификатор = Лев(Идентификатор, 8)
			+ "-" + Сред(Идентификатор, 9, 4)+ "-" + Сред(Идентификатор, 13, 4)+ "-" + Сред(Идентификатор, 17, 4)
			+ "-" + Прав(Идентификатор, 12);
		
		Если Текст <> Идентификатор Тогда
			
			СтандартнаяОбработка = Ложь;
			
			Текст = Идентификатор;
			
			СписокВыбора = Новый СписокЗначений;
			СписокВыбора.Добавить(Идентификатор);
			
			ДанныеВыбора = СписокВыбора;
			
		КонецЕсли;
		
	Иначе
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВидЗапросаПриИзменении(Элемент)
	
	Элементы.СтраницыВидЗапроса.ТекущаяСтраница = 
		?(ВидЗапроса = 1, Элементы.СтраницаЗапросПоИдентификатору, Элементы.СтраницаЗапросСДаты);
		
	НастроитьЗависимыеЭлементыФормы(ЭтотОбъект, "ВидЗапроса");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ВыполнениеЗаявокВЕТИС_API

&НаСервере
Функция ВыполнениеЗаявкиВЕТИСНачалоНаСервере()
	
	ИсходящиеСообщения.Очистить();
	ВходящиеСообщения.Очистить();
	
	Если ВидЗапроса = 1 Тогда
		
		Идентификаторы = Новый Массив;
		Для Каждого СтрокаТЧ Из ИсходящиеЗапросы Цикл
			Идентификаторы.Добавить(СтрокаТЧ.Идентификатор);
		КонецЦикла;
		
		РезультатОбмена = ЗаявкиВЕТИСВызовСервера.ПодготовитьЗапросВетеринарноСопроводительногоДокументаПоUUID(
			ХозяйствующийСубъект, Предприятие, Идентификаторы, УникальныйИдентификатор);
		
	ИначеЕсли ВидЗапроса = 2 Тогда
		
		ПараметрыОтбора = Новый Структура;
		
		Если ЗначениеЗаполнено(СтатусВСД) Тогда
			ПараметрыОтбора.Вставить("СтатусВСД", СтатусВСД);
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ТипВСД) Тогда
			ПараметрыОтбора.Вставить("ТипВСД", ТипВСД);
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ПредприятиеГрузоотправитель) Тогда
			ПараметрыОтбора.Вставить("ГрузоотправительПредприятие", ПредприятиеГрузоотправитель);
		КонецЕсли;
		
		КонецПериода = Неопределено;
		Если ЗначениеЗаполнено(НачалоПериода) И ЗначениеЗаполнено(КонецПериода) Тогда
			ПараметрыОтбора.Вставить("Интервал", ИнтеграцияВЕТИСКлиентСервер.СтруктураИнтервала(НачалоПериода, КонецПериода));
		ИначеЕсли ЗначениеЗаполнено(НачалоПериода) И Не ЗначениеЗаполнено(КонецПериода) Тогда
			ПараметрыОтбора.Вставить("Интервал", ИнтеграцияВЕТИСКлиентСервер.СтруктураИнтервала(НачалоПериода));
		КонецЕсли;
		
		РезультатОбмена = ЗаявкиВЕТИСВызовСервера.ПодготовитьЗапросВетеринарноСопроводительныхДокументов(
			ХозяйствующийСубъект,
			Предприятие,
			ПараметрыОтбора,
			УникальныйИдентификатор);
		
	КонецЕсли;
	
	Возврат РезультатОбмена;
	
КонецФункции

&НаКлиенте
Процедура ВыполнениеЗаявкиВЕТИСНачало()
	
	РезультатОбмена = ВыполнениеЗаявкиВЕТИСНачалоНаСервере();
	
	ОбработатьРезультатОбменаСВЕТИС(РезультатОбмена);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнениеЗаявкиВЕТИСОкончание()
	
	ПоказатьУспешныйРезультатОбмена();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьРезультатОбменаСВЕТИС(РезультатОбмена)
	
	Если РезультатОбмена.Ожидать <> Неопределено Тогда
		
		Для Каждого СтрокаТЧ Из РезультатОбмена.Изменения Цикл
			
			ИсходящееСообщение = СтрокаТЧ.ИсходящееСообщение;
			
			НоваяСтрока = ИсходящиеСообщения.Добавить();
			НоваяСтрока.ИсходящееСообщение = СтрокаТЧ.ИсходящееСообщение;
			
		КонецЦикла;
		
		СформироватьТекстОжидание();
		
	КонецЕсли;
	
	ИнтеграцияВЕТИСКлиент.ОбработатьРезультатОбмена(РезультатОбмена, ЭтотОбъект,, ОповещениеПриЗавершенииОбмена(), Ложь);
	
КонецПроцедуры

//@skip-warning
&НаКлиенте
Процедура Подключаемый_ВыполнитьОбменОбработкаОжидания()
	
	ИнтеграцияВЕТИСКлиент.ПродолжитьВыполнениеОбмена(ЭтотОбъект,, ОповещениеПриЗавершенииОбмена(), Ложь);
	
КонецПроцедуры

&НаКлиенте
Функция ОповещениеПриЗавершенииОбмена()
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПослеПолученияРезультатОбработкиЗаявки", ЭтотОбъект);
	
	Возврат ОписаниеОповещения;
	
КонецФункции

&НаКлиенте
Процедура ПослеПолученияРезультатОбработкиЗаявки(Изменения, ДополнительныеПараметры) Экспорт
	
	КоличествоОшибок     = 0;
	КоличествоОбъектов   = 0;
	НетОбновленныхДанных = Истина;
	ТекстОшибки          = "";
	Для Каждого ЭлементДанных Из Изменения Цикл
		Если ЭлементДанных.Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийВЕТИС.ОтветНаЗапросВСД")
			Или ЭлементДанных.Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийВЕТИС.ОтветНаЗапросВсехВСД") Тогда
			
			ВходящееСообщение = ЭлементДанных.ВходящееСообщение;
			ВСД               = ЭлементДанных.Объект;
			ТекстОшибки       = ЭлементДанных.ТекстОшибки;
			
			НоваяСтрока = ВходящиеСообщения.Добавить();
			НоваяСтрока.ВходящееСообщение = ЭлементДанных.ВходящееСообщение;
			НоваяСтрока.ВСД               = ЭлементДанных.Объект;
			НоваяСтрока.ТекстОшибки       = ЭлементДанных.ТекстОшибки;
			
			Если ЗначениеЗаполнено(ЭлементДанных.Объект) Тогда
				КоличествоОбъектов = КоличествоОбъектов + 1;
			КонецЕсли;
			Если ЗначениеЗаполнено(ЭлементДанных.ТекстОшибки) Тогда
				КоличествоОшибок = КоличествоОшибок + 1;
			КонецЕсли;
			
		КонецЕсли;
		
		Если ЭлементДанных.Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийВЕТИС.ОтветНаЗапросВсехВСД")
			И Не ЗначениеЗаполнено(ВСД) Тогда
			НетОбновленныхДанных = Истина;
		КонецЕсли;
		
	КонецЦикла;
	
	Если КоличествоОшибок = 0 И КоличествоОбъектов = 0 Тогда
		Если Не НетОбновленныхДанных Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	Если КоличествоОшибок > 0
		И (КоличествоОбъектов = 0 И Не НетОбновленныхДанных) Тогда
		ПоказатьОшибкуОбмена(ТекстОшибки);
	ИначеЕсли КоличествоОбъектов > 0 Или НетОбновленныхДанных Тогда
		ВыполнениеЗаявкиВЕТИСОкончание();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область УправлениеИнтерфейсом

&НаКлиентеНаСервереБезКонтекста
Процедура НастроитьЗависимыеЭлементыФормы(Форма, СписокРеквизитов = "")
	
	Элементы = Форма.Элементы;
	
	Инициализация = ПустаяСтрока(СписокРеквизитов);
	СтруктураРеквизитов = Новый Структура(СписокРеквизитов);
	
	Если Инициализация Или СтруктураРеквизитов.Свойство("ВидЗапроса") Тогда
		Элементы.ИдентификаторыВСДИдентификатор.АвтоОтметкаНезаполненного = Форма.ВидЗапроса = 1;
		Элементы.НачалоПериода.АвтоОтметкаНезаполненного             = Форма.ВидЗапроса = 2;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьТекстОжидание()
	
	Строки = Новый Массив();
	Если ВидЗапроса = 1 Тогда
		Если ИсходящиеСообщения.Количество() = 1 Тогда
			Строки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'Запрос';
															|en = 'Запрос'"),, ЦветГиперссылки,, "ОткрытьИсходящееСообщение"));
			Строки.Добавить(" ");
			Строки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'ВСД по идентификатору';
															|en = 'ВСД по идентификатору'")));
			Строки.Добавить(" ");
			Строки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'передан в ВетИС.';
															|en = 'передан в ВетИС.'")));
		Иначе
			Строки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'Запросы';
															|en = 'Запросы'"),, ЦветГиперссылки,, "ОткрытьИсходящиеСообщения"));
			Строки.Добавить(" ");
			Строки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'ВСД по идентификаторам';
															|en = 'ВСД по идентификаторам'")));
			Строки.Добавить(" ");
			Строки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'переданы в ВетИС.';
															|en = 'переданы в ВетИС.'")));
		КонецЕсли;
	Иначе
		Строки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'Запрос';
														|en = 'Запрос'"),, ЦветГиперссылки,, "ОткрытьИсходящееСообщение"));
		Строки.Добавить(" ");
		
		Строки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'ВСД с';
														|en = 'ВСД с'")));
		Строки.Добавить(" ");
		Строки.Добавить(Новый ФорматированнаяСтрока(Формат(НачалоПериода, "ДЛФ=D;")));
		
		Если ЗначениеЗаполнено(КонецПериода) Тогда
			Строки.Добавить(" ");
			Строки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'по';
															|en = 'по'")));
			Строки.Добавить(" ");
			Строки.Добавить(Новый ФорматированнаяСтрока(Формат(КонецПериода, "ДЛФ=D;")));
		КонецЕсли;
		
		Строки.Добавить(" ");
		Строки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'передан в ВетИС.';
														|en = 'передан в ВетИС.'")));
	КонецЕсли;
	
	Строки.Добавить(Символы.ПС);
	Строки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'Получение ответа от сервера может занять продолжительное время.';
													|en = 'Получение ответа от сервера может занять продолжительное время.'")));
	
	ТекстОжидание = Новый ФорматированнаяСтрока(Строки);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьОшибкуОбмена(ТекстОшибки)
	
	Строки = Новый Массив();
	Если ВидЗапроса = 1 Тогда
		Если ИсходящиеСообщения.Количество() = 1 Тогда
			Строки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'Запрос';
															|en = 'Запрос'"),, ЦветГиперссылки,, "ОткрытьИсходящееСообщение"));
			Строки.Добавить(" ");
			Строки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'ВСД по идентификатору';
															|en = 'ВСД по идентификатору'")));
			Строки.Добавить(" ");
			Строки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'завершился с';
															|en = 'завершился с'")));
			Строки.Добавить(" ");
			Строки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'ошибкой';
															|en = 'ошибкой'"),, ЦветГиперссылки,, "ОткрытьВходящееСообщение"));
			Строки.Добавить(":");
			Строки.Добавить(Символы.ПС);
		Иначе
			Строки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'Запросы';
															|en = 'Запросы'"),, ЦветГиперссылки,, "ОткрытьИсходящиеСообщения"));
			Строки.Добавить(" ");
			Строки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'ВСД по идентификаторам';
															|en = 'ВСД по идентификаторам'")));
			Строки.Добавить(" ");
			Строки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'завершились с';
															|en = 'завершились с'")));
			Строки.Добавить(" ");
			Строки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'ошибками';
															|en = 'ошибками'"),, ЦветГиперссылки,, "ОткрытьВходящиеСообщения"));
			Строки.Добавить(":");
			Строки.Добавить(Символы.ПС);
		КонецЕсли;
	Иначе
		Строки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'Запрос';
														|en = 'Запрос'"),, ЦветГиперссылки,, "ОткрытьИсходящееСообщение"));
		Строки.Добавить(" ");
		Строки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'ВСД с';
														|en = 'ВСД с'")));
		Строки.Добавить(" ");
		Строки.Добавить(Новый ФорматированнаяСтрока(Формат(НачалоПериода, "ДЛФ=D;")));
		
		Если ЗначениеЗаполнено(КонецПериода) Тогда
			Строки.Добавить(" ");
			Строки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'по';
															|en = 'по'")));
			Строки.Добавить(" ");
			Строки.Добавить(Новый ФорматированнаяСтрока(Формат(КонецПериода, "ДЛФ=D;")));
		КонецЕсли;
		
		Строки.Добавить(" ");
		Строки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'завершился с';
														|en = 'завершился с'")));
		Строки.Добавить(" ");
		Строки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'ошибками';
														|en = 'ошибками'"),, ЦветГиперссылки,, "ОткрытьВходящиеСообщения"));
		Строки.Добавить(":");
		Строки.Добавить(Символы.ПС);
	КонецЕсли;
	
	Строки.Добавить(Новый ФорматированнаяСтрока(ТекстОшибки,, ЦветПроблема));
	
	ТекстОшибка = Новый ФорматированнаяСтрока(Строки);
	
	СтраницыФормы = Элементы.ГруппаСтраницы;
	СтраницыФормы.ТекущаяСтраница = СтраницыФормы.ПодчиненныеЭлементы.СтраницаЗапросОшибка;
	
	ГруппаСтраницыПриСменеСтраницы(СтраницыФормы, СтраницыФормы.ТекущаяСтраница);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьУспешныйРезультатОбмена()
	
	Строки = Новый Массив();
	
	Строки.Добавить(НСтр("ru = 'На';
						|en = 'На'"));
	Строки.Добавить(" ");
	
	Если ИсходящиеЗапросы.Количество() = 1 Тогда
		Если ИсходящиеЗапросы.Количество() = 1 Тогда
			
			Строки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'запрос';
															|en = 'запрос'"),, ЦветГиперссылки,, "ОткрытьИсходящееСообщение"));
			Строки.Добавить(" ");
			Строки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'ВСД по идентификатору';
															|en = 'ВСД по идентификатору'")));
			Строки.Добавить(" ");
			Строки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'получен';
															|en = 'получен'")));
			Строки.Добавить(" ");
			Строки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'ответ';
															|en = 'ответ'"),, ЦветГиперссылки,, "ОткрытьВходящееСообщение"));
			Строки.Добавить(".");
			Строки.Добавить(Символы.ПС);
			Строки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'Загружен документ';
															|en = 'Загружен документ'")));
			Строки.Добавить(" ");
			Строки.Добавить(Новый ФорматированнаяСтрока(Строка(ВСД),, ЦветГиперссылки,, ПолучитьНавигационнуюСсылку(ВСД)));
			
		Иначе
			
			КоличествоВСД = 0;
			Для Каждого СтрокаТЧ Из ВходящиеСообщения Цикл
				Если ЗначениеЗаполнено(СтрокаТЧ.ВСД) Тогда
					КоличествоВСД = КоличествоВСД + 1;
				КонецЕсли;
			КонецЦикла;
			
			Строки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'запросы';
															|en = 'запросы'"),, ЦветГиперссылки,, "ОткрытьИсходящиеСообщения"));
			Строки.Добавить(" ");
			Строки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'ВСД по идентификаторам';
															|en = 'ВСД по идентификаторам'")));
			Строки.Добавить(" ");
			Строки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'получены';
															|en = 'получены'")));
			Строки.Добавить(" ");
			Строки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'ответы';
															|en = 'ответы'"),, ЦветГиперссылки,, "ОткрытьВходящиеСообщения"));
			Строки.Добавить(".");
			Строки.Добавить(Символы.ПС);
			Строки.Добавить(
				Новый ФорматированнаяСтрока(
					СтрШаблон(
							НСтр("ru = 'Загружено документов: %1';
								|en = 'Загружено документов: %1'"),
							КоличествоВСД),,
						ЦветГиперссылки,, "ОткрытьРезультат"));
			
		КонецЕсли;
		
	Иначе
		
			КоличествоВСД = 0;
			Для Каждого СтрокаТЧ Из ВходящиеСообщения Цикл
				Если ЗначениеЗаполнено(СтрокаТЧ.ВСД) Тогда
					КоличествоВСД = КоличествоВСД + 1;
				КонецЕсли;
			КонецЦикла;
			
			Строки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'запрос';
															|en = 'запрос'"),, ЦветГиперссылки,, "ОткрытьИсходящиеСообщения"));
			Строки.Добавить(" ");
			Строки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'ВСД с';
															|en = 'ВСД с'")));
			Строки.Добавить(" ");
			Строки.Добавить(Новый ФорматированнаяСтрока(Формат(НачалоПериода, "ДЛФ=D;")));
			
			Если ЗначениеЗаполнено(КонецПериода) Тогда
				Строки.Добавить(" ");
				Строки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'по';
																|en = 'по'")));
				Строки.Добавить(" ");
				Строки.Добавить(Новый ФорматированнаяСтрока(Формат(КонецПериода, "ДЛФ=D;")));
			КонецЕсли;
			
			Строки.Добавить(" ");
			Строки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'получены';
															|en = 'получены'")));
			Строки.Добавить(" ");
			Строки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'ответы';
															|en = 'ответы'"),, ЦветГиперссылки,, "ОткрытьВходящиеСообщения"));
			Строки.Добавить(".");
			Строки.Добавить(Символы.ПС);
			Строки.Добавить(
				Новый ФорматированнаяСтрока(
					СтрШаблон(
							НСтр("ru = 'Загружено новых документов: %1';
								|en = 'Загружено новых документов: %1'"),
							КоличествоВСД),,
						ЦветГиперссылки,, "ОткрытьРезультат"));
		
	КонецЕсли;
	
	ТекстРезультат = Новый ФорматированнаяСтрока(Строки);
	
	СтраницыФормы = Элементы.ГруппаСтраницы;
	СтраницыФормы.ТекущаяСтраница = СтраницыФормы.ПодчиненныеЭлементы.СтраницаЗапросРезультат;
	
	ГруппаСтраницыПриСменеСтраницы(СтраницыФормы, СтраницыФормы.ТекущаяСтраница);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьИменаСтраниц()
	
	СтраницыФормы = Новый Массив();
	
	СтраницыФормы.Добавить("СтраницаИсходныеДанные");
	СтраницыФормы.Добавить("СтраницаЗапросОжидание");
	СтраницыФормы.Добавить("СтраницаЗапросОшибка");
	СтраницыФормы.Добавить("СтраницаЗапросРезультат");
	
	ИменаСтраниц = Новый ФиксированныйМассив(СтраницыФормы);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьТекущуюСтраницуНавигации(Форма)
	
	СтраницыФормы     = Форма.Элементы.ГруппаСтраницы;
	СтраницыНавигации = Форма.Элементы.Навигация;
	
	ИндексСтраницы    = Форма.ИменаСтраниц.Найти(СтраницыФормы.ТекущаяСтраница.Имя);
	КоличествоСтраниц = Форма.ИменаСтраниц.Количество();
	
	Если ИндексСтраницы = 0 Тогда
		СтраницыНавигации.ТекущаяСтраница = СтраницыНавигации.ПодчиненныеЭлементы.НавигацияНачало;
		Форма.Элементы.НачалоДалее.КнопкаПоУмолчанию = Истина;
	ИначеЕсли ИндексСтраницы = (КоличествоСтраниц - 1) Тогда
		СтраницыНавигации.ТекущаяСтраница = СтраницыНавигации.ПодчиненныеЭлементы.НавигацияОкончание;
		Форма.Элементы.ОкончаниеЗакрыть.КнопкаПоУмолчанию = Истина;
	ИначеЕсли СтраницыФормы.ТекущаяСтраница = СтраницыФормы.ПодчиненныеЭлементы.СтраницаЗапросОшибка Тогда
		СтраницыНавигации.ТекущаяСтраница = СтраницыНавигации.ПодчиненныеЭлементы.НавигацияОшибка;
		Форма.Элементы.ОшибкаНазад.КнопкаПоУмолчанию = Истина;
	Иначе
		СтраницыНавигации.ТекущаяСтраница = СтраницыНавигации.ПодчиненныеЭлементы.НавигацияПродолжение;
		Если НЕ Форма.Элементы.ПродолжениеДалее.КнопкаПоУмолчанию Тогда
			Форма.Элементы.ПродолжениеДалее.КнопкаПоУмолчанию = Истина;
		КонецЕсли;
	КонецЕсли;
	
	Если СтраницыФормы.ТекущаяСтраница = СтраницыФормы.ПодчиненныеЭлементы.СтраницаЗапросОжидание Тогда
		СтраницыНавигации.Доступность = Ложь;
	Иначе
		СтраницыНавигации.Доступность = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Оборудование

&НаКлиенте
Процедура ПодключитьОборудованиеЗавершение(РезультатВыполнения, Параметры) Экспорт
	
	Если НЕ РезультатВыполнения.Результат Тогда
		ТекстСообщения = НСтр( "ru = 'При подключении оборудования произошла ошибка:""%ОписаниеОшибки%"".';
								|en = 'При подключении оборудования произошла ошибка:""%ОписаниеОшибки%"".'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ОписаниеОшибки%" , РезультатВыполнения.ОписаниеОшибки);
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтключитьОборудованиеЗавершение(РезультатВыполнения, Параметры) Экспорт
	
	Если НЕ РезультатВыполнения.Результат Тогда
		ТекстСообщения = НСтр( "ru = 'При отключении оборудования произошла ошибка: ""%ОписаниеОшибки%"".';
								|en = 'При отключении оборудования произошла ошибка: ""%ОписаниеОшибки%"".'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ОписаниеОшибки%" , РезультатВыполнения.ОписаниеОшибки);
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура ОбработатьРезультатЗагрузкиВСДИзВнешнегоФайла(Результат, ДополнительныеПараметры) Экспорт
	
	Если ТипЗнч(Результат) <> Тип("Массив") Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого Идентификатор Из Результат Цикл
		
		СтрокаТЧ = ИсходящиеЗапросы.Добавить();
		СтрокаТЧ.Идентификатор = Идентификатор;
		
	КонецЦикла;
	
	ИнтеграцияВЕТИСКлиент.ПронумероватьТаблицу(ЭтотОбъект, "ИсходящиеЗапросы");
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если ВидЗапроса = 1 Тогда
		
		Если ИсходящиеЗапросы.Количество() = 0 Тогда
			ОбщегоНазначения.СообщитьПользователю(
				НСтр("ru = 'Идентификаторы ВСД не заполнены.';
					|en = 'Идентификаторы ВСД не заполнены.'"),,
				"ИсходящиеЗапросы",,
				Отказ);
		КонецЕсли;
		
	Иначе
		
		Если Не ЗначениеЗаполнено(НачалоПериода) Тогда
			ОбщегоНазначения.СообщитьПользователю(
				НСтр("ru = 'Дата начала периода не заполнена.';
					|en = 'Дата начала периода не заполнена.'"),,
				"НачалоПериода",,
				Отказ);
		КонецЕсли;
		
		Если НачалоПериода >= КонецПериода Тогда
			ОбщегоНазначения.СообщитьПользователю(
				НСтр("ru = 'Дата конца периода загрузки ВСД должна быть больше даты начала.';
					|en = 'Дата конца периода загрузки ВСД должна быть больше даты начала.'"),,
				"КонецПериода",,
				Отказ);
		КонецЕсли;
		
	КонецЕсли;
	
	Для Каждого СтрокаТЧ Из ИсходящиеЗапросы Цикл
		
		Если Не СтроковыеФункцииКлиентСервер.ЭтоУникальныйИдентификатор(СтрокаТЧ.Идентификатор) Тогда
			
			ТекстСообщения = СтрШаблон(НСтр("ru = 'Значение %1 не является идентификатором.';
											|en = 'Значение %1 не является идентификатором.'"), СтрокаТЧ.Идентификатор);
			
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("ИсходящиеЗапросы", ИсходящиеЗапросы.Индекс(СтрокаТЧ) + 1, "Идентификатор"),,
				Отказ);
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Функция ИдентификаторИзШтрихкода(Штрихкод)
	
	Идентификатор = Неопределено;
	СтруктураURI = ОбщегоНазначенияКлиентСервер.СтруктураURI(Штрихкод);
	ПараметрыURI = СтрРазделить(
		Сред(СтруктураURI.ПутьНаСервере,
			СтрНайти(СтруктураURI.ПутьНаСервере, "?")), "&");
	
	Если ПараметрыURI.Количество() > 0 Тогда
		
		Для Каждого ПараметрURI Из ПараметрыURI Цикл
			
			ПараметрИЗначение = СтрРазделить(ПараметрURI, "=");
			Если ПараметрИЗначение.Количество() = 2
				И ПараметрИЗначение[0] = "uuid"
				И СтроковыеФункцииКлиентСервер.ЭтоУникальныйИдентификатор(ПараметрИЗначение[1]) Тогда
				
				Идентификатор = ПараметрИЗначение[1];
				Прервать;
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
	Возврат Идентификатор;
	
КонецФункции

#КонецОбласти
