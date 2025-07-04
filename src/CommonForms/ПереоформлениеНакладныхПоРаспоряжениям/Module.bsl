#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	// Возврат при получении формы для анализа.
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	НастроитьФормуПриСоздании();
	ЗаполнитьРеквизитыФормыПриСоздании();
	
	ОперацииРаздельнойЗакупки = ЗакупкиСервер.ХозяйственныеОперацииРаздельнойЗакупкиБезОтборов();
	
	Если ЗначениеЗаполнено(ХозяйственнаяОперация)
		И ОперацииРаздельнойЗакупки.Найти(ХозяйственнаяОперация) <> Неопределено Тогда
		
		Если ЭтоДокументПоступлениеТоваров Тогда
			НадписьИнфоЗаголовок = НСтр("ru = 'По выбранным распоряжениям уже оформлены поступления. Необходимо скорректировать имеющиеся поступления с учетом ордера командой ""Перезаполнить выбранное"" или оформить новое поступление на оставшиеся неоформленными товары командой ""Оформить новое"".';
										|en = 'Incoming payments are already registered for the selected references. Adjust the incoming payments considering the note by clicking ""Refill selected one"", or register a new incoming payment for the remaining unregistered goods by clicking ""Register new one"".'");
			
			ПерезаполнитьЗаголовок = НСтр("ru = 'Перезаполнить выбранное';
											|en = 'Refill selected one'");
			ОформитьНовуюЗаголовок = НСтр("ru = 'Оформить новое';
											|en = 'Register new one'");
			
			ТоварыНакладнойЗаголовок	= НСтр("ru = 'Расхождения между поступлениями и ордерами';
												|en = 'Discrepancies between incoming payments and notes'");
			НакладнаяЗаголовок			= НСтр("ru = 'Поступление';
												|en = 'Receipt'");
			
			ОформленныеНакладныеЗаголовок = НСтр("ru = 'Поступления';
												|en = 'Receipts'");
		Иначе
			НадписьИнфоЗаголовок = НСтр("ru = 'По выбранным распоряжениям уже оформлены накладные. Необходимо скорректировать имеющиеся накладные с учетом поступления командой ""Перезаполнить выбранную"" или оформить новую накладную на оставшиеся неоформленными товары командой ""Оформить новую"".';
										|en = 'Invoices are already registered for the selected references. Adjust the invoices considering the goods receipt by clicking ""Refill selected one"", or register a new invoice for the remaining unregistered goods by clicking ""Register new one"".'");
			
			ПерезаполнитьЗаголовок = НСтр("ru = 'Перезаполнить выбранную';
											|en = 'Refill selected one'");
			ОформитьНовуюЗаголовок = НСтр("ru = 'Оформить новую';
											|en = 'Register new one'");
			
			ТоварыНакладнойЗаголовок	= НСтр("ru = 'Расхождения между накладными и поступлениями';
												|en = 'There are discrepancies between invoices and receipts'");
			НакладнаяЗаголовок			= НСтр("ru = 'Накладная';
												|en = 'Invoice'");
			
			ОформленныеНакладныеЗаголовок = НСтр("ru = 'Накладные';
												|en = 'Invoices'");
		КонецЕсли;
		
		Элементы.НадписьИнфо.Заголовок = НадписьИнфоЗаголовок;
		
		Элементы.Перезаполнить.Заголовок = ПерезаполнитьЗаголовок;
		Элементы.ОформитьНовую.Заголовок = ОформитьНовуюЗаголовок;
		
		Элементы.ТоварыНакладной.Заголовок	= ТоварыНакладнойЗаголовок;
		Элементы.Накладная.Заголовок		= НакладнаяЗаголовок;
		
		Элементы.ОформленныеНакладные.Заголовок = ОформленныеНакладныеЗаголовок;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапки

&НаКлиенте
Процедура НадписьЗаголовокЗаказыНажатие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ОткрытьФорму(
		"ОбщаяФорма.ПросмотрСпискаДокументов",
		Новый Структура("СписокДокументов, Заголовок",
			СписокЗаказов,
			НСтр("ru = 'Распоряжения (%КоличествоДокументов%)';
				|en = 'References (%КоличествоДокументов%)'")
		),
		ЭтаФорма,,,, Неопределено, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры

&НаКлиенте
Процедура СтандартныйПериодПриИзменении(Элемент)
	СтандартныйПериодПриИзмененииСервер();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыОформленныеНакладные

&НаКлиенте
Процедура ОформленныеНакладныеВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ДанныеНакладная = Элементы.ОформленныеНакладные.ТекущиеДанные;
	ПоказатьЗначение(, ДанныеНакладная.Накладная);
	
КонецПроцедуры

&НаКлиенте
Процедура ОформленныеНакладныеПриАктивизацииСтроки(Элемент)
	
	ПодключитьОбработчикОжидания("ЗаполнитьТаблицуТоварыНакладнойОтложенно", 0.2, Истина);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Перезаполнить(Команда)
	
	ТекущиеДанные = Элементы.ОформленныеНакладные.ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено Тогда
		
		ЗначенияЗаполнения = Новый Структура(
			"ЗаполнятьПоОрдеру, МассивЗаказов, ОтборПоТоварам", Истина, СписокЗаказов.ВыгрузитьЗначения());
		
		Параметры.РеквизитыШапки.Свойство("ОтборПоТоварам", ЗначенияЗаполнения.ОтборПоТоварам);
		
		ПараметрыФормы = Новый Структура(
			"Ключ, ЗначенияЗаполнения", ТекущиеДанные.Накладная, ЗначенияЗаполнения);
		
		ОткрытьФорму(ИмяФормыНакладной, ПараметрыФормы);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОформитьНовую(Команда)
	
	ТекущиеДанные =Элементы.ОформленныеНакладные.ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено Тогда
		
		Если ТоварыНакладной.Итог("Увеличить") <= 0 Тогда
			
			ТекстПредупреждения = НСтр("ru = 'Нет положительных расхождений. Оформление новой накладной не предусмотрено.';
										|en = 'No positive discrepancies. Cannot register a new invoice.'");
			ПоказатьПредупреждение(, ТекстПредупреждения);
			Возврат;
			
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(ДанныеЗаполнения) Тогда
			МассивЗаказов = СписокЗаказов.ВыгрузитьЗначения();
			
			// Создание накладной по выделенным заказам.
			ДанныеЗаполнения = Новый Структура("МассивЗаказов, ЗаполнятьПоОрдеру, РеквизитыШапки",
				МассивЗаказов, Истина, Параметры.РеквизитыШапки);
			
			// Специфика передачи параметров для заполнения реализации товаров.
			ВариантОформленияПродажи = ПредопределенноеЗначение("Перечисление.ВариантыОформленияПродажи.РеализацияТоваровУслуг");
			ДанныеЗаполнения.Вставить("ВариантОформленияПродажи", ВариантОформленияПродажи);
			ДанныеЗаполнения.Вставить("ЗаполнятьПоОстаткам",      Истина);
			ДанныеЗаполнения.Вставить("ДокументОснование",        МассивЗаказов);
			ДанныеЗаполнения.Вставить("СкладОтгрузки",            Склад);
			ДанныеЗаполнения.Вставить("СкладПоступления",         Склад);
			ДанныеЗаполнения.Вставить("ПараметрыОформления",      Новый Структура("ПоЗаказам, ПоОрдерам", Ложь, Истина));
		Иначе
			ДанныеЗаполнения = ДанныеЗаполнения;
		КонецЕсли;
		ОткрытьФорму(ИмяФормыНакладной, Новый Структура("Основание", ДанныеЗаполнения));
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура НастроитьФормуПриСоздании()
	
	НастройкиФормыПереоформления = НакладныеСервер.НастройкиФормыПереоформленияНакладных();
	ЗаполнитьЗначенияСвойств(НастройкиФормыПереоформления, Параметры.НастройкиФормы);
	
	ДанныеЗаполнения = НастройкиФормыПереоформления.ДанныеЗаполнения;
	
	ИмяФормыНакладной = НастройкиФормыПереоформления.ИмяФормыНакладной;
	ЗаголовокФормы = НастройкиФормыПереоформления.Заголовок;
	НакладнаяНаОтгрузку = НастройкиФормыПереоформления.НакладнаяНаОтгрузку;
	НакладнаяНаПриемку = НастройкиФормыПереоформления.НакладнаяНаПриемку;
	ЭтоДокументПоступлениеТоваров = НастройкиФормыПереоформления.ЭтоДокументПоступлениеТоваров;
	
	ОсновнаяНоменклатура = НастройкиФормыПереоформления.ОсновнойТовар.Ключ.Номенклатура;
	ОсновнаяХарактеристика = НастройкиФормыПереоформления.ОсновнойТовар.Ключ.Характеристика;
	
	КартинкаШапки = НастройкиФормыПереоформления.ОсновнойТовар.КартинкаШапки;
	КартинкаЗначений = НастройкиФормыПереоформления.ОсновнойТовар.КартинкаЗначений;	
	
	Если ЗаголовокФормы <> Неопределено Тогда
		Автозаголовок = Ложь;
		Заголовок = ЗаголовокФормы;
	КонецЕсли;
	
	Заказ = Параметры.Заказы.Получить(0);
	Если Параметры.Заказы.Количество() = 1 Тогда
		Элементы.СтраницыРаспоряжения.ТекущаяСтраница = Элементы.СтраницаЗаказ;
	Иначе
		НадписьЗаголовокЗаказы = НСтр("ru = 'Всего распоряжений';
										|en = 'Total references'") + ": " + Параметры.Заказы.Количество();
		Элементы.СтраницыРаспоряжения.ТекущаяСтраница = Элементы.СтраницаЗаказы;
	КонецЕсли;
	Элементы.ЗаказТаблица.Видимость = Параметры.Заказы.Количество() > 1;
	Элементы.ОсновнойТовар.Видимость        = ОсновнаяНоменклатура <> Неопределено;
	Элементы.ОсновнойТовар.КартинкаШапки    = КартинкаШапки;
	Элементы.ОсновнойТовар.КартинкаЗначений = КартинкаЗначений;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьРеквизитыФормыПриСоздании()
	
	СкладИзШапки = Справочники.Склады.ПустаяСсылка();
	Параметры.РеквизитыШапки.Свойство("Склад", СкладИзШапки);
	
	Склад = ?(ЗначениеЗаполнено(Параметры.Склад),Параметры.Склад, СкладИзШапки);
	Склады.ЗагрузитьЗначения(СкладИлиГруппа(Склад));
	Параметры.РеквизитыШапки.Свойство("ХозяйственнаяОперация", ХозяйственнаяОперация);
	СписокЗаказов.ЗагрузитьЗначения(Параметры.Заказы);
	ТаблицаНакладных = НакладныеПоЗаказам(Параметры.Заказы);
	ОформленныеНакладные.Загрузить(ТаблицаНакладных);
	
КонецПроцедуры

&НаСервере
Функция СкладИлиГруппа(Склад)
	
	Если ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Склад, "ЭтоГруппа") = Истина Тогда
		
		Запрос = Новый Запрос();
		Запрос.Текст =
			"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
			|	СпрСклады.Ссылка КАК Ссылка
			|ИЗ
			|	Справочник.Склады КАК СпрСклады
			|ГДЕ
			|	НЕ СпрСклады.ПометкаУдаления
			|	И СпрСклады.Ссылка В ИЕРАРХИИ (&Склад)";
		Запрос.УстановитьПараметр("Склад", Склад);
		Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
		
	Иначе
		
		МассивСкладов = Новый Массив();
		МассивСкладов.Добавить(Склад);
		Возврат МассивСкладов;
		
	КонецЕсли;
	
КонецФункции

#Область Заполнение

&НаСервере
Процедура ЗаполнитьТаблицуТоварыНакладной(Накладная)
	
	ТребуемыеТовары		= Неопределено;
	Распоряжения		= СписокЗаказов.ВыгрузитьЗначения();
	НастройкиОтборов	= ПолучитьНастройкиОтборов(Параметры.РеквизитыШапки);
	
	Если Параметры.РеквизитыШапки.Свойство("ТребуемыеТовары") Тогда
		ТребуемыеТовары = ПолучитьИзВременногоХранилища(Параметры.РеквизитыШапки.ТребуемыеТовары);
	КонецЕсли;
	
	ЕстьОтборПоСкладу			= ЗначениеЗаполнено(Склад);
	ЕстьОтборПоТоварам			= ЗначениеЗаполнено(ТребуемыеТовары);
	ЕстьОтборПоТоварамЗаказа	= НастройкиОтборов <> Неопределено;
	
	Запрос = Новый Запрос();
	Запрос.Текст = ТекстЗапросаТоваровНакладной(ЕстьОтборПоСкладу, ЕстьОтборПоТоварам, ЕстьОтборПоТоварамЗаказа);
	
	Запрос.УстановитьПараметр("МассивЗаказов",			Распоряжения);
	Запрос.УстановитьПараметр("Накладная",				Накладная);
	Запрос.УстановитьПараметр("ХозяйственнаяОперация",	ХозяйственнаяОперация);
	Запрос.УстановитьПараметр("Склад",					Склады.ВыгрузитьЗначения());
	Запрос.УстановитьПараметр("ТоварыПоЗаказам",		?(НастройкиОтборов = Неопределено,
															Неопределено,
															НастройкиОтборов.ТаблицаОтборов));
	Запрос.УстановитьПараметр("НакладнаяНаПриемку",		НакладнаяНаПриемку);
	Запрос.УстановитьПараметр("НакладнаяНаОтгрузку",	НакладнаяНаОтгрузку);
	Запрос.УстановитьПараметр("ТребуемыеТовары",		ТребуемыеТовары);
	Запрос.УстановитьПараметр("ОсновнаяНоменклатура",	ОсновнаяНоменклатура);
	Запрос.УстановитьПараметр("ОсновнаяХарактеристика",	ОсновнаяХарактеристика);
	
	Если ЭтоДокументПоступлениеТоваров Тогда
		Запрос.УстановитьПараметр("ХозОперацииРаздельнойЗакупки", Новый Массив);
	Иначе
		Запрос.УстановитьПараметр("ХозОперацииРаздельнойЗакупки",
									ЗакупкиСервер.ХозяйственныеОперацииРаздельнойЗакупкиБезОтборов());
	КонецЕсли;
	
	ТоварыНакладной.Загрузить(Запрос.Выполнить().Выгрузить());
	
	Для Каждого СтрокаТовары Из ТоварыНакладной Цикл
		СтрокаТовары.Увеличить = ?(СтрокаТовары.Расхождение > 0, 1, 0);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ТекстЗапросаТоваровНакладной(ЕстьОтборПоСкладу, ЕстьОтборПоТоварам, ЕстьОтборПоТоварамЗаказа)
	
	ТекстЗапросаОтборПоТоварам = ?(ЕстьОтборПоТоварам,
		"ВЫБРАТЬ
		|	ТаблицаОтбора.Номенклатура		КАК Номенклатура,
		|	ТаблицаОтбора.Характеристика	КАК Характеристика
		|ПОМЕСТИТЬ ВТТаблицаОтбора
		|ИЗ
		|	&ТребуемыеТовары КАК ТаблицаОтбора
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Номенклатура,
		|	Характеристика
		|;
		|",
		"");
	
	ТекстЗапросаОтборПоТоварамЗаказа = ?(ЕстьОтборПоТоварамЗаказа,
		"ВЫБРАТЬ
		|	ВтТаблицаОтборовПоТоварамЗаказа.Ссылка			КАК Заказ,
		|	ВтТаблицаОтборовПоТоварамЗаказа.Номенклатура	КАК Номенклатура,
		|	ВтТаблицаОтборовПоТоварамЗаказа.Характеристика	КАК Характеристика
		|ПОМЕСТИТЬ ВтТаблицаОтборовПоТоварамЗаказа
		|ИЗ
		|	&ТоварыПоЗаказам КАК ВтТаблицаОтборовПоТоварамЗаказа
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Ссылка,
		|	Номенклатура,
		|	Характеристика
		|;
		|",
		"");
	
	ТекстЗапроса = ТекстЗапросаОтборПоТоварам + ТекстЗапросаОтборПоТоварамЗаказа +
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Таблица.ДокументОтгрузки	КАК Заказ,
	|	Таблица.Склад				КАК Склад,
	|	Таблица.Номенклатура		КАК Номенклатура,
	|	Таблица.Характеристика		КАК Характеристика,
	|	Таблица.Серия				КАК Серия,
	|	Таблица.КОтгрузкеРасход + Таблица.СобраноПриход - Таблица.КОформлениюРасход КАК РасхождениеПоЗаказу
	|ПОМЕСТИТЬ ВтТовары
	|ИЗ
	|	РегистрНакопления.ТоварыКОтгрузке.ОстаткиИОбороты(
	|			,
	|			,
	|			,
	|			,
	|			&ОтборТоварыКОтгрузке
	|	) КАК Таблица
	|
	|ГДЕ
	|	&НакладнаяНаОтгрузку
	|	И Таблица.КОтгрузкеРасход + Таблица.СобраноПриход - Таблица.КОформлениюРасход <> 0
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	Таблица.ДокументПоступления	КАК Заказ,
	|	Таблица.Склад				КАК Склад,
	|	Таблица.Номенклатура		КАК Номенклатура,
	|	Таблица.Характеристика		КАК Характеристика,
	|	Таблица.Серия				КАК Серия,
	|	Таблица.КОформлениюПоступленийПоОрдерамОстаток КАК РасхождениеПоЗаказу
	|ИЗ
	|	РегистрНакопления.ТоварыКПоступлению.Остатки(
	|			,
	|			&ОтборТоварыКОформлениюПоступления
	|			И ВЫБОР
	|				КОГДА НЕ ХозяйственнаяОперация В(&ХозОперацииРаздельнойЗакупки)
	|					ТОГДА ХозяйственнаяОперация = &ХозяйственнаяОперация
	|				ИНАЧЕ ЛОЖЬ
	|			КОНЕЦ
	|		) КАК Таблица
	|
	|ГДЕ
	|	&НакладнаяНаПриемку
	|	И Таблица.КОформлениюПоступленийПоОрдерамОстаток <> 0
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	Таблица.ДокументПоступления	КАК Заказ,
	|	Таблица.Склад				КАК Склад,
	|	Таблица.Номенклатура		КАК Номенклатура,
	|	Таблица.Характеристика		КАК Характеристика,
	|	Таблица.Серия				КАК Серия,
	|	-Таблица.КОформлениюПоступленийПоНакладнымОстаток КАК РасхождениеПоЗаказу
	|ИЗ
	|	РегистрНакопления.ТоварыКПоступлению.Остатки(
	|			,
	|			&ОтборТоварыКОформлениюПоступления
	|			И ВЫБОР
	|				КОГДА ХозяйственнаяОперация В(&ХозОперацииРаздельнойЗакупки)
	|					ТОГДА ХозяйственнаяОперация = &ХозяйственнаяОперация
	|				ИНАЧЕ ЛОЖЬ
	|			КОНЕЦ
	|	) КАК Таблица
	|
	|ГДЕ
	|	&НакладнаяНаПриемку
	|	И Таблица.КОформлениюПоступленийПоНакладнымОстаток <> 0
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Номенклатура,
	|	Характеристика,
	|	Серия,
	|	Склад,
	|	Заказ
	|;
	|
	|////////////////////////////////////////////////////////////////////////
	// Расхождение по всем заказам.
	|ВЫБРАТЬ
	|	Таблица.Номенклатура				КАК Номенклатура,
	|	Таблица.Характеристика				КАК Характеристика,
	|	Таблица.Серия						КАК Серия,
	|	Таблица.Склад						КАК Склад,
	|	СУММА(Таблица.РасхождениеПоЗаказу)	КАК Количество
	|ПОМЕСТИТЬ ВтРасхождение
	|ИЗ
	|	ВтТовары КАК Таблица
	|
	|СГРУППИРОВАТЬ ПО
	|	Таблица.Номенклатура,
	|	Таблица.Характеристика,
	|	Таблица.Серия,
	|	Таблица.Склад
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Номенклатура,
	|	Характеристика,
	|	Серия,
	|	Склад
	|;
	|
	|////////////////////////////////////////////////////////////////////////
	// Номенклатура накладной.
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Таблица.ДокументОтгрузки	КАК Заказ,
	|	Таблица.Номенклатура		КАК Номенклатура,
	|	Таблица.Характеристика		КАК Характеристика,
	|	Таблица.Серия				КАК Серия,
	|	Таблица.Склад				КАК Склад,
	|	СУММА(Таблица.КОформлению)	КАК Количество
	|ПОМЕСТИТЬ ВтНакладная
	|ИЗ
	|	РегистрНакопления.ТоварыКОтгрузке КАК Таблица
	|ГДЕ
	|	Таблица.Активность
	|	И &НакладнаяНаОтгрузку
	|	И Таблица.Регистратор = &Накладная
	|	И Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)
	|
	|СГРУППИРОВАТЬ ПО
	|	Таблица.ДокументОтгрузки,
	|	Таблица.Номенклатура,
	|	Таблица.Характеристика,
	|	Таблица.Серия,
	|	Таблица.Склад
	|
	|ИМЕЮЩИЕ
	|	СУММА(Таблица.КОформлению) <> 0
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	Таблица.ДокументПоступления	КАК Заказ,
	|	Таблица.Номенклатура		КАК Номенклатура,
	|	Таблица.Характеристика		КАК Характеристика,
	|	Таблица.Серия				КАК Серия,
	|	Таблица.Склад				КАК Склад,
	|	СУММА(Таблица.КОформлениюПоступленийПоОрдерам) КАК Количество
	|
	|ИЗ
	|	РегистрНакопления.ТоварыКПоступлению КАК Таблица
	|ГДЕ
	|	Таблица.Активность
	|	И &НакладнаяНаПриемку
	|	И Таблица.Регистратор = &Накладная
	|	И Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)
	|	И ВЫБОР
	|		КОГДА НЕ Таблица.ХозяйственнаяОперация В(&ХозОперацииРаздельнойЗакупки)
	|			ТОГДА Таблица.ХозяйственнаяОперация = &ХозяйственнаяОперация
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ
	|
	|СГРУППИРОВАТЬ ПО
	|	Таблица.ДокументПоступления,
	|	Таблица.Номенклатура,
	|	Таблица.Характеристика,
	|	Таблица.Серия,
	|	Таблица.Склад
	|
	|ИМЕЮЩИЕ
	|	СУММА(Таблица.КОформлениюПоступленийПоОрдерам) <> 0
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	Таблица.ДокументПоступления	КАК Заказ,
	|	Таблица.Номенклатура		КАК Номенклатура,
	|	Таблица.Характеристика		КАК Характеристика,
	|	Таблица.Серия				КАК Серия,
	|	Таблица.Склад				КАК Склад,
	|	СУММА(Таблица.КОформлениюПоступленийПоНакладным) КАК Количество
	|ИЗ
	|	РегистрНакопления.ТоварыКПоступлению КАК Таблица
	|ГДЕ
	|	Таблица.Активность
	|	И &НакладнаяНаПриемку
	|	И Таблица.Регистратор = &Накладная
	|	И Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|	И ВЫБОР
	|		КОГДА Таблица.ХозяйственнаяОперация В(&ХозОперацииРаздельнойЗакупки)
	|			ТОГДА Таблица.ХозяйственнаяОперация = &ХозяйственнаяОперация
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ
	|
	|СГРУППИРОВАТЬ ПО
	|	Таблица.ДокументПоступления,
	|	Таблица.Номенклатура,
	|	Таблица.Характеристика,
	|	Таблица.Серия,
	|	Таблица.Склад
	|
	|ИМЕЮЩИЕ
	|	СУММА(Таблица.КОформлениюПоступленийПоНакладным) <> 0
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Номенклатура,
	|	Характеристика,
	|	Серия,
	|	Склад,
	|	Заказ
	|;
	|
	|////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Таблица.Заказ						КАК Заказ,
	|	ВЫБОР
	|		КОГДА Таблица.Номенклатура= &ОсновнаяНоменклатура
	|				И Таблица.Характеристика = &ОсновнаяХарактеристика
	|				И Таблица.Склад В(&Склад)
	|			ТОГДА 1
	|		ИНАЧЕ 0
	|	КОНЕЦ								КАК ОсновнойТовар,
	|	Таблица.Номенклатура				КАК Номенклатура,
	|	ЕСТЬNULL(СпрНоменклатура.Наименование, """") КАК НоменклатураНаименование,
	|	Таблица.Характеристика				КАК Характеристика,
	|	Таблица.Характеристика.Наименование	КАК ХарактеристикаНаименование,
	|	ВЫБОР
	|		КОГДА СпрНоменклатура.ИспользованиеХарактеристик = ЗНАЧЕНИЕ(Перечисление.ВариантыИспользованияХарактеристикНоменклатуры.НеИспользовать)
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ								КАК ХарактеристикиИспользуются,
	|	Таблица.Серия						КАК Серия,
	|	СпрНоменклатура.ЕдиницаИзмерения	КАК ЕдиницаИзмерения,
	|	Таблица.Склад						КАК Склад,
	|	Таблица.Склад.Наименование			КАК СкладНаименование,
	|	ТаблицаРасхождениеВсего.Количество	КАК Расхождение,
	|	ТаблицаНакладная.Количество			КАК КоличествоВНакладной,
	|	ВЫБОР
	|		КОГДА Таблица.РасхождениеПоЗаказу < 0
	|				И ЕСТЬNULL(ТаблицаНакладная.Количество, 0) < -Таблица.РасхождениеПоЗаказу
	|			ТОГДА -ТаблицаНакладная.Количество
	|		ИНАЧЕ Таблица.РасхождениеПоЗаказу
	|	КОНЕЦ								КАК УвеличитьУменьшить
	|ИЗ
	|	ВтТовары КАК Таблица
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВтНакладная КАК ТаблицаНакладная
	|		ПО Таблица.Номенклатура = ТаблицаНакладная.Номенклатура
	|			И Таблица.Характеристика = ТаблицаНакладная.Характеристика
	|			И Таблица.Серия = ТаблицаНакладная.Серия
	|			И Таблица.Склад = ТаблицаНакладная.Склад
	|			И Таблица.Заказ = ТаблицаНакладная.Заказ
	|		
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВтРасхождение КАК ТаблицаРасхождениеВсего
	|		ПО Таблица.Номенклатура = ТаблицаРасхождениеВсего.Номенклатура
	|			И Таблица.Характеристика = ТаблицаРасхождениеВсего.Характеристика
	|			И Таблица.Серия = ТаблицаРасхождениеВсего.Серия
	|			И Таблица.Склад = ТаблицаРасхождениеВсего.Склад
	|		
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК СпрНоменклатура
	|		ПО СпрНоменклатура.Ссылка = Таблица.Номенклатура
	|
	|УПОРЯДОЧИТЬ ПО
	|	НоменклатураНаименование,
	|	ХарактеристикаНаименование,
	|	СкладНаименование,
	|	Заказ";
		
	Если ЕстьОтборПоТоварамЗаказа Тогда
		ОтборТоварыКОтгрузке =
			"(ДокументОтгрузки, Номенклатура, Характеристика) В
			|			(ВЫБРАТЬ
			|				ВтТаблицаОтборовПоТоварамЗаказа.Заказ,
			|				ВтТаблицаОтборовПоТоварамЗаказа.Номенклатура,
			|				ВтТаблицаОтборовПоТоварамЗаказа.Характеристика
			|			ИЗ
			|				ВтТаблицаОтборовПоТоварамЗаказа)";
		
		ТоварыКОформлениюПоступления =
			"(ДокументПоступления, Номенклатура, Характеристика) В
			|			(ВЫБРАТЬ
			|				ВтТаблицаОтборовПоТоварамЗаказа.Заказ,
			|				ВтТаблицаОтборовПоТоварамЗаказа.Номенклатура,
			|				ВтТаблицаОтборовПоТоварамЗаказа.Характеристика
			|			ИЗ
			|				ВтТаблицаОтборовПоТоварамЗаказа)";
	Иначе
		ОтборТоварыКОтгрузке			= "ДокументОтгрузки В (&МассивЗаказов)";
		ТоварыКОформлениюПоступления	= "ДокументПоступления В (&МассивЗаказов)";
	КонецЕсли;
	
	Если ЕстьОтборПоСкладу Тогда
		ОтборТоварыКОтгрузке			= "Склад В(&Склад) И " + ОтборТоварыКОтгрузке;
		ТоварыКОформлениюПоступления	= "Склад В(&Склад) И " + ТоварыКОформлениюПоступления;
	КонецЕсли;
	
	Если ЕстьОтборПоТоварам Тогда
		ОтборПоТоварам =
		"(Номенклатура, Характеристика) В
		|			(ВЫБРАТЬ
		|				ТаблицаОтбора.Номенклатура КАК Номенклатура,
		|				ТаблицаОтбора.Характеристика КАК Характеристика
		|			ИЗ
		|				ВТТаблицаОтбора КАК ТаблицаОтбора)";
		
		ОтборТоварыКОтгрузке			= ОтборТоварыКОтгрузке + " И " + ОтборПоТоварам;
		ТоварыКОформлениюПоступления	= ТоварыКОформлениюПоступления + " И " + ОтборПоТоварам;
	КонецЕсли;
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ОтборТоварыКОтгрузке",				ОтборТоварыКОтгрузке);
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ОтборТоварыКОформлениюПоступления",	ТоварыКОформлениюПоступления);
	
	Возврат ТекстЗапроса;
	
КонецФункции

#КонецОбласти

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	// Положительная общая разница
	Элемент = УсловноеОформление.Элементы.Добавить();
	Элемент.Представление = НСтр("ru = 'Положительная общая разница';
								|en = 'Total positive difference'");
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Расхождение.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ТоварыНакладной.Расхождение");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.БольшеИлиРавно;
	ОтборЭлемента.ПравоеЗначение = 0;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ОтметкаПоложительногоВыполненияЗадачи);
	
	// Отрицательная общая разница
	Элемент = УсловноеОформление.Элементы.Добавить();
	Элемент.Представление = НСтр("ru = 'Отрицательная общая разница';
								|en = 'Total negative difference'");
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Расхождение.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ТоварыНакладной.Расхождение");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Меньше;
	ОтборЭлемента.ПравоеЗначение = 0;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ОтметкаОтрицательногоВыполненияЗадачи);
	
	// Положительная разница
	Элемент = УсловноеОформление.Элементы.Добавить();
	Элемент.Представление = НСтр("ru = 'Положительная разница';
								|en = 'Positive difference'");
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.УвеличитьУменьшить.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ТоварыНакладной.УвеличитьУменьшить");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.БольшеИлиРавно;
	ОтборЭлемента.ПравоеЗначение = 0;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ОтметкаПоложительногоВыполненияЗадачи);
	
	// Отрицательная разница
	Элемент = УсловноеОформление.Элементы.Добавить();
	Элемент.Представление = НСтр("ru = 'Отрицательная разница';
								|en = 'Negative difference'");
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.УвеличитьУменьшить.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ТоварыНакладной.УвеличитьУменьшить");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Меньше;
	ОтборЭлемента.ПравоеЗначение = 0;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ОтметкаОтрицательногоВыполненияЗадачи);
	
	НоменклатураСервер.УстановитьУсловноеОформлениеХарактеристикНоменклатуры(
		ЭтаФорма, "Характеристика", "ТоварыНакладной.ХарактеристикиИспользуются");
	
КонецПроцедуры

&НаСервере
Функция НакладныеПоЗаказам(Заказы)
	
	ТекстЗапроса = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	Таблица.Регистратор					КАК Накладная,
	|	РеквизитыДокумента.ДатаДокументаИБ	КАК Дата
	|ИЗ
	|	РегистрНакопления.ТоварыКОтгрузке КАК Таблица
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.РеестрДокументов КАК РеквизитыДокумента
	|		ПО РеквизитыДокумента.Ссылка = Таблица.Регистратор
	|			И НЕ РеквизитыДокумента.ДополнительнаяЗапись
	|ГДЕ
	|	Таблица.Активность
	|	И &ОтборПоЗаказам_2
	|	И &ОтборПоТоварам_2
	|	И &ОтборПоТоварам_3
	|	И ВЫБОР
	|		КОГДА &СкладЗаполнен
	|			ТОГДА Таблица.Склад В(&Склад)
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ
	|	И &НакладнаяНаОтгрузку
	|	И Таблица.КОформлению > 0
	|	И Таблица.Период МЕЖДУ &ДатаНачала И &ДатаОкончания
	|	И Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Таблица.Регистратор					КАК Накладная,
	|	РеквизитыДокумента.ДатаДокументаИБ	КАК Дата
	|ИЗ
	|	РегистрНакопления.ТоварыКПоступлению КАК Таблица
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.РеестрДокументов КАК РеквизитыДокумента
	|		ПО РеквизитыДокумента.Ссылка = Таблица.Регистратор
	|			И НЕ РеквизитыДокумента.ДополнительнаяЗапись
	|ГДЕ
	|	Таблица.Активность
	|	И &ОтборПоЗаказам_1
	|	И &ОтборПоТоварам_1
	|	И &ОтборПоТоварам_3
	|	И ВЫБОР
	|		КОГДА &СкладЗаполнен
	|			ТОГДА Таблица.Склад В(&Склад)
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ
	|	И ВЫБОР
	|		КОГДА НЕ Таблица.ХозяйственнаяОперация В(&ХозОперацииРаздельнойЗакупки)
	|			ТОГДА Таблица.ХозяйственнаяОперация = &ХозяйственнаяОперация
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ
	|	И &НакладнаяНаПриемку
	|	И Таблица.КОформлениюПоступленийПоОрдерам > 0
	|	И Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)
	|	И (&ДатаНачала = Неопределено
	|		ИЛИ Таблица.Период МЕЖДУ &ДатаНачала И &ДатаОкончания)
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Таблица.Регистратор КАК Накладная,
	|	ЕСТЬNULL(РеквизитыДокумента.ДатаДокументаИБ, ДАТАВРЕМЯ(1,1,1)) КАК Дата
	|ИЗ
	|	РегистрНакопления.ТоварыКПоступлению КАК Таблица
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.РеестрДокументов КАК РеквизитыДокумента
	|		ПО РеквизитыДокумента.Ссылка = Таблица.Регистратор
	|			И НЕ РеквизитыДокумента.ДополнительнаяЗапись
	|ГДЕ
	|	Таблица.Активность
	|	И &ОтборПоЗаказам_1
	|	И &ОтборПоТоварам_1
	|	И &ОтборПоТоварам_3
	|	И ВЫБОР
	|		КОГДА &СкладЗаполнен
	|			ТОГДА Таблица.Склад В(&Склад)
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ
	|	И ВЫБОР
	|		КОГДА Таблица.ХозяйственнаяОперация В(&ХозОперацииРаздельнойЗакупки)
	|			ТОГДА Таблица.ХозяйственнаяОперация = &ХозяйственнаяОперация
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ
	|	И &НакладнаяНаПриемку
	|	И Таблица.КОформлениюПоступленийПоНакладным > 0
	|	И Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|	И (&ДатаНачала = Неопределено
	|		ИЛИ Таблица.Период МЕЖДУ &ДатаНачала И &ДатаОкончания)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Дата УБЫВ";
	
	НастройкиОтборов = ПолучитьНастройкиОтборов(Параметры.РеквизитыШапки);
	
	Если НастройкиОтборов = Неопределено Тогда

		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "И &ОтборПоЗаказам_1", "И Таблица.ДокументПоступления В(&Заказы)");
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "И &ОтборПоЗаказам_2", "И Таблица.ДокументОтгрузки В(&Заказы)");

		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "И &ОтборПоТоварам_1", "");
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "И &ОтборПоТоварам_2", "");
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "И &ОтборПоТоварам_3", "");
		
	Иначе
		
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "И &ОтборПоЗаказам_1", "");
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "И &ОтборПоЗаказам_2", "");

		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "И &ОтборПоТоварам_1", "И (Таблица.ДокументПоступления, Таблица.Номенклатура, Таблица.Характеристика) В");
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "И &ОтборПоТоварам_2", "И (Таблица.ДокументОтгрузки, Таблица.Номенклатура, Таблица.Характеристика) В");
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "И &ОтборПоТоварам_3", 
													"		(ВЫБРАТЬ
													|				ВтТаблицаОтборовПоТоварамЗаказа.Заказ,
													|				ВтТаблицаОтборовПоТоварамЗаказа.Номенклатура,
													|				ВтТаблицаОтборовПоТоварамЗаказа.Характеристика
													|			ИЗ
													|				ВтТаблицаОтборовПоТоварамЗаказа)");
		
		ТекстЗапросаОтборПоТоварам =
		"ВЫБРАТЬ
		|	ВтТаблицаОтборовПоТоварамЗаказа.Ссылка			КАК Заказ,
		|	ВтТаблицаОтборовПоТоварамЗаказа.Номенклатура	КАК Номенклатура,
		|	ВтТаблицаОтборовПоТоварамЗаказа.Характеристика	КАК Характеристика
		|ПОМЕСТИТЬ ВтТаблицаОтборовПоТоварамЗаказа
		|ИЗ
		|	&Заказы КАК ВтТаблицаОтборовПоТоварамЗаказа
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Заказ,
		|	Номенклатура,
		|	Характеристика
		|";
		
		ТекстыЗапросов = Новый Массив;
		ТекстыЗапросов.Добавить(ТекстЗапросаОтборПоТоварам);
		ТекстыЗапросов.Добавить(ТекстЗапроса);
		
		ТекстЗапроса = СтрСоединить(ТекстыЗапросов, ОбщегоНазначения.РазделительПакетаЗапросов());
		
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	
	Запрос.УстановитьПараметр("Заказы",					?(НастройкиОтборов = Неопределено,
															Заказы,
															НастройкиОтборов.ТаблицаОтборов));
	Запрос.УстановитьПараметр("Склад",					Склады.ВыгрузитьЗначения());
	Запрос.УстановитьПараметр("СкладЗаполнен",			ЗначениеЗаполнено(Склад));
	Запрос.УстановитьПараметр("ХозяйственнаяОперация",	ХозяйственнаяОперация);
	Запрос.УстановитьПараметр("ДатаНачала",				?(ЗначениеЗаполнено(СтандартныйПериод.ДатаНачала),
															СтандартныйПериод.ДатаНачала,
															Неопределено));
	Запрос.УстановитьПараметр("ДатаОкончания",			?(ЗначениеЗаполнено(СтандартныйПериод.ДатаОкончания),
															СтандартныйПериод.ДатаОкончания,
															Дата(3999,12,31)));
	Запрос.УстановитьПараметр("НакладнаяНаПриемку",		НакладнаяНаПриемку);
	Запрос.УстановитьПараметр("НакладнаяНаОтгрузку",	НакладнаяНаОтгрузку);
	
	Если ЭтоДокументПоступлениеТоваров Тогда
		Запрос.УстановитьПараметр("ХозОперацииРаздельнойЗакупки", Новый Массив);
	Иначе
		Запрос.УстановитьПараметр("ХозОперацииРаздельнойЗакупки",
									ЗакупкиСервер.ХозяйственныеОперацииРаздельнойЗакупкиБезОтборов());
	КонецЕсли;
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

&НаКлиенте
Процедура ЗаполнитьТаблицуТоварыНакладнойОтложенно()
	
	ТоварыНакладной.Очистить();
	СтрокаТовары = Элементы.ОформленныеНакладные.ТекущиеДанные;
	Если СтрокаТовары <> Неопределено Тогда
		
		ЗаполнитьТаблицуТоварыНакладной(СтрокаТовары.Накладная);
		
	КонецЕсли;
	
	
КонецПроцедуры

&НаСервере
Процедура СтандартныйПериодПриИзмененииСервер()
	ТаблицаНакладных = НакладныеПоЗаказам(СписокЗаказов);
	ОформленныеНакладные.Загрузить(ТаблицаНакладных);
КонецПроцедуры

&НаСервере
Функция ПолучитьНастройкиОтборов(ПараметрыОтборов) 

	ТаблицаОтборов = Новый ТаблицаЗначений;

	//++ НЕ УТ

	ОтборПоТоварам = Неопределено;
	ПараметрыОтборов.Свойство("ОтборПоТоварам", ОтборПоТоварам);

	Если ЗначениеЗаполнено(ОтборПоТоварам) Тогда

		ТаблицаОтборов.Колонки.Добавить("Ссылка",
			Документы.ТипВсеСсылки());
		
		ТаблицаОтборов.Колонки.Добавить("Номенклатура",
			Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));

		ТаблицаОтборов.Колонки.Добавить("Характеристика",
			Новый ОписаниеТипов("СправочникСсылка.ХарактеристикиНоменклатуры"));

		Для каждого ЭлементОтбора Из ОтборПоТоварам Цикл

			ДокументИсточник = ЭлементОтбора.Ключ;

			ЗначенияОтбора = ЭлементОтбора.Значение;
			Для каждого ЗначениеОтбора Из ЗначенияОтбора Цикл

				СтрокаТаблицыОтбора = ТаблицаОтборов.Добавить();
				СтрокаТаблицыОтбора.Ссылка = ДокументИсточник;
				ЗаполнитьЗначенияСвойств(СтрокаТаблицыОтбора, ЗначениеОтбора.Значение);

			КонецЦикла;

		КонецЦикла;

	КонецЕсли;

	//-- НЕ УТ

	НастройкаОтборов = ?(ТаблицаОтборов.Колонки.Количество() = 0,
		Неопределено, Новый Структура("ТаблицаОтборов", ТаблицаОтборов));

	Возврат НастройкаОтборов;

КонецФункции

#КонецОбласти