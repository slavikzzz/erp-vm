
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбработкаОбъект = РеквизитФормыВЗначение("Объект");

	ИмяФормыНастройкаСоставаВидовДокументов = ОбработкаОбъект.Метаданные().ПолноеИмя()
			+ ".Форма.НастройкаСоставаВидовДокументов";

	УстановитьКлючНастроек();

	ЗаполнитьТаблицуЗапросов(ОбработкаОбъект);

	ОбновитьСписокВидовДокументов();

	ВосстановитьНастройки();

	ОбновитьТекстЗапроса();

	УстановитьЗначенияПоУмолчанию();

	ПрименитьПараметрыКоманды();

КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)

	Если Не ЗавершениеРаботы Тогда
		СохранитьНастройки();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТолькоАктуальныеПриИзменении(Элемент)
	
	ОбработатьИзменениеФлагаТолькоАктуальныеНаСервере()
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТаблицаДокументов

&НаКлиенте
Процедура ТаблицаДокументовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)

	ПоказатьЗначение(Неопределено, Элемент.ТекущиеДанные.Документ);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура НастроитьСоставДокументов(Команда)

	РедактироватьСоставДокументов();

КонецПроцедуры

&НаКлиенте
Процедура Сформировать(Команда)

	ОбновитьТаблицуДокументовНаСервере();

КонецПроцедуры

&НаКлиенте
Процедура ВыбратьПериод(Команда)

	ВыборПериода();

КонецПроцедуры

&НаКлиенте
Процедура Редактировать(Команда)

	ТекущиеДанные = Элементы.ТаблицаДокументов.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда

		ПоказатьЗначение(Неопределено, ТекущиеДанные.Документ);

	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Настройки

&НаСервере
Процедура ВосстановитьНастройки()

	ЗначениеНастроек = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("Обработка.ДокументыПоПартнеру", КлючНастроек);
	Если ТипЗнч(ЗначениеНастроек) = Тип("Соответствие") Тогда

		ЗначениеИзНастройки = ЗначениеНастроек.Получить("СписокВидовДокументов");
		Если ТипЗнч(ЗначениеИзНастройки) = Тип("СписокЗначений") Тогда
			ПрименитьНастройкиКСпискуВидовДокументов(ЗначениеИзНастройки);
		КонецЕсли;

		ПериодВыборкиДокументов.ДатаНачала    = ЗначениеНастроек.Получить("ДатаНачала");
		ПериодВыборкиДокументов.ДатаОкончания = ЗначениеНастроек.Получить("ДатаОкончания");

		Партнер = ЗначениеНастроек.Получить("Параметр");

	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура СохранитьНастройки()

	Настройки = Новый Соответствие;
	Настройки.Вставить("Партнер",               Параметр);
	Настройки.Вставить("СписокВидовДокументов", СписокВидовДокументов);
	Настройки.Вставить("ДатаНачала",            ПериодВыборкиДокументов.ДатаНачала);
	Настройки.Вставить("ДатаОкончания",         ПериодВыборкиДокументов.ДатаОкончания);

	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("Обработка.ДокументыПоПартнеру", КлючНастроек, Настройки);

КонецПроцедуры

&НаСервере
Процедура УстановитьЗначенияПоУмолчанию()
	
	Если Не ЗначениеЗаполнено(ПериодВыборкиДокументов.ДатаНачала)
		Или Не ЗначениеЗаполнено(ПериодВыборкиДокументов.ДатаОкончания) Тогда
		
		ПериодВыборкиДокументов.ДатаНачала    = ДобавитьМесяц(ТекущаяДатаСеанса(), - 12);
		ПериодВыборкиДокументов.ДатаОкончания = ТекущаяДатаСеанса();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьКлючНастроек()

	Если Параметры.Свойство("КлючНастроек") И Не ПустаяСтрока(Параметры.КлючНастроек) Тогда

		КлючНастроек = Параметры.КлючНастроек;

	Иначе

		КлючНастроек = "БезСделки";

	КонецЕсли;

	КлючНастроек = КлючНастроек + "_" + Пользователи.ТекущийПользователь().УникальныйИдентификатор();

	Если Параметры.Свойство("Отбор") И Параметры.Отбор.Свойство("Сделка") Тогда

		КлючНастроек = КлючНастроек + "_" + Параметры.Отбор.Сделка.УникальныйИдентификатор();

	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаСервере
Процедура ОбновитьТекстЗапроса()

	ВремТекстЗапросаВт     = "";
	ВремТекстЗапросаДанные = "";
	Для Каждого СтрокаТаб Из ТаблицаЗапросов.НайтиСтроки(Новый Структура("Использовать", Истина)) Цикл
		
		ЗапросПустой = ПустаяСтрока(ВремТекстЗапросаВт);
		Если Не ЗапросПустой Тогда
			ТекстЗапросаПоСтроке = СтрЗаменить(СтрокаТаб.ТекстЗапроса, "ПОМЕСТИТЬ ВтТаблицаОтбора", "");
		Иначе 
			ТекстЗапросаПоСтроке = СтрокаТаб.ТекстЗапроса;
		КонецЕсли;

		ВремТекстЗапросаВт = ВремТекстЗапросаВт + ?(ЗапросПустой, "", " ОБЪЕДИНИТЬ ВСЕ " + Символы.ПС)
				+ ТекстЗапросаПоСтроке;
				
		ЗапросДанныеПустой = ПустаяСтрока(ВремТекстЗапросаДанные);
		ВремТекстЗапросаДанные = ВремТекстЗапросаДанные + ?(ЗапросДанныеПустой, "", " ОБЪЕДИНИТЬ ВСЕ " + Символы.ПС)
				+ СтрокаТаб.ТекстЗапросаВыборка;
				
		ВремТекстЗапросаДанные = СтрЗаменить(ВремТекстЗапросаДанные, "&ПостфиксВыбрать,", ?(ЗапросДанныеПустой," РАЗРЕШЕННЫЕ ", ""));

	КонецЦикла;
	
	Если Не ПустаяСтрока(ВремТекстЗапросаДанные) Тогда

		ВремТекстЗапросаДанные = ВремТекстЗапросаДанные + 
		"УПОРЯДОЧИТЬ ПО
		|	Дата,
		|	Документ
		|";

	КонецЕсли;

	ТекстЗапросаФильтр       = ВремТекстЗапросаВт;
	ТекстЗапросаПоДокументам = ВремТекстЗапросаДанные;

КонецПроцедуры

&НаСервере
Процедура УстановитьПризнакИспользованияВидаДокумента()

	Для Каждого СтрокаТаб Из ТаблицаЗапросов Цикл

		ЭлементСписка = СписокВидовДокументов.НайтиПоЗначению(СтрокаТаб.ИмяДокумента);
		Если ЭлементСписка <> Неопределено Тогда
			СтрокаТаб.Использовать = ЭлементСписка.Пометка;
		КонецЕсли;

	КонецЦикла;

КонецПроцедуры

&НаСервере
Процедура ОбновитьСписокВидовДокументов()

	СписокВидовДокументов.Очистить();
	Для Каждого Строка Из ТаблицаЗапросов Цикл
		СписокВидовДокументов.Добавить(Строка.ИмяДокумента, Строка.СинонимДокумента, Строка.Использовать);
	КонецЦикла;

	СписокВидовДокументов.СортироватьПоЗначению(НаправлениеСортировки.Возр);

КонецПроцедуры

&НаСервере
Процедура ПрименитьНастройкиКСпискуВидовДокументов(ЗначениеНастройки)

	ПереформироватьЗапрос = Ложь;
	Для Каждого Элемент Из ЗначениеНастройки Цикл

		ЭлементСписка = СписокВидовДокументов.НайтиПоЗначению(Элемент.Значение);
		Если ЭлементСписка <> Неопределено И ЭлементСписка.Пометка <> Элемент.Пометка Тогда

			ЭлементСписка.Пометка = Элемент.Пометка;
			ПереформироватьЗапрос = Истина;

		КонецЕсли;

	КонецЦикла;

	Если ПереформироватьЗапрос Тогда

		УстановитьПризнакИспользованияВидаДокумента();

		ОбновитьТекстЗапроса();

		СохранитьНастройки();

	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура РедактироватьСоставДокументов()

	Результат = Неопределено;


	ОткрытьФорму(ИмяФормыНастройкаСоставаВидовДокументов,
			Новый Структура("СписокВидовДокументов", СписокВидовДокументов),,,,, Новый ОписаниеОповещения("РедактироватьСоставДокументовЗавершение", ЭтотОбъект), РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);

КонецПроцедуры

&НаКлиенте
Процедура РедактироватьСоставДокументовЗавершение(Результат, ДополнительныеПараметры) Экспорт
    
    Если ТипЗнч(Результат) = Тип("СписокЗначений") Тогда
        
        ПрименитьНастройкиКСпискуВидовДокументов(Результат);
        
    КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ВыборПериода()
	
	ОбщегоНазначенияУТКлиент.РедактироватьПериод(ПериодВыборкиДокументов);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьТаблицуДокументовНаСервере()

	Если ПустаяСтрока(ТекстЗапросаПоДокументам) Тогда

		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Необходимо настроить состав документов';
																|en = 'It is necessary to set content of documents'"),,"ЭтаФорма");
		Возврат;

	КонецЕсли;

	Запрос = Новый Запрос(ТекстЗапросаФильтр);
	Запрос.УстановитьПараметр("Параметр",         Параметр);
	Запрос.УстановитьПараметр("НачалоПериода",    ПериодВыборкиДокументов.ДатаНачала);
	Запрос.УстановитьПараметр("ОкончаниеПериода", ПериодВыборкиДокументов.ДатаОкончания);
	Запрос.МенеджерВременныхТаблиц  = Новый МенеджерВременныхТаблиц;

	УстановитьПривилегированныйРежим(Истина);
	Запрос.Выполнить();
	УстановитьПривилегированныйРежим(Ложь);

	Запрос.Текст = ТекстЗапросаПоДокументам;

	ЗначениеВРеквизитФормы(Запрос.Выполнить().Выгрузить(), "ТаблицаДокументов");

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицуЗапросов(ОбработкаОбъект)

	ТаблицаЗапросов.Очистить();
	
	ДополнительныеДокументы = Новый Массив;
	ДополнительныеДокументы.Добавить(Метаданные.Документы.РасходныйОрдерНаТовары);
	ДополнительныеДокументы.Добавить(Метаданные.Документы.ПриходныйОрдерНаТовары);
	ДополнительныеДокументы.Добавить(Метаданные.Документы.ПриходныйКассовыйОрдер);
	ДополнительныеДокументы.Добавить(Метаданные.Документы.РасходныйКассовыйОрдер);
	ДополнительныеДокументы.Добавить(Метаданные.Документы.СписаниеБезналичныхДенежныхСредств);
	ДополнительныеДокументы.Добавить(Метаданные.Документы.КорректировкаЗадолженности);
	ДополнительныеДокументы.Добавить(Метаданные.Документы.ПоступлениеБезналичныхДенежныхСредств);
	ДополнительныеДокументы.Добавить(Метаданные.Документы.ОперацияПоПлатежнойКарте);
	ДополнительныеДокументы.Добавить(Метаданные.Документы.ВзаимозачетЗадолженности);
	ДополнительныеДокументы.Добавить(Метаданные.Документы.ЗаявкаНаРасходованиеДенежныхСредств);

	ПоляШапки = Новый Массив;
	ПоляШапки.Добавить("СуммаДокумента");
	ПоляШапки.Добавить("Валюта");
	ПоляШапки.Добавить("Склад");
	ПоляШапки.Добавить("Организация");

	ОбработкаОбъект.ЗаполнитьТаблицуЗапросов(ТаблицаЗапросов, "ДокументыПоСделке",
			ДополнительныеДокументы,
			ПоляШапки,
			Истина,
			ТолькоАктуальные);

КонецПроцедуры

&НаСервере
Процедура ОбработатьИзменениеФлагаТолькоАктуальныеНаСервере()

	ЗаполнитьТаблицуЗапросов(РеквизитФормыВЗначение("Объект"));
	ОбновитьТекстЗапроса();
	ОбновитьТаблицуДокументовНаСервере();

КонецПроцедуры 

&НаСервере
Процедура ПрименитьПараметрыКоманды()

	// Чтение и установка параметров открытия.
	Если Параметры.Свойство("Отбор") Тогда

		Параметры.Отбор.Свойство("Сделка", Параметр);

	КонецЕсли;

	Если Параметры.Свойство("СформироватьПриОткрытии") И Параметры.СформироватьПриОткрытии Тогда

		ОбновитьТаблицуДокументовНаСервере();

	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Параметр) Тогда
		Элементы.Параметр.Видимость = Истина;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#КонецОбласти
