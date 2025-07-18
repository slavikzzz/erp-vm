///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Подсистема "ИнтернетПоддержкаПользователей.СистемаБыстрыхПлатежей.БазоваяФункциональностьСБП".
// ОбщийМодуль.СистемаБыстрыхПлатежейКлиент.
//
// Клиентские процедуры настройки подключения к Системе быстрых платежей:
//  - открытие форм настройки параметров подключения;
//  - отправка сообщений в службу технической поддержки;
//  - переход в журнал регистрации для просмотра лога;
//  - создание новых настроек подключения;
//  - алгоритмы настройки формы "Интернет-поддержка и сервисы";
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Открывает форму списка настроек подключения с Системой быстрых платежей.
//
// Параметры:
//  Владелец - ФормаКлиентскогоПриложения - форма которая будет установлена в качестве владельца.
//
Процедура НастройкиПодключения(Владелец) Экспорт
	
	ОткрытьФорму(
		"Справочник.НастройкиПодключенияКСистемеБыстрыхПлатежей.ФормаСписка",
		,
		Владелец);
	
КонецПроцедуры

// Открывает форму настройки подключения к Системой быстрых платежей.
//
// Параметры:
//  БИК - Строка, Неопределено - идентификатор банка. Используется для автоматического
//    выбора участника СБП;
//  ОтборУчастников - Строка, Неопределено - Параметры отбора участников СБП;
//  ОтображатьОписаниеСервиса - Булево - Признак отображения страницы описания сервиса.
//
// Возвращаемое значение:
//  Структура - настройки открытия формы подключения:
//    * БИК - Строка, Неопределено - идентификатор банка. Используется для автоматического
//      выбора участника СБП;
//    * ОтборУчастников - Строка, Неопределено - Параметры отбора участников СБП;
//    * ОтображатьОписаниеСервиса - Булево - Признак отображения страницы описания сервиса.
//
Функция НовыйПараметрыПодключения(
		БИК,
		ОтборУчастников,
		ОтображатьОписаниеСервиса = Истина) Экспорт
	
	ПараметрыПодключения = Новый Структура;
	ПараметрыПодключения.Вставить("БИК", БИК);
	ПараметрыПодключения.Вставить("ОтборУчастников", ОтборУчастников);
	ПараметрыПодключения.Вставить("ОтображатьОписаниеСервиса", ОтображатьОписаниеСервиса);
	
	Возврат ПараметрыПодключения;
	
КонецФункции

// Открывает форму настройки подключения к Системой быстрых платежей.
//
// Параметры:
//  ПараметрыПодключения - Структура - см. СистемаБыстрыхПлатежейКлиент.НовыйПараметрыПодключения.
//  ОписаниеОповещения - ОписаниеОповещения, Неопределено - оповещение, которое
//    необходимо вызвать после завершения настройки подключения. В случае успешного
//    завершения настройки подключения в результате оповещения будет возвращено Истина;
//  ДополнительныеПараметры - Структура, Неопределено - дополнительные параметры подключения.
//    Значение будет передано в переопределяемые методы:
//     - СистемаБыстрыхПлатежейПереопределяемый.ПриНастройкеЭлементовФормыПодключения;
//     - СистемаБыстрыхПлатежейПереопределяемый.ПриЗаполненииФормыНастройкиПодключения.
//
Процедура ПодключитьСистемуБыстрыхПлатежей(
		ПараметрыПодключения,
		ОписаниеОповещения = Неопределено,
		ДополнительныеПараметры = Неопределено) Экспорт
	
	ПараметрыПодключенияПроверка = НовыйПараметрыПодключения(
		Неопределено,
		Неопределено);
	
	Если ПараметрыПодключения <> Неопределено Тогда
		ЗаполнитьЗначенияСвойств(
			ПараметрыПодключенияПроверка,
			ПараметрыПодключения);
	КонецЕсли;
	
	НастройкиПодключения = Новый Структура;
	НастройкиПодключения.Вставить("БИК", ПараметрыПодключенияПроверка.БИК);
	НастройкиПодключения.Вставить("НастройкаПодключения", Неопределено);
	НастройкиПодключения.Вставить("ДополнительныеПараметры", ДополнительныеПараметры);
	НастройкиПодключения.Вставить("ОтборУчастников", ПараметрыПодключенияПроверка.ОтборУчастников);
	НастройкиПодключения.Вставить("ОтображатьОписаниеСервиса", ПараметрыПодключенияПроверка.ОтображатьОписаниеСервиса);
	
	СлужебнаяПодключитьСистемуБыстрыхПлатежей(
		НастройкиПодключения,
		ОписаниеОповещения);
	
КонецПроцедуры

// Отправляет сообщение в службу технической поддержки.
//
// Параметры:
//  ДокументОперации - ОпределяемыйТип.ДокументОперацииСБП - документ, который отражает
//    продажу в информационной базе;
//  НастройкаПодключения - СправочникСсылка.НастройкиПодключенияКСистемеБыстрыхПлатежей -
//    настройка выполнения оплаты;
//  ТекстСообщения - Строка - сообщение для технической поддержки.
//
Процедура ОтправитьСообщениеВСлужбуТехническойПоддержки(
		ДокументОперации,
		НастройкаПодключения,
		ТекстСообщения = "") Экспорт
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.СообщенияВСлужбуТехническойПоддержки") Тогда
		
		ДанныеОперации = СистемаБыстрыхПлатежейВызовСервера.ИнформацияДляТехническойПоддержки(
			ДокументОперации,
			НастройкаПодключения);
		
		Вложения = Новый Массив;
		Вложения.Добавить(
			Новый Структура(
				"Представление, ВидДанных, Данные",
				НСтр("ru = 'Служебные данные операции.txt';
					|en = 'Internal transaction data.txt'"),
				"Текст",
				ДанныеОперации));
		
		МодульСообщенияВСлужбуТехническойПоддержкиКлиентСервер =
			ОбщегоНазначенияКлиент.ОбщийМодуль("СообщенияВСлужбуТехническойПоддержкиКлиентСервер");
		ДанныеСообщения = МодульСообщенияВСлужбуТехническойПоддержкиКлиентСервер.ДанныеСообщения();
		ДанныеСообщения.Получатель = "webIts";
		ДанныеСообщения.Тема       = НСтр("ru = 'Интернет-поддержка. Система быстрых платежей';
											|en = 'Online support. Faster Payments System'");
		ДанныеСообщения.Сообщение  = ТекстСообщения;
		
		МодульСообщенияВСлужбуТехническойПоддержкиКлиент =
			ОбщегоНазначенияКлиент.ОбщийМодуль("СообщенияВСлужбуТехническойПоддержкиКлиент");
		МодульСообщенияВСлужбуТехническойПоддержкиКлиент.ОтправитьСообщение(
			ДанныеСообщения,
			Вложения);
	Иначе
		ВызватьИсключение НСтр("ru = 'Для отправки сообщений в техническую поддержку необходимо встроить подсистему ""СообщенияВСлужбуТехническойПоддержки""';
								|en = 'To send messages to the technical support, embed the ""СообщенияВСлужбуТехническойПоддержки"" subsystem'");
	КонецЕсли;
	
	ПоказатьОповещениеПользователя(
		НСтр("ru = 'Сформировано сообщение в техническую поддержку.';
			|en = 'Message to the technical support is created.'"),
		,
		,
		БиблиотекаКартинок.Информация32);
	
КонецПроцедуры

// Открывает форму пользовательского соглашения.
//
// Параметры:
//  ВладелецФормы - ы качестве владельца может выступить форма или элемент управления другой формы.
//
Процедура ФормаПользовательскогоСоглашения(ВладелецФормы = Неопределено) Экспорт
	
	ОткрытьФорму(
		"Обработка.ПодключениеКСБП.Форма.ПользовательскоеСоглашение",
		,
		ВладелецФормы);
	
КонецПроцедуры

// Формирует текст подсказки настройки подключения к Системе быстрых платежей.
//
// Параметры:
//  НаименованиеУчастника - Строка - наименование банка участника СБП;
//  ПараметрыПодсказки - Структура - результат создания параметров подсказки:
//   * АдресЛичногоКабинета - Строка - ссылка для перехода в личный кабинет;
//   * ПартнерАгентаСБП - Строка - признак партнера Агента СБП;
//   * АдресСтраницыЗаявки - Строка - адрес страницы отправки заявки;
//   * ИдентификаторУчастника - Строка - идентификатор участника СБП.
//
// Возвращаемое значение:
//  Строка, ФорматированнаяСтрока - подсказка при настройке подключения.
//
Функция ТекстПодсказкиПодключения(НаименованиеУчастника, ПараметрыПодсказки) Экспорт
	
	Возврат СтроковыеФункцииКлиент.ФорматированнаяСтрока(
		СистемаБыстрыхПлатежейКлиентСервер.ТекстПодсказкиПодключенияБезФорматирования(
			НаименованиеУчастника,
			ПараметрыПодсказки));
		
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Выполнение проверки и подключение к Интернет-поддержке пользователей.
// Параметры:
//  ОбработкаЗавершения - ОписаниеОповещения - Процедура, которая будет либо выполнена сразу, если вход в ИПП выполнен,
//    либо после вывода пользователю диалога о необходимости подключения к ИПП и ввода учетных данных.
//    Параметр Результат процедуры-обработчика может принимать значение Ложь,если пользователь отказался от подключения
//    к ИПП или отменил ввод учетных данных, либо Истина, если вход в ИПП выполнен.
//
Процедура НачатьПроверкуИПодключениеИнтернетПоддержкиПользователей(
		Знач ОбработкаЗавершения = Неопределено) Экспорт
	
	Если ПроверитьПодключениеИнтернетПоддержкиПользователей() Тогда
		
		Если ОбработкаЗавершения <> Неопределено Тогда
			ВыполнитьОбработкуОповещения(ОбработкаЗавершения, Истина);
		КонецЕсли;
		
	Иначе
		
		ПоказатьВопросПодключенияИнтернетПоддержкиПользователей(ОбработкаЗавершения);
		
	КонецЕсли;
	
КонецПроцедуры

// Открывает форму настройки подключения к с Системой быстрых платежей.
//
// Параметры:
//  НастройкиПодключения - Структура - параметры настройки подключения к Системе быстрых платежей:
//    * БИК - Строка, Неопределено - идентификатор банка. Используется для автоматического
//      выбора участника СБП.
//    * НастройкаПодключения - СправочникСсылка.НастройкиПодключенияКСистемеБыстрыхПлатежей, Неопределено - настройка
//      для автоматического заполнения параметров подключения на основании;
//    * ДополнительныеПараметры - Структура, Неопределено - дополнительные параметры подключения.
//      Значение будет передано в переопределяемые методы:
//       - СистемаБыстрыхПлатежейПереопределяемый.ПриНастройкеЭлементовФормыПодключения;
//       - СистемаБыстрыхПлатежейПереопределяемый.ПриЗаполненииФормыНастройкиПодключения.
//  ОписаниеОповещения - ОписаниеОповещения, Неопределено - оповещение, которое
//    необходимо вызвать после завершения настройки подключения. В случае успешного
//    завершения настройки подключения в результате оповещения будет возвращено Истина;
//
Процедура СлужебнаяПодключитьСистемуБыстрыхПлатежей(
		НастройкиПодключения,
		ОписаниеОповещения = Неопределено) Экспорт
	
	ОткрытьФорму(
		"Обработка.ПодключениеКСБП.Форма",
		НастройкиПодключения,
		,
		,
		,
		,
		ОписаниеОповещения);
	
КонецПроцедуры

// Определяет валидность URL переданной кассовой ссылки.
//
// Параметры:
//  КассоваяСсылка - Строка - URL кассовой ссылки.
//  ПроверкаПутиНаСервере - Булево - признак проверки заполненности пути на серверер в переданном URL.
//
// Возвращаемое значение:
//  Структура - Содержит результат проверки:
//    *URLВалиден - Булево - если Истина, URL валиден.
//    *СтруктураURI - Структура - составные части URL в виде структуры.
//
Функция СтруктураURLФункциональнойСсылки(
		Знач Ссылка,
		Знач ПроверкаПутиНаСервере) Экспорт
	
	РезультатПроверки = Новый Структура;
	РезультатПроверки.Вставить("URLВалиден", Истина);
	РезультатПроверки.Вставить("СтруктураURI", Неопределено);
	
	СтруктураURI = ОбщегоНазначенияКлиентСервер.СтруктураURI(
		Ссылка);
	
	Если СтруктураURI.Схема <> "https"
		Или (СтруктураURI.Порт <> Неопределено И СтруктураURI.Порт <> 443)
		Или (ПроверкаПутиНаСервере И ПустаяСтрока(СтруктураURI.ПутьНаСервере)) Тогда
		РезультатПроверки.URLВалиден = Ложь;
	КонецЕсли;
	
	РезультатПроверки.СтруктураURI = СтруктураURI;
	
	Возврат РезультатПроверки;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область НастройкиПодключения

// Вызывается при нажатии на гиперссылку форматированной строки, расположенной в элементе
// ДекорацияДополнительнаяИнформация.
//
// Параметры:
//  Элемент - Элемент - элемент формы;
//  НавигационнаяСсылкаФорматированнойСтроки - Строка - значение гиперссылки форматированной строки.
//    Параметр передается по ссылке.
//  СтандартнаяОбработка - передается признак выполнения стандартной (системной) обработки события.
//  ДанныеФормы - Структура - настройки подключения на форме:
//    * ПараметрыОплатыСБПc2b - Соответствие, Неопределено - содержит настройки выполнения оплаты.
//       Структура параметра соответствует структуре регистра, которая определена
//       в метаданных за исключением полей указанных в настройках в свойстве ИсключаемыеПоля
//       процедуры СистемаБыстрыхПлатежейПереопределяемый.ПриОпределенииНастроекПодключения
//       (см. Настройки.c2b.ОбъектМетаданных).
//    * НастройкаПодключения, Неопределено - СправочникСсылка.НастройкиПодключенияКСистемеБыстрыхПлатежей -
//       настройка выполнения оплаты. При настройке подключения будет возвращено Неопределено,
//       т.к. элемент настройки еще не создан.
//    * Модифицированность - Булево - признак модифицированности формы.
//
//@skip-warning
Процедура ПриОбработкеНавигационнойСсылкиДополнительнойИнформации(
		Элемент,
		НавигационнаяСсылкаФорматированнойСтроки,
		СтандартнаяОбработка,
		ДанныеФормы) Экспорт
	
	ИнтеграцияПодсистемБИПКлиент.ПриОбработкеНавигационнойСсылкиДополнительнойИнформации(
		Элемент,
		НавигационнаяСсылкаФорматированнойСтроки,
		СтандартнаяОбработка,
		ДанныеФормы);
	СистемаБыстрыхПлатежейКлиентПереопределяемый.ПриОбработкеНавигационнойСсылкиДополнительнойИнформации(
		Элемент,
		НавигационнаяСсылкаФорматированнойСтроки,
		СтандартнаяОбработка,
		ДанныеФормы);
	
КонецПроцедуры

#КонецОбласти

#Область ИнтернетПоддержкаПользователей

// См. СистемаБыстрыхПлатежейВызовСервера.ЗаполненыДанныеАутентификацииПользователяИнтернетПоддержки
//
Функция ПроверитьПодключениеИнтернетПоддержкиПользователей() 
	
	Возврат СистемаБыстрыхПлатежейВызовСервера.ЗаполненыДанныеАутентификацииПользователяИнтернетПоддержки();
	
КонецФункции

// Выполняет вызов вопроса пользователю оповещения после окончания процесса подключения ИПП
//
// Параметры:
//  ОбработкаЗавершения - ОписаниеОповещения - Содержит описание оповещения,
//   которое необходимо вызвать после ответа пользователя.
//
Процедура ПоказатьВопросПодключенияИнтернетПоддержкиПользователей(
		Знач ОбработкаЗавершения = Неопределено)
	
	Параметры = Новый Структура;
	Параметры.Вставить("ОбработкаЗавершения", ОбработкаЗавершения);
	
	ОбработкаОтвета = Новый ОписаниеОповещения("ПоказатьВопросПодключенияИнтернетПоддержкиПользователейЗавершение", ЭтотОбъект, Параметры);
	
	ТекстВопроса = НСтр("ru = 'Для использования функций взаимодействия с сервисом СБП,
		|необходимо подключиться к Интернет-поддержке пользователей.
		|Подключиться сейчас?';
		|en = 'To use functions of interaction with FPS service,
		|connect to Online user support.
		|Connect now?'");
	ПоказатьВопрос(ОбработкаОтвета, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

// Выполняет вызов обработки оповещения после окончания процесса подключения ИПП
//
// Параметры:
//  Ответ - КодВозвратаДиалога - Содержит ответ пользователя.
//  Параметры - Структура - содержит описание оповещения при закрытии формы.
//
Процедура ПоказатьВопросПодключенияИнтернетПоддержкиПользователейЗавершение(
		Знач Ответ,
		Знач Параметры) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		
		ОбработкаПодключения = Новый ОписаниеОповещения(
			"НачатьПодключениеИнтернетПоддержкиПользователейЗавершение",
			ЭтотОбъект,
			Параметры);
		НачатьПодключениеИнтернетПоддержкиПользователей(ОбработкаПодключения);
		
	Иначе
		
		Если Параметры.ОбработкаЗавершения <> Неопределено Тогда
			ВыполнитьОбработкуОповещения(Параметры.ОбработкаЗавершения, Ложь);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// См. ИнтернетПоддержкаПользователейКлиент.ПодключитьИнтернетПоддержкуПользователей
//
Процедура НачатьПодключениеИнтернетПоддержкиПользователей(
		Знач ОбработкаПодключения = Неопределено)
	
	ИнтернетПоддержкаПользователейКлиент.ПодключитьИнтернетПоддержкуПользователей(
		ОбработкаПодключения,
		ЭтотОбъект);
	
КонецПроцедуры

// Выполняет вызов обработки оповещения после окончания процесса подключения ИПП
//
// Параметры:
//  ДанныеПодключения - Структура - Содержит данные аутентификации пользователя,
//    пустая если они не заданы.
//  Параметры - Структура - содержит описание оповещения при закрытии формы
//
Процедура НачатьПодключениеИнтернетПоддержкиПользователейЗавершение(
		Знач ДанныеПодключения,
		Знач Параметры) Экспорт
	
	Если Параметры.ОбработкаЗавершения <> Неопределено Тогда
		
		Подключено = (ДанныеПодключения <> Неопределено);
		ВыполнитьОбработкуОповещения(Параметры.ОбработкаЗавершения, Подключено);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ПрочиеСлужебныеПроцедурыФункции

// Открывает форму журнала регистрации с отбором
// по событию см. ИмяСобытияЖурналаРегистрации.
//
Процедура ОткрытьЖурналРегистрации() Экспорт
	
	Отбор = Новый Структура;
	Отбор.Вставить("СобытиеЖурналаРегистрации", ИмяСобытияЖурналаРегистрации());
	ЖурналРегистрацииКлиент.ОткрытьЖурналРегистрации(Отбор);
	
КонецПроцедуры

// Возвращает имя события для журнала регистрации, которое используется
// для записи событий загрузки данных из внешних систем.
//
// Возвращаемое значение:
//  Строка - имя события.
//
Функция ИмяСобытияЖурналаРегистрации()
	
	Возврат НСтр("ru = 'Переводы СБП';
				|en = 'FPS transfers'",
		ОбщегоНазначенияКлиент.КодОсновногоЯзыка());
	
КонецФункции

#КонецОбласти

#КонецОбласти