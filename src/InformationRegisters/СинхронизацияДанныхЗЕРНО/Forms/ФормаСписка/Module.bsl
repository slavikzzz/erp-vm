#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	УстановитьБыстрыйОтборСервер();
	
	ОбщегоназначенияСобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура РекомендацииОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "ПараметрыОптимизации" Тогда
		
		СтандартнаяОбработка = Ложь;
		ОткрытьФорму("Обработка.ПанельАдминистрированияЗЕРНО.Форма.ПараметрыОптимизации");
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "УдалитьЗаписьСинхронизации" Тогда
		
		ТекущиеДанные = Элементы.Список.ТекущиеДанные;
		Если ТекущиеДанные <> Неопределено Тогда
			
			СтандартнаяОбработка = Ложь;
			УдалитьЗаписьСинхронизации(
				ТекущиеДанные.ИмяЗапросаЗЕРНО,
				ТекущиеДанные.Организация,
				ТекущиеДанные.Подразделение);
			
		КонецЕсли;
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "ВыполнитьОбмен" Тогда
		
		СтандартнаяОбработка = Ложь;
		Синхронизировать();
		
	ИначеЕсли ОбщегоНазначенияСлужебныйКлиент.ЭтоНавигационнаяСсылка(НавигационнаяСсылкаФорматированнойСтроки) Тогда
		
		СтандартнаяОбработка = Ложь;
		ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку(НавигационнаяСсылкаФорматированнойСтроки);
		
	Иначе
		
		ВызватьИсключение СтрШаблон(
			НСтр("ru = 'Неизвестная ссылка: %1';
				|en = 'Неизвестная ссылка: %1'"),
			НавигационнаяСсылкаФорматированнойСтроки);
		
	КонецЕсли;
	
КонецПроцедуры

#Область ОтборПоОрганизации

&НаКлиенте
Процедура ОтборОрганизацииПриИзменении(Элемент)
	
	ИнтеграцияЗЕРНОКлиент.ОбработатьВыборОрганизаций(ЭтотОбъект, Организации, Истина, "Отбор");
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацииНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияЗЕРНОКлиент.ОткрытьФормуВыбораОрганизаций(ЭтотОбъект, "Отбор");
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацииОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияЗЕРНОКлиент.ОбработатьВыборОрганизаций(ЭтотОбъект, Неопределено, Истина, "Отбор");
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацииОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияЗЕРНОКлиент.ОбработатьВыборОрганизаций(ЭтотОбъект, ВыбранноеЗначение, Истина, "Отбор");
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияПриИзменении(Элемент)
	
	ИнтеграцияЗЕРНОКлиент.ОбработатьВыборОрганизаций(ЭтотОбъект, Организация, Истина, "Отбор");
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияЗЕРНОКлиент.ОткрытьФормуВыбораОрганизаций(ЭтотОбъект, "Отбор");
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияЗЕРНОКлиент.ОбработатьВыборОрганизаций(ЭтотОбъект, Неопределено, Истина, "Отбор");
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияЗЕРНОКлиент.ОбработатьВыборОрганизаций(ЭтотОбъект, ВыбранноеЗначение, Истина, "Отбор");
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокОбработкаЗапросаОбновления(Элемент)
	
	ОбработкаАктивизацииСтроки();
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура СписокПриПолученииДанныхНаСервере(ИмяЭлемента, Настройки, Строки)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Таблица.ИмяЗапроса,
	|	Таблица.Подразделение,
	|	Таблица.Организация,
	|	Таблица.ДатаСинхронизации,
	|	Таблица.ДатаОбмена
	|ИЗ
	|	РегистрСведений.СинхронизацияДанныхЗЕРНО КАК Таблица
	|ГДЕ
	|	(Таблица.ИмяЗапроса, Таблица.Организация, Таблица.Подразделение) В (&Ключи)
	|";
	
	СтрокиСписка = Строки.ПолучитьКлючи();
	
	ДанныеСписка = Новый ТаблицаЗначений();
	ДанныеСписка.Колонки.Добавить("ИмяЗапроса",    Новый ОписаниеТипов("ПеречислениеСсылка.ИмяЗапросаЗЕРНО"));
	ДанныеСписка.Колонки.Добавить("Организация",   Новый ОписаниеТипов(Метаданные.ОпределяемыеТипы.Организация.Тип));
	ДанныеСписка.Колонки.Добавить("Подразделение", Новый ОписаниеТипов(Метаданные.ОпределяемыеТипы.Подразделение.Тип));
	ДанныеСписка.Колонки.Добавить("КлючЗаписи");
	Организации = Новый СписокЗначений();
	Для Каждого КлючЗаписи Из СтрокиСписка Цикл
		
		СтрокаТЧ = ДанныеСписка.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаТЧ, КлючЗаписи);
		СтрокаТЧ.КлючЗаписи = КлючЗаписи;
		
		// Состояние по-умолчанию: Зеленый
		СтрокаСписка = Строки[КлючЗаписи];
		СтрокаСписка.Оформление["ДатаОбмена"].УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.Зеленый);
		СтрокаСписка.Оформление["СостояниеОбмена"].УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.Зеленый);
		
		СтрокаСписка.Данные["ДатаОбмена"] = МестноеВремя(СтрокаСписка.Данные["ДатаОбмена"]);
		
		Организации.Добавить(КлючЗаписи.Организация);
	КонецЦикла;
	
	РезультатыЗапроса = ИнтеграцияЗЕРНО.СостояниеОбмена(Организации);
	
	// Обмен не выполнялся длительное время
	ИдентификаторПроблемы = "ДлительноеОтсутствиеОбменаСДИЗ";
	Проблемы = РезультатыЗапроса[ИдентификаторПроблемы].Выгрузить();
	Для Каждого СтрокаТЧ Из Проблемы Цикл
		
		СтруктураКлюча = Новый Структура;
		СтруктураКлюча.Вставить("ИмяЗапроса",    СтрокаТЧ.ИмяЗапроса);
		СтруктураКлюча.Вставить("Организация",   СтрокаТЧ.Организация);
		СтруктураКлюча.Вставить("Подразделение", СтрокаТЧ.Подразделение);
		
		НайденныеСтроки = ДанныеСписка.НайтиСтроки(СтруктураКлюча);
		ПрименитьОформление(Строки, НайденныеСтроки, ИдентификаторПроблемы,
			НСтр("ru = 'Обмен не выполнялся длительное время';
				|en = 'Обмен не выполнялся длительное время'"),
			ЦветаСтиля.ЦветТекстаТребуетВниманияГосИС);
		
	КонецЦикла;
	
	ДанныеСписка.Колонки.Удалить(ДанныеСписка.Колонки.Найти("КлючЗаписи"));
	Запрос.УстановитьПараметр("Ключи", ДанныеСписка);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		СтруктураКлюча = Новый Структура("Организация, Подразделение, ИмяЗапроса");
		ЗаполнитьЗначенияСвойств(СтруктураКлюча, Выборка);
		КлючЗаписи = РегистрыСведений.СинхронизацияДанныхЗЕРНО.СоздатьКлючЗаписи(СтруктураКлюча);
		
		СтрокаСписка = Строки[КлючЗаписи];
		
		Если Не ЗначениеЗаполнено(Выборка.ДатаОбмена) И Не ЗначениеЗаполнено(Выборка.ДатаСинхронизации) Тогда
			
			СтрокаСписка.Данные["ИдентификаторПроблемы"] = "СинхронизацияНеВыполняласьДлительноеВремя";
			СтрокаСписка.Данные["СостояниеОбмена"] = НСтр("ru = 'Синхронизация не выполнялась длительное время';
															|en = 'Синхронизация не выполнялась длительное время'");
			СтрокаСписка.Оформление["СостояниеОбмена"].УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаТребуетВниманияГосИС);
			
			СтрокаСписка.Данные["ДатаОбмена"] = НСтр("ru = '<не выполнялся>';
													|en = '<не выполнялся>'");
			СтрокаСписка.Оформление["ДатаОбмена"].УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаНеТребуетВниманияГосИС);
			
		Иначе
			
			Если ТекущаяДатаСеанса() - Выборка.ДатаОбмена > 30 * 24 * 60 * 60 Тогда
				
				СтрокаСписка.Данные["ИдентификаторПроблемы"] = "СинхронизацияНеВыполняласьДлительноеВремя";
				СтрокаСписка.Данные["СостояниеОбмена"] = НСтр("ru = 'Синхронизация не выполнялась длительное время';
																|en = 'Синхронизация не выполнялась длительное время'");
				СтрокаСписка.Оформление["СостояниеОбмена"].УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаТребуетВниманияГосИС);
				
				СтрокаСписка.Оформление["ДатаОбмена"].УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаТребуетВниманияГосИС);
				
			Иначе
				
				СтрокаСписка.Оформление["ДатаОбмена"].УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.Зеленый);
				
			КонецЕсли;
			
		КонецЕсли;
			
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле.Имя = "СостояниеОбмена" Тогда
		
		ДанныеСтроки = Элементы.Список.ДанныеСтроки(ВыбраннаяСтрока);
		
		СтандартнаяОбработка = Ложь;
		
		Если ДанныеСтроки.ИдентификаторПроблемы = "СинхронизацияНеВыполняласьДлительноеВремя" Тогда
			Синхронизировать();
		КонецЕсли;
	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	ОбработкаАктивизацииСтроки();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура Синхронизировать()
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено
		Или Не ЗначениеЗаполнено(ТекущиеДанные.ИмяЗапроса) Тогда
			ПоказатьПредупреждение(, ОбщегоНазначенияИСКлиентСервер.ТекстКомандаНеМожетБытьВыполнена());
			Возврат;
	КонецЕсли;
	
	ОчиститьСообщения();
	
	РезультатОбмена = СинхронизироватьНаСервере(
		ТекущиеДанные.ДатаСинхронизации,
		ТекущиеДанные.ИмяЗапроса,
		ТекущиеДанные.Организация,
		ТекущиеДанные.Подразделение);
	
	Если РезультатОбмена <> Неопределено Тогда
		ОбработатьРезультатОбмена(РезультатОбмена);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаАктивизацииСтроки()

	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Рекомендации = Неопределено;
		Возврат;
	КонецЕсли;
	
	Если ПустаяСтрока(ТекущиеДанные.ИдентификаторПроблемы) Тогда
		
		Рекомендации = Новый ФорматированнаяСтрока(НСтр("ru = 'Обмен выполняется, проблем не обнаружено.';
														|en = 'Обмен выполняется, проблем не обнаружено.'"));
		
	Иначе
		
		Рекомендации = ИнтеграцияЗЕРНОКлиентСервер.ПодсказкаКСостояниюОбмена(
			ТекущиеДанные.ИдентификаторПроблемы,
			ТекущиеДанные.ИмяЗапроса,
			Элементы.Рекомендации);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьБыстрыйОтборСервер()
	
	СтруктураБыстрогоОтбора = Неопределено;
	Параметры.Свойство("СтруктураБыстрогоОтбора", СтруктураБыстрогоОтбора);
	
	Если СтруктураБыстрогоОтбора <> Неопределено Тогда
		
		СтруктураБыстрогоОтбора.Свойство("Организация", Организация);
		СтруктураБыстрогоОтбора.Свойство("Организации", Организации);
		
		Если ЗначениеЗаполнено(Организации) Тогда
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Организация", Организации,,, Истина);
			
			ОрганизацииПредставление = Строка(Организации);
		КонецЕсли;
		
	КонецЕсли;
	
	ЗаполнитьСписокВыбораОрганизацииПоСохраненнымНастройкам();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокВыбораОрганизацииПоСохраненнымНастройкам()
	
	СобытияФормЗЕРНО.ЗаполнитьСписокВыбораОрганизацииПоСохраненнымНастройкам(ЭтотОбъект, "Оформлено");
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();
	
	// Нет данных о выполнении обмена
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДатаОбмена.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(Элементы.ДатаОбмена.ПутьКДанным);
	ОтборЭлемента.ВидСравнения  = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаНеТребуетВниманияГосИС);
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<нет данных>';
																|en = '<нет данных>'"));
	
	// Даты
	СтандартныеПодсистемыСервер.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "Список.ДатаОбмена", Элементы.ДатаОбмена.Имя);
	
КонецПроцедуры

&НаСервере
Функция СинхронизироватьНаСервере(ДатаСинхронизации, ИмяЗапросаЗерно, Организация, Подразделение)
	
	ПараметрыСинхронизации = Новый Структура;
	ПараметрыСинхронизации.Вставить("Организация",             Организация);
	ПараметрыСинхронизации.Вставить("Подразделение",           Подразделение);
	ПараметрыСинхронизации.Вставить("ДатаСинхронизации",       ДатаСинхронизации);
	ПараметрыСинхронизации.Вставить("ИмяЗапросаЗерно",         ИмяЗапросаЗерно);
	ПараметрыСинхронизации.Вставить("УникальныйИдентификатор", УникальныйИдентификатор);
	
	Возврат ИнтеграцияЗЕРНОСлужебный.ЗагрузитьИзменения(ПараметрыСинхронизации);
	
КонецФункции

&НаКлиенте
Процедура ОбработатьРезультатОбмена(РезультатОбмена)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПослеПолученияРезультатОбмена", ЭтотОбъект);
	
	ИнтеграцияЗЕРНОСлужебныйКлиент.ОбработатьРезультатОбмена(РезультатОбмена, ЭтотОбъект,, ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьОбменОбработкаОжидания(РезультатОбмена, ДополнительныеПараметры) Экспорт
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПослеПолученияРезультатОбмена", ЭтотОбъект);
	ИнтеграцияЗЕРНОСлужебныйКлиент.ПродолжитьВыполнениеОбмена(ЭтотОбъект,, ОписаниеОповещения, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеПолученияРезультатОбмена(Изменения, ДополнительныеПараметры) Экспорт
	
	Элементы.Список.Обновить();
	
	ОбработкаАктивизацииСтроки();
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ПрименитьОформление(Строки, НайденныеСтроки, ИдентификаторПроблемы, СостояниеОбмена, ЦветТекста)
	
	Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл
		
		СтрокаСписка = Строки[НайденнаяСтрока.КлючЗаписи];
		
		Если ПустаяСтрока(СтрокаСписка.Данные["СостояниеОбмена"]) Тогда
			
			СтрокаСписка.Данные["ИдентификаторПроблемы"] = ИдентификаторПроблемы;
			СтрокаСписка.Данные["СостояниеОбмена"]       = СостояниеОбмена;
			
			СтрокаСписка.Оформление["СостояниеОбмена"].УстановитьЗначениеПараметра("ЦветТекста", ЦветТекста);
			СтрокаСписка.Оформление["ДатаОбмена"].УстановитьЗначениеПараметра("ЦветТекста",      ЦветТекста);
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура УдалитьЗаписьСинхронизации(ИмяЗапросаЗЕРНО, Организация, Подразделение)
	
	УстановитьПривилегированныйРежим(Истина);
	
	НаборЗаписей = РегистрыСведений.СинхронизацияДанныхЗЕРНО.СоздатьНаборЗаписей();
	
	Если ИмяЗапросаЗЕРНО <> Неопределено Тогда
		НаборЗаписей.Отбор.ИмяЗапроса.Установить(ИмяЗапросаЗЕРНО);
	КонецЕсли;
	
	НаборЗаписей.Отбор.Организация.Установить(Организация);
	НаборЗаписей.Отбор.Подразделение.Установить(Подразделение);
	
	НаборЗаписей.Записать(Истина);
	
	Элементы.Список.Обновить();
	
КонецПроцедуры

#КонецОбласти