#Область ПрограммныйИнтерфейс

Функция АдресДанныхПроверкиМаркируемойПродукцииЧекККМ(ПараметрыСканирования, Знач Объект, УникальныйИдентификатор, ВидМаркируемойПродукции) Экспорт
	
	Возврат ПроверкаИПодборПродукцииИСМПУТ.АдресДанныхПроверкиМаркируемойПродукцииЧекККМ(
		ПараметрыСканирования,
		Объект,
		УникальныйИдентификатор,
		ВидМаркируемойПродукции);
	
КонецФункции

// Использовать ордерную схему при поступлении.
// 
// Параметры:
//  Склад - СправочникСсылка.Склады -
//  Дата - Неопределено, Дата -
//  МожетБытьГруппа - Булево - Может быть группа
// 
// Возвращаемое значение:
//  Булево, Произвольный - Использовать ордерную схему при поступлении
Функция ИспользоватьОрдернуюСхемуПриПоступлении(Склад, Дата = Неопределено, МожетБытьГруппа = Ложь) Экспорт
	
	Возврат СкладыСервер.ИспользоватьОрдернуюСхемуПриПоступлении(Склад, Дата, МожетБытьГруппа);
	
КонецФункции

// Использовать ордерную схему при отгрузке.
// 
// Параметры:
//  Склад - СправочникСсылка.Склады -
//  Дата - Неопределено, Дата -
// 
// Возвращаемое значение:
//  Булево, Произвольный - Использовать ордерную схему при отгрузке
Функция ИспользоватьОрдернуюСхемуПриОтгрузке(Склад, Дата = Неопределено, МожетБытьГруппа = Ложь) Экспорт
	
	Возврат СкладыСервер.ИспользоватьОрдернуюСхемуПриОтгрузке(Склад, Дата);
	
КонецФункции

// Получить данные по фактически обработанным маркам
// 
// Параметры:
// ПроверяемыйДокумент - ДокументСсылка - распоряжение ордеров.
// Возвращаемое значение:
// Структура:
//	*Успешно - Булево
//	*Штрихкоды - см. ЗаполнитьТаблицуШтрихКодовДляЗагрузки.Штрихкоды
//	*ТекстОшибки - Строка
Функция КодыМаркировкиПоОрдерам(ПроверяемыйДокумент) Экспорт
	
	ВозвращаемоеЗначение = Новый Структура;
	ВозвращаемоеЗначение.Вставить("Успешно",      Ложь);
	ВозвращаемоеЗначение.Вставить("Штрихкоды",    Новый Массив);
	ВозвращаемоеЗначение.Вставить("ТекстОшибки",  "");
	
	Штрихкоды 	= Новый Массив();
	ТекстЗапроса = "";

	Если ТипЗнч(ПроверяемыйДокумент) = Тип("ДокументСсылка.ПриобретениеТоваровУслуг") Тогда
		
		ПриобретениеТоваровУслугЛокализация.ТекстЗапросаОрдераПоРаспоряжению(ТекстЗапроса);
		
	ИначеЕсли ТипЗнч(ПроверяемыйДокумент) = Тип("ДокументСсылка.ПриемкаТоваровИСМП") Тогда 
	
		ДокументОснование = ОбщегоНазначенияУТВызовСервера.ЗначениеРеквизитаОбъекта(ПроверяемыйДокумент, "ДокументОснование");
		Если ТипЗнч(ДокументОснование) = Тип("ДокументСсылка.ПриобретениеТоваровУслуг") Тогда
			
			ПроверяемыйДокумент = ДокументОснование;
			ПриобретениеТоваровУслугЛокализация.ТекстЗапросаОрдераПоРаспоряжению(ТекстЗапроса);
			
		КонецЕсли;
			
	ИначеЕсли ТипЗнч(ПроверяемыйДокумент) = Тип("ДокументСсылка.РеализацияТоваровУслуг") Тогда
		
		РеализацияТоваровУслугЛокализация.ТекстЗапросаОрдераПоРаспоряжению(ТекстЗапроса);
		
	Иначе
		
		ВозвращаемоеЗначение.Успешно = Ложь;
		ВозвращаемоеЗначение.ТекстОшибки = СтрШаблон(НСтр("ru = 'На основании документа %1 
															|невозможно подобрать фактически обработанные марки';
															|en = 'Cannot select actually processed stamps from the %1 
															| document'"),
				ПроверяемыйДокумент);
				
		Возврат ВозвращаемоеЗначение;
		
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ТекстЗапроса) Тогда
		
		ВозвращаемоеЗначение.Успешно = Ложь;
		ВозвращаемоеЗначение.ТекстОшибки = СтрШаблон(НСтр("ru = 'На основании документа %1 
															|невозможно подобрать фактически обработанные марки';
															|en = 'Cannot select actually processed stamps from the %1 
															| document'"),
				ПроверяемыйДокумент);
				
		Возврат ВозвращаемоеЗначение;
		
	КонецЕсли;
	
	Запрос = Новый Запрос(ТекстЗапроса);
	
	Если ТипЗнч(ПроверяемыйДокумент) = Тип("ДокументСсылка.РеализацияТоваровУслуг") Тогда
		Запрос.УстановитьПараметр("Распоряжения", 
								РеализацияТоваровУслугЛокализация.ПолучитьРаспоряженияПоДокументу(ПроверяемыйДокумент));
	Иначе
		Запрос.УстановитьПараметр("Распоряжение", ПроверяемыйДокумент);
	КонецЕсли;
	
	ТаблицаОрдеровПоРаспоряжению = Запрос.Выполнить().Выгрузить();
	Если ТаблицаОрдеровПоРаспоряжению.Количество() = 0 Тогда
		
		ВозвращаемоеЗначение.Успешно = Ложь;
		ВозвращаемоеЗначение.ТекстОшибки = СтрШаблон(НСтр("ru = 'На основании документа %1 
															|не найдены фактически обработанные марки';
															|en = 'Cannot find actually processed stamps from the %1 
															| document'"),
				ПроверяемыйДокумент);
				
		Возврат ВозвращаемоеЗначение;
		
	КонецЕсли;
	
	ЕстьОшибки = Ложь;
	
	Для Каждого Строка Из ТаблицаОрдеровПоРаспоряжению Цикл
		
		ШтрихкодыУпаковокПоДокументу = ШтрихкодированиеИС.ВложенныеШтрихкодыУпаковокПоДокументу(Строка.Ордер,,, Истина);
			
			Если ШтрихкодыУпаковокПоДокументу.ЕстьОшибки Тогда
				ВозвращаемоеЗначение.Успешно = Ложь;
				ВозвращаемоеЗначение.ТекстОшибки = ШтрихкодыУпаковокПоДокументу.ТекстОшибки;
				ЕстьОшибки = Истина;
				Прервать;
			КонецЕсли; 
			
			ЗаполнитьТаблицуШтрихКодовДляЗагрузки(Штрихкоды, ШтрихкодыУпаковокПоДокументу.ВложенныеШтрихкоды.ДеревоУпаковок.Строки, "");
	
	КонецЦикла;
	
	Если Не ЕстьОшибки Тогда
		ВозвращаемоеЗначение.Успешно   = Истина;
		ВозвращаемоеЗначение.Штрихкоды = Штрихкоды;
	КонецЕсли;
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

// Склад группы с общей политикой учета серий.
// 
// Параметры:
//  ГруппаСкладов - СправочникСсылка.Склады - Группа складов
//  ВидМаркируемойПродукции - ПеречислениеСсылка.ВидыПродукцииИС - Вид маркируемой продукции
// 
// Возвращаемое значение:
//  СправочникСсылка.Склады - склад из указанной группы складов, если по складам группы 
//   по маркируемой продукции указанного вида нет особенностей настроек серий
Функция СкладГруппыСОбщейПолитикойУчетаСерий(ГруппаСкладов, ВидМаркируемойПродукции) Экспорт
	
	Если Не ЗначениеЗаполнено(ВидМаркируемойПродукции) Тогда
		Возврат ГруппаСкладов;
	КонецЕсли;
	ОсобенностьУчета = ИнтеграцияИСУТКлиентСервер.ОсобенностьУчетаПоВидуПродукции(ВидМаркируемойПродукции);
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ОсобенностьУчета", ОсобенностьУчета);
	Запрос.УстановитьПараметр("ГруппаСкладов", ГруппаСкладов);
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВидыНоменклатуры.ВладелецСерий
	|ПОМЕСТИТЬ ВладельцыСерий
	|ИЗ
	|	Справочник.ВидыНоменклатуры КАК ВидыНоменклатуры
	|ГДЕ
	|	ВидыНоменклатуры.ОсобенностьУчета = &ОсобенностьУчета
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка) КАК Склад
	|ИЗ
	|	Справочник.ВидыНоменклатуры.ПолитикиУчетаСерий КАК ВидыНоменклатурыПолитикиУчетаСерий
	|ГДЕ
	|	ВидыНоменклатурыПолитикиУчетаСерий.Ссылка В (ВЫБРАТЬ ВладелецСерий ИЗ ВладельцыСерий)
	|	И ВидыНоменклатурыПолитикиУчетаСерий.Склад В ИЕРАРХИИ (&ГруппаСкладов)
	|	И ВидыНоменклатурыПолитикиУчетаСерий.Склад <> (&ГруппаСкладов)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	Склады.Ссылка
	|ИЗ
	|	Справочник.Склады КАК Склады
	|ГДЕ
	|	Склады.Ссылка В ИЕРАРХИИ (&ГруппаСкладов)
	|	И Не Склады.ЭтоГруппа
	|";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Склад;
	КонецЕсли;
	Возврат Справочники.Склады.ПустаяСсылка();
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Параметры:
// Штрихкоды - Массив из Структура:
//	*Штрихкод - Строка
//	*Количество - Строка
//	*ШтрихкодМаркиАлкогольнойПродукции - Строка
//	*ШтрихкодУпаковки - Строка
// СтрокиШК - Массив из СтрокаТаблицыЗначений
// УпаковкаВерхнегоУровня - Строка
Процедура ЗаполнитьТаблицуШтрихКодовДляЗагрузки(Штрихкоды, СтрокиШК, Знач УпаковкаВерхнегоУровня)
	
	Для Каждого СтрокаШК Из СтрокиШК Цикл
				
		Если ИнтеграцияИСКлиентСервер.ЭтоУпаковка(СтрокаШК.ТипУпаковки) Тогда
			
			ПоляСтроки = Новый Структура;
			ПоляСтроки.Вставить("Штрихкод",                          СтрокаШК.Штрихкод);
			ПоляСтроки.Вставить("Количество",                        СтрокаШК.Количество);
			ПоляСтроки.Вставить("ШтрихкодМаркиАлкогольнойПродукции", "");
			ПоляСтроки.Вставить("ШтрихкодУпаковки",                  УпаковкаВерхнегоУровня);
			Штрихкоды.Добавить(ПоляСтроки);

			ЗаполнитьТаблицуШтрихКодовДляЗагрузки(Штрихкоды, СтрокаШК.Строки, СтрокаШК.Штрихкод);
			
		ИначеЕсли СтрокаШК.ТипУпаковки = Перечисления.ТипыУпаковок.МаркированныйТовар Тогда
			
			ПоляСтроки = Новый Структура;
			ПоляСтроки.Вставить("Штрихкод",                          СтрокаШК.Штрихкод);
			ПоляСтроки.Вставить("Количество",                        СтрокаШК.Количество);
			ПоляСтроки.Вставить("ШтрихкодМаркиАлкогольнойПродукции", "");
			ПоляСтроки.Вставить("ШтрихкодУпаковки",                  УпаковкаВерхнегоУровня);
			Штрихкоды.Добавить(ПоляСтроки);
			
		Иначе
			
			Продолжить; 
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

