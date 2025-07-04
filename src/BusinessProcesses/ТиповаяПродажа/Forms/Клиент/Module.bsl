
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	НачальныйПризнакВыполнения = Объект.Выполнена;
	ЗадачаОбъект = РеквизитФормыВЗначение("Объект");
	ЗаданиеОбъект = ЗадачаОбъект.БизнесПроцесс.ПолучитьОбъект();
	ЗначениеВРеквизитФормы(ЗаданиеОбъект, "Задание");

	ИспользоватьСоглашенияСКлиентами   = ПолучитьФункциональнуюОпцию("ИспользоватьСоглашенияСКлиентами");

	ИспользоватьДатуИВремяВСрокахЗадач = ПолучитьФункциональнуюОпцию("ИспользоватьДатуИВремяВСрокахЗадач");
	Элементы.СрокИсполненияВремя.Видимость = ИспользоватьДатуИВремяВСрокахЗадач;
	Элементы.СрокНачалаИсполненияВремя.Видимость = ИспользоватьДатуИВремяВСрокахЗадач;
	Элементы.ДатаИсполнения.Формат = ?(ИспользоватьДатуИВремяВСрокахЗадач, "ДЛФ=DT", "ДЛФ=D");

	БизнесПроцессыИЗадачиСервер.ФормаЗадачиПриСозданииНаСервере(
		ЭтаФорма, Объект, Элементы.ГруппаСостояние, Элементы.ДатаИсполнения);
	
	РеквизитыСделки = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Задание.Предмет,Новый Структура("Партнер,СоглашениеСКлиентом"));
	
	Клиент = РеквизитыСделки.Партнер;
	Соглашение = РеквизитыСделки.СоглашениеСКлиентом;
	
	УстановитьЗаголовокКомандыКлиент();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_СделкиСКлиентами" Тогда
		
		Если Параметр.Свойство("Партнер") Тогда
			Клиент = Параметр.Партнер;
		КонецЕсли;
		
		Если Параметр.Свойство("СоглашениеСКлиентом") Тогда
			Соглашение = Параметр.СоглашениеСКлиентом;
		КонецЕсли;
		
	КонецЕсли;
	
	УстановитьЗаголовокКомандыКлиент();
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.УправлениеДоступом

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьИЗакрытьВыполнить()

	БизнесПроцессыИЗадачиКлиент.ЗаписатьИЗакрытьВыполнить(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура ВыполненоВыполнить()

	БизнесПроцессыИЗадачиКлиент.ЗаписатьИЗакрытьВыполнить(ЭтаФорма,Истина,Новый Структура("Сделка",Объект.Предмет));

КонецПроцедуры

&НаКлиенте
Процедура Клиент(Команда)

	Если ЗначениеЗаполнено(Клиент) 
		И (Не ИспользоватьСоглашенияСКлиентами Или ЗначениеЗаполнено(Соглашение)) Тогда
	
		ПоказатьЗначение(Неопределено, Клиент);
	
	Иначе
	
		ОткрытьФорму("Справочник.СделкиСКлиентами.Форма.ФормаЭлемента",
		             Новый Структура("Ключ,НеобходимоОповещение",Задание.Предмет,Истина));
	
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьЗаголовокКомандыКлиент()

	Если Не ЗначениеЗаполнено(Клиент) Тогда
		
		Элементы.КомандаКлиент.Заголовок = НСтр("ru = 'Указать клиента и соглашение';
												|en = 'Specify customer and agreement'");
		
	ИначеЕсли ИспользоватьСоглашенияСКлиентами И НЕ ЗначениеЗаполнено(Соглашение) Тогда
		
		Элементы.КомандаКлиент.Заголовок = НСтр("ru = 'Указать соглашение';
												|en = 'Specify agreement'");
		
	Иначе
		
		Элементы.КомандаКлиент.Заголовок = Клиент;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
