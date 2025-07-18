////////////////////////////////////////////////////////////////////////////////
// Подсистема "Базовая функциональность в модели сервиса".
// Серверные процедуры и функции общего назначения:
// - Поддержка профилей безопасности.
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Заполняет структуру массивами поддерживаемых версий всех подлежащих версионированию подсистем,
// используя в качестве ключей названия подсистем.
// Обеспечивает функциональность Web-сервиса InterfaceVersion.
// При внедрении надо поменять тело процедуры так, чтобы она возвращала актуальные наборы версий (см. пример.ниже).
//
// Параметры:
// СтруктураПоддерживаемыхВерсий - Структура - где:
//  Ключи - названия подсистем, 
//  Значения - массивы названий поддерживаемых версий.
//
// Пример:
//
//	// СервисПередачиФайлов
//	МассивВерсий = Новый Массив;
//	МассивВерсий.Добавить("1.0.1.1");	
//	МассивВерсий.Добавить("1.0.2.1"); 
//	СтруктураПоддерживаемыхВерсий.Вставить("СервисПередачиФайлов", МассивВерсий);
//	// Конец СервисПередачиФайлов
//
Процедура ПриОпределенииПоддерживаемыхВерсийПрограммныхИнтерфейсов(Знач СтруктураПоддерживаемыхВерсий) Экспорт
	
	Если РаботаВБезопасномРежимеСлужебный.ВозможноИспользованиеПрофилейБезопасности() Тогда
		МассивВерсий = Новый Массив;
		МассивВерсий.Добавить("1.0.0.2");
		СтруктураПоддерживаемыхВерсий.Вставить("SecurityProfileCompatibilityMode", МассивВерсий);
	КонецЕсли;
	
КонецПроцедуры

// Вызывается при проверке возможности настройки профилей безопасности
//
// Параметры:
//  Отказ - Булево - Если для информационной базы недоступно использование профилей безопасности -
//    значение данного параметра нужно установить равным Истина.
//
Процедура ПриПроверкеВозможностиНастройкиПрофилейБезопасности(Отказ) Экспорт
	
	Если ОбщегоНазначения.РазделениеВключено() Тогда
		
		// В модели сервиса управление настройкой профилей безопасности выполняется централизованно
		// из менеджера сервиса.
		Отказ = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

// Вызывается при создании запроса разрешений на использование внешних ресурсов.
//
// Параметры:
//  ПрограммныйМодуль - ЛюбаяСсылка - ссылка на объект информационной базы, представляющий программный
//    модуль, для которого выполняется запрос разрешений,
//  Владелец - ЛюбаяСсылка - ссылка на объект информационной базы, представляющий объект-владелец запрашиваемых
//    разрешений на использование внешних ресурсов,
//  РежимЗамещения - Булево - флаг замещения ранее предоставленных разрешений по владельцу,
//  ДобавляемыеРазрешения - Массив Из ОбъектXDTO - массив добавляемых разрешений,
//  УдаляемыеРазрешения - Массив Из ОбъектXDTO - массив удаляемых разрешений,
//  СтандартнаяОбработка - Булево - флаг выполнения стандартной обработки создания запроса на использование
//    внешних ресурсов.
//  Результат - УникальныйИдентификатор - идентификатор запроса (в том случае, если внутри обработчика
//    значение параметра СтандартнаяОбработка установлено в значение Ложь).
//
Процедура ПриЗапросеРазрешенийНаИспользованиеВнешнихРесурсов(Знач ПрограммныйМодуль, Знач Владелец, Знач РежимЗамещения, 
	Знач ДобавляемыеРазрешения, Знач УдаляемыеРазрешения, СтандартнаяОбработка, Результат) Экспорт
	
	Если ОбщегоНазначения.РазделениеВключено() Тогда
		
		СтандартнаяОбработка = Ложь;
		
		Если ПрограммныйМодуль = Неопределено Тогда
			ПрограммныйМодуль = Справочники.ИдентификаторыОбъектовМетаданных.ПустаяСсылка();
		КонецЕсли;
		
		Если Владелец = Неопределено Тогда
			Владелец = ПрограммныйМодуль;
		КонецЕсли;
		
		Если ПолучитьФункциональнуюОпцию("ИспользуютсяПрофилиБезопасности") Тогда
			
			Если ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных() Тогда
				
				РегистрЗапросов = РегистрыСведений.ЗапросыРазрешенийНаИспользованиеВнешнихРесурсовОбластейДанных;
				
			Иначе
				
				РегистрЗапросов = РегистрыСведений.ЗапросыРазрешенийНаИспользованиеВнешнихРесурсовВМоделиСервиса;
				
			КонецЕсли;
			
			ЗапросРазрешений = РегистрЗапросов.СоздатьМенеджерЗаписи();
			
			ЗапросРазрешений.ИдентификаторЗапроса = Новый УникальныйИдентификатор;
			
			Если РаботаВБезопасномРежиме.УстановленБезопасныйРежим() Тогда
				ЗапросРазрешений.БезопасныйРежим = БезопасныйРежим();
			Иначе
				ЗапросРазрешений.БезопасныйРежим = Ложь;
			КонецЕсли;
			
			КлючПрограммногоМодуля = КлючРегистраПоСсылке(ПрограммныйМодуль);
			ЗапросРазрешений.ТипПрограммногоМодуля = КлючПрограммногоМодуля.Тип;
			ЗапросРазрешений.ИдентификаторПрограммногоМодуля = КлючПрограммногоМодуля.Идентификатор;
			
			КлючВладельца = КлючРегистраПоСсылке(Владелец);
			ЗапросРазрешений.ТипВладельца = КлючВладельца.Тип;
			ЗапросРазрешений.ИдентификаторВладельца = КлючВладельца.Идентификатор;
			
			ЗапросРазрешений.РежимЗамещения = РежимЗамещения;
			
			Если ДобавляемыеРазрешения <> Неопределено Тогда
				
				МассивРазрешений = Новый Массив();
				Для Каждого НовоеРазрешение Из ДобавляемыеРазрешения Цикл
					МассивРазрешений.Добавить(ОбщегоНазначения.ОбъектXDTOВСтрокуXML(НовоеРазрешение));
				КонецЦикла;
				
				Если МассивРазрешений.Количество() > 0 Тогда
					ЗапросРазрешений.ДобавляемыеРазрешения = ОбщегоНазначения.ЗначениеВСтрокуXML(МассивРазрешений);
				КонецЕсли;
				
			КонецЕсли;
			
			Если УдаляемыеРазрешения <> Неопределено Тогда
				
				МассивРазрешений = Новый Массив();
				Для Каждого ОтменяемоеРазрешение Из УдаляемыеРазрешения Цикл
					МассивРазрешений.Добавить(ОбщегоНазначения.ОбъектXDTOВСтрокуXML(ОтменяемоеРазрешение));
				КонецЦикла;
				
				Если МассивРазрешений.Количество() > 0 Тогда
					ЗапросРазрешений.УдаляемыеРазрешения = ОбщегоНазначения.ЗначениеВСтрокуXML(МассивРазрешений);
				КонецЕсли;
				
			КонецЕсли;
			
			ЗапросРазрешений.Записать();
			
			Результат = ЗапросРазрешений.ИдентификаторЗапроса;
			
		Иначе
			
			Результат = Новый УникальныйИдентификатор();
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Вызывается при запросе создания профиля безопасности.
//
// Параметры:
//  ПрограммныйМодуль - ЛюбаяСсылка - ссылка на объект информационной базы, представляющий программный
//    модуль, для которого выполняется запрос разрешений,
//  СтандартнаяОбработка - Булево - флаг выполнения стандартной обработки,
//  Результат - УникальныйИдентификатор - идентификатор запроса (в том случае, если внутри обработчика
//    значение параметра СтандартнаяОбработка установлено в значение Ложь).
//
Процедура ПриЗапросеСозданияПрофиляБезопасности(Знач ПрограммныйМодуль, СтандартнаяОбработка, Результат) Экспорт
	
	ПриЗапросеИзмененияПрофилейБезопасности(ПрограммныйМодуль, СтандартнаяОбработка, Результат);
	
КонецПроцедуры

// Вызывается при запросе создания профиля безопасности.
//
// Параметры:
//  ПрограммныйМодуль - ЛюбаяСсылка - ссылка на объект информационной базы, представляющий программный
//    модуль, для которого выполняется запрос разрешений,
//  СтандартнаяОбработка - Булево - флаг выполнения стандартной обработки,
//  Результат - УникальныйИдентификатор - идентификатор запроса (в том случае, если внутри обработчика
//    значение параметра СтандартнаяОбработка установлено в значение Ложь).
//
Процедура ПриЗапросеУдаленияПрофиляБезопасности(Знач ПрограммныйМодуль, СтандартнаяОбработка, Результат) Экспорт
	
	ПриЗапросеИзмененияПрофилейБезопасности(ПрограммныйМодуль, СтандартнаяОбработка, Результат);
	
КонецПроцедуры

// Вызывается при подключении внешнего модуля. В теле процедуры-обработчика может быть изменен
// безопасный режим, в котором будет выполняться подключение.
//
// Параметры:
//  ВнешнийМодуль - ЛюбаяСсылка - ссылка на объект информационной базы, представляющий подключаемый
//    внешний модуль,
//  БезопасныйРежим - ОпределяемыйТип.БезопасныйРежим - безопасный режим, в котором внешний
//    модуль будет подключен к информационной базе. Может быть изменен внутри данной процедуры.
//
Процедура ПриПодключенииВнешнегоМодуля(Знач ВнешнийМодуль, БезопасныйРежим) Экспорт
	
	Если ОбщегоНазначения.РазделениеВключено() Тогда
		
		БезопасныйРежим = РаботаВБезопасномРежимеВМоделиСервиса.РежимИсполненияВнешнегоМодуля(ВнешнийМодуль);
		
	КонецЕсли;
	
КонецПроцедуры

// Формирует список параметров ИБ.
//
// Параметры:
// ТаблицаПараметров - ТаблицаЗначений - таблица описания параметров.
// Описание состав колонок - см. РаботаВМоделиСервиса.ПолучитьТаблицуПараметровИБ().
//
Процедура ПриЗаполненииТаблицыПараметровИБ(Знач ТаблицаПараметров) Экспорт
	
	РаботаВМоделиСервиса.ДобавитьКонстантуВТаблицуПараметровИБ(ТаблицаПараметров, "ИспользуютсяПрофилиБезопасности");
	РаботаВМоделиСервиса.ДобавитьКонстантуВТаблицуПараметровИБ(ТаблицаПараметров, 
		"ПрофильБезопасностиИнформационнойБазы");
	РаботаВМоделиСервиса.ДобавитьКонстантуВТаблицуПараметровИБ(ТаблицаПараметров, 
		"АвтоматическиНастраиватьРазрешенияВПрофиляхБезопасности");
	
КонецПроцедуры

// Заполняет переданный массив общими модулями, которые являются обработчиками интерфейсов
//  принимаемых сообщений.
//
// Параметры:
//  МассивОбработчиков - Массив - обработчики.
//
Процедура РегистрацияИнтерфейсовПринимаемыхСообщений(МассивОбработчиков) Экспорт
	
	МассивОбработчиков.Добавить(СообщенияКонтрольУправленияРазрешениямиИнтерфейс);
	
КонецПроцедуры

// См. ВыгрузкаЗагрузкаДанныхПереопределяемый.ПриЗаполненииТиповИсключаемыхИзВыгрузкиЗагрузки.
// 
// Параметры:
// 	Типы - См. ВыгрузкаЗагрузкаДанныхПереопределяемый.ПриЗаполненииТиповИсключаемыхИзВыгрузкиЗагрузки.Типы
// 
Процедура ПриЗаполненииТиповИсключаемыхИзВыгрузкиЗагрузки(Типы) Экспорт
	
	Типы.Добавить(Метаданные.Константы.ВнешнийАдресУправляющегоПриложения);
	
	Типы.Добавить(Метаданные.РегистрыСведений.ЗапросыРазрешенийНаИспользованиеВнешнихРесурсовВМоделиСервиса);
	Типы.Добавить(Метаданные.РегистрыСведений.ЗапросыРазрешенийНаИспользованиеВнешнихРесурсовОбластейДанных);
	
	Типы.Добавить(Метаданные.РегистрыСведений.РазрешенияНаИспользованиеВнешнихРесурсовВМоделиСервиса);
	Типы.Добавить(Метаданные.РегистрыСведений.РазрешенияНаИспользованиеВнешнихРесурсовОбластейДанных);
	
	Типы.Добавить(Метаданные.РегистрыСведений.РежимыПодключенияВнешнихМодулейВМоделиСервиса);
	Типы.Добавить(Метаданные.РегистрыСведений.РежимыПодключенияВнешнихМодулейОбластейДанных);
	
	Типы.Добавить(Метаданные.РегистрыСведений.ПрименениеРазрешенийНаИспользованиеВнешнихРесурсовВМоделиСервиса);
	Типы.Добавить(Метаданные.РегистрыСведений.ПрименениеРазрешенийНаИспользованиеВнешнихРесурсовОбластейДанных);
	
КонецПроцедуры

// Параметры:
// 	Ссылка - СправочникСсылка.ИдентификаторыОбъектовМетаданных - 
// 	
// Возвращаемое значение:
// 	Структура - Описание:
// * Тип - СправочникСсылка.ИдентификаторыОбъектовМетаданных - ИОМ 
// * Идентификатор - УникальныйИдентификатор - 
// 
Функция КлючРегистраПоСсылке(Знач Ссылка) Экспорт
	
	Результат = Новый Структура("Тип,Идентификатор");
	
	Если Ссылка = Справочники.ИдентификаторыОбъектовМетаданных.ПустаяСсылка() Тогда
		
		Результат.Тип = Справочники.ИдентификаторыОбъектовМетаданных.ПустаяСсылка();
		Результат.Идентификатор = Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000");
		
	Иначе
		
		Результат.Тип = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(Ссылка.Метаданные());
		Результат.Идентификатор = Ссылка.УникальныйИдентификатор();
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Параметры: 
//  Тип - СправочникСсылка.ИдентификаторыОбъектовМетаданных
//  Идентификатор - УникальныйИдентификатор
// 
// Возвращаемое значение: 
//  ЛюбаяСсылка - ссылка по ключу регистра.
Функция СсылкаПоКлючуРегистра(Знач Тип, Знач Идентификатор) Экспорт
	
	Если Тип = Справочники.ИдентификаторыОбъектовМетаданных.ПустаяСсылка() Тогда
		Возврат Тип;
	Иначе
		
		ОбъектМетаданных = ОбщегоНазначения.ОбъектМетаданныхПоИдентификатору(Тип);
		Менеджер = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(ОбъектМетаданных.ПолноеИмя());
		
		Возврат Менеджер.ПолучитьСсылку(Идентификатор);
		
	КонецЕсли;
	
КонецФункции

// Формирует ключ разрешения (для использования в регистрах, в которых хранится информация о
// предоставленных разрешениях).
//
// Параметры:
//  Разрешение - ОбъектXDTO -
//
// Возвращаемое значение:
//   Строка - ключ.
//
Функция КлючРазрешения(Знач Разрешение) Экспорт
	
	Хеширование = Новый ХешированиеДанных(ХешФункция.MD5);
	Хеширование.Добавить(ОбщегоНазначения.ОбъектXDTOВСтрокуXML(Разрешение));
	
	Ключ = ФабрикаXDTO.Создать(ФабрикаXDTO.Тип("http://www.w3.org/2001/XMLSchema", "hexBinary"), 
		Хеширование.ХешСумма).ЛексическоеЗначение;
	
	Если СтрДлина(Ключ) > 32 Тогда
		ВызватьИсключение НСтр("ru = 'Превышение длины ключа';
								|en = 'Key length exceeded'");
	КонецЕсли;
	
	Возврат Ключ;
	
КонецФункции

// Возвращает строку таблицы разрешений, соответствующую отбору.
// Если в таблице нет строк, соответствующих отбору - может быть добавлена новая.
// Если в таблице больше одной строки, соответствующей отбору - генерируется исключение.
//
// Параметры:
//  ТаблицаРазрешений - ТаблицаЗначений - 
//  Отбор - Структура - 
//  ДобавитьПриОтсутствии - Булево - 
//
// Возвращаемое значение:
//   СтрокаТаблицыЗначений, Неопределено - 
//
Функция СтрокаТаблицыРазрешений(Знач ТаблицаРазрешений, Знач Отбор, Знач ДобавитьПриОтсутствии = Истина) Экспорт
	
	Строки = ТаблицаРазрешений.НайтиСтроки(Отбор);
	
	Если Строки.Количество() = 0 Тогда
		
		Если ДобавитьПриОтсутствии Тогда
			
			Строка = ТаблицаРазрешений.Добавить();
			ЗаполнитьЗначенияСвойств(Строка, Отбор);
			Возврат Строка;
			
		Иначе
			
			Возврат Неопределено;
			
		КонецЕсли;
		
	ИначеЕсли Строки.Количество() = 1 Тогда
		
		Возврат Строки.Получить(0);
		
	Иначе
		
		ВызватьИсключение СтрШаблон(НСтр("ru = 'Нарушение уникальности строк в таблице разрешений по отбору %1';
										|en = 'Row uniqueness violation in permission table filtered by %1'"),
			ОбщегоНазначения.ЗначениеВСтрокуXML(Отбор));
		
	КонецЕсли;
	
КонецФункции

// Устанавливает исключительную управляемую блокировку на таблицы всех регистров, использующихся
// для хранения перечня предоставленных разрешений.
//
// Параметры:
//  ПрограммныйМодуль - ЛюбаяСсылка - ссылка на элемент справочника, соответствующая внешнему модулю, информацию
//    о ранее предоставленных разрешениях по которому требуется очистить. Если значение параметра не задано -
//    будет заблокирована информация о предоставленных разрешениях по всем внешним модулям.
// ЗаблокироватьРежимыПодключенияВнешнихМодулей - Булево - флаг необходимости дополнительной блокировки режимов подключения
//    внешних модулей.
//
Процедура ЗаблокироватьРегистрыПредоставленныхРазрешений(Знач ПрограммныйМодуль = Неопределено, 
	Знач ЗаблокироватьРежимыПодключенияВнешнихМодулей = Истина) Экспорт
	
	Если Не ТранзакцияАктивна() Тогда
		ВызватьИсключение НСтр("ru = 'Транзакция не активна';
								|en = 'Transaction is not active'");
	КонецЕсли;
	
	Регистры = Новый Массив();
	
	Если ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных() Тогда
		
		Регистры.Добавить(РегистрыСведений.РазрешенияНаИспользованиеВнешнихРесурсовОбластейДанных);
		
		Если ЗаблокироватьРежимыПодключенияВнешнихМодулей Тогда
			Регистры.Добавить(РегистрыСведений.РежимыПодключенияВнешнихМодулейВМоделиСервиса);
		КонецЕсли;
		
	Иначе
		
		Регистры.Добавить(РегистрыСведений.РазрешенияНаИспользованиеВнешнихРесурсовОбластейДанных);
		
		Если ЗаблокироватьРежимыПодключенияВнешнихМодулей Тогда
			Регистры.Добавить(РегистрыСведений.РежимыПодключенияВнешнихМодулейВМоделиСервиса);
		КонецЕсли;
		
	КонецЕсли;
	
	Если ПрограммныйМодуль <> Неопределено Тогда
		Ключ = КлючРегистраПоСсылке(ПрограммныйМодуль);
	КонецЕсли;
	
	Блокировка = Новый БлокировкаДанных();
	
	Для Каждого Регистр Из Регистры Цикл
		БлокировкаРегистра = Блокировка.Добавить(Регистр.СоздатьНаборЗаписей().Метаданные().ПолноеИмя());
		Если ПрограммныйМодуль <> Неопределено Тогда
			БлокировкаРегистра.УстановитьЗначение("ТипПрограммногоМодуля", Ключ.Тип);
			БлокировкаРегистра.УстановитьЗначение("ИдентификаторПрограммногоМодуля", Ключ.Идентификатор);
		КонецЕсли;
	КонецЦикла;
	
	Блокировка.Заблокировать();
	
КонецПроцедуры

// Возвращает текущий срез предоставленных разрешений.
//
// Параметры:
//  ВРазрезеВладельцев - Булево - если Истина - в возвращаемой таблице будет присутствовать информация
//    о владельцах разрешений, иначе текущий срез будет свернут по владельцу.
//  БезОписаний - Булево - если Истина - срез будет возвращен с очищенным полем Description у разрешений.
//
// Возвращаемое значение:
// ТаблицаЗначений - колонки:
// * ТипПрограммногоМодуля - СправочникСсылка.ИдентификаторыОбъектовМетаданных - 
// * ИдентификаторПрограммногоМодуля - УникальныйИдентификатор - 
// * ТипВладельца - СправочникСсылка.ИдентификаторыОбъектовМетаданных -
// * ИдентификаторВладельца - УникальныйИдентификатор - 
// * Тип - Строка - имя XDTO-типа, описывающего разрешения,
// * Разрешения - Соответствие из КлючИЗначение - описание разрешений:
//   ** Ключ - Строка - ключ разрешения (см. функцию КлючРазрешения в модуле менеджера регистра
//      РазрешенияНаИспользованиеВнешнихРесурсов).
//   ** Значение - ОбъектXDTO - XDTO-описание разрешения.
// * ДополненияРазрешений - Соответствие из КлючИЗначение - описание дополнений разрешений:
//   ** Ключ - Строка - ключ разрешения (см. функцию КлючРазрешения в модуле менеджера регистра
//      РазрешенияНаИспользованиеВнешнихРесурсов).
//   ** Значение - см. РегистрыСведений.РазрешенияНаИспользованиеВнешнихРесурсов.ДополнениеРазрешения
//
Функция СрезРазрешений(Знач ВРазрезеВладельцев = Истина, Знач БезОписаний = Ложь) Экспорт
	
	Если ОбщегоНазначения.РазделениеВключено() Тогда
		Регистр = РегистрыСведений.РазрешенияНаИспользованиеВнешнихРесурсовОбластейДанных;
	Иначе
		Регистр = РегистрыСведений.РазрешенияНаИспользованиеВнешнихРесурсовВМоделиСервиса;
	КонецЕсли;
	
	Результат = Новый ТаблицаЗначений();
	
	Результат.Колонки.Добавить("ТипПрограммногоМодуля", 
		Новый ОписаниеТипов("СправочникСсылка.ИдентификаторыОбъектовМетаданных"));
	Результат.Колонки.Добавить("ИдентификаторПрограммногоМодуля", Новый ОписаниеТипов("УникальныйИдентификатор"));
	Если ВРазрезеВладельцев Тогда
		Результат.Колонки.Добавить("ТипВладельца", 
			Новый ОписаниеТипов("СправочникСсылка.ИдентификаторыОбъектовМетаданных"));
		Результат.Колонки.Добавить("ИдентификаторВладельца", Новый ОписаниеТипов("УникальныйИдентификатор"));
	КонецЕсли;
	Результат.Колонки.Добавить("Тип", Новый ОписаниеТипов("Строка"));
	Результат.Колонки.Добавить("Разрешения", Новый ОписаниеТипов("Соответствие"));
	
	Выборка = Регистр.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Разрешение = ОбщегоНазначения.ОбъектXDTOИзСтрокиXML(Выборка.ТелоРазрешения);
		
		ОтборПоТаблице = Новый Структура();
		ОтборПоТаблице.Вставить("ТипПрограммногоМодуля", Выборка.ТипПрограммногоМодуля);
		ОтборПоТаблице.Вставить("ИдентификаторПрограммногоМодуля", Выборка.ИдентификаторПрограммногоМодуля);
		Если ВРазрезеВладельцев Тогда
			ОтборПоТаблице.Вставить("ТипВладельца", Выборка.ТипВладельца);
			ОтборПоТаблице.Вставить("ИдентификаторВладельца", Выборка.ИдентификаторВладельца);
		КонецЕсли;
		ОтборПоТаблице.Вставить("Тип", Разрешение.Тип().Имя);
		
		Строка = СтрокаТаблицыРазрешений(Результат, ОтборПоТаблице);
		
		ТелоРазрешения = Выборка.ТелоРазрешения;
		КлючРазрешения = Выборка.КлючРазрешения;
		
		Если БезОписаний Тогда
			
			Если ЗначениеЗаполнено(Разрешение.Description) Тогда
				
				Разрешение.Description = "";
				ТелоРазрешения = ОбщегоНазначения.ОбъектXDTOВСтрокуXML(Разрешение);
				КлючРазрешения = КлючРазрешения(Разрешение);
				
			КонецЕсли;
			
		КонецЕсли;
		
		Строка.Разрешения.Вставить(КлючРазрешения, ТелоРазрешения);
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Записывает в регистр разрешение.
//
// Параметры:
//  ТипПрограммногоМодуля - СправочникСсылка.ИдентификаторыОбъектовМетаданных - 
//  ИдентификаторПрограммногоМодуля - УникальныйИдентификатор - 
//  ТипВладельца - СправочникСсылка.ИдентификаторыОбъектовМетаданных - 
//  ИдентификаторВладельца - УникальныйИдентификатор - 
//  КлючРазрешения - Строка - ключ разрешения
//  Разрешение - ОбъектXDTO - XDTO-представление разрешения
//  ДополнениеРазрешения - Произвольный - сериализуемый в XDTO.
//
Процедура ДобавитьРазрешение(Знач ТипПрограммногоМодуля, Знач ИдентификаторПрограммногоМодуля, Знач ТипВладельца, 
	Знач ИдентификаторВладельца, Знач КлючРазрешения, Знач Разрешение, Знач ДополнениеРазрешения = Неопределено) Экспорт
	
	Если ОбщегоНазначения.РазделениеВключено() Тогда
		Регистр = РегистрыСведений.РазрешенияНаИспользованиеВнешнихРесурсовОбластейДанных;
	Иначе
		Регистр = РегистрыСведений.РазрешенияНаИспользованиеВнешнихРесурсовВМоделиСервиса;
	КонецЕсли;
	
	Менеджер = Регистр.СоздатьМенеджерЗаписи();
	Менеджер.ТипПрограммногоМодуля = ТипПрограммногоМодуля;
	Менеджер.ИдентификаторПрограммногоМодуля = ИдентификаторПрограммногоМодуля;
	Менеджер.ТипВладельца = ТипВладельца;
	Менеджер.ИдентификаторВладельца = ИдентификаторВладельца;
	Менеджер.КлючРазрешения = КлючРазрешения;
	
	Менеджер.Прочитать();
	
	Если Менеджер.Выбран() Тогда
		
		ВызватьИсключение СтрШаблон("%1
                  |- ТипПрограммногоМодуля: %2
                  |- ИдентификаторПрограммногоМодуля: %3
                  |- ТипВладельца: %4
                  |- ИдентификаторВладельца: %5
                  |- КлючРазрешения: %6.",
			НСтр("ru = 'Дублирование разрешений по ключевым полям:';
				|en = 'Permission duplication by key fields:'"),
			Строка(ТипПрограммногоМодуля),
			Строка(ИдентификаторПрограммногоМодуля),
			Строка(ТипВладельца),
			Строка(ИдентификаторВладельца),
			КлючРазрешения);
		
	Иначе
		
		Менеджер.ТипПрограммногоМодуля = ТипПрограммногоМодуля;
		Менеджер.ИдентификаторПрограммногоМодуля = ИдентификаторПрограммногоМодуля;
		Менеджер.ТипВладельца = ТипВладельца;
		Менеджер.ИдентификаторВладельца = ИдентификаторВладельца;
		Менеджер.КлючРазрешения = КлючРазрешения;
		Менеджер.ТелоРазрешения = ОбщегоНазначения.ОбъектXDTOВСтрокуXML(Разрешение);
		
		Менеджер.Записать(Ложь);
		
	КонецЕсли;
	
КонецПроцедуры

// Удаляет разрешение из регистра.
//
// Параметры:
//  ТипПрограммногоМодуля - СправочникСсылка.ИдентификаторыОбъектовМетаданных - 
//  ИдентификаторПрограммногоМодуля - УникальныйИдентификатор -
//  ТипВладельца - СправочникСсылка.ИдентификаторыОбъектовМетаданных - 
//  ИдентификаторВладельца - УникальныйИдентификатор -
//  КлючРазрешения - Строка - ключ разрешения
//  Разрешение - ОбъектXDTO - XDTO-представление разрешения.
//
Процедура УдалитьРазрешение(Знач ТипПрограммногоМодуля, Знач ИдентификаторПрограммногоМодуля, Знач ТипВладельца, 
	Знач ИдентификаторВладельца, Знач КлючРазрешения, Знач Разрешение) Экспорт
	
	Если ОбщегоНазначения.РазделениеВключено() Тогда
		Регистр = РегистрыСведений.РазрешенияНаИспользованиеВнешнихРесурсовОбластейДанных;
	Иначе
		Регистр = РегистрыСведений.РазрешенияНаИспользованиеВнешнихРесурсовВМоделиСервиса;
	КонецЕсли;
	
	Менеджер = Регистр.СоздатьМенеджерЗаписи();
	Менеджер.ТипПрограммногоМодуля = ТипПрограммногоМодуля;
	Менеджер.ИдентификаторПрограммногоМодуля = ИдентификаторПрограммногоМодуля;
	Менеджер.ТипВладельца = ТипВладельца;
	Менеджер.ИдентификаторВладельца = ИдентификаторВладельца;
	Менеджер.КлючРазрешения = КлючРазрешения;
	
	Менеджер.Прочитать();
	
	Если Менеджер.Выбран() Тогда
		
		Если Менеджер.ТелоРазрешения <> ОбщегоНазначения.ОбъектXDTOВСтрокуXML(Разрешение) Тогда
			
			ВызватьИсключение СтрШаблон("%1
	                  |- ТипПрограммногоМодуля: %2
	                  |- ИдентификаторПрограммногоМодуля: %3
	                  |- ТипВладельца: %4
	                  |- ИдентификаторВладельца: %5
	                  |- КлючРазрешения: %6.",
				НСтр("ru = 'Коллизия разрешений по ключам:';
					|en = 'Permission collision by keys:'"),
				Строка(ТипПрограммногоМодуля),
				Строка(ИдентификаторПрограммногоМодуля),
				Строка(ТипВладельца),
				Строка(ИдентификаторВладельца),
				КлючРазрешения);
				
		КонецЕсли;
		
		Менеджер.Удалить();
		
	Иначе
		
		ВызватьИсключение СтрШаблон("%1
                  |- ТипПрограммногоМодуля: %2
                  |- ИдентификаторПрограммногоМодуля: %3
                  |- ТипВладельца: %4
                  |- ИдентификаторВладельца: %5
                  |- КлючРазрешения: %6.",
			НСтр("ru = 'Попытка удаления несуществующего разрешения:';
				|en = 'Attempt to delete a non-existing permission:'"),
			Строка(ТипПрограммногоМодуля),
			Строка(ИдентификаторПрограммногоМодуля),
			Строка(ТипВладельца),
			Строка(ИдентификаторВладельца),
			КлючРазрешения);
		
	КонецЕсли;
	
КонецПроцедуры

// Удаляет запросы на использование внешних ресурсов.
//
// Параметры:
//  ИдентификаторыЗапросов - Массив Из УникальныйИдентификатор - идентификаторы удаляемых запросов.
//
Процедура УдалитьЗапросы(Знач ИдентификаторыЗапросов) Экспорт
	
	Если ОбщегоНазначения.РазделениеВключено() Тогда
		Регистр = РегистрыСведений.ЗапросыРазрешенийНаИспользованиеВнешнихРесурсовОбластейДанных;
	Иначе
		Регистр = РегистрыСведений.ЗапросыРазрешенийНаИспользованиеВнешнихРесурсовВМоделиСервиса;
	КонецЕсли;
	
	НачатьТранзакцию();
	
	Попытка
		
		Для Каждого ИдентификаторЗапроса Из ИдентификаторыЗапросов Цикл
			
			Менеджер = Регистр.СоздатьМенеджерЗаписи();
			Менеджер.ИдентификаторЗапроса = ИдентификаторЗапроса;
			Менеджер.Удалить();
			
		КонецЦикла;
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		ВызватьИсключение;
		
	КонецПопытки;
	
КонецПроцедуры

// Очищает неактуальные запросы на использование внешних ресурсов.
//
Процедура ОчиститьНеактуальныеЗапросы() Экспорт
	
	Если ОбщегоНазначения.РазделениеВключено() Тогда
		Регистр = РегистрыСведений.ЗапросыРазрешенийНаИспользованиеВнешнихРесурсовОбластейДанных;
	Иначе
		Регистр = РегистрыСведений.ЗапросыРазрешенийНаИспользованиеВнешнихРесурсовВМоделиСервиса;
	КонецЕсли;
	
	НачатьТранзакцию();
	
	Попытка
		
		Выборка = Регистр.Выбрать();
		
		Пока Выборка.Следующий() Цикл
			
			Попытка
				
				Ключ = Регистр.СоздатьКлючЗаписи(Новый Структура("ИдентификаторЗапроса", Выборка.ИдентификаторЗапроса));
				ЗаблокироватьДанныеДляРедактирования(Ключ);
				
			Исключение
				
				// Обработка исключения не требуется.
				// Ожидаемое исключение - попытка удалить ту же запись регистра из другого сеанса.
				Продолжить;
				
			КонецПопытки;
			
			Менеджер = Регистр.СоздатьМенеджерЗаписи();
			Менеджер.ИдентификаторЗапроса = Выборка.ИдентификаторЗапроса;
			Менеджер.Удалить();
			
		КонецЦикла;
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		ВызватьИсключение;
		
	КонецПопытки;
	
КонецПроцедуры

// Создает и инициализирует менеджер применения запросов на использование внешних ресурсов.
//
// Параметры:
//  ИдентификаторыЗапросов - Массив Из УникальныйИдентификатор - идентификаторы запросов, для
//   применения которых создается менеджер.
//
// Возвращаемое значение:
//   ОбработкаОбъект.НастройкаРазрешенийНаИспользованиеВнешнихРесурсов - менеджер.
//
Функция МенеджерПримененияРазрешений(Знач ИдентификаторыЗапросов) Экспорт
	
	Менеджер = Обработки.НастройкаРазрешенийНаИспользованиеВнешнихРесурсовВМоделиСервиса.Создать();
	
	Если ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных() Тогда
		Регистр = РегистрыСведений.ЗапросыРазрешенийНаИспользованиеВнешнихРесурсовОбластейДанных;
	Иначе
		Регистр = РегистрыСведений.ЗапросыРазрешенийНаИспользованиеВнешнихРесурсовВМоделиСервиса;
	КонецЕсли;
	
	ТекстЗапроса =
		"ВЫБРАТЬ
		|	Запросы.ТипПрограммногоМодуля,
		|	Запросы.ИдентификаторПрограммногоМодуля,
		|	Запросы.ТипВладельца,
		|	Запросы.ИдентификаторВладельца,
		|	Запросы.РежимЗамещения,
		|	Запросы.ДобавляемыеРазрешения,
		|	Запросы.УдаляемыеРазрешения,
		|	Запросы.ИдентификаторЗапроса
		|ИЗ
		|	&Таблица КАК Запросы
		|ГДЕ
		|	Запросы.ИдентификаторЗапроса В(&ИдентификаторыЗапросов)";
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&Таблица", Регистр.СоздатьНаборЗаписей().Метаданные().ПолноеИмя());
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("ИдентификаторыЗапросов", ИдентификаторыЗапросов);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		КлючЗаписи = Регистр.СоздатьКлючЗаписи(Новый Структура("ИдентификаторЗапроса", Выборка.ИдентификаторЗапроса));
		ЗаблокироватьДанныеДляРедактирования(КлючЗаписи);
		
		ДобавляемыеРазрешения = Новый Массив();
		Если ЗначениеЗаполнено(Выборка.ДобавляемыеРазрешения) Тогда
			
			Массив = ОбщегоНазначения.ЗначениеИзСтрокиXML(Выборка.ДобавляемыеРазрешения);
			
			Для Каждого ЭлементМассива Из Массив Цикл
				ДобавляемыеРазрешения.Добавить(ОбщегоНазначения.ОбъектXDTOИзСтрокиXML(ЭлементМассива));
			КонецЦикла;
			
		КонецЕсли;
		
		УдаляемыеРазрешения = Новый Массив();
		Если ЗначениеЗаполнено(Выборка.УдаляемыеРазрешения) Тогда
			
			Массив = ОбщегоНазначения.ЗначениеИзСтрокиXML(Выборка.УдаляемыеРазрешения);
			
			Для Каждого ЭлементМассива Из Массив Цикл
				УдаляемыеРазрешения.Добавить(ОбщегоНазначения.ОбъектXDTOИзСтрокиXML(ЭлементМассива));
			КонецЦикла;
			
		КонецЕсли;
		
		Менеджер.ДобавитьИдентификаторЗапроса(Выборка.ИдентификаторЗапроса);
		
		Менеджер.ДобавитьЗапросРазрешенийНаИспользованиеВнешнихРесурсов(
			Выборка.ТипПрограммногоМодуля,
			Выборка.ИдентификаторПрограммногоМодуля,
			Выборка.ТипВладельца,
			Выборка.ИдентификаторВладельца,
			Выборка.РежимЗамещения,
			ДобавляемыеРазрешения,
			УдаляемыеРазрешения);
		
	КонецЦикла;
	
	Менеджер.РассчитатьПрименениеЗапросов();
	
	Возврат Менеджер;
	
КонецФункции

// Идентификатор пакета применяемых запросов
// 
// Параметры: 
//  Состояние - строка - строка XML
// 
// Возвращаемое значение:
//  УникальныйИдентификатор
Функция ПакетПрименяемыхЗапросов(Знач Состояние) Экспорт
	
	Если ОбщегоНазначения.РазделениеВключено() Тогда
		Регистр = РегистрыСведений.ПрименениеРазрешенийНаИспользованиеВнешнихРесурсовОбластейДанных;
	Иначе
		Регистр = РегистрыСведений.ПрименениеРазрешенийНаИспользованиеВнешнихРесурсовВМоделиСервиса;
	КонецЕсли;
	
	Менеджер = Регистр.СоздатьМенеджерЗаписи();
	Менеджер.ИдентификаторПакета = Новый УникальныйИдентификатор();
	Менеджер.Состояние = Состояние;
	
	Менеджер.Записать();
	
	Возврат Менеджер.ИдентификаторПакета;
	
КонецФункции

// Параметры: 
//  ИдентификаторПакета - Строка
// 
// Возвращаемое значение: 
//  ПеречислениеСсылка.РезультатыОбработкиЗапросовНаИспользованиеВнешнихРесурсовВМоделиСервиса
Функция РезультатОбработкиПакета(Знач ИдентификаторПакета) Экспорт
	
	Если ОбщегоНазначения.РазделениеВключено() Тогда
		Регистр = РегистрыСведений.ПрименениеРазрешенийНаИспользованиеВнешнихРесурсовОбластейДанных;
	Иначе
		Регистр = РегистрыСведений.ПрименениеРазрешенийНаИспользованиеВнешнихРесурсовВМоделиСервиса;
	КонецЕсли;
	
	Менеджер = Регистр.СоздатьМенеджерЗаписи();
	Менеджер.ИдентификаторПакета = Новый УникальныйИдентификатор();
	Менеджер.Прочитать();
	
	Если Менеджер.Выбран() Тогда
		
		Возврат Менеджер.Результат;
		
	Иначе
		
		ВызватьИсключение СтрШаблон(
			НСтр("ru = 'Не найден пакет запросов %1';
				|en = 'Query pack %1 is not found'"), ИдентификаторПакета);
		
	КонецЕсли;
	
КонецФункции

Процедура УстановитьРезультатОбработкиПакета(Знач Результат) Экспорт
	
	Если ОбщегоНазначения.РазделениеВключено() Тогда
		Регистр = РегистрыСведений.ПрименениеРазрешенийНаИспользованиеВнешнихРесурсовОбластейДанных;
	Иначе
		Регистр = РегистрыСведений.ПрименениеРазрешенийНаИспользованиеВнешнихРесурсовВМоделиСервиса;
	КонецЕсли;
	
	Менеджер = Регистр.СоздатьМенеджерЗаписи();
	Менеджер.ИдентификаторПакета = Новый УникальныйИдентификатор();
	Менеджер.Результат = Результат;
	Менеджер.Записать();
	
КонецПроцедуры

// Менеджер применения пакета
// 
// Параметры: 
//  ИдентификаторПакета - УникальныйИдентификатор
// 
// Возвращаемое значение: 
//  ОбработкаОбъект.НастройкаРазрешенийНаИспользованиеВнешнихРесурсовВМоделиСервиса
Функция МенеджерПримененияПакета (Знач ИдентификаторПакета) Экспорт
	
	Менеджер = Обработки.НастройкаРазрешенийНаИспользованиеВнешнихРесурсовВМоделиСервиса.Создать();
	Менеджер.ПрочитатьСостояниеИзСтрокиXML(СостояниеОбработкиПакета(ИдентификаторПакета));
	
	Возврат Менеджер;
	
КонецФункции

// Сериализует запросы на использование внешних ресурсов для отправки в менеджер сервиса.
//
// Параметры:
//  ИдентификаторыЗапросов - Массив Из УникальныйИдентификатор - идентификаторы запросов.
//
// Возвращаемое значение:
//	ОбъектXDTO - {http://www.1c.ru/1cFresh/Application/Permissions/Management/a.b.c.d}PermissionsRequestsList.
//
Функция СериализоватьЗапросыНаИспользованиеВнешнихРесурсов(Знач ИдентификаторыЗапросов) Экспорт
	
	Конверт = ФабрикаXDTO.Создать(ФабрикаXDTO.Тип(ПакетАдминистрированиеРазрешений(), "PermissionsRequestsList"));
	
	ТекстЗапроса =
		"ВЫБРАТЬ
		|	Запросы.ТипПрограммногоМодуля,
		|	Запросы.ИдентификаторПрограммногоМодуля,
		|	Запросы.ТипВладельца,
		|	Запросы.ИдентификаторВладельца,
		|	Запросы.РежимЗамещения,
		|	Запросы.ДобавляемыеРазрешения,
		|	Запросы.УдаляемыеРазрешения
		|ИЗ
		|	&Таблица КАК Запросы
		|ГДЕ
		|	Запросы.ИдентификаторЗапроса В(&ИдентификаторыЗапросов)";
	
	Если РаботаВМоделиСервиса.ДоступноИспользованиеРазделенныхДанных() Тогда
		
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&Таблица", 
			"РегистрСведений.ЗапросыРазрешенийНаИспользованиеВнешнихРесурсовОбластейДанных");
		
	Иначе
		
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&Таблица", 
			"РегистрСведений.ЗапросыРазрешенийНаИспользованиеВнешнихРесурсовВМоделиСервиса");
		
	КонецЕсли;
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("ИдентификаторыЗапросов", ИдентификаторыЗапросов);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		ЗапросРазрешений = ФабрикаXDTO.Создать(ФабрикаXDTO.Тип(ПакетАдминистрированиеРазрешений(), "PermissionsRequest"));
		
		ЗапросРазрешений.UUID = Выборка.ИдентификаторЗапроса;
		
		ПрограммныйМодуль = СсылкаПоКлючуРегистра(Выборка.ТипПрограммногоМодуля, Выборка.ИдентификаторПрограммногоМодуля);
		Владелец = СсылкаПоКлючуРегистра(Выборка.ТипВладельца, Выборка.ИдентификаторВладельца);
		
		ПредставлениеПрограммногоМодуля = Неопределено;
		ПредставлениеВладельца = Неопределено;
		
		СтандартнаяОбработка = Истина;
		
		Если ОбщегоНазначения.ПодсистемаСуществует(
			"СтандартныеПодсистемы.РаботаВМоделиСервиса.ДополнительныеОтчетыИОбработкиВМоделиСервиса") Тогда
			
			МодульДополнительныеОтчетыИОбработкиВМоделиСервиса = 
				ОбщегоНазначения.ОбщийМодуль("ДополнительныеОтчетыИОбработкиВМоделиСервиса");
			МодульДополнительныеОтчетыИОбработкиВМоделиСервиса.ПриСериализацииВладельцаРазрешенийНаИспользованиеВнешнихРесурсов(
				Владелец, СтандартнаяОбработка, ПредставлениеВладельца);
			
		КонецЕсли;
		
		Если СтандартнаяОбработка Тогда
			
			Если ПрограммныйМодуль = Справочники.ИдентификаторыОбъектовМетаданных.ПустаяСсылка() Тогда
				
				ПредставлениеПрограммногоМодуля = ФабрикаXDTO.Создать(ФабрикаXDTO.Тип(ПакетАдминистрированиеРазрешений(), 
					"PermissionModuleApplication"));
				
			Иначе
				
				ВызватьИсключение СтрШаблон(
					НСтр("ru = 'Не сериализован программный модуль по ключу:
                          |- Тип: %1
                          |- Идентификатор: %2';
                          |en = 'Unserialized key program module:
                          |- Type: %1
                          |- ID: %2'"),
					Выборка.ТипПрограммногоМодуля,
					Выборка.ИдентификаторПрограммногоМодуля);
				
			КонецЕсли;
			
			Если Владелец = Справочники.ИдентификаторыОбъектовМетаданных.ПустаяСсылка() Тогда
				
				ПредставлениеВладельца = ФабрикаXDTO.Создать(ФабрикаXDTO.Тип(ПакетАдминистрированиеРазрешений(), 
					"PermissionsOwnerApplication"));
				
			Иначе
				
				ПредставлениеВладельца = ФабрикаXDTO.Создать(ФабрикаXDTO.Тип(ПакетАдминистрированиеРазрешений(), 
					"PermissionsOwnerApplicationObject"));
				ПредставлениеВладельца.Type = Выборка.Владелец.Метаданные().ПолноеИмя();
				ПредставлениеВладельца.UUID = Выборка.Владелец.УникальныйИдентификатор();
				ПредставлениеВладельца.Description = Строка(Выборка.Владелец);
				
			КонецЕсли;
			
		КонецЕсли;
		
		ЗапросРазрешений.Module = ПредставлениеПрограммногоМодуля;
		ЗапросРазрешений.Owner = ПредставлениеВладельца;
		
		ДобавляемыеРазрешения = ФабрикаXDTO.Создать(ФабрикаXDTO.Тип(ПакетАдминистрированиеРазрешений(), "PermissionsList"));
		Если Не ПустаяСтрока(Выборка.ДобавляемыеРазрешения) Тогда
			МассивРазрешений = ОбщегоНазначения.ЗначениеИзСтрокиXML(Выборка.ДобавляемыеРазрешения);
			Для Каждого ЭлементМассива Из МассивРазрешений Цикл
				РазрешенияСписок = ДобавляемыеРазрешения.Permission; // СписокXDTO
				РазрешенияСписок.Добавить(ОбщегоНазначения.ОбъектXDTOИзСтрокиXML(ЭлементМассива));
			КонецЦикла;
		КонецЕсли;
		ЗапросРазрешений.GrantPermissions = ДобавляемыеРазрешения;
		
		УдаляемыеРазрешения = ФабрикаXDTO.Создать(ФабрикаXDTO.Тип(ПакетАдминистрированиеРазрешений(), "PermissionsList"));
		Если Не ПустаяСтрока(Выборка.УдаляемыеРазрешения) Тогда
			МассивРазрешений = ОбщегоНазначения.ЗначениеИзСтрокиXML(Выборка.УдаляемыеРазрешения);
			Для Каждого ЭлементМассива Из МассивРазрешений Цикл
				РазрешенияСписок = УдаляемыеРазрешения.Permission; // СписокXDTO
				РазрешенияСписок.Добавить(ОбщегоНазначения.ОбъектXDTOИзСтрокиXML(ЭлементМассива));
			КонецЦикла;
		КонецЕсли;
		ЗапросРазрешений.CancelPermissions = УдаляемыеРазрешения;
		
		ЗапросРазрешений.ReplaceOwnerPermissions = Выборка.РежимЗамещения;
		
		СписокЗапросов = Конверт.Request; // СписокXDTO
		СписокЗапросов.Добавить(ЗапросРазрешений);
		
	КонецЦикла;
	
	Возврат Конверт;
	
КонецФункции

// Пакет администрирование разрешений.
// 
// Возвращаемое значение:
//  Строка
Функция ПакетАдминистрированиеРазрешений() Экспорт
	
	Возврат "http://www.1c.ru/1cFresh/Application/Permissions/Management/1.0.0.1";
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция СостояниеОбработкиПакета(Знач ИдентификаторПакета)
	
	Если ОбщегоНазначения.РазделениеВключено() Тогда
		Регистр = РегистрыСведений.ПрименениеРазрешенийНаИспользованиеВнешнихРесурсовОбластейДанных;
	Иначе
		Регистр = РегистрыСведений.ПрименениеРазрешенийНаИспользованиеВнешнихРесурсовВМоделиСервиса;
	КонецЕсли;
	
	Менеджер = Регистр.СоздатьМенеджерЗаписи();
	Менеджер.ИдентификаторПакета = Новый УникальныйИдентификатор();
	Менеджер.Прочитать();
	
	Если Менеджер.Выбран() Тогда
		
		Возврат Менеджер.Состояние;
		
	Иначе
		
		ВызватьИсключение СтрШаблон(НСтр("ru = 'Не найден пакет запросов %1';
										|en = 'Query pack %1 is not found'"), ИдентификаторПакета);
		
	КонецЕсли;
	
КонецФункции

Процедура ПриЗапросеИзмененияПрофилейБезопасности(Знач ПрограммныйМодуль, СтандартнаяОбработка, Результат)
	
	Если ОбщегоНазначения.РазделениеВключено() Тогда
		
		СтандартнаяОбработка = Ложь;
		Результат  = Новый УникальныйИдентификатор();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти