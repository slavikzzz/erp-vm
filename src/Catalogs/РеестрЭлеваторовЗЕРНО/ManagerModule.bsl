#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

// Возвращает реквизиты объекта, которые не рекомендуется редактировать
// с помощью обработки группового изменения реквизитов.
//
// Возвращаемое значение:
//  Массив из Строка
//
Функция РеквизитыНеРедактируемыеВГрупповойОбработке() Экспорт
	
	Результат = Новый Массив;
	Результат.Добавить("Идентификатор");
	Возврат Результат;
	
КонецФункции

// Конец СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

// ТехнологияСервиса.ВыгрузкаЗагрузкаДанных

// Возвращает реквизиты справочника, которые образуют естественный ключ
// для элементов справочника.
//
// Возвращаемое значение:
//  Массив из Строка - массив имен реквизитов, образующих естественный ключ.
//
Функция ПоляЕстественногоКлюча() Экспорт
	
	Результат = Новый Массив();
	Результат.Добавить("Идентификатор");
	Возврат Результат;
	
КонецФункции

// Конец ТехнологияСервиса.ВыгрузкаЗагрузкаДанных

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ОбработкаСообщений

Функция ВыполнитьЗапросВСервис(ЭлементОчереди, ПараметрыОбмена) Экспорт
	
	ДанныеОбработки = Новый Структура;
	ДанныеОбработки.Вставить("РезультатОтправкиЗапроса", Неопределено);
	ДанныеОбработки.Вставить("ЗапросОтправлен",          Ложь);
	ДанныеОбработки.Вставить("ОтветПолучен",             Ложь);
	ДанныеОбработки.Вставить("КодСостояния",             Неопределено);
	ДанныеОбработки.Вставить("Объект",                   Неопределено);
	ДанныеОбработки.Вставить("ИдентификаторЗаявки",      Неопределено);
	ДанныеОбработки.Вставить("ТекстОшибки",              "");
	ДанныеОбработки.Вставить("ЭтоОбработаннаяОшибка",    Ложь);
	ДанныеОбработки.Вставить("СтатусОбработки",          Перечисления.СтатусыОбработкиСообщенийЗЕРНО.ЗаявкаВыполнена);
	ДанныеОбработки.Вставить("Операция",                 ЭлементОчереди.Операция);
	ДанныеОбработки.Вставить("Организация",              ЭлементОчереди.Организация);
	ДанныеОбработки.Вставить("ТекущееДействие",          Перечисления.ДействиеССообщениемЗЕРНО.ПолучениеРезультата);
	
	ПараметрыЗапроса = ЭлементОчереди.РеквизитыИсходящегоСообщения.ПараметрыЗапроса;
	
	РезультатОтправкиЗапроса = Новый Структура;
	РезультатОтправкиЗапроса.Вставить("ПараметрыОтправкиHTTPЗапросов", Неопределено);
	РезультатОтправкиЗапроса.Вставить("HTTPМетод",                     "GET");
	РезультатОтправкиЗапроса.Вставить("HTTPЗапрос",                    Неопределено);
	РезультатОтправкиЗапроса.Вставить("HTTPОтвет",                     Новый Структура);
	РезультатОтправкиЗапроса.Вставить("ТекстОшибки",                   Неопределено);
	РезультатОтправкиЗапроса.HTTPОтвет.Вставить("Тело",         ПараметрыЗапроса.ДанныеРеестраЭлеваторовXML);
	РезультатОтправкиЗапроса.HTTPОтвет.Вставить("КодСостояния", Неопределено);
	РезультатОтправкиЗапроса.HTTPОтвет.Вставить("Заголовки",    Новый Соответствие());
	РезультатОтправкиЗапроса.HTTPОтвет.Заголовки.Вставить("Date", ТекущаяДатаСеанса());
	
	ДанныеОбработки.РезультатОтправкиЗапроса = РезультатОтправкиЗапроса;
	
	ПрочитатьСодержаниеФайлаКлассификатора(ПараметрыЗапроса.ДанныеРеестраЭлеваторовXML, ДанныеОбработки, ПараметрыОбмена);
	
	ИнтеграцияЗЕРНОСлужебный.ДобавитьВПротоколОбмена(ЭлементОчереди, ДанныеОбработки, ПараметрыОбмена);
	
	Если ДанныеОбработки.Объект = Неопределено Тогда
		ДанныеОбработки.СтатусОбработки = Перечисления.СтатусыОбработкиСообщенийЗЕРНО.Ошибка;
		ДанныеОбработки.ТекстОшибки = НСтр(
			"ru = 'Внутренняя ошибка. Корневой узел загрузки реестра элеваторов не определен';
			|en = 'Внутренняя ошибка. Корневой узел загрузки реестра элеваторов не определен'");
		Возврат ДанныеОбработки;
	КонецЕсли;
	
	Возврат ДанныеОбработки;
	
КонецФункции

Процедура ПрочитатьСодержаниеФайлаКлассификатора(СожержаниеФайла, ДанныеОбработки, ПараметрыОбмена)
	
	ОбъектXDTO = РаботаСXMLИС.ПроизвольныйОбъектXDTOПоТекстуСообщенияXML(СожержаниеФайла);
	ПараметрыОбмена.ПараметрыПреобразования = ИнтеграцияЗЕРНОСлужебный.ПараметрыПреобразования(ПараметрыОбмена.ПараметрыОптимизации);
	
	ПространстваИмен = Метаданные.ПакетыXDTO.РеестрЭлеваторовЗЕРНО.ПространствоИмен;
	ПреобразованныйОбъектXDTO = РаботаСXMLИС.ОбъектXDTOПоИмениСвойства(ПространстваИмен, "elevators");
	
	ИнтеграцияЗЕРНОСлужебный.ПреобразоватьПроизвольныйОбъектXDTOВОбъектXDTO(
		ОбъектXDTO, ПреобразованныйОбъектXDTO,
		ПараметрыОбмена.ПараметрыПреобразования,
		ПараметрыОбмена.ПараметрыОптимизации.ВерсияAPI,
		ПараметрыОбмена.ПараметрыОптимизации.ВерсияСервисаAPI);
	
	КорневыеУзлы = Новый Массив();
	
	ИнтеграцияЗЕРНОСлужебный.ОбъектXDTOВСтруктуру(
		ПреобразованныйОбъектXDTO,
		ПараметрыОбмена.ПараметрыПреобразования,
		КорневыеУзлы);
	
	Для Каждого ДанныеУзла Из КорневыеУзлы Цикл
		ИмяСвойства = ДанныеУзла.Параметры.ИмяПоляРезультат;
		ДанныеОбработки.Вставить(ИмяСвойства, ДанныеУзла.Значение);
	КонецЦикла;
	
КонецПроцедуры

Процедура ОбработкаЗагрузкиПолученныхДанных(ЭлементОчереди, ПараметрыОбмена, ПолученныеДанные, ИзмененныеОбъекты, ПрочитаноВерсиейAPI) Экспорт
	
	Блокировка = Новый БлокировкаДанных();
	Блокировка.Добавить(Метаданные.Справочники.РеестрЭлеваторовЗЕРНО.ПолноеИмя());
	
	НачатьТранзакцию();
	
	Попытка
		
		Блокировка.Заблокировать();
		
		ИнтеграцияЗЕРНОСлужебный.СсылкиПоИдентификаторам(ПараметрыОбмена);
		
		Для Каждого СтрокаДанных Из ПолученныеДанные.elevator Цикл
			
			ДанныеОрганизации = ДанныеОрганизацииПоЗаполенномуСвойству(СтрокаДанных, ПараметрыОбмена);
			Если Не ЗначениеЗаполнено(ДанныеОрганизации.Идентификатор) Тогда
				Продолжить;
			КонецЕсли;
			
			Элеватор = ЗагрузитьЭлеватор(ДанныеОрганизации, ПараметрыОбмена);
			
			Если Элеватор <> Неопределено Тогда
				ИзмененныеОбъекты.Добавить(Элеватор);
			КонецЕсли;
			
		КонецЦикла;
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		ИнфрмацияОшибки = ИнформацияОбОшибке();
		
		ВызватьИсключение СтрШаблон(
			НСтр("ru = 'Ошибка загрузки реестра элеваторов ФГИС ""Зерно"" %1';
				|en = 'Ошибка загрузки реестра элеваторов ФГИС ""Зерно"" %1'"),
			ОбработкаОшибок.КраткоеПредставлениеОшибки(ИнфрмацияОшибки));
		
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти

#Область Сообщения

// Сообщение к передаче XML
//
// Параметры:
//  СсылкаНаОбъект          - СправочникСсылка.РеестрПартийЗЕРНО - Ссылка на объект.
//  ДальнейшееДействие      - ПеречислениеСсылка.ДальнейшиеДействияПоВзаимодействиюЗЕРНО - дальнейшее действие.
//  ДополнительныеПараметры - Структура, Неопределено - Дополнительные параметры.
// Возвращаемое значение:
//  Массив из см. ИнтеграцияЗЕРНОСлужебный.СтруктураСообщенияXML - Сообщения к передаче.
//
Функция СообщениеКПередачеXML(СсылкаНаОбъект, ДальнейшееДействие, ДополнительныеПараметры) Экспорт
	
	Если ДальнейшееДействие = Перечисления.ДальнейшиеДействияПоВзаимодействиюЗЕРНО.ПередайтеДанные Тогда
		Возврат СообщенияЗагрузкиРеестраЭлеваторов(
			СсылкаНаОбъект,
			ДополнительныеПараметры.ПараметрыОбработкиДокумента.Организация,
			Перечисления.ВидыПродукцииИС.Зерно,
			ДополнительныеПараметры.ПараметрыОбработкиДокумента.ПараметрыЗапроса.ДанныеРеестраЭлеваторовXML);
	КонецЕсли;
	
КонецФункции

// Сообщение загрузки партий
//
// Параметры:
//  СсылкаНаОбъект - СправочникСсылка.РеестрПартийЗЕРНО - Ссылка на объект.
//  Организация    - ОпределяемыйТип.Организация        - Организация.
//  ВидПродукции   - ПеречислениеСсылка.ВидыПродукцииИС - ВидПродукции.
// Возвращаемое значение:
//  Массив из См. ИнтеграцияЗЕРНОСлужебный.СтруктураСообщенияXML
//
Функция СообщенияЗагрузкиРеестраЭлеваторов(СсылкаНаОбъект, Организация, ВидПродукции, ДанныеРеестраЭлеваторовXML)
	
	СообщенияXML = Новый Массив();
	
	Операция = Перечисления.ВидыОперацийЗЕРНО.ЗапросРеестраЭлеваторов;
	
	СообщениеXML = ИнтеграцияЗЕРНОСлужебный.СтруктураСообщенияXML();
	СообщениеXML.Операция                  = Операция;
	СообщениеXML.ТипСообщения              = Перечисления.ТипыЗапросовИС.Исходящий;
	СообщениеXML.Версия                    = 1;
	СообщениеXML.Организация               = Организация;
	СообщениеXML.ПараметрыЗапроса          = Новый Структура();
	СообщениеXML.ВидПродукции              = ВидПродукции;
	СообщениеXML.ТребуетсяПодписание       = Ложь;
	СообщениеXML.СсылкаНаОбъект            = ПустаяСсылка();
	СообщениеXML.ПараметрыЗапроса.Вставить("ДанныеРеестраЭлеваторовXML", ДанныеРеестраЭлеваторовXML);
	
	СообщенияXML.Добавить(СообщениеXML);
	
	Возврат СообщенияXML;
	
КонецФункции

#КонецОбласти

#Область ПоискСсылок

Функция Элеватор(ЗначениеИдентификатора, Организация, Подразделение, ПараметрыОбмена, Наименование = Неопределено) Экспорт
	
	Идентификатор = Лев(ЗначениеИдентификатора, 255);
	
	ИмяТаблицы = Метаданные.Справочники.РеестрЭлеваторовЗЕРНО.ПолноеИмя();
	
	СправочникСсылка = ИнтеграцияЗЕРНОСлужебный.СсылкаПоИдентификатору(ПараметрыОбмена, ИмяТаблицы, Идентификатор);
	
	Если ЗначениеЗаполнено(СправочникСсылка) Тогда
		ИнтеграцияЗЕРНОСлужебный.ОбновитьСсылку(ПараметрыОбмена, ИмяТаблицы, Идентификатор, СправочникСсылка);
	Иначе
		
		ИнтеграцияЗЕРНОСлужебный.ПроверитьВозможностьСозданияНеразделенныхДанных(Идентификатор, ПустаяСсылка(), ПараметрыОбмена);
		
		Блокировка = Новый БлокировкаДанных();
		ЭлементБлокировки = Блокировка.Добавить(ИмяТаблицы);
		ЭлементБлокировки.УстановитьЗначение("Идентификатор", Идентификатор);
		
		ТранзакцияЗафиксирована = Истина;
		
		НачатьТранзакцию();
		
		Попытка
			
			Блокировка.Заблокировать();
			
			СправочникСсылка = ИнтеграцияЗЕРНОСлужебный.СсылкаПоИдентификатору(ПараметрыОбмена, ИмяТаблицы, Идентификатор);
			
			Если Не ЗначениеЗаполнено(СправочникСсылка) Тогда
				СправочникСсылка = СоздатьЭлеватор(Идентификатор, Наименование);
				ИнтеграцияЗЕРНОСлужебный.ДобавитьКЗагрузке(ПараметрыОбмена, ИмяТаблицы, Идентификатор,, Организация, Подразделение);
			КонецЕсли;
			
			ЗафиксироватьТранзакцию();
			
		Исключение
			
			ОтменитьТранзакцию();
			
			ТранзакцияЗафиксирована = Ложь;
			
			ТекстОшибки = СтрШаблон(
				НСтр("ru = 'Ошибка при создании справочника %1 с идентификатором %2:
				           |%3';
				           |en = 'Ошибка при создании справочника %1 с идентификатором %2:
				           |%3'"),
				Метаданные.Справочники.РеестрМестФормированияПартийЗЕРНО.Синоним,
				Идентификатор,
				ОбработкаОшибок.КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
			
			ТекстОшибкиПодробно = СтрШаблон(
				НСтр("ru = 'Ошибка при создании справочника %1 с идентификатором %2:
				           |%3';
				           |en = 'Ошибка при создании справочника %1 с идентификатором %2:
				           |%3'"),
				Метаданные.Справочники.РеестрМестФормированияПартийЗЕРНО.Синоним,
				Идентификатор,
				ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			
			ОбщегоНазначенияИСВызовСервера.ЗаписатьОшибкуВЖурналРегистрации(
				ТекстОшибкиПодробно,
				НСтр("ru = 'Работа с реестром элеваторов';
					|en = 'Работа с реестром элеваторов'", ОбщегоНазначения.КодОсновногоЯзыка()));
			
			ВызватьИсключение ТекстОшибки;
			
		КонецПопытки;
		
		Если ТранзакцияЗафиксирована Тогда
			ИнтеграцияЗЕРНОСлужебный.ОбновитьСсылку(ПараметрыОбмена, ИмяТаблицы, Идентификатор, СправочникСсылка);
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат СправочникСсылка;
	
КонецФункции

Функция СоздатьЭлеватор(Идентификатор, Наименование = Неопределено)
	
	СправочникОбъект = СоздатьЭлемент();
	СправочникОбъект.Идентификатор         = Идентификатор;
	СправочникОбъект.ТребуетсяЗагрузка     = Истина;
	СправочникОбъект.ОбменДанными.Загрузка = Истина;
	
	Если ЗначениеЗаполнено(Наименование) Тогда
		СправочникОбъект.Наименование = Наименование;
	Иначе
		СправочникОбъект.Наименование = СтрШаблон(НСтр("ru = '%1 <Требуется загрузка>';
														|en = '%1 <Требуется загрузка>'"), Идентификатор);
	КонецЕсли;
	
	СправочникОбъект.Записать();
	
	Возврат СправочникОбъект.Ссылка;
	
КонецФункции

Функция ЗагрузитьЭлеватор(ДанныеПоСвойству, ПараметрыОбмена, СуществующийОбъект = Неопределено, ТребуетсяПоиск = Истина) Экспорт
	
	ЗаписьНового       = Ложь;
	МетаданныеЭлемента = Метаданные.Справочники.РеестрЭлеваторовЗЕРНО;
	Идентификатор      = ДанныеПоСвойству.Идентификатор;
	
	Если СуществующийОбъект = Неопределено Тогда
		
		СуществующийЭлемент = Неопределено;
		
		Если ТребуетсяПоиск Тогда
			СуществующийЭлемент = ИнтеграцияЗЕРНОСлужебный.СсылкаПоИдентификатору(
				ПараметрыОбмена,
				МетаданныеЭлемента.ПолноеИмя(),
				Идентификатор);
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(СуществующийЭлемент) Тогда
			ИнтеграцияЗЕРНОСлужебный.ПроверитьВозможностьСозданияНеразделенныхДанных(Идентификатор, ПустаяСсылка(), ПараметрыОбмена);
			СуществующийОбъект = СоздатьЭлемент();
			СуществующийОбъект.Идентификатор  = Идентификатор;
			СуществующийОбъект.ТипОрганизации = ДанныеПоСвойству.ТипОрганизации;
			ЗаписьНового = Истина;
		Иначе
			СуществующийОбъект = СуществующийЭлемент.ПолучитьОбъект();
		КонецЕсли;
		
	КонецЕсли;
	
	Если Не ЗаписьНового Тогда
		СуществующийОбъект.Заблокировать();
	КонецЕсли;
	
	ЭлементДанных = ДанныеПоСвойству.Данные;
	
	Если СуществующийОбъект.ТипОрганизации = Перечисления.ТипыОрганизацийЗЕРНО.ЮридическоеЛицо Тогда
		СуществующийОбъект.Наименование = ЭлементДанных.Name;
		СуществующийОбъект.ИНН          = ЭлементДанных.INN;
		СуществующийОбъект.КПП          = ЭлементДанных.KPP;
		СуществующийОбъект.ОГРН         = ЭлементДанных.OGRN;
	ИначеЕсли СуществующийОбъект.ТипОрганизации = Перечисления.ТипыОрганизацийЗЕРНО.ИндивидуальныйПредприниматель Тогда
		СуществующийОбъект.ИНН          = ЭлементДанных.INN;
		СуществующийОбъект.ОГРН         = ЭлементДанных.OGRN;
		СуществующийОбъект.Наименование = ЭлементДанных.Name;
	ИначеЕсли СуществующийОбъект.ТипОрганизации = Перечисления.ТипыОрганизацийЗЕРНО.Самозанятый Тогда
		СуществующийОбъект.ИНН          = ЭлементДанных.INN;
		СуществующийОбъект.Наименование = ЭлементДанных.Name;
	ИначеЕсли СуществующийОбъект.ТипОрганизации = Перечисления.ТипыОрганизацийЗЕРНО.ИностраннаяОрганизация Тогда
		СуществующийОбъект.Наименование = ЭлементДанных.Name;
		СуществующийОбъект.ИНН          = ЭлементДанных.INN;
		СуществующийОбъект.КПП          = ЭлементДанных.KPP;
	ИначеЕсли СуществующийОбъект.ТипОрганизации = Перечисления.ТипыОрганизацийЗЕРНО.ИностраннаяОрганизацияБезРегистрацииВРФ Тогда
		СуществующийОбъект.Наименование = ЭлементДанных.Name;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(СуществующийОбъект.Наименование) Тогда
		СуществующийОбъект.Наименование = НСтр("ru = '<Не указано>';
												|en = '<Не указано>'");
	КонецЕсли;
	
	СуществующийОбъект.МестаХранения.Очистить();
	СуществующийОбъект.УслугиЭлеватора.Очистить();
	
	СуществующийОбъект.ДействуетС      = Неопределено;
	СуществующийОбъект.ДействуетПо     = Неопределено;
	
	Если ЭлементДанных.elevatorInfo <> Неопределено Тогда
		
		СуществующийОбъект.ДействуетС  = ЭлементДанных.elevatorInfo.startDate;
		СуществующийОбъект.ДействуетПо = ЭлементДанных.elevatorInfo.endDate;
		
		Если ЭлементДанных.elevatorInfo.services <> Неопределено
			И ЭлементДанных.elevatorInfo.services.service <> Неопределено Тогда
			Для Каждого УслугаЭлеватора Из ЭлементДанных.elevatorInfo.services.service Цикл
				НоваяСтрока = СуществующийОбъект.УслугиЭлеватора.Добавить();
				НоваяСтрока.УслугаЭлеватора = УслугаЭлеватора;
			КонецЦикла;
		КонецЕсли;
		
	КонецЕсли;
	
	Для Каждого СтрокаТаблицы Из ЭлементДанных.elevatorSiteList Цикл
		
		НоваяСтрока = СуществующийОбъект.МестаХранения.Добавить();
		НоваяСтрока.КадастровыйНомер  = СтрокаТаблицы.cadastralNumber;
		НоваяСтрока.ТипЗернохранилища = СтрокаТаблицы.granaryType;
		Если ЗначениеЗаполнено(СтрокаТаблицы.address) Тогда
			НоваяСтрока.МестоХранения = СтрокаТаблицы.address;
		КонецЕсли;
		
	КонецЦикла;
	
	СуществующийОбъект.ТребуетсяЗагрузка = Ложь;
	СуществующийОбъект.Записать();
	
	ИнтеграцияЗЕРНОСлужебный.ОбновитьСсылку(ПараметрыОбмена, МетаданныеЭлемента.ПолноеИмя(), Идентификатор, СуществующийОбъект.Ссылка);
	
	Возврат СуществующийОбъект.Ссылка;
	
КонецФункции

Функция ДанныеОрганизацииПоЗаполенномуСвойству(ЭлементДанных, ПараметрыОбмена, Сопоставление = Неопределено)
	
	ВозвращаемоеЗначение = Новый Структура();
	ВозвращаемоеЗначение.Вставить("ТипОрганизации", Неопределено);
	ВозвращаемоеЗначение.Вставить("Данные",         Неопределено);
	ВозвращаемоеЗначение.Вставить("Идентификатор",  Неопределено);
	ВозвращаемоеЗначение.Вставить("Сопоставление",  Сопоставление);
	
	Для Каждого КлючИЗначение Из ПараметрыОбмена.ПараметрыПреобразования.ТипыОрганизацийПоИменамСвойств Цикл
		ПараметрыТипа = КлючИЗначение.Значение;
		Если ЭлементДанных.Свойство(ПараметрыТипа.ИмяПоля, ВозвращаемоеЗначение.Данные)
			И ЗначениеЗаполнено(ВозвращаемоеЗначение.Данные) Тогда
			ВозвращаемоеЗначение.ТипОрганизации = Перечисления.ТипыОрганизацийЗЕРНО.ТипОрганизацииПоРеквизитам(
				ЭлементДанных.subject);
			ВозвращаемоеЗначение.Данные = ЭлементДанных[ПараметрыТипа.ИмяПоля];
			ВозвращаемоеЗначение.Данные.Вставить("elevatorSiteList",   ЭлементДанных.elevatorSiteList);
			ВозвращаемоеЗначение.Данные.Вставить("elevatorInfo",       ЭлементДанных.elevatorInfo);
			ВозвращаемоеЗначение.Идентификатор = Лев(ЭлементДанных.registrationNumber, 255);
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

#КонецОбласти

// см. РаботаСКлассификаторамиПереопределяемый.ПриЗагрузкеКлассификатора
Процедура ПриЗагрузкеКлассификатора(Идентификатор, Версия, Адрес, Обработан, ДополнительныеПараметры, ФайлыКлассификатора) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ПараметрыОбмена = ИнтеграцияЗЕРНО.ПараметрыОбмена();
	ПараметрыОбмена.ПараметрыПреобразования = ИнтеграцияЗЕРНОСлужебный.ПараметрыПреобразования(ПараметрыОбмена.ПараметрыОптимизации);
	
	ДанныеОбработки = Новый Структура("Объект");
	
	Попытка
		
		Для Каждого ИмяФайла Из ФайлыКлассификатора Цикл
			ЧтениеТекста = Новый ЧтениеТекста(ИмяФайла);
			ПрочитатьСодержаниеФайлаКлассификатора(ЧтениеТекста.Прочитать(), ДанныеОбработки, ПараметрыОбмена);
			ЧтениеТекста.Закрыть();
		КонецЦикла;
		
		Если ДанныеОбработки.Объект = Неопределено Тогда
			ТекстОшибки = НСтр("ru = 'Внутренняя ошибка. Корневой узел загрузки реестра элеваторов не определен';
								|en = 'Внутренняя ошибка. Корневой узел загрузки реестра элеваторов не определен'");
			ОбщегоНазначенияИСВызовСервера.ЗаписатьОшибкуВЖурналРегистрации(
				ТекстОшибки,
				НСтр("ru = 'Работа с классификаторами';
					|en = 'Работа с классификаторами'", ОбщегоНазначения.КодОсновногоЯзыка()));
			ВызватьИсключение ТекстОшибки
		Иначе
			ИзмененныеОбъекты = Новый Массив();
			ОбработкаЗагрузкиПолученныхДанных(
				Неопределено, ПараметрыОбмена, ДанныеОбработки.Объект, ИзмененныеОбъекты, ПараметрыОбмена.ПараметрыПреобразования.ВерсияAPI);
		КонецЕсли;
		
		Обработан = Истина;
	
	Исключение
		
		ТекстОшибки = СтрШаблон(
			НСтр("ru = 'Ошибка при обновлении реестра элеваторов ФГИС ""Зерно"":
			           |%1';
			           |en = 'Ошибка при обновлении реестра элеваторов ФГИС ""Зерно"":
			           |%1'"),
			ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		
		ТекстОписанияОшибки = СтрШаблон(
			НСтр("ru = 'Ошибка при обновлении реестра элеваторов ФГИС ""Зерно"":
			           |%1';
			           |en = 'Ошибка при обновлении реестра элеваторов ФГИС ""Зерно"":
			           |%1'"),
			ОбработкаОшибок.КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
		
		ОбщегоНазначенияИСВызовСервера.ЗаписатьОшибкуВЖурналРегистрации(
			ТекстОшибки,
			НСтр("ru = 'Работа с классификаторами';
				|en = 'Работа с классификаторами'", ОбщегоНазначения.КодОсновногоЯзыка()));
		
		ВызватьИсключение ТекстОписанияОшибки;
		
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
