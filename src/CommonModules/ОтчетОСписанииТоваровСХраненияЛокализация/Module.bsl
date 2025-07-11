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
	
	// Акт о списании товаров (ТОРГ-16)
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.МенеджерПечати = "Обработка.ПечатьТОРГ16";
	КомандаПечати.Идентификатор = "ТОРГ16";
	КомандаПечати.Представление = НСтр("ru = 'Акт о списании товаров (ТОРГ-16)';
										|en = 'Retirement certificate (TORG-16)'");
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
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
	
	
КонецПроцедуры

//++ Локализация

// Функция получает данные для формирования печатной формы ТОРГ-16.
//
// Параметры:
//	ПараметрыПечати   - Структура                                        - Дополнительные параметры печати.
//	ДокументОснование - ДокументСсылка.ОтчетОСписанииТоваровСХранения - Документ, который нужно распечатать.
//
// Возвращаемое значение:
//	Структура - структура с данными для печати формы ТОРГ-16.
//
Функция ПолучитьДанныеДляПечатнойФормыТОРГ16(ПараметрыПечати, ДокументОснование) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СписаниеТоваров.Дата				КАК ДатаДокумента,
	|	СписаниеТоваров.Партнер				КАК Партнер,
	|	СписаниеТоваров.Организация			КАК Организация,
	|	СписаниеТоваров.Руководитель		КАК Руководитель,
	|	ЕСТЬNULL(СписаниеТоваров.Руководитель.Должность, """") КАК ДолжностьРуководителя,
	|	СписаниеТоваров.ГлавныйБухгалтер	КАК ГлавныйБухгалтер,
	|	ВЫБОР
	|		КОГДА СписаниеТоваров.ХозяйственнаяОперация В(
	//++ НЕ УТКА
	|				ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.СписаниеТоваровДавальцаНаРасходы),
	//-- НЕ УТКА
	|				ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.СписаниеПринятыхТоваровНаРасходы))
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ								КАК СписаниеЗаНашСчет
	|ИЗ
	|	Документ.ОтчетОСписанииТоваровСХранения КАК СписаниеТоваров
	|
	|ГДЕ
	|	СписаниеТоваров.Ссылка = &ДокументОснование";
	
	Запрос.УстановитьПараметр("ДокументОснование", ДокументОснование);
	
	УстановитьПривилегированныйРежим(Истина);
	ДанныеДокумента = Запрос.Выполнить().Выбрать();
	УстановитьПривилегированныйРежим(Ложь);
	
	ДанныеДокумента.Следующий();
	
	ДатаДокумента     = ДанныеДокумента.ДатаДокумента;
	Организация       = ДанныеДокумента.Организация;
	Партнер           = ДанныеДокумента.Партнер;
	СписаниеЗаНашСчет = ДанныеДокумента.СписаниеЗаНашСчет;
	
	ДопКолонка             = ФормированиеПечатныхФорм.ДополнительнаяКолонкаПечатныхФормДокументов().ИмяКолонки;
	ИспользуетсяДопКолонка = ЗначениеЗаполнено(ДопКолонка);
	
	СтруктураОтветственных = ОтветственныеЛицаСервер.ПолучитьОтветственныеЛицаОрганизации(Организация,
																							КонецДня(ДатаДокумента));
	
	Руководитель          = ?(ЗначениеЗаполнено(ДанныеДокумента.Руководитель),
								ДанныеДокумента.Руководитель,
								СтруктураОтветственных.Руководитель);
	ДолжностьРуководителя = ?(ЗначениеЗаполнено(ДанныеДокумента.Руководитель),
								ДанныеДокумента.ДолжностьРуководителя,
								СтруктураОтветственных.РуководительДолжность);
	ГлавныйБухгалтер      = ?(ЗначениеЗаполнено(ДанныеДокумента.ГлавныйБухгалтер),
								ДанныеДокумента.ГлавныйБухгалтер,
								СтруктураОтветственных.ГлавныйБухгалтер);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ДатаЦен",               ДатаДокумента);
	Запрос.УстановитьПараметр("ТекущийДокумент",       ДокументОснование);
	Запрос.УстановитьПараметр("Руководитель",          Руководитель);
	Запрос.УстановитьПараметр("ДолжностьРуководителя", ДолжностьРуководителя);
	Запрос.УстановитьПараметр("ГлавныйБухгалтер",      ГлавныйБухгалтер);
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	СписаниеТоваров.Ссылка      КАК Ссылка,
	|	НЕОПРЕДЕЛЕНО                КАК ДокументОснование,
	|	ЕСТЬNULL(СписаниеТоваров.ИсправляемыйДокумент.Номер, СписаниеТоваров.Номер) КАК Номер,
	|	ЕСТЬNULL(СписаниеТоваров.ИсправляемыйДокумент.Дата, СписаниеТоваров.Дата) КАК ДатаДокумента,
	|	СписаниеТоваров.Контрагент  КАК Поставщик,
	|	СписаниеТоваров.Организация КАК Организация,
	|	ПРЕДСТАВЛЕНИЕ(СписаниеТоваров.Организация.НаименованиеСокращенное) КАК ОрганизацияПредставление,
	|	ПРЕДСТАВЛЕНИЕ(СписаниеТоваров.Организация.КодПоОКПО)               КАК ОрганизацияПоОКПО,
	|	ПРЕДСТАВЛЕНИЕ(СписаниеТоваров.Организация.Префикс)                 КАК Префикс,
	|	СписаниеТоваров.Подразделение                КАК Подразделение,
	|	ПРЕДСТАВЛЕНИЕ(СписаниеТоваров.Подразделение) КАК ПодразделениеПредставление,
	|	НЕОПРЕДЕЛЕНО                КАК Кладовщик,
	|	НЕОПРЕДЕЛЕНО                КАК ДолжностьКладовщика,
	|	СписаниеТоваров.Менеджер.ФизическоеЛицо КАК Ответственный,
	|	&Руководитель               КАК Руководитель,
	|	&ДолжностьРуководителя      КАК ДолжностьРуководителя,
	|	&ГлавныйБухгалтер           КАК ГлавныйБухгалтер,
	|	""""                        КАК ОснованиеДата,
	|	""""                        КАК НомерОснования
	|ИЗ
	|	Документ.ОтчетОСписанииТоваровСХранения КАК СписаниеТоваров
	|
	|ГДЕ
	|	СписаниеТоваров.Ссылка = &ТекущийДокумент
	|
	|УПОРЯДОЧИТЬ ПО
	|	Ссылка
	|;
	|
	|//////////////////////////////////////////////////////////////////////////////// 1";
	
	Если СписаниеЗаНашСчет Тогда
		
		ТекстЗапроса = ТекстЗапроса + "
		|ВЫБРАТЬ
		|	ТоварыСписания.НомерСтроки                                  КАК НомерСтроки,
		|	&ТекстЗапросаТоварКод                                       КАК ТоварКод,
		|	ТоварыСписания.Номенклатура                                 КАК Номенклатура,
		|	ТоварыСписания.Номенклатура.НаименованиеПолное              КАК НоменклатураПредставление,
		|	ТоварыСписания.Характеристика.НаименованиеПолное            КАК ХарактеристикаПредставление,
		|	ТоварыСписания.Номенклатура.ЕдиницаИзмерения.Код            КАК ЕдиницаИзмеренияКодПоОКЕИ,
		|	ПРЕДСТАВЛЕНИЕ(ТоварыСписания.Номенклатура.ЕдиницаИзмерения) КАК ЕдиницаИзмеренияПредставление,
		|	&ТекстЗапросаВес                                            КАК МассаОдногоМеста,
		|	ТоварыСписания.Количество                                   КАК КоличествоМест,
		|	ВЫБОР
		|		КОГДА &ТекстЗапросаКоэффициентУпаковки <> 0
		|			ТОГДА ТоварыСписания.Цена / &ТекстЗапросаКоэффициентУпаковки
		|		ИНАЧЕ ТоварыСписания.Цена
		|	КОНЕЦ                                                       КАК Цена
		|ИЗ
		|	Документ.ОтчетОСписанииТоваровСХранения.Товары КАК ТоварыСписания
		|ГДЕ
		|	ТоварыСписания.Ссылка = &ТекущийДокумент
		|
		|УПОРЯДОЧИТЬ ПО
		|	ТоварыСписания.НомерСтроки";
		
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса,
									"&ТекстЗапросаКоэффициентУпаковки",
									Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаКоэффициентаУпаковки("ТоварыСписания.Упаковка",
																											"ТоварыСписания.Номенклатура"));
		
	Иначе
		
		ТекстЗапроса = ТекстЗапроса + "
		|ВЫБРАТЬ
		|	Запасы.ВидЦены                КАК ВидЦены,
		|	КлючиАналитики.Номенклатура   КАК Номенклатура,
		|	КлючиАналитики.Характеристика КАК Характеристика
		|
		|ПОМЕСТИТЬ ЗапасыСписания
		|ИЗ
		|	Документ.ОтчетОСписанииТоваровСХранения.ВидыЗапасов КАК ТоварыСписания
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ВидыЗапасов КАК Запасы
		|		ПО ТоварыСписания.ВидЗапасов = Запасы.Ссылка
		|		
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.КлючиАналитикиУчетаНоменклатуры КАК КлючиАналитики
		|		ПО ТоварыСписания.АналитикаУчетаНоменклатуры = КлючиАналитики.Ссылка
		|
		|ГДЕ
		|	ТоварыСписания.Ссылка = &ТекущийДокумент
		|;
		|
		|//////////////////////////////////////////////////////////////////////////////// 2
		|ВЫБРАТЬ
		|	ЦеныНоменклатуры.Номенклатура   КАК Номенклатура,
		|	ЦеныНоменклатуры.Характеристика КАК Характеристика,
		|	ЦеныНоменклатуры.Упаковка       КАК Упаковка,
		|	ЦеныНоменклатуры.Цена           КАК Цена
		|
		|ПОМЕСТИТЬ ЦеныНоменклатуры
		|ИЗ
		|	РегистрСведений.ЦеныНоменклатурыПоставщиков.СрезПоследних(КОНЕЦПЕРИОДА(&ДатаЦен, ДЕНЬ),
		|		(Партнер, ВидЦеныПоставщика, Номенклатура, Характеристика) В
		|			(ВЫБРАТЬ
		|				&Партнер,
		|				ЗапасыСписания.ВидЦены        КАК ВидЦены,
		|				ЗапасыСписания.Номенклатура   КАК Номенклатура,
		|				ЗапасыСписания.Характеристика КАК Характеристика
		|			ИЗ
		|				ЗапасыСписания КАК ЗапасыСписания)) КАК ЦеныНоменклатуры
		|;
		|
		|//////////////////////////////////////////////////////////////////////////////// 3
		|ВЫБРАТЬ
		|	ТоварыСписания.НомерСтроки                                  КАК НомерСтроки,
		|	&ТекстЗапросаТоварКод                                       КАК ТоварКод,
		|	ТоварыСписания.Номенклатура                                 КАК Номенклатура,
		|	ТоварыСписания.Номенклатура.НаименованиеПолное              КАК НоменклатураПредставление,
		|	ТоварыСписания.Характеристика.НаименованиеПолное            КАК ХарактеристикаПредставление,
		|	ТоварыСписания.Номенклатура.ЕдиницаИзмерения.Код            КАК ЕдиницаИзмеренияКодПоОКЕИ,
		|	ПРЕДСТАВЛЕНИЕ(ТоварыСписания.Номенклатура.ЕдиницаИзмерения) КАК ЕдиницаИзмеренияПредставление,
		|	&ТекстЗапросаВес                                            КАК МассаОдногоМеста,
		|	ТоварыСписания.Количество                                   КАК КоличествоМест,
		|	ВЫБОР
		|		КОГДА НЕ &ТекстЗапросаКоэффициентУпаковки ЕСТЬ NULL
		|				И &ТекстЗапросаКоэффициентУпаковки <> 0
		|			ТОГДА ЕСТЬNULL(ЦеныНоменклатуры.Цена, 0) / &ТекстЗапросаКоэффициентУпаковки
		|		ИНАЧЕ ЕСТЬNULL(ЦеныНоменклатуры.Цена, 0)
		|	КОНЕЦ                                                       КАК Цена
		|ИЗ
		|	Документ.ОтчетОСписанииТоваровСХранения.Товары КАК ТоварыСписания
		|		ЛЕВОЕ СОЕДИНЕНИЕ ЦеныНоменклатуры КАК ЦеныНоменклатуры
		|		ПО ТоварыСписания.Номенклатура      = ЦеныНоменклатуры.Номенклатура
		|			И ТоварыСписания.Характеристика = ЦеныНоменклатуры.Характеристика
		|ГДЕ
		|	ТоварыСписания.Ссылка = &ТекущийДокумент
		|
		|УПОРЯДОЧИТЬ ПО
		|	ТоварыСписания.НомерСтроки";
		
		Запрос.УстановитьПараметр("Партнер", Партнер);
		
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса,
									"&ТекстЗапросаКоэффициентУпаковки",
									Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаКоэффициентаУпаковки("ЦеныНоменклатуры.Упаковка",
																											"ЦеныНоменклатуры.Номенклатура"));
		
	КонецЕсли;
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса,
								"&ТекстЗапросаВес",
								Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаКоэффициентаУпаковки(
									"ТоварыСписания.Номенклатура.ЕдиницаИзмерения",
									"ТоварыСписания.Номенклатура"));
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса,
									"&ТекстЗапросаТоварКод",
									"ТоварыСписания.Номенклатура." + ?(ИспользуетсяДопКолонка, ДопКолонка, "Код"));
	
	Запрос.Текст = ТекстЗапроса;
	
	УстановитьПривилегированныйРежим(Истина);
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	УстановитьПривилегированныйРежим(Ложь);
	
	РезультатПоШапке    = РезультатЗапроса[0];
	РезультатПоДатам    = РезультатЗапроса[РезультатЗапроса.Количество() - 1];
	РезультатПоТоварам  = РезультатЗапроса[РезультатЗапроса.Количество() - 1];
	РезультатКурсыВалют = ТаблицаКурсовВалют(ДокументОснование);
	
	СтруктураВозврата = Новый Структура;
	СтруктураВозврата.Вставить("РезультатПоШапке",    РезультатПоШапке);
	СтруктураВозврата.Вставить("РезультатПоДатам",    РезультатПоДатам);
	СтруктураВозврата.Вставить("РезультатПоТоварам",  РезультатПоТоварам);
	СтруктураВозврата.Вставить("РезультатКурсыВалют", РезультатКурсыВалют);
	
	Возврат СтруктураВозврата;
	
КонецФункции

// Функция формирует таблицу курсов валют по дням.
//
// Параметры:
//	ДокументОснование - ДокументСсылка.ОтчетОСписанииТоваровСХранения - документ, на дату которого нужно получить
//																			курсы валют.
//
// Возвращаемое значение:
//	ТаблицаЗначений - таблица значений, содержащая информацию о курсах валют по дням.
//
Функция ТаблицаКурсовВалют(ДокументОснование)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТоварыСписания.Ссылка КАК Ссылка,
	|	ВЫБОР
	|		КОГДА ТоварыСписания.Ссылка.ХозяйственнаяОперация В(
	//++ НЕ УТКА
	|				ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.СписаниеТоваровДавальцаНаРасходы),
	//-- НЕ УТКА
	|				ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.СписаниеПринятыхТоваровНаРасходы))
	|			ТОГДА ТоварыСписания.Ссылка.Валюта
	|		ИНАЧЕ ЕСТЬNULL(МАКСИМУМ(ВидыЦен.Валюта), ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка))
	|	КОНЕЦ                 КАК Валюта
	|ПОМЕСТИТЬ ВалютыСписанияТоваров
	|ИЗ
	|	Документ.ОтчетОСписанииТоваровСХранения.ВидыЗапасов КАК ТоварыСписания
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ВидыЗапасов КАК Запасы
	|		ПО ТоварыСписания.ВидЗапасов = Запасы.Ссылка
	|		
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВидыЦенПоставщиков КАК ВидыЦен
	|		ПО Запасы.ВидЦены = ВидыЦен.Ссылка
	|
	|ГДЕ
	|	ТоварыСписания.Ссылка = &ДокументОснование
	|
	|СГРУППИРОВАТЬ ПО
	|	ТоварыСписания.Ссылка
	|
	|;
	|//////////////////////////////////////////////////////////////////////////////// 1
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	СписаниеТоваров.Ссылка                    КАК Ссылка,
	|	НАЧАЛОПЕРИОДА(СписаниеТоваров.Дата, ДЕНЬ) КАК Дата,
	|	ЕСТЬNULL(ВалютыСписания.Валюта, ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка)) КАК Валюта,
	|	СписаниеТоваров.Организация.ВалютаРегламентированногоУчета КАК ВалютаРегламентированногоУчета
	|ИЗ
	|	Документ.ОтчетОСписанииТоваровСХранения КАК СписаниеТоваров
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВалютыСписанияТоваров КАК ВалютыСписания
	|		ПО СписаниеТоваров.Ссылка = ВалютыСписания.Ссылка
	|ГДЕ
	|	СписаниеТоваров.Ссылка = &ДокументОснование
	|	И ЕСТЬNULL(ВалютыСписания.Валюта, ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка)) <> СписаниеТоваров.Организация.ВалютаРегламентированногоУчета
	|
	|УПОРЯДОЧИТЬ ПО
	|	Валюта,
	|	Дата";
	
	Запрос.УстановитьПараметр("ДокументОснование",              ДокументОснование);
	
	ТаблицаКурсовВалют = Новый ТаблицаЗначений;
	ТаблицаКурсовВалют.Колонки.Добавить("Ссылка",    Новый ОписаниеТипов(
															"ДокументСсылка.ОтчетОСписанииТоваровСХранения"));
	ТаблицаКурсовВалют.Колонки.Добавить("Валюта",    Новый ОписаниеТипов("СправочникСсылка.Валюты"));
	ТаблицаКурсовВалют.Колонки.Добавить("Дата",      Новый ОписаниеТипов("Дата"));
	ТаблицаКурсовВалют.Колонки.Добавить("КурсЧислитель", Новый ОписаниеТипов("Число"));
	ТаблицаКурсовВалют.Колонки.Добавить("КурсЗнаменатель", Новый ОписаниеТипов("Число"));
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Выборка.Следующий();
	
	НоваяСтрока = ТаблицаКурсовВалют.Добавить();
	ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
	
	КурсыВалюты = РаботаСКурсамиВалютУТ.ПолучитьКурсВалюты(Выборка.Валюта, Выборка.Дата, Выборка.ВалютаРегламентированногоУчета);
	
	НоваяСтрока.КурсЧислитель = КурсыВалюты.КурсЧислитель;
	НоваяСтрока.КурсЗнаменатель = КурсыВалюты.КурсЗнаменатель;
	
	Возврат ТаблицаКурсовВалют;
	
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
	
	ТекстыОтражения = Новый Массив;
	
	//++ Локализация
	
	ТекстыОтражения.Добавить(ТекстСписаниеТоваровНаРасходы()); // Списание на расходы собственных товаров (Дт 94, 44 :: Кт 20
	ТекстыОтражения.Добавить(ТекстСписаниеТоваровНаСтатьиАктивовПассивов()); // Списание на прочие активы собственных товаров (Дт ХХ.ХХ :: Кт 20)
	ТекстыОтражения.Добавить(ТекстВозмещениеУбытковПоклажедателяНаРасходы()); // Списание на расходы собственных товаров (Дт 94, 44 :: Кт 60, 76.02)
	ТекстыОтражения.Добавить(ТекстВозмещениеУбытковПоклажедателяНаСтатьиАктивовПассивов()); // Списание на прочие активы собственных товаров (Дт ХХ.ХХ :: Кт 60, 76.02)
	ТекстыОтражения.Добавить(ПроизводствоБезЗаказаЛокализация.ТекстСписаниеТоваровЗаБалансом()); // Списание материалов давальца (Дт :: Кт 002, 003, 004)
	
	//-- Локализация
	
	Возврат СтрСоединить(ТекстыОтражения, ОбщегоНазначенияУТ.РазделительЗапросовВОбъединении());
	
КонецФункции

// Функция возвращает текст запроса дополнительных временных таблиц,
// необходимых для отражения в регламентированном учете
//
// Возвращаемое значение:
//   Строка - сформированный текст запроса.
//
Функция ТекстЗапросаВТОтраженияВРеглУчете() Экспорт
	
	ТекстыЗапроса = Новый Массив;
	
	//++ Локализация
	
	ТекстыЗапроса.Добавить(РеглУчетВыборкиСерверПовтИсп.ТекстВТПерваяЗаписьРегистра("ПрочиеРасходы"));
	
	ТекстыЗапроса.Добавить(РеглУчетВыборкиСерверПовтИсп.ТекстВТПерваяЗаписьРегистра("ДвиженияПоПрочимАктивамПассивам"));
	
	ТекстыЗапроса.Добавить("");
	
	//-- Локализация
	
	ТекстЗапроса = СтрСоединить(ТекстыЗапроса, ОбщегоНазначения.РазделительПакетаЗапросов());
	
	Возврат ТекстЗапроса;
	
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
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	&Период      КАК Период,
	|	&Организация КАК Организация,
	|	НАЧАЛОПЕРИОДА(&Период, ДЕНЬ) КАК ДатаОтражения";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции
//-- НЕ УТ

//-- Локализация

#КонецОбласти

//++ Локализация

//++ НЕ УТ

#Область ФрагментыПроводокРеглУчета

Функция ТекстСписаниеТоваровНаРасходы()
	
	ТекстЗапроса = "
	|ВЫБРАТЬ // Списание на расходы собственных товаров (Дт 94, 44 :: Кт 20)
	|
	|	Стоимости.Ссылка КАК Ссылка,
	|	Стоимости.Период КАК Период,
	|	Стоимости.Организация КАК Организация,
	|	НЕОПРЕДЕЛЕНО КАК ИдентификаторСтроки,
	|
	|	Стоимости.СуммаБалансовая КАК Сумма,
	|	Стоимости.СуммаБалансоваяУУ КАК СуммаУУ,
	|
	|	ВЫБОР
	|		КОГДА Статьи.ВариантРаспределенияРасходовРегл = ЗНАЧЕНИЕ(Перечисление.ВариантыРаспределенияРасходов.НаПрочиеАктивы)
	|		ТОГДА ЗНАЧЕНИЕ(Перечисление.ВидыСчетовРеглУчета.ПрочиеОперации)
	|		ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.ВидыСчетовРеглУчета.Расходы)
	|	КОНЕЦ КАК ВидСчетаДт,
	|	Расходы.СтатьяРасходов КАК АналитикаУчетаДт,
	|	Расходы.Подразделение КАК МестоУчетаДт,
	|
	|	ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка) КАК ВалютаДт,
	|	Расходы.Подразделение КАК ПодразделениеДт,
	|	Расходы.НаправлениеДеятельности КАК НаправлениеДеятельностиДт,
	|
	|	ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ПустаяСсылка) КАК СчетДт,
	|	Расходы.СтатьяРасходов КАК СубконтоДт1,
	|	Расходы.АналитикаРасходов КАК СубконтоДт2,
	|	ВЫБОР
	|		КОГДА Статьи.ВариантРаспределенияРасходовРегл = ЗНАЧЕНИЕ(Перечисление.ВариантыРаспределенияРасходов.НаВнеоборотныеАктивы)
	|		ТОГДА ЕСТЬNULL(ОбъектыСтроительства.СпособСтроительства, ЗНАЧЕНИЕ(Перечисление.СпособыСтроительства.Подрядный))
	|		ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.ТипыЗатратРегл.Прочее)
	|	КОНЕЦ КАК СубконтоДт3,
	|
	|	0 КАК ВалютнаяСуммаДт,
	|	0 КАК КоличествоДт,
	|	ВЫБОР
	|		КОГДА Статьи.ПринятиеКНалоговомуУчету
	|		ТОГДА Стоимости.СуммаНУ
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК СуммаНУДт,
	|	ВЫБОР
	|		КОГДА Статьи.ПринятиеКНалоговомуУчету
	|		ТОГДА Стоимости.СуммаПР
	|		ИНАЧЕ Стоимости.СуммаПР + Стоимости.СуммаНУ
	|	КОНЕЦ КАК СуммаПРДт,
	|	Стоимости.СуммаВР КАК СуммаВРДт,
	|
	|	ЗНАЧЕНИЕ(Перечисление.ВидыСчетовРеглУчета.Производство) КАК ВидСчетаКт,
	|	Стоимости.ГруппаПродукции КАК АналитикаУчетаКт,
	|	Стоимости.ПодразделениеАналитики КАК МестоУчетаКт,
	|
	|	ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка) КАК ВалютаКт,
	|	Стоимости.ПодразделениеАналитики КАК ПодразделениеКт,
	|	Стоимости.НаправлениеДеятельности КАК НаправлениеДеятельностиКт,
	|
	|	НЕОПРЕДЕЛЕНО КАК СчетКт,
	|
	|	Стоимости.Номенклатура КАК СубконтоКт1,
	|	Стоимости.ГруппаПродукции КАК СубконтоКт2,
	|	Стоимости.ТипЗатрат КАК СубконтоКт3,
	|
	|	0 КАК ВалютнаяСуммаКт,
	|	0 КАК КоличествоКт,
	|	Стоимости.СуммаНУ КАК СуммаНУКт,
	|	Стоимости.СуммаПР КАК СуммаПРКт,
	|	Стоимости.СуммаВР КАК СуммаВРКт,
	|	ВЫБОР
	|		КОГДА Стоимости.РазделУчета = ЗНАЧЕНИЕ(Перечисление.РазделыУчетаСебестоимостиТоваров.МатериалыПринятыеВПереработку)
	|		ТОГДА ""Списание на расходы материалов давальца""
	|		КОГДА Стоимости.РазделУчета = ЗНАЧЕНИЕ(Перечисление.РазделыУчетаСебестоимостиТоваров.ТоварыПринятыеНаОтветхранение)
	|		ТОГДА ""Списание на расходы полуфабрикатов давальца""
	|		КОГДА Стоимости.РазделУчета = ЗНАЧЕНИЕ(Перечисление.РазделыУчетаСебестоимостиТоваров.ТоварыНаХраненииСПравомПродажи)
	|		ТОГДА ""Списание на расходы товаров, принятых на ответственное хранение""
	|		КОГДА Стоимости.РазделУчета = ЗНАЧЕНИЕ(Перечисление.РазделыУчетаСебестоимостиТоваров.ТоварыПринятыеНаКомиссию)
	|		ТОГДА ""Списание на расходы товаров принятых на комиссию""
	|		КОГДА Стоимости.РазделУчета В (
	|			ЗНАЧЕНИЕ(Перечисление.РазделыУчетаСебестоимостиТоваров.МатериалыПринятыеВПереработкуКОформлениюСписания),
	|			ЗНАЧЕНИЕ(Перечисление.РазделыУчетаСебестоимостиТоваров.МатериалыПринятыеВПереработкуПереданныеПартнерам))
	|		ТОГДА ""Списание на расходы материалов, принятых в переработку""
	|		ИНАЧЕ ""Списание на расходы товаров, принятых на хранение""
	|	КОНЕЦ КАК Содержание
	|ИЗ
	|	ДокументыКОтражению КАК ДокументыКОтражению
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		ВтСтоимости КАК Стоимости
	|	ПО
	|		Стоимости.Ссылка = ДокументыКОтражению.Ссылка
	|		И Стоимости.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)
	|		И Стоимости.КорРазделУчета = ЗНАЧЕНИЕ(Перечисление.РазделыУчетаСебестоимостиТоваров.ПустаяСсылка)
	|		И Стоимости.РазделУчета В (&ЗабалансовыеРазделыУчета)
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		РегистрНакопления.ПрочиеРасходы КАК Расходы
	|	ПО
	|		Стоимости.Ссылка = Расходы.Регистратор
	|		И Расходы.Активность И НЕ Расходы.Сторно
	|		И Расходы.ИдентификаторФинЗаписи = Стоимости.ИдентификаторФинЗаписи
	|		И Расходы.НастройкаХозяйственнойОперации = Стоимости.НастройкаХозяйственнойОперации
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ 
	|		ПланВидовХарактеристик.СтатьиРасходов КАК Статьи
	|	ПО 
	|		Статьи.Ссылка = Расходы.СтатьяРасходов
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		Справочник.ОбъектыСтроительства КАК ОбъектыСтроительства
	|	ПО
	|		ОбъектыСтроительства.Ссылка = Расходы.АналитикаРасходов
	|		И Статьи.ВариантРаспределенияРасходовРегл = ЗНАЧЕНИЕ(Перечисление.ВариантыРаспределенияРасходов.НаВнеоборотныеАктивы)
	|		И ОбъектыСтроительства.СпособСтроительства <> ЗНАЧЕНИЕ(Перечисление.СпособыСтроительства.ПустаяСсылка)";

	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстСписаниеТоваровНаСтатьиАктивовПассивов()
	
	ТекстЗапроса = РеглУчетВыборкиСерверПовтИсп.ТекстСписаниеСтоимостиНаСтатьиАктивовПассивов(Ложь, Истина);

	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&Содержание", "ВЫБОР
	|		КОГДА Стоимости.РазделУчета = ЗНАЧЕНИЕ(Перечисление.РазделыУчетаСебестоимостиТоваров.МатериалыПринятыеВПереработку)
	|		ТОГДА ""Списание на прочие активы материалов давальца""
	|		КОГДА Стоимости.РазделУчета = ЗНАЧЕНИЕ(Перечисление.РазделыУчетаСебестоимостиТоваров.ТоварыПринятыеНаОтветхранение)
	|		ТОГДА ""Списание на прочие активы полуфабрикатов давальца""
	|		КОГДА Стоимости.РазделУчета = ЗНАЧЕНИЕ(Перечисление.РазделыУчетаСебестоимостиТоваров.ТоварыНаХраненииСПравомПродажи)
	|		ТОГДА ""Списание на прочие активы товаров, принятых на ответственное хранение""
	|		КОГДА Стоимости.РазделУчета = ЗНАЧЕНИЕ(Перечисление.РазделыУчетаСебестоимостиТоваров.ТоварыПринятыеНаКомиссию)
	|		ТОГДА ""Списание на прочие активы товаров принятых на комиссию""
	|		КОГДА Стоимости.РазделУчета В (
	|			ЗНАЧЕНИЕ(Перечисление.РазделыУчетаСебестоимостиТоваров.МатериалыПринятыеВПереработкуКОформлениюСписания),
	|			ЗНАЧЕНИЕ(Перечисление.РазделыУчетаСебестоимостиТоваров.МатериалыПринятыеВПереработкуПереданныеПартнерам))
	|		ТОГДА ""Списание на прочие активы материалов, принятых в переработку""
	|		ИНАЧЕ ""Списание на прочие активы товаров, принятых на хранение""
	|	КОНЕЦ");
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ОтборПоУмолчанию", "Стоимости.РазделУчета В (&ЗабалансовыеРазделыУчета)
	|		И Стоимости.КорРазделУчета = ЗНАЧЕНИЕ(Перечисление.РазделыУчетаСебестоимостиТоваров.ПустаяСсылка)
	|		И НЕ Стоимости.ХозяйственнаяОперация В (ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПередачаНаПрочиеЦели),
	|			ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПеремещениеТоваровМеждуФилиалами))");
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстВозмещениеУбытковПоклажедателяНаРасходы()
	
	ТекстЗапроса = "
	|ВЫБРАТЬ // Списание на расходы собственных товаров (Дт 94, 44 :: Кт 60, 76.02)
	|
	|	Расчеты.Ссылка КАК Ссылка,
	|	Расчеты.Период КАК Период,
	|	Расчеты.Организация КАК Организация,
	|	НЕОПРЕДЕЛЕНО КАК ИдентификаторСтроки,
	|
	|	Расходы.СуммаРегл КАК Сумма,
	|	Расходы.СуммаУпр КАК СуммаУУ,
	|
	|	ВЫБОР
	|		КОГДА Статьи.ВариантРаспределенияРасходовРегл = ЗНАЧЕНИЕ(Перечисление.ВариантыРаспределенияРасходов.НаПрочиеАктивы)
	|		ТОГДА ЗНАЧЕНИЕ(Перечисление.ВидыСчетовРеглУчета.ПрочиеОперации)
	|		ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.ВидыСчетовРеглУчета.Расходы)
	|	КОНЕЦ КАК ВидСчетаДт,
	|	Расходы.СтатьяРасходов КАК АналитикаУчетаДт,
	|	Расходы.Подразделение КАК МестоУчетаДт,
	|
	|	ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка) КАК ВалютаДт,
	|	Расходы.Подразделение КАК ПодразделениеДт,
	|	Расходы.НаправлениеДеятельности КАК НаправлениеДеятельностиДт,
	|
	|	ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ПустаяСсылка) КАК СчетДт,
	|	Расходы.СтатьяРасходов КАК СубконтоДт1,
	|	Расходы.АналитикаРасходов КАК СубконтоДт2,
	|	ВЫБОР
	|		КОГДА Статьи.ВариантРаспределенияРасходовРегл = ЗНАЧЕНИЕ(Перечисление.ВариантыРаспределенияРасходов.НаВнеоборотныеАктивы)
	|		ТОГДА ЕСТЬNULL(ОбъектыСтроительства.СпособСтроительства, ЗНАЧЕНИЕ(Перечисление.СпособыСтроительства.Подрядный))
	|		ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.ТипыЗатратРегл.Прочее)
	|	КОНЕЦ КАК СубконтоДт3,
	|
	|	0 КАК ВалютнаяСуммаДт,
	|	0 КАК КоличествоДт,
	|	ВЫБОР
	|		КОГДА Статьи.ПринятиеКНалоговомуУчету
	|		ТОГДА Расходы.СуммаРегл
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК СуммаНУДт,
	|	ВЫБОР
	|		КОГДА Статьи.ПринятиеКНалоговомуУчету
	|		ТОГДА 0
	|		ИНАЧЕ Расходы.СуммаРегл
	|	КОНЕЦ КАК СуммаПРДт,
	|	0 КАК СуммаВРДт,
	|
	|	Расчеты.ВидСчета КАК ВидСчетаКт,
	|	Расчеты.ГруппаФинансовогоУчета КАК АналитикаУчетаКт,
	|	НЕОПРЕДЕЛЕНО КАК МестоУчетаКт,
	|
	|	Расчеты.Валюта КАК ВалютаКт,
	|	Расчеты.Подразделение КАК ПодразделениеКт,
	|	Расчеты.НаправлениеДеятельности КАК НаправлениеДеятельностиКт,
	|
	|	НЕОПРЕДЕЛЕНО КАК СчетКт,
	|
	|	Расчеты.Контрагент КАК СубконтоКт1,
	|	Расчеты.Договор КАК СубконтоКт2,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоКт3,
	|
	|	ВЫБОР
	|		КОГДА Расчеты.Валюта <> &ВалютаРеглУчета И ПерваяЗаписьРегистра.НомерСтроки = Расходы.НомерСтроки
	|		ТОГДА Расчеты.Сумма
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК ВалютнаяСуммаКт,
	|	0 КАК КоличествоКт,
	|	Расходы.СуммаРегл КАК СуммаНУКт,
	|	0 КАК СуммаПРКт,
	|	0 КАК СуммаВРКт,
	|	""Возмещение убытков поклажедателя на расходы"" КАК Содержание
	|ИЗ
	|	ДокументыКОтражению КАК ДокументыКОтражению
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ РасчетыСПоставщикамиНоваяАрхитектура КАК Расчеты
	|	ПО Расчеты.Ссылка = ДокументыКОтражению.Ссылка
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.ПрочиеРасходы КАК Расходы
	|	ПО Расчеты.Ссылка = Расходы.Регистратор
	|		И Расходы.Активность И НЕ Расходы.Сторно
	|		И Расходы.ИдентификаторФинЗаписи = Расчеты.ИдентификаторФинЗаписи
	|		
	|	ЛЕВОЕ СОЕДИНЕНИЕ ВТПерваяЗаписьПрочиеРасходы КАК ПерваяЗаписьРегистра
	|	ПО ПерваяЗаписьРегистра.Регистратор = Расходы.Регистратор
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ ПланВидовХарактеристик.СтатьиРасходов КАК Статьи
	|	ПО Статьи.Ссылка = Расходы.СтатьяРасходов
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ОбъектыСтроительства КАК ОбъектыСтроительства
	|	ПО ОбъектыСтроительства.Ссылка = Расходы.АналитикаРасходов
	|		И Статьи.ВариантРаспределенияРасходовРегл = ЗНАЧЕНИЕ(Перечисление.ВариантыРаспределенияРасходов.НаВнеоборотныеАктивы)
	|		И ОбъектыСтроительства.СпособСтроительства <> ЗНАЧЕНИЕ(Перечисление.СпособыСтроительства.ПустаяСсылка)";

	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстВозмещениеУбытковПоклажедателяНаСтатьиАктивовПассивов()
	
	ТекстЗапроса = "
	|ВЫБРАТЬ // Списание на прочие активы собственных товаров (Дт ХХ.ХХ :: Кт 60, 76.02)
	|
	|	Расчеты.Ссылка КАК Ссылка,
	|	Расчеты.Период КАК Период,
	|	Расчеты.Организация КАК Организация,
	|	НЕОПРЕДЕЛЕНО КАК ИдентификаторСтроки,
	|
	|	ПрочиеАктивыПассивы.СуммаРегл КАК Сумма,
	|	ПрочиеАктивыПассивы.СуммаУпр КАК СуммаУУ,
	|
	|	ЗНАЧЕНИЕ(Перечисление.ВидыСчетовРеглУчета.ПрочиеАктивыПассивы) КАК ВидСчетаДт,
	|	ПрочиеАктивыПассивы.Статья КАК АналитикаУчетаДт,
	|	ПрочиеАктивыПассивы.Подразделение КАК МестоУчетаДт,
	|
	|	ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка) КАК ВалютаДт,
	|	ПрочиеАктивыПассивы.Подразделение КАК ПодразделениеДт,
	|	ПрочиеАктивыПассивы.НаправлениеДеятельности КАК НаправлениеДеятельностиДт,
	|
	|	ЕСТЬNULL(НастройкиСчетовУчета.СчетУчета, НЕОПРЕДЕЛЕНО) КАК СчетДт,
	|	ЕСТЬNULL(НастройкиСчетовУчета.Субконто1, НЕОПРЕДЕЛЕНО) КАК СубконтоДт1,
	|	ЕСТЬNULL(НастройкиСчетовУчета.Субконто2, НЕОПРЕДЕЛЕНО) КАК СубконтоДт2,
	|	ЕСТЬNULL(НастройкиСчетовУчета.Субконто3, НЕОПРЕДЕЛЕНО) КАК СубконтоДт3,
	|
	|	0 КАК ВалютнаяСуммаДт,
	|	0 КАК КоличествоДт,
	|	ПрочиеАктивыПассивы.СуммаРегл - ПрочиеАктивыПассивы.ПостояннаяРазница - ПрочиеАктивыПассивы.ВременнаяРазница КАК СуммаНУДт,
	|	ПрочиеАктивыПассивы.ПостояннаяРазница КАК СуммаПРДт,
	|	ПрочиеАктивыПассивы.ВременнаяРазница КАК СуммаВРДт,
	|
	|	Расчеты.ВидСчета КАК ВидСчетаКт,
	|	Расчеты.ГруппаФинансовогоУчета КАК АналитикаУчетаКт,
	|	НЕОПРЕДЕЛЕНО КАК МестоУчетаКт,
	|
	|	Расчеты.Валюта КАК ВалютаКт,
	|	Расчеты.Подразделение КАК ПодразделениеКт,
	|	Расчеты.НаправлениеДеятельности КАК НаправлениеДеятельностиКт,
	|
	|	НЕОПРЕДЕЛЕНО КАК СчетКт,
	|
	|	Расчеты.Контрагент КАК СубконтоКт1,
	|	Расчеты.Договор КАК СубконтоКт2,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоКт3,
	|
	|	ВЫБОР
	|		КОГДА Расчеты.Валюта <> &ВалютаРеглУчета И ПерваяЗаписьРегистраРасходы.НомерСтроки ЕСТЬ NULL
	|			И ПерваяЗаписьРегистра.НомерСтроки = ПрочиеАктивыПассивы.НомерСтроки
	|		ТОГДА Расчеты.Сумма
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК ВалютнаяСуммаКт,
	|	0 КАК КоличествоКт,
	|	ПрочиеАктивыПассивы.СуммаРегл КАК СуммаНУКт,
	|	0 КАК СуммаПРКт,
	|	0 КАК СуммаВРКт,
	|	""Возмещение убытков поклажедателя на прочие активы"" КАК Содержание
	|ИЗ
	|	ДокументыКОтражению КАК ДокументыКОтражению
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ РасчетыСПоставщикамиНоваяАрхитектура КАК Расчеты
	|	ПО Расчеты.Ссылка = ДокументыКОтражению.Ссылка
	|	
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.ДвиженияПоПрочимАктивамПассивам КАК ПрочиеАктивыПассивы
	|	ПО Расчеты.Ссылка = ПрочиеАктивыПассивы.Регистратор
	|		И ПрочиеАктивыПассивы.Активность И НЕ ПрочиеАктивыПассивы.Сторно
	|		И ПрочиеАктивыПассивы.ИдентификаторФинЗаписи = Расчеты.ИдентификаторФинЗаписи
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ ВТПерваяЗаписьДвиженияПоПрочимАктивамПассивам КАК ПерваяЗаписьРегистра
	|	ПО ПерваяЗаписьРегистра.Регистратор = ПрочиеАктивыПассивы.Регистратор
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ ВТПерваяЗаписьПрочиеРасходы КАК ПерваяЗаписьРегистраРасходы
	|	ПО ПерваяЗаписьРегистраРасходы.Регистратор = ПрочиеАктивыПассивы.Регистратор
	|	
	|	ЛЕВОЕ СОЕДИНЕНИЕ Справочник.НастройкиСчетовУчетаПрочихОпераций КАК НастройкиСчетовУчета
	|	ПО ПрочиеАктивыПассивы.НастройкаСчетовУчета = НастройкиСчетовУчета.Ссылка";

	Возврат ТекстЗапроса;
	
КонецФункции

#КонецОбласти

//-- НЕ УТ

//-- Локализация

#КонецОбласти
