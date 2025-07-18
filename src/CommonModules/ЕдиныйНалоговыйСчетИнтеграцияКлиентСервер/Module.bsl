////////////////////////////////////////////////////////////////////////////////
// ЕдиныйНалоговыйСчетИнтеграцияКлиентСервер:
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

Функция ТекстСлужебногоМаркераВЖР() Экспорт
	
	Возврат НСтр("ru = '#ДеталиОшибкиВыведены#';
				|en = '#ДеталиОшибкиВыведены#'");
	
КонецФункции

Функция СтруктураПараметровВыполненияЗапроса() Экспорт
	
	Возврат ЕдиныйНалоговыйСчетИнтеграцияВызовСервера.СтруктураПараметровВыполненияЗапроса();
	
КонецФункции

Процедура ОбработатьИнформационноеСообщение(ВидОперации, Знач ПодробныйТекстСообщения, Знач ТекстСообщения = "",
		СсылкаНаОбъект = Неопределено, ЭтоОшибка = Истина) Экспорт
	
	Если ЗначениеЗаполнено(ПодробныйТекстСообщения) Тогда
		ПодробныйТекстСообщения = ОбщегоНазначенияКлиентСервер.УдалитьНедопустимыеСимволыXML(ПодробныйТекстСообщения);
	Иначе
		ПодробныйТекстСообщения = "";
	КонецЕсли;
	Если ЗначениеЗаполнено(ТекстСообщения) Тогда
		ТекстСообщения = ОбщегоНазначенияКлиентСервер.УдалитьНедопустимыеСимволыXML(ТекстСообщения);
	Иначе
		ТекстСообщения = "";
	КонецЕсли;
	
	Если ЭтоОшибка И ДеталиОшибкиВыведены(ТекстСообщения) Тогда
		ТекстСообщения = "";
	КонецЕсли;
	
	ЕдиныйНалоговыйСчетИнтеграцияВызовСервера.ОбработатьИнформационноеСообщение(ВидОперации,
		"ЕдиныйНалоговыйСчетИнтеграция", ПодробныйТекстСообщения, ТекстСообщения, СсылкаНаОбъект, ЭтоОшибка);
	
КонецПроцедуры

Функция ЗапросВыполнен(Статус) Экспорт
	
	ЗапросВыполнен =
		ВРег(Статус) = "COMPLETED"
			Или ВРег(Статус) = "TRANSFER_DATA_TO_STORE_COMPLETED";
		
	Возврат ЗапросВыполнен;
	
КонецФункции

Функция ЗапросВыполняется(Статус) Экспорт
	
	ЗапросВыполняется =
		ВРег(Статус) = "NEW"
			Или ВРег(Статус) = "PROCESSOR_DATA_PROCESS"
			Или ВРег(Статус) = "PROCESSOR_DATA_COMPLETED"
			Или ВРег(Статус) = "EXPORT_DATA_PROCESS"
			Или ВРег(Статус) = "EXPORT_DATA_COMPLETED"
			Или ВРег(Статус) = "CRYPT_DATA_SEND_PROCESS"
			Или ВРег(Статус) = "CRYPT_DATA_SEND_COMPLETED"
			Или ВРег(Статус) = "CRYPT_DATA_RECEIVE_PROCESS"
			Или ВРег(Статус) = "CRYPT_DATA_RECEIVE_COMPLETED"
			Или ВРег(Статус) = "READY_FOR_TRANSPORT"
			Или ВРег(Статус) = "TRANSFER_DATA_TO_STORE_PROCESS";
		
	Возврат ЗапросВыполняется;
	
КонецФункции

Функция РезультатОтсутствует(Статус) Экспорт
	
	РезультатОтсутствует =
		ВРег(Статус) = "EXPORT_DATA_EMPTY_RESULT";
		
	Возврат РезультатОтсутствует;
	
КонецФункции

Функция ОшибкаВыполненияЗапроса(Статус) Экспорт
	
	ОшибкаВыполненияЗапроса =
		СтрНайти(ВРег(Статус), "ERROR") <> 0;
		
	Возврат ОшибкаВыполненияЗапроса;
	
КонецФункции

Функция ОшибкаТехническиеРаботыНаСторонеФНС(Статус) Экспорт
	
	ОшибкаВыполненияЗапроса =
		СтрНайти(ВРег(Статус), "EXPORT_DATA_SUSPENSION") <> 0;
		
	Возврат ОшибкаВыполненияЗапроса;
	
КонецФункции

Функция ТребуетсяПовторнаяАвторизация(Статус) Экспорт
	
	ТребуетсяАвторизация =
		ВРег(Статус) = "PROCESSOR_DATA_NOT_COMPLETED";
		
	Возврат ТребуетсяАвторизация;
	
КонецФункции

Функция СобытиеЖурналаРегистрации() Экспорт
	
	Возврат НСтр("ru = 'Сервис ENS-Integration (интеграция ЛК ЕНС)';
				|en = 'Сервис ENS-Integration (интеграция ЛК ЕНС)'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка())
	
КонецФункции

Функция ДанныеСогласияНаРаскрытиеНалоговойТайны(Организация) Экспорт
	
	// Титульный
	ДанныеТитульногоЛиста = Новый Структура;
	ДанныеТитульногоЛиста.Вставить("ПризДок",       "1");
	ДанныеТитульногоЛиста.Вставить("ПризРаскрСвед", "2");
	ДанныеТитульногоЛиста.Вставить("ДатаНачПер",    "2022");
	ДанныеТитульногоЛиста.Вставить("ДатаНачСогл",   ТекущаяДата());
	
	// Лист002
	ДанныеЛиста02 = Новый Структура;
	ДанныеЛиста02.Вставить("ИННЮЛ",    "7729510210");
	ДанныеЛиста02.Вставить("НаимОрг",  "ОБЩЕСТВО С ОГРАНИЧЕННОЙ ОТВЕТСТВЕННОСТЬЮ ""НАУЧНО-ПРОИЗВОДСТВЕННЫЙ ЦЕНТР ""1С""");
	ДанныеЛиста02.Вставить("КодКомпл", "21001");
	
	ПараметрыЗаявления = Новый Структура;
	ПараметрыЗаявления.Вставить("Организация", Организация);
	ПараметрыЗаявления.Вставить("Титульная",   ДанныеТитульногоЛиста);
	ПараметрыЗаявления.Вставить("Лист002",     ДанныеЛиста02);
	
	Возврат ПараметрыЗаявления;
	
КонецФункции

Процедура УстановитьДатыПоследнегоОбновления(Организация, ДатаПоследнегоОбновления) Экспорт
	
	ЕдиныйНалоговыйСчетИнтеграцияВызовСервера.УстановитьДатыПоследнегоОбновления(Организация, ДатаПоследнегоОбновления);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ДеталиОшибкиВыведены(ПодробноеПредставлениеОшибки)
	
	Результат = СтрЗаканчиваетсяНа(ПодробноеПредставлениеОшибки,
		ЕдиныйНалоговыйСчетИнтеграцияКлиентСервер.ТекстСлужебногоМаркераВЖР());
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти