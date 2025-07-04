#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	ИнтеграцияИСМППереопределяемый.ОбработкаЗаполненияДокумента(ЭтотОбъект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка);
	ЗаполнитьОбъектПоСтатистике();
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	ИнтеграцияИСПереопределяемый.ПередЗаписьюОбъекта(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если Операция = Перечисления.ВидыОперацийИСМП.ОтчетИСМПСведенияОбОтклонениях Тогда
		
		МассивНепроверяемыхРеквизитов.Добавить("СтатусКодаМаркировки");
		
		РазностьДатВДнях = Документы.ОтчетИСМП.РазностьДатВДнях(НачалоДня(ДатаВыгрузкиНачалоПериода),НачалоДня(ДатаВыгрузкиКонецПериода));
		Если РазностьДатВДнях > 90 Тогда
			
			ОбщегоНазначения.СообщитьПользователю(
				СтрШаблон(
					НСтр("ru = 'Указан некорректный период выгрузки: %1 дней.
					           |Максимальный интервал не более 91 дня.';
					           |en = 'Указан некорректный период выгрузки: %1 дней.
					           |Максимальный интервал не более 91 дня.'"),
					Строка(РазностьДатВДнях)),
				Ссылка,,
				"ПериодДатаВыгрузки",
				Отказ);
			
		КонецЕсли;
		
	Иначе
		
		МассивНепроверяемыхРеквизитов.Добавить("ДатаВыгрузкиНачалоПериода");
		МассивНепроверяемыхРеквизитов.Добавить("ДатаВыгрузкиКонецПериода");
		
	КонецЕсли;
	
	ИнтеграцияИСМППереопределяемый.ПриОпределенииОбработкиПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбменДаннымиИСМП.ЗаписатьСтатусДокументаПоУмолчанию(ЭтотОбъект);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	КодыНаБалансе.Очистить();
	СведенияОбОтклонениях.Очистить();
	
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

#Область ОбработкаЗаполнения

Процедура ЗаполнитьОбъектПоСтатистике()
	
	ДанныеСтатистики = ЗаполнениеОбъектовПоСтатистикеИСМП.ДанныеЗаполненияОтчетИСМП(Организация);
	
	Для Каждого КлючИЗначение Из ДанныеСтатистики Цикл
		ЗаполнениеОбъектовПоСтатистикеИСМП.ЗаполнитьПустойРеквизит(ЭтотОбъект, ДанныеСтатистики, КлючИЗначение.Ключ);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
