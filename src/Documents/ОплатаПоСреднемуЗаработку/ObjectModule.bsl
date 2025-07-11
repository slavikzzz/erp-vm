#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

// В качестве данных заполнения может принимать структуру с полями.
//		Ссылка
//		Действие
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.Сотрудники") Тогда
		ЗарплатаКадры.ЗаполнитьПоОснованиюСотрудником(ЭтотОбъект, ДанныеЗаполнения);
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ВосстановлениеВДолжности") Тогда
		
		РеквизитыДанныхЗаполнения = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
			ДанныеЗаполнения, "Организация,Сотрудник,ДатаУвольнения,ДатаВосстановления,Проведен");
			
		Если РеквизитыДанныхЗаполнения.Проведен Тогда
			
			ЗаполнитьЗначенияСвойств(ЭтотОбъект, РеквизитыДанныхЗаполнения);
			
			ДатаНачала = КонецДня(РеквизитыДанныхЗаполнения.ДатаУвольнения) + 1;
			ДатаОкончания = НачалоДня(РеквизитыДанныхЗаполнения.ДатаВосстановления) - 1;
			ДатаНачалаСобытия = ДатаНачала;
			
			РасчетДенежногоСодержания = Ложь;
			ЗарплатаКадрыРасширенный.УстановитьВариантРасчетаДокументаПоСреднемуЗаработку(ЭтотОбъект);
			
			ДопПараметры = Документы.ОплатаПоСреднемуЗаработку.ДополнительныеПараметрыВыбораНачислений(ЭтотОбъект, "ВидРасчета");
			ДопПараметры.Вставить("Отбор.Код", НСтр("ru = 'ОВП';
													|en = 'OCI'"));
			ПланыВидовРасчета.Начисления.УстановитьНачислениеПоУмолчаниюВОбъекте(ЭтотОбъект, "ВидРасчета", ДопПараметры);
			Если Не ЗначениеЗаполнено(ВидРасчета) Тогда
				ДопПараметры.Удалить("Отбор.Код");
				ПланыВидовРасчета.Начисления.УстановитьНачислениеПоУмолчаниюВОбъекте(ЭтотОбъект, "ВидРасчета", ДопПараметры);
			КонецЕсли;
			
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		Если ДанныеЗаполнения.Свойство("Действие") И ДанныеЗаполнения.Действие = "Исправить" Тогда
			
			ИсправлениеДокументовЗарплатаКадры.СкопироватьДокумент(ЭтотОбъект, 
												ДанныеЗаполнения.Ссылка, 
												"ДокументРассчитан", 
												"ДанныеОбИндексации,Начисления,НачисленияПерерасчет,НачисленияПерерасчетНулевыеСторно,
												|НДФЛ,ОтработанноеВремяДляСреднегоОбщий,
												|Показатели,ПримененныеВычетыНаДетейИИмущественные,
												|РаспределениеРезультатовНачислений,РаспределениеРезультатовУдержаний,
												|СреднийЗаработокОбщий,Удержания",
												ДанныеЗаполнения);
			
			ИсправленныйДокумент = ДанныеЗаполнения.Ссылка;
			
		ИначеЕсли ДанныеЗаполнения.Свойство("Действие") И ДанныеЗаполнения.Действие = "ЗаполнитьПослеПереноса" Тогда
			ЗаполнитьПослеПереноса(ДанныеЗаполнения);	
		КонецЕсли;
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.ОхранаТруда.МедицинскиеОсмотры") Тогда
		МодульМедицинскиеОсмотры = ОбщегоНазначения.ОбщийМодуль("МедицинскиеОсмотры");
		МодульМедицинскиеОсмотры.ЗаполнитьОплатуПоСреднемуПоНаправлениюНаМедицинскийОсмотр(ЭтотОбъект, ДанныеЗаполнения);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ДатаНачала) И Не ЗначениеЗаполнено(ДатаНачалаСобытия) Тогда
		ДатаНачалаСобытия = ДатаНачала;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Документы.ОплатаПоСреднемуЗаработку.ПровестиПоУчетам(Ссылка, РежимПроведения, Отказ, Неопределено, Движения, ЭтотОбъект, ДополнительныеСвойства);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ВнутрисменноеОтсутствие Тогда
		ЗарплатаКадры.ПроверитьКорректностьДаты(Ссылка, ДатаОтсутствия, "Объект.ДатаОтсутствия", Отказ, НСтр("ru = 'Дата отсутствия';
																											|en = 'Absence date'"), , , Ложь);
	Иначе
		ЗарплатаКадры.ПроверитьКорректностьДаты(Ссылка, ДатаНачала, "Объект.ДатаНачала", Отказ, НСтр("ru = 'Дата начала';
																									|en = 'Start date'"), , , Ложь);
	КонецЕсли;
	
	КонтейнерОшибок = Неопределено;
	
	ПроверитьЗаполнениеРеквизитовШапки(КонтейнерОшибок);	
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьРасчетЗарплатыРасширенная") Тогда
		
		Если ДокументРассчитан Тогда 
			
			ЗарплатаКадры.ПроверитьДатуВыплаты(ЭтотОбъект, Отказ);
			
			ПроверитьЗаполнениеРеквизитовНеобходимыхДляРасчета(КонтейнерОшибок);                                                                        
			
			ИсправлениеДокументовЗарплатаКадры.ПроверитьЗаполнение(ЭтотОбъект, ПроверяемыеРеквизиты, Отказ);
			ПроверитьПериодДействияНачислений(Отказ);
			
			// Проверка корректности распределения по источникам финансирования
			ИменаТаблицРаспределяемыхПоСтатьямФинансирования = "Начисления,НачисленияПерерасчет,Удержания,НДФЛ,КорректировкиВыплаты";
			
			ОтражениеЗарплатыВБухучетеРасширенный.ПроверитьРезультатыРаспределенияНачисленийУдержанийОбъекта(
				ЭтотОбъект, ИменаТаблицРаспределяемыхПоСтатьямФинансирования, Отказ);
			
			// Проверка корректности распределения по территориям и условиям труда
			ИменаТаблицРаспределенияПоТерриториямУсловиямТруда = "Начисления,НачисленияПерерасчет";
			
			РасчетЗарплатыРасширенный.ПроверитьРаспределениеПоТерриториямУсловиямТрудаДокумента(
				ЭтотОбъект, ИменаТаблицРаспределенияПоТерриториямУсловиямТруда, Отказ);
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если Не ДополнительныеСвойства.Свойство("ПроверкаПересеченияПериодовВыполнена") Тогда
		ПроверитьПересечениеПериодовОтсутствия(Отказ);
	КонецЕсли;
	
	ПроверитьРегистрациюВнутрисменногоВремени(Отказ);
	
	ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(КонтейнерОшибок, Отказ);
	
	УдалитьПроверенныеРеквизиты(ПроверяемыеРеквизиты);
	
	КадровыйЭДО.ПроверитьВозможностьСохраненияИзмененийДокументаСПечатнымиФормами(
		ЭтотОбъект, Метаданные.Роли.ДобавлениеИзменениеНачисленнойЗарплатыРасширенная, Отказ);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьСотрудникаВТаблицахНачислений();
	
	ПредставлениеПериода = ЗарплатаКадрыРасширенный.ПредставлениеПериодаРасчетногоДокумента(ДатаНачала, ДатаОкончания);
	
	РасчетЗарплатыРасширенный.ЗаполнитьИсходныйДокумент(ЭтотОбъект);
	ОтражениеЗарплатыВБухучетеРасширенный.ОбновитьДанныеБухучетаДокументаПередЗаписью(ЭтотОбъект);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	УчетСреднегоЗаработка.ЗаписатьДатуНачалаСобытия(Ссылка, Сотрудник, ДатаНачалаСобытия);
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.ЦепочкиДокументов") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("ЦепочкиДокументов");
		Модуль.УстановитьВторичныеРеквизитыДокументаЗамещения(ЭтотОбъект);
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	ДанныеДляБухучета = Документы.ОплатаПоСреднемуЗаработку.ДанныеДляБухучетаЗарплатыПервичныхДокументов(ЭтотОбъект);
	ОтражениеЗарплатыВБухучетеРасширенный.ЗарегистрироватьБухучетЗарплатыПервичныхДокументов(ДанныеДляБухучета);
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	РасчетЗарплатыРасширенный.ЗаполнитьИсходныйДокументПриКопировании(ЭтотОбъект, ОбъектКопирования.Ссылка);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ПроверкаЗаполненияДокумента

Функция ДокументГотовКРасчету(ВыводитьСообщения = Истина) Экспорт
	
	КонтейнерОшибок = Неопределено;
	
	ПроверитьЗаполнениеРеквизитовШапки(КонтейнерОшибок);
	
	ПроверитьЗаполнениеРеквизитовНеобходимыхДляРасчета(КонтейнерОшибок, Истина);                                                                        
		
	КонтейнерСодержитОшибки = Ложь;
	
	ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(КонтейнерОшибок, КонтейнерСодержитОшибки);
	
	Если Не ВыводитьСообщения Тогда
		
		ПолучитьСообщенияПользователю(Истина);		
		
	КонецЕсли;
	
	Возврат Не КонтейнерСодержитОшибки;	
	
КонецФункции

Процедура ПроверитьЗаполнениеРеквизитовШапки(КонтейнерОшибок)
	
	Если Не ЗначениеЗаполнено(ПериодРегистрации) Тогда
		ТекстСообщения = НСтр("ru = 'Не указан период регистрации.';
								|en = 'Registration period is not specified.'");
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(КонтейнерОшибок, "Объект.ПериодРегистрации", ТекстСообщения, "");
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Организация) Тогда
		ТекстСообщения = НСтр("ru = 'Поле ""Организация"" обязательно к заполнению.';
								|en = 'Field ""Company"" is required.'");
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(КонтейнерОшибок, "Объект.Организация", ТекстСообщения, "");
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Сотрудник) Тогда
		ТекстСообщения = НСтр("ru = 'Поле ""Сотрудник"" обязательно к заполнению.';
								|en = 'Field ""Employee"" is required.'");
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(КонтейнерОшибок, "Объект.Сотрудник", ТекстСообщения, "");
	КонецЕсли;
	
	Если ВнутрисменноеОтсутствие Тогда
		Если Не ЗначениеЗаполнено(ДатаОтсутствия) Тогда
			ТекстСообщения = НСтр("ru = 'Не заполнена дата отсутствия.';
									|en = 'Absence date is not entered.'");
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(КонтейнерОшибок, "Объект.ДатаОтсутствия", ТекстСообщения, "");
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(ОплачиватьЧасов) Тогда
			ТекстСообщения = НСтр("ru = 'Не указано количество часов внутрисменного отсутствия.';
									|en = 'Number of hours of part-shift absence is not specified.'");
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(КонтейнерОшибок, "Объект.ОплачиватьЧасов", ТекстСообщения, "");
		КонецЕсли;
	Иначе 				
		Если Не ЗначениеЗаполнено(ДатаНачала) И Не ЗначениеЗаполнено(ДатаОкончания) Тогда
			ТекстСообщения = НСтр("ru = 'Не указаны даты оплаты по среднему заработку.';
									|en = 'Average earnings payment dates are not specified.'");
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(КонтейнерОшибок, "Объект.ДатаОкончания", ТекстСообщения, "");
		Иначе
			Если Не ЗначениеЗаполнено(ДатаНачала) И ЗначениеЗаполнено(ДатаОкончания) Тогда
				ТекстСообщения = НСтр("ru = 'Не заполнена дата начала оплаты по среднему заработку.';
										|en = 'Start date of average earnings payment is not entered.'");
				ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(КонтейнерОшибок, "Объект.ДатаНачала", ТекстСообщения, "");
			КонецЕсли;
			
			Если Не ЗначениеЗаполнено(ДатаОкончания) И ЗначениеЗаполнено(ДатаНачала) Тогда
				ТекстСообщения = НСтр("ru = 'Не заполнена дата окончания оплаты по среднему заработку.';
										|en = 'End date of average earnings payment is not entered.'");
				ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(КонтейнерОшибок, "Объект.ДатаОкончания", ТекстСообщения, "");
			КонецЕсли;
			
			Если ЗначениеЗаполнено(ДатаНачала) И ЗначениеЗаполнено(ДатаОкончания) И ДатаНачала > ДатаОкончания Тогда
				ТекстСообщения = НСтр("ru = 'Дата окончания оплаты по среднему заработку не может быть меньше даты начала.';
										|en = 'End date of average earnings payment cannot be less than the start date.'");
				ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(КонтейнерОшибок, "Объект.ДатаОкончания", ТекстСообщения, "");
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ВидВремени) Тогда
		ТекстСообщения = НСтр("ru = 'Не указан вид отсутствия.';
								|en = 'Absence kind is not specified.'");
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(КонтейнерОшибок, "Объект.ВидВремени", ТекстСообщения, "");
	КонецЕсли;
	
КонецПроцедуры

Процедура ПроверитьЗаполнениеРеквизитовНеобходимыхДляРасчета(КонтейнерОшибок, ПроверкаПередРасчетом = Ложь)
	
	Если Не ДокументРассчитан И Не ПроверкаПередРасчетом Тогда
		Возврат;
	КонецЕсли;	
	
	Если Не ЗначениеЗаполнено(ДатаНачалаСобытия) Тогда
		ТекстСообщения = НСтр("ru = 'Не указана дата начала периода сохранения среднего заработка.';
								|en = 'Start date of average earnings preservation period is not specified.'");
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(КонтейнерОшибок, "Объект.ДатаНачалаСобытия", ТекстСообщения, "");
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ПроцентОплаты) Тогда
		ТекстСообщения = НСтр("ru = 'Не указан процент оплаты.';
								|en = 'Payment percent is not specified.'");
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(КонтейнерОшибок, "Объект.ПроцентОплаты", ТекстСообщения, "");
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ВидРасчета) Тогда
		ТекстСообщения = Документы.ОплатаПоСреднемуЗаработку.ТекстСообщенияНеЗаполненВидРасчета(ВнутрисменноеОтсутствие);
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(КонтейнерОшибок, "Объект.ВидРасчета", ТекстСообщения, "");
	КонецЕсли;
	
	ПроверитьЗаполнениеПланируемойДатыВыплаты(КонтейнерОшибок, ПроверкаПередРасчетом);
	
КонецПроцедуры

Процедура ПроверитьЗаполнениеПланируемойДатыВыплаты(КонтейнерОшибок, ПроверкаПередРасчетом)
	
	МассивНачисленийДокумента = Новый Массив;
	
	Если НЕ ПроверкаПередРасчетом Тогда
		ОбщегоНазначенияКлиентСервер.ДополнитьМассив(МассивНачисленийДокумента, Начисления.ВыгрузитьКолонку("Начисление"), Истина);
		ОбщегоНазначенияКлиентСервер.ДополнитьМассив(МассивНачисленийДокумента, НачисленияПерерасчет.ВыгрузитьКолонку("Начисление"), Истина);
	КонецЕсли;
	
	Если УчетНДФЛРасширенный.ДатаВыплатыОбязательнаКЗаполнению(ПорядокВыплаты, МассивНачисленийДокумента, ПериодРегистрации)
		И Не ЗначениеЗаполнено(ПланируемаяДатаВыплаты) Тогда
		ТекстСообщения = НСтр("ru = 'Дата выплаты обязательна к заполнению при выплате в межрасчет.';
								|en = 'Payment date is required for payments outside the payroll period.'");
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(КонтейнерОшибок, "Объект.ПланируемаяДатаВыплаты", ТекстСообщения, "");
	КонецЕсли;
	
КонецПроцедуры

Процедура ПроверитьПериодДействияНачислений(Отказ)
	ПараметрыПроверкиПериодаДействия = РасчетЗарплатыРасширенный.ПараметрыПроверкиПериодаДействия();
	ПараметрыПроверкиПериодаДействия.Ссылка = Ссылка;
	ПроверяемыеКоллекции = Новый Массив;
	ПроверяемыеКоллекции.Добавить(РасчетЗарплатыРасширенный.ОписаниеКоллекцииДляПроверкиПериодаДействия("Начисления", НСтр("ru = 'Начисления';
																															|en = 'Accruals'")));
	ПроверяемыеКоллекции.Добавить(РасчетЗарплатыРасширенный.ОписаниеКоллекцииДляПроверкиПериодаДействия("Удержания", НСтр("ru = 'Удержания';
																															|en = 'Deductions'"), "Удержание"));
	ПроверяемыеКоллекции.Добавить(РасчетЗарплатыРасширенный.ОписаниеКоллекцииДляПроверкиПериодаДействия("НачисленияПерерасчет", НСтр("ru = 'Перерасчет прошлого периода';
																																	|en = 'Recalculation of the last period'")));
	РасчетЗарплатыРасширенный.ПроверитьПериодДействияВКоллекцияхНачислений(ЭтотОбъект, ПараметрыПроверкиПериодаДействия, ПроверяемыеКоллекции, Отказ);
КонецПроцедуры

Процедура ПроверитьРегистрациюВнутрисменногоВремени(Отказ)
	
	Если НЕ ВнутрисменноеОтсутствие Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеОВремениДляПроверки = Документы.ОплатаПоСреднемуЗаработку.ДанныеОВремени(ЭтотОбъект);
	ОшибкиВводаВремени = УчетРабочегоВремениРасширенный.ПроверитьРегистрациюВнутрисменногоВремени(Ссылка, ДанныеОВремениДляПроверки, ПериодРегистрации);
	Ошибки = Новый Соответствие;
	Для Каждого ОписаниеОшибки Из ОшибкиВводаВремени Цикл
		УчетРабочегоВремениРасширенный.ДобавитьОшибкуПоСотруднику(Ошибки, ОписаниеОшибки.Сотрудник, ОписаниеОшибки.ТекстОшибки, "", ОписаниеОшибки.Документ);		
	КонецЦикла;
	УчетРабочегоВремениРасширенный.ВывестиОшибкиПоСотрудникам(Ошибки, Отказ);
	
КонецПроцедуры

Процедура УдалитьПроверенныеРеквизиты(ПроверяемыеРеквизиты)
	
	Если ПроверяемыеРеквизиты = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "Организация");
	ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "Сотрудник");
	ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "ДатаНачала");
	ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "ДатаОкончания");
	ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "ДатаОтсутствия");
	ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "ОплачиватьЧасов");
	ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "ПроцентОплаты");
	ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "ВидВремени");
	ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "ВидРасчета");
	ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "ПланируемаяДатаВыплаты");

КонецПроцедуры

Процедура ПроверитьПересечениеПериодовОтсутствия(Отказ)
	
	РезультатПроверки = РезультатПроверкиПересеченийПериодовОтсутствия();
	
	ДанныеСотрудника = РезультатПроверки.ДанныеСотрудников.Получить(Сотрудник);
	Если ДанныеСотрудника = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если РезультатПроверки.Отказ Тогда
		ТекстСообщения = НСтр("ru = 'На период %1 сотруднику уже зарегистрировано отсутствие документом %2.';
								|en = 'Absence has already been registered for the employee on period %1 by the %2 document.'");
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, ДанныеСотрудника.ПредставлениеПериода, ДанныеСотрудника.Регистратор);
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, , , , Отказ);
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

Функция РезультатПроверкиПересеченийПериодовОтсутствия() Экспорт
	
	ИсходныеДанные = СостоянияСотрудников.ПустаяТаблицаДанныхСостоянийСотрудника();
	
	НоваяСтрока = ИсходныеДанные.Добавить();
	НоваяСтрока.Сотрудник = Сотрудник;
	НоваяСтрока.Состояние = Перечисления.СостоянияСотрудника.ОтсутствиеССохранениемОплаты;
	НоваяСтрока.Начало = ДатаНачала;
	НоваяСтрока.Окончание = ДатаОкончания;
	
	Возврат СостоянияСотрудников.ПроверитьПересечениеПериодовОтсутствия(ИсходныеДанные, Ссылка, ИсправленныйДокумент);
	
КонецФункции

#КонецОбласти

Процедура ЗаполнитьСотрудникаВТаблицахНачислений()
	
	ТаблицыНачислений = Новый Массив;
	ТаблицыНачислений.Добавить(Начисления);
	ТаблицыНачислений.Добавить(НачисленияПерерасчет);
	ТаблицыНачислений.Добавить(НачисленияПерерасчетНулевыеСторно);
	
	Для Каждого ТаблицаНачислений Из ТаблицыНачислений Цикл
		Для Каждого СтрокаТаблицы Из ТаблицаНачислений Цикл
			Если Не ЗначениеЗаполнено(СтрокаТаблицы.Сотрудник) Тогда
				СтрокаТаблицы.Сотрудник = Сотрудник;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьПослеПереноса(ДанныеЗаполнения)
	
	ПериодРасчетаСреднего = УчетСреднегоЗаработка.ПериодРасчетаОбщегоСреднегоЗаработкаСотрудника(ДатаНачалаСобытия, Сотрудник, ВидРасчета);
	ПериодРасчетаСреднегоЗаработкаНачало	= ПериодРасчетаСреднего.ДатаНачала;
	ПериодРасчетаСреднегоЗаработкаОкончание = ПериодРасчетаСреднего.ДатаОкончания;
	
	ЗапрашиваемыеЗначения = Новый Структура;
	ЗапрашиваемыеЗначения.Вставить("Организация", "Организация");
	ЗапрашиваемыеЗначения.Вставить("Ответственный", "Ответственный");
	ЗапрашиваемыеЗначения.Вставить("Руководитель", "Руководитель");
	ЗапрашиваемыеЗначения.Вставить("ДолжностьРуководителя", "ДолжностьРуководителя");
	ЗапрашиваемыеЗначения.Вставить("ГлавныйБухгалтер", "ГлавныйБухгалтер");
	ЗапрашиваемыеЗначения.Вставить("Бухгалтер", "Бухгалтер");
	ЗарплатаКадры.ЗаполнитьЗначенияВФорме(ЭтотОбъект, ЗапрашиваемыеЗначения, ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве("Организация"));

КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.';
						|en = 'Invalid object call on the client.'");
#КонецЕсли