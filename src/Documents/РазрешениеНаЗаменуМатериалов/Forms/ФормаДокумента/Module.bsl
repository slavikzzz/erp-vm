

#Область ОписаниеПеременных

&НаКлиенте
Перем КэшированныеЗначения; //используется механизмом обработки изменения реквизитов ТЧ

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);

	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		ПриЧтенииСозданииНаСервере();
		
	КонецЕсли;
	
	УправлениеВидимостью(ЭтаФорма);
	
	УстановитьДоступностьКомандБуфераОбмена(ЭтаФорма, РаботаСТабличнымиЧастями.ЕстьСтрокиВБуфереОбмена());
	
	// СтандартныеПодсистемы.Свойства
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтаФорма, ДополнительныеПараметры);
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ИнтеграцияС1СДокументооборотом

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПриЧтенииСозданииНаСервере();
	
	// Обработчик механизма "ДатыЗапретаИзменения"
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	МодификацияКонфигурацииПереопределяемый.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ИсточникВыбора.ИмяФормы = "Справочник.РесурсныеСпецификации.Форма.ПодборМатериаловПоСпецификации" Тогда
		
		Если Не ЭтоАдресВременногоХранилища(ВыбранноеЗначение) Тогда
			Возврат;
		КонецЕсли;
		
		ОбработатьПодборМатериаловПоСпецификации(ВыбранноеЗначение);
		
	ИначеЕсли ИсточникВыбора.ИмяФормы = "Документ.РазрешениеНаЗаменуМатериалов.Форма.ФормаВводаОбластиДействия" Тогда
		
		Модифицированность = Истина;
		
		ЗначениеВыбора = ВыбранноеЗначение.ЗначениеВыбора;
		
		Если Объект.Спецификация <> ЗначениеВыбора.Спецификация Или Объект.Этап <> ЗначениеВыбора.Этап Тогда
			Объект.Материалы.Очистить();
		КонецЕсли;
		
		СписокСвойств = "НаправлениеДеятельности,"
						+ "ЗаказНаПроизводство,"
						+ "ЗаказКлиента,"
						+ "Подразделение,"
						+ "Спецификация,"
						+ "Этап,"
						+ "Изделие,"
						+ "ХарактеристикаИзделия";
		
		ЗаполнитьЗначенияСвойств(Объект, ЗначениеВыбора, СписокСвойств);
		
		ОбновитьПредставлениеОбластиДействия();
		
		УправлениеВидимостью(ЭтаФорма);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "КопированиеСтрокВБуферОбмена" Тогда
		УстановитьДоступностьКомандБуфераОбмена(ЭтаФорма, Истина);
	КонецЕсли;
	
	// СтандартныеПодсистемы.Свойства 
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтаФорма, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ЗаполнитьСлужебныеРеквизиты();

	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)

	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);

	// СтандартныеПодсистемы.ПодключаемыеКоманды
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульПодключаемыеКомандыКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ПодключаемыеКомандыКлиент");
		МодульПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);
	// Конец ИнтеграцияС1СДокументооборотом
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПредставлениеОбластиДействияНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыФормы = Новый Структура;
	
	ПараметрыФормы.Вставить("НаправлениеДеятельности", Объект.НаправлениеДеятельности);
	ПараметрыФормы.Вставить("ЗаказНаПроизводство", Объект.ЗаказНаПроизводство);
	ПараметрыФормы.Вставить("ЗаказКлиента", Объект.ЗаказКлиента);
	ПараметрыФормы.Вставить("Подразделение", Объект.Подразделение);
	ПараметрыФормы.Вставить("Спецификация", Объект.Спецификация);
	ПараметрыФормы.Вставить("Этап", Объект.Этап);
	ПараметрыФормы.Вставить("Изделие", Объект.Изделие);
	ПараметрыФормы.Вставить("ХарактеристикаИзделия", Объект.ХарактеристикаИзделия);
	ПараметрыФормы.Вставить("КоличествоМатериалов", Объект.Материалы.Количество());
	ПараметрыФормы.Вставить("ТолькоПросмотр", ТолькоПросмотр);
	
	ОткрытьФорму("Документ.РазрешениеНаЗаменуМатериалов.Форма.ФормаВводаОбластиДействия", ПараметрыФормы, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОснованиеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(
		Элемент.ТекстРедактирования,
		ЭтотОбъект,
		"Объект.УказаниеПоПрименению",
		НСтр("ru = 'Указание по применению';
			|en = 'Usage note'"));
	
КонецПроцедуры

&НаКлиенте
Процедура СтатусПриИзменении(Элемент)
	
	Если Объект.Статус 
			= ПредопределенноеЗначение("Перечисление.СтатусыРазрешенийНаЗаменуМатериалов.Утверждено")
		И Не ЗначениеЗаполнено(Объект.ДатаНачалаДействия) Тогда
		
		Объект.ДатаНачалаДействия = ОбщегоНазначенияКлиент.ДатаСеанса();
		
	ИначеЕсли Объект.Статус 
			= ПредопределенноеЗначение("Перечисление.СтатусыРазрешенийНаЗаменуМатериалов.Прекращено") Тогда
			
		Объект.ДатаОкончанияДействия = ОбщегоНазначенияКлиент.ДатаСеанса();
		
	КонецЕсли;
	
	НастроитьЗависимыеЭлементыФормы(ЭтотОбъект, "Статус");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыМатериалы

&НаКлиенте
Процедура МатериалыПередОкончаниемРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования, Отказ)
	
	Если ОтменаРедактирования Тогда
		Возврат;
	КонецЕсли;
	
	Если НоваяСтрока Тогда
		ЗаполнитьИдентификаторСтроки(Элементы.Материалы.ТекущиеДанные);
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура МатериалыНоменклатураПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Материалы.ТекущиеДанные;
	
	СтруктураДействий = Новый Структура;
	
	ДобавитьВСтруктуруДействияПриИзмененииНоменклатуры(СтруктураДействий, ТекущаяСтрока, "Материалы");
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	
КонецПроцедуры

&НаКлиенте
Процедура Материалы_ПодобратьПоСпецификации(Команда)
	
	ОткрытьФорму(
		"Справочник.РесурсныеСпецификации.Форма.ПодборМатериаловПоСпецификации",
		ПараметрыПодбораПоСпецификации(),
		ЭтотОбъект, 
		УникальныйИдентификатор,,,, 
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура Материалы_ВставитьСтроки(Команда)
	
	ПолучитьСтрокиИзБуфераОбмена("Материалы");
	
КонецПроцедуры

&НаКлиенте
Процедура Материалы_СкопироватьСтроки(Команда)
	
	СкопироватьСтрокиТЧ("Материалы");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыАналоги

&НаКлиенте
Процедура АналогиНоменклатураПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Аналоги.ТекущиеДанные;
	
	СтруктураДействий = Новый Структура;
	
	ДобавитьВСтруктуруДействияПриИзмененииНоменклатуры(СтруктураДействий, ТекущаяСтрока, "Аналоги");
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	
КонецПроцедуры

&НаКлиенте
Процедура Аналоги_ВставитьСтроки(Команда)
	
	ПолучитьСтрокиИзБуфераОбмена("Аналоги");
	
КонецПроцедуры

&НаКлиенте
Процедура Аналоги_СкопироватьСтроки(Команда)
	
	СкопироватьСтрокиТЧ("Аналоги");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовСтраницыДополнительно

&НаКлиенте
Процедура КомментарийПриИзменении(Элемент)
	
	НастроитьЗависимыеЭлементыФормы(ЭтаФорма, "Комментарий");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура ЗаписатьДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Записать(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Провести(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиИЗакрыть(Команда)
	
	ОбщегоНазначенияУТКлиент.ПровестиИЗакрыть(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьИнтервалВыполнить(Команда)
	
	ОбщегоНазначенияУТКлиент.РедактироватьПериод(Объект, 
		Новый Структура("ДатаНачала, ДатаОкончания", "ДатаНачалаДействия", "ДатаОкончанияДействия"));
	
КонецПроцедуры

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры
// Конец ИнтеграцияС1СДокументооборотом

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

// СтандартныеПодсистемы.Свойства
&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	#Область СтандартноеОформление
	НоменклатураСервер.УстановитьУсловноеОформлениеХарактеристикНоменклатуры(ЭтаФорма, 
																			 "МатериалыХарактеристика",
																		     "Объект.Материалы.ХарактеристикиИспользуются");

	НоменклатураСервер.УстановитьУсловноеОформлениеХарактеристикНоменклатуры(ЭтаФорма, 
																			 "АналогиХарактеристика",
																		     "Объект.Аналоги.ХарактеристикиИспользуются");

	НоменклатураСервер.УстановитьУсловноеОформлениеЕдиницИзмерения(ЭтаФорма,
																   "МатериалыНоменклатураЕдиницаИзмерения",
																   "Объект.Материалы.Упаковка");
																   
	НоменклатураСервер.УстановитьУсловноеОформлениеЕдиницИзмерения(ЭтаФорма,
																   "АналогиНоменклатураЕдиницаИзмерения",
																   "Объект.Аналоги.Упаковка");
	#КонецОбласти
	
	//
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДатаОкончанияДействия.Имя);
	
	ОтборГруппаИли = Элемент.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ОтборГруппаИли.Использование = Истина;
	ОтборГруппаИли.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;
	                                                                                
	ОтборЭлемента = ОтборГруппаИли.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.Статус");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеРавно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.СтатусыРазрешенийНаЗаменуМатериалов.Прекращено;
	
	ОтборЭлемента = ОтборГруппаИли.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.ДатаОкончанияДействия");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()
	
	ЗаполнитьСлужебныеРеквизиты();
	
	НастроитьЭлементыФормы();
	
КонецПроцедуры

&НаСервере
Процедура НастроитьЭлементыФормы()
	
	ОбновитьПредставлениеОбластиДействия();
	
	НастроитьЗависимыеЭлементыФормы(ЭтаФорма);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура НастроитьЗависимыеЭлементыФормы(Форма, СписокРеквизитов = "")
	
	Объект = Форма.Объект;
	Элементы = Форма.Элементы;
	
	Инициализация = ПустаяСтрока(СписокРеквизитов);
	СтруктураРеквизитов = Новый Структура(СписокРеквизитов);
	
	Если СтруктураРеквизитов.Свойство("Комментарий")
		ИЛИ Инициализация Тогда
		
		Элементы.СтраницаКомментарий.Картинка = ОбщегоНазначенияКлиентСервер.КартинкаКомментария(Объект.Комментарий);
		
	КонецЕсли;
	
	Если СтруктураРеквизитов.Свойство("Статус")
		ИЛИ Инициализация Тогда
		
		Элементы.ДатаОкончанияДействия.АвтоОтметкаНезаполненного = 
			(Объект.Статус = ПредопределенноеЗначение("Перечисление.СтатусыРазрешенийНаЗаменуМатериалов.Прекращено"));
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСлужебныеРеквизиты()
	
	ЗаполнитьПризнакХарактеристикиИспользуются = Новый Структура("Номенклатура", "ХарактеристикиИспользуются");
	ЗаполнитьПризнакТипНоменклатуры = Новый Структура("Номенклатура", "ТипНоменклатуры");
	
	СтруктураДействий = Новый Структура("ЗаполнитьПризнакХарактеристикиИспользуются, ЗаполнитьПризнакТипНоменклатуры",
		ЗаполнитьПризнакХарактеристикиИспользуются,
		ЗаполнитьПризнакТипНоменклатуры);
		
	НоменклатураСервер.ЗаполнитьСлужебныеРеквизитыПоНоменклатуреВКоллекции(
		Объект.Материалы, СтруктураДействий);
		
	НоменклатураСервер.ЗаполнитьСлужебныеРеквизитыПоНоменклатуреВКоллекции(
		Объект.Аналоги, СтруктураДействий);
		
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ДобавитьВСтруктуруДействияПриИзмененииНоменклатуры(СтруктураДействий, ТекущаяСтрока, ИмяТЧ)

	СтруктураДействий.Вставить("ЗаполнитьПризнакТипНоменклатуры", Новый Структура("Номенклатура", "ТипНоменклатуры"));
	СтруктураДействий.Вставить("ПроверитьХарактеристикуПоВладельцу", ТекущаяСтрока.Характеристика);
	СтруктураДействий.Вставить("ПроверитьЗаполнитьУпаковкуПоВладельцу", ТекущаяСтрока.Упаковка);
	СтруктураДействий.Вставить("НоменклатураПриИзмененииПереопределяемый", Новый Структура("ИмяФормы, ИмяТабличнойЧасти", "ФормаДокумента", ИмяТЧ));
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьПредставлениеОбластиДействия()
	
	ПредставлениеОбластиДействия = "";
	
	Если ЗначениеЗаполнено(Объект.ЗаказНаПроизводство) Тогда
		
		РеквизитыОбъекта = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект.ЗаказНаПроизводство, "Номер, Дата");
		
		Шаблон = НСтр("ru = 'Заказ на производство: №%1 от %2;';
						|en = 'Production order: No.%1 from %2;'") + " ";
		
		ПредставлениеОбластиДействия = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Шаблон,
			ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(РеквизитыОбъекта.Номер),
			Формат(РеквизитыОбъекта.Дата, "ДЛФ=D"));
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.ЗаказКлиента) Тогда
		
		РеквизитыОбъекта = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект.ЗаказКлиента, "Номер, Дата");
		
		Шаблон = НСтр("ru = 'Заказ клиента: №%1 от %2;';
						|en = 'Sales order: No.%1 from %2;'") + " ";
		
		ПредставлениеОбластиДействия = ПредставлениеОбластиДействия + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Шаблон,
			ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(РеквизитыОбъекта.Номер),
			Формат(РеквизитыОбъекта.Дата, "ДЛФ=D"));
			
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.Спецификация) Тогда
		
		Шаблон = НСтр("ru = 'Спецификация: %1;';
						|en = 'Bill of materials: %1;'") + " ";
		
		ПредставлениеОбластиДействия = ПредставлениеОбластиДействия + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Шаблон,
			Объект.Спецификация);
		
	КонецЕсли;
		
	Если ЗначениеЗаполнено(Объект.Этап) Тогда
		
		Шаблон = НСтр("ru = 'Этап: %1;';
						|en = 'Stage: %1;'") + " ";
		
		ПредставлениеОбластиДействия = ПредставлениеОбластиДействия + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Шаблон,
			Объект.Этап);
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.Изделие) Тогда
		
		Шаблон = НСтр("ru = 'Изделие: %1;';
						|en = 'Material: %1;'") + " ";
		
		ПредставлениеОбластиДействия = ПредставлениеОбластиДействия + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Шаблон,
			Объект.Изделие);
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.ХарактеристикаИзделия) Тогда
		
		Шаблон = НСтр("ru = 'Характеристика: %1;';
						|en = 'Variant: %1;'") + " ";
		
		ПредставлениеОбластиДействия = ПредставлениеОбластиДействия + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Шаблон,
			Объект.ХарактеристикаИзделия);
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.Подразделение) Тогда
		
		Шаблон = НСтр("ru = 'Подразделение: %1;';
						|en = 'Business unit: %1;'") + " ";
		
		ПредставлениеОбластиДействия = ПредставлениеОбластиДействия + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Шаблон,
			Объект.Подразделение);
		
	КонецЕсли;
		
	Если ЗначениеЗаполнено(Объект.НаправлениеДеятельности) Тогда
		
		Шаблон = НСтр("ru = 'Направление деятельности: %1;';
						|en = 'Line of business: %1'") + " ";
		
		ПредставлениеОбластиДействия = ПредставлениеОбластиДействия + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Шаблон,
			Объект.НаправлениеДеятельности);
		
	КонецЕсли;
	
	Если СтрДлина(ПредставлениеОбластиДействия) > 0 Тогда
		ПредставлениеОбластиДействия = Лев(ПредставлениеОбластиДействия, СтрДлина(ПредставлениеОбластиДействия) - 2);
	Иначе
		ПредставлениеОбластиДействия = НСтр("ru = 'По предприятию в целом';
											|en = 'By the entire enterprise'");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеВидимостью(Форма)
	
	ВидимостьКомандРаботыСБуфером = НЕ ЗначениеЗаполнено(Форма.Объект.Спецификация);
	
	Форма.Элементы.Материалы_ВставитьСтроки.Видимость = ВидимостьКомандРаботыСБуфером;
	Форма.Элементы.КонтекстноеМенюМатериалы_ВставитьСтроки.Видимость = ВидимостьКомандРаботыСБуфером;
	Форма.Элементы.Материалы_ПодобратьПоСпецификации.Видимость = Не ВидимостьКомандРаботыСБуфером;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ЗаполнитьИдентификаторСтроки(СтрокаТаблицы)
	
	Если СтрокаТаблицы.Свойство("ИдентификаторСтроки") Тогда
		СтрокаТаблицы.ИдентификаторСтроки = Новый УникальныйИдентификатор;
	КонецЕсли;	
	
КонецПроцедуры	

#Область РаботаСБуферомОбмена

&НаКлиенте
Процедура СкопироватьСтрокиТЧ(ИмяТЧ)

	Если РаботаСТабличнымиЧастямиКлиент.ВыбранаСтрокаДляВыполненияКоманды(Элементы[ИмяТЧ]) Тогда
		СкопироватьСтрокиНаСервере(ИмяТЧ);
		РаботаСТабличнымиЧастямиКлиент.ОповеститьПользователяОКопированииСтрок(Элементы[ИмяТЧ].ВыделенныеСтроки.Количество());
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура СкопироватьСтрокиНаСервере(ИмяТЧ)
	
	РаботаСТабличнымиЧастями.СкопироватьСтрокиВБуферОбмена(Объект[ИмяТЧ], Элементы[ИмяТЧ].ВыделенныеСтроки);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьСтрокиИзБуфераОбмена(ИмяТЧ)
	
	КоличествоСтрокДоВставки = Объект[ИмяТЧ].Количество();
	
	ПолучитьСтрокиИзБуфераОбменаНаСервере(ИмяТЧ);
	
	КоличествоВставленных = Объект[ИмяТЧ].Количество() - КоличествоСтрокДоВставки;
	РаботаСТабличнымиЧастямиКлиент.ОповеститьПользователяОВставкеСтрок(КоличествоВставленных);
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьСтрокиИзБуфераОбменаНаСервере(ИмяТЧ)
	
	МассивТиповНоменклатуры = Новый Массив;
	МассивТиповНоменклатуры.Добавить(ПредопределенноеЗначение("Перечисление.ТипыНоменклатуры.Товар"));
	МассивТиповНоменклатуры.Добавить(ПредопределенноеЗначение("Перечисление.ТипыНоменклатуры.МногооборотнаяТара"));
	МассивТиповНоменклатуры.Добавить(ПредопределенноеЗначение("Перечисление.ТипыНоменклатуры.Работа"));
	
	ПараметрыОтбора = Новый Соответствие;
	ПараметрыОтбора.Вставить("Номенклатура.ТипНоменклатуры", МассивТиповНоменклатуры);
	
	Колонки = "Номенклатура,Характеристика,Упаковка,КоличествоУпаковок";
	
	СтрокиИзБуфера = РаботаСТабличнымиЧастями.СтрокиИзБуфераОбмена(ПараметрыОтбора, Колонки);
	
	Если Не ЗначениеЗаполнено(СтрокиИзБуфера) Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураДействий = Новый Структура;
	
	КэшированныеЗначения = ОбработкаТабличнойЧастиКлиентСервер.ПолучитьСтруктуруКэшируемыеЗначения();
	
	Для каждого СтрокаИзБуфера Из СтрокиИзБуфера Цикл
		
		Таблица = Объект[ИмяТЧ];//ДанныеФормыКоллекция - 
		ТекущаяСтрока = Таблица.Добавить();
		ЗаполнитьЗначенияСвойств(ТекущаяСтрока, СтрокаИзБуфера);
		
		ДобавитьВСтруктуруДействияПриИзмененииНоменклатуры(СтруктураДействий, ТекущаяСтрока, ИмяТЧ);
		
		ОбработкаТабличнойЧастиСервер.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДоступностьКомандБуфераОбмена(Форма, ДоступностьРеквизитов)
	
	Форма.Элементы.Материалы_ВставитьСтроки.Доступность = ДоступностьРеквизитов;
	Форма.Элементы.КонтекстноеМенюМатериалы_ВставитьСтроки.Доступность = ДоступностьРеквизитов;
	
	Форма.Элементы.Аналоги_ВставитьСтроки.Доступность = ДоступностьРеквизитов;
	Форма.Элементы.КонтекстноеМенюАналоги_ВставитьСтроки.Доступность = ДоступностьРеквизитов;
	
КонецПроцедуры

#КонецОбласти

#Область ПодбораПоСпецификации

&НаСервере
Функция ПараметрыПодбораПоСпецификации()
	
	ДанныеПоНоменклатуре = Справочники.РесурсныеСпецификации.ДанныеПоНоменклатуреРасширенный();
	ЗаполнитьЗначенияСвойств(ДанныеПоНоменклатуре, Объект, "Спецификация");
	
	ЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
		Объект.Спецификация, "ОсновноеИзделиеНоменклатура, ОсновноеИзделиеУпаковка, ОсновноеИзделиеКоличествоУпаковок");
		
	ДанныеСпецификации = Новый Структура;
	ДанныеСпецификации.Вставить("Номенклатура",       ЗначенияРеквизитов.ОсновноеИзделиеНоменклатура);
	ДанныеСпецификации.Вставить("Упаковка",           ЗначенияРеквизитов.ОсновноеИзделиеУпаковка);
	ДанныеСпецификации.Вставить("КоличествоУпаковок", ЗначенияРеквизитов.ОсновноеИзделиеКоличествоУпаковок);
	ДанныеСпецификации.Вставить("Количество",         0);
		
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПересчитатьКоличествоЕдиниц");
	
	ОбработкаТабличнойЧастиСервер.ОбработатьСтрокуТЧ(ДанныеСпецификации, СтруктураДействий, Неопределено);
	
	ДанныеПоНоменклатуре.Количество = ДанныеСпецификации.Количество;
	
	СтруктураПолейТаблицы = ПроизводствоСервер.СтруктураПолейТаблицы();
	СтруктураПолейТаблицы.ОсновныеПоля = "Номенклатура, Характеристика, КоличествоУпаковок, Упаковка";
	СтруктураПолейТаблицы.ДополнительныеПоля.Вставить("Этап", Новый ОписаниеТипов("СправочникСсылка.ЭтапыПроизводства"));
	СтруктураПолейТаблицы.ЗначенияПоУмолчанию.Вставить("Этап", Объект.Этап);
	
	АдресПодобранныеМатериалы = ПроизводствоСервер.ПоместитьВоВременноеХранилищеДанныеСтрок(
									ЭтотОбъект, "Объект", "Материалы", Ложь, СтруктураПолейТаблицы);
	
	ПараметрыПодбора = Новый Структура;
	ПараметрыПодбора.Вставить("ДанныеПоНоменклатуре", ДанныеПоНоменклатуре);
	ПараметрыПодбора.Вставить("Этап", Объект.Этап);
	ПараметрыПодбора.Вставить("ПоказыватьКоличествоПодобрано", Истина);
	ПараметрыПодбора.Вставить("ЗаголовокКолонкиКоличествоПодобрано", НСтр("ru = 'В документе';
																			|en = 'In document'"));
	ПараметрыПодбора.Вставить("СтруктураПоискаПодобранныеМатериалы", Новый Структура("Номенклатура, Характеристика, Этап"));
	ПараметрыПодбора.Вставить("АдресПодобранныеМатериалы", АдресПодобранныеМатериалы);
	ПараметрыПодбора.Вставить("Основание", Объект.Ссылка);
	
	Возврат ПараметрыПодбора;
	
КонецФункции

&НаСервере
Процедура ОбработатьПодборМатериаловПоСпецификации(АдресВХранилище)
	
	ТаблицаДанных = ПолучитьИзВременногоХранилища(АдресВХранилище);
	Для каждого СтрокаТаблицы Из ТаблицаДанных Цикл
		
		СтрокаМатериалы = Объект.Материалы.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаМатериалы, СтрокаТаблицы);
		СтрокаМатериалы.ИдентификаторСтроки = Новый УникальныйИдентификатор;
		
	КонецЦикла;	
	
КонецПроцедуры	

#КонецОбласти

// СтандартныеПодсистемы.Свойства 

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()

	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтотОбъект);

КонецПроцедуры

// Конец СтандартныеПодсистемы.Свойства

#КонецОбласти
