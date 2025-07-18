#Область ПрограммныйИнтерфейс

Функция ИмяПодсистемы() Экспорт
	
	Возврат "ЕГАИС";
	
КонецФункции

Функция ПредставлениеПодсистемы() Экспорт
	
	Возврат "ЕГАИС";
	
КонецФункции

#Область ГруппыРеквизитовРедактируемыеОтдельно

// Комментарии строки документов импорта/производства:
// 
// Параметры:
//  Источник - СтрокаТабличнойЧасти - Текущая строка
//           - ФормаКлиентскогоПриложения - Форма уточнения группы реквизитов
//           - Структура - Данные строки структурой
// 
// Возвращаемое значение:
//  Структура - Комментарии строки документов импорта/производства:
//   * Комментарий1 - Строка - комментарий 1
//   * Комментарий2 - Строка - комментарий 2
//   * Комментарий3 - Строка - комментарий 3
Функция Комментарии(Источник) Экспорт
	
	Реквизиты = Новый Структура;
	Реквизиты.Вставить("Комментарий1", "");
	Реквизиты.Вставить("Комментарий2", "");
	Реквизиты.Вставить("Комментарий3", "");
	ЗаполнитьЗначенияСвойств(Реквизиты, Источник);
	Возврат Реквизиты;
	
КонецФункции

// Представление комментариев строки документов импорта/производства:
// 
// Параметры:
//  Источник - СтрокаТабличнойЧасти - Текущая строка с реквизитами:
//    Комментарий1 - ОпределяемыйТип.Строка200ЕГАИС - комментарий 1
//    Комментарий2 - ОпределяемыйТип.Строка200ЕГАИС - комментарий 2
//    Комментарий3 - ОпределяемыйТип.Строка200ЕГАИС - комментарий 3
// 
// Возвращаемое значение:
//  Строка - Представление комментарииев строки документов импорта/производства.
Функция ПредставлениеКомментариев(Источник) Экспорт
	
	Реквизиты = Новый Массив;
	Если ЗначениеЗаполнено(Источник.Комментарий1) Тогда
		Реквизиты.Добавить(Источник.Комментарий1);
	КонецЕсли;
	Если ЗначениеЗаполнено(Источник.Комментарий2) Тогда
		Реквизиты.Добавить(Источник.Комментарий2);
	КонецЕсли;
	Если ЗначениеЗаполнено(Источник.Комментарий3) Тогда
		Реквизиты.Добавить(Источник.Комментарий3);
	КонецЕсли;
	Возврат СтрСоединить(Реквизиты, "; ");
	
КонецФункции

// Крепость строки документов импорта/производства:
// 
// Параметры:
//  Источник - Произвольный - Источник данных о крепости с полями:
//   * Крепость   - Число - крепость
//   * КрепостьОт - Число - минимальная крепость
//   * КрепостьДо - Число - максимальная крепость
// 
// Возвращаемое значение:
//  Структура - крепость строки документов импорта/производства:
//   * Крепость   - Число - крепость
//   * КрепостьОт - Число - минимальная крепость
//   * КрепостьДо - Число - максимальная крепость
Функция Крепость(Источник) Экспорт
	
	Реквизиты = Новый Структура;
	Реквизиты.Вставить("Крепость", 0);
	Реквизиты.Вставить("КрепостьОт", 0);
	Реквизиты.Вставить("КрепостьДо", 0);
	ЗаполнитьЗначенияСвойств(Реквизиты, Источник);
	Возврат Реквизиты;
	
КонецФункции

// Представление крепости строки документов импорта/производства:
// 
// Параметры:
//  Источник - СтрокаТабличнойЧасти - Текущая строка с реквизитами:
//   * Крепость   - Число - крепость
//   * КрепостьОт - Число - минимальная крепость
//   * КрепостьДо - Число - максимальная крепость
// 
// Возвращаемое значение:
//  Строка - Представление крепости строки документов импорта/производства.
Функция ПредставлениеКрепости(Источник) Экспорт
	
	Если ЗначениеЗаполнено(Источник.Крепость) Тогда
		Возврат Строка(Источник.Крепость);
	Иначе
		Возврат СтрШаблон("%1 - %2", Источник.КрепостьОт, Источник.КрепостьДо);
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#Область КоличествоЕГАИС

// Округляет вниз количество для упакованной алкогольной продукции до целого. Для поля 
//    "Количество упаковок" выполняется дополнительная проверка (на совпадение с полем "Количество")
// 
// Параметры:
//   ДанныеСтроки               - ДанныеФормыСтруктура - редактируемая строка
//   ПолеНеупакованнаяПродукция - Строка               - реквизит "Неупакованная продукция"
//   ПоляКоличество             - Строка               - реквизиты к округлению (через запятую)
//   ПолеДоступноДробноеКоличество- Строка - путь к данным значения "Доступно указание дробного количествав для алкогольной продукции"
//
Процедура ОкруглитьКоличествоДляУпакованнойПродукцииСУчетомУпаковок(ДанныеСтроки, ПолеНеупакованнаяПродукция, Знач ПоляКоличество, ПолеДоступноДробноеКоличество = "") Экспорт
	
	Если Не ДанныеСтроки[ПолеНеупакованнаяПродукция] Тогда
		Если Не ПустаяСтрока(ПолеДоступноДробноеКоличество)
			И ДанныеСтроки[ПолеДоступноДробноеКоличество] Тогда
			ДанныеСтроки.КоличествоУпаковок = Окр(ДанныеСтроки.КоличествоУпаковок, 3);
		ИначеЕсли ДанныеСтроки.Количество = ДанныеСтроки.КоличествоУпаковок Тогда
			ДанныеСтроки.КоличествоУпаковок = Цел(ДанныеСтроки.КоличествоУпаковок);
		КонецЕсли;
	КонецЕсли;
	
	ОкруглитьКоличествоДляУпакованнойПродукции(ДанныеСтроки, ПолеНеупакованнаяПродукция, ПоляКоличество, ПолеДоступноДробноеКоличество);
	
КонецПроцедуры

// Округляет вниз количество для упакованной алкогольной продукции до целого
// 
// Параметры:
//   ДанныеСтроки               - ДанныеФормыСтруктура - редактируемая строка
//   ПолеНеупакованнаяПродукция - Строка               - реквизит "Неупакованная продукция"
//   ПоляКоличество             - Строка               - реквизиты к округлению (через запятую)
//   ПолеДоступноДробноеКоличество - Строка - путь к данным значения "Доступно указание дробного количествав для алкогольной продукции"
//
Процедура ОкруглитьКоличествоДляУпакованнойПродукции(ДанныеСтроки, ПолеНеупакованнаяПродукция, Знач ПоляКоличество, ПолеДоступноДробноеКоличество = "") Экспорт
	
	Если НЕ ДанныеСтроки[ПолеНеупакованнаяПродукция] Тогда
		ДоступноДробноеКоличество = Не ПустаяСтрока(ПолеДоступноДробноеКоличество)
			И ДанныеСтроки[ПолеДоступноДробноеКоличество];
		ПоляКоличество = СтрРазделить(ПоляКоличество, ",", Ложь);
		Для Каждого ПолеКоличества Из ПоляКоличество Цикл
			Если ДоступноДробноеКоличество Тогда
				ДанныеСтроки[ПолеКоличества] = Окр(ДанныеСтроки[ПолеКоличества], 3);
			Иначе
				ДанныеСтроки[ПолеКоличества] = Цел(ДанныеСтроки[ПолеКоличества]);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОтборПоОрганизацииЕГАИС

Процедура НастроитьОтборПоОрганизацииЕГАИС(Форма, Результат, Префикс = Неопределено, Знач ЗначениеПрефиксы = Неопределено) Экспорт
	
	Если ТипЗнч(Результат) = Тип("Массив") Тогда
		Форма.ОрганизацииЕГАИС.ЗагрузитьЗначения(Результат);
	ИначеЕсли ТипЗнч(Результат) = Тип("СправочникСсылка.КлассификаторОрганизацийЕГАИС") Тогда
		Форма.ОрганизацииЕГАИС.Очистить();
		Форма.ОрганизацииЕГАИС.Добавить(Результат);
	ИначеЕсли ТипЗнч(Результат) = Тип("СписокЗначений") Тогда
	Иначе
		Форма.ОрганизацииЕГАИС.Очистить();
	КонецЕсли;
	
	Если Форма.ОрганизацииЕГАИС.Количество() = 1 Тогда
		Форма.ОрганизацияЕГАИС = Форма.ОрганизацииЕГАИС.Получить(0).Значение;
		Форма.ОрганизацииЕГАИСПредставление = Строка(Форма.ОрганизацияЕГАИС);
	ИначеЕсли Форма.ОрганизацииЕГАИС.Количество() = 0 Тогда
		Форма.ОрганизацияЕГАИС = Неопределено;
		Форма.ОрганизацииЕГАИСПредставление = "";
	Иначе
		Форма.ОрганизацияЕГАИС = Неопределено;
		Форма.ОрганизацииЕГАИСПредставление = Строка(Форма.ОрганизацииЕГАИС);
	КонецЕсли;
	
	Если ЗначениеПрефиксы = Неопределено Тогда
		Префиксы = Новый Массив;
		Префиксы.Добавить("Оформлено");
		Префиксы.Добавить("КОформлению");
		Префиксы.Добавить("ВРегистр3");
	Иначе
		Если ТипЗнч(ЗначениеПрефиксы) = Тип("Строка") Тогда
			Префиксы = Новый Массив();
			Префиксы.Добавить(ЗначениеПрефиксы);
		Иначе
			Префиксы = ЗначениеПрефиксы;
		КонецЕсли;
	КонецЕсли;
	
	Для Каждого Значение Из Префиксы Цикл
		
		Если Форма.ОрганизацииЕГАИС.Количество() > 1 Тогда
			Окончание = "ОрганизацииЕГАИС";
		Иначе 
			Окончание = "ОрганизацияЕГАИС";
		КонецЕсли;
		
		Если Значение = "Отбор" Тогда
			Постфикс = Окончание;
		Иначе
			Постфикс = "Отбор" + Окончание;
		КонецЕсли;
		
		СтраницыОтбораОрганизацияЕГАИС = Форма.Элементы.Найти("Страницы" + Значение + Постфикс);
		Если СтраницыОтбораОрганизацияЕГАИС <> Неопределено Тогда
			СтраницыОтбораОрганизацияЕГАИС.ТекущаяСтраница = Форма.Элементы["Страница" + Значение + Окончание];
		КонецЕсли;
	КонецЦикла;
	
	Если Префикс <> Неопределено Тогда
		ЭлементОтбораОрганизацияЕГАИС = Форма.Элементы.Найти(Префикс + ?(Форма.ОрганизацииЕГАИС.Количество() > 1,
		                                                                "ОрганизацииЕГАИС",
		                                                                "ОрганизацияЕГАИС"));
		Если ЭлементОтбораОрганизацияЕГАИС <> Неопределено Тогда
			Форма.ТекущийЭлемент = ЭлементОтбораОрганизацияЕГАИС;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ПодборПартий

// Это выбор справки2 ЕГАИС.
// 
// Параметры:
//  ВыбранноеЗначение - Произвольный
// 
// Возвращаемое значение:
//  Булево - Это выбор справки2 ЕГАИС
Функция ЭтоВыборСправки2ЕГАИС(ВыбранноеЗначение) Экспорт
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура")
		И ВыбранноеЗначение.Свойство("Операция")
		И ВыбранноеЗначение.Операция = "ПодборВыборСправки2ЕГАИС" Тогда
		Возврат Истина;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Возвращает структуру, необходимую для записи справки 1.
// 
// Возвращаемое значение:
//  Структура - Структура данных справки1:
// * РегистрационныйНомер - Строка - 
// * Наименование - Строка - 
// * НомерТТН - Неопределено - 
// * ДатаТТН - Неопределено - 
// * Грузоотправитель - Неопределено - 
// * Грузополучатель - Неопределено - 
// * ДатаОтгрузки - Неопределено - 
// * АлкогольнаяПродукция - Неопределено - 
// * ДатаРозлива - Неопределено - 
// * Количество - Неопределено - 
// * НомерПодтвержденияЕГАИС - Неопределено - 
// * ДатаПодтвержденияЕГАИС - Неопределено - 
Функция СтруктураДанныхСправки1() Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("РегистрационныйНомер"   , "");
	Результат.Вставить("Наименование"           , "");
	Результат.Вставить("НомерТТН"               , Неопределено);
	Результат.Вставить("ДатаТТН"                , Неопределено);
	Результат.Вставить("Грузоотправитель"       , Неопределено);
	Результат.Вставить("Грузополучатель"        , Неопределено);
	Результат.Вставить("ДатаОтгрузки"           , Неопределено);
	Результат.Вставить("АлкогольнаяПродукция"   , Неопределено);
	Результат.Вставить("ДатаРозлива"            , Неопределено);
	Результат.Вставить("Количество"             , Неопределено);
	Результат.Вставить("НомерПодтвержденияЕГАИС", Неопределено);
	Результат.Вставить("ДатаПодтвержденияЕГАИС" , Неопределено);
	
	Возврат Результат;
	
КонецФункции

// Возвращает структуру, необходимую для записи справки 2.
// 
// Возвращаемое значение:
//  Структура - Структура данных справки2:
// * РегистрационныйНомер - Строка - 
// * Наименование - Строка - 
// * АлкогольнаяПродукция - Неопределено - 
// * Количество - Неопределено - 
// * НомерСправки1 - Строка - 
// * Справка1 - Неопределено - 
// * ДокументОснование - Неопределено - 
// * НомерПодтвержденияЕГАИС - Неопределено - 
// * ДатаПодтвержденияЕГАИС - Неопределено - 
// * Поштучная - Булево - 
// * ДиапазоныМарок - Массив из Строка - 
Функция СтруктураДанныхСправки2() Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("РегистрационныйНомер",    "");
	Результат.Вставить("Наименование",            "");
	Результат.Вставить("АлкогольнаяПродукция",    Неопределено);
	Результат.Вставить("Количество",              Неопределено);
	Результат.Вставить("НомерСправки1",           "");
	Результат.Вставить("Справка1",                Неопределено);
	Результат.Вставить("ДокументОснование",       Неопределено);
	Результат.Вставить("НомерПодтвержденияЕГАИС", Неопределено);
	Результат.Вставить("ДатаПодтвержденияЕГАИС",  Неопределено);
	Результат.Вставить("Поштучная",               Ложь);
	Результат.Вставить("ДиапазоныМарок" ,         Новый Массив);
	
	Возврат Результат;
	
КонецФункции

#Область ПроцедурыПересчетаСуммы

// Возвращает структуру, содержащую поля для пересчета суммы в табличной части документа
//
// Параметры:
//  Реквизиты - Строка - Содержит имена полей, заданных через запятую,
//  ЗависимыеРеквизиты - Структура - структура, каждое элемент которой есть структура с именами реквизитов без префикса,
//                       ключ элемента содержит префикс. Например Новый Структура("Тара", "Сумма, СуммаНДС") означает
//                       наличие реквизитов: "СуммаТара" и "СуммаНДСТара".
//  ИмяПоляКоличество     - Строка - Имя поля, по которому считается коэффициент пропорциональности.
//  РазрядностиОкругления - Структура - структура, в формате ИмяПоля => Количество знаков дробной части, которая будет
//                                      использоваться при пересчете реквизитов.
//
// Возвращаемое значение:
//  Структура - Структура со следующими полями:
//              * Поля - Структура - содержит поля для пересчета суммы в табличной части документа
//              * Строки - Массив из ДанныеФормыЭлементКоллекции - ссылки нас строки для пересчета сумм
//              * ИтогКоличество - Число - сумма значений в поле "Количество" в строках переданных в параметре "Строки"
//              * ИмяПоляКоличество     - Строка - Имя поля, по которому считается коэффициент пропорциональности
//              * РазрядностиОкругления - Неопределено, Структура - структура, в формате ИмяПоля => Количество знаков дробной части, которая будет
//                                      использоваться при пересчете реквизитов.
Функция СтруктураПересчетаСуммы(Реквизиты, ЗависимыеРеквизиты = Неопределено, ИмяПоляКоличество = "Количество", РазрядностиОкругления = Неопределено) Экспорт

	Поля = Новый Структура(Реквизиты);
	Если ЗависимыеРеквизиты <> Неопределено Тогда
		
		Для Каждого ПолеСтруктуры Из ЗависимыеРеквизиты цикл

			Реквизиты = Новый Структура(ПолеСтруктуры.Значение);
			Для Каждого Поле Из Реквизиты цикл
				Поля.Вставить(Поле.Ключ + ПолеСтруктуры.Ключ);
			КонецЦикла;

		КонецЦикла;

	КонецЕсли;
	
	Результат = Новый Структура;
	Результат.Вставить("Поля", Поля);
	Результат.Вставить("Строки", Новый Массив());
	Результат.Вставить("ИтогКоличество", 0);
	Результат.Вставить("ИмяПоляКоличество", ИмяПоляКоличество);
	Результат.Вставить("РазрядностиОкругления", РазрядностиОкругления);

	Возврат Результат;

КонецФункции

// Инициализирует структуру для пересчета суммы в табличной части документа
//
// Параметры:
//  СтруктураПересчетаСуммы - Структура - структура подлежащая инициализации, описание см. функция
//                            ОбработкаТабличнойЧастиКлиентСервер.СтруктураПересчетаСуммы.
//  ДанныеЗаполнения - ДанныеФормыЭлементКоллекции - строка, содержащая значения суммовых показателей,
//                     которые необходимо будет распределить между строками при пересчете сумм.
//
Процедура ЗаполнитьСтруктуруПересчетаСуммы(СтруктураПересчетаСуммы, ДанныеЗаполнения) Экспорт

	ЗаполнитьЗначенияСвойств(СтруктураПересчетаСуммы.Поля, ДанныеЗаполнения);

	СтруктураПересчетаСуммы.ИтогКоличество = 0;
	СтруктураПересчетаСуммы.Строки.Очистить();

КонецПроцедуры

// Добавляет строку для пересчета суммы в структуру пересчета суммы, описание см. функция
//                            ОбработкаТабличнойЧастиКлиентСервер.СтруктураПересчетаСуммы.
//
// Параметры:
//  СтруктураПересчетаСуммы - Структура - структура пересчета суммы, описание см. функция
//                            ОбработкаТабличнойЧастиКлиентСервер.СтруктураПересчетаСуммы.
//  Строка - ДанныеФормыЭлементКоллекции - строка, для которой необходимо рассчитать значения сумм.
//
Процедура ДобавитьСтрокуДляПересчетаСуммы(СтруктураПересчетаСуммы, Строка) Экспорт

	СтруктураПересчетаСуммы.Строки.Добавить(Строка);
	СтруктураПересчетаСуммы.ИтогКоличество = СтруктураПересчетаСуммы.ИтогКоличество + Строка[СтруктураПересчетаСуммы.ИмяПоляКоличество];

Конецпроцедуры

// Пересчитывает суммы в строках, добавленных в структуру пересчета суммы, описание см. функция
//                            ОбработкаТабличнойЧастиКлиентСервер.СтруктураПересчетаСуммы.
//
// Параметры:
//  СтруктураПересчетаСуммы - Структура - структура пересчета суммы, описание см. функция
//                            ОбработкаТабличнойЧастиКлиентСервер.СтруктураПересчетаСуммы.
//
Процедура ПересчитатьСуммы(СтруктураПересчетаСуммы) Экспорт
	
	РазрядностиОкругления = Неопределено;
	Если СтруктураПересчетаСуммы.Свойство("РазрядностиОкругления") Тогда
		РазрядностиОкругления = СтруктураПересчетаСуммы.РазрядностиОкругления;
	КонецЕсли;
	
	Для Каждого Строка Из СтруктураПересчетаСуммы.Строки Цикл
		
		Если СтруктураПересчетаСуммы.ИтогКоличество = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		Коэффициент = Строка[СтруктураПересчетаСуммы.ИмяПоляКоличество] / СтруктураПересчетаСуммы.ИтогКоличество;
		СтруктураПересчетаСуммы.ИтогКоличество = СтруктураПересчетаСуммы.ИтогКоличество - Строка[СтруктураПересчетаСуммы.ИмяПоляКоличество];

		Для Каждого Поле Из СтруктураПересчетаСуммы.Поля Цикл
			
			НовоеЗначение = Поле.Значение * Коэффициент;
			
			Если РазрядностиОкругления <> Неопределено Тогда
				Строка[Поле.Ключ] = Окр(НовоеЗначение, РазрядностиОкругления[Поле.Ключ]);
			Иначе
				Строка[Поле.Ключ] = НовоеЗначение;
			КонецЕсли;
			
			СтруктураПересчетаСуммы.Поля[Поле.Ключ] = Поле.Значение - Строка[Поле.Ключ];

		КонецЦикла;

	КонецЦикла;

КонецПроцедуры

#КонецОбласти

#Область ПодборПартий

Функция РезультатВыбораСправки2ЕГАИС(ВыбранноеЗначение) Экспорт
	
	РезультатВыбора = Новый Структура;
	РезультатВыбора.Вставить("Операция", "ПодборВыборСправки2ЕГАИС");
	РезультатВыбора.Вставить("Справка2", ВыбранноеЗначение.Справка2);
	Если ЗначениеЗаполнено(ВыбранноеЗначение.АлкогольнаяПродукция) Тогда
		РезультатВыбора.Вставить("АлкогольнаяПродукция", ВыбранноеЗначение.АлкогольнаяПродукция);
	КонецЕсли;
	
	РезультатВыбора.Вставить("КоличествоЕГАИС", ВыбранноеЗначение.Количество);
	
	Возврат РезультатВыбора;
	
КонецФункции

#КонецОбласти

// Устанавливает отбор в списке по указанному значению для нужной колонки
// с учетом переданной структуры быстрого отбора
//
// Параметры:
//  Список - динамический список, для которого требуется установить отбор
//  ИмяКолонки - Строка - Имя колонки, по которой устанавливается отбор
//  Значение - устанавливаемое значение отбора
//  СтруктураБыстрогоОтбора - Неопределено, Структура - Структура, содержащая ключи и значения отбора
//  Использование - Неопределено, Булево - Признак использования элемента отбора
//  ВидСравнения - Неопределено, ВидСравненияКомпоновкиДанных - вид сравнения, устанавливаемый для элемента отбора
//  ПриводитьЗначениеКЧислу - Булево - Признак приведения значения к числу.
//
Процедура ОтборПоЗначениюСпискаПриСозданииНаСервере(Список, ИмяКолонки, Значение, Знач СтруктураБыстрогоОтбораРасширенная,
			Использование = Неопределено, ВидСравнения = Неопределено, ПриводитьЗначениеКЧислу = Ложь) Экспорт
	
	Если СтруктураБыстрогоОтбораРасширенная <> Неопределено Тогда
		
		Если СтруктураБыстрогоОтбораРасширенная.Количество() = 2
			И СтруктураБыстрогоОтбораРасширенная.Свойство("ИмяПоля")
			И СтруктураБыстрогоОтбораРасширенная.Свойство("Настройки") Тогда
			СтруктураБыстрогоОтбора = СтруктураБыстрогоОтбораРасширенная.Настройки;
			ИмяКолонкиДляПоиска = СтруктураБыстрогоОтбораРасширенная.ИмяПоля;
		Иначе
			СтруктураБыстрогоОтбора = СтруктураБыстрогоОтбораРасширенная;
			ИмяКолонкиДляПоиска = ИмяКолонки;
		КонецЕсли;
		
		Если СтруктураБыстрогоОтбора <> Неопределено
			И СтруктураБыстрогоОтбора.Свойство(ИмяКолонкиДляПоиска) Тогда
			
			ЗначениеОтбора = СтруктураБыстрогоОтбора[ИмяКолонкиДляПоиска];
			Если ТипЗнч(Значение) = Тип("СписокЗначений") Тогда
				
				Если ТипЗнч(ЗначениеОтбора) = Тип("СписокЗначений") Тогда
					Значение.ЗагрузитьЗначения(ЗначениеОтбора.ВыгрузитьЗначения());
				ИначеЕсли ТипЗнч(ЗначениеОтбора) = Тип("Массив") Тогда
					Значение.ЗагрузитьЗначения(ЗначениеОтбора);
				Иначе
					Значение.Очистить();
					Если ЗначениеЗаполнено(ЗначениеОтбора) Тогда
						Значение.Добавить(ЗначениеОтбора);
					КонецЕсли;
				КонецЕсли;
				
			Иначе
				
				Значение = ЗначениеОтбора;
				
			КонецЕсли;
			
			Если ПриводитьЗначениеКЧислу Тогда
				Значение = ?(ЗначениеЗаполнено(Значение), Число(Значение), Значение);
			КонецЕсли;
			
			Если ТипЗнч(Значение) = Тип("СписокЗначений") Тогда
				ИспользованиеЭлементаОтбора = ?(Использование = Неопределено, Значение.Количество() > 0, Использование);
			Иначе
				ИспользованиеЭлементаОтбора = ?(Использование = Неопределено, ЗначениеЗаполнено(Значение), Использование);
			КонецЕсли;
			
			Если Список <> Неопределено Тогда
				ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, ИмяКолонки, Значение, ВидСравнения,,ИспользованиеЭлементаОтбора);
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Устанавливает отбор в списке по указанному значению для нужной колонки
// с учетом переданной структуры быстрого отбора и переданных настроек
//
// Параметры:
//  Список - динамический список, для которого требуется установить отбор
//  ИмяКолонки - Строка - Имя колонки, по которой устанавливается отбор
//  Значение - устанавливаемое значение отбора
//  СтруктураБыстрогоОтбора - Неопределено, Структура - Структура, содержащая ключи и значения отбора
//  Настройки - настройки, из которых могут получаться значения отбора
//  Использование - Неопределено, Булево - Признак использования элемента отбора
//  ВидСравнения - Неопределено, ВидСравненияКомпоновкиДанных - вид сравнения, устанавливаемый для элемента отбора
//  ПриводитьЗначениеКЧислу - Булево - Признак приведения значения к числу.
//
Процедура ОтборПоЗначениюСпискаПриЗагрузкеИзНастроек(Список, ИмяКолонки, Значение, Знач СтруктураБыстрогоОтбораРасширенная,
			НастройкиРасширенные, Использование = Неопределено, ВидСравнения = Неопределено, ПриводитьЗначениеКЧислу = Ложь) Экспорт
	
	Если ТипЗнч(НастройкиРасширенные) = Тип("Структура")
		И НастройкиРасширенные.Количество() = 2
		И НастройкиРасширенные.Свойство("ИмяПоля")
		И НастройкиРасширенные.Свойство("Настройки") Тогда
		Настройки           = НастройкиРасширенные.Настройки;
		ИмяКолонкиДляПоиска = НастройкиРасширенные.ИмяПоля;
	Иначе
		Настройки           = НастройкиРасширенные;
		ИмяКолонкиДляПоиска = ИмяКолонки;
	КонецЕсли;
	
	Если СтруктураБыстрогоОтбораРасширенная <> Неопределено Тогда
		
		Если СтруктураБыстрогоОтбораРасширенная.Количество() = 2
			И СтруктураБыстрогоОтбораРасширенная.Свойство("ИмяПоля")
			И СтруктураБыстрогоОтбораРасширенная.Свойство("СтруктураБыстрогоОтбора") Тогда
			СтруктураБыстрогоОтбора = СтруктураБыстрогоОтбораРасширенная.СтруктураБыстрогоОтбора;
			ИмяКолонкиДляПоиска = СтруктураБыстрогоОтбораРасширенная.ИмяПоля;
		Иначе
			СтруктураБыстрогоОтбора = СтруктураБыстрогоОтбораРасширенная;
			ИмяКолонкиДляПоиска = ИмяКолонки;
		КонецЕсли;
		
		Если СтруктураБыстрогоОтбора.Свойство(ИмяКолонкиДляПоиска) Тогда
			
			ЗначениеОтбора = СтруктураБыстрогоОтбора[ИмяКолонкиДляПоиска];
			Если ТипЗнч(Значение) = Тип("СписокЗначений") Тогда
				
				Если ТипЗнч(ЗначениеОтбора) = Тип("СписокЗначений") Тогда
					Значение.ЗагрузитьЗначения(ЗначениеОтбора.ВыгрузитьЗначения());
				ИначеЕсли ТипЗнч(ЗначениеОтбора) = Тип("Массив") Тогда
					Значение.ЗагрузитьЗначения(ЗначениеОтбора);
				Иначе
					Значение.Очистить();
					Если ЗначениеЗаполнено(ЗначениеОтбора) Тогда
						Значение.Добавить(ЗначениеОтбора);
					КонецЕсли;
				КонецЕсли;
				
			Иначе
				
				Значение = ЗначениеОтбора;
				
			КонецЕсли;
			
			Если ПриводитьЗначениеКЧислу Тогда
				Значение = ?(ЗначениеЗаполнено(Значение), Число(Значение), Значение);
			КонецЕсли;
			
			Если ТипЗнч(Значение) = Тип("СписокЗначений") Тогда
				ИспользованиеЭлементаОтбора = ?(Использование = Неопределено, Значение.Количество() > 0, Использование);
			Иначе
				ИспользованиеЭлементаОтбора = ?(Использование = Неопределено, ЗначениеЗаполнено(Значение), Использование);
			КонецЕсли;
			
			Если Список <> Неопределено Тогда
				ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, ИмяКолонки, Значение, ВидСравнения,,ИспользованиеЭлементаОтбора);
			КонецЕсли;
			
		КонецЕсли;
		
	Иначе
		
		ЗначениеОтбора = Настройки.Получить(ИмяКолонкиДляПоиска);
		
		Если ТипЗнч(Значение) = Тип("СписокЗначений") Тогда
			
			Если ТипЗнч(ЗначениеОтбора) = Тип("СписокЗначений") Тогда
				Значение.ЗагрузитьЗначения(ЗначениеОтбора.ВыгрузитьЗначения());
			ИначеЕсли ТипЗнч(ЗначениеОтбора) = Тип("Массив") Тогда
				Значение.ЗагрузитьЗначения(ЗначениеОтбора);
			Иначе
				Значение.Очистить();
				Если ЗначениеЗаполнено(ЗначениеОтбора) Тогда
					Значение.Добавить(ЗначениеОтбора);
				КонецЕсли;
			КонецЕсли;
			
		Иначе
			
			Значение = ЗначениеОтбора;
			
		КонецЕсли;
		
		Если ПриводитьЗначениеКЧислу Тогда
			Значение = ?(ЗначениеЗаполнено(Значение), Число(Значение), Значение);
		КонецЕсли;
		
		Если ТипЗнч(Значение) = Тип("СписокЗначений") Тогда
			ИспользованиеЭлементаОтбора = ?(Использование = Неопределено, Значение.Количество() > 0, Использование);
		Иначе
			ИспользованиеЭлементаОтбора = ?(Использование = Неопределено, ЗначениеЗаполнено(Значение), Использование);
		КонецЕсли;
		
		Если Список <> Неопределено Тогда
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, ИмяКолонки, Значение, ВидСравнения,,ИспользованиеЭлементаОтбора);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Создает структура поиска поля для загрузки из настроек.
//
// Параметры:
//  ИмяПоля - Строка - Имя поля для загрузки.
//  Настройки - Структура - Структура быстрого отбора.
// 
// Возвращаемое значение:
//  Структура - Структура со свойствами:
//   * ИмяПоля - Строка - Имя поля для загрузки.
//   * СтруктураБыстрогоОтбора - Структура - Структура быстрого отбора.
//
Функция СтруктураПоискаПоляДляЗагрузкиИзНастроек(ИмяПоля, Настройки) Экспорт
	
	ВозвращаемоеЗначение = Новый Структура;
	ВозвращаемоеЗначение.Вставить("ИмяПоля",   ИмяПоля);
	ВозвращаемоеЗначение.Вставить("Настройки", Настройки);
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

// Проверяет передан ли в форму списка документов отбор по дальнейшему действию ЕГАИС
//
// Параметры:
// ДальнейшееДействиеЕГАИС - Строка, ПеречислениеСсылка.ДальнейшиеДействияПоВзаимодействиюЕГАИС - поле отбора
// СтруктураБыстрогоОтбора - Структура - переданный в форму списка документов отбор
//
// Возвращаемое значение:
// Булево
// Истина, если необходимо установить отбор по состоянию, иначе Ложь
//
Функция НеобходимОтборПоДальнейшемуДействиюЕГАИСПриСозданииНаСервере(ДальнейшееДействиеЕГАИС, Знач СтруктураБыстрогоОтбора) Экспорт
	
	Если СтруктураБыстрогоОтбора <> Неопределено Тогда
		Если СтруктураБыстрогоОтбора.Свойство("ДальнейшееДействиеЕГАИС", ДальнейшееДействиеЕГАИС) Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

// Проверяет, нужно ли устанавливать отбор по дальнейшему действию ЕГАИС, загруженный из настроек или переданный в форму извне
// Отбор из настроек устанавливается только если отбор не передан в форму извне
// 
// Параметры:
//  ДальнейшееДействиеЕГАИС - Строка, ПеречислениеСсылка.ДальнейшиеДействияПоВзаимодействиюЕГАИС - поле отбора по дальнейшему действию ГИСМ
//  СтруктураБыстрогоОтбора - Структура - переданный в форму списка документов отбор
//  Настройки - Соответствие из КлючИЗначение - настройки формы
// 
// Возвращаемое значение:
//  Булево - Необходим отбор по дальнейшему действию ЕГАИСПеред загрузкой из настроек
Функция НеобходимОтборПоДальнейшемуДействиюЕГАИСПередЗагрузкойИзНастроек(ДальнейшееДействиеЕГАИС, Знач СтруктураБыстрогоОтбора, Настройки) Экспорт
	
	НеобходимОтбор = Ложь;
	
	Если СтруктураБыстрогоОтбора = Неопределено Тогда
		
		ДальнейшееДействиеЕГАИС = Настройки.Получить("ДальнейшееДействиеЕГАИС");
		НеобходимОтбор = Истина;
		
	Иначе
	
		Если Не СтруктураБыстрогоОтбора.Свойство("ДальнейшееДействиеЕГАИС") Тогда
			ДальнейшееДействиеЕГАИС = Настройки.Получить("ДальнейшееДействиеЕГАИС");
			НеобходимОтбор = Истина;
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат НеобходимОтбор;
	
КонецФункции

Функция ОбработатьДанныеШтрихкода(ДанныеШтрихкода) Экспорт
	
	ЧтениеШтрихкода = ШтрихкодыУпаковокКлиентСервер.ПараметрыШтрихкода(СокрЛП(ДанныеШтрихкода.Штрихкод));
	Если Не ЧтениеШтрихкода.Результат = Неопределено Тогда
		
		Если ЧтениеШтрихкода.ТипШтрихкода = ПредопределенноеЗначение("Перечисление.ТипыШтрихкодов.GS1_128")
			Или ЧтениеШтрихкода.ТипШтрихкода = ПредопределенноеЗначение("Перечисление.ТипыШтрихкодов.GS1_DataBarExpandedStacked") Тогда
			
			ШтрихкодGS1 = ШтрихкодыУпаковокКлиентСервер.ШтрихкодGS1(ЧтениеШтрихкода.Результат, Истина);
			
			НовыеДанныеШтрихкода = Новый Структура;
			НовыеДанныеШтрихкода.Вставить("Штрихкод",   ШтрихкодGS1);
			НовыеДанныеШтрихкода.Вставить("Количество", ДанныеШтрихкода.Количество);
			
			Возврат НовыеДанныеШтрихкода;
			
		ИначеЕсли ЧтениеШтрихкода.ТипШтрихкода = ПредопределенноеЗначение("Перечисление.ТипыШтрихкодов.SSCC") Тогда
			
			ШтрихкодSSCC = ШтрихкодыУпаковокКлиентСервер.ШтрихкодSSCC(ЧтениеШтрихкода.Результат, Истина);
			
			НовыеДанныеШтрихкода = Новый Структура;
			НовыеДанныеШтрихкода.Вставить("Штрихкод",   ШтрихкодSSCC);
			НовыеДанныеШтрихкода.Вставить("Количество", ДанныеШтрихкода.Количество);
			
			Возврат НовыеДанныеШтрихкода;
			
		Иначе
			
			Возврат ДанныеШтрихкода;
			
		КонецЕсли;
		
	Иначе
		
		Возврат ДанныеШтрихкода;
		
	КонецЕсли;
	
КонецФункции

// Возвращает структуру параметров заполнения табличной части.
// 
// Возвращаемое значение:
//  Структура - параметры заполнения табличной части
Функция ПараметрыЗаполненияТабличнойЧасти() Экспорт

	ПараметрыЗаполнения = Новый Структура;
	ПараметрыЗаполнения.Вставить("ЗаполнитьАлкогольнуюПродукцию",   Ложь);
	ПараметрыЗаполнения.Вставить("ЗаполнитьКрепость",               Ложь);
	ПараметрыЗаполнения.Вставить("МаркируемаяАлкогольнаяПродукция", Неопределено); // Вся; Булево - [не]маркируемая. 
	ПараметрыЗаполнения.Вставить("ИмпортПроизводство",              Неопределено); // Вся; Булево - Ложь=импорт, Истина=РФ.
	ПараметрыЗаполнения.Вставить("ЗаполнитьИндексАкцизнойМарки",    Ложь);
	ПараметрыЗаполнения.Вставить("ОбработатьУпаковки",              Истина);
	ПараметрыЗаполнения.Вставить("ПерезаполнитьНоменклатуруЕГАИС",  Ложь);
	ПараметрыЗаполнения.Вставить("ПересчитатьКоличествоЕдиниц",     Ложь);
	ПараметрыЗаполнения.Вставить("ПересчитатьКоличествоУпаковок",   Ложь);
	ПараметрыЗаполнения.Вставить("ПересчитатьСумму",                Ложь);
	ПараметрыЗаполнения.Вставить("ПересчитатьЦенуПоСумме",          Ложь);
	ПараметрыЗаполнения.Вставить("ПроверитьСериюРассчитатьСтатус",  Ложь);
	ПараметрыЗаполнения.Вставить("ШтрихкодыВТЧ",                    Ложь);
	ПараметрыЗаполнения.Вставить("МаркируемаяПродукцияВТЧ",         Ложь);

	ПараметрыЗаполнения.Вставить("ЗаполнитьАртикул",                Ложь);
	ПараметрыЗаполнения.Вставить("ЗаполнитьКод",                    Ложь);
	ПараметрыЗаполнения.Вставить("ЗаполнитьЕдиницуИзмерения",       Истина);
	ПараметрыЗаполнения.Вставить("ЗаполнитьТипНоменклатуры",        Истина);
	
	Возврат ПараметрыЗаполнения;
	
КонецФункции

Функция ТекстОшибкиНеСоответствуютДокументуОснованию(ДанныеШтрихкода) Экспорт
	
	ЧастиТекстаОшибки = Новый Массив;
	
	ЧастиТекстаОшибки.Добавить(НСтр("ru = 'Не удалось сопоставить данным документа следующие данные:';
									|en = 'Не удалось сопоставить данным документа следующие данные:'"));
	ЧастиТекстаОшибки.Добавить(" ");
	ЧастиТекстаОшибки.Добавить(
		СтрШаблон(НСтр("ru = 'номенклатура - %1';
						|en = 'номенклатура - %1'"),
			?(ЗначениеЗаполнено(ДанныеШтрихкода.Номенклатура),
				ДанныеШтрихкода.Номенклатура,
				НСтр("ru = 'Не определена';
					|en = 'Не определена'"))));
	Если ЗначениеЗаполнено(ДанныеШтрихкода.Характеристика) Тогда
		ЧастиТекстаОшибки.Добавить(", ");
		ЧастиТекстаОшибки.Добавить(
			СтрШаблон(НСтр("ru = 'Характеристика - %1';
							|en = 'Характеристика - %1'"), ДанныеШтрихкода.Характеристика));
	КонецЕсли;
	Если ЗначениеЗаполнено(ДанныеШтрихкода.Серия) Тогда
		ЧастиТекстаОшибки.Добавить(", ");
		ЧастиТекстаОшибки.Добавить(
			СтрШаблон(НСтр("ru = 'Серия - %1';
							|en = 'Серия - %1'"), ДанныеШтрихкода.Серия));
	КонецЕсли;
	Возврат СтрСоединить(ЧастиТекстаОшибки);
	
КонецФункции

// Возвращает имя формы рабочего места по оформлению входящих ТТН.
// 
// Возвращаемое значение:
//  Строка - имя формы.
//
Функция ИмяФормыРабочегоМестаПоОформлениюДокументаТТНВходящаяЕГАИС() Экспорт
	
	ИмяФормы = "Документ.ТТНВходящаяЕГАИС.Форма.ФормаСписка";
	ИнтеграцияЕГАИСКлиентСерверПереопределяемый.ИмяФормыРабочегоМестаПоОформлениюДокументаТТНВходящаяЕГАИС(ИмяФормы);
	Возврат ИмяФормы;
	
КонецФункции

// Заполняет минимальные цены алкогольной продукции в товарах
//
// Параметры:
//  Товары          - ТабличнаяЧасть - "Товары" документа
//  СписокНарушений - Массив - с результатами проверки минимальных цен
//
Процедура ЗаполнитьМинимальныеЦеныВТоварах(Товары, СписокНарушений) Экспорт
	
	ШаблонДетализации = НСтр("ru = 'Минимальная цена - %1 руб. Вид продукции - %2. Операция - %3. Крепость - %4. Объем - %5 л. Минимальная цена для объема 0,5 л. - %6 руб.';
							|en = 'Минимальная цена - %1 руб. Вид продукции - %2. Операция - %3. Крепость - %4. Объем - %5 л. Минимальная цена для объема 0,5 л. - %6 руб.'");
	
	Для каждого СтрокаНарушения Из СписокНарушений Цикл
		ПараметрыОтбора = Новый Структура;
		ПараметрыОтбора.Вставить("Номенклатура",   СтрокаНарушения.Номенклатура);
		ПараметрыОтбора.Вставить("Характеристика", СтрокаНарушения.Характеристика);
		ПараметрыОтбора.Вставить("Серия",          СтрокаНарушения.Серия);
		
		СтрокиСАлкогольнойПродукцией = Товары.НайтиСтроки(ПараметрыОтбора);
		
		Для каждого СтрокаТоваров Из СтрокиСАлкогольнойПродукцией Цикл
			СтрокаТоваров.МинимальнаяЦена = СтрокаНарушения.МинимальнаяЦена;
			СтрокаТоваров.ДетализацияМинимальнойЦены = СтрШаблон(ШаблонДетализации, Формат(СтрокаНарушения.МинимальнаяЦена, "ЧДЦ=2"),
				СтрокаНарушения.ВидПодакцизногоТовара, СтрокаНарушения.ВидОперации, Формат(СтрокаНарушения.Крепость, "ЧДЦ=3"),
				Формат(СтрокаНарушения.Объем, "ЧДЦ=3"), Формат(СтрокаНарушения.МинимальнаяЦенаБезУчетаОбъема, "ЧДЦ=2"));
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти