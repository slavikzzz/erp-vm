///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// Задать настройки формы отчета.
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения
//         - Неопределено
//   КлючВарианта - Строка
//                - Неопределено
//   Настройки - см. ОтчетыКлиентСервер.НастройкиОтчетаПоУмолчанию
//
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	
	Настройки.События.ПередЗагрузкойНастроекВКомпоновщик = Истина;
	
КонецПроцедуры

// Вызывается перед загрузкой новых настроек. Используется для изменения СКД отчета.
//
// Параметры:
//   Контекст - Произвольный
//   КлючСхемы - Строка
//   КлючВарианта - Строка
//                - Неопределено
//   НовыеНастройкиКД - НастройкиКомпоновкиДанных
//                    - Неопределено
//   НовыеПользовательскиеНастройкиКД - ПользовательскиеНастройкиКомпоновкиДанных
//                                    - Неопределено
//
Процедура ПередЗагрузкойНастроекВКомпоновщик(Контекст, КлючСхемы, КлючВарианта, НовыеНастройкиКД, НовыеПользовательскиеНастройкиКД) Экспорт
	
	Если КлючСхемы <> "1" Тогда
		КлючСхемы = "1";
		
		Если ТипЗнч(Контекст) = Тип("ФормаКлиентскогоПриложения")
		   И НовыеНастройкиКД <> Неопределено
		   И Контекст.Параметры.Свойство("ПараметрКоманды")
		   И ЗначениеЗаполнено(Контекст.Параметры.ПараметрКоманды)
		   И ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
			
			МодульУправлениеДоступомСлужебный = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступомСлужебный");
			ПараметрыДляОтчетов = МодульУправлениеДоступомСлужебный.ПараметрыДляОтчетов();
			
			Значения = Контекст.Параметры.ПараметрКоманды;
			Если ТипЗнч(Значения[0]) = Тип("СправочникСсылка.Пользователи")
			 Или ТипЗнч(Значения[0]) = Тип("СправочникСсылка.ГруппыПользователей")
			 Или ТипЗнч(Значения[0]) = Тип("СправочникСсылка.ВнешниеПользователи")
			 Или ТипЗнч(Значения[0]) = Тип("СправочникСсылка.ГруппыВнешнихПользователей") Тогда
				ИмяПараметра = "Участник";
			ИначеЕсли ТипЗнч(Значения[0]) = ПараметрыДляОтчетов.ТипСправочникСсылкаГруппыДоступа Тогда
				ИмяПараметра = "ГруппаДоступа";
			ИначеЕсли ТипЗнч(Значения[0]) = ПараметрыДляОтчетов.ТипСправочникСсылкаПрофилиГруппДоступа Тогда
				ИмяПараметра = "Профиль";
			КонецЕсли;
			
			СписокЗначений = Новый СписокЗначений;
			СписокЗначений.ЗагрузитьЗначения(Значения);
			ПользователиСлужебный.УстановитьОтборДляПараметра(ИмяПараметра,
				СписокЗначений, НовыеНастройкиКД, НовыеПользовательскиеНастройкиКД);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ДокументРезультат.Очистить();
	
	Если ОбщегоНазначения.РазделениеВключено() Тогда
		ВыполнитьПроверкуПравДоступа("АдминистрированиеДанных", Метаданные);
	Иначе
		ВыполнитьПроверкуПравДоступа("Администрирование", Метаданные);
	КонецЕсли;
	УстановитьПривилегированныйРежим(Истина);
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	Настройки = КомпоновщикНастроек.ПолучитьНастройки();
	
	ВнешниеНаборыДанных = Новый Структура;
	ВнешниеНаборыДанных.Вставить("Изменения", ИзмененияСоставов(Настройки));
	
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, Настройки, ДанныеРасшифровки);
	
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, ВнешниеНаборыДанных, ДанныеРасшифровки, Истина);
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	
	ПроцессорВывода.НачатьВывод();
	ЭлементРезультата = ПроцессорКомпоновки.Следующий();
	Пока ЭлементРезультата <> Неопределено Цикл
		ПроцессорВывода.ВывестиЭлемент(ЭлементРезультата);
		ЭлементРезультата = ПроцессорКомпоновки.Следующий();
	КонецЦикла;
	ПроцессорВывода.ЗакончитьВывод();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ИзмененияСоставов(Настройки)
	
	ИмяКолонкиСоединение = КонтрольРаботыПользователейСлужебный.ИмяКолонкиСоединение();
	
	Отбор = Новый Структура;
	
	СтатусыТранзакции = Новый Массив;
	СтатусыТранзакции.Добавить(СтатусТранзакцииЗаписиЖурналаРегистрации.Зафиксирована);
	СтатусыТранзакции.Добавить(СтатусТранзакцииЗаписиЖурналаРегистрации.НетТранзакции);
	Отбор.Вставить("СтатусТранзакции", СтатусыТранзакции);
	
	Период = ЗначениеПараметра(Настройки, "Период", Новый СтандартныйПериод);
	Если ЗначениеЗаполнено(Период.ДатаНачала) Тогда
		Отбор.Вставить("StartDate", Период.ДатаНачала);
	КонецЕсли;
	Если ЗначениеЗаполнено(Период.ДатаОкончания) Тогда
		Отбор.Вставить("EndDate", Период.ДатаОкончания);
	КонецЕсли;
	
	МодульУправлениеДоступомСлужебный = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступомСлужебный");
	ИмяСобытияИзменениеУчастниковГруппДоступа =
		МодульУправлениеДоступомСлужебный.ИмяСобытияИзменениеУчастниковГруппДоступаДляЖурналаРегистрации();
	СобытияДляОтбора = Новый Массив;
	СобытияДляОтбора.Добавить(
		ПользователиСлужебный.ИмяСобытияИзменениеУчастниковГруппПользователейДляЖурналаРегистрации());
	СобытияДляОтбора.Добавить(
		ПользователиСлужебный.ИмяСобытияИзменениеУчастниковГруппВнешнихПользователейДляЖурналаРегистрации());
	СобытияДляОтбора.Добавить(ИмяСобытияИзменениеУчастниковГруппДоступа);
	Отбор.Вставить("Событие", СобытияДляОтбора);
	
	Автор = ЗначениеПараметра(Настройки, "Автор", Null);
	Если Автор <> Null Тогда
		Отбор.Вставить("Пользователь", Строка(Автор));
	КонецЕсли;
	
	ТипБулево     = Новый ОписаниеТипов("Булево");
	ТипДата       = Новый ОписаниеТипов("Дата");
	ТипЧисло      = Новый ОписаниеТипов("Число");
	ТипСтрока     = Новый ОписаниеТипов("Строка");
	ТипСтрока1    = Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(1));
	ТипСтрока20   = Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(20));
	ТипСтрока36   = Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(36));
	ТипСтрока100  = Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(100));
	ТипСтрока1000 = Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(1000));
	
	ТипПрофиль       = Новый ОписаниеТипов(ТипСтрока100, "СправочникСсылка.ПрофилиГруппДоступа");
	ТипГруппаДоступа = Новый ОписаниеТипов(ТипСтрока100, "СправочникСсылка.ГруппыДоступа");
	ТипУчастник      = Новый ОписаниеТипов(ТипСтрока100, "СправочникСсылка.Пользователи,
		|СправочникСсылка.ГруппыПользователей,
		|СправочникСсылка.ВнешниеПользователи,
		|СправочникСсылка.ГруппыВнешнихПользователей");
	ТипПользователь  = Новый ОписаниеТипов(ТипСтрока100, "СправочникСсылка.Пользователи,
		|СправочникСсылка.ВнешниеПользователи");
	
	Изменения = Новый ТаблицаЗначений;
	Колонки = Изменения.Колонки;
	Колонки.Добавить("Профиль",                      ТипПрофиль);
	Колонки.Добавить("ПредставлениеПрофиля",         ТипСтрока1000);
	Колонки.Добавить("ПометкаУдаленияПрофиля",       ТипБулево);
	Колонки.Добавить("ГруппаДоступа",                ТипГруппаДоступа);
	Колонки.Добавить("ПредставлениеГруппыДоступа",   ТипСтрока1000);
	Колонки.Добавить("ПометкаУдаленияГруппыДоступа", ТипБулево);
	Колонки.Добавить("НомерСобытия",                 ТипЧисло);
	Колонки.Добавить("Дата",                         ТипДата);
	Колонки.Добавить("Автор",                        ТипСтрока100);
	Колонки.Добавить("ИдентификаторАвтора",          ТипСтрока36);
	Колонки.Добавить("Приложение",                   ТипСтрока20);
	Колонки.Добавить("Компьютер",                    ТипСтрока);
	Колонки.Добавить("Сеанс",                        ТипЧисло);
	Колонки.Добавить(ИмяКолонкиСоединение,           ТипЧисло);
	Колонки.Добавить("Участник",                     ТипУчастник);
	Колонки.Добавить("УчастникЭтоПользователь",      ТипБулево);
	Колонки.Добавить("ПредставлениеУчастника",       ТипСтрока1000);
	Колонки.Добавить("УчаствуетДо",                  ТипДата);
	Колонки.Добавить("УчастникИспользуется",         ТипБулево);
	Колонки.Добавить("Пользователь",                 ТипПользователь);
	Колонки.Добавить("ПредставлениеПользователя",    ТипСтрока1000);
	Колонки.Добавить("ПользовательИспользуется",     ТипБулево);
	Колонки.Добавить("ИзНижестоящейГруппы",          ТипБулево);
	Колонки.Добавить("ВидИзменения",                 ТипСтрока1);
	Колонки.Добавить("БылоПрофиль",                  ТипПрофиль);
	Колонки.Добавить("БылоПредставлениеПрофиля",     ТипСтрока1000);
	Колонки.Добавить("БылоПометкаУдаленияПрофиля",   ТипБулево);
	Колонки.Добавить("БылоПометкаУдаленияГруппыДоступа", ТипБулево);
	Колонки.Добавить("БылоУчаствуетДо",              ТипДата);
	
	КолонкиЖурнала = "Событие,Дата,Пользователь,ИмяПользователя,
	|ИмяПриложения,Компьютер,Сеанс,Данные," + ИмяКолонкиСоединение;
	
	УстановитьПривилегированныйРежим(Истина);
	События = Новый ТаблицаЗначений;
	ВыгрузитьЖурналРегистрации(События, Отбор, КолонкиЖурнала);
	
	НомерСобытия = 0;
	ОтборДанных = Новый Структура;
	ОтборДанных.Вставить("Профили", ИдентификаторыЗначений(
		ЗначениеПараметра(Настройки, "Профиль", Неопределено)));
	ОтборДанных.Вставить("ГруппыДоступа", ИдентификаторыЗначений(
		ЗначениеПараметра(Настройки, "ГруппаДоступа", Неопределено)));
	ОтборДанных.Вставить("Участники", ИдентификаторыЗначений(
		ЗначениеПараметра(Настройки, "Участник", Неопределено)));
	
	Для Каждого Событие Из События Цикл
		Если Событие.Событие = ИмяСобытияИзменениеУчастниковГруппДоступа Тогда
			Данные = РасширенныеДанныеИзмененияУчастниковГруппДоступа(Событие.Данные, ОтборДанных);
		Иначе
			Данные = РасширенныеДанныеИзмененияУчастниковГруппПользователей(Событие.Данные, ОтборДанных);
		КонецЕсли;
		Если Данные = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		НомерСобытия = НомерСобытия + 1;
		
		СвойстваСобытия = Новый Структура;
		СвойстваСобытия.Вставить("НомерСобытия",        НомерСобытия);
		СвойстваСобытия.Вставить("Дата",                Событие.Дата);
		СвойстваСобытия.Вставить("Автор",               Событие.ИмяПользователя);
		СвойстваСобытия.Вставить("ИдентификаторАвтора", Событие.Пользователь);
		СвойстваСобытия.Вставить("Приложение",          Событие.ИмяПриложения);
		СвойстваСобытия.Вставить("Компьютер",           Событие.Компьютер);
		СвойстваСобытия.Вставить("Сеанс",               Событие.Сеанс);
		СвойстваСобытия.Вставить(ИмяКолонкиСоединение,  Событие.Соединение);
		
		Если Событие.Событие = ИмяСобытияИзменениеУчастниковГруппДоступа Тогда
			Для Каждого ОписаниеУчастника Из Данные.ИзмененияУчастников Цикл
				СвойстваГруппыДоступа = Данные.ПредставлениеГруппДоступа.Найти(
					ОписаниеУчастника.ГруппаДоступа, "ГруппаДоступа");
				Если СвойстваГруппыДоступа = Неопределено Тогда
					Продолжить;
				КонецЕсли;
				СвойстваСтроки = Новый Структура;
				СвойстваСтроки.Вставить("Профиль",                      ДесериализованнаяСсылка(СвойстваГруппыДоступа.Профиль));
				СвойстваСтроки.Вставить("ПредставлениеПрофиля",         СвойстваГруппыДоступа.ПредставлениеПрофиля);
				СвойстваСтроки.Вставить("ПометкаУдаленияПрофиля",       СвойстваГруппыДоступа.ПометкаУдаленияПрофиля);
				СвойстваСтроки.Вставить("ГруппаДоступа",                ДесериализованнаяСсылка(СвойстваГруппыДоступа.ГруппаДоступа));
				СвойстваСтроки.Вставить("ПредставлениеГруппыДоступа",   СвойстваГруппыДоступа.Представление);
				СвойстваСтроки.Вставить("ПометкаУдаленияГруппыДоступа", СвойстваГруппыДоступа.ПометкаУдаления);
				СвойстваСтроки.Вставить("Участник",                     ДесериализованнаяСсылка(ОписаниеУчастника.Участник));
				СвойстваСтроки.Вставить("ПредставлениеУчастника",       ОписаниеУчастника.ПредставлениеУчастника);
				СвойстваСтроки.Вставить("УчаствуетДо",                  ОписаниеУчастника.СрокДействия);
				СвойстваСтроки.Вставить("УчастникИспользуется",         ОписаниеУчастника.УчастникИспользуется);
				СвойстваСтроки.Вставить("ВидИзменения",                 ?(ОписаниеУчастника.ВидИзменения = "Удалено", "-",
					?(ОписаниеУчастника.ВидИзменения = "Добавлено", "+",
					?(ОписаниеУчастника.ВидИзменения = "Изменено", "*", "?"))));
				
				СтарыеЗначения = СвойстваГруппыДоступа.СтарыеЗначенияСвойств;
				СвойстваСтроки.Вставить("БылоПрофиль", ?(СтарыеЗначения.Свойство("Профиль"),
					ДесериализованнаяСсылка(СтарыеЗначения.Профиль), СвойстваСтроки.Профиль));
				СвойстваСтроки.Вставить("БылоПредставлениеПрофиля", ?(СтарыеЗначения.Свойство("ПредставлениеПрофиля"),
					СтарыеЗначения.ПредставлениеПрофиля, СвойстваСтроки.ПредставлениеПрофиля));
				СвойстваСтроки.Вставить("БылоПометкаУдаленияПрофиля", ?(СтарыеЗначения.Свойство("ПометкаУдаленияПрофиля"),
					СтарыеЗначения.ПометкаУдаленияПрофиля, СвойстваСтроки.ПометкаУдаленияПрофиля));
				СвойстваСтроки.Вставить("БылоПометкаУдаленияГруппыДоступа", ?(СтарыеЗначения.Свойство("ПометкаУдаления"),
					СтарыеЗначения.ПометкаУдаления, СвойстваСтроки.ПометкаУдаленияГруппыДоступа));
				СтарыеЗначения = ОписаниеУчастника.СтарыеЗначенияСвойств;
				СвойстваСтроки.Вставить("БылоУчаствуетДо", ?(СтарыеЗначения.Свойство("СрокДействия"),
					СтарыеЗначения.СрокДействия, СвойстваСтроки.УчаствуетДо));
				
				Отбор = Новый Структура("ГруппаПользователей", ОписаниеУчастника.Участник);
				СоставГруппы = Данные.СоставыГруппПользователей.НайтиСтроки(Отбор);
				Если СоставГруппы.Количество() = 0 Тогда
					НоваяСтрока = Изменения.Добавить();
					ЗаполнитьЗначенияСвойств(НоваяСтрока, СвойстваСобытия);
					ЗаполнитьЗначенияСвойств(НоваяСтрока, СвойстваСтроки);
					НоваяСтрока.Пользователь              = ОписаниеУчастника.Участник;
					НоваяСтрока.УчастникЭтоПользователь   = Истина;
					НоваяСтрока.ПредставлениеПользователя = ОписаниеУчастника.ПредставлениеУчастника;
					НоваяСтрока.ПользовательИспользуется  = ОписаниеУчастника.УчастникИспользуется;
				Иначе
					Для Каждого ОписаниеПользователя Из СоставГруппы Цикл
						НоваяСтрока = Изменения.Добавить();
						ЗаполнитьЗначенияСвойств(НоваяСтрока, СвойстваСобытия);
						ЗаполнитьЗначенияСвойств(НоваяСтрока, СвойстваСтроки);
						НоваяСтрока.Пользователь              = ОписаниеПользователя.Пользователь;
						НоваяСтрока.ПредставлениеПользователя = ОписаниеПользователя.ПредставлениеПользователя;
						НоваяСтрока.ПользовательИспользуется  = ОписаниеПользователя.Используется;
						НоваяСтрока.ИзНижестоящейГруппы       = ОписаниеПользователя.ИзНижестоящейГруппы;
					КонецЦикла;
				КонецЕсли;
			КонецЦикла;
		Иначе
			ОтборПользователя = Новый Структура("ГруппаПользователей, Пользователь",
				ПользователиСлужебный.СериализованнаяСсылка(Пользователи.ГруппаВсеПользователи()));
			ОтборВнешнегоПользователя = Новый Структура("ГруппаПользователей, Пользователь",
				ПользователиСлужебный.СериализованнаяСсылка(ВнешниеПользователи.ГруппаВсеВнешниеПользователи()));
			
			Для Каждого ОписаниеУчастника Из Данные.УчастникиГруппДоступа Цикл
				СвойстваГруппыДоступа = Данные.ПредставлениеГруппДоступа.Найти(
					ОписаниеУчастника.ГруппаДоступа, "ГруппаДоступа");
				Если СвойстваГруппыДоступа = Неопределено Тогда
					Продолжить;
				КонецЕсли;
				Отбор = Новый Структура("ГруппаПользователей", ОписаниеУчастника.Участник);
				НайденныеСтроки = Данные.ИзмененияСоставов.НайтиСтроки(Отбор);
				ЭтоПользователь = Ложь;
				Если Не ЗначениеЗаполнено(НайденныеСтроки) Тогда
					ЭтоПользователь = Истина;
					ОтборПользователя.Пользователь = ОписаниеУчастника.Участник;
					НайденныеСтроки = Данные.ИзмененияСоставов.НайтиСтроки(ОтборПользователя);
					Если Не ЗначениеЗаполнено(НайденныеСтроки) Тогда
						ОтборВнешнегоПользователя.Пользователь = ОписаниеУчастника.Участник;
						НайденныеСтроки = Данные.ИзмененияСоставов.НайтиСтроки(ОтборВнешнегоПользователя);
						Если Не ЗначениеЗаполнено(НайденныеСтроки) Тогда
							Продолжить;
						КонецЕсли;
					КонецЕсли;
				КонецЕсли;
				ТекущийПрофиль = ДесериализованнаяСсылка(СвойстваГруппыДоступа.Профиль);
				ТекущаяГруппаДоступа = ДесериализованнаяСсылка(СвойстваГруппыДоступа.ГруппаДоступа);
				Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл
					НоваяСтрока = Изменения.Добавить();
					ЗаполнитьЗначенияСвойств(НоваяСтрока, СвойстваСобытия);
					НоваяСтрока.Профиль                      = ТекущийПрофиль;
					НоваяСтрока.ПредставлениеПрофиля         = СвойстваГруппыДоступа.ПредставлениеПрофиля;
					НоваяСтрока.ПометкаУдаленияПрофиля       = СвойстваГруппыДоступа.ПометкаУдаленияПрофиля;
					НоваяСтрока.ГруппаДоступа                = ТекущаяГруппаДоступа;
					НоваяСтрока.ПредставлениеГруппыДоступа   = СвойстваГруппыДоступа.Представление;
					НоваяСтрока.ПометкаУдаленияГруппыДоступа = СвойстваГруппыДоступа.ПометкаУдаления;
					Если ЭтоПользователь Тогда
						НоваяСтрока.Участник                  = ДесериализованнаяСсылка(НайденнаяСтрока.Пользователь);
						НоваяСтрока.УчастникЭтоПользователь   = Истина;
						НоваяСтрока.ПредставлениеУчастника    = НайденнаяСтрока.ПредставлениеПользователя;
						НоваяСтрока.Пользователь              = НоваяСтрока.Участник;
						НоваяСтрока.ПредставлениеПользователя = НоваяСтрока.ПредставлениеУчастника;
					Иначе
						НоваяСтрока.Участник                  = ДесериализованнаяСсылка(НайденнаяСтрока.ГруппаПользователей);
						НоваяСтрока.ПредставлениеУчастника    = НайденнаяСтрока.ПредставлениеГруппы;
						НоваяСтрока.Пользователь              = ДесериализованнаяСсылка(НайденнаяСтрока.Пользователь);
						НоваяСтрока.ПредставлениеПользователя = НайденнаяСтрока.ПредставлениеПользователя;
					КонецЕсли;
					НоваяСтрока.УчаствуетДо                  = ОписаниеУчастника.СрокДействия;
					НоваяСтрока.УчастникИспользуется         = НайденнаяСтрока.Используется;
					НоваяСтрока.ПользовательИспользуется     = НайденнаяСтрока.Используется;
					НоваяСтрока.ИзНижестоящейГруппы          = НайденнаяСтрока.ИзНижестоящейГруппы;
					НоваяСтрока.ВидИзменения                 = ?(НайденнаяСтрока.ВидИзменения = "Удалено", "-",
						?(НайденнаяСтрока.ВидИзменения = "Добавлено", "+",
						?(НайденнаяСтрока.ВидИзменения = "Изменено", "*", "?")));
				
					НоваяСтрока.БылоПрофиль                      = НоваяСтрока.Профиль;
					НоваяСтрока.БылоПредставлениеПрофиля         = НоваяСтрока.ПредставлениеПрофиля;
					НоваяСтрока.БылоПометкаУдаленияПрофиля       = НоваяСтрока.ПометкаУдаленияПрофиля;
					НоваяСтрока.БылоПометкаУдаленияГруппыДоступа = НоваяСтрока.ПометкаУдаленияГруппыДоступа;
					НоваяСтрока.БылоУчаствуетДо                  = НоваяСтрока.УчаствуетДо;
				КонецЦикла;
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Изменения;
	
КонецФункции

Функция ЗначениеПараметра(Настройки, ИмяПараметра, ЗначениеПоУмолчанию)
	
	Поле = Настройки.ПараметрыДанных.Элементы.Найти(ИмяПараметра);
	
	Если Поле <> Неопределено И Поле.Использование Тогда
		Возврат Поле.Значение;
	КонецЕсли;
	
	Возврат ЗначениеПоУмолчанию;
	
КонецФункции

Функция ИдентификаторыЗначений(ВыбранныеЗначения)
	
	Если ВыбранныеЗначения = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Если ТипЗнч(ВыбранныеЗначения) = Тип("СписокЗначений") Тогда
		Значения = ВыбранныеЗначения.ВыгрузитьЗначения();
	Иначе
		Значения = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ВыбранныеЗначения);
	КонецЕсли;
	
	Результат = Новый Соответствие;
	
	Для Каждого Значение Из Значения Цикл
		Если Не ЗначениеЗаполнено(Значение) Тогда
			Продолжить;
		КонецЕсли;
		Результат.Вставить(НРег(Значение.УникальныйИдентификатор()), Истина);
		Результат.Вставить(ПользователиСлужебный.СериализованнаяСсылка(Значение), Истина);
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Параметры:
//  ДанныеСобытия - Строка
//
// Возвращаемое значение:
//  Структура
//
Функция РасширенныеДанныеИзмененияУчастниковГруппПользователей(ДанныеСобытия, ОтборДанных)
	
	Если Не ЗначениеЗаполнено(ДанныеСобытия) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Попытка
		Данные = ОбщегоНазначения.ЗначениеИзСтрокиXML(ДанныеСобытия);
	Исключение
		Возврат Неопределено;
	КонецПопытки;
	
	Если ТипЗнч(Данные) <> Тип("Структура") Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Хранение = Новый Структура;
	Хранение.Вставить("ВерсияСтруктурыДанных");
	Хранение.Вставить("ИзмененияСоставов");
	Хранение.Вставить("ПредставлениеГрупп");
	Хранение.Вставить("ПредставлениеПользователей");
	Хранение.Вставить("УчастникиГруппДоступа");
	Хранение.Вставить("ПредставлениеГруппДоступа");
	ЗаполнитьЗначенияСвойств(Хранение, Данные);
	Если Хранение.ВерсияСтруктурыДанных <> 2 Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Свойства = Новый Структура;
	Свойства.Вставить("ИдентификаторГруппы", "");
	Свойства.Вставить("ИдентификаторПользователя", "");
	Свойства.Вставить("ИзНижестоящейГруппы", Ложь);
	Свойства.Вставить("Используется", Ложь);
	Свойства.Вставить("ВидИзменения", "");
	
	ИзмененияСоставов = ХранимаяТаблица(Хранение.ИзмененияСоставов, Свойства);
	Если Не ЗначениеЗаполнено(ИзмененияСоставов) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Свойства = Новый Структура;
	Свойства.Вставить("ИдентификаторРодителя", "");
	Свойства.Вставить("ИдентификаторГруппы", "");
	Свойства.Вставить("ПредставлениеГруппы", "");
	Свойства.Вставить("СсылкаГруппы", "");
	
	ПредставлениеГрупп = ХранимаяТаблица(Хранение.ПредставлениеГрупп, Свойства);
	Если ПредставлениеГрупп = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Свойства = Новый Структура;
	Свойства.Вставить("ИдентификаторПользователя", "");
	Свойства.Вставить("ПредставлениеПользователя", "");
	Свойства.Вставить("СсылкаПользователя", "");
	
	ПредставлениеПользователей = ХранимаяТаблица(Хранение.ПредставлениеПользователей, Свойства);
	Если ПредставлениеПользователей = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Свойства = Новый Структура;
	Свойства.Вставить("ГруппаДоступа", "");
	Свойства.Вставить("Участник", "");
	Свойства.Вставить("СрокДействия", '00010101');
	
	УчастникиГруппДоступа = ХранимаяТаблица(Хранение.УчастникиГруппДоступа, Свойства);
	Если УчастникиГруппДоступа = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Свойства = Новый Структура;
	Свойства.Вставить("ГруппаДоступа", "");
	Свойства.Вставить("ПометкаУдаления", Ложь);
	Свойства.Вставить("Представление", "");
	Свойства.Вставить("Профиль", "");
	Свойства.Вставить("ПометкаУдаленияПрофиля", Ложь);
	Свойства.Вставить("ПредставлениеПрофиля", "");
	
	ПредставлениеГруппДоступа = ХранимаяТаблица(Хранение.ПредставлениеГруппДоступа, Свойства);
	Если ПредставлениеГруппДоступа = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ПредставлениеГрупп.Индексы.Добавить("ИдентификаторГруппы");
	ПредставлениеПользователей.Индексы.Добавить("ИдентификаторПользователя");
	
	ИзмененияСоставов.Колонки.Добавить("ПредставлениеГруппы");
	ИзмененияСоставов.Колонки.Добавить("ГруппаПользователей");
	ИзмененияСоставов.Колонки.Добавить("ПредставлениеПользователя");
	ИзмененияСоставов.Колонки.Добавить("Пользователь");
	
	Индекс = ИзмененияСоставов.Количество();
	Пока Индекс > 0 Цикл
		Индекс = Индекс - 1;
		Строка = ИзмененияСоставов.Получить(Индекс);
		СвойстваГруппы = ПредставлениеГрупп.Найти(
			Строка.ИдентификаторГруппы, "ИдентификаторГруппы");
		СвойстваПользователя = ПредставлениеПользователей.Найти(
			Строка.ИдентификаторПользователя, "ИдентификаторПользователя");
		
		Если СвойстваПользователя = Неопределено
		 Или СвойстваГруппы = Неопределено
		 Или ОтборДанных.Участники <> Неопределено
		   И ОтборДанных.Участники.Получить(Строка.ИдентификаторГруппы) = Неопределено
		   И ОтборДанных.Участники.Получить(Строка.ИдентификаторПользователя) = Неопределено Тогда
			
			ИзмененияСоставов.Удалить(Индекс);
			Продолжить;
		КонецЕсли;
		Строка.ПредставлениеГруппы = СвойстваГруппы.ПредставлениеГруппы;
		Строка.ГруппаПользователей = СвойстваГруппы.СсылкаГруппы;
		Строка.ПредставлениеПользователя = СвойстваПользователя.ПредставлениеПользователя;
		Строка.Пользователь              = СвойстваПользователя.СсылкаПользователя;
	КонецЦикла;
	
	Если Не ЗначениеЗаполнено(ИзмененияСоставов) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ПредставлениеГруппДоступа.Индексы.Добавить("ГруппаДоступа");
	ИзмененияСоставов.Индексы.Добавить("ГруппаПользователей, Пользователь");
	
	Результат = Новый Структура;
	Результат.Вставить("ИзмененияСоставов", ИзмененияСоставов);
	Результат.Вставить("УчастникиГруппДоступа", УчастникиГруппДоступа);
	Результат.Вставить("ПредставлениеГруппДоступа", ПредставлениеГруппДоступа);
	
	Если ОтборДанных.Профили = Неопределено
	   И ОтборДанных.ГруппыДоступа = Неопределено Тогда
		
		Возврат Результат;
	КонецЕсли;
	
	Индекс = ПредставлениеГруппДоступа.Количество();
	Пока Индекс > 0 Цикл
		Индекс = Индекс - 1;
		Строка = ПредставлениеГруппДоступа.Получить(Индекс);
		Если ОтборДанных.Профили <> Неопределено
		   И ОтборДанных.Профили.Получить(Строка.Профиль) = Неопределено
		 Или ОтборДанных.ГруппыДоступа <> Неопределено
		   И ОтборДанных.ГруппыДоступа.Получить(Строка.ГруппаДоступа) = Неопределено Тогда
			ПредставлениеГруппДоступа.Удалить(Индекс);
			Продолжить;
		КонецЕсли;
	КонецЦикла;
	
	Если Не ЗначениеЗаполнено(ПредставлениеГруппДоступа) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Параметры:
//  ДанныеСобытия - Строка
//
// Возвращаемое значение:
//  Структура
//
Функция РасширенныеДанныеИзмененияУчастниковГруппДоступа(ДанныеСобытия, ОтборДанных)
	
	Если Не ЗначениеЗаполнено(ДанныеСобытия) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Попытка
		Данные = ОбщегоНазначения.ЗначениеИзСтрокиXML(ДанныеСобытия);
	Исключение
		Возврат Неопределено;
	КонецПопытки;
	
	Если ТипЗнч(Данные) <> Тип("Структура") Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Хранение = Новый Структура;
	Хранение.Вставить("ВерсияСтруктурыДанных");
	Хранение.Вставить("ИзмененияУчастников");
	Хранение.Вставить("ПредставлениеГруппДоступа");
	Хранение.Вставить("СоставыГруппПользователей");
	ЗаполнитьЗначенияСвойств(Хранение, Данные);
	Если Хранение.ВерсияСтруктурыДанных <> 1 Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Свойства = Новый Структура;
	Свойства.Вставить("ГруппаДоступа", "");
	Свойства.Вставить("Участник", "");
	Свойства.Вставить("ПредставлениеУчастника", "");
	Свойства.Вставить("УчастникИспользуется", Ложь);
	Свойства.Вставить("СрокДействия", '00010101');
	Свойства.Вставить("СтарыеЗначенияСвойств", Новый Структура);
	Свойства.Вставить("ВидИзменения", "");
	
	ИзмененияУчастников = ХранимаяТаблица(Хранение.ИзмененияУчастников, Свойства);
	Если Не ЗначениеЗаполнено(ИзмененияУчастников) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Свойства = Новый Структура;
	Свойства.Вставить("ГруппаДоступа", "");
	Свойства.Вставить("Представление", "");
	Свойства.Вставить("ПометкаУдаления", Ложь);
	Свойства.Вставить("Профиль", "");
	Свойства.Вставить("ПредставлениеПрофиля", "");
	Свойства.Вставить("ПометкаУдаленияПрофиля", Ложь);
	Свойства.Вставить("СтарыеЗначенияСвойств", Новый Структура);
	
	ПредставлениеГруппДоступа = ХранимаяТаблица(Хранение.ПредставлениеГруппДоступа, Свойства);
	Если ПредставлениеГруппДоступа = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Свойства = Новый Структура;
	Свойства.Вставить("ГруппаПользователей", "");
	Свойства.Вставить("Пользователь", "");
	Свойства.Вставить("Используется", Ложь);
	Свойства.Вставить("ПредставлениеПользователя", "");
	Свойства.Вставить("ИзНижестоящейГруппы", Ложь);
	
	СоставыГруппПользователей = ХранимаяТаблица(Хранение.СоставыГруппПользователей, Свойства);
	Если СоставыГруппПользователей = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ПредставлениеГруппДоступа.Индексы.Добавить("ГруппаДоступа");
	СоставыГруппПользователей.Индексы.Добавить("ГруппаПользователей");
	
	Результат = Новый Структура;
	Результат.Вставить("ИзмененияУчастников", ИзмененияУчастников);
	Результат.Вставить("ПредставлениеГруппДоступа", ПредставлениеГруппДоступа);
	Результат.Вставить("СоставыГруппПользователей", СоставыГруппПользователей);
	
	Если ОтборДанных.Профили = Неопределено
	   И ОтборДанных.ГруппыДоступа = Неопределено
	   И ОтборДанных.Участники = Неопределено Тогда
		
		Возврат Результат;
	КонецЕсли;
	
	Индекс = ПредставлениеГруппДоступа.Количество();
	Пока Индекс > 0 Цикл
		Индекс = Индекс - 1;
		Строка = ПредставлениеГруппДоступа.Получить(Индекс);
		Если ОтборДанных.Профили <> Неопределено
		   И ОтборДанных.Профили.Получить(Строка.Профиль) = Неопределено
		 Или ОтборДанных.ГруппыДоступа <> Неопределено
		   И ОтборДанных.ГруппыДоступа.Получить(Строка.ГруппаДоступа) = Неопределено Тогда
			ПредставлениеГруппДоступа.Удалить(Индекс);
			Продолжить;
		КонецЕсли;
	КонецЦикла;
	
	Если Не ЗначениеЗаполнено(ПредставлениеГруппДоступа) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ВсеГруппыПользователей = Новый Соответствие;
	Индекс = СоставыГруппПользователей.Количество();
	Пока Индекс > 0 Цикл
		Индекс = Индекс - 1;
		Строка = СоставыГруппПользователей.Получить(Индекс);
		ВсеГруппыПользователей.Вставить(Строка.ГруппаПользователей, Истина);
		Если ОтборДанных.Участники <> Неопределено
		   И ОтборДанных.Участники.Получить(Строка.Пользователь) = Неопределено
		   И ОтборДанных.Участники.Получить(Строка.ГруппаПользователей) = Неопределено Тогда
			СоставыГруппПользователей.Удалить(Индекс);
			Продолжить;
		КонецЕсли;
	КонецЦикла;
	
	Индекс = ИзмененияУчастников.Количество();
	Пока Индекс > 0 Цикл
		Индекс = Индекс - 1;
		Строка = ИзмененияУчастников.Получить(Индекс);
		ЭтоПользователь = ВсеГруппыПользователей.Получить(Строка.Участник) = Неопределено;
		Если ЭтоПользователь
		   И ОтборДанных.Участники <> Неопределено
		   И ОтборДанных.Участники.Получить(Строка.Участник) = Неопределено
		 Или Не ЭтоПользователь
		   И СоставыГруппПользователей.Найти(Строка.Участник, "ГруппаПользователей") = Неопределено Тогда
			ИзмененияУчастников.Удалить(Индекс);
			Продолжить;
		КонецЕсли;
	КонецЦикла;
	
	Если Не ЗначениеЗаполнено(ИзмененияУчастников) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ХранимаяТаблица(Строки, Свойства)
	
	Если ТипЗнч(Строки) <> Тип("Массив") Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Результат = Новый ТаблицаЗначений;
	Для Каждого КлючИЗначение Из Свойства Цикл
		Типы = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ТипЗнч(КлючИЗначение.Значение));
		Результат.Колонки.Добавить(КлючИЗначение.Ключ, Новый ОписаниеТипов(Типы));
	КонецЦикла;
	
	Для Каждого Строка Из Строки Цикл
		Если ТипЗнч(Строка) <> Тип("Структура") Тогда
			Возврат Неопределено;
		КонецЕсли;
		НоваяСтрока = Результат.Добавить();
		Для Каждого КлючИЗначение Из Свойства Цикл
			Если Не Строка.Свойство(КлючИЗначение.Ключ)
			 Или ТипЗнч(Строка[КлючИЗначение.Ключ]) <> ТипЗнч(КлючИЗначение.Значение) Тогда
				Возврат Неопределено;
			КонецЕсли;
			НоваяСтрока[КлючИЗначение.Ключ] = Строка[КлючИЗначение.Ключ];
		КонецЦикла;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Функция ДесериализованнаяСсылка(СериализованнаяСсылка)
	
	Если СериализованнаяСсылка = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Попытка
		Результат = ЗначениеИзСтрокиВнутр(СериализованнаяСсылка);
	Исключение
		Результат = Неопределено;
	КонецПопытки;
	
	Если Результат = Неопределено Тогда
		Возврат СериализованнаяСсылка;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.';
						|en = 'Invalid object call on the client.'");
#КонецЕсли