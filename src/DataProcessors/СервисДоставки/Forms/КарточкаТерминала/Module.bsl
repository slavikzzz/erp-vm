#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Не СервисДоставки.ПравоРаботыССервисомДоставки(Истина) Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Параметры.Свойство("Идентификатор", Идентификатор);
	Параметры.Свойство("ОрганизацияБизнесСетиСсылка", ОрганизацияБизнесСетиСсылка);
	
	СервисДоставкиСлужебный.ПроверитьОрганизациюБизнесСети(ОрганизацияБизнесСетиСсылка, Отказ);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Параметры.Свойство("ТипГрузоперевозки", ТипГрузоперевозки);
	
	Если НЕ ЗначениеЗаполнено(ТипГрузоперевозки) Тогда
		ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'Не выбран тип грузоперевозки';
													|en = 'Cargo transportation type is not selected'"));
		Отказ = Истина;
		Возврат;
	ИначеЕсли НЕ СервисДоставки.ТипГрузоперевозкиДоступен(ТипГрузоперевозки) Тогда
		ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'Выбранный тип грузоперевозки не доступен';
													|en = 'The selected cargo transportation type is not available'"));
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	НастроитьФормуПоТипуГрузоперевозки();
	
	// Запуск фонового задания для загрузки доступных форм.
	ФоновоеЗаданиеПолучитьДанныеТерминала = ПолучитьТерминал();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ЗначениеЗаполнено(ФоновоеЗаданиеПолучитьДанныеТерминала) Тогда
		
		ПараметрыОперации = Новый Структура("ИмяПроцедуры, НаименованиеОперации, ВыводитьОкноОжидания");
		ПараметрыОперации.ИмяПроцедуры = СервисДоставкиКлиентСервер.ИмяПроцедурыПолучитьДанныеТерминала();
		ПараметрыОперации.НаименованиеОперации = НСтр("ru = 'Получение данных терминала.';
														|en = 'Getting terminal data.'");
		
		ОжидатьЗавершениеВыполненияЗапроса(ПараметрыОперации);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КарточкаТерминалаОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка, ДополнительныеПараметры)
	
	Если Расшифровка = "Грузоперевозчик" Тогда
		
		СтандартнаяОбработка = Ложь;
		ОткрытьФормуГрузоперевозчика();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗакрытьФорму(Команда)
		Закрыть();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура НастроитьФормуПоТипуГрузоперевозки();
	
	Заголовок = СтрШаблон(НСтр("ru = '%1: Пункт приема-выдачи';
								|en = '%1: Point of acceptance and delivery'"),
		СервисДоставкиКлиентСервер.ПредставлениеТипаГрузоперевозки(ТипГрузоперевозки));
	
КонецПроцедуры

#Область ВыполнитьЗапрос

&НаКлиенте
Процедура ОжидатьЗавершениеВыполненияЗапроса(ПараметрыОперации)
	
	ВыводитьОкноОжидания = ?(ЗначениеЗаполнено(ПараметрыОперации.ВыводитьОкноОжидания), 
																	ПараметрыОперации.ВыводитьОкноОжидания,
																	Ложь);
	// Установка картинки длительной операции.
	Если Не ВыводитьОкноОжидания Тогда
		
		Если ПараметрыОперации.ИмяПроцедуры = СервисДоставкиКлиентСервер.ИмяПроцедурыПолучитьДанныеТерминала() Тогда
			
			Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаОжиданиеЗагрузки;
			
		КонецЕсли;
		
	КонецЕсли;
	
	// Инициализация обработчик ожидания завершения.
	ИмяФоновогоЗадания = "ФоновоеЗадание" + ПараметрыОперации.ИмяПроцедуры;
	ФоновоеЗадание = ЭтотОбъект[ИмяФоновогоЗадания];
	ПараметрыОперации.Вставить("ФоновоеЗадание", ФоновоеЗадание);
	
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ПараметрыОжидания.ТекстСообщения = ПараметрыОперации.НаименованиеОперации;
	ПараметрыОжидания.ВыводитьПрогрессВыполнения = Ложь;
	ПараметрыОжидания.ВыводитьОкноОжидания = ВыводитьОкноОжидания;
	ПараметрыОжидания.ОповещениеПользователя.Показать = Ложь;
	ПараметрыОжидания.ВыводитьСообщения = Истина;
	ПараметрыОжидания.Вставить("ИдентификаторЗадания", ФоновоеЗадание.ИдентификаторЗадания);
	
	ОбработкаЗавершения = Новый ОписаниеОповещения("ВыполнитьЗапросЗавершение",
		ЭтотОбъект, ПараметрыОперации);
		
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ФоновоеЗадание, ОбработкаЗавершения, ПараметрыОжидания);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьЗапросЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	// Инициализация.
	Отказ = Ложь;
	ИмяФоновогоЗадания = "ФоновоеЗадание" + ДополнительныеПараметры.ИмяПроцедуры;
	ФоновоеЗадание = ЭтотОбъект[ИмяФоновогоЗадания];
	
	// Скрыть элементы ожидания на форме
	Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаОсновная;
	
	// Вывод сообщений из фонового задания.
	СервисДоставкиКлиент.ОбработатьРезультатФоновогоЗадания(Результат, ДополнительныеПараметры, Отказ);
	Если Результат = Неопределено ИЛИ ФоновоеЗадание = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	// Проверка результата поиска.
	Если Не Отказ И Результат.Статус = "Выполнено" Тогда
		Если ЗначениеЗаполнено(Результат.АдресРезультата)
			И ЭтоАдресВременногоХранилища(Результат.АдресРезультата)
			И ДополнительныеПараметры.ФоновоеЗадание.ИдентификаторЗадания
			= ЭтотОбъект[ИмяФоновогоЗадания].ИдентификаторЗадания Тогда
			
			Если ДополнительныеПараметры.ИмяПроцедуры = СервисДоставкиКлиентСервер.ИмяПроцедурыПолучитьДанныеТерминала() Тогда
				
				// Загрузка результатов запроса.
				ОперацияВыполнена = Истина;
				ЗагрузитьРезультатПолученияДанныхТерминала(Результат.АдресРезультата, ОперацияВыполнена);
				ЭтотОбъект[ИмяФоновогоЗадания] = Неопределено;
				
				СформироватьКарточкуТерминала();
				
			КонецЕсли;
			
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ВыполнитьЗапросВФоне

&НаСервере
Функция ВыполнитьЗапросВФоне(ИнтернетПоддержкаПодключена, ПараметрыОперации)
	
	// Проверка подключения Интернет-поддержки пользователей.
	ИнтернетПоддержкаПодключена =
		ИнтернетПоддержкаПользователей.ЗаполненыДанныеАутентификацииПользователяИнтернетПоддержки();
	Если Не ИнтернетПоддержкаПодключена Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Отказ = Ложь;
	ПараметрыЗапроса = ПараметрыЗапроса(ПараметрыОперации, Отказ);
	
	Если Отказ Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ИмяФоновогоЗадания = "ФоновоеЗадание" + ПараметрыОперации.ИмяПроцедуры;
	ФоновоеЗадание = ЭтотОбъект[ИмяФоновогоЗадания];
	Если ФоновоеЗадание <> Неопределено Тогда
		ОтменитьВыполнениеЗадания(ФоновоеЗадание.ИдентификаторЗадания);
	КонецЕсли;
	
	Задание = Новый Структура("ИмяПроцедуры, Наименование, ПараметрыПроцедуры");
	Задание.Наименование = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = '%1.';
																						|en = '%1.'"),
		ПараметрыОперации.НаименованиеОперации);
	Задание.ИмяПроцедуры = "СервисДоставки." + ПараметрыОперации.ИмяПроцедуры;
	Задание.ПараметрыПроцедуры = ПараметрыЗапроса;
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = Задание.Наименование;
	ПараметрыВыполнения.ОжидатьЗавершение = 0;
	
	Возврат ДлительныеОперации.ВыполнитьВФоне(Задание.ИмяПроцедуры,
		Задание.ПараметрыПроцедуры, ПараметрыВыполнения);
	
КонецФункции

&НаСервереБезКонтекста
Процедура ОтменитьВыполнениеЗадания(ИдентификаторЗадания)
	
	Если ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ДлительныеОперации.ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
		ИдентификаторЗадания = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьТерминал()
	
	ПараметрыОперации = Новый Структура("ИмяПроцедуры, НаименованиеОперации, ВыводитьОкноОжидания");
	ПараметрыОперации.ИмяПроцедуры = СервисДоставкиКлиентСервер.ИмяПроцедурыПолучитьДанныеТерминала();
	ПараметрыОперации.НаименованиеОперации = НСтр("ru = 'Получение данных терминала.';
													|en = 'Getting terminal data.'");
	
	Возврат ВыполнитьЗапросВФоне(Ложь, ПараметрыОперации);
	
КонецФункции

#КонецОбласти

#Область ПараметрыЗапроса

&НаСервере
Функция ПараметрыЗапроса(ПараметрыОперации, Отказ)
	
	ПараметрыЗапроса = Новый Структура();
	
	ИмяПроцедуры = ПараметрыОперации.ИмяПроцедуры;
	
	Если ИмяПроцедуры = СервисДоставкиКлиентСервер.ИмяПроцедурыПолучитьДанныеТерминала() Тогда
		ПараметрыЗапроса = ПараметрыЗапросаПолучитьДанныеТерминала(ПараметрыЗапроса, Отказ);
	КонецЕсли;
	
	ПараметрыЗапроса.Вставить("ОрганизацияБизнесСетиСсылка", ОрганизацияБизнесСетиСсылка);
	
	Возврат ПараметрыЗапроса;
	
КонецФункции

&НаСервере
Функция ПараметрыЗапросаПолучитьДанныеТерминала(ПараметрыЗапроса, Отказ)
	
	ПараметрыЗапроса = СервисДоставки.НовыйПараметрыЗапросаПолучитьДанныеТерминала();
	ПараметрыЗапроса.Вставить("Идентификатор", Идентификатор);
	
	Возврат ПараметрыЗапроса;

КонецФункции

#КонецОбласти

#Область ЗагрузитьРезультаты

&НаСервере
Процедура ЗагрузитьРезультатПолученияДанныхТерминала(АдресРезультата, ОперацияВыполнена)
	
	Если ЭтоАдресВременногоХранилища(АдресРезультата) Тогда
		
		Результат = ПолучитьИзВременногоХранилища(АдресРезультата);
		Если ЗначениеЗаполнено(Результат) 
			И ТипЗнч(Результат) = Тип("Структура") Тогда
			
			Если Результат.Свойство("Данные") Тогда
				
				ЗаполнитьЗначенияСвойств(ЭтаФорма, Результат.Данные);
				
				ГрафикРаботы = Результат.Данные.ГрафикРаботы;
				Для Каждого ТекущаяСтрока Из ГрафикРаботы Цикл
					
					НоваяСтрока = ГрафикРаботыСписок.Добавить();
					ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекущаяСтрока);
					
				КонецЦикла;
				
				ТекстЗаголовка = НСтр("ru = '%1: %2 (%3)';
										|en = '%1: %2 (%3)'");
				Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					ТекстЗаголовка,
					СервисДоставкиКлиентСервер.ПредставлениеТипаГрузоперевозки(ТипГрузоперевозки),
					Наименование,
					ТипНаименование);
				
			Иначе
				ОперацияВыполнена = Ложь;
			КонецЕсли;
			
			СервисДоставки.ОбработатьБлокОшибок(Результат, ОперацияВыполнена);
			
		Иначе
			ОперацияВыполнена = Ложь;
		КонецЕсли;
		
	Иначе
		ОперацияВыполнена = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

&НаСервере
Процедура СформироватьКарточкуТерминала()
	
	КарточкаТерминала = ТабличныйДокументКарточкаТерминала();
	
КонецПроцедуры

&НаСервере
Функция ТабличныйДокументКарточкаТерминала()
	
	ТабличныйДокумент = Новый ТабличныйДокумент();
	
	Обработка = РеквизитФормыВЗначение("Объект");
	Макет = Обработка.ПолучитьМакет("Терминал");
	
	ОбластьМакетаШапка = Макет.ПолучитьОбласть("Шапка");
	
	ПараметрыОбласти = ОбластьМакетаШапка.Параметры;
	
	ПараметрыОбласти.Наименование = Наименование;
	ПараметрыОбласти.ТипНаименование = ТипНаименование;
	ПараметрыОбласти.Адрес = Адрес;
	ПараметрыОбласти.Телефон = Телефон;
	ПараметрыОбласти.ГрузоперевозчикНаименование = ГрузоперевозчикНаименование;
	ПараметрыОбласти.РасшифровкаГрузоперевозчик = "Грузоперевозчик";
	
	ТабличныйДокумент.Вывести(ОбластьМакетаШапка);
	
	Если Описание <> "" Тогда
		ОбластьМакетаОписание = Макет.ПолучитьОбласть("Описание");
		ОбластьМакетаОписание.Параметры.Описание = Описание;
		ТабличныйДокумент.Вывести(ОбластьМакетаОписание);
	КонецЕсли;
	
	Если ГрафикРаботыСписок.Количество() > 0 Тогда
		
		ОбластьМакетаЗаголовокТаблицыГрафикРаботы = Макет.ПолучитьОбласть("ЗаголовокТаблицыГрафикРаботы");
		ТабличныйДокумент.Вывести(ОбластьМакетаЗаголовокТаблицыГрафикРаботы);
		
		ОбластьМакетаСтрокаТаблицыГрафикРаботы = Макет.ПолучитьОбласть("СтрокаТаблицыГрафикРаботы");
		
		Для Каждого ТекущаяСтрока Из ГрафикРаботыСписок Цикл
			ОбластьМакетаСтрокаТаблицыГрафикРаботы.Параметры.Заполнить(ТекущаяСтрока);
			ТабличныйДокумент.Вывести(ОбластьМакетаСтрокаТаблицыГрафикРаботы);
		КонецЦикла;
		
	КонецЕсли;
	
	Возврат ТабличныйДокумент;
	
КонецФункции

&НаКлиенте
Процедура ОткрытьФормуГрузоперевозчика()
	
	ПараметрыОткрытияФормы = Новый Структура();
	ПараметрыОткрытияФормы.Вставить("Идентификатор", ГрузоперевозчикИдентификатор);
	ПараметрыОткрытияФормы.Вставить("ОрганизацияБизнесСетиСсылка", ОрганизацияБизнесСетиСсылка);
	ПараметрыОткрытияФормы.Вставить("ТипГрузоперевозки", ТипГрузоперевозки);
	
	ОткрытьФорму("Обработка.СервисДоставки.Форма.КарточкаГрузоперевозчика", 
		ПараметрыОткрытияФормы,
		ЭтаФорма,,,,,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
							
КонецПроцедуры

#КонецОбласти
