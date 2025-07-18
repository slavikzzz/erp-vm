///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОписаниеПеременных

&НаКлиенте
Перем ПрограммноеЗакрытие;

&НаКлиенте
Перем РеестрФункций; // см. ПодготовитьРеестрПроверки

&НаКлиенте
Перем КодЯзыка;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	НастройкиПользователя = Параметры.НастройкиПользователя;
	СписокОпераций = Параметры.СписокОпераций;
	
	Если НЕ ЗначениеЗаполнено(СписокОпераций) Тогда
		СписокОпераций = ВесьСписокОпераций();
	КонецЕсли;	
	
	Если НастройкиПользователя = Неопределено Тогда
		НастройкиПользователя = СервисКриптографииDSS.НастройкиПользователяПоУмолчанию();
		СписокОпераций = Новый Структура;
	КонецЕсли;
	
	Сервер			= СервисКриптографииDSSКлиентСервер.ПолучитьПолеСтруктуры(НастройкиПользователя.Подключение, "Сервер");
	КодЯзыка 		= СервисКриптографииDSSСлужебный.КодЯзыка();
	ТекстОписания 	= НСтр("ru = '%1 на сервере %2';
							|en = '%1 on server %2'", КодЯзыка);
	ТекстОписания 	= СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстОписания, НастройкиПользователя.Логин, Сервер);
	Аккаунт 		= ТекстОписания;
	СтатусПроверки 	= "Начало";
	
	Картинки 		= Новый Структура;
	Картинки.Вставить("Пустая", Новый Картинка);
	ПолучитьКартинку("Ошибка32");
	ПолучитьКартинку("Успешно");
	ПолучитьКартинку("ДлительнаяОперация16");
				
	ПодготовитьФорму();
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	СервисКриптографииDSSСлужебныйКлиент.ПриОткрытииФормы(ЭтотОбъект, ПрограммноеЗакрытие);
	КодЯзыка = СервисКриптографииDSSСлужебныйКлиент.КодЯзыка();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если СервисКриптографииDSSСлужебныйКлиент.ПередЗакрытиемФормы(
			ЭтотОбъект,
			Отказ,
			ПрограммноеЗакрытие,
			ЗавершениеРаботы) Тогда
		ЗакрытьФорму();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Начать(Команда)
	
	Если СтатусПроверки = "Успешно" Тогда
		ЗакрытьФорму(ПодготовитьРезультаты());
	Иначе
		ПровестиПроверку();
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Если СтатусПроверки = "Ошибка" Тогда
		ЗакрытьФорму(ПодготовитьРезультаты());
	Иначе	
		ЗакрытьФорму();
	КонецЕсли;	
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область РеализацияРеестраПроверок

// Продолжение процедуры ЦиклПроверки.
&НаКлиенте
Процедура ВыбратьСертификат(ПараметрыРаботы, ДополнительныеПараметры) Экспорт
	
	СервисКриптографииDSSКлиент.ВыборСертификата(
		ОбратныйВызов(ДополнительныеПараметры),
		ПараметрыРаботы,
		НовыеПараметрыОперации());
		
КонецПроцедуры

// Продолжение процедуры ЦиклПроверки.
&НаКлиенте
Процедура ПолучитьДанныеСертификата(ПараметрыРаботы, ДополнительныеПараметры) Экспорт
	
	СервисКриптографииDSSКлиент.ПолучитьДанныеСертификата(
		ОбратныйВызов(ДополнительныеПараметры),
		ПараметрыРаботы,
		Сертификат,
		НовыеПараметрыОперации());
	
КонецПроцедуры

// Продолжение процедуры ЦиклПроверки.
&НаКлиенте
Процедура ЗашифроватьCMS(ПараметрыРаботы, ДополнительныеПараметры) Экспорт
	
	Сертификаты 	= Новый Массив;
	Сертификаты.Добавить(ОбъектСертификата);
	ДанныеДокумента = ПолучитьДвоичныеДанныеИзСтроки(ИсходныйТекст);
	
	СервисКриптографииDSSКлиент.Зашифровать(
		ОбратныйВызов(ДополнительныеПараметры),
		ПараметрыРаботы,
		ДанныеДокумента,
		Сертификаты,
		"CMS",
		НовыеПараметрыОперации());
	
КонецПроцедуры

// Продолжение процедуры ЦиклПроверки.
&НаКлиенте
Процедура ЗашифроватьXML(ПараметрыРаботы, ДополнительныеПараметры) Экспорт
	
	Сертификаты 	= Новый Массив;
	Сертификаты.Добавить(ОбъектСертификата.Сертификат);
	ДанныеДокумента = ПолучитьДвоичныеДанныеИзСтроки(ИсходныйТекст);
	
	СервисКриптографииDSSКлиент.Зашифровать(
		ОбратныйВызов(ДополнительныеПараметры),
		ПараметрыРаботы,
		ДанныеДокумента,
		Сертификаты,
		"XML",
		НовыеПараметрыОперации());
	
КонецПроцедуры

// Продолжение процедуры ЦиклПроверки.
&НаКлиенте
Процедура РасшифроватьCMS(ПараметрыРаботы, ДополнительныеПараметры) Экспорт
	
	Если ЗначениеЗаполнено(ДанныеОперации) Тогда
		СервисКриптографииDSSКлиент.Расшифровать(
			ОбратныйВызов(ДополнительныеПараметры),
			ПараметрыРаботы,
			ДанныеОперации,
			"CMS",
			Сертификат,
			НовыеПараметрыОперации());
	Иначе	
		ОтветСервиса = СервисКриптографииDSSКлиент.ОтветСервисаПоУмолчанию(Ложь);
		ОтветСервиса.СтатусОшибки.Представление = НСтр("ru = 'Нет данных для расшифрования';
														|en = 'No data to decrypt'", КодЯзыка);
		ОтветСервиса.Ошибка = ОтветСервиса.СтатусОшибки.Представление;
		ЦиклПроверкиПослеВыполнения(ОтветСервиса, ДополнительныеПараметры);
	КонецЕсли;	
	
КонецПроцедуры

// Продолжение процедуры ЦиклПроверки.
&НаКлиенте
Процедура РасшифроватьXML(ПараметрыРаботы, ДополнительныеПараметры) Экспорт
	
	Если ЗначениеЗаполнено(ДанныеОперацииXML) Тогда
		СервисКриптографииDSSКлиент.Расшифровать(
			ОбратныйВызов(ДополнительныеПараметры),
			ПараметрыРаботы,
			ДанныеОперацииXML,
			"XML",
			Сертификат,
			НовыеПараметрыОперации());
	Иначе
		ОтветСервиса = СервисКриптографииDSSКлиент.ОтветСервисаПоУмолчанию(Ложь);
		ОтветСервиса.СтатусОшибки.Представление = НСтр("ru = 'Нет данных для расшифрования XML';
														|en = 'No data to decrypt XML'", КодЯзыка);
		ОтветСервиса.Ошибка = ОтветСервиса.СтатусОшибки.Представление;
		ЦиклПроверкиПослеВыполнения(ОтветСервиса, ДополнительныеПараметры);
	КонецЕсли;		
	
КонецПроцедуры

// Продолжение процедуры ЦиклПроверки.
&НаКлиенте
Процедура ПодписатьCMS(ПараметрыРаботы, ДополнительныеПараметры) Экспорт
	
	ДанныеДокумента	= ПолучитьДвоичныеДанныеИзСтроки(ИсходныйТекст);
	СвойствоПодписи	= ПолучитьСвойствоПодписи("CMS");
	СервисКриптографииDSSКлиент.Подписать(
			ОбратныйВызов(ДополнительныеПараметры),
			ПараметрыРаботы,
			ДанныеДокумента, 
			СвойствоПодписи, 
			Сертификат,
			НовыеПараметрыОперации());
	
КонецПроцедуры

// Продолжение процедуры ЦиклПроверки.
&НаКлиенте
Процедура ПодписатьXML(ПараметрыРаботы, ДополнительныеПараметры) Экспорт
	
	ДанныеДокумента	= ПолучитьДвоичныеДанныеИзСтроки(ИсходныйТекст);
	СвойствоПодписи	= ПолучитьСвойствоПодписи("XML");
	СервисКриптографииDSSКлиент.Подписать(
			ОбратныйВызов(ДополнительныеПараметры),
			ПараметрыРаботы,
			ДанныеДокумента, 
			СвойствоПодписи, 
			Сертификат,
			НовыеПараметрыОперации());
	
КонецПроцедуры

// Продолжение процедуры ЦиклПроверки.
&НаКлиенте
Процедура ПроверитьСертификат(ПараметрыРаботы, ДополнительныеПараметры) Экспорт
	
	СервисКриптографииDSSКлиент.ПроверитьСертификат(
			ОбратныйВызов(ДополнительныеПараметры),
			ПараметрыРаботы,
			ОбъектСертификата.Сертификат,
			НовыеПараметрыОперации());

КонецПроцедуры

// Продолжение процедуры ЦиклПроверки.
&НаКлиенте
Процедура ПроверитьПодпись(ПараметрыРаботы, ДополнительныеПараметры) Экспорт
	
	Если ЗначениеЗаполнено(ДанныеОперации) Тогда
		ДанныеДокумента	= ПолучитьДвоичныеДанныеИзСтроки(ИсходныйТекст);
		СервисКриптографииDSSКлиент.ПроверитьПодпись(
							ОбратныйВызов(ДополнительныеПараметры),
							ПараметрыРаботы,
							ДанныеОперации,
							ДанныеДокумента,
							"CMS",
							НовыеПараметрыОперации());
	Иначе
		ОтветСервиса = СервисКриптографииDSSКлиент.ОтветСервисаПоУмолчанию(Ложь);
		ОтветСервиса.СтатусОшибки.Представление = НСтр("ru = 'Нет данных для проверки подписи';
														|en = 'No data to check the signature'", КодЯзыка);
		ОтветСервиса.Ошибка = ОтветСервиса.СтатусОшибки.Представление;
		ЦиклПроверкиПослеВыполнения(ОтветСервиса, ДополнительныеПараметры);
	КонецЕсли;
	
КонецПроцедуры	

// Продолжение процедуры ЦиклПроверки.
&НаКлиенте
Процедура ПроверитьПодписьXML(ПараметрыРаботы, ДополнительныеПараметры) Экспорт
	
	Если ЗначениеЗаполнено(ДанныеОперацииXML) Тогда
		ДанныеДокумента	= ПолучитьДвоичныеДанныеИзСтроки(ИсходныйТекст);
		СервисКриптографииDSSКлиент.ПроверитьПодпись(
							ОбратныйВызов(ДополнительныеПараметры),
							ПараметрыРаботы,
							ДанныеОперацииXML,
							ДанныеДокумента,
							"XML",
							НовыеПараметрыОперации());
	Иначе
		ОтветСервиса = СервисКриптографииDSSКлиент.ОтветСервисаПоУмолчанию(Ложь);
		ОтветСервиса.СтатусОшибки.Представление = НСтр("ru = 'Нет данных для проверки подписи XML';
														|en = 'No data to check XML signature'", КодЯзыка);
		ОтветСервиса.Ошибка = ОтветСервиса.СтатусОшибки.Представление;
		ЦиклПроверкиПослеВыполнения(ОтветСервиса, ДополнительныеПараметры);
	КонецЕсли;
	
КонецПроцедуры

// Продолжение процедуры ЦиклПроверки.
&НаКлиенте
Процедура УсовершенствоватьПодпись(ПараметрыРаботы, ДополнительныеПараметры) Экспорт
	
	ДанныеДокумента = Неопределено;
	СписокСерверов = Новый Массив;
	
	Если ЗначениеЗаполнено(ДанныеОперации) Тогда
		СписокСерверов = СервисКриптографииDSSКлиентСервер.ПолучитьСервераШтамповВремени(ПараметрыРаботы);
		ДанныеДокумента	= ДанныеОперации;
	КонецЕсли;
	
	Если СписокСерверов.Количество() = 0 Тогда
		ОтветСервиса = СервисКриптографииDSSКлиент.ОтветСервисаПоУмолчанию(Ложь);
		ОтветСервиса.Ошибка = НСтр("ru = 'На сервере подписи не обнаружено описание сервисов штрампов времени';
									|en = 'Timestamp service details are not found on the signature server'", КодЯзыка);
		ЦиклПроверкиПослеВыполнения(ОтветСервиса, ДополнительныеПараметры);
	ИначеЕсли ДанныеДокумента <> Неопределено Тогда
		СвойстваПодписи = СервисКриптографииDSSКлиентСервер.ПолучитьСвойствоПодписиCAdES("T", Истина, Ложь, "Подпись", СписокСерверов[0].Адрес);
		СервисКриптографииDSSКлиент.УсовершенствоватьПодпись(
							ОбратныйВызов(ДополнительныеПараметры),
							ПараметрыРаботы,
							ДанныеДокумента,
							СвойстваПодписи,
							НовыеПараметрыОперации());
	Иначе
		ОтветСервиса = СервисКриптографииDSSКлиент.ОтветСервисаПоУмолчанию(Ложь);
		ОтветСервиса.СтатусОшибки.Представление = НСтр("ru = 'Нет данных для усовершенстования подписи';
														|en = 'No data to enhance the signature'", КодЯзыка);
		ОтветСервиса.Ошибка = ОтветСервиса.СтатусОшибки.Представление;
		ЦиклПроверкиПослеВыполнения(ОтветСервиса, ДополнительныеПараметры);
	КонецЕсли;
	
КонецПроцедуры	

// Продолжение процедуры ЦиклПроверки.
&НаКлиенте
Процедура Хешировать(ПараметрыРаботы, ДополнительныеПараметры) Экспорт
	
	ДанныеДокумента	= ПолучитьДвоичныеДанныеИзСтроки(ИсходныйТекст);
	СервисКриптографииDSSКлиент.ХешированиеДанных(
		ОбратныйВызов(ДополнительныеПараметры),
		ПараметрыРаботы,
		ДанныеДокумента, ,
		НовыеПараметрыОперации());
		
КонецПроцедуры

// Продолжение процедуры ЦиклПроверки.
&НаКлиенте
Процедура ПроизвольноеПодтверждение(ПараметрыРаботы, ДополнительныеПараметры) Экспорт
	
	СервисКриптографииDSSКлиент.ПодтверждениеПроизвольнойОперации(
			ОбратныйВызов(ДополнительныеПараметры),
			ПараметрыРаботы,
			НСтр("ru = 'Проверка работоспособности';
				|en = 'Check operation'", КодЯзыка), ,
			НовыеПараметрыОперации());
	
КонецПроцедуры	

#КонецОбласти

#Область Прочее

&НаКлиенте
Процедура ЦиклПроверки()
	
	ОбработкаСледующая	= РеестрФункций[0]; // ОписаниеОповещения
	
	ИмяПроверки = ОбработкаСледующая.ДополнительныеПараметры.ИмяПроверки;
	НашлиСтроки = БазовыеФункции.НайтиСтроки(Новый Структура("ИмяПроверки", ИмяПроверки));
	Если НашлиСтроки.Количество() = 1 Тогда
		НашлиСтроки[0].Статус = "Ожидание";
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(ОбработкаСледующая, НастройкиПользователя);
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

// Продолжение процедуры ЦиклПроверки.
&НаКлиенте
Процедура ЦиклПроверкиПослеВыполнения(ПараметрыРаботы, ДополнительныеПараметры) Экспорт
	
	Если НЕ Открыта() Тогда
		СтатусПроверки = "Ошибка";
		Возврат;
	КонецЕсли;
	
	ИмяПроверки		= ДополнительныеПараметры.ИмяПроверки;
	КритичнаяОшибка = Ложь;
	ОписаниеОшибки	= "";
	
	Если ПараметрыРаботы.Свойство("НастройкиПользователя") Тогда
		НастройкиПользователя = ПараметрыРаботы.НастройкиПользователя;
	КонецЕсли;
	
	Если НЕ ПараметрыРаботы.Выполнено Тогда
		ОписаниеОшибки	= ПараметрыРаботы.СтатусОшибки.Представление;
		Если ИмяПроверки = "ВыбратьСертификат" Тогда
			КритичнаяОшибка = Истина;
		ИначеЕсли ИмяПроверки = "СвойстваСертификата" Тогда
			КритичнаяОшибка = Истина;
		Иначе
			КритичнаяОшибка = СервисКриптографииDSSКлиентСервер.ТребуетсяВводКонфиденциальныхДанных(НастройкиПользователя.ТокенАвторизации.Токен);
		КонецЕсли;	
	КонецЕсли;
	
	НашлиСтроки = БазовыеФункции.НайтиСтроки(Новый Структура("ИмяПроверки", ИмяПроверки));
	Если НашлиСтроки.Количество() = 0 Тогда
		ОписаниеОшибки	= НСтр("ru = 'Не найден раздел';
								|en = 'Section is not found'", КодЯзыка);
		КритичнаяОшибка = Истина;
	Иначе
		НашлиСтроки[0].Статус = ?(НЕ ПараметрыРаботы.Выполнено, "Ошибка", "Успешно");
	КонецЕсли;
	
	Если КритичнаяОшибка Тогда
		Элементы.ДекорацияОшибка.Заголовок = ОписаниеОшибки;
		РеестрФункций.Очистить();
	Иначе	
		РеестрФункций.Удалить(0);
		УстановитьДанныеОперации(ПараметрыРаботы, НашлиСтроки[0]);
	КонецЕсли;
	
	Если РеестрФункций.Количество() > 0 Тогда
		ПодключитьОбработчикОжидания("ЦиклПроверки", 0.1, Истина);
	ИначеЕсли КритичнаяОшибка Тогда
		СтатусПроверки = "Ошибка";
		УправлениеФормой(ЭтотОбъект);
	Иначе
		СтатусПроверки = "Успешно";
		УправлениеФормой(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДанныеОперации(ПараметрыРаботы, ДанныеРаздела)
	
	ИмяПроверки	= ДанныеРаздела.ИмяПроверки;
	НовыеДанные = Неопределено;
	Если ПараметрыРаботы.Выполнено 
		И ИмяПроверки <> "ПроизвольноеПодтверждение" Тогда
		НовыеДанные = ПараметрыРаботы.Результат;
	КонецЕсли;	
	
	ДанныеРаздела.Ошибка = ПараметрыРаботы.СтатусОшибки.Представление;
	
	Если ИмяПроверки = "ВыбратьСертификат" Тогда
		Сертификат = НовыеДанные;
	ИначеЕсли ИмяПроверки = "СвойстваСертификата" Тогда
		ОбъектСертификата = НовыеДанные;
	ИначеЕсли ИмяПроверки = "ЗашифроватьCMS" Тогда
		ДанныеОперации = НовыеДанные;
	ИначеЕсли ИмяПроверки = "ЗашифроватьXML" Тогда
		ДанныеОперацииXML = НовыеДанные;
	ИначеЕсли ИмяПроверки = "ПодписатьCMS" Тогда
		ДанныеОперации = НовыеДанные;
	ИначеЕсли ИмяПроверки = "ПодписатьXML" Тогда
		ДанныеОперацииXML = НовыеДанные;
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Функция ОбратныйВызов(ПараметрыВызова)
	
	Результат = Новый ОписаниеОповещения("ЦиклПроверкиПослеВыполнения", ЭтотОбъект, ПараметрыВызова);	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Функция ПодготовитьРезультаты()
	
	Результат 	= СервисКриптографииDSSКлиент.ОтветСервисаПоУмолчанию(Истина);
	Счетчик 	= 0;
	
	Для каждого СтрокаТаблицы Из БазовыеФункции Цикл
		Если НЕ СтрокаТаблицы.Выполнить Тогда
			Продолжить;
		КонецЕсли;
		
		Проверен = Ложь;
		Если СтрокаТаблицы.Статус = "Успешно" Тогда
			Проверен = Истина;
			Счетчик = Счетчик + 1;
		КонецЕсли;
		СписокОпераций.Вставить(СтрокаТаблицы.ИмяПроверки, Проверен);
		
	КонецЦикла;
	
	ДанныеПроверки = Новый Структура;
	ДанныеПроверки.Вставить("Успешно", Счетчик);
	ДанныеПроверки.Вставить("СписокОпераций", СписокОпераций);
	
	Результат.Вставить("Результат", ДанныеПроверки);
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура ЗакрытьФорму(ПараметрыЗакрытия = Неопределено)
	
	ПрограммноеЗакрытие = Истина;
	
	Если ПараметрыЗакрытия = Неопределено Тогда
		ПараметрыЗакрытия = СервисКриптографииDSSКлиент.ОтветСервисаПоУмолчанию(Ложь, "ОтказПользователя");
	КонецЕсли;	
	
	Закрыть(ПараметрыЗакрытия);
	
КонецПроцедуры

// Возвращаемое значение:
//   Массив из ОписаниеОповещения
//
&НаКлиенте
Функция ПодготовитьРеестрПроверки()
	
	МассивПроверки 	= Новый Массив;
	
	Для каждого СтрокаТаблицы Из БазовыеФункции Цикл
		СтрокаТаблицы.Статус = "";
		СтрокаТаблицы.Ошибка = "";
		Если СтрокаТаблицы.Выполнить Тогда
			ДополнительныеПараметры = Новый Структура();
			ДополнительныеПараметры.Вставить("ИмяПроверки", СтрокаТаблицы.ИмяПроверки);
			НовоеОповещение = ПодготовитьОбъектОповещения(СтрокаТаблицы.ИмяПроверки, СтрокаТаблицы.ИмяФункции);
			МассивПроверки.Добавить(НовоеОповещение);
		КонецЕсли;	
	КонецЦикла;
	
	Возврат МассивПроверки;
	
КонецФункции

&НаКлиенте
Функция ПодготовитьОбъектОповещения(ИмяПроверки, ИмяФункции)
	
	ДополнительныеПараметры = Новый Структура();
	ДополнительныеПараметры.Вставить("ИмяПроверки", ИмяПроверки);
	
	Если ИмяФункции = "ВыбратьСертификат" Тогда
		НовоеОповещение	= Новый ОписаниеОповещения("ВыбратьСертификат", ЭтотОбъект, ДополнительныеПараметры);
	ИначеЕсли ИмяФункции = "ПолучитьДанныеСертификата" Тогда
		НовоеОповещение	= Новый ОписаниеОповещения("ПолучитьДанныеСертификата", ЭтотОбъект, ДополнительныеПараметры);
	ИначеЕсли ИмяФункции = "ЗашифроватьCMS" Тогда
		НовоеОповещение	= Новый ОписаниеОповещения("ЗашифроватьCMS", ЭтотОбъект, ДополнительныеПараметры);
	ИначеЕсли ИмяФункции = "ЗашифроватьXML" Тогда
		НовоеОповещение	= Новый ОписаниеОповещения("ЗашифроватьXML", ЭтотОбъект, ДополнительныеПараметры);
	ИначеЕсли ИмяФункции = "РасшифроватьCMS" Тогда
		НовоеОповещение	= Новый ОписаниеОповещения("РасшифроватьCMS", ЭтотОбъект, ДополнительныеПараметры);
	ИначеЕсли ИмяФункции = "РасшифроватьXML" Тогда
		НовоеОповещение	= Новый ОписаниеОповещения("РасшифроватьXML", ЭтотОбъект, ДополнительныеПараметры);
	ИначеЕсли ИмяФункции = "ПодписатьCMS" Тогда
		НовоеОповещение	= Новый ОписаниеОповещения("ПодписатьCMS", ЭтотОбъект, ДополнительныеПараметры);
	ИначеЕсли ИмяФункции = "ПодписатьXML" Тогда
		НовоеОповещение	= Новый ОписаниеОповещения("ПодписатьXML", ЭтотОбъект, ДополнительныеПараметры);
	ИначеЕсли ИмяФункции = "ПроверитьСертификат" Тогда
		НовоеОповещение	= Новый ОписаниеОповещения("ПроверитьСертификат", ЭтотОбъект, ДополнительныеПараметры);
	ИначеЕсли ИмяФункции = "ПроверитьПодпись" Тогда
		НовоеОповещение	= Новый ОписаниеОповещения("ПроверитьПодпись", ЭтотОбъект, ДополнительныеПараметры);
	ИначеЕсли ИмяФункции = "ПроверитьПодписьXML" Тогда
		НовоеОповещение	= Новый ОписаниеОповещения("ПроверитьПодписьXML", ЭтотОбъект, ДополнительныеПараметры);
	ИначеЕсли ИмяФункции = "Хешировать" Тогда
		НовоеОповещение	= Новый ОписаниеОповещения("Хешировать", ЭтотОбъект, ДополнительныеПараметры);
	ИначеЕсли ИмяФункции = "ПроизвольноеПодтверждение" Тогда
		НовоеОповещение	= Новый ОписаниеОповещения("ПроизвольноеПодтверждение", ЭтотОбъект, ДополнительныеПараметры);
	ИначеЕсли ИмяФункции = "УсовершенствоватьПодпись" Тогда
		НовоеОповещение	= Новый ОписаниеОповещения("УсовершенствоватьПодпись", ЭтотОбъект, ДополнительныеПараметры);
	Иначе
		НовоеОповещение = Неопределено;
	КонецЕсли;
	
	Возврат НовоеОповещение;
	
КонецФункции

&НаКлиенте
Процедура ПровестиПроверку()
	
	Элементы.ДекорацияОшибка.Заголовок = "";
	СтатусПроверки 		= "Ожидание";
	
	РеестрФункций 		= ПодготовитьРеестрПроверки();
	ИсходныйТекст		= "<get><regNum>1</regNum><lnCode>2</lnCode><snils>0</snils></get>";
	ДанныеОперацииXML	= Неопределено;
	ДанныеОперации		= Неопределено;
	Сертификат			= Неопределено;
	
	УправлениеФормой(ЭтотОбъект);
	Если РеестрФункций.Количество() > 0 Тогда
		ЦиклПроверки();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция НовыеПараметрыОперации()
	
	ПараметрыОперации = Новый Структура();
	
	Возврат ПараметрыОперации;
	
КонецФункции

&НаСервере
Процедура ПодготовитьФорму()
	
	КодЯзыка = СервисКриптографииDSSСлужебный.КодЯзыка();
	БазовыеФункции.Очистить();
	
	ДобавитьЭлементПроверки("Сертификат", "ВыбратьСертификат", НСтр("ru = 'Выбор сертификата';
																	|en = 'Select certificate'", КодЯзыка), "ВыбратьСертификат");
	ДобавитьЭлементПроверки("Сертификат", "СвойстваСертификата", НСтр("ru = 'Получить свойства сертификата';
																		|en = 'Get certificate properties'", КодЯзыка), "ПолучитьДанныеСертификата");
	
	ДобавитьЭлементПроверки("Зашифровать", "ЗашифроватьCMS", НСтр("ru = 'Зашифровать произвольные данные';
																	|en = 'Encrypt arbitrary data'", КодЯзыка), "ЗашифроватьCMS");
	ДобавитьЭлементПроверки("Зашифровать", "ЗашифроватьXML", НСтр("ru = 'Зашифровать XML данные';
																	|en = 'Encrypt XML data'", КодЯзыка), "ЗашифроватьXML");
	
	ДобавитьЭлементПроверки("Расшифровать", "РасшифроватьCMS", НСтр("ru = 'Расшифровать произвольные данные';
																	|en = 'Decrypt arbitrary data'", КодЯзыка), "РасшифроватьCMS");
	ДобавитьЭлементПроверки("Расшифровать", "РасшифроватьXML", НСтр("ru = 'Расшифровать XML данные';
																	|en = 'Decrypt XML data'", КодЯзыка), "РасшифроватьXML");
	
	ДобавитьЭлементПроверки("Подписать", "ПодписатьCMS", НСтр("ru = 'Подписать произвольные данные';
																|en = 'Sign arbitrary data'", КодЯзыка), "ПодписатьCMS");
	ДобавитьЭлементПроверки("Подписать", "ПодписатьXML", НСтр("ru = 'Подписать XML данные';
																|en = 'Sign XML data'", КодЯзыка), "ПодписатьXML");
	
	ДобавитьЭлементПроверки("Прочее", "ПроверитьСертификат", НСтр("ru = 'Проверить сертификат';
																	|en = 'Check certificate'", КодЯзыка), "ПроверитьСертификат");
	ДобавитьЭлементПроверки("Прочее", "ПроверитьПодпись", НСтр("ru = 'Проверить подпись';
																|en = 'Check signature'", КодЯзыка), "ПроверитьПодпись");
	ДобавитьЭлементПроверки("Прочее", "ПроверитьПодписьXML", НСтр("ru = 'Проверить подпись XML';
																	|en = 'Check XML signature'", КодЯзыка), "ПроверитьПодписьXML");
	ДобавитьЭлементПроверки("Прочее", "УсовершенствоватьПодпись", НСтр("ru = 'Усовершенствовать подпись';
																		|en = 'Enhance signature'", КодЯзыка), "УсовершенствоватьПодпись");
	ДобавитьЭлементПроверки("Прочее", "Хешировать", НСтр("ru = 'Хешировать данные';
														|en = 'Hash data'", КодЯзыка), "Хешировать");
	ДобавитьЭлементПроверки("Прочее", "ПроизвольноеПодтверждение", НСтр("ru = 'Подтвердить операцию';
																		|en = 'Confirm operation'", КодЯзыка), "ПроизвольноеПодтверждение");
	
	ДобавитьРазделПроверки("Сертификат", НСтр("ru = 'Сертификат';
												|en = 'Certificate'", КодЯзыка));
	ДобавитьРазделПроверки("Зашифровать", НСтр("ru = 'Зашифровать';
												|en = 'Encrypt'", КодЯзыка));
	ДобавитьРазделПроверки("Расшифровать", НСтр("ru = 'Расшифровать';
												|en = 'Decrypt'", КодЯзыка));
	ДобавитьРазделПроверки("Подписать", НСтр("ru = 'Подписание';
											|en = 'Signing'", КодЯзыка));
	ДобавитьРазделПроверки("Прочее", НСтр("ru = 'Прочее';
											|en = 'Other'", КодЯзыка));
	
	ОтобразитьДеревоНаФорме();
	
КонецПроцедуры

&НаСервере
Процедура ОтобразитьДеревоНаФорме()
	
	Для каждого СтрокаТаблицы Из БазовыеФункции Цикл
		
		ИмяЭлемента			= СтрокаТаблицы.ИмяПроверки;
		ЭлементГруппы 		= Элементы.Добавить("Группа" + ИмяЭлемента, Тип("ГруппаФормы"), Элементы.ГруппаПроверки);
		ЭлементГруппы.Вид = ВидГруппыФормы.ОбычнаяГруппа;
		ЭлементГруппы.ОтображатьЗаголовок = Ложь;
		ЭлементГруппы.Группировка = ГруппировкаПодчиненныхЭлементовФормы.ГоризонтальнаяВсегда;
		
		Если СтрокаТаблицы.Выполнить Тогда
			ЭлементСтатуса 		= Элементы.Добавить("Статус" + ИмяЭлемента, Тип("ДекорацияФормы"), ЭлементГруппы);
			ЭлементСтатуса.Вид = ВидДекорацииФормы.Картинка;
			ЭлементСтатуса.РазмерКартинки = РазмерКартинки.АвтоРазмер;
			ЭлементСтатуса.Высота = 1;
			ЭлементСтатуса.Ширина = 3;
		КонецЕсли;
		
		ЭлементОписания		= Элементы.Добавить("Описание" + ИмяЭлемента, Тип("ДекорацияФормы"), ЭлементГруппы);
		ЭлементОписания.Вид = ВидДекорацииФормы.Надпись;
		ЭлементОписания.АвтоМаксимальнаяШирина = Ложь;
		ЭлементОписания.РастягиватьПоГоризонтали = НЕ СтрокаТаблицы.Выполнить;
		ЭлементОписания.ОтображениеПодсказки = ОтображениеПодсказки.Кнопка;
		
		Если СтрокаТаблицы.Выполнить Тогда
			ЭлементОписания.Заголовок = СтрокаТаблицы.Описание;
		Иначе
			ЭлементОписания.Заголовок = СтрокаТаблицы.Описание;
			ЭлементОписания.ЦветФона = WebЦвета.Бежевый;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры	

&НаСервере
Функция ДобавитьЭлементПроверки(ИмяРаздела, ИмяПроверки, Описание, ИмяФункции)
	
	Если СписокОпераций.Свойство(ИмяПроверки) Тогда
		НовыйЭлемент = БазовыеФункции.Добавить();
		НовыйЭлемент.Выполнить 	= Истина;
		НовыйЭлемент.ИмяРаздела = ИмяРаздела;
		НовыйЭлемент.ИмяПроверки= ИмяПроверки;
		НовыйЭлемент.Описание 	= Описание;
		НовыйЭлемент.ИмяФункции = ИмяФункции;
		НовыйЭлемент.Статус 	= "";
	КонецЕсли;	
	
	Возврат НовыйЭлемент;
	
КонецФункции	

&НаСервере
Функция ДобавитьРазделПроверки(ИмяРаздела, Описание)
	
	СтрокаПоиска    = Новый Структура("ИмяРаздела, Выполнить", ИмяРаздела, Истина);
	НашлиСтроки 	= БазовыеФункции.НайтиСтроки(СтрокаПоиска);
	
	Если НашлиСтроки.Количество() > 0 Тогда
		ИндексСтроки = БазовыеФункции.Индекс(НашлиСтроки[0]);
		НовыйЭлемент = БазовыеФункции.Вставить(ИндексСтроки);
		НовыйЭлемент.Выполнить 	= Ложь;
		НовыйЭлемент.ИмяРаздела = ИмяРаздела;
		НовыйЭлемент.ИмяПроверки= ИмяРаздела;
		НовыйЭлемент.Описание 	= Описание;
		НовыйЭлемент.ИмяФункции = "";
		НовыйЭлемент.Статус 	= "";
	КонецЕсли;	
	
	Возврат НовыйЭлемент;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(КонтекстФормы)
	
	СтатусПроверки = КонтекстФормы.СтатусПроверки;
	Если СтатусПроверки = "Начало" Тогда
		ЗаголовокКнопки = "Начать";
	ИначеЕсли СтатусПроверки = "Успешно" Тогда
		ЗаголовокКнопки = "ОК";
	ИначеЕсли СтатусПроверки = "Ошибка" Тогда
		ЗаголовокКнопки = "Повторить";
	ИначеЕсли СтатусПроверки = "Ожидание" Тогда
		ЗаголовокКнопки = "Проверяется";
	КонецЕсли;	
	
	КонтекстФормы.Элементы.Начать.Заголовок = ЗаголовокКнопки;
	КонтекстФормы.Элементы.Начать.Доступность = СтатусПроверки <> "Ожидание";
	
	Для каждого СтрокаТаблицы Из КонтекстФормы.БазовыеФункции Цикл
		Если СтрокаТаблицы.Выполнить Тогда
			ЭлементФормы = КонтекстФормы.Элементы["Статус" + СтрокаТаблицы.ИмяПроверки];
			Если СтрокаТаблицы.Статус = "Ошибка" Тогда
				ЭлементФормы.Картинка = КонтекстФормы.Картинки.Ошибка32;
			ИначеЕсли СтрокаТаблицы.Статус = "Успешно" Тогда
				ЭлементФормы.Картинка = КонтекстФормы.Картинки.Успешно;
			ИначеЕсли СтрокаТаблицы.Статус = "Ожидание" Тогда
				ЭлементФормы.Картинка = КонтекстФормы.Картинки.ДлительнаяОперация16;
			Иначе
				ЭлементФормы.Картинка = КонтекстФормы.Картинки.Пустая;
			КонецЕсли;
			ЭлементФормы = КонтекстФормы.Элементы["Описание" + СтрокаТаблицы.ИмяПроверки];
			ЭлементФормы.Подсказка = СтрокаТаблицы.Ошибка;
		КонецЕсли;	
	КонецЦикла;
	
КонецПроцедуры	

&НаСервереБезКонтекста
Функция ПолучитьСвойствоПодписи(ТипПодписи)
	
	Результат = Новый Структура;
	
	Если ТипПодписи = "XML" Тогда
		Результат = СервисКриптографииDSSКлиентСервер.ПолучитьСвойствоПодписиXML("Включенная");
	ИначеЕсли ТипПодписи = "CMS" Тогда
		Результат = СервисКриптографииDSSКлиентСервер.ПолучитьСвойствоПодписиCMS(Истина, Ложь);
	КонецЕсли;	
	
	СервисКриптографииDSSКлиентСервер.ПолучитьИнформациюДокументаДляПодписи(Результат, НСтр("ru = 'Тестовый пример';
																							|en = 'Test example'"), "XML");
	
	Возврат Результат;
	
КонецФункции

&НаСервереБезКонтекста
Функция ВесьСписокОпераций()
	
	Результат = Новый Структура;
	
	Результат.Вставить("ВыбратьСертификат", Ложь);
	Результат.Вставить("СвойстваСертификата", Ложь);
	
	Результат.Вставить("ЗашифроватьCMS", Ложь);
	Результат.Вставить("ЗашифроватьXML", Ложь);
	
	Результат.Вставить("РасшифроватьCMS", Ложь);
	Результат.Вставить("РасшифроватьXML", Ложь);
	
	Результат.Вставить("ПодписатьCMS", Ложь);
	Результат.Вставить("ПодписатьXML", Ложь);
	
	Результат.Вставить("ПроверитьСертификат", Ложь);
	Результат.Вставить("ПроверитьПодпись", Ложь);
	Результат.Вставить("ПроверитьПодписьXML", Ложь);
	Результат.Вставить("УсовершенствоватьПодпись", Ложь);
	Результат.Вставить("Хешировать", Ложь);
	Результат.Вставить("ПроизвольноеПодтверждение", Ложь);
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура ПолучитьКартинку(ИмяКартинки)
	
	Картинки.Вставить(ИмяКартинки, Новый Картинка);
	Если Метаданные.ОбщиеКартинки.Найти(ИмяКартинки) <> Неопределено Тогда
		Картинки.Вставить(ИмяКартинки, БиблиотекаКартинок[ИмяКартинки]);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти