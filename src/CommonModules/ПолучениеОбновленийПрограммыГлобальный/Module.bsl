///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Подсистема "Получение обновлений программы".
// ОбщийМодуль.ПолучениеОбновленийПрограммыГлобальный.
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

Процедура ПолучениеОбновленийПрограммы_ПроверитьНаличиеОбновлений() Экспорт
	
	ПолучениеОбновленийПрограммыКлиент.ПроверитьНаличиеОбновлений();
	
КонецПроцедуры

// Подключается при начале работы системы и показывает оповещение пользователю о необходимости включить автоматическую
// загрузку и установку исправлений.
//
Процедура ПолучениеОбновленийПрограммы_ПоказатьЗадачуНастройкиЗагрузкиИсправлений() Экспорт
	
	ПоказатьОповещениеПользователя(
		НСтр("ru = 'Установка исправлений (патчей)';
			|en = 'Installing corrections (patches)'"),
		"e1cib/app/Обработка.ОбновлениеПрограммы.Форма.НастройкаЗагрузкиИсправлений",
		НСтр("ru = 'Рекомендуется включить автоматическую загрузку и установку исправлений (патчей).';
			|en = 'Enable automatic import and installation of corrections (patches).'"),
		БиблиотекаКартинок.ДиалогВосклицание,
		СтатусОповещенияПользователя.Важное);
	
КонецПроцедуры

#КонецОбласти
