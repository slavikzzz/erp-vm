///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#Область ВременныеФайлы

////////////////////////////////////////////////////////////////////////////////
// Процедуры и функции для работы с временными файлами.

// Создает временный каталог. После окончания работы с временным каталогом его необходимо удалить 
// с помощью ФайловаяСистема.УдалитьВременныйКаталог.
//
// Параметры:
//   Расширение - Строка - расширение каталога, которое идентифицирует назначение временного каталога
//                         и подсистему, которая его создала.
//                         Рекомендуется указывать на английском языке.
//
// Возвращаемое значение:
//   Строка - полный путь к каталогу с разделителем пути.
//
Функция СоздатьВременныйКаталог(Знач Расширение = "") Экспорт
	
	ПутьККаталогу = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(ПолучитьИмяВременногоФайла(Расширение));
	СоздатьКаталог(ПутьККаталогу);
	Возврат ПутьККаталогу;
	
КонецФункции

// Удаляет временный каталог вместе с его содержимым, если возможно.
// Если временный каталог не может быть удален (например, он занят каким-то процессом),
// то в журнал регистрации записывается соответствующее предупреждение, а процедура завершается.
//
// Для совместного использования с ФайловаяСистема.СоздатьВременныйКаталог, 
// после окончания работы с временным каталогом.
//
// Параметры:
//   Путь - Строка - полный путь к временному каталогу.
//
Процедура УдалитьВременныйКаталог(Знач Путь) Экспорт
	
	Если НЕ ЭтоИмяВременногоФайла(Путь) Тогда
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Неверное значение параметра %1 в %2:
				|Каталог не является временным ""%3"".';
				|en = 'Invalid value of parameter %1 in %2:
				|The catalog is not temporary ""%3"".'"), 
			"Путь", "ФайловаяСистема.УдалитьВременныйКаталог", Путь);
	КонецЕсли;
	
	УдалитьВременныеФайлы(Путь);
	
КонецПроцедуры

// Удаляет временный файл.
// 
// Выбрасывает исключение, если передано имя не временного файла.
// 
// Если временный файл не может быть удален (например, он занят каким-то процессом),
// то в журнал регистрации записывается соответствующее предупреждение, а процедура завершается.
//
// Для совместного использования с методом ПолучитьИмяВременногоФайла, 
// после окончания работы с временным файлом.
//
// Параметры:
//   Путь - Строка - полный путь к временному файлу.
//
Процедура УдалитьВременныйФайл(Знач Путь) Экспорт
	
	Если НЕ ЭтоИмяВременногоФайла(Путь) Тогда
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Неверное значение параметра %1 в %2:
				|Файл не является временным ""%3"".';
				|en = 'Invalid value of parameter %1 in %2:
				|The file is not temporary ""%3"".'"), 
			"Путь", "ФайловаяСистема.УдалитьВременныйФайл", Путь);
	КонецЕсли;
	
	УдалитьВременныеФайлы(Путь);
	
КонецПроцедуры

// Формирует уникальное имя файла в указанной папке, при необходимости добавляя к имени файла порядковый номер,
// например: "файл (2).txt", "файл (3).txt" и т.п.
//
// Параметры:
//   ИмяФайла - Строка - полное имя файла с папкой, например, "C:\Документы\файл.txt".
//
// Возвращаемое значение:
//   Строка - например, "C:\Документы\файл (2).txt", если "файл.txt" уже существует в указанной папке.
//
Функция УникальноеИмяФайла(Знач ИмяФайла) Экспорт
	
	Возврат ФайловаяСистемаСлужебныйКлиентСервер.УникальноеИмяФайла(ИмяФайла);

КонецФункции

#КонецОбласти

#Область ЗапускВнешнихПриложений

////////////////////////////////////////////////////////////////////////////////
// Процедуры и функции для работы с внешними приложениями.

// Конструктор параметров для ФайловаяСистема.ЗапуститьПрограмму.
//
// Возвращаемое значение:
//  Структура:
//    * ТекущийКаталог - Строка - задает текущий каталог запускаемого приложения.
//    * ДождатьсяЗавершения - Булево - Ложь - дожидаться завершения запущенного приложения 
//         перед продолжением работы.
//    * ПолучитьПотокВывода - Булево - Ложь - результат, направленный в поток stdout,
//         если не указан ДождатьсяЗавершения - игнорируется.
//    * ПолучитьПотокОшибок - Булево - Ложь - ошибки, направленные в поток stderr,
//         если не указан ДождатьсяЗавершения - игнорируется.
//    * КодировкаПотоков - КодировкаТекста
//                       - Строка - кодировка, используемая для чтения stdout и stderr.
//         По умолчанию используется для Windows "CP866", для остальных - "UTF-8".
//    * КодировкаИсполнения - Строка
//                          - Число - кодировка, устанавливаемая в Windows с помощью команды chcp,
//             возможные значения: "OEM", "CP866", "UTF8" или номер кодовой страницы.
//         В Linux устанавливается переменной окружения "LANGUAGE" для конкретной команды,
//             возможные значения можно определить выполнив команду "locale -a", например "ru_RU.UTF-8".
//         В MacOS игнорируется.
//
Функция ПараметрыЗапускаПрограммы() Экспорт
	
	Параметры = Новый Структура;
	Параметры.Вставить("ТекущийКаталог", "");
	Параметры.Вставить("ДождатьсяЗавершения", Ложь);
	Параметры.Вставить("ПолучитьПотокВывода", Ложь);
	Параметры.Вставить("ПолучитьПотокОшибок", Ложь);
	Параметры.Вставить("КодировкаПотоков", Неопределено);
	Параметры.Вставить("КодировкаИсполнения", Неопределено);
	
	Возврат Параметры;
	
КонецФункции

// Запускает внешнюю программу на исполнение (например, *.exe, *bat), 
// или системную команду (например, ping, tracert или traceroute, обращаться к rac-клиенту),
// Позволяет также получать код возврата и значения потоков вывода (stdout) и ошибок (stderr)
//
// При запуске внешней программы в пакетном режиме поток вывода и поток ошибок может возвращаться на не ожидаемом языке. 
// Для того чтобы передать внешней программе язык, на котором ожидается результат следует:
// - указать язык в параметре запуска этой программы (если такой параметр предусмотрен). 
//   Например, в пакетном режиме платформы 1С:Предприятие предусмотрен ключ "/L en";
// - в других случаях явно установить кодировку исполнения пакетной команды.
//   См. свойство КодировкаИсполнения возвращаемого значения ФайловаяСистема.ПараметрыЗапускаПрограммы. 
//
// Параметры:
//  КомандаЗапуска - Строка - командная строка для запуска программы.
//                 - Массив - первый элемент массива, путь к исполняемому приложению, 
//                            остальные элементы массива - это передаваемые параметры,
//                            массив соответствует тому, который получит вызываемая программа в argv.
//  ПараметрыЗапускаПрограммы - см. ФайловаяСистема.ПараметрыЗапускаПрограммы
//
// Возвращаемое значение:
//  Структура:
//    * КодВозврата - Число  - код возврата программы;
//    * ПотокВывода - Строка - результат работы программы, направленный в поток stdout;
//    * ПотокОшибок - Строка - ошибки исполнения программы, направленные в поток stderr.
//
// Пример:
//	// Простой запуск
//	ФайловаяСистема.ЗапуститьПрограмму("calc");
//	
//	// Запуск с ожиданием завершения
//	ПараметрыЗапускаПрограммы = ФайловаяСистема.ПараметрыЗапускаПрограммы();
//	ПараметрыЗапускаПрограммы.ДождатьсяЗавершения = Истина;
//	ФайловаяСистема.ЗапуститьПрограмму("C:\Program Files\1cv8\common\1cestart.exe", 
//		ПараметрыЗапускаПрограммы);
//	
//	// Запуск с ожиданием завершения и получением потока вывода
//	ПараметрыЗапускаПрограммы = ФайловаяСистема.ПараметрыЗапускаПрограммы();
//	ПараметрыЗапускаПрограммы.ДождатьсяЗавершения = Истина;
//	ПараметрыЗапускаПрограммы.ПолучитьПотокВывода = Истина;
//	Результат = ФайловаяСистема("ping 127.0.0.1 -n 5", ПараметрыЗапускаПрограммы);
//	ОбщегоНазначений.СообщитьПользователю(Результат.ПотокВывода);
//
//	// Запуск с ожиданием завершения и получением потока вывода и с конкатенацией команды запуска
//	ПараметрыЗапускаПрограммы = ФайловаяСистема.ПараметрыЗапускаПрограммы();
//	ПараметрыЗапускаПрограммы.ДождатьсяЗавершения = Истина;
//	ПараметрыЗапускаПрограммы.ПолучитьПотокВывода = Истина;
//	КомандаЗапуска = Новый Массив;
//	КомандаЗапуска.Добавить("ping");
//	КомандаЗапуска.Добавить("127.0.0.1");
//	КомандаЗапуска.Добавить("-n");
//	КомандаЗапуска.Добавить(5);
//	Результат = ФайловаяСистема.ЗапуститьПрограмму(КомандаЗапуска, ПараметрыЗапускаПрограммы);
//	ОбщегоНазначений.СообщитьПользователю(Результат.ПотокВывода);
//
Функция ЗапуститьПрограмму(Знач КомандаЗапуска, ПараметрыЗапускаПрограммы = Неопределено) Экспорт 
	
	// АПК:534-выкл методы безопасного запуска обеспечиваются этой функцией
	
	СтрокаКоманды = ОбщегоНазначенияСлужебныйКлиентСервер.БезопаснаяСтрокаКоманды(КомандаЗапуска);
	
	Если ПараметрыЗапускаПрограммы = Неопределено Тогда 
		ПараметрыЗапускаПрограммы = ПараметрыЗапускаПрограммы();
	КонецЕсли;
	
	ТекущийКаталог = ПараметрыЗапускаПрограммы.ТекущийКаталог;
	ДождатьсяЗавершения = ПараметрыЗапускаПрограммы.ДождатьсяЗавершения;
	ПолучитьПотокВывода = ПараметрыЗапускаПрограммы.ПолучитьПотокВывода;
	ПолучитьПотокОшибок = ПараметрыЗапускаПрограммы.ПолучитьПотокОшибок;
	КодировкаПотоков = ПараметрыЗапускаПрограммы.КодировкаПотоков;
	КодировкаИсполнения = ПараметрыЗапускаПрограммы.КодировкаИсполнения;
	
	ПроверитьТекущийКаталог(СтрокаКоманды, ТекущийКаталог);
	
	Если ДождатьсяЗавершения Тогда 
		Если ПолучитьПотокВывода Тогда 
			ИмяФайлаПотокаВывода = ПолучитьИмяВременногоФайла("stdout.tmp");
			СтрокаКоманды = СтрокаКоманды + " > """ + ИмяФайлаПотокаВывода + """";
		КонецЕсли;
		
		Если ПолучитьПотокОшибок Тогда 
			ИмяФайлаПотокаОшибок = ПолучитьИмяВременногоФайла("stderr.tmp");
			СтрокаКоманды = СтрокаКоманды + " 2>""" + ИмяФайлаПотокаОшибок + """";
		КонецЕсли;
	КонецЕсли;
	
	Если КодировкаПотоков = Неопределено Тогда 
		КодировкаПотоков = КодировкаСтандартныхПотоков();
	КонецЕсли;
	
	// Для cmd не всегда активна текущая кодовая страница, поэтому всегда задаем по-умолчанию.
	Если КодировкаИсполнения = Неопределено И ОбщегоНазначения.ЭтоWindowsСервер() Тогда 
		КодировкаИсполнения = "CP866";
	КонецЕсли;
	
	КодВозврата = Неопределено;
	
	Если ОбщегоНазначения.ЭтоWindowsСервер() Тогда
		
		СтрокаКоманды = ОбщегоНазначенияСлужебныйКлиентСервер.СтрокаЗапускаКомандыWindows(
			СтрокаКоманды, ТекущийКаталог, ДождатьсяЗавершения, КодировкаИсполнения);
		
		Если ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
			// В файловой информационной базе показывать окно консоли не следует и в серверном контексте.
			Оболочка = Новый COMОбъект("Wscript.Shell");
			КодВозврата = Оболочка.Run(СтрокаКоманды, 0, ДождатьсяЗавершения);
			Оболочка = Неопределено;
		Иначе
			ЗапуститьПриложение(СтрокаКоманды,, ДождатьсяЗавершения, КодВозврата);
		КонецЕсли;
		
	Иначе
		
		Если ОбщегоНазначения.ЭтоLinuxСервер() И ЗначениеЗаполнено(КодировкаИсполнения) Тогда
			СтрокаКоманды = "LANGUAGE=" + КодировкаИсполнения + " " + СтрокаКоманды;
		КонецЕсли;
		
		ЗапуститьПриложение(СтрокаКоманды, ТекущийКаталог, ДождатьсяЗавершения, КодВозврата);
	КонецЕсли;
	
	ПотокВывода = "";
	ПотокОшибок = "";
	
	Если ДождатьсяЗавершения Тогда 
		Если ПолучитьПотокВывода Тогда
			ПотокВывода = ПрочитатьФайлЕслиСуществует(ИмяФайлаПотокаВывода, КодировкаПотоков);
			УдалитьВременныйФайл(ИмяФайлаПотокаВывода);
		КонецЕсли;
		
		Если ПолучитьПотокОшибок Тогда 
			ПотокОшибок = ПрочитатьФайлЕслиСуществует(ИмяФайлаПотокаОшибок, КодировкаПотоков);
			УдалитьВременныйФайл(ИмяФайлаПотокаОшибок);
		КонецЕсли;
	КонецЕсли;
	
	Результат = Новый Структура;
	Результат.Вставить("КодВозврата", КодВозврата);
	Результат.Вставить("ПотокВывода", ПотокВывода);
	Результат.Вставить("ПотокОшибок", ПотокОшибок);
	
	Возврат Результат;
	
	// АПК:534-вкл
	
КонецФункции

#КонецОбласти

// Возвращает путь к общему сетевому каталогу временных файлов.
//
// Для корректной работы программы в клиент-серверном варианте временные файлы 
// следует размещать в общем сетевом каталоге, одинаково доступном с любого сервера в кластере. 
// Это обеспечит доступ со всех серверов кластера к временному файлу, например, 
// для его обработки в фоновых заданиях, работающих параллельно
// Путь к каталогу определяется в общих настройках администрирования.
// Если путь не заполнен или информационная база развернута в файловом варианте, то каталог 
// создается во временном каталоге пользователя.
// Следует удалять временные файлы в каталоге самостоятельно после их использования,
// т.к. при активном создании файлов временные файлы могут занять значительную часть дискового пространства.
//
// Параметры:
//  ВложенныйКаталог - Строка - если указан, то внутри общего сетевого каталога будет создан подчиненный каталог.
// 
// Возвращаемое значение:
//  Строка - путь к каталогу временных файлов.
//
Функция ОбщийКаталогВременныхФайлов(ВложенныйКаталог = Неопределено) Экспорт
	
	Если ОбщегоНазначения.ИнформационнаяБазаФайловая() И НЕ ОбщегоНазначения.РежимОтладки() Тогда
		
		Возврат ИмяКаталогаВременныхФайлов(ВложенныйКаталог);
		
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	ОбщийТипПлатформы = "";
	Если ОбщегоНазначения.ЭтоWindowsСервер() Тогда
		
		Результат         = Константы.КаталогВременныхФайловДляWindows.Получить();
		ОбщийТипПлатформы = "Windows";
		
	Иначе
		
		Результат         = Константы.КаталогВременныхФайловДляLinux.Получить();
		ОбщийТипПлатформы = "Linux";
		
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Если ПустаяСтрока(Результат) Тогда
		
		Возврат ИмяКаталогаВременныхФайлов(ВложенныйКаталог);
		
	Иначе
		
		Результат = СокрЛП(Результат);
		
		Каталог = Новый Файл(Результат);
		Если Не Каталог.Существует() Тогда
			
			ПредставлениеКонстанты = ?(ОбщийТипПлатформы = "Windows", 
				Метаданные.Константы.КаталогВременныхФайловДляWindows.Представление(),
				Метаданные.Константы.КаталогВременныхФайловДляLinux.Представление());
			
			ШаблонСообщения = НСтр("ru = 'Каталог временных файлов не существует.
					|Необходимо убедиться, что в настройках приложения задано правильное значение параметра
					|""%1"".';
					|en = 'Temporary file directory does not exist.
					|Ensure that the value is valid for the parameter:
					|""%1"".'", ОбщегоНазначения.КодОсновногоЯзыка());
			
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения, ПредставлениеКонстанты);
			ВызватьИсключение(ТекстСообщения);
			
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ВложенныйКаталог) Тогда
			Результат = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(Результат) + ВложенныйКаталог;
			СоздатьКаталог(Результат);
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции
	
#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура УдалитьВременныеФайлы(Знач Путь)
	
	Попытка
		УдалитьФайлы(Путь);
	Исключение
		ЗаписьЖурналаРегистрации(
			НСтр("ru = 'Стандартные подсистемы';
				|en = 'Standard subsystems'", ОбщегоНазначения.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Предупреждение,,, // АПК:154 Не ошибка, а предупреждение.
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Не удалось удалить временный файл ""%1"" по причине:
					|%2';
					|en = 'Cannot delete temporary file %1. Reason:
					|%2'"),
				Путь,
				ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке())));
	КонецПопытки;
	
КонецПроцедуры

Функция ЭтоИмяВременногоФайла(Путь)
	
	// Ожидается, что Путь получен методом ПолучитьИмяВременногоФайла().
	// Перед проверкой разворачиваем слэши в одну сторону.
	Возврат СтрНачинаетсяС(СтрЗаменить(Путь, "/", "\"), СтрЗаменить(КаталогВременныхФайлов(), "/", "\"));
	
КонецФункции

#Область ЗапуститьПрограмму

Процедура ПроверитьТекущийКаталог(СтрокаКоманды, ТекущийКаталог)
	
	Если Не ПустаяСтрока(ТекущийКаталог) Тогда 
		
		ФайлИнфо = Новый Файл(ТекущийКаталог);
		
		Если Не ФайлИнфо.Существует() Тогда 
			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Не удалось запустить приложение
				           |%1
				           |по причине:
				           |Не существует каталог %2
				           |%3';
				           |en = 'Cannot start
				           |%1.
				           |Reason:
				           |The %2 directory does not exist
				           |%3'"),
				СтрокаКоманды, "ТекущийКаталог", ТекущийКаталог);
		КонецЕсли;
		
		Если Не ФайлИнфо.ЭтоКаталог() Тогда 
			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Не удалось запустить приложение
				           |%1
				           |по причине:
				           |%2 не является каталогом 
				           |%3';
				           |en = 'Cannot start
				           |%1.
				           |Reason:
				           |%2 is not a directory:
				           |%3'"),
				СтрокаКоманды, "ТекущийКаталог", ТекущийКаталог);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Функция ИмяКаталогаВременныхФайлов(ВложенныйКаталог)
	
	Результат = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(КаталогВременныхФайлов());
	Если ЗначениеЗаполнено(ВложенныйКаталог) Тогда
		Результат = Результат + ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(ВложенныйКаталог);
	КонецЕсли;
	
	СоздатьКаталог(Результат);
	
	Возврат Результат;
	
КонецФункции

Функция ПрочитатьФайлЕслиСуществует(Путь, Кодировка)
	
	Результат = Неопределено;
	ФайлИнфо = Новый Файл(Путь);
	
	Если ФайлИнфо.Существует() Тогда 
		
		ЧтениеПотокаОшибок = Новый ЧтениеТекста(Путь, Кодировка);
		Результат = ЧтениеПотокаОшибок.Прочитать();
		ЧтениеПотокаОшибок.Закрыть();
		
	КонецЕсли;
	
	Если Результат = Неопределено Тогда 
		Результат = "";
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Возвращает кодировку стандартных поток вывода и ошибок, используемую в текущей ОС.
//
// Возвращаемое значение:
//  КодировкаТекста
//
Функция КодировкаСтандартныхПотоков()
	
	Если ОбщегоНазначения.ЭтоWindowsСервер() Тогда
		Кодировка = "CP866";
	Иначе
		Кодировка = "UTF-8";
	КонецЕсли;
	
	Возврат Кодировка;
	
КонецФункции

#КонецОбласти

#КонецОбласти