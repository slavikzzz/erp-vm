///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Определяет макеты печатных форм, в которых поддерживается перевод на другие языки.
// 
// Параметры:
//  Макеты - Массив из ОбъектМетаданныхМакет
//
Процедура ПриОпределенииДоступныхДляПереводаМакетов(Макеты) Экспорт
	
	Макеты.Добавить(Метаданные.Обработки.ПечатьСчетовНаОплату.Макеты.ПФ_MXL_Invoice);
	Макеты.Добавить(Метаданные.Обработки.ПечатьСчетовНаОплату.Макеты.ПФ_MXL_DebitCreditNote);
	Макеты.Добавить(Метаданные.Документы.ЗаявкаНаВозвратТоваровОтКлиента.Макеты.ПФ_MXL_ЗаявкаНаВозврат);
	Макеты.Добавить(Метаданные.Обработки.ПечатьЗаказовНаТоварыУслуги.Макеты.ПФ_MXL_ЗаказКлиента);
	Макеты.Добавить(Метаданные.Обработки.ПечатьЗаказовНаТоварыУслуги.Макеты.ПФ_MXL_ЗаказПоставщику);
	
	//++ НЕ УТКА
	//++ Устарело_Переработка24
	Макеты.Добавить(Метаданные.Документы.ЗаказДавальца.Макеты.ПФ_MXL_ЗаказДавальца);
	//-- Устарело_Переработка24
	Макеты.Добавить(Метаданные.Документы.ЗаказДавальца2_5.Макеты.ПФ_MXL_ЗаказДавальца);
	//-- НЕ УТКА
	
	//++ НЕ УТ
	//++ Устарело_Переработка24
	Макеты.Добавить(Метаданные.Документы.ЗаказПереработчику.Макеты.ПФ_MXL_ЗаказПереработчику);
	Макеты.Добавить(Метаданные.Документы.ЗаказПереработчику.Макеты.ПФ_MXL_ЗаказПереработчикуНаУслуги);
	//-- Устарело_Переработка24
	Макеты.Добавить(Метаданные.Документы.ЗаказПереработчику2_5.Макеты.ПФ_MXL_ЗаказПереработчику2_5);
	Макеты.Добавить(Метаданные.Документы.ЗаказПереработчику2_5.Макеты.ПФ_MXL_ЗаказПереработчикуНаУслуги2_5);
	//-- НЕ УТ
	
КонецПроцедуры

#КонецОбласти
