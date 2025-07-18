#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	Если Не ЗначениеЗаполнено(ДатаСоздания) Тогда
		ДатаСоздания = ТекущаяДата(); // АПК:143 Для фильтрации событий в журнале регистрации требуется дата сервера.
	КонецЕсли;
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	МенеджерРегистра = РегистрыСведений.РегистрацииОтветовНаЗапросыФССДляРасчетаПособий;
	МенеджерРегистра.ПриЗаписиДокументаУведомлениеОбИзмененииРасчетаПособия(ЭтотОбъект);
	УстановитьВходящийЗапросОбработан();
КонецПроцедуры

Процедура ПередУдалением(Отказ)
	МенеджерРегистра = РегистрыСведений.РегистрацииОтветовНаЗапросыФССДляРасчетаПособий;
	МенеджерРегистра.ПриЗаписиДокументаУведомлениеОбИзмененииРасчетаПособия(ЭтотОбъект, Истина);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ФиксацияВторичныхДанныхВДокументах

Функция ОбновитьВторичныеДанные(ПараметрыФиксации = Неопределено) Экспорт
	УстановитьПривилегированныйРежим(Истина);
	Модифицирован = Ложь;
	
	Если ОбъектЗафиксирован() Тогда
		Возврат Модифицирован;
	КонецЕсли;
	
	Если ПараметрыФиксации = Неопределено Тогда
		ПараметрыФиксации = Менеджер().ПараметрыФиксацииВторичныхДанных();
	КонецЕсли;
	
	Если ЗаполнитьПодтверждениеПолучения(ПараметрыФиксации) Тогда
		Модифицирован = Истина;
	КонецЕсли;
	
	Если ЗаполнитьМаксимальнуюДатуПодтвержденияПолучения(ПараметрыФиксации) Тогда
		Модифицирован = Истина;
	КонецЕсли;
	
	Если ЗаполнитьСвязанныеДокументы(ПараметрыФиксации) Тогда
		Модифицирован = Истина;
	КонецЕсли;
	
	Возврат Модифицирован;
КонецФункции

Функция Менеджер()
	Возврат Документы.УведомлениеОбИзмененииРасчетаПособия;
КонецФункции

Функция ОбъектЗафиксирован() Экспорт
	Возврат Менеджер().ОбъектЗафиксирован(ЭтотОбъект);
КонецФункции

Функция ЗаполнитьПодтверждениеПолучения(ПараметрыФиксации) Экспорт
	
	Реквизиты = Новый Структура("ТребуетсяПодтверждение, ДатаОтправкиПодтверждения, ПодтверждениеПолученоСФР");
	Если ФиксацияВторичныхДанныхВДокументах.РеквизитыШапкиЗафиксированы(ЭтотОбъект, Реквизиты) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВходящиеСообщенияСЭДОФСС.Идентификатор КАК Идентификатор,
	|	ВходящиеСообщенияСЭДОФСС.Организация КАК Организация,
	|	ВходящиеСообщенияСЭДОФСС.ТребуетсяПодтверждение КАК ТребуетсяПодтверждение,
	|	ВходящиеСообщенияСЭДОФСС.ДатаОтправкиПодтверждения КАК ДатаОтправкиПодтверждения,
	|	ВходящиеСообщенияСЭДОФСС.ДатаПолученияИзвещенияОПолученииПодтверждения КАК ДатаПолученияИзвещенияОПолученииПодтверждения,
	|	ВходящиеСообщенияСЭДОФСС.ОшибкаПодтверждения КАК ОшибкаПодтверждения,
	|	ВходящиеСообщенияСЭДОФСС.ДатаПолученияОшибкиПодтверждения КАК ДатаПолученияОшибкиПодтверждения
	|ИЗ
	|	РегистрСведений.ВходящиеСообщенияСЭДОФСС КАК ВходящиеСообщенияСЭДОФСС
	|ГДЕ
	|	ВходящиеСообщенияСЭДОФСС.Идентификатор = &Идентификатор";
	Запрос.УстановитьПараметр("Идентификатор", ИдентификаторСообщения);
	
	Таблица = Запрос.Выполнить().Выгрузить();
	Если Таблица.Количество() > 1 Тогда
		Найденные = Таблица.НайтиСтроки(Новый Структура("Организация", Страхователь));
		Если Найденные.Количество() > 0 Тогда
			СтрокаТаблицы = Найденные[0];
		Иначе
			СтрокаТаблицы = Таблица[0];
		КонецЕсли
	ИначеЕсли Таблица.Количество() = 1 Тогда
		СтрокаТаблицы = Таблица[0];
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
	Реквизиты.ТребуетсяПодтверждение    = СтрокаТаблицы.ТребуетсяПодтверждение;
	Реквизиты.ДатаОтправкиПодтверждения = СтрокаТаблицы.ДатаОтправкиПодтверждения;
	Реквизиты.ПодтверждениеПолученоСФР  = ЗначениеЗаполнено(СтрокаТаблицы.ДатаПолученияИзвещенияОПолученииПодтверждения);
	
	Возврат ФиксацияВторичныхДанныхВДокументах.ОбновитьДанныеШапки(Реквизиты, ЭтотОбъект, ПараметрыФиксации);
КонецФункции

Функция ЗаполнитьМаксимальнуюДатуПодтвержденияПолучения(ПараметрыФиксации)
	Если Не ЗначениеЗаполнено(ДатаСообщения) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Реквизиты = Новый Структура("МаксимальнаяДатаПодтверждения");
	Если ФиксацияВторичныхДанныхВДокументах.РеквизитыШапкиЗафиксированы(ЭтотОбъект, Реквизиты) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Реквизиты.МаксимальнаяДатаПодтверждения = Менеджер().МаксимальнаяДатаПодтвержденияПолучения(ЭтотОбъект);
	
	Возврат ФиксацияВторичныхДанныхВДокументах.ОбновитьДанныеШапки(Реквизиты, ЭтотОбъект, ПараметрыФиксации);
КонецФункции

Функция ЗаполнитьСвязанныеДокументы(ПараметрыФиксации)
	
	Реквизиты = Новый Структура("ОтветНаЗапрос,ВходящийЗапрос,ФизическоеЛицо,СНИЛС,Сотрудник");
	Если ФиксацияВторичныхДанныхВДокументах.РеквизитШапкиЗафиксирован(ЭтотОбъект, Реквизиты) Тогда
		Возврат Ложь;
	КонецЕсли;
	Реквизиты = Менеджер().ДанныеСвязанныхДокументов(Страхователь, НомерПроцесса, ДатаСообщения);
	
	Возврат ФиксацияВторичныхДанныхВДокументах.ОбновитьДанныеШапки(Реквизиты, ЭтотОбъект, ПараметрыФиксации);
	
КонецФункции

#КонецОбласти

Процедура УстановитьВходящийЗапросОбработан()

	Если ВидУведомления <> Перечисления.ВидыУведомленийОбИзмененииРасчетаПособия.ПроцессЗакрыт Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВходящийЗапросФССДляРасчетаПособия.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.ВходящийЗапросФССДляРасчетаПособия КАК ВходящийЗапросФССДляРасчетаПособия
	|ГДЕ
	|	ВходящийЗапросФССДляРасчетаПособия.Ссылка = &ВходящийЗапрос
	|	И НЕ ВходящийЗапросФССДляРасчетаПособия.Обработан";
	Запрос.УстановитьПараметр("ВходящийЗапрос", ВходящийЗапрос);

	УстановитьПривилегированныйРежим(Истина);
	Результат = Запрос.Выполнить();
	Если Не Результат.Пустой() Тогда
		Выборка = Результат.Выбрать();
		Если Выборка.Следующий() Тогда
			ВходящийЗапросОбъект = ВходящийЗапрос.ПолучитьОбъект();
			ВходящийЗапросОбъект.Обработан = Истина;
			СЭДОФСС.ЗаписатьДокумент(ВходящийЗапросОбъект, Истина);
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.';
						|en = 'Invalid object call on the client.'");
#КонецЕсли