
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Перем РезультатПроверки;
	
	Если ЗначениеЗаполнено(Параметры.ПроверяемыйРегистратор) Тогда
		
		МетаданныеРегистратора = Параметры.ПроверяемыйРегистратор.Метаданные();
		Если МетаданныеРегистратора.Реквизиты.Найти("Организация") <> Неопределено Тогда
			Организация = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Параметры.ПроверяемыйРегистратор, "Организация");
		КонецЕсли; 
		
	КонецЕсли; 
	
	Если ТипЗнч(Параметры.ДанныеОЗанятыхПозициях) <> Тип("Строка") Тогда
		ДанныеОЗанятыхПозициях = Новый ФиксированныйМассив(Параметры.ДанныеОЗанятыхПозициях);
		НесколькоПроблем = ДанныеОЗанятыхПозициях.Количество() > 1;
	Иначе
		ДанныеОЗанятыхПозициях = Параметры.ДанныеОЗанятыхПозициях;
		НесколькоПроблем = ПолучитьИзВременногоХранилища(ДанныеОЗанятыхПозициях).Количество() > 1;
	КонецЕсли;	
	
	// Отключено использование штатного расписания, выполняется только проверка соответствия грейдам.
	ПроверкаСоответствияГрейдам = Параметры.Свойство("ПроверкаСоответствияГрейдам");
	
	ПроверкаПередЗаписью = Параметры.ПроверкаПередЗаписью;
	ПроверяемыйРегистратор = Параметры.ПроверяемыйРегистратор;
	ИсправленныйДокумент = НеОпределено;
	Параметры.Свойство("ИсправленныйДокумент", ИсправленныйДокумент);
	Если НЕ Параметры.ПроверкаПередЗаписью Тогда
		КадровыйУчетРасширенный.ПроверкаСоответствияШтатномуРасписанию(ДанныеОЗанятыхПозициях, ПроверяемыйРегистратор, Ложь, АдресРезультатаПроверки, ИсправленныйДокумент);
	Иначе
		АдресРезультатаПроверки = Параметры.РезультатыПроверки;
	КонецЕсли;
	Если ЗначениеЗаполнено(АдресРезультатаПроверки) Тогда
		РезультатПроверки = ПолучитьИзВременногоХранилища(АдресРезультатаПроверки);
	КонецЕсли; 
	ОтобразитьРезультатПроверкиВФорме(РезультатПроверки);
	
	Если ПроверкаСоответствияГрейдам Тогда 
		Заголовок = НСтр("ru = 'Проверка соответствия грейдам';
						|en = 'Check compliance with grades'");
		АвтоЗаголовок = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Перепроверить(Команда)
	ПерепроверитьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ОК(Команда)
	Закрыть(СтруктураРезультатаПроверки("ОК"));
КонецПроцедуры

&НаКлиенте
Процедура ПродолжитьЗапись(Команда)
	Закрыть(СтруктураРезультатаПроверки("Продолжить"));
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	Закрыть(СтруктураРезультатаПроверки("Отмена"));
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьДокумент(Команда)
	ДанныеТекущейСтроки = Элементы.ДокументыНеСоотвШтатномуРасписанию.ТекущиеДанные;
	Если ДанныеТекущейСтроки <> Неопределено И ЗначениеЗаполнено(ДанныеТекущейСтроки.Документ) Тогда
		ПараметрыОткрытия = Новый Структура("Ключ", ДанныеТекущейСтроки.Документ);
		ОткрытьФорму(ПолучитьИмяФормыДокумента(ДанныеТекущейСтроки.Документ), ПараметрыОткрытия);
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПозициюШтатногоРасписания(Команда)
	ДанныеТекущейСтроки = Элементы.ДокументыНеСоотвШтатномуРасписанию.ТекущиеДанные;
	Если ДанныеТекущейСтроки <> Неопределено И ЗначениеЗаполнено(ДанныеТекущейСтроки.ПозицияШтатногоРасписания) Тогда
		ОткрытьФормуПозицииШтатногоРасписания(ДанныеТекущейСтроки.ПозицияШтатногоРасписания);
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиКШтатномуРасписанию(Команда)
	
	СтруктураОтбора = Новый Структура;
	СтруктураОтбора.Вставить("Владелец", Организация);
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("Отбор", СтруктураОтбора);
	
	ОткрытьФорму("Справочник.ШтатноеРасписание.ФормаСписка", ПараметрыОткрытия);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_РаботаСГрейдами()
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.Грейды") Тогда 
		Модуль = ОбщегоНазначенияКлиент.ОбщийМодуль("ГрейдыКлиент");
		Модуль.ОткрытьФормуРаботаСГрейдами();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Функция ПолучитьИмяФормыДокумента(Документ)
	Возврат Документ.Метаданные().ПолноеИмя() + ".ФормаОбъекта";	
КонецФункции	

&НаСервере
Процедура ПерепроверитьНаСервере()
	
	Перем РезультатПроверки;
	
	// Результат проверки не следует сохранять на сервере.
	ДокументыНеСоотвШтатномуРасписанию.Очистить();
	АдресРезультатаПроверки = "";
	
	КадровыйУчетРасширенный.ПроверкаСоответствияШтатномуРасписанию(ДанныеОЗанятыхПозициях, ПроверяемыйРегистратор, Ложь, АдресРезультатаПроверки, ИсправленныйДокумент);
	Если НЕ ПустаяСтрока(АдресРезультатаПроверки) Тогда
		РезультатПроверки = ПолучитьИзВременногоХранилища(АдресРезультатаПроверки);
	КонецЕсли; 
	
	ОтобразитьРезультатПроверкиВФорме(РезультатПроверки);
	
КонецПроцедуры

&НаСервере
Процедура ОтобразитьРезультатПроверкиВФорме(РезультатПроверки)
	
	ДругиеДокументыНеСоотвШтатномуРасписанию.Очистить();
	ДокументыНеСоотвШтатномуРасписанию.Очистить();
	ПроблемаТекущегоДокументаОписание = "";
	ТекстРезультатаПроверки = "";
	
	ПроблемыТекущегоДокумента = Ложь;
	ПроблемыДругихДокументов = Ложь;
	НесколькоПроблем = Ложь;
	
	Если РезультатПроверки = Неопределено Тогда
		
		ТекстРезультатаПроверки = НСтр("ru = 'Документ на данный момент соответствует штатному расписанию.';
										|en = 'Document corresponds to the headcount at the moment.'");
		Если ПроверкаСоответствияГрейдам Тогда 
			ТекстРезультатаПроверки = НСтр("ru = 'Начисления документа соответствуют грейдам';
											|en = 'Document accruals correspond to grades'");
		КонецЕсли;
		НастроитьВидимостьЭлементов();
		
	Иначе
		
		ПроблемыТекущегоДокумента = РезультатПроверки.Свойство("ПроблемыТекущегоДокумента");
		ПроблемыДругихДокументов = РезультатПроверки.Свойство("ПроблемыДругихДокументов");
		Если ПроблемыДругихДокументов Тогда
			Для Каждого ОписаниеПроблемы Из РезультатПроверки.ПроблемыДругихДокументов Цикл
				ЗаполнитьЗначенияСвойств(ДругиеДокументыНеСоотвШтатномуРасписанию.Добавить(), ОписаниеПроблемы);
			КонецЦикла;
		КонецЕсли; 
		
		Если РезультатПроверки.Свойство("ПроблемыТекущегоДокумента") Тогда
			
			ТекстРезультатаПроверки = НСтр("ru = 'Документ не соответствует штатному расписанию. Подробности приведены ниже';
											|en = 'Document does not comply with the headcount. See the details below'");
			Если ПроверкаСоответствияГрейдам Тогда 
				ТекстРезультатаПроверки = НСтр("ru = 'Начисления документа не соответствуют установленным для грейдов ограничениям';
												|en = 'Document accruals do not correspond to the limitations set for the grades'");
			КонецЕсли;
			
			Если Не НесколькоПроблем Тогда
				НесколькоПроблем = РезультатПроверки.ПроблемыТекущегоДокумента.Количество() > 1; 
			КонецЕсли; 
			
			Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.Грейды") Тогда 
				Модуль = ОбщегоНазначения.ОбщийМодуль("Грейды");
				Модуль.ПроверкаСоответствияШтатномуРасписаниюДополнитьФорму(ЭтотОбъект);
			КонецЕсли;
			
			Если НесколькоПроблем Тогда
				Для каждого ОписаниеПроблемы Из РезультатПроверки.ПроблемыТекущегоДокумента Цикл
					ЗаполнитьЗначенияСвойств(ДокументыНеСоотвШтатномуРасписанию.Добавить(), ОписаниеПроблемы);
				КонецЦикла;
			Иначе
				СтрокаПроблемыТекущегоДокумента = РезультатПроверки.ПроблемыТекущегоДокумента[0];
				СтрокаПроблемыТекущегоДокумента.РасшифровкаНачислений = СтрокаПроблемыТекущегоДокумента.РасшифровкаНачислений;
				Если ЗначениеЗаполнено(СтрокаПроблемыТекущегоДокумента.ПозицияШтатногоРасписания) Тогда
					
					Если СтрокаПроблемыТекущегоДокумента.ПроблемыСНачислениями Тогда
						Если СтрокаПроблемыТекущегоДокумента.КоличествоСтавокНеСоответствуетПозиции И СтрокаПроблемыТекущегоДокумента.КоличествоСтавок <> СтрокаПроблемыТекущегоДокумента.СвободноеКоличествоСтавок Тогда
							ПроблемаТекущегоДокументаОписание = НСтр("ru = 'На %1 недостаточное количество свободных ставок, состав начислений не соответствует начислениям позиции штатного расписания';
																	|en = 'Insufficient number of vacant rates on %1, accruals do not correspond those of the headcount position'"); 
						Иначе
							ПроблемаТекущегоДокументаОписание = НСтр("ru = 'На %1 состав начислений не соответствует начислениям позиции штатного расписания';
																	|en = 'Content of accruals does not correspond to accruals of the headcount position on %1'"); 
						КонецЕсли; 
					ИначеЕсли СтрокаПроблемыТекущегоДокумента.КоличествоСтавокНеСоответствуетПозиции И СтрокаПроблемыТекущегоДокумента.КоличествоСтавок <> СтрокаПроблемыТекущегоДокумента.СвободноеКоличествоСтавок Тогда 
						ПроблемаТекущегоДокументаОписание = НСтр("ru = 'На %1 недостаточное количество свободных ставок по позиции штатного расписания';
																|en = 'Insufficient number of vacant rates for the headcount position on %1'"); 
					ИначеЕсли СтрокаПроблемыТекущегоДокумента.ПроблемыСГрейдом Тогда 
						ПроблемаТекущегоДокументаОписание = НСтр("ru = 'На %1 состав начислений не соответствует установленным для грейда ограничениям';
																|en = 'Content of accruals does not correspond to limitations specified for the grade on %1'"); 
					КонецЕсли;
					
					Если НЕ ПустаяСтрока(ПроблемаТекущегоДокументаОписание) Тогда
						ПроблемаТекущегоДокументаОписание = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
							ПроблемаТекущегоДокументаОписание,
							Формат(СтрокаПроблемыТекущегоДокумента.Период,  "ДЛФ=DD"));
					КонецЕсли; 
					
					ПозицияШтатногоРасписания 				= СтрокаПроблемыТекущегоДокумента.ПозицияШтатногоРасписания;
					ПозицияШтатногоРасписанияПредставление 	= СтрокаПроблемыТекущегоДокумента.ПозицияШтатногоРасписанияПредставление;
					Документ 								= СтрокаПроблемыТекущегоДокумента.Документ;
					ДокументПредставление 					= СтрокаПроблемыТекущегоДокумента.ДокументПредставление;
					
					Сотрудник								= СтрокаПроблемыТекущегоДокумента.Сотрудник;
					КоличествоСтавок						= СтрокаПроблемыТекущегоДокумента.КоличествоСтавок;
					СвободноеКоличествоСтавок				= СтрокаПроблемыТекущегоДокумента.СвободноеКоличествоСтавок;
					
					Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.Грейды") Тогда 
						Модуль = ОбщегоНазначения.ОбщийМодуль("Грейды");
						Модуль.ОтобразитьРезультатПроверкиНаСоответствиеГрейдуДокумента(ЭтотОбъект, СтрокаПроблемыТекущегоДокумента);
					КонецЕсли;
					
				Иначе
					ПроблемаТекущегоДокументаОписание = НСтр("ru = 'Не задана позиция штатного расписания';
															|en = 'Headcount position is not specified'"); 
				КонецЕсли;					
			КонецЕсли;
			
		Иначе
			
			ТекстРезультатаПроверки = НСтр("ru = 'Документ соответствует штатному расписанию, но после его проведения штатному расписанию перестанут соответствовать другие документы';
											|en = 'The document corresponds to the headcount, but other documents will not correspond to the headcount once it is posted '");
			Если Не НесколькоПроблем Тогда
				НесколькоПроблем = РезультатПроверки.ПроблемыДругихДокументов.Количество() > 1;
			КонецЕсли; 
			
			Если НесколькоПроблем Тогда
				Для каждого ОписаниеПроблемы Из РезультатПроверки.ПроблемыДругихДокументов Цикл
					ЗаполнитьЗначенияСвойств(ДокументыНеСоотвШтатномуРасписанию.Добавить(), ОписаниеПроблемы);
				КонецЦикла;
			Иначе
				ПозицияШтатногоРасписанияПредставление = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(РезультатПроверки.ПроблемыДругихДокументов[0].ПозицияШтатногоРасписания, "Наименование");
				ПозицияШтатногоРасписания = РезультатПроверки.ПроблемыДругихДокументов[0].ПозицияШтатногоРасписания;
				ДокументПредставление = РезультатПроверки.ПроблемыДругихДокументов[0].ДокументПредставление;
				Документ = РезультатПроверки.ПроблемыДругихДокументов[0].Документ;
			КонецЕсли;
			
		КонецЕсли;
		
		НастроитьВидимостьЭлементов();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура НастроитьВидимостьЭлементов()
	
	ЕстьОшибки = ПроблемыТекущегоДокумента Или ПроблемыДругихДокументов;
	
	Если ЕстьОшибки Тогда
		Элементы.РезультатСтраницы.ТекущаяСтраница = Элементы.РезультатСтраницы.ПодчиненныеЭлементы.РезультатПроблемы;
		Если НесколькоПроблем Тогда
			Элементы.ГруппаПроблемы.ТекущаяСтраница = Элементы.ГруппаПроблемы.ПодчиненныеЭлементы.СписокПроблем;
		Иначе
			Элементы.ГруппаПроблемы.ТекущаяСтраница = Элементы.ГруппаПроблемы.ПодчиненныеЭлементы.ОднаПроблема;
			
			Если ПроблемыТекущегоДокумента Тогда
				Элементы.ОписаниеПроблем.ТекущаяСтраница = Элементы.ОписаниеПроблем.ПодчиненныеЭлементы.ПроблемаТекущийДокумент;
			Иначе
				Элементы.ОписаниеПроблем.ТекущаяСтраница = Элементы.ОписаниеПроблем.ПодчиненныеЭлементы.ПроблемаБудущийДокумент;
			КонецЕсли;					
		КонецЕсли;
	Иначе
		Элементы.РезультатСтраницы.ТекущаяСтраница = Элементы.РезультатСтраницы.ПодчиненныеЭлементы.РезультатДокументПрошелПроверку;	
	КонецЕсли;
	
	Если НесколькоПроблем Тогда
		
		Если ПроблемыТекущегоДокумента Тогда
			ТекстНадписи = НСтр("ru = 'Ниже приведен список сотрудников и позиций, которые не соответствуют штатному расписанию.';
								|en = 'Below is the list of employees and positions that do not correspond to the headcount. '");
			Если ПроверкаСоответствияГрейдам Тогда 
				ТекстНадписи = НСтр("ru = 'Ниже приведен список сотрудников, начисления которых не соответствуют установленным для грейдов ограничениям.';
									|en = 'Below is the list of employees whose accruals do not correspond to limitations set for grades.'");
			КонецЕсли;	
		Иначе
			ТекстНадписи = НСтр("ru = 'Ниже приведен список документов, которые не будут соответствовать штатному расписанию. Используйте правую кнопку мыши для редактирования.';
								|en = 'Below is the list of documents that will not correspond to the headcount. Right-click them to edit.'");
		КонецЕсли;
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы,
			"НадписьКДокументам",
			"Заголовок",
			ТекстНадписи);
		
	КонецЕсли; 
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ДокументыНеСоотвШтатномуРасписаниюДокумент",
		"Видимость",
		НесколькоПроблем И Не ПроблемыТекущегоДокумента);
		
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ДокументыНеСоотвШтатномуРасписаниюДатаДокумента",
		"Видимость",
		НесколькоПроблем И Не ПроблемыТекущегоДокумента);
		
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"СправочникШтатноеРасписаниеОткрытьСписок",
		"Видимость",
		ЕстьОшибки);
		
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"Перепроверить",
		"Видимость",
		ЕстьОшибки);
		
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ОК",
		"Видимость",
		Не ПроверкаПередЗаписью);
		
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"Отмена",
		"Видимость",
		ПроверкаПередЗаписью И ЕстьОшибки);
		
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ДекорацияКнопкиОтменить",
		"Видимость",
		ПроверкаПередЗаписью И ЕстьОшибки);
		
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"Продолжить",
		"Видимость",
		ПроверкаПередЗаписью И ЕстьОшибки);
		
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ДекорацияКнопкиПровести",
		"Видимость",
		ПроверкаПередЗаписью И ЕстьОшибки);
		
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ДокументыНеСоотвШтатномуРасписаниюКонтекстноеМенюОткрытьДокумент",
		"Видимость",
		НесколькоПроблем И Не ПроблемыТекущегоДокумента);
		
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"Отмена",
		"КнопкаПоУмолчанию",
		Элементы.Отмена.Видимость);
		
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ОК",
		"КнопкаПоУмолчанию",
		Не Элементы.Отмена.Видимость);
	
	Если НесколькоПроблем Тогда
			
		ТаблицаПозиций = ДокументыНеСоотвШтатномуРасписанию.Выгрузить(, "ПозицияШтатногоРасписания");
		ТаблицаПозиций.Свернуть("ПозицияШтатногоРасписания");
		Если ДокументыНеСоотвШтатномуРасписанию.Количество() > 1 И ТаблицаПозиций.Количество() = 1 Тогда
			
			ЕдинственнаяПозиция = Истина;
			ЕдинственнаяПозицияПредставление = НСтр("ru = 'Открыть позицию ""%1""';
													|en = 'Open the ""%1"" position '");
			ЕдинственнаяПозицияПредставление = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				ЕдинственнаяПозицияПредставление,
				ТаблицаПозиций[0].ПозицияШтатногоРасписания);
				
		Иначе
				
			ЕдинственнаяПозиция = Ложь;
			ЕдинственнаяПозицияПредставление = НСтр("ru = 'Открыть позицию штатного расписания';
													|en = 'Open headcount position'");
			
		КонецЕсли; 

		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы,
			"ДокументыНеСоотвШтатномуРасписаниюДолжность",
			"Видимость",
			Не ЕдинственнаяПозиция);
	
	КонецЕсли; 
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"НадписьКДокументамГруппа2",
		"Видимость",
		Не ПроверкаСоответствияГрейдам);
		
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ГруппаПозицияШтатногоРасписанияТекущаяПроблема",
		"Видимость",
		Не ПроверкаСоответствияГрейдам);
		
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"СправочникШтатноеРасписаниеОткрытьСписок",
		"Видимость",
		Не ПроверкаСоответствияГрейдам);
		
КонецПроцедуры	

&НаКлиенте
Функция СтруктураРезультатаПроверки(ВыбранноеДействие)
	СтруктураРезультатаПроверки =  Новый Структура("ВыбранноеДействие,СоответствуетШтатномуРасписанию,АдресРезультатаПроверки", ВыбранноеДействие, Истина);
	Если ПроблемыТекущегоДокумента Тогда
		СтруктураРезультатаПроверки.СоответствуетШтатномуРасписанию = Ложь;
		СтруктураРезультатаПроверки.АдресРезультатаПроверки = АдресРезультатаПроверки;
	КонецЕсли; 
	Возврат СтруктураРезультатаПроверки;
КонецФункции

&НаКлиенте
Процедура ПозицияШтатногоРасписанияТекущаяПроблемаНажатие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ОткрытьФормуПозицииШтатногоРасписания(ПозицияШтатногоРасписания);
КонецПроцедуры

&НаКлиенте
Процедура ПозицияШтатногоРасписанияБудущаяПроблемаНажатие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ОткрытьФормуПозицииШтатногоРасписания(ПозицияШтатногоРасписания);
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуПозицииШтатногоРасписания(ОткрываемаяПозицияШтатногоРасписания)
	ПараметрыОткрытия = Новый Структура("Ключ", ОткрываемаяПозицияШтатногоРасписания);
	ФормаПозиции = ПолучитьФорму("Справочник.ШтатноеРасписание.Форма.ФормаЭлемента", ПараметрыОткрытия);
	ФормаПозиции.РежимОткрытияОкна = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
	ФормаПозиции.Открыть();
КонецПроцедуры

&НаКлиенте
Процедура ДокументНажатие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ПоказатьЗначение(, Документ);
КонецПроцедуры

#КонецОбласти
