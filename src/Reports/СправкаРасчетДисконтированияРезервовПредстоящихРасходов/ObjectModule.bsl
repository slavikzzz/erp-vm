
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	НастройкиОтчета = КомпоновщикНастроек.ПолучитьНастройки();
	
	ПараметрРегистратор = НастройкиОтчета.ПараметрыДанных.Элементы.Найти("Регистратор");
	
	Если ЗначениеЗаполнено(ПараметрРегистратор.Значение) Тогда
		ДатаДокумента = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ПараметрРегистратор.Значение, "Дата");
		КомпоновкаДанныхКлиентСервер.УстановитьПараметр(НастройкиОтчета, "Период", ДатаДокумента);
		
		Для Каждого ПолеГруппировки Из НастройкиОтчета.Выбор.Элементы Цикл
			Если ПолеГруппировки.Заголовок = НСтр("ru = 'Приведенная стоимость';
													|en = 'Present value'") Тогда
				ПолеГруппировки.Заголовок = СтрШаблон(НСтр("ru = 'Приведенная стоимость на %1';
															|en = 'Present value as of %1'"),
					Формат(ДатаДокумента, "ДФ=dd.MM.yyyy; ДЛФ=D;"));
			КонецЕсли;
			Если ПолеГруппировки.Заголовок = НСтр("ru = 'Сумма процентов';
													|en = 'Interest amount'") Тогда
				ПолеГруппировки.Заголовок = СтрШаблон(НСтр("ru = 'Сумма процентов на %1';
															|en = 'Interest amount as of %1'"),
					Формат(ДатаДокумента, "ДФ=dd.MM.yyyy; ДЛФ=D;"));
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, НастройкиОтчета, ДанныеРасшифровки);
	
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки,, ДанныеРасшифровки, Истина);

	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Настройки общей формы отчета подсистемы "Варианты отчетов".
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - Форма отчета.
//   КлючВарианта - Строка - Имя предопределенного варианта отчета или уникальный идентификатор пользовательского.
//   Настройки - Структура - см. возвращаемое значение ОтчетыКлиентСервер.ПолучитьНастройкиОтчетаПоУмолчанию().
//
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	Настройки.События.ПриСозданииНаСервере = Истина;
	Настройки.События.ПередЗагрузкойНастроекВКомпоновщик = Истина;
КонецПроцедуры

// Вызывается в обработчике одноименного события формы отчета после выполнения кода формы.
//
// Параметры:
//   ЭтаФорма - ФормаКлиентскогоПриложения - Форма отчета
//   Отказ - Булево - Передается из параметров обработчика "как есть".
//   СтандартнаяОбработка - Булево - Передается из параметров обработчика "как есть".
//
// См. также:
//   "ФормаКлиентскогоПриложения.ПриСозданииНаСервере" в синтакс-помощнике.
//
Процедура ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка) Экспорт
	
	Параметры = ЭтаФорма.Параметры;
	
	Если Параметры.Свойство("ПараметрКоманды") Тогда
		Если Не ЭтаФорма.ФормаПараметры.Отбор.Свойство("Регистратор") Тогда
			ЭтаФорма.ФормаПараметры.Отбор.Вставить("Регистратор", Параметры.ПараметрКоманды);
		КонецЕсли;
		ДатаДокумента = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Параметры.ПараметрКоманды, "Дата");
		ЭтаФорма.ФормаПараметры.Отбор.Вставить("Период", ДатаДокумента);
	КонецЕсли;
	
КонецПроцедуры

// Вызывается перед загрузкой новых настроек. Используется для изменения схемы компоновки.
//   Например, если схема отчета зависит от ключа варианта или параметров отчета.
//   Чтобы изменения схемы вступили в силу следует вызывать метод ОтчетыСервер.ПодключитьСхему().
//   В ДополнительныеСвойства параметра НовыеНастройкиКД и свойство Настройки компоновщика настроек
//   объекта включены свойства КлючВарианта, КлючПредопределенногоВарианта, КонтекстВарианта 
//   и ФормаПараметрыОтбор.
//
// Параметры:
//   Контекст - Произвольный - 
//       Параметры контекста, в котором используется отчет.
//       Используется для передачи в параметрах метода ОтчетыСервер.ПодключитьСхему().
//   КлючСхемы - Строка -
//       Идентификатор текущей схемы компоновщика настроек.
//       По умолчанию не заполнен (это означает что компоновщик инициализирован на основании основной схемы).
//       Используется для оптимизации, чтобы переинициализировать компоновщик как можно реже.
//       Может не использоваться если переинициализация выполняется безусловно.
//   КлючВарианта - Строка, Неопределено -
//       Имя предопределенного или уникальный идентификатор пользовательского варианта отчета.
//       Неопределено когда вызов для варианта расшифровки или без контекста.
//   НовыеНастройкиКД - НастройкиКомпоновкиДанных, Неопределено -
//       Настройки варианта отчета, которые будут загружены в компоновщик настроек после его инициализации.
//       Неопределено когда настройки варианта не надо загружать (уже загружены ранее).
//   НовыеПользовательскиеНастройкиКД - ПользовательскиеНастройкиКомпоновкиДанных, Неопределено -
//       Пользовательские настройки, которые будут загружены в компоновщик настроек после его инициализации.
//       Неопределено когда пользовательские настройки не надо загружать (уже загружены ранее).
//
// Примеры:
// 1. Компоновщик отчета инициализируется на основании схемы из общих макетов:
//	Если КлючСхемы <> "1" Тогда
//		КлючСхемы = "1";
//		СхемаКД = ПолучитьОбщийМакет("МояОбщаяСхемаКомпоновки");
//		ОтчетыСервер.ПодключитьСхему(ЭтотОбъект, Контекст, СхемаКД, КлючСхемы);
//	КонецЕсли;
//
// 2. Схема зависит от значения параметра, выведенного в пользовательские настройки отчета:
//	Если ТипЗнч(НовыеПользовательскиеНастройкиКД) = Тип("ПользовательскиеНастройкиКомпоновкиДанных") Тогда
//		ПолноеИмяОбъектаМетаданных = "";
//		Для Каждого ЭлементКД Из НовыеПользовательскиеНастройкиКД.Элементы Цикл
//			Если ТипЗнч(ЭлементКД) = Тип("ЗначениеПараметраНастроекКомпоновкиДанных") Тогда
//				ИмяПараметра = Строка(ЭлементКД.Параметр);
//				Если ИмяПараметра = "ОбъектМетаданных" Тогда
//					ПолноеИмяОбъектаМетаданных = ЭлементКД.Значение;
//				КонецЕсли;
//			КонецЕсли;
//		КонецЦикла;
//		Если КлючСхемы <> ПолноеИмяОбъектаМетаданных Тогда
//			КлючСхемы = ПолноеИмяОбъектаМетаданных;
//			СхемаКД = Новый СхемаКомпоновкиДанных;
//			// Наполнение схемы...
//			ОтчетыСервер.ПодключитьСхему(ЭтотОбъект, Контекст, СхемаКД, КлючСхемы);
//		КонецЕсли;
//	КонецЕсли;
//
Процедура ПередЗагрузкойНастроекВКомпоновщик(Контекст, КлючСхемы, КлючВарианта, НовыеНастройкиКД, НовыеПользовательскиеНастройкиКД) Экспорт
	
	НастройкиОтчета = КомпоновщикНастроек.ПолучитьНастройки();
	ПараметрПериод = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(НастройкиОтчета, "Период");
	ПараметрРегистратор = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(НастройкиОтчета, "Регистратор");
	
	Если ЗначениеЗаполнено(ПараметрРегистратор.Значение) Тогда
		КомпоновкаДанныхКлиентСервер.УстановитьПараметр(НовыеНастройкиКД, "Период",
			ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ПараметрРегистратор.Значение, "Дата"));
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура СформироватьОтчет(ТабличныйДокумент, ОбъектУчетаРезервов, Период, ЕстьДанныеДляОтображения) Экспорт
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.Очистить();
	
	СКДРасшифровки = ПолучитьМакет("МакетРасшифровки");
	
	КомпоновщикНастроекРасшифровки = Новый КомпоновщикНастроекКомпоновкиДанных();
	КомпоновщикНастроекРасшифровки.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(СКДРасшифровки));
	КомпоновщикНастроекРасшифровки.ЗагрузитьНастройки(СКДРасшифровки.НастройкиПоУмолчанию);
	НастройкиОтчета = КомпоновщикНастроекРасшифровки.ПолучитьНастройки();
	
	Параметр = НастройкиОтчета.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ОбъектУчетаРезервов"));
	Если Параметр <> Неопределено Тогда
		Параметр.Значение = ОбъектУчетаРезервов;
		Параметр.Использование = Истина;
	КонецЕсли;
	
	Параметр = НастройкиОтчета.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Период"));
	Если Параметр <> Неопределено Тогда
		Параметр.Значение = Период;
		Параметр.Использование = Истина;
	КонецЕсли;
	
	РеквизитыОУР = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ОбъектУчетаРезервов, "Организация, ВидРезервов");
	Параметр = НастройкиОтчета.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Организация"));
	Если Параметр <> Неопределено Тогда
		Параметр.Значение = РеквизитыОУР.Организация;
		Параметр.Использование = Истина;
	КонецЕсли;
	
	Параметр = НастройкиОтчета.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ВидРезервов"));
	Если Параметр <> Неопределено Тогда
		Параметр.Значение = РеквизитыОУР.ВидРезервов;
		Параметр.Использование = Истина;
	КонецЕсли;
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СКДРасшифровки, НастройкиОтчета);
	
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки,,, Истина);

	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ТабличныйДокумент);
	ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
	ЕстьДанныеДляОтображения = ТабличныйДокумент.ВысотаТаблицы <> 0;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
