#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

// СтандартныеПодсистемы.Печать

// Заполняет список команд печати.
//
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	ОбработчикПечати    = "УправлениеПечатьюБЗККлиент.ВыполнитьКомандуПечати";
	МетаданныеДокумента = Метаданные.Документы.ВозмещениеБольничныхВЧастиФБ;
	ПолноеИмяМенеджера  = МетаданныеДокумента.ПолноеИмя();
	Макеты              = МетаданныеДокумента.Макеты;
	
	Макет = Макеты.ПФ_MXL_ВозмещениеБольничныхВЧастиФБ_2021;
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Обработчик     = ОбработчикПечати;
	КомандаПечати.МенеджерПечати = ПолноеИмяМенеджера;
	КомандаПечати.Идентификатор  = Макет.Имя;
	КомандаПечати.Представление  = Макет.Представление();
	КомандаПечати.Порядок        = 1;
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	
КонецПроцедуры

// См. УправлениеПечатьюПереопределяемый.ПриПечати.
Процедура Печать(МассивСсылок, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	ПараметрыВывода.ДоступнаПечатьПоКомплектно = Истина;
	Менеджер = Документы.ВозмещениеБольничныхВЧастиФБ;
	УправлениеПечатьюБЗК.Печать(МассивСсылок, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, Менеджер);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.Печать

// ЗарплатаКадрыПодсистемы

// Формирует печатную форму. Вызывается из УправлениеПечатьюБЗК.Печать.
//
// Параметры:
//   КонтекстПечати - Структура - См. УправлениеПечатьюБЗК.КонтекстПечати.
//
Процедура ПриФормированииПечатнойФормы(КонтекстПечати) Экспорт
	
	Макеты = Метаданные.Документы.ВозмещениеБольничныхВЧастиФБ.Макеты;
	Если КонтекстПечати.МетаданныеМакета = Макеты.ПФ_MXL_ВозмещениеБольничныхВЧастиФБ_2021 Тогда
		ПриПечатиВозмещенияБольничныхВЧастиФБ(КонтекстПечати);
	КонецЕсли;
	
КонецПроцедуры

// Конец ЗарплатаКадрыПодсистемы

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ДляВсехСтрок( ЗначениеРазрешено(Пособия.ФизическоеЛицо, NULL КАК ИСТИНА)
	|	) И ЗначениеРазрешено(Организация)";
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает описание состава документа
//
// Возвращаемое значение:
//  Структура - см. ЗарплатаКадрыСоставДокументов.НовоеОписаниеСоставаОбъекта.
Функция ОписаниеСоставаОбъекта() Экспорт
	
	МетаданныеДокумента = Метаданные.Документы.ВозмещениеБольничныхВЧастиФБ;
	Возврат ЗарплатаКадрыСоставДокументов.ОписаниеСоставаОбъектаПоМетаданнымФизическиеЛицаВТабличныхЧастях(МетаданныеДокумента);
	
КонецФункции

#Область ФиксацияВторичныхДанныхВДокументах

Функция ПараметрыФиксацииВторичныхДанных() Экспорт
	ФиксируемыеТЧ = Новый Структура("Пособия", СтрРазделить("Больничный,ДатаСтраховогоСлучая,ФизическоеЛицо", ",", Ложь));
	Возврат ФиксацияВторичныхДанныхВДокументах.ПараметрыФиксации(ФиксируемыеРеквизиты(), ФиксируемыеТЧ);
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ЗащитаПерсональныхДанных

// См. ЗащитаПерсональныхДанныхПереопределяемый.ЗаполнитьСведенияОПерсональныхДанных.
Процедура ЗаполнитьСведенияОПерсональныхДанных(ТаблицаСведений) Экспорт
	
	Объект = Метаданные.Документы.ВозмещениеБольничныхВЧастиФБ.ПолноеИмя();
	
	НовыеСведения = ТаблицаСведений.Добавить();
	НовыеСведения.Объект          = Объект;
	НовыеСведения.ПоляРегистрации = "Пособия.ФизическоеЛицо";
	НовыеСведения.ПоляДоступа     = "Пособия.СуммаФинансируемаяРаботодателем,Пособия.СуммаСверхНорм";
	НовыеСведения.ОбластьДанных   = "Доходы";
	
КонецПроцедуры

#КонецОбласти

#Область ФиксацияВторичныхДанныхВДокументах

Функция ФиксируемыеРеквизиты() Экспорт
	ФиксируемыеРеквизиты = Новый Соответствие;
	
	// Реквизиты организации.
	Шаблон = ФиксацияВторичныхДанныхВДокументах.ОписаниеФиксируемогоРеквизита();
	Шаблон.ИмяГруппы           = "Организация";
	Шаблон.ОснованиеЗаполнения = "Организация";
	
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "НаименованиеТерриториальногоОрганаФСС");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "РегистрационныйНомерФСС");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "ДополнительныйКодФСС");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "КодПодчиненностиФСС");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "ИНН");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "КПП");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "АдресОрганизации");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "АдресЭлектроннойПочтыОрганизации");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "ТелефонСоставителя");
	
	// Роль подписанта Руководитель.
	Шаблон = ФиксацияВторичныхДанныхВДокументах.ОписаниеФиксируемогоРеквизита();
	Шаблон.ОснованиеЗаполнения      = "Организация";
	Шаблон.ИмяГруппы                = "ПредставительСФР";
	Шаблон.ФиксацияГруппы           = Истина;
	Шаблон.ОтображатьПредупреждение = Ложь;
	
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "ПредставительСФР");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "ДолжностьПредставителяСФР");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "ОснованиеПодписиПредставителяСФР");
	
	// Реквизиты табличной части "Пособия".
	Шаблон = ФиксацияВторичныхДанныхВДокументах.ОписаниеФиксируемогоРеквизита();
	Шаблон.Путь                     = "Пособия";
	Шаблон.РеквизитСтроки           = Истина;
	Шаблон.ОтображатьПредупреждение = Ложь;
	
	// Кнопка "Заполнить".
	Шаблон.ОснованиеЗаполнения = "Организация";
	Шаблон.ИмяГруппы           = "Больничный";
	
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "Больничный");
	
	// Документ-основание.
	Шаблон.ОснованиеЗаполнения = "Больничный";
	Шаблон.ИмяГруппы           = "Больничный";
	
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "ФизическоеЛицо");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "ДатаСтраховогоСлучая");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "ДатаНачала");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "ДатаОкончания");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "СуммаФинансируемаяРаботодателем");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "СуммаСверхНорм");
	
	// Физлицо.
	Шаблон.ОснованиеЗаполнения = "ФизическоеЛицо";
	Шаблон.ИмяГруппы           = "ФизическоеЛицо";
	
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "Фамилия");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "Имя");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "Отчество");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "СНИЛС");
	
	Возврат Новый ФиксированноеСоответствие(ФиксируемыеРеквизиты);
КонецФункции

#КонецОбласти

#Область ПФ_MXL_ВозмещениеБольничныхВЧастиФБ_2021

Процедура ПриПечатиВозмещенияБольничныхВЧастиФБ(КонтекстПечати)
	СЭДОФСС.УстановитьСтандартныйОтступПечати(КонтекстПечати);
	
	Выборка = ВыборкаПоДокументам(КонтекстПечати.МассивОбъектов);
	Пока Выборка.Следующий() Цикл
		Пособия = Выборка.Пособия.Выгрузить();
		Если Пособия.Количество() = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		УправлениеПечатьюБЗК.ПередПечатьюОчередногоОбъекта(КонтекстПечати);
		
		Пособия.Сортировать("НомерСтроки");
		ВывестиШапкуВозмещенияБольничныхВЧастиФБ(КонтекстПечати,  Выборка, Пособия);
		ВывестиСтрокиВозмещенияБольничныхВЧастиФБ(КонтекстПечати, Выборка, Пособия);
		ВывестиПодвалВозмещенияБольничныхВЧастиФБ(КонтекстПечати, Выборка, Пособия);
		
		УправлениеПечатьюБЗК.ПослеПечатиОчередногоОбъекта(КонтекстПечати, Выборка.Ссылка);
		
	КонецЦикла;
КонецПроцедуры

Функция ВыборкаПоДокументам(МассивСсылок)
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВозмещениеБольничныхВЧастиФБ.Ссылка КАК Ссылка,
	|	ВозмещениеБольничныхВЧастиФБ.ВерсияДанных КАК ВерсияДанных,
	|	ВозмещениеБольничныхВЧастиФБ.ПометкаУдаления КАК ПометкаУдаления,
	|	ВозмещениеБольничныхВЧастиФБ.Номер КАК Номер,
	|	ВозмещениеБольничныхВЧастиФБ.Дата КАК Дата,
	|	ВозмещениеБольничныхВЧастиФБ.Проведен КАК Проведен,
	|	ВозмещениеБольничныхВЧастиФБ.Организация КАК Организация,
	|	ВозмещениеБольничныхВЧастиФБ.НаименованиеТерриториальногоОрганаФСС КАК НаименованиеТерриториальногоОрганаФСС,
	|	ВозмещениеБольничныхВЧастиФБ.РегистрационныйНомерФСС КАК РегистрационныйНомерФСС,
	|	ВозмещениеБольничныхВЧастиФБ.ДополнительныйКодФСС КАК ДополнительныйКодФСС,
	|	ВозмещениеБольничныхВЧастиФБ.КодПодчиненностиФСС КАК КодПодчиненностиФСС,
	|	ВозмещениеБольничныхВЧастиФБ.ИНН КАК ИНН,
	|	ВозмещениеБольничныхВЧастиФБ.КПП КАК КПП,
	|	ВозмещениеБольничныхВЧастиФБ.ПредставительСФР КАК ПредставительСФР,
	|	ВозмещениеБольничныхВЧастиФБ.ДолжностьПредставителяСФР КАК ДолжностьПредставителяСФР,
	|	ВозмещениеБольничныхВЧастиФБ.ОснованиеПодписиПредставителяСФР КАК ОснованиеПодписиПредставителяСФР,
	|	ВозмещениеБольничныхВЧастиФБ.АдресОрганизации КАК АдресОрганизации,
	|	ВозмещениеБольничныхВЧастиФБ.АдресЭлектроннойПочтыОрганизации КАК АдресЭлектроннойПочтыОрганизации,
	|	ВозмещениеБольничныхВЧастиФБ.Банк КАК Банк,
	|	ВозмещениеБольничныхВЧастиФБ.НаименованиеБанка КАК НаименованиеБанка,
	|	ВозмещениеБольничныхВЧастиФБ.НомерЛицевогоСчета КАК НомерЛицевогоСчета,
	|	ВозмещениеБольничныхВЧастиФБ.КБК КАК КБК,
	|	ВозмещениеБольничныхВЧастиФБ.НомерСчета КАК НомерСчета,
	|	ВозмещениеБольничныхВЧастиФБ.БИКБанка КАК БИКБанка,
	|	ВозмещениеБольничныхВЧастиФБ.СтатусДокумента КАК СтатусДокумента,
	|	ВозмещениеБольничныхВЧастиФБ.ТелефонСоставителя КАК ТелефонСоставителя,
	|	ВозмещениеБольничныхВЧастиФБ.Ответственный КАК Ответственный,
	|	ВозмещениеБольничныхВЧастиФБ.Комментарий КАК Комментарий,
	|	ВЫБОР
	|		КОГДА (ВЫРАЗИТЬ(Организации.НаименованиеПолное КАК СТРОКА(1000))) = """"
	|			ТОГДА Организации.НаименованиеСокращенное
	|		ИНАЧЕ ВЫРАЗИТЬ(Организации.НаименованиеПолное КАК СТРОКА(1000))
	|	КОНЕЦ КАК НаименованиеСтрахователя,
	|	ЕСТЬNULL(ФизическиеЛица.ФИО, """") КАК ФИОПредставителяСФР,
	|	ВозмещениеБольничныхВЧастиФБ.Пособия.(
	|		Ссылка КАК Ссылка,
	|		НомерСтроки КАК НомерСтроки,
	|		Больничный КАК Больничный,
	|		ФизическоеЛицо КАК ФизическоеЛицо,
	|		Фамилия КАК Фамилия,
	|		Имя КАК Имя,
	|		Отчество КАК Отчество,
	|		СНИЛС КАК СНИЛС,
	|		ДатаНачала КАК ДатаНачала,
	|		ДатаОкончания КАК ДатаОкончания,
	|		СуммаФинансируемаяРаботодателем КАК СуммаФинансируемаяРаботодателем,
	|		СуммаСверхНорм КАК СуммаСверхНорм,
	|		ИдентификаторСтрокиФикс КАК ИдентификаторСтрокиФикс
	|	) КАК Пособия
	|ИЗ
	|	Документ.ВозмещениеБольничныхВЧастиФБ КАК ВозмещениеБольничныхВЧастиФБ
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Организации КАК Организации
	|		ПО ВозмещениеБольничныхВЧастиФБ.Организация = Организации.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ФизическиеЛица КАК ФизическиеЛица
	|		ПО ВозмещениеБольничныхВЧастиФБ.ПредставительСФР = ФизическиеЛица.Ссылка
	|ГДЕ
	|	ВозмещениеБольничныхВЧастиФБ.Ссылка В(&МассивСсылок)";
	Запрос.УстановитьПараметр("МассивСсылок", МассивСсылок);
	
	Возврат Запрос.Выполнить().Выбрать();
КонецФункции

Процедура ВывестиШапкуВозмещенияБольничныхВЧастиФБ(КонтекстПечати, Выборка, ТаблицаПособий)
	Параметры = Новый Структура(КонтекстПечати.ИменаПараметровОбластей.Шапка);
	Секция    = УправлениеПечатьюБЗК.СекцияПечатнойФормы(КонтекстПечати, "Шапка");
	
	Итого = ТаблицаПособий.Итог("СуммаСверхНорм");
	Параметры.ИтогоРублей = Формат(Итого, "ЧДЦ=0; ЧН=");
	Параметры.ИтогоКопеек = Формат((Итого - Цел(Итого))*100, "ЧЦ=2; ЧДЦ=0; ЧН=; ЧВН=");
	
	Секция.ТабличныйДокумент.Параметры.Заполнить(Параметры);
	УправлениеПечатьюБЗК.ВывестиПоБуквам(Секция, Выборка.НаименованиеТерриториальногоОрганаФСС, "НаименованиеТОФ");
	УправлениеПечатьюБЗК.ВывестиПоБуквам(Секция, Выборка.НаименованиеСтрахователя, "НаименованиеСтрахователя");
	
	КонтекстПечати.ТабличныйДокумент.Вывести(Секция.ТабличныйДокумент);
КонецПроцедуры

Процедура ВывестиСтрокиВозмещенияБольничныхВЧастиФБ(КонтекстПечати, Выборка, ТаблицаПособий)
	// Определение локальных переменных.
	ТабличныйДокумент = КонтекстПечати.ТабличныйДокумент;
	
	// Характеристики печатной формы:
	// На первой странице (с шапкой печатной формы) помещается 6 строк (без подвала).
	// На отдельной странице помещается 13 строк (без подвала).
	// Высоту подвала считаем равной высоте одной строки.
	ВысотаПодвала               = 1;
	МаксимумНаПервойСтранице    = 6;
	МаксимумНаОтдельнойСтранице = 13;
	МинимумНаПоследнейСтранице  = 2;
	МаксимумНаПоследнейСтранице = 10;
	
	// Распределение строк по страницам.
	КоличествоСтрок = ТаблицаПособий.Количество();
	Если КоличествоСтрок <= 4 Тогда
		ВывестиНаПервойСтранице    = КоличествоСтрок;
		ВывестиНаПоследнейСтранице = 0;
	ИначеЕсли КоличествоСтрок <= МаксимумНаПервойСтранице + МинимумНаПоследнейСтранице Тогда
		ВывестиНаПервойСтранице    = КоличествоСтрок - МинимумНаПоследнейСтранице;
		ВывестиНаПоследнейСтранице = МинимумНаПоследнейСтранице;
	ИначеЕсли КоличествоСтрок <= МаксимумНаПервойСтранице Тогда
		ВывестиНаПервойСтранице    = МаксимумНаПервойСтранице - 1;
		ВывестиНаПоследнейСтранице = КоличествоСтрок - ВывестиНаПервойСтранице;
	Иначе // КоличествоСтрок > МаксимумНаПервойСтранице.
		ВывестиНаПервойСтранице = МаксимумНаПервойСтранице;
		Остаток = КоличествоСтрок - ВывестиНаПервойСтранице; // Остаток > 0.
		ВывестиНаПоследнейСтранице = Макс(Остаток % МаксимумНаОтдельнойСтранице, МинимумНаПоследнейСтранице);
		Если ВывестиНаПоследнейСтранице > МаксимумНаПоследнейСтранице Тогда
			ВывестиНаПоследнейСтранице = МинимумНаПоследнейСтранице;
		КонецЕсли;
		// Добивка предпоследней страницы до целого числа строк.
		ВывестиНаОтдельныхСтраницах = КоличествоСтрок - ВывестиНаПервойСтранице - ВывестиНаПоследнейСтранице;
		ВывестиНаПредпоследнейСтранице = ВывестиНаОтдельныхСтраницах % МаксимумНаОтдельнойСтранице;
		НехваткаДоЦелойСтраницы = МаксимумНаОтдельнойСтранице - ВывестиНаПредпоследнейСтранице;
		Если НехваткаДоЦелойСтраницы <= 2 Тогда
			ВывестиНаПервойСтранице = ВывестиНаПервойСтранице - НехваткаДоЦелойСтраницы;
		КонецЕсли;
	КонецЕсли;
	ВывестиНаОтдельныхСтраницах = КоличествоСтрок - ВывестиНаПервойСтранице - ВывестиНаПоследнейСтранице;
	
	// Оценка общего количества страниц со сведениями о получателях пособия и подготовка параметров вывода.
	ВсегоСтраниц = Цел((ВывестиНаОтдельныхСтраницах + МаксимумНаОтдельнойСтранице - 1) / МаксимумНаОтдельнойСтранице)
		+ ?(ВывестиНаПервойСтранице > 0, 1, 0)
		+ ?(ВывестиНаПоследнейСтранице > 0, 1, 0);
	ВыводитьНомерСтраницы = Ложь;
	ВыводитьНомерСтраницы = (ВсегоСтраниц > 1);
	ИмяОбластиШапка = ?(ВыводитьНомерСтраницы, "ШапкаСтраницыСНомерамиСтраниц", "ШапкаСтраницыБезНомеровСтраниц");
	СекцияШапкаСтраницы = КонтекстПечати.Макет.ПолучитьОбласть(ИмяОбластиШапка);
	
	НомерСтраницы = 0;
	ОстатокНаСтранице = 0;
	
	Для Каждого СтрокаТаблицы Из ТаблицаПособий Цикл
		// Вывод шапки страницы для 2й и последующих страниц.
		Если ОстатокНаСтранице = 0 Тогда
			// Определение остатка на новой странице и вывод разделителя страниц.
			Если ВывестиНаПервойСтранице > 0 Тогда
				ОстатокНаСтранице           = ВывестиНаПервойСтранице;
				ВывестиНаПервойСтранице     = 0;
			ИначеЕсли ВывестиНаОтдельныхСтраницах > 0 Тогда
				ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
				ОстатокНаСтранице           = Мин(ВывестиНаОтдельныхСтраницах, МаксимумНаОтдельнойСтранице);
				ВывестиНаОтдельныхСтраницах = ВывестиНаОтдельныхСтраницах - ОстатокНаСтранице;
			ИначеЕсли ВывестиНаПоследнейСтранице > 0 Тогда
				ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
				ОстатокНаСтранице           = ВывестиНаПоследнейСтранице;
				ВывестиНаПоследнейСтранице  = 0;
			КонецЕсли;
			// Вывод шапки таблицы.
			НомерСтраницы = НомерСтраницы + 1;
			Если ВыводитьНомерСтраницы Тогда
				СекцияШапкаСтраницы.Параметры.НомерСтраницы = НомерСтраницы;
				СекцияШапкаСтраницы.Параметры.ВсегоСтраниц = ВсегоСтраниц;
			КонецЕсли;
			ТабличныйДокумент.Вывести(СекцияШапкаСтраницы);
		КонецЕсли;
		
		// Вывод строки.
		Секция = УправлениеПечатьюБЗК.СекцияПечатнойФормы(КонтекстПечати, "Строка");
		
		Секция.ТабличныйДокумент.Параметры.НомерСтроки = Формат(СтрокаТаблицы.НомерСтроки, "ЧЦ=; ЧГ=") + ".";
		
		СНИЛС = УчетПособийСоциальногоСтрахованияКлиентСервер.СНИЛСВФорматеФСС(СтрокаТаблицы.СНИЛС);
		
		УправлениеПечатьюБЗК.ВывестиПоБуквам(Секция, СтрокаТаблицы.Фамилия,  "Работник_Фамилия");
		УправлениеПечатьюБЗК.ВывестиПоБуквам(Секция, СтрокаТаблицы.Имя,      "Работник_Имя");
		УправлениеПечатьюБЗК.ВывестиПоБуквам(Секция, СтрокаТаблицы.Отчество, "Работник_Отчество");
		УправлениеПечатьюБЗК.ВывестиПоБуквам(Секция, СНИЛС,                  "СНИЛС");
		УправлениеПечатьюБЗК.ВывестиДатуПоБуквам(Секция, СтрокаТаблицы.ДатаНачала,    "ДатаНачалаЛН");
		УправлениеПечатьюБЗК.ВывестиДатуПоБуквам(Секция, СтрокаТаблицы.ДатаОкончания, "ДатаОкончанияЛН");
		УправлениеПечатьюБЗК.ВывестиСуммуПоБуквам(Секция, СтрокаТаблицы.СуммаФинансируемаяРаботодателем, "СуммаПособия");
		УправлениеПечатьюБЗК.ВывестиСуммуПоБуквам(Секция, СтрокаТаблицы.СуммаСверхНорм, "РасходыСверхНорм");
		
		ТабличныйДокумент.Вывести(Секция.ТабличныйДокумент);
		ОстатокНаСтранице = ОстатокНаСтранице - 1;
	КонецЦикла;
	
	// Вывод итогов.
	Секция = УправлениеПечатьюБЗК.СекцияПечатнойФормы(КонтекстПечати, "Итого");
	
	Итого_СуммаПособия     = ТаблицаПособий.Итог("СуммаФинансируемаяРаботодателем");
	Итого_РасходыСверхНорм = ТаблицаПособий.Итог("СуммаСверхНорм");
	
	УправлениеПечатьюБЗК.ВывестиСуммуПоБуквам(Секция, Итого_СуммаПособия, "Итого_СуммаПособия");
	УправлениеПечатьюБЗК.ВывестиСуммуПоБуквам(Секция, Итого_РасходыСверхНорм, "Итого_РасходыСверхНорм");
	
	ТабличныйДокумент.Вывести(Секция.ТабличныйДокумент);
	
КонецПроцедуры

Процедура ВывестиПодвалВозмещенияБольничныхВЧастиФБ(КонтекстПечати, Выборка, ТаблицаПособий)
	Секция = УправлениеПечатьюБЗК.СекцияПечатнойФормы(КонтекстПечати, "Подвал");
	
	Параметры = Новый Структура(КонтекстПечати.ИменаПараметровОбластей.Подвал);
	ЗаполнитьЗначенияСвойств(Параметры, Выборка);
	
	УправлениеПечатьюБЗК.ВывестиПоБуквам(Секция, Выборка.РегистрационныйНомерФСС, "РегистрационныйНомер");
	УправлениеПечатьюБЗК.ВывестиПоБуквам(Секция, Выборка.ДополнительныйКодФСС,    "ДополнительныйКод");
	УправлениеПечатьюБЗК.ВывестиПоБуквам(Секция, Выборка.КодПодчиненностиФСС,     "КодПодчиненности");
	УправлениеПечатьюБЗК.ВывестиПоБуквам(Секция, Выборка.ИНН,                     "ИНН");
	УправлениеПечатьюБЗК.ВывестиПоБуквам(Секция, Выборка.КПП,                     "КПП");
	
	ИменаПолей = "Индекс, Регион, Район, НаселенныйПункт, Улица, Дом, Корпус, Строение, Квартира";
	УправлениеПечатьюБЗК.ВывестиАдресПоБуквам(Секция, Выборка.АдресОрганизации, "АдресОрганизации", ИменаПолей);
	
	УправлениеПечатьюБЗК.ВывестиПоБуквам(Секция, Выборка.НаименованиеБанка,  "НаименованиеБанка");
	УправлениеПечатьюБЗК.ВывестиПоБуквам(Секция, Выборка.НомерСчета,         "НомерСчета");
	УправлениеПечатьюБЗК.ВывестиПоБуквам(Секция, Выборка.БИКБанка,           "БИК");
	УправлениеПечатьюБЗК.ВывестиПоБуквам(Секция, Выборка.НомерЛицевогоСчета, "НомерЛицевогоСчета");
	УправлениеПечатьюБЗК.ВывестиПоБуквам(Секция, Выборка.КБК,                "КБК");
	
	УправлениеПечатьюБЗК.ВывестиТелефонПоБуквам(Секция, Выборка.ТелефонСоставителя, "ТелефонСтрахователя");
	
	УправлениеПечатьюБЗК.ВывестиПоБуквам(Секция, Выборка.АдресЭлектроннойПочтыОрганизации, "АдресЭлектроннойПочты");
	
	Секция.ТабличныйДокумент.Параметры.Заполнить(Параметры);
	КонтекстПечати.ТабличныйДокумент.Вывести(Секция.ТабличныйДокумент);
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
