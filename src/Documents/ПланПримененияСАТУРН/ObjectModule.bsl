
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	ИнтеграцияСАТУРНПереопределяемый.ОбработкаЗаполненияДокумента(ЭтотОбъект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка);
	
	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	
	Если ТипДанныхЗаполнения = Тип("Структура")Тогда
	
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
		
	КонецЕсли;
	
	ЗаполнитьОбъектПоСтатистике();
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	МассивНепроверяемыхРеквизитов.Добавить("Товары.Серия");
	
	Для Каждого СтрокаМестаПрименения Из МестаПрименения Цикл
		
		Если СтрокаМестаПрименения.ТипМестаПрименения = Перечисления.ТипыМестПримененияСАТУРН.ЗарегистрованноеМестоПрименения
			И Не ЗначениеЗаполнено(СтрокаМестаПрименения.МестоПрименения) Тогда
			
			ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'Выберите Место применения из загруженных.';
														|en = 'Выберите Место применения из загруженных.'"),
				ЭтотОбъект,ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти(
					"МестаПрименения", СтрокаМестаПрименения.НомерСтроки, "МестоПрименения"),, Отказ);
			
		КонецЕсли;
		
		Если Не СтрокаМестаПрименения.ТипМестаПрименения = Перечисления.ТипыМестПримененияСАТУРН.ЗарегистрованноеМестоПрименения
			И Не ЗначениеЗаполнено(СтрокаМестаПрименения.ОписаниеМестаПрименения) Тогда
			
			ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'Заполните описание места применения.';
														|en = 'Заполните описание места применения.'"),
				ЭтотОбъект,ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти(
					"МестаПрименения", СтрокаМестаПрименения.НомерСтроки, "ОписаниеМестаПрименения"),, Отказ);
			
		КонецЕсли;
		
		Если Не СтрокаМестаПрименения.ТипМестаПрименения = Перечисления.ТипыМестПримененияСАТУРН.ЗарегистрованноеМестоПрименения
			И СтрДлина(СтрокаМестаПрименения.ОписаниеМестаПрименения) < 10 Тогда
			
			ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'Недостаточное описание места применения. Опишите подробнее.';
														|en = 'Недостаточное описание места применения. Опишите подробнее.'"),
				ЭтотОбъект,ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти(
					"МестаПрименения", СтрокаМестаПрименения.НомерСтроки, "ОписаниеМестаПрименения"),, Отказ);
			
		КонецЕсли;
		
	КонецЦикла;
	
	ТекущееСостояние      = РегистрыСведений.СтатусыДокументовСАТУРН.ТекущееСостояние(Ссылка);
	СтатусыДанныеПереданы = Документы.ПланПримененияСАТУРН.СтатусыДанныеПереданы();
	Если СтатусыДанныеПереданы.Найти(ТекущееСостояние.Статус) <> Неопределено Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Товары.Дозировка");
	КонецЕсли;
	
	ИнтеграцияСАТУРНПереопределяемый.ПриОпределенииОбработкиПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ИдентификаторПоследнейЗаписиТоваров        = 0;
	ИдентификаторПоследнейЗаписиМестПрименения = 0;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ЕСТЬNULL(МАКСИМУМ(ПланПримененияСАТУРНМестаПрименения.Идентификатор), 0) КАК Идентификатор
		|ИЗ
		|	Документ.ПланПримененияСАТУРН.МестаПрименения КАК ПланПримененияСАТУРНМестаПрименения
		|ГДЕ
		|	ПланПримененияСАТУРНМестаПрименения.Ссылка = &Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ЕСТЬNULL(МАКСИМУМ(ПланПримененияСАТУРНТовары.Идентификатор), 0) КАК Идентификатор
		|ИЗ
		|	Документ.ПланПримененияСАТУРН.Товары КАК ПланПримененияСАТУРНТовары
		|ГДЕ
		|	ПланПримененияСАТУРНТовары.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	РезультатЗапроса       = Запрос.ВыполнитьПакет();
	ВыборкаМестаПрименения = РезультатЗапроса[0].Выбрать();
	ВыборкаТовары          = РезультатЗапроса[1].Выбрать();
	
	Если ВыборкаМестаПрименения.Следующий() Тогда
		ИдентификаторПоследнейЗаписиМестПрименения = ВыборкаМестаПрименения.Идентификатор;
	КонецЕсли;
	
	Если ВыборкаТовары.Следующий() Тогда
		ИдентификаторПоследнейЗаписиТоваров = ВыборкаТовары.Идентификатор;
	КонецЕсли;
	
	Для Каждого СтрокаТоваров Из Товары Цикл
		
		Если ЗначениеЗаполнено(СтрокаТоваров.Идентификатор) Тогда
			Продолжить;
		КонецЕсли;
		
		СтрокаТоваров.Идентификатор = ИдентификаторПоследнейЗаписиТоваров + 1;
		ИдентификаторПоследнейЗаписиТоваров = ИдентификаторПоследнейЗаписиТоваров + 1;
		
	КонецЦикла;
	
	Для Каждого СтрокаМестПрименения Из МестаПрименения Цикл
		
		Если ЗначениеЗаполнено(СтрокаМестПрименения.Идентификатор) Тогда
			Продолжить;
		КонецЕсли;
		
		СтрокаМестПрименения.Идентификатор = ИдентификаторПоследнейЗаписиМестПрименения + 1;
		ИдентификаторПоследнейЗаписиМестПрименения = ИдентификаторПоследнейЗаписиМестПрименения + 1;
		
	КонецЦикла;
	
	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	ИнтеграцияИСПереопределяемый.ПередЗаписьюОбъекта(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ИнтеграцияСАТУРН.ЗаписатьСтатусДокументаПоУмолчанию(ЭтотОбъект);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)

	Для Каждого СтрокаТоваров Из Товары Цикл
		
		СтрокаТоваров.Идентификатор = 0;
		
	КонецЦикла;
	
	Для Каждого СтрокаМестПрименения Из МестаПрименения Цикл
		
		СтрокаМестПрименения.Идентификатор = 0;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Инициализация дополнительных свойств для проведения документа
	ИнтеграцияИС.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	
	// Инициализация данных документа
	Документы.ПланПримененияСАТУРН.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	ИнтеграцияИС.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	ИнтеграцияИСПереопределяемый.ОтразитьДвижения(ДополнительныеСвойства, Движения, Отказ);
	
	ИнтеграцияИС.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	ИнтеграцияИСПереопределяемый.ОбработкаПроведения(ЭтотОбъект, Отказ, РежимПроведения);
	
	ИнтеграцияИС.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ОбработкаЗаполнения

Процедура ЗаполнитьОбъектПоСтатистике()
	
	Если ЗначениеЗаполнено(ДокументОснование) Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеСтатистики = ЗаполнениеОбъектовПоСтатистикеСАТУРН.ДанныеЗаполненияПланПримененияСАТУРН(ОрганизацияСАТУРН);
	
	Для Каждого КлючИЗначение Из ДанныеСтатистики Цикл
		ЗаполнениеОбъектовПоСтатистикеСАТУРН.ЗаполнитьПустойРеквизит(ЭтотОбъект, ДанныеСтатистики, КлючИЗначение.Ключ);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
