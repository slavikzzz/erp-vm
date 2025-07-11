////////////////////////////////////////////////////////////////////////////////
// Подсистема "Интеграция с 1С:Документооборотом"
// Модуль ИнтеграцияС1СДокументооборотБазоваяФункциональностьВызовСервераПереопределяемый: сервер, вызов сервера
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Заполняет предопределенные шаблоны выражений на встроенном языке.
//
// Параметры:
//   ШаблоныВыражений - Соответствие из КлючИЗначение:
//     * Ключ - Строка - имя шаблона.
//     * Значение - Строка - выражение на встроенном языке.
//
Процедура ПриОпределенииШаблоновВыраженийНаВстроенномЯзыке(ШаблоныВыражений) Экспорт
	
	ШаблоныВыражений.Вставить("ЗаполнениеБессрочныйВДО",
		"Параметры.Результат = Не ЗначениеЗаполнено(Параметры.Источник.ДатаОкончанияДействия);");
	
	ШаблоныВыражений.Вставить("ЗаполнениеНДСвДО",
		"Параметры.Результат = УчетНДСУПКлиентСервер.РассчитатьСуммуНДС(
		|	Параметры.Источник.Сумма,
		|	Параметры.Источник.СтавкаНДС);");
	
	ШаблоныВыражений.Вставить("ЗаполнениеСтатейДДСвДО",
		"Параметры.Результат = Новый ТаблицаЗначений;
		|Параметры.Результат.Колонки.Добавить(""СтатьяДДС"");
		|Параметры.Результат.Колонки.Добавить(""Сумма"");
		|Параметры.Результат.Колонки.Добавить(""СуммаНДС"");
		|Для Каждого Строка Из Параметры.Источник.РасшифровкаПлатежа Цикл
		|	НоваяСтрока = Параметры.Результат.Добавить();
		|	НоваяСтрока.СтатьяДДС = Строка.СтатьяДвиженияДенежныхСредств;
		|	НоваяСтрока.Сумма = Строка.Сумма;
		|	НоваяСтрока.СуммаНДС = Строка.СуммаНДС;
		|КонецЦикла;
		|Параметры.Результат.Свернуть(""СтатьяДДС"", ""Сумма, СуммаНДС"")");
	
	ШаблоныВыражений.Вставить("ЗаполнениеСторонИзСоглашения",
		"Параметры.Результат = Новый ТаблицаЗначений;
		|Параметры.Результат.Колонки.Добавить(""Комментарий"");
		|Параметры.Результат.Колонки.Добавить(""КонтактноеЛицо"");
		|Параметры.Результат.Колонки.Добавить(""Наименование"");
		|Параметры.Результат.Колонки.Добавить(""НаименованиеID"");
		|Параметры.Результат.Колонки.Добавить(""НаименованиеТип"");
		|Параметры.Результат.Колонки.Добавить(""Сторона"");
		|Параметры.Результат.Колонки.Добавить(""Установил"");
		|Параметры.Результат.Колонки.Добавить(""ДатаПодписи"");
		|Параметры.Результат.Колонки.Добавить(""Подписан"");
		|Параметры.Результат.Колонки.Добавить(""Подписал"");
		|
		|НоваяСтрока = Параметры.Результат.Добавить();
		|НоваяСтрока.Сторона = Параметры.Источник.Организация;
		|НаименованиеПродавецXDTO = ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПредопределенноеЗначениеДО(
		|	""DMPartyName"", ""Продавец"");
		|НоваяСтрока.Наименование = НаименованиеПродавецXDTO.name;
		|НоваяСтрока.НаименованиеID = НаименованиеПродавецXDTO.objectID.ID;
		|НоваяСтрока.НаименованиеТип = НаименованиеПродавецXDTO.objectID.type;
		|
		|НоваяСтрока = Параметры.Результат.Добавить();
		|НоваяСтрока.Сторона = Параметры.Источник.Контрагент;
		|НаименованиеПокупательXDTO = ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПредопределенноеЗначениеДО(
		|	""DMPartyName"", ""Покупатель"");
		|НоваяСтрока.Наименование = НаименованиеПокупательXDTO.name;
		|НоваяСтрока.НаименованиеID = НаименованиеПокупательXDTO.objectID.ID;
		|НоваяСтрока.НаименованиеТип = НаименованиеПокупательXDTO.objectID.type;
		|Если ЗначениеЗаполнено(Параметры.Источник.КонтактноеЛицо) Тогда
		|	НоваяСтрока.КонтактноеЛицо = Параметры.Источник.КонтактноеЛицо;
		|КонецЕсли;");
	
	ШаблоныВыражений.Вставить("ЗаполнениеСторонИзДоговора",
		"Параметры.Результат = Новый ТаблицаЗначений;
		|Параметры.Результат.Колонки.Добавить(""Комментарий"");
		|Параметры.Результат.Колонки.Добавить(""КонтактноеЛицо"");
		|Параметры.Результат.Колонки.Добавить(""Наименование"");
		|Параметры.Результат.Колонки.Добавить(""НаименованиеID"");
		|Параметры.Результат.Колонки.Добавить(""НаименованиеТип"");
		|Параметры.Результат.Колонки.Добавить(""Сторона"");
		|Параметры.Результат.Колонки.Добавить(""Установил"");
		|Параметры.Результат.Колонки.Добавить(""ДатаПодписи"");
		|Параметры.Результат.Колонки.Добавить(""Подписан"");
		|Параметры.Результат.Колонки.Добавить(""Подписал"");
		|
		|НоваяСтрока = Параметры.Результат.Добавить();
		|НоваяСтрока.Сторона = Параметры.Источник.Организация;
		|НаименованиеЗаказчикXDTO = ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПредопределенноеЗначениеДО(
		|	""DMPartyName"", ""Заказчик"");
		|НоваяСтрока.Наименование = НаименованиеЗаказчикXDTO.name;
		|НоваяСтрока.НаименованиеID = НаименованиеЗаказчикXDTO.objectID.id;
		|НоваяСтрока.НаименованиеТип = НаименованиеЗаказчикXDTO.objectID.type;
		|
		|НоваяСтрока = Параметры.Результат.Добавить();
		|НоваяСтрока.Сторона = Параметры.Источник.Контрагент;
		|НаименованиеИсполнительXDTO = ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПредопределенноеЗначениеДО(
		|	""DMPartyName"", ""Исполнитель"");
		|НоваяСтрока.Наименование = НаименованиеИсполнительXDTO.name;
		|НоваяСтрока.НаименованиеID = НаименованиеИсполнительXDTO.objectID.id;
		|НоваяСтрока.НаименованиеТип = НаименованиеИсполнительXDTO.objectID.type;
		|Если ЗначениеЗаполнено(Параметры.Источник.КонтактноеЛицо) Тогда
		|	НоваяСтрока.КонтактноеЛицо = Параметры.Источник.КонтактноеЛицо;
		|КонецЕсли;");
	
	ШаблоныВыражений.Вставить("ЗаполнениеСуммыИзЗаказа",
		"Если Параметры.Источник.ЦенаВключаетНДС Тогда
		|	Параметры.Результат = Параметры.Источник.СуммаДокумента;
		|Иначе
		|	Параметры.Результат = Параметры.Источник.СуммаДокумента - Параметры.Источник.Товары.Итог(""СуммаНДС"");
		|КонецЕсли;");
	
	ШаблоныВыражений.Вставить("ЗаполнениеНДСИзЗаказа",
		"Параметры.Результат = Параметры.Источник.Товары.Итог(""СуммаНДС"");");
	
	ШаблоныВыражений.Вставить("ЗаполнениеСуммыИзЗаявкиНаВозврат",
		"Если Параметры.Источник.ЦенаВключаетНДС Тогда
		|	Параметры.Результат = Параметры.Источник.СуммаДокумента;
		|Иначе
		|	Параметры.Результат = Параметры.Источник.СуммаДокумента - Параметры.Источник.ВозвращаемыеТовары.Итог(""СуммаНДС"");
		|КонецЕсли;");
	
	ШаблоныВыражений.Вставить("ЗаполнениеНДСИзЗаявкиНаВозврат",
		"Параметры.Результат = Параметры.Источник.ВозвращаемыеТовары.Итог(""СуммаНДС"");");
	
	ШаблоныВыражений.Вставить("ЗаполнениеНДСИзЗаявкиНаРасходДС",
		"Параметры.Результат = Параметры.Источник.РасшифровкаПлатежа.Итог(""СуммаНДС"");");
	
КонецПроцедуры

// Создает правила интеграции для указанного типа объекта ИС.
//
// Параметры:
//   ИмяТипаОбъекта - Строка, ЛюбаяСсылка - полное имя типа объекта ИС, как в метаданных, или ссылка на объект ИС.
//   ПравилаИнтеграции - Массив из Структура:
//     * Ссылка - СправочникСсылка.ПравилаИнтеграцииС1СДокументооборотом
//     * ТипОбъектаИС - Строка
//     * ТипОбъектаДО - Строка
//     * ПредставлениеОбъектаИС - Строка
//     * ПредставлениеОбъектаДО - Строка
//     * ИдентификаторВидаДокумента - Строка
//     * ТипВидаДокумента - Строка
//
// Пример:
//   Если ИмяТипаОбъекта = "Документ.ПоступлениеТоваровУслуг" Тогда
//     // Создаем правила интеграции и добавляем в массив
//     ПравилаИнтеграции = НачатьАвтоматическуюНастройкуИнтеграцииПоступлениеТоваровУслуг();
//   ИначеЕсли ИмяТипаОбъекта = "Документ.ЗаявкаНаРасходованиеДенежныхСредств" Тогда
//     // Создаем правила интеграции и добавляем в массив
//     ПравилаИнтеграции = НачатьАвтоматическуюНастройкуИнтеграцииЗаявкаНаОперацию();
//   КонецЕсли;
//
Процедура ПриСозданииПравилИнтеграцииАвтоматически(Знач ИмяТипаОбъекта, ПравилаИнтеграции) Экспорт
	
	Если ОбщегоНазначения.ЭтоСсылка(ТипЗнч(ИмяТипаОбъекта)) Тогда
		ИмяТипаОбъекта = ИмяТипаОбъекта.Метаданные().ПолноеИмя();
	КонецЕсли;
	
	РеквизитыПапки = ИнтеграцияС1СДокументооборот.СтруктураРеквизитовЗаполняемойПапкиВнутреннихДокументов();
	РеквизитыПапки.Описание = НСтр("ru = 'Создано автоматически из БИД';
									|en = 'Generated automatically from LID'");
	ПапкаВнутреннихДокументов = Неопределено;
	
	РеквизитыВидаДокумента = ИнтеграцияС1СДокументооборот.СтруктураРеквизитовЗаполняемогоВидаДокументовДО(
		"DMInternalDocumentType");
	РеквизитыВидаДокумента.АвтоНумерация = Истина;
	ВидДокумента = Неопределено;
	
	Если ИмяТипаОбъекта = "Справочник.СоглашенияСКлиентами" Тогда
		РеквизитыПапки.Имя = НСтр("ru = 'Соглашения об условиях продаж';
									|en = 'Terms of sale'");
		
		РеквизитыВидаДокумента.Имя = НСтр("ru = 'Соглашение об условиях продаж';
											|en = 'Terms of sale'");
		РеквизитыВидаДокумента.ИспользоватьПодписание = Истина;
		РеквизитыВидаДокумента.ВестиУчетПоОрганизациям = Истина;
		РеквизитыВидаДокумента.ВестиУчетСторон = Истина;
		РеквизитыВидаДокумента.УчитыватьСрокДействия = Истина;
		РеквизитыВидаДокумента.УчитыватьСуммуДокумента = Истина;
		
	ИначеЕсли ИмяТипаОбъекта = "Справочник.ДоговорыКонтрагентов" Тогда
		РеквизитыПапки.Имя = НСтр("ru = 'Договоры';
									|en = 'Contracts'");
		
		РеквизитыВидаДокумента.Имя = НСтр("ru = 'Договор с контрагентом';
											|en = 'Contract'");
		РеквизитыВидаДокумента.ИспользоватьПодписание = Истина;
		РеквизитыВидаДокумента.ВестиУчетПоОрганизациям = Истина;
		РеквизитыВидаДокумента.ВестиУчетСторон = Истина;
		РеквизитыВидаДокумента.УчитыватьСрокДействия = Истина;
		РеквизитыВидаДокумента.УчитыватьСуммуДокумента = Истина;
		
	ИначеЕсли ИмяТипаОбъекта = "Документ.КоммерческоеПредложениеКлиенту" Тогда
		РеквизитыПапки.Имя = НСтр("ru = 'Коммерческие предложения клиентам';
									|en = 'Sales quotations'");
		
		РеквизитыВидаДокумента.Имя = НСтр("ru = 'Коммерческое предложение клиенту';
											|en = 'Sales quotation'");
		РеквизитыВидаДокумента.ИспользоватьСрокИсполнения = Истина;
		РеквизитыВидаДокумента.УчитыватьСуммуДокумента = Истина;
		РеквизитыВидаДокумента.ВестиУчетСторон = Истина;
		РеквизитыВидаДокумента.ВестиУчетПоОрганизациям = Истина;
		РеквизитыВидаДокумента.ВестиУчетТоваровИУслуг = Истина;
		РеквизитыВидаДокумента.ИспользоватьУтверждение = Истина;
		
	ИначеЕсли ИмяТипаОбъекта = "Документ.ЗаказКлиента" Тогда
		РеквизитыПапки.Имя = НСтр("ru = 'Заказы клиентов';
									|en = 'Sales orders'");
		
		РеквизитыВидаДокумента.Имя = НСтр("ru = 'Заказ клиента';
											|en = 'Sales order'");
		РеквизитыВидаДокумента.УчитыватьСуммуДокумента = Истина;
		РеквизитыВидаДокумента.ВестиУчетПоКонтрагентам = Истина;
		РеквизитыВидаДокумента.ВестиУчетПоОрганизациям = Истина;
		РеквизитыВидаДокумента.ВестиУчетТоваровИУслуг = Истина;
		РеквизитыВидаДокумента.ИспользоватьУтверждение = Истина;
		
	ИначеЕсли ИмяТипаОбъекта = "Документ.ЗаказПоставщику" Тогда
		РеквизитыПапки.Имя = НСтр("ru = 'Заказы поставщикам';
									|en = 'Purchase orders'");
		
		РеквизитыВидаДокумента.Имя = НСтр("ru = 'Заказ поставщику';
											|en = 'Purchase order'");
		РеквизитыВидаДокумента.УчитыватьСуммуДокумента = Истина;
		РеквизитыВидаДокумента.ВестиУчетПоКонтрагентам = Истина;
		РеквизитыВидаДокумента.ВестиУчетПоОрганизациям = Истина;
		РеквизитыВидаДокумента.ВестиУчетТоваровИУслуг = Истина;
		РеквизитыВидаДокумента.ИспользоватьУтверждение = Истина;
		
	ИначеЕсли ИмяТипаОбъекта = "Документ.ЗаявкаНаВозвратТоваровОтКлиента" Тогда
		РеквизитыПапки.Имя = НСтр("ru = 'Заявки на возврат товаров от клиентов';
									|en = 'Sales return requests'");
		
		РеквизитыВидаДокумента.Имя = НСтр("ru = 'Заявка на возврат товаров от клиента';
											|en = 'Sales return request'");
		РеквизитыВидаДокумента.ИспользоватьСрокИсполнения = Истина;
		РеквизитыВидаДокумента.УчитыватьСуммуДокумента = Истина;
		РеквизитыВидаДокумента.ВестиУчетПоКонтрагентам = Истина;
		РеквизитыВидаДокумента.ВестиУчетПоОрганизациям = Истина;
		РеквизитыВидаДокумента.ВестиУчетТоваровИУслуг = Истина;
		РеквизитыВидаДокумента.ИспользоватьУтверждение = Истина;
		
	ИначеЕсли ИмяТипаОбъекта = "Документ.ЗаявкаНаРасходованиеДенежныхСредств" Тогда
		РеквизитыПапки.Имя = НСтр("ru = 'Заявки на расходование ДС';
									|en = 'Payment requests'");
		
		РеквизитыВидаДокумента.Имя = НСтр("ru = 'Заявка на расходование денежных средств';
											|en = 'Payment request'");
		РеквизитыВидаДокумента.ИспользоватьСрокИсполнения = Истина;
		РеквизитыВидаДокумента.УчитыватьСуммуДокумента = Истина;
		РеквизитыВидаДокумента.ВестиУчетПоОрганизациям = Истина;
		РеквизитыВидаДокумента.ВестиУчетСторон = Истина;
		РеквизитыВидаДокумента.ЯвляетсяЗаявкойНаОплату = Истина;
		РеквизитыВидаДокумента.ВестиУчетТоваровИУслуг = Истина;
		РеквизитыВидаДокумента.ИспользоватьУтверждение = Истина;
		РеквизитыВидаДокумента.ВестиУчетПоСтатьямДДС = Истина;
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(РеквизитыПапки.Имя) И ЗначениеЗаполнено(РеквизитыВидаДокумента.Имя) Тогда
		ПапкаВнутреннихДокументов = ИнтеграцияС1СДокументооборот.НайтиСоздатьПапкуВнутреннихДокументовВДО(РеквизитыПапки);
		ВидДокумента = ИнтеграцияС1СДокументооборот.НайтиСоздатьВидДокументаВДО(РеквизитыВидаДокумента);
		
		// Создадим правило
		ПравилаИнтеграции.Добавить(
			ИнтеграцияС1СДокументооборотУП.СоздатьПравилоИнтеграции(
				ИмяТипаОбъекта,
				"DMInternalDocument",
				ВидДокумента,
				ПапкаВнутреннихДокументов));
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти