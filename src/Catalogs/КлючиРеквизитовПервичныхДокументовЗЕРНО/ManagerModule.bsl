#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

#Область ПоискСсылок

Функция КлючПервичногоДокумента(ИсходныеДанные, ИмяПоля, Организация, Подразделение, ПараметрыОбмена, ИсходныеДанныеЯвляютсяОбъектом = Ложь) Экспорт
	
	Если ИсходныеДанныеЯвляютсяОбъектом Тогда
		ДанныеДокумента = ИсходныеДанные;
	Иначе
		ДанныеДокумента = ИсходныеДанные[ИмяПоля];
	КонецЕсли;
	
	Если ДанныеДокумента = Неопределено Тогда
		Возврат ПустаяСсылка();
	КонецЕсли;
	
	ИмяТаблицы = Метаданные.Справочники.КлючиРеквизитовПервичныхДокументовЗЕРНО.ПолноеИмя();
	
	ДанныеПервичногоДокумента = ДанныеПервичногоДокумента(ДанныеДокумента, ИмяПоля, Организация, Подразделение, ПараметрыОбмена);
	Если Не ЗначениеЗаполнено(ДанныеПервичногоДокумента.Идентификатор) Тогда
		Возврат ПустаяСсылка();
	КонецЕсли;
	
	СправочникСсылка = ИнтеграцияЗЕРНОСлужебный.СсылкаПоИдентификатору(
		ПараметрыОбмена, ИмяТаблицы, ДанныеПервичногоДокумента.Идентификатор);
	
	Если Не ЗначениеЗаполнено(СправочникСсылка) Тогда
		
		Блокировка = Новый БлокировкаДанных();
		ЭлементБлокировки = Блокировка.Добавить(ИмяТаблицы);
		ЭлементБлокировки.УстановитьЗначение("Идентификатор", ДанныеПервичногоДокумента.Идентификатор);
		
		НачатьТранзакцию();
		
		Попытка
			
			Блокировка.Заблокировать();
			
			СправочникСсылка = ИнтеграцияЗЕРНОСлужебный.СсылкаПоИдентификатору(ПараметрыОбмена, ИмяТаблицы, ДанныеПервичногоДокумента.Идентификатор);
			
			Если Не ЗначениеЗаполнено(СправочникСсылка) Тогда
				СправочникСсылка = ЗагрузитьКлючПервичногоДокумента(ДанныеПервичногоДокумента, ПараметрыОбмена,, Ложь);
			КонецЕсли;
			
			ЗафиксироватьТранзакцию();
			
		Исключение
			
			ОтменитьТранзакцию();
			
			ТекстОшибки = СтрШаблон(
				НСтр("ru = 'Ошибка при создании справочника %1 с идентификатором %2:
				           |%3';
				           |en = 'Ошибка при создании справочника %1 с идентификатором %2:
				           |%3'"),
				Метаданные.Справочники.КлючиРеквизитовПервичныхДокументовЗЕРНО.Синоним,
				ДанныеПервичногоДокумента.Идентификатор,
				ОбработкаОшибок.КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
			
			ТекстОшибкиПодробно = СтрШаблон(
				НСтр("ru = 'Ошибка при создании справочника %1 с идентификатором %2:
				           |%3';
				           |en = 'Ошибка при создании справочника %1 с идентификатором %2:
				           |%3'"),
				Метаданные.Справочники.КлючиРеквизитовПервичныхДокументовЗЕРНО.Синоним,
				ДанныеПервичногоДокумента.Идентификатор,
				ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			
			ОбщегоНазначенияИСВызовСервера.ЗаписатьОшибкуВЖурналРегистрации(
				ТекстОшибкиПодробно,
				НСтр("ru = 'Работа с ключами первичных документов';
					|en = 'Работа с ключами первичных документов'", ОбщегоНазначения.КодОсновногоЯзыка()));
			
			ВызватьИсключение ТекстОшибки;
			
		КонецПопытки;
		
	КонецЕсли;
	
	Возврат СправочникСсылка;
	
КонецФункции

Функция ЗагрузитьКлючПервичногоДокумента(ДанныеДокумента, ПараметрыОбмена, СуществующийОбъект = Неопределено, ТребуетсяПоиск = Истина) Экспорт
	
	ЗаписьНового       = Ложь;
	МетаданныеЭлемента = Метаданные.Справочники.КлючиРеквизитовПервичныхДокументовЗЕРНО;
	Идентификатор      = ДанныеДокумента.Идентификатор;
	
	Если СуществующийОбъект = Неопределено Тогда
		
		СуществующийЭлемент = Неопределено;
		Если ТребуетсяПоиск Тогда
			СуществующийЭлемент = ИнтеграцияЗЕРНОСлужебный.СсылкаПоИдентификатору(
				ПараметрыОбмена,
				МетаданныеЭлемента.ПолноеИмя(),
				Идентификатор);
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(СуществующийЭлемент) Тогда
			СуществующийОбъект = СоздатьЭлемент();
			СуществующийОбъект.Идентификатор = Идентификатор;
			СуществующийОбъект.ТипДокумента  = ДанныеДокумента.ТипДокумента;
			ЗаписьНового = Истина;
		Иначе
			СуществующийОбъект = СуществующийЭлемент.ПолучитьОбъект();
		КонецЕсли;
		
	КонецЕсли;
	
	Если Не ЗаписьНового Тогда
		СуществующийОбъект.Заблокировать();
	КонецЕсли;
	
	ЭлементДанных = ДанныеДокумента.Данные;
	
	ДанныеНаименования = Новый Массив();
	
	Если СуществующийОбъект.ТипДокумента = Перечисления.ТипыПервичныхДокументовЗЕРНО.ДоговорХранения Тогда
		СуществующийОбъект.Дата  = ЭлементДанных.dateDogovor;
		СуществующийОбъект.Номер = ЭлементДанных.numberDogovor;
	Иначе
		СуществующийОбъект.Дата  = ЭлементДанных.date;
		СуществующийОбъект.Номер = ЭлементДанных.number;
	КонецЕсли;
	
	Если СуществующийОбъект.ТипДокумента = Перечисления.ТипыПервичныхДокументовЗЕРНО.ДекларацияСоответствия Тогда
		СуществующийОбъект.ДатаОкончания = ЭлементДанных.dateEnd;
	ИначеЕсли СуществующийОбъект.ТипДокумента = Перечисления.ТипыПервичныхДокументовЗЕРНО.ВетеринарныйСертификат Тогда
		СуществующийОбъект.ИдентификаторВЕТИС = ЭлементДанных.uuid;
		СуществующийОбъект.Серия              = ЭлементДанных.series;
		СуществующийОбъект.ВидДокумента       = ЭлементДанных.KindDoc;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(СуществующийОбъект.ТипДокумента) Тогда
		ДанныеНаименования.Добавить(СуществующийОбъект.ТипДокумента);
	КонецЕсли;
	Если ЗначениеЗаполнено(СуществующийОбъект.Номер) Тогда
		ДанныеНаименования.Добавить(СтрШаблон(НСтр("ru = '№%1';
													|en = '№%1'"), СуществующийОбъект.Номер));
	КонецЕсли;
	Если ЗначениеЗаполнено(СуществующийОбъект.Дата) Тогда
		ДанныеНаименования.Добавить(СтрШаблон(НСтр("ru = 'от %1';
													|en = 'от %1'"), Формат(СуществующийОбъект.Дата, "ДФ=dd.MM.yyyy;")));
	КонецЕсли;
	Если ДанныеНаименования.Количество() = 0 Тогда
		ДанныеНаименования.Добавить(НСтр("ru = '<Не указано>';
										|en = '<Не указано>'"));
	КонецЕсли;
	
	СуществующийОбъект.Наименование = СтрСоединить(ДанныеНаименования, " ");
	СуществующийОбъект.Записать();
	
	ИнтеграцияЗЕРНОСлужебный.ОбновитьСсылку(ПараметрыОбмена, МетаданныеЭлемента.ПолноеИмя(), Идентификатор, СуществующийОбъект.Ссылка);
	
	Возврат СуществующийОбъект.Ссылка;
	
КонецФункции

Функция ДанныеПервичногоДокумента(ДанныеДокумента, ИмяПоля, Организация, Подразделение, ПараметрыОбмена)
	
	ВозвращаемоеЗначение = Новый Структура();
	ВозвращаемоеЗначение.Вставить("ТипДокумента",  Неопределено);
	ВозвращаемоеЗначение.Вставить("Идентификатор", Неопределено);
	ВозвращаемоеЗначение.Вставить("Данные",        ДанныеДокумента);
	
	ПараметрыТипа = ПараметрыОбмена.ПараметрыПреобразования.ТипыДокументовПоИменамСвойств[ИмяПоля];
	Если ПараметрыТипа = Неопределено Тогда
		Возврат ВозвращаемоеЗначение;
	КонецЕсли;
	ПоляКлюча = ПоляСоставногоКлючаПоТипуПервичногоДокумента(ПараметрыТипа.ТипДокумента);
	Если ПараметрыТипа.ТипДокумента = Перечисления.ТипыПервичныхДокументовЗЕРНО.Товаросопроводительный Тогда
		ВозвращаемоеЗначение.ТипДокумента = ДанныеДокумента.KindDoc;
	ИначеЕсли ПараметрыТипа.ТипДокумента = Перечисления.ТипыПервичныхДокументовЗЕРНО.ПодтверждениеПраваСобственности Тогда
		ВозвращаемоеЗначение.ТипДокумента = Справочники.КлассификаторНСИЗЕРНО.КлассификаторНСИ(
			Перечисления.ВидыКлассификаторовЗЕРНО.ДокументПраваСобственности,
			ДанныеДокумента.KindDoc,
			Организация,
			Подразделение,
			ПараметрыОбмена);
	Иначе
		ВозвращаемоеЗначение.ТипДокумента = ПараметрыТипа.ТипДокумента;
		ДополнительноеЗначениеКлюча       = XMLСтрока(ПараметрыТипа.ТипДокумента);
	КонецЕсли;
	ВозвращаемоеЗначение.Идентификатор = ИнтеграцияЗЕРНОСлужебный.СоставнойКлючОбъекта(
		ВозвращаемоеЗначение.Данные, ПоляКлюча, ДополнительноеЗначениеКлюча);
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

Функция ПоляСоставногоКлючаПоТипуПервичногоДокумента(ТипДокумента = Неопределено) Экспорт
	
	ВозвращаемоеЗначение = Новый Массив();
	
	Если ТипДокумента = Перечисления.ТипыПервичныхДокументовЗЕРНО.ДоговорХранения Тогда
		ВозвращаемоеЗначение.Добавить("numberDogovor");
		ВозвращаемоеЗначение.Добавить("dateDogovor");
	Иначе
		Если ТипДокумента = Перечисления.ТипыПервичныхДокументовЗЕРНО.Товаросопроводительный
			Или ТипДокумента = Перечисления.ТипыПервичныхДокументовЗЕРНО.ПодтверждениеПраваСобственности
			Или ТипДокумента = Перечисления.ТипыПервичныхДокументовЗЕРНО.ВетеринарныйСертификат Тогда
			ВозвращаемоеЗначение.Добавить("KindDoc");
		КонецЕсли;
		ВозвращаемоеЗначение.Добавить("number");
		ВозвращаемоеЗначение.Добавить("date");
		Если ТипДокумента = Перечисления.ТипыПервичныхДокументовЗЕРНО.ДекларацияСоответствия Тогда
			ВозвращаемоеЗначение.Добавить("dateEnd");
		ИначеЕсли ТипДокумента = Перечисления.ТипыПервичныхДокументовЗЕРНО.ВетеринарныйСертификат Тогда
			ВозвращаемоеЗначение.Добавить("series");
			ВозвращаемоеЗначение.Добавить("uuid");
		КонецЕсли;
	КонецЕсли;
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли
