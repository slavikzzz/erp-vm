///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Если НЕ ЕстьФайлыВТомах() Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Файлы в томах отсутствуют.';
										|en = 'No files in volumes.'"));
		Возврат;
	КонецЕсли;
	
	ОткрытьФорму("ОбщаяФорма.ВыборПутиКАрхивуФайловТомов", , ПараметрыВыполненияКоманды.Источник);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ЕстьФайлыВТомах()
	
	Возврат РаботаСФайламиСлужебный.ЕстьФайлыВТомах();
	
КонецФункции

#КонецОбласти
