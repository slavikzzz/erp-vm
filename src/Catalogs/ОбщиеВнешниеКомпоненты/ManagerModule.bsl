///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

// Возвращает реквизиты объекта, которые разрешается редактировать
// с помощью обработки группового изменения реквизитов.
//
// Возвращаемое значение:
//  Массив из Строка
//
Функция РеквизитыРедактируемыеВГрупповойОбработке() Экспорт
	
	Результат = Новый Массив;
	Возврат Результат;
	
КонецФункции

// Конец СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Возвращает ссылку на справочник внешней компоненты по идентификатору и версии.
//
// Параметры:
//  Идентификатор - Строка - идентификатор объекта внешнего компонента.
//  Версия        - Строка - версия компоненты.
//
// Возвращаемое значение:
//  СправочникСсылка.ВнешниеКомпоненты - ссылка на контейнер внешней компоненты в информационной базе.
//
Функция НайтиПоИдентификатору(Идентификатор, Версия = Неопределено) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Идентификатор", Идентификатор);
	
	Если Не ЗначениеЗаполнено(Версия) Тогда 
		Запрос.Текст = 
			"ВЫБРАТЬ ПЕРВЫЕ 1
			|	ВнешниеКомпоненты.Ссылка КАК Ссылка
			|ИЗ
			|	Справочник.ОбщиеВнешниеКомпоненты КАК ВнешниеКомпоненты
			|ГДЕ
			|	ВнешниеКомпоненты.Идентификатор = &Идентификатор
			|
			|УПОРЯДОЧИТЬ ПО
			|	ВнешниеКомпоненты.ДатаВерсии УБЫВ";
	Иначе 
		Запрос.УстановитьПараметр("Версия", Версия);
		Запрос.Текст = 
			"ВЫБРАТЬ ПЕРВЫЕ 1
			|	ВнешниеКомпоненты.Ссылка КАК Ссылка
			|ИЗ
			|	Справочник.ОбщиеВнешниеКомпоненты КАК ВнешниеКомпоненты
			|ГДЕ
			|	ВнешниеКомпоненты.Идентификатор = &Идентификатор
			|	И ВнешниеКомпоненты.Версия = &Версия";
		
	КонецЕсли;
	
	Результат = Запрос.Выполнить();
	
	Если Результат.Пустой() Тогда 
		Возврат ПустаяСсылка();
	КонецЕсли;
	
	Выборка = Результат.Выбрать();
	Выборка.Следующий();
	
	Возврат Результат.Выгрузить()[0].Ссылка;
	
КонецФункции

#Область ОбработчикиОбновления

// Заполняет реквизит ЦелевыеПлатформы в справочнике "Общие внешние компоненты".
//
Процедура ОбработатьОбщиеВнешниеКомпоненты() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	ОбщиеВнешниеКомпоненты.Ссылка,
	|	ОбщиеВнешниеКомпоненты.ХранилищеКомпоненты,
	|	ОбщиеВнешниеКомпоненты.ЦелевыеПлатформы
	|ИЗ
	|	Справочник.ОбщиеВнешниеКомпоненты КАК ОбщиеВнешниеКомпоненты";
		
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ОбъектовОбработано = 0;
	ПроблемныхОбъектов = 0;

	Пока Выборка.Следующий() Цикл

		ЦелевыеПлатформы = Выборка.ЦелевыеПлатформы.Получить();
		ДвоичныеДанныеКомпоненты = Выборка.ХранилищеКомпоненты.Получить();
		
		Если ТипЗнч(ДвоичныеДанныеКомпоненты) <> Тип("ДвоичныеДанные") Тогда
			ОбъектовОбработано = ОбъектовОбработано + 1;
			Продолжить;
		КонецЕсли;
		
		ИнформацияОКомпонентеИзФайла = ВнешниеКомпонентыСлужебный.ИнформацияОКомпонентеИзФайла(
			ДвоичныеДанныеКомпоненты, Ложь);
		Если Не ИнформацияОКомпонентеИзФайла.Разобрано Тогда
			ОбъектовОбработано = ОбъектовОбработано + 1;
			Продолжить;
		КонецЕсли;
		
		Реквизиты = ИнформацияОКомпонентеИзФайла.Реквизиты;
		
		Если ЦелевыеПлатформы <> Неопределено И ОбщегоНазначения.КоллекцииИдентичны(ЦелевыеПлатформы, Реквизиты.ЦелевыеПлатформы) Тогда
			ОбъектовОбработано = ОбъектовОбработано + 1;
			Продолжить;
		КонецЕсли;
		
		ПредставлениеСсылки = Строка(Выборка.Ссылка);
		НачатьТранзакцию();
		Попытка

			Блокировка = Новый БлокировкаДанных;
			ЭлементБлокировки = Блокировка.Добавить("Справочник.ОбщиеВнешниеКомпоненты");
			ЭлементБлокировки.УстановитьЗначение("Ссылка", Выборка.Ссылка);
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
			Блокировка.Заблокировать();

			КомпонентаОбъект = Выборка.Ссылка.ПолучитьОбъект(); // СправочникОбъект.ОбщиеВнешниеКомпоненты
			КомпонентаОбъект.ЦелевыеПлатформы = Новый ХранилищеЗначения(Реквизиты.ЦелевыеПлатформы);
			ОбновлениеИнформационнойБазы.ЗаписатьОбъект(КомпонентаОбъект);

			ОбъектовОбработано = ОбъектовОбработано + 1;
			ЗафиксироватьТранзакцию();

		Исключение

			ОтменитьТранзакцию();
			
			ПроблемныхОбъектов = ПроблемныхОбъектов + 1;

			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Не удалось обработать общую компоненту %1 по причине:
					 |%2';
					 |en = 'Couldn''t process the common add-in %1 due to:
					 |%2'"), ПредставлениеСсылки, ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));

			ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
				УровеньЖурналаРегистрации.Предупреждение, Выборка.Ссылка.Метаданные(), Выборка.Ссылка, ТекстСообщения);

		КонецПопытки;

	КонецЦикла;

	Если ОбъектовОбработано = 0 И ПроблемныхОбъектов <> 0 Тогда
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не удалось обработать общие компоненты (пропущены): %1';
				|en = 'Couldn''t process (skipped) some common add-ins: %1'"),
			ПроблемныхОбъектов);
		ВызватьИсключение ТекстСообщения;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли