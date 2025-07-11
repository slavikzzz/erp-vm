#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПереопределяемаяНастройкаДополненияВыгрузки

// Предназначена для настройки вариантов интерактивной настройки выгрузки по сценарию узла.
// Для настройки необходимо установить значения свойств параметров в необходимые значения.
//
// Используется для контроля режимов работы помощника интерактивного обмена данными.
//
// Параметры:
//     Получатель - ПланОбменаСсылка - Узел, для которого производится настройка
//     Параметры  - Структура        - Параметры для изменения. Содержит поля:
//
//         ВариантБезДополнения - Структура     - настройки типового варианта "Не добавлять".
//                                                Содержит поля:
//             Использование - Булево - флаг разрешения использования варианта. По умолчанию Истина.
//             Порядок       - Число  - порядок размещения варианта на форме помощника, сверху вниз. По умолчанию 1.
//             Заголовок     - Строка - позволяет переопределить название типового варианта.
//             Пояснение     - Строка - позволяет переопределить текст пояснения варианта для пользователя.
//
//         ВариантВсеДокументы - Структура      - настройки типового варианта "Добавить все документы за период".
//                                                Содержит поля:
//             Использование - Булево - флаг разрешения использования варианта. По умолчанию Истина.
//             Порядок       - Число  - порядок размещения варианта на форме помощника, сверху вниз. По умолчанию 2.
//             Заголовок     - Строка - позволяет переопределить название типового варианта.
//             Пояснение     - Строка - позволяет переопределить текст пояснения варианта для пользователя.
//
//         ВариантПроизвольныйОтбор - Структура - настройки типового варианта "Добавить данные с произвольным отбором".
//                                                Содержит поля:
//             Использование - Булево - флаг разрешения использования варианта. По умолчанию Истина.
//             Порядок       - Число  - порядок размещения варианта на форме помощника, сверху вниз. По умолчанию 3.
//             Заголовок     - Строка - позволяет переопределить название типового варианта.
//             Пояснение     - Строка - позволяет переопределить текст пояснения варианта для пользователя.
//
//         ВариантДополнительно - Структура     - настройки дополнительного варианта по сценарию узла.
//                                                Содержит поля:
//             Использование            - Булево            - флаг разрешения использования варианта. По умолчанию Ложь.
//             Порядок                  - Число             - порядок размещения варианта на форме помощника, сверху
//                                                            вниз. По умолчанию 4.
//             Заголовок                - Строка            - название варианта для отображения на форме.
//             ИмяФормыОтбора           - Строка            - Имя формы, вызываемой для редактирования настроек.
//             ЗаголовокКомандыФормы    - Строка            - Заголовок для отрисовки на форме команды открытия формы настроек.
//             ИспользоватьПериодОтбора - Булево            - флаг того, что необходим общий отбор по периоду. По
//                                                            умолчанию Ложь.
//             ПериодОтбора             - СтандартныйПериод - значение периода общего отбора, предлагаемого по умолчанию.
//
//             Отбор                    - ТаблицаЗначений   - содержит строки с описанием подробных отборов по сценарию узла.
//                                                            Содержит колонки:
//                 ПолноеИмяМетаданных - Строка                - полное имя метаданных регистрируемого объекта, отбор
//                                                               которого описывает строка. Например
//                                                               "Документ._ДемоПоступлениеТоваров". Можно  использовать
//                                                               специальные значения "ВсеДокументы" и "ВсеСправочники"
//                                                               для отбора соответственно всех документов и всех
//                                                               справочников, регистрирующихся на узле Получатель.
//                 ВыборПериода        - Булево                - флаг того, что данная строка описывает отбор с общим периодом.
//                 Период              - СтандартныйПериод     - значение периода общего отбора для метаданных строки,
//                                                               предлагаемого по умолчанию.
//                 Отбор               - ОтборКомпоновкиДанных - отбор по умолчанию. Поля отбора формируются в
//                                                               соответствии с общим правилами формирования полей
//                                                               компоновки. Например, для указания отбора по реквизиту
//                                                               документа "Организация", необходимо использовать поле "Ссылка.Организация".
//
//
//     Если для всех вариантов флаги разрешения использования установлены в Ложь, то страница дополнения выгрузки в помощнике
//     интерактивного обмена данными будет пропущена и дополнительная регистрация объектов производится не будет.
//     Например, инициализация вида:
//
//          Параметры.ВариантВсеДокументы.Использование      = Ложь;
//          Параметры.ВариантБезДополнения.Использование     = Ложь;
//          Параметры.ВариантПроизвольныйОтбор.Использование = Ложь;
//          Параметры.ВариантДополнительно.Использование     = Ложь;
//
//     Приведет к тому, что шаг дополнения выгрузки будет полностью пропущен.
//
Процедура НастроитьИнтерактивнуюВыгрузку(Получатель, Параметры) Экспорт
	
	РеквизитыУзлаОбмена = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Получатель, "РежимВыгрузкиДокументов, РежимВыгрузкиСправочников");
	
	Если РеквизитыУзлаОбмена.РежимВыгрузкиДокументов = Перечисления.РежимыВыгрузкиОбъектовОбмена.НеВыгружать 
		И РеквизитыУзлаОбмена.РежимВыгрузкиСправочников = Перечисления.РежимыВыгрузкиОбъектовОбмена.НеВыгружать Тогда
		
		Параметры.ВариантВсеДокументы.Использование      = Ложь;
		Параметры.ВариантБезДополнения.Использование     = Ложь;
		Параметры.ВариантПроизвольныйОтбор.Использование = Ложь;
		Параметры.ВариантДополнительно.Использование     = Ложь;
		
	Иначе
		
		// Отключаем вариант "ВариантВсеДокументы"
		
		Параметры.ВариантВсеДокументы.Использование      = Ложь;
		
		// Настраиваем вариант "Без дополнения" 
		Параметры.ВариантБезДополнения.Использование = Истина;
		Параметры.ВариантБезДополнения.Порядок       = 3;
		Параметры.ВариантБезДополнения.Заголовок     = НСтр("ru = 'Не добавлять документы к отправке';
															|en = 'Do not add documents to send'") 
			+ Символы.ПС 
			+ НСтр("ru = 'Отправлять только нормативно-справочную информацию, измененную с момента последней отправки';
					|en = 'Send only master data changed since the last sending'");
		
		// Настраиваем вариант "Произвольный отбор" 
		Параметры.ВариантПроизвольныйОтбор.Использование = Истина;
		Параметры.ВариантПроизвольныйОтбор.Порядок       = 2;
		
		ПравилаОтправкиДокументовПолучателя = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Получатель, "ПравилаОтправкиДокументов");
		
		Если ПравилаОтправкиДокументовПолучателя = "НеСинхронизировать" Тогда
			Параметры.ВариантПроизвольныйОтбор.Заголовок = НСтр("ru = 'Добавить справочники';
																|en = 'Add catalogs'");
		Иначе
			Параметры.ВариантПроизвольныйОтбор.Заголовок = НСтр("ru = 'Добавить произвольные справочники и документы';
																|en = 'Add arbitrary catalogs and documents'");
		КонецЕсли;
		
		Если Не ПравилаОтправкиДокументовПолучателя = "НеСинхронизировать" Тогда
			// Вычисляем и устанавливаем параметры сценария
			ПараметрыПоУмолчанию = ПараметрыВыгрузкиПоУмолчанию(Получатель);
			
			// Настраиваем вариант "Дополнительно" по сценарию узла
			Параметры.ВариантДополнительно.Использование            = Истина;
			Параметры.ВариантДополнительно.Порядок                  = 1;
			Параметры.ВариантДополнительно.Заголовок                = НСтр("ru = 'Отправить все документы';
																			|en = 'Send all documents'");
			Параметры.ВариантДополнительно.ИмяФормыОтбора           = "ОбщаяФорма.НастройкаВыгрузки";
			Параметры.ВариантДополнительно.ЗаголовокКомандыФормы    = НСтр("ru = 'Выбрать организации для отбора';
																			|en = 'Select companies to filter'");
			Параметры.ВариантДополнительно.ИспользоватьПериодОтбора = Истина;
			Параметры.ВариантДополнительно.ПериодОтбора             = ПараметрыПоУмолчанию.Период;
			
			// Добавляем строка настройки отбора 
			СтрокаОтбора = Параметры.ВариантДополнительно.Отбор.Добавить();
			СтрокаОтбора.ПолноеИмяМетаданных = "ВсеДокументы";
			СтрокаОтбора.ВыборПериода = Истина;
			СтрокаОтбора.Период       = ПараметрыПоУмолчанию.Период;
			СтрокаОтбора.Отбор        = ПараметрыПоУмолчанию.Отбор;
		Иначе
			Параметры.ВариантДополнительно.Использование            = Ложь;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Расчет параметров выгрузки по умолчанию.
//
// Параметры:
//     Получатель - ПланОбменаСсылка - Узел, для которого производится настройка.
//
// Возвращаемое значение - Структура - содержит поля:
//     ПредставлениеОтбора - Строка - текстовое описание отбора по умолчанию ;
//     Период              - СтандартныйПериод     - значение периода общего отбора по умолчанию;
//     Отбор               - ОтборКомпоновкиДанных - отбор.
//
Функция ПараметрыВыгрузкиПоУмолчанию(Получатель)
	
	Результат = Новый Структура;
	
	// Период по умолчанию
	Результат.Вставить("Период", Новый СтандартныйПериод);
	Результат.Период.Вариант = ВариантСтандартногоПериода.ПрошлыйМесяц;
	
	// Отбор по умолчанию и его представление
	КомпоновщикОтбора = Новый КомпоновщикНастроекКомпоновкиДанных;
	Результат.Вставить("Отбор", КомпоновщикОтбора.Настройки.Отбор);
	
	// Общее представление, период не включаем, так как в этом сценарии поле периода будет редактироваться отдельно.
	Результат.Вставить( "ПредставлениеОтбора", 
	                    СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
	                    НСтр("ru = 'Будут отправлены все документы за %1';
							|en = 'All documents for %1 will be sent'"),
	                    НРег(Строка(Результат.Период.Вариант))));
	
	Возврат Результат;
КонецФункции


// Возвращает представление отбора для варианта дополнения выгрузки по сценарию узла.
// См. описание "ВариантДополнительно" в процедуре "НастроитьИнтерактивнуюВыгрузку".
//
// Параметры:
//     Получатель - ПланОбменаСсылка - Узел, для которого определяется представление отбора
//     Параметры  - Структура        - Характеристики отбора. Содержит поля:
//         ИспользоватьПериодОтбора - Булево            - флаг того, что необходимо использовать общий отбор по периоду.
//         ПериодОтбора             - СтандартныйПериод - значение периода общего отбора.
//         Отбор                    - ТаблицаЗначений   - содержит строки с описанием подробных отборов по сценарию узла.
//                                                        Содержит колонки:
//                 ПолноеИмяМетаданных - Строка                - полное имя метаданных регистрируемого объекта, отбор
//                                                               которого описывает строка. Например
//                                                               "Документ._ДемоПоступлениеТоваров". Могут быть
//                                                               использованы специальные значения "ВсеДокументы" и
//                                                               "ВсеСправочники" для отбора соответственно всех
//                                                               документов и всех справочников, регистрирующихся на
//                                                               узле Получатель.
//                 ВыборПериода        - Булево                - флаг того, что данная строка описывает отбор с общим периодом.
//                 Период              - СтандартныйПериод     - значение периода общего отбора для метаданных строки.
//                 Отбор               - ОтборКомпоновкиДанных - поля отбора. Поля отбора формируются в соответствии с
//                                                               общим правилами формирования полей компоновки.
//                                                               Например, для указания отбора по реквизиту документа
//                                                               "Организация", будет использовано поле "Ссылка.Организация".
//
// Возвращаемое значение: 
//     Строка - описание отбора.
//
Функция ПредставлениеОтбораИнтерактивнойВыгрузки(Получатель, Параметры) Экспорт
	
	Если Параметры.ИспользоватьПериодОтбора Тогда
		Если ЗначениеЗаполнено(Параметры.ПериодОтбора) Тогда
			ОписаниеПериода = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'за период: %1';
					|en = 'for the period: %1'"), НРег(Параметры.ПериодОтбора));
		Иначе
			ДатаНачалаВыгрузки = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Получатель, "ДатаНачалаВыгрузкиДокументов");
			Если ЗначениеЗаполнено(ДатаНачалаВыгрузки) Тогда
				ОписаниеПериода = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'начиная с даты начала отправки документов: %1';
						|en = 'starting from the document sending date: %1'"), Формат(ДатаНачалаВыгрузки, "ДЛФ=DD"));
			Иначе
				ОписаниеПериода = НСтр("ru = 'за весь период учета';
										|en = 'for the entire accounting period'");
			КонецЕсли;
		КонецЕсли;
	Иначе
		ОписаниеПериода = "";
	КонецЕсли;
	
	СписокОрганизаций = ОрганизацииОтбораИнтерактивнойВыгрузки(Параметры.Отбор);
	
	Если СписокОрганизаций.Количество()=0 Тогда
		ОписаниеОтбораОрганизации = НСтр("ru = 'по всем организациям';
										|en = 'by all companies'");
	Иначе
		ОписаниеОтбораОрганизации = "";
		Для Каждого Элемент Из СписокОрганизаций Цикл
			ОписаниеОтбораОрганизации = ОписаниеОтбораОрганизации+ ", " + Элемент.Представление;
		КонецЦикла;
		ОписаниеОтбораОрганизации = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'с отбором по организациям: %1';
				|en = 'with filter by companies: %1'"), СокрЛП(Сред(ОписаниеОтбораОрганизации, 2)));
	КонецЕсли;

	Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Будут отправлены все документы %1,
		         |%2';
		         |en = 'All documents will be sent %1,
		         |%2'"),
		ОписаниеПериода,  ОписаниеОтбораОрганизации);
	
КонецФункции


// Возвращает список организаций по таблице отбора (см "ПредставлениеОтбораИнтерактивнойВыгрузки")
// Также используется из демонстрационной формы "НастройкаВыгрузки" этого плана обмена.
//
// Параметры:
//     ТаблицаОтбора - ТаблицаЗначений   - содержит строки с описанием подробных отборов по сценарию узла. Содержит колонки:
//         ПолноеИмяМетаданных - Строка;
//         ВыборПериода        - Булево;
//         Период              - СтандартныйПериод;
//         Отбор               - ОтборКомпоновкиДанных.
//
// Возвращаемое значение:
//     СписокЗначений - значение - ссылка на организацию, представление - наименование.
//
Функция ОрганизацииОтбораИнтерактивнойВыгрузки(Знач ТаблицаОтбора)
	
	Результат = Новый СписокЗначений;
	
	Если ТаблицаОтбора.Количество()=0 Или ТаблицаОтбора[0].Отбор.Элементы.Количество()=0 Тогда
		// Нет данных отбора
		Возврат Результат;
	КонецЕсли;
		
	// Мы знаем состав отбора, так как помещали туда сами - или из "НастроитьИнтерактивнуюВыгрузку",
	// или как результат редактирования в форме.
	
	СтрокаДанных = ТаблицаОтбора[0].Отбор.Элементы[0];
	Отобранные   = СтрокаДанных.ПравоеЗначение;
	ТипКоллекции = ТипЗнч(Отобранные);
	
	Если ТипКоллекции=Тип("СписокЗначений") Тогда
		Для Каждого Элемент Из Отобранные Цикл
			ДобавитьСписокОрганизаций(Результат, Элемент.Значение);
		КонецЦикла;
		
	ИначеЕсли ТипКоллекции=Тип("Массив") Тогда
		ДобавитьСписокОрганизаций(Результат, Отобранные);
		 
	ИначеЕсли ТипКоллекции=Тип("СправочникСсылка.Организации") Тогда
		Если Результат.НайтиПоЗначению(Отобранные)=Неопределено Тогда
			Результат.Добавить(Отобранные, Отобранные.Наименование);
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции


// Добавляет в список организаций коллекцию
//
// Параметры:
//     Список      - СписокЗначений - дополняемый список;
//     Организации - коллекция организаций.
// 
Процедура ДобавитьСписокОрганизаций(Список, Знач Организации)
	
	Для Каждого Организация Из Организации Цикл
		
		Если ТипЗнч(Организация)=Тип("Массив") Тогда
			ДобавитьСписокОрганизаций(Список, Организация);
			Продолжить;
		КонецЕсли;
		
		Если Список.НайтиПоЗначению(Организация)=Неопределено Тогда
			Список.Добавить(Организация, Организация.Наименование);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры


#КонецОбласти

#Область Прочее

// Заполняет настройки, влияющие на использование плана обмена.
// 
// Параметры:
//  Настройки - Структура - настройки плана обмена по умолчанию, см. ОбменДаннымиСервер.НастройкиПланаОбменаПоУмолчанию,
//                          описание возвращаемого значения функции.
//
Процедура ПриПолученииНастроек(Настройки) Экспорт
	
	Настройки.ИмяКонфигурацииИсточника = "УправлениеПредприятием";
	Настройки.ПредупреждатьОНесоответствииВерсийПравилОбмена	= Ложь;
	Настройки.ПланОбменаИспользуетсяВМоделиСервиса				= Ложь;
	
	Настройки.Алгоритмы.ПриПолученииОписанияВариантаНастройки				= Истина;
	Настройки.Алгоритмы.НастроитьИнтерактивнуюВыгрузку                      = Истина;
	Настройки.Алгоритмы.ПредставлениеОтбораИнтерактивнойВыгрузки            = Истина;
	
КонецПроцедуры

// Заполняет набор параметров, определяющих вариант настройки обмена.
// 
// Параметры:
//  ОписаниеВарианта       - Структура - набор варианта настройки по умолчанию,
//                                       см. ОбменДаннымиСервер.ОписаниеВариантаНастройкиОбменаПоУмолчанию,
//                                       описание возвращаемого значения.
//  ИдентификаторНастройки - Строка    - идентификатор варианта настройки обмена.
//  ПараметрыКонтекста     - Структура - см. ОбменДаннымиСервер.ПараметрыКонтекстаПолученияОписанияВариантаНастройки,
//                                       описание возвращаемого значения функции.
//
Процедура ПриПолученииОписанияВариантаНастройки(ОписаниеВарианта, ИдентификаторНастройки, ПараметрыКонтекста) Экспорт
	
	КраткаяИнформацияПоОбмену   = НСтр("ru = 'Данная настройка позволит синхронизировать данные между программами ""1С:ERP Управление предприятием, редакция 2"",
	|и ""Зарплата и Управление Персоналом, редакция 2.5"".  В синхронизации участвуют документы и нормативно-справочная информация.';
	|en = 'This setting allows you to synchronize data between applications 1C:ERP 2 (Enterprise Resource Management)
	| and 1C:HRM 2.5 (HR Management). Documents and master data are synchronized.'");
	ПодробнаяИнформацияПоОбмену = "ПланОбмена.ОбменУправлениеПредприятиемЗарплатаИУправлениеПерсоналом25.Форма.ПодробнаяИнформация";
	
	ОписаниеВарианта.ПутьКФайлуКомплектаПравилНаПользовательскомСайте = "https://users.v8.1c.ru/distribution/project/HRM";
	ОписаниеВарианта.ПутьКФайлуКомплектаПравилВКаталогеШаблонов	      = "\1c\hrm";
	ОписаниеВарианта.ИмяФайлаНастроекДляПриемника                     = НСтр("ru = 'Настройки обмена ERP-ЗУП';
																			|en = 'Configure 1C:ERP-1C:HRM (HR Management) exchange'");
	ОписаниеВарианта.ИспользоватьПомощникСозданияОбменаДанными        = Истина;
	ОписаниеВарианта.ИспользуемыеТранспортыСообщенийОбмена            = ИспользуемыеТранспортыСообщенийОбмена();
	ОписаниеВарианта.КраткаяИнформацияПоОбмену                        = КраткаяИнформацияПоОбмену;
	ОписаниеВарианта.ПодробнаяИнформацияПоОбмену                      = ПодробнаяИнформацияПоОбмену;
	ОписаниеВарианта.ИмяКонфигурацииКорреспондента                    = НСтр("ru = 'ЗарплатаИУправлениеПерсоналом';
																			|en = 'ЗарплатаИУправлениеПерсоналом'");
	
КонецПроцедуры

// Возвращает массив используемых транспортов сообщений для этого плана обмена
//
// 1. Например, если план обмена поддерживает только два транспорта сообщений FILE и FTP,
// то тело функции следует определить следующим образом:
//
//	Результат = Новый Массив;
//	Результат.Добавить(Перечисления.ВидыТранспортаСообщенийОбмена.FILE);
//	Результат.Добавить(Перечисления.ВидыТранспортаСообщенийОбмена.FTP);
//	Возврат Результат;
//
// 2. Например, если план обмена поддерживает все транспорты сообщений, определенных в конфигурации,
// то тело функции следует определить следующим образом:
//
//	Возврат ОбменДаннымиСервер.ВсеТранспортыСообщенийОбменаКонфигурации();
//
// Возвращаемое значение:
//  Массив - массив содержит значения перечисления ВидыТранспортаСообщенийОбмена.
//
Функция ИспользуемыеТранспортыСообщенийОбмена()
	
	Результат = Новый Массив;
	Результат.Добавить(Обработки.ТранспортСообщенийОбменаFILE);
	Результат.Добавить(Обработки.ТранспортСообщенийОбменаFTP);
	Результат.Добавить(Обработки.ТранспортСообщенийОбменаCOM);
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецЕсли