#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);

КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(Ответственный) Тогда
		Ответственный = Пользователи.ТекущийПользователь();
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)

	Если ТипСделки = Перечисления.ТипыСделокСКлиентами.СделкиСРучнымПереходомПоЭтапам
		И ЭтапыСделкиПоПродаже.Количество() = 0 Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Необходимо определить этапы процесса';
				|en = 'Specify the process stages'"),
			ЭтотОбъект,
			"ЭтапыСделкиПоПродаже",
			,
			Отказ);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#КонецЕсли