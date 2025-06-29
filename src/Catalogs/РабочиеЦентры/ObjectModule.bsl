#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);

КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	ПараллельнаяЗагрузка = Ложь;
	ЕстьУчасток = Ложь;
		
	Если НЕ ВидРабочегоЦентра.Пустая() Тогда
		
		СтруктураРеквизитов = Новый Структура;
		СтруктураРеквизитов.Вставить("ПараллельнаяЗагрузка", "ПараллельнаяЗагрузка");
		СтруктураРеквизитов.Вставить("ПодразделениеИспользоватьПроизводственныеУчастки",
			"Подразделение.ИспользоватьПроизводственныеУчастки");
		РеквизитыВидаРЦ = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ВидРабочегоЦентра, СтруктураРеквизитов);
		
		ПараллельнаяЗагрузка = РеквизитыВидаРЦ.ПараллельнаяЗагрузка;
		ЕстьУчасток = РеквизитыВидаРЦ.ПодразделениеИспользоватьПроизводственныеУчастки;
		
	КонецЕсли;
	
	Если НЕ ПараллельнаяЗагрузка Тогда
		МассивНепроверяемыхРеквизитов.Добавить("МаксимальнаяЗагрузка");
	КонецЕсли; 
	
	Если НЕ ЕстьУчасток Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Участок");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") 
		И ДанныеЗаполнения.Свойство("ВидРабочегоЦентра")
		И ЗначениеЗаполнено(ДанныеЗаполнения.ВидРабочегоЦентра)
		И ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДанныеЗаполнения.ВидРабочегоЦентра, "ЭтоГруппа") Тогда
		
		ДанныеЗаполнения.Удалить("ВидРабочегоЦентра");
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли