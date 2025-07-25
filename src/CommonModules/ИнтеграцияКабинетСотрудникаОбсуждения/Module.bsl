
#Область СлужебныйПрограммныйИнтерфейс

Процедура ПриДобавленииРазделенныхПараметровРаботыКлиентаПриЗапуске(Параметры) Экспорт
	
	СВЗарегистрирована = СистемаВзаимодействия.ИнформационнаяБазаЗарегистрирована();
	ИДОбсуждения = Неопределено;
	ИспользуютсяОбсуждения = Ложь;
	Если СВЗарегистрирована И ПолучитьФункциональнуюОпцию("ИспользуютсяОбсужденияКабинетСотрудника") Тогда
		ИспользуютсяОбсуждения = Истина;
		Ответ = ОбсуждениеДляСлужебныхОповещений();
		Если Ответ.СообщениеОбОшибке = Неопределено Тогда
			ИДОбсуждения = Строка(Ответ.ОбсуждениеСВ.Идентификатор);
		КонецЕсли;
	КонецЕсли;
	Параметры.Вставить("ИДОбсужденияДляСлужебныхОповещенийКабинетСотрудника", ИДОбсуждения);
	Параметры.Вставить("ИспользуютсяОбсужденияКабинетСотрудника", ИспользуютсяОбсуждения);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ВключитьОбсужденияФоновоеЗадание(Параметры, АдресХранилища) Экспорт

	Отказ = Ложь;
	Результат = Новый Структура("СообщениеОбОшибке");
	
	// Создание чат-бота.
	ПользовательСВ = Неопределено;
	Ответ = ПользовательБотСВ();
	Если Ответ.СообщениеОбОшибке <> Неопределено Тогда
		Отказ = Истина;
		Результат.СообщениеОбОшибке = Ответ.СообщениеОбОшибке;
	Иначе
		ПользовательСВ = Ответ.ПользовательСВ;
	КонецЕсли;
	
	// Создание служебного обсуждения.
	ИдентификаторОбсужденияСВ = Неопределено;
	Если Не Отказ Тогда
		Ответ = ОбсуждениеДляСлужебныхОповещений();
		Если Ответ.СообщениеОбОшибке <> Неопределено Тогда
			Отказ = Истина;
			Результат.СообщениеОбОшибке = Ответ.СообщениеОбОшибке;
		Иначе
			ИдентификаторОбсужденияСВ = Строка(Ответ.ОбсуждениеСВ.Идентификатор);
		КонецЕсли;
	КонецЕсли;
	
	// Отправка настроек СВ в сервис.
	Если Не Отказ Тогда
		
		Ответ = КабинетСотрудникаМенеджерОбмена.ОбновитьНастройкиСистемыВзаимодействия(ПользовательСВ, ИдентификаторОбсужденияСВ);
		Если Ответ.СообщениеОбОшибке <> Неопределено Тогда
			
			Отказ = Истина;
			СообщениеОбОшибке = НСтр("ru = 'Не удалось отправить настройки системы взаимодействия.';
									|en = 'Cannot send collaboration system settings.'");
			Результат.СообщениеОбОшибке = СтрШаблон("%1 %2", СообщениеОбОшибке, ПодробностиВЖурналеРегистрации());
			
			ШаблонОписания = НСтр(
			"ru = 'Ошибка отправки настроек системы взаимодействия.
			|Описание ошибки:
			|%1';
			|en = 'An error occurred when sending collaboration system settings.
			|Error details: 
			|%1'");
			ТекстОшибки = СтрШаблон(ШаблонОписания, Ответ.СообщениеОбОшибке);
			ЗаписьЖурналаРегистрации(КабинетСотрудника.ИмяСобытияОбсуждения(), УровеньЖурналаРегистрации.Ошибка,,, ТекстОшибки);
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если Не Отказ Тогда
		Настройки = РегистрыСведений.НастройкиИнтеграцииКабинетСотрудника.НастройкиИнтеграции();
		Настройки.ИспользоватьОбсуждения = Истина;
		НаборЗаписей = РегистрыСведений.НастройкиИнтеграцииКабинетСотрудника.СоздатьНаборЗаписей();
		ЗаполнитьЗначенияСвойств(НаборЗаписей.Добавить(), Настройки);
		НаборЗаписей.Записать();
	КонецЕсли;

	ПоместитьВоВременноеХранилище(Результат, АдресХранилища);

КонецПроцедуры

Процедура ОтключениеОбсужденийФоновоеЗадание(Параметры, АдресХранилища) Экспорт

	Результат = Новый Структура("СообщениеОбОшибке");
	
	Идентификатор1 = СистемаВзаимодействия.ИдентификаторТекущегоПриложения();
	Идентификатор2 = Неопределено;
	
	Приложение2Зарегистрировано = Ложь;
	НастройкиИнтеграции = РегистрыСведений.НастройкиИнтеграцииКабинетСотрудника.НастройкиИнтеграции();
	Идентификатор2Строка = НастройкиИнтеграции.ИдентификаторПриложенияСовместногоИспользования;
	Если Не ПустаяСтрока(Идентификатор2Строка) Тогда
		
		Идентификатор2 = Новый ИдентификаторПриложенияСистемыВзаимодействия(Идентификатор2Строка);
		Попытка
			ПриложениеСВ = СистемаВзаимодействия.ПолучитьПриложение(Идентификатор2);
			Приложение2Зарегистрировано = Истина;
		Исключение
		КонецПопытки;
		
	КонецЕсли;
	
	Если Приложение2Зарегистрировано Тогда
		
		Попытка
			
			СовместноеИспользованиеНастроено = Ложь;
			
			ЭлементыСовместногоИспользования = СистемаВзаимодействия.ПолучитьСовместноеИспользованиеПриложенийАбонента();
			СовместноеИспользованиеНастроено = Ложь;
			Для каждого ЭлементСовместногоИспользования Из ЭлементыСовместногоИспользования Цикл
				Для Каждого ИдентификаторПриложения Из ЭлементСовместногоИспользования.Приложения Цикл
					Если ИдентификаторПриложения <> Идентификатор1 И ИдентификаторПриложения <> Идентификатор2 Тогда
						СовместноеИспользованиеНастроено = Ложь;
						Прервать;
					КонецЕсли;
					СовместноеИспользованиеНастроено = Истина;
				КонецЦикла;
				Если СовместноеИспользованиеНастроено Тогда
					Прервать;
				КонецЕсли;
			КонецЦикла;
			
			Если СовместноеИспользованиеНастроено Тогда
				Приложения = Новый КоллекцияИдентификаторовПриложенийСистемыВзаимодействия();
				Приложения.Добавить(Идентификатор1);
				Приложения.Добавить(Идентификатор2);
				СистемаВзаимодействия.ОтменитьСовместноеИспользованиеПриложенийАбонента(Приложения);
			КонецЕсли;
			
		Исключение
			
			ТекстСообщенияОбОшибке = НСтр("ru = 'Отмена совместного использования приложений не выполнена.';
											|en = 'Application sharing is not canceled.'");
			Результат.СообщениеОбОшибке = СтрШаблон("%1 %2", ТекстСообщенияОбОшибке, ПодробностиВЖурналеРегистрации());
			
			ШаблонОписания = НСтр(
				"ru = 'Ошибка отмены совместного использования приложений.
				|Описание ошибки:
				|%1';
				|en = 'An error occurred when canceling the application sharing.
				|Error details:
				|%1'");
			ТекстОшибки = СтрШаблон(ШаблонОписания, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			ЗаписьЖурналаРегистрации(КабинетСотрудника.ИмяСобытияОбсуждения(), УровеньЖурналаРегистрации.Ошибка,,, ТекстОшибки);
			
		КонецПопытки;
		
	КонецЕсли;
	
	Если Результат.СообщениеОбОшибке = Неопределено Тогда
		
		Константы.ИспользуютсяОбсужденияКабинетСотрудника.Установить(Ложь);
		РегистрыСведений.НастройкиИнтеграцииКабинетСотрудника.СохранитьЗначениеИдентификаторПриложенияСовместногоИспользования("");
		РегистрыСведений.НастройкиСервисаКабинетСотрудника.УстановитьТребуетсяОбновитьНастройкиФункциональности(Истина);
		КабинетСотрудникаМенеджерОбмена.ОбновитьНастройкиФункциональностиСервиса();
		
		Настройки = РегистрыСведений.НастройкиИнтеграцииКабинетСотрудника.НастройкиИнтеграции();
		Настройки.ИдентификаторПриложенияСовместногоИспользования = "";
		Настройки.ИспользоватьОбсуждения = Ложь;
		НаборЗаписей = РегистрыСведений.НастройкиИнтеграцииКабинетСотрудника.СоздатьНаборЗаписей();
		ЗаполнитьЗначенияСвойств(НаборЗаписей.Добавить(), Настройки);
		НаборЗаписей.Записать();
		
	КонецЕсли;
	
	ПоместитьВоВременноеХранилище(Результат, АдресХранилища);

КонецПроцедуры

Процедура ОбъединениеПриложенийФоновоеЗадание(Параметры, АдресХранилища) Экспорт

	Отказ = Ложь;
	Результат = Новый Структура("Включено,НеПодключено,НеЗарегистрированоУАбонента,СообщениеОбОшибке", Ложь, Ложь, Ложь);
	
	Ответ = КабинетСотрудникаМенеджерОбмена.ПриложениеСистемыВзаимодействия();
	ОписаниеПриложения = Неопределено;
	Если Ответ.СообщениеОбОшибке <> Неопределено Тогда
		Отказ = Истина;
		Результат.СообщениеОбОшибке = Ответ.СообщениеОбОшибке;
	Иначе
		ОписаниеПриложения = Ответ.ОписаниеПриложения;
		Если Не ЗначениеЗаполнено(ОписаниеПриложения.Идентификатор) Тогда
			Отказ = Истина;
			Результат.НеПодключено = Истина;
		КонецЕсли;
	КонецЕсли;
		
	Если Не Отказ Тогда
		Ответ = ОбъединитьПриложенияДляСовместногоИспользования(ОписаниеПриложения);
		Результат.СообщениеОбОшибке = Ответ.СообщениеОбОшибке;
		Результат.Включено = Ответ.Включено;
		Результат.НеЗарегистрированоУАбонента = Ответ.НеЗарегистрированоУАбонента;
	КонецЕсли;
	
	Если Результат.Включено Тогда
		УстановитьПривилегированныйРежим(Истина);
		РегистрыСведений.НастройкиИнтеграцииКабинетСотрудника.СохранитьЗначениеИдентификаторПриложенияСовместногоИспользования(ОписаниеПриложения.Идентификатор);
		РегистрыСведений.НастройкиСервисаКабинетСотрудника.УстановитьТребуетсяОбновитьНастройкиФункциональности(Истина);
		Константы.ИспользуютсяОбсужденияКабинетСотрудника.Установить(Истина);
		УстановитьПривилегированныйРежим(Ложь);
		КабинетСотрудникаМенеджерОбмена.ОбновитьНастройкиФункциональностиСервиса();
	КонецЕсли;
	
	ПоместитьВоВременноеХранилище(Результат, АдресХранилища);
	
КонецПроцедуры

Функция ОбъединитьПриложенияДляСовместногоИспользования(ОписаниеПриложения)
	
	Результат = Новый Структура("Включено,НеЗарегистрированоУАбонента,СообщениеОбОшибке", Ложь, Ложь);
	
	Идентификатор1 = СистемаВзаимодействия.ИдентификаторТекущегоПриложения();
	Идентификатор2 = Новый ИдентификаторПриложенияСистемыВзаимодействия(ОписаниеПриложения.Идентификатор);
	
	ТекстСообщенияОбОшибке = НСтр("ru = 'Объединение приложений не выполнено.';
									|en = 'Applications are not merged.'");
	СообщениеОбОшибке = СтрШаблон("%1 %2", ТекстСообщенияОбОшибке, ПодробностиВЖурналеРегистрации());
	
	ШаблонОписания = НСтр(
		"ru = 'Ошибка установки совместного использования приложений.
		|Описание ошибки:
		|%1';
		|en = 'An error occurred when setting the application sharing.
		|Error details:
		|%1'");
	
	Попытка
		ПриложенияАбонента = СистемаВзаимодействия.ПолучитьПриложенияАбонента();
	Исключение
		Результат.Включено = Ложь;
		Результат.СообщениеОбОшибке = СообщениеОбОшибке;
		ТекстОшибки = СтрШаблон(ШаблонОписания, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ЗаписьЖурналаРегистрации(КабинетСотрудника.ИмяСобытияОбсуждения(), УровеньЖурналаРегистрации.Ошибка,,, ТекстОшибки);
		Возврат Результат;
	КонецПопытки;
	
	ПриложениеЗарегистрированоУАбонента = Ложь;;
	Для каждого ПриложениеАбонента Из ПриложенияАбонента Цикл
		Если ПриложениеАбонента.Идентификатор = Идентификатор2 Тогда
			ПриложениеЗарегистрированоУАбонента = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если Не ПриложениеЗарегистрированоУАбонента Тогда
		Результат.НеЗарегистрированоУАбонента = Истина;
		Возврат Результат;
	КонецЕсли;
	
	Попытка
		УстановитьПривилегированныйРежим(Истина);
		ЭлементыСовместногоИспользования = СистемаВзаимодействия.ПолучитьСовместноеИспользованиеПриложенийАбонента();
		УстановитьПривилегированныйРежим(Ложь);
	Исключение
		Результат.Включено = Ложь;
		Результат.СообщениеОбОшибке = СообщениеОбОшибке;
		ТекстОшибки = СтрШаблон(ШаблонОписания, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ЗаписьЖурналаРегистрации(КабинетСотрудника.ИмяСобытияОбсуждения(), УровеньЖурналаРегистрации.Ошибка,,, ТекстОшибки);
		Возврат Результат;
	КонецПопытки;
	
	СовместноеИспользованиеНастроено = Ложь;
	Для каждого ЭлементСовместногоИспользования Из ЭлементыСовместногоИспользования Цикл
		
		Для Каждого ИдентификаторПриложения Из ЭлементСовместногоИспользования.Приложения Цикл
			Если ИдентификаторПриложения <> Идентификатор1 И ИдентификаторПриложения <> Идентификатор2 Тогда
				СовместноеИспользованиеНастроено = Ложь;
				Прервать;
			КонецЕсли;
			СовместноеИспользованиеНастроено = Истина;
		КонецЦикла;
		
		Если СовместноеИспользованиеНастроено Тогда
			Прервать;
		КонецЕсли;
		
	КонецЦикла;
	
	Если СовместноеИспользованиеНастроено Тогда
		Результат.Включено = Истина;
		Возврат Результат;
	КонецЕсли;
	
	Связь = Новый СовместноеИспользованиеПриложенийСистемыВзаимодействия;
	Связь.Приложения.Добавить(Идентификатор1);
	Связь.Приложения.Добавить(Идентификатор2);
	
	Попытка
		СистемаВзаимодействия.УстановитьСовместноеИспользованиеПриложенийАбонента(Связь);
		Результат.Включено = Истина;
	Исключение
		Результат.Включено = Ложь;
		Результат.СообщениеОбОшибке = СообщениеОбОшибке;
		ТекстОшибки = СтрШаблон(ШаблонОписания, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ЗаписьЖурналаРегистрации(КабинетСотрудника.ИмяСобытияОбсуждения(), УровеньЖурналаРегистрации.Ошибка,,, ТекстОшибки);
	КонецПопытки;
	
	Возврат Результат;
	
КонецФункции

#Область ПользовательБот

Функция ПользовательБотСВ()
	
	Результат = Новый Структура("ПользовательСВ,СообщениеОбОшибке");
	
	ИмяПользователяБота = ИмяПользователяБота();
	ПользовательБотОбъект = ПользовательБот(ИмяПользователяБота);
	ИдентификаторПользователяИБ = ПользовательБотОбъект.ИдентификаторПользователяИБ;
	УстановитьПривилегированныйРежим(Истина);
	ПользовательБотИБ = ПользователиИнформационнойБазы.НайтиПоУникальномуИдентификатору(ИдентификаторПользователяИБ);
	УстановитьПривилегированныйРежим(Ложь);
	
	ПользовательСВ = Неопределено;
	Попытка
		ИдентификаторПользователяСВ = СистемаВзаимодействия.ПолучитьИдентификаторПользователя(ИдентификаторПользователяИБ);
		ПользовательСВ = СистемаВзаимодействия.ПолучитьПользователя(ИдентификаторПользователяСВ);
	Исключение
	КонецПопытки;
	
	Если ПользовательСВ = Неопределено Тогда
		
		Попытка
			
			УстановитьПривилегированныйРежим(Истина);
			ПользовательСВ = СистемаВзаимодействия.СоздатьПользователя(ПользовательБотИБ);
			ПользовательСВ.Картинка = БиблиотекаКартинок.ЧатБотКабинетСотрудника;
			ПользовательСВ.Записать();
			УстановитьПривилегированныйРежим(Ложь);
			
		Исключение
			
			ШаблонОписания = НСтр("ru = 'При создании пользователя системы взаимодействия %1 произошла ошибка.';
									|en = 'An error occurred when creating a collaboration system user %1.'");
			СообщениеОбОшибке = СтрШаблон(ШаблонОписания, ИмяПользователяБота);
			Результат.СообщениеОбОшибке = СтрШаблон("%1. %2", СообщениеОбОшибке, ПодробностиВЖурналеРегистрации());
			
			ШаблонОписания = НСтр(
			"ru = 'При создании пользователя системы взаимодействия %1 произошла ошибка.
			|Описание ошибки:
			|%2';
			|en = 'An error occurred when creating a collaboration system user %1.
			|Error details:
			|%2'");
			ТекстОшибки = СтрШаблон(ШаблонОписания, ИмяПользователяБота, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			ЗаписьЖурналаРегистрации(КабинетСотрудника.ИмяСобытияОбсуждения(), УровеньЖурналаРегистрации.Ошибка,,, ТекстОшибки);
			
		КонецПопытки;
		
	КонецЕсли;
	
	Если Результат.СообщениеОбОшибке = Неопределено Тогда
		
		Результат.ПользовательСВ = ПользовательСВ;
		
		Настройки = РегистрыСведений.НастройкиИнтеграцииКабинетСотрудника.НастройкиИнтеграции();
		Настройки.ЧатБот = ПользовательБотОбъект.Ссылка;
		НаборЗаписей = РегистрыСведений.НастройкиИнтеграцииКабинетСотрудника.СоздатьНаборЗаписей();
		ЗаполнитьЗначенияСвойств(НаборЗаписей.Добавить(), Настройки);
		НаборЗаписей.Записать();
		
	КонецЕсли;
		
	Возврат Результат;
	
КонецФункции

Функция ПользовательБот(ИмяПользователя)
	
	ПользовательСсылка = Справочники.Пользователи.НайтиПоНаименованию(ИмяПользователя, Истина);
	Если ЗначениеЗаполнено(ПользовательСсылка) Тогда
		Возврат ПользовательСсылка.ПолучитьОбъект();
	КонецЕсли;
	
	НовыйПользователь = Справочники.Пользователи.СоздатьЭлемент();
	НовыйПользователь.Наименование = ИмяПользователя;
	НовыйПользователь.Недействителен = Ложь;
	НовыйПользователь.Служебный = Истина;
	
	НовыйПароль = НовыйПароль();
	ОписаниеПользователяИБ = Пользователи.НовоеОписаниеПользователяИБ();
	ОписаниеПользователяИБ.Имя = ИмяПользователя;
	ОписаниеПользователяИБ.ПолноеИмя = ИмяПользователя;
	ОписаниеПользователяИБ.АутентификацияСтандартная = Ложь;
	ОписаниеПользователяИБ.ПоказыватьВСпискеВыбора = Ложь;
	ОписаниеПользователяИБ.Пароль = НовыйПароль;
	ОписаниеПользователяИБ.Вставить("Действие", "Записать");
	НовыйПользователь.ДополнительныеСвойства.Вставить("ОписаниеПользователяИБ", ОписаниеПользователяИБ);
	НовыйПользователь.Записать();
	
	Возврат НовыйПользователь;

КонецФункции

Функция ИмяПользователяБота()

	Возврат "Настя (бот)";

КонецФункции

Функция НовыйПароль()
	
	МинимальнаяДлинаПароля = ПолучитьМинимальнуюДлинуПаролейПользователей();
	Если МинимальнаяДлинаПароля <= 8 Тогда
		МинимальнаяДлинаПароля = 8;
	КонецЕсли;
	ПараметрыПароля = ПользователиСлужебный.ПараметрыПароля(МинимальнаяДлинаПароля, Истина);
	Возврат ПользователиСлужебный.СоздатьПароль(ПараметрыПароля);
	
КонецФункции

#КонецОбласти

#Область ОбработкаНовыхСообщений

// Процедура регламентного задания ОбработатьНовыеОбсужденияКабинетСотрудника
//
Процедура ОбработатьНовыеОбсуждения() Экспорт
	
	ОбщегоНазначения.ПриНачалеВыполненияРегламентногоЗадания(Метаданные.РегламентныеЗадания.ОбработатьНовыеОбсужденияКабинетСотрудника);
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если Не Обсуждения.СистемаВзаимодействийПодключена() Тогда
		Возврат;
	КонецЕсли;
	
	БылиОшибки = Ложь;
	Попытка
		ТекущийПользовательИБ = ПользователиИнформационнойБазы.ТекущийПользователь();
		Если ПустаяСтрока(ТекущийПользовательИБ.Имя) Тогда
			// Задание выполняется под пользователем по умолчанию, устанавливаем пользователя для системы взаимодействия.
			НастройкиИнтеграции = РегистрыСведений.НастройкиИнтеграцииКабинетСотрудника.НастройкиИнтеграции();
			КоординаторОбсуждений = НастройкиИнтеграции.КоординаторОбсуждений;
			ИдентификаторПользователяИБ = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(КоординаторОбсуждений, "ИдентификаторПользователяИБ");
			СистемаВзаимодействия.УстановитьТекущегоПользователя(ИдентификаторПользователяИБ);
		КонецЕсли;
	Исключение
		БылиОшибки = Истина;
		ЗаписьЖурналаРегистрации(КабинетСотрудника.ИмяСобытияОбсуждения(),
			УровеньЖурналаРегистрации.Ошибка,,, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
	
	Если Не БылиОшибки Тогда
		БылиОшибки = РезультатОбработкиНовыхСообщений();
	КонецЕсли;
	
	Если БылиОшибки Тогда
		ВызватьИсключение НСтр("ru = 'Обработка новых сообщений завершена с ошибками.';
								|en = 'New messages are processed with errors.'");
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработатьНовыеОбсужденияФоновоеЗадание(Параметры, АдресХранилища) Экспорт
	
	Результат = Новый Структура("БылиОшибки", Ложь); 
	
	УстановитьПривилегированныйРежим(Истина);

	Результат.БылиОшибки = РезультатОбработкиНовыхСообщений();
	
	ПоместитьВоВременноеХранилище(Результат, АдресХранилища);
	
КонецПроцедуры

Функция РезультатОбработкиНовыхСообщений()
	
	Приложение = Перечисления.ПриложенияДляИнтеграции.КабинетСотрудника;
	ВидСобытия = Перечисления.ВидыСобытийОбменаУправлениеПерсоналом.ОбработкаОбсуждений;
	СобытиеОбмена = РегистрыСведений.СобытияОбменаУправлениеПерсоналом.СобытиеОбмена(Приложение, ВидСобытия);
	СобытиеОбмена.ДатаНачала = ТекущаяДатаСеанса();
	
	Комментарий = НСтр("ru = 'Начало обработки новых обсуждений.';
						|en = 'Processing new conversations.'");
	ЗаписьЖурналаРегистрации(КабинетСотрудника.ИмяСобытияОбсуждения(), УровеньЖурналаРегистрации.Информация,,,Комментарий);
	
	БылиОшибки = Ложь;
	ОбработаноОбсуждений = 0;
	Попытка
		НастройкиИнтеграции = РегистрыСведений.НастройкиИнтеграцииКабинетСотрудника.НастройкиИнтеграции();
		КоординаторОбсуждений 	= НастройкиИнтеграции.КоординаторОбсуждений;
		ЧатБот 					= НастройкиИнтеграции.ЧатБот;
		Если Не ЗначениеЗаполнено(КоординаторОбсуждений) Или Не ЗначениеЗаполнено(ЧатБот) Тогда
			БылиОшибки = Истина;
			ОписаниеОшибки =  НСтр("ru = 'Нет пользователей Координатор обсуждений или ЧатБот.';
									|en = 'There are no Conversation coordinator users or ChatBot users.'");
			ЗаписьЖурналаРегистрации(КабинетСотрудника.ИмяСобытияОбсуждения(),
				УровеньЖурналаРегистрации.Ошибка,,, ОписаниеОшибки);
		КонецЕсли;
	Исключение
		БылиОшибки = Истина;
		ЗаписьЖурналаРегистрации(КабинетСотрудника.ИмяСобытияОбсуждения(),
			УровеньЖурналаРегистрации.Ошибка,,, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
	
	Если Не БылиОшибки Тогда
		
		Попытка
			
			Настройки = РегистрыСведений.НастройкиСервисаКабинетСотрудника.НастройкиСервиса();
			ИдентификаторПриложения = Настройки.ИдентификаторПриложения;
			
			КоординаторСВ 	= Обсуждения.ПользовательСистемыВзаимодействия(КоординаторОбсуждений);
			ЧатБотСВ 		= Обсуждения.ПользовательСистемыВзаимодействия(ЧатБот);
			
			ИдентификаторПользователяСВ = ЧатБотСВ.Идентификатор;
			
			Отбор = Новый ОтборОбсужденийСистемыВзаимодействия;
			Отбор.Групповое 			= Истина;
			Отбор.Отображаемое 			= Ложь;
			Отбор.КонтекстноеОбсуждение = Ложь;
			Отбор.ТекущийПользовательЯвляетсяУчастником = Ложь;
			НайденныеОбсуждения = СистемаВзаимодействия.ПолучитьОбсуждения(Отбор);
			
			ОбсужденияКОбработке = Новый Массив;
			Для каждого ОтобранноеОбсуждение Из НайденныеОбсуждения Цикл
				Если ОтобранноеОбсуждение.Участники.Количество() = 2 И ОтобранноеОбсуждение.Участники.Содержит(ИдентификаторПользователяСВ) Тогда
					ОбсужденияКОбработке.Добавить(ОтобранноеОбсуждение);
				КонецЕсли;
			КонецЦикла;
			
			КонтекстныеОбсуждения = Новый ТаблицаЗначений;
			КонтекстныеОбсуждения.Колонки.Добавить("Обсуждение");
			КонтекстныеОбсуждения.Колонки.Добавить("Сообщение");
			КонтекстныеОбсуждения.Колонки.Добавить("ФизическоеЛицо");
			КонтекстныеОбсуждения.Колонки.Добавить("ИдентификаторДокумента", Новый ОписаниеТипов("Строка",,,, Новый КвалификаторыСтроки(72)));
			
			ОтборСообщений = Новый ОтборСообщенийСистемыВзаимодействия;
			Для каждого ОбсуждениеДляОбработки Из ОбсужденияКОбработке Цикл
				
				ОтборСообщений.Обсуждение = ОбсуждениеДляОбработки.Идентификатор;
				Сообщения = СистемаВзаимодействия.ПолучитьСообщения(ОтборСообщений);
				
				ОбсуждениеПодходит = Ложь;
				
				ПолучателиСообщения = Новый Массив;
				Для Каждого Сообщение Из Сообщения Цикл
					
					ОбъектДанныеСообщения = Неопределено;
					Если ТипЗнч(Сообщение.Данные) = Тип("Строка") И Не ПустаяСтрока(Сообщение.Данные) Тогда
						ЧтениеJSON = Новый ЧтениеJSON;
						ЧтениеJSON.УстановитьСтроку(Сообщение.Данные);
						Попытка
							ОбъектДанныеСообщения = ПрочитатьJSON(ЧтениеJSON, Истина);
						Исключение
							Продолжить;
						КонецПопытки;
					КонецЕсли;
					
					Если Не ЗначениеЗаполнено(ОбъектДанныеСообщения) Тогда
						Продолжить;
					КонецЕсли;
					
					ДанныеСообщения = ДанныеСообщенияПоОбъекту(ОбъектДанныеСообщения);
					Если ДанныеСообщения.ИдентификаторПриложения <> ИдентификаторПриложения Тогда
						Продолжить;
					КонецЕсли;
					
					Если ЗначениеЗаполнено(ДанныеСообщения.ИдентификаторДокумента) Тогда
						НоваяСтрока = КонтекстныеОбсуждения.Добавить();
						НоваяСтрока.Обсуждение = ОбсуждениеДляОбработки;
						НоваяСтрока.Сообщение = Сообщение;
						НоваяСтрока.ФизическоеЛицо = ДанныеСообщения.ФизическоеЛицо;
						НоваяСтрока.ИдентификаторДокумента = ДанныеСообщения.ИдентификаторДокумента;
						Прервать;
					КонецЕсли;
					
					Если КоординаторСВ <> Неопределено Тогда
						ПолучателиСообщения.Добавить(КоординаторСВ);
					КонецЕсли;
					
				КонецЦикла;
				
				Если ПолучателиСообщения.Количество() > 0 Тогда
					ОбработаноОбсуждений = ОбработаноОбсуждений +1;
					ЗавершитьОбработкуОбсуждения(ОбсуждениеДляОбработки, ПолучателиСообщения, Сообщение, ДанныеСообщения.ФизическоеЛицо);
				КонецЕсли;
				
			КонецЦикла;
			
			СоответствиеПользователей = Новый Соответствие;
			Если КонтекстныеОбсуждения.Количество() > 0 Тогда
				
				СсылкаНеуказанногоПользователя = Пользователи.СсылкаНеуказанногоПользователя(Ложь);
				
				ИдентификаторыДокументов = КонтекстныеОбсуждения.ВыгрузитьКолонку("ИдентификаторДокумента");
				ДокументыКЭДО = ДокументыКЭДОПоИдентификатору(ИдентификаторыДокументов);
				
				Для каждого СтрокаТЗ Из КонтекстныеОбсуждения Цикл
					
					ПолучателиСообщения = Новый Массив;
					ПолучателиСообщения.Добавить(КоординаторСВ);
					
					ДанныеДокумента = ДокументыКЭДО.Найти(СтрокаТЗ.ИдентификаторДокумента, "ИдентификаторДокумента");
					КонтекстОбсуждения = Неопределено;
					Если ДанныеДокумента <> Неопределено Тогда
						КонтекстОбсуждения = ДанныеДокумента.Ссылка;
						Ответственный = ДанныеДокумента.Ответственный;
						Если ЗначениеЗаполнено(Ответственный) И Не Ответственный = СсылкаНеуказанногоПользователя Тогда
							ПользовательСВ = СоответствиеПользователей[Ответственный];
							Если ПользовательСВ = Неопределено Тогда
								ПользовательСВ = Обсуждения.ПользовательСистемыВзаимодействия(Ответственный);
								СоответствиеПользователей.Вставить(Ответственный, ПользовательСВ);
							КонецЕсли;
							ПолучателиСообщения.Добавить(ПользовательСВ);
						КонецЕсли;
					КонецЕсли;
					
					ОбработаноОбсуждений = ОбработаноОбсуждений +1;
					ЗавершитьОбработкуОбсуждения(СтрокаТЗ.Обсуждение, ПолучателиСообщения, СтрокаТЗ.Сообщение, СтрокаТЗ.ФизическоеЛицо, КонтекстОбсуждения);
					
				КонецЦикла;
				
			КонецЕсли;
			
		Исключение
			БылиОшибки = Истина;
			ЗаписьЖурналаРегистрации(КабинетСотрудника.ИмяСобытияОбсуждения(),
				УровеньЖурналаРегистрации.Ошибка,,, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		КонецПопытки;
		
	КонецЕсли;
	
	Комментарий = НСтр("ru = 'Окончание обработки новых обсуждений. Новых обсуждений: %1';
						|en = 'Processing new conversations. New conversations: %1'");
	Комментарий = СтрШаблон(Комментарий, ОбработаноОбсуждений);
	Если БылиОшибки Тогда
		Комментарий = СтрШаблон("%1 %2", Комментарий, НСтр("ru = 'Были ошибки.';
															|en = 'There were errors.'"));
	КонецЕсли;
	ЗаписьЖурналаРегистрации(КабинетСотрудника.ИмяСобытияОбсуждения(), УровеньЖурналаРегистрации.Информация,,,Комментарий);
	
	СобытиеОбмена.ДатаОкончания = ТекущаяДатаСеанса();
	СобытиеОбмена.БылиОшибки 	= БылиОшибки;
	РегистрыСведений.СобытияОбменаУправлениеПерсоналом.ЗаписатьСобытиеОбмена(СобытиеОбмена);;
	
	Возврат БылиОшибки;

КонецФункции

Процедура ЗавершитьОбработкуОбсуждения(ОбсуждениеДляОбработки, ПолучателиСообщения, Сообщение, ФизическоеЛицо, ДокументКЭДО = Неопределено)

	ОбсуждениеДляОбработки.Отображаемое = Истина;
	Для каждого Получатель Из ПолучателиСообщения Цикл
		ОбсуждениеДляОбработки.Участники.Добавить(Получатель.Идентификатор);
		Сообщение.Получатели.Добавить(Получатель.Идентификатор);
	КонецЦикла;
	ОбсуждениеДляОбработки.Записать();
	
	Если ЗначениеЗаполнено(ФизическоеЛицо) Тогда
		Действие = Новый Структура;
		Действие.Вставить("ВыполняемоеДействие", "ОткрытьНавигационнуюСсылкуКабинетСотрудника");
		Действие.Вставить("НавигационнаяСсылка", ПолучитьНавигационнуюСсылку(ФизическоеЛицо));
		Сообщение.Действия.Добавить(Новый ФиксированнаяСтруктура(Действие), Строка(ФизическоеЛицо));
	КонецЕсли;
	Если ЗначениеЗаполнено(ДокументКЭДО) Тогда
		Действие = Новый Структура;
		Действие.Вставить("ВыполняемоеДействие", "ОткрытьНавигационнуюСсылкуКабинетСотрудника");
		Действие.Вставить("НавигационнаяСсылка", ПолучитьНавигационнуюСсылку(ДокументКЭДО));
		Сообщение.Действия.Добавить(Новый ФиксированнаяСтруктура(Действие), Строка(ДокументКЭДО));
	КонецЕсли;
	Сообщение.Записать();
	
КонецПроцедуры

Функция ОписаниеДанныхСообщения()

	Описание = Новый Соответствие;
	Описание.Вставить("applicationID", 	"ИдентификаторПриложения");
	Описание.Вставить("documentID", 	"ИдентификаторДокумента");
	Описание.Вставить("personID", 		"ФизическоеЛицо");
	Описание.Вставить("employerID", 	"Организация");
	
	Возврат Описание;

КонецФункции

Функция ДанныеСообщенияПоОбъекту(ОбъектДанныеСообщения)

	ОписаниеДанныхСообщения = ОписаниеДанныхСообщения();
	ДанныеСообщения = Новый Структура;
	Для каждого ЭлементКоллекции Из ОписаниеДанныхСообщения Цикл
		ЗначениеПоля = ОбъектДанныеСообщения[ЭлементКоллекции.Ключ];
		Если ЭлементКоллекции.Значение = "ФизическоеЛицо" И ЗначениеЗаполнено(ЗначениеПоля) Тогда
			ЗначениеПоля = Справочники.ФизическиеЛица.ПолучитьСсылку(Новый УникальныйИдентификатор(ЗначениеПоля));
		ИначеЕсли ЭлементКоллекции.Значение = "Организация" И ЗначениеЗаполнено(ЗначениеПоля) Тогда
			ЗначениеПоля = Справочники.Организации.ПолучитьСсылку(Новый УникальныйИдентификатор(ЗначениеПоля));
		КонецЕсли;
		ДанныеСообщения.Вставить(ЭлементКоллекции.Значение, ЗначениеПоля);
	КонецЦикла;
	
	Возврат ДанныеСообщения;

КонецФункции

Функция ДокументыКЭДОПоИдентификатору(Идентификаторы)

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ИдентификаторыДокументов", Идентификаторы);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ДокументКЭДО.Ссылка КАК Ссылка,
	|	ДокументКЭДО.ИдентификаторДокумента КАК ИдентификаторДокумента,
	|	ДокументКЭДО.ОснованиеДокумента КАК Документ,
	|	ВЫБОР
	|		КОГДА НЕ РасчетныеЛистки.Ответственный ЕСТЬ NULL
	|			ТОГДА РасчетныеЛистки.Ответственный
	|		ИНАЧЕ ДокументКЭДО.Ответственный
	|	КОНЕЦ КАК Ответственный
	|ИЗ
	|	Документ.ДокументКадровогоЭДО КАК ДокументКЭДО
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.РасчетныеЛисткиКабинетСотрудника КАК РасчетныеЛистки
	|		ПО ДокументКЭДО.Ссылка = РасчетныеЛистки.ДокументКадровогоЭДО
	|ГДЕ
	|	ДокументКЭДО.ИдентификаторДокумента В(&ИдентификаторыДокументов)";
	
	Возврат Запрос.Выполнить().Выгрузить();

КонецФункции

#КонецОбласти

#Область ОбработкаСлужебногоОповещения

Процедура ОбработкаСлужебногоОповещения(ОписаниеСообщения, ДополнительныеПараметры) Экспорт
	
	ДанныеСообщения = ОписаниеСообщения.Данные;
	
	ОбъектДанныеСообщения = Неопределено;
	Если ТипЗнч(ДанныеСообщения) = Тип("Строка") И Не ПустаяСтрока(ДанныеСообщения) Тогда
		ЧтениеJSON = Новый ЧтениеJSON;
		ЧтениеJSON.УстановитьСтроку(ДанныеСообщения);
		Попытка
			ОбъектДанныеСообщения = ПрочитатьJSON(ЧтениеJSON, Истина);
		Исключение
			Возврат;
		КонецПопытки;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ОбъектДанныеСообщения) Тогда
		Возврат;
	КонецЕсли;
	
	Действие = ОбъектДанныеСообщения["action"];
	Если Действие = "delete"  Тогда
		ИдентификаторСтарогоСообщенияСтрока = ОбъектДанныеСообщения["oldMessageID"];
		ИдентификаторНовогоСообщенияСтрока  = ОбъектДанныеСообщения["newMessageID"];
		Если ЗначениеЗаполнено(ИдентификаторНовогоСообщенияСтрока) И ЗначениеЗаполнено(ИдентификаторСтарогоСообщенияСтрока) Тогда
			ОбработатьСообщениеСистемыВзаимодействия(ИдентификаторНовогоСообщенияСтрока, ИдентификаторСтарогоСообщенияСтрока);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработатьСообщениеСистемыВзаимодействия(ИдентификаторНовогоСообщенияСтрока, ИдентификаторСтарогоСообщенияСтрока)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Попытка
		ИдентификаторСтарогоСообщения = Новый ИдентификаторСообщенияСистемыВзаимодействия(ИдентификаторСтарогоСообщенияСтрока);
		СтароеСообщение = СистемаВзаимодействия.ПолучитьСообщение(ИдентификаторСтарогоСообщения);
	Исключение
		// старое сообщение удалено
		Возврат;
	КонецПопытки;
	
	Попытка
		
		ДействияСтарогоСообщения = СтароеСообщение.Действия;
		ДанныеСтарогоСообщения = СтароеСообщение.Данные;
		
		ИдентификаторНовогоСообщения = Новый ИдентификаторСообщенияСистемыВзаимодействия(ИдентификаторНовогоСообщенияСтрока);
		НовоеСообщение = СистемаВзаимодействия.ПолучитьСообщение(ИдентификаторНовогоСообщения);
		ЗаписыватьСообщение = Ложь;
		Для каждого ЭлементКоллекции Из ДействияСтарогоСообщения Цикл
			НовоеСообщение.Действия.Добавить(ЭлементКоллекции.Значение, ЭлементКоллекции.Представление);
			ЗаписыватьСообщение = Истина;
		КонецЦикла;
		Если ЗначениеЗаполнено(ДанныеСтарогоСообщения) Тогда
			НовоеСообщение.Данные = ДанныеСтарогоСообщения;
			ЗаписыватьСообщение = Истина;
		КонецЕсли;
		
		Если ЗаписыватьСообщение Тогда
			НовоеСообщение.Записать();
		КонецЕсли;
		
		СтароеСообщение.Текст = "";
		СтароеСообщение.Данные = Неопределено;
		СтароеСообщение.Действия.Очистить();
		СтароеСообщение.Записать();
		
	Исключение
		ШаблонОписания = НСтр(
		"ru = 'При удалении сообщения %1 системы взаимодействия произошла ошибка.
		|Описание ошибки:
		|%2';
		|en = 'An error occurred when deleting the collaboration system message %1.
		|Error details:
		|%2'");
		ТекстОшибки = СтрШаблон(ШаблонОписания, ИдентификаторСтарогоСообщенияСтрока, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ЗаписьЖурналаРегистрации(КабинетСотрудника.ИмяСобытияОбсуждения(), УровеньЖурналаРегистрации.Ошибка,,, ТекстОшибки);
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти

#Область Прочие

Функция ОбсуждениеДляСлужебныхОповещений() Экспорт
	
	Результат = Новый Структура("ОбсуждениеСВ,СообщениеОбОшибке");
	
	УстановитьПривилегированныйРежим(Истина);
	
	Попытка
		
		ИДПользователяСВ = СистемаВзаимодействия.СтандартныеПользователи.ВсеПользователиПриложения;
		КлючОбсуждения = "SystemNotificationESS_" + Строка(ИДПользователяСВ);
		Обсуждение = СистемаВзаимодействия.ПолучитьОбсуждение(КлючОбсуждения);
		Если Обсуждение = Неопределено Тогда
			Обсуждение = СистемаВзаимодействия.СоздатьОбсуждение();
			Обсуждение.Ключ = КлючОбсуждения;
			Обсуждение.Отображаемое = Ложь;
			Обсуждение.Участники.Добавить(ИДПользователяСВ);
			Обсуждение.Записать();
		ИначеЕсли Обсуждение.Участники.Количество() = 0 Тогда
			Обсуждение.Участники.Добавить(ИДПользователяСВ);
			Обсуждение.Записать();
		КонецЕсли;
		
		Результат.ОбсуждениеСВ = Обсуждение;
		
	Исключение
		
		СообщениеОбОшибке = НСтр("ru = 'Не удалось создать служебное обсуждение.';
								|en = 'Cannot create an internal conversation.'");
		Результат.СообщениеОбОшибке = СтрШаблон("%1. %2", СообщениеОбОшибке, ПодробностиВЖурналеРегистрации());
		
		ШаблонОписания = НСтр(
			"ru = 'Ошибка создания служебного обсуждения.
			|Описание ошибки:
			|%1';
			|en = 'An error occurred when creating an internal conversation.
			|Error details:
			|%1'");
		ТекстОшибки = СтрШаблон(ШаблонОписания, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ЗаписьЖурналаРегистрации(КабинетСотрудника.ИмяСобытияОбсуждения(), УровеньЖурналаРегистрации.Ошибка,,, ТекстОшибки);
		
	КонецПопытки;
	
	Возврат Результат;
	
КонецФункции

Функция ПодробностиВЖурналеРегистрации()

	Возврат НСтр("ru = 'Подробности см. в журнале регистрации.';
				|en = 'See the event log for details.'");

КонецФункции

#КонецОбласти

#КонецОбласти



