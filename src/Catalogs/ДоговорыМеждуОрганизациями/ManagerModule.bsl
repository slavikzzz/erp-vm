#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Добавляет команду создания объекта.
//
// Параметры:
//	КомандыСозданияНаОсновании - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
//
// Возвращаемое значение:
//	СтрокаТаблицыЗначений, Неопределено - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
//
Функция ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании) Экспорт
	
	Команда = Неопределено;
	
	Если ПравоДоступа("Добавление", Метаданные.Справочники.ДоговорыМеждуОрганизациями) Тогда
		Команда = КомандыСозданияНаОсновании.Добавить();
		Команда.Менеджер = Метаданные.Справочники.ДоговорыМеждуОрганизациями.ПолноеИмя();
		Команда.Представление = ОбщегоНазначенияУТ.ПредставлениеОбъекта(Метаданные.Справочники.ДоговорыМеждуОрганизациями);
		Команда.РежимЗаписи = "Проводить";
		Команда.ФункциональныеОпции = "ИспользоватьДоговорыМеждуОрганизациями";
	КонецЕсли;
	
	Возврат Команда;
	
КонецФункции

// Устанавливает статус договоров.
//
// Параметры:
//	Договоры - Массив - Массив ссылок на договоры (СправочникСсылка.ДоговорыМеждуОрганизациями);
//	Статус - ПеречислениеСсылка.СтатусыДоговоровКонтрагентов - Статус, который будет установлен у договоров.
//
// Возвращаемое значение:
//	Число - Количество обработанных объектов.
//
Функция УстановитьСтатус(Договоры, Статус) Экспорт
	
	МассивСсылок = Новый Массив;
	КоличествоОбработанных = 0;
	
	Для Каждого Договор Из Договоры Цикл
		Если ТипЗнч(Договор) = Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
			Продолжить;
		КонецЕсли;
		
		МассивСсылок.Добавить(Договор);
	КонецЦикла;
	
	Если МассивСсылок = 0 Тогда
		Возврат КоличествоОбработанных;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ДоговорыМеждуОрганизациями.Ссылка КАК Ссылка,
	|	ДоговорыМеждуОрганизациями.ПометкаУдаления КАК ПометкаУдаления,
	|	ВЫБОР
	|		КОГДА ДоговорыМеждуОрганизациями.Статус = &Статус
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК СтатусСовпадает
	|ИЗ
	|	Справочник.ДоговорыМеждуОрганизациями КАК ДоговорыМеждуОрганизациями
	|
	|ГДЕ
	|	ДоговорыМеждуОрганизациями.Ссылка В(&МассивСсылок)";
	
	Запрос.УстановитьПараметр("МассивСсылок", МассивСсылок);
	Запрос.УстановитьПараметр("Статус", Статус);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Если Выборка.ПометкаУдаления Тогда
			ТекстОшибки = НСтр("ru = 'Договор %Договор% помечен на удаление. Невозможно изменить статус';
								|en = 'Contract %Договор% is marked for deletion. Cannot change the status'");
			ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Договор%", Выборка.Ссылка);
			
			ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, Выборка.Ссылка);
			
			Продолжить;
		КонецЕсли;
		
		Если Выборка.СтатусСовпадает Тогда
			ТекстОшибки = НСтр("ru = 'Договору %Договор% уже присвоен статус ""%Статус%""';
								|en = 'Status ""%Статус%"" has already been assigned to contract %Договор%'");
			ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Договор%", Выборка.Ссылка);
			ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Статус%", Статус);
			
			ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, Выборка.Ссылка);
			
			Продолжить;
		КонецЕсли;
		
		Попытка
			ЗаблокироватьДанныеДляРедактирования(Выборка.Ссылка);
		Исключение
			ТекстОшибки = НСтр("ru = 'Не удалось заблокировать %Договор%. %ОписаниеОшибки%';
								|en = 'Failed to lock %Договор%. %ОписаниеОшибки%'");
			ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Договор%", Выборка.Ссылка);
			ТекстОшибки = СтрЗаменить(ТекстОшибки, "%ОписаниеОшибки%", КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
			
			ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, Выборка.Ссылка);
			
			Продолжить;
		КонецПопытки;
		
		Объект = Выборка.Ссылка.ПолучитьОбъект();
		Объект.Статус = Статус;
		
		Если Статус = Перечисления.СтатусыДоговоровКонтрагентов.НеСогласован Тогда
			Если Объект.Согласован Тогда
				Объект.Согласован = Ложь;
			КонецЕсли;
		КонецЕсли;
		
		Если Не Объект.ПроверитьЗаполнение() Тогда
			Продолжить;
		КонецЕсли;
			
		Попытка
			Объект.Записать();
			
			КоличествоОбработанных = КоличествоОбработанных + 1;
		Исключение
			ТекстОшибки = НСтр("ru = 'Не удалось записать %Договор%. %ОписаниеОшибки%';
								|en = 'Failed to save %Договор%. %ОписаниеОшибки%'");
			ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Договор%", Выборка.Ссылка);
			ТекстОшибки = СтрЗаменить(ТекстОшибки, "%ОписаниеОшибки%", КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
			
			ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, Выборка.Ссылка);
		КонецПопытки
		
	КонецЦикла;
	
	Возврат КоличествоОбработанных;
	
КонецФункции

// Процедура заполняет банковские счета документа по договору.
//
// Параметры:
//	Договор - СправочникСсылка.ДоговорыКонтрагентов - Договор, указанный в документе;
//	БанковскийСчетОрганизации - СправочникСсылка.БанковскиеСчетаОрганизаций - Реквизит документа "Банковский счет организации";
//	БанковскийСчетОрганизацииПолучателя - СправочникСсылка.БанковскиеСчетаКонтрагентов - Реквизит документа "Банковский счет контрагента".
//
Процедура ЗаполнитьБанковскиеСчетаПоДоговору(Договор, БанковскийСчетОрганизации, БанковскийСчетОрганизацииПолучателя) Экспорт
	
	ДанныеДоговора = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Договор, "БанковскийСчет, БанковскийСчетПолучателя"); 
		
	БанковскийСчетОрганизации = ДанныеДоговора.БанковскийСчет;
	БанковскийСчетОрганизацииПолучателя = ДанныеДоговора.БанковскийСчетПолучателя;
	
КонецПроцедуры 

// Процедура заполняет статью движения денежных средств по договору
//
// Параметры:
//	Договор - СправочникСсылка.ДоговорыМеждуОрганизациями - Договор, указанный в документе;
//	СтатьяДвиженияДенежныхСредств - СправочникСсылка.СтатьиДвиженияДенежныхСредств - Реквизит документа "Статья движения денежных средств";
//
Процедура ЗаполнитьСтатьюДвиженияДенежныхСредствПоДоговору(Договор, СтатьяДвиженияДенежныхСредств) Экспорт
	
	Если ЗначениеЗаполнено(Договор) Тогда
		СтатьяДвиженияДенежныхСредств = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Договор, "СтатьяДвиженияДенежныхСредств"); 
	КонецЕсли;
	
КонецПроцедуры

// Возвращает имена блокируемых реквизитов для механизма блокирования реквизитов БСП.
//
// Возвращаемое значение:
//	Массив - имена блокируемых реквизитов.
//
Функция ПолучитьБлокируемыеРеквизитыОбъекта() Экспорт
	
	Результат = Новый Массив;
	Результат.Добавить("ТипДоговора");
	Результат.Добавить("Организация");
	Результат.Добавить("ОрганизацияПолучатель");
	Результат.Добавить("Подразделение");
	Результат.Добавить("ОплатаВВалюте");
	Результат.Добавить("ВалютаВзаиморасчетов");
	Результат.Добавить("ПорядокРасчетов");
	Результат.Добавить("ГруппаФинансовогоУчета");
	Результат.Добавить("ГруппаФинансовогоУчетаПолучателя");
	Результат.Добавить("НаправлениеДеятельности");
	
	Возврат Результат;
КонецФункции

// Формирует описание реквизитов объекта, заполняемых по статистике их использования.
//
// Параметры:
//  ОписаниеРеквизитов - Структура - описание реквизитов, для которых необходимо получить значения по статистике
//
//
Процедура ЗадатьОписаниеЗаполняемыхРеквизитовПоСтатистике(ОписаниеРеквизитов) Экспорт
	
	Параметры = ЗаполнениеОбъектовПоСтатистике.ПараметрыЗаполняемыхРеквизитов();
	Параметры.РазрезыСбораСтатистики.ИспользоватьВсегда = "ТипДоговора,Менеджер";
	Параметры.ЗаполнятьПриУсловии.ПоляОбъектаЗаполнены = "ТипДоговора";
	ЗаполнениеОбъектовПоСтатистике.ДобавитьОписаниеЗаполняемыхРеквизитов(ОписаниеРеквизитов,
		"ПорядокРасчетов", Параметры);
	
КонецПроцедуры

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// Параметры:
//   Ограничение - см. УправлениеДоступомПереопределяемый.ПриЗаполненииОграниченияДоступа.Ограничение.
//
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)
	|	ИЛИ ЗначениеРазрешено(ОрганизацияПолучатель)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

// Возвращает параметры для заполнения налогообложения НДС.
//
// Параметры:
//	Объект - ДанныеФормыСтруктура,
//			СправочникСсылка.ДоговорыМеждуОрганизациями,
//			СправочникОбъект.ДоговорыМеждуОрганизациями - справочник договор между организациями.
//
// Возвращаемое значение:
//	Структура - состав полей задается в функции УчетНДСУПКлиентСервер.ПараметрыЗаполненияНалогообложенияНДСПродажи().
//
Функция ПараметрыЗаполненияНалогообложенияНДС(Объект) Экспорт
	
	ИменаРеквизитов = "Организация, ОрганизацияПолучатель, ТипДоговора, НалогообложениеНДСОпределяетсяВДокументе";
	РеквизитыСправочника = Новый Структура(ИменаРеквизитов);
	
	Если ТипЗнч(Объект) = Тип("СправочникСсылка.ДоговорыМеждуОрганизациями") Тогда
		РеквизитыСправочника = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект, РеквизитыСправочника);
	Иначе
		ЗаполнитьЗначенияСвойств(РеквизитыСправочника, Объект);
	КонецЕсли;
	
	ПараметрыЗаполнения = УчетНДСУПКлиентСервер.ПараметрыЗаполненияНалогообложенияНДСПродажи();
	ЗаполнитьЗначенияСвойств(ПараметрыЗаполнения, РеквизитыСправочника);
	
	РеализацияТоваров = РеквизитыСправочника.ТипДоговора = Перечисления.ТипыДоговоровМеждуОрганизациями.КупляПродажа;
	
	ПараметрыЗаполнения.РеализацияТоваров    = РеализацияТоваров
												И Не РеквизитыСправочника.НалогообложениеНДСОпределяетсяВДокументе;
	ПараметрыЗаполнения.РеализацияРаботУслуг = РеализацияТоваров
												И Не РеквизитыСправочника.НалогообложениеНДСОпределяетсяВДокументе;
	ПараметрыЗаполнения.ОтчетКомиссионера    = Не РеализацияТоваров
												И Не РеквизитыСправочника.НалогообложениеНДСОпределяетсяВДокументе;
	
	ПараметрыЗаполнения.ЭтоОперацияМеждуОрганизациями = Истина;
	
	Возврат ПараметрыЗаполнения;
	
КонецФункции

// Возвращает параметры для заполнения вида деятельности НДС.
//
// Параметры:
//	Объект - ДанныеФормыСтруктура,
//			СправочникСсылка.ДоговорыМеждуОрганизациями,
//			СправочникОбъект.ДоговорыМеждуОрганизациями - справочник договор между организациями.
//
// Возвращаемое значение:
//	Структура - состав полей задается в функции УчетНДСУПКлиентСервер.ПараметрыЗаполненияВидаДеятельностиНДС().
//
Функция ПараметрыЗаполненияВидаДеятельностиНДС(Объект) Экспорт
	
	ИменаРеквизитов = "Организация, ТипДоговора, ЗакупкаПодДеятельностьОпределяетсяВДокументе, НаправлениеДеятельности";
	РеквизитыСправочника = Новый Структура(ИменаРеквизитов);
	
	Если ТипЗнч(Объект) = Тип("СправочникСсылка.ДоговорыМеждуОрганизациями") Тогда
		РеквизитыСправочника = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект, РеквизитыСправочника);
	Иначе
		ЗаполнитьЗначенияСвойств(РеквизитыСправочника, Объект);
	КонецЕсли;
	
	ПараметрыЗаполнения = УчетНДСУПКлиентСервер.ПараметрыЗаполненияВидаДеятельностиНДС();
	ЗаполнитьЗначенияСвойств(ПараметрыЗаполнения, РеквизитыСправочника);
	
	ПриобретениеТоваров = Не РеквизитыСправочника.ЗакупкаПодДеятельностьОпределяетсяВДокументе
							И РеквизитыСправочника.ТипДоговора = Перечисления.ТипыДоговоровМеждуОрганизациями.КупляПродажа;
	
	ПараметрыЗаполнения.ПриобретениеТоваров = ПриобретениеТоваров;
	ПараметрыЗаполнения.ПриобретениеРабот   = ПриобретениеТоваров;
	
	Возврат ПараметрыЗаполнения;
	
КонецФункции

// Возвращает параметры механизма взаиморасчетов.
//
// Параметры:
// 	ДанныеЗаполнения - ДокументОбъект, СправочникОбъект, ДокументСсылка, СправочникСсылка, Структура, ДанныеФормыСтруктура - Объект или коллекция для
//              расчета параметров взаиморасчетов.
//
// Возвращаемое значение:
// 	Массив из см. ВзаиморасчетыСервер.ПараметрыМеханизма - параметров функций механизма взаиморасчетов.
//
Функция ПараметрыВзаиморасчеты(ДанныеЗаполнения = Неопределено) Экспорт
	
	Если ОбщегоНазначения.ЗначениеСсылочногоТипа(ДанныеЗаполнения) Тогда
		ДанныеЗаполненияСтруктура = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДанныеЗаполнения, "ТипДоговора, Сумма");
		ТипДоговора = ДанныеЗаполненияСтруктура.ТипДоговора;
		Сумма       = ДанныеЗаполненияСтруктура.Сумма;
	ИначеЕсли ДанныеЗаполнения = Неопределено Тогда
		ТипДоговора = Неопределено;
		Сумма       = 0;
	Иначе
		ТипДоговора = ДанныеЗаполнения.ТипДоговора;
		Сумма       = ДанныеЗаполнения.Сумма;
	КонецЕсли;
	
	МассивПараметров = Новый Массив();
	
	#Область ОрганизацияОтправитель
		
	#Область Отправитель
	
	СтруктураПараметров = ВзаиморасчетыСервер.ПараметрыМеханизма();
	
	СтруктураПараметров.ЭтоСправочник                    = Истина;
	
	СтруктураПараметров.ТипРасчетов                      = Перечисления.ТипыРасчетовСПартнерами.РасчетыСКлиентом;
	
	// Для отображения гиперссылки и зачета оплат.
	СтруктураПараметров.ИзменяетПланОплаты = ТипДоговора = Перечисления.ТипыДоговоровМеждуОрганизациями.КупляПродажа
												И Сумма <> 0;
	
	СтруктураПараметров.Дата                             = "Объект.Дата"; 
	
	// Валюта и сумма операции. Обязательно путь к реквизитам объекта.
	СтруктураПараметров.ВалютаДокумента                  = "Объект.ВалютаВзаиморасчетов";
	СтруктураПараметров.СуммаДокумента                   = "Объект.Сумма";
	СтруктураПараметров.Партнер                          = Справочники.Партнеры.НашеПредприятие;
	СтруктураПараметров.Контрагент                       = "Объект.ОрганизацияПолучатель";
	СтруктураПараметров.Договор                          = "Объект.Ссылка";
	СтруктураПараметров.ПорядокРасчетов                  = "Объект.ПорядокРасчетов";
	СтруктураПараметров.Соглашение                       = "";
	
	// Используются для определения значения ОплатаВВалюте и в форме редактирования правил оплаты.
	СтруктураПараметров.БанковскийСчетОрганизации        = "Объект.БанковскийСчет";
	СтруктураПараметров.БанковскийСчетКонтрагента        = "Объект.БанковскийСчетПолучателя";
	СтруктураПараметров.Касса                            = "";
	СтруктураПараметров.ФормаОплаты                      = "";
	
	СтруктураПараметров.Менеджер                         = "Объект.Менеджер";
	СтруктураПараметров.НомерВходящегоДокумента          = "Объект.Номер";
	СтруктураПараметров.ДатаВходящегоДокумента           = "Объект.Дата";
	
	МассивПараметров.Добавить(СтруктураПараметров);
	
	#КонецОбласти
	
	#Область ОтправительВознаграждение
	
	Если ТипДоговора = Перечисления.ТипыДоговоровМеждуОрганизациями.Комиссионный Тогда
	
		СтруктураПараметров = ВзаиморасчетыСервер.ПараметрыМеханизма();
		
		СтруктураПараметров.ЭтоСправочник                    = Истина;
		
		СтруктураПараметров.ТипРасчетов                      = Перечисления.ТипыРасчетовСПартнерами.РасчетыСПоставщиком;
		
		СтруктураПараметров.ИзменяетПланОплаты               = Ложь;
		СтруктураПараметров.ИзменяетПланОтгрузкиПоставки     = Ложь;
		
		СтруктураПараметров.Дата                             = "Объект.Дата"; 
		
		// Валюта и сумма операции. Обязательно путь к реквизитам объекта.
		СтруктураПараметров.ВалютаДокумента                  = "Объект.ВалютаВзаиморасчетов";
		СтруктураПараметров.СуммаДокумента                   = "Объект.Сумма";
		СтруктураПараметров.Партнер                          = Справочники.Партнеры.НашеПредприятие;
		СтруктураПараметров.Контрагент                       = "Объект.ОрганизацияПолучатель";
		СтруктураПараметров.Договор                          = "Объект.Ссылка";
		СтруктураПараметров.ПорядокРасчетов                  = "Объект.ПорядокРасчетов";
		СтруктураПараметров.Соглашение                       = "";
		
		// Используются для определения значения ОплатаВВалюте и в форме редактирования правил оплаты.
		СтруктураПараметров.БанковскийСчетОрганизации        = "Объект.БанковскийСчет";
		СтруктураПараметров.БанковскийСчетКонтрагента        = "Объект.БанковскийСчетПолучателя";
		СтруктураПараметров.Касса                            = "";
		СтруктураПараметров.ФормаОплаты                      = "";
		
		СтруктураПараметров.Менеджер                         = "Объект.Менеджер";
		СтруктураПараметров.НомерВходящегоДокумента          = "Объект.Номер";
		СтруктураПараметров.ДатаВходящегоДокумента           = "Объект.Дата";
		
		МассивПараметров.Добавить(СтруктураПараметров);
	
	КонецЕсли;
	
	#КонецОбласти
	
	#КонецОбласти
	
	#Область ОрганизацияПолучатель
	
	#Область Получатель
	
	СтруктураПараметров = ВзаиморасчетыСервер.ПараметрыМеханизма();
	
	СтруктураПараметров.ЭтоСправочник                    = Истина;
	
	СтруктураПараметров.ТипРасчетов                      = Перечисления.ТипыРасчетовСПартнерами.РасчетыСПоставщиком;
	
	// Для отображения гиперссылки
	СтруктураПараметров.ИзменяетПланОплаты = ТипДоговора = Перечисления.ТипыДоговоровМеждуОрганизациями.КупляПродажа
											И Сумма <> 0;
	
	СтруктураПараметров.Дата                             = "Объект.Дата"; 
	
	// Валюта и сумма операции. Обязательно путь к реквизитам объекта.
	СтруктураПараметров.ВалютаДокумента                  = "Объект.ВалютаВзаиморасчетов";
	СтруктураПараметров.СуммаДокумента                   = "Объект.Сумма";
	СтруктураПараметров.Организация                      = "Объект.ОрганизацияПолучатель";
	СтруктураПараметров.Контрагент                       = "Объект.Организация";
	СтруктураПараметров.Партнер                          = Справочники.Партнеры.НашеПредприятие;
	СтруктураПараметров.Договор                          = "Объект.Ссылка";
	СтруктураПараметров.ПорядокРасчетов                  = "Объект.ПорядокРасчетов";
	СтруктураПараметров.Соглашение                       = "";
	
	// Используются для определения значения ОплатаВВалюте и в форме редактирования правил оплаты.
	СтруктураПараметров.БанковскийСчетОрганизации        = "Объект.БанковскийСчетПолучателя";
	СтруктураПараметров.БанковскийСчетКонтрагента        = "Объект.БанковскийСчет";
	СтруктураПараметров.Касса                            = "";
	СтруктураПараметров.ФормаОплаты                      = "";
	
	СтруктураПараметров.ГруппаФинансовогоУчета           = "Объект.ГруппаФинансовогоУчетаПолучателя";
	СтруктураПараметров.Менеджер                         = "Объект.Менеджер";
	СтруктураПараметров.НомерВходящегоДокумента          = "Объект.Номер";
	СтруктураПараметров.ДатаВходящегоДокумента           = "Объект.Дата";
	
	МассивПараметров.Добавить(СтруктураПараметров);
	
	#КонецОбласти
	
	#Область ПолучательВознаграждение
	
	Если ТипДоговора = Перечисления.ТипыДоговоровМеждуОрганизациями.Комиссионный Тогда
	
		СтруктураПараметров = ВзаиморасчетыСервер.ПараметрыМеханизма();
		
		СтруктураПараметров.ЭтоСправочник                    = Истина;
		СтруктураПараметров.ТипРасчетов                      = Перечисления.ТипыРасчетовСПартнерами.РасчетыСКлиентом;
		
		СтруктураПараметров.ИзменяетПланОплаты = Ложь;
		СтруктураПараметров.ИзменяетПланОтгрузкиПоставки = Ложь;
		
		СтруктураПараметров.Дата                             = "Объект.Дата"; 
		
		// Валюта и сумма операции. Обязательно путь к реквизитам объекта.
		СтруктураПараметров.ВалютаДокумента                  = "Объект.ВалютаВзаиморасчетов";
		СтруктураПараметров.СуммаДокумента                   = "Объект.Сумма";
		СтруктураПараметров.Организация                      = "Объект.ОрганизацияПолучатель";
		СтруктураПараметров.Контрагент                       = "Объект.Организация";
		СтруктураПараметров.Партнер                          = Справочники.Партнеры.НашеПредприятие;
		СтруктураПараметров.Договор                          = "Объект.Ссылка";
		СтруктураПараметров.ПорядокРасчетов                  = "Объект.ПорядокРасчетов";
		СтруктураПараметров.Соглашение                       = "";
		
		// Используются для определения значения ОплатаВВалюте и в форме редактирования правил оплаты.
		СтруктураПараметров.БанковскийСчетОрганизации        = "Объект.БанковскийСчетПолучателя";
		СтруктураПараметров.БанковскийСчетКонтрагента        = "Объект.БанковскийСчет";
		СтруктураПараметров.Касса                            = "";
		СтруктураПараметров.ФормаОплаты                      = "";
		
		СтруктураПараметров.ГруппаФинансовогоУчета           = "Объект.ГруппаФинансовогоУчетаПолучателя";
		СтруктураПараметров.Менеджер                         = "Объект.Менеджер";
		СтруктураПараметров.НомерВходящегоДокумента          = "Объект.Номер";
		СтруктураПараметров.ДатаВходящегоДокумента           = "Объект.Дата";
		
		МассивПараметров.Добавить(СтруктураПараметров);
		
	КонецЕсли;
	
	#КонецОбласти
	
	#КонецОбласти
	
	Возврат МассивПараметров;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - см. УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	ДоговорыМеждуОрганизациямиЛокализация.ДобавитьКомандыПечати(КомандыПечати);
КонецПроцедуры

#КонецОбласти

#Область Отчеты

// Определяет список команд отчетов.
//
// Параметры:
//   КомандыОтчетов - См. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.КомандыОтчетов
//   Параметры - См. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.Параметры
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры) Экспорт
	
	ДоговорыМеждуОрганизациямиЛокализация.ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
