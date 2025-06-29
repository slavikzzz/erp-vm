
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Определяет настройки начального заполнения элементов
//
// Параметры:
//  Настройки - Структура - настройки заполнения:
//   * ПриНачальномЗаполненииЭлемента - Булево - Если Истина, то для каждого элемента будет
//      вызвана процедура индивидуального заполнения ПриНачальномЗаполненииЭлемента.
Процедура ПриНастройкеНачальногоЗаполненияЭлементов(Настройки) Экспорт
	
	Настройки.ПриНачальномЗаполненииЭлемента = Истина;
	
КонецПроцедуры

// Вызывается при начальном заполнении справочника.
//
// Параметры:
//  КодыЯзыков - Массив - список языков конфигурации. Актуально для мультиязычных конфигураций.
//  Элементы   - ТаблицаЗначений - данные заполнения. Состав колонок соответствует набору реквизитов
//                                 справочника.
//  ТабличныеЧасти - Структура - Ключ - Имя табличной части объекта.
//                               Значение - Выгрузка в таблицу значений пустой табличной части.
//
Процедура ПриНачальномЗаполненииЭлементов(КодыЯзыков, Элементы, ТабличныеЧасти) Экспорт

	#Область ОтклонениеПриПриемкеМерныхТоваров
	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "ОтклонениеПриПриемкеМерныхТоваров";
	Элемент.Наименование = НСтр("ru = 'Отклонение при приемке мерных товаров';
								|en = 'Variance on measured goods receiving'", ОбщегоНазначения.КодОсновногоЯзыка());
	Элемент.ИнициаторОтменыЗаказовПоставщикам = Перечисления.ИнициаторОтменыЗаказовПоставщикам.Поставщик;
	#КонецОбласти

КонецПроцедуры

// Вызывается при начальном заполнении создаваемого элемента.
//
// Параметры:
//  Объект                  - СправочникОбъект.ПричиныОтменыЗаказовПоставщикам - заполняемый объект.
//  Данные                  - СтрокаТаблицыЗначений - данные заполнения.
//  ДополнительныеПараметры - Структура - Дополнительные параметры.
//
Процедура ПриНачальномЗаполненииЭлемента(Объект, Данные, ДополнительныеПараметры) Экспорт
	
	
	
КонецПроцедуры

#КонецОбласти	
	
#Область СлужебныеПроцедурыИФункции

#Область ОбновлениеИнформационнойБазы

// см. ОбновлениеИнформационнойБазыБСП.ПриДобавленииОбработчиковОбновления
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт

	Обработчик = Обработчики.Добавить();
	Обработчик.Процедура = "Справочники.ПричиныОтменыЗаказовПоставщикам.ЗаполнитьЭлементыНачальнымиДанными";
	Обработчик.Версия = "11.5.5.51";
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Идентификатор = Новый УникальныйИдентификатор("90a46ab0-a9ca-4186-a0a5-5d89a8474274");
	Обработчик.ПроцедураЗаполненияДанныхОбновления = "Справочники.ПричиныОтменыЗаказовПоставщикам.ЗарегистрироватьПредопределенныеЭлементыДляОбновления";
	Обработчик.ПроцедураПроверки = "ОбновлениеИнформационнойБазы.ДанныеОбновленыНаНовуюВерсиюПрограммы";
	Обработчик.Комментарий = НСтр("ru = 'Обновление наименований предопределенных элементов.
	|До завершения обработки наименования этих элементов в ряде случаев будет отображаться некорректно.';
	|en = 'Updates the names of predefined items.
	|While the update is in progress, names of predefined items might be displayed incorrectly.'");
	
	Читаемые = Новый Массив;
	Читаемые.Добавить(Метаданные.Справочники.ПричиныОтменыЗаказовПоставщикам.ПолноеИмя());
	Обработчик.ЧитаемыеОбъекты = СтрСоединить(Читаемые, ",");
	
	Изменяемые = Новый Массив;
	Изменяемые.Добавить(Метаданные.Справочники.ПричиныОтменыЗаказовПоставщикам.ПолноеИмя());
	Обработчик.ИзменяемыеОбъекты = СтрСоединить(Изменяемые, ",");
	
	Блокируемые = Новый Массив;
	Блокируемые.Добавить(Метаданные.Справочники.ПричиныОтменыЗаказовПоставщикам.ПолноеИмя());
	Обработчик.БлокируемыеОбъекты = СтрСоединить(Блокируемые, ",");

КонецПроцедуры

Процедура ЗарегистрироватьПредопределенныеЭлементыДляОбновления(Параметры) Экспорт
	
	ОбновлениеИнформационнойБазы.ЗарегистрироватьПредопределенныеЭлементыДляОбновления(Параметры, Метаданные.Справочники.ПричиныОтменыЗаказовПоставщикам);
	
КонецПроцедуры

Процедура ЗаполнитьЭлементыНачальнымиДанными(Параметры) Экспорт
	
	НастройкиЗаполнения = ОбновлениеИнформационнойБазы.НастройкиЗаполнения();
	НастройкиЗаполнения.Реквизиты = "Наименование";
	
	ОбновлениеИнформационнойБазы.ЗаполнитьЭлементыНачальнымиДанными(Параметры, Метаданные.Справочники.ПричиныОтменыЗаказовПоставщикам, НастройкиЗаполнения);
	
КонецПроцедуры

#КонецОбласти

// Заполняет предопределенный элемент справочника "Причины отмены заказов поставщикам".
//
Процедура ЗаполнитьПредопределенныеЭлементы() Экспорт
	
	СправочникОбъект = Справочники.ПричиныОтменыЗаказовПоставщикам.ОтклонениеПриПриемкеМерныхТоваров.ПолучитьОбъект();
	СправочникОбъект.ИнициаторОтменыЗаказовПоставщикам = Перечисления.ИнициаторОтменыЗаказовПоставщикам.Поставщик;
	ОбновлениеИнформационнойБазы.ЗаписатьДанные(СправочникОбъект);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
