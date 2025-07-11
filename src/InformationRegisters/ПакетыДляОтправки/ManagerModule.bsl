///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьКрайнийПакет()
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	ISNULL(МАКСИМУМ(ПакетыДляОтправки.НомерПакета), 0) КАК КрайнийПакета
	|ИЗ
	|	РегистрСведений.ПакетыДляОтправки КАК ПакетыДляОтправки
	|";
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	Выборка.Следующий();
	
	Возврат Выборка.КрайнийПакета;	
КонецФункции

Процедура ЗаписатьНовыйПакет(ДатаЗаписи, JSONСтруктура, СледующийНомерПакета) Экспорт
	JSONСтруктура.Вставить("pn", Формат(СледующийНомерПакета, "ЧН=0; ЧГ=0"));
	JSONСтруктура.Вставить("application", Строка(Метаданные.Имя));
	JSONСтруктура.Вставить("applicationVersion", Строка(Метаданные.Версия));
	
	ТелоПакета = ЦентрМониторингаСлужебный.СтруктураJSONВСтроку(JSONСтруктура);
	ХешMD5 = Новый ХешированиеДанных(ХешФункция.MD5);
	ХешMD5.Добавить(ТелоПакета + "hashSalt");
	ХешПакета = ХешMD5.ХешСумма;
	ХешПакета = СтрЗаменить(Строка(ХешПакета), " ", "");
	
	НаборЗаписей = СоздатьНаборЗаписей();
	НовЗапись = НаборЗаписей.Добавить();
	НовЗапись.Период = ДатаЗаписи;
	НовЗапись.НомерПакета = СледующийНомерПакета;
	НовЗапись.ТелоПакета = ТелоПакета;
	НовЗапись.ХешПакета = ХешПакета;
	
	НаборЗаписей.ОбменДанными.Загрузка = Истина;
	НаборЗаписей.Записать(Ложь);
КонецПроцедуры

Процедура УдалитьСтарыеПакеты() Экспорт
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	КОЛИЧЕСТВО(*) КАК ВсегоПакетов
	|ИЗ
	|	РегистрСведений.ПакетыДляОтправки КАК ПакетыДляОтправки
	|";
	ПакетовДляОтправки = ЦентрМониторингаСлужебный.ПолучитьПараметрыЦентраМониторинга("ПакетовДляОтправки");
		
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	Выборка.Следующий();
	ВсегоПакетов = Выборка.ВсегоПакетов;
	
	Если ВсегоПакетов > ПакетовДляОтправки Тогда
		КрайнийПакет = ПолучитьКрайнийПакет();
		
		Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1000
		|	ПакетыДляОтправки.НомерПакета КАК НомерПакета
		|ИЗ
		|	РегистрСведений.ПакетыДляОтправки КАК ПакетыДляОтправки
		|ГДЕ
		|	ПакетыДляОтправки.НомерПакета < &КрайнийПакет
		|УПОРЯДОЧИТЬ ПО
		|	ПакетыДляОтправки.НомерПакета УБЫВ
		|";
		
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "1000", Формат(ВсегоПакетов - ПакетовДляОтправки, "ЧГ=")); 
		
		Запрос.УстановитьПараметр("КрайнийПакет", КрайнийПакет);
		Результат = Запрос.Выполнить();
		Выборка = Результат.Выбрать();
		
		НачатьТранзакцию();
		Попытка
			НаборЗаписей = СоздатьНаборЗаписей();
			Пока Выборка.Следующий() Цикл
				НаборЗаписей.Отбор.НомерПакета.Установить(Выборка.НомерПакета);
				НаборЗаписей.Записать(Истина);
			КонецЦикла;
			
			ЗафиксироватьТранзакцию();
		Исключение
			ОтменитьТранзакцию();
			ЗаписьЖурналаРегистрации(НСтр("ru = 'Центр мониторинга';
											|en = 'Monitoring center'", ОбщегоНазначения.КодОсновногоЯзыка()), 
				УровеньЖурналаРегистрации.Ошибка, Метаданные.РегистрыСведений.ПакетыДляОтправки,, 
				ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			ВызватьИсключение;
		КонецПопытки;
		
	КонецЕсли;
КонецПроцедуры

Процедура УдалитьПакет(НомерПакета) Экспорт
	Запрос = Новый Запрос;
	
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	ПакетыДляОтправки.НомерПакета КАК НомерПакета
	|ИЗ
	|	РегистрСведений.ПакетыДляОтправки КАК ПакетыДляОтправки
	|ГДЕ
	|	ПакетыДляОтправки.НомерПакета = &НомерПакета
	|";
	
	Запрос.УстановитьПараметр("НомерПакета", НомерПакета);
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	НачатьТранзакцию();
	Попытка
		НаборЗаписей = СоздатьНаборЗаписей();
		Пока Выборка.Следующий() Цикл
			НаборЗаписей.Отбор.НомерПакета.Установить(Выборка.НомерПакета);
			НаборЗаписей.Записать(Истина);
		КонецЦикла;
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Центр мониторинга';
										|en = 'Monitoring center'", ОбщегоНазначения.КодОсновногоЯзыка()), 
			УровеньЖурналаРегистрации.Ошибка, Метаданные.РегистрыСведений.ПакетыДляОтправки,, 
			ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ВызватьИсключение;
	КонецПопытки;
КонецПроцедуры

Функция ПолучитьПакет(НомерПакета) Экспорт
	Запрос = Новый Запрос;
	
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	ПакетыДляОтправки.НомерПакета,
	|	ПакетыДляОтправки.ТелоПакета,
	|	ПакетыДляОтправки.ХешПакета
	|ИЗ
	|	РегистрСведений.ПакетыДляОтправки КАК ПакетыДляОтправки
	|ГДЕ
	|	ПакетыДляОтправки.НомерПакета = &НомерПакета
	|";
		
	Запрос.УстановитьПараметр("НомерПакета", НомерПакета);
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Пакет = Неопределено;
	Иначе
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
		
		Пакет = Новый Структура;
		Пакет.Вставить("НомерПакета", Выборка.НомерПакета);
		Пакет.Вставить("ТелоПакета", Выборка.ТелоПакета);
		Пакет.Вставить("ХешПакета", Выборка.ХешПакета);	
	КонецЕсли;
	
	Возврат Пакет;
КонецФункции

Функция ПолучитьНомераПакетов() Экспорт
	Запрос = Новый Запрос;
	
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	ПакетыДляОтправки.НомерПакета
    |ИЗ
    |	РегистрСведений.ПакетыДляОтправки КАК ПакетыДляОтправки
    |УПОРЯДОЧИТЬ ПО
    |	ПакетыДляОтправки.НомерПакета
	|";
	
	Результат = Запрос.Выполнить();
	НомераПакетов = Новый Массив;
	Если НЕ Результат.Пустой() Тогда
		Выборка = Результат.Выбрать();
		Пока Выборка.Следующий() Цикл
			НомераПакетов.Добавить(Выборка.НомерПакета);
		КонецЦикла;
	КонецЕсли;
	
	Возврат НомераПакетов;
КонецФункции

Процедура Очистить() Экспорт
    
    НаборЗаписей = СоздатьНаборЗаписей();
    НаборЗаписей.Записать(Истина);
    
КонецПроцедуры

#КонецОбласти

#КонецЕсли
