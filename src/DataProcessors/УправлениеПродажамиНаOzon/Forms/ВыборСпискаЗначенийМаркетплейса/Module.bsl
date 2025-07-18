
#Область ОписаниеПеременных

&НаКлиенте
Перем ПерезаполнитьЗначениеСписка;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Параметры.Свойство("УчетнаяЗаписьМаркетплейса", УчетнаяЗаписьМаркетплейса);
	Параметры.Свойство("ИдентификаторКатегорииМаркетплейса", ИдентификаторКатегорииМаркетплейса);
	Параметры.Свойство("ИдентификаторАтрибутаМаркетплейса", ИдентификаторАтрибутаМаркетплейса);
	Параметры.Свойство("НаименованиеАтрибутаМаркетплейса", НаименованиеАтрибутаМаркетплейса);
	Параметры.Свойство("ТекущееЗначениеАтрибута", СписокЗначений);
	Параметры.Свойство("Описание", Описание);
	Параметры.Свойство("АдресХранилищаДоступныхЗначений", АдресХранилищаДоступныхЗначений);

	Элементы.ДекорацияОписание.Заголовок = Описание;

	ШаблонЗаголовка = НСтр("ru = 'Выбор значений для атрибута <%1>';
							|en = 'Select values for the <%1> product option'");
	Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонЗаголовка, НаименованиеАтрибутаМаркетплейса);

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)

	Если ВыбранноеЗначение = Неопределено Тогда
		Возврат;
	КонецЕсли;

	Если ПерезаполнитьЗначениеСписка Тогда
		ТекущиеДанные = Элементы.СписокЗначений.ТекущиеДанные;
		ЗначениеСписка = СписокЗначений.НайтиПоЗначению(ТекущиеДанные.Значение);
		Индекс = СписокЗначений.Индекс(ЗначениеСписка);
		СписокЗначений.Вставить(Индекс, ВыбранноеЗначение.ИдентификаторЗначенияАтрибута, ВыбранноеЗначение.ЗначениеАтрибута);
		СписокЗначений.Удалить(ЗначениеСписка);

		ЗначениеСписка = СписокЗначений.НайтиПоЗначению(ВыбранноеЗначение.ИдентификаторЗначенияАтрибута);
		Элементы.СписокЗначений.ТекущаяСтрока = ЗначениеСписка.ПолучитьИдентификатор();
	Иначе
		Если СписокЗначений.НайтиПоЗначению(ВыбранноеЗначение.ИдентификаторЗначенияАтрибута) = Неопределено Тогда
			СписокЗначений.Добавить(ВыбранноеЗначение.ИдентификаторЗначенияАтрибута, ВыбранноеЗначение.ЗначениеАтрибута);
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписокЗначений 

&НаКлиенте
Процедура СписокЗначенийВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)

	ОткрытьФормуВыбораЗначенияАтрибута(Истина, Истина);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Добавить(Команда)

	ОткрытьФормуВыбораЗначенияАтрибута();

КонецПроцедуры

&НаКлиенте
Процедура Подбор(Команда)

	ОткрытьФормуВыбораЗначенияАтрибута(Ложь);

КонецПроцедуры

&НаКлиенте
Процедура СохранитьЗначения(Команда)

	МассивЗначенийУдаления = Новый Массив;
	
	Для Каждого ЗначениеСписка Из СписокЗначений Цикл
		Если Не ЗначениеЗаполнено(ЗначениеСписка.Значение) Тогда
			МассивЗначенийУдаления.Добавить(ЗначениеСписка);
		КонецЕсли;
	КонецЦикла;

	Для Каждого ЭлементУдаления Из МассивЗначенийУдаления Цикл
		СписокЗначений.Удалить(ЭлементУдаления);
	КонецЦикла;

	Результат = Новый Структура;
	Результат.Вставить("АдресХранилищаДоступныхЗначений", АдресХранилищаДоступныхЗначений);
	Результат.Вставить("ЗначенияАтрибута", СписокЗначений);

	Закрыть(Результат);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОткрытьФормуВыбораЗначенияАтрибута(ЗакрыватьПриВыборе = Истина, ЗаполнитьТекущееЗначение = Ложь)

	ПараметрыВыбора = Новый Структура;
	ПараметрыВыбора.Вставить("УчетнаяЗаписьМаркетплейса", УчетнаяЗаписьМаркетплейса);
	ПараметрыВыбора.Вставить("ИдентификаторКатегорииМаркетплейса", ИдентификаторКатегорииМаркетплейса);
	ПараметрыВыбора.Вставить("ИдентификаторАтрибутаМаркетплейса", ИдентификаторАтрибутаМаркетплейса);
	ПараметрыВыбора.Вставить("НаименованиеАтрибутаМаркетплейса", НаименованиеАтрибутаМаркетплейса);
	ПараметрыВыбора.Вставить("Описание", Описание);
	ПараметрыВыбора.Вставить("ЗакрыватьПриВыборе", ЗакрыватьПриВыборе);

	ПерезаполнитьЗначениеСписка = ЗаполнитьТекущееЗначение;

	Если ЗаполнитьТекущееЗначение Тогда
		ТекущиеДанные = Элементы.СписокЗначений.ТекущиеДанные;
		ПараметрыВыбора.Вставить("ТекущееЗначениеАтрибута", ТекущиеДанные.Представление);
		ПараметрыВыбора.Вставить("ИдентификаторТекущегоЗначенияАтрибута", ТекущиеДанные.Значение);
	КонецЕсли;

	Если ЗначениеЗаполнено(АдресХранилищаДоступныхЗначений) Тогда
		ПараметрыВыбора.Вставить("АдресХранилищаДоступныхЗначений", АдресХранилищаДоступныхЗначений);
	КонецЕсли;

	Если ЗакрыватьПриВыборе Тогда
		ОбработчикВыбораЗначения = Новый ОписаниеОповещения("ВыборЗначенияЗавершение", ЭтотОбъект);
	Иначе
		ОбработчикВыбораЗначения = Неопределено;
	КонецЕсли;

	ОткрытьФорму("Обработка.УправлениеПродажамиНаOzon.Форма.ВыборЗначенияМаркетплейса",
			ПараметрыВыбора, ЭтотОбъект,,,, ОбработчикВыбораЗначения); 

КонецПроцедуры

&НаКлиенте
Процедура ВыборЗначенияЗавершение(ВыбранноеЗначение, ДополнительныеПараметры) Экспорт

	ОбработкаВыбора(ВыбранноеЗначение, Неопределено);

КонецПроцедуры

#КонецОбласти
