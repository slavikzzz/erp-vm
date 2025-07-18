
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	МодификацияКонфигурацииПереопределяемый.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПриСозданииЧтенииНаСервере();
	КонецЕсли;
	
	ПараметрыВыбораСтатейИАналитик = Документы.ВводОстатковНМАМеждународныйУчет.ПараметрыВыбораСтатейИАналитик();
	ДоходыИРасходыСервер.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыВыбораСтатейИАналитик);
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПриСозданииНаСервере(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	МодификацияКонфигурацииПереопределяемый.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	ПриСозданииЧтенииНаСервере();
	
	ПараметрыВыбораСтатейИАналитик = Документы.ВводОстатковНМАМеждународныйУчет.ПараметрыВыбораСтатейИАналитик();
	ДоходыИРасходыСервер.ПриЧтенииНаСервере(ЭтотОбъект, ПараметрыВыбораСтатейИАналитик);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
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
	
	ДоходыИРасходыСервер.ПослеЗаписиНаСервере(ЭтотОбъект);
	
	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);
	
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
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура НематериальныйАктивПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Объект.НематериальныйАктив) Тогда
		НематериальныйАктивПриИзмененииНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура НематериальныйАктивПриИзмененииНаСервере()
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	НематериальныеАктивы.ГруппаНМА.ПорядокУчета КАК ПорядокУчета
		|ИЗ
		|	Справочник.НематериальныеАктивы КАК НематериальныеАктивы
		|ГДЕ
		|	НематериальныеАктивы.Ссылка = &Ссылка"
	);
	
	Запрос.УстановитьПараметр("Ссылка", Объект.НематериальныйАктив);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		
		Объект.ПорядокУчета = Выборка.ПорядокУчета;
		ОбновитьДоступностьЭлементовФормы("ПорядокУчета");
		
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПорядокУчетаПриИзменении(Элемент)
	
	ОбновитьДоступностьЭлементовФормы("ПорядокУчета");
	
КонецПроцедуры

&НаКлиенте
Процедура МетодНачисленияАмортизацииПриИзменении(Элемент)
	ОбновитьДоступностьЭлементовФормы("МетодНачисленияАмортизации");
КонецПроцедуры

&НаКлиенте
Процедура ПервоначальнаяСтоимостьПриИзменении(Элемент)
	
	Объект.ПервоначальнаяСтоимостьПредставления = Объект.ПервоначальнаяСтоимость * КоэффициентПересчетаВВалютуПредставления;
	
КонецПроцедуры

&НаКлиенте
Процедура ЛиквидационнаяСтоимостьПриИзменении(Элемент)
	
	Объект.ЛиквидационнаяСтоимостьПредставления = Объект.ЛиквидационнаяСтоимость * КоэффициентПересчетаВВалютуПредставления;
	
КонецПроцедуры

&НаКлиенте
Процедура НакопленнаяАмортиазцияПриИзменении(Элемент)
	
	Объект.НакопленнаяАмортизацияПредставления = Объект.НакопленнаяАмортизация * КоэффициентПересчетаВВалютуПредставления;
	
	ОбновитьДоступностьЭлементовФормы("НакопленнаяАмортиазция");
	
КонецПроцедуры

&НаКлиенте
Процедура НакопленнаяАмортизацияПредставленияПриИзменении(Элемент)
	
	ОбновитьДоступностьЭлементовФормы("НакопленнаяАмортиазция");
	
КонецПроцедуры

&НаКлиенте
Процедура СтатьяРасходовПриИзменении(Элемент)
	
	ДоходыИРасходыКлиентСервер.СтатьяПриИзменении(ЭтотОбъект, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура СтатьяРасходовНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ДоходыИРасходыКлиент.НачалоВыбораСтатьи(ЭтотОбъект, Элемент, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура АналитикаРасходовНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ДоходыИРасходыКлиент.НачалоВыбораАналитикиРасходов(ЭтотОбъект, Элемент, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура АналитикаРасходовАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	ДоходыИРасходыКлиент.АвтоПодборАналитикиРасходов(ЭтотОбъект, Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура АналитикаРасходовОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	ДоходыИРасходыКлиент.ОкончаниеВводаТекстаАналитикиРасходов(ЭтотОбъект, Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды


// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды


#Область СтандартныеПодсистемы

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
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

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
Процедура ЗаписатьДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Записать(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Провести(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПриСозданииЧтенииНаСервере()
	
	Валюты = МеждународныйУчетОбщегоНазначения.УчетныеВалюты(Справочники.ПланыСчетовМеждународногоУчета.Международный, Объект.Организация);
	
	ШаблонДекорацииВалюты = НСтр("ru = '(%Валюта%)';
								|en = '(%Валюта%)'");
	ДекорацияВалютаФункциональная = СтрЗаменить(ШаблонДекорацииВалюты, "%Валюта%", Валюты.Функциональная);
	ДекорацияВалютаПредставления = СтрЗаменить(ШаблонДекорацииВалюты, "%Валюта%", Валюты.Представления);
	
	КоэффициентПересчетаВВалютуПредставления = РаботаСКурсамивалютУТ.ПолучитьКоэффициентПересчетаИзВалютыВВалюту(
		Валюты.Функциональная,
		Валюты.Представления,
		?(ЗначениеЗаполнено(Объект.Дата), Объект.Дата, ТекущаяДатаСеанса()));
	
	ОбновитьДоступностьЭлементовФормы();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьДоступностьЭлементовФормы(ИзмененныеРеквизиты=Неопределено)
	
	ОбновитьВсе = (ИзмененныеРеквизиты=Неопределено);
	Реквизиты = Новый Структура(ИзмененныеРеквизиты);
	
	Если ОбновитьВсе Или Реквизиты.Свойство("ПорядокУчета") Тогда
		
		НачислятьАмортизацию = (Объект.ПорядокУчета=Перечисления.ПорядокУчетаСтоимостиВнеоборотныхАктивов.НачислятьАмортизацию);
		Элементы.СтраницаАмортизация.Видимость = НачислятьАмортизацию;
		
	КонецЕсли;
	
	Если ОбновитьВсе Или Реквизиты.Свойство("ПорядокУчета") Или Реквизиты.Свойство("НакопленнаяАмортиазция") Тогда
		
		ТребуетсяУказатьСчетАмортизации = (
			Объект.ПорядокУчета = Перечисления.ПорядокУчетаСтоимостиВнеоборотныхАктивов.НачислятьАмортизацию
			Или Объект.НакопленнаяАмортизация <> 0
			Или Объект.НакопленнаяАмортизацияПредставления <> 0);
		
		Элементы.СчетАмортизации.АвтоОтметкаНезаполненного = ТребуетсяУказатьСчетАмортизации;
		Элементы.СчетАмортизации.ОтметкаНезаполненного = Не ЗначениеЗаполнено(Объект.СчетАмортизации) И ТребуетсяУказатьСчетАмортизации;
		
	КонецЕсли;
	
	Если ОбновитьВсе Или Реквизиты.Свойство("МетодНачисленияАмортизации") Тогда
		
		АмортизацияПоОбъемуПродукции = (Объект.МетодНачисленияАмортизации=Перечисления.СпособыНачисленияАмортизацииНМА.ПропорциональноОбъемуПродукции);
		Элементы.СрокИспользования.АвтоОтметкаНезаполненного = Не АмортизацияПоОбъемуПродукции;
		Элементы.СрокИспользования.ОтметкаНезаполненного = Не АмортизацияПоОбъемуПродукции;
		Элементы.ОбъемНаработки.Видимость = АмортизацияПоОбъемуПродукции;
		Элементы.КоэффициентУскорения.Видимость = (Объект.МетодНачисленияАмортизации=Перечисления.СпособыНачисленияАмортизацииНМА.УменьшаемогоОстатка)
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
