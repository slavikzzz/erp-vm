#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	ИнтеграцияИСМППереопределяемый.ОбработкаЗаполненияДокумента(ЭтотОбъект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка);
	
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
	
	НепроверяемыеРеквизиты = Новый Массив;
	НепроверяемыеРеквизиты.Добавить("КоличествоУпаковок");
	
	Если Не (Операция = Перечисления.ВидыОперацийИСМП.ПриемкаИзЕАЭССПризнаниемКМ
		Или Операция = Перечисления.ВидыОперацийИСМП.ПриемкаИзЕАЭСПриОСУ) Тогда
		НепроверяемыеРеквизиты.Добавить("Товары.КодТНВЭД");
		НепроверяемыеРеквизиты.Добавить("Товары.Цена");
	КонецЕсли;
	
	Если Не ИнтеграцияИСМПСлужебныйКлиентСервер.ТребуетсяУказаниеДатыПроизводстваПриПриемкеОтгрузке(Операция, ВидПродукции) Тогда
		НепроверяемыеРеквизиты.Добавить("Товары.ДатаПроизводства");
	КонецЕсли;
	Если Не ИнтеграцияИСМПСлужебныйКлиентСервер.ТребуетсяУказаниеСрокаГодностиПриПриемкеОтгрузке(Операция, ВидПродукции) Тогда
		НепроверяемыеРеквизиты.Добавить("Товары.СрокГодности");
	КонецЕсли;
	
	НепроверяемыеРеквизиты.Добавить("Товары.ИдентификаторПроисхожденияВЕТИССтрокой");
	Если Не (Операция = Перечисления.ВидыОперацийИСМП.ПриемкаИзЕАЭСПриОСУ
		И ВидПродукции = Перечисления.ВидыПродукцииИС.МолочнаяПродукцияПодконтрольнаяВЕТИС) Тогда
		НепроверяемыеРеквизиты.Добавить("Товары.ИдентификаторПроисхожденияВЕТИС");
	ИначеЕсли Не ИнтеграцияИСМПВЕТИС.ИспользуетсяПодсистемаВетИС() Тогда
		НепроверяемыеРеквизиты.Добавить("Товары.ИдентификаторПроисхожденияВЕТИС");
		ШаблонСообщения = НСтр("ru = 'Не заполнена колонка ""%1"" в строке %2 списка ""Товары""';
								|en = 'Не заполнена колонка ""%1"" в строке %2 списка ""Товары""'");
		Для Каждого СтрокаТовары Из Товары Цикл
			Если Не ЗначениеЗаполнено(СтрокаТовары.ИдентификаторПроисхожденияВЕТИССтрокой) Тогда
				ТекстСообщения = СтрШаблон(ШаблонСообщения, НСтр("ru = 'Идентификатор ВСД';
																|en = 'Идентификатор ВСД'"), СтрокаТовары.НомерСтроки);
				ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,
						ЭтотОбъект,
						ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти(
							"Товары", СтрокаТовары.НомерСтроки, "ИдентификаторПроисхожденияВЕТИССтрокойНаФорме"),,
						Отказ);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	ИнтеграцияИСМППереопределяемый.ПриОпределенииОбработкиПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты, НепроверяемыеРеквизиты);
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, НепроверяемыеРеквизиты);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбменДаннымиИСМП.ЗаписатьСтатусДокументаПоУмолчанию(ЭтотОбъект);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ДокументОснование   = Неопределено;
	ИдентификаторЗаявки = Неопределено;
	ШтрихкодыУпаковок.Очистить();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#КонецОбласти

#КонецЕсли