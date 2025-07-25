#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	
	Если ЭтоНовый() И Не ЭтоГруппа
	 	И ТипПлана.Пустая() Тогда
		
		ДоступныеТипы = Новый Массив;
		Если ПолучитьФункциональнуюОпцию("ИспользоватьПланированиеЗакупок") Тогда
			ДоступныеТипы.Добавить(Перечисления.ТипыПланов.ПланЗакупок);
		КонецЕсли;
		Если ПолучитьФункциональнуюОпцию("ИспользоватьПланированиеОстатков") Тогда
			ДоступныеТипы.Добавить(Перечисления.ТипыПланов.ПланОстатков);
		КонецЕсли;
		Если ПолучитьФункциональнуюОпцию("ИспользоватьПланированиеПродажПоКатегориям") Тогда
			ДоступныеТипы.Добавить(Перечисления.ТипыПланов.ПланПродажПоКатегориям);
		КонецЕсли;
		Если ПолучитьФункциональнуюОпцию("ИспользоватьПланированиеПродаж") Тогда
			ДоступныеТипы.Добавить(Перечисления.ТипыПланов.ПланПродаж);
		КонецЕсли;
		Если ПолучитьФункциональнуюОпцию("ИспользоватьПланированиеСборкиРазборки") Тогда
			ДоступныеТипы.Добавить(Перечисления.ТипыПланов.ПланСборкиРазборки);
		КонецЕсли;
		Если ПолучитьФункциональнуюОпцию("ИспользоватьПланированиеВнутреннихПотреблений") Тогда
			ДоступныеТипы.Добавить(Перечисления.ТипыПланов.ПланВнутреннихПотреблений);
		КонецЕсли;
		//++ НЕ УТ
		Если ПолучитьФункциональнуюОпцию("ИспользоватьПланированиеПроизводства") Тогда
			ДоступныеТипы.Добавить(Перечисления.ТипыПланов.ПланПроизводства);
		КонецЕсли;
		//-- НЕ УТ
		
		Если ДанныеЗаполнения <> Неопределено 
			И ДанныеЗаполнения.Свойство("ТипПлана") 
			И ДоступныеТипы.Найти(ДанныеЗаполнения.ТипПлана) <> Неопределено Тогда
			ТипПлана = ДанныеЗаполнения.ТипПлана;
		ИначеЕсли ДоступныеТипы.Количество() > 0 Тогда
			ТипПлана = ДоступныеТипы[0];
		КонецЕсли;
		
	КонецЕсли;
	
	Если ТипДанныхЗаполнения = Тип("Структура") Тогда
		ЗаполнитьВидПланаПоОтбору(ДанныеЗаполнения);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Если Не ЭтоГруппа Тогда
		//++ Локализация
		ИдентификаторМоделиПрогнозирования = -1;
		//-- Локализация
	КонецЕсли;
	
КонецПроцедуры


Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	Если ЭтоНовый() Тогда
		
		Если ПланированиеОстатков
			И ЭтоГруппа Тогда
			ПорядокПланирования = 0;
		Иначе
			ПорядокПланирования = ПолучитьНовыйПорядокПланирования(ЭтотОбъект.Владелец);
		КонецЕсли;
		
	ИначеЕсли Не ЭтоГруппа Тогда
		
		ПроверитьСоответствиеТиповПланирования(Отказ);
		
		ЭтапПланированияДоЗаписи = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "Родитель");
		Если ЭтапПланированияДоЗаписи <> ЭтотОбъект.Родитель Тогда
			
			ПорядокПланирования = ПолучитьНовыйПорядокПланирования(ЭтотОбъект.Владелец);
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если ЭтоГруппа Тогда	
		Возврат;
	КонецЕсли;
	
	Если ЗаполнятьПоФормуле Тогда
		ЗаполнятьПартнераВТЧ = Ложь;
		ЗаполнятьСоглашениеВТЧ = Ложь;
		ЗаполнятьСкладВТЧ = Ложь;
	КонецЕсли;
	
	Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоСкладов") Тогда
		ЗаполнятьСклад = Истина;
	КонецЕсли;
	
	ИспользоватьСоглашенияСКлиентами = ПолучитьФункциональнуюОпцию("ИспользоватьСоглашенияСКлиентами");
	Если ТипПлана = Перечисления.ТипыПланов.ПланПроизводства Тогда
		ЗаполнятьПартнера = Ложь;
		ЗаполнятьПартнераВТЧ = Ложь;
		ЗаполнятьСоглашение = Ложь;
		ЗаполнятьСоглашениеВТЧ = Ложь;
		ЗаполнятьСклад = Ложь;
		ЗаполнятьСкладВТЧ = Ложь;
		ЗаполнятьПланОплат = Ложь;
	ИначеЕсли ТипПлана = Перечисления.ТипыПланов.ПланПродаж И НЕ ИспользоватьСоглашенияСКлиентами Тогда
		ЗаполнятьСоглашение = Ложь;
		ЗаполнятьСоглашениеВТЧ = Ложь;
	КонецЕсли;
	Если ЗаполнятьПланОплат И (ЗаполнятьПартнераВТЧ ИЛИ ЗаполнятьСоглашениеВТЧ) Тогда
		ЗаполнятьПланОплат = Ложь;
	КонецЕсли;
	Если ЗаполнятьФорматМагазина
		И (ЗаполнятьСклад 
		ИЛИ ЗаполнятьСкладВТЧ)
		И (ТипПлана = Перечисления.ТипыПланов.ПланПродаж 
		ИЛИ ТипПлана = Перечисления.ТипыПланов.ПланПродажПоКатегориям) Тогда
		ЗаполнятьФорматМагазина = Ложь;
	КонецЕсли; 
	Если ЗаполнятьФорматМагазина И НЕ ПолучитьФункциональнуюОпцию("ИспользоватьФорматыМагазинов") Тогда
		ЗаполнятьФорматМагазина = Ложь;
	КонецЕсли; 
	Если НЕ ЗаполнятьПартнера И НЕ ЗаполнятьПартнераВТЧ Тогда
		ЗаполнятьСоглашение = Ложь;
		ЗаполнятьСоглашениеВТЧ = Ложь;
	ИначеЕсли НЕ ЗаполнятьПартнера И ЗаполнятьПартнераВТЧ Тогда
		ЗаполнятьСоглашение = Ложь;
	КонецЕсли;
	
	Если ЗаполнятьПланОплат 
		И (ТипПлана = Перечисления.ТипыПланов.ПланЗакупок 
		ИЛИ ТипПлана = Перечисления.ТипыПланов.ПланПродаж) Тогда
		
		Реквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Владелец, "ПланЗакупокПланироватьПоСумме, ПланПродажПланироватьПоСумме");
		
		Если ТипПлана = Перечисления.ТипыПланов.ПланЗакупок 
			И НЕ Реквизиты.ПланЗакупокПланироватьПоСумме
			ИЛИ ТипПлана = Перечисления.ТипыПланов.ПланПродаж 
			И НЕ Реквизиты.ПланПродажПланироватьПоСумме Тогда
		
			ЗаполнятьПланОплат = Ложь;
		
		КонецЕсли; 
		
	КонецЕсли; 
	
	//++ НЕ УТ
	Если НЕ ОтражаетсяВБюджетировании Тогда
		СтатьяБюджетов = Неопределено;
	КонецЕсли;
	
	Если НЕ ОтражаетсяВБюджетированииОплаты Тогда
		СтатьяБюджетовОплат = Неопределено;
	КонецЕсли;
	
	Если НЕ ОтражаетсяВБюджетированииОплатыКредит Тогда
		СтатьяБюджетовОплатКредит = Неопределено;
	КонецЕсли;
	//-- НЕ УТ
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ЭтоГруппа Тогда
		Если ПланированиеОстатков  Тогда
			Запрос = Новый Запрос;
			Запрос.Текст = 
			"ВЫБРАТЬ
			|	ВидыПланов.Ссылка КАК Ссылка
			|ИЗ
			|	Справочник.ВидыПланов КАК ВидыПланов
			|ГДЕ
			|	ВидыПланов.ПланированиеОстатков
			|	И ВидыПланов.Владелец = &Владелец
			|	И ВидыПланов.Ссылка <> &Ссылка
			|	И НЕ ВидыПланов.ПометкаУдаления
			|	И ВидыПланов.ЭтоГруппа";
			Запрос.УстановитьПараметр("Владелец", Владелец);
			Запрос.УстановитьПараметр("Ссылка",Ссылка);
			
			Если Запрос.Выполнить().Выбрать().Следующий() Тогда
				
				ТекстСообщения = НСтр("ru = 'Этап планирования остатков может быть только один.';
										|en = 'There can be only a single balance projection stage'");
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,,, Отказ);
				
			КонецЕсли;
		КонецЕсли;
		
		Если Не ЭтоНовый() Тогда
			Запрос = Новый Запрос;
			Запрос.Текст = 
			"ВЫБРАТЬ
			|	ВидыПланов.Ссылка КАК Ссылка
			|ИЗ
			|	Справочник.ВидыПланов КАК ВидыПланов
			|ГДЕ
			|	(ВидыПланов.ПланированиеОстатков <> &ПланированиеОстатков
			|	ИЛИ ВидыПланов.ПланированиеПотребностей <> &ПланированиеПотребностей)
			|	И ВидыПланов.Родитель = &Ссылка
			|	И НЕ ВидыПланов.ПометкаУдаления";
			Запрос.УстановитьПараметр("ПланированиеПотребностей", ПланированиеПотребностей);
			Запрос.УстановитьПараметр("ПланированиеОстатков", ПланированиеОстатков);
			Запрос.УстановитьПараметр("Ссылка", Ссылка);
			
			Если Запрос.Выполнить().Выбрать().Следующий() Тогда
				
				ТекстСообщения = НСтр("ru = 'Для этапа планирования введены планы с другим типом планирования, смена типа невозможна.';
										|en = 'For the planning stage, the plans with a different planning type have been entered; you cannot change the type.'");
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,,, Отказ);
				
			КонецЕсли;
		КонецЕсли;
		
		Возврат;
	Иначе
		ПроверитьСоответствиеТиповПланирования(Отказ);
	КонецЕсли;
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	//++ НЕ УТ
	Если НЕ ОтражаетсяВБюджетировании Тогда
		МассивНепроверяемыхРеквизитов.Добавить("СтатьяБюджетов");
	КонецЕсли;
	Если НЕ ОтражаетсяВБюджетированииОплаты Тогда
		МассивНепроверяемыхРеквизитов.Добавить("СтатьяБюджетовОплат");
	КонецЕсли;
	Если НЕ ОтражаетсяВБюджетированииОплатыКредит Тогда
		МассивНепроверяемыхРеквизитов.Добавить("СтатьяБюджетовОплатКредит");
	КонецЕсли;
	//-- НЕ УТ
	
	Если ПолучитьФункциональнуюОпцию("УправлениеТорговлей") Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ОтражаетсяВБюджетировании");
		МассивНепроверяемыхРеквизитов.Добавить("СтатьяБюджетов");
		МассивНепроверяемыхРеквизитов.Добавить("ОтражаетсяВБюджетированииОплаты");
		МассивНепроверяемыхРеквизитов.Добавить("СтатьяБюджетовОплат");
		МассивНепроверяемыхРеквизитов.Добавить("ОтражаетсяВБюджетированииОплатыКредит");
		МассивНепроверяемыхРеквизитов.Добавить("СтатьяБюджетовОплатКредит");
	КонецЕсли;
	
	Если ТипПлана <> Перечисления.ТипыПланов.ПланПроизводства Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ТипПроизводственногоПроцесса");
	КонецЕсли;
	
	Если ТипПлана <> Перечисления.ТипыПланов.ПланСборкиРазборки Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ХозяйственнаяОперация");
	КонецЕсли;
	
	// Сервис прогнозирования.
	Если Не ЗаполнятьПоДаннымСервиса Тогда
		МассивНепроверяемыхРеквизитов.Добавить("МетрикаОценкиКачестваПрогноза");
		МассивНепроверяемыхРеквизитов.Добавить("Периодичность");
		МассивНепроверяемыхРеквизитов.Добавить("НачалоПрогнозирования");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьВидПланаПоОтбору(Знач ДанныеЗаполнения)
	
	Если ДанныеЗаполнения.Свойство("Владелец") И ДанныеЗаполнения.Свойство("ТипПлана") Тогда
		
		Сценарий = ДанныеЗаполнения.Владелец;
		ТипПлана = ДанныеЗаполнения.ТипПлана;
		
		Если НЕ ЗначениеЗаполнено(Сценарий) ИЛИ НЕ ЗначениеЗаполнено(ТипПлана) Тогда
			Возврат;
		КонецЕсли;
		
		ВидПлана = Планирование.ПолучитьВидПланаПоУмолчанию(ТипПлана, Сценарий);
		
		Если ЗначениеЗаполнено(ВидПлана) Тогда
			ИменаРеквизитов = "ЗаполнятьПартнера, ЗаполнятьСоглашение, ЗаполнятьСклад, ЗаполнятьПодразделение, 
				|ЗаполнятьПартнераВТЧ, ЗаполнятьСоглашениеВТЧ, ЗаполнятьСкладВТЧ, ЗаполнятьМенеджера, ЗаполнятьФорматМагазина,
				|ЗапретитьРедактированиеПравила, ЗаполнятьПланОплат, ЗаполнятьПоФормуле";
			//++ НЕ УТ
			ИменаРеквизитов = ИменаРеквизитов + ", ОтражаетсяВБюджетировании, СтатьяБюджетов";
			//-- НЕ УТ
			Реквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ВидПлана, ИменаРеквизитов);
			ЗаполнитьЗначенияСвойств(ЭтотОбъект, Реквизиты);
		КонецЕсли; 
		
	КонецЕсли;
	
КонецПроцедуры

Функция ПолучитьНовыйПорядокПланирования(Сценарий)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	Таблица.ПорядокПланирования КАК ПорядокПланирования
	|ИЗ
	|	Справочник.ВидыПланов КАК Таблица
	|ГДЕ
	|	Таблица.Владелец = &Владелец
	|
	|УПОРЯДОЧИТЬ ПО
	|	ПорядокПланирования УБЫВ");
	Запрос.УстановитьПараметр("Владелец", Сценарий);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	Возврат ?(Не ЗначениеЗаполнено(Выборка.ПорядокПланирования), 1, Выборка.ПорядокПланирования + 1);
	
КонецФункции

Процедура ПроверитьСоответствиеТиповПланирования(Отказ)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ВидыПланов.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ВидыПланов КАК ВидыПланов
	|ГДЕ
	|	(ВидыПланов.ПланированиеОстатков <> &ПланированиеОстатков
	|	ИЛИ ВидыПланов.ПланированиеПотребностей <> &ПланированиеПотребностей)
	|	И ВидыПланов.Ссылка = &Родитель
	|	И НЕ ВидыПланов.ПометкаУдаления";
	Запрос.УстановитьПараметр("ПланированиеПотребностей", ПланированиеПотребностей);
	Запрос.УстановитьПараметр("ПланированиеОстатков", ПланированиеОстатков);
	Запрос.УстановитьПараметр("Родитель", Родитель);
	
	Если Запрос.Выполнить().Выбрать().Следующий() Тогда
		
		ТекстСообщения = НСтр("ru = 'Тип планирования этапа не соответствует типу планирования вида плана.';
								|en = 'The stage planning type does not match the planning type of the plan.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,,, Отказ);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
