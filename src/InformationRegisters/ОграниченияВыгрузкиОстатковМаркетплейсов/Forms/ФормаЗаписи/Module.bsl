
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Элементы.ГруппаОграничениеОстатковДетали.Видимость = Запись.Используется;
	
	ЗаполнитьТипОбластиДействия();
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.УправлениеДоступом

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом

КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("ИзмененоОграничениеВыгрузкиОстатковМаркетплейсов");
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОбластьДействияПриИзменении(Элемент)
	
	ЗаполнитьТипОбластиДействия();
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользуетсяПриИзменении(Элемент)
	
	Элементы.ГруппаОграничениеОстатковДетали.Видимость = Запись.Используется;
	
	УстановитьПредставлениеЗаписи();
	
КонецПроцедуры

&НаКлиенте
Процедура ПроцентОстаткаПриИзменении(Элемент)
	
	УстановитьПредставлениеЗаписи();       
	
КонецПроцедуры

&НаКлиенте
Процедура СтраховойЗапасПриИзменении(Элемент)
	
	УстановитьПредставлениеЗаписи();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьПредставлениеЗаписи()
	
	РегистрыСведений.ОграниченияВыгрузкиОстатковМаркетплейсов.УстановитьПредставлениеЗаписи(Запись);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТипОбластиДействия()
	
	Если Не ЗначениеЗаполнено(Запись.ОбластьДействия) Тогда
		ТипОбластиДействия = "";
	ИначеЕсли ТипЗнч(Запись.ОбластьДействия) = Тип("СправочникСсылка.Номенклатура")
				И Не ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Запись.ОбластьДействия, "ЭтоГруппа") Тогда
		ТипОбластиДействия = "(" + НСтр("ru = 'Номенклатура';
										|en = 'Items'") + ")";
	ИначеЕсли ТипЗнч(Запись.ОбластьДействия) = Тип("СправочникСсылка.Номенклатура") Тогда
		ТипОбластиДействия = "(" + НСтр("ru = 'Группа номенклатуры';
										|en = 'Items group'") + ")";
	ИначеЕсли ТипЗнч(Запись.ОбластьДействия) = Тип("СправочникСсылка.ТоварныеКатегории") Тогда
		ТипОбластиДействия = "(" + НСтр("ru = 'Товарная категория';
										|en = 'Product category'") + ")";
	ИначеЕсли ТипЗнч(Запись.ОбластьДействия) = Тип("СправочникСсылка.ВидыНоменклатуры") Тогда
		ТипОбластиДействия = "(" + НСтр("ru = 'Вид номенклатуры';
										|en = 'Item kind'") + ")";
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
