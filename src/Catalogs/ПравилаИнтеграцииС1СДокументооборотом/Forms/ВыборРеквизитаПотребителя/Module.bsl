#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Объект = Метаданные.НайтиПоПолномуИмени(Параметры.ТипОбъекта);
	Если Объект <> Неопределено Тогда
		Синоним = ?(Объект.Синоним = "", Объект.Имя, Объект.Синоним);
	Иначе
		Синоним = ИнтеграцияС1СДокументооборотБазоваяФункциональность.СокращенноеНаименованиеКонфигурации();
	КонецЕсли;
	
	Если Параметры.ЭтоТаблица Тогда
		Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Выбор таблицы %1';
				|en = 'Select table %1'"), Синоним);
	Иначе
		Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Выбор реквизита %1';
				|en = 'Select attribute %1'"), Синоним);
	КонецЕсли;
	
	ЗаполнитьДеревоРеквизитов(Параметры.ТипОбъекта,
		Параметры.ИмяРеквизитаОбъектаИС,
		Параметры.ПредставлениеРеквизитаОбъектаДО,
		Параметры.ЭтоТаблица,
		Параметры.Таблица);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДеревоРеквизитов

&НаКлиенте
Процедура ДеревоРеквизитовПередРазворачиванием(Элемент, Строка, Отказ)
	
	ДанныеСтроки = ДеревоРеквизитов.НайтиПоИдентификатору(Строка);
	
	Если ДанныеСтроки = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ДанныеСтроки.РеквизитыСчитаны Тогда
		ЗаполнитьПодчиненныеРеквизиты(Строка, ДанныеСтроки.ИмяМетаданных);
		ДанныеСтроки.РеквизитыСчитаны = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоРеквизитовВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ВыбратьЗначениеРеквизита();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выбрать(Команда)
	
	ВыбратьЗначениеРеквизита();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ВыбратьЗначениеРеквизита()
	
	ТекущиеДанные = Элементы.ДеревоРеквизитов.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено
		Или ТекущиеДанные.Имя = ""
		Или ТекущиеДанные.Недоступно Тогда
		Возврат;
	КонецЕсли;
	
	Результат = Новый Структура;
	Результат.Вставить("Имя", ТекущиеДанные.Путь);
	Результат.Вставить("Представление", ТекущиеДанные.ПредставлениеПути);
	Результат.Вставить("ЭтоДополнительныйРеквизитИС", ТекущиеДанные.ЭтоДополнительныйРеквизитИС);
	Результат.Вставить("ДополнительныйРеквизитИС", ТекущиеДанные.ДополнительныйРеквизитИС);
	Результат.Вставить("ЭтоТаблица", ТекущиеДанные.ЭтоТаблица);
	Результат.Вставить("Таблица", ТекущиеДанные.Таблица);
	
	Закрыть(Результат);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДеревоРеквизитов(ИмяМетаданных, ИмяРеквизитаОбъектаИС, ПредставлениеРеквизитаОбъектаДО,
		ЭтоТаблица, Таблица)
	
	Дерево = РеквизитФормыВЗначение("ДеревоРеквизитов");
	Объект = Метаданные.НайтиПоПолномуИмени(ИмяМетаданных);
	
	Если Объект = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЭтоТаблица Тогда
		
		Для Каждого Реквизит Из Объект.СтандартныеРеквизиты Цикл
			
			Если Реквизит.Имя = "Проведен"
				Или Реквизит.Имя = "ПометкаУдаления"
				Или Реквизит.Имя = "Ссылка" Тогда
				Продолжить;
			КонецЕсли;
			
			Представление = Реквизит.Представление();
			
			НоваяСтрока = Дерево.Строки.Добавить();
			НоваяСтрока.Имя = Реквизит.Имя;
			НоваяСтрока.Путь = Реквизит.Имя;
			НоваяСтрока.Представление = Представление;
			НоваяСтрока.ПредставлениеПути = Представление;
			НоваяСтрока.Тип = Реквизит.Тип;
			
			Типы = Реквизит.Тип.Типы();
			Если Типы.Количество() > 1 Тогда
				Продолжить;
			КонецЕсли;
			
			ОбъектРеквизит = Метаданные.НайтиПоТипу(Типы[0]);
			Если ОбъектРеквизит = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			НоваяСтрока.ИмяМетаданных = ОбъектРеквизит.ПолноеИмя();
			
			Если Метаданные.Справочники.Содержит(ОбъектРеквизит)
					Или Метаданные.Документы.Содержит(ОбъектРеквизит)
					Или Метаданные.БизнесПроцессы.Содержит(ОбъектРеквизит)
					Или Метаданные.Задачи.Содержит(ОбъектРеквизит)
					Или Метаданные.ПланыВидовХарактеристик.Содержит(ОбъектРеквизит)
					Или Метаданные.ПланыСчетов.Содержит(ОбъектРеквизит) Тогда
				
				НоваяСтрока.ЕстьРеквизиты = Истина;
				НоваяСтрока.Строки.Добавить();
				
			КонецЕсли;
			
		КонецЦикла;
		
		НоваяСтрока = Дерево.Строки.Добавить();
		НоваяСтрока.Имя = "Представление";
		НоваяСтрока.Путь = "Представление";
		НоваяСтрока.Представление = НСтр("ru = 'Представление';
										|en = 'Presentation'");
		НоваяСтрока.ПредставлениеПути = НСтр("ru = 'Представление';
											|en = 'Presentation'");
		НоваяСтрока.Тип = "Строка";
		
		Для Каждого Реквизит Из Объект.Реквизиты Цикл
			
			Если СтрНачинаетсяС(Реквизит.Имя, "Удалить") Тогда
				Продолжить;
			КонецЕсли;
		
			Представление = Реквизит.Представление();
			
			НоваяСтрока = Дерево.Строки.Добавить();
			НоваяСтрока.Имя = Реквизит.Имя;
			НоваяСтрока.Путь = Реквизит.Имя;
			НоваяСтрока.Представление = Представление;
			НоваяСтрока.ПредставлениеПути = Представление;
			НоваяСтрока.Тип = Реквизит.Тип;
			
			Типы = Реквизит.Тип.Типы();
			Если Типы.Количество() > 1 Тогда
				Продолжить;
			КонецЕсли;
			
			ОбъектРеквизит = Метаданные.НайтиПоТипу(Типы[0]);
			Если ОбъектРеквизит = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			НоваяСтрока.ИмяМетаданных = ОбъектРеквизит.ПолноеИмя();
			
			Если Метаданные.Справочники.Содержит(ОбъектРеквизит)
					Или Метаданные.Документы.Содержит(ОбъектРеквизит)
					Или Метаданные.БизнесПроцессы.Содержит(ОбъектРеквизит)
					Или Метаданные.Задачи.Содержит(ОбъектРеквизит)
					Или Метаданные.ПланыВидовХарактеристик.Содержит(ОбъектРеквизит)
					Или Метаданные.ПланыСчетов.Содержит(ОбъектРеквизит) Тогда
				
				НоваяСтрока.ЕстьРеквизиты = Истина;
				НоваяСтрока.Строки.Добавить();
				
			КонецЕсли;
			
		КонецЦикла;
		
		Если Метаданные.ФункциональныеОпции.Найти("ИспользоватьДополнительныеРеквизитыИСведения") <> Неопределено
				И ПолучитьФункциональнуюОпцию("ИспользоватьДополнительныеРеквизитыИСведения") Тогда
			
			ВладелецСвойств = Новый(Тип(СтрЗаменить(ИмяМетаданных, ".", "Ссылка.")));
			
			Если УправлениеСвойствами.ИспользоватьДопРеквизиты(ВладелецСвойств) Тогда
				
				НаборДопРеквизитов = УправлениеСвойствами.СвойстваОбъекта(ВладелецСвойств, Истина, Ложь);
				СвойстваДопРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъектов(
					НаборДопРеквизитов,
					"Наименование, ТипЗначения");
				
				Для Каждого ДопРеквизит Из НаборДопРеквизитов Цикл
					СвойстваДопРеквизита = СвойстваДопРеквизитов[ДопРеквизит];
					
					НоваяСтрока = Дерево.Строки.Добавить();
					НоваяСтрока.Имя = СвойстваДопРеквизита.Наименование;
					НоваяСтрока.Путь = СвойстваДопРеквизита.Наименование;
					НоваяСтрока.Представление = СвойстваДопРеквизита.Наименование;
					НоваяСтрока.ПредставлениеПути = СвойстваДопРеквизита.Наименование;
					НоваяСтрока.Тип = СвойстваДопРеквизита.ТипЗначения;
					НоваяСтрока.ЭтоДополнительныйРеквизитИС = Истина;
					НоваяСтрока.ДополнительныйРеквизитИС = ДопРеквизит;
				КонецЦикла;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если ЭтоТаблица Или ЗначениеЗаполнено(Таблица) Тогда
		
		Для Каждого ТабличнаяЧасть Из Объект.ТабличныеЧасти Цикл
			
			СтрокиДерева = Дерево.Строки;
			
			Если СтрНачинаетсяС(ТабличнаяЧасть.Имя, "Удалить") Тогда
				Продолжить;
			КонецЕсли;
			
			Если ЭтоТаблица Тогда
				
				НоваяСтрока = СтрокиДерева.Добавить();
				НоваяСтрока.Имя = ТабличнаяЧасть.Имя;
				НоваяСтрока.Путь = ТабличнаяЧасть.Имя;
				НоваяСтрока.Представление = ?(ЗначениеЗаполнено(ТабличнаяЧасть.Синоним),
					ТабличнаяЧасть.Синоним,
					ТабличнаяЧасть.Имя);
				НоваяСтрока.ПредставлениеПути = НоваяСтрока.Представление;
				НоваяСтрока.Тип = НСтр("ru = 'Таблица';
										|en = 'Table'");
				НоваяСтрока.ЭтоТаблица = Истина;
				
			Иначе
				
				НоваяСтрока = СтрокиДерева.Добавить();
				НоваяСтрока.Имя = ТабличнаяЧасть.Имя;
				НоваяСтрока.Путь = ТабличнаяЧасть.Имя;
				НоваяСтрока.Представление = ?(ЗначениеЗаполнено(ТабличнаяЧасть.Синоним),
					ТабличнаяЧасть.Синоним,
					ТабличнаяЧасть.Имя);
				НоваяСтрока.ПредставлениеПути = НоваяСтрока.Представление;
				НоваяСтрока.Тип = НСтр("ru = 'Таблица';
										|en = 'Table'");
				НоваяСтрока.ЭтоТаблица = Истина;
				НоваяСтрока.Недоступно = Истина;
				НоваяСтрока.Выделено = (Таблица = ТабличнаяЧасть.Имя);
				НоваяСтрока.РеквизитыСчитаны = Истина;
				
				СтрокиДерева = НоваяСтрока.Строки;
				
				Для Каждого Реквизит Из ТабличнаяЧасть.Реквизиты Цикл
					
					Если СтрНачинаетсяС(Реквизит.Имя, "Удалить") Тогда
						Продолжить;
					КонецЕсли;
				
					Представление = Реквизит.Представление();
					
					НоваяСтрока = СтрокиДерева.Добавить();
					НоваяСтрока.Имя = Реквизит.Имя;
					НоваяСтрока.Путь = ТабличнаяЧасть.Имя + "." + Реквизит.Имя;
					НоваяСтрока.Представление = Представление;
					НоваяСтрока.ПредставлениеПути = Представление;
					НоваяСтрока.Тип = Реквизит.Тип;
					НоваяСтрока.Таблица = ТабличнаяЧасть.Имя;
					НоваяСтрока.Недоступно = (Таблица <> ТабличнаяЧасть.Имя);
					
				КонецЦикла;
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
	Дерево.Строки.Сортировать("Представление");
	
	ЗначениеВРеквизитФормы(Дерево, "ДеревоРеквизитов");
	
	// Найдем таблицу
	Если ЗначениеЗаполнено(Таблица) Тогда
		Для Каждого ЭлементДерева Из ДеревоРеквизитов.ПолучитьЭлементы() Цикл
			Если ЭлементДерева.ЭтоТаблица
				И ЭлементДерева.Имя = Таблица Тогда
				Элементы.ДеревоРеквизитов.ТекущаяСтрока = ЭлементДерева.ПолучитьИдентификатор();
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	// Найдем ранее выбранный элемент.
	Если ЗначениеЗаполнено(ИмяРеквизитаОбъектаИС) Тогда
		Для Каждого ЭлементДерева Из ДеревоРеквизитов.ПолучитьЭлементы() Цикл
			Если ЭлементДерева.Имя = ИмяРеквизитаОбъектаИС
				И ЭлементДерева.Таблица = Таблица Тогда
				Элементы.ДеревоРеквизитов.ТекущаяСтрока = ЭлементДерева.ПолучитьИдентификатор();
				Возврат;
			КонецЕсли;
			Если ЭлементДерева.ЭтоТаблица Тогда
				Для Каждого ПодчиненныйЭлемент Из ЭлементДерева.ПолучитьЭлементы() Цикл
					Если СтрШаблон("%1.%2", ПодчиненныйЭлемент.Таблица, ПодчиненныйЭлемент.Имя) = ИмяРеквизитаОбъектаИС Тогда
						Элементы.ДеревоРеквизитов.ТекущаяСтрока = ПодчиненныйЭлемент.ПолучитьИдентификатор();
						Возврат;
					КонецЕсли;
				КонецЦикла;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	// Найдем подходящий по представлению.
	Для Каждого ЭлементДерева Из ДеревоРеквизитов.ПолучитьЭлементы() Цикл
		Если ЭлементДерева.Представление = ПредставлениеРеквизитаОбъектаДО
				И ЭлементДерева.Таблица = Таблица Тогда
			Элементы.ДеревоРеквизитов.ТекущаяСтрока = ЭлементДерева.ПолучитьИдентификатор();
			Возврат;
		КонецЕсли;
		Если ЭлементДерева.ЭтоТаблица Тогда
			Для Каждого ПодчиненныйЭлемент Из ЭлементДерева.ПолучитьЭлементы() Цикл
				Если ПодчиненныйЭлемент.Представление = ПредставлениеРеквизитаОбъектаДО
						И ПодчиненныйЭлемент.Таблица = Таблица Тогда
					Элементы.ДеревоРеквизитов.ТекущаяСтрока = ПодчиненныйЭлемент.ПолучитьИдентификатор();
					Возврат;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПодчиненныеРеквизиты(Строка, ИмяМетаданных)
	
	ДанныеСтроки = ДеревоРеквизитов.НайтиПоИдентификатору(Строка);
	Объект = Метаданные.НайтиПоПолномуИмени(ИмяМетаданных);
	
	Если Объект = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЭлементыДерева = ДанныеСтроки.ПолучитьЭлементы();
	ЭлементыДерева.Очистить();
	
	Для Каждого Реквизит Из Объект.СтандартныеРеквизиты Цикл
		
		Если Реквизит.Имя = "Проведен" Или Реквизит.Имя = "ПометкаУдаления" Или Реквизит.Имя = "Ссылка" Тогда
			Продолжить;
		КонецЕсли;
		
		Представление = Реквизит.Представление();
		
		НоваяСтрока = ЭлементыДерева.Добавить();
		НоваяСтрока.Имя = Реквизит.Имя;
		НоваяСтрока.Путь = ДанныеСтроки.Путь + "." + Реквизит.Имя;
		НоваяСтрока.Представление = Представление;
		НоваяСтрока.ПредставлениеПути = ДанныеСтроки.ПредставлениеПути + "." + Представление;
		НоваяСтрока.Тип = Реквизит.Тип;
		
		Типы = Реквизит.Тип.Типы();
		Если Типы.Количество() > 1 Тогда
			Продолжить;
		КонецЕсли;
		
		ОбъектРеквизит = Метаданные.НайтиПоТипу(Типы[0]);
		Если ОбъектРеквизит = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		НоваяСтрока.ИмяМетаданных = ОбъектРеквизит.ПолноеИмя();
		
		Если Метаданные.Справочники.Содержит(ОбъектРеквизит)
				Или Метаданные.Документы.Содержит(ОбъектРеквизит)
				Или Метаданные.БизнесПроцессы.Содержит(ОбъектРеквизит)
				Или Метаданные.Задачи.Содержит(ОбъектРеквизит)
				Или Метаданные.ПланыВидовХарактеристик.Содержит(ОбъектРеквизит)
				Или Метаданные.ПланыСчетов.Содержит(ОбъектРеквизит) Тогда
			
			НоваяСтрока.ЕстьРеквизиты = Истина;
			НоваяСтрока.ПолучитьЭлементы().Добавить();
			
		КонецЕсли;
		
	КонецЦикла;
	
	НоваяСтрока = ЭлементыДерева.Добавить();
	НоваяСтрока.Имя = "Представление";
	НоваяСтрока.Путь = ДанныеСтроки.Путь + "." + "Представление";
	НоваяСтрока.Представление = НСтр("ru = 'Представление';
									|en = 'Presentation'");
	НоваяСтрока.ПредставлениеПути = ДанныеСтроки.ПредставлениеПути + "." + НСтр("ru = 'Представление';
																				|en = 'Presentation'");
	НоваяСтрока.Тип = "Строка";
	
	Для Каждого Реквизит Из Объект.Реквизиты Цикл
		
		Если СтрНачинаетсяС(Реквизит.Имя, "Удалить") Тогда
			Продолжить;
		КонецЕсли;
	
		Представление = Реквизит.Представление();
		
		НоваяСтрока = ЭлементыДерева.Добавить();
		НоваяСтрока.Имя = Реквизит.Имя;
		НоваяСтрока.Путь = ДанныеСтроки.Путь + "." + Реквизит.Имя;
		НоваяСтрока.Представление =  Представление;
		НоваяСтрока.ПредставлениеПути =  ДанныеСтроки.ПредставлениеПути + "." + Представление;
		НоваяСтрока.Тип = Реквизит.Тип;
		
		Типы = Реквизит.Тип.Типы();
		Если Типы.Количество() > 1 Тогда
			Продолжить;
		КонецЕсли;
			
		ОбъектРеквизит = Метаданные.НайтиПоТипу(Типы[0]);
		Если ОбъектРеквизит = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		НоваяСтрока.ИмяМетаданных = ОбъектРеквизит.ПолноеИмя();
		
		Если Метаданные.Справочники.Содержит(ОбъектРеквизит)
				Или Метаданные.Документы.Содержит(ОбъектРеквизит)
				Или Метаданные.БизнесПроцессы.Содержит(ОбъектРеквизит)
				Или Метаданные.Задачи.Содержит(ОбъектРеквизит)
				Или Метаданные.ПланыВидовХарактеристик.Содержит(ОбъектРеквизит)
				Или Метаданные.ПланыСчетов.Содержит(ОбъектРеквизит) Тогда
			НоваяСтрока.ЕстьРеквизиты = Истина;
			НоваяСтрока.ПолучитьЭлементы().Добавить();
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры
	
#КонецОбласти