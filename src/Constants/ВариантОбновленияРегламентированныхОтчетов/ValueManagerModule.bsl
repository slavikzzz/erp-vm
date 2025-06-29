///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ОбщегоНазначения.РазделениеВключено() Тогда
		ВызватьИсключение НСтр("ru = 'Настройка варианта обновления регламентированных отчетов недоступна при работе в модели сервиса.
			|Загрузка обновлений выполняется подсистемой ""Поставляемые данные"".';
			|en = 'You cannot set up an option for updating local reports in SaaS mode.
			|Updates are imported by the Default master data subsystem.'");
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	// Значение константы и режима работы регламентного задания не должны отличаться
	// вне зависимости от прав пользователей.
	УстановитьПривилегированныйРежим(Истина);
	ПолучениеРегламентированныхОтчетов.УстановитьИспользованиеРегламентныхЗаданий(Значение <> 0);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли