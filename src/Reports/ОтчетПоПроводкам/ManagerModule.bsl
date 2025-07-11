#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Инициализирует набор параметров, задающих флаги выполнения дополнительных действий над сущностями, обрабатываемыми
// в процессе формирования отчета.
//
// Возвращаемое значение:
//   Структура   - флаги, задающие необходимость дополнительных действий.
//
Функция ПолучитьПараметрыИсполненияОтчета() Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("ИспользоватьПередКомпоновкойМакета", Истина);
	Результат.Вставить("ИспользоватьПослеКомпоновкиМакета",  Истина);
	Результат.Вставить("ИспользоватьПослеВыводаРезультата",  Истина);
	Результат.Вставить("ИспользоватьДанныеРасшифровки",      Истина);
	Возврат Результат;

КонецФункции

// Формирует текст, выводимый в заголовке отчета.
//
// Параметры:
//  ПараметрыОтчета - Структура - см. ПодготовитьПараметрыОтчета() в ФормаОтчета.
//
// Возвращаемое значение:
//   Строка      - текст заголовка с учетом периода.
//
Функция ПолучитьТекстЗаголовка(ПараметрыОтчета) Экспорт 
	
	Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Отчет по проводкам%1';
			|en = 'Posting report%1'"),
		БухгалтерскиеОтчетыКлиентСервер.ПолучитьПредставлениеПериода(ПараметрыОтчета.НачалоПериода, ПараметрыОтчета.КонецПериода));

КонецФункции

// В процедуре можно доработать компоновщик перед выводом в отчет. Изменения сохранены не будут.
//
// Параметры:
//  ПараметрыОтчета - Структура - см. ПодготовитьПараметрыОтчета() в ФормаОтчета.
//  Схема        - СхемаКомпоновкиДанных - описание получаемых данных.
//  КомпоновщикНастроек - КомпоновщикНастроекКомпоновкиДанных - связь настроек компоновки данных и схемы компоновки.
//
Процедура ПередКомпоновкойМакета(ПараметрыОтчета, Схема, КомпоновщикНастроек) Экспорт
	
	Если ЗначениеЗаполнено(ПараметрыОтчета.НачалоПериода) Тогда
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "НачалоПериода", НачалоДня(ПараметрыОтчета.НачалоПериода));
	КонецЕсли;
	Если ЗначениеЗаполнено(ПараметрыОтчета.КонецПериода) Тогда
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "КонецПериода", КонецДня(ПараметрыОтчета.КонецПериода));
	КонецЕсли;
	
	БухгалтерскиеОтчетыПереопределяемый.УстановитьПараметрыВалют(Схема, КомпоновщикНастроек, ПараметрыОтчета);
	
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "ПС", Символы.ПС);

	ЛинияСплошная = Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная, 1);
	
	МассивМакетов = Новый Массив;
	МассивМакетов.Добавить("ЗаголовокПодвал");
	МассивМакетов.Добавить("ПроводкиЗаголовок");	
	
	Для Каждого ЭлементМассива Из МассивМакетов Цикл
		Схема.Макеты[ЭлементМассива].Макет = БухгалтерскиеОтчетыВызовСервера.ПолучитьКопиюОписанияМакета(Схема.Макеты[ЭлементМассива + "Образец"].Макет);
		ОписаниеМакета = Схема.Макеты[ЭлементМассива].Макет;
		МассивСтрокДляУдаления = Новый Массив;
		Индекс = 0;
		НетНедоступныхПоказателей = Истина;
		Для Каждого ЭлементПоказатель Из ПараметрыОтчета.НаборПоказателей Цикл
			Если Не ПараметрыОтчета["Показатель" + ЭлементПоказатель] Тогда 
				МассивСтрокДляУдаления.Добавить(ОписаниеМакета[Индекс]);
			ИначеЕсли (НЕ (ЭлементПоказатель = "Количество")) 
				И (НЕ БухгалтерскиеОтчетыКлиентСервер.ПоказательДоступен(КомпоновщикНастроек.Настройки.ДоступныеПоляВыбора, "Суммы." + ЭлементПоказатель + "Дт")) Тогда
				МассивСтрокДляУдаления.Добавить(ОписаниеМакета[Индекс]);
				НетНедоступныхПоказателей = Ложь;
			КонецЕсли;
			Индекс = Индекс + 1;
		КонецЦикла;		
		
		// Каждому показателю отчета в образце (макет "ПроводкиОбразец: Заголовок") соответствует строка.
		// Строки показатели которых не включены или недоступны, нужно удалить.
		// В образце также есть строка не соответствующая ни одному показателю (пустая).
		// Если есть недоступные показатели которые включены (ПараметрыОтчета["Показатель" + ЭлементПоказатель] = Истина)
		// нужно удалить строки соответствующие этим показателям и вывести пустую строку (чтобы не портить структуру отчета).
		// В остальных случаях нужно всегда удалять пустую строку (последняя строка в образце).
		Если НетНедоступныхПоказателей И Индекс = ОписаниеМакета.Количество() - 1 Тогда
			МассивСтрокДляУдаления.Добавить(ОписаниеМакета[Индекс]);
		КонецЕсли;	
		
		Для Каждого Строка Из МассивСтрокДляУдаления Цикл
			ОписаниеМакета.Удалить(Строка);
		КонецЦикла;
		
		КоличествоСтрок = ОписаниеМакета.Количество();
		
		// Обвести область.
		Если КоличествоСтрок > 0 Тогда
			Для Индекс = 0 По 10 Цикл
				ПоследняяСтрока = ?(ЭлементМассива = "ЗаголовокПодвал" И Индекс < 4, 0, КоличествоСтрок - 1);
				ПараметрГраницы = БухгалтерскиеОтчетыКлиентСервер.ПолучитьПараметр(ОписаниеМакета[0].Ячейки[Индекс].Оформление.Элементы, "СтильГраницы");
				БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(ПараметрГраницы.ЗначенияВложенныхПараметров, "СтильГраницы.Сверху", ЛинияСплошная);
				ПараметрГраницы = БухгалтерскиеОтчетыКлиентСервер.ПолучитьПараметр(ОписаниеМакета[ПоследняяСтрока].Ячейки[Индекс].Оформление.Элементы, "СтильГраницы");
				БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(ПараметрГраницы.ЗначенияВложенныхПараметров, "СтильГраницы.Снизу", ЛинияСплошная);	
			КонецЦикла;
		КонецЕсли;
		
		Для Индекс = 1 По КоличествоСтрок - 1 Цикл
			ОписаниеМакета[Индекс].Ячейки[0].Элементы.Очистить();	
			БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(ОписаниеМакета[Индекс].Ячейки[0].Оформление.Элементы, "ОбъединятьПоВертикали", Истина);
			БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(ОписаниеМакета[Индекс].Ячейки[0].Оформление.Элементы, "Расшифровка", Неопределено, Ложь);
			ОписаниеМакета[Индекс].Ячейки[1].Элементы.Очистить();
			БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(ОписаниеМакета[Индекс].Ячейки[1].Оформление.Элементы, "ОбъединятьПоВертикали", Истина);
			БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(ОписаниеМакета[Индекс].Ячейки[1].Оформление.Элементы, "Расшифровка", Неопределено, Ложь);
			ОписаниеМакета[Индекс].Ячейки[2].Элементы.Очистить();
			БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(ОписаниеМакета[Индекс].Ячейки[2].Оформление.Элементы, "ОбъединятьПоВертикали", Истина);
			БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(ОписаниеМакета[Индекс].Ячейки[2].Оформление.Элементы, "Расшифровка", Неопределено, Ложь);
			ОписаниеМакета[Индекс].Ячейки[3].Элементы.Очистить();
			БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(ОписаниеМакета[Индекс].Ячейки[3].Оформление.Элементы, "ОбъединятьПоВертикали", Истина);
			БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(ОписаниеМакета[Индекс].Ячейки[3].Оформление.Элементы, "Расшифровка", Неопределено, Ложь);
			Если ЭлементМассива = "ПроводкиЗаголовок" Тогда
				ОписаниеМакета[Индекс].Ячейки[5].Элементы.Очистить();
				БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(ОписаниеМакета[Индекс].Ячейки[5].Оформление.Элементы, "ОбъединятьПоВертикали", Истина);
				БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(ОписаниеМакета[Индекс].Ячейки[5].Оформление.Элементы, "Расшифровка", Неопределено, Ложь);
				ОписаниеМакета[Индекс].Ячейки[8].Элементы.Очистить();
				БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(ОписаниеМакета[Индекс].Ячейки[8].Оформление.Элементы, "ОбъединятьПоВертикали", Истина);
				БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(ОписаниеМакета[Индекс].Ячейки[8].Оформление.Элементы, "Расшифровка", Неопределено, Ложь);
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	Если Не ПараметрыОтчета.ПоказательБУ Тогда
		ГруппаОтборов = КомпоновщикНастроек.Настройки.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
		ГруппаОтборов.Использование = Истина;
		ГруппаОтборов.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;
		Если ПараметрыОтчета.ПоказательНУ Тогда
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ГруппаОтборов, "Суммы.НУДт", 0, ВидСравненияКомпоновкиДанных.НеРавно);
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ГруппаОтборов, "Суммы.НУКт", 0, ВидСравненияКомпоновкиДанных.НеРавно);
		КонецЕсли;
		Если ПараметрыОтчета.ПоказательПР Тогда
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ГруппаОтборов, "Суммы.ПРДт", 0, ВидСравненияКомпоновкиДанных.НеРавно);
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ГруппаОтборов, "Суммы.ПРКт", 0, ВидСравненияКомпоновкиДанных.НеРавно);
		КонецЕсли;
		Если ПараметрыОтчета.ПоказательВР Тогда
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ГруппаОтборов, "Суммы.ВРДт", 0, ВидСравненияКомпоновкиДанных.НеРавно);
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ГруппаОтборов, "Суммы.ВРКт", 0, ВидСравненияКомпоновкиДанных.НеРавно);
		КонецЕсли;
		Если ПараметрыОтчета.ПоказательВалютнаяСумма Тогда
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ГруппаОтборов, "Суммы.ВалютнаяСуммаДт", 0, ВидСравненияКомпоновкиДанных.НеРавно);
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ГруппаОтборов, "Суммы.ВалютнаяСуммаКт", 0, ВидСравненияКомпоновкиДанных.НеРавно);
		КонецЕсли;
		Если ПараметрыОтчета.ПоказательКоличество Тогда
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ГруппаОтборов, "КоличествоДт", 0, ВидСравненияКомпоновкиДанных.НеРавно);
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ГруппаОтборов, "КоличествоКт", 0, ВидСравненияКомпоновкиДанных.НеРавно);	
		КонецЕсли;	
	КонецЕсли;
	
	
	МассивОтборов = Новый Массив;
	Для Каждого ЭлементОтбора Из КомпоновщикНастроек.Настройки.Отбор.Элементы Цикл
		Если ТипЗнч(ЭлементОтбора) = Тип("ЭлементОтбораКомпоновкиДанных") Тогда 
			ДоступныеПоляОтбора = КомпоновщикНастроек.Настройки.Отбор.ДоступныеПоляОтбора;
			Если ДоступныеПоляОтбора.НайтиПоле(ЭлементОтбора.ЛевоеЗначение) = Неопределено
				И ДоступныеПоляОтбора.НайтиПоле(Новый ПолеКомпоновкиДанных(СтрЗаменить(Строка(ЭлементОтбора.ЛевоеЗначение), "Субконто", "СубконтоДт"))) <> Неопределено Тогда 
				МассивОтборов.Добавить(ЭлементОтбора);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого ЭлементОтбора Из МассивОтборов Цикл
		ГруппаИЛИ = КомпоновщикНастроек.Настройки.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
		ГруппаИЛИ.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;
		БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ГруппаИЛИ, СтрЗаменить(ЭлементОтбора.ЛевоеЗначение, "Субконто", "СубконтоДт"), ЭлементОтбора.ПравоеЗначение, ЭлементОтбора.ВидСравнения); 
		БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ГруппаИЛИ, СтрЗаменить(ЭлементОтбора.ЛевоеЗначение, "Субконто", "СубконтоКт"), ЭлементОтбора.ПравоеЗначение, ЭлементОтбора.ВидСравнения); 
		КомпоновщикНастроек.Настройки.Отбор.Элементы.Удалить(ЭлементОтбора);	
	КонецЦикла;
	
	БухгалтерскиеОтчетыВызовСервера.ДобавитьОтборПоОрганизации(ПараметрыОтчета, КомпоновщикНастроек);
	
КонецПроцедуры

// В процедуре можно уточнить особенности вывода данных в отчет.
//
// Параметры:
//  ПараметрыОтчета - Структура - см. ПодготовитьПараметрыОтчета() в ФормаОтчета.
//  МакетКомпоновки - МакетКомпоновкиДанных - описание выводимых данных.
//
Процедура ПослеКомпоновкиМакета(ПараметрыОтчета, МакетКомпоновки) Экспорт
	
	КоличествоПоказателей = БухгалтерскиеОтчетыВызовСервера.КоличествоПоказателей(ПараметрыОтчета);
	
	// Если показатель один, то удалим столбик "Показатель".
	Если КоличествоПоказателей = 1 Тогда
		Для Каждого Макет Из МакетКомпоновки.Макеты Цикл
			
			// Пропускаем макеты не соответствующего типа.
			Если ТипЗнч(Макет) = Тип("ОписаниеМакетаОбластиМакетаКомпоновкиДанных")
				И ТипЗнч(Макет.Макет) <> Тип("МакетОбластиКомпоновкиДанных") Тогда
				Продолжить;
			КонецЕсли;
			
			Для Каждого СтрокаМакета Из Макет.Макет Цикл
				Если СтрокаМакета.Ячейки.Количество() > 4 Тогда // удаляем только из неслужебных строк
					СтрокаМакета.Ячейки.Удалить(СтрокаМакета.Ячейки[4]);
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

// В процедуре можно изменить табличный документ после вывода в него данных.
//
// Параметры:
//  ПараметрыОтчета - Структура - см. ПодготовитьПараметрыОтчета() в ФормаОтчета.
//  Результат    - ТабличныйДокумент - сформированный отчет.
//
Процедура ПослеВыводаРезультата(ПараметрыОтчета, Результат) Экспорт
	
	БухгалтерскиеОтчетыВызовСервера.ОбработкаРезультатаОтчета(ПараметрыОтчета.ИдентификаторОтчета, Результат);

	ВысотаЗаголовка = ?(Результат.Области.Найти("Заголовок") = Неопределено, 0, Результат.Области.Заголовок.Низ);
	ВысотаПараметров = 0;
	БухгалтерскиеОтчетыПереопределяемый.ВысотаВыводимыхПараметров(ПараметрыОтчета.СхемаКомпоновкиДанных, ВысотаПараметров);

	Результат.ФиксацияСверху = ВысотаЗаголовка + 2 + ВысотаПараметров;
	
КонецПроцедуры

// Задает набор показателей, которые позволяет анализировать отчет.
//
// Возвращаемое значение:
//   Массив      - основные суммовые показатели отчета.
//
Функция ПолучитьНаборПоказателей() Экспорт
	
	НаборПоказателей = Новый Массив;
	НаборПоказателей.Добавить("БУ");
	НаборПоказателей.Добавить("НУ");
	НаборПоказателей.Добавить("ПР");
	НаборПоказателей.Добавить("ВР");
	НаборПоказателей.Добавить("ВалютнаяСумма");
	НаборПоказателей.Добавить("Количество");
	
	БухгалтерскиеОтчетыПереопределяемый.ДополнительныеПоказателиБухгалтерскихОтчетов(НаборПоказателей);
	
	Возврат НаборПоказателей;
	
КонецФункции

#КонецОбласти

#Область РасшифровкаСтандартныхОтчетов

// Заполняет настройки расшифровки (см. БухгалтерскиеОтчетыКлиентСервер.НовыйУниверсальныеНастройки) для переданного экземпляра отчета.
//
// Параметры:
//  Настройки				 - Структура								 - Настройки расшифровки отчета, которые нужно заполнить (см. БухгалтерскиеОтчетыКлиентСервер.НовыйУниверсальныеНастройки).
//  Объект					 - ОтчетОбъект								 - Отчет из данных которого нудно собрать универсальные настройки.
//  ДанныеРасшифровки		 - ДанныеРасшифровкиКомпоновкиДанных		 - Данные расшифровки отчета.
//  ИдентификаторРасшифровки - ИдентификаторРасшифровкиКомпоновкиДанных  - Идентификатор расшифровки из ячейки для которой вызвана расшифровка.
//  РеквизитыРасшифровки	 - Структура								 - Реквизиты отчета полученные из контекста расшифровываемой ячейки.
//
Процедура ЗаполнитьНастройкиРасшифровки(Настройки, Объект, ДанныеРасшифровки, ИдентификаторРасшифровки, РеквизитыРасшифровки) Экспорт

	БухгалтерскиеОтчетыРасшифровка.ЗаполнитьНастройкиРасшифровкиПоДаннымСтандартногоОтчета(
		Настройки,
		ДанныеРасшифровки,
		ИдентификаторРасшифровки,
		Объект,
		РеквизитыРасшифровки);
	
КонецПроцедуры

// Адаптирует переданные настройки для данного вида отчетов.
// Перед применением настроек расшифровки может возникнуть необходимость учесть особенности этого вида отчетов.
//
// Параметры:
//  Настройки	 - Структура - Настройки которые нужно адаптировать (см. БухгалтерскиеОтчетыКлиентСервер.НовыйУниверсальныеНастройки).
//
Процедура АдаптироватьНастройки(Настройки) Экспорт
	
	// В отчете по проводкам фиксированная сортировка
	// удаляем сортировку поступившую из настроек.
	Настройки.Порядок.Элементы.Очистить();
	
	БухТипРесурса = Неопределено;
	
	Настройки.Свойство("БухТипРесурса", БухТипРесурса);
	
	Если ЗначениеЗаполнено(БухТипРесурса) Тогда
		
		ПоляЗависящиеОтБухТипРесурса = Новый Структура;
		
		ПоляЗависящиеОтБухТипРесурса.Вставить("Счет", "Счет" + БухТипРесурса);
		ПоляЗависящиеОтБухТипРесурса.Вставить("Подразделение", "Подразделение" + БухТипРесурса);
		ПоляЗависящиеОтБухТипРесурса.Вставить("КорСчет", "Счет" + ?(БухТипРесурса = "Дт", "Кт", "Дт"));
		
		Для НомерСубконто = 1 По БухгалтерскийУчет.МаксимальноеКоличествоСубконто() Цикл
			ПоляЗависящиеОтБухТипРесурса.Вставить("Субконто" + НомерСубконто, "Субконто" + БухТипРесурса + НомерСубконто);
		КонецЦикла;
		
		УстановитьБухТипРесурсаВОтборах(Настройки.Отбор.Элементы, ПоляЗависящиеОтБухТипРесурса);
		
	КонецЕсли;
	
	// Удалим автоотступ из условного оформления.
	БухгалтерскиеОтчеты.УдалитьАвтоотступИзУсловногоОформления(Настройки.УсловноеОформление);
	
КонецПроцедуры

Процедура УстановитьБухТипРесурсаВОтборах(ЭлементыОтбора, ПоляЗависящиеОтБухТипРесурса)
	
	Для Каждого ЭлементОтбора Из ЭлементыОтбора Цикл
		
		Если ТипЗнч(ЭлементОтбора) = Тип("ГруппаЭлементовОтбораКомпоновкиДанных") Тогда
			УстановитьБухТипРесурсаВОтборах(ЭлементОтбора.Элементы, ПоляЗависящиеОтБухТипРесурса);
			Продолжить;
		КонецЕсли;
		
		Для Каждого ЗависимоеПоле Из ПоляЗависящиеОтБухТипРесурса Цикл
			
			Если СтрНачинаетсяС(ЭлементОтбора.ЛевоеЗначение, ЗависимоеПоле.Ключ) Тогда
				
				ПутьЛевогоЗначения = СтрРазделить(ЭлементОтбора.ЛевоеЗначение, ".");
				
				ПутьЛевогоЗначения.Установить(0, ЗависимоеПоле.Значение);
				
				ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(СтрСоединить(ПутьЛевогоЗначения, "."));
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

// Устанавливает какими отчетами и при каких условиях может быть расшифрован этот вид отчетов.
//
// Параметры:
//  Правила - ТаблицаЗначений с правилами расшифровки этого отчета см. БухгалтерскиеОтчетыРасшифровка.НовыйПравилаРасшифровки.
//
Процедура ЗаполнитьПравилаРасшифровки(Правила) Экспорт

КонецПроцедуры

#КонецОбласти

#КонецЕсли