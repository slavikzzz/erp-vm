///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)

	М = ПланыВидовХарактеристик.КатегорииНовостей; // М = Менеджер.

	// Для категорий "Product", "ProductVersion", "PlatformVersion" должно быть одно из: eq ne lt le gt ge.
	// Во всех остальных случаях установить eq.
	Для каждого ТекущаяЗапись Из ЭтотОбъект Цикл
		Если ТекущаяЗапись.КатегорияНовостей = М.КатегорияПродукт()
				ИЛИ ТекущаяЗапись.КатегорияНовостей = М.КатегорияВерсияПродукта()
				ИЛИ ТекущаяЗапись.КатегорияНовостей = М.КатегорияВерсияПлатформы() Тогда
			Если НРег(ТекущаяЗапись.УсловиеОтбора) = НРег("eq")
					ИЛИ НРег(ТекущаяЗапись.УсловиеОтбора) = НРег("ne")
					ИЛИ НРег(ТекущаяЗапись.УсловиеОтбора) = НРег("lt")
					ИЛИ НРег(ТекущаяЗапись.УсловиеОтбора) = НРег("le")
					ИЛИ НРег(ТекущаяЗапись.УсловиеОтбора) = НРег("gt")
					ИЛИ НРег(ТекущаяЗапись.УсловиеОтбора) = НРег("ge") Тогда
				// Все нормально.
			Иначе
				ТекущаяЗапись.УсловиеОтбора = "eq";
			КонецЕсли;
		Иначе
			ТекущаяЗапись.УсловиеОтбора = "eq";
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры

Процедура ПередЗаписью(Отказ, Замещение)

	// Проверка должна находиться в самом начале процедуры.
	// Это необходимо для того, чтобы никакая бизнес-логика объекта не выполнялась при записи объекта через механизм обмена данными,
	//  поскольку она уже была выполнена для объекта в том узле, где он был создан.
	// В этом случае все данные загружаются в ИБ "как есть", без искажений (изменений),
	//  проверок или каких-либо других дополнительных действий, препятствующих загрузке данных.
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	М = ПланыВидовХарактеристик.КатегорииНовостей; // М = Менеджер.

	Для каждого ТекущаяЗапись Из ЭтотОбъект Цикл

		// Для категорий "Product", "ProductVersion", "PlatformVersion" должно быть одно из: eq ne lt le gt ge.
		// Во всех остальных случаях установить eq.
		Если ТекущаяЗапись.КатегорияНовостей = М.КатегорияПродукт() Тогда
			Если НРег(ТекущаяЗапись.УсловиеОтбора) = НРег("eq")
					ИЛИ НРег(ТекущаяЗапись.УсловиеОтбора) = НРег("ne")
					ИЛИ НРег(ТекущаяЗапись.УсловиеОтбора) = НРег("lt")
					ИЛИ НРег(ТекущаяЗапись.УсловиеОтбора) = НРег("le")
					ИЛИ НРег(ТекущаяЗапись.УсловиеОтбора) = НРег("gt")
					ИЛИ НРег(ТекущаяЗапись.УсловиеОтбора) = НРег("ge") Тогда
				// Все нормально.
			Иначе
				ТекущаяЗапись.УсловиеОтбора = "eq";
			КонецЕсли;
		Иначе
			ТекущаяЗапись.УсловиеОтбора = "eq";
		КонецЕсли;

		// В простых категориях не должно быть "ProductVersion", "PlatformVersion".
		Если ТекущаяЗапись.КатегорияНовостей = М.КатегорияВерсияПродукта()
				ИЛИ ТекущаяЗапись.КатегорияНовостей = М.КатегорияВерсияПлатформы() Тогда
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'В простых категориях не должно быть категории [%1] - она должна быть в категориях интервалов версий.';
					|en = 'Simple categories cannot have the categories [%1]. It must be in the version interval categories.'"),
				ТекущаяЗапись.КатегорияНовостей);
			Сообщение = Новый СообщениеПользователю();
			Сообщение.Текст = ТекстСообщения;
			Сообщение.Сообщить();
			Отказ = Истина;
			ВызватьИсключение ТекстСообщения;
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры

#КонецОбласти

#КонецЕсли