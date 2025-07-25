#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		
		Если ДанныеЗаполнения.Свойство("Действие") Тогда
			
			Если ДанныеЗаполнения.Действие = "Исправить" Тогда
				
				ИсправлениеДокументовЗарплатаКадры.СкопироватьДокумент(ЭтотОбъект, ДанныеЗаполнения.Ссылка);
				
				ИсправленныйДокумент = ДанныеЗаполнения.Ссылка;
				
			ИначеЕсли ДанныеЗаполнения.Действие = "ЗаполнитьПослеПереноса" Тогда
				ЗаполнитьПослеПереноса(ДанныеЗаполнения);	
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ГосударственнаяСлужба") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("ГосударственнаяСлужба");
		Модуль.ОбработкаЗаполненияДокументаПриемНаРаботу(ЭтотОбъект, ДанныеЗаполнения, СтандартнаяОбработка);
	КонецЕсли;
	
	Если КадровыйУчет.НастройкиКадровогоУчета().ПриемНаРаботуБезПриказаОПриеме Тогда
		ПриемТрудовымДоговором = Истина;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Документы.ПриемНаРаботу.ОбработкаПроведения(ЭтотОбъект, Отказ, РежимПроведения);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Документы.ПриемНаРаботу.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);

КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	Документы.ПриемНаРаботу.ОбработкаУдаленияПроведения(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	ДатаСобытия = Дата;
	Документы.ПриемНаРаботуСписком.ЗаполнитьДатуЗапретаРедактирования(ЭтотОбъект);
	
	ФОИспользоватьШтатноеРасписание = ПолучитьФункциональнуюОпцию("ИспользоватьШтатноеРасписание");
	Для каждого СтрокаСотрудника Из Сотрудники Цикл
		
		Если ФОИспользоватьШтатноеРасписание Тогда
			
			ДолжностьПозиции = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СтрокаСотрудника.ДолжностьПоШтатномуРасписанию, "Должность");
			Если СтрокаСотрудника.Должность <> ДолжностьПозиции Тогда
				СтрокаСотрудника.Должность = ДолжностьПозиции;
			КонецЕсли;
			
		Иначе
			
			Если ЗначениеЗаполнено(СтрокаСотрудника.ДолжностьПоШтатномуРасписанию) Тогда
				СтрокаСотрудника.ДолжностьПоШтатномуРасписанию = Справочники.ШтатноеРасписание.ПустаяСсылка();
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	УчетПособийСоциальногоСтрахованияРасширенный.ПередЗаписьюДокументаПриемНаРаботуСписком(
		ЭтотОбъект,
		Отказ,
		РежимЗаписи,
		РежимПроведения);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	УчетПособийСоциальногоСтрахованияРасширенный.ПриЗаписиДокументаПриемНаРаботуСписком(ЭтотОбъект, Отказ);
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Если ОбъектКопирования.Проведен Тогда
		
		Сотрудники.Очистить();
		Начисления.Очистить();
		Показатели.Очистить();
		ЕжегодныеОтпуска.Очистить();
		Льготы.Очистить();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

#Область ОбменДанными

Функция СовместноРегистрируемыеОбъекты() Экспорт
	Возврат Сотрудники.ВыгрузитьКолонку("Сотрудник");
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьПослеПереноса(ДанныеЗаполнения)
	
	ЕжегодныеОтпускаСотрудника = ЕжегодныеОтпуска.ВыгрузитьКолонки();
	
	Для каждого СтрокаСотрудника Из Сотрудники Цикл
		
		ДанныеДокумента = ОстаткиОтпусков.ОписаниеПараметровДанныхКадровогоДокумента();
		ДанныеДокумента.Регистратор = Ссылка;
		ДанныеДокумента.Сотрудник 	= СтрокаСотрудника.Сотрудник;
		ДанныеДокумента.ДатаСобытия = СтрокаСотрудника.ДатаПриема;
		
		ДанныеНовойПозиции = ОстаткиОтпусков.ОписаниеПараметровДанныхПозиции();
		ДанныеНовойПозиции.ДолжностьПоШтатномуРасписанию = СтрокаСотрудника.ДолжностьПоШтатномуРасписанию;
		ДанныеНовойПозиции.Подразделение 	= СтрокаСотрудника.Подразделение;
		ДанныеНовойПозиции.Должность 		= СтрокаСотрудника.Должность;
		ДанныеНовойПозиции.Территория 		= СтрокаСотрудника.Территория;
		
		ОстаткиОтпусков.ЗаполнитьПоложеннымиПравамиСотрудника(ЕжегодныеОтпускаСотрудника, ДанныеДокумента, ДанныеНовойПозиции);
		ЕжегодныеОтпускаСотрудника.ЗаполнитьЗначения(СтрокаСотрудника.ИдентификаторСтрокиСотрудника, "ИдентификаторСтрокиСотрудника");
		ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(ЕжегодныеОтпускаСотрудника, ЕжегодныеОтпуска);
		
	КонецЦикла;
	
	ЗапрашиваемыеЗначения = Новый Структура;
	ЗапрашиваемыеЗначения.Вставить("Организация", "Организация");
	ЗапрашиваемыеЗначения.Вставить("Ответственный", "Ответственный");
	ЗапрашиваемыеЗначения.Вставить("Руководитель", "Руководитель");
	ЗапрашиваемыеЗначения.Вставить("ДолжностьРуководителя", "ДолжностьРуководителя");
	ЗарплатаКадры.ЗаполнитьЗначенияВФорме(ЭтотОбъект, ЗапрашиваемыеЗначения, ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве("Организация"));
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.';
						|en = 'Invalid object call on the client.'");
#КонецЕсли