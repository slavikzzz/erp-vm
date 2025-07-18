#Область ПрограммныйИнтерфейс

#Область ДлительныеОперации

// Подготавливает сообщения к передаче в сервис САТУРН.
//
// Параметры:
//  ВходящиеДанные - Массив Из (См. ИнтерфейсСАТУРНКлиентСервер.ПараметрыОбработкиДокументов)
//  УникальныйИдентификатор - УникальныйИдентификатор - Уникальный идентификатор формы.
// 
// Возвращаемое значение:
//  Структура - см. функцию ПодготовитьСообщенияКПередаче().
//
Функция ПодготовитьКПередаче(ВходящиеДанные, УникальныйИдентификатор = Неопределено) Экспорт
	
	Организации = Неопределено;
	
	ПараметрыОбмена = ИнтеграцияСАТУРН.ПараметрыОбмена(Организации, УникальныйИдентификатор);
	
	Если УникальныйИдентификатор <> Неопределено И Не ОбщегоНазначенияИС.РежимРаботыБезФоновыхЗаданий() Тогда
		
		ВозвращаемоеЗначение = Новый Структура;
		ВозвращаемоеЗначение.Вставить("Изменения",                      Новый Массив);
		ВозвращаемоеЗначение.Вставить("ДлительнаяОперация",             Неопределено);
		ВозвращаемоеЗначение.Вставить("Ожидать",                        Неопределено);
		ВозвращаемоеЗначение.Вставить("АдресВоВременномХранилище",      Неопределено);
		
		ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
		ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Выполнение обмена с ФГИС ""Сатурн""';
																|en = 'Выполнение обмена с ФГИС ""Сатурн""'");
		
		ПараметрыФоновогоЗадания = Новый Структура;
		ПараметрыФоновогоЗадания.Вставить("ВходящиеДанные",    ВходящиеДанные);
		ПараметрыФоновогоЗадания.Вставить("ПараметрыОбмена",   ПараметрыОбмена);
		ПараметрыФоновогоЗадания.Вставить("ПараметрыСеансаИС", ИнтеграцияСАТУРНСлужебный.ПараметрыСеансаИС());
		
		ИнтеграцияИСПереопределяемый.НастроитьДлительнуюОперацию(ПараметрыФоновогоЗадания, ПараметрыВыполнения);
		
		ВозвращаемоеЗначение.ДлительнаяОперация = ДлительныеОперации.ВыполнитьВФоне(
			"ИнтеграцияСАТУРНСлужебный.ПодготовитьКПередачеДлительнаяОперация",
			ПараметрыФоновогоЗадания, ПараметрыВыполнения);
		
	Иначе
		
		ВозвращаемоеЗначение = ИнтеграцияСАТУРНСлужебный.ПодготовитьКПередачеУниверсально(ВходящиеДанные, ПараметрыОбмена);
		
	КонецЕсли;
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

Функция ВыполнитьОбмен(ЗначениеОтбора = Неопределено, УникальныйИдентификатор = Неопределено, СообщениеИлиДокумент = Неопределено) Экспорт
	
	ВозвращаемоеЗначение = НоваяСтруктураРезультатовОбмена();
	
	ПараметрыОбмена = ИнтеграцияСАТУРН.ПараметрыОбмена(ЗначениеОтбора, УникальныйИдентификатор);
	
	ВыполнитьОбработкуОчередиСообщений = ИнтеграцияСАТУРНСлужебный.ПодготовитьДанныеКПередачеПоНастройкеРегламентногоЗадания(ПараметрыОбмена);
	
	Если Не ВыполнитьОбработкуОчередиСообщений Тогда
		Возврат ВозвращаемоеЗначение;
	КонецЕсли;
	
	ИнтеграцияСАТУРНСлужебный.ПостроитьОчередьСообщений(ПараметрыОбмена, СообщениеИлиДокумент);
	
	Если УникальныйИдентификатор <> Неопределено И Не ОбщегоНазначенияИС.РежимРаботыБезФоновыхЗаданий() Тогда
		
		ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
		ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Выполнение обмена с ФГИС ""Сатурн""';
																|en = 'Выполнение обмена с ФГИС ""Сатурн""'");
		
		ПараметрыФоновогоЗадания = Новый Структура;
		ПараметрыФоновогоЗадания.Вставить("ПараметрыОбмена",   ПараметрыОбмена);
		ПараметрыФоновогоЗадания.Вставить("ПараметрыСеансаИС", ИнтеграцияСАТУРНСлужебный.ПараметрыСеансаИС());
		
		ИнтеграцияИСПереопределяемый.НастроитьДлительнуюОперацию(ПараметрыФоновогоЗадания, ПараметрыВыполнения);
		
		ВозвращаемоеЗначение.ДлительнаяОперация = ДлительныеОперации.ВыполнитьВФоне(
			"ИнтеграцияСАТУРНСлужебный.ВыполнитьОбменДлительнаяОперация",
			ПараметрыФоновогоЗадания, ПараметрыВыполнения);
		
	Иначе
		
		ВозвращаемоеЗначение = ИнтеграцияСАТУРНСлужебный.ВыполнитьОбменУниверсально(ПараметрыОбмена);
		
	КонецЕсли;
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

Функция ПродолжитьВыполнениеОбмена(АдресВоВременномХранилище) Экспорт
	
	ПараметрыОбмена = ПолучитьИзВременногоХранилища(АдресВоВременномХранилище);
	
	Если ПараметрыОбмена.УникальныйИдентификатор <> Неопределено
		И Не ОбщегоНазначенияИС.РежимРаботыБезФоновыхЗаданий() Тогда
		
		ВозвращаемоеЗначение = Новый Структура;
		ВозвращаемоеЗначение.Вставить("Изменения",                      Новый Массив);
		ВозвращаемоеЗначение.Вставить("ДлительнаяОперация",             Неопределено);
		ВозвращаемоеЗначение.Вставить("Ожидать",                        Неопределено);
		ВозвращаемоеЗначение.Вставить("АдресВоВременномХранилище",      Неопределено);
		
		ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(ПараметрыОбмена.УникальныйИдентификатор);
		ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Выполнение обмена с ФГИС ""Сатурн""';
																|en = 'Выполнение обмена с ФГИС ""Сатурн""'");
		
		ПараметрыФоновогоЗадания = Новый Структура;
		ПараметрыФоновогоЗадания.Вставить("ПараметрыОбмена",                  ПараметрыОбмена);
		ПараметрыФоновогоЗадания.Вставить("ПараметрыСеансаИС",                ИнтеграцияСАТУРНСлужебный.ПараметрыСеансаИС());
		
		ИнтеграцияИСПереопределяемый.НастроитьДлительнуюОперацию(ПараметрыФоновогоЗадания, ПараметрыВыполнения);
		
		ВозвращаемоеЗначение.ДлительнаяОперация = ДлительныеОперации.ВыполнитьВФоне(
			"ИнтеграцияСАТУРНСлужебный.ПродолжитьВыполнениеОбменаДлительнаяОперация",
			ПараметрыФоновогоЗадания, ПараметрыВыполнения);
		
	Иначе
		
		ВозвращаемоеЗначение = ИнтеграцияСАТУРНСлужебный.ПродолжитьВыполнениеОбменаУниверсально(ПараметрыОбмена);
		
	КонецЕсли;
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

#КонецОбласти

// Удаляет неотправленную операцию из очереди передачи данных в Сатурн.
//
// Параметры:
//  ДокументСсылка - ДокументСсылка - документ, по которому требуется отменить передачу данных.
//
// Возвращаемое значение:
//  Массив - Массив структур, см. функцию ИнтеграцияСАТУРНСлужебный.СтруктураИзменения(), или Неопределено (если в очереди нет сообщений).
//
Функция ОтменитьПередачу(ДокументСсылка) Экспорт
	
	Изменения = Новый Массив;
	
	ОчередьСообщений = РегистрыСведений.ОчередьСообщенийСАТУРН.ОчередьСообщенийПоДокументу(ДокументСсылка);
	
	Если ОчередьСообщений.Количество() = 0 Тогда
		
		ВосстановитьСтатусДокументаПоДаннымПротоколаОбмена(ДокументСсылка);
		
		Возврат Неопределено;
		
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТекстОшибки = "";
	
	НачатьТранзакцию();
	Попытка
		
		Для Каждого ЭлементОчереди Из ОчередьСообщений Цикл
			НаборЗаписей = РегистрыСведений.ОчередьСообщенийСАТУРН.СоздатьНаборЗаписей();
			НаборЗаписей.Отбор.Сообщение.Установить(ЭлементОчереди.Сообщение, Истина);
			НаборЗаписей.Записать();
		КонецЦикла;
		
		ВосстановитьСтатусДокументаПоДаннымПротоколаОбмена(ДокументСсылка, ЭлементОчереди.Сообщение);
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		ТекстОшибки = ОбработкаОшибок.КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
		ИнтеграцияСАТУРНСлужебный.ЗаписатьОшибкуВЖурналРегистрации(ТекстОшибки);
		
	КонецПопытки;
	
	УстановитьПривилегированныйРежим(Ложь);
	
	ДокументОснование = Неопределено;
	Если ДокументСсылка.Метаданные().Реквизиты.Найти("ДокументОснование") <> Неопределено Тогда
		ДокументОснование = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДокументСсылка, "ДокументОснование");
	КонецЕсли;
	
	СтрокаРезультата = ИнтеграцияСАТУРНСлужебный.СтруктураИзменения();
	СтрокаРезультата.ОрганизацияСАТУРН = ЭлементОчереди.ОрганизацияСАТУРН;
	СтрокаРезультата.Операция          = ЭлементОчереди.Операция;
	СтрокаРезультата.ДокументОснование = ДокументОснование;
	СтрокаРезультата.ТекстОшибки       = ТекстОшибки;
	СтрокаРезультата.Объект.Добавить(ДокументСсылка);
	
	Изменения.Добавить(СтрокаРезультата);
	
	Возврат Изменения;
	
КонецФункции

// Отменяет последнюю операцию (например, если возникла ошибка передачи данных).
//
// Параметры:
//  ДокументСсылка - ДокументСсылка - документ, по которому требуется отменить операцию.
//
// Возвращаемое значение:
//  см. ИнтеграцияСАТУРНСлужебный.СтруктураИзменения.
//
Функция ОтменитьПоследнююОперацию(ДокументСсылка) Экспорт
	
	Изменения = Новый Массив;
	
	ДанныеПоследнегоСообщения = Справочники.САТУРНПрисоединенныеФайлы.ПоследнееСообщение(ДокументСсылка, "Передано");
	
	Если ДанныеПоследнегоСообщения = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТекстОшибки = "";
	Попытка
		ВосстановитьСтатусДокументаПоДаннымПротоколаОбмена(ДокументСсылка, ДанныеПоследнегоСообщения.Сообщение);
	Исключение
		ТекстОшибки = ОбработкаОшибок.КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
		ИнтеграцияСАТУРНСлужебный.ЗаписатьОшибкуВЖурналРегистрации(ТекстОшибки);
		Возврат Неопределено;
	КонецПопытки;
	
	УстановитьПривилегированныйРежим(Ложь);
	
	ДокументОснование = Неопределено;
	Если ДокументСсылка.Метаданные().Реквизиты.Найти("ДокументОснование") <> Неопределено Тогда
		ДокументОснование = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДокументСсылка, "ДокументОснование");
	КонецЕсли;
	
	СтрокаРезультата = ИнтеграцияСАТУРНСлужебный.СтруктураИзменения();
	СтрокаРезультата.ОрганизацияСАТУРН = ДанныеПоследнегоСообщения.ОрганизацияСАТУРН;
	СтрокаРезультата.Операция          = ДанныеПоследнегоСообщения.Операция;
	СтрокаРезультата.ДокументОснование = ДокументОснование;
	СтрокаРезультата.ТекстОшибки       = ТекстОшибки;
	СтрокаРезультата.Объект.Добавить(ДокументСсылка);
	
	Изменения.Добавить(СтрокаРезультата);
	
	Возврат Изменения;
	
КонецФункции

Функция ВестиУчетПродукции() Экспорт
	
	Возврат ПолучитьФункциональнуюОпцию("ВестиУчетПестицидовАгрохимикатовТукосмесейСАТУРН");
	
КонецФункции

// Возвращает отборы для реквизитов документа по основанию
//
// Параметры:
// 	ТипДокумента - Тип - Тип документа
//  ДокументОснование - ДокументСсылка - ссылка на документ-основание
// 
// Возвращаемое значение:
//  Неопределено - отсуствует результат
//  Структура - структура со свойствами, по которым нужно устанавливать отбор:
//  * ГрузоотправительИзОснованияДляОтбораОрганизации - СправочникСсылка - ссылка на элемент справочника,
//  	по которому нужно делать отбор организаций САТУРН грузоотправителя
//  * ГрузоотправительИзОснованияДляОтбораМестаХранения - СправочникСсылка - ссылка на элемент справочника,
//  	по которому нужно делать отбор мест хранения САТУРН грузоотправителя
//  * ГрузополучательИзОснованияДляОтбораОрганизации - СправочникСсылка - ссылка на элемент справочника,
//  	по которому нужно делать отбор организаций САТУРН грузополучателя
//  * ГрузополучательИзОснованияДляОтбораМестаХранения - СправочникСсылка - ссылка на элемент справочника,
//  	по которому нужно делать отбор мест хранения САТУРН грузополучателя.
//
Функция ОтборыДляРеквизитовДокументаПоОснованию(ТипДокумента, ДокументОснование) Экспорт
	
	ЭлементСоответствияПолейДокумента = ИнтеграцияСАТУРНКлиентСервер.СоответствиеПолейДокументовОснованийИДокументовСАТУРН(
		ТипДокумента, ТипЗнч(ДокументОснование));
	
	Если Не (ЭлементСоответствияПолейДокумента = Неопределено) Тогда
		СтруктураВозврата = Новый Структура;
	
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("Ссылка", ДокументОснование);
	
		ТекстЗапроса = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ИСТИНА
		|ИЗ
		|	Документ.ИмяТаблицыДокумента КАК ТаблицаДокумента
		|ГДЕ
		|	ТаблицаДокумента.Ссылка = &Ссылка";
	
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "ИмяТаблицыДокумента", ЭлементСоответствияПолейДокумента.Ключ);
		
		Для Каждого СоответствиеПоля Из ЭлементСоответствияПолейДокумента.Значение Цикл
			СтруктураВозврата.Вставить(СоответствиеПоля.Ключ);
			ТекстЗапроса = СтрЗаменить(ТекстЗапроса,
				"
			|	ИСТИНА",
			СтрШаблон("
			|	%1%2 КАК %3,
			|	ИСТИНА",
				?(ЗначениеЗаполнено(СоответствиеПоля.Значение), "ТаблицаДокумента.", "НЕОПРЕДЕЛЕНО"),
				?(ЗначениеЗаполнено(СоответствиеПоля.Значение), СоответствиеПоля.Значение, ""),
				СоответствиеПоля.Ключ));
		КонецЦикла;
		
		Запрос.Текст = ТекстЗапроса;
		
		РезультатЗапроса = Запрос.Выполнить();
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
			
		Если ВыборкаДетальныеЗаписи.Следующий() Тогда
			ЗаполнитьЗначенияСвойств(СтруктураВозврата, ВыборкаДетальныеЗаписи);
		КонецЕсли;
		Возврат СтруктураВозврата;
		
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

#Область НастройкиУчета

// Возвращает признак включения режима работы с тестовым контуром Сатурн
//
// Возвращаемое значение:
//  Булево - Истина, если включен режим работы с тестовым контуром Сатурн.
//
Функция РежимРаботыСТестовымКонтуромСАТУРН() Экспорт
	
	Возврат ПолучитьФункциональнуюОпцию("РежимРаботыСТестовымКонтуромСАТУРН");
	
КонецФункции

#КонецОбласти

// Возвращает признак наличия типа метаданных конфигурации в типе реквизита "ДокументОснование"
// Наличие типа означает то, что документ может иметь документ-основание.
// 
// Параметры:
//   ПолноеИмяМетаданных - Строка - Полное имя объекта метаданных
// Возвращаемое значение:
//   Булево - Истина, в случае необходимости контроля статусов.
//
Функция ДокументМожетИметьДокументОснование(ПолноеИмяМетаданных) Экспорт
	
	ЭлементМетаданных = Метаданные.НайтиПоПолномуИмени(ПолноеИмяМетаданных);
	
	Если ЭлементМетаданных = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Реквизит = ЭлементМетаданных.Реквизиты.Найти("ДокументОснование");
	
	Если Реквизит = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Для Каждого СтрокаТип Из Реквизит.Тип.Типы() Цикл
		Если Метаданные.НайтиПоТипу(СтрокаТип) <> Неопределено Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Ложь;
	
КонецФункции

// Восстанавливает статус документа по данным протокола обмена.
//
// Параметры:
//  ДокументСсылка - ДокументСсылка - документ, по которому требуется восстановить статус.
//  СообщениеПрерывания - Строка, СправочникСсылка.САТУРНПрисоединенныеФайлы - Сообщение на котором необходимо закончить процесс расчета статусов.
// Возвращаемое значение:
// 	ПеречислениеСсылка.СтатусыОбработкиНакладнойСАТУРН, ПеречислениеСсылка.СтатусыОбработкиАктаПримененияСАТУРН, ПеречислениеСсылка.СтатусыОбработкиПланаПримененияСАТУРН, ПеречислениеСсылка.СтатусыОбработкиИмпортаПродукцииСАТУРН, ПеречислениеСсылка.СтатусыОбработкиАктаИнвентаризацииСАТУРН, ПеречислениеСсылка.СтатусыОбработкиЗапросаОстатковПартийСАТУРН, ПеречислениеСсылка.СтатусыОбработкиПроизводственнойОперацииСАТУРН - Рассчитанный статус.
Функция ВосстановитьСтатусДокументаПоДаннымПротоколаОбмена(ДокументСсылка, СообщениеПрерывания = Неопределено) Экспорт
	
	НаборПоДокументу = ИнтеграцияСАТУРН.РассчитатьСтатусДокументаПоДаннымПротоколаОбмена(ДокументСсылка,, СообщениеПрерывания);
	
	Возврат НаборПоДокументу[0].Статус;
	
КонецФункции

// Функция - Документы САТУРН по документу основанию
//
// Параметры:
//  ДокументОснование - ДокументСсылка - основание по которому надо получить документы САТУРН
// 
// Возвращаемое значение:
//  См. ИнтеграцияИС.ДокументыИСПоДокументуОснованию
//
Функция ДокументыСАТУРНПоДокументуОснованию(ДокументОснование) Экспорт
	
	ДокументыСАТУРН = ИнтеграцияИС.ДокументыИСПоДокументуОснованию(
		ДокументОснование,
		Метаданные.РегистрыСведений.СтатусыДокументовСАТУРН,
		,
		"И ИдентификаторСтроки = """"");
	
	Возврат ДокументыСАТУРН;
	
КонецФункции

// Возвращает имена документов САТУРН, основанием для которых может являться указанный документ.
//
// Параметры:
//   ДокументОснование - ОпределяемыйТип.ОснованиеСтатусыОформленияДокументовСАТУРН - документ-основание для документа САТУРН
//
// Возвращаемое значение:
//   Массив из Строка - имена документов САТУРН
//
Функция ИменаДокументовДляДокументаОснования(ДокументОснование) Экспорт
	
	Возврат РасчетСтатусовОформленияСАТУРН.ИменаДокументовДляДокументаОснования(ДокументОснование);
	
КонецФункции

Функция АрхивироватьДокументы(ДокументыКАрхивированию) Экспорт
	
	Возврат РегистрыСведений.СтатусыДокументовСАТУРН.Архивировать(ДокументыКАрхивированию);
	
КонецФункции

// Архивирует (убирает из интерфейса к обработке) записи из регистра по переданным документам.
//
// Параметры:
//   Основания - Массив Из ОпределяемыйТип.ОснованиеСтатусыОформленияДокументовСАТУРН - массив распоряжений
//   Документ  - ОпределяемыйТип.ДокументыСАТУРНПоддерживающиеСтатусыОформления - документ, данные по которому
//                                                                              необходимо архивировать.
// Возвращаемое значение:
//   См. РегистрыСведений.СтатусыОформленияДокументовСАТУРН.АрхивироватьРаспоряженияКОформлению.
Функция АрхивироватьРаспоряженияКОформлению(Основания, Документ) Экспорт
	
	Возврат РегистрыСведений.СтатусыОформленияДокументовСАТУРН.АрхивироватьРаспоряженияКОформлению(Основания, Документ);
	
КонецФункции

Функция ТекстНадписиПоляИнтеграцииВФормеДокументаОснования(Знач ДокументОснование) Экспорт
	
	ТекстНадписи = "";
	
	// Получим структуру вида ИмяДокументаСАТУРН - Статус
	СтатусыОформления = РегистрыСведений.СтатусыОформленияДокументовСАТУРН.СтатусыДокументовСАТУРНПоДокументуОснованию(ДокументОснование);
	
	Если НЕ ЗначениеЗаполнено(СтатусыОформления) Тогда
		Возврат ТекстНадписи;
	КонецЕсли;
	
	// Получим структуру вида ИмяДокументаСАТУРН - Массив(ДокументыСАТУРНДанногоВида)
	ДокументыСАТУРН = ДокументыСАТУРНПоДокументуОснованию(ДокументОснование);
	
	ТекстыНадписиПоДокументам = Новый Массив;
	
	Для Каждого КлючИЗначение Из СтатусыОформления Цикл
		
		МетаданныеДокумента = Метаданные.Документы[КлючИЗначение.Ключ];
		
		Если ИнтеграцияИС.РеквизитДокументОснованиеДокументаИС(МетаданныеДокумента).Тип.СодержитТип(ТипЗнч(ДокументОснование)) Тогда
			
			// Получим структуру с ключами "Представление, МассивДокументов, СтатусОформления, МетаданныеДокумента"
			Описание = ИнтеграцияСАТУРН.ОписаниеОформленныхДокументов(МетаданныеДокумента, ДокументОснование, ДокументыСАТУРН, СтатусыОформления);
			
			Если Описание = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			
			Если ТекстыНадписиПоДокументам.Количество() > 0 Тогда
				ТекстыНадписиПоДокументам.Добавить(", ");
			КонецЕсли;
			
			ТекстыНадписиПоДокументам.Добавить(Описание.ТекстНадписи);
			
		КонецЕсли;
		
	КонецЦикла;
	
	ТекстНадписи = Новый ФорматированнаяСтрока(ТекстыНадписиПоДокументам);
	Возврат ТекстНадписи;
	
КонецФункции

// Классифицирует текущий сеанс, как сеанс, запущенный в фоновом задании в клиент-серверном варианте, в остальных
// случаях, сеанс имеет ту же файловую систему на стороне сервера, что и основной сеанс.
//	
// Возвращаемое значение:
// 	Булево - Описание
Функция ЭтоФоновоеЗаданиеНаСервере() Экспорт
	
	Если ПолучитьТекущийСеансИнформационнойБазы().ПолучитьФоновоеЗадание() <> Неопределено
		И Не ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

Процедура ИзвлечьЛогЗапросовИзПараметровОбмена(АдресПараметровОбмена) Экспорт
	
	Если Не ЭтоАдресВременногоХранилища(АдресПараметровОбмена) Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыОбмена = ПолучитьИзВременногоХранилища(АдресПараметровОбмена);
	
	Если Не ЭтоАдресВременногоХранилища(ПараметрыОбмена.АдресДанныхЛогаЗапроса) Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеЛогаЗапросов = ПолучитьИзВременногоХранилища(ПараметрыОбмена.АдресДанныхЛогаЗапроса);
	
	Если ДанныеЛогаЗапросов = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеДляЗаписи = Новый Структура();
	ДанныеДляЗаписи.Вставить("ДанныеЛогаЗапросов", ДанныеЛогаЗапросов);
	
	ЛогированиеЗапросовСАТУРН.ДописатьВТекущийЛогДанныеИзФоновогоЗадания(ДанныеДляЗаписи);
	
	ПоместитьВоВременноеХранилище(Неопределено, ПараметрыОбмена.АдресДанныхЛогаЗапроса);
	
КонецПроцедуры

// Новая структура результатов обмена.
// 
// Возвращаемое значение:
//  Структура - Новая структура результатов обмена:
// * ДоступныеСертификаты - Неопределено -
// * ТребуетсяПодписание - Неопределено -
// * Изменения - Массив -
// * ДлительнаяОперация - Неопределено -
// * Ожидать - Неопределено -
// * АдресВоВременномХранилище - Неопределено -
// * ИзвлекатьДанныеЛогаЗапросов - Булево -
Функция НоваяСтруктураРезультатовОбмена() Экспорт
	
	ВозвращаемоеЗначение = Новый Структура;
	ВозвращаемоеЗначение.Вставить("Изменения",                      Новый Массив);
	ВозвращаемоеЗначение.Вставить("ДлительнаяОперация",             Неопределено);
	ВозвращаемоеЗначение.Вставить("Ожидать",                        Неопределено);
	ВозвращаемоеЗначение.Вставить("АдресВоВременномХранилище",      Неопределено);
	ВозвращаемоеЗначение.Вставить("АдресДанныхЛогаЗапроса",         Неопределено);
	ВозвращаемоеЗначение.Вставить(
		"ИзвлекатьДанныеЛогаЗапросов",
		ОбщегоНазначенияИСВызовСервера.ЭтоФоновоеЗаданиеНаСервере());
		
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

Функция ДанныеАдресаПоАдресуXML(АдресXML, АдресПредставление) Экспорт
	
	// ДополнительныеПараметры - Структура - параметры контактной информации. 
	//    * БезПредставлений - Булево - Если Истина, то поле представления адреса будет отсутствовать.
	//    * КодыКЛАДР - Булево - Если Истина, то возвращает структуру с кодами КЛАДР по всем частям адреса.
	//    * ПолныеНаименованияСокращений - Булево - Если Истина, то возвращает полное наименование адресных объектов.
	//    * НаименованиеВключаетСокращение - Булево - Если Истина, то поля содержат сокращениям в наименованиях адресных объектов.
	ДополнительныеПараметры = Новый Структура("КодыКЛАДР", Истина);
	
	СведенияОбАдресе = РаботаСАдресами.СведенияОбАдресе(АдресXML, ДополнительныеПараметры);
	
	Возврат СведенияОбАдресе;
	
КонецФункции

Функция МестаХраненияОрганизацииСАТУРН(ОрганизацияСАТУРН, ПомеченныеНаУдаление = Ложь) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Организация",          ОрганизацияСАТУРН);
	Запрос.УстановитьПараметр("ПомеченныеНаУдаление", ПомеченныеНаУдаление);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	МестаХраненияСАТУРН.МестоХранения КАК МестоХранения
	|ИЗ
	|	Справочник.КлассификаторОрганизацийСАТУРН.МестаХранения КАК МестаХраненияСАТУРН
	|ГДЕ
	|	МестаХраненияСАТУРН.Ссылка = &Организация
	|	И (&ПомеченныеНаУдаление ИЛИ НЕ МестаХраненияСАТУРН.МестоХранения.ПометкаУдаления)";
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("МестоХранения");
	
КонецФункции

// Функция определяет признак "Сопоставлено с организацией ИБ" по данным организации САТУРН.
// Параметры:
// 	ОрганизацияСАТУРН - СправочникСсылка.КлассификаторОрганизацийСАТУРН - организация САТУРН.
//
// Возвращаемое значение:
//  Структура:
//	* Сопоставлено - Булево - Истина, если организация САТУРН сопоставлена с организацией.
//  * Организация  - Неопределено, ОпределяемыйТип.Организация - сопоставленная организация
Функция ОрганизацияСАТУРНСопоставленаСОрганизациейИБ(ОрганизацияСАТУРН) Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("Сопоставлено", Ложь);
	Результат.Вставить("Организация",  Неопределено);
	
	ЗначенияСопоставлений = Справочники.КлассификаторОрганизацийСАТУРН.ОрганизацииКонтрагентыПоКлассификаторамСАТУРН(
		ОрганизацияСАТУРН);
	
	СвязанноеЗначение = ЗначенияСопоставлений.Получить(ОрганизацияСАТУРН);
	Если СвязанноеЗначение <> Неопределено И ЗначениеЗаполнено(СвязанноеЗначение.Организация) Тогда
		Результат.Сопоставлено = Истина;
		Результат.Организация = СвязанноеЗначение.Организация;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Возвращает параметры для создания номенклатуры.
//
// Параметры:
//   ПАТ        - СправочникСсылка.КлассификаторПАТСАТУРН        - ПАТ.
//
// Возвращаемое значение:
//   Структура - Структура со свойствами:
//    * НаименованиеНоменклатурыСАТУРН - Неопределено,
//                                       ОпределяемыйТип.СтрокаСАТУРН - Наименование номенклатуры.
Функция ПараметрыСозданияНоменклатуры(ПАТ) Экспорт
	
	ПараметрыНоменклатуры = Новый Структура;
	ПараметрыНоменклатуры.Вставить("НаименованиеНоменклатурыСАТУРН");
	
	Если Не ЗначениеЗаполнено(ПАТ) Тогда
		
		Возврат ПараметрыНоменклатуры;
		
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	КлассификаторПАТСАТУРН.Наименование КАК Наименование
	|ИЗ
	|	Справочник.КлассификаторПАТСАТУРН КАК КлассификаторПАТСАТУРН
	|ГДЕ
	|	КлассификаторПАТСАТУРН.Ссылка = &ПАТ";
	
	Запрос.УстановитьПараметр("ПАТ", ПАТ);
	
	РезультатЗапроса = Запрос.Выполнить().Выбрать();
	
	Если РезультатЗапроса.Следующий() Тогда
		ПараметрыНоменклатуры.НаименованиеНоменклатурыСАТУРН = РезультатЗапроса.Наименование;
	КонецЕсли;
	
	Возврат ПараметрыНоменклатуры;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Заполняет структуру реквизитов по организациям контрагентам с учетом обособленных подразделений.
// Заполняемая колонка в таблице - РеквизитыОрганизацииКонтрагента (исходящий).
// Параметры:
//  ТаблицаОрганизацияКонтрагент - см. ИнтеграцияСАТУРН.НоваяТаблицаОрганизацияКонтрагент
Процедура РеквизитыОрганизацийКонтрагентов(ТаблицаОрганизацияКонтрагент) Экспорт
	
	Если ТаблицаОрганизацияКонтрагент.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ИнтеграцияСАТУРНПереопределяемый.ПриОпределенииРеквизитовОрганизацийКонтрагентов(ТаблицаОрганизацияКонтрагент);
	
КонецПроцедуры

Функция РеквизитыПартии(Партия, Реквизиты) Экспорт
	
	Возврат ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Партия, Реквизиты);
	
КонецФункции

// Данные выбора идентификации товара партии.
// 
// Параметры:
//  ПараметрыИдентификации - см. ИнтеграцияСАТУРНКлиентСервер.ПараметрыИдентификацииТовараПартии
// 
// Возвращаемое значение:
//  Структура:
// * ИдентификаторыПартии - СписокЗначений из Строка - Идентификаторы партии
Функция ДанныеИдентификацииТовараПартии(ПараметрыИдентификации) Экспорт
	
	ВозвращаемоеЗначение = Новый Структура();
	ВозвращаемоеЗначение.Вставить("ИдентификаторыПартии", Новый СписокЗначений());
	
	ИнтеграцияСАТУРНПереопределяемый.ПриЗаполненииДанныхИдентификацииТовараПартии(
		ПараметрыИдентификации,
		ВозвращаемоеЗначение.ИдентификаторыПартии);
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

#КонецОбласти