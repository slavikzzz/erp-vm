////////////////////////////////////////////////////////////////
// Модуль "ВнутренняяПереработкаСервер" содержит процедуры и функции для 
// работы с механизмом внутренней переработки.
//
////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#Область Заполнение

// Заполняет признак ВладелецИзделияДоступен в строках таблицы
// 
//	Параметры:
//		Форма   - ФормаКлиентскогоПриложения - форма владелец обрабатываемой таблицы
//		Таблица - ДанныеФормыКоллекция       - обрабатываемая таблица
//		Строки  - Массив, Неопределено       - массив обрабатываемых строк
//
Процедура ЗаполнитьВладелецИзделияДоступенВТаблице(Форма, Таблица, Строки = Неопределено) Экспорт
	
	Если Не Форма.ИспользоватьВнутреннююПереработку
		Или Таблица.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	Таблица.НомерСтроки КАК НомерСтроки,
	|	Таблица.Назначение КАК Назначение
	|ПОМЕСТИТЬ Таблица
	|ИЗ
	|	&Таблица КАК Таблица
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Назначение
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Таблица.НомерСтроки КАК НомерСтроки,
	|	НЕ ЕСТЬNULL(Назначения.ТипНазначения, ЗНАЧЕНИЕ(Перечисление.ТипыНазначений.ПустаяСсылка)) В (
	|		ЗНАЧЕНИЕ(Перечисление.ТипыНазначений.Давальческое21),
	|		ЗНАЧЕНИЕ(Перечисление.ТипыНазначений.ДавальческоеМатериалы22),
	|		ЗНАЧЕНИЕ(Перечисление.ТипыНазначений.ДавальческоеМатериалыПодЭтап22),
	|		ЗНАЧЕНИЕ(Перечисление.ТипыНазначений.ДавальческоеПродукция22),
	|		ЗНАЧЕНИЕ(Перечисление.ТипыНазначений.Давальческое2_5)) КАК ВладелецИзделияДоступен
	|ИЗ
	|	Таблица КАК Таблица
	|	
	|	ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Назначения КАК Назначения
	|	ПО Таблица.Назначение = Назначения.Ссылка
	|";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Таблица", Таблица.Выгрузить(Строки, "НомерСтроки, Назначение"));
	
	УстановитьПривилегированныйРежим(Истина);
	Выборка = Запрос.Выполнить().Выбрать();
	УстановитьПривилегированныйРежим(Ложь);
	
	Пока Выборка.Следующий() Цикл
		
		ТекущиеДанные = Таблица[Выборка.НомерСтроки - 1];
		
		ЗаполнитьЗначенияСвойств(ТекущиеДанные, Выборка, "ВладелецИзделияДоступен");
		
		Если Не ТекущиеДанные.ВладелецИзделияДоступен И ЗначениеЗаполнено(ТекущиеДанные.ВладелецИзделия) Тогда
			ТекущиеДанные.ВладелецИзделия = Неопределено;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Заполняет служебный реквизит "ВладелецИзделияДоступен" в строке по данным указанного назначение
//
// Параметры:
//  ТекущиеДанные		 - Структура - данные обрабатываемой строки.
//  СтруктураДействий	 - Структура - описывает действия, где Ключ - наименование действия,
//  														   Значение - Структура - параметры действия.
//  КэшированныеЗначения - Структура - сохраненные значения параметров, используемых при обработке.
//
Процедура ЗаполнитьВладелецИзделияДоступен(ТекущиеДанные, СтруктураДействий, КэшированныеЗначения) Экспорт
	
	Если Не ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ТекущиеДанные, "ВладелецИзделияДоступен") Тогда
		Возврат;
	КонецЕсли;
	
	ВладелецИзделияДоступен = Истина;
	
	Если ЗначениеЗаполнено(ТекущиеДанные.Назначение) Тогда
		
		СвойстваНазначение = КэшированныеЗначения.СвойстваНазначений.Получить(ТекущиеДанные.Назначение);
		
		Если СвойстваНазначение = Неопределено Тогда 
			
			СвойстваНазначений = Справочники.Назначения.СвойстваНазначений(ТекущиеДанные.Назначение);
			СвойстваНазначение = СвойстваНазначений.Получить(ТекущиеДанные.Назначение);
			
			КэшированныеЗначения.СвойстваНазначений.Вставить(ТекущиеДанные.Назначение, СвойстваНазначение);
			
		КонецЕсли;
		
		ВладелецИзделияДоступен =
			Не СвойстваНазначение.ЭтоНазначениеДавальца2_5
			//++ Устарело_Переработка24
			И Не СвойстваНазначение.ЭтоНазначениеДавальца
			//-- Устарело_Переработка24
			И Истина;
		
	КонецЕсли;
	
	ТекущиеДанные.ВладелецИзделияДоступен = ВладелецИзделияДоступен;
	
	Если Не ТекущиеДанные.ВладелецИзделияДоступен Тогда
		ТекущиеДанные.ВладелецИзделия = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область УсловноеОформление

// Устанавливает условное оформление поля "Владелец изделия"
//	
// Параметры:
//  Форма          - ФормаКлиентскогоПриложения - форма, для которой настраивается условное оформление
//	ИмяОбъекта     - Строка           - имя объекта
//  ИмяТЧ          - Строка           - имя таблицы формы
//  ПутиКДанным    - Структура        - имя таблицы формы
// 
Процедура УстановитьУсловноеОформлениеПоляВладелецИзделия(Форма, ИмяОбъекта, ИмяТЧ, ПутиКДанным = Неопределено) Экспорт
	
	УсловноеОформление = Форма.УсловноеОформление;
	ЭлементыФормы = Форма.Элементы;
	
	// Установка видимости колонки "Владелец изделия"
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(ЭлементыФормы[ИмяТЧ + "ВладелецИзделия"]["Имя"]);
	
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = ПроизводствоУправлениеФормами.ПолеКомпоновкиДанныхПоПути(ИмяОбъекта, ПутиКДанным, "ВнутренняяПереработка");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;
	
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);
	
	// Установка доступности/обязательности колонки "Владелец изделия"
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(ЭлементыФормы[ИмяТЧ + "ВладелецИзделия"]["Имя"]);
	
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(ИмяОбъекта + "." + ИмяТЧ + ".ВладелецИзделияДоступен");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;
	
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр",        Истина);
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Текст",                 НСтр("ru = '<для собственных изделий>';
																									|en = '<for own products>'"));
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста",            ЦветаСтиля.ТекстЗапрещеннойЯчейкиЦвет);
	
	// Установка представления владельца изделия - давалец
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(ЭлементыФормы[ИмяТЧ + "ВладелецИзделия"]["Имя"]);
	
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(ИмяОбъекта + "." + ИмяТЧ + ".ВладелецИзделияДоступен");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(ИмяОбъекта + "." + ИмяТЧ + ".ВладелецИзделия");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено;
	
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(ИмяОбъекта + "." + ИмяТЧ + ".ВладелецИзделия");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = ПроизводствоУправлениеФормами.ПолеКомпоновкиДанныхПоПути(ИмяОбъекта, ПутиКДанным, "ОрганизацияДавалец");
	
	ПолеТекст = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ПутиКДанным, "ТекстВладелецДавалец", "ТекстВладелецДавалец");
	ПолеТекст = Новый ПолеКомпоновкиДанных(ПолеТекст);
	
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Текст", ПолеТекст);
	
	// Установка представления владельца изделия - переработчик
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(ЭлементыФормы[ИмяТЧ + "ВладелецИзделия"]["Имя"]);
	
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.ПобочныеИзделия.ВладелецИзделияДоступен");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(ИмяОбъекта + "." + ИмяТЧ + ".ВладелецИзделия");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено;
	
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(ИмяОбъекта + "." + ИмяТЧ + ".ВладелецИзделия");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = ПроизводствоУправлениеФормами.ПолеКомпоновкиДанныхПоПути(ИмяОбъекта, ПутиКДанным, "Организация");
	
	ПолеТекст = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ПутиКДанным, "ТекстВладелецПереработчик", "ТекстВладелецПереработчик");
	ПолеТекст = Новый ПолеКомпоновкиДанных(ПолеТекст);
	
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Текст", ПолеТекст);
	
КонецПроцедуры

// Устанавливает условное оформление для "Владелец изделия" для отменных строк
//	
// Параметры:
//  Форма          - ФормаКлиентскогоПриложения - форма, для которой настраивается условное оформление
//	ИмяОбъекта     - Строка           - имя объекта
//  ИмяТЧ          - Строка           - имя таблицы формы
//  ПутьКЭлементам - Строка           - путь к элементам формы
// 
Процедура УстановитьУсловноеОформлениеПоляВладелецИзделияОтмененныхСтрок(
			Форма, ИмяОбъекта, ИмяТЧ, ПутьКЭлементам = "") Экспорт

	ПутьКЭлементамФормы = ?(ПутьКЭлементам <> "", ПутьКЭлементам, ИмяТЧ);
	
	УсловноеОформление = Форма.УсловноеОформление;
	ЭлементыФормы = Форма.Элементы;

	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(ЭлементыФормы[ПутьКЭлементамФормы + "ВладелецИзделия"]["Имя"]);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(ИмяОбъекта + "." + ИмяТЧ + ".Отменено");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиЭтаповЗакрытияМесяца

#Область ПроверкаОстатковКОформлениюОтчетовДавальцу

// Добавляет этап в таблицу этапов закрытия месяца.
// Элементы данной таблицы являются элементами второго уровня в дереве этапов в форме закрытия месяца.
// 
// Параметры:
// 	ТаблицаЭтапов - см. Обработки.ОперацииЗакрытияМесяца.ЗаполнитьОписаниеЭтаповЗакрытияМесяца
// 	ТекущийРодитель - Строка - идентификатор группы.
//
Процедура ДобавитьЭтап_ОстаткиКОформлениюОтчетовДавальцам(ТаблицаЭтапов,ТекущийРодитель) Экспорт
	
	НоваяСтрока =  ЗакрытиеМесяцаСервер.ДобавитьЭтапВТаблицу(
		ТаблицаЭтапов,
		ТекущийРодитель,
		Перечисления.ОперацииЗакрытияМесяца.ОформлениеОтчетовДавальцамМеждуОрганизациями);
	
	НоваяСтрока.ВыполняетсяВручную = Истина;
	НоваяСтрока.ДействиеОформление =  ЗакрытиеМесяцаСервер.ОписаниеДействия_СервернаяПроцедура(
		"ВнутренняяПереработкаСервер.Оформление_ОстаткиКОформлениюОтчетовДавальцам");
	НоваяСтрока.ДействиеИспользование =  ЗакрытиеМесяцаСервер.ОписаниеДействия_СервернаяПроцедура(
		"ВнутренняяПереработкаСервер.Использование_ОстаткиКОформлениюОтчетовДавальцам");
	
	НоваяСтрока.ДействиеВыполнить  =  ЗакрытиеМесяцаСервер.ОписаниеДействия_ОткрытьФорму(
		Метаданные.Документы.ОтчетДавальцуМеждуОрганизациями.Формы.ФормаРабочееМесто.ПолноеИмя(), Истина);
	
КонецПроцедуры

// Обработчики этапа
// 
// Параметры:
// 	ПараметрыОбработчика - см. ЗакрытиеМесяцаСервер.ИнициализироватьПараметрыОбработчикаЭтапаЗакрытияМесяцаДляПроверки
//
Процедура Использование_ОстаткиКОформлениюОтчетовДавальцам(ПараметрыОбработчика) Экспорт
	
	ЗакрытиеМесяцаСервер.УвеличитьКоличествоОбработанныхДанныхДляЗамера(ПараметрыОбработчика, 1);
	
	ЭтоПараметрыОбработчика = ПараметрыОбработчика.Свойство("ПараметрыРасчета");
	
	Если ЭтоПараметрыОбработчика Тогда
		ПараметрыРасчета = ПараметрыОбработчика.ПараметрыРасчета;
	Иначе
		ПараметрыРасчета = ПараметрыОбработчика;
	КонецЕсли;
	
	Если ПараметрыРасчета.Свойство("НачалоПериода") Тогда
		НачалоПериода = НачалоМесяца(ПараметрыРасчета.НачалоПериода);
	Иначе
		НачалоПериода = НачалоМесяца(ПараметрыРасчета.ПериодРегистрации);
	КонецЕсли;
	
	ПараметрыЗапросаОстатков = Документы.ОтчетДавальцуМеждуОрганизациями.ПараметрыЗапросаОстатковОтчетовКОформлению();
	ПараметрыЗапросаОстатков.Организация = ПараметрыРасчета.МассивОрганизаций;
	ПараметрыЗапросаОстатков.Месяц = НачалоПериода;
	ПараметрыЗапросаОстатков.ТолькоЗавершенные = Истина;
	
	Запрос = Документы.ОтчетДавальцуМеждуОрганизациями.ЗапросОстаткиОтчетовКОформлению(ПараметрыЗапросаОстатков);
	
	// Менеджер временных таблиц.
	ДанныеИнициализированы = ЭтоПараметрыОбработчика И ПараметрыОбработчика.Свойство("МенеджерВременныхТаблиц");
	Если ДанныеИнициализированы Тогда
		Запрос.МенеджерВременныхТаблиц = ПараметрыОбработчика.МенеджерВременныхТаблиц;
	ИначеЕсли ЭтоПараметрыОбработчика Тогда
		ПараметрыОбработчика.Вставить("МенеджерВременныхТаблиц", Новый МенеджерВременныхТаблиц);
		Запрос.МенеджерВременныхТаблиц = ПараметрыОбработчика.МенеджерВременныхТаблиц;
	Иначе
		Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	КонецЕсли;
	
	Запрос = СхемыЗапросов.УстановитьПомещениеВоВременнуюТаблицу(Запрос, "ОстаткиКОформлениюОтчетовДавальцам");
	Запрос.Выполнить();
	
	РазмерыВременныхТаблиц = ЗакрытиеМесяцаСервер.РазмерыВременныхТаблиц(Запрос, ПараметрыОбработчика);
	
	Если РазмерыВременныхТаблиц.ОстаткиКОформлениюОтчетовДавальцам = 0 Тогда
	
		ЗакрытиеМесяцаСервер.УстановитьСостояниеНеТребуется(
			ПараметрыОбработчика,
			НСтр("ru = 'Нет остатков к оформлению отчетов давальцам между организациями.';
				|en = 'There are no remaining goods to register ""Intercompany consumption reports — Subcontracting services delivered"".'", ОбщегоНазначения.КодОсновногоЯзыка()));
		
	КонецЕсли;
	
КонецПроцедуры

// Оформляет этап закрытия месяца.
// 
// Параметры:
// 	ПараметрыОбработчика - см. ЗакрытиеМесяцаСервер.ИнициализироватьПараметрыОбработчикаЭтапаЗакрытияМесяцаДляПроверки
//
Процедура Оформление_ОстаткиКОформлениюОтчетовДавальцам(ПараметрыОбработчика) Экспорт
	
	ПараметрыОбработчика.ДанныеЭтапа.ТекстВыполнить = НСтр("ru = 'Оформить';
															|en = 'Register'");
	
	ЗакрытиеМесяцаСервер.УвеличитьКоличествоОбработанныхДанныхДляЗамера(ПараметрыОбработчика);
	
КонецПроцедуры

// Проверки состояния системы, относящиеся к этапу.
// 
// Параметры:
// 	ТаблицаПроверок - см. АудитСостоянияСистемы.ТаблицаПроверокСостоянияСистемы
//
Процедура ОписаниеПроверок_ОстаткиКОформлениюОтчетовДавальцам(ТаблицаПроверок) Экспорт
	
	ОписаниеПроверки = ЗакрытиеМесяцаСервер.ДобавитьОписаниеНовойПроверки(
		ТаблицаПроверок,
		"ОформлениеОтчетовДавальцамМеждуОрганизациями",
		Перечисления.ОперацииЗакрытияМесяца.ОформлениеОтчетовДавальцамМеждуОрганизациями,
		Перечисления.МоментЗапускаПроверкиОперацииЗакрытияМесяца.ДоРасчета,
		"ВнутренняяПереработкаСервер.ПроверкаОстаткиКОформлениюОтчетовДавальцам");
	
	ЗакрытиеМесяцаСервер.ЗаполнитьПредставлениеНовойПроверки(ОписаниеПроверки,
		НСтр("ru = 'Не оформлены отчеты давальцам между организациями.';
			|en = '""Intercompany consumption reports — Subcontracting services delivered"" are not registered.'", ОбщегоНазначения.КодОсновногоЯзыка()),
		НСтр("ru = 'По всем завершенным партиям производства должны быть оформлены отчеты давальцу между организациями.';
			|en = 'Intercompany consumption reports — Subcontracting services delivered must be registered for all finished lots.'", ОбщегоНазначения.КодОсновногоЯзыка()));
		
КонецПроцедуры

// Регистрация ошибок.
// 
// Параметры:
// 	ПараметрыПроверки - см. АудитСостоянияСистемы.ИнициализироватьПараметрыПроверки
//
Процедура ПроверкаОстаткиКОформлениюОтчетовДавальцам(ПараметрыПроверки) Экспорт
	
	Если НЕ ЗакрытиеМесяцаСервер.ПроверкаВыполняетсяМеханизмомЗакрытияМесяца(ПараметрыПроверки) Тогда
		Возврат;
	КонецЕсли;
	
	СписокПолей = Новый СписокЗначений;
	СписокПолей.Добавить("Организация",        НСтр("ru = 'Переработчик';
													|en = 'Subcontractor'",        ОбщегоНазначения.КодОсновногоЯзыка()));
	СписокПолей.Добавить("Давалец",            НСтр("ru = 'Давалец';
													|en = 'Material provider'",             ОбщегоНазначения.КодОсновногоЯзыка()));
	СписокПолей.Добавить("ПартияПроизводства", НСтр("ru = 'Партия производства';
													|en = 'Production lot'", ОбщегоНазначения.КодОсновногоЯзыка()));
	
	ПараметрыРегистрации = ЗакрытиеМесяцаСервер.ИнициализироватьПараметрыРегистрацииПроблемПроверки(
		"ОстаткиКОформлениюОтчетовДавальцам",
		НСтр("ru = 'Обнаружены остатки к оформлению отчетов давальцам между организации от имени переработчика ""%1"" на конец периода %2';
			|en = 'There is remaining stock to register intercompany consumption reports on behalf of the ""%1"" subcontractor at the end of the period %2'", ОбщегоНазначения.КодОсновногоЯзыка()),
		СписокПолей);
	
	ЗакрытиеМесяцаСервер.ЗарегистрироватьПроблемыВыполненияПроверки(
		ПараметрыПроверки,
		ПараметрыРегистрации);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецОбласти