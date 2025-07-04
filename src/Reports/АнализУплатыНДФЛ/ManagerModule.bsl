#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ВариантыОтчетов

// См. ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов.
//
Процедура НастроитьВариантыОтчета(Настройки, НастройкиОтчета) Экспорт
		
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "Проверка6НДФЛ");
	НастройкиВарианта.Описание =
		НСтр("ru = 'Проверка заполнения 6-НДФЛ.';
			|en = 'Check filled-out 6-NDFL.'");
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "КонтрольУплаты");
	НастройкиВарианта.Описание =
		НСтр("ru = '(Утратил актуальность с 2024 года) Контроль просроченности уплаты НДФЛ. Если конечный 
		|остаток на дату положительный - уплата просрочена.';
		|en = '(No longer relevant since 2024) Overdue PIT payment control.
		|If closing balance on a date is positive, a payment is considered overdue.'");
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ВариантыОтчетов

#КонецОбласти

#КонецОбласти
	
#КонецЕсли