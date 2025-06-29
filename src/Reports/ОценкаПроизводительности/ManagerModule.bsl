///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ВариантыОтчетов

// Параметры:
//   Настройки - см. ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов.Настройки.
//   НастройкиОтчета - см. ВариантыОтчетов.ОписаниеОтчета.
//
Процедура НастроитьВариантыОтчета(Настройки, НастройкиОтчета) Экспорт
	
	ВариантыОтчетовСуществует = ОценкаПроизводительностиСлужебный.ПодсистемаСуществует("СтандартныеПодсистемы.ВариантыОтчетов");
	Если ВариантыОтчетовСуществует Тогда
		МодульВариантыОтчетов = ОценкаПроизводительностиСлужебный.ОбщийМодуль("ВариантыОтчетов");
		
		НастройкиВарианта = МодульВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "ОценкаПроизводительностиПоКлючевымОперациям"); // см. ВариантыОтчетов.ОписаниеВарианта		
		НастройкиВарианта.Описание = 
			НСтр("ru = 'Предоставляет информацию об оценке производительности';
				|en = 'Provides Apdex metrics'");
			
		НастройкиВарианта = МодульВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "СравнениеОценкиПроизводительности"); // см. ВариантыОтчетов.ОписаниеВарианта
		НастройкиВарианта.Описание = 
			НСтр("ru = 'Предоставляет информацию о сравнении оценки производительности за период';
				|en = 'Compares Apdex metrics during a period'");
			
		НастройкиВарианта = МодульВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "ОценкаПроизводительностиПериодВКолонках"); // см. ВариантыОтчетов.ОписаниеВарианта
		НастройкиВарианта.Описание = 
			НСтр("ru = 'Предоставляет информацию об оценке производительности в разрезе периодов. Периоды представлены в колонках';
				|en = 'Provides Apdex metrics by period'");
	КонецЕсли;
			
КонецПроцедуры

// Конец СтандартныеПодсистемы.ВариантыОтчетов

#КонецОбласти

#КонецОбласти

#КонецЕсли
