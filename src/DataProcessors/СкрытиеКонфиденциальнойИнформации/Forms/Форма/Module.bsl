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
	
	ОбработкаОбъект      = РеквизитФормыВЗначение("Объект");
	АдресХранилищаНастроек = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
	
	Заголовок = НСтр("ru = 'Скрытие конфиденциальной информации';
					|en = 'Hide confidential information'");
	
	ЗаполнитьДеревоОбрабатываемыхОбъектов(ОбработкаОбъект);
	ЗаполнитьПравилаОбработки(ОбработкаОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "СкрытиеПерсональныхДанных_УстановленоПравилоОбработки" Тогда
		ИдентификаторТекущейСтроки = Элементы.ОбрабатываемыеОбъекты.ТекущаяСтрока;
		ТекущаяСтрока = ОбрабатываемыеОбъекты.НайтиПоИдентификатору(ИдентификаторТекущейСтроки);
		ТекущаяСтрока.ПредставлениеПравилаОбработки = Параметр.Представление;
		ТекущаяСтрока.ПравилоОбработки = Параметр.ПравилоОбработки;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Не МакетОпределен Тогда
		Элементы.ГруппаИзменениеРежима.Видимость = Ложь;
		РасширенныеВозможностиНажатие(Неопределено);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	ПриЗакрытииНаСервере();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПравилоЧислоПриИзменении(Элемент)
	Если ПредставлениеПравилаЧисло = "Умножить"
		Или ПредставлениеПравилаЧисло = "Разделить"
		Или ПредставлениеПравилаЧисло = "Прибавить"
		Или ПредставлениеПравилаЧисло = "Вычесть" Тогда
		Элементы.СтраницыЗначения.ТекущаяСтраница = Элементы.ЗначениеЧисла;
	Иначе
		Элементы.СтраницыЗначения.ТекущаяСтраница = Элементы.ПустаяСтраница;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПравилоДатаПриИзменении(Элемент)
	Если ПредставлениеПравилаДата = "НеИзменять" Тогда
		Элементы.СтраницыЗначенияДаты.ТекущаяСтраница = Элементы.ПустаяСтраницаДата;
	Иначе
		Элементы.СтраницыЗначенияДаты.ТекущаяСтраница = Элементы.СтраницаЗначенияДата;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура РасширенныеВозможностиНажатие(Элемент)
	
	Если ДеревоМетаданныхЗаполнено Тогда
		Если Элементы.СтраницыВидФормы.ТекущаяСтраница = Элементы.СтраницаЧастотныеВозможности Тогда
			Элементы.СтраницыВидФормы.ТекущаяСтраница = Элементы.СтраницаРасширенныеВозможности;
			Если МакетОпределен Тогда
				Заголовок = НСтр("ru = 'Скрытие конфиденциальной информации - полные возможности';
								|en = 'Confidential information hiding - full functionality'");
			КонецЕсли;
			Элементы.РасширенныеВозможности.Заголовок = НСтр("ru = 'Обычный вид';
															|en = 'Normal view'");
		Иначе
			Элементы.СтраницыВидФормы.ТекущаяСтраница = Элементы.СтраницаЧастотныеВозможности;
			Заголовок = НСтр("ru = 'Скрытие конфиденциальной информации';
							|en = 'Hide confidential information'");
			Элементы.РасширенныеВозможности.Заголовок = НСтр("ru = 'Полные возможности';
															|en = 'Full functionality'");
		КонецЕсли;
	Иначе
		Если ДеревоМетаданныхЗаполнено() Тогда
			Элементы.СтраницыВидФормы.ТекущаяСтраница = Элементы.СтраницаРасширенныеВозможности;
			Элементы.РасширенныеВозможности.Доступность = Истина;
			Если МакетОпределен Тогда
				Заголовок = НСтр("ru = 'Скрытие конфиденциальной информации - полные возможности';
								|en = 'Confidential information hiding - full functionality'");
			КонецЕсли;
			Элементы.РасширенныеВозможности.Заголовок = НСтр("ru = 'Обычный вид';
															|en = 'Normal view'");
		Иначе
			Элементы.СтраницыВидФормы.ТекущаяСтраница   = Элементы.СтраницаДлительнаяОперация;
			Элементы.РасширенныеВозможности.Доступность = Ложь;
			
			ОповещениеОЗакрытии = Новый ОписаниеОповещения("ОбработатьРезультатВыполнениеЗадания", ЭтотОбъект);
			ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
			ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
			ДлительныеОперацииКлиент.ОжидатьЗавершение(РезультатДлительнойОперации, ОповещениеОЗакрытии, ПараметрыОжидания);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗначениеЧислоПриИзменении(Элемент)
	Если ЗначениеЧисло = 0 Тогда
		ТекстПредупреждения = НСтр("ru = 'Значение должно быть не нулевым.';
									|en = 'The value must be zero.'");
		ПоказатьПредупреждение(, ТекстПредупреждения);
		ЗначениеЧисло = 1;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ЗначениеДатаПриИзменении(Элемент)
	Если ЗначениеДата = 0 Тогда
		ТекстПредупреждения = НСтр("ru = 'Значение должно быть не нулевым.';
									|en = 'The value must be zero.'");
		ПоказатьПредупреждение(, ТекстПредупреждения);
		ЗначениеДата = 1;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыОбрабатываемыеОбъекты

&НаКлиенте
Процедура ОбрабатываемыеОбъектыПравилоОбработкиНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ВыбраннаяСтрока = Элементы.ОбрабатываемыеОбъекты.ТекущиеДанные;
	
	Если ВыбраннаяСтрока = Неопределено Или Не ЗначениеЗаполнено(ВыбраннаяСтрока.ТипЗначения) Тогда
		Возврат;
	КонецЕсли;
	
	Если ВыбраннаяСтрока.ПравилоОбработки.Количество() > 0 Тогда
		ОбщиеПравилаОбработки = ВыбраннаяСтрока.ПравилоОбработки;
	Иначе
		ОбщиеПравилаОбработки = Новый Структура;
		ОбщиеПравилаОбработки.Вставить("ПравилоСтрока", Объект.ПравилоСтрока);
		Если ПредставлениеПравилаЧисло = "НеИзменять"
			Или ПредставлениеПравилаЧисло = "Очистить" Тогда
			ПравилоЧисло = ПредставлениеПравилаЧисло;
		Иначе
			ПравилоЧисло = ПредставлениеПравилаЧисло + ";" + ЗначениеЧисло;
		КонецЕсли;
		ОбщиеПравилаОбработки.Вставить("ПравилоЧисло", ПравилоЧисло);
		ОбщиеПравилаОбработки.Вставить("ПравилоБулево", Объект.ПравилоБулево);
		Если ПредставлениеПравилаДата = "НеИзменять"
			Или ПредставлениеПравилаДата = "Очистить" Тогда
			ПравилоДата = ПредставлениеПравилаДата;
		Иначе
			ПравилоДата = ПредставлениеПравилаДата + ";" + ЗначениеДата;
		КонецЕсли;
		ОбщиеПравилаОбработки.Вставить("ПравилоДата", ПравилоДата);
		ОбщиеПравилаОбработки.Вставить("ПравилоХранилищеЗначений", Объект.ПравилоХранилищеЗначений);
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ТипЗначения", ВыбраннаяСтрока.ТипЗначения);
	ПараметрыФормы.Вставить("ОбщиеПравилаОбработки", ОбщиеПравилаОбработки);
	
	ОткрытьФорму(ПолноеИмяФормы("ВыборПравилОбработки"), ПараметрыФормы);
КонецПроцедуры

&НаКлиенте
Процедура ОбрабатываемыеОбъектыПометкаПриИзменении(Элемент)
	
	ТекущиеДанные       = Элементы.ОбрабатываемыеОбъекты.ТекущиеДанные;
	ИдентификаторСтроки = Элементы.ОбрабатываемыеОбъекты.ТекущаяСтрока;
	ТекущаяСтрока       = ОбрабатываемыеОбъекты.НайтиПоИдентификатору(ИдентификаторСтроки);
	
	ЗначениеПометки = ?(ТекущиеДанные.Пометка = 2, 0, ТекущиеДанные.Пометка);
	ТекущиеДанные.Пометка = ЗначениеПометки;
	
	ИзменитьДочерниеЭлементы(ТекущаяСтрока.ПолучитьЭлементы(), ЗначениеПометки);
	ИзменитьРодительскиеЭлементы(ТекущаяСтрока);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОтметитьВсе(Команда)
	Для Каждого ДочернийЭлемент Из ОбрабатываемыеОбъекты.ПолучитьЭлементы() Цикл
		ДочернийЭлемент.Пометка = 1;
		ИзменитьДочерниеЭлементы(ДочернийЭлемент.ПолучитьЭлементы(), 1);
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура СнятьОтметку(Команда)
	Для Каждого ДочернийЭлемент Из ОбрабатываемыеОбъекты.ПолучитьЭлементы() Цикл
		ДочернийЭлемент.Пометка = 0;
		ИзменитьДочерниеЭлементы(ДочернийЭлемент.ПолучитьЭлементы(), 0);
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьСкрытие(Команда)
	
	ТекстПредупреждения = НСтр("ru = 'Скрытие конфиденциальной информации необходимо выполнять на копии рабочей базы,
		|все изменения будут выполнены безвозвратно.
		|Продолжить?';
		|en = 'Hide confidential information on the working infobase copy,
		|all changes will be made permanently.""
		|""Continue?'");
	
	ОбработкаОповещения = Новый ОписаниеОповещения("ВыполнитьСкрытиеПродолжение", ЭтотОбъект);
	ПоказатьВопрос(ОбработкаОповещения, ТекстПредупреждения, РежимДиалогаВопрос.ДаНет)
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьСкрытиеПродолжение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ПодключитьОбработчикОжидания("Подключаемый_ВыполнитьСкрытиеЗавершение", 1);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьСкрытиеЗавершение()
	
	МодульДлительныеОперацииКлиент = ОбщийМодуль("ДлительныеОперацииКлиент");
	Если МодульДлительныеОперацииКлиент = Неопределено Тогда
		СкрытиеКонфиденциальнойИнформации();
		Возврат;
	КонецЕсли;
	
	Если ДеревоМетаданныхЗаполнено
		Или ЗаданиеВыполнено(ИдентификаторЗадания) Тогда
		ОтключитьОбработчикОжидания("Подключаемый_ВыполнитьСкрытиеЗавершение");
	Иначе
		ОповещениеОЗакрытии = Новый ОписаниеОповещения("ОбработатьРезультатВыполнениеЗадания", ЭтотОбъект);
		МодульДлительныеОперацииКлиент.ОжидатьЗавершение(РезультатДлительнойОперации, ОповещениеОЗакрытии);
		Возврат;
	КонецЕсли;
	
	РезультатЗапуска = СкрытиеКонфиденциальнойИнформации();
	
	Если РезультатЗапуска.Статус <> "Выполнено" Тогда
		ОповещениеОЗакрытии = Новый ОписаниеОповещения("СкрытиеКонфиденциальнойИнформацииЗавершение", ЭтотОбъект);
		МодульДлительныеОперацииКлиент.ОжидатьЗавершение(РезультатДлительнойОперации, ОповещениеОЗакрытии);
	Иначе
		ОповеститьСпискиОбИзменении();
		Оповестить("СкрытиеКонфиденциальнойИнформации");
		СообщитьПользователю(НСтр("ru = 'Скрытие конфиденциальной информации завершено.';
									|en = 'Confidential information hiding completed.'"));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоУмолчанию(Команда)
	ЗаполнитьПоУмолчаниюНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура СохранитьНастройки(Команда)
	
	ПараметрыСохранения = ФайловаяСистемаКлиент.ПараметрыСохраненияФайла();
	ПараметрыСохранения.Диалог.Фильтр = НСтр("ru = 'Файл настроек';
											|en = 'Setting file'") + "(*.xml)|*.xml";
	ПараметрыСохранения.Диалог.МножественныйВыбор = Ложь;
	ФайловаяСистемаКлиент.СохранитьФайл(Неопределено, НастройкиОбработки(), , ПараметрыСохранения);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьНастройки(Команда)
	
	Оповещение = Новый ОписаниеОповещения("ЗагрузитьНастройкиЗавершение", ЭтотОбъект);
	ПараметрыЗагрузки = ФайловаяСистемаКлиент.ПараметрыЗагрузкиФайла();
	ПараметрыЗагрузки.ИдентификаторФормы = УникальныйИдентификатор;
	ПараметрыЗагрузки.Диалог.Фильтр = НСтр("ru = 'Файл настроек';
											|en = 'Setting file'") + "(*.xml)|*.xml";
	ПараметрыЗагрузки.Диалог.МножественныйВыбор = Ложь;
	ФайловаяСистемаКлиент.ЗагрузитьФайл(Оповещение, ПараметрыЗагрузки);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПриЗакрытииНаСервере()
	
	ДлительныеОперации.ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	ДлительныеОперации.ОтменитьВыполнениеЗадания(ИдентификаторЗаданияВторой);
	
КонецПроцедуры

&НаСервере
Функция ДеревоМетаданныхЗаполнено()
	Если ИдентификаторЗадания <> Неопределено И Не ЗаданиеВыполнено(ИдентификаторЗадания) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ДеревоОбрабатываемыхОбъектов = ПолучитьИзВременногоХранилища(АдресХранилища);
	ЗначениеВРеквизитФормы(ДеревоОбрабатываемыхОбъектов, "ОбрабатываемыеОбъекты");
	ДеревоМетаданныхЗаполнено = Истина;
	
	Возврат Истина;
КонецФункции

// Параметры:
//  Результат - см. ДлительныеОперацииКлиент.НовыйРезультатДлительнойОперации
//  ДополнительныеПараметры - Неопределено
//
&НаКлиенте
Процедура ОбработатьРезультатВыполнениеЗадания(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	Если Результат.Статус = "Ошибка" Тогда
		СтандартныеПодсистемыКлиент.ВывестиИнформациюОбОшибке(
			Результат.ИнформацияОбОшибке);
		Возврат;
	КонецЕсли;
	ДеревоМетаданныхЗаполнено();
	
	Элементы.СтраницыВидФормы.ТекущаяСтраница = Элементы.СтраницаРасширенныеВозможности;
	Элементы.РасширенныеВозможности.Доступность = Истина;
	Заголовок = НСтр("ru = 'Скрытие конфиденциальной информации - полные возможности';
					|en = 'Confidential information hiding - full functionality'");
	Элементы.РасширенныеВозможности.Заголовок = НСтр("ru = 'Обычный вид';
													|en = 'Normal view'");
	
КонецПроцедуры

// Параметры:
//  Результат - см. ДлительныеОперацииКлиент.НовыйРезультатДлительнойОперации
//  ДополнительныеПараметры - Неопределено
//
&НаКлиенте
Процедура СкрытиеКонфиденциальнойИнформацииЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	Если Результат.Статус = "Ошибка" Тогда
		СтандартныеПодсистемыКлиент.ВывестиИнформациюОбОшибке(
			Результат.ИнформацияОбОшибке);
		Возврат;
	КонецЕсли;
	
	ОповеститьСпискиОбИзменении();
	Оповестить("СкрытиеКонфиденциальнойИнформации");
	
	СообщитьПользователю(НСтр("ru = 'Скрытие конфиденциальной информации завершено.';
								|en = 'Confidential information hiding completed.'"));
	
КонецПроцедуры

&НаКлиенте
Процедура ОповеститьСпискиОбИзменении()
	
	Для Каждого ВидОбъектов Из ОбрабатываемыеОбъекты.ПолучитьЭлементы() Цикл
		Если ВидОбъектов.Имя <> "Справочники"
			И ВидОбъектов.Имя <> "Документы"
			И ВидОбъектов.Имя <> "ПланыВидовХарактеристик"
			И ВидОбъектов.Имя <> "ПланыСчетов"
			И ВидОбъектов.Имя <> "ПланыВидовРасчета"
			И ВидОбъектов.Имя <> "БизнесПроцессы"
			И ВидОбъектов.Имя <> "Задачи" Тогда
			Продолжить;
		КонецЕсли;
		
		Если ВидОбъектов.Пометка = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		Для Каждого ОбъектВида Из ВидОбъектов.ПолучитьЭлементы() Цикл
			Если ОбъектВида.Пометка = 0 Тогда
				Продолжить;
			КонецЕсли;
			
			Для Каждого Тип Из ОбъектВида.ТипЗначения.Типы() Цикл
				ОповеститьОбИзменении(Тип);
			КонецЦикла;
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ЗаданиеВыполнено(ИдентификаторФоновогоЗадания = Неопределено)
	МодульДлительныеОперации = ОбщийМодуль("ДлительныеОперации");
	Если ИдентификаторФоновогоЗадания = Неопределено Тогда
		Возврат Истина;
	КонецЕсли;
	
	Возврат МодульДлительныеОперации.ЗаданиеВыполнено(ИдентификаторФоновогоЗадания);
КонецФункции

&НаКлиенте
Процедура ЗагрузитьНастройкиЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьНастройки(Результат.Хранение);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьНастройки(Результат)
	
	ФайлНастроек = ПолучитьИзВременногоХранилища(Результат); // ДвоичныеДанные
	ИмяФайла = ПолучитьИмяВременногоФайла("xml");
	ФайлНастроек.Записать(ИмяФайла);
	
	ТекстовыйДокумент = Новый ТекстовыйДокумент;
	ТекстовыйДокумент.Прочитать(ИмяФайла);
	СтрокаНастроек = ТекстовыйДокумент.ПолучитьТекст();
	
	СохраненныеНастройки = Новый Массив;
	СохраненныеНастройки.Добавить(СтрокаНастроек);
	
	ДеревоОбрабатываемыхОбъектов = РеквизитФормыВЗначение("ОбрабатываемыеОбъекты");
	ОбработкаОбъект = РеквизитФормыВЗначение("Объект");
	ОбработкаОбъект.ПрименитьНастройкиКДереву(СохраненныеНастройки, ДеревоОбрабатываемыхОбъектов);
	ЗначениеВРеквизитФормы(ДеревоОбрабатываемыхОбъектов, "ОбрабатываемыеОбъекты");
	
	УдалитьФайлы(ИмяФайла);
КонецПроцедуры

&НаСервере
Функция НастройкиОбработки()
	
	ДеревоОбъектов = РеквизитФормыВЗначение("ОбрабатываемыеОбъекты");
	
	ТаблицаОтмеченныхОбъектов = Новый ТаблицаЗначений;
	ТаблицаОтмеченныхОбъектов.Колонки.Добавить("Пометка");
	ТаблицаОтмеченныхОбъектов.Колонки.Добавить("ПолноеИмя");
	ТаблицаОтмеченныхОбъектов.Колонки.Добавить("ПравилоОбработки");
	ТаблицаОтмеченныхОбъектов.Колонки.Добавить("ПредставлениеПравилаОбработки");
	
	ПараметрыПоиска = Новый Структура;
	ПараметрыПоиска.Вставить("Пометка", 1);
	
	ОтмеченныеОбъекты = ДеревоОбъектов.Строки.НайтиСтроки(ПараметрыПоиска, Истина);
	Для Каждого ОтмеченныйОбъект Из ОтмеченныеОбъекты Цикл
		ЗаполнитьЗначенияСвойств(ТаблицаОтмеченныхОбъектов.Добавить(), ОтмеченныйОбъект);
	КонецЦикла;
	
	Возврат ПоместитьВоВременноеХранилище(ЗначениеВСтрокуXML(ТаблицаОтмеченныхОбъектов));
	
КонецФункции

&НаКлиенте
Функция ПолноеИмяФормы(Имя)
	ЧастиИмени = СтрРазделить(ИмяФормы, ".");
	ЧастиИмени[3] = Имя;
	Возврат СтрСоединить(ЧастиИмени, ".");
КонецФункции

&НаСервере
Процедура ЗаполнитьПравилаОбработки(ОбработкаОбъект)
	
	ПравилаОбработки = Обработки.СкрытиеКонфиденциальнойИнформации.ПравилаОбработкиПоУмолчанию();
	
	ЗаполнитьЗначенияСвойств(Объект, ПравилаОбработки);
	
	ПредставлениеПравилаДата = ПравилаОбработки.ПравилоДата;
	ПредставлениеПравилаЧисло = ПравилаОбработки.ПравилоЧисло;
	
	ЗначениеЧисло = 1;
	ЗначениеДата  = 1;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДеревоОбрабатываемыхОбъектов(ОбработкаОбъект)
	
	СохраненныеНастройки = СохраненныеНастройки(ОбработкаОбъект);
	
	ОбработкаОбъект = РеквизитФормыВЗначение("Объект");
	МодульДлительныеОперации = ОбщийМодуль("ДлительныеОперации");
	Если МодульДлительныеОперации = Неопределено Тогда
		АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
		ОбработкаОбъект.ЗаполнитьДеревоОбрабатываемыхОбъектов(СохраненныеНастройки, АдресХранилища);
		Возврат;
	КонецЕсли;
	
	МодульДлительныеОперации.ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	
	ПараметрыВыполненияВФоне = МодульДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполненияВФоне.НаименованиеФоновогоЗадания = НСтр("ru = 'Скрытие конфиденциальной информации';
																|en = 'Hide confidential information'");
	ПараметрыВыполненияВФоне.ОжидатьЗавершение = Ложь;
	
	РезультатДлительнойОперации = МодульДлительныеОперации.ВыполнитьВФоне(
		ОбработкаОбъект.Метаданные().ПолноеИмя() + ".МодульОбъекта.ЗаполнитьДеревоОбрабатываемыхОбъектов",
		СохраненныеНастройки,
		ПараметрыВыполненияВФоне);

	Если РезультатДлительнойОперации.Статус = "Ошибка" Тогда
		ВызватьИсключение РезультатДлительнойОперации.КраткоеПредставлениеОшибки;
	КонецЕсли;
	
	АдресХранилища       = РезультатДлительнойОперации.АдресРезультата;
	ИдентификаторЗадания = РезультатДлительнойОперации.ИдентификаторЗадания;
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьДочерниеЭлементы(ОбрабатываемыеЭлементы, ЗначениеПометки)
	
	Для Каждого Элемент Из ОбрабатываемыеЭлементы Цикл
		Элемент.Пометка = ЗначениеПометки;
		ДочерниеЭлементы = Элемент.ПолучитьЭлементы();
		Если ДочерниеЭлементы.Количество() > 0 Тогда
			ИзменитьДочерниеЭлементы(ДочерниеЭлементы, ЗначениеПометки);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ИзменитьРодительскиеЭлементы(ТекущаяСтрока)
	
	Родитель = ТекущаяСтрока.ПолучитьРодителя();
	Если Родитель = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ЭлементыРодителя    = Родитель.ПолучитьЭлементы();
	КоличествоЭлементов = ЭлементыРодителя.Количество();
	ОтмеченоЭлементов   = 0;
	ЕстьСНеопределеннымСтатусом = Ложь;
	
	Для Каждого Элемент Из ЭлементыРодителя Цикл
		Если Элемент.Пометка = 1 Тогда
			ОтмеченоЭлементов = ОтмеченоЭлементов + 1;
		ИначеЕсли Элемент.Пометка = 2 Тогда
			ЕстьСНеопределеннымСтатусом = Истина;
		КонецЕсли;
	КонецЦикла;
	
	Если ОтмеченоЭлементов = КоличествоЭлементов Тогда
		Родитель.Пометка = 1;
	ИначеЕсли ОтмеченоЭлементов > 0 Или ЕстьСНеопределеннымСтатусом Тогда
		Родитель.Пометка = 2;
	Иначе
		Родитель.Пометка = 0;
	КонецЕсли;
	
	ИзменитьРодительскиеЭлементы(Родитель);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПоУмолчаниюНаСервере()
	
	ДеревоОбрабатываемыхОбъектов = РеквизитФормыВЗначение("ОбрабатываемыеОбъекты");
	
	ОбработкаОбъект = РеквизитФормыВЗначение("Объект");
	СохраненныеНастройки = СохраненныеНастройки(ОбработкаОбъект);
	
	ОбработкаОбъект.ПрименитьНастройкиКДереву(СохраненныеНастройки, ДеревоОбрабатываемыхОбъектов);
	ЗначениеВРеквизитФормы(ДеревоОбрабатываемыхОбъектов, "ОбрабатываемыеОбъекты");
	
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////////////////

&НаСервере
Функция СкрытиеКонфиденциальнойИнформации()
	
	ПравилаОбработки = Обработки.СкрытиеКонфиденциальнойИнформации.ПравилаОбработкиПоУмолчанию();
	
	Если ПредставлениеПравилаЧисло = "Умножить"
		Или ПредставлениеПравилаЧисло = "Разделить"
		Или ПредставлениеПравилаЧисло = "Прибавить"
		Или ПредставлениеПравилаЧисло = "Вычесть" Тогда
		Объект.ПравилоЧисло = ПредставлениеПравилаЧисло + ";" + ЗначениеЧисло;
	Иначе
		Объект.ПравилоЧисло = ПредставлениеПравилаЧисло;
	КонецЕсли;
	
	Если ПредставлениеПравилаДата = "НеИзменять" Тогда
		Объект.ПравилоДата = ПредставлениеПравилаДата;
	Иначе
		Объект.ПравилоДата = ПредставлениеПравилаДата + ";" + ЗначениеДата;
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(ПравилаОбработки, Объект);
	
	Если Не ДеревоМетаданныхЗаполнено
		И ЗначениеЗаполнено(АдресХранилища) Тогда
		ДеревоОбрабатываемыхОбъектов = ПолучитьИзВременногоХранилища(АдресХранилища);
	Иначе
		ДеревоОбрабатываемыхОбъектов = РеквизитФормыВЗначение("ОбрабатываемыеОбъекты");
	КонецЕсли;
	АдресХранилищаВторой = "";
	
	ОбработкаОбъект = РеквизитФормыВЗначение("Объект");
	
	ПараметрыПроцедуры = Новый Структура;
	ПараметрыПроцедуры.Вставить("ДеревоОбрабатываемыхОбъектов", ДеревоОбрабатываемыхОбъектов);
	ПараметрыПроцедуры.Вставить("ПравилаОбработки", ПравилаОбработки);
	
	МодульДлительныеОперации = ОбщийМодуль("ДлительныеОперации");
	Если МодульДлительныеОперации = Неопределено Тогда
		АдресХранилищаВторой = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
		ОбработкаОбъект.УничтожитьПерсональныеДанные(ПараметрыПроцедуры, АдресХранилищаВторой);
		Возврат Истина;
	КонецЕсли;
	
	МодульДлительныеОперации.ОтменитьВыполнениеЗадания(ИдентификаторЗаданияВторой);
	
	ПараметрыВыполненияВФоне = МодульДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполненияВФоне.НаименованиеФоновогоЗадания = НСтр("ru = 'Скрытие конфиденциальной информации';
																|en = 'Hide confidential information'");
	ПараметрыВыполненияВФоне.ОжидатьЗавершение = Ложь;
	
	РезультатДлительнойОперации = МодульДлительныеОперации.ВыполнитьВФоне(
		ОбработкаОбъект.Метаданные().ПолноеИмя() + ".МодульОбъекта.УничтожитьПерсональныеДанные",
		ПараметрыПроцедуры,
		ПараметрыВыполненияВФоне);
	
	АдресХранилищаВторой = РезультатДлительнойОперации.АдресРезультата;
	ИдентификаторЗаданияВторой = РезультатДлительнойОперации.ИдентификаторЗадания;
	
	Возврат РезультатДлительнойОперации;
	
КонецФункции

&НаСервере
Функция СохраненныеНастройки(ОбработкаОбъект)
	
	Макеты = ОбработкаОбъект.Метаданные().Макеты;
	
	КоличествоНастроек   = 0;
	СохраненныеНастройки = Новый Массив;
	Для Каждого Макет Из Макеты Цикл
		МакетОбъект = ОбработкаОбъект.ПолучитьМакет(Макет.Имя);
		ИмяВременногоФайла = ПолучитьИмяВременногоФайла("XML");
		МакетОбъект.Записать(ИмяВременногоФайла);
		ТекстовыйДокумент = Новый ТекстовыйДокумент;
		ТекстовыйДокумент.Прочитать(ИмяВременногоФайла, КодировкаТекста.UTF8);
		СтрокаНастроек = ТекстовыйДокумент.ПолучитьТекст();
		
		СохраненныеНастройки.Добавить(СтрокаНастроек);
		КоличествоНастроек = КоличествоНастроек + 1;
		
		УдалитьФайлы(ИмяВременногоФайла);
	КонецЦикла;
	МакетОпределен = (КоличествоНастроек > 1);
	
	Возврат СохраненныеНастройки;
КонецФункции

&НаСервере
Функция ЗначениеВСтрокуXML(Значение)
	
	ЗаписьXML = Новый ЗаписьXML;
	ЗаписьXML.УстановитьСтроку();
	СериализаторXDTO.ЗаписатьXML(ЗаписьXML, Значение, НазначениеТипаXML.Явное);
	
	Возврат ЗаписьXML.Закрыть();
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ОбщийМодуль(Имя)
	
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	Если Метаданные.ОбщиеМодули.Найти(Имя) <> Неопределено Тогда
		Модуль = Вычислить(Имя);
	Иначе
		Модуль = Неопределено;
	КонецЕсли;
	
#Иначе
	Модуль = Вычислить(Имя);
#КонецЕсли
	
	Возврат Модуль;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура СообщитьПользователю(Знач ТекстСообщенияПользователю)
	
	Сообщение = Новый СообщениеПользователю;
	Сообщение.Текст = ТекстСообщенияПользователю;
	
	Сообщение.Сообщить();

	
КонецПроцедуры

#КонецОбласти
