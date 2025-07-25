#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);

	
	// подсистема запрета редактирования ключевых реквизитов объектов	
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтаФорма);
		
	ИспользоватьХарактеристики = Константы.ИспользоватьХарактеристикиНоменклатуры.Получить();
	ИспользоватьСерии = Константы.ИспользоватьСерииНоменклатуры.Получить();
		   
	Если Не ИспользоватьСерии Тогда
		
		Элементы.ОписаниеМонотоварности.СписокВыбора.Удалить(2);
		Элементы.ДекорацияМонотоварностьБезСерий.Видимость = Истина;

		Если Не ИспользоватьХарактеристики Тогда
			Элементы.СтраницыМонотоварностьИПриоритетОтбора.ТекущаяСтраница = Элементы.СтраницаБезМонотоварности;
		КонецЕсли;
		
	Иначе
		
		Если Не ИспользоватьХарактеристики Тогда
			Элементы.ОписаниеМонотоварности.СписокВыбора[2].Представление = НСтр("ru = 'по номенклатуре и серии';
																				|en = 'by items and batch'");
			Элементы.ОписаниеМонотоварности.СписокВыбора.Удалить(1);
			Элементы.ДекорацияМонотоварностьБезСерий.Видимость = Истина;
		КонецЕсли;
		
	КонецЕсли;
	
	Если Объект.СтрогаяМонотоварность Тогда
		Размещать = "СтрогаяМонотоварность";
	Иначе
		Размещать = "ПоПриоритетам";
	КонецЕсли;	
	
	НастроитьДоступностьПриоритетовРазмещения();
	
	Если НЕ ЗначениеЗаполнено(Объект.ИспользованиеПериодичностиИнвентаризацииЯчеек) Тогда
		Объект.ИспользованиеПериодичностиИнвентаризацииЯчеек = Перечисления.ВариантыИспользованияПериодическойИнвентаризацииЯчеек.НеИспользовать;		
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		ПриЧтенииСозданииНаСервере();
		
	КонецЕсли;
	
	Элементы.КонтролироватьОбособление.Доступность = ТипХранения = "Обособленный";
		
	Если Не ПравоДоступа("Изменение",Метаданные.Справочники.ОбластиХранения) Тогда
		Элементы.ГруппаХранениеТоваров.Доступность = Ложь;	
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ИнтеграцияС1СДокументооборотом

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом

	// подсистема запрета редактирования ключевых реквизитов объектов	
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтаФорма);

	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если Размещать = "ПоПриоритетам" Тогда
		ТекущийОбъект.СтрогаяМонотоварность = Ложь;
	Иначе
		ТекущийОбъект.СтрогаяМонотоварность = Истина;
	КонецЕсли;	

	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);

	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);
	// Конец ИнтеграцияС1СДокументооборотом
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)

	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульПодключаемыеКомандыКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ПодключаемыеКомандыКлиент");
		МодульПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	ПриЧтенииСозданииНаСервере();
	МодификацияКонфигурацииПереопределяемый.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОписаниеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(
		Элемент.ТекстРедактирования,
		ЭтотОбъект,
		"Объект.Описание",
		НСтр("ru = 'Описание';
			|en = 'Details'"));
	
КонецПроцедуры

&НаКлиенте
Процедура ВладелецПриИзменении(Элемент)
	УстановитьПараметрыФункциональныхОпцийФормы(Новый Структура("Склад", Объект.Владелец))
КонецПроцедуры

&НаКлиенте
Процедура ТипХраненияПриИзменении(Элемент)
	
	Если ТипХранения = "Общий" Тогда
		Элементы.СтраницыСтратегии.ТекущаяСтраница = Элементы.СтратегииДоступны;
		Элементы.КонтролироватьОбособление.Доступность = Ложь;
		Объект.ОбластьОбособленногоХранения = Ложь;
	Иначе
		Элементы.СтраницыСтратегии.ТекущаяСтраница = Элементы.СтратегииНедоступны;
		Элементы.КонтролироватьОбособление.Доступность = Истина;
		Объект.ОбластьОбособленногоХранения = Истина;
	КонецЕсли;
	          	
КонецПроцедуры

&НаКлиенте
Процедура ИспользованиеПериодичностиИнвентаризацииЯчеекПриИзменении(Элемент)
	ИспользованиеПериодичностиИнвентаризацииЯчеекПриИзмененииНаСервере();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// Обработчик команды, создаваемой механизмом запрета редактирования ключевых реквизитов.
//
&НаКлиенте
Процедура Подключаемый_РазрешитьРедактированиеРеквизитовОбъекта(Команда)

	Если Не Объект.Ссылка.Пустая() Тогда
		ОткрытьФорму("Справочник.ОбластиХранения.Форма.РазблокированиеРеквизитов",,,,,, 
			Новый ОписаниеОповещения("Подключаемый_РазрешитьРедактированиеРеквизитовОбъектаЗавершение", ЭтотОбъект), 
			РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_РазрешитьРедактированиеРеквизитовОбъектаЗавершение(Результат, ДополнительныеПараметры) Экспорт
    
    Если ТипЗнч(Результат) = Тип("Массив") И Результат.Количество() > 0 Тогда
        
        ЗапретРедактированияРеквизитовОбъектовКлиент.УстановитьДоступностьЭлементовФормы(ЭтаФорма, Результат);
        
    КонецЕсли;

КонецПроцедуры

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры
// Конец ИнтеграцияС1СДокументооборотом

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()
	
	УстановитьПараметрыФункциональныхОпцийФормы(Новый Структура("Склад", Объект.Владелец));
	
	ИспользоватьОбособленноеОбеспечениеЗаказов = ПолучитьФункциональнуюОпциюФормы("ИспользоватьОбособленноеОбеспечениеЗаказов");
	
	Если ПолучитьФункциональнуюОпциюФормы("ИспользоватьОбособленноеОбеспечениеЗаказов") 
		И Объект.ОбластьОбособленногоХранения Тогда
		ТипХранения = "Обособленный";
		Элементы.СтраницыСтратегии.ТекущаяСтраница = Элементы.СтратегииНедоступны;
	Иначе
		ТипХранения = "Общий";
		Элементы.СтраницыСтратегии.ТекущаяСтраница = Элементы.СтратегииДоступны;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) И ТипХранения = "Общий" Тогда
		Объект.КонтролироватьОбособление = Истина;
	КонецЕсли;
	
	Элементы.ПояснениеОбособленногоХранения.Видимость = ИспользоватьОбособленноеОбеспечениеЗаказов;
	Элементы.ПояснениеОбособленногоХранения1.Видимость = ИспользоватьОбособленноеОбеспечениеЗаказов;
	
	ИспользованиеПериодичностиИнвентаризацииЯчеекПриИзмененииНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура НастроитьДоступностьПриоритетовРазмещения()
	
	Если Размещать = "СтрогаяМонотоварность" Тогда
		Элементы.ПриоритетыРазмещения.Доступность = Ложь;
	Иначе
		Элементы.ПриоритетыРазмещения.Доступность = Истина;	
	КонецЕсли;	
	
КонецПроцедуры

&НаСервере
Процедура ИспользованиеПериодичностиИнвентаризацииЯчеекПриИзмененииНаСервере()
	
	Если Объект.ИспользованиеПериодичностиИнвентаризацииЯчеек 
			= Перечисления.ВариантыИспользованияПериодическойИнвентаризацииЯчеек.ИспользоватьНастройкиОбластиХранения Тогда 
		Элементы.КоличествоДнейМеждуИнвентаризациямиСтраницы.ТекущаяСтраница = Элементы.ГруппаКоличествоДнейМеждуИнвентаризациямиДоступно;
	Иначе
		Объект.КоличествоДнейМеждуИнвентаризациями = 0;
		Элементы.КоличествоДнейМеждуИнвентаризациямиСтраницы.ТекущаяСтраница = Элементы.ГруппаКоличествоДнейМеждуИнвентаризациямиНедоступно;
	КонецЕсли;
	
КонецПроцедуры

#Область ПриИзмененииРеквизитов

&НаКлиенте
Процедура РазмещатьПриИзменении(Элемент)
	
	НастроитьДоступностьПриоритетовРазмещения();	
	
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#КонецОбласти
