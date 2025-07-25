#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Если используется один план счетов, то возвращается ссылка на него.
// Если несколько, то возвращается пустая ссылка.
// 
// Возвращаемое значение:
// 	СправочникСсылка.ПланыСчетовМеждународногоУчета - 
Функция ПланСчетовПоУмолчанию() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 2
	|	ПланыСчетов.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ПланыСчетовМеждународногоУчета КАК ПланыСчетов
	|ГДЕ
	|	НЕ ПланыСчетов.ПометкаУдаления";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Количество = Выборка.Количество();
	Если Количество = 1 Тогда
		Выборка.Следующий();
		Возврат Выборка.Ссылка;
	КонецЕсли;
	
	Возврат Справочники.ПланыСчетовМеждународногоУчета.ПустаяСсылка();
	
КонецФункции

// Возвращает планы счетов, по которым проводки формируются с корреспонденцией
// 
// Возвращаемое значение:
// 	СписокЗначений - 
Функция ПланСчетовСПроводкамиСКорреспонденцией() Экспорт
	
	Результат = Новый СписокЗначений;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПланыСчетов.Ссылка КАК Ссылка,
	|	ПланыСчетов.Наименование КАК Наименование
	|ИЗ
	|	Справочник.ПланыСчетовМеждународногоУчета КАК ПланыСчетов
	|ГДЕ
	|	НЕ ПланыСчетов.ПометкаУдаления
	|	И ПланыСчетов.ВариантФормированияПроводок = ЗНАЧЕНИЕ(Перечисление.ВариантыФормированияПроводок.СКорреспонденцией)";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Результат.Добавить(Выборка.Ссылка, Выборка.Наименование);
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Доступен учет в валюте упр.
// 
// Возвращаемое значение:
//  Булево - Доступен учет в валюте упр
Функция ДоступенУчетВВалютеУпр() Экспорт
	
	ДоступенУчетВВалютеУпр = Истина;
	Если НЕ ПолучитьФункциональнуюОпцию("ПроводкиМеждународногоУчетаПоДаннымОперативного")
 		И ПолучитьФункциональнуюОпцию("ФормироватьПроводкиМеждународногоУчетаПоДаннымРегламентированного")
		И НЕ ПолучитьФункциональнуюОпцию("ВестиУУНаПланеСчетовХозрасчетный") Тогда
		ДоступенУчетВВалютеУпр = Ложь;	
	КонецЕсли;
	
	Возврат ДоступенУчетВВалютеУпр;
	
КонецФункции

// Определяет настройки начального заполнения элементов
//
// Параметры:
//  Настройки - Структура - настройки заполнения:
//   * ПриНачальномЗаполненииЭлемента - Булево - Если Истина, то для каждого элемента будет
//      вызвана процедура индивидуального заполнения ПриНачальномЗаполненииЭлемента.
Процедура ПриНастройкеНачальногоЗаполненияЭлементов(Настройки) Экспорт
	
	Настройки.ПриНачальномЗаполненииЭлемента = Ложь;
	
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

	#Область Международный
	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "Международный";
	Элемент.Наименование = НСтр("ru = 'Международный';
								|en = 'Financial'", ОбщегоНазначения.КодОсновногоЯзыка());
	Элемент.УчетВФункциональнойВалюте = Перечисления.ВидыУчетаВФункциональнойВалюте.ВВалютеРегл;
	Элемент.ВалютаПредставления = Константы.ВалютаУправленческогоУчета.Получить();
	Элемент.СпособУчетаНесобственныхПодконтрольныхЦенностей = Перечисления.СпособыУчетаНесобственныхПодконтрольныхЦенностей.НеОтражаютсяНаСчетах;
	Элемент.ПредставлениеСчетов = Перечисления.ПредставлениеСчетовМеждународногоУчета.ВВидеКодаИНаименования;
	Если ПолучитьФункциональнуюОпцию("ЛокализацияРФ") Тогда
		Элемент.ВариантФормированияПроводок = Перечисления.ВариантыФормированияПроводок.СКорреспонденцией;
		Элемент.ПроводкиБезКорреспонденции = Ложь;
		Элемент.ПроводкиСКорреспонденцией = Истина;
	Иначе
		Элемент.ВариантФормированияПроводок = Перечисления.ВариантыФормированияПроводок.БезКорреспонденции;
		Элемент.ПроводкиБезКорреспонденции = Истина;
		Элемент.ПроводкиСКорреспонденцией = Ложь;
	КонецЕсли;
	#КонецОбласти

КонецПроцедуры

// Возвращает имена блокируемых реквизитов для механизма блокирования реквизитов БСП.
//
// Возвращаемое значение:
//	Массив - имена блокируемых реквизитов.
//
Функция ПолучитьБлокируемыеРеквизитыОбъекта() Экспорт
	
	БлокируемыеРеквизиты = Новый Массив;
	БлокируемыеРеквизиты.Добавить("УчетВФункциональнойВалюте;УчетВФункциональнойВалюте");
	БлокируемыеРеквизиты.Добавить("ВалютаПредставления;ВалютаПредставления");
	БлокируемыеРеквизиты.Добавить("ВариантФормированияПроводок;ВариантФормированияПроводок");
	БлокируемыеРеквизиты.Добавить("СпособУчетаНесобственныхПодконтрольныхЦенностей;СпособУчетаНесобственныхПодконтрольныхЦенностей");
	
	Возврат БлокируемыеРеквизиты;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ОбновлениеИнформационнойБазы

Процедура СоздатьМеждународныйПланСчетовПервыйЗапуск() Экспорт
	
	НачатьТранзакцию();
	
	Попытка
		Блокировка = Новый БлокировкаДанных();
		ЭлементБлокировки = Блокировка.Добавить("Справочник.ПланыСчетовМеждународногоУчета");
		ЭлементБлокировки.УстановитьЗначение("Ссылка", Международный);
		Блокировка.Заблокировать();
		
		МеждународныйПланСчетов = Международный.ПолучитьОбъект();
		Если Не ЗначениеЗаполнено(МеждународныйПланСчетов.Наименование) Тогда
			МеждународныйПланСчетов.Наименование = НСтр("ru = 'Международный';
														|en = 'Financial'", ОбщегоНазначения.КодОсновногоЯзыка()); // строка записывается в ИБ
			МеждународныйПланСчетов.УчетВФункциональнойВалюте = Перечисления.ВидыУчетаВФункциональнойВалюте.ВВалютеРегл;
			МеждународныйПланСчетов.СпособУчетаНесобственныхПодконтрольныхЦенностей = Перечисления.СпособыУчетаНесобственныхПодконтрольныхЦенностей.НеОтражаютсяНаСчетах;
			МеждународныйПланСчетов.ПредставлениеСчетов = Перечисления.ПредставлениеСчетовМеждународногоУчета.ВВидеКодаИНаименования;
			МеждународныйПланСчетов.ВариантФормированияПроводок = Перечисления.ВариантыФормированияПроводок.СКорреспонденцией;
			МеждународныйПланСчетов.ПроводкиСКорреспонденцией = Истина;
			ОбновлениеИнформационнойБазы.ЗаписатьДанные(МеждународныйПланСчетов);
		КонецЕсли;
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		ВызватьИсключение;
		
	КонецПопытки;
	
КонецПроцедуры

// Добавляет в список процедуры-обработчики обновления данных ИБ
// для всех поддерживаемых версий библиотеки или конфигурации.
// Вызывается перед началом обновления данных ИБ для построения плана обновления.
//
//  Обработчики - См. ОбновлениеИнформационнойБазы.НоваяТаблицаОбработчиковОбновления
//
// Пример добавления процедуры-обработчика в список:
//  Обработчик = Обработчики.Добавить();
//  Обработчик.Версия              = "1.1.0.0";
//  Обработчик.Процедура           = "ОбновлениеИБ.ПерейтиНаВерсию_1_1_0_0";
//  Обработчик.МонопольныйРежим    = Ложь;
//
// Параметры:
// 	Обработчики - см. ОбновлениеИнформационнойБазы.НоваяТаблицаОбработчиковОбновления
//
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт

	Обработчик = Обработчики.Добавить();
	Обработчик.Процедура = "Справочники.ПланыСчетовМеждународногоУчета.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	Обработчик.Версия = "2.5.16.4";
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Идентификатор = Новый УникальныйИдентификатор("dc398a05-cb04-5bfa-ae98-cf46918db767");
	Обработчик.Многопоточный = Истина;
	Обработчик.ПроцедураЗаполненияДанныхОбновления = "Справочники.ПланыСчетовМеждународногоУчета.ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию";
	Обработчик.ПроцедураПроверки = "ОбновлениеИнформационнойБазы.ДанныеОбновленыНаНовуюВерсиюПрограммы";
	Обработчик.Комментарий = НСтр("ru = 'Заполняет реквизит ""Представление счетов"" значением ""В виде кода и наименования"".';
									|en = 'Fills the ""Account presentation"" attribute with the ""As code and name"" value.'");
	
	Читаемые = Новый Массив;
	Читаемые.Добавить(Метаданные.Справочники.ПланыСчетовМеждународногоУчета.ПолноеИмя());
	Обработчик.ЧитаемыеОбъекты = СтрСоединить(Читаемые, ",");
	
	Изменяемые = Новый Массив;
	Изменяемые.Добавить(Метаданные.Справочники.ПланыСчетовМеждународногоУчета.ПолноеИмя());
	Обработчик.ИзменяемыеОбъекты = СтрСоединить(Изменяемые, ",");
	
	Блокируемые = Новый Массив;
	Блокируемые.Добавить(Метаданные.Справочники.ПланыСчетовМеждународногоУчета.ПолноеИмя());
	Обработчик.БлокируемыеОбъекты = СтрСоединить(Блокируемые, ",");

КонецПроцедуры

Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ПараметрыВыборки = Параметры.ПараметрыВыборки;
	ПараметрыВыборки.ПолныеИменаОбъектов = "Справочник.ПланыСчетовМеждународногоУчета";
	ПараметрыВыборки.СпособВыборки = ОбновлениеИнформационнойБазы.СпособВыборкиСсылки();
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	ПланыСчетовМеждународногоУчета.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ПланыСчетовМеждународногоУчета КАК ПланыСчетовМеждународногоУчета
	|ГДЕ
	|	ПланыСчетовМеждународногоУчета.ПредставлениеСчетов =
	|		ЗНАЧЕНИЕ(Перечисление.ПредставлениеСчетовМеждународногоУчета.ПустаяСсылка)
	|";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Результат = Запрос.Выполнить();
	
	ПланыСчетовМеждународногоУчета = Результат.Выгрузить().ВыгрузитьКолонку("Ссылка");
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, ПланыСчетовМеждународногоУчета);
	
КонецПроцедуры

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ПолноеИмяОбъекта = "Справочник.ПланыСчетовМеждународногоУчета";
	
	ОбновляемыеДанные = ОбновлениеИнформационнойБазы.ДанныеДляОбновленияВМногопоточномОбработчике(Параметры);
	
	Для каждого ЭлементСправочника Из ОбновляемыеДанные Цикл
		
		НачатьТранзакцию();
		
		Попытка
			
			Блокировка = Новый БлокировкаДанных;
			ЭлементБлокировки = Блокировка.Добавить(ПолноеИмяОбъекта);
			ЭлементБлокировки.УстановитьЗначение("Ссылка", ЭлементСправочника.Ссылка);
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
			Блокировка.Заблокировать();
			
			СправочникОбъект = ЭлементСправочника.Ссылка.ПолучитьОбъект(); // СправочникОбъект.ПланыСчетовМеждународногоУчета
			
			Если СправочникОбъект = Неопределено Тогда
				ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(ЭлементСправочника.Ссылка);
				ЗафиксироватьТранзакцию();
				Продолжить;
			КонецЕсли;
			
			Если НЕ ЗначениеЗаполнено(СправочникОбъект.ПредставлениеСчетов) Тогда
				СправочникОбъект.ПредставлениеСчетов = Перечисления.ПредставлениеСчетовМеждународногоУчета.ВВидеКодаИНаименования;
			КонецЕсли;
			
			ОбновлениеИнформационнойБазы.ЗаписатьОбъект(СправочникОбъект);
			
			ЗафиксироватьТранзакцию();
			
		Исключение
			
			ОтменитьТранзакцию();
			ОбновлениеИнформационнойБазыУТ.СообщитьОНеудачнойОбработке(ИнформацияОбОшибке(), ЭлементСправочника.Ссылка);
			
		КонецПопытки;
		
	КонецЦикла;
	
	Параметры.ОбработкаЗавершена = ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(Параметры.Очередь, ПолноеИмяОбъекта);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
