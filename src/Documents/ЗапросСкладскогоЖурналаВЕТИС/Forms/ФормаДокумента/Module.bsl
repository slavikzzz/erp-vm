#Область ОписаниеПеременных

&НаКлиенте
Перем КэшированныеЗначения; //используется механизмом обработки изменения реквизитов ТЧ

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ВерсионированиеОбъектов") Тогда
		МодульВерсионированиеОбъектов = ОбщегоНазначения.ОбщийМодуль("ВерсионированиеОбъектов");
		МодульВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	//ПодключаемыеКомандыВЕТИС.ПриСозданииНаСервере(ЭтотОбъект);
	
	Если Объект.Ссылка.Пустая() Тогда
		ПриСозданииЧтенииНаСервере();
		ЗаполнитьСтатусыУказанияСерийСервер();
	КонецЕсли;
	
	ОпределяемыйТипНоменклатура = Метаданные.ОпределяемыеТипы.Номенклатура.Тип;
	
	ИнтеграцияВЕТИСПереопределяемый.УстановитьПараметрыВыбораНоменклатуры(ЭтотОбъект);
	
	СобытияФормИСПереопределяемый.УстановитьСвязиПараметровВыбораСНоменклатурой(ЭтотОбъект, "ТоварыХарактеристика");
	СобытияФормИСПереопределяемый.УстановитьСвязиПараметровВыбораСНоменклатурой(ЭтотОбъект, "ТоварыСерия");
	
	ОбщегоНазначенияСобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	
	Если ОпределяемыйТипНоменклатура.СодержитТип(ТипЗнч(ВыбранноеЗначение)) Тогда
		
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("ТекущаяСтрока", ТекущиеДанные.ПолучитьИдентификатор());
		
		ОписаниеОповещения = Новый ОписаниеОповещения(
			"ОбработкаВыбораНоменклатурыЗавершение",
			ЭтотОбъект,
			ДополнительныеПараметры);
		
		СобытияФормВЕТИСКлиентПереопределяемый.ОбработкаВыбораНоменклатуры(
			ОписаниеОповещения,
			ВыбранноеЗначение,
			ИсточникВыбора);
		
	КонецЕсли;
		
	Если ПараметрыУказанияСерий <> Неопределено Тогда
		СобытияФормВЕТИСКлиентПереопределяемый.ОбработкаВыбораСерии(ЭтотОбъект, ПараметрыУказанияСерий, ВыбранноеЗначение,
			ИсточникВыбора);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = ОбменДаннымиИСКлиентСервер.ИмяСобытияИзмененоСостояние(ИнтеграцияВЕТИСКлиентСервер.ИмяПодсистемы())
		И Параметр.Ссылка = Объект.Ссылка Тогда
		
		Если Параметр.Свойство("ОбъектИзменен")
			И Параметр.ОбъектИзменен Тогда
			ОбновитьПредставленияНаФорме(Истина);
		Иначе
			ОбновитьПредставленияНаФорме(Ложь);
		КонецЕсли;
		
	КонецЕсли;
	
	Если ИмяСобытия = ОбменДаннымиИСКлиентСервер.ИмяСобытияВыполненОбмен(ИнтеграцияВЕТИСКлиентСервер.ИмяПодсистемы())
		И (Параметр = Неопределено
		Или (ТипЗнч(Параметр) = Тип("Структура") И Параметр.ОбновлятьСтатусВФормахДокументов)) Тогда
		
		ОбновитьПредставленияНаФорме(Истина);
		
	КонецЕсли;
	
	Если ИмяСобытия = "Запись_ХозяйствующиеСубъектыВЕТИС" Тогда
		
		СписокРеквизитовОбновления = "ХозяйствующийСубъект, Предприятие";
		НастроитьЗависимыеЭлементыФормы(ЭтотОбъект, СписокРеквизитовОбновления);
		
	КонецЕсли;
	
	Если ИмяСобытия = "Закрытие_ПерейтиКСтрокеОшибки" И Источник = "Справочник.ВЕТИСПрисоединенныеФайлы.Форма.ФормаОшибки" Тогда
		ТекущийЭлемент = Элементы.Товары;
		Элементы.Товары.ТекущаяСтрока = Параметр;
	КонецЕсли;
	
	ОбщегоНазначенияСобытияФормИСКлиентПереопределяемый.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаЗаписиНового(НовыйОбъект, Источник, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ТекущаяСтрока", ТекущиеДанные.ПолучитьИдентификатор());
		
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ОбработкаВыбораНоменклатурыЗавершение",
		ЭтотОбъект,
		ДополнительныеПараметры);
	
	СобытияФормВЕТИСКлиентПереопределяемый.ОбработкаВыбораНоменклатуры(ОписаниеОповещения, НовыйОбъект, Источник);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПриСозданииЧтенииНаСервере();
	
	ОбщегоНазначенияСобытияФормИСПереопределяемый.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	ОбщегоНазначенияСобытияФормИСКлиентПереопределяемый.ПередЗаписью(ЭтотОбъект, Отказ, ПараметрыЗаписи);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ОбновитьЗаписатьПараметрыОбновленияСтатуса(Отказ, ТекущийОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ПриСозданииЧтенииНаСервере();
	
	РазблокироватьДанныеФормыДляРедактирования();
	
	ИнтеграцияИС.ПослеЗаписиНаСервереВФормеОбъектаДокументаИС(
		ЭтотОбъект,
		ТекущийОбъект,
		ИнтеграцияВЕТИСКлиентСервер.ИмяПодсистемы(),
		ПараметрыЗаписи);
	
	ОбщегоНазначенияСобытияФормИСПереопределяемый.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульПодключаемыеКомандыКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ПодключаемыеКомандыКлиент");
		МодульПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаНавигационнойСсылки(НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	ИнтеграцияВЕТИСКлиент.ОбработкаНавигационнойСсылки(НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка, Объект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СтатусВЕТИСОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ТекстВопроса         = "";
	
	ОчиститьСообщения();
	
	Если НЕ НажатиеНавигационнойСсылкиТребуетЗаписиДокумента(НавигационнаяСсылкаФорматированнойСтроки) Тогда
	ИначеЕсли Не ЗначениеЗаполнено(Объект.Ссылка) Или НЕ Объект.Проведен Тогда
		ТекстВопроса = НСтр("ru = 'Документ не проведен. Провести?';
							|en = 'Документ не проведен. Провести?'");
	ИначеЕсли Модифицированность Тогда
		ТекстВопроса = НСтр("ru = 'Документ был изменен. Провести?';
							|en = 'Документ был изменен. Провести?'");
	КонецЕсли;
	
	Если НЕ ПустаяСтрока(ТекстВопроса) Тогда
		ОписаниеОповещенияВопрос = Новый ОписаниеОповещения("СтатусВЕТИСОбработкаНавигационнойСсылкиЗавершение",
			ЭтотОбъект,
			Новый Структура("НавигационнаяСсылкаФорматированнойСтроки", НавигационнаяСсылкаФорматированнойСтроки));
		ПоказатьВопрос(ОписаниеОповещенияВопрос, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	Иначе
		ОбработатьНажатиеНавигационнойСсылки(НавигационнаяСсылкаФорматированнойСтроки);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ХозяйствующийСубъектПриИзменении(Элемент)
	
	ХозяйствующийСубъектПриИзмененииНаСервере(Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредприятиеПриИзменении(Элемент)
	
	ПредприятиеПриИзмененииНаСервере(Элемент.Имя);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТовары

&НаКлиенте
Процедура ТоварыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Поле = Элементы.ТоварыЗаписьСкладскогоЖурнала Тогда
		СтандартнаяОбработка = Ложь;
		ПоказатьЗначение(, ТекущиеДанные.ЗаписьСкладскогоЖурнала);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	ИнтеграцияИСКлиентПереопределяемый.ОбновитьКешированныеЗначенияДляУчетаСерий(Элемент,
		КэшированныеЗначения, ПараметрыУказанияСерий, Копирование);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	НеобходимоОбновитьСтатусыСерий = Ложь;
	
	Если ПараметрыУказанияСерий <> Неопределено Тогда
		НеобходимоОбновитьСтатусыСерий = 
			ИнтеграцияИСКлиент.НеобходимоОбновитьСтатусыСерий(
				ЭтотОбъект,
				Элемент,
				КэшированныеЗначения);
	КонецЕсли;
	
	Если НеобходимоОбновитьСтатусыСерий Тогда
		ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
		ТекущаяСтрокаИдентификатор = ТекущиеДанные.ПолучитьИдентификатор();
		
		ЗаполнитьСтатусыУказанияСерийПриОкончанииРедактированияСтрокиТЧ(
			ТекущаяСтрокаИдентификатор,
			КэшированныеЗначения);
		
		ИнтеграцияИСКлиентПереопределяемый.ОбновитьКешированныеЗначенияДляУчетаСерий(
			Элемент,
			КэшированныеЗначения,
			ПараметрыУказанияСерий);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыПриАктивизацииЯчейки(Элемент)
	
	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Элемент.ТекущийЭлемент = Элементы.ТоварыНоменклатура Тогда
		
		ЗаполнитьСпискиВыбораНоменклатуры(ТекущиеДанные);
		
	КонецЕсли;
	
	Если Элемент.ТекущийЭлемент = Элементы.ТоварыХарактеристика Тогда
		
		ЗаполнитьСпискиВыбораХарактеристика(ТекущиеДанные);
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ТоварыНоменклатураПриИзменении(Элемент)
	
	НоменклатураПриИзменении();
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыНоменклатураНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	
	ПараметрыНоменклатуры = ИнтеграцияВЕТИСВызовСервера.ПараметрыСозданияНоменклатуры(
		ТекущиеДанные.Продукция,
		ТекущиеДанные.ЕдиницаИзмеренияВЕТИС);
	
	СобытияФормВЕТИСКлиентПереопределяемый.ОткрытьФормуВыбораНоменклатуры(ЭтотОбъект, ПараметрыНоменклатуры);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыНоменклатураСоздание(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	
	ПараметрыНоменклатуры = ИнтеграцияВЕТИСВызовСервера.ПараметрыСозданияНоменклатуры(
		ТекущиеДанные.Продукция,
		ТекущиеДанные.ЕдиницаИзмеренияВЕТИС);
	
	СобытияФормВЕТИСКлиентПереопределяемый.ОткрытьФормуСозданияНоменклатуры(ЭтотОбъект, ПараметрыНоменклатуры,
		ТекущиеДанные.ЕдиницаИзмеренияВЕТИС);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыХарактеристикаПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	
	ПараметрыЗаполнения = ИнтеграцияВЕТИСКлиентСервер.ПараметрыЗаполненияТабличнойЧасти();
	
	СобытияФормВЕТИСКлиентПереопределяемый.ПриИзмененииХарактеристики(ЭтотОбъект, ТекущиеДанные, КэшированныеЗначения,
		ПараметрыЗаполнения);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыХарактеристикаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	
	СобытияФормВЕТИСКлиентПереопределяемый.НачалоВыбораХарактеристики(ЭтотОбъект, ТекущаяСтрока, Элемент, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыХарактеристикаСоздание(Элемент, СтандартнаяОбработка)
	
	СобытияФормВЕТИСКлиентПереопределяемый.ХарактеристикаСоздание(ЭтотОбъект, Элементы.Товары.ТекущиеДанные, Элемент, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыСерияПриИзменении(Элемент)
	
	Если ПараметрыУказанияСерий <> Неопределено Тогда
		СобытияФормВЕТИСКлиентПереопределяемый.ПриИзмененииСерии(ЭтотОбъект,
																ПараметрыУказанияСерий,
																Элементы.Товары.ТекущиеДанные);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыСерияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОткрытьПодборСерий(Элемент.ТекстРедактирования, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыКоличествоПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	
	ПараметрыЗаполнения = ИнтеграцияВЕТИСКлиентСервер.ПараметрыЗаполненияТабличнойЧасти();
	ПараметрыЗаполнения.ЕдиницаИзмеренияВЕТИС = ТекущиеДанные.ЕдиницаИзмеренияВЕТИС;
	
	ВведенноеЗначение = ТекущиеДанные.Количество;
	
	ПараметрыЗаполнения.ПересчитатьКоличествоЕдиницПоВЕТИС = Истина;
	
	СобытияФормВЕТИСКлиентПереопределяемый.ПриИзмененииКоличестваВЕТИС(ЭтотОбъект, ТекущиеДанные,
		КэшированныеЗначения, ПараметрыЗаполнения);
		
	Если НЕ ВведенноеЗначение = ТекущиеДанные.Количество Тогда
		ТекстСообщения = НСтр( "ru = 'Документ был передан в информационную систему ВетИС.
			|Количество номенклатуры должно соответствовать количеству ВетИС с учетом коэффициентов пересчета.';
			|en = 'Документ был передан в информационную систему ВетИС.
			|Количество номенклатуры должно соответствовать количеству ВетИС с учетом коэффициентов пересчета.'");
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

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
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда) Экспорт
	
	СобытияФормИСКлиентПереопределяемый.ВыполнитьПереопределяемуюКоманду(ЭтотОбъект, Команда);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьДокумент(Команда)
	
	ОценкаПроизводительностиКлиент.ЗамерВремени("Документ.ЗапросСкладскогоЖурналаВЕТИС.Форма.ФормаДокумента.Записать");
	
	ОчиститьСообщения();
	Записать();
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиДокумент(Команда)
	
	ОценкаПроизводительностиКлиент.ЗамерВремени("Документ.ЗапросСкладскогоЖурналаВЕТИС.Форма.ФормаДокумента.Провести");
	
	ОчиститьСообщения();
	ПараметрыЗаписи = Новый Структура("РежимЗаписи", РежимЗаписиДокумента.Проведение);
	Записать(ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиИЗакрыть(Команда)
	
	ОценкаПроизводительностиКлиент.ЗамерВремени("Документ.ЗапросСкладскогоЖурналаВЕТИС.Форма.ФормаДокумента.ПровестиИЗакрыть");
	
	ОчиститьСообщения();
	ПараметрыЗаписи = Новый Структура("РежимЗаписи", РежимЗаписиДокумента.Проведение);
	
	Если Записать(ПараметрыЗаписи) Тогда
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура АрхивироватьДокумент(Команда)
	
	ОбщегоНазначенияИСКлиент.АрхивироватьДокументы(ЭтотОбъект, Объект.Ссылка, ИнтеграцияВЕТИСКлиент);
	
КонецПроцедуры

&НаКлиенте
Процедура СопоставитьНоменклатуру(Команда)
	
	ОповещениеОЗавершении = Новый ОписаниеОповещения("ПриЗавершенииСопоставленияНоменклатурыСтрок", ЭтотОбъект);
	ИнтеграцияИСКлиент.ОткрытьФормуУказанияНоменклатуры(
		ЭтотОбъект, ОповещениеОЗавершении, ИнтеграцияИСКлиентСервер.ВидыПродукцииПодконтрольныеВЕТИС());
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	СобытияФормИСПереопределяемый.УстановитьУсловноеОформлениеХарактеристикНоменклатуры(ЭтотОбъект);
	СобытияФормИСПереопределяемый.УстановитьУсловноеОформлениеСерийНоменклатуры(ЭтотОбъект);
	
	СобытияФормИС.УстановитьУсловноеОформлениеПоляНоменклатура(ЭтотОбъект,,, Ложь);
	СобытияФормИС.УстановитьУсловноеОформлениеПоляХарактеристика(ЭтотОбъект,,, Ложь);
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииЧтенииНаСервере()
	
	ИнтеграцияВЕТИС.УстановитьДоступностьПоляСтатус(ЭтотОбъект);
	
	ПараметрыОбновленияСтатуса = Неопределено;
	
	ОбновитьСтатусВЕТИС();
	
	УстановитьПараметрыВыбораХозяйствующегоСубъекта();
	
	ЗаполнитьСлужебныеРеквизиты();
	
	НастроитьЗависимыеЭлементыФормы(ЭтотОбъект);
	
	ПодготовитьЗаполнитьУстановитьВидимостьСерий();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСлужебныеРеквизиты()
	
	ИнтеграцияИСПереопределяемый.ЗаполнитьСлужебныеРеквизитыВКоллекции(ЭтотОбъект, Объект.Товары);
	
	ЗаполнитьСопоставленныеТовары();
	ЗаполнитьКолонкуПроизводитель();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСопоставленныеТовары()
	
	//Заполнение предсавления сопоставления для всех строк
	СопоставленныеТовары = ИнтеграцияВЕТИС.ПолучитьСопоставленныеТовары(Объект.Товары, НоменклатураДляВыбора);
	
	Для каждого СтрокаСопоставление Из СопоставленныеТовары Цикл
		
		СтрокаТЧ = Объект.Товары.Получить(СтрокаСопоставление.НомерСтрокиТовара - 1);
		
		Если СтрокаСопоставление.Количество > 1 Тогда
			СтрокаТЧ.СопоставлениеНоменклатура   = СтрШаблон(НСтр("ru = '<Сопоставлено (%1)>';
																	|en = '<Сопоставлено (%1)>'"), СтрокаСопоставление.Количество);
			СтрокаТЧ.СопоставлениеХарактеристика = НСтр("ru = '<Не сопоставлено>';
														|en = '<Не сопоставлено>'");
		ИначеЕсли СтрокаСопоставление.Количество = 1 Тогда
			СтрокаТЧ.СопоставлениеНоменклатура = СтрокаСопоставление.Номенклатура;
			СтрокаТЧ.СопоставлениеХарактеристика = СтрокаСопоставление.Характеристика;
		ИначеЕсли СтрокаСопоставление.Количество = 0 Тогда
			СтрокаТЧ.СопоставлениеНоменклатура   = НСтр("ru = '<Не сопоставлено>';
														|en = '<Не сопоставлено>'");
			СтрокаТЧ.СопоставлениеХарактеристика = НСтр("ru = '<Не сопоставлено>';
														|en = '<Не сопоставлено>'");
		КонецЕсли;
		
	КонецЦикла;
	
	//Заполнение только явно сопоставленных по записи журнала строк
	ИмяКолонки = "ЗаписьСкладскогоЖурнала";
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ЗаписиЖурнала", Объект.Товары.Выгрузить(, ИмяКолонки).ВыгрузитьКолонку(ИмяКолонки));
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	Соответствие.Номенклатура КАК Номенклатура,
	|	Соответствие.Характеристика КАК Характеристика,
	|	Соответствие.Серия КАК Серия,
	|	Соответствие.ЗаписьСкладскогоЖурнала КАК ЗаписьСкладскогоЖурнала
	|ИЗ
	|	РегистрСведений.СоответствиеНоменклатурыВЕТИС КАК Соответствие
	|ГДЕ
	|	Соответствие.ЗаписьСкладскогоЖурнала В (&ЗаписиЖурнала)";
	ЗаписанныеСоответствия = Запрос.Выполнить().Выгрузить();
	ЗаписанныеСоответствия.Индексы.Добавить("ЗаписьСкладскогоЖурнала");
	Для Каждого СтрокаТЧ Из Объект.Товары Цикл
		
		Если ЗначениеЗаполнено(СтрокаТЧ.Номенклатура) Тогда
			Продолжить;
		КонецЕсли;
		СопоставленныеПозиции = ЗаписанныеСоответствия.НайтиСтроки(Новый Структура(ИмяКолонки, СтрокаТЧ[ИмяКолонки]));
		Если СопоставленныеПозиции.Количество() = 1 Тогда
			ЗаполнитьЗначенияСвойств(СтрокаТЧ, СопоставленныеПозиции[0]);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьКолонкуПроизводитель()
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	Производители.Ссылка КАК Ссылка,
	|	ПРЕДСТАВЛЕНИЕ(Производители.Производитель) КАК Производитель
	|ИЗ
	|	Справочник.ЗаписиСкладскогоЖурналаВЕТИС.Производители КАК Производители
	|ГДЕ
	|	Производители.Ссылка В (&Ссылка)
	|ИТОГИ ПО
	|	Ссылка";
	Запрос.УстановитьПараметр("Ссылка", Объект.Товары.Выгрузить().ВыгрузитьКолонку("ЗаписьСкладскогоЖурнала"));
	Выборка = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока Выборка.Следующий() Цикл
		ПроизводителиЗаписи = Новый Массив;
		ДетальныеЗаписи = Выборка.Выбрать();
		Пока ДетальныеЗаписи.Следующий() Цикл
			ПроизводителиЗаписи.Добавить(ДетальныеЗаписи.Производитель);
		КонецЦикла;
		Объект.Товары.НайтиСтроки(Новый Структура("ЗаписьСкладскогоЖурнала", Выборка.Ссылка))[0].Производитель = СтрСоединить(ПроизводителиЗаписи, "; ");
	КонецЦикла;
	
КонецПроцедуры


&НаСервере
Процедура ХозяйствующийСубъектПриИзмененииНаСервере(ИмяЭлемента)
	
	НастроитьЗависимыеЭлементыФормы(ЭтотОбъект, ИмяЭлемента);
	ПодготовитьЗаполнитьУстановитьВидимостьСерий();
	
КонецПроцедуры

&НаСервере
Процедура ПредприятиеПриИзмененииНаСервере(ИмяЭлемента)
	
	НастроитьЗависимыеЭлементыФормы(ЭтотОбъект, ИмяЭлемента);
	ПодготовитьЗаполнитьУстановитьВидимостьСерий();
	
КонецПроцедуры

//@skip-warning
&НаКлиенте
Процедура Подключаемый_ВыполнитьОбменОбработкаОжидания()
	
	ИнтеграцияВЕТИСКлиент.ПродолжитьВыполнениеОбмена(ЭтотОбъект, Объект.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьСпискиВыбораНоменклатуры(ТекущаяСтрока)
	
	СписокВыбораНоменклатура = Элементы.ТоварыНоменклатура.СписокВыбора;
	СписокВыбораНоменклатура.Очистить();
	
	НайденныеСтроки = НоменклатураДляВыбора.НайтиСтроки(Новый Структура("Продукция", ТекущаяСтрока.Продукция));
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
	
	СписокВыбораХарактеристика = Элементы.ТоварыХарактеристика.СписокВыбора;
	СписокВыбораХарактеристика.Очистить();
	
	НайденныеСтроки = НоменклатураДляВыбора.НайтиСтроки(Новый Структура("Продукция, Номенклатура",
		ТекущаяСтрока.Продукция,
		ТекущаяСтрока.Номенклатура));
	Для Каждого СтрокаТЧ Из НайденныеСтроки Цикл
		СписокВыбораХарактеристика.Добавить(СтрокаТЧ.Характеристика);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбораНоменклатурыЗавершение(Номенклатура, ДополнительныеПараметры) Экспорт
	
	Если Номенклатура = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СтрокаТабличнойЧасти = Объект.Товары.НайтиПоИдентификатору(ДополнительныеПараметры.ТекущаяСтрока);
	
	СтрокаТабличнойЧасти.Номенклатура = Номенклатура;
	
	НоменклатураПриИзменении();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьПараметрыВыбораХозяйствующегоСубъекта()

	ИспользуетсяКомиссияИлиПереработка = ИнтеграцияВЕТИС.ИспользуетсяКомиссияПриЗакупкахИлиПереработкаДавальческогоСырья();
	
	МассивПараметровВыбора = Новый Массив;
	МассивПараметровВыбора.Добавить(Новый ПараметрВыбора("НастроеноПодключение", Истина));
	
	Если Не ИспользуетсяКомиссияИлиПереработка Тогда
		МассивПараметровВыбора.Добавить(Новый ПараметрВыбора("Соответствует", "Организации"));
	КонецЕсли;
	
	Элементы.ХозяйствующийСубъект.ПараметрыВыбора = Новый ФиксированныйМассив(МассивПараметровВыбора);

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура НастроитьЗависимыеЭлементыФормы(Форма, СписокРеквизитов = "")
	
	Элементы = Форма.Элементы;
	Объект   = Форма.Объект;
	
	Инициализация = ПустаяСтрока(СписокРеквизитов);
	СтруктураРеквизитов = Новый Структура(СписокРеквизитов);
	
	Если СтруктураРеквизитов.Свойство("ХозяйствующийСубъект")
		ИЛИ СтруктураРеквизитов.Свойство("Предприятие")
		ИЛИ Инициализация Тогда
		
		ПредставленияСопоставлений = ИнтеграцияВЕТИСВызовСервера.ПредставленияСопоставлений(
			Объект.ХозяйствующийСубъект, Объект.Предприятие);
		
		Форма.НадписьХозяйствующийСубъект = ПредставленияСопоставлений.КонтрагентХозяйствующегоСубъекта.Представление;
		Форма.ХозяйствующийСубъектСоответствие = ПредставленияСопоставлений.КонтрагентХозяйствующегоСубъекта.Ссылка;
		
		Форма.НадписьПредприятие = ПредставленияСопоставлений.ТорговыйОбъект.Представление;
		Форма.ПредприятиеСоответствие = ПредставленияСопоставлений.ТорговыйОбъект.Ссылка;
		
		СопоставленныйОбъект = ПредставленияСопоставлений.ТорговыйОбъект.Ссылка;
		Если СопоставленныйОбъект <> Неопределено И СопоставленныйОбъект.Количество() > 0 Тогда
			Объект.ТорговыйОбъект = СопоставленныйОбъект.Получить(0).Значение;
		Иначе
			Объект.ТорговыйОбъект = Неопределено;
		КонецЕсли;
		
		Элементы.Предприятие.Доступность = ЗначениеЗаполнено(Объект.ХозяйствующийСубъект);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция НажатиеНавигационнойСсылкиТребуетЗаписиДокумента(НавигационнаяСсылкаФорматированнойСтроки)
	
	ТребуетсяЗаписьДокумента = Истина;
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "ПоказатьПричинуОшибки" Тогда
		ТребуетсяЗаписьДокумента = Ложь;
	КонецЕсли;
	
	Возврат ТребуетсяЗаписьДокумента;
	
КонецФункции

&НаКлиенте
Процедура ПриЗавершенииСопоставленияНоменклатурыСтрок(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Модифицированность = Истина;
	ДанныеВыбора = Результат.ДанныеВыбора;
	
	Для Каждого СтрокаСписка Из Элементы.Товары.ВыделенныеСтроки Цикл
		ДанныеСтроки = Элементы.Товары.ДанныеСтроки(СтрокаСписка);
		ДанныеСтроки.Номенклатура = ДанныеВыбора.Номенклатура;
		ДанныеСтроки.Характеристика = ДанныеВыбора.Характеристика;
		ДанныеСтроки.Серия = ДанныеВыбора.Серия;
		
		ПараметрыЗаполнения = ИнтеграцияВЕТИСКлиентСервер.ПараметрыЗаполненияТабличнойЧасти();
		ПараметрыЗаполнения.ЕдиницаИзмеренияВЕТИС              = ДанныеСтроки.ЕдиницаИзмеренияВЕТИС;
		ПараметрыЗаполнения.ПересчитатьКоличествоЕдиницПоВЕТИС = Истина;
		ПараметрыЗаполнения.ПроверитьСериюРассчитатьСтатус     = ПараметрыУказанияСерий <> Неопределено;
	
		СобытияФормВЕТИСКлиентПереопределяемый.ПриИзмененииНоменклатуры(ЭтотОбъект, ДанныеСтроки, КэшированныеЗначения,
			ПараметрыЗаполнения, ПараметрыУказанияСерий);
		ДанныеСтроки.Серия = ДанныеВыбора.Серия;
		
	КонецЦикла;
	
КонецПроцедуры

#Область Статус

&НаСервере
Процедура ОбновитьЗаписатьПараметрыОбновленияСтатуса(Отказ, ТекущийОбъект)
	
	Если ПараметрыОбновленияСтатуса = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	РегистрыСведений.СтатусыДокументовВЕТИС.ОбновитьСтатус(
		ТекущийОбъект.Ссылка,
		ПараметрыОбновленияСтатуса);
	
	ПараметрыОбновленияСтатуса = Неопределено;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСтатусВЕТИС()
	
	МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоСсылке(Объект.Ссылка);
	
	СтатусВЕТИС                = МенеджерОбъекта.СтатусПоУмолчанию();
	ОперацииДопустимыхДействий = МенеджерОбъекта.ОперацииДопустимыхДействий();
	
	ДальнейшееДействие = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(МенеджерОбъекта.ДальнейшееДействиеПоУмолчанию());
	
	Если ЗначениеЗаполнено(Объект.Ссылка) И ПараметрыОбновленияСтатуса = Неопределено Тогда
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	Статусы.Статус КАК Статус,
		|	ВЫБОР
		|		КОГДА Статусы.ДальнейшееДействие1 В (&МассивДальнейшиеДействия)
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ДальнейшиеДействияПоВзаимодействиюВЕТИС.НеТребуется)
		|		ИНАЧЕ Статусы.ДальнейшееДействие1
		|	КОНЕЦ КАК ДальнейшееДействие1,
		|	ВЫБОР
		|		КОГДА Статусы.ДальнейшееДействие2 В (&МассивДальнейшиеДействия)
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ДальнейшиеДействияПоВзаимодействиюВЕТИС.НеТребуется)
		|		ИНАЧЕ Статусы.ДальнейшееДействие2
		|	КОНЕЦ КАК ДальнейшееДействие2,
		|	ВЫБОР
		|		КОГДА Статусы.ДальнейшееДействие3 В (&МассивДальнейшиеДействия)
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ДальнейшиеДействияПоВзаимодействиюВЕТИС.НеТребуется)
		|		ИНАЧЕ Статусы.ДальнейшееДействие3
		|	КОНЕЦ КАК ДальнейшееДействие3
		|ИЗ
		|	РегистрСведений.СтатусыДокументовВЕТИС КАК Статусы
		|ГДЕ
		|	Статусы.Документ = &Документ");
		
		Запрос.УстановитьПараметр("Документ", Объект.Ссылка);
		Запрос.УстановитьПараметр("МассивДальнейшиеДействия", ИнтеграцияВЕТИС.НеотображаемыеВДокументахДальнейшиеДействия());
		
		Выборка = Запрос.Выполнить().Выбрать();
		
		Если Выборка.Следующий() Тогда
			
			СтатусВЕТИС = Выборка.Статус;
			
			ДальнейшееДействие = Новый Массив;
			ДальнейшееДействие.Добавить(Выборка.ДальнейшееДействие1);
			ДальнейшееДействие.Добавить(Выборка.ДальнейшееДействие2);
			ДальнейшееДействие.Добавить(Выборка.ДальнейшееДействие3);
			
		КонецЕсли;
		
	ИначеЕсли ПараметрыОбновленияСтатуса <> Неопределено Тогда
		
		СтатусВЕТИС = ПараметрыОбновленияСтатуса.НовыйСтатус;
		
		ДальнейшееДействие = Новый Массив;
		ДальнейшееДействие.Добавить(ПараметрыОбновленияСтатуса.ДальнейшееДействие1);
		ДальнейшееДействие.Добавить(ПараметрыОбновленияСтатуса.ДальнейшееДействие2);
		ДальнейшееДействие.Добавить(ПараметрыОбновленияСтатуса.ДальнейшееДействие3);
		
	КонецЕсли;
	
	ДопустимыеДействия = Новый Массив;
	ДопустимыеДействия.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюВЕТИС.ПередайтеДанные);
	ДопустимыеДействия.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюВЕТИС.ОтменитеОперацию);
	ДопустимыеДействия.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюВЕТИС.ОтменитеПередачуДанных);
	
	НедоступныеДействия = ПользователиВЕТИС.НедоступныеДальнейшиеДействия(Объект.Ссылка, ДопустимыеДействия, ОперацииДопустимыхДействий, Объект.ХозяйствующийСубъект);
	
	СтатусВЕТИСПредставление = ИнтеграцияВЕТИС.ПредставлениеСтатусаВЕТИС(
		СтатусВЕТИС,
		ДальнейшееДействие,
		ДопустимыеДействия,
		НедоступныеДействия);
	
	РедактированиеФормыНеДоступно = СтатусВЕТИС <> Перечисления.СтатусыОбработкиЗапросовСкладскогоЖурналаВЕТИС.Черновик
	                              И СтатусВЕТИС <> Перечисления.СтатусыОбработкиЗапросовСкладскогоЖурналаВЕТИС.ОшибкаПередачи;
	
	Элементы.ГруппаНередактируемыеПослеОтправкиРеквизитыОсновное.ТолькоПросмотр = РедактированиеФормыНеДоступно;
	
	#Область ОшибкиВетИС
	
	Для Каждого СтрокаТоваров Из Объект.Товары Цикл
		СтрокаТоваров.ЕстьОшибки = -1;
		СтрокаТоваров.Ошибка     = "";
	КонецЦикла;
	
	ЕстьОшибкиПоСтрокам = Ложь;
	Если СтатусВЕТИС = Перечисления.СтатусыОбработкиЗапросовСкладскогоЖурналаВЕТИС.ОшибкаПередачи Тогда
		ТаблицаОшибок = ИнтеграцияВЕТИСВызовСервера.ОшибкиСервисаПоДокументу(Объект.Ссылка);
		Если ТаблицаОшибок <> Неопределено Тогда
			Для Каждого Ошибка Из ТаблицаОшибок Цикл
				СтрокиТоваровПоНомеру = Объект.Товары.НайтиСтроки(Новый Структура("НомерСтроки", Ошибка.НомерСтрокиСОшибкой));
				Для Каждого СтрокаТоваров Из СтрокиТоваровПоНомеру Цикл
					СтрокаТоваров.ЕстьОшибки = 0;
					СтрокаТоваров.Ошибка     = Ошибка.КодОшибки+": "+Ошибка.ОписаниеОшибки;
					ЕстьОшибкиПоСтрокам = Истина;
				КонецЦикла;
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	
	Элементы.ТоварыОшибка.Видимость = ЕстьОшибкиПоСтрокам;
	
	#КонецОбласти
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьНажатиеНавигационнойСсылки(НавигационнаяСсылкаФорматированнойСтроки)
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "ПередатьДанные" Тогда
		
		ПараметрыПередачи = ИнтеграцияВЕТИСКлиентСервер.СтруктураПараметрыПередачи();
		ПараметрыПередачи.ДальнейшееДействие = ПредопределенноеЗначение("Перечисление.ДальнейшиеДействияПоВзаимодействиюВЕТИС.ПередайтеДанные");
		
		ИнтеграцияВЕТИСКлиент.ПодготовитьКПередаче(ЭтотОбъект, ПараметрыПередачи);
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "ОтменитьОперацию" Тогда
		
		ИнтеграцияВЕТИСКлиент.ОтменитьПоследнююОперацию(Объект.Ссылка);
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "ОтменитьПередачу" Тогда
		
		ИнтеграцияВЕТИСКлиент.ОтменитьПередачу(Объект.Ссылка);
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "ПоказатьПричинуОшибки" Тогда
		
		ПараметрыОткрытияФормы = Новый Структура;
		ПараметрыОткрытияФормы.Вставить("Документ", Объект.Ссылка);
		
		ОткрытьФорму(
			"Справочник.ВЕТИСПрисоединенныеФайлы.Форма.ФормаОшибки",
			ПараметрыОткрытияФормы,
			ЭтотОбъект);
		
	ИначеЕсли СтрНачинаетсяС(НавигационнаяСсылкаФорматированнойСтроки, "НетДоступа") Тогда
		
		УточнениеГиперссылки = СтрЗаменить(НавигационнаяСсылкаФорматированнойСтроки,"НетДоступа","");
		ИнтеграцияВЕТИСКлиент.ПредупредитьОбОтсутствииДоступа(УточнениеГиперссылки);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СтатусВЕТИСОбработкаНавигационнойСсылкиЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
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

#КонецОбласти

#Область Серии

&НаКлиенте
Процедура ОткрытьПодборСерий(Текст, СтандартнаяОбработка)
	
	Если ПараметрыУказанияСерий <> Неопределено Тогда
		
		ИнтеграцияИСКлиент.ОткрытьПодборСерий(ЭтотОбъект,, Текст, СтандартнаяОбработка)
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПодготовитьЗаполнитьУстановитьВидимостьСерий()
	
	ПараметрыУказанияСерий = ИнтеграцияИС.ПараметрыУказанияСерийФормыОбъекта(
		Объект, Документы.ЗапросСкладскогоЖурналаВЕТИС);
	
	ЗаполнитьСтатусыУказанияСерийСервер();
	УстановитьВидимостьЭлементовСерий();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСтатусыУказанияСерийСервер()
	
	Если ПараметрыУказанияСерий <> Неопределено Тогда
		ИнтеграцияИСПереопределяемый.ЗаполнитьСтатусыУказанияСерий(Объект, ПараметрыУказанияСерий);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьЭлементовСерий()
	
	Если ПараметрыУказанияСерий <> Неопределено Тогда
		ИспользоватьСерииНоменклатуры = ПараметрыУказанияСерий.ИспользоватьСерииНоменклатуры;
	Иначе
		ИспользоватьСерииНоменклатуры = Ложь;
	КонецЕсли;
	
	Элементы.ТоварыСерия.Видимость = ИспользоватьСерииНоменклатуры;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСтатусыУказанияСерийПриОкончанииРедактированияСтрокиТЧ(ТекущаяСтрокаИдентификатор,
																		КэшированныеЗначения)
	
	ИнтеграцияИСПереопределяемый.ЗаполнитьСтатусыУказанияСерийПриОкончанииРедактированияСтрокиТЧ(
		ЭтотОбъект,,
		ТекущаяСтрокаИдентификатор,
		КэшированныеЗначения);
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаКлиенте
Процедура НоменклатураПриИзменении(ТекущиеДанные = Неопределено)
	
	ОчиститьСообщения();
	
	Если ТекущиеДанные = Неопределено Тогда
		ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	КонецЕсли;
	
	ПараметрыЗаполнения = ИнтеграцияВЕТИСКлиентСервер.ПараметрыЗаполненияТабличнойЧасти();
	ПараметрыЗаполнения.ЕдиницаИзмеренияВЕТИС              = ТекущиеДанные.ЕдиницаИзмеренияВЕТИС;
	ПараметрыЗаполнения.ПересчитатьКоличествоЕдиницПоВЕТИС = Истина;
	ПараметрыЗаполнения.ПроверитьСериюРассчитатьСтатус     = ПараметрыУказанияСерий <> Неопределено;
	
	СобытияФормВЕТИСКлиентПереопределяемый.ПриИзмененииНоменклатуры(ЭтотОбъект, ТекущиеДанные, КэшированныеЗначения,
		ПараметрыЗаполнения, ПараметрыУказанияСерий);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьПредставленияНаФорме(Прочитать = Ложь)
	
	Если Прочитать Тогда
		Прочитать();
	Иначе
		ОбновитьСтатусВЕТИС();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
