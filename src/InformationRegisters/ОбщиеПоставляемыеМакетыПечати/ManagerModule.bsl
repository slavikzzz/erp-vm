///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

Процедура ОбновитьКонтрольнуюСуммуМакетов() Экспорт
	
	ВерсияМакета = Метаданные.Версия;
	
	ОбрабатываемыеМакеты = МакетыПечатныхФормКонфигурации();
	
	СписокОшибок = Новый Массив;
	
	Для Каждого ОписаниеМакета Из ОбрабатываемыеМакеты Цикл
		Владелец = ОписаниеМакета.Значение;
		ИмяВладельца = ?(Владелец = Метаданные.ОбщиеМакеты, "ОбщийМакет", Владелец.ПолноеИмя());
		ИдентификаторОбъектаМетаданныхВладельца = ?(Владелец = Метаданные.ОбщиеМакеты,
			Справочники.ИдентификаторыОбъектовМетаданных.ПустаяСсылка(), ОбщегоНазначения.ИдентификаторОбъектаМетаданных(Владелец));
		Макет = ОписаниеМакета.Ключ;
		ИмяМакета = Макет.Имя;
		
		Если Владелец = Метаданные.ОбщиеМакеты Тогда
			ДанныеМакета = ПолучитьОбщийМакет(Макет);
		Иначе
			УстановитьОтключениеБезопасногоРежима(Истина);
			УстановитьПривилегированныйРежим(Истина);
			
			ДанныеМакета = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(Владелец.ПолноеИмя()).ПолучитьМакет(Макет);
			
			УстановитьПривилегированныйРежим(Ложь);
			УстановитьОтключениеБезопасногоРежима(Ложь);
		КонецЕсли;
		
		КонтрольнаяСумма = ОбщегоНазначения.КонтрольнаяСуммаСтрокой(ДанныеМакета);
		
		БлокировкаДанных = Новый БлокировкаДанных;
		ЭлементБлокировкиДанных = БлокировкаДанных.Добавить(Метаданные.РегистрыСведений.ОбщиеПоставляемыеМакетыПечати.ПолноеИмя());
		ЭлементБлокировкиДанных.УстановитьЗначение("ИмяМакета", ИмяМакета);
		ЭлементБлокировкиДанных.УстановитьЗначение("Объект", ИдентификаторОбъектаМетаданныхВладельца);
		
		НачатьТранзакцию();
		Попытка
			БлокировкаДанных.Заблокировать();
			
			НаборЗаписей = РегистрыСведений.ОбщиеПоставляемыеМакетыПечати.СоздатьНаборЗаписей();
			НаборЗаписей.Отбор.ИмяМакета.Установить(Макет.Имя);
			НаборЗаписей.Отбор.Объект.Установить(ИдентификаторОбъектаМетаданныхВладельца);
			НаборЗаписей.Прочитать();
			
			Если НаборЗаписей.Количество() > 0 Тогда
				Запись = НаборЗаписей[0];
			Иначе
				Запись = НаборЗаписей.Добавить();
				Запись.ИмяМакета = Макет.Имя;
				Запись.Объект = ИдентификаторОбъектаМетаданныхВладельца;
			КонецЕсли;
		
			Если Запись.ВерсияМакета = ВерсияМакета Тогда
				ОтменитьТранзакцию();
				Продолжить;
			КонецЕсли;
			
			Запись.ВерсияМакета = ВерсияМакета;
			Запись.ПредыдущаяКонтрольнаяСумма = Запись.КонтрольнаяСумма;
			Запись.КонтрольнаяСумма = КонтрольнаяСумма;
			
			ОбновлениеИнформационнойБазы.ЗаписатьНаборЗаписей(НаборЗаписей);
			
			ЗафиксироватьТранзакцию();
		Исключение
			ОтменитьТранзакцию();
			ИнформацияОбОшибке = ИнформацияОбОшибке();
			
			ТекстОшибки = НСтр("ru = 'Не удалось записать сведения о макете';
								|en = 'Failed to save template info'") + Символы.ПС
				+ Макет.ПолноеИмя() + Символы.ПС
				+ ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке);
			
			ЗаписьЖурналаРегистрации(НСтр("ru = 'Контроль изменения поставляемых макетов';
											|en = 'Build-in template edit monitor'", ОбщегоНазначения.КодОсновногоЯзыка()),
				УровеньЖурналаРегистрации.Ошибка, Макет, , ТекстОшибки);
			
			СписокОшибок.Добавить(ИмяВладельца + "." + ИмяМакета + ": " + ОбработкаОшибок.КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
		КонецПопытки;
	КонецЦикла;
	
	Если ЗначениеЗаполнено(СписокОшибок) Тогда
		СписокОшибок.Вставить(0, НСтр("ru = 'Не удалось записать сведения о макетах печатных форм конфигурации:';
										|en = 'Couldn''t save the print form templates details stored in the configuration:'"));
		ТекстОшибки = СтрСоединить(СписокОшибок, Символы.ПС);
		ВызватьИсключение ТекстОшибки;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция МакетыПечатныхФормКонфигурации()
	
	Результат = Новый Соответствие;
	
	Для Каждого Макет Из УправлениеПечатью.МакетыПечатныхФорм() Цикл
		Если Макет.Ключ.РасширениеКонфигурации() <> Неопределено Тогда
			Продолжить;
		КонецЕсли;
		Результат.Вставить(Макет.Ключ, Макет.Значение);
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Формирует печатные формы.
//
// Параметры:
//  МассивОбъектов - см. УправлениеПечатьюПереопределяемый.ПриПечати.МассивОбъектов
//  ПараметрыПечати - см. УправлениеПечатьюПереопределяемый.ПриПечати.ПараметрыПечати
//  КоллекцияПечатныхФорм - см. УправлениеПечатьюПереопределяемый.ПриПечати.КоллекцияПечатныхФорм
//  ОбъектыПечати - см. УправлениеПечатьюПереопределяемый.ПриПечати.ОбъектыПечати
//  ПараметрыВывода - см. УправлениеПечатьюПереопределяемый.ПриПечати.ПараметрыВывода
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	ПечатнаяФорма = УправлениеПечатью.СведенияОПечатнойФорме(КоллекцияПечатныхФорм, "ИнструкцияПоСозданиюФаксимильнойПодписиИПечати");
	Если ПечатнаяФорма <> Неопределено Тогда
		ПечатнаяФорма.СинонимМакета = НСтр("ru = 'Как сделать факсимильную подпись и печать';
											|en = 'How to create facsimile signatures and stamps'");
		ПечатнаяФорма.ТабличныйДокумент = ПолучитьОбщийМакет("ИнструкцияПоСозданиюФаксимильнойПодписиИПечати");
		ПечатнаяФорма.ПолныйПутьКМакету = "ОбщийМакет.ИнструкцияПоСозданиюФаксимильнойПодписиИПечати";
		ПечатнаяФорма.ТабличныйДокумент.ТолькоПросмотр = Истина;
		
		ОбластьСсылки = ПечатнаяФорма.ТабличныйДокумент.Рисунки.Сканировать;
		Если ПараметрыПечати.ДоступноСканирование И ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСФайлами") Тогда
			ОбластьСсылки.Текст = НСтр("ru = 'Сканировать';
										|en = 'Scan'");
			МодульРаботаСФайламиСлужебный = ОбщегоНазначения.ОбщийМодуль("РаботаСФайламиСлужебный");
			ОбластьСсылки.Маска = МодульРаботаСФайламиСлужебный.КомандаСканироватьЛист();
		Иначе
			ПечатнаяФорма.ТабличныйДокумент.Рисунки.Удалить(ОбластьСсылки);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли