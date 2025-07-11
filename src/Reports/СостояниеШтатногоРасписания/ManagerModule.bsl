#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ВариантыОтчетов

// См. ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов.
//
Процедура НастроитьВариантыОтчета(Настройки, НастройкиОтчета) Экспорт
	
	НастройкиОтчета.ОпределитьНастройкиФормы = Истина;
	
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "АнализШтатногоРасписания");
	НастройкиВарианта.Описание =
		НСтр("ru = 'План-фактный анализ штатного расписания, как по ставкам, так и по ФОТ.';
			|en = 'Variance analysis of the headcount by rates and salary budget.'");
	
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "СоблюдениеШтатногоРасписания");
	НастройкиВарианта.Описание =
		НСтр("ru = 'Сопоставление штатного расписания и фактически занятых позиций 
		|штатного расписания. ""Перерасход"" ставок отображается красным.';
		|en = 'Mapping of the headcount and currently occupied positions of the headcount.
		|Rate ""overspending"" is displayed in red color.'");
	
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "ЗаполненностьШтатногоРасписания");
	НастройкиВарианта.Описание = НСтр("ru = 'Информация о занятых и свободных ставках по штатному расписанию.';
										|en = 'Information about the occupied and vacant positions as per headcount.'");
	
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "ШтатнаяРасстановка");
	НастройкиВарианта.Описание = НСтр("ru = 'Информация о занятых ставках и состоянии сотрудников.';
										|en = 'Information about the occupied positions and employee status.'");
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ВариантыОтчетов

#КонецОбласти

#КонецОбласти

#КонецЕсли