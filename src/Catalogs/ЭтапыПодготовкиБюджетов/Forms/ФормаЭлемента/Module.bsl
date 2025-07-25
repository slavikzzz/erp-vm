
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	ТекущееДействие = Объект.Действие;
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		Если Не ЗначениеЗаполнено(Объект.Владелец) Тогда
			ЗначениеВладелец = Неопределено;
			Если НЕ Параметры.ЗначенияЗаполнения.Свойство("Владелец", ЗначениеВладелец) 
				ИЛИ НЕ ЗначениеЗаполнено(ЗначениеВладелец) Тогда
				
				ВызватьИсключение НСтр("ru = 'Для нового этапа подготовки бюджетов не задана модель бюджетирования.';
										|en = 'Budgeting model is not specified for a new budgeting step.'");
				
			КонецЕсли;
		КонецЕсли;
		
		ЗначениеКопировать = Неопределено;
		Если Параметры.Свойство("ЗначениеКопирования", ЗначениеКопировать) Тогда
			
			ХранилищеНастроекДействия = ЗначениеКопировать.НастройкаДействия; // ХранилищеЗначения
			ТаблицаНастроек = ХранилищеНастроекДействия.Получить();
			Если ТаблицаНастроек <> Неопределено Тогда
				 ПоместитьНастройкиДействияВоВременноеХранилище(ТаблицаНастроек);
			КонецЕсли;
			
			ХранилищеНастроекКонтрольныхОтчетов = ЗначениеКопировать.НастройкиКонтрольныхОтчетов; // ХранилищеЗначения
			ТаблицаНастройкиКонтрольныхОтчетов = ХранилищеНастроекКонтрольныхОтчетов.Получить();
			Если ТаблицаНастройкиКонтрольныхОтчетов <> Неопределено Тогда
				НастройкиКонтрольныхОтчетов.Загрузить(ТаблицаНастройкиКонтрольныхОтчетов);
			КонецЕсли;
			
		КонецЕсли;
	КонецЕсли;
	
	// СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
	
	УправлениеФормой();
		
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ТаблицаНастроек = ТекущийОбъект.НастройкаДействия.Получить();
	Если ТаблицаНастроек <> Неопределено Тогда
		 ПоместитьНастройкиДействияВоВременноеХранилище(ТаблицаНастроек);
	КонецЕсли;
	
	ТаблицаНастройкиКонтрольныхОтчетов = ТекущийОбъект.НастройкиКонтрольныхОтчетов.Получить();
	Если ТаблицаНастройкиКонтрольныхОтчетов <> Неопределено Тогда
		НастройкиКонтрольныхОтчетов.Загрузить(ТаблицаНастройкиКонтрольныхОтчетов);
	КонецЕсли;
	
	ВыполнятьАвтоматически = Объект.ВыполнятьАвтоматически;

	МодификацияКонфигурацииПереопределяемый.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ТаблицаНастроек = ПолучитьНастройкиДействияИзВременноеХранилище();

	ТекущийОбъект.НастройкаДействия = Новый ХранилищеЗначения(ТаблицаНастроек);

	ТекущийОбъект.НастройкиКонтрольныхОтчетов = Новый ХранилищеЗначения(НастройкиКонтрольныхОтчетов.Выгрузить());
	
	Если ТекущийОбъект.ВыполнятьАвтоматически Тогда
		ТекущийОбъект.Ответственный = Неопределено;
	КонецЕсли;
	
	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)

	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
	
	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	Ошибки = Неопределено;
	
	Если Объект.Действие <> Перечисления.ТипыДействийЭтаповПодготовкиБюджетов.УтверждениеБюджетов Тогда
		
		НастройкаДействия = ПолучитьНастройкиДействияИзВременноеХранилище();
		
		СтруктураПроверки = Новый Структура;
		Для Каждого СтрокаДействия Из НастройкаДействия Цикл
			СтруктураПроверки.Вставить(СтрокаДействия.Имя, СтрокаДействия.Значение);
		КонецЦикла;
		
		Если Объект.Действие = Перечисления.ТипыДействийЭтаповПодготовкиБюджетов.УстановкаЗначенийНефинансовыхПоказателей Тогда
			Если Не СтруктураПроверки.Свойство("ВидОперации") Тогда
				СтруктураПроверки.Вставить("ВидОперации", Неопределено);
			КонецЕсли;
			Если Не СтруктураПроверки.Свойство("НефинансовыйПоказатель") Тогда
				СтруктураПроверки.Вставить("НефинансовыйПоказатель", Неопределено);
			КонецЕсли;
			Если Не СтруктураПроверки.Свойство("ШаблонВвода") Тогда
				СтруктураПроверки.Вставить("ШаблонВвода", Неопределено);
			КонецЕсли;
		КонецЕсли;
		
		РеквизитыДляПроверки = Перечисления.ТипыДействийЭтаповПодготовкиБюджетов.РеквизитыПоТипуДействия(
																	СтруктураПроверки, Объект.Действие, Объект.Владелец);
		
		Для Каждого Реквизит Из РеквизитыДляПроверки Цикл
			НайденныеСтроки = НастройкаДействия.НайтиСтроки(Новый Структура("Имя", Реквизит));
			Если Не НайденныеСтроки.Количество() ИЛИ Не ЗначениеЗаполнено(НайденныеСтроки[0].Значение) Тогда
				ТекстОшибки = НСтр("ru = 'Не заданы настройки действия';
									|en = 'Action settings are not specified'");
				ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "", ТекстОшибки, "");
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки, Отказ);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ДействиеПриИзменении(Элемент)
	
	ДействиеПриИзмененииСервер();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура НастроитьДействие(Команда)
	
	Отказ = Ложь;
	Если Объект.Действие = ПредопределенноеЗначение("Перечисление.ТипыДействийЭтаповПодготовкиБюджетов.УтверждениеБюджетов") Тогда
		Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
			ТекстВопроса = НСтр("ru = 'Для настройки действия необходимо записать объект. Записать?';
								|en = 'To configure the action, save the object. Do you want to save it?'");
			ОписаниеОповещения = Новый ОписаниеОповещения("НастроитьДействиеЗавершение", ЭтотОбъект);
			
			ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	НастроитьДействиеФрагмент(Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьДействиеЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		Отказ = НЕ Записать();
	Иначе
		Отказ = Истина;
	КонецЕсли;
	
	НастроитьДействиеФрагмент(Отказ);

КонецПроцедуры

&НаКлиенте
Процедура НастроитьДействиеФрагмент(Знач Отказ)
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Адрес = ?(ЗначениеЗаполнено(АдресНастройкаДействия), АдресНастройкаДействия, ПоместитьНастройкиДействияВоВременноеХранилище());
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("Адрес", Адрес);
	ПараметрыФормы.Вставить("ЭтапПодготовкиБюджетов",	Объект.Ссылка);
	ПараметрыФормы.Вставить("МодельБюджетирования", Объект.Владелец);
	
	Оповещение = Новый ОписаниеОповещения("ПриЗакрытииФормыНастройкиДействия", ЭтаФорма);
	
	ИмяФормыНастройки = ИмяФормыНастройкиНаСервере(Объект.Действие);
	ОткрытьФорму(ИмяФормыНастройки, ПараметрыФормы, ЭтаФорма, , , , Оповещение);

КонецПроцедуры

&НаКлиенте
Процедура НастроитьКонтрольныеОтчеты(Команда)
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("Адрес",					ПоместитьНастройкиКонтрольныхОтчетовВоВременноеХранилище());
	ПараметрыФормы.Вставить("ЭтапПодготовкиБюджетов",	Объект.Ссылка);
	ПараметрыФормы.Вставить("МодельБюджетирования",		Объект.Владелец);
	
	Оповещение = Новый ОписаниеОповещения("ПриЗакрытииФормыНастройкиКонтрольныхОтчетов", ЭтаФорма);
	
	ОткрытьФорму("Справочник.ЭтапыПодготовкиБюджетов.Форма.НастройкаКонтрольныхОтчетов", 
		ПараметрыФормы, ЭтаФорма, , , , Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура Подключаемый_РазрешитьРедактированиеРеквизитовОбъекта(Команда)
	
	ОбщегоНазначенияУТКлиент.РазрешитьРедактированиеРеквизитовОбъекта(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура НастроитьСписокДействийШага()
	
	РеквизитыМодели = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
						Объект.Владелец, "ИспользоватьУтверждениеБюджетов");
		
	Если Не РеквизитыМодели.ИспользоватьУтверждениеБюджетов 
		И Не Объект.Действие = Перечисления.ТипыДействийЭтаповПодготовкиБюджетов.УтверждениеБюджетов Тогда
		
		УдалитьДействиеИзСписка(Перечисления.ТипыДействийЭтаповПодготовкиБюджетов.УтверждениеБюджетов);
	КонецЕсли;

	Если Не (ПолучитьФункциональнуюОпцию("ИспользоватьПланированиеЗакупок")
		Или ПолучитьФункциональнуюОпцию("ИспользоватьПланированиеПродаж")
		Или ПолучитьФункциональнуюОпцию("ИспользоватьПланированиеПроизводства")
		Или ПолучитьФункциональнуюОпцию("ИспользоватьПланированиеСборкиРазборки")
		Или ПолучитьФункциональнуюОпцию("ИспользоватьПланированиеВнутреннихПотреблений")) Тогда
		УдалитьДействиеИзСписка(Перечисления.ТипыДействийЭтаповПодготовкиБюджетов.ВводПлана);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УдалитьДействиеИзСписка(ТипДействия)
	
	ЭлементСписка = Элементы.Действие.СписокВыбора.НайтиПоЗначению(ТипДействия);
	Если ЭлементСписка <> Неопределено Тогда
		Элементы.Действие.СписокВыбора.Удалить(ЭлементСписка);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ДействиеПриИзмененииСервер()
	
	Если Объект.Действие = ТекущееДействие Тогда
		Возврат;
	КонецЕсли;
	
	Если Объект.Действие = Перечисления.ТипыДействийЭтаповПодготовкиБюджетов.ПовторГруппыЭтапов
		И Не Объект.ВыполнятьАвтоматически Тогда
		
		Объект.ВыполнятьАвтоматически = Истина;
		ВыполнятьАвтоматически = Объект.ВыполнятьАвтоматически;
		
	КонецЕсли;
	
	АдресНастройкаДействия = "";
	ТекущееДействие = Объект.Действие;
	
	УправлениеФормой();
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ИмяФормыНастройкиНаСервере(Действие)
	
	Возврат Перечисления.ТипыДействийЭтаповПодготовкиБюджетов.ИмяФормы(Действие)
	
КонецФункции

&НаСервере
Процедура УправлениеФормой()
	
	СписокВыбораДействий = Элементы.Действие.СписокВыбора;
	СписокВыбораДействий.Очистить();
	Если ВыполнятьАвтоматически Тогда
		СписокВыбораДействий.Добавить(Перечисления.ТипыДействийЭтаповПодготовкиБюджетов.ВводБюджетов);
		СписокВыбораДействий.Добавить(Перечисления.ТипыДействийЭтаповПодготовкиБюджетов.УстановкаЗначенийНефинансовыхПоказателей);
		СписокВыбораДействий.Добавить(Перечисления.ТипыДействийЭтаповПодготовкиБюджетов.ПовторГруппыЭтапов);
	Иначе
		СписокВыбораДействий.Добавить(Перечисления.ТипыДействийЭтаповПодготовкиБюджетов.ВводБюджетов);
		СписокВыбораДействий.Добавить(Перечисления.ТипыДействийЭтаповПодготовкиБюджетов.ВводПлана);
		СписокВыбораДействий.Добавить(Перечисления.ТипыДействийЭтаповПодготовкиБюджетов.УстановкаЗначенийНефинансовыхПоказателей);
		СписокВыбораДействий.Добавить(Перечисления.ТипыДействийЭтаповПодготовкиБюджетов.УтверждениеБюджетов);
		СписокВыбораДействий.Добавить(Перечисления.ТипыДействийЭтаповПодготовкиБюджетов.ПовторГруппыЭтапов);
		СписокВыбораДействий.Добавить(Перечисления.ТипыДействийЭтаповПодготовкиБюджетов.Прочее);
	КонецЕсли;
	
	НастроитьСписокДействийШага();
	
	ЭтоВводБюджета = (Объект.Действие = Перечисления.ТипыДействийЭтаповПодготовкиБюджетов.ВводБюджетов);
	ЭтоДействиеПрочее = (Объект.Действие = Перечисления.ТипыДействийЭтаповПодготовкиБюджетов.Прочее);
	ЭтоДействиеУтверждения = (Объект.Действие = Перечисления.ТипыДействийЭтаповПодготовкиБюджетов.УтверждениеБюджетов);
	
	ВидимостьНастроек = ЗначениеЗаполнено(Объект.Действие) И Не ЭтоДействиеПрочее;
	Элементы.ГруппаДействиеШагаНастройка.Видимость = ВидимостьНастроек;
	
	НастройкаДействия = ПолучитьНастройкиДействияИзВременноеХранилище();
	ПредставлениеДействия = Перечисления.ТипыДействийЭтаповПодготовкиБюджетов.ПолучитьПредставлениеДействия(НастройкаДействия);
	Элементы.ДекорацияНастройки.Заголовок = ПредставлениеДействия;
	
	ЗаголовокКонтрольныеОтчеты = НСтр("ru = 'Настроить контрольные отчеты (%1)';
										|en = 'Set up monitoring reports (%1)'");
	Элементы.НастроитьКонтрольныеОтчеты.Заголовок = 
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			ЗаголовокКонтрольныеОтчеты, 
			НастройкиКонтрольныхОтчетов.Количество());
	
	Элементы.НастроитьКонтрольныеОтчеты.Видимость = ЭтоДействиеПрочее Или ЭтоДействиеУтверждения Или ЭтоВводБюджета;
	
	Элементы.Ответственный.Доступность = Не ВыполнятьАвтоматически;
	Элементы.ГруппаОсновныеДлительность.Доступность = Не ВыполнятьАвтоматически;
	
	Элементы.Ответственный.Доступность = Не ВыполнятьАвтоматически;
	Элементы.ГруппаОсновныеДлительность.Доступность = Не ВыполнятьАвтоматически;
	
	Элементы.ВыполнятьАвтоматически.Доступность = Объект.Действие <> Перечисления.ТипыДействийЭтаповПодготовкиБюджетов.ПовторГруппыЭтапов
	                                            И Не ТолькоПросмотр;
	
	Элементы.ДекорацияНастройки.Доступность = Не ТолькоПросмотр;
	
КонецПроцедуры

&НаСервере
Функция ПоместитьНастройкиКонтрольныхОтчетовВоВременноеХранилище()
	
	Возврат ПоместитьВоВременноеХранилище(НастройкиКонтрольныхОтчетов.Выгрузить(), УникальныйИдентификатор);
	
КонецФункции

&НаСервере
Функция ПоместитьНастройкиДействияВоВременноеХранилище(Знач ТаблицаНастроек = Неопределено)
	
	Если ТаблицаНастроек = Неопределено Тогда
		ТаблицаНастроек = Новый ТаблицаЗначений;
		ТаблицаНастроек.Колонки.Добавить("Имя");
		ТаблицаНастроек.Колонки.Добавить("Значение");
		ТаблицаНастроек.Колонки.Добавить("Представление");
	КонецЕсли;

	Если ЗначениеЗаполнено(АдресНастройкаДействия) Тогда
		АдресНастройкаДействия = ПоместитьВоВременноеХранилище(ТаблицаНастроек, АдресНастройкаДействия);
	Иначе
		АдресНастройкаДействия = ПоместитьВоВременноеХранилище(ТаблицаНастроек, УникальныйИдентификатор);
	КонецЕсли;
	
	Возврат АдресНастройкаДействия;
	
КонецФункции

&НаСервере
Функция ПолучитьНастройкиДействияИзВременноеХранилище()
	
	ТаблицаНастроек = Новый ТаблицаЗначений;
	ТаблицаНастроек.Колонки.Добавить("Имя");
	ТаблицаНастроек.Колонки.Добавить("Значение");
	ТаблицаНастроек.Колонки.Добавить("Представление");

	Если ЗначениеЗаполнено(АдресНастройкаДействия) Тогда
		ТаблицаНастроек = ПолучитьИзВременногоХранилища(АдресНастройкаДействия);
	КонецЕсли;
	
	Возврат ТаблицаНастроек;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьНастройкиКонтрольныхОтчетовСервер(Адрес)
	
	НастройкиКонтрольныхОтчетов.Загрузить(ПолучитьИзВременногоХранилища(Адрес));
	УправлениеФормой();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытииФормыНастройкиДействия(Адрес, ДополнительныеПараметры) Экспорт
	
	Если Адрес = Неопределено Тогда
		Возврат;
	КонецЕсли;
		
	УправлениеФормой();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытииФормыНастройкиКонтрольныхОтчетов(Адрес, ДополнительныеПараметры) Экспорт
	
	Если Адрес = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьНастройкиКонтрольныхОтчетовСервер(Адрес);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнятьАвтоматическиПриИзменении(Элемент)
	
	Объект.ВыполнятьАвтоматически = ВыполнятьАвтоматически;
	
	Если ВыполнятьАвтоматически Тогда
		Объект.Длительность = 1;
		Объект.ТипДлительности = ПредопределенноеЗначение("Перечисление.ТипыСроковЭтаповПодготовкиБюджетов.ВКалендарныхДнях");
		Если Объект.Действие <> ПредопределенноеЗначение("Перечисление.ТипыДействийЭтаповПодготовкиБюджетов.ВводБюджетов")
			И Объект.Действие <> ПредопределенноеЗначение("Перечисление.ТипыДействийЭтаповПодготовкиБюджетов.УстановкаЗначенийНефинансовыхПоказателей")
			И Объект.Действие <> ПредопределенноеЗначение("Перечисление.ТипыДействийЭтаповПодготовкиБюджетов.ПовторГруппыЭтапов") Тогда
			
			Объект.Действие = ПредопределенноеЗначение("Перечисление.ТипыДействийЭтаповПодготовкиБюджетов.ВводБюджетов");
			ДействиеПриИзмененииСервер();
			Возврат;
			
		КонецЕсли;
	КонецЕсли;
	
	УправлениеФормой();
	
КонецПроцедуры

#КонецОбласти
