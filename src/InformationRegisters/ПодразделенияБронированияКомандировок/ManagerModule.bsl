#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

Процедура ЗарегистрироватьИзмененияПодразделений(СистемаБронирования, СписокПодразделений) Экспорт

	Если СистемаБронирования = Неопределено Тогда
		Возврат;
	КонецЕсли;

	БлокировкаДанных = Новый БлокировкаДанных;
	ЭлементБлокировкиДанных = БлокировкаДанных.Добавить("РегистрСведений.ПодразделенияБронированияКомандировок");
	ЭлементБлокировкиДанных.Режим = РежимБлокировкиДанных.Исключительный;
	
	НачатьТранзакцию();
	Попытка
		БлокировкаДанных.Заблокировать();

		НаборЗаписей = РегистрыСведений.ПодразделенияБронированияКомандировок.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.СистемаБронирования.Установить(СистемаБронирования);
		НаборЗаписей.Прочитать();
		НаборЗаписей.Очистить();
		НаборЗаписей.Записать();
		Если СписокПодразделений.Количество() > 0 Тогда
			Для Каждого Подразделение Из СписокПодразделений Цикл
				Запись = НаборЗаписей.Добавить();
				Запись.СистемаБронирования = СистемаБронирования;
				Запись.Подразделение = Подразделение.Значение;
				Запись.ВключатьПодчиненныеПодразделения = Подразделение.Пометка;
			КонецЦикла;
			НаборЗаписей.Записать();
		КонецЕсли;
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Сохранение подразделений';
										|en = 'Save business units'", ОбщегоНазначения.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка,,, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ВызватьИсключение;
	КонецПопытки;

КонецПроцедуры

#КонецОбласти

#КонецЕсли