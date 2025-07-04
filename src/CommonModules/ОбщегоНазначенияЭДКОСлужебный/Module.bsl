////////////////////////////////////////////////////////////////////////////////
// Подсистема "Базовая функциональность 
//             электронного документооборота с контролирующими органами". 
////////////////////////////////////////////////////////////////////////////////


#Область СлужебныйПрограммныйИнтерфейс

Процедура ПолучитьДистрибутивCryptoProCSP(Параметры, АдресРезультата, АдресДополнительногоРезультата) Экспорт
	
	URL = "https://www.cryptopro.ru/products/csp/downloads/kontur";
	ПараметрыСоединения = Новый Структура;
	ПараметрыСоединения.Вставить("ЗащищенноеСоединение", Новый ЗащищенноеСоединениеOpenSSL);
	Соединение = ОбщегоНазначенияЭДКО.СоединениеССерверомИнтернета(URL, ПараметрыСоединения);
	
	Заголовки = Новый Соответствие;
	Заголовки.Вставить("Content-Type", "application/x-www-form-urlencoded");
	Запрос = Новый HTTPЗапрос("/products/csp/downloads/kontur", Заголовки);
	
	СтрокаЗапроса = "product=%1&username=%2&email=%3&company=%4";
	СтрокаЗапроса = СтрШаблон(СтрокаЗапроса,
		Параметры.Продукт,
		КодироватьСтроку(Параметры.КонтактноеЛицо, СпособКодированияСтроки.URLВКодировкеURL), 
		КодироватьСтроку(Параметры.ЭлектроннаяПочта, СпособКодированияСтроки.URLВКодировкеURL),
		"");
	
	Запрос.УстановитьТелоИзСтроки(СтрокаЗапроса);
	
	Ответ = Соединение.ОтправитьДляОбработки(Запрос);
	
	Если Ответ.КодСостояния = 200 И Ответ.Заголовки.Получить("Distribution-Number") <> Неопределено Тогда
		ПоместитьВоВременноеХранилище(Ответ.ПолучитьТелоКакДвоичныеДанные(), АдресДополнительногоРезультата);
		ПараметрыДистрибутива = Новый Структура;
		ПараметрыДистрибутива.Вставить("НомерДистрибутива", Ответ.Заголовки["Distribution-Number"]);
		ПараметрыДистрибутива.Вставить("КонтрольнаяСумма", Ответ.Заголовки["GOST"]);
		ПараметрыДистрибутива.Вставить("Версия", Ответ.Заголовки["Version"]);
		ПараметрыДистрибутива.Вставить("Дистрибутив", АдресДополнительногоРезультата);
	Иначе
		Ошибка = Ответ.ПолучитьТелоКакСтроку();
		ЗаписьЖурналаРегистрации(
			НСтр("ru = 'Электронный документооброт с контролирующими органами.Получение серийного номер CryptoPro CSP';
				|en = 'Электронный документооброт с контролирующими органами.Получение серийного номер CryptoPro CSP'", ОбщегоНазначения.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка,,, Ошибка);
		ВызватьИсключение(Ошибка);
	КонецЕсли;
	
	ПоместитьВоВременноеХранилище(ПараметрыДистрибутива, АдресРезультата);
	
КонецПроцедуры

#КонецОбласти