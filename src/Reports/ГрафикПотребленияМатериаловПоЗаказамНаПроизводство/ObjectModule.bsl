#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	ВыводитьЗаказ = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(
		КомпоновщикНастроек.ПользовательскиеНастройки,
		"ВыводитьЗаказ");
	
	Если НЕ ТипЗнч(ВыводитьЗаказ) = Тип("ЗначениеПараметраНастроекКомпоновкиДанных") Тогда
		Возврат;
	КонецЕсли;
	
	ВыводитьЗаказ.Значение = ?(ВыводитьЗаказ.Значение = Неопределено, Ложь, ВыводитьЗаказ.Значение);
	
	Таблица            = НайтиПоИмени(КомпоновщикНастроек.Настройки.Структура, "ТаблицаПотреблениеМатериалов");
	Строка             = ?(Таблица = Неопределено, Неопределено, НайтиСтрокуРекурсивно(Таблица.Строки, "ОсновнаяГруппировкаСтрок"));
	Колонка            = ?(Строка = Неопределено, Неопределено, НайтиПоИмени(Строка.Выбор.Элементы, "ЗаказНаПроизводство"));
	КолонкаГруппировка = ?(Строка = Неопределено, Неопределено, НайтиПоИмени(Строка.ПоляГруппировки.Элементы, "ЗаказНаПроизводство"));
	
	Если КолонкаГруппировка = Неопределено ИЛИ Колонка = Неопределено Тогда
		Возврат
	КонецЕсли;
	
	Колонка.Использование            = ВыводитьЗаказ.Значение;
	КолонкаГруппировка.Использование = ВыводитьЗаказ.Значение;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Настройки общей формы отчета подсистемы "Варианты отчетов".
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - Форма отчета.
//   КлючВарианта - Строка - Имя предопределенного варианта отчета или уникальный идентификатор пользовательского.
//   Настройки - См. ОтчетыКлиентСервер.ПолучитьНастройкиОтчетаПоУмолчанию
//
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	Настройки.События.ПриСозданииНаСервере = Истина;
	Настройки.События.ПриЗагрузкеПользовательскихНастроекНаСервере = Истина;
КонецПроцедуры

// Вызывается в обработчике одноименного события формы отчета после выполнения кода формы.
//
// Параметры:
//   ЭтаФорма - ФормаКлиентскогоПриложения - Форма отчета.
//   Отказ - Булево - Передается из параметров обработчика "как есть".
//   СтандартнаяОбработка - Передается из параметров обработчика "как есть".
//
// См. также:
//   "ФормаКлиентскогоПриложения.ПриСозданииНаСервере" в синтакс-помощнике.
//
Процедура ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка) Экспорт
	
	// Дополнительные команды
	КомпоновщикНастроекФормы = ЭтаФорма.Отчет.КомпоновщикНастроек;
	Параметры = ЭтаФорма.Параметры;
	
	Если Параметры.Свойство("ПараметрКоманды")
		И ТипЗнч(Параметры.ПараметрКоманды) = Тип("ДокументСсылка.ЗаказНаПроизводство2_2") Тогда
		
		Если НЕ ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Параметры.ПараметрКоманды, "ДинамическаяСтруктура") Тогда
			
			ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'Данный отчет применим только к заказам с включенной динамической структурой.';
														|en = 'This report is applicable only to orders with enabled dynamic structure.'"));
			Отказ = Истина;
			Возврат;
			
		КонецЕсли;
		
		ЭтаФорма.ФормаПараметры.Отбор.Вставить("ЗаказНаПроизводство", Параметры.ПараметрКоманды);
		ЭтаФорма.ФормаПараметры.Отбор.Вставить("НаправлениеДеятельности",
				ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Параметры.ПараметрКоманды, "НаправлениеДеятельности"));
		
		ЭтаФорма.ФормаПараметры.Вставить("КонтекстноеОткрытие", Истина);
	КонецЕсли;
		
КонецПроцедуры

// Параметры:
//  ЭтаФорма - ФормаКлиентскогоПриложения
//  НовыеНастройкиКД - ПользовательскиеНастройкиКомпоновкиДанных
Процедура ПриЗагрузкеПользовательскихНастроекНаСервере(ЭтаФорма, НовыеНастройкиКД) Экспорт
	
	Параметры = ЭтаФорма.ФормаПараметры;
	Если (Параметры.Свойство("КонтекстноеОткрытие") И Параметры.КонтекстноеОткрытие)
		ИЛИ ЭтаФорма.РежимРасшифровки Тогда
		КомпоновкаДанныхСервер.УдалитьПараметрИзПользовательскихНастроекОтчета(КомпоновщикНастроек, "ВыводитьЗаказ");
	КонецЕсли;
	
	Если ЭтаФорма.Параметры.Свойство("ПараметрКоманды")
		И ТипЗнч(ЭтаФорма.Параметры.ПараметрКоманды) = Тип("ДокументСсылка.ЗаказНаПроизводство2_2") Тогда
		ГраницыЗаказа = СтруктураЗаказаСлужебный.ГраницыПериодаНормативногоГрафика(ЭтаФорма.Параметры.ПараметрКоманды);
		
		ЗначениеПериода = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек.ПользовательскиеНастройки,
																		"Период").Значение;
		ПериодЗаполнен = ЗначениеЗаполнено(ЗначениеПериода);
		
		Период = ?(ПериодЗаполнен, ЗначениеПериода, Новый СтандартныйПериод());//СтандартныйПериод
		
		Если ЗначениеЗаполнено(ГраницыЗаказа.Окончание) И ЗначениеЗаполнено(ГраницыЗаказа.Начало) Тогда
			Период.ДатаНачала = НачалоМесяца(ГраницыЗаказа.Начало);
			Период.ДатаОкончания = КонецМесяца(ГраницыЗаказа.Окончание + 1);
		ИначеЕсли Не ПериодЗаполнен Тогда 
			ТекущаяДата = ТекущаяДатаСеанса();
			Период.ДатаНачала = НачалоГода(ТекущаяДата);
			Период.ДатаОкончания = КонецГода(ТекущаяДата);
		КонецЕсли;
		
		КомпоновкаДанныхКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "Период", Период);
	КонецЕсли;
	
	НовыеНастройкиКД = КомпоновщикНастроек.ПолучитьНастройки();

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция НайтиПоИмени(Структура, Имя)
	
	Для Каждого Элемент Из Структура Цикл
		Если ТипЗнч(Элемент) = Тип("ВыбранноеПолеКомпоновкиДанных")
			ИЛИ ТипЗнч(Элемент) = Тип("ПолеГруппировкиКомпоновкиДанных") Тогда
			
			Если Элемент.Поле = Новый ПолеКомпоновкиДанных(Имя) Тогда
				Возврат Элемент;
			КонецЕсли;
			
		ИначеЕсли ТипЗнч(Элемент) <> Тип("ГруппаВыбранныхПолейКомпоновкиДанных") Тогда
			
			Если Элемент.Имя = Имя Тогда
				Возврат Элемент;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецФункции

Функция НайтиСтрокуРекурсивно(Структура, Имя)
	
	Для Каждого Элемент Из Структура Цикл
		
		Если ТипЗнч(Элемент) = Тип("ГруппировкаТаблицыКомпоновкиДанных") Тогда
			
			Если Элемент.Имя = Имя Тогда
				Возврат Элемент;
			КонецЕсли;
			
			Если Элемент.Структура.Количество() > 0 Тогда
				
				Строка = НайтиСтрокуРекурсивно(Элемент.Структура, Имя);
				
				Если Строка <> Неопределено Тогда
					Возврат Строка;
				КонецЕсли; 
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Неопределено;
	
КонецФункции

#КонецОбласти

#КонецЕсли