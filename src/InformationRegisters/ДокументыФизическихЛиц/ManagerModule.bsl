#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Функция возвращает действующий на указанную дату документ, удостоверяющий личность.
//
// Параметры:
//	Физлицо			- СправочникСсылка.Контрагенты, СправочникСсылка.ФизическиеЛица - физическое лицо, для которого необходимо получить документ.
//	Дата			- Дата - дата, на которую необходимо получить документ.
//
// Возвращаемое значение:
//		Строка - представление документа, удостоверяющего личность.
//
Функция ДокументУдостоверяющийЛичностьФизлица(Физлицо, Дата = Неопределено) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Физлицо",	Физлицо);
	Запрос.УстановитьПараметр("ДатаСреза",	Дата);
	
	ТекстЗапроса =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ДокументыФизическихЛиц.Представление
	|ИЗ
	|	РегистрСведений.ДокументыФизическихЛиц КАК ДокументыФизическихЛиц
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			МАКСИМУМ(ДокументыФизическихЛиц.Период) КАК Период,
	|			ДокументыФизическихЛиц.Физлицо КАК Физлицо
	|		ИЗ
	|			РегистрСведений.ДокументыФизическихЛиц КАК ДокументыФизическихЛиц
	|		ГДЕ
	|			ДокументыФизическихЛиц.ЯвляетсяДокументомУдостоверяющимЛичность
	|			И ДокументыФизическихЛиц.Физлицо = &Физлицо
	|			И ДокументыФизическихЛиц.Период <= &ДатаСреза
	|		
	|		СГРУППИРОВАТЬ ПО
	|			ДокументыФизическихЛиц.Физлицо) КАК ДокументыСрез
	|		ПО ДокументыФизическихЛиц.Период = ДокументыСрез.Период
	|			И ДокументыФизическихЛиц.Физлицо = ДокументыСрез.Физлицо
	|			И (ДокументыФизическихЛиц.ЯвляетсяДокументомУдостоверяющимЛичность)";
	
	Если НЕ ЗначениеЗаполнено(Дата) Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "И ДокументыФизическихЛиц.Период <= &ДатаСреза", "");
	КонецЕсли;
	
	Запрос.Текст = ТекстЗапроса;
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Представление;
	КонецЕсли;
	
	Возврат "";
	
КонецФункции

// Функция проверяет, является-ли указанный вид документа документом, удостоверяющим личность для этого физлица.
//
// Параметры:
//	Физлицо			- СправочникСсылка.Контрагенты, СправочникСсылка.ФизическиеЛица - физическое лицо, для которого необходимо получить документ.
//	ВидДокумента	- СправочникСсылка.ВидыДокументовФизическихЛиц - вид документа, удостоверяющего личность.
//	Дата			- Дата - дата, на которую необходимо получить документ.
//
// Возвращаемое значение:
//		Булево - является ли указанный вид документа документом, удостоверяющим личность.
//
Функция ЯвляетсяУдостоверениемЛичности(Физлицо, ВидДокумента, Дата) Экспорт
	
	Если Не ЗначениеЗаполнено(Физлицо) Или ВидДокумента.Пустая() Или Не ЗначениеЗаполнено(Дата) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Физлицо",		Физлицо);
	Запрос.УстановитьПараметр("ВидДокумента",	ВидДокумента);
	Запрос.УстановитьПараметр("ДатаСреза",		Дата);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ДокументыФизическихЛиц.ВидДокумента
	|ИЗ
	|	РегистрСведений.ДокументыФизическихЛиц КАК ДокументыФизическихЛиц
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			МАКСИМУМ(ДокументыФизическихЛиц.Период) КАК Период,
	|			ДокументыФизическихЛиц.Физлицо КАК Физлицо
	|		ИЗ
	|			РегистрСведений.ДокументыФизическихЛиц КАК ДокументыФизическихЛиц
	|		ГДЕ
	|			ДокументыФизическихЛиц.Физлицо = &Физлицо
	|			И ДокументыФизическихЛиц.Период < &ДатаСреза
	|			И ДокументыФизическихЛиц.ЯвляетсяДокументомУдостоверяющимЛичность
	|		
	|		СГРУППИРОВАТЬ ПО
	|			ДокументыФизическихЛиц.Физлицо) КАК ДокументыСрез
	|		ПО ДокументыФизическихЛиц.Физлицо = ДокументыСрез.Физлицо
	|			И ДокументыФизическихЛиц.Период = ДокументыСрез.Период
	|			И (ДокументыФизическихЛиц.ВидДокумента = &ВидДокумента)";
	Возврат Не Запрос.Выполнить().Пустой();
	
КонецФункции

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Физлицо ТОЛЬКО Справочник.ФизическиеЛица)
	|	ИЛИ ЗначениеРазрешено(ВЫРАЗИТЬ(Физлицо КАК Справочник.Контрагенты).Партнер)";
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПредставлениеЗаписи(Запись) Экспорт
	
	Если Запись.ВидДокумента.Пустая() Тогда
		Представление = "";
	Иначе
		
		ТекстСерия				= НСтр("ru = ', серия: %1';
										|en = ', batch: %1'");
		ТекстНомер				= НСтр("ru = ', № %1';
										|en = ', No.%1'");
		ТекстДатаВыдачи			= НСтр("ru = ', выдан: %1';
											|en = ', issued: %1'");
		ТекстСрокДействия		= НСтр("ru = ', действует до: %1';
										|en = ', valid until: %1'");
		ТекстКодПодразделения	= НСтр("ru = ', код подр. %1';
										|en = ', business unit code %1'");
		
		Представление = ""
			+ Запись.ВидДокумента
			+ ?(ЗначениеЗаполнено(Запись.Серия), СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСерия, Запись.Серия), "")
			+ ?(ЗначениеЗаполнено(Запись.Номер), СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстНомер, Запись.Номер), "")
			+ ?(ЗначениеЗаполнено(Запись.ДатаВыдачи), СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстДатаВыдачи, Формат(Запись.ДатаВыдачи, НСтр("ru = 'ДФ=''дд ММММ гггг ""года""''';
																																								|en = 'DF=''MMMM dd yyyy'''"))), "")
			+ ?(ЗначениеЗаполнено(Запись.СрокДействия), СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСрокДействия, Формат(Запись.СрокДействия, НСтр("ru = 'ДФ=''дд ММММ гггг ""года""''';
																																									|en = 'DF=''MMMM dd yyyy'''"))), "")
			+ ?(ЗначениеЗаполнено(Запись.КемВыдан), ", " + Запись.КемВыдан, "");
			
		//++ Локализация
			Представление = Представление + ?(ЗначениеЗаполнено(Запись.КодПодразделения) И Запись.ВидДокумента = Справочники.ВидыДокументовФизическихЛиц.ПаспортРФ,
												СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстКодПодразделения, Запись.КодПодразделения), "");
		//-- Локализация
		
	КонецЕсли;
	
	Возврат Представление;
	
КонецФункции

#КонецОбласти

#КонецЕсли