///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Элементы.ПодписанныйОбъект.Видимость = Ложь;
	
	Если ЗначениеЗаполнено(Параметры.РежимПродления) Тогда
		
		ОбновитьПредставлениеДанных(Истина);
		
		Если Параметры.РежимПродления = "ТребуетсяУсовершенствоватьПодписи" Тогда 
			ТипПодписи = Константы.ТипПодписиКриптографииПоУмолчанию.Получить();
			Элементы.ДобавитьАрхивнуюМеткуВремени.Видимость = Ложь;
			Элементы.ТипПодписи.Видимость = Ложь;
			Элементы.ДекорацияУсовершенствование.Видимость = Истина;
			Элементы.ДекорацияУсовершенствование.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Подписи будут усовершенствованы до типа
			|%1';
			|en = 'Signatures will be enhanced to:
			|%1'"), ТипПодписи);
		ИначеЕсли Параметры.РежимПродления = "ТребуетсяДобавитьАрхивныеМетки" Тогда
			Элементы.ДобавитьАрхивнуюМеткуВремени.Видимость = Ложь;
			Элементы.ДекорацияДобавлениеМетокВремени.Видимость = Истина; 
			Элементы.ДекорацияДобавлениеМетокВремени.Заголовок = НСтр("ru = 'В подписи будут добавлены архивные метки времени';
																		|en = 'Archive timestamps will be added to the signatures'");
			Элементы.ТипПодписи.Видимость = Ложь;
		Иначе
			Элементы.ДобавитьАрхивнуюМеткуВремени.Видимость = Истина;
			Элементы.ТипПодписи.Видимость = Истина;
		КонецЕсли;
		
	Иначе
		
		Если ЗначениеЗаполнено(Параметры.Подпись) Тогда
			Подпись = ПоместитьВоВременноеХранилище(Параметры.Подпись, УникальныйИдентификатор);
		КонецЕсли;
		
		Если ТипЗнч(Параметры.Подпись) = Тип("Структура") Тогда
			Если ЗначениеЗаполнено(Параметры.Подпись.ПодписанныйОбъект) Тогда
				ПодписанныйОбъект = Параметры.Подпись.ПодписанныйОбъект;
				
				Если Не Пользователи.ЭтоПолноправныйПользователь()
					И ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
					МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
					МодульУправлениеДоступом.ПроверитьИзменениеРазрешено(ПодписанныйОбъект);
				КонецЕсли;
				
				ПорядковыйНомер = Параметры.Подпись.ПорядковыйНомер; 
				Элементы.ПодписанныйОбъект.Видимость = Истина; 
			КонецЕсли;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Параметры.ЗаголовокДанных) Тогда
			Элементы.ПредставлениеДанных.Заголовок = Параметры.ЗаголовокДанных;
		Иначе
			Элементы.ПредставлениеДанных.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Нет;
		КонецЕсли;
		
		ПредставлениеДанных = Параметры.ПредставлениеДанных;
		Элементы.ПредставлениеДанных.Гиперссылка = Параметры.ПредставлениеДанныхОткрывается;
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.ТипПодписи) Тогда
		Если Параметры.ТипПодписи = Перечисления.ТипыПодписиКриптографии.АрхивнаяCAdESAv3
			Или Параметры.ТипПодписи = Перечисления.ТипыПодписиКриптографии.CAdESAv2 Тогда
			
			Элементы.ДобавитьАрхивнуюМеткуВремени.Видимость = Ложь;
			Элементы.ДекорацияДобавлениеМетокВремени.Видимость = Истина; 
			Элементы.ДекорацияДобавлениеМетокВремени.Заголовок = НСтр("ru = 'В подписи будут добавлены архивные метки времени';
																		|en = 'Archive timestamps will be added to the signatures'");
			
			Элементы.ТипПодписи.Видимость = Ложь;
			ДобавитьАрхивнуюМеткуВремени = Истина;
		Иначе
			Элементы.ДобавитьАрхивнуюМеткуВремени.Видимость = Ложь;
			Элементы.ТипПодписи.Видимость = Истина;
		КонецЕсли;
	Иначе
		Если ЗначениеЗаполнено(ПодписанныйОбъект) Тогда
			ОпределитьТипПодписейОбъекта();
		КонецЕсли;
	КонецЕсли;

	Если Не ЗначениеЗаполнено(ПредставлениеДанных) Тогда
		Элементы.ПредставлениеДанных.Видимость = Ложь;
	КонецЕсли;
	
	Если Элементы.ТипПодписи.Видимость Тогда
		ЭлектроннаяПодписьСлужебный.ЗаполнитьСписокТиповПодписейКриптографии(Элементы.ТипПодписи.СписокВыбора,
			"Усовершенствование", ?(ЗначениеЗаполнено(Параметры.ТипПодписи), Параметры.ТипПодписи, Неопределено));
		Если Элементы.ДобавитьАрхивнуюМеткуВремени.Видимость Тогда
			Элементы.ТипПодписи.СписокВыбора.Добавить(Перечисления.ТипыПодписиКриптографии.ПустаяСсылка(), НСтр("ru = 'Не усовершенствовать';
																												|en = 'Do not enhance'"));
		КонецЕсли;
		Если Элементы.ТипПодписи.СписокВыбора.Количество() = 1 Тогда
			ТипПодписи = Элементы.ТипПодписи.СписокВыбора[0].Значение;
			Элементы.ТипПодписи.Видимость = Ложь;
			Элементы.ДекорацияУсовершенствование.Видимость = Истина;
			Элементы.ДекорацияУсовершенствование.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Подписи будут усовершенствованы до типа
					|%1';
					|en = 'Signatures will be enhanced to:
					|%1'"), ТипПодписи);
		Иначе
			ТипПодписи = Константы.ТипПодписиКриптографииПоУмолчанию.Получить();
			Если ТипПодписи = Перечисления.ТипыПодписиКриптографии.БазоваяCAdESBES
				Или ТипПодписи = Перечисления.ТипыПодписиКриптографии.ПустаяСсылка()
				Или ТипПодписи = Перечисления.ТипыПодписиКриптографии.ОбычнаяCMS Тогда
				ТипПодписи = Элементы.ТипПодписи.СписокВыбора[0].Значение;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Если Элементы.ДобавитьАрхивнуюМеткуВремени.Видимость Тогда
		ДобавитьАрхивнуюМеткуВремени = Константы.ДобавлятьМеткиВремениАвтоматически.Получить();
	КонецЕсли;
	
	СтандартныеПодсистемыСервер.СброситьРазмерыИПоложениеОкна(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы
	
&НаКлиенте
Процедура ПодписанныйОбъектНажатие(Элемент, СтандартнаяОбработка)
	Если ЭтоСсылка(ПодписанныйОбъект) Тогда
		ПоказатьЗначение(,ПодписанныйОбъект);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеДанныхНажатие(Элемент, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Параметры.РежимПродления) Тогда
		СтандартнаяОбработка = Ложь;
		ПараметрыОтчета = Новый Структура("КлючВарианта", Параметры.РежимПродления); 
		Если Ошибки.Количество() > 0 Тогда
			ПараметрыОтчета.Вставить("Ошибки", ПолучитьАдресОшибокВоВременномХранилище());
		КонецЕсли;
		ОткрытьФорму("Отчет.ПродлениеСрокаДействияЭлектронныхПодписей.Форма", ПараметрыОтчета);
	КонецЕсли;
	
КонецПроцедуры
	
#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыполнитьДействия(Команда)
	
	Ошибки.Очистить();
	
	Если Параметры.РежимПродления = "НеобработанныеПодписи"
		Или Параметры.РежимПродления = "ТребуетсяДобавитьАрхивныеМетки"
		Или Параметры.РежимПродления = "ОшибкиПриАвтоматическомПродлении"
		Или Параметры.РежимПродления = "ТребуетсяУсовершенствоватьПодписи" Тогда
		ЗаполнитьПодпись();
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Подпись) Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Не заполнены данные подписей';
										|en = 'Signature data is required'"));
		Возврат;
	КонецЕсли;
	
	ОписаниеДанных = Новый Структура("Подпись, ТипПодписи, ДобавитьАрхивнуюМеткуВремени",
		Подпись, ТипПодписи, ДобавитьАрхивнуюМеткуВремени);
	ОписаниеДанных.Подпись = ПолучитьИзВременногоХранилища(Подпись);
		
	Оповещение = Новый ОписаниеОповещения("ПослеВыполнения", ЭтотОбъект);  
	ЭлектроннаяПодписьКлиент.УсовершенствоватьПодпись(ОписаниеДанных, ЭтотОбъект, Оповещение, Ложь); 
	Элементы.ВыполнитьДействия.Доступность = Ложь;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьПодпись()
	
	ПараметрыЗапроса = Новый Структура;
	ПараметрыЗапроса.Вставить(Параметры.РежимПродления, Истина);
	Запрос = ЭлектроннаяПодписьСлужебный.ЗапросДляПродленияДостоверностиПодписей(ПараметрыЗапроса);
	
	Массив = Новый Массив;
	УстановитьПривилегированныйРежим(Истина);
	РезультатЗапроса = Запрос.Выполнить();
	УстановитьПривилегированныйРежим(Ложь);
	
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		Массив.Добавить(Новый Структура("ПодписанныйОбъект, ПорядковыйНомер",
			Выборка.ПодписанныйОбъект, Выборка.ПорядковыйНомер));
	КонецЦикла;
	
	КоличествоПодписей = Массив.Количество();
	Если КоличествоПодписей > 0 Тогда
		Подпись = ПоместитьВоВременноеХранилище(Массив, УникальныйИдентификатор);
	КонецЕсли;
	
	ОбновитьПредставлениеДанных();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьПредставлениеДанных(ВычислитьКоличество = Ложь)
	
	Если Не ЗначениеЗаполнено(Параметры.РежимПродления) Тогда
		Возврат;
	КонецЕсли;

	Если ВычислитьКоличество Тогда
		КоличествоПодписей = ЭлектроннаяПодписьСлужебный.КоличествоПодписей(Параметры.РежимПродления);
		Элементы.ПредставлениеДанных.Гиперссылка = Истина;
		Элементы.ПредставлениеДанных.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Нет;
	КонецЕсли;

	Если Параметры.РежимПродления = "ТребуетсяУсовершенствоватьПодписи" Тогда
		ПредставлениеДанных = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Подписи для усовершенствования (%1)';
				|en = 'Signatures pending enhancement (%1)'"), КоличествоПодписей);
	ИначеЕсли Параметры.РежимПродления = "ТребуетсяДобавитьАрхивныеМетки" Тогда
		ПредставлениеДанных = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Подписи для добавления архивных меток (%1)';
				|en = 'Signatures to add archive timestamps (%1)'"), КоличествоПодписей);
	ИначеЕсли Параметры.РежимПродления = "НеобработанныеПодписи" Тогда
		ПредставлениеДанных = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Ранее добавленные подписи с незаполненным типом (%1)';
				|en = 'Previously added signatures with a blank type (%1)'"), КоличествоПодписей);
	ИначеЕсли Параметры.РежимПродления = "ОшибкиПриАвтоматическомПродлении" Тогда
		ПредставлениеДанных = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Ошибки при автоматическом продлении подписей (%1)';
				|en = 'Automatic signature renewal errors (%1)'"), КоличествоПодписей);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеВыполнения(Результат, Контекст) Экспорт
	
	Элементы.ВыполнитьДействия.Доступность = Истина;
	Оповестить("Запись_Подпись");
	Если Не Результат.Успех Тогда 
		Если Результат.СвойстваПодписей <> Неопределено Тогда
			Для Каждого СвойствоПодписи Из Результат.СвойстваПодписей Цикл
				Если СвойствоПодписи.Свойство("Ошибка") Тогда
					НоваяСтрока = Ошибки.Добавить();
					ЗаполнитьЗначенияСвойств(НоваяСтрока, СвойствоПодписи);
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		
		Элементы.Ошибки.Видимость = Ошибки.Количество() > 0;
		
		Если ЗначениеЗаполнено(Результат.ТекстОшибки) Тогда
			ПоказатьПредупреждение(, Результат.ТекстОшибки);
		КонецЕсли;
		ОбновитьПредставлениеДанных(Истина);
	Иначе
		Закрыть(Результат);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьАдресОшибокВоВременномХранилище()
	Возврат ПоместитьВоВременноеХранилище(Ошибки.Выгрузить(), УникальныйИдентификатор);
КонецФункции

&НаСервереБезКонтекста
Функция ЭтоСсылка(ПодписанныйОбъект)
	Возврат ОбщегоНазначения.ЭтоСсылка(ТипЗнч(ПодписанныйОбъект));
КонецФункции

&НаСервере
Процедура ОпределитьТипПодписейОбъекта()
	
	УстановленныеПодписи = ЭлектроннаяПодпись.УстановленныеПодписи(
		ПодписанныйОбъект, ?(ЗначениеЗаполнено(ПорядковыйНомер), ПорядковыйНомер, Неопределено));
		
	ЕстьБазоваяПодпись = Ложь; ЕстьПодписьСМеткойВремени = Ложь; ЕстьАрхивнаяПодпись = Ложь;
	
	Для Каждого ТекущаяПодпись Из УстановленныеПодписи Цикл
		
		Если Не ТекущаяПодпись.ПодписьВерна Тогда
			Продолжить;
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(ТекущаяПодпись.ТипПодписи) Тогда
			Прервать;
		КонецЕсли;
		
		Если Не ЕстьБазоваяПодпись И ЭлектроннаяПодписьСлужебныйКлиентСервер.ПодлежитУсовершенствованию(
				ТекущаяПодпись.ТипПодписи, Перечисления.ТипыПодписиКриптографии.СМеткойДоверенногоВремениCAdEST) Тогда
			ЕстьБазоваяПодпись = Истина;
			Продолжить;
		КонецЕсли;
		
		Если Не ЕстьПодписьСМеткойВремени И ЭлектроннаяПодписьСлужебныйКлиентСервер.ПодлежитУсовершенствованию(
				ТекущаяПодпись.ТипПодписи, Перечисления.ТипыПодписиКриптографии.АрхивнаяCAdESAv3) Тогда
			ЕстьПодписьСМеткойВремени = Истина;
			Продолжить;
		КонецЕсли;
		
		Если Не ЕстьАрхивнаяПодпись
			И (ТекущаяПодпись.ТипПодписи = Перечисления.ТипыПодписиКриптографии.CAdESAv2
			Или ТекущаяПодпись.ТипПодписи = Перечисления.ТипыПодписиКриптографии.АрхивнаяCAdESAv3) Тогда
			ЕстьАрхивнаяПодпись = Истина;
			Продолжить;
		КонецЕсли;
		
	КонецЦикла;
	
	Если ЕстьАрхивнаяПодпись Тогда
		Если Не ЕстьБазоваяПодпись И Не ЕстьПодписьСМеткойВремени Тогда
			Элементы.ДобавитьАрхивнуюМеткуВремени.Видимость = Ложь;
			Элементы.ДекорацияДобавлениеМетокВремени.Видимость = Истина; 
			Элементы.ДекорацияДобавлениеМетокВремени.Заголовок = НСтр("ru = 'В подписи будут добавлены архивные метки времени';
																		|en = 'Archive timestamps will be added to the signatures'");
			Элементы.ТипПодписи.Видимость = Ложь;
			ДобавитьАрхивнуюМеткуВремени = Истина;
		Иначе
			Элементы.ДобавитьАрхивнуюМеткуВремени.Видимость = Истина;
		КонецЕсли;
	ИначеЕсли ЕстьПодписьСМеткойВремени Или ЕстьБазоваяПодпись Тогда
		Элементы.ДобавитьАрхивнуюМеткуВремени.Видимость = Ложь;
	КонецЕсли;
	
	Если ЕстьБазоваяПодпись Тогда
		Параметры.ТипПодписи = Перечисления.ТипыПодписиКриптографии.БазоваяCAdESBES;
		Элементы.ТипПодписи.Видимость = Истина;
	ИначеЕсли ЕстьПодписьСМеткойВремени Тогда
		Параметры.ТипПодписи = Перечисления.ТипыПодписиКриптографии.СМеткойДоверенногоВремениCAdEST;
		Элементы.ТипПодписи.Видимость = Истина;
	ИначеЕсли ЕстьАрхивнаяПодпись Тогда
		Параметры.ТипПодписи = Перечисления.ТипыПодписиКриптографии.АрхивнаяCAdESAv3;
		Элементы.ТипПодписи.Видимость = Ложь;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти