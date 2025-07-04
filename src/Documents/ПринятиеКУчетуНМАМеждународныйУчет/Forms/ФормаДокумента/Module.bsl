
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПриСозданииЧтенииНаСервере();
	КонецЕсли;
	
	ПараметрыВыбораСтатейИАналитик = Документы.ПринятиеКУчетуНМАМеждународныйУчет.ПараметрыВыбораСтатейИАналитик();
	ДоходыИРасходыСервер.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыВыбораСтатейИАналитик);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ИнтеграцияС1СДокументооборотом
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// Обработчик механизма "ДатыЗапретаИзменения"
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	ПриСозданииЧтенииНаСервере();
	
	ПараметрыВыбораСтатейИАналитик = Документы.ПринятиеКУчетуНМАМеждународныйУчет.ПараметрыВыбораСтатейИАналитик();
	ДоходыИРасходыСервер.ПриЧтенииНаСервере(ЭтотОбъект, ПараметрыВыбораСтатейИАналитик);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	Элементы.СтраницаКомментарий.Картинка = ОбщегоНазначенияКлиентСервер.КартинкаКомментария(Объект.Комментарий);
	
	ДоходыИРасходыСервер.ПослеЗаписиНаСервере(ЭтотОбъект);
	
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

&НаКлиенте
Процедура СчетРасходовПриИзменении(Элемент)
	ОбновитьДоступностьЭлементовФормы("СчетРасходов");
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


&НаКлиенте
Процедура ЗаписатьДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Записать(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПервоначальнуюСтоимость(Команда)
	ЗаполнитьПервоначальнуюСтоимостьНаСервере();
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПервоначальнуюСтоимостьНаСервере()
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	СУММА(МеждународныйОстаткиИОбороты.СуммаНачальныйОстатокДт + МеждународныйОстаткиИОбороты.СуммаОборотДт) КАК ПервоначальнаяСтоимость,
		|	СУММА(МеждународныйОстаткиИОбороты.СуммаПредставленияНачальныйОстатокДт + МеждународныйОстаткиИОбороты.СуммаПредставленияОборотДт) КАК ПервоначальнаяСтоимостьПредставления
		|ИЗ
		|	РегистрБухгалтерии.Международный.ОстаткиИОбороты(
		|			&МесяцНачало,
		|			&МесяцОкончание,
		|			,
		|			,
		|			Счет = &Счет,
		|			,
		|			Организация = &Организация
		|				И Подразделение = &Подразделение
		|				И Субконто1 = &НематериальныйАктив) КАК МеждународныйОстаткиИОбороты");
	
	Запрос.УстановитьПараметр("Счет", Объект.СчетКапитальныхВложений);
	Запрос.УстановитьПараметр("Организация", Объект.Организация);
	Запрос.УстановитьПараметр("Подразделение", Объект.Подразделение);
	Запрос.УстановитьПараметр("МесяцНачало", НачалоМесяца(Объект.Дата));
	Запрос.УстановитьПараметр("МесяцОкончание", Новый Граница(КонецМесяца(Объект.Дата), ВидГраницы.Включая));
	Запрос.УстановитьПараметр("НематериальныйАктив", Объект.НематериальныйАктив);
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Объект.ПервоначальнаяСтоимость = 0;
		Объект.ПервоначальнаяСтоимостьПредставления = 0;
	Иначе
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
		Объект.ПервоначальнаяСтоимость = Выборка.ПервоначальнаяСтоимость;
		Объект.ПервоначальнаяСтоимостьПредставления = Выборка.ПервоначальнаяСтоимостьПредставления;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиИЗакрыть(Команда)
	
	ОбщегоНазначенияУТКлиент.ПровестиИЗакрыть(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Провести(ЭтаФорма);
	
КонецПроцедуры

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры
// Конец ИнтеграцияС1СДокументооборотом

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПриСозданииЧтенииНаСервере()
	
	Элементы.СтраницаКомментарий.Картинка = ОбщегоНазначенияКлиентСервер.КартинкаКомментария(Объект.Комментарий);
	
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
		Списывать = (Объект.ПорядокУчета=Перечисления.ПорядокУчетаСтоимостиВнеоборотныхАктивов.СписыватьПриПринятииКУчету);
		
		Элементы.ГруппаСчетАмортизации.Видимость = НачислятьАмортизацию;
		Элементы.СтраницаАмортизация.Видимость = НачислятьАмортизацию;
		Элементы.ГруппаСчетРасходов.Видимость = Списывать;
		Элементы.ГруппаСубконтоСчетаРасходов.Видимость = Списывать;
		
		Если Списывать Тогда
			Реквизиты.Вставить("СчетРасходов");
		КонецЕсли;
		
	КонецЕсли;
	
	Если ОбновитьВсе Или Реквизиты.Свойство("МетодНачисленияАмортизации") Тогда
		
		АмортизацияПоОбъемуПродукции = (Объект.МетодНачисленияАмортизации=Перечисления.СпособыНачисленияАмортизацииНМА.ПропорциональноОбъемуПродукции);
		Элементы.СрокИспользования.АвтоОтметкаНезаполненного = Не АмортизацияПоОбъемуПродукции;
		Элементы.СрокИспользования.ОтметкаНезаполненного = Не АмортизацияПоОбъемуПродукции;
		Элементы.ОбъемНаработки.Видимость = АмортизацияПоОбъемуПродукции;
		Элементы.КоэффициентУскорения.Видимость = (Объект.МетодНачисленияАмортизации=Перечисления.СпособыНачисленияАмортизацииНМА.УменьшаемогоОстатка)
		
	КонецЕсли;
	
	Если ОбновитьВсе Или Реквизиты.Свойство("СчетРасходов") Тогда
		
		Если ЗначениеЗаполнено(Объект.СчетРасходов) Тогда
			Элементы.ГруппаСубконтоСчетаРасходов.Видимость = Истина;
			ОбновитьЗаголовкиСубконтоСчетаРасходов();
		Иначе
			Элементы.ГруппаСубконтоСчетаРасходов.Видимость = Ложь;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьЗаголовкиСубконтоСчетаРасходов()
	
	Элементы.СчетРасходовСубконто1.Видимость = Ложь;
	Элементы.СчетРасходовСубконто2.Видимость = Ложь;
	Элементы.СчетРасходовСубконто3.Видимость = Ложь;
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ ПЕРВЫЕ 3
		|	СубконтоСчета.ВидСубконто.Наименование КАК Заголовок,
		|	СубконтоСчета.ВидСубконто.ТипЗначения КАК ТипЗначения
		|ИЗ
		|	ПланСчетов.Международный.ВидыСубконто КАК СубконтоСчета
		|ГДЕ
		|	СубконтоСчета.Ссылка = &Ссылка
		|
		|УПОРЯДОЧИТЬ ПО
		|	СубконтоСчета.НомерСтроки"
	);
	Запрос.УстановитьПараметр("Ссылка", Объект.СчетРасходов);
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	Индекс = 1;
	Выборка = Результат.Выбрать();
	Пока Выборка.Следующий() Цикл
		Элементы["СчетРасходовСубконто"+Формат(Индекс, "ЧГ=0")].Заголовок = "   " + Выборка.Заголовок;
		Элементы["СчетРасходовСубконто"+Формат(Индекс, "ЧГ=0")].ОграничениеТипа = Выборка.ТипЗначения;
		Элементы["СчетРасходовСубконто"+Формат(Индекс, "ЧГ=0")].Видимость = Истина;
		Индекс = Индекс + 1;
	КонецЦикла;
	
КонецПроцедуры

#Область СтандартныеПодсистемы_ДополнительныеОтчетыИОбработки

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

#КонецОбласти

#КонецОбласти
