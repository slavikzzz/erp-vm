#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	УстановитьУсловноеОформление();

	УстановитьЗначенияПоПараметрамФормы(Параметры);
	ОбновитьДанныеФормы();
	
	Если ЗначениеЗаполнено(ОтчетКомитентуОЗакупках) Тогда
		
		Элементы.ГруппаПериод.Видимость = Ложь;
		Элементы.ГруппаОтборовПоРеквизитам.Видимость = Ложь;
		Элементы.ОтчетКомитентуОЗакупках.Доступность= Ложь;
		
	КонецЕсли;

	ОбщегоНазначенияУТ.НастроитьПодключаемоеОборудование(ЭтаФорма);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ТипыДокументовДляПечати = Новый Массив;
	ТипыДокументовДляПечати.Добавить(Тип("ДокументСсылка.СчетФактураВыданный"));
	ПараметрыРазмещения.Источники = Новый ОписаниеТипов(ТипыДокументовДляПечати);
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПриСозданииНаСервере(ЭтаФорма,Элементы.СписокКоманднаяПанельГруппаГлобальныеКоманды);
	// Конец ИнтеграцияС1СДокументооборотом
	
	// ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	ПараметрыПриСозданииНаСервере = ОбменСКонтрагентами.ПараметрыПриСозданииНаСервере_ФормаСписка();
	ПараметрыПриСозданииНаСервере.Форма = ЭтотОбъект;
	ПараметрыПриСозданииНаСервере.МестоРазмещенияКоманд = Элементы.ПодменюЭДО;
	ОбменСКонтрагентами.ПриСозданииНаСервере_ФормаСписка(ПараметрыПриСозданииНаСервере);
	// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	
	// СтандартныеПодсистемы.РаботаСКонтрагентами
	ПроверкаКонтрагентов.ПриСозданииНаСервереСписокДокументов(Список);
	
	Если ПроверкаКонтрагентовВызовСервера.ИспользованиеПроверкиВозможно() Тогда
		Элементы.СодержитНекорректныхКонтрагентов.Видимость = Истина;
	КонецЕсли;
	// Конец СтандартныеПодсистемы.РаботаСКонтрагентами
	
	МассивМенеджеровРасчетаСмТакжеВРаботе = Новый Массив();
	МассивМенеджеровРасчетаСмТакжеВРаботе.Добавить("Обработка.ЖурналДокументовНДС");
	СмТакжеВРаботе = ОбщегоНазначенияУТ.СформироватьГиперссылкуСмТакжеВРаботе(МассивМенеджеровРасчетаСмТакжеВРаботе, Неопределено);
	
	СтандартныеПодсистемыСервер.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "Список.Дата", Элементы.СписокДата.Имя);

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	ПараметрыОповещенияЭДО = ОбменСКонтрагентамиКлиент.ПараметрыОповещенияЭДО_ФормаСписка();
	ПараметрыОповещенияЭДО.Форма = ЭтотОбъект;
	ПараметрыОповещенияЭДО.ИмяДинамическогоСписка = "Список";
	ОбменСКонтрагентамиКлиент.ОбработкаОповещения_ФормаСписка(ИмяСобытия, Параметр, Источник, ПараметрыОповещенияЭДО);
	// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	
	Если ИмяСобытия = "Запись_СчетФактураВыданный" Тогда
		
		Элементы.КРегистрации.Обновить();
		Элементы.Список.Обновить();
		
	ИначеЕсли ИмяСобытия = "Запись_СчетФактураПолученный" Тогда
		
		Элементы.КРегистрации.Обновить();
		
	ИначеЕсли ИмяСобытия = "Запись_ОтчетКомитентуОЗакупках" Тогда
		
		Элементы.КРегистрации.Обновить();
		
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	МенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПриОткрытииФормы(Неопределено, ЭтаФорма, "СканерШтрихкода");
	
	// ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	ОбменСКонтрагентамиКлиент.ПриОткрытии(ЭтотОбъект);
	// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	МенеджерОборудованияКлиент.НачатьОтключениеОборудованиеПриЗакрытииФормы(Неопределено, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура НачалоПериодаПриИзменении(Элемент)
	
	ОбновитьДанныеФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура КонецПериодаПриИзменении(Элемент)
	
	ОбновитьДанныеФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ОбновитьДанныеФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура КомитентПриИзменении(Элемент)
	
	ОбновитьДанныеФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтчетКомитентуОЗакупкахПриИзменении(Элемент)
	
	ЗначениеРеквизитовПоСсылке = ОбщегоНазначенияУТВызовСервера.ЗначенияРеквизитовОбъекта(ОтчетКомитентуОЗакупках,"Организация,Контрагент");
	Организация = ЗначениеРеквизитовПоСсылке.Организация;
	Комитент = ЗначениеРеквизитовПоСсылке.Контрагент;
	
	ОбновитьДанныеФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура КРегистрацииВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Значение = Неопределено;
	
	Если Поле = Элементы.КРегистрацииКомитент Тогда
		Значение = Элемент.ТекущиеДанные.Комитент;
	ИначеЕсли Поле = Элементы.КРегистрацииПоставщик Тогда
		Значение = Элемент.ТекущиеДанные.Поставщик;
	ИначеЕсли Поле = Элементы.КРегистрацииОтчетКомитентуОЗакупках Тогда
		Значение = Элемент.ТекущиеДанные.ОтчетКомитентуОЗакупках;
	ИначеЕсли Поле = Элементы.КРегистрацииСчетФактураПолученный Тогда
		Значение = Элемент.ТекущиеДанные.СчетФактураПолученный;
	КонецЕсли; 
	
	Если Значение <> Неопределено Тогда
		СтандартнаяОбработка = Ложь;
		ПоказатьЗначение(, Значение);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ДополнитьПараметрыСчетаФактурыДаннымиПоставщиков(ПараметрыСчетаФактуры, ДанныеСтроки)
	
	Поставщики = Неопределено;
	Если ЗначениеЗаполнено(ПараметрыСчетаФактуры.Поставщики) Тогда
		Поставщики = ПараметрыСчетаФактуры.Поставщики;
	Иначе
		Поставщики = Новый Массив;
		ПараметрыСчетаФактуры.Поставщики = Поставщики;
	КонецЕсли;
	
	ДанныеПоставщиков = Новый Структура("Поставщик, СчетФактураПолученный, Комитент, СуммаСНДС, СуммаНДС");
	ЗаполнитьЗначенияСвойств(ДанныеПоставщиков, ДанныеСтроки);
	
	Поставщики.Добавить(ДанныеПоставщиков);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьДанныеФормы()
	
	ДинамическиеСписки = Новый Массив;
	ДинамическиеСписки.Добавить("Список");
	ДинамическиеСписки.Добавить("КРегистрации");
	
	Для каждого Имя Из ДинамическиеСписки Цикл
		
		ЭлементыОтбора = ОбщегоНазначенияУТКлиентСервер.ПолучитьОтборДинамическогоСписка(ЭтаФорма[Имя]).Элементы;
		
		ГруппаОтбораПериода = ОбщегоНазначенияКлиентСервер.СоздатьГруппуЭлементовОтбора(
			ЭлементыОтбора, "ГруппаОтбораПериода", ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ);
			
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			ЭтаФорма[Имя], 
			"Комитент", 
			Комитент, 
			ВидСравненияКомпоновкиДанных.Равно
			,
			,
			ЗначениеЗаполнено(Комитент));
			
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			ЭтаФорма[Имя], 
			"Организация", 
			Организация, 
			ВидСравненияКомпоновкиДанных.Равно
			,
			,
			ЗначениеЗаполнено(Организация));
			
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			ЭтаФорма[Имя], 
			"ОтчетКомитентуОЗакупках", 
			ОтчетКомитентуОЗакупках, 
			ВидСравненияКомпоновкиДанных.Равно
			,
			,
			ЗначениеЗаполнено(ОтчетКомитентуОЗакупках));
			
		ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(
			ГруппаОтбораПериода,
			"Дата", 
			ВидСравненияКомпоновкиДанных.БольшеИлиРавно, 
			НачалоДня(НачалоПериода),
			,
			ЗначениеЗаполнено(НачалоПериода));
			
		ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(
			ГруппаОтбораПериода,
			"Дата", 
			ВидСравненияКомпоновкиДанных.МеньшеИлиРавно, 
			КонецДня(КонецПериода),
			,
			ЗначениеЗаполнено(КонецПериода));
			
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьПериодЗавершение(РезультатВыбора, ДопПараметры) Экспорт
	
	Если РезультатВыбора = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(ЭтаФорма, РезультатВыбора, "НачалоПериода, КонецПериода");
	
	ОбновитьДанныеФормы();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьЗначенияПоПараметрамФормы(Параметры)
	
	СтруктураБыстрогоОтбора = Неопределено;
	Параметры.Свойство("СтруктураБыстрогоОтбора", СтруктураБыстрогоОтбора);
	Если СтруктураБыстрогоОтбора <> Неопределено Тогда
		СтруктураБыстрогоОтбора.Свойство("Организация", Организация);
		СтруктураБыстрогоОтбора.Свойство("Комитент", Комитент);
		СтруктураБыстрогоОтбора.Свойство("НачалоПериода", НачалоПериода);
		СтруктураБыстрогоОтбора.Свойство("КонецПериода", КонецПериода);
		СтруктураБыстрогоОтбора.Свойство("ОтчетКомитентуОЗакупках", ОтчетКомитентуОЗакупках);
	КонецЕсли;
	
	ОтображатьСтраницуКОформлению = Неопределено;
	Если Параметры.Свойство("ОтображатьСтраницуКОформлению", ОтображатьСтраницуКОформлению) И (ОтображатьСтраницуКОформлению = Неопределено Или ОтображатьСтраницуКОформлению) Тогда
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаКРегистрации;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.КРегистрацииОтчетКомитентуОЗакупках.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ОтчетКомитентуОЗакупках");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено;

	Элемент.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);

КонецПроцедуры

&НаКлиенте
Процедура СмТакжеВРаботеОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	// &ЗамерПроизводительности
	ОценкаПроизводительностиКлиент.ЗамерВремени("Документ.СчетФактураВыданный.Форма.ФормаРабочееМестоДляОформленияСчетовФактурКомитенту.Событие.СмТакжеВРаботеОбработкаНавигационнойСсылки");
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыФормы = Новый Структура;
	СтруктураБыстрогоОтбора = Новый Структура;
	СтруктураБыстрогоОтбора.Вставить("Организация",Организация);
	СтруктураБыстрогоОтбора.Вставить("Контрагент",Комитент);
	ПараметрыФормы.Вставить("СтруктураБыстрогоОтбора", СтруктураБыстрогоОтбора);
	
	ОткрытьФорму(НавигационнаяСсылкаФорматированнойСтроки, ПараметрыФормы, ЭтаФорма, УникальныйИдентификатор);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыбратьПериод(Команда)
	
	ПараметрыВыбора = Новый Структура("НачалоПериода, КонецПериода", НачалоПериода, КонецПериода);
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыбратьПериодЗавершение", ЭтотОбъект);
	ОткрытьФорму("ОбщаяФорма.ВыборСтандартногоПериода", ПараметрыВыбора, Элементы.ВыбратьПериод, , , , ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПеревыставитьСчетФактуру(Команда)
	
	ОценкаПроизводительностиКлиент.ЗамерВремени(
	"Документ.СчетФактураВыданный.Форма.ФормаРабочееМестоДляОформленияСчетовФактурКомитенту.ПеревыставитьСчетФактуру_ПодготовкаДанныхИПеревыставление");	
	
	ОчиститьСообщения();
	Если Элементы.КРегистрации.ВыделенныеСтроки.Количество() = 0 Тогда
		ПоказатьПредупреждение(,НСтр("ru = 'Нет данных для регистрации счетов-фактур.';
									|en = 'No data to register tax invoices.'"));
		Возврат;
	КонецЕсли;
	
	ПараметрыСчетаФактуры = Неопределено;
	ПараметрыСчетовФактурДляПеревыставления = Новый Массив;
	
	Для Каждого Строка Из Элементы.КРегистрации.ВыделенныеСтроки Цикл
		ДанныеСтроки = Элементы.КРегистрации.ДанныеСтроки(Строка);
		
		ПараметрыСчетаФактуры = Новый Структура;
		ПараметрыСчетаФактуры.Вставить("Организация",           ДанныеСтроки.Организация);
		ПараметрыСчетаФактуры.Вставить("Комитент",              ДанныеСтроки.Комитент);
		ПараметрыСчетаФактуры.Вставить("ДатаСоставления",       ДанныеСтроки.Дата);
		ПараметрыСчетаФактуры.Вставить("Валюта",                ДанныеСтроки.Валюта);
		ПараметрыСчетаФактуры.Вставить("Дата",                  ДанныеСтроки.Дата);
		ПараметрыСчетаФактуры.Вставить("ДокументОснование",     ДанныеСтроки.ОтчетКомитентуОЗакупках);
		ПараметрыСчетаФактуры.Вставить("СчетФактураВыданный",   ДанныеСтроки.СчетФактураВыданный);
		ПараметрыСчетаФактуры.Вставить("Поставщик",             ДанныеСтроки.Поставщик);
		ПараметрыСчетаФактуры.Вставить("СчетФактураПолученный", ДанныеСтроки.СчетФактураПолученный);
		ПараметрыСчетаФактуры.Вставить("Комитент",              ДанныеСтроки.Комитент);
		ПараметрыСчетаФактуры.Вставить("СуммаСНДС",             ДанныеСтроки.СуммаСНДС);
		ПараметрыСчетаФактуры.Вставить("СуммаНДС",              ДанныеСтроки.СуммаНДС);
		ПараметрыСчетаФактуры.Вставить("Корректировочный",      ДанныеСтроки.Корректировочный);
		ПараметрыСчетаФактуры.Вставить("Исправление",           ДанныеСтроки.Исправление);
		
		ПараметрыСчетовФактурДляПеревыставления.Добавить(ПараметрыСчетаФактуры);
		
	КонецЦикла;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПеревыставитьСчетФактуруЗавершение", ЭтотОбъект);
	ДлительнаяОперация = ПеревыставитьСчетаФактурыПолученныеСервер(ПараметрыСчетовФактурДляПеревыставления);
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, ОписаниеОповещения, ПараметрыОжидания);

КонецПроцедуры

&НаКлиенте
Процедура ПеревыставитьСчетФактуруЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат.Статус = "Ошибка" Тогда
		ТекстСообщения = НСтр("ru = 'Произошла ошибка при перевыставлении счетов-фактуры полученных от поставщиков:';
								|en = 'An error occurred while re-issuing tax invoices received from suppliers:'") + Символы.ПС + Результат.КраткоеПредставлениеОшибки;
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		
		Возврат;
	КонецЕсли;
	
	ФормаВладелец = ВладелецФормы;
	Если ФормаВладелец = Неопределено Тогда
		ФормаВладелец = ЭтаФорма; 
	КонецЕсли;	
	Оповестить("ПеревыставленСчетФактураПоставщика", Новый Структура("ФормаВладелец", ФормаВладелец.УникальныйИдентификатор));
	Элементы.КРегистрации.Обновить();
	Элементы.Список.Обновить();
		
КонецПроцедуры	

&НаСервере
Функция ПеревыставитьСчетаФактурыПолученныеСервер(ПараметрыСчетовФактурДляПеревыставления)
	
	ТаблицаДокументов = Новый ТаблицаЗначений();
	ТаблицаДокументов.Колонки.Добавить("Организация");
	ТаблицаДокументов.Колонки.Добавить("Комитент");
	ТаблицаДокументов.Колонки.Добавить("ДатаСоставления");
	ТаблицаДокументов.Колонки.Добавить("Валюта");
	ТаблицаДокументов.Колонки.Добавить("Дата");
	ТаблицаДокументов.Колонки.Добавить("ДокументОснование");
	ТаблицаДокументов.Колонки.Добавить("СчетФактураВыданный");
	ТаблицаДокументов.Колонки.Добавить("Перевыставленный");
	ТаблицаДокументов.Колонки.Добавить("Корректировочный");
	ТаблицаДокументов.Колонки.Добавить("Исправление");
	ТаблицаДокументов.Колонки.Добавить("СводныйКомиссионный");
	ТаблицаДокументов.Колонки.Добавить("Поставщики");
	
	Для Каждого ДанныеСтроки Из ПараметрыСчетовФактурДляПеревыставления Цикл
		
		ОтборПоПараметрам = Новый Структура();
		ОтборПоПараметрам.Вставить("Организация",         ДанныеСтроки.Организация);
		ОтборПоПараметрам.Вставить("Комитент",            ДанныеСтроки.Комитент);
		ОтборПоПараметрам.Вставить("ДатаСоставления",     ДанныеСтроки.Дата);
		ОтборПоПараметрам.Вставить("Валюта",              ДанныеСтроки.Валюта);
		ОтборПоПараметрам.Вставить("Дата",                ДанныеСтроки.Дата);
		ОтборПоПараметрам.Вставить("ДокументОснование",   ДанныеСтроки.ДокументОснование);
		ОтборПоПараметрам.Вставить("СчетФактураВыданный", ДанныеСтроки.СчетФактураВыданный);
		ОтборПоПараметрам.Вставить("Корректировочный",    ДанныеСтроки.Корректировочный);
		ОтборПоПараметрам.Вставить("Исправление",         ДанныеСтроки.Исправление);
		
		НайденныеСтроки = ТаблицаДокументов.НайтиСтроки(ОтборПоПараметрам);
		
		Если НайденныеСтроки.Количество() = 0
			Или ВариантФормированияСчетовФактур = 0 Тогда
			
			ПараметрыСчетаФактуры = ТаблицаДокументов.Добавить();
			
			ПараметрыСчетаФактуры.Организация =         ДанныеСтроки.Организация;
			ПараметрыСчетаФактуры.Комитент =            ДанныеСтроки.Комитент;
			ПараметрыСчетаФактуры.ДатаСоставления =     ДанныеСтроки.Дата;
			ПараметрыСчетаФактуры.Валюта =              ДанныеСтроки.Валюта;
			ПараметрыСчетаФактуры.Дата =                ДанныеСтроки.Дата;
			ПараметрыСчетаФактуры.ДокументОснование =   ДанныеСтроки.ДокументОснование;
			ПараметрыСчетаФактуры.СчетФактураВыданный = ДанныеСтроки.СчетФактураВыданный;
			ПараметрыСчетаФактуры.Корректировочный =    ДанныеСтроки.Корректировочный;
			ПараметрыСчетаФактуры.Исправление =         ДанныеСтроки.Исправление;
			ПараметрыСчетаФактуры.Перевыставленный =    Истина;
			ПараметрыСчетаФактуры.СводныйКомиссионный = Ложь;
			
			ДополнитьПараметрыСчетаФактурыДаннымиПоставщиков(ПараметрыСчетаФактуры, ДанныеСтроки);
			
		Иначе
			
			ПараметрыСчетаФактуры = НайденныеСтроки[0];
			ДополнитьПараметрыСчетаФактурыДаннымиПоставщиков(ПараметрыСчетаФактуры, ДанныеСтроки);
			ПараметрыСчетаФактуры.СводныйКомиссионный = Истина;
			
		КонецЕсли;
			
	КонецЦикла;
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Перевыставление комитенту счетов-фактуры полученных от поставщиков';
															|en = 'Re-issuance to the consignor of invoices received from suppliers'");
	ПараметрыВыполнения.ЗапуститьНеВФоне = (ПараметрыСчетовФактурДляПеревыставления.Количество()=1);
	
	РезультатВыполнения = ДлительныеОперации.ВыполнитьВФоне(
		"Документы.СчетФактураВыданный.ПеревыставитьСчетаФактурыПолученные",
		ТаблицаДокументов, ПараметрыВыполнения);
	
	Возврат РезультатВыполнения;
	
КонецФункции

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Элементы.Список);
	
КонецПроцедуры
// Конец ИнтеграцияС1СДокументооборотом

// ЭлектронноеВзаимодействие.ОбменСКонтрагентами

&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуЭДО(Команда)
	
	ЭлектронноеВзаимодействиеКлиент.ВыполнитьПодключаемуюКомандуЭДО(Команда, ЭтаФорма, Элементы.Список);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбработчикОжиданияЭДО()
	
	ОбменСКонтрагентамиКлиент.ОбработчикОжиданияЭДО(ЭтотОбъект);
	
КонецПроцедуры

// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами

#КонецОбласти
