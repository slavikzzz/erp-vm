#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

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
	
	Возврат Документы.КадровыйПеревод.СторнироватьПоУчетам(Движения, Регистратор, ИсправленныйДокумент, СтруктураВидовУчета, ДополнительныеПараметры);
	
КонецФункции

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ДляВсехСтрок( ЗначениеРазрешено(Сотрудники.ФизическоеЛицо, NULL КАК ИСТИНА)
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
	ОписаниеРаздела.РеквизитСостояние = "НачисленияУтверждены";	
	ОписаниеРаздела.ТребуетсяУтверждениеПриПроведении = Истина;
	ОписаниеРаздела.СообщениеДокументНеУтвержден =  НСтр("ru = '%1 - ежемесячные начисления не установлены.';
														|en = '%1 - monthly accruals are not specified.'");
	
	Возврат ОписаниеРазделовДанных;
КонецФункции

// Описание - возвращает структуру со значениями по которым будут проверяться права на разделы документа
// 				 
// Параметры:
//  ДокументОбъект - ДокументОбъект.КадровыйПереводСписком, ДанныеФормыСтруктура - объект или данные формы, 
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
	
	МетаданныеДокумента = Метаданные.Документы.КадровыйПереводСписком;
	Возврат ЗарплатаКадрыСоставДокументов.ОписаниеСоставаОбъектаПоМетаданнымФизическиеЛицаВТабличныхЧастях(МетаданныеДокумента);
	
КонецФункции

// Описывает реквизит документы, в котором хранится ссылка на кадровое решение. 
Функция ОписаниеРеквизитаКадровогоРешения() Экспорт
	Возврат Метаданные.Документы.КадровыйПереводСписком.ТабличныеЧасти.Сотрудники.Реквизиты.Решение;
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
		Для Каждого СтрокаДокумента Из ДокументОбъект.Сотрудники Цикл
			Если ЗначениеЗаполнено(СтрокаДокумента.Сотрудник) И ОбщегоНазначения.СсылкаСуществует(СтрокаДокумента.Сотрудник) Тогда
				ПланыОбмена.ЗарегистрироватьИзменения(ДокументОбъект.ОбменДанными.Получатели, СтрокаДокумента.Сотрудник);
			КонецЕсли;
		КонецЦикла;
		
		СинхронизацияДанныхЗарплатаКадры.ПринадлежностьФизлицаОрганизацииПриЗаписи(ДокументОбъект);
		
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

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

Функция ДобавитьКомандыСозданияДокументов(КомандыСозданияДокументов, ДополнительныеПараметры) Экспорт
	
	ЗарплатаКадрыРасширенный.ДобавитьВКоллекциюКомандуСозданияДокументаПоМетаданнымДокумента(
		КомандыСозданияДокументов, Метаданные.Документы.КадровыйПереводСписком);
	
КонецФункции

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	ИдентификаторыПФ = Новый Массив;
	
	Если Пользователи.РолиДоступны("ДобавлениеИзменениеДанныхДляНачисленияЗарплаты,ЧтениеДанныхДляНачисленияЗарплаты", , Ложь) Тогда
		
		// Бронирование позиции
		КомандаПечати = КомандыПечати.Добавить();
		КомандаПечати.Обработчик = "УправлениеПечатьюБЗККлиент.ВыполнитьКомандуПечати";
		КомандаПечати.МенеджерПечати = "Обработка.ПечатьКадровыхПриказовРасширенная";
		КомандаПечати.Идентификатор = "ПФ_MXL_ПодтверждениеБронированияПозиции";
		КомандаПечати.Представление = НСтр("ru = 'Подтверждение брони';
											|en = 'Reservation confirmation'");
		КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
		КомандаПечати.ФункциональныеОпции = "ИспользоватьБронированиеПозиций";
		
		ЗарплатаКадры.ДобавитьИдентификаторКомандыДляПечатиВПакетномРежиме(ИдентификаторыПФ, КомандаПечати);
		
	КонецЕсли;
	
	// Приказ о переводе
	Если ПравоДоступа("Просмотр", Метаданные.Отчеты.ПечатнаяФормаТ5а) Тогда
		
		КомандаПечати = КомандыПечати.Добавить();
		КомандаПечати.Обработчик = "УправлениеПечатьюБЗККлиент.ВыполнитьКомандуПечати";
		КомандаПечати.МенеджерПечати = "Отчет.ПечатнаяФормаТ5а";
		КомандаПечати.Идентификатор = "ПФ_MXL_Т5а";
		КомандаПечати.Представление = НСтр("ru = 'Приказ о переводе (Т-5а)';
											|en = 'Transfer order (T-5a)'");
		КомандаПечати.ДополнительныеПараметры.Вставить("ТребуетсяЧтениеБезОграничений", Истина);
		КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
		
		ЗарплатаКадры.ДобавитьИдентификаторКомандыДляПечатиВПакетномРежиме(ИдентификаторыПФ, КомандаПечати);
		
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.КадровыйУчет.ДистанционнаяРабота") Тогда
		МодульДистанционнаяРабота = ОбщегоНазначения.ОбщийМодуль("ДистанционнаяРабота");
		МодульДистанционнаяРабота.ДобавитьКомандыПечатиПереводаНаДистанционнуюРаботу(КомандыПечати, Истина, ИдентификаторыПФ);
	КонецЕсли;
	
	// Настраиваемый комплект документов
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Обработчик = "УправлениеПечатьюБЗККлиент.ВыполнитьКомандуПечати";
	КомандаПечати.Идентификатор = СтрСоединить(ИдентификаторыПФ, ",");
	КомандаПечати.Порядок = 900;
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	КомандаПечати.ДополнитьКомплектВнешнимиПечатнымиФормами = Истина;
	КомандаПечати.Представление = НСтр("ru = 'Комплект документов при кадровом переводе';
										|en = 'A set of documents for employee transfer'");
	КомандаПечати.ДополнительныеПараметры.Вставить("ТребуетсяЧтениеБезОграничений", Истина);
	КомандаПечати.Картинка = БиблиотекаКартинок.ПечатьПакетаДокументов;
	
КонецПроцедуры

Функция ДанныеДляРегистрацииВУчетаСтажаПФР(МассивСсылок) Экспорт
	
	ДанныеДляРегистрацииВУчете = Новый Соответствие;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("МассивСсылок", МассивСсылок);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	КадровыйПеревод.Ссылка КАК Ссылка,
	|	КадровыйПеревод.Сотрудник КАК Сотрудник,
	|	КадровыйПеревод.ДатаНачала КАК ДатаНачала,
	|	КадровыйПеревод.ДатаОкончания КАК ДатаОкончания,
	|	КадровыйПеревод.Подразделение КАК Подразделение,
	|	КадровыйПеревод.ОбособленноеПодразделение КАК Организация,
	|	КадровыйПеревод.Должность КАК Должность,
	|	КадровыйПеревод.ДолжностьПоШтатномуРасписанию КАК ДолжностьПоШтатномуРасписанию,
	|	КадровыйПеревод.ВидЗанятости КАК ВидЗанятости,
	|	КадровыйПеревод.КоличествоСтавок КАК КоличествоСтавок,
	|	КадровыйПеревод.ГрафикРаботы КАК ГрафикРаботы,
	|	КадровыйПеревод.ИзменитьПодразделениеИДолжность КАК ИзменитьПодразделениеИДолжность,
	|	КадровыйПеревод.ИзменитьГрафикРаботы КАК ИзменитьГрафикРаботы,
	|	КадровыйПеревод.НаПериодПереводаСохранятьЛьготныйСтажПФР КАК НаПериодПереводаСохранятьЛьготныйСтажПФР,
	|	КадровыйПеревод.ВидСтажаПФР КАК ВидСтажаПФР,
	|	КадровыйПеревод.ИзменитьТерриторию КАК ИзменитьТерриторию
	|ИЗ
	|	Документ.КадровыйПереводСписком.Сотрудники КАК КадровыйПеревод
	|ГДЕ
	|	КадровыйПеревод.Ссылка В(&МассивСсылок)";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		ДанныеДляРегистрацииВУчетеПоДокументу = УчетСтажаПФР.ДанныеДляРегистрацииВУчетеСтажаПФР();
		ДанныеДляРегистрацииВУчете.Вставить(Выборка.Ссылка, ДанныеДляРегистрацииВУчетеПоДокументу); 
		
		ОписаниеПериода = УчетСтажаПФР.ОписаниеРегистрируемогоПериода();
		ОписаниеПериода.Сотрудник = Выборка.Сотрудник;
		ОписаниеПериода.ДатаНачалаПериода = Выборка.ДатаНачала;
		ОписаниеПериода.ДатаОкончанияПериода = Выборка.ДатаОкончания;
		ОписаниеПериода.Состояние = Перечисления.СостоянияСотрудника.Перемещение;
		ОписаниеПериода.ВидЗанятости = Выборка.ВидЗанятости;
		
		РегистрируемыйПериод = УчетСтажаПФР.ДобавитьЗаписьВДанныеДляРегистрацииВУчета(ДанныеДляРегистрацииВУчетеПоДокументу, ОписаниеПериода);
		
		Если Выборка.НаПериодПереводаСохранятьЛьготныйСтажПФР Тогда
			
			Если Выборка.ИзменитьПодразделениеИДолжность Тогда
				УчетСтажаПФР.УстановитьЗначениеРегистрируемогоРесурса(РегистрируемыйПериод, "Организация", Выборка.Организация);
				УчетСтажаПФР.УстановитьЗначениеРегистрируемогоРесурса(РегистрируемыйПериод, "Подразделение", Выборка.Подразделение);
			КонецЕсли;
				
			Если Выборка.ИзменитьТерриторию Тогда
				УчетСтажаПФР.УстановитьЗначениеРегистрируемогоРесурса(РегистрируемыйПериод, "Территория", Выборка.Территория);
			КонецЕсли;
				
			УчетСтажаПФР.УстановитьЗначениеРегистрируемогоРесурса(РегистрируемыйПериод, "ВидСтажаПФР", Выборка.ВидСтажаПФР);
			
		Иначе
			
			Если Выборка.ИзменитьПодразделениеИДолжность Тогда
				
				УчетСтажаПФР.УстановитьЗначениеРегистрируемогоРесурса(РегистрируемыйПериод, "Должность", Выборка.Должность);
				УчетСтажаПФР.УстановитьЗначениеРегистрируемогоРесурса(РегистрируемыйПериод, "ДолжностьПоШтатномуРасписанию", Выборка.ДолжностьПоШтатномуРасписанию);
				УчетСтажаПФР.УстановитьЗначениеРегистрируемогоРесурса(РегистрируемыйПериод, "КоличествоСтавок", Выборка.КоличествоСтавок);
				УчетСтажаПФР.УстановитьЗначениеРегистрируемогоРесурса(РегистрируемыйПериод, "Организация", Выборка.Организация);
				УчетСтажаПФР.УстановитьЗначениеРегистрируемогоРесурса(РегистрируемыйПериод, "Подразделение", Выборка.Подразделение);
				
			КонецЕсли;
				
			Если Выборка.ИзменитьТерриторию Тогда
				УчетСтажаПФР.УстановитьЗначениеРегистрируемогоРесурса(РегистрируемыйПериод, "Территория", Выборка.Территория);
			КонецЕсли;
			
			Если Выборка.ИзменитьГрафикРаботы Тогда
				УчетСтажаПФР.УстановитьЗначениеРегистрируемогоРесурса(РегистрируемыйПериод, "ГрафикРаботы", Выборка.ГрафикРаботы);
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ДанныеДляРегистрацииВУчете;
	
КонецФункции

Процедура ЗаполнитьДатуЗапретаРедактирования(ОбъектДокумента) Экспорт
	
	ЗарплатаКадры.ЗаполнитьДатуЗапретаРедактированияСписочногоДокумента(ОбъектДокумента, "Сотрудники", "ДатаНачала");
	
КонецПроцедуры

Процедура ЗаполнитьДатыЗапрета(ПараметрыОбновления) Экспорт
	
	ОбновлениеВыполнено = Истина;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ ПЕРВЫЕ 100
		|	КадровыйПереводСписком.Ссылка КАК Ссылка,
		|	КадровыйПереводСписком.Дата КАК Дата
		|ИЗ
		|	Документ.КадровыйПереводСписком КАК КадровыйПереводСписком
		|ГДЕ
		|	КадровыйПереводСписком.ДатаЗапрета = ДАТАВРЕМЯ(1, 1, 1)
		|
		|УПОРЯДОЧИТЬ ПО
		|	КадровыйПереводСписком.Дата УБЫВ";
	
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

Функция ОписаниеПодписейДокумента() Экспорт 

	ОписаниеПодписей = ПодписиДокументов.ОписаниеТаблицыПодписей();

	ОписаниеПодписиРуководитель = ПодписиДокументов.ОписаниеРеквизитовПодписанта();
	ОписаниеПодписиРуководитель.ФизическоеЛицо = "Руководитель";
	ОписаниеПодписиРуководитель.Должность = "ДолжностьРуководителя";
	ОписаниеПодписиРуководитель.ОснованиеПодписи = "ОснованиеПредставителяНанимателя";

	ПереопределяемыеИмена = Новый Соответствие;
	ПереопределяемыеИмена.Вставить("Руководитель", ОписаниеПодписиРуководитель);

	ПодписиДокументов.ДобавитьОписаниеПодписейОрганизации(
		ОписаниеПодписей,
		"Руководитель",
		ПереопределяемыеИмена);

	Возврат ОписаниеПодписей;

КонецФункции

Процедура СформироватьДвиженияМероприятийТрудовойДеятельности(НаборЗаписей, ДанныеДляПроведения) Экспорт
	
	Документы.КадровыйПеревод.СформироватьДвиженияМероприятийТрудовойДеятельности(НаборЗаписей, ДанныеДляПроведения);
	
КонецПроцедуры

Функция ДанныеДляПроведенияМероприятияТрудовойДеятельности(СсылкаНаДокумент, ТолькоПроведенные = Ложь) Экспорт
	
	Возврат Документы.КадровыйПеревод.ДанныеДляПроведенияМероприятияТрудовойДеятельности(СсылкаНаДокумент, ТолькоПроведенные);
	
КонецФункции

#КонецОбласти

#КонецЕсли
