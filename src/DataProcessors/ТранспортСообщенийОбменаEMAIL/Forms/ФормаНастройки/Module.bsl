///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2025, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ТранспортСообщенийОбмена.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
	УстановитьВидимостьДоступность();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СжиматьФайлИсходящегоСообщенияПриИзменении(Элемент)
	УстановитьВидимостьДоступность();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Готово(Команда)
	
	Если ПроверитьЗаполнение() Тогда
		
		РезультатЗакрытия = РезультатЗакрытияНаСервере();
		Закрыть(РезультатЗакрытия);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьПодключение(Команда)
	
	ПодключениеУстановлено = Ложь;
	ПроверитьПодключениеНаСервере(ПодключениеУстановлено);
		
	ТекстПредупреждения = ?(ПодключениеУстановлено, НСтр("ru = 'Подключение успешно установлено.';
														|en = 'Connection established.'"),
								НСтр("ru = 'Не удалось установить подключение.';
									|en = 'Cannot establish connection.'"));
								
	ПоказатьПредупреждение(, ТекстПредупреждения);
	
КонецПроцедуры


#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция РезультатЗакрытияНаСервере()
	
	Возврат ТранспортСообщенийОбмена.РезультатЗакрытияФормыТранспорта(ЭтаФорма);
	
КонецФункции

&НаСервере
Процедура ПроверитьПодключениеНаСервере(ПодключениеУстановлено)
	
	УстановитьПривилегированныйРежим(Истина);
	
	ОбработкаОбъект = РеквизитФормыВЗначение("Объект");
		
	// Заполним пароль.
	ТранспортСообщенийОбмена.ЗаполнитьНастройкиИзБезопасногоХранилищаДляФормы(ЭтаФорма, ОбработкаОбъект);
	
	// Выполняем проверку подключения.
	ПодключениеУстановлено = ОбработкаОбъект.ПодключениеУстановлено();
	Если Не ПодключениеУстановлено Тогда
		
		Отказ = Истина;
		
		СообщениеОбОшибке = ОбработкаОбъект.СообщениеОбОшибке
			+ Символы.ПС + НСтр("ru = 'Техническую информацию об ошибке см. в журнале регистрации.';
								|en = 'See the event log for details.'");
		
		ОбщегоНазначения.СообщитьПользователю(СообщениеОбОшибке, , , , Отказ);
		
	КонецЕсли;
		
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьДоступность()
	Элементы.ПарольАрхиваСообщенияОбмена.Доступность = Объект.СжиматьФайлИсходящегоСообщения;
КонецПроцедуры

#КонецОбласти

