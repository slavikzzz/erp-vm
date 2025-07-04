#Область ПрограммныйИнтерфейс

// Возвращает строку пустого глобального уникального идентификатора GUID.
//
// Возвращаемое значение:
//  Строка - строка, содержащая пустой уникальный идентификатор.
//
Функция ПустойУникальныйИдентификатор() Экспорт
	Возврат "00000000-0000-0000-0000-000000000000" // АПК:1297 Не локализуется
КонецФункции

// Из переданной строки создает новую, содержащую только цифры.
// Иные символы отбрасываются.
//
// Параметры:
//  Значение - Строка - исходная строка.
//
// Возвращаемое значение:
//   Строка - строка, содержащая только цифры.
//
Функция СкопироватьЦифры(Знач Значение) Экспорт
	Возврат СкопироватьСимволы(Значение, "0123456789") // АПК:1297 Не локализуется, перечень всех цифр
КонецФункции

// Из переданной строки создает новую, содержащую только указанные символы.
// Иные символы отбрасываются.
//
// Параметры:
//  Значение - Строка - исходная строка.
//  Символы  - Строка - допустимые символы.
//
// Возвращаемое значение:
//   Строка - строка, содержащая только указанные символы.
//
Функция СкопироватьСимволы(Знач Значение, Знач Символы) Экспорт
	// Справа налево:
	// 1. Разбиваем исходную строку, используя допустимые символы как разделители.
	//    Получим массив со строками, состоящими из недопустимых символов.
	// 2. Соединяем недопустимые символы в строку лишних букв.
	// 3. Разбиваем исходную строку, используя лишние символы как разделители.
	//    Получим массив со строками, состоящими из допустимых символов.
	// 4. Соединяем разрешенные символы в итоговую строку.
	Возврат СтрСоединить(СтрРазделить(Значение, СтрСоединить(СтрРазделить(Значение, Символы))))
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Разделяет строку с именами свойств на части по разделителю-запятой.
//
// Параметры:
//	СписокСвойств - Строка - имена свойств,  разделенные запятыми. 
//
// Возвращаемое значение:
//	Булево - Массив, строки, которые получились в результате разделения списка свойств.
// 
Функция РазделитьИменаСвойств(СписокСвойств) Экспорт
	ИменаСвойств = Новый Массив;
	Для Каждого Свойство Из Новый Структура(СписокСвойств) Цикл
	    ИменаСвойств.Добавить(Свойство.Ключ)
	КонецЦикла;	
	Возврат ИменаСвойств
КонецФункции

// Получает числовой номер объекта.
//
// Параметры:
//    НомерОбъекта - Строка - Строковый номер объекта.
//
// Возвращаемое значение:
//     Неопределено - Не удалось преобразовать номер объекта в число.
//     Число - Числовой номер объекта.
//
Функция НомерОбъектаЧислом(Знач НомерОбъекта) Экспорт
	Номер = СокрЛП(НомерОбъекта);
	
	// Удаление пользовательских префиксов.
	Номер = ПрефиксацияОбъектовКлиентСервер.УдалитьПользовательскиеПрефиксыИзНомераОбъекта(Номер);
	
	// Удаление лидирующих нулей.
	Номер = ПрефиксацияОбъектовКлиентСервер.УдалитьЛидирующиеНулиИзНомераОбъекта(Номер);
	
	// Удаление префикса организации и префикса информационной базы.
	Номер = ПрефиксацияОбъектовКлиентСервер.УдалитьПрефиксыИзНомераОбъекта(Номер, Истина, Истина);
	
	Возврат СтроковыеФункцииКлиентСервер.СтрокаВЧисло(Номер);
КонецФункции

// Убирает цифры из строки.
//
// Параметры:
//    Строка - Исходная строка.
//
// Возвращаемое значение:
//     Строка - Строка без цифр.
//
Функция УдалитьЦифрыИзСтроки(Строка) Экспорт
	Возврат УдалитьСимволы(Строка, "0123456789");
КонецФункции

// Убирает указанные символы из строки.
//
// Параметры:
//    Строка           - Строка - Исходная строка.
//    УдаляемыеСимволы - Строка - Удаляемые символы.
//
// Возвращаемое значение:
//     Строка - Строка без указанных символов.
//
Функция УдалитьСимволы(Строка, УдаляемыеСимволы) Экспорт
	// Текущий вариант (с Ложь и "") оказался быстрее чем вариант без параметров ~ на 5-15% (зависит от длин строк):
	// СтрСоединить(СтрРазделить(Строка, УдаляемыеСимволы)).
	Возврат СтрСоединить(СтрРазделить(Строка, УдаляемыеСимволы, Ложь), "");
КонецФункции

// Соединяет заполненные строки через разделитель (пустые пропускает).
//
// Параметры:
//  Разделитель - Строка
//  Строка1     - Строка
//  Строка2     - Строка
//  Строка3     - Строка
//  Строка4     - Строка
//
// Возвращаемое значение:
//   Строка - строки соединенные через разделитель.
//
Функция Соединить(Разделитель, Строка1, Строка2, Строка3 = Неопределено, Строка4 = Неопределено) Экспорт
	Массив = Новый Массив;
	Если ЗначениеЗаполнено(Строка1) Тогда
		Массив.Добавить(Строка1);
	КонецЕсли;
	Если ЗначениеЗаполнено(Строка2) Тогда
		Массив.Добавить(Строка2);
	КонецЕсли;
	Если ЗначениеЗаполнено(Строка3) Тогда
		Массив.Добавить(Строка3);
	КонецЕсли;
	Если ЗначениеЗаполнено(Строка4) Тогда
		Массив.Добавить(Строка4);
	КонецЕсли;
	Возврат СтрСоединить(Массив, Разделитель);
КонецФункции

// Возвращает левую часть строки до указанного разделителя. Если разделитель не найден - возвращается вся строка.
Функция СтрЛев(Знач Строка, Знач Разделитель, СтрокаПослеРазделителя = Неопределено) Экспорт
	Позиция = Найти(Строка, Разделитель);
	Если Позиция = 0 Тогда
		СтрокаДоРазделителя = Строка;
		СтрокаПослеРазделителя = "";
	Иначе
		СтрокаДоРазделителя = Лев(Строка, Позиция - 1);
		СтрокаПослеРазделителя = Сред(Строка, Позиция + СтрДлина(Разделитель));
	КонецЕсли;
	Возврат СтрокаДоРазделителя;
КонецФункции

// Возвращает правую часть строки после указанного разделителя. Если разделитель не найден - возвращается вся строка.
Функция СтрПрав(Знач Строка, Знач Разделитель, СтрокаДоРазделителя = Неопределено) Экспорт
	Позиция = СтрНайти(Строка, Разделитель, НаправлениеПоиска.СКонца);
	Если Позиция = 0 Тогда
		СтрокаДоРазделителя = "";
		СтрокаПослеРазделителя = Строка;
	Иначе
		СтрокаДоРазделителя = Лев(Строка, Позиция - 1);
		СтрокаПослеРазделителя = Сред(Строка, Позиция + СтрДлина(Разделитель));
	КонецЕсли;
	Возврат СтрокаПослеРазделителя;
КонецФункции

// Возвращает строку без символов переноса, пробелов и табуляции.
Функция УбратьПробелы(Строка, УбратьТире = Истина) Экспорт
	ПробелыИПереносыСтрок = ПробелыИПереносыСтрок();
	Если УбратьТире Тогда
		ПробелыИПереносыСтрок = ПробелыИПереносыСтрок + "-";
	КонецЕсли;
	Возврат СтрСоединить(СтрРазделить(СокрЛП(Строка), ПробелыИПереносыСтрок, Ложь), "");
КонецФункции

// Возвращает строку с символами пробелов, переносов строк и табуляции.
Функция ПробелыИПереносыСтрок() Экспорт
	Возврат " " + Символы.ВК + Символы.ВТаб + Символы.НПП + Символы.ПС + Символы.ПФ + Символы.Таб;
КонецФункции

#КонецОбласти
