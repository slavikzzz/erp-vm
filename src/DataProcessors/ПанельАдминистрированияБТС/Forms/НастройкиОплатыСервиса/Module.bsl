#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	//@skip-warning
	ПарольПользователяУчетнойСистемы = ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища(
		ОплатаСервиса.ВладелецПароляАвторизацииВУчетнойСистеме());
		
	Элементы.ГруппаЗагрузкаТарифов.Видимость = ОплатаСервиса.ПоддерживаетсяЗагрузкаТарифов();
		
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИмяПользователяУчетнойСистемыПриИзменении(Элемент)
	
	ПриИзмененииРеквизита(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ПарольПользователяУчетнойСистеимыПриИзменении(Элемент)
	
	ПарольПользователяУчетнойСистеимыПриИзмененииНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗагрузитьТарифыСервиса(Команда)
	
	Если Не ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли; 
	
	ДлительнаяОперация = НачатьЗагрузкуТарифовСервиса();
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	Оповещение = Новый ОписаниеОповещения("ПриЗавершенииЗагрузкиТарифов", ЭтотОбъект);
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, Оповещение, ПараметрыОжидания);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция НачатьЗагрузкуТарифовСервиса()
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияПроцедуры();
	Возврат ДлительныеОперации.ВыполнитьПроцедуру(ПараметрыВыполнения, "ОплатаСервиса.ЗагрузитьТарифыСервиса");
	
КонецФункции

&НаКлиенте
Процедура ПриЗавершенииЗагрузкиТарифов(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда // Пользователь отменил задание.
		Возврат;
	КонецЕсли;
	
	Если Результат.Статус = "Ошибка" Тогда
		ВызватьИсключение Результат.КраткоеПредставлениеОшибки;
	КонецЕсли;
	
	ПоказатьОповещениеПользователя(НСтр("ru = 'Загрузка выполнена';
										|en = 'Import completed'"), , 
		НСтр("ru = 'Загрузка тарифов сервиса выполнена.';
			|en = 'Service plans are imported.'"), БиблиотекаКартинок.Информация32);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииРеквизита(Элемент)
	
	ИменаКонстант = ПриИзмененииРеквизитаСервер(Элемент.Имя);
	ОбновитьПовторноИспользуемыеЗначения();
	
	Для Каждого ИмяКонстанты Из ИменаКонстант Цикл
		Если ИмяКонстанты <> "" Тогда
			Оповестить("Запись_НаборКонстант", Новый Структура, ИмяКонстанты);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ПриИзмененииРеквизитаСервер(ИмяЭлемента)
	
	ИменаКонстант = Новый Массив;
	РеквизитПутьКДанным = Элементы[ИмяЭлемента].ПутьКДанным;
	
	НачатьТранзакцию();
	Попытка
		
		ИмяКонстанты = СохранитьЗначениеРеквизита(РеквизитПутьКДанным);
		ИменаКонстант.Добавить(ИмяКонстанты);
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
	ОбновитьПовторноИспользуемыеЗначения();
	Возврат ИменаКонстант;
	
КонецФункции

&НаСервере
Функция СохранитьЗначениеРеквизита(РеквизитПутьКДанным)
	
	ЧастиИмени = СтрРазделить(РеквизитПутьКДанным, ".");
	Если ЧастиИмени.Количество() <> 2 Тогда
		Возврат "";
	КонецЕсли;
	
	ИмяКонстанты = ЧастиИмени[1];
	КонстантаМенеджер = Константы[ИмяКонстанты];
	КонстантаЗначение = НаборКонстант[ИмяКонстанты];
	ТекущееЗначение  = КонстантаМенеджер.Получить();
	Если ТекущееЗначение <> КонстантаЗначение Тогда
		Попытка
			КонстантаМенеджер.Установить(КонстантаЗначение);
		Исключение
			НаборКонстант[ИмяКонстанты] = ТекущееЗначение;
			ВызватьИсключение;
		КонецПопытки;
	КонецЕсли;
	
	Возврат ИмяКонстанты;
	
КонецФункции

&НаСервере
Процедура ПарольПользователяУчетнойСистеимыПриИзмененииНаСервере()
	
	ОбщегоНазначения.ЗаписатьДанныеВБезопасноеХранилище(
		ОплатаСервиса.ВладелецПароляАвторизацииВУчетнойСистеме(), ПарольПользователяУчетнойСистемы);
	
КонецПроцедуры

#КонецОбласти
