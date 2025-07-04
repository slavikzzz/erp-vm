
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Параметры.Свойство("Заголовок",              Заголовок);
	Параметры.Свойство("ИдентификаторВладельца", ИдентификаторВладельца);
	Параметры.Свойство("ВидЭлемента",            ВидЭлемента);
	Параметры.Свойство("ИмяТипаЭлемента",        ИмяТипаЭлемента);
	
	ТекущийОбъект = Справочники[ИмяТипаЭлемента].СоздатьЭлемент();
	
	АдресТаблицыСвойств = Неопределено;
	Если Параметры.Свойство("АдресТаблицыСвойств", АдресТаблицыСвойств)
			И ЭтоАдресВременногоХранилища(АдресТаблицыСвойств) Тогда
		ТекущийОбъект.ДополнительныеРеквизиты.Загрузить(ПолучитьИзВременногоХранилища(АдресТаблицыСвойств));
	КонецЕсли;
	
	ИмяРеквизитаОбъекта = ИмяРеквизитаОбъекта(ВидЭлемента);
	ЗначениеВРеквизитФормы(ТекущийОбъект, ИмяРеквизитаОбъекта);
	
	// СтандартныеПодсистемы.Свойства
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Объект", ЭтотОбъект[ИмяРеквизитаОбъекта]);
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект, ДополнительныеПараметры);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если Модифицированность Тогда
		СтандартнаяОбработка = Ложь;
		Отказ = Истина;
		ПоказатьВопрос(Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект),
			НСтр("ru = 'Данные были изменены. Сохранить изменения?';
				|en = 'The data has changed. Do you want to save the changes?'"),
			РежимДиалогаВопрос.ДаНетОтмена);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты, ЭтотОбъект[ИмяРеквизитаОбъекта]);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СохранитьИЗакрыть(Команда)
	
	ЗавершитьРедактирование();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ЗавершитьРедактирование()
	
	Результат = ЗавершитьРедактированиеНаСервере();
	
	Если Результат <> Неопределено Тогда
		
		Модифицированность = Ложь;
		
		Закрыть(Результат);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ЗавершитьРедактированиеНаСервере()
	
	Если ПроверитьЗаполнение() Тогда
	
		ТекущийОбъект = ЭтотОбъект[ИмяРеквизитаОбъекта];
		
		УправлениеСвойствами.ПеренестиЗначенияИзРеквизитовФормыВОбъект(ЭтотОбъект, ТекущийОбъект);
		
		Возврат ПоместитьВоВременноеХранилище(ТекущийОбъект.ДополнительныеРеквизиты.Выгрузить(), ИдентификаторВладельца);
		
	Иначе
		
		Возврат Неопределено;
		
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		ЗавершитьРедактирование();
	ИначеЕсли РезультатВопроса = КодВозвратаДиалога.Нет Тогда
		Модифицированность = Ложь;
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ИмяРеквизитаОбъекта(ВидЭлемента)
	
	ДоступныеРеквизиты = Новый Структура;
	ДоступныеРеквизиты.Вставить("Этап",     "ЭтапОбъект");
	ДоступныеРеквизиты.Вставить("Операция", "ОперацияОбъект");
	
	Возврат ДоступныеРеквизиты[ВидЭлемента];
	
КонецФункции

#Область УниверсальныеМеханизмы

// СтандартныеПодсистемы.Свойства

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект, ЭтотОбъект[ИмяРеквизитаОбъекта]);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект, ЭтотОбъект[ИмяРеквизитаОбъекта]);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры

// Конец СтандартныеПодсистемы.Свойства

#КонецОбласти

#КонецОбласти