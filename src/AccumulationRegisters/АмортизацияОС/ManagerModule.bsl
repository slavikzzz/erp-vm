#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Заполняет параметры отражения движений регистра в финансовом учете
//
// Параметры:
//  МетаданныеРегистра - ОбъектМетаданныхРегистрНакопления - Метаданные регистра накопления
//  РегистрацияКОтражению - Булево - Признак получения параметров для регистрации к отражению в учете
//
// Возвращаемое значение:
// 	см. ФинансовыйУчетПоДаннымБалансовыхРегистров.ПараметрыОтраженияДвиженийВФинансовомУчете
//
Функция ПараметрыОтраженияДвиженийВФинансовомУчете(МетаданныеРегистра = Неопределено, РегистрацияКОтражению = Ложь) Экспорт
	
	ПараметрыОтражения = ФинансовыйУчетПоДаннымБалансовыхРегистров.ПараметрыОтраженияДвиженийВФинансовомУчете(РегистрацияКОтражению);
	
	Если РегистрацияКОтражению Тогда
		Возврат ПараметрыОтражения;
	КонецЕсли;
	
	ПараметрыОтражения.ПутьКДаннымНаправлениеДеятельности = "НаправлениеДеятельности";
	ПараметрыОтражения.ПутьКДаннымПодразделение = "Подразделение";
	//++ НЕ УТКА
	ПараметрыОтражения.ПутьКДаннымОбъектНастройки = "ГруппаФинансовогоУчета";
	ПараметрыОтражения.ПутьКДаннымМестоУчета = "Подразделение";
	//-- НЕ УТКА
	ПараметрыОтражения.РесурсыУпр.Добавить("Амортизация");
	ПараметрыОтражения.РесурсыРегл.Добавить("АмортизацияРегл");
	ПараметрыОтражения.РесурсыРегл.Добавить("АмортизацияЦФ");
	ПараметрыОтражения.ТипДанныхУчета = Перечисления.ТипыДанныхУчета.ПрочиеАктивыПассивы;
	ПараметрыОтражения.СтруктураАналитики = ОбщегоНазначения.СкопироватьРекурсивно(ИсточникиДанныхПовтИсп.СтруктураАналитикиПоТипуДанныхУчета(ПараметрыОтражения.ТипДанныхУчета));
	ПараметрыОтражения.СтруктураАналитики.СтатьяАктивовПассивов.Вставить("Значение", ПланыВидовХарактеристик.СтатьиАктивовПассивов.ОсновныеСредства);
	ПараметрыОтражения.СтруктураАналитики.АналитикаАктивовПассивов.ПутьКДанным = "ОсновноеСредство";
	ПараметрыОтражения.СтруктураАналитики.Контрагент.Вставить("Значение", Неопределено);
	
	Если МетаданныеРегистра = Неопределено Тогда
		МетаданныеРегистра = СоздатьНаборЗаписей().Метаданные();
	КонецЕсли;
	
	ФинансовыйУчетПоДаннымБалансовыхРегистров.ЗаполнитьПараметрыОтраженияПоМетаданнымРегистра(ПараметрыОтражения, МетаданныеРегистра);
	
	Возврат ПараметрыОтражения;
	
КонецФункции

//++ НЕ УТКА

// Определяет источники уточнения счета, доступные в регистре и их свойства.
//
//
// Параметры:
//  СвойстваИсточника - Строка - "ИмяПоля" - имя атрибута регистра накопления, из которого планируется получать источник
//                               уточнения счета.
//
// Возвращаемое значение:
//  Соответствие - Ключ - название источника уточнения счета. 
//                 Значение - структура свойств источника уточнения счета.
//
Функция ИсточникиУточненияСчета(СвойстваИсточника) Экспорт
	
	Возврат ВнеоборотныеАктивыСлужебный.ИсточникиУточненияСчетаАмортизация(СвойстваИсточника);
	
КонецФункции

// Определяет источники подразделений регистра и их свойства.
//
//
// Возвращаемое значение:
//  Соответствие - Ключ - имя источника. 
//                 Значение - структура свойств источника. 
//
Функция ИсточникиПодразделений() Экспорт

	Возврат ВнеоборотныеАктивыСлужебный.ИсточникиПодразделенийАмортизация();

КонецФункции

// Определяет источники направлений регистра и их свойства.
//
//
// Возвращаемое значение:
//  Соответствие - Ключ - имя источника. 
//                 Значение - структура свойств источника. 
//
Функция ИсточникиНаправлений() Экспорт

	Возврат ВнеоборотныеАктивыСлужебный.ИсточникиНаправлений();

КонецФункции

// Определяет источники заполнения субконто.
//
//
// Возвращаемое значение:
//  Массив - массив атрибутов регистра.
//
Функция ИсточникиСубконто() Экспорт

	МассивСубконто = Новый Массив;
	МассивСубконто.Добавить("ОсновноеСредство");
	МассивСубконто.Добавить("СтатьяРасходов");

	Возврат Новый Структура("СубконтоДт, СубконтоКт", МассивСубконто, МассивСубконто);

КонецФункции

// Определяет показатели в валюте регистра.
//
//
// Параметры:
//  СвойстваПоказателей - Строка - "ИсточникВалюты" - источник валюты для показателя регистра.
//
// Возвращаемое значение:
//  Соответствие - Ключ - имя показателя.
//                 Значение - структура свойств показателя.
//
Функция ПоказателиВВалюте(СвойстваПоказателей) Экспорт

	ПоказателиВВалюте = Новый Соответствие;
	Возврат ПоказателиВВалюте;

КонецФункции

// Определяет показатели в валюте регистра.
//
//
// Возвращаемое значение:
//  Соответствие - Ключ - имя показателя.
//                 Значение - структура свойств показателя.
//
Функция ПоказателиКоличества() Экспорт

	ПоказателиКоличества = Новый Соответствие;
	Возврат ПоказателиКоличества;

КонецФункции

//-- НЕ УТКА

// Определяет показатели регистра.
//
//
// Параметры:
//  Свойства - Структура - содержащая ключи СвойстваПоказателей, СвойстваРесурсов.
//
// Возвращаемое значение:
//  Соответствие - Ключ - имя показателя.
//                 Значение - структура свойств показателя.
//
Функция Показатели(Свойства) Экспорт

	Показатели = Новый Соответствие;
	
	СвойстваПоказателей = Свойства.СвойстваПоказателей;
	СвойстваРесурсов = Свойства.СвойстваРесурсов;
	
	МассивРесурсов = Новый Массив;
	МассивРесурсов.Добавить(Новый Структура(СвойстваРесурсов, "Амортизация", "ВалютаУпр"));
	МассивРесурсов.Добавить(Новый Структура(СвойстваРесурсов, "АмортизацияРегл", "ВалютаРегл"));//АмортизацияРегл = АмортизацияРегл + АмортизацияЦФ
	Показатели.Вставить(Перечисления.ПоказателиАналитическихРегистров.Сумма, Новый Структура(СвойстваПоказателей, МассивРесурсов));
	
	Возврат Показатели;
	
КонецФункции

// Собирает структуру из текстов запросов для дальнейшей проверки даты запрета.
// 
// Параметры:
// 	Запрос - Запрос - Запрос по проверке даты запрета, можно установить параметры
// Возвращаемое значение:
// 	Структура - см. ЗакрытиеМесяцаСервер.ИнициализироватьСтруктуруТекстовЗапросов
Функция ТекстЗапросаКонтрольДатыЗапрета(Запрос) Экспорт
	ИмяРегистра = Метаданные.РегистрыНакопления.АмортизацияОС.Имя;
	ИмяТаблицыИзменений = "АмортизацияОСИзменение"; 
	СтруктураТекстовЗапросов = ПроведениеДокументов.ШаблонТекстЗапросаКонтрольДатыЗапрета(Запрос, 
		ИмяРегистра, 
		ИмяТаблицыИзменений, 
		"ФинансовыйКонтур");
	Возврат СтруктураТекстовЗапросов

КонецФункции

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// Параметры:
//   Ограничение - см. УправлениеДоступомПереопределяемый.ПриЗаполненииОграниченияДоступа.Ограничение.
//
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#КонецЕсли
