////////////////////////////////////////////////////////////////////////////////
// Подсистема "Коммерческие предложения документы".
// ОбщийМодуль.КоммерческиеПредложенияДокументыКлиентСервер
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#Область ОтборыСписков

// Устанавливает отбор в списке по указанному значению для нужной колонки
// с учетом переданной структуры быстрого отбора.
//
// Параметры:
//  Список                  - ДинамическийСписок - список, для которого требуется установить отбор.
//  ИмяКолонки              - Строка - имя колонки, по которой устанавливается отбор.
//  Значение                - Произвольный - устанавливаемое значение отбора.
//  СтруктураБыстрогоОтбора - Неопределено, Структура - содержит ключи и значения отбора.
//  Использование           - Неопределено, Булево - признак использования элемента отбора.
//  ВидСравнения            - Неопределено, ВидСравненияКомпоновкиДанных - вид сравнения, устанавливаемый для элемента отбора.
//  ИмяНастройки            - Строка - имя настройки формы, в которой содержится значение отбора.
//
Процедура ОтборПоЗначениюСпискаПриСозданииНаСервере(Список, ИмяКолонки, Значение, Знач СтруктураБыстрогоОтбора, 
			Использование = Неопределено, ВидСравнения = Неопределено, ИмяНастройки = "") Экспорт
	
	Если СтруктураБыстрогоОтбора <> Неопределено Тогда
		
		Если ПустаяСтрока(ИмяНастройки) Тогда
			ИмяНастройки = ИмяКолонки;
		КонецЕсли;
		
		Если СтруктураБыстрогоОтбора.Свойство(ИмяНастройки, Значение) Тогда
			ИспользованиеЭлементаОтбора = ?(Использование = Неопределено, ЗначениеЗаполнено(Значение), Использование);
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, ИмяКолонки, Значение, ВидСравнения,,ИспользованиеЭлементаОтбора);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Устанавливает отбор в списке по указанному значению для нужной колонки
// с учетом переданной структуры быстрого отбора.
//
// Параметры:
//  Параметры               - Структура - настройки отбора списка документов:
//  * Список                - ДинамическийСписок - список, для которого требуется установить отбор.
//  * ИмяКолонки            - Строка - имя колонки, по которой устанавливается отбор.
//  * ИмяНастройки          - Строка - имя сохраненной настройки.
//  * Настройки             - НастройкиКомпоновкиДанных  -настройки, из которых могут получаться значения отбора
//  * Использование         - Неопределено, Булево - признак использования элемента отбора.
//  * ВидСравнения          - Неопределено, ВидСравненияКомпоновкиДанных - вид сравнения, устанавливаемый для элемента отбора.
//  Значение                - Произвольный - устанавливаемое значение отбора.
//  СтруктураБыстрогоОтбора - Неопределено, Структура - содержит ключи и значения отбора.
//
Процедура ОтборПоЗначениюСпискаПередЗагрузкойИзНастроек(Параметры, Значение, Знач СтруктураБыстрогоОтбора) Экспорт
	
	Список             = Параметры.Список;
	ИмяКолонки         = Параметры.ИмяКолонки;
	ИмяНастройки       = Параметры.ИмяНастройки;
	Настройки          = Параметры.Настройки;
	Использование      = Параметры.Использование;
	ВидСравненияОтбора = Параметры.ВидСравнения;
	
	Если СтруктураБыстрогоОтбора = Неопределено Тогда
		Значение = Настройки.Получить(ИмяНастройки);
		ИспользованиеЭлементаОтбора = ?(Использование = Неопределено, ЗначениеЗаполнено(Значение), Использование);
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, ИмяКолонки, Значение, ВидСравненияОтбора,,ИспользованиеЭлементаОтбора);
	Иначе
		Если Не СтруктураБыстрогоОтбора.Свойство(ИмяНастройки) Тогда
			Значение = Настройки.Получить(ИмяНастройки);
			ИспользованиеЭлементаОтбора = ?(Использование = Неопределено, ЗначениеЗаполнено(Значение), Использование);
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, ИмяКолонки, Значение, ВидСравненияОтбора,,ИспользованиеЭлементаОтбора);
		КонецЕсли;
	КонецЕсли;
	
	Настройки.Удалить(ИмяНастройки);
	
КонецПроцедуры

#КонецОбласти

// Заполняет список выбора для отбора по актуальности.
//
// Параметры:
//  СписокВыбораАктуальности - СписокЗначений - список выбора, который необходимо заполнить.
//
Процедура ЗаполнитьСписокВыбораОтбораПоАктуальности(СписокВыбораАктуальности) Экспорт
	
	СписокВыбораАктуальности.Добавить("НеИстек",        НСтр("ru = 'Не истек';
															|en = 'Not expired'"));
	СписокВыбораАктуальности.Добавить("Истек",          НСтр("ru = 'Истек';
															|en = 'Expired'"));
	СписокВыбораАктуальности.Добавить("Сегодня",        НСтр("ru = 'Сегодня';
															|en = 'Today'"));
	СписокВыбораАктуальности.Добавить("Завтра",         НСтр("ru = 'Завтра';
															|en = 'Tomorrow'"));
	СписокВыбораАктуальности.Добавить("Послезавтра",    НСтр("ru = 'Послезавтра';
															|en = 'The day after tomorrow'"));
	СписокВыбораАктуальности.Добавить("ЧерезНеделю",    НСтр("ru = 'Через неделю';
															|en = 'In a week'"));
	СписокВыбораАктуальности.Добавить("ИстекаетНаДату", НСтр("ru = 'Истекает на дату...';
															|en = 'Expires on date ...'"));
	
КонецПроцедуры

// Устанавливает переданный в форму списка документов отбор по актуальности.
//
// Параметры:
//  Список                  - ДинамическийСписок - список, в котором необходимо установить отбор.
//  Актуальность            - Строка - строка отбора по актуальности.
//  ДатаСобытия             - Дата - дата, на которую необходимо считать документы неактуальными.
//  ТекущаяДата             - Дата - текущая дата сеанса.
//  СтруктураБыстрогоОтбора - Структура - переданный в форму списка документов отбор.
//  СписокВыбора            - СписокЗначений - список, отображаемый в элементе формы.
//
Процедура ОтборПоАктуальностиПриСозданииНаСервере(Список, Актуальность, ДатаСобытия, ТекущаяДата, Знач СтруктураБыстрогоОтбора, СписокВыбора) Экспорт
	
	Если СтруктураБыстрогоОтбора <> Неопределено Тогда
		
		СтруктураБыстрогоОтбора.Свойство("Актуальность", Актуальность);
		СтруктураБыстрогоОтбора.Свойство("ДатаСобытия",  ДатаСобытия);
		
		ДобавитьЭлементСпискаАктуальностиЕслиНеобходимо(СписокВыбора, Актуальность, ДатаСобытия);
		
		ПриИзмененииОтбораПоАктуальности(Список, Актуальность, ДатаСобытия, ТекущаяДата, СписокВыбора);
		
	КонецЕсли;
	
КонецПроцедуры

// Устанавливает в форме списка документов отбор по актуальности и дате актуальности.
// Изменяет значение даты актуальности в зависимости от строки актуальности.
//
// Параметры:
//  Список               - ДинамическийСписок - список, в котором необходимо установить отбор
//  Актуальность         - Строка - строка отбора по актуальности
//  ДатаСобытия          - Дата - дата, на которую документ будет просрочен
//  ТекущаяДата          - Дата - текущая дата сеанса.
//  СтандартнаяОбработка - Булево - флаг выполнения стандартной обработки при очистке значения поля.
//  СписокВыбора         - СписокЗначений - список, содержащий возможные значения отбора.
//
Процедура ПриОчисткеОтбораПоАктуальности(Список, Актуальность, ДатаСобытия, ТекущаяДата, СтандартнаяОбработка, СписокВыбора) Экспорт
	
	СтандартнаяОбработка = Ложь;
	Если ЗначениеЗаполнено(Актуальность) Тогда
		Актуальность = "";
		ПриИзмененииОтбораПоАктуальности(Список, Актуальность, ДатаСобытия, ТекущаяДата, СписокВыбора);
	КонецЕсли;
	
КонецПроцедуры

// Устанавливает в форме списка документов отбор по актуальности и дате актуальности
// Изменяет значение даты актуальности в зависимости от строки актуальности.
//
// Параметры:
//  Список       - ДинамическийСписок - список, в котором необходимо установить отбор
//  Актуальность - Строка - строка отбора по актуальности
//  ДатаСобытия  - Дата - дата, на которую документы считаются неактуальными
//  ТекущаяДата  - Дата - текущая дата сеанса.
//  СписокВыбора - СписокЗначений - содержащий возможные значения отбора.
//
Процедура ПриИзмененииОтбораПоАктуальности(Список, Актуальность, ДатаСобытия, ТекущаяДата, СписокВыбора) Экспорт
	
	Если НЕ ЗначениеЗаполнено(Актуальность) Тогда
		ДатаСобытия      = Дата(1,1,1);
	ИначеЕсли Актуальность = "Сегодня" Тогда
		ДатаСобытия = ТекущаяДата;
	ИначеЕсли Актуальность = "Завтра" Тогда
		ДатаСобытия = ТекущаяДата + 86400;
	ИначеЕсли Актуальность = "Послезавтра" Тогда
		ДатаСобытия = ТекущаяДата + 2*86400;
	ИначеЕсли Актуальность = "ЧерезНеделю" Тогда
		ДатаСобытия = ТекущаяДата + 7*86400;
	ИначеЕсли Актуальность = "Истек" Тогда
		ДатаСобытия      = Дата(1,1,1);
	ИначеЕсли Актуальность = "НеИстек" Тогда
		ДатаСобытия      = Дата(1,1,1);
	КонецЕсли;
	
	Если Актуальность <> "ИстекаетНаДатуВыбран" Тогда
		УдалитьИзСпискаВыбраннуюДату(СписокВыбора);
	КонецЕсли;
	
	УстановитьОтборВСпискеПоАктуальности(Список, Актуальность);
	УстановитьОтборВСпискеПоДатеСобытия(Список, ДатаСобытия);
	
КонецПроцедуры

// Устанавливает в форме списка документов отбор по актуальности.
//
// Параметры:
//  Список - ДинамическийСписок - список, в котором необходимо установить отбор.
//  Актуальность - Строка - строка отбора по актуальности.
//
Процедура УстановитьОтборВСпискеПоАктуальности(Список, Актуальность) Экспорт
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, 
		"Истек",
		Актуальность = "Истек",
		ВидСравненияКомпоновкиДанных.Равно,,
		Актуальность = "НеИстек" Или Актуальность = "Истек");
	
КонецПроцедуры

// Удаляет из списка выбора элемент с выбранной датой.
//
// Параметры:
//  СписокВыбора - СписокЗначений - список, из которого удаляется значение.
//
Процедура УдалитьИзСпискаВыбраннуюДату(СписокВыбора) Экспорт
	
	ЭлементСписка = СписокВыбора.НайтиПоЗначению("ИстекаетНаДатуВыбран");
	Если ЭлементСписка <> Неопределено Тогда
		СписокВыбора.Удалить(ЭлементСписка);
	КонецЕсли;
	
КонецПроцедуры

// Устанавливает в форме списка документов отбор по дате события.
//
// Параметры:
//  Список      - ДинамическийСписок - список, в котором необходимо установить отбор.
//  ДатаСобытия - Дата - дата, на которую документ будет просрочен.
//
Процедура УстановитьОтборВСпискеПоДатеСобытия(Список, ДатаСобытия) Экспорт
	
	ВидСравненияДатыСобытия = ВидСравненияКомпоновкиДанных.МеньшеИлиРавно;
	
	ГруппаОтбора = ОбщегоНазначенияКлиентСервер.СоздатьГруппуЭлементовОтбора(
		Список.КомпоновщикНастроек.ФиксированныеНастройки.Отбор.Элементы,
		НСтр("ru = 'Отбор по дате события';
			|en = 'Filter by event date'"), 
		ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ);
	
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(
		ГруппаОтбора,
		"ДатаСобытия",
		ВидСравненияДатыСобытия,
		ДатаСобытия,,
		ЗначениеЗаполнено(ДатаСобытия));
		
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(
		ГруппаОтбора,
		"ДатаСобытия",
		ВидСравненияКомпоновкиДанных.НеРавно,
		Дата(1,1,1),,
		ЗначениеЗаполнено(ДатаСобытия));

КонецПроцедуры

// Определяет видимость поля контрагент в форме документа.
//
// Параметры:
//  НастройкиУчета  - Структура - содержит настройки учета.
//
// Возвращаемое значение:
//   Булево   - Истина, если контрагент видим.
//
Функция ПолеКонтрагентВидимо(НастройкиУчета) Экспорт
	
	Возврат Не (НастройкиУчета.ИспользуютсяПартнеры 
	            И Не НастройкиУчета.НезависимоеВедениеПартнеровИКонтрагентов);
	
КонецФункции

// Определяет вариант указания срока поставки по содержащимся в массиве значениям.
//
// Параметры:
//  МассивЗначений  - Массив - содержит значения срока поставки.
//
// Возвращаемое значение:
//   ПеречислениеСсылка.ВариантыСроковПоставкиКоммерческихПредложений - определенный вариант указания.
//
Функция ВариантУказанияСрокаПоставкиПоЗначениям(МассивЗначений) Экспорт
	
	ВариантУказания = ПредопределенноеЗначение("Перечисление.ВариантыСроковПоставкиКоммерческихПредложений.НеУказывается");
	
	Для Каждого ЭлементМассива Из МассивЗначений Цикл
		
		Если ЗначениеЗаполнено(ЭлементМассива) Тогда
			
			Если ТипЗнч(ЭлементМассива) = Тип("Число") Тогда
				Возврат ПредопределенноеЗначение("Перечисление.ВариантыСроковПоставкиКоммерческихПредложений.УказываетсяВДняхСМоментаЗаказа");
			Иначе
				Возврат ПредопределенноеЗначение("Перечисление.ВариантыСроковПоставкиКоммерческихПредложений.УказываетсяНаОпределеннуюДату");
			КонецЕсли;
			
		КонецЕсли;
	
	КонецЦикла;
	
	Возврат ВариантУказания;
	
КонецФункции

// Настраивает колонку "Срок поставки" и команду изменяющую срок поставки, в зависимости от варианта указания.
//
// Параметры:
//  ВариантУказанияСрокаПоставки - ПеречислениеСсылка.ВариантыСроковПоставкиКоммерческихПредложений - вариант указания.
//  ЭлементФормыКолонка          - ЭлементыФормы - колонка табличной части, содержащая срок поставки.
//  ЭлементФормыКоманда          - ЭлементыФормы - элемент формы, содержащий команду, изменяющую срок поставки.
//
Процедура УправлениеКолонкойСрокПоставки(ВариантУказанияСрокаПоставки, ЭлементФормыКолонка, ЭлементФормыКоманда = Неопределено) Экспорт
	
	ЭлементФормыКолонка.Видимость        = ВариантУказанияСрокаПоставки <> ПредопределенноеЗначение("Перечисление.ВариантыСроковПоставкиКоммерческихПредложений.НеУказывается");
	Если ЭлементФормыКоманда <> Неопределено Тогда
		ЭлементФормыКоманда.Видимость = ВариантУказанияСрокаПоставки <> ПредопределенноеЗначение("Перечисление.ВариантыСроковПоставкиКоммерческихПредложений.НеУказывается");
	КонецЕсли;
	
	ЭлементФормыКолонка.ВыбиратьТип = Ложь;
	ОграничениеТипа = Новый ОписаниеТипов("Неопределено");
	Если ВариантУказанияСрокаПоставки = ПредопределенноеЗначение("Перечисление.ВариантыСроковПоставкиКоммерческихПредложений.УказываетсяНаОпределеннуюДату") Тогда
		ОграничениеТипа = Новый ОписаниеТипов("Дата",,,,,Новый КвалификаторыДаты(ЧастиДаты.Дата));
	ИначеЕсли ВариантУказанияСрокаПоставки = ПредопределенноеЗначение("Перечисление.ВариантыСроковПоставкиКоммерческихПредложений.УказываетсяВДняхСМоментаЗаказа") Тогда
		ОграничениеТипа = Новый ОписаниеТипов("Число",,,Новый КвалификаторыЧисла(3));
	КонецЕсли;
	ЭлементФормыКолонка.ОграничениеТипа = ОграничениеТипа;
	ЭлементФормыКолонка.Заголовок = ЗаголовокСрокПоставки(ВариантУказанияСрокаПоставки);
	
КонецПроцедуры

// Формирует представление значения срока поставки, в зависимости от варианта указания.
//
// Параметры:
//  ВариантУказанияСрокаПоставки - ПеречислениеСсылка.ВариантыСроковПоставкиКоммерческихПредложений - вариант указания.
//  СрокПоставки                 - Число, Дата - значение срока поставки
//
// Возвращаемое значение:
//   Строка   - сформированное представление значение срока поставки.
//
Функция СрокПоставкиСтрокой(ВариантУказанияСрокаПоставки, СрокПоставки) Экспорт

	ПредставлениеСрокаПоставки = "";
	
	Если Не ЗначениеЗаполнено(СрокПоставки)
		Или Не ЗначениеЗаполнено(ВариантУказанияСрокаПоставки) Тогда
		ПредставлениеСрокаПоставки = "";
	ИначеЕсли ВариантУказанияСрокаПоставки = ПредопределенноеЗначение("Перечисление.ВариантыСроковПоставкиКоммерческихПредложений.НеУказывается") Тогда
		ПредставлениеСрокаПоставки = НСтр("ru = 'не важно';
											|en = 'doesn''t matter'");
	ИначеЕсли ВариантУказанияСрокаПоставки = ПредопределенноеЗначение("Перечисление.ВариантыСроковПоставкиКоммерческихПредложений.УказываетсяВДняхСМоментаЗаказа") Тогда
		ПредставлениеСрокаПоставки = СтрШаблон(НСтр("ru = 'в течение %1 дн.';
													|en = 'during %1 days.'"), СрокПоставки);
	ИначеЕсли ВариантУказанияСрокаПоставки = ПредопределенноеЗначение("Перечисление.ВариантыСроковПоставкиКоммерческихПредложений.УказываетсяНаОпределеннуюДату") Тогда
		ПредставлениеСрокаПоставки = Формат(СрокПоставки,"ДЛФ=D");
	КонецЕсли;
	
	Возврат ПредставлениеСрокаПоставки;
	
КонецФункции

// Формирует заголовок колонки "Срок поставки".
//
// Параметры:
//  ВариантУказанияСрокаПоставки - ПеречислениеСсылка.ВариантыСроковПоставкиКоммерческихПредложений - вариант указания.
//
// Возвращаемое значение:
//   Строка   - сформированный заголовок колонки.
//
Функция ЗаголовокСрокПоставки(ВариантУказанияСрокаПоставки) Экспорт
	
	Если ВариантУказанияСрокаПоставки = ПредопределенноеЗначение("Перечисление.ВариантыСроковПоставкиКоммерческихПредложений.УказываетсяНаОпределеннуюДату") Тогда
		Возврат НСтр("ru = 'Дата поставки';
					|en = 'Delivery date'");
	ИначеЕсли ВариантУказанияСрокаПоставки = ПредопределенноеЗначение("Перечисление.ВариантыСроковПоставкиКоммерческихПредложений.УказываетсяВДняхСМоментаЗаказа") Тогда
		Возврат НСтр("ru = 'Срок поставки (дн.)';
					|en = 'Delivery period (days)'");
	Иначе
		Возврат "";
	КонецЕсли;
	
КонецФункции

// Очищает в колонке табличной части срок поставки, если он не соответствует варианту указания.
//
// Параметры:
//  ТабличнаяЧасть               - ТабличнаяЧасть - в ней содержится колонка со сроком поставки.
//  ИмяРеквизита                 - Строка - имя реквизита табличной части, содержащего срок поставки.
//  ВариантУказанияСрокаПоставки - ПеречислениеСсылка.ВариантыСроковПоставкиКоммерческихПредложений - вариант указания.
//
Процедура ОчиститьСрокПоставкиЕслиНеСоответствуетВарианту(ТабличнаяЧасть, ИмяРеквизита, ВариантУказанияСрокаПоставки) Экспорт
	
	Для Каждого СтрокаТабличнойЧасти Из  ТабличнаяЧасть Цикл
		
		Если  ВариантУказанияСрокаПоставки = ПредопределенноеЗначение("Перечисление.ВариантыСроковПоставкиКоммерческихПредложений.НеУказывается") Тогда
			Если ЗначениеЗаполнено(СтрокаТабличнойЧасти[ИмяРеквизита]) Тогда
				СтрокаТабличнойЧасти[ИмяРеквизита] = Неопределено;
			КонецЕсли;
		ИначеЕсли ВариантУказанияСрокаПоставки = ПредопределенноеЗначение("Перечисление.ВариантыСроковПоставкиКоммерческихПредложений.УказываетсяВДняхСМоментаЗаказа") Тогда
			Если ТипЗнч(СтрокаТабличнойЧасти[ИмяРеквизита]) <> Тип("Число") Тогда
				СтрокаТабличнойЧасти[ИмяРеквизита] = 0;
			КонецЕсли;
		ИначеЕсли ВариантУказанияСрокаПоставки = ПредопределенноеЗначение("Перечисление.ВариантыСроковПоставкиКоммерческихПредложений.УказываетсяНаОпределеннуюДату") Тогда
			Если ТипЗнч(СтрокаТабличнойЧасти[ИмяРеквизита]) <> Тип("Дата") Тогда
				СтрокаТабличнойЧасти[ИмяРеквизита] = Дата(1, 1, 1);
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Формирует представление номенклатуры для печати.
//
// Параметры:
//  Номенклатура   - ОпределяемыйТип.НоменклатураБЭД - номенклатура.
//  Характеристика - ОпределяемыйТип.ХарактеристикаНоменклатурыБЭД - характеристика.
//
// Возвращаемое значение:
//   Строка   - сформированное представление номенклатуры для печати.
//
Функция ПредставлениеНоменклатурыДляПечати(Номенклатура, Характеристика) Экспорт

	ПредставлениеДляПечати = "";
	СтандартнаяОбработка = Истина;
	
	КоммерческиеПредложенияДокументыКлиентСерверПереопределяемый.СформироватьПредставлениеНоменклатурыДляПечати(ПредставлениеДляПечати, Номенклатура, Характеристика, СтандартнаяОбработка);
	
	Если Не СтандартнаяОбработка Тогда
		Возврат ПредставлениеДляПечати;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Характеристика) Тогда
		Возврат СтрШаблон(НСтр("ru = '%1 (%2)';
								|en = '%1 (%2)'"), Номенклатура, Характеристика);
	Иначе
		Возврат Номенклатура;
	КонецЕсли;

КонецФункции

// Описание параметров отбора формы списка документов.
//
// Возвращаемое значение:
//  Структура - содержит поля:
//  * Список        - ДинамическийСписок - список, для которого требуется установить отбор.
//  * ИмяКолонки    - Строка - имя колонки, по которой устанавливается отбор.
//  * ИмяНастройки  - Строка - имя сохраненной настройки.
//  * Настройки     - НастройкиКомпоновкиДанных  -настройки, из которых могут получаться значения отбора
//  * Использование - Неопределено, Булево - признак использования элемента отбора.
//  * ВидСравнения  - Неопределено, ВидСравненияКомпоновкиДанных - вид сравнения, устанавливаемый для элемента отбора.
//
Функция ПараметрыОтбораПередЗагрузкойИзНастроек() Экспорт
	
	Параметры = Новый Структура;
	
	Параметры.Вставить("Список", Неопределено);
	Параметры.Вставить("ИмяКолонки", "");
	Параметры.Вставить("ИмяНастройки", "");
	Параметры.Вставить("Настройки", Неопределено);
	Параметры.Вставить("Использование", Неопределено);
	Параметры.Вставить("ВидСравнения", Неопределено);
	
	Возврат Параметры;
	
КонецФункции

// Устанавливает в форме списка документов отбор по актуальности, сохраненный в настройках
// Отбор из настроек устанавливается только если отбор не передан в форму извне.
//
// Параметры:
//  Список                  - ДинамическийСписок - список, в котором необходимо установить отбор.
//  Актуальность            - Строка - строка отбора по актуальности.
//  ДатаСобытия             - Дата - дата, на которую необходимо считать документы неактуальными.
//  ТекущаяДата             - Дата - текущая дата сеанса.
//  СтруктураБыстрогоОтбора - Структура - переданный в форму списка документов отбор.
//  Настройки               - Соответствие - настройки формы.
//  СписокВыбора            - СписокЗначений - список, содержащий возможные значения отбора.
//
Процедура ОтборПоАктуальностиПриЗагрузкеИзНастроек(Список, Актуальность, ДатаСобытия, ТекущаяДата, Знач СтруктураБыстрогоОтбора, Настройки, СписокВыбора) Экспорт
	
	Если СтруктураБыстрогоОтбора = Неопределено Тогда
		
		Актуальность     = Настройки.Получить("Актуальность");
		ДатаСобытия      = Настройки.Получить("ДатаСобытия");
		
		ПриИзмененииОтбораПоАктуальности(Список, Актуальность, ДатаСобытия, ТекущаяДата, СписокВыбора);
		
	Иначе
		
		Если Не СтруктураБыстрогоОтбора.Свойство("Актуальность") Тогда
			Актуальность = Настройки.Получить("Актуальность");
		КонецЕсли;
		
		Если Не СтруктураБыстрогоОтбора.Свойство("ДатаСобытия") Тогда
			ДатаСобытия = Настройки.Получить("ДатаСобытия");
		КонецЕсли;
		
		ПриИзмененииОтбораПоАктуальности(Список, Актуальность, ДатаСобытия, ТекущаяДата, СписокВыбора);
		
	КонецЕсли;
	
	ДобавитьЭлементСпискаАктуальностиЕслиНеобходимо(СписокВыбора, Актуальность, ДатаСобытия);
	
	Настройки.Удалить("Актуальность");
	Настройки.Удалить("ДатаСобытия");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ДобавитьЭлементСпискаАктуальностиЕслиНеобходимо(СписокВыбора, Актуальность, ДатаСобытия)
	
	Если Актуальность = "ИстекаетНаДату"
		Или Актуальность = "ИстекаетНаДатуВыбран" Тогда
		
		ПредставлениеВыбора = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Истекает на дату %1';
																							|en = 'Expires on %1'"), Формат(ДатаСобытия, "ДЛФ=D"));
		СписокВыбора.Добавить("ИстекаетНаДатуВыбран", ПредставлениеВыбора);
		
		Актуальность = "ИстекаетНаДатуВыбран";
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
