
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Параметры.Свойство("ВедущийОбъект", ОбъектВладелец);
	Если Не ЗначениеЗаполнено(ОбъектВладелец) Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	// Если объект еще не заблокирован для изменений и есть права на изменение набора
	// попытаемся установить блокировку.
	Если НЕ Пользователи.РолиДоступны("НастройкаНалогиИВзносы") Тогда
		
		ТолькоПросмотр = Истина;
		
	КонецЕсли;
	
	Если ТолькоПросмотр Тогда
		
		Элементы.НаборЗаписей.ТолькоПросмотр = Истина;
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы, 
			"ФормаКомандаОК",
			"Доступность",
			Ложь);
			
		Элементы.ФормаКомандаОтмена.КнопкаПоУмолчанию = Истина;
		
	КонецЕсли;
	
	Для Каждого ЗаписьНабора Из Параметры.МассивЗаписей Цикл
		ЗаполнитьЗначенияСвойств(НаборЗаписей.Добавить(), ЗаписьНабора);
	КонецЦикла;
	
	НаборЗаписей.Сортировать("Период");
	
	Для Каждого СтрокаТабличнойЧасти Из НаборЗаписей Цикл
		СтрокаТабличнойЧасти.ПериодСтрокой = ПредставлениеПериода(СтрокаТабличнойЧасти.Период, КонецКвартала(СтрокаТабличнойЧасти.Период), "ФП = Истина");
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыНаборЗаписей

&НаКлиенте
Процедура НаборЗаписейПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	Запись = Элемент.ТекущиеДанные;
	Если Запись = Неопределено Тогда
		Возврат;
	КонецЕсли;
	Если НоваяСтрока Тогда
		ПоследняяЗапись = ?(НаборЗаписей.Количество() > 1, НаборЗаписей[НаборЗаписей.Количество() - 2], Неопределено);
		Если ПоследняяЗапись <> Неопределено Тогда
			ЗаполнитьЗначенияСвойств(Запись, ПоследняяЗапись);
		КонецЕсли;
		Если ЗначениеЗаполнено(ОбъектВладелец) Тогда
			Запись.Организация = ОбъектВладелец;
		КонецЕсли;
		ТекущаяДата = ТекущаяДата(); // АПК:143 Время не важно.
		Если Год(Запись.Период) < Год(ТекущаяДата) Тогда
			Запись.Период = НачалоГода(ТекущаяДата);
		Иначе
			Запись.Период = НачалоКвартала(ДобавитьМесяц(Запись.Период, 3));
		КонецЕсли;
		Запись.ПериодСтрокой = ЗарплатаКадрыКлиентСервер.ПолучитьПредставлениеКвартала(Запись.Период);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура НаборЗаписейПередОкончаниемРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования, Отказ)
	Если НЕ ОтменаРедактирования Тогда
		Если Элемент.ТекущиеДанные <> Неопределено Тогда
			Если НЕ ЗначениеЗаполнено(Элемент.ТекущиеДанные.Период) Тогда
				СообщениеОбОшибке = НСтр("ru = 'Необходимо указать дату сведений';
										|en = 'Enter information date'");
				ОбщегоНазначенияКлиент.СообщитьПользователю(СообщениеОбОшибке,,"НаборЗаписей.Период", , Отказ);
			Иначе
				НайденныеСтроки = НаборЗаписей.НайтиСтроки(Новый Структура("Период", Элемент.ТекущиеДанные.Период));
				Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл
					Если НайденнаяСтрока.Период <> НачалоКвартала(НайденнаяСтрока.Период) Тогда
						НайденнаяСтрока.Период = НачалоКвартала(НайденнаяСтрока.Период);
						Элемент.ТекущиеДанные.ПериодСтрокой = ПредставлениеПериода(Элемент.ТекущиеДанные.Период, КонецКвартала(Элемент.ТекущиеДанные.Период), "ФП = Истина");
					КонецЕсли;
					Если НайденнаяСтрока <> Элемент.ТекущиеДанные Тогда
						СообщениеОбОшибке = НСтр("ru = 'Уже есть запись с указанной датой сведений';
												|en = 'The record with the specified information date already exists'");
						ОбщегоНазначенияКлиент.СообщитьПользователю(СообщениеОбОшибке,,"НаборЗаписей.Период", , Отказ);
						Прервать;
					КонецЕсли; 
				КонецЦикла;
			КонецЕсли; 
		КонецЕсли; 
	КонецЕсли; 
КонецПроцедуры

&НаКлиенте
Процедура НаборЗаписейПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	Если ОтменаРедактирования Тогда
		Возврат;
	КонецЕсли;
	
	РедактированиеПериодическихСведенийКлиент.УпорядочитьНаборЗаписейВФорме(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура НаборЗаписейПослеУдаления(Элемент)
	
	Если НаборЗаписей.Количество() = 0 Тогда
		ДобавитьЗаписьПоУмолчанию();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НаборЗаписейПериодСтрокойПриИзменении(Элемент)
	
	ЗарплатаКадрыКлиент.ВводМесяцаПриИзменении(Элементы.НаборЗаписей.ТекущиеДанные, "Период", "ПериодСтрокой", Модифицированность);
	
	Если Элементы.НаборЗаписей.ТекущиеДанные.Период <> НачалоКвартала(Элементы.НаборЗаписей.ТекущиеДанные.Период) Тогда
		Элементы.НаборЗаписей.ТекущиеДанные.Период = НачалоКвартала(Элементы.НаборЗаписей.ТекущиеДанные.Период);
		Элементы.НаборЗаписей.ТекущиеДанные.ПериодСтрокой = ПредставлениеПериода(
			Элементы.НаборЗаписей.ТекущиеДанные.Период,
			КонецКвартала(Элементы.НаборЗаписей.ТекущиеДанные.Период),
			"ФП = Истина");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НаборЗаписейПериодСтрокойНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПутьРеквизита = "Период";
	ПутьРеквизитаПредставления = "ПериодСтрокой";
	
	Значение = ОбщегоНазначенияКлиентСервер.ПолучитьРеквизитФормыПоПути(Элементы.НаборЗаписей.ТекущиеДанные, ПутьРеквизита);
	
	Оповещение = Новый ОписаниеОповещения("НаборЗаписейПериодСтрокойНачалоВыбораЗавершение", ЭтотОбъект);
	
	ОткрытьФорму("ОбщаяФорма.ВыборПериода",
		Новый Структура("Значение,РежимВыбораПериода,ЗапрашиватьРежимВыбораПериодаУВладельца", Значение, "Квартал", Ложь),
		ЭтаФорма, , , , Оповещение, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура НаборЗаписейПериодСтрокойНачалоВыбораЗавершение(ВыбранноеЗначение, ДополнительныеПараметры) Экспорт 
	
	Если ВыбранноеЗначение = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПутьРеквизита = "Период";
	ПутьРеквизитаПредставления = "ПериодСтрокой";
	
	ВыбранноеЗначение = НачалоКвартала(ВыбранноеЗначение);
	Значение = ВыбранноеЗначение;
	
	ОбщегоНазначенияКлиентСервер.УстановитьРеквизитФормыПоПути(Элементы.НаборЗаписей.ТекущиеДанные, ПутьРеквизита, Значение);
	Представление = ПредставлениеПериода(Значение, КонецКвартала(Значение), "ФП = Истина");
	ОбщегоНазначенияКлиентСервер.УстановитьРеквизитФормыПоПути(Элементы.НаборЗаписей.ТекущиеДанные, ПутьРеквизитаПредставления, Представление);
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура НаборЗаписейПериодСтрокойРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ВводМесяцаРегулирование(Элементы.НаборЗаписей.ТекущиеДанные, "Период", "ПериодСтрокой", Направление * 3, Модифицированность);
	Элементы.НаборЗаписей.ТекущиеДанные.ПериодСтрокой = ПредставлениеПериода(Элементы.НаборЗаписей.ТекущиеДанные.Период, КонецКвартала(Элементы.НаборЗаписей.ТекущиеДанные.Период), "ФП = Истина");
	
КонецПроцедуры

&НаКлиенте
Процедура НаборЗаписейПериодСтрокойАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ВводМесяцаАвтоПодборТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура НаборЗаписейПериодСтрокойОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ВводМесяцаОкончаниеВводаТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОК(Команда)
	РедактированиеПериодическихСведенийКлиент.ОповеститьОЗавершении(ЭтаФорма, "ИсторияРегистрацийВОрганеПФР", ОбъектВладелец);
КонецПроцедуры

&НаКлиенте
Процедура КомандаОтмена(Команда)
	Закрыть();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ДобавитьЗаписьПоУмолчанию()
	
	Запись = НаборЗаписей.Добавить();
	ЗаполнитьЗначенияСвойств(Запись, РегистрыСведений.ИсторияРегистрацийВОрганеПФР.СоздатьМенеджерЗаписи());
	Запись.Организация = ОбъектВладелец;
	
КонецПроцедуры

#КонецОбласти
