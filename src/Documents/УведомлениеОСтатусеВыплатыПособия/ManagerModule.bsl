///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.Печать

// Заполняет список команд печати.
// 
// Параметры:
//  КомандыПечати - см. УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	
КонецПроцедуры

// Формирует печатные формы.
//
// Параметры:
//  МассивОбъектов  - Массив    - ссылки на объекты, которые нужно распечатать;
//  ПараметрыПечати - Структура - дополнительные настройки печати;
//  КоллекцияПечатныхФорм - ТаблицаЗначений - сформированные табличные документы (выходной параметр).
//  ОбъектыПечати         - СписокЗначений  - значение - ссылка на объект;
//                                            представление - имя области в которой был выведен объект (выходной
//                                                            параметр);
//  ПараметрыВывода       - Структура       - дополнительные параметры сформированных табличных документов (выходной
//                                            параметр).
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.Печать

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(ФизическоеЛицо)
	|	И ЗначениеРазрешено(Страхователь)";
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

// СтандартныеПодсистемы.ТекущиеДела

// См. ТекущиеДелаПереопределяемый.ПриОпределенииОбработчиковТекущихДел.
Процедура ПриЗаполненииСпискаТекущихДел(ТекущиеДела) Экспорт
	
	МетаданныеДокумента = ОбъектМетаданных();
	Если Не СЭДОФСС.ДоступенОбменЧерезСЭДО()
		Или Не ПравоДоступа("Изменение", МетаданныеДокумента) Тогда
		Возврат; // Нет прав.
	КонецЕсли;
	
	МодульТекущиеДелаСервер = ОбщегоНазначения.ОбщийМодуль("ТекущиеДелаСервер");
	Разделы = МодульТекущиеДелаСервер.РазделыДляОбъекта(МетаданныеДокумента.ПолноеИмя());
	Если Разделы.Количество() = 0 Тогда
		Возврат; // Некорректное внедрение.
	КонецЕсли;
	
	Требования = ТребованияПоОтправке();
	ВРаботе                  = Требования.Количество();
	ТребуетсяЗагрузить       = Требования.НайтиСтроки(Новый Структура("ТребуетсяЗагрузить", Истина)).Количество();
	ТребуетсяОбработать      = Требования.НайтиСтроки(Новый Структура("ТребуетсяОбработать", Истина)).Количество();
	ТребуетсяПодтвердить     = Требования.НайтиСтроки(Новый Структура("ТребуетсяПодтвердить", Истина)).Количество();
	ИмяДокумента             = МетаданныеДокумента.Имя;
	ПредставлениеСписка      = МетаданныеДокумента.ПредставлениеСписка;
	
	Для Каждого Раздел Из Разделы Цикл
		
		ПолноеИмяРаздела = СтрЗаменить(Раздел.ПолноеИмя(), ".", "_");
		
		Дело = ТекущиеДела.Добавить();
		Дело.Идентификатор  = ИмяДокумента + "_ВРаботе_" + ПолноеИмяРаздела;
		Дело.ЕстьДела       = (ВРаботе > 0);
		Дело.Важное         = (ТребуетсяОбработать > 0);
		Дело.Владелец       = Раздел;
		Дело.Представление  = ПредставлениеСписка;
		Дело.Количество     = ВРаботе;
		Дело.ПараметрыФормы = Новый Структура("ТолькоВРаботе", Истина);
		Дело.Форма          = "Документ.УведомлениеОСтатусеВыплатыПособия.ФормаСписка";
		
		ИдентификаторРодителя = Дело.Идентификатор;
		
		Дело = ТекущиеДела.Добавить();
		Дело.Идентификатор  = ИмяДокумента + "_Загрузить_" + ПолноеИмяРаздела;
		Дело.ЕстьДела       = (ТребуетсяЗагрузить > 0);
		Дело.Важное         = Ложь;
		Дело.Владелец       = ИдентификаторРодителя;
		Дело.Представление  = НСтр("ru = 'Получить новые уведомления';
									|en = 'Получить новые уведомления'");
		Дело.Количество     = ТребуетсяЗагрузить;
		
		Дело = ТекущиеДела.Добавить();
		Дело.Идентификатор  = ИмяДокумента + "_Обработать_" + ПолноеИмяРаздела;
		Дело.ЕстьДела       = (ТребуетсяОбработать > 0);
		Дело.Важное         = Истина;
		Дело.Владелец       = ИдентификаторРодителя;
		Дело.Представление  = НСтр("ru = 'Обработать (от банка получен отказ оплаты)';
									|en = 'Обработать (от банка получен отказ оплаты)'");
		Дело.Количество     = ТребуетсяОбработать;
		
		Дело = ТекущиеДела.Добавить();
		Дело.Идентификатор  = ИмяДокумента + "_Подтвердить_" + ПолноеИмяРаздела;
		Дело.ЕстьДела       = (ТребуетсяПодтвердить > 0);
		Дело.Важное         = Ложь;
		Дело.Владелец       = ИдентификаторРодителя;
		Дело.Представление  = НСтр("ru = 'Подтвердить получение';
									|en = 'Confirm receipt'");
		Дело.Количество     = ТребуетсяПодтвердить;
		
	КонецЦикла;
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ТекущиеДела

#КонецОбласти

#КонецОбласти


#Область СлужебныйПрограммныйИнтерфейс

#Область ОбновлениеИнформационнойБазы

// См. ОбновлениеИнформационнойБазыБСП.ПриДобавленииОбработчиковОбновления.
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия          = "3.1.30.79";
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Идентификатор   = Новый УникальныйИдентификатор("efa80edc-75cd-11ef-8138-4cedfb43b11a");
	Обработчик.Процедура       = "Документы.УведомлениеОСтатусеВыплатыПособия.ПовторноОбработатьСообщения110";
	Обработчик.Комментарий     = НСтр("ru = 'Обработка уведомлений о статусе выплаты пособий.';
										|en = 'Обработка уведомлений о статусе выплаты пособий.'");
	
КонецПроцедуры

// Обработка уведомлений о состоянии пособий.
//
// Параметры:
//   ПараметрыОбновления - Структура - Параметры отложенного обновления.
//
Процедура ПовторноОбработатьСообщения110(ПараметрыОбновления = Неопределено) Экспорт
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВходящиеСообщенияСЭДОФСС.Идентификатор КАК Идентификатор,
	|	ВходящиеСообщенияСЭДОФСС.Организация КАК Организация,
	|	ВходящиеСообщенияСЭДОФСС.Содержимое КАК Содержимое,
	|	ВходящиеСообщенияСЭДОФСС.Дата КАК Дата,
	|	ВходящиеСообщенияСЭДОФСС.ДатаЗагрузки КАК ДатаЗагрузки,
	|	ВходящиеСообщенияСЭДОФСС.ДатаСоздания КАК ДатаСоздания
	|ИЗ
	|	РегистрСведений.ВходящиеСообщенияСЭДОФСС КАК ВходящиеСообщенияСЭДОФСС
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.УведомлениеОСтатусеВыплатыПособия КАК Шапка
	|		ПО ВходящиеСообщенияСЭДОФСС.Идентификатор = Шапка.ИдентификаторСообщения
	|ГДЕ
	|	ВходящиеСообщенияСЭДОФСС.Тип = 110
	|	И Шапка.Ссылка ЕСТЬ NULL
	|	И НЕ ВходящиеСообщенияСЭДОФСС.Новое
	|
	|УПОРЯДОЧИТЬ ПО
	|	Дата,
	|	ДатаЗагрузки,
	|	ДатаСоздания";
	
	Таблица = Новый ТаблицаЗначений;
	Таблица.Колонки.Добавить("ИдентификаторСообщения", ОбщегоНазначения.ОписаниеТипаСтрока(36));
	Таблица.Колонки.Добавить("СтатусВыплаты", ОбщегоНазначения.ОписаниеТипаЧисло(2));
	Таблица.Колонки.Добавить("НомерПроцесса", ОбщегоНазначения.ОписаниеТипаЧисло(15));
	Таблица.Колонки.Добавить("ИдентификаторСтрокиРеестра", ОбщегоНазначения.ОписаниеТипаСтрока(50));
	Таблица.Колонки.Добавить("ИдентификаторРеестра", ОбщегоНазначения.ОписаниеТипаСтрока(50));
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ТекстXML = Выборка.Содержимое.Получить();
		Если Не ЗначениеЗаполнено(ТекстXML) Тогда
			Продолжить;
		КонецЕсли;
		Документ = Документы.УведомлениеОСтатусеВыплатыПособия.СтруктураСообщения110(ТекстXML);
		
		СтрокаТаблицы = Таблица.Добавить();
		СтрокаТаблицы.ИдентификаторСообщения = Выборка.Идентификатор;
		СтрокаТаблицы.СтатусВыплаты = Документ.СтатусВыплаты;
		СтрокаТаблицы.НомерПроцесса = Документ.НомерПроцесса;
		СтрокаТаблицы.ИдентификаторСтрокиРеестра = Документ.ИдентификаторСтрокиРеестра;
		СтрокаТаблицы.ИдентификаторРеестра = Документы.УведомлениеОСтатусеВыплатыПособия.ИдентификаторРеестра(
			Документ.ИдентификаторСтрокиРеестра);
		
		Если Таблица.Количество() > 999 Тогда
			ПовторноОбработатьСообщения110ПоТаблице(Таблица);
			Таблица.Очистить();
		КонецЕсли;
	КонецЦикла;
	
	Если Таблица.Количество() > 0 Тогда
		ПовторноОбработатьСообщения110ПоТаблице(Таблица);
	КонецЕсли;
	
	Если ПараметрыОбновления <> Неопределено Тогда
		ПараметрыОбновления.ОбработкаЗавершена = Истина;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область СЭДО

Функция ТипСообщения() Экспорт
	Возврат 110;
КонецФункции

#КонецОбласти

#Область СоставДокументов

Функция ОбъектМетаданных() Экспорт
	Возврат Метаданные.Документы.УведомлениеОСтатусеВыплатыПособия;
КонецФункции

// Возвращает описание состава документа
//
// Возвращаемое значение:
//   Структура - см. ЗарплатаКадрыСоставДокументов.НовоеОписаниеСоставаОбъекта.
//
Функция ОписаниеСоставаОбъекта() Экспорт
	Возврат ЗарплатаКадрыСоставДокументов.ОписаниеСоставаОбъектаПоМетаданнымФизическиеЛицаВТабличныхЧастях(
		ОбъектМетаданных());
КонецФункции

#КонецОбласти

#Область ФиксацияВторичныхДанныхВДокументах

Функция ПараметрыФиксацииВторичныхДанных() Экспорт
	ФиксируемыеРеквизиты = ФиксируемыеРеквизиты();
	ФиксируемыеТаблицы = Новый Структура;
	Возврат ФиксацияВторичныхДанныхВДокументах.ПараметрыФиксации(ФиксируемыеРеквизиты, ФиксируемыеТаблицы);
КонецФункции

Функция ОбъектЗафиксирован(Документ) Экспорт
	Возврат Документ.Обработан;
КонецФункции

#КонецОбласти

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

#Область ОбновлениеИнформационнойБазы

Процедура ПовторноОбработатьСообщения110ПоТаблице(Таблица)
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Таблица.ИдентификаторСообщения КАК ИдентификаторСообщения,
	|	Таблица.СтатусВыплаты КАК СтатусВыплаты,
	|	Таблица.НомерПроцесса КАК НомерПроцесса,
	|	Таблица.ИдентификаторСтрокиРеестра КАК ИдентификаторСтрокиРеестра,
	|	Таблица.ИдентификаторРеестра КАК ИдентификаторРеестра
	|ПОМЕСТИТЬ Таблица
	|ИЗ
	|	&Таблица КАК Таблица
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Таблица.ИдентификаторСообщения КАК ИдентификаторСообщения
	|ИЗ
	|	Таблица КАК Таблица
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.РегистрацииОтветовНаЗапросыФССДляРасчетаПособий КАК Регистр
	|		ПО (Таблица.ИдентификаторРеестра <> """")
	|			И Таблица.ИдентификаторРеестра = Регистр.РегистрацияНомерРеестра
	|			И Таблица.СтатусВыплаты > Регистр.ВыплатаСтатус
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Таблица.ИдентификаторСообщения
	|ИЗ
	|	Таблица КАК Таблица
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.РегистрацииОтветовНаЗапросыФССДляРасчетаПособий КАК Регистр
	|		ПО (Таблица.НомерПроцесса <> 0)
	|			И Таблица.НомерПроцесса = Регистр.РегистрацияНомерПроцесса
	|			И Таблица.СтатусВыплаты > Регистр.ВыплатаСтатус
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Таблица.ИдентификаторСообщения
	|ИЗ
	|	Таблица КАК Таблица
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ЗаявлениеВФССОВозмещенииВыплатРодителямДетейИнвалидов КАК Шапка
	|		ПО (Таблица.ИдентификаторРеестра <> """")
	|			И Таблица.ИдентификаторРеестра = Шапка.ИдентификаторРеестра
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.РегистрацииЗаявленийОВозмещенииВыплатРодителямДетейИнвалидов КАК Регистр
	|		ПО (Шапка.ИдентификаторСообщения = Регистр.ИдентификаторСообщения)
	|			И Таблица.СтатусВыплаты > Регистр.ВыплатаСтатус";
	Запрос.УстановитьПараметр("Таблица", Таблица);
	Идентификаторы = КоллекцииБЗК.УникальныеЗначенияКолонки(Запрос.Выполнить().Выгрузить(), "ИдентификаторСообщения");
	Если Идентификаторы.Количество() > 0 Тогда
		СЭДОФСС.ПовторноОбработатьВходящиеСообщенияСЭДО(, , Идентификаторы);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ФиксацияВторичныхДанныхВДокументах

Функция ФиксируемыеРеквизиты()
	ФиксируемыеРеквизиты = Новый Соответствие;
	
	// При помощи механизмов фиксации описываются только механизмы обновления вторичных данных.
	// Механизмы заполнения первичных данных при этом могут существенно отличаться.
	
	Шаблон = ФиксацияВторичныхДанныхВДокументах.ОписаниеФиксируемогоРеквизита();
	Шаблон.ИмяГруппы           = "ПодтверждениеПолучения";
	Шаблон.ОснованиеЗаполнения = "ИдентификаторСообщения";
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "ТребуетсяПодтверждение");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "ДатаОтправкиПодтверждения");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "ПодтверждениеПолученоСФР");
	
	Шаблон = ФиксацияВторичныхДанныхВДокументах.ОписаниеФиксируемогоРеквизита();
	Шаблон.ИмяГруппы           = "МаксимальнаяДатаПодтверждения";
	Шаблон.ОснованиеЗаполнения = "ДатаСообщения";
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "МаксимальнаяДатаПодтверждения");
	
	Шаблон = ФиксацияВторичныхДанныхВДокументах.ОписаниеФиксируемогоРеквизита();
	Шаблон.ИмяГруппы           = "Прочее";
	Шаблон.ОснованиеЗаполнения = "ИдентификаторРеестра";
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "ТребуетсяОбработать");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "Обработан");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "Ответственный");
	
	// Реквизиты табличной части "Оплаты".
	Шаблон = ФиксацияВторичныхДанныхВДокументах.ОписаниеФиксируемогоРеквизита();
	Шаблон.ОснованиеЗаполнения = "СотрудникСНИЛС";
	Шаблон.ИмяГруппы           = "КадровыеДанные";
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "ФизическоеЛицо");
	
	Возврат Новый ФиксированноеСоответствие(ФиксируемыеРеквизиты);
КонецФункции

#КонецОбласти

#Область СЭДО

Процедура ЗагрузитьУведомлениеОНаличииСообщения110(Страхователь, ИдентификаторСообщения, ТребуетсяПодтверждение) Экспорт
	УстановитьПривилегированныйРежим(Истина);
	
	НачатьТранзакцию(РежимУправленияБлокировкойДанных.Управляемый);
	Попытка
		// Поиск документа по идентификатору сообщения.
		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	Шапка.Ссылка КАК Ссылка,
		|	Шапка.Дата КАК Дата,
		|	Шапка.ПометкаУдаления КАК ПометкаУдаления,
		|	Шапка.Страхователь КАК Страхователь,
		|	Шапка.ТребуетсяПодтверждение КАК ТребуетсяПодтверждение
		|ИЗ
		|	Документ.УведомлениеОСтатусеВыплатыПособия КАК Шапка
		|ГДЕ
		|	Шапка.ИдентификаторСообщения = &ИдентификаторСообщения
		|
		|УПОРЯДОЧИТЬ ПО
		|	ПометкаУдаления,
		|	Дата УБЫВ";
		Запрос.УстановитьПараметр("ИдентификаторСообщения", ИдентификаторСообщения);
		
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			Если Выборка.Страхователь = Страхователь
				И Не Выборка.ПометкаУдаления
				И ТребуетсяПодтверждение = Выборка.ТребуетсяПодтверждение Тогда
				ОтменитьТранзакцию();
				Возврат;
			КонецЕсли;
			ДокументОбъект = Выборка.Ссылка.ПолучитьОбъект();
		Иначе
			ДокументОбъект = Документы.УведомлениеОСтатусеВыплатыПособия.СоздатьДокумент();
		КонецЕсли;
		
		Если ДокументОбъект.ПометкаУдаления Тогда
			ДокументОбъект.УстановитьПометкуУдаления(Ложь);
		КонецЕсли;
		
		ДокументОбъект.Страхователь           = Страхователь;
		ДокументОбъект.ИдентификаторСообщения = ИдентификаторСообщения;
		Если ТребуетсяПодтверждение И ИмеетСмыслВключатьФлажокТребуетсяПодтверждение(ДокументОбъект) Тогда
			ДокументОбъект.ТребуетсяПодтверждение = Истина;
		КонецЕсли;
		Если Не ЗначениеЗаполнено(ДокументОбъект.Дата) Тогда
			ДокументОбъект.Дата = ТекущаяДатаСеанса();
		КонецЕсли;
		ЗаписатьДокумент(ДокументОбъект, РежимЗаписиДокумента.Запись);
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ТекстОшибки = СтрШаблон(
			НСтр("ru = 'При загрузке отказа в возмещении выплат родителям детей инвалидов %1 возникла ошибка: %2';
				|en = 'An error occurred when importing the %1 refusal to compensate payments to parents of disabled children: %2'"),
			ИдентификаторСообщения,
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		СообщенияБЗК.СообщитьОПроблеме(ТекстОшибки);
	КонецПопытки;
	
КонецПроцедуры

Процедура ЗагрузитьСообщение110(Страхователь, ИдентификаторСообщения, ТекстXML, ТребуетсяПодтверждение, Результат, Кэш) Экспорт
	Документ = СтруктураСообщения110(ТекстXML);
	Документ.Вставить("Страхователь", Страхователь);
	Документ.Вставить("ИдентификаторСообщения", ИдентификаторСообщения);
	
	ДатаСообщения = СЭДОФСС.ДатаСообщения(ИдентификаторСообщения, Кэш);
	
	НачатьТранзакцию(РежимУправленияБлокировкойДанных.Управляемый);
	Попытка
		// Поиск документа по идентификатору сообщения.
		ДокументОбъект = СоздатьДокументПоСообщению(Страхователь, ИдентификаторСообщения);
		
		ЕстьИзменения = Не ДокументОбъект.Проведен;
		
		// Обновление реквизитов документа.
		Если Не ДокументОбъект.Загружен Тогда
			ЕстьИзменения = Истина;
			ДокументОбъект.Дата = ТекущаяДатаСеанса();
			ДокументОбъект.Загружен = Истина;
		КонецЕсли;
		Если Не ЗначениеЗаполнено(ДокументОбъект.ДатаСообщения)
			Или ДокументОбъект.ДатаСообщения > ДатаСообщения
			Или ДокументОбъект.ДатаСообщения = НачалоДня(ДатаСообщения) Тогда
			ЕстьИзменения = Истина;
			ДокументОбъект.ДатаСообщения = ДатаСообщения;
		КонецЕсли;
		Для Каждого КлючИЗначение Из Документ Цикл
			Если ТипЗнч(КлючИЗначение.Значение) = Тип("ТаблицаЗначений") Тогда
				ЗначениеДоИзменения = ДокументОбъект[КлючИЗначение.Ключ].Выгрузить();
				ДокументОбъект[КлючИЗначение.Ключ].Загрузить(КлючИЗначение.Значение);
				ЗначениеПослеизменения = ДокументОбъект[КлючИЗначение.Ключ].Выгрузить();
				Если Не ОбщегоНазначенияБЗК.ЗначенияСовпадают(ЗначениеДоИзменения, ЗначениеПослеизменения) Тогда
					ЕстьИзменения = Истина;
				КонецЕсли;
			Иначе
				ЗначениеДоИзменения = ДокументОбъект[КлючИЗначение.Ключ];
				ДокументОбъект[КлючИЗначение.Ключ] = КлючИЗначение.Значение;
				Если ЗначениеДоИзменения <> ДокументОбъект[КлючИЗначение.Ключ] Тогда
					ЕстьИзменения = Истина;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
		
		Если ДокументОбъект.ЗаполнитьФлажокТребуетсяОбработать() Тогда
			ЕстьИзменения = Истина;
		КонецЕсли;
		
		Если ТребуетсяПодтверждение = Истина И ИмеетСмыслВключатьФлажокТребуетсяПодтверждение(ДокументОбъект) Тогда
			ДокументОбъект.ТребуетсяПодтверждение = Истина;
			ЕстьИзменения = Истина;
		КонецЕсли;
		
		Если ДокументОбъект.ОбновитьВторичныеДанные() Тогда
			ЕстьИзменения = Истина;
		КонецЕсли;
		
		Если ЕстьИзменения Тогда
			ЗаписатьДокумент(ДокументОбъект, РежимЗаписиДокумента.Проведение);
		КонецЕсли;
		
		ЗафиксироватьТранзакцию();
		Результат.Обработано = Истина;
	Исключение
		ОтменитьТранзакцию();
		СЭДОФСС.ОшибкаОбработки(Результат, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		Возврат;
	КонецПопытки;
	
КонецПроцедуры

// Возвращает Истина для документа можно и имеет смысл отправлять подтверждение.
Функция ИмеетСмыслВключатьФлажокТребуетсяПодтверждение(ДокументОбъект)
	Если ДокументОбъект.ТребуетсяПодтверждение Тогда
		Возврат Ложь; // Уже включен.
	КонецЕсли;
	Если ФиксацияВторичныхДанныхВДокументах.РеквизитШапкиЗафиксирован(ДокументОбъект, "ТребуетсяПодтверждение") Тогда
		Возврат Ложь; // Решение принимает пользователь.
	КонецЕсли;
	Если ДокументОбъект.ТребуетсяОбработать Тогда
		Возврат Истина; // Уже принято решение что документ требуется обработать.
	КонецЕсли;
	// При обновлении ИБ имеет смысл включать флажок только если документ актуален (относительно новый),
	// т.к. в противном случае после обновления может получиться очень много документов с избыточно включенным флажком.
	Возврат Не ОбновлениеИнформационнойБазы.ЭтоВызовИзОбработчикаОбновления()
		Или ДокументОбъект.ДатаСообщения > НачалоДня(ТекущаяДатаСеанса() - 86400*3);
КонецФункции

Функция СтруктураСообщения110(ТекстXML) Экспорт
	// Пример XML сообщения:
	//<v01:paymentStatusNotice xmlns:v01="http://www.fss.ru/integration/types/pvso/notice/v01">
	//	<person>
	//		<firstName>string</firstName>
	//		<secondName>string</secondName>
	//		<patronymic>string</patronymic>
	//		<birthDate>2008-09-29</birthDate>
	//		<snils>string</snils>
	//	</person>
	//	<paymentNotice>
	//		<noticeType>4</noticeType>
	//		<!--You have a CHOICE of the next 5 items at this level-->
	//		<registerRecieve>
	//			<infoType>0</infoType>
	//			<docType>5</docType>
	//			<period>
	//				<periodStart>2006-08-19+04:00</periodStart>
	//				<periodEnd>2009-05-16</periodEnd>
	//			</period>
	//			<addInformation>string</addInformation>
	//			<insurerName>string</insurerName>
	//		</registerRecieve>
	//		<paymentSend>
	//			<infoType>1</infoType>
	//			<docType>4</docType>
	//			<period>
	//				<periodStart>2013-12-21+04:00</periodStart>
	//				<periodEnd>2016-01-01</periodEnd>
	//			</period>
	//			<addInformation>string</addInformation>
	//		</paymentSend>
	//		<paymentDone>
	//			<infoType>0</infoType>
	//			<docType>3</docType>
	//			<period>
	//				<periodStart>2019-08-19</periodStart>
	//				<periodEnd>2018-02-04+03:00</periodEnd>
	//			</period>
	//			<addInformation>string</addInformation>
	//			<summa>1000.00000000</summa>
	//			<sum>1000.00000000</sum>
	//			<dutySum>1000.00000000</dutySum>
	//		</paymentDone>
	//		<paymentCanceling>
	//			<infoType>0</infoType>
	//			<docType>3</docType>
	//			<period>
	//				<periodStart>2014-06-10+04:00</periodStart>
	//				<periodEnd>2003-11-10+03:00</periodEnd>
	//			</period>
	//			<addInformation>string</addInformation>
	//			<sum>1000.00000000</sum>
	//			<paymentState>string</paymentState>
	//		</paymentCanceling>
	//		<noticeSend>
	//			<infoType>0</infoType>
	//			<docType>1</docType>
	//			<period>
	//				<periodStart>2014-06-27+04:00</periodStart>
	//				<periodEnd>2017-08-17</periodEnd>
	//			</period>
	//			<addInformation>string</addInformation>
	//			<insurerName>string</insurerName>
	//		</noticeSend>
	//	</paymentNotice>
	//</v01:paymentStatusNotice>
	
	Документ = Новый Структура;
	
	// Поиск корневого узла.
	СтруктураDOM = СериализацияБЗК.СтруктураDOM(ТекстXML);
	КореньDOM = СериализацияБЗК.НайтиУзелDOMПоИмени(СтруктураDOM, "paymentStatusNotice");
	Если КореньDOM = Неопределено Тогда
		КореньDOM = СтруктураDOM.ДокументDOM.ЭлементДокумента;
	КонецЕсли;
	
	// Чтение реквизитов.
	УзлыКорня = СериализацияБЗК.УзлыЭлементаDOM(КореньDOM, "person, paymentNotice");
	
	ИменаУзлов = "firstName, secondName, patronymic, birthDate, snils";
	УзлыСотрудника = СериализацияБЗК.УзлыЭлементаDOM(УзлыКорня.person, ИменаУзлов);
	Документ.Вставить("СотрудникИмя", СериализацияБЗК.СтрокаИзXML(УзлыСотрудника.firstName));
	Документ.Вставить("СотрудникФамилия", СериализацияБЗК.СтрокаИзXML(УзлыСотрудника.secondName));
	Документ.Вставить("СотрудникОтчество", СериализацияБЗК.СтрокаИзXML(УзлыСотрудника.patronymic));
	Документ.Вставить("СотрудникДатаРождения", СериализацияБЗК.ДатаИзXML(УзлыСотрудника.birthDate));
	Документ.Вставить("СотрудникСНИЛС", СЭДОФСС.СНИЛСИзXML(УзлыСотрудника.snils));
	
	УзлыСообщения = СериализацияБЗК.УзлыЭлементаDOM(УзлыКорня.paymentNotice, "noticeType, batchNo, socialAssistNum,
		|registerRecieve, paymentSend, paymentDone, paymentCanceling, noticeSend");
	Документ.Вставить("НомерПроцесса", СериализацияБЗК.СтрокаИзXML(УзлыСообщения.socialAssistNum));
	Документ.Вставить("ИдентификаторСтрокиРеестра", СериализацияБЗК.СтрокаИзXML(УзлыСообщения.batchNo));
	Документ.Вставить("СтатусВыплаты", СериализацияБЗК.ЧислоИзXML(УзлыСообщения.noticeType));
	Документ.Вставить("СтатусВыплатыПоТегам", Неопределено);
	Если УзлыСообщения.registerRecieve <> Неопределено Тогда
		Документ.СтатусВыплатыПоТегам = 1;
		ЗаполнитьВложенныеДанные(Документ, УзлыСообщения.registerRecieve);
	КонецЕсли;
	Если УзлыСообщения.paymentSend <> Неопределено Тогда
		Документ.СтатусВыплатыПоТегам = 2;
		ЗаполнитьВложенныеДанные(Документ, УзлыСообщения.paymentSend);
	КонецЕсли;
	Если УзлыСообщения.paymentDone <> Неопределено Тогда
		Документ.СтатусВыплатыПоТегам = 3;
		ЗаполнитьВложенныеДанные(Документ, УзлыСообщения.paymentDone);
	КонецЕсли;
	Если УзлыСообщения.paymentCanceling <> Неопределено Тогда
		Документ.СтатусВыплатыПоТегам = 4;
		ЗаполнитьВложенныеДанные(Документ, УзлыСообщения.paymentCanceling);
	КонецЕсли;
	Если УзлыСообщения.noticeSend <> Неопределено Тогда
		Документ.СтатусВыплатыПоТегам = 5;
		ЗаполнитьВложенныеДанные(Документ, УзлыСообщения.noticeSend);
	КонецЕсли;
	
	Возврат Документ;
КонецФункции

Процедура ЗаполнитьВложенныеДанные(Документ, ЭлементDOM)
	УзлыДанных = СериализацияБЗК.УзлыЭлементаDOM(ЭлементDOM);
	Если УзлыДанных.Свойство("infoType") Тогда
		Документ.Вставить("ТипВыплаты", СериализацияБЗК.СтрокаИзXML(УзлыДанных.infoType));
	КонецЕсли;
	Если УзлыДанных.Свойство("docType") Тогда
		Документ.Вставить("ВидПособияЧислом", СериализацияБЗК.ЧислоИзXML(УзлыДанных.docType));
	КонецЕсли;
	Если УзлыДанных.Свойство("period") Тогда
		УзлыПериода = СериализацияБЗК.УзлыЭлементаDOM(УзлыДанных.period, "periodStart, periodEnd");
		Документ.Вставить("НачалоПериода", СериализацияБЗК.ДатаИзXML(УзлыПериода.periodStart));
		Документ.Вставить("КонецПериода", СериализацияБЗК.ДатаИзXML(УзлыПериода.periodEnd));
	КонецЕсли;
	Если УзлыДанных.Свойство("addInformation") Тогда
		Документ.Вставить("Пояснения", СериализацияБЗК.СтрокаИзXML(УзлыДанных.addInformation));
	КонецЕсли;
	Если УзлыДанных.Свойство("insurerName") Тогда
		Документ.Вставить("СтраховательНаименование", СериализацияБЗК.СтрокаИзXML(УзлыДанных.insurerName));
	КонецЕсли;
	Если УзлыДанных.Свойство("summa") Тогда
		Документ.Вставить("Начислено", СериализацияБЗК.ЧислоИзXML(УзлыДанных.summa));
	КонецЕсли;
	Если УзлыДанных.Свойство("sum") Тогда
		Документ.Вставить("Выплачено", СериализацияБЗК.ЧислоИзXML(УзлыДанных.sum));
	КонецЕсли;
	Если УзлыДанных.Свойство("dutySum") Тогда
		Документ.Вставить("Удержано", СериализацияБЗК.ЧислоИзXML(УзлыДанных.dutySum));
	КонецЕсли;
	Если УзлыДанных.Свойство("paymentState") Тогда
		Документ.Вставить("СтатусПлатежа", СериализацияБЗК.СтрокаИзXML(УзлыДанных.paymentState));
	КонецЕсли;
КонецПроцедуры

Процедура ЗагрузитьОтветНаПодтверждениеПолученияСообщения110(Страхователь, ИсходноеСообщение, Результат) Экспорт
	// Вызывается при получении сообщения с типом 11 в ответ на подтверждение о прочтении входящего сообщения.
	//   Страхователь - СправочникСсылка.Организации - организация, получатель сообщения.
	//   ИсходноеСообщение - Структура:
	//     * ИдентификаторСообщения - Строка - идентификатор исходного сообщения СЭДО, по которому отправлялось подтверждение.
	//     * Тип                    - Число  - тип исходного сообщения СЭДО, по которому отправлялось подтверждение.
	//     * ТекстОшибки            - Строка - ошибка приема подтверждения.
	//     * ТекстПредупреждения    - Строка - предупреждение приема подтверждения.
	//   Результат - Структура - результат обработки сообщения:
	//     * Обработано      - Булево - признак того, что сообщение было успешно обработано.
	//     * ОшибкаОбработки - Булево - признак того, что при обработке сообщения возникла ошибка.
	//     * ОписаниеОшибки  - Строка - описание ошибки обработки.
	
	Ссылка = НайтиДокументПоСообщению(Страхователь, ИсходноеСообщение.ИдентификаторСообщения);
	Если Не ЗначениеЗаполнено(Ссылка) Тогда
		Возврат;
	КонецЕсли;
	
	НачатьТранзакцию(РежимУправленияБлокировкойДанных.Управляемый);
	Попытка
		// Поиск документа по идентификатору сообщения.
		ДокументОбъект = Ссылка.ПолучитьОбъект();
		ФиксацияВторичныхДанныхВДокументах.ОтменитьФиксациюРеквизитаШапки(ДокументОбъект, "ТребуетсяПодтверждение");
		ФиксацияВторичныхДанныхВДокументах.ОтменитьФиксациюРеквизитаШапки(ДокументОбъект, "ДатаОтправкиПодтверждения");
		ФиксацияВторичныхДанныхВДокументах.ОтменитьФиксациюРеквизитаШапки(ДокументОбъект, "ПодтверждениеПолученоСФР");
		Если ДокументОбъект.ЗаполнитьПодтверждениеПолучения(Ложь) Тогда
			ЗаписатьДокумент(ДокументОбъект, РежимЗаписиДокумента.Запись);
			ЗафиксироватьТранзакцию();
			Результат.Обработано = Истина;
		Иначе
			ОтменитьТранзакцию();
		КонецЕсли;
	Исключение
		ОтменитьТранзакцию();
		СЭДОФСС.ОшибкаОбработки(Результат, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		Возврат;
	КонецПопытки;
	
КонецПроцедуры

Функция НайтиДокументПоСообщению(Страхователь, ИдентификаторСообщения)
	ВыбираемыеПоля = "Ссылка";
	НастройкиЗапроса = ЗапросыБЗК.НастройкиЗапросаКТаблице();
	НастройкиЗапроса.Количество = 1;
	ЗапросыБЗК.ДобавитьОтбор(НастройкиЗапроса.Отбор, "ИдентификаторСообщения", , ИдентификаторСообщения);
	ЗапросыБЗК.ДобавитьОтбор(НастройкиЗапроса.Отбор, "Страхователь",           , Страхователь);
	Запрос = ЗапросыБЗК.ЗапросКТаблице(ОбъектМетаданных(), ВыбираемыеПоля, НастройкиЗапроса);
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Ссылка;
	КонецЕсли;
	Возврат Неопределено;
КонецФункции

Функция СоздатьДокументПоСообщению(Страхователь, ИдентификаторСообщения)
	Ссылка = НайтиДокументПоСообщению(Страхователь, ИдентификаторСообщения);
	Если ЗначениеЗаполнено(Ссылка) Тогда
		Возврат Ссылка.ПолучитьОбъект();
	Иначе
		Объект = СоздатьДокумент();
		Объект.Страхователь = Страхователь;
		Объект.ИдентификаторСообщения = ИдентификаторСообщения;
		Возврат Объект;
	КонецЕсли;
КонецФункции

#КонецОбласти

#Область Регламенты

Функция МаксимальнаяДатаПодтвержденияПолучения(Объект) Экспорт
	Возврат СЭДОФСС.СледующийРабочийДень(Объект.ДатаСообщения, РабочихДнейНаПодтверждениеПолучения());
КонецФункции

// См. п.7 Положения № 1 утвержденного Постановлением Правительства РФ от 21.04.2011 N 294.
Функция РабочихДнейНаПодтверждениеПолучения()
	Возврат 1;
КонецФункции

#КонецОбласти

#Область ТекущиеДела

Функция ТребованияПоОтправке()
	НачалоТекущегоДня = НачалоДня(ТекущаяДатаСеанса());
	НачалоРабочегоДня = НачалоДня(СЭДОФСС.БлижайшийРабочийДень(НачалоТекущегоДня));
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Шапка.Ссылка КАК Ссылка,
	|	ЛОЖЬ КАК ТребуетсяЗагрузить,
	|	ИСТИНА КАК ТребуетсяОбработать,
	|	Шапка.ТребуетсяПодтверждение
	|		И Шапка.ДатаОтправкиПодтверждения = &ПустаяДата КАК ТребуетсяПодтвердить
	|ИЗ
	|	Документ.УведомлениеОСтатусеВыплатыПособия КАК Шапка
	|ГДЕ
	|	Шапка.ТребуетсяОбработать
	|	И НЕ Шапка.Обработан
	|	И НЕ Шапка.ПометкаУдаления
	|	И Шапка.Загружен
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	Шапка.Ссылка,
	|	ИСТИНА,
	|	ЛОЖЬ,
	|	Шапка.ТребуетсяПодтверждение
	|		И Шапка.ДатаОтправкиПодтверждения = &ПустаяДата
	|ИЗ
	|	Документ.УведомлениеОСтатусеВыплатыПособия КАК Шапка
	|ГДЕ
	|	НЕ Шапка.Загружен
	|	И НЕ Шапка.ПометкаУдаления";
	
	Запрос.УстановитьПараметр("ПустаяДата", '00010101');
	
	Возврат Запрос.Выполнить().Выгрузить();
КонецФункции

#КонецОбласти

#Область ФизическиеЛица

Процедура ПриИзмененииСНИЛСФизическогоЛица(ФизическоеЛицо, СтарыйСНИЛС, НовыйСНИЛС) Экспорт
	// В сообщениях 110 Фонд явно указывает СНИЛС, поэтому в них требуется актуализировать ссылки физлиц.
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Шапка.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.УведомлениеОСтатусеВыплатыПособия КАК Шапка
	|ГДЕ
	|	Шапка.СотрудникСНИЛС = &НовыйСНИЛС
	|	И Шапка.ФизическоеЛицо <> &ФизическоеЛицо
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ
	|	Шапка.Ссылка
	|ИЗ
	|	Документ.УведомлениеОСтатусеВыплатыПособия КАК Шапка
	|ГДЕ
	|	Шапка.ФизическоеЛицо = &ФизическоеЛицо
	|	И Шапка.СотрудникСНИЛС <> &НовыйСНИЛС";
	Если ЗначениеЗаполнено(НовыйСНИЛС) Тогда
		Запрос.УстановитьПараметр("НовыйСНИЛС", НовыйСНИЛС);
	Иначе
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "Шапка.СотрудникСНИЛС = &НовыйСНИЛС", "ЛОЖЬ");
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "Шапка.СотрудникСНИЛС <> &НовыйСНИЛС", "ИСТИНА");
	КонецЕсли;
	Запрос.УстановитьПараметр("ФизическоеЛицо", ФизическоеЛицо);
	
	Таблица = Запрос.Выполнить().Выгрузить();
	Для Каждого СтрокаВыборки Из Таблица Цикл
		Если Не ЗначениеЗаполнено(СтрокаВыборки.Ссылка) Тогда
			Продолжить;
		КонецЕсли;
		ДокументОбъект = СтрокаВыборки.Ссылка.ПолучитьОбъект();
		Если ДокументОбъект.СотрудникСНИЛС = НовыйСНИЛС И ЗначениеЗаполнено(НовыйСНИЛС) Тогда
			ДокументОбъект.ФизическоеЛицо = ФизическоеЛицо;
		Иначе
			ДокументОбъект.ФизическоеЛицо = Неопределено;
		КонецЕсли;
		ЗаписатьДокумент(ДокументОбъект, РежимЗаписиДокумента.Запись);
	КонецЦикла;
КонецПроцедуры

#КонецОбласти

Процедура ЗаписатьДокумент(ДокументОбъект, РежимЗаписи) Экспорт
	СЭДОФСС.ЗаписатьДокумент(ДокументОбъект, Истина, "БЗК", РежимЗаписи);
КонецПроцедуры

Функция ИдентификаторРеестра(ИдентификаторСтрокиРеестра) Экспорт
	Если ИдентификаторСтрокиРеестра = "" Тогда
		Возврат "";
	КонецЕсли;
	Позиция = СтрНайти(ИдентификаторСтрокиРеестра, ":", НаправлениеПоиска.СКонца);
	Если Позиция = 0 Тогда
		Возврат ИдентификаторСтрокиРеестра;
	КонецЕсли;
	Возврат Лев(ИдентификаторСтрокиРеестра, Позиция - 1);
КонецФункции

#КонецОбласти

#КонецЕсли