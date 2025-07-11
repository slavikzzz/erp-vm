///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Элементы.Надпись.Заголовок = СтроковыеФункции.ФорматированнаяСтрока(
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Вход в информационную базу был выполнен в целях автоматического тестирования
			           |с параметром запуска <b>%1</b>.
			           |
			           |Работа пользователей в этом режиме настоятельно не рекомендуется,
			           |так как это приведет к рассогласованию или потере данных.';
			           |en = 'The authorization in the infobase was performed for automated testing purposes,
			           |using the startup parameter <b>%1</b>.
			           |
			           |It is strongly recommended that you do not allow normal user operation in this mode
			           |as it will result in data losses or mismatches.'"),
			"ОтключитьЛогикуНачалаРаботыСистемы"));
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Не СтандартныеПодсистемыКлиент.ОтключенаЛогикаНачалаРаботыСистемы() Тогда
		Возврат;
	КонецЕсли;
	
	Элементы.ТестовыйРежим.Видимость = Истина;
	
	ЗаголовокТестовогоРежима = "{" + НСтр("ru = 'Тестирование';
											|en = 'Testing'") + "} ";
	ТекущийЗаголовок = КлиентскоеПриложение.ПолучитьЗаголовок();
	
	Если СтрНачинаетсяС(ТекущийЗаголовок, ЗаголовокТестовогоРежима) Тогда
		Возврат;
	КонецЕсли;
	
	КлиентскоеПриложение.УстановитьЗаголовок(ЗаголовокТестовогоРежима + ТекущийЗаголовок);
	
	ЗарегистрироватьОтключениеЛогикиНачалаРаботыСистемы();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Процедура ЗарегистрироватьОтключениеЛогикиНачалаРаботыСистемы()
	
	Если Не ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных() Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	ВладелецДанных = Справочники.ИдентификаторыОбъектовМетаданных.ПолучитьСсылку(
		Новый УникальныйИдентификатор("627a6fb8-872a-11e3-bb87-005056c00008")); // Константы.
	
	ДатыОтключения = ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища(ВладелецДанных); // Массив
	Если ТипЗнч(ДатыОтключения) <> Тип("Массив") Тогда
		ДатыОтключения = Новый Массив;
	КонецЕсли;
	
	ДатыОтключения.Добавить(ТекущаяДатаСеанса());
	ОбщегоНазначения.ЗаписатьДанныеВБезопасноеХранилище(ВладелецДанных, ДатыОтключения);
	
КонецПроцедуры

#КонецОбласти
