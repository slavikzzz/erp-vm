///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПодключитьОбработчикОжидания("ЗаполнитьПользователейОС", 0.1, Истина);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТаблицаДоменов

&НаКлиенте
Процедура ТаблицаДоменовПриАктивизацииСтроки(Элемент)
	
	СписокПользователейТекущегоДомена.Очистить();
	
	Если Элемент.ТекущиеДанные <> Неопределено Тогда
		ИмяДомена = Элемент.ТекущиеДанные.ИмяДомена;
		
		Для Каждого Запись Из ТаблицаДоменовИПользователей Цикл
			Если Запись.ИмяДомена = ИмяДомена Тогда
				
				Для Каждого Пользователь Из Запись.Пользователи Цикл
					ПользовательДомена = СписокПользователейТекущегоДомена.Добавить();
					ПользовательДомена.ИмяПользователя = Пользователь;
				КонецЦикла;
				Прервать;
				
			КонецЕсли;
		КонецЦикла;
		
		СписокПользователейТекущегоДомена.Сортировать("ИмяПользователя");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТаблицаПользователей

&НаКлиенте
Процедура ТаблицаПользователейДоменаВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СкомпоноватьРезультатИЗакрытьФорму();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выбрать(Команда)
	
	Если Элементы.ТаблицаДоменов.ТекущиеДанные = Неопределено Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Выберите домен.';
										|en = 'Select a domain.'"));
		Возврат;
	КонецЕсли;
	
	Если Элементы.ТаблицаПользователейДомена.ТекущиеДанные = Неопределено Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Выберите пользователя домена.';
										|en = 'Select a domain user.'"));
		Возврат;
	КонецЕсли;
	
	СкомпоноватьРезультатИЗакрытьФорму();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ЗаполнитьПользователейОС()
	
#Если ТолстыйКлиентОбычноеПриложение ИЛИ ТолстыйКлиентУправляемоеПриложение Тогда
	ТаблицаДоменовИПользователей = ПользователиОС();
#ИначеЕсли ТонкийКлиент Тогда
	ТаблицаДоменовИПользователей = Новый ФиксированныйМассив (ПользователиОС());
#КонецЕсли
	
	СписокДоменов.Очистить();
	
	Для Каждого Запись Из ТаблицаДоменовИПользователей Цикл
		Домен = СписокДоменов.Добавить();
		Домен.ИмяДомена = Запись.ИмяДомена;
	КонецЦикла;
	
	СписокДоменов.Сортировать("ИмяДомена");
	
	Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаВыбор;
	
КонецПроцедуры

&НаКлиенте
Процедура СкомпоноватьРезультатИЗакрытьФорму()
	
	ИмяДомена = Элементы.ТаблицаДоменов.ТекущиеДанные.ИмяДомена;
	ИмяПользователя = Элементы.ТаблицаПользователейДомена.ТекущиеДанные.ИмяПользователя;
	
	РезультатВыбора = "\\" + ИмяДомена + "\" + ИмяПользователя;
	ОповеститьОВыборе(РезультатВыбора);
	
КонецПроцедуры

#КонецОбласти
