#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	ДатаСобытия = Дата;
	Для Каждого СтрокаСотрудника Из Сотрудники Цикл
		Если ДатаСобытия < СтрокаСотрудника.ДатаНачала Тогда
			ДатаСобытия = СтрокаСотрудника.ДатаНачала;
		КонецЕсли;
		Если Не ЗначениеЗаполнено(СтрокаСотрудника.ИдентификаторСтроки) Тогда
			СтрокаСотрудника.ИдентификаторСтроки = Новый УникальныйИдентификатор();
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.ЦепочкиДокументов") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("ЦепочкиДокументов");
		Модуль.УстановитьВторичныеРеквизитыДокументаЗамещения(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	ДанныеДляПроведения = ДанныеДляПроведения();
	
	РасчетЗарплатыРасширенный.СформироватьДвиженияПримененияПлановыхНачислений(
		Движения, ДанныеДляПроведения.ПрименениеПлановыхНачислений);
	
	СостоянияСотрудников.ЗарегистрироватьСостоянияСотрудников(
		Движения, Ссылка, ДанныеДляПроведения.ДанныеСостоянийСотрудников);
	
	КадровыйУчетРасширенный.СформироватьДвиженияЗанятостиВременноОсвобожденныхПозицииПоТаблицеЗначений(
		Движения, ДанныеДляПроведения.ЗанятостьПозицийШтатногоРасписания, Истина);
	
	ПараметрыФормирования = ЭлектронныеТрудовыеКнижки.ПараметрыФормированияДвиженийМероприятийТрудовойДеятельности();
	ПараметрыФормирования.ДополнитьСведениямиОЗанятости = Истина;
	ПараметрыФормирования.ДополнитьСведениямиОДолжности = Истина;
	ПараметрыФормирования.ПолучатьИсточникДанныхОТерриториальныхУсловиях = Истина;
	ПараметрыФормирования.ДополнитьСведениямиОТерриториальныхУсловиях = Истина;
	ПараметрыФормирования.ДополнитьСведениямиОКодахПоОКЗ = Истина;
	
	ЭлектронныеТрудовыеКнижки.СформироватьДвиженияМероприятийТрудовойДеятельности(
		Движения.МероприятияТрудовойДеятельности,
		ДанныеДляПроведения.МероприятияТрудовойДеятельности,
		ПараметрыФормирования);
	
	УчетСтажаПФР.ЗарегистрироватьПериодыВУчетеСтажаПФР(Движения, ДанныеДляПроведения.ПараметрыПериодовСтажаПФР);
	
	КонтрактыДоговорыСотрудников.СформироватьДвиженияПриостановленияТрудовыхДоговоровКонтрактов(
		Движения, ДанныеДляПроведения.ПриостановленияТрудовыхДоговоровКонтрактов)
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.Сотрудники") Тогда
		ЗарплатаКадры.ЗаполнитьПоОснованиюСотрудником(ЭтотОбъект, ДанныеЗаполнения);
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("Структура") И ДанныеЗаполнения.Свойство("Сотрудник") Тогда
		ЗарплатаКадры.ЗаполнитьПоОснованиюСотрудником(ЭтотОбъект, ДанныеЗаполнения.Сотрудник);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	СтрокиСотрудниковДокумента = Новый Соответствие;
	Для Каждого СтрокаСотрудника Из Сотрудники Цикл
		
		Если СтрокиСотрудниковДокумента.Получить(СтрокаСотрудника.Сотрудник) = Неопределено Тогда
			СтрокиСотрудниковДокумента.Вставить(СтрокаСотрудника.Сотрудник, СтрокаСотрудника.НомерСтроки);
		Иначе
			ТекстСообщения = НСтр("ru = 'В строке %1 повторяется Сотрудник %2';
									|en = 'In line %1 Employee %2 is repeated'");
			ПутьКДанным = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Сотрудники", СтрокаСотрудника.НомерСтроки, "Сотрудник");
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, Ссылка, , ПутьКДанным, Отказ);
		КонецЕсли;
		
		ПутьКДате = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Сотрудники", СтрокаСотрудника.НомерСтроки, "ДатаНачала");
		ЗарплатаКадры.ПроверитьКорректностьДаты(
			Ссылка, СтрокаСотрудника.ДатаНачала, ПутьКДате, Отказ, НСтр("ru = 'дата начала приостановления';
																		|en = 'suspension start date'"), '20220901');
		
		ПутьКДате = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Сотрудники", СтрокаСотрудника.НомерСтроки, "ДатаОкончания");
		ЗарплатаКадры.ПроверитьКорректностьДаты(
			Ссылка, СтрокаСотрудника.ДатаОкончания, ПутьКДате, Отказ, НСтр("ru = 'дата окончания приостановления';
																			|en = 'suspension end date'"),
			СтрокаСотрудника.ДатаНачала + ЗарплатаКадрыКлиентСервер.ДлительностьСутокВСекундах(),
			НСтр("ru = 'даты начала приостановления';
				|en = 'suspension start dates'"), Ложь);
		
	КонецЦикла;
	
	КадровыйУчет.ПроверитьРаботающихСотрудниковТабличнойЧастиДокумента(ЭтотОбъект, "Сотрудники", "ДатаНачала", "ДатаОкончания", Отказ);
	
	Если Не Отказ Тогда
		
		ОтборКадровыхДанных = Новый Массив;
		ЗарплатаКадрыОбщиеНаборыДанных.ДобавитьВКоллекциюОтбор(
			ОтборКадровыхДанных, "Регистратор", "<>", Ссылка);
		
		ПоляОтбора = Новый Структура("ПриостановленияТрудовыхДоговоровКонтрактов", ОтборКадровыхДанных);
		
		КадровыеДанные = КадровыйУчет.КадровыеДанныеСотрудников(Истина, Сотрудники.ВыгрузитьКолонку("Сотрудник"),
			"ТрудовойДоговорПриостановлен,ТрудовойДоговорПриостановленРегистратор", Дата, ПоляОтбора);
		
		Для Каждого СтрокаСотрудника Из Сотрудники Цикл
			
			ДанныеСотрудника = КадровыеДанные.НайтиСтроки(Новый Структура("Сотрудник", СтрокаСотрудника.Сотрудник));
			Если ДанныеСотрудника.Количество() > 0 Тогда
				
				Если ДанныеСотрудника[0].ТрудовойДоговорПриостановлен = Истина Тогда
					ТекстСообщения = СтрШаблон(
						НСтр("ru = 'Трудовой договор с сотрудником %1 уже приостановлен документом %2';
							|en = 'Employment contract with employee %1 is already terminated by the %2 document'"),
						СтрокаСотрудника.Сотрудник,
						ДанныеСотрудника[0].ТрудовойДоговорПриостановленРегистратор);
					ПутьКДанным = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Сотрудники", СтрокаСотрудника.НомерСтроки, "Сотрудник");
					ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, Ссылка, , ПутьКДанным, Отказ);
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Получает данные для формирования движений.
// Возвращает Структуру с полями.
//		КадровыеДвижения - данные, необходимые для формирования 
//				- кадровой истории (см. КадровыйУчетРасширенный.СформироватьКадровыеДвижения)
//				- авансов (см. РасчетЗарплаты.СформироватьДвиженияПлановыхВыплат)
//				- истории применяемых графиков работы (см. КадровыйУчетРасширенный.СформироватьИсториюИзмененияГрафиков).
//		ПлановыеНачисления - данные, необходимые для формирования истории плановых начислений.
//		(см. РасчетЗарплатыРасширенный.СформироватьДвиженияПлановыхНачислений)
//		ЗначенияПоказателей (см. там же).
//
Функция ДанныеДляПроведения()
	
	ДанныеДляПроведения = Новый Структура;
	ЗаполнитьПрименениеПлановыхНачислений(ДанныеДляПроведения);
	ЗаполнитьДанныеСостоянийСотрудников(ДанныеДляПроведения);
	ЗаполнитьЗанятостьПозицийШтатногоРасписания(ДанныеДляПроведения);
	ЗаполнитьМероприятияТрудовойДеятельности(ДанныеДляПроведения);
	ЗаполнитьПараметрыПериодовСтажаПФР(ДанныеДляПроведения);
	ЗаполнитьПриостановленияТрудовыхДоговоровКонтрактов(ДанныеДляПроведения);
	
	Возврат ДанныеДляПроведения;
	
КонецФункции

Процедура ЗаполнитьПрименениеПлановыхНачислений(ДанныеДляПроведения)
	
	ПрименениеНачислений = РасчетЗарплатыРасширенный.ПустаяТаблицаРегистрацииПримененияПлановыхНачислений();
	Для каждого СтрокаСотрудников Из Сотрудники Цикл
		ПрименениеНачисленийСотрудник = ПрименениеНачислений.Добавить();
		ПрименениеНачисленийСотрудник.Сотрудник = СтрокаСотрудников.Сотрудник;
		ПрименениеНачисленийСотрудник.ДатаСобытия = СтрокаСотрудников.ДатаНачала;
		ПрименениеНачисленийСотрудник.Применение = Ложь;
	КонецЦикла;
	
	ДанныеДляПроведения.Вставить("ПрименениеПлановыхНачислений", ПрименениеНачислений);
	
КонецПроцедуры

Процедура ЗаполнитьДанныеСостоянийСотрудников(ДанныеДляПроведения)
	
	ДанныеСостояний = СостоянияСотрудников.ПустаяТаблицаДанныхСостоянийСотрудника();
	Для каждого СтрокаСотрудников Из Сотрудники Цикл
		ДанныеСостоянийСотрудника = ДанныеСостояний.Добавить();
		ДанныеСостоянийСотрудника.Сотрудник = СтрокаСотрудников.СОтрудник;
		ДанныеСостоянийСотрудника.Состояние = Перечисления.СостоянияСотрудника.ТрудовойДоговорПриостановлен;
		ДанныеСостоянийСотрудника.Начало = СтрокаСотрудников.ДатаНачала;
		ДанныеСостоянийСотрудника.ВидВремени = Справочники.ВидыИспользованияРабочегоВремени.ПриостановлениеТрудовогоДоговора;
		ДанныеСостоянийСотрудника.ОкончаниеПредположительно = СтрокаСотрудников.ДатаОкончания;
	КонецЦикла;
	
	ДанныеДляПроведения.Вставить("ДанныеСостоянийСотрудников", ДанныеСостояний);
	
КонецПроцедуры

Процедура ЗаполнитьЗанятостьПозицийШтатногоРасписания(ДанныеДляПроведения)
	
	Если ОсвобождатьСтавки Тогда
		СотрудникиПериоды = Сотрудники.Выгрузить(,"Сотрудник,ДатаНачала,ДатаОкончания");
	Иначе
		СотрудникиПериоды = КадровыйУчетРасширенный.ПустаяТаблицаЗначенийСотрудникиПериоды();
	КонецЕсли;
	
	ДанныеДляПроведения.Вставить("ЗанятостьПозицийШтатногоРасписания", СотрудникиПериоды);
	
КонецПроцедуры

Процедура ЗаполнитьМероприятияТрудовойДеятельности(ДанныеДляПроведения)
	
	Мероприятия = Новый Массив;
	Если ОтразитьВТрудовойКнижке Тогда
		Для Каждого СтрокаСотрудников Из Сотрудники Цикл
			Мероприятие = ЭлектронныеТрудовыеКнижки.ПустаяСтруктураЗаписиОТрудовойДеятельности();
			Мероприятие.Регистратор = Ссылка;
			Мероприятие.Организация = Организация;
			Мероприятие.ФизическоеЛицо = КадровыйУчетПовтИсп.ФизическоеЛицоСотрудника(СтрокаСотрудников.Сотрудник);
			Мероприятие.Сотрудник = СтрокаСотрудников.Сотрудник;
			Мероприятие.ДатаМероприятия = СтрокаСотрудников.ДатаНачала;
			Мероприятие.ВидМероприятия = Перечисления.ВидыМероприятийТрудовойДеятельности.Приостановление;
			Мероприятие.НаименованиеДокументаОснования = НаименованиеДокумента;
			Мероприятие.НомерДокументаОснования = ЗарплатаКадрыОтчеты.НомерНаПечать(Номер, НомерПриказа);
			Мероприятие.ДатаДокументаОснования = Дата;
			Мероприятие.ОтразитьТерриториальныеУсловияПоТерриторииВыполненияРабот = ОтразитьТерриториальныеУсловияПоТерриторииВыполненияРабот;
			Мероприятия.Добавить(Мероприятие);
		КонецЦикла;
	КонецЕсли;
	ДанныеДляПроведения.Вставить("МероприятияТрудовойДеятельности", Мероприятия);
	
КонецПроцедуры

Процедура ЗаполнитьПараметрыПериодовСтажаПФР(ДанныеДляПроведения)
	
	ДанныеДляРегистрацииВУчетеПоДокументу = УчетСтажаПФР.ДанныеДляРегистрацииВУчетеСтажаПФР();
	Для Каждого СтрокаСотрудников Из Сотрудники Цикл
		ОписаниеПериода = УчетСтажаПФР.ОписаниеРегистрируемогоПериода();
		ОписаниеПериода.Сотрудник = СтрокаСотрудников.Сотрудник;
		ОписаниеПериода.ДатаНачалаПериода = СтрокаСотрудников.ДатаНачала;
		ОписаниеПериода.ДатаНачалаСобытия = СтрокаСотрудников.ДатаНачала;
		ОписаниеПериода.Состояние = Перечисления.СостоянияСотрудника.ТрудовойДоговорПриостановлен;
		РегистрируемыйПериод = УчетСтажаПФР.ДобавитьЗаписьВДанныеДляРегистрацииВУчета(ДанныеДляРегистрацииВУчетеПоДокументу, ОписаниеПериода);
		
		Если ОснованиеПриостановления = Справочники.ОснованияПриостановленияТрудовыхДоговоровКонтрактов.Контракт3517
			Или ОснованиеПриостановления = Справочники.ОснованияПриостановленияТрудовыхДоговоровКонтрактов.Содействие3517
			Или ОснованиеПриостановления = Справочники.ОснованияПриостановленияТрудовыхДоговоровКонтрактов.Мобилизация3517 Тогда
			
			ВидСтажаПФР = Перечисления.ВидыСтажаПФР2014.ВОЕНСЛ;
		Иначе
			ВидСтажаПФР = Перечисления.ВидыСтажаПФР2014.НеВключаетсяВСтраховойСтаж;
		КонецЕсли;
		
		УчетСтажаПФР.УстановитьЗначениеРегистрируемогоРесурса(РегистрируемыйПериод, "ВидСтажаПФР", ВидСтажаПФР);
	КонецЦикла;
	ДанныеДляПроведения.Вставить("ПараметрыПериодовСтажаПФР", ДанныеДляРегистрацииВУчетеПоДокументу);
	
КонецПроцедуры

Процедура ЗаполнитьПриостановленияТрудовыхДоговоровКонтрактов(ДанныеДляПроведения)
	ПриостановленияДоговоров = Новый Массив;
	Для Каждого СтрокаСотрудников Из Сотрудники Цикл
		Запись = КонтрактыДоговорыСотрудников.ПустаяЗаписьПриостановленияТрудовыхДоговоровКонтрактов();
		Запись.Период = СтрокаСотрудников.ДатаНачала;
		Запись.Сотрудник = СтрокаСотрудников.Сотрудник;
		Запись.ФизическоеЛицо = КадровыйУчетПовтИсп.ФизическоеЛицоСотрудника(Запись.Сотрудник);
		Запись.Организация = Организация;
		Запись.Приостановлен = Истина;
		Запись.ОснованиеПриостановления = ОснованиеПриостановления;
		Запись.НомерПриказа = ЗарплатаКадрыОтчеты.НомерНаПечать(Номер, НомерПриказа);
		Запись.ДатаПриказа = Дата;
		Запись.ПланируемаяДатаЗавершения = СтрокаСотрудников.ДатаОкончания;
		ПриостановленияДоговоров.Добавить(Запись);
	КонецЦикла;
	ДанныеДляПроведения.Вставить("ПриостановленияТрудовыхДоговоровКонтрактов", ПриостановленияДоговоров);
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.';
						|en = 'Invalid object call on the client.'");
#КонецЕсли