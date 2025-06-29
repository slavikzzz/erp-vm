#Область ОписаниеПеременных
&НаКлиенте
Перем СтрокиЭлементаФормыКСтрокамДереваЗначений; 
#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ИспользоватьРеглУчет              = ПолучитьФункциональнуюОпцию("ИспользоватьРеглУчет");
	ИспользоватьНесколькоОрганизаций  = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций");
	ИспользоватьНесколькоВалют        = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоВалют");
	СтарыйДокументВводаОстатков       = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(Метаданные.Документы.ВводОстатков);
	ВестиУУННаПланеСчетовХозрасчетный = Ложь;
	ВводОстатковВзаиморасчетов        = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(Метаданные.Документы.ВводОстатковВзаиморасчетов);

	//++ Локализация

	//++ НЕ УТ
	ВестиУУННаПланеСчетовХозрасчетный = ПолучитьФункциональнуюОпцию("ВестиУУНаПланеСчетовХозрасчетный");
	СтарыйДокументВводаОстатковВзаиморасчетовПоАренде
									  = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(Метаданные.Документы.ВводОстатковВнеоборотныхАктивов2_4);
	//-- НЕ УТ

	//-- Локализация
	
	СписокВидовОтбораПоРазделамУчета = Обработки.ЖурналДокументовВводаНачальныхОстатков.ИнициализироватьСписокВидовОтбораПоРазделамУчета();
	
	Элементы.ОтборПоВидуУчета.СписокВыбора.Очистить();
	Для Каждого ЭлементОтбора Из СписокВидовОтбораПоРазделамУчета Цикл
		Элементы.ОтборПоВидуУчета.СписокВыбора.Добавить(ЭлементОтбора.Значение, ЭлементОтбора.Представление);
	КонецЦикла;
	
	ОтборПоВидуУчета = "БезОтбора";
	
	ТаблицаРазделовИХозяйственныхОпераций = Обработки.ЖурналДокументовВводаНачальныхОстатков.ИнициализироватьДеревоХозяйственныхОперацийВводаНачальныхОстатков();
	ЗаполнитьДеревоРазделовДокументовВводаНачальныхОстатков(ТаблицаРазделовИХозяйственныхОпераций);
	
	СформироватьТекстЗапросаСписка();
	
	ОписаниеХозОпераций = ВводОстатковСервер.ОписаниеРазделовВводаОстатков();
	ОписаниеХозОпераций.Свернуть("ДокументВводаОстатков");
	ИспользуемыеДокументы = ОписаниеХозОпераций.ВыгрузитьКолонку("ДокументВводаОстатков");

	ИспользуемыеТипыДокументов = Новый Массив;
	Для Каждого ИспользуемыйДокумент Из  ИспользуемыеДокументы Цикл
	
		Если Не ЗначениеЗаполнено(ИспользуемыйДокумент) Тогда 
			Продолжить;
		КонецЕсли;
		
		ИспользуемыеТипыДокументов.Добавить(ОбщегоНазначения.ОбъектМетаданныхПоИдентификатору(ИспользуемыйДокумент));
		
	КонецЦикла;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.Источники = ИспользуемыеТипыДокументов;
	ПараметрыРазмещения.КоманднаяПанель = Элементы.СписокКоманднаяПанель;
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	УстановитьВидимость();
	УстановитьУсловноеОформление();
	
	ВыполнятьЗамерыПроизводительности = ОценкаПроизводительностиВызовСервераПовтИсп.ВыполнятьЗамерыПроизводительности();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	#Если МобильныйКлиент Тогда
	Список.Параметры.УстановитьЗначениеПараметра("ОтборПоТипамОпераций", ОтборПоТипамОпераций);
	Список.Параметры.УстановитьЗначениеПараметра("ОтборПоТипамДокументов", ОтборПоТипамДокументов);
	#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "Запись_ВводОстатков" Тогда

		АктивнаяСтрокаСтароеСостояние = Элементы.ДеревоОпераций.ТекущиеДанные;
		ОбновитьДанныеСписка(Параметр);
		ВосстановитьСостояниеДерева(ДеревоОпераций);
		Элементы.ДеревоОпераций.ТекущаяСтрока = ПоискАктивнойСтрокиДерева(ДеревоОпераций, АктивнаяСтрокаСтароеСостояние.РазделУчета, АктивнаяСтрокаСтароеСостояние.ХозяйственнаяОперацияДокумента);
		
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВосстановитьСостояниеДерева(ДеревоОпераций)
	
	ЭлементыДереваОпераций = ДеревоОпераций.ПолучитьЭлементы();

	Для Каждого ЭлементДерева Из ЭлементыДереваОпераций Цикл
		
		Если Не РазделыУчетаРазвернутыхУзлов.НайтиПоЗначению(ЭлементДерева.РазделУчета) = Неопределено Тогда 
			Элементы.ДеревоОпераций.Развернуть(ЭлементДерева.ПолучитьИдентификатор());
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Функция ПоискАктивнойСтрокиДерева(ДеревоОпераций, РазделУчета, ХозяйственнаяОперацияДокумента)
	
	АктивнаяСтрока         = Неопределено;
	ЭлементыДереваОпераций = ДеревоОпераций.ПолучитьЭлементы();
	
	Для Каждого ЭлементДерева Из ЭлементыДереваОпераций Цикл
		Если ЭлементДерева.РазделУчета = РазделУчета Тогда
			
			Если ЗначениеЗаполнено(ХозяйственнаяОперацияДокумента) Тогда
				
				Если ЗначениеЗаполнено(ЭлементДерева.ХозяйственнаяОперацияДокумента) Тогда
					
					Если ЭлементДерева.ХозяйственнаяОперацияДокумента = ХозяйственнаяОперацияДокумента Тогда
						АктивнаяСтрока = ЭлементДерева.ПолучитьИдентификатор();
					КонецЕсли
					
				Иначе
					//Выполняем поиск среди элементов узла
					АктивнаяСтрока = ПоискАктивнойСтрокиДерева(ЭлементДерева, РазделУчета, ХозяйственнаяОперацияДокумента);
					
				КонецЕсли;
				
			Иначе
				АктивнаяСтрока = ЭлементДерева.ПолучитьИдентификатор();
			КонецЕсли;
			
		КонецЕсли;
	КонецЦикла;
	
	Возврат АктивнаяСтрока;
КонецФункции

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтборОрганизацияПриИзменении(Элемент)
	
	АктивнаяСтрокаСтароеСостояние = Элементы.ДеревоОпераций.ТекущиеДанные;
	
	ОбновитьФормуПоДаннымОтборов();
	
	ВосстановитьСостояниеДерева(ДеревоОпераций);
	Элементы.ДеревоОпераций.ТекущаяСтрока = ПоискАктивнойСтрокиДерева(ДеревоОпераций, АктивнаяСтрокаСтароеСостояние.РазделУчета, АктивнаяСтрокаСтароеСостояние.ХозяйственнаяОперацияДокумента);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборПоВидуУчетаПриИзменении(Элемент)
	
	АктивнаяСтрокаСтароеСостояние = Элементы.ДеревоОпераций.ТекущиеДанные;
	
	ОбновитьФормуПоДаннымОтборов();
	
	ВосстановитьСостояниеДерева(ДеревоОпераций);
	Элементы.ДеревоОпераций.ТекущаяСтрока = ПоискАктивнойСтрокиДерева(ДеревоОпераций, АктивнаяСтрокаСтароеСостояние.РазделУчета, АктивнаяСтрокаСтароеСостояние.ХозяйственнаяОперацияДокумента);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДеревоОпераций

&НаКлиенте
Процедура ДеревоОперацийПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоОперацийПриАктивизацииСтроки(Элемент)
	
	ТекущаяСтрокаДерева   = Элементы.ДеревоОпераций.ТекущиеДанные;
	ХозяйственнаяОперация = ТекущаяСтрокаДерева.ХозяйственнаяОперацияДокумента;
	ТипДокумента          = ТекущаяСтрокаДерева.ДокументВводаОстатков;
	
	ОтборПоТипамОпераций.Очистить();
	
	Если Не ЗначениеЗаполнено(ХозяйственнаяОперация) Тогда
		ОтборПоТипамОпераций.ЗагрузитьЗначения(ДанныеПоРазделуУчета(ТекущаяСтрокаДерева, "ХозяйственнаяОперацияДокумента"));
	Иначе
		ОтборПоТипамОпераций.Добавить(ХозяйственнаяОперация);
	КонецЕсли;
	
	Список.Параметры.УстановитьЗначениеПараметра("ОтборПоТипамОпераций", ОтборПоТипамОпераций);
	
	ОтборПоТипамДокументов.Очистить();
	
	Если Не ЗначениеЗаполнено(ТипДокумента) Тогда
		ОтборПоТипамДокументов.ЗагрузитьЗначения(ДанныеПоРазделуУчета(ТекущаяСтрокаДерева, "ДокументВводаОстатков"));
	Иначе
		ОтборПоТипамДокументов.Добавить(ТипДокумента);
	КонецЕсли;
	
	ОтборПоТипамДокументов.Добавить(СтарыйДокументВводаОстатков);
	
	//++ Локализация

	//++ НЕ УТ
	Если ОтборПоТипамОпераций.НайтиПоЗначению(
		ОбщегоНазначенияКлиент.ПредопределенныйЭлемент(
			"Перечисление.ХозяйственныеОперации.ВводОстатковВзаиморасчетовПоДоговорамАренды")) <> Неопределено Тогда
		ОтборПоТипамДокументов.Добавить(СтарыйДокументВводаОстатковВзаиморасчетовПоАренде);
	КонецЕсли;
	//-- НЕ УТ

	//-- Локализация
	
	Список.Параметры.УстановитьЗначениеПараметра("ОтборПоТипамДокументов", ОтборПоТипамДокументов);
	
	ЭтоВводОстатковВзаиморасчетов = ОтборПоТипамДокументов.НайтиПоЗначению(ВводОстатковВзаиморасчетов) <> Неопределено;
	Элементы.Валюта.Видимость = Не ЭтоВводОстатковВзаиморасчетов;
	Элементы.Сумма.Видимость = Не (ИспользоватьНесколькоВалют И ЭтоВводОстатковВзаиморасчетов);
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоОперацийПередРазворачиванием(Элемент, Строка, Отказ)

	ТекущаяСтрока = ДеревоОпераций.НайтиПоИдентификатору(Строка);
	
	Если Не ТекущаяСтрока = Неопределено Тогда
		
		РазделыУчетаРазвернутыхУзлов.Добавить(ТекущаяСтрока.РазделУчета, , , )
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоОперацийПередСворачиванием(Элемент, Строка, Отказ)
	
	ТекущаяСтрока = ДеревоОпераций.НайтиПоИдентификатору(Строка);
	
	Если Не ТекущаяСтрока = Неопределено Тогда
		
		УдаляемыйЭлемент = РазделыУчетаРазвернутыхУзлов.НайтиПоЗначению(ТекущаяСтрока.РазделУчета);
		
		Если Не УдаляемыйЭлемент = Неопределено Тогда
			РазделыУчетаРазвернутыхУзлов.Удалить(УдаляемыйЭлемент);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Если Не Копирование Тогда
		
		Отказ = Истина;
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("ОтборПоТипамОпераций", ОтборПоТипамОпераций);
		ПараметрыФормы.Вставить("ПараметрыЗаполнения",  ПодготовитьПараметрыЗаполненияДокументаВводаОстатков());
		
		ОткрытьФорму("Обработка.ЖурналДокументовВводаНачальныхОстатков.Форма.ВыборХозяйственнойОперации", ПараметрыФормы);
		
	Иначе
		Отказ = Истина;
		ОбщегоНазначенияУТКлиент.СкопироватьЭлемент(Элементы.Список);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	ОбщегоНазначенияУТКлиент.ИзменитьЭлемент(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередУдалением(Элемент, Отказ)
	
	
	Отказ = Истина;
	ОбщегоНазначенияУТКлиент.УстановитьПометкуУдаления(Элемент, Заголовок);
	ОбеспечениеВДокументахКлиент.ПроверитьЗапуститьФоновоеЗаданиеРаспределенияЗапасов();
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ВыполнятьЗамерыПроизводительности Тогда
		
		ИмяКлючевойОперацииОткрытияФормы = ПолучитьКлючевуюОперациюОткрытияФормыДокументаПоСсылке(Элемент.ТекущиеДанные.Ссылка);
		Если Не ПустаяСтрока(ИмяКлючевойОперацииОткрытияФормы) Тогда
			// СтандартныеПодсистемы.ЗамерПроизводительности
			ОценкаПроизводительностиКлиент.ЗамерВремени(ИмяКлючевойОперацииОткрытияФормы);
			// Конец СтандартныеПодсистемы.ЗамерПроизводительности
		КонецЕсли;
		
	КонецЕсли;
	
	ОбщегоНазначенияУТКлиент.ИзменитьЭлемент(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОткрытьОтчетКонтрольБалансаВводаОстатков(Команда)
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("КлючВарианта", "КонтрольВводаОстатковКонтекст");
	ПараметрыФормы.Вставить("СформироватьПриОткрытии", Истина); 

	ОткрытьФорму("Отчет.ФинансовоеСостояние.Форма", ПараметрыФормы, , "ВводОстатков");

КонецПроцедуры

&НаКлиенте
Процедура СписокУстановитьСнятьПометкуУдаления(Команда)
	
	ОбщегоНазначенияУТКлиент.УстановитьПометкуУдаления(Элементы.Список, Заголовок);
	ОбеспечениеВДокументахКлиент.ПроверитьЗапуститьФоновоеЗаданиеРаспределенияЗапасов();
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПровести(Команда)
	
	ОбщегоНазначенияУТКлиент.ПровестиДокументы(Элементы.Список, Заголовок);
	ОбеспечениеВДокументахКлиент.ПроверитьЗапуститьФоновоеЗаданиеРаспределенияЗапасов();
	
КонецПроцедуры

&НаКлиенте
Процедура СписокОтменаПроведения(Команда)
	
	ОбщегоНазначенияУТКлиент.ОтменаПроведения(Элементы.Список, Заголовок);
	ОбеспечениеВДокументахКлиент.ПроверитьЗапуститьФоновоеЗаданиеРаспределенияЗапасов();
	
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОбновитьФормуПоДаннымОтборов()
	
	ПараметрыОтбора = Обработки.ЖурналДокументовВводаНачальныхОстатков.ИнициализироватьПараметрыОтбораДокументовВводаНачальныхОстатков();
	
	ПараметрыОтбора.Организация             = ОтборПоОрганизации;
	ПараметрыОтбора.ОтборПоВидуУчета = ОтборПоВидуУчета;
	
	ТаблицаРазделовИХозяйственныхОпераций = Обработки.ЖурналДокументовВводаНачальныхОстатков.ИнициализироватьДеревоХозяйственныхОперацийВводаНачальныхОстатков(ПараметрыОтбора);
	ЗаполнитьДеревоРазделовДокументовВводаНачальныхОстатков(ТаблицаРазделовИХозяйственныхОпераций);
	
	ОтборыСписковКлиентСервер.ИзменитьЭлементОтбораСписка(Список, "Организация", ОтборПоОрганизации, ЗначениеЗаполнено(ОтборПоОрганизации));
	
	СписокВидовОтбораПоРазделамУчета = Обработки.ЖурналДокументовВводаНачальныхОстатков.ИнициализироватьСписокВидовОтбораПоРазделамУчета();
	
	Для Каждого ЭлементОтбора Из СписокВидовОтбораПоРазделамУчета Цикл
		
		ЗначениеЭлементаОтбора = ЭлементОтбора.Значение;
		
		Если ЗначениеЭлементаОтбора = "БезОтбора" Тогда
			Продолжить;
		КонецЕсли;
		
		ОтборыСписковКлиентСервер.ИзменитьЭлементОтбораСписка(Список, ЗначениеЭлементаОтбора, Истина, ОтборПоВидуУчета = ЗначениеЭлементаОтбора);
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Функция ПодготовитьПараметрыЗаполненияДокументаВводаОстатков()
	
	ПараметрыЗаполнения = ВводОстатковВызовСервера.ИнициализироватьЗначенияЗаполненияДокументаВводОстатков();
	ПараметрыЗаполнения.Организация = ОтборПоОрганизации;
	ПараметрыЗаполнения.ОтражатьВОперативномУчете = 
		ОтборПоВидуУчета = "ОтражатьВОперативномУчете" Или ОтборПоВидуУчета = "БезОтбора";
	ПараметрыЗаполнения.ОтражатьВБУиНУ = 
		ОтборПоВидуУчета = "ОтражатьВБУиНУ" Или (ОтборПоВидуУчета = "БезОтбора" И ИспользоватьРеглУчет);
	ПараметрыЗаполнения.ОтражатьВУУ = 
		ОтборПоВидуУчета = "ОтражатьВУУ" Или (ОтборПоВидуУчета = "БезОтбора" И ВестиУУННаПланеСчетовХозрасчетный);
	
	Возврат ПараметрыЗаполнения;
	
КонецФункции

&НаКлиенте
Функция ДанныеПоРазделуУчета(СтрокиДерева, ТипДанных)
	
	ДанныеПоРазделуУчета = Новый Массив();
	
	Для Каждого СтрокаДерева Из СтрокиДерева.ПолучитьЭлементы() Цикл
		ДанныеПоРазделуУчета.Добавить(СтрокаДерева[ТипДанных]);
	КонецЦикла;
	
	Возврат ДанныеПоРазделуУчета;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьДеревоРазделовДокументовВводаНачальныхОстатков(ТаблицаРазделовИХозяйственныхОпераций)
	
	Дерево = ДеревоОпераций;
	Дерево.ПолучитьЭлементы().Очистить();
	
	Для Каждого РазделУчета Из ТаблицаРазделовИХозяйственныхОпераций.Строки Цикл
		
		СтрокаГруппы = Дерево.ПолучитьЭлементы().Добавить();
		СтрокаГруппы.СтатусОперации = 2;
		СтрокаГруппы.ПредставлениеОперации = РазделУчета.РазделУчета;
		ЗаполнитьЗначенияСвойств(СтрокаГруппы, РазделУчета);
		
		Для Каждого ХозяйственнаяОперацияРазделаУчета Из РазделУчета.Строки Цикл
			
			СтрокаОперация = СтрокаГруппы.ПолучитьЭлементы().Добавить();
			
			СтрокаОперация.ХозяйственнаяОперацияДокумента = ХозяйственнаяОперацияРазделаУчета.ХозяйственнаяОперацияДокумента;
			СтрокаОперация.КоличествоДокументов           = ХозяйственнаяОперацияРазделаУчета.КоличествоДокументов;
			СтрокаОперация.ПояснениеРазделаУчета          = Строка(ХозяйственнаяОперацияРазделаУчета.ПояснениеРазделаУчета);
			СтрокаОперация.СтатусОперации                 = 1;
			Если ХозяйственнаяОперацияРазделаУчета.ХозяйственнаяОперацияДокумента = Перечисления.ХозяйственныеОперации.ВводОстатковТоваровПереданныхНаКомиссию Тогда
				Постфикс = КомиссионнаяТорговляСервер.ПостфиксСхемыКомиссии20();
				СтрокаОперация.ПредставлениеОперации = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Ввод остатков товаров, переданных на комиссию (%1)';
																													|en = 'Enter remaining consignment stock (%1)'"), Постфикс);
			ИначеЕсли ХозяйственнаяОперацияРазделаУчета.ХозяйственнаяОперацияДокумента = Перечисления.ХозяйственныеОперации.ВводОстатковТоваровПереданныхНаКомиссию2_5 Тогда
				
				Если Не ПолучитьФункциональнуюОпцию("ИспользуетсяКомиссионнаяПродажа20")
					Или ПолучитьФункциональнуюОпцию("ТолькоКомиссионныеПродажи25") Тогда
					СтрокаОперация.ПредставлениеОперации          = НСтр("ru = 'Ввод остатков товаров, переданных на комиссию';
																		|en = 'Enter remaining consignment stock'");
				Иначе
					Постфикс = КомиссионнаяТорговляСервер.ПостфиксСхемыКомиссии25();
					СтрокаОперация.ПредставлениеОперации = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Ввод остатков товаров, переданных на комиссию (%1)';
																														|en = 'Enter remaining consignment stock (%1)'"), Постфикс);
				КонецЕсли;
				
			Иначе
				СтрокаОперация.ПредставлениеОперации          = ХозяйственнаяОперацияРазделаУчета.ХозяйственнаяОперацияДокумента;
			КонецЕсли;
			СтрокаОперация.РазделУчета                    = ХозяйственнаяОперацияРазделаУчета.РазделУчета;
			СтрокаОперация.ДокументВводаОстатков          = ХозяйственнаяОперацияРазделаУчета.ДокументВводаОстатков;
			
			Если СтрокаОперация.КоличествоДокументов > 0 Тогда
				СтрокаОперация.ПредставлениеОперации = СтрокаОперация.ПредставлениеОперации + " ("+ХозяйственнаяОперацияРазделаУчета.КоличествоДокументов+")";
				СтрокаОперация.СтатусОперации = 0;
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьДанныеСписка(Параметр)
	ПараметрыОтбора                      = Обработки.ЖурналДокументовВводаНачальныхОстатков.ИнициализироватьПараметрыОтбораДокументовВводаНачальныхОстатков();
	ПараметрыОтбора.Организация          = ОтборПоОрганизации;
	ПараметрыОтбора.ОтборПоВидуУчета     = ОтборПоВидуУчета;
	ТаблицаРазделовИХозяйственныхОпераций = Обработки.ЖурналДокументовВводаНачальныхОстатков.ИнициализироватьДеревоХозяйственныхОперацийВводаНачальныхОстатков(ПараметрыОтбора);
	ЗаполнитьДеревоРазделовДокументовВводаНачальныхОстатков(ТаблицаРазделовИХозяйственныхОпераций);
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимость()
	
	Элементы.ОтборПоОрганизации.Видимость = ИспользоватьНесколькоОрганизаций;
	Элементы.ОтборПоВидуУчета.Видимость = ИспользоватьРеглУчет Или ВестиУУННаПланеСчетовХозрасчетный;
	
	Если Не ПравоДоступа("Просмотр", Метаданные.Отчеты.УправленческийБаланс) Тогда
		Элементы.ОткрытьОтчетКонтрольБалансаВводаОстатков.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СформироватьТекстЗапросаСписка()
	
	СписокВидовОтбораПоРазделамУчета = Обработки.ЖурналДокументовВводаНачальныхОстатков.ИнициализироватьСписокВидовОтбораПоРазделамУчета();
	ОтражатьПоВидуУчета              = "";
	ОписаниеРазеделовВводаОстатков   = ВводОстатковСервер.ОписаниеРазделовВводаОстатков();
	ОписаниеРазеделовВводаОстатков.Свернуть("ДокументВводаОстатков");
	
	Для Каждого ЭлементОтбора Из СписокВидовОтбораПоРазделамУчета Цикл
		
		ЗначениеЭлементаОтбора = ЭлементОтбора.Значение;
		
		Если ЗначениеЭлементаОтбора = "БезОтбора" Тогда
			Продолжить;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ОтражатьПоВидуУчета) Тогда
			ОтражатьПоВидуУчета = ОтражатьПоВидуУчета + ",
				|	";
		КонецЕсли;
		ОтражатьПоВидуУчета = ОтражатьПоВидуУчета + "ВЫБОР";  //@Query-part
		
		ПорядковыйНомерПараметра = 0;
		
		Для Каждого СтрокаОписания Из ОписаниеРазеделовВводаОстатков Цикл
			
			ПорядковыйНомерПараметра = ПорядковыйНомерПараметра + 1;
			ДокументВводаОстатков    = СтрокаОписания.ДокументВводаОстатков;
			ТипДокументаСтрокой      = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДокументВводаОстатков, "ПолноеИмя");
			МетаданныеДокумента      = ОбщегоНазначения.ОбъектМетаданныхПоИдентификатору(ДокументВводаОстатков);
			ПараметрСтрокой          = "&ТипСсылки" + ПорядковыйНомерПараметра;
			
			Если ОбщегоНазначения.ЕстьРеквизитОбъекта(ЗначениеЭлементаОтбора, МетаданныеДокумента) Тогда
				ОтражатьПоВидуУчета = ОтражатьПоВидуУчета + "
					|		КОГДА РеестрДокументовПереопределяемый.ТипСсылки = " + ПараметрСтрокой + "
					|			ТОГДА ВЫРАЗИТЬ(РеестрДокументовПереопределяемый.Ссылка КАК " + ТипДокументаСтрокой + ")." + ЗначениеЭлементаОтбора;
			КонецЕсли;
		КонецЦикла;
		
		ОтражатьПоВидуУчета = ОтражатьПоВидуУчета + "
			|		ИНАЧЕ ЛОЖЬ
			|	КОНЕЦ КАК " + ЗначениеЭлементаОтбора;
	КонецЦикла;
	
	СтруктураСвойствДинамическогоСписка = ОбщегоНазначения.СтруктураСвойствДинамическогоСписка();
	СтруктураСвойствДинамическогоСписка.ДинамическоеСчитываниеДанных = Истина;
	СтруктураСвойствДинамическогоСписка.ТекстЗапроса = СтрЗаменить(Список.ТекстЗапроса , "&ОтражатьПоВидуУчета", ОтражатьПоВидуУчета);
	СтруктураСвойствДинамическогоСписка.ОсновнаяТаблица = "РеестрДокументов";
	
	ОбщегоНазначения.УстановитьСвойстваДинамическогоСписка(Элементы.Список, СтруктураСвойствДинамическогоСписка);
	
	ПорядковыйНомерПараметра  = 0;
	
	Для Каждого СтрокаОписания Из ОписаниеРазеделовВводаОстатков Цикл 
		
		ПорядковыйНомерПараметра = ПорядковыйНомерПараметра + 1;
		ДокументВводаОстатков    = СтрокаОписания.ДокументВводаОстатков;
		МетаданныеДокумента      = ОбщегоНазначения.ОбъектМетаданныхПоИдентификатору(ДокументВводаОстатков);
		ПараметрСтрокой          = "ТипСсылки" + ПорядковыйНомерПараметра;
		
		Если ОбщегоНазначения.ЕстьРеквизитОбъекта("ОтражатьВОперативномУчете", МетаданныеДокумента)
			ИЛИ ОбщегоНазначения.ЕстьРеквизитОбъекта("ОтражатьВБУиНУ", МетаданныеДокумента) Тогда
				Список.Параметры.УстановитьЗначениеПараметра(ПараметрСтрокой, ДокументВводаОстатков);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();
	
	Настройка = УсловноеОформление.Элементы;
	
	// Валюта и Сумма
	ЭлементНастройки = Настройка.Добавить();
	ПолеВалюта = ЭлементНастройки.Поля.Элементы.Добавить();
	ПолеВалюта.Поле = Новый ПолеКомпоновкиДанных("Валюта");
	ПолеСумма = ЭлементНастройки.Поля.Элементы.Добавить();
	ПолеСумма.Поле = Новый ПолеКомпоновкиДанных("Сумма");
	
	ОперацииДенежныхСредств = Новый СписокЗначений;
	ОперацииДенежныхСредств.Добавить(Перечисления.ХозяйственныеОперации.ВводОстатковВКассах);
	ОперацииДенежныхСредств.Добавить(Перечисления.ХозяйственныеОперации.ВводОстатковВАвтономныхКассахККМКОформлениюОтчетовОРозничныхПродажах);
	ОперацииДенежныхСредств.Добавить(Перечисления.ХозяйственныеОперации.ВводОстатковВАвтономныхКассахККМПоРозничнойВыручке);
	ОперацииДенежныхСредств.Добавить(Перечисления.ХозяйственныеОперации.ВводОстатковНаБанковскихСчетах);
	ОперацииДенежныхСредств.Добавить(Перечисления.ХозяйственныеОперации.ВводОстатковЗадолженностиПодотчетников);
	ОперацииДенежныхСредств.Добавить(Перечисления.ХозяйственныеОперации.ВводОстатковПерерасходовПодотчетныхСредств);
	
	ФинансоваяОтчетностьСервер.НовыйОтбор(
		ЭлементНастройки.Отбор,
		"Список.ХозяйственнаяОперация",
		ОперацииДенежныхСредств, ,
		ВидСравненияКомпоновкиДанных.ВСписке);
	ФинансоваяОтчетностьСервер.НовыйОтбор(
		ЭлементНастройки.Отбор,
		"Список.Валюта", , ,
		ВидСравненияКомпоновкиДанных.НеЗаполнено);
	ФинансоваяОтчетностьСервер.НовыйОтбор(
		ЭлементНастройки.Отбор,
		"Список.Сумма", , ,
		ВидСравненияКомпоновкиДанных.НеЗаполнено);
	
	ЭлементНастройки.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<несколько валют>';
																			|en = '<multiple currencies>'"));
	ЭлементНастройки.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ТекстИнформационнойНадписи);

КонецПроцедуры

&НаКлиенте
Функция ПолучитьКлючевуюОперациюОткрытияФормыДокументаПоСсылке(Ссылка)
	
	ИмяФормыДокумента = "";
	
	Если Ссылка <> Неопределено И ЗначениеЗаполнено(Ссылка) Тогда
		
		Если ТипЗнч(Ссылка) = Тип("ДокументСсылка.ВводОстатковТоваров") Тогда
			ИмяФормыДокумента = "Документ.ВводОстатковТоваров.ОткрытьФормуДокумента";
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат ИмяФормыДокумента;
	
КонецФункции

#КонецОбласти
