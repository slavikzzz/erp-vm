
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Не ЗначениеЗаполнено(Параметры.Ключ) Тогда
		Возврат;// Создание новых элементов из формы списка не предусмотрено.
	КонецЕсли;

	Элементы.ДекорацияАктивнаяУчетнаяЗапись.Видимость = Не Объект.ПометкаУдаления;
	Элементы.ДекорацияАрхивнаяУчетнаяЗапись.Видимость = Объект.ПометкаУдаления;
	Элементы.ВалютаУчета.Доступность = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоВалют");
	Элементы.НеОбновлятьДанныеТорговойПлощадки.ТолькоПросмотр = Не Пользователи.ЭтоПолноправныйПользователь(, Ложь, Ложь);

	ЭтоOzon         = (Объект.ВидМаркетплейса = ПредопределенноеЗначение("Перечисление.ВидыМаркетплейсов.МаркетплейсOzon"));
	ЭтоЯндексМаркет = (Объект.ВидМаркетплейса = ПредопределенноеЗначение("Перечисление.ВидыМаркетплейсов.МаркетплейсЯндексМаркет"));

	Если ЭтоOzon Тогда
		Элементы.ИдентификаторАккаунта.Видимость = Ложь;
		Элементы.ИдентификаторКабинета.Видимость = Ложь;
		Элементы.ИдентификаторМагазина.Видимость = Ложь;
		Элементы.СхемаРаботы.Видимость           = Ложь;
		
	ИначеЕсли ЭтоЯндексМаркет Тогда
		Элементы.ВалютаУчета.Видимость = Ложь;

		Элементы.ДекорацияАктивнаяУчетнаяЗапись.Заголовок    = НСтр("ru = 'Учетная запись активна. Основные настройки заполняются в форме настроек магазина.';
																	|en = 'The account is active. You can fill the main settings in the store settings form.'");
		Элементы.ДекорацияАрхивнаяУчетнаяЗапись.Заголовок    = НСтр("ru = 'Магазин отсутствует в кабинете торговой площадки.';
																	|en = 'The store is unavailable in the personal account of the trading platform.'");
		Элементы.НеОбновлятьДанныеТорговойПлощадки.Заголовок = НСтр("ru = 'Запрещен обмен данными с магазином';
																	|en = 'Data exchange with the store is not allowed'");
		Элементы.ИдентификаторАккаунта.Заголовок             = НСтр("ru = 'Аккаунт подключения';
																	|en = 'Connection account'");
		Элементы.ИдентификаторМагазина.Заголовок             = НСтр("ru = 'Идентификатор кампании';
																	|en = 'Campaign ID'");
		Элементы.ИдентификаторКлиента.Заголовок              = НСтр("ru = 'Номер магазина';
																	|en = 'Store number'");
	КонецЕсли;

	Если Объект.ПометкаУдаления Тогда
		ТолькоПросмотр = Истина;
	КонецЕсли;

	УстановитьУсловноеОформление();

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.УправлениеДоступом

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом

КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)

	Если ЭтоOzon Тогда
		ПараметрыФормыСопоставленияКатегорий = Новый Структура;
		ПараметрыФормыСопоставленияКатегорий.Вставить("УчетнаяЗаписьМаркетплейса", Объект.Ссылка);
		ПараметрыФормыСопоставленияКатегорий.Вставить("ИсточникКатегории",         Объект.ИсточникКатегории);
		
		ОповеститьОбИзменении(Объект.Ссылка);
		Оповестить("ИсточникКатегорииИзменен", ПараметрыФормыСопоставленияКатегорий);
		Оповестить("ОбновитьСписокПодключений");
		Оповестить("Запись_УчетныеЗаписиМаркетплейсов", Объект.Ссылка);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	//
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДополнительныеНастройкиЗначениеНастройки.Имя);

	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДополнительныеНастройки.ДополнительныеНастройкиЗначениеНастройкиСтрока");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено;

	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);

	//
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДополнительныеНастройкиЗначениеНастройкиСтрока.Имя);

	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДополнительныеНастройки.ДополнительныеНастройкиЗначениеНастройкиСтрока");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;

	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);

КонецПроцедуры

#КонецОбласти