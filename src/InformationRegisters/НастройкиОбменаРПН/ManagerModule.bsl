#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Обработчик обновления БРО 1.1.11.23
Процедура ОтключитьОбменНапрямую() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	НастройкиОбменаРПН.Организация КАК Организация
		|ИЗ
		|	РегистрСведений.НастройкиОбменаРПН КАК НастройкиОбменаРПН
		|ГДЕ
		|	НастройкиОбменаРПН.ОбменНапрямую
		|	И (НастройкиОбменаРПН.Пользователь ЕСТЬ NULL
		|	ИЛИ НастройкиОбменаРПН.Пользователь = ЗНАЧЕНИЕ(Справочник.Пользователи.ПустаяСсылка))");
	
	НастройкиОбменаРПННапрямую = Запрос.Выполнить().Выгрузить();
	
	Для каждого НастройкаОбменаРПННапрямую Из НастройкиОбменаРПННапрямую Цикл
		
		МенеджерЗаписи = РегистрыСведений.НастройкиОбменаРПН.СоздатьМенеджерЗаписи();
		МенеджерЗаписи.Организация = НастройкаОбменаРПННапрямую.Организация;
		МенеджерЗаписи.Пользователь = Справочники.Пользователи.ПустаяСсылка();
		МенеджерЗаписи.Прочитать();
		
		МенеджерЗаписи.ОбменНапрямую = Ложь;
		
		Попытка
			МенеджерЗаписи.Записать();
		Исключение
			ИнформацияОбОшибке = ИнформацияОбОшибке();
			ТекстСообщения = СтрШаблон(
				НСтр("ru = 'Не удалось сохранить в информационной базе настройки обмена с Росприроднадзором для организации ""%1""
						   |%2';
						   |en = 'Не удалось сохранить в информационной базе настройки обмена с Росприроднадзором для организации ""%1""
						   |%2'"),
				Строка(НастройкаОбменаРПННапрямую.Организация),
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке));
			ЗаписьЖурналаРегистрации(
				НСтр("ru = 'Электронный документооборот с контролирующими органами. Настройки обмена с Росприроднадзором.';
					|en = 'Электронный документооборот с контролирующими органами. Настройки обмена с Росприроднадзором.'"),
				УровеньЖурналаРегистрации.Ошибка,,,
				ТекстСообщения);
		КонецПопытки;
		
	КонецЦикла;
	
КонецПроцедуры

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

Процедура СохранитьСписокПользователей(
		ОрганизацияСсылка,
		Список,
		ИспользоватьНесколько,
		СертификатСтрахователяОтпечаток = "",
		Доверенность = Неопределено) Экспорт
	
	РеквизитыНастроек = Новый Структура;
	РеквизитыНастроек.Вставить("Доверенность", Доверенность);
	
	Мультирежим.СохранитьСписокПользователейВНастройкиОбмена(
		ОрганизацияСсылка,
		Список,
		ИспользоватьНесколько,
		СертификатСтрахователяОтпечаток,
		РеквизитыНастроек,
		"НастройкиОбменаРПН",
		"СертификатАбонентаОтпечаток");
	
КонецПроцедуры
	
#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	// инициализируем контекст ЭДО - модуль обработки
	ТекстСообщения = "";
	КонтекстЭДО = ДокументооборотСКО.ПолучитьОбработкуЭДО(ТекстСообщения);
	Если КонтекстЭДО = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	КонтекстЭДО.ОбработкаПолученияФормы("РегистрСведений", "НастройкиОбменаРПН", ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли

