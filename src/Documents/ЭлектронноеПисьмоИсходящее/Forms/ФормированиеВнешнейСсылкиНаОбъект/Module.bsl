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
	
	АдресПубликацииИнформационнойБазыВИнтернете = ОбщегоНазначения.АдресПубликацииИнформационнойБазыВИнтернете();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	СформироватьАдресСсылки();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура АдресПубликацииИнформационнойБазыВИнтернетеПриИзменении(Элемент)
	
	СформироватьАдресСсылки();

КонецПроцедуры

&НаКлиенте
Процедура СсылкаНаОбъектПриИзменении(Элемент)
	
	СформироватьАдресСсылки();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Вставить(Команда)
	
	ОчиститьСообщения();
	
	Отказ = Ложь;
	
	Если ПустаяСтрока(АдресПубликацииИнформационнойБазыВИнтернете) Тогда
		
		ТекстСообщения = НСтр("ru = 'Не указан адрес публикации информационной базы в интернете.';
								|en = 'Infobase publication URL not specified.'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,, "АдресПубликацииИнформационнойБазыВИнтернете",, Отказ);
		
	КонецЕсли;
	
	Если ПустаяСтрока(СсылкаНаОбъект) Тогда
		
		ТекстСообщения = НСтр("ru = 'Не указана внутренняя ссылка на объект.';
								|en = 'In-app link to the object is not specified.'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,, "СсылкаНаОбъект",, Отказ);
		
	КонецЕсли;
	
	Если Не Отказ Тогда
		ОповеститьОВыборе(СформированнаяСсылка);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура СформироватьАдресСсылки()

	СформированнаяСсылка = АдресПубликацииИнформационнойБазыВИнтернете + "#"+ СсылкаНаОбъект;

КонецПроцедуры

#КонецОбласти
