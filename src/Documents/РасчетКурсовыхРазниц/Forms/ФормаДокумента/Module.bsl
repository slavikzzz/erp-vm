
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	Если Объект.Ссылка.Пустая() Тогда
		Объект.ПереоценкаПоДням = Константы.ПереоцениватьВалютныеСредстваПоДням.Получить();
	КонецЕсли;
	
	СписокВыбора = Элементы.ХозяйственнаяОперация.СписокВыбора;
	ДенежныеСредстваСервер.УстановитьВидимостьОперацийПоДоговорамКредитовИДепозитов(Элементы.ХозяйственнаяОперация);
	
	//++ НЕ УТ
	Если ВнеоборотныеАктивы.ИспользуетсяУправлениеВНА() Тогда
		ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПереоценкаФинансовыхИнструментов;
		ЭлементСписка = СписокВыбора.НайтиПоЗначению(ХозяйственнаяОперация);
		Если ЭлементСписка = Неопределено Тогда
			СписокВыбора.Добавить(ХозяйственнаяОперация, НСтр("ru = 'Финансовые инструменты';
																|en = 'Financial instruments'"));
		КонецЕсли;
	КонецЕсли;
	//++ Локализация
	УстановитьВидимостьКомандыПерезаполненияРегистровНУ();
	//-- Локализация
	
	//-- НЕ УТ
	
	// Контроль создания документа в подчиненном узле РИБ с фильтрами
	ОбменДаннымиУТУП.КонтрольСозданияДокументовВРаспределеннойИБ(Объект, Отказ);

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

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
	
	ПереоценкаПоДням = ТекущийОбъект.ПереоценкаПоДням;
	МодификацияКонфигурацииПереопределяемый.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)

	ТекущийОбъект.ПереоценкаПоДням = ПереоценкаПоДням;
	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);

	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);
	// Конец ИнтеграцияС1СДокументооборотом
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом

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

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ХозяйственнаяОперацияПриИзменении(Элемент)
	//++ НЕ УТ
	
	//++ Локализация
	УстановитьВидимостьКомандыПерезаполненияРегистровНУ();
	//-- Локализация
	
	//-- НЕ УТ
	
	Возврат;
	
КонецПроцедуры

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(
		Элемент.ТекстРедактирования, 
		ЭтотОбъект, 
		"Объект.Комментарий");
	
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
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

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
Процедура ПерезаполнитьРегистрыНУ(Команда)
	//++ НЕ УТ
	
	//++ Локализация
	ШаблонВопроса = НСтр("ru = 'По организации %Организация% будут перезаполнены остатки и обороты 
		|в регистрах налогового учета по %расчетам% за период с %НачалоПериода% до %КонецПериода%.
		|После этого необходимо рассчитать курсовые разницы и закрыть периоды начиная с текущего.
		|Перезаполнение регистров не оказывает влияние на закрытие месяца.
		|Продолжить?';
		|en = 'For company %Организация%, balances and turnovers will be refilled 
		|in tax accounting registers by %расчетам% from %НачалоПериода% to %КонецПериода%.
		|After that, calculate the exchange differences and close the periods starting from the current one.
		|Register refilling does not affect month-end closing.
		|Continue?'");
	
	ТекстВопроса = СтрЗаменить(ШаблонВопроса, "%Организация%", Объект.Организация);
	Если Объект.ХозяйственнаяОперация = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ПереоценкаРасчетовСКлиентами") Тогда
		ТекстВопроса = СтрЗаменить(ТекстВопроса, "%расчетам%", НСтр("ru = 'расчетам с клиентами';
																	|en = 'customer AR/AP'"));
	ИначеЕсли Объект.ХозяйственнаяОперация = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ПереоценкаРасчетовСПоставщиками") Тогда
		ТекстВопроса = СтрЗаменить(ТекстВопроса, "%расчетам%", НСтр("ru = 'расчетам с поставщиками';
																	|en = 'vendor AR/AP'"));
	ИначеЕсли Объект.ХозяйственнаяОперация = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ПереоценкаФинансовыхИнструментов") Тогда
		ТекстВопроса = СтрЗаменить(ТекстВопроса, "%расчетам%", НСтр("ru = 'финансовым инструментам';
																	|en = 'financial instruments'"));
	ИначеЕсли Объект.ХозяйственнаяОперация = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ПереоценкаРасчетовПоАренде") Тогда
		ТекстВопроса = СтрЗаменить(ТекстВопроса, "%расчетам%", НСтр("ru = 'арендным расчетам';
																	|en = 'rental AR/AP'"));
	ИначеЕсли Объект.ХозяйственнаяОперация = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ПереоценкаДенежныхСредств") Тогда
		ТекстВопроса = НСтр("ru = 'По организации %Организация% будет перезаполнен регистр сведений ""Расчет переоценки валютных средств НУ""
		|за период с %НачалоПериода% до %КонецПериода%.
		|После этого необходимо рассчитать курсовые разницы и закрыть периоды начиная с текущего.
		|Перезаполнение регистр не оказывает влияние на закрытие месяца.
		|Продолжить?';
		|en = 'For company %Организация%, the ""Calculation of TA currency revaluation"" information register will be refilled
		|for the period from %НачалоПериода% to %КонецПериода%.
		|After that, calculate the exchange differences and close the periods starting from the current one.
		|Register refilling does not affect month-end closing.
		|Continue?'");
		ТекстВопроса = СтрЗаменить(ТекстВопроса, "%Организация%", Объект.Организация);
	КонецЕсли;
	ТекстВопроса = СтрЗаменить(ТекстВопроса, "%НачалоПериода%", Формат(Дата(2022,1,1), "ДЛФ=DD"));
	ТекстВопроса = СтрЗаменить(ТекстВопроса, "%КонецПериода%", Формат(НачалоМесяца(Объект.Дата), "ДЛФ=DD"));
	
	ПоказатьВопрос(Новый ОписаниеОповещения("ПерезаполнитьРегистрыНУЗавершение", ЭтотОбъект), ТекстВопроса,РежимДиалогаВопрос.ДаНет);
	//-- Локализация
	
	//-- НЕ УТ
	
	Возврат;
	
КонецПроцедуры

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры
// Конец ИнтеграцияС1СДокументооборотом
#КонецОбласти

#Область СлужебныеПроцедурыИФункции
//++ НЕ УТ

//++ Локализация
&НаСервере
Процедура УстановитьВидимостьКомандыПерезаполненияРегистровНУ()
	
	Элементы.ФормаПерезаполнитьРегистрыНУ.Видимость = ПолучитьФункциональнуюОпцию("ЛокализацияРФ")
		И НЕ ПолучитьФункциональнуюОпцию("УправлениеТорговлей")
		И (Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПереоценкаРасчетовСКлиентами
			ИЛИ Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПереоценкаРасчетовСПоставщиками
			ИЛИ Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПереоценкаФинансовыхИнструментов
			ИЛИ Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПереоценкаРасчетовПоАренде
			ИЛИ Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПереоценкаДенежныхСредств)
		И Объект.Дата >= РегистрыСведений.НастройкиУчетаНалогаНаПрибыль.НачалоВступленияВСилу67ФЗ();
	
КонецПроцедуры

&НаКлиенте
Процедура ПерезаполнитьРегистрыНУЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		ВыполнитьПерезаполнениеРегистровНУ();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьПерезаполнениеРегистровНУ()
	 
	ДлительнаяОперация = НачатьВыполнениеНаСервере();
	ОповещениеОЗавершении = Новый ОписаниеОповещения("ОбработатьРезультат", ЭтотОбъект);
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, ОповещениеОЗавершении, ПараметрыОжидания);
	
КонецПроцедуры

&НаСервере
Функция НачатьВыполнениеНаСервере()
	
	Если Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПереоценкаРасчетовСКлиентами Тогда
		Возврат ДлительныеОперации.ВыполнитьПроцедуру(,
					"ОперативныеВзаиморасчетыСервер.ПерезаполнитьОборотыНУ", Объект.Организация, Объект.Дата, Истина);
		
	ИначеЕсли Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПереоценкаРасчетовСПоставщиками Тогда
		Возврат ДлительныеОперации.ВыполнитьПроцедуру(,
					"ОперативныеВзаиморасчетыСервер.ПерезаполнитьОборотыНУ", Объект.Организация, Объект.Дата, Ложь);
		
	ИначеЕсли (Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПереоценкаФинансовыхИнструментов
				ИЛИ Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПереоценкаРасчетовПоАренде) Тогда
		Возврат ДлительныеОперации.ВыполнитьПроцедуру(,
					"Документы.РасчетКурсовыхРазниц.ПерезаполнитьОборотыНУ", Объект.Организация, Объект.Дата, Объект.ХозяйственнаяОперация);
		
	ИначеЕсли Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПереоценкаДенежныхСредств Тогда
		Возврат ДлительныеОперации.ВыполнитьПроцедуру(,
					"Документы.РасчетКурсовыхРазниц.ПерезаполнитьОборотыНУ", Объект.Организация, Объект.Дата, Объект.ХозяйственнаяОперация);
		
	ИначеЕсли Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПереоценкаДенежныхСредств Тогда
		Возврат ДлительныеОперации.ВыполнитьПроцедуру(,
					"Документы.РасчетКурсовыхРазниц.ПерезаполнитьРасшифровкуРасчетаНУДляДС", Объект.Организация, Объект.Дата);
		
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура ОбработатьРезультат(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;

	Если Результат.Статус = "Ошибка" Тогда
		ВызватьИсключение Результат.ПодробноеПредставлениеОшибки;
	КонецЕсли;
 
КонецПроцедуры
//-- Локализация

//-- НЕ УТ

#КонецОбласти
