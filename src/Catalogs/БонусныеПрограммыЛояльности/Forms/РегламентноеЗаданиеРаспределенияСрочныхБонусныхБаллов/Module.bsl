///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ЭтоПолноправныйПользователь = Пользователи.ЭтоПолноправныйПользователь(, Истина);
	РазделениеВключено = ОбщегоНазначения.РазделениеВключено();
	
	Если Не ПравоДоступа("Изменение", Метаданные.Справочники.БонусныеПрограммыЛояльности) Тогда
		ВызватьИсключение НСтр("ru = 'Недостаточно прав доступа.
		                             |
		                             |Изменение свойств регламентного задания
		                             |выполняется только пользователями с правом изменения бонусных программ лояльности.';
		                             |en = 'Insufficient access rights.
		                             |
		                             |Only users with the right to change loyalty programs
		                             |can change scheduled job properties.'");
	КонецЕсли;
	
	Действие = Параметры.Действие;
	
	Если СтрНайти(", Добавить, Скопировать, Изменить,", ", " + Действие + ",") = 0 Тогда
		ВызватьИсключение НСтр("ru = 'Неверные параметры открытия формы ""Регламентное задание"".';
								|en = 'Cannot open the ""Scheduled job"" form. Invalid opening parameters.'");
	КонецЕсли;
	
	Если Действие = "Добавить" Тогда
		
		Расписание = Новый РасписаниеРегламентногоЗадания;
		Задание = Метаданные.РегламентныеЗадания.РаспределениеСрочныхБонусныхБаллов;
		
		ИмяМетаданных       = Задание.Имя;
		СинонимМетаданных   = Задание.Синоним;
		ИмяМетодаМетаданных = Задание.ИмяМетода;
			
	Иначе
		Задание = ПолучитьРегламентноеЗадание(Параметры.Идентификатор);
		
		Идентификатор = Строка(Параметры.Идентификатор);
		Если ТипЗнч(Задание) = Тип("РегламентноеЗадание") Тогда
			ЗаполнитьЗначенияСвойств(
				ЭтотОбъект,
				Задание,
				"Ключ,
				|Предопределенное,
				|Использование,
				|Наименование,
				|ИмяПользователя,
				|ИнтервалПовтораПриАварийномЗавершении,
				|КоличествоПовторовПриАварийномЗавершении");
			
			Если Задание.Метаданные = Неопределено Тогда
				ИмяМетаданных        = НСтр("ru = '<нет метаданных>';
											|en = '<no metadata>'");
				СинонимМетаданных    = НСтр("ru = '<нет метаданных>';
											|en = '<no metadata>'");
				ИмяМетодаМетаданных  = НСтр("ru = '<нет метаданных>';
											|en = '<no metadata>'");
			Иначе
				ИмяМетаданных        = Задание.Метаданные.Имя;
				СинонимМетаданных    = Задание.Метаданные.Синоним;
				ИмяМетодаМетаданных  = Задание.Метаданные.ИмяМетода;
			КонецЕсли;

			Расписание = Задание.Расписание;
			
		ИначеЕсли ТипЗнч(Задание) = Тип("СправочникСсылка.ОчередьЗаданий") Тогда
			
			СтрутураЗадания = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Задание, "Ключ,
																		|Использование,
																		|ИмяПользователя,
																		|ИнтервалПовтораПриАварийномЗавершении,
																		|КоличествоПовторовПриАварийномЗавершении,
																		|Расписание,
																		|Параметры");
			
			ЗаполнитьЗначенияСвойств(
				ЭтотОбъект,
				СтрутураЗадания,
				"Ключ,
				|Использование,
				|ИмяПользователя,
				|ИнтервалПовтораПриАварийномЗавершении,
				|КоличествоПовторовПриАварийномЗавершении");
			
			ИмяМетаданных        = НСтр("ru = '<нет метаданных>';
										|en = '<no metadata>'");
			СинонимМетаданных    = НСтр("ru = '<нет метаданных>';
										|en = '<no metadata>'");
			ИмяМетодаМетаданных  = НСтр("ru = '<нет метаданных>';
										|en = '<no metadata>'");

			Расписание = СтрутураЗадания.Расписание.Получить();
			
		КонецЕсли;

		Если ЭтоПолноправныйПользователь И ТипЗнч(Задание) = Тип("РегламентноеЗадание") Тогда
			СообщенияПользователюИОписаниеИнформацииОбОшибке = РегламентныеЗаданияСлужебный.СообщенияИОписанияОшибокРегламентногоЗадания(Задание);
		КонецЕсли;
	КонецЕсли;
	
	Если Действие <> "Изменить" Тогда
		Идентификатор = НСтр("ru = '<будет создан при записи>';
							|en = '<will be generated automatically>'");
		Использование = Ложь;
		
	КонецЕсли;
	
	Если Действие = "Добавить" Или ПустаяСтрока(Наименование) Тогда
		Наименование = АвтоНаименование(ЭтотОбъект);
	Иначе
		АвтоНаименование(ЭтотОбъект);
	КонецЕсли;
	
	ОбновитьРеквизитыАвтонаименования();
	
	// Заполнение списка выбора имени пользователя.
	Если ЭтоПолноправныйПользователь Тогда
		МассивПользователей = ПользователиИнформационнойБазы.ПолучитьПользователей();
		
		Для каждого Пользователь Из МассивПользователей Цикл
			Элементы.ИмяПользователя.СписокВыбора.Добавить(Пользователь.Имя);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры 

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Действие = "Добавить" Тогда
		
		ОбновитьЗаголовокФормы();
		
	Иначе
		ОбновитьЗаголовокФормы();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения("ЗаписатьИЗакрытьЗавершение", ЭтотОбъект);
	ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(Оповещение, Отказ, ЗавершениеРаботы);
	
	ОбновитьАвтонаименование(Модифицированность);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НаименованиеПриИзменении(Элемент)
	
	ИндексАвтонаименования = 0;
	НаименованиеИзмененоПользователем = Истина;
	ИспользуетсяАвтоНаименование = Ложь;
	Для Каждого ЭлементСписка Из Элементы.Наименование.СписокВыбора Цикл
		
		Если ЭлементСписка.Значение = Наименование Тогда
			ИспользуетсяАвтоНаименование = Истина;
			НаименованиеИзмененоПользователем = Ложь;
			ИндексАвтонаименования = Элементы.Наименование.СписокВыбора.Индекс(ЭлементСписка);
		КонецЕсли;
		
	КонецЦикла;
		
	ОбновитьЗаголовокФормы();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Записать(Команда)
	
	ЗаписатьРегламентноеЗадание();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрытьВыполнить()
	
	ЗаписатьИЗакрытьЗавершение();
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьРасписаниеВыполнить()

	Диалог = Новый ДиалогРасписанияРегламентногоЗадания(Расписание);
	Диалог.Показать(Новый ОписаниеОповещения("ОткрытьРасписаниеЗавершение", ЭтотОбъект));
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ЗаписатьИЗакрытьЗавершение(Результат = Неопределено, ДополнительныеПараметры = Неопределено) Экспорт
	
	ЗаписатьРегламентноеЗадание();
	Модифицированность = Ложь;
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьРасписаниеЗавершение(НовоеРасписание, Контекст) Экспорт

	Если НовоеРасписание <> Неопределено Тогда
		Расписание = НовоеРасписание;
		Модифицированность = Истина;
		Если РазделениеВключено 
			И Расписание.ПериодПовтораВТечениеДня > 0
			И Расписание.ПериодПовтораВТечениеДня < 3600 Тогда
			
			Расписание.ПериодПовтораВТечениеДня = 3600;
			
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьРегламентноеЗадание()
	
	Если НЕ ЗначениеЗаполнено(ИмяМетаданных) Тогда
		Возврат;
	КонецЕсли;
	
	ТекущийИдентификатор = ?(Действие = "Изменить", Идентификатор, Неопределено);
	
	ЗаписатьРегламентноеЗаданиеНаСервере();
	ОбновитьЗаголовокФормы();
	
	Оповестить("Запись_РегламентныеЗадания", ТекущийИдентификатор);
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьРегламентноеЗаданиеНаСервере()
	
	ПараметрыЗадания = Новый Структура();
	ПараметрыЗадания.Вставить("Ключ");
	ПараметрыЗадания.Вставить("Наименование");
	ПараметрыЗадания.Вставить("Использование");
	ПараметрыЗадания.Вставить("ИмяПользователя");
	ПараметрыЗадания.Вставить("ИнтервалПовтораПриАварийномЗавершении");
	ПараметрыЗадания.Вставить("КоличествоПовторовПриАварийномЗавершении");
	ПараметрыЗадания.Вставить("Параметры", Новый Массив());
	ПараметрыЗадания.Вставить("Расписание");
	Если Не Действие = "Изменить" Тогда
		ПараметрыЗадания.Вставить("Метаданные", Метаданные.РегламентныеЗадания.РаспределениеСрочныхБонусныхБаллов);
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(
		ПараметрыЗадания,
		ЭтотОбъект,
		"Ключ, 
		|Наименование,
		|Использование,
		|ИмяПользователя,
		|ИнтервалПовтораПриАварийномЗавершении,
		|КоличествоПовторовПриАварийномЗавершении,
		|Расписание");
		
	УстановитьПривилегированныйРежим(Истина);

	Если Действие = "Изменить" Тогда
		ИзменитьЗадание(Идентификатор, ПараметрыЗадания);
	Иначе
		УникальныйИдентификаторЗадания = ДобавитьЗадание(ПараметрыЗадания);
		Идентификатор = Строка(УникальныйИдентификаторЗадания);
	КонецЕсли;

	УстановитьПривилегированныйРежим(Ложь);

	Модифицированность = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЗаголовокФормы()
	
	Если НЕ ПустаяСтрока(Наименование) Тогда
		Представление = Наименование;
		
	ИначеЕсли НЕ ПустаяСтрока(СинонимМетаданных) Тогда
		Представление = СинонимМетаданных;
	Иначе
		Представление = ИмяМетаданных;
	КонецЕсли;
	
	Если Действие = "Изменить" Тогда
		Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = '%1 (Регламентное задание)';
																				|en = '%1 (Scheduled job)'"), Представление);
	Иначе
		Заголовок = НСтр("ru = 'Регламентное задание (создание)';
						|en = 'Scheduled job (Create)'");
	КонецЕсли;
	
КонецПроцедуры

#Область РегламентныеЗадания

// Возвращает РегламентноеЗадание из информационной базы.
//
// В модели сервиса работает с регламентными заданиями платформы, а не с заданиями очереди,
// одинаково как в разделенном, так и в неразделенном режимах.
//
// Параметры:
//  Идентификатор - ОбъектМетаданных - объект метаданных регламентного задания для поиска
//                  предопределенного регламентного задания.
//                - УникальныйИдентификатор - идентификатор регламентного задания.
//                - Строка - строка уникального идентификатора регламентного задания.
//                - РегламентноеЗадание - регламентное задание из которого нужно получить
//                  уникальный идентификатор для получения свежей копии регламентного задания.
// 
// Возвращаемое значение:
//  РегламентноеЗадание - прочитано из базы данных.
//
&НаСервере
Функция ПолучитьРегламентноеЗадание(Идентификатор)

	УстановитьПривилегированныйРежим(Истина);

	ЗаданиеРезультат = РегламентныеЗаданияСервер.Задание(Идентификатор);

	УстановитьПривилегированныйРежим(Ложь);
	
	Если ТипЗнч(ЗаданиеРезультат)  = Тип("СтрокаТаблицыЗначений") Тогда
		Задание = ЗаданиеРезультат.УникальныйИдентификатор;
	Иначе
		Задание = ЗаданиеРезультат;
	КонецЕсли;
	
	Возврат Задание;
	
КонецФункции

// Добавляет новое задание в очередь или регламентное.
// 
// Параметры: 
//  ПараметрыЗадания - Структура - параметры добавляемого задания, возможные свойства:
//   * Использование - Булево - Истина, если регламентное задание должно выполняться автоматически согласно расписанию. 
//   * Метаданные    - ОбъектМетаданныхРегламентноеЗадание - обязательно для указания. Объект метаданных, на основе 
//                              которого будет создано регламентное задание.
//   * Параметры     - Массив - параметры регламентного задания. Количество и состав параметров должны соответствовать 
//                              параметрам метода регламентного задания.
//   * Ключ          - Строка - прикладной идентификатор регламентного задания.
//   * ИнтервалПовтораПриАварийномЗавершении - Число - интервал в секундах, через который нужно перезапускать задание 
//                              в случае его аварийного завершения.
//   * Расписание    - РасписаниеРегламентногоЗадания - расписание задания.
//   * КоличествоПовторовПриАварийномЗавершении - Число - количество повторов при аварийном завершении задания.
//
// Возвращаемое значение:
//  РегламентноеЗадание,
//  см. РегламентныеЗаданияСервер.НайтиЗадания - в локальном режиме работы,
// 
&НаСервере
Функция ДобавитьЗадание(ПараметрыЗадания)

	УстановитьПривилегированныйРежим(Истина);

	Задание = РегламентныеЗаданияСервер.ДобавитьЗадание(ПараметрыЗадания);
	УникальныйИдентификаторЗадания = РегламентныеЗаданияСервер.УникальныйИдентификатор(Задание);
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Действие = "Изменить";
	
	Возврат УникальныйИдентификаторЗадания;
	
КонецФункции

// Изменяет задание очереди или регламентное.
//
// В модели сервиса (разделение включено):
// - в случае вызова в транзакции на задание устанавливается объектная блокировка,
// - если задание создано на основе шаблона или предопределенное, может быть указано
// только свойство Использование в параметре Параметры. Расписание в этом случае,
// изменять нельзя, т.к. оно хранится централизованно в неразделенном Шаблоне задания,
// отдельно для каждой области оно не сохраняется.
// 
// Параметры: 
//  Идентификатор - ОбъектМетаданных - объект метаданных регламентного задания для поиска
//                                     непредопределенного регламентного задания.
//                - Строка - имя метаданных предопределенного регламентного задания в любом режиме работы
//                           или строка уникального идентификатора регламентного задания в локальном режиме работы
//                           или строка уникального идентификатора ссылки задания очереди в модели сервиса.
//                - УникальныйИдентификатор - идентификатор регламентного задания в локальном режиме работы
//                           или идентификатор ссылки задания очереди в модели сервиса.
//                - РегламентноеЗадание - регламентное задание в локальном режиме работы.
//                - СправочникСсылка.ОчередьЗаданий - идентификатор задания очереди в модели сервиса.
//                - СтрокаТаблицыЗначений: см. НайтиЗадания
//
//  ПараметрыЗадания - Структура - параметры, которые следует установить заданию, возможные свойства:
//   * Использование - Булево - Истина, если регламентное задание должно выполняться автоматически согласно расписанию.
//   * Параметры     - Массив - параметры регламентного задания. Количество и состав параметров должны соответствовать
//                              параметрам метода регламентного задания.
//   * Ключ          - Строка - прикладной идентификатор регламентного задания.
//   * ИнтервалПовтораПриАварийномЗавершении - Число - интервал в секундах, через который нужно перезапускать задание
//                              в случае его аварийного завершения.
//   * Расписание    - РасписаниеРегламентногоЗадания - расписание задания.
//   * КоличествоПовторовПриАварийномЗавершении - Число - количество повторов при аварийном завершении задания.
//
&НаСервере
Процедура ИзменитьЗадание(Идентификатор, ПараметрыЗадания)

	УстановитьПривилегированныйРежим(Истина);

	РегламентныеЗаданияСервер.ИзменитьЗадание(Идентификатор, ПараметрыЗадания);

	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

#КонецОбласти

#Область Прочее
&НаКлиентеНаСервереБезКонтекста
Функция АвтоНаименование(Форма)
	
	СтрокаНаименования = НСтр("ru = 'Распределение срочных бонусных баллов';
								|en = 'Allocate fixed-term bonus points'");
	
	Если Форма.Элементы.Наименование.СписокВыбора.Количество() = 0 Тогда
		Форма.Элементы.Наименование.СписокВыбора.Добавить(СтрокаНаименования);
	КонецЕсли;
	
	Если Форма.ИндексАвтонаименования <= Форма.Элементы.Наименование.СписокВыбора.Количество() - 1 Тогда
		Возврат Форма.Элементы.Наименование.СписокВыбора.Получить(Форма.ИндексАвтонаименования).Значение;
	Иначе
		Возврат СтрокаНаименования;
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура ОбновитьАвтонаименование(Обновить = Истина)
	
	НаименованиеСтр = АвтоНаименование(ЭтотОбъект);
	Если Не ЗначениеЗаполнено(Наименование)
		ИЛИ (Обновить И ИспользуетсяАвтоНаименование И Не НаименованиеИзмененоПользователем) Тогда
		Наименование = НаименованиеСтр;
		ИспользуетсяАвтоНаименование = Истина;
		ОбновитьЗаголовокФормы();
	КонецЕсли;
	
КонецПроцедуры

// Обновить реквизиты автонаименования
//
&НаСервере
Процедура ОбновитьРеквизитыАвтонаименования()
	
	ИндексАвтонаименования = 0;
	НаименованиеИзмененоПользователем = Истина;
	ИспользуетсяАвтоНаименование = Ложь;
	Для Каждого ЭлементСписка Из Элементы.Наименование.СписокВыбора Цикл
		
		Если ЭлементСписка.Значение = Наименование Тогда
			ИспользуетсяАвтоНаименование = Истина;
			НаименованиеИзмененоПользователем = Ложь;
			ИндексАвтонаименования = Элементы.Наименование.СписокВыбора.Индекс(ЭлементСписка);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
