//////////////////////////////////////////////////////////////////////
// Модуль "АналогиМатериаловКлиент" содержит процедуры и функции для 
// работы с механизмом замены материалов на аналоги.
//
//////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#Область ОткрытиеФорм

// Открывает форму выбора аналогов
//
// Параметры:
//	ПараметрыВыбораАналогов - Структура         - параметры необходимые для выбора аналогов см. АналогиМатериалов.ПараметрыВыбораАналогов
//  Форма					 - ФормаКлиентскогоПриложения - форма в которой выполняется выбор аналогов (после выбора будет вызвано событие ОбработкаВыбора()).
//
Процедура ОткрытьПодборАналогов(ПараметрыВыбораАналогов, Форма) Экспорт
	
	ОткрытьФорму("Документ.РазрешениеНаЗаменуМатериалов.Форма.ПодборАналогов", ПараметрыВыбораАналогов, Форма);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#КонецОбласти
