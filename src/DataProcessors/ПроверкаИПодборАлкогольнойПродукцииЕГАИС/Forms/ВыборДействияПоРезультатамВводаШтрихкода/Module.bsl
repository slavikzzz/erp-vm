
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Элементы.ГруппаОтложитьАлкогольнуюПродукцию.Видимость = Ложь;
	
	ДобавитьОтсканированнуюУпаковку  = 2;
	УдалосьПодобратьНеизвестнуюМарку = 2;
	
	ОбработатьИПроверитьПереданныеПараметры();
	СформироватьЗаголовокФормы();
	СформироватьИнформациюОРезультатахПоиска();
	СформироватьПредложенияДействий();
	
	ПоддерживаемыеТипыПодключаемогоОборудования = "СканерШтрихкода";
	ОбщегоНазначенияИС.НастроитьПодключаемоеОборудование(ЭтотОбъект, ПоддерживаемыеТипыПодключаемогоОборудования);
	
	ОбщегоНазначенияСобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПриОткрытииФормы(Неопределено, ЭтотОбъект, ПоддерживаемыеТипыПодключаемогоОборудования);
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.НачатьОтключениеОборудованиеПриЗакрытииФормы(Неопределено, ЭтотОбъект);
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры

&НаКлиенте
Процедура ВнешнееСобытие(Источник, Событие, Данные)
	
	ПараметрыСканирования = ШтрихкодированиеОбщегоНазначенияИСКлиент.ПараметрыСканирования(ВладелецФормы);
	
	ШтрихкодированиеОбщегоНазначенияИСКлиент.ВнешнееСобытиеПолученыШтрихкоды("ПоискПоШтрихкодуЗавершение", ЭтотОбъект, Источник, Событие, Данные, ПараметрыСканирования);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура УказаннаяАлкогольнаяПродукцияПриИзменении(Элемент)
	
	ЗаполнитьСписокВыбораСправки2(ЭтотОбъект);
	ДоступностьОтветаДаПодборМарки(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура УказаннаяСправка2ПриИзменении(Элемент)
	
	ДоступностьОтветаДаПодборМарки(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияОтсканируйтеУпаковкуОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "ОтметитьЧтоУпаковкаБезУпаковки" Тогда
	
		Если ПустаяСтрока(ШтрихкодУпаковкиГдеДолжноБыть) Тогда
			
			ИзменитьКонтекстПроверки();
			
		ИначеЕсли РежимПроверки = ПредопределенноеЗначение("Перечисление.ВариантыПроверкиПоступившейПродукцииИС.ОставлятьТамГдеНайдены") Тогда
			
			ПереместитьУпаковкуВДругуюУпаковку(Неопределено);
			
		Иначе
			
			Элементы.ГруппаОтсканируйтеУпаковку.Видимость = Ложь;
			Элементы.ГруппаОтложитьУпаковку.Видимость     = Истина;
			
			Если СтатусПроверки = ПредопределенноеЗначение("Перечисление.СтатусыПроверкиНаличияПродукцииИС.Отложена") Тогда
				Элементы.ОтложитьУпаковку.Видимость         = Ложь;
				Элементы.ОтменаОтложитьУпаковку.Заголовок   = НСтр("ru = 'Закрыть';
																	|en = 'Закрыть'");
			Иначе
				Элементы.ОтложитьУпаковку.КнопкаПоУмолчанию = Истина;
			КонецЕсли;
			
			Элементы.ДекорацияОтложитьУпаковку.Заголовок  = ТекстОтложите(ЭтотОбъект);
			
		КонецЕсли;
	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияОтсканируйтеУпаковкуАлкогольнойПродукцииОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "ОтметитьЧтоАлкогольнаяПродукцияНайденаВнеУпаковки" Тогда
		
		Если РежимПроверки = ПредопределенноеЗначение("Перечисление.ВариантыПроверкиПоступившейПродукцииИС.ОставлятьТамГдеНайдены")
			Или ПустаяСтрока(ШтрихкодУпаковкиГдеДолжноБыть) Тогда
			
			ПереместитьВБутылкиБезУпаковки(Истина);
			
		Иначе
			
			Элементы.ГруппаОтсканируйтеУпаковкуАлкогольнойПродукции.Видимость = Ложь;
			Элементы.ГруппаОтложитьАлкогольнуюПродукцию.Видимость     = Истина;
			
			Если СтатусПроверки = ПредопределенноеЗначение("Перечисление.СтатусыПроверкиНаличияПродукцииИС.Отложена") Тогда
				Элементы.ОтложитьАлкогольнуюПродукцию.Видимость         = Ложь;
				Элементы.ОтменаОтложитьАлкогольнуюПродукцию.Заголовок   = НСтр("ru = 'Закрыть';
																				|en = 'Закрыть'");
			Иначе
				Элементы.ОтменаОтложитьАлкогольнуюПродукцию.КнопкаПоУмолчанию = Истина;
			КонецЕсли;
			
			Элементы.ДекорацияОтложитьАлкогольнуюПродукцию.Заголовок  = ТекстОтложите(ЭтотОбъект);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#Область ОтветыНаВопросы

&НаКлиенте
Процедура УдалосьПодобратьНеизвестнуюМаркуДаПриИзменении(Элемент)
	
	ПриОтветеУдалосьПодобратьНеизвестнуюМарку();
	
КонецПроцедуры

&НаКлиенте
Процедура УдалосьПодобратьНеизвестнуюМаркуНетПриИзменении(Элемент)
	
	ПриОтветеУдалосьПодобратьНеизвестнуюМарку();
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьОтсканированнуюУпаковкуПриИзменении(Элемент)
	
	Если ДобавитьОтсканированнуюУпаковку = 0 Тогда
		
		СтруктураДействия = Новый Структура;
		СтруктураДействия.Вставить("ВидДействия", "ДобавитьНовуюУпаковку");
		СтруктураДействия.Вставить("Штрихкод", Штрихкод);
		
		Закрыть(СтруктураДействия);
		
	Иначе
		
		Элементы.ГруппаОтветНаВопросДобавитьУпаковку.ТолькоПросмотр = Истина;
		Элементы.ГруппаНеДобавлятьОтсканированнуюУпаковку.Видимость = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПоискПоШтрихкодуВыполнить(Команда)
	
	ОчиститьСообщения();
	
	ШтрихкодированиеОбщегоНазначенияИСКлиент.ПоказатьВводШтрихкода(
		Новый ОписаниеОповещения("РучнойВводШтрихкодаЗавершение", ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура ОтложитьУпаковку(Команда)
	
	СтруктураДействия = Новый Структура;
	СтруктураДействия.Вставить("ВидДействия", "ОтложитьНайденноеВДругоеМесте");
	СтруктураДействия.Вставить("Штрихкод", Штрихкод);
	
	Закрыть(СтруктураДействия);
	
КонецПроцедуры

&НаКлиенте
Процедура ПереместитьВБутылкиБезУпаковки(ИзменятьКонтекстПроверки)
	
	СтруктураДействия = Новый Структура;
	СтруктураДействия.Вставить("ВидДействия",              "ПереместитьВБутылкиБезУпаковки");
	СтруктураДействия.Вставить("Штрихкод",                 Штрихкод);
	СтруктураДействия.Вставить("ИзменятьКонтекстПроверки", ИзменятьКонтекстПроверки);
	
	Закрыть(СтруктураДействия)
	
КонецПроцедуры

&НаКлиенте
Процедура ПоместитьНовуюВБутылкиБезУпаковки(Команда)
	
	СтруктураДействия = Новый Структура;
	СтруктураДействия.Вставить("ВидДействия",          "ПоместитьНовуюВБутылкиБезУпаковки");
	СтруктураДействия.Вставить("Штрихкод",             Штрихкод);
	СтруктураДействия.Вставить("АлкогольнаяПродукция", УказаннаяАлкогольнаяПродукция);
	СтруктураДействия.Вставить("Справка2",             УказаннаяСправка2);
	
	Закрыть(СтруктураДействия);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Оборудование

#КонецОбласти

#Область НастройкаОтображения

#Область АлкогольнаяПродукция

&НаСервере
Процедура УстановитьДействиеВыбратьАлкогольнуюПродукцию()
	
	ОжидаетсяСканированиеDataMatrix = Истина;
	
	Элементы.СтраницыНеНайдено.ТекущаяСтраница = Элементы.СтраницаОтсканировалиМаркуЕстьНеизвестные;
	Элементы.ГруппаВыборАкцизнойМарки.Видимость = Истина;
	Элементы.ГруппаСканированиеDataMatrixДоступно.Видимость = СканированиеDataMatrixДоступно;
	
	ДоступностьОтветаДаПодборМарки(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьНевозможностьИзмененияКонтекстаПроверкиПриПроверкеНаличияАлкогольнойПродукции()

	ОжидаетсяСканированиеУпаковки = Ложь;
	
	Элементы.ГруппаПроблемыПослеСканированияУпаковкиАлкогольнойПродукции.Видимость  = Ложь;
	Элементы.ГруппаОтсканируйтеУпаковкуАлкогольнойПродукции.Видимость               = Ложь;
	Элементы.ГруппаОтсканированнаяУпаковкаАлкогольнойПродукцииНеПроверена.Видимость = Истина;

КонецПроцедуры

&НаКлиенте
Процедура ПоказатьПовторноОтсканировалиУпаковкуАлкогольнойПродукции()
	
	ОжидаетсяСканированиеУпаковки = Истина;
	
	Элементы.ГруппаПроблемыПослеСканированияУпаковкиАлкогольнойПродукции.Видимость      = Истина;
	Элементы.КартинкаПроблемыПослеСканированияУпаковкиАлкогольнойПродукции.Видимость    = Истина;
	Элементы.ДекорацияОтсканированнаяУпаковкаАлкогольнойПродукцииНеПроверена.Заголовок  = 
		НСтр("ru = 'Вы повторно отсканировали алкогольную продукцию, необходимо осканировать упаковку, в которой она найдена.';
			|en = 'Вы повторно отсканировали алкогольную продукцию, необходимо осканировать упаковку, в которой она найдена.'");
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьОтсканированнаяУпаковкуАлкогольнойПродукцииНеНайдена()
	
	ОжидаетсяСканированиеУпаковки = Истина;
	
	Элементы.ГруппаПроблемыПослеСканированияУпаковкиАлкогольнойПродукции.Видимость      = Истина;
	Элементы.КартинкаПроблемыПослеСканированияУпаковкиАлкогольнойПродукции.Видимость    = Ложь;
	Элементы.ДекорацияПроблемыПослеСканированияУпаковкиАлкогольнойПродукции.Заголовок  = 
		НСтр("ru = 'Отсканированная упаковка в данных документа не найдена. Если вы хотите проверить её содержимое, закройте данную форму и отсканируйте ее заново.';
			|en = 'Отсканированная упаковка в данных документа не найдена. Если вы хотите проверить её содержимое, закройте данную форму и отсканируйте ее заново.'");
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьОтсканировалиАкцизнуюМаркуВместоУпаковкиАлкогольнойПродукции()
	
	ОжидаетсяСканированиеУпаковки = Истина;
	
	Элементы.ГруппаПроблемыПослеСканированияУпаковкиАлкогольнойПродукции.Видимость      = Истина;
	Элементы.КартинкаПроблемыПослеСканированияУпаковкиАлкогольнойПродукции.Видимость    = Истина;
	Элементы.ДекорацияПроблемыПослеСканированияУпаковкиАлкогольнойПродукции.Заголовок  = 
		НСтр("ru = 'Вы отсканировали акцизную марку, а надо отсканировать упаковку, в которой обнаружена алкогольная продукция.';
			|en = 'Вы отсканировали акцизную марку, а надо отсканировать упаковку, в которой обнаружена алкогольная продукция.'");
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьОтсканировалиКодDataMatrixВместоУпаковкиАлкогольнойПродукции()
	
	ОжидаетсяСканированиеУпаковки = Истина;
	
	Элементы.ГруппаПроблемыПослеСканированияУпаковкиАлкогольнойПродукции.Видимость      = Истина;
	Элементы.КартинкаПроблемыПослеСканированияУпаковкиАлкогольнойПродукции.Видимость    = Истина;
	Элементы.ДекорацияПроблемыПослеСканированияУпаковкиАлкогольнойПродукции.Заголовок  = 
		НСтр("ru = 'Вы отсканировали код ""data matrix"", а надо отсканировать упаковку, в которой обнаружена алкогольная продукция.';
			|en = 'Вы отсканировали код ""data matrix"", а надо отсканировать упаковку, в которой обнаружена алкогольная продукция.'");
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьПереместитьВУпаковкиБезБутылки()
	
	ОжидаетсяСканированиеУпаковки = Ложь;
	
	Элементы.ГруппаПроблемыПослеСканированияУпаковкиАлкогольнойПродукции.Видимость  = Ложь;
	Элементы.ГруппаОтсканируйтеУпаковкуАлкогольнойПродукции.Видимость               = Ложь;
	Элементы.ГруппаПереместитьВБутылкиБезУпаковки.Видимость                         = Истина;
	Элементы.ПереместитьВБутылкиБезУпаковки.КнопкаПоУмолчанию                       = Истина;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ПоказатьОтложитьАлкогольнуюПродукцию(Форма)
	
	Элементы = Форма.Элементы;
	
	Форма.ОжидаетсяСканированиеУпаковки = Ложь;
	
	Элементы.ГруппаПроблемыПослеСканированияУпаковкиАлкогольнойПродукции.Видимость  = Ложь;
	Элементы.ГруппаОтсканируйтеУпаковкуАлкогольнойПродукции.Видимость               = Ложь;
	
	Элементы.ГруппаОтложитьАлкогольнуюПродукцию.Видимость    = Истина;
	Элементы.ОтложитьАлкогольнуюПродукцию.КнопкаПоУмолчанию  = Истина;
	Элементы.ДекорацияОтложитьАлкогольнуюПродукцию.Заголовок = ТекстОтложите(Форма);

КонецПроцедуры

#КонецОбласти

#Область Упаковки

&НаКлиенте
Процедура ПоказатьНевозможностьИзмененияКонтекстаПроверкиПриПроверкеНаличияУпаковки()

	ОжидаетсяСканированиеУпаковки = Ложь;
	
	Элементы.ГруппаПовторноОтсканировали.Видимость                      = Ложь;
	Элементы.ГруппаОтсканируйтеУпаковку.Видимость                       = Ложь;
	Элементы.ГруппаПроблемыПослеСканированияУпаковкиУпаковки.Видимость  = Ложь;
	Элементы.ГруппаОтсканированнаяУпаковкаНеПроверена.Видимость         = Истина;
	
КонецПроцедуры 

&НаКлиентеНаСервереБезКонтекста
Процедура ПоказатьОтложитьУпаковку(Форма)

	Элементы = Форма.Элементы;
	
	Форма.ОжидаетсяСканированиеУпаковки = Ложь;
	
	Элементы.ГруппаПовторноОтсканировали.Видимость                     = Ложь;
	Элементы.ГруппаОтсканируйтеУпаковку.Видимость                      = Ложь;
	Элементы.ГруппаПроблемыПослеСканированияУпаковкиУпаковки.Видимость = Ложь;
	Элементы.ГруппаОтложитьУпаковку.Видимость                          = Истина;
	Элементы.ОтложитьУпаковку.КнопкаПоУмолчанию                        = Истина;
	Элементы.ДекорацияОтложитьУпаковку.Заголовок                       = ТекстОтложите(Форма);

КонецПроцедуры 

&НаКлиенте
Процедура ПоказатьПовторноОтсканировалиУпаковку()
	
	ОжидаетсяСканированиеУпаковки = Истина;
	
	Элементы.ГруппаПроблемыПослеСканированияУпаковкиУпаковки.Видимость = Ложь;
	Элементы.ГруппаПовторноОтсканировали.Видимость                     = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьОтсканированнаяУпаковкаУпаковкиНеНайдена()
	
	ОжидаетсяСканированиеУпаковки = Истина;
	
	Элементы.ГруппаПроблемыПослеСканированияУпаковкиУпаковки.Видимость      = Истина;
	Элементы.КартинкаПроблемыПослеСканированияУпаковкиУпаковки.Видимость    = Ложь;
	Элементы.ДекорацияПроблемыПослеСканированияУпаковкиУпаковки.Заголовок  = 
		НСтр("ru = 'Отсканированная упаковка в данных документа не найдена. Если вы хотите проверить её содержимое, закройте данную форму и отсканируйте ее заново.';
			|en = 'Отсканированная упаковка в данных документа не найдена. Если вы хотите проверить её содержимое, закройте данную форму и отсканируйте ее заново.'");
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьОтсканировалиКодDataMatrixВместоУпаковкиУпаковки()
	
	ОжидаетсяСканированиеУпаковки = Истина;
	
	Элементы.ГруппаПроблемыПослеСканированияУпаковкиУпаковки.Видимость      = Истина;
	Элементы.КартинкаПроблемыПослеСканированияУпаковкиУпаковки.Видимость    = Истина;
	Элементы.ДекорацияПроблемыПослеСканированияУпаковкиУпаковки.Заголовок  = 
		НСтр("ru = 'Вы отсканировали код ""data matrix"", а надо отсканировать упаковку, в которой обнаружена упаковка.';
			|en = 'Вы отсканировали код ""data matrix"", а надо отсканировать упаковку, в которой обнаружена упаковка.'");
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьОтсканировалиАкцизнуюМаркуВместоУпаковкиУпаковки()
	
	ОжидаетсяСканированиеУпаковки = Истина;
	
	Элементы.ГруппаПроблемыПослеСканированияУпаковкиУпаковки.Видимость      = Истина;
	Элементы.КартинкаПроблемыПослеСканированияУпаковкиУпаковки.Видимость    = Истина;
	Элементы.ДекорацияПроблемыПослеСканированияУпаковкиАлкогольнойПродукции.Заголовок  = 
		НСтр("ru = 'Вы отсканировали акцизную марку, а надо отсканировать упаковку, в которой обнаружена упаковка.';
			|en = 'Вы отсканировали акцизную марку, а надо отсканировать упаковку, в которой обнаружена упаковка.'");
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ПриОтветеНаВопросы

&НаКлиенте
Процедура ПриОтветеУдалосьПодобратьНеизвестнуюМарку()
	
	Если УдалосьПодобратьНеизвестнуюМарку = 0 Тогда
		
		Если УпаковкаНеСодержитсяВДанныхДокумента
			Или РежимПроверки = ПредопределенноеЗначение("Перечисление.ВариантыПроверкиПоступившейПродукцииИС.ОставлятьТамГдеНайдены") Тогда
			
			ДобавитьАлкогольнуюПродукцию();
			
		Иначе
			
			Элементы.ГруппаПереместитьВБутылкиБезУпаковкиНеНайдено.Видимость       = Истина;
			Элементы.ГруппаНеУдалосьИдентифицироватьАлкогольнуюПродукцию.Видимость = Ложь;
			Элементы.ПереместитьВБутылкиБезУпаковкиНеНайдено.КнопкаПоУмолчанию     = Истина;
			
		КонецЕсли;
		
	Иначе
		
		Элементы.ГруппаПереместитьВБутылкиБезУпаковкиНеНайдено.Видимость       = Ложь;
		Элементы.ГруппаНеУдалосьИдентифицироватьАлкогольнуюПродукцию.Видимость = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ДействияПриЗакрытии

&НаКлиенте
Процедура ПереместитьУпаковкуВДругуюУпаковку(ШтрихкодОтсканированнойУпаковки)

	СтруктураДействия = Новый Структура;
	СтруктураДействия.Вставить("ВидДействия", "ПереместитьУпаковкуВДругуюУпаковку");
	СтруктураДействия.Вставить("ШтрихкодПеремещаемойУпаковки", Штрихкод);
	СтруктураДействия.Вставить("ШтрихкодУпаковкиНазначения",   ШтрихкодОтсканированнойУпаковки);
	
	СтруктураДействия.Вставить("СтатусПроверки",
	                            ?(СтатусПроверки = ПредопределенноеЗначение("Перечисление.СтатусыПроверкиНаличияПродукцииИС.НеЧислилась"),
	                              СтатусПроверки,
	                              ПредопределенноеЗначение("Перечисление.СтатусыПроверкиНаличияПродукцииИС.ВНаличии")));
	
	Закрыть(СтруктураДействия);

КонецПроцедуры

&НаКлиенте
Процедура ПереместитьБутылкуВДругуюУпаковку(ШтрихкодОтсканированнойУпаковки)

	СтруктураДействия = Новый Структура;
	СтруктураДействия.Вставить("ВидДействия", "ПереместитьБутылкуВДругуюУпаковку");
	СтруктураДействия.Вставить("ШтрихкодПеремещаемойБутылки", Штрихкод);
	СтруктураДействия.Вставить("ШтрихкодУпаковкиНазначения",   ШтрихкодОтсканированнойУпаковки);
	
	СтруктураДействия.Вставить("СтатусПроверки",
	                            ?(СтатусПроверки = ПредопределенноеЗначение("Перечисление.СтатусыПроверкиНаличияПродукцииИС.НеЧислилась"),
	                              СтатусПроверки,
	                              ПредопределенноеЗначение("Перечисление.СтатусыПроверкиНаличияПродукцииИС.ВНаличии")));
	
	Закрыть(СтруктураДействия);

КонецПроцедуры 

&НаКлиенте
Процедура ДобавитьАлкогольнуюПродукцию()

	СтруктураДействия = Новый Структура;
	СтруктураДействия.Вставить("ВидДействия",            "ДобавлениеАлкогольнойПродукции");
	СтруктураДействия.Вставить("Штрихкод",               Штрихкод);
	СтруктураДействия.Вставить("АлкогольнаяПродукция",   УказаннаяАлкогольнаяПродукция);
	СтруктураДействия.Вставить("Справка2",               УказаннаяСправка2);
	Закрыть(СтруктураДействия);

КонецПроцедуры

&НаКлиенте
Процедура ИзменитьКонтекстПроверки()
	
	СтруктураДействия = Новый Структура;
	СтруктураДействия.Вставить("ВидДействия", "ИзменитьКонтекстПроверки");
	
	Закрыть(СтруктураДействия);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработкаПоискаПоШтрихкоду

&НаКлиенте
Процедура РучнойВводШтрихкодаЗавершение(ДанныеШтрихкода, ДополнительныеПараметры) Экспорт
	
	ПараметрыСканирования = ШтрихкодированиеОбщегоНазначенияИСКлиент.ПараметрыСканирования(ВладелецФормы);
	ПараметрыСканирования.СоздаватьШтрихкодУпаковки = Ложь;
	ПараметрыСканирования.КэшМаркируемойПродукции   = Неопределено;
	ПараметрыСканирования.СопоставлятьНоменклатуру  = Ложь;
	Если ОжидаетсяСканированиеУпаковки Тогда
		ПараметрыСканирования.ЗапрашиватьНоменклатуру = Ложь;
	Иначе
		ПараметрыСканирования.ЗапрашиватьНоменклатуру = РежимПодбораСуществующихУпаковок;
	КонецЕсли;
	
	ШтрихкодированиеОбщегоНазначенияИСКлиент.ОбработатьДанныеШтрихкода(
		"ПоискПоШтрихкодуЗавершение", ЭтотОбъект, ДанныеШтрихкода, ПараметрыСканирования);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоискПоШтрихкодуЗавершение(ДанныеШтрихкода, ДополнительныеПараметры) Экспорт
	
	Если Не ОжидаетсяСканированиеУпаковки
		И Не ОжидаетсяСканированиеDataMatrix Тогда
		Возврат;
	КонецЕсли;
	
	Если ДанныеШтрихкода = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ОжидаетсяСканированиеУпаковки Тогда
	
		ШтрихкодОтсканированнойУпаковки = ДанныеШтрихкода.Штрихкод;
		ЭтоУпаковкаДокумента   = УпаковкиДокумента.НайтиПоЗначению(ШтрихкодОтсканированнойУпаковки) <> Неопределено;
		ЭтоДобавленнаяУпаковка = ДобавленныеУпаковки.НайтиПоЗначению(ШтрихкодОтсканированнойУпаковки) <> Неопределено;
		МожноИзменитьКонтекст  = ДоступныеДляПроверкиУпаковки.НайтиПоЗначению(ШтрихкодОтсканированнойУпаковки) <> Неопределено;
	
	КонецЕсли;
	
	Если ТипУпаковкиНайденного = ПредопределенноеЗначение("Перечисление.ТипыУпаковок.МаркированныйТовар") Тогда
		
		Если ОжидаетсяСканированиеУпаковки Тогда
		
			ПоискПоШтрихкодуЗавершениеДляАлкогольнойПродукции(ЭтоУпаковкаДокумента,
			                                                  ЭтоДобавленнаяУпаковка,
			                                                  ШтрихкодОтсканированнойУпаковки,
			                                                  МожноИзменитьКонтекст,
			                                                  ДанныеШтрихкода);
		
		ИначеЕсли ОжидаетсяСканированиеDataMatrix Тогда
			
			ПоискПоШтрихкодуЗавершениеСканированиеDataMatrix(ДанныеШтрихкода);
			
		КонецЕсли;
	
	Иначе
		
		Если ОжидаетсяСканированиеУпаковки Тогда
			
			ПоискПоШтрихкодуЗавершениеДляУпаковки(ЭтоУпаковкаДокумента,
			                                      ЭтоДобавленнаяУпаковка,
			                                      ШтрихкодОтсканированнойУпаковки,
			                                      МожноИзменитьКонтекст,
			                                      ДанныеШтрихкода);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоискПоШтрихкодуЗавершениеДляАлкогольнойПродукции(ЭтоУпаковкаДокумента,
	                                                        ЭтоДобавленнаяУпаковка,
	                                                        ШтрихкодОтсканированнойУпаковки,
	                                                        МожноИзменитьКонтекст,
	                                                        ДанныеШтрихкода)

	Если ЭтоУпаковкаДокумента Или ЭтоДобавленнаяУпаковка Тогда
		
		Если ШтрихкодУпаковкиГдеДолжноБыть = ШтрихкодОтсканированнойУпаковки Тогда
			
			Если МожноИзменитьКонтекст Тогда
			
				ИзменитьКонтекстПроверки();
				
			Иначе
				
				ПоказатьНевозможностьИзмененияКонтекстаПроверкиПриПроверкеНаличияАлкогольнойПродукции();
				
			КонецЕсли;
			
		ИначеЕсли  ШтрихкодОтсканированнойУпаковки = Штрихкод Тогда
			
			ПоказатьПовторноОтсканировалиУпаковкуАлкогольнойПродукции();
			
		Иначе
			
			Если РежимПроверки = ПредопределенноеЗначение("Перечисление.ВариантыПроверкиПоступившейПродукцииИС.ОставлятьТамГдеНайдены") Тогда
				
				Если МожноИзменитьКонтекст Тогда
					
					ПереместитьБутылкуВДругуюУпаковку(ШтрихкодОтсканированнойУпаковки);
					
				Иначе
					
					ПоказатьНевозможностьИзмененияКонтекстаПроверкиПриПроверкеНаличияАлкогольнойПродукции();
					
				КонецЕсли;
				
			ИначеЕсли НеСодержитсяВДанныхДокумента И ЭтоДобавленнаяУпаковка Тогда
				
				ПереместитьБутылкуВДругуюУпаковку(ШтрихкодОтсканированнойУпаковки);
				
			ИначеЕсли НеСодержитсяВДанныхДокумента И ЭтоУпаковкаДокумента Тогда
				
				ПоказатьПереместитьВУпаковкиБезБутылки();
				
			Иначе
				
				ПоказатьОтложитьАлкогольнуюПродукцию(ЭтотОбъект);
				
			КонецЕсли;
			
		КонецЕсли;
		
	Иначе
		
		Если ДанныеШтрихкода.Свойство("ТипШтрихкода") Тогда
			
			Если ДанныеШтрихкода.ТипШтрихкода = ПредопределенноеЗначение("Перечисление.ТипыШтрихкодов.PDF417") Тогда
				
				ПоказатьОтсканировалиАкцизнуюМаркуВместоУпаковкиАлкогольнойПродукции();
				
			ИначеЕсли  ДанныеШтрихкода.ТипШтрихкода = ПредопределенноеЗначение("Перечисление.ТипыШтрихкодов.DataMatrix") Тогда
				
				ПоказатьОтсканировалиКодDataMatrixВместоУпаковкиАлкогольнойПродукции();
				
			Иначе
				
				ПоказатьОтсканированнаяУпаковкуАлкогольнойПродукцииНеНайдена();
				
			КонецЕсли;
			
		Иначе
			
			ПоказатьОтсканированнаяУпаковкуАлкогольнойПродукцииНеНайдена();
			
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры 

&НаКлиенте
Процедура ПоискПоШтрихкодуЗавершениеДляУпаковки(ЭтоУпаковкаДокумента,
	                                            ЭтоДобавленнаяУпаковка, 
	                                            ШтрихкодОтсканированнойУпаковки,
	                                            МожноИзменитьКонтекст,
	                                            ДанныеШтрихкода);
	
	Если Не ОжидаетсяСканированиеУпаковки Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭтоУпаковкаДокумента Или ЭтоДобавленнаяУпаковка Тогда
		
		Если ШтрихкодУпаковкиГдеДолжноБыть = ШтрихкодОтсканированнойУпаковки Тогда
			
			Если МожноИзменитьКонтекст Тогда
				
				ИзменитьКонтекстПроверки();
				
			Иначе
				
				ПоказатьНевозможностьИзмененияКонтекстаПроверкиПриПроверкеНаличияУпаковки();
				
			КонецЕсли;
			
		ИначеЕсли ШтрихкодОтсканированнойУпаковки = Штрихкод Тогда
			
			ПоказатьПовторноОтсканировалиУпаковку();
			
		ИначеЕсли ЭтоДобавленнаяУпаковка Тогда
			
			Если НеСодержитсяВДанныхДокумента Тогда
				
				ПереместитьУпаковкуВДругуюУпаковку(ШтрихкодОтсканированнойУпаковки);
			
			Иначе
				
				Если РежимПроверки = ПредопределенноеЗначение("Перечисление.ВариантыПроверкиПоступившейПродукцииИС.ОставлятьТамГдеНайдены") Тогда
					
					ПереместитьУпаковкуВДругуюУпаковку(ШтрихкодОтсканированнойУпаковки);
					
				Иначе
					
					ПоказатьОтложитьУпаковку(ЭтотОбъект);
					
				КонецЕсли;
				
			КонецЕсли;
			
		ИначеЕсли ЭтоУпаковкаДокумента Тогда
			
			Если РежимПроверки = ПредопределенноеЗначение("Перечисление.ВариантыПроверкиПоступившейПродукцииИС.ОставлятьТамГдеНайдены") Тогда
				
				Если МожноИзменитьКонтекст Тогда
					
					ПереместитьУпаковкуВДругуюУпаковку(ШтрихкодОтсканированнойУпаковки);
					
				Иначе
					
					ПоказатьНевозможностьИзмененияКонтекстаПроверкиПриПроверкеНаличияУпаковки();
					
				КонецЕсли;
				
			Иначе
				
				ПоказатьОтложитьУпаковку(ЭтотОбъект);
				
			КонецЕсли;
			
		КонецЕсли;
		
	Иначе
		
		Если ДанныеШтрихкода.Свойство("ТипШтрихкода") Тогда
			
			Если ДанныеШтрихкода.ТипШтрихкода = ПредопределенноеЗначение("Перечисление.ТипыШтрихкодов.PDF417") Тогда
				
				ПоказатьОтсканировалиАкцизнуюМаркуВместоУпаковкиУпаковки();
				
			ИначеЕсли  ДанныеШтрихкода.ТипШтрихкода = ПредопределенноеЗначение("Перечисление.ТипыШтрихкодов.DataMatrix") Тогда
				
				ПоказатьОтсканировалиКодDataMatrixВместоУпаковкиУпаковки();
				
			Иначе
				
				ПоказатьОтсканированнаяУпаковкаУпаковкиНеНайдена();
				
			КонецЕсли;
			
		Иначе
			
			ПоказатьОтсканированнаяУпаковкаУпаковкиНеНайдена();
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоискПоШтрихкодуЗавершениеСканированиеDataMatrix(ДанныеШтрихкода)
	
	НайденнаяАлкогольнаяПродукция = Неопределено;
	НайденнаяСправка2             = Неопределено;
	
	Если ЗначениеЗаполнено(ДанныеШтрихкода.Справка2) Тогда
		
		Если ДанныеВПулеНайдены(ДанныеШтрихкода.АлкогольнаяПродукция, 
			                    ДанныеШтрихкода.Справка2) Тогда
			
			НайденнаяАлкогольнаяПродукция = ДанныеШтрихкода.АлкогольнаяПродукция;
			НайденнаяСправка2             = ДанныеШтрихкода.Справка2;
			
		КонецЕсли;
		
	Иначе
		
		Для Каждого СтрокаСправки2 Из ДанныеШтрихкода.Справки2 Цикл
			
			Если ДанныеВПулеНайдены(СтрокаСправки2.АлкогольнаяПродукция, 
			                        СтрокаСправки2.Справка2) Тогда
			
				НайденнаяАлкогольнаяПродукция = СтрокаСправки2.АлкогольнаяПродукция;
				НайденнаяСправка2             = СтрокаСправки2.Справка2;
				
				Прервать;
			
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(НайденнаяАлкогольнаяПродукция) Тогда
		
		УказаннаяАлкогольнаяПродукция = НайденнаяАлкогольнаяПродукция;
		ЗаполнитьСписокВыбораСправки2(ЭтотОбъект);
		УказаннаяСправка2             = НайденнаяСправка2;
		ДоступностьОтветаДаПодборМарки(ЭтотОбъект);
		
		УдалосьПодобратьНеизвестнуюМарку = 0;
		ПриОтветеУдалосьПодобратьНеизвестнуюМарку();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ДанныеВПулеНайдены(АлкогольнаяПродукция, Справка2)
	
	ПараметрыПоиска = Новый Структура;
	ПараметрыПоиска.Вставить("АлкогольнаяПродукция", АлкогольнаяПродукция);
	
	НайденныеСтроки = ПулНеизвестныхАкцизныхМарок.НайтиСтроки(ПараметрыПоиска);
	
	Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл
		
		Для Каждого НайденнаяСправка2 Из НайденнаяСтрока.Справки2 Цикл
			
			Если НайденнаяСправка2.Справка2 = Справка2 Тогда
				
				Возврат Истина;
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
	
	Возврат Ложь;
	
КонецФункции

#КонецОбласти

#Область Прочее

&НаКлиентеНаСервереБезКонтекста
Функция ТекстОтложите(Форма)
	
	Если Форма.СтатусПроверки = ПредопределенноеЗначение("Перечисление.СтатусыПроверкиНаличияПродукцииИС.Отложена") Тогда
		
		Если ИнтеграцияИСКлиентСервер.ЭтоУпаковка(Форма.ТипУпаковкиНайденного) Тогда
			
			ТекстУпаковка = НСтр("ru = 'Упаковка';
								|en = 'Упаковка'");
			
		Иначе
			
			ТекстУпаковка = НСтр("ru = 'Бутылка';
								|en = 'Бутылка'");
			
		КонецЕсли;
		
		Возврат СтрШаблон(НСтр("ru = '%1 уже отложена и помечена стикером № ""%2"".';
								|en = '%1 уже отложена и помечена стикером № ""%2"".'"), 
			              ТекстУпаковка, 
			              Формат(Форма.СледующийСтикерОтложено - 1, "ЧДЦ=; ЧГ=0"));
		
	Иначе
		
		Если ИнтеграцияИСКлиентСервер.ЭтоУпаковка(Форма.ТипУпаковкиНайденного) Тогда
			
			ТекстУпаковка = НСтр("ru = 'упаковку';
								|en = 'упаковку'");
			
		Иначе
			
			ТекстУпаковка = НСтр("ru = 'бутылку';
								|en = 'бутылку'");
			
		КонецЕсли;
		
		Возврат СтрШаблон(НСтр("ru = 'Пометьте найденную %1 стикером № ""%2"" и отложите в сторону.';
								|en = 'Пометьте найденную %1 стикером № ""%2"" и отложите в сторону.'"), 
			                       ТекстУпаковка, 
			                       Формат(Форма.СледующийСтикерОтложено, "ЧДЦ=; ЧГ=0"));
		
	КонецЕсли;
	
КонецФункции

&НаСервере
Процедура ОбработатьИПроверитьПереданныеПараметры()
	
	Штрихкод       = Параметры.Штрихкод;
	ШтрихкодНайден = Параметры.ШтрихкодНайден;
	
	Если ЗначениеЗаполнено(Параметры.АдресПулаНеизвестныхАкцизныхМарок) Тогда
		
		ПолученныйПулАкцизныхМарок = ПолучитьИзВременногоХранилища(Параметры.АдресПулаНеизвестныхАкцизныхМарок);
		
		Если ТипЗнч(ПолученныйПулАкцизныхМарок) = Тип("ТаблицаЗначений") Тогда
			
			Для Каждого СтрокаПереданногоПула Из ПолученныйПулАкцизныхМарок Цикл
				
				Если Не СтрокаПереданногоПула.Количество > 0 Тогда
					Продолжить;
				КонецЕсли;
				
				ПараметрыОтбора = Новый Структура("АлкогольнаяПродукция", СтрокаПереданногоПула.АлкогольнаяПродукция);
				НайденныеСтроки = ПулНеизвестныхАкцизныхМарок.НайтиСтроки(ПараметрыОтбора);
				
				Если НайденныеСтроки.Количество() = 1 Тогда
					СтрокаПребразованногоПула = НайденныеСтроки[0];
				Иначе
					СтрокаПребразованногоПула = ПулНеизвестныхАкцизныхМарок.Добавить();
					СтрокаПребразованногоПула.АлкогольнаяПродукция = СтрокаПереданногоПула.АлкогольнаяПродукция;
				КонецЕсли;
				
				НоваяСтрокаСправки2 = СтрокаПребразованногоПула.Справки2.Добавить();
				НоваяСтрокаСправки2.Справка2 = СтрокаПереданногоПула.Справка2;
				
			КонецЦикла;
			
			Для Каждого СтрокаПула Из ПулНеизвестныхАкцизныхМарок Цикл
				
				Элементы.УказаннаяАлкогольнаяПродукция.СписокВыбора.Добавить(СтрокаПула.АлкогольнаяПродукция);
				
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЕсли;
	
	УказаннаяАлкогольнаяПродукция        = Параметры.НайденнаяАлкогольнаяПродукция;
	УказаннаяСправка2                    = Параметры.НайденнаяСправка2;
	
	ЭтоШтрихкодАлкогольнойПродукции      = Параметры.ЭтоШтрихкодАлкогольнойПродукции;
	УпаковкаНеСодержитсяВДанныхДокумента = Параметры.УпаковкаНеСодержитсяВДанныхДокумента;
	РежимПроверки                        = Параметры.РежимПроверки;
	СтатусПроверки                       = Параметры.СтатусПроверки;

	ШтрихкодУпаковкиГдеДолжноБыть        = Параметры.ШтрихкодУпаковкиГдеДолжноБыть;
	НеСодержитсяВДанныхДокумента         = Параметры.НеСодержитсяВДанныхДокумента;
	
	ТипУпаковкиГдеДолжноНаходиться       = Параметры.ТипУпаковкиГдеДолжноНаходиться;
	ТипУпаковкиГдеНашли                  = Параметры.ТипУпаковкиГдеНашли;
	ТипУпаковкиНайденного                = Параметры.ТипУпаковкиНайденного;
	
	НомерСтикераОтложено                 = Параметры.НомерСтикераОтложено;
	СледующийСтикерОтложено              = Параметры.СледующийСтикерОтложено;
	
	ДобавленныеУпаковки                  = Параметры.ДобавленныеУпаковки;
	УпаковкиДокумента                    = Параметры.УпаковкиДокумента;
	ДоступныеДляПроверкиУпаковки         = Параметры.ДоступныеДляПроверкиУпаковки;
	
	РежимПодбораСуществующихУпаковок     = Параметры.РежимПодбораСуществующихУпаковок;
	ОбработкаДанныхТСД                   = Параметры.ОбработкаДанныхТСД;
	
	СканированиеDataMatrixДоступно = АкцизныеМаркиЕГАИС.ВидимостьИнформацииОСканированииDataMatrix(Ложь);
	
КонецПроцедуры 

&НаСервере
Процедура СформироватьПредложенияДействий()
	
	Если Не ШтрихкодНайден Тогда
		
		Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.СтраницаНеНайдено;
		
		Если ЭтоШтрихкодАлкогольнойПродукции Тогда
			
			Если ПулНеизвестныхАкцизныхМарок.Количество() = 0 Тогда
				
				Элементы.СтраницыНеНайдено.ТекущаяСтраница = Элементы.СтраницаОтсканировалиМаркуНетНеизвестных;
				
			ИначеЕсли ЗначениеЗаполнено(УказаннаяАлкогольнаяПродукция)
				И ЗначениеЗаполнено(УказаннаяСправка2) Тогда
				
				Элементы.ПереместитьВБутылкиБезУпаковкиНеНайдено.КнопкаПоУмолчанию = Истина;
				Элементы.ГруппаПереместитьВБутылкиБезУпаковкиНеНайдено.Видимость   = Истина;
				
			Иначе
				
				УстановитьДействиеВыбратьАлкогольнуюПродукцию();
				
			КонецЕсли;
			
		Иначе
			
			УстановитьДействиеОтсканировалиНеизвестнуюУпаковку();
			
		КонецЕсли;
		
	Иначе
		
		Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.СтраницаНайдено;
		
		Если ТипУпаковкиНайденного = Перечисления.ТипыУпаковок.МаркированныйТовар Тогда
			
			Если ОбработкаДанныхТСД Тогда
				
				ПоказатьОтложитьАлкогольнуюПродукцию(ЭтотОбъект);
				
			Иначе
				
				ОжидаетсяСканированиеУпаковки = Истина;
				
			КонецЕсли;
			
			Элементы.СтраницыНайдено.ТекущаяСтраница = Элементы.СтраницаНайденоАлкогольнаяПродукция;
			
		Иначе
			
			Если ОбработкаДанныхТСД Тогда
				
				ПоказатьОтложитьУпаковку(ЭтотОбъект);
				
			Иначе
			
				ОжидаетсяСканированиеУпаковки = Истина;
				
			КонецЕсли;
			
			Элементы.СтраницыНайдено.ТекущаяСтраница = Элементы.СтраницаНайденоУпаковка;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьДействиеОтсканировалиНеизвестнуюУпаковку()

	Если РежимПодбораСуществующихУпаковок Тогда
		ТекстВопроса  = НСтр("ru = 'Добавить новую пустую упаковку?';
							|en = 'Добавить новую пустую упаковку?'");
	Иначе
		ТекстВопроса = НСтр("ru = 'Упаковка не найдена в данных документа. Добавить в список проверяемого?';
							|en = 'Упаковка не найдена в данных документа. Добавить в список проверяемого?'");
	КонецЕсли;
	
	Элементы.ДекорацияНеНайденоОтсканировалиУпаковку.Заголовок = ТекстВопроса;
	Элементы.СтраницыНеНайдено.ТекущаяСтраница = Элементы.СтраницаОтсканировалиУпаковку;

КонецПроцедуры 

&НаКлиентеНаСервереБезКонтекста
Процедура ЗаполнитьСписокВыбораСправки2(Форма)

	Форма.Элементы.УказаннаяСправка2.СписокВыбора.Очистить();
	
	Если  ЗначениеЗаполнено(Форма.УказаннаяАлкогольнаяПродукция) Тогда
		
		СтруктураПоиска = Новый Структура("АлкогольнаяПродукция", Форма.УказаннаяАлкогольнаяПродукция);
		НайденныеСтроки = Форма.ПулНеизвестныхАкцизныхМарок.НайтиСтроки(СтруктураПоиска);
		Если НайденныеСтроки.Количество() > 0 Тогда
			Справки2 = НайденныеСтроки[0].Справки2;
		Иначе
			Возврат;
		КонецЕсли;
		
		Для Каждого СтрокаСправки Из Справки2 Цикл
			Форма.Элементы.УказаннаяСправка2.СписокВыбора.Добавить(СтрокаСправки.Справка2);
		КонецЦикла;
		
		КоличествоВозможныхСправок = Справки2.Количество();
		
		Если КоличествоВозможныхСправок = 1 Тогда
			Форма.УказаннаяСправка2 = Форма.Элементы.УказаннаяСправка2.СписокВыбора[0].Значение;
		КонецЕсли;
	 
	КонецЕсли; 

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ДоступностьОтветаДаПодборМарки(Форма)

	ОтветДаДоступен = ЗначениеЗаполнено(Форма.УказаннаяАлкогольнаяПродукция)
	                  И ЗначениеЗаполнено(Форма.УказаннаяСправка2);

	Форма.Элементы.УдалосьПодобратьНеизвестнуюМаркуДа.Доступность = ОтветДаДоступен;
	Если Не ОтветДаДоступен И Форма.УдалосьПодобратьНеизвестнуюМарку = 0 Тогда
		Форма.УдалосьПодобратьНеизвестнуюМарку = 3;
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура СформироватьИнформациюОРезультатахПоиска()
	
	ПредставлениеШтрихкода = ШтрихкодированиеОбщегоНазначенияИСКлиентСервер.ПредставлениеШтрихкода(Штрихкод);
	
	СтрокаШтрихкод = Новый ФорматированнаяСтрока(ПредставлениеШтрихкода, Новый Шрифт(,,Истина));
	
	Если ШтрихкодНайден Тогда
		
		Если ИнтеграцияИСКлиентСервер.ЭтоУпаковка(ТипУпаковкиНайденного)  Тогда
			
			Префикс = НСтр("ru = 'Упаковка со штрихкодом';
							|en = 'Упаковка со штрихкодом'");
			
		Иначе
			
			Префикс = НСтр("ru = 'Алкогольная продукция с акцизной маркой';
							|en = 'Алкогольная продукция с акцизной маркой'");
			
		КонецЕсли;
		
		Если ИнтеграцияИСКлиентСервер.ЭтоУпаковка(ТипУпаковкиГдеДолжноНаходиться) Тогда
			
			Если ИнтеграцияИСКлиентСервер.ЭтоУпаковка(ТипУпаковкиГдеНашли) Тогда 
			
				Постфикс = НСтр("ru = 'найдена, но должна находиться в другой упаковке.';
								|en = 'найдена, но должна находиться в другой упаковке.'");
				
			Иначе
				
				Постфикс = НСтр("ru = 'найдена, но должна находиться в упаковке.';
								|en = 'найдена, но должна находиться в упаковке.'");
				
			КонецЕсли;
			
		Иначе
			
			Постфикс = НСтр("ru = 'найдена, но не должна находиться в упаковке.';
							|en = 'найдена, но не должна находиться в упаковке.'");
			
		КонецЕсли;
		
		ТекстШтрихкодНеНайден = Новый ФорматированнаяСтрока(
			Префикс, " """, СтрокаШтрихкод, """ ", Постфикс);
		
	Иначе
		
		ТекстШтрихкодНеНайден = Новый ФорматированнаяСтрока(
			НСтр("ru = 'Штрихкод';
				|en = 'Штрихкод'"), " """, СтрокаШтрихкод, """ ", НСтр("ru = 'в данных документа не найден.';
																		|en = 'в данных документа не найден.'"));
		
	КонецЕсли;
	
	Элементы.ДекорацияИнформацияОРезультатахПоиска.Заголовок = ТекстШтрихкодНеНайден;
	
КонецПроцедуры

&НаСервере
Процедура СформироватьЗаголовокФормы()
	
	Если ШтрихкодНайден Тогда
		
		Заголовок = НСтр("ru = 'Штрихкод найден';
						|en = 'Штрихкод найден'");
		
	Иначе
		
		Заголовок = НСтр("ru = 'Штрихкод не найден';
						|en = 'Штрихкод не найден'");
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
