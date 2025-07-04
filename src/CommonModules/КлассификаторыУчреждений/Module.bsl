// Модуль обеспечивает работу с данными классификаторов, поставляемыми в формате, 
// принятом в конфигурации БухгалтерияГосударственногоУчрежденияКОРП (StateAccountingCorp).

#Область ПрограммныйИнтерфейс

// Содержит описание ОКОФ в терминах подсистемы РаботаСКлассификаторами.
// 
// Возвращаемое значение:
//  см. РаботаСКлассификаторами.ОписаниеКлассификатора
//
Функция ОписаниеОКОФ() Экспорт
	
	Описание = РаботаСКлассификаторами.ОписаниеКлассификатора();
	
	Описание.Наименование           = НСтр("ru = 'Общероссийский классификатор основных фондов';
											|en = 'All-Russian Classifier of Fixed Assets'");
	Описание.Идентификатор          = ИдентификаторФайлаОКОФ();
	Описание.ОбновлятьАвтоматически = Истина;
	Описание.ОбщиеДанные            = Истина;
	
	Возврат Описание;
	
КонецФункции

// Десериализует содержимое ОКОФ, поставляемого сервисом подсистемы РаботаСКлассификаторами -
// https://releases.1c.ru/classifiers/total
//
// Параметры:
//  ИдентификаторФайла - Строка - см. ИдентификаторФайлаОКОФ
//  АдресФайла - Строка - адрес во временном хранилище, содержащий файл, полученный от сервиса
// 
// Возвращаемое значение:
//  Структура - см. НовыйСодержимоеКлассификатора
//
Функция СодержимоеОКОФ(ИдентификаторФайла, АдресФайла) Экспорт
	
	Если ИдентификаторФайла <> ИдентификаторФайлаОКОФ() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат СодержимоеКлассификатора("ОКОФ", АдресФайла);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция СодержимоеКлассификатора(ИдентификаторКлассификатора, АдресФайла)

	Читатель = Обработки.ЗагрузкаКлассификаторовУчреждений.Создать();
	Читатель.ИдентификаторКлассификатора = ИдентификаторКлассификатора;
	Читатель.ДобавитьНовыйКлассификатор(Неопределено, АдресФайла, Неопределено);
	
	Данные = Читатель.ПолучитьСодержаниеКлассификатора(Истина);
	
	Содержимое = НовыйСодержимоеКлассификатора();
	Содержимое.Количество = Читатель.КоличествоЭлементов;
	Содержимое.Данные     = Данные;
	
	Возврат Содержимое;
	
КонецФункции

Функция ИдентификаторФайлаОКОФ()
	Возврат "RussianClassificationOfFixedAssets";
КонецФункции

Функция НовыйСодержимоеКлассификатора()
	
	Содержимое = Новый Структура;
	Содержимое.Вставить("Количество", 0);
	Содержимое.Вставить("Данные",     Неопределено); // ОбъектXDTO
	
	Возврат Содержимое;
	
КонецФункции

#КонецОбласти