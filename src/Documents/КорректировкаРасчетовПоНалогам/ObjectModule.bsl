#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	Ответственный = Пользователи.ТекущийПользователь(); 
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") 
		И ДанныеЗаполнения.Свойство("РасшифровкаНалогов") Тогда 
			
			СтрокаРасшифровки = РасшифровкаНалогов.Добавить(); 
			ЗаполнитьЗначенияСвойств(СтрокаРасшифровки, ДанныеЗаполнения.РасшифровкаНалогов);
			
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ОписаниеЗамера = ОценкаПроизводительности.НачатьЗамерДлительнойОперации("ПроведениеКорректировкаРасчетовПоНалогам");
	ДополнительныеСвойства.Вставить("ОписаниеЗамера", ОписаниеЗамера);
	
	ПроведениеДокументов.ПередЗаписьюДокумента(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	
	СуммаДокумента = РасшифровкаНалогов.Итог("Сумма");
	
	ОбщегоНазначенияУТ.ЗаполнитьИдентификаторыДокумента(ЭтотОбъект, "РасшифровкаНалогов");
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПроведениеДокументов.ПриЗаписиДокумента(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеДокументов.ОбработкаПроведенияДокумента(ЭтотОбъект, Отказ);
	
	ОписаниеЗамера = Неопределено;
	Если ДополнительныеСвойства.Свойство("ОписаниеЗамера", ОписаниеЗамера) Тогда
		ОценкаПроизводительности.ЗакончитьЗамерДлительнойОперации(ОписаниеЗамера, 1);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеДокументов.ОбработкаУдаленияПроведенияДокумента(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если Не ПлатежиВБюджет.ИспользуетсяЕдиныйНалоговыйПлатеж(Организация, Дата) Тогда
		ТекстСообщения = СтрШаблон(
			НСтр("ru = 'Организация %1 не является плательщиком единого налогового платежа';
				|en = '%1 company is not a unified tax payer'"),
			Организация);
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, , "Организация", "Объект", Отказ);
		Возврат;
	КонецЕсли;
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если ВидОперации = Перечисления.ВидыОперацийПоЕдиномуНалоговомуСчету.КорректировкаСчета Тогда
		МассивНепроверяемыхРеквизитов.Добавить("РасшифровкаНалогов.ТипНалога");
		МассивНепроверяемыхРеквизитов.Добавить("РасшифровкаНалогов.КодБК");
		МассивНепроверяемыхРеквизитов.Добавить("РасшифровкаНалогов.СрокУплаты");
		МассивНепроверяемыхРеквизитов.Добавить("РасшифровкаНалогов.ВидПлатежа");
	ИначеЕсли ВидОперации = Перечисления.ВидыОперацийПоЕдиномуНалоговомуСчету.НачислениеПенейШтрафов Тогда
		МассивНепроверяемыхРеквизитов.Добавить("РасшифровкаНалогов.ТипНалога");
		МассивНепроверяемыхРеквизитов.Добавить("РасшифровкаНалогов.КодБК");
		МассивНепроверяемыхРеквизитов.Добавить("РасшифровкаНалогов.СрокУплаты");
		МассивНепроверяемыхРеквизитов.Добавить("РасшифровкаНалогов.ПлатежныйДокумент");
		МассивНепроверяемыхРеквизитов.Добавить("РасшифровкаНалогов.ВидДвижения");
	ИначеЕсли ВидОперации = Перечисления.ВидыОперацийПоЕдиномуНалоговомуСчету.ПогашениеПенейШтрафов Тогда
		МассивНепроверяемыхРеквизитов.Добавить("РасшифровкаНалогов.ТипНалога");
		МассивНепроверяемыхРеквизитов.Добавить("РасшифровкаНалогов.КодБК");
		МассивНепроверяемыхРеквизитов.Добавить("РасшифровкаНалогов.СрокУплаты");
		МассивНепроверяемыхРеквизитов.Добавить("РасшифровкаНалогов.ВидДвижения");
		МассивНепроверяемыхРеквизитов.Добавить("РасшифровкаНалогов.СчетУчета");
	ИначеЕсли ВидОперации = Перечисления.ВидыОперацийПоЕдиномуНалоговомуСчету.НачислениеНалогов Тогда
		МассивНепроверяемыхРеквизитов.Добавить("РасшифровкаНалогов.ВидПлатежа");
		МассивНепроверяемыхРеквизитов.Добавить("РасшифровкаНалогов.ВидДвижения");
		МассивНепроверяемыхРеквизитов.Добавить("РасшифровкаНалогов.ПлатежныйДокумент");
	ИначеЕсли ВидОперации = Перечисления.ВидыОперацийПоЕдиномуНалоговомуСчету.УплатаНалогов Тогда
		МассивНепроверяемыхРеквизитов.Добавить("РасшифровкаНалогов.ВидПлатежа");
		МассивНепроверяемыхРеквизитов.Добавить("РасшифровкаНалогов.ВидДвижения");
	КонецЕсли;

	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
	Если Не Отказ И ОбщегоНазначенияУТ.ПроверитьЗаполнениеРеквизитовОбъекта(ЭтотОбъект, ПроверяемыеРеквизиты) Тогда
		Отказ = Истина;
	КонецЕсли;
	
	Если ВидОперации = Перечисления.ВидыОперацийПоЕдиномуНалоговомуСчету.НачислениеНалогов
		ИЛИ ВидОперации = Перечисления.ВидыОперацийПоЕдиномуНалоговомуСчету.УплатаНалогов Тогда
		
		РегистрацияОрганизацииВНО = Справочники.РегистрацииВНалоговомОргане.РегистрацияВНалоговомОргане(Организация, Дата);
		Если НЕ ЗначениеЗаполнено(РегистрацияОрганизацииВНО) Тогда
			ТекстСообщения = СтрШаблон(
				НСтр("ru = 'Для организации %1 на дату документа не указана основная регистрация в налоговом органе';
					|en = 'For the %1 company, the main registration with the tax authority is not specified as of the document date'"),
				Организация);
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, , "Организация", "Объект", Отказ);
		КонецЕсли;
		
		Для Каждого ЭлементСписка Из СписокИспользуемыхРегистрацийВНО(РегистрацияОрганизацииВНО) Цикл
			
			Если ЗначениеЗаполнено(ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ЭлементСписка.Значение, "КодПоОКТМО")) Тогда
				Продолжить;
			КонецЕсли;
			
			ТекстСообщения = СтрШаблон(
				НСтр("ru = 'Для регистрации в налоговом органе %1 не указан код по ОКТМО';
					|en = 'For registration with the %1 tax authority, the RNCMT code is required'"),
				ЭлементСписка.Значение);
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, , ЭлементСписка.Представление, "Объект", Отказ);
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция СписокИспользуемыхРегистрацийВНО(Знач ОсновнаяРегистрация)
	
	СписокРегистраций = Новый СписокЗначений;
	Для Каждого СтрокаТаблицы Из РасшифровкаНалогов Цикл
		
		Если ТипЗнч(СтрокаТаблицы.Субконто1) = Тип("СправочникСсылка.РегистрацииВНалоговомОргане") И ЗначениеЗаполнено(СтрокаТаблицы.Субконто1) Тогда
			ПутьКДанным = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("РасшифровкаНалогов", СтрокаТаблицы.НомерСтроки, "Субконто1");
			РегистрацияВНО = СтрокаТаблицы.Субконто1;
		ИначеЕсли ТипЗнч(СтрокаТаблицы.Субконто2) = Тип("СправочникСсылка.РегистрацииВНалоговомОргане") И ЗначениеЗаполнено(СтрокаТаблицы.Субконто2) Тогда
			ПутьКДанным = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("РасшифровкаНалогов", СтрокаТаблицы.НомерСтроки, "Субконто2");
			РегистрацияВНО = СтрокаТаблицы.Субконто2;
		ИначеЕсли ТипЗнч(СтрокаТаблицы.Субконто3) = Тип("СправочникСсылка.РегистрацииВНалоговомОргане") И ЗначениеЗаполнено(СтрокаТаблицы.Субконто3) Тогда
			ПутьКДанным = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("РасшифровкаНалогов", СтрокаТаблицы.НомерСтроки, "Субконто3");
			РегистрацияВНО = СтрокаТаблицы.Субконто3;
		Иначе
			РегистрацияВНО = ОсновнаяРегистрация;
			ПутьКДанным = "Организация";
		КонецЕсли;
		
		Если ЗначениеЗаполнено(РегистрацияВНО) И СписокРегистраций.НайтиПоЗначению(РегистрацияВНО) = Неопределено Тогда
			СписокРегистраций.Добавить(РегистрацияВНО, ПутьКДанным);
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат СписокРегистраций;
	
КонецФункции

#КонецОбласти

#КонецЕсли