#Область ОписаниеПеременных

&НаКлиенте
Перем ПараметрыОбработчикаОжидания;


#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	БухгалтерскиеОтчетыВызовСервера.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);

	// Для этого отчета, период только месяц
	ВидПериода = Перечисления.ДоступныеПериодыОтчета.Месяц;
	
	УправлениеФормой(ЭтотОбъект);
		
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОбновитьТекстЗаголовка(ЭтотОбъект);
	
	Отчет.НаборПоказателейОтчета = 2;
		
	ИБФайловая = СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиента().ИнформационнаяБазаФайловая;
	ПодключитьОбработчикОжидания = Не ИБФайловая И ЗначениеЗаполнено(ИдентификаторЗадания);
	Если ПодключитьОбработчикОжидания Тогда
		ПодключитьОбработчикОжидания("СформироватьОтчет", 0.1, Истина);
	Иначе
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	ВариантМодифицирован                    = Ложь;
	ПользовательскиеНастройкиМодифицированы = НЕ Отчет.РежимРасшифровки;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	БухгалтерскиеОтчетыКлиент.ПриЗакрытии(ЭтотОбъект, ЗавершениеРаботы);
	
КонецПроцедуры

&НаСервере
Процедура ПриСохраненииПользовательскихНастроекНаСервере(Настройки)
	
	БухгалтерскиеОтчетыВызовСервера.ПриСохраненииПользовательскихНастроекНаСервере(ЭтотОбъект, Настройки);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеПользовательскихНастроекНаСервере(Настройки)
	
	БухгалтерскиеОтчетыВызовСервера.ПриЗагрузкеПользовательскихНастроекНаСервере(ЭтотОбъект, Настройки);
	
	ОбновитьТекстЗаголовка(ЭтотОбъект);
	
	УправлениеФормой(ЭтотОбъект);
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
	Если Параметры.Свойство("ПараметрКоманды") Тогда
		Если ТипЗнч(Параметры.ПараметрКоманды) = Тип("Массив")
			И Параметры.ПараметрКоманды.Количество()>0 Тогда
			Если ТипЗнч(Параметры.ПараметрКоманды[0]) = Тип("ДокументСсылка.ПризнаниеРасходовПоИсследованиямИРазработкам") Тогда
				Отчет.Документ = Параметры.ПараметрКоманды[0];
				ОбновитьПараметрыПоДаннымДокумента(Отчет.Документ);
			КонецЕсли;	
		КонецЕсли;	
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПериодПриИзменении(Элемент)
	
	ВыборПериодаКлиент.ПериодПриИзменении(Элемент, Период, Отчет.НачалоПериода, Отчет.КонецПериода);
	
	Период = БухгалтерскиеОтчетыКлиентСервер.ПолучитьПредставлениеПериода(Отчет.НачалоПериода, Отчет.КонецПериода, Истина);
	
	ОбновитьТекстЗаголовка(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыВыбора = Новый Структура("НачалоПериода,КонецПериода, ВидПериода", Отчет.НачалоПериода, Отчет.КонецПериода, ВидПериода);
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыбратьПериодЗавершение", ЭтотОбъект);
	ОткрытьФорму("ОбщаяФорма.ВыборСтандартногоПериодаМесяц", ПараметрыВыбора, Элементы.Период, , , , ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ВыборПериодаКлиент.ПериодОбработкаВыбора(
		Элемент, ВыбранноеЗначение, СтандартнаяОбработка,
		ВидПериода, Период, Отчет.НачалоПериода, Отчет.КонецПериода);
		
КонецПроцедуры

&НаКлиенте
Процедура ПериодАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	ВыборПериодаКлиент.ПериодАвтоПодбор(
		Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка,
		ВидПериода, Период, Отчет.НачалоПериода, Отчет.КонецПериода);
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	ВыборПериодаКлиент.ПериодОкончаниеВводаТекста(
		Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка,
		ВидПериода, Период, Отчет.НачалоПериода, Отчет.КонецПериода);
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	БухгалтерскиеОтчетыКлиент.ОрганизацияПриИзменении(ЭтотОбъект, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ДокументПриИзменении(Элемент)
	
	ОбновитьПараметрыПоДаннымДокумента(Отчет.Документ);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СформироватьОтчет(Команда)
	
	ОчиститьСообщения();
	
	Если ПроверитьЗаполнение() Тогда
		СформироватьВФоне();
	КонецЕсли;	
		
	СкрытьНастройки();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьНастройки(Команда)
	
	Элементы.Сформировать.КнопкаПоУмолчанию = Истина;
	СкрытьНастройки();
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьНастройки(Команда)
	Элементы.ПрименитьНастройки.КнопкаПоУмолчанию = Истина;
	ОткрытьНастройки();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийПоляТабличногоДокумента

&НаКлиенте
Процедура РезультатПриАктивизацииОбласти(Элемент)
	
	Если ТипЗнч(Результат.ВыделенныеОбласти) = Тип("ВыделенныеОбластиТабличногоДокумента") Тогда
		ИнтервалОжидания = ?(ПолучитьСкоростьКлиентскогоСоединения() = СкоростьКлиентскогоСоединения.Низкая, 1, 0.2);
		ПодключитьОбработчикОжидания("Подключаемый_РезультатПриАктивизацииОбластиПодключаемый", ИнтервалОжидания, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РезультатОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	
	БухгалтерскиеОтчетыКлиент.ОбработкаРасшифровкиСтандартногоОтчета(ЭтотОбъект, Элемент, Расшифровка, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура РезультатОбработкаДополнительнойРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	
	// Не будем обрабатывать нажатие на правую кнопку мыши.
	// Покажем стандартное контекстное меню ячейки табличного документа.
	Расшифровка = Неопределено;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийГруппыОтборы

&НаКлиенте
Процедура ОтборыПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	БухгалтерскиеОтчетыКлиент.ОтборыПередНачаломДобавления(ЭтотОбъект, Элемент, Отказ, Копирование, Родитель, Группа);

КонецПроцедуры

&НаКлиенте
Процедура ОтборыПередНачаломИзменения(Элемент, Отказ)
	
	БухгалтерскиеОтчетыКлиент.ОтборыПередНачаломИзменения(ЭтотОбъект, Элемент, Отказ);	
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборыПередУдалением(Элемент, Отказ)
	
	Если Элемент.ТекущиеДанные.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный Тогда
		РежимОтображенияНедоступный = Истина;
	Иначе
		РежимОтображенияНедоступный = Ложь;
	КонецЕсли;
	
	Отказ = РежимОтображенияНедоступный;
	
КонецПроцедуры

#КонецОбласти

#Область  ОбработчикиСобытийГруппыРегистрУчета

&НаКлиенте
Процедура СохранитьРегистрУчета(Команда)
	
	РегистрыУчетаКлиент.СохранитьРегистрУчета(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьРегистрУчетаИПодписатьЭП(Команда)
	
	РегистрыУчетаКлиент.СохранитьРегистрУчета(ЭтотОбъект, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьАрхивРегистровУчета(Команда)
	
	РегистрыУчетаКлиент.ОткрытьАрхивРегистровУчета(ЭтотОбъект);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийГруппыОформление

&НаКлиенте
Процедура МакетОформленияПриИзменении(Элемент)
	
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметрВывода(Отчет.КомпоновщикНастроек.Настройки, "МакетОформления", МакетОформления);
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыводитьЗаголовокПриИзменении(Элемент)

	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ВыводитьПодвалПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ВыводитьЕдиницуИзмеренияПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ВыбратьПериодЗавершение(РезультатВыбора, ДопПараметры) Экспорт
	
	Если РезультатВыбора = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(Отчет, РезультатВыбора, "НачалоПериода,КонецПериода");
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Отчет    = Форма.Отчет;
	
	Форма.Период = ВыборПериодаКлиентСервер.ПолучитьПредставлениеПериодаОтчета(
		Форма.ВидПериода, Отчет.НачалоПериода, Отчет.КонецПериода);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьТекстЗаголовка(Форма)
	
	Отчет = Форма.Отчет;
	ЗаголовокОтчета = НСтр("ru = 'Справка-расчет ""Признание расходов по НИОКР""';
							|en = 'Detailed calculation ""Recognition of R&D expenses""'")
		+ БухгалтерскиеОтчетыКлиентСервер.ПолучитьПредставлениеПериода(
			Отчет.НачалоПериода,
			Отчет.КонецПериода);

	Если ЗначениеЗаполнено(Отчет.Организация) И Форма.ИспользуетсяНесколькоОрганизаций Тогда
		ЗаголовокОтчета = ЗаголовокОтчета + " " + БухгалтерскиеОтчетыВызовСервера.ПолучитьТекстОрганизация(
			Отчет.Организация,
			Отчет.ВключатьОбособленныеПодразделения);
	КонецЕсли;

	Форма.Заголовок = ЗаголовокОтчета;
	
КонецПроцедуры

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

&НаКлиенте
Процедура ОткрытьНастройки()
	
	Элементы.РазделыОтчета.ТекущаяСтраница = Элементы.НастройкиОтчета;
	
КонецПроцедуры

&НаКлиенте
Процедура СкрытьНастройки()
	
	Элементы.РазделыОтчета.ТекущаяСтраница = Элементы.Отчет;
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьВФоне()
	
	ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "ФормированиеОтчета");
	
	ДлительнаяОперация = ВыполнитьФормированиеОтчетаВФоне();

	Если ДлительнаяОперация <> Неопределено Тогда
		ИдентификаторЗадания = ДлительнаяОперация.ИдентификаторЗадания;
		ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
		ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
		ПараметрыОжидания.Интервал = 0; 
		ОповещениеОЗавершении = Новый ОписаниеОповещения("ОбработатьЗавершениеФормированияВФоне", ЭтотОбъект);
		ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, ОповещениеОЗавершении, ПараметрыОжидания);
	Иначе
		Результат = Неопределено;
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьЗавершениеФормированияВФоне(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		Если Результат.Статус = "Выполнено" Тогда
			
			АдресХранилища = Результат.АдресРезультата;
			
			ЗагрузитьПодготовленныеДанные();
			
		ИначеЕсли Результат.Статус = "Ошибка" Тогда
			ВызватьИсключение Результат.ПодробноеПредставлениеОшибки;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ВыполнитьФормированиеОтчетаВФоне()
		
	ДлительныеОперации.ОтменитьВыполнениеЗадания(ИдентификаторЗадания);

	ИдентификаторЗадания = Неопределено;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");

	Отчет.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.Вставить("ВыводитьЗаголовок", ВыводитьЗаголовок);
	Отчет.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.Вставить("ВыводитьПодвал"   , ВыводитьПодвал);
	Отчет.КомпоновщикНастроек.Настройки.Отбор.ИдентификаторПользовательскойНастройки              = "";
	Отчет.КомпоновщикНастроек.Настройки.Порядок.ИдентификаторПользовательскойНастройки            = "";
	Отчет.КомпоновщикНастроек.Настройки.УсловноеОформление.ИдентификаторПользовательскойНастройки = "";
	
	ПараметрыОтчета = ПодготовитьПараметрыОтчета();
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.ОжидатьЗавершение = 0; // запускать сразу
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Справка-расчет ""Признание расходов по НИОКР в НУ""';
															|en = 'Detailed calculation ""Recognition of R&D expenses in TA""'");
		
	РезультатФоновогоЗадания = ДлительныеОперации.ВыполнитьВФоне("БухгалтерскиеОтчетыВызовСервера.СформироватьОтчет",
		ПараметрыОтчета, ПараметрыВыполнения);
		
	Элементы.Сформировать.КнопкаПоУмолчанию = Истина;
	
	Возврат РезультатФоновогоЗадания;

КонецФункции

&НаСервере
Функция ПодготовитьПараметрыОтчета()
	
	ПараметрыОтчета = Новый Структура;
	ПараметрыОтчета.Вставить("Организация"                      , Отчет.Организация);
	ПараметрыОтчета.Вставить("НачалоПериода"                    , Отчет.НачалоПериода);
	ПараметрыОтчета.Вставить("КонецПериода"                     , Отчет.КонецПериода);
	ПараметрыОтчета.Вставить("ДокументПризнанияРасходов"    	, Отчет.Документ);
	ПараметрыОтчета.Вставить("ВключатьОбособленныеПодразделения", Отчет.ВключатьОбособленныеПодразделения);
	
	Если Отчет.НаборПоказателейОтчета = 1 Тогда
		ПараметрыОтчета.Вставить("ПоказательБУ"                     , Истина);
		ПараметрыОтчета.Вставить("ПоказательНУ"                     , Ложь);
		ПараметрыОтчета.Вставить("ПоказательПР"                     , Ложь);
		ПараметрыОтчета.Вставить("ПоказательВР"                     , Ложь);
		ПараметрыОтчета.Вставить("НазваниеНабораПоказателейОтчета"  , НСтр("ru = 'бухгалтерский учет';
																			|en = 'bookkeeping'"));
	ИначеЕсли Отчет.НаборПоказателейОтчета = 2 Тогда
		ПараметрыОтчета.Вставить("ПоказательБУ"                     , Ложь);
		ПараметрыОтчета.Вставить("ПоказательНУ"                     , Истина);
		ПараметрыОтчета.Вставить("ПоказательПР"                     , Ложь);
		ПараметрыОтчета.Вставить("ПоказательВР"                     , Ложь);
		ПараметрыОтчета.Вставить("НазваниеНабораПоказателейОтчета"  , НСтр("ru = 'налоговый учет';
																			|en = 'tax accounting'"));
	ИначеЕсли Отчет.НаборПоказателейОтчета = 3 Тогда
		ПараметрыОтчета.Вставить("ПоказательБУ"                     , Истина);
		ПараметрыОтчета.Вставить("ПоказательНУ"                     , Ложь);
		ПараметрыОтчета.Вставить("ПоказательПР"                     , Истина);
		ПараметрыОтчета.Вставить("ПоказательВР"                     , Истина);
		ПараметрыОтчета.Вставить("НазваниеНабораПоказателейОтчета"  , НСтр("ru = 'бухгалтерский учет с постоянными и временными разницами';
																			|en = 'bookkeeping with permanent and temporary differences'"));
	КонецЕсли;	
	ПараметрыОтчета.Вставить("РежимРасшифровки"                 , Отчет.РежимРасшифровки);
	ПараметрыОтчета.Вставить("ДанныеРасшифровки"                , ДанныеРасшифровки);
	ПараметрыОтчета.Вставить("МакетОформления"                  , МакетОформления);	
	ПараметрыОтчета.Вставить("СхемаКомпоновкиДанных"            , ПолучитьИзВременногоХранилища(СхемаКомпоновкиДанных));
	ПараметрыОтчета.Вставить("ИдентификаторОтчета"              , БухгалтерскиеОтчетыКлиентСервер.ПолучитьИдентификаторОбъекта(ЭтотОбъект));
	ПараметрыОтчета.Вставить("НастройкиКомпоновкиДанных"        , Отчет.КомпоновщикНастроек.ПолучитьНастройки());
	ПараметрыОтчета.Вставить("НаборПоказателей"                 , Отчеты[ПараметрыОтчета.ИдентификаторОтчета].ПолучитьНаборПоказателей());
	ПараметрыОтчета.Вставить("ОтветственноеЛицо"            	,?(Отчет.НаборПоказателейОтчета = 2, Перечисления.ОтветственныеЛицаОрганизаций.ОтветственныйЗаНалоговыеРегистры, Перечисления.ОтветственныеЛицаОрганизаций.ОтветственныйЗаБухгалтерскиеРегистры));
	
	Возврат ПараметрыОтчета;
	
КонецФункции

&НаСервере
Процедура ЗагрузитьПодготовленныеДанные()

	РезультатВыполнения = ПолучитьИзВременногоХранилища(АдресХранилища);
	Результат         = РезультатВыполнения.Результат;
	ДанныеРасшифровки = РезультатВыполнения.ДанныеРасшифровки;
	
	ИдентификаторЗадания = Неопределено;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьЗапрещенныеПоля(Режим = "") Экспорт
	
	СписокПолей = Новый Массив;
	
	СписокПолей.Добавить("UserFields");
	СписокПолей.Добавить("DataParameters");
	СписокПолей.Добавить("SystemFields");
	СписокПолей.Добавить("Показатели");
	СписокПолей.Добавить("Параметры");
	СписокПолей.Добавить("Ресурсы");
	СписокПолей.Добавить("ПоказателиВыпуска");
	СписокПолей.Добавить("Группировки");
	СписокПолей.Добавить("Организация");
	СписокПолей.Добавить("Подразделение");
		
	Возврат Новый ФиксированныйМассив(СписокПолей);
	
КонецФункции

&НаСервере
Процедура ОбновитьПараметрыПоДаннымДокумента(Документ)

	Если ЗначениеЗаполнено(Документ) Тогда
		Реквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Документ, "Дата, Организация");
		Отчет.Организация = Реквизиты.Организация;
		Отчет.НачалоПериода = НачалоМесяца(Реквизиты.Дата);
		Отчет.КонецПериода = КонецМесяца(Реквизиты.Дата);
		Период = БухгалтерскиеОтчетыКлиентСервер.ПолучитьПредставлениеПериода(Отчет.НачалоПериода, Отчет.КонецПериода, Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

