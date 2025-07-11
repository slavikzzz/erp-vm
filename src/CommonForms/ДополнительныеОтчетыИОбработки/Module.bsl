///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОписаниеПеременных

&НаКлиенте
Перем ВыполняемаяКоманда;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Параметры.ИмяРаздела)
		И Параметры.ИмяРаздела <> ДополнительныеОтчетыИОбработкиКлиентСервер.ИмяНачальнойСтраницы() Тогда
		СсылкаРаздела = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(Метаданные.Подсистемы.Найти(Параметры.ИмяРаздела));
	КонецЕсли;
	
	ВидОбработок = ДополнительныеОтчетыИОбработки.ПолучитьВидОбработкиПоСтроковомуПредставлениюВида(Параметры.Вид);
	Если ВидОбработок = Перечисления.ВидыДополнительныхОтчетовИОбработок.ЗаполнениеОбъекта Тогда
		ЭтоНазначаемыеОбработки = Истина;
		Заголовок = НСтр("ru = 'Команды заполнения объектов';
						|en = 'Object filling commands'");
	ИначеЕсли ВидОбработок = Перечисления.ВидыДополнительныхОтчетовИОбработок.Отчет Тогда
		ЭтоНазначаемыеОбработки = Истина;
		ЭтоОтчеты = Истина;
		Заголовок = НСтр("ru = 'Отчеты';
						|en = 'Reports'");
	ИначеЕсли ВидОбработок = Перечисления.ВидыДополнительныхОтчетовИОбработок.ПечатнаяФорма Тогда
		ЭтоНазначаемыеОбработки = Истина;
		Заголовок = НСтр("ru = 'Дополнительные печатные формы';
						|en = 'Additional print forms'");
	ИначеЕсли ВидОбработок = Перечисления.ВидыДополнительныхОтчетовИОбработок.СозданиеСвязанныхОбъектов Тогда
		ЭтоНазначаемыеОбработки = Истина;
		Заголовок = НСтр("ru = 'Команды создания связанных объектов';
						|en = 'Create related objects commands'");
	ИначеЕсли ВидОбработок = Перечисления.ВидыДополнительныхОтчетовИОбработок.ДополнительнаяОбработка Тогда
		ЭтоГлобальныеОбработки = Истина;
		Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Дополнительные обработки (%1)';
				|en = 'Additional data processors (%1)'"), 
			ДополнительныеОтчетыИОбработки.ПредставлениеРаздела(СсылкаРаздела));
	ИначеЕсли ВидОбработок = Перечисления.ВидыДополнительныхОтчетовИОбработок.ДополнительныйОтчет Тогда
		ЭтоГлобальныеОбработки = Истина;
		ЭтоОтчеты = Истина;
		Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Дополнительные отчеты (%1)';
				|en = 'Additional reports (%1)'"), 
			ДополнительныеОтчетыИОбработки.ПредставлениеРаздела(СсылкаРаздела));
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.РежимОткрытияОкна) Тогда
		РежимОткрытияОкна = Параметры.РежимОткрытияОкна;
	КонецЕсли;
	Если Не ПустаяСтрока(Параметры.Заголовок) Тогда
		Заголовок = Параметры.Заголовок;
	КонецЕсли;
	
	Если ЭтоНазначаемыеОбработки Тогда
		Элементы.НастроитьСписок.Видимость = Ложь;
		
		ОбъектыНазначения.ЗагрузитьЗначения(Параметры.ОбъектыНазначения.ВыгрузитьЗначения());
		Если ОбъектыНазначения.Количество() = 0 Тогда
			Отказ = Истина;
			Возврат;
		КонецЕсли;
		
		ИнформацияОВладельце = ДополнительныеОтчетыИОбработкиПовтИсп.ПараметрыФормыНазначаемогоОбъекта(Параметры.ИмяФормы);
		МетаданныеРодителя = Метаданные.НайтиПоТипу(ТипЗнч(ОбъектыНазначения[0].Значение));
		Если МетаданныеРодителя = Неопределено Тогда
			СсылкаРодителя = ИнформацияОВладельце.СсылкаРодителя;
		Иначе
			СсылкаРодителя = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(МетаданныеРодителя);
		КонецЕсли;
		Если ТипЗнч(ИнформацияОВладельце) = Тип("ФиксированнаяСтруктура") Тогда
			ЭтоФормаОбъекта = ИнформацияОВладельце.ЭтоФормаОбъекта;
		Иначе
			ЭтоФормаОбъекта = Ложь;
		КонецЕсли;
	КонецЕсли;
	
	ЗаполнитьТаблицуОбработок();
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	Если ВыбранноеЗначение = "ВыполненаНастройкаМоихОтчетовИОбработок" Тогда
		ЗаполнитьТаблицуОбработок();
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТаблицаКоманд

&НаКлиенте
Процедура ТаблицаКомандВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ВыполнитьОбработкуПоПараметрам();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыполнитьОбработку(Команда)
	
	ВыполнитьОбработкуПоПараметрам()
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьСписок(Команда)
	ПараметрыФормы = Новый Структура("ВидОбработок, СсылкаРаздела");
	ЗаполнитьЗначенияСвойств(ПараметрыФормы, ЭтотОбъект);
	ОткрытьФорму("ОбщаяФорма.НастройкаМоихОтчетовИОбработок", ПараметрыФормы, ЭтотОбъект, Ложь);
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьВыполнениеОбработки(Команда)
	Закрыть();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьТаблицуОбработок()
	ТипыКоманд = Новый Массив;
	ТипыКоманд.Добавить(Перечисления.СпособыВызоваДополнительныхОбработок.ВызовКлиентскогоМетода);
	ТипыКоманд.Добавить(Перечисления.СпособыВызоваДополнительныхОбработок.ВызовСерверногоМетода);
	ТипыКоманд.Добавить(Перечисления.СпособыВызоваДополнительныхОбработок.ОткрытиеФормы);
	ТипыКоманд.Добавить(Перечисления.СпособыВызоваДополнительныхОбработок.СценарийВБезопасномРежиме);
	
	Запрос = ДополнительныеОтчетыИОбработки.НовыйЗапросПоДоступнымКомандам(ВидОбработок, ?(ЭтоГлобальныеОбработки, СсылкаРаздела, СсылкаРодителя), ЭтоФормаОбъекта, ТипыКоманд);
	ТаблицаРезультат = Запрос.Выполнить().Выгрузить();
	ТаблицаКоманд.Загрузить(ТаблицаРезультат);
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьОбработкуПоПараметрам()
	ДанныеОбработки = Элементы.ТаблицаКоманд.ТекущиеДанные;
	Если ДанныеОбработки = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ВыполняемаяКоманда = Новый Структура(
		"Ссылка, Представление, 
		|Идентификатор, ВариантЗапуска, ПоказыватьОповещение, 
		|Модификатор, ОбъектыНазначения, ЭтоОтчет, Вид");
	ЗаполнитьЗначенияСвойств(ВыполняемаяКоманда, ДанныеОбработки);
	Если НЕ ЭтоГлобальныеОбработки Тогда
		ВыполняемаяКоманда.ОбъектыНазначения = ОбъектыНазначения.ВыгрузитьЗначения();
	КонецЕсли;
	ВыполняемаяКоманда.ЭтоОтчет = ЭтоОтчеты;
	ВыполняемаяКоманда.Вид = ВидОбработок;
	
	Если ДанныеОбработки.ВариантЗапуска = ПредопределенноеЗначение("Перечисление.СпособыВызоваДополнительныхОбработок.ОткрытиеФормы") Тогда
		
		ДополнительныеОтчетыИОбработкиКлиент.ВыполнитьОткрытиеФормыОбработки(ВыполняемаяКоманда, ВладелецФормы, ВыполняемаяКоманда.ОбъектыНазначения);
		
	ИначеЕсли ДанныеОбработки.ВариантЗапуска = ПредопределенноеЗначение("Перечисление.СпособыВызоваДополнительныхОбработок.ВызовКлиентскогоМетода") Тогда
		
		ДополнительныеОтчетыИОбработкиКлиент.ВыполнитьКлиентскийМетодОбработки(ВыполняемаяКоманда, ВладелецФормы, ВыполняемаяКоманда.ОбъектыНазначения);
		
	ИначеЕсли ВидОбработок = ПредопределенноеЗначение("Перечисление.ВидыДополнительныхОтчетовИОбработок.ПечатнаяФорма")
		И ДанныеОбработки.Модификатор = "ПечатьMXL" Тогда
		
		ДополнительныеОтчетыИОбработкиКлиент.ВыполнитьОткрытиеПечатнойФормы(ВыполняемаяКоманда, ВладелецФормы, ВыполняемаяКоманда.ОбъектыНазначения);
		
	ИначеЕсли ДанныеОбработки.ВариантЗапуска = ПредопределенноеЗначение("Перечисление.СпособыВызоваДополнительныхОбработок.ВызовСерверногоМетода")
		Или ДанныеОбработки.ВариантЗапуска = ПредопределенноеЗначение("Перечисление.СпособыВызоваДополнительныхОбработок.СценарийВБезопасномРежиме") Тогда
		
		// Изменение элементов формы
		Элементы.ПоясняющаяДекорация.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Выполняется команда ""%1""...';
				|en = 'Executing command %1…'"),
			ДанныеОбработки.Представление);
		Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаВыполненияОбработки;
		Элементы.НастроитьСписок.Видимость = Ложь;
		Элементы.ВыполнитьОбработку.Видимость = Ложь;
		
		// Вызов сервера только после перехода формы в консистентное состояние.
		ПодключитьОбработчикОжидания("ВыполнитьСерверныйМетодОбработки", 0.1, Истина);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьСерверныйМетодОбработки()
	
	Задание = ЗапуститьФоновоеЗадание(ВыполняемаяКоманда, УникальныйИдентификатор);
	
	НастройкиОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	НастройкиОжидания.ВыводитьОкноОжидания = Ложь;
	
	Обработчик = Новый ОписаниеОповещения("ВыполнитьСерверныйМетодОбработкиЗавершение", ЭтотОбъект);
	ДлительныеОперацииКлиент.ОжидатьЗавершение(Задание, Обработчик, НастройкиОжидания);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗапуститьФоновоеЗадание(Знач ВыполняемаяКоманда, Знач УникальныйИдентификатор)
	ИмяМетода = "ДополнительныеОтчетыИОбработки.ВыполнитьКоманду";
	
	НастройкиЗапуска = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	НастройкиЗапуска.НаименованиеФоновогоЗадания = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Доп. отчеты и обработки: Выполнение команды ""%1""';
			|en = 'Additional reports and data processors: executing command %1.'"),
		ВыполняемаяКоманда.Представление);
	
	НастройкиЗапуска.УточнениеОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Не удалось выполнить команду ""%1"" по причине:';
			|en = 'Cannot execute the command. Reason: %1.'"),
		ВыполняемаяКоманда.Представление);
	
	ПараметрыМетода = Новый Структура("ДополнительнаяОбработкаСсылка, ИдентификаторКоманды, ОбъектыНазначения");
	ПараметрыМетода.ДополнительнаяОбработкаСсылка = ВыполняемаяКоманда.Ссылка;
	ПараметрыМетода.ИдентификаторКоманды          = ВыполняемаяКоманда.Идентификатор;
	ПараметрыМетода.ОбъектыНазначения             = ВыполняемаяКоманда.ОбъектыНазначения;
	
	Возврат ДлительныеОперации.ВыполнитьВФоне(ИмяМетода, ПараметрыМетода, НастройкиЗапуска);
КонецФункции

// Параметры:
//  Результат - см. ДлительныеОперацииКлиент.НовыйРезультатДлительнойОперации
//  ДополнительныеПараметры - Неопределено
//
&НаКлиенте
Процедура ВыполнитьСерверныйМетодОбработкиЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Результат.Статус = "Ошибка" Тогда
		Если Открыта() Тогда
			Закрыть();
		КонецЕсли;
		СтандартныеПодсистемыКлиент.ВывестиИнформациюОбОшибке(
			Результат.ИнформацияОбОшибке);
	КонецЕсли;
		
	// Показ всплывающего оповещения и закрытие этой формы.
	Если ВыполняемаяКоманда.ПоказыватьОповещение Тогда
		ПоказатьОповещениеПользователя(НСтр("ru = 'Команда выполнена';
											|en = 'The operation is completed.'"),, ВыполняемаяКоманда.Представление);
	КонецЕсли;
	Если Открыта() Тогда
		Закрыть();
	КонецЕсли;
	
	// Обновление формы владельца.
	Если ЭтоФормаОбъекта Тогда
		Попытка
			ВладелецФормы.Прочитать();
		Исключение
			// Действие не требуется.
		КонецПопытки;
	КонецЕсли;
	
	// Оповещение других форм.
	РезультатВыполнения = ПолучитьИзВременногоХранилища(Результат.АдресРезультата);
	ОповеститьФормы = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(РезультатВыполнения, "ОповеститьФормы");
	Если ОповеститьФормы <> Неопределено Тогда
		СтандартныеПодсистемыКлиент.ОповеститьФормыОбИзменении(ОповеститьФормы);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти