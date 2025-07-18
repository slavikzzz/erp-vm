///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2025, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОписаниеПеременных

Перем ПолеСтрокаСообщенияОбОшибке; // Строка - переменная содержит строку с сообщением об ошибке.

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// Экспортные служебные процедуры и функции.

// Выполняет действия при создании нового обмена данными:
// - создает или обновляет узлы текущего плана обмена
// - загружает правила конвертации данными из макета текущего плана обмена (если НЕ РИБ)
// - загружает правила регистрации данными из макета текущего плана обмена
// - загружает настройки транспорта сообщений обмена
// - устанавливает значение константы префикса информационной базы (если не задано)
// - выполняет регистрацию всех данных на текущем узле плана обмена с учетом правил регистрации объектов.
//
// Параметры:
//  Отказ - Булево - флаг отказа; поднимается в случае возникновения ошибок при работе процедуры.
// 
Процедура ВыполнитьДействияПоНастройкеНовогоОбменаДанными(Отказ,
	НастройкаОтборовНаУзле,
	ЗначенияПоУмолчаниюНаУзле,
	РегистрироватьДанныеДляВыгрузки = Истина,
	ИспользоватьНастройкиТранспорта = Истина)
	
	КодЭтогоУзла = ?(ИспользоватьПрефиксыДляНастройкиОбмена,
					ПолучитьКодУзлаЭтойБазы(ПрефиксИнформационнойБазыИсточника),
					ПолучитьКодУзлаЭтойБазы(ИдентификаторИнформационнойБазыИсточника));
	Если ВариантРаботыМастера = "ПродолжитьНастройкуОбменаДанными" Тогда
		КодНовогоУзла = КодНовогоУзлаВторойБазы;
	ИначеЕсли ИспользоватьПрефиксыДляНастройкиОбмена Тогда
		КодНовогоУзла = ОбменДаннымиСервер.КодУзлаПланаОбменаСтрокой(ПрефиксИнформационнойБазыПриемника);
	Иначе
		КодНовогоУзла = ИдентификаторИнформационнойБазыПриемника;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	НачатьТранзакцию();
	Попытка
		// Создаем/обновляем узлы плана обмена.
		СоздатьОбновитьУзлыПланаОбмена(НастройкаОтборовНаУзле, ЗначенияПоУмолчаниюНаУзле, КодЭтогоУзла, КодНовогоУзла);
		
		Если ИспользоватьНастройкиТранспорта Тогда
			
			// Загружаем настройки транспорта сообщений.
			ОбновитьНастройкиТранспортаСообщенийОбмена();
			
		КонецЕсли;
		
		// Обновляем значение константы префикса ИБ.
		Если ИспользоватьПрефиксыДляНастройкиОбмена
			И Не ПрефиксИнформационнойБазыИсточникаУстановлен Тогда
			
			ОбновитьЗначениеКонстантыПрефиксаИнформационнойБазы();
			
		КонецЕсли;
		
		Если ЭтоНастройкаРаспределеннойИнформационнойБазы
			И ВариантРаботыМастера = "ПродолжитьНастройкуОбменаДанными" Тогда
			
			Константы.НастройкаПодчиненногоУзлаРИБЗавершена.Установить(Истина);
			Константы.ИспользоватьСинхронизациюДанных.Установить(Истина);
			Константы.НеИспользоватьРазделениеПоОбластямДанных.Установить(Истина);
			
			// Правила обмена не мигрируют в РИБ, поэтому выполняем загрузку правил.
			ОбменДаннымиСервер.ВыполнитьОбновлениеПравилДляОбменаДанными();
			
		КонецЕсли;
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		СообщитьИнформациюОбОшибке(ИнформацияОбОшибке(), Отказ);
		Возврат;
	КонецПопытки;
	
	// Обновляем повторно используемые значения МРО.
	ОбменДаннымиСлужебный.ПроверитьКэшМеханизмаРегистрацииОбъектов();
	
	Попытка
		
		Если РегистрироватьДанныеДляВыгрузки
			И Не ЭтоНастройкаРаспределеннойИнформационнойБазы Тогда
			
			// Выполняем регистрацию изменений на узле плана обмена.
			ЗарегистрироватьИзмененияДляОбмена(Отказ);
			
		КонецЕсли;
		
	Исключение
		СообщитьИнформациюОбОшибке(ИнформацияОбОшибке(), Отказ);
		Возврат;
	КонецПопытки;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Для работы через внешнее соединение.

// Выполняет регистрацию изменений на узле плана обмена.
//
Процедура ВнешнееСоединениеЗарегистрироватьИзмененияДляОбмена() Экспорт
	
	// Выполняем регистрацию изменений на узле плана обмена.
	ЗарегистрироватьИзмененияДляОбмена(Ложь);
	
КонецПроцедуры

// Читает настройки помощника обмена из строки XML.
//
Процедура ВнешнееСоединениеВыполнитьЗагрузкуПараметровМастера(Отказ, СтрокаXML) Экспорт
	
	ВыполнитьЗагрузкуПараметровМастера(Отказ, СтрокаXML);
	
КонецПроцедуры

// Обновляет настройки узла обмена данными через внешнее соединение, устанавливает значения по умолчанию.
//
Процедура ВнешнееСоединениеОбновитьНастройкиОбменаДанными(ЗначенияПоУмолчаниюНаУзле) Экспорт
	
	НачатьТранзакцию();
	Попытка
		Блокировка = Новый БлокировкаДанных;
	    ЭлементБлокировки = Блокировка.Добавить(ОбщегоНазначения.ИмяТаблицыПоСсылке(УзелИнформационнойБазы));
	    ЭлементБлокировки.УстановитьЗначение("Ссылка", УзелИнформационнойБазы);
	    Блокировка.Заблокировать();
		
		// Обновляем настройки для узла.
		ЗаблокироватьДанныеДляРедактирования(УзелИнформационнойБазы);
		УзелИнформационнойБазыОбъект = УзелИнформационнойБазы.ПолучитьОбъект();
		
		// Установка значений по умолчанию.
		ОбменДаннымиСобытия.УстановитьЗначенияПоУмолчаниюНаУзле(УзелИнформационнойБазыОбъект, ЗначенияПоУмолчаниюНаУзле);
		
		УзелИнформационнойБазыОбъект.ДополнительныеСвойства.Вставить("ПолучениеСообщенияОбмена");
		УзелИнформационнойБазыОбъект.Записать();
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

// Выполняет выгрузку параметров помощника во временное хранилище для продолжения настройки обмена во второй базе.
//
// Параметры:
//  Отказ - Булево - флаг отказа; поднимается в случае возникновения ошибок при работе процедуры.
//  АдресВременногоХранилища - Строка - при успешной выгрузке xml-файла с настройками
//                                      в эту переменную записывается адрес временного хранилища,
//                                      по которому будут доступны данные файла на сервере и на клиенте.
// 
Процедура ВыполнитьВыгрузкуПараметровМастераВоВременноеХранилище(Отказ, АдресВременногоХранилища) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	// Получаем имя временного файла в локальной ФС на сервере.
	ИмяВременногоФайла = ПолучитьИмяВременногоФайла("xml");
	
	МодульПомощникНастройки = ОбменДаннымиСервер.МодульПомощникСозданияОбменаДанными();
	Попытка
		МодульПомощникНастройки.НастройкиПодключенияВXML(ЭтотОбъект, ИмяВременногоФайла);
	Исключение
		СообщитьИнформациюОбОшибке(ИнформацияОбОшибке(), Отказ);
		ФайловаяСистема.УдалитьВременныйФайл(ИмяВременногоФайла);
		Возврат;
	КонецПопытки;
	
	АдресВременногоХранилища = ПоместитьВоВременноеХранилище(Новый ДвоичныеДанные(ИмяВременногоФайла));
	
	ФайловаяСистема.УдалитьВременныйФайл(ИмяВременногоФайла);
	
КонецПроцедуры

// Выполняет действия при создании нового обмена данными через веб-сервис.
// Подробное описание см. в процедуре ВыполнитьДействияПоНастройкеНовогоОбменаДанными.
//
Процедура ВебСервисВыполнитьДействияПоНастройкеНовогоОбменаДанными(Отказ, НастройкаОтборовНаУзле, ЗначенияПоУмолчаниюНаУзле) Экспорт
	
	НастройкаОтборовНаУзле    = ПолучитьЗначенияНастройкиОтборов(НастройкаОтборовНаУзле);
	ЗначенияПоУмолчаниюНаУзле = ПолучитьЗначенияНастройкиОтборов(ЗначенияПоУмолчаниюНаУзле);
	Если ИспользоватьПрефиксыДляНастройкиОбмена Тогда
		ПрефиксИнформационнойБазыИсточникаУстановлен = ЗначениеЗаполнено(ПолучитьФункциональнуюОпцию("ПрефиксИнформационнойБазы"));
	КонецЕсли;

	// {Обработчик: ПриПолученииДанныхОтправителя} Начало
	Если ОбменДаннымиСервер.ЕстьАлгоритмМенеджераПланаОбмена("ПриПолученииДанныхОтправителя",ИмяПланаОбмена) Тогда
		Попытка
			ПланыОбмена[ИмяПланаОбмена].ПриПолученииДанныхОтправителя(НастройкаОтборовНаУзле, Ложь);
		Исключение
			СообщитьИнформациюОбОшибке(ИнформацияОбОшибке(), Отказ);
			Возврат;
		КонецПопытки;
	КонецЕсли;
	// {Обработчик: ПриПолученииДанныхОтправителя} Окончание
	
	ВидТранспортаСообщенийОбмена = Перечисления.ВидыТранспортаСообщенийОбмена.WSПассивныйРежим;
	
	ВыполнитьДействияПоНастройкеНовогоОбменаДанными(Отказ,
													НастройкаОтборовНаУзле,
													ЗначенияПоУмолчаниюНаУзле,
													Ложь,
													Истина);
	
	Если Отказ Тогда
		УдалитьНастройкуОбменаДанными();
	КонецЕсли;
	
КонецПроцедуры

Процедура УдалитьНастройкуОбменаДанными()
	
	МенеджерПланаОбмена = ПланыОбмена[ИмяПланаОбмена];
	УдаляемыйУзел = МенеджерПланаОбмена.НайтиПоКоду(КодНовогоУзлаВторойБазы);
	
	Если Не УдаляемыйУзел.Пустая() Тогда
		ОбменДаннымиСервер.УдалитьНастройкуСинхронизации(УдаляемыйУзел);
	КонецЕсли;
	
КонецПроцедуры

// Инициализирует настройки узла обмена.
//
Процедура Инициализация(Узел) Экспорт
	
	ИмяПланаОбмена = ОбменДаннымиПовтИсп.ПолучитьИмяПланаОбмена(Узел);
	ИмяПланаОбменаКорреспондента = ИмяПланаОбмена;
	ЭтотУзел = ПланыОбмена[ИмяПланаОбмена].ЭтотУзел();
	РеквизитыЭтогоУзла = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ЭтотУзел, "Код, Наименование");
	КодУзла = РеквизитыЭтогоУзла.Код;
	НаименованиеЭтойБазы = РеквизитыЭтогоУзла.Наименование;
	ПрефиксИнформационнойБазыИсточника = РеквизитыЭтогоУзла.Код;
	
	УзелИнформационнойБазы = Узел;
	РеквизитыУзла = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Узел, "Код, Наименование");
	КодУзлаКорреспондента = РеквизитыУзла.Код;
	НаименованиеВторойБазы = РеквизитыУзла.Наименование;
	ПрефиксИнформационнойБазыПриемника = РеквизитыУзла.Код;

	ИспользоватьПрефиксыДляНастройкиОбмена = Не (ОбменДаннымиСервер.ЭтоПланОбменаXDTO(ИмяПланаОбмена)
		И ОбменДаннымиXDTOСервер.ПоддерживаетсяВерсияСИдентификаторомОбменаДанными(ПланыОбмена[ИмяПланаОбмена].ПустаяСсылка()));
		
	Если ИспользоватьПрефиксыДляНастройкиОбмена Тогда
		Если ОбщегоНазначения.РазделениеВключено() Тогда
			ПрефиксИнформационнойБазыИсточника = ОбменДаннымиСервер.КодПредопределенногоУзлаПланаОбмена(ИмяПланаОбмена);
		Иначе
			ПрефиксИнформационнойБазыИсточника = ПолучитьФункциональнуюОпцию("ПрефиксИнформационнойБазы");
		КонецЕсли;
		ПрефиксИнформационнойБазыИсточникаУстановлен = ЗначениеЗаполнено(ПрефиксИнформационнойБазыИсточника);
	Иначе
		КодПредопределенногоУзла = ОбменДаннымиСервер.КодПредопределенногоУзлаПланаОбмена(ИмяПланаОбмена);
		ИдентификаторИнформационнойБазыИсточника = КодПредопределенногоУзла;
		ПрефиксИнформационнойБазыПриемникаУстановлен = Ложь;
		ПрефиксИнформационнойБазыИсточникаУстановлен = Истина;
	КонецЕсли;
	
	Если Не ПрефиксИнформационнойБазыИсточникаУстановлен
		И ИспользоватьПрефиксыДляНастройкиОбмена Тогда
		ОбменДаннымиПереопределяемый.ПриОпределенииПрефиксаИнформационнойБазыПоУмолчанию(ПрефиксИнформационнойБазыИсточника);
	КонецЕсли;
	
	НастройкиТранспорта = ТранспортСообщенийОбмена.НастройкиТранспортаПоУмолчанию(Узел, ИдентификаторТранспорта);

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Функции-свойства

// Сообщение об ошибке при обмене данными.
//
// Возвращаемое значение:
//  Строка - сообщение об ошибке при обмене данными.
//
Функция СтрокаСообщенияОбОшибке() Экспорт
	
	Если ТипЗнч(ПолеСтрокаСообщенияОбОшибке) <> Тип("Строка") Тогда
		
		ПолеСтрокаСообщенияОбОшибке = "";
		
	КонецЕсли;
	
	Возврат ПолеСтрокаСообщенияОбОшибке;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Вспомогательные служебные процедуры и функции.

Процедура СоздатьОбновитьУзлыПланаОбмена(НастройкаОтборовНаУзле, ЗначенияПоУмолчаниюНаУзле, КодЭтогоУзла, КодНовогоУзла)
	
	МенеджерПланаОбмена = ПланыОбмена[ИмяПланаОбмена]; // ПланОбменаМенеджер
	
	// ОБНОВЛЯЕМ ЭТОТ УЗЕЛ ПРИ НЕОБХОДИМОСТИ
	
	// Получение ссылки на этот узел плана обмена.
	ЭтотУзел = МенеджерПланаОбмена.ЭтотУзел();
	
	КодЭтогоУзлаВБазе = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ЭтотУзел, "Код");
	ЭтоПланОбменаРИБ  = ОбменДаннымиПовтИсп.ЭтоПланОбменаРаспределеннойИнформационнойБазы(ИмяПланаОбмена);
	
	Если ПустаяСтрока(ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ЭтотУзел, "Код"))
		Или (ЭтоПланОбменаРИБ И КодЭтогоУзлаВБазе <> КодЭтогоУзла)
		Или (ИспользоватьПрефиксыДляНастройкиОбмена И КодЭтогоУзлаВБазе <> КодЭтогоУзла) Тогда
		
		НачатьТранзакцию();
		Попытка
		    Блокировка = Новый БлокировкаДанных;
		    ЭлементБлокировки = Блокировка.Добавить(ОбщегоНазначения.ИмяТаблицыПоСсылке(ЭтотУзел));
		    ЭлементБлокировки.УстановитьЗначение("Ссылка", ЭтотУзел);
		    Блокировка.Заблокировать();
		    
		    ЭтотУзелОбъект = ЭтотУзел.ПолучитьОбъект();
			ЭтотУзелОбъект.Код = КодЭтогоУзла;
			ЭтотУзелОбъект.Наименование = НаименованиеЭтойБазы;
			ЭтотУзелОбъект.ДополнительныеСвойства.Вставить("ПолучениеСообщенияОбмена");
			ЭтотУзелОбъект.Записать();

		    ЗафиксироватьТранзакцию();
		Исключение
		    ОтменитьТранзакцию();
			ВызватьИсключение;
		КонецПопытки;
		
	КонецЕсли;
	
	// ПОЛУЧАЕМ УЗЕЛ ДЛЯ ОБМЕНА
	СоздаватьНовыйУзел = Ложь;
	Если ЭтоНастройкаРаспределеннойИнформационнойБазы
		И ВариантРаботыМастера = "ПродолжитьНастройкуОбменаДанными" Тогда
		
		ГлавныйУзел = ОбменДаннымиСервер.ГлавныйУзел();
		
		Если ГлавныйУзел = Неопределено Тогда
			
			ВызватьИсключение НСтр("ru = 'Главный узел для текущей информационной базы не определен.
							|Возможно, информационная база не является подчиненным узлом в РИБ.';
							|en = 'The master node is not defined.
							|Probably this infobase is not a subordinate DIB node.'");
		КонецЕсли;
		
		НовыйУзел = ГлавныйУзел.ПолучитьОбъект();
		
	Иначе
		
		// СОЗДАЕМ/ОБНОВЛЯЕМ УЗЕЛ
		НовыйУзел = МенеджерПланаОбмена.НайтиПоКоду(КодНовогоУзла);
		СоздаватьНовыйУзел = НовыйУзел.Пустая();
		Если СоздаватьНовыйУзел Тогда
			НовыйУзел = МенеджерПланаОбмена.СоздатьУзел();
			НовыйУзел.Код = КодНовогоУзла;
		Иначе
			ВызватьИсключение НСтр("ru = 'Значение префикса первой информационной базы не уникально.
				|В системе уже существует синхронизация данных для информационной базы (программы) с указанным префиксом.';
				|en = 'The first infobase prefix is not unique.
				|A data synchronization for an infobase (application) with this prefix already exists.'");
		КонецЕсли;
		
		НовыйУзел.Наименование = НаименованиеВторойБазы;
		
		Если ОбщегоНазначения.ЕстьРеквизитОбъекта("ВариантНастройки", Метаданные.ПланыОбмена[ИмяПланаОбмена]) Тогда
			НовыйУзел.ВариантНастройки = ВариантНастройкиОбмена;
		КонецЕсли;
		
	КонецЕсли;
	
	// Установка значений отборов на новом узле.
	ОбменДаннымиСобытия.УстановитьЗначенияОтборовНаУзле(НовыйУзел, НастройкаОтборовНаУзле);
	
	// Установка значений по умолчанию на новом узле.
	ОбменДаннымиСобытия.УстановитьЗначенияПоУмолчаниюНаУзле(НовыйУзел, ЗначенияПоУмолчаниюНаУзле);
	
	// Сбрасываем счетчики сообщений.
	НовыйУзел.НомерОтправленного = 0;
	НовыйУзел.НомерПринятого     = 0;
	
	Если ОбщегоНазначения.РазделениеВключено()
		И ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных()
		И ОбменДаннымиСервер.ЭтоРазделенныйПланОбменаБСП(ИмяПланаОбмена) Тогда
		
		НовыйУзел.РегистрироватьИзменения = Истина;
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(СсылкаНового) Тогда
		НовыйУзел.УстановитьСсылкуНового(СсылкаНового);
	КонецЕсли;
	
	НовыйУзел.ОбменДанными.Загрузка = Истина;
	НовыйУзел.Записать();
	
	Если ОбменДаннымиПовтИсп.ЭтоПланОбменаXDTO(ИмяПланаОбмена) Тогда
		
		ТаблицаОбъектыБазы = ОбменДаннымиXDTOСервер.ПоддерживаемыеОбъектыФормата(ИмяПланаОбмена,
			"ОтправкаПолучение", НовыйУзел.Ссылка);
		ТаблицаОбъектыКорреспондента = ТаблицаОбъектыБазы.СкопироватьКолонки();
		
		Для Каждого СтрокаОбъектыБазы Из ТаблицаОбъектыБазы Цикл
			СтрокаОбъектыКорреспондента = ТаблицаОбъектыКорреспондента.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаОбъектыКорреспондента, СтрокаОбъектыБазы, "Версия, Объект");
			СтрокаОбъектыКорреспондента.Отправка  = СтрокаОбъектыБазы.Получение;
			СтрокаОбъектыКорреспондента.Получение = СтрокаОбъектыБазы.Отправка;
		КонецЦикла;
		
		МенеджерНастройкиXDTO = ОбщегоНазначения.ОбщийМодуль("РегистрыСведений.НастройкиОбменаДаннымиXDTO");
		МенеджерНастройкиXDTO.ОбновитьНастройки(
			НовыйУзел.Ссылка, "ПоддерживаемыеОбъекты", ТаблицаОбъектыБазы);
		МенеджерНастройкиXDTO.ОбновитьНастройкиКорреспондента(
			НовыйУзел.Ссылка, "ПоддерживаемыеОбъекты", ТаблицаОбъектыКорреспондента);
		
		СтруктураЗаписи = Новый Структура;
		СтруктураЗаписи.Вставить("УзелИнформационнойБазы",       НовыйУзел.Ссылка);
		СтруктураЗаписи.Вставить("ИмяПланаОбменаКорреспондента", ИмяПланаОбменаКорреспондента);
		
		ОбменДаннымиСлужебный.ОбновитьЗаписьВРегистрСведений(СтруктураЗаписи, "НастройкиОбменаДаннымиXDTO");
	КонецЕсли;
	
	// Общие данные узлов.
	РегистрыСведений.ОбщиеНастройкиУзловИнформационныхБаз.ОбновитьПрефиксы(
		НовыйУзел.Ссылка,
		?(ИспользоватьПрефиксыДляНастройкиОбмена, ПрефиксИнформационнойБазыИсточника, ""),
		ПрефиксИнформационнойБазыПриемника);
		
	Если Не ОбменДаннымиСервер.НастройкаСинхронизацииЗавершена(НовыйУзел.Ссылка) Тогда
		ОбменДаннымиСервер.ЗавершитьНастройкуСинхронизацииДанных(НовыйУзел.Ссылка);
	КонецЕсли;
	
	УзелИнформационнойБазы = НовыйУзел.Ссылка;
	
	Если СоздаватьНовыйУзел
		И Не ОбщегоНазначения.РазделениеВключено() Тогда
		ОбменДаннымиСервер.ВыполнитьОбновлениеПравилДляОбменаДанными();
	КонецЕсли;
	Если КодЭтогоУзла <> КодЭтогоУзлаВБазе 
		И (ИспользоватьПрефиксыДляНастройкиОбмена
			Или ИспользоватьПрефиксыДляНастройкиОбменаКорреспондента) Тогда
		// Узел в базе корреспонденте нуждается в перекодировании.
		СтруктураВременныйКод = Новый Структура("Корреспондент, КодУзла", УзелИнформационнойБазы, КодЭтогоУзла);
		ОбменДаннымиСлужебный.ДобавитьЗаписьВРегистрСведений(СтруктураВременныйКод, "ПсевдонимыПредопределенныхУзлов");
	КонецЕсли;

КонецПроцедуры

Процедура ОбновитьНастройкиТранспортаСообщенийОбмена()
	
	Если ВидТранспортаСообщенийОбмена = Перечисления.ВидыТранспортаСообщенийОбмена.WSПассивныйРежим Тогда
		
		НовыйСправочник = Справочники.НастройкиТранспортаСообщенийОбмена.СоздатьЭлемент();
		НовыйСправочник.Корреспондент = УзелИнформационнойБазы;
		НовыйСправочник.НастройкаПоУмолчанию = Истина;
		НовыйСправочник.ИдентификаторТранспорта = "ПассивныйРежим";
		НовыйСправочник.Записать();
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбновитьЗначениеКонстантыПрефиксаИнформационнойБазы()
	ЗначениеДоОбновления = ПолучитьФункциональнуюОпцию("ПрефиксИнформационнойБазы");
	
	Если ПустаяСтрока(ЗначениеДоОбновления)
		И ЗначениеДоОбновления <> ПрефиксИнформационнойБазыИсточника Тогда
		
		ОбменДаннымиСервер.УстановитьПрефиксИнформационнойБазы(СокрЛП(ПрефиксИнформационнойБазыИсточника));
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗарегистрироватьИзмененияДляОбмена(Отказ)
	
	Попытка
		ОбменДаннымиСервер.ЗарегистрироватьДанныеДляНачальнойВыгрузки(УзелИнформационнойБазы);
	Исключение
		СообщитьИнформациюОбОшибке(ИнформацияОбОшибке(), Отказ);
		Возврат;
	КонецПопытки;
	
КонецПроцедуры

Функция ПолучитьКодУзлаЭтойБазы(Знач ПрефиксИнформационнойБазыЗаданныйПользователем)
	
	Если ВариантРаботыМастера = "ПродолжитьНастройкуОбменаДанными" Тогда
		
		Если ЗначениеЗаполнено(КодПредопределенногоУзла) Тогда
			Возврат КодПредопределенногоУзла;
		Иначе
			Возврат СокрЛП(ПрефиксИнформационнойБазыЗаданныйПользователем);
		КонецЕсли;
		
	КонецЕсли;
	Если ИспользоватьПрефиксыДляНастройкиОбмена Тогда
		Если ЗначениеЗаполнено(ПрефиксИнформационнойБазыИсточника) Тогда
			Результат = ПрефиксИнформационнойБазыИсточника;
		Иначе
			Если ПустаяСтрока(Результат) Тогда
				Результат = ПрефиксИнформационнойБазыЗаданныйПользователем;
			
				Если ПустаяСтрока(Результат) Тогда
					
					Возврат "000";
					
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		Возврат ОбменДаннымиСервер.КодУзлаПланаОбменаСтрокой(Результат);
	Иначе
		Если ЗначениеЗаполнено(ИдентификаторИнформационнойБазыИсточника) Тогда 
			Возврат ИдентификаторИнформационнойБазыИсточника;
		Иначе
			Возврат "";
		КонецЕсли;
	КонецЕсли;
КонецФункции

// Читает настройки помощника обмена из строки XML.
//
Процедура ВыполнитьЗагрузкуПараметровМастера(Отказ, СтрокаXML, ИдентификаторТраспорта = "") Экспорт
	
	// Проверка возможности использования плана обмена в модели сервиса.
	Если ОбщегоНазначения.РазделениеВключено()
		И Не ОбменДаннымиПовтИсп.ПланОбменаИспользуетсяВМоделиСервиса(ИмяПланаОбмена) Тогда
		ПолеСтрокаСообщенияОбОшибке = НСтр("ru = 'Синхронизация данных с этой программой в режиме сервиса не предусмотрена.';
											|en = 'Data synchronization with this application is not available in SaaS mode.'");
		ОбменДаннымиСервер.СообщитьОбОшибке(СтрокаСообщенияОбОшибке(), Отказ);
		Возврат;
	КонецЕсли;
	
	Если ПустаяСтрока(ВариантРаботыМастера) Тогда
		ВариантРаботыМастера = "ПродолжитьНастройкуОбменаДанными";
	КонецЕсли;
	
	МодульПомощникНастройки = ОбменДаннымиСервер.МодульПомощникСозданияОбменаДанными();
	Попытка
		МодульПомощникНастройки.ЗаполнитьНастройкиПодключенияИзXML(ЭтотОбъект, СтрокаXML,,, ИдентификаторТраспорта);
	Исключение
		СообщитьИнформациюОбОшибке(ИнформацияОбОшибке(), Отказ);
	КонецПопытки;
	
КонецПроцедуры

Процедура СообщитьИнформациюОбОшибке(ИнформацияОбОшибке, Отказ)
	
	ПолеСтрокаСообщенияОбОшибке = ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке);
	
	ОбменДаннымиСервер.СообщитьОбОшибке(ОбработкаОшибок.КраткоеПредставлениеОшибки(ИнформацияОбОшибке), Отказ);
	
	ЗаписьЖурналаРегистрации(ОбменДаннымиСервер.СобытиеЖурналаРегистрацииСозданиеОбменаДанными(), УровеньЖурналаРегистрации.Ошибка,,, СтрокаСообщенияОбОшибке());
	
КонецПроцедуры

Функция ПолучитьЗначенияНастройкиОтборов(СтруктураНастроекВнешнегоСоединения)
	
	Возврат ОбменДаннымиСервер.ПолучитьЗначенияНастройкиОтборов(СтруктураНастроекВнешнегоСоединения);
	
КонецФункции

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.';
						|en = 'Invalid object call on the client.'");
#КонецЕсли