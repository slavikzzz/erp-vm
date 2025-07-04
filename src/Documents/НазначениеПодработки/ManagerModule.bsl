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

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ДляВсехСтрок( ЗначениеРазрешено(ФизическиеЛица.ФизическоеЛицо, NULL КАК ИСТИНА)
	|	) И ЗначениеРазрешено(Организация)";
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
	ОписаниеРаздела.РеквизитСостояние = "Утверждено";	
	ОписаниеРаздела.ТребуетсяУтверждениеПриПроведении = Истина;
	ОписаниеРаздела.СообщениеДокументНеУтвержден =  НСтр("ru = '%1 - документ не утвержден.';
														|en = '%1 - the document is not confirmed.'");
	
	Возврат ОписаниеРазделовДанных;
КонецФункции

// Описание - возвращает структуру со значениями по которым будут проверяться права на разделы документа
// 				 
// Параметры:
//  ДокументОбъект - ДокументОбъект.НазначениеПодработки, ДанныеФормыСтруктура - объект или данные формы, 
//					отображающие данные документа, для которого нужно получить данные
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

// Возвращает описание состава документа
//
// Возвращаемое значение:
//  Структура - см. ЗарплатаКадрыСоставДокументов.НовоеОписаниеСоставаОбъекта.
Функция ОписаниеСоставаОбъекта() Экспорт
	
	ОписаниеСостава = ЗарплатаКадрыСоставДокументов.НовоеОписаниеСоставаОбъекта();
	ОписаниеСостава.ЗаполнятьФизическиеЛицаПоСотрудникам = Ложь;
	ОписаниеСостава.ИспользоватьКраткийСостав = Ложь;
	
	ЗарплатаКадрыСоставДокументов.ДобавитьОписаниеХраненияСотрудниковФизическихЛиц(
		ОписаниеСостава.ОписаниеХраненияСотрудниковФизическихЛиц,
		,
		,
		"ГоловнойСотрудник");
	
	ЗарплатаКадрыСоставДокументов.ДобавитьОписаниеХраненияСотрудниковФизическихЛиц(
		ОписаниеСостава.ОписаниеХраненияСотрудниковФизическихЛиц,
		,
		,
		"СовмещающийСотрудник");
	
	ЗарплатаКадрыСоставДокументов.ДобавитьОписаниеХраненияСотрудниковФизическихЛиц(
		ОписаниеСостава.ОписаниеХраненияСотрудниковФизическихЛиц,
		,
		,
		"ОтсутствующийСотрудник");
	
	Возврат ОписаниеСостава;
	
КонецФункции

#Область ОбработчикиРегистрацииФизическихЛиц

Функция ПринадлежностиОбъекта() Экспорт
	Возврат ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве("Организация");
КонецФункции

#КонецОбласти

#Область ОбработчикиПравилРегистрации

// См. ЗарплатаКадрыРасширенныйСинхронизацияДанных.ШаблонОбработчика
Процедура ПриЗаполненииНастроекОбработчиковПравилРегистрации(Настройки) Экспорт
	ЗарплатаКадрыРасширенныйСинхронизацияДанных.ДляОтбораПоОрганизации(Настройки);
	ЗарплатаКадрыРасширенныйСинхронизацияДанных.ДляОбъектаСПрисоединеннымиФайлами(Настройки);
	ЗарплатаКадрыРасширенныйСинхронизацияДанных.ДляРегистрацииДвижений(Настройки);
	ЗарплатаКадрыРасширенныйСинхронизацияДанных.ДляСовместноРегистрируемыхОбъектов(Настройки);
КонецПроцедуры

#КонецОбласти

#Область ОбменДанными

// Регистрирует изменение организации или структурного подразделения для сотрудников и физических лиц
//
// Параметры:
//		МассивДокументов - Массив - Массив объектов заполненный при загрузке сообщения обмена
//
Процедура ЗарегистрироватьЗависимыеОбъектыПослеЗагрузкиОбменаДанными(МассивДокументов) Экспорт
	
	// Зарегистрируем сотрудников по виду документа, изменяющего принадлежность к организации
	Для Каждого ДокументОбъект Из МассивДокументов Цикл
		Если ЗначениеЗаполнено(ДокументОбъект.ГоловнойСотрудник) И ОбщегоНазначения.СсылкаСуществует(ДокументОбъект.ГоловнойСотрудник) Тогда
			ПланыОбмена.ЗарегистрироватьИзменения(ДокументОбъект.ОбменДанными.Получатели, ДокументОбъект.ГоловнойСотрудник);
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ДокументОбъект.СовмещающийСотрудник) И ОбщегоНазначения.СсылкаСуществует(ДокументОбъект.СовмещающийСотрудник) Тогда
			ПланыОбмена.ЗарегистрироватьИзменения(ДокументОбъект.ОбменДанными.Получатели, ДокументОбъект.СовмещающийСотрудник);
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ДокументОбъект.ОтсутствующийСотрудник) И ОбщегоНазначения.СсылкаСуществует(ДокументОбъект.ОтсутствующийСотрудник) Тогда
			ПланыОбмена.ЗарегистрироватьИзменения(ДокументОбъект.ОбменДанными.Получатели, ДокументОбъект.ОтсутствующийСотрудник);
		КонецЕсли;
		
		СинхронизацияДанныхЗарплатаКадры.ПринадлежностьФизлицаОрганизацииПриЗаписи(ДокументОбъект);
		СинхронизацияДанныхЗарплатаКадры.ОрганизацииСотрудниковПриЗаписи(ДокументОбъект);
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

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

#Область Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
КонецПроцедуры

#КонецОбласти	

// Функция возвращает структуру с описанием данного вида документа.
//
Функция ОписаниеДокумента() Экспорт 

	ОписаниеДокумента = ЗарплатаКадрыРасширенныйКлиентСервер.СтруктураОписанияДокумента();
	
	ОписаниеДокумента.КраткоеНазваниеИменительныйПадеж	 = НСтр("ru = 'подработка';
																	|en = 'side job'");
	ОписаниеДокумента.КраткоеНазваниеРодительныйПадеж	 = НСтр("ru = 'подработки';
																|en = 'side jobs'");
	ОписаниеДокумента.ИмяРеквизитаСотрудник				 = "ГоловнойСотрудник";
	ОписаниеДокумента.ИмяРеквизитаОтсутствующийСотрудник = "ОтсутствующийСотрудник";
	ОписаниеДокумента.ИмяРеквизитаДатаНачалаСобытия		 = "ДатаНачала";
	ОписаниеДокумента.ИмяРеквизитаДатаОкончанияСобытия	 = "ДатаОкончания";
	
	Возврат ОписаниеДокумента;

КонецФункции

Процедура ЗаполнитьДатуЗапретаРедактирования(ОбъектДокумента) Экспорт
	
	ЗарплатаКадры.ЗаполнитьДатуЗапретаРедактирования(ОбъектДокумента, "ДатаНачала");
	
КонецПроцедуры

Процедура ЗаполнитьДатыЗапрета(ПараметрыОбновления) Экспорт
	
	ОбновлениеВыполнено = Истина;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ ПЕРВЫЕ 100
		|	НазначениеПодработки.Ссылка КАК Ссылка,
		|	НазначениеПодработки.Дата КАК Дата
		|ИЗ
		|	Документ.НазначениеПодработки КАК НазначениеПодработки
		|ГДЕ
		|	НазначениеПодработки.ДатаЗапрета = ДАТАВРЕМЯ(1, 1, 1)
		|
		|УПОРЯДОЧИТЬ ПО
		|	НазначениеПодработки.Дата УБЫВ";
	
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

#КонецОбласти

#КонецЕсли
