
#Область ПрограммныйИнтерфейс

#Область ПараметрыСканирования

// Заполняет параметры сканирования по контексту.
// 
// Параметры:
//  Контекст - ФормаКлиентскогоПриложения, ДокументСсылка - источник заполнения параметров сканирования
//  ВидПродукции - ПеречислениеСсылка.ВидыПродукцииИС - по данному параметру будет проиходить отбор заполнения
//  ПараметрыСканирования - См. ШтрихкодированиеОбщегоНазначенияИСКлиент.ПараметрыСканирования
//  ПараметрыРежимаИсправленияОшибок - Структура - Параметры режима исправления ошибок
Процедура ЗаполнитьПараметрыСканирования(Контекст, ВидПродукции, ПараметрыСканирования, ПараметрыРежимаИсправленияОшибок = Неопределено) Экспорт
	
	ЗаполнитьРасширенныеПараметрыСканированияПоДокументам(Контекст, ПараметрыСканирования, ПараметрыРежимаИсправленияОшибок);
	
КонецПроцедуры

Процедура ДополнитьПараметрамиСканированияИСМП(ПараметрыСканирования) Экспорт
	
	Если ПараметрыСканирования.Свойство("ЭтоАгрегацияКодовМаркировкиИСМП") Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыСканирования.Вставить("ВыполняетсяЗагрузкаДанныхВФормуПроверкиИПодбораИСМП", Ложь);
	
	ПараметрыСканирования.Вставить("ОпределениеВидаПродукцииИСМП",     Ложь);
	ПараметрыСканирования.Вставить("СохранятьКодыМаркировкиВПулИСМП",  Ложь);
	ПараметрыСканирования.Вставить("ТребоватьПолныйКодМаркировкиИСМП", Ложь);
	ПараметрыСканирования.Вставить("ЗаписыватьЛогЗапросовИСМП",        Ложь);
	
	ПараметрыСканирования.Вставить("ВидОперацииИСМП",                   Неопределено);
	ПараметрыСканирования.Вставить("ЭтоПроверкаКодовМаркировкиИСМП",    Ложь);
	ПараметрыСканирования.Вставить("ЭтоАгрегацияКодовМаркировкиИСМП",   Ложь);
	ПараметрыСканирования.Вставить("ЭтоПечатьКодаМаркировкиИзПулаИСМП", Ложь);
	ПараметрыСканирования.Вставить("ЭтоОтчетПроизводственнойЛинии",     Ложь);
	ПараметрыСканирования.Вставить("ЭтоМаркировкаТоваровИСМП",          Ложь);
	ПараметрыСканирования.Вставить("ОперацияНанесенияТолькоДляНаборов", Ложь);
	
	ПараметрыСканирования.Вставить("ЗапрашиватьДанныеНеизвестныхУпаковокИСМП", Ложь);
	ПараметрыСканирования.Вставить("ЗапрашиватьДанныеСервисаИСМП",             Ложь);
	
	ПараметрыСканирования.Вставить("КонтролироватьСтатусыКодовМаркировкиИСМП",    Ложь);
	ПараметрыСканирования.Вставить("КонтролироватьВладельцевКодовМаркировкиИСМП", Ложь);
	ПараметрыСканирования.Вставить("ТребуетсяПроверкаСредствамиККТ",              Ложь);
	ПараметрыСканирования.Вставить("ККТФФД12ИСМП",                                Неопределено);
	ПараметрыСканирования.Вставить("ПодключенноеККТИСМП",                         Неопределено);
	ПараметрыСканирования.Вставить("ЭтоОблачнаяККТИСМП",                          Ложь);
	ПараметрыСканирования.Вставить("НомерФискальногоНакопителя",                  "");
	
	ПараметрыСканирования.Вставить("ИмяКолонкиРазрешительныйРежимИдентификаторЗапросаГИСМТ", Неопределено);
	ПараметрыСканирования.Вставить("ИмяКолонкиРазрешительныйРежимДатаЗапросаГИСМТ",          Неопределено);
	
	ПараметрыСканирования.Вставить("ПоддерживаетсяОбъемноСортовойУчет",        Ложь);
	ПараметрыСканирования.Вставить("ЗаполнятьGTINПотребительскихУпаковок",     Ложь);
	
	ПараметрыСканирования.Вставить("ТолькоВесоваяПродукция", Ложь);
	// ДатаДокумента - Параметр был предназначен установки даты отслеживания в контроле сроков годности продукции и контроля разделенных дат.
	// Изменен принцип проверки - для розничной продажи срок годности даже при пробитии из чека прошлой даты должен проверяться по актуальной дате.
	ПараметрыСканирования.Вставить("ДатаДокумента",                                        '00010101');
	
	ОбщегоНазначенияИСМПКлиентСервер.УстановитьПараметрСканированияЗапрашиватьДанныеНеизвестныхУпаковокИСМП(ПараметрыСканирования);
	ОбщегоНазначенияИСМПКлиентСервер.УстановитьПараметрСканированияЗапрашиватьДанныеСервисаИСМП(ПараметрыСканирования);
	
	НастройкиСканированияКодовМаркировки = ОбщегоНазначенияИСМПКлиентСерверПовтИсп.НастройкиСканированияКодовМаркировки();
	
	ПараметрыСканирования.КонтролироватьСтандартнуюВложенность      = НастройкиСканированияКодовМаркировки.КонтролироватьСтандартнуюВложенность;
	ПараметрыСканирования.ПропускатьСтрокиСОшибкамиПриЗагрузкеИзТСД = НастройкиСканированияКодовМаркировки.ПропускатьСтрокиСОшибкамиПриЗагрузкеИзТСД;
	ПараметрыСканирования.ПроверятьАлфавитКодовМаркировки           = НастройкиСканированияКодовМаркировки.ПроверятьАлфавитКодовМаркировки;
	
	ПараметрыСканирования.ПроверятьСтруктуруКодовМаркировки = НастройкиСканированияКодовМаркировки.ПроверятьСтруктуруКодовМаркировки;
	
	// Только для табачной продукции
	Если ПараметрыСканирования.Свойство("ПроверятьПотребительскиеУпаковкиНаВхождениеВСеруюЗонуМОТП") Тогда
		ПараметрыСканирования.ПроверятьПотребительскиеУпаковкиНаВхождениеВСеруюЗонуМОТП =
			НастройкиСканированияКодовМаркировки.ПроверятьПотребительскиеУпаковкиНаВхождениеВСеруюЗонуМОТП;
	КонецЕсли;
	Если ПараметрыСканирования.Свойство("ПроверятьЛогистическиеИГрупповыеУпаковкиНаСодержаниеСерыхКодовМОТП") Тогда
		ПараметрыСканирования.ПроверятьЛогистическиеИГрупповыеУпаковкиНаСодержаниеСерыхКодовМОТП =
			НастройкиСканированияКодовМаркировки.ПроверятьЛогистическиеИГрупповыеУпаковкиНаСодержаниеСерыхКодовМОТП;
	КонецЕсли;
	Если ПараметрыСканирования.Свойство("ДатаПроизводстваНачалаКонтроляСтатусовКодовМаркировкиМОТП") Тогда
		ПараметрыСканирования.ДатаПроизводстваНачалаКонтроляСтатусовКодовМаркировкиМОТП =
			НастройкиСканированияКодовМаркировки.ДатаПроизводстваНачалаКонтроляСтатусовКодовМаркировкиМОТП;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ПроверкаКодовМаркировкиСредствамиКТТ

// Конструктор элемента данных для проверки кода маркировки средствами ККТ.
// 
// Возвращаемое значение:
//  Структура - Новый элемент данных проверки средствами ККТ:
// * КодМаркировки                  - Строка - код маркировки.
// * ПолныйКодМаркировки            - Строка - полный код маркировки.
// * ПланируемыйСтатусТовара        - ПеречислениеСсылка.ПланируемыйСтатусМаркируемогоТовара - планируемый статус.
// * ВидПродукции                   - ПеречислениеСсылка.ВидыПродукцииИС - вид продукции.
// * ВидУпаковки                    - ПеречислениеСсылка.ВидыУпаковокИС  - вид упаковки.
// * ШтрихкодУпаковки               - Неопределено, ОпределяемыйТип.ШтрихкодУпаковкиИС - ссылка на штрихкод, используется в сценариях сохранения результатов проверки.
// * ПредставлениеНоменклатуры      - Строка, Неопределено - представление позиции для отображения пользователю. Если не заполнено - будет определяться по ШтрихкодУпаковки.
// * ПолученРезультатЗапросаКМ      - Булево - Служебный. Для блокировки повторного оповещения.
// * ТекстОшибки                    - Строка, Неопределено - текст ошибки распределения.
// * Количество                     - Число                - количество штук или иной мере (вес, объем и.т.д.).
// * ЧастичноеВыбытиеКоличество     - Число, Неопределено  - числитель частичного выбытия.
// * ЕмкостьПотребительскойУпаковки - Число, Неопределено  - знаменатель частичного выбытия.
// * КодЕдиницыИзмерения            - Строка, Неопределено - код единицы измерения частично выбытия
// * КоличествоПотребительскихУпаковок - Число - Количество потребительских упаковок
// * РазрешительныйРежимИдентификаторЗапросаГИСМТ - ОпределяемыйТип.УникальныйИдентификаторИС - идентификатор запроса ГИС МТ
// * РазрешительныйРежимДатаЗапросаГИСМТ - Строка - дата получения идентификатора ГИС МТ в формате timestamp
// * РазрешительныйРежимАдресСервера - Строка - адрес сервера разрешительного запроса
// * РазрешительныйРежимТелоЗапросаJSON - Строка - тело разрешительного запроса
// * РазрешительныйРежимТелоОтветаJSON - Строка - тело ответа разрешительного запроса
// * РазрешительныйРежимКодОтвета - Строка - код ответа разрешительного запроса
// * ПараметрыОшибки            - см. ШтрихкодированиеИСМПКлиентСервер.ПараметрыРасширенногоОписанияОшибки
// * ЧастичноеВыбытиеОстаток - Неопределено, Число - остаток во вскрытой потребительской упаковке
// * ЧастичноеВыбытиеКомментарий - Неопределено, Строка - комментарий к вскрытой потребительской упаковке
Функция НовыйЭлементДанныхПроверкиСредствамиККТ() Экспорт
	
	ВозвращаемоеЗначение = Новый Структура();
	ВозвращаемоеЗначение.Вставить("КодМаркировки",                                "");
	ВозвращаемоеЗначение.Вставить("ПолныйКодМаркировки",                          "");
	ВозвращаемоеЗначение.Вставить("ВидПродукции",                                 Неопределено);
	ВозвращаемоеЗначение.Вставить("ПолученРезультатЗапросаКМ",                    Ложь); // Блокировка от повторного оповещения
	ВозвращаемоеЗначение.Вставить("ПланируемыйСтатусТовара",                      Неопределено);
	ВозвращаемоеЗначение.Вставить("ВидУпаковки",                                  Неопределено);
	ВозвращаемоеЗначение.Вставить("ШтрихкодУпаковки",                             Неопределено);
	ВозвращаемоеЗначение.Вставить("СоставКодаМаркировки",                         Неопределено);
	ВозвращаемоеЗначение.Вставить("ПредставлениеНоменклатуры",                    Неопределено);
	ВозвращаемоеЗначение.Вставить("ИдентификаторЗапроса",                         СокрЛП(Новый УникальныйИдентификатор));
	ВозвращаемоеЗначение.Вставить("ИдентификаторЭлемента",                        СокрЛП(Новый УникальныйИдентификатор));
	ВозвращаемоеЗначение.Вставить("ТребуетВзвешивания",                           Ложь);
	ВозвращаемоеЗначение.Вставить("Количество",                                   0);
	ВозвращаемоеЗначение.Вставить("ЧастичноеВыбытиеКоличество",                   Неопределено);
	ВозвращаемоеЗначение.Вставить("ЕмкостьПотребительскойУпаковки",               Неопределено);
	ВозвращаемоеЗначение.Вставить("КодЕдиницыИзмерения",                          Неопределено);
	ВозвращаемоеЗначение.Вставить("ТекстОшибки",                                  Неопределено);
	ВозвращаемоеЗначение.Вставить("КоличествоПотребительскихУпаковок",            0);
	ВозвращаемоеЗначение.Вставить("РазрешительныйРежимИдентификаторЗапросаГИСМТ", "");
	ВозвращаемоеЗначение.Вставить("РазрешительныйРежимДатаЗапросаГИСМТ",          "");
	ВозвращаемоеЗначение.Вставить("РазрешительныйРежимАдресСервера",              "");
	ВозвращаемоеЗначение.Вставить("РазрешительныйРежимТелоЗапросаJSON",           "");
	ВозвращаемоеЗначение.Вставить("РазрешительныйРежимТелоОтветаJSON",            "");
	ВозвращаемоеЗначение.Вставить("РазрешительныйРежимКодОтвета",                 "");
	ВозвращаемоеЗначение.Вставить("ПараметрыОшибки",                              Неопределено);
	ВозвращаемоеЗначение.Вставить("ЧастичноеВыбытиеОстаток",                      Неопределено);
	ВозвращаемоеЗначение.Вставить("ЧастичноеВыбытиеКомментарий",                  Неопределено);
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

#КонецОбласти

#Область ТекстыОшибок

// Функция возвращает текст ошибки при работе с разрешительным режимом и подключенной ККТ
//  	с ФФД не 1.2. Только версия ФФД 1.2 поддерживает работу с разрешительным режимом и теги 1260.
// 
// Возвращаемое значение:
//  Строка
Функция ТекстОшибкиЗапрещенаРаботаРазрешительногоРежимаСФФД_1_05() Экспорт
	Возврат НСтр("ru = 'Подключенная ККТ не поддерживает разрешительный режим (требуется версия ФФД 1.2).';
				|en = 'Подключенная ККТ не поддерживает разрешительный режим (требуется версия ФФД 1.2).'");
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьРасширенныеПараметрыСканированияПоДокументам(Контекст, ПараметрыСканирования, ПараметрыРежимаИсправленияОшибок)
	
	Если ОбщегоНазначенияИСКлиентСервер.ЭтоРасширеннаяВерсияГосИС("ИСМП") Тогда
		
		#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
			//@skip-check wrong-string-literal-content
			Модуль = ОбщегоНазначения.ОбщийМодуль("ШтрихкодированиеИСМПКлиентСервер");
		#Иначе
			//@skip-check wrong-string-literal-content
			Модуль = ОбщегоНазначенияКлиент.ОбщийМодуль("ШтрихкодированиеИСМПКлиентСервер");
		#КонецЕсли
		
		Модуль.ЗаполнитьРасширенныеПараметрыСканированияПоДокументам(Контекст, ПараметрыСканирования, ПараметрыРежимаИсправленияОшибок);
		
	КонецЕсли;
	
КонецПроцедуры

#Область ПроверкаКодовМаркировкиСредствамиКТТ

Функция НовыйЭлементПроверкиСредствамиККТПоДаннымШтрихкода(ДанныеШтрихкода) Экспорт
	
	ЭлементПроверки  = НовыйЭлементДанныхПроверкиСредствамиККТ();
	ЗаполнитьЗначенияСвойств(ЭлементПроверки, ДанныеШтрихкода);
	Если ЗначениеЗаполнено(ДанныеШтрихкода.ПредставлениеНоменклатурыРР) Тогда
		ЭлементПроверки.ПредставлениеНоменклатуры = ДанныеШтрихкода.ПредставлениеНоменклатурыРР;
	КонецЕсли;
	ЭлементПроверки.КодМаркировки = ДанныеШтрихкода.НормализованныйШтрихкод;
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ДанныеШтрихкода, "ЧастичноеВыбытие")
		И ДанныеШтрихкода.ЧастичноеВыбытие Тогда
		ЭлементПроверки.ЕмкостьПотребительскойУпаковки = ДанныеШтрихкода.ЕмкостьПотребительскойУпаковки;
		ЭлементПроверки.ЧастичноеВыбытиеКоличество     = ЭлементПроверки.Количество;
		Если ЭлементПроверки.Количество < 1 Тогда
			ЭлементПроверки.ЧастичноеВыбытиеКоличество = Окр(ЭлементПроверки.ЕмкостьПотребительскойУпаковки * ЭлементПроверки.Количество);
		КонецЕсли;
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ДанныеШтрихкода, "РазрешительныйРежимДатаЗапросаГИСМТ") Тогда
		ЭлементПроверки.РазрешительныйРежимДатаЗапросаГИСМТ = ДанныеШтрихкода.РазрешительныйРежимДатаЗапросаГИСМТ;
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ДанныеШтрихкода, "РазрешительныйРежимИдентификаторЗапросаГИСМТ") Тогда
		ЭлементПроверки.РазрешительныйРежимИдентификаторЗапросаГИСМТ = ДанныеШтрихкода.РазрешительныйРежимИдентификаторЗапросаГИСМТ;
	КонецЕсли;
	
	Возврат ЭлементПроверки;
	
КонецФункции

Функция ВыполняемыеОперацииПроверкиСредствамиККТ() Экспорт
	
	ВозвращаемоеЗначение= Новый Структура();
	ВозвращаемоеЗначение.Вставить("ЛокальнаяПроверка",           "ЛокальнаяПроверка");
	ВозвращаемоеЗначение.Вставить("УдаленнаяПроверка",           "УдаленнаяПроверка");
	ВозвращаемоеЗначение.Вставить("Подтверждение",               "Подтверждение");
	ВозвращаемоеЗначение.Вставить("ПроверкаИдентификатораГИСМТ", "ПроверкаИдентификатораГИСМТ");
	ВозвращаемоеЗначение.Вставить("ПолучениеТокенаГИСМТ",        "ПолучениеТокенаГИСМТ");
	ВозвращаемоеЗначение.Вставить("ОбновлениеCDNПлощадок",       "ОбновлениеCDNПлощадок");
	ВозвращаемоеЗначение.Вставить("ПроверкаЕдинымМетодомБПО",    "ПроверкаЕдинымМетодомБПО");
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

Функция ДанныеПредставленияРезультатовПроверкиСредствамиККТ(СтрокаДанных, ДополнятьТекстомОшибки = Истина, ЭтоОблачнаяККТ = Истина) Экспорт
	
	ВозвращаемоеЗначение  = Новый Структура();
	ВозвращаемоеЗначение.Вставить("ЕстьОшибки",                   Ложь);
	ВозвращаемоеЗначение.Вставить("ТребуетсяПолныйКодМаркировки", Ложь);
	ВозвращаемоеЗначение.Вставить("ОписаниеОшибок",               "");
	ВозвращаемоеЗначение.Вставить("ПредставлениеВЧеке",           Неопределено);
	
	ПредставленияВЧеке  = ПредставлениеКодаМаркировкиВЧеке();
	МассивТекстовОшибки = Новый Массив;
	
	Если СтрокаДанных.ТребуетсяПолныйКодМаркировки Тогда
		
		ТекстОшибки = НСтр("ru = 'Отсутствует полный код маркировки';
							|en = 'Отсутствует полный код маркировки'");
		МассивТекстовОшибки.Добавить(ТекстОшибки);
		ВозвращаемоеЗначение.ТребуетсяПолныйКодМаркировки = Истина;
		
		ДополнитьПредставлениеВЧеке(ВозвращаемоеЗначение, ПредставленияВЧеке.Отсутствует);
		
	ИначеЕсли СтрокаДанных.ВидУпаковки <> ПредопределенноеЗначение("Перечисление.ВидыУпаковокИС.ОбъемноСортовойУчет")
		И Не ЭтоОблачнаяККТ Тогда
		
		ОшибочныеКодыПроверки = КодыРезультатаПроверкиДляОтображенияОшибки();
		ДанныеОписания        = ОшибочныеКодыПроверки.Получить(СтрокаДанных.ПредставлениеРезультатаПроверки);
		
		Если ДанныеОписания <> Неопределено Тогда
			
			ВозвращаемоеЗначение.ПредставлениеВЧеке = ДанныеОписания.ПредставлениеВЧеке;
			МассивТекстовОшибки.Добавить(ДанныеОписания.Описание);
			
		КонецЕсли;
	
		Если СтрокаДанных.КодМаркировкиПроверен
			И Не СтрокаДанных.РезультатПроверки
			И ДанныеОписания = Неопределено Тогда
			
			МассивТекстовОшибки.Добавить(НСтр("ru = 'Результат проверки КП КМ фискальным накопителем с использованием ключа проверки КП отрицательный.';
												|en = 'Результат проверки КП КМ фискальным накопителем с использованием ключа проверки КП отрицательный.'"));
			ДополнитьПредставлениеВЧеке(ВозвращаемоеЗначение, ПредставленияВЧеке.ММинус);
			
		КонецЕсли;
		
		Если СтрокаДанных.КодОбработкиЗапроса = "1" Тогда
			МассивТекстовОшибки.Добавить(НСтр("ru = 'Запрос проверки статуса ОИСМ имеет некорректный формат.';
												|en = 'Запрос проверки статуса ОИСМ имеет некорректный формат.'"));
			ДополнитьПредставлениеВЧеке(ВозвращаемоеЗначение, ПредставленияВЧеке.ММинус);
		ИначеЕсли СтрокаДанных.КодОбработкиЗапроса = "2" Тогда
			МассивТекстовОшибки.Добавить(НСтр("ru = 'Указанный в запросе код маркировки имеет некорректный формат (не распознан).';
												|en = 'Указанный в запросе код маркировки имеет некорректный формат (не распознан).'"));
			ДополнитьПредставлениеВЧеке(ВозвращаемоеЗначение, ПредставленияВЧеке.ММинус);
		КонецЕсли;
		
		Если Не СтрокаДанных.РезультаПроверкиОИСМ
			И ДанныеОписания = Неопределено
			И МассивТекстовОшибки.Количество() = 0 Тогда
			
			МассивТекстовОшибки.Добавить(НСтр("ru = 'Проверка статуса товара ОИСМ завершилась с отрицательным результатом.';
												|en = 'Проверка статуса товара ОИСМ завершилась с отрицательным результатом.'"));
			ДополнитьПредставлениеВЧеке(ВозвращаемоеЗначение, ПредставленияВЧеке.М);
			
		КонецЕсли;
		
		Если СтрокаДанных.СтатусТовара = ПредопределенноеЗначение("Перечисление.ОтветОИСМОСтатусеТовара.ОборотТовараПриостановлен")
			Или СтрокаДанных.СтатусТовара = ПредопределенноеЗначение("Перечисление.ОтветОИСМОСтатусеТовара.ПланируемыйСтатусТовараНекорректен") Тогда
			
			МассивТекстовОшибки.Добавить(Строка(СтрокаДанных.СтатусТовара));
			ДополнитьПредставлениеВЧеке(ВозвращаемоеЗначение, ПредставленияВЧеке.ММинус);
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если МассивТекстовОшибки.Количество() Тогда
		
		ВозвращаемоеЗначение.ЕстьОшибки = Истина;
		Если ДополнятьТекстомОшибки
			И ЗначениеЗаполнено(СтрокаДанных.ТекстОшибки) Тогда
			МассивТекстовОшибки.Добавить(СтрокаДанных.ТекстОшибки);
		КонецЕсли;
		
	КонецЕсли;
	
	ВозвращаемоеЗначение.ОписаниеОшибок = СтрСоединить(МассивТекстовОшибки, Символы.ПС);
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

// Представление кода маркировки в чеке.
// 
// Возвращаемое значение:
//  Структура - Представление кода маркировки в чеке:
// * Отсутствует - Строка - "[М] отсутствует".
// * МПлюс       - Строка - "[М+]".
// * ММинус      - Строка - "[М-]".
// * М           - Строка - "[М]".
Функция ПредставлениеКодаМаркировкиВЧеке() Экспорт
	
	ВозвращаемоеЗначение = Новый Структура();
	ВозвращаемоеЗначение.Вставить("Отсутствует", "[М] отсутствует");
	ВозвращаемоеЗначение.Вставить("МПлюс",       "[М+]");
	ВозвращаемоеЗначение.Вставить("ММинус",      "[М-]");
	ВозвращаемоеЗначение.Вставить("М",           "[М]");
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

// Новая структура установки дополнительных свойств при проверке ККТ.
// 
// Возвращаемое значение:
//  Структура - Новая структура установки дополнительных свойств при проверке ККТ:
// * Идентификатор        - УникальныйИдентификатор -
// * СтрокаТовары         - Структура, СтрокаТаблицыЗначений, СтрокаДереваЗначений - Исходная строка товаров с полями "Номенклатура", "Упаковка"
// * СтрокаНазначения     - см. ШтрихкодированиеИСМП.НовыйРезультатРаспределенияШтрихкодовПоТоварам, см. ШтрихкодированиеОбщегоНазначенияИСМПКлиентСервер.НовыйЭлементДанныхПроверкиСредствамиККТ -
//                          Коллекция свойств, в составе которых присутствует свойство: КодЕдиницыИзмерения.
// * ЭтоЧастичноеВыбытие  - Булево - Признак выбытия части потребительской упаковки.
// * ИсходнаяНоменклатура - Неопределено, ОпределяемыйТип.Номенклатура - Исходная номенклатура, если была выполнена подмена при частичном выбытии.
Функция НоваяСтруктураУстановкиДополнительныхСвойствПриПроверкеККТ() Экспорт
	
	ВозвращаемоеЗначение = Новый Структура();
	ВозвращаемоеЗначение.Вставить("Идентификатор",        Новый УникальныйИдентификатор());
	ВозвращаемоеЗначение.Вставить("СтрокаТовары",         Неопределено);
	ВозвращаемоеЗначение.Вставить("СтрокаНазначения",     Неопределено);
	ВозвращаемоеЗначение.Вставить("ЭтоЧастичноеВыбытие",  Ложь);
	ВозвращаемоеЗначение.Вставить("ИсходнаяНоменклатура", Неопределено);
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

// Вызывается при получении элеметнов проверки средставами ККТ для дозаполнения свойств прикладными данными.
// Используется для заполнения полей, которые будут переданы в методы проверки на ККТ, например, КодЕдиницыИзмерения.
// 
// Параметры:
//  ДанныеДляЗаполненияСвойств - Массив из см. НоваяСтруктураУстановкиДополнительныхСвойствПриПроверкеККТ - данные для обработки.
Процедура ПриУстановкеДополнительныхСвойствЭлеметовПроверкиСредствамиККТ(ДанныеДляЗаполненияСвойств) Экспорт
	
	Если ДанныеДляЗаполненияСвойств.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеОбработкиРезультата = Новый Соответствие();
	ДанныеОбработкиЗаполнения = Новый Массив();
	
	Для Каждого ЭлементДанных Из ДанныеДляЗаполненияСвойств Цикл
		ДанныеОбработкиРезультата.Вставить(ЭлементДанных.Идентификатор, ЭлементДанных.СтрокаНазначения);
		ДанныеОбработкиЗаполнения.Добавить(НовыйЭлементОбработкиУстановкиДополнительныхСвойствПриПроверкеККТ(ЭлементДанных));
	КонецЦикла;
	
	ШтрихкодированиеИСМПКлиентСерверПереопределяемый.ПриУстановкеДополнительныхСвойствЭлеметовПроверкиСредствамиККТ(ДанныеОбработкиЗаполнения);
	
	Для Каждого СтрокаДанныхОбработки Из ДанныеОбработкиЗаполнения Цикл
		СтрокаНазначения = ДанныеОбработкиРезультата[СтрокаДанныхОбработки.Идентификатор];
		СтрокаНазначения.КодЕдиницыИзмерения = СтрокаДанныхОбработки.КодЕдиницыИзмерения;
	КонецЦикла;
	
КонецПроцедуры

// Новый элемент обработки установки дополнительных свойств при проверки средствами ККТ.
// 
// Параметры:
//  ВходящаяСтруктураОбработки - см. НоваяСтруктураУстановкиДополнительныхСвойствПриПроверкеККТ
// 
// Возвращаемое значение:
//  Структура - Новый элемент обработки установки дополнительных свойств при проверке ККТ:
// * Идентификатор       - УникальныйИдентификатор - 
// * Номенклатура        - ОпределяемыйТип.Номенклатура -
// * Характеристика      - ОпределяемыйТип.ХарактеристикаНоменклатуры -
// * Упаковка            - ОпределяемыйТип.Упаковка -
// * ЭтоЧастичноеВыбытие - Булево - Признак выбытия части потребительской упаковки.
// * КодЕдиницыИзмерения - Строка - Код единицы измерения (тэг 2108).
Функция НовыйЭлементОбработкиУстановкиДополнительныхСвойствПриПроверкеККТ(ВходящаяСтруктураОбработки)
	
	ВозвращаемоеЗначение = Новый Структура();
	ВозвращаемоеЗначение.Вставить("Номенклатура",        Неопределено);
	ВозвращаемоеЗначение.Вставить("Характеристика",      Неопределено);
	ВозвращаемоеЗначение.Вставить("Упаковка",            Неопределено);
	ЗаполнитьЗначенияСвойств(ВозвращаемоеЗначение, ВходящаяСтруктураОбработки.СтрокаТовары);
	ВозвращаемоеЗначение.Вставить("КодЕдиницыИзмерения", Неопределено);
	ВозвращаемоеЗначение.Вставить("Идентификатор",       ВходящаяСтруктураОбработки.Идентификатор);
	ВозвращаемоеЗначение.Вставить("ЭтоЧастичноеВыбытие", ВходящаяСтруктураОбработки.ЭтоЧастичноеВыбытие);
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

Функция КодыРезультатаПроверкиДляОтображенияОшибки()
	
	ВозвращаемоеЗначение = Новый Соответствие();
	ПредставленияВЧеке   = ПредставлениеКодаМаркировкиВЧеке();
	
	ДобавитьОписаниеРезультатаПроверки(
		ВозвращаемоеЗначение,
		"00000000",
		ПредставленияВЧеке.М,
		НСтр("ru = 'Проверка КП КМ не выполнена, статус товара ОИСМ не проверен';
			|en = 'Проверка КП КМ не выполнена, статус товара ОИСМ не проверен'"));
	ДобавитьОписаниеРезультатаПроверки(
		ВозвращаемоеЗначение,
		"00000001",
		ПредставленияВЧеке.ММинус,
		НСтр("ru = 'Проверка КП КМ выполнена в ФН с отрицательным результатом, статус товара ОИСМ не проверен';
			|en = 'Проверка КП КМ выполнена в ФН с отрицательным результатом, статус товара ОИСМ не проверен'"));
	ДобавитьОписаниеРезультатаПроверки(
		ВозвращаемоеЗначение,
		"00000011",
		ПредставленияВЧеке.М,
		НСтр("ru = 'Проверка КП КМ выполнена с положительным результатом, статус товара ОИСМ не проверен';
			|en = 'Проверка КП КМ выполнена с положительным результатом, статус товара ОИСМ не проверен'"));
	ДобавитьОписаниеРезультатаПроверки(
		ВозвращаемоеЗначение,
		"00010000",
		ПредставленияВЧеке.М,
		НСтр("ru = 'Проверка КП КМ не выполнена, статус товара ОИСМ не проверен (ККТ функционирует в автономном режиме)';
			|en = 'Проверка КП КМ не выполнена, статус товара ОИСМ не проверен (ККТ функционирует в автономном режиме)'"));
	ДобавитьОписаниеРезультатаПроверки(
		ВозвращаемоеЗначение,
		"00010001",
		ПредставленияВЧеке.ММинус,
		НСтр("ru = 'Проверка КП КМ выполнена в ФН с отрицательным результатом, статус товара ОИСМ не проверен (ККТ функционирует в автономном режиме)';
			|en = 'Проверка КП КМ выполнена в ФН с отрицательным результатом, статус товара ОИСМ не проверен (ККТ функционирует в автономном режиме)'"));
	ДобавитьОписаниеРезультатаПроверки(
		ВозвращаемоеЗначение,
		"_00010011",
		ПредставленияВЧеке.М,
		НСтр("ru = 'Проверка КП КМ выполнена в ФН с положительным результатом, статус товара ОИСМ не проверен (ККТ функционирует в автономном режиме)';
			|en = 'Проверка КП КМ выполнена в ФН с положительным результатом, статус товара ОИСМ не проверен (ККТ функционирует в автономном режиме)'"));
	ДобавитьОписаниеРезультатаПроверки(
		ВозвращаемоеЗначение,
		"00000101",
		ПредставленияВЧеке.ММинус,
		НСтр("ru = 'Проверка КП КМ выполнена с отрицательным результатом, статус товара у ОИСМ некорректен';
			|en = 'Проверка КП КМ выполнена с отрицательным результатом, статус товара у ОИСМ некорректен'"));
	ДобавитьОписаниеРезультатаПроверки(
		ВозвращаемоеЗначение,
		"00000111",
		ПредставленияВЧеке.ММинус,
		НСтр("ru = 'Проверка КП КМ выполнена с положительным результатом, статус товара у ОИСМ некорректен';
			|en = 'Проверка КП КМ выполнена с положительным результатом, статус товара у ОИСМ некорректен'"));
	ДобавитьОписаниеРезультатаПроверки(
		ВозвращаемоеЗначение,
		"_00001111",
		ПредставленияВЧеке.МПлюс,
		НСтр("ru = 'Проверка КП КМ выполнена с положительным результатом, статус товара у ОИСМ корректен';
			|en = 'Проверка КП КМ выполнена с положительным результатом, статус товара у ОИСМ корректен'"));
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

Процедура ДобавитьОписаниеРезультатаПроверки(Коллекция, Код, ПредставлениеВЧеке, Описание)
	
	ДанныеОписания = Новый Структура();
	ДанныеОписания.Вставить("ПредставлениеВЧеке", ПредставлениеВЧеке);
	ДанныеОписания.Вставить("Описание",           Описание);
	
	Коллекция.Вставить(Код, ДанныеОписания);
	
КонецПроцедуры

Процедура ДополнитьПредставлениеВЧеке(ПараметрыПредставления, Значение)
	
	Если Не ЗначениеЗаполнено(ПараметрыПредставления.ПредставлениеВЧеке) Тогда
		ПараметрыПредставления.ПредставлениеВЧеке = Значение;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

