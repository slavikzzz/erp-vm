
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПриСозданииЧтенииНаСервере();
	КонецЕсли;
	
	ПараметрыВыбораСтатейИАналитик = Документы.ИзменениеПараметровОС.ПараметрыВыбораСтатейИАналитик(Объект);
	ДоходыИРасходыСервер.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыВыбораСтатейИАналитик);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПриСозданииНаСервере(ЭтаФорма);
	
	СобытияФорм.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	ПриСозданииЧтенииНаСервере();
	
	ПараметрыВыбораСтатейИАналитик = Документы.ИзменениеПараметровОС.ПараметрыВыбораСтатейИАналитик(Объект);
	ДоходыИРасходыСервер.ПриЧтенииНаСервере(ЭтотОбъект, ПараметрыВыбораСтатейИАналитик);
	
	СобытияФорм.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	КоличествоСтрокОтраженияРасходов = ?(
		Объект.ОтражениеАмортизационныхРасходовФлаг,
		Объект.ОтражениеАмортизационныхРасходов.Количество(),
		0);
	
	ЗаполнитьТекущиеЗначенияРеквизитов(Истина);
	
	ДоходыИРасходыСервер.ПослеЗаписиНаСервере(ЭтотОбъект);
	
	СобытияФорм.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Запись_ИзменениеПараметровОС", ПараметрыЗаписи, Объект.Ссылка);

	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);

	ОбщегоНазначенияУТКлиент.ВыполнитьДействияПослеЗаписи(ЭтаФорма, Объект, ПараметрыЗаписи);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульПодключаемыеКомандыКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ПодключаемыеКомандыКлиент");
		МодульПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ИсточникВыбора.ИмяФормы = "Справочник.ОбъектыЭксплуатации.Форма.ФормаВыбора"
		ИЛИ ИсточникВыбора.ИмяФормы = "Справочник.ОбъектыЭксплуатации.Форма.ФормаВыбора2_4" Тогда
		
		Если ВыбранноеЗначение.Количество() > 0 Тогда
			Для Каждого ЭлементМассива Из ВыбранноеЗначение Цикл
				Объект.ОС.Добавить().ОсновноеСредство = ЭлементМассива;
			КонецЦикла;
			ПослеИзмененияСпискаОС();
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	СобытияФормКлиент.ПередЗаписью(ЭтотОбъект, Отказ, ПараметрыЗаписи);

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	СобытияФормКлиент.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ОрганизацияПриИзмененииСервер();
	
КонецПроцедуры

&НаСервере
Процедура ОрганизацияПриИзмененииСервер()
	
	Если Объект.ОС.Количество() > 0 Тогда
		ЗаполнитьТекущиеЗначенияРеквизитов();
	КонецЕсли;
	
	УстановитьДоступностьПередачиАмортизационныхРасходов();
	ВнеоборотныеАктивы.УстановитьПараметрыФункциональныхОпцийФормыОбъекта(ЭтаФорма, Объект.Организация, Объект.Дата);
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	
	Если (Объект.ОС.Количество() > 0)
		ИЛИ (ЗначениеЗаполнено(Объект.ДокументОснование)
			И ТипЗнч(Объект.ДокументОснование) = Тип("ДокументСсылка.ПринятиеКУчетуОС")) Тогда
		
		ДатаПриИзмененииНаСервере();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ДатаПриИзмененииНаСервере()
		
	Если Объект.ОС.Количество() > 0 Тогда
		ЗаполнитьТекущиеЗначенияРеквизитов();
	КонецЕсли;
	
	УстановитьВидимостьРеквизитовОтраженияРасходов();
	ВнеоборотныеАктивы.УстановитьПараметрыФункциональныхОпцийФормыОбъекта(ЭтаФорма, Объект.Организация, Объект.Дата);
	
КонецПроцедуры

&НаКлиенте
Процедура СчетУчетаФлагПриИзменении(Элемент)
	
	ФлагПриИзменении(Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура СчетАмортизацииФлагПриИзменении(Элемент)
	
	ФлагПриИзменении(Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура СрокИспользованияБУПриИзменении(Элемент)
	
	СрокИспользованияБУРасшифровка = ВнеоборотныеАктивыКлиентСервер.ПредставлениеКоличестваМесяцевСтрокой(
		Объект.СрокИспользованияБУ);
	
КонецПроцедуры

&НаКлиенте
Процедура СрокИспользованияНУПриИзменении(Элемент)
	
	СрокИспользованияНУРасшифровка = ВнеоборотныеАктивыКлиентСервер.ПредставлениеКоличестваМесяцевСтрокой(
		Объект.СрокИспользованияНУ);
	
КонецПроцедуры

&НаКлиенте
Процедура ГрафикАмортизацииФлагПриИзменении(Элемент)
	
	ФлагПриИзменении(Элемент.Имя);
	
	Если Элементы.ГрафикАмортизации.ПодсказкаВвода = "" Тогда
		Элементы.ГрафикАмортизации.ПодсказкаВвода = НСтр("ru = '<без графика>';
														|en = '<without schedule>'")
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СрокИспользованияБУФлагПриИзменении(Элемент)
	
	ФлагПриИзменении(Элемент.Имя);
	
	Если Не Объект.СрокИспользованияБУФлаг Тогда
		СрокИспользованияБУРасшифровка = ВнеоборотныеАктивыКлиентСервер.ПредставлениеКоличестваМесяцевСтрокой(
			Объект.СрокИспользованияБУ);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СрокИспользованияНУФлагПриИзменении(Элемент)
	
	ФлагПриИзменении(Элемент.Имя);
	
	Если Не Объект.СрокИспользованияНУФлаг Тогда
		СрокИспользованияНУРасшифровка = ВнеоборотныеАктивыКлиентСервер.ПредставлениеКоличестваМесяцевСтрокой(
			Объект.СрокИспользованияНУ);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбъемНаработкиБУФлагПриИзменении(Элемент)
	
	ФлагПриИзменении(Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура КоэффициентАмортизацииБУФлагПриИзменении(Элемент)
	
	ФлагПриИзменении(Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура КоэффициентУскоренияБУФлагПриИзменении(Элемент)
	
	ФлагПриИзменении(Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура СпециальныйКоэффициентНУФлагПриИзменении(Элемент)
	
	ФлагПриИзменении(Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтражениеАмортизационныхРасходовФлагПриИзменении(Элемент)
	
	ОтражениеАмортизационныхРасходовФлагПриИзмененииНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ОтражениеАмортизационныхРасходовФлагПриИзмененииНаСервере()
	
	ТаблицаПустая = Объект.ОтражениеАмортизационныхРасходов.Количество()=0;
	
	Элементы.ОтражениеАмортизационныхРасходов.ТолькоПросмотр = Не Объект.ОтражениеАмортизационныхРасходовФлаг;
	Элементы.ОтражениеАмортизационныхРасходов.ЦветФона = ?(Объект.ОтражениеАмортизационныхРасходовФлаг, ЦветФонаПоля, ЦветФонаФормы);
	Элементы.ОтражениеАмортизационныхРасходов.АвтоОтметкаНезаполненного = Объект.ОтражениеАмортизационныхРасходовФлаг;
	Элементы.ОтражениеАмортизационныхРасходов.ОтметкаНезаполненного = Объект.ОтражениеАмортизационныхРасходовФлаг И ТаблицаПустая;
	
	Элементы.ОСОтражениеАмортизационныхРасходов.Видимость = Объект.ОтражениеАмортизационныхРасходовФлаг;
	
	КоличествоСтрокОтраженияРасходов = ?(
		Объект.ОтражениеАмортизационныхРасходовФлаг,
		Объект.ОтражениеАмортизационныхРасходов.Количество(),
		0);
	
КонецПроцедуры

&НаКлиенте
Процедура СтраницыПриСменеСтраницы(Элемент, ТекущаяСтраница)
	Если ТекущаяСтраница = Элементы.СтраницаПараметры И ОбновитьТекущиеЗначения Тогда
		СтраницыПриСменеСтраницыНаСервере();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура СтраницыПриСменеСтраницыНаСервере()
	ЗаполнитьТекущиеЗначенияРеквизитов(Ложь);
	УстановитьВидимостьРеквизитовОтраженияРасходов();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицыОС

&НаКлиенте
Процедура ОСПриИзменении(Элемент)
	ОбновитьТекущиеЗначения = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ОСОсновноеСредствоПриИзменении(Элемент)
	
	СтрокаТЧ = Элементы.ОС.ТекущиеДанные;
	ОсновноеСредство = СтрокаТЧ.ОсновноеСредство;
	Если ЗначениеЗаполнено(ОсновноеСредство) Тогда
		ЗаполнитьЗначенияСвойств(
			СтрокаТЧ,
			ТекущиеЗначенияРеквизитовОсновногоСредства(ОсновноеСредство, Объект.Дата, Объект.Организация));
	Иначе
		ЗаполнитьЗначенияСвойств(
			СтрокаТЧ,
			ПустыеЗначенияРеквизитовОсновногоСредства());
	КонецЕсли;
	
	ПослеИзмененияСпискаОС();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицыОтражениеРасходов

&НаКлиенте
Процедура ОтражениеАмортизационныхРасходовПриИзменении(Элемент)
	
	КоличествоСтрокОтраженияРасходов = ?(
		Объект.ОтражениеАмортизационныхРасходовФлаг,
		Объект.ОтражениеАмортизационныхРасходов.Количество(),
		0);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтражениеАмортизационныхРасходовСтатьяРасходовПриИзменении(Элемент)
	
	ДоходыИРасходыКлиентСервер.СтатьяПриИзменении(ЭтотОбъект, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтражениеАмортизационныхРасходовСтатьяРасходовАмортизационнойПремииПриИзменении(Элемент)
	
	ДоходыИРасходыКлиентСервер.СтатьяПриИзменении(ЭтотОбъект, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтражениеАмортизационныхРасходовСтатьяРасходовНалогПриИзменении(Элемент)
	
	ДоходыИРасходыКлиентСервер.СтатьяПриИзменении(ЭтотОбъект, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтражениеАмортизационныхРасходовСтатьяРасходовНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ДоходыИРасходыКлиент.НачалоВыбораСтатьи(ЭтотОбъект, Элемент, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтражениеАмортизационныхРасходовСтатьяРасходовАмортизационнойПремииНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ДоходыИРасходыКлиент.НачалоВыбораСтатьи(ЭтотОбъект, Элемент, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтражениеАмортизационныхРасходовСтатьяРасходовНалогНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ДоходыИРасходыКлиент.НачалоВыбораСтатьи(ЭтотОбъект, Элемент, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтражениеАмортизационныхРасходовАналитикаРасходовНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ДоходыИРасходыКлиент.НачалоВыбораАналитикиРасходов(ЭтотОбъект, Элемент, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтражениеАмортизационныхРасходовАналитикаРасходовАмортизационнойПремииНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ДоходыИРасходыКлиент.НачалоВыбораАналитикиРасходов(ЭтотОбъект, Элемент, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтражениеАмортизационныхРасходовАналитикаРасходовНалогНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ДоходыИРасходыКлиент.НачалоВыбораАналитикиРасходов(ЭтотОбъект, Элемент, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтражениеАмортизационныхРасходовАналитикаРасходовАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	ДоходыИРасходыКлиент.АвтоПодборАналитикиРасходов(ЭтотОбъект, Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтражениеАмортизационныхРасходовАналитикаРасходовАмортизационнойПремииАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	ДоходыИРасходыКлиент.АвтоПодборАналитикиРасходов(ЭтотОбъект, Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтражениеАмортизационныхРасходовАналитикаРасходовНалогАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	ДоходыИРасходыКлиент.АвтоПодборАналитикиРасходов(ЭтотОбъект, Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтражениеАмортизационныхРасходовАналитикаРасходовОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	ДоходыИРасходыКлиент.ОкончаниеВводаТекстаАналитикиРасходов(ЭтотОбъект, Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтражениеАмортизационныхРасходовАналитикаРасходовАмортизационнойПремииОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	ДоходыИРасходыКлиент.ОкончаниеВводаТекстаАналитикиРасходов(ЭтотОбъект, Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтражениеАмортизационныхРасходовАналитикаРасходовНалогОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	ДоходыИРасходыКлиент.ОкончаниеВводаТекстаАналитикиРасходов(ЭтотОбъект, Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтражениеАмортизационныхРасходовПередаватьРасходыВДругуюОрганизациюПриИзменении(Элемент)
	
	СтрокаТаблицы = Элементы.ОтражениеАмортизационныхРасходов.ТекущиеДанные;
	Если Не СтрокаТаблицы.ПередаватьРасходыВДругуюОрганизацию Тогда
		СтрокаТаблицы.ОрганизацияПолучательРасходов = Неопределено;
		СтрокаТаблицы.СчетПередачиРасходов = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры

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
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтотОбъект, Команда);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Записать(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоНаименованию(Команда)
	
	ОсновноеСредство = ВнеоборотныеАктивыКлиентЛокализация.ПолучитьОСДляЗаполнениеПоНаименованию(
		ПараметрыЗаполненияПоНаименованию(ЭтаФорма));
	
	Если ЗначениеЗаполнено(ОсновноеСредство) Тогда
		
		ЗаполнитьПоНаименованиюСервер(ОсновноеСредство);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подбор(Команда)
	
	ПараметрыОтбор = Новый Структура;
	ПараметрыОтбор.Вставить("БУСостояние", ПредопределенноеЗначение("Перечисление.СостоянияОС.ПринятоКУчету"));
	ПараметрыОтбор.Вставить("БУОрганизация", Объект.Организация);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Контекст", "БУ, МФУ");
	ПараметрыФормы.Вставить("ДатаСведений", Объект.Дата);
	ПараметрыФормы.Вставить("ТекущийРегистратор", Объект.Ссылка);
	ПараметрыФормы.Вставить("Отбор", ПараметрыОтбор);
	ПараметрыФормы.Вставить("ЗакрыватьПриВыборе", Ложь);
	ПараметрыФормы.Вставить("МножественныйВыбор", Истина);
	
	ОткрытьФорму("Справочник.ОбъектыЭксплуатации.ФормаВыбора", ПараметрыФормы, ЭтаФорма);
	
КонецПроцедуры

#Область ИнтеграцияС1СДокументооборотом

&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура ПровестиИЗакрыть(Команда)
	
	ОбщегоНазначенияУТКлиент.ПровестиИЗакрыть(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Провести(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура Подключаемый_ЗакрытьФорму()
	
	Закрыть();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	#Область СтатьяРасходовНалог
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	Элемент.Поля.Элементы.Добавить().Поле = Новый ПолеКомпоновкиДанных(Элементы.ОтражениеАмортизационныхРасходовСтатьяРасходовНалог.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ТребуетсяЗаполнениеРеквизитовНалог");
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ОтборЭлемента.ПравоеЗначение = Ложь;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);

	#КонецОбласти
		
	#Область ПередачаРасходов
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ОтражениеАмортизационныхРасходовПодразделение.Имя);
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ОтражениеАмортизационныхРасходовСтатьяРасходов.Имя);
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ОтражениеАмортизационныхРасходовАналитикаРасходов.Имя);
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ОтражениеАмортизационныхРасходовСтатьяРасходовАмортизационнойПремии.Имя);
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ОтражениеАмортизационныхРасходовАналитикаРасходовАмортизационнойПремии.Имя);
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ОтражениеАмортизационныхРасходовСтатьяРасходовНалог.Имя);
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ОтражениеАмортизационныхРасходовАналитикаРасходовНалог.Имя);
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ОтражениеАмортизационныхРасходовСчетПередачиРасходов.Имя);
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ОтражениеАмортизационныхРасходовОрганизацияПолучательРасходов.Имя);
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ОтражениеАмортизационныхРасходовКоэффициент.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.ОтражениеАмортизационныхРасходовФлаг");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);
	
	#КонецОбласти
	
	#Область ПередачаРасходовВДругуюОрганизацию
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ОтражениеАмортизационныхРасходовСчетПередачиРасходов.Имя);
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ОтражениеАмортизационныхРасходовОрганизацияПолучательРасходов.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.ОтражениеАмортизационныхРасходов.ПередаватьРасходыВДругуюОрганизацию");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);
	
	#КонецОбласти
	
КонецПроцедуры

&НаКлиенте
Процедура ФлагПриИзменении(ИмяФлага)
	
	ФлагУстановлен = Объект[ИмяФлага];
	Имя = СтрЗаменить(ИмяФлага, "Флаг", "");
	
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, Имя, "Доступность", ФлагУстановлен);
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ОС"+Имя, "Видимость", ФлагУстановлен);
	
	Если Объект[ИмяФлага] Тогда
		Элементы[Имя].ПодсказкаВвода = "";
	Иначе
		Объект[Имя] = ТекущиеЗначенияРеквизитов[Имя];
		Если ТипЗнч(ТекущиеЗначенияРеквизитов[Имя]) = Тип("Строка") Тогда
			Элементы[Имя].ПодсказкаВвода = ТекущиеЗначенияРеквизитов[Имя];
		КонецЕсли;
	КонецЕсли;
	
	КоличествоИзмененныхСвойств = КоличествоИзмененныхСвойств + ?(ФлагУстановлен, 1, -1);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТекущиеЗначенияРеквизитов(ЗаполнитьДоступность=Ложь)
	
	КоличествоИзмененныхСвойств = 0;
	Структура = СтруктураИзменяемыхРеквизитов();
	ТребуетсяЗаполнениеРеквизитовНалог = Ложь;
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ВЫРАЗИТЬ(ДанныеДокумента.НомерСтроки КАК ЧИСЛО) КАК НомерСтроки,
	|	ВЫРАЗИТЬ(ДанныеДокумента.ОсновноеСредство КАК Справочник.ОбъектыЭксплуатации) КАК ОсновноеСредство
	|ПОМЕСТИТЬ ДанныеДокумента
	|ИЗ
	|	&ДанныеДокумента КАК ДанныеДокумента
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДанныеДокумента.НомерСтроки КАК НомерСтроки,
	|	ДанныеДокумента.ОсновноеСредство.ИнвентарныйНомер КАК ИнвентарныйНомер,
	|	ВЫБОР 
	|		КОГДА ДанныеДокумента.ОсновноеСредство.ГруппаОС В (
	|					ЗНАЧЕНИЕ(Перечисление.ГруппыОС.Здания),
	|					ЗНАЧЕНИЕ(Перечисление.ГруппыОС.Сооружения),
	|					ЗНАЧЕНИЕ(Перечисление.ГруппыОС.МноголетниеНасаждения),
	|					ЗНАЧЕНИЕ(Перечисление.ГруппыОС.ТранспортныеСредства),
	|					ЗНАЧЕНИЕ(Перечисление.ГруппыОС.ПрочееИмуществоТребующееГосударственнойРегистрации),
	|					ЗНАЧЕНИЕ(Перечисление.ГруппыОС.ЗемельныеУчастки))
	|			ТОГДА ИСТИНА
	|		КОГДА ПервоначальныеСведенияОС.ДатаВводаВЭксплуатациюБУ < ДАТАВРЕМЯ(2013,1,1,0,0,0)
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ТребуетсяЗаполнениеРеквизитовНалог,
	|	ЕСТЬNULL(ПараметрыАмортизацииОСБУ.ГрафикАмортизации, ЗНАЧЕНИЕ(Справочник.ГодовыеГрафикиАмортизацииОС.ПустаяСсылка)) КАК ГрафикАмортизации,
	|	ПараметрыАмортизацииОСБУ.СрокИспользованияДляВычисленияАмортизации КАК СрокИспользованияБУ,
	|	ПараметрыАмортизацииОСБУ.ОбъемПродукцииРаботДляВычисленияАмортизации КАК ОбъемНаработкиБУ,
	|	ПараметрыАмортизацииОСБУ.КоэффициентАмортизацииБУ КАК КоэффициентАмортизацииБУ,
	|	ПараметрыАмортизацииОСБУ.КоэффициентУскорения КАК КоэффициентУскоренияБУ,
	|	ПараметрыАмортизацииОСБУ.СпециальныйКоэффициент КАК СпециальныйКоэффициентНУ,
	|	ПараметрыАмортизацииОСБУ.СрокПолезногоИспользованияНУ КАК СрокИспользованияНУ,
	|	МестонахождениеОС.Местонахождение КАК Подразделение,
	|	ПорядокУчетаОСБУ.СтатьяРасходовБУ КАК СтатьяРасходов,
	|	ПорядокУчетаОСБУ.АналитикаРасходовБУ КАК АналитикаРасходов,
	|	СпособыОтраженияРасходовПоИмущественнымНалогам.СтатьяРасходов КАК СтатьяРасходовНалог,
	|	СпособыОтраженияРасходовПоИмущественнымНалогам.АналитикаРасходов КАК АналитикаРасходовНалог,
	|	ПорядокУчетаОС.СчетУчета КАК СчетУчета,
	|	ПорядокУчетаОС.СчетНачисленияАмортизации КАК СчетАмортизации,
	|	1 КАК Коэффициент
	|ПОМЕСТИТЬ ТекущиеДанные
	|ИЗ
	|	ДанныеДокумента КАК ДанныеДокумента
	|
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПервоначальныеСведенияОС.СрезПоследних(
	|				&Дата,
	|				Организация = &Организация
	|				И ОсновноеСредство В
	|						(ВЫБРАТЬ
	|							ДанныеДокумента.ОсновноеСредство
	|						ИЗ
	|							ДанныеДокумента КАК ДанныеДокумента)
	|					И Регистратор <> &ТекущийРегистратор) КАК ПервоначальныеСведенияОС
	|		ПО ДанныеДокумента.ОсновноеСредство = ПервоначальныеСведенияОС.ОсновноеСредство
	|
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПараметрыАмортизацииОСБУ.СрезПоследних(
	|				&Дата,
	|				Организация = &Организация
	|				И ОсновноеСредство В
	|						(ВЫБРАТЬ
	|							ДанныеДокумента.ОсновноеСредство
	|						ИЗ
	|							ДанныеДокумента КАК ДанныеДокумента)
	|					И Регистратор <> &ТекущийРегистратор) КАК ПараметрыАмортизацииОСБУ
	|		ПО ДанныеДокумента.ОсновноеСредство = ПараметрыАмортизацииОСБУ.ОсновноеСредство
	|
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПорядокУчетаОСБУ.СрезПоследних(
	|				&Дата,
	|				Организация = &Организация
	|				И ОсновноеСредство В
	|						(ВЫБРАТЬ
	|							ДанныеДокумента.ОсновноеСредство
	|						ИЗ
	|							ДанныеДокумента КАК ДанныеДокумента)
	|					И Регистратор <> &ТекущийРегистратор) КАК ПорядокУчетаОСБУ
	|		ПО ДанныеДокумента.ОсновноеСредство = ПорядокУчетаОСБУ.ОсновноеСредство
	|
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.МестонахождениеОС.СрезПоследних(
	|				&Дата,
	|				Организация = &Организация
	|				И ОсновноеСредство В
	|						(ВЫБРАТЬ
	|							ДанныеДокумента.ОсновноеСредство
	|						ИЗ
	|							ДанныеДокумента КАК ДанныеДокумента)
	|					И Регистратор <> &ТекущийРегистратор) КАК МестонахождениеОС
	|		ПО ДанныеДокумента.ОсновноеСредство = МестонахождениеОС.ОсновноеСредство
	|
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СпособыОтраженияРасходовПоИмущественнымНалогам.СрезПоследних(
	|				&Дата,
	|				Организация = &Организация
	|				И ОсновноеСредство В
	|						(ВЫБРАТЬ
	|							ДанныеДокумента.ОсновноеСредство
	|						ИЗ
	|							ДанныеДокумента КАК ДанныеДокумента)
	|					И Регистратор <> &ТекущийРегистратор) КАК СпособыОтраженияРасходовПоИмущественнымНалогам
	|		ПО ДанныеДокумента.ОсновноеСредство = СпособыОтраженияРасходовПоИмущественнымНалогам.ОсновноеСредство
	|
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПорядокУчетаОС.СрезПоследних(
	|				&Дата,
	|				ОсновноеСредство В
	|						(ВЫБРАТЬ
	|							ДанныеДокумента.ОсновноеСредство
	|						ИЗ
	|							ДанныеДокумента КАК ДанныеДокумента)
	|					И Регистратор <> &ТекущийРегистратор) КАК ПорядокУчетаОС
	|		ПО ДанныеДокумента.ОсновноеСредство = ПорядокУчетаОС.ОсновноеСредство
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТекущиеДанные.НомерСтроки,
	|	ТекущиеДанные.ИнвентарныйНомер,
	|	ТекущиеДанные.ГрафикАмортизации,
	|	ТекущиеДанные.СрокИспользованияБУ,
	|	ТекущиеДанные.ОбъемНаработкиБУ,
	|	ТекущиеДанные.КоэффициентАмортизацииБУ,
	|	ТекущиеДанные.КоэффициентУскоренияБУ,
	|	ТекущиеДанные.СрокИспользованияНУ,
	|	ТекущиеДанные.СпециальныйКоэффициентНУ,
	|	ТекущиеДанные.Подразделение,
	|	ТекущиеДанные.СтатьяРасходов,
	|	ТекущиеДанные.АналитикаРасходов,
	|	ТекущиеДанные.СчетУчета,
	|	ТекущиеДанные.СчетАмортизации
	|ИЗ
	|	ТекущиеДанные КАК ТекущиеДанные
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	МАКСИМУМ(ТекущиеДанные.СчетУчета) КАК СчетУчета,
	|	МАКСИМУМ(ТекущиеДанные.СчетАмортизации) КАК СчетАмортизации,
	|	МАКСИМУМ(ТекущиеДанные.ГрафикАмортизации) КАК ГрафикАмортизации,
	|	МАКСИМУМ(ТекущиеДанные.СрокИспользованияБУ) КАК СрокИспользованияБУ,
	|	МАКСИМУМ(ТекущиеДанные.ОбъемНаработкиБУ) КАК ОбъемНаработкиБУ,
	|	МАКСИМУМ(ТекущиеДанные.КоэффициентАмортизацииБУ) КАК КоэффициентАмортизацииБУ,
	|	МАКСИМУМ(ТекущиеДанные.КоэффициентУскоренияБУ) КАК КоэффициентУскоренияБУ,
	|	МАКСИМУМ(ТекущиеДанные.СрокИспользованияНУ) КАК СрокИспользованияНУ,
	|	МАКСИМУМ(ТекущиеДанные.СпециальныйКоэффициентНУ) КАК СпециальныйКоэффициентНУ,
	|	МАКСИМУМ(ТекущиеДанные.ТребуетсяЗаполнениеРеквизитовНалог) КАК ТребуетсяЗаполнениеРеквизитовНалог,
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ТекущиеДанные.СчетУчета) КАК СчетУчетаКоличествоРазличных,
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ТекущиеДанные.СчетАмортизации) КАК СчетАмортизацииКоличествоРазличных,
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ТекущиеДанные.ГрафикАмортизации) КАК ГрафикАмортизацииКоличествоРазличных,
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ТекущиеДанные.СрокИспользованияБУ) КАК СрокИспользованияБУКоличествоРазличных,
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ТекущиеДанные.ОбъемНаработкиБУ) КАК ОбъемНаработкиБУКоличествоРазличных,
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ТекущиеДанные.КоэффициентАмортизацииБУ) КАК КоэффициентАмортизацииБУКоличествоРазличных,
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ТекущиеДанные.КоэффициентУскоренияБУ) КАК КоэффициентУскоренияБУКоличествоРазличных,
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ТекущиеДанные.СрокИспользованияНУ) КАК СрокИспользованияНУКоличествоРазличных,
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ТекущиеДанные.СпециальныйКоэффициентНУ) КАК СпециальныйКоэффициентНУКоличествоРазличных
	|ИЗ
	|	ТекущиеДанные КАК ТекущиеДанные";

	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Дата", Новый Граница(?(ЗначениеЗаполнено(Объект.Дата), Объект.Дата, ТекущаяДатаСеанса()), ВидГраницы.Исключая));
	Запрос.УстановитьПараметр("ДанныеДокумента", Объект.ОС.Выгрузить(, "НомерСтроки, ОсновноеСредство"));
	Запрос.УстановитьПараметр("ТекущийРегистратор", Объект.Ссылка);
	Запрос.УстановитьПараметр("Организация", Объект.Организация);
	
	Результат = Запрос.ВыполнитьПакет();
	
	Если Не Результат[3].Пустой() Тогда
		Выборка = Результат[3].Выбрать();
		Выборка.Следующий();
		Для Каждого КлючИЗначение Из Структура Цикл
			Имя = КлючИЗначение.Ключ;
			Если Выборка[Имя+"КоличествоРазличных"] > 1 Тогда
				Структура[Имя] = СтрЗаменить(НСтр("ru = '% различных';
													|en = '% different '"), "%", Формат(Выборка[Имя+"КоличествоРазличных"], "ЧЦ=1; ЧГ=0"));
			Иначе
				Структура[Имя] = Выборка[Имя];
			КонецЕсли;
		КонецЦикла;
		
		ТребуетсяЗаполнениеРеквизитовНалог = Выборка.ТребуетсяЗаполнениеРеквизитовНалог = Истина;
		
	КонецЕсли;
	
	Если ЗаполнитьДоступность И Не Результат[2].Пустой() Тогда
		Выборка = Результат[2].Выбрать();
		Пока Выборка.Следующий() Цикл
			ЗаполнитьЗначенияСвойств(Объект.ОС[Выборка.НомерСтроки-1], Выборка,, "НомерСтроки");
		КонецЦикла;
	КонецЕсли;
	
	Для Каждого КлючИЗначение Из Структура Цикл
		Имя = КлючИЗначение.Ключ;
		Если Не Объект[Имя+"Флаг"] Тогда
			Объект[Имя] = Структура[Имя];
			Если ТипЗнч(Структура[Имя]) = Тип("Строка") Тогда
				Элементы[Имя].ПодсказкаВвода = Структура[Имя];
			КонецЕсли;
		КонецЕсли;
		Если ЗаполнитьДоступность Тогда
			
			ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, Имя, "Доступность", Объект[Имя + "Флаг"]);
			ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ОС"+Имя, "Видимость", Объект[Имя + "Флаг"]);
			
		КонецЕсли;
		КоличествоИзмененныхСвойств = КоличествоИзмененныхСвойств + ?(Объект[Имя + "Флаг"], 1, 0);
		
	КонецЦикла;
	
	Если ЗаполнитьДоступность Тогда
		Элементы.ОтражениеАмортизационныхРасходов.ТолькоПросмотр = Не Объект.ОтражениеАмортизационныхРасходовФлаг;
		Элементы.ОтражениеАмортизационныхРасходов.ЦветФона = ?(Объект.ОтражениеАмортизационныхРасходовФлаг, ЦветФонаПоля, ЦветФонаФормы);
		Элементы.ОтражениеАмортизационныхРасходов.АвтоОтметкаНезаполненного = Объект.ОтражениеАмортизационныхРасходовФлаг;
		Элементы.ОСОтражениеАмортизационныхРасходов.Видимость = Объект.ОтражениеАмортизационныхРасходовФлаг;
		
		Если Не Объект.СрокИспользованияБУФлаг Тогда
			СрокИспользованияБУРасшифровка = ВнеоборотныеАктивыКлиентСервер.ПредставлениеКоличестваМесяцевСтрокой(
				Объект.СрокИспользованияБУ);
		КонецЕсли;
		Если Не Объект.СрокИспользованияНУФлаг Тогда
			СрокИспользованияНУРасшифровка = ВнеоборотныеАктивыКлиентСервер.ПредставлениеКоличестваМесяцевСтрокой(
				Объект.СрокИспользованияНУ);
		КонецЕсли;
		
	КонецЕсли;
	
	ТекущиеЗначенияРеквизитов = Новый ФиксированнаяСтруктура(Структура);
	
	ОбновитьТекущиеЗначения = Ложь;
	
	Если Элементы.ГрафикАмортизации.ПодсказкаВвода = "" Тогда
		Элементы.ГрафикАмортизации.ПодсказкаВвода = НСтр("ru = '<без графика>';
														|en = '<without schedule>'")
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция СтруктураИзменяемыхРеквизитов()
	
	Возврат Новый Структура(
		"СчетУчета, СчетАмортизации,
		|ГрафикАмортизации, СрокИспользованияБУ, СрокИспользованияНУ,
		|ОбъемНаработкиБУ, КоэффициентАмортизацииБУ, КоэффициентУскоренияБУ,
		|СпециальныйКоэффициентНУ");
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ПустыеЗначенияРеквизитовОсновногоСредства()
	
	Возврат Новый Структура(
		"ИнвентарныйНомер, СчетУчета, СчетАмортизации,
		|ГрафикАмортизации, СрокИспользованияБУ, СрокИспользованияНУ,
		|ОбъемНаработкиБУ, КоэффициентАмортизацииБУ, КоэффициентУскоренияБУ,
		|СпециальныйКоэффициентНУ");
	
КонецФункции

&НаСервереБезКонтекста
Функция ТекущиеЗначенияРеквизитовОсновногоСредства(ОсновноеСредство, Дата, Организация)
	
	Структура = ПустыеЗначенияРеквизитовОсновногоСредства();
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ОбъектыЭксплуатации.ИнвентарныйНомер КАК ИнвентарныйНомер,
		|	ПорядокУчетаОС.СчетУчета КАК СчетУчета,
		|	ПорядокУчетаОС.СчетНачисленияАмортизации КАК СчетАмортизации,
		|	ПараметрыАмортизацииОСБУ.ГрафикАмортизации КАК ГрафикАмортизации,
		|	ПараметрыАмортизацииОСБУ.СрокИспользованияДляВычисленияАмортизации КАК СрокИспользованияБУ,
		|	ПараметрыАмортизацииОСБУ.ОбъемПродукцииРаботДляВычисленияАмортизации КАК ОбъемНаработкиБУ,
		|	ПараметрыАмортизацииОСБУ.КоэффициентАмортизацииБУ КАК КоэффициентАмортизацииБУ,
		|	ПараметрыАмортизацииОСБУ.КоэффициентУскорения КАК КоэффициентУскоренияБУ,
		|	ПараметрыАмортизацииОСБУ.СпециальныйКоэффициент КАК СпециальныйКоэффициентНУ,
		|	ПараметрыАмортизацииОСБУ.СрокПолезногоИспользованияНУ КАК СрокИспользованияНУ
		|ИЗ
		|	Справочник.ОбъектыЭксплуатации КАК ОбъектыЭксплуатации
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПараметрыАмортизацииОСБУ.СрезПоследних(&Дата, Организация = &Организация И ОсновноеСредство В (&ОсновноеСредство)) КАК ПараметрыАмортизацииОСБУ
		|		ПО ОбъектыЭксплуатации.Ссылка = ПараметрыАмортизацииОСБУ.ОсновноеСредство
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПорядокУчетаОС.СрезПоследних(&Дата, ОсновноеСредство В (&ОсновноеСредство)) КАК ПорядокУчетаОС
		|		ПО ОбъектыЭксплуатации.Ссылка = ПорядокУчетаОС.ОсновноеСредство
		|ГДЕ
		|	ОбъектыЭксплуатации.Ссылка = &ОсновноеСредство");
	
	Запрос.УстановитьПараметр("Дата", ?(ЗначениеЗаполнено(Дата), Дата, ТекущаяДатаСеанса()));
	Запрос.УстановитьПараметр("ОсновноеСредство", ОсновноеСредство);
	Запрос.УстановитьПараметр("Организация", Организация);
	Результат = Запрос.Выполнить();
	
	Если Результат.Пустой() Тогда
		Возврат Структура;
	КонецЕсли;
	
	Выборка = Результат.Выбрать();
	Выборка.Следующий();
	ЗаполнитьЗначенияСвойств(Структура, Выборка);
	
	Возврат Структура;
	
КонецФункции

&НаСервере
Процедура ПриСозданииЧтенииНаСервере()
	
	ЦветФонаФормы = ЦветаСтиля.ЦветФонаФормы;
	ЦветФонаПоля = ЦветаСтиля.ЦветФонаПоля;
	
	Элементы.ДокументОснование.Видимость = ЗначениеЗаполнено(Объект.ДокументОснование);
	
	ЗаполнитьТекущиеЗначенияРеквизитов(Истина);
	УстановитьВидимостьРеквизитовОтраженияРасходов();
	УстановитьДоступностьПередачиАмортизационныхРасходов();
	ВнеоборотныеАктивы.УстановитьПараметрыФункциональныхОпцийФормыОбъекта(ЭтаФорма, Объект.Организация, Объект.Дата);
	
	КоличествоСтрокОтраженияРасходов = ?(
		Объект.ОтражениеАмортизационныхРасходовФлаг,
		Объект.ОтражениеАмортизационныхРасходов.Количество(),
		0);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ПараметрыЗаполненияПоНаименованию(Форма)
	
	Результат = Новый Структура;
	Результат.Вставить("Форма", Форма);
	Результат.Вставить("Объект", Форма.Объект);
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьПоНаименованиюСервер(Знач ОсновноеСредство)
	
	УчетОСВызовСервера.ДозаполнитьТабличнуюЧастьОсновнымиСредствамиПоНаименованию(
		ПараметрыЗаполненияПоНаименованию(ЭтаФорма), ОсновноеСредство);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьРеквизитовОтраженияРасходов()
	
	ТребуетсяЗаполнениеРеквизитовПремии = Ложь;
	
	Если ЗначениеЗаполнено(Объект.ДокументОснование)
		И ТипЗнч(Объект.ДокументОснование) = Тип("ДокументСсылка.ПринятиеКУчетуОС") Тогда
		
		ВключитьАмортизационнуюПремиюВСоставРасходов = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(
			Объект.ДокументОснование, "ВключитьАмортизационнуюПремиюВСоставРасходов");
		
		ТребуетсяЗаполнениеРеквизитовПремии = (ВключитьАмортизационнуюПремиюВСоставРасходов = Истина);
		
	КонецЕсли;
	
	Элементы.ГруппаАмортизация.ОтображатьВШапке = ТребуетсяЗаполнениеРеквизитовПремии Или ТребуетсяЗаполнениеРеквизитовНалог;
	Элементы.ГруппаПремия.Видимость = ТребуетсяЗаполнениеРеквизитовПремии;
	Элементы.ГруппаНалог.Видимость = ТребуетсяЗаполнениеРеквизитовНалог;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьДоступностьПередачиАмортизационныхРасходов()
	
	ЕстьСвязанныеОрганизации = Справочники.Организации.ОрганизацияВзаимосвязанаСДругимиОрганизациями(Объект.Организация);
	Элементы.ГруппаПередачаРасходовПоАмортизации.Видимость = ЕстьСвязанныеОрганизации;
	
КонецПроцедуры

&НаСервере
Процедура ПослеИзмененияСпискаОС()

	ЗаполнитьТекущиеЗначенияРеквизитов(Истина);
	УстановитьВидимостьРеквизитовОтраженияРасходов();

КонецПроцедуры

#КонецОбласти
