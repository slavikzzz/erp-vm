///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)

	// Проверка должна находиться в самом начале процедуры.
	// Это необходимо для того, чтобы никакая бизнес-логика объекта не выполнялась при записи объекта через механизм обмена данными,
	//  поскольку она уже была выполнена для объекта в том узле, где он был создан.
	// В этом случае все данные загружаются в ИБ "как есть", без искажений (изменений),
	//  проверок или каких-либо других дополнительных действий, препятствующих загрузке данных.
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	// В идентификаторе (Код) допустимы только английские символы, подчеркивания, минус и числа.
	РазрешенныеСимволы = ОбработкаНовостейКлиентСервер.РазрешенныеДляИдентификацииСимволы();
	СписокЗапрещенныхСимволов = ОбработкаНовостейСлужебный.ПроверитьСтрокуНаЗапрещенныеСимволы(
		СокрЛП(Код),
		РазрешенныеСимволы);

	Если СписокЗапрещенныхСимволов.Количество() > 0 Тогда
		Отказ = Истина;
		Сообщение = Новый СообщениеПользователю;
		Сообщение.УстановитьДанные(ЭтотОбъект);
		Сообщение.Поле = "Код";
		Сообщение.ПутьКДанным = "Объект";
		Сообщение.Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'В идентификаторе присутствуют запрещенные символы: %1.
				|Разрешено использовать цифры, английские буквы, подчеркивание и минус.';
				|en = 'There are prohibited characters in ID: %1.
				|You can use digits, English letters, underline, and minus.'"),
			СписокЗапрещенныхСимволов);
		Сообщение.Сообщить();
	КонецЕсли;

КонецПроцедуры

Процедура ПередЗаписью(Отказ)

	// Проверка должна находиться в самом начале процедуры.
	// Это необходимо для того, чтобы никакая бизнес-логика объекта не выполнялась при записи объекта через механизм обмена данными,
	//  поскольку она уже была выполнена для объекта в том узле, где он был создан.
	// В этом случае все данные загружаются в ИБ "как есть", без искажений (изменений),
	//  проверок или каких-либо других дополнительных действий, препятствующих загрузке данных.
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	Код          = СокрЛП(Код);
	Наименование = СокрЛП(Наименование);

КонецПроцедуры

#КонецОбласти

#КонецЕсли