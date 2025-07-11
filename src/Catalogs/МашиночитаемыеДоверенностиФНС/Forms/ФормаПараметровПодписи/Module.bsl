
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.ОрганизацияИлиСсылкаНаОбъект)
		И ТипЗнч(Параметры.ОрганизацияИлиСсылкаНаОбъект) <> Тип("СправочникСсылка.Организации") Тогда
		
		Организация = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Параметры.ОрганизацияИлиСсылкаНаОбъект, "Организация");
	Иначе
		Организация = Параметры.ОрганизацияИлиСсылкаНаОбъект;
	КонецЕсли;
	МестоХраненияКлюча = КриптографияЭДКОКлиентСервер.КонтекстМоделиХраненияКлюча(Организация);
	
	КлючСохраненияПоложенияОкна = ?(КриптографияЭДКОКлиентСервер.ЭтоЛокальнаяПодпись(МестоХраненияКлюча),
		"", "ВМоделиСервиса");
	
	Элементы.ПарольДоступаКЗакрытомуКлючу.Видимость =
		КриптографияЭДКОКлиентСервер.ЭтоЛокальнаяПодпись(МестоХраненияКлюча);
	
	ОтпечаткиСертификатовАбонентов =
		ХранилищеОбщихНастроек.Загрузить("ДокументооборотСКонтролирующимиОрганами_МЧДФНСОтпечаткиСертификатов");
	ОтпечатокСертификатаАбонента = ?(ЗначениеЗаполнено(ОтпечаткиСертификатовАбонентов),
		ОтпечаткиСертификатовАбонентов[Организация], "");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	КриптографияЭДКОКлиент.ОтобразитьПредставлениеСертификата(
		МестоХраненияКлюча,
		Элементы.СертификатАбонентаПредставление,
		ОтпечатокСертификатаАбонента,
		ЭтотОбъект,
		"СертификатАбонентаПредставление");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СертификатАбонентаПредставлениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения(
		"СертификатАбонентаПредставлениеНачалоВыбораЗавершение", ЭтотОбъект, Новый Структура("Элемент", Элемент));
	
	КриптографияЭДКОКлиент.ВыбратьСертификат(
		Оповещение, МестоХраненияКлюча, ОтпечатокСертификатаАбонента, "My");
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатАбонентаПредставлениеОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ОтпечатокСертификатаАбонента = "";
	СертификатАбонентаПредставление = "";
	
	КриптографияЭДКОКлиент.ОтобразитьПредставлениеСертификата(
		МестоХраненияКлюча,
		Элемент,
		ОтпечатокСертификатаАбонента,
		ЭтотОбъект,
		"СертификатАбонентаПредставление");
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатАбонентаПредставлениеОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	СертификатАбонента = Новый Структура("Отпечаток", ОтпечатокСертификатаАбонента);
	КриптографияЭДКОКлиентСервер.КонтекстМоделиХраненияКлюча(МестоХраненияКлюча, СертификатАбонента);
	КриптографияЭДКОКлиент.ПоказатьСертификат(СертификатАбонента);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подписать(Команда)
	
	Если НЕ СохранениеВозможно() Тогда
		Возврат;
	КонецЕсли;
	
	СохранитьПараметрыОтправки();
	
	СтруктураДанных = Новый Структура;
	СтруктураДанных.Вставить("МестоХраненияКлюча", 						МестоХраненияКлюча);
	СтруктураДанных.Вставить("ОтпечатокСертификатаАбонента", 			ОтпечатокСертификатаАбонента);
	СтруктураДанных.Вставить("ПарольДоступаКЗакрытомуКлючу", 			ПарольДоступаКЗакрытомуКлючу);
	
	Закрыть(СтруктураДанных);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Функция СохранениеВозможно()
	
	Отказ = Ложь;
	
	ОчиститьСообщения();
	
	Если НЕ ЗначениеЗаполнено(ОтпечатокСертификатаАбонента) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Не выбран сертификат для подписания';
														|en = 'Не выбран сертификат для подписания'"),,
			"СертификатАбонентаПредставление",, Отказ);
	КонецЕсли;
	
	Возврат НЕ Отказ;
	
КонецФункции

&НаКлиенте
Процедура СертификатАбонентаПредставлениеНачалоВыбораЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Элемент = ДополнительныеПараметры.Элемент;
	
	Если Результат.Выполнено Тогда
		ОтпечатокСертификатаАбонента = Результат.ВыбранноеЗначение.Отпечаток;
		
		КриптографияЭДКОКлиент.ОтобразитьПредставлениеСертификата(
			МестоХраненияКлюча,
			Элемент,
			Результат.ВыбранноеЗначение.Отпечаток,
			ЭтотОбъект,
			"СертификатАбонентаПредставление");
		
		Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СохранитьПараметрыОтправки()
	
	ОтпечаткиСертификатовАбонентов =
		ХранилищеОбщихНастроек.Загрузить("ДокументооборотСКонтролирующимиОрганами_МЧДФНСОтпечаткиСертификатов");
	Если ОтпечаткиСертификатовАбонентов = Неопределено Тогда
		ОтпечаткиСертификатовАбонентов = Новый Соответствие;
	КонецЕсли;
	ОтпечаткиСертификатовАбонентов[Организация] = ОтпечатокСертификатаАбонента;
	ХранилищеОбщихНастроек.Сохранить("ДокументооборотСКонтролирующимиОрганами_МЧДФНСОтпечаткиСертификатов",,
		ОтпечаткиСертификатовАбонентов);
	
КонецПроцедуры

#КонецОбласти
