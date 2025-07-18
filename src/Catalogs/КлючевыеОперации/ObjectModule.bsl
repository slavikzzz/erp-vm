///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПроверитьПриоритет(Отказ);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ХешMD5 = Новый ХешированиеДанных(ХешФункция.MD5);
	ХешMD5.Добавить(Имя);
	ИмяХешТемп = ХешMD5.ХешСумма;
	ИмяХеш = СтрЗаменить(Строка(ИмяХешТемп), " ", "");
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПроверитьПриоритет(Отказ)
	
	Если ДополнительныеСвойства.Свойство(ОценкаПроизводительностиКлиентСервер.НеПроверятьПриоритет()) Или Приоритет = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Приоритет", Приоритет);
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	КлючевыеОперации.Ссылка КАК Ссылка,
	|	КлючевыеОперации.Наименование КАК Наименование
	|ИЗ
	|	Справочник.КлючевыеОперации КАК КлючевыеОперации
	|ГДЕ
	|	КлючевыеОперации.Приоритет = &Приоритет
	|	И КлючевыеОперации.Ссылка <> &Ссылка";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		ТекстСообщения = НСтр("ru = 'Ключевая операция с приоритетом ""%1"" уже существует (%2).';
								|en = 'Key operation priority %1 is not unique (%2 has the same priority).'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%1", Строка(Приоритет));
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%2", Выборка.Наименование);
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Оценка производительности';
										|en = 'Performance monitor'", ОбщегоНазначения.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка,, Выборка.Ссылка, ТекстСообщения);
		ОценкаПроизводительностиСлужебный.СообщитьПользователю(ТекстСообщения);
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	Если Не ОценкаПроизводительностиВызовСервераПовтИсп.ВыполнятьЗамерыПроизводительности() Тогда
		ИндексЦелевоеВремя = ПроверяемыеРеквизиты.Найти("ЦелевоеВремя");
		Если ИндексЦелевоеВремя <> Неопределено Тогда
			ПроверяемыеРеквизиты.Удалить(ИндексЦелевоеВремя);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.';
						|en = 'Invalid object call on the client.'");
#КонецЕсли