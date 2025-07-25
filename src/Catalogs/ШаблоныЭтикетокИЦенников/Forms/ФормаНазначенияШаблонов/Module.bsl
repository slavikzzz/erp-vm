
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	Шаблон = Параметры.Шаблон;
	Назначение = Параметры.Назначение;
	
	Если Параметры.Назначение = Перечисления.НазначенияШаблоновЭтикетокИЦенников.ЦенникДляТоваров Тогда
		Элементы.НазначитьДля.СписокВыбора.Добавить("Номенклатура", НСтр("ru = 'Номенклатуры';
																		|en = 'Items'"));
		Элементы.НазначитьДля.СписокВыбора.Добавить("ВидНоменклатуры", НСтр("ru = 'Вида номенклатуры';
																			|en = 'Of item kind'"));
		
		Номенклатура = Параметры.ДляЧего;
		ВидНоменклатуры = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Параметры.ДляЧего, "ВидНоменклатуры");
		
	ИначеЕсли Параметры.Назначение = Перечисления.НазначенияШаблоновЭтикетокИЦенников.ЭтикеткаДляТоваров Тогда
		Элементы.НазначитьДля.СписокВыбора.Добавить("Номенклатура", НСтр("ru = 'Номенклатуры';
																		|en = 'Items'"));
		Элементы.НазначитьДля.СписокВыбора.Добавить("ВидНоменклатуры", НСтр("ru = 'Вида номенклатуры';
																			|en = 'Of item kind'"));
		
		Номенклатура = Параметры.ДляЧего;
		ВидНоменклатуры = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Параметры.ДляЧего, "ВидНоменклатуры");
		
	ИначеЕсли Параметры.Назначение = Перечисления.НазначенияШаблоновЭтикетокИЦенников.ЭтикеткаДляСкладскихЯчеек
		ИЛИ Параметры.Назначение = Перечисления.НазначенияШаблоновЭтикетокИЦенников.ЭтикеткаДляАкцизныхМарок
		ИЛИ Параметры.Назначение = Перечисления.НазначенияШаблоновЭтикетокИЦенников.ЭтикеткаДляШтрихкодовУпаковок
		ИЛИ Параметры.Назначение = Перечисления.НазначенияШаблоновЭтикетокИЦенников.ЭтикеткаОбъектаЭксплуатацииЛента 
		ИЛИ Параметры.Назначение = Перечисления.НазначенияШаблоновЭтикетокИЦенников.ЭтикеткаОбъектаЭксплуатацииБумага 
		ИЛИ Параметры.Назначение = Перечисления.НазначенияШаблоновЭтикетокИЦенников.ЭтикеткаУзлаОбъектаЭксплуатацииЛента 
		ИЛИ Параметры.Назначение = Перечисления.НазначенияШаблоновЭтикетокИЦенников.ЭтикеткаУзлаОбъектаЭксплуатацииБумага 
		ИЛИ Параметры.Назначение = Перечисления.НазначенияШаблоновЭтикетокИЦенников.ЭтикеткаТМЦВЭксплуатацииЛента 
		ИЛИ Параметры.Назначение = Перечисления.НазначенияШаблоновЭтикетокИЦенников.ЭтикеткаТМЦВЭксплуатацииБумага 
		ИЛИ Параметры.Назначение = Перечисления.НазначенияШаблоновЭтикетокИЦенников.ЭтикеткаКодМаркировкиИСМП Тогда
		Элементы.НазначитьДля.СписокВыбора.Добавить("Запрещено", НСтр("ru = 'Не назначается';
																		|en = 'Not assigned'"));
	ИначеЕсли Параметры.Назначение = Перечисления.НазначенияШаблоновЭтикетокИЦенников.ЭтикеткаСерииНоменклатуры Тогда
		Элементы.НазначитьДля.СписокВыбора.Добавить("ВидНоменклатуры", НСтр("ru = 'Вида номенклатуры';
																			|en = 'Of item kind'"));
	ИначеЕсли Параметры.Назначение = Перечисления.НазначенияШаблоновЭтикетокИЦенников.ЭтикеткаДляДоставки Тогда
		Элементы.НазначитьДля.СписокВыбора.Добавить("Партнер", НСтр("ru = 'Клиента\Перевозчика';
																	|en = 'Customer\Shipper'"));
	КонецЕсли;
	
	НазначитьДля = Элементы.НазначитьДля.СписокВыбора.Получить(0).Значение;
	
	Если Элементы.НазначитьДля.СписокВыбора.Количество() < 2 Тогда
		Элементы.НазначитьДля.Видимость = Ложь;
	КонецЕсли;
	
	ПриИзмененииНазначения(ЭтаФорма);

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НазначитьДляПриИзменении(Элемент)
	
	ПриИзмененииНазначения(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Назначить(Команда)
	НазначитьНаСервере();
	Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочее

&НаСервере
Процедура НазначитьНаСервере()
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если Назначение = Перечисления.НазначенияШаблоновЭтикетокИЦенников.ЦенникДляТоваров Тогда
		
		Если НазначитьДля = "Номенклатура" Тогда
			Объект = Номенклатура.ПолучитьОбъект();
			Объект.ШаблонЦенника = Шаблон;
			Объект.ИспользоватьИндивидуальныйШаблонЦенника = Истина;
			Объект.Записать();
		ИначеЕсли НазначитьДля = "ВидНоменклатуры" Тогда
			Объект = ВидНоменклатуры.ПолучитьОбъект();
			Объект.ШаблонЦенника = Шаблон;
			Объект.Записать();
		КонецЕсли;
		
	ИначеЕсли Назначение = Перечисления.НазначенияШаблоновЭтикетокИЦенников.ЭтикеткаДляТоваров Тогда
		
		Если НазначитьДля = "Номенклатура" Тогда
			Объект = Номенклатура.ПолучитьОбъект();
			Объект.ШаблонЭтикетки = Шаблон;
			Объект.ИспользоватьИндивидуальныйШаблонЭтикетки = Истина;
			Объект.Записать();
		ИначеЕсли НазначитьДля = "ВидНоменклатуры" Тогда
			Объект = ВидНоменклатуры.ПолучитьОбъект();
			Объект.ШаблонЭтикетки = Шаблон;
			Объект.Записать();
		КонецЕсли;
		
	ИначеЕсли Назначение = Перечисления.НазначенияШаблоновЭтикетокИЦенников.ЭтикеткаДляСкладскихЯчеек Тогда
		
	ИначеЕсли Назначение = Перечисления.НазначенияШаблоновЭтикетокИЦенников.ЭтикеткаСерииНоменклатуры Тогда
		
		Объект = ВидНоменклатуры.ПолучитьОбъект();
		Объект.ШаблонЭтикеткиСерии = Шаблон;
		Объект.Записать();
		
	ИначеЕсли Назначение = Перечисления.НазначенияШаблоновЭтикетокИЦенников.ЭтикеткаДляДоставки Тогда
		
		Объект = Партнер.ПолучитьОбъект();
		Объект.ШаблонЭтикетки = Шаблон;
		Объект.Записать();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ПриИзмененииНазначения(Форма)

	Если Форма.НазначитьДля = "Номенклатура" Тогда
		Форма.Элементы.ГруппаСтраницы.ТекущаяСтраница = Форма.Элементы.ГруппаНоменклатура;
	ИначеЕсли Форма.НазначитьДля = "ВидНоменклатуры" Тогда
		Форма.Элементы.ГруппаСтраницы.ТекущаяСтраница = Форма.Элементы.ГруппаВидНоменклатуры;
	ИначеЕсли Форма.НазначитьДля = "Запрещено" Тогда
		Форма.Элементы.ГруппаСтраницы.ТекущаяСтраница = Форма.Элементы.ГруппаЗапрещено;
	ИначеЕсли Форма.НазначитьДля = "Партнер" Тогда
		Форма.Элементы.ГруппаСтраницы.ТекущаяСтраница = Форма.Элементы.ГруппаПартнер;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
