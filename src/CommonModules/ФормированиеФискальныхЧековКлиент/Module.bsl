#Область ПрограммныйИнтерфейс

// Открывает форму предпросмотра чека
// 
// Параметры:
// 	Форма - ФормаКлиентскогоПриложения - Форма документа
// 	ФискальнаяОперацияЗавершение - ОписаниеОповещения - Обработчик закрытия формы
Процедура ОтобразитьЧек(Форма, ФискальнаяОперацияЗавершение) Экспорт
	
	ОчиститьСообщения();
	
	ОбработатьРежимЗаписи(СформироватьСтруктуруПараметровОбработкиОтображенияЧека(Форма, ФискальнаяОперацияЗавершение));
	
КонецПроцедуры

// Выполняет команду фискализации
//
// Параметры:
// 	Форма - ФормаКлиентскогоПриложения - Форма документа, состоит из:
// 	* Объект - ДокументОбъект - Основной реквизит формы
// 	НавигационнаяСсылка - Строка - Имя команды фискализации
// 	СтандартнаяОбработка - Булево - Признак стандартной обработки
//
Процедура ФискальнаяОперацияОбработкаНавигационнойСсылки(Форма, НавигационнаяСсылка, СтандартнаяОбработка) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыФискализации = ОбщегоНазначенияУТКлиентСервер.ПолучитьДанныеМеханизмаИзКэшаФормы(Форма, "РозничныеПродажи");
	
	Если "ПробитьЧек" = НавигационнаяСсылка Тогда
		
		ФормированиеФискальныхЧековКлиент.ОтобразитьЧек(
			Форма,
			Новый ОписаниеОповещения("ФискальнаяОперацияЗавершение", Форма));
			
	ИначеЕсли "ПробитьЧекИнкассацияВыемка" = НавигационнаяСсылка Тогда
		
		ОборудованиеПодключенноеПоТорговомуОбъекту = ПодключаемоеОборудованиеУТВызовСервера.ОборудованиеПодключенноеПоТорговомуОбъектуВзаимодействующееОнлайнС1С(ПараметрыФискализации.ТорговыйОбъект);
		Если ОборудованиеПодключенноеПоТорговомуОбъекту.ККТ.Количество() = 1 Тогда
			ПараметрыФискализации.Вставить("ПодключенноеОборудование", ОборудованиеПодключенноеПоТорговомуОбъекту.ККТ[0]);
		КонецЕсли;
		
		ДополнительныеПараметрыОповещения = Новый Структура("РезультатВыполненияФискальнойОперации,СсылкаНаДокумент", Неопределено, Неопределено);
		
		ПодключаемоеОборудованиеУТКлиент.ПробитьЧекВыемкаДенежныхСредств(
			Форма,
			ПараметрыФискализации,
			РежимЗаписиДокумента.Проведение,
			Новый ОписаниеОповещения("ФискальнаяОперацияЗавершение", Форма, ДополнительныеПараметрыОповещения));
		
	ИначеЕсли "ПробитьЧекИнкассацияВнесение" = НавигационнаяСсылка Тогда
		
		ОборудованиеПодключенноеПоТорговомуОбъекту = ПодключаемоеОборудованиеУТВызовСервера.ОборудованиеПодключенноеПоТорговомуОбъектуВзаимодействующееОнлайнС1С(ПараметрыФискализации.ТорговыйОбъект);
		Если ОборудованиеПодключенноеПоТорговомуОбъекту.ККТ.Количество() = 1 Тогда
			ПараметрыФискализации.Вставить("ПодключенноеОборудование", ОборудованиеПодключенноеПоТорговомуОбъекту.ККТ[0]);
		КонецЕсли;
		
		ДополнительныеПараметрыОповещения = Новый Структура("РезультатВыполненияФискальнойОперации,СсылкаНаДокумент", Неопределено, Неопределено);
		
		ПодключаемоеОборудованиеУТКлиент.ПробитьЧекВнесениеДенежныхСредств(
			Форма,
			ПараметрыФискализации,
			РежимЗаписиДокумента.Проведение,
			Новый ОписаниеОповещения("ФискальнаяОперацияЗавершение", Форма, ДополнительныеПараметрыОповещения));
		
	ИначеЕсли "ОткрытьЗаписьФискальнойОперации" = НавигационнаяСсылка Тогда
		
		ПодключаемоеОборудованиеУТКлиент.ОткрытьЗаписьФискальнойОперации(Форма, Форма.Объект.Ссылка);
		
	ИначеЕсли "НастроитьОборудование" = НавигационнаяСсылка Тогда
		
		ОткрытьФорму("Обработка.ПредпросмотрЧека.Форма.ОшибкаПодключенияККТ");
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция СформироватьСтруктуруПараметровОбработкиОтображенияЧека(Форма, ФискальнаяОперацияЗавершение)
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Форма",                   Форма);
	ДополнительныеПараметры.Вставить("ПараметрыОперации",       Новый Структура);
	ДополнительныеПараметры.Вставить("ОповещениеПриЗавершении", ФискальнаяОперацияЗавершение);
	
	Возврат ДополнительныеПараметры;
	
КонецФункции

Функция ДокументПроведен(ДополнительныеПараметры)
	
	ДокументПроведен = Истина;
	
	Если Не ДополнительныеПараметры.Форма.Объект.Проведен Или ДополнительныеПараметры.Форма.Модифицированность Тогда
		ДокументПроведен = Ложь;
	КонецЕсли;
	
	Возврат ДокументПроведен;
	
КонецФункции

Процедура ОбновитьПараметрыОперации(ДополнительныеПараметры)
	
	ПараметрыОперации = ОбщегоНазначенияУТКлиентСервер.ПолучитьДанныеМеханизмаИзКэшаФормы(
		ДополнительныеПараметры.Форма,
		"РозничныеПродажи");
	
	ДополнительныеПараметры.ПараметрыОперации.Вставить("ПараметрыОперации", ПараметрыОперации);
	
КонецПроцедуры

#Область ОбработкаРежимаЗаписиДокумента

Процедура ПослеОтветаНаВопросОПроведенииДокумента(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		
		ПодключаемоеОборудованиеУТКлиент.ЗаписатьОбъект(
			ДополнительныеПараметры.Форма,
			РежимЗаписиДокумента.Проведение,
			Новый ОписаниеОповещения("ОтобразитьЧекПослеЗаписиДокумента", ЭтотОбъект, ДополнительныеПараметры));
		
	КонецЕсли;
	
КонецПроцедуры

// Обработчик оповещения после записи документа
// 
// Параметры:
// 	Результат - Булево - Результат записи документа (ИСТИНА если записан)
// 	ДополнительныеПараметры - Структура - Дополнительные параметры операции, состоит из:
// 	* Форма - ФормаКлиентскогоПриложения - Форма документа, состоит из:
// 	** Объект - ДокументОбъект - Основной реквизит формы
// 	* ПараметрыОперации - Структура - Основные параметры операции по документу
// 	* ОповещениеПриЗавершении - ОписаниеОповещения -
Процедура ОтобразитьЧекПослеЗаписиДокумента(Результат, ДополнительныеПараметры) Экспорт
	
	Если НЕ ДокументПроведен(ДополнительныеПараметры) Тогда
		
		ТекстОшибки = НСтр("ru = 'Не удалось провести документ';
							|en = 'Cannot post the document'");
		ОбработатьОшибку(ТекстОшибки, ДополнительныеПараметры.ОповещениеПриЗавершении);
		
	Иначе
		
		Форма = ДополнительныеПараметры.Форма;
		
		ИмяКомандыПробитияЧека = "";
		Если ОбщегоНазначенияУТКлиентСервер.ЕстьРеквизитОбъекта(Форма, "ИмяКомандыПробитияЧека") Тогда
			ИмяКомандыПробитияЧека = Форма.ИмяКомандыПробитияЧека;
		КонецЕсли;
		
		ТипРасчета = Неопределено;
		Если ОбщегоНазначенияУТКлиентСервер.ЕстьРеквизитОбъекта(Форма, "ТипРасчета") Тогда
			ТипРасчета = Форма.ТипРасчета;
		КонецЕсли;
		
		Если НЕ ШтрихкодыУпаковокПоДокументамЗаполнены(Форма, ДополнительныеПараметры) Тогда
			ТекстОшибки = НСтр("ru = 'Штрихкоды упаковок не заполнены';
								|en = 'The packaging unit barcodes are not filled'");
			ОбработатьОшибку(ТекстОшибки, ДополнительныеПараметры.ОповещениеПриЗавершении);
			Возврат;
		КонецЕсли;
		
		ТекстСообщения = "";
		
		Если ФормированиеФискальныхЧековВызовСервера.ПробитФискальныйЧекПоДокументу(Форма.Объект.Ссылка, ТипРасчета) Тогда
			
			ТекстОшибки = НСтр("ru = 'По документу уже был пробит чек';
								|en = 'Receipt of the document was printed already'");
			ОбработатьОшибку(ТекстОшибки, ДополнительныеПараметры.ОповещениеПриЗавершении);
			
		ИначеЕсли НЕ ФормированиеФискальныхЧековВызовСервера.ОбъектыРасчетовВДокументеОплатыВведеныКорректно(Форма.Объект.Ссылка, ТекстСообщения, ИмяКомандыПробитияЧека) Тогда
			
			ТекстОшибки = СтрШаблон(НСтр("ru = '%1';
										|en = '%1'"), ТекстСообщения);
			ОбработатьОшибку(ТекстОшибки, ДополнительныеПараметры.ОповещениеПриЗавершении);
			
		Иначе
			
			ОбновитьПараметрыОперации(ДополнительныеПараметры);
			ОткрытьФормуПредпросмотраЧека(ДополнительныеПараметры);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Функция ШтрихкодыУпаковокПоДокументамЗаполнены(Форма, ДополнительныеПараметры)
	
	Результат = Истина;
	
	ДокументыРеализации = Новый Массив;
	Если Форма.ИмяФормы = "Документ.ПриходныйКассовыйОрдер.Форма.ФормаДокумента"
		ИЛИ Форма.ИмяФормы = "Документ.ОперацияПоПлатежнойКарте.Форма.ФормаДокумента"
		ИЛИ Форма.ИмяФормы = "Документ.ПоступлениеБезналичныхДенежныхСредств.Форма.ФормаДокумента" Тогда
		
		Для Каждого СтрокаРасшифровкиПлатежа Из Форма.Объект.РасшифровкаПлатежа Цикл
			
			Если ТипЗнч(СтрокаРасшифровкиПлатежа.ОбъектРасчетов) = Тип("ДокументСсылка.РеализацияТоваровУслуг") Тогда
				ДокументыРеализации.Добавить(СтрокаРасшифровкиПлатежа.ОбъектРасчетов);
				Продолжить;
			КонецЕсли;
			
			Если ТипЗнч(СтрокаРасшифровкиПлатежа.ОснованиеПлатежа) = Тип("ДокументСсылка.РеализацияТоваровУслуг") Тогда
				ДокументыРеализации.Добавить(СтрокаРасшифровкиПлатежа.ОснованиеПлатежа);
				Продолжить;
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
	Если НЕ ФормированиеФискальныхЧековВызовСервера.ШтрихкодыУпаковокПоДокументамЗаполнены(ДокументыРеализации) Тогда
		Результат = Ложь;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Процедура ОбработатьРежимЗаписи(ДополнительныеПараметры)
	
	Если Не ДокументПроведен(ДополнительныеПараметры) Тогда
		ОтобразитьВопросОНеобходимостиПроведенияДокумента(ДополнительныеПараметры);
	Иначе
		ОтобразитьЧекПослеЗаписиДокумента(Истина, ДополнительныеПараметры);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОтобразитьВопросОНеобходимостиПроведенияДокумента(ДополнительныеПараметры)
	
	ПоказатьВопрос(
		Новый ОписаниеОповещения("ПослеОтветаНаВопросОПроведенииДокумента", ЭтотОбъект, ДополнительныеПараметры),
		НСтр("ru = 'Операция возможна только после проведения документа, провести документ?';
			|en = 'The operation is possible only after posting the document. Post the document?'"),
		РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

Процедура ОбработатьОшибку(ТекстОшибки, ОповещениеПриЗавершении)
	
	ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстОшибки);
	
	Если ОповещениеПриЗавершении <> Неопределено Тогда
		ВыполнитьОбработкуОповещения(ОповещениеПриЗавершении, Ложь);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

Процедура ОткрытьФормуПредпросмотраЧека(ДополнительныеПараметры)
	
	ПараметрыОперации       = ДополнительныеПараметры.ПараметрыОперации;
	ВладелецФормы           = ДополнительныеПараметры.Форма;
	ОповещениеПриЗавершении = ДополнительныеПараметры.ОповещениеПриЗавершении;
	
	ОткрытьФорму("Обработка.ПредпросмотрЧека.Форма", ПараметрыОперации, ВладелецФормы,,,, ОповещениеПриЗавершении);
	
КонецПроцедуры

#КонецОбласти
