#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ВариантыОтчетов

// См. ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов.
//
Процедура НастроитьВариантыОтчета(Настройки, НастройкиОтчета) Экспорт
	
	НастройкиОтчета.ОпределитьНастройкиФормы = Истина;
	
	ФункциональныеОпции = Новый Массив;
	ФункциональныеОпции.Добавить("ИспользоватьСтатьиФинансированияЗарплата");
	
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "Т51ПерваяПоловинаМесяца");
	НастройкиВарианта.Описание = НСтр("ru = 'Расчетная ведомость за первую половину месяца.';
										|en = 'Payroll for the first half of the month.'");
	
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "РасчетныйЛистокПерваяПоловинаМесяца");
	НастройкиВарианта.Описание = НСтр("ru = 'Расчетные листки за первую половину месяца.';
										|en = 'Payslips for the first half of the month.'");
	
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "РасчетныйЛистокСРазбивкойПоИсточникамФинансированияПерваяПоловинаМесяца");
	НастройкиВарианта.Описание = НСтр("ru = 'Расчетные листки за первую половину месяца, разбитые по источникам финансирования.';
										|en = 'Payslips for the first half of the month by funding sources.'");
	НастройкиВарианта.ФункциональныеОпции = ФункциональныеОпции;
	
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "Форма0504402ПерваяПоловинаМесяца");
	НастройкиВарианта.Описание = НСтр("ru = 'Расчетная ведомость 0504402 за первую половину месяца.';
										|en = 'Payroll 0504402 for the first half of the month.'");
	
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "АнализЗарплатыПоПодразделениямИСотрудникамПерваяПоловинаМесяца");
	НастройкиВарианта.Описание = НСтр("ru = 'Начисления, удержания и выплаты по сотрудникам за первую половину месяца.';
										|en = 'Accruals, deductions and payments by employees for the first half of the month.'");
	
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "АнализЗарплатыПоПодразделениямИСотрудникамПоИсточникамФинансированияПерваяПоловинаМесяца");
	НастройкиВарианта.Описание = НСтр("ru = 'Начисления, удержания и выплаты по сотрудникам и источникам финансирования за первую половину месяца.';
										|en = 'Accruals, deductions and payments by employees and sources of financing for the first half of the month.'");
	НастройкиВарианта.ФункциональныеОпции = ФункциональныеОпции;
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ВариантыОтчетов

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Функция ПечатьТ49(Документ, Финансирование = Неопределено) Экспорт
	
	ОтчетОбъект = Отчеты.АнализНачисленийИУдержанийАвансом.Создать();
	ОтчетОбъект.ИнициализироватьОтчет();
	
	ВариантОтчета = ОтчетОбъект.СхемаКомпоновкиДанных.ВариантыНастроек.Найти("Т49ПерваяПоловинаМесяца");
	Если ВариантОтчета = Неопределено Тогда
		Возврат Новый ТабличныйДокумент;
	КонецЕсли;
	
	НастройкиОтчета = ВариантОтчета.Настройки;
	
	РеквизитыДокумента = 
		ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Документ, 
		"ПериодРегистрации, Организация, Подразделение");
	ДанныеВедомости = Документы[Документ.Метаданные().Имя].ДанныеВедомостиДляПечати(Документ);
	
	Период = РеквизитыДокумента.ПериодРегистрации;
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("Период", Новый СтандартныйПериод(НачалоМесяца(Период), КонецМесяца(Период)));
	СтруктураПараметров.Вставить("НачалоПериода",				НачалоМесяца(Период));
	СтруктураПараметров.Вставить("КонецПериода",				КонецМесяца(Период));
	
	Для каждого ПараметрЗаполнения Из СтруктураПараметров Цикл
		
		ПараметрКомпоновкиДанных = Новый ПараметрКомпоновкиДанных(ПараметрЗаполнения.Ключ);
		ЗначениеПараметра = НастройкиОтчета.ПараметрыДанных.НайтиЗначениеПараметра(ПараметрКомпоновкиДанных);
		Если ЗначениеПараметра <> Неопределено Тогда
			ЗначениеПараметра.Значение = ПараметрЗаполнения.Значение;
			ЗначениеПараметра.Использование = Истина;
		Иначе
			НовыйПараметр = НастройкиОтчета.ПараметрыДанных.Элементы.Добавить();
			НовыйПараметр.Параметр = ПараметрКомпоновкиДанных;
			НовыйПараметр.Значение = ПараметрЗаполнения.Значение;
			НовыйПараметр.Использование = Истина;
		КонецЕсли;
		
	КонецЦикла;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(НастройкиОтчета.Отбор, 
		"Организация", 
		РеквизитыДокумента.Организация, 
		ВидСравненияКомпоновкиДанных.Равно, , Истина);
		
	Если ЗначениеЗаполнено(РеквизитыДокумента.Подразделение) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(НастройкиОтчета.Отбор, 
			"Подразделение", 
			РеквизитыДокумента.Подразделение, 
			ВидСравненияКомпоновкиДанных.ВИерархии, , Истина);
	КонецЕсли;
	
	Если ОбщегоНазначенияБЗККлиентСервер.ЗаполненоЗначениеСвойства(Финансирование, "СтатьяФинансирования") Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(НастройкиОтчета.Отбор, 
			"СтатьяФинансирования", 
			Финансирование.СтатьяФинансирования, 
			ВидСравненияКомпоновкиДанных.Равно, , Истина);
	КонецЕсли;
	Если ОбщегоНазначенияБЗККлиентСервер.ЗаполненоЗначениеСвойства(Финансирование, "СтатьяРасходов") Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(НастройкиОтчета.Отбор, 
			"СтатьяРасходов", 
			Финансирование.СтатьяРасходов, 
			ВидСравненияКомпоновкиДанных.Равно, , Истина);
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(НастройкиОтчета.Отбор, 
		"Сотрудник.ГоловнойСотрудник", 
		ДанныеВедомости.ВыгрузитьКолонку("Сотрудник"), 
		ВидСравненияКомпоновкиДанных.ВСписке, , Истина);
	
	ОтчетОбъект.КомпоновщикНастроек.ЗагрузитьНастройки(НастройкиОтчета);
	
	ОтчетОбъект.КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства.Вставить("Документ", Документ);
	ОтчетОбъект.КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства.Вставить("ДанныеВедомости", ДанныеВедомости);
	Если ЗначениеЗаполнено(РеквизитыДокумента.Подразделение) Тогда
		ОтчетОбъект.КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства.Вставить("ПодразделениеВШапке", РеквизитыДокумента.Подразделение);
	КонецЕсли;
	
	ДокументРезультат = Новый ТабличныйДокумент;
	
	ОтчетОбъект.СкомпоноватьРезультат(ДокументРезультат);
	
	Возврат ДокументРезультат;
	
КонецФункции

#КонецОбласти

#КонецЕсли