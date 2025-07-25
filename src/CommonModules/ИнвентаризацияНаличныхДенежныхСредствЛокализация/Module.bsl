
#Область ПрограммныйИнтерфейс

#Область Проведение

// Описывает учетные механизмы используемые в документе для регистрации в механизме проведения.
//
// Параметры:
//  МеханизмыДокумента - Массив - список имен учетных механизмов, для которых будет выполнена
//              регистрация в механизме проведения.
//
Процедура ЗарегистрироватьУчетныеМеханизмы(МеханизмыДокумента) Экспорт
	
	//++ Локализация

	//++ НЕ УТ
	МеханизмыДокумента.Добавить("РегламентированныйУчет");
	//-- НЕ УТ

	//-- Локализация
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

// Вызывается из соответствующего обработчика документа
//
// Параметры:
//  Объект - ДокументОбъект - Обрабатываемый документ.
//  Отказ - Булево - Признак проведения документа.
//                   Если в теле процедуры-обработчика установить данному параметру значение Истина,
//                   то проведение документа выполнено не будет.
//  РежимПроведения - РежимПроведенияДокумента - В данный параметр передается текущий режим проведения.
//
Процедура ОбработкаПроведения(Объект, Отказ, РежимПроведения) Экспорт
	
КонецПроцедуры

// Вызывается из соответствующего обработчика документа
//
// Параметры:
//  Объект - ДокументОбъект - Обрабатываемый объект
//  Отказ - Булево - Если в теле процедуры-обработчика установить данному параметру значение Истина,
//                   то будет выполнен отказ от продолжения работы после выполнения проверки заполнения.
//  ПроверяемыеРеквизиты - Массив - Массив путей к реквизитам, для которых будет выполнена проверка заполнения.
//
Процедура ОбработкаПроверкиЗаполнения(Объект, Отказ, ПроверяемыеРеквизиты) Экспорт
	
	
КонецПроцедуры

// Вызывается из соответствующего обработчика документа
//
// Параметры:
//  Объект - ДокументОбъект - Обрабатываемый объект.
//  ДанныеЗаполнения - Произвольный - Значение, которое используется как основание для заполнения.
//  СтандартнаяОбработка - Булево - В данный параметр передается признак выполнения стандартной (системной) обработки события.
//
Процедура ОбработкаЗаполнения(Объект, ДанныеЗаполнения, СтандартнаяОбработка) Экспорт
	
	
КонецПроцедуры

// Вызывается из соответствующего обработчика документа
//
// Параметры:
//  Объект - ДокументОбъект - Обрабатываемый объект
//  Отказ - Булево - Признак отказа от записи.
//                   Если в теле процедуры-обработчика установить данному параметру значение Истина,
//                   то запись выполнена не будет и будет вызвано исключение.
//
Процедура ОбработкаУдаленияПроведения(Объект, Отказ) Экспорт
	
	
КонецПроцедуры

// Вызывается из соответствующего обработчика документа
//
// Параметры:
//  Объект - ДокументОбъект - Обрабатываемый объект
//  Отказ - Булево - Признак отказа от записи.
//                   Если в теле процедуры-обработчика установить данному параметру значение Истина,
//                   то запись выполнена не будет и будет вызвано исключение.
//  РежимЗаписи - РежимЗаписиДокумента - В параметр передается текущий режим записи документа. Позволяет определить в теле процедуры режим записи.
//  РежимПроведения - РежимПроведенияДокумента - В данный параметр передается текущий режим проведения.
//
Процедура ПередЗаписью(Объект, Отказ, РежимЗаписи, РежимПроведения) Экспорт
	
	
КонецПроцедуры

// Вызывается из соответствующего обработчика документа
//
// Параметры:
//  Объект - ДокументОбъект - Обрабатываемый объект
//  Отказ - Булево - Признак отказа от записи.
//                   Если в теле процедуры-обработчика установить данному параметру значение Истина, то запись выполнена не будет и будет вызвано исключение.
//
Процедура ПриЗаписи(Объект, Отказ) Экспорт
	
	
КонецПроцедуры

// Вызывается из соответствующего обработчика документа
//
// Параметры:
//  Объект - ДокументОбъект - Обрабатываемый объект
//  ОбъектКопирования - ДокументОбъект - Исходный документ, который является источником копирования.
//
Процедура ПриКопировании(Объект, ОбъектКопирования) Экспорт
	
	
КонецПроцедуры

#КонецОбласти

#Область ПодключаемыеКоманды

// Определяет список команд создания на основании.
//
// Параметры:
//  КомандыСозданияНаОсновании - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
//  Параметры - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.Параметры
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСозданияНаОсновании, Параметры) Экспорт
	
	
КонецПроцедуры

// Добавляет команду создания документа "Авансовый отчет".
//
// Параметры:
//  КомандыСозданияНаОсновании - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
//
Процедура ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании) Экспорт


КонецПроцедуры

// Определяет список команд отчетов.
//
// Параметры:
//   КомандыОтчетов - См. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.КомандыОтчетов
//   Параметры - См. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.Параметры
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры) Экспорт
	
	
КонецПроцедуры

// Заполняет список команд печати.
//
// Параметры:
//   КомандыПечати - см. УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	//++ Локализация
	Если ПравоДоступа("Изменение", Метаданные.Документы.ИнвентаризацияНаличныхДенежныхСредств) Тогда
		
		// Акт инвентаризации
		КомандаПечати = КомандыПечати.Добавить();
		КомандаПечати.Идентификатор = "ИНВ15";
		КомандаПечати.Представление = НСтр("ru = 'ИНВ-15';
											|en = 'INV-15'");
		КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
		
	КонецЕсли;
	//-- Локализация
	
КонецПроцедуры

#КонецОбласти

#Область Печать

// Формирует печатные формы.
//
// Параметры:
//  МассивОбъектов  - Массив    - ссылки на объекты, которые нужно распечатать;
//  ПараметрыПечати - Структура - дополнительные настройки печати;
//  КоллекцияПечатныхФорм - ТаблицаЗначений - сформированные табличные документы (выходной параметр)
//  ОбъектыПечати         - СписокЗначений  - значение - ссылка на объект;
//                                            представление - имя области в которой был выведен объект (выходной параметр);
//  ПараметрыВывода       - Структура       - дополнительные параметры сформированных табличных документов (выходной параметр).
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	//++ Локализация
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ИНВ15") Тогда
		
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм,
			"ИНВ15",
			"ИНВ-15",
			СформироватьПечатнуюАктаИнвентаризацииНаличныхДенежныхСредств(МассивОбъектов, ОбъектыПечати));
		
	КонецЕсли;
	//-- Локализация
КонецПроцедуры

//++ Локализация
Функция СформироватьПечатнуюАктаИнвентаризацииНаличныхДенежныхСредств(МассивОбъектов, ОбъектыПечати)
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ИНВ15";
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.ИнвентаризацияНаличныхДенежныхСредств.ПФ_MXL_ИНВ15_ru");
	Макет.КодЯзыка = Метаданные.Языки.Русский.КодЯзыка;
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	ОтветственныеЛицаСервер.СформироватьВременнуюТаблицуОтветственныхЛицДокументов(МассивОбъектов, МенеджерВременныхТаблиц);
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ДанныеДокумента.Ссылка КАК Ссылка,
	|	ЕСТЬNULL(ДанныеДокумента.ИсправляемыйДокумент.Номер, ДанныеДокумента.Номер) КАК Номер,
	|	ДанныеДокумента.Организация.Префикс КАК Префикс,
	|	ЕСТЬNULL(ДанныеДокумента.ИсправляемыйДокумент.Дата, ДанныеДокумента.Дата) КАК ДатаДокумента,
	|	ДанныеДокумента.Организация КАК Организация,
	|	ДанныеДокумента.Организация.КодПоОКПО КАК ОрганизацияКодПоОКПО,
	|	ДанныеДокумента.Организация.КодОКВЭД КАК ОрганизацияКодПоОКВЭД,
	|	ДанныеДокумента.ПоследнийНомерПКО КАК НомерПКО,
	|	ДанныеДокумента.ПоследнийНомерРКО КАК НомерРКО,
	|	ДанныеДокумента.КассоваяКнига.СтруктурноеПодразделение КАК Подразделение,
	|	ТаблицаОтветственныеЛица.КассирНаименование КАК ФИОКассира,
	|	ТаблицаОтветственныеЛица.КассирДолжность КАК КассирДолжность,
	|	ТаблицаОтветственныеЛица.РуководительНаименование КАК ФИОРуководителя,
	|	ТаблицаОтветственныеЛица.РуководительДолжность КАК РуководительДолжность
	|ИЗ
	|	Документ.ИнвентаризацияНаличныхДенежныхСредств КАК ДанныеДокумента
	|		ЛЕВОЕ СОЕДИНЕНИЕ ТаблицаОтветственныеЛица КАК ТаблицаОтветственныеЛица
	|		ПО ДанныеДокумента.Ссылка = ТаблицаОтветственныеЛица.Ссылка
	|ГДЕ
	|	ДанныеДокумента.Ссылка В(&МассивДокументов)
	|
	|УПОРЯДОЧИТЬ ПО
	|	ДатаДокумента,
	|	Номер
	|;
	|///////////////////////////////////////////////////////////
	|
	|ВЫБРАТЬ
	|	ТаблицаДокумента.Ссылка КАК Ссылка,
	|	ТаблицаДокумента.Касса.ВалютаДенежныхСредств КАК Валюта,
	|	СУММА(ТаблицаДокумента.СуммаПоФакту) КАК СуммаПоФакту
	|	
	|ИЗ
	|	Документ.ИнвентаризацияНаличныхДенежныхСредств.Кассы КАК ТаблицаДокумента
	|	
	|ГДЕ
	|	ТаблицаДокумента.Ссылка В(&МассивДокументов)
	|	
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаДокумента.Ссылка,
	|	ТаблицаДокумента.Касса.ВалютаДенежныхСредств
	|;
	|///////////////////////////////////////////////////////////
	|
	|ВЫБРАТЬ
	|	ТаблицаДокумента.Ссылка                       КАК Ссылка,
	|	ТаблицаДокумента.Ссылка.СуммаПоФактуВсего     КАК СуммаПоФактуРегл,
	|	ТаблицаДокумента.Ссылка.СуммаПоУчетуВсего     КАК СуммаПоУчетуРегл,
	|	СУММА(ВЫБОР 
	|		КОГДА ДенежныеСредства.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|			ТОГДА ДенежныеСредства.СуммаРегл
	|				ИНАЧЕ 0
	|		КОНЕЦ) КАК СуммаИзлишекРегл,
	|	СУММА(ВЫБОР 
	|		КОГДА ДенежныеСредства.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)
	|			ТОГДА ДенежныеСредства.СуммаРегл
	|				ИНАЧЕ 0
	|		КОНЕЦ) КАК СуммаНедостачаРегл
	|ИЗ
	|	Документ.ИнвентаризацияНаличныхДенежныхСредств.Кассы КАК ТаблицаДокумента
	|	ЛЕВОЕ СОЕДИНЕНИЕ 
	|		РегистрНакопления.ДенежныеСредстваНаличные КАК ДенежныеСредства
	|	ПО
	|		ДенежныеСредства.Регистратор = ТаблицаДокумента.Ссылка
	|		И НЕ ДенежныеСредства.Сторно
	|	
	|ГДЕ
	|	ТаблицаДокумента.Ссылка В(&МассивДокументов)
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаДокумента.Ссылка 
	|;";
	
	Запрос.УстановитьПараметр("МассивДокументов", МассивОбъектов);
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	ВыборкаДокументов = МассивРезультатов[0].Выбрать();
	ВыборкаРасхождений = МассивРезультатов[1].Выбрать();
	ВыборкаИтогов = МассивРезультатов[2].Выбрать();
	
	ПервыйДокумент = Истина;
	Пока ВыборкаДокументов.Следующий() Цикл
		
		ВалютаРегламентированногоУчета = ЗначениеНастроекПовтИсп.ВалютаРегламентированногоУчетаОрганизации(ВыборкаДокументов.Организация);
		
		Если ПервыйДокумент Тогда
			ПервыйДокумент = Ложь;
		Иначе
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		ОбластьМакета = Макет.ПолучитьОбласть("Шапка");
		ОбластьМакета.Параметры.Заполнить(ВыборкаДокументов);
		ОбластьМакета.Параметры.НомерДокумента = ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(ВыборкаДокументов.Номер);
		ОбластьМакета.Параметры.ДатаДокумента = Формат(ВыборкаДокументов.ДатаДокумента, "ДЛФ=D");
		НаименованияНаДату = ОрганизацииПовтИсп.НаименованияНаДату(ВыборкаДокументов.Организация, ВыборкаДокументов.ДатаДокумента);
		ДанныеШапки = Новый Структура;
		ДанныеШапки.Вставить("ПредставлениеОрганизации", НаименованияНаДату.НаименованиеСокращенное);
		ОбластьМакета.Параметры.Заполнить(ДанныеШапки);
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		СтруктураПоиска = Новый Структура("Ссылка", ВыборкаДокументов.Ссылка);
		НомерПоПорядку = 1;
		Пока ВыборкаРасхождений.НайтиСледующий(СтруктураПоиска) Цикл
			ОбластьМакета = Макет.ПолучитьОбласть("СтрокаНаличныхДенег");
			ОбластьМакета.Параметры.Заполнить(ВыборкаРасхождений);
			ОбластьМакета.Параметры.НомерПоПорядку = НомерПоПорядку;
			ОбластьМакета.Параметры.НаименованиеЦенности = НСтр("ru = 'наличных денег';
																|en = 'cash '", Метаданные.Языки.Русский.КодЯзыка);
			ТабличныйДокумент.Вывести(ОбластьМакета);
			НомерПоПорядку = НомерПоПорядку + 1;
		КонецЦикла;
		Для Инд = НомерПоПорядку По 5 Цикл
			ОбластьМакета = Макет.ПолучитьОбласть("СтрокаНаличныхДенег");
			ОбластьМакета.Параметры.НомерПоПорядку = Инд;
			ТабличныйДокумент.Вывести(ОбластьМакета);
		КонецЦикла;
		
		ВыборкаРасхождений.Сбросить();
		
		ОбластьМакета = Макет.ПолучитьОбласть("Итоги");
		Если ВыборкаИтогов.НайтиСледующий(СтруктураПоиска) Тогда
		
			ОбластьМакета.Параметры.СуммаПоФактуРубли = Формат(Цел(ВыборкаИтогов.СуммаПоФактуРегл), "ЧЦ=15; ЧДЦ=0; ЧН='0'");
			КопеекПоФакту = (ВыборкаИтогов.СуммаПоФактуРегл - Цел(ВыборкаИтогов.СуммаПоФактуРегл)) * 100;
			ОбластьМакета.Параметры.СуммаПоФактуКопейки = Формат(КопеекПоФакту, "ЧЦ=2; ЧДЦ=0; ЧН='00'");
			
			ОбластьМакета.Параметры.СуммаПоУчетуРубли = Формат(Цел(ВыборкаИтогов.СуммаПоУчетуРегл), "ЧЦ=15; ЧДЦ=0; ЧН='0'");
			КопеекПоУчету = (ВыборкаИтогов.СуммаПоУчетуРегл - Цел(ВыборкаИтогов.СуммаПоУчетуРегл)) * 100;
			ОбластьМакета.Параметры.СуммаПоУчетуКопейки = Формат(КопеекПоУчету, "ЧЦ=2; ЧДЦ=0; ЧН='00'");
			
			ОбластьМакета.Параметры.СуммаИзлишекРубли = Формат(Цел(ВыборкаИтогов.СуммаИзлишекРегл), "ЧЦ=15; ЧДЦ=0; ЧН='0'");
			КопеекИзлишек = (ВыборкаИтогов.СуммаИзлишекРегл - Цел(ВыборкаИтогов.СуммаИзлишекРегл)) * 100;
			ОбластьМакета.Параметры.СуммаИзлишекКопейки = Формат(КопеекИзлишек, "ЧЦ=2; ЧДЦ=0; ЧН='00'");
			
			ОбластьМакета.Параметры.СуммаНедостачаРубли = Формат(Цел(ВыборкаИтогов.СуммаНедостачаРегл), "ЧЦ=15; ЧДЦ=0; ЧН='0'");
			КопеекНедостача = (ВыборкаИтогов.СуммаНедостачаРегл - Цел(ВыборкаИтогов.СуммаНедостачаРегл)) * 100;
			ОбластьМакета.Параметры.СуммаНедостачаКопейки = Формат(КопеекНедостача, "ЧЦ=2; ЧДЦ=0; ЧН='00'");
			
			ОбластьМакета.Параметры.СуммаПоФактуРеглПрописью = РаботаСКурсамиВалютУТ.СформироватьСуммуПрописью(
				ВыборкаИтогов.СуммаПоФактуРегл,
				ВалютаРегламентированногоУчета,
				Ложь);
			ОбластьМакета.Параметры.СуммаПоУчетуРеглПрописью = РаботаСКурсамиВалютУТ.СформироватьСуммуПрописью(
				ВыборкаИтогов.СуммаПоУчетуРегл,
				ВалютаРегламентированногоУчета,
				Ложь);
		КонецЕсли;
		
		ТабличныйДокумент.Вывести(ОбластьМакета);
		ВыборкаИтогов.Сбросить();
		
		ОбластьМакета = Макет.ПолучитьОбласть("Подвал");
		ОбластьМакета.Параметры.Заполнить(ВыборкаДокументов);
		ОбластьМакета.Параметры.НомерПКО = ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(ВыборкаДокументов.НомерПКО);
		ОбластьМакета.Параметры.НомерРКО = ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(ВыборкаДокументов.НомерРКО);
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		
		ОбластьМакета = Макет.ПолучитьОбласть("Страница2");
		ОбластьМакета.Параметры.Заполнить(ВыборкаДокументов);
		ТабличныйДокумент.Вывести(ОбластьМакета);
	КонецЦикла;
	
	Возврат ТабличныйДокумент;
	
КонецФункции
//-- Локализация
#КонецОбласти

//++ НЕ УТ
#Область ПроводкиРегУчета

// Функция возвращает текст запроса для отражения документа в регламентированном учете.
//
// Возвращаемое значение:
//	Строка - Текст запроса
//
Функция ТекстОтраженияВРеглУчете() Экспорт
	
	//++ Локализация

#Область Доходы

	ТекстДоходы = "
	|ВЫБРАТЬ // Излишки при инвентаризации ДС (Дт <50.01>:: Кт <91.01>)
	|
	|	Операция.Ссылка КАК Ссылка,
	|	Операция.Дата КАК Период,
	|	Операция.Организация КАК Организация,
	|	Строки.ИдентификаторСтроки КАК ИдентификаторСтроки,
	|
	|	Суммы.СуммаБезНДСРегл КАК Сумма,
	|	Суммы.СуммаБезНДСУпр КАК СуммаУУ,
	|
	|	ЗНАЧЕНИЕ(Перечисление.ВидыСчетовРеглУчета.ДенежныеСредства) КАК ВидСчетаДт,
	|	Строки.Касса КАК АналитикаУчетаДт,
	|	НЕОПРЕДЕЛЕНО КАК МестоУчетаДт,
	|
	|	Строки.Касса.ВалютаДенежныхСредств КАК ВалютаДт,
	|	Строки.Касса.Подразделение КАК ПодразделениеДт,
	|	Строки.Касса.НаправлениеДеятельности КАК НаправлениеДеятельностиДт,
	|	
	|	НЕОПРЕДЕЛЕНО КАК СчетДт,
	|	Строки.СтатьяДвиженияДенежныхСредств КАК СубконтоДт1,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоДт2,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоДт3,
	|	
	|	ВЫБОР КОГДА Строки.Касса.ВалютаДенежныхСредств = &ВалютаРеглУчета ТОГДА
	|		0
	|	ИНАЧЕ
	|		Строки.СуммаРасхождения
	|	КОНЕЦ КАК ВалютнаяСуммаДт,
	|	0 КАК КоличествоДт,
	|	0 КАК СуммаНУДт,
	|	0 КАК СуммаПРДт,
	|	0 КАК СуммаВРДт,
	|	
	|	ЗНАЧЕНИЕ(Перечисление.ВидыСчетовРеглУчета.Доходы) КАК ВидСчетаКт,
	|	СтатьиДоходов.Ссылка КАК АналитикаУчетаКт,
	|	Строки.Подразделение КАК МестоУчетаКт,
	|
	|	ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка) КАК ВалютаКт,
	|	Строки.Подразделение КАК ПодразделениеКт,
	|	Строки.Касса.НаправлениеДеятельности КАК НаправлениеДеятельностиКт,
	|
	|	НЕОПРЕДЕЛЕНО КАК СчетКт,
	|	СтатьиДоходов.Ссылка КАК СубконтоКт1,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоКт2,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоКт3,
	|
	|	0 КАК ВалютнаяСуммаКт,
	|	0 КАК КоличествоКт,
	|	0 КАК СуммаНУКт,
	|	0 КАК СуммаПРКт,
	|	0 КАК СуммаВРКт,
	|	""Излишки при инвентаризации ДС"" КАК Содержание
	|ИЗ
	|	ДокументыКОтражению КАК ДокументыКОтражению
	|	
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		Документ.ИнвентаризацияНаличныхДенежныхСредств КАК Операция
	|	ПО
	|		ДокументыКОтражению.Ссылка = Операция.Ссылка
	|	
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		Документ.ИнвентаризацияНаличныхДенежныхСредств.Кассы КАК Строки
	|	ПО
	|		Строки.Ссылка = Операция.Ссылка
	|	
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		РегистрСведений.СуммыДокументовВВалютахУчета КАК Суммы
	|	ПО
	|		Суммы.Регистратор = Операция.Ссылка
	|		И Суммы.ИдентификаторСтроки = Строки.ИдентификаторСтроки
	|	
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		ПланВидовХарактеристик.СтатьиДоходов КАК СтатьиДоходов
	|	ПО
	|		Строки.СтатьяДоходовРасходов = СтатьиДоходов.Ссылка
	|ГДЕ
	|	Строки.СуммаРасхождения > 0
	|";
	
#КонецОбласти

#Область Расходы
	
	ТекстРасходы = "
	|ВЫБРАТЬ // Недостача при инвентаризации ДС (Дт <94> :: Кт <50.01>)
	|
	|	Операция.Ссылка КАК Ссылка,
	|	Операция.Дата КАК Период,
	|	Операция.Организация КАК Организация,
	|	Строки.ИдентификаторСтроки КАК ИдентификаторСтроки,
	|	
	|	Суммы.СуммаБезНДСРегл КАК Сумма,
	|	Суммы.СуммаБезНДСУпр КАК СуммаУУ,
	|
	|	ЗНАЧЕНИЕ(Перечисление.ВидыСчетовРеглУчета.Расходы) КАК ВидСчетаДт,
	|	СтатьиРасходов.Ссылка КАК АналитикаУчетаДт,
	|	Строки.Подразделение КАК МестоУчетаДт,
	|	
	|	ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка) КАК ВалютаДт,
	|	Строки.Подразделение КАК ПодразделениеДт,
	|	Строки.Касса.НаправлениеДеятельности КАК НаправлениеДеятельностиДт,
	|
	|	ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ПустаяСсылка) КАК СчетДт,
	|	СтатьиРасходов.Ссылка КАК СубконтоДт1,
	|	Строки.АналитикаРасходов  КАК СубконтоДт2,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыЗатратРегл.Прочее) КАК СубконтоДт3,
	|	
	|	0 КАК ВалютнаяСуммаДт,
	|	0 КАК КоличествоДт,
	|	0 КАК СуммаНУДт,
	|	0 КАК СуммаПРДт,
	|	0 КАК СуммаВРДт,
	|	
	|	ЗНАЧЕНИЕ(Перечисление.ВидыСчетовРеглУчета.ДенежныеСредства) КАК ВидСчетаКт,
	|	Строки.Касса КАК ГруппаФинансовогоУчетаКт,
	|	НЕОПРЕДЕЛЕНО КАК МестоУчетаКт,
	|	
	|	Строки.Касса.ВалютаДенежныхСредств КАК ВалютаКт,
	|	Строки.Касса.Подразделение КАК ПодразделениеКт,
	|	Строки.Касса.НаправлениеДеятельности КАК НаправлениеДеятельностиКт,
	|	
	|	НЕОПРЕДЕЛЕНО КАК СчетКт,
	|	Строки.СтатьяДвиженияДенежныхСредств КАК СубконтоКт1,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоКт2,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоКт3,
	|	
	|	ВЫБОР КОГДА Строки.Касса.ВалютаДенежныхСредств = &ВалютаРеглУчета ТОГДА
	|		0
	|	ИНАЧЕ
	|		-Строки.СуммаРасхождения
	|	КОНЕЦ КАК ВалютнаяСуммаКт,
	|	0 КАК КоличествоКт,
	|	0 КАК СуммаНУКт,
	|	0 КАК СуммаПРКт,
	|	0 КАК СуммаВРКт,
	|	""Недостача при инвентаризации ДС"" КАК Содержание
	|	
	|ИЗ
	|	ДокументыКОтражению КАК ДокументыКОтражению
	|	
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		Документ.ИнвентаризацияНаличныхДенежныхСредств КАК Операция
	|	ПО
	|		ДокументыКОтражению.Ссылка = Операция.Ссылка
	|	
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		Документ.ИнвентаризацияНаличныхДенежныхСредств.Кассы КАК Строки
	|	ПО
	|		Строки.Ссылка = Операция.Ссылка
	|	
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		РегистрСведений.СуммыДокументовВВалютахУчета КАК Суммы
	|	ПО
	|		Суммы.Регистратор = Операция.Ссылка
	|		И Суммы.ИдентификаторСтроки = Строки.ИдентификаторСтроки
	|	
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		ПланВидовХарактеристик.СтатьиРасходов КАК СтатьиРасходов
	|	ПО
	|		Строки.СтатьяДоходовРасходов = СтатьиРасходов.Ссылка
	|ГДЕ
	|	Строки.СуммаРасхождения < 0
	|";
	
#КонецОбласти

	ТекстыОтражения = Новый Массив;
	ТекстыОтражения.Добавить(ТекстДоходы);
	ТекстыОтражения.Добавить(ТекстРасходы);
	
	Возврат СтрСоединить(ТекстыОтражения, ОбщегоНазначенияУТ.РазделительЗапросовВОбъединении());

	//-- Локализация
	Возврат "";
	
КонецФункции

// Функция возвращает текст запроса дополнительных временных таблиц,
// необходимых для отражения в регламентированном учете
//
// Возвращаемое значение:
//   Строка - сформированный текст запроса.
//
Функция ТекстЗапросаВТОтраженияВРеглУчете() Экспорт
	
	//++ Локализация
	//-- Локализация
	Возврат "";
	
КонецФункции

#КонецОбласти
//-- НЕ УТ

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Проведение

// Процедура дополняет тексты запросов проведения документа.
//
// Параметры:
//  Запрос - Запрос - Общий запрос проведения документа.
//  ТекстыЗапроса - СписокЗначений - Список текстов запроса проведения.
//  Регистры - Строка, Структура - Список регистров проведения документа через запятую или в ключах структуры.
//
Процедура ДополнитьТекстыЗапросовПроведения(Запрос, ТекстыЗапроса, Регистры) Экспорт
	
	//++ Локализация

	//++ НЕ УТ
	ТекстЗапросаТаблицаОтражениеДокументовВРеглУчете(Запрос, ТекстыЗапроса, Регистры);
	//-- НЕ УТ

	//-- Локализация
	
КонецПроцедуры
//++ Локализация

//++ НЕ УТ

Функция ТекстЗапросаТаблицаОтражениеДокументовВРеглУчете(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ОтражениеДокументовВРеглУчете";
	
	Если Не ПроведениеДокументов.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли; 
	
	Если Не ПроведениеДокументов.ЕстьТаблицаЗапроса("ВтПрочиеРасходы", ТекстыЗапроса) Тогда
		Документы.ИнвентаризацияНаличныхДенежныхСредств.ТекстЗапросаТаблицаВтПрочиеРасходы(Запрос, ТекстыЗапроса);
	КонецЕсли;
	
	Если Не ПроведениеДокументов.ЕстьТаблицаЗапроса("ВтПартииПрочихРасходов", ТекстыЗапроса) Тогда
		Документы.ИнвентаризацияНаличныхДенежныхСредств.ТекстЗапросаТаблицаВтПартииПрочихРасходов(Запрос, ТекстыЗапроса);
	КонецЕсли;
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	&Период                      КАК Период,
	|	&Организация                 КАК Организация,
	|	НАЧАЛОПЕРИОДА(&Период, ДЕНЬ) КАК ДатаОтражения
	|";
	ТекстЗапроса = ТекстЗапроса + "ОБЪЕДИНИТЬ ВСЕ"
		+ ДоходыИРасходыСервер.ДополнитьТекстЗапросаТаблицаОтражениеДокументовВРеглУчете();
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции
//-- НЕ УТ

//-- Локализация

#КонецОбласти

#КонецОбласти
