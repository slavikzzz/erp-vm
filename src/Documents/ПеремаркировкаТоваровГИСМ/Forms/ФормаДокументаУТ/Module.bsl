//++ НЕ ГОСИС

#Область ОписаниеПеременных

&НаКлиенте
Перем КэшированныеЗначения; //используется механизмом обработки изменения реквизитов ТЧ

&НаКлиенте
Перем ТекущиеДанныеИдентификатор; //используется для передачи текущей строки в обработчик ожидания

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	Элементы.Подразделение.Видимость = ОбщегоНазначенияИС.ИспользоватьПодразделения();
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПриЧтенииСозданииНаСервере();
		Если РаботаСГИСМЗавершена Тогда
			ИнтеграцияГИСМ.СообщитьОбОтключенииПодсистемы(Отказ);
		КонецЕсли;
		ПараметрыУказанияСерий = Новый ФиксированнаяСтруктура(НоменклатураСервер.ПараметрыУказанияСерий(Объект, Документы.ПеремаркировкаТоваровГИСМ));
		НоменклатураСервер.ЗаполнитьСтатусыУказанияСерий(Объект, ПараметрыУказанияСерий);
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

	ПараметрыВыбораСтатейИАналитик = МаркировкаТоваровГИСМУТ.ПараметрыВыбораСтатейИАналитикПеремаркировкаТоваров();
	ДоходыИРасходыСервер.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыВыбораСтатейИАналитик);
	
	ОбщегоНазначенияУТ.НастроитьПодключаемоеОборудование(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// Обработчик механизма "ДатыЗапретаИзменения"
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	ПараметрыУказанияСерий = Новый ФиксированнаяСтруктура(НоменклатураСервер.ПараметрыУказанияСерий(Объект, Документы.ПеремаркировкаТоваровГИСМ));
	ПриЧтенииСозданииНаСервере();
	
	СобытияФорм.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	
	ПараметрыВыбораСтатейИАналитик = МаркировкаТоваровГИСМУТ.ПараметрыВыбораСтатейИАналитикПеремаркировкаТоваров();
	ДоходыИРасходыСервер.ПриЧтенииНаСервере(ЭтотОбъект, ПараметрыВыбораСтатейИАналитик);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ИсточникВыбора.ИмяФормы = "Обработка.ПодборТоваровВДокументПродажи.Форма.Форма" Тогда
		
		ОбработкаВыбораПодборНаСервере(ВыбранноеЗначение);
		
	ИначеЕсли ИсточникВыбора.ИмяФормы = "Справочник.ВидыЗапасов.Форма.ФормаВводаВидовЗапасов" Тогда
		
		ПолучитьВидыЗапасовИзХранилища(ВыбранноеЗначение);
	ИначеЕсли НоменклатураКлиент.ЭтоУказаниеСерий(ИсточникВыбора) Тогда
		
		ТекущиеДанные = Элементы[ПараметрыУказанияСерий.ИмяТЧТовары].ДанныеСтроки(ВыбранноеЗначение.ИдентификаторТекущейСтроки);
		
		НоменклатураКлиент.ОбработатьУказаниеСерии(ЭтаФорма, ПараметрыУказанияСерий, ВыбранноеЗначение);
		
		ТекущаяСтрока = Новый Структура;
		ТекущаяСтрока.Вставить("Серия", ТекущиеДанные.СписываемаяСерия);
		ТекущаяСтрока.Вставить("СтатусУказанияСерий", ТекущиеДанные.СтатусУказанияСерийСписываемаяСерия);
		ВыбранноеЗначение.Значение = ВыбранноеЗначение.ЗначениеСписываемойСерии;
		
		НоменклатураКлиент.ОбработатьУказаниеСерии(ЭтаФорма, ПараметрыУказанияСерий, ВыбранноеЗначение, ТекущаяСтрока);
		
		ТекущиеДанные.СписываемаяСерия                    = ТекущаяСтрока.Серия;
		ТекущиеДанные.СтатусУказанияСерийСписываемаяСерия = ТекущаяСтрока.СтатусУказанияСерий;
			
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	МаркировкаТоваровГИСМУТ.ЗаполнитьСлужебныеРеквизитыТабличнойЧасти(Объект.Товары);
	
	ОбновитьСтатусГИСМ();
	
	ДоходыИРасходыСервер.ПослеЗаписиНаСервере(ЭтотОбъект);
	
	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("#ГИСМ#Запись_ПеремаркировкаТоваровГИСМ");
	
	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);
	ОбщегоНазначенияУТКлиент.ВыполнитьДействияПослеЗаписи(ЭтаФорма, Объект, ПараметрыЗаписи);

	// СтандартныеПодсистемы.ПодключаемыеКоманды
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульПодключаемыеКомандыКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ПодключаемыеКомандыКлиент");
		МодульПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульПодключаемыеКомандыКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ПодключаемыеКомандыКлиент");
		МодульПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	МенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПриОткрытииФормы(Неопределено, ЭтаФорма, "СканерШтрихкода");
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	МенеджерОборудованияКлиент.НачатьОтключениеОборудованиеПриЗакрытииФормы(Неопределено, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	// ПодключаемоеОборудование
	Если Источник = "ПодключаемоеОборудование" И ВводДоступен() Тогда
		Если ИмяСобытия = "ScanData" И МенеджерОборудованияУТКлиент.ЕстьНеобработанноеСобытие() Тогда
			Данные = СобытияФормИСКлиент.ПреобразоватьДанныеСоСканераВМассив(Параметр);
			ОбработатьШтрихкоды(Данные);
		КонецЕсли;
	КонецЕсли;
	// Конец ПодключаемоеОборудование
	
	// Неизвестные штрихкоды
	Если Источник = "ПодключаемоеОборудование"
		И ИмяСобытия = "НеизвестныеШтрихкоды"
		И Параметр.ФормаВладелец = УникальныйИдентификатор Тогда
		
		КэшированныеЗначения.Штрихкоды.Очистить();
		ДанныеШтрихкодов = Новый Массив;
		Для Каждого ПолученныйШтрихкод Из Параметр.ПолученыНовыеШтрихкоды Цикл
			ДанныеШтрихкодов.Добавить(ПолученныйШтрихкод);
		КонецЦикла;
		Для Каждого ПолученныйШтрихкод Из Параметр.ЗарегистрированныеШтрихкоды Цикл
			ДанныеШтрихкодов.Добавить(ПолученныйШтрихкод);
		КонецЦикла;
		
		ОбработатьШтрихкоды(ДанныеШтрихкодов);
		
	КонецЕсли;
	
	Если ИмяСобытия = "#ГИСМ#ИзменениеСостоянияГИСМ"
		И Параметр.Ссылка = Объект.Ссылка Тогда
		
		ОбновитьСтатусГИСМ();
		
	КонецЕсли;
	
	Если ИмяСобытия = "#ГИСМ#ВыполненОбменГИСМ"
		И (Параметр = Неопределено
		Или (ТипЗнч(Параметр) = Тип("Структура") И Параметр.ОбновлятьСтатусВФормахДокументов)) Тогда
		
		ОбновитьСтатусГИСМ();
		
	КонецЕсли;
	
	СобытияФормКлиент.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);

КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	СобытияФормКлиент.ПередЗаписью(ЭтотОбъект, Отказ, ПараметрыЗаписи);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапки

&НаКлиенте
Процедура НаправлениеДеятельностиПриИзменении(Элемент)
	
	НаправлениеДеятельностиПриИзмененииСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура СтатьяРасходовПриИзменении(Элемент)
	
	СтатьяРасходовПриИзмененииСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура АналитикаРасходовАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	ДоходыИРасходыКлиент.АвтоПодборАналитикиРасходов(ЭтотОбъект, Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура АналитикаРасходовОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	ДоходыИРасходыКлиент.ОкончаниеВводаТекстаАналитикиРасходов(ЭтотОбъект, Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура СтатусГИСМОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если (Не ЗначениеЗаполнено(Объект.Ссылка)) Или (Не Объект.Проведен) Тогда
		
		ОписаниеОповещенияВопрос = Новый ОписаниеОповещения("СтатусГИСМОбработкаНавигационнойСсылкиЗавершение",
		                                                    ЭтотОбъект,
		                                                    Новый Структура("НавигационнаяСсылкаФорматированнойСтроки", НавигационнаяСсылкаФорматированнойСтроки));
		ТекстВопроса = НСтр("ru = 'Перемаркировка товаров ГИСМ не проведена. Провести?';
							|en = 'Перемаркировка товаров ГИСМ не проведена. Провести?'");
		ПоказатьВопрос(ОписаниеОповещенияВопрос, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		
	ИначеЕсли Модифицированность Тогда
		
		ОписаниеОповещенияВопрос = Новый ОписаниеОповещения("СтатусГИСМОбработкаНавигационнойСсылкиЗавершение",
		                                                    ЭтотОбъект,
		                                                    Новый Структура("НавигационнаяСсылкаФорматированнойСтроки", НавигационнаяСсылкаФорматированнойСтроки));
		ТекстВопроса = НСтр("ru = 'Перемаркировка товаров ГИСМ была изменена. Провести?';
							|en = 'Перемаркировка товаров ГИСМ была изменена. Провести?'");
		ПоказатьВопрос(ОписаниеОповещенияВопрос, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		
	Иначе
		
		ОбработатьНажатиеНавигационнойСсылки(НавигационнаяСсылкаФорматированнойСтроки);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СтатусГИСМОбработкаНавигационнойСсылкиЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если Не РезультатВопроса = КодВозвратаДиалога.Да Тогда
		 Возврат;
	КонецЕсли;
	
	Если ПроверитьЗаполнение() Тогда
		Записать();
	КонецЕсли;
	
	Если Не Модифицированность И ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ОбработатьНажатиеНавигационнойСсылки(ДополнительныеПараметры.НавигационнаяСсылкаФорматированнойСтроки);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьНажатиеНавигационнойСсылки(НавигационнаяСсылкаФорматированнойСтроки)
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "ПередатьДанные" Тогда
		
		ИнтеграцияГИСМКлиент.ПодготовитьСообщениеКПередаче(
			Объект.Ссылка,
			ПредопределенноеЗначение("Перечисление.ОперацииОбменаГИСМ.ПередачаДанныхСписаниеКиЗ"));
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "ПередатьДанныеСписаниеКиЗ" Тогда
		
		ИнтеграцияГИСМКлиент.ПодготовитьСообщениеКПередаче(
			Объект.Ссылка,
			ПредопределенноеЗначение("Перечисление.ОперацииОбменаГИСМ.ПередачаДанныхСписаниеКиЗ"));
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "ПередатьДанныеМаркировкаТоваров" Тогда
		
		ИнтеграцияГИСМКлиент.ПодготовитьСообщениеКПередаче(
			Объект.Ссылка,
			ПредопределенноеЗначение("Перечисление.ОперацииОбменаГИСМ.ПередачаДанныхМаркировкаТоваров"));
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "ПередатьДанныеПеремаркировкаТоваров" Тогда
		
		ИнтеграцияГИСМКлиент.ПодготовитьСообщениеКПередаче(
			Объект.Ссылка,
			ПредопределенноеЗначение("Перечисление.ОперацииОбменаГИСМ.ПередачаДанныхПеремаркировкаТоваров"));
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СкладПриИзменении(Элемент)
	СкладПриИзмененииСервер();
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	ОрганизацияПриИзмененииСервер();
КонецПроцедуры

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	ДатаПриИзмененииСервер();
КонецПроцедуры

&НаКлиенте
Процедура КиЗГИСМВидПриИзменении(Элемент)
	Если МаркировкаТоваровГИСМКлиент.ПроверитьЗаполнениеКатегорийКиЗ(Объект) Тогда
		КатегорияКиЗПриИзменении();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура КиЗГИСМРазмерПриИзменении(Элемент)
	Если МаркировкаТоваровГИСМКлиент.ПроверитьЗаполнениеКатегорийКиЗ(Объект) Тогда
		КатегорияКиЗПриИзменении();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура КиЗГИСМСпособВыпускаВОборотПриИзменении(Элемент)
	Если МаркировкаТоваровГИСМКлиент.ПроверитьЗаполнениеКатегорийКиЗ(Объект) Тогда
		КатегорияКиЗПриИзменении();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура КиЗГИСМСИндивидуализациейПриИзменении(Элемент)
	Если МаркировкаТоваровГИСМКлиент.ПроверитьЗаполнениеКатегорийКиЗ(Объект) Тогда
		КатегорияКиЗПриИзменении();
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТовары

&НаКлиенте
Процедура ТоварыНоменклатураПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	ИдентификаторСтроки = ТекущаяСтрока.ПолучитьИдентификатор();
	ТоварыНоменклатураПриИзмененииСервер(ИдентификаторСтроки);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыХарактеристикаПриИзменении(Элемент)
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	ИдентификаторСтроки = ТекущаяСтрока.ПолучитьИдентификатор();
	ТоварыХарактеристикаПриИзмененииСервер(ИдентификаторСтроки);
КонецПроцедуры

&НаКлиенте
Процедура ТоварыGTINПриИзменении(Элемент)
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	ИдентификаторСтроки = ТекущаяСтрока.ПолучитьИдентификатор();
	ТоварыGTINПриИзмененииСервер(ИдентификаторСтроки);
КонецПроцедуры

&НаКлиенте
Процедура ТоварыНоменклатураКиЗПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПроверитьХарактеристикуКиЗПоВладельцу", ТекущаяСтрока.ХарактеристикаКиЗ);
	СтруктураДействий.Вставить("ЗаполнитьПризнакХарактеристикиИспользуются", Новый Структура("НоменклатураКиЗ", "ХарактеристикиКиЗИспользуются"));
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыGTINНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	СписокВыбораGTIN = Новый Массив;
	МаркировкаТоваровГИСМВызовСервераПереопределяемый.МассивGTINМаркированногоТовара(
		ТекущаяСтрока.Номенклатура, ТекущаяСтрока.Характеристика, СписокВыбораGTIN);
	Элемент.СписокВыбора.ЗагрузитьЗначения(СписокВыбораGTIN);
КонецПроцедуры

&НаКлиенте
Процедура ТоварыНоменклатураКиЗНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	GTIN = ?(Объект.КиЗГИСМСИндивидуализацией, ТекущаяСтрока.GTIN, "");
	СписокВыбораКиЗ = Новый Массив;
	МаркировкаТоваровГИСМВызовСервераПереопределяемый.ОтобратьНоменклатуруПоНомеруGTIN(
		СписокНоменклатураКиЗ, GTIN, СписокВыбораКиЗ);
	Элемент.СписокВыбора.ЗагрузитьЗначения(СписокВыбораКиЗ);
КонецПроцедуры

&НаКлиенте
Процедура ТоварыСерияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ОткрытьПодборСерий("",,Истина);
КонецПроцедуры

&НаКлиенте
Процедура ТоварыСписываемаяСерияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ОткрытьПодборСерий(Элемент.ТекстРедактирования);
КонецПроцедуры

&НаКлиенте
Процедура ТоварыСписываемаяСерияПриИзменении(Элемент)
	ВыбранноеЗначение = НоменклатураКлиентСервер.ВыбраннаяСерия();
	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	
	ВыбранноеЗначение.Значение            		 = ТекущиеДанные.СписываемаяСерия;
	ВыбранноеЗначение.ИдентификаторТекущейСтроки = ТекущиеДанные.ПолучитьИдентификатор();
	
	ТекущаяСтрока = Новый Структура;
	ТекущаяСтрока.Вставить("Серия", ТекущиеДанные.СписываемаяСерия);
	ТекущаяСтрока.Вставить("СтатусУказанияСерий", ТекущиеДанные.СтатусУказанияСерийСписываемаяСерия);
	ТекущаяСтрока.Вставить("Количество", ТекущиеДанные.Количество);
	
	НоменклатураКлиент.ОбработатьУказаниеСерии(ЭтаФорма, ПараметрыУказанияСерий, ВыбранноеЗначение, ТекущаяСтрока);
	
	ТекущиеДанные.СписываемаяСерия = ТекущаяСтрока.Серия;
	ТекущиеДанные.СтатусУказанияСерийСписываемаяСерия = ТекущаяСтрока.СтатусУказанияСерий;
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыСерияПриИзменении(Элемент)
	ВыбранноеЗначение = НоменклатураКлиентСервер.ВыбраннаяСерия();
	
	ВыбранноеЗначение.Значение            		 = Элементы.Товары.ТекущиеДанные.Серия;
	ВыбранноеЗначение.ИдентификаторТекущейСтроки = Элементы.Товары.ТекущиеДанные.ПолучитьИдентификатор();
	
	НоменклатураКлиент.ОбработатьУказаниеСерии(ЭтаФорма, ПараметрыУказанияСерий, ВыбранноеЗначение);
КонецПроцедуры

&НаКлиенте
Процедура ТоварыПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Если ФлагРекурсии Тогда
		ФлагРекурсии = Ложь;
		Возврат;
	КонецЕсли;
	
	Отказ        = Истина;
	ФлагРекурсии = Истина;
	
	Элементы.Товары.ДобавитьСтроку();
	
	НоваяСтрока = Элементы.Товары.ТекущиеДанные;
	
	Если Не НоваяСтрока = Неопределено Тогда
		НоваяСтрока.Количество = 1;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПодобратьТовары(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Склад",                                     Объект.Склад);
	ПараметрыФормы.Вставить("РежимПодбораБезСуммовыхПараметров",         Истина);
	ПараметрыФормы.Вставить("СкрыватьКолонкуВидЦены",                    Истина);
	ПараметрыФормы.Вставить("СкрыватьКомандуЦеныНоменклатуры",           Истина);
	ПараметрыФормы.Вставить("ОтборПоТипуНоменклатуры",                   Новый ФиксированныйМассив(НоменклатураКлиентСервер.ОтборПоТоваруМногооборотнойТаре(Ложь)));
	ПараметрыФормы.Вставить("Заголовок",                                 НСтр("ru = 'Подбор товаров';
																				|en = 'Подбор товаров'"));
	ПараметрыФормы.Вставить("Дата",                                      Объект.Дата);
	ПараметрыФормы.Вставить("Документ",                                  Объект.Ссылка);
	ПараметрыФормы.Вставить("НаправлениеДеятельности",                   Объект.НаправлениеДеятельности);
	ПараметрыФормы.Вставить("ОсобенностьУчета",                          ПредопределенноеЗначение("Перечисление.ОсобенностиУчетаНоменклатуры.ПродукцияИзНатуральногоМеха"));
	ПараметрыФормы.Вставить("РежимПодбораБезКоличественныхПараметров",   Истина);
	
	ОткрытьФорму("Обработка.ПодборТоваровВДокументПродажи.Форма", ПараметрыФормы, ЭтаФорма, УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьВидыЗапасов(Команда)

	ПараметрыРедактированияВидовЗапасов = ПоместитьТоварыИВидыЗапасовВХранилище();
	
	ФинансыКлиент.ОткрытьВидыЗапасов(ЭтотОбъект, ПараметрыРедактированияВидовЗапасов);

КонецПроцедуры

&НаКлиенте
Процедура ПоискПоШтрихкодуВыполнить(Команда)
	
	ОчиститьСообщения();
	Оповещение = Новый ОписаниеОповещения("ПоискПоШтрихкодуЗавершение", ЭтотОбъект);
	ШтрихкодированиеНоменклатурыКлиент.ПоказатьВводШтрихкода(Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоискПоШтрихкодуЗавершение(ДанныхШтрихкода, ДополнительныеПараметры) Экспорт
	
	ОбработатьШтрихкоды(ДанныхШтрихкода);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьДанныеИзТСД(Команда)
	
	ОчиститьСообщения();
	
	МенеджерОборудованияИСКлиент.НачатьЗагрузкуДанныеИзТСД(
		Новый ОписаниеОповещения("ЗагрузитьИзТСДЗавершение", ЭтотОбъект),
		УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьИзТСДЗавершение(Результат, Параметры) Экспорт
	
	Если Результат.Результат Тогда
		ОбработатьШтрихкоды(Результат.ТаблицаТоваров);
	Иначе
		МенеджерОборудованияУТКлиент.СообщитьОбОшибке(Результат);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УказатьСерии(Команда)
	ОткрытьПодборСерий("");
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПричинуСписанияПоврежден(Команда)
	
	ЗаполнитьПричинуСписания(ПредопределенноеЗначение("Перечисление.ПричиныСписанияКиЗГИСМ.Поврежден"));
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПричинуСписанияУничтожен(Команда)
	
	ЗаполнитьПричинуСписания(ПредопределенноеЗначение("Перечисление.ПричиныСписанияКиЗГИСМ.Уничтожен"));
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПричинуСписанияУтерян(Команда)
	
	ЗаполнитьПричинуСписания(ПредопределенноеЗначение("Перечисление.ПричиныСписанияКиЗГИСМ.Утерян"));
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ЗаполнитьПричинуСписания(ПричинаСписания)

	Для Каждого ВыделеннаяСтрока Из Элементы.Товары.ВыделенныеСтроки Цикл
		ДанныеСтроки = Элементы.Товары.ДанныеСтроки(ВыделеннаяСтрока);
		ДанныеСтроки.ПричинаСписания = ПричинаСписания;
	КонецЦикла

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()
	
	РаботаСГИСМЗавершена = ИнтеграцияГИСМ.ПодсистемаНеИспользуется();
	ТолькоПросмотр = РаботаСГИСМЗавершена;
	
	ОбновитьСтатусГИСМ();
	
	МаркировкаТоваровГИСМУТ.ЗаполнитьСлужебныеРеквизитыТабличнойЧасти(Объект.Товары);
	МаркировкаТоваровГИСМУТ.УправлениеДоступностью(ЭтаФорма);
	
	МаркировкаТоваровГИСМПереопределяемый.ЗаполнитьСпискиВыбораРеквизитовШапкиПеремаркировкаТоваров(ЭтаФорма);
	МаркировкаТоваровГИСМПереопределяемый.ПолучитьКиЗДляЗаполнения(Объект,СписокНоменклатураКиЗ);
	
	АктуализироватьМаркировкаПодДеятельность(Ложь);
	
КонецПроцедуры

#Область Серии

&НаСервере
Процедура ЗаполнитьСтатусыУказанияСерийСервер()
	
	НоменклатураСервер.ЗаполнитьСтатусыУказанияСерий(Объект,ПараметрыУказанияСерий);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПодборСерий(Текст = "",ТекущиеДанные = Неопределено,ЭтоВводНовойСерии = Ложь)
	
	Если ТекущиеДанные = Неопределено Тогда
		ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
		Если ТекущиеДанные = Неопределено Тогда
			Возврат
		КонецЕсли;
	КонецЕсли;
		
	ТекущаяСтрока = Новый Структура;
	ТекущаяСтрока.Вставить("Номенклатура", ТекущиеДанные.Номенклатура);
	ТекущаяСтрока.Вставить("Характеристика", ТекущиеДанные.Характеристика);
	ТекущаяСтрока.Вставить("НоменклатураКиЗ", ТекущиеДанные.НоменклатураКиЗ);
	ТекущаяСтрока.Вставить("ХарактеристикаКиЗ", ТекущиеДанные.ХарактеристикаКиЗ);
	ТекущаяСтрока.Вставить("ХарактеристикиИспользуются", ТекущиеДанные.ХарактеристикиИспользуются);
	ТекущаяСтрока.Вставить("ХарактеристикиКиЗИспользуются", ТекущиеДанные.ХарактеристикиКиЗИспользуются);
	ТекущаяСтрока.Вставить("GTIN", ТекущиеДанные.GTIN);
	ТекущаяСтрока.Вставить("Серия", ТекущиеДанные.Серия);
	ТекущаяСтрока.Вставить("СписываемаяСерия", ТекущиеДанные.СписываемаяСерия);
	ТекущаяСтрока.Вставить("СтатусУказанияСерий", ТекущиеДанные.СтатусУказанияСерий);
	ТекущаяСтрока.Вставить("ИдентификаторТекущейСтроки", ТекущиеДанные.ПолучитьИдентификатор());
	ТекущаяСтрока.Вставить("Количество", ТекущиеДанные.Количество);
	Если ЭтоВводНовойСерии Тогда
		ТекущаяСтрока.Вставить("РежимПомощника", "НоваяСерия");
	Иначе
		ТекущаяСтрока.Вставить("РежимПомощника", "СтараяСерия");
	КонецЕсли;	
		
	Если НоменклатураКлиент.ДляУказанияСерийНуженСерверныйВызов(ЭтаФорма,ПараметрыУказанияСерий,Текст,ТекущаяСтрока)Тогда
		ТекстИсключения = НСтр("ru = 'Ошибка при попытке указать серии - в этом документе для указания серий не нужен серверный вызов.';
								|en = 'Ошибка при попытке указать серии - в этом документе для указания серий не нужен серверный вызов.'");
		ВызватьИсключение ТекстИсключения;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПодборСерийПриСканированииШтрихкодаНоменклатуры()
	
	Если ТекущиеДанныеИдентификатор = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Объект.Товары.НайтиПоИдентификатору(ТекущиеДанныеИдентификатор);
	ОткрытьПодборСерий(,ТекущиеДанные);
	
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
//@skip-warning
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

//@skip-warning
&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

//@skip-warning
&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#Область ПриИзмененииРеквизитов

&НаСервере
Процедура ОрганизацияПриИзмененииСервер()
	
	АктуализироватьМаркировкаПодДеятельность();
	
КонецПроцедуры

&НаСервере
Процедура СкладПриИзмененииСервер()
	АктуализироватьМаркировкаПодДеятельность();
	ПараметрыУказанияСерий = Новый ФиксированнаяСтруктура(НоменклатураСервер.ПараметрыУказанияСерий(Объект, Документы.ПеремаркировкаТоваровГИСМ));
	НоменклатураСервер.ЗаполнитьСтатусыУказанияСерий(Объект, ПараметрыУказанияСерий);
КонецПроцедуры

&НаСервере
Процедура ТоварыНоменклатураПриИзмененииСервер(ИдентификаторСтроки)
	
	ТекущаяСтрока = Объект.Товары.НайтиПоИдентификатору(ИдентификаторСтроки);
	
	ТекущаяСтрокаСписываемаяСерия = Новый Структура;
	ТекущаяСтрокаСписываемаяСерия.Вставить("Номенклатура", ТекущаяСтрока.Номенклатура);
	ТекущаяСтрокаСписываемаяСерия.Вставить("Характеристика", ТекущаяСтрока.Характеристика);
	ТекущаяСтрокаСписываемаяСерия.Вставить("Серия", ТекущаяСтрока.СписываемаяСерия);
	ТекущаяСтрокаСписываемаяСерия.Вставить("СтатусУказанияСерий", ТекущаяСтрока.СтатусУказанияСерийСписываемаяСерия);
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПроверитьХарактеристикуПоВладельцу", ТекущаяСтрока.Характеристика);
	СтруктураДействий.Вставить("ЗаполнитьGTINВСтроке");
	СтруктураДействий.Вставить("ПроверитьСериюРассчитатьСтатус", Новый Структура("Склад, ПараметрыУказанияСерий", Объект.Склад, ПараметрыУказанияСерий));
	ОбработкаТабличнойЧастиСервер.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, Неопределено);
	МаркировкаТоваровГИСМПереопределяемый.ЗаполнитьНоменклатуруКиЗВСтроке(ТекущаяСтрока, СписокНоменклатураКиЗ, Объект.КиЗГИСМСИндивидуализацией);
	
КонецПроцедуры

&НаСервере
Процедура ТоварыХарактеристикаПриИзмененииСервер(ИдентификаторСтроки)
	
	ТекущаяСтрока = Объект.Товары.НайтиПоИдентификатору(ИдентификаторСтроки);
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ЗаполнитьGTINВСтроке");
	ОбработкаТабличнойЧастиСервер.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, Неопределено);
	МаркировкаТоваровГИСМПереопределяемый.ЗаполнитьНоменклатуруКиЗВСтроке(ТекущаяСтрока, СписокНоменклатураКиЗ, Объект.КиЗГИСМСИндивидуализацией);
	
КонецПроцедуры

&НаСервере
Процедура ТоварыGTINПриИзмененииСервер(ИдентификаторСтроки)
	
	ТекущаяСтрока = Объект.Товары.НайтиПоИдентификатору(ИдентификаторСтроки);
	МаркировкаТоваровГИСМПереопределяемый.ЗаполнитьНоменклатуруКиЗВСтроке(ТекущаяСтрока, СписокНоменклатураКиЗ, Объект.КиЗГИСМСИндивидуализацией);
	
КонецПроцедуры

&НаСервере
Процедура НаправлениеДеятельностиПриИзмененииСервер()
	Объект.НазначениеКиЗ = НаправленияДеятельностиСервер.ТолкающееНазначение(Объект.НаправлениеДеятельности);
КонецПроцедуры

&НаСервере
Процедура КатегорияКиЗПриИзменении()
	МаркировкаТоваровГИСМПереопределяемый.КатегорияКиЗПриИзменении(Объект, СписокНоменклатураКиЗ, Ложь);
КонецПроцедуры

&НаСервере
Процедура СтатьяРасходовПриИзмененииСервер()
	
	ДоходыИРасходыКлиентСервер.СтатьяПриИзменении(ЭтотОбъект, Элементы.СтатьяРасходов);
	
	МаркировкаТоваровГИСМУТ.УправлениеДоступностью(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ДатаПриИзмененииСервер()
	
	АктуализироватьМаркировкаПодДеятельность();
	
КонецПроцедуры

&НаСервере
Процедура АктуализироватьМаркировкаПодДеятельность(Заполнить = Истина)
	
	ПараметрыЗаполнения = МаркировкаТоваровГИСМУТ.ПараметрыЗаполненияВидаДеятельностиНДС(Объект);
	
	Если Заполнить Тогда
		УчетНДСУП.ЗаполнитьВидДеятельностиНДС(
			Объект.МаркировкаДляДеятельности,
			ПараметрыЗаполнения,
			УчетНДСКэшированныеЗначенияПараметров);
	КонецЕсли;
	
	УчетНДСУП.ЗаполнитьСписокВыбораВидаДеятельностиНДС(
		Элементы.МаркировкаДляДеятельности,
		Объект.МаркировкаДляДеятельности,
		ПараметрыЗаполнения,
		УчетНДСКэшированныеЗначенияПараметров);
	
КонецПроцедуры

#КонецОбласти

&НаСервере
Функция ПоместитьТоварыИВидыЗапасовВХранилище()
	
	ПараметрыРедактированияВидовЗапасов = ЗапасыСервер.ПараметрыРедактированияВидовЗапасов();
	ПараметрыРедактированияВидовЗапасов.ИмяКолонкиНоменклатура   = "НоменклатураКиЗ";
	ПараметрыРедактированияВидовЗапасов.ИмяКолонкиХарактеристика = "ХарактеристикаКиЗ";
	
	Возврат ЗапасыСервер.ПоместитьТоварыИВидыЗапасовВХранилище(ЭтотОбъект, ПараметрыРедактированияВидовЗапасов);
	
КонецФункции

&НаСервере
Процедура ПолучитьВидыЗапасовИзХранилища(ВыбранноеЗначение)
	
	ЗапасыСервер.ОбработатьВводВидовЗапасовВручную(ВыбранноеЗначение, ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаВыбораПодборНаСервере(ВыбранноеЗначение)
	
	ТаблицаТоваров = ПолучитьИзВременногоХранилища(ВыбранноеЗначение.АдресТоваровВХранилище);
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ЗаполнитьGTINВСтроке");
	СтруктураДействий.Вставить("ПроверитьСериюРассчитатьСтатус", Новый Структура("Склад, ПараметрыУказанияСерий", Объект.Склад, ПараметрыУказанияСерий));
	КэшированныеЗначения = ОбработкаТабличнойЧастиКлиентСервер.ПолучитьСтруктуруКэшируемыеЗначения();
	
	Для каждого СтрокаТовара Из ТаблицаТоваров Цикл
		
		ТекущаяСтрока = Объект.Товары.Добавить();
		ЗаполнитьЗначенияСвойств(ТекущаяСтрока, СтрокаТовара, "Номенклатура, Характеристика, ХарактеристикиИспользуются, Количество");
		ТекущаяСтрока.Количество = 1;
		ОбработкаТабличнойЧастиСервер.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
		
	КонецЦикла;
	ЗаполнитьСтатусыУказанияСерийСервер();
	МаркировкаТоваровГИСМПереопределяемый.ЗаполнитьНоменклатуруКиЗВСтроках(Объект, СписокНоменклатураКиЗ, Ложь);
КонецПроцедуры

#Область ШтрихкодыИТорговоеОборудование

&НаКлиенте
Процедура ОбработатьШтрихкоды(ДанныеШтрихкодов)
	
	СтруктураДействийСДобавленнымиСтроками = Новый Структура;
	СтруктураДействийСДобавленнымиСтроками.Вставить("ЗаполнитьGTINВСтроке");
	СтруктураДействийСИзмененнымиСтроками = Новый Структура;
	СтруктураДействий = ШтрихкодированиеНоменклатурыКлиент.ПараметрыОбработкиШтрихкодов();
	
	СтруктураДействий.Штрихкоды                              = ДанныеШтрихкодов;
	СтруктураДействий.СтруктураДействийСДобавленнымиСтроками = СтруктураДействийСДобавленнымиСтроками;
	СтруктураДействий.СтруктураДействийСИзмененнымиСтроками  = СтруктураДействийСИзмененнымиСтроками;
	СтруктураДействий.ПараметрыУказанияСерий                 = ПараметрыУказанияСерий;
	СтруктураДействий.ИзменятьКоличество                     = Ложь;
	СтруктураДействий.ТолькоТовары                           = Истина;
	СтруктураДействий.НеИспользоватьУпаковки                 = Истина;
	СтруктураДействий.ИмяКолонкиКоличество                   = "Количество";
	
	ОбработатьШтрихкодыСервер(СтруктураДействий,КэшированныеЗначения);
	ШтрихкодированиеНоменклатурыКлиент.ОбработатьНеизвестныеШтрихкоды(СтруктураДействий,КэшированныеЗначения,ЭтаФорма);
	
	Если ШтрихкодированиеНоменклатурыКлиент.НужноОткрытьФормуУказанияСерийПослеОбработкиШтрихкодов(СтруктураДействий) Тогда
		
		ТекущиеДанныеИдентификатор = СтруктураДействий.МассивСтрокССериями[0];
		
		ПодключитьОбработчикОжидания("ОткрытьПодборСерийПриСканированииШтрихкодаНоменклатуры",0.1,Истина);
			
	КонецЕсли;
	
	Если СтруктураДействий.ТекущаяСтрока <> Неопределено Тогда
		Элементы.Товары.ТекущаяСтрока = СтруктураДействий.ТекущаяСтрока;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьШтрихкодыСервер(СтруктураПараметровДействия,КэшированныеЗначения)
	ШтрихкодированиеНоменклатурыСервер.ОбработатьШтрихкоды(ЭтаФорма, Объект,СтруктураПараметровДействия,КэшированныеЗначения);
	МаркировкаТоваровГИСМПереопределяемый.ЗаполнитьНоменклатуруКиЗВСтроках(Объект, СписокНоменклатураКиЗ, Ложь);
КонецПроцедуры

#КонецОбласти

&НаСервере
Процедура ОбновитьСтатусГИСМ()
	
	МаркировкаТоваровГИСМ.ОбновитьСтатусГИСМ(ЭтаФорма, "ПеремаркировкаТоваровГИСМ");
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	//
	НоменклатураСервер.УстановитьУсловноеОформлениеХарактеристикНоменклатуры(ЭтаФорма);
	НоменклатураСервер.УстановитьУсловноеОформлениеХарактеристикНоменклатуры(ЭтаФорма, "ТоварыХарактеристикаКиЗ", "Объект.Товары.ХарактеристикиКизИспользуются");
	
КонецПроцедуры

&НаКлиенте
Процедура СтатьяРасходовНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ДоходыИРасходыКлиент.НачалоВыбораСтатьи(ЭтотОбъект, Элемент, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура АналитикаРасходовНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ДоходыИРасходыКлиент.НачалоВыбораАналитикиРасходов(ЭтотОбъект, Элемент, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

//-- НЕ ГОСИС
