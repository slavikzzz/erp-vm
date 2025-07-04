#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// Процедура создает запись в регистре по переданным данным
//
// Параметры:
//    БанковскийСчет - СправочникСсылка - ссылка на элемент справочника "Банковские счета организаций"
//    ПараметрыЗаписи - Структура - Данные для записи в регистр.
//
Процедура СоздатьЗапись(БанковскийСчет, ПараметрыЗаписи) Экспорт
	
	Если БанковскийСчет = Неопределено Или БанковскийСчет = Справочники.БанковскиеСчетаОрганизаций.ПустаяСсылка() Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	НоваяЗапись = СоздатьМенеджерЗаписи();
	НоваяЗапись.БанковскийСчет = БанковскийСчет;
	НоваяЗапись.Прочитать();
	ЗаполнитьЗначенияСвойств(НоваяЗапись, ПараметрыЗаписи);
	НоваяЗапись.БанковскийСчет = БанковскийСчет;
	
	Попытка
		НоваяЗапись.Записать();
	Исключение
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Запись в регистр сведений ""Последний обмен с банками""';
										|en = 'Write to the ""Last EDI with banks"" information register'",
			ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка,,,
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли