#Область ОписаниеПеременных

&НаКлиенте
Перем ПараметрыОбработчикаОжидания;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Параметры.СформироватьПриОткрытии = Ложь;
	
	ПараметрКоманды = Неопределено;
	Если Параметры.Свойство("ПараметрКоманды", ПараметрКоманды)
		И ТипЗнч(ПараметрКоманды) = Тип("Массив") Тогда
			
		Если ПараметрКоманды.Количество() > 0 Тогда
			Документ = ПараметрКоманды[0];
			РеквизитыДокумента = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Документ, "Организация, Дата");
			Организация = РеквизитыДокумента.Организация;
			Период = РеквизитыДокумента.Дата;
		КонецЕсли;
	Иначе
		Параметры.Свойство("Период", Период);
		Параметры.Свойство("Организация", Организация); 
		Параметры.Свойство("Документ", Документ);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Период) Тогда
		ПереданыПараметры = Истина;
		Если Месяц(Период) = Месяц(КонецКвартала(Период)) Тогда 
			
			Настройка = ПереданныеНастройки.Добавить();
			Настройка.Имя = "НачалоПериода";
			Настройка.Значение = НачалоКвартала(Период);
			
			Настройка = ПереданныеНастройки.Добавить();
			Настройка.Имя = "КонецПериода";
			Настройка.Значение = КонецКвартала(Период);
			
		Иначе
			
			Настройка = ПереданныеНастройки.Добавить();
			Настройка.Имя = "НачалоПериода";
			Настройка.Значение = НачалоМесяца(Период);
			
			Настройка = ПереданныеНастройки.Добавить();
			Настройка.Имя = "КонецПериода";
			Настройка.Значение = КонецМесяца(Период);
			
		КонецЕсли;
	КонецЕсли;
		
	Если ЗначениеЗаполнено(Организация) Тогда 
		
		ПереданыПараметры = Истина;
		
		Настройка = ПереданныеНастройки.Добавить();
		Настройка.Имя = "Организация";
		Настройка.Значение = Организация;
			
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Документ) Тогда 
		
		ПереданыПараметры = Истина;
		
		Настройка = ПереданныеНастройки.Добавить();
		Настройка.Имя = "ВыручкаПоДокументам";
		Настройка.Значение = Истина;
		
		
		Настройка = ПереданныеНастройки.Добавить();
		Настройка.Имя = "ДокументРаспределения";
		Настройка.Значение = Документ;
		
	КонецЕсли;
	
	Если ПереданыПараметры Тогда 
		УстановитьОтбор();
	КонецЕсли;
	
	// Установка настроек печати по умолчанию. Если настройки были изменены, они будут загружены при формировании отчета.
	Результат.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
	Результат.АвтоМасштаб        = Истина;
	
	БухгалтерскиеОтчетыВызовСервера.УстановитьНастройкиПоУмолчанию(ЭтаФорма);
		
	УправлениеФормой(ЭтаФорма);
	
	УчетНДСКлиентСервер.ОтобразитьПоясненияКПериодуОтчета(ЭтотОбъект);
	ОбновитьТекстЗаголовка(ЭтаФорма);
	
КонецПроцедуры     

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	БухгалтерскиеОтчетыКлиент.ПриОткрытии(ЭтаФорма, Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	БухгалтерскиеОтчетыКлиент.ПередЗакрытием(ЭтаФорма, Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОтменитьВыполнениеЗадания();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриСохраненииПользовательскихНастроекНаСервере(Настройки)
	
	БухгалтерскиеОтчетыВызовСервера.ПриСохраненииПользовательскихНастроекНаСервере(ЭтаФорма, Настройки, Истина);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеПользовательскихНастроекНаСервере(Настройки)
	
		
	Если ПереданыПараметры Тогда 
		
		  УстановитьОтбор();
		
	Иначе
		
		БухгалтерскиеОтчетыВызовСервера.ПриЗагрузкеПользовательскихНастроекНаСервере(ЭтаФорма, Настройки, Истина);
		
	КонецЕсли;	
	
	ОбновитьТекстЗаголовка(ЭтаФорма);
		
	УчетНДСПереопределяемый.ФормаОтчетаОбработатьВыборПериода(ЭтотОбъект);
	УправлениеФормой(ЭтаФорма);
			
КонецПроцедуры

&НаСервере
Процедура УстановитьОтбор()
	
	Для Каждого Настройка Из ПереданныеНастройки Цикл
		 Отчет[Настройка.Имя] = Настройка.Значение;
	КонецЦикла;
			
КонецПроцедуры

#Область ОбработчикиСобытийПоляТабличногоДокумента

&НаКлиенте
Процедура РезультатПриАктивизацииОбласти(Элемент)
	
	//++ НЕ УТ
	Если ТипЗнч(Результат.ВыделенныеОбласти) = Тип("ВыделенныеОбластиТабличногоДокумента") Тогда
		ИнтервалОжидания = ?(ПолучитьСкоростьКлиентскогоСоединения() = СкоростьКлиентскогоСоединения.Низкая, 1, 0.2);
		ПодключитьОбработчикОжидания("Подключаемый_РезультатПриАктивизацииОбластиПодключаемый", ИнтервалОжидания, Истина);
	КонецЕсли;
	//-- НЕ УТ
	
	Возврат; // Обработчик в УТ не требуется
	
КонецПроцедуры

#КонецОбласти

#Область ДействияКомандФормы

&НаКлиенте
Процедура СформироватьОтчет(Команда)

	ОчиститьСообщения();
	
	ОтключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания");
	
	РезультатВыполнения = СформироватьОтчетНаСервере();
	Если Не РезультатВыполнения.ЗаданиеВыполнено Тогда		
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "ФормированиеОтчета");
	КонецЕсли;
	
	Если РезультатВыполнения.Свойство("ОтказПроверкиЗаполнения") Тогда
		ПоказатьНастройки("");
	Иначе	
		ПодключитьОбработчикОжидания("Подключаемый_ЗакрытьНастройки", 0.1, Истина);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПоказатьНастройки(Команда)
	Элементы.ПрименитьНастройки.КнопкаПоУмолчанию = Истина;
	ПодключитьОбработчикОжидания("Подключаемый_ОткрытьНастройки", 0.1, Истина);
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьНастройки(Команда)
	Элементы.Сформировать.КнопкаПоУмолчанию = Истина;
	ПодключитьОбработчикОжидания("Подключаемый_ЗакрытьНастройки", 0.1, Истина);
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьПериод(Команда)
	
	ПараметрыВыбора = Новый Структура("НачалоПериода,КонецПериода", Отчет.НачалоПериода, Отчет.КонецПериода);
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыбратьПериодЗавершение", ЭтотОбъект);
	ОткрытьФорму("ОбщаяФорма.ВыборСтандартногоПериода", ПараметрыВыбора, Элементы.ВыбратьПериод, , , , ОписаниеОповещения);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийПолейФормы

&НаКлиенте
Процедура НачалоПериодаПриИзменении(Элемент)
	
	ПериодПриИзмененииСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура КонецПериодаПриИзменении(Элемент)
	
	ПериодПриИзмененииСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ОрганизацияПриИзмененииСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыручкаПоДокументамПриИзменении(Элемент)
	
	УправлениеФормой(ЭтаФорма);
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДокументРаспределенияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)

	НовыйПараметр = Новый ПараметрВыбора("Отбор.Организация", Отчет.Организация);
	НовыйМассив = Новый Массив();
	НовыйМассив.Добавить(НовыйПараметр);
	НовыеПараметры = Новый ФиксированныйМассив(НовыйМассив);
	Элементы.ДокументРаспределения.ПараметрыВыбора = НовыеПараметры;
	
КонецПроцедуры

&НаКлиенте
Процедура ДокументРаспределенияПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Отчет    = Форма.Отчет;
	Элементы = Форма.Элементы;
	
	Элементы.ДокументРаспределения.Доступность = Отчет.ВыручкаПоДокументам;
	
КонецПроцедуры

&НаСервере
Процедура ОрганизацияПриИзмененииСервер()
	
	Если Отчет.ВыручкаПоДокументам 
		И ЗначениеЗаполнено(Отчет.ДокументРаспределения) Тогда
		
		ОрганизацияДокумента = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Отчет.ДокументРаспределения, "Организация");
		
		Если ОрганизацияДокумента <> Отчет.Организация Тогда
			Отчет.ВыручкаПоДокументам = Ложь;
			Отчет.ДокументРаспределения = Неопределено;
		КонецЕсли;
		
	КонецЕсли;
	
	УчетНДСКлиентСервер.ОтобразитьПоясненияКПериодуОтчета(ЭтотОбъект);
	ОбновитьТекстЗаголовка(ЭтаФорма);
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПериодПриИзмененииСервер()
	
	Если Отчет.ВыручкаПоДокументам 
		И ЗначениеЗаполнено(Отчет.ДокументРаспределения) Тогда
		
		ДатаДокумента = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Отчет.ДокументРаспределения, "Дата");
		
		Если ДатаДокумента < Отчет.НачалоПериода 
			ИЛИ ДатаДокумента > Отчет.КонецПериода Тогда
			Отчет.ВыручкаПоДокументам = Ложь;
			Отчет.ДокументРаспределения = Неопределено;
		КонецЕсли;
		
	КонецЕсли;

	ОбновитьТекстЗаголовка(ЭтаФорма);
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	УчетНДСКлиентСервер.ОтобразитьПоясненияКПериодуОтчета(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьТекстЗаголовка(Форма)
	
	Отчет = Форма.Отчет;
	
	ЗаголовокОтчета = НСтр("ru = 'Распределение сумм НДС';
							|en = 'VAT amount allocation'")
		+ БухгалтерскиеОтчетыКлиентСервер.ПолучитьПредставлениеПериода(Отчет.НачалоПериода,
		Отчет.КонецПериода);
	
	Если ЗначениеЗаполнено(Отчет.Организация) И Форма.ИспользуетсяНесколькоОрганизаций Тогда
		ЗаголовокОтчета = ЗаголовокОтчета 
		+ " "
		+ БухгалтерскиеОтчетыВызовСервера.ПолучитьТекстОрганизация(Отчет.Организация);
	КонецЕсли;
	
	Форма.Заголовок = ЗаголовокОтчета;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(ИдентификаторЗадания)
	
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания);
	
КонецФункции

&НаСервере
Процедура ОтменитьВыполнениеЗадания()
	
	ДлительныеОперации.ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗадания()
	
	Попытка
		Если ЗаданиеВыполнено(ИдентификаторЗадания) Тогда 
			ЗагрузитьПодготовленныеДанные();
			ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
		Иначе
			ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
			ПодключитьОбработчикОжидания(
				"Подключаемый_ПроверитьВыполнениеЗадания", 
				ПараметрыОбработчикаОжидания.ТекущийИнтервал, 
				Истина);
		КонецЕсли;
	Исключение
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьПодготовленныеДанные()
	
	Результат.Очистить();
	Результат.Вывести(ПолучитьИзВременногоХранилища(АдресХранилища));
	
	ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
	
КонецПроцедуры

//++ НЕ УТ

&НаСервере
Процедура ВычислитьСуммуВыделенныхЯчеекТабличногоДокументаВКонтекстеНаСервере()
	
	ПолеСумма = БухгалтерскиеОтчетыВызовСервера.ВычислитьСуммуВыделенныхЯчеекТабличногоДокумента(
		Результат, КэшВыделеннойОбласти);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_РезультатПриАктивизацииОбластиПодключаемый()
	
	НеобходимоВычислятьНаСервере = Ложь;
	БухгалтерскиеОтчетыКлиент.ВычислитьСуммуВыделенныхЯчеекТабличногоДокумента(
		ПолеСумма, Результат, Элементы.Результат, КэшВыделеннойОбласти, НеобходимоВычислятьНаСервере);
	
	Если НеобходимоВычислятьНаСервере Тогда
		ВычислитьСуммуВыделенныхЯчеекТабличногоДокументаВКонтекстеНаСервере();
	КонецЕсли;
	
	ОтключитьОбработчикОжидания("Подключаемый_РезультатПриАктивизацииОбластиПодключаемый");
	
КонецПроцедуры
//-- НЕ УТ

&НаСервере
Функция ПодготовитьПараметрыОтчета()
	
	ПараметрыОтчета = Новый Структура;
	ПараметрыОтчета.Вставить("Организация"                       , Отчет.Организация);
	ПараметрыОтчета.Вставить("НачалоПериода"                     , Отчет.НачалоПериода);
	ПараметрыОтчета.Вставить("КонецПериода"                      , Отчет.КонецПериода);
	ПараметрыОтчета.Вставить("ВидОтчета"                         , Отчет.ВидОтчета);
	ПараметрыОтчета.Вставить("ВыручкаПоДокументам"               , Отчет.ВыручкаПоДокументам);
	ПараметрыОтчета.Вставить("ДокументРаспределения"             , Отчет.ДокументРаспределения);
	
	Возврат ПараметрыОтчета;
	
КонецФункции

&НаСервере
Функция СформироватьОтчетНаСервере()
	
	Если Не ПроверитьЗаполнение() Тогда 
		Возврат Новый Структура("ЗаданиеВыполнено", Истина);
	КонецЕсли;
	
	ИБФайловая = ОбщегоНазначения.ИнформационнаяБазаФайловая();
	
	ДлительныеОперации.ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	
	ИдентификаторЗадания = Неопределено;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
	
	ПараметрыОтчета = ПодготовитьПараметрыОтчета();
	
	Отчет.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.Вставить("ВыводитьЗаголовок", Истина);
	Если ИБФайловая Тогда
		АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
		Отчеты.АнализРаспределенияНДС.СформироватьОтчет(ПараметрыОтчета, АдресХранилища);
		РезультатВыполнения = Новый Структура("ЗаданиеВыполнено", Истина);
	Иначе
		РезультатВыполнения = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
			УникальныйИдентификатор, 
			"Отчеты.АнализРаспределенияНДС.СформироватьОтчет", 
			ПараметрыОтчета, 
			БухгалтерскиеОтчетыКлиентСервер.ПолучитьНаименованиеЗаданияВыполненияОтчета(ЭтаФорма));
			
		ИдентификаторЗадания = РезультатВыполнения.ИдентификаторЗадания;
		АдресХранилища       = РезультатВыполнения.АдресХранилища;
	КонецЕсли;
	
	Если РезультатВыполнения.ЗаданиеВыполнено Тогда
		ЗагрузитьПодготовленныеДанные();
	КонецЕсли;
	
	Элементы.Сформировать.КнопкаПоУмолчанию = Истина;
		
	Возврат РезультатВыполнения;
	
КонецФункции

&НаКлиенте
Процедура ВыбратьПериодЗавершение(РезультатВыбора, ДопПараметры) Экспорт
	
	Если РезультатВыбора = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ЗаполнитьЗначенияСвойств(Отчет, РезультатВыбора, "НачалоПериода,КонецПериода");
	
	ОбработатьВыборПериодаНаСервере();
	
	ОбновитьТекстЗаголовка(ЭтаФорма); 
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ОбработатьВыборПериодаНаСервере()
	
	УчетНДСПереопределяемый.ФормаОтчетаОбработатьВыборПериода(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОткрытьНастройки()
    Элементы.РазделыОтчета.ТекущаяСтраница = Элементы.НастройкиОтчета;
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ЗакрытьНастройки()
	Элементы.РазделыОтчета.ТекущаяСтраница = Элементы.Отчет;	
КонецПроцедуры

#КонецОбласти 
