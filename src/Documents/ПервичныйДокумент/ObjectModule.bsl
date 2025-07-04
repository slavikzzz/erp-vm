#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		
		Если ДанныеЗаполнения.Свойство("Партнер") Тогда
			Если НЕ (ДанныеЗаполнения.Свойство("Контрагент") И ЗначениеЗаполнено(ДанныеЗаполнения.Контрагент)) Тогда
				ДанныеЗаполнения.Вставить("Контрагент", ПартнерыИКонтрагенты.ПолучитьКонтрагентаПартнераПоУмолчанию(ДанныеЗаполнения.Партнер));
			КонецЕсли;
			Если ДанныеЗаполнения.Свойство("Организация") 
				И ЗначениеЗаполнено(ДанныеЗаполнения.Организация) 
				И Не ДанныеЗаполнения.Свойство("Валюта") Тогда
				Если (ТипЗнч(ДанныеЗаполнения.Организация) = Тип("ФиксированныйМассив")
					Или ТипЗнч(ДанныеЗаполнения.Организация) = Тип("Массив"))
					И ДанныеЗаполнения.Организация.Количество() > 0 Тогда
					ДанныеЗаполнения.Вставить("Валюта", ЗначениеНастроекПовтИсп.ВалютаРегламентированногоУчетаОрганизации(ДанныеЗаполнения.Организация[0]));
				Иначе
					ДанныеЗаполнения.Вставить("Валюта", ЗначениеНастроекПовтИсп.ВалютаРегламентированногоУчетаОрганизации(ДанныеЗаполнения.Организация));
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		
		Если ДанныеЗаполнения.Свойство("ВалютаДоговора") Тогда
			ДанныеЗаполнения.Вставить("Валюта", ДанныеЗаполнения.ВалютаДоговора);
		КонецЕсли;
		
		Если ДанныеЗаполнения.Свойство("ПорядокРасчетов") Тогда
			Если ТипЗнч(ДанныеЗаполнения.ПорядокРасчетов) = Тип("ФиксированныйМассив")
				ИЛИ ТипЗнч(ДанныеЗаполнения.ПорядокРасчетов) = Тип("Массив") Тогда
				Если ДанныеЗаполнения.ПорядокРасчетов.Найти(Перечисления.ПорядокРасчетов.ПоНакладным) <> Неопределено Тогда
					ПорядокРасчетов = Перечисления.ПорядокРасчетов.ПоНакладным;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		
		Если ДанныеЗаполнения.Свойство("ТипПервичногоДокумента")
			И (ТипЗнч(ДанныеЗаполнения.ТипПервичногоДокумента) = Тип("ФиксированныйМассив")
				Или ТипЗнч(ДанныеЗаполнения.ТипПервичногоДокумента) = Тип("Массив"))
			И ДанныеЗаполнения.ТипПервичногоДокумента.Количество() > 0 Тогда
			ТипПервичногоДокумента = ДанныеЗаполнения.ТипПервичногоДокумента[0];
		КонецЕсли;
		
	КонецЕсли;
	
	ПараметрыЗаполнения = Документы.ПервичныйДокумент.ПараметрыЗаполненияНалогообложенияНДС(ЭтотОбъект);
	Если ПараметрыЗаполнения.Продажа Тогда
		УчетНДСУП.ЗаполнитьНалогообложениеНДСПродажи(НалогообложениеНДС, ПараметрыЗаполнения);
	ИначеЕсли ПараметрыЗаполнения.Закупка Тогда
		УчетНДСУП.ЗаполнитьНалогообложениеНДСЗакупки(НалогообложениеНДС, ПараметрыЗаполнения);
	КонецЕсли;
	
	ИнициализироватьДокумент(ДанныеЗаполнения);
	
	ВзаиморасчетыСервер.ОбработкаЗаполнения(ЭтотОбъект, ДанныеЗаполнения);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Дата              = НачалоДня(ОбщегоНазначения.ТекущаяДатаПользователя());
	ДокументОснование = Неопределено;
	
	ПараметрыЗаполнения = Документы.ПервичныйДокумент.ПараметрыЗаполненияНалогообложенияНДС(ЭтотОбъект);
	Если ПараметрыЗаполнения.Продажа Тогда
		УчетНДСУП.ЗаполнитьНалогообложениеНДСПродажи(НалогообложениеНДС, ПараметрыЗаполнения);
	ИначеЕсли ПараметрыЗаполнения.Закупка Тогда
		УчетНДСУП.ЗаполнитьНалогообложениеНДСЗакупки(НалогообложениеНДС, ПараметрыЗаполнения);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ПроведениеДокументов.ПередЗаписьюДокумента(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	
	ЕстьКорректировки = Ложь;
	ПродажиСервер.ПроверитьНаличиеКорректировок(Ссылка, Ссылка, ЕстьКорректировки);
	Если РежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения И ЕстьКорректировки Тогда
		ПродажиСервер.СообщитьОбОшибкахОтменаПроведенияЕстьКорректировки(Ссылка,Отказ);
	КонецЕсли;
	
	Если Не ТипПервичногоДокумента = Перечисления.ТипыПервичныхДокументов.ПриемНаХранение Тогда
		ПараметрыРегистрации = Документы.ПервичныйДокумент.ПараметрыРегистрацииСчетовФактурПолученных(ЭтотОбъект);
		УчетНДСУП.АктуализироватьСчетаФактурыПолученныеПередЗаписью(ПараметрыРегистрации, РежимЗаписи, ПометкаУдаления, Проведен);
	КонецЕсли;
	
	Если ТипПервичногоДокумента = Перечисления.ТипыПервичныхДокументов.РеализацияКлиенту Тогда
		ПараметрыРегистрации = Документы.ПервичныйДокумент.ПараметрыРегистрацииСчетовФактурВыданных(ЭтотОбъект);
		УчетНДСУП.АктуализироватьСчетаФактурыВыданныеПередЗаписью(ПараметрыРегистрации, РежимЗаписи, ПометкаУдаления, Проведен);
	КонецЕсли;
	
	Если ЭтоНовый() И НЕ ЗначениеЗаполнено(Номер) Тогда
		УстановитьНовыйНомер();
	КонецЕсли;
	
	Если ТипПервичногоДокумента = Перечисления.ТипыПервичныхДокументов.РеализацияКлиенту Тогда
		НомерВходящегоДокумента = Номер;
		ДатаВходящегоДокумента = Дата;
	КонецЕсли;
	
	Если Не ЭтоНовый() 
		И Модифицированность()
		И Не ТипПервичногоДокумента = Перечисления.ТипыПервичныхДокументов.ПриемНаХранение Тогда
		
		Запрос = Новый Запрос();
		Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
		|	ВводОстатковВзаиморасчетовРасчетыСПартнерами.Ссылка 
		|ИЗ
		|	Документ.ВводОстатковВзаиморасчетов.РасчетыСПартнерами КАК ВводОстатковВзаиморасчетовРасчетыСПартнерами
		|ГДЕ
		|	ВводОстатковВзаиморасчетовРасчетыСПартнерами.ДокументРасчетов = &ДокументРасчетов";
		Запрос.УстановитьПараметр("ДокументРасчетов", Ссылка);
		
		РезультатЗапроса = Запрос.Выполнить();
		
		Если Не РезультатЗапроса.Пустой() Тогда
			ТекстОшибки = НСтр("ru = 'Документ уже использован в документах ввода остатков, изменение невозможно';
								|en = 'The document is already used in balance entry documents. Cannot change the document.'");
			ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, Ссылка, , , Отказ);
		КонецЕсли;
		
	КонецЕсли;
	
	//++ НЕ УТ
	Если ТипЗнч(Договор) <> Тип("СправочникСсылка.ДоговорыАренды") Тогда
	//-- НЕ УТ
	ВзаиморасчетыСервер.ПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи);
	//++ НЕ УТ
	КонецЕсли;
	//-- НЕ УТ
	
	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПроведениеДокументов.ПриЗаписиДокумента(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Реквизиты = Документы.ПервичныйДокумент.МассивРеквизитовПоТипуПервичногоДокумента(ТипПервичногоДокумента);
	ОбщегоНазначенияУТКлиентСервер.ЗаполнитьМассивНепроверяемыхРеквизитов(
		Реквизиты.МассивВсехРеквизитов,
		Реквизиты.МассивРеквизитовДляТипа,
		МассивНепроверяемыхРеквизитов);
	
	Если ПорядокРасчетов <> Перечисления.ПорядокРасчетов.ПоДоговорамКонтрагентов
		И Не ТипПервичногоДокумента = Перечисления.ТипыПервичныхДокументов.ПриемНаХранение Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Договор");
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(НомерВходящегоДокумента)
		И НЕ ЗначениеЗаполнено(ДатаВходящегоДокумента) Тогда
		МассивНепроверяемыхРеквизитов.Добавить("НомерВходящегоДокумента");
		МассивНепроверяемыхРеквизитов.Добавить("ДатаВходящегоДокумента");
	КонецЕсли; 
	
	// Если номер не был заполнен вручную по данным прошлой системы, то будет сгенерирован автоматически.
	МассивНепроверяемыхРеквизитов.Добавить("Номер"); 
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(
		ПроверяемыеРеквизиты,
		МассивНепроверяемыхРеквизитов);
	
	Если ЗначениеЗаполнено(Организация) И Организация = Контрагент Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Организация и контрагент не должны совпадать';
				|en = 'Company and counterparty should not match'"),
			ЭтотОбъект,
			"Контрагент",
			,
			Отказ);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)

	ПроведениеДокументов.ОбработкаПроведенияДокумента(ЭтотОбъект, Отказ);
	
	Если Не ТипПервичногоДокумента = Перечисления.ТипыПервичныхДокументов.ПриемНаХранение Тогда
		ПараметрыРегистрации = Документы.ПервичныйДокумент.ПараметрыРегистрацииСчетовФактурПолученных(ЭтотОбъект);
		УчетНДСУП.АктуализироватьСчетаФактурыПолученныеПриПроведении(ПараметрыРегистрации);
	КонецЕсли;
	Если ТипПервичногоДокумента = Перечисления.ТипыПервичныхДокументов.РеализацияКлиенту Тогда
		ПараметрыРегистрации = Документы.ПервичныйДокумент.ПараметрыРегистрацииСчетовФактурВыданных(ЭтотОбъект);
		УчетНДСУП.АктуализироватьСчетаФактурыВыданныеПриПроведении(ПараметрыРегистрации);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)

	ПроведениеДокументов.ОбработкаУдаленияПроведенияДокумента(ЭтотОбъект, Отказ);
	
	Если Не ТипПервичногоДокумента = Перечисления.ТипыПервичныхДокументов.ПриемНаХранение Тогда
		ПараметрыРегистрации = Документы.ПервичныйДокумент.ПараметрыРегистрацииСчетовФактурПолученных(ЭтотОбъект);
		УчетНДСУП.АктуализироватьСчетаФактурыПолученныеПриУдаленииПроведения(ПараметрыРегистрации);
	КонецЕсли;
	Если ТипПервичногоДокумента = Перечисления.ТипыПервичныхДокументов.РеализацияКлиенту Тогда
		ПараметрыРегистрации = Документы.ПервичныйДокумент.ПараметрыРегистрацииСчетовФактурВыданных(ЭтотОбъект);
		УчетНДСУП.АктуализироватьСчетаФактурыВыданныеПриУдаленииПроведения(ПараметрыРегистрации);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ИнициализироватьДокумент(ДанныеЗаполнения)
	
	ДанныеЗаполненияЭтоСтруктура = (ТипЗнч(ДанныеЗаполнения) = Тип("Структура"));
	
	Если ДанныеЗаполненияЭтоСтруктура И ДанныеЗаполнения.Свойство("Организация") Тогда
		Если (ТипЗнч(ДанныеЗаполнения.Организация) = Тип("ФиксированныйМассив")
				Или ТипЗнч(ДанныеЗаполнения.Организация) = Тип("Массив"))
			И ДанныеЗаполнения.Организация.Количество() > 0 Тогда
			Организация = ДанныеЗаполнения.Организация[0];
		Иначе
			Организация = ДанныеЗаполнения.Организация;
		КонецЕсли;
	Иначе
		Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	КонецЕсли;
	
	Если НЕ ДанныеЗаполненияЭтоСтруктура ИЛИ НЕ ДанныеЗаполнения.Свойство("Контрагент") Тогда
		Контрагент = Справочники.Контрагенты.ПустаяСсылка();
	КонецЕсли;
	
	Если НЕ ДанныеЗаполненияЭтоСтруктура ИЛИ НЕ ДанныеЗаполнения.Свойство("Договор") Тогда
		Если ДанныеЗаполненияЭтоСтруктура 
			И ДанныеЗаполнения.Свойство("Партнер")
			И ДанныеЗаполнения.Партнер = Справочники.Партнеры.НашеПредприятие Тогда
			Договор = Справочники.ДоговорыМеждуОрганизациями.ПустаяСсылка();
		Иначе
			Договор = Справочники.ДоговорыКонтрагентов.ПустаяСсылка();
		КонецЕсли;
	КонецЕсли;
	
	Если НЕ ДанныеЗаполненияЭтоСтруктура ИЛИ НЕ ДанныеЗаполнения.Свойство("Валюта") Тогда
		Если Не ЗначениеЗаполнено(Валюта) Тогда
			Валюта = ЗначениеНастроекПовтИсп.ВалютаРегламентированногоУчетаОрганизации(Организация);
		КонецЕсли;
	КонецЕсли;
	
	Если ДанныеЗаполненияЭтоСтруктура
		И ДанныеЗаполнения.Свойство("Договор") Тогда
		ЗаполнитьЗначенияСвойств(
			ЭтотОбъект,
			ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
				ДанныеЗаполнения.Договор,
				"Подразделение, НаправлениеДеятельности, НалогообложениеНДС, ГруппаФинансовогоУчета"));
	КонецЕсли;
	
	Если ДанныеЗаполненияЭтоСтруктура И ДанныеЗаполнения.Свойство("Номер") Тогда
		Номер = ДанныеЗаполнения.Номер;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
