///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Подсистема "Интернет-поддержка пользователей".
// ОбщийМодуль.ПодключениеСервисовСопровожденияКлиент.
//
// Клиентские процедуры и функции подключения тестовых периодов:
//  - открытие формы подключения тестовых периодов;
//  - обработка результатов подключения.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Открывает форму подключения тестового периода, предварительно
// проверяя возможность подключения. Подключение может быть не доступно если:
//   - у пользователя нет прав для подключения тестового периода,
//     считается, что все сервисы не доступны;
//   - существуют необработанные запросы на подключение,
//     невозможно определить доступные тарифы;
//   - конфигурация работает в модели сервиса
//   - доступные тестовые периоды отсутствуют.
// Функцию следует использовать, если однозначно определено, что целевой сервис не подключен.
//
// Параметры:
//  Идентификатор         - Строка - идентификатор сервиса в системе Портал 1С:ИТС;
//  Форма                 - ФормаКлиентскогоПриложения - форма из которой производится подключение;
//  ОповещениеПриЗакрытии - ОписаниеОповещения - описание обработчика, который необходимо выполнить
//                          по завершению подключения. В качестве результата будет передан статус подключения:
//                          СостояниеПодключения - Перечисление.СостоянияПодключенияСервисов - 
//                          описывает состояние подключения тестового периода. Для определения статуса
//                          необходимо использовать функции программного интерфейса:
//                            - Перечисление.СостоянияПодключенияСервисов.Подключен - подключение
//                              тестового периода выполнено без ошибок;
//                            - Перечисление.СостоянияПодключенияСервисов.ОшибкаПодключения - тестовый
//                              период не подключен;
//                            - Перечисление.СостоянияПодключенияСервисов.НеПодключен - пользователь
//                              не дождался обработки заявки на подключение;
//                            - Перечисление.СостоянияПодключенияСервисов.ПодключениеНедоступно - подключение
//                              не доступно, форма не была открыта;
//                            - Перечисление.СостоянияПодключенияСервисов.Подключение - выполняется подключение
//                              тестового периода.
//
Процедура ПодключитьТестовыйПериод(
		Идентификатор,
		Форма,
		ОповещениеПриЗакрытии = Неопределено) Экспорт
	
	Состояние(, , НСтр("ru = 'Получение информации о доступных тестовых периодах';
						|en = 'Updating list of available trial periods'"));
	ОписательПодключения = ПодключениеСервисовСопровожденияВызовСервера.ТестовыеПериодыСервисаСопровождения(Идентификатор);
	Состояние();
	
	Если ОписательПодключения.Ошибка Тогда
		ПараметрыФормы = ПодключениеСервисовСопровожденияКлиентСервер.НовыйПараметрыФормыОтобразитьРезультат(
			"",
			"",
			Идентификатор,
			"",
			ОписательПодключения.ИнформацияОбОшибке,
			ПредопределенноеЗначение("Перечисление.СостоянияПодключенияСервисов.ОшибкаПодключения"));
	ИначеЕсли Не ОписательПодключения.ПодключениеДоступно Тогда
		ВыполнитьОбработкуОповещения(
			ОповещениеПриЗакрытии,
			ПредопределенноеЗначение("Перечисление.СостоянияПодключенияСервисов.ПодключениеНедоступно"));
		Возврат;
	ИначеЕсли ОписательПодключения.ПодключениеСервиса Тогда
		ДанныеОтображения = ОписательПодключения.ДанныеОтображения;
		ПараметрыФормы    = ПодключениеСервисовСопровожденияКлиентСервер.НовыйПараметрыФормыОтобразитьРезультат(
			ДанныеОтображения.ИдентификаторТестовогоПериода,
			ДанныеОтображения.НаименованиеПодключаемого,
			Идентификатор,
			ДанныеОтображения.ИдентификаторЗапроса,
			"",
			ПредопределенноеЗначение("Перечисление.СостоянияПодключенияСервисов.Подключение"),
			ДанныеОтображения.РежимРегламентногоЗадания);
	Иначе
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Идентификатор",        Идентификатор);
		ПараметрыФормы.Вставить("ОписательПодключения", ОписательПодключения);
	КонецЕсли;
	
	УникальныйИдентификатор = Неопределено;
	Если ТипЗнч(Форма) = Тип("ФормаКлиентскогоПриложения") Тогда
		УникальныйИдентификатор = Форма.УникальныйИдентификатор;
	КонецЕсли;
	
	ОткрытьФорму(
		"Обработка.ПодключениеСервисовСопровождения.Форма.ПодключениеТестовогоПериода",
		ПараметрыФормы,
		Форма,
		УникальныйИдентификатор,
		,
		,
		ОповещениеПриЗакрытии,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Получает состояние подключения "ПодключениеНедоступно".
//
// Возвращаемое значение:
//  ПеречислениеСсылка.СостоянияПодключенияСервисов - значение перечисления ПодключениеНедоступно.
//
Функция СостояниеПодключенияПодключениеНедоступно() Экспорт
	
	Возврат ПредопределенноеЗначение("Перечисление.СостоянияПодключенияСервисов.ПодключениеНедоступно");
	
КонецФункции

// Получает состояние подключения "Подключен".
//
// Возвращаемое значение:
//  ПеречислениеСсылка.СостоянияПодключенияСервисов - значение перечисления Подключен.
//
Функция СостояниеПодключенияПодключен() Экспорт
	
	Возврат ПредопределенноеЗначение("Перечисление.СостоянияПодключенияСервисов.Подключен");
	
КонецФункции

// Получает состояние подключения "НеПодключен".
//
// Возвращаемое значение:
//  ПеречислениеСсылка.СостоянияПодключенияСервисов - значение перечисления НеПодключен.
//
Функция СостояниеПодключенияНеПодключен() Экспорт
	
	Возврат ПредопределенноеЗначение("Перечисление.СостоянияПодключенияСервисов.НеПодключен");
	
КонецФункции

// Вызывается при начале работы системы из
// ИнтернетПоддержкаПользователейКлиент.ПриНачалеРаботыСистемы().
//
Процедура ПриНачалеРаботыСистемы() Экспорт
	
	Если Не ИспользоватьОповещения() Тогда
		Возврат;
	КонецЕсли;
	
	// Вызвать автоматическую проверку обработки запросов на подключение
	// тестовых периодов через 1 секунду после начала работы программы.
	ПодключитьОбработчикОжидания("ПодключениеТестовыхПериодов_ПроверитьСостояниеЗапроса", 1, Истина);
	
КонецПроцедуры

#Область НастройкаФормы

// Обработчик команды подключения тестового периода.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма подключения тестового периода.
//
Процедура КомандаПодключенияТестовогоПериода(Форма) Экспорт
	
	ДанныеПодключения = Форма.ДанныеПодключения;
	ДанныеПодключения.КоличествоИтерацийПроверки = 0;
	
	Если Форма.СостояниеПодключения = ПредопределенноеЗначение("Перечисление.СостоянияПодключенияСервисов.Подключение")
		Или ЗначениеЗаполнено(ДанныеПодключения.ИдентификаторЗапроса) Тогда
		
		ПодключениеСервисовСопровожденияКлиентСервер.УстановитьВидимостьДоступностьКнопокПодключения(
			Форма,
			Истина);
		ПодключениеТестовогоПериода(Форма);
		
	Иначе
		Если Форма.ОтобразитьРезультат Тогда
			ПодключениеСервисовСопровожденияВызовСервера.УдалитьИнформациюОЗапросеНаПодключение(
				ДанныеПодключения.ОписательСервиса.СервисСопровождения,
				ДанныеПодключения.ИдентификаторЗапроса);
		КонецЕсли;
		Если ПодключениеСервисовСопровожденияКлиентСервер.ПодключениеДоступно(Форма.СостояниеПодключения) Тогда
			Форма.СостояниеПодключения = ПредопределенноеЗначение("Перечисление.СостоянияПодключенияСервисов.НеПодключен");
			Если Не ДанныеПодключения.ФормаЗаполнена Тогда
				
				ОписаниеОповещения = Новый ОписаниеОповещения(
					"Подключаемый_ПриПодключенииТестовогоПериодаНаФорме",
					Форма);
				ВыполнитьОбработкуОповещения(
					ОписаниеОповещения,
					ПодключениеСервисовСопровожденияКлиентСервер.ИмяСобытияЗаполненияДанныхФормы());
				
			Иначе
				ПодключениеСервисовСопровожденияКлиентСервер.УстановитьВидимостьДоступностьКнопокПодключения(
					Форма,
					Истина);
				ПодключениеТестовогоПериода(Форма);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Обработчик события формы ПередЗакрытием.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма подключения тестового периода;
//  Отказ - Булево - признак отказа от закрытия формы;
//  ЗавершениеРаботы - Булево - признак завершения работы приложения;
//  ТекстПредупреждения - Строка - текст предупреждения для пользователя.
//
Процедура ПередЗакрытием(
		Форма,
		Отказ,
		ЗавершениеРаботы,
		ТекстПредупреждения) Экспорт
	
	Если ОбщегоНазначенияКлиент.РазделениеВключено() Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗавершениеРаботы Тогда
		Если ПоказатьВопросПриЗавершенииРаботыПрограммы(Форма) Тогда
			Отказ = Истина;
			ТекстПредупреждения = НСтр("ru = 'Подключение тестового периода сервиса не завершено.';
										|en = 'Test period connection not completed.'");
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"Подключаемый_ПриПодключенииТестовогоПериодаНаФорме",
		Форма);
	ВыполнитьОбработкуОповещения(
		ОписаниеОповещения,
		ПодключениеСервисовСопровожденияКлиентСервер.ИмяСобытияПередЗакрытиемФормыПодключения());
	
	Если Форма.СостояниеПодключения = ПредопределенноеЗначение("Перечисление.СостоянияПодключенияСервисов.Подключение")
		И Не Форма.ДанныеПодключения.РежимРегламентногоЗадания Тогда
		ПодключитьОбработчикПроверкиСостоянияЗапросов();
	КонецЕсли;
	
КонецПроцедуры

// Отображает страницу подключения тестового периода.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма подключения тестового периода.
//
Процедура ОтображениеТестовыхПериодов(Форма) Экспорт
	
	Элементы = Форма.Элементы;
	ПараметрыПодключения = Форма.ДанныеПодключения.ПараметрыПодключения;
	ИмяЭлементаДляРазмещения = ПараметрыПодключения.ИмяЭлементаДляРазмещения;
	ЭлементДляРазмещения = Элементы[ИмяЭлементаДляРазмещения];
	ЭлементСтраницы = ЭлементДляРазмещения.Родитель;
	ТекущаяСтраница = ЭлементСтраницы.ТекущаяСтраница;
	
	ЭлементСтраницы.ТекущаяСтраница = ЭлементДляРазмещения;
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"Подключаемый_ПриПодключенииТестовогоПериодаНаФорме",
		Форма);
	ВыполнитьОбработкуОповещения(
		ОписаниеОповещения,
		ПодключениеСервисовСопровожденияКлиентСервер.ИмяСобытияДействияПриОтображенииТестовыхПериодов());
	
	Если ПодключениеВозможно(Форма.СостояниеПодключения) Тогда
		ЭлементКомандаДалее = Элементы[ПараметрыПодключения.ИмяЭлементаКомандыДалее];
		ЭлементКомандаДалее.КнопкаПоУмолчанию = Истина;
		ЭлементКомандаДалее.Видимость = Истина;
	Иначе
		ЭлементСтраницы.ТекущаяСтраница = ТекущаяСтраница;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ПодключениеТестовогоПериода

// Подключение тестового периода.
//  - Получение идентификатора подключения;
//  - Проверка успешности подключения.
// 
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма подключения тестового периода
//
Процедура ПодключениеТестовогоПериода(Форма) Экспорт
	
	ДанныеПодключения = Форма.ДанныеПодключения;
	ОписательСервиса  = ДанныеПодключения.ОписательСервиса;
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(Форма);
	ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
	
	Если Не ЗначениеЗаполнено(ДанныеПодключения.ИдентификаторЗапроса) Тогда
		
		РезультатВыполнения = ПодключениеСервисовСопровожденияВызовСервера.ПодключениеТестовогоПериода(
			Форма.ИдентификаторТестовогоПериода,
			ОписательСервиса.СервисСопровождения,
			Форма.УникальныйИдентификатор);
			
		ДополнительныеПараметры = Новый Структура("Форма", Форма);
		Если РезультатВыполнения.Статус = "Выполнено" Тогда
			ПодключениеТестовогоПериодаЗавершение(РезультатВыполнения, ДополнительныеПараметры);
			Возврат;
		КонецЕсли;
		
		ОповещениеОЗавершении = Новый ОписаниеОповещения(
			"ПодключениеТестовогоПериодаЗавершение",
			ЭтотОбъект,
			ДополнительныеПараметры);
		
	Иначе
		
		Если ДанныеПодключения.КоличествоИтерацийПроверки >= 3 Тогда
			ПодключениеСервисовСопровожденияКлиентСервер.УстановитьВидимостьДоступностьКнопокПодключения(Форма);
			Возврат;
		КонецЕсли;
		
		ПараметрыПроверкиПодключения = Новый Структура;
		ПараметрыПроверкиПодключения.Вставить("СервисСопровождения", ОписательСервиса.СервисСопровождения);
		ПараметрыПроверкиПодключения.Вставить("Идентификатор", ДанныеПодключения.ИдентификаторЗапроса);
		ПараметрыПроверкиПодключения.Вставить("УникальныйИдентификатор", Форма.УникальныйИдентификатор);
		ПараметрыПроверкиПодключения.Вставить("РежимРегламентногоЗадания", ДанныеПодключения.РежимРегламентногоЗадания);
		ПараметрыПроверкиПодключения.Вставить("ИдентификаторТестовогоПериода", Форма.ИдентификаторТестовогоПериода);
		
		РезультатВыполнения = ПодключениеСервисовСопровожденияВызовСервера.ПроверитьПодключениеТестовогоПериода(
			ПараметрыПроверкиПодключения,
			ДанныеПодключения.КоличествоИтерацийПроверки);
			
		ДополнительныеПараметры = Новый Структура("Форма", Форма);
		Если РезультатВыполнения.Статус = "Выполнено" Тогда
			ПроверитьПодключениеТестовогоПериодаЗавершение(РезультатВыполнения, ДополнительныеПараметры);
			Возврат;
		КонецЕсли;
		
		ОповещениеОЗавершении = Новый ОписаниеОповещения(
			"ПроверитьПодключениеТестовогоПериодаЗавершение",
			ЭтотОбъект,
			ДополнительныеПараметры);
		
	КонецЕсли;
	
	ДлительныеОперацииКлиент.ОжидатьЗавершение(
		РезультатВыполнения,
		ОповещениеОЗавершении,
		ПараметрыОжидания);
	
КонецПроцедуры

// Завершение подключения тестового периода.
//  - Отображение элементов формы;
//  - Запуск проверки успешности подключения.
// 
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма подключения тестового периода.
//  ВыполнитьВФоне - Структура - см ДлительныеОперации.ВыполнитьВФоне.
//  ДополнительныеПараметры - Произвольный - Свойство оповещения.
Процедура ПодключениеТестовогоПериодаЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Форма = ДополнительныеПараметры.Форма;
	
	Если Результат.Статус = "Выполнено" Тогда
		РезультатОперации = ПолучитьИзВременногоХранилища(Результат.АдресРезультата);
		Если РезультатОперации.Ошибка Тогда
			Форма.ИнформацияОбОшибке = РезультатОперации.ИнформацияОбОшибке;
			Форма.СостояниеПодключения = ПредопределенноеЗначение("Перечисление.СостоянияПодключенияСервисов.ОшибкаПодключения");
			ПодключениеСервисовСопровожденияКлиентСервер.НастроитьОтображениеФормы(Форма);
		Иначе
			Форма.СостояниеПодключения = ПредопределенноеЗначение("Перечисление.СостоянияПодключенияСервисов.Подключение");
			Форма.ДанныеПодключения.ИдентификаторЗапроса = РезультатОперации.ИдентификаторЗапроса;
			ПодключениеТестовогоПериода(Форма);
		КонецЕсли;
	ИначеЕсли Результат.Статус = "Ошибка" Тогда
		Форма.ИнформацияОбОшибке = Результат.КраткоеПредставлениеОшибки;
		Форма.СостояниеПодключения = ПредопределенноеЗначение("Перечисление.СостоянияПодключенияСервисов.ОшибкаПодключения");
		ПодключениеСервисовСопровожденияКлиентСервер.НастроитьОтображениеФормы(Форма);
	КонецЕсли;
	
КонецПроцедуры

// Завершение проверки подключения тестового периода.
// Отображение элементов формы;
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма подключения тестового периода.
//  ВыполнитьВФоне - Структура - см ДлительныеОперации.ВыполнитьВФоне.
//  ДополнительныеПараметры - Произвольный - Свойство оповещения.
Процедура ПроверитьПодключениеТестовогоПериодаЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Форма = ДополнительныеПараметры.Форма;
	ДанныеПодключения = Форма.ДанныеПодключения;
	Если Результат.Статус = "Выполнено" Тогда
		РезультатОперации = ПолучитьИзВременногоХранилища(Результат.АдресРезультата);
		Если РезультатОперации.Ошибка Тогда
			Форма.ИнформацияОбОшибке   = РезультатОперации.ИнформацияОбОшибке;
			Форма.СостояниеПодключения = ПредопределенноеЗначение("Перечисление.СостоянияПодключенияСервисов.ОшибкаПодключения");
			ПодключениеСервисовСопровожденияКлиентСервер.НастроитьОтображениеФормы(Форма);
		Иначе
			РезультатПодключения = РезультатОперации.РезультатПодключения;
			Если РезультатПодключения.Ошибка Тогда
				Форма.ИнформацияОбОшибке   = РезультатПодключения.ИнформацияОбОшибке;
				Форма.СостояниеПодключения = ПредопределенноеЗначение("Перечисление.СостоянияПодключенияСервисов.ОшибкаПодключения");
				ПодключениеСервисовСопровожденияКлиентСервер.НастроитьОтображениеФормы(Форма);
				// Необходимо перезаполнение данных формы,
				// т.к. дальнейшая проверка состояние запроса
				// ничего не даст.
				ДанныеПодключения.Вставить("ФормаЗаполнена", Ложь);
			ИначеЕсли РезультатПодключения.Подключен Тогда
				Форма.СостояниеПодключения = ПредопределенноеЗначение("Перечисление.СостоянияПодключенияСервисов.Подключен");
				ПодключениеСервисовСопровожденияКлиентСервер.НастроитьОтображениеФормы(Форма);
				ОповещениеОПодключении = Новый ОписаниеОповещения(
					ДанныеПодключения.ПараметрыПодключения.ОбработчикПриПодключении,
					Форма);
				ВыполнитьОбработкуОповещения(ОповещениеОПодключении, Форма.СостояниеПодключения);
			Иначе
				Если ДанныеПодключения.КоличествоИтерацийПроверки >= 3 Тогда
					Форма.СостояниеПодключения = ПредопределенноеЗначение("Перечисление.СостоянияПодключенияСервисов.Подключение");
					ПодключениеСервисовСопровожденияКлиентСервер.НастроитьОтображениеФормы(Форма);
				Иначе
					ПодключениеТестовогоПериода(Форма);
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	ИначеЕсли Результат.Статус = "Ошибка" Тогда
		Форма.ИнформацияОбОшибке   = Результат.КраткоеПредставлениеОшибки;
		Форма.СостояниеПодключения = ПредопределенноеЗначение("Перечисление.СостоянияПодключенияСервисов.ОшибкаПодключения");
		ПодключениеСервисовСопровожденияКлиентСервер.НастроитьОтображениеФормы(Форма);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Выполняет обработку закрытия форму. При необходимости создает регламентное
// задание для проверки результатов подключения тестовых периодов, подключает
// обработчик ожидания и закрывает форму.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма подключения тестовых периодов.
//
Процедура ЗакрытьФормуПодключенияТестовыхПериодов(Форма) Экспорт
	
	ДанныеПодключения = Форма.ДанныеПодключения;
	Если Форма.СостояниеПодключения = ПредопределенноеЗначение("Перечисление.СостоянияПодключенияСервисов.Подключение")
		И Не ДанныеПодключения.РежимРегламентногоЗадания Тогда
		
		НаименованиеТестовогоПериода = ДанныеПодключения.ТестовыеПериоды.Получить(
			Форма.ИдентификаторТестовогоПериода);
		
		ПодключениеСервисовСопровожденияВызовСервера.СоздатьРегламентноеЗаданиеПроверкиПодключения(
			ДанныеПодключения.ОписательСервиса.СервисСопровождения,
			ДанныеПодключения.ИдентификаторЗапроса,
			Форма.ИдентификаторТестовогоПериода,
			НаименованиеТестовогоПериода);
		
		ПодключитьОбработчикПроверкиСостоянияЗапросов();
		
	КонецЕсли;
	
	Форма.ОтказПриЗакрытии = Ложь;
	Форма.Закрыть(Форма.СостояниеПодключения);
	
КонецПроцедуры

// Проверка обработки запросов на подключение тестовых периодов.
//
Процедура ПроверитьСостояниеЗапроса() Экспорт
	
	Если Не ИспользоватьОповещения() Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеОповещений = ПодключениеСервисовСопровожденияВызовСервера.ДанныеОповещенийОбОбработкеЗапросов();
	
	Для Каждого ОписательОповещения Из ДанныеОповещений.Оповещения Цикл
		
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("ПараметрыФормы", ОписательОповещения.ПараметрыФормы);
		
		ОписаниеОповещенияПриНажатии = Новый ОписаниеОповещения(
			"ПроверитьСостояниеЗапросаПриНажатии",
			ЭтотОбъект,
			ДополнительныеПараметры);
		
		ПоказатьОповещениеПользователя(
			НСтр("ru = 'Подключение тестового периода';
				|en = 'Trial period activation'"),
			ОписаниеОповещенияПриНажатии,
			ОписательОповещения.Представление,
			БиблиотекаКартинок.ИнтернетПоддержкаПользователей,
			СтатусОповещенияПользователя.Важное);
		
	КонецЦикла;
	
	Если ДанныеОповещений.ЕстьНеОбработанныеЗапросы Тогда
		ПодключитьОбработчикПроверкиСостоянияЗапросов();
	КонецЕсли;
	
КонецПроцедуры

// Обработчик нажатия на оповещение. Открывает форму подключения тестовых
// периодов и отображает состояние подключения.
//
// Параметры:
//  ДополнительныеПараметры - Структура - дополнительные параметры оповещения.
//
Процедура ПроверитьСостояниеЗапросаПриНажатии(ДополнительныеПараметры) Экспорт
	
	ОткрытьФорму(
		"Обработка.ПодключениеСервисовСопровождения.Форма.ПодключениеТестовогоПериода",
		ДополнительныеПараметры.ПараметрыФормы);
	
КонецПроцедуры

// Подключает обработчик ожидания, который выполняет проверку состояния запросов
// на подключение тестовых периодов. Если ранее уже был подключен обработчик
// ожидания, необходимо его отключить,т.к. одновременно должен работать
// только один обработчик.
//
Процедура ПодключитьОбработчикПроверкиСостоянияЗапросов()
	
	ОтключитьОбработчикОжидания("ПодключениеТестовыхПериодов_ПроверитьСостояниеЗапроса");
	ПодключитьОбработчикОжидания(
		"ПодключениеТестовыхПериодов_ПроверитьСостояниеЗапроса",
		3600,
		Истина);
	
КонецПроцедуры

// Определяет необходимость использования пользовательских оповещений.
//
// Возвращаемое значение:
//  Булево - если истина, необходимо выводить оповещения пользователю.
//
Функция ИспользоватьОповещения()
	
	Возврат Не ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ТекущиеДела");
	
КонецФункции

// Определяет необходимость вопроса при завершении работы программы
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма подключения тестового периода.
// 
// Возвращаемое значение:
//  Булево - признак необходимости вопроса.
//
Функция ПоказатьВопросПриЗавершенииРаботыПрограммы(Форма)
	
	Элементы = Форма.Элементы;
	ПараметрыПодключения = Форма.ДанныеПодключения.ПараметрыПодключения;
	ИмяЭлементаДляРазмещения = ПараметрыПодключения.ИмяЭлементаДляРазмещения;
	ЭлементДляРазмещения = Элементы[ИмяЭлементаДляРазмещения];
	
	Возврат (Форма.СостояниеПодключения = ПредопределенноеЗначение("Перечисление.СостоянияПодключенияСервисов.Подключение")
		Или ЭлементДляРазмещения.Родитель.ТекущаяСтраница = 
			Элементы[ПодключениеСервисовСопровожденияКлиентСервер.ИмяЭлемента("ГруппаДлительнаяОперация")]);
	
КонецФункции

// Определяет возможность подключения тестового периода.
//
// Возвращаемое значение:
//   Булево - Возможность подключения.
//
Функция ПодключениеВозможно(Знач СостояниеПодключения)
	
	Результат = (СостояниеПодключения <> ПредопределенноеЗначение("Перечисление.СостоянияПодключенияСервисов.Подключен")
		И СостояниеПодключения <> ПредопределенноеЗначение("Перечисление.СостоянияПодключенияСервисов.ПодключениеНедоступно"));
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти
