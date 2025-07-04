#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс

// Присваивает номер пакета основным средствам, для которых он еще не определено.
//
// Параметры:
//  СписокОрганизаций	 - Массив, Неопределено	 - Список организация по которым требуется создать пакеты.
//  НомерЗадания		 - Число				 - Номер задания, который будет использоваться для создания новых заданий.
// 
// Возвращаемое значение:
//  ТаблицаЗначений - Содержит измененные пакеты амортизации.
//
Функция СоздатьПакетыАмортизации(СписокОрганизаций, НомерЗадания = Неопределено) Экспорт

	Если СписокОрганизаций = Неопределено Тогда
		СписокОрганизаций = Новый Массив;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если НомерЗадания = Неопределено Тогда
		// Перед выполнением увеличиваем номер задания.
		// Т.к. в ходе выполнения в других сеансах могут добавить новые задания и они должны остаться.
		НомерЗадания = РегистрыСведений.ЗаданияКРасчетуАмортизацииОС.УвеличитьНомерЗадания();
	КонецЕсли; 
	
	НачатьТранзакцию();

	Попытка
	
		ИзмененныеПакеты = РассчитатьНомераПакетов(СписокОрганизаций);
		СформироватьЗаданияПослеСозданияПакетов(ИзмененныеПакеты, СписокОрганизаций, НомерЗадания);
		
		ЗафиксироватьТранзакцию();
		
	Исключение
	
		ОтменитьТранзакцию();
		
		ТекстОшибки = ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		
		ВызватьИсключение ТекстОшибки;
		
	КонецПопытки; 
	
	Возврат ИзмененныеПакеты;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция РассчитатьНомераПакетов(СписокОрганизаций)

	ТекстЗапроса = ВнеоборотныеАктивыЛокализация.ТекстЗапросаРассчитатьНомераПакетовАмортизацииОС();
	
	Если ТекстЗапроса = Неопределено Тогда
		
		ТекстЗапроса = 
		"ВЫБРАТЬ
		|	МИНИМУМ(НАЧАЛОПЕРИОДА(ПорядокУчетаОС.Период, МЕСЯЦ)) КАК Период,
		|	ПорядокУчетаОС.Организация                           КАК Организация,
		|	ПорядокУчетаОС.ОсновноеСредство                      КАК ОсновноеСредство
		|ПОМЕСТИТЬ ВТ_СписокОС_БезНомера
		|ИЗ
		|	РегистрСведений.ПорядокУчетаОСУУ КАК ПорядокУчетаОС
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПакетыАмортизацииОС КАК ПакетыАмортизацииОС
		|		ПО (ПакетыАмортизацииОС.Организация = ПорядокУчетаОС.Организация)
		|			И (ПакетыАмортизацииОС.ОсновноеСредство = ПорядокУчетаОС.ОсновноеСредство)
		|ГДЕ
		|	ПорядокУчетаОС.НачислятьАмортизациюУУ
		|	И ПорядокУчетаОС.Организация В(&Организация)
		|	И ПакетыАмортизацииОС.НомерПакета ЕСТЬ NULL
		|	И ПорядокУчетаОС.ДатаИсправления = ДАТАВРЕМЯ(1,1,1)
		|
		|СГРУППИРОВАТЬ ПО
		|	ПорядокУчетаОС.Организация,
		|	ПорядокУчетаОС.ОсновноеСредство
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	СписокОС.Период                       КАК НачалоМесяца,
		|	КОНЕЦПЕРИОДА(СписокОС.Период, МЕСЯЦ)  КАК КонецМесяца
		|ПОМЕСТИТЬ ВТ_Периоды
		|ИЗ
		|	ВТ_СписокОС_БезНомера КАК СписокОС
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТ_Периоды.НачалоМесяца                                  КАК Период,
		|	ПорядокУчетаОС.Организация                            КАК Организация,
		|	ПакетыАмортизацииОС.НомерПакета                       КАК НомерПакета,
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ПорядокУчетаОС.ОсновноеСредство) КАК ОбъемПакета
		|ИЗ
		|	ВТ_Периоды КАК ВТ_Периоды
		|
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ПорядокУчетаОСУУ КАК ПорядокУчетаОС
		|		ПО (ПорядокУчетаОС.Период >= ВТ_Периоды.НачалоМесяца)
		|			И (ПорядокУчетаОС.Период <= ВТ_Периоды.КонецМесяца)
		|			И (ПорядокУчетаОС.Организация В (&Организация))
		|			И (ПорядокУчетаОС.НачислятьАмортизациюУУ)
		|			И (ПорядокУчетаОС.ДатаИсправления = ДАТАВРЕМЯ(1,1,1))
		|
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ПакетыАмортизацииОС КАК ПакетыАмортизацииОС
		|		ПО (ПакетыАмортизацииОС.Организация = ПорядокУчетаОС.Организация)
		|			И (ПакетыАмортизацииОС.ОсновноеСредство = ПорядокУчетаОС.ОсновноеСредство)
		|
		|СГРУППИРОВАТЬ ПО
		|	ВТ_Периоды.НачалоМесяца,
		|	ПакетыАмортизацииОС.НомерПакета,
		|	ПорядокУчетаОС.Организация
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СписокОС.Период КАК Период,
		|	СписокОС.Организация КАК Организация,
		|	СписокОС.ОсновноеСредство КАК ОсновноеСредство
		|ИЗ
		|	ВТ_СписокОС_БезНомера КАК СписокОС";
		
	КонецЕсли; 
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Организация", СписокОрганизаций);
	Запрос.УстановитьПараметр("ПоВсемОрганизациям", СписокОрганизаций.Количество() = 0);
	
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ПакетыАмортизацииОС");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	Если СписокОрганизаций.Количество() <> 0 Тогда
		ЭлементБлокировки.ИсточникДанных = СписокОрганизацийВТаблицу(СписокОрганизаций);
		ЭлементБлокировки.ИспользоватьИзИсточникаДанных("Организация", "Организация");
	КонецЕсли; 
	Блокировка.Заблокировать(); 
	
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	
	ОбъемПакетов = РезультатЗапроса[РезультатЗапроса.ВГраница()-1].Выгрузить();
	Выборка = РезультатЗапроса[РезультатЗапроса.ВГраница()].Выбрать();
	
	НаборЗаписей = РегистрыСведений.ПакетыАмортизацииОС.СоздатьНаборЗаписей();
	ИзмененныеПакеты = РассчитатьНомераПакетовАмортизации(Выборка, ОбъемПакетов, НаборЗаписей);
	
	Возврат ИзмененныеПакеты;
	
КонецФункции

// Требуется сформировать задания, т.к. у ОС появился номер пакета.
// Если это не сделать, то потеряется информация о том, что для этих ОС нужен пересчет.
//
Процедура СформироватьЗаданияПослеСозданияПакетов(ИзмененныеПакеты, СписокОрганизаций, НомерЗадания)

	Если ПланыОбмена.ГлавныйУзел() <> Неопределено Тогда
		// В РИБ данный регистр обрабатывается только в главном узле.
		Возврат;
	КонецЕсли;
	
	Если ИзмененныеПакеты.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ИзмененныеПакеты.Организация КАК Организация,
	|	ИзмененныеПакеты.НомерПакета КАК НомерПакета
	|ПОМЕСТИТЬ ИзмененныеПакеты
	|ИЗ
	|	&ИзмененныеПакеты КАК ИзмененныеПакеты
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Организация
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Задания.Месяц,
	|	Задания.Организация,
	|	Задания.НомерПакета,
	|	Задания.НомерЗадания,
	|	Задания.Документ
	|ПОМЕСТИТЬ Задания
	|ИЗ
	|	РегистрСведений.ЗаданияКРасчетуАмортизацииОС КАК Задания
	|ГДЕ
	|	Задания.НомерПакета = 0
	|	И Задания.НомерЗадания <= &НомерЗадания
	|	И Задания.Месяц >= &ДатаНачалаУчета24
	|	И (Задания.Организация В (&Организация)
	|			ИЛИ &ПоВсемОрганизациям)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|// Запись новых заданий
	|ВЫБРАТЬ
	|	Задания.Месяц,
	|	Задания.Организация,
	|	ИзмененныеПакеты.НомерПакета,
	|	МАКСИМУМ(Задания.НомерЗадания) КАК НомерЗадания
	|ИЗ
	|	Задания КАК Задания
	|
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ИзмененныеПакеты КАК ИзмененныеПакеты
	|		ПО (ИзмененныеПакеты.Организация = Задания.Организация)
	|
	|СГРУППИРОВАТЬ ПО
	|	Задания.Месяц,
	|	Задания.Организация,
	|	ИзмененныеПакеты.НомерПакета
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|// Удаление заданий
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Задания.Месяц,
	|	Задания.Организация,
	|	Задания.НомерЗадания
	|ИЗ
	|	Задания КАК Задания";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("ИзмененныеПакеты", ИзмененныеПакеты);
	Запрос.УстановитьПараметр("Организация", СписокОрганизаций);
	Запрос.УстановитьПараметр("ПоВсемОрганизациям", СписокОрганизаций.Количество() = 0);
	Запрос.УстановитьПараметр("НомерЗадания", НомерЗадания);
	Запрос.УстановитьПараметр("ДатаНачалаУчета24", ВнеоборотныеАктивыЛокализация.ДатаНачалаУчетаВнеоборотныхАктивов2_4());
	
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ЗаданияКРасчетуАмортизацииОС");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	ЭлементБлокировки.УстановитьЗначение("НомерПакета", 0);
	Если СписокОрганизаций.Количество() <> 0 Тогда
		ЭлементБлокировки.ИсточникДанных = СписокОрганизацийВТаблицу(СписокОрганизаций);
		ЭлементБлокировки.ИспользоватьИзИсточникаДанных("Организация", "Организация");
	КонецЕсли; 
	Блокировка.Заблокировать(); 
	
	Результат = Запрос.ВыполнитьПакет();
	
	// Добавление новых заданий по измененным пакетам.
	Выборка = Результат[Результат.ВГраница()-1].Выбрать();
	Пока Выборка.Следующий() Цикл
		НовоеЗаданиеЗапись = РегистрыСведений.ЗаданияКРасчетуАмортизацииОС.СоздатьМенеджерЗаписи();
		ЗаполнитьЗначенияСвойств(НовоеЗаданиеЗапись, Выборка);
		НовоеЗаданиеЗапись.Записать();
	КонецЦикла;
	
	// Удаление заданий на нулевой пакет.
	Выборка = Результат[Результат.ВГраница()].Выбрать();
	Пока Выборка.Следующий() Цикл
		НаборЗаписей = РегистрыСведений.ЗаданияКРасчетуАмортизацииОС.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Месяц.Установить(Выборка.Месяц);
		НаборЗаписей.Отбор.Организация.Установить(Выборка.Организация);
		НаборЗаписей.Отбор.НомерЗадания.Установить(Выборка.НомерЗадания);
		НаборЗаписей.Отбор.НомерПакета.Установить(0);
		НаборЗаписей.Записать();
	КонецЦикла;
	
КонецПроцедуры

Функция СписокОрганизацийВТаблицу(СписокОрганизаций)

	ТаблицаОрганизаций = Новый ТаблицаЗначений;
	ТаблицаОрганизаций.Колонки.Добавить("Организация", Новый ОписаниеТипов("СправочникСсылка.Организации"));
	
	Для каждого Организация Из СписокОрганизаций Цикл
		НоваяСтрока = ТаблицаОрганизаций.Добавить();
		НоваяСтрока.Организация = Организация;
	КонецЦикла; 

	Возврат ТаблицаОрганизаций;
	
КонецФункции

Функция РассчитатьНомераПакетовАмортизации(Выборка, ОбъемПакетов, НаборЗаписей)
	
	СписокТекущихПакетов = Новый ТаблицаЗначений;
	СписокТекущихПакетов.Колонки.Добавить("Организация", Новый ОписаниеТипов("СправочникСсылка.Организации"));
	СписокТекущихПакетов.Колонки.Добавить("Период", Новый ОписаниеТипов("Дата"));
	СписокТекущихПакетов.Колонки.Добавить("НомерПакета", Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(10,0)));
	СписокТекущихПакетов.Колонки.Добавить("ОбъемПакета", Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(10,0)));
	
	МаксимальныйОбъемПакета = МаксимальныйОбъемПакета();
	
	ИзмененныеПакеты = Новый ТаблицаЗначений;
	ИзмененныеПакеты.Колонки.Добавить("Организация", Новый ОписаниеТипов("СправочникСсылка.Организации"));
	ИзмененныеПакеты.Колонки.Добавить("НомерПакета", Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(10,0)));
	
	ТекущийПакет = Неопределено;
	ДанныеКЗаписи = 0;
	Пока Выборка.Следующий() Цикл
		
		СтруктураПоиска = Новый Структура("Организация,Период", Выборка.Организация, Выборка.Период);
		СписокСтрок = СписокТекущихПакетов.НайтиСтроки(СтруктураПоиска);
		Если СписокСтрок.Количество() <> 0 Тогда
			ТекущийПакет = СписокСтрок[0];
		Иначе
			ТекущийПакет = Неопределено;
		КонецЕсли;
		
		Если ТекущийПакет = Неопределено ИЛИ ТекущийПакет.ОбъемПакета >= МаксимальныйОбъемПакета Тогда
			
			ПодходящийПакет = НайтиПодходящийПакет(
									Выборка.Организация, 
									Выборка.Период,
									?(ТекущийПакет <> Неопределено, ТекущийПакет.НомерПакета, 0), 
									ОбъемПакетов, 
									МаксимальныйОбъемПакета);
			
			Если ТекущийПакет = Неопределено Тогда
				ТекущийПакет = СписокТекущихПакетов.Добавить();
				ТекущийПакет.Организация = Выборка.Организация;
				ТекущийПакет.Период      = Выборка.Период;
			КонецЕсли;
			ТекущийПакет.НомерПакета = ПодходящийПакет.НомерПакета;
			ТекущийПакет.ОбъемПакета = ПодходящийПакет.ОбъемПакета;
			
		КонецЕсли; 
		
		Если ДанныеКЗаписи > 5000 Тогда
			НаборЗаписей.Записать(Ложь);
			Если ТипЗнч(НаборЗаписей) = Тип("РегистрСведенийНаборЗаписей.ПакетыАмортизацииОС") Тогда
				НаборЗаписей = РегистрыСведений.ПакетыАмортизацииОС.СоздатьНаборЗаписей();
			Иначе
				НаборЗаписей = РегистрыСведений.ПакетыАмортизацииНМА.СоздатьНаборЗаписей();
			КонецЕсли;
			ДанныеКЗаписи = 0;
		КонецЕсли; 
		
		НовыйПакетЗапись = НаборЗаписей.Добавить();
		ЗаполнитьЗначенияСвойств(НовыйПакетЗапись, Выборка);
		НовыйПакетЗапись.НомерПакета = ТекущийПакет.НомерПакета;
		
		ИзмененныйПакет = ИзмененныеПакеты.Добавить();
		ЗаполнитьЗначенияСвойств(ИзмененныйПакет, НовыйПакетЗапись);
		
		ДанныеКЗаписи = ДанныеКЗаписи + 1;
		
		ТекущийПакет.ОбъемПакета = ТекущийПакет.ОбъемПакета + 1;
		
	КонецЦикла;
	
	Если ДанныеКЗаписи > 0 Тогда
		НаборЗаписей.Записать(Ложь);
	КонецЕсли;
	
	ИзмененныеПакеты.Свернуть("Организация,НомерПакета");
	
	Возврат ИзмененныеПакеты;

КонецФункции

Функция НайтиПодходящийПакет(Организация, Период, Знач НомерПакета, ОбъемПакетов, МаксимальныйОбъем)
	
	ОбъемПакета = МаксимальныйОбъем;
	Пока ОбъемПакета >= МаксимальныйОбъем Цикл
		НомерПакета = НомерПакета + 1;
		СтруктураПоиска = Новый Структура("Организация,Период,НомерПакета", Организация, Период, НомерПакета);
		СписокСтрок = ОбъемПакетов.НайтиСтроки(СтруктураПоиска);
		Если СписокСтрок.Количество() <> 0 Тогда
			ОбъемПакета = СписокСтрок[0].ОбъемПакета;
		Иначе
			ОбъемПакета = 0;
		КонецЕсли;
	КонецЦикла;

	Возврат Новый Структура("ОбъемПакета,НомерПакета", ОбъемПакета,НомерПакета);
	
КонецФункции

Функция МаксимальныйОбъемПакета() Экспорт

	Возврат 500;

КонецФункции

#КонецОбласти

#КонецЕсли