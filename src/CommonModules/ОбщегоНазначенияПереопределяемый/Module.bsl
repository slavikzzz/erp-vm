///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Позволяет настроить общие параметры подсистемы.
//
// Параметры:
//  ОбщиеПараметры - Структура:
//      * ВыводитьПолныйСтекПриОшибкеДлительнойОперации  - Булево - если Истина, то в информацию об ошибке 
//              для разработчика включается фрагмент стека запуска длительной операции (до старта фонового задания). 
//              Это повышается информативность ошибок, возникающих в фоновых заданиях длительных операций,
//              которые запускаются функциями ДлительныеОперации.ВыполнитьФункцию, ВыполнитьПроцедуру и др.
//              По умолчанию Ложь, чтобы не мешать отладке при остановке по ошибке.
//      * ЗапрашиватьПодтверждениеПриЗавершенииПрограммы - Булево - по умолчанию Истина. Если установить в Ложь, то 
//              подтверждение при завершении работы программы не будет запрашиваться,  если явно не разрешить в
//              персональных настройках программы.
//      * ИмяФормыПерсональныхНастроек  - Строка - имя формы для редактирования персональных настроек.
//      * МинимальнаяВерсияПлатформы    - Строка - минимальная версии платформы, требуемая для запуска программы.
//              Запуск программы на версии платформы ниже указанной будет невозможен. Например, "8.3.6.1650".
//              Допускается указание нескольких версий платформы через точку с запятой.
//              В этом случае минимальная версия платформы будет выбрана, исходя из фактически используемой.
//              Например, "8.3.14.1694; 8.3.15.2107; 8.3.16.1791" - при запуске на предыдущих релизах 8.3.14 
//              будет предложено перейти на 8.3.14.1694, при запуске на 8.3.15 - 8.3.15.2107, и 8.3.16 - 
//              8.3.16.1791, соответственно.
//      * ОтключитьИдентификаторыОбъектовМетаданных - Булево - отключает заполнение справочников ИдентификаторыОбъектовМетаданных 
//              и ИдентификаторыОбъектовРасширений, процедуру выгрузки и загрузки в узлах РИБ.
//              Для частичного встраивания отдельных функций библиотеки в конфигурации без постановки на поддержку.
//      * РекомендуемаяВерсияПлатформы              - Строка - рекомендуемая версия платформы для запуска программы.
//              Например, "8.3.8.2137". Допускается указание нескольких версий платформы через точку с запятой. 
//              См. пример в параметре МинимальнаяВерсияПлатформы.
//      * РекомендуемыйОбъемОперативнойПамяти       - Число - объем памяти в гигабайтах, рекомендуемый 
//               для комфортной работы в программе. По умолчанию 4 Гб.
//
//    Устарели, следует использовать свойства МинимальнаяВерсияПлатформы и РекомендуемаяВерсияПлатформы:
//      * МинимальноНеобходимаяВерсияПлатформы    - Строка - полный номер версии платформы для запуска программы.
//                                                           Например, "8.3.4.365".
//      * РаботаВПрограммеЗапрещена               - Булево - начальное значение Ложь.
//
Процедура ПриОпределенииОбщихПараметровБазовойФункциональности(ОбщиеПараметры) Экспорт
	
	ОбщиеПараметры.РекомендуемыйОбъемОперативнойПамяти  = 3;
	ОбщиеПараметры.МинимальнаяВерсияПлатформы = "8.3.24.1548; 8.3.25.1286";
	ОбщиеПараметры.РекомендуемаяВерсияПлатформы = "8.3.24.1548; 8.3.25.1286";
	
КонецПроцедуры

// Определяет соответствие имен параметров сеанса и обработчиков для их установки.
// Вызывается для инициализации параметров сеанса из обработчика события модуля сеанса УстановкаПараметровСеанса
// (подробнее о нем см. синтакс-помощник).
//
// В указанных модулях должна быть размещена процедура обработчика, в которую передаются параметры:
//  ИмяПараметра           - Строка - имя параметра сеанса, который требуется установить.
//  УстановленныеПараметры - Массив - имена параметров, которые уже установлены.
// 
// Далее пример процедуры обработчика для копирования в указанные модули.
//
//// Параметры:
////  ИмяПараметра  - Строка
////  УстановленныеПараметры - Массив из Строка
////
//Процедура УстановкаПараметровСеанса(ИмяПараметра, УстановленныеПараметры) Экспорт
//	
//  Если ИмяПараметра = "ТекущийПользователь" Тогда
//		ПараметрыСеанса.ТекущийПользователь = Значение;
//		УстановленныеПараметры.Добавить("ТекущийПользователь");
//  КонецЕсли;
//	
//КонецПроцедуры
//
// Параметры:
//  Обработчики - Соответствие из КлючИЗначение:
//    * Ключ     - Строка - в формате "<ИмяПараметраСеанса>|<НачалоИмениПараметраСеанса*>".
//                   Символ '*'используется в конце имени параметра сеанса и обозначает,
//                   что один обработчик будет вызван для инициализации всех параметров сеанса
//                   с именем, начинающимся на слово НачалоИмениПараметраСеанса.
//
//    * Значение - Строка - в формате "<ИмяМодуля>.УстановкаПараметровСеанса".
//
//  Пример:
//   Обработчики.Вставить("ТекущийПользователь", "ПользователиСлужебный.УстановкаПараметровСеанса");
//
Процедура ПриДобавленииОбработчиковУстановкиПараметровСеанса(Обработчики) Экспорт
	
	//++ НЕ ГОСИС
	ОбщегоНазначенияЛокализация.ПриДобавленииОбработчиковУстановкиПараметровСеанса(Обработчики);
	Обработчики.Вставить("ПроводитьБезКонтроляОстатковТоваровОрганизаций" , "ЗапасыСервер.УстановитьПараметрыСеанса");
	Обработчики.Вставить("ПроводитьБезКонтроляРезервовТоваровПоЗаказам" ,
		"ОбеспечениеВДокументахСервер.УстановитьПараметрыСеанса");
	Обработчики.Вставить("ХозяйственныеОперацииСНастройкамиОграниченийДоступа" , "Справочники.НастройкиХозяйственныхОпераций.УстановитьПараметрыСеанса");
	Обработчики.Вставить("СформированныеЗаданияЗакрытияМесяца" , "ЗакрытиеМесяцаСервер.УстановкаПараметровСеанса");
	
	//-- НЕ ГОСИС
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПриДобавленииОбработчиковУстановкиПараметровСеанса(Обработчики);
	// Конец ИнтеграцияС1СДокументооборотом
	
	//ПодключаемоеОборудование
	ИнтеграцияПодсистемБПО.ПриДобавленииОбработчиковУстановкиПараметровСеанса(Обработчики);
	//Конец ПодключаемоеОборудование
	
	//++ Локализация
	СервисПрогнозирования.ПриДобавленииОбработчиковУстановкиПараметровСеанса(Обработчики);
	//-- Локализация
	
КонецПроцедуры

// Позволяет задать значения параметров, необходимых для работы клиентского кода
// при запуске конфигурации (в обработчиках событий ПередНачаломРаботыСистемы и ПриНачалеРаботыСистемы) 
// без дополнительных серверных вызовов. 
// Для получения значений этих параметров из клиентского кода
// см. СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиентаПриЗапуске.
//
// Важно: недопустимо использовать команды сброса кэша повторно используемых модулей, 
// иначе запуск может привести к непредсказуемым ошибкам и лишним серверным вызовам.
//
// Параметры:
//   Параметры - Структура - имена и значения параметров работы клиента при запуске, которые необходимо задать.
//                           Для установки параметров работы клиента при запуске:
//                           Параметры.Вставить(<ИмяПараметра>, <код получения значения параметра>);
//
Процедура ПриДобавленииПараметровРаботыКлиентаПриЗапуске(Параметры) Экспорт
	
	Если ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных() Тогда
	
		//++ НЕ ГОСИС
		Параметры.Вставить("ПодключатьКомпонентуОбменаДаннымиПриСтартеСистемы", МобильныеПриложения.ПодключатьКомпонентуОбменаДаннымиПриСтартеСистемы());
		Параметры.Вставить("ФормыОткрываемыеПриНачалеРаботыСистемы", 			ОткрытиеФормПриНачалеРаботыСистемы.ФормыОткрываемыеПриНачалеРаботыСистемы());
		Параметры.Вставить("ВозможенЗапускБазовойВерсии", 						ОбщегоНазначенияУТ.ВозможенЗапускБазовойВерсии());
		
		ОбщегоНазначенияУТВызовСервера.ПараметрыРаботыКлиентаПриЗапуске(Параметры);
	
		//++ НЕ УТ
		Параметры.Вставить("ПоказатьОписаниеИзмененийСистемы", Ложь);
		//-- НЕ УТ
		
		//-- НЕ ГОСИС
		
		// ПодключаемоеОборудование
		ИнтеграцияПодсистемБПО.ПриДобавленииПараметровРаботыКлиентаПриЗапуске(Параметры);
		// Конец ПодключаемоеОборудование
		
	КонецЕсли;
	
	//++ НЕ ГОСИС
	ОбщегоНазначенияЛокализация.ПриДобавленииПараметровРаботыКлиентаПриЗапуске(Параметры);
	//-- НЕ ГОСИС
	
КонецПроцедуры

// Позволяет задать значения параметров, необходимых для работы клиентского кода
// конфигурации без дополнительных серверных вызовов.
// Для получения этих параметров из клиентского кода
// см. СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиента.
//
// Параметры:
//   Параметры - Структура - имена и значения параметров работы клиента, которые необходимо задать.
//                           Для установки параметров работы клиента:
//                           Параметры.Вставить(<ИмяПараметра>, <код получения значения параметра>);
//
Процедура ПриДобавленииПараметровРаботыКлиента(Параметры) Экспорт
	
	//++ НЕ ГОСИС
	ОбщегоНазначенияЛокализация.ПриДобавленииПараметровРаботыКлиента(Параметры);
		
	//++ НЕ УТ
	Параметры.Вставить("ПоказатьОписаниеИзмененийСистемы", Ложь);	                                                                
	//-- НЕ УТ
	
	//-- НЕ ГОСИС
	
КонецПроцедуры

// Позволяет выполнить действия перед запуском сеанса программы, которые невозможно отложить на более поздний этап. 
// Например, настроить начальную страницу и другие параметры интерфейса в зависимости от режима работы.
//
// Вызывается в клиентских сеансах и в сеансах регламентных заданий после проверки минимальной версии платформы, 
// заданной в процедуре ОбщегоНазначенияПереопределяемый.ПриОпределенииОбщихПараметровБазовойФункциональности.
// Не вызывается из сеансов фоновых заданий.
//
// Для определения, что запущен клиентский сеанс, можно проверить ТекущийРежимЗапуска() <> Неопределено.
// Для определения других видов сеанса - условие ПолучитьТекущийСеансИнформационнойБазы().ИмяПриложения = "<имя>", 
// например "WSConnection" или "BackgroundJob".
//
// Вызов производится в привилегированном режиме.
//
// Рекомендуется размещать здесь код вместо обработчика события УстановкаПараметровСеанса модуля сеанса 
// с проверкой условия ИменаПараметровСеанса = Неопределено.
// При реализации обработчика следует иметь в виду, что в ИБ могут быть не завершены обработчики обновления
// и не выполнена дальнейшая инициализация, которая происходит позже при запуске программы. 
// Поэтому может быть небезопасно безусловно вызывать другие процедуры и функции, которые зависят от этого.
//
Процедура ПередЗапускомПрограммы() Экспорт

	//++ НЕ ГОСИС
	ОбщегоНазначенияЛокализация.ПередЗапускомПрограммы();
	//-- НЕ ГОСИС
	
КонецПроцедуры

// Определяет объекты метаданных и отдельные реквизиты, которые исключаются из результатов поиска ссылок,
// не учитываются при монопольном удалении помеченных, замене ссылок и в отчете по местам использования.
// См. также ОбщегоНазначения.ИсключенияПоискаСсылок.
//
// Пример задачи: к документу "Реализация товаров и услуг" подключены подсистемы "Версионирование объектов" и "Свойства".
// Также этот документ может быть указан в других объектах метаданных - документах или регистрах.
// Часть ссылок имеют значение для бизнес-логики (например движения по регистрам) и должны выводиться пользователю.
// Другая часть ссылок - "техногенные" (ссылки на документ из данных подсистем "Версионирование объектов" и "Свойства")
// и должны скрываться от пользователя при удалении, анализе мест использования или запретов редактирования ключевых реквизитов.
// Список таких "техногенных" объектов нужно перечислить в этой процедуре.
//
// При этом для избежания появления ссылок на несуществующие объекты
// рекомендуется предусмотреть процедуру очистки указанных объектов метаданных.
//   * Для измерений регистров сведений - с помощью установки флажка "Ведущее",
//     тогда запись регистра сведений будет удалена вместе с удалением ссылки, указанной в измерении.
//   * Для других реквизитов указанных объектов - с помощью подписки на событие ПередУдалением всех типов объектов
//     метаданных, которые могут быть записаны в реквизиты указанных объектов метаданных.
//     В обработчике необходимо найти "техногенные" объекты, в реквизитах которых указана ссылка удаляемого объекта,
//     и выбрать, как именно очищать ссылку: очищать значение реквизита, удалять строку таблицы или удалять весь объект.
// Подробнее см. в документации к подсистеме "Удаление помеченных объектов".
//
// При исключении регистров допустимо исключать только Измерения.
// При необходимости исключить из поиска значения в ресурсах
// или в реквизитах регистров требуется исключить регистр целиком.
//
// Параметры:
//   ИсключенияПоискаСсылок - Массив - объекты метаданных или их реквизиты (ОбъектМетаданных, Строка),
//       которые не должно учитываться в бизнес-логике.
//       Стандартные реквизиты и табличные части могут быть указаны только в виде строковых имен (см. пример ниже).
//
// Пример:
//   ИсключенияПоискаСсылок.Добавить(Метаданные.РегистрыСведений.ВерсииОбъектов);
//   ИсключенияПоискаСсылок.Добавить(Метаданные.РегистрыСведений.ВерсииОбъектов.Измерения.Объект);
//   ИсключенияПоискаСсылок.Добавить("ПланВидовРасчета.ОсновныеНачисления.СтандартнаяТабличнаяЧасть.БазовыеВидыРасчета.СтандартныйРеквизит.ВидРасчета");
//
Процедура ПриДобавленииИсключенийПоискаСсылок(ИсключенияПоискаСсылок) Экспорт
	//++ НЕ ГОСИС
	ОбщегоНазначенияЛокализация.ПриДобавленииИсключенийПоискаСсылок(ИсключенияПоискаСсылок);
	
	ИсключенияПоискаСсылок.Добавить(Метаданные.РегистрыСведений.АналитикаУчетаНоменклатуры.ПолноеИмя());
	ИсключенияПоискаСсылок.Добавить(Метаданные.РегистрыСведений.АналитикаУчетаПартий.ПолноеИмя());
	ИсключенияПоискаСсылок.Добавить(Метаданные.РегистрыСведений.АналитикаУчетаПоПартнерам.ПолноеИмя());
	ИсключенияПоискаСсылок.Добавить(Метаданные.РегистрыСведений.ЗаданияКРасчетуСебестоимости.ПолноеИмя());
	ИсключенияПоискаСсылок.Добавить(Метаданные.РегистрыСведений.ЗаданияКРаспределениюРасчетовСКлиентами.ПолноеИмя());
	ИсключенияПоискаСсылок.Добавить(Метаданные.РегистрыСведений.ЗаданияКРаспределениюРасчетовСПоставщиками.ПолноеИмя());
	ИсключенияПоискаСсылок.Добавить(Метаданные.РегистрыСведений.ЗаданияКЗакрытиюМесяца.ПолноеИмя());
	
	//++ НЕ УТ
	ИсключенияПоискаСсылок.Добавить(Метаданные.РегистрыСведений.ЗаданияКРасчетуАмортизацииНМА.ПолноеИмя());
	ИсключенияПоискаСсылок.Добавить(Метаданные.РегистрыСведений.ЗаданияКРасчетуАмортизацииОС.ПолноеИмя());
	ИсключенияПоискаСсылок.Добавить(Метаданные.РегистрыСведений.ЗаданияКРасчетуСтоимостиВНА.ПолноеИмя());
	ИсключенияПоискаСсылок.Добавить(Метаданные.РегистрыСведений.ЗаданияКФормированиюДвиженийПоВНА.ПолноеИмя());
	
	ИсключенияПоискаСсылок.Добавить(Метаданные.Документы.ИзменениеПараметровНМА2_4.Реквизиты.ДокументВДругомУчете);
	ИсключенияПоискаСсылок.Добавить(Метаданные.Документы.ИзменениеПараметровОС2_4.Реквизиты.ДокументВДругомУчете);
	ИсключенияПоискаСсылок.Добавить(Метаданные.Документы.МодернизацияОС2_4.Реквизиты.ДокументВДругомУчете);
	ИсключенияПоискаСсылок.Добавить(Метаданные.Документы.ПереоценкаНМА2_4.Реквизиты.ДокументВДругомУчете);
	ИсключенияПоискаСсылок.Добавить(Метаданные.Документы.ПереоценкаОС2_4.Реквизиты.ДокументВДругомУчете);
	ИсключенияПоискаСсылок.Добавить(Метаданные.Документы.ПринятиеКУчетуНМА2_4.Реквизиты.ДокументВДругомУчете);
	ИсключенияПоискаСсылок.Добавить(Метаданные.Документы.ПринятиеКУчетуОС2_4.Реквизиты.ДокументВДругомУчете);
	ИсключенияПоискаСсылок.Добавить(Метаданные.Документы.ПринятиеКУчетуУзловКомпонентовАмортизации.Реквизиты.ДокументВДругомУчете);
	ИсключенияПоискаСсылок.Добавить(Метаданные.Документы.СписаниеНМА2_4.Реквизиты.ДокументВДругомУчете);
	ИсключенияПоискаСсылок.Добавить(Метаданные.Документы.СписаниеОС2_4.Реквизиты.ДокументВДругомУчете);
	ИсключенияПоискаСсылок.Добавить(Метаданные.Документы.ОбъединениеОС.Реквизиты.ДокументВДругомУчете);
	ИсключенияПоискаСсылок.Добавить(Метаданные.Документы.РазукомплектацияОС.Реквизиты.ДокументВДругомУчете);
	ИсключенияПоискаСсылок.Добавить(Метаданные.Документы.УлучшениеНМА.Реквизиты.ДокументВДругомУчете);
	
	ИсключенияПоискаСсылок.Добавить(Метаданные.Справочники.ПравилаПолученияФактаПоПоказателямБюджетов.Реквизиты.ПоказательБюджетов);
	ИсключенияПоискаСсылок.Добавить(Метаданные.Справочники.ПравилаПолученияФактаПоСтатьямБюджетов.Реквизиты.СтатьяБюджетов);
	//-- НЕ УТ
	
	//++ НЕ УТКА
	ИсключенияПоискаСсылок.Добавить(Метаданные.РегистрыСведений.СтруктураЗаказа);
	ИсключенияПоискаСсылок.Добавить(Метаданные.РегистрыСведений.ТрудозатратыСтруктурыЗаказа);
	ИсключенияПоискаСсылок.Добавить(Метаданные.РегистрыСведений.КэшНСИСтруктурыЗаказа);
	ИсключенияПоискаСсылок.Добавить(Метаданные.РегистрыСведений.ПротоколРасчетаСтруктурыЗаказа);
	ИсключенияПоискаСсылок.Добавить(Метаданные.РегистрыСведений.БуферЗаданийКРасчетуСтруктурыЗаказаСпецификации);
	ИсключенияПоискаСсылок.Добавить(Метаданные.РегистрыСведений.ЗаданияКРасчетуСтруктурыЗаказаСпецификации);
	ИсключенияПоискаСсылок.Добавить(Метаданные.РегистрыСведений.БуферЗаданийКРасчетуСтруктурыЗаказаРаспределениеЗапасов);
	ИсключенияПоискаСсылок.Добавить(Метаданные.РегистрыСведений.ЗаданияКРасчетуСтруктурыЗаказаРаспределениеЗапасов);
	ИсключенияПоискаСсылок.Добавить(Метаданные.РегистрыСведений.НормативныйГрафикСтруктурыЗаказа.Измерения.ЗаказНаПроизводство);
	//-- НЕ УТКА
	
	ИсключенияПоискаСсылок.Добавить(Метаданные.Документы.РегистраторЗапасыИПотребности.ПолноеИмя());
	ИсключенияПоискаСсылок.Добавить(Метаданные.Документы.УдалитьРегистраторГрафикаДвиженияТоваров.ПолноеИмя());
	
	ИсключенияПоискаСсылок.Добавить(Метаданные.РегистрыСведений.ДатыПередачиТоваровНаКомиссию.ПолноеИмя());
	ИсключенияПоискаСсылок.Добавить(Метаданные.РегистрыСведений.ДатыПоступленияТоваровОрганизаций.ПолноеИмя());
	ИсключенияПоискаСсылок.Добавить(Метаданные.РегистрыСведений.ДоступностьТоваровДляВнешнихПользователей.ПолноеИмя());
	ИсключенияПоискаСсылок.Добавить(Метаданные.РегистрыСведений.ИсточникиДанныхВариантовАнализаЦелевыхПоказателей.ПолноеИмя());
	ИсключенияПоискаСсылок.Добавить(Метаданные.РегистрыСведений.ЦелевыеЗначенияВариантовАнализа.ПолноеИмя());	
	ИсключенияПоискаСсылок.Добавить(Метаданные.РегистрыСведений.ШтрихкодыНоменклатуры.ПолноеИмя());	
	ИсключенияПоискаСсылок.Добавить(Метаданные.РегистрыСведений.ВерсииОбъектов.ПолноеИмя());
	ИсключенияПоискаСсылок.Добавить(Метаданные.РегистрыСведений.ДатыЗапретаИзменения.ПолноеИмя());
	ИсключенияПоискаСсылок.Добавить(Метаданные.РегистрыСведений.ДополнительныеСведения.ПолноеИмя());
	ИсключенияПоискаСсылок.Добавить(Метаданные.РегистрыСведений.КурсыВалют.ПолноеИмя());
	ИсключенияПоискаСсылок.Добавить(Метаданные.РегистрыСведений.НаличиеФайлов.ПолноеИмя());
	ИсключенияПоискаСсылок.Добавить(Метаданные.РегистрыСведений.УдалитьДвоичныеДанныеФайлов.ПолноеИмя());
	ИсключенияПоискаСсылок.Добавить(Метаданные.РегистрыСведений.ДокументыФизическихЛиц.ПолноеИмя());
	ИсключенияПоискаСсылок.Добавить(Метаданные.РегистрыСведений.ОчередьЗаказовККорректировкеСтрокМерныхТоваров.ПолноеИмя());
	
	ИсключенияПоискаСсылок.Добавить(Метаданные.Справочники.ВидыНоменклатуры.ТабличныеЧасти.РеквизитыБыстрогоОтбораНоменклатуры.Реквизиты.Свойство);
	ИсключенияПоискаСсылок.Добавить(Метаданные.Справочники.ВидыНоменклатуры.ТабличныеЧасти.РеквизитыБыстрогоОтбораХарактеристик.Реквизиты.Свойство);
	ИсключенияПоискаСсылок.Добавить(Метаданные.Справочники.ВидыНоменклатуры.ТабличныеЧасти.РеквизитыДляКонтроляНоменклатуры.Реквизиты.Свойство);
	ИсключенияПоискаСсылок.Добавить(Метаданные.Справочники.ВидыНоменклатуры.ТабличныеЧасти.РеквизитыДляКонтроляХарактеристик.Реквизиты.Свойство);
	ИсключенияПоискаСсылок.Добавить(Метаданные.Справочники.ВидыНоменклатуры.ТабличныеЧасти.РеквизитыДляКонтроляСерий.Реквизиты.Свойство);
	ИсключенияПоискаСсылок.Добавить(Метаданные.Справочники.ВидыНоменклатуры.ТабличныеЧасти.ПолитикиУчетаСерий.Реквизиты.Склад);
	//-- НЕ ГОСИС
	
	//++ НЕ УТКА
	ИсключенияПоискаСсылок.Добавить(Метаданные.Справочники.ТехнологическиеОперации.Реквизиты.Основание);
	//-- НЕ УТКА
	
КонецПроцедуры

// Позволяет задать список подчиненных объектов и их связи с основными объектами.
// Подчиненные объекты рекомендуется использовать, если в процессе замены ссылок
// нужно создавать часть объектов или подбирать замену из существующих объектов.
//
// Параметры:
//  ПодчиненныеОбъекты - см. ОбщегоНазначения.ПодчиненныеОбъекты
//
// Пример:
//	СвязиПодчиненногоОбъекта = Новый Соответствие;
//	СвязиПодчиненногоОбъекта.Вставить("ПолеСвязи");
//	ПодчиненныйОбъект = ПодчиненныеОбъекты.Добавить();
//	ПодчиненныйОбъект.ПодчиненныйОбъект = Метаданные.Справочники.<ПодчиненныйСправочник>;
//	ПодчиненныйОбъект.ПоляСвязей = СвязиПодчиненногоОбъекта;
//	ПодчиненныйОбъект.ВыполнятьАвтоматическийПоискЗаменСсылок = Истина;
//
//	СвязиПодчиненногоОбъекта = Новый Массив;
//	СвязиПодчиненногоОбъекта.Вставить("ПолеСвязи");
//	ПодчиненныйОбъект = ПодчиненныеОбъекты.Добавить();
//	ПодчиненныйОбъект.ПодчиненныйОбъект = Метаданные.Справочники.<ПодчиненныйСправочник>;
//	ПодчиненныйОбъект.ПоляСвязей = СвязиПодчиненногоОбъекта;
//	ПодчиненныйОбъект.ВыполнятьАвтоматическийПоискЗаменСсылок = Истина;
//
//	ПодчиненныйОбъект = ПодчиненныеОбъекты.Добавить();
//	ПодчиненныйОбъект.ПодчиненныйОбъект = Метаданные.Справочники.<ПодчиненныйСправочник>;
//	ПодчиненныйОбъект.ПоляСвязей = "ПолеСвязи";
//	ПодчиненныйОбъект.ПриПоискеЗаменыСсылок = "<ОбщийМодуль>";
// 	
Процедура ПриОпределенииПодчиненныхОбъектов(ПодчиненныеОбъекты) Экспорт

	

КонецПроцедуры

// Выполняется после замены ссылок перед непосредственным удалением объектов.
// 
// Параметры:
//  Результат - см. ОбщегоНазначения.ЗаменитьСсылки
//  ПараметрыВыполнения - см. ОбщегоНазначения.ПараметрыЗаменыСсылок
//  ТаблицаПоиска - см. ОбщегоНазначения.МестаИспользования
//
Процедура ПослеЗаменыСсылок(Результат, ПараметрыВыполнения, ТаблицаПоиска) Экспорт

	// удаление дублей ключей реестра документов
	МассивТиповКлючейРеестраДокументов = Метаданные.Справочники.КлючиРеестраДокументов.Реквизиты.Ключ.Тип.Типы();
	
	Если ТаблицаПоиска.Количество() > 0
		И МассивТиповКлючейРеестраДокументов.Найти(ТипЗнч(ТаблицаПоиска.Получить(0).Ссылка)) <> Неопределено Тогда
		
		КлючиРеестраДокументовСервер.УдалениеДублейКлючейРеестраДокументов();
		
	КонецЕсли;

КонецПроцедуры

// Вызывается при обновлении информационной базы для учета переименований подсистем и ролей в конфигурации.
// В противном случае, возникнет рассинхронизация между метаданными конфигурации и 
// элементами справочника ИдентификаторыОбъектовМетаданных, что приведет к различным ошибкам при работе конфигурации.
// См. также ОбщегоНазначения.ИдентификаторОбъектаМетаданных, ОбщегоНазначения.ИдентификаторыОбъектовМетаданных.
//
// В этой процедуре последовательно для каждой версии конфигурации задаются переименования только подсистем и ролей, 
// а переименования остальных объектов метаданных задавать не следует, т.к. они обрабатываются автоматически.
//
// Параметры:
//  Итог - ТаблицаЗначений - таблица переименований, которую требуется заполнить.
//                           См. ОбщегоНазначения.ДобавитьПереименование.
//
// Пример:
//	ОбщегоНазначения.ДобавитьПереименование(Итог, "2.1.2.14",
//		"Подсистема.СлужебныеПодсистемы",
//		"Подсистема.СервисныеПодсистемы");
//
Процедура ПриДобавленииПереименованийОбъектовМетаданных(Итог) Экспорт
	//++ НЕ ГОСИС
	ОбновлениеИнформационнойБазыУТ.ПриДобавленииПереименованийОбъектовМетаданных(Итог);
	//++ НЕ УТ
	ОбновлениеИнформационнойБазыКА.ПриДобавленииПереименованийОбъектовМетаданных(Итог);
	//-- НЕ УТ

	//++ НЕ УТКА
	ОбновлениеИнформационнойБазыУП.ПриДобавленииПереименованийОбъектовМетаданных(Итог);
	//-- НЕ УТКА

	ОбщегоНазначенияЛокализация.ПриДобавленииПереименованийОбъектовМетаданных(Итог);
	//-- НЕ ГОСИС
	
КонецПроцедуры

// Позволяет отключать подсистемы, например, для целей тестирования.
// Если подсистема отключена, то функции ОбщегоНазначения.ПодсистемаСуществует и 
// ОбщегоНазначенияКлиент.ПодсистемаСуществует вернут Ложь.
//
// В реализации этой процедуры нельзя использовать функцию ОбщегоНазначения.ПодсистемаСуществует, 
// т.к. это приводит к рекурсии.
//
// Параметры:
//   ОтключенныеПодсистемы - Соответствие из КлючИЗначение:
//     * Ключ - Строка - имя отключаемой подсистемы
//     * Значение - Булево - Истина
//
Процедура ПриОпределенииОтключенныхПодсистем(ОтключенныеПодсистемы) Экспорт
	
	
	
КонецПроцедуры

// Вызывается перед загрузкой приоритетных данных в подчиненном узле РИБ
// и предназначена для заполнения настроек размещения сообщения обмена данными или
// для реализации нестандартной загрузки приоритетных данных из главного узла РИБ.
//
// К приоритетным данным относятся предопределенные элементы, а также
// элементы справочника ИдентификаторыОбъектовМетаданных.
//
// Параметры:
//  СтандартнаяОбработка - Булево - начальное значение Истина; если установить Ложь, 
//                то стандартная загрузка приоритетных данных с помощью подсистемы
//                ОбменДанными будет пропущена (так же будет и в том случае,
//                если подсистемы ОбменДанными нет в конфигурации).
//
Процедура ПередЗагрузкойПриоритетныхДанныхВПодчиненномРИБУзле(СтандартнаяОбработка) Экспорт
	
	
	
КонецПроцедуры

// Определяет список версий программных интерфейсов, доступных через web-сервис InterfaceVersion.
//
// Параметры:
//  ПоддерживаемыеВерсии - Структура - в ключе указывается имя программного интерфейса,
//                                     а в значениях - массив строк с поддерживаемыми версиями этого интерфейса.
//
// Пример:
//
//  // СервисПередачиФайлов
//  Версии = Новый Массив;
//  Версии.Добавить("1.0.1.1");
//  Версии.Добавить("1.0.2.1"); 
//  ПоддерживаемыеВерсии.Вставить("СервисПередачиФайлов", Версии);
//  // Конец СервисПередачиФайлов
//
Процедура ПриОпределенииПоддерживаемыхВерсийПрограммныхИнтерфейсов(ПоддерживаемыеВерсии) Экспорт
	//++ НЕ ГОСИС
	ОбщегоНазначенияЛокализация.ПриОпределенииПоддерживаемыхВерсийПрограммныхИнтерфейсов(ПоддерживаемыеВерсии);
	//-- НЕ ГОСИС
	Возврат // В УТ 11.1 код данного обработчика пустой
	
КонецПроцедуры

// Задает параметры функциональных опций, действие которых распространяется на командный интерфейс и рабочий стол.
// Например, если значения функциональной опции хранятся в ресурсах регистра сведений,
// то параметры функциональных опций могут определять условия отборов по измерениям регистра,
// которые будут применяться при чтении значения этой функциональной опции.
//
// См. в синтакс-помощнике методы ПолучитьФункциональнуюОпциюИнтерфейса,
// УстановитьПараметрыФункциональныхОпцийИнтерфейса и ПолучитьПараметрыФункциональныхОпцийИнтерфейса.
//
// Параметры:
//   ОпцииИнтерфейса - Структура - значения параметров функциональных опций, установленных для командного интерфейса.
//       Ключ элемента структуры определяет имя параметра, а значение элемента - текущее значение параметра.
//
Процедура ПриОпределенииПараметровФункциональныхОпцийИнтерфейса(ОпцииИнтерфейса) Экспорт
	
КонецПроцедуры


// Вызывается при запуске сеанса для получения списка оповещений
// которые необходимо отправить с сервера на клиент (из регламентного задания).
// Смотри СтандартныеПодсистемыСервер.ПриОтправкеСерверногоОповещения
// и СтандартныеПодсистемыКлиент.ПриПолученииСерверногоОповещения.
//
// Параметры:
//  Оповещения - Соответствие из КлючИЗначение:
//   * Ключ     - Строка - смотри СерверныеОповещения.НовоеСерверноеОповещение.Имя
//   * Значение - см. СерверныеОповещения.НовоеСерверноеОповещение
//
// Пример:
//	Оповещение = СерверныеОповещения.НовоеСерверноеОповещение(
//		"СтандартныеПодсистемы.ЗавершениеРаботыПользователей.БлокировкаСеансов");
//	Оповещение.ИмяМодуляОтправки  = "СоединенияИБ";
//	Оповещение.ИмяМодуляПолучения = "СоединенияИБКлиент";
//	Оповещение.ПериодПроверки = 300;
//	
//	Оповещения.Вставить(Оповещение.Имя, Оповещение);
//
Процедура ПриДобавленииСерверныхОповещений(Оповещения) Экспорт

	//++ НЕ ГОСИС
	
	ОбщегоНазначенияЛокализация.ПриДобавленииСерверныхОповещений(Оповещения);

	//-- НЕ ГОСИС
	
КонецПроцедуры

// Вызывается из глобального обработчика ожидания по необходимости, но не чаще раза в 60 сек,
// для получения данных с клиента, а также возврате результата на клиент, если нужно.
// Например, для передачи статистики о количестве открытых окон и
// возврате признака дальнейшей передачи статистики с клиента на сервер.
//
// Для получения данных клиента на сервере они должны быть заполнены в параметре Параметры процедуры
// ОбщегоНазначенияКлиентПереопределяемый.ПередПериодическойОтправкойДанныхКлиентаНаСервер.
//
// Для возврата данных с сервера на клиент заполните параметр Результаты,
// который затем будет передан в процедуру
// ОбщегоНазначенияКлиентПереопределяемый.ПослеПериодическогоПолученияДанныхКлиентаНаСервере.
//
// Параметры:
//  Параметры - Соответствие из КлючИЗначение:
//    * Ключ     - Строка       - имя параметра, полученного с клиента.
//    * Значение - Произвольный - значение параметра, полученного с клиента.
//  Результаты - Соответствие из КлючИЗначение:
//    * Ключ     - Строка       - имя параметра, возвращаемого на клиент.
//    * Значение - Произвольный - значение параметра, возвращаемого на клиент.
//
// Пример:
//	МоментНачала = ТекущаяУниверсальнаяДатаВМиллисекундах();
//	Попытка
//		Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ЦентрМониторинга") Тогда
//			МодульЦентрМониторингаСлужебный = ОбщегоНазначения.ОбщийМодуль("ЦентрМониторингаСлужебный");
//			МодульЦентрМониторингаСлужебный.ПриПериодическомПолученииДанныхКлиентаНаСервере(Параметры, Результаты);
//		КонецЕсли;
//	Исключение
//		СерверныеОповещения.ОбработатьОшибку(ИнформацияОбОшибке());
//	КонецПопытки;
//	СерверныеОповещения.ДобавитьПоказатель(Результаты, МоментНачала,
//		"ЦентрМониторингаСлужебный.ПриПериодическомПолученииДанныхКлиентаНаСервере");
//
Процедура ПриПериодическомПолученииДанныхКлиентаНаСервере(Параметры, Результаты) Экспорт
	
	//++ НЕ ГОСИС
	
	ОбщегоНазначенияЛокализация.ПриПериодическомПолученииДанныхКлиентаНаСервере(Параметры, Результаты);

	//-- НЕ ГОСИС
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработчики отправки и получения данных для обмена в распределенной информационной базе.

// Дополнительный обработчик одноименного события, возникающего при обмене данными в распределенной информационной базе.
// Выполняется после выполнения базовых алгоритмов библиотеки.
// Не выполняется, если отправка элемента данных была проигнорирована ранее.
//
// Параметры:
//  Источник                  - ПланОбменаОбъект - узел, для которого выполняется обмен.
//  ЭлементДанных             - Произвольный - см. описание одноименного обработчика в синтакс-помощнике.
//  ОтправкаЭлемента          - ОтправкаЭлементаДанных - см. описание одноименного обработчика в синтакс-помощнике.
//  СозданиеНачальногоОбраза  - Булево - см. описание одноименного обработчика в синтакс-помощнике.
//
Процедура ПриОтправкеДанныхПодчиненному(Источник, ЭлементДанных, ОтправкаЭлемента, СозданиеНачальногоОбраза) Экспорт
	
КонецПроцедуры

// Дополнительный обработчик одноименного события, возникающего при обмене данными в распределенной информационной базе.
// Выполняется после выполнения базовых алгоритмов библиотеки.
// Не выполняется, если отправка элемента данных была проигнорирована ранее.
//
// Параметры:
//  Источник          - ПланОбменаОбъект - узел, для которого выполняется обмен.
//  ЭлементДанных     - Произвольный - см. описание одноименного обработчика в синтакс-помощнике.
//  ОтправкаЭлемента  - ОтправкаЭлементаДанных - см. описание одноименного обработчика в синтакс-помощнике.
//
Процедура ПриОтправкеДанныхГлавному(Источник, ЭлементДанных, ОтправкаЭлемента) Экспорт
	
КонецПроцедуры

// Дополнительный обработчик одноименного события, возникающего при обмене данными в распределенной информационной базе.
// Выполняется после выполнения базовых алгоритмов библиотеки.
// Не выполняется, если получение элемента данных было проигнорировано ранее.
//
// Параметры:
//  Источник          - ПланОбменаОбъект - узел, для которого выполняется обмен.
//  ЭлементДанных     - Произвольный - см. описание одноименного обработчика в синтакс-помощнике.
//  ПолучениеЭлемента - ПолучениеЭлементаДанных - см. описание одноименного обработчика в синтакс-помощнике.
//  ОтправкаНазад     - Булево - см. описание одноименного обработчика в синтакс-помощнике.
//
Процедура ПриПолученииДанныхОтПодчиненного(Источник, ЭлементДанных, ПолучениеЭлемента, ОтправкаНазад) Экспорт
	
КонецПроцедуры

// Дополнительный обработчик одноименного события, возникающего при обмене данными в распределенной информационной базе.
// Выполняется после выполнения базовых алгоритмов библиотеки.
// Не выполняется, если получение элемента данных было проигнорировано ранее.
//
// Параметры:
//  Источник          - ПланОбменаОбъект - узел, для которого выполняется обмен.
//  ЭлементДанных     - Произвольный - см. описание одноименного обработчика в синтакс-помощнике.
//  ПолучениеЭлемента - ПолучениеЭлементаДанных - см. описание одноименного обработчика в синтакс-помощнике.
//  ОтправкаНазад     - Булево - см. описание одноименного обработчика в синтакс-помощнике.
//
Процедура ПриПолученииДанныхОтГлавного(Источник, ЭлементДанных, ПолучениеЭлемента, ОтправкаНазад) Экспорт
	
КонецПроцедуры

// Позволяет изменить признак того, что версия программы является, либо не является базовой.
//
// Параметры:
//  ЭтоБазовая - Булево - признак того, что версия программы является базовой. По умолчанию Истина, если в имени
//                        программы есть слово "Базовая".
// 
Процедура ПриОпределенииПризнакаЭтоБазоваяВерсияКонфигурации(ЭтоБазовая) Экспорт 
	
КонецПроцедуры

#КонецОбласти
