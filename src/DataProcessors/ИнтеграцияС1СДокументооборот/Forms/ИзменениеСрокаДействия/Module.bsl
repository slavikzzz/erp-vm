#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.ТолькоПросмотр Тогда
		ТолькоПросмотр = Истина;
		Элементы.Отмена.Видимость = Ложь;
		Элементы.ИзменитьСрокДействия.Видимость = Ложь;
		Элементы.Закрыть.Видимость = Истина;
	КонецЕсли;
	
	Параметры.Свойство("Документ", Документ);
	Параметры.Свойство("ДокументID", ДокументID);
	Параметры.Свойство("ДокументТип", ДокументТип);
	Параметры.Свойство("ДатаНачалаДействия", ДатаНачалаДействия);
	Параметры.Свойство("ДатаОкончанияДействия", ДатаОкончанияДействия);
	Параметры.Свойство("ПорядокПродления", ПорядокПродления);
	Параметры.Свойство("ПорядокПродленияID", ПорядокПродленияID);
	Параметры.Свойство("ПорядокПродленияТип", ПорядокПродленияТип);
	Параметры.Свойство("Бессрочный", Бессрочный);
	
	Элементы.ДатаОкончанияДействия.Доступность = Не Бессрочный;
	Элементы.ПорядокПродления.Доступность = Не Бессрочный;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если Не Бессрочный Тогда
		Если Не ЗначениеЗаполнено(ПорядокПродления) Тогда
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(,, НСтр("ru = 'Порядок продления';
																						|en = 'Extension procedure'"));
			Сообщение.Поле = "ПорядокПродления";
			Сообщение.Сообщить();
		    Отказ = Истина;
		КонецЕсли;
		Если Не ЗначениеЗаполнено(ПорядокПродления) Тогда
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(,, НСтр("ru = 'Дата окончания действия';
																						|en = 'Expiration date'"));
			Сообщение.Поле = "ДатаОкончанияДействия";
			Сообщение.Сообщить();
		    Отказ = Истина;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры


#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура БессрочныйПриИзменении(Элемент)
	
	Если Бессрочный Тогда
		ДатаОкончанияДействия = '00010101';
		Элементы.ДатаОкончанияДействия.Доступность = Ложь;
		Элементы.ПорядокПродления.Доступность = Ложь;
		ПорядокПродления = "";
		ИнтеграцияС1СДокументооборотКлиент.ОчиститьСсылочныйРеквизит("ПорядокПродления", ЭтотОбъект);
	Иначе
		Элементы.ДатаОкончанияДействия.Доступность = Истина;
		Элементы.ПорядокПродления.Доступность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПорядокПродленияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыбратьЗначениеИзВыпадающегоСписка(
		"DMProlongationProcedure", "ПорядокПродления", ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПорядокПродленияОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		ИнтеграцияС1СДокументооборотБазоваяФункциональностьВызовСервера.ДанныеДляАвтоПодбора(
			"DMProlongationProcedure", ДанныеВыбора, Текст, СтандартнаяОбработка);
		
		Если ДанныеВыбора.Количество() = 1 Тогда
			ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ОбработкаВыбораДанныхДляАвтоПодбора(
				"ПорядокПродления", ДанныеВыбора[0].Значение, СтандартнаяОбработка, ЭтотОбъект);
			СтандартнаяОбработка = Истина;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПорядокПродленияАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		ИнтеграцияС1СДокументооборотБазоваяФункциональностьВызовСервера.ДанныеДляАвтоПодбора(
			"DMProlongationProcedure",
			ДанныеВыбора,
			Текст,
			СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПорядокПродленияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ОбработкаВыбораДанныхДляАвтоПодбора(
		"ПорядокПродления", ВыбранноеЗначение, СтандартнаяОбработка, ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ИзменитьСрокДействия(Команда)
	
	ОчиститьСообщения();
	Если Не ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыЗакрытия = Новый Структура;
	ПараметрыЗакрытия.Вставить("ДатаНачалаДействия", ДатаНачалаДействия);
	ПараметрыЗакрытия.Вставить("ДатаОкончанияДействия", ДатаОкончанияДействия);
	ПараметрыЗакрытия.Вставить("ПорядокПродления", ПорядокПродления);
	ПараметрыЗакрытия.Вставить("ПорядокПродленияID", ПорядокПродленияID);
	ПараметрыЗакрытия.Вставить("ПорядокПродленияТип", ПорядокПродленияТип);
	ПараметрыЗакрытия.Вставить("Бессрочный", Бессрочный);
	
	Закрыть(ПараметрыЗакрытия);
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

