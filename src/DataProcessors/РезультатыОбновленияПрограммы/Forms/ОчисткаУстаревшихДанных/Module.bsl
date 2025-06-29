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
	
	УстановитьУсловноеОформление();
	
	ОчиститьИЗакрыть = Параметры.ОчиститьИЗакрыть;
	Элементы.КоманднаяПанельДиалога.Видимость = Ложь;
	
	ОбновитьВидимостьДоступность(ЭтотОбъект, Истина);
	
	Если ОчиститьИЗакрыть Тогда
		ЧиститьУдаляемые = Ложь;
		Элементы.ПредупреждениеНадпись.Заголовок =
			НСтр("ru = 'Отложенное обновление <a href = %1>не завершено</a>. Рекомендуется завершить обновление и выполнить очистку перед обновлением конфигурации.';
				|en = 'The deferred update is <a href = %1>not completed</a>. We recommend that you complete the update and clear data before the configuration update.'");
		СтандартныеПодсистемыСервер.СброситьРазмерыИПоложениеОкна(ЭтотОбъект);
		Элементы.ГруппаПояснение.Видимость = Ложь;
		Элементы.ОбрабатыватьОбластиДанных.Видимость = Ложь;
		Элементы.КоманднаяПанельФормы.Видимость = Ложь;
		Если ОтложенноеОбновлениеЗавершено Тогда
			ДлительнаяОперацияОчистки = НачатьОчисткуНаСервере();
		Иначе
			ДлительнаяОперацияОбновления = НачатьОбновлениеНаСервере();
			Элементы.ГруппаПредупреждение.Видимость = Ложь;
		КонецЕсли;
	Иначе
		НавигационнаяСсылка = "e1cib/app/Обработка.РезультатыОбновленияПрограммы.Форма.ОчисткаУстаревшихДанных";
		ДлительнаяОперацияОбновления = НачатьОбновлениеНаСервере();
		Элементы.УстаревшиеДанныеОбластьДанных.Формат = "ЧН=0";
	КонецЕсли;
	
	Элементы.ПредупреждениеНадпись.Заголовок = СтроковыеФункции.ФорматированнаяСтрока(
		Элементы.ПредупреждениеНадпись.Заголовок, "ОткрытьРезультатыОбновления");
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаВМоделиСервиса.ОбновлениеВерсииИБВМоделиСервиса") Тогда
		МодульОбновлениеИнформационнойБазыСлужебныйВМоделиСервиса = ОбщегоНазначения.ОбщийМодуль("ОбновлениеИнформационнойБазыСлужебныйВМоделиСервиса");
		ОтчетПрогрессОбновления = МодульОбновлениеИнформационнойБазыСлужебныйВМоделиСервиса.ОтчетПрогрессОбновления();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Не ОчиститьИЗакрыть
	 Или Не ОтложенноеОбновлениеЗавершено Тогда
		Обновить(Неопределено);
	Иначе
		Очистить(Неопределено);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	ОтменитьДлительныеОперации();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ВыполненВыходИзОбластиДанных"
	 Или ИмяСобытия = "ВыполненВходВОбластьДанных" Тогда
		
		ПодключитьОбработчикОжидания("ПриИзмененииОбластиДанных", 0.1, Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПредупреждениеНадписьОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если НавигационнаяСсылкаФорматированнойСтроки <> "ОткрытьРезультатыОбновления" Тогда
		Возврат;
	КонецЕсли;
	
	Если НеразделенныйРежим И ЗначениеЗаполнено(ОтчетПрогрессОбновления) Тогда
		ОткрытьФорму(ОтчетПрогрессОбновления);
	Иначе
		ОткрытьФорму("Обработка.РезультатыОбновленияПрограммы.Форма");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбрабатыватьОбластиДанныхПриИзменении(Элемент)
	
	УстаревшиеДанные.Очистить();
	ОбновитьВидимостьДоступность(ЭтотОбъект, Истина);
	Обновить("");
	
КонецПроцедуры

&НаКлиенте
Процедура ВывестиКоличествоПриИзменении(Элемент)
	
	Если ВывестиКоличество Тогда
		УстаревшиеДанные.Очистить();
	КонецЕсли;
	
	ОбновитьВидимостьДоступность(ЭтотОбъект);
	Обновить("");
	
КонецПроцедуры

&НаКлиенте
Процедура ЧиститьУдаляемыеПриИзменении(Элемент)
	
	УстаревшиеДанные.Очистить();
	Обновить("");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПродолжитьБезОчистки(Команда)
	Закрыть(Истина);
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьОбновлениеКонфигурации(Команда)
	Закрыть(Ложь);
КонецПроцедуры

&НаКлиенте
Процедура Обновить(Команда)
	
	Элементы.ОбрабатыватьОбластиДанных.Доступность = Истина;
	Элементы.ВывестиКоличество.Доступность = Истина;
	Элементы.ЧиститьУдаляемые.Доступность = Истина;
	
	Если Команда <> Неопределено Тогда
		ДлительнаяОперацияОбновления = НачатьОбновлениеНаСервере();
	КонецЕсли;
	
	УстановитьПрогресс(0);
	
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
	ПараметрыОжидания.ОповещениеОПрогрессеВыполнения =
		Новый ОписаниеОповещения("ОбновитьПриПолученииПрогресса",
			ЭтотОбъект, ДлительнаяОперацияОбновления);
	
	ОповещениеОЗавершении = Новый ОписаниеОповещения("ОбновитьЗавершение",
		ЭтотОбъект, ДлительнаяОперацияОбновления);
	
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперацияОбновления,
		ОповещениеОЗавершении, ПараметрыОжидания);
	
КонецПроцедуры

&НаКлиенте
Процедура Очистить(Команда)
	
	Если ОтложенноеОбновлениеЗавершено Тогда
		ОчиститьПослеПодтверждения(Новый Структура("Значение", "Продолжить"), Команда);
		Возврат;
	КонецЕсли;
	
	ОбработкаЗавершения = Новый ОписаниеОповещения(
		"ОчиститьПослеПодтверждения", ЭтотОбъект, Команда);
	
	ТекстВопроса =
		НСтр("ru = 'Отложенное обновление не завершено.
		           |Очистка может удалить данные, которые требуются для завершения обновления.
		           |
		           |Сделайте резервную копию, если она еще не сделана.';
		           |en = 'The deferred update is not completed.
		           |The cleanup might delete data required to complete the update.
		           |
		           |Create a backup if you have not done it yet.'");
	
	Кнопки = Новый СписокЗначений;
	Кнопки.Добавить("Продолжить", НСтр("ru = 'Продолжить';
										|en = 'Continue'"));
	Кнопки.Добавить("Отмена",     НСтр("ru = 'Отмена';
										|en = 'Cancel'"));
	
	ДополнительныеПараметры = СтандартныеПодсистемыКлиент.ПараметрыВопросаПользователю();
	ДополнительныеПараметры.Заголовок = НСтр("ru = 'Очистка устаревших данных';
											|en = 'Clear obsolete data'");
	ДополнительныеПараметры.ПредлагатьБольшеНеЗадаватьЭтотВопрос = Ложь;
	ДополнительныеПараметры.КнопкаПоУмолчанию = "Отмена";
	
	СтандартныеПодсистемыКлиент.ПоказатьВопросПользователю(ОбработкаЗавершения,
		ТекстВопроса, Кнопки, ДополнительныеПараметры);
	
КонецПроцедуры

&НаКлиенте
Процедура ПланОчистки(Команда)
	
	ТекстовыйДокумент = Новый ТекстовыйДокумент;
	ТекстовыйДокумент.УстановитьТекст(ПланОчисткиНаСервере(ЧиститьУдаляемые, ОбрабатыватьОбластиДанных));
	ТекстовыйДокумент.Показать(НСтр("ru = 'План очистки устаревших данных';
									|en = 'Obsolete data cleanup plan'"));
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.УстаревшиеДанныеОбластьДанных.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("УстаревшиеДанные.ОбластьДанных");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = -1;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'Общие данные';
																|en = 'Shared data'"));
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьВидимостьДоступность(Форма, ОбновитьРезультатОтложенногоОбновления = Ложь)

	Элементы = Форма.Элементы;
	
	Если ОбновитьРезультатОтложенногоОбновления Тогда
		Форма.ОтложенноеОбновлениеЗавершено = ОтложенноеОбновлениеЗавершено(Форма.НеразделенныйРежим);
	КонецЕсли;
	Элементы.ГруппаПредупреждение.Видимость = Не Форма.ОтложенноеОбновлениеЗавершено;
	
	Элементы.ОбрабатыватьОбластиДанных.Видимость = Форма.НеразделенныйРежим;
	Элементы.УстаревшиеДанныеОбластьДанных.Видимость =
		Форма.НеразделенныйРежим И Форма.ОбрабатыватьОбластиДанных;
	
	Элементы.УстаревшиеДанныеКоличество.Видимость = Форма.ВывестиКоличество;
	Элементы.УстаревшиеДанные.Шапка =
		    Элементы.УстаревшиеДанныеКоличество.Видимость
		Или Элементы.УстаревшиеДанныеОбластьДанных.Видимость;
	
	Элементы.УстаревшиеДанные.ВысотаШапки =
		?(Элементы.УстаревшиеДанныеКоличество.Видимость, 2, 1);
	
	Элементы.ФормаОчистить.Доступность = Форма.УстаревшиеДанные.Количество() > 0;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ОтложенноеОбновлениеЗавершено(НеразделенныйРежим)
	
	НеразделенныйРежим = Не ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных();
	
	Возврат ОбновлениеИнформационнойБазыСлужебный.ОтложенноеОбновлениеЗавершено();
	
КонецФункции

&НаКлиенте
Процедура ПриИзмененииОбластиДанных()
	
	Обновить("");
	
КонецПроцедуры

&НаСервере
Процедура ОтменитьДлительныеОперации()
	
	Если ДлительнаяОперацияОбновления <> Неопределено Тогда
		ДлительныеОперации.ОтменитьВыполнениеЗадания(
			ДлительнаяОперацияОбновления.ИдентификаторЗадания);
		ДлительнаяОперацияОбновления = Неопределено;
	КонецЕсли;
	
	Если ДлительнаяОперацияОчистки <> Неопределено Тогда
		ДлительныеОперации.ОтменитьВыполнениеЗадания(
			ДлительнаяОперацияОчистки.ИдентификаторЗадания);
		ДлительнаяОперацияОчистки = Неопределено;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(АдресРезультатаОбновления) Тогда
		УдалитьИзВременногоХранилища(АдресРезультатаОбновления);
		АдресРезультатаОбновления = "";
	КонецЕсли;
	
	Если ЗначениеЗаполнено(АдресРезультатаОчистки) Тогда
		УдалитьИзВременногоХранилища(АдресРезультатаОчистки);
		АдресРезультатаОчистки = "";
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПрогресс(Процент)
	
	Элементы.ДлительнаяОперацияПроцент.Заголовок = 
		Формат(Процент, "ЧН=0") + "%";
	
КонецПроцедуры


&НаСервере
Функция НачатьОбновлениеНаСервере()
	
	ОбновитьВидимостьДоступность(ЭтотОбъект, Истина);
	
	УстаревшиеДанные.Очистить();
	
	Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаДлительнаяОперация;
	Элементы.ДлительнаяОперацияТекст.Заголовок =
		НСтр("ru = 'Обновление списка устаревших данных ...';
			|en = 'Updating the obsolete data list...'");
	
	ОтменитьДлительныеОперации();
	
	АдресРезультатаОбновления = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.ОжидатьЗавершение = 0;
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Обновление списка устаревших данных';
															|en = 'Update the obsolete data list'");
	ПараметрыВыполнения.АдресРезультата = АдресРезультатаОбновления;
	ПараметрыВыполнения.СРасширениямиБазыДанных = Истина;
	
	ПараметрыЗадания = Новый Структура;
	ПараметрыЗадания.Вставить("ВывестиКоличество", ВывестиКоличество);
	ПараметрыЗадания.Вставить("ЧиститьУдаляемые", ЧиститьУдаляемые);
	ПараметрыЗадания.Вставить("ОбрабатыватьОбластиДанных", ОбрабатыватьОбластиДанных);
	
	Результат = ДлительныеОперации.ВыполнитьВФоне(
		"ОбновлениеИнформационнойБазыСлужебный.СформироватьСписокУстаревшихДанныхВФоне",
		ПараметрыЗадания, ПараметрыВыполнения);
		
	Возврат Результат;
	
КонецФункции

// Параметры:
//  Результат - см. ДлительныеОперацииКлиент.НовоеСостояниеДлительнойОперации
//  ДополнительныеПараметры - Неопределено
//
&НаКлиенте
Процедура ОбновитьПриПолученииПрогресса(Результат, ДополнительныеПараметры) Экспорт
	
	Если ДополнительныеПараметры <> ДлительнаяОперацияОбновления Тогда
		Возврат;
	КонецЕсли;
	
	Если Результат.Прогресс <> Неопределено Тогда
		УстановитьПрогресс(Результат.Прогресс.Процент);
	КонецЕсли;
	
КонецПроцедуры

// Параметры:
//  Результат - см. ДлительныеОперацииКлиент.НовыйРезультатДлительнойОперации
//  ДополнительныеПараметры - Неопределено
//
&НаКлиенте
Процедура ОбновитьЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если ДополнительныеПараметры <> ДлительнаяОперацияОбновления Тогда
		Возврат;
	КонецЕсли;
	
	ИнформацияОбОшибке = Неопределено;
	ЕстьОшибка = Ложь;
	ЗавершитьОбновлениеНаСервере(Результат, ЕстьОшибка);
	
	Если ИнформацияОбОшибке <> Неопределено Тогда
		СтандартныеПодсистемыКлиент.ВывестиИнформациюОбОшибке(ИнформацияОбОшибке);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ТекстОшибки) Тогда
		ПоказатьПредупреждение(, ТекстОшибки);
	КонецЕсли;
	
	Если Не ОчиститьИЗакрыть Тогда
		ОбновитьВидимостьДоступность(ЭтотОбъект);
		Возврат;
	КонецЕсли;
	
	Если ЕстьОшибка Или УстаревшиеДанные.Количество() > 0 Тогда
		ОбновитьВидимостьДоступность(ЭтотОбъект);
		Элементы.Страницы.Видимость = Ложь;
		Элементы.КоманднаяПанельДиалога.Видимость = Истина;
		Элементы.ОтменитьОбновлениеКонфигурации.КнопкаПоУмолчанию = Истина;
		Возврат;
	КонецЕсли;
	
	Закрыть(Истина);
	
КонецПроцедуры

&НаСервере
Процедура ЗавершитьОбновлениеНаСервере(Знач Результат, ЕстьОшибка)
	
	ДлительнаяОперацияОбновления = Неопределено;
	Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаУстаревшиеДанные;
	
	Если ЗначениеЗаполнено(АдресРезультатаОбновления) Тогда
		Данные = ПолучитьИзВременногоХранилища(АдресРезультатаОбновления);
		УдалитьИзВременногоХранилища(АдресРезультатаОбновления);
		АдресРезультатаОбновления = "";
	Иначе
		Данные = Неопределено;
	КонецЕсли;
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекстОшибки = "";
	
	Если Результат.Статус = "Ошибка" Тогда
		ИнформацияОбОшибке = Результат.ИнформацияОбОшибке;
	ИначеЕсли ТипЗнч(Данные) = Тип("ИнформацияОбОшибке") Тогда
		ИнформацияОбОшибке = Данные;
	ИначеЕсли Данные = Неопределено Тогда
		ТекстОшибки = НСтр("ru = 'Фоновое задание не вернуло результат.
			|Повторите попытку, нажав на кнопку Обновить.';
			|en = 'Background job returned nothing.
			|Click ""Refresh"" to try again.'");
	КонецЕсли;
	
	Если ИнформацияОбОшибке <> Неопределено Тогда
		ЕстьОшибка = Истина;
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ТекстОшибки) Тогда
		ЕстьОшибка = Истина;
		Возврат;
	КонецЕсли;
	
	Для Каждого Строка Из Данные Цикл
		ЗаполнитьЗначенияСвойств(УстаревшиеДанные.Добавить(), Строка);
	КонецЦикла;
	
КонецПроцедуры


&НаКлиенте
Процедура ОчиститьПослеПодтверждения(Ответ, Команда) Экспорт
	
	Если Не ЗначениеЗаполнено(Ответ)
	 Или Ответ.Значение <> "Продолжить" Тогда
		Возврат;
	КонецЕсли;
	
	Если Команда <> Неопределено Тогда
		ДлительнаяОперацияОчистки = НачатьОчисткуНаСервере();
	КонецЕсли;
	
	УстановитьПрогресс(0);
	
	Элементы.ОбрабатыватьОбластиДанных.Доступность = Ложь;
	Элементы.ВывестиКоличество.Доступность = Ложь;
	Элементы.ЧиститьУдаляемые.Доступность = Ложь;
	Элементы.ФормаОчистить.Доступность = Ложь;
	
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
	ПараметрыОжидания.ОповещениеОПрогрессеВыполнения =
		Новый ОписаниеОповещения("ОчиститьПриПолученииПрогресса",
			ЭтотОбъект, ДлительнаяОперацияОчистки);
	
	ОповещениеОЗавершении = Новый ОписаниеОповещения("ОчиститьЗавершение",
		ЭтотОбъект, ДлительнаяОперацияОчистки);
	
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперацияОчистки,
		ОповещениеОЗавершении, ПараметрыОжидания);
	
КонецПроцедуры

&НаСервере
Функция НачатьОчисткуНаСервере()
	
	ОбновлениеИнформационнойБазыСлужебный.ОтменитьРегламентноеЗаданиеОчисткаУстаревшихДанных();
	
	Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаДлительнаяОперация;
	Элементы.ДлительнаяОперацияТекст.Заголовок =
		НСтр("ru = 'Очистка устаревших данных ...';
			|en = 'Clearing obsolete data...'");
	
	ОтменитьДлительныеОперации();
	
	АдресРезультатаОчистки = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.ОжидатьЗавершение = 0;
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Очистка устаревших данных';
															|en = 'Clear obsolete data'");
	ПараметрыВыполнения.АдресРезультата = АдресРезультатаОчистки;
	ПараметрыВыполнения.СРасширениямиБазыДанных = Истина;
	ПараметрыВыполнения.КлючФоновогоЗадания = ОбновлениеИнформационнойБазыСлужебный.КлючЗаданияОчисткиУстаревшихДанных();
	
	Если ОбщегоНазначения.РазделениеВключено() Тогда
		ПараметрыЗадания = Новый Структура;
		ПараметрыЗадания.Вставить("ЧиститьУдаляемые", ЧиститьУдаляемые);
		ПараметрыЗадания.Вставить("ОбрабатыватьОбластиДанных", ОбрабатыватьОбластиДанных);
		
		Результат = ДлительныеОперации.ВыполнитьВФоне(
			"ОбновлениеИнформационнойБазыСлужебный.ОчиститьУстаревшиеДанныеВФоне",
			ПараметрыЗадания, ПараметрыВыполнения);
	Иначе
		НаборПараметровПроцедуры = Новый Структура;
		НаборПараметровПроцедуры.Вставить("Контекст", Новый Структура("ЧиститьУдаляемые", ЧиститьУдаляемые));
		НаборПараметровПроцедуры.Вставить("ИмяМетодаПолученияПорций",
			"ОбновлениеИнформационнойБазыСлужебный.УстаревшиеДанныеПриЗапросеПорцийВФоне");
		
		Результат = ДлительныеОперации.ВыполнитьПроцедуруВНесколькоПотоков(
			"ОбновлениеИнформационнойБазыСлужебный.УстаревшиеДанныеПриОчисткеПорцииВФоне",
			ПараметрыВыполнения, НаборПараметровПроцедуры);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Параметры:
//  Результат - см. ДлительныеОперацииКлиент.НовоеСостояниеДлительнойОперации
//  ДополнительныеПараметры - Неопределено
//
&НаКлиенте
Процедура ОчиститьПриПолученииПрогресса(Результат, ДополнительныеПараметры) Экспорт
	
	Если ДополнительныеПараметры <> ДлительнаяОперацияОчистки Тогда
		Возврат;
	КонецЕсли;
	
	Если Результат.Прогресс <> Неопределено Тогда
		УстановитьПрогресс(Результат.Прогресс.Процент);
	КонецЕсли;
	
КонецПроцедуры

// Параметры:
//  Результат - см. ДлительныеОперацииКлиент.НовыйРезультатДлительнойОперации
//  ДополнительныеПараметры - Неопределено
//
&НаКлиенте
Процедура ОчиститьЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если ДополнительныеПараметры <> ДлительнаяОперацияОчистки Тогда
		Возврат;
	КонецЕсли;
	
	ИнформацияОбОшибке = Неопределено;
	ЕстьОшибка = Ложь;
	ЗавершитьОчисткуНаСервере(Результат, ЕстьОшибка);
	
	Если ИнформацияОбОшибке <> Неопределено Тогда
		СтандартныеПодсистемыКлиент.ВывестиИнформациюОбОшибке(ИнформацияОбОшибке);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ТекстОшибки) Тогда
		ПоказатьПредупреждение(, ТекстОшибки);
	КонецЕсли;
	
	Если ЕстьОшибка Тогда
		Возврат;
	КонецЕсли;
	
	Если ОчиститьИЗакрыть Тогда
		Закрыть(Истина);
	Иначе
		Обновить("");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗавершитьОчисткуНаСервере(Знач Результат, ЕстьОшибка)
	
	ДлительнаяОперацияОчистки = Неопределено;
	Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаУстаревшиеДанные;
	
	Если ЗначениеЗаполнено(АдресРезультатаОчистки) Тогда
		Результаты = ПолучитьИзВременногоХранилища(АдресРезультатаОчистки);
		УдалитьИзВременногоХранилища(АдресРезультатаОчистки);
		АдресРезультатаОчистки = "";
	Иначе
		Результаты = Неопределено;
	КонецЕсли;
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(Результаты) = Тип("ИнформацияОбОшибке") Тогда
		ИнформацияОбОшибке = Результаты;
		ЕстьОшибка = Истина;
		Возврат;
	КонецЕсли;
	
	ТекстОшибки = "";
	
	Если Результат.Статус = "Ошибка" Тогда
		ИнформацияОбОшибке = Результат.ИнформацияОбОшибке;
	Иначе
		ТекстОшибки = ОбновлениеИнформационнойБазыСлужебный.ТекстОшибкиОчисткиУстаревшихДанных(Результаты);
	КонецЕсли;
	
	Если ИнформацияОбОшибке <> Неопределено Или ЗначениеЗаполнено(ТекстОшибки) Тогда
		ЕстьОшибка = Истина;
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПланОчисткиНаСервере(ЧиститьУдаляемые, ОбрабатыватьОбластиДанных)
	
	Возврат ОбновлениеИнформационнойБазыСлужебный.ПланОчисткиУстаревшихДанных(
		ЧиститьУдаляемые,, Не ОбрабатыватьОбластиДанных);
	
КонецФункции

#КонецОбласти
