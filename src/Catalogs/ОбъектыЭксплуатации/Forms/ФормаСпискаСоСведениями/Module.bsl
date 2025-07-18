
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ИспользоватьУчет2_4 = ВнеоборотныеАктивы.ИспользуетсяУправлениеВНА_2_4();
							
	УстановитьТекстЗапросаСписок();
		
	УстановитьОтборы(ЭтотОбъект);
	
	НастроитьЗависимыеЭлементыФормы();
	
	ОбщегоНазначенияУТ.НастроитьПодключаемоеОборудование(ЭтаФорма);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ИнтеграцияС1СДокументооборотом
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	СохраненноеЗначение = Настройки.Получить("ПоказатьСведения");
	ПоказатьСведения = ?(ЗначениеЗаполнено(СохраненноеЗначение), СохраненноеЗначение, Истина);
	ЗаполнитьСвойстваЭлементовСведений();
	
	ОтборСостояние = Настройки.Получить("ОтборСостояние");
	ОтборОрганизация = Настройки.Получить("ОтборОрганизация");
	ОтборПодразделение = Настройки.Получить("ОтборПодразделение");
	ОтборМОЛ = Настройки.Получить("ОтборМОЛ");
	ОтборАмортизационнаяГруппа = Настройки.Получить("ОтборАмортизационнаяГруппа");
	ОтборТипОС = Настройки.Получить("ОтборТипОС");

	УстановитьОтборы(ЭтотОбъект);
	
	ЗаполнитьСведения(ЭтотОбъект);
		
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ЗаписьДокументаВЖурналОС" Тогда
		ПодключитьОбработчикОжидания("Подключаемый_ЗаполнитьСведения", 0.2, Истина);
	КонецЕсли;
	
	// ПодключаемоеОборудование
	Если Источник = "ПодключаемоеОборудование" И ВводДоступен() Тогда
		Если ИмяСобытия = "ScanData" И МенеджерОборудованияУТКлиент.ЕстьНеобработанноеСобытие() Тогда
			ОбработатьШтрихкоды(МенеджерОборудованияУТКлиент.ПреобразоватьДанныеСоСканераВСтруктуру(Параметр));
		КонецЕсли;
	КонецЕсли;
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	МенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПриОткрытииФормы(Неопределено, ЭтаФорма, "СканерШтрихкода");
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	МенеджерОборудованияКлиент.НачатьОтключениеОборудованиеПриЗакрытииФормы(Неопределено, ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтборСостояниеПриИзменении(Элемент)
	
	УстановитьОтборы(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияПриИзменении(Элемент)
	
	УстановитьОтборы(ЭтотОбъект);
		
	ЗаполнитьСведения(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборПодразделениеПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"Подразделение",
		ОтборПодразделение,
		ВидСравненияКомпоновкиДанных.Равно,,
		ЗначениеЗаполнено(ОтборПодразделение));
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборМОЛПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"МОЛ",
		ОтборМОЛ,
		ВидСравненияКомпоновкиДанных.Равно,,
		ЗначениеЗаполнено(ОтборМОЛ));
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборАмортизационнаяГруппаПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"АмортизационнаяГруппа",
		ОтборАмортизационнаяГруппа,
		ВидСравненияКомпоновкиДанных.Равно,,
		ЗначениеЗаполнено(ОтборАмортизационнаяГруппа));
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборТипОСПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"ТипОС",
		ОтборТипОС,
		ВидСравненияКомпоновкиДанных.Равно,,
		ЗначениеЗаполнено(ОтборТипОС));

КонецПроцедуры

&НаКлиенте
Процедура СведенияПринятКУчетуОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	Если СтрНайти(НавигационнаяСсылкаФорматированнойСтроки, "#Создать") <> 0 Тогда
		СтандартнаяОбработка = Ложь;
		ПараметрыФормы = Новый Структура("Основание", Элементы.Список.ТекущаяСтрока);
		ИмяФормыОткрытия = ПолучитьИмяФормыПринятияКУчету(ПараметрыФормы.Основание);
		ОткрытьФорму(ИмяФормыОткрытия, ПараметрыФормы);
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура СведенияМестонахождениеАдресОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	УправлениеКонтактнойИнформациейКлиент.ПоказатьАдресНаКарте(НавигационнаяСсылкаФорматированнойСтроки, "Яндекс.Карты");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// Из-за серверного вызова активизация строки выполняется два раза.
	Если ПредыдущаяТекущаяСтрока <> Элементы.Список.ТекущаяСтрока Тогда
		ПодключитьОбработчикОжидания("Подключаемый_ЗаполнитьСведения", 0.2, Истина);
	КонецЕсли;
	
	ПредыдущаяТекущаяСтрока = Элементы.Список.ТекущаяСтрока;
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписокУзловКомпонентовАмортизации

&НаКлиенте
Процедура СписокУзловКомпонентовАмортизацииВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)

	ТекущиеДанные = Элементы.СписокУзловКомпонентовАмортизации.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПоказатьЗначение(, ТекущиеДанные.УзелКомпонент);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Сведения(Команда)
	
	ПоказатьСведения = Не ПоказатьСведения;
	Элементы.ГруппаСведения.Видимость = ПоказатьСведения;
	
	Если ПоказатьСведения Тогда
		Элементы.КнопкаСведения.Заголовок = НСтр("ru = 'Скрыть сведения';
												|en = 'Hide information'");
		ПодключитьОбработчикОжидания("Подключаемый_ЗаполнитьСведения", 0.2, Истина);
	Иначе
		Элементы.КнопкаСведения.Заголовок = НСтр("ru = 'Показать сведения';
												|en = 'Show details'");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьГрупповоеОС(Команда)
	
	ДанныеОтбора = Новый Структура;
	ДанныеОтбора.Вставить("ТипОС", ПредопределенноеЗначение("Перечисление.ТипыОС.ГрупповоеОС"));
	
	ДанныеОснования = Новый Структура;
	ДанныеОснования.Вставить("Отбор", ДанныеОтбора);

	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Основание", ДанныеОтбора);
	
	ОткрытьФорму("Справочник.ОбъектыЭксплуатации.ФормаОбъекта", ПараметрыФормы);

КонецПроцедуры

&НаКлиенте
Процедура СоздатьОСУзел(Команда)
	
	ДанныеОтбора = Новый Структура;
	ДанныеОтбора.Вставить("ТипОС", ПредопределенноеЗначение("Перечисление.ТипыОС.Узел"));

	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Основание", ДанныеОтбора);
	
	ОткрытьФорму("Справочник.ОбъектыЭксплуатации.ФормаОбъекта", ПараметрыФормы);

КонецПроцедуры

&НаКлиенте
Процедура СоздатьКомпонентАмортизации(Команда)
	
	ДанныеОтбора = Новый Структура;
	ДанныеОтбора.Вставить("ТипОС", ПредопределенноеЗначение("Перечисление.ТипыОС.КомпонентАмортизации"));
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Основание", ДанныеОтбора);
	
	ОткрытьФорму("Справочник.ОбъектыЭксплуатации.ФормаОбъекта", ПараметрыФормы);

КонецПроцедуры

#Область СтандартныеПодсистемы

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Элементы.Список);
	// Конец ИнтеграцияС1СДокументооборотом
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура НастроитьЗависимыеЭлементыФормы()
	
	ВедетсяРегламентированныйУчетВНА = ВнеоборотныеАктивыСлужебный.ВедетсяРегламентированныйУчетВНА();
	
	Элементы.СтраницыСведения.ТекущаяСтраница = Элементы.СтраницаСведенияНеВыбраноОС;
	
	Если ИспользоватьУчет2_4 Тогда
		
		Если НЕ ВедетсяРегламентированныйУчетВНА Тогда
			Элементы.СписокСостояниеУпр.Заголовок = НСтр("ru = 'Состояние';
														|en = 'State'");
			Элементы.СписокСостояниеРегл.Видимость = Ложь;
			Элементы.СведенияГруппаОС.Видимость = Ложь;
			Элементы.СведенияКодПоОКОФ.Видимость = Ложь;
			Элементы.СведенияАмортизационнаяГруппа.Видимость = Ложь;
			Элементы.СведенияТаблицаСумм2_4Учет.Видимость = Ложь;
			Элементы.СписокДатаПринятияКУчетуУпр.Заголовок = НСтр("ru = 'Принято к учету';
																	|en = 'Recognized'");
			Элементы.СписокДатаПринятияКУчетуРегл.Видимость = Ложь;
		Иначе
			Элементы.СведенияОстаточнаяСтоимость.Видимость = Ложь;
			Элементы.СведенияНакопленнаяАмортизация.Видимость = Ложь;
			Элементы.СведенияВосстановительнаяСтоимость.Видимость = Ложь;
		КонецЕсли;
		
		Если НЕ ВедетсяРегламентированныйУчетВНА Тогда
			Элементы.СведенияТаблицаСумм2_4.Видимость = Ложь;
		КонецЕсли;
		
		Заголовок = НСтр("ru = 'Основные средства';
						|en = 'Fixed assets'");
	
	Иначе
		Элементы.СписокСостояниеРегл.Заголовок = НСтр("ru = 'Состояние';
														|en = 'State'");
		Элементы.СписокСостояниеУпр.Видимость = Ложь;
		Элементы.СписокДатаПринятияКУчетуРегл.Заголовок = НСтр("ru = 'Принято к учету';
																|en = 'Recognized'");
		Элементы.СписокДатаПринятияКУчетуУпр.Видимость = Ложь;
		Заголовок = НСтр("ru = 'ОС и объекты строительства';
						|en = 'FA and assets under construction'");
	КонецЕсли;
	
	ВнеоборотныеАктивыКлиентСервер.УстановитьВидимостьЗначенияСпискаВыбора(
		Элементы.ОтборСостояние.СписокВыбора,
		ВедетсяРегламентированныйУчетВНА,
		Перечисления.СостоянияОС.ПринятоКЗабалансовомуУчету);
	
	ПоказатьСведения = Ложь;
	ЗаполнитьСвойстваЭлементовСведений();
	
	Если НЕ ПравоДоступа("ИнтерактивноеДобавление", Метаданные.Справочники.ОбъектыЭксплуатации) Тогда
		Элементы.СписокСоздатьГрупповуюЕдиницуОС.Видимость = Ложь;
		Элементы.СоздатьОСУзел.Видимость = Ложь;
		Элементы.СоздатьКомпонентАмортизации.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьТекстЗапросаСписок()

	ТекстЗапроса = ОбъектыЭксплуатацииЛокализация.ТекстЗапросаФормыСписка();
	
	Если ТекстЗапроса = Неопределено Тогда
			
		ТекстЗапроса =
		"ВЫБРАТЬ
		|	СправочникОбъектыЭксплуатации.Ссылка,
		|	СправочникОбъектыЭксплуатации.ПометкаУдаления,
		|	СправочникОбъектыЭксплуатации.Родитель,
		|	СправочникОбъектыЭксплуатации.ЭтоГруппа,
		|	СправочникОбъектыЭксплуатации.Код,
		|	СправочникОбъектыЭксплуатации.ТипОС,
		|	СправочникОбъектыЭксплуатации.Наименование,
		|	СправочникОбъектыЭксплуатации.НаименованиеПолное,
		|	СправочникОбъектыЭксплуатации.Изготовитель,
		|	СправочникОбъектыЭксплуатации.ЗаводскойНомер,
		|	СправочникОбъектыЭксплуатации.НомерПаспорта,
		|	СправочникОбъектыЭксплуатации.ДатаВыпуска,
		|	NULL КАК КодПоОКОФ,
		|	NULL КАК ГруппаОС,
		|	NULL КАК АмортизационнаяГруппа,
		|	NULL КАК ШифрПоЕНАОФ,
		|	СправочникОбъектыЭксплуатации.Комментарий,
		|	СправочникОбъектыЭксплуатации.Расположение,
		|	СправочникОбъектыЭксплуатации.Модель,
		|	СправочникОбъектыЭксплуатации.СерийныйНомер,
		|	СправочникОбъектыЭксплуатации.ИнвентарныйНомер,
		|
		|	МестонахождениеОС.АдресМестонахождения КАК АдресМестонахождения,
		|
		|	ВЫБОР 
		|		КОГДА СправочникОбъектыЭксплуатации.ЭтоГруппа
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.СостоянияОС.ПустаяСсылка)
		|
		|		КОГДА &ОтборПоОрганизации
		|				И МестонахождениеОС.Арендатор = &ОтборОрганизация
		|				И НЕ ПорядокУчетаОСБУ.ОсновноеСредство ЕСТЬ NULL
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.СостоянияОС.ПринятоКЗабалансовомуУчету)
		|
		|		КОГДА &Состояние <> ЗНАЧЕНИЕ(Перечисление.СостоянияОС.ПустаяСсылка)
		|			ТОГДА
		|				ВЫБОР
		|					КОГДА &Состояние = ПорядокУчетаОСБУ.СостояниеБУ
		|						ТОГДА ПорядокУчетаОСБУ.СостояниеБУ
		|
		|					КОГДА &Состояние = ПорядокУчетаОСУУ.Состояние
		|						ТОГДА ПорядокУчетаОСУУ.Состояние
		|					ИНАЧЕ ЕСТЬNULL(ПорядокУчетаОСБУ.СостояниеБУ, ЕСТЬNULL(ПорядокУчетаОСУУ.Состояние, ЗНАЧЕНИЕ(Перечисление.СостоянияОС.НеПринятоКУчету)))
		|				КОНЕЦ
		|		ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.СостоянияОС.ПустаяСсылка)
		|
		|	КОНЕЦ КАК Состояние,
		|
		|	ВЫБОР 
		|		КОГДА СправочникОбъектыЭксплуатации.ЭтоГруппа
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.СостоянияОС.ПустаяСсылка)
		|		КОГДА &ОтборПоОрганизации 
		|				И МестонахождениеОС.Арендатор = &ОтборОрганизация
		|				И НЕ ПорядокУчетаОСБУ.ОсновноеСредство ЕСТЬ NULL
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.СостоянияОС.ПринятоКЗабалансовомуУчету)
		|		КОГДА ПорядокУчетаОСБУ.СостояниеБУ <> ЗНАЧЕНИЕ(Перечисление.СостоянияОС.ПустаяСсылка)
		|			ТОГДА ПорядокУчетаОСБУ.СостояниеБУ
		|		ИНАЧЕ ЕСТЬNULL(ПорядокУчетаОСБУ.СостояниеНУ, ЗНАЧЕНИЕ(Перечисление.СостоянияОС.НеПринятоКУчету))
		|	КОНЕЦ КАК СостояниеРегл,
		|
		|	ВЫБОР 
		|		КОГДА СправочникОбъектыЭксплуатации.ЭтоГруппа
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.СостоянияОС.ПустаяСсылка)
		|		КОГДА &ОтборПоОрганизации 
		|				И МестонахождениеОС.Арендатор = &ОтборОрганизация
		|				И НЕ ПорядокУчетаОСУУ.Состояние ЕСТЬ NULL
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.СостоянияОС.ПринятоКЗабалансовомуУчету)
		|		ИНАЧЕ ЕСТЬNULL(ПорядокУчетаОСУУ.Состояние, ЗНАЧЕНИЕ(Перечисление.СостоянияОС.НеПринятоКУчету)) 
		|	КОНЕЦ КАК СостояниеУпр,
		|
		|	ВЫБОР
		|		КОГДА &ОтборПоОрганизации И МестонахождениеОС.Арендатор = &ОтборОрганизация
		|			ТОГДА МестонахождениеОС.МОЛАрендатора
		|		ИНАЧЕ ЕСТЬNULL(МестонахождениеОС.МОЛ, ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка))
		|	КОНЕЦ КАК МОЛ,
		|
		|	ВЫБОР
		|		КОГДА &ОтборПоОрганизации И МестонахождениеОС.Арендатор = &ОтборОрганизация
		|			ТОГДА МестонахождениеОС.ПодразделениеАрендатора
		|		ИНАЧЕ ЕСТЬNULL(МестонахождениеОС.Местонахождение, ЗНАЧЕНИЕ(Справочник.СтруктураПредприятия.ПустаяСсылка))
		|	КОНЕЦ КАК Подразделение,
		|		
		|	ВЫБОР
		|		КОГДА &ОтборПоОрганизации И МестонахождениеОС.Арендатор = &ОтборОрганизация
		|			ТОГДА МестонахождениеОС.Арендатор
		|		ИНАЧЕ ЕСТЬNULL(МестонахождениеОС.Организация, ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)) 
		|	КОНЕЦ КАК Организация,
		|
		|	ДАТАВРЕМЯ(1, 1, 1) КАК ДатаПринятияКУчетуРегл,
		|	ЕСТЬNULL(ПервоначальныеСведенияОС.ДатаВводаВЭксплуатациюУУ, ДАТАВРЕМЯ(1, 1, 1)) КАК ДатаПринятияКУчетуУпр,
		|
		|	ВЫБОР
		|		КОГДА НаличиеФайлов.ЕстьФайлы ЕСТЬ NULL ТОГДА 0
		|		КОГДА НаличиеФайлов.ЕстьФайлы ТОГДА 1
		|		ИНАЧЕ 0
		|	КОНЕЦ КАК ЕстьФайлы
		|
		|{ВЫБРАТЬ
		|	АдресМестонахождения,
		|	МОЛ,
		|	Подразделение,		
		|	Организация,
		|	Состояние,
		|	СостояниеРегл,
		|	СостояниеУпр,
		|	ДатаПринятияКУчетуРегл,
		|	ДатаПринятияКУчетуУпр
		|}
		|
		|ИЗ
		|	Справочник.ОбъектыЭксплуатации КАК СправочникОбъектыЭксплуатации
		|
		|		{ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НаличиеФайлов КАК НаличиеФайлов
		|		ПО СправочникОбъектыЭксплуатации.Ссылка = НаличиеФайлов.ОбъектСФайлами}
		|
		|		{ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.МестонахождениеОС.СрезПоследних КАК МестонахождениеОС
		|		ПО (МестонахождениеОС.ОсновноеСредство = СправочникОбъектыЭксплуатации.Ссылка)}
		|		
		|		{ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПервоначальныеСведенияОС.СрезПоследних КАК ПервоначальныеСведенияОС
		|		ПО ПервоначальныеСведенияОС.ОсновноеСредство = МестонахождениеОС.ОсновноеСредство
		|			И ПервоначальныеСведенияОС.Организация = МестонахождениеОС.Организация}
		|
		|		{ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПорядокУчетаОСБУ.СрезПоследних КАК ПорядокУчетаОСБУ
		|		ПО (ПорядокУчетаОСБУ.ОсновноеСредство = МестонахождениеОС.ОсновноеСредство)
		|			И (ПорядокУчетаОСБУ.Организация = МестонахождениеОС.Организация)}
		|
		|		{ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПорядокУчетаОСУУ.СрезПоследних КАК ПорядокУчетаОСУУ
		|		ПО (ПорядокУчетаОСУУ.ОсновноеСредство = МестонахождениеОС.ОсновноеСредство)
		|			И (ПорядокУчетаОСУУ.Организация = МестонахождениеОС.Организация)}
		|
		|{ГДЕ
		|	ВЫБОР 
		|		КОГДА СправочникОбъектыЭксплуатации.ЭтоГруппа
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.СостоянияОС.ПустаяСсылка)
		|
		|		КОГДА &ОтборПоОрганизации
		|				И МестонахождениеОС.Арендатор = &ОтборОрганизация
		|				И НЕ ПорядокУчетаОСБУ.ОсновноеСредство ЕСТЬ NULL
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.СостоянияОС.ПринятоКЗабалансовомуУчету)
		|
		|		КОГДА &Состояние <> ЗНАЧЕНИЕ(Перечисление.СостоянияОС.ПустаяСсылка)
		|			ТОГДА
		|				ВЫБОР
		|					КОГДА &Состояние = ПорядокУчетаОСБУ.СостояниеБУ
		|						ТОГДА ПорядокУчетаОСБУ.СостояниеБУ
		|
		|					КОГДА &Состояние = ПорядокУчетаОСУУ.Состояние
		|						ТОГДА ПорядокУчетаОСУУ.Состояние
		|					ИНАЧЕ ЕСТЬNULL(ПорядокУчетаОСБУ.СостояниеБУ, ЕСТЬNULL(ПорядокУчетаОСУУ.Состояние, ЗНАЧЕНИЕ(Перечисление.СостоянияОС.НеПринятоКУчету)))
		|				КОНЕЦ
		|		ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.СостоянияОС.ПустаяСсылка)
		|
		|	КОНЕЦ КАК Состояние,
		|
		|	ВЫБОР
		|		КОГДА &ОтборПоОрганизации И МестонахождениеОС.Арендатор = &ОтборОрганизация
		|			ТОГДА МестонахождениеОС.МОЛАрендатора
		|		ИНАЧЕ ЕСТЬNULL(МестонахождениеОС.МОЛ, ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка))
		|	КОНЕЦ КАК МОЛ,
		|
		|	ВЫБОР
		|		КОГДА &ОтборПоОрганизации И МестонахождениеОС.Арендатор = &ОтборОрганизация
		|			ТОГДА МестонахождениеОС.ПодразделениеАрендатора
		|		ИНАЧЕ ЕСТЬNULL(МестонахождениеОС.Местонахождение, ЗНАЧЕНИЕ(Справочник.СтруктураПредприятия.ПустаяСсылка))
		|	КОНЕЦ КАК Подразделение,
		|		
		|	ВЫБОР
		|		КОГДА &ОтборПоОрганизации И МестонахождениеОС.Арендатор = &ОтборОрганизация
		|			ТОГДА МестонахождениеОС.Арендатор
		|		ИНАЧЕ ЕСТЬNULL(МестонахождениеОС.Организация, ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)) 
		|	КОНЕЦ КАК Организация
		|
		|}";		
			
	КонецЕсли; 
	
	СвойстваСписка = ОбщегоНазначения.СтруктураСвойствДинамическогоСписка();
	СвойстваСписка.ТекстЗапроса = ТекстЗапроса;
	ОбщегоНазначения.УстановитьСвойстваДинамическогоСписка(Элементы.Список, СвойстваСписка);

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСвойстваЭлементовСведений()
	
	Элементы.ГруппаСведения.Видимость = ПоказатьСведения;
	Если ПоказатьСведения Тогда
		Элементы.КнопкаСведения.Заголовок = НСтр("ru = 'Скрыть сведения';
												|en = 'Hide information'");
	Иначе
		Элементы.КнопкаСведения.Заголовок = НСтр("ru = 'Показать сведения';
												|en = 'Show details'");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	//
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СведенияТаблицаСуммСуммаБУ1.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СведенияТаблицаСумм.Представление");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'БУ';
																|en = 'AC'"));
	
	//
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СведенияТаблицаСуммСуммаНУ1.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СведенияТаблицаСумм.Представление");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'НУ';
																|en = 'TA'"));
	
	//
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СведенияТаблицаСуммСуммаПР1.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СведенияТаблицаСумм.Представление");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'ПР';
																|en = 'PD'"));
	
	//
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СведенияТаблицаСуммСуммаВР1.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СведенияТаблицаСумм.Представление");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'ВР';
																|en = 'TD'"));
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ЗаполнитьСведения()

	ОценкаПроизводительностиКлиент.ЗамерВремени(
		"Справочник.ОбъектыЭксплуатации.Форма.ФормаСпискаСоСведениями.Команда.Сведения");
		
	ЗаполнитьСведения(ЭтотОбъект);

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ЗаполнитьСведения(Форма)
	
	Если НЕ Форма.ПоказатьСведения Тогда
		Возврат;
	КонецЕсли;
	
	Элементы = Форма.Элементы;
	
	ТекущаяСтрока = Элементы.Список.ТекущаяСтрока;
	ТекущиеДанные = Неопределено;
	Если ТекущаяСтрока <> Неопределено Тогда
		ТекущиеДанные = Элементы.Список.ДанныеСтроки(ТекущаяСтрока);
		Если ТекущиеДанные <> Неопределено И ТекущиеДанные.ЭтоГруппа Тогда
			ТекущиеДанные = Неопределено;
		КонецЕсли;
	КонецЕсли;
	
	Если ТекущиеДанные = Неопределено Тогда
		Элементы.СтраницыСведения.ТекущаяСтраница = Элементы.СтраницаСведенияНеВыбраноОС;
		Возврат;
	КонецЕсли;
	
	Если Форма.ИспользоватьУчет2_4 Тогда
		
		Элементы.СтраницыСведения.ТекущаяСтраница = Элементы.СтраницаСведения2_4;
		
		Форма.СведенияТаблицаСумм2_4.Очистить();
		ПредставлениеСведений = Неопределено;
		
		ТекущаяСтрока = Форма.Элементы.Список.ТекущаяСтрока;
		Сведения2_4 = ПолучитьСведения2_4(ТекущиеДанные.Ссылка, Форма.ОтборОрганизация);
	
		Для Каждого ЭлМассива Из Сведения2_4.Суммы Цикл
			ЗаполнитьЗначенияСвойств(Форма.СведенияТаблицаСумм2_4.Добавить(), ЭлМассива);
		КонецЦикла;
		
		Элементы.СписокУзловКомпонентовАмортизации.Видимость = 
			(ТекущиеДанные.ТипОС = ПредопределенноеЗначение("Перечисление.ТипыОС.ОбъектЭксплуатации")
			Или ТекущиеДанные.ТипОС = ПредопределенноеЗначение("Перечисление.ТипыОС.ГрупповоеОС"));
		
		Форма.СписокУзловКомпонентовАмортизации.Очистить();
		Для Каждого СтрокаУзлаКомпонента Из Сведения2_4.СуммыУзловКомпонентов Цикл
			ЗаполнитьЗначенияСвойств(Форма.СписокУзловКомпонентовАмортизации.Добавить(), СтрокаУзлаКомпонента);
		КонецЦикла;
		
		Форма.Элементы.СписокУзловКомпонентовАмортизацииОстаточнаяСтоимостьРегл.Видимость =
			Сведения2_4.ПараметрыЗаголовковУзловКомпонентов.ОтображатьРегл;
		
		Если Сведения2_4.ПараметрыЗаголовковУзловКомпонентов.ОтображатьРегл Тогда
			
			ВалютаРегл = Строка(Сведения2_4.ПараметрыЗаголовковУзловКомпонентов.ВалютаРегл);
			Форма.Элементы.СписокУзловКомпонентовАмортизацииОстаточнаяСтоимостьРегл.Заголовок =
				СтрШаблон(НСтр("ru = 'Остаточная стоимость (%1)';
								|en = 'Net book value (%1)'"), ВалютаРегл);
			
		КонецЕсли;
		
		ВалютаУпр = Строка(Сведения2_4.ПараметрыЗаголовковУзловКомпонентов.ВалютаУпр);
		Форма.Элементы.СписокУзловКомпонентовАмортизацииОстаточнаяСтоимость.Заголовок =
			СтрШаблон(НСтр("ru = 'Остаточная стоимость (%1)';
							|en = 'Net book value (%1)'"), ВалютаУпр);
		
		ПредставлениеСведений = Сведения2_4.ПредставлениеСведений;
		Если ПредставлениеСведений <> Неопределено Тогда
			
			Элементы.ОбщаяКомандаДокументыПоОсновномуСредству.Видимость = ПредставлениеСведений.Период <> '000101010000';
			
			ВнеоборотныеАктивыКлиентСервер.ЗаполнитьСведенияЭлемента(
				Элементы.СведенияПринятКУчету1, ПредставлениеСведений.СведенияПринятКУчету1);
				
			ВнеоборотныеАктивыКлиентСервер.ЗаполнитьСведенияЭлемента(
				Элементы.СведенияПринятКУчету3, ПредставлениеСведений.СведенияПринятКУчету3);
				
			ВнеоборотныеАктивыКлиентСервер.ЗаполнитьСведенияЭлемента(
				Элементы.СведенияМестонахождениеОрганизация, ПредставлениеСведений.СведенияМестонахождениеОрганизация);
				
			ВнеоборотныеАктивыКлиентСервер.ЗаполнитьСведенияЭлемента(
				Элементы.СведенияМестонахождениеПодразделение, ПредставлениеСведений.СведенияМестонахождениеПодразделение);
				
			ВнеоборотныеАктивыКлиентСервер.ЗаполнитьСведенияЭлемента(
				Элементы.СведенияМестонахождениеМОЛ, ПредставлениеСведений.СведенияМестонахождениеМОЛ);
				
			ВнеоборотныеАктивыКлиентСервер.ЗаполнитьСведенияЭлемента(
				Элементы.СведенияМестонахождениеАдрес, ПредставлениеСведений.СведенияМестонахождениеАдрес);
				
			ВнеоборотныеАктивыКлиентСервер.ЗаполнитьСведенияЭлемента(
				Элементы.СведенияСрокИспользования1, ПредставлениеСведений.СведенияСрокИспользования1);
				
			ВнеоборотныеАктивыКлиентСервер.ЗаполнитьСведенияЭлемента(
				Элементы.СведенияСрокИспользования3, ПредставлениеСведений.СведенияСрокИспользования3);
				
			ВнеоборотныеАктивыКлиентСервер.ЗаполнитьСведенияЭлемента(
				Элементы.СведенияДоговор, ПредставлениеСведений.СведенияДоговор);
				
			ВнеоборотныеАктивыКлиентСервер.ЗаполнитьСведенияЭлемента(
				Элементы.СведенияВосстановительнаяСтоимость, ПредставлениеСведений.СведенияВосстановительнаяСтоимость);
				
			ВнеоборотныеАктивыКлиентСервер.ЗаполнитьСведенияЭлемента(
				Элементы.СведенияНакопленнаяАмортизация, ПредставлениеСведений.СведенияНакопленнаяАмортизация);
				
			ВнеоборотныеАктивыКлиентСервер.ЗаполнитьСведенияЭлемента(
				Элементы.СведенияОбесценение, ПредставлениеСведений.СведенияОбесценение);
				
			ВнеоборотныеАктивыКлиентСервер.ЗаполнитьСведенияЭлемента(
				Элементы.СведенияОстаточнаяСтоимость, ПредставлениеСведений.СведенияОстаточнаяСтоимость);
			
			ВнеоборотныеАктивыКлиентСервер.ЗаполнитьСведенияЭлемента(
				Элементы.СведенияЛиквидационнаяСтоимостьРегл, ПредставлениеСведений.СведенияЛиквидационнаяСтоимостьРегл);
				
			ВнеоборотныеАктивыКлиентСервер.ЗаполнитьСведенияЭлемента(
				Элементы.СведенияЛиквидационнаяСтоимость, ПредставлениеСведений.СведенияЛиквидационнаяСтоимость);
				
		Иначе
			
			Элементы.ОбщаяКомандаДокументыПоОсновномуСредству.Видимость = Ложь;
			Элементы.СведенияПринятКУчету1.Видимость = Ложь;
			Элементы.СведенияПринятКУчету3.Видимость = Ложь;
			Элементы.СведенияМестонахождениеОрганизация.Видимость = Ложь;
			Элементы.СведенияМестонахождениеПодразделение.Видимость = Ложь;
			Элементы.СведенияМестонахождениеМОЛ.Видимость = Ложь;
			Элементы.СведенияМестонахождениеАдрес.Видимость = Ложь;
			Элементы.СведенияСрокИспользования1.Видимость = Ложь;
			Элементы.СведенияСрокИспользования2.Видимость = Ложь;
			Элементы.СведенияДоговор.Видимость = Ложь;
			Элементы.СведенияВосстановительнаяСтоимость.Видимость = Ложь;
			Элементы.СведенияНакопленнаяАмортизация.Видимость = Ложь;
			Элементы.СведенияОбесценение.Видимость = Ложь;
			Элементы.СведенияОстаточнаяСтоимость.Видимость = Ложь;
			Элементы.СведенияЛиквидационнаяСтоимостьРегл.Видимость = Ложь;
			Элементы.СведенияЛиквидационнаяСтоимость.Видимость = Ложь;
			
		КонецЕсли; 
		
		Элементы.СведенияПринятКУчету2.Видимость = Ложь;
		Элементы.СведенияГруппаОС.Видимость = Ложь;
		Элементы.СведенияКодПоОКОФ.Видимость = Ложь;
		Элементы.СведенияАмортизационнаяГруппа.Видимость = Ложь;
		Элементы.СведенияСрокИспользования2.Видимость = Ложь;
		Элементы.СведенияСрокИспользования3.Видимость = Ложь;
		
	Иначе
		
		Сведения2_2 = ПолучитьСведения2_2(Элементы.Список.ТекущаяСтрока, Форма.ОтборОрганизация);
		
	КонецЕсли;
	
	ВнеоборотныеАктивыКлиентСерверЛокализация.ЗаполнитьСведенияВФормеСпискаОС(Форма, Сведения2_4, Сведения2_2);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьСведения2_2(Знач ВнеоборотныйАктив, Знач ОтборОрганизация)
	
	Сведения2_2 = ОбъектыЭксплуатацииЛокализация.ПолучитьСведения2_2(ВнеоборотныйАктив, ОтборОрганизация);
	
	Возврат Сведения2_2;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьСведения2_4(Знач ВнеоборотныйАктив, Знач ОтборОрганизация)

	СведенияОбУчете = Справочники.ОбъектыЭксплуатации.СведенияОбУчете(ВнеоборотныйАктив, ОтборОрганизация);
	СтоимостьИАмортизация = ВнеоборотныеАктивы.СтоимостьИАмортизацияОС(ВнеоборотныйАктив);
	СтоимостьИАмортизацияУзловКомпонентов = ВнеоборотныеАктивы.СтоимостьИАмортизацияУзловКомпонентов(ВнеоборотныйАктив);

	МассивСумм = Новый Массив;
	
	ВалютаУпр  = Константы.ВалютаУправленческогоУчета.Получить();
	Если СведенияОбУчете = Неопределено Тогда
		ВалютаРегл = ЗначениеНастроекПовтИсп.БазоваяВалютаПоУмолчанию();
	Иначе
		ВалютаРегл = ЗначениеНастроекПовтИсп.ВалютаРегламентированногоУчетаОрганизации(СведенияОбУчете.Организация);
	КонецЕсли;
	
	Сведения2_4 = Новый Структура;
	ПараметрыЗаголовковУзловКомпонентов = Новый Структура("ВалютаУпр, ВалютаРегл, ОтображатьРегл",
		ВалютаУпр, ВалютаРегл, ВалютаУпр <> ВалютаРегл);
	
	ОбъектыЭксплуатацииЛокализация.ДополнитьСведения2_4(
		ВнеоборотныйАктив, СведенияОбУчете, СтоимостьИАмортизация, МассивСумм, Сведения2_4);
		
	Если НЕ ВнеоборотныеАктивыСлужебный.ВедетсяРегламентированныйУчетВНА()
		И ВалютаУпр <> ВалютаРегл Тогда
	
		// БУ
		ДанныеУчета = Новый Структура;
		ДанныеУчета.Вставить("Учет", "БУ");
		ДанныеУчета.Вставить("Валюта", ВалютаРегл);
		ДанныеУчета.Вставить("ВосстановительнаяСтоимость", СтоимостьИАмортизация.СтоимостьРегл);
		ДанныеУчета.Вставить("НакопленнаяАмортизация", СтоимостьИАмортизация.АмортизацияРегл);
		ДанныеУчета.Вставить("Обесценение", СтоимостьИАмортизация.ОбесценениеРегл);
		ДанныеУчета.Вставить("ОстаточнаяСтоимость", СтоимостьИАмортизация.СтоимостьРегл - СтоимостьИАмортизация.АмортизацияРегл - СтоимостьИАмортизация.ОбесценениеРегл);
		МассивСумм.Добавить(ДанныеУчета);
		
	КонецЕсли; 
	
	// УУ
	Если СведенияОбУчете = Неопределено
		ИЛИ СведенияОбУчете.СостояниеБУ <> Перечисления.СостоянияОС.ПринятоКЗабалансовомуУчету Тогда
		ДанныеУчета = Новый Структура;
		ДанныеУчета.Вставить("Учет", "УУ");
		ДанныеУчета.Вставить("Валюта", ВалютаУпр);
		ДанныеУчета.Вставить("ВосстановительнаяСтоимость", СтоимостьИАмортизация.Стоимость);
		ДанныеУчета.Вставить("НакопленнаяАмортизация", СтоимостьИАмортизация.Амортизация);
		ДанныеУчета.Вставить("Обесценение", СтоимостьИАмортизация.ОбесценениеУпр);
		ДанныеУчета.Вставить("ОстаточнаяСтоимость", СтоимостьИАмортизация.Стоимость - СтоимостьИАмортизация.Амортизация - СтоимостьИАмортизация.ОбесценениеУпр);
		МассивСумм.Добавить(ДанныеУчета);
	КонецЕсли; 
	
	ПредставлениеСведений = Справочники.ОбъектыЭксплуатации.ПредставлениеСведенийОбУчете(СведенияОбУчете, СтоимостьИАмортизация, Ложь);
	
	СуммыУзловКомпонентов = ОбщегоНазначения.ТаблицаЗначенийВМассив(СтоимостьИАмортизацияУзловКомпонентов);
	
	Сведения2_4.Вставить("ПредставлениеСведений", ПредставлениеСведений);
	Сведения2_4.Вставить("Суммы", МассивСумм);
	Сведения2_4.Вставить("СуммыУзловКомпонентов", СуммыУзловКомпонентов);
	Сведения2_4.Вставить("ПараметрыЗаголовковУзловКомпонентов", ПараметрыЗаголовковУзловКомпонентов);
	
	Возврат Сведения2_4;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтборы(Форма)
	
	Список = Форма.Список;
	
	Список.Параметры.УстановитьЗначениеПараметра("ОтборПоОрганизации", ЗначениеЗаполнено(Форма.ОтборОрганизация));
	Список.Параметры.УстановитьЗначениеПараметра("ОтборОрганизация", Форма.ОтборОрганизация);
	Список.Параметры.УстановитьЗначениеПараметра("Состояние", Форма.ОтборСостояние);
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"Состояние",
		Форма.ОтборСостояние,
		ВидСравненияКомпоновкиДанных.Равно,,
		ЗначениеЗаполнено(Форма.ОтборСостояние));
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"Организация",
		Форма.ОтборОрганизация,
		ВидСравненияКомпоновкиДанных.Равно,,
		ЗначениеЗаполнено(Форма.ОтборОрганизация));
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"Подразделение",
		Форма.ОтборПодразделение,
		ВидСравненияКомпоновкиДанных.Равно,,
		ЗначениеЗаполнено(Форма.ОтборПодразделение));
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"МОЛ",
		Форма.ОтборМОЛ,
		ВидСравненияКомпоновкиДанных.Равно,,
		ЗначениеЗаполнено(Форма.ОтборМОЛ));
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"ТипОС",
		Форма.ОтборТипОС,
		ВидСравненияКомпоновкиДанных.Равно,,
		ЗначениеЗаполнено(Форма.ОтборТипОС));
	
	ВнеоборотныеАктивыКлиентСерверЛокализация.УстановитьОтборыВФормеСпискаОС(Форма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьШтрихкоды(Данные)
	
	МассивСсылок = СсылкаНаЭлементСпискаПоШтрихкоду(Данные.Штрихкод);
	Если МассивСсылок.Количество() > 0 Тогда
		Элементы.Список.ТекущаяСтрока = МассивСсылок[0];
		ПоказатьЗначение(Неопределено, МассивСсылок[0]);
	Иначе
		ШтрихкодированиеПечатныхФормКлиент.ОбъектНеНайден(Данные.Штрихкод);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция СсылкаНаЭлементСпискаПоШтрихкоду(Штрихкод)
	
	Менеджеры = Новый Массив();
	Менеджеры.Добавить(ПредопределенноеЗначение("Справочник.ОбъектыЭксплуатации.ПустаяСсылка"));
	Возврат ШтрихкодированиеПечатныхФормКлиент.ПолучитьСсылкуПоШтрихкодуТабличногоДокумента(Штрихкод, Менеджеры);
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьИмяФормыПринятияКУчету(ОсновноеСредство)

	ТипОС = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ОсновноеСредство, "ТипОС");
	Если ТипОС = Перечисления.ТипыОС.КомпонентАмортизации
		Или ТипОС = Перечисления.ТипыОС.Узел Тогда
		
		Возврат "Документ.ПринятиеКУчетуУзловКомпонентовАмортизации.ФормаОбъекта";
	Иначе
		Возврат "Документ.ПринятиеКУчетуОС2_4.ФормаОбъекта";
	КонецЕсли;

КонецФункции

#КонецОбласти