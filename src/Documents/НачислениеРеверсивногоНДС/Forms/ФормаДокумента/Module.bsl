
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец ИнтеграцияС1СДокументооборотом
	
	// СтандартныеПодсистемы.Свойства
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект, ДополнительныеПараметры);
	// Конец СтандартныеПодсистемы.Свойства
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	ИсправлениеДокументов.ПриСозданииНаСервере(ЭтаФорма, Элементы.СтрокаИсправление);
	
	УстановитьПредставлениеДокументаОснования();
	
	// СтандартныеПодсистемы.РаботаСФайлами
	ПараметрыГиперссылки = РаботаСФайлами.ГиперссылкаФайлов();
	ПараметрыГиперссылки.Размещение = "КоманднаяПанель";
	РаботаСФайлами.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыГиперссылки);
	// Конец СтандартныеПодсистемы.РаботаСФайлами
	
	Если Объект.НачислениеНДС.Количество() = 0 Тогда
		
		Объект.НачислениеНДС.Добавить();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// Обработчик механизма "ДатыЗапретаИзменения"
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	ИсправлениеДокументов.ПриЧтенииНаСервере(ЭтаФорма, Элементы.СтрокаИсправление);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец ИнтеграцияС1СДокументооборотом
	
КонецПроцедуры


&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// СтандартныеПодсистемы.Свойства 
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтотОбъект, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.РаботаСФайлами
	РаботаСФайламиКлиент.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия);
	// Конец СтандартныеПодсистемы.РаботаСФайлами
	
КонецПроцедуры


&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.РаботаСФайлами
	РаботаСФайламиКлиент.ПриОткрытии(ЭтотОбъект, Отказ);
	// Конец СтандартныеПодсистемы.РаботаСФайлами
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	Если ЗначениеЗаполнено(Объект.ДокументОснование) Тогда
		
		Оповестить("СозданДокументНачисленияРеверсивногоНДС", Новый Структура("ДокументОснование", Объект.ДокументОснование));
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	СобытияФорм.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	ТипВыбранногоЗначения = ТипЗнч(ВыбранноеЗначение);
	
	Если ТипВыбранногоЗначения = Тип("ДокументСсылка.ПриобретениеТоваровУслуг")
		ИЛИ ТипВыбранногоЗначения = Тип("ДокументСсылка.ПриобретениеУслугПрочихАктивов")
		//++ НЕ УТ
		ИЛИ ТипВыбранногоЗначения = Тип("ДокументСсылка.ОтчетПереработчика2_5")
		//-- НЕ УТ
		ИЛИ ТипВыбранногоЗначения = Тип("ДокументСсылка.ВыкупПринятыхНаХранениеТоваров")
		ИЛИ ТипВыбранногоЗначения = Тип("ДокументСсылка.КорректировкаПриобретения") Тогда
		
		ОбработкаВыбораДокументаОснованияСервер(ВыбранноеЗначение);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	ПринудительноЗакрытьФорму = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПереключательРасшифровкиПриИзменении(Элемент)
	
	Если ПереключательРасшифровки = 0 Тогда
		
		Если Объект.НачислениеНДС.Количество() > 1 Тогда
			
			ТекстСообщения = НСтр("ru = 'Переключение в режим без разбиения невозможно, если в списке Начисления НДС введено более одной строки';
									|en = 'Cannot switch to no split mode if more than one line is entered into the list of VAT accruals'");
			ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
			ПереключательРасшифровки = 1;
			
			Возврат;
			
		КонецЕсли;
		
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаБезРазбиения;
		
	Иначе
		
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаСписок;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДокументОснованиеНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ЗначениеЗаполнено(Объект.ДокументОснование) Тогда
		
		ПоказатьЗначение(Неопределено, Объект.ДокументОснование);
		
	Иначе
		
		СписокТипов = Новый СписокЗначений;
		//++ НЕ УТ
		СписокТипов.Добавить(Тип("ДокументСсылка.ОтчетПереработчика2_5"));
		//-- НЕ УТ
		СписокТипов.Добавить(Тип("ДокументСсылка.ПриобретениеТоваровУслуг"));
		СписокТипов.Добавить(Тип("ДокументСсылка.ПриобретениеУслугПрочихАктивов"));
		СписокТипов.Добавить(Тип("ДокументСсылка.ВыкупПринятыхНаХранениеТоваров"));
		СписокТипов.Добавить(Тип("ДокументСсылка.КорректировкаПриобретения"));
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ПредставлениеДокументаОснованияНажатиеЗавершение", ЭтотОбъект);
		ПоказатьВыборИзСписка(ОписаниеОповещения, СписокТипов, Элементы.ПредставлениеДокументаОснование);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеДокументаОснованияНажатиеЗавершение(ВыбранноеЗначение, Параметры) Экспорт
	
	Если ВыбранноеЗначение = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	МассивХозОпераций = Новый Массив;
	МассивХозОпераций.Добавить(ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ЗакупкаУПоставщика"));
	МассивХозОпераций.Добавить(ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ЗакупкаУПоставщикаНеотфактурованнаяПоставка"));
	МассивХозОпераций.Добавить(ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ЗакупкаУПоставщикаПоступлениеИзТоваровВПути"));
	МассивХозОпераций.Добавить(ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ЗакупкаУПоставщикаТоварыВПути"));
	МассивХозОпераций.Добавить(ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ЗакупкаУПоставщикаФактуровкаПоставки"));
	
	СтруктураОтбор = Новый Структура;
	СтруктураОтбор.Вставить("Проведен", Истина);
	СтруктураОтбор.Вставить("ХозяйственнаяОперация", МассивХозОпераций);
	СтруктураОтбор.Вставить("НалогообложениеНДС", ПредопределенноеЗначение("Перечисление.ТипыНалогообложенияНДС.РеверсивноеОбложениеНДС"));
	
	Если ВыбранноеЗначение.Значение = Тип("ДокументСсылка.ПриобретениеТоваровУслуг") Тогда
		ИмяФормыВыбора = "Документ.ПриобретениеТоваровУслуг.ФормаВыбора";
	ИначеЕсли ВыбранноеЗначение.Значение = Тип("ДокументСсылка.ПриобретениеУслугПрочихАктивов") Тогда
		ИмяФормыВыбора = "Документ.ПриобретениеУслугПрочихАктивов.ФормаВыбора";
	//++ НЕ УТ
	ИначеЕсли ВыбранноеЗначение.Значение = Тип("ДокументСсылка.ОтчетПереработчика2_5") Тогда
		ИмяФормыВыбора = "Документ.ОтчетПереработчика2_5.ФормаВыбора";
	//-- НЕ УТ
		СтруктураОтбор.Вставить("ХозяйственнаяОперация",ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ПроизводствоУПереработчика2_5"));
	ИначеЕсли ВыбранноеЗначение.Значение = Тип("ДокументСсылка.ВыкупПринятыхНаХранениеТоваров") Тогда
		ИмяФормыВыбора = "Документ.ВыкупПринятыхНаХранениеТоваров.ФормаВыбора";
		СтруктураОтбор.ХозяйственнаяОперация.Добавить(ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ВыкупПринятыхНаХранениеТоваров"));
		СтруктураОтбор.ХозяйственнаяОперация.Добавить(ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ПоставкаПодПринципала"));
	ИначеЕсли ВыбранноеЗначение.Значение = Тип("ДокументСсылка.КорректировкаПриобретения") Тогда
		ИмяФормыВыбора = "Документ.КорректировкаПриобретения.ФормаВыбора";
	КонецЕсли;
	
	ОткрытьФорму(
		ИмяФормыВыбора,
		Новый Структура("Отбор", СтруктураОтбор),
		ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура СтавкаНДСПриИзменении(Элемент)
	
	ПересчитатьСуммуНДС(Объект.НачислениеНДС[0]);
	
КонецПроцедуры

&НаКлиенте
Процедура НалоговаяБазаПриИзменении(Элемент)
	
	ПересчитатьСуммуНДС(Объект.НачислениеНДС[0]);
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	
	НалогообложениеНДСПриИзмененииСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	НалогообложениеНДСПриИзмененииСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура СтрокаИсправлениеОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	ИсправлениеДокументовКлиент.СтрокаИсправлениеОбработкаНавигационныйСсылки(
		ЭтотОбъект, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыНачислениеНДС

&НаКлиенте
Процедура НачислениеНДССтавкаНДСПриИзменении(Элемент)
	
	ПересчитатьСуммуНДС();
	
КонецПроцедуры


&НаКлиенте
Процедура НачислениеНДСНалоговаяБазаПриИзменении(Элемент)
	
	ПересчитатьСуммуНДС();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.РаботаСФайлами
&НаКлиенте
Процедура Подключаемый_КомандаПанелиПрисоединенныхФайлов(Команда)
	РаботаСФайламиКлиент.КомандаУправленияПрисоединеннымиФайлами(ЭтотОбъект, Команда);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПолеПредпросмотраПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка)
	РаботаСФайламиКлиент.ПолеПредпросмотраПроверкаПеретаскивания(ЭтотОбъект, Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПолеПредпросмотраПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка)
	РаботаСФайламиКлиент.ПолеПредпросмотраПеретаскивание(ЭтотОбъект, Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПолеПредпросмотраНажатие(Элемент, СтандартнаяОбработка)
	РаботаСФайламиКлиент.ПолеПредпросмотраНажатие(ЭтотОбъект, Элемент, СтандартнаяОбработка);
КонецПроцедуры
// Конец СтандартныеПодсистемы.РаботаСФайлами

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

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры

&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

// СтандартныеПодсистемы.Свойства
&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтотОбъект, Объект);
	
КонецПроцедуры
// Конец ИнтеграцияС1СДокументооборотом

&НаКлиенте
Процедура РазбитьСтроку(Команда)
	
	ТаблицаФормы  = Элементы.НачислениеНДС;
	ДанныеТаблицы = Объект.НачислениеНДС;
	
	ПараметрыРазбиенияСтроки = РаботаСТабличнымиЧастямиКлиент.ПараметрыРазбиенияСтроки();
	ПараметрыРазбиенияСтроки.Вставить("ИмяПоляКоличество", "НалоговаяБаза");
	ПараметрыРазбиенияСтроки.Вставить("Заголовок", НСтр("ru = 'Введите сумму налоговой базы в новой строке';
														|en = 'Enter the tax base amount in a new line'"));
	ПараметрыРазбиенияСтроки.Вставить("РазрешитьНулевоеКоличество", Ложь);
	
	Оповещение = Новый ОписаниеОповещения("РазбитьСтрокуЗавершение", ЭтотОбъект);
	РаботаСТабличнымиЧастямиКлиент.РазбитьСтроку(ДанныеТаблицы, ТаблицаФормы, Оповещение, ПараметрыРазбиенияСтроки);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура РазбитьСтрокуЗавершение(НоваяСтрока, ДополнительныеПараметры) Экспорт 
	
	ТекущаяСтрока = Элементы.НачислениеНДС.ТекущиеДанные;
	
	Если НоваяСтрока <> Неопределено Тогда
		
		ПересчитатьСуммуНДС(ТекущаяСтрока);
		ПересчитатьСуммуНДС(НоваяСтрока);
		
	КонецЕсли;
	
КонецПроцедуры

// СтандартныеПодсистемы.Свойства 
&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

&НаСервере
Процедура УстановитьПредставлениеДокументаОснования()
	
	Если ЗначениеЗаполнено(Объект.ДокументОснование) Тогда
		
		ПредставлениеДокументаОснования = Объект.ДокументОснование;
		Элементы.ПредставлениеДокументаОснование.ЦветТекста = ЦветаСтиля.ГиперссылкаЦвет;
		
	Иначе
		
		ПредставлениеДокументаОснования = НСтр("ru = 'Выберите документ-основание';
												|en = 'Select a base document'");
		Элементы.ПредставлениеДокументаОснование.ЦветТекста = ЦветаСтиля.ЦветОсобогоТекста;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаВыбораДокументаОснованияСервер(ВыбранноеЗначение)
	
	Модифицированность = Истина;
	
	ДокументОбъект = РеквизитФормыВЗначение("Объект");
	ДокументОбъект.Заполнить(ВыбранноеЗначение);
	ЗначениеВРеквизитФормы(ДокументОбъект, "Объект");
	
	Объект.ДокументОснование = ВыбранноеЗначение;
	УстановитьПредставлениеДокументаОснования();
	
	Если Объект.НачислениеНДС.Количество() > 1 Тогда
		
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаСписок;
		
		
	Иначе
		
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаБезРазбиения;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПересчитатьСуммуНДС(ТекущаяСтрока = Неопределено)
	
	Если ТекущаяСтрока = Неопределено Тогда
		
		ТекущаяСтрока = Элементы.НачислениеНДС.ТекущиеДанные;
		
	КонецЕсли;
	
	СтавкаНДСПроцентом = УчетНДСУПКлиентСервер.ЗначениеСтавкиНДС(ТекущаяСтрока.СтавкаНДС);
	ТекущаяСтрока.СуммаНДС = ТекущаяСтрока.НалоговаяБаза * (СтавкаНДСПроцентом / 100);
	
КонецПроцедуры

&НаСервере
Процедура НалогообложениеНДСПриИзмененииСервер()
	
	КэшированныеЗначения = ОбработкаТабличнойЧастиКлиентСервер.ПолучитьСтруктуруКэшируемыеЗначения();
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("СкорректироватьСтавкуНДС", ОбработкаТабличнойЧастиКлиентСервер.ПараметрыЗаполненияСтавкиНДС(Объект));
	
	ОбработкаТабличнойЧастиСервер.ОбработатьТЧ(Объект.НачислениеНДС, СтруктураДействий, КэшированныеЗначения);
	
	Для Каждого СтрокаТЧ Из КэшированныеЗначения.ОбработанныеСтроки Цикл
		
		СтавкаНДСПроцентом = УчетНДСУПКлиентСервер.ЗначениеСтавкиНДС(СтрокаТЧ.СтавкаНДС);
		СтрокаТЧ.СуммаНДС = СтрокаТЧ.НалоговаяБаза * (СтавкаНДСПроцентом / 100);
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
