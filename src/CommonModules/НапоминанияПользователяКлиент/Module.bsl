///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Запускает периодическую проверку текущих напоминаний пользователя.
Процедура Включить() Экспорт
	ПроверитьТекущиеНапоминания();
КонецПроцедуры

// Отключает периодическую проверку текущих напоминаний пользователя.
Процедура Выключить() Экспорт
	ОтключитьОбработчикОжидания("ПроверитьТекущиеНапоминания");
КонецПроцедуры

// Создает новое напоминание на указанное время.
//
// Параметры:
//  Текст - Строка - текст напоминания;
//  Время - Дата - дата и время напоминания;
//  Предмет - ЛюбаяСсылка - предмет напоминания;
//  Идентификатор - Строка - уточняет предмет напоминания, например, "ДеньРождения".
//
Процедура НапомнитьВУказанноеВремя(Текст, Время, Предмет = Неопределено, Идентификатор = Неопределено) Экспорт
	
	Напоминание = НапоминанияПользователяВызовСервера.ПодключитьНапоминание(
		Текст, Время, , Предмет, Идентификатор);
		
	ПоказатьОповещениеПользователя(НСтр("ru = 'Напоминание записано';
										|en = 'Reminder saved'"),,
		Напоминание.Описание, БиблиотекаКартинок.Напоминание,
		СтатусОповещенияПользователя.Информация, Идентификатор);
		
	ОбновитьЗаписьВКэшеОповещений(Напоминание);
	СброситьТаймерПроверкиТекущихОповещений();
	
КонецПроцедуры

// Создает новое напоминание на время, рассчитанное относительно времени в предмете.
//
// Параметры:
//  Текст - Строка - текст напоминания;
//  Интервал - Число - время в секундах, за которое необходимо напомнить относительно даты в реквизите предмета;
//  Предмет - ЛюбаяСсылка - предмет напоминания;
//  ИмяРеквизита - Строка - имя реквизита предмета, относительно которого устанавливается срок напоминания.
//
Процедура НапомнитьДоВремениПредмета(Текст, Интервал, Предмет, ИмяРеквизита) Экспорт
	
	Напоминание = НапоминанияПользователяВызовСервера.ПодключитьНапоминаниеДоВремениПредмета(
		Текст, Интервал, Предмет, ИмяРеквизита, Ложь);
		
	ОбновитьЗаписьВКэшеОповещений(Напоминание);
	СброситьТаймерПроверкиТекущихОповещений();
	
КонецПроцедуры

// Создает напоминание с произвольным временем или расписанием выполнения.
//
// Параметры:
//  Текст - Строка - текст напоминания;
//  ВремяСобытия - Дата - дата и время события, о котором надо напомнить;
//               - РасписаниеРегламентногоЗадания - расписание периодического события;
//               - Строка - имя реквизита предмета напоминания, в котором содержится время наступления события.
//  ИнтервалДоСобытия - Число - время в секундах, за которое необходимо напомнить относительно времени события;
//  Предмет - ЛюбаяСсылка - предмет напоминания;
//  Идентификатор - Строка - уточняет предмет напоминания, например, "ДеньРождения".
//
Процедура Напомнить(Текст, ВремяСобытия, ИнтервалДоСобытия = 0, Предмет = Неопределено, Идентификатор = Неопределено) Экспорт
	
	Напоминание = НапоминанияПользователяВызовСервера.ПодключитьНапоминание(
		Текст, ВремяСобытия, ИнтервалДоСобытия, Предмет, Идентификатор);
		
	ОбновитьЗаписьВКэшеОповещений(Напоминание);
	СброситьТаймерПроверкиТекущихОповещений();
	
КонецПроцедуры

// Создает ежегодное напоминание на дату предмета.
//
// Параметры:
//  Текст - Строка - текст напоминания;
//  Интервал - Число - время в секундах, за которое необходимо напомнить относительно даты в реквизите предмета;
//  Предмет - ЛюбаяСсылка - предмет напоминания;
//  ИмяРеквизита - Строка - имя реквизита предмета, относительно которого устанавливается срок напоминания.
//
Процедура НапомнитьОЕжегодномСобытииПредмета(Текст, Интервал, Предмет, ИмяРеквизита) Экспорт
	
	Напоминание = НапоминанияПользователяВызовСервера.ПодключитьНапоминаниеДоВремениПредмета(
		Текст, Интервал, Предмет, ИмяРеквизита, Истина);
		
	ОбновитьЗаписьВКэшеОповещений(Напоминание);
	СброситьТаймерПроверкиТекущихОповещений();
	
КонецПроцедуры

// Обработчик одноименного события формы.
//
// Параметры:
//   Элемент - ПолеФормы - форма, в которой размещены элементы настройки напоминания.
//   Форма - ФормаКлиентскогоПриложения - форма, в которой размещены элементы настройки напоминания.
//	
Процедура ПриИзмененииНастройкиНапоминания(Элемент, Форма) Экспорт
	
	ИмяПоляИнтервалВремениНапоминания = НапоминанияПользователяКлиентСервер.ИмяПоляИнтервалВремениНапоминания();
	
	Если Элемент.Имя = ИмяПоляИнтервалВремениНапоминания Тогда
		НастройкиНапоминания = НастройкиНапоминанияВФорме(Форма);
		Если Форма[Элемент.Имя] = НапоминанияПользователяКлиентСервер.ПредставлениеПеречисленияНеНапоминать() Тогда
			Напоминать = Ложь;
		Иначе
			ИнтервалВремениНапоминания = ПолучитьИнтервалВремениИзСтроки(Форма[Элемент.Имя]);
			Если Форма[Элемент.Имя] <> НапоминанияПользователяКлиентСервер.ПредставлениеПеречисленияПриНаступлении() Тогда
				Форма[Элемент.Имя] = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'за %1';
						|en = '%1 before'"), ПредставлениеВремени(ИнтервалВремениНапоминания, , ИнтервалВремениНапоминания <> 0));
			КонецЕсли;
			НастройкиНапоминания.ИнтервалВремениНапоминания = ИнтервалВремениНапоминания;
			Напоминать = Истина;
		КонецЕсли;
		Форма[НапоминанияПользователяКлиентСервер.ИмяПоляНапоминатьОСобытии()] = Напоминать;
	КонецЕсли;
	
КонецПроцедуры

// Обработчик одноименного события формы.
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - форма, в которой размещены элементы настройки напоминания.
//   ИмяСобытия  - Строка
//   Параметр    - см. НапоминанияПользователяКлиентСервер.ОписаниеНапоминания
//   Источник    - ФормаКлиентскогоПриложения
//               - Произвольный - источник события.
//	
Процедура ОбработкаОповещения(Форма, ИмяСобытия, Параметр, Источник) Экспорт
	
	Если ИмяСобытия = "Запись_НапоминанияПользователя" Тогда
		НастройкиНапоминания = НастройкиНапоминанияВФорме(Форма);

		Если ЗначениеЗаполнено(Параметр) 
			И Параметр.Источник = НастройкиНапоминания.Предмет
			И Параметр.ИмяРеквизитаИсточника = НастройкиНапоминания.ИмяРеквизитаСДатойСобытия Тогда
				
			ИмяПоляИнтервалВремениНапоминания = НапоминанияПользователяКлиентСервер.ИмяПоляИнтервалВремениНапоминания();
			ИнтервалВремениНапоминания = Параметр.ИнтервалВремениНапоминания;
			Если ИнтервалВремениНапоминания > НастройкиНапоминания.ИнтервалВремениНапоминания Тогда
				НастройкиНапоминания.ИнтервалВремениНапоминания = ИнтервалВремениНапоминания;
				Форма[ИмяПоляИнтервалВремениНапоминания] = НапоминанияПользователяКлиентСервер.ПредставлениеСрокаНапоминания(Параметр);
				Форма[НапоминанияПользователяКлиентСервер.ИмяПоляНапоминатьОСобытии()] = Истина;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Открывает форму настроек напоминаний.
Процедура ОткрытьНастройки() Экспорт
	ОткрытьФорму("РегистрСведений.НапоминанияПользователя.Форма.Настройки");
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий подсистем конфигурации.

// См. ОбщегоНазначенияКлиентПереопределяемый.ПослеНачалаРаботыСистемы.
Процедура ПослеНачалаРаботыСистемы() Экспорт
	
	Если Не ОбщегоНазначенияКлиент.ДоступноИспользованиеРазделенныхДанных() Тогда
		Возврат;
	КонецЕсли;
	
	НастройкиНапоминаний = СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиентаПриЗапуске().НастройкиНапоминаний;
	Если НастройкиНапоминаний.ИспользоватьНапоминания Тогда
		НастройкиНаКлиенте().СписокТекущихНапоминаний = НастройкиНапоминаний.СписокТекущихНапоминаний;
		ПодключитьОбработчикОжидания("ПроверитьТекущиеНапоминания", 60, Истина); // Через 60 секунд после запуска клиента.
	КонецЕсли;
	
КонецПроцедуры

// См. СтандартныеПодсистемыКлиент.ПриПолученииСерверногоОповещения.
Процедура ПриПолученииСерверногоОповещения(ИмяОповещения, Результат) Экспорт
	
	Если ИмяОповещения <> НапоминанияПользователяКлиентСервер.ИмяСерверногоОповещения() Тогда
		Возврат;
	КонецЕсли;
	
	Результат = Результат; // см. НапоминанияПользователяСлужебный.НовыеИзмененныеНапоминания
	
	Для Каждого Напоминание Из Результат.Удаленные Цикл
		УдалитьЗаписьИзКэшаОповещений(Напоминание);
	КонецЦикла;
	
	Для Каждого Напоминание Из Результат.Добавленные Цикл
		ОбновитьЗаписьВКэшеОповещений(Напоминание);
	КонецЦикла;
	
	СброситьТаймерПроверкиТекущихОповещений();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Возвращаемое значение:
//  Структура:
//   * СписокТекущихНапоминаний - см. НапоминанияПользователяСлужебный.СписокТекущихНапоминанийПользователя
//
Функция НастройкиНаКлиенте()
	
	ИмяПараметра = "СтандартныеПодсистемы.НапоминанияПользователя";
	Настройки = ПараметрыПриложения[ИмяПараметра];
	
	Если Настройки = Неопределено Тогда
		Настройки = Новый Структура;
		Настройки.Вставить("СписокТекущихНапоминаний", Новый Массив);
		ПараметрыПриложения[ИмяПараметра] = Настройки;
	КонецЕсли;
	
	Возврат Настройки;
	
КонецФункции

Процедура СброситьТаймерПроверкиТекущихОповещений() Экспорт
	ОтключитьОбработчикОжидания("ПроверитьТекущиеНапоминания");
	ПодключитьОбработчикОжидания("ПроверитьТекущиеНапоминания", 0.1, Истина);
КонецПроцедуры

Процедура ОткрытьФормуОповещения() Экспорт
	
	// Хранение формы в переменной требуется для предотвращения открытия дублей формы,
	// а также для уменьшения количества серверных вызовов.
	ИмяПараметра = "СтандартныеПодсистемы.ФормаОповещения";
	Если ПараметрыПриложения[ИмяПараметра] = Неопределено Тогда
		ИмяФормыОповещения = "РегистрСведений.НапоминанияПользователя.Форма.ФормаОповещения";
		ПараметрыПриложения.Вставить(ИмяПараметра, ПолучитьФорму(ИмяФормыОповещения));
	КонецЕсли;
	ФормаОповещения = ПараметрыПриложения[ИмяПараметра];
	ФормаОповещения.Открыть();

КонецПроцедуры

// Возвращает кэшированные оповещения текущего пользователя, исключив из результата ненаступившие оповещения.
//
// Параметры:
//  ВремяБлижайшего - Дата - в этот параметр возвращается время ближайшего будущего напоминания. Если
//                           ближайшее напоминание за пределами выборки кэша, то возвращается Неопределено.
//
// Возвращаемое значение: 
//   см. НапоминанияПользователяСлужебный.СписокТекущихНапоминанийПользователя
//
Функция ПолучитьТекущиеОповещения(ВремяБлижайшего = Неопределено) Экспорт
	
	ТаблицаОповещений = НастройкиНаКлиенте().СписокТекущихНапоминаний;
	Результат = Новый Массив;
	
	ВремяБлижайшего = Неопределено;
	
	Для Каждого Оповещение Из ТаблицаОповещений Цикл
		Если Оповещение.СрокНапоминания <= ОбщегоНазначенияКлиент.ДатаСеанса() Тогда
			Результат.Добавить(Оповещение);
		Иначе                                                           
			Если ВремяБлижайшего = Неопределено Тогда
				ВремяБлижайшего = Оповещение.СрокНапоминания;
			Иначе
				ВремяБлижайшего = Мин(ВремяБлижайшего, Оповещение.СрокНапоминания);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;		
	
	Возврат Результат;
	
КонецФункции

// Обновляет запись в кэше напоминаний текущего пользователя.
Процедура ОбновитьЗаписьВКэшеОповещений(ПараметрыОповещения) Экспорт
	КэшОповещений = НастройкиНаКлиенте().СписокТекущихНапоминаний;
	Запись = НайтиЗаписьВКэшеОповещений(КэшОповещений, ПараметрыОповещения);
	Если Запись <> Неопределено Тогда
		ЗаполнитьЗначенияСвойств(Запись, ПараметрыОповещения);
	Иначе
		КэшОповещений.Добавить(ПараметрыОповещения);
	КонецЕсли;
КонецПроцедуры

// Удаляет запись из кэша напоминаний текущего пользователя.
Процедура УдалитьЗаписьИзКэшаОповещений(ПараметрыОповещения) Экспорт
	КэшОповещений = НастройкиНаКлиенте().СписокТекущихНапоминаний;
	Запись = НайтиЗаписьВКэшеОповещений(КэшОповещений, ПараметрыОповещения);
	Если Запись <> Неопределено Тогда
		КэшОповещений.Удалить(КэшОповещений.Найти(Запись));
	КонецЕсли;
КонецПроцедуры

// Возвращает запись из кэша напоминаний текущего пользователя.
//
// Параметры:
//  КэшОповещений - см. НапоминанияПользователяСлужебный.СписокТекущихНапоминанийПользователя
//  ПараметрыОповещения - Структура:
//   * Источник - ОпределяемыйТип.ПредметНапоминания
//   * ВремяСобытия - Дата
//
Функция НайтиЗаписьВКэшеОповещений(КэшОповещений, ПараметрыОповещения)
	Для Каждого Запись Из КэшОповещений Цикл
		Если Запись.Источник = ПараметрыОповещения.Источник
		   И Запись.ВремяСобытия = ПараметрыОповещения.ВремяСобытия Тогда
			Возврат Запись;
		КонецЕсли;
	КонецЦикла;
	Возврат Неопределено;
КонецФункции

// Получает из строки интервал времени и возвращает его текстовое представление.
//
// Параметры:
//  ВремяСтрокой - Строка - текстовое описание времени, где числа записаны цифрами,
//							а единицы измерения - строкой.
//
// Возвращаемое значение:
//  Строка - оформленное представление времени.
//
Функция ОформитьВремя(ВремяСтрокой) Экспорт
	Возврат ПредставлениеВремени(ПолучитьИнтервалВремениИзСтроки(ВремяСтрокой));
КонецФункции

// См. НапоминанияПользователяКлиентСервер.ПредставлениеВремени
Функция ПредставлениеВремени(Знач Время, ПолноеПредставление = Истина, ВыводитьСекунды = Истина) Экспорт
	
	Возврат НапоминанияПользователяКлиентСервер.ПредставлениеВремени(Время, ПолноеПредставление, ВыводитьСекунды);
	
КонецФункции

// См. НапоминанияПользователяКлиентСервер.ИнтервалВремениИзСтроки
Функция ПолучитьИнтервалВремениИзСтроки(Знач СтрокаСоВременем) Экспорт
	
	Возврат НапоминанияПользователяКлиентСервер.ИнтервалВремениИзСтроки(СтрокаСоВременем);
	
КонецФункции

Функция НастройкиНапоминанияВФорме(Форма)
	
	Возврат НапоминанияПользователяКлиентСервер.НастройкиНапоминанияВФорме(Форма);
	
КонецФункции

#КонецОбласти
