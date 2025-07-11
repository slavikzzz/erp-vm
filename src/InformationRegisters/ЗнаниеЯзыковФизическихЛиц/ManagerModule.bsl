#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(ФизическоеЛицо)";
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

#Область ОбработчикиПравилРегистрации

// См. ЗарплатаКадрыРасширенныйСинхронизацияДанных.ШаблонОбработчика
Процедура ПриЗаполненииНастроекОбработчиковПравилРегистрации(Настройки) Экспорт
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыРасширеннаяПодсистемы") Тогда
		МодульЗарплатаКадрыРасширенныйСинхронизацияДанных = ОбщегоНазначения.ОбщийМодуль("ЗарплатаКадрыРасширенныйСинхронизацияДанных");
		МодульЗарплатаКадрыРасширенныйСинхронизацияДанных.ДляНезависимогоРегистра(Настройки, "ФизическоеЛицо", "ОбщиеДанные");
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

// Функция - Представление владение языками физического лица
//
// Параметры:
//  ФизическоеЛицоСсылка - СправочникСсылка.ФизическиеЛица - владелец знаний языков.
// 
// Возвращаемое значение:
//  Строка - представление знаний языков.
//
Функция ПредставлениеВладениеЯзыкамиФизическогоЛица(ФизическоеЛицоСсылка) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ФизическоеЛицоСсылка", ФизическоеЛицоСсылка);
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ЗнаниеЯзыков.Язык КАК Язык,
		|	ЗнаниеЯзыков.СтепеньЗнанияЯзыка КАК СтепеньЗнанияЯзыка,
		|	ЗнаниеЯзыков.Язык.Код КАК ЯзыкКод,
		|	ЗнаниеЯзыков.СтепеньЗнанияЯзыка.Код КАК СтепеньЗнанияЯзыкаКод
		|ИЗ
		|	РегистрСведений.ЗнаниеЯзыковФизическихЛиц КАК ЗнаниеЯзыков
		|ГДЕ
		|	ЗнаниеЯзыков.ФизическоеЛицо = &ФизическоеЛицоСсылка
		|
		|УПОРЯДОЧИТЬ ПО
		|	СтепеньЗнанияЯзыкаКод УБЫВ,
		|	ЯзыкКод";
	
	Возврат ПредставлениеУпорядоченнойКоллекцииЗаписейЗнанияЯзыков(Запрос.Выполнить().Выгрузить());
	
КонецФункции

// Функция - Представление владение языками по коллекции записей
//
// Параметры:
//  КоллекцияЗаписей - любая коллекция, для которой доступен обход посредством оператора Для каждого … Из … Цикл.
//  Упорядочивать	 - Булево - необязательный, если Истина - коллекция будет предварительно упорядочена.
// 
// Возвращаемое значение:
//  Строка - представление знаний языков.
//
Функция ПредставлениеВладениеЯзыкамиПоКоллекцииЗаписей(КоллекцияЗаписей, Упорядочивать = Истина) Экспорт
	
	Если Упорядочивать Тогда
		Возврат ПредставлениеНеУпорядоченнойКоллекцииЗаписейЗнанияЯзыков(КоллекцияЗаписей);
	КонецЕсли;
	
	Возврат ПредставлениеУпорядоченнойКоллекцииЗаписейЗнанияЯзыков(КоллекцияЗаписей);
	
КонецФункции

// Создает новую структуру для сведений о состоянии в браке.
// 
// Возвращаемое значение:
//  Структура - Новое знание языка:
// * Язык - СправочникСсылка.ЯзыкиНародовМира -
// * ЯзыкСтрока - Строка -
// * СтепеньЗнанияЯзыка - СправочникСсылка.СтепениЗнанияЯзыка -
Функция НовоеЗнаниеЯзыка() Экспорт
	
	СтруктураЗаписи = ОбщегоНазначенияБЗК.СтруктураПоИмениРегистраСведений("ЗнаниеЯзыковФизическихЛиц");
	
	ЗнаниеЯзыка = Новый Структура();
	ЗнаниеЯзыка.Вставить("Язык", СтруктураЗаписи.Язык);
	Если ЗначениеЗаполнено(СтруктураЗаписи.Язык) Тогда
		СтепеньЗнанияЯзыка = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СтруктураЗаписи.Язык, "Наименование");
	Иначе
		СтепеньЗнанияЯзыка = "";
	КонецЕсли;
	ЗнаниеЯзыка.Вставить("ЯзыкСтрока", СтепеньЗнанияЯзыка);
	ЗнаниеЯзыка.Вставить("СтепеньЗнанияЯзыка", СтруктураЗаписи.СтепеньЗнанияЯзыка);
	
	Возврат ЗнаниеЯзыка;

КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПредставлениеУпорядоченнойКоллекцииЗаписейЗнанияЯзыков(КоллекцияЗаписей)
	
	Представление = "";
	
	Для Каждого СтрокаКоллекции Из КоллекцияЗаписей Цикл
		Если Не ПустаяСтрока(Представление) Тогда
			Представление = Представление + ", ";
		КонецЕсли;
		Если Не ЗначениеЗаполнено(СтрокаКоллекции.Язык) Тогда
			Продолжить;
		КонецЕсли;
		Представление = Представление + Строка(СтрокаКоллекции.Язык);
		Если ЗначениеЗаполнено(СтрокаКоллекции.СтепеньЗнанияЯзыка) Тогда
			Представление = Представление + " (" + Строка(СтрокаКоллекции.СтепеньЗнанияЯзыка) + ")";
		КонецЕсли;
	КонецЦикла;
	
	Если ПустаяСтрока(Представление) Тогда
		Представление = НСтр("ru = 'Не владеет языками';
							|en = 'Does not have a command of any language '");
	КонецЕсли; 
	
	Возврат Представление;
	
КонецФункции

Функция ПредставлениеНеУпорядоченнойКоллекцииЗаписейЗнанияЯзыков(КоллекцияЗаписей)
	
	Языки = ОбщегоНазначения.ВыгрузитьКолонку(КоллекцияЗаписей, "Язык");
	КодыЯзыков = ОбщегоНазначения.ЗначениеРеквизитаОбъектов(Языки, "Код");
	
	СтепениЗнания = ОбщегоНазначения.ВыгрузитьКолонку(КоллекцияЗаписей, "СтепеньЗнанияЯзыка");
	КодыСтепеней = ОбщегоНазначения.ЗначениеРеквизитаОбъектов(СтепениЗнания, "Код");
	
	ТаблицаЗначений = Новый ТаблицаЗначений;
	ТаблицаЗначений.Колонки.Добавить("Язык", Новый ОписаниеТипов("СправочникСсылка.ЯзыкиНародовМира"));
	ТаблицаЗначений.Колонки.Добавить("СтепеньЗнанияЯзыка", Новый ОписаниеТипов("СправочникСсылка.СтепениЗнанияЯзыка"));
	ТаблицаЗначений.Колонки.Добавить("КодЯзыка", Метаданные.Справочники.ЯзыкиНародовМира.СтандартныеРеквизиты["Код"].Тип);
	ТаблицаЗначений.Колонки.Добавить("КодСтепениЗнания", Метаданные.Справочники.СтепениЗнанияЯзыка.СтандартныеРеквизиты["Код"].Тип);
	
	Для Каждого СтрокаКоллекции Из КоллекцияЗаписей Цикл
		НоваяСтрока = ТаблицаЗначений.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаКоллекции);
		НоваяСтрока.КодЯзыка = КодыЯзыков[СтрокаКоллекции.Язык];
		НоваяСтрока.КодСтепениЗнания = КодыСтепеней[СтрокаКоллекции.СтепеньЗнанияЯзыка];
	КонецЦикла;
	
	ТаблицаЗначений.Сортировать("КодСтепениЗнания Убыв, КодЯзыка Возр");
	
	Возврат ПредставлениеУпорядоченнойКоллекцииЗаписейЗнанияЯзыков(ТаблицаЗначений);
	
КонецФункции

#КонецОбласти

#КонецЕсли