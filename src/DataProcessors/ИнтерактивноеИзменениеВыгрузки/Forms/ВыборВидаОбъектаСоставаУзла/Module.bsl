///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2025, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.УзелИнформационнойБазы = Неопределено Тогда
		
		ВызватьИсключение НСтр("ru = 'Эта форма не предназначена для непосредственного открытия.';
								|en = 'This form is not intended for direct opening.'", ОбщегоНазначения.КодОсновногоЯзыка());
		
	КонецЕсли;
	
	ЗакрыватьПриЗакрытииВладельца = Истина;
	ЗакрыватьПриВыборе = Ложь;
	
	Объект.УзелИнформационнойБазы = Параметры.УзелИнформационнойБазы;
	
	ДеревоВыбора = РеквизитФормыВЗначение("ДоступныеВидыОбъектов");
	СтрокиДереваВыбора = ДеревоВыбора.Строки;
	СтрокиДереваВыбора.Очистить();
	
	ВсеДанные = ОбменДаннымиПовтИсп.СоставПланаОбмена(Объект.УзелИнформационнойБазы.Метаданные().Имя);

	// Объекты, для которых указано "НеВыгружать", скрываем.
	РежимНеВыгружать = Перечисления.РежимыВыгрузкиОбъектовОбмена.НеВыгружать;
	РежимыВыгрузки   = ОбменДаннымиПовтИсп.ПользовательскийСоставПланаОбмена(Объект.УзелИнформационнойБазы);
	Позиция = ВсеДанные.Количество() - 1;
	Пока Позиция >= 0 Цикл
		СтрокаДанных = ВсеДанные[Позиция];
		Если РежимыВыгрузки[СтрокаДанных.ПолноеИмяМетаданных] = РежимНеВыгружать Тогда
			ВсеДанные.Удалить(Позиция);
		КонецЕсли;
		Позиция = Позиция - 1;
	КонецЦикла;
	
	// Убираем типовую картинку метаданных для листьев.
	ВсеДанные.ЗаполнитьЗначения(-1, "ИндексКартинки");
	
	ДобавитьВсеОбъекты(ВсеДанные, СтрокиДереваВыбора);
	
	ЗначениеВРеквизитФормы(ДеревоВыбора, "ДоступныеВидыОбъектов");
	
	ВыбираемыеКолонки = "";
	Для Каждого Реквизит Из ПолучитьРеквизиты("ДоступныеВидыОбъектов") Цикл
		ВыбираемыеКолонки = ВыбираемыеКолонки + "," + Реквизит.Имя;
	КонецЦикла;
	ВыбираемыеКолонки = Сред(ВыбираемыеКолонки, 2);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДоступныеВидыОбъектов

&НаКлиенте
Процедура ДоступныеВидыОбъектовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ВыполнитьВыбор(ВыбраннаяСтрока);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПодобратьИЗакрыть(Команда)
	ВыполнитьВыбор();
	Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура Подобрать(Команда)
	ВыполнитьВыбор();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ЭтотОбъект(НовыйОбъект = Неопределено)
	Если НовыйОбъект=Неопределено Тогда
		Возврат РеквизитФормыВЗначение("Объект");
	КонецЕсли;
	ЗначениеВРеквизитФормы(НовыйОбъект, "Объект");
	Возврат Неопределено;
КонецФункции

&НаКлиенте
Процедура ВыполнитьВыбор(ВыбраннаяСтрока = Неопределено)
	
	ТаблицаФормы = Элементы.ДоступныеВидыОбъектов;
	ДанныеВыбора = Новый Массив;
	
	Если ВыбраннаяСтрока = Неопределено Тогда
		Для Каждого Строка Из ТаблицаФормы.ВыделенныеСтроки Цикл
			ЭлементВыбора = Новый Структура(ВыбираемыеКолонки);
			ЗаполнитьЗначенияСвойств(ЭлементВыбора, ТаблицаФормы.ДанныеСтроки(Строка) );
			ДанныеВыбора.Добавить(ЭлементВыбора);
		КонецЦикла;
		
	ИначеЕсли ТипЗнч(ВыбраннаяСтрока) = Тип("Массив") Тогда
		Для Каждого Строка Из ВыбраннаяСтрока Цикл
			ЭлементВыбора = Новый Структура(ВыбираемыеКолонки);
			ЗаполнитьЗначенияСвойств(ЭлементВыбора, ТаблицаФормы.ДанныеСтроки(Строка) );
			ДанныеВыбора.Добавить(ЭлементВыбора);
		КонецЦикла;
		
	Иначе
		ЭлементВыбора = Новый Структура(ВыбираемыеКолонки);
		ЗаполнитьЗначенияСвойств(ЭлементВыбора, ТаблицаФормы.ДанныеСтроки(ВыбраннаяСтрока) );
		ДанныеВыбора.Добавить(ЭлементВыбора);
	КонецЕсли;
	
	ОповеститьОВыборе(ДанныеВыбора);
КонецПроцедуры

&НаСервере
Процедура ДобавитьВсеОбъекты(ВсеСсылочныеДанныеУзла, СтрокиПриемника)
	
	ЭтаОбработка = ЭтотОбъект();
	
	ГруппаДокументы = СтрокиПриемника.Добавить();
	ГруппаДокументы.ПредставлениеСписка = ЭтаОбработка.ЗаголовокГруппыОтбораВсехДокументов();
	ГруппаДокументы.ПолноеИмяМетаданных = ЭтаОбработка.ИдентификаторВсехДокументов();
	ГруппаДокументы.ИндексКартинки = 7;
	
	ГруппаСправочники = СтрокиПриемника.Добавить();
	ГруппаСправочники.ПредставлениеСписка = ЭтаОбработка.ЗаголовокГруппыОтбораВсехСправочников();
	ГруппаСправочники.ПолноеИмяМетаданных = ЭтаОбработка.ИдентификаторВсехСправочников();
	ГруппаСправочники.ИндексКартинки = 3;
	
	Для Каждого Строка Из ВсеСсылочныеДанныеУзла Цикл
		Если Строка.ВыборПериода Тогда
			ЗаполнитьЗначенияСвойств(ГруппаДокументы.Строки.Добавить(), Строка);
		Иначе
			ЗаполнитьЗначенияСвойств(ГруппаСправочники.Строки.Добавить(), Строка);
		КонецЕсли;
	КонецЦикла;
	
	// Пустое удаляем
	Если ГруппаДокументы.Строки.Количество() = 0 Тогда
		СтрокиПриемника.Удалить(ГруппаДокументы);
	КонецЕсли;
	Если ГруппаСправочники.Строки.Количество() = 0 Тогда
		СтрокиПриемника.Удалить(ГруппаСправочники);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
