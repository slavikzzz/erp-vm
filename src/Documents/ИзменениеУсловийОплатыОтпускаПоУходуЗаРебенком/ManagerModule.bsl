#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

// Сторнирует документ по учетам. Используется подсистемой исправления документов.
//
// Параметры:
//  Движения				 - КоллекцияДвижений, Структура	 - Коллекция движений исправляющего документа в которую будут добавлены сторно стоки.
//  Регистратор				 - ДокументСсылка				 - Документ регистратор исправления (документ исправление).
//  ИсправленныйДокумент	 - ДокументСсылка				 - Исправленный документ движения которого будут сторнированы.
//  СтруктураВидовУчета		 - Структура					 - Виды учета, по которым будет выполнено сторнирование исправленного документа.
//  					Состав полей см. в ПроведениеРасширенныйСервер.СтруктураВидовУчета().
//  ДополнительныеПараметры	 - Структура					 - Структура со свойствами:
//  					* ИсправлениеВТекущемПериоде - Булево - Истина когда исправление выполняется в периоде регистрации исправленного документа.
//						* ОтменаДокумента - Булево - Истина когда исправление вызвано документом СторнированиеНачислений.
//  					* ПериодРегистрации	- Дата - Период регистрации документа регистратора исправления.
// 
// Возвращаемое значение:
//  Булево - "Истина" если сторнирование выполнено этой функцией, "Ложь" если специальной процедуры не предусмотрено.
//
Функция СторнироватьПоУчетам(Движения, Регистратор, ИсправленныйДокумент, СтруктураВидовУчета, ДополнительныеПараметры) Экспорт
	
	УправлениеШтатнымРасписанием.СторнироватьДвиженияДокумента(Движения, ИсправленныйДокумент);
	
	Если ДополнительныеПараметры.ОтменаДокумента Тогда
		ИсправлениеДокументовЗарплатаКадры.СторнироватьДвиженияПоВсемУчетам(
			Движения, ИсправленныйДокумент, ДополнительныеПараметры, СтруктураВидовУчета);
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции
	
#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)
	|	И ЗначениеРазрешено(Сотрудник)";
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

// Описание - возвращает описание разделов данных, которые содержит документ
// 
// Возвращаемое значение:
// 	Соответствие - описание разделов данных документов -
//	 *Ключ - Строка - имя раздела. Одно из значений структуры 
//		возвращаемой методом см. МногофункциональныеДокументыБЗККлиентСервер.РазделыДанных
//   *Значение - см. МногофункциональныеДокументыБЗККлиентСервер.НовыйОписаниеРазделаДанных - описание раздела
//
Функция ОписаниеРазделовДанных() Экспорт
	ВсеРазделы = МногофункциональныеДокументыБЗККлиентСервер.РазделыДанных();
	
	ОписаниеРазделовДанных = Новый Соответствие();
	
	ОписаниеРаздела = МногофункциональныеДокументыБЗККлиентСервер.НовыйОписаниеРазделаДанных();
	ОписаниеРазделовДанных.Вставить(ВсеРазделы.КадровыеДанные, ОписаниеРаздела);	
	ОписаниеРаздела.РеквизитСостояние = "Проведен";
	ОписаниеРаздела.РеквизитОтветсвенный = "Ответственный";
	
	ОписаниеРаздела = МногофункциональныеДокументыБЗККлиентСервер.НовыйОписаниеРазделаДанных();
	ОписаниеРазделовДанных.Вставить(ВсеРазделы.ПлановыеНачисления, ОписаниеРаздела);
	ОписаниеРаздела.РеквизитСостояние = "НачисленияУтверждены";	
	ОписаниеРаздела.ТребуетсяУтверждениеПриПроведении = Истина;
	ОписаниеРаздела.СообщениеДокументНеУтвержден =  НСтр("ru = '%1 - ежемесячные начисления не установлены.';
														|en = '%1 - monthly accruals are not specified.'");
	
	Возврат ОписаниеРазделовДанных;
КонецФункции

// Описание - возвращает структуру со значениями по которым будут проверяться права на разделы документа
// 				 
// Параметры:
//  ДокументОбъект - ДокументОбъект.ИзменениеУсловийОплатыОтпускаПоУходуЗаРебенком, ДанныеФормыСтруктура - объект или 
//                   данные формы, отображающие данные документа, для которого нужно получить данные
//
// Возвращаемое значение:
// 	Структура -  см. НовыйЗначенияДоступа - значения доступа по которым будут проверяться права на документ
//
Функция ЗначенияДоступа(ДокументОбъект) Экспорт
	Возврат МногофункциональныеДокументыБЗК.ЗначенияДоступаПоСоставуДокумента(
		ДокументОбъект, 
		ДокументОбъект.Организация);
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

#Область ОбработчикиПравилРегистрации

// См. ЗарплатаКадрыРасширенныйСинхронизацияДанных.ШаблонОбработчика
Процедура ПриЗаполненииНастроекОбработчиковПравилРегистрации(Настройки) Экспорт
	ЗарплатаКадрыРасширенныйСинхронизацияДанных.ДляОтбораПоОрганизации(Настройки);
	ЗарплатаКадрыРасширенныйСинхронизацияДанных.ДляОбъектаСПрисоединеннымиФайлами(Настройки);
КонецПроцедуры

#КонецОбласти

// Возвращает описание состава документа
//
// Возвращаемое значение:
//  Структура - см. ЗарплатаКадрыСоставДокументов.НовоеОписаниеСоставаОбъекта.
Функция ОписаниеСоставаОбъекта() Экспорт
	Возврат ЗарплатаКадрыСоставДокументов.ОписаниеСоставаОбъектаФизическоеЛицоВШапке("Сотрудник", "ОсновнойСотрудник");
КонецФункции

Функция СвойстваИсправляемогоДокумента(ДокументСсылка) Экспорт
	
	Реквизиты = ИсправлениеДокументовЗарплатаКадры.РеквизитыИсправляемогоДокумента();
	Возврат ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДокументСсылка, Реквизиты);
	
КонецФункции

Функция ПараметрыИсправляемогоДокумента(ДокументСсылка) Экспорт
	
	Возврат ИсправлениеДокументовЗарплатаКадры.ПараметрыИсправляемогоДокумента(ДокументСсылка,
		СвойстваИсправляемогоДокумента(ДокументСсылка));
	
КонецФункции

Функция ОбъектЗаблокирован(СсылкаНаОбъект) Экспорт
	
	Возврат Ложь;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ДобавитьКомандыСозданияДокументов(КомандыСозданияДокументов, ДополнительныеПараметры) Экспорт
	
	ЗарплатаКадрыРасширенный.ДобавитьВКоллекциюКомандуСозданияДокументаПоМетаданнымДокумента(
		КомандыСозданияДокументов, Метаданные.Документы.ИзменениеУсловийОплатыОтпускаПоУходуЗаРебенком);
	
КонецФункции

Процедура РассчитатьФОТПоДокументу(ДокументОбъект) Экспорт
	
	Если НЕ ДокументОбъект.ИзменитьНачисления Тогда
		Возврат;
	КонецЕсли; 
			
	ТаблицаСотрудников = ДокументОбъект.Начисления.Выгрузить(, "РабочееМесто");
	ТаблицаСотрудников.Свернуть("РабочееМесто");
	
	ТаблицаНачислений = ПлановыеНачисленияСотрудников.ТаблицаНачисленийДляРасчетаВторичныхДанных();
	ТаблицаПоказателей = ПлановыеНачисленияСотрудников.ТаблицаИзвестныеПоказатели();
	ИзвестныеКадровыеДанные = ПлановыеНачисленияСотрудников.СоздатьТаблицаКадровыхДанных();
	
	Для каждого СтрокаТаблицыСотрудников Из ТаблицаСотрудников Цикл
		
		КадровыеДанныеСотрудника = ИзвестныеКадровыеДанные.Добавить();
		КадровыеДанныеСотрудника.Сотрудник = ДокументОбъект.ОсновнойСотрудник;
		КадровыеДанныеСотрудника.Период = ДокументОбъект.ДатаИзменения;
		КадровыеДанныеСотрудника.Организация = ДокументОбъект.Организация;
				
		НачисленияСотрудника = ДокументОбъект.Начисления.НайтиСтроки(Новый Структура("РабочееМесто", СтрокаТаблицыСотрудников.РабочееМесто));
		
		Для Каждого СтрокаНачисления Из НачисленияСотрудника Цикл
			
			ДанныеНачисления = ТаблицаНачислений.Добавить();
			ДанныеНачисления.Сотрудник = ДокументОбъект.ОсновнойСотрудник;
			ДанныеНачисления.Период = ДокументОбъект.ДатаИзменения;
			ДанныеНачисления.Начисление = СтрокаНачисления.Начисление;
			ДанныеНачисления.ДокументОснование = СтрокаНачисления.ДокументОснование;
			ДанныеНачисления.Размер = СтрокаНачисления.Размер;
			
			ПоказателиНачисления = ДокументОбъект.Показатели.НайтиСтроки(Новый Структура("ИдентификаторСтрокиВидаРасчета", СтрокаНачисления.ИдентификаторСтрокиВидаРасчета));
			Для Каждого СтрокаПоказателя Из ПоказателиНачисления Цикл
				ДанныеПоказателя = ТаблицаПоказателей.Добавить();
				ДанныеПоказателя.Сотрудник = ДокументОбъект.ОсновнойСотрудник;
				ДанныеПоказателя.Период = ДокументОбъект.ДатаИзменения;
				ДанныеПоказателя.Показатель = СтрокаПоказателя.Показатель;
				ДанныеПоказателя.ДокументОснование = СтрокаНачисления.ДокументОснование;
				ДанныеПоказателя.Значение = СтрокаПоказателя.Значение;
			КонецЦикла;
			
		КонецЦикла;
					
	КонецЦикла;
	
	РассчитанныеДанные = ПлановыеНачисленияСотрудников.РассчитатьВторичныеДанныеПлановыхНачислений(ТаблицаНачислений, ТаблицаПоказателей, ИзвестныеКадровыеДанные);
	
	Для Каждого ОписаниеНачисления Из РассчитанныеДанные.ПлановыйФОТ Цикл
			
		Отбор = Новый Структура("РабочееМесто, Начисление, ДокументОснование", 
			СтрокаТаблицыСотрудников.РабочееМесто, ОписаниеНачисления.Начисление, ОписаниеНачисления.ДокументОснование);
		СтрокиДокумента = ДокументОбъект.Начисления.НайтиСтроки(Отбор);
		
		Если СтрокиДокумента.Количество() > 0 Тогда
			СтрокиДокумента[0].Размер = ОписаниеНачисления.ВкладВФОТ;
		КонецЕсли; 
		
	КонецЦикла;
		
	РасчетЗарплатыРасширенный.ЗаполнитьФОТВДвиженияхЗагружаемогоДокумента(ДокументОбъект.Движения.ПлановыеНачисления, ДокументОбъект.Начисления, "РабочееМесто");		
КонецПроцедуры

Функция ДанныеДляРегистрацииВУчетаСтажаПФР(МассивСсылок) Экспорт
	ДанныеДляРегистрацииВУчете = Новый Соответствие;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("МассивСсылок", МассивСсылок);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ИзменениеУсловийОплатыОтпускаПоУходуЗаРебенком.Ссылка,
	|	ИзменениеУсловийОплатыОтпускаПоУходуЗаРебенком.ОсновнойСотрудник,
	|	ИзменениеУсловийОплатыОтпускаПоУходуЗаРебенком.ДатаИзменения,
	|	ИзменениеУсловийОплатыОтпускаПоУходуЗаРебенком.ДатаНачалаПФР,
	|	ИзменениеУсловийОплатыОтпускаПоУходуЗаРебенком.ДатаОкончанияПособияДоПолутораЛет,
	|	ИзменениеУсловийОплатыОтпускаПоУходуЗаРебенком.ВыплачиватьПособиеДоПолутораЛет,
	|	ИзменениеУсловийОплатыОтпускаПоУходуЗаРебенком.ВыплачиватьПособиеДоТрехЛет
	|ПОМЕСТИТЬ ВТДанныеДокументов
	|ИЗ
	|	Документ.ИзменениеУсловийОплатыОтпускаПоУходуЗаРебенком КАК ИзменениеУсловийОплатыОтпускаПоУходуЗаРебенком
	|ГДЕ
	|	ИзменениеУсловийОплатыОтпускаПоУходуЗаРебенком.Ссылка В(&МассивСсылок)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДанныеДокументов.Ссылка,
	|	ДанныеДокументов.ОсновнойСотрудник,
	|	ДанныеДокументов.ДатаИзменения,
	|	ДанныеДокументов.ДатаНачалаПФР,
	|	ДанныеДокументов.ДатаОкончанияПособияДоПолутораЛет,
	|	ДанныеДокументов.ВыплачиватьПособиеДоПолутораЛет,
	|	ДанныеДокументов.ВыплачиватьПособиеДоТрехЛет,
	|	МАКСИМУМ(ЕСТЬNULL(ИзменениеУсловийОплатыОтпускаПоУходуЗаРебенкомПрименениеПлановыхНачислений.Применение, ЛОЖЬ)) КАК ЭтоВозвратКРаботе
	|ИЗ
	|	ВТДанныеДокументов КАК ДанныеДокументов
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ИзменениеУсловийОплатыОтпускаПоУходуЗаРебенком.ПрименениеПлановыхНачислений КАК ИзменениеУсловийОплатыОтпускаПоУходуЗаРебенкомПрименениеПлановыхНачислений
	|		ПО ДанныеДокументов.Ссылка = ИзменениеУсловийОплатыОтпускаПоУходуЗаРебенкомПрименениеПлановыхНачислений.Ссылка
	|			И ДанныеДокументов.ОсновнойСотрудник = ИзменениеУсловийОплатыОтпускаПоУходуЗаРебенкомПрименениеПлановыхНачислений.РабочееМесто
	|
	|СГРУППИРОВАТЬ ПО
	|	ДанныеДокументов.Ссылка,
	|	ДанныеДокументов.ДатаОкончанияПособияДоПолутораЛет,
	|	ДанныеДокументов.ОсновнойСотрудник,
	|	ДанныеДокументов.ВыплачиватьПособиеДоПолутораЛет,
	|	ДанныеДокументов.ВыплачиватьПособиеДоТрехЛет,
	|	ДанныеДокументов.ДатаИзменения,
	|	ДанныеДокументов.ДатаНачалаПФР";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		ДанныеДляРегистрацииВУчетеПоДокументу = УчетСтажаПФР.ДанныеДляРегистрацииВУчетеСтажаПФР();	
		ДанныеДляРегистрацииВУчете.Вставить(Выборка.Ссылка, ДанныеДляРегистрацииВУчетеПоДокументу);
		
		Если Выборка.ЭтоВозвратКРаботе Тогда
			ОписаниеПериода = УчетСтажаПФР.ОписаниеРегистрируемогоПериода();
			ОписаниеПериода.Сотрудник = Выборка.ОсновнойСотрудник;	
			ОписаниеПериода.ДатаНачалаПериода = Макс(Выборка.ДатаИзменения, Выборка.ДатаНачалаПФР);
			ОписаниеПериода.Состояние = Перечисления.СостоянияСотрудника.Работа;
			
			РегистрируемыйПериод = УчетСтажаПФР.ДобавитьЗаписьВДанныеДляРегистрацииВУчета(ДанныеДляРегистрацииВУчетеПоДокументу, ОписаниеПериода);
											
			УчетСтажаПФР.УстановитьЗначениеРегистрируемогоРесурса(РегистрируемыйПериод, "ВидСтажаПФР", Перечисления.ВидыСтажаПФР2014.ВключаетсяВСтажДляДосрочногоНазначенияПенсии);
		Иначе
			ДатаНачалаПериодаБезОплаты = Выборка.ДатаИзменения; 
			Если Выборка.ВыплачиватьПособиеДоПолутораЛет Тогда
				Если Выборка.ДатаОкончанияПособияДоПолутораЛет >= Макс(Выборка.ДатаИзменения, Выборка.ДатаНачалаПФР) Тогда
					ОписаниеПериода = УчетСтажаПФР.ОписаниеРегистрируемогоПериода();
					ОписаниеПериода.Сотрудник = Выборка.ОсновнойСотрудник;	
					ОписаниеПериода.ДатаНачалаПериода =  Макс(Выборка.ДатаИзменения, Выборка.ДатаНачалаПФР);
					ОписаниеПериода.Состояние = Перечисления.СостоянияСотрудника.ОтпускПоУходуЗаРебенком;
					
					РегистрируемыйПериод = УчетСтажаПФР.ДобавитьЗаписьВДанныеДляРегистрацииВУчета(ДанныеДляРегистрацииВУчетеПоДокументу, ОписаниеПериода);
												
					УчетСтажаПФР.УстановитьЗначениеРегистрируемогоРесурса(РегистрируемыйПериод, "ВидСтажаПФР", Перечисления.ВидыСтажаПФР2014.Дети);	
				КонецЕсли;	
				
				ДатаНачалаПериодаБезОплаты = Выборка.ДатаОкончанияПособияДоПолутораЛет + 86400;
			КонецЕсли; 
			
			ОписаниеПериода = УчетСтажаПФР.ОписаниеРегистрируемогоПериода();
			ОписаниеПериода.Сотрудник = Выборка.ОсновнойСотрудник;	
			ОписаниеПериода.ДатаНачалаСобытия = Макс(Выборка.ДатаИзменения, Выборка.ДатаНачалаПФР);
			ОписаниеПериода.ДатаНачалаПериода = Макс(ДатаНачалаПериодаБезОплаты, Выборка.ДатаНачалаПФР);
			ОписаниеПериода.Состояние = Перечисления.СостоянияСотрудника.ОтпускПоУходуЗаРебенком;
		
			РегистрируемыйПериод = УчетСтажаПФР.ДобавитьЗаписьВДанныеДляРегистрацииВУчета(ДанныеДляРегистрацииВУчетеПоДокументу, ОписаниеПериода);
								
			УчетСтажаПФР.УстановитьЗначениеРегистрируемогоРесурса(РегистрируемыйПериод, "ВидСтажаПФР", Перечисления.ВидыСтажаПФР2014.ДЛДЕТИ);
				
		КонецЕсли;	
	КонецЦикла;	
			
	Возврат ДанныеДляРегистрацииВУчете;
														
КонецФункции	

#Область Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Обработчик = "УправлениеПечатьюБЗККлиент.ВыполнитьКомандуПечати";
	КомандаПечати.МенеджерПечати = "Обработка.ПечатьКадровыхПриказовРасширенная";
	КомандаПечати.Идентификатор = "ПФ_MXL_ПриказОВыходеНаНеполноеРабочееВремя";
	КомандаПечати.Представление = НСтр("ru = 'Приказ о работе на условиях неполного рабочего времени';
										|en = 'Part-time work order'");
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;

КонецПроцедуры

#КонецОбласти

Процедура ЗаполнитьДатуЗапретаРедактирования(ОбъектДокумента) Экспорт
	
	ЗарплатаКадры.ЗаполнитьДатуЗапретаРедактирования(ОбъектДокумента, "ДатаИзменения");
	
КонецПроцедуры

Процедура ЗаполнитьДатыЗапрета(ПараметрыОбновления) Экспорт
	
	ОбновлениеВыполнено = Истина;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ ПЕРВЫЕ 100
		|	ИзменениеУсловийОплатыОтпускаПоУходуЗаРебенком.Ссылка КАК Ссылка,
		|	ИзменениеУсловийОплатыОтпускаПоУходуЗаРебенком.Дата КАК Дата
		|ИЗ
		|	Документ.ИзменениеУсловийОплатыОтпускаПоУходуЗаРебенком КАК ИзменениеУсловийОплатыОтпускаПоУходуЗаРебенком
		|ГДЕ
		|	ИзменениеУсловийОплатыОтпускаПоУходуЗаРебенком.ДатаЗапрета = ДАТАВРЕМЯ(1, 1, 1)
		|
		|УПОРЯДОЧИТЬ ПО
		|	ИзменениеУсловийОплатыОтпускаПоУходуЗаРебенком.Дата УБЫВ";
	
	РезультатЗапроса = Запрос.Выполнить();
	Если Не РезультатЗапроса.Пустой() Тогда
		
		ОбновлениеВыполнено = Ложь;
		Выборка = РезультатЗапроса.Выбрать();
		Пока Выборка.Следующий() Цикл
			
			Если Не ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.ПодготовитьОбновлениеДанных(
				ПараметрыОбновления, Выборка.Ссылка.Метаданные().ПолноеИмя(), "Ссылка", Выборка.Ссылка) Тогда
				
				Продолжить;
				
			КонецЕсли;
			
			ОбъектДокумента = Выборка.Ссылка.ПолучитьОбъект();
			
			МенеджерДокумента = ОбщегоНазначения.МенеджерОбъектаПоСсылке(Выборка.Ссылка);
			МенеджерДокумента.ЗаполнитьДатуЗапретаРедактирования(ОбъектДокумента);
			
			ОбъектДокумента.ДополнительныеСвойства.Вставить("ОтключитьПроверкуДатыЗапретаИзменения", Истина);
			
			ОбновлениеИнформационнойБазы.ЗаписатьОбъект(ОбъектДокумента);
			ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.ЗавершитьОбновлениеДанных(ПараметрыОбновления);
			
		КонецЦикла;
		
	КонецЕсли;
	
	ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.УстановитьПараметрОбновления(ПараметрыОбновления, "ОбработкаЗавершена", ОбновлениеВыполнено);
	
КонецПроцедуры

Процедура ЗаполнитьДвиженияЗанятостьПозицийШтатногоРасписания(ПараметрыОбновления = Неопределено) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Если ПараметрыОбновления = Неопределено Тогда
		МассивОбновленных = Новый Массив;
	Иначе
		
		Если ПараметрыОбновления.Свойство("МассивОбновленных") Тогда
			МассивОбновленных = ПараметрыОбновления.МассивОбновленных;
		Иначе
			МассивОбновленных = Новый Массив;
			ПараметрыОбновления.Вставить("МассивОбновленных", МассивОбновленных);
		КонецЕсли;
		
	КонецЕсли;
	
	Запрос.УстановитьПараметр("МассивОбновленных", МассивОбновленных);
	Запрос.Текст =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ ПЕРВЫЕ 1000
		|	ТаблицаДокумента.Ссылка КАК Регистратор
		|ПОМЕСТИТЬ ВТРегистраторыКОбновлению
		|ИЗ
		|	Документ.ИзменениеУсловийОплатыОтпускаПоУходуЗаРебенком КАК ТаблицаДокумента
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КадроваяИсторияСотрудников КАК КадроваяИсторияСотрудников
		|		ПО ТаблицаДокумента.ОсновнойСотрудник = КадроваяИсторияСотрудников.Сотрудник
		|			И (КОНЕЦПЕРИОДА(ТаблицаДокумента.ДатаИзменения, ДЕНЬ) >= КадроваяИсторияСотрудников.Период)
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЗанятостьПозицийШтатногоРасписания КАК ЗанятостьПозицийШтатногоРасписания
		|		ПО ТаблицаДокумента.Ссылка = ЗанятостьПозицийШтатногоРасписания.Регистратор
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ИзменениеУсловийОплатыОтпускаПоУходуЗаРебенком КАК ТаблицаДокументаИсправления
		|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЗанятостьПозицийШтатногоРасписанияИспр КАК ЗанятостьПозицийШтатногоРасписанияИспр
		|			ПО ТаблицаДокументаИсправления.Ссылка = ЗанятостьПозицийШтатногоРасписанияИспр.РегистраторИзмерение
		|		ПО ТаблицаДокумента.Ссылка = ТаблицаДокументаИсправления.ИсправленныйДокумент
		|			И (ТаблицаДокументаИсправления.Проведен)
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ОтпускПоУходуЗаРебенком КАК ОтпускПоУходуЗаРебенком
		|		ПО ТаблицаДокумента.ДокументОснование = ОтпускПоУходуЗаРебенком.Ссылка
		|ГДЕ
		|	ТаблицаДокумента.Проведен
		|	И ОтпускПоУходуЗаРебенком.ОсвобождатьСтавку
		|	И ЗанятостьПозицийШтатногоРасписания.Регистратор ЕСТЬ NULL
		|	И ЗанятостьПозицийШтатногоРасписанияИспр.РегистраторИзмерение ЕСТЬ NULL
		|	И НЕ КадроваяИсторияСотрудников.Сотрудник ЕСТЬ NULL
		|	И НЕ ТаблицаДокумента.Ссылка В (&МассивОбновленных)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	РегистраторыКОбновлению.Регистратор КАК Регистратор
		|ИЗ
		|	ВТРегистраторыКОбновлению КАК РегистраторыКОбновлению";
	
	Если ПараметрыОбновления = Неопределено Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "ПЕРВЫЕ 1000", "");
	КонецЕсли;
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		
		ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.ЗавершитьОбработчик(ПараметрыОбновления);
		Возврат;
		
	ИначеЕсли ПараметрыОбновления <> Неопределено Тогда
		ОбщегоНазначенияКлиентСервер.ДополнитьМассив(МассивОбновленных, РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("Регистратор"));
	КонецЕсли;
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ТаблицаДокумента.Ссылка КАК Регистратор,
		|	ТаблицаДокумента.РабочееМесто КАК Сотрудник,
		|	ТаблицаДокумента.Ссылка.ДатаИзменения КАК ДатаНачала,
		|	ОтпускПоУходуЗаРебенком.ДатаОкончания КАК ДатаОкончания,
		|	ТаблицаДокументаИсправления.Ссылка КАК РегистраторИзмерение
		|ИЗ
		|	ВТРегистраторыКОбновлению КАК РегистраторыКОбновлению
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ИзменениеУсловийОплатыОтпускаПоУходуЗаРебенком.Начисления КАК ТаблицаДокумента
		|			ЛЕВОЕ СОЕДИНЕНИЕ Документ.ИзменениеУсловийОплатыОтпускаПоУходуЗаРебенком КАК ТаблицаДокументаИсправления
		|			ПО ТаблицаДокумента.Ссылка = ТаблицаДокументаИсправления.ИсправленныйДокумент
		|				И (ТаблицаДокументаИсправления.Проведен)
		|		ПО РегистраторыКОбновлению.Регистратор = ТаблицаДокумента.Ссылка
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ОтпускПоУходуЗаРебенком КАК ОтпускПоУходуЗаРебенком
		|		ПО (ТаблицаДокумента.Ссылка.ДокументОснование = ОтпускПоУходуЗаРебенком.Ссылка)
		|
		|УПОРЯДОЧИТЬ ПО
		|	ДатаНачала,
		|	Регистратор,
		|	Сотрудник";
	
	Выборка = Запрос.Выполнить().Выбрать();
	РегистрыСведений.ЗанятостьПозицийШтатногоРасписания.ЗаполнитьДвиженияПоДаннымВыборкиРегистраторов(Выборка, Истина, ПараметрыОбновления);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли