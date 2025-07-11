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
	
	ПользовательСсылка             = Параметры.Пользователь;
	ДействиеСНастройками           = Параметры.ДействиеСНастройками;
	ПользовательИнформационнойБазы = Обработки.НастройкиПользователей.ИмяПользователяИБ(ПользовательСсылка);
	ТекущийПользовательСсылка      = Пользователи.ТекущийПользователь();
	ТекущийПользователь            = Обработки.НастройкиПользователей.ИмяПользователяИБ(ТекущийПользовательСсылка);
	
	ВыбраннаяСтраницаНастроек = Элементы.ВидыНастроек.ТекущаяСтраница.Имя;
	
	ИмяФормыПерсональныхНастроек = 
		ОбщегоНазначения.ОбщиеПараметрыБазовойФункциональности().ИмяФормыПерсональныхНастроек;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ДанныеВХранилищеНастроекСохранены
	   И ТипЗнч(ВладелецФормы) = Тип("ФормаКлиентскогоПриложения") Тогда
		
		Свойства = Новый Структура("ОчиститьИсториюВыбораНастроек", Ложь);
		ЗаполнитьЗначенияСвойств(ВладелецФормы, Свойства);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриСохраненииДанныхВНастройкахНаСервере(Настройки)
	
	Настройки.Удалить("ВнешнийВид");
	Настройки.Удалить("НастройкиОтчетов");
	Настройки.Удалить("ПрочиеНастройки");
	
	ВнешнийВидДерево       = РеквизитФормыВЗначение("ВнешнийВид");
	НастройкиОтчетовДерево = РеквизитФормыВЗначение("НастройкиОтчетов");
	ПрочиеНастройкиДерево  = РеквизитФормыВЗначение("ПрочиеНастройки");
	
	ПомеченныеНастройкиВнешнегоВида = ПомеченныеНастройки(ВнешнийВидДерево);
	ПомеченныеНастройкиОтчетов      = ПомеченныеНастройки(НастройкиОтчетовДерево);
	ПомеченныеПрочиеНастройки       = ПомеченныеНастройки(ПрочиеНастройкиДерево);
	
	Настройки.Вставить("ПомеченныеНастройкиВнешнегоВида", ПомеченныеНастройкиВнешнегоВида);
	Настройки.Вставить("ПомеченныеНастройкиОтчетов",      ПомеченныеНастройкиОтчетов);
	Настройки.Вставить("ПомеченныеПрочиеНастройки",       ПомеченныеПрочиеНастройки);
	
	ДанныеВХранилищеНастроекСохранены = Истина;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	ВсеВыбранныеНастройки = Новый Структура;
	ВсеВыбранныеНастройки.Вставить("ПомеченныеНастройкиВнешнегоВида");
	ВсеВыбранныеНастройки.Вставить("ПомеченныеНастройкиОтчетов");
	ВсеВыбранныеНастройки.Вставить("ПомеченныеПрочиеНастройки");
	
	Если Параметры.ОчиститьИсториюВыбораНастроек Тогда
		Настройки.Очистить();
		Возврат;
	КонецЕсли;
	
	ПомеченныеНастройкиВнешнегоВида = Настройки.Получить("ПомеченныеНастройкиВнешнегоВида");
	ПомеченныеНастройкиОтчетов      = Настройки.Получить("ПомеченныеНастройкиОтчетов");
	ПомеченныеПрочиеНастройки       = Настройки.Получить("ПомеченныеПрочиеНастройки");
	
	ВсеВыбранныеНастройки.ПомеченныеНастройкиВнешнегоВида = ПомеченныеНастройкиВнешнегоВида;
	ВсеВыбранныеНастройки.ПомеченныеНастройкиОтчетов = ПомеченныеНастройкиОтчетов;
	ВсеВыбранныеНастройки.ПомеченныеПрочиеНастройки = ПомеченныеПрочиеНастройки;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ОбновитьСписокНастроек();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПриСменеСтраницы(Элемент, ТекущаяСтраница)
	
	ВыбраннаяСтраницаНастроек = ТекущаяСтраница.Имя;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоНастроекВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПользователиСлужебныйКлиент.ОткрытьОтчетИлиФорму(
		ТекущийЭлемент, ПользовательИнформационнойБазы, ТекущийПользователь, ИмяФормыПерсональныхНастроек);
	
КонецПроцедуры

&НаКлиенте
Процедура ПометкаПриИзменении(Элемент)
	
	ИзменитьПометку(Элемент);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Обновить(Команда)
	
	ОбновитьСписокНастроек();
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьНастройку(Команда)
	
	ПользователиСлужебныйКлиент.ОткрытьОтчетИлиФорму(
		ТекущийЭлемент, ПользовательИнформационнойБазы, ТекущийПользователь, ИмяФормыПерсональныхНастроек);
	
КонецПроцедуры

&НаКлиенте
Процедура ПометитьВсе(Команда)
	
	Если ВыбраннаяСтраницаНастроек = "НастройкиОтчетовСтраница" Тогда
		ДеревоНастроек = НастройкиОтчетов.ПолучитьЭлементы();
		ПометитьЭлементыДерева(ДеревоНастроек, Истина);
	ИначеЕсли ВыбраннаяСтраницаНастроек = "ВнешнийВидСтраница" Тогда
		ДеревоНастроек = ВнешнийВид.ПолучитьЭлементы();
		ПометитьЭлементыДерева(ДеревоНастроек, Истина);
	Иначе
		ДеревоНастроек = ПрочиеНастройки.ПолучитьЭлементы();
		ПометитьЭлементыДерева(ДеревоНастроек, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьПометкуСоВсех(Команда)
	
	Если ВыбраннаяСтраницаНастроек = "НастройкиОтчетовСтраница" Тогда
		ДеревоНастроек = НастройкиОтчетов.ПолучитьЭлементы();
		ПометитьЭлементыДерева(ДеревоНастроек, Ложь);
	ИначеЕсли ВыбраннаяСтраницаНастроек = "ВнешнийВидСтраница" Тогда
		ДеревоНастроек = ВнешнийВид.ПолучитьЭлементы();
		ПометитьЭлементыДерева(ДеревоНастроек, Ложь);
	Иначе
		ДеревоНастроек = ПрочиеНастройки.ПолучитьЭлементы();
		ПометитьЭлементыДерева(ДеревоНастроек, Ложь);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Выбрать(Команда)
	
	Результат = Новый Структура;
	
	ВыбранныеНастройкиВнешнегоВида    = ВыбранныеНастройки(ВнешнийВид);
	ВыбранныеНастройкиОтчетов         = ВыбранныеНастройки(НастройкиОтчетов);
	ВыбранныеПрочиеНастройкиСтруктура = ВыбранныеНастройки(ПрочиеНастройки);
	
	КоличествоНастроек = ВыбранныеНастройкиВнешнегоВида.КоличествоНастроек
	                   + ВыбранныеНастройкиОтчетов.КоличествоНастроек
	                   + ВыбранныеПрочиеНастройкиСтруктура.КоличествоНастроек;
	
	Если ВыбранныеНастройкиОтчетов.КоличествоНастроек = 1 Тогда
		ПредставленияНастроек = ВыбранныеНастройкиОтчетов.ПредставленияНастроек;
	ИначеЕсли ВыбранныеНастройкиВнешнегоВида.КоличествоНастроек = 1 Тогда
		ПредставленияНастроек = ВыбранныеНастройкиВнешнегоВида.ПредставленияНастроек;
	ИначеЕсли ВыбранныеПрочиеНастройкиСтруктура.КоличествоНастроек = 1 Тогда
		ПредставленияНастроек = ВыбранныеПрочиеНастройкиСтруктура.ПредставленияНастроек;
	КонецЕсли;
	
	Результат.Вставить("ВнешнийВид",       ВыбранныеНастройкиВнешнегоВида.МассивНастроек);
	Результат.Вставить("НастройкиОтчетов", ВыбранныеНастройкиОтчетов.МассивНастроек);
	Результат.Вставить("ПрочиеНастройки",  ВыбранныеПрочиеНастройкиСтруктура.МассивНастроек);
	
	Результат.Вставить("ПредставленияНастроек", ПредставленияНастроек);
	Результат.Вставить("КоличествоНастроек",    КоличествоНастроек);
	
	Результат.Вставить("ТаблицаВариантовОтчетов",  ТаблицаПользовательскихВариантовОтчетов);
	Результат.Вставить("ВыбранныеВариантыОтчетов", ВыбранныеНастройкиОтчетов.ВариантыОтчетов);
	
	Результат.Вставить("ПерсональныеНастройки",           ВыбранныеПрочиеНастройкиСтруктура.МассивПерсональныхНастроек);
	Результат.Вставить("ПрочиеПользовательскиеНастройки", ВыбранныеПрочиеНастройкиСтруктура.ПрочиеПользовательскиеНастройки);
	
	Закрыть(Результат);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// Процедуры и функции, отвечающие за вывод настроек пользователю.

&НаКлиенте
Процедура ОбновитьСписокНастроек()
	
	Элементы.КоманднаяПанель.Доступность = Ложь;
	Элементы.СтраницыДлительнаяОперация.ТекущаяСтраница = Элементы.СтраницаДлительнаяОперация;
	Результат = ОбновлениеСпискаНастроек();
	
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
	ОповещениеОЗавершении = Новый ОписаниеОповещения("ОбновитьСписокНастроекЗавершение", ЭтотОбъект);
	
	ДлительныеОперацииКлиент.ОжидатьЗавершение(Результат, ОповещениеОЗавершении, ПараметрыОжидания);
	
КонецПроцедуры

&НаСервере
Функция ОбновлениеСпискаНастроек()
	
	Если ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ДлительныеОперации.ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
		ИдентификаторЗадания = Неопределено;
	КонецЕсли;
	
	ПараметрыДлительнойОперации = ПараметрыДлительнойОперации();
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.ОжидатьЗавершение = 0; // запускать сразу
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Обновление настроек пользователей';
															|en = 'Update user settings'");
	
	ДлительнаяОперация = ДлительныеОперации.ВыполнитьВФоне("ПользователиСлужебный.ЗаполнитьСпискиНастроек",
		ПараметрыДлительнойОперации, ПараметрыВыполнения);
	
	Если ДлительнаяОперация.Статус = "Выполняется" Тогда
		ИдентификаторЗадания = ДлительнаяОперация.ИдентификаторЗадания; 
	КонецЕсли;
	
	Возврат ДлительнаяОперация;
	
КонецФункции

// Параметры:
//  Результат - см. ДлительныеОперацииКлиент.НовыйРезультатДлительнойОперации
//  ДополнительныеПараметры - Неопределено
//
&НаКлиенте
Процедура ОбновитьСписокНастроекЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Элементы.СтраницыДлительнаяОперация.ТекущаяСтраница = Элементы.СтраницаНастройки;
	Элементы.КоманднаяПанель.Доступность = Истина;
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Результат.Статус = "Выполнено" Тогда
		ЗаполнитьНастройки(Результат.АдресРезультата);
		РазвернутьДеревоЗначений();
		
	ИначеЕсли Результат.Статус = "Ошибка" Тогда
		СтандартныеПодсистемыКлиент.ВывестиИнформациюОбОшибке(
			Результат.ИнформацияОбОшибке);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНастройки(Знач АдресРезультата)
	
	Результат = ПолучитьИзВременногоХранилища(АдресРезультата);
	
	ЗначениеВРеквизитФормы(Результат.НастройкиОтчетовДерево, "НастройкиОтчетов");
	ЗначениеВРеквизитФормы(Результат.ПользовательскиеВариантыОтчетов, "ТаблицаПользовательскихВариантовОтчетов");
	ЗначениеВРеквизитФормы(Результат.НастройкиВнешнегоВида, "ВнешнийВид");
	ЗначениеВРеквизитФормы(Результат.ПрочиеНастройкиДерево, "ПрочиеНастройки");
	
	Если Не НачальныеНастройкиЗагружены 
		И ВсеВыбранныеНастройки <> Неопределено Тогда
		ЗагрузитьЗначенияПометок(НастройкиОтчетов, ВсеВыбранныеНастройки.ПомеченныеНастройкиОтчетов, "НастройкиОтчетов");
		ЗагрузитьЗначенияПометок(ВнешнийВид, ВсеВыбранныеНастройки.ПомеченныеНастройкиВнешнегоВида, "ВнешнийВид");
		ЗагрузитьЗначенияПометок(ПрочиеНастройки, ВсеВыбранныеНастройки.ПомеченныеПрочиеНастройки, "ПрочиеНастройки");
		НачальныеНастройкиЗагружены = Истина;
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Вспомогательные процедуры и функции.

&НаКлиенте
Процедура ИзменитьПометку(Элемент)
	
	ПомеченныйЭлемент = Элемент.Родитель.Родитель.ТекущиеДанные;
	ЗначениеПометки = ПомеченныйЭлемент.Пометка;
	
	Если ЗначениеПометки = 2 Тогда
		ЗначениеПометки = 0;
		ПомеченныйЭлемент.Пометка = ЗначениеПометки;
	КонецЕсли;
	
	РодительЭлемента = ПомеченныйЭлемент.ПолучитьРодителя();
	ДочерниеЭлементы = ПомеченныйЭлемент.ПолучитьЭлементы();
	КоличествоНастроек = 0;
	
	Если РодительЭлемента = Неопределено Тогда
		
		Для Каждого ДочернийЭлемент Из ДочерниеЭлементы Цикл
			
			Если ДочернийЭлемент.Пометка <> ЗначениеПометки Тогда
				КоличествоНастроек = КоличествоНастроек + 1
			КонецЕсли;
			
			ДочернийЭлемент.Пометка = ЗначениеПометки;
		КонецЦикла;
		
		Если ДочерниеЭлементы.Количество() = 0 Тогда
			КоличествоНастроек = КоличествоНастроек + 1;
		КонецЕсли;
		
	Иначе
		ПроверитьПометкиДочернихЭлементовИОтметитьРодителя(РодительЭлемента, ЗначениеПометки);
		КоличествоНастроек = КоличествоНастроек + 1;
	КонецЕсли;
	
	КоличествоНастроек = ?(ЗначениеПометки, КоличествоНастроек, -КоличествоНастроек);
	// Обновление заголовка страницы настроек.
	ОбновитьЗаголовокСтраницы(КоличествоНастроек);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЗаголовокСтраницы(КоличествоНастроек)
	
	Если ВыбраннаяСтраницаНастроек = "НастройкиОтчетовСтраница" Тогда
		
		КоличествоНастроекОтчетов = КоличествоНастроекОтчетов + КоличествоНастроек;
		
		Если КоличествоНастроекОтчетов = 0 Тогда
			ТекстЗаголовка = НСтр("ru = 'Настройки отчетов';
									|en = 'Report settings'");
		Иначе
			ТекстЗаголовка = НСтр("ru = 'Настройки отчетов (%1)';
									|en = 'Report settings (%1)'");
			ТекстЗаголовка = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстЗаголовка, КоличествоНастроекОтчетов);
		КонецЕсли;
		
		Элементы.НастройкиОтчетовСтраница.Заголовок = ТекстЗаголовка;
		
	ИначеЕсли ВыбраннаяСтраницаНастроек = "ВнешнийВидСтраница" Тогда
		
		КоличествоНастроекВнешнегоВида = КоличествоНастроекВнешнегоВида + КоличествоНастроек;
		Если КоличествоНастроекВнешнегоВида = 0 Тогда
			ТекстЗаголовка = НСтр("ru = 'Внешний вид';
									|en = 'Interface settings'");
		Иначе
			ТекстЗаголовка = НСтр("ru = 'Внешний вид (%1)';
									|en = 'Interface settings (%1)'");
			ТекстЗаголовка = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстЗаголовка, КоличествоНастроекВнешнегоВида);
		КонецЕсли;
		
		Элементы.ВнешнийВидСтраница.Заголовок = ТекстЗаголовка;
		
	ИначеЕсли ВыбраннаяСтраницаНастроек = "ПрочиеНастройкиСтраница" Тогда
		
		КоличествоПрочихНастроек = КоличествоПрочихНастроек + КоличествоНастроек;
		Если КоличествоПрочихНастроек = 0 Тогда
			ТекстЗаголовка = НСтр("ru = 'Прочие настройки';
									|en = 'Other settings'");
		Иначе
			ТекстЗаголовка = НСтр("ru = 'Прочие настройки (%1)';
									|en = 'Other settings (%1)'");
			ТекстЗаголовка = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстЗаголовка, КоличествоПрочихНастроек);
		КонецЕсли;
		
		Элементы.ПрочиеНастройкиСтраница.Заголовок = ТекстЗаголовка;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьПометкиДочернихЭлементовИОтметитьРодителя(ЭлементДерева, ЗначениеПометки)
	
	ЕстьНеПомеченные = Ложь;
	ЕстьПомеченные = Ложь;
	
	ДочерниеЭлементы = ЭлементДерева.ПолучитьЭлементы();
	Если ДочерниеЭлементы = Неопределено Тогда
		ЭлементДерева.Пометка = ЗначениеПометки;
	Иначе
		
		Для Каждого ДочернийЭлемент Из ДочерниеЭлементы Цикл
			
			Если ДочернийЭлемент.Пометка = 0 Тогда
				ЕстьНеПомеченные = Истина;
			ИначеЕсли ДочернийЭлемент.Пометка = 1 Тогда
				ЕстьПомеченные = Истина;
			КонецЕсли;
			
		КонецЦикла;
		
		Если ЕстьНеПомеченные 
			И ЕстьПомеченные Тогда
			ЭлементДерева.Пометка = 2;
		ИначеЕсли ЕстьПомеченные Тогда
			ЭлементДерева.Пометка = 1;
		Иначе
			ЭлементДерева.Пометка = 0;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПометитьЭлементыДерева(ДеревоНастроек, ЗначениеПометки)
	
	КоличествоНастроек = 0;
	Для Каждого ЭлементДерева Из ДеревоНастроек Цикл
		ДочерниеЭлементы = ЭлементДерева.ПолучитьЭлементы();
		
		Для Каждого ДочернийЭлемент Из ДочерниеЭлементы Цикл
			
			ДочернийЭлемент.Пометка = ЗначениеПометки;
			КоличествоНастроек = КоличествоНастроек + 1;
			
		КонецЦикла;
		
		Если ДочерниеЭлементы.Количество() = 0 Тогда
			КоличествоНастроек = КоличествоНастроек + 1;
		КонецЕсли;
		
		ЭлементДерева.Пометка = ЗначениеПометки;
	КонецЦикла;
	
	КоличествоНастроек = ?(ЗначениеПометки, КоличествоНастроек, 0);
	
	Если ВыбраннаяСтраницаНастроек = "НастройкиОтчетовСтраница" Тогда
		КоличествоНастроекОтчетов = КоличествоНастроек;
	ИначеЕсли ВыбраннаяСтраницаНастроек = "ВнешнийВидСтраница" Тогда
		КоличествоНастроекВнешнегоВида = КоличествоНастроек;
	ИначеЕсли ВыбраннаяСтраницаНастроек = "ПрочиеНастройкиСтраница" Тогда
		КоличествоПрочихНастроек = КоличествоНастроек;
	КонецЕсли;
	
	ОбновитьЗаголовокСтраницы(0);
	
КонецПроцедуры

&НаКлиенте
Функция ВыбранныеНастройки(ДеревоНастроек)
	
	МассивНастроек = Новый Массив;
	МассивПерсональныхНастроек = Новый Массив;
	ПредставленияНастроек = Новый Массив;
	МассивВариантовОтчетов = Новый Массив;
	ПрочиеПользовательскиеНастройки = Новый Массив;
	КоличествоНастроек = 0;
	
	Для Каждого Настройка Из ДеревоНастроек.ПолучитьЭлементы() Цикл
		
		Если Настройка.Пометка = 1 Тогда
			
			Если Настройка.Тип = "ПерсональныеНастройки" Тогда
				МассивПерсональныхНастроек.Добавить(Настройка.Ключи);
			ИначеЕсли Настройка.Тип = "ПрочаяПользовательскаяНастройка" Тогда
				ПользовательскиеНастройки = Новый Структура;
				ПользовательскиеНастройки.Вставить("ИдентификаторНастройки", Настройка.ТипСтроки);
				ПользовательскиеНастройки.Вставить("ЗначениеНастройки", Настройка.Ключи);
				ПрочиеПользовательскиеНастройки.Добавить(ПользовательскиеНастройки);
			Иначе
				МассивНастроек.Добавить(Настройка.Ключи);
				
				Если Настройка.Тип = "ВариантЛичный" Тогда
					МассивВариантовОтчетов.Добавить(Настройка.Ключи);
				КонецЕсли;
				
			КонецЕсли;
			КоличествоДочерних = Настройка.ПолучитьЭлементы().Количество();
			КоличествоНастроек = КоличествоНастроек + ?(КоличествоДочерних=0,1,КоличествоДочерних);
			
			Если КоличествоДочерних = 1 Тогда
				
				ДочерняяНастройка = Настройка.ПолучитьЭлементы()[0];
				ПредставленияНастроек.Добавить(Настройка.Настройка + " - " + ДочерняяНастройка.Настройка);
				
			ИначеЕсли КоличествоДочерних = 0 Тогда
				ПредставленияНастроек.Добавить(Настройка.Настройка);
			КонецЕсли;
			
		Иначе
			ДочерниеНастройки = Настройка.ПолучитьЭлементы();
			
			Для Каждого ДочерняяНастройка Из ДочерниеНастройки Цикл
				
				Если ДочерняяНастройка.Пометка = 1 Тогда
					МассивНастроек.Добавить(ДочерняяНастройка.Ключи);
					ПредставленияНастроек.Добавить(Настройка.Настройка + " - " + ДочерняяНастройка.Настройка);
					КоличествоНастроек = КоличествоНастроек + 1;
				КонецЕсли;
				
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЦикла;
	
	СтруктураНастроек = Новый Структура;
	
	СтруктураНастроек.Вставить("МассивНастроек", МассивНастроек);
	СтруктураНастроек.Вставить("МассивПерсональныхНастроек", МассивПерсональныхНастроек);
	СтруктураНастроек.Вставить("ПрочиеПользовательскиеНастройки", ПрочиеПользовательскиеНастройки);
	СтруктураНастроек.Вставить("ВариантыОтчетов", МассивВариантовОтчетов);
	СтруктураНастроек.Вставить("ПредставленияНастроек", ПредставленияНастроек);
	СтруктураНастроек.Вставить("КоличествоНастроек", КоличествоНастроек);
	
	Возврат СтруктураНастроек;
	
КонецФункции

&НаКлиенте
Процедура РазвернутьДеревоЗначений()
	
	Для Каждого Элемент Из НастройкиОтчетов.ПолучитьЭлементы() Цикл 
		Элементы.НастройкиОтчетовДерево.Развернуть(Элемент.ПолучитьИдентификатор(), Истина);
	КонецЦикла;
	
	Для Каждого Элемент Из ВнешнийВид.ПолучитьЭлементы() Цикл 
		Элементы.ВнешнийВид.Развернуть(Элемент.ПолучитьИдентификатор(), Истина);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ПараметрыДлительнойОперации()
	
	ПараметрыДлительнойОперации = Новый Структура;
	ПараметрыДлительнойОперации.Вставить("ИмяФормы");
	ПараметрыДлительнойОперации.Вставить("ДействиеСНастройками");
	ПараметрыДлительнойОперации.Вставить("ПользовательИнформационнойБазы");
	ПараметрыДлительнойОперации.Вставить("ПользовательСсылка");
	
	ЗаполнитьЗначенияСвойств(ПараметрыДлительнойОперации, ЭтотОбъект);
	
	ПараметрыДлительнойОперации.Вставить("НастройкиОтчетовДерево",          РеквизитФормыВЗначение("НастройкиОтчетов"));
	ПараметрыДлительнойОперации.Вставить("НастройкиВнешнегоВида",           РеквизитФормыВЗначение("ВнешнийВид"));
	ПараметрыДлительнойОперации.Вставить("ПрочиеНастройкиДерево",           РеквизитФормыВЗначение("ПрочиеНастройки"));
	ПараметрыДлительнойОперации.Вставить("ПользовательскиеВариантыОтчетов", РеквизитФормыВЗначение("ТаблицаПользовательскихВариантовОтчетов"));
	
	Возврат ПараметрыДлительнойОперации;
	
КонецФункции

&НаСервере
Функция ПомеченныеНастройки(ДеревоНастроек)
	
	СписокПомеченных = Новый СписокЗначений;
	ОтборПомеченных = Новый Структура("Пометка", 1);
	ОтборНеопределенных = Новый Структура("Пометка", 2);
	
	МассивПомеченных = ДеревоНастроек.Строки.НайтиСтроки(ОтборПомеченных, Истина);
	Для Каждого СтрокаМассива Из МассивПомеченных Цикл
		СписокПомеченных.Добавить(СтрокаМассива.ТипСтроки, , Истина);
	КонецЦикла;
	
	МассивНеопределенных = ДеревоНастроек.Строки.НайтиСтроки(ОтборНеопределенных, Истина);
	Для Каждого СтрокаМассива Из МассивНеопределенных Цикл
		СписокПомеченных.Добавить(СтрокаМассива.ТипСтроки);
	КонецЦикла;
	
	Возврат СписокПомеченных;
	
КонецФункции

&НаСервере
Процедура ЗагрузитьЗначенияПометок(ДеревоЗначений, ПомеченныеНастройки, ВидНастроек)
	
	Если ПомеченныеНастройки = Неопределено Тогда
		Возврат;
	КонецЕсли;
	КоличествоПомеченных = 0;
	
	Для Каждого СтрокаПомеченныеНастройки Из ПомеченныеНастройки Цикл
		
		ПомеченнаяНастройка = СтрокаПомеченныеНастройки.Значение;
		
		Для Каждого СтрокаДерева Из ДеревоЗначений.ПолучитьЭлементы() Цикл
			
			ДочерниеЭлементы = СтрокаДерева.ПолучитьЭлементы();
			
			Если СтрокаДерева.ТипСтроки = ПомеченнаяНастройка Тогда
				
				Если СтрокаПомеченныеНастройки.Пометка Тогда
					СтрокаДерева.Пометка = 1;
					
					Если ДочерниеЭлементы.Количество() = 0 Тогда
						КоличествоПомеченных = КоличествоПомеченных + 1;
					КонецЕсли;
					
				Иначе
					СтрокаДерева.Пометка = 2;
				КонецЕсли;
				
			Иначе
				
				Для Каждого ДочернийЭлемент Из ДочерниеЭлементы Цикл
					
					Если ДочернийЭлемент.ТипСтроки = ПомеченнаяНастройка Тогда
						ДочернийЭлемент.Пометка = 1;
						КоличествоПомеченных = КоличествоПомеченных + 1;
					КонецЕсли;
					
				КонецЦикла;
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
	
	Если КоличествоПомеченных > 0 Тогда
		
		Если ВидНастроек = "НастройкиОтчетов" Тогда
			КоличествоНастроекОтчетов = КоличествоПомеченных;
			Элементы.НастройкиОтчетовСтраница.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Настройки отчетов (%1)';
																														|en = 'Report settings (%1)'"), КоличествоПомеченных);
		ИначеЕсли ВидНастроек = "ВнешнийВид" Тогда
			КоличествоНастроекВнешнегоВида = КоличествоПомеченных;
			Элементы.ВнешнийВидСтраница.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Внешний вид (%1)';
																												|en = 'Interface settings (%1)'"), КоличествоПомеченных);
		ИначеЕсли ВидНастроек = "ПрочиеНастройки" Тогда
			КоличествоПрочихНастроек = КоличествоПомеченных;
			Элементы.ПрочиеНастройкиСтраница.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Прочие настройки (%1)';
																														|en = 'Other settings (%1)'"), КоличествоПомеченных);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
