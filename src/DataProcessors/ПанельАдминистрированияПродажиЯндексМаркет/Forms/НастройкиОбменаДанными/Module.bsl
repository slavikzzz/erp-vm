
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Параметры.Свойство("УчетнаяЗаписьМаркетплейса", УчетнаяЗапись);
	Параметры.Свойство("ПоказыватьВыборУчетнойЗаписи", ПоказыватьВыборУчетнойЗаписи);

	Если Не ЗначениеЗаполнено(УчетнаяЗапись) И Не ПоказыватьВыборУчетнойЗаписи Тогда
		Отказ = Истина;
		Возврат; 
	Иначе
		Если ЗначениеЗаполнено(УчетнаяЗапись) Тогда  
			ИнициализироватьФормуПоУчетнойЗаписи();
		КонецЕсли;    
		
		Если ПоказыватьВыборУчетнойЗаписи Тогда  
			Элементы.ГруппаВыборУЗ.Видимость           = Истина;
			Элементы.ФормаСохранитьНастройки.Видимость = Ложь;
			Элементы.ФормаНазад.Видимость              = Ложь;
			Элементы.ДекорацияНазад.Видимость          = Истина;
		КонецЕсли;
	КонецЕсли;  

КонецПроцедуры   

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ОбновитьАвторизациюПриложения" Тогда 
		СрокДоступаНаЯндексДиск  = СрокДоступаНаЯндексДиск();
		ЗаполнитьДанныеАвторизацииНаЯндексДиск();
		ОбновитьОтображениеДанных();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СтраницыПриСменеСтраницы(Элемент, ТекущаяСтраница)

	ОбновитьВидимостьКнопокНазадДалее(); 
	ПроверитьОбновитьДанныеАвторизацииНаЯндексДиск();

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Назад(Команда)

	СменитьСтраницу("_Назад");

КонецПроцедуры

&НаКлиенте
Процедура Далее(Команда)

	СменитьСтраницу("_Далее");

КонецПроцедуры

&НаКлиенте
Процедура ОткрытьРасписаниеПолученияРекомендованныхСвязей(Команда)

	ПрефиксРасписания      = "ЯндексМаркет_ПолучениеРекомендацийПоСклейкеТовараЯндексМаркет_";
	НаименованиеРасписания = ПрефиксыРегламентныхЗаданий.НайтиПоЗначению(ПрефиксРасписания).Представление;

	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("УчетнаяЗаписьМаркетплейса",        УчетнаяЗапись);
	ПараметрыОткрытия.Вставить("ИмяМетаданных",                    "ПолучениеРекомендацийПоСклейкеТовараЯндексМаркет");
	ПараметрыОткрытия.Вставить("Наименование",                     НаименованиеРасписания);
	ПараметрыОткрытия.Вставить("Префикс",                          ПрефиксРасписания);  
	ПараметрыОткрытия.Вставить("ОткрыватьПодОграниченнымиПравами", Истина);

	ОткрытьФорму("Справочник.УчетныеЗаписиМаркетплейсов.Форма.РегламентноеЗадание",
		ПараметрыОткрытия,
		ЭтотОбъект,,,,
		Новый ОписаниеОповещения("ОбновлениеНастроекРегламентногоЗаданияЗавершение", ЭтотОбъект),
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);

КонецПроцедуры

&НаКлиенте
Процедура ОткрытьРасписаниеОтправкиНаМодерациюСвязейТоваров(Команда)
	
	ПрефиксРасписания      = "ЯндексМаркет_ОтправкаНаМодерациюСвязейТоваровЯндексМаркет_";
	НаименованиеРасписания = ПрефиксыРегламентныхЗаданий.НайтиПоЗначению(ПрефиксРасписания).Представление;
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("УчетнаяЗаписьМаркетплейса",        УчетнаяЗапись);
	ПараметрыОткрытия.Вставить("ИмяМетаданных",                    "ОтправкаНаМодерациюСвязейТоваровЯндексМаркет");
	ПараметрыОткрытия.Вставить("Наименование",                     НаименованиеРасписания);
	ПараметрыОткрытия.Вставить("Префикс",                          ПрефиксРасписания); 
	ПараметрыОткрытия.Вставить("ОткрыватьПодОграниченнымиПравами", Истина);
		
	ОткрытьФорму("Справочник.УчетныеЗаписиМаркетплейсов.Форма.РегламентноеЗадание",
		ПараметрыОткрытия,
		ЭтотОбъект,,,,
		Новый ОписаниеОповещения("ОбновлениеНастроекРегламентногоЗаданияЗавершение", ЭтотОбъект),
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьРасписаниеПолученияСтатусовМодерации(Команда)

	ПрефиксРасписания      = "ЯндексМаркет_ПолучениеСтатусовМодерацииТоваровЯндексМаркет_";
	НаименованиеРасписания = ПрефиксыРегламентныхЗаданий.НайтиПоЗначению(ПрефиксРасписания).Представление;
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("УчетнаяЗаписьМаркетплейса",        УчетнаяЗапись);
	ПараметрыОткрытия.Вставить("ИмяМетаданных",                    "ПолучениеСтатусовМодерацииТоваровЯндексМаркет");
	ПараметрыОткрытия.Вставить("Наименование",                     НаименованиеРасписания);
	ПараметрыОткрытия.Вставить("Префикс",                          ПрефиксРасписания);     
	ПараметрыОткрытия.Вставить("ОткрыватьПодОграниченнымиПравами", Истина);

	ОткрытьФорму("Справочник.УчетныеЗаписиМаркетплейсов.Форма.РегламентноеЗадание", 
		ПараметрыОткрытия,
		ЭтотОбъект,,,,
		Новый ОписаниеОповещения("ОбновлениеНастроекРегламентногоЗаданияЗавершение", ЭтотОбъект),
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);

КонецПроцедуры

&НаКлиенте
Процедура ОткрытьРасписаниеВыгрузкиЦен(Команда)

	ПрефиксРасписания      = "ЯндексМаркет_ВыгрузкаУстановленныхЦенЯндексМаркет_";
	НаименованиеРасписания = ПрефиксыРегламентныхЗаданий.НайтиПоЗначению(ПрефиксРасписания).Представление;

	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("УчетнаяЗаписьМаркетплейса",        УчетнаяЗапись);
	ПараметрыОткрытия.Вставить("ИмяМетаданных",                    "ВыгрузкаУстановленныхЦенЯндексМаркет");
	ПараметрыОткрытия.Вставить("Наименование",                     НаименованиеРасписания);
	ПараметрыОткрытия.Вставить("Префикс",                          ПрефиксРасписания);  
	ПараметрыОткрытия.Вставить("ОткрыватьПодОграниченнымиПравами", Истина);

	ОткрытьФорму("Справочник.УчетныеЗаписиМаркетплейсов.Форма.РегламентноеЗадание", 
		ПараметрыОткрытия,
		ЭтотОбъект,,,,
		Новый ОписаниеОповещения("ОбновлениеНастроекРегламентногоЗаданияЗавершение", ЭтотОбъект),
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);

КонецПроцедуры

&НаКлиенте
Процедура ОткрытьВидыЦен(Команда)

	ОткрытьФорму("Справочник.ВидыЦен.Форма.ФормаСписка",
		,
		ЭтотОбъект,
		Истина);

КонецПроцедуры

&НаКлиенте
Процедура ОткрытьРасписаниеОбновленияЦен(Команда)

	ОткрытьФорму("Справочник.ВидыЦен.Форма.ФормаНастройкиРасписанияАвтообновленияЦен",
		,
		ЭтотОбъект,
		Истина);

КонецПроцедуры

&НаКлиенте
Процедура ОткрытьРасписаниеВыгрузкиОстатковТоваров(Команда)

	ПрефиксРасписания      = "ЯндексМаркет_ВыгрузкаОстатковТоваровЯндексМаркет_";
	НаименованиеРасписания = ПрефиксыРегламентныхЗаданий.НайтиПоЗначению(ПрефиксРасписания).Представление;

	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("УчетнаяЗаписьМаркетплейса",        УчетнаяЗапись);
	ПараметрыОткрытия.Вставить("ИмяМетаданных",                    "ВыгрузкаОстатковТоваровЯндексМаркет");
	ПараметрыОткрытия.Вставить("Наименование",                     НаименованиеРасписания);
	ПараметрыОткрытия.Вставить("Префикс",                          ПрефиксРасписания);  
	ПараметрыОткрытия.Вставить("ОткрыватьПодОграниченнымиПравами", Истина);
	
	ОткрытьФорму("Справочник.УчетныеЗаписиМаркетплейсов.Форма.РегламентноеЗадание",
		ПараметрыОткрытия,
		ЭтотОбъект,,,,
		Новый ОписаниеОповещения("ОбновлениеНастроекРегламентногоЗаданияЗавершение", ЭтотОбъект),
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);

КонецПроцедуры

&НаКлиенте
Процедура ПодключитьЯндексДискНажатие(Элемент)
	
	ПараметрыФормы = Новый Структура("ПараметрыПриложенияЯндекс, УчетнаяЗаписьМаркетплейса",ПараметрыПриложенияЯндексДиск(), УчетнаяЗапись);
	ОткрытьФорму("Справочник.УчетныеЗаписиМаркетплейсов.Форма.АвторизацияПриложенияЯндекс", ПараметрыФормы, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура Сохранить(Команда)

	Если СохранитьНаСервере() Тогда
		Закрыть(УчетнаяЗапись);
		ОповеститьОбИзменении(УчетнаяЗапись);
		Оповестить("ЯндексМаркет_НастройкиОбменаДанными", УчетнаяЗапись);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьДанныеАвторизацииНаЯндексДиск()  
	
	ЧастиСтроки = Новый Массив;
	
	ТекущаяДатаСеанса = ТекущаяДатаСеанса();
	
	Если СрокДоступаНаЯндексДиск < ТекущаяДатаСеанса Тогда 
		
		СостояниеАвторизацииТекст = НСтр("ru = 'Доступ не настроен.';
										|en = 'Доступ не настроен.'");
	    СостояниеАвторизации = Новый ФорматированнаяСтрока(СостояниеАвторизацииТекст,,ЦветаСтиля.ЦветОсобогоТекста);
		
	ИначеЕсли СрокДоступаНаЯндексДиск > ТекущаяДатаСеанса
			  И СрокДоступаНаЯндексДиск - 864000 < ТекущаяДатаСеанса Тогда
			  
		КоличествоДней = (НачалоДня(СрокДоступаНаЯндексДиск) - НачалоДня(ТекущаяДатаСеанса)) / (60 * 60 * 24); 

		СостояниеАвторизацииТекст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку( 
									НСтр("ru = 'Доступ предоставлен до %1 (истекает через %2). Для продления авторизации воспользуйтесь командой ""Подключить Яндекс Диск"".';
										|en = 'Доступ предоставлен до %1 (истекает через %2). Для продления авторизации воспользуйтесь командой ""Подключить Яндекс Диск"".'"),
									Формат(СрокДоступаНаЯндексДиск,"ДФ=dd.MM.yyyy"),
									КоличествоДней);
		СостояниеАвторизации = Новый ФорматированнаяСтрока(СостояниеАвторизацииТекст,,ЦветаСтиля.ЦветОсобогоТекста);  	
		
	ИначеЕсли СрокДоступаНаЯндексДиск - 864000 > ТекущаяДатаСеанса Тогда
		
		СостояниеАвторизацииТекст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку( 
									НСтр("ru = 'Доступ предоставлен до %1.';
										|en = 'Доступ предоставлен до %1.'"),
									Формат(СрокДоступаНаЯндексДиск,"ДФ=dd.MM.yyyy"));
		СостояниеАвторизации = Новый ФорматированнаяСтрока(СостояниеАвторизацииТекст,,ЦветаСтиля.РезультатУспехЦвет);
	КонецЕсли;
	
	ЧастиСтроки = Новый Массив;  
	ЧастиСтроки.Добавить(СостояниеАвторизации); 
	ЧастиСтроки.Добавить("
						|");
	ЧастиСтроки.Добавить(НСтр("ru = 'Авторизация на сервисе Яндекс Диск необходима для выгрузки изображений товара.';
								|en = 'Авторизация на сервисе Яндекс Диск необходима для выгрузки изображений товара.'"));
	
	Элементы.ДекорацияАвторизацияЯндексДискПодсказка1.Заголовок = Новый ФорматированнаяСтрока(ЧастиСтроки);
	
КонецПроцедуры

&НаСервере
Процедура ИнициализироватьФормуПоУчетнойЗаписи()
	
	УстановитьПривилегированныйРежим(Истина);
	ДанныеУчетнойЗаписиЯндексМаркет = ИнтеграцияСЯндексМаркетСервер.ДанныеУчетнойЗаписиЯндексМаркет(УчетнаяЗапись);
	УстановитьПривилегированныйРежим(Ложь);
	
	Наименование          = ДанныеУчетнойЗаписиЯндексМаркет.Наименование;
	МодельРаботы          = ДанныеУчетнойЗаписиЯндексМаркет.СхемаРаботы;
	Организация           = ДанныеУчетнойЗаписиЯндексМаркет.Организация;
	ИдентификаторАккаунта = ДанныеУчетнойЗаписиЯндексМаркет.ИдентификаторАккаунта;
	ИдентификаторКабинета = ДанныеУчетнойЗаписиЯндексМаркет.ИдентификаторКабинета;
	ИдентификаторКампании = ДанныеУчетнойЗаписиЯндексМаркет.ИдентификаторМагазина;
	НомерМагазина         = ДанныеУчетнойЗаписиЯндексМаркет.ИдентификаторКлиента;
	ВключенаСинхронизация = Не ДанныеУчетнойЗаписиЯндексМаркет.НеОбновлятьДанныеТорговойПлощадки; 
    ЛогинИзХранилища         = ИнтеграцияСЯндексМаркетСервер.ДанныеАвторизацииЛогин(ИдентификаторАккаунта); 
	Если ЛогинИзХранилища <> Неопределено Тогда
		Логин = ЛогинИзХранилища; 
	КонецЕсли;	
	ДополнительнаяИнформация = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
									НСтр("ru = 'ID кампании - %1, ID кабинета - %2';
										|en = 'ID кампании - %1, ID кабинета - %2'"),
									ИдентификаторКампании,
									ИдентификаторКабинета);

	ЦенаПродажи           = ДанныеУчетнойЗаписиЯндексМаркет.ЦенаПродажи;
	ИсточникКатегории     = ДанныеУчетнойЗаписиЯндексМаркет.ИсточникКатегории;

	ЗаполнитьСкладПоУчетнойЗаписи();
	ОбновитьВидимостьКнопокНазадДалее();

	ПараметрыВыбора = Новый Структура("УчетнаяЗаписьМаркетплейса", УчетнаяЗапись);
	ДанныеВыбора    = Перечисления.СхемыРаботыТорговыхПлощадок.ПолучитьДанныеВыбора(ПараметрыВыбора);

	Для Каждого ЗначениеВыбора Из ДанныеВыбора Цикл
		Элементы.МодельРаботы.СписокВыбора.Добавить(ЗначениеВыбора.Значение, ЗначениеВыбора.Представление);
	КонецЦикла;   
	
	Элементы.ФормаСохранитьНастройки.Видимость = Истина; 
	Если ПоказыватьВыборУчетнойЗаписи Тогда 
		Элементы.ФормаНазад.Видимость     = Истина;
		Элементы.ДекорацияНазад.Видимость = Ложь;
	КонецЕсли;       
	
	СрокДоступаНаЯндексДиск  = СрокДоступаНаЯндексДиск();
	ЗаполнитьДанныеАвторизацииНаЯндексДиск(); 
		
	ЗаполнитьИнформациюПоРегламентнымЗаданиям(Истина);
	
	ПредыдущийСклад               = Склад;
	ПредыдущийИдентификаторСклада = ИдентификаторСклада;
	
КонецПроцедуры

&НаСервере
Функция СрокДоступаНаЯндексДиск()  
	
	Возврат ИнтеграцияСМаркетплейсамиСервер.ПолучитьДатуДействияДоступаЯндексДиск(УчетнаяЗапись);

КонецФункции

&НаСервере
Процедура ЗаполнитьСкладПоУчетнойЗаписи()

	Запрос = Новый Запрос();
	Запрос.Текст =
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	СоответствияОбъектовМаркетплейсов.ИдентификаторОбъектаМаркетплейса КАК ИдентификаторОбъектаМаркетплейса,
		|	СоответствияОбъектовМаркетплейсов.НаименованиеОбъектаМаркетплейса КАК НаименованиеОбъектаМаркетплейса,
		|	СоответствияОбъектовМаркетплейсов.Объект1С КАК Склад
		|ИЗ
		|	РегистрСведений.СоответствияОбъектовМаркетплейсов КАК СоответствияОбъектовМаркетплейсов
		|ГДЕ
		|	СоответствияОбъектовМаркетплейсов.УчетнаяЗаписьМаркетплейса = &УчетнаяЗапись
		|	И СоответствияОбъектовМаркетплейсов.ВидОбъектаМаркетплейса = ЗНАЧЕНИЕ(Перечисление.ВидыОбъектовМаркетплейсов.Склад)";

	Запрос.Параметры.Вставить("УчетнаяЗапись",          УчетнаяЗапись);
	Запрос.УстановитьПараметр("ВидОбъектаМаркетплейса", Перечисления.ВидыОбъектовМаркетплейсов.Склад);

	ВыборкаДанных = Запрос.Выполнить().Выбрать();
		
	Пока ВыборкаДанных.Следующий() Цикл
		ИдентификаторСклада = ВыборкаДанных.ИдентификаторОбъектаМаркетплейса;
		Склад               = ВыборкаДанных.Склад;
	КонецЦикла;

КонецПроцедуры
	
&НаСервере
Функция ОбновитьКлючиДоступаПоУчетнойЗаписиНаСервере()
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияФункции(УникальныйИдентификатор);
	ПараметрыВыполнения.ОжидатьЗавершение            = 0;
	ПараметрыВыполнения.НаименованиеФоновогоЗадания  = НСтр("ru = 'Яндекс Диск. Обновление данных авторизации.';
															|en = 'Яндекс Диск. Обновление данных авторизации.'");
	ПараметрыВыполнения.ЗапуститьВФоне               = Истина;
	ПараметрыВыполнения.ПрерватьВыполнениеЕслиОшибка = Истина;
	
	ИмяМетода = "ИнтеграцияСМаркетплейсамиСервер.ОбновитьКлючиДоступаПоУчетнойЗаписи";
	Возврат ДлительныеОперации.ВыполнитьФункцию(ПараметрыВыполнения, 
		ИмяМетода,
		УчетнаяЗапись);
	
КонецФункции

&НаКлиенте
Процедура ПроверитьОбновитьДанныеАвторизацииНаЯндексДиск()
	
	ТекущаяДатаСеансаНаСервере = ОбщегоНазначенияКлиент.ДатаСеанса();
	
	Если СрокДоступаНаЯндексДиск > ТекущаяДатаСеансаНаСервере
		И СрокДоступаНаЯндексДиск - 864000 < ТекущаяДатаСеансаНаСервере Тогда 
		
		ДлительнаяОперация    = ОбновитьКлючиДоступаПоУчетнойЗаписиНаСервере();
		ОповещениеОЗавершении = Новый ОписаниеОповещения("ОбновитьКлючиДоступаПоУчетнойЗаписиЗавершениеФоновогоЗадания", ЭтотОбъект, УчетнаяЗапись);
		
		Если ДлительнаяОперация.Статус = "Выполнено" Тогда
			ВыполнитьОбработкуОповещения(ОповещениеОЗавершении, ДлительнаяОперация);
			
		Иначе
			ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
			ПараметрыОжидания.ВыводитьОкноОжидания             = Истина;
			ПараметрыОжидания.ТекстСообщения                   = НСтр("ru = 'Обновление данных авторизации для доступа на Яндекс Диск.';
																		|en = 'Обновление данных авторизации для доступа на Яндекс Диск.'");
			ПараметрыОжидания.ОповещениеПользователя.Показать  = Истина;
			ПараметрыОжидания.ОповещениеПользователя.Текст     = НСтр("ru = 'Получение данных';
																		|en = 'Получение данных'");
			ПараметрыОжидания.ОповещениеПользователя.Пояснение = НСтр("ru = 'Завершено Обновление данных авторизации для доступа на Яндекс Диск.';
																		|en = 'Завершено Обновление данных авторизации для доступа на Яндекс Диск.'");
			ПараметрыОжидания.ОповещениеПользователя.Картинка  = БиблиотекаКартинок.ЛоготипЯндексМаркет;
			
			ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, ОповещениеОЗавершении, ПараметрыОжидания);
		КонецЕсли;	
	КонецЕсли;     
	
КонецПроцедуры  

&НаСервере
Функция ОбновитьДанныеУчетнойЗаписи()  
	
	Результат = Ложь;

	НачатьТранзакцию();
	
	Попытка
		БлокировкаДанных = Новый БлокировкаДанных;
		ЭлементБлокировкиДанных = БлокировкаДанных.Добавить("Справочник.УчетныеЗаписиМаркетплейсов");
		ЭлементБлокировкиДанных.УстановитьЗначение("Ссылка", УчетнаяЗапись);
		БлокировкаДанных.Заблокировать();

		УчетнаяЗаписьОбъект                                   = УчетнаяЗапись.ПолучитьОбъект();
		УчетнаяЗаписьОбъект.Наименование                      = Наименование;
		УчетнаяЗаписьОбъект.Организация                       = Организация;
		УчетнаяЗаписьОбъект.ИсточникКатегории                 = ИсточникКатегории;
		УчетнаяЗаписьОбъект.ИдентификаторАккаунта             = ИдентификаторАккаунта;
		УчетнаяЗаписьОбъект.ИдентификаторКабинета             = ИдентификаторКабинета;
		УчетнаяЗаписьОбъект.ИдентификаторМагазина             = ИдентификаторКампании;
		УчетнаяЗаписьОбъект.ИдентификаторКлиента              = НомерМагазина;
		УчетнаяЗаписьОбъект.СхемаРаботы                       = МодельРаботы;
		УчетнаяЗаписьОбъект.НеОбновлятьДанныеТорговойПлощадки = Не ВключенаСинхронизация;
	
		ТабличнаяЧастьВидовЦен = УчетнаяЗаписьОбъект.ВидыЦен; 
		СтрЦенаПродажи         = НСтр("ru = 'Цена продажи';
										|en = 'Selling price'");
		СтрокаЦеныПродажи      = ТабличнаяЧастьВидовЦен.Найти(СтрЦенаПродажи, "ИмяНастройки");
	
		Если СтрокаЦеныПродажи = Неопределено Тогда
			СтрокаЦеныПродажи              = ТабличнаяЧастьВидовЦен.Добавить();
			СтрокаЦеныПродажи.ИмяНастройки = СтрЦенаПродажи;
			СтрокаЦеныПродажи.ВидЦены      = ЦенаПродажи;
		Иначе
			СтрокаЦеныПродажи.ВидЦены = ЦенаПродажи;
		КонецЕсли;
	
		УчетнаяЗаписьОбъект.Записать();
		
		ЗафиксироватьТранзакцию(); 
		
		Результат = Истина;
		
	Исключение
		ОтменитьТранзакцию();  
		СообщениеПользователю = ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());  
		СтрокаПоиска = НСтр("ru = 'У пользователя недостаточно прав на исполнение операции над базой данных.';
							|en = 'The user has insufficient rights to perform operations with the database.'");
		Если СтрНайти(СообщениеПользователю,СтрокаПоиска)>0 Тогда 
			СообщениеПользователю = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'У пользователя недостаточно прав на исполнение операции над базой данных.Проверьте доступность работы с организацией ""%1"" в настройках профиля доступа.';
																								|en = 'The user has insufficient rights to perform operations with the database. Check whether it is possible to operate with the ""%1"" company in the access profile settings.'"),Организация);
	
		КонецЕсли;    
		
		ОбщегоНазначения.СообщитьПользователю(СообщениеПользователю);
	КонецПопытки;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура ЗаписатьСоответствиеСкладов()

	НачатьТранзакцию();
	
	Попытка
		БлокировкаДанных = Новый БлокировкаДанных;
		ЭлементБлокировкиДанных = БлокировкаДанных.Добавить("РегистрСведений.СоответствияОбъектовМаркетплейсов");
		ЭлементБлокировкиДанных.УстановитьЗначение("УчетнаяЗаписьМаркетплейса", УчетнаяЗапись);
		ЭлементБлокировкиДанных.УстановитьЗначение("ВидОбъектаМаркетплейса",    Перечисления.ВидыОбъектовМаркетплейсов.Склад);
		БлокировкаДанных.Заблокировать();

		НаборЗаписей = РегистрыСведений.СоответствияОбъектовМаркетплейсов.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.УчетнаяЗаписьМаркетплейса.Установить(УчетнаяЗапись);
		НаборЗаписей.Отбор.ВидОбъектаМаркетплейса.Установить(Перечисления.ВидыОбъектовМаркетплейсов.Склад);
		НаборЗаписей.Прочитать();
	
		Если НаборЗаписей.Количество() > 0 Тогда
			Запись = НаборЗаписей[0];
		Иначе
			Запись = НаборЗаписей.Добавить();
		КонецЕсли;
	
		Запись.УчетнаяЗаписьМаркетплейса        = УчетнаяЗапись;
		Запись.ВидОбъектаМаркетплейса           = ПредопределенноеЗначение("Перечисление.ВидыОбъектовМаркетплейсов.Склад");
		Запись.ИдентификаторОбъектаМаркетплейса = ИдентификаторСклада;
		Запись.Объект1С                         = Склад;
		Запись.НаименованиеОбъектаМаркетплейса  = СокрЛП(Склад);
		Запись.ДатаАктуальности                 = ТекущаяДатаСеанса();
	
		НаборЗаписей.Записать();
	
		ЗафиксироватьТранзакцию();
		
	Исключение
		ОтменитьТранзакцию();
		ОбщегоНазначения.СообщитьПользователю(
			ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
КонецПроцедуры

&НаКлиенте
Функция СоответствиеПереключенияСтраниц()

	СоответствиеПереключенияСтраниц = Новый Соответствие;
	
	СоответствиеПереключенияСтраниц.Вставить("ДанныеМагазина_Далее",                   "СтраницаСопоставлениеДанных");
	СоответствиеПереключенияСтраниц.Вставить("СтраницаСопоставлениеДанных_Назад",      "ДанныеМагазина");
	СоответствиеПереключенияСтраниц.Вставить("СтраницаСопоставлениеДанных_Далее",      "СтраницаНастройкиОбновленияЦен");
	СоответствиеПереключенияСтраниц.Вставить("СтраницаНастройкиОбновленияЦен_Далее",   "СтраницаНастройкиОбменаОстатками");
	СоответствиеПереключенияСтраниц.Вставить("СтраницаНастройкиОбновленияЦен_Назад",   "СтраницаСопоставлениеДанных");
	СоответствиеПереключенияСтраниц.Вставить("СтраницаНастройкиОбменаОстатками_Назад", "СтраницаНастройкиОбновленияЦен");

	Возврат СоответствиеПереключенияСтраниц;

КонецФункции

&НаКлиенте
Процедура СменитьСтраницу(Постфикс)
	
	ОчиститьСообщения();
	
	Если Элементы.ГруппаВыбораУчетнойЗаписи.ТекущаяСтраница = Элементы.ГруппаВыбораУчетнойЗаписи.ПодчиненныеЭлементы.ГруппаВыборУЗ
		И Постфикс = "_Далее" Тогда       
		
		Если Не ЗначениеЗаполнено(УчетнаяЗапись) Тогда  
			ТекстОшибки = 	НСтр("ru = 'Выберите магазин';
									|en = 'Select a store'",);
			ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстОшибки);
		Иначе	
			ИнициализироватьФормуПоУчетнойЗаписи();
			Элементы.ГруппаВыбораУчетнойЗаписи.ТекущаяСтраница = Элементы.ГруппаВыбораУчетнойЗаписи.ПодчиненныеЭлементы.ГруппаБезВыбораУЗ; 
		КонецЕсли;
		
	ИначеЕсли Элементы.Страницы.ТекущаяСтраница = Элементы.Страницы.ПодчиненныеЭлементы.ДанныеМагазина
		И Постфикс = "_Назад" Тогда

		Элементы.ГруппаВыбораУчетнойЗаписи.ТекущаяСтраница = Элементы.ГруппаВыбораУчетнойЗаписи.ПодчиненныеЭлементы.ГруппаВыборУЗ; 	
		Элементы.ФормаСохранитьНастройки.Видимость = Ложь;
		Элементы.ФормаНазад.Видимость              = Ложь;
		Элементы.ДекорацияНазад.Видимость          = Истина;
		
	Иначе        
		
		СоответствиеПереключенияСтраниц   = СоответствиеПереключенияСтраниц();
		Элементы.Страницы.ТекущаяСтраница = Элементы[СоответствиеПереключенияСтраниц[Элементы.Страницы.ТекущаяСтраница.Имя + Постфикс]];
		ОбновитьВидимостьКнопокНазадДалее(); 
		
	КонецЕсли;
КонецПроцедуры

&НаКлиенте  
Процедура ОбновитьКлючиДоступаПоУчетнойЗаписиЗавершениеФоновогоЗадания(Результат, ДополнительныеПараметры) Экспорт
	
	СрокДоступаНаЯндексДиск  = СрокДоступаНаЯндексДиск();
	ЗаполнитьДанныеАвторизацииНаЯндексДиск();
	ОбновитьОтображениеДанных();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновлениеНастроекРегламентногоЗаданияЗавершение(Результат, ДополнительныеПараметры) Экспорт

	ЗаполнитьИнформациюПоРегламентнымЗаданиям();

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьИнформациюПоРегламентнымЗаданиям(ЗаполнитьПрефиксы = Ложь)

	СписокОбновляемыхЭлементов = Новый СписокЗначений;
	СписокОбновляемыхЭлементов.Добавить("ИнформацияОРасписанииВыгрузкиТоварногоКаталога", "ЯндексМаркет_ПолучениеРекомендацийПоСклейкеТовараЯндексМаркет_");
	СписокОбновляемыхЭлементов.Добавить("ИнформацияОРасписанииОтправкиНаМодерациюСвязейТоваров", "ЯндексМаркет_ОтправкаНаМодерациюСвязейТоваровЯндексМаркет_");
	СписокОбновляемыхЭлементов.Добавить("ИнформацияОРасписанииПолученияСтатусовМодерации", "ЯндексМаркет_ПолучениеСтатусовМодерацииТоваровЯндексМаркет_");
	СписокОбновляемыхЭлементов.Добавить("ИнформацияОРасписанииВыгрузкиЦен", "ЯндексМаркет_ВыгрузкаУстановленныхЦенЯндексМаркет_");
	СписокОбновляемыхЭлементов.Добавить("ИнформацияОРасписанииВыгрузкиОстатков", "ЯндексМаркет_ВыгрузкаОстатковТоваровЯндексМаркет_");
    
    УстановитьПривилегированныйРежим(Истина);
	ПрефиксыРегламентныхЗаданий          = ИнтеграцияСЯндексМаркетСервер.ПрефиксыРегламентныхЗаданий();  
	СостояниеРегламентныхЗаданийМагазина = ИнтеграцияСЯндексМаркетСервер.ПолучитьСостоянияРегламентныхЗаданийМагазина(УчетнаяЗапись, ПрефиксыРегламентныхЗаданий);
	ОтключенныеРегламентныеЗадания       = СостояниеРегламентныхЗаданийМагазина.ОтключенныеРегламентныеЗадания;
    УстановитьПривилегированныйРежим(Ложь);

	Для Каждого ОбновляемыйЭлемент Из СписокОбновляемыхЭлементов Цикл
		ЭлементОбновления = Элементы[ОбновляемыйЭлемент.Значение];
		ЭлементОбновления.Видимость = (ОтключенныеРегламентныеЗадания.НайтиПоЗначению(ОбновляемыйЭлемент.Представление) <> Неопределено);
	КонецЦикла;

КонецПроцедуры

&НаСервереБезКонтекста
Функция ПараметрыПриложенияЯндексДиск()

	Возврат ИнтеграцияСМаркетплейсамиСервер.ПараметрыПриложенияЯндексДиск();

КонецФункции

&НаСервере
Процедура ОбновитьВидимостьКнопокНазадДалее()

	Если Элементы.Страницы.ТекущаяСтраница = Элементы.Страницы.ПодчиненныеЭлементы.ДанныеМагазина Тогда  
		Если Не ПоказыватьВыборУчетнойЗаписи Тогда
			Элементы.ФормаНазад.Видимость     = Ложь;
			Элементы.ДекорацияНазад.Видимость = Истина;
		Иначе   
			Элементы.ФормаНазад.Видимость     = Истина;
			Элементы.ДекорацияНазад.Видимость = Ложь;
		КонецЕсли;
	Иначе
		Элементы.ФормаНазад.Видимость     = Истина;
		Элементы.ДекорацияНазад.Видимость = Ложь;
	КонецЕсли;

	Если Элементы.Страницы.ТекущаяСтраница = Элементы.Страницы.ПодчиненныеЭлементы.СтраницаНастройкиОбменаОстатками
			И (МодельРаботы = Перечисления.СхемыРаботыТорговыхПлощадок.FBS
				Или МодельРаботы = Перечисления.СхемыРаботыТорговыхПлощадок.Express) Тогда
		Элементы.ФормаДалее.Видимость                      = Ложь;
		Элементы.ФормаДалее.КнопкаПоУмолчанию              = Ложь;
		Элементы.ФормаСохранитьНастройки.КнопкаПоУмолчанию = Истина;
		ПродажиСервер.УстановитьРежимВыбораГруппЭлементовСклада(Элементы.Склад);
		
	ИначеЕсли Элементы.Страницы.ТекущаяСтраница = Элементы.Страницы.ПодчиненныеЭлементы.СтраницаНастройкиОбновленияЦен
				И Не (МодельРаботы = Перечисления.СхемыРаботыТорговыхПлощадок.FBS
					Или МодельРаботы = Перечисления.СхемыРаботыТорговыхПлощадок.Express) Тогда
		Элементы.ФормаДалее.Видимость                      = Ложь;
		Элементы.ФормаДалее.КнопкаПоУмолчанию              = Ложь;
		Элементы.ФормаСохранитьНастройки.КнопкаПоУмолчанию = Истина;
		
	Иначе
		Элементы.ФормаДалее.Видимость         = Истина;
		Элементы.ФормаДалее.КнопкаПоУмолчанию = Истина;
	КонецЕсли;

КонецПроцедуры

&НаСервере
Функция СохранитьНаСервере()   
	
	Результат = Ложь;

	Попытка
		Результат = ОбновитьДанныеУчетнойЗаписи();
		
		Если МодельРаботы = Перечисления.СхемыРаботыТорговыхПлощадок.FBS
				Или МодельРаботы = Перечисления.СхемыРаботыТорговыхПлощадок.Express Тогда
			ЗаписатьСоответствиеСкладов();
			
			Если Склад <> ПредыдущийСклад
					Или ИдентификаторСклада <> ПредыдущийИдентификаторСклада Тогда
				РегистрыСведений.ОстаткиТоваровМаркетплейсов.ОчиститьЗаписиПоСкладу(УчетнаяЗапись, Неопределено);
			КонецЕсли;
		КонецЕсли;

	Исключение
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'При сохранении настроек учетной записи ""%1"" возникли ошибки: %2';
				|en = 'Errors occurred while saving the settings of account ""%1"": %2'",
				ОбщегоНазначения.КодОсновногоЯзыка()),
			УчетнаяЗапись,
			ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));

		ОбщегоНазначения.СообщитьПользователю(ТекстОшибки);
		Возврат Ложь;
	КонецПопытки;

	Возврат Результат;

КонецФункции

&НаКлиенте
Процедура ИдентификаторКлиентаНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;   
	ПолучитьИзБуфераОбменаНомерМагазина();

КонецПроцедуры  

&НаКлиенте
Асинх Процедура ПолучитьИзБуфераОбменаНомерМагазина() 
	
	НомерМагазина = Ждать СодержимоеБуфераОбмена();	

КонецПроцедуры

&НаКлиенте
Асинх Функция СодержимоеБуфераОбмена()
	
	Если СредстваБуфераОбмена.ИспользованиеДоступно() Тогда
		Если Ждать СредстваБуфераОбмена.СодержитДанныеАсинх(СтандартныйФорматДанныхБуфераОбмена.Текст) Тогда
			Возврат Ждать СредстваБуфераОбмена.ПолучитьДанныеАсинх(СтандартныйФорматДанныхБуфераОбмена.Текст);
		КонецЕсли;
	КонецЕсли;   
	
	Возврат Неопределено;
	
КонецФункции

#КонецОбласти
