#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриКопировании(ОбъектКопирования)
	
	// Очистим табличные части документа.
	ДанныеКонтрагента.Очистить();
	ГруппировкиРасчеты.Очистить();
	ДетальныеЗаписиРасчеты.Очистить();
	ГруппировкиФинансовыеИнструменты.Очистить();
	ДетальныеЗаписиФинансовыеИнструменты.Очистить();
	
	Статус = Перечисления.СтатусыСверокВзаиморасчетов.Создана;
	Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	Менеджер = Пользователи.ТекущийПользователь();
	Автор = Пользователи.ТекущийПользователь();
	
	СтруктураДанных = Новый Структура;
	СтруктураДанных.Вставить(
		"РеквизитыОтветственныеЛица",
		Документы.СверкаВзаиморасчетов.СтруктураРеквизитыОтветственныеЛица());
	СтруктураДанных.Вставить(
		"РеквизитыОтветственныеЛицаОрганизацииКонтрагента",
		Документы.СверкаВзаиморасчетов.СтруктураРеквизитыОтветственныеЛицаОрганизацииКонтрагента());
	
	ДополнительныеСвойства.Вставить("ОтветственныеЛица", СтруктураДанных);
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ЕстьРасхождения = Ложь;
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		ЗаполнитьДокументПоДаннымПомощника(ДанныеЗаполнения);
	КонецЕсли;
	ИнициализироватьДокумент(ДанныеЗаполнения);
	
	СтруктураДанных = Новый Структура;
	СтруктураДанных.Вставить(
		"РеквизитыОтветственныеЛица",
		Документы.СверкаВзаиморасчетов.СтруктураРеквизитыОтветственныеЛица());
	СтруктураДанных.Вставить(
		"РеквизитыОтветственныеЛицаОрганизацииКонтрагента",
		Документы.СверкаВзаиморасчетов.СтруктураРеквизитыОтветственныеЛицаОрганизацииКонтрагента());
	
	ДополнительныеСвойства.Вставить("ОтветственныеЛица", СтруктураДанных);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ПроверитьКорректностьПериода(Отказ);
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	Если ЗначениеЗаполнено(ТипРасчетов) Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ГруппировкиРасчеты.ТипРасчетов");
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Партнер) Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ГруппировкиРасчеты.Партнер");
	КонецЕсли;
	//++ Локализация
	Если ДанныеКонтрагента.Количество() > 0 Тогда
		Если НЕ РасшифровкаПоЗаказам Тогда
			МассивНепроверяемыхРеквизитов.Добавить("ДанныеКонтрагента.РасчетныйДокумент");
			МассивНепроверяемыхРеквизитов.Добавить("ДанныеКонтрагента.ОписаниеДокумента");
		КонецЕсли;
		
		Если НЕ РасшифровкаПоПартнерам Тогда
			МассивНепроверяемыхРеквизитов.Добавить("ДанныеКонтрагента.Партнер");
		КонецЕсли;
		
		Если НЕ РасшифровкаПоДоговорам Тогда
			МассивНепроверяемыхРеквизитов.Добавить("ДанныеКонтрагента.Договор");
		КонецЕсли;
	КонецЕсли;
	//-- Локализация
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(
		ПроверяемыеРеквизиты,
		МассивНепроверяемыхРеквизитов);
	
	СтруктураДанных = Новый Структура;
	СтруктураДанных.Вставить(
		"РеквизитыОтветственныеЛица",
		Документы.СверкаВзаиморасчетов.СтруктураРеквизитыОтветственныеЛица());
	СтруктураДанных.Вставить(
		"РеквизитыОтветственныеЛицаОрганизацииКонтрагента",
		Документы.СверкаВзаиморасчетов.СтруктураРеквизитыОтветственныеЛицаОрганизацииКонтрагента());
	
	ДополнительныеСвойства.Вставить("ОтветственныеЛица", СтруктураДанных);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли; 

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	УстановитьСвойстваИзмененияРеквизитов(ЭтотОбъект, ДополнительныеСвойства);
	
	УдалитьЗависшиеПодчиенныеСтроки("ГруппировкиРасчеты", "ДетальныеЗаписиРасчеты", "ОбъектРасчетов");
	УдалитьЗависшиеПодчиенныеСтроки("ГруппировкиФинансовыеИнструменты", "ДетальныеЗаписиФинансовыеИнструменты", "Договор");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ИнициализацияИЗаполнение

Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено) Экспорт
	
	Автор = Пользователи.ТекущийПользователь();
	ОтветственныеЛицаСервер.ЗаполнитьМенеджера(ЭтотОбъект, Ложь);
	Если НЕ ЗначениеЗаполнено(Менеджер) Тогда
		Менеджер = Пользователи.ТекущийПользователь();
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Статус) Тогда
		Статус = Перечисления.СтатусыСверокВзаиморасчетов.Создана;
	КонецЕсли;
	
	Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	
	Если НЕ ЗначениеЗаполнено(КонецПериода) Тогда
		КонецПериода = ТекущаяДатаСеанса();
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Контрагент) И НЕ ЗначениеЗаполнено(КонтактноеЛицо) Тогда
		КонтактноеЛицо = ПартнерыИКонтрагенты.ПолучитьКонтактноеЛицоПартнераКонтрагентаПоУмолчанию(Контрагент);
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьДокументПоДаннымПомощника(ДанныеЗаполнения)
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
	
	ДанныеЗаполнения.Вставить("Дата", Дата);
	
	ДанныеДокумента = Документы.СверкаВзаиморасчетов.РеквизитыПоследнегоДокумента(Контрагент);
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеДокумента, "ФИОРуководителяКонтрагента, ДолжностьРуководителяКонтрагента");
	
	Если ДанныеЗаполнения.Свойство("НастройкиОтбора") Тогда
		УстановитьОтборыНаРавенство(ДанныеЗаполнения);
		НастройкиОтбора = Новый ХранилищеЗначения(ДанныеЗаполнения.НастройкиОтбора);
	КонецЕсли;
	
	Документы.СверкаВзаиморасчетов.ЗаполнитьДанныеПоРасчетам(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

// Устанавливает статус для объекта документа
//
// Параметры:
//	НовыйСтатус - Строка - Имя статуса, который будет установлен у заказов.
//	ДополнительныеПараметры - Структура - Структура дополнительных параметров установки статуса.
//
// Возвращаемое значение:
//	Булево - Истина, в случае успешной установки нового статуса.
//
Функция УстановитьСтатус(НовыйСтатус, ДополнительныеПараметры) Экспорт
	
	Статус = Перечисления.СтатусыСверокВзаиморасчетов[НовыйСтатус];
	
	Возврат ПроверитьЗаполнение();
	
КонецФункции

Процедура ПроверитьКорректностьПериода(Отказ)
	
	Если ЗначениеЗаполнено(НачалоПериода)
	 И ЗначениеЗаполнено(КонецПериода)
	 И НачалоПериода > КонецПериода Тогда
	 
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Дата начала периода не должна быть больше окончания периода %1';
				|en = 'Period start date cannot exceed period end date %1'"),
			Формат(КонецПериода, "ДЛФ=DD"));
		ОбщегоНазначения.СообщитьПользователю(
			ТекстОшибки,
			ЭтотОбъект,
			"НачалоПериода",
			, // ПутьКДанным
			Отказ);
	 
	КонецЕсли;
	
КонецПроцедуры

Процедура УстановитьОтборыНаРавенство(ДанныеЗаполнения)
	
	ПоляОтбора = Новый Массив();
	ПоляОтбора.Добавить("ТипРасчетов");
	ПоляОтбора.Добавить("Партнер");
	ПоляОтбора.Добавить("Договор");
	Если ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций") Тогда
		ПоляОтбора.Добавить("Организация");
	КонецЕсли;
	ПоляОтбора.Добавить("Контрагент");
	
	Отбор = ДанныеЗаполнения.НастройкиОтбора.Отбор;
	Для Каждого ПолеОтбора Из ПоляОтбора Цикл
		РазбиватьДокументы = Истина;
		Если ПолеОтбора = "ТипРасчетов" Тогда
			РазбиватьДокументы = ДанныеЗаполнения.РазбиватьПоТипамРасчетов;
			
		ИначеЕсли ПолеОтбора = "Партнер" Тогда
			РазбиватьДокументы = ДанныеЗаполнения.РазбиватьПоПартнерам;
			
		ИначеЕсли ПолеОтбора = "Договор" Тогда
			РазбиватьДокументы = ДанныеЗаполнения.РазбиватьПоДоговорам;
			
		КонецЕсли;
		Если РазбиватьДокументы Тогда
			ФинансоваяОтчетностьСервер.УстановитьОтбор(Отбор, ПолеОтбора, ДанныеЗаполнения[ПолеОтбора], ВидСравненияКомпоновкиДанных.Равно, РазбиватьДокументы);
		КонецЕсли;
	КонецЦикла;
	
	ОтборДоговорыБезОборотов = ФинансоваяОтчетностьСервер.НайтиЭлементОтбора(Отбор, "ДоговорыБезОборотов");
	ОтборДоговорыБезОборотов.Использование = ДанныеЗаполнения.ДоговорыБезОборотов;
	
КонецПроцедуры

Процедура УстановитьСвойстваИзмененияРеквизитов(Объект, ДополнительныеСвойства)
		
	ИзменилсяТолькоСтатусСвереноНаСверке = Ложь;
	
	Если Объект.Проведен Тогда
		
		НепроверяемыеРеквизиты = Новый Структура;
		НепроверяемыеРеквизиты.Вставить("Комментарий");
		НепроверяемыеРеквизиты.Вставить("НастройкиОтбора");
		
		ИзмененияДокумента = ОбщегоНазначенияУТ.ИзмененияДокумента(Объект, НепроверяемыеРеквизиты);
		
		ИзменилисьДругиеРеквизиты = Ложь;
		ИзменилсяСтатус = Ложь;
		
		Если ИзмененияДокумента.Свойство("ТабличныеЧасти") Тогда
			ИзменилисьДругиеРеквизиты = Истина;
		КонецЕсли;                                  
		
		Если ИзмененияДокумента.Свойство("Реквизиты") Тогда
			Если ИзмененияДокумента.Реквизиты.Найти("Статус", "Имя") <> Неопределено Тогда
				ИзменилсяСтатус = Истина;
			КонецЕсли;
			Для каждого Реквизит Из ИзмененияДокумента.Реквизиты Цикл
				Если Реквизит.Имя <> "Статус" Тогда
					ИзменилисьДругиеРеквизиты = Истина;
					Прервать;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;                                    
		
		ИзменилсяТолькоСтатусСвереноНаСверке = ИзменилсяСтатус И Не ИзменилисьДругиеРеквизиты;
		
	КонецЕсли;
	
	ДополнительныеСвойства.Вставить("ИзменилсяТолькоСтатусСвереноНаСверке", ИзменилсяТолькоСтатусСвереноНаСверке);
	
КонецПроцедуры

Процедура УдалитьЗависшиеПодчиенныеСтроки(тчГруппировки, тчДетальныеЗаписи, ПолеСвязи)
	
	Документы.СверкаВзаиморасчетов.УдалитьЗависшиеПодчиенныеСтроки(ЭтотОбъект, тчГруппировки, тчДетальныеЗаписи, ПолеСвязи);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
