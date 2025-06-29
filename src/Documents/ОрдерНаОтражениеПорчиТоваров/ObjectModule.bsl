#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	Если СкладыСервер.ИспользоватьАдресноеХранение(Склад,Помещение,Дата) Тогда
		ПроверитьБлокировкуЯчеек(Отказ);
		Если Отказ Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	ПроведениеДокументов.ПередЗаписьюДокумента(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	
	НоменклатураСервер.ОчиститьНеиспользуемыеСерии(ЭтотОбъект,
		НоменклатураСервер.ПараметрыУказанияСерий(ЭтотОбъект, Документы.ОрдерНаОтражениеПорчиТоваров));
	
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		ПроверитьОрдерныйСклад(Отказ);
	КонецЕсли;
	
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

Процедура ПриКопировании(ОбъектКопирования)

	ИнициализироватьДокумент();

КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если Не СкладыСервер.ИспользоватьАдресноеХранение(Склад,Помещение,Дата) Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Товары.Ячейка");
		МассивНепроверяемыхРеквизитов.Добавить("Товары.Упаковка");
		МассивНепроверяемыхРеквизитов.Добавить("Товары.УпаковкаОприходование");
	ИначеЕсли Не ПолучитьФункциональнуюОпцию("ИспользоватьУпаковкиНоменклатуры") Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Товары.Упаковка");
		МассивНепроверяемыхРеквизитов.Добавить("Товары.УпаковкаОприходование");
		
		ТекстСообщения = НСтр("ru = 'В настройках программы не включено использование упаковок номенклатуры, 
			|поэтому нельзя оформить документ по складу с адресным хранением остатков. Обратитесь к администратору';
			|en = 'Packaging options are disabled in the application settings. To create a document that uses bin locations, you need to enable packaging options.
			|Please contact the administrator'");
		
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, , , , Отказ);
	Иначе
		ИменаПолейССуффиксом = Новый Структура;
		ИменаПолейССуффиксом.Вставить("Номенклатура",	"НоменклатураОприходование");
		ИменаПолейССуффиксом.Вставить("Упаковка",		"УпаковкаОприходование");
		
		ПараметрыПроверки = НоменклатураСервер.ПараметрыПроверкиЗаполненияУпаковок();
		ПараметрыПроверки.ИменаПолейССуффиксом = ИменаПолейССуффиксом;
		
		НоменклатураСервер.ПроверитьЗаполнениеУпаковок(ЭтотОбъект, МассивНепроверяемыхРеквизитов, Отказ, ПараметрыПроверки);
	КонецЕсли;
	
	Если Не СкладыСервер.ИспользоватьСкладскиеПомещения(Склад, Дата) Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Помещение");
	КонецЕсли;
	
	ПараметрыПроверки = НоменклатураСервер.ПараметрыПроверкиЗаполненияХарактеристик();
	ПараметрыПроверки.ИменаПолейССуффиксом.Вставить("Номенклатура", "НоменклатураОприходование");
	ПараметрыПроверки.ИменаПолейССуффиксом.Вставить("Характеристика", "ХарактеристикаОприходование");
	НоменклатураСервер.ПроверитьЗаполнениеХарактеристик(ЭтотОбъект,МассивНепроверяемыхРеквизитов,Отказ,ПараметрыПроверки);
	
	НоменклатураСервер.ПроверитьЗаполнениеСерий(ЭтотОбъект,
												НоменклатураСервер.ПараметрыУказанияСерий(ЭтотОбъект, Документы.ОрдерНаОтражениеПорчиТоваров),
												Отказ,
												МассивНепроверяемыхРеквизитов);
	
	//++ НЕ УТКА
	
	ТипыНазначений = ОбщегоНазначения.ЗначениеРеквизитаОбъектов(Товары.ВыгрузитьКолонку("Назначение"), "ТипНазначения");
	ТекстОшибкиПодНазначение = НСтр("ru = 'При порче товара, обособленного под назначение давальца, приход товара должен быть ""Под назначение""';
									|en = 'If an item assigned for the provider assignment has a stock quality change, the stock surplus must be ""For assignment""'");
	
	//-- НЕ УТКА
	
	ТекстОшибки = НСтр("ru = 'Товар исходного качества совпадает с товаром другого качества';
						|en = 'Goods of original quality matches with goods of different quality'");
	
	Для Каждого СтрТабл Из Товары Цикл
		АдресОшибки = НСтр("ru = 'в строке %НомерСтроки% списка ""Товары""';
							|en = 'in line %НомерСтроки% of the ""Goods"" list'");
		АдресОшибки =  СтрЗаменить(АдресОшибки, "%НомерСтроки%", СтрТабл.НомерСтроки);
		Если ЗначениеЗаполнено(СтрТабл.Номенклатура)
			И СтрТабл.Номенклатура = СтрТабл.НоменклатураОприходование Тогда
			Поле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Товары", СтрТабл.НомерСтроки, "НоменклатураОприходование");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки + Символы.НПП + АдресОшибки,ЭтотОбъект,Поле,,Отказ);
		КонецЕсли;
		
		//++ НЕ УТКА
		
		Если Не СтрТабл.ПодНазначение
		   И ТипыНазначений.Получить(СтрТабл.Назначение) = Перечисления.ТипыНазначений.Давальческое2_5 Тогда
			
			ОбщегоНазначения.СообщитьПользователю(
				СтрШаблон("%1 %2", ТекстОшибкиПодНазначение, АдресОшибки),
				ЭтотОбъект,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Товары", СтрТабл.НомерСтроки, "ПодНазначение"),,
				Отказ);
			
		КонецЕсли;
		
		//-- НЕ УТКА
		
	КонецЦикла;
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьМногооборотнуюТару") Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ТаблицаТоваров.Номенклатура,
		|	ТаблицаТоваров.НоменклатураОприходование,
		|	ТаблицаТоваров.НомерСтроки
		|ПОМЕСТИТЬ ТаблицаТоваров
		|ИЗ
		|	&ТаблицаТоваров КАК ТаблицаТоваров
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТаблицаТоваров.НомерСтроки КАК НомерСтроки,
		|	ВЫРАЗИТЬ(ТаблицаТоваров.Номенклатура КАК Справочник.Номенклатура).ТипНоменклатуры КАК НоменклатураТипНоменклатуры,
		|	ВЫРАЗИТЬ(ТаблицаТоваров.НоменклатураОприходование КАК Справочник.Номенклатура).ТипНоменклатуры КАК НоменклатураОприходованиеТипНоменклатуры
		|ИЗ
		|	ТаблицаТоваров КАК ТаблицаТоваров
		|ГДЕ
		|	ВЫРАЗИТЬ(ТаблицаТоваров.Номенклатура КАК Справочник.Номенклатура).ТипНоменклатуры <> ВЫРАЗИТЬ(ТаблицаТоваров.НоменклатураОприходование КАК Справочник.Номенклатура).ТипНоменклатуры
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтроки";	
		
		Запрос.УстановитьПараметр("ТаблицаТоваров", Товары.Выгрузить(,"НомерСтроки,Номенклатура,НоменклатураОприходование"));
		
		Выборка = Запрос.Выполнить().Выбрать();
		
		ТекстОшибки = НСтр("ru = 'В строке %НомерСтроки% списка ""Товары"" не совпадают типы номенклатуры. У номенклатуры исходхого качества тип %НоменклатураТипНоменклатуры%, другого качества - %НоменклатураОприходованиеТипНоменклатуры%.';
							|en = 'Item types do not match in line %НомерСтроки% of the Item list. Items of the original quality are of the %НоменклатураТипНоменклатуры% type; items of other quality are of the %НоменклатураОприходованиеТипНоменклатуры% type.'");
		
		Пока Выборка.Следующий() Цикл
			СообщениеОбОшибке = СтрЗаменить(ТекстОшибки, "%НомерСтроки%", Выборка.НомерСтроки); 
			СообщениеОбОшибке = СтрЗаменить(СообщениеОбОшибке, "%НоменклатураТипНоменклатуры%", Выборка.НоменклатураТипНоменклатуры); 
			СообщениеОбОшибке = СтрЗаменить(СообщениеОбОшибке, "%НоменклатураОприходованиеТипНоменклатуры%", Выборка.НоменклатураОприходованиеТипНоменклатуры); 
			
			Поле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Товары", СтрТабл.НомерСтроки, "НоменклатураОприходование");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СообщениеОбОшибке,ЭтотОбъект,Поле,,Отказ);
		КонецЦикла;
		
	КонецЕсли;
	
	НоменклатураСервер.ПроверитьВидНоменклатурыОприходования(ЭтотОбъект,Отказ);
	
	СверитьКоличествоВБазовыхЕдиницах(Отказ);
	
	ПараметрыПроверки = НоменклатураСервер.ПараметрыПроверкиЗаполненияКоличества();
	ПараметрыПроверки.ПроверитьВозможностьОкругления = Ложь;
	
	НоменклатураСервер.ПроверитьЗаполнениеКоличества(ЭтотОбъект, ПроверяемыеРеквизиты, Отказ, ПараметрыПроверки);
	
	СкладыСервер.ПроверитьОрдерностьСклада(Склад, Дата, "ПриОтраженииИзлишковНедостач", Отказ);
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.РасходныйОрдерНаТовары") Тогда
		ЗаполнитьНаОсновании(ДанныеЗаполнения);
	Иначе
		ИнициализироватьДокумент(ДанныеЗаполнения);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ИнициализацияИЗаполнение

Процедура ЗаполнитьНаОсновании(Основание)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ОтгружаемыеТовары.Номенклатура КАК НоменклатураБрак,
	|	ЕСТЬNULL(ТоварыДругогоКачества.Номенклатура, ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)) КАК Номенклатура
	|ПОМЕСТИТЬ БракованныеТовары
	|ИЗ
	|	Документ.РасходныйОрдерНаТовары.ОтгружаемыеТовары КАК ОтгружаемыеТовары
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ТоварыДругогоКачества КАК ТоварыДругогоКачества
	|		ПО ОтгружаемыеТовары.Номенклатура = ТоварыДругогоКачества.НоменклатураБрак
	|ГДЕ
	|	ОтгружаемыеТовары.Ссылка = &ДокументОснование
	|	И ОтгружаемыеТовары.Действие = ЗНАЧЕНИЕ(Перечисление.ДействияСоСтрокамиОрдеровНаОтгрузку.Неотгружать)
	|	И ОтгружаемыеТовары.Номенклатура.Качество <> ЗНАЧЕНИЕ(Перечисление.ГрадацииКачества.Новый)
	|;
	|
	|//////////////////////////////////////////////////////////////////////////////// 1
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	БракованныеТовары.НоменклатураБрак КАК НоменклатураБрак,
	|	БракованныеТовары.Номенклатура     КАК Номенклатура
	|ПОМЕСТИТЬ СопоставленныеТоварыОрдера
	|ИЗ
	|	БракованныеТовары КАК БракованныеТовары
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.РасходныйОрдерНаТовары.ОтгружаемыеТовары КАК ОтгружаемыеТовары
	|		ПО БракованныеТовары.Номенклатура = ОтгружаемыеТовары.Номенклатура
	|ГДЕ
	|	ОтгружаемыеТовары.Ссылка = &ДокументОснование
	|	И ОтгружаемыеТовары.Действие <> ЗНАЧЕНИЕ(Перечисление.ДействияСоСтрокамиОрдеровНаОтгрузку.Неотгружать)
	|	И ОтгружаемыеТовары.Номенклатура.Качество = ЗНАЧЕНИЕ(Перечисление.ГрадацииКачества.Новый)
	|;
	|
	|//////////////////////////////////////////////////////////////////////////////// 2
	|ВЫБРАТЬ
	|	КачественныеТовары.Номенклатура                 КАК Номенклатура,
	|	КОЛИЧЕСТВО(КачественныеТовары.НоменклатураБрак) КАК КоличествоСвязей
	|ПОМЕСТИТЬ ТаблицаСвязейКачественныхТоваров
	|ИЗ
	|	СопоставленныеТоварыОрдера КАК КачественныеТовары
	|
	|СГРУППИРОВАТЬ ПО
	|	КачественныеТовары.Номенклатура
	|;
	|
	|//////////////////////////////////////////////////////////////////////////////// 3
	|ВЫБРАТЬ
	|	БракованныеТовары.НоменклатураБрак         КАК НоменклатураБрак,
	|	КОЛИЧЕСТВО(БракованныеТовары.Номенклатура) КАК КоличествоСвязей
	|ПОМЕСТИТЬ ТаблицаСвязейБракованныхТоваровОрдера
	|ИЗ
	|	СопоставленныеТоварыОрдера КАК БракованныеТовары
	|
	|СГРУППИРОВАТЬ ПО
	|	БракованныеТовары.НоменклатураБрак
	|;
	|
	|//////////////////////////////////////////////////////////////////////////////// 4
	|ВЫБРАТЬ
	|	БракованныеТовары.НоменклатураБрак         КАК НоменклатураБрак,
	|	КОЛИЧЕСТВО(БракованныеТовары.Номенклатура) КАК КоличествоСвязей
	|ПОМЕСТИТЬ ТаблицаСвязейБракованныхТоваров
	|ИЗ
	|	БракованныеТовары КАК БракованныеТовары
	|ГДЕ
	|	НЕ БракованныеТовары.НоменклатураБрак В
	|		(ВЫБРАТЬ
	|			СопоставленныеТоварыОрдера.НоменклатураБрак
	|		ИЗ
	|			СопоставленныеТоварыОрдера КАК СопоставленныеТоварыОрдера)
	|	И НЕ БракованныеТовары.Номенклатура ЕСТЬ NULL
	|
	|СГРУППИРОВАТЬ ПО
	|	БракованныеТовары.НоменклатураБрак
	|;
	|
	|//////////////////////////////////////////////////////////////////////////////// 5
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ТоварыОрдера.НоменклатураБрак КАК НоменклатураБрак,
	|	ВЫБОР
	|		КОГДА ТаблицаСвязейБракованныхТоваровОрдера.КоличествоСвязей = 1
	|				И ТаблицаСвязейКачественныхТоваров.КоличествоСвязей = 1
	|			ТОГДА ТоварыОрдера.Номенклатура
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)
	|	КОНЕЦ                         КАК Номенклатура
	|ПОМЕСТИТЬ СопоставленныеБракованныеТовары
	|ИЗ
	|	СопоставленныеТоварыОрдера КАК ТоварыОрдера
	|		ЛЕВОЕ СОЕДИНЕНИЕ ТаблицаСвязейБракованныхТоваровОрдера КАК ТаблицаСвязейБракованныхТоваровОрдера
	|		ПО ТоварыОрдера.НоменклатураБрак = ТаблицаСвязейБракованныхТоваровОрдера.НоменклатураБрак
	|
	|		ЛЕВОЕ СОЕДИНЕНИЕ ТаблицаСвязейКачественныхТоваров КАК ТаблицаСвязейКачественныхТоваров
	|		ПО ТоварыОрдера.Номенклатура = ТаблицаСвязейКачественныхТоваров.Номенклатура
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	БракованныеТовары.НоменклатураБрак,
	|	ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)
	|ИЗ
	|	БракованныеТовары КАК БракованныеТовары
	|ГДЕ
	|	БракованныеТовары.Номенклатура ЕСТЬ NULL
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ТаблицаСвязейБракованныхТоваров.НоменклатураБрак,
	|	ВЫБОР
	|		КОГДА ТаблицаСвязейБракованныхТоваров.КоличествоСвязей = 1
	|			ТОГДА ЕСТЬNULL(БракованныеТовары.Номенклатура, ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка))
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)
	|	КОНЕЦ
	|ИЗ
	|	ТаблицаСвязейБракованныхТоваров КАК ТаблицаСвязейБракованныхТоваров
	|	ЛЕВОЕ СОЕДИНЕНИЕ БракованныеТовары КАК БракованныеТовары
	|		ПО ТаблицаСвязейБракованныхТоваров.НоменклатураБрак = БракованныеТовары.НоменклатураБрак
	|;
	|
	|//////////////////////////////////////////////////////////////////////////////// 6
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ЕСТЬNULL(БракованныеТовары.НоменклатураБрак, ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)) КАК НоменклатураБрак,
	|	ОтгружаемыеТовары.Характеристика КАК ХарактеристикаБрак,
	|	ЕСТЬNULL(БракованныеТовары.Номенклатура, ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)) КАК Номенклатура,
	|	ВЫБОР
	|		КОГДА (ОтгружаемыеТовары.Номенклатура.ИспользованиеХарактеристик = ЗНАЧЕНИЕ(Перечисление.ВариантыИспользованияХарактеристикНоменклатуры.ОбщиеДляВидаНоменклатуры)
	|					И ОтгружаемыеТовары.Номенклатура.ВидНоменклатуры = БракованныеТовары.НоменклатураБрак.ВидНоменклатуры)
	|				ИЛИ (ОтгружаемыеТовары.Номенклатура.ИспользованиеХарактеристик = ЗНАЧЕНИЕ(Перечисление.ВариантыИспользованияХарактеристикНоменклатуры.ОбщиеСДругимВидомНоменклатуры)
	|					И ОтгружаемыеТовары.Номенклатура.ВладелецХарактеристик = БракованныеТовары.НоменклатураБрак.ВладелецХарактеристик)
	|			ТОГДА ОтгружаемыеТовары.Характеристика
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка)
	|	КОНЕЦ                            КАК Характеристика
	|ПОМЕСТИТЬ СопоставленныеБракованныеТоварыПоХарактеристикам
	|ИЗ
	|	Документ.РасходныйОрдерНаТовары.ОтгружаемыеТовары КАК ОтгружаемыеТовары
	|		ЛЕВОЕ СОЕДИНЕНИЕ СопоставленныеБракованныеТовары КАК БракованныеТовары
	|		ПО ОтгружаемыеТовары.Номенклатура = БракованныеТовары.НоменклатураБрак
	|ГДЕ
	|	ОтгружаемыеТовары.Ссылка = &ДокументОснование
	|	И ОтгружаемыеТовары.Действие = ЗНАЧЕНИЕ(Перечисление.ДействияСоСтрокамиОрдеровНаОтгрузку.Неотгружать)
	|	И ОтгружаемыеТовары.Номенклатура.Качество <> ЗНАЧЕНИЕ(Перечисление.ГрадацииКачества.Новый)
	|	И ОтгружаемыеТовары.Номенклатура.ИспользованиеХарактеристик <> ЗНАЧЕНИЕ(Перечисление.ВариантыИспользованияХарактеристикНоменклатуры.ИндивидуальныеДляНоменклатуры)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ЕСТЬNULL(БракованныеТовары.НоменклатураБрак, ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)),
	|	ОтгружаемыеТовары.Характеристика,
	|	ЕСТЬNULL(БракованныеТовары.Номенклатура, ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)),
	|	ЕСТЬNULL(ХарактеристикиНоменклатуры.Ссылка, ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка))
	|ИЗ
	|	Документ.РасходныйОрдерНаТовары.ОтгружаемыеТовары КАК ОтгружаемыеТовары
	|		ЛЕВОЕ СОЕДИНЕНИЕ СопоставленныеБракованныеТовары КАК БракованныеТовары
	|		ПО ОтгружаемыеТовары.Номенклатура = БракованныеТовары.НоменклатураБрак
	|
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ХарактеристикиНоменклатуры КАК ХарактеристикиНоменклатуры
	|		ПО БракованныеТовары.Номенклатура = ХарактеристикиНоменклатуры.Владелец
	|			И ВЫРАЗИТЬ(ОтгружаемыеТовары.Характеристика.Наименование КАК СТРОКА(500)) = ВЫРАЗИТЬ(ХарактеристикиНоменклатуры.Наименование КАК СТРОКА(500))
	|ГДЕ
	|	ОтгружаемыеТовары.Ссылка = &ДокументОснование
	|	И ОтгружаемыеТовары.Действие = ЗНАЧЕНИЕ(Перечисление.ДействияСоСтрокамиОрдеровНаОтгрузку.Неотгружать)
	|	И ОтгружаемыеТовары.Номенклатура.Качество <> ЗНАЧЕНИЕ(Перечисление.ГрадацииКачества.Новый)
	|	И ОтгружаемыеТовары.Номенклатура.ИспользованиеХарактеристик = ЗНАЧЕНИЕ(Перечисление.ВариантыИспользованияХарактеристикНоменклатуры.ИндивидуальныеДляНоменклатуры)
	|	И НЕ ЕСТЬNULL(ХарактеристикиНоменклатуры.ПометкаУдаления, ЛОЖЬ)
	|;
	|
	|//////////////////////////////////////////////////////////////////////////////// 7
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ЕСТЬNULL(БракованныеТовары.НоменклатураБрак, ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)) КАК НоменклатураБрак,
	|	ОтгружаемыеТовары.Упаковка КАК УпаковкаБрак,
	|	ЕСТЬNULL(БракованныеТовары.Номенклатура, ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)) КАК Номенклатура,
	|	ВЫБОР
	|		КОГДА ОтгружаемыеТовары.Номенклатура.ИспользоватьУпаковки
	|				И ОтгружаемыеТовары.Упаковка.Владелец = БракованныеТовары.НоменклатураБрак.НаборУпаковок
	|			ТОГДА ОтгружаемыеТовары.Упаковка
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.УпаковкиЕдиницыИзмерения.ПустаяСсылка)
	|	КОНЕЦ                      КАК Упаковка
	|ПОМЕСТИТЬ СопоставленныеБракованныеТоварыПоУпаковкам
	|ИЗ
	|	Документ.РасходныйОрдерНаТовары.ОтгружаемыеТовары КАК ОтгружаемыеТовары
	|		ЛЕВОЕ СОЕДИНЕНИЕ СопоставленныеБракованныеТовары КАК БракованныеТовары
	|		ПО ОтгружаемыеТовары.Номенклатура = БракованныеТовары.НоменклатураБрак
	|ГДЕ
	|	ОтгружаемыеТовары.Ссылка = &ДокументОснование
	|	И ОтгружаемыеТовары.Действие = ЗНАЧЕНИЕ(Перечисление.ДействияСоСтрокамиОрдеровНаОтгрузку.Неотгружать)
	|	И ОтгружаемыеТовары.Номенклатура.Качество <> ЗНАЧЕНИЕ(Перечисление.ГрадацииКачества.Новый)
	|	И ОтгружаемыеТовары.Номенклатура.НаборУпаковок <> ЗНАЧЕНИЕ(Справочник.НаборыУпаковок.ИндивидуальныйДляНоменклатуры)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ЕСТЬNULL(БракованныеТовары.НоменклатураБрак, ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)),
	|	ОтгружаемыеТовары.Упаковка,
	|	ЕСТЬNULL(БракованныеТовары.Номенклатура, ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)),
	|	ЕСТЬNULL(УпаковкиНоменклатуры.Ссылка, ЗНАЧЕНИЕ(Справочник.УпаковкиЕдиницыИзмерения.ПустаяСсылка))
	|ИЗ
	|	Документ.РасходныйОрдерНаТовары.ОтгружаемыеТовары КАК ОтгружаемыеТовары
	|		ЛЕВОЕ СОЕДИНЕНИЕ СопоставленныеБракованныеТовары КАК БракованныеТовары
	|		ПО ОтгружаемыеТовары.Номенклатура = БракованныеТовары.НоменклатураБрак
	|
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.УпаковкиЕдиницыИзмерения КАК УпаковкиНоменклатуры
	|		ПО БракованныеТовары.Номенклатура = УпаковкиНоменклатуры.Владелец
	|			И ВЫРАЗИТЬ(ОтгружаемыеТовары.Упаковка.Наименование КАК СТРОКА(500)) = ВЫРАЗИТЬ(УпаковкиНоменклатуры.Наименование КАК СТРОКА(500))
	|ГДЕ
	|	ОтгружаемыеТовары.Ссылка = &ДокументОснование
	|	И ОтгружаемыеТовары.Действие = ЗНАЧЕНИЕ(Перечисление.ДействияСоСтрокамиОрдеровНаОтгрузку.Неотгружать)
	|	И ОтгружаемыеТовары.Номенклатура.Качество <> ЗНАЧЕНИЕ(Перечисление.ГрадацииКачества.Новый)
	|	И ОтгружаемыеТовары.Номенклатура.НаборУпаковок = ЗНАЧЕНИЕ(Справочник.НаборыУпаковок.ИндивидуальныйДляНоменклатуры)
	|	И НЕ ЕСТЬNULL(УпаковкиНоменклатуры.ПометкаУдаления, ЛОЖЬ)
	|;
	|
	|//////////////////////////////////////////////////////////////////////////////// 8
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ЕСТЬNULL(ТоварыДругогоКачества.НоменклатураБрак, ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)) КАК НоменклатураБрак,
	|	ОтгружаемыеТовары.Номенклатура КАК Номенклатура
	|ПОМЕСТИТЬ НеотгружаемыеКачественныеТовары
	|ИЗ
	|	Документ.РасходныйОрдерНаТовары.ОтгружаемыеТовары КАК ОтгружаемыеТовары
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ТоварыДругогоКачества КАК ТоварыДругогоКачества
	|		ПО ОтгружаемыеТовары.Номенклатура = ТоварыДругогоКачества.Номенклатура
	|ГДЕ
	|	ОтгружаемыеТовары.Ссылка = &ДокументОснование
	|	И ОтгружаемыеТовары.Действие = ЗНАЧЕНИЕ(Перечисление.ДействияСоСтрокамиОрдеровНаОтгрузку.Неотгружать)
	|	И ОтгружаемыеТовары.Номенклатура.Качество = ЗНАЧЕНИЕ(Перечисление.ГрадацииКачества.Новый)
	|;
	|
	|//////////////////////////////////////////////////////////////////////////////// 9
	|ВЫБРАТЬ
	|	КачественныеТовары.Номенклатура                 КАК Номенклатура,
	|	КОЛИЧЕСТВО(КачественныеТовары.НоменклатураБрак) КАК КоличествоСвязей
	|ПОМЕСТИТЬ ТаблицаСвязейНеотгружаемыхКачественныхТоваров
	|ИЗ
	|	НеотгружаемыеКачественныеТовары КАК КачественныеТовары
	|
	|СГРУППИРОВАТЬ ПО
	|	КачественныеТовары.Номенклатура
	|;
	|
	|//////////////////////////////////////////////////////////////////////////////// 10
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВЫБОР
	|		КОГДА ТаблицаСвязей.КоличествоСвязей = 1
	|			ТОГДА ВЫРАЗИТЬ(ТоварыОрдера.НоменклатураБрак КАК Справочник.Номенклатура)
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)
	|	КОНЕЦ                     КАК НоменклатураБрак,
	|	ТоварыОрдера.Номенклатура КАК Номенклатура
	|ПОМЕСТИТЬ СопоставленныеКачественныеТовары
	|ИЗ
	|	НеотгружаемыеКачественныеТовары КАК ТоварыОрдера
	|		ЛЕВОЕ СОЕДИНЕНИЕ ТаблицаСвязейНеотгружаемыхКачественныхТоваров КАК ТаблицаСвязей
	|		ПО ТоварыОрдера.Номенклатура = ТаблицаСвязей.Номенклатура
	|;
	|
	|//////////////////////////////////////////////////////////////////////////////// 11
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ЕСТЬNULL(КачественныеТовары.НоменклатураБрак, ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)) КАК НоменклатураБрак,
	|	ВЫБОР
	|		КОГДА (ОтгружаемыеТовары.Номенклатура.ИспользованиеХарактеристик = ЗНАЧЕНИЕ(Перечисление.ВариантыИспользованияХарактеристикНоменклатуры.ОбщиеДляВидаНоменклатуры)
	|					И ОтгружаемыеТовары.Номенклатура.ВидНоменклатуры = КачественныеТовары.НоменклатураБрак.ВидНоменклатуры)
	|				ИЛИ (ОтгружаемыеТовары.Номенклатура.ИспользованиеХарактеристик = ЗНАЧЕНИЕ(Перечисление.ВариантыИспользованияХарактеристикНоменклатуры.ОбщиеСДругимВидомНоменклатуры)
	|					И ОтгружаемыеТовары.Номенклатура.ВладелецХарактеристик = КачественныеТовары.НоменклатураБрак.ВладелецХарактеристик)
	|			ТОГДА ОтгружаемыеТовары.Характеристика
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка)
	|	КОНЕЦ                               КАК ХарактеристикаБрак,
	|	ОтгружаемыеТовары.Номенклатура      КАК Номенклатура,
	|	ОтгружаемыеТовары.Характеристика    КАК Характеристика
	|ПОМЕСТИТЬ СопоставленныеКачественныеТоварыПоХарактеристикам
	|ИЗ
	|	Документ.РасходныйОрдерНаТовары.ОтгружаемыеТовары КАК ОтгружаемыеТовары
	|		ЛЕВОЕ СОЕДИНЕНИЕ СопоставленныеКачественныеТовары КАК КачественныеТовары
	|		ПО ОтгружаемыеТовары.Номенклатура = КачественныеТовары.Номенклатура
	|ГДЕ
	|	ОтгружаемыеТовары.Ссылка = &ДокументОснование
	|	И ОтгружаемыеТовары.Действие = ЗНАЧЕНИЕ(Перечисление.ДействияСоСтрокамиОрдеровНаОтгрузку.Неотгружать)
	|	И ОтгружаемыеТовары.Номенклатура.Качество = ЗНАЧЕНИЕ(Перечисление.ГрадацииКачества.Новый)
	|	И ОтгружаемыеТовары.Номенклатура.ИспользованиеХарактеристик <> ЗНАЧЕНИЕ(Перечисление.ВариантыИспользованияХарактеристикНоменклатуры.ИндивидуальныеДляНоменклатуры)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ЕСТЬNULL(КачественныеТовары.НоменклатураБрак, ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)),
	|	ЕСТЬNULL(ХарактеристикиНоменклатуры.Ссылка, ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка)),
	|	ОтгружаемыеТовары.Номенклатура,
	|	ОтгружаемыеТовары.Характеристика
	|ИЗ
	|	Документ.РасходныйОрдерНаТовары.ОтгружаемыеТовары КАК ОтгружаемыеТовары
	|		ЛЕВОЕ СОЕДИНЕНИЕ СопоставленныеКачественныеТовары КАК КачественныеТовары
	|		ПО ОтгружаемыеТовары.Номенклатура = КачественныеТовары.Номенклатура
	|
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ХарактеристикиНоменклатуры КАК ХарактеристикиНоменклатуры
	|		ПО КачественныеТовары.НоменклатураБрак = ХарактеристикиНоменклатуры.Владелец
	|			И ВЫРАЗИТЬ(ОтгружаемыеТовары.Характеристика.Наименование КАК СТРОКА(500)) = ВЫРАЗИТЬ(ХарактеристикиНоменклатуры.Наименование КАК СТРОКА(500))
	|ГДЕ
	|	ОтгружаемыеТовары.Ссылка = &ДокументОснование
	|	И ОтгружаемыеТовары.Действие = ЗНАЧЕНИЕ(Перечисление.ДействияСоСтрокамиОрдеровНаОтгрузку.Неотгружать)
	|	И ОтгружаемыеТовары.Номенклатура.Качество = ЗНАЧЕНИЕ(Перечисление.ГрадацииКачества.Новый)
	|	И ОтгружаемыеТовары.Номенклатура.ИспользованиеХарактеристик = ЗНАЧЕНИЕ(Перечисление.ВариантыИспользованияХарактеристикНоменклатуры.ИндивидуальныеДляНоменклатуры)
	|	И НЕ ЕСТЬNULL(ХарактеристикиНоменклатуры.ПометкаУдаления, ЛОЖЬ)
	|;
	|
	|//////////////////////////////////////////////////////////////////////////////// 12
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ЕСТЬNULL(КачественныеТовары.НоменклатураБрак, ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)) КАК НоменклатураБрак,
	|	ВЫБОР
	|		КОГДА ОтгружаемыеТовары.Номенклатура.ИспользоватьУпаковки
	|				И ОтгружаемыеТовары.Упаковка.Владелец = КачественныеТовары.НоменклатураБрак.НаборУпаковок
	|			ТОГДА ОтгружаемыеТовары.Упаковка
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.УпаковкиЕдиницыИзмерения.ПустаяСсылка)
	|	КОНЕЦ                               КАК УпаковкаБрак,
	|	ОтгружаемыеТовары.Номенклатура      КАК Номенклатура,
	|	ОтгружаемыеТовары.Упаковка          КАК Упаковка
	|ПОМЕСТИТЬ СопоставленныеКачественныеТоварыПоУпаковкам
	|ИЗ
	|	Документ.РасходныйОрдерНаТовары.ОтгружаемыеТовары КАК ОтгружаемыеТовары
	|		ЛЕВОЕ СОЕДИНЕНИЕ СопоставленныеКачественныеТовары КАК КачественныеТовары
	|		ПО ОтгружаемыеТовары.Номенклатура = КачественныеТовары.Номенклатура
	|ГДЕ
	|	ОтгружаемыеТовары.Ссылка = &ДокументОснование
	|	И ОтгружаемыеТовары.Действие = ЗНАЧЕНИЕ(Перечисление.ДействияСоСтрокамиОрдеровНаОтгрузку.Неотгружать)
	|	И ОтгружаемыеТовары.Номенклатура.Качество = ЗНАЧЕНИЕ(Перечисление.ГрадацииКачества.Новый)
	|	И ОтгружаемыеТовары.Номенклатура.НаборУпаковок <> ЗНАЧЕНИЕ(Справочник.НаборыУпаковок.ИндивидуальныйДляНоменклатуры)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ЕСТЬNULL(КачественныеТовары.НоменклатураБрак, ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)),
	|	ЕСТЬNULL(УпаковкиНоменклатуры.Ссылка, ЗНАЧЕНИЕ(Справочник.УпаковкиЕдиницыИзмерения.ПустаяСсылка)),
	|	ОтгружаемыеТовары.Номенклатура,
	|	ОтгружаемыеТовары.Упаковка
	|ИЗ
	|	Документ.РасходныйОрдерНаТовары.ОтгружаемыеТовары КАК ОтгружаемыеТовары
	|		ЛЕВОЕ СОЕДИНЕНИЕ СопоставленныеКачественныеТовары КАК КачественныеТовары
	|		ПО ОтгружаемыеТовары.Номенклатура = КачественныеТовары.Номенклатура
	|
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.УпаковкиЕдиницыИзмерения КАК УпаковкиНоменклатуры
	|		ПО КачественныеТовары.НоменклатураБрак = УпаковкиНоменклатуры.Владелец
	|			И ВЫРАЗИТЬ(ОтгружаемыеТовары.Упаковка.Наименование КАК СТРОКА(500)) = ВЫРАЗИТЬ(УпаковкиНоменклатуры.Наименование КАК СТРОКА(500))
	|ГДЕ
	|	ОтгружаемыеТовары.Ссылка = &ДокументОснование
	|	И ОтгружаемыеТовары.Действие = ЗНАЧЕНИЕ(Перечисление.ДействияСоСтрокамиОрдеровНаОтгрузку.Неотгружать)
	|	И ОтгружаемыеТовары.Номенклатура.Качество = ЗНАЧЕНИЕ(Перечисление.ГрадацииКачества.Новый)
	|	И ОтгружаемыеТовары.Номенклатура.НаборУпаковок = ЗНАЧЕНИЕ(Справочник.НаборыУпаковок.ИндивидуальныйДляНоменклатуры)
	|	И НЕ ЕСТЬNULL(УпаковкиНоменклатуры.ПометкаУдаления, ЛОЖЬ)
	|;
	|
	|//////////////////////////////////////////////////////////////////////////////// 13
	|ВЫБРАТЬ
	|	ОтгружаемыеТовары.Ссылка.ЗонаОтгрузки       КАК Ячейка,
	|	ЕСТЬNULL(ХарактеристикиТоваров.НоменклатураБрак, ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)) КАК НоменклатураОприходование,
	|	ЕСТЬNULL(ХарактеристикиТоваров.ХарактеристикаБрак, ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка)) КАК ХарактеристикаОприходование,
	|	ВЫБОР
	|		КОГДА ОтгружаемыеТовары.Назначение = ЗНАЧЕНИЕ(Справочник.Назначения.ПустаяСсылка)
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ                                       КАК ПодНазначение,
	|	ЕСТЬNULL(УпаковкиТоваров.УпаковкаБрак, ЗНАЧЕНИЕ(Справочник.УпаковкиЕдиницыИзмерения.ПустаяСсылка)) КАК УпаковкаОприходование,
	|	ОтгружаемыеТовары.Серия                     КАК Серия,
	|	ЕСТЬNULL(ХарактеристикиТоваров.Номенклатура, ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)) КАК Номенклатура,
	|	ЕСТЬNULL(ХарактеристикиТоваров.Характеристика, ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка)) КАК Характеристика,
	|	ОтгружаемыеТовары.Назначение                КАК Назначение,
	|	ЕСТЬNULL(УпаковкиТоваров.Упаковка, ЗНАЧЕНИЕ(Справочник.УпаковкиЕдиницыИзмерения.ПустаяСсылка)) КАК Упаковка,
	|	ОтгружаемыеТовары.СтатусУказанияСерий       КАК СтатусУказанияСерий,
	|	СУММА(ОтгружаемыеТовары.Количество)         КАК Количество,
	|	СУММА(ОтгружаемыеТовары.КоличествоУпаковок) КАК КоличествоУпаковок
	|ПОМЕСТИТЬ ТоварыОрдера
	|ИЗ
	|	Документ.РасходныйОрдерНаТовары.ОтгружаемыеТовары КАК ОтгружаемыеТовары
	|		ЛЕВОЕ СОЕДИНЕНИЕ СопоставленныеБракованныеТоварыПоХарактеристикам КАК ХарактеристикиТоваров
	|		ПО ОтгружаемыеТовары.Номенклатура = ХарактеристикиТоваров.НоменклатураБрак
	|			И ОтгружаемыеТовары.Характеристика = ХарактеристикиТоваров.ХарактеристикаБрак
	|
	|		ЛЕВОЕ СОЕДИНЕНИЕ СопоставленныеБракованныеТоварыПоУпаковкам КАК УпаковкиТоваров
	|		ПО ОтгружаемыеТовары.Номенклатура = УпаковкиТоваров.НоменклатураБрак
	|			И ОтгружаемыеТовары.Упаковка = УпаковкиТоваров.УпаковкаБрак
	|ГДЕ
	|	ОтгружаемыеТовары.Ссылка = &ДокументОснование
	|	И ОтгружаемыеТовары.Действие = ЗНАЧЕНИЕ(Перечисление.ДействияСоСтрокамиОрдеровНаОтгрузку.Неотгружать)
	|	И ОтгружаемыеТовары.Номенклатура.Качество <> ЗНАЧЕНИЕ(Перечисление.ГрадацииКачества.Новый)
	|	И (ОтгружаемыеТовары.Упаковка = ЗНАЧЕНИЕ(Справочник.УпаковкиЕдиницыИзмерения.ПустаяСсылка)
	|		ИЛИ ОтгружаемыеТовары.Упаковка.ТипУпаковки <> ЗНАЧЕНИЕ(Перечисление.ТипыУпаковокНоменклатуры.ТоварноеМесто))
	|
	|СГРУППИРОВАТЬ ПО
	|	ОтгружаемыеТовары.Ссылка.ЗонаОтгрузки,
	|	ЕСТЬNULL(ХарактеристикиТоваров.НоменклатураБрак, ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)),
	|	ЕСТЬNULL(ХарактеристикиТоваров.ХарактеристикаБрак, ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка)),
	|	ВЫБОР
	|		КОГДА ОтгружаемыеТовары.Назначение = ЗНАЧЕНИЕ(Справочник.Назначения.ПустаяСсылка)
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ,
	|	ОтгружаемыеТовары.Серия,
	|	ЕСТЬNULL(УпаковкиТоваров.УпаковкаБрак, ЗНАЧЕНИЕ(Справочник.УпаковкиЕдиницыИзмерения.ПустаяСсылка)),
	|	ЕСТЬNULL(ХарактеристикиТоваров.Номенклатура, ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)),
	|	ЕСТЬNULL(ХарактеристикиТоваров.Характеристика, ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка)),
	|	ОтгружаемыеТовары.Назначение,
	|	ЕСТЬNULL(УпаковкиТоваров.Упаковка, ЗНАЧЕНИЕ(Справочник.УпаковкиЕдиницыИзмерения.ПустаяСсылка)),
	|	ОтгружаемыеТовары.СтатусУказанияСерий
	|
	|ИМЕЮЩИЕ
	|	СУММА(ОтгружаемыеТовары.Количество) > 0
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ОтгружаемыеТовары.Ссылка.ЗонаОтгрузки,
	|	ЕСТЬNULL(ХарактеристикиТоваров.НоменклатураБрак, ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)),
	|	ЕСТЬNULL(ХарактеристикиТоваров.ХарактеристикаБрак, ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка)),
	|	ВЫБОР
	|		КОГДА ОтгружаемыеТовары.Назначение = ЗНАЧЕНИЕ(Справочник.Назначения.ПустаяСсылка)
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ,
	|	ЕСТЬNULL(УпаковкиТоваров.УпаковкаБрак, ЗНАЧЕНИЕ(Справочник.УпаковкиЕдиницыИзмерения.ПустаяСсылка)),
	|	ОтгружаемыеТовары.Серия,
	|	ЕСТЬNULL(ХарактеристикиТоваров.Номенклатура, ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)),
	|	ЕСТЬNULL(ХарактеристикиТоваров.Характеристика, ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка)),
	|	ОтгружаемыеТовары.Назначение,
	|	ЕСТЬNULL(УпаковкиТоваров.Упаковка, ЗНАЧЕНИЕ(Справочник.УпаковкиЕдиницыИзмерения.ПустаяСсылка)),
	|	ОтгружаемыеТовары.СтатусУказанияСерий,
	|	СУММА(ОтгружаемыеТовары.Количество),
	|	СУММА(ОтгружаемыеТовары.КоличествоУпаковок)
	|ИЗ
	|	Документ.РасходныйОрдерНаТовары.ОтгружаемыеТовары КАК ОтгружаемыеТовары
	|		ЛЕВОЕ СОЕДИНЕНИЕ СопоставленныеКачественныеТоварыПоХарактеристикам КАК ХарактеристикиТоваров
	|		ПО ОтгружаемыеТовары.Номенклатура = ХарактеристикиТоваров.Номенклатура
	|			И ОтгружаемыеТовары.Характеристика = ХарактеристикиТоваров.Характеристика
	|
	|		ЛЕВОЕ СОЕДИНЕНИЕ СопоставленныеКачественныеТоварыПоУпаковкам КАК УпаковкиТоваров
	|		ПО ОтгружаемыеТовары.Номенклатура = УпаковкиТоваров.Номенклатура
	|			И ОтгружаемыеТовары.Упаковка = УпаковкиТоваров.Упаковка
	|ГДЕ
	|	ОтгружаемыеТовары.Ссылка = &ДокументОснование
	|	И ОтгружаемыеТовары.Действие = ЗНАЧЕНИЕ(Перечисление.ДействияСоСтрокамиОрдеровНаОтгрузку.Неотгружать)
	|	И ОтгружаемыеТовары.Номенклатура.Качество = ЗНАЧЕНИЕ(Перечисление.ГрадацииКачества.Новый)
	|	И (ОтгружаемыеТовары.Упаковка = ЗНАЧЕНИЕ(Справочник.УпаковкиЕдиницыИзмерения.ПустаяСсылка)
	|		ИЛИ ОтгружаемыеТовары.Упаковка.ТипУпаковки <> ЗНАЧЕНИЕ(Перечисление.ТипыУпаковокНоменклатуры.ТоварноеМесто))
	|
	|СГРУППИРОВАТЬ ПО
	|	ОтгружаемыеТовары.Ссылка.ЗонаОтгрузки,
	|	ЕСТЬNULL(ХарактеристикиТоваров.НоменклатураБрак, ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)),
	|	ЕСТЬNULL(ХарактеристикиТоваров.ХарактеристикаБрак, ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка)),
	|	ВЫБОР
	|		КОГДА ОтгружаемыеТовары.Назначение = ЗНАЧЕНИЕ(Справочник.Назначения.ПустаяСсылка)
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ,
	|	ОтгружаемыеТовары.Серия,
	|	ЕСТЬNULL(УпаковкиТоваров.УпаковкаБрак, ЗНАЧЕНИЕ(Справочник.УпаковкиЕдиницыИзмерения.ПустаяСсылка)),
	|	ЕСТЬNULL(ХарактеристикиТоваров.Номенклатура, ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)),
	|	ЕСТЬNULL(ХарактеристикиТоваров.Характеристика, ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка)),
	|	ОтгружаемыеТовары.Назначение,
	|	ЕСТЬNULL(УпаковкиТоваров.Упаковка, ЗНАЧЕНИЕ(Справочник.УпаковкиЕдиницыИзмерения.ПустаяСсылка)),
	|	ОтгружаемыеТовары.СтатусУказанияСерий
	|
	|ИМЕЮЩИЕ
	|	СУММА(ОтгружаемыеТовары.Количество) > 0
	|;
	|
	|//////////////////////////////////////////////////////////////////////////////// 14
	|ВЫБРАТЬ
	|	ТоварыОрдера.Ячейка                      КАК Ячейка,
	|	ТоварыОрдера.НоменклатураОприходование   КАК НоменклатураОприходование,
	|	ТоварыОрдера.ХарактеристикаОприходование КАК ХарактеристикаОприходование,
	|	ТоварыОрдера.ПодНазначение               КАК ПодНазначение,
	|	ТоварыОрдера.УпаковкаОприходование       КАК УпаковкаОприходование,
	|	ТоварыОрдера.Серия                       КАК Серия,
	|	ТоварыОрдера.Номенклатура                КАК Номенклатура,
	|	ТоварыОрдера.Характеристика              КАК Характеристика,
	|	ТоварыОрдера.Назначение                  КАК Назначение,
	|	ТоварыОрдера.Упаковка                    КАК Упаковка,
	|	ТоварыОрдера.СтатусУказанияСерий         КАК СтатусУказанияСерий,
	|	ТоварыОрдера.Количество                  КАК Количество,
	|	ТоварыОрдера.КоличествоУпаковок          КАК КоличествоУпаковок,
	|	ТоварыОрдера.Количество                  КАК КоличествоОприходование
	|ИЗ
	|	ТоварыОрдера КАК ТоварыОрдера
	|
	|УПОРЯДОЧИТЬ ПО
	|	ТоварыОрдера.Номенклатура.Наименование,
	|	ТоварыОрдера.Характеристика.Наименование,
	|	ТоварыОрдера.Назначение.Наименование,
	|	ТоварыОрдера.Серия.Наименование
	|;
	|
	|//////////////////////////////////////////////////////////////////////////////// 15
	|ВЫБРАТЬ
	|	ШапкаДокумента.Склад         КАК Склад,
	|	ШапкаДокумента.Помещение     КАК Помещение,
	|	ШапкаДокумента.Ответственный КАК Ответственный
	|ИЗ
	|	Документ.РасходныйОрдерНаТовары КАК ШапкаДокумента
	|ГДЕ
	|	ШапкаДокумента.Ссылка = &ДокументОснование
	|";
	
	Запрос.УстановитьПараметр("ДокументОснование", Основание);
	
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	
	РеквизитыДокумента = РезультатЗапроса[15].Выбрать();
	РеквизитыДокумента.Следующий();
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, РеквизитыДокумента);
	
	Товары.Загрузить(РезультатЗапроса[14].Выгрузить());
	
КонецПроцедуры

Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено)

	Ответственный = Пользователи.ТекущийПользователь();
	Склад         = ЗначениеНастроекПовтИсп.ПолучитьСкладПоУмолчанию(Склад);

КонецПроцедуры

#КонецОбласти

#Область Прочее

Процедура СверитьКоличествоВБазовыхЕдиницах(Отказ)
	
	ТаблицаПроверки = Товары.Выгрузить();
	ШаблонТекстаСообщения = НСтр("ru = 'Количество номенклатуры исходного качества ""%НоменклатураСписания%"" в строке ""%НомерСтроки%"" списка ""Товары"" отличается от количества испорченной номенклатуры ""%НоменклатураОприходования%"" на ""%Количество%"" единиц хранения';
								|en = 'Quantity of the  ""%НоменклатураСписания%"" items of original quality in line ""%НомерСтроки%"" of the ""Goods"" list is different from the quantity of damaged ""%НоменклатураОприходования%"" items by ""%Количество%"" stock UOM'");
	
	Для Каждого СтрокаТовара Из ТаблицаПроверки Цикл
		
		Если СтрокаТовара.Количество <> СтрокаТовара.КоличествоОприходование Тогда
			КоличествоРасхождение = СтрокаТовара.Количество - СтрокаТовара.КоличествоОприходование;
			КоличествоРасхождение = Макс(КоличествоРасхождение, -КоличествоРасхождение);
			
			ПредставлениеНоменклатурыСписания     = НоменклатураКлиентСервер.ПредставлениеНоменклатуры(СтрокаТовара.Номенклатура,
													СтрокаТовара.Характеристика, СтрокаТовара.Упаковка, СтрокаТовара.Серия, СтрокаТовара.Назначение);
			ПредставлениеНоменклатурыПриходования = НоменклатураКлиентСервер.ПредставлениеНоменклатуры(
													СтрокаТовара.НоменклатураОприходование, СтрокаТовара.ХарактеристикаОприходование,
													СтрокаТовара.УпаковкаОприходование);
			
			ТекстСообщения = СтрЗаменить(ШаблонТекстаСообщения, "%НомерСтроки%", СтрокаТовара.НомерСтроки);
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%НоменклатураСписания%", ПредставлениеНоменклатурыСписания);
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%НоменклатураОприходования%", ПредставлениеНоменклатурыПриходования);
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Количество%", КоличествоРасхождение);
			
			Поле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Товары", СтрокаТовара.НомерСтроки, "КоличествоУпаковок");
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ПроверитьБлокировкуЯчеек(Отказ)
	
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.БлокировкиСкладскихЯчеек");
	ЭлементБлокировки.Режим          = РежимБлокировкиДанных.Разделяемый;
	ЭлементБлокировки.ИсточникДанных = Товары;
	ЭлементБлокировки.ИспользоватьИзИсточникаДанных("Ячейка", "Ячейка");
	
	Блокировка.Заблокировать();
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	БлокировкиСкладскихЯчеек.Ячейка КАК Ячейка,
	|	БлокировкиСкладскихЯчеек.ТипБлокировки КАК ТипБлокировки
	|ИЗ
	|	РегистрСведений.БлокировкиСкладскихЯчеек КАК БлокировкиСкладскихЯчеек
	|ГДЕ
	|	БлокировкиСкладскихЯчеек.Ячейка В (&МассивЯчеек)
	|
	|СГРУППИРОВАТЬ ПО
	|	БлокировкиСкладскихЯчеек.Ячейка,
	|	БлокировкиСкладскихЯчеек.ТипБлокировки
	|
	|УПОРЯДОЧИТЬ ПО
	|	Ячейка";
	
	Запрос.УстановитьПараметр("МассивЯчеек", Товары.ВыгрузитьКолонку("Ячейка"));
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		ТекстСообщения = НСтр("ru = 'Ячейка %Ячейка% заблокирована: тип блокировки ""%ТипБлокировки%""';
								|en = 'Storage bin %Ячейка% is blocked: block type ""%ТипБлокировки%""'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Ячейка%", Выборка.Ячейка);
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ТипБлокировки%", Выборка.ТипБлокировки);
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,,,Отказ);
	КонецЦикла;
	
КонецПроцедуры

Процедура ПроверитьОрдерныйСклад(Отказ)
	
	Если НЕ СкладыСервер.ИспользоватьОрдернуюСхемуПриОтраженииИзлишковНедостач(Склад, Дата) Тогда
		
		Отказ = Истина;
		ТекстСообщения = НСтр("ru = 'На складе ""%Склад%"" на %Дата% не используется ордерная схема при отражении излишков, недостач и порчи.';
								|en = 'Warehouse management is not used in warehouse ""%Склад%"" to record surpluses, shortages and damage as of %Дата%.'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения,"%Склад%",Склад);
		ТекстСообщения = СтрЗаменить(ТекстСообщения,"%Дата%",Формат(Дата, "ДЛФ=D"));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстСообщения,
			Ссылка);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли