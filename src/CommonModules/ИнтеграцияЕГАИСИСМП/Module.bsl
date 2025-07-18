// @strict-types

#Область ПрограммныйИнтерфейс

// Доступна работа с кодами маркировки пива.
// 
// Параметры:
//  Отказ - Булево - Отказ от открытия форм связанных с производством/импортом пива
// 
// Возвращаемое значение:
//  Булево - Доступна работа с кодами маркировки ИСМП (пива, слабоалкогольной продукции)
//
Функция ДоступнаРаботаСКодамиМаркировкиИСМП(Отказ = Неопределено) Экспорт
	
	Если Не ОбщегоНазначения.ПодсистемаСуществует("ГосИС.ИСМП") Тогда
		Если Не(Отказ = Неопределено) Тогда
			ОбщегоНазначения.СообщитьПользователю(
				НСтр("ru = 'Для работы с документами производства/импорта пива
					 |требуется встроить подсистему ИС МП библиотеки';
					 |en = 'Для работы с документами производства/импорта пива
					 |требуется встроить подсистему ИС МП библиотеки'"),,,,
				Отказ);
		КонецЕсли;
		Возврат Ложь;
	КонецЕсли;
	
	ВидыПродукции = ДопустимыеВидыПродукцииИмпортаПроизводства();
	
	Если ВидыПродукции.Количество() = 0 Тогда
		Если Не(Отказ = Неопределено) Тогда
			ОбщегоНазначения.СообщитьПользователю(
				НСтр("ru = 'Для работы с документами производства/импорта
					 |требуется включить использование хотя бы одного вида алкогольной продукции
					 |в панели администрирования ИС МП';
					 |en = 'Для работы с документами производства/импорта
					 |требуется включить использование хотя бы одного вида алкогольной продукции
					 |в панели администрирования ИС МП'"),,,,
				Отказ);
		КонецЕсли;
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

// Допустимые виды продукции, которые можно указать в документе импорта или производства ЕГАИС.
// 
// Параметры:
//  Сырье - Булево - для табличной части Сырья
// 
// Возвращаемое значение:
//  Массив Из ПеречислениеСсылка.ВидыПродукцииИС - Допустимые виды продукции импорта производства
Функция ДопустимыеВидыПродукцииИмпортаПроизводства(Сырье = Ложь) Экспорт
	
	Результат = Новый Массив; //Массив Из ПеречислениеСсылка.ВидыПродукцииИС - 
	
	Если Не ОбщегоНазначения.ПодсистемаСуществует("ГосИС.ИСМП") Тогда
		Возврат Результат;
	КонецЕсли;
	
	Модуль = ОбщегоНазначения.ОбщийМодуль("ИнтеграцияИСМПКлиентСервер");
	Возврат Модуль.ВидыПродукцииЕГАИС(Не Сырье);
	
КонецФункции

// Сформировать данные документа основания.
// 
// Параметры:
//  ТаблицаДанныхДокументаОснования - ТаблицаЗначений - Таблица данных документа основания
//  ДокументОснование - ЛюбаяСсылка - Документ основание
//  ДанныеСформированы - Булево - Данные сформированы
Процедура СформироватьДанныеДокументаОснования(ТаблицаДанныхДокументаОснования, ДокументОснование, ДанныеСформированы) Экспорт
	
	Если ЗначениеЗаполнено(ДокументОснование) Тогда
		Если ТипЗнч(ДокументОснование) = Тип("ДокументСсылка.УведомлениеОПланируемомИмпортеЕГАИС") Тогда
		
		ДанныеСформированы = Истина;
		
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ
		|	УведомлениеОПланируемомИмпортеЕГАИСТовары.Номенклатура                        КАК Номенклатура,
		|	УведомлениеОПланируемомИмпортеЕГАИСТовары.Характеристика                      КАК Характеристика,
		|	УведомлениеОПланируемомИмпортеЕГАИСТовары.Серия                               КАК Серия,
		|	СУММА(УведомлениеОПланируемомИмпортеЕГАИСТовары.Количество)                   КАК Количество
		|ИЗ
		|	Документ.УведомлениеОПланируемомИмпортеЕГАИС.Товары КАК УведомлениеОПланируемомИмпортеЕГАИСТовары
		|ГДЕ
		|	УведомлениеОПланируемомИмпортеЕГАИСТовары.Ссылка = &ДокументСсылка
		|
		|СГРУППИРОВАТЬ ПО
		|	УведомлениеОПланируемомИмпортеЕГАИСТовары.Номенклатура,
		|	УведомлениеОПланируемомИмпортеЕГАИСТовары.Характеристика,
		|	УведомлениеОПланируемомИмпортеЕГАИСТовары.Серия";
		
		Запрос.УстановитьПараметр("ДокументСсылка", ДокументОснование);
		
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			
			НоваяСтрока = ТаблицаДанныхДокументаОснования.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
			
		КонецЦикла;
		
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

