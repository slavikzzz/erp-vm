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
	
	ИнтеграцияИС.НастроитьВидимостьДокументаОснования(ЭтотОбъект);
	Элементы.ДокументОснование.ДоступныеТипы = Метаданные.ОпределяемыеТипы.ОснованиеЗапросОстатковПартийСАТУРН.Тип;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыИС.ПриСозданииНаСервере(ЭтотОбъект);
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ВерсионированиеОбъектов") Тогда
		МодульВерсионированиеОбъектов = ОбщегоНазначения.ОбщийМодуль("ВерсионированиеОбъектов");
		МодульВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	СобытияФормИСПереопределяемый.УстановитьСвязиПараметровВыбораСНоменклатурой(
		ЭтотОбъект,
		"ОстаткиПоДаннымСАТУРНХарактеристика",
		"Элементы.ОстаткиПоДаннымСАТУРН.ТекущиеДанные.Номенклатура");
	СобытияФормИСПереопределяемый.УстановитьСвязиПараметровВыбораСНоменклатурой(
		ЭтотОбъект,
		"ОстаткиПоДаннымСАТУРНУпаковка",
		"Элементы.ОстаткиПоДаннымСАТУРН.ТекущиеДанные.Номенклатура");
	СобытияФормИСПереопределяемый.УстановитьСвязиПараметровВыбораСНоменклатурой(
		ЭтотОбъект,
		"ОстаткиПоДаннымСАТУРНСерия",
		"Элементы.ОстаткиПоДаннымСАТУРН.ТекущиеДанные.Номенклатура");
	СобытияФормИСПереопределяемый.УстановитьСвязиПараметровВыбораСХарактеристикой(
		ЭтотОбъект,
		"ОстаткиПоДаннымСАТУРНСерия",
		"Элементы.ОстаткиПоДаннымСАТУРН.ТекущиеДанные.Характеристика");
	
	СобытияФормСАТУРН.УстановитьСвязиПараметровВыбораСОрганизациейМестомХранения(ЭтотОбъект, "МестоХранения",, "");
	СобытияФормСАТУРН.УстановитьПараметрыВыбораОрганизации(ЭтотОбъект);
	
	Если Объект.Ссылка.Пустая() Тогда
		ПриСозданииЧтенииНаСервере();
		ИнтеграцияИСПереопределяемый.ЗаполнитьСтатусыУказанияСерий(Объект, ПараметрыУказанияСерий);
	КонецЕсли;
	НастроитьЗависимыеЭлементыФормы(ЭтотОбъект);
	
	ОбщегоНазначенияСобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаЗаписиНового(НовыйОбъект, Источник, СтандартнаяОбработка)
	
	Если НовыйОбъект = Элементы.ДокументОснование.ДоступныеТипы.ПривестиЗначение(НовыйОбъект) Тогда
		Объект.ДокументОснование = НовыйОбъект;
		Модифицированность = Истина;
		Записать();
	КонецЕсли;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриВыбореНоменклатуры", ЭтотОбъект);
	СобытияФормСАТУРНКлиентПереопределяемый.ОбработкаВыбораНоменклатуры(ОписаниеОповещения, НовыйОбъект, Источник);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	ПриСозданииЧтенииНаСервере(Ложь);
	
	ОбщегоНазначенияСобытияФормИСПереопределяемый.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыИС.ПриЧтенииНаСервере(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	ИмяПодсистемы = ИнтеграцияСАТУРНКлиентСервер.ИмяПодсистемы();
	
	Если ИмяСобытия = ОбменДаннымиИСКлиентСервер.ИмяСобытияИзмененоСостояние(ИмяПодсистемы)
		И Параметр.Ссылка = Объект.Ссылка Тогда
		
		Если Параметр.Свойство("ОбъектИзменен")
			И Параметр.ОбъектИзменен Тогда
			ОбновитьПредставленияНаФорме(Истина);
		Иначе
			ОбновитьПредставленияНаФорме(Ложь);
		КонецЕсли;
		
	КонецЕсли;
	
	Если ИмяСобытия = ОбменДаннымиИСКлиентСервер.ИмяСобытияВыполненОбмен(ИмяПодсистемы)
	 И (Параметр = Неопределено
		Или (ТипЗнч(Параметр) = Тип("Структура") И Параметр.ОбновлятьСтатусВФормахДокументов)) Тогда
		
		ОбновитьПредставленияНаФорме(Истина);
		
	КонецЕсли;
	
	Если ИмяСобытия = "Закрытие_ПерейтиКСтрокеОшибки" И Источник = "Справочник.САТУРНПрисоединенныеФайлы.Форма.ФормаОшибки" Тогда
		ТекущийЭлемент = Элементы.ОстаткиПоДаннымСАТУРН;
		Элементы.ОстаткиПоДаннымСАТУРН.ТекущаяСтрока = Параметр;
	КонецЕсли;
	
	Если (ИмяСобытия = "Запись_КлассификаторОрганизацийСАТУРН" И Параметр = Объект.ОрганизацияСАТУРН
		Или ИмяСобытия = "Запись_МестаХраненияСАТУРН" И Параметр = Объект.МестоХранения) Тогда
		
		ЗаполнитьГиперссылкиРеквизитов();
		
	КонецЕсли;
	
	ОбщегоНазначенияСобытияФормИСКлиентПереопределяемый.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	СобытияФормСАТУРНКлиентПереопределяемый.ОбработкаВыбораСерии(
		ЭтотОбъект, ВыбранноеЗначение, ИсточникВыбора, ПараметрыУказанияСерий);
	
	СобытияФормСАТУРНКлиентПереопределяемый.ОбработкаВыбора(ЭтотОбъект, ВыбранноеЗначение, ИсточникВыбора);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаНавигационнойСсылки(НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СобытияФормСАТУРНКлиент.ОбработкаНавигационнойСсылкиСАТУРН(ЭтотОбъект, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка);
	Если Не СтандартнаяОбработка Тогда
		Возврат;
	КонецЕсли;
	
	СобытияФормИСКлиент.ОбработкаНавигационнойСсылки(ЭтотОбъект, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	ОбщегоНазначенияСобытияФормИСКлиентПереопределяемый.ПередЗаписью(ЭтотОбъект, Отказ, ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ИнтеграцияИСКлиент.ПослеЗаписиВФормеОбъектаДокументаИС(
		ЭтотОбъект,
		Объект,
		ИнтеграцияСАТУРНКлиентСервер.ИмяПодсистемы(),
		ПараметрыЗаписи);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульПодключаемыеКомандыКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ПодключаемыеКомандыКлиент");
		МодульПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	Подключаемый_ОбновитьКоманды();
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	ИнтеграцияИСПереопределяемый.ЗаполнитьСлужебныеРеквизитыВКоллекции(ЭтотОбъект, Объект.ОстаткиПоДаннымСАТУРН);
	ЗаполнитьСопоставленныеТовары();
	
	ОбновитьПредставленияНаФорме();
	НастроитьЗависимыеЭлементыФормы(ЭтотОбъект);
	
	ИнтеграцияИС.ПослеЗаписиНаСервереВФормеОбъектаДокументаИС(
		ЭтотОбъект,
		ТекущийОбъект,
		ИнтеграцияСАТУРНКлиентСервер.ИмяПодсистемы(),
		ПараметрыЗаписи);
	
	ОбщегоНазначенияСобытияФормИСПереопределяемый.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СтатусПредставлениеОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;

	ОчиститьСообщения();

	Если (Не ЗначениеЗаполнено(Объект.Ссылка)) Или (Не Объект.Проведен) Тогда

		ОписаниеОповещенияВопрос = Новый ОписаниеОповещения("СтатусПредставлениеОбработкаНавигационнойСсылкиЗавершение",
		                                                    ЭтотОбъект,
		                                                    Новый Структура("НавигационнаяСсылкаФорматированнойСтроки", НавигационнаяСсылкаФорматированнойСтроки));
		ТекстВопроса = НСтр("ru = '""Запрос остатков партий"" не проведен. Провести?';
							|en = '""Запрос остатков партий"" не проведен. Провести?'");
		ПоказатьВопрос(ОписаниеОповещенияВопрос, ТекстВопроса, РежимДиалогаВопрос.ДаНет);

	ИначеЕсли Модифицированность Тогда

		ОписаниеОповещенияВопрос = Новый ОписаниеОповещения("СтатусПредставлениеОбработкаНавигационнойСсылкиЗавершение",
		                                                    ЭтотОбъект,
		                                                    Новый Структура("НавигационнаяСсылкаФорматированнойСтроки", НавигационнаяСсылкаФорматированнойСтроки));
		ТекстВопроса = НСтр("ru = '""Запрос остатков партий"" был изменен. Провести?';
							|en = '""Запрос остатков партий"" был изменен. Провести?'");
		ПоказатьВопрос(ОписаниеОповещенияВопрос, ТекстВопроса, РежимДиалогаВопрос.ДаНет);

	Иначе

		ОбработатьНажатиеНавигационнойСсылки(НавигационнаяСсылкаФорматированнойСтроки);

	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ДокументОснованиеПриИзменении(Элемент)
	
	НастроитьЗависимыеЭлементыФормы(ЭтотОбъект, "ДокументОснование");
	
КонецПроцедуры

&НаКлиенте
Процедура МестоХраненияПриИзменении(Элемент)
	
	ЗаполнитьГиперссылкиРеквизитов();
	НастроитьЗависимыеЭлементыФормы(ЭтотОбъект, "МестоХранения");
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияСАТУРНПриИзменении(Элемент)
	ЗаполнитьГиперссылкиРеквизитов();
КонецПроцедуры

&НаКлиенте
Процедура ДокументОснованиеОчистка(Элемент, СтандартнаяОбработка)
	ЗаполнитьОтборыПоОснованию(Неопределено, ЭтотОбъект);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыОстаткиПоДаннымСАТУРН

&НаКлиенте
Процедура ОстаткиПоДаннымСАТУРНВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если (РедактированиеФормыНедоступно Или Не ПравоИзменения)
		И (Не Поле.Доступность Или Поле.ТолькоПросмотр) Тогда
		СобытияФормСАТУРНКлиент.ВыборЭлементаТабличнойЧастиОткрытьФормуЭлемента(ЭтотОбъект, Элемент, Поле);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОстаткиПоДаннымСАТУРНПередУдалением(Элемент, Отказ)
	
	Если РедактированиеФормыНедоступно Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОстаткиПоДаннымСАТУРНПриАктивизацииЯчейки(Элемент)
	
	ТекущиеДанные = Элементы.ОстаткиПоДаннымСАТУРН.ТекущиеДанные;
	
	Если Элемент.ТекущийЭлемент = Элементы.ОстаткиПоДаннымСАТУРННоменклатура Тогда
		
		ЗаполнитьСпискиВыбораНоменклатуры(ТекущиеДанные);
		
	КонецЕсли;
	
	Если Элемент.ТекущийЭлемент = Элементы.ОстаткиПоДаннымСАТУРНХарактеристика Тогда
		
		ЗаполнитьСпискиВыбораХарактеристика(ТекущиеДанные);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОстаткиПоДаннымСАТУРННоменклатураНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СобытияФормИСКлиентПереопределяемый.ПриНачалеВыбораНоменклатуры(
		Элемент,
		ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.ПодконтрольнаяПродукцияСАТУРН"),
		СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОстаткиПоДаннымСАТУРННоменклатураПриИзменении(Элемент)
	
	НоменклатураПриИзменении();
	
КонецПроцедуры

&НаКлиенте
Процедура ОстаткиПоДаннымСАТУРНХарактеристикаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.ОстаткиПоДаннымСАТУРН.ТекущиеДанные;
	СобытияФормСАТУРНКлиентПереопределяемый.ПриНачалеВыбораХарактеристики(
		Элемент, ТекущиеДанные, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОстаткиПоДаннымСАТУРНХарактеристикаПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ОстаткиПоДаннымСАТУРН.ТекущиеДанные;
	СобытияФормСАТУРНКлиентПереопределяемый.ПриИзмененииХарактеристики(ЭтотОбъект, ТекущиеДанные, КэшированныеЗначения);
	
КонецПроцедуры

&НаКлиенте
Процедура ОстаткиПоДаннымСАТУРНСерияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ИнтеграцияИСКлиент.ОткрытьПодборСерий(ЭтотОбъект,, Элемент.ТекстРедактирования, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОстаткиПоДаннымСАТУРНСерияПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ОстаткиПоДаннымСАТУРН.ТекущиеДанные;
	СобытияФормСАТУРНКлиентПереопределяемый.ПриИзмененииСерии(
		ЭтотОбъект, ТекущиеДанные, КэшированныеЗначения, ПараметрыУказанияСерий);
	
КонецПроцедуры

&НаКлиенте
Процедура ОстаткиПоДаннымСАТУРНУпаковкаПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ОстаткиПоДаннымСАТУРН.ТекущиеДанные;
	СобытияФормСАТУРНКлиентПереопределяемый.ПриИзмененииУпаковки(
		ЭтотОбъект, ТекущиеДанные, КэшированныеЗначения);
	
	ПриИзмененииКоличестваВУпаковкеСАТУРН(ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура ОстаткиПоДаннымСАТУРНКоличествоУпаковокПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ОстаткиПоДаннымСАТУРН.ТекущиеДанные;
	СобытияФормСАТУРНКлиентПереопределяемый.ПриИзмененииКоличестваУпаковок(
		ЭтотОбъект, ТекущиеДанные, КэшированныеЗначения);
	
	ПриИзмененииКоличестваУпаковок(ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура ОстаткиПоДаннымСАТУРНТипИзмеряемойВеличиныСАТУРННачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекущиеДанные = Элементы.ОстаткиПоДаннымСАТУРН.ТекущиеДанные;
	
	Данные = Новый Структура;
	Данные.Вставить("Партия",       ТекущиеДанные.Партия);
	Данные.Вставить("Номенклатура", ТекущиеДанные.Номенклатура);
	Данные.Вставить("Упаковка",     ТекущиеДанные.Упаковка);
	
	ДанныеВыбора = Новый СписокЗначений;
	ДанныеВыбора.ЗагрузитьЗначения(
		ИнтеграцияСАТУРНКлиент.ДоступныеТипыИзмеряемыхВеличин(Данные, КэшированныеЗначения));
	
КонецПроцедуры

&НаКлиенте
Процедура ОстаткиПоДаннымСАТУРНТипИзмеряемойВеличиныСАТУРНПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ОстаткиПоДаннымСАТУРН.ТекущиеДанные;
	СобытияФормСАТУРНКлиентПереопределяемый.ПриИзмененииТипаИзмеряемойВеличины(
		ЭтотОбъект, ТекущиеДанные, КэшированныеЗначения);
	
	ПриИзмененииКоличестваВУпаковкеСАТУРН(ТекущиеДанные);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПровестиДокумент(Команда)
	
	ОценкаПроизводительностиКлиент.ЗамерВремени("Документ.ЗапросОстатковПартийСАТУРН.Форма.ФормаДокумента.Провести",,Истина);
	
	ОчиститьСообщения();
	ПараметрыЗаписи = Новый Структура("РежимЗаписи", РежимЗаписиДокумента.Проведение);
	Записать(ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьДокумент(Команда)
	
	ОценкаПроизводительностиКлиент.ЗамерВремени("Документ.ЗапросОстатковПартийСАТУРН.Форма.ФормаДокумента.Записать",,Истина);
	
	ОчиститьСообщения();
	Записать();
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиИЗакрыть(Команда)
	
	ОценкаПроизводительностиКлиент.ЗамерВремени("Документ.ЗапросОстатковПартийСАТУРН.Форма.ФормаДокумента.ПровестиИЗакрыть",,Истина);
	
	ОчиститьСообщения();
	ПараметрыЗаписи = Новый Структура("РежимЗаписи", РежимЗаписиДокумента.Проведение);
	
	Если Записать(ПараметрыЗаписи) Тогда
		Закрыть();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура АрхивироватьДокумент(Команда)
	
	ОбщегоНазначенияИСКлиент.АрхивироватьДокументы(ЭтотОбъект, Объект.Ссылка, ИнтеграцияСАТУРНКлиент);
	
КонецПроцедуры

&НаКлиенте
Процедура ПерезаполнитьПоОснованию(Команда)
	ОбработчикПерезаполненияПоОснованию();
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоРасхождениям(Команда)
	
	ОчиститьСообщения();
	ЗаполнитьПоРасхождениямНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура НеСниматьРезервы(Команда)
	НеСниматьРезервыСервер();
КонецПроцедуры

&НаКлиенте
Процедура СопоставитьНоменклатуру(Команда)
	
	ОповещениеОЗавершении = Новый ОписаниеОповещения("ПриЗавершенииСопоставленияНоменклатурыСтрок", ЭтотОбъект);
	ИнтеграцияИСКлиент.ОткрытьФормуУказанияНоменклатуры(ЭтотОбъект, ОповещениеОЗавершении,
		ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(
			ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.ПодконтрольнаяПродукцияСАТУРН")));
	
КонецПроцедуры

#Область ПодключаемыеКоманды

&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда) Экспорт
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды() Экспорт
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	ПодключаемыеКомандыИСКлиентСервер.УправлениеВидимостьюКомандПодключенныхКОбъекту(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда) Экспорт
	
	СобытияФормИСКлиентПереопределяемый.ВыполнитьПереопределяемуюКоманду(ЭтотОбъект, Команда);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьОбменОбработкаОжидания() Экспорт
	
	ИнтеграцияСАТУРНСлужебныйКлиент.ПродолжитьВыполнениеОбмена(ЭтотОбъект, Объект.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриЗавершенииОперации(Результат, ДополнительныеПараметры) Экспорт

	Прочитать();

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПослеВыбораОснования(ДанныеВыбора, ДополнительныеПараметры) Экспорт
	
	Если ДанныеВыбора = Элементы.ДокументОснование.ДоступныеТипы.ПривестиЗначение(ДанныеВыбора) Тогда
		Объект.ДокументОснование = ДанныеВыбора;
		Модифицированность       = Истина;
	КонецЕсли;
	
	ЗаполнитьОстаткиПоДаннымСАТУРН = (ТипЗнч(ДополнительныеПараметры) = Тип("Структура")
		И ДополнительныеПараметры.Свойство("ОбработатьПерезаполнение"));
	Если ЗаполнитьОстаткиПоДаннымСАТУРН Тогда
		ОбработчикПерезаполненияПоОснованию(Ложь);
	КонецЕсли;
	
	НастроитьЗависимыеЭлементыФормы(ЭтотОбъект, "ДокументОснование");
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	СобытияФормИСПереопределяемый.УстановитьУсловноеОформлениеЕдиницИзмерения(
		ЭтотОбъект,
		"ОстаткиПоДаннымСАТУРННоменклатураЕдиницаИзмерения",
		"Объект.ОстаткиПоДаннымСАТУРН.Упаковка");
	СобытияФормИСПереопределяемый.УстановитьУсловноеОформлениеХарактеристикНоменклатуры(
		ЭтотОбъект,
		"ОстаткиПоДаннымСАТУРНХарактеристика",
		"Объект.ОстаткиПоДаннымСАТУРН.ХарактеристикиИспользуются");
	СобытияФормИСПереопределяемый.УстановитьУсловноеОформлениеСерийНоменклатуры(
		ЭтотОбъект,
		"ОстаткиПоДаннымСАТУРНСерия",
		"Объект.ОстаткиПоДаннымСАТУРН.СтатусУказанияСерий",
		"Объект.ОстаткиПоДаннымСАТУРН.ТипНоменклатуры");
	
	СобытияФормИС.УстановитьУсловноеОформлениеПоляНоменклатура(
		ЭтотОбъект, "ОстаткиПоДаннымСАТУРННоменклатура", "ОстаткиПоДаннымСАТУРН", Ложь);
	СобытияФормИС.УстановитьУсловноеОформлениеПоляХарактеристика(
		ЭтотОбъект, "ОстаткиПоДаннымСАТУРНХарактеристика", "ОстаткиПоДаннымСАТУРН", Ложь);
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииЧтенииНаСервере(ОбновитьКомандыОснования = Истина)
	
	ЦветГиперссылки = ЦветаСтиля.ЦветГиперссылкиГосИС;
	ЦветТекстаПоля  = ЦветаСтиля.ЦветТекстаПоля;
	
	ПравоИзменения = ПравоДоступа("Изменение", Метаданные.Документы.ЗапросОстатковПартийСАТУРН);
	ЗаполнитьОтборыПоОснованию(Объект.ДокументОснование, ЭтотОбъект, ОбновитьКомандыОснования);
	ИнтеграцияИСПереопределяемый.ЗаполнитьСлужебныеРеквизитыВКоллекции(ЭтотОбъект, Объект.ОстаткиПоДаннымСАТУРН);
	
	ЗаполнитьСопоставленныеТовары();
	
	ПараметрыУказанияСерий = ИнтеграцияИС.ПараметрыУказанияСерийФормыОбъекта(Объект, Документы.ЗапросОстатковПартийСАТУРН);
	
	ЗаполнитьГиперссылкиРеквизитов();
	ОбновитьПредставленияНаФорме();
	
	СобытияФормИСКлиентСерверПереопределяемый.УстановитьПараметрыВыбораНоменклатуры(
		ЭтотОбъект,
		Перечисления.ВидыПродукцииИС.ПодконтрольнаяПродукцияСАТУРН,
		"ОстаткиПоДаннымСАТУРННоменклатура");
	
	НастроитьЗависимыеЭлементыФормы(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьПредставленияНаФорме(Прочитать = Ложь)

	Если Прочитать Тогда
		Прочитать();
	Иначе
		ОбновитьСтатусСАТУРН(ЭтотОбъект);
	КонецЕсли;

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура НастроитьЗависимыеЭлементыФормы(Форма, СписокРеквизитов = "")
	
	Элементы = Форма.Элементы;
	Объект   = Форма.Объект;
	
	Инициализация = ПустаяСтрока(СписокРеквизитов);
	СтруктураРеквизитов = Новый Структура(СписокРеквизитов);
	
	Если Инициализация Тогда
		
	КонецЕсли;
	
	Если СтруктураРеквизитов.Свойство("СтатусСАТУРН") Тогда
		
		РедактированиеФормыНеДоступно = Форма.СтатусСАТУРН <> ПредопределенноеЗначение("Перечисление.СтатусыОбработкиЗапросаОстатковПартийСАТУРН.Черновик")
			И Форма.СтатусСАТУРН <> ПредопределенноеЗначение("Перечисление.СтатусыОбработкиЗапросаОстатковПартийСАТУРН.Ошибка");
		
		Форма.РедактированиеФормыНеДоступно = РедактированиеФормыНеДоступно;
	
		Элементы.ГруппаНередактируемыеПослеОтправкиРеквизитыОсновное.ТолькоПросмотр = РедактированиеФормыНеДоступно;
		
	КонецЕсли;
	
	Если Инициализация Или СтруктураРеквизитов.Свойство("МестоХранения") Тогда
		
		Элементы.ОстаткиПоДаннымСАТУРНМестоХранения.Видимость = Не ЗначениеЗаполнено(Объект.МестоХранения);
		Элементы.КорректировкаОстатковМестоХранения.Видимость = Не ЗначениеЗаполнено(Объект.МестоХранения);
		
	КонецЕсли;
	
	Если Инициализация Или СтруктураРеквизитов.Свойство("ОбновитьСтатусСАТУРН") Тогда
		
		УстановитьПараметрыОбновленияСтатуса = Форма.Модифицированность И НЕ Инициализация;
		ОбновитьСтатусСАТУРН(Форма, УстановитьПараметрыОбновленияСтатуса);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПоРасхождениямНаСервере()
	
	ТекущийОбъект = РеквизитФормыВЗначение("Объект");
	ТекущийОбъект.ЗаполнитьПоРасхождениям();
	
	ЗначениеВРеквизитФормы(ТекущийОбъект, "Объект");
	
КонецПроцедуры

&НаСервере
Процедура НеСниматьРезервыСервер()
	Для Каждого СтрокаТЧ Из Объект.КорректировкаОстатков Цикл
		СтрокаТЧ.ВОбработкеСАТУРН = 0;
	КонецЦикла;
КонецПроцедуры

#Область ПерезаполнениеПоОснованию

&НаКлиенте
Процедура ОбработчикПерезаполненияПоОснованию(ЗадаватьВопрос = Истина)
	
	ОчиститьСообщения();
	
	Если Объект.ОстаткиПоДаннымСАТУРН.Количество() > 0 И ЗадаватьВопрос Тогда
		
		ТекстВопроса = НСтр("ru = 'Данные документа будут перезаполнены. Продолжить?';
							|en = 'Данные документа будут перезаполнены. Продолжить?'");
		ОписаниеОповещенияОЗавершении = Новый ОписаниеОповещения("ВопросОПерезаполнениииПоОснованиюПриЗавершении", ЭтотОбъект);
		ПоказатьВопрос(ОписаниеОповещенияОЗавершении, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		
	Иначе
		
		ПерезаполнитьПоОснованиюСервер();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросОПерезаполнениииПоОснованиюПриЗавершении(Результат, Параметры) Экспорт

	Если Результат = КодВозвратаДиалога.Да Тогда
		
		ПерезаполнитьПоОснованиюСервер();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПерезаполнитьПоОснованиюСервер()
	
	ТекущийОбъект = РеквизитФормыВЗначение("Объект");
	ТекущийОбъект.Заполнить(Объект.ДокументОснование);
	
	ЗначениеВРеквизитФормы(ТекущийОбъект, "Объект");
	
	ПриСозданииЧтенииНаСервере();
	ИнтеграцияИСПереопределяемый.ЗаполнитьСтатусыУказанияСерий(Объект, ПараметрыУказанияСерий);
	
	Модифицированность = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область Статус

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьСтатусСАТУРН(Форма, УстановитьПараметрыОбновленияСтатуса = Ложь)
	
	Объект = Форма.Объект;
	
	ПараметрыСтатуса = ПараметрыСтатусаДокумента(Объект);
	
	Форма.СтатусСАТУРН                  = ПараметрыСтатуса.СтатусСАТУРН;
	Форма.СтатусСАТУРНПредставление     = ПараметрыСтатуса.СтатусСАТУРНПредставление;
	Форма.РедактированиеФормыНеДоступно = ПараметрыСтатуса.РедактированиеФормыНеДоступно;
	
	НастроитьЗависимыеЭлементыФормы(Форма, "СтатусСАТУРН");
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПараметрыСтатусаДокумента(ДокументОбъект)
	
	Результат = Новый Структура;
	Результат.Вставить("СтатусСАТУРН");
	Результат.Вставить("СтатусСАТУРНПредставление");
	Результат.Вставить("РедактированиеФормыНеДоступно", Ложь);
	
	Ссылка = ДокументОбъект.Ссылка;
	
	МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоСсылке(Ссылка);
	
	СтатусСАТУРН       = МенеджерОбъекта.СтатусПоУмолчанию();
	ДальнейшееДействие = МенеджерОбъекта.ДальнейшееДействиеПоУмолчанию();
	
	Если ЗначениеЗаполнено(Ссылка) Тогда
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	Статусы.Статус КАК Статус,
		|	ВЫБОР
		|		КОГДА Статусы.ДальнейшееДействие1 В (&МассивДальнейшиеДействия)
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ДальнейшиеДействияПоВзаимодействиюСАТУРН.НеТребуется)
		|		ИНАЧЕ Статусы.ДальнейшееДействие1
		|	КОНЕЦ КАК ДальнейшееДействие1,
		|	ВЫБОР
		|		КОГДА Статусы.ДальнейшееДействие2 В (&МассивДальнейшиеДействия)
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ДальнейшиеДействияПоВзаимодействиюСАТУРН.НеТребуется)
		|		ИНАЧЕ Статусы.ДальнейшееДействие2
		|	КОНЕЦ КАК ДальнейшееДействие2,
		|	ВЫБОР
		|		КОГДА Статусы.ДальнейшееДействие3 В (&МассивДальнейшиеДействия)
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ДальнейшиеДействияПоВзаимодействиюСАТУРН.НеТребуется)
		|		ИНАЧЕ Статусы.ДальнейшееДействие3
		|	КОНЕЦ КАК ДальнейшееДействие3
		|ИЗ
		|	РегистрСведений.СтатусыДокументовСАТУРН КАК Статусы
		|ГДЕ
		|	Статусы.Документ = &Документ");
		
		Запрос.УстановитьПараметр("Документ",                 Ссылка);
		Запрос.УстановитьПараметр("МассивДальнейшиеДействия", ИнтеграцияСАТУРН.НеотображаемыеВДокументахДальнейшиеДействия());
		
		Выборка = Запрос.Выполнить().Выбрать();
		
		Если Выборка.Следующий() Тогда
			
			СтатусСАТУРН = Выборка.Статус;
			
			ДальнейшееДействие = Новый Массив;
			ДальнейшееДействие.Добавить(Выборка.ДальнейшееДействие1);
			ДальнейшееДействие.Добавить(Выборка.ДальнейшееДействие2);
			ДальнейшееДействие.Добавить(Выборка.ДальнейшееДействие3);
			
		КонецЕсли;
		
	КонецЕсли;
	
	ДопустимыеДействия = Новый Массив;
	ДопустимыеДействия.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюСАТУРН.ПередайтеДанные);
	ДопустимыеДействия.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюСАТУРН.ОтменитеОперацию);
	ДопустимыеДействия.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюСАТУРН.ОтменитеПередачуДанных);
	
	СтатусСАТУРНПредставление = ИнтеграцияСАТУРН.ПредставлениеСтатуса(СтатусСАТУРН, ДальнейшееДействие, ДопустимыеДействия);
	
	РедактированиеФормыНеДоступно = СтатусСАТУРН <> Перечисления.СтатусыОбработкиЗапросаОстатковПартийСАТУРН.Черновик;
	
	Результат.СтатусСАТУРН                  = СтатусСАТУРН;
	Результат.СтатусСАТУРНПредставление     = СтатусСАТУРНПредставление;
	Результат.РедактированиеФормыНеДоступно = РедактированиеФормыНеДоступно;
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура СтатусПредставлениеОбработкаНавигационнойСсылкиЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт

	Если Не РезультатВопроса = КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;

	Если ПроверитьЗаполнение() Тогда
		Записать(Новый Структура("РежимЗаписи", РежимЗаписиДокумента.Проведение));
		РазблокироватьДанныеФормыДляРедактирования();
	КонецЕсли;

	Если Не Модифицированность И Объект.Проведен Тогда
		ОбработатьНажатиеНавигационнойСсылки(ДополнительныеПараметры.НавигационнаяСсылкаФорматированнойСтроки);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОбработатьНажатиеНавигационнойСсылки(НавигационнаяСсылкаФорматированнойСтроки)
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "ПередатьДанные" Тогда
		
		ПараметрыОбработкиДокументов = ИнтеграцияСАТУРНСлужебныйКлиентСервер.ПараметрыОбработкиДокументов();
		ПараметрыОбработкиДокументов.Ссылка             = Объект.Ссылка;
		ПараметрыОбработкиДокументов.ОрганизацияСАТУРН  = Объект.ОрганизацияСАТУРН;
		ПараметрыОбработкиДокументов.ДальнейшееДействие = ПредопределенноеЗначение("Перечисление.ДальнейшиеДействияПоВзаимодействиюСАТУРН.ПередайтеДанные");
		
		ОписаниеПриЗавершении = Новый ОписаниеОповещения(
			"Подключаемый_ПриЗавершенииОперации", ЭтотОбъект, ПараметрыОбработкиДокументов);
		
		ИнтеграцияСАТУРНКлиент.ПодготовитьКПередаче(
			ЭтотОбъект,
			ПараметрыОбработкиДокументов,
			ОписаниеПриЗавершении);
			
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "ОтменитьОперацию" Тогда
		
		ИнтеграцияСАТУРНКлиент.ОтменитьПоследнююОперацию(Объект.Ссылка);
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "ОтменитьПередачуДанных" Тогда
		
		ИнтеграцияСАТУРНКлиент.ОтменитьПередачу(Объект.Ссылка);
	
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "ПоказатьПричинуОшибки" Тогда
		
		ПараметрыОткрытияФормы = Новый Структура;
		ПараметрыОткрытияФормы.Вставить("Документ", Объект.Ссылка);
		
		ОткрытьФорму(
			"Справочник.САТУРНПрисоединенныеФайлы.Форма.ФормаОшибки",
			ПараметрыОткрытияФормы,
			ЭтотОбъект);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

&НаСервере
Процедура ЗаполнитьГиперссылкиРеквизитов()
	
	СобытияФормСАТУРН.ЗаполнитьГиперссылкиРеквизитовУпрощенно(ЭтотОбъект);
		
КонецПроцедуры

#Область ОстаткиПоДаннымСАТУРН

&НаКлиенте
Процедура ЗаполнитьСпискиВыбораНоменклатуры(ТекущаяСтрока)
	
	СписокВыбораНоменклатура = Элементы.ОстаткиПоДаннымСАТУРННоменклатура.СписокВыбора;
	СписокВыбораНоменклатура.Очистить();
	
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	НайденныеСтроки = НоменклатураДляВыбора.НайтиСтроки(Новый Структура("ПАТ", ТекущаяСтрока.ПАТ));
	НоменклатураКэш = Неопределено;
	Для Каждого СтрокаТЧ Из НайденныеСтроки Цикл
		Если СтрокаТЧ.Номенклатура <> НоменклатураКэш Тогда
			СписокВыбораНоменклатура.Добавить(СтрокаТЧ.Номенклатура);
			НоменклатураКэш = СтрокаТЧ.Номенклатура;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьСпискиВыбораХарактеристика(ТекущаяСтрока)
	
	СписокВыбораХарактеристика = Элементы.ОстаткиПоДаннымСАТУРНХарактеристика.СписокВыбора;
	СписокВыбораХарактеристика.Очистить();
	
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	НайденныеСтроки = НоменклатураДляВыбора.НайтиСтроки(Новый Структура("ПАТ, Номенклатура",
		ТекущаяСтрока.ПАТ,
		ТекущаяСтрока.Номенклатура));
	Для Каждого СтрокаТЧ Из НайденныеСтроки Цикл
		СписокВыбораХарактеристика.Добавить(СтрокаТЧ.Характеристика);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииКоличестваВУпаковкеСАТУРН(ТекущиеДанные)
	
	Если ТекущиеДанные.КоличествоВУпаковкеСАТУРН > 0 Тогда
		ТекущиеДанные.КоличествоУпаковок = ТекущиеДанные.КоличествоОстатокСАТУРН / ТекущиеДанные.КоличествоВУпаковкеСАТУРН;
	Иначе
		ТекущиеДанные.КоличествоУпаковок = 0;
	КонецЕсли;
	
	СобытияФормСАТУРНКлиентПереопределяемый.ПриИзмененииКоличестваУпаковок(
		ЭтотОбъект, ТекущиеДанные, КэшированныеЗначения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииКоличестваУпаковок(ТекущиеДанные)
	
	Если ТекущиеДанные.КоличествоУпаковок > 0 Тогда
		ТекущиеДанные.КоличествоВУпаковкеСАТУРН = ТекущиеДанные.КоличествоОстатокСАТУРН / ТекущиеДанные.КоличествоУпаковок;
	Иначе
		ТекущиеДанные.КоличествоВУпаковкеСАТУРН = 0;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура НоменклатураПриИзменении(ТекущиеДанные = Неопределено)
	
	Если ТекущиеДанные = Неопределено Тогда
		ТекущиеДанные = Элементы.ОстаткиПоДаннымСАТУРН.ТекущиеДанные;
	КонецЕсли;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СобытияФормСАТУРНКлиентПереопределяемый.ПриИзмененииНоменклатуры(
		ЭтотОбъект, ТекущиеДанные, КэшированныеЗначения, ПараметрыУказанияСерий);
	
	ПриИзмененииКоличестваВУпаковкеСАТУРН(ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриВыбореНоменклатуры(Номенклатура, ДополнительныеПараметры) Экспорт
	
	Если Номенклатура = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элементы.ОстаткиПоДаннымСАТУРН.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные.Номенклатура = Номенклатура;
	
	НоменклатураПриИзменении(ТекущиеДанные);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ЗаполнитьОтборыПоОснованию(ДокументОснование, Форма, НастроитьЗависимыеЭлементыФормы = Истина)
	
	ОтборыПоОснованию = Неопределено;
	Если ДокументОснование <> Неопределено Тогда 
		ОтборыПоОснованию = ИнтеграцияСАТУРНВызовСервера.ОтборыДляРеквизитовДокументаПоОснованию(Тип("ДокументСсылка.ЗапросОстатковПартийСАТУРН"), ДокументОснование);
	КонецЕсли;
	
	Если ОтборыПоОснованию <> Неопределено Тогда
		Форма.ОрганизацияИзОснованияДляОтбораОрганизацииСАТУРН = ОтборыПоОснованию.ОрганизацияСАТУРН;
		Форма.СкладИзОснованияДляОтбораМестаХранения           = ОтборыПоОснованию.МестоХранения;
	Иначе 
		Форма.ОрганизацияИзОснованияДляОтбораОрганизацииСАТУРН = Неопределено;
		Форма.СкладИзОснованияДляОтбораМестаХранения           = Неопределено;
	КонецЕсли;
	
	Если НастроитьЗависимыеЭлементыФормы Тогда
		НастроитьЗависимыеЭлементыФормы(Форма, "ДокументОснование");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСопоставленныеТовары()
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	СоответствиеНоменклатуры.ПАТ КАК ПАТ,
	|	СоответствиеНоменклатуры.Номенклатура КАК Номенклатура,
	|	СоответствиеНоменклатуры.Характеристика КАК Характеристика
	|ИЗ
	|	РегистрСведений.СоответствиеНоменклатурыСАТУРН КАК СоответствиеНоменклатуры
	|ГДЕ
	|	СоответствиеНоменклатуры.ПАТ В (&ПАТ)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СоответствиеНоменклатуры.ПАТ КАК ПАТ,
	|	ВЫБОР
	|		КОГДА КОЛИЧЕСТВО(РАЗЛИЧНЫЕ СоответствиеНоменклатуры.Номенклатура) = 1
	|			И КОЛИЧЕСТВО(РАЗЛИЧНЫЕ СоответствиеНоменклатуры.Характеристика) = 1
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК СопоставленоОднозначно,
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ СоответствиеНоменклатуры.Номенклатура) КАК Количество,
	|	МАКСИМУМ(СоответствиеНоменклатуры.Номенклатура) КАК Номенклатура,
	|	МАКСИМУМ(СоответствиеНоменклатуры.Характеристика) КАК Характеристика
	|ИЗ
	|	РегистрСведений.СоответствиеНоменклатурыСАТУРН КАК СоответствиеНоменклатуры
	|ГДЕ
	|	СоответствиеНоменклатуры.ПАТ В (&ПАТ)
	|СГРУППИРОВАТЬ ПО
	|	СоответствиеНоменклатуры.ПАТ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СоответствиеНоменклатуры.Партия КАК Партия,
	|	ВЫБОР
	|		КОГДА КОЛИЧЕСТВО(РАЗЛИЧНЫЕ СоответствиеНоменклатуры.Номенклатура) = 1
	|			И КОЛИЧЕСТВО(РАЗЛИЧНЫЕ СоответствиеНоменклатуры.Характеристика) = 1
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК СопоставленоОднозначно,
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ СоответствиеНоменклатуры.Номенклатура) КАК Количество,
	|	МАКСИМУМ(СоответствиеНоменклатуры.Номенклатура) КАК Номенклатура,
	|	МАКСИМУМ(СоответствиеНоменклатуры.Характеристика) КАК Характеристика,
	|	МАКСИМУМ(СоответствиеНоменклатуры.Серия) КАК Серия,
	|	МАКСИМУМ(СоответствиеНоменклатуры.СтатусУказанияСерий) КАК СтатусУказанияСерий
	|ИЗ
	|	РегистрСведений.СоответствиеНоменклатурыСАТУРН КАК СоответствиеНоменклатуры
	|ГДЕ
	|	СоответствиеНоменклатуры.Партия В (&Партия)
	|СГРУППИРОВАТЬ ПО
	|	СоответствиеНоменклатуры.Партия";
	
	ПАТ = Новый Массив;
	Партии = Новый Массив;
	Для Каждого СтрокаТЧ Из Объект.ОстаткиПоДаннымСАТУРН Цикл
		ПАТ.Добавить(СтрокаТЧ.ПАТ);
		Партии.Добавить(СтрокаТЧ.Партия);
	КонецЦикла;
	Запрос.УстановитьПараметр("ПАТ", ПАТ);
	Запрос.УстановитьПараметр("Партия", Партии);
	
	Сопоставление = Запрос.ВыполнитьПакет();
	НоменклатураДляВыбора.Загрузить(Сопоставление[0].Выгрузить());
	ТаблицаСопоставленныеТовары = Сопоставление[1].Выгрузить();
	ТаблицаСопоставленныеТовары.Индексы.Добавить("ПАТ");
	ТаблицаСопоставленныеПартии = Сопоставление[2].Выгрузить();
	ТаблицаСопоставленныеПартии.Индексы.Добавить("Партия");
	
	Для каждого СтрокаТЧ Из Объект.ОстаткиПоДаннымСАТУРН Цикл
		
		СтрокаСопоставление = ТаблицаСопоставленныеПартии.Найти(СтрокаТЧ.Партия, "Партия");
		ОтметитьСопоставление = Истина;
		
		Если СтрокаСопоставление = Неопределено Тогда
			СтрокаСопоставление = ТаблицаСопоставленныеТовары.Найти(СтрокаТЧ.ПАТ, "ПАТ");
			ОтметитьСопоставление = Ложь;
		КонецЕсли;
		
		Если СтрокаСопоставление = Неопределено Тогда
			СтрокаТЧ.СопоставлениеНоменклатура   = НСтр("ru = '<Не сопоставлено>';
														|en = '<Не сопоставлено>'");
			СтрокаТЧ.СопоставлениеХарактеристика = НСтр("ru = '<Не сопоставлено>';
														|en = '<Не сопоставлено>'");
		ИначеЕсли СтрокаСопоставление.СопоставленоОднозначно Тогда
			СтрокаТЧ.СопоставлениеНоменклатура = СтрокаСопоставление.Номенклатура;
			СтрокаТЧ.СопоставлениеХарактеристика = СтрокаСопоставление.Характеристика;
			Если Не ЗначениеЗаполнено(СтрокаТЧ.Номенклатура) И ОтметитьСопоставление Тогда
				ЗаполнитьЗначенияСвойств(СтрокаТЧ, СтрокаСопоставление);
			КонецЕсли;
		Иначе
			СтрокаТЧ.СопоставлениеНоменклатура   = СтрШаблон(НСтр("ru = '<Несколько позиций (%1)>';
																	|en = '<Несколько позиций (%1)>'"), СтрокаСопоставление.Количество);
			СтрокаТЧ.СопоставлениеХарактеристика = НСтр("ru = '<Не сопоставлено>';
														|en = '<Не сопоставлено>'");
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗавершенииСопоставленияНоменклатурыСтрок(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Модифицированность = Истина;
	ДанныеВыбора = Результат.ДанныеВыбора;
	
	Для Каждого СтрокаСписка Из Элементы.ОстаткиПоДаннымСАТУРН.ВыделенныеСтроки Цикл
		
		ДанныеСтроки = Элементы.ОстаткиПоДаннымСАТУРН.ДанныеСтроки(СтрокаСписка);
		ДанныеСтроки.Номенклатура = ДанныеВыбора.Номенклатура;
		ДанныеСтроки.Характеристика = ДанныеВыбора.Характеристика;
		ДанныеСтроки.Серия = ДанныеВыбора.Серия;
		
		НоменклатураПриИзменении(ДанныеСтроки);
		ДанныеСтроки.Серия = ДанныеВыбора.Серия;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
