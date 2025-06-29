#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Параметры.Свойство("ТипОбъектаДО", ТипОбъектаДО);
	Параметры.Свойство("ТипОбъектаИС", ТипОбъектаИС);
	Параметры.Свойство("ВидДокументаДО", ВидДокументаДО);
	Параметры.Свойство("Вариант", Вариант);
	Параметры.Свойство("ЭтоПолноправныйПользователь", ЭтоПолноправныйПользователь);
	Параметры.Свойство("ПредставлениеРеквизитаОбъектаИС", ПредставлениеРеквизитаОбъектаИС);
	Параметры.Свойство("ТипРеквизитаОбъектаИС", ТипРеквизитаОбъектаИС);
	Параметры.Свойство("ИмяРеквизитаОбъектаДО", ИмяРеквизитаОбъектаДО);
	Параметры.Свойство("ПредставлениеРеквизитаОбъектаДО", ПредставлениеРеквизитаОбъектаДО);
	Параметры.Свойство("РеквизитыОбъектаДО", РеквизитыОбъектаДО);
	Параметры.Свойство("ЗначениеРеквизитаИС", ЗначениеРеквизитаИС);
	Параметры.Свойство("ВычисляемоеВыражение", ВычисляемоеВыражение);
	Параметры.Свойство("Обновлять", Обновлять);
	Параметры.Свойство("ОбновлятьРодитель", ОбновлятьРодитель);
	Параметры.Свойство("Зависимый", Зависимый);
	Параметры.Свойство("РежимИзмененияДанныхПроведенногоДокумента", РежимИзмененияДанныхПроведенногоДокумента);
	Если Не ЗначениеЗаполнено(РежимИзмененияДанныхПроведенногоДокумента) Тогда
		РежимИзмененияДанныхПроведенногоДокумента =
			Перечисления.РежимИзмененияПроведенногоДокументаДанными1СДокументооборота.Запрещено;
	КонецЕсли;
	
	Параметры.Свойство("ЭтоДополнительныйРеквизитДО", ЭтоДополнительныйРеквизитДО);
	Параметры.Свойство("ДополнительныйРеквизитДОID", ДополнительныйРеквизитДОID);
	Параметры.Свойство("ДополнительныйРеквизитДОТип", ДополнительныйРеквизитДОТип);
	Параметры.Свойство("ЭтоДополнительныйРеквизитИС", ЭтоДополнительныйРеквизитИС);
	Параметры.Свойство("ДополнительныйРеквизитИС", ДополнительныйРеквизитИС);
	
	Параметры.Свойство("Ключевой", Ключевой);
	Параметры.Свойство("Таблица", Таблица);
	
	РеквизитОбъекта = ПредопределенноеЗначение("Перечисление.ВариантыПравилЗаполненияРеквизитов.РеквизитОбъекта");
	УказанноеЗначение = ПредопределенноеЗначение("Перечисление.ВариантыПравилЗаполненияРеквизитов.УказанноеЗначение");
	ВыражениеНаВстроенномЯзыке =
		ПредопределенноеЗначение("Перечисление.ВариантыПравилЗаполненияРеквизитов.ВыражениеНаВстроенномЯзыке");
	НеЗаполнять = ПредопределенноеЗначение("Перечисление.ВариантыПравилЗаполненияРеквизитов.ПустаяСсылка");
	
	// Выберем вариант по умолчанию.
	Если Не ЗначениеЗаполнено(Вариант) И Не Ключевой Тогда
		Обновлять = Истина;
	КонецЕсли;
	
	Если Зависимый Тогда
		Обновлять = ОбновлятьРодитель;
	КонецЕсли;
	
	ЗначениеРеквизитаИС = ТипРеквизитаОбъектаИС.ПривестиЗначение(ЗначениеРеквизитаИС);
	
	ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиентСервер.НастроитьПолеВводаПоТипу(
		Элементы.ЗначениеРеквизитаИС,
		ТипРеквизитаОбъектаИС);
	
	СокращенноеНаименованиеКонфигурации =
		ИнтеграцияС1СДокументооборотБазоваяФункциональность.СокращенноеНаименованиеКонфигурации();
	Если ЗначениеЗаполнено(СокращенноеНаименованиеКонфигурации) Тогда
		Заголовок = СтрШаблон(НСтр("ru = 'Правило заполнения реквизита %1';
									|en = '%1 attribute filling rule'"), СокращенноеНаименованиеКонфигурации);
	КонецЕсли;
	
	// Ограничим выбор вариантов заполнения и флажка Ключевой.
	Если Вариант = ВыражениеНаВстроенномЯзыке Или Вариант = РеквизитОбъекта Или Вариант = НеЗаполнять Тогда
		Элементы.Ключевой.Доступность = Ложь;
	Иначе
		Элементы.Ключевой.Доступность = Истина;
	КонецЕсли;
	ДоступенФункционалОбмен = ИнтеграцияС1СДокументооборотБазоваяФункциональностьПовтИсп.ДоступенФункционалВерсииСервиса(
		"1.3.2.3.CORP");
	Элементы.Обновлять.Видимость = ДоступенФункционалОбмен;
	Элементы.РежимИзмененияДанныхПроведенногоДокумента.Видимость =
		(Параметры.ЗаполняетсяДокумент И ДоступенФункционалОбмен);
	
	// Установим доступные режимы изменения в проведенном документе.
	Элементы.РежимИзмененияДанныхПроведенногоДокумента.СписокВыбора.Добавить(
		Перечисления.РежимИзмененияПроведенногоДокументаДанными1СДокументооборота.РазрешеноСПерепроведением);
	Элементы.РежимИзмененияДанныхПроведенногоДокумента.СписокВыбора.Добавить(
		Перечисления.РежимИзмененияПроведенногоДокументаДанными1СДокументооборота.РазрешеноБезПерепроведения);
	Элементы.РежимИзмененияДанныхПроведенногоДокумента.СписокВыбора.Добавить(
		Перечисления.РежимИзмененияПроведенногоДокументаДанными1СДокументооборота.Запрещено);
	ИнтеграцияС1СДокументооборотБазоваяФункциональностьПереопределяемый.УстановитьРежимыИзмененияВПроведенномДокументе(
		ТипОбъектаИС,
		ПредставлениеРеквизитаОбъектаИС,
		Элементы.РежимИзмененияДанныхПроведенногоДокумента.СписокВыбора);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьДоступность();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КлючевойПриИзменении(Элемент)
	
	Если Ключевой Тогда
		Вариант = УказанноеЗначение;
		УстановитьДоступность();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВариантПриИзменении(Элемент)
	
	Если Вариант = ВыражениеНаВстроенномЯзыке Или Вариант = РеквизитОбъекта Или Вариант = НеЗаполнять Тогда
		Ключевой = Ложь;
		Элементы.Ключевой.Доступность = Ложь;
	Иначе
		Элементы.Ключевой.Доступность = Истина;
	КонецЕсли;
	
	Если Зависимый Тогда
		Обновлять = ОбновлятьРодитель;
	Иначе
		Обновлять =
			ДоступенФункционалОбмен
			И (Обновлять Или Вариант = РеквизитОбъекта)
			И Не (Вариант = НеЗаполнять)
			И Не (Вариант = УказанноеЗначение);
	КонецЕсли;
	
	УстановитьДоступность();
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеРеквизитаОбъектаДОНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ВыбратьРеквизитОбъектаДокументооборота();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗначениеРеквизитаИСНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Если ТипЗнч(ЗначениеРеквизитаИС) = Тип("Число")
		Или ТипЗнч(ЗначениеРеквизитаИС) = Тип("Дата")
		Или ТипЗнч(ЗначениеРеквизитаИС) = Тип("Булево") Тогда
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	
	Оповещение = Новый ОписаниеОповещения("ВыбратьЗначениеРеквизитаИСЗавершениеВводаЗначения", ЭтотОбъект);
	ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ВыбратьЗначениеРеквизитаИС(
		ЭтотОбъект,
		Элементы.ЗначениеРеквизитаИС,
		ТипРеквизитаОбъектаИС,
		ПредставлениеРеквизитаОбъектаИС,
		ЗначениеРеквизитаИС,
		Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьЗначениеРеквизитаИСЗавершениеВводаЗначения(Результат, ПараметрыОповещения) Экспорт
	
	Если Результат <> Неопределено Тогда
		ЗначениеРеквизитаИС = Результат;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВычисляемоеВыражениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ВыбратьВычисляемоеВыражение();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	Если Не ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	Результат = Новый Структура;
	Результат.Вставить("ИмяРеквизитаОбъектаДО");
	Результат.Вставить("ПредставлениеРеквизитаОбъектаДО");
	Результат.Вставить("ЗначениеРеквизитаИС");
	Результат.Вставить("ВычисляемоеВыражение");
	Результат.Вставить("Картинка");
	
	Если Вариант = РеквизитОбъекта Тогда
		Результат.ИмяРеквизитаОбъектаДО = ИмяРеквизитаОбъектаДО;
		Результат.ПредставлениеРеквизитаОбъектаДО = ПредставлениеРеквизитаОбъектаДО;
		Результат.Картинка = 1;
		
	ИначеЕсли Вариант = УказанноеЗначение Тогда
		Результат.ЗначениеРеквизитаИС = ЗначениеРеквизитаИС;
		Результат.Картинка = 2;
		
	ИначеЕсли Вариант = ВыражениеНаВстроенномЯзыке Тогда
		Результат.ВычисляемоеВыражение = ВычисляемоеВыражение;
		Результат.Картинка = 3;
		
	КонецЕсли;
	
	Результат.Вставить("Вариант", Вариант);
	Результат.Вставить("Обновлять", Обновлять);
	Результат.Вставить("ЭтоДополнительныйРеквизитДО", ЭтоДополнительныйРеквизитДО);
	Результат.Вставить("ДополнительныйРеквизитДОID", ДополнительныйРеквизитДОID);
	Результат.Вставить("ДополнительныйРеквизитДОТип", ДополнительныйРеквизитДОТип);
	Результат.Вставить("Ключевой", Ключевой);
	Результат.Вставить("РежимИзмененияДанныхПроведенногоДокумента", РежимИзмененияДанныхПроведенногоДокумента);
	
	Закрыть(Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ВыбратьРеквизитОбъектаДокументооборота()
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ТипОбъектаДО", ТипОбъектаДО);
	ПараметрыФормы.Вставить("РеквизитыОбъектаДО", РеквизитыОбъектаДО);
	ПараметрыФормы.Вставить("ИмяРеквизитаОбъектаДО", ИмяРеквизитаОбъектаДО);
	ПараметрыФормы.Вставить("ПредставлениеРеквизитаОбъектаИС", ПредставлениеРеквизитаОбъектаИС);
	ПараметрыФормы.Вставить("Таблица", Таблица);
	ПараметрыФормы.Вставить("ЭтоТаблица", Ложь);
	
	Оповещение = Новый ОписаниеОповещения("ВыбратьРеквизитОбъектаДокументооборотаЗавершение", ЭтотОбъект);
	
	ОткрытьФорму("Обработка.ИнтеграцияС1СДокументооборотБазоваяФункциональность.Форма.ВыборРеквизитаДокументооборота",
		ПараметрыФормы, ЭтотОбъект,,,, Оповещение, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьРеквизитОбъектаДокументооборотаЗавершение(Результат, ПараметрыОповещения) Экспорт

	Если ТипЗнч(Результат) = Тип("Структура") Тогда
		Результат.Свойство("Имя", ИмяРеквизитаОбъектаДО);
		Результат.Свойство("Представление", ПредставлениеРеквизитаОбъектаДО);
		Результат.Свойство("ЭтоДополнительныйРеквизитДО", ЭтоДополнительныйРеквизитДО);
		Результат.Свойство("ДополнительныйРеквизитДОID", ДополнительныйРеквизитДОID);
		Результат.Свойство("ДополнительныйРеквизитДОТип", ДополнительныйРеквизитДОТип);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ВыбратьВычисляемоеВыражение()
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ВычисляемоеВыражение", ВычисляемоеВыражение);
	ПараметрыФормы.Вставить("ТипВыражения", "ПравилоЗагрузки");
	ПараметрыФормы.Вставить("ТипОбъектаДО", ТипОбъектаДО);
	ПараметрыФормы.Вставить("ТипОбъектаИС", ТипОбъектаИС);
	ПараметрыФормы.Вставить("ЭтоТаблица", Ложь);
	ПараметрыФормы.Вставить("ВидДокументаДО", ВидДокументаДО);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыбратьВычисляемоеВыражениеЗавершение", ЭтотОбъект);
	
	ОткрытьФорму("Справочник.ПравилаИнтеграцииС1СДокументооборотом.Форма.ВыражениеНаВстроенномЯзыке",
		ПараметрыФормы, ЭтотОбъект,,,, ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьВычисляемоеВыражениеЗавершение(Результат, ПараметрыОповещения) Экспорт
	
	Если ТипЗнч(Результат) = Тип("Строка") Тогда
		ВычисляемоеВыражение = Результат;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДоступность()
	
	Элементы.ПредставлениеРеквизитаОбъектаДО.Доступность = (Вариант = РеквизитОбъекта);
	Элементы.ПредставлениеРеквизитаОбъектаДО.АвтоОтметкаНезаполненного =
		(Вариант = РеквизитОбъекта);
	Элементы.ПредставлениеРеквизитаОбъектаДО.ОтметкаНезаполненного =
		(Вариант = РеквизитОбъекта) И Не ЗначениеЗаполнено(ПредставлениеРеквизитаОбъектаДО);
	
	Элементы.ЗначениеРеквизитаИС.Доступность = (Вариант = УказанноеЗначение);
	Элементы.ЗначениеРеквизитаИС.АвтоОтметкаНезаполненного = (Вариант = УказанноеЗначение);
	Элементы.ЗначениеРеквизитаИС.ОтметкаНезаполненного =
		(Вариант = УказанноеЗначение) И Не ЗначениеЗаполнено(ЗначениеРеквизитаИС);
	
	Элементы.ВычисляемоеВыражение.Доступность = ЭтоПолноправныйПользователь И (Вариант = ВыражениеНаВстроенномЯзыке);
	Элементы.ВычисляемоеВыражение.АвтоОтметкаНезаполненного = (Вариант = ВыражениеНаВстроенномЯзыке);
	Элементы.ВычисляемоеВыражение.ОтметкаНезаполненного =
		(Вариант = ВыражениеНаВстроенномЯзыке) И Не ЗначениеЗаполнено(ВычисляемоеВыражение);
	
	Элементы.РежимИзмененияДанныхПроведенногоДокумента.Доступность =
		(Вариант = РеквизитОбъекта)
		Или (Вариант = ВыражениеНаВстроенномЯзыке);
	
	Элементы.Обновлять.Доступность = Не (Вариант = УказанноеЗначение) И Не Зависимый;
	Элементы.РежимИзмененияДанныхПроведенногоДокумента.Доступность = Не (Вариант = УказанноеЗначение) И Не Зависимый;
	
	Если Зависимый Тогда
		Обновлять = ОбновлятьРодитель;
	Иначе
		Обновлять = Обновлять И Не (Вариант = УказанноеЗначение);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если Вариант = Перечисления.ВариантыПравилЗаполненияРеквизитов.РеквизитОбъекта Тогда
		ПроверяемыеРеквизиты.Добавить("ПредставлениеРеквизитаОбъектаДО");
		Если Параметры.ЗаполняетсяДокумент Тогда
			ПроверяемыеРеквизиты.Добавить("РежимИзмененияДанныхПроведенногоДокумента");
		КонецЕсли;
		
	ИначеЕсли Вариант = Перечисления.ВариантыПравилЗаполненияРеквизитов.УказанноеЗначение Тогда
		ПроверяемыеРеквизиты.Добавить("ЗначениеРеквизитаИС");
		
	ИначеЕсли Вариант = Перечисления.ВариантыПравилЗаполненияРеквизитов.ВыражениеНаВстроенномЯзыке Тогда
		ПроверяемыеРеквизиты.Добавить("ВычисляемоеВыражение");
		Если Параметры.ЗаполняетсяДокумент Тогда
			ПроверяемыеРеквизиты.Добавить("РежимИзмененияДанныхПроведенногоДокумента");
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти