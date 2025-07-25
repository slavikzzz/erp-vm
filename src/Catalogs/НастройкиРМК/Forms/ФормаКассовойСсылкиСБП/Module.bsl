
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	НастройкиПодключенияКПлатежнымСистемамДействующихДоговоров.Загрузить(Параметры.НастройкиПодключенияКПлатежнымСистемамДействующихДоговоров.Выгрузить());
	ДоговорПодключенияДоИзменения = Параметры.ДоговорПодключения;
	ДоговорПодключения = Параметры.ДоговорПодключения;
	КассоваяСсылка = Параметры.КассоваяСсылка;
	ИдентификаторОплаты = Параметры.ИдентификаторОплаты;
	
	ОтобразитьNFCСсылку();
	
	ОтборДляПоиска = Новый Структура("КассовыеСсылки", Истина); 
	ПоддерживаютсяОперацииПоКассовойСсылке = (НастройкиПодключенияКПлатежнымСистемамДействующихДоговоров.НайтиСтроки(ОтборДляПоиска).Количество() > 0);
	Если Не ПравоДоступа("Редактирование", Метаданные.Справочники.НастройкиРМК)
		Или Не ПоддерживаютсяОперацииПоКассовойСсылке
		Или ЗначениеЗаполнено(КассоваяСсылка) Тогда
		
		ТолькоПросмотр = Истина;
		Элементы.ДоговорПодключения.ТолькоПросмотр = Истина;
		Элементы.ИдентификаторОплаты.ТолькоПросмотр = Истина;
		Элементы.КассоваяСсылка.ТолькоПросмотр = Истина;
		Элементы.NFCСсылка.ТолькоПросмотр = Истина;
		
		Если Не ПоддерживаютсяОперацииПоКассовойСсылке Тогда
			ШаблонСообщения = НСтр("ru = 'Форма открыта в режиме просмотра. Не найдено действующих договоров подключения к платежным системам, поддерживающих операции с видом ссылки %1';
									|en = 'The form is opened in view mode. No valid payment system contracts that support transactions with the %1 link kind are found'");
			ОбщегоНазначения.СообщитьПользователю(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						ШаблонСообщения,
						ПредопределенноеЗначение("Перечисление.ВидыСсылокСБП.КассоваяСсылкаСБП")));
		Иначе
						
			Если ЗначениеЗаполнено(ДоговорПодключения) Тогда
				ОтборДляПоиска.Вставить("ДоговорПодключения", ДоговорПодключения);
				Если НастройкиПодключенияКПлатежнымСистемамДействующихДоговоров.НайтиСтроки(ОтборДляПоиска).Количество() = 0 Тогда
				
					ШаблонСообщения = НСтр("ru = 'Форма открыта в режиме просмотра. По указанному договору подключения не поддерживаются операции с видом ссылки %1';
											|en = 'Форма открыта в режиме просмотра. По указанному договору подключения не поддерживаются операции с видом ссылки %1'");
					ОбщегоНазначения.СообщитьПользователю(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
								ШаблонСообщения,
								ПредопределенноеЗначение("Перечисление.ВидыСсылокСБП.КассоваяСсылкаСБП")));
				КонецЕсли;
			КонецЕсли;
						
		КонецЕсли;

	КонецЕсли;
	
	СобытияФорм.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
	УстановитьДоступностьКоманд();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	ПараметрыЗакрытияФормы = Новый Структура();
	ПараметрыЗакрытияФормы.Вставить("ДоговорПодключения", Неопределено);
	ПараметрыЗакрытияФормы.Вставить("КассоваяСсылка", "");
	ПараметрыЗакрытияФормы.Вставить("ИдентификаторОплаты", "");

	Если Не ТолькоПросмотр Тогда
		ПараметрыЗакрытияФормы.Вставить("ДоговорПодключения", ДоговорПодключения);
		ПараметрыЗакрытияФормы.Вставить("КассоваяСсылка", КассоваяСсылка);
		ПараметрыЗакрытияФормы.Вставить("ИдентификаторОплаты", ИдентификаторОплаты);
	КонецЕсли;
	
	Оповестить("ЗавершитьСозданиеКассовойСсылкиСБП", ПараметрыЗакрытияФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	ОтобразитьNFCСсылку();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДоговорПодключенияПриИзменении(Элемент)
	
	ОчиститьСообщения();
	ОтборДляПоиска = Новый Структура("ДоговорПодключения,КассовыеСсылки", ДоговорПодключения, Истина);
	Если ЗначениеЗаполнено(ДоговорПодключения)
		И НастройкиПодключенияКПлатежнымСистемамДействующихДоговоров.НайтиСтроки(ОтборДляПоиска).Количество() = 0 Тогда
		ШаблонСообщения = НСтр("ru = 'Договор %1 не поддерживает операции с видом ссылки %2';
								|en = 'The %1 contract does not support transactions with the %2 link kind'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					ШаблонСообщения,
					ДоговорПодключения,
					ПредопределенноеЗначение("Перечисление.ВидыСсылокСБП.КассоваяСсылкаСБП")));
		
		ДоговорПодключения = ДоговорПодключенияДоИзменения;
	КонецЕсли;
	Если ДоговорПодключения <> ДоговорПодключенияДоИзменения Тогда
		ДоговорПодключенияДоИзменения = ДоговорПодключения;
	КонецЕсли;

	УстановитьДоступностьКоманд();
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияИнструкцияПрограммированияМеткиНажатие(Элемент)
	
	ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку(
		"https://downloads.v8.1c.ru/content/Instruction/programming-NFC-tags.pdf");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗакрытьФорму(Команда)
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьQRКод(Команда)
	
	СформироватьQRКодНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПодключитьQRКод(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ПодключитьКассовуюСсылкуЗавершение",
		ЭтотОбъект);
	
	ПереводыСБПc2bКлиент.ПодключитьКассовуюСсылку(
		НастройкаПодключения(),
		ОписаниеОповещения,
		ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПодключитьКассовуюСсылкуЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	КассоваяСсылка = Результат.КассоваяСсылка;
	ИдентификаторОплаты = Результат.ИдентификаторОплаты;
	
	ОтобразитьNFCСсылку();
	
КонецПроцедуры

&НаСервере
Процедура СформироватьQRКодНаСервере()
	
	НастройкаПодключения = НастройкаПодключения();
	
	НастройкиТорговойТочки = СистемаБыстрыхПлатежей.НастройкиПодключения(НастройкаПодключения);
	Если НЕ НастройкиТорговойТочки.НастройкиСБПc2b.КассовыеСсылки Тогда
		ТекстОшибки = НСтр("ru = 'Настройка подключения не поддерживает работу с кассовыми ссылками СБП.';
							|en = 'The connection settings do not support FPS QR code payment links.'");
		ОбщегоНазначения.СообщитьПользователю(ТекстОшибки);
		Возврат;
	КонецЕсли;
	
	РезультатСоздания = ПереводыСБПc2b.КассоваяСсылка(НастройкаПодключения);
	
	Если ЗначениеЗаполнено(РезультатСоздания.СообщениеОбОшибке) Тогда
		ОбщегоНазначения.СообщитьПользователю(РезультатСоздания.СообщениеОбОшибке);
		Возврат;
	КонецЕсли;
	
	КассоваяСсылка = РезультатСоздания.КассоваяСсылка;
	ИдентификаторОплаты = РезультатСоздания.ИдентификаторОплаты;
	
	ОтобразитьNFCСсылку();
	
КонецПроцедуры

&НаСервере
Процедура ОтобразитьNFCСсылку()
	
	Если ЗначениеЗаполнено(КассоваяСсылка) Тогда
		NFCСсылка = ПереводыСБПc2bКлиентСервер.ФункциональнаяСсылкаNFC(КассоваяСсылка);
	КонецЕсли;
	
КонецПроцедуры

// Возвращает настройки настройки подключения к платежной системе.
//
// Возвращаемое значение:
//  СправочникСсылка.НастройкиПодключенияКСистемеБыстрыхПлатежей - Настройка подключения к платежной системе
//
&НаСервере
Функция НастройкаПодключения()
	
	Возврат РозничныеПродажиЛокализация.НастройкаПодключения(ДоговорПодключения);
	
КонецФункции

&НаСервере
Процедура УстановитьДоступностьКоманд()
	
	Элементы.ФормаСформироватьQRКод.Доступность = Ложь;
	Элементы.ФормаПодключитьQRКод.Доступность = Ложь;
	Если ЗначениеЗаполнено(ДоговорПодключения)
		И НЕ ЗначениеЗаполнено(КассоваяСсылка) Тогда
		ОтборДляПоиска = Новый Структура("ДоговорПодключения,КассовыеСсылки",ДоговорПодключения,Истина);
		НайденныеНастройки = НастройкиПодключенияКПлатежнымСистемамДействующихДоговоров.НайтиСтроки(ОтборДляПоиска);
		Если НайденныеНастройки.Количество() Тогда
			Элементы.ФормаСформироватьQRКод.Доступность = НайденныеНастройки[0].КассовыеСсылки;
			Элементы.ФормаПодключитьQRКод.Доступность = Элементы.ФормаСформироватьQRКод.Доступность И НайденныеНастройки[0].ПодключениеКассовойСсылки;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти