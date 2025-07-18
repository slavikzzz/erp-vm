///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Подсистема "ИнтернетПоддержкаПользователей.ПолучениеВнешнихКомпонент".
// ОбщийМодуль.ПолучениеВнешнихКомпонентКлиент.
//
// Клиентские процедуры и функции загрузки внешних компонент:
//  - обработка событий панели Интернет-поддержка и сервисы;
//  - переход к интерактивному обновлению внешних компонент;
//  - настройка автоматической загрузки обновлений внешних компонент;
//  - оповещение об изменении данных внешних компонент.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Открывает помощник обновления внешних компонент.
// Доступно только для пользователей с полными правами.
//
// Параметры:
//  Идентификаторы - Массив из Строка, Неопределено - список уникальных идентификаторов
//                   внешних компонент.
//  ФайлОбновления - Строка, Неопределено - путь к файлу с внешними компонентами.
//
Процедура ОбновитьВнешниеКомпоненты(
		Идентификаторы = Неопределено,
		ФайлОбновления = Неопределено) Экспорт
	
	ПараметрыФормы = Новый Структура(
		"Идентификаторы, ФайлОбновления",
		Идентификаторы,
		ФайлОбновления);
	ОткрытьФорму(
		"Обработка.ОбновлениеВнешнихКомпонент.Форма.Форма",
		ПараметрыФормы);
	
КонецПроцедуры

// Определяет имя события, которое будет содержать оповещение
// о завершении загрузки внешних компонент.
//
// Возвращаемое значение:
//  Строка - Имя события. Может быть использовано для идентификации
//           сообщений принимающими их формами.
//
Функция ИмяСобытияОповещенияОЗагрузки() Экспорт
	
	Возврат "ПолучениеВнешнихКомпонент.ЗагруженыВнешниеКомпоненты";
	
КонецФункции

// Определяет расписание регламентного задания обновления внешних компонент.
//
// Возвращаемое значение:
//  Структура - Настройки регламентного задания обновления внешних компонент.
//              См ПолучениеВнешнихКомпонент.НастройкиОбновленияВнешнихКомпонент.
//
Функция НастройкиОбновленияВнешнихКомпонент() Экспорт
	
	Возврат ПолучениеВнешнихКомпонентВызовСервера.НастройкиОбновленияВнешнихКомпонент();
	
КонецФункции

// Изменяет настройки обновления внешних компонент.
//
// Параметры:
//  Настройки - Структура - Настройки регламентного задания обновления внешних компонент.
//    **ВариантОбновления - Число - вариант обновления внешних компонент;
//    **ФайлВнешнихКомпонент - Строка - путь к файлу внешних компонент;
//    **Расписание - РасписаниеРегламентногоЗадания - расписание обновления внешних компонент.
//
Процедура ИзменитьНастройкиОбновленияВнешнихКомпонент(Настройки) Экспорт
	
	ПолучениеВнешнихКомпонентВызовСервера.ИзменитьНастройкиОбновленияВнешнихКомпонент(Настройки);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

#Область ИнтеграцияПодсистемИнтернетПоддержкиПользователей

// Выполняет обработку оповещения на панели администрирования
// "Интернет-поддержка и сервисы".
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма, в которой обрабатывается оповещение;
//  ИмяСобытия - Строка - имя события;
//  Параметр - Произвольный - параметр;
//  Источник - Произвольный - источник события.
//
Процедура ИнтернетПоддержкаИСервисыОбработкаОповещения(
		Форма,
		ИмяСобытия,
		Параметр,
		Источник) Экспорт
	
	Если ИмяСобытия <> "ИнтернетПоддержкаОтключена"
			И ИмяСобытия <> "ИнтернетПоддержкаПодключена" Тогда
		Возврат;
	КонецЕсли;
	
	НастройкиОбновления = ПолучениеВнешнихКомпонентВызовСервера.НастройкиОбновленияВнешнихКомпонент();
	
	Если ИмяСобытия = "ИнтернетПоддержкаОтключена" Тогда
		
		Если НастройкиОбновления.ВариантОбновления = ВариантОбновленияИзСервиса() Тогда
			Форма.Элементы.ДекорацияОбновлениеВнешнихКомпонентНеВыполняется.Видимость = Истина;
		КонецЕсли;
		
	ИначеЕсли ИмяСобытия = "ИнтернетПоддержкаПодключена" Тогда
		
		Если НастройкиОбновления.Расписание <> Неопределено Тогда
			Форма.Элементы.ДекорацияРасписаниеОбновленияВнешнихКомпонент.Заголовок =
				ИнтернетПоддержкаПользователейКлиентСервер.ПредставлениеРасписания(
					НастройкиОбновления.Расписание);
		КонецЕсли;
		Форма.ВариантОбновленияВнешнихКомпонент = НастройкиОбновления.ВариантОбновления;
		Форма.Элементы.ДекорацияОбновлениеВнешнихКомпонентНеВыполняется.Видимость = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Определяет идентификаторы и номера версий, которые содержит файл с обновлениями.
//
// Параметры:
//  ИмяФайла - Строка - расположение архива с внешними компонентами.
//
// Возвращаемое значение:
//  Массив - содержит идентификаторы внешних компонент и номер версий.
//
Функция ВерсииВнешнихКомпонентВФайле(ИмяФайла) Экспорт
	
	#Если Не ВебКлиент Тогда
	
	ВерсииВнешнихКомпонент = Новый Массив;
	
	Если ОбщегоНазначенияКлиентСервер.ПолучитьРасширениеИмениФайла(ИмяФайла) <> "zip" Тогда
		Возврат ВерсииВнешнихКомпонент;
	КонецЕсли;
	
	ФайлМанифеста = Неопределено;
	
	// АПК:574-выкл код не используется в мобильном клиенте
	
	ЧтениеZipФайла = Новый ЧтениеZipФайла(ИмяФайла);
	Для Каждого ЭлементАрхива Из ЧтениеZipФайла.Элементы Цикл
		
		Если ВРег(ЭлементАрхива.Имя) = "EXTERNAL-COMPONENTS.JSON" Тогда
			ФайлМанифеста = ЭлементАрхива;
			Прервать;
		КонецЕсли;
		
	КонецЦикла;
	
	Если ФайлМанифеста <> Неопределено Тогда
	
		КаталогОписания = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(
			ПолучитьИмяВременногоФайла(ФайлМанифеста.ИмяБезРасширения));
		ЧтениеZipФайла.Извлечь(
			ФайлМанифеста,
			КаталогОписания,
			РежимВосстановленияПутейФайловZIP.НеВосстанавливать);
		ИмяФайлаОписания = КаталогОписания + ФайлМанифеста.Имя;
		
		РезультатОперации = ИнформацияОВерсияхВнешнихКомпонент(ИмяФайлаОписания);
		Если Не ЗначениеЗаполнено(РезультатОперации.КодОшибки) Тогда
			ВерсииВнешнихКомпонент = РезультатОперации.ДанныеВнешнихКомпонент;
		КонецЕсли;
		УдалитьФайлы(КаталогОписания);
		
	КонецЕсли;
	
	ЧтениеZipФайла.Закрыть();
	
	// АПК:574-вкл
	
	Возврат ВерсииВнешнихКомпонент;
	
	#Иначе
	
	ВызватьИсключение НСтр("ru = 'Интерактивная загрузка архива с внешними компонентами при работе в веб-клиенте запрещена.';
							|en = 'Manual import of the archive with add-ins is not allowed in the web client.'");
	
	#КонецЕсли
	
КонецФункции

// Возвращает имя события для журнала регистрации
//
// Возвращаемое значение:
//  Строка - имя события.
//
Функция ИмяСобытияЖурналаРегистрации() Экспорт
	
	Возврат НСтр("ru = 'Получение внешних компонент.';
				|en = 'Get add-ins.'", ОбщегоНазначенияКлиент.КодОсновногоЯзыка());
	
КонецФункции

// Возвращает описание файлов внешних компонент из манифеста.
//
// Возвращаемое значение:
//   Структура - результат загрузки внешних компонент:
//    *КодОшибки              - Строка - содержит код ошибки обработки файла;
//    *СообщениеОбОшибке      - Строка - содержит описание ошибки обработки файла;
//    *ДанныеВнешнихКомпонент - Массив из Структура - содержит информацию о внешних компонентах:
//     **Идентификатор          - Строка - содержит уникальный идентификатор внешней компоненты;
//     **Наименование           - Строка - содержит наименование внешней компоненты, к которой
//                                относится версия;
//                                указывается пользователем при создании новой компоненты;
//     **Версия                 - Строка - содержит номер версии внешней компоненты;
//     **ДатаВерсии             - Дата - содержит дату выхода версии внешней компоненты;
//     **ОписаниеВерсии         - Строка - содержит описание версии внешней компоненты;
//     **ИмяФайла               - Строка - содержит имя файла версии внешней компоненты.
//
Функция ИнформацияОВерсияхВнешнихКомпонент(ИмяФайла)
	
	#Если Не ВебКлиент Тогда
	
	РезультатОперации = Новый Структура;
	РезультатОперации.Вставить("КодОшибки",              "");
	РезультатОперации.Вставить("СообщениеОбОшибке",      "");
	
	ДанныеВнешнихКомпонент = Новый Массив;
	
	Попытка
		
		ЧтениеJSON = Новый ЧтениеJSON;
		ЧтениеJSON.ОткрытьФайл(ИмяФайла);
		ВерсииВнешнихКомпонент = ПрочитатьJSON(ЧтениеJSON, , "buildDate");
		
		// Заполнение таблицы с обновлениями.
		Для Каждого ОписаниеВнешнейКомпоненты Из ВерсииВнешнихКомпонент Цикл
			
			ДанныеВнешнейКомпоненты = Новый Структура;
			ДанныеВнешнейКомпоненты.Вставить("Идентификатор",    ОписаниеВнешнейКомпоненты.externalComponentNick);
			ДанныеВнешнейКомпоненты.Вставить("Наименование",     ОписаниеВнешнейКомпоненты.externalComponentName);
			ДанныеВнешнейКомпоненты.Вставить("Версия",           ОписаниеВнешнейКомпоненты.version);
			ДанныеВнешнейКомпоненты.Вставить("ДатаВерсии",       ОписаниеВнешнейКомпоненты.buildDate);
			ДанныеВнешнейКомпоненты.Вставить("ОписаниеВерсии",   "");
			ДанныеВнешнейКомпоненты.Вставить("ИмяФайла",         ОписаниеВнешнейКомпоненты.fileName);
			
			ДанныеВнешнихКомпонент.Добавить(ДанныеВнешнейКомпоненты);
			
		КонецЦикла;
	
	Исключение
		ИнформацияОбОшибке = ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		Комментарий = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не удалось получить описание внешних компонент из файла по причине:
				|%1';
				|en = 'Cannot get add-in details from the file due to:
				|%1'"),
			ИнформацияОбОшибке);
		ЖурналРегистрацииКлиент.ДобавитьСообщениеДляЖурналаРегистрации(
			ИмяСобытияЖурналаРегистрации(),
			"Предупреждение",
			Комментарий);
		РезультатОперации.КодОшибки = "НекорректныйФайлОписанияВнешнихКомпонент";
		РезультатОперации.СообщениеОбОшибке = Комментарий;
	КонецПопытки;
	
	ЧтениеJSON.Закрыть();
	
	РезультатОперации.Вставить("ДанныеВнешнихКомпонент", ДанныеВнешнихКомпонент);
	
	Возврат РезультатОперации;
	
	#Иначе
	
	ВызватьИсключение НСтр("ru = 'Получение информации о версиях внешних компонент при работе в веб-клиенте запрещена.';
							|en = 'Getting information about add-in versions is not allowed in the web client.'");
	
	#КонецЕсли
	
КонецФункции

// Возвращает числовое значение варианта обновления из сервиса.
// 
// Возвращаемое значение:
//  Число - Значение режима обновления.
//
Функция ВариантОбновленияИзСервиса()
	Возврат 1;
КонецФункции

#КонецОбласти
