///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
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
		ВызватьИсключение НСтр("ru = 'Настройка загрузки классификаторов из файла не доступна при работе в модели сервиса.
			|Загрузка обновлений выполняется подсистемой ""Поставляемые данные"".';
			|en = 'Cannot import classifiers from files in SaaS.
			|Classifiers are updated automatically by the Default Master Data subsystem.'");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли