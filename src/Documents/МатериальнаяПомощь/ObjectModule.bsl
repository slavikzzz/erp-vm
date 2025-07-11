#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		
		Если ДанныеЗаполнения.Свойство("Действие") Тогда 
			Если ДанныеЗаполнения.Действие = "Исправить" Тогда
				ДокументыРазовыхНачислений.СкопироватьИсправляемыйДокумент(ЭтотОбъект, ДанныеЗаполнения.Ссылка,
					"ДокументРассчитан", 
					"НачисленияПерерасчет,
					|НДФЛ,
					|ПримененныеВычетыНаДетейИИмущественные,
					|РаспределениеРезультатовНачислений,
					|РаспределениеРезультатовУдержаний,
					|Удержания");
				ИсправленныйДокумент = ДанныеЗаполнения.Ссылка;
				
			ИначеЕсли ДанныеЗаполнения.Действие = "ЗаполнитьПоЗаявке" Тогда 
				Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.СамообслуживаниеСотрудников") Тогда 
					Модуль = ОбщегоНазначения.ОбщийМодуль("СамообслуживаниеСотрудников");
					Модуль.ОбработкаЗаполненияДокументаМатериальнаяПомощь(ЭтотОбъект, ДанныеЗаполнения, СтандартнаяОбработка);
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.ПроизвольныеКадровыеПриказы") Тогда
		МодульПроизвольныеКадровыеПриказы = ОбщегоНазначения.ОбщийМодуль("ПроизвольныеКадровыеПриказы");
		МодульПроизвольныеКадровыеПриказы.ОбработкаЗаполнения(ЭтотОбъект, ДанныеЗаполнения);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Документы.МатериальнаяПомощь.ПровестиПоУчетам(Ссылка, РежимПроведения, Отказ, Неопределено, Движения, ЭтотОбъект, ДополнительныеСвойства);
		
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ЗарплатаКадры.ПроверитьКорректностьДаты(Ссылка, ДатаНачала, "Объект.ДатаНачала", Отказ, НСтр("ru = 'Дата начала';
																								|en = 'Start date'"), , , Ложь);
	
	ИсправлениеДокументовЗарплатаКадры.ПроверитьЗаполнение(ЭтотОбъект, ПроверяемыеРеквизиты, Отказ, , "ПериодРегистрации");
	
	КонтейнерОшибок = Неопределено;
	ПроверитьЗаполнениеРеквизитовШапки(КонтейнерОшибок);
	ПроверитьЗаполнениеРеквизитовНеобходимыхДляРасчета(КонтейнерОшибок);
	ПроверитьПериодДействияНачислений(Отказ);
	ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(КонтейнерОшибок, Отказ);
	УдалитьПроверенныеРеквизиты(ПроверяемыеРеквизиты);
	
	Если ДокументРассчитан Тогда
		
		ЗарплатаКадры.ПроверитьДатуВыплаты(ЭтотОбъект, Отказ);
		
		// Проверка корректности распределения по источникам финансирования
		ИменаТаблицРаспределяемыхПоСтатьямФинансирования = "Начисления,НачисленияПерерасчет,Удержания,НДФЛ,КорректировкиВыплаты";
		
		ОтражениеЗарплатыВБухучетеРасширенный.ПроверитьРезультатыРаспределенияНачисленийУдержанийОбъекта(
			ЭтотОбъект, ИменаТаблицРаспределяемыхПоСтатьямФинансирования, Отказ, ВидРасчета);
		
		// Проверка корректности распределения по территориям и условиям труда
		ИменаТаблицРаспределенияПоТерриториямУсловиямТруда = "Начисления,НачисленияПерерасчет";
		
		РасчетЗарплатыРасширенный.ПроверитьРаспределениеПоТерриториямУсловиямТрудаДокумента(
			ЭтотОбъект, ИменаТаблицРаспределенияПоТерриториямУсловиямТруда, Отказ);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПерерасчетЗарплаты.УдалитьПерерасчетыПоРегистратору(Ссылка);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
		
	ДокументыРазовыхНачислений.ЗаполнитьРегистраторРазовыхНачисленийПередЗаписью(ЭтотОбъект);
	РасчетЗарплатыРасширенный.ЗаполнитьИсходныйДокумент(ЭтотОбъект);
	ОтражениеЗарплатыВБухучетеРасширенный.ОбновитьДанныеБухучетаДокументаПередЗаписью(ЭтотОбъект);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	ДанныеДляБухучета = Документы.МатериальнаяПомощь.ДанныеДляБухучетаЗарплатыПервичныхДокументов(ЭтотОбъект);
	ОтражениеЗарплатыВБухучетеРасширенный.ЗарегистрироватьБухучетЗарплатыПервичныхДокументов(ДанныеДляБухучета);
	
	УстановитьПривилегированныйРежим(Ложь);
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ДокументыРазовыхНачислений.ПриКопированииДокумента(ЭтотОбъект);
	РасчетЗарплатыРасширенный.ЗаполнитьИсходныйДокументПриКопировании(ЭтотОбъект, ОбъектКопирования.Ссылка);
	ПериодРегистрации = '00010101';
	
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
		ТекстСообщения = НСтр("ru = 'Не указан месяц начисления.';
								|en = 'Accrual month is not specified.'");
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(КонтейнерОшибок, "Объект.МесяцНачисления", ТекстСообщения, "");
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Организация) Тогда
		ТекстСообщения = НСтр("ru = 'Поле ""Организация"" обязательно к заполнению.';
								|en = 'Field ""Company"" is required.'");
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(КонтейнерОшибок, "Объект.Организация", ТекстСообщения, "");
	КонецЕсли;

КонецПроцедуры

Процедура ПроверитьЗаполнениеРеквизитовНеобходимыхДляРасчета(КонтейнерОшибок, ПроверкаПередРасчетом = Ложь)
	
	Если Не ЗначениеЗаполнено(ВидРасчета) Тогда
		ТекстСообщения = НСтр("ru = 'Поле ""Вид матпомощи"" обязательно к заполнению.';
								|en = 'The ""Support payment kind"" field is required.'");
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(КонтейнерОшибок, "Объект.ВидРасчета", ТекстСообщения, "");
	Иначе 
		
		ИнформацияОВидеРасчета = ЗарплатаКадры.ИнформацияОВидеРасчета(ВидРасчета);
		НачисляетсяВЦеломЗаМесяц = ИнформацияОВидеРасчета.НачисляетсяВЦеломЗаМесяц;
		
		Если НачисляетсяВЦеломЗаМесяц Тогда
			Если Не ЗначениеЗаполнено(ДатаНачала) И НЕ ЗначениеЗаполнено(ДатаОкончания) Тогда
				ТекстСообщения = НСтр("ru = 'Необходимо заполнить даты начала и окончания периода начисления.';
										|en = 'Enter start and end dates of accrual period.'");
				ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(КонтейнерОшибок, "Объект.ДатаНачала", ТекстСообщения, "");
			Иначе 
				Если Не ЗначениеЗаполнено(ДатаНачала) Тогда
					ТекстСообщения = НСтр("ru = 'Поле ""Дата начала"" обязательно к заполнению.';
											|en = 'Start date is required.'");
					ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(КонтейнерОшибок, "Объект.ДатаНачала", ТекстСообщения, "");
				КонецЕсли;
				
				Если Не ЗначениеЗаполнено(ДатаОкончания) Тогда
					ТекстСообщения = НСтр("ru = 'Поле ""Дата окончания"" обязательно к заполнению.';
											|en = 'Field ""End date"" is required.'");
					ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(КонтейнерОшибок, "Объект.ДатаОкончания", ТекстСообщения, "");
				КонецЕсли;
				Если ЗначениеЗаполнено(ДатаНачала) И ЗначениеЗаполнено(ДатаОкончания) И ДатаОкончания < ДатаНачала Тогда
					ТекстСообщения = НСтр("ru = 'Дата окончания не может быть меньше даты начала';
											|en = 'End date cannot be less than the start date'");
					ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(КонтейнерОшибок, "Объект.ДатаОкончания", ТекстСообщения, "");
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		Если ИнформацияОВидеРасчета.КодДоходаНДФЛ = Справочники.ВидыДоходовНДФЛ.Код2762 Тогда
			Отбор = Новый Структура("КоличествоДетей", 0);
			СтрокиОтбора = Начисления.НайтиСтроки(Отбор);
			Для Каждого СтрокаНачисления Из СтрокиОтбора Цикл
				ТекстСообщения = НСтр("ru = 'Поле ""Количество детей"" обязательно к заполнению.';
										|en = 'The ""Number of children"" field is required.'");
				ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(КонтейнерОшибок,
					"Объект.Начисления[%1].КоличествоДетей", ТекстСообщения, "", СтрокаНачисления.НомерСтроки - 1);
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	
	ПроверитьЗаполнениеПланируемойДатыВыплаты(КонтейнерОшибок, ПроверкаПередРасчетом);
	
КонецПроцедуры

Процедура ПроверитьЗаполнениеПланируемойДатыВыплаты(КонтейнерОшибок, ПроверкаПередРасчетом)
	
	МассивНачисленийДокумента = Новый Массив;
	МассивНачисленийДокумента.Добавить(ВидРасчета);
	
	Если Не ПроверкаПередРасчетом Тогда
		ОбщегоНазначенияКлиентСервер.ДополнитьМассив(МассивНачисленийДокумента, НачисленияПерерасчет.ВыгрузитьКолонку("Начисление"), Истина);
	КонецЕсли;
	
	Если УчетНДФЛРасширенный.ДатаВыплатыОбязательнаКЗаполнению(ПорядокВыплаты, МассивНачисленийДокумента)
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
	ПроверяемыеКоллекции.Добавить(РасчетЗарплатыРасширенный.ОписаниеКоллекцииДляПроверкиПериодаДействия("Удержания", НСтр("ru = 'Удержания';
																															|en = 'Deductions'"), "Удержание"));
	ПроверяемыеКоллекции.Добавить(РасчетЗарплатыРасширенный.ОписаниеКоллекцииДляПроверкиПериодаДействия("НачисленияПерерасчет", НСтр("ru = 'Перерасчет прошлого периода';
																																	|en = 'Recalculation of the last period'")));
	РасчетЗарплатыРасширенный.ПроверитьПериодДействияВКоллекцияхНачислений(ЭтотОбъект, ПараметрыПроверкиПериодаДействия, ПроверяемыеКоллекции, Отказ);
	
	ОписаниеВидаРасчета = ЗарплатаКадрыРасширенныйПовтИсп.ПолучитьИнформациюОВидеРасчета(ВидРасчета);
	РезультатПроверки = РасчетЗарплатыРасширенныйКлиентСервер.ПериодНачисленияЗаполненПравильно(ОписаниеВидаРасчета, ДатаНачала, ДатаОкончания);
	Если Не РезультатПроверки.ПериодНачисленияЗаполненПравильно Тогда
		Отказ = Истина;
		Если РезультатПроверки.ПериодБольшеМесяца Тогда
			ТекстПредупреждения = НСтр("ru = 'Период должен быть в пределах одного месяца';
										|en = 'Period should be within one month'");
		Иначе
			ТекстПредупреждения = НСтр("ru = 'Окончание периода должно быть позже его начала';
										|en = 'Period end should be later than its start'");
		КонецЕсли;
		ОбщегоНазначения.СообщитьПользователю(ТекстПредупреждения, Ссылка, "Объект.ДатаОкончания");
	КонецЕсли;
	
КонецПроцедуры

Процедура УдалитьПроверенныеРеквизиты(ПроверяемыеРеквизиты)
	
	Если ПроверяемыеРеквизиты = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "Организация");
	ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "ПланируемаяДатаВыплаты");
	ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "ВидРасчета");
	ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "ДатаНачала");
	ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "ДатаОкончания");
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.';
						|en = 'Invalid object call on the client.'");
#КонецЕсли