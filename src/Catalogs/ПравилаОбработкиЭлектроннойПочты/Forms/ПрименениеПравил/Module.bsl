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
	
	Если Не ЗначениеЗаполнено(Параметры.УчетнаяЗапись) Или Параметры.УчетнаяЗапись.Пустая() Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
		
	УчетнаяЗапись = Параметры.УчетнаяЗапись;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	ПравилаОбработкиЭлектроннойПочты.Ссылка КАК Правило,
	|	ЛОЖЬ КАК Применять,
	|	ПравилаОбработкиЭлектроннойПочты.ПредставлениеОтбора,
	|	ПравилаОбработкиЭлектроннойПочты.ПомещатьВПапку
	|ИЗ
	|	Справочник.ПравилаОбработкиЭлектроннойПочты КАК ПравилаОбработкиЭлектроннойПочты
	|ГДЕ
	|	ПравилаОбработкиЭлектроннойПочты.Владелец = &Владелец
	|	И (НЕ ПравилаОбработкиЭлектроннойПочты.ПометкаУдаления)
	|
	|УПОРЯДОЧИТЬ ПО
	|	ПравилаОбработкиЭлектроннойПочты.РеквизитДопУпорядочивания";
	
	Запрос.УстановитьПараметр("Владелец", Параметры.УчетнаяЗапись);
	
	Результат = Запрос.Выполнить();
	Если НЕ Результат.Пустой() Тогда
		ПрименяемыеПравила.Загрузить(Результат.Выгрузить());
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.ДляПисемВПапке) Тогда
		ДляПисемВПапке = Параметры.ДляПисемВПапке;
	Иначе 
		
		Запрос.Текст = "
		|ВЫБРАТЬ
		|	ПапкиЭлектронныхПисем.Ссылка
		|ИЗ
		|	Справочник.ПапкиЭлектронныхПисем КАК ПапкиЭлектронныхПисем
		|ГДЕ
		|	ПапкиЭлектронныхПисем.ПредопределеннаяПапка
		|	И ПапкиЭлектронныхПисем.Владелец = &Владелец
		|	И ПапкиЭлектронныхПисем.ТипПредопределеннойПапки = ЗНАЧЕНИЕ(Перечисление.ТипыПредопределенныхПапокПисем.Входящие)";
		
		Результат = Запрос.Выполнить();
		Если НЕ Результат.Пустой() Тогда
			Выборка = Результат.Выбрать();
			Выборка.Следующий();
			ДляПисемВПапке = Выборка.Ссылка;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Применить(Команда)
	
	ОчиститьСообщения();
	ТекстСообщенияПользователю = "";
	
	ВыбраноХотьОдноПравило = Ложь;
	Отказ = Ложь;
	
	Для каждого Правило Из ПрименяемыеПравила Цикл
		
		Если Правило.Применять Тогда
			ВыбраноХотьОдноПравило = Истина;
			Прервать;
		КонецЕсли;
		
	КонецЦикла;
	
	Если Не ВыбраноХотьОдноПравило Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(
			НСтр("ru = 'Выберите хотя бы одно правило для применения';
				|en = 'Select at least one rule to apply'"),,"Список");
		Отказ = Истина;
	КонецЕсли;
	
	Если ДляПисемВПапке.Пустая() Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(
			НСтр("ru = 'Не выбрана папка к письмам которой будут применены правила';
				|en = 'Please select a folder.'"),,"ДляПисемВПапке");
		Отказ = Истина;
	КонецЕсли;
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ДлительнаяОперация = ПрименитьПравилаНаСервере();
	
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ОповещениеОЗавершении = Новый ОписаниеОповещения("ПрименитьПравилаЗавершение", ЭтотОбъект);
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, ОповещениеОЗавершении, ПараметрыОжидания);
	
КонецПроцедуры

&НаКлиенте
Процедура ПрименитьВсеПравила(Команда)
	
	Для каждого ПравилоОбработки Из ПрименяемыеПравила Цикл
		ПравилоОбработки.Применять = Истина;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура НеПрименятьВсеПравила(Команда)
	
	Для каждого ПравилоОбработки Из ПрименяемыеПравила Цикл
		ПравилоОбработки.Применять = Ложь;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ПрименитьПравилаНаСервере()
	
	ПараметрыПроцедуры = Новый Структура;
	
	ПараметрыПроцедуры.Вставить("ТаблицаПравил", ПрименяемыеПравила.Выгрузить());
	ПараметрыПроцедуры.Вставить("ДляПисемВПапке", ДляПисемВПапке);
	ПараметрыПроцедуры.Вставить("ВключаяПодчиненные", ВключаяПодчиненные);
	ПараметрыПроцедуры.Вставить("УчетнаяЗапись", УчетнаяЗапись);
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Применение правил';
															|en = 'Running mailbox rules'") + " ";
	
	Возврат ДлительныеОперации.ВыполнитьВФоне("Справочники.ПравилаОбработкиЭлектроннойПочты.ПрименитьПравила",
		ПараметрыПроцедуры, 	ПараметрыВыполнения);
			
КонецФункции

// Параметры:
//  Результат - см. ДлительныеОперацииКлиент.НовыйРезультатДлительнойОперации
//  ДополнительныеПараметры - Неопределено
//
&НаКлиенте
Процедура ПрименитьПравилаЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	ИначеЕсли Результат.Статус = "Ошибка" Тогда
		СтандартныеПодсистемыКлиент.ВывестиИнформациюОбОшибке(
			Результат.ИнформацияОбОшибке);
	ИначеЕсли Результат.Статус = "Выполнено" Тогда
		ЗагрузитьРезультат(Результат.АдресРезультата);
		Оповестить("ПримененыПравилаОбработкиПисем");
		Если Не ПустаяСтрока(ТекстСообщенияПользователю) Тогда
			ПоказатьОповещениеПользователя(НСтр("ru = 'Применение правил обработки';
												|en = 'Running mailbox rules'"),,
				ТекстСообщенияПользователю, БиблиотекаКартинок.ДиалогИнформация);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьРезультат(АдресРезультата)
	
	Результат = ПолучитьИзВременногоХранилища(АдресРезультата);
	Если ТипЗнч(Результат) = Тип("Строка")
		И ЗначениеЗаполнено(Результат) Тогда
			ТекстСообщенияПользователю = Результат;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
