
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПриЧтенииСозданииНаСервере();
	КонецЕсли;
	
	ПараметрыВыбораСтатейИАналитик = Документы.ИзменениеПараметровНМА2_4.ПараметрыВыбораСтатейИАналитик();
	ДоходыИРасходыСервер.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыВыбораСтатейИАналитик);
	
	#Область СтандартныеПодсистемы
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.РаботаСФайлами
	ГиперссылкаФайлов = РаботаСФайлами.ГиперссылкаФайлов();
	ГиперссылкаФайлов.Размещение = "КоманднаяПанель";
	РаботаСФайлами.ПриСозданииНаСервере(ЭтотОбъект, ГиперссылкаФайлов);
	// Конец СтандартныеПодсистемы.РаботаСФайлами
	
	СобытияФорм.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
	#КонецОбласти
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец ИнтеграцияС1СДокументооборотом
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	
	ПриЧтенииСозданииНаСервере();
	
	ПараметрыВыбораСтатейИАналитик = Документы.ИзменениеПараметровНМА2_4.ПараметрыВыбораСтатейИАналитик();
	ДоходыИРасходыСервер.ПриЧтенииНаСервере(ЭтотОбъект, ПараметрыВыбораСтатейИАналитик);
	
	СобытияФорм.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Запись_ИзменениеПараметровНМА2_4", ПараметрыЗаписи, Объект.Ссылка);
	ОбщегоНазначенияУТКлиент.ОповеститьОЗаписиДокументаВЖурнал();
	ВнеоборотныеАктивыКлиент.ОповеститьОЗаписиДокументаВЖурналНМА();

	НастроитьЗависимыеЭлементыФормыНаКлиентеНаСервере(ЭтотОбъект);
	
	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтотОбъект, ПараметрыЗаписи);

	ОбщегоНазначенияУТКлиент.ВыполнитьДействияПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульПодключаемыеКомандыКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ПодключаемыеКомандыКлиент");
		МодульПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	ЗаполнитьИнформациюВПодвале();
	ЗаполнитьТекущиеЗначенияПараметров();
	
	ДоходыИРасходыСервер.ПослеЗаписиНаСервере(ЭтотОбъект);
	
	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	
	СобытияФорм.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	СобытияФормКлиент.ПередЗаписью(ЭтотОбъект, Отказ, ПараметрыЗаписи);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПередЗаписьюНаСервере(
		ЭтотОбъект,
		ТекущийОбъект,
		ПараметрыЗаписи);
	// Конец ИнтеграцияС1СДокументооборотом
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_ИзменениеПараметровНМА2_4" Тогда
		ЗаполнитьИнформациюВПодвале();
	КонецЕсли;
	
	СобытияФормКлиент.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	
	// СтандартныеПодсистемы.РаботаСФайлами
	РаботаСФайламиКлиент.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия);
	// Конец СтандартныеПодсистемы.РаботаСФайлами

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.РаботаСФайлами
	РаботаСФайламиКлиент.ПриОткрытии(ЭтотОбъект, Отказ);
	// Конец СтандартныеПодсистемы.РаботаСФайлами

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ОрганизацияПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	
	ДатаПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ВариантОтраженияВУчетеПриИзменении(Элемент)
	
	ВнеоборотныеАктивыКлиентСервер.ПриИзмененииВариантаОтраженияВУчете(Объект, ВариантОтраженияВУчете, Истина);
		
	НастроитьЗависимыеЭлементыФормыНаКлиентеНаСервере(ЭтотОбъект, "ОтражатьВУпрУчете,ОтражатьВРеглУчете,ОтражатьВБУ,ОтражатьВНУ");
	
КонецПроцедуры

&НаКлиенте
Процедура ПорядокУчетаБУФлагПриИзменении(Элемент)

	НастроитьЗависимыеЭлементыФормыНаКлиентеНаСервере(ЭтотОбъект, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура МетодНачисленияАмортизацииБУФлагПриИзменении(Элемент)
	
	НастроитьЗависимыеЭлементыФормыНаКлиентеНаСервере(ЭтотОбъект, Элемент);

КонецПроцедуры

&НаКлиенте
Процедура СрокИспользованияБУФлагПриИзменении(Элемент)
	
	НастроитьЗависимыеЭлементыФормыНаКлиентеНаСервере(ЭтотОбъект, Элемент);

КонецПроцедуры

&НаКлиенте
Процедура СрокИспользованияБУПриИзменении(Элемент)
	
	НастроитьЗависимыеЭлементыФормыНаКлиентеНаСервере(ЭтотОбъект, Элемент);

КонецПроцедуры

&НаКлиенте
Процедура КоэффициентБУФлагПриИзменении(Элемент)
	
	НастроитьЗависимыеЭлементыФормыНаКлиентеНаСервере(ЭтотОбъект, Элемент);

КонецПроцедуры

&НаКлиенте
Процедура ПорядокУчетаФлагПриИзменении(Элемент)
	
	НастроитьЗависимыеЭлементыФормыНаКлиентеНаСервере(ЭтотОбъект, Элемент);

КонецПроцедуры

&НаКлиенте
Процедура НаправлениеДеятельностиФлагПриИзменении(Элемент)
	
	НастроитьЗависимыеЭлементыФормыНаКлиентеНаСервере(ЭтотОбъект, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура СрокИспользованияУУПриИзменении(Элемент)
	
	НастроитьЗависимыеЭлементыФормыНаКлиентеНаСервере(ЭтотОбъект, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура МетодНачисленияАмортизацииУУФлагПриИзменении(Элемент)
	
	НастроитьЗависимыеЭлементыФормыНаКлиентеНаСервере(ЭтотОбъект, Элемент);

КонецПроцедуры

&НаКлиенте
Процедура ИнформацияОДокументеВДругомУчетеОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "#СоздатьДокумент" Тогда
		СтандартнаяОбработка = Ложь;
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Основание", Объект.Ссылка);
		ОткрытьФорму("Документ.ИзменениеПараметровНМА2_4.ФормаОбъекта", ПараметрыФормы);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СрокИспользованияУУФлагПриИзменении(Элемент)
	
	НастроитьЗависимыеЭлементыФормыНаКлиентеНаСервере(ЭтотОбъект, Элемент);

КонецПроцедуры

&НаКлиенте
Процедура КоэффициентУскоренияУУФлагПриИзменении(Элемент)
	
	НастроитьЗависимыеЭлементыФормыНаКлиентеНаСервере(ЭтотОбъект, Элемент);

КонецПроцедуры

&НаКлиенте
Процедура ЛиквидационнаяСтоимостьРеглФлагПриИзменении(Элемент)
	
	НастроитьЗависимыеЭлементыФормыНаКлиентеНаСервере(ЭтотОбъект, Элемент);

КонецПроцедуры

&НаКлиенте
Процедура ЛиквидационнаяСтоимостьФлагПриИзменении(Элемент)
	
	НастроитьЗависимыеЭлементыФормыНаКлиентеНаСервере(ЭтотОбъект, Элемент);

КонецПроцедуры

&НаКлиенте
Процедура ГруппаФинансовогоУчетаФлагПриИзменении(Элемент)
	
	НастроитьЗависимыеЭлементыФормыНаКлиентеНаСервере(ЭтотОбъект, Элемент);

КонецПроцедуры

&НаКлиенте
Процедура ОбъемНаработкиФлагПриИзменении(Элемент)
	
	НастроитьЗависимыеЭлементыФормыНаКлиентеНаСервере(ЭтотОбъект, Элемент);

КонецПроцедуры

&НаКлиенте
Процедура АмортизационныеРасходыФлагПриИзменении(Элемент)
	
	НастроитьЗависимыеЭлементыФормыНаКлиентеНаСервере(ЭтотОбъект, Элемент);

КонецПроцедуры

&НаКлиенте
Процедура АмортизационныеРасходыПередаватьРасходыВДругуюОрганизациюПриИзменении(Элемент)
	
	СтрокаТаблицы = Элементы.АмортизационныеРасходы.ТекущиеДанные;
	Если Не СтрокаТаблицы.ПередаватьРасходыВДругуюОрганизацию Тогда
		СтрокаТаблицы.ОрганизацияПолучательРасходов = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииРеквизита(Элемент)

	ИзменениеПараметровНМАКлиентЛокализация.ПриИзмененииРеквизита(Элемент.Имя, ЭтотОбъект);

КонецПроцедуры

// СтандартныеПодсистемы.РаботаСФайлами
&НаКлиенте
Процедура Подключаемый_ПолеПредпросмотраНажатие(Элемент, СтандартнаяОбработка)

	РаботаСФайламиКлиент.ПолеПредпросмотраНажатие(ЭтотОбъект, Элемент, СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПолеПредпросмотраПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка)

	РаботаСФайламиКлиент.ПолеПредпросмотраПроверкаПеретаскивания(ЭтотОбъект, Элемент,
				ПараметрыПеретаскивания, СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПолеПредпросмотраПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка)

	РаботаСФайламиКлиент.ПолеПредпросмотраПеретаскивание(ЭтотОбъект, Элемент,
				ПараметрыПеретаскивания, СтандартнаяОбработка);

КонецПроцедуры
// Конец СтандартныеПодсистемы.РаботаСФайлами

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыНМА

&НаКлиенте
Процедура НМАОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ВнеоборотныеАктивыКлиентСервер.ОбработкаВыбораЭлемента(Объект.НМА, "НематериальныйАктив", ВыбранноеЗначение).Количество() <> 0 Тогда
		ПриИзмененииНМАНаСервере();
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура НМАНематериальныйАктивПриИзменении(Элемент)
	
	ПриИзмененииНМАНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыОтражениеРасходов

&НаКлиенте
Процедура АмортизационныеРасходыСтатьяРасходовПриИзменении(Элемент)
	
	ДоходыИРасходыКлиентСервер.СтатьяПриИзменении(ЭтотОбъект, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура АмортизационныеРасходыСтатьяРасходовНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ДоходыИРасходыКлиент.НачалоВыбораСтатьи(ЭтотОбъект, Элемент, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура АмортизационныеРасходыАналитикаРасходовНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ДоходыИРасходыКлиент.НачалоВыбораАналитикиРасходов(ЭтотОбъект, Элемент, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура АмортизационныеРасходыАналитикаРасходовАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	ДоходыИРасходыКлиент.АвтоПодборАналитикиРасходов(ЭтотОбъект, Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура АмортизационныеРасходыАналитикаРасходовОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	ДоходыИРасходыКлиент.ОкончаниеВводаТекстаАналитикиРасходов(ЭтотОбъект, Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подобрать(Команда)
	
	ПараметрыПодбора = ОбщегоНазначенияУТКлиентСервер.ПараметрыПодбора(Элементы.НМАНематериальныйАктив, ЭтотОбъект);
	ОткрытьФорму(
		"Справочник.НематериальныеАктивы.ФормаВыбора",
		ПараметрыПодбора,
		Элементы.НМА,,,,,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьТекущиеЗначения(Команда)
	
	ПоказатьТекущиеЗначения = НЕ ПоказатьТекущиеЗначения;
	Элементы.НМАПоказатьТекущиеЗначения.Пометка = ПоказатьТекущиеЗначения;
	
	НастроитьЗависимыеЭлементыФормыНаКлиентеНаСервере(ЭтотОбъект, "ПоказатьТекущиеЗначения");
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Записать(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Провести(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиИЗакрыть(Команда)
	
	ОбщегоНазначенияУТКлиент.ПровестиИЗакрыть(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Объект);
КонецПроцедуры

#Область ПодключаемыеКоманды

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
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(
		Команда,
		ЭтотОбъект,
		Объект);
	
КонецПроцедуры
// Конец ИнтеграцияС1СДокументооборотом

// СтандартныеПодсистемы.РаботаСФайлами
&НаКлиенте
Процедура Подключаемый_КомандаПанелиПрисоединенныхФайлов(Команда)

	РаботаСФайламиКлиент.КомандаУправленияПрисоединеннымиФайлами(ЭтотОбъект, Команда);

КонецПроцедуры
// Конец СтандартныеПодсистемы.РаботаСФайлами

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура Подключаемый_ЗакрытьФорму()
	
	Закрыть();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	#Область Подразделение
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.АмортизационныеРасходыПодразделение.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.АмортизационныеРасходы.Подразделение");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<Местонахождение НМА>';
																|en = '<Intangible assets location>'"));
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.НезаполненноеПолеТаблицы);
	
	#КонецОбласти

	#Область НеПринятКУчету_Регл
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.НМАНачислятьАмортизациюНУ.Имя);
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.НМАСпециальныйКоэффициентНУ.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.НМА.ПринятКУчетуРегл");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<не принят к учету>';
																|en = '<not recognized>'"));
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.НезаполненноеПолеТаблицы);
	#КонецОбласти
			
	#Область НеПринятКУчету_Упр
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.НМАПорядокУчетаУУ.Имя);
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.НМАМетодНачисленияАмортизацииУУ.Имя);
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.НМАСрокИспользованияУУ.Имя);
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.НМАКоэффициентУскоренияУУ.Имя);
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.НМАЛиквидационнаяСтоимость.Имя);
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.НМАЛиквидационнаяСтоимостьРегл.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.НМА.ПринятКУчетуУпр");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<не принят к учету>';
																|en = '<not recognized>'"));
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.НезаполненноеПолеТаблицы);
	#КонецОбласти
	
	#Область НеПринятКУчету_Обще
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.НМАГруппаФинансовогоУчета.Имя);
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.НМАОбъемНаработки.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.НМА.ПринятКУчетуУпр");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.НМА.ПринятКУчетуРегл");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<не принят к учету>';
																|en = '<not recognized>'"));
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.НезаполненноеПолеТаблицы);
	#КонецОбласти
	
	ИзменениеПараметровНМАЛокализация.УстановитьУсловноеОформление(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()
	
	ЗаполнитьТекущиеЗначенияПараметров();
	
	ВалютаУпр = Константы.ВалютаУправленческогоУчета.Получить();
	ВалютаРегл = ЗначениеНастроекПовтИсп.ВалютаРегламентированногоУчетаОрганизации(Объект.Организация);
	
	ВалютыСовпадают = (ВалютаУпр = ВалютаРегл);
	
	ВедетсяРегламентированныйУчетВНА = ВнеоборотныеАктивыСлужебный.ВедетсяРегламентированныйУчетВНА();
	
	Элементы.НМАЛиквидационнаяСтоимостьРегл.Заголовок = СтрШаблон(НСтр("ru = 'Ликвидационная стоимость (%1)';
																		|en = 'Residual value (%1)'"), Строка(ВалютаРегл));
	Элементы.НМАЛиквидационнаяСтоимость.Заголовок = СтрШаблон(НСтр("ru = 'Ликвидационная стоимость (%1)';
																	|en = 'Residual value (%1)'"), Строка(ВалютаУпр));
	
	ВариантОтраженияВУчете = ВнеоборотныеАктивыКлиентСервер.ВариантОтраженияВУчете(Объект, Истина);
	
	Элементы.ДокументОснование.Видимость = ЗначениеЗаполнено(Объект.ДокументОснование);
	
	ВнеоборотныеАктивы.УстановитьПараметрыФункциональныхОпцийФормыОбъекта(ЭтаФорма, Объект.Организация, Объект.Дата);
	
	ЗаполнитьИнформациюВПодвале();

	НастроитьЗависимыеЭлементыФормыНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОкончанииИзмененияРеквизитаЛокализации(ИмяЭлемента, ПараметрыОповещения) Экспорт

	Перем ПараметрыДействия;
	
	Если ПараметрыОповещения.ПараметрыОбработки.Свойство("Выполнить_НастроитьЗависимыеЭлементыФормы", ПараметрыДействия) Тогда
		НастроитьЗависимыеЭлементыФормыНаКлиентеНаСервере(ЭтотОбъект, ПараметрыДействия);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура НастроитьЗависимыеЭлементыФормыНаКлиентеНаСервере(Форма, Знач ИзмененныеРеквизитыИлиЭлемент = "")
	
	Если ТипЗнч(ИзмененныеРеквизитыИлиЭлемент) = Тип("Строка") Тогда
		ИзмененныеРеквизиты = ИзмененныеРеквизитыИлиЭлемент;
	Иначе
		ИзмененныеРеквизиты = ИзмененныеРеквизитыИлиЭлемент.Имя;
	КонецЕсли;
	
	СтруктураИзмененныхРеквизитов = Новый Структура(ИзмененныеРеквизиты);
	
	ОбновитьВсе = СтруктураИзмененныхРеквизитов.Количество() = 0;
	
	Объект = Форма.Объект;
	Элементы = Форма.Элементы;
	СлужебныеПараметрыФормы = Форма.СлужебныеПараметрыФормы;
	
	ВспомогательныеРеквизиты = Новый Структура;
	ВспомогательныеРеквизиты.Вставить("ВедетсяРегламентированныйУчетВНА", Форма.ВедетсяРегламентированныйУчетВНА);
	ВспомогательныеРеквизиты.Вставить("ВалютыСовпадают", Форма.ВалютыСовпадают);
	ВспомогательныеРеквизиты.Вставить("РеглУчетВНАВедетсяНезависимо", СлужебныеПараметрыФормы.РеглУчетВНАВедетсяНезависимо);
	
	ПараметрыРеквизитовОбъекта = ВнеоборотныеАктивыКлиентСервер.ЗначенияСвойствЗависимыхРеквизитов_ИзменениеПараметровНМА(
									Объект, ВспомогательныеРеквизиты, ИзмененныеРеквизиты);
									
	ОбщегоНазначенияУТКлиентСервер.НастроитьЗависимыеЭлементыФормы(Форма, ПараметрыРеквизитовОбъекта);
	
	Если НЕ ОбновитьВсе Тогда
		ОбщегоНазначенияУТКлиентСервер.ОчиститьНеиспользуемыеРеквизиты(Объект, ПараметрыРеквизитовОбъекта, "НМА,АмортизационныеРасходы");
	КонецЕсли;

	#Область СтраницаОсновное
	
	Если СтруктураИзмененныхРеквизитов.Свойство("Организация")
		ИЛИ СтруктураИзмененныхРеквизитов.Свойство("Дата")
		ИЛИ ОбновитьВсе Тогда
			
		Элементы.ВариантОтраженияВУчете.Видимость = СлужебныеПараметрыФормы.РеглУчетВНАВедетсяНезависимо;
		
		Если НЕ СлужебныеПараметрыФормы.РеглУчетВНАВедетсяНезависимо 
			И НЕ ОбновитьВсе Тогда
			Форма.ВариантОтраженияВУчете = ПредопределенноеЗначение("Перечисление.ВариантыОтраженияВУчетеВнеоборотныхАктивов.УправленческомИРегламентированномУчетах");
			Объект.ОтражатьВРеглУчете = Истина;
			Объект.ОтражатьВУпрУчете = Истина;
			Объект.ОтражатьВБУ = Истина;
			Объект.ОтражатьВНУ = Истина;
		КонецЕсли;
		
	КонецЕсли;
	
	Если СтруктураИзмененныхРеквизитов.Свойство("ОтражатьВУпрУчете")
		ИЛИ СтруктураИзмененныхРеквизитов.Свойство("ОтражатьВРеглУчете")
		ИЛИ ОбновитьВсе Тогда
		
		Элементы.ВариантОтраженияВУчете.Заголовок = 
			?(Форма.ВариантОтраженияВУчете = ПредопределенноеЗначение("Перечисление.ВариантыОтраженияВУчетеВнеоборотныхАктивов.УправленческомИРегламентированномУчетах"),
				НСтр("ru = 'Изменение параметров во';
					|en = 'Parameter change in'"),
				НСтр("ru = 'Изменение параметров в';
					|en = 'Parameter change in'"));
	КонецЕсли;
	
	#КонецОбласти
	
	#Область СтраницаУчет
	
	Если СтруктураИзмененныхРеквизитов.Свойство("СрокИспользованияБУ")
		ИЛИ СтруктураИзмененныхРеквизитов.Свойство("СрокИспользованияБУФлаг")
		ИЛИ ОбновитьВсе Тогда
		
		Форма.СрокИспользованияБУРасшифровка = ВнеоборотныеАктивыКлиентСервер.ПредставлениеКоличестваМесяцевСтрокой(
			Объект.СрокИспользованияБУ);
		
	КонецЕсли;
	
	Если СтруктураИзмененныхРеквизитов.Свойство("СрокИспользованияУУ")
		ИЛИ СтруктураИзмененныхРеквизитов.Свойство("СрокИспользованияНУФлаг")
		ИЛИ ОбновитьВсе Тогда
		
		Форма.СрокИспользованияУУРасшифровка = ВнеоборотныеАктивыКлиентСервер.ПредставлениеКоличестваМесяцевСтрокой(
			Объект.СрокИспользованияУУ);
			
	КонецЕсли;
	
	Если СтруктураИзмененныхРеквизитов.Свойство("ОтражатьВРеглУчете")
		ИЛИ СтруктураИзмененныхРеквизитов.Свойство("ОтражатьВУпрУчете")
		ИЛИ ОбновитьВсе Тогда
		
		Элементы.ЛиквидационнаяСтоимостьРеглВалюта.Видимость = Элементы.ЛиквидационнаяСтоимостьРегл.Видимость;
		Элементы.ЛиквидационнаяСтоимостьВалюта.Видимость = Элементы.ЛиквидационнаяСтоимость.Видимость;
			
	КонецЕсли;

	#КонецОбласти
	
	ОбесценениеВНАКлиентСервер.УправлениеВидимостьюЕГДС(Форма, "ЕГДСФлаг");

	УстановитьВидимостьТекущихЗначений(Форма, ОбновитьВсе, СтруктураИзмененныхРеквизитов);
	
	ВнеоборотныеАктивыКлиентСерверЛокализация.НастроитьЗависимыеЭлементыФормы_ИзменениеПараметровНМА(
		Форма, СтруктураИзмененныхРеквизитов);
	
КонецПроцедуры

&НаСервере
Процедура НастроитьЗависимыеЭлементыФормыНаСервере(Знач ИзмененныеРеквизиты = "")
	
	СтруктураИзмененныхРеквизитов = Новый Структура(ИзмененныеРеквизиты);
	
	ОбновитьВсе = СтруктураИзмененныхРеквизитов.Количество() = 0;
	
	Если СтруктураИзмененныхРеквизитов.Свойство("Организация") 
		ИЛИ ОбновитьВсе Тогда
		ВалютаРегл = ЗначениеНастроекПовтИсп.ВалютаРегламентированногоУчетаОрганизации(Объект.Организация);
	КонецЕсли;
	
	Если СтруктураИзмененныхРеквизитов.Свойство("Организация") 
		ИЛИ СтруктураИзмененныхРеквизитов.Свойство("Дата")
		ИЛИ ОбновитьВсе Тогда
			
		ВнеоборотныеАктивы.УстановитьПараметрыФункциональныхОпцийФормыОбъекта(ЭтотОбъект, Объект.Организация, Объект.Дата);
		
		ВнеоборотныеАктивыСлужебный.УстановитьСвойствоСтруктуры(
			"РеглУчетВНАВедетсяНезависимо",
			НастройкиНалоговУчетныхПолитикПовтИсп.РеглУчетВНАВедетсяНезависимо(Объект.Организация, КонецМесяца(?(Объект.Дата <> '000101010000', Объект.Дата, ТекущаяДатаСеанса()))),
			СлужебныеПараметрыФормы);
			
	КонецЕсли;
	
	ИзменениеПараметровНМАЛокализация.НастроитьЗависимыеЭлементыФормы(ЭтотОбъект, СтруктураИзмененныхРеквизитов);
	
	НастроитьЗависимыеЭлементыФормыНаКлиентеНаСервере(ЭтотОбъект, ИзмененныеРеквизиты);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьИнформациюВПодвале()
	
	ЗаголовокНадписи = ВнеоборотныеАктивыСлужебный.ИнформацияОДокументеВДругомУчете(Объект, Ложь);

	ИзменениеПараметровНМАЛокализация.ДополнитьИнформациюВПодвале(Объект, ЗаголовокНадписи);
	
	Если ЗаголовокНадписи.Количество() <> 0 Тогда
		Элементы.Информация.Заголовок = Новый ФорматированнаяСтрока(ЗаголовокНадписи);
		Элементы.КартинкаИнформация.Видимость = Истина;
		Элементы.Информация.Видимость = Истина;
	Иначе
		Элементы.КартинкаИнформация.Видимость = Ложь;
		Элементы.Информация.Видимость = Ложь;
	КонецЕсли; 
	
КонецПроцедуры

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()
	
	ЗаполнитьТекущиеЗначенияПараметров();

	НастроитьЗависимыеЭлементыФормыНаСервере("Организация");
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьВидимостьТекущихЗначений(Форма, ОбновитьВсе, СтруктураИзмененныхРеквизитов)

	Элементы = Форма.Элементы; 
	Объект = Форма.Объект;
	
	СвойстваБУ  = Новый Массив;
	СвойстваБУ.Добавить(ВнеоборотныеАктивыКлиентСервер.ИменаРеквизитовДанныеФлаг("ПорядокУчетаБУ", "ПорядокУчетаБУФлаг"));
	СвойстваБУ.Добавить(ВнеоборотныеАктивыКлиентСервер.ИменаРеквизитовДанныеФлаг("КоэффициентБУ", "КоэффициентБУФлаг"));
	СвойстваБУ.Добавить(ВнеоборотныеАктивыКлиентСервер.ИменаРеквизитовДанныеФлаг("СрокИспользованияБУ", "СрокИспользованияБУФлаг"));
	СвойстваБУ.Добавить(ВнеоборотныеАктивыКлиентСервер.ИменаРеквизитовДанныеФлаг("МетодНачисленияАмортизацииБУ", "МетодНачисленияАмортизацииБУФлаг"));
	

	СвойстваУУ  = Новый Массив;
	СвойстваУУ.Добавить(ВнеоборотныеАктивыКлиентСервер.ИменаРеквизитовДанныеФлаг("ПорядокУчетаУУ", "ПорядокУчетаУУФлаг"));
	СвойстваУУ.Добавить(ВнеоборотныеАктивыКлиентСервер.ИменаРеквизитовДанныеФлаг("МетодНачисленияАмортизацииУУ", "МетодНачисленияАмортизацииУУФлаг"));
	СвойстваУУ.Добавить(ВнеоборотныеАктивыКлиентСервер.ИменаРеквизитовДанныеФлаг("СрокИспользованияУУ", "СрокИспользованияУУФлаг"));
	СвойстваУУ.Добавить(ВнеоборотныеАктивыКлиентСервер.ИменаРеквизитовДанныеФлаг("КоэффициентУскоренияУУ", "КоэффициентУскоренияУУФлаг"));
	
	СвойстваОбщ = Новый Массив;
	СвойстваОбщ.Добавить(ВнеоборотныеАктивыКлиентСервер.ИменаРеквизитовДанныеФлаг("ГруппаФинансовогоУчета", "ГруппаФинансовогоУчетаФлаг"));
	СвойстваОбщ.Добавить(ВнеоборотныеАктивыКлиентСервер.ИменаРеквизитовДанныеФлаг("ОбъемНаработки", "ОбъемНаработкиФлаг"));
	СвойстваОбщ.Добавить(ВнеоборотныеАктивыКлиентСервер.ИменаРеквизитовДанныеФлаг("НаправлениеДеятельности","НаправлениеДеятельностиФлаг"));
	СвойстваОбщ.Добавить(ВнеоборотныеАктивыКлиентСервер.ИменаРеквизитовДанныеФлаг("ЛиквидационнаяСтоимость", "ЛиквидационнаяСтоимостьФлаг"));
	СвойстваОбщ.Добавить(ВнеоборотныеАктивыКлиентСервер.ИменаРеквизитовДанныеФлаг("ЛиквидационнаяСтоимостьРегл", "ЛиквидационнаяСтоимостьРеглФлаг"));
	
	КоличествоСвойствЛокализация = 0;
	КоличествоСвойствБУ = 0;
	КоличествоСвойствУУ = 0;
	КоличествоСвойствОбщ = 0;
	
	Для каждого ЭлементМассива Из СвойстваБУ Цикл
		
		ВнеоборотныеАктивыКлиентСервер.УстановитьВидимостьТекущегоЗначенияПараметраПриИзмененииПараметров(
			Форма, Неопределено, ЭлементМассива, "НМА", СтруктураИзмененныхРеквизитов);
			
		КоличествоСвойствБУ = КоличествоСвойствБУ + ?(Объект[ЭлементМассива.ИмяРеквизитаФлаг], 1, 0);
		
	КонецЦикла;

	Для каждого ЭлементМассива Из СвойстваУУ Цикл
		
		ВнеоборотныеАктивыКлиентСервер.УстановитьВидимостьТекущегоЗначенияПараметраПриИзмененииПараметров(
			Форма, Неопределено, ЭлементМассива, "НМА", СтруктураИзмененныхРеквизитов);
			
		КоличествоСвойствУУ = КоличествоСвойствУУ + ?(Объект[ЭлементМассива.ИмяРеквизитаФлаг], 1, 0);
		
	КонецЦикла;
	
	Для каждого ЭлементМассива Из СвойстваОбщ Цикл
		
		ВнеоборотныеАктивыКлиентСервер.УстановитьВидимостьТекущегоЗначенияПараметраПриИзмененииПараметров(
			Форма, Неопределено, ЭлементМассива, "НМА", СтруктураИзмененныхРеквизитов);
			
		КоличествоСвойствОбщ = КоличествоСвойствОбщ + ?(Объект[ЭлементМассива.ИмяРеквизитаФлаг], 1, 0);
		
	КонецЦикла;
	
	ВнеоборотныеАктивыКлиентСерверЛокализация.УстановитьВидимостьТекущихЗначений_ИзменениеПараметровНМА(
		Форма, КоличествоСвойствУУ + КоличествоСвойствБУ, КоличествоСвойствОбщ, КоличествоСвойствЛокализация, СтруктураИзмененныхРеквизитов);
	
	Если Форма.ПоказатьТекущиеЗначения Тогда
		
		ОтображатьВШапке = КоличествоСвойствЛокализация <> 0;
		Если Элементы.НМАГруппаУУ.ОтображатьВШапке <> ОтображатьВШапке Тогда
			Элементы.НМАГруппаУУ.ОтображатьВШапке = ОтображатьВШапке;
		КонецЕсли;
		
		Если Элементы.НМАГруппаОбщее.ОтображатьВШапке <> ОтображатьВШапке Тогда
			Элементы.НМАГруппаОбщее.ОтображатьВШапке = ОтображатьВШапке;
		КонецЕсли;
		
	КонецЕсли;

	Форма.КоличествоИзмененныхСвойств = КоличествоСвойствЛокализация + КоличествоСвойствУУ + КоличествоСвойствБУ + КоличествоСвойствОбщ;

	Если Форма.ПоказатьТекущиеЗначения 
		И Форма.КоличествоИзмененныхСвойств > 0
		И Элементы.НМАНематериальныйАктив.ФиксацияВТаблице <> ФиксацияВТаблице.Лево Тогда
		
		Элементы.НМАНематериальныйАктив.ФиксацияВТаблице = ФиксацияВТаблице.Лево;
		
	ИначеЕсли (НЕ Форма.ПоказатьТекущиеЗначения 
				ИЛИ Форма.КоличествоИзмененныхСвойств = 0)
		И Элементы.НМАНематериальныйАктив.ФиксацияВТаблице <> ФиксацияВТаблице.Нет Тогда
		
		Элементы.НМАНематериальныйАктив.ФиксацияВТаблице = ФиксацияВТаблице.Нет;
		
	КонецЕсли; 
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТекущиеЗначенияПараметров()
	
	Если Объект.НМА.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;

	ТекстЗапроса = ИзменениеПараметровНМАЛокализация.ТекстЗапросаДляЗаполненияТекущихЗначенийПараметров();
	
	Если ТекстЗапроса = Неопределено Тогда
		
		ТекстЗапроса = 
		"ВЫБРАТЬ
		|	НематериальныеАктивы.Ссылка КАК НематериальныйАктив,
		|	ЕСТЬNULL(ПорядокУчетаНМА.ГруппаФинансовогоУчета, НЕОПРЕДЕЛЕНО) КАК ГруппаФинансовогоУчета,
		|	ЕСТЬNULL(ПорядокУчетаНМА.НаправлениеДеятельности, НЕОПРЕДЕЛЕНО) КАК НаправлениеДеятельности,
		|	ЕСТЬNULL(ПорядокУчетаНМА.ОбъемНаработки, НЕОПРЕДЕЛЕНО) КАК ОбъемНаработки,
		|	ЕСТЬNULL(ПараметрыАмортизацииНМАБУ.СрокПолезногоИспользованияБУ, 0) КАК СрокИспользованияБУ,
		|	ЕСТЬNULL(ПараметрыАмортизацииНМАУУ.СрокИспользования, 0) КАК СрокИспользованияУУ,
		|	ЕСТЬNULL(ПараметрыАмортизацииНМАУУ.КоэффициентУскорения, 0) КАК КоэффициентУскоренияУУ,
		|	ЕСТЬNULL(ПараметрыАмортизацииНМАУУ.МетодНачисленияАмортизации, НЕОПРЕДЕЛЕНО) КАК МетодНачисленияАмортизацииУУ,
		|	ЕСТЬNULL(ПараметрыАмортизацииНМАУУ.ЛиквидационнаяСтоимость, 0) КАК ЛиквидационнаяСтоимость,
		|	ЕСТЬNULL(ПараметрыАмортизацииНМАБУ.ЛиквидационнаяСтоимость, 0) КАК ЛиквидационнаяСтоимостьРегл,
		|	ВЫБОР 
		|		КОГДА ЕСТЬNULL(ПорядокУчетаНМАУУ.НачислятьАмортизациюУУ, ЛОЖЬ) 
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ПорядокУчетаСтоимостиВнеоборотныхАктивов.НачислятьАмортизацию)
		|		ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.ПорядокУчетаСтоимостиВнеоборотныхАктивов.НеНачислятьАмортизацию)
		|	КОНЕЦ КАК ПорядокУчетаУУ,
		|	ВЫБОР 
		|		КОГДА ЕСТЬNULL(ПорядокУчетаНМАБУ.НачислятьАмортизациюБУ, ЛОЖЬ) 
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ПорядокУчетаСтоимостиВнеоборотныхАктивов.НачислятьАмортизацию)
		|		ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.ПорядокУчетаСтоимостиВнеоборотныхАктивов.НеНачислятьАмортизацию)
		|	КОНЕЦ КАК ПорядокУчетаБУ,
		|	ЕСТЬNULL(ПервоначальныеСведенияНМА.ДокументПринятияКУчетуУУ, ДАТАВРЕМЯ(1, 1, 1)) <> ДАТАВРЕМЯ(1, 1, 1) КАК ПринятКУчетуУпр,
		|	ЕСТЬNULL(ПараметрыАмортизацииНМАБУ.КоэффициентБУ, 0) КАК КоэффициентБУ,
		|	ЕСТЬNULL(ПервоначальныеСведенияНМА.МетодНачисленияАмортизацииБУ, 0) КАК МетодНачисленияАмортизацииБУ,
		|	ЕСТЬNULL(ПервоначальныеСведенияНМА.ДокументПринятияКУчетуБУ, ДАТАВРЕМЯ(1, 1, 1)) <> ДАТАВРЕМЯ(1, 1, 1) КАК ПринятКУчетуРегл
		|
		|ИЗ
		|	Справочник.НематериальныеАктивы КАК НематериальныеАктивы
		|
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПараметрыАмортизацииНМАБУ.СрезПоследних(
		|				&Период,
		|				Организация = &Организация
		|					И Регистратор <> &Ссылка
		|					И НематериальныйАктив В (&СписокНМА)) КАК ПараметрыАмортизацииНМАБУ
		|		ПО (ПараметрыАмортизацииНМАБУ.НематериальныйАктив = НематериальныеАктивы.Ссылка)
		|
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПараметрыАмортизацииНМАУУ.СрезПоследних(
		|				&Период,
		|				Организация = &Организация
		|					И Регистратор <> &Ссылка
		|					И НематериальныйАктив В (&СписокНМА)) КАК ПараметрыАмортизацииНМАУУ
		|		ПО (ПараметрыАмортизацииНМАУУ.НематериальныйАктив = НематериальныеАктивы.Ссылка)
		|
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПорядокУчетаНМА.СрезПоследних(
		|				&Период,
		|				Регистратор <> &Ссылка
		|					И Организация = &Организация
		|					И НематериальныйАктив В (&СписокНМА)) КАК ПорядокУчетаНМА
		|		ПО (ПорядокУчетаНМА.НематериальныйАктив = НематериальныеАктивы.Ссылка)
		|
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПорядокУчетаНМАУУ.СрезПоследних(
		|				&Период,
		|				Организация = &Организация
		|					И Регистратор <> &Ссылка
		|					И НематериальныйАктив В (&СписокНМА)) КАК ПорядокУчетаНМАУУ
		|		ПО (ПорядокУчетаНМАУУ.НематериальныйАктив = НематериальныеАктивы.Ссылка)
		|
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПорядокУчетаНМАБУ.СрезПоследних(
		|				&Период,
		|				Организация = &Организация
		|					И Регистратор <> &Ссылка
		|					И НематериальныйАктив В (&СписокНМА)) КАК ПорядокУчетаНМАБУ
		|		ПО (ПорядокУчетаНМАБУ.НематериальныйАктив = НематериальныеАктивы.Ссылка)
		|
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПервоначальныеСведенияНМА.СрезПоследних(
		|				,
		|				Организация = &Организация
		|					И НематериальныйАктив В (&СписокНМА)) КАК ПервоначальныеСведенияНМА
		|		ПО (ПервоначальныеСведенияНМА.НематериальныйАктив = НематериальныеАктивы.Ссылка)";
	КонецЕсли;
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("СписокНМА", Объект.НМА.Выгрузить().ВыгрузитьКолонку("НематериальныйАктив"));
	Запрос.УстановитьПараметр("Организация", Объект.Организация);
	Запрос.УстановитьПараметр("Ссылка", Объект.Ссылка);
	Запрос.УстановитьПараметр("Период", КонецДня(?(ЗначениеЗаполнено(Объект.Дата), Объект.Дата, ТекущаяДатаСеанса())));
	
	УстановитьПривилегированныйРежим(Истина);
	Результат = Запрос.Выполнить().Выгрузить();
	УстановитьПривилегированныйРежим(Ложь);
	
	Для каждого ДанныеСтроки Из Объект.НМА Цикл
		ТекущиеЗначения = Результат.Найти(ДанныеСтроки.НематериальныйАктив, "НематериальныйАктив");
		Если ТекущиеЗначения <> Неопределено Тогда
			ЗаполнитьЗначенияСвойств(ДанныеСтроки, ТекущиеЗначения);
		Иначе
			ДанныеСтроки.ПринятКУчетуРегл = Ложь;
			ДанныеСтроки.ПринятКУчетуУпр = Ложь;
		КонецЕсли; 
	КонецЦикла; 
	
КонецПроцедуры

&НаСервере
Процедура ДатаПриИзмененииНаСервере()
		
	ЗаполнитьИнформациюВПодвале();
	ЗаполнитьТекущиеЗначенияПараметров();

	НастроитьЗависимыеЭлементыФормыНаСервере("Дата");
	
КонецПроцедуры

&НаСервере
Процедура ПриИзмененииНМАНаСервере()
	
	ЗаполнитьШапкуПоВыбраннымНМА();
	ЗаполнитьТекущиеЗначенияПараметров();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьШапкуПоВыбраннымНМА()

	ИзмененныеРеквизиты = "НематериальныйАктив";
	ВнеоборотныеАктивыСлужебный.ЗаполнитьШапкуПоВыбраннымНМА(
		"Организация", 
		Объект.НМА, 
		Объект, 
		ИзмененныеРеквизиты);
	
	НастроитьЗависимыеЭлементыФормыНаКлиентеНаСервере(ЭтотОбъект, ИзмененныеРеквизиты);
	
КонецПроцедуры

#КонецОбласти
