#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	ДействияПередЗаписью();
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	ДействияПриЗаписи();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ФизическиеЛица

Процедура ПриИзмененииФизическогоЛица() Экспорт
	Возврат;
КонецПроцедуры

#КонецОбласти

#Область ПередЗаписью

Процедура ДействияПередЗаписью() Экспорт
	Если Не ЗначениеЗаполнено(Дата) Тогда
		Дата = ТекущаяДатаСеанса();
		Если ЗначениеЗаполнено(ВходящаяДата) И НачалоДня(ВходящаяДата) < НачалоДня(Дата) Тогда
			Дата = ВходящаяДата;
		КонецЕсли;
	КонецЕсли;
	ДополнительныеСвойства.Вставить("ЗначенияРеквизитовДоЗаписи", ЗначенияРеквизитовДоЗаписи());
КонецПроцедуры

Функция ЗначенияРеквизитовДоЗаписи()
	ИменаРеквизитов = "СНИЛС, Страхователь";
	ЭтоНовый = ЭтоНовый();
	Если ЭтоНовый Тогда
		ЗначенияРеквизитовДоЗаписи = ОбщегоНазначенияБЗК.ЗначенияСвойств(ЭтотОбъект, ИменаРеквизитов);
	Иначе
		ЗначенияРеквизитовДоЗаписи = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Ссылка, ИменаРеквизитов);
	КонецЕсли;
	ЗначенияРеквизитовДоЗаписи.Вставить("ЭтоНовый", ЭтоНовый);
	Возврат ЗначенияРеквизитовДоЗаписи;
КонецФункции

#КонецОбласти

#Область ПриЗаписи

Процедура ДействияПриЗаписи() Экспорт
	РегистрыСведений.СНИЛСВходящихСообщенийСЭДО.ОбновитьПоДокументу(
		Ссылка,
		Страхователь,
		ИдентификаторСообщения,
		СНИЛС,
		ФизическоеЛицо,
		ВходящаяДата,
		ФИО,
		88);
	
	Таблица = РегистрыСведений.ЗастрахованныеЛицаСЭДО.ПустаяТаблицаОбновления();
	ЗначенияРеквизитовДоЗаписи = ДополнительныеСвойства.ЗначенияРеквизитовДоЗаписи;
	Если Не ЗначенияРеквизитовДоЗаписи.ЭтоНовый
		И ЗначениеЗаполнено(ЗначенияРеквизитовДоЗаписи.СНИЛС)
		И ЗначениеЗаполнено(ЗначенияРеквизитовДоЗаписи.Страхователь)
		И (ЗначенияРеквизитовДоЗаписи.СНИЛС <> ЭтотОбъект.СНИЛС
			Или ЗначенияРеквизитовДоЗаписи.Страхователь <> ЭтотОбъект.Страхователь) Тогда
		ЗаполнитьЗначенияСвойств(Таблица.Добавить(), ЗначенияРеквизитовДоЗаписи);
	КонецЕсли;
	Если ЗначениеЗаполнено(ЭтотОбъект.СНИЛС)
		И ЗначениеЗаполнено(ЭтотОбъект.Страхователь) Тогда
		ЗаполнитьЗначенияСвойств(Таблица.Добавить(), ЭтотОбъект);
	КонецЕсли;
	Если Таблица.Количество() > 0 Тогда
		РегистрыСведений.ЗастрахованныеЛицаСЭДО.ОбновитьПоТаблице(Таблица, Ложь);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.';
						|en = 'Invalid object call on the client.'");
#КонецЕсли