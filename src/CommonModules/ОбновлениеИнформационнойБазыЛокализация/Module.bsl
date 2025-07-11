#Область СведенияОБиблиотекеИлиКонфигурации

// Заполняет основные сведения о библиотеке или основной конфигурации.
// Библиотека, имя которой имя совпадает с именем конфигурации в метаданных, определяется как основная конфигурация.
// 
// Параметры:
//  Описание - Структура - сведения о библиотеке:
//
//   * Имя                 - Строка - имя библиотеки, например, "СтандартныеПодсистемы".
//   * Версия              - Строка - версия в формате из 4-х цифр, например, "2.1.3.1".
//
//   * ТребуемыеПодсистемы - Массив - имена других библиотек (Строка), от которых зависит данная библиотека.
//                                    Обработчики обновления таких библиотек должны быть вызваны ранее
//                                    обработчиков обновления данной библиотеки.
//                                    При циклических зависимостях или, напротив, отсутствии каких-либо зависимостей,
//                                    порядок вызова обработчиков обновления определяется порядком добавления модулей
//                                    в процедуре ПриДобавленииПодсистем общего модуля
//                                    ПодсистемыКонфигурацииПереопределяемый.
//   * РежимВыполненияОтложенныхОбработчиков - Строка - "Последовательно" - отложенные обработчики обновления выполняются
//                                    последовательно в интервале от номера версии информационной базы до номера
//                                    версии конфигурации включительно или "Параллельно" - отложенный обработчик после
//                                    обработки первой порции данных передает управление следующему обработчику, а после
//                                    выполнения последнего обработчика цикл повторяется заново.
//
Процедура ПриДобавленииПодсистемы(Описание) Экспорт
	
	Описание.Имя    = "Локализация" + ?(СтандартныеПодсистемыСервер.ЭтоБазоваяВерсияКонфигурации(), "Базовая", "");
	Описание.Версия = "2.5.17.219";
	Описание.РежимВыполненияОтложенныхОбработчиков = "Параллельно";
	
КонецПроцедуры

// См. ОбновлениеИнформационнойБазыПереопределяемый.ПриОпределенииНастроек
Процедура ПриОпределенииНастроек(Параметры) Экспорт
	
	//++ Локализация
	
	Объекты = Параметры.ОбъектыСНачальнымЗаполнением;
	
	ЭлектронноеВзаимодействие.ПриОпределенииНастроекОбновленияИнформационнойБазы(Параметры);
	
	//++ НЕ УТ
	Объекты.Добавить(Метаданные.Справочники.ВариантыНалогообложенияПрибыли);
	Объекты.Добавить(Метаданные.Справочники.ДрагоценныеМатериалы);
	//-- НЕ УТ
	
	//-- Локализация
		
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиОбновленияИнформационнойБазы

// См. ОбновлениеИнформационнойБазыБСП.ПриДобавленииОбработчиковОбновления
//
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт
	
	//++ Локализация
	
	ОбновлениеИнформационнойБазыЛокализация.ПриДобавленииОбработчиковОбновленияЛокализация(Обработчики);
	РегистрыСведений.СчетаФактурыКомиссионерамКОформлению.ПриДобавленииОбработчиковОбновления(Обработчики);
	
	Справочники.УчетныеЗаписиМаркетплейсов.ПриДобавленииОбработчиковОбновления(Обработчики);
	РегистрыСведений.СтатусыПубликацииТоваровЯндексМаркет.ПриДобавленииОбработчиковОбновления(Обработчики);
	РегистрыСведений.СтатусыПубликацииОбъектовМаркетплейсаOzon.ПриДобавленииОбработчиковОбновления(Обработчики);
	РегистрыСведений.СоответствияОбъектовМаркетплейсов.ПриДобавленииОбработчиковОбновления(Обработчики);
	Справочники.БанковскиеСчетаКонтрагентов.ПриДобавленииОбработчиковОбновления(Обработчики);
	Константы.НастройкиСервисаПрогнозирования.ПриДобавленииОбработчиковОбновления(Обработчики);
	
	//++ НЕ УТ
	ПланыСчетов.Хозрасчетный.ПриДобавленииОбработчиковОбновления(Обработчики);
	РегистрыСведений.УчетнаяПолитикаБухУчета.ПриДобавленииОбработчиковОбновления(Обработчики);
	РегистрыСведений.РасчетНалогаНаИмущество.ПриДобавленииОбработчиковОбновления(Обработчики);
	РегистрыСведений.НастройкаПереходаНаФСБУ5.ПриДобавленииОбработчиковОбновления(Обработчики);
	РегистрыСведений.ПорядокУплатыНалоговПоРегионам.ПриДобавленииОбработчиковОбновления(Обработчики);
	Справочники.ИсточникиПоступленияЦелевыхСредств.ПриДобавленииОбработчиковОбновления(Обработчики);
	Справочники.НаправленияРасходованияЦелевыхСредств.ПриДобавленииОбработчиковОбновления(Обработчики);
	РегистрыСведений.РегистрацииВНалоговомОргане.ПриДобавленииОбработчиковОбновления(Обработчики);
	Документы.ОтражениеЗарплатыВФинансовомУчете.ПриДобавленииОбработчиковОбновления(Обработчики);
	
	РегистрыСведений.РасчетЗемельногоНалога.ПриДобавленииОбработчиковОбновления(Обработчики);
	РегистрыСведений.ПараметрыНачисленияЗемельногоНалога.ПриДобавленииОбработчиковОбновления(Обработчики);
	Документы.ПерерасчетИмущественныхНалогов.ПриДобавленииОбработчиковОбновления(Обработчики);
	Справочники.ОснованияЛьготПоИмущественнымНалогам.ПриДобавленииОбработчиковОбновления(Обработчики);
	РегистрыСведений.СтавкиНалогаНаПрибыльДляВсехОрганизаций.ПриДобавленииОбработчиковОбновления(Обработчики);
	Документы.КонтролируемаяСделка.ПриДобавленииОбработчиковОбновления(Обработчики);
	//-- НЕ УТ
	
	РегистрыСведений.НастройкиУчетаНДСПриУСН.ПриДобавленииОбработчиковОбновления(Обработчики);
	ОрганизацииЛокализация.ПриДобавленииОбработчиковОбновления(Обработчики);
	
	//-- Локализация
	
КонецПроцедуры

// Позволяет переопределить очередь отложенных обработчиков обновления, выполняемых в
// параллельном режиме. Может понадобиться, когда отложенные обработчики библиотек
// обрабатывают те же данные, что и обработчики основной конфигурации.
// Например, есть обработчики библиотеки и конфигурации, которые обрабатывают справочник
// Контрагенты, при этом обработчик конфигурации должен выполниться раньше, чтобы данные
// обновились корректно. В таком случае в данной процедуре нужно указать новый номер очереди
// для обработчика библиотеки, который будет больше, чем у обработчика конфигурации.
//
// Параметры:
//  ОбработчикИОчередь - Соответствие - где:
//    * Ключ     - Строка - полное имя обработчика обновления.
//    * Значение - Число  - номер очереди, который необходимо установить обработчику.
//
Процедура ПриФормированииОчередейОтложенныхОбработчиков(ОбработчикИОчередь) Экспорт

	//++ Локализация
	//-- Локализация
	Возврат;

КонецПроцедуры

// Вызывается перед процедурами-обработчиками обновления данных ИБ.
//
Процедура ПередОбновлениемИнформационнойБазы() Экспорт
	
КонецПроцедуры

// Вызывается после завершения обновления данных ИБ.
// 
// Параметры:
//   ПредыдущаяВерсия       - Строка - версия до обновления. "0.0.0.0" для "пустой" ИБ.
//   ТекущаяВерсия          - Строка - версия после обновления.
//   ВыполненныеОбработчики - ДеревоЗначений - список выполненных процедур-обработчиков обновления,
//                                             сгруппированных по номеру версии.
//   ВыводитьОписаниеОбновлений - Булево - (возвращаемое значение) если установить Истина,
//                                то будет выведена форма с описанием обновлений. По умолчанию, Истина.
//   МонопольныйРежим           - Булево - Истина, если обновление выполнялось в монопольном режиме.
//
// Пример обхода выполненных обработчиков обновления:
//
//	Для Каждого Версия Из ВыполненныеОбработчики.Строки Цикл
//		
//		Если Версия.Версия = "*" Тогда
//			// Обработчик, который может выполнятся при каждой смене версии.
//		Иначе
//			// Обработчик, который выполняется для определенной версии.
//		КонецЕсли;
//		
//		Для Каждого Обработчик Из Версия.Строки Цикл
//			...
//		КонецЦикла;
//		
//	КонецЦикла;
//
Процедура ПослеОбновленияИнформационнойБазы(Знач ПредыдущаяВерсия, Знач ТекущаяВерсия,
		Знач ВыполненныеОбработчики, ВыводитьОписаниеОбновлений, МонопольныйРежим) Экспорт
	
КонецПроцедуры

// Вызывается при подготовке табличного документа с описанием изменений в программе.
//
// Параметры:
//   Макет - ТабличныйДокумент - описание обновления всех библиотек и конфигурации.
//           Макет можно дополнить или заменить.
//           См. общий макет ОписаниеИзмененийСистемы.
//
Процедура ПриПодготовкеМакетаОписанияОбновлений(Знач Макет) Экспорт
	
КонецПроцедуры
//++ НЕ УТ

// Добавляет в список процедуры-обработчики перехода с другой программы (с другим именем конфигурации).
// Например, для перехода между разными, но родственными конфигурациями: базовая -> проф -> корп.
// Вызывается перед началом обновления данных ИБ.
//
// Параметры:
//  Обработчики - ТаблицаЗначений - с колонками:
//    * ПредыдущееИмяКонфигурации - Строка - имя конфигурации, с которой выполняется переход;
//    * Процедура                 - Строка - полное имя процедуры-обработчика перехода с программы ПредыдущееИмяКонфигурации. 
//                                  Например, "ОбновлениеИнформационнойБазыУПП.ЗаполнитьУчетнуюПолитику"
//                                  Обязательно должна быть экспортной.
//
// Пример добавления процедуры-обработчика в список:
//  Обработчик = Обработчики.Добавить();
//  Обработчик.ПредыдущееИмяКонфигурации  = "УправлениеТорговлей";
//  Обработчик.Процедура                  = "ОбновлениеИнформационнойБазыУПП.ЗаполнитьУчетнуюПолитику";
//
Процедура ПриДобавленииОбработчиковПереходаНаКА(Обработчики) Экспорт
	
	//++ Локализация
	Обработчик = Обработчики.Добавить();
	Обработчик.ПредыдущееИмяКонфигурации = "УправлениеТорговлей";
	Обработчик.Процедура = "ПланыОбмена.СинхронизацияДанныхЧерезУниверсальныйФормат.ПереходСУправлениеТорговлей";
	
	Обработчик = Обработчики.Добавить();
	Обработчик.ПредыдущееИмяКонфигурации = "УправлениеТорговлей";
	Обработчик.Процедура = "ОбновлениеИнформационнойБазыЛокализация.ОбновлениеУТДоКА";
	
	ДобавитьОбработчикиНачальногоЗаполненияЗарплаты(Обработчики);
	//-- Локализация
	
КонецПроцедуры
//++ НЕ УТКА

// Добавляет в список процедуры-обработчики перехода с другой программы (с другим именем конфигурации).
// Например, для перехода между разными, но родственными конфигурациями: базовая -> проф -> корп.
// Вызывается перед началом обновления данных ИБ.
//
// Параметры:
//  Обработчики - ТаблицаЗначений - с колонками:
//    * ПредыдущееИмяКонфигурации - Строка - имя конфигурации, с которой выполняется переход;
//    * Процедура                 - Строка - полное имя процедуры-обработчика перехода с программы ПредыдущееИмяКонфигурации. 
//                                  Например, "ОбновлениеИнформационнойБазыУПП.ЗаполнитьУчетнуюПолитику"
//                                  Обязательно должна быть экспортной.
//
// Пример добавления процедуры-обработчика в список:
//  Обработчик = Обработчики.Добавить();
//  Обработчик.ПредыдущееИмяКонфигурации  = "УправлениеТорговлей";
//  Обработчик.Процедура                  = "ОбновлениеИнформационнойБазыУПП.ЗаполнитьУчетнуюПолитику";
//
Процедура ПриДобавленииОбработчиковПереходаНаУП(Обработчики) Экспорт
	
	//++ Локализация
	Обработчик = Обработчики.Добавить();
	Обработчик.ПредыдущееИмяКонфигурации = "УправлениеТорговлей";
	Обработчик.Процедура = "ПланыОбмена.СинхронизацияДанныхЧерезУниверсальныйФормат.ПереходСУправлениеТорговлей";
	
	Обработчик = Обработчики.Добавить();
	Обработчик.ПредыдущееИмяКонфигурации = "УправлениеТорговлей";
	Обработчик.Процедура = "ОбновлениеИнформационнойБазыЛокализация.ОбновлениеУТДоERP";
	
	Обработчик = Обработчики.Добавить();
	Обработчик.ПредыдущееИмяКонфигурации = "КомплекснаяАвтоматизация";
	Обработчик.Процедура = "ОбновлениеИнформационнойБазыЛокализация.ОбновлениеКАДоERP";
	//-- Локализация
	
КонецПроцедуры
//-- НЕ УТКА

//-- НЕ УТ

// Позволяет переопределить режим обновления данных информационной базы.
// Для использования в редких (нештатных) случаях перехода, не предусмотренных в
// стандартной процедуре определения режима обновления.
//
// Параметры:
//   РежимОбновленияДанных - Строка - в обработчике можно присвоить одно из значений:
//              "НачальноеЗаполнение"     - если это первый запуск пустой базы (области данных);
//              "ОбновлениеВерсии"        - если выполняется первый запуск после обновление конфигурации базы данных;
//              "ПереходСДругойПрограммы" - если выполняется первый запуск после обновление конфигурации базы данных, 
//                                          в которой изменилось имя основной конфигурации.
//
//   СтандартнаяОбработка  - Булево - если присвоить Ложь, то стандартная процедура
//                                    определения режима обновления не выполняется, 
//                                    а используется значение РежимОбновленияДанных.
//
Процедура ПриОпределенииРежимаОбновленияДанных(РежимОбновленияДанных, СтандартнаяОбработка) Экспорт
	
КонецПроцедуры

// Вызывается после выполнения всех процедур-обработчиков перехода с другой программы (с другим именем конфигурации),
// и до начала выполнения обновления данных ИБ.
//
// Параметры:
//  ПредыдущееИмяКонфигурации    - Строка - имя конфигурации до перехода.
//  ПредыдущаяВерсияКонфигурации - Строка - имя предыдущей конфигурации (до перехода).
//  Параметры                    - Структура:
//    * ВыполнитьОбновлениеСВерсии   - Булево - по умолчанию Истина. Если установить Ложь, 
//        то будут выполнена только обязательные обработчики обновления (с версией "*").
//    * ВерсияКонфигурации           - Строка - номер версии после перехода. 
//        По умолчанию, равен значению версии конфигурации в свойствах метаданных.
//        Для того чтобы выполнить, например, все обработчики обновления с версии ПредыдущаяВерсияКонфигурации, 
//        следует установить значение параметра в ПредыдущаяВерсияКонфигурации.
//        Для того чтобы выполнить вообще все обработчики обновления, установить значение "0.0.0.1".
//    * ОчиститьСведенияОПредыдущейКонфигурации - Булево - по умолчанию Истина. 
//        Для случаев когда предыдущая конфигурация совпадает по имени с подсистемой текущей конфигурации, следует
//        указать Ложь.
//
Процедура ПриЗавершенииПереходаСДругойПрограммы(Знач ПредыдущееИмяКонфигурации, 
	Знач ПредыдущаяВерсияКонфигурации, Параметры) Экспорт
	
	
КонецПроцедуры

#КонецОбласти

#Область ПереименованныеОбъектыМетаданных

// Заполняет переименования объектов метаданных (подсистемы и роли).
// Подробнее см. ОбщегоНазначенияПереопределяемый.ПриДобавленииПереименованийОбъектовМетаданных.
// 
// Параметры:
//   Итог	- Структура - передается в процедуру подсистемой БазоваяФункциональность.
//
Процедура ПриДобавленииПереименованийОбъектовМетаданных(Итог) Экспорт
	
	ОписаниеПодсистемы = Новый Структура("Имя, Версия, РежимВыполненияОтложенныхОбработчиков");
	ПриДобавленииПодсистемы(ОписаниеПодсистемы);
	
	//++ Локализация
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"2.3.1.13",
		"Роль.БазовыеПраваЕГАИС",
		"Роль.ВыполнениеСинхронизацииСЕГАИС",
		ОписаниеПодсистемы.Имя);
	//++ НЕ УТ
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"2.1.1.69",
		"Роль.ПроверкаДокументовПравоИзменения",
		"Роль.ИзменениеРазрешатьИзменятьПроверенныеДокументыПоРеглУчету",
		ОписаниеПодсистемы.Имя);
		
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"2.4.2.32",
		"Роль.ДобавлениеИзменениеПогашенийСтоимостиТМЦВЭксплуатации",
		"Роль.ДобавлениеИзменениеПогашенийСтоимостиТМЦВЭксплуатации",
		ОписаниеПодсистемы.Имя);
		
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"2.4.7.14",
		"Роль.ИзменениеРазрешатьИзменятьПроверенныеДокументыПоРеглУчету",
		"Роль.ИзменениеСтатусыПроверкиДокументов",
		ОписаниеПодсистемы.Имя);
		
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"2.5.2.10",
		"Роль.ДобавлениеИзменениеРегистрацийНаработокТМЦВЭксплуатации",
		"Роль.ДобавлениеИзменениеНаработкиТМЦВЭксплуатации",
		ОписаниеПодсистемы.Имя);	
		
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"2.5.9.2",
		"Роль.ДобавлениеИзменениеРегистрацииЗемельныхУчастков",
		"Роль.ДобавлениеИзменениеПараметровНачисленияЗемельногоНалога",
		ОписаниеПодсистемы.Имя);
		
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"2.5.9.2",
		"Роль.ДобавлениеИзменениеРегистрацииТранспортныхСредств",
		"Роль.ДобавлениеИзменениеПараметровНачисленияТранспортногоНалога",
		ОписаниеПодсистемы.Имя);	
		
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"2.5.9.2",
		"Роль.ЧтениеРегистрацииЗемельныхУчастков",
		"Роль.ЧтениеПараметровНачисленияЗемельногоНалога",
		ОписаниеПодсистемы.Имя);	
		
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"2.5.9.2",
		"Роль.ЧтениеРегистрацииТранспортныхСредств",
		"Роль.ЧтениеПараметровНачисленияТранспортногоНалога",
		ОписаниеПодсистемы.Имя);	
	//-- НЕ УТ

	//-- Локализация
		
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ЗаполненияПустойИБ

// Обработчик первого запуска УП (ERP).
//
Процедура ПервыйЗапуск() Экспорт
	
	//++ Локализация
	Справочники.КодыВалютныхОпераций.ЗаполнитьПредопределенныеЭлементы();
	ИнициализироватьПоддержкаПлатежейРФ();
	//++ НЕ УТ
	ЗаполнитьКонстантуИспользоватьРеглУчет();
	Справочники.ТипыПлатежейФЗ275.ЗаполнитьПредопределенныеЭлементы();
	ПланыСчетов.Хозрасчетный.ЗаполнитьПредопределенныеНастройки();
	Справочники.ВидыПодтверждающихДокументов.ЗаполнитьПредопределенныеЭлементы();
	Справочники.ДрагоценныеМатериалы.ЗаполнитьПредопределенныеДрагоценныеМатериалы();
	//++ НЕ УТКА
	Константы.ИсточникСуммыДляПересчетаВВалютуФинОтчетности.Установить(Перечисления.ИсточникиСуммыДляПересчетаВВалютуФинОтчетности.БУ);
	//-- НЕ УТКА

	//-- НЕ УТ

	//-- Локализация
	
КонецПроцедуры
//++ НЕ УТ

Процедура ОбновлениеУТДоКА() Экспорт
	
	//++ Локализация
	Справочники.ТипыПлатежейФЗ275.ЗаполнитьПредопределенныеЭлементы();
	Справочники.ВидыПодтверждающихДокументов.ЗаполнитьПредопределенныеЭлементы();
	ПланыСчетов.Хозрасчетный.ЗаполнитьПредопределенныеНастройки();
	Справочники.ДрагоценныеМатериалы.ЗаполнитьПредопределенныеДрагоценныеМатериалы();
	
	ОбновитьПовторноИспользуемыеЗначения();
	//-- Локализация
	
КонецПроцедуры

Процедура ОбновлениеУТДоERP() Экспорт
	
	//++ Локализация
	Справочники.ТипыПлатежейФЗ275.ЗаполнитьПредопределенныеЭлементы();
	Справочники.ВидыПодтверждающихДокументов.ЗаполнитьПредопределенныеЭлементы();
	Справочники.СтатистическиеПоказатели.ЗаполнитьПоставляемымиПравилами();
	Справочники.ДрагоценныеМатериалы.ЗаполнитьПредопределенныеДрагоценныеМатериалы();
	ПланыСчетов.Хозрасчетный.ЗаполнитьПредопределенныеНастройки();
	Константы.ИсточникСуммыДляПересчетаВВалютуФинОтчетности.Установить(Перечисления.ИсточникиСуммыДляПересчетаВВалютуФинОтчетности.БУ);
	ОбновитьПовторноИспользуемыеЗначения();
	//-- Локализация
	
КонецПроцедуры

Процедура ОбновлениеКАДоERP() Экспорт
	
	//++ Локализация

	//++ НЕ УТКА
	Константы.ИсточникСуммыДляПересчетаВВалютуФинОтчетности.Установить(Перечисления.ИсточникиСуммыДляПересчетаВВалютуФинОтчетности.БУ);
	//-- НЕ УТКА
	ОбновитьПовторноИспользуемыеЗначения();
	//-- Локализация
	
КонецПроцедуры
//++ Локализация

// Обработчики инициализации зарплатной подсистемы при переходе с УТ
Процедура ДобавитьОбработчикиНачальногоЗаполненияЗарплаты(Обработчики)
	
	Обработчик = Обработчики.Добавить();
	Обработчик.ПредыдущееИмяКонфигурации = "УправлениеТорговлей";
	Обработчик.Процедура = "УправлениеСвойствамиСлужебный.СоздатьПредопределенныеНаборыСвойств";
	
	ВсеОбработчикиЗарплаты = ОбновлениеИнформационнойБазы.НоваяТаблицаОбработчиковОбновления();
	ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.ПриДобавленииОбработчиковОбновления(ВсеОбработчикиЗарплаты);
	ОбновлениеИнформационнойБазыЗарплатаКадрыРасширенный.ПриДобавленииОбработчиковОбновления(ВсеОбработчикиЗарплаты);
	
	ОбработчикиНачальногоЗаполнения = ВсеОбработчикиЗарплаты.НайтиСтроки(Новый Структура("НачальноеЗаполнение", Истина));
	Для Каждого ОбработчикНачальногоЗаполнения Из ОбработчикиНачальногоЗаполнения Цикл
		Обработчик = Обработчики.Добавить();
		Обработчик.ПредыдущееИмяКонфигурации = "УправлениеТорговлей";
		Обработчик.Процедура = ОбработчикНачальногоЗаполнения.Процедура;
	КонецЦикла;
	
КонецПроцедуры

// Обработчик первого запуска КА.
// Включает константу "ИспользоватьРеглУчет".
//
Процедура ЗаполнитьКонстантуИспользоватьРеглУчет() Экспорт
	
	Если ПолучитьФункциональнуюОпцию("УправлениеТорговлей") Тогда
		Возврат;
	КонецЕсли;
	
	Константы.ИспользоватьРеглУчет.Установить(Истина);
	
КонецПроцедуры

//-- Локализация

//-- НЕ УТ

#КонецОбласти

#Область Прочее

//++ Локализация

#Область ОбновлениеИнформационнойБазы

// см. ОбновлениеИнформационнойБазыБСП.ПриДобавленииОбработчиковОбновления
Процедура ПриДобавленииОбработчиковОбновленияЛокализация(Обработчики) Экспорт

#Область ПервыйЗапуск

	Обработчик = Обработчики.Добавить();
	Обработчик.Процедура = "ОбновлениеИнформационнойБазыЛокализация.ПервыйЗапуск";
	Обработчик.Версия = "";
	Обработчик.РежимВыполнения = "Монопольно";
	Обработчик.НачальноеЗаполнение = Истина;
	Обработчик.Комментарий = "";

#КонецОбласти

#Область УстановитьКонстантуВариантПроверкиСтатусовСертификатовНоменклатурыРосаккредитации
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Процедура = "ОбновлениеИнформационнойБазыЛокализация.УстановитьКонстантуВариантПроверкиСтатусовСертификатовНоменклатурыРосаккредитации";
	Обработчик.Версия = "2.5.15.31";
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Идентификатор = Новый УникальныйИдентификатор("ba4c5f2c-8098-40a9-9251-4e552d6c4d9f");
	Обработчик.ПроцедураЗаполненияДанныхОбновления = "ОбновлениеИнформационнойБазыЛокализация.ЗарегистрироватьДанныеКОбновлениюКонстанты";
	Обработчик.ПроцедураПроверки = "ОбновлениеИнформационнойБазы.ДанныеОбновленыНаНовуюВерсиюПрограммы";
	Обработчик.Порядок = Перечисления.ПорядокОбработчиковОбновления.Критичный;
	
	Обработчик.Комментарий = НСтр("ru = 'Устанавливает значение по умолчанию для константы ""Вариант проверки статусов сертификатов номенклатуры Росаккредитации"".';
									|en = 'Sets the default value for the ""Status check options of RusAccreditation quality certificates"" constant.'");
	
	Читаемые = Новый Массив;
	Читаемые.Добавить(Метаданные.Константы.ВариантПроверкиСтатусовСертификатовНоменклатурыРосаккредитации.ПолноеИмя());
	
	Обработчик.ЧитаемыеОбъекты = СтрСоединить(Читаемые, ",");
	
	Изменяемые = Новый Массив;
	Изменяемые.Добавить(Метаданные.Константы.ВариантПроверкиСтатусовСертификатовНоменклатурыРосаккредитации.ПолноеИмя());
	Обработчик.ИзменяемыеОбъекты = СтрСоединить(Изменяемые, ",");
	
#КонецОбласти
	
//++ НЕ УТ
	РегистрыСведений.ПорядокОтраженияНаСчетахУчета.ПриДобавленииОбработчиковОбновления(Обработчики);
//-- НЕ УТ

КонецПроцедуры

Процедура ИнициализироватьПоддержкаПлатежейРФ() Экспорт
	
	Если Константы.ПоддержкаПлатежейРФ.Получить() = Ложь Тогда
		МенеджерЗначения = Константы.ПоддержкаПлатежейРФ.СоздатьМенеджерЗначения();
		МенеджерЗначения.Значение = Истина;
		
		ОбновлениеИнформационнойБазы.ЗаписатьДанные(МенеджерЗначения);
	КонецЕсли;
	
КонецПроцедуры
//++ НЕ УТ

#Область УстановкаКонстанты_ДатаНачалаПризнанияДоходовОтчетомОРозничныхПродажах

Процедура ДатаНачалаПризнанияДоходовОтчетомОРозничныхПродажах_ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	// Регистрация не требуется
	Возврат;
	
КонецПроцедуры

Процедура ДатаНачалаПризнанияДоходовОтчетомОРозничныхПродажах_ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	МенеджерЗначения = Константы.ДатаНачалаПризнанияДоходовОтчетомОРозничныхПродажах.СоздатьМенеджерЗначения();
	Запрос = Новый Запрос;
	МассивТекстовЗапроса = Новый Массив;
	ТекстЗапроса =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ОрганизацииНаУСН.Организация КАК Организация,
	|	ОрганизацииНаУСН.Период КАК НачалоПериода,
	|	МИНИМУМ(ЕСТЬNULL(ОстальныеОрганизации.Период, ДАТАВРЕМЯ(2120, 1, 1))) КАК КонецПериода
	|ПОМЕСТИТЬ ВТДанныеПоОрганизациямНаУСН
	|ИЗ
	|	РегистрСведений.НастройкиСистемыНалогообложения КАК ОрганизацииНаУСН
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НастройкиСистемыНалогообложения КАК ОстальныеОрганизации
	|		ПО ОрганизацииНаУСН.Организация = ОстальныеОрганизации.Организация
	|			И ОрганизацииНаУСН.Период < ОстальныеОрганизации.Период
	|			И (НЕ ОстальныеОрганизации.ПрименяетсяУСН)
	|ГДЕ
	|	ОрганизацииНаУСН.ПрименяетсяУСН
	|
	|СГРУППИРОВАТЬ ПО
	|	ОрганизацииНаУСН.Организация,
	|	ОрганизацииНаУСН.Период
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Организация";
	МассивТекстовЗапроса.Добавить(ТекстЗапроса);
	ТекстЗапроса = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	МАКСИМУМ(ЕСТЬNULL(ВложенныйЗапрос.Дата, ДАТАВРЕМЯ(1,1,1))) КАК Дата
	|ИЗ
	|	(ВЫБРАТЬ РАЗЛИЧНЫЕ
	|		МАКСИМУМ(КнигаУчетаДоходовИРасходов.Период) КАК Дата
	|	ИЗ
	|		РегистрНакопления.КнигаУчетаДоходовИРасходов КАК КнигаУчетаДоходовИРасходов
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ПриходныйКассовыйОрдер КАК ПриходныйКассовыйОрдер
	|			ПО (ПриходныйКассовыйОрдер.Ссылка = КнигаУчетаДоходовИРасходов.Регистратор)
	|				И (ПриходныйКассовыйОрдер.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПоступлениеДенежныхСредствИзКассыККМ)
	|					ИЛИ ПриходныйКассовыйОрдер.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПоступлениеДенежныхСредствИзДругойКассы)
	|						И ПриходныйКассовыйОрдер.КассаОтправитель ССЫЛКА Справочник.КассыККМ)
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ РАЗЛИЧНЫЕ
	|		МАКСИМУМ(ОтчетОРозничныхПродажах.Дата)
	|	ИЗ
	|		ВТДанныеПоОрганизациямНаУСН КАК ОрганизациямНаУСН
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ОтчетОРозничныхПродажах КАК ОтчетОРозничныхПродажах
	|			ПО ОрганизациямНаУСН.Организация = ОтчетОРозничныхПродажах.Организация
	|				И (ОтчетОРозничныхПродажах.Дата >= ОрганизациямНаУСН.НачалоПериода)
	|				И (ОтчетОРозничныхПродажах.Дата < ОрганизациямНаУСН.КонецПериода)) КАК ВложенныйЗапрос";
	МассивТекстовЗапроса.Добавить(ТекстЗапроса);
	Запрос.Текст = СтрСоединить(МассивТекстовЗапроса, ОбщегоНазначения.РазделительПакетаЗапросов());
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		НовоеЗначение = ?(ЗначениеЗаполнено(Выборка.Дата), ДобавитьМесяц(НачалоМесяца(Выборка.Дата),1), Выборка.Дата); // начало следующего месяца
		МенеджерЗначения.Значение = НовоеЗначение;
		ОбновлениеИнформационнойБазы.ЗаписатьДанные(МенеджерЗначения);
	КонецЕсли;
	Параметры.ОбработкаЗавершена = Истина
	
КонецПроцедуры

#КонецОбласти
//-- НЕ УТ

#Область УстановкаКонстанты_ВариантПроверкиСтатусовСертификатовНоменклатурыРосаккредитации

// Обработчик регистрации
//
// Параметры:
//	ПараметрыОбновления - См. ОбновлениеИнформационнойБазы.ДополнительныеПараметрыВыборкиДанныхДляМногопоточнойОбработки.
//
Процедура ЗарегистрироватьДанныеКОбновлениюКонстанты(ПараметрыОбновления) Экспорт
	
	// Регистрация не требуется
	Возврат;
	
КонецПроцедуры

// Выполняет инициализацию константы 'ВариантПроверкиСтатусовСертификатовНоменклатурыРосаккредитации' значением
// по умолчанию.
//
// Параметры:
//	ПараметрыОбновления - См. ОбновлениеИнформационнойБазы.ДополнительныеПараметрыВыборкиДанныхДляМногопоточнойОбработки.
//
Процедура УстановитьКонстантуВариантПроверкиСтатусовСертификатовНоменклатурыРосаккредитации(ПараметрыОбновления) Экспорт
	
	ПараметрыОбновления.ОбработкаЗавершена = Ложь;
	
	КонстантаМенеджер = Константы.ВариантПроверкиСтатусовСертификатовНоменклатурыРосаккредитации;
	
	Если Не ЗначениеЗаполнено(КонстантаМенеджер.Получить()) Тогда
		МенеджерЗначения = КонстантаМенеджер.СоздатьМенеджерЗначения();
		МенеджерЗначения.Значение = Перечисления.ВариантыПроверкиСтатусовСертификатовНоменклатурыРосаккредитации.ПроверятьИОбновлятьСтатусДействия;
		
		ОбновлениеИнформационнойБазы.ЗаписатьДанные(МенеджерЗначения);
	КонецЕсли;
	
	ПараметрыОбновления.ОбработкаЗавершена = Истина;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
//-- Локализация

#КонецОбласти

#КонецОбласти
