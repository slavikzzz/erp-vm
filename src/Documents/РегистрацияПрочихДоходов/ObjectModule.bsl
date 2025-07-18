#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Документы.РегистрацияПрочихДоходов.ПровестиПоУчетам(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	ЗарплатаКадры.ПроверитьДатуВыплаты(ЭтотОбъект, Отказ);
	ЗарплатаКадрыРасширенный.ПроверитьЗадвоениеФизическихЛицВТабличнойЧастиДокумента(
		ЭтотОбъект, "НачисленияУдержанияВзносы", Отказ);
	// Доходы с кодом НДФЛ 1010 (Дивиденды) регистрируются только документом "ДивидендыФизическимЛицам".
	ДивидендыНДФЛ = ОбщегоНазначения.ПредопределенныйЭлемент("Справочник.ВидыДоходовНДФЛ.Код1010");
	КодНДФЛ = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВидПрочегоДохода, "КодДоходаНДФЛ");
	Если КодНДФЛ = ДивидендыНДФЛ Тогда
		ТекстСообщения = "Доходы с кодом НДФЛ 1010 (Дивиденды) регистрируются только документом ""Дивиденды""";
		Поле = "Объект.ВидПрочегоДохода";
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, Ссылка, Поле, , Отказ);
	КонецЕсли;
	
	Если НЕ ПеречислениеНДФЛВыполнено Тогда
		ИсключаемыеРеквизиты = Новый Массив;
		ИсключаемыеРеквизиты.Добавить("ДатаПлатежаНДФЛ");
		ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, ИсключаемыеРеквизиты);
	КонецЕсли;
	
	// Проверка корректности распределения по источникам финансирования
	Если РаспределятьРезультатыРасчета Тогда
		ОтражениеЗарплатыВБухучетеРасширенный.ПроверитьРезультатыРаспределенияНачисленийУдержанийОбъекта(
		ЭтотОбъект, "НачисленияУдержанияВзносы,Удержания,НДФЛ", Отказ, ВидПрочегоДохода, Истина);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	ВсегоВыплачено = НачисленияУдержанияВзносы.Итог("КВыплате");
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	ДанныеДляБухучета = Документы.РегистрацияПрочихДоходов.ДанныеДляБухучетаЗарплатыПервичныхДокументов(ЭтотОбъект);
	ОтражениеЗарплатыВБухучетеРасширенный.ЗарегистрироватьБухучетЗарплатыПервичныхДокументов(ДанныеДляБухучета);
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.';
						|en = 'Invalid object call on the client.'");
#КонецЕсли