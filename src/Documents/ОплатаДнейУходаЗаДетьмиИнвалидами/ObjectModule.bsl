#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.Сотрудники") Тогда
		ЗарплатаКадры.ЗаполнитьПоОснованиюСотрудником(ЭтотОбъект, ДанныеЗаполнения);
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		Если ДанныеЗаполнения.Свойство("Действие") И ДанныеЗаполнения.Действие = "Исправить" Тогда
			
			ИсправлениеДокументовЗарплатаКадры.СкопироватьДокумент(ЭтотОбъект, ДанныеЗаполнения.Ссылка,
				"ДокументРассчитан", 
				"Начисления,
				|НачисленияПерерасчет,
				|НачисленияПерерасчетНулевыеСторно,
				|НДФЛ,
				|ПримененныеВычетыНаДетейИИмущественные,
				|РаспределениеРезультатовНачислений,
				|РаспределениеРезультатовУдержаний,
				|Удержания",
				ДанныеЗаполнения);
			
			ИсправленныйДокумент = ДанныеЗаполнения.Ссылка;

		ИначеЕсли ДанныеЗаполнения.Свойство("Действие") И ДанныеЗаполнения.Действие = "ЗаполнитьПоПараметрамЗаполнения" Тогда
			ЗаполнитьПоПараметрамЗаполнения(ДанныеЗаполнения);
		ИначеЕсли ДанныеЗаполнения.Свойство("Действие") И ДанныеЗаполнения.Действие = "ЗаполнитьПослеПереноса" Тогда
			ЗаполнитьПослеПереноса(ДанныеЗаполнения);
		ИначеЕсли ДанныеЗаполнения.Свойство("Сотрудник") И ЗначениеЗаполнено(ДанныеЗаполнения.Сотрудник) Тогда
			ЗарплатаКадры.ЗаполнитьПоОснованиюСотрудником(ЭтотОбъект, ДанныеЗаполнения.Сотрудник);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Документы.ОплатаДнейУходаЗаДетьмиИнвалидами.ПровестиПоУчетам(Ссылка, РежимПроведения, Отказ, Неопределено, Движения, ЭтотОбъект, ДополнительныеСвойства);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
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
	
	ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(КонтейнерОшибок, Отказ);
	
	УдалитьПроверенныеРеквизиты(ПроверяемыеРеквизиты);
	
	КадровыйЭДО.ПроверитьВозможностьСохраненияИзмененийДокументаСПечатнымиФормами(
		ЭтотОбъект, Метаданные.Роли.ДобавлениеИзменениеНачисленнойЗарплатыРасширенная, Отказ);
	
	КоличествоДней = ДниУхода.Количество();
	Если КоличествоДней > 1 И Год(ДниУхода[0].Дата) <> Год(ДниУхода[КоличествоДней-1].Дата) Тогда
		Текст = НСтр("ru = 'Выбраны дни в разных годах';
					|en = 'Days in different years are selected'");
		СообщенияБЗК.СообщитьОбОшибкеВОбъекте(Отказ, ЭтотОбъект, Текст, "ДниУхода");
	КонецЕсли;
	Если КоличествоДней > 0 И ЗначениеЗаполнено(Сотрудник) Тогда
		МесяцыУхода = Документы.ОплатаДнейУходаЗаДетьмиИнвалидами.МесяцыУхода(ДниУхода);
		Если ИспользоватьОстатокДнейЗаГод Тогда
			Если ИзбыточноВключенФлажокИспользоватьОстатокДнейЗаГод() Тогда
				Текст = СтрШаблон(
					НСтр("ru = 'Избыточно включен флажок ""%1""';
						|en = 'The %1 check box selection is not required'"),
					Метаданные().Реквизиты.ИспользоватьОстатокДнейЗаГод.Представление());
				СообщенияБЗК.СообщитьОбОшибкеВОбъекте(Отказ, ЭтотОбъект, Текст, "ИспользоватьОстатокДнейЗаГод");
			ИначеЕсли ПроверитьОтсутствиеДругихДокументовСФлажкомЗаЭтотГод(Отказ) Тогда
				ПроверитьОграничениеДнейПоСотрудникуЗаГод(Отказ);
			КонецЕсли;
		Иначе
			Для Каждого МесяцУхода Из МесяцыУхода Цикл
				Если МесяцУхода.КоличествоДней > 4 Тогда
					Если МесяцУхода.НачалоМесяца >= Документы.ОплатаДнейУходаЗаДетьмиИнвалидами.ДатаНачалаПримененияОстаткаДнейЗаГод() Тогда
						Текст = СтрШаблон(
							НСтр("ru = 'За %1 использовано более 4 дней. Требуется включить флажок ""%2""';
								|en = 'For %1, more than 4 days are used. Select the %2 check box'"),
							Формат(МесяцУхода.НачалоМесяца, "ДФ=MMMM"),
							Метаданные().Реквизиты.ИспользоватьОстатокДнейЗаГод.Представление());
						СообщенияБЗК.СообщитьОбОшибкеВОбъекте(Отказ, ЭтотОбъект, Текст, "ИспользоватьОстатокДнейЗаГод");
					Иначе
						Текст = СтрШаблон(
							НСтр("ru = 'За %1 использовано более 4 дней';
								|en = 'For %1, more than 4 days are used'"),
							Формат(МесяцУхода.НачалоМесяца, "ДФ=MMMM"));
						СообщенияБЗК.СообщитьОбОшибкеВОбъекте(Отказ, ЭтотОбъект, Текст, "ДниУхода");
					КонецЕсли;
				КонецЕсли;
			КонецЦикла;
			ПроверитьОграничениеДнейПоСотрудникуЗаМесяцы(Отказ, МесяцыУхода);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПерерасчетЗарплаты.УдалитьПерерасчетыПоРегистратору(Ссылка);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьСотрудникаВТаблицахНачислений();
	
	МесяцыУхода = Документы.ОплатаДнейУходаЗаДетьмиИнвалидами.МесяцыУхода(ДниУхода);
	ПредставлениеПериода = Документы.ОплатаДнейУходаЗаДетьмиИнвалидами.ПредставлениеПериодовУхода(МесяцыУхода);
	
	РасчетЗарплатыРасширенный.ЗаполнитьИсходныйДокумент(ЭтотОбъект);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	УчетСреднегоЗаработка.ЗаписатьДатуНачалаСобытия(Ссылка, Сотрудник, ДатаНачалаСобытия);
	
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
	
	Если ДниУхода.Количество() = 0 Тогда
		ТекстСообщения = НСтр("ru = 'Не указаны дни ухода за детьми-инвалидами.';
								|en = 'Disabled child care days are not specified.'");
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(КонтейнерОшибок, "Объект.ДниУхода", ТекстСообщения, "");
	КонецЕсли;

КонецПроцедуры

Процедура ПроверитьЗаполнениеРеквизитовНеобходимыхДляРасчета(КонтейнерОшибок, ПроверкаПередРасчетом = Ложь)
	
	Если Не ДокументРассчитан И Не ПроверкаПередРасчетом Тогда
		Возврат;
	КонецЕсли;	
	
	Если Не ЗначениеЗаполнено(ВидРасчета) 
		И Не ПолучитьФункциональнуюОпцию("ВыбиратьВидНачисленияОплатыДнейУходаЗаДетьмиИнвалидами") Тогда
		ТекстСообщения = Документы.ОплатаДнейУходаЗаДетьмиИнвалидами.ТекстСообщенияНеЗаполненВидРасчета();
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
	ПроверяемыеКоллекции.Добавить(РасчетЗарплатыРасширенный.ОписаниеКоллекцииДляПроверкиПериодаДействия("НачисленияПерерасчет", НСтр("ru = 'Перерасчет прошлого периода';
																																	|en = 'Recalculation of the last period'")));
	ПроверяемыеКоллекции.Добавить(РасчетЗарплатыРасширенный.ОписаниеКоллекцииДляПроверкиПериодаДействия("Удержания", НСтр("ru = 'Удержания';
																															|en = 'Deductions'"), "Удержание"));
	РасчетЗарплатыРасширенный.ПроверитьПериодДействияВКоллекцияхНачислений(ЭтотОбъект, ПараметрыПроверкиПериодаДействия, ПроверяемыеКоллекции, Отказ);
КонецПроцедуры

Процедура УдалитьПроверенныеРеквизиты(ПроверяемыеРеквизиты)
	
	Если ПроверяемыеРеквизиты = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "Организация");
	ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "Сотрудник");
	ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "ПланируемаяДатаВыплаты");
	ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "ДниУхода");
	ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "ВидРасчета");
	
КонецПроцедуры

Функция ИзбыточноВключенФлажокИспользоватьОстатокДнейЗаГод()
	Возврат Документы.ОплатаДнейУходаЗаДетьмиИнвалидами.ИзбыточноВключенФлажокИспользоватьОстатокДнейЗаГод(ЭтотОбъект);
КонецФункции

Функция ПроверитьОтсутствиеДругихДокументовСФлажкомЗаЭтотГод(Отказ)
	УстановитьПривилегированныйРежим(Истина);
	Если Не ЗначениеЗаполнено(Сотрудник) Тогда
		Возврат Истина;
	КонецЕсли;
	НачалоГода = НачалоГода(ДниУхода[0].Дата);
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ТаблицаДней.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.ОплатаДнейУходаЗаДетьмиИнвалидами КАК Шапка
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ОплатаДнейУходаЗаДетьмиИнвалидами.ДниУхода КАК ТаблицаДней
	|		ПО ТаблицаДней.Ссылка = Шапка.Ссылка
	|			И (ТаблицаДней.Дата МЕЖДУ &НачалоГода И &КонецГода)
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ОплатаДнейУходаЗаДетьмиИнвалидами КАК Шапка2
	|		ПО Шапка.Ссылка = Шапка2.ИсправленныйДокумент
	|			И (Шапка2.Проведен
	|				ИЛИ Шапка2.Ссылка = &Ссылка)
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.СторнированиеНачислений КАК Сторнирование
	|		ПО Шапка.Ссылка = Сторнирование.СторнируемыйДокумент
	|			И (Сторнирование.Проведен)
	|ГДЕ
	|	Шапка.Сотрудник = &Сотрудник
	|	И Шапка.ИспользоватьОстатокДнейЗаГод
	|	И Шапка.Проведен
	|	И Шапка.Ссылка <> &Ссылка
	|	И Шапка.Ссылка <> &ИсправленныйДокумент
	|	И Шапка2.Ссылка ЕСТЬ NULL
	|	И Сторнирование.Ссылка ЕСТЬ NULL";
	Запрос.УстановитьПараметр("Сотрудник",  Сотрудник);
	Запрос.УстановитьПараметр("НачалоГода", НачалоГода);
	Запрос.УстановитьПараметр("КонецГода",  КонецГода(НачалоГода));
	Запрос.УстановитьПараметр("Ссылка",     Ссылка);
	Запрос.УстановитьПараметр("ИсправленныйДокумент", ИсправленныйДокумент);
	
	Таблица = Запрос.Выполнить().Выгрузить();
	Для Каждого СтрокаТаблицы Из Таблица Цикл
		Текст = СтрШаблон(
			НСтр("ru = 'В %1 году по сотруднику %2 обнаружен другой документ с флажком ""%3"": %4';
				|en = 'In %1, another document with the selected %3 check box is found for employee %2: %4'"),
			Формат(НачалоГода, "ДФ=yyyy"),
			Строка(Сотрудник),
			Метаданные().Реквизиты.ИспользоватьОстатокДнейЗаГод.Представление(),
			Строка(СтрокаТаблицы.Ссылка));
		СообщенияБЗК.СообщитьОбОшибкеВОбъекте(Отказ, ЭтотОбъект, Текст, "ИспользоватьОстатокДнейЗаГод");
		Возврат Ложь;
	КонецЦикла;
	
	Возврат Истина;
КонецФункции

Функция ПроверитьОграничениеДнейПоСотрудникуЗаГод(Отказ)
	Если Не ЗначениеЗаполнено(Сотрудник) Тогда
		Возврат Истина;
	КонецЕсли;
	ИспользованоДней = ДниУхода.Количество();
	Если ИспользованоДней > 24 Тогда
		Текст = СтрШаблон(
			НСтр("ru = 'Выбрано более 24 дней (%1).';
				|en = 'Over 24 days are selected (%1).'"),
			ПредставлениеКоличестваДней(ИспользованоДней));
		СообщенияБЗК.СообщитьОбОшибкеВОбъекте(Отказ, ЭтотОбъект, Текст, "ДниУхода");
		Возврат Ложь;
	КонецЕсли;
	КонецМесяца = КонецМесяца(ДниУхода[0].Дата);
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ТаблицаДней.Дата) КАК КоличествоДней
	|ИЗ
	|	Документ.ОплатаДнейУходаЗаДетьмиИнвалидами КАК Шапка
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ОплатаДнейУходаЗаДетьмиИнвалидами.ДниУхода КАК ТаблицаДней
	|		ПО Шапка.Ссылка = ТаблицаДней.Ссылка
	|			И (ТаблицаДней.Дата МЕЖДУ &НачалоГода И &КонецМесяца)
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ОплатаДнейУходаЗаДетьмиИнвалидами КАК Шапка2
	|		ПО Шапка.Ссылка = Шапка2.ИсправленныйДокумент
	|			И (Шапка2.Проведен
	|				ИЛИ Шапка2.Ссылка = &Ссылка)
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.СторнированиеНачислений КАК Сторнирование
	|		ПО Шапка.Ссылка = Сторнирование.СторнируемыйДокумент
	|			И (Сторнирование.Проведен)
	|ГДЕ
	|	Шапка.Сотрудник = &Сотрудник
	|	И Шапка.Проведен
	|	И Шапка.Ссылка <> &Ссылка
	|	И Шапка.Ссылка <> &ИсправленныйДокумент
	|	И Шапка2.Ссылка ЕСТЬ NULL
	|	И Сторнирование.Ссылка ЕСТЬ NULL";
	Запрос.УстановитьПараметр("Сотрудник",   Сотрудник);
	Запрос.УстановитьПараметр("НачалоГода",  НачалоГода(КонецМесяца));
	Запрос.УстановитьПараметр("КонецМесяца", КонецМесяца);
	Запрос.УстановитьПараметр("Ссылка",      Ссылка);
	Запрос.УстановитьПараметр("ИсправленныйДокумент", ИсправленныйДокумент);
	
	УстановитьПривилегированныйРежим(Истина);
	Таблица           = Запрос.Выполнить().Выгрузить();
	ИспользованоРанее = Таблица.Итог("КоличествоДней");
	Доступно          = Месяц(КонецМесяца) * 4;
	Остаток           = Доступно - ИспользованоРанее;
	Если Остаток < ИспользованоДней Тогда
		Текст = СтрШаблон(
			НСтр("ru = 'Превышен остаток дней в год. По состоянию на %1 доступно %2, использовано ранее %3, остаток (%4) меньше требуемого количества: %5.';
				|en = 'The number of remaining days for the year is exceeded. As of %1, %2 days are available, and %3 days were previously used. The number of remaining days (%4) is less than required: %5.'"),
			Формат(КонецМесяца, "ДЛФ=D"),
			ПредставлениеКоличестваДней(Доступно),
			ПредставлениеКоличестваДней(ИспользованоРанее),
			ПредставлениеКоличестваДней(Остаток),
			ПредставлениеКоличестваДней(ИспользованоДней));
		СообщенияБЗК.СообщитьОбОшибкеВОбъекте(Отказ, ЭтотОбъект, Текст, "ДниУхода");
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
КонецФункции

// Возвращает представление количества дней.
Функция ПредставлениеКоличестваДней(КоличествоДнейЧислом)
	Если КоличествоДнейЧислом = 0 Тогда
		Возврат НСтр("ru = '0 дней';
					|en = '0 days'");
	Иначе
		Возврат СтроковыеФункцииКлиентСервер.СтрокаСЧисломДляЛюбогоЯзыка(
			НСтр("ru = ';%1 день;;%1 дня;%1 дней;';
				|en = ';%1 day;;%1 days;%1 days;'"),
			КоличествоДнейЧислом);
	КонецЕсли;
КонецФункции

Процедура ПроверитьОграничениеДнейПоСотрудникуЗаМесяцы(Отказ, МесяцыУхода)
	Если Не ЗначениеЗаполнено(Сотрудник) Тогда
		Возврат;
	КонецЕсли;
	КонецМесяца = КонецМесяца(ДниУхода[0].Дата);
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	МесяцыУхода.НачалоМесяца КАК НачалоМесяца,
	|	МесяцыУхода.КоличествоДней КАК КоличествоДней
	|ПОМЕСТИТЬ МесяцыУхода
	|ИЗ
	|	&МесяцыУхода КАК МесяцыУхода
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	НАЧАЛОПЕРИОДА(МесяцыУхода.НачалоМесяца, ГОД) КАК НачалоГода,
	|	КОНЕЦПЕРИОДА(МесяцыУхода.НачалоМесяца, ГОД) КАК КонецГода,
	|	МИНИМУМ(МесяцыУхода.НачалоМесяца) КАК НачалоПервогоМесяцаВГоду,
	|	МАКСИМУМ(МесяцыУхода.НачалоМесяца) КАК НачалоПоследнегоМесяцаВГоду,
	|	МАКСИМУМ(КОНЕЦПЕРИОДА(МесяцыУхода.НачалоМесяца, МЕСЯЦ)) КАК КонецПоследнегоМесяцаВГоду
	|ПОМЕСТИТЬ ГодыУхода
	|ИЗ
	|	МесяцыУхода КАК МесяцыУхода
	|
	|СГРУППИРОВАТЬ ПО
	|	НАЧАЛОПЕРИОДА(МесяцыУхода.НачалоМесяца, ГОД),
	|	КОНЕЦПЕРИОДА(МесяцыУхода.НачалоМесяца, ГОД)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаДней.Дата КАК Дата,
	|	Шапка.Ссылка КАК Ссылка,
	|	НАЧАЛОПЕРИОДА(ТаблицаДней.Дата, ГОД) КАК НачалоГода,
	|	НАЧАЛОПЕРИОДА(ТаблицаДней.Дата, МЕСЯЦ) КАК НачалоМесяца,
	|	Шапка.ИспользоватьОстатокДнейЗаГод КАК ИспользоватьОстатокДнейЗаГод
	|ПОМЕСТИТЬ ДанныеДокументов
	|ИЗ
	|	Документ.ОплатаДнейУходаЗаДетьмиИнвалидами КАК Шапка
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ГодыУхода КАК ГодыУхода
	|		ПО (ИСТИНА)
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ОплатаДнейУходаЗаДетьмиИнвалидами.ДниУхода КАК ТаблицаДней
	|		ПО Шапка.Ссылка = ТаблицаДней.Ссылка
	|			И (ТаблицаДней.Дата МЕЖДУ ГодыУхода.НачалоГода И ГодыУхода.КонецГода)
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ОплатаДнейУходаЗаДетьмиИнвалидами КАК Шапка2
	|		ПО Шапка.Ссылка = Шапка2.ИсправленныйДокумент
	|			И (Шапка2.Проведен
	|				ИЛИ Шапка2.Ссылка = &Ссылка)
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.СторнированиеНачислений КАК Сторнирование
	|		ПО Шапка.Ссылка = Сторнирование.СторнируемыйДокумент
	|			И (Сторнирование.Проведен)
	|ГДЕ
	|	Шапка.Сотрудник = &Сотрудник
	|	И Шапка.Проведен
	|	И Шапка.Ссылка <> &Ссылка
	|	И Шапка.Ссылка <> &ИсправленныйДокумент
	|	И Шапка2.Ссылка ЕСТЬ NULL
	|	И Сторнирование.Ссылка ЕСТЬ NULL
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ДанныеДокументов.Дата) КАК ИспользованоЗаМесяц,
	|	ДанныеДокументов.НачалоГода КАК НачалоГода,
	|	ДанныеДокументов.НачалоМесяца КАК НачалоМесяца
	|ПОМЕСТИТЬ ИтогиДокументовБезФлажка
	|ИЗ
	|	ДанныеДокументов КАК ДанныеДокументов
	|ГДЕ
	|	НЕ ДанныеДокументов.ИспользоватьОстатокДнейЗаГод
	|
	|СГРУППИРОВАТЬ ПО
	|	ДанныеДокументов.НачалоГода,
	|	ДанныеДокументов.НачалоМесяца
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДанныеДокументов.Ссылка КАК Ссылка,
	|	МИНИМУМ(ДанныеДокументов.НачалоМесяца) КАК НачалоПервогоМесяца,
	|	ДанныеДокументов.НачалоГода КАК НачалоГода,
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ДанныеДокументов.Дата) КАК ИспользованоДней
	|ПОМЕСТИТЬ ИтогиДокументовСФлажком1
	|ИЗ
	|	ДанныеДокументов КАК ДанныеДокументов
	|ГДЕ
	|	ДанныеДокументов.ИспользоватьОстатокДнейЗаГод
	|
	|СГРУППИРОВАТЬ ПО
	|	ДанныеДокументов.Ссылка,
	|	ДанныеДокументов.НачалоГода
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ИтогиДокументовСФлажком1.Ссылка КАК Ссылка,
	|	ИтогиДокументовСФлажком1.НачалоПервогоМесяца КАК НачалоПервогоМесяца,
	|	ИтогиДокументовСФлажком1.НачалоГода КАК НачалоГода,
	|	ИтогиДокументовСФлажком1.ИспользованоДней КАК ИспользованоДней,
	|	СУММА(МесяцыУхода.КоличествоДней) КАК ИспользованоТекущимДокументом
	|ПОМЕСТИТЬ ИтогиДокументовСФлажком2
	|ИЗ
	|	ИтогиДокументовСФлажком1 КАК ИтогиДокументовСФлажком1
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ МесяцыУхода КАК МесяцыУхода
	|		ПО ИтогиДокументовСФлажком1.НачалоПервогоМесяца >= МесяцыУхода.НачалоМесяца
	|			И (ИтогиДокументовСФлажком1.НачалоГода = НАЧАЛОПЕРИОДА(МесяцыУхода.НачалоМесяца, ГОД))
	|
	|СГРУППИРОВАТЬ ПО
	|	ИтогиДокументовСФлажком1.Ссылка,
	|	ИтогиДокументовСФлажком1.НачалоПервогоМесяца,
	|	ИтогиДокументовСФлажком1.НачалоГода,
	|	ИтогиДокументовСФлажком1.ИспользованоДней
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СУММА(ВЫБОР
	|			КОГДА ИтогиДокументовБезФлажка.НачалоМесяца = МесяцыУхода.НачалоМесяца
	|				ТОГДА ИтогиДокументовБезФлажка.ИспользованоЗаМесяц
	|			ИНАЧЕ 0
	|		КОНЕЦ) КАК ИспользованоРанееЗаМесяц,
	|	МесяцыУхода.НачалоМесяца КАК НачалоМесяца
	|ИЗ
	|	ИтогиДокументовБезФлажка КАК ИтогиДокументовБезФлажка
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ МесяцыУхода КАК МесяцыУхода
	|		ПО ИтогиДокументовБезФлажка.НачалоМесяца <= МесяцыУхода.НачалоМесяца
	|			И (ИтогиДокументовБезФлажка.НачалоГода = НАЧАЛОПЕРИОДА(МесяцыУхода.НачалоМесяца, ГОД))
	|
	|СГРУППИРОВАТЬ ПО
	|	МесяцыУхода.НачалоМесяца
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ИтогиДокументовСФлажком2.Ссылка КАК Ссылка,
	|	ИтогиДокументовСФлажком2.НачалоПервогоМесяца КАК НачалоПервогоМесяца,
	|	ИтогиДокументовСФлажком2.ИспользованоДней КАК ИспользованоДней,
	|	ИтогиДокументовСФлажком2.ИспользованоТекущимДокументом КАК ИспользованоТекущимДокументом,
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ДанныеДокументовБезФлажка.Дата) КАК ИспользованоРанее
	|ИЗ
	|	ИтогиДокументовСФлажком2 КАК ИтогиДокументовСФлажком2
	|		ЛЕВОЕ СОЕДИНЕНИЕ ДанныеДокументов КАК ДанныеДокументовБезФлажка
	|		ПО ИтогиДокументовСФлажком2.НачалоГода = ДанныеДокументовБезФлажка.НачалоГода
	|			И ИтогиДокументовСФлажком2.НачалоПервогоМесяца >= ДанныеДокументовБезФлажка.НачалоМесяца
	|			И ИтогиДокументовСФлажком2.Ссылка <> ДанныеДокументовБезФлажка.Ссылка
	|			И (НЕ ДанныеДокументовБезФлажка.ИспользоватьОстатокДнейЗаГод)
	|
	|СГРУППИРОВАТЬ ПО
	|	ИтогиДокументовСФлажком2.Ссылка,
	|	ИтогиДокументовСФлажком2.НачалоПервогоМесяца,
	|	ИтогиДокументовСФлажком2.ИспользованоДней,
	|	ИтогиДокументовСФлажком2.ИспользованоТекущимДокументом";
	Запрос.УстановитьПараметр("МесяцыУхода", МесяцыУхода);
	Запрос.УстановитьПараметр("Сотрудник",   Сотрудник);
	Запрос.УстановитьПараметр("НачалоГода",  НачалоГода(КонецМесяца));
	Запрос.УстановитьПараметр("КонецМесяца", КонецМесяца);
	Запрос.УстановитьПараметр("Ссылка",      Ссылка);
	Запрос.УстановитьПараметр("ИсправленныйДокумент", ИсправленныйДокумент);
	
	УстановитьПривилегированныйРежим(Истина);
	РезультатыЗапроса = Запрос.ВыполнитьПакет();
	ПерваяТаблица = РезультатыЗапроса[РезультатыЗапроса.Количество()-2].Выгрузить();
	ВтораяТаблица = РезультатыЗапроса[РезультатыЗапроса.Количество()-1].Выгрузить();
	// Анализ остатков по месяцам из расчета 4 дня в месяц.
	Для Каждого СтрокаТаблицы Из ПерваяТаблица Цикл
		МесяцУхода = МесяцыУхода.Найти(СтрокаТаблицы.НачалоМесяца, "НачалоМесяца");
		Доступно   = 4;
		Остаток    = Доступно - СтрокаТаблицы.ИспользованоРанееЗаМесяц;
		Если Остаток < МесяцУхода.КоличествоДней Тогда
			Текст = СтрШаблон(
				НСтр("ru = 'Превышен остаток дней за %1: доступно %2, использовано ранее %3, остаток %4 меньше требуемого количества: %5.';
					|en = 'The number of remaining days for %1 is exceeded: %2 days are available, %3 days were previously used. The number of remaining days (%4) is less than required: %5.'"),
				Формат(СтрокаТаблицы.НачалоМесяца, "ДФ=MMMM"),
				ПредставлениеКоличестваДней(Доступно),
				ПредставлениеКоличестваДней(СтрокаТаблицы.ИспользованоРанееЗаМесяц),
				ПредставлениеКоличестваДней(Остаток),
				ПредставлениеКоличестваДней(МесяцУхода.КоличествоДней));
			СообщенияБЗК.СообщитьОбОшибкеВОбъекте(Отказ, ЭтотОбъект, Текст, "ДниУхода");
		КонецЕсли;
	КонецЦикла;
	// Анализ что более поздние документы которые списывают остаток за год все еще вписываются в ограничение.
	Для Каждого СтрокаТаблицы Из ВтораяТаблица Цикл
		Доступно          = Месяц(СтрокаТаблицы.НачалоПервогоМесяца) * 4;
		ИспользованоРанее = СтрокаТаблицы.ИспользованоРанее + СтрокаТаблицы.ИспользованоДней;
		Остаток           = Доступно - ИспользованоРанее;
		Если Остаток >= 0 И Остаток < СтрокаТаблицы.ИспользованоТекущимДокументом Тогда
			Текст = СтрШаблон(
				НСтр("ru = 'При проведении данного документа будет превышен остаток с учётом более поздних проведённых документов на %1. Документом ""%2"" использовано %3. По состоянию на %4 с учетом всех документов потребуется %5, что больше доступного количества: %6.';
					|en = 'When you post this document, the number of remaining days will be exceeded considering more recently posted documents as of %1. The %2 document has used %3. As of %4, considering all the documents, %5 will be required, which is greater that the available quantity: %6.'"),
				ПредставлениеКоличестваДней(СтрокаТаблицы.ИспользованоТекущимДокументом - Остаток),
				СтрокаТаблицы.Ссылка,
				ПредставлениеКоличестваДней(СтрокаТаблицы.ИспользованоДней),
				НРег(Формат(СтрокаТаблицы.НачалоПервогоМесяца, "ДФ='ММММ yyyy'")),
				ПредставлениеКоличестваДней(ИспользованоРанее + СтрокаТаблицы.ИспользованоТекущимДокументом),
				ПредставлениеКоличестваДней(Доступно));
			СообщенияБЗК.СообщитьОбОшибкеВОбъекте(Отказ, ЭтотОбъект, Текст, "ДниУхода");
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

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

	Если ЗначениеЗаполнено(ДатаНачала) Тогда
		
		Если Не ЗначениеЗаполнено(ДатаОкончания) Тогда
			ДатаОкончания = ДатаНачала;
		КонецЕсли;
		
		ОчереднаяДата = ДатаНачала;
		Пока ОчереднаяДата <= ДатаОкончания Цикл
			НоваяСтрока = ДниУхода.Добавить();
	        НоваяСтрока.Дата = ОчереднаяДата;
			ОчереднаяДата = ОчереднаяДата + 86400;
		КонецЦикла;
		
	КонецЕсли;
	
	ПериодРасчетаСреднего = УчетСреднегоЗаработка.ПериодРасчетаОбщегоСреднегоЗаработкаСотрудника(ДатаНачалаСобытия, Сотрудник);
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

Процедура ЗаполнитьПоПараметрамЗаполнения(ДанныеЗаполнения)
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
	
	ЗаполняемыеЗначения = Новый Структура(
		"ПериодРегистрации, 
		|Ответственный");
	ЗарплатаКадры.ПолучитьЗначенияПоУмолчанию(ЗаполняемыеЗначения, ТекущаяДатаСеанса());
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ЗаполняемыеЗначения);
	
	Если ДанныеЗаполнения.Свойство("ДниУхода") Тогда
		Для каждого ДеньУхода Из ДанныеЗаполнения.ДниУхода Цикл
			НовыйДеньУхода = ДниУхода.Добавить();
			ЗаполнитьЗначенияСвойств(НовыйДеньУхода, ДеньУхода);
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.';
						|en = 'Invalid object call on the client.'");
#КонецЕсли
