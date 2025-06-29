///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ПрофилиБезопасности") Тогда
		
		МодульРаботаВБезопасномРежиме   = ОбщегоНазначения.ОбщийМодуль("РаботаВБезопасномРежиме");
		ИспользуютсяПрофилиБезопасности = МодульРаботаВБезопасномРежиме.ИспользуютсяПрофилиБезопасности();
		
	Иначе
		ИспользуютсяПрофилиБезопасности = Ложь;
	КонецЕсли;
	
	Если Не ДополнительныеСвойства.Свойство("ПропуститьОсновнуюПроверкуЗаполнения") Тогда
	
		Если Не НомерПорядкаУникален(ПорядокЗаполнения, Ссылка) Тогда
			ТекстОшибки = НСтр("ru = 'Порядок заполнения не уникален - в системе уже есть том с таким порядком';
								|en = 'The filling order is not unique. A volume with this order already exists.'");
			ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, , "ПорядокЗаполнения", "Объект", Отказ);
		КонецЕсли;
		
		Если МаксимальныйРазмер <> 0 Тогда
			ТекущийРазмерВБайтах = 0;
			Если Не Ссылка.Пустая() Тогда
				ТекущийРазмерВБайтах = РаботаСФайламиВТомахСлужебный.ОбъемТома(Ссылка);
			КонецЕсли;
			ТекущийРазмер = ТекущийРазмерВБайтах / (1024 * 1024);
			
			Если МаксимальныйРазмер < ТекущийРазмер Тогда
				ТекстОшибки = НСтр("ru = 'Максимальный размер тома меньше, чем текущий размер';
									|en = 'The volume size limit is less than the current size.'");
				ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, , "МаксимальныйРазмер", "Объект", Отказ);
			КонецЕсли;
		КонецЕсли;
		
		Если ПустаяСтрока(ПолныйПутьWindows) И ПустаяСтрока(ПолныйПутьLinux) Тогда
			ТекстОшибки = НСтр("ru = 'Не заполнен полный путь';
								|en = 'The full path is required.'");
			ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, , "ПолныйПутьWindows", "Объект", Отказ);
			ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, , "ПолныйПутьLinux",   "Объект", Отказ);
			Возврат;
		КонецЕсли;
		
		ПутиКТомам = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Ссылка, "ПолныйПутьLinux, ПолныйПутьWindows");
		ПроверятьУникальностьПутей = ПутиКТомам.ПолныйПутьLinux <> ПолныйПутьLinux 
										ИЛИ ПутиКТомам.ПолныйПутьWindows <> ПолныйПутьWindows;
		Если ПроверятьУникальностьПутей Тогда
			ПроверитьУникальностьПутиКТомам(Отказ); 
		КонецЕсли;
		
		Если Не ИспользуютсяПрофилиБезопасности
		   И Не ПустаяСтрока(ПолныйПутьWindows)
		   И (    Лев(ПолныйПутьWindows, 2) <> "\\"
		      ИЛИ СтрНайти(ПолныйПутьWindows, ":") <> 0 ) Тогда
			
			ТекстОшибки = НСтр("ru = 'Путь к тому должен быть в формате UNC (\\servername\resource).';
								|en = 'The volume path must have UNC format (\\server_name\resource).'");
			ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, , "ПолныйПутьWindows", "Объект", Отказ);
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	Если Не ДополнительныеСвойства.Свойство("ПропуститьПроверкуДоступаКПапке") Тогда
		
		ИмяПоляСПолнымПутем = ?(ОбщегоНазначения.ЭтоWindowsСервер(), "ПолныйПутьWindows", "ПолныйПутьLinux");
		Если ОбщегоНазначения.РазделениеВключено() Тогда
			МодульРаботаВМоделиСервиса = ОбщегоНазначения.ОбщийМодуль("РаботаВМоделиСервиса");
			ЗначениеРазделителя = ?(МодульРаботаВМоделиСервиса.ИспользованиеРазделителяСеанса(),
				МодульРаботаВМоделиСервиса.ЗначениеРазделителяСеанса(), "");
		Иначе
			ЗначениеРазделителя = "";
		КонецЕсли;
		
		ПолныйПутьТома = СтрЗаменить(ЭтотОбъект[ИмяПоляСПолнымПутем], "%z", ЗначениеРазделителя);
		ИмяКаталогаТестовое = ПолныйПутьТома + "ПроверкаДоступа" + ПолучитьРазделительПути();
		
		Попытка
			СоздатьКаталог(ИмяКаталогаТестовое);
			УдалитьФайлы(ИмяКаталогаТестовое);
		Исключение
			ИнформацияОбОшибке = ИнформацияОбОшибке();
			
			Если ИспользуютсяПрофилиБезопасности Тогда
				ШаблонОшибки =
					НСтр("ru = 'Некорректный путь к тому или сервер с томом в данный момент недоступен.
					           |Проверьте корректность пути к общей папке и доступность сервера.
					           |Возможно не настроены разрешения в профилях безопасности,
					           |или учетная запись, от лица которой работает
					           |сервер 1С:Предприятия, не имеет прав доступа к каталогу тома.
					           |
					           |%1';
					           |en = 'The volume path is invalid or the server with the volume is currently unavailable.
					           |Check if the path to the shared folder is correct and the server is available.
					           |Security profile permissions might not be configured,
					           |or an account on whose behalf
					           |1C:Enterprise server is running might have no access rights to the volume directory.
					           |
					           |%1'");
			Иначе
				ШаблонОшибки =
					НСтр("ru = 'Некорректный путь к тому или сервер с томом в данный момент недоступен.
					           |Проверьте корректность пути к общей папке и доступность сервера.
					           |Возможно учетная запись, от лица которой работает
					           |сервер 1С:Предприятия, не имеет прав доступа к каталогу тома.
					           |
					           |%1';
					           |en = 'The volume path is invalid or the server with the volume is currently unavailable.
					           |Check if the path to the shared folder is correct and the server is available.
					           |An account on whose behalf 1C:Enterprise server is running
					           |might have no access rights to the volume directory.
					           |
					           |%1'");
			КонецЕсли;
			
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				ШаблонОшибки, ОбработкаОшибок.КраткоеПредставлениеОшибки(ИнформацияОбОшибке));
			
			ОбщегоНазначения.СообщитьПользователю(
				ТекстОшибки, , ИмяПоляСПолнымПутем, "Объект", Отказ);
		КонецПопытки;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Возвращает Ложь, если есть том с таким порядком.
Функция НомерПорядкаУникален(ПорядокЗаполнения, СсылкаНаТом)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	КОЛИЧЕСТВО(Тома.ПорядокЗаполнения) КАК Количество
	|ИЗ
	|	Справочник.ТомаХраненияФайлов КАК Тома
	|ГДЕ
	|	Тома.ПорядокЗаполнения = &ПорядокЗаполнения
	|	И Тома.Ссылка <> &СсылкаНаТом";
	
	Запрос.Параметры.Вставить("ПорядокЗаполнения", ПорядокЗаполнения);
	Запрос.Параметры.Вставить("СсылкаНаТом", СсылкаНаТом);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Количество = 0;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

Процедура ПроверитьУникальностьПутиКТомам(Отказ)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ТомаХраненияФайлов.Ссылка КАК Ссылка,
		|	ПРЕДСТАВЛЕНИЕ(ТомаХраненияФайлов.Ссылка) КАК Представление,
		|	ТомаХраненияФайлов.ПолныйПутьWindows КАК ПолныйПутьWindows,
		|	ТомаХраненияФайлов.ПолныйПутьLinux КАК ПолныйПутьLinux
		|ИЗ
		|	Справочник.ТомаХраненияФайлов КАК ТомаХраненияФайлов
		|ГДЕ
		|	НЕ ТомаХраненияФайлов.ПометкаУдаления";
		
	РезультатЗапроса = Запрос.Выполнить();
	ТаблицаРезультата = РезультатЗапроса.Выгрузить();
	ТаблицаРезультата.Индексы.Добавить("ПолныйПутьLinux");
	ТаблицаРезультата.Индексы.Добавить("ПолныйПутьWindows");
	
	ШаблонОшибки = НСтр("ru = 'Путь к тому должен быть уникален. Каталог указан в томе %1.';
						|en = 'The volume path must be unique. The directory is specified in the %1 volume.'");
	Если ЗначениеЗаполнено(ПолныйПутьLinux) Тогда
		Для каждого Том Из ТаблицаРезультата.НайтиСтроки(Новый Структура("ПолныйПутьLinux", ПолныйПутьLinux)) Цикл
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонОшибки, Том.Представление);
			ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, , "ПолныйПутьLinux", "Объект", Отказ);
		КонецЦикла;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ПолныйПутьWindows) Тогда
		Для каждого Том Из ТаблицаРезультата.НайтиСтроки(Новый Структура("ПолныйПутьWindows", ПолныйПутьWindows)) Цикл
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонОшибки, Том.Представление);
			ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, , "ПолныйПутьWindows", "Объект", Отказ);
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.';
						|en = 'Invalid object call on the client.'");
#КонецЕсли