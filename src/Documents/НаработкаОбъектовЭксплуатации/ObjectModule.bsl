#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриКопировании(ОбъектКопирования)
	
	ИнициализироватьДокумент();
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	
	Если ТипДанныхЗаполнения = Тип("Структура") Тогда
		
		Если ДанныеЗаполнения.Свойство("ДокументОснование") И ТипЗнч(ДанныеЗаполнения.ДокументОснование) = Тип("Массив") Тогда
			
			ЗаполнитьНаОснованииМассиваРаспоряжений(ДанныеЗаполнения.ДокументОснование);
			
		Иначе
			
			ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
			
		КонецЕсли;
		
	ИначеЕсли ТипДанныхЗаполнения = Тип("СправочникСсылка.ОбъектыЭксплуатации")
		//++ НЕ УТКА
		Или ТипДанныхЗаполнения = Тип("СправочникСсылка.УзлыОбъектовЭксплуатации")
		//-- НЕ УТКА
		Тогда
		
		ЗаполнитьДокументНаОснованииОбъектаЭксплуатации(ДанныеЗаполнения);
		
	КонецЕсли;
	
	ИнициализироватьДокумент(ДанныеЗаполнения);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	МассивНепроверяемыхРеквизитов.Добавить("Наработки.ОбъектЭксплуатации");
	
	Документы.НаработкаОбъектовЭксплуатации.ПроверкаТаблицыНаработок(ЭтотОбъект, Наработки, Отказ);
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ПроведениеДокументов.ПередЗаписьюДокумента(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	
	//++ НЕ УТКА
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьУправлениеРемонтами") Тогда
		
		РассчитатьСреднесуточныеЗначения();
		
		РасчетныеНаработки.Очистить();
		РассчитатьЗависимыеПоказателиНаработок(Наработки);
		
	КонецЕсли;
	
	//-- НЕ УТКА
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПроведениеДокументов.ПриЗаписиДокумента(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеДокументов.ОбработкаПроведенияДокумента(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеДокументов.ОбработкаУдаленияПроведенияДокумента(ЭтотОбъект, Отказ);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Инициализирует документ
//
Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено)
	
	Дата = ТекущаяДатаСеанса();
	Ответственный = Пользователи.ТекущийПользователь();
	
КонецПроцедуры

// Заполняет документ на основании массива
//
Процедура ЗаполнитьНаОснованииМассиваРаспоряжений(МассивРаспоряжений)
	
	Наработки.Очистить();
	Для Каждого Распоряжение Из МассивРаспоряжений Цикл
		НоваяСтрока = Наработки.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Распоряжение);
	КонецЦикла;
	
КонецПроцедуры

// Заполняет документ на основании объекта 
//
Процедура ЗаполнитьДокументНаОснованииОбъектаЭксплуатации(ДанныеЗаполнения)
	
	Наработки.Очистить();
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТекстЗапроса = РегистрацияНаработокЛокализация.ТекстЗапросаДляЗаполненияДокументаНаОснованииОбъектаЭксплуатации();
	
	Если ТекстЗапроса = Неопределено Тогда
		
		ТекстЗапроса =
		"
		//++ НЕ УТКА
		|ВЫБРАТЬ
		|	Объекты.Ссылка КАК ОбъектЭксплуатации,
		|	ЕСТЬNULL(ПоказателиНаработки.ПоказательНаработки, ЗНАЧЕНИЕ(Справочник.ПоказателиНаработки.ПустаяСсылка)) КАК ПоказательНаработки,
		|	Объекты.Статус КАК Статус,
		|	ВЫБОР
		|		КОГДА Объекты.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыОбъектовЭксплуатации.ВЭксплуатации)
		|			ТОГДА ЛОЖЬ
		|		ИНАЧЕ ИСТИНА
		|	КОНЕЦ КАК ЕстьОшибкиСтатус,
		|	Объекты.ПометкаУдаления КАК ЕстьОшибкиУдален,
		|	Объекты.ЭтоГруппа КАК ЕстьОшибкиГруппа
		|ИЗ
		|	Справочник.ОбъектыЭксплуатации КАК Объекты
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КлассыОбъектовЭксплуатации.ПоказателиНаработки КАК ПоказателиНаработки
		|		ПО Объекты.Класс = ПоказателиНаработки.Ссылка
		|			И (НЕ ПоказателиНаработки.РегистрироватьОтИсточника)
		|ГДЕ
		|	Объекты.Ссылка = &ОбъектЭксплуатации И &ИспользоватьУправлениеРемонтами
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		//-- НЕ УТКА
		|ВЫБРАТЬ
		|	Объекты.Ссылка КАК ОбъектЭксплуатации,
		|	ЕСТЬNULL(ПорядокУчетаОС.ПоказательНаработки, ЗНАЧЕНИЕ(Справочник.ПоказателиНаработки.ПустаяСсылка)) КАК ПоказательНаработки,
		|	Объекты.Статус КАК Статус,
		|	ЛОЖЬ КАК ЕстьОшибкиСтатус,
		|	Объекты.ПометкаУдаления КАК ЕстьОшибкиУдален,
		|	Объекты.ЭтоГруппа КАК ЕстьОшибкиГруппа
		|ИЗ
		|	Справочник.ОбъектыЭксплуатации КАК Объекты
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПорядокУчетаОС.СрезПоследних(
		|				&Дата, 
		|				ДатаИсправления = ДАТАВРЕМЯ(1,1,1)
		|					И ОсновноеСредство В (&ОбъектЭксплуатации)) КАК ПорядокУчетаОС
		|		ПО Объекты.Ссылка = ПорядокУчетаОС.ОсновноеСредство
		|ГДЕ
		|	Объекты.Ссылка = &ОбъектЭксплуатации И НЕ &ИспользоватьУправлениеРемонтами
		//++ НЕ УТКА
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Узлы.Ссылка КАК ОбъектЭксплуатации,
		|	ЕСТЬNULL(ПоказателиНаработки.ПоказательНаработки, ЗНАЧЕНИЕ(Справочник.ПоказателиНаработки.ПустаяСсылка)) КАК ПоказательНаработки,
		|	Узлы.Статус КАК Статус,
		|	ВЫБОР
		|		КОГДА Узлы.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыОбъектовЭксплуатации.ВЭксплуатации)
		|			ТОГДА ЛОЖЬ
		|		ИНАЧЕ ИСТИНА
		|	КОНЕЦ КАК ЕстьОшибкиСтатус,
		|	Узлы.ПометкаУдаления КАК ЕстьОшибкиУдален
		|ИЗ
		|	Справочник.УзлыОбъектовЭксплуатации КАК Узлы
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КлассыОбъектовЭксплуатации.ПоказателиНаработки КАК ПоказателиНаработки
		|		ПО Узлы.Класс = ПоказателиНаработки.Ссылка
		|			И (НЕ ПоказателиНаработки.РегистрироватьОтИсточника)
		|ГДЕ
		|	Узлы.Ссылка = &ОбъектЭксплуатации
		//-- НЕ УТКА
		|";
		
	КонецЕсли; 
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("ОбъектЭксплуатации", ДанныеЗаполнения);
	Запрос.УстановитьПараметр("Дата", ?(ЗначениеЗаполнено(Дата), Дата, ТекущаяДатаСеанса()));
	Запрос.УстановитьПараметр("ИспользоватьУправлениеРемонтами", ПолучитьФункциональнуюОпцию("ИспользоватьУправлениеРемонтами"));
	Запрос.УстановитьПараметр("ИспользуетсяУправлениеВНА_2_4", ВнеоборотныеАктивы.ИспользуетсяУправлениеВНА_2_4(Дата));
	
	ТекстОшибкиГруппа = НСтр("ru = 'Элемент справочника ""%1"" является группой. Ввод на основании групп справочника запрещен.';
							|en = '""%1"" is a group. Cannot generate documents from a group.'");
	ТекстОшибкиУдален = НСтр("ru = '%1 ""%2"" помечен на удаление. Ввод на основании помеченного на удаление элемента справочника запрещен.';
							|en = '%1 ""%2"" is marked for deletion. Cannot generate documents from items that have been marked for deletion.'");
	ТекстОшибкиСтатус = НСтр("ru = '%1 ""%2"" находится в статусе ""%3"". Ввод на основании разрешен только в статусе ""В эксплуатации"".';
							|en = '%1 ""%2"" in ""%3"" status. To generate a document, change its status to ""Operating"".'");
	ТекстОшибкиПоказатель = НСтр("ru = 'Для %1 ""%2"" нет доступных для регистрации показателей наработки';
								|en = '%1 ""%2"" has no operating time units to register'");
	
	УстановитьПривилегированныйРежим(Истина);
	Пакет = Запрос.ВыполнитьПакет();
	УстановитьПривилегированныйРежим(Ложь);
	
	Если Не Пакет[0].Пустой() Тогда
		
		Выборка = Пакет[0].Выбрать();
		
		Пока Выборка.Следующий() Цикл
			Если Выборка.ЕстьОшибкиГруппа Тогда
				ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					ТекстОшибкиГруппа,
					Выборка.ОбъектЭксплуатации);
				ВызватьИсключение ТекстОшибки;
			ИначеЕсли Выборка.ЕстьОшибкиУдален Тогда
				ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					ТекстОшибкиУдален,
					НСтр("ru = 'Объект эксплуатации';
						|en = 'Asset'"),
					Выборка.ОбъектЭксплуатации);
				ВызватьИсключение ТекстОшибки;
			ИначеЕсли Выборка.ЕстьОшибкиСтатус Тогда
				ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					ТекстОшибкиСтатус,
					НСтр("ru = 'Объект эксплуатации';
						|en = 'Asset'"),
					Выборка.ОбъектЭксплуатации,
					Выборка.Статус);
				ВызватьИсключение ТекстОшибки;
			ИначеЕсли Не ЗначениеЗаполнено(Выборка.ПоказательНаработки) Тогда
				ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					ТекстОшибкиПоказатель,
					НСтр("ru = 'объекта эксплуатации';
						|en = 'asset'"),
					Выборка.ОбъектЭксплуатации);
				ВызватьИсключение ТекстОшибки;
			КонецЕсли;
			
			ЗаполнитьЗначенияСвойств(Наработки.Добавить(), Выборка);
		КонецЦикла;
		
	КонецЕсли;
	
	//++ НЕ УТКА
	
	Если Не Пакет[1].Пустой() Тогда
		Выборка = Пакет[1].Выбрать();
		Пока Выборка.Следующий() Цикл
			Если Выборка.ЕстьОшибкиУдален Тогда
				ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					ТекстОшибкиУдален,
					НСтр("ru = 'Узел объекта эксплуатации';
						|en = 'Sub-asset'"),
					Выборка.ОбъектЭксплуатации);
				ВызватьИсключение ТекстОшибки;
			ИначеЕсли Выборка.ЕстьОшибкиСтатус Тогда
				ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					ТекстОшибкиСтатус,
					НСтр("ru = 'Узел объекта эксплуатации';
						|en = 'Sub-asset'"),
					Выборка.ОбъектЭксплуатации,
					Выборка.Статус);
				ВызватьИсключение ТекстОшибки;
			ИначеЕсли Не ЗначениеЗаполнено(Выборка.ПоказательНаработки) Тогда
				ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					ТекстОшибкиПоказатель,
					НСтр("ru = 'узла объекта эксплуатации';
						|en = 'Sub-asset'"),
					Выборка.ОбъектЭксплуатации);
				ВызватьИсключение ТекстОшибки;
			КонецЕсли;
			ЗаполнитьЗначенияСвойств(Наработки.Добавить(), Выборка);
		КонецЦикла;
		
	КонецЕсли;
	
	//-- НЕ УТКА
	
КонецПроцедуры

//++ НЕ УТКА

// Рассчитывает значения зависимых показателей наработок
//
// Параметры:
// 		МассивСтрок - Массив - Массив со строками табличной части.
//
Процедура РассчитатьЗависимыеПоказателиНаработок(ТабличнаяЧастьИсточник, МассивСтрок = Неопределено)
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ТаблицаДокумента.ОбъектЭксплуатации КАК ОбъектЭксплуатации,
		|	ВЫРАЗИТЬ(ТаблицаДокумента.ПоказательНаработки КАК Справочник.ПоказателиНаработки) КАК ПоказательНаработки,
		|	ВЫРАЗИТЬ(ТаблицаДокумента.Значение КАК ЧИСЛО) КАК Значение,
		|	ВЫРАЗИТЬ(ТаблицаДокумента.СреднесуточноеЗначение КАК ЧИСЛО) КАК СреднесуточноеЗначение
		|ПОМЕСТИТЬ ТаблицаДокумента
		|ИЗ
		|	&ТаблицаДокумента КАК ТаблицаДокумента
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ПараметрыУчета.Ссылка КАК ОбъектЭксплуатации,
		|	ПараметрыУчета.ПоказательНаработки КАК ПоказательНаработки,
		|	ТаблицаДокумента.Значение + ПараметрыУчета.СмещениеЗначения КАК Значение,
		|	ТаблицаДокумента.СреднесуточноеЗначение КАК СреднесуточноеЗначение
		|ИЗ
		|	ТаблицаДокумента КАК ТаблицаДокумента
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ОбъектыЭксплуатации.ПараметрыУчетаНаработок КАК ПараметрыУчета
		|		ПО ТаблицаДокумента.ОбъектЭксплуатации = ПараметрыУчета.ИсточникПараметра
		|ГДЕ
		|	ПараметрыУчета.Ссылка.Статус В (ЗНАЧЕНИЕ(Перечисление.СтатусыОбъектовЭксплуатации.ВЭксплуатации))
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ПараметрыУчета.Ссылка,
		|	ПараметрыУчета.ПоказательНаработки,
		|	ТаблицаДокумента.Значение + ПараметрыУчета.СмещениеЗначения,
		|	ТаблицаДокумента.СреднесуточноеЗначение
		|ИЗ
		|	ТаблицаДокумента КАК ТаблицаДокумента
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.УзлыОбъектовЭксплуатации.ПараметрыУчетаНаработок КАК ПараметрыУчета
		|		ПО ТаблицаДокумента.ОбъектЭксплуатации = ПараметрыУчета.ИсточникПараметра
		|ГДЕ
		|	ПараметрыУчета.Ссылка.Статус В (ЗНАЧЕНИЕ(Перечисление.СтатусыОбъектовЭксплуатации.ВЭксплуатации))");
	Запрос.УстановитьПараметр("ТаблицаДокумента", ТабличнаяЧастьИсточник.Выгрузить(МассивСтрок, "ОбъектЭксплуатации, ПоказательНаработки, Значение, СреднесуточноеЗначение"));
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	МассивДобавленныхСтрок = Новый Массив;
	Выборка = Результат.Выбрать();
	Пока Выборка.Следующий() Цикл
		
		НоваяСтрока = РасчетныеНаработки.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
		
		МассивДобавленныхСтрок.Добавить(НоваяСтрока);
		
	КонецЦикла;
	
	РассчитатьЗависимыеПоказателиНаработок(РасчетныеНаработки, МассивДобавленныхСтрок);
	
КонецПроцедуры

// Рассчитывает среднесуточные значения показателей наработок
//
Процедура РассчитатьСреднесуточныеЗначения()
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ВЫРАЗИТЬ(ТаблицаДокумента.НомерСтроки - 1 КАК ЧИСЛО) КАК ИндексСтроки,
		|	ТаблицаДокумента.ОбъектЭксплуатации КАК ОбъектЭксплуатации,
		|	ВЫРАЗИТЬ(ТаблицаДокумента.ПоказательНаработки КАК Справочник.ПоказателиНаработки) КАК ПоказательНаработки,
		|	ВЫРАЗИТЬ(ТаблицаДокумента.Значение КАК ЧИСЛО) КАК Значение
		|ПОМЕСТИТЬ ДанныеТабличнойЧасти
		|ИЗ
		|	&ТаблицаДокумента КАК ТаблицаДокумента
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТаблицаДокумента.ИндексСтроки КАК ИндексСтроки,
		|	ЕСТЬNULL(Объекты.Ссылка, Узлы.Ссылка) КАК ОбъектЭксплуатации,
		|	ТаблицаДокумента.ПоказательНаработки КАК ПоказательНаработки,
		|	ТаблицаДокумента.Значение КАК Значение
		|ПОМЕСТИТЬ ТаблицаДокумента
		|ИЗ
		|	ДанныеТабличнойЧасти КАК ТаблицаДокумента
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ОбъектыЭксплуатации КАК Объекты
		|		ПО ТаблицаДокумента.ОбъектЭксплуатации = Объекты.Ссылка
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.УзлыОбъектовЭксплуатации КАК Узлы
		|		ПО ТаблицаДокумента.ОбъектЭксплуатации = Узлы.Ссылка
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	ОбъектЭксплуатации,
		|	ПоказательНаработки
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	НастройкиОбъекта.ОбъектЭксплуатации КАК ОбъектЭксплуатации,
		|	НастройкиОбъекта.ПоказательНаработки КАК ПоказательНаработки,
		|	НастройкиОбъекта.СреднесуточноеЗначение
		|ПОМЕСТИТЬ НастройкиОбъекта
		|ИЗ
		|	РегистрСведений.НаработкиОбъектовЭксплуатации.СрезПоследних(
		|			&ДатаРегистрации,
		|			(ОбъектЭксплуатации, ПоказательНаработки) В
		|				(ВЫБРАТЬ
		|					ТаблицаДокумента.ОбъектЭксплуатации,
		|					ТаблицаДокумента.ПоказательНаработки
		|				ИЗ
		|					ТаблицаДокумента КАК ТаблицаДокумента)) КАК НастройкиОбъекта
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	ОбъектЭксплуатации,
		|	ПоказательНаработки
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТаблицаДокумента.ИндексСтроки КАК ИндексСтроки,
		|	ТаблицаДокумента.ОбъектЭксплуатации КАК ОбъектЭксплуатации,
		|	ТаблицаДокумента.ПоказательНаработки КАК ПоказательНаработки,
		|	ТаблицаДокумента.Значение КАК Значение,
		|	ЕСТЬNULL(НастройкиОбъекта.СреднесуточноеЗначение, 0) КАК СреднесуточноеЗначениеПоУмолчанию,
		|	ЕСТЬNULL(НастройкиКласса.ПересчитыватьСреднесуточноеЗначение, ЛОЖЬ) КАК ПересчитыватьСреднесуточноеЗначение,
		|	КОНЕЦПЕРИОДА(ДОБАВИТЬКДАТЕ(&ДатаРегистрации, ДЕНЬ, -ЕСТЬNULL(НастройкиКласса.МинимальныйПериодРасчета, 0)), ДЕНЬ) КАК МинимальныйПериод,
		|	НАЧАЛОПЕРИОДА(ДОБАВИТЬКДАТЕ(&ДатаРегистрации, ДЕНЬ, -ЕСТЬNULL(НастройкиКласса.МаксимальныйПериодРасчета, 0)), ДЕНЬ) КАК МаксимальныйПериод,
		|	ЕСТЬNULL(ДатыКорректировочныхЗаписей.Период, ДАТАВРЕМЯ(1, 1, 1)) КАК ДатаКорректировочнойЗаписи
		|ПОМЕСТИТЬ Параметры
		|ИЗ
		|	ТаблицаДокумента КАК ТаблицаДокумента
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КлассыОбъектовЭксплуатации.ПоказателиНаработки КАК НастройкиКласса
		|		ПО ТаблицаДокумента.ОбъектЭксплуатации.Класс = НастройкиКласса.Ссылка
		|			И ТаблицаДокумента.ПоказательНаработки = НастройкиКласса.ПоказательНаработки
		|		ЛЕВОЕ СОЕДИНЕНИЕ НастройкиОбъекта КАК НастройкиОбъекта
		|		ПО ТаблицаДокумента.ОбъектЭксплуатации = НастройкиОбъекта.ОбъектЭксплуатации
		|			И ТаблицаДокумента.ПоказательНаработки = НастройкиОбъекта.ПоказательНаработки
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НаработкиОбъектовЭксплуатации.СрезПоследних(
		|				&ДатаРегистрации,
		|				КорректировочнаяЗапись
		|					И (ОбъектЭксплуатации, ПоказательНаработки) В
		|						(ВЫБРАТЬ
		|							ТаблицаДокумента.ОбъектЭксплуатации,
		|							ТаблицаДокумента.ПоказательНаработки
		|						ИЗ
		|							ТаблицаДокумента КАК ТаблицаДокумента)) КАК ДатыКорректировочныхЗаписей
		|		ПО ТаблицаДокумента.ОбъектЭксплуатации = ДатыКорректировочныхЗаписей.ОбъектЭксплуатации
		|			И ТаблицаДокумента.ПоказательНаработки = ДатыКорректировочныхЗаписей.ПоказательНаработки
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	ОбъектЭксплуатации,
		|	ПоказательНаработки
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	МИНИМУМ(Наработки.Период) КАК Период,
		|	Наработки.ОбъектЭксплуатации КАК ОбъектЭксплуатации,
		|	Наработки.ПоказательНаработки КАК ПоказательНаработки
		|ПОМЕСТИТЬ ЗаписиОПериодах
		|ИЗ
		|	РегистрСведений.НаработкиОбъектовЭксплуатации КАК Наработки
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Параметры КАК Параметры
		|		ПО Наработки.ОбъектЭксплуатации = Параметры.ОбъектЭксплуатации
		|			И Наработки.ПоказательНаработки = Параметры.ПоказательНаработки
		|			И Наработки.Период <= Параметры.МинимальныйПериод
		|			И Наработки.Период >= Параметры.МаксимальныйПериод
		|			И Наработки.Период >= Параметры.ДатаКорректировочнойЗаписи
		|ГДЕ
		|	Параметры.ПересчитыватьСреднесуточноеЗначение
		|
		|СГРУППИРОВАТЬ ПО
		|	Наработки.ОбъектЭксплуатации,
		|	Наработки.ПоказательНаработки
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	ОбъектЭксплуатации,
		|	ПоказательНаработки
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Параметры.ИндексСтроки,
		|	ВЫБОР
		|		КОГДА НЕ Параметры.ПересчитыватьСреднесуточноеЗначение
		|			ТОГДА Параметры.СреднесуточноеЗначениеПоУмолчанию
		|		КОГДА НаработкиОбъектовЭксплуатации.Период ЕСТЬ NULL 
		|			ТОГДА Параметры.СреднесуточноеЗначениеПоУмолчанию
		|		КОГДА РАЗНОСТЬДАТ(НаработкиОбъектовЭксплуатации.Период, &ДатаРегистрации, ДЕНЬ) = 0
		|			ТОГДА Параметры.СреднесуточноеЗначениеПоУмолчанию
		|		ИНАЧЕ (Параметры.Значение - НаработкиОбъектовЭксплуатации.Значение) / РАЗНОСТЬДАТ(НаработкиОбъектовЭксплуатации.Период, &ДатаРегистрации, ДЕНЬ)
		|	КОНЕЦ КАК СреднесуточноеЗначение
		|ИЗ
		|	Параметры КАК Параметры
		|		ЛЕВОЕ СОЕДИНЕНИЕ ЗаписиОПериодах КАК ЗаписиОПериодах
		|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НаработкиОбъектовЭксплуатации КАК НаработкиОбъектовЭксплуатации
		|			ПО ЗаписиОПериодах.Период = НаработкиОбъектовЭксплуатации.Период
		|				И ЗаписиОПериодах.ОбъектЭксплуатации = НаработкиОбъектовЭксплуатации.ОбъектЭксплуатации
		|				И ЗаписиОПериодах.ПоказательНаработки = НаработкиОбъектовЭксплуатации.ПоказательНаработки
		|		ПО Параметры.ОбъектЭксплуатации = ЗаписиОПериодах.ОбъектЭксплуатации
		|			И Параметры.ПоказательНаработки = ЗаписиОПериодах.ПоказательНаработки");
	
	Запрос.УстановитьПараметр("ТаблицаДокумента", Наработки.Выгрузить( , "НомерСтроки, ОбъектЭксплуатации, ПоказательНаработки, Значение"));
	Запрос.УстановитьПараметр("ДатаРегистрации", Дата);
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Для Каждого Строка Из Наработки Цикл
			Строка.СреднесуточноеЗначение = 0;
		КонецЦикла;
	КонецЕсли;
	
	Выборка = Результат.Выбрать();
	Пока Выборка.Следующий() Цикл
		ЗаполнитьЗначенияСвойств(Наработки[Выборка.ИндексСтроки], Выборка);
	КонецЦикла;
	
КонецПроцедуры

//-- НЕ УТКА

#КонецОбласти

#КонецЕсли
