#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

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
	
	МетаданныеДокумента = Метаданные.Документы.ИндексацияЗаработка;
	Возврат ЗарплатаКадрыСоставДокументов.ОписаниеСоставаОбъектаПоМетаданнымФизическиеЛицаВТабличныхЧастях(МетаданныеДокумента);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	Если ПолучитьФункциональнуюОпцию("ИспользоватьИндексациюЗаработка") Тогда
		// Приказ об индексации заработка.
		КомандаПечати = КомандыПечати.Добавить();
		КомандаПечати.Обработчик = "УправлениеПечатьюБЗККлиент.ВыполнитьКомандуПечати";
		КомандаПечати.МенеджерПечати = "Обработка.ПечатьКадровыхПриказовРасширенная";
		КомандаПечати.Идентификатор = "ПФ_MXL_ИндексацияЗаработка";
		КомандаПечати.Представление = НСтр("ru = 'Приказ об индексации заработка';
											|en = 'Wage indexation order'");
	КонецЕсли;	
КонецПроцедуры

Процедура ДобавитьКомандыСозданияДокументов(КомандыСозданияДокументов, ДополнительныеПараметры) Экспорт 
	
	Если Не ДополнительныеПараметры.Свойство("ИзменениеОплатыСотрудников")
		Или ДополнительныеПараметры.ИзменениеОплатыСотрудников = Ложь Тогда
		
		ЗарплатаКадрыРасширенный.ДобавитьВКоллекциюКомандуСозданияДокументаПоМетаданнымДокумента(
			КомандыСозданияДокументов, Метаданные.Документы.ИндексацияЗаработка);
		
	КонецЕсли;
		
КонецПроцедуры

#Область ЗаполнениеДокумента

Функция ИндексированныеЗначенияПоказателейСотрудников(ТекущиеПоказателиСотрудников, 
													КоэффициентИндексации, 
													ПоказателиСотрудниковВДокументе = Неопределено, 
													СпособыОкругленияПоказателей = Неопределено,
													ИндексацияВоеннослужащих = Ложь,
													ВидИндексацииГосударственныхСлужащих = Неопределено) Экспорт
	
	ЗначенияПоказателейСотрудников = Новый ТаблицаЗначений;
	ЗначенияПоказателейСотрудников.Колонки.Добавить("Сотрудник", Новый ОписаниеТипов("СправочникСсылка.Сотрудники"));
	ЗначенияПоказателейСотрудников.Колонки.Добавить("Показатель", Новый ОписаниеТипов("СправочникСсылка.ПоказателиРасчетаЗарплаты"));
	ЗначенияПоказателейСотрудников.Колонки.Добавить("ДокументОснование", Метаданные.ОпределяемыеТипы.ОснованиеНачисления.Тип);
	ЗначенияПоказателейСотрудников.Колонки.Добавить("Значение", Новый ОписаниеТипов("Число"));
	
	КоэффициентыИндексацииСотрудников = Новый ТаблицаЗначений;
	КоэффициентыИндексацииСотрудников.Колонки.Добавить("Сотрудник", Новый ОписаниеТипов("СправочникСсылка.Сотрудники"));
	КоэффициентыИндексацииСотрудников.Колонки.Добавить("КоэффициентИндексации", Новый ОписаниеТипов("Число"));
	КоэффициентыИндексацииСотрудников.Колонки.Добавить("ФиксСтрока", Новый ОписаниеТипов("Булево"));
	КоэффициентыИндексацииСотрудников.Колонки.Добавить("Счетчик", Новый ОписаниеТипов("Число"));
	
	Если СпособыОкругленияПоказателей = Неопределено Тогда
		СпособыОкругленияПоказателей = Новый ТаблицаЗначений;
		СпособыОкругленияПоказателей.Колонки.Добавить("Показатель");
		СпособыОкругленияПоказателей.Колонки.Добавить("СпособОкругления");
	КонецЕсли;
	
	ОписаниеОкругленияПоказателей = ИндексацияЗаработка.ОписаниеОкругленияПоказателей(СпособыОкругленияПоказателей);	
	
	Для каждого ПоказательСотрудника Из ТекущиеПоказателиСотрудников Цикл 
		
		КоэффициентИндексацииПоказателя = КоэффициентИндексации;
		Если ИндексацияВоеннослужащих И ЗначениеЗаполнено(ВидИндексацииГосударственныхСлужащих) Тогда
			Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ГосударственнаяСлужба.РасчетДенежногоДовольствия") Тогда
				Модуль = ОбщегоНазначения.ОбщийМодуль("РасчетДенежногоДовольствия");			
				КоэффициентИндексацииПоказателя = Модуль.КоэффициентИндексацииПоказателя(КоэффициентИндексацииПоказателя, ПоказательСотрудника.Показатель, ВидИндексацииГосударственныхСлужащих);
			КонецЕсли;
		КонецЕсли;
		
		ОписаниеОкругленияПоказателя = ОписаниеОкругленияПоказателей.Получить(ПоказательСотрудника.Показатель);
		
		НоваяСтрока = ЗначенияПоказателейСотрудников.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ПоказательСотрудника);
		
		ИндексированноеЗначение = ИндексацияЗаработка.ИндексированноеЗначениеПоказателя(НоваяСтрока.Значение, КоэффициентИндексацииПоказателя, ОписаниеОкругленияПоказателя);
		
		Если НоваяСтрока.Значение <> 0 Тогда
			КоэффициентИндексацииСотрудника  = ИндексированноеЗначение / НоваяСтрока.Значение;
			НоваяСтрока.Значение = ИндексированноеЗначение;
		Иначе
			КоэффициентИндексацииСотрудника  = КоэффициентИндексацииПоказателя;
		КонецЕсли;
		
		Если ПоказательСотрудника.ПоказательТарифнойСтавки = ПоказательСотрудника.Показатель 
			ИЛИ ЗначениеЗаполнено(ВидИндексацииГосударственныхСлужащих) Тогда
			НоваяСтрока = КоэффициентыИндексацииСотрудников.Добавить();
			НоваяСтрока.Сотрудник = ПоказательСотрудника.Сотрудник;
			НоваяСтрока.КоэффициентИндексации = КоэффициентИндексацииСотрудника;
			НоваяСтрока.Счетчик = 1;
		КонецЕсли;
	КонецЦикла; 
	
	// Сохраним данные которые пользователь мог отредактировать в документе.
	Если НЕ ПоказателиСотрудниковВДокументе = Неопределено Тогда
		ОтборПоказателя = Новый Структура("Сотрудник,Показатель");
		Для каждого ПоказательСотрудникаВДокументе Из ПоказателиСотрудниковВДокументе Цикл
				
			ОтборПоказателя.Вставить("Сотрудник", 	ПоказательСотрудникаВДокументе.Сотрудник);  
			ОтборПоказателя.Вставить("Показатель", 	ПоказательСотрудникаВДокументе.Показатель);  
			
			ЗначенияПоказателейСотрудника = ЗначенияПоказателейСотрудников.НайтиСтроки(ОтборПоказателя);
			
			Если ЗначенияПоказателейСотрудника.Количество() <> 0 Тогда
				ЗначенияПоказателейСотрудника[0].Значение = ПоказательСотрудникаВДокументе.Значение;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	КоэффициентыИндексацииСотрудников.Свернуть("Сотрудник,ФиксСтрока","КоэффициентИндексации,Счетчик");
	Для каждого СтрокаИндексации Из КоэффициентыИндексацииСотрудников Цикл
		СтрокаИндексации.КоэффициентИндексации = СтрокаИндексации.КоэффициентИндексации / СтрокаИндексации.Счетчик;
	КонецЦикла;
	
	Возврат Новый Структура("ЗначенияПоказателейСотрудников,КоэффициентыИндексацииСотрудников", ЗначенияПоказателейСотрудников, КоэффициентыИндексацииСотрудников);	
	
КонецФункции

Функция ОбъектыДляРасчетаФОТ(Ссылка, Организация, ДатаИндексации, НачисленияСотрудников, ЗначенияПоказателей, ВремяРегистрацииСотрудников = Неопределено)
	Если ВремяРегистрацииСотрудников = Неопределено Тогда
		СписокСотрудников = ОбщегоНазначения.ВыгрузитьКолонку(ЗначенияПоказателей, "Сотрудник", Истина);
		ВремяРегистрацииСотрудников = ЗарплатаКадрыРасширенный.ВремяРегистрацииСотрудниковДокумента(Ссылка, СписокСотрудников, ДатаИндексации);
	КонецЕсли;
	
	ГоловнаяОрганизация = ЗарплатаКадры.ГоловнаяОрганизация(Организация);
	ТаблицаНачислений = ПлановыеНачисленияСотрудников.ТаблицаНачисленийДляРасчетаВторичныхДанных();
	ТаблицаПоказателей = ПлановыеНачисленияСотрудников.ТаблицаИзвестныеПоказатели();
		
	Для Каждого СтрокаЗначенияПоказателей Из ЗначенияПоказателей Цикл
		ВремяРегистрации = ВремяРегистрацииСотрудников.Получить(СтрокаЗначенияПоказателей.Сотрудник);
				
		СтрокиНачислений = НачисленияСотрудников.НайтиСтроки(Новый Структура("Сотрудник", СтрокаЗначенияПоказателей.Сотрудник));
		Для Каждого СтрокаНачисления Из СтрокиНачислений Цикл
			Отбор = Новый Структура("Сотрудник, Начисление, ДокументОснование", СтрокаНачисления.Сотрудник, СтрокаНачисления.Начисление, СтрокаНачисления.ДокументОснование);
			Если ТаблицаНачислений.НайтиСтроки(Отбор).Количество() = 0 Тогда 
				ДанныеНачисления = ТаблицаНачислений.Добавить();
				ДанныеНачисления.Сотрудник = СтрокаЗначенияПоказателей.Сотрудник;
				ДанныеНачисления.ГоловнаяОрганизация = ГоловнаяОрганизация;
				ДанныеНачисления.Период = ВремяРегистрации;
				ДанныеНачисления.Начисление = СтрокаНачисления.Начисление;
				ДанныеНачисления.ДокументОснование = СтрокаНачисления.ДокументОснование;
				ДанныеНачисления.Размер = СтрокаНачисления.Размер;
			КонецЕсли;
		КонецЦикла;
		
		ДанныеПоказателя = ТаблицаПоказателей.Добавить();
		ДанныеПоказателя.Сотрудник = СтрокаЗначенияПоказателей.Сотрудник;
		ДанныеПоказателя.ГоловнаяОрганизация = ГоловнаяОрганизация;
		ДанныеПоказателя.Период = ВремяРегистрации;
		ДанныеПоказателя.Показатель = СтрокаЗначенияПоказателей.Показатель;
		ДанныеПоказателя.ДокументОснование = СтрокаЗначенияПоказателей.ДокументОснование;
		ДанныеПоказателя.Значение = СтрокаЗначенияПоказателей.Значение;		
	КонецЦикла;
	
	ОбъектыДляРасчетаФОТ = Новый Структура("ТаблицаНачислений, ТаблицаПоказателей", ТаблицаНачислений, ТаблицаПоказателей);
	
	Возврат ОбъектыДляРасчетаФОТ;
	
КонецФункции
	
Процедура РассчитатьФОТ(Знач Ссылка, Знач Организация, Знач ДатаИндексации, НачисленияСотрудников, Знач ЗначенияПоказателей, ТарифныеСтавкиСотрудников, ВремяРегистрацииСотрудников = Неопределено) Экспорт	
	ОбъектыДляРасчетаФОТ = ОбъектыДляРасчетаФОТ(Ссылка, Организация, ДатаИндексации, НачисленияСотрудников, ЗначенияПоказателей, ВремяРегистрацииСотрудников);
	
	РассчитанныеДанные = ПлановыеНачисленияСотрудников.РассчитатьВторичныеДанныеПлановыхНачислений(ОбъектыДляРасчетаФОТ.ТаблицаНачислений, ОбъектыДляРасчетаФОТ.ТаблицаПоказателей);	
	ПеренестиРезультатыРасчетаФОТ(Ссылка, НачисленияСотрудников, РассчитанныеДанные.ПлановыйФОТ);
	
	Для Каждого СтрокаТарифнойСтавки Из РассчитанныеДанные.ТарифныеСтавки Цикл
		НайденныеСтроки = ТарифныеСтавкиСотрудников.НайтиСтроки(Новый Структура("Сотрудник", СтрокаТарифнойСтавки.Сотрудник));
		
		Если НайденныеСтроки.Количество() > 0 Тогда
			НайденныеСтроки[0].ВидТарифнойСтавки = СтрокаТарифнойСтавки.ВидТарифнойСтавки;
			НайденныеСтроки[0].СовокупнаяТарифнаяСтавка = СтрокаТарифнойСтавки.СовокупнаяТарифнаяСтавка;
		Иначе
			СтрокаТаблицы = ТарифныеСтавкиСотрудников.Добавить();
			СтрокаТаблицы.Сотрудник = СтрокаТарифнойСтавки.Сотрудник;
			СтрокаТаблицы.ВидТарифнойСтавки = СтрокаТарифнойСтавки.ВидТарифнойСтавки;
			СтрокаТаблицы.СовокупнаяТарифнаяСтавка = СтрокаТарифнойСтавки.СовокупнаяТарифнаяСтавка;
		КонецЕсли;
	КонецЦикла;	
	
КонецПроцедуры

Процедура ПеренестиРезультатыРасчетаФОТ(Ссылка, НачисленияСотрудников, ПлановыйФОТ)
		
	Для Каждого НачислениеСотрудника Из НачисленияСотрудников Цикл
		
		Отбор = Новый Структура("Сотрудник, Начисление, ДокументОснование", НачислениеСотрудника.Сотрудник, НачислениеСотрудника.Начисление, НачислениеСотрудника.ДокументОснование);
		СтрокиНачисления = ПлановыйФОТ.НайтиСтроки(Отбор);
			
		Если СтрокиНачисления.Количество() > 0 Тогда 
			НачислениеСотрудника.Размер = СтрокиНачисления[0].ВкладВФОТ;
		КонецЕсли;
		 
	КонецЦикла;
	
КонецПроцедуры

Функция СотрудникиДляИндексации(Организация, Подразделение, ДатаИндексации, ИндексацияГосслужащих = Ложь, ИндексацияВоеннослужащих = Ложь, ПозицииШтатногоРасписанияДляОтбора = Неопределено) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Параметры = КадровыйУчет.ПараметрыПолученияСотрудниковОрганизацийПоСпискуФизическихЛиц();
	Параметры.Организация 		= Организация;
	Если ЗначениеЗаполнено(Подразделение) Тогда
		Параметры.Подразделение 	= Подразделение;
	КонецЕсли;
	Параметры.НачалоПериода 	= ДатаИндексации;
	Параметры.ОкончаниеПериода 	= ДатаИндексации;
	
	Если ИндексацияГосслужащих Тогда
				
		Если ИндексацияВоеннослужащих Тогда
			ВидыДоговоров = Перечисления.ВидыДоговоровССотрудниками.ВидыДоговоровВоеннойСлужбы();	
		Иначе
			Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ГосударственнаяСлужба") Тогда
				Модуль = ОбщегоНазначения.ОбщийМодуль("ГосударственнаяСлужба");			
				ВидыДоговоров = Модуль.ВидыДоговоровГосударственнойСлужбы();
			КонецЕсли;
		КонецЕсли;
		
		ЗарплатаКадрыОбщиеНаборыДанных.ДобавитьВКоллекциюОтбор(Параметры.Отборы, "ВидДоговора", "В", ВидыДоговоров);
	Иначе 
		Если ТипЗнч(ПозицииШтатногоРасписанияДляОтбора)=Тип("Массив") И ПозицииШтатногоРасписанияДляОтбора.Количество()>0 Тогда
			ЗарплатаКадрыОбщиеНаборыДанных.ДобавитьВКоллекциюОтбор(Параметры.Отборы, "ДолжностьПоШтатномуРасписанию", "В", ПозицииШтатногоРасписанияДляОтбора);
		КонецЕсли;
	КонецЕсли;	
	
	КадровыйУчетРасширенный.ПрименитьОтборПоФункциональнойОпцииВыполнятьРасчетЗарплатыПоПодразделениям(Параметры);
	
	Возврат КадровыйУчет.СотрудникиОрганизации(Истина, Параметры).ВыгрузитьКолонку("Сотрудник");
	                                                              
КонецФункции

Функция НачисленияСотрудников(Ссылка, ДатаИндексации, СписокСотрудников, ВремяРегистрацииСотрудников = Неопределено) Экспорт
	
	Если ВремяРегистрацииСотрудников = Неопределено Тогда 
		ВремяРегистрацииСотрудников = ЗарплатаКадрыРасширенный.ВремяРегистрацииСотрудниковДокумента(Ссылка, СписокСотрудников, ДатаИндексации);
	КонецЕсли;
	
	СотрудникиДаты = Новый ТаблицаЗначений;
	СотрудникиДаты.Колонки.Добавить("Сотрудник", Новый ОписаниеТипов("СправочникСсылка.Сотрудники"));
	СотрудникиДаты.Колонки.Добавить("Период", Новый ОписаниеТипов("Дата"));
	
	Для Каждого Сотрудник Из СписокСотрудников Цикл 
		НоваяСтрока = СотрудникиДаты.Добавить();
		НоваяСтрока.Сотрудник = Сотрудник;
		НоваяСтрока.Период = ВремяРегистрацииСотрудников.Получить(Сотрудник);
	КонецЦикла;
	
	Запрос = Новый Запрос;
	
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("СотрудникиДаты", СотрудникиДаты);
	
	Запрос.Текст = "ВЫБРАТЬ РАЗЛИЧНЫЕ
	               |	СотрудникиДаты.Период,
	               |	СотрудникиДаты.Сотрудник
	               |ПОМЕСТИТЬ ВТИзмеренияДаты
	               |ИЗ
	               |	&СотрудникиДаты КАК СотрудникиДаты";
				   
	Запрос.Выполнить();			   
	
	ПараметрыПостроения = ЗарплатаКадрыОбщиеНаборыДанных.ПараметрыПостроенияДляСоздатьВТИмяРегистраСрез();
	ПараметрыПостроения.ФормироватьСПериодичностьДень = Ложь;
	ПараметрыПостроенияФОТ = ЗарплатаКадрыОбщиеНаборыДанных.ПараметрыПостроенияДляСоздатьВТИмяРегистраСрез();
	ПараметрыПостроенияФОТ.ФормироватьСПериодичностьДень = Ложь;
	
	ЗарплатаКадрыОбщиеНаборыДанных.ДобавитьВКоллекциюОтбор(ПараметрыПостроения.Отборы, "Регистратор", "<>", Ссылка);
	
	ЗарплатаКадрыОбщиеНаборыДанных.СоздатьВТИмяРегистраСрезПоследних(
		"ПлановыеНачисления",
		Запрос.МенеджерВременныхТаблиц,
		Истина,
		ЗарплатаКадрыОбщиеНаборыДанных.ОписаниеФильтраДляСоздатьВТИмяРегистра("ВТИзмеренияДаты", "Сотрудник"),
		ПараметрыПостроения);

	ЗарплатаКадрыОбщиеНаборыДанных.СоздатьВТИмяРегистраСрезПоследних(
		"ПлановыйФОТ",
		Запрос.МенеджерВременныхТаблиц,
		Истина,
		ЗарплатаКадрыОбщиеНаборыДанных.ОписаниеФильтраДляСоздатьВТИмяРегистра("ВТИзмеренияДаты", "Сотрудник"),
		ПараметрыПостроенияФОТ);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ПлановыеНачисления.Сотрудник,
	|	ПлановыеНачисления.Начисление,
	|	ПлановыеНачисления.ДокументОснование,
	|	ВЫБОР
	|		КОГДА ПлановыйФОТ.ВкладВФОТ ЕСТЬ NULL 
	|			ТОГДА ПлановыеНачисления.Размер
	|		ИНАЧЕ ПлановыйФОТ.ВкладВФОТ
	|	КОНЕЦ КАК Размер,
	|	ВЫРАЗИТЬ(ПлановыеНачисления.Начисление КАК ПланВидовРасчета.Начисления).РеквизитДопУпорядочивания КАК Порядок
	|ИЗ
	|	ВТПлановыеНачисленияСрезПоследних КАК ПлановыеНачисления
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТПлановыйФОТСрезПоследних КАК ПлановыйФОТ
	|		ПО ПлановыеНачисления.Сотрудник = ПлановыйФОТ.Сотрудник
	|			И ПлановыеНачисления.Начисление = ПлановыйФОТ.Начисление
	|			И ПлановыеНачисления.ДокументОснование = ПлановыйФОТ.ДокументОснование
	|ГДЕ
	|	НЕ ВЫРАЗИТЬ(ПлановыеНачисления.Начисление КАК ПланВидовРасчета.Начисления).КатегорияНачисленияИлиНеоплаченногоВремени В (ЗНАЧЕНИЕ(Перечисление.КатегорииНачисленийИНеоплаченногоВремени.ПособиеПоУходуЗаРебенкомДоПолутораЛет), ЗНАЧЕНИЕ(Перечисление.КатегорииНачисленийИНеоплаченногоВремени.ПособиеПоУходуЗаРебенкомДоТрехЛет))
	|	И ПлановыеНачисления.Используется
	|
	|УПОРЯДОЧИТЬ ПО
	|	Порядок";
	
	НачисленияСотрудников = Запрос.Выполнить().Выгрузить();
	
	Возврат НачисленияСотрудников;
	
КонецФункции 

Функция ТекущиеПоказателиСотрудников(Ссылка, МассивПоказателей, ДатаИндексации, МассивСотрудников, ВремяРегистрацииСотрудников = Неопределено) Экспорт
	
	Если ВремяРегистрацииСотрудников = Неопределено Тогда 
		ВремяРегистрацииСотрудников = ЗарплатаКадрыРасширенный.ВремяРегистрацииСотрудниковДокумента(Ссылка, МассивСотрудников, ДатаИндексации);
	КонецЕсли;
	
	СотрудникиДаты = Новый ТаблицаЗначений;
	СотрудникиДаты.Колонки.Добавить("Сотрудник", Новый ОписаниеТипов("СправочникСсылка.Сотрудники"));
	СотрудникиДаты.Колонки.Добавить("Период", Новый ОписаниеТипов("Дата"));
	
	Для Каждого Сотрудник Из МассивСотрудников Цикл 
		НоваяСтрока = СотрудникиДаты.Добавить();
		НоваяСтрока.Сотрудник = Сотрудник;
		НоваяСтрока.Период = ВремяРегистрацииСотрудников.Получить(Сотрудник);
	КонецЦикла;
	
	Запрос = Новый Запрос;
	
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("СотрудникиДаты", СотрудникиДаты);
	
	Запрос.Текст = "ВЫБРАТЬ РАЗЛИЧНЫЕ
	               |	СотрудникиДаты.Период,
	               |	СотрудникиДаты.Сотрудник
	               |ПОМЕСТИТЬ ВТСотрудникиПериоды
	               |ИЗ
	               |	&СотрудникиДаты КАК СотрудникиДаты";
				   
	Запрос.Выполнить();			   
	
	ОписательВременныхТаблиц = КадровыйУчет.ОписательВременныхТаблицДляСоздатьВТКадровыеДанныеСотрудников(Запрос.МенеджерВременныхТаблиц, "ВТСотрудникиПериоды");
	КадровыеДанные = "Организация,ПоказательТарифнойСтавки";
	ЗарплатаКадры.ДополнитьКадровымиДаннымиНастройкиПорядкаСписка(КадровыеДанные);
	КадровыйУчет.СоздатьВТКадровыеДанныеСотрудников(ОписательВременныхТаблиц, Истина, КадровыеДанные);
																				   
	Запрос.Текст = "ВЫБРАТЬ
	               |	Сотрудники.Период КАК Период,
	               |	Сотрудники.Сотрудник КАК Сотрудник,
				   |	Сотрудники.Организация КАК Организация
	               |ИЗ
	               |	ВТКадровыеДанныеСотрудников КАК Сотрудники";
				   
	СотрудникиДаты = Запрос.Выполнить().Выгрузить();
	
	// Получаем текущие начисления и показатели по сотрудникам.
	ПараметрыПостроения = ЗарплатаКадрыОбщиеНаборыДанных.ПараметрыПостроенияДляСоздатьВТИмяРегистраСрез();
	ПараметрыПостроения.ФормироватьСПериодичностьДень = Ложь;
	
	ЗарплатаКадрыОбщиеНаборыДанных.ДобавитьВКоллекциюОтбор(ПараметрыПостроения.Отборы, "Регистратор", "<>", Ссылка);

	ЗарплатаКадрыОбщиеНаборыДанных.СоздатьВТИмяРегистраСрезПоследних(
		"ПлановыеНачисления",
		Запрос.МенеджерВременныхТаблиц,
		Истина,
		ЗарплатаКадрыОбщиеНаборыДанных.ОписаниеФильтраДляСоздатьВТИмяРегистра(СотрудникиДаты),
		ПараметрыПостроения);
	
	ЗарплатаКадрыОбщиеНаборыДанных.ДобавитьВКоллекциюОтбор(ПараметрыПостроения.Отборы, "Показатель", "В", МассивПоказателей);
	
	ЗарплатаКадрыОбщиеНаборыДанных.СоздатьВТИмяРегистраСрезПоследних(
		"ЗначенияПериодическихПоказателейРасчетаЗарплатыСотрудников",
		Запрос.МенеджерВременныхТаблиц,
		Истина,
		ЗарплатаКадрыОбщиеНаборыДанных.ОписаниеФильтраДляСоздатьВТИмяРегистра(СотрудникиДаты),
		ПараметрыПостроения);
	
	ЗарплатаКадрыОбщиеНаборыДанных.СоздатьВТИмяРегистраСрезПоследних(
		"ПрименениеДополнительныхПериодическихПоказателейРасчетаЗарплатыСотрудников",
		Запрос.МенеджерВременныхТаблиц,
		Истина,
		ЗарплатаКадрыОбщиеНаборыДанных.ОписаниеФильтраДляСоздатьВТИмяРегистра(СотрудникиДаты),
		ПараметрыПостроения);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ДействующиеНачисления.Сотрудник КАК Сотрудник,
	|	НачисленияПоказатели.Показатель КАК Показатель,
	|	ЗначенияПериодическихПоказателей.Значение КАК Значение,
	|	ЗначенияПериодическихПоказателей.ДокументОснование КАК ДокументОснование
	|ПОМЕСТИТЬ ДанныеЗаполнения
	|ИЗ
	|	ВТПлановыеНачисленияСрезПоследних КАК ДействующиеНачисления
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ПланВидовРасчета.Начисления.Показатели КАК НачисленияПоказатели
	|		ПО ДействующиеНачисления.Начисление = НачисленияПоказатели.Ссылка
	|			И (ДействующиеНачисления.Используется)
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТЗначенияПериодическихПоказателейРасчетаЗарплатыСотрудниковСрезПоследних КАК ЗначенияПериодическихПоказателей
	|		ПО (ЗначенияПериодическихПоказателей.Показатель = НачисленияПоказатели.Показатель)
	|			И (ЗначенияПериодическихПоказателей.Сотрудник = ДействующиеНачисления.Сотрудник)
	|ГДЕ
	|	ДействующиеНачисления.Используется
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ПрименениеДополнительныхПоказателей.Сотрудник,
	|	ПрименениеДополнительныхПоказателей.Показатель,
	|	ЗначенияПериодическихПоказателей.Значение,
	|	NULL
	|ИЗ
	|	ВТПрименениеДополнительныхПериодическихПоказателейРасчетаЗарплатыСотрудниковСрезПоследних КАК ПрименениеДополнительныхПоказателей
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТЗначенияПериодическихПоказателейРасчетаЗарплатыСотрудниковСрезПоследних КАК ЗначенияПериодическихПоказателей
	|		ПО (ЗначенияПериодическихПоказателей.Показатель = ПрименениеДополнительныхПоказателей.Показатель)
	|			И (ЗначенияПериодическихПоказателей.Сотрудник = ПрименениеДополнительныхПоказателей.Сотрудник)
	|ГДЕ
	|	ПрименениеДополнительныхПоказателей.Применение
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	СотрудникиОрганизации.Сотрудник КАК Сотрудник,
	|	СотрудникиОрганизации.ПоказательТарифнойСтавки КАК ПоказательТарифнойСтавки,
	|	ЕСТЬNULL(ДанныеЗаполнения.Показатель, ЗНАЧЕНИЕ(Справочник.ПоказателиРасчетаЗарплаты.ПустаяСсылка)) КАК Показатель,
	|	ЕСТЬNULL(ДанныеЗаполнения.Значение, 0) КАК Значение,
	|	ЕСТЬNULL(ДанныеЗаполнения.ДокументОснование, НЕОПРЕДЕЛЕНО) КАК ДокументОснование
	|ИЗ
	|	ВТКадровыеДанныеСотрудников КАК СотрудникиОрганизации
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ДанныеЗаполнения КАК ДанныеЗаполнения
	|		ПО СотрудникиОрганизации.Сотрудник = ДанныеЗаполнения.Сотрудник";
	
	ЗарплатаКадры.ДополнитьТекстЗапросаУпорядочиваниемСотрудниковПоВТСДаннымиПорядка(Запрос, "СотрудникиОрганизации");
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции 

Функция ТекущиеЗначенияСовокупныхТарифныхСтавокСотрудников(Ссылка, ДатаДокумента, МассивСотрудников, ВремяРегистрацииСотрудников = Неопределено) Экспорт
	
	Если ВремяРегистрацииСотрудников = Неопределено Тогда 
		ВремяРегистрацииСотрудников = ЗарплатаКадрыРасширенный.ВремяРегистрацииСотрудниковДокумента(Ссылка, МассивСотрудников, ДатаДокумента);
	КонецЕсли;
	
	СотрудникиДаты = Новый ТаблицаЗначений;
	СотрудникиДаты.Колонки.Добавить("Сотрудник", Новый ОписаниеТипов("СправочникСсылка.Сотрудники"));
	СотрудникиДаты.Колонки.Добавить("Период", Новый ОписаниеТипов("Дата"));
	
	Для Каждого Сотрудник Из МассивСотрудников Цикл 
		НоваяСтрока = СотрудникиДаты.Добавить();
		НоваяСтрока.Сотрудник = Сотрудник;
		НоваяСтрока.Период = ВремяРегистрацииСотрудников.Получить(Сотрудник);
	КонецЦикла;
	
	Запрос = Новый Запрос;
	
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("СотрудникиДаты", СотрудникиДаты);
	
	Запрос.Текст = "ВЫБРАТЬ РАЗЛИЧНЫЕ
	               |	СотрудникиДаты.Период,
	               |	СотрудникиДаты.Сотрудник
	               |ПОМЕСТИТЬ ВТИзмеренияДаты
	               |ИЗ
	               |	&СотрудникиДаты КАК СотрудникиДаты";
				   
	Запрос.Выполнить();
	
	ПараметрыПостроения = ЗарплатаКадрыОбщиеНаборыДанных.ПараметрыПостроенияДляСоздатьВТИмяРегистраСрез();
	ПараметрыПостроения.ФормироватьСПериодичностьДень = Ложь;
	
	ЗарплатаКадрыОбщиеНаборыДанных.ДобавитьВКоллекциюОтбор(ПараметрыПостроения.Отборы, "Регистратор", "<>", Ссылка);
	
	ЗарплатаКадрыОбщиеНаборыДанных.СоздатьВТИмяРегистраСрезПоследних(
		"ПлановыйФОТИтоги",
		Запрос.МенеджерВременныхТаблиц,
		Истина,
		ЗарплатаКадрыОбщиеНаборыДанных.ОписаниеФильтраДляСоздатьВТИмяРегистра(
			"ВТИзмеренияДаты",
			"Сотрудник"),
		ПараметрыПостроения);
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	ЗначенияСовокупныхТарифныхСтавок.Сотрудник,
	               |	ЗначенияСовокупныхТарифныхСтавок.СовокупнаяТарифнаяСтавка КАК СовокупнаяТарифнаяСтавка,
	               |	ЗначенияСовокупныхТарифныхСтавок.ВидТарифнойСтавки
	               |ИЗ
	               |	ВТПлановыйФОТИтогиСрезПоследних КАК ЗначенияСовокупныхТарифныхСтавок
	               |ГДЕ
	               |	ЗначенияСовокупныхТарифныхСтавок.СовокупнаяТарифнаяСтавка <> 0";
				   
	ЗначенияСовокупныхТарифныхСтавок = Запрос.Выполнить().Выгрузить();			   
	
	Возврат ЗначенияСовокупныхТарифныхСтавок;
	
КонецФункции

#КонецОбласти

Процедура РассчитатьФОТПоДокументу(ДокументОбъект) Экспорт
	
	// Расчет ФОТ
	РассчитываемыеОбъекты = ОбъектыДляРасчетаФОТ(ДокументОбъект.Ссылка, ДокументОбъект.Организация, ДокументОбъект.МесяцИндексации, ДокументОбъект.НачисленияСотрудников, ДокументОбъект.ЗначенияПоказателей);
	РассчитанныеДанные = ПлановыеНачисленияСотрудников.РассчитатьВторичныеДанныеПлановыхНачислений(РассчитываемыеОбъекты.ТаблицаНачислений, РассчитываемыеОбъекты.ТаблицаПоказателей);	
	ПеренестиРезультатыРасчетаФОТ(ДокументОбъект.Ссылка, ДокументОбъект.НачисленияСотрудников, РассчитанныеДанные.ПлановыйФОТ);
	
	РасчетЗарплатыРасширенный.ЗаполнитьФОТВДвиженияхЗагружаемогоДокумента(ДокументОбъект.Движения.ПлановыеНачисления, ДокументОбъект.НачисленияСотрудников, "Сотрудник");
	
	// Совокупные тарифные ставки
	СовокупныеСтавкиОбъектов = РассчитанныеДанные.ТарифныеСтавки;
	
	КоллекцияОбъектов = Неопределено;
	РасчетЗарплатыРасширенный.ДобавитьВКоллекциюОписаниеОбъектаДляЗаполненияСовокупныхТарифныхСтавок(КоллекцияОбъектов, ДокументОбъект.Ссылка, ДокументОбъект.ПересчетТарифныхСтавок);
	
	РасчетЗарплатыРасширенный.ЗаполнитьСовокупныеТарифныеСтавкиСотрудниковКоллекции(КоллекцияОбъектов, СовокупныеСтавкиОбъектов, "Сотрудник");
	
	РасчетЗарплатыРасширенный.ЗаполнитьСовокупныеТарифныеСтавкиВДвиженияхЗагружаемогоДокумента(ДокументОбъект, ДокументОбъект.ПересчетТарифныхСтавок, "Сотрудник");
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли