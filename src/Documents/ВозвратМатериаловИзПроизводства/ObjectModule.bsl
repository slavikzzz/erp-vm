//++ Устарело_Производство21
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Устанавливает статус для объекта документа
//
// Параметры:
//	НовыйСтатус - Строка - Имя статуса, который будет установлен у заказов
//	ДополнительныеПараметры - Структура - Структура дополнительных параметров установки статуса.
//
// Возвращаемое значение:
//	Булево - Истина, в случае успешной установки нового статуса.
//
Функция УстановитьСтатус(НовыйСтатус, ДополнительныеПараметры) Экспорт
	
	Статус = Перечисления.СтатусыВозвратовМатериаловИзПроизводства[НовыйСтатус];
	
	ПараметрыУказанияСерий = НоменклатураСервер.ПараметрыУказанияСерий(ЭтотОбъект, Документы.ВозвратМатериаловИзПроизводства);
	НоменклатураСервер.ЗаполнитьСтатусыУказанияСерий(ЭтотОбъект, ПараметрыУказанияСерий);
	Возврат ПроверитьЗаполнение();
	
КонецФункции

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
 	Перем РеквизитыШапки;
	
	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	
	Если ТипДанныхЗаполнения = Тип("ДокументСсылка.ПередачаМатериаловВПроизводство") Тогда
		
		ЗаполнитьДокументНаОснованииПередачиВПроизводство(ДанныеЗаполнения);
	//++ НЕ УТКА
	ИначеЕсли ТипДанныхЗаполнения = Тип("ДокументСсылка.МаршрутныйЛистПроизводства") Тогда
		
		ЗаполнитьДокументНаОснованииМаршрутногоЛиста(ДанныеЗаполнения);
	//-- НЕ УТКА
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("Структура") И ДанныеЗаполнения.Свойство("Товары") Тогда
		
		ДанныеЗаполнения.Свойство("РеквизитыШапки", РеквизитыШапки);
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, РеквизитыШапки);
		
		Для Каждого Строка Из ДанныеЗаполнения.Товары Цикл
			НоваяСтрока = Товары.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, Строка);
			НоваяСтрока.НазначениеОтправителя = НоваяСтрока.Назначение;
		КонецЦикла;
	//++ НЕ УТКА
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("Структура")
		И ДанныеЗаполнения.Свойство("Подразделение")
		И НЕ ДанныеЗаполнения.Свойство("Склад") Тогда
		НастройкаПередачиМатериалов = РегистрыСведений.НастройкаПередачиМатериаловВПроизводство.ПолучитьНастройкуПередачиМатериаловПроизводство(ДанныеЗаполнения.Подразделение);
		Склад = НастройкаПередачиМатериалов.Склад;
	//-- НЕ УТКА
	КонецЕсли;
	
	ПараметрыПолученияКоэффициентаРНПТ = УчетПрослеживаемыхТоваровКлиентСерверЛокализация.ПараметрыПолученияКоэффициентаРНПТ(
											ЭтотОбъект);
	УчетПрослеживаемыхТоваровЛокализация.ЗаполнитьКоличествоПоРНПТВТабличнойЧасти(ПараметрыПолученияКоэффициентаРНПТ,
																					Товары);
	
	ИнициализироватьДокумент(ДанныеЗаполнения);
	
	ПараметрыПолученияКоэффициентаРНПТ = УчетПрослеживаемыхТоваровКлиентСерверЛокализация.ПараметрыПолученияКоэффициентаРНПТ(
											ЭтотОбъект);
	УчетПрослеживаемыхТоваровЛокализация.ЗаполнитьКоличествоПоРНПТВТабличнойЧасти(ПараметрыПолученияКоэффициентаРНПТ,
																					Товары);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Серии.Очистить();
	СостояниеЗаполненияМногооборотнойТары = Перечисления.СостоянияЗаполненияМногооборотнойТары.ПустаяСсылка();
	
	ИнициализироватьДокумент();
	
	ПараметрыПолученияКоэффициентаРНПТ = УчетПрослеживаемыхТоваровКлиентСерверЛокализация.ПараметрыПолученияКоэффициентаРНПТ(
											ЭтотОбъект);
	УчетПрослеживаемыхТоваровЛокализация.ЗаполнитьКоличествоПоРНПТВТабличнойЧасти(ПараметрыПолученияКоэффициентаРНПТ,
																					Товары);
	
	ОбщегоНазначенияУТ.ОчиститьИдентификаторыДокумента(ЭтотОбъект, "Товары");
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли; 
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ПроведениеДокументов.ПередЗаписьюДокумента(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	
	НоменклатураСервер.ОкруглитьКоличествоШтучныхТоваров(ЭтотОбъект, РежимЗаписи);
	
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		МестаУчета = РегистрыСведений.АналитикаУчетаНоменклатуры.МестаУчета(ХозяйственнаяОперация, Склад, Подразделение, НЕОПРЕДЕЛЕНО);
		РегистрыСведений.АналитикаУчетаНоменклатуры.ЗаполнитьВКоллекции(Товары, МестаУчета);
		ЗаполнитьВидыЗапасовДокумента(Отказ);
	КонецЕсли;
	
	ОбщегоНазначенияУТ.ЗаполнитьИдентификаторыДокумента(ЭтотОбъект, "Товары");
	
	НоменклатураСервер.ОчиститьНеиспользуемыеСерии(
		ЭтотОбъект,
		НоменклатураСервер.ПараметрыУказанияСерий(ЭтотОбъект, Документы.ВозвратМатериаловИзПроизводства));
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПроведениеДокументов.ПриЗаписиДокумента(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	НоменклатураСервер.ПроверитьЗаполнениеКоличества(ЭтотОбъект, ПроверяемыеРеквизиты, Отказ);
	НоменклатураСервер.ПроверитьЗаполнениеХарактеристик(ЭтотОбъект,МассивНепроверяемыхРеквизитов,Отказ);
	
	НоменклатураСервер.ПроверитьЗаполнениеСерий(
		ЭтотОбъект,
		НоменклатураСервер.ПараметрыУказанияСерий(ЭтотОбъект, Документы.ВозвратМатериаловИзПроизводства),
		Отказ,
		МассивНепроверяемыхРеквизитов);
	
	МассивНепроверяемыхРеквизитов.Добавить("Товары.НомерГТД");
	МассивНепроверяемыхРеквизитов.Добавить("Товары.КоличествоПоРНПТ");
	
	ЭтоПрослеживаемыйДокумент = УчетПрослеживаемыхТоваровЛокализация.ЭтоПрослеживаемыйДокумент(Товары, Дата);
	
	Если ЭтоПрослеживаемыйДокумент
		Или ПолучитьФункциональнуюОпцию("ЗапретитьПоступлениеТоваровБезНомеровГТД") Тогда
		
		ЗапасыСервер.ПроверитьЗаполнениеНомеровГТД(ЭтотОбъект, Отказ);
		УчетПрослеживаемыхТоваровЛокализация.ПроверитьДанныеПрослеживаемостиНомеровГТД(ЭтотОбъект, Товары, Дата);
		
	КонецЕсли;
	
	Если ЭтоПрослеживаемыйДокумент Тогда
		УчетПрослеживаемыхТоваровЛокализация.ПроверитьКорректностьНастроекТоваровРНПТ(ЭтотОбъект, Товары, Дата);
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ДополнительныеСвойства.Вставить("ПараметрыЗаполненияВидовЗапасов", ЗапасыСервер.ПараметрыЗаполненияВидовЗапасов());
	
	ПроведениеДокументов.ОбработкаПроведенияДокумента(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ДополнительныеСвойства.Вставить("ПараметрыЗаполненияВидовЗапасов", ЗапасыСервер.ПараметрыЗаполненияВидовЗапасов());
	
	ПроведениеДокументов.ОбработкаУдаленияПроведенияДокумента(ЭтотОбъект, Отказ);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Параметры:
//    Таблица - см. УправлениеДоступом.ТаблицаНаборыЗначенийДоступа
Процедура ЗаполнитьНаборыЗначенийДоступа(Таблица) Экспорт
	
	СтрокаТаб = Таблица.Добавить();
	СтрокаТаб.ЗначениеДоступа = Организация;
	
	СтрокаТаб = Таблица.Добавить();
	СтрокаТаб.ЗначениеДоступа = Склад;
	
	СтрокаТаб = Таблица.Добавить();
	СтрокаТаб.ЗначениеДоступа = Подразделение;
	
КонецПроцедуры

#Область ИнициализацияИЗаполнение

//++ НЕ УТКА

Процедура ЗаполнитьДокументНаОснованииМаршрутногоЛиста(Знач ДокументОснование)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	МаршрутныйЛистПроизводства.Ссылка КАК ДокументОснование,
	|	МаршрутныйЛистПроизводства.Подразделение КАК Подразделение,
	|	МаршрутныйЛистПроизводства.Организация КАК Организация
	|ИЗ
	|	Документ.МаршрутныйЛистПроизводства КАК МаршрутныйЛистПроизводства
	|ГДЕ
	|	МаршрутныйЛистПроизводства.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Товары.Номенклатура КАК Номенклатура,
	|	Товары.Характеристика КАК Характеристика,
	|	Товары.Количество - Товары.КоличествоФакт КАК Количество,
	|	Товары.КоличествоУпаковок - Товары.КоличествоУпаковокФакт КАК КоличествоУпаковок,
	|	Товары.Упаковка КАК Упаковка,
	|	Товары.Назначение КАК Назначение,
	|	Товары.Назначение КАК НазначениеОтправителя
	|ИЗ
	|	Документ.МаршрутныйЛистПроизводства.МатериалыИУслуги КАК Товары
	|ГДЕ
	|	Товары.Ссылка = &Ссылка
	|	И Товары.Количество - Товары.КоличествоФакт > 0
	|	И Товары.Номенклатура.ТипНоменклатуры В(
	|		ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Товар),
	|		ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.МногооборотнаяТара))";
	
	Запрос.УстановитьПараметр("Ссылка", ДокументОснование);
	
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	ВыборкаШапка = МассивРезультатов[0].Выбрать();
	ВыборкаШапка.Следующий();
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ВыборкаШапка);
	
	Товары.Загрузить(МассивРезультатов[1].Выгрузить());
	
КонецПроцедуры

//-- НЕ УТКА

Процедура ЗаполнитьДокументНаОснованииПередачиВПроизводство(Знач ДокументОснование)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПередачаМатериаловВПроизводство.Ссылка КАК ДокументОснование,
	|	ПередачаМатериаловВПроизводство.Склад КАК Склад,
	|	ПередачаМатериаловВПроизводство.Подразделение КАК Подразделение,
	|	ПередачаМатериаловВПроизводство.Организация КАК Организация,
	|	НЕ ПередачаМатериаловВПроизводство.Проведен КАК ЕстьОшибкиПроведен
	|ИЗ
	|	Документ.ПередачаМатериаловВПроизводство КАК ПередачаМатериаловВПроизводство
	|ГДЕ
	|	ПередачаМатериаловВПроизводство.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Товары.Номенклатура КАК Номенклатура,
	|	Товары.Характеристика КАК Характеристика,
	|	Товары.Упаковка КАК Упаковка,
	|	Товары.КоличествоУпаковок КАК КоличествоУпаковок,
	|	Товары.Количество КАК Количество,
	|	Товары.Назначение КАК Назначение,
	|	Товары.Назначение КАК НазначениеОтправителя
	|ИЗ
	|	Документ.ПередачаМатериаловВПроизводство.Товары КАК Товары
	|ГДЕ
	|	Товары.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", ДокументОснование);
	
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	ВыборкаШапка = МассивРезультатов[0].Выбрать();
	ВыборкаШапка.Следующий();
	
	ОбщегоНазначенияУТ.ПроверитьВозможностьВводаНаОсновании(ДокументОснование, , ВыборкаШапка.ЕстьОшибкиПроведен);
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ВыборкаШапка);
	
	Товары.Загрузить(МассивРезультатов[1].Выгрузить());
	
КонецПроцедуры

Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено)

	Ответственный = Пользователи.ТекущийПользователь();

	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") И НЕ ДанныеЗаполнения.Свойство("Организация") Тогда	
		Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	КонецЕсли;
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") И НЕ ДанныеЗаполнения.Свойство("Подразделение") Тогда	
		Подразделение = ЗначениеНастроекПовтИсп.ПодразделениеПользователя(Ответственный, Подразделение);
	КонецЕсли;
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда	
		Если ДанныеЗаполнения.Свойство("Склад") Тогда
			Склад = ДанныеЗаполнения.Склад;
		Иначе
			Склад = ЗначениеНастроекПовтИсп.ПолучитьСкладПоУмолчанию(Склад);
		КонецЕсли;
	КонецЕсли;
	
	ВидЦены = Справочники.Склады.УчетныйВидЦены(Склад);
	
	ВариантПриемкиТоваров = ЗакупкиСервер.ПолучитьВариантПриемкиТоваров();
	
КонецПроцедуры

#КонецОбласти

#Область ВидыЗапасов

Процедура ЗаполнитьВидыЗапасовДокумента(Отказ)
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	МенеджерВременныхТаблиц = ВременныеТаблицыДанныхДокумента();
	
	//++ НЕ УТКА
	
	//++ Устарело_Переработка24
	
	// заполнение видов запасов давальца
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	ТаблицаТоваров.Организация                  КАК Организация,
	|	ТаблицаТоваров.НалогообложениеОрганизации   КАК НалогообложениеОрганизации,
	|	ТаблицаТоваров.НомерСтроки                  КАК НомерСтроки,
	|	ТаблицаТоваров.ВладелецТовара               КАК ВладелецТовара,
	|	ТаблицаТоваров.Договор                      КАК Договор,
	|	ТаблицаТоваров.Контрагент                   КАК Контрагент,
	|	ТаблицаТоваров.ТипЗапасов                   КАК ТипЗапасов,
	|	ТаблицаТоваров.ГруппаФинансовогоУчета       КАК ГруппаФинансовогоУчета
	|ИЗ
	|	ВтТоварыДавальца КАК ТаблицаТоваров");
	
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Товары[Выборка.НомерСтроки - 1].ВидЗапасов = Справочники.ВидыЗапасов.ВидЗапасовДокумента(Организация,,Выборка);
	КонецЦикла;
	//-- Устарело_Переработка24
	
	//-- НЕ УТКА
	
	// заполнение видов запасов для остальных строк
	ЗапасыСервер.ЗаполнитьВидыЗапасовПоУмолчанию(МенеджерВременныхТаблиц, Товары);
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

// Функция формирует временные таблицы данных документа.
//
// Возвращаемое значение:
//	МенеджерВременныхТаблиц - менеджер временных таблиц.
//
Функция ВременныеТаблицыДанныхДокумента() Экспорт
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	ТаблицаТоваров.НомерСтроки КАК НомерСтроки,
	|	ТаблицаТоваров.Номенклатура КАК Номенклатура,
	|	ТаблицаТоваров.Назначение КАК Назначение,
	|	ТаблицаТоваров.ВидЗапасов КАК ВидЗапасов
	|ПОМЕСТИТЬ ВтИсходнаяТаблицаТоваров
	|ИЗ
	|	&ТаблицаТоваров КАК ТаблицаТоваров
	|ГДЕ
	|	ТаблицаТоваров.ВидЗапасов = ЗНАЧЕНИЕ(Справочник.ВидыЗапасов.ПустаяСсылка)
	|	ИЛИ &ПерезаполнитьВидыЗапасов
	|;
	//++ НЕ УТКА

	//++ Устарело_Переработка24
	|
	|////////////////////////////////////////////////////////////////////////////////
	// возврат давальческих материалов из производства
	// давальческий вид запасов при возврате заполняется если возврат осуществляется:
	//    - под заказ давальца
	//    - под давальческое назначение (партнер заполнен).
	|ВЫБРАТЬ
	|	&Организация                                                      КАК Организация,
	|	&НалогообложениеОрганизации                                       КАК НалогообложениеОрганизации,
	|	ТаблицаТоваров.НомерСтроки                                        КАК НомерСтроки,
	|	ЕСТЬNULL(ЗаказДавальца.Партнер, Назначения.Партнер)               КАК ВладелецТовара,
	|	ЕСТЬNULL(ЗаказДавальца.Договор, Назначения.Договор)               КАК Договор,
	|	ЕСТЬNULL(ЗаказДавальца.Контрагент, Назначения.Договор.Контрагент) КАК Контрагент,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.МатериалДавальца)               КАК ТипЗапасов,
	|	ВЫБОР
	|		КОГДА &ФормироватьВидыЗапасовПоГруппамФинансовогоУчета
	|			ТОГДА СпрНоменклатура.ГруппаФинансовогоУчета
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.ГруппыФинансовогоУчетаНоменклатуры.ПустаяСсылка)
	|	КОНЕЦ                                                             КАК ГруппаФинансовогоУчета
	|ПОМЕСТИТЬ ВтТоварыДавальца
	|ИЗ
	|	ВтИсходнаяТаблицаТоваров КАК ТаблицаТоваров
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Назначения КАК Назначения
	|		ПО ТаблицаТоваров.Назначение = Назначения.Ссылка
	|	ЛЕВОЕ СОЕДИНЕНИЕ Документ.ЗаказДавальца КАК ЗаказДавальца
	|		ПО ЗаказДавальца.Ссылка = Назначения.Заказ
	|	ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК СпрНоменклатура
	|		ПО ТаблицаТоваров.Номенклатура = СпрНоменклатура.Ссылка
	|ГДЕ
	|	(НЕ ЗаказДавальца.Ссылка ЕСТЬ NULL
	|		ИЛИ Назначения.ТипНазначения = ЗНАЧЕНИЕ(Перечисление.ТипыНазначений.Давальческое21))
	|	И ТаблицаТоваров.ВидЗапасов = ЗНАЧЕНИЕ(Справочник.ВидыЗапасов.ПустаяСсылка)
	|;
	//-- Устарело_Переработка24

	//-- НЕ УТКА
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаТоваров.НомерСтроки КАК НомерСтроки,
	|	ТаблицаТоваров.Номенклатура КАК Номенклатура,
	|	ВЫБОР
	|		КОГДА &Проведен
	|			ТОГДА ТаблицаТоваров.ВидЗапасов
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.ВидыЗапасов.ПустаяСсылка)
	|	КОНЕЦ КАК ТекущийВидЗапасов,
	|	ЛОЖЬ КАК ЭтоВозвратнаяТара,
	|	&Организация КАК Организация,
	|	ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ОприходованиеТоваров) КАК ХозяйственнаяОперация,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.Товар) КАК ТипЗапасов,
	|	ЗНАЧЕНИЕ(Справочник.СоглашенияСПоставщиками.ПустаяСсылка) КАК Соглашение,
	|	ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка) КАК Контрагент,
	|	ЗНАЧЕНИЕ(Справочник.ДоговорыКонтрагентов.ПустаяСсылка) КАК Договор,
	|	ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка) КАК Валюта,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ПустаяСсылка) КАК НалогообложениеНДС,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ПустаяСсылка) КАК НалогообложениеОрганизации,
	|	НЕОПРЕДЕЛЕНО КАК ВладелецТовара,
	|	ЗНАЧЕНИЕ(Справочник.ВидыЦенПоставщиков.ПустаяСсылка) КАК ВидЦены
	|ПОМЕСТИТЬ ИсходнаяТаблицаТоваров
	|ИЗ
	|	ВтИсходнаяТаблицаТоваров КАК ТаблицаТоваров
	//++ НЕ УТКА

	//++ Устарело_Переработка24
	|	ЛЕВОЕ СОЕДИНЕНИЕ ВтТоварыДавальца КАК ТоварыДавальца
	|		ПО ТаблицаТоваров.НомерСтроки = ТоварыДавальца.НомерСтроки
	|ГДЕ
	|	ТоварыДавальца.НомерСтроки ЕСТЬ NULL
	//-- Устарело_Переработка24

	//-- НЕ УТКА
	|");
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	ПараметрыУчетаПоОрганизации = УчетНДСУП.ПараметрыУчетаПоОрганизации(Организация, Дата);
	
	Запрос.УстановитьПараметр("Дата", Дата);
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("ТаблицаТоваров", Товары);
	Запрос.УстановитьПараметр("НалогообложениеОрганизации", ПараметрыУчетаПоОрганизации.ОсновноеНалогообложениеНДСПродажи);
	Запрос.УстановитьПараметр("ФормироватьВидыЗапасовПоГруппамФинансовогоУчета", ПолучитьФункциональнуюОпцию("ФормироватьВидыЗапасовПоГруппамФинансовогоУчета"));
	Запрос.УстановитьПараметр("Проведен", Проведен);
	
	ЗапасыСервер.ДополнитьВременныеТаблицыОбязательнымиКолонками(Запрос);
	ЗапасыСервер.ПроверитьНеобходимостьПерезаполненияВидовЗапасовДокумента(ЭтотОбъект, Запрос);
	
	Запрос.Выполнить();
	
	Возврат МенеджерВременныхТаблиц;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли
//-- Устарело_Производство21
