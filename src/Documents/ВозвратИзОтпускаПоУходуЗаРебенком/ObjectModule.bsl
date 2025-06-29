#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Документы.ВозвратИзОтпускаПоУходуЗаРебенком.ЗаполнитьДатуЗапретаРедактирования(ЭтотОбъект);
	
	Если Не Отказ Тогда
		Документы.УведомлениеОПрекращенииОтпускаПоУходуЗаРебенком.ПередЗаписьюОснованияУведомления(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ЗначениеЗаполнено(ДокументОснование) Тогда
		ДатаОтпуска = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДокументОснование, "ДатаНачала");
		Если ЗначениеЗаполнено(ДатаВозврата) И ДатаВозврата < ДатаОтпуска Тогда
			ЗарплатаКадры.ПроверитьКорректностьДаты(Ссылка, ДатаВозврата, "Объект.ДатаВозврата", Отказ,
				НСтр("ru = 'Дата возврата';
					|en = 'Return date'"), ДатаОтпуска, НСтр("ru = 'даты ухода в отпуск';
																|en = 'leave dates'"));
		КонецЕсли;
	КонецЕсли;
	
	ИсправлениеДокументовЗарплатаКадры.ПроверитьЗаполнение(ЭтотОбъект, ПроверяемыеРеквизиты, Отказ, "ПериодическиеСведения");
	
	ПараметрыПолученияСотрудниковОрганизаций = КадровыйУчет.ПараметрыПолученияРабочихМестВОрганизацийПоСпискуФизическихЛиц();
	ПараметрыПолученияСотрудниковОрганизаций.Организация 				= Организация;
	ПараметрыПолученияСотрудниковОрганизаций.НачалоПериода				= ДатаВозврата;
	ПараметрыПолученияСотрудниковОрганизаций.ОкончаниеПериода			= ДатаВозврата;
	ПараметрыПолученияСотрудниковОрганизаций.РаботникиПоДоговорамГПХ 	= Истина;
	
	СписокФизическихЛиц = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Сотрудник);

	КадровыйУчет.ПроверитьРаботающихФизическихЛиц(
		СписокФизическихЛиц,
		ПараметрыПолученияСотрудниковОрганизаций,
		Отказ,
		Новый Структура("ИмяПоляСотрудник, ИмяОбъекта", "Сотрудник", "Объект"));
	
	ЕстьДоговорыГПХ = КадровыйУчет.ЕстьДоговорыГПХ(Сотрудник, Организация);
	ОсновныеСотрудники = КадровыйУчет.ОсновныеСотрудникиФизическихЛиц(СписокФизическихЛиц, Истина, Организация, ДатаВозврата);
	Если Не ОсновныеСотрудники.Количество() > 0 
		И НЕ ЕстьДоговорыГПХ Тогда
		ТекстСообщения = НСтр("ru = '%1 не работает в организации на %2.';
								|en = '%1 does not work for the company on %2.'");
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, Сотрудник, Формат(ДатаВозврата,"ДЛФ=D"));
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,,"Объект.Сотрудник",, Отказ);
	КонецЕсли;

	КадровыйУчетРасширенный.ПроверкаСпискаНачисленийКадровогоДокумента(
		ЭтотОбъект, ДатаВозврата, "Начисления,Льготы", "Показатели", Отказ, Истина, "РабочееМесто", "Начисление,Льгота");
	
	ИсключаемыеРеквизиты = Новый Массив;
	
	Если Не ИзменитьНачисления Или НЕ НачисленияУтверждены Тогда
		ИсключаемыеРеквизиты.Добавить("Начисления.РабочееМесто");
	КонецЕсли;
	
	Если Не ИзменитьАванс Или НЕ НачисленияУтверждены Тогда
		ИсключаемыеРеквизиты.Добавить("Авансы.РабочееМесто");
		ИсключаемыеРеквизиты.Добавить("Авансы.СпособРасчетаАванса");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, ИсключаемыеРеквизиты);
	
	СотрудникиДаты = Новый ТаблицаЗначений;
	СотрудникиДаты.Колонки.Добавить("Сотрудник", Новый ОписаниеТипов("СправочникСсылка.Сотрудники"));
	СотрудникиДаты.Колонки.Добавить("Период", Новый ОписаниеТипов("Дата"));
	
	СотрудникиДокумента = ОбщегоНазначения.ВыгрузитьКолонку(Начисления, "РабочееМесто", Истина);
	Для Каждого РабочееМесто Из СотрудникиДокумента Цикл 
		НоваяСтрока = СотрудникиДаты.Добавить();
		НоваяСтрока.Сотрудник = РабочееМесто;
		НоваяСтрока.Период = ДатаВозврата;
	КонецЦикла;
	
	ЗарплатаКадрыРасширенный.ПроверитьНаличиеДокументовСФиксированнымСдвигомНаДату(СотрудникиДаты, Ссылка, Отказ, ИсправленныйДокумент);
	
	Если ИзменитьНачисления И НачисленияУтверждены Тогда 
		РасчетЗарплатыРасширенный.ПроверитьМножественностьОплатыВремениУходЗаРебенком(ДатаВозврата, Начисления, Ссылка, Отказ, , , ИсправленныйДокумент);
	КонецЕсли;
	
	КадровыйЭДО.ПроверитьВозможностьСохраненияИзмененийДокументаСПечатнымиФормами(
		ЭтотОбъект, Метаданные.Роли.ДобавлениеИзменениеДанныхДляНачисленияЗарплатыРасширенная, Отказ);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект, , , ЗначениеЗаполнено(ИсправленныйДокумент));
	ЗарплатаКадрыРасширенный.ИнициализироватьОтложеннуюРегистрациюВторичныхДанныхПоДвижениямДокумента(Движения);
	
	ИсправлениеДокументовЗарплатаКадры.ПриПроведенииИсправления(Ссылка, Движения, РежимПроведения, Отказ,,, ЭтотОбъект, "ДатаВозврата");
	
	// Начинаем состояние «Работа».
	ПараметрыСостояния = СостоянияСотрудников.ПараметрыСостоянияФизическогоЛица();
	ПараметрыСостояния.Состояние = Перечисления.СостоянияСотрудника.Работа; 
	ПараметрыСостояния.ДокументСсылка = Ссылка;
	ПараметрыСостояния.Организация = Организация;
	ПараметрыСостояния.Начало = ДатаВозврата; 
	СостоянияСотрудников.ЗарегистрироватьСостояниеФизическогоЛица(Движения, Сотрудник, ПараметрыСостояния);
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьРасчетЗарплатыРасширенная") Тогда
		Возврат;
	КонецЕсли;
		
	// Проведение документа
	ДанныеДляПроведения = ПолучитьДанныеДляПроведения();
	
	ЗарплатаКадрыРасширенный.УстановитьВремяРегистрацииДокумента(Движения, ДанныеДляПроведения.СотрудникиДаты, Ссылка);
	
	Если НачисленияУтверждены Тогда
		
		СтруктураПлановыхНачислений = Новый Структура;
		СтруктураПлановыхНачислений.Вставить("ДанныеОПлановыхНачислениях", ДанныеДляПроведения.ПлановыеНачисления);
		СтруктураПлановыхНачислений.Вставить("ЗначенияПоказателей", ДанныеДляПроведения.ЗначенияПоказателей);
		
		Если ДанныеДляПроведения.Свойство("ПрименениеДополнительныхПоказателей") Тогда
			СтруктураПлановыхНачислений.Вставить("ПрименениеДополнительныхПоказателей", ДанныеДляПроведения.ПрименениеДополнительныхПоказателей);
		КонецЕсли;
		
		РасчетЗарплаты.СформироватьДвиженияПлановыхНачислений(ЭтотОбъект, Движения, СтруктураПлановыхНачислений);
		
		РасчетЗарплатыРасширенный.СформироватьДвиженияПримененияПлановыхНачислений(Движения, ДанныеДляПроведения.ПрименениеНачислений);
		РасчетЗарплатыРасширенный.СформироватьДвиженияПорядкаПересчетаТарифныхСтавок(Движения, ДанныеДляПроведения.ПорядокПересчетаТарифнойСтавки);
		
		РасчетЗарплаты.СформироватьДвиженияПлановыхВыплат(Движения, ДанныеДляПроведения.ПлановыеАвансы)
		
	КонецЕсли;
	
	Сотрудники = КадровыйУчетРасширенный.МассивСотрудников(Сотрудник, Организация, ДатаВозврата);
	КадровыйУчетРасширенный.СформироватьДвиженияВозвратаВременноОсвобожденныхПозиции(Движения, Сотрудники, ДатаВозврата);
	
	УчетСтажаПФР.ЗарегистрироватьПериодыВУчетеСтажаПФР(Движения, ДанныеДляРегистрацииВУчетаСтажаПФР());
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	// Подготовка к регистрации перерасчетов
	ДанныеДляРегистрацииПерерасчетов = Новый МенеджерВременныхТаблиц;
		
	ПроведениеСервер.ПодготовитьНаборыЗаписейКУдалениюПроведения(ЭтотОбъект, ЗначениеЗаполнено(ИсправленныйДокумент));
		
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ОбъектОснование = ДанныеЗаполнения;
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") И ДанныеЗаполнения.Свойство("Сотрудник") Тогда
		ОбъектОснование = ДанныеЗаполнения.Сотрудник;
	КонецЕсли;
	
	Если ТипЗнч(ОбъектОснование) = Тип("СправочникСсылка.Сотрудники") Тогда
		
		ЗарплатаКадры.ЗаполнитьПоОснованиюСотрудником(ЭтотОбъект, ОбъектОснование);
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("РабочееМесто", ОбъектОснование);
		Запрос.Текст =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
		|	ОтпускПоУходуЗаРебенкомНачисления.Ссылка,
		|	ОтпускПоУходуЗаРебенкомНачисления.Ссылка.ДатаНачала КАК ДатаНачала
		|ИЗ
		|	Документ.ОтпускПоУходуЗаРебенком.Начисления КАК ОтпускПоУходуЗаРебенкомНачисления
		|ГДЕ
		|	ОтпускПоУходуЗаРебенкомНачисления.РабочееМесто = &РабочееМесто
		|	И ОтпускПоУходуЗаРебенкомНачисления.Ссылка.Проведен
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ ПЕРВЫЕ 1
		|	ИзменениеУсловийОплатыОтпускаПоУходуЗаРебенкомНачисления.Ссылка,
		|	ИзменениеУсловийОплатыОтпускаПоУходуЗаРебенкомНачисления.Ссылка.ДатаИзменения
		|ИЗ
		|	Документ.ИзменениеУсловийОплатыОтпускаПоУходуЗаРебенком.Начисления КАК ИзменениеУсловийОплатыОтпускаПоУходуЗаРебенкомНачисления
		|ГДЕ
		|	ИзменениеУсловийОплатыОтпускаПоУходуЗаРебенкомНачисления.РабочееМесто = &РабочееМесто
		|	И ИзменениеУсловийОплатыОтпускаПоУходуЗаРебенкомНачисления.Ссылка.Проведен
		|
		|УПОРЯДОЧИТЬ ПО
		|	ДатаНачала УБЫВ";
		
		РезультатЗапроса = Запрос.Выполнить();
		Если НЕ РезультатЗапроса.Пустой() Тогда
			
			Выборка = РезультатЗапроса.Выбрать();
			Выборка.Следующий();
			
			ОбъектОснование = Выборка.Ссылка;
			
		КонецЕсли; 
		
	КонецЕсли;
	
	Если ТипЗнч(ОбъектОснование) = Тип("ДокументСсылка.ОтпускПоУходуЗаРебенком") Тогда
		ЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ОбъектОснование, "Проведен, Организация, Сотрудник, ОсвобождатьСтавку");
		Если НЕ ЗначенияРеквизитов.Проведен Тогда
			ВызватьИсключение НСтр("ru = 'Ввод на основании непроведенного документа невозможен.';
									|en = 'You cannot use the ""input on basis"" method for unposted document.'");
		Иначе
			ЗаполнитьЗначенияСвойств(ЭтотОбъект, ЗначенияРеквизитов, "Организация, Сотрудник"); 
			ДокументОснование  	= ОбъектОснование;
		КонецЕсли;
	ИначеЕсли ТипЗнч(ОбъектОснование) = Тип("ДокументСсылка.ИзменениеУсловийОплатыОтпускаПоУходуЗаРебенком") Тогда
		ЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ОбъектОснование, "Проведен, Организация, Сотрудник, ДокументОснование");
		Если НЕ ЗначенияРеквизитов.Проведен Тогда
			ВызватьИсключение НСтр("ru = 'Ввод на основании непроведенного документа невозможен.';
									|en = 'You cannot use the ""input on basis"" method for unposted document.'");
		Иначе
			ЗаполнитьЗначенияСвойств(ЭтотОбъект, ЗначенияРеквизитов, "Организация, Сотрудник, ДокументОснование"); 
		КонецЕсли;
	ИначеЕсли ТипЗнч(ОбъектОснование) = Тип("Структура") Тогда
		Если ОбъектОснование.Свойство("Действие") И ОбъектОснование.Действие = "Исправить" Тогда
			ИсправлениеДокументовЗарплатаКадры.СкопироватьДокумент(ЭтотОбъект, ОбъектОснование.Ссылка);
			ИсправленныйДокумент = ОбъектОснование.Ссылка;
		КонецЕсли;
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.КадровыеРешения") Тогда
		МодульКадровыеРешения = ОбщегоНазначения.ОбщийМодуль("КадровыеРешения");
		МодульКадровыеРешения.ОбработкаЗаполненияКадровогоПриказа(ЭтотОбъект, ДанныеЗаполнения, СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьРеквизитыОснования(Реквизиты = "ВыплачиватьПособиеДоПолутораЛет,ДатаОкончанияПособияДоПолутораЛет,
	|КоличествоДетей,КоличествоПервыхДетей,
	|ВыплачиватьПособиеДоТрехЛет,ДатаОкончанияПособияДоТрехЛет") Экспорт
	
	Возврат ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДокументОснование, Реквизиты);
	
КонецФункции

#Область ПолучитьДанныеДляПроведения

Функция ПолучитьДанныеДляПроведения()
	
	ДанныеДляПроведения = Новый Структура; 
	
	Если НачисленияУтверждены Тогда
		
		ЗаполнитьПлановыеНачисленияИПоказатели(ДанныеДляПроведения);
		
		ЗаполнитьПлановыеАвансы(ДанныеДляПроведения);
		
		ЗаполнитьПрименениеПлановыхНачислений(ДанныеДляПроведения);
		
		ЗаполнитьПрименениеДополнительныхПоказателей(ДанныеДляПроведения);
		
		ЗаполнитьПересчетТарифныхСтавок(ДанныеДляПроведения);
		
		ЗаполнитьСовокупныеТарифныеСтавки(ДанныеДляПроведения);
		
	КонецЕсли;
	
	ЗаполнитьДанныеВремениРегистрацииДокумента(ДанныеДляПроведения);
	
	Возврат ДанныеДляПроведения;
	
КонецФункции

#Область ПлановыеНачисленияИПоказатели

Процедура ЗаполнитьПлановыеНачисленияИПоказатели(ДанныеДляПроведения)
	
	ПлановыеНачисления = РасчетЗарплатыРасширенный.ПустаяТаблицаРегистрацииПлановыхНачислений();
	ПлановыеНачисления.Колонки.Добавить("ИспользуетсяПоОкончании", Новый ОписаниеТипов("Булево"));
	
	ЗначенияПоказателей = РасчетЗарплатыРасширенный.ПустаяТаблицаРегистрацииЗначенийПериодическихПоказателей();
	
	ДобавитьПособияПоУходу(ПлановыеНачисления);
	
	Если ИзменитьНачисления Тогда
		ДобавитьПлановыеНачисления(ПлановыеНачисления);
	КонецЕсли;
	
	Если ИзменитьЛьготы Тогда
		ДобавитьЛьготы(ПлановыеНачисления);
	КонецЕсли;
	
	ДобавитьПлановыеПоказатели(ЗначенияПоказателей, ИзменитьНачисления, ИзменитьЛьготы);
	
	ДанныеДляПроведения.Вставить("ПлановыеНачисления", ПлановыеНачисления);
	ДанныеДляПроведения.Вставить("ЗначенияПоказателей", ЗначенияПоказателей);
	
КонецПроцедуры

Процедура ДобавитьПособияПоУходу(ПлановыеНачисления)
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	СоздатьВТПлановыеНачисленияСрезПоследних(Запрос);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПлановыеНачисления.Период КАК ДатаСобытия,
	|	ПлановыеНачисления.Сотрудник,
	|	ПлановыеНачисления.Начисление,
	|	ВЫРАЗИТЬ(ПлановыеНачисления.Сотрудник КАК Справочник.Сотрудники).ГоловнаяОрганизация КАК ГоловнаяОрганизация,
	|	ПлановыеНачисления.ФизическоеЛицо,
	|	ЛОЖЬ КАК Используется
	|ИЗ
	|	ВТПлановыеНачисленияСрезПоследних КАК ПлановыеНачисления";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		ЗаполнитьЗначенияСвойств(ПлановыеНачисления.Добавить(), Выборка);
	КонецЦикла;
		
КонецПроцедуры

Процедура ДобавитьПлановыеНачисления(ПлановыеНачисления)
	
	Запрос = ЗапросССсылкой();
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВозвратИзОтпускаПоУходуЗаРебенком.ДатаВозврата КАК ДатаСобытия,
	|	ВозвратИзОтпускаПоУходуЗаРебенкомНачисления.РабочееМесто КАК Сотрудник,
	|	ВозвратИзОтпускаПоУходуЗаРебенкомНачисления.Начисление,
	|	ВЫБОР
	|		КОГДА ВозвратИзОтпускаПоУходуЗаРебенкомНачисления.Действие = ЗНАЧЕНИЕ(Перечисление.ДействияСНачислениямиИУдержаниями.Отменить)
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК Используется,
	|	ВозвратИзОтпускаПоУходуЗаРебенком.Сотрудник КАК ФизическоеЛицо,
	|	ВозвратИзОтпускаПоУходуЗаРебенкомНачисления.ДокументОснование,
	|	ВозвратИзОтпускаПоУходуЗаРебенкомНачисления.Размер,
	|	ВозвратИзОтпускаПоУходуЗаРебенком.Организация.ГоловнаяОрганизация КАК ГоловнаяОрганизация
	|ИЗ
	|	Документ.ВозвратИзОтпускаПоУходуЗаРебенком.Начисления КАК ВозвратИзОтпускаПоУходуЗаРебенкомНачисления
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ВозвратИзОтпускаПоУходуЗаРебенком КАК ВозвратИзОтпускаПоУходуЗаРебенком
	|		ПО ВозвратИзОтпускаПоУходуЗаРебенкомНачисления.Ссылка = ВозвратИзОтпускаПоУходуЗаРебенком.Ссылка
	|ГДЕ
	|	ВозвратИзОтпускаПоУходуЗаРебенком.Ссылка = &Ссылка";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		ЗаполнитьЗначенияСвойств(ПлановыеНачисления.Добавить(), Выборка);
	КонецЦикла;
	
КонецПроцедуры

Процедура ДобавитьПлановыеПоказатели(ЗначенияПоказателей, ИзменитьНачисления, ИзменитьЛьготы)
	
	Если Не ИзменитьНачисления И Не ИзменитьЛьготы Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = ЗапросССсылкой();
	
	Запрос.УстановитьПараметр("ИзменитьНачисления", ИзменитьНачисления);
	Запрос.УстановитьПараметр("ИзменитьЛьготы", ИзменитьЛьготы);
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ВозвратИзОтпускаПоУходуЗаРебенком.Организация КАК Организация,
		|	ВозвратИзОтпускаПоУходуЗаРебенкомНачисления.РабочееМесто КАК Сотрудник,
		|	ВозвратИзОтпускаПоУходуЗаРебенком.Сотрудник КАК ФизическоеЛицо,
		|	ВозвратИзОтпускаПоУходуЗаРебенкомПоказатели.Показатель КАК Показатель,
		|	ВозвратИзОтпускаПоУходуЗаРебенкомНачисления.ДокументОснование КАК ДокументОснование,
		|	МАКСИМУМ(ВозвратИзОтпускаПоУходуЗаРебенкомПоказатели.Значение) КАК Значение,
		|	ВозвратИзОтпускаПоУходуЗаРебенком.ДатаВозврата КАК ДатаСобытия
		|ПОМЕСТИТЬ ВТПоказатели
		|ИЗ
		|	Документ.ВозвратИзОтпускаПоУходуЗаРебенком.Показатели КАК ВозвратИзОтпускаПоУходуЗаРебенкомПоказатели
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ВозвратИзОтпускаПоУходуЗаРебенком.Начисления КАК ВозвратИзОтпускаПоУходуЗаРебенкомНачисления
		|		ПО ВозвратИзОтпускаПоУходуЗаРебенкомПоказатели.Ссылка = ВозвратИзОтпускаПоУходуЗаРебенкомНачисления.Ссылка
		|			И ВозвратИзОтпускаПоУходуЗаРебенкомПоказатели.ИдентификаторСтрокиВидаРасчета = ВозвратИзОтпускаПоУходуЗаРебенкомНачисления.ИдентификаторСтрокиВидаРасчета
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ВозвратИзОтпускаПоУходуЗаРебенком КАК ВозвратИзОтпускаПоУходуЗаРебенком
		|		ПО ВозвратИзОтпускаПоУходуЗаРебенкомПоказатели.Ссылка = ВозвратИзОтпускаПоУходуЗаРебенком.Ссылка
		|ГДЕ
		|	ВозвратИзОтпускаПоУходуЗаРебенком.Ссылка = &Ссылка
		|	И &ИзменитьНачисления
		|
		|СГРУППИРОВАТЬ ПО
		|	ВозвратИзОтпускаПоУходуЗаРебенком.Организация,
		|	ВозвратИзОтпускаПоУходуЗаРебенкомНачисления.РабочееМесто,
		|	ВозвратИзОтпускаПоУходуЗаРебенком.Сотрудник,
		|	ВозвратИзОтпускаПоУходуЗаРебенкомПоказатели.Показатель,
		|	ВозвратИзОтпускаПоУходуЗаРебенкомНачисления.ДокументОснование,
		|	ВозвратИзОтпускаПоУходуЗаРебенком.ДатаВозврата
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ВозвратИзОтпускаПоУходуЗаРебенкомПоказатели.Ссылка.Организация,
		|	ВозвратИзОтпускаПоУходуЗаРебенкомПоказатели.Ссылка.Сотрудник,
		|	ВозвратИзОтпускаПоУходуЗаРебенкомЛьготы.РабочееМесто,
		|	ВозвратИзОтпускаПоУходуЗаРебенкомПоказатели.Показатель,
		|	ВозвратИзОтпускаПоУходуЗаРебенкомЛьготы.ДокументОснование,
		|	МАКСИМУМ(ВозвратИзОтпускаПоУходуЗаРебенкомПоказатели.Значение),
		|	ВозвратИзОтпускаПоУходуЗаРебенкомПоказатели.Ссылка.ДатаВозврата
		|ИЗ
		|	Документ.ВозвратИзОтпускаПоУходуЗаРебенком.Показатели КАК ВозвратИзОтпускаПоУходуЗаРебенкомПоказатели
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ВозвратИзОтпускаПоУходуЗаРебенком.Льготы КАК ВозвратИзОтпускаПоУходуЗаРебенкомЛьготы
		|		ПО ВозвратИзОтпускаПоУходуЗаРебенкомПоказатели.Ссылка = ВозвратИзОтпускаПоУходуЗаРебенкомЛьготы.Ссылка
		|			И ВозвратИзОтпускаПоУходуЗаРебенкомПоказатели.ИдентификаторСтрокиВидаРасчета = ВозвратИзОтпускаПоУходуЗаРебенкомЛьготы.ИдентификаторСтрокиВидаРасчета
		|ГДЕ
		|	ВозвратИзОтпускаПоУходуЗаРебенкомПоказатели.Ссылка = &Ссылка
		|	И &ИзменитьЛьготы
		|
		|СГРУППИРОВАТЬ ПО
		|	ВозвратИзОтпускаПоУходуЗаРебенкомПоказатели.Ссылка.Организация,
		|	ВозвратИзОтпускаПоУходуЗаРебенкомПоказатели.Ссылка.Сотрудник,
		|	ВозвратИзОтпускаПоУходуЗаРебенкомЛьготы.РабочееМесто,
		|	ВозвратИзОтпускаПоУходуЗаРебенкомПоказатели.Показатель,
		|	ВозвратИзОтпускаПоУходуЗаРебенкомЛьготы.ДокументОснование,
		|	ВозвратИзОтпускаПоУходуЗаРебенкомПоказатели.Ссылка.ДатаВозврата
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ВозвратИзОтпускаПоУходуЗаРебенкомПоказатели.Ссылка.Организация,
		|	ВозвратИзОтпускаПоУходуЗаРебенкомПоказатели.РабочееМесто,
		|	ВозвратИзОтпускаПоУходуЗаРебенкомПоказатели.Ссылка.Сотрудник,
		|	ВозвратИзОтпускаПоУходуЗаРебенкомПоказатели.Показатель,
		|	NULL,
		|	ВЫБОР
		|		КОГДА ВозвратИзОтпускаПоУходуЗаРебенкомПоказатели.Действие <> ЗНАЧЕНИЕ(Перечисление.ДействияСНачислениямиИУдержаниями.Отменить)
		|			ТОГДА ВозвратИзОтпускаПоУходуЗаРебенкомПоказатели.Значение
		|		ИНАЧЕ 0
		|	КОНЕЦ,
		|	ВозвратИзОтпускаПоУходуЗаРебенкомПоказатели.Ссылка.ДатаВозврата
		|ИЗ
		|	Документ.ВозвратИзОтпускаПоУходуЗаРебенком.Показатели КАК ВозвратИзОтпускаПоУходуЗаРебенкомПоказатели
		|ГДЕ
		|	ВозвратИзОтпускаПоУходуЗаРебенкомПоказатели.Ссылка = &Ссылка
		|	И ВозвратИзОтпускаПоУходуЗаРебенкомПоказатели.ИдентификаторСтрокиВидаРасчета = 0
		|	И ВозвратИзОтпускаПоУходуЗаРебенкомПоказатели.Показатель <> ЗНАЧЕНИЕ(Справочник.ПоказателиРасчетаЗарплаты.ПустаяСсылка)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Показатели.Организация КАК Организация,
		|	Показатели.Сотрудник КАК Сотрудник,
		|	Показатели.ФизическоеЛицо КАК ФизическоеЛицо,
		|	Показатели.Показатель КАК Показатель,
		|	Показатели.ДокументОснование КАК ДокументОснование,
		|	МАКСИМУМ(Показатели.Значение) КАК Значение,
		|	Показатели.ДатаСобытия КАК ДатаСобытия
		|ИЗ
		|	ВТПоказатели КАК Показатели
		|
		|СГРУППИРОВАТЬ ПО
		|	Показатели.Организация,
		|	Показатели.Сотрудник,
		|	Показатели.ФизическоеЛицо,
		|	Показатели.Показатель,
		|	Показатели.ДокументОснование,
		|	Показатели.ДатаСобытия";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		ЗаполнитьЗначенияСвойств(ЗначенияПоказателей.Добавить(), Выборка);
	КонецЦикла;
	
КонецПроцедуры

Процедура СоздатьВТПлановыеНачисленияСрезПоследних(Запрос)
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	&ДатаВозврата КАК Период,
	|	&ОсновнойСотрудник КАК Сотрудник
	|ПОМЕСТИТЬ ВТИзмеренияДаты";
	Запрос.УстановитьПараметр("ДатаВозврата", ДатаВозврата);
	Запрос.УстановитьПараметр("ОсновнойСотрудник", ОсновнойСотрудник);
	
	Запрос.Выполнить();
	
	КатегорииПособий = УчетПособийСоциальногоСтрахованияРасширенный.КатегорииНачисленийОплачивающихПособияПоУходуЗаРебенком();
	
	ПараметрыПостроения = ЗарплатаКадрыОбщиеНаборыДанных.ПараметрыПостроенияДляСоздатьВТИмяРегистраСрез();
	ЗарплатаКадрыОбщиеНаборыДанных.ДобавитьВКоллекциюОтбор(ПараметрыПостроения.Отборы, "Начисление.КатегорияНачисленияИлиНеоплаченногоВремени", "В", КатегорииПособий);
	
	ЗарплатаКадрыОбщиеНаборыДанных.СоздатьВТИмяРегистраСрезПоследних("ПлановыеНачисления", Запрос.МенеджерВременныхТаблиц,	Истина,
		ЗарплатаКадрыОбщиеНаборыДанных.ОписаниеФильтраДляСоздатьВТИмяРегистра("ВТИзмеренияДаты", "Сотрудник"), ПараметрыПостроения);
		
КонецПроцедуры

Процедура ДобавитьЛьготы(ПлановыеНачисления)
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ВозвратИзОтпускаПоУходуЗаРебенкомЛьготы.Ссылка.ДатаВозврата КАК ДатаСобытия,
		|	ВозвратИзОтпускаПоУходуЗаРебенкомЛьготы.РабочееМесто КАК Сотрудник,
		|	ВозвратИзОтпускаПоУходуЗаРебенкомЛьготы.Льгота КАК Начисление,
		|	ВЫБОР
		|		КОГДА ВозвратИзОтпускаПоУходуЗаРебенкомЛьготы.Действие = ЗНАЧЕНИЕ(Перечисление.ДействияСНачислениямиИУдержаниями.Отменить)
		|			ТОГДА ЛОЖЬ
		|		ИНАЧЕ ИСТИНА
		|	КОНЕЦ КАК Используется,
		|	ВозвратИзОтпускаПоУходуЗаРебенкомЛьготы.Ссылка.Сотрудник КАК ФизическоеЛицо,
		|	ВозвратИзОтпускаПоУходуЗаРебенкомЛьготы.ДокументОснование КАК ДокументОснование,
		|	ВозвратИзОтпускаПоУходуЗаРебенкомЛьготы.Размер КАК Размер,
		|	ВозвратИзОтпускаПоУходуЗаРебенкомЛьготы.Ссылка.Организация.ГоловнаяОрганизация КАК ГоловнаяОрганизация
		|ИЗ
		|	Документ.ВозвратИзОтпускаПоУходуЗаРебенком.Льготы КАК ВозвратИзОтпускаПоУходуЗаРебенкомЛьготы
		|ГДЕ
		|	ВозвратИзОтпускаПоУходуЗаРебенкомЛьготы.Ссылка = &Ссылка";
				   
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		ЗаполнитьЗначенияСвойств(ПлановыеНачисления.Добавить(), Выборка);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

Процедура ЗаполнитьПлановыеАвансы(ДанныеДляПроведения)
	
	ПлановыеАвансы =  ПустаяТаблицаРегистрацииПлановыхАвансов();
	
	Если ИзменитьАванс Тогда
		Запрос = ЗапросССсылкой();
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ВозвратИзОтпускаПоУходуЗаРебенком.ДатаВозврата КАК ДатаСобытия,
		|	ВозвратИзОтпускаПоУходуЗаРебенкомАвансы.РабочееМесто КАК Сотрудник,
		|	ВозвратИзОтпускаПоУходуЗаРебенкомАвансы.РабочееМесто.ГоловнаяОрганизация КАК ГоловнаяОрганизация,
		|	ЗНАЧЕНИЕ(ПЕРЕЧИСЛЕНИЕ.ВидыКадровыхСобытий.Перемещение) КАК ВидСобытия,
		|	ВозвратИзОтпускаПоУходуЗаРебенкомАвансы.СпособРасчетаАванса КАК СпособРасчетаАванса,
		|	ВозвратИзОтпускаПоУходуЗаРебенкомАвансы.Аванс КАК Аванс,
		|	ДАТАВРЕМЯ(1, 1, 1) КАК ДействуетДо,
		|	ВозвратИзОтпускаПоУходуЗаРебенком.Сотрудник КАК ФизическоеЛицо
		|ИЗ
		|	Документ.ВозвратИзОтпускаПоУходуЗаРебенком.Авансы КАК ВозвратИзОтпускаПоУходуЗаРебенкомАвансы
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ВозвратИзОтпускаПоУходуЗаРебенком КАК ВозвратИзОтпускаПоУходуЗаРебенком
		|		ПО ВозвратИзОтпускаПоУходуЗаРебенкомАвансы.Ссылка = ВозвратИзОтпускаПоУходуЗаРебенком.Ссылка
		|ГДЕ
		|	ВозвратИзОтпускаПоУходуЗаРебенком.Ссылка = &Ссылка";
		Выборка = Запрос.Выполнить().Выбрать();
		
		Пока Выборка.Следующий() Цикл
			ЗаполнитьЗначенияСвойств(ПлановыеАвансы.Добавить(), Выборка);
		КонецЦикла;
	КонецЕсли;
	
	ДанныеДляПроведения.Вставить("ПлановыеАвансы", ПлановыеАвансы);
	
КонецПроцедуры

Функция ПустаяТаблицаРегистрацииПлановыхАвансов()
	
	ТаблицаРегистрации = Новый ТаблицаЗначений;
	ТаблицаРегистрации.Колонки.Добавить("ДатаСобытия", 			Новый ОписаниеТипов("Дата"));
	ТаблицаРегистрации.Колонки.Добавить("Сотрудник", 			Новый ОписаниеТипов("СправочникСсылка.Сотрудники"));
	ТаблицаРегистрации.Колонки.Добавить("ГоловнаяОрганизация",	Новый ОписаниеТипов("СправочникСсылка.Организации"));
	ТаблицаРегистрации.Колонки.Добавить("ВидСобытия", 			Новый ОписаниеТипов("ПеречислениеСсылка.ВидыКадровыхСобытий"));
	ТаблицаРегистрации.Колонки.Добавить("СпособРасчетаАванса", 	Новый ОписаниеТипов("ПеречислениеСсылка.СпособыРасчетаАванса"));
	ТаблицаРегистрации.Колонки.Добавить("Аванс", 				Новый ОписаниеТипов("Число"));
	ТаблицаРегистрации.Колонки.Добавить("ДействуетДо", 			Новый ОписаниеТипов("Дата"));
	ТаблицаРегистрации.Колонки.Добавить("ФизическоеЛицо", 		Новый ОписаниеТипов("СправочникСсылка.ФизическиеЛица"));
	
	Возврат ТаблицаРегистрации;
	
КонецФункции

Процедура ЗаполнитьПрименениеПлановыхНачислений(ДанныеДляПроведения)
	
	ПрименениеНачислений = РасчетЗарплатыРасширенный.ПустаяТаблицаРегистрацииПримененияПлановыхНачислений();
	
	Запрос = ЗапросССсылкой();
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВозвратИзОтпускаПоУходуЗаРебенкомНачисления.РабочееМесто КАК Сотрудник,
	|	ВозвратИзОтпускаПоУходуЗаРебенком.ДатаВозврата КАК ДатаСобытия,
	|	МАКСИМУМ(ИСТИНА) КАК Применение
	|ИЗ
	|	Документ.ВозвратИзОтпускаПоУходуЗаРебенком.Начисления КАК ВозвратИзОтпускаПоУходуЗаРебенкомНачисления
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ВозвратИзОтпускаПоУходуЗаРебенком КАК ВозвратИзОтпускаПоУходуЗаРебенком
	|		ПО ВозвратИзОтпускаПоУходуЗаРебенкомНачисления.Ссылка = ВозвратИзОтпускаПоУходуЗаРебенком.Ссылка
	|ГДЕ
	|	ВозвратИзОтпускаПоУходуЗаРебенком.Ссылка = &Ссылка
	|
	|СГРУППИРОВАТЬ ПО
	|	ВозвратИзОтпускаПоУходуЗаРебенкомНачисления.РабочееМесто,
	|	ВозвратИзОтпускаПоУходуЗаРебенком.ДатаВозврата";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		ЗаполнитьЗначенияСвойств(ПрименениеНачислений.Добавить(), Выборка);
	КонецЦикла;

	ДанныеДляПроведения.Вставить("ПрименениеНачислений", ПрименениеНачислений);
	
КонецПроцедуры

Процедура ЗаполнитьПрименениеДополнительныхПоказателей(ДанныеДляПроведения)
	
	Если ИзменитьНачисления Тогда
		
		ПрименениеДополнительныхПоказателей = Неопределено;
		
		Запрос = ЗапросССсылкой();
		Запрос.Текст =
			"ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	ВозвратИзОтпускаПоУходуЗаРебенкомПоказатели.Ссылка,
			|	ВозвратИзОтпускаПоУходуЗаРебенкомПоказатели.Показатель,
			|	ВозвратИзОтпускаПоУходуЗаРебенкомПоказатели.РабочееМесто
			|ПОМЕСТИТЬ ВТПоказателиНачислений
			|ИЗ
			|	Документ.ВозвратИзОтпускаПоУходуЗаРебенком.Начисления КАК ВозвратИзОтпускаПоУходуЗаРебенкомНачисления
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ВозвратИзОтпускаПоУходуЗаРебенком.Показатели КАК ВозвратИзОтпускаПоУходуЗаРебенкомПоказатели
			|		ПО ВозвратИзОтпускаПоУходуЗаРебенкомНачисления.Ссылка = ВозвратИзОтпускаПоУходуЗаРебенкомПоказатели.Ссылка
			|			И ВозвратИзОтпускаПоУходуЗаРебенкомНачисления.РабочееМесто = ВозвратИзОтпускаПоУходуЗаРебенкомПоказатели.РабочееМесто
			|			И ВозвратИзОтпускаПоУходуЗаРебенкомНачисления.ИдентификаторСтрокиВидаРасчета = ВозвратИзОтпускаПоУходуЗаРебенкомПоказатели.ИдентификаторСтрокиВидаРасчета
			|ГДЕ
			|	ВозвратИзОтпускаПоУходуЗаРебенкомНачисления.Ссылка = &Ссылка
			|	И ВозвратИзОтпускаПоУходуЗаРебенкомНачисления.Действие <> ЗНАЧЕНИЕ(Перечисление.ДействияСНачислениямиИУдержаниями.Отменить)
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	ВозвратИзОтпускаПоУходуЗаРебенкомПоказатели.Ссылка.ДатаВозврата КАК ДатаСобытия,
			|	ВозвратИзОтпускаПоУходуЗаРебенкомПоказатели.Ссылка.Организация КАК Организация,
			|	ВозвратИзОтпускаПоУходуЗаРебенкомПоказатели.РабочееМесто КАК Сотрудник,
			|	ВозвратИзОтпускаПоУходуЗаРебенкомПоказатели.Ссылка.Сотрудник КАК ФизическоеЛицо,
			|	ВозвратИзОтпускаПоУходуЗаРебенкомПоказатели.Показатель КАК Показатель,
			|	ВЫБОР
			|		КОГДА ВозвратИзОтпускаПоУходуЗаРебенкомПоказатели.Действие = ЗНАЧЕНИЕ(Перечисление.ДействияСНачислениямиИУдержаниями.Отменить)
			|			ТОГДА ЛОЖЬ
			|		ИНАЧЕ ИСТИНА
			|	КОНЕЦ КАК Применение
			|ИЗ
			|	Документ.ВозвратИзОтпускаПоУходуЗаРебенком.Показатели КАК ВозвратИзОтпускаПоУходуЗаРебенкомПоказатели
			|		ЛЕВОЕ СОЕДИНЕНИЕ ВТПоказателиНачислений КАК ПоказателиНачислений
			|		ПО ВозвратИзОтпускаПоУходуЗаРебенкомПоказатели.Ссылка = ПоказателиНачислений.Ссылка
			|			И ВозвратИзОтпускаПоУходуЗаРебенкомПоказатели.РабочееМесто = ПоказателиНачислений.РабочееМесто
			|			И ВозвратИзОтпускаПоУходуЗаРебенкомПоказатели.Показатель = ПоказателиНачислений.Показатель
			|ГДЕ
			|	ВозвратИзОтпускаПоУходуЗаРебенкомПоказатели.Ссылка = &Ссылка
			|	И ВозвратИзОтпускаПоУходуЗаРебенкомПоказатели.ИдентификаторСтрокиВидаРасчета = 0
			|	И ВозвратИзОтпускаПоУходуЗаРебенкомПоказатели.Показатель <> ЗНАЧЕНИЕ(Справочник.ПоказателиРасчетаЗарплаты.ПустаяСсылка)
			|	И ПоказателиНачислений.Показатель ЕСТЬ NULL ";
		
		ПрименениеДополнительныхПоказателей = Запрос.Выполнить().Выгрузить();
		
		ДанныеДляПроведения.Вставить("ПрименениеДополнительныхПоказателей", ПрименениеДополнительныхПоказателей);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьПересчетТарифныхСтавок(ДанныеДляПроведения)
	
	ПорядокПересчетаТарифнойСтавки = Неопределено;
	
	Если ИзменитьНачисления Тогда
		Запрос = ЗапросССсылкой();
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ПересчетТарифныхСтавок.Ссылка.ДатаВозврата КАК ДатаСобытия,
		|	ПересчетТарифныхСтавок.РабочееМесто КАК Сотрудник,
		|	ПересчетТарифныхСтавок.Ссылка.Сотрудник КАК ФизическоеЛицо,
		|	ПересчетТарифныхСтавок.ПорядокРасчетаСтоимостиЕдиницыВремени КАК ПорядокРасчета,
		|	ДАТАВРЕМЯ(1, 1, 1) КАК ДействуетДо
		|ИЗ
		|	Документ.ВозвратИзОтпускаПоУходуЗаРебенком.ПересчетТарифныхСтавок КАК ПересчетТарифныхСтавок
		|ГДЕ
		|	ПересчетТарифныхСтавок.Ссылка = &Ссылка";
		ПорядокПересчетаТарифнойСтавки = Запрос.Выполнить().Выгрузить();
	КонецЕсли;
	
	ДанныеДляПроведения.Вставить("ПорядокПересчетаТарифнойСтавки", ПорядокПересчетаТарифнойСтавки);
	
КонецПроцедуры

Процедура ЗаполнитьСовокупныеТарифныеСтавки(ДанныеДляПроведения)
	
	ДанныеСовокупныхТарифныхСтавок = Неопределено;
	
	Если ИзменитьНачисления Тогда
		Запрос = ЗапросССсылкой();
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ПересчетТарифныхСтавок.Ссылка.ДатаВозврата КАК ДатаСобытия,
		|	ПересчетТарифныхСтавок.РабочееМесто КАК Сотрудник,
		|	ПересчетТарифныхСтавок.Ссылка.Сотрудник КАК ФизическоеЛицо,
		|	ПересчетТарифныхСтавок.СовокупнаяТарифнаяСтавка КАК Значение,
		|	ВЫБОР
		|		КОГДА ПересчетТарифныхСтавок.СовокупнаяТарифнаяСтавка = 0
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ВидыТарифныхСтавок.ПустаяСсылка)
		|		ИНАЧЕ ПересчетТарифныхСтавок.ВидТарифнойСтавки
		|	КОНЕЦ КАК ВидТарифнойСтавки,
		|	ДАТАВРЕМЯ(1, 1, 1) КАК ДействуетДо
		|ИЗ
		|	Документ.ВозвратИзОтпускаПоУходуЗаРебенком.ПересчетТарифныхСтавок КАК ПересчетТарифныхСтавок
		|ГДЕ
		|	ПересчетТарифныхСтавок.Ссылка = &Ссылка";
		ДанныеСовокупныхТарифныхСтавок = Запрос.Выполнить().Выгрузить();
	КонецЕсли;
	
	ДанныеДляПроведения.Вставить("ДанныеСовокупныхТарифныхСтавок", ДанныеСовокупныхТарифныхСтавок);
	
КонецПроцедуры

Процедура ЗаполнитьДанныеВремениРегистрацииДокумента(ДанныеДляПроведения)
	
	Запрос = ЗапросССсылкой();
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВозвратИзОтпускаПоУходуЗаРебенкомНачисления.РабочееМесто КАК Сотрудник,
	|	ВозвратИзОтпускаПоУходуЗаРебенкомНачисления.Ссылка.ДатаВозврата КАК ДатаСобытия
	|ИЗ
	|	Документ.ВозвратИзОтпускаПоУходуЗаРебенком.Начисления КАК ВозвратИзОтпускаПоУходуЗаРебенкомНачисления
	|ГДЕ
	|	ВозвратИзОтпускаПоУходуЗаРебенкомНачисления.Ссылка = &Ссылка";
	СотрудникиДаты = Запрос.Выполнить().Выгрузить();
	ДанныеДляПроведения.Вставить("СотрудникиДаты", СотрудникиДаты);
	
КонецПроцедуры

Функция ЗапросССсылкой()
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Возврат Запрос;
КонецФункции 

#КонецОбласти

Функция ДанныеДляРегистрацииВУчетаСтажаПФР()
	МассивСсылок = Новый Массив;
	МассивСсылок.Добавить(Ссылка);
	
	ДанныеДляРегистрацииВУчете = Документы.ВозвратИзОтпускаПоУходуЗаРебенком.ДанныеДляРегистрацииВУчетаСтажаПФР(МассивСсылок);
	
	Возврат ДанныеДляРегистрацииВУчете[Ссылка];
	
КонецФункции	

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.';
						|en = 'Invalid object call on the client.'");
#КонецЕсли