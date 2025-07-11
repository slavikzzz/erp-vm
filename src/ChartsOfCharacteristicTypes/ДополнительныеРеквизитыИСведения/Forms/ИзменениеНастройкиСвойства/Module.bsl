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
	
	Если Параметры.ЭтоДополнительноеСведение Тогда
		Элементы.ТипыСвойства.ТекущаяСтраница = Элементы.ДополнительноеСведение;
		Заголовок = НСтр("ru = 'Изменить настройку дополнительного сведения';
						|en = 'Change additional information record settings'");
	Иначе
		Элементы.ТипыСвойства.ТекущаяСтраница = Элементы.ДополнительныйРеквизит;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.ВладелецДополнительныхЗначений) Тогда
		Элементы.ВидыРеквизита.ТекущаяСтраница = Элементы.ВидОбщиеЗначенияРеквизитов;
		Элементы.ВидыСведения.ТекущаяСтраница  = Элементы.ВидОбщиеЗначенияСведений;
		ОтдельноеСвойствоСОбщимСпискомЗначений = 1;
	Иначе
		Элементы.ВидыРеквизита.ТекущаяСтраница = Элементы.ВидОбщийРеквизит;
		Элементы.ВидыСведения.ТекущаяСтраница  = Элементы.ВидОбщееСведение;
		ОбщееСвойство = 1;
	КонецЕсли;
	
	Свойство = Параметры.Свойство;
	ТекущийНаборСвойств = Параметры.ТекущийНаборСвойств;
	ЭтоДополнительноеСведение = Параметры.ЭтоДополнительноеСведение;
	
	Элементы.ОтдельныеЗначенияРеквизитаКомментарий.Заголовок =
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Элементы.ОтдельныеЗначенияРеквизитаКомментарий.Заголовок, ТекущийНаборСвойств);
	
	Элементы.ОбщиеЗначенияРеквизитовКомментарий.Заголовок =
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Элементы.ОбщиеЗначенияРеквизитовКомментарий.Заголовок, ТекущийНаборСвойств);
	
	Элементы.ОтдельныеЗначенияСведенияКомментарий.Заголовок =
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Элементы.ОтдельныеЗначенияСведенияКомментарий.Заголовок, ТекущийНаборСвойств);
	
	Элементы.ОбщиеЗначенияСведенийКомментарий.Заголовок =
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Элементы.ОбщиеЗначенияСведенийКомментарий.Заголовок, ТекущийНаборСвойств);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения("ЗаписатьИЗакрытьЗавершение", ЭтотОбъект);
	ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(Оповещение, Отказ, ЗавершениеРаботы);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВидПриИзменении(Элемент)
	
	ВидПриИзмененииНаСервере(Элемент.Имя);
	
КонецПроцедуры

&НаСервере
Процедура ВидПриИзмененииНаСервере(ИмяЭлемента)
	
	ОтдельноеСвойствоСОбщимСпискомЗначений = 0;
	ОтдельноеСвойствоСОтдельнымСпискомЗначений = 0;
	ОбщееСвойство = 0;
	
	ЭтотОбъект[Элементы[ИмяЭлемента].ПутьКДанным] = 1;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	ЗаписатьИЗакрытьЗавершение();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ЗаписатьИЗакрытьЗавершение(Результат = Неопределено, ДополнительныеПараметры = Неопределено) Экспорт
	
	Если ОтдельноеСвойствоСОтдельнымСпискомЗначений = 1 Тогда
		ЗаписатьНачало();
	Иначе
		ЗаписатьЗавершение(Неопределено);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьНачало()
	
	РезультатВыполнения = ЗаписатьНаСервере();
	
	Если РезультатВыполнения.Статус = "Выполнено" Тогда
		ОткрытьСвойство = ПолучитьИзВременногоХранилища(РезультатВыполнения.АдресРезультата);
		ЗаписатьЗавершение(ОткрытьСвойство);
	Иначе
		ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
		ОповещениеОЗавершении = Новый ОписаниеОповещения("ЗаписатьПродолжение", ЭтотОбъект);
		
		ДлительныеОперацииКлиент.ОжидатьЗавершение(РезультатВыполнения, ОповещениеОЗавершении, ПараметрыОжидания);
	КонецЕсли;
	
КонецПроцедуры

// Параметры:
//  Результат - см. ДлительныеОперацииКлиент.НовыйРезультатДлительнойОперации
//  ДополнительныеПараметры - Неопределено
//
&НаКлиенте
Процедура ЗаписатьПродолжение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Результат.Статус = "Ошибка" Тогда
		СтандартныеПодсистемыКлиент.ВывестиИнформациюОбОшибке(
			Результат.ИнформацияОбОшибке);
		Возврат;
	КонецЕсли;
	
	ОткрытьСвойство = ПолучитьИзВременногоХранилища(Результат.АдресРезультата);
	
	ЗаписатьЗавершение(ОткрытьСвойство);
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьЗавершение(ОткрытьСвойство)
	
	Модифицированность = Ложь;
	
	Оповестить("Запись_ДополнительныеРеквизитыИСведения",
		Новый Структура("Ссылка", Свойство), Свойство);
	
	Оповестить("Запись_НаборыДополнительныхРеквизитовИСведений",
		Новый Структура("Ссылка", ТекущийНаборСвойств), ТекущийНаборСвойств);
	
	ОповеститьОВыборе(ОткрытьСвойство);
	
КонецПроцедуры

&НаСервере
Функция ЗаписатьНаСервере()
	
	НаименованиеЗадания = НСтр("ru = 'Изменение настройки дополнительного свойства';
								|en = 'Change additional property settings'");
	
	ПараметрыПроцедуры = Новый Структура;
	ПараметрыПроцедуры.Вставить("Свойство", Свойство);
	ПараметрыПроцедуры.Вставить("ТекущийНаборСвойств", ТекущийНаборСвойств);
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.ОжидатьЗавершение = 2;
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НаименованиеЗадания;
	
	Результат = ДлительныеОперации.ВыполнитьВФоне("ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.ИзменитьНастройкуСвойства",
		ПараметрыПроцедуры, ПараметрыВыполнения);
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти
