#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ИсправлениеДокументов.ПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	ПроведениеДокументов.ПередЗаписьюДокумента(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	ОбщегоНазначенияУТ.ЗаполнитьИдентификаторыДокумента(	ЭтотОбъект, "НДСПредъявленный");
	
	ВводОстатковЛокализация.ВводОстатковНДСПредъявленногоПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеДокументов.ОбработкаПроведенияДокумента(ЭтотОбъект, Отказ);
	
	ВводОстатковЛокализация.ВводОстатковНДСПредъявленногоОбработкаПроведения(ЭтотОбъект, Отказ, РежимПроведения);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеДокументов.ОбработкаУдаленияПроведенияДокумента(ЭтотОбъект, Отказ);
	
	ВводОстатковЛокализация.ВводОстатковНДСПредъявленногоОбработкаУдаленияПроведения(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)

	Если Не ОтражатьВОперативномУчете И Не ОтражатьВБУиНУ И Не ОтражатьВУУ Тогда
		ТекстСообщения = НСтр("ru = 'Операция должна отражаться в одном из учетов';
								|en = 'The operation must be recorded in one of accounting types'");
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, , 
			"Объект.ОтражатьВОперативномУчете", , Отказ);
	КонецЕсли;
	
	ИсправлениеДокументов.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	
	ВводОстатковЛокализация.ВводОстатковНДСПредъявленногоОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Ответственный = Пользователи.ТекущийПользователь();
	ИнициализироватьДокумент(ДанныеЗаполнения);
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка." + Метаданные().Имя) Тогда
		
		ИсправлениеДокументов.ЗаполнитьИсправление(ЭтотОбъект, ДанныеЗаполнения);
		
	КонецЕсли;
	
	ВводОстатковЛокализация.ВводОстатковНДСПредъявленногоОбработкаЗаполнения(ЭтотОбъект, ДанныеЗаполнения, СтандартнаяОбработка);
	
	ПараметрыЗаполнения = Документы.ВводОстатковНДСПредъявленного.ИнициализироватьПараметрыВидовДеятельностиНДС(ЭтотОбъект);
	УчетНДСУП.ЗаполнитьВидДеятельностиНДС(ВидДеятельностиНДС, ПараметрыЗаполнения);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ИсправлениеДокументов.ПриКопировании(ЭтотОбъект, ОбъектКопирования);
	
	ОбщегоНазначенияУТ.ОчиститьИдентификаторыДокумента(ЭтотОбъект, "НДСПредъявленный");
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("СкорректироватьСтавкуНДС", ОбработкаТабличнойЧастиКлиентСервер.ПараметрыЗаполненияСтавкиНДС(ЭтотОбъект));
	ОбработкаТабличнойЧастиСервер.ОбработатьТЧ(НДСПредъявленный, СтруктураДействий, Неопределено);
	
	Для Каждого Строка Из НДСПредъявленный Цикл
		ТекПроцентНДС = УчетНДСУПКлиентСервер.ЗначениеСтавкиНДС(Строка.СтавкаНДС);
		Если ТекПроцентНДС <> 0 Тогда
			Строка.СуммаБезНДС = Строка.НДС * 100 / ТекПроцентНДС;
		КонецЕсли;
	КонецЦикла;
	
	ВводОстатковЛокализация.ВводОстатковНДСПредъявленногоПриКопировании(ЭтотОбъект, ОбъектКопирования);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)

	Если ОбменДанными.Загрузка Тогда
		Возврат
	КонецЕсли;
	
	ПроведениеДокументов.ПриЗаписиДокумента(ЭтотОбъект, Отказ);
	
	ВводОстатковЛокализация.ВводОстатковНДСПредъявленногоПриЗаписи(ЭтотОбъект, Отказ);

КонецПроцедуры

Процедура ПередУдалением(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат
	КонецЕсли;
	
	ВводОстатковЛокализация.ВводОстатковНДСПредъявленногоПередУдалением(ЭтотОбъект, Отказ);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ИнициализацияИЗаполнение

Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено)

	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций") Тогда
		Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Валюта) Тогда
		Валюта = ЗначениеНастроекПовтИсп.ВалютаРегламентированногоУчетаОрганизации(Организация);
	КонецЕсли;
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		
		Если ДанныеЗаполнения.Свойство("Комментарий") Тогда
			Комментарий = ДанныеЗаполнения.Комментарий;
		КонецЕсли;
		
		Если ДанныеЗаполнения.Свойство("ЗначениеКопирования") Тогда
			ВводОстатковСервер.ЗаполнитьЗначенияПоСтаромуВводуОстатков(ЭтотОбъект, ДанныеЗаполнения.ЗначениеКопирования);
		КонецЕсли;
		
	КонецЕсли;
	
	ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВводОстатковНДСПоПриобретеннымЦенностям;
	ПараметрыЗаполнения = Документы.ВводОстатковНДСПредъявленного.ИнициализироватьПараметрыВидовДеятельностиНДС(ЭтотОбъект);
	УчетНДСУП.ЗаполнитьВидДеятельностиНДС(ВидДеятельностиНДС, ПараметрыЗаполнения);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
