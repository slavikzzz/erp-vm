///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

Процедура ОбновлениеСтатусовМЧД(Доверенности = Неопределено) Экспорт
	ТаймаутДляПовтора = 180;
	Запрос = Новый Запрос;
	Запрос.Текст =  "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	                |	МашиночитаемыеДоверенности.Ссылка КАК МашиночитаемаяДоверенность,
	                |	МашиночитаемыеДоверенности.НомерДоверенности КАК НомерДоверенности,
	                |	МашиночитаемыеДоверенности.Верна КАК Верна,
	                |	МашиночитаемыеДоверенностиСтатусы.ИдентификаторТранзакции КАК ИдентификаторТранзакции,
	                |	МашиночитаемыеДоверенностиСтатусы.СтатусТранзакции КАК СтатусТранзакции,
	                |	МашиночитаемыеДоверенностиСтатусы.ТехническийСтатус КАК ТехническийСтатусТекущий,
	                |	МашиночитаемыеДоверенностиСтатусы.ТехническийСтатус КАК ТехническийСтатус,
	                |	МашиночитаемыеДоверенностиСтатусы.ТипТранзакции КАК ТипТранзакции,
	                |	МашиночитаемыеДоверенностиСтатусы.ДатаТранзакции КАК ДатаТранзакции,
	                |	МашиночитаемыеДоверенностиСтатусы.Подписана КАК Подписана,
	                |	ВЫБОР
	                |		КОГДА ЕСТЬNULL(МашиночитаемыеДоверенностиСтатусы.ИдентификаторТранзакции, """") = """"
	                |			ТОГДА ЛОЖЬ
	                |		КОГДА МашиночитаемыеДоверенностиСтатусы.СтатусТранзакции = ЗНАЧЕНИЕ(Перечисление.СтатусыТранзакцииСРеестромМЧД.ОжидаетОбработки)
	                |				ИЛИ МашиночитаемыеДоверенностиСтатусы.СтатусТранзакции = ЗНАЧЕНИЕ(Перечисление.СтатусыТранзакцииСРеестромМЧД.ПустаяСсылка)
	                |				ИЛИ &ПроверятьФинальныеСтатусы = ИСТИНА
	                |			ТОГДА ИСТИНА
	                |		ИНАЧЕ ЛОЖЬ
	                |	КОНЕЦ КАК ЗапросСтатусаТранзакции,
	                |	ВЫБОР
	                |		КОГДА МашиночитаемыеДоверенностиСтатусы.ТехническийСтатус = ЗНАЧЕНИЕ(Перечисление.ТехническиеСтатусыМЧД.Регистрация)
	                |				ИЛИ МашиночитаемыеДоверенностиСтатусы.ТехническийСтатус = ЗНАЧЕНИЕ(Перечисление.ТехническиеСтатусыМЧД.ДатаНачалаДействияНеНаступила)
	                |				ИЛИ МашиночитаемыеДоверенностиСтатусы.ТехническийСтатус = ЗНАЧЕНИЕ(Перечисление.ТехническиеСтатусыМЧД.Зарегистрирована)
	                |				ИЛИ МашиночитаемыеДоверенностиСтатусы.ТехническийСтатус = ЗНАЧЕНИЕ(Перечисление.ТехническиеСтатусыМЧД.РегистрацияОтмены)
	                |				ИЛИ &ПроверятьФинальныеСтатусы = ИСТИНА
	                |			ТОГДА ИСТИНА
	                |		ИНАЧЕ ЛОЖЬ
	                |	КОНЕЦ КАК ЗапросСтатусаДоверенности,
	                |	МашиночитаемыеДоверенности.Статус КАК Статус,
	                |	МашиночитаемыеДоверенности.ДляНалоговыхОрганов КАК ДляНалоговыхОрганов,
	                |	ВЫБОР
	                |		КОГДА МашиночитаемыеДоверенностиСтатусы.ТехническийСтатус = ЗНАЧЕНИЕ(Перечисление.ТехническиеСтатусыМЧД.Регистрация)
	                |				И ЕСТЬNULL(МашиночитаемыеДоверенностиСтатусы.ИдентификаторТранзакции, """") = """"
	                |			ТОГДА ИСТИНА
	                |		ИНАЧЕ ЛОЖЬ
	                |	КОНЕЦ КАК Зарегистрировать,
					|	ВЫБОР
	                |		КОГДА МашиночитаемыеДоверенностиСтатусы.ТехническийСтатус = ЗНАЧЕНИЕ(Перечисление.ТехническиеСтатусыМЧД.РегистрацияОтмены)
	                |				И ЕСТЬNULL(МашиночитаемыеДоверенностиСтатусы.ИдентификаторТранзакции, """") = """"
	                |			ТОГДА ИСТИНА
	                |		ИНАЧЕ ЛОЖЬ
	                |	КОНЕЦ КАК ЗарегистрироватьОтмену,
	                |	МашиночитаемыеДоверенности.ФайлДоверенности КАК ФайлДоверенности,
	                |	МашиночитаемыеДоверенностиСтатусы.ДанныеОшибкиЗапросаСтатуса КАК ДанныеОшибкиЗапросаСтатусаТекущие
	                |ИЗ
	                |	Справочник.МашиночитаемыеДоверенности КАК МашиночитаемыеДоверенности
	                |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.МашиночитаемыеДоверенностиСтатусы КАК МашиночитаемыеДоверенностиСтатусы
	                |		ПО (МашиночитаемыеДоверенностиСтатусы.МашиночитаемаяДоверенность = МашиночитаемыеДоверенности.Ссылка)
	                |ГДЕ
	                |	(МашиночитаемыеДоверенностиСтатусы.СтатусТранзакции = ЗНАЧЕНИЕ(Перечисление.СтатусыТранзакцииСРеестромМЧД.ОжидаетОбработки)
	                |			ИЛИ МашиночитаемыеДоверенностиСтатусы.СтатусТранзакции = ЗНАЧЕНИЕ(Перечисление.СтатусыТранзакцииСРеестромМЧД.ПустаяСсылка)
	                |			ИЛИ МашиночитаемыеДоверенностиСтатусы.ТехническийСтатус = ЗНАЧЕНИЕ(Перечисление.ТехническиеСтатусыМЧД.Регистрация)
	                |			ИЛИ МашиночитаемыеДоверенностиСтатусы.ТехническийСтатус = ЗНАЧЕНИЕ(Перечисление.ТехническиеСтатусыМЧД.ДатаНачалаДействияНеНаступила)
	                |			ИЛИ МашиночитаемыеДоверенностиСтатусы.ТехническийСтатус = ЗНАЧЕНИЕ(Перечисление.ТехническиеСтатусыМЧД.Зарегистрирована)
	                |			ИЛИ МашиночитаемыеДоверенностиСтатусы.ТехническийСтатус = ЗНАЧЕНИЕ(Перечисление.ТехническиеСтатусыМЧД.РегистрацияОтмены)
	                |			ИЛИ &ПроверятьФинальныеСтатусы = ИСТИНА)
	                |	И МашиночитаемыеДоверенности.Ссылка В(&Доверенности)";
	Запрос.УстановитьПараметр("ПроверятьФинальныеСтатусы", Доверенности<>Неопределено);
	Если Доверенности = Неопределено Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "МашиночитаемыеДоверенности.Ссылка В(&Доверенности)", "Истина");
	Иначе
		Запрос.УстановитьПараметр("Доверенности", Доверенности);
	КонецЕсли;
	Результат = Запрос.Выполнить();
	
	Если Не Результат.Пустой() Тогда
		
		ДоверенностиДляПроверкиСтатуса = Результат.Выгрузить();
		
		ДоверенностиДляПроверкиСтатуса.Колонки.Добавить("РезультатЗапросаСтатуса");
		ДоверенностиДляПроверкиСтатуса.Колонки.Добавить("ДатаЗапросаСтатуса");
		ДоверенностиДляПроверкиСтатуса.Колонки.Добавить("ЗаписыватьВРегистр");
		ДоверенностиДляПроверкиСтатуса.Колонки.Добавить("ЗаписыватьВДокумент");
		ДоверенностиДляПроверкиСтатуса.Колонки.Добавить("ДанныеОшибкиЗапросаСтатуса");
		
		Авторизация = МашиночитаемыеДоверенностиФНССлужебный.АвторизоватьсяНаСервереМЧДРР(НСтр("ru = 'Не удалось обновить статус доверенности';
																								|en = 'Cannot update the status of the letter of authority'"));
		Если Авторизация.Ошибка <> Неопределено Тогда
			Для Каждого ДоверенностьДляПроверки Из ДоверенностиДляПроверкиСтатуса Цикл
				ДоверенностьДляПроверки.ДатаЗапросаСтатуса = ТекущаяДатаСеанса();
				ДоверенностьДляПроверки.ДанныеОшибкиЗапросаСтатуса = Авторизация.Ошибка;
				ДоверенностьДляПроверки.РезультатЗапросаСтатуса = Авторизация.Ошибка.ЗаголовокОшибки;
			КонецЦикла;
			ЗаписатьРезультатОбновленияСтатуса(ДоверенностиДляПроверкиСтатуса);
			Возврат;
		КонецЕсли;
		
		ТокенДоступа = Авторизация.ТокенДоступа;
		
		Для Каждого ДоверенностьДляПроверки Из ДоверенностиДляПроверкиСтатуса Цикл
			
			ДоверенностьДляПроверки.ДанныеОшибкиЗапросаСтатуса = ?(ТипЗнч(ДоверенностьДляПроверки.ДанныеОшибкиЗапросаСтатусаТекущие) = Тип("ХранилищеЗначения"), 
				ДоверенностьДляПроверки.ДанныеОшибкиЗапросаСтатусаТекущие.Получить(), Неопределено);
			
			ДоверенностьДляПроверки.ЗаписыватьВРегистр = Ложь;
			ДоверенностьДляПроверки.ЗаписыватьВДокумент = Ложь;
			
			Если ДоверенностьДляПроверки.Зарегистрировать Тогда
				ДоверенностьДляПроверки.ЗапросСтатусаТранзакции = Ложь;
				ДоверенностьДляПроверки.ЗапросСтатусаДоверенности = Ложь;
				УстановленныеПодписи = ЭлектроннаяПодпись.УстановленныеПодписи(ДоверенностьДляПроверки.ФайлДоверенности);
	
				СвойстваФайла = РаботаСФайламиСлужебныйВызовСервера.ДанныеФайлаИДвоичныеДанные(
						ДоверенностьДляПроверки.ФайлДоверенности,, Новый УникальныйИдентификатор);
				
				Если УстановленныеПодписи.Количество() = 0 Тогда
					Возврат;
				КонецЕсли;
				
				ДанныеПодписей = Новый Массив; 
				Для Каждого УстановленнаяПодпись Из	УстановленныеПодписи Цикл
					ДанныеПодписей.Добавить(УстановленнаяПодпись.Подпись);
				КонецЦикла;
				
				ДанныеПодписи = ДанныеПодписей[0];
				ДанныеРегистрации = МашиночитаемыеДоверенностиФНССлужебный.ЗарегистрироватьМЧДРР(СвойстваФайла.ДанныеФайла.Наименование, 
					СвойстваФайла.ДвоичныеДанные, ДанныеПодписи, ТокенДоступа, ДоверенностьДляПроверки.НомерДоверенности);
					
				ДоверенностьДляПроверки.ЗаписыватьВРегистр = Истина;
				Если ДанныеРегистрации.Ошибка <> Неопределено Тогда
					ДоверенностьДляПроверки.ДанныеОшибкиЗапросаСтатуса = ДанныеРегистрации.Ошибка;
					ДоверенностьДляПроверки.РезультатЗапросаСтатуса = ДанныеРегистрации.Ошибка.ЗаголовокОшибки;
					ДоверенностьДляПроверки.СтатусТранзакции = Перечисления.СтатусыТранзакцииСРеестромМЧД.Ошибка;
					ДоверенностьДляПроверки.ЗапросСтатусаТранзакции = Ложь;
					Если СпособУстранения(ДоверенностьДляПроверки.ДанныеОшибкиЗапросаСтатуса.СпособУстранения, "НеЗапрашиватьСтатусДоверенности") Тогда
						ДоверенностьДляПроверки.ЗапросСтатусаДоверенности = Ложь;
					КонецЕсли;
				Иначе
					ДоверенностьДляПроверки.ИдентификаторТранзакции = ДанныеРегистрации.ИдентификаторТранзакции;
					ДоверенностьДляПроверки.СтатусТранзакции = Перечисления.СтатусыТранзакцииСРеестромМЧД.ОжидаетОбработки;
				КонецЕсли;
				
			КонецЕсли;
			
			Если ДоверенностьДляПроверки.ЗапросСтатусаТранзакции Тогда
			
				ДанныеСтатуса = МашиночитаемыеДоверенностиФНССлужебный.ПолучитьСтатусТранзакцииМЧДРР(ДоверенностьДляПроверки.ИдентификаторТранзакции, 
					ТокенДоступа, ДоверенностьДляПроверки.НомерДоверенности, НСтр("ru = 'Не удалось обновить статус доверенности';
																					|en = 'Cannot update the status of the letter of authority'"));
					
				ДоверенностьДляПроверки.ДатаЗапросаСтатуса = ТекущаяДатаСеанса();
				
				Если ДанныеСтатуса.Ошибка <> Неопределено Тогда
					ВыждатьТаймаут = Ложь;
					Если ДанныеСтатуса.ДатаВремяТранзакции + ТаймаутДляПовтора > ДоверенностьДляПроверки.ДатаЗапросаСтатуса Тогда
						ВыждатьТаймаут = СпособУстранения(ДанныеСтатуса.Ошибка.СпособУстранения, "ИспользоватьТаймаут");
					КонецЕсли;
					Если Не ВыждатьТаймаут Тогда
						ДоверенностьДляПроверки.ДанныеОшибкиЗапросаСтатуса = ДанныеСтатуса.Ошибка;
						ДоверенностьДляПроверки.РезультатЗапросаСтатуса = ДанныеСтатуса.Ошибка.ЗаголовокОшибки;
						ДоверенностьДляПроверки.СтатусТранзакции = Перечисления.СтатусыТранзакцииСРеестромМЧД.Ошибка;
						ДоверенностьДляПроверки.ЗаписыватьВРегистр = Истина;
					КонецЕсли;
					Продолжить;
				КонецЕсли;
				
				ДоверенностьДляПроверки.ЗаписыватьВРегистр = Истина;
				ДоверенностьДляПроверки.СтатусТранзакции = ДанныеСтатуса.СтатусТранзакции;
			КонецЕсли;
				
			Если ДоверенностьДляПроверки.ТипТранзакции = Перечисления.ТипыТранзакцийСРеестромМЧД.Регистрация Тогда
				Если ДоверенностьДляПроверки.СтатусТранзакции = Перечисления.СтатусыТранзакцииСРеестромМЧД.Успешно Тогда
					ДоверенностьДляПроверки.ТехническийСтатус = Перечисления.ТехническиеСтатусыМЧД.Зарегистрирована;
				ИначеЕсли ДоверенностьДляПроверки.СтатусТранзакции = Перечисления.СтатусыТранзакцииСРеестромМЧД.Ошибка Тогда
					Если ДоверенностьДляПроверки.ДанныеОшибкиЗапросаСтатуса <> Неопределено И Не СпособУстранения(ДоверенностьДляПроверки.ДанныеОшибкиЗапросаСтатуса.СпособУстранения, "ПовторнаяОтправка") Тогда
						ДоверенностьДляПроверки.ТехническийСтатус = Перечисления.ТехническиеСтатусыМЧД.ОшибкаРегистрации;
					КонецЕсли;
				КонецЕсли;
			ИначеЕсли ДоверенностьДляПроверки.ТипТранзакции = Перечисления.ТипыТранзакцийСРеестромМЧД.Отмена Тогда
				Если ДоверенностьДляПроверки.СтатусТранзакции = Перечисления.СтатусыТранзакцииСРеестромМЧД.Успешно Тогда
					ДоверенностьДляПроверки.ТехническийСтатус = Перечисления.ТехническиеСтатусыМЧД.Отменена;
					ДоверенностьДляПроверки.ЗапросСтатусаДоверенности = Ложь;
				ИначеЕсли ДоверенностьДляПроверки.СтатусТранзакции = Перечисления.СтатусыТранзакцииСРеестромМЧД.Ошибка Тогда
					ДоверенностьДляПроверки.ТехническийСтатус = Перечисления.ТехническиеСтатусыМЧД.Зарегистрирована;
				ИначеЕсли ДоверенностьДляПроверки.СтатусТранзакции = Перечисления.СтатусыТранзакцииСРеестромМЧД.ОжидаетОбработки Тогда
					ДоверенностьДляПроверки.ТехническийСтатус = Перечисления.ТехническиеСтатусыМЧД.РегистрацияОтмены;
					ДоверенностьДляПроверки.ЗапросСтатусаДоверенности = Ложь;
				КонецЕсли;
			КонецЕсли;
			
			Если ДоверенностьДляПроверки.ДляНалоговыхОрганов
				И ДоверенностьДляПроверки.СтатусТранзакции <> Перечисления.СтатусыТранзакцииСРеестромМЧД.Ошибка
				И ДоверенностьДляПроверки.ТипТранзакции = Перечисления.ТипыТранзакцийСРеестромМЧД.Регистрация Тогда
				ДоверенностьДляПроверки.ЗапросСтатусаДоверенности = Истина;
			КонецЕсли;
				
			
			Если ДоверенностьДляПроверки.ЗапросСтатусаДоверенности Тогда
			
				ДанныеСтатусаДоверенности = МашиночитаемыеДоверенностиФНССлужебный.ЧастичныеДанныеДоверенностиМЧДРР( 
					ДоверенностьДляПроверки.НомерДоверенности, ТокенДоступа, НСтр("ru = 'Не удалось обновить статус доверенности';
																					|en = 'Cannot update the status of the letter of authority'"));
					
				ДоверенностьДляПроверки.ДатаЗапросаСтатуса = ТекущаяДатаСеанса();
				
				Если ДанныеСтатусаДоверенности.Ошибка <> Неопределено Тогда
					ПовторнаяОтправка = СпособУстранения(ДанныеСтатусаДоверенности.Ошибка.СпособУстранения, "ПовторнаяОтправка");
					ВыждатьТаймаут = Ложь;
					Если ?(ДоверенностьДляПроверки.ЗапросСтатусаТранзакции, ДанныеСтатуса.ДатаВремяТранзакции, ДоверенностьДляПроверки.ДатаТранзакции) + ТаймаутДляПовтора > ДоверенностьДляПроверки.ДатаЗапросаСтатуса Тогда
						ВыждатьТаймаут = СпособУстранения(ДанныеСтатусаДоверенности.Ошибка.СпособУстранения, "ИспользоватьТаймаут");
					КонецЕсли;
					Если Не ВыждатьТаймаут И Не ПовторнаяОтправка Тогда
						ДоверенностьДляПроверки.ДанныеОшибкиЗапросаСтатуса = ДанныеСтатусаДоверенности.Ошибка;
						ДоверенностьДляПроверки.РезультатЗапросаСтатуса = ДанныеСтатусаДоверенности.Ошибка.ЗаголовокОшибки;
						ДоверенностьДляПроверки.СтатусТранзакции = Перечисления.СтатусыТранзакцииСРеестромМЧД.Ошибка;
						ДоверенностьДляПроверки.ЗаписыватьВРегистр = Истина;
					КонецЕсли;
					Продолжить;
				КонецЕсли;
				ДоверенностьДляПроверки.ДанныеОшибкиЗапросаСтатуса = Неопределено;
				ДоверенностьДляПроверки.СтатусТранзакции = Перечисления.СтатусыТранзакцииСРеестромМЧД.Успешно;
				
				ДоверенностьДляПроверки.ТехническийСтатус = МашиночитаемыеДоверенностиФНССлужебный.ПолучитьЗначениеСтатуса(ДанныеСтатусаДоверенности.СтатусДоверенности);
				ДоверенностьДляПроверки.ЗаписыватьВРегистр = ДоверенностьДляПроверки.ЗаписыватьВРегистр Или ЗначениеЗаполнено(ДоверенностьДляПроверки.ТехническийСтатус);
			КонецЕсли;
			
			РасчетныйСтатусДокумента = МашиночитаемыеДоверенностиФНССлужебный.РасчетныйСтатусДокумента(ДоверенностьДляПроверки.ТехническийСтатус, ДоверенностьДляПроверки.Верна);
			
			ДоверенностьДляПроверки.ЗаписыватьВДокумент = РасчетныйСтатусДокумента <> ДоверенностьДляПроверки.Статус;
			ДоверенностьДляПроверки.Статус = РасчетныйСтатусДокумента;
		КонецЦикла;

		ОтборКЗаписи = Новый Структура("ЗаписыватьВРегистр", Истина);
		ДоверенностиДляУстановкиСтатусов = ДоверенностиДляПроверкиСтатуса.Скопировать(ОтборКЗаписи);
		
		ЗаписатьРезультатОбновленияСтатуса(ДоверенностиДляУстановкиСтатусов);
		
	КонецЕсли;
КонецПроцедуры

Процедура ЗаписатьРезультатОбновленияСтатуса(ДанныеДляЗаписи)
	
	ОтборКЗаписиВДокумент = Новый Структура("ЗаписыватьВДокумент", Истина);

	ДанныеДляЗаписиВДокумент = ДанныеДляЗаписи.Скопировать(ОтборКЗаписиВДокумент, "МашиночитаемаяДоверенность");
	
	НачатьТранзакцию();
	Попытка
		БлокировкаДанных = Новый БлокировкаДанных;
		ЭлементБлокировки = БлокировкаДанных.Добавить("РегистрСведений.МашиночитаемыеДоверенностиСтатусы");
		ЭлементБлокировки.ИсточникДанных = ДанныеДляЗаписи;
		ЭлементБлокировки.ИспользоватьИзИсточникаДанных("МашиночитаемаяДоверенность", "МашиночитаемаяДоверенность");
		
		ЭлементБлокировки = БлокировкаДанных.Добавить("Справочник.МашиночитаемыеДоверенности");
		ЭлементБлокировки.ИсточникДанных = ДанныеДляЗаписиВДокумент;
		ЭлементБлокировки.ИспользоватьИзИсточникаДанных("Ссылка", "МашиночитаемаяДоверенность");
		БлокировкаДанных.Заблокировать();
		
		УстановитьПривилегированныйРежим(Истина);
		
		Для Каждого ДоверенностьДляПроверки Из ДанныеДляЗаписи Цикл
			
			МашиночитаемаяДоверенность = ДоверенностьДляПроверки.МашиночитаемаяДоверенность;
			
			НаборЗаписей = РегистрыСведений.МашиночитаемыеДоверенностиСтатусы.СоздатьНаборЗаписей();
			НаборЗаписей.Отбор.МашиночитаемаяДоверенность.Установить(МашиночитаемаяДоверенность);
			ЗаполнитьЗначенияСвойств(НаборЗаписей.Добавить(), ДоверенностьДляПроверки);
			НаборЗаписей[0].МашиночитаемаяДоверенность = МашиночитаемаяДоверенность;
			НаборЗаписей[0].ДанныеОшибкиЗапросаСтатуса = Новый ХранилищеЗначения(ДоверенностьДляПроверки.ДанныеОшибкиЗапросаСтатуса);
			НаборЗаписей.Записать();
			
			Если ДоверенностьДляПроверки.ЗаписыватьВДокумент = Истина Тогда
				МашиночитаемаяДоверенностьОбъект = МашиночитаемаяДоверенность.ПолучитьОбъект();
				МашиночитаемаяДоверенностьОбъект.Статус = ДоверенностьДляПроверки.Статус;
				МашиночитаемаяДоверенностьОбъект.Записать();
			КонецЕсли;
				
		КонецЦикла;
		
		ЗафиксироватьТранзакцию(); 
		
	Исключение
		ОтменитьТранзакцию();
		ЗаписьЖурналаРегистрации(МашиночитаемыеДоверенностиФНССлужебный.ИмяСобытияЖурналаРегистрации(), 
			УровеньЖурналаРегистрации.Ошибка,,, ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

Функция СпособУстранения(СпособУстраненияСтрокой, Методика)
	Если ЗначениеЗаполнено(СпособУстраненияСтрокой) Тогда
		ЧтениеJSON = Новый ЧтениеJSON;
		ЧтениеJSON.УстановитьСтроку(СпособУстраненияСтрокой);
		СпособУстранения = ПрочитатьJSON(ЧтениеJSON);
		ЧтениеJSON.Закрыть();
	Иначе
		Возврат Ложь;	
	КонецЕсли;
	
	МетодикиУстранения = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(СпособУстранения, "МетодикиУстранения", Неопределено);
	Если МетодикиУстранения.Найти(Методика) <> Неопределено Тогда
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;
КонецФункции

#КонецОбласти

#КонецЕсли
