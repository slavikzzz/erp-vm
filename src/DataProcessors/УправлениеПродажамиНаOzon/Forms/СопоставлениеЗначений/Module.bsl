
#Область ОписаниеПеременных

&НаКлиенте
Перем ДанныеАктивнойСтроки;

&НаКлиенте
Перем ЭтоЗакрытиеФормы;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Параметры.Свойство("УчетнаяЗаписьМаркетплейса", УчетнаяЗаписьМаркетплейса);
	Параметры.Свойство("МножественныйВыбор", МножественныйВыбор);
	Параметры.Свойство("НаименованиеАтрибутаМаркетплейса", НаименованиеАтрибутаМаркетплейса);
	Параметры.Свойство("СоответствиеПсевдонимовМетаданных", СоответствиеПсевдонимовМетаданных);
	Параметры.Свойство("Реквизит1С", Реквизит1С);
	Параметры.Свойство("ТипЗначенияРеквизита1С", ТипЗначенияРеквизита1С);
	Параметры.Свойство("ПараметрыАтрибута", ПараметрыАтрибута);
	Параметры.Свойство("АдресХранилищаДоступныхЗначений", АдресХранилищаДоступныхЗначений);

	ШаблонПодсказкиНаименованияАтрибута = НСтр("ru = 'Необходимо заполнить соответствие значений для атрибута <%1>.';
												|en = 'Fill the value mapping for the <%1> product option.'");
	Элементы.ДекорацияПодсказкаНаименованияАтрибута.Заголовок = 
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонПодсказкиНаименованияАтрибута, НаименованиеАтрибутаМаркетплейса);

	Если МножественныйВыбор Тогда
		ШаблонПодсказкиВариантаЗаполненияЗначений = НСтр("ru = 'Для одного значения 1С доступно указание нескольких значений маркетплейса.';
														|en = 'You can specify multiple marketplace values for the same 1C value.'");
	Иначе	
		ШаблонПодсказкиВариантаЗаполненияЗначений = НСтр("ru = 'Для одного значения 1С доступно указание одного значения маркетплейса.';
														|en = 'You can specify one marketplace value for a single 1C value.'");
	КонецЕсли;

	Элементы.ДекорацияПодсказкаВариантаЗаполненияЗначений.Заголовок = ШаблонПодсказкиВариантаЗаполненияЗначений;

	Элементы.СоответствияЗначенийАтрибутовИдентификаторЗначенияАтрибута.Видимость = Не МножественныйВыбор;
	Элементы.СоответствияЗначенийАтрибутовЗначенияАтрибута.Видимость = МножественныйВыбор;

	УстановитьУсловноеОформление();
	
	Элементы.СтраницыИнформацииПоЗначениям.ТекущаяСтраница = Элементы.СтраницаДлительногоОжидания;

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	ЗаполнитьИнформациюПоЗначениямАтрибута();

КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)

	ЭтоЗакрытиеФормы = Истина;
	Оповестить("ЗакрытиеСопоставленияЗначений", АдресХранилищаДоступныхЗначений, ВладелецФормы.УникальныйИдентификатор);

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)

	Если ИмяСобытия = "ЗакрытиеВыбораЗначений" И Источник = УникальныйИдентификатор Тогда
		АдресХранилищаДоступныхЗначений = Параметр;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти    

#Область ОбработчикиСобытийЭлементовТаблицыФормыСоответствияЗначенийАтрибутов

&НаКлиенте
Процедура СоответствияЗначенийАтрибутовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)

	Если Поле.Имя = "СоответствияЗначенийАтрибутовИдентификаторЗначенияАтрибута" Тогда
		ОткрытьФормуВыбораЗначенияАтрибута(ВыбраннаяСтрока);
		СтандартнаяОбработка = Ложь;
	ИначеЕсли Поле.Имя = "СоответствияЗначенийАтрибутовЗначенияАтрибута" Тогда
		ОткрытьФормуВыбораЗначенияАтрибута(ВыбраннаяСтрока, Истина);
		СтандартнаяОбработка = Ложь;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура СоответствияЗначенийАтрибутовПриИзменении(Элемент)

	ТекущиеДанные = Элементы.СоответствияЗначенийАтрибутов.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;

	ТекущиеДанные.ЗначениеУстановлено = (ТекущиеДанные.ЗначенияАтрибута.Количество() > 0
			Или ЗначениеЗаполнено(ТекущиеДанные.ИдентификаторЗначенияАтрибута));

	ТекущиеДанные.ПредыдущиеЗначенияАтрибута.Очистить();
	ТекущиеДанные.ЗаписываемыеЗначенияАтрибута.Очистить();

	Если ДанныеАктивнойСтроки <> Неопределено Тогда 
		Если ДанныеАктивнойСтроки.ИдентификаторЗначенияАтрибута <> ТекущиеДанные.ИдентификаторЗначенияАтрибута Тогда
			ТекущиеДанные.ЗаписываемыеЗначенияАтрибута.Добавить(
					ТекущиеДанные.ИдентификаторЗначенияАтрибута, ТекущиеДанные.НаименованиеЗначенияАтрибута);
			ТекущиеДанные.ПредыдущиеЗначенияАтрибута.Добавить(
					ДанныеАктивнойСтроки.ИдентификаторЗначенияАтрибута, ДанныеАктивнойСтроки.НаименованиеЗначенияАтрибута);
		ИначеЕсли ДанныеАктивнойСтроки.ЗначенияАтрибута.Количество() Тогда
			Для Каждого ЗначениеАтрибута Из ТекущиеДанные.ЗначенияАтрибута Цикл
				СтрокаИзИстории = ДанныеАктивнойСтроки.ЗначенияАтрибута.НайтиПоЗначению(ЗначениеАтрибута.Значение);
				Если СтрокаИзИстории <> Неопределено Тогда
					ДанныеАктивнойСтроки.ЗначенияАтрибута.Удалить(СтрокаИзИстории);
				КонецЕсли;

				ТекущиеДанные.ЗаписываемыеЗначенияАтрибута.Добавить(ЗначениеАтрибута.Значение, ЗначениеАтрибута);
			КонецЦикла;

			ТекущиеДанные.ПредыдущиеЗначенияАтрибута = ДанныеАктивнойСтроки.ЗначенияАтрибута;
		КонецЕсли;
	КонецЕсли;

	Если ТекущиеДанные.ЗначениеУстановлено Или ТекущиеДанные.ЗаданоСоответствие Тогда
		ЗаписьВРегистрСоответствияОбъектов(ТекущиеДанные.ПолучитьИдентификатор());
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура СоответствияЗначенийАтрибутовЗначенияАтрибутаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)

	ТекущиеДанные = Элементы.СоответствияЗначенийАтрибутов.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;

	ДоступныеТипы = Новый ОписаниеТипов("Строка");
	ТекущиеДанные.ЗначенияАтрибута.ТипЗначения = ДоступныеТипы;
	ТекущиеДанные.ЗначенияАтрибута.ДоступныеЗначения = Элемент.СписокВыбора;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура УстановитьСоответствие(Команда)

	ОткрытьФормуВыбораЗначенияАтрибута(, МножественныйВыбор);

КонецПроцедуры

&НаКлиенте
Процедура ОчиститьСоответствие(Команда)

	ТекущиеДанные = Элементы.СоответствияЗначенийАтрибутов.ТекущиеДанные;

	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;

	ТекущиеДанные.ПредыдущиеЗначенияАтрибута.Очистить();
	ТекущиеДанные.ЗаписываемыеЗначенияАтрибута.Очистить();

	Если ТекущиеДанные.ЗначенияАтрибута.Количество() Тогда
		ТекущиеДанные.ПредыдущиеЗначенияАтрибута = ОбщегоНазначенияКлиент.СкопироватьРекурсивно(ТекущиеДанные.ЗначенияАтрибута);
	ИначеЕсли ЗначениеЗаполнено(ТекущиеДанные.ИдентификаторЗначенияАтрибута) Тогда
		ТекущиеДанные.ПредыдущиеЗначенияАтрибута.Добавить(
				ТекущиеДанные.ИдентификаторЗначенияАтрибута, ТекущиеДанные.НаименованиеЗначенияАтрибута);
	КонецЕсли;

	ТекущиеДанные.ИдентификаторЗначенияАтрибута = "";
	ТекущиеДанные.НаименованиеЗначенияАтрибута = "";
	ТекущиеДанные.ЗначенияАтрибута.Очистить();
	ТекущиеДанные.ЗначениеУстановлено = Ложь;

	ЗаписьВРегистрСоответствияОбъектов(ТекущиеДанные.ПолучитьИдентификатор());

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СоответствияЗначенийАтрибутовИдентификаторЗначенияАтрибута.Имя);

	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СоответствияЗначенийАтрибутов.ЗначениеУстановлено");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;

	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.НезаполненноеПолеТаблицы);
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<Выбрать значение маркетплейса>';
																					|en = '<Select marketplace value>'"));

	//
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СоответствияЗначенийАтрибутовИдентификаторЗначенияАтрибута.Имя);

	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СоответствияЗначенийАтрибутов.ЗначениеУстановлено");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Текст", Новый ПолеКомпоновкиДанных("СоответствияЗначенийАтрибутов.НаименованиеЗначенияАтрибута"));

	//
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СоответствияЗначенийАтрибутовЗначенияАтрибута.Имя);

	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СоответствияЗначенийАтрибутов.ЗначениеУстановлено");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;

	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.НезаполненноеПолеТаблицы);
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<Выбрать значения маркетплейса>';
																					|en = '<Select marketplace values>'"));

КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьИнформациюПоЗначениямАтрибута()

	Если ПараметрыАтрибута = Неопределено Тогда
		Возврат;
	КонецЕсли;

	ИдентификаторКэшаАтрибутаКатегории = "АтрибутКатегории_" +
			"_" + ПараметрыАтрибута.ИдентификаторКатегории1С +
			"_" + ПараметрыАтрибута.ИдентификаторКатегорииМаркетплейса +
			"_" + ПараметрыАтрибута.ИдентификаторАтрибутаМаркетплейса;
	ДанныеКэша = ИнтеграцияСМаркетплейсомOzonКлиент.ПолучитьДанныеИзКэшаКатегорий(ИдентификаторКэшаАтрибутаКатегории);

	ДлительнаяОперация = ЗаполнитьДеревоАтрибутовКатегорииНаСервере(ДанныеКэша);

	ОповещениеОЗавершении = Новый ОписаниеОповещения("ЗаполнитьДанныеЗначенийАтрибутаКатегорииЗавершение", ЭтотОбъект);
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, ОповещениеОЗавершении, ПараметрыОжидания);

КонецПроцедуры

&НаСервере
Функция ЗаполнитьДеревоАтрибутовКатегорииНаСервере(ДанныеКэша = Неопределено)

	ИмяМетода = "ИнтеграцияСМаркетплейсомOzonСервер.ЗаполнитьДанныеЗначенийАтрибутаКатегории";
	НаименованиеФоновогоЗадания = НСтр("ru = 'Ozon. Заполнение значений атрибута ""%1""';
										|en = 'Ozon. Fill the ""%1"" product option values'");

	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.ЗапуститьВФоне = Истина;
	ПараметрыВыполнения.НаименованиеФоновогоЗадания =
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НаименованиеФоновогоЗадания, НаименованиеАтрибутаМаркетплейса);

	ПараметрыЗаполнения = Новый Структура;
	ПараметрыЗаполнения.Вставить("ПараметрыАтрибута", ПараметрыАтрибута);
	ПараметрыЗаполнения.Вставить("МножественныйВыбор", МножественныйВыбор);
	ПараметрыЗаполнения.Вставить("Реквизит1С", Реквизит1С);
	ПараметрыЗаполнения.Вставить("ТипЗначенияРеквизита1С", ТипЗначенияРеквизита1С);
	ПараметрыЗаполнения.Вставить("СоответствиеПсевдонимовМетаданных", СоответствиеПсевдонимовМетаданных);

	СоответствияЗначенийАтрибутовФормы = РеквизитФормыВЗначение("СоответствияЗначенийАтрибутов");
	СоответствияЗначенийАтрибутовФормы.Очистить();

	Возврат ДлительныеОперации.ВыполнитьФункцию(ПараметрыВыполнения, ИмяМетода,
			СоответствияЗначенийАтрибутовФормы, ПараметрыЗаполнения, УчетнаяЗаписьМаркетплейса, ДанныеКэша);

КонецФункции

&НаКлиенте
Процедура ЗаполнитьДанныеЗначенийАтрибутаКатегорииЗавершение(Результат, ДополнительныеПараметры) Экспорт

	ОчиститьСообщения();

	Если Результат <> Неопределено И Результат.Статус = "Выполнено" Тогда
		ДанныеКэша = Неопределено;
		ЗаполнитьДанныеЗначенийАтрибутаКатегорииНаСервере(Результат.АдресРезультата, ДанныеКэша);

		Если ЗначениеЗаполнено(ДанныеКэша) Тогда
			ИнтеграцияСМаркетплейсомOzonКлиент.СохранитьДанныеВКэшКатегорий(ДанныеКэша, ИдентификаторКэшаАтрибутаКатегории);
			ДанныеКэша = Неопределено;
		КонецЕсли;
	ИначеЕсли ЭтоЗакрытиеФормы <> Истина Тогда
		ШаблонОшибки = НСтр("ru = 'Не удалось заполнить значения атрибута ""%1"" по причине: %2. Подробнее см. журнал регистрации.';
							|en = 'Cannot fill the ""%1"" product option value due to: %2. For more information, see the event log.'");
		ПредставлениеНеизвестнойОшибки = НСтр("ru = 'Неизвестная ошибка выполнения операции';
												|en = 'Unknown operation error'");
		ПодробноеПредставлениеОшибки = ?(Результат = Неопределено, ПредставлениеНеизвестнойОшибки, Результат.ПодробноеПредставлениеОшибки);
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				ШаблонОшибки,
				НаименованиеАтрибутаМаркетплейса,
				ПодробноеПредставлениеОшибки);
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстОшибки);
	КонецЕсли;

	Элементы.СтраницыИнформацииПоЗначениям.ТекущаяСтраница = Элементы.СтраницаИнформацииПоЗначениям;

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДанныеЗначенийАтрибутаКатегорииНаСервере(АдресХранилища, ДанныеКэша)

	Результат = ПолучитьИзВременногоХранилища(АдресХранилища);
	УдалитьИзВременногоХранилища(АдресХранилища);

	ЗначениеВРеквизитФормы(Результат, "СоответствияЗначенийАтрибутов");

	ОбновитьИнформационнуюНадпись();

КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуВыбораЗначенияАтрибута(ИдентификаторСтроки = Неопределено, МножественныйВыбор = Ложь)

	Если ИдентификаторСтроки = Неопределено Тогда
		ТекущиеДанные = Элементы.СоответствияЗначенийАтрибутов.ТекущиеДанные;
	Иначе
		ТекущиеДанные = СоответствияЗначенийАтрибутов.НайтиПоИдентификатору(ИдентификаторСтроки);
	КонецЕсли;

	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;

	ДанныеАктивнойСтроки = Новый Структура;
	ДанныеАктивнойСтроки.Вставить("ЗначениеУстановлено", ТекущиеДанные.ЗначениеУстановлено);
	ДанныеАктивнойСтроки.Вставить("ИдентификаторЗначенияАтрибута", ТекущиеДанные.ИдентификаторЗначенияАтрибута);
	ДанныеАктивнойСтроки.Вставить("НаименованиеЗначенияАтрибута", ТекущиеДанные.НаименованиеЗначенияАтрибута);
	ДанныеАктивнойСтроки.Вставить("ЗначенияАтрибута", ОбщегоНазначенияКлиент.СкопироватьРекурсивно(ТекущиеДанные.ЗначенияАтрибута));

	ПараметрыВыбора = Новый Структура;
	ПараметрыВыбора.Вставить("УчетнаяЗаписьМаркетплейса", УчетнаяЗаписьМаркетплейса);
	ПараметрыВыбора.Вставить("ИдентификаторКатегорииМаркетплейса", ТекущиеДанные.ИдентификаторКатегорииМаркетплейса);
	ПараметрыВыбора.Вставить("ИдентификаторАтрибутаМаркетплейса", ТекущиеДанные.ИдентификаторАтрибутаМаркетплейса);
	ПараметрыВыбора.Вставить("НаименованиеАтрибутаМаркетплейса", НаименованиеАтрибутаМаркетплейса);
	ШаблонОписания = НСтр("ru = 'Выбор значения маркетплейса для значения реквизита 1С <%1>';
							|en = 'Select a marketplace value for the <%1> 1C attribute value'");
	ПараметрыВыбора.Вставить("Описание",
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонОписания, ТекущиеДанные.ЗначениеРеквизита1С));

	Если МножественныйВыбор Тогда
		ПараметрыВыбора.Вставить("ТекущееЗначениеАтрибута", ТекущиеДанные.ЗначенияАтрибута);

		ИмяФормыВыбора = "ВыборСпискаЗначенийМаркетплейса";
	Иначе
		ПараметрыВыбора.Вставить("ТекущееЗначениеАтрибута", ТекущиеДанные.НаименованиеЗначенияАтрибута);
		ПараметрыВыбора.Вставить("ИдентификаторТекущегоЗначенияАтрибута", ТекущиеДанные.ИдентификаторЗначенияАтрибута);

		ИмяФормыВыбора = "ВыборЗначенияМаркетплейса";
	КонецЕсли;

	Если ЗначениеЗаполнено(АдресХранилищаДоступныхЗначений) Тогда
		ПараметрыВыбора.Вставить("АдресХранилищаДоступныхЗначений", АдресХранилищаДоступныхЗначений);
	КонецЕсли;

	ОбработчикВыбораЗначения = Новый ОписаниеОповещения("ВыборЗначенияЗавершение", ЭтотОбъект);
	ОткрытьФорму("Обработка.УправлениеПродажамиНаOzon.Форма." + ИмяФормыВыбора,
			ПараметрыВыбора, ЭтотОбъект,,,, ОбработчикВыбораЗначения);

КонецПроцедуры

&НаКлиенте
Процедура ВыборЗначенияЗавершение(ВыбранноеЗначение, ДополнительныеПараметры = Неопределено) Экспорт

	Если ВыбранноеЗначение = Неопределено Тогда
		Возврат;
	КонецЕсли;

	АдресХранилищаДоступныхЗначений = ВыбранноеЗначение.АдресХранилищаДоступныхЗначений;

	ТекущиеДанные = Элементы.СоответствияЗначенийАтрибутов.ТекущиеДанные;

	Если ВыбранноеЗначение.Свойство("ЗначенияАтрибута") Тогда
		ТекущиеДанные.ИдентификаторЗначенияАтрибута = "";
		ТекущиеДанные.НаименованиеЗначенияАтрибута = "";
		ТекущиеДанные.ЗначенияАтрибута = ВыбранноеЗначение.ЗначенияАтрибута;
	Иначе
		ТекущиеДанные.ИдентификаторЗначенияАтрибута = ВыбранноеЗначение.ИдентификаторЗначенияАтрибута;
		ТекущиеДанные.НаименованиеЗначенияАтрибута = ВыбранноеЗначение.ЗначениеАтрибута;
		ТекущиеДанные.ЗначенияАтрибута = Новый СписокЗначений;
	КонецЕсли;

	ТекущиеДанные.ЗначениеУстановлено = (ТекущиеДанные.ЗначенияАтрибута.Количество() > 0
			Или ЗначениеЗаполнено(ТекущиеДанные.ИдентификаторЗначенияАтрибута));

	ТекущиеДанные.ПредыдущиеЗначенияАтрибута.Очистить();
	ТекущиеДанные.ЗаписываемыеЗначенияАтрибута.Очистить();

	Если ДанныеАктивнойСтроки <> Неопределено Тогда
		Если ДанныеАктивнойСтроки.ИдентификаторЗначенияАтрибута <> ТекущиеДанные.ИдентификаторЗначенияАтрибута Тогда
			ТекущиеДанные.ЗаписываемыеЗначенияАтрибута.Добавить(ТекущиеДанные.ИдентификаторЗначенияАтрибута,
					ТекущиеДанные.НаименованиеЗначенияАтрибута);
			ТекущиеДанные.ПредыдущиеЗначенияАтрибута.Добавить(ДанныеАктивнойСтроки.ИдентификаторЗначенияАтрибута,
					ДанныеАктивнойСтроки.НаименованиеЗначенияАтрибута);
		ИначеЕсли ТекущиеДанные.ЗначенияАтрибута.Количество() Тогда
			Для Каждого ЗначениеАтрибута Из ТекущиеДанные.ЗначенияАтрибута Цикл 
				СтрокаИзИстории = ДанныеАктивнойСтроки.ЗначенияАтрибута.НайтиПоЗначению(ЗначениеАтрибута.Значение);
				Если СтрокаИзИстории <> Неопределено Тогда
					ДанныеАктивнойСтроки.ЗначенияАтрибута.Удалить(СтрокаИзИстории);
				КонецЕсли;
	
				ТекущиеДанные.ЗаписываемыеЗначенияАтрибута.Добавить(ЗначениеАтрибута.Значение, ЗначениеАтрибута);
			КонецЦикла;

			ТекущиеДанные.ПредыдущиеЗначенияАтрибута = ДанныеАктивнойСтроки.ЗначенияАтрибута;
		ИначеЕсли Не ТекущиеДанные.ЗначенияАтрибута.Количество() И ДанныеАктивнойСтроки.ЗначенияАтрибута.Количество() Тогда
			ТекущиеДанные.ПредыдущиеЗначенияАтрибута = ОбщегоНазначенияКлиент.СкопироватьРекурсивно(ДанныеАктивнойСтроки.ЗначенияАтрибута);
		КонецЕсли;
	КонецЕсли;

	Если ТекущиеДанные.ЗначениеУстановлено Или ТекущиеДанные.ЗаданоСоответствие Тогда
		ЗаписьВРегистрСоответствияОбъектов(ТекущиеДанные.ПолучитьИдентификатор());
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ЗаписьВРегистрСоответствияОбъектов(ДанныеСтроки)
	
	Если ТипЗнч(ДанныеСтроки) = Тип("Число") Тогда
		ТекущиеДанные = СоответствияЗначенийАтрибутов.НайтиПоИдентификатору(ДанныеСтроки);
	Иначе
		ТекущиеДанные = ДанныеСтроки;
	КонецЕсли;

	ИдентификаторВладельца = ПараметрыАтрибута.ИдентификаторКатегории1С +
			"/" + ТекущиеДанные.ИдентификаторКатегорииМаркетплейса +
			"/" + ТекущиеДанные.ИдентификаторАтрибутаМаркетплейса;

	ОсновныеДанныеЗаписи = Новый Структура;
	ОсновныеДанныеЗаписи.Вставить("УчетнаяЗаписьМаркетплейса", УчетнаяЗаписьМаркетплейса);
	ОсновныеДанныеЗаписи.Вставить("ВидОбъектаМаркетплейса", ПредопределенноеЗначение("Перечисление.ВидыОбъектовМаркетплейсов.ЗначениеАтрибутаКатегорииТоваров"));
	ОсновныеДанныеЗаписи.Вставить("ИдентификаторВладельцаОбъектаМаркетплейса", ИдентификаторВладельца);
	ОсновныеДанныеЗаписи.Вставить("Объект1С", ТекущиеДанные.ЗначениеРеквизита1С);

	Если ТекущиеДанные.ЗначениеУстановлено Тогда
		НаборЗаписей = РегистрыСведений.СоответствияОбъектовМаркетплейсов.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.УчетнаяЗаписьМаркетплейса.Установить(УчетнаяЗаписьМаркетплейса);
		НаборЗаписей.Отбор.ВидОбъектаМаркетплейса.Установить(ПредопределенноеЗначение("Перечисление.ВидыОбъектовМаркетплейсов.ЗначениеАтрибутаКатегорииТоваров"));
		НаборЗаписей.Отбор.ИдентификаторВладельцаОбъектаМаркетплейса.Установить(ИдентификаторВладельца);
		НаборЗаписей.Отбор.Объект1С.Установить(ТекущиеДанные.ЗначениеРеквизита1С);

		ДатаИзменения = ТекущаяДатаСеанса();

		Для Каждого ЗначениеАтрибута Из ТекущиеДанные.ЗаписываемыеЗначенияАтрибута Цикл
			Если Не ЗначениеЗаполнено(ЗначениеАтрибута.Значение) Тогда
				Продолжить;
			КонецЕсли;

			ЗаписьСоответствия = НаборЗаписей.Добавить();
			ЗаполнитьЗначенияСвойств(ЗаписьСоответствия, ОсновныеДанныеЗаписи);
			ЗаписьСоответствия.ИдентификаторОбъектаМаркетплейса = ЗначениеАтрибута.Значение;
			ЗаписьСоответствия.НаименованиеОбъектаМаркетплейса = ЗначениеАтрибута;
			ЗаписьСоответствия.ДатаАктуальности = ДатаИзменения;
		КонецЦикла;

		Если НаборЗаписей.Количество() Тогда
			НаборЗаписей.Записать();
		КонецЕсли;

		ТекущиеДанные.ЗаданоСоответствие = Истина;
		
	ИначеЕсли ТекущиеДанные.ПредыдущиеЗначенияАтрибута.Количество() Тогда
		Для Каждого ЗначениеАтрибута Из ТекущиеДанные.ПредыдущиеЗначенияАтрибута Цикл
			ЗаписьСоответствия = РегистрыСведений.СоответствияОбъектовМаркетплейсов.СоздатьМенеджерЗаписи();
			ЗаполнитьЗначенияСвойств(ЗаписьСоответствия, ОсновныеДанныеЗаписи);
			ЗаписьСоответствия.ИдентификаторОбъектаМаркетплейса = ЗначениеАтрибута.Значение; 
			ЗаписьСоответствия.Удалить();
		КонецЦикла;

		ТекущиеДанные.ЗаданоСоответствие = Ложь;
	КонецЕсли;

	ОбновитьИнформационнуюНадпись();

КонецПроцедуры

&НаСервере
Процедура ОбновитьИнформационнуюНадпись()

	ШаблонСоответствия = НСтр("ru = 'Сопоставлено %1 из %2';
								|en = 'Mapped %1 out of %2'");

	Отбор = Новый Структура("ЗаданоСоответствие", Истина);
	СтрокиОтбора = СоответствияЗначенийАтрибутов.НайтиСтроки(Отбор);
	СопоставленноеКоличество = СтрокиОтбора.Количество();

	ОбщееКоличество = СоответствияЗначенийАтрибутов.Количество();

	Элементы.ДекорацияИнформационнаяНадпись.Заголовок =
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСоответствия, СопоставленноеКоличество, ОбщееКоличество);

КонецПроцедуры

#КонецОбласти
