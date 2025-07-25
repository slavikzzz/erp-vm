#Область СлужебныйПрограммныйИнтерфейс

Процедура ПродолжитьВыполнениеОбмена(Форма, Контекст = Неопределено, ОповещениеПриЗавершении = Неопределено, ВыводитьОкноОжидания = Истина) Экспорт
	
	РезультатОбмена = ИнтеграцияСАТУРНВызовСервера.ПродолжитьВыполнениеОбмена(Форма.АдресРезультатаОбменаВоВременномХранилище);
	
	ОбработатьРезультатОбмена(РезультатОбмена, Форма, Контекст, ОповещениеПриЗавершении, ВыводитьОкноОжидания);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Обмен

Процедура ОбработатьРезультатОбмена(РезультатОбмена, Форма, Контекст = Неопределено, ОповещениеПриЗавершении = Неопределено, ВыводитьОкноОжидания = Истина) Экспорт
	
	Если РезультатОбмена.ДлительнаяОперация <> Неопределено Тогда
		
		ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(Неопределено);
		ПараметрыОжидания.ТекстСообщения             = НСтр("ru = 'Выполняется обмен с САТУРН';
															|en = 'Выполняется обмен с САТУРН'");
		ПараметрыОжидания.ВыводитьПрогрессВыполнения = Истина;
		ПараметрыОжидания.ВыводитьОкноОжидания       = ВыводитьОкноОжидания;
		ПараметрыОжидания.ВыводитьСообщения          = Истина;
		
		Если РезультатОбмена.Ожидать <> Неопределено Тогда
			ПараметрыОжидания.Интервал = РезультатОбмена.Ожидать;
		КонецЕсли;
		
		ПараметрыЗавершенияДлительнойОперации = ПараметрыЗавершенияДлительнойОперации();
		ПараметрыЗавершенияДлительнойОперации.Форма                   = Форма;
		ПараметрыЗавершенияДлительнойОперации.Контекст                = Контекст;
		ПараметрыЗавершенияДлительнойОперации.ОповещениеПриЗавершении = ОповещениеПриЗавершении;
		
		ДлительныеОперацииКлиент.ОжидатьЗавершение(
			РезультатОбмена.ДлительнаяОперация,
			Новый ОписаниеОповещения("ПослеЗавершенияДлительнойОперации", ИнтеграцияСАТУРНСлужебныйКлиент, ПараметрыЗавершенияДлительнойОперации),
			ПараметрыОжидания);
		
	Иначе
		
		Если РезультатОбмена.Ожидать <> Неопределено Тогда
			
			Форма.АдресРезультатаОбменаВоВременномХранилище = РезультатОбмена.АдресВоВременномХранилище;
			Форма.ПодключитьОбработчикОжидания("Подключаемый_ВыполнитьОбменОбработкаОжидания", РезультатОбмена.Ожидать, Истина);
			
		Иначе
			
			ПараметрыЗавершенияДлительнойОперации = ПараметрыЗавершенияДлительнойОперации();
			ПараметрыЗавершенияДлительнойОперации.Форма                   = Форма;
			ПараметрыЗавершенияДлительнойОперации.Контекст                = Контекст;
			ПараметрыЗавершенияДлительнойОперации.ОповещениеПриЗавершении = ОповещениеПриЗавершении;
			
			ОбработатьРезультатОбменаСлужебный(РезультатОбмена, ПараметрыЗавершенияДлительнойОперации);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Только для внутреннего использования.
// Вызывается из: ОповещениеПослеЗавершенииОбмена
Процедура ПослеЗавершенияДлительнойОперации(Результат, ДополнительныеПараметрыДлительнойОперации) Экспорт
	
	Если Результат = Неопределено Тогда // отменено пользователем
		Если ДополнительныеПараметрыДлительнойОперации.ОповещениеПриЗавершении <> Неопределено Тогда
			ВыполнитьОбработкуОповещения(ДополнительныеПараметрыДлительнойОперации.ОповещениеПриЗавершении);
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	Если Результат.Сообщения <> Неопределено Тогда
		Для каждого СообщениеПользователю Из Результат.Сообщения Цикл
			СообщениеПользователю.Сообщить();
		КонецЦикла;
	КонецЕсли;
	
	Если Результат.Статус = "Выполнено" Тогда
		
		РезультатОбмена = ПолучитьИзВременногоХранилища(Результат.АдресРезультата);
		
		ОбработатьРезультатОбменаСлужебный(РезультатОбмена, ДополнительныеПараметрыДлительнойОперации);
		
	ИначеЕсли Результат.Статус = "Ошибка" Тогда
		
		ОбщегоНазначенияКлиент.СообщитьПользователю(Результат.ПодробноеПредставлениеОшибки);
		
		Если ДополнительныеПараметрыДлительнойОперации.ОповещениеПриЗавершении <> Неопределено Тогда
			ВыполнитьОбработкуОповещения(ДополнительныеПараметрыДлительнойОперации.ОповещениеПриЗавершении, Новый Массив);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Только для внутреннего использования.
Процедура ОбработатьРезультатОбменаСлужебный(РезультатОбмена, ДополнительныеПараметрыДлительнойОперации)
	
	Форма                                     = ДополнительныеПараметрыДлительнойОперации.Форма;
	ОповещениеПриЗавершении                   = ДополнительныеПараметрыДлительнойОперации.ОповещениеПриЗавершении;
	АдресРезультатаОбменаВоВременномХранилище = РезультатОбмена.АдресВоВременномХранилище;
	
	Если РезультатОбмена.ИзвлекатьДанныеЛогаЗапросов Тогда
		ИнтеграцияСАТУРНВызовСервера.ИзвлечьЛогЗапросовИзПараметровОбмена(АдресРезультатаОбменаВоВременномХранилище);
	КонецЕсли;
	
	Если РезультатОбмена.Ожидать <> Неопределено Тогда
		
		Форма.АдресРезультатаОбменаВоВременномХранилище = РезультатОбмена.АдресВоВременномХранилище;
		Попытка
			Форма.ПодключитьОбработчикОжидания("Подключаемый_ВыполнитьОбменОбработкаОжидания", РезультатОбмена.Ожидать, Истина);
		Исключение
			
			РасширенноеСообщениеОбОшибке = СтрШаблон(
				НСтр("ru = 'Ошибка подключения обработчика ожидания Подключаемый_ВыполнитьОбменОбработкаОжидания:
				           |Значение ожидания: %1
				           |Тип значения: %2';
				           |en = 'Ошибка подключения обработчика ожидания Подключаемый_ВыполнитьОбменОбработкаОжидания:
				           |Значение ожидания: %1
				           |Тип значения: %2'"),
				РезультатОбмена.Ожидать,
				Строка(ТипЗнч(РезультатОбмена.Ожидать)));
			
			ВызватьИсключение РасширенноеСообщениеОбОшибке;
			
		КонецПопытки;
		
	Иначе
		
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("Форма",                   Форма);
		ДополнительныеПараметры.Вставить("Контекст",                Неопределено);
		ДополнительныеПараметры.Вставить("ОповещениеПриЗавершении", ОповещениеПриЗавершении);
		
		ИнтеграцияСАТУРНСлужебныйКлиент.ПослеЗавершенияОбмена(
			РезультатОбмена.Изменения,
			ДополнительныеПараметры);
		
	КонецЕсли;
	
КонецПроцедуры

//Только для внутреннего использования.
// Вызывается из: ПослеЗавершенияОбмена.
Процедура ОткрытьРезультатВыполненияОбмена(ДополнительныеПараметры) Экспорт
	
		Если ДополнительныеПараметры.Изменения.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ОткрытьФорму("ОбщаяФорма.РезультатВыполненияОбменаСАТУРН", ДополнительныеПараметры);
	
КонецПроцедуры

//Только для внутреннего использования.
// Вызывается из: ОповещениеПослеЗавершенииОбмена.
Процедура ПослеЗавершенияОбмена(Изменения, ДополнительныеПараметры) Экспорт
	
	СоответствиеДокументыОснования  = Новый Соответствие;
	СоответствиеДокументыСтатусы    = Новый Соответствие;
	СоответствиеИзмененныеДокументы = Новый Соответствие;
	
	Для Каждого ЭлементДанных Из Изменения Цикл
		
		Если ЗначениеЗаполнено(ЭлементДанных.ТекстОшибки) Тогда
			УникальныйИдентификатор = Неопределено;
			Если ДополнительныеПараметры.Свойство("Форма") Тогда
				УникальныйИдентификатор = ДополнительныеПараметры.Форма.УникальныйИдентификатор;
			КонецЕсли;
			
			ОбщегоНазначенияИСКлиент.СообщитьПользователюВФорму(УникальныйИдентификатор, ЭлементДанных.ТекстОшибки);
			
		КонецЕсли;
		
		Если ТипЗнч(ЭлементДанных.Объект)<>Тип("Массив") Тогда
			СоответствиеДокументыОснования.Вставить(ЭлементДанных.Объект, ЭлементДанных.ДокументОснование);
		ИначеЕсли ЗначениеЗаполнено(ЭлементДанных.Объект) Тогда
			
			Для Каждого Объект Из ЭлементДанных.Объект Цикл
				СоответствиеДокументыОснования.Вставить(Объект, ЭлементДанных.ДокументОснование);
				СоответствиеИзмененныеДокументы.Вставить(Объект, Истина);
				СоответствиеДокументыСтатусы.Вставить(Объект, Неопределено);
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Для Каждого КлючИЗначение Из СоответствиеДокументыОснования Цикл
		
		ОбъектИзменен = СоответствиеИзмененныеДокументы.Получить(КлючИЗначение.Ключ);
		Если ОбъектИзменен = Неопределено Тогда
			ОбъектИзменен = Ложь;
		КонецЕсли;
		
		ПараметрОповещения = Новый Структура;
		ПараметрОповещения.Вставить("Ссылка",        КлючИЗначение.Ключ);
		ПараметрОповещения.Вставить("Основание",     КлючИЗначение.Значение);
		ПараметрОповещения.Вставить("ОбъектИзменен", ОбъектИзменен);
		
		Оповестить(ОбменДаннымиИСКлиентСервер.ИмяСобытияИзмененоСостояние(ИмяПодсистемы()), ПараметрОповещения);
		
	КонецЦикла;
	
	Если ТипЗнч(ДополнительныеПараметры.Контекст) = Тип("ТаблицаФормы") Тогда
		
		// Выполнено действие из динамического списка
		ТекстСообщения = СтрШаблон(
			НСтр("ru = 'Для %1 из %2 выделенных в списке документов выполнено действие: %3';
				|en = 'Для %1 из %2 выделенных в списке документов выполнено действие: %3'"),
			СоответствиеДокументыСтатусы.Количество(),
			ДополнительныеПараметры.Контекст.ВыделенныеСтроки.Количество(),
			ДополнительныеПараметры.ДальнейшееДействие);
			
		ПоказатьОповещениеПользователя(
			НСтр("ru = 'Выполнено действие';
				|en = 'Выполнено действие'"),,
			ТекстСообщения,
			БиблиотекаКартинок.Информация32);
		
	ИначеЕсли ЗначениеЗаполнено(ДополнительныеПараметры.Контекст) Тогда
		
		// Выполнено действие из формы документа
		Для Каждого КлючИЗначение Из СоответствиеДокументыСтатусы Цикл
			
			Если КлючИЗначение.Значение = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			
			ТекстСообщения = СтрШаблон(
				НСтр("ru = 'Для документа %1 изменен статус САТУРН: %2.';
					|en = 'Для документа %1 изменен статус САТУРН: %2.'"),
				КлючИЗначение.Ключ,
				КлючИЗначение.Значение);
			
			ПоказатьОповещениеПользователя(
				НСтр("ru = 'Выполнено действие';
					|en = 'Выполнено действие'"),
				ПолучитьНавигационнуюСсылку(КлючИЗначение.Ключ),
				ТекстСообщения,
				БиблиотекаКартинок.Информация32);
			
		КонецЦикла;
		
	Иначе
		
		// Выполнен обмен с САТУРН
		ДополнительныеПараметрыОповещения = Новый Структура;
		ДополнительныеПараметрыОповещения.Вставить("СоответствиеДокументыОснования", СоответствиеДокументыОснования);
		ДополнительныеПараметрыОповещения.Вставить("СоответствиеДокументыСтатусы",   СоответствиеДокументыСтатусы);
		ДополнительныеПараметрыОповещения.Вставить("Изменения",                      Изменения);
		
		ТекстСообщения = СтрШаблон(НСтр("ru = 'Изменено объектов: %1';
										|en = 'Изменено объектов: %1'"), СоответствиеДокументыСтатусы.Количество());
		
		ПоказатьОповещениеПользователя(
			НСтр("ru = 'Выполнен обмен с ФГИС ""Сатурн""';
				|en = 'Выполнен обмен с ФГИС ""Сатурн""'"),
			Новый ОписаниеОповещения("ОткрытьРезультатВыполненияОбмена", ИнтеграцияСАТУРНСлужебныйКлиент, ДополнительныеПараметрыОповещения),
			ТекстСообщения,
			БиблиотекаКартинок.Информация32);
		
	КонецЕсли;
	
	Если ДополнительныеПараметры.ОповещениеПриЗавершении <> Неопределено Тогда
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПриЗавершении, Изменения);
	КонецЕсли;
	
КонецПроцедуры

Функция ПараметрыЗавершенияДлительнойОперации() Экспорт
	
	ПараметрыЗавершения = Новый Структура;
	ПараметрыЗавершения.Вставить("Форма");
	ПараметрыЗавершения.Вставить("Контекст");
	ПараметрыЗавершения.Вставить("ОповещениеПриЗавершении");
	
	Возврат ПараметрыЗавершения;
	
КонецФункции

Функция ПараметрыЗавершенияОбмена() Экспорт
	
	ПараметрыЗавершения = Новый Структура;
	ПараметрыЗавершения.Вставить("Контекст");
	ПараметрыЗавершения.Вставить("ОповещениеПриЗавершении");
	
	Возврат ПараметрыЗавершения;
	
КонецФункции

Функция ИмяПодсистемы() Экспорт
	
	Возврат "САТУРН";
	
КонецФункции

Функция ПредставлениеПодсистемы() Экспорт
	
	Возврат "САТУРН";
	
КонецФункции

Процедура ОткрытьФормуСопоставленнойНоменклатурыПоПартии(Партия, ВладелецФормы) Экспорт
	
	ПараметрыОткрытияФормы = Новый Структура();
	ПараметрыОткрытияФормы.Вставить("Отбор", Новый Структура());
	ПараметрыОткрытияФормы.Отбор.Вставить("Партия", Партия);
	
	ОткрытьФорму(
		"РегистрСведений.СоответствиеНоменклатурыСАТУРН.ФормаСписка",
		ПараметрыОткрытияФормы,
		ВладелецФормы,
		Партия);
	
КонецПроцедуры

Функция ПараметрыОткрытияФормыЗапросаДокументов() Экспорт
	
	ВозвращаемоеЗначение = Новый Структура();
	ВозвращаемоеЗначение.Вставить("ОрганизацияСАТУРН",    Неопределено);
	ВозвращаемоеЗначение.Вставить("ТипДокумента",         Неопределено);
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

Процедура ОткрытьФормуЗапросаДокументов(ПараметрыОткрытияФормы, ВладелецФормы, ОповещениеПриЗавершении = Неопределено) Экспорт
	
	ОткрытьФорму(
		"ОбщаяФорма.ЗапросДокументовСАТУРН",
		ПараметрыОткрытияФормы,
		ВладелецФормы,,,,
		ОповещениеПриЗавершении,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти