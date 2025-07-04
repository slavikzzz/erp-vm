// @strict-types

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

#Область ПросмотрДоверенности

// Параметры:
//  Организация - ОпределяемыйТип.Организация
//  НомерДоверенности - Строка
//  ИННДоверителя - Строка
// 
// Возвращаемое значение:
//  Структура:
//  * СтатусыДоверенности - см. СтатусыДоверенностиИзФорматаСервиса
//  * НастройкиПроверкиПолномочий - Неопределено,Массив из Структура
//  * Визуализация - см. ВизуализацияДоверенностиИзФорматаСервиса
//  * КонтекстДиагностики - см. ОбработкаНеисправностейБЭД.НовыйКонтекстДиагностики
//
Функция ДанныеДляПросмотраДоверенности(Организация, НомерДоверенности, ИННДоверителя) Экспорт
	
	ДанныеДляПросмотра = Новый Структура;
	ДанныеДляПросмотра.Вставить("СтатусыДоверенности", Новый Структура);
	ДанныеДляПросмотра.Вставить("НастройкиПроверкиПолномочий", Неопределено);
	ДанныеДляПросмотра.Вставить("Визуализация", Неопределено);
	ДанныеДляПросмотра.Вставить("КонтекстДиагностики", ОбработкаНеисправностейБЭД.НовыйКонтекстДиагностики());
	
	ОперацияСервиса = СервисОблачногоЭДО.НоваяОперацияСервиса();
	ОперацияСервиса.ИдентификаторУчетнойЗаписи = РегистрыСведений.УчетныеЗаписиОблачногоЭДО.ИдентификаторУчетнойЗаписи(
		Организация);
	
	ОписаниеМетода = ОписаниеМетодаПолученияСтатусовДоверенности(НомерДоверенности, ИННДоверителя);
	СервисОблачногоЭДО.ДобавитьОписаниеМетодаВОперацию(ОперацияСервиса, ОписаниеМетода);
	
	ОписаниеМетода = ОписаниеМетодаПолученияВизуализацииДоверенности(НомерДоверенности, ИННДоверителя);
	СервисОблачногоЭДО.ДобавитьОписаниеМетодаВОперацию(ОперацияСервиса, ОписаниеМетода);
	
	РезультатОперации = СервисОблачногоЭДО.ВыполнитьОперациюСервиса(ОперацияСервиса);
	
	Если ЗначениеЗаполнено(РезультатОперации.Ошибки) Тогда
		ИнтеграцияОблачногоЭДО.ДобавитьНеизвестнуюОшибку(ДанныеДляПросмотра.КонтекстДиагностики,
			НСтр("ru = 'Получение данных для просмотра доверенности';
				|en = 'Get data to view the authorization letter'"),
			СтрСоединить(РезультатОперации.Ошибки, Символы.ПС));
		Возврат ДанныеДляПросмотра;
	КонецЕсли;
	
	РезультатыМетодов = РезультатОперации.РезультатыМетодов;
	
	ДанныеДляПросмотра.СтатусыДоверенности = СтатусыДоверенностиИзФорматаСервиса(РезультатыМетодов[0]);
	
	ДанныеДляПросмотра.Визуализация = ВизуализацияДоверенностиИзФорматаСервиса(РезультатыМетодов[1]);
	
	Возврат ДанныеДляПросмотра;
	
КонецФункции

// Параметры:
//  НомерДоверенности - Строка
//  ИННДоверителя - Строка
//  ИдентификаторМетода - Неопределено,Строка,Число
//
// Возвращаемое значение:
//  См. СервисОблачногоЭДО.ОписаниеМетодаСервиса
Функция ОписаниеМетодаПолученияСтатусовДоверенности(НомерДоверенности, ИННДоверителя, ИдентификаторМетода = Неопределено)
	ПараметрыМетода = Новый Массив; // см. СервисОблачногоЭДО.ОписаниеМетодаСервиса.Параметры
	ПараметрыМетода.Добавить(НомерДоверенности);
	Возврат СервисОблачногоЭДО.ОписаниеМетодаСервиса(
		"ОбменСКонтрагентамиВОблаке.СтатусыДоверенности", ПараметрыМетода, ИдентификаторМетода);
КонецФункции

// Параметры:
//  НомерДоверенности - Строка
//  ИННДоверителя - Строка
//  ИдентификаторМетода - Неопределено,Строка,Число
//
// Возвращаемое значение:
//  См. СервисОблачногоЭДО.ОписаниеМетодаСервиса
Функция ОписаниеМетодаПолученияВизуализацииДоверенности(НомерДоверенности, ИННДоверителя, ИдентификаторМетода = Неопределено)
	ПараметрыМетода = Новый Массив; // см. СервисОблачногоЭДО.ОписаниеМетодаСервиса.Параметры
	ПараметрыМетода.Добавить(НомерДоверенности);
	Возврат СервисОблачногоЭДО.ОписаниеМетодаСервиса(
		"ОбменСКонтрагентамиВОблаке.ВизуализацияДоверенности", ПараметрыМетода, ИдентификаторМетода);
КонецФункции

// Параметры:
//  СтатусыДоверенностиВФорматеСервиса - Структура:
//  * Подписана - Булево
//  * Верна - Булево
//  * Отозвана - Булево
//  * ДатаОтзыва - Строка - дата в формате ISO.
//  * СтатусВРеестреФНС - Неопределено
//                      - Строка
// 
// Возвращаемое значение:
//  Структура:
//  * Подписана - Булево
//  * Верна - Булево
//  * Отозвана - Булево
//  * ДатаОтзыва - Дата
//  * СтатусВРеестреФНС - ПеречислениеСсылка.СтатусыМашиночитаемойДоверенностиВРеестреФНС
Функция СтатусыДоверенностиИзФорматаСервиса(СтатусыДоверенностиВФорматеСервиса)
	
	СтатусыДоверенности = Новый Структура;
	СтатусыДоверенности.Вставить("Подписана", Ложь);
	СтатусыДоверенности.Вставить("Верна", Ложь);
	СтатусыДоверенности.Вставить("Отозвана", Ложь);
	СтатусыДоверенности.Вставить("ДатаОтзыва", '00010101');
	СтатусыДоверенности.Вставить("СтатусВРеестреФНС",
		Перечисления.СтатусыМашиночитаемойДоверенностиВРеестреФНС.ПустаяСсылка());
	
	ЗаполнитьЗначенияСвойств(СтатусыДоверенности, СтатусыДоверенностиВФорматеСервиса,,"ДатаОтзыва, СтатусВРеестреФНС");
	
	Если ЗначениеЗаполнено(СтатусыДоверенностиВФорматеСервиса.ДатаОтзыва) Тогда
		СтатусыДоверенности.ДатаОтзыва = ПрочитатьДатуJSON(СтатусыДоверенностиВФорматеСервиса.ДатаОтзыва,
			ФорматДатыJSON.ISO);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(СтатусыДоверенностиВФорматеСервиса.СтатусВРеестреФНС) Тогда
		СтатусВРеестреФНС = ОбщегоНазначенияБЭД.ЗначениеПеречисленияПоИмени(
			СтатусыДоверенностиВФорматеСервиса.СтатусВРеестреФНС, СтатусыДоверенности.СтатусВРеестреФНС.Метаданные()); // ПеречислениеСсылка.СтатусыМашиночитаемойДоверенностиВРеестреФНС
		СтатусыДоверенности.СтатусВРеестреФНС = СтатусВРеестреФНС;
	КонецЕсли;
	
	Возврат СтатусыДоверенности;
	
КонецФункции

// Параметры:
//  ВизуализацияВФорматеСервиса - Неопределено
//                              - Строка - двоичные данные в формате base64.
// 
// Возвращаемое значение:
//  - Неопределено
//  - ТабличныйДокумент
Функция ВизуализацияДоверенностиИзФорматаСервиса(ВизуализацияВФорматеСервиса)
	
	Визуализация = Неопределено;
	
	Если Не ЗначениеЗаполнено(ВизуализацияВФорматеСервиса) Тогда
		Возврат Визуализация;
	КонецЕсли;
	
	ДвоичныеДанные = Base64Значение(ВизуализацияВФорматеСервиса);
	Визуализация = ИнтеграцияОблачногоЭДО.ТабличныйДокументИзДвоичныхДанных(ДвоичныеДанные);
	
	Возврат Визуализация;
	
КонецФункции

#КонецОбласти

#Область ВыгрузитьВОблачныйЭДО

// Параметры:
//  ИдентификаторыУчетныхЗаписей - Массив из см. РегистрСведений.УчетныеЗаписиОблачногоЭДО.Идентификатор
//  Доверенности - Массив из СправочникСсылка.МашиночитаемыеДоверенностиОрганизаций,СправочникСсылка.МЧД003
// 
// Возвращаемое значение:
//  Структура:
//  * ЕстьОшибки - Булево
//  * КонтекстДиагностики - см. ОбработкаНеисправностейБЭД.НовыйКонтекстДиагностики
Функция ВыгрузитьВОблачныйЭДО(ИдентификаторыУчетныхЗаписей, Доверенности) Экспорт
	
	КонтекстДиагностики = ОбработкаНеисправностейБЭД.НовыйКонтекстДиагностики();
	
	Результат = Новый Структура;
	Результат.Вставить("ЕстьОшибки", Ложь);
	Результат.Вставить("КонтекстДиагностики", КонтекстДиагностики);
	
	Для Каждого ИдентификаторУчетнойЗаписи Из ИдентификаторыУчетныхЗаписей Цикл
		
		ОперацияСервиса = СервисОблачногоЭДО.НоваяОперацияСервиса();
		ОперацияСервиса.ИдентификаторУчетнойЗаписи = ИдентификаторУчетнойЗаписи;
		
		ДобавитьОписанияМетодовЗагрузкиДоверенностейПоСсылкам(ОперацияСервиса, Доверенности);
		
		РезультатОперации = СервисОблачногоЭДО.ВыполнитьОперациюСервиса(ОперацияСервиса);
		
		РезультатыМетодов = РезультатОперации.РезультатыМетодов;
		
		Если Не ЗначениеЗаполнено(РезультатыМетодов) Тогда
			Продолжить;
		КонецЕсли;
		
		Для Каждого РезультатМетода Из РезультатыМетодов Цикл
			
			Индекс = РезультатМетода.Ключ;
			Доверенность = Доверенности[Индекс];
			РезультатЗагрузки = РезультатЗагрузкиДоверенностиИзФорматаСервиса(РезультатМетода.Значение);
			
			Если Не ЗначениеЗаполнено(РезультатЗагрузки.Ошибка) Тогда
				Продолжить;
			КонецЕсли;
			
			Результат.ЕстьОшибки = Истина;
			
			ВидОперации = НСтр("ru = 'Выгрузка МЧД в облачный ЭДО.';
								|en = 'Export the machine-readable letter of authority to the cloud EDI.'");
			ТекстСообщения = СтрШаблон(НСтр("ru = 'Не удалось выгрузить машиночитаемую доверенность %1
				|по учетной записи облачного ЭДО %2';
				|en = 'Cannot export the %1machine-readable letter of authority
				|by the %2 cloud EDI account'"), Доверенность, ИдентификаторУчетнойЗаписи)
				+ Символы.ПС + РезультатЗагрузки.Ошибка;
			ИнтеграцияОблачногоЭДО.ДобавитьНеизвестнуюОшибку(КонтекстДиагностики, ВидОперации, ТекстСообщения);
			
		КонецЦикла;
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Параметры:
//  ОперацияСервиса - см. СервисОблачногоЭДО.НоваяОперацияСервиса
//  Доверенности - Массив из СправочникСсылка.МашиночитаемыеДоверенностиОрганизаций,СправочникСсылка.МашиночитаемыеДоверенностиКонтрагентов
Процедура ДобавитьОписанияМетодовЗагрузкиДоверенностейПоСсылкам(ОперацияСервиса, Доверенности)
	
	ОбщийМодульМашиночитаемыеДоверенности = ОбщегоНазначения.ОбщийМодуль("МашиночитаемыеДоверенности");
	
	ОбщиеСвойстваДоверенностей = ОбщийМодульМашиночитаемыеДоверенности.ОбщиеСвойстваДоверенностей(Доверенности);
	
	Для Каждого ОбщиеСвойстваПоДоверенности Из ОбщиеСвойстваДоверенностей Цикл
		ОбщиеСвойстваДоверенности = ОбщиеСвойстваПоДоверенности.Значение;
		ОписаниеМетода = ОписаниеМетодаЗагрузкиДоверенностиИзРеестраФНС(ОбщиеСвойстваДоверенности.НомерДоверенности,
			ОбщиеСвойстваДоверенности.ДоверительИНН);
		СервисОблачногоЭДО.ДобавитьОписаниеМетодаВОперацию(ОперацияСервиса, ОписаниеМетода);
	КонецЦикла;
	
КонецПроцедуры

// Параметры:
//  НомерДоверенности - Строка
//  ИННДоверителя - Строка
//  ИдентификаторМетода - Неопределено,Строка,Число
//
// Возвращаемое значение:
//  См. СервисОблачногоЭДО.ОписаниеМетодаСервиса
Функция ОписаниеМетодаЗагрузкиДоверенностиИзРеестраФНС(НомерДоверенности, ИННДоверителя, ИдентификаторМетода = Неопределено)
	ПараметрыМетода = Новый Массив; // см. СервисОблачногоЭДО.ОписаниеМетодаСервиса.Параметры
	ПараметрыМетода.Добавить(НомерДоверенности);
	ПараметрыМетода.Добавить(ИННДоверителя);
	Возврат СервисОблачногоЭДО.ОписаниеМетодаСервиса(
		"ОбменСКонтрагентамиВОблаке.ЗагрузитьДоверенностьИзРеестраФНС", ПараметрыМетода, ИдентификаторМетода);
КонецФункции

// Параметры:
//  РезультатыЗагрузкиВФорматеСервиса - Структура:
//  * Ошибка - Неопределено
//           - Строка
//  * ОписаниеДоверенности - Неопределено
//                         - Структура:
//  ** НомерДоверенности - Строка
//  ** ХешДанных - Строка
//  ** СтатусВРеестре - Строка
//  
// Возвращаемое значение:
//  Структура:
//  * Ошибка - Неопределено
//           - Строка
//  * ОписаниеДоверенности - Неопределено
//                         - Структура:
//  ** НомерДоверенности - Строка
//  ** ХешДанных - Строка
//  ** СтатусВРеестре - Строка  
Функция РезультатЗагрузкиДоверенностиИзФорматаСервиса(РезультатыЗагрузкиВФорматеСервиса)
	Возврат РезультатыЗагрузкиВФорматеСервиса;
КонецФункции

// Параметры:
//  ОперацияСервиса - см. СервисОблачногоЭДО.НоваяОперацияСервиса
//  Организация - ОпределяемыйТип.Организация
//  Сертификаты - Массив из СправочникСсылка.СертификатыКлючейЭлектроннойПодписиИШифрования
//
// Возвращаемое значение:
//  Булево
Функция ДобавитьОписанияМетодовЗагрузкиДоверенностейПоСертификатам(ОперацияСервиса, Организация, Сертификаты) Экспорт
	
	Доверенности = ДоверенностиОрганизацииПоСертификатам(Организация, Сертификаты);
	
	Если Не ЗначениеЗаполнено(Доверенности) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ДобавитьОписанияМетодовЗагрузкиДоверенностейПоСсылкам(ОперацияСервиса, Доверенности);
	
	Возврат Истина;
	
КонецФункции

// Параметры:
//  Организация - СправочникСсылка.Организации
//  Сертификаты - Массив из СправочникСсылка.СертификатыКлючейЭлектроннойПодписиИШифрования
// 
// Возвращаемое значение:
//  См. МашиночитаемыеДоверенности.ПолучитьДоверенностиОрганизации
Функция ДоверенностиОрганизацииПоСертификатам(Организация, Сертификаты)
	
	ДоверенностиСертификатов = Новый Массив; // Массив из СправочникСсылка.МашиночитаемыеДоверенностиОрганизаций,СправочникСсылка.МЧД003
	
	ОбщийМодульМашиночитаемыеДоверенности = ОбщегоНазначения.ОбщийМодуль("МашиночитаемыеДоверенности");
	
	Для Каждого Сертификат Из Сертификаты Цикл
		
		Отбор = МашиночитаемыеДоверенности.НовыйОтборМЧД();
		Отбор.Доверитель = Организация;
		Отбор.Сертификат = Сертификат;
		ДоверенностиОрганизации = ОбщийМодульМашиночитаемыеДоверенности.ПолучитьДоверенностиОрганизации(Отбор); // Массив из СправочникСсылка.МашиночитаемыеДоверенностиОрганизаций,СправочникСсылка.МЧД003
		
		Если ЗначениеЗаполнено(ДоверенностиОрганизации) Тогда
			ДоверенностиСертификатов.Добавить(ДоверенностиОрганизации[0]);
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ДоверенностиСертификатов;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли
