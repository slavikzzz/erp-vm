///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Подсистема "ИнтернетПоддержкаПользователей.РаботаВМоделиСервиса.БазоваяФункциональностьБИП".
// ОбщийМодуль.РаботаВМоделиСервисаБИП.
//
// Серверные процедуры и функции вызова Технологии сервиса:
//  - Серверные процедуры и функции для вызова Базовой функциональности
//    технологии сервиса.
//
///////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает внутренний адрес менеджера сервиса.
//
// Возвращаемое значение:
//  Строка - внутренний адрес менеджера сервиса.
//
Функция ВнутреннийАдресМенеджераСервиса() Экспорт
	
	ПроверитьВозможностьВызова();
	
	МодульРаботаВМоделиСервиса = ОбщегоНазначения.ОбщийМодуль("РаботаВМоделиСервиса");
	Возврат МодульРаботаВМоделиСервиса.ВнутреннийАдресМенеджераСервиса();
	
КонецФункции

// Возвращает имя служебного пользователя менеджера сервиса.
//
// Возвращаемое значение:
//  Строка - имя служебного пользователя менеджера сервиса.
//
Функция ИмяСлужебногоПользователяМенеджераСервиса() Экспорт
	
	ПроверитьВозможностьВызова();
	
	МодульРаботаВМоделиСервиса = ОбщегоНазначения.ОбщийМодуль("РаботаВМоделиСервиса");
	Возврат МодульРаботаВМоделиСервиса.ИмяСлужебногоПользователяМенеджераСервиса();
	
КонецФункции

// Возвращает пароль служебного пользователя менеджера сервиса.
//
// Возвращаемое значение:
//  Строка - пароль служебного пользователя менеджера сервиса.
//
Функция ПарольСлужебногоПользователяМенеджераСервиса() Экспорт
	
	ПроверитьВозможностьВызова();
	
	МодульРаботаВМоделиСервиса = ОбщегоНазначения.ОбщийМодуль("РаботаВМоделиСервиса");
	Возврат МодульРаботаВМоделиСервиса.ПарольСлужебногоПользователяМенеджераСервиса();
	
КонецФункции

// Возвращает значение разделителя текущей области данных.
// В случае если значение не установлено выдается ошибка.
// 
// Возвращаемое значение: 
// Тип значения разделителя.
// Значение разделителя текущей области данных. 
// 
Функция ЗначениеРазделителяСеанса() Экспорт
	
	Если НЕ ОбщегоНазначения.РазделениеВключено() Тогда
		Возврат 0;
	КонецЕсли;
	
	ПроверитьВозможностьВызова();
	
	МодульРаботаВМоделиСервиса = ОбщегоНазначения.ОбщийМодуль("РаботаВМоделиСервиса");
	Возврат МодульРаботаВМоделиСервиса.ЗначениеРазделителяСеанса();
	
КонецФункции

// Устанавливает разделение сеанса.
//
// Параметры:
// Использование - Булево - Использование разделителя ОбластьДанных в сеансе.
// ОбластьДанных - Число - Значение разделителя ОбластьДанных.
//
Процедура УстановитьРазделениеСеанса(Использование = Неопределено, ОбластьДанных = Неопределено) Экспорт
	
	Если Не ОбщегоНазначения.РазделениеВключено() Тогда
		Возврат;
	КонецЕсли;
	
	ПроверитьВозможностьВызова();
	
	МодульРаботаВМоделиСервиса = ОбщегоНазначения.ОбщийМодуль("РаботаВМоделиСервиса");
	МодульРаботаВМоделиСервиса.УстановитьРазделениеСеанса(Использование, ОбластьДанных);
	
КонецПроцедуры

// Определяет, сеанс запущен с разделителями или без.
//
// Возвращаемое значение:
//   Булево - Истина, если сеанс запущен без разделителей.
//
Функция СеансЗапущенБезРазделителей() Экспорт
	
	Если ДоступенВызовФункциональностиБТС() Тогда
		МодульРаботаВМоделиСервиса = ОбщегоНазначения.ОбщийМодуль("РаботаВМоделиСервиса");
		СеансЗапущенБезРазделителей = МодульРаботаВМоделиСервиса.СеансЗапущенБезРазделителей();
	Иначе
		СеансЗапущенБезРазделителей = Истина;
	КонецЕсли;
	
	Возврат СеансЗапущенБезРазделителей;
	
КонецФункции

// Возвращает признак наличия в конфигурации общих реквизитов-разделителей.
//
// Возвращаемое значение:
//   Булево - Истина, если это разделенная конфигурация.
//
Функция ЭтоРазделеннаяКонфигурация() Экспорт
	
	Если ДоступенВызовФункциональностиБТС() Тогда
		МодульРаботаВМоделиСервиса = ОбщегоНазначения.ОбщийМодуль("РаботаВМоделиСервиса");
		ЕстьРазделители = МодульРаботаВМоделиСервиса.ЭтоРазделеннаяКонфигурация();
	Иначе
		ЕстьРазделители = Ложь;
	КонецЕсли;
	
	Возврат ЕстьРазделители;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Выполняет проверку возможности вызова программного интерфейса
// базовой функциональности Технологии сервиса. Если в конфигурацию
// не встроены подсистемы:
//  - ТехнологияСервиса.БазоваяФункциональность
//  - СтандартныеПодсистемы.РаботаВМоделиСервиса.БазоваяФункциональностьВМоделиСервиса
// будет вызвано исключение.
//
Процедура ПроверитьВозможностьВызова()
	
	Подсистемы = Новый Массив;
	Если Не ОбщегоНазначения.ПодсистемаСуществует("ТехнологияСервиса.БазоваяФункциональность") Тогда
		Подсистемы.Добавить(НСтр("ru = 'ТехнологияСервиса.БазоваяФункциональность';
								|en = 'SaaSTechnology.Core'"));
	КонецЕсли;
	
	Если Не ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаВМоделиСервиса") Тогда
		Подсистемы.Добавить(НСтр("ru = 'СтандартныеПодсистемы.РаботаВМоделиСервиса.БазоваяФункциональностьВМоделиСервиса';
								|en = 'StandardSubsystems.SaaS.CoreSaaS'"));
	КонецЕсли;
	
	Если Подсистемы.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ТекстИсключения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Для работы Интернет-поддержки пользователей в модели сервиса необходимо встроить
			|%1:';
			|en = 'For Internet user support to work in SaaS, you need to build in
			|%1:'"),
		?(Подсистемы.Количество() > 1,
			НСтр("ru = 'подсистемы';
				|en = 'subsystems'"),
			НСтр("ru = 'подсистему';
				|en = 'subsystem'")));
	
	Для Каждого Подсистема Из Подсистемы Цикл
		ТекстИсключения = ТекстИсключения + Символы.ПС + Подсистема;
	КонецЦикла;
	
	ВызватьИсключение ТекстИсключения;
	
КонецПроцедуры

// Выполняет проверку возможности вызова программного интерфейса
// базовой функциональности Технологии сервиса. Если в конфигурацию
// не встроены подсистемы:
//  - ТехнологияСервиса.БазоваяФункциональность
//  - СтандартныеПодсистемы.РаботаВМоделиСервиса.БазоваяФункциональностьВМоделиСервиса
// функция вернет Ложь.
//
// Возвращаемое значение:
//  Булево - результат проверки.
//
Функция ДоступенВызовФункциональностиБТС()
	
	Возврат ОбщегоНазначения.ПодсистемаСуществует("ТехнологияСервиса.БазоваяФункциональность")
		И ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаВМоделиСервиса");
	
КонецФункции

#КонецОбласти
