///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

// Возвращает реквизиты объекта, которые не рекомендуется редактировать
// с помощью обработки группового изменения реквизитов.
//
// Возвращаемое значение:
//  Массив из Строка
//
Функция РеквизитыНеРедактируемыеВГрупповойОбработке() Экспорт
	
	Результат = Новый Массив;
	Результат.Добавить("*");
	Возврат Результат;
	
КонецФункции

// Конец СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

// СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов

// Возвращаемое значение:
//   см. ЗапретРедактированияРеквизитовОбъектовПереопределяемый.ПриОпределенииЗаблокированныхРеквизитов.ЗаблокированныеРеквизиты.
//
Функция ПолучитьБлокируемыеРеквизитыОбъекта() Экспорт
	
	БлокируемыеРеквизиты = Новый Массив;
	
	БлокируемыеРеквизиты.Добавить("Тип;Тип");
	БлокируемыеРеквизиты.Добавить("Родитель");
	БлокируемыеРеквизиты.Добавить("ИдентификаторДляФормул");
	
	Возврат БлокируемыеРеквизиты;
	
КонецФункции

// Конец СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов

// СтандартныеПодсистемы.ПоискИУдалениеДублей

// Параметры: 
//   ПарыЗамен - см. ПоискИУдалениеДублейПереопределяемый.ПриОпределенииВозможностиЗаменыЭлементов.ПарыЗамен
//   ПараметрыЗамены - см. ПоискИУдалениеДублейПереопределяемый.ПриОпределенииВозможностиЗаменыЭлементов.ПараметрыЗамены
// 
// Возвращаемое значение:
//   см. ПоискИУдалениеДублейПереопределяемый.ПриОпределенииВозможностиЗаменыЭлементов.НедопустимыеЗамены
//
Функция ВозможностьЗаменыЭлементов(Знач ПарыЗамен, Знач ПараметрыЗамены = Неопределено) Экспорт
	
	Результат = Новый Соответствие;
	Для Каждого КлючЗначение Из ПарыЗамен Цикл
		ТекущаяСсылка = КлючЗначение.Ключ;
		ЦелеваяСсылка = КлючЗначение.Значение;
		
		Если ТекущаяСсылка = ЦелеваяСсылка Тогда
			Продолжить;
		КонецЕсли;
		
		// Разрешаем заменять вид контактной информации на другой, только если они относятся к одной группе.
		МожноЗаменять = ТекущаяСсылка.Родитель = ЦелеваяСсылка.Родитель;
		Если Не МожноЗаменять Тогда
			Ошибка = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Элемент ""%1"" относится к ""%2"", а ""%3"" - к ""%4""';
																					|en = 'Item ""%1"" belongs to ""%2,"" while ""%3"" belongs to ""%4.""'"),
				ТекущаяСсылка, ТекущаяСсылка.Родитель, ЦелеваяСсылка, ЦелеваяСсылка.Родитель);
			Результат.Вставить(ТекущаяСсылка, Ошибка);
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Результат;
КонецФункции

// Параметры: 
//   ПараметрыПоиска - см. ПоискИУдалениеДублейПереопределяемый.ПриОпределенииПараметровПоискаДублей.ПараметрыПоиска
//   ДополнительныеПараметры - см. ПоискИУдалениеДублейПереопределяемый.ПриОпределенииПараметровПоискаДублей.ДополнительныеПараметры 
//
Процедура ПараметрыПоискаДублей(ПараметрыПоиска, ДополнительныеПараметры = Неопределено) Экспорт
	
	Ограничение = Новый Структура;
	Ограничение.Вставить("Представление",      НСтр("ru = 'Относятся к одной группе и одного типа (адрес, телефон и пр.).';
													|en = 'Same group and same type (for example, ""address"" or ""phone"" type).'"));
	Ограничение.Вставить("ДополнительныеПоля", "Родитель, Тип, Используется");
	ПараметрыПоиска.ОграниченияСравнения.Добавить(Ограничение);
	
	// Размер таблицы для передачи в обработчик.
	ПараметрыПоиска.КоличествоЭлементовДляСравнения = 100;
	
КонецПроцедуры

// Параметры:
//   ДублиЭлементов - см. ПоискИУдалениеДублейПереопределяемый.ПриПоискеДублей.ДублиЭлементов
//   ДополнительныеПараметры - см. ПоискИУдалениеДублейПереопределяемый.ПриПоискеДублей.ДополнительныеПараметры
//
Процедура ПриПоискеДублей(ДублиЭлементов, ДополнительныеПараметры = Неопределено) Экспорт
	
	Для Каждого Дубль Из ДублиЭлементов Цикл
		Если Дубль.Поля1.Используется
		   И Дубль.Поля2.Используется
		   И Дубль.Поля1.Родитель = Дубль.Поля2.Родитель 
		   И Дубль.Поля1.Тип = Дубль.Поля2.Тип
		   И СтрСравнить(Дубль.Поля1.Наименование, Дубль.Поля2.Наименование) = 0 Тогда
			Дубль.ЭтоДубли = Истина;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ПоискИУдалениеДублей

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// 
// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//   Настройки - Структура - настройки подсистемы.
//
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

#КонецОбласти

#КонецОбласти

#КонецЕсли

#Область ОбработчикиСобытий

// АПК:362-выкл Проектное решение

Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка)
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Мультиязычность") Тогда
		МодульМультиязычностьКлиентСервер = ОбщегоНазначения.ОбщийМодуль("МультиязычностьКлиентСервер");
		МодульМультиязычностьКлиентСервер.ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка);
	КонецЕсли;
#Иначе
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.Мультиязычность") Тогда
		МодульМультиязычностьКлиентСервер = ОбщегоНазначенияКлиент.ОбщийМодуль("МультиязычностьКлиентСервер");
		МодульМультиязычностьКлиентСервер.ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка);
	КонецЕсли;
#КонецЕсли
КонецПроцедуры

// АПК:362-вкл

#КонецОбласти

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Смотри также ОбновлениеИнформационнойБазыПереопределяемый.ПриНастройкеНачальногоЗаполненияЭлементов
// 
// Параметры:
//  Настройки - см. ОбновлениеИнформационнойБазыСлужебный.НастройкиЗаполненияЭлементов
//
Процедура ПриНастройкеНачальногоЗаполненияЭлементов(Настройки) Экспорт
	
	УправлениеКонтактнойИнформациейПереопределяемый.ПриНастройкеНачальногоЗаполненияЭлементов(Настройки);

	Настройки.ПриНачальномЗаполненииЭлемента = Истина;
	Настройки.ИмяКлючевогоРеквизита          = ИмяКлючевогоРеквизита();
	
КонецПроцедуры

// Смотри также ОбновлениеИнформационнойБазыПереопределяемый.ПриНачальномЗаполненииЭлементов
// 
// Параметры:
//   КодыЯзыков - см. ОбновлениеИнформационнойБазыПереопределяемый.ПриНачальномЗаполненииЭлементов.КодыЯзыков
//   Элементы   - см. ОбновлениеИнформационнойБазыПереопределяемый.ПриНачальномЗаполненииЭлементов.Элементы
//   ТабличныеЧасти - см. ОбновлениеИнформационнойБазыПереопределяемый.ПриНачальномЗаполненииЭлементов.ТабличныеЧасти
//
Процедура ПриНачальномЗаполненииЭлементов(КодыЯзыков, Элементы, ТабличныеЧасти) Экспорт
	
	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "СправочникПользователи";
	Элемент.ЭтоГруппа = Истина;
	Элемент.Используется = Истина;
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Мультиязычность") Тогда
		МодульМультиязычностьСервер = ОбщегоНазначения.ОбщийМодуль("МультиязычностьСервер");
		МодульМультиязычностьСервер.ЗаполнитьМультиязычныйРеквизит(Элемент, "Наименование", 
			"ru = 'Контактная информация справочника ""Пользователи""';
			|en = '""Users"" catalog contact information'", КодыЯзыков); // @НСтр-1
	Иначе
		Элемент.Наименование = НСтр("ru = 'Контактная информация справочника ""Пользователи""';
									|en = '""Users"" catalog contact information'", 
			ОбщегоНазначения.КодОсновногоЯзыка());
	КонецЕсли;
	
	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "EmailПользователя";
	Элемент.Тип = Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты;
	Элемент.МожноИзменятьСпособРедактирования = Истина;
	Элемент.РазрешитьВводНесколькихЗначений   = Истина;
	Элемент.Родитель = Справочники.ВидыКонтактнойИнформации.СправочникПользователи;
	Элемент.ИдентификаторДляФормул = "ЭлектроннаяПочта";
	Элемент.ВидРедактирования = "ПолеВвода";
	Элемент.Используется = Истина;
	Элемент.РеквизитДопУпорядочивания = 2;
	Элемент.ОтображатьВсегда          = Истина;
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Мультиязычность") Тогда
		МодульМультиязычностьСервер = ОбщегоНазначения.ОбщийМодуль("МультиязычностьСервер");
		МодульМультиязычностьСервер.ЗаполнитьМультиязычныйРеквизит(Элемент, "Наименование", 
		"ru = 'Электронная почта';
		|en = 'Email'", КодыЯзыков); // @НСтр-1
	Иначе
		Элемент.Наименование = НСтр("ru = 'Электронная почта';
									|en = 'Email'", ОбщегоНазначения.КодОсновногоЯзыка());
	КонецЕсли;
	
	
	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "ТелефонПользователя";
	Элемент.Тип = Перечисления.ТипыКонтактнойИнформации.Телефон;
	
	Элемент.МожноИзменятьСпособРедактирования = Истина;
	Элемент.РазрешитьВводНесколькихЗначений   = Истина;
	Элемент.Родитель = Справочники.ВидыКонтактнойИнформации.СправочникПользователи;
	Элемент.ИдентификаторДляФормул = "Телефон";
	Элемент.Используется = Истина;
	Элемент.ВидРедактирования = "ПолеВводаИДиалог";
	Элемент.РеквизитДопУпорядочивания = 1;
	Элемент.ОтображатьВсегда          = Истина;
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Мультиязычность") Тогда
		МодульМультиязычностьСервер = ОбщегоНазначения.ОбщийМодуль("МультиязычностьСервер");
		МодульМультиязычностьСервер.ЗаполнитьМультиязычныйРеквизит(Элемент, "Наименование", 
		"ru = 'Телефон';
		|en = 'Phone'", КодыЯзыков); // @НСтр-1
	Иначе
		Элемент.Наименование = НСтр("ru = 'Телефон';
									|en = 'Phone'", ОбщегоНазначения.КодОсновногоЯзыка());
	КонецЕсли;
	
	УправлениеКонтактнойИнформациейПереопределяемый.ПриНачальномЗаполненииЭлементов(КодыЯзыков, Элементы, ТабличныеЧасти);
	
КонецПроцедуры

// Смотри также ОбновлениеИнформационнойБазыПереопределяемый.ПриНастройкеНачальногоЗаполненияЭлементов
//
// Параметры:
//  Объект                  - СправочникОбъект.ВидыКонтактнойИнформации - заполняемый объект.
//  Данные                  - СтрокаТаблицыЗначений - данные заполнения объекта.
//  ДополнительныеПараметры - Структура:
//   * ПредопределенныеДанные - ТаблицаЗначений - данные заполненные в процедуре ПриНачальномЗаполненииЭлементов.
//
Процедура ПриНачальномЗаполненииЭлемента(Объект, Данные, ДополнительныеПараметры) Экспорт
	
	УправлениеКонтактнойИнформациейПереопределяемый.ПриНачальномЗаполненииЭлемента(Объект, Данные, ДополнительныеПараметры);
	
	Если Не Объект.ЭтоГруппа И ПустаяСтрока(Объект.ИмяГруппы) Тогда
		ИмяГруппы = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.Родитель, ИмяКлючевогоРеквизита());
		Если ПустаяСтрока(ИмяГруппы) Тогда
			ИмяГруппы = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.Родитель, "ИмяПредопределенныхДанных");
		КонецЕсли;
		Объект.ИмяГруппы = ИмяГруппы;
	КонецЕсли;
	
	Результат = УправлениеКонтактнойИнформациейСлужебный.ПроверитьПараметрыВидаКонтактнойИнформации(Объект);
	Если Результат.ЕстьОшибки Тогда
		ВызватьИсключение Результат.ТекстОшибки;
	КонецЕсли;
	
	Если Объект.Тип = Перечисления.ТипыКонтактнойИнформации.Адрес Тогда 
		Если ПустаяСтрока(Объект.ВидРедактирования) Тогда
			Объект.ВидРедактирования = "ПолеВводаИДиалог";
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
	
#Область СлужебныеПроцедурыИФункции

#Область ИдентификаторДляФормул

// Проверяет уникальность идентификатора в рамках объекта метаданных для которого предназначен вид контактной
// информации (родитель) а также соответствие идентификатора правилам написания.
// 
// Параметры:
//   ИдентификаторДляФормул - Строка - идентификатор для формул.
//   Ссылка - СправочникСсылка.ВидыКонтактнойИнформации - ссылка на текущий объект.
//   Родитель - СправочникСсылка.ВидыКонтактнойИнформации - ссылка на родитель текущего объекта.
//   Отказ - Булево - флаг отказа при наличии ошибки.
//
Процедура ПроверитьУникальностьИдентификатора(ИдентификаторДляФормул, Ссылка, Родитель, Отказ) Экспорт
	
	Если ЗначениеЗаполнено(ИдентификаторДляФормул) Тогда
		
		ИдентификаторПоПравилам = Истина;
		ПроверочныйИдентификатор = ИдентификаторДляФормул(ИдентификаторДляФормул);
		Если НЕ ВРег(ПроверочныйИдентификатор) = ВРег(ИдентификаторДляФормул) Тогда
			ИдентификаторПоПравилам = Ложь;
			
			ТекстОшибки = НСтр("ru = 'Идентификатор ""%1"" не соответствует правилам именования переменных.
									|Идентификатор не должен содержать пробелов и специальных символов.';
									|en = 'ID ""%1"" does not comply with variable naming rules.
									|An ID must not contain spaces and special characters.'");
			ОбщегоНазначения.СообщитьПользователю(
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстОшибки, ИдентификаторДляФормул),,
				"ИдентификаторДляФормул",, Отказ);
				
			КодЯзыка = ОбщегоНазначения.КодОсновногоЯзыка();
			ИмяСобытия = НСтр("ru = 'Запись дополнительного реквизита (сведения)';
								|en = 'Save additional attribute or information record'", КодЯзыка);
			ТекстОшибки = НСтр("ru = 'Идентификатор ""%1"" не соответствует правилам именования переменных.
									|Идентификатор не должен содержать пробелов и специальных символов.';
									|en = 'ID ""%1"" does not comply with variable naming rules.
									|An ID must not contain spaces and special characters.'", КодЯзыка);
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстОшибки,
				ИдентификаторДляФормул);
			ЗаписьЖурналаРегистрации(ИмяСобытия,
					УровеньЖурналаРегистрации.Ошибка,
					Ссылка.Метаданные(),
					Ссылка,
					ТекстОшибки);
		КонецЕсли;
		
		Если ИдентификаторПоПравилам Тогда
			РодительВерхнегоУровня = Родитель;
			Пока ЗначениеЗаполнено(РодительВерхнегоУровня) Цикл
				Значение = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(РодительВерхнегоУровня, "Родитель");
				Если ЗначениеЗаполнено(Значение) Тогда
					РодительВерхнегоУровня = Значение;
				Иначе
					Прервать;
				КонецЕсли;
			КонецЦикла;
			Если НЕ ИдентификаторДляФормулУникален(ИдентификаторДляФормул, Ссылка, РодительВерхнегоУровня) Тогда
				
				Отказ = Истина;
				
				ТекстОшибки = НСтр("ru = 'В базе данных уже содержится вид контактной информации с идентификатором ""%1"" внутри группы ""%2"". Идентификатор должен быть уникальным';
									|en = 'The database already contains a contact information type with ID ""%1"" within group ""%2"". The ID must be unique'");
				ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстОшибки,
					ИдентификаторДляФормул, РодительВерхнегоУровня);
				ОбщегоНазначения.СообщитьПользователю(ТекстОшибки,, "ИдентификаторДляФормул");
				
				КодЯзыка = ОбщегоНазначения.КодОсновногоЯзыка();
				ТекстОшибки = НСтр("ru = 'В базе данных уже содержится вид контактной информации с идентификатором ""%1"" внутри группы ""%2"". Идентификатор должен быть уникальным';
									|en = 'The database already contains a contact information type with ID ""%1"" within group ""%2"". The ID must be unique'", КодЯзыка);
				ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстОшибки,
					ИдентификаторДляФормул, РодительВерхнегоУровня);
				ИмяСобытия = НСтр("ru = 'Запись дополнительного реквизита (сведения)';
									|en = 'Save additional attribute or information record'", КодЯзыка);
				ЗаписьЖурналаРегистрации(ИмяСобытия,
					УровеньЖурналаРегистрации.Ошибка,
					Ссылка.Метаданные(),
					Ссылка,
					ТекстОшибки);
			КонецЕсли;
		КонецЕсли;
		
	Иначе
		
		ТекстОшибки = НСтр("ru = 'Идентификатор для формул не заполнен';
							|en = 'ID for formulas is required'");
		ОбщегоНазначения.СообщитьПользователю(
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстОшибки, ИдентификаторДляФормул),,
			"ИдентификаторДляФормул",, Отказ);
			
		КодЯзыка = ОбщегоНазначения.КодОсновногоЯзыка();
		ИмяСобытия = НСтр("ru = 'Запись дополнительного реквизита (сведения)';
							|en = 'Save additional attribute or information record'", КодЯзыка);
		ТекстОшибки = НСтр("ru = 'Идентификатор для формул не заполнен';
							|en = 'ID for formulas is required'", КодЯзыка);
		ЗаписьЖурналаРегистрации(ИмяСобытия,
			УровеньЖурналаРегистрации.Ошибка,
			Ссылка.Метаданные(),
			Ссылка,
			ТекстОшибки);
			
	КонецЕсли;
	
КонецПроцедуры

// Возвращает уникальный идентификатора для формул (после проверки на уникальность)
// 
// Параметры:
//   ПредставлениеОбъекта - Строка - представление, из которого будет сформирован идентификатор для формул.
//   СсылкаНаТекущийОбъект - СправочникСсылка.ВидыКонтактнойИнформации - ссылка на текущий элемент.
//   Родитель - СправочникСсылка.ВидыКонтактнойИнформации - ссылка на родитель текущего объекта.
// Возвращаемое значение:
//   Строка - уникальное значение идентификатора для формул.
//
Функция УникальныйИдентификаторДляФормул(ПредставлениеОбъекта, СсылкаНаТекущийОбъект, Родитель) Экспорт

	Идентификатор = ИдентификаторДляФормул(ПредставлениеОбъекта);
	Если ПустаяСтрока(Идентификатор) Тогда
		// Представление состоит и спецсимволов или цифр.
		Префикс = НСтр("ru = 'Идентификатор';
						|en = 'ID'");
		Идентификатор = ИдентификаторДляФормул(Префикс + ПредставлениеОбъекта);
	КонецЕсли;
	
	РодительВерхнегоУровня = Родитель;
	Пока ЗначениеЗаполнено(РодительВерхнегоУровня) Цикл
		Значение = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(РодительВерхнегоУровня, "Родитель");
		Если ЗначениеЗаполнено(Значение) Тогда
			РодительВерхнегоУровня = Значение;
		Иначе
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВидыКонтактнойИнформации.ИдентификаторДляФормул КАК ИдентификаторДляФормул
	|ИЗ
	|	Справочник.ВидыКонтактнойИнформации КАК ВидыКонтактнойИнформации
	|ГДЕ
	|	ВидыКонтактнойИнформации.ИдентификаторДляФормул = &ИдентификаторДляФормул
	|	И ВидыКонтактнойИнформации.Ссылка <> &СсылкаНаТекущийОбъект
	|	И ВидыКонтактнойИнформации.Ссылка В ИЕРАРХИИ (&РодительВерхнегоУровня)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВидыКонтактнойИнформации.ИдентификаторДляФормул КАК ИдентификаторДляФормул
	|ИЗ
	|	Справочник.ВидыКонтактнойИнформации КАК ВидыКонтактнойИнформации
	|ГДЕ
	|	ВидыКонтактнойИнформации.ИдентификаторДляФормул ПОДОБНО &ИдентификаторДляФормулПодобие СПЕЦСИМВОЛ ""~""
	|	И ВидыКонтактнойИнформации.Ссылка <> &СсылкаНаТекущийОбъект
	|	И ВидыКонтактнойИнформации.Ссылка В ИЕРАРХИИ (&РодительВерхнегоУровня)";
	Запрос.УстановитьПараметр("СсылкаНаТекущийОбъект", СсылкаНаТекущийОбъект);
	Запрос.УстановитьПараметр("РодительВерхнегоУровня", РодительВерхнегоУровня);
	Запрос.УстановитьПараметр("ИдентификаторДляФормул", Идентификатор);
	Запрос.УстановитьПараметр("ИдентификаторДляФормулПодобие", ОбщегоНазначения.СформироватьСтрокуДляПоискаВЗапросе(Идентификатор) + "%");
	
	РезультатыЗапроса = Запрос.ВыполнитьПакет();
	УникальностьПоТочномуСоответствию = РезультатыЗапроса[0];
	Если НЕ УникальностьПоТочномуСоответствию.Пустой() Тогда
		// Есть элементы с данным идентификатором.
		ИспользованныеИдентификаторы = Новый Соответствие;
		ВыборкаПодобных = РезультатыЗапроса[1].Выбрать();
		Пока ВыборкаПодобных.Следующий() Цикл
			ИспользованныеИдентификаторы.Вставить(ВРЕГ(ВыборкаПодобных.ИдентификаторДляФормул), Истина);
		КонецЦикла;
		
		ДобавляемыйНомер = 1;
		ИдентификаторБезНомера = Идентификатор;
		Пока НЕ ИспользованныеИдентификаторы.Получить(ВРЕГ(Идентификатор)) = Неопределено Цикл
			ДобавляемыйНомер = ДобавляемыйНомер + 1;
			Идентификатор = ИдентификаторБезНомера + ДобавляемыйНомер;
		КонецЦикла;
	КонецЕсли;
	ИспользованныеИдентификаторы = Новый Соответствие;
	
	Возврат Идентификатор;
КонецФункции

Функция ИдентификаторДляФормулУникален(ПроверяемыйИдентификатор, СсылкаНаТекущийОбъект, Родитель)
	
	РодительВерхнегоУровня = Родитель;
	Пока ЗначениеЗаполнено(РодительВерхнегоУровня) Цикл
		Значение = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(РодительВерхнегоУровня, "Родитель");
		Если ЗначениеЗаполнено(Значение) Тогда
			РодительВерхнегоУровня = Значение;
		Иначе
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	Таблица.Ссылка
	|ИЗ
	|	Справочник.ВидыКонтактнойИнформации КАК Таблица
	|ГДЕ
	|	Таблица.Ссылка <> &СсылкаНаТекущийОбъект
	|	И Таблица.Ссылка В ИЕРАРХИИ (&РодительВерхнегоУровня)
	|	И Таблица.ИдентификаторДляФормул = &ИдентификаторДляФормул";
	Запрос.УстановитьПараметр("ИдентификаторДляФормул", ПроверяемыйИдентификатор);
	Запрос.УстановитьПараметр("СсылкаНаТекущийОбъект", СсылкаНаТекущийОбъект);
	Запрос.УстановитьПараметр("РодительВерхнегоУровня", РодительВерхнегоУровня);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат РезультатЗапроса.Пустой();
КонецФункции

// Вычисляет значение идентификатора из строки соответствии с правилами именования переменных.
// 
// Параметры:
//  СтрокаПредставления - Строка - наименование, строка из которой необходимо получить идентификатор. 
//
// Возвращаемое значение:
//  Строка - идентификатор, соответствующий правилам именования идентификаторов.
//
Функция ИдентификаторДляФормул(СтрокаПредставления) Экспорт
	
	СпецСимволы = СпецСимволы();
	
	Идентификатор = "";
	БылСпецСимвол = Ложь;
	
	Для НомСимвола = 1 По СтрДлина(СтрокаПредставления) Цикл
		
		Символ = Сред(СтрокаПредставления, НомСимвола, 1);
		
		Если СтрНайти(СпецСимволы, Символ) <> 0 Тогда
			БылСпецСимвол = Истина;
			Если Символ = "_" Тогда
				Идентификатор = Идентификатор + Символ;
			КонецЕсли;
		ИначеЕсли БылСпецСимвол
			ИЛИ НомСимвола = 1 Тогда
			БылСпецСимвол = Ложь;
			Идентификатор = Идентификатор + ВРег(Символ);
		Иначе
			Идентификатор = Идентификатор + Символ;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Идентификатор;
	
КонецФункции

Функция СпецСимволы()
	Диапазоны = Новый Массив;
	Диапазоны.Добавить(Новый Структура("Мин, Макс", 0, 32));
	Диапазоны.Добавить(Новый Структура("Мин, Макс", 127, 191));
	
	СпецСимволы = " .,+,-,/,*,?,=,<,>,(,)%!@#$%&*""№:;{}[]?()\|/`~'^_";
	Для Каждого Диапазон Из Диапазоны Цикл
		Для КодСимвола = Диапазон.Мин По Диапазон.Макс Цикл
			СпецСимволы = СпецСимволы + Символ(КодСимвола);
		КонецЦикла;
	КонецЦикла;
	Возврат СпецСимволы;
КонецФункции

Функция НаименованиеДляФормированияИдентификатора(Знач Наименование, Знач Представления)
	Если ТекущийЯзык().КодЯзыка <> ОбщегоНазначения.КодОсновногоЯзыка() Тогда
		Отбор = Новый Структура();
		Отбор.Вставить("КодЯзыка", ОбщегоНазначения.КодОсновногоЯзыка());
		НайденныеСтроки = Представления.НайтиСтроки(Отбор);
		Если НайденныеСтроки.Количество() > 0 Тогда
			Наименование = НайденныеСтроки[0].Наименование;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Наименование;
КонецФункции

// Параметры:
//  Родитель - СправочникСсылка.ВидыКонтактнойИнформации
// 
// Возвращаемое значение:
//  Строка
//
Функция ИмяГруппыВидаКонтактнойИнформации(Родитель) Экспорт
	
	ИмяГруппы = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Родитель, "ИмяПредопределенногоВида");
	Если ПустаяСтрока(ИмяГруппы) Тогда
		ИмяГруппы = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Родитель, "ИмяПредопределенныхДанных");
	КонецЕсли;
	
	Возврат ИмяГруппы;
	
КонецФункции

#КонецОбласти

// Регистрирует к обработке виды контактной информации.
//
Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	
	Если Метаданные.Языки.Количество() = 1 Тогда
			ТекстЗапроса = "ВЫБРАТЬ
			|	ВидыКонтактнойИнформации.Ссылка КАК Ссылка,
			|	ВидыКонтактнойИнформации.ИмяПредопределенныхДанных КАК ИмяПредопределенныхДанных
			|ИЗ
			|	Справочник.ВидыКонтактнойИнформации КАК ВидыКонтактнойИнформации
			|ГДЕ
			|	ВидыКонтактнойИнформации.ЭтоГруппа = ЛОЖЬ
			|	И (ЕСТЬNULL(ВидыКонтактнойИнформации.ИдентификаторДляФормул, """") = """"
			|			ИЛИ ЕСТЬNULL(ВидыКонтактнойИнформации.ВидРедактирования, """") = """"
			|			ИЛИ ЕСТЬNULL(ВидыКонтактнойИнформации.ИмяГруппы, """") = """"
			|			ИЛИ ВидыКонтактнойИнформации.ОтображатьВсегда = ЛОЖЬ)";
	Иначе
		
		ТекстЗапроса = "ВЫБРАТЬ
			|	ВидыКонтактнойИнформации.Ссылка КАК Ссылка,
			|	ВидыКонтактнойИнформации.ИмяПредопределенныхДанных КАК ИмяПредопределенныхДанных
			|ИЗ
			|	Справочник.ВидыКонтактнойИнформации КАК ВидыКонтактнойИнформации
			|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВидыКонтактнойИнформации.Представления КАК ПредставленияВида
			|		ПО (ПредставленияВида.Ссылка = ВидыКонтактнойИнформации.Ссылка)
			|ГДЕ
			|	(ВидыКонтактнойИнформации.ЭтоГруппа = ЛОЖЬ
			|				И ((ЕСТЬNULL(ВидыКонтактнойИнформации.ИдентификаторДляФормул, """") = """"
			|					ИЛИ ЕСТЬNULL(ВидыКонтактнойИнформации.ВидРедактирования, """") = """"
			|					ИЛИ ЕСТЬNULL(ВидыКонтактнойИнформации.ИмяГруппы, """") = """"
			|					ИЛИ ВидыКонтактнойИнформации.ОтображатьВсегда = ЛОЖЬ)
			|			ИЛИ ПредставленияВида.Ссылка ЕСТЬ NULL))"
	КонецЕсли;
		
	Запрос = Новый Запрос(ТекстЗапроса);
	
	РезультатЗапроса = Запрос.Выполнить().Выгрузить();
	
	Позиция = РезультатЗапроса.Количество() - 1;
	Пока Позиция >= 0 Цикл
		СтрокаТаблицы = РезультатЗапроса.Получить(Позиция);
		Если СтрНачинаетсяС(СтрокаТаблицы.ИмяПредопределенныхДанных, "Удалить") Тогда
			РезультатЗапроса.Удалить(Позиция);
		КонецЕсли;
		Позиция = Позиция - 1;
	КонецЦикла;
	
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, РезультатЗапроса.ВыгрузитьКолонку("Ссылка"));
	
КонецПроцедуры

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ВидКонтактнойИнформацииСсылка = ОбновлениеИнформационнойБазы.ВыбратьСсылкиДляОбработки(Параметры.Очередь, "Справочник.ВидыКонтактнойИнформации");
	
	ЯзыковБольшеОдного = Метаданные.Языки.Количество() > 1;
	Наименования = УправлениеКонтактнойИнформациейСлужебныйПовтИсп.НаименованияВидовКонтактнойИнформации();
	
	ПроблемныхОбъектов = 0;
	ОбъектовОбработано = 0;
	
	УстановитьОтображатьВсегда = ОбщегоНазначенияКлиентСервер.СравнитьВерсии("3.1.8.270", Параметры.ВерсияПодсистемыНаНачалоОбновления) > 0;
	
	Пока ВидКонтактнойИнформацииСсылка.Следующий() Цикл
		
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить("Справочник.ВидыКонтактнойИнформации");
		ЭлементБлокировки.УстановитьЗначение("Ссылка", ВидКонтактнойИнформацииСсылка.Ссылка);
		
		ПредставлениеСсылки = Строка(ВидКонтактнойИнформацииСсылка.Ссылка);
		
		НачатьТранзакцию();
		Попытка
			
			Блокировка.Заблокировать();
			
			ВидКонтактнойИнформации = ВидКонтактнойИнформацииСсылка.Ссылка.ПолучитьОбъект(); // СправочникОбъект.ВидыКонтактнойИнформации
			
			// Исправление наименований на разных языках
			Если ЯзыковБольшеОдного Тогда
				ИмяВида = ?(ЗначениеЗаполнено(ВидКонтактнойИнформации.ИмяПредопределенногоВида),
					ВидКонтактнойИнформации.ИмяПредопределенногоВида, ВидКонтактнойИнформации.ИмяПредопределенныхДанных);
				
				Если ЗначениеЗаполнено(ИмяВида) Тогда
					УстановитьНаименованияВидовКонтактнойИнформации(ВидКонтактнойИнформации, ИмяВида, Наименования);
				КонецЕсли;
			КонецЕсли;
			
			Если Не ВидКонтактнойИнформации.ЭтоГруппа И ПустаяСтрока(ВидКонтактнойИнформации.ВидРедактирования) Тогда
				Если ВидКонтактнойИнформации.Тип = Перечисления.ТипыКонтактнойИнформации.ВебСтраница 
					Или ВидКонтактнойИнформации.УдалитьРедактированиеТолькоВДиалоге Тогда
					ВидКонтактнойИнформации.ВидРедактирования = "Диалог";
				ИначеЕсли ВидКонтактнойИнформации.Тип = Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты
					Или ВидКонтактнойИнформации.Тип = Перечисления.ТипыКонтактнойИнформации.Skype
					Или ВидКонтактнойИнформации.Тип = Перечисления.ТипыКонтактнойИнформации.Другое Тогда
					ВидКонтактнойИнформации.ВидРедактирования = "ПолеВвода";
				Иначе
					ВидКонтактнойИнформации.ВидРедактирования = "ПолеВводаИДиалог";
				КонецЕсли;
			КонецЕсли;
			
			Если НЕ ВидКонтактнойИнформации.ЭтоГруппа
				И НЕ ЗначениеЗаполнено(ВидКонтактнойИнформации.ИдентификаторДляФормул) Тогда
				НаименованиеДляИдентификатора = НаименованиеДляФормированияИдентификатора(ВидКонтактнойИнформации.Наименование,
					ВидКонтактнойИнформации.Представления);
				// @skip-check query-in-loop - На каждой итерации необходимо зачитывать актуальные данные из ИБ.
				ВидКонтактнойИнформации.ИдентификаторДляФормул = УникальныйИдентификаторДляФормул(НаименованиеДляИдентификатора,
					ВидКонтактнойИнформации.Ссылка, ВидКонтактнойИнформации.Родитель);
			КонецЕсли;
				
			Если Не ВидКонтактнойИнформации.ЭтоГруппа Тогда
				Если УстановитьОтображатьВсегда Тогда
					ВидКонтактнойИнформации.ОтображатьВсегда = Истина;
				КонецЕсли;
				Если ПустаяСтрока(ВидКонтактнойИнформации.ИмяГруппы) Тогда
					ВидКонтактнойИнформации.ИмяГруппы = ИмяГруппыВидаКонтактнойИнформации(ВидКонтактнойИнформации.Родитель);
				КонецЕсли;
			КонецЕсли;
							
			ОбновлениеИнформационнойБазы.ЗаписатьДанные(ВидКонтактнойИнформации);
			ОбъектовОбработано = ОбъектовОбработано + 1;
			
			ЗафиксироватьТранзакцию();
		Исключение
			ОтменитьТранзакцию();
			
			// Если не удалось обработать какой-либо вид контактной информации, повторяем попытку снова.
			ПроблемныхОбъектов = ПроблемныхОбъектов + 1;
			
			ОбновлениеИнформационнойБазы.ЗаписатьОшибкуВЖурналРегистрации(
				ВидКонтактнойИнформацииСсылка.Ссылка,
				ПредставлениеСсылки,
				ИнформацияОбОшибке());
		КонецПопытки;
	КонецЦикла;
	
	Параметры.ОбработкаЗавершена = ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(Параметры.Очередь, "Справочник.ВидыКонтактнойИнформации");
	
	Если ОбъектовОбработано = 0 И ПроблемныхОбъектов <> 0 Тогда
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не удалось обработать некоторые виды контактной информации (пропущены): %1';
				|en = 'Couldn''t process (skipped) some kinds of contact information: %1'"), 
				ПроблемныхОбъектов);
		ВызватьИсключение ТекстСообщения;
	Иначе
		ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Информация,
			Метаданные.Справочники.ВидыКонтактнойИнформации,,
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Обработана очередная порция видов контактной информации: %1';
						|en = 'Yet another batch of contact information kinds is processed: %1'"),
					ОбъектовОбработано));
	КонецЕсли;
	
КонецПроцедуры

Процедура УстановитьНаименованияВидовКонтактнойИнформации(ВидКонтактнойИнформации, ИмяВида, Наименования)
	
	Для Каждого Язык Из Метаданные.Языки Цикл
		
		Представление = Наименования[Язык.КодЯзыка][ИмяВида];
		Если ЗначениеЗаполнено(Представление) Тогда
			
			Если СтрСравнить(Язык.КодЯзыка, ОбщегоНазначения.КодОсновногоЯзыка()) =  0 Тогда
				ВидКонтактнойИнформации.Наименование = Представление;
			Иначе
				
				Если Наименования[Язык.КодЯзыка][ИмяВида] <> Неопределено Тогда
					
					Отбор = Новый Структура;
					Отбор.Вставить("КодЯзыка",     Язык.КодЯзыка);
					НайденныеСтроки = ВидКонтактнойИнформации.Представления.НайтиСтроки(Отбор);
					Если НайденныеСтроки.Количество() > 0 Тогда
						НоваяСтрока = НайденныеСтроки[0];
					Иначе
						НоваяСтрока = ВидКонтактнойИнформации.Представления.Добавить();
					КонецЕсли;
					НоваяСтрока.КодЯзыка     = Язык.КодЯзыка;
					НоваяСтрока.Наименование = Представление;
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры

Функция ИмяКлючевогоРеквизита()
	Возврат "ИмяПредопределенногоВида";
КонецФункции

#КонецОбласти

#КонецЕсли