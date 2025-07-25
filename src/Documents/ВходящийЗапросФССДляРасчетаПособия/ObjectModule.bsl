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

#Область ПервичноеЗаполнение

Функция ЗаполнитьДату() Экспорт
	ДатаСообщения = СЭДОФСС.ДатаСообщения(ИдентификаторСообщения);
	Если ДатаСообщения <> Дата Тогда
		Дата = ДатаСообщения;
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;
КонецФункции

Функция ЗаполнитьПервичныйДокумент() Экспорт
	Возврат СЭДОФСС.ЗаполнитьПервичныйДокументДляРасчетаПособияФСС(ЭтотОбъект, Ложь);
КонецФункции

Функция ЗаполнитьДатыОтправки() Экспорт
	Если Обработан Тогда
		МаксДатаОтвета = '00010101';
	Иначе
		МаксДатаОтвета = Документы.ВходящийЗапросФССДляРасчетаПособия.МаксимальнаяДатаОтвета(ЭтотОбъект);
	КонецЕсли;
	ЕстьИзменения = (МаксДатаОтвета <> МаксимальнаяДатаОтвета);
	МаксимальнаяДатаОтвета = МаксДатаОтвета;
	Возврат ЕстьИзменения;
КонецФункции

#КонецОбласти

#Область ФизическиеЛица

Процедура ПриИзмененииФизическогоЛица() Экспорт
	Возврат;
КонецПроцедуры

#КонецОбласти

#Область ПередЗаписью

Процедура ДействияПередЗаписью() Экспорт
	Если Не ЗначениеЗаполнено(ДатаСоздания) Тогда
		ДатаСоздания = ТекущаяДата(); // АПК:143 Для фильтрации событий в журнале регистрации требуется дата сервера.
	КонецЕсли;
	
	ДополнительныеСвойства.Вставить("ЗначенияРеквизитовДоЗаписи", ЗначенияРеквизитовДоЗаписи());
	
	ГоловнаяОрганизация = ЗарплатаКадры.ГоловнаяОрганизация(Страхователь);
	
	// Физлицо заполняется безусловно, т.к. определяет права.
	Если ЗначениеЗаполнено(Сотрудник) Тогда
		ФизическоеЛицо = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Сотрудник, "ФизическоеЛицо");
	ИначеЕсли ЗначениеЗаполнено(ФизическоеЛицо) И ЗначениеЗаполнено(Страхователь) Тогда
		УстановитьПривилегированныйРежим(Истина);
		КадровыеДанные = КадровыйУчет.КадровыеДанныеОсновногоСотрудникаФизическогоЛица(
			Страхователь,
			ФизическоеЛицо,
			"Сотрудник, Организация",
			ТекущаяДатаСеанса(),
			Ложь,
			СотрудникТекстОшибкиПоиска);
		УстановитьПривилегированныйРежим(Ложь);
		Если КадровыеДанные <> Неопределено Тогда
			Если ЗначениеЗаполнено(КадровыеДанные.Организация) Тогда
				Организация = КадровыеДанные.Организация;
			КонецЕсли;
			Сотрудник = КадровыеДанные.Сотрудник;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

Функция ЗначенияРеквизитовДоЗаписи()
	ИменаРеквизитов = "ГоловнаяОрганизация, НомерЛН, ПометкаУдаления";
	Если ЭтоНовый() Тогда
		Возврат ОбщегоНазначенияБЗК.ЗначенияСвойств(ЭтотОбъект, ИменаРеквизитов);
	Иначе
		Возврат ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Ссылка, ИменаРеквизитов);
	КонецЕсли;
КонецФункции

#КонецОбласти

#Область ПриЗаписи

Процедура ДействияПриЗаписи() Экспорт
	РегистрыСведений.СведенияОбЭЛН.ПриЗаписиВходящегоЗапроса(ЭтотОбъект);
	РегистрыСведений.СНИЛСВходящихСообщенийСЭДО.ОбновитьПоДокументу(
		Ссылка,
		Страхователь,
		ИдентификаторСообщения,
		СотрудникСНИЛС,
		ФизическоеЛицо,
		ДатаСообщения,
		СокрЛП(СотрудникФамилия + " " + СотрудникИмя + " " + СотрудникОтчество),
		100);
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.';
						|en = 'Invalid object call on the client.'");
#КонецЕсли