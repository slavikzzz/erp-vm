
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураПараметров = РегистрацииВНалоговомОрганеКлиентСервер.НовыйСтруктураПараметровФормыВыбораРегистрации();
	ЗаполнитьЗначенияСвойств(СтруктураПараметров, Параметры);
	
	Период                = НачалоМесяца(ТекущаяДатаСеанса());
	Организация           = СтруктураПараметров.Организация;
	СписокПодразделений   = СтруктураПараметров.СписокПодразделений;
	
	НастроитьВидимостьЭлементов(ЭтаФорма, СтруктураПараметров);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	СтруктураВыбора = РегистрацииВНалоговомОрганеКлиентСервер.НовыйСтруктураВозвратаФормыВыбораРегистрации();
	СтруктураВыбора.МассивПодразделений = СписокПодразделений.ВыгрузитьЗначения();
	СтруктураВыбора.НалоговыйОрган      = НалоговыйОрган;
	СтруктураВыбора.Период              = Период;
	
	ОповеститьОВыборе(СтруктураВыбора);
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	Закрыть();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийШапкиФормы

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура НастроитьВидимостьЭлементов(Форма, ПараметрыОткрытияФормы = Неопределено)
	
	Если ЗначениеЗаполнено(ПараметрыОткрытияФормы) Тогда
	
		// При создании формы на сервере
		
		Если Форма.СписокПодразделений.Количество() = 1 Тогда
			ШаблонЗаголовка = НСтр("ru = 'Назначить налоговый орган (%1)';
									|en = 'Assign tax authority (%1)'");
			Форма.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				ШаблонЗаголовка,
				Форма.СписокПодразделений[0]);
		Иначе
			ШаблонЗаголовка = НСтр("ru = 'Назначить налоговый орган для %1 подразделений';
									|en = 'Assign tax authority for %1 business units'");
			Форма.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				ШаблонЗаголовка,
				Форма.СписокПодразделений.Количество());
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти