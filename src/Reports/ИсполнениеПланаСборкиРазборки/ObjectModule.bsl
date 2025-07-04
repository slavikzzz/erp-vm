#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрСценарий = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "Сценарий");
	
	Если НЕ ЗначениеЗаполнено(ПараметрСценарий.Значение) Тогда
		ВызватьИсключение НСтр("ru = 'Не заполнено значение параметра ""Сценарий"".';
								|en = 'Parameter ""Scenario"" is not filled in.'");
	КонецЕсли; 
	
	СтруктураЗначений = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ПараметрСценарий.Значение, "Периодичность, ПланированиеПоНазначениям");
	Периодичность = СтруктураЗначений.Периодичность;
	ИспользоватьНазначения = СтруктураЗначений.ПланированиеПоНазначениям;
	КомпоновкаДанныхКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "ИспользоватьНазначения", ИспользоватьНазначения);
	
	КомпоновкаДанныхКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "Периодичность", Периодичность);
	
	Период = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "ПериодВыпуска").Значение; // СтандартныйПериод -
	
	ДатаОкончания = ПланированиеКлиентСервер.РассчитатьДатуОкончанияПериода(Период.ДатаНачала, Периодичность);
	
	Если ДатаОкончания < Период.ДатаОкончания Тогда
		ИспользоватьИтоги = Истина;
	Иначе
		ИспользоватьИтоги = Ложь;
	КонецЕсли; 
	
	Параметр = Новый ПараметрКомпоновкиДанных("ГоризонтальноеРасположениеОбщихИтогов");
	ПараметрГоризонтальноеРасположениеОбщихИтогов = КомпоновщикНастроек.Настройки.ПараметрыВывода.Элементы.Найти(Параметр);
	
	Если ИспользоватьИтоги Тогда
		ПараметрГоризонтальноеРасположениеОбщихИтогов.Значение = РасположениеИтоговКомпоновкиДанных.Начало;
	Иначе
		ПараметрГоризонтальноеРасположениеОбщихИтогов.Значение = РасположениеИтоговКомпоновкиДанных.Нет;
	КонецЕсли;

	СегментыСервер.ВключитьОтборПоСегментуНоменклатурыВСКД(КомпоновщикНастроек);

	Планирование.ИсполнениеПлановПриКомпоновкеРезультата(СхемаКомпоновкиДанных, КомпоновщикНастроек, 
		ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка);

	НастройкиОтчета = КомпоновщикНастроек.ПолучитьНастройки();

	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, НастройкиОтчета, ДанныеРасшифровки);

	КоллекцияЭлементовСтруктуры = НастройкиОтчета.Структура;
	
	Если ТипЗнч(КоллекцияЭлементовСтруктуры[0]) = Тип("ТаблицаКомпоновкиДанных") Тогда
		
		Если КоллекцияЭлементовСтруктуры[0].Колонки[0].Имя = "Расшифровка" Тогда
			ИмяЭлементаСтруктуры = КоллекцияЭлементовСтруктуры[0].Колонки[0].Имя;
			ПолеГруппировкиЭлементаСтруктуры = КоллекцияЭлементовСтруктуры[0].Колонки[0].ПоляГруппировки.Элементы[0].Поле;
		Иначе
			ИмяЭлементаСтруктуры = КоллекцияЭлементовСтруктуры[0].Строки[0].Имя;
			ПолеГруппировкиЭлементаСтруктуры = КоллекцияЭлементовСтруктуры[0].Строки[0].ПоляГруппировки.Элементы[0].Поле;
		КонецЕсли;
		
	Иначе
		
		ИмяЭлементаСтруктуры = КоллекцияЭлементовСтруктуры[0].Имя;
		ПолеГруппировкиЭлементаСтруктуры = КоллекцияЭлементовСтруктуры[0].ПоляГруппировки.Элементы[0].Поле;
		
	КонецЕсли;
	
	// Переопределение структуры отчета при расшифровке по полю Регистратор
	Если ИмяЭлементаСтруктуры = "Расшифровка" Тогда
		
		ПолеРегистратор = Новый ПолеКомпоновкиДанных("Регистратор");
		
		Если ПолеГруппировкиЭлементаСтруктуры = ПолеРегистратор Тогда
			
			Планирование.ПереопределитьНастройкиРасшифровкиОтчета(СхемаКомпоновкиДанных, КомпоновщикНастроек, ДанныеРасшифровки);
			
			НастройкиОтчета = ДанныеРасшифровки.Настройки;
			МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, НастройкиОтчета, ДанныеРасшифровки);
			
		КонецЕсли;
	КонецЕсли;

	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, , ДанныеРасшифровки, Истина);
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Планирование.ИсполнениеПлановОбработкаПроверкиЗаполнения(КомпоновщикНастроек, Отказ);
	
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
	Настройки.События.ПриЗагрузкеВариантаНаСервере = Истина;
	
КонецПроцедуры

// Вызывается в обработчике одноименного события формы отчета после выполнения кода формы.
//
// Параметры:
//   ЭтаФорма - ФормаКлиентскогоПриложения - Форма отчета.
//   Отказ - Булево - Передается из параметров обработчика "как есть".
//   СтандартнаяОбработка - Булево - Передается из параметров обработчика "как есть".
//
// См. также:
//   "ФормаКлиентскогоПриложения.ПриСозданииНаСервере" в синтакс-помощнике.
//
Процедура ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка) Экспорт
	
	Параметры = ЭтаФорма.Параметры;
	
	// Дополнительные команды
	НастройкиОтчета = ЭтаФорма.НастройкиОтчета;
	
	Если Параметры.Свойство("Расшифровка")
	   И Параметры.Расшифровка <> Неопределено Тогда
		
		// Исправление варианта отчета при расшифровке
		Если ЭтоАдресВременногоХранилища(Параметры.Расшифровка.Данные) Тогда
			
			ДанныеРасшифровки = ПолучитьИзВременногоХранилища(Параметры.Расшифровка.Данные);
			
			Если Параметры.Свойство("КлючВарианта") И Параметры.КлючВарианта = Неопределено Тогда
				Параметры.КлючВарианта = ДанныеРасшифровки.Настройки.ДополнительныеСвойства.КлючВарианта;
			КонецЕсли;
			
			ЭтаФорма.КлючТекущегоВарианта = ДанныеРасшифровки.Настройки.ДополнительныеСвойства.КлючВарианта;
			
		КонецЕсли;
		
		НастройкиОтчета.ВариантСсылка = ВариантыОтчетов.ВариантОтчета(НастройкиОтчета.ОтчетСсылка, ЭтаФорма.КлючТекущегоВарианта);
		
	КонецЕсли;
	
КонецПроцедуры

// Вызывается в одноименном обработчике формы отчета после выполнения кода формы.
//
Процедура ПриЗагрузкеВариантаНаСервере(ЭтаФорма, НовыеНастройкиКД) Экспорт
	
	Параметры = ЭтаФорма["Параметры"];
	
	Если Параметры.Свойство("Расшифровка")
	   И Параметры.Расшифровка <> Неопределено Тогда
		
		Если ЭтоАдресВременногоХранилища(Параметры.Расшифровка.Данные) Тогда
			
			ДопустимыеОтклоненияКоличества = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "ДопустимыеОтклоненияПроцент");
			Если ДопустимыеОтклоненияКоличества <> Неопределено Тогда
				ДопустимыеОтклоненияКоличества.Использование = Ложь;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли