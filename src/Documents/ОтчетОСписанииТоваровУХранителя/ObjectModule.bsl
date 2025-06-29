#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Заполняет условия продаж в документе списания товаров у хранителя.
//
// Параметры:
//	УсловияПродаж - Структура - Данные для заполнения.
//
Процедура ЗаполнитьУсловияПродаж(Знач УсловияПродаж) Экспорт
	
	Если УсловияПродаж = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	НаправлениеДеятельности = УсловияПродаж.НаправлениеДеятельности;
	Если ЗначениеЗаполнено(УсловияПродаж.ВалютаВзаиморасчетов) Тогда
		Валюта = УсловияПродаж.ВалютаВзаиморасчетов;
	КонецЕсли;
	
	Если УсловияПродаж.Организация <> Организация
		И ЗначениеЗаполнено(УсловияПродаж.Организация) Тогда
		
		Организация = УсловияПродаж.Организация;
		
	КонецЕсли;
	
	Если Не УсловияПродаж.Типовое Тогда
		
		Если ЗначениеЗаполнено(УсловияПродаж.Контрагент)
			И УсловияПродаж.Контрагент <> Контрагент Тогда
			
			Контрагент = УсловияПродаж.Контрагент;
			
		КонецЕсли;
		
	КонецЕсли;
	
	ПартнерыИКонтрагенты.ЗаполнитьКонтрагентаПартнераПоУмолчанию(Партнер, Контрагент);
	
	Обработчик = Документы.ОтчетОСписанииТоваровУХранителя.ОбработчикДействий(ХозяйственнаяОперация);
	Договор = Обработчик.ПолучитьДоговорПоУмолчанию(ЭтотОбъект);
	РеквизитыДоговора = Новый Структура("НаправлениеДеятельности, Подразделение");
	Справочники.ДоговорыКонтрагентов.ЗаполнитьРеквизитыДокумента(ЭтотОбъект, Договор, РеквизитыДоговора);
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьУчетДоходовПоНаправлениямДеятельности") Тогда
		НаправленияДеятельностиСервер.ЗаполнитьНаправлениеПоУмолчанию(НаправлениеДеятельности, Соглашение, Договор);
	КонецЕсли;
	
КонецПроцедуры

// Заполняет условия продаж по умолчанию в документе списания товаров у хранителя.
//
Процедура ЗаполнитьУсловияПродажПоУмолчанию() Экспорт
	
	Обработчик = Документы.ОтчетОСписанииТоваровУХранителя.ОбработчикДействий(ХозяйственнаяОперация);
	ИспользоватьСоглашенияСКлиентами = Обработчик.ИспользоватьСоглашенияСКлиентами();
	
	Если ЗначениеЗаполнено(Партнер)
		Или Не ИспользоватьСоглашенияСКлиентами Тогда
		
		ПараметрыОтбора = Новый Структура;
		ПараметрыОтбора.Вставить("ВыбранноеСоглашение",   Соглашение);
		ПараметрыОтбора.Вставить("ПустаяСсылкаДокумента", Документы.ОтчетОСписанииТоваровУХранителя.ПустаяСсылка());
		ПараметрыОтбора.Вставить("ХозяйственныеОперации", Обработчик.ХозяйственнаяОперацияДоговора());
		
		УсловияПродажПоУмолчанию = ПродажиСервер.ПолучитьУсловияПродажПоУмолчанию(
										Партнер, ПараметрыОтбора, Обработчик.СоглашенияСКлиентамиПрименимы());
		
		Если УсловияПродажПоУмолчанию <> Неопределено Тогда
			
			Если Не ИспользоватьСоглашенияСКлиентами
				Или (Соглашение <> УсловияПродажПоУмолчанию.Соглашение
					И ЗначениеЗаполнено(УсловияПродажПоУмолчанию.Соглашение)) Тогда
				
				Соглашение = УсловияПродажПоУмолчанию.Соглашение;
				
				ЗаполнитьУсловияПродаж(УсловияПродажПоУмолчанию);
				
			Иначе
				Соглашение = УсловияПродажПоУмолчанию.Соглашение;
				
				ПартнерыИКонтрагенты.ЗаполнитьКонтрагентаПартнераПоУмолчанию(Партнер, Контрагент);
				
				Договор = Обработчик.ПолучитьДоговорПоУмолчанию(ЭтотОбъект);
			КонецЕсли;
			
		Иначе
			Соглашение = Неопределено;
			
			ПартнерыИКонтрагенты.ЗаполнитьКонтрагентаПартнераПоУмолчанию(Партнер, Контрагент);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Заполняет условия продаж по соглашению в документе списания товаров у хранителя.
//
Процедура ЗаполнитьУсловияПродажПоСоглашению() Экспорт
	
	УсловияПродаж = ПродажиСервер.ПолучитьУсловияПродаж(Соглашение);
	
	ЗаполнитьУсловияПродаж(УсловияПродаж);
	
КонецПроцедуры

// Функция формирует временные данные документа.
//
// Возвращаемое значение:
//	МенеджерВременныхТаблиц - Менеджер временных таблиц.
//
Функция ВременныеТаблицыДанныхДокумента() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	&Дата        КАК Дата,
	|	&Партнер     КАК Партнер,
	|	&Контрагент  КАК Контрагент,
	|	&Соглашение  КАК Соглашение,
	|	&ХозяйственнаяОперация КАК ХозяйственнаяОперация,
	|	&Организация КАК Организация,
	|	&Договор     КАК Договор,
	|	ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка) КАК Валюта,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ПустаяСсылка) КАК НалогообложениеНДС,
	|	&ТипЗапасов  КАК ТипЗапасов
	|ПОМЕСТИТЬ ТаблицаДанныхДокумента
	|;
	|
	|//////////////////////////////////////////////////////////////////////////////// 1
	|ВЫБРАТЬ
	|	ТаблицаТоваров.НомерСтроки    КАК НомерСтроки,
	|	ТаблицаТоваров.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|	ТаблицаТоваров.Номенклатура   КАК Номенклатура,
	|	ТаблицаТоваров.Характеристика КАК Характеристика,
	|	ТаблицаТоваров.Назначение     КАК Назначение,
	|	ТаблицаТоваров.Серия          КАК Серия,
	|	ТаблицаТоваров.СтатусУказанияСерий КАК СтатусУказанияСерий,
	|	ТаблицаТоваров.Количество     КАК Количество,
	|	ВЫБОР
	|		КОГДА НЕ &ИспользоватьУчетПрослеживаемыхИмпортныхТоваров
	|				ИЛИ НАЧАЛОПЕРИОДА(&Дата, МЕСЯЦ) < &ДатаНачалаУчетаПрослеживаемыхИмпортныхТоваров
	|			ТОГДА 0
	|		ИНАЧЕ &ТекстПоляТаблицаТоваровКоличествоПоРНПТ_
	|	КОНЕЦ                         КАК КоличествоПоРНПТ,
	|	ТаблицаТоваров.НомерГТД       КАК НомерГТД,
	|	&Договор					  КАК Склад,
	|	ИСТИНА                        КАК ПодбиратьВидыЗапасов,
	|	ТаблицаТоваров.Цена           КАК Цена,
	|	ТаблицаТоваров.Сумма          КАК Сумма
	|ПОМЕСТИТЬ ТаблицаТоваров
	|ИЗ
	|	&ТаблицаТоваров КАК ТаблицаТоваров
	|;
	|
	|//////////////////////////////////////////////////////////////////////////////// 2
	|ВЫБРАТЬ
	|	ТаблицаВидыЗапасов.НомерСтроки		КАК НомерСтроки,
	|	ТаблицаВидыЗапасов.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|	ТаблицаВидыЗапасов.ВидЗапасов		КАК ВидЗапасов,
	|	ТаблицаВидыЗапасов.Количество		КАК Количество,
	|	ВЫБОР
	|		КОГДА НЕ &ИспользоватьУчетПрослеживаемыхИмпортныхТоваров
	|				ИЛИ НАЧАЛОПЕРИОДА(&Дата, МЕСЯЦ) < &ДатаНачалаУчетаПрослеживаемыхИмпортныхТоваров
	|			ТОГДА 0
	|		ИНАЧЕ ТаблицаВидыЗапасов.КоличествоПоРНПТ
	|	КОНЕЦ								КАК КоличествоПоРНПТ,
	|	ТаблицаВидыЗапасов.НомерГТД			КАК НомерГТД,
	|	ТаблицаВидыЗапасов.Цена				КАК Цена,
	|	ТаблицаВидыЗапасов.Сумма			КАК Сумма
	|ПОМЕСТИТЬ ВтВидыЗапасов
	|ИЗ
	|	&ТаблицаВидыЗапасов КАК ТаблицаВидыЗапасов
	|;
	|
	|//////////////////////////////////////////////////////////////////////////////// 3
	|ВЫБРАТЬ
	|	ТаблицаВидыЗапасов.НомерСтроки		КАК НомерСтроки,
	|	ТаблицаВидыЗапасов.ВидЗапасов		КАК ВидЗапасов,
	|	ТаблицаВидыЗапасов.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|	Аналитика.Номенклатура				КАК Номенклатура,
	|	Аналитика.Характеристика			КАК Характеристика,
	|	Аналитика.Серия						КАК Серия,
	|	ТаблицаВидыЗапасов.Количество		КАК Количество,
	|	ТаблицаВидыЗапасов.КоличествоПоРНПТ	КАК КоличествоПоРНПТ,
	|	ТаблицаВидыЗапасов.НомерГТД			КАК НомерГТД,
	|	ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка) КАК СкладОтгрузки,
	|	Аналитика.МестоХранения				КАК Склад,
	|	ЗНАЧЕНИЕ(Справочник.СделкиСКлиентами.ПустаяСсылка) КАК Сделка,
	|	&ВидыЗапасовУказаныВручную			КАК ВидыЗапасовУказаныВручную,
	|	ТаблицаВидыЗапасов.Цена				КАК Цена,
	|	ТаблицаВидыЗапасов.Сумма			КАК Сумма
	|ПОМЕСТИТЬ ТаблицаВидыЗапасов
	|ИЗ
	|	ВтВидыЗапасов КАК ТаблицаВидыЗапасов
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КлючиАналитикиУчетаНоменклатуры КАК Аналитика
	|		ПО ТаблицаВидыЗапасов.АналитикаУчетаНоменклатуры = Аналитика.Ссылка
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	АналитикаУчетаНоменклатуры";
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	ТаблицаТоваров = ?(ДополнительныеСвойства.Свойство("ТаблицыЗаполненияВидовЗапасовПриОбмене")
							И ДополнительныеСвойства.ТаблицыЗаполненияВидовЗапасовПриОбмене <> Неопределено
							И ДополнительныеСвойства.ТаблицыЗаполненияВидовЗапасовПриОбмене.Свойство("Товары"),
						ДополнительныеСвойства.ТаблицыЗаполненияВидовЗапасовПриОбмене.Товары,
						Товары);
	
	Запрос.УстановитьПараметр("Ссылка",                    Ссылка);
	Запрос.УстановитьПараметр("Дата",                      Дата);
	Запрос.УстановитьПараметр("Партнер",                   Партнер);
	Запрос.УстановитьПараметр("Контрагент",                Контрагент);
	Запрос.УстановитьПараметр("Соглашение",                Соглашение);
	Запрос.УстановитьПараметр("ХозяйственнаяОперация",     ХозяйственнаяОперация);
	Запрос.УстановитьПараметр("Организация",               Организация);
	Запрос.УстановитьПараметр("Договор",                   Договор);
	Запрос.УстановитьПараметр("ТипЗапасов",                Перечисления.ТипыЗапасов.Товар);
	Запрос.УстановитьПараметр("Проведен",                  Проведен);
	Запрос.УстановитьПараметр("ТаблицаТоваров",            ТаблицаТоваров);
	Запрос.УстановитьПараметр("ТаблицаВидыЗапасов",        ВидыЗапасов);
	Запрос.УстановитьПараметр("ВидыЗапасовУказаныВручную", ВидыЗапасовУказаныВручную);
	
	УчетПрослеживаемыхТоваровЛокализация.УстановитьПараметрыИспользованияУчетаПрослеживаемыхТоваров(Запрос);
	
	ЗапасыСервер.ДополнитьВременныеТаблицыОбязательнымиКолонками(Запрос);
	
	ОбщегоНазначенияУТ.ЗаменитьОтсутствующиеПоляТаблицыЗначенийВТекстеЗапроса(
		ТаблицаТоваров,
		Запрос.Текст,
		"&ТекстПоляТаблицаТоваровКоличествоПоРНПТ_",
		"ТаблицаТоваров",
		"КоличествоПоРНПТ",
		"ТаблицаТоваров.КоличествоПоРНПТ",
		"0");
	
	Запрос.Выполнить();
	
	Возврат МенеджерВременныхТаблиц;
	
КонецФункции

// Инициализирует параметры заполнения видов запасов дополнительных свойств документа, используемых при записи документа
// в режиме 'Проведения' или 'Отмены проведения'.
//
// Параметры:
//	ДокументОбъект - ДокументОбъект.ОтчетОСписанииТоваровУХранителя - документ, для которого выполняется инициализация параметров.
//	РежимЗаписи - РежимЗаписиДокумента - режим записи документа.
//
Процедура ИнициализироватьПараметрыЗаполненияВидовЗапасовДляПроведения(ДокументОбъект, РежимЗаписи = Неопределено) Экспорт
	
	ДокументОбъект.ДополнительныеСвойства.Вставить("ПараметрыЗаполненияВидовЗапасов", ПараметрыЗаполненияВидовЗапасов());
	
КонецПроцедуры

// Заполняет реквизиты, хранящие информацию о видах запасов и аналитиках учета номенклатуры в табличной части 'Товары'
// документа, а также заполняет табличную часть 'ВидыЗапасов'.
//
// Параметры:
//	Отказ - Булево - признак того, что не удалось заполнить данные.
//	ТаблицыДокумента - см. Документы.ОтчетОСписанииТоваровУХранителя.КоллекцияТабличныхЧастейТоваров.
//
Процедура ЗаполнитьВидыЗапасовПриОбмене(Отказ, ТаблицыДокумента) Экспорт
	
	ЗаполнитьАналитикиУчетаНоменклатурыВТабличныхЧастяхТоваров();
	
	Если ТаблицыДокумента <> Неопределено Тогда
		ЗаполнитьАналитикиУчетаНоменклатурыВТабличныхЧастяхТоваров(ТаблицыДокумента);
		ДополнительныеСвойства.Вставить("ТаблицыЗаполненияВидовЗапасовПриОбмене", ТаблицыДокумента);
	Иначе
		ИмяПараметра = "ТаблицыДокумента";
		
		ТекстИсключения = НСтр("ru = 'Для заполнения видов запасов не передан параметр ""%1"".';
								|en = 'The ""%1"" parameter is not transferred to fill in the inventory owner attributes.'");
		ТекстИсключения = СтрШаблон(ТекстИсключения, ИмяПараметра);
		
		ВызватьИсключение ТекстИсключения;
	КонецЕсли;
	
	ЗаполнитьВидыЗапасов(Отказ);
	ДополнительныеСвойства.Удалить("ТаблицыЗаполненияВидовЗапасовПриОбмене");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	ПараметрыУказанияСерий = НоменклатураСервер.ПараметрыУказанияСерий(ЭтотОбъект, Документы.ОтчетОСписанииТоваровУХранителя);
	
	НоменклатураСервер.ПроверитьЗаполнениеХарактеристик(ЭтотОбъект, МассивНепроверяемыхРеквизитов, Отказ);
	НоменклатураСервер.ПроверитьЗаполнениеСерий(ЭтотОбъект, ПараметрыУказанияСерий, Отказ, МассивНепроверяемыхРеквизитов);
	
	Если ПолучитьФункциональнуюОпцию("ФормироватьВидыЗапасовПоПодразделениямМенеджерам") Тогда
		ПроверяемыеРеквизиты.Добавить("Подразделение");
	КонецЕсли;
	
	МассивНепроверяемыхРеквизитов.Добавить("Товары.НомерГТД");
	Если ПолучитьФункциональнуюОпцию("ЗапретитьПоступлениеТоваровБезНомеровГТД")
		//++ НЕ УТ
		И Не ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.СписаниеТоваровУПереработчика
		//-- НЕ УТ
		И Истина Тогда
		ЗапасыСервер.ПроверитьЗаполнениеНомеровГТД(ЭтотОбъект, Отказ);
	КонецЕсли;
	
	ИсправлениеДокументов.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	Обработчик = Документы.ОтчетОСписанииТоваровУХранителя.ОбработчикДействий(ХозяйственнаяОперация);
	Если Не Обработчик.ИспользоватьСоглашенияСКлиентами() Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Соглашение");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты,МассивНепроверяемыхРеквизитов);
	
	// Выбор статей и аналитик.
	ПараметрыВыбораСтатейИАналитик = Документы.ОтчетОСписанииТоваровУХранителя.ПараметрыВыбораСтатейИАналитик();
	ДоходыИРасходыСервер.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты,
		ПараметрыВыбораСтатейИАналитик);
		
	Если Не Отказ
		И ОбщегоНазначенияУТ.ПроверитьЗаполнениеРеквизитовОбъекта(ЭтотОбъект, ПроверяемыеРеквизиты) Тогда
		
		Отказ = Истина;
		
	КонецЕсли;
	
	ЗатратыСервер.ПроверитьИспользованиеПартионногоУчета22(ЭтотОбъект, Дата, Отказ);
	
	ПродажиСервер.ПроверитьКорректностьЗаполненияДокументаПродажи(ЭтотОбъект, Отказ);
	
	ОтчетОСписанииТоваровУХранителяЛокализация.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
	//++ НЕ УТКА
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ОтчетОСписанииТоваровСХранения") Тогда
		ЗаполнитьНаОснованииОтчетаОСписанииТоваровДавальца(ДанныеЗаполнения);
	//-- НЕ УТКА
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка." + Метаданные().Имя) Тогда
		ИсправлениеДокументов.ЗаполнитьИсправление(ЭтотОбъект, ДанныеЗаполнения);
	КонецЕсли;
	
	// Выбор статей и аналитик.
	ПараметрыВыбораСтатейИАналитик = Документы.ОтчетОСписанииТоваровУХранителя.ПараметрыВыбораСтатейИАналитик();
	ДоходыИРасходыСервер.ОбработкаЗаполнения(ЭтотОбъект, ПараметрыВыбораСтатейИАналитик);
	
	ИнициализироватьДокумент();
	
	УсловияПродажПоУмолчанию = ПродажиСервер.ПолучитьУсловияПродажПоУмолчанию(
		Партнер,
		Новый Структура("ВыбранноеСоглашение, ПустаяСсылкаДокумента", 
		Соглашение,
		Документы.ОтчетОСписанииТоваровУХранителя.ПустаяСсылка()));
	
	Если УсловияПродажПоУмолчанию <> Неопределено Тогда
		Валюта = УсловияПродажПоУмолчанию.Валюта;
	КонецЕсли;
	
	ОтветственныеЛицаСервер.ОтветственныеЛицаДокументаОбработкаЗаполнения(Ссылка, ДанныеЗаполнения, СтандартнаяОбработка);
	ЗаполнениеОбъектовПоСтатистике.ЗаполнитьРеквизитыОбъекта(ЭтотОбъект, ДанныеЗаполнения);
	
	ОтчетОСписанииТоваровУХранителяЛокализация.ОбработкаЗаполнения(ЭтотОбъект, ДанныеЗаполнения, СтандартнаяОбработка);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	// Очистим реквизиты документа не используемые для хозяйственной операции.
	МассивВсехРеквизитов = Новый Массив;
	МассивРеквизитовОперации = Новый Массив;
	Документы.ОтчетОСписанииТоваровУХранителя.ЗаполнитьИменаРеквизитовПоХозяйственнойОперации(
		ХозяйственнаяОперация,
		МассивВсехРеквизитов,
		МассивРеквизитовОперации);
	ДенежныеСредстваСервер.ОчиститьНеиспользуемыеРеквизиты(
		ЭтотОбъект,
		МассивВсехРеквизитов,
		МассивРеквизитовОперации);

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ИсправлениеДокументов.ПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	
	ПроведениеДокументов.ПередЗаписьюДокумента(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	
	ПараметрыУказанияСерий = НоменклатураСервер.ПараметрыУказанияСерий(ЭтотОбъект, Документы.ОтчетОСписанииТоваровУХранителя);
	
	НоменклатураСервер.ОчиститьНеиспользуемыеСерии(ЭтотОбъект, ПараметрыУказанияСерий);
	
	Сумма = Товары.Итог("Сумма");
	
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		
		ЗаполнитьАналитикиУчетаНоменклатурыВТабличныхЧастяхТоваров();
		ЗаполнитьВидыЗапасов(Отказ);
		
	ИначеЕсли РежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения Тогда
		Если Не ВидыЗапасовУказаныВручную Тогда
			ВидыЗапасов.Очистить();
		КонецЕсли;
	КонецЕсли;
	
	Если ЭтоНовый()
		И Не ЗначениеЗаполнено(Номер) Тогда
		
		УстановитьНовыйНомер();
		
	КонецЕсли;
	
	ОбщегоНазначенияУТ.ЗаполнитьИдентификаторыДокумента(ЭтотОбъект, "ВидыЗапасов");
	
	//++ НЕ УТ

	//Настройка счетов учета
	НастройкаСчетовУчетаСервер.ПередЗаписью(ЭтотОбъект,
		Документы.ОтчетОСписанииТоваровУХранителя.ПараметрыНастройкиСчетовУчета());
	//-- НЕ УТ
	
	// Выбор статей и аналитик.
	ПараметрыВыбораСтатейИАналитик = Документы.ОтчетОСписанииТоваровУХранителя.ПараметрыВыбораСтатейИАналитик();
	ДоходыИРасходыСервер.ПередЗаписью(ЭтотОбъект, ПараметрыВыбораСтатейИАналитик);
	
	ИсправлениеДокументов.ПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	ОтчетОСписанииТоваровУХранителяЛокализация.ПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПроведениеДокументов.ПриЗаписиДокумента(ЭтотОбъект, Отказ);
	
	ОтчетОСписанииТоваровУХранителяЛокализация.ПриЗаписи(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ИнициализироватьПараметрыЗаполненияВидовЗапасовДляПроведения(ЭтотОбъект);
	
	ПроведениеДокументов.ОбработкаПроведенияДокумента(ЭтотОбъект, Отказ);
	
	ОтчетОСписанииТоваровУХранителяЛокализация.ОбработкаПроведения(ЭтотОбъект, Отказ, РежимПроведения);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ИнициализироватьПараметрыЗаполненияВидовЗапасовДляПроведения(ЭтотОбъект);
	
	ПроведениеДокументов.ОбработкаУдаленияПроведенияДокумента(ЭтотОбъект, Отказ);
	
	ОтчетОСписанииТоваровУХранителяЛокализация.ОбработкаУдаленияПроведения(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ИсправлениеДокументов.ПриКопировании(ЭтотОбъект, ОбъектКопирования);
	
	ВидыЗапасовУказаныВручную = Ложь;
	Основание = Неопределено;
	
	ВидыЗапасов.Очистить();
	
	ИнициализироватьДокумент();
	
	ОбщегоНазначенияУТ.ОчиститьИдентификаторыДокумента(ЭтотОбъект, "ВидыЗапасов");
	
	ОтчетОСписанииТоваровУХранителяЛокализация.ПриКопировании(ЭтотОбъект, ОбъектКопирования);
	
	Автор = Пользователи.ТекущийПользователь();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ИнициализацияИЗаполнение

Процедура ИнициализироватьДокумент()
	
	Организация   = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	Если Не ЗначениеЗаполнено(Валюта) Тогда
		Валюта = ЗначениеНастроекПовтИсп.ВалютаРегламентированногоУчетаОрганизации(Организация);
	КонецЕсли;
	Ответственный = Пользователи.ТекущийПользователь();
	Подразделение = ЗначениеНастроекПовтИсп.ПодразделениеПользователя(Ответственный, Подразделение);
	
	Если Не ЗначениеЗаполнено(ИсточникИнформацииОЦенахДляПечати) Тогда
		ИсточникИнформацииОЦенахДляПечати = Перечисления.ИсточникиИнформацииОЦенахДляПечати.ПоСебестоимости;
		ВидЦены                           = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

//++ НЕ УТКА

#Область ЗаполнениеПоОтчетуОСписанииТоваровДавальца

Процедура ЗаполнитьНаОснованииОтчетаОСписанииТоваровДавальца(СтруктураЗаполнения)
	
	ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.СписаниеТоваровУПереработчика;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Основание", СтруктураЗаполнения);
	Запрос.Текст = ТекстЗапросаЗаполнитьНаОснованииОтчетаОСписанииТоваровДавальца();
	
	Результат = Запрос.ВыполнитьПакет();
	РеквизитыШапки = Результат[Результат.ВГраница() - 1].Выбрать();
	ТаблицаТовары  = Результат[Результат.ВГраница()].Выгрузить();
	
	Если РеквизитыШапки.Следующий() Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, РеквизитыШапки);
	КонецЕсли;
	
	Товары.Загрузить(ТаблицаТовары);
	
	ПараметрыУказанияСерий = Новый ФиксированнаяСтруктура(НоменклатураСервер.ПараметрыУказанияСерий(ЭтотОбъект, Документы.ОтчетОСписанииТоваровУХранителя));
	НоменклатураСервер.ЗаполнитьСтатусыУказанияСерий(ЭтотОбъект, ПараметрыУказанияСерий);
	
КонецПроцедуры

Функция ТекстЗапросаЗаполнитьНаОснованииОтчетаОСписанииТоваровДавальца()
	
	ТекстЗапроса =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	СпрОрганизации.Ссылка           КАК Организация,
	|	СпрКонтрагенты.Ссылка           КАК Контрагент,
	|	СпрКонтрагенты.Партнер          КАК Партнер,
	|	СпрДоговоры.Ссылка              КАК Договор,
	|	ВЫБОР
	|		КОГДА СпрДоговоры.НаправлениеДеятельности ЕСТЬ NULL
	|			ТОГДА ОтчетОСписанииТоваровСХранения.НаправлениеДеятельности
	|		ИНАЧЕ СпрДоговоры.НаправлениеДеятельности
	|	КОНЕЦ                                 КАК НаправлениеДеятельности,
	|	ОтчетОСписанииТоваровСХранения.Валюта КАК Валюта,
	|	ВЫБОР
	|		КОГДА СпрДоговоры.ВалютаВзаиморасчетов ЕСТЬ NULL
	|			ТОГДА ОтчетОСписанииТоваровСХранения.ВалютаВзаиморасчетов
	|		ИНАЧЕ СпрДоговоры.ВалютаВзаиморасчетов
	|	КОНЕЦ                                 КАК ВалютаВзаиморасчетов,
	|	ОтчетОСписанииТоваровСХранения.Ссылка КАК Основание
	|ИЗ
	|	Документ.ОтчетОСписанииТоваровСХранения КАК ОтчетОСписанииТоваровСХранения
	|	
	|	ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Контрагенты КАК Давалец
	|	ПО Давалец.Ссылка = ОтчетОСписанииТоваровСХранения.Контрагент
	|	
	|	ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Организации КАК СпрОрганизации
	|	ПО СпрОрганизации.ИНН = Давалец.ИНН
	|	И СпрОрганизации.КПП = Давалец.КПП
	|	И НЕ СпрОрганизации.ПометкаУдаления
	|	
	|	ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Организации КАК Переработчик
	|	ПО Переработчик.Ссылка = ОтчетОСписанииТоваровСХранения.Организация
	|	
	|	ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Контрагенты КАК СпрКонтрагенты
	|	ПО СпрКонтрагенты.ИНН = Переработчик.ИНН
	|	И СпрКонтрагенты.КПП = Переработчик.КПП
	|	И НЕ СпрКонтрагенты.ПометкаУдаления
	|	
	|	ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ДоговорыКонтрагентов КАК ДоговорДавальца
	|	ПО ДоговорДавальца.Ссылка = ОтчетОСписанииТоваровСХранения.Договор
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ДоговорыКонтрагентов КАК СпрДоговоры
	|	ПО СпрДоговоры.Организация = СпрОрганизации.Ссылка
	|	И СпрДоговоры.Контрагент = СпрКонтрагенты.Ссылка
	|	И СпрДоговоры.Номер = ДоговорДавальца.Номер
	|	И СпрДоговоры.Дата = ДоговорДавальца.Дата
	|	И СпрДоговоры.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыДоговоровКонтрагентов.Действует)
	|	И НЕ СпрДоговоры.ПометкаУдаления
	|
	|ГДЕ
	|	ОтчетОСписанииТоваровСХранения.Ссылка = &Основание
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ТаблицаТоваров.АналитикаУчетаНоменклатуры.Номенклатура   КАК Номенклатура,
	|	ТаблицаТоваров.АналитикаУчетаНоменклатуры.Характеристика КАК Характеристика,
	|	ТаблицаТоваров.АналитикаУчетаНоменклатуры.Серия          КАК Серия,
	|	ТаблицаТоваров.НомерГТД                                  КАК НомерГТД,
	|	СУММА(ТаблицаТоваров.Количество)                         КАК Количество,
	|	ТаблицаТоваров.Цена                                      КАК Цена,
	|	СУММА(ТаблицаТоваров.Сумма)                              КАК Сумма
	|ИЗ
	|	Документ.ОтчетОСписанииТоваровСХранения.ВидыЗапасов КАК ТаблицаТоваров
	|ГДЕ
	|	ТаблицаТоваров.Ссылка = &Основание
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаТоваров.АналитикаУчетаНоменклатуры,
	|	ТаблицаТоваров.НомерГТД,
	|	ТаблицаТоваров.Цена
	|";
	
	Возврат ТекстЗапроса;
	
КонецФункции

#КонецОбласти

//-- НЕ УТКА

#КонецОбласти

#Область ВидыЗапасов

Процедура ЗаполнитьВидыЗапасов(Отказ)
	
	УстановитьПривилегированныйРежим(Истина);
	
	МенеджерВременныхТаблиц		= ВременныеТаблицыДанныхДокумента();
	ПерезаполнитьВидыЗапасов	= ЗапасыСервер.ПроверитьНеобходимостьПерезаполненияВидовЗапасовДокумента(ЭтотОбъект);
	
	Если Не Проведен
		Или ПерезаполнитьВидыЗапасов
		Или ПроверитьИзменениеРеквизитовДокумента(МенеджерВременныхТаблиц)
		Или ПроверитьИзменениеТоваров(МенеджерВременныхТаблиц) Тогда
		
		ПараметрыЗаполнения = ПараметрыЗаполненияВидовЗапасов();
		
		ЗапасыСервер.ЗаполнитьВидыЗапасовПоТоварамОрганизаций(ЭтотОбъект,
																МенеджерВременныхТаблиц,
																Отказ,
																ПараметрыЗаполнения);
		
		ВидыЗапасов.Свернуть("АналитикаУчетаНоменклатуры, ВидЗапасов, НомерГТД", "Количество, КоличествоПоРНПТ");
		ЗаполнитьДопКолонкиВидовЗапасов();
		
	КонецЕсли;
	
	Если ПривилегированныйРежим() Тогда
		УстановитьПривилегированныйРежим(Ложь);
	КонецЕсли;
	
КонецПроцедуры

// Процедура заполняет дополнительные колонки табличной части 'ВидыЗапасов' документа.
//
Процедура ЗаполнитьДопКолонкиВидовЗапасов() Экспорт
	
	ВыгружаемыеКолонки = "АналитикаУчетаНоменклатуры, Количество, Цена, Сумма";
	
	ТаблицаТовары = Товары.Выгрузить(, ВыгружаемыеКолонки);
	ТаблицаТовары.Свернуть("АналитикаУчетаНоменклатуры, Цена",
							"Количество, Сумма");
	
	СтруктураПоиска = Новый Структура("АналитикаУчетаНоменклатуры");
	
	Для Каждого СтрокаТоваров Из ТаблицаТовары Цикл
		
		КоличествоТоваров  = СтрокаТоваров.Количество;
		СуммаТоваров       = СтрокаТоваров.Сумма;
		
		Если КоличествоТоваров = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		ЗаполнитьЗначенияСвойств(СтруктураПоиска, СтрокаТоваров);
		
		Для Каждого СтрокаЗапасов Из ВидыЗапасов.НайтиСтроки(СтруктураПоиска) Цикл
			
			Если СтрокаЗапасов.Количество = 0 Тогда
				Продолжить;
			КонецЕсли;
			
			Количество = Мин(КоличествоТоваров, СтрокаЗапасов.Количество);
			
			НоваяСтрока = ВидыЗапасов.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаЗапасов);
			
			НоваяСтрока.Цена       = СтрокаТоваров.Цена;
			НоваяСтрока.Количество = Количество;
			
			Если КоличествоТоваров <> 0 Тогда
				НоваяСтрока.Сумма               = Количество * СуммаТоваров / КоличествоТоваров;
			КонецЕсли;
			
			СтрокаЗапасов.Количество = СтрокаЗапасов.Количество - НоваяСтрока.Количество;
			
			КоличествоТоваров  = КоличествоТоваров - НоваяСтрока.Количество;
			СуммаТоваров       = СуммаТоваров - НоваяСтрока.Сумма;
			
			Если КоличествоТоваров = 0 Тогда
				Прервать;
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
	
	Отбор = Новый Структура("Количество", 0);
	МассивУдаляемыхСтрок = ВидыЗапасов.НайтиСтроки(Отбор);
	
	Для Каждого СтрокаТаблицы Из МассивУдаляемыхСтрок Цикл
		ВидыЗапасов.Удалить(СтрокаТаблицы);
	КонецЦикла;
	
КонецПроцедуры

Функция ПроверитьИзменениеРеквизитовДокумента(МенеджерВременныхТаблиц)
	
	ИменаРеквизитов = "Дата, Организация, ХозяйственнаяОперация, Партнер, Договор";
	
	Возврат ЗапасыСервер.ПроверитьИзменениеРеквизитовДокумента(МенеджерВременныхТаблиц, Ссылка, ИменаРеквизитов);
	
КонецФункции

Функция ПроверитьИзменениеТоваров(МенеджерВременныхТаблиц)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаТоваров.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры
	|ИЗ
	|	(ВЫБРАТЬ
	|		ТаблицаТоваров.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|		ТаблицаТоваров.Номенклатура   КАК Номенклатура,
	|		ТаблицаТоваров.Характеристика КАК Характеристика,
	|		ТаблицаТоваров.Количество     КАК Количество,
	|		ТаблицаТоваров.НомерГТД       КАК НомерГТД,
	|		ТаблицаТоваров.Сумма          КАК Сумма
	|
	|	ИЗ
	|		ТаблицаТоваров КАК ТаблицаТоваров
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ТаблицаВидыЗапасов.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|		ТаблицаВидыЗапасов.Номенклатура   КАК Номенклатура,
	|		ТаблицаВидыЗапасов.Характеристика КАК Характеристика,
	|		-ТаблицаВидыЗапасов.Количество    КАК Количество,
	|		ТаблицаВидыЗапасов.НомерГТД       КАК НомерГТД,
	|		-ТаблицаВидыЗапасов.Сумма         КАК Сумма
	|	ИЗ
	|		ТаблицаВидыЗапасов КАК ТаблицаВидыЗапасов
	|	) КАК ТаблицаТоваров
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаТоваров.АналитикаУчетаНоменклатуры,
	|	ТаблицаТоваров.Номенклатура,
	|	ТаблицаТоваров.Характеристика,
	|	ТаблицаТоваров.НомерГТД
	|
	|ИМЕЮЩИЕ
	|	СУММА(ТаблицаТоваров.Количество) <> 0
	|	ИЛИ СУММА(ТаблицаТоваров.Сумма) <> 0
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|";
	
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	РезультатЗапрос = Запрос.Выполнить();
	
	Возврат Не РезультатЗапрос.Пустой();
	
КонецФункции

Функция ПараметрыЗаполненияВидовЗапасов()
	
	Обработчик = Документы.ОтчетОСписанииТоваровУХранителя.ОбработчикДействий(ХозяйственнаяОперация);
	
	Возврат Обработчик.ПараметрыЗаполненияВидовЗапасов(ЭтотОбъект);
	
КонецФункции

// Заполняет аналитики учета номенклатуры в табличных частях документа, хранящих информацию о товарах.
// Если параметр не передан, тогда будет выполнено заполнение данных в табличных частях документа.
//
// Параметры:
//	ТаблицыДокумента - см. Документы.ОтчетОСписанииТоваровУХранителя.КоллекцияТабличныхЧастейТоваров.
//
Процедура ЗаполнитьАналитикиУчетаНоменклатурыВТабличныхЧастяхТоваров(ТаблицыДокумента = Неопределено)
	
	Если ТаблицыДокумента = Неопределено Тогда
		ТаблицыДокумента = Документы.ОтчетОСписанииТоваровУХранителя.КоллекцияТабличныхЧастейТоваров();
		
		ЗаполнитьЗначенияСвойств(ТаблицыДокумента, ЭтотОбъект);
	КонецЕсли;
	
	ТаблицаТовары = ТаблицыДокумента.Товары;
	
	МестаУчета = РегистрыСведений.АналитикаУчетаНоменклатуры.МестаУчета(ХозяйственнаяОперация,
																		Договор,
																		Подразделение,
																		Партнер,
																		Договор);
	
	ИменаПолей = РегистрыСведений.АналитикаУчетаНоменклатуры.ИменаПолейКоллекцииПоУмолчанию();
	
	РегистрыСведений.АналитикаУчетаНоменклатуры.ЗаполнитьВКоллекции(ТаблицаТовары, МестаУчета, ИменаПолей);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
