///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОписаниеПеременных

&НаКлиенте
Перем ИдентификаторДоИзменения;	// Строка

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Заполнение объекта по связи с определяемым типом ОблачнаяКасса
	Если ЗначениеЗаполнено(Параметры.ОблачнаяКасса) Тогда
		
		// Проверка переданного типа в программном интерфейсе см. ОблачныеКассыКлиент.НастройкаПодключения
		ОбщегоНазначенияКлиентСервер.ПроверитьПараметр(
			"ОблачныеКассыКлиент.НастройкаПодключения",
			"ОблачнаяКасса",
			Параметры.ОблачнаяКасса,
			Метаданные.ОпределяемыеТипы.ОблачнаяКасса.Тип);
		
		НастройкаПодключения = Справочники.НастройкиПодключенияКОблачнымКассам.НастройкаПодключения(
			Параметры.ОблачнаяКасса);
		Если НастройкаПодключения <> Неопределено Тогда
			ЗначениеВРеквизитФормы(
				НастройкаПодключения.Ссылка.ПолучитьОбъект(),
				"Объект");
			ЗаполнитьПараметрыПодключенияПоОбъекту();
		Иначе
			//@skip-check bsl-legacy-check-expression-type
			Объект.ОблачнаяКасса = Параметры.ОблачнаяКасса;
		КонецЕсли;
	
	ИначеЕсли Объект.Ссылка.Пустая() Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Объект.Ссылка.Пустая()
		И Не ЗначениеЗаполнено(Параметры.ОблачнаяКасса) Тогда
		
		Закрыть();
		ПоказатьПредупреждение(, НСтр("ru = 'Интерактивное создание настроек подключения запрещено.';
										|en = 'Interactive connection setting creation is restricted.'"));
		
	Иначе
		ПодключитьОбработчикОжидания("ЗаполнитьДоступныеОблачныеКассы", 0.1, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ЗаполнитьПараметрыПодключенияПоОбъекту();
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	ПроверяемыеРеквизиты.Очистить();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИдентификаторПриИзменении(Элемент)
	
	Если Объект.Идентификатор = ИдентификаторДоИзменения Тогда
		Возврат;
	КонецЕсли;
	
	ИдентификаторДоИзменения = Объект.Идентификатор;
	
	ТипАутентификации       = "";
	Логин                   = "";
	Пароль                  = "";
	Токен                   = "";
	ИдентификаторМагазина   = "";
	ИдентификаторГруппыКасс = "";
	СекретныйКлючМагазина   = "";
	
	Если ПустаяСтрока(Объект.Идентификатор) Тогда
		Элементы.СтраницыПараметровПодключения.ТекущаяСтраница = Элементы.СтраницаПустая;
		Возврат;
	КонецЕсли;
	
	ОтборДоступнойКассы    = Новый Структура("Идентификатор", Объект.Идентификатор);
	ДоступнаяОблачнаяКасса = ДоступныеОблачныеКассы.НайтиСтроки(ОтборДоступнойКассы)[0];
	ТипАутентификации      = ДоступнаяОблачнаяКасса.ТипАутентификации;
	Объект.Наименование    = ДоступнаяОблачнаяКасса.Представление;
	Объект.АдресСервиса    = ДоступнаяОблачнаяКасса.АдресСервиса;
	
	ОбновитьИнформацияОПодключении(
		ЭтотОбъект,
		ДоступнаяОблачнаяКасса.Представление,
		ДоступнаяОблачнаяКасса.АдресСервиса);
	АктивироватьСтраницуПараметровАутентификации(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ИдентификаторОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ВыбранноеЗначение = УдалитьИдентификатор Тогда
		СтандартнаяОбработка = Ложь;
		ПоказатьПредупреждение(, НСтр("ru = 'Облачная касса не доступа';
										|en = 'Cloud cash account is not available'"));
	ИначеЕсли Не ПустаяСтрока(УдалитьИдентификатор) Тогда
		Элементы.Идентификатор.СписокВыбора.Удалить(
			Элементы.Идентификатор.СписокВыбора.НайтиПоЗначению(УдалитьИдентификатор));
		УдалитьИдентификатор = "";
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СостояниеОшибкаОбработкаНавигационнойСсылки(
	Элемент,
	НавигационнаяСсылкаФорматированнойСтроки,
	СтандартнаяОбработка)
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "retry" Тогда
		
		СтандартнаяОбработка = Ложь;
		ЗаполнитьДоступныеОблачныеКассы();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	Если Не ПроверитьЗаполнениеНаКлиенте() Тогда
		Возврат;
	КонецЕсли;
	
	Если Записать() Тогда
		
		ПараметрыПодключения = ПараметрыПодключения();
		
		РезультатСохранения = СохранитьПараметрыПодключения(ПараметрыПодключения);
		Если ПустаяСтрока(РезультатСохранения.КодОшибки) Тогда
			Закрыть(Истина);
		Иначе
			ПоказатьПредупреждение(, РезультатСохранения.СообщениеОбОшибке);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Проверить(Команда)
	
	ПроверитьПараметрыПодключения();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ДоступныеОблачныеКассы

&НаКлиенте
Процедура ЗаполнитьДоступныеОблачныеКассы()
	
	Элементы.СтраницыСостоянийЗагрузки.ТекущаяСтраница = Элементы.СтраницаЗагрузка;
	
	ДлительнаяОперация    = ПолучитьДоступныеОблачныеКассыВФоне(УникальныйИдентификатор);
	ОповещениеОЗавершении = Новый ОписаниеОповещения("ЗаполнитьДоступныеОблачныеКассыЗавершение", ЭтотОбъект);
	
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
	
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, ОповещениеОЗавершении, ПараметрыОжидания);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьДоступныеОблачныеКассыВФоне(Знач ИдентификаторФормы)
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияФункции(ИдентификаторФормы);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Загрузка списка доступных Облачных касс';
															|en = 'Importing the list of available Cloud cash accounts'");
	ПараметрыВыполнения.ЗапуститьВФоне              = Истина;
	ПараметрыВыполнения.ОжидатьЗавершение           = 0;
	
	РезультатВыполнения = ДлительныеОперации.ВыполнитьФункцию(
		ПараметрыВыполнения,
		"ОблачныеКассыСлужебный.ДоступныеОблачныеКассы");
	
	Возврат РезультатВыполнения;
	
КонецФункции

&НаКлиенте
Процедура ЗаполнитьДоступныеОблачныеКассыЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	ИначеЕсли Результат.Статус = "Выполнено" Тогда
		
		СообщениеОбОшибке = ЗаполнитьДоступныеОблачныеКассыНаСервере(Результат.АдресРезультата);
		Если ПустаяСтрока(СообщениеОбОшибке) Тогда
			ИдентификаторДоИзменения = Объект.Идентификатор;
		Иначе
			ПоказатьОшибкуЗаполненияСпискаДоступныхОблачныхКасс(СообщениеОбОшибке);
		КонецЕсли;
		
	ИначеЕсли Результат.Статус = "Ошибка" Тогда
		ПоказатьОшибкуЗаполненияСпискаДоступныхОблачныхКасс(Результат.КраткоеПредставлениеОшибки);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ЗаполнитьДоступныеОблачныеКассыНаСервере(Знач АдресРезультата)
	
	Результат = "";
	
	РезультатОперации = ПолучитьИзВременногоХранилища(АдресРезультата); // см. ОблачныеКассыСлужебный.ДоступныеОблачныеКассы
	Если ПустаяСтрока(РезультатОперации.КодОшибки) Тогда
		
		Элементы.СтраницыСостоянийЗагрузки.ТекущаяСтраница = Элементы.СтраницаЗагружено;
		
		Для Каждого ОблачнаяКасса Из РезультатОперации.ОблачныеКассы Цикл
			ЗаполнитьЗначенияСвойств(ДоступныеОблачныеКассы.Добавить(), ОблачнаяКасса);
			РезультатПоиска = Элементы.Идентификатор.СписокВыбора.НайтиПоЗначению(ОблачнаяКасса.Идентификатор);
			Если РезультатПоиска = Неопределено Тогда
				Элементы.Идентификатор.СписокВыбора.Добавить(ОблачнаяКасса.Идентификатор, ОблачнаяКасса.Представление);
			ИначеЕсли РезультатПоиска.Представление <> ОблачнаяКасса.Представление Тогда
				РезультатПоиска.Представление = ОблачнаяКасса.Представление;
			КонецЕсли;
		КонецЦикла;
		ДоступныеОблачныеКассы.Сортировать("Представление");
		Элементы.Идентификатор.СписокВыбора.СортироватьПоПредставлению();
		
		ЗаполнитьПараметрыПодключения();
		
	Иначе
		Результат = РезультатОперации.СообщениеОбОшибке;
	КонецЕсли;
	
	УдалитьИзВременногоХранилища(АдресРезультата);
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область ПараметрыПодключения

&НаСервере
Процедура ЗаполнитьПараметрыПодключенияПоОбъекту()
	
	Если Элементы.Идентификатор.СписокВыбора.НайтиПоЗначению(Объект.Идентификатор) = Неопределено Тогда
		Элементы.Идентификатор.СписокВыбора.Добавить(Объект.Идентификатор, Объект.Наименование);
	КонецЕсли;
	
	ПараметрыАутентификации = ОблачныеКассыСлужебный.ПараметрыАутентификации(Объект.Ссылка);
	Если ПараметрыАутентификации <> Неопределено Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ПараметрыАутентификации);
	КонецЕсли;
	
	ОбновитьИнформацияОПодключении(ЭтотОбъект, Объект.Наименование, Объект.АдресСервиса);
	АктивироватьСтраницуПараметровАутентификации(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПараметрыПодключения()
	
	Если Не ПустаяСтрока(Объект.Идентификатор) Тогда
		
		РезультатПоиска = ДоступныеОблачныеКассы.НайтиСтроки(
			Новый Структура("Идентификатор", Объект.Идентификатор));
		
		ТекущийИдентификатор = Элементы.Идентификатор.СписокВыбора.НайтиПоЗначению(Объект.Идентификатор);
		
		// Подключение к ранее сохраненной облачной кассе больше не доступно
		Если РезультатПоиска.Количество() = 0 Тогда
			
			УдалитьИдентификатор          = Объект.Идентификатор;
			ТекущийИдентификатор.Картинка = БиблиотекаКартинок.ОформлениеЗнакВосклицательныйЗнак;
			
			ОбщегоНазначения.СообщитьПользователю(
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Облачная касса ""%1"" больше не доступна для фискализации.';
						|en = 'The ""%1"" cloud cash account is no longer available for fiscalization.'"),
					Объект.Наименование),
				Объект.Ссылка,
				"Идентификатор",
				"Объект");
			
		Иначе
			
			ТекущийИдентификатор.Картинка = Новый Картинка();
			
			ДоступнаяОблачнаяКасса  = РезультатПоиска[0];
			ТипАутентификации       = ДоступнаяОблачнаяКасса.ТипАутентификации;
			ПараметрыАутентификации = ОблачныеКассыСлужебный.ПараметрыАутентификации(Объект.Ссылка);
			
			Если Объект.Наименование <> Лев(ДоступнаяОблачнаяКасса.Представление, 150) Тогда
				Объект.Наименование = ДоступнаяОблачнаяКасса.Представление;
			КонецЕсли;
			Если Объект.АдресСервиса <> ДоступнаяОблачнаяКасса.АдресСервиса Тогда
				Объект.АдресСервиса = ДоступнаяОблачнаяКасса.АдресСервиса;
			КонецЕсли;
			
			Если ПараметрыАутентификации <> Неопределено Тогда
				ЗаполнитьЗначенияСвойств(ЭтотОбъект, ПараметрыАутентификации);
			КонецЕсли;
			
			ОбновитьИнформацияОПодключении(
				ЭтотОбъект,
				ДоступнаяОблачнаяКасса.Представление,
				ДоступнаяОблачнаяКасса.АдресСервиса);
			АктивироватьСтраницуПараметровАутентификации(ЭтотОбъект);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ПараметрыПодключения()
	
	Результат = ОблачныеКассыКлиентСервер.НовыйПараметрыПодключения();
	Результат.НастройкаПодключения    = Объект.Ссылка;
	Результат.Идентификатор           = Объект.Идентификатор;
	Результат.ПараметрыАутентификации = ПараметрыАутентификацииПоДаннымФормы();
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Асинх Процедура ПроверитьПараметрыПодключения()
	
	Если Не ПроверитьЗаполнениеНаКлиенте() Тогда
		Возврат;
	КонецЕсли;
	
	Состояние(
		НСтр("ru = 'Проверка параметров подключения к Облачной кассе.';
			|en = 'Check parameters of connection to the Cloud cash account.'"),
		,
		НСтр("ru = 'Пожалуйста, подождите...';
			|en = 'Please wait…'"));
	
	ПараметрыПодключения = ПараметрыПодключения();
	
	РезультатПроверки = ПроверитьПараметрыПодключенияНаСервере(ПараметрыПодключения);
	Если РезультатПроверки.КодОшибки = КодОшибкиНеПодключенаИнтернетПоддержка()
		И ИнтернетПоддержкаПользователейКлиент.ДоступноПодключениеИнтернетПоддержки() Тогда
		
		ТекстВопроса = НСтр("ru = 'Для работы с Облачными кассами необходимо подключить Интернет-поддержку пользователей.
			|Подключить?';
			|en = 'To use the Cloud cash accounts, connect the online user support.
			|Connect?'");
		Ответ = Ждать ВопросАсинх(ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		Если Ответ = КодВозвратаДиалога.Да Тогда
			ОповещениеОЗавершении = Новый ОписаниеОповещения("ПослеПодключенияИнтернетПоддержки", ЭтотОбъект);
			ИнтернетПоддержкаПользователейКлиент.ПодключитьИнтернетПоддержкуПользователей(
				ОповещениеОЗавершении,
				ЭтотОбъект);
		Иначе
			ПоказатьПредупреждение(, РезультатПроверки.СообщениеОбОшибке);
		КонецЕсли;
		
	ИначеЕсли Не ПустаяСтрока(РезультатПроверки.КодОшибки) Тогда
		ПоказатьПредупреждение(, РезультатПроверки.СообщениеОбОшибке);
	Иначе
		ПоказатьПредупреждение(, НСтр("ru = 'Проверка подключения выполнена успешно.';
										|en = 'Connection is checked.'"));
	КонецЕсли;
	
	Состояние();
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПроверитьПараметрыПодключенияНаСервере(Знач ПараметрыПодключения)
	
	Если ИнтернетПоддержкаПользователей.ЗаполненыДанныеАутентификацииПользователяИнтернетПоддержки() Тогда
		Результат = ОблачныеКассыСлужебный.ПроверитьПараметрыПодключения(ПараметрыПодключения);
	Иначе
		Результат = Новый Структура();
		Результат.Вставить("КодОшибки"         , КодОшибкиНеПодключенаИнтернетПоддержка());
		Результат.Вставить("СообщениеОбОшибке" , НСтр("ru = 'Интернет-поддержка пользователей не подключена.';
														|en = 'Online user support is disabled.'"));
		Результат.Вставить("ИнформацияОбОшибке", Результат.СообщениеОбОшибке);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция КодОшибкиНеПодключенаИнтернетПоддержка()
	
	Возврат "НеПодключенаИнтернетПоддержка";
	
КонецФункции

&НаКлиенте
Процедура ПослеПодключенияИнтернетПоддержки(Результат, ДополнительныеПараметры) Экспорт
	
	ПроверитьПараметрыПодключения();
	
КонецПроцедуры

&НаКлиенте
Функция ПроверитьЗаполнениеНаКлиенте()
	
	ЕстьОшибки           = Ложь;
	ПроверяемыеРеквизиты = Новый СписокЗначений();
	ШаблонСообщения      = НСтр("ru = 'Поле ""%1"" не заполнено.';
								|en = 'Field %1 is required.'");
	
	ПроверяемыеРеквизиты.Добавить("Идентификатор", НСтр("ru = 'Облачная касса';
														|en = 'Cloud cash account'"), Истина);
	Если ТипАутентификации = ОблачныеКассыКлиентСервер.ТипАутентификацииBasic() Тогда
		ПроверяемыеРеквизиты.Добавить("Логин" , НСтр("ru = 'Логин';
													|en = 'Username'"));
		ПроверяемыеРеквизиты.Добавить("Пароль", НСтр("ru = 'Пароль';
													|en = 'Password'"));
	ИначеЕсли ТипАутентификации = ОблачныеКассыКлиентСервер.ТипАутентификацииBearer() Тогда
		ПроверяемыеРеквизиты.Добавить("Токен", НСтр("ru = 'Токен';
													|en = 'Token'"));
	ИначеЕсли ТипАутентификации = ОблачныеКассыКлиентСервер.ТипАутентификацииSalesRegisterGroup() Тогда
		ПроверяемыеРеквизиты.Добавить("ИдентификаторМагазина"  , НСтр("ru = 'Идентификатор магазина';
																		|en = 'Shop ID'"));
		ПроверяемыеРеквизиты.Добавить("ИдентификаторГруппыКасс", НСтр("ru = 'Идентификатор группы';
																		|en = 'Group ID'"));
		ПроверяемыеРеквизиты.Добавить("СекретныйКлючМагазина"  , НСтр("ru = 'Секретный ключ магазина';
																		|en = 'Secret shop key'"));
	КонецЕсли;
	
	Для Каждого ПроверяемыйРеквизит Из ПроверяемыеРеквизиты Цикл
		Если ПроверяемыйРеквизит.Пометка
			И Не ЗначениеЗаполнено(Объект[ПроверяемыйРеквизит.Значение])
			Или Не ПроверяемыйРеквизит.Пометка
			И Не ЗначениеЗаполнено(ЭтотОбъект[ПроверяемыйРеквизит.Значение]) Тогда
			
			ОбщегоНазначенияКлиент.СообщитьПользователю(
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					ШаблонСообщения,
					ПроверяемыйРеквизит.Представление),
				Объект.Ссылка,
				ПроверяемыйРеквизит.Значение,
				?(ПроверяемыйРеквизит.Пометка, "Объект", ""),
				ЕстьОшибки);
			
		КонецЕсли;
	КонецЦикла;
	
	Возврат Не ЕстьОшибки;
	
КонецФункции

&НаКлиенте
Функция ПараметрыАутентификацииПоДаннымФормы()
	
	Если ТипАутентификации = ОблачныеКассыКлиентСервер.ТипАутентификацииBasic() Тогда
		Результат = ОблачныеКассыКлиентСервер.НовыйПараметрыАутентификацииBasic();
		Результат.Логин  = Логин;
		Результат.Пароль = Пароль;
	ИначеЕсли ТипАутентификации = ОблачныеКассыКлиентСервер.ТипАутентификацииBearer() Тогда
		Результат = ОблачныеКассыКлиентСервер.НовыйПараметрыАутентификацииBearer();
		Результат.Токен = Токен;
	ИначеЕсли ТипАутентификации = ОблачныеКассыКлиентСервер.ТипАутентификацииSalesRegisterGroup() Тогда
		Результат = ОблачныеКассыКлиентСервер.НовыйПараметрыАутентификацииSalesRegisterGroup();
		Результат.ИдентификаторМагазина   = ИдентификаторМагазина;
		Результат.ИдентификаторГруппыКасс = ИдентификаторГруппыКасс;
		Результат.СекретныйКлючМагазина   = СекретныйКлючМагазина;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция СохранитьПараметрыПодключения(Знач ПараметрыПодключения)
	
	Возврат ОблачныеКассыСлужебный.СохранитьПараметрыПодключения(ПараметрыПодключения);
	
КонецФункции

#КонецОбласти

#Область УправлениеЭлементамиФормы

&НаКлиентеНаСервереБезКонтекста
Процедура АктивироватьСтраницуПараметровАутентификации(Форма)
	
	Элементы = Форма.Элементы;
	
	Элементы.СтраницыПараметровПодключения.ТекущаяСтраница = Элементы.СтраницаПараметровПодключения;
	Если Форма.ТипАутентификации = ОблачныеКассыКлиентСервер.ТипАутентификацииBasic() Тогда
		Элементы.ТипыАутентификации.ТекущаяСтраница = Элементы.АутентификацияBasic;
	ИначеЕсли Форма.ТипАутентификации = ОблачныеКассыКлиентСервер.ТипАутентификацииBearer() Тогда
		Элементы.ТипыАутентификации.ТекущаяСтраница = Элементы.АутентификацияBearer;
	ИначеЕсли Форма.ТипАутентификации = ОблачныеКассыКлиентСервер.ТипАутентификацииSalesRegisterGroup() Тогда
		Элементы.ТипыАутентификации.ТекущаяСтраница = Элементы.АутентификацияSalesRegisterGroup;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьИнформацияОПодключении(Форма, Представление, АдресСервиса)
	
	ШаблонСтроки = НСтр(
		"ru = 'Для подключения к Облачной кассе заполните настройки. Получить данные для настройки можно в <a href=""%1"">%2</a>.';
		|en = 'To connect to the Cloud cash account, fill the settings. You can get the setting data at <a href=""%1"">%2</a>.'");
	
	#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
		ФорматированнаяСтрока = СтроковыеФункции.ФорматированнаяСтрока(
			ШаблонСтроки,
			АдресСервиса,
			Представление);
	#Иначе
		ФорматированнаяСтрока = СтроковыеФункцииКлиент.ФорматированнаяСтрока(
			ШаблонСтроки,
			АдресСервиса,
			Представление);
	#КонецЕсли
	
	Форма.Элементы.ИнформацияОПодключении.Заголовок = ФорматированнаяСтрока;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьОшибкуЗаполненияСпискаДоступныхОблачныхКасс(ТекстОшибки)
	
	Элементы.СтраницыСостоянийЗагрузки.ТекущаяСтраница = Элементы.СтраницаОшибка;
	
	ПоказатьПредупреждение(, ТекстОшибки);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
