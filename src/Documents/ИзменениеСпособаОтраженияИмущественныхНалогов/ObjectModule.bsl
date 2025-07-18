#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	
	Если ТипДанныхЗаполнения = Тип("СправочникСсылка.ОбъектыЭксплуатации") Тогда
		
		ОбработкаЗаполненияОбъектЭксплуатации(ДанныеЗаполнения);
		
	КонецЕсли;
	
	ИнициализироватьДокумент();
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ИнициализироватьДокумент();
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ПроведениеДокументов.ПередЗаписьюДокумента(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	
	Если Не Отказ И Не ЭтоНовый() И РежимЗаписи <> РежимЗаписиДокумента.Запись Тогда
		ПодготовитьДанныеДляФормированияЗаданияКЗакрытиюМесяцаПередЗаписью();
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПроведениеДокументов.ПриЗаписиДокумента(ЭтотОбъект, Отказ);
	
	ПараметрыВыбораСтатейИАналитик = Документы.ИзменениеСпособаОтраженияИмущественныхНалогов.ПараметрыВыбораСтатейИАналитик();
	ДоходыИРасходыСервер.ПередЗаписью(ЭтотОбъект, ПараметрыВыбораСтатейИАналитик);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	НепроверяемыеРеквизиты = Новый Массив;
	
	ПараметрыВыбораСтатейИАналитик = Документы.ИзменениеСпособаОтраженияИмущественныхНалогов.ПараметрыВыбораСтатейИАналитик();
	ДоходыИРасходыСервер.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты, ПараметрыВыбораСтатейИАналитик);
		
	ПроверитьЧтоОсновныеСредстваСоответствуютВидуНалога(Отказ);
		
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, НепроверяемыеРеквизиты);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Документы.ИзменениеСпособаОтраженияИмущественныхНалогов.ПроверитьБлокировкуВходящихДанныхПриОбновленииИБ(
		НСтр("ru = 'Отмена регистрации земельных участков';
			|en = 'Cancel land plot registration'"));
	
	ПроведениеДокументов.ОбработкаПроведенияДокумента(ЭтотОбъект, Отказ);
	
	СформироватьЗаданияКЗакрытиюМесяцаПриЗаписи();
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеДокументов.ОбработкаУдаленияПроведенияДокумента(ЭтотОбъект, Отказ);
	
	СформироватьЗаданияКЗакрытиюМесяцаПриЗаписи();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Заполнение

Процедура ИнициализироватьДокумент()
	
	Ответственный = Пользователи.ТекущийПользователь();
	Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	
	ПараметрыВыбораСтатейИАналитик = Документы.ИзменениеСпособаОтраженияИмущественныхНалогов.ПараметрыВыбораСтатейИАналитик();
	ДоходыИРасходыСервер.ОбработкаЗаполнения(ЭтотОбъект, ПараметрыВыбораСтатейИАналитик);
	
КонецПроцедуры

Процедура ОбработкаЗаполненияОбъектЭксплуатации(ДанныеЗаполнения)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ОсновноеСредство", ДанныеЗаполнения);
	Запрос.УстановитьПараметр("Период", ?(ЗначениеЗаполнено(Дата), Дата, ТекущаяДатаСеанса()));
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ПараметрыНачисленияЗемельногоНалога.Организация,
	|	ПараметрыНачисленияЗемельногоНалога.КодКатегорииЗемель,
	|	ПараметрыНачисленияЗемельногоНалога.КадастровыйНомер,
	|	ПараметрыНачисленияЗемельногоНалога.КадастроваяСтоимость,
	|	ПараметрыНачисленияЗемельногоНалога.ОбщаяСобственность,
	|	ПараметрыНачисленияЗемельногоНалога.ДоляВПравеОбщейСобственностиЧислитель,
	|	ПараметрыНачисленияЗемельногоНалога.ДоляВПравеОбщейСобственностиЗнаменатель,
	|	ПараметрыНачисленияЗемельногоНалога.ЖилищноеСтроительство,
	|	ПараметрыНачисленияЗемельногоНалога.ДатаНачалаПроектирования,
	|	ПараметрыНачисленияЗемельногоНалога.ДатаРегистрацииПравНаОбъектНедвижимости,
	|	ПараметрыНачисленияЗемельногоНалога.ПостановкаНаУчетВНалоговомОргане,
	|	ПараметрыНачисленияЗемельногоНалога.НалоговыйОрган,
	|	ПараметрыНачисленияЗемельногоНалога.КодПоОКАТО,
	|	ПараметрыНачисленияЗемельногоНалога.НалоговаяСтавка,
	|	ПараметрыНачисленияЗемельногоНалога.НалоговаяЛьготаПоНалоговойБазе,
	|	ПараметрыНачисленияЗемельногоНалога.КодНалоговойЛьготыОсвобождениеОтНалогообложенияПоСтатье395,
	|	ПараметрыНачисленияЗемельногоНалога.КодНалоговойЛьготыУменьшениеНалоговойБазыПоСтатье391,
	|	ПараметрыНачисленияЗемельногоНалога.УменьшениеНалоговойБазыПоСтатье391,
	|	ПараметрыНачисленияЗемельногоНалога.УменьшениеНалоговойБазыНаСумму,
	|	ПараметрыНачисленияЗемельногоНалога.ДоляНеОблагаемойНалогомПлощадиЧислитель,
	|	ПараметрыНачисленияЗемельногоНалога.ДоляНеОблагаемойНалогомПлощадиЗнаменатель,
	|	ПараметрыНачисленияЗемельногоНалога.НеОблагаемаяНалогомСумма,
	|	ПараметрыНачисленияЗемельногоНалога.СниженнаяНалоговаяСтавка,
	|	ПараметрыНачисленияЗемельногоНалога.ПроцентУменьшенияСуммыНалога,
	|	ПараметрыНачисленияЗемельногоНалога.СуммаУменьшенияСуммыНалога
	|ИЗ
	|	РегистрСведений.ПараметрыНачисленияЗемельногоНалога.СрезПоследних(
	|		&Период, 
	|		ДатаИсправления = ДАТАВРЕМЯ(1,1,1)
	|			И ОсновноеСредство = &ОсновноеСредство) КАК ПараметрыНачисленияЗемельногоНалога";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Количество() > 0 Тогда
		Выборка.Следующий();
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, Выборка);
		ЗаполнитьЗначенияСвойств(ОС.Добавить(), Выборка);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ЗаданияКЗакрытиюМесяца

Процедура ПодготовитьДанныеДляФормированияЗаданияКЗакрытиюМесяцаПередЗаписью()
	
	ДополнительныеСвойства.Вставить("ТаблицыДанных",
		Новый Структура("МенеджерВременныхТаблиц", Новый МенеджерВременныхТаблиц));
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ТаблицаПередЗаписью.Дата КАК Период,
	|	ТаблицаПередЗаписью.Организация КАК Организация,
	|	ТаблицаПередЗаписью.ВидНалога
	|ПОМЕСТИТЬ ИзменениеСпособаОтраженияИмущественныхНалогов_ПередЗаписью
	|ИЗ
	|	Документ.ИзменениеСпособаОтраженияИмущественныхНалогов КАК ТаблицаПередЗаписью
	|ГДЕ
	|	ТаблицаПередЗаписью.Ссылка = &Ссылка
	|	И ТаблицаПередЗаписью.Проведен
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаПередЗаписью.Ссылка.Дата КАК Период,
	|	ТаблицаПередЗаписью.Подразделение,
	|	ТаблицаПередЗаписью.НаправлениеДеятельности,
	|	ТаблицаПередЗаписью.СтатьяРасходов,
	|	ТаблицаПередЗаписью.АналитикаРасходов,
	|	ТаблицаПередЗаписью.Коэффициент
	|ПОМЕСТИТЬ ИзменениеСпособаОтраженияИмущественныхНалогов_ОтражениеРасходов_ПередЗаписью
	|ИЗ
	|	Документ.ИзменениеСпособаОтраженияИмущественныхНалогов.ОтражениеРасходов КАК ТаблицаПередЗаписью
	|ГДЕ
	|	ТаблицаПередЗаписью.Ссылка = &Ссылка
	|	И ТаблицаПередЗаписью.Ссылка.Проведен
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаПередЗаписью.Ссылка.Дата КАК Период,
	|	ТаблицаПередЗаписью.ОсновноеСредство
	|ПОМЕСТИТЬ ИзменениеСпособаОтраженияИмущественныхНалогов_ОС_ПередЗаписью
	|ИЗ
	|	Документ.ИзменениеСпособаОтраженияИмущественныхНалогов.ОС КАК ТаблицаПередЗаписью
	|ГДЕ
	|	ТаблицаПередЗаписью.Ссылка = &Ссылка
	|	И ТаблицаПередЗаписью.Ссылка.Проведен";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.МенеджерВременныхТаблиц = ДополнительныеСвойства.ТаблицыДанных.МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.Выполнить();
	
КонецПроцедуры

Процедура СформироватьЗаданияКЗакрытиюМесяцаПриЗаписи()
	
	Если ПроведениеДокументов.СвойстваДокумента(ЭтотОбъект).ЭтоНовый Тогда
		Возврат;
	КонецЕсли;
	
	ТекстЗапроса =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	НАЧАЛОПЕРИОДА(ТаблицаПередЗаписью.Период, МЕСЯЦ) КАК Период
	|ИЗ
	|	ИзменениеСпособаОтраженияИмущественныхНалогов_ОтражениеРасходов_ПередЗаписью КАК ТаблицаПередЗаписью
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ИзменениеСпособаОтраженияИмущественныхНалогов.ОтражениеРасходов КАК ТаблицаПослеЗаписи
	|		ПО ТаблицаПередЗаписью.Подразделение = ТаблицаПослеЗаписи.Подразделение
	|			И ТаблицаПередЗаписью.НаправлениеДеятельности = ТаблицаПослеЗаписи.НаправлениеДеятельности
	|			И ТаблицаПередЗаписью.СтатьяРасходов = ТаблицаПослеЗаписи.СтатьяРасходов
	|			И ТаблицаПередЗаписью.АналитикаРасходов = ТаблицаПослеЗаписи.АналитикаРасходов
	|			И ТаблицаПередЗаписью.Коэффициент = ТаблицаПослеЗаписи.Коэффициент
	|			И (ТаблицаПослеЗаписи.Ссылка = &Ссылка)
	|			И (ТаблицаПослеЗаписи.Ссылка.Проведен)
	|ГДЕ
	|	ТаблицаПослеЗаписи.Ссылка ЕСТЬ NULL
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	НАЧАЛОПЕРИОДА(&Дата, МЕСЯЦ)
	|ИЗ
	|	Документ.ИзменениеСпособаОтраженияИмущественныхНалогов.ОтражениеРасходов КАК ТаблицаПослеЗаписи
	|		ЛЕВОЕ СОЕДИНЕНИЕ ИзменениеСпособаОтраженияИмущественныхНалогов_ОтражениеРасходов_ПередЗаписью КАК ТаблицаПередЗаписью
	|		ПО ТаблицаПередЗаписью.Подразделение = ТаблицаПослеЗаписи.Подразделение
	|			И ТаблицаПередЗаписью.НаправлениеДеятельности = ТаблицаПослеЗаписи.НаправлениеДеятельности
	|			И ТаблицаПередЗаписью.СтатьяРасходов = ТаблицаПослеЗаписи.СтатьяРасходов
	|			И ТаблицаПередЗаписью.АналитикаРасходов = ТаблицаПослеЗаписи.АналитикаРасходов
	|			И ТаблицаПередЗаписью.Коэффициент = ТаблицаПослеЗаписи.Коэффициент
	|ГДЕ
	|	ТаблицаПослеЗаписи.Ссылка = &Ссылка
	|	И ТаблицаПередЗаписью.Подразделение ЕСТЬ NULL
	|	И ТаблицаПослеЗаписи.Ссылка.Проведен";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.МенеджерВременныхТаблиц = ДополнительныеСвойства.ТаблицыДанных.МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("ВидНалога", ВидНалога);
	Запрос.УстановитьПараметр("Дата", Дата);
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		// Реквизиты документа не изменились.
		Возврат;
	КонецЕсли;
	
	// Реквизиты документа изменились.
	// Нужно сформировать задания по ОС указанным в ТЧ до записи и после записи.
	ТекстЗапроса =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Таблица.Период           КАК Период,
	|	Таблица.Организация      КАК Организация,
	|	Таблица.ОсновноеСредство КАК ОсновноеСредство,
	|	ИСТИНА                   КАК ОтражатьВРеглУчете,
	|	ЛОЖЬ                     КАК ОтражатьВУпрУчете,
	|	&Ссылка                  КАК Документ
	|ПОМЕСТИТЬ ИзменениеСпособаОтраженияИмущественныхНалогов_НалогНаИмуществоИзменение
	|ИЗ
	|	(ВЫБРАТЬ
	|		ШапкаПередЗаписью.Период              КАК Период,
	|		ШапкаПередЗаписью.Организация         КАК Организация,
	|		ТаблицаПередЗаписью.ОсновноеСредство  КАК ОсновноеСредство
	|	ИЗ
	|		ИзменениеСпособаОтраженияИмущественныхНалогов_ОС_ПередЗаписью КАК ТаблицаПередЗаписью
	|			ЛЕВОЕ СОЕДИНЕНИЕ ИзменениеСпособаОтраженияИмущественныхНалогов_ПередЗаписью КАК ШапкаПередЗаписью
	|			ПО ИСТИНА
	|	ГДЕ
	|		ШапкаПередЗаписью.ВидНалога = ЗНАЧЕНИЕ(Перечисление.ВидыИмущественныхНалогов.НалогНаИмущество)
	|			ИЛИ ШапкаПередЗаписью.ВидНалога = ЗНАЧЕНИЕ(Перечисление.ВидыИмущественныхНалогов.ПустаяСсылка)
	|
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		&Дата,
	|		&Организация,
	|		ТаблицаПриЗаписи.ОсновноеСредство
	|	ИЗ
	|		Документ.ИзменениеСпособаОтраженияИмущественныхНалогов.ОС КАК ТаблицаПриЗаписи
	|	ГДЕ
	|		ТаблицаПриЗаписи.Ссылка = &Ссылка
	|		И (&ВидНалога = ЗНАЧЕНИЕ(Перечисление.ВидыИмущественныхНалогов.НалогНаИмущество)
	|			ИЛИ &ВидНалога = ЗНАЧЕНИЕ(Перечисление.ВидыИмущественныхНалогов.ПустаяСсылка))
	|
	|	) КАК Таблица
	|
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Таблица.Период           КАК Период,
	|	Таблица.Организация      КАК Организация,
	|	Таблица.ОсновноеСредство КАК ОсновноеСредство,
	|	ИСТИНА                   КАК ОтражатьВРеглУчете,
	|	ЛОЖЬ                     КАК ОтражатьВУпрУчете,
	|	&Ссылка                  КАК Документ
	|ПОМЕСТИТЬ ИзменениеСпособаОтраженияИмущественныхНалогов_ТранспортныйНалогИзменение
	|ИЗ
	|	(ВЫБРАТЬ
	|		ШапкаПередЗаписью.Период              КАК Период,
	|		ШапкаПередЗаписью.Организация         КАК Организация,
	|		ТаблицаПередЗаписью.ОсновноеСредство  КАК ОсновноеСредство
	|	ИЗ
	|		ИзменениеСпособаОтраженияИмущественныхНалогов_ОС_ПередЗаписью КАК ТаблицаПередЗаписью
	|			ЛЕВОЕ СОЕДИНЕНИЕ ИзменениеСпособаОтраженияИмущественныхНалогов_ПередЗаписью КАК ШапкаПередЗаписью
	|			ПО ИСТИНА
	|	ГДЕ
	|		ШапкаПередЗаписью.ВидНалога = ЗНАЧЕНИЕ(Перечисление.ВидыИмущественныхНалогов.НалогНаИмущество)
	|			ИЛИ ШапкаПередЗаписью.ВидНалога = ЗНАЧЕНИЕ(Перечисление.ВидыИмущественныхНалогов.ПустаяСсылка)
	|
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		&Дата,
	|		&Организация,
	|		ТаблицаПриЗаписи.ОсновноеСредство
	|	ИЗ
	|		Документ.ИзменениеСпособаОтраженияИмущественныхНалогов.ОС КАК ТаблицаПриЗаписи
	|	ГДЕ
	|		ТаблицаПриЗаписи.Ссылка = &Ссылка
	|		И (&ВидНалога = ЗНАЧЕНИЕ(Перечисление.ВидыИмущественныхНалогов.ТранспортныйНалог)
	|			ИЛИ &ВидНалога = ЗНАЧЕНИЕ(Перечисление.ВидыИмущественныхНалогов.ПустаяСсылка))
	|
	|	) КАК Таблица
	|
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Таблица.Период           КАК Период,
	|	Таблица.Организация      КАК Организация,
	|	Таблица.ОсновноеСредство КАК ОсновноеСредство,
	|	ИСТИНА                   КАК ОтражатьВРеглУчете,
	|	ЛОЖЬ                     КАК ОтражатьВУпрУчете,
	|	&Ссылка                  КАК Документ
	|ПОМЕСТИТЬ ИзменениеСпособаОтраженияИмущественныхНалогов_ЗемельныйНалогИзменение
	|ИЗ
	|	(ВЫБРАТЬ
	|		ШапкаПередЗаписью.Период              КАК Период,
	|		ШапкаПередЗаписью.Организация         КАК Организация,
	|		ТаблицаПередЗаписью.ОсновноеСредство  КАК ОсновноеСредство
	|	ИЗ
	|		ИзменениеСпособаОтраженияИмущественныхНалогов_ОС_ПередЗаписью КАК ТаблицаПередЗаписью
	|			ЛЕВОЕ СОЕДИНЕНИЕ ИзменениеСпособаОтраженияИмущественныхНалогов_ПередЗаписью КАК ШапкаПередЗаписью
	|			ПО ИСТИНА
	|	ГДЕ
	|		ШапкаПередЗаписью.ВидНалога = ЗНАЧЕНИЕ(Перечисление.ВидыИмущественныхНалогов.НалогНаИмущество)
	|			ИЛИ ШапкаПередЗаписью.ВидНалога = ЗНАЧЕНИЕ(Перечисление.ВидыИмущественныхНалогов.ПустаяСсылка)
	|
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		&Дата,
	|		&Организация,
	|		ТаблицаПриЗаписи.ОсновноеСредство
	|	ИЗ
	|		Документ.ИзменениеСпособаОтраженияИмущественныхНалогов.ОС КАК ТаблицаПриЗаписи
	|	ГДЕ
	|		ТаблицаПриЗаписи.Ссылка = &Ссылка
	|		И (&ВидНалога = ЗНАЧЕНИЕ(Перечисление.ВидыИмущественныхНалогов.ЗемельныйНалог)
	|			ИЛИ &ВидНалога = ЗНАЧЕНИЕ(Перечисление.ВидыИмущественныхНалогов.ПустаяСсылка))
	|
	|	) КАК Таблица
	|
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ИзменениеСпособаОтраженияИмущественныхНалогов_ОтражениеРасходов_ПередЗаписью
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ИзменениеСпособаОтраженияИмущественныхНалогов_ОС_ПередЗаписью
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ИзменениеСпособаОтраженияИмущественныхНалогов_ПередЗаписью";
	Запрос.Текст = ТекстЗапроса;
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	
	// НалогНаИмущество
	Выборка = РезультатЗапроса[0].Выбрать();
	Выборка.Следующий();
	
	ДополнительныеСвойства.ТаблицыДанных.Вставить("ИзменениеСпособаОтраженияИмущественныхНалогов_НалогНаИмуществоИзменение", Выборка.Количество > 0);
	
	// ТранспортныйНалог
	Выборка = РезультатЗапроса[1].Выбрать();
	Выборка.Следующий();
	
	ДополнительныеСвойства.ТаблицыДанных.Вставить("ИзменениеСпособаОтраженияИмущественныхНалогов_ТранспортныйНалогИзменение", Выборка.Количество > 0);
	
	// ЗемельныйНалог
	Выборка = РезультатЗапроса[2].Выбрать();
	Выборка.Следующий();
	
	ДополнительныеСвойства.ТаблицыДанных.Вставить("ИзменениеСпособаОтраженияИмущественныхНалогов_ЗемельныйНалогИзменение", Выборка.Количество > 0);
	
	ВнеоборотныеАктивы.СформироватьЗаписиРегистровЗаданий(ЭтотОбъект, ДополнительныеСвойства.ТаблицыДанных);
	
КонецПроцедуры

#КонецОбласти

#Область ПроверкаЗаполнения

Процедура ПроверитьЧтоОсновныеСредстваСоответствуютВидуНалога(Отказ)

	Если НЕ ЗначениеЗаполнено(ВидНалога) Тогда
		Возврат;
	КонецЕсли; 
	
	Если ВидНалога = Перечисления.ВидыИмущественныхНалогов.НалогНаИмущество Тогда
		ШаблонСообщенияГруппаОС = НСтр("ru = 'Основное средство ""%1"" не должно относиться к группе ОС ""Земельные участки"".';
										|en = 'Fixed asset ""%1"" should not belong to the ""Land plots"" FA group'");
		ШаблонСообщенияАмГруппа = НСтр("ru = 'Основное средство ""%1"" не должно относиться к первой или второй амортизационным группам.';
										|en = 'Fixed asset ""%1"" should not belong to the first or second depreciation group.'");
		ШаблонСообщенияНедвижимоеИмущество = НСтр("ru = 'Основное средство ""%1"" должно относиться к недвижимому имуществу.';
													|en = 'The ""%1"" fixed asset must belong to real estate.'");
	ИначеЕсли ВидНалога = Перечисления.ВидыИмущественныхНалогов.ТранспортныйНалог Тогда
		ШаблонСообщенияГруппаОС = НСтр("ru = 'Основное средство ""%1"" должно относиться к группе ОС ""Транспортные средства"", ""Машины и оборудование (кроме офисного)"".';
										|en = 'Fixed asset ""%1"" should belong to the ""Vehicles"", ""Machines and equipment (except for office one)"" FA group.'");
	ИначеЕсли ВидНалога = Перечисления.ВидыИмущественныхНалогов.ЗемельныйНалог Тогда
		ШаблонСообщенияГруппаОС = НСтр("ru = 'Основное средство ""%1"" должно относиться к группе ОС ""Земельные участки"".';
										|en = 'Fixed asset ""%1"" should belong to the ""Land plots"" FA group'");
	КонецЕсли; 
	
	Результат = Документы.ИзменениеСпособаОтраженияИмущественныхНалогов.ОсновныеСредстваКоторыеНеСоответствуютВидуНалога(
					ВидНалога, 
					ОС.ВыгрузитьКолонку("ОсновноеСредство"), 
					Дата,
					Организация);
	
	Для каждого ЭлементКоллекции Из Результат Цикл
		
		ДанныеСтроки = ОС.Найти(ЭлементКоллекции.Ссылка, "ОсновноеСредство");
		
		Если ВидНалога = Перечисления.ВидыИмущественныхНалогов.НалогНаИмущество Тогда
			
			Если Дата < '201901010000'
				И (ЭлементКоллекции.АмортизационнаяГруппа = Перечисления.АмортизационныеГруппы.ПерваяГруппа
					ИЛИ ЭлементКоллекции.АмортизационнаяГруппа = Перечисления.АмортизационныеГруппы.ВтораяГруппа) Тогда
			
				ТекстСообщения = СтрШаблон(ШаблонСообщенияАмГруппа, ЭлементКоллекции.Наименование);
			Иначе
				ТекстСообщения = СтрШаблон(ШаблонСообщенияНедвижимоеИмущество, ЭлементКоллекции.Наименование);
			КонецЕсли;
			
			Поле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("ОС", ДанныеСтроки.НомерСтроки, "ОсновноеСредство");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "", Отказ);
			
		КонецЕсли; 
		
		Если ВидНалога <> Перечисления.ВидыИмущественныхНалогов.НалогНаИмущество
			ИЛИ ЭлементКоллекции.ГруппаОС = Перечисления.ГруппыОС.ЗемельныеУчастки Тогда
			
			ТекстСообщения = СтрШаблон(ШаблонСообщенияГруппаОС, ЭлементКоллекции.Наименование);
			
			Поле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("ОС", ДанныеСтроки.НомерСтроки, "ОсновноеСредство");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "", Отказ);
			
		КонецЕсли; 
	
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
