///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// Задать настройки формы отчета.
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения
//         - Неопределено
//   КлючВарианта - Строка
//                - Неопределено
//   Настройки - см. ОтчетыКлиентСервер.НастройкиОтчетаПоУмолчанию
//
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	
	Настройки.СкрытьКомандыРассылки                              = Истина;
	Настройки.ФормироватьСразу                                   = Ложь;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка, АдресХранилища)
	
	СтатистикаОбновления = СтатистикаОбновления();
	
	СтатистикаДляДиаграммы = СтатистикаОбновления.Скопировать();
	СтатистикаОбновления.Свернуть("Обработчик, Порядок, Статус", "Длительность");
	
	СведенияОбОбновлении = ОбновлениеИнформационнойБазыСлужебный.СведенияОбОбновленииИнформационнойБазы();
	Если СведенияОбОбновлении.ОтложенноеОбновлениеЗавершеноУспешно <> Неопределено Тогда
		ИнформацияОПоследнейПроверке = НСтр("ru = 'Отчет сформирован %1';
											|en = 'The report is generated %1'");
	Иначе
		ИнформацияОПоследнейПроверке = НСтр("ru = 'Отчет сформирован %1
			|Обновление в данный момент выполняется, информация может быть неполной';
			|en = 'The report is generated on %1
			|Update is in progress. The information might be incomplete'");
	КонецЕсли;
	ИнформацияОПоследнейПроверке = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ИнформацияОПоследнейПроверке, ТекущаяДатаСеанса());
	
	НастройкиОтчета   = КомпоновщикНастроек.ПолучитьНастройки();
	ЧислоОбработчиков = НастройкиОтчета.ПараметрыДанных.Элементы.Найти("СамыеДлительныеОбработчики").Значение;
	
	КомпоновщикНастроек.Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("ИнформацияОПоследнейПроверке", ИнформацияОПоследнейПроверке);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("СтатистикаОбновления", СтатистикаОбновления);
	Запрос.Текст =
		"ВЫБРАТЬ
		|	СтатистикаОбновления.Обработчик КАК Обработчик,
		|	СтатистикаОбновления.Порядок КАК Порядок,
		|	СтатистикаОбновления.Длительность КАК Длительность,
		|	СтатистикаОбновления.Статус КАК Статус
		|ПОМЕСТИТЬ СтатистикаОбновления
		|ИЗ
		|	&СтатистикаОбновления КАК СтатистикаОбновления
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ ПЕРВЫЕ 10
		|	СтатистикаОбновления.Обработчик КАК Обработчик,
		|	СтатистикаОбновления.Порядок КАК Порядок,
		|	СтатистикаОбновления.Длительность КАК Длительность,
		|	СтатистикаОбновления.Статус КАК Статус
		|ИЗ
		|	СтатистикаОбновления КАК СтатистикаОбновления
		|
		|УПОРЯДОЧИТЬ ПО
		|	Длительность УБЫВ";
	Если ЧислоОбработчиков <> 10 Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "10", ЧислоОбработчиков);
	КонецЕсли;
	СтатистикаОбновления = Запрос.Выполнить().Выгрузить();
	
	СтандартнаяОбработка = Ложь;
	НастройкиКД = КомпоновщикНастроек.ПолучитьНастройки();
	ВнешниеНаборыДанных = Новый Структура("СтатистикаОбновления", СтатистикаОбновления);
	
	КомпоновщикМакетаКД = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКД = КомпоновщикМакетаКД.Выполнить(СхемаКомпоновкиДанных, НастройкиКД, ДанныеРасшифровки);
	
	ПроцессорКД = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКД.Инициализировать(МакетКД, ВнешниеНаборыДанных, ДанныеРасшифровки, Истина);
	
	ПроцессорВыводаРезультатаКД = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВыводаРезультатаКД.УстановитьДокумент(ДокументРезультат);
	ПроцессорВыводаРезультатаКД.Вывести(ПроцессорКД);
	
	ДокументРезультат.ФиксацияСверху = 0;
	ДокументРезультат.ФиксацияСлева  = 0;
	
	ДиаграммаГанта(СтатистикаДляДиаграммы, ДокументРезультат);
	
	ШаблонДиаграммы = Неопределено;
	Для Каждого Рисунок Из ДокументРезультат.Рисунки Цикл
		Если Рисунок.ТипРисунка = ТипРисункаТабличногоДокумента.Диаграмма Тогда
			ШаблонДиаграммы = Рисунок;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если ДокументРезультат.Области.Количество() <> 0 Тогда
		ДокументРезультат.Области.ДиаграммаГанта.Верх = ШаблонДиаграммы.Верх;
		Если ШаблонДиаграммы.Ширина < 200 Тогда
			ДокументРезультат.Области.ДиаграммаГанта.Ширина = 200;
		Иначе
			ДокументРезультат.Области.ДиаграммаГанта.Ширина = ШаблонДиаграммы.Ширина;
		КонецЕсли;
		ДокументРезультат.Области.ДиаграммаГанта.Высота = ШаблонДиаграммы.Высота;
	КонецЕсли;
	
	ДокументРезультат.Рисунки.Удалить(ШаблонДиаграммы);
	
	КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства.Вставить("ОтчетПустой", СтатистикаОбновления.Количество() = 0);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ТаблицаСтатистики()
	
	Статистика = Новый ТаблицаЗначений;
	Статистика.Колонки.Добавить("Начало", Новый ОписаниеТипов("Дата"));
	Статистика.Колонки.Добавить("Конец", Новый ОписаниеТипов("Дата"));
	Статистика.Колонки.Добавить("Длительность", Новый ОписаниеТипов("Число"));
	Статистика.Колонки.Добавить("Обработчик", Новый ОписаниеТипов("Строка"));
	Статистика.Колонки.Добавить("Порядок", Новый ОписаниеТипов("Строка"));
	Статистика.Колонки.Добавить("Статус", Новый ОписаниеТипов("ПеречислениеСсылка.СтатусыОбработчиковОбновления"));
	
	Возврат Статистика;
	
КонецФункции

Функция СтатистикаОбновления()
	
	ТаблицаСтатистики = ТаблицаСтатистики();
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ОбработчикиОбновления.ИмяОбработчика КАК ИмяОбработчика,
		|	ОбработчикиОбновления.Статус КАК Статус,
		|	ОбработчикиОбновления.Версия КАК Версия,
		|	ОбработчикиОбновления.ИмяБиблиотеки КАК ИмяБиблиотеки,
		|	ОбработчикиОбновления.ДлительностьОбработки КАК ДлительностьОбработки,
		|	ОбработчикиОбновления.РежимВыполнения КАК РежимВыполнения,
		|	ОбработчикиОбновления.ВерсияРегистрации КАК ВерсияРегистрации,
		|	ОбработчикиОбновления.ВерсияПорядок КАК ВерсияПорядок,
		|	ОбработчикиОбновления.Идентификатор КАК Идентификатор,
		|	ОбработчикиОбновления.ЧислоПопыток КАК ЧислоПопыток,
		|	ОбработчикиОбновления.СтатистикаВыполнения КАК СтатистикаВыполнения,
		|	ОбработчикиОбновления.ИнформацияОбОшибке КАК ИнформацияОбОшибке,
		|	ОбработчикиОбновления.Комментарий КАК Комментарий,
		|	ОбработчикиОбновления.Приоритет КАК Приоритет,
		|	ОбработчикиОбновления.ПроцедураПроверки КАК ПроцедураПроверки,
		|	ОбработчикиОбновления.ПроцедураЗаполненияДанныхОбновления КАК ПроцедураЗаполненияДанныхОбновления,
		|	ОбработчикиОбновления.ОчередьОтложеннойОбработки КАК ОчередьОтложеннойОбработки,
		|	ОбработчикиОбновления.ЗапускатьТолькоВГлавномУзле КАК ЗапускатьТолькоВГлавномУзле,
		|	ОбработчикиОбновления.ЗапускатьИВПодчиненномУзлеРИБСФильтрами КАК ЗапускатьИВПодчиненномУзлеРИБСФильтрами,
		|	ОбработчикиОбновления.Многопоточный КАК Многопоточный,
		|	ОбработчикиОбновления.ОбработкаПорцииЗавершена КАК ОбработкаПорцииЗавершена,
		|	ОбработчикиОбновления.ГруппаОбновления КАК ГруппаОбновления,
		|	ОбработчикиОбновления.ИтерацияЗапуска КАК ИтерацияЗапуска,
		|	ОбработчикиОбновления.ОбрабатываемыеДанные КАК ОбрабатываемыеДанные,
		|	ОбработчикиОбновления.РежимВыполненияОтложенногоОбработчика КАК РежимВыполненияОтложенногоОбработчика,
		|	ОбработчикиОбновления.Порядок КАК Порядок
		|ИЗ
		|	РегистрСведений.ОбработчикиОбновления КАК ОбработчикиОбновления");
	СведенияОбОбработчиках = Запрос.Выполнить().Выгрузить();
	СведенияОбОбновлении = ОбновлениеИнформационнойБазыСлужебный.СведенияОбОбновленииИнформационнойБазы();
	ДлительностьЭтаповОбновления = СведенияОбОбновлении.ДлительностьЭтаповОбновления;
	
	Для Каждого СтрокаОбработчика Из СведенияОбОбработчиках Цикл
		ИмяОбработчика = СтрокаОбработчика.ИмяОбработчика;
		СтатистикаВыполнения = СтрокаОбработчика.СтатистикаВыполнения.Получить();
		
		Если СтатистикаВыполнения = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		НачалоПроцедурыОбработчика = СтатистикаВыполнения["НачалоПроцедурыОбработчика"];
		ЗавершениеПроцедурыОбработчика = СтатистикаВыполнения["ЗавершениеПроцедурыОбработчика"];
		ДлительностьПроцедурыОбработчика = СтатистикаВыполнения["ДлительностьПроцедурыОбработчика"];
		
		СмещениеОтУниверсальнойДаты = ТекущаяДатаСеанса() - ТекущаяУниверсальнаяДата();
		
		Если СтрокаОбработчика.Порядок = Перечисления.ПорядокОбработчиковОбновления.Критичный Тогда
			ПорядокСтрокой = "Критичные";
		ИначеЕсли СтрокаОбработчика.Порядок = Перечисления.ПорядокОбработчиковОбновления.Обычный Тогда
			ПорядокСтрокой = "Обычные";
		Иначе
			ПорядокСтрокой = "Некритичные";
		КонецЕсли;
		
		Если НачалоПроцедурыОбработчика = Неопределено Или ЗавершениеПроцедурыОбработчика = Неопределено Тогда
			СтрокаСтатистики = ТаблицаСтатистики.Добавить();
			СтрокаСтатистики.Обработчик = ИмяОбработчика;
			СтрокаСтатистики.Начало = СтатистикаВыполнения["НачалоОбработкиДанных"];
			СтрокаСтатистики.Конец = СтатистикаВыполнения["ЗавершениеОбработкиДанных"];
			СтрокаСтатистики.Длительность = СтатистикаВыполнения["ДлительностьВыполнения"];
			СтрокаСтатистики.Статус = СтрокаОбработчика.Статус;
			СтрокаСтатистики.Порядок = ПорядокСтрокой;
		Иначе
			Для Индекс = 0 По НачалоПроцедурыОбработчика.ВГраница() Цикл
				СтрокаСтатистики = ТаблицаСтатистики.Добавить();
				СтрокаСтатистики.Обработчик = ИмяОбработчика;
				Если СтрокаОбработчика.Порядок = Перечисления.ПорядокОбработчиковОбновления.Обычный
					И ДлительностьЭтаповОбновления.Некритичные.Начало <> Неопределено
					И НачалоПроцедурыОбработчика[Индекс] + СмещениеОтУниверсальнойДаты >= ДлительностьЭтаповОбновления.Некритичные.Начало Тогда
					СтрокаСтатистики.Обработчик = СтрокаСтатистики.Обработчик + "_" + "Некритичный";
					СтрокаСтатистики.Порядок = "Некритичные";
				Иначе
					СтрокаСтатистики.Порядок = ПорядокСтрокой;
				КонецЕсли;
				СтрокаСтатистики.Статус = СтрокаОбработчика.Статус;
				СтрокаСтатистики.Начало = НачалоПроцедурыОбработчика[Индекс];
				СтрокаСтатистики.Конец = ЗавершениеПроцедурыОбработчика[Индекс];
				СтрокаСтатистики.Длительность = ДлительностьПроцедурыОбработчика[Индекс];
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
	
	ТаблицаСтатистики.Сортировать("Начало, Длительность УБЫВ");
	
	Возврат ТаблицаСтатистики;
	
КонецФункции

Процедура ДиаграммаГанта(ТаблицаСтатистики, ДокументРезультат)
	
	Макет = ПолучитьМакет("ДиаграммаГанта");
	ОбластьДиаграммы = Макет.ПолучитьОбласть("Диаграмма");
	ДиаграммаГанта = ОбластьДиаграммы.Рисунки.ДиаграммаГанта.Объект; // ДиаграммаГанта
	ДиаграммаГанта.Обновление = Ложь;
	
	МинимальнаяДлительность = 0;
	
	Генератор = Новый ГенераторСлучайныхЧисел(12);
	Цвета = Новый Соответствие;
	Серия = ДиаграммаГанта.УстановитьСерию(НСтр("ru = 'Длительность';
												|en = 'Duration'"));
	ШаблонПодсказки = НСтр("ru = '%1 сек., с %2 по %3 %4';
							|en = '%1 sec, from %2 to %3 %4'");
	
	Сведения = ОбновлениеИнформационнойБазыСлужебный.СведенияОбОбновленииИнформационнойБазы();
	ОбновлениеЗавершено = (Сведения.ОтложенноеОбновлениеЗавершеноУспешно <> Неопределено);
	ДлительностьЭтаповОбновления = Сведения.ДлительностьЭтаповОбновления;
	СмещениеОтУниверсальнойДаты  = ТекущаяДатаСеанса() - ТекущаяУниверсальнаяДата();
	ОбщаяДлительность = ОбщаяДлительность(ДлительностьЭтаповОбновления);
	ТочкиРодитель = Новый Массив;
	НачалоОбновления = Неопределено;
	КонецОбновления  = Неопределено;
	Для Каждого ЭтапОбновления Из ДлительностьЭтаповОбновления Цикл
		Начало = ЭтапОбновления.Значение.Начало; // Дата
		Конец  = ЭтапОбновления.Значение.Конец; // Дата
		Если Не ЗначениеЗаполнено(Начало) Тогда
			Продолжить;
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(Конец) И Не ОбновлениеЗавершено Тогда
			Конец = ТекущаяДатаСеанса();
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(Конец) Тогда
			Продолжить;
		КонецЕсли;
		
		Если Конец - Начало = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		ДлительностьЭтапа = Конец - Начало;
		ДлительностьЭтапаСтрокой = ОбновлениеИнформационнойБазыСлужебный.ДлительностьЭтапаСтрокой(ДлительностьЭтапа);
		Если ОбновлениеЗавершено Тогда
			ПроцентОтОбщейДлительности = Цел((ДлительностьЭтапа / ОбщаяДлительность) * 100);
			Шаблон = НСтр("ru = '%1, %2% от общей длительности';
							|en = '%1, %2% of the total duration'");
			ДлительностьЭтапаСтрокой = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Шаблон,
				ДлительностьЭтапаСтрокой, ПроцентОтОбщейДлительности);
		КонецЕсли;
		
		Точка = ДиаграммаГанта.УстановитьТочку(Строка(ЭтапОбновления.Ключ));
		Значение = ДиаграммаГанта.ПолучитьЗначение(Точка, Серия);
		ИнтервалДлительности = Значение.Добавить();
		ИнтервалДлительности.Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Начало: %1
			|Конец: %2
			|Длительность: %3';
			|en = 'Start: %1
			|End: %2
			|Duration: %3'"), Начало, Конец, ДлительностьЭтапаСтрокой);
		ИнтервалДлительности.Начало = Начало - СмещениеОтУниверсальнойДаты;
		ИнтервалДлительности.Конец = Конец - СмещениеОтУниверсальнойДаты;
		ИнтервалДлительности.Цвет = СледующийЦвет(Цвета, ЭтапОбновления.Ключ, Генератор, Истина);
		
		Если ЗначениеЗаполнено(Начало)
			И НачалоОбновления = Неопределено Тогда
			НачалоОбновления = Начало - СмещениеОтУниверсальнойДаты;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Конец) Тогда
			КонецОбновления = Конец - СмещениеОтУниверсальнойДаты;
		КонецЕсли;
		
		Если ТочкиРодитель.Найти(Точка) = Неопределено Тогда
			Точка.Шрифт = ШрифтыСтиля.ВажнаяНадписьШрифт;
			ТочкиРодитель.Добавить(Точка);
		КонецЕсли;
	КонецЦикла;
	
	ВсеТочки   = Новый Массив;
	ЕстьДанные = Ложь;
	Для каждого СтрокаСтатистики Из ТаблицаСтатистики Цикл
		Если СтрокаСтатистики.Длительность = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		ЕстьДанные = Истина;
		ДлительностьСек = СтрокаСтатистики.Длительность / 1000;
		
		Если ДлительностьСек >= МинимальнаяДлительность Тогда
			Точка = ДиаграммаГанта.УстановитьТочку(СтрокаСтатистики.Обработчик, СтрокаСтатистики.Порядок);
			Значение = ДиаграммаГанта.ПолучитьЗначение(Точка, Серия);
			
			Если ВсеТочки.Найти(Точка) = Неопределено Тогда
				ВсеТочки.Добавить(Точка);
			КонецЕсли;
			
			ТекстПодсказки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонПодсказки,
				ДлительностьСек,
				СтрокаСтатистики.Начало + СмещениеОтУниверсальнойДаты,
				СтрокаСтатистики.Конец + СмещениеОтУниверсальнойДаты);
			
			ИнтервалДлительности = Значение.Добавить();
			ИнтервалДлительности.Текст = ТекстПодсказки;
			ИнтервалДлительности.Начало = СтрокаСтатистики.Начало;
			ИнтервалДлительности.Конец = СтрокаСтатистики.Конец;
			ИнтервалДлительности.Цвет = СледующийЦвет(Цвета, СтрокаСтатистики.Обработчик, Генератор, Истина);
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого Точка Из ТочкиРодитель Цикл
		ДиаграммаГанта.СвернутьТочку(Точка, Истина);
	КонецЦикла;
	ДиаграммаГанта.ОбластьЛегенды.Расположение = РасположениеЛегендыДиаграммы.Нет;
	ДиаграммаГанта.АвтоОпределениеПолногоИнтервала = Ложь;
	ДиаграммаГанта.ВертикальнаяПрокрутка = Истина;
	Если ЗначениеЗаполнено(НачалоОбновления) Тогда
		ДиаграммаГанта.УстановитьПолныйИнтервал(НачалоОбновления, КонецОбновления);
	КонецЕсли;
	
	Если ЕстьДанные Тогда
		ДокументРезультат.Вывести(ОбластьДиаграммы);
	КонецЕсли;
	
КонецПроцедуры

Функция ОбщаяДлительность(ДлительностьЭтаповОбновления)
	
	Длительность = 0;
	Для Каждого ЭтапОбновления Из ДлительностьЭтаповОбновления Цикл
		Начало = ЭтапОбновления.Значение.Начало; // Дата
		Конец  = ЭтапОбновления.Значение.Конец; // Дата
		Если Не ЗначениеЗаполнено(Начало) Тогда
			Продолжить;
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(Конец) Тогда
			Продолжить;
		КонецЕсли;
		
		Если Конец - Начало = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		Длительность = Длительность + (Конец - Начало);
	КонецЦикла;
	
	Возврат Длительность;
	
КонецФункции

Функция СледующийЦвет(Цвета, ИмяОбработчика, Генератор, Точный)
	
	Обработчик = Цвета[Точный];
	
	Если Обработчик = Неопределено Тогда
		Обработчик = Новый Соответствие;
		Цвета[Точный] = Обработчик;
	КонецЕсли;
	
	Цвет = Обработчик[ИмяОбработчика];
	
	Если Цвет = Неопределено Тогда
		Если Точный Тогда
			Красный = Генератор.СлучайноеЧисло(32, 192);
			Зеленый = Генератор.СлучайноеЧисло(32, 192);
			Синий = Генератор.СлучайноеЧисло(32, 192);
			Цвет = Новый Цвет(Красный, Зеленый, Синий); //@skip-check new-color - для информативности диаграммы ганта.
		Иначе
			Серый = Генератор.СлучайноеЧисло(32, 192);
			Цвет = Новый Цвет(Серый, Серый, Серый); //@skip-check new-color - для информативности диаграммы ганта.
		КонецЕсли;
		
		Обработчик[ИмяОбработчика] = Цвет;
	КонецЕсли;
	
	Возврат Цвет;
	
КонецФункции

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.';
						|en = 'Invalid object call on the client.'");
#КонецЕсли