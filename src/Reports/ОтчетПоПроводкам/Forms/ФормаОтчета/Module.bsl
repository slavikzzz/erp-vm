#Область ОписаниеПеременных

&НаКлиенте
Перем ПараметрыОбработчикаОжидания; 

&НаКлиенте
Перем ПараметрыОбработчикаОжиданияАктуализации Экспорт;

&НаКлиенте
Перем УИДЗамера;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	БухгалтерскиеОтчетыВызовСервера.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОбновитьТекстЗаголовка(ЭтаФорма);
		
	ИБФайловая = СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиента().ИнформационнаяБазаФайловая;
	ПодключитьОбработчикОжидания = Не ИБФайловая И ЗначениеЗаполнено(ИдентификаторЗадания);
	Если ПодключитьОбработчикОжидания Тогда		
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "ФормированиеОтчета");
			
	ИначеЕсли Отчет.РежимРасшифровки Тогда
		БухгалтерскийУчетКлиентПереопределяемый.ПослеФормированияОтчета(ЭтотОбъект);
	КонецЕсли;
	
	БухгалтерскиеОтчетыКлиент.ПриОткрытии(ЭтаФорма, Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	БухгалтерскиеОтчетыКлиент.ПередЗакрытием(ЭтаФорма, Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка, Отчет.РежимРасшифровки);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	БухгалтерскиеОтчетыКлиент.ПриЗакрытии(ЭтаФорма, ЗавершениеРаботы);
	
КонецПроцедуры

&НаСервере
Процедура ПриСохраненииПользовательскихНастроекНаСервере(Настройки)
	
	БухгалтерскиеОтчетыВызовСервера.ПриСохраненииПользовательскихНастроекНаСервере(ЭтаФорма, Настройки);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеПользовательскихНастроекНаСервере(Настройки, ИспользуютсяСтандартныеНастройки)
	
	Если ИспользуютсяСтандартныеНастройки Тогда
		Возврат;
	КонецЕсли;
	
	Если Не КомпоновщикИнициализирован Тогда
		ПользовательскиеНастройки = ПоместитьВоВременноеХранилище(Настройки, УникальныйИдентификатор);
	КонецЕсли;
	
	БухгалтерскиеОтчетыВызовСервера.ПриЗагрузкеПользовательскихНастроекНаСервере(ЭтаФорма, Настройки);
	
	Если Не КомпоновщикИнициализирован И ОбщегоНазначения.ЭтоВебКлиент() Тогда
		ИнициализацияКомпоновщикаНастроек();
		РазделыНастроек = Элементы.РазделыНастроек.ПодчиненныеЭлементы;
		Элементы.РазделыНастроек.ТекущаяСтраница = РазделыНастроек.ГруппаОтбор;
	КонецЕсли;
	
	ОбновитьТекстЗаголовка(ЭтаФорма);
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	БухгалтерскийУчетКлиентПереопределяемый.ОбработкаОповещенияАктуализации(ЭтотОбъект, Отчет.Организация, Отчет.КонецПериода, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

#Область Период

&НаКлиенте
Процедура ВыбратьПериод(Команда)
	
	ПараметрыВыбора = Новый Структура("НачалоПериода,КонецПериода", Отчет.НачалоПериода, Отчет.КонецПериода);
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыбратьПериодЗавершение", ЭтотОбъект);
	ОткрытьФорму("ОбщаяФорма.ВыборСтандартногоПериода", ПараметрыВыбора, Элементы.ВыбратьПериод, , , , ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьПериодЗавершение(РезультатВыбора, ДопПараметры) Экспорт
	
	Если РезультатВыбора = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ЗаполнитьЗначенияСвойств(Отчет, РезультатВыбора, "НачалоПериода,КонецПериода");
	
	ОбновитьТекстЗаголовкаИАктуализации(); 
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
	БухгалтерскийУчетКлиентПереопределяемый.СкрытьПанельАктуализацииАвтоматически(ЭтотОбъект);

КонецПроцедуры

&НаКлиенте
Процедура НачалоПериодаПриИзменении(Элемент)
	ОбновитьТекстЗаголовкаИАктуализации();
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
	БухгалтерскийУчетКлиентПереопределяемый.СкрытьПанельАктуализацииАвтоматически(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура КонецПериодаПриИзменении(Элемент)
	ОбновитьТекстЗаголовкаИАктуализации();
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
	БухгалтерскийУчетКлиентПереопределяемый.СкрытьПанельАктуализацииАвтоматически(ЭтотОбъект);
КонецПроцедуры

#КонецОбласти

#Область Организация

&НаКлиенте
Процедура ПолеОрганизацияПриИзменении(Элемент)
	
	ОбщегоНазначенияБПКлиент.ПолеОрганизацияПриИзменении(Элемент, ПолеОрганизация,
		Отчет.Организация, Отчет.ВключатьОбособленныеПодразделения);
	
	ОбновитьТекстЗаголовкаИАктуализации();
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
	БухгалтерскиеОтчетыКлиент.ОрганизацияПриИзменении(ЭтаФорма, Элемент);
	
	БухгалтерскийУчетКлиентПереопределяемый.СкрытьПанельАктуализацииАвтоматически(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолеОрганизацияОткрытие(Элемент, СтандартнаяОбработка)
	
	ОбщегоНазначенияБПКлиент.ПолеОрганизацияОткрытие(Элемент, СтандартнаяОбработка,
		ПолеОрганизация, СоответствиеОрганизаций);
		
КонецПроцедуры

&НаКлиенте
Процедура ПолеОрганизацияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ОбщегоНазначенияБПКлиент.ПолеОрганизацияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка, 
		СоответствиеОрганизаций, Отчет.Организация, Отчет.ВключатьОбособленныеПодразделения);
	
КонецПроцедуры

#КонецОбласти

#Область Результат

&НаКлиенте
Процедура РезультатПриАктивизации(Элемент)
	
	БухгалтерскиеОтчетыКлиент.НачатьРасчетСуммыВыделенныхЯчеек(
		Элементы.Результат,
		ЭтотОбъект,
		"Подключаемый_РезультатПриАктивизацииПодключаемый");
	
КонецПроцедуры

&НаКлиенте
Процедура РезультатОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	
	БухгалтерскиеОтчетыКлиент.ОбработкаРасшифровкиСтандартногоОтчета(ЭтаФорма, Элемент, Расшифровка, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура РезультатОбработкаДополнительнойРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	
	// Не будем обрабатывать нажатие на правую кнопку мыши.
	// Покажем стандартное контекстное меню ячейки табличного документа.
	Расшифровка = Неопределено;
	
КонецПроцедуры

#КонецОбласти

#Область Показатели

&НаКлиенте
Процедура ПоказательБУПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказательНУПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказательПРПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказательВРПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказательВалютнаяСуммаПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказательКоличествоПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Отборы

&НаКлиенте
Процедура ОтборыПриИзменении(Элемент)
	
	БухгалтерскиеОтчетыКлиент.ОтборыПриИзменении(ЭтаФорма, Элемент, Ложь);
	
	ОбновитьТекстЗаголовка(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборыПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	БухгалтерскиеОтчетыКлиент.ОтборыПередНачаломДобавления(ЭтаФорма, Элемент, Отказ, Копирование, Родитель, Группа);

КонецПроцедуры

&НаКлиенте
Процедура ОтборыПередНачаломИзменения(Элемент, Отказ)
	
	БухгалтерскиеОтчетыКлиент.ОтборыПередНачаломИзменения(ЭтаФорма, Элемент, Отказ);	
	
КонецПроцедуры

#КонецОбласти

#Область Оформление

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

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СформироватьОтчет(Команда)
	
	ОчиститьСообщения();
	
	ОтключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания");
	
	// СтандартныеПодсистемы.ОценкаПроизводительности
	УИДЗамера = ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Ложь, "ФормированиеОтчетаОтчетПоПроводкам");
	// СтандартныеПодсистемы.ОценкаПроизводительности
	
	РезультатВыполнения = СформироватьОтчетНаСервере();
	Если Не РезультатВыполнения.ЗаданиеВыполнено Тогда
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "ФормированиеОтчета");
	Иначе
		
		ЗафиксироватьДлительностьКлючевойОперации();
				
		Если НЕ РезультатВыполнения.Свойство("ОтказПроверкиЗаполнения") Тогда
			БухгалтерскийУчетКлиентПереопределяемый.ПослеФормированияОтчета(ЭтотОбъект);
		КонецЕсли;
		
	КонецЕсли;
	
	Если РезультатВыполнения.Свойство("ОтказПроверкиЗаполнения") Тогда
		ПоказатьНастройки("");
	Иначе	
		СкрытьНастройки();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПроверитьАктуальность()
	
	БухгалтерскийУчетКлиентПереопределяемый.ПроверитьАктуальность(ЭтотОбъект, Отчет.Организация, Отчет.КонецПериода);

КонецПроцедуры

&НаКлиенте
Процедура Актуализировать(Команда)
	
	БухгалтерскийУчетКлиентПереопределяемый.Актуализировать(ЭтотОбъект, Отчет.Организация, Отчет.КонецПериода);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеАктуализации()
	
	БухгалтерскийУчетКлиентПереопределяемый.ПроверитьВыполнениеАктуализацииОтчета(ЭтотОбъект, Отчет.Организация, Отчет.КонецПериода);

КонецПроцедуры

&НаКлиенте
Процедура ОтменитьАктуализацию(Команда)
	
	БухгалтерскийУчетКлиентПереопределяемый.ОтменитьАктуализацию(ЭтотОбъект, Отчет.Организация, Отчет.КонецПериода);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытиеМесяцаЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = "СформироватьОтчет" Тогда
		
		БухгалтерскийУчетКлиентПереопределяемый.СкрытьПанельАктуализации(ЭтотОбъект);
		Активизировать();
		СформироватьОтчет("");
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьКак(Команда)
	
	БухгалтерскиеОтчетыКлиент.ОтчетСохранитьКак(ЭтотОбъект);

КонецПроцедуры

&НаКлиенте
Процедура ОтправитьПоЭлектроннойПочте(Команда)
	
	ОтправкаПочтовыхСообщенийКлиент.ОтправитьОтчет(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СкрытьНажатие(Элемент)
	
	БухгалтерскийУчетКлиентПереопределяемый.СкрытьПанельАктуализации(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПроверитьЗавершениеАктуализации()
	
	БухгалтерскийУчетКлиентПереопределяемый.ПроверитьЗавершениеАктуализации(ЭтотОбъект, Отчет.Организация, Отчет.КонецПериода);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьНастройки(Команда)
	
	Элементы.Сформировать.КнопкаПоУмолчанию = Истина;
	СкрытьНастройки();
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьНастройки(Команда)
	Элементы.ПрименитьНастройки.КнопкаПоУмолчанию = Истина;

	Если Не КомпоновщикИнициализирован Тогда
		ИнициализацияКомпоновщикаНастроек();
	КонецЕсли;

	ОткрытьНастройки();
КонецПроцедуры

#Область РегистрыУчета

&НаКлиенте
Процедура СохранитьРегистрУчета(Команда)
	
	РегистрыУчетаКлиент.СохранитьРегистрУчета(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьРегистрУчетаИПодписатьЭП(Команда)
	
	РегистрыУчетаКлиент.СохранитьРегистрУчета(ЭтаФорма, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьАрхивРегистровУчета(Команда)
	
	РегистрыУчетаКлиент.ОткрытьАрхивРегистровУчета(ЭтаФорма);

КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ПодготовитьПараметрыОтчета()
	
	ПараметрыОтчета = Новый Структура;
	ПараметрыОтчета.Вставить("Организация"                      , Отчет.Организация);
	ПараметрыОтчета.Вставить("НачалоПериода"                    , Отчет.НачалоПериода);
	ПараметрыОтчета.Вставить("КонецПериода"                     , Отчет.КонецПериода);
	ПараметрыОтчета.Вставить("ВключатьОбособленныеПодразделения", Отчет.ВключатьОбособленныеПодразделения);
	ПараметрыОтчета.Вставить("ПоказательБУ"                     , Отчет.ПоказательБУ);
	ПараметрыОтчета.Вставить("ПоказательНУ"                     , Отчет.ПоказательНУ);
	ПараметрыОтчета.Вставить("ПоказательПР"                     , Отчет.ПоказательПР);
	ПараметрыОтчета.Вставить("ПоказательВР"                     , Отчет.ПоказательВР);
	ПараметрыОтчета.Вставить("ПоказательКонтроль"               , Ложь);
	ПараметрыОтчета.Вставить("ПоказательВалютнаяСумма"          , Мин(Отчет.ПоказательВалютнаяСумма, БухгалтерскийУчетПереопределяемый.ИспользоватьВалютныйУчет()));
	ПараметрыОтчета.Вставить("ПоказательКоличество"             , Отчет.ПоказательКоличество);
	ПараметрыОтчета.Вставить("РежимРасшифровки"                 , Отчет.РежимРасшифровки);
	ПараметрыОтчета.Вставить("ВыводитьЗаголовок"                , ВыводитьЗаголовок);
	ПараметрыОтчета.Вставить("ВыводитьПодвал"                   , ВыводитьПодвал);
	ПараметрыОтчета.Вставить("ДанныеРасшифровки"                , ДанныеРасшифровки);
	ПараметрыОтчета.Вставить("МакетОформления"                  , МакетОформления);	
	ПараметрыОтчета.Вставить("СхемаКомпоновкиДанных"            , ПолучитьИзВременногоХранилища(СхемаКомпоновкиДанных));
	ПараметрыОтчета.Вставить("ИдентификаторОтчета"              , БухгалтерскиеОтчетыКлиентСервер.ПолучитьИдентификаторОбъекта(ЭтаФорма));
	ПараметрыОтчета.Вставить("НастройкиКомпоновкиДанных"        , Отчет.КомпоновщикНастроек.ПолучитьНастройки());
	ПараметрыОтчета.Вставить("НаборПоказателей"                 , Отчеты[ПараметрыОтчета.ИдентификаторОтчета].ПолучитьНаборПоказателей());
	ПараметрыОтчета.Вставить("ОтветственноеЛицо"                , Перечисления.ОтветственныеЛицаОрганизаций.ОтветственныйЗаБухгалтерскиеРегистры);
	ПараметрыОтчета.Вставить("ВыводитьЕдиницуИзмерения"         , ВыводитьЕдиницуИзмерения);
	
	БухгалтерскиеОтчетыПереопределяемый.ДополнительныеПараметрыОтчета(ПараметрыОтчета, Отчет);
	
	Возврат ПараметрыОтчета;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьТекстЗаголовка(Форма)
	
	Отчет = Форма.Отчет;
	
	ЗаголовокОтчета = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Отчет по проводкам%1';
			|en = 'Posting report%1'"),
		БухгалтерскиеОтчетыКлиентСервер.ПолучитьПредставлениеПериода(Отчет.НачалоПериода, Отчет.КонецПериода));

	Если ЗначениеЗаполнено(Отчет.Организация) И Форма.ИспользуетсяНесколькоОрганизаций Тогда
		ЗаголовокОтчета = ЗаголовокОтчета + " " + БухгалтерскиеОтчетыВызовСервера.ПолучитьТекстОрганизация(
			Отчет.Организация, Отчет.ВключатьОбособленныеПодразделения, Отчет.КонецПериода);
	КонецЕсли;
	
	Форма.Заголовок = ЗаголовокОтчета;

КонецПроцедуры

&НаКлиенте
Функция ПолучитьЗапрещенныеПоля(Режим = "") Экспорт
	
	СписокПолей = Новый Массив;
	
	СписокПолей.Добавить("UserFields");
	СписокПолей.Добавить("DataParameters");
	СписокПолей.Добавить("SystemFields");
	СписокПолей.Добавить("Показатели");
	СписокПолей.Добавить("Период");
	
	Если Режим = "Отбор" Тогда
		Для Каждого ИмяПоказателя Из НаборПоказателей Цикл
			Если Не Отчет["Показатель" + ИмяПоказателя] Тогда
				СписокПолей.Добавить(ИмяПоказателя + "Дт");
				СписокПолей.Добавить(ИмяПоказателя + "Кт");
				Если ИмяПоказателя = "ВалютнаяСумма" Тогда
					СписокПолей.Добавить("Валюта");
					СписокПолей.Добавить("КорВалюта");
					СписокПолей.Добавить("ВалютаДт");
					СписокПолей.Добавить("ВалютаКт");
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Возврат Новый ФиксированныйМассив(СписокПолей);
	
КонецФункции

&НаСервере
Функция СформироватьОтчетНаСервере() Экспорт
	
	Если Не КомпоновщикИнициализирован Тогда
		ИнициализацияКомпоновщикаНастроек();
	КонецЕсли;
	
	Если Не ПроверитьЗаполнение() Тогда
		Возврат Новый Структура("ЗаданиеВыполнено, ОтказПроверкиЗаполнения", Истина, Истина);
	КонецЕсли;
	
	ДополнительныеСвойства = Отчет.КомпоновщикНастроек.Настройки.ДополнительныеСвойства;
	
	ИБФайловая = ОбщегоНазначения.ИнформационнаяБазаФайловая();
	
	ДлительныеОперации.ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	
	ИдентификаторЗадания = Неопределено;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
	
	Отчет.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.Вставить("ВыводитьЗаголовок", ВыводитьЗаголовок);
	Отчет.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.Вставить("ВыводитьПодвал"   , ВыводитьПодвал);
	Отчет.КомпоновщикНастроек.Настройки.Отбор.ИдентификаторПользовательскойНастройки              = "";
	Отчет.КомпоновщикНастроек.Настройки.Порядок.ИдентификаторПользовательскойНастройки            = "";
	Отчет.КомпоновщикНастроек.Настройки.УсловноеОформление.ИдентификаторПользовательскойНастройки = "";
	
	ПараметрыОтчета = ПодготовитьПараметрыОтчета();
	
	Если ИБФайловая Тогда
		АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
		БухгалтерскиеОтчетыВызовСервера.СформироватьОтчет(ПараметрыОтчета, АдресХранилища);
		РезультатВыполнения = Новый Структура("ЗаданиеВыполнено", Истина);
	Иначе
		РезультатВыполнения = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
			УникальныйИдентификатор,
			"БухгалтерскиеОтчетыВызовСервера.СформироватьОтчет",
			ПараметрыОтчета,
			БухгалтерскиеОтчетыКлиентСервер.ПолучитьНаименованиеЗаданияВыполненияОтчета(ЭтаФорма));
		
		АдресХранилища       = РезультатВыполнения.АдресХранилища;
		ИдентификаторЗадания = РезультатВыполнения.ИдентификаторЗадания;
	КонецЕсли;
	
	Если РезультатВыполнения.ЗаданиеВыполнено Тогда
		ЗагрузитьПодготовленныеДанные();
	КонецЕсли;
	
	Элементы.Сформировать.КнопкаПоУмолчанию = Истина;
	
	Возврат РезультатВыполнения;
	
КонецФункции

// Адаптирует схему компоновки данных отчета под изменившиеся настройки отчета.
//
&НаСервере
Процедура ИзменениеСхемыКомпоновкиДанныхНаСервере() Экспорт
	// Изменение схемы не требуется
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНастройкамиПоУмолчанию(ЗаполняемыеНастройки) Экспорт
	
	Если ЗаполняемыеНастройки.Свойство("Показатели") Тогда
		Если ЗаполняемыеНастройки.Показатели Тогда
			// Управление показателями
			Отчет.ПоказательБУ            = Истина;
			Отчет.ПоказательНУ            = Ложь;
			Отчет.ПоказательПР            = Ложь;
			Отчет.ПоказательВР            = Ложь;

			Отчет.ПоказательВалютнаяСумма = Ложь;
			Отчет.ПоказательКоличество    = Ложь;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьПодготовленныеДанные()

	РезультатВыполнения = ПолучитьИзВременногоХранилища(АдресХранилища);
	
	Результат = РезультатВыполнения.Результат;	

	ДанныеРасшифровки = РезультатВыполнения.ДанныеРасшифровки;
	
	ИдентификаторЗадания = Неопределено;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
	
	ДополнительныеСвойства = Отчет.КомпоновщикНастроек.Настройки.ДополнительныеСвойства;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗадания()
	
	Попытка
		Если ЗаданиеВыполнено(ИдентификаторЗадания) Тогда 
			ЗагрузитьПодготовленныеДанные();
			ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
			ЗафиксироватьДлительностьКлючевойОперации();
					
			БухгалтерскийУчетКлиентПереопределяемый.ПослеФормированияОтчета(ЭтотОбъект);
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
Процедура ВычислитьСуммуВыделенныхЯчеекТабличногоДокументаВКонтекстеНаСервере()
	
	ПолеСумма = БухгалтерскиеОтчетыВызовСервера.ВычислитьСуммуВыделенныхЯчеекТабличногоДокумента(
		Результат, КэшВыделеннойОбласти);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_РезультатПриАктивизацииПодключаемый()
	
	НеобходимоВычислятьНаСервере = Ложь;
	БухгалтерскиеОтчетыКлиент.ВычислитьСуммуВыделенныхЯчеекТабличногоДокумента(
		ПолеСумма, Результат, Элементы.Результат, КэшВыделеннойОбласти, НеобходимоВычислятьНаСервере);
	
	Если НеобходимоВычислятьНаСервере Тогда
		ВычислитьСуммуВыделенныхЯчеекТабличногоДокументаВКонтекстеНаСервере();
	КонецЕсли;
	
	ОтключитьОбработчикОжидания("Подключаемый_РезультатПриАктивизацииПодключаемый");
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(ИдентификаторЗадания)
	
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания);
	
КонецФункции

&НаКлиенте
Процедура ЗафиксироватьДлительностьКлючевойОперации()
	
	ОценкаПроизводительностиКлиент.ЗавершитьЗамерВремени(УИДЗамера);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьНастройки()
	
	Элементы.РазделыОтчета.ТекущаяСтраница = Элементы.НастройкиОтчета;
	
КонецПроцедуры

&НаКлиенте
Процедура СкрытьНастройки()
	
	Элементы.РазделыОтчета.ТекущаяСтраница = Элементы.Отчет;
	
КонецПроцедуры

&НаСервере
Процедура ИнициализацияКомпоновщикаНастроек() 

	БухгалтерскиеОтчетыВызовСервера.ИнициализацияКомпоновщикаНастроек(ЭтаФорма, Истина);

КонецПроцедуры

&НаКлиенте
Процедура ОбновитьТекстЗаголовкаИАктуализации()
	
	ОбновитьТекстЗаголовкаИАктуализацииНаСервере();
	БухгалтерскийУчетКлиентПереопределяемый.ПослеФормированияОтчета(ЭтотОбъект);

КонецПроцедуры

&НаСервере
Процедура ОбновитьТекстЗаголовкаИАктуализацииНаСервере()
	
	ОбновитьТекстЗаголовка(ЭтотОбъект);
	
	ПараметрыПроверки = БухгалтерскиеОтчетыКлиентСервер.ИнициализироватьПараметрыПроверкиАктуальности(ЭтотОбъект);
	ДанныеАктуализации = Новый Структура("ИдентификаторЗаданияАктуализации,АдресХранилищаАктуализации", "", "");
	ЗаполнитьЗначенияСвойств(ДанныеАктуализации, ЭтотОбъект);
	
	БухгалтерскиеОтчеты.ПроверитьАктуальность(ПараметрыПроверки, ДанныеАктуализации);
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеАктуализации);
	
КонецПроцедуры

#КонецОбласти