#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Определяет список команд создания на основании.
//
// Параметры:
//  КомандыСозданияНаОсновании - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
//  Параметры - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.Параметры
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСозданияНаОсновании, Параметры) Экспорт
	
	
	
КонецПроцедуры

// Добавляет команду создания документа "Операция (регламентированный учет)".
//
// Параметры:
//  КомандыСозданияНаОсновании - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
//
Функция ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании) Экспорт
	Если ПравоДоступа("Добавление", Метаданные.Документы.ОперацияБух) Тогда
		КомандаСоздатьНаОсновании = КомандыСозданияНаОсновании.Добавить();
		КомандаСоздатьНаОсновании.Менеджер = Метаданные.Документы.ОперацияБух.ПолноеИмя();
		КомандаСоздатьНаОсновании.Представление = ОбщегоНазначенияУТ.ПредставлениеОбъекта(Метаданные.Документы.ОперацияБух);
		КомандаСоздатьНаОсновании.ФункциональныеОпции = "ИспользоватьРеглУчет";
		КомандаСоздатьНаОсновании.РежимЗаписи = "Проводить";
		
	

		Возврат КомандаСоздатьНаОсновании;
	КонецЕсли;

	Возврат Неопределено;
КонецФункции

// Определяет список команд отчетов.
//
// Параметры:
//   КомандыОтчетов - См. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.КомандыОтчетов
//   Параметры - См. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.Параметры
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры) Экспорт
	
КонецПроцедуры

// Возвращает список счетов учета, использование которых в документе не рекомендуется.
// 
// Возвращаемое значение:
// 	Результат - СписокЗначений - Список счетов учета.
//
Функция НерекомендуемыеСчетаУчета() Экспорт
	
	НерекомендуемыеСчетаУчета = Новый Массив;
	
	СчетаУчетаНоменклатуры = Обработки.НастройкаОтраженияДокументовВРеглУчете.ДоступныеСчетаУчетаНоменклатуры();
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(НерекомендуемыеСчетаУчета, СчетаУчетаНоменклатуры.СчетаУчетаНаСкладе);
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(НерекомендуемыеСчетаУчета, СчетаУчетаНоменклатуры.СчетаУчетаВПути);
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(НерекомендуемыеСчетаУчета, СчетаУчетаНоменклатуры.СчетаУчетаПередачиНаКомиссию);
	
	СчетаУчетаРасчетов = Обработки.НастройкаОтраженияДокументовВРеглУчете.ДоступныеСчетаУчетаРасчетов();
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(НерекомендуемыеСчетаУчета, СчетаУчетаРасчетов.СчетаРасчетовСПоставщиками);
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(НерекомендуемыеСчетаУчета, СчетаУчетаРасчетов.СчетаРасчетовПоАвансамВыданным);
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(НерекомендуемыеСчетаУчета, СчетаУчетаРасчетов.СчетаРасчетовСКлиентами);
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(НерекомендуемыеСчетаУчета, СчетаУчетаРасчетов.СчетаРасчетовПоАвансамПолученным);
	
	СчетаУчетаРасходов = Обработки.НастройкаОтраженияДокументовВРеглУчете.ДоступныеСчетаУчетаРасходов();
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(НерекомендуемыеСчетаУчета, СчетаУчетаРасходов.СчетаРасходов);
	
	СчетаУчетаПрочихДоходов = Обработки.НастройкаОтраженияДокументовВРеглУчете.ДоступныеСчетаУчетаПрочихДоходов();
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(НерекомендуемыеСчетаУчета, СчетаУчетаПрочихДоходов.СчетаПрочихДоходов);
	
	СчетаУчетаТМЦВЭксплуатации = Обработки.НастройкаОтраженияДокументовВРеглУчете.ДоступныеСчетаУчетаТМЦВЭксплуатации();
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(НерекомендуемыеСчетаУчета, СчетаУчетаТМЦВЭксплуатации.СчетаУчетаТМЦВЭксплуатации);
	
	СчетаУчетаДенежныхСредств = Обработки.НастройкаОтраженияДокументовВРеглУчете.ДоступныеСчетаУчетаДенежныхСредств();
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(НерекомендуемыеСчетаУчета, СчетаУчетаДенежныхСредств.СчетаБезналичныхДенежныхСредств);
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(НерекомендуемыеСчетаУчета, СчетаУчетаДенежныхСредств.СчетаНаличныхДенежныхСредств);
	
	// Исключения из правил.
	ОбщегоНазначенияКлиентСервер.УдалитьВсеВхожденияЗначенияИзМассива(НерекомендуемыеСчетаУчета, ПланыСчетов.Хозрасчетный.БалансировкаВРПоДоговорамАренды);
		
	Возврат НерекомендуемыеСчетаУчета;
	
КонецФункции

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - см. УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт

	// Бухгалтерская справка
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "БухгалтерскаяСправка";
	КомандаПечати.Представление = НСтр("ru = 'Бухгалтерская справка';
										|en = 'Accounting statement'");
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	КомандаПечати.МенеджерПечати = "Обработка.ПечатьБухгалтерскойСправки";
	КомандаПечати.ДополнительныеПараметры.Вставить("ПолеСодержаниеОперации", "Содержание");
	КомандаПечати.ДополнительныеПараметры.Вставить("ТипДокумента", "ОперацияБух");
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли