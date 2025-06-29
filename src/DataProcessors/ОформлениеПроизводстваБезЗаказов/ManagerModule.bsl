
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Сформировать документы по параметрам.
// 
// Параметры:
//  ПараметрыДокументов - см. ПроизводствоКлиентСервер.ПараметрыФормированияДокументовПроизводстваБезЗаказов
// 
// Возвращаемое значение:
//  Структура - Сформировать документы по параметрам:
// * ОбъектФормы - ДокументОбъект
// * ТипДокумента - Строка
// * ЕстьОшибки - Булево
// * СписокДокументов - СписокЗначений из ДокументСсылка.ПроизводствоБезЗаказа, ДокументСсылка.РаспределениеВозвратныхОтходов - список документов.
// * МассивОшибок - ФиксированныйМассив из СообщениеПользователю - ошибки.
//
Функция СформироватьДокументыПоПараметрам(ПараметрыДокументов) Экспорт
	
	// СтандартныеПодсистемы.ЗамерПроизводительности
	ОписаниеЗамера = ОценкаПроизводительности.НачатьЗамерДлительнойОперации(
		"Обработка.ОформлениеПроизводстваБезЗаказов.Форма.ФормаРабочееМесто.Процедура.ДокументыПоПараметрам");
	// Конец СтандартныеПодсистемы.ЗамерПроизводительности
	
	// Данные шапки.
	ДатаДокумента = Мин(КонецМесяца(ПараметрыДокументов.ПериодРегистрации), ТекущаяДатаСеанса());
	ДанныеШапки = Новый Структура("Дата", ДатаДокумента);
	
	ТаблицаИзделияПоСпецификации = ТаблицаПараметровИзделий(ПараметрыДокументов.ИзделияПоСпецификации, ДатаДокумента);
	
	ПараметрыВыбораСпецификаций = УправлениеДаннымиОбИзделияхКлиентСервер.ПараметрыВыбораСпецификацийНаИзготовлениеСборку();
	
	ИгнорируемыеПараметрыНазначения = Новый Массив;
	ИгнорируемыеПараметрыНазначения.Добавить(Перечисления.ВидыПараметровНазначенияСпецификаций.ПодразделениеДиспетчер);
	ПараметрыВыбораСпецификаций.Вставить("ИгнорируемыеПараметрыНазначения", ИгнорируемыеПараметрыНазначения);
	
	ДанныеОбИзделиях = Новый Массив;
	Для каждого Строка Из ТаблицаИзделияПоСпецификации Цикл
		ДанныеОбИзделии = УправлениеДаннымиОбИзделияхКлиентСервер.СтруктураДанныхОбИзделииДляВыбораСпецификации();
		ЗаполнитьЗначенияСвойств(ДанныеОбИзделии, Строка);
		ДанныеОбИзделиях.Добавить(ДанныеОбИзделии);
	КонецЦикла;
	
	УправлениеДаннымиОбИзделиях.ЗаполнитьСпецификациюВСтроках(
		ТаблицаИзделияПоСпецификации,
		ДанныеОбИзделиях,
		ПараметрыВыбораСпецификаций,,
		Истина);
	
	ТаблицаИзделияПоПравилу = ТаблицаПараметровИзделий(ПараметрыДокументов.ИзделияПоПравилу, ДатаДокумента);
	
	ПараметрыСозданияДокументов = Новый Структура("ДанныеШапки",	ДанныеШапки);
	ПараметрыСозданияДокументов.Вставить("ИзделияПоСпецификации",	ПоместитьВоВременноеХранилище(ТаблицаИзделияПоСпецификации));
	ПараметрыСозданияДокументов.Вставить("ИзделияПоПравилу",		ПоместитьВоВременноеХранилище(ТаблицаИзделияПоПравилу));
	ПараметрыСозданияДокументов.Вставить("ЗаполнятьАвтоматически",	ПараметрыДокументов.ЗаполнятьАвтоматически);
	ПараметрыСозданияДокументов.Вставить("ПереченьДанных",			ПараметрыДокументов.ПереченьДанных);
	
	СписокОбъектов = Новый СписокЗначений;
	
	Документы.ПроизводствоБезЗаказа.ДокументыПоПараметрам(ПараметрыСозданияДокументов, СписокОбъектов);
	Документы.РаспределениеВозвратныхОтходов.ДокументыПоПараметрам(ПараметрыСозданияДокументов, СписокОбъектов);
	
	Результат = Новый Структура;
	Результат.Вставить("ОбъектФормы");
	Результат.Вставить("ТипДокумента");
	Результат.Вставить("ЕстьОшибки",       Ложь);
	Результат.Вставить("СписокДокументов", Новый СписокЗначений);
	
	Если СписокОбъектов.Количество() = 1 Тогда
		
		ТекДокумент = СписокОбъектов[0].Значение;
		Если ТипЗнч(ТекДокумент) = Тип("ДокументОбъект.ПроизводствоБезЗаказа") Тогда
			Результат.ОбъектФормы = ПараметрыДокументов.ОбъектыФормы["ПроизводствоБезЗаказа"];
			Результат.ТипДокумента = "ПроизводствоБезЗаказа";
		Иначе
			Результат.ОбъектФормы = ПараметрыДокументов.ОбъектыФормы["РаспределениеВозвратныхОтходов"];
			Результат.ТипДокумента = "РаспределениеВозвратныхОтходов";
		КонецЕсли;
		
		ЗначениеВДанныеФормы(ТекДокумент, Результат.ОбъектФормы);
		
	Иначе
		
		Для Каждого ТекДокумент Из СписокОбъектов Цикл
			ТекДокумент.Значение.Записать(РежимЗаписиДокумента.Запись);
			Результат.СписокДокументов.Добавить(ТекДокумент.Значение.Ссылка);
			
			Если ТекДокумент.Значение.ПроверитьЗаполнение() Тогда
				Попытка
					ТекДокумент.Значение.Записать(РежимЗаписиДокумента.Проведение);
				Исключение
					Результат.ЕстьОшибки = Истина;
					ОбщегоНазначения.СообщитьПользователю(ОписаниеОшибки());
				КонецПопытки;
			Иначе
				Результат.ЕстьОшибки = Истина;
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;
	
	Результат.Вставить("МассивОшибок", ПолучитьСообщенияПользователю(Истина));
	
	// СтандартныеПодсистемы.ЗамерПроизводительности
	КоличествоОпераций = ПараметрыДокументов.ИзделияПоСпецификации.Количество() + ПараметрыДокументов.ИзделияПоПравилу.Количество();
	ОценкаПроизводительности.ЗакончитьЗамерДлительнойОперации(ОписаниеЗамера, КоличествоОпераций);
	// Конец СтандартныеПодсистемы.ЗамерПроизводительности
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ТаблицаПараметровИзделий(Изделия, ДатаДокумента)
	
	ПараметрыИзделий = Новый ТаблицаЗначений;
	ПараметрыИзделий.Колонки.Добавить("НомерГруппыЗатрат",			Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(10, 0)));
	ПараметрыИзделий.Колонки.Добавить("Организация",				Новый ОписаниеТипов("СправочникСсылка.Организации"));
	ПараметрыИзделий.Колонки.Добавить("ГруппировкаЗатрат",			Новый ОписаниеТипов("ПеречислениеСсылка.ГруппировкиЗатратВПроизводствеБезЗаказа"));
	//++ НЕ УТКА
	ПараметрыИзделий.Колонки.Добавить("ВнутренняяПереработка",		Новый ОписаниеТипов("Булево"));
	ПараметрыИзделий.Колонки.Добавить("ОрганизацияДавалец",			Новый ОписаниеТипов("СправочникСсылка.Организации"));
	//-- НЕ УТКА
	ПараметрыИзделий.Колонки.Добавить("Подразделение",				Новый ОписаниеТипов("СправочникСсылка.СтруктураПредприятия"));
	ПараметрыИзделий.Колонки.Добавить("НаправлениеВыпуска",			Новый ОписаниеТипов("ПеречислениеСсылка.ХозяйственныеОперации"));
	
	ПараметрыИзделий.Колонки.Добавить("Получатель",					Новый ОписаниеТипов("СправочникСсылка.СтруктураПредприятия,
																						|СправочникСсылка.Склады"));
	
	ПараметрыИзделий.Колонки.Добавить("НачалоПроизводства",			Новый ОписаниеТипов("Дата"));
	ПараметрыИзделий.Колонки.Добавить("Номенклатура",				Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));
	ПараметрыИзделий.Колонки.Добавить("Характеристика",				Новый ОписаниеТипов("СправочникСсылка.ХарактеристикиНоменклатуры"));
	ПараметрыИзделий.Колонки.Добавить("Серия",						Новый ОписаниеТипов("СправочникСсылка.СерииНоменклатуры"));
	ПараметрыИзделий.Колонки.Добавить("Назначение",					Новый ОписаниеТипов("СправочникСсылка.Назначения"));
	ПараметрыИзделий.Колонки.Добавить("НаправлениеДеятельности",	Новый ОписаниеТипов("СправочникСсылка.НаправленияДеятельности"));
	ПараметрыИзделий.Колонки.Добавить("Спецификация",				Новый ОписаниеТипов("СправочникСсылка.РесурсныеСпецификации"));
	ПараметрыИзделий.Колонки.Добавить("ПравилоРаспределения",		Новый ОписаниеТипов("СправочникСсылка.ПравилаРаспределенияРасходов"));
	ПараметрыИзделий.Колонки.Добавить("Количество",					Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(15, 3)));
	ПараметрыИзделий.Колонки.Добавить("ОтражатьЗатратыДокументом",	Новый ОписаниеТипов("Булево"));
	ПараметрыИзделий.Колонки.Добавить("ОшибкаВНастройкахМодели",	Новый ОписаниеТипов("Булево"));
	
	Для Каждого Строка Из Изделия Цикл
		
		НоваяСтрока = ПараметрыИзделий.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Строка);
		
		НоваяСтрока.Организация			= ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(НоваяСтрока.Организация);
		НоваяСтрока.НачалоПроизводства	= ДатаДокумента;
		
	КонецЦикла;
	
	Возврат ПараметрыИзделий;
	
КонецФункции

#Область ФормированиеГиперссылкиВЖурналеПроизводства

Функция ТекстЗапросаПроизводствоБезЗаказаКОформлению(Параметры)

	ТекстЗапроса = "
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	|	ТоварыОрганизаций.Организация КАК Организация,
	|	СпрСклады.Подразделение       КАК Подразделение
	|ИЗ
	// Получаем перечень аналитик, по которым была оформлена передача продукции в этом месяце
	|	(ВЫБРАТЬ
	|		ТоварыОрганизацийДвижения.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|		ТоварыОрганизацийДвижения.Организация КАК Организация
	|	ИЗ
	|		РегистрНакопления.ТоварыОрганизаций КАК ТоварыОрганизацийДвижения
	|	ГДЕ
	|		ТоварыОрганизацийДвижения.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)
	|		И ТИПЗНАЧЕНИЯ(ТоварыОрганизацийДвижения.Регистратор) = ТИП(Документ.ДвижениеПродукцииИМатериалов)
	|		И ТоварыОрганизацийДвижения.ХозяйственнаяОперация В (ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПередачаПродукцииИзКладовой),
	|															ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПередачаПродукцииИзПроизводства))
	|	
	|	СГРУППИРОВАТЬ ПО
	|		ТоварыОрганизацийДвижения.АналитикаУчетаНоменклатуры,
	|		ТоварыОрганизацийДвижения.Организация) КАК ТоварыОрганизацийДвижения
	|	
	// Получаем остатки переданной продукции
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.ТоварыОрганизаций.Остатки КАК ТоварыОрганизаций
	|		ПО ТоварыОрганизацийДвижения.АналитикаУчетаНоменклатуры = ТоварыОрганизаций.АналитикаУчетаНоменклатуры
	|		И ТоварыОрганизацийДвижения.Организация = ТоварыОрганизаций.Организация
	|	
	|	ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КлючиАналитикиУчетаНоменклатуры КАК Аналитика
	|		ПО (Аналитика.Ссылка = ТоварыОрганизаций.АналитикаУчетаНоменклатуры)
	|	ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Склады КАК СпрСклады
	|		ПО (Аналитика.МестоХранения = СпрСклады.Ссылка)
	|ГДЕ
	|	ТоварыОрганизаций.КоличествоОстаток < 0
	|	И СпрСклады.ЦеховаяКладовая
	|	И &ТекстУсловия
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	Работы.Организация   КАК Организация,
	|	Работы.Подразделение КАК Подразделение
	|ИЗ
	|	РегистрНакопления.МатериалыИРаботыВПроизводстве.Остатки(,
	|		Номенклатура В (
	|			ВЫБРАТЬ
	|				СпрНоменклатура.Ссылка
	|			ИЗ
	|				Справочник.Номенклатура КАК СпрНоменклатура
	|			ГДЕ
	|				СпрНоменклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Работа))) КАК Работы
	|ГДЕ
	|	Работы.КоличествоОстаток < 0
	|	И &ТекстУсловияРаботы
	|";
	
	ТекстУсловия       = "";
	ТекстУсловияРаботы = "";
	Если Параметры.Свойство("Организация") И ЗначениеЗаполнено(Параметры.Организация) Тогда
		ТекстУсловия       = ТекстУсловия + Символы.ПС + " И ТоварыОрганизаций.Организация = &Организация";
		ТекстУсловияРаботы = ТекстУсловияРаботы + Символы.ПС + " И Работы.Организация = &Организация";
	КонецЕсли;
	
	Если Параметры.Свойство("Подразделение") И ЗначениеЗаполнено(Параметры.Подразделение) Тогда
		ТекстУсловия       = ТекстУсловия + Символы.ПС + " И СпрСклады.Подразделение = &Подразделение";
		ТекстУсловияРаботы = ТекстУсловияРаботы + Символы.ПС + " И Работы.Подразделение = &Подразделение";
	КонецЕсли;
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "И &ТекстУсловияРаботы", ТекстУсловияРаботы);
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "И &ТекстУсловия", ТекстУсловия);
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция СформироватьГиперссылкуКОформлению(Параметры) Экспорт
	
	Если Не (ПравоДоступа("Изменение", Метаданные.Документы.ПроизводствоБезЗаказа)
			ИЛИ ПравоДоступа("Изменение", Метаданные.Документы.РаспределениеВозвратныхОтходов))Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапросаПроизводствоБезЗаказаКОформлению(Параметры);
	Запрос.УстановитьПараметр("Организация", Параметры.Организация);
	Запрос.УстановитьПараметр("Подразделение", Параметры.Подразделение);
	
	ТекстГиперссылки = НСтр("ru = 'Производство без заказа';
							|en = 'Backflush production'");
	Если Запрос.Выполнить().Пустой() Тогда
		Возврат Новый ФорматированнаяСтрока(ТекстГиперссылки,,ЦветаСтиля.НезаполненноеПолеТаблицы,,
			"Обработка.ОформлениеПроизводстваБезЗаказов.Форма.ФормаРабочееМесто");
	Иначе
		Возврат Новый ФорматированнаяСтрока(ТекстГиперссылки,,,,
			"Обработка.ОформлениеПроизводстваБезЗаказов.Форма.ФормаРабочееМесто");
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли