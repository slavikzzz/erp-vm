
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	УстановитьУсловноеОформление();
	
	УстановитьСвязиПараметровВыбораБанковскогоСчета();
	
	ИспользоватьНесколькоОрганизаций = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций");
	Элементы.ОрганизацияОтбор.Видимость = ИспользоватьНесколькоОрганизаций;
	Элементы.ДенежныеСредстваВПутиОрганизация.Видимость = ИспользоватьНесколькоОрганизаций;
	
	ИспользоватьНесколькоРасчетныхСчетов = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоРасчетныхСчетов");
	Элементы.БанковскийСчетОтбор.Видимость = ИспользоватьНесколькоРасчетныхСчетов;
	Элементы.ДенежныеСредстваВПутиБанковскийСчет.Видимость = ИспользоватьНесколькоРасчетныхСчетов;
	
	ИспользоватьНесколькоКасс = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоКасс");
	Элементы.ДенежныеСредстваВПутиКасса.Видимость = ИспользоватьНесколькоРасчетныхСчетов;
	
	ЗаполнитьРеквизитыФормыПриСоздании();
	НастроитьКнопкиУправленияДокументами();
	
	ИспользуемыеТипыДокументов = Новый Массив();
	ИспользуемыеТипыДокументов.Добавить(Тип("ДокументСсылка.ОтражениеРасхожденийПриИнкассацииДенежныхСредств"));
	ИспользуемыеТипыДокументов.Добавить(Тип("ДокументСсылка.Сторно"));
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.Источники = Новый ОписаниеТипов(ИспользуемыеТипыДокументов);
	ПараметрыРазмещения.КоманднаяПанель = Элементы.РасхожденияПриИнкассацииКоманднаяПанель;
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	НавигационнаяСсылка = "e1cib/list/Документ.ОтражениеРасхожденийПриИнкассацииДенежныхСредств";
	
	РасхожденияПриИнкассации.Параметры.УстановитьЗначениеПараметра("ТипСсылки",
		ОбщегоНазначения.ИдентификаторОбъектаМетаданных("Документ.ОтражениеРасхожденийПриИнкассацииДенежныхСредств"));
		
	ОбщегоНазначенияУТ.ЗаменитьПолеСсылкаКонструкциейВыразитьПоТипамДокументов(Элементы.РасхожденияПриИнкассации,
		ХозяйственныеОперацииИДокументы);
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПриСозданииНаСервере(
		ЭтотОбъект,
		Элементы.РасхожденияПриИнкассацииКоманднаяПанель);
	// Конец ИнтеграцияС1СДокументооборотом
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_РасходныйКассовыйОрдер"
		Или ИмяСобытия = "Запись_ПоступлениеБезналичныхДенежныхСредств"
		Или ИмяСобытия = "Запись_ОтражениеРасхожденийПриИнкассацииДенежныхСредств" Тогда
		ОбновитьДинамическиеСписки();
	КонецЕсли;
	
	Если ИмяСобытия = "Проведение_Сторно"
		Или ИмяСобытия = "Запись_Сторно"
		Или ИмяСобытия = "Запись_ОтражениеРасхожденийПриИнкассацииДенежныхСредств" Тогда
			 Элементы.РасхожденияПриИнкассации.Обновить();
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	Организация = Настройки.Получить("Организация");
	БанковскийСчет = Настройки.Получить("БанковскийСчет");
	Период = Настройки.Получить("Период");
	
	УстановитьОтборДинамическихСписков();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ГруппаСтраницыПриСменеСтраницы(Элемент, ТекущаяСтраница)
	
	ОбновитьДинамическиеСписки();
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияОтборПриИзменении(Элемент)
	
	ОрганизацияОтборПриИзмененииНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ОрганизацияОтборПриИзмененииНаСервере()
	
	УстановитьСвязиПараметровВыбораБанковскогоСчета();
	
	УстановитьОтборДинамическихСписков();
	
КонецПроцедуры

&НаКлиенте
Процедура БанковскийСчетОтборПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		РасхожденияПриИнкассации,
		"БанковскийСчет",
		БанковскийСчет,
		ВидСравненияКомпоновкиДанных.ВИерархии,
		,
		ЗначениеЗаполнено(БанковскийСчет));
		
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		ДенежныеСредстваВПути,
		"БанковскийСчет",
		БанковскийСчет,
		ВидСравненияКомпоновкиДанных.ВИерархии,
		,
		ЗначениеЗаполнено(БанковскийСчет));
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыРасхожденияПриИнкассации

&НаКлиенте
Процедура РасхожденияПриИнкассацииПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура РасхожденияПриИнкассацииПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, ЭтоГруппа, Параметр)
	
	Если Копирование Тогда
		ОбщегоНазначенияУТКлиент.СкопироватьЭлемент(Элемент);
	Иначе
		ОткрытьФорму("Документ.ОтражениеРасхожденийПриИнкассацииДенежныхСредств.ФормаОбъекта", , Элементы.РасхожденияПриИнкассации);
	КонецЕсли;
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура РасхожденияПриИнкассацииВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОбщегоНазначенияУТКлиент.ИзменитьЭлемент(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура РасхожденияПриИнкассацииПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	ОбщегоНазначенияУТКлиент.ИзменитьЭлемент(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура РасхожденияПриИнкассацииПровести(Команда)
	
	ОбщегоНазначенияУТКлиент.ПровестиДокументы(Элементы.РасхожденияПриИнкассации, Заголовок);
	
КонецПроцедуры

&НаКлиенте
Процедура РасхожденияПриИнкассацииОтменаПроведения(Команда)
	
	ОбщегоНазначенияУТКлиент.ОтменаПроведения(Элементы.РасхожденияПриИнкассации, Заголовок);
	
КонецПроцедуры

&НаКлиенте
Процедура РасхожденияПриИнкассацииСкопировать(Команда)
	
	ОбщегоНазначенияУТКлиент.СкопироватьЭлемент(Элементы.РасхожденияПриИнкассации);
	
КонецПроцедуры

&НаКлиенте
Процедура РасхожденияПриИнкассацииУстановитьСнятьПометкуУдаления(Команда)
	
	ОбщегоНазначенияУТКлиент.УстановитьПометкуУдаления(Элементы.РасхожденияПриИнкассации, Заголовок);
КонецПроцедуры

&НаКлиенте
Процедура УстановитьИнтервал(Команда)
	
	Оповещение = Новый ОписаниеОповещения("УстановитьИнтервалЗавершение", ЭтотОбъект);
	
	ОбщегоНазначенияУтКлиент.РедактироватьПериод(Период, , Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьИнтервалЗавершение(ВыбранноеЗначение, ДополнительныеПараметры) Экспорт
	
	Если ВыбранноеЗначение = Неопределено Тогда
		Возврат;
	КонецЕсли;
	Период = ВыбранноеЗначение;
	УстановитьОтборПоПериоду();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборПоПериоду()
	
	РасхожденияПриИнкассации.Параметры.УстановитьЗначениеПараметра("НачалоПериода",
		Период.ДатаНачала);
	РасхожденияПриИнкассации.Параметры.УстановитьЗначениеПараметра("КонецПериода", 
		Период.ДатаОкончания);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОтразитьРасхождение(Команда)
	
	ДанныеСтроки = Элементы.ДенежныеСредстваВПути.ТекущиеДанные;
	
	Если ДанныеСтроки <> Неопределено Тогда
		СтруктураОснование = Новый Структура("Организация, БанковскийСчет, Касса, Валюта");
		ЗаполнитьЗначенияСвойств(СтруктураОснование, ДанныеСтроки);
		Если ДанныеСтроки.СуммаВПути > 0 Тогда
			СтруктураОснование.Вставить("Сумма", ДанныеСтроки.СуммаВПути);
			СтруктураОснование.Вставить("ХозяйственнаяОперация",
				ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ОтражениеНедостачиПриИнкассацииДенежныхСредств"));
		Иначе
			СтруктураОснование.Вставить("Сумма", ДанныеСтроки.СуммаИзлишка);
			СтруктураОснование.Вставить("ХозяйственнаяОперация",
				ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ОтражениеИзлишкаПриИнкассацииДенежныхСредств"));
		КонецЕсли;
		
		СтруктураПараметры = Новый Структура("Основание", СтруктураОснование);
		
		Открытьформу("Документ.ОтражениеРасхожденийПриИнкассацииДенежныхСредств.ФормаОбъекта", СтруктураПараметры, Элементы.РасхожденияПриИнкассации);
	КонецЕсли;
	
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.РасхожденияПриИнкассации);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.РасхожденияПриИнкассации, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.РасхожденияПриИнкассации);
КонецПроцедуры

// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(
		Команда,
		ЭтотОбъект,
		Элементы.РасхожденияПриИнкассации);
	
КонецПроцедуры
// Конец ИнтеграцияС1СДокументооборотом

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_СоздатьДокумент(Команда)
	
	СтруктураОтборы = Новый Структура("Организация, БанковскийСчет", Организация, БанковскийСчет);
	ОбщегоНазначенияУТКлиент.СоздатьДокументЧерезКоманду(Команда.Имя, СтруктураОтборы);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции 

#Область ЖурналДокументов

&НаСервере
Процедура ЗаполнитьРеквизитыФормыПриСоздании()
	
	ТаблицаЗначенийДоступно = Документы.ОтражениеРасхожденийПриИнкассацииДенежныхСредств.ИнициализироватьХозяйственныеОперацииИДокументы(
		ХозяйственныеОперацииИДокументы.Выгрузить());
	
	ХозяйственныеОперацииИДокументы.Загрузить(ТаблицаЗначенийДоступно);
	
КонецПроцедуры

&НаСервере
Процедура НастроитьКнопкиУправленияДокументами()
	
	СтруктураПараметров = ОбщегоНазначенияУТ.СтруктураПараметровНастройкиКнопокУправленияДокументами();
	СтруктураПараметров.Форма 												= ЭтотОбъект;
	СтруктураПараметров.ИмяГруппыСоздать 									="СписокГруппаСоздатьГенерируемая";
	СтруктураПараметров.ИмяГруппыСоздатьКонтекст							= "";
	СтруктураПараметров.ИмяКнопкиСкопировать 								= "РасхожденияПриИнкассацииСкопировать";
	СтруктураПараметров.ИмяКнопкиСкопироватьКонтекстноеМеню 				= "СписокКонтекстноеМенюСкопировать";
	СтруктураПараметров.ИмяКнопкиПровестиКонтекстноеМеню 					= "СписокКонтекстноеМенюПровести";
	СтруктураПараметров.ИмяКнопкиОтменаПроведенияКонтекстноеМеню 			= "СписокКонтекстноеМенюОтменаПроведения";
	СтруктураПараметров.ИмяКнопкиУстановитьПометкуУдаленияКонтекстноеМеню 	= "СписокКонтекстноеМенюУстановитьПометкуУдаления";
	
	ОбщегоНазначенияУТ.НастроитьКнопкиУправленияДокументами(СтруктураПараметров);

КонецПроцедуры

#КонецОбласти

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	// Условное оформление динамического списка "Список"
	СписокУсловноеОформление = РасхожденияПриИнкассации.КомпоновщикНастроек.Настройки.УсловноеОформление;
	СписокУсловноеОформление.Элементы.Очистить();
	
	//
	Элемент = СписокУсловноеОформление.Элементы.Добавить();
	Элемент.Поля.Элементы.Добавить().Поле = Новый ПолеКомпоновкиДанных("ХозяйственнаяОперация");
	Элемент.Представление = НСтр("ru = 'Отражение недостачи / Списание';
								|en = 'Cash shortage recognition / Write-off'");
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ХозяйственнаяОперация");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.ХозяйственныеОперации.ОтражениеНедостачиПриИнкассацииДенежныхСредств;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'Отражение недостачи / Списание';
																|en = 'Cash shortage recognition / Write-off'"));
	
	//
	Элемент = СписокУсловноеОформление.Элементы.Добавить();
	Элемент.Поля.Элементы.Добавить().Поле = Новый ПолеКомпоновкиДанных("ХозяйственнаяОперация");
	Элемент.Представление = НСтр("ru = 'Отражение излишка';
								|en = 'Overage recognition'");
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ХозяйственнаяОперация");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.ХозяйственныеОперации.ОтражениеИзлишкаПриИнкассацииДенежныхСредств;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'Отражение излишка';
																|en = 'Overage recognition'"));
	
	СтандартныеПодсистемыСервер.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "РасхожденияПриИнкассации.Дата", Элементы.Дата.Имя);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьСвязиПараметровВыбораБанковскогоСчета()
	
	МассивПараметров = Новый Массив;
	Если ЗначениеЗаполнено(Организация) Тогда
		МассивПараметров.Добавить(Новый СвязьПараметраВыбора("Отбор.Владелец", "Организация"));
	Иначе
		БанковскийСчет = Неопределено;
	КонецЕсли;
	Элементы.БанковскийСчетОтбор.СвязиПараметровВыбора = Новый ФиксированныйМассив(МассивПараметров);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборДинамическихСписков()
	
	СписокОрганизаций = Новый СписокЗначений;
	СписокОрганизаций.Добавить(Организация);
	
	Если ЗначениеЗаполнено(Организация)
		И ПолучитьФункциональнуюОпцию("ИспользоватьОбособленныеПодразделенияВыделенныеНаБаланс") Тогда
		
		Запрос = Новый Запрос("ВЫБРАТЬ
		|	Организации.Ссылка
		|ИЗ
		|	Справочник.Организации КАК Организации
		|ГДЕ
		|	Организации.ОбособленноеПодразделение
		|	И Организации.ГоловнаяОрганизация = &Организация
		|	И Организации.ДопускаютсяВзаиморасчетыЧерезГоловнуюОрганизацию");
		Запрос.УстановитьПараметр("Организация", Организация);
		
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			СписокОрганизаций.Добавить(Выборка.Ссылка);
		КонецЦикла;
	КонецЕсли;
	
	Для Каждого ДинамическийСписок Из МассивДинамическихСписков() Цикл
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			ДинамическийСписок,
			"Организация",
			СписокОрганизаций,
			ВидСравненияКомпоновкиДанных.ВСписке,
			,
			ЗначениеЗаполнено(Организация));
			
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			ДинамическийСписок,
			"БанковскийСчет",
			БанковскийСчет,
			ВидСравненияКомпоновкиДанных.ВИерархии,
			,
			ЗначениеЗаполнено(БанковскийСчет));
	КонецЦикла;
	
	УстановитьОтборПоПериоду();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьДинамическиеСписки()
	
	Элементы.ДенежныеСредстваВПути.Обновить();
	
КонецПроцедуры

&НаСервере
Функция МассивДинамическихСписков()

	МассивСписков = Новый Массив;
	МассивСписков.Добавить(РасхожденияПриИнкассации);
	МассивСписков.Добавить(ДенежныеСредстваВПути);
	
	Возврат МассивСписков;

КонецФункции

#КонецОбласти
