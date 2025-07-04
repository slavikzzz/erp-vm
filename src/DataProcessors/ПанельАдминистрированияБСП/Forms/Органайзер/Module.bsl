///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОписаниеПеременных

&НаКлиенте
Перем ОбновитьИнтерфейс;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.БизнесПроцессыИЗадачи") Тогда
		Если Пользователи.ЭтоПолноправныйПользователь() Тогда
			ЕстьПочта = ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСПочтовымиСообщениями");
			РегламентноеЗадание = НайтиРегламентноеЗадание("МониторингЗадач");
			Если ЕстьПочта И РегламентноеЗадание <> Неопределено Тогда
				МониторингЗадачИспользование = РегламентноеЗадание.Использование;
				МониторингЗадачРасписание    = РегламентноеЗадание.Расписание;
			Иначе
				Элементы.ГруппаМониторингЗадач.Видимость = Ложь;
			КонецЕсли;
			РегламентноеЗадание = НайтиРегламентноеЗадание("УведомлениеИсполнителейОНовыхЗадачах");
			Если ЕстьПочта И РегламентноеЗадание <> Неопределено Тогда
				УведомлениеИсполнителейОНовыхЗадачахИспользование = РегламентноеЗадание.Использование;
				УведомлениеИсполнителейОНовыхЗадачахРасписание    = РегламентноеЗадание.Расписание;
			Иначе
				Элементы.ГруппаУведомлениеИсполнителейОНовыхЗадачах.Видимость = Ложь;
			КонецЕсли;
		Иначе
			Элементы.ГруппаМониторингЗадач.Видимость = Ложь;
			Элементы.ГруппаУведомлениеИсполнителейОНовыхЗадачах.Видимость = Ложь;
		КонецЕсли;
		
		Если ОбщегоНазначения.РазделениеВключено() Тогда
			Элементы.МониторингЗадачНастроитьРасписание.Видимость = Ложь;
			Элементы.УведомлениеИсполнителейОНовыхЗадачахНастроитьРасписание.Видимость = Ложь;
		КонецЕсли;
	Иначе
		Элементы.ГруппаБизнесПроцессыИЗадачи.Видимость = Ложь;
	КонецЕсли;
	
	// Обновление состояния элементов.
	УстановитьДоступность();
	
	НастройкиПрограммыПереопределяемый.ОрганайзерПриСозданииНаСервере(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	ОбновитьИнтерфейсПрограммы();
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия <> "Запись_НаборКонстант" Тогда
		Возврат;
	КонецЕсли;
	
	Если Источник = "ИспользоватьВнешнихПользователей" Тогда
		
		Прочитать();
		УстановитьДоступность();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИспользоватьПочтовыйКлиентПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьПрочиеВзаимодействияПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ОтправлятьПисьмаВФорматеHTMLПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьПризнакРассмотреноПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ЗапретитьОтображениеНебезопасногоСодержимогоВПисьмахПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьЗаметкиПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьНапоминанияПользователяПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьАнкетированиеПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьШаблоныСообщенийПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьБизнесПроцессыИЗадачиПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьПодчиненныеБизнесПроцессыПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИзменятьЗаданияЗаднимЧисломПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьДатуНачалаЗадачПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьДатуИВремяВСрокахЗадачПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьИнцидентыПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры
#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура РолиИИсполнителиЗадач(Команда)
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.БизнесПроцессыИЗадачи") Тогда
		МодульБизнесПроцессыИЗадачиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("БизнесПроцессыИЗадачиКлиент");
		МодульБизнесПроцессыИЗадачиКлиент.ОткрытьСписокРолейИИсполнителейЗадач();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура МониторингЗадачНастроитьРасписание(Команда)
	Диалог = Новый ДиалогРасписанияРегламентногоЗадания(МониторингЗадачРасписание);
	Диалог.Показать(Новый ОписаниеОповещения("МониторингЗадачПослеИзмененияРасписания", ЭтотОбъект));
КонецПроцедуры

&НаКлиенте
Процедура УведомлениеИсполнителейОНовыхЗадачахНастроитьРасписание(Команда)
	Диалог = Новый ДиалогРасписанияРегламентногоЗадания(УведомлениеИсполнителейОНовыхЗадачахРасписание);
	Диалог.Показать(Новый ОписаниеОповещения("УведомлениеИсполнителейОНовыхЗадачахПослеИзмененияРасписания", ЭтотОбъект));
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// Клиент

&НаКлиенте
Процедура Подключаемый_ПриИзмененииРеквизита(Элемент, ОбновлятьИнтерфейс = Истина)
	
	ИмяКонстанты = ПриИзмененииРеквизитаСервер(Элемент.Имя);
	ОбновитьПовторноИспользуемыеЗначения();
	
	Если ОбновлятьИнтерфейс Тогда
		ОбновитьИнтерфейс = Истина;
		ПодключитьОбработчикОжидания("ОбновитьИнтерфейсПрограммы", 2, Истина);
	КонецЕсли;
	
	Если ИмяКонстанты <> "" Тогда
		Оповестить("Запись_НаборКонстант", Новый Структура, ИмяКонстанты);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИнтерфейсПрограммы()
	
	Если ОбновитьИнтерфейс = Истина Тогда
		ОбновитьИнтерфейс = Ложь;
		ОбщегоНазначенияКлиент.ОбновитьИнтерфейсПрограммы();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура МониторингЗадачПослеИзмененияРасписания(Расписание, ПараметрыВыполнения) Экспорт
	Если Расписание = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	МониторингЗадачРасписание = Расписание;
	МониторингЗадачИспользование = Истина;
	ЗаписатьРегламентноеЗадание("МониторингЗадач", МониторингЗадачИспользование, 
		МониторингЗадачРасписание, "МониторингЗадачРасписание");
КонецПроцедуры

&НаКлиенте
Процедура МониторингЗадачИспользованиеПриИзменении(Элемент)
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСПочтовымиСообщениями") И МониторингЗадачИспользование Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("МониторингЗадачИспользованиеПроверкаДоступностиПочтыВыполнена", ЭтотОбъект);
		МодульРаботаСПочтовымиСообщениямиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("РаботаСПочтовымиСообщениямиКлиент");
		МодульРаботаСПочтовымиСообщениямиКлиент.ПроверитьНаличиеУчетнойЗаписиДляОтправкиПочты(ОписаниеОповещения);
	Иначе
		МониторингЗадачИспользованиеПроверкаДоступностиПочтыВыполнена(Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура МониторингЗадачИспользованиеПроверкаДоступностиПочтыВыполнена(ПроверкаВыполнена, ДополнительныеПараметры = Неопределено) Экспорт
	
	Если ПроверкаВыполнена = Истина Тогда
		ЗаписатьРегламентноеЗадание("МониторингЗадач", МониторингЗадачИспользование, 
			МониторингЗадачРасписание, "МониторингЗадачРасписание");
	Иначе
		МониторингЗадачИспользование = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УведомлениеИсполнителейОНовыхЗадачахПослеИзмененияРасписания(Расписание, ПараметрыВыполнения) Экспорт
	Если Расписание = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	УведомлениеИсполнителейОНовыхЗадачахРасписание = Расписание;
	УведомлениеИсполнителейОНовыхЗадачахИспользование = Истина;
	ЗаписатьРегламентноеЗадание("УведомлениеИсполнителейОНовыхЗадачах", УведомлениеИсполнителейОНовыхЗадачахИспользование, 
		УведомлениеИсполнителейОНовыхЗадачахРасписание, "УведомлениеИсполнителейОНовыхЗадачахРасписание");
КонецПроцедуры

&НаКлиенте
Процедура УведомлениеИсполнителейОНовыхЗадачахИспользованиеПриИзменении(Элемент)
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСПочтовымиСообщениями") И УведомлениеИсполнителейОНовыхЗадачахИспользование Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения(
			"УведомлениеИсполнителейОНовыхЗадачахИспользованиеПроверкаДоступностиПочтыВыполнена", ЭтотОбъект);
		МодульРаботаСПочтовымиСообщениямиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("РаботаСПочтовымиСообщениямиКлиент");
		МодульРаботаСПочтовымиСообщениямиКлиент.ПроверитьНаличиеУчетнойЗаписиДляОтправкиПочты(ОписаниеОповещения);
	Иначе
		УведомлениеИсполнителейОНовыхЗадачахИспользованиеПроверкаДоступностиПочтыВыполнена(Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УведомлениеИсполнителейОНовыхЗадачахИспользованиеПроверкаДоступностиПочтыВыполнена(ПроверкаВыполнена, ДополнительныеПараметры = Неопределено) Экспорт
	
	Если ПроверкаВыполнена = Истина Тогда
		ЗаписатьРегламентноеЗадание("УведомлениеИсполнителейОНовыхЗадачах", УведомлениеИсполнителейОНовыхЗадачахИспользование, 
			УведомлениеИсполнителейОНовыхЗадачахРасписание, "УведомлениеИсполнителейОНовыхЗадачахРасписание");
	Иначе
		УведомлениеИсполнителейОНовыхЗадачахИспользование = Ложь;
	КонецЕсли;
		
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Сервер

&НаСервере
Функция ПриИзмененииРеквизитаСервер(ИмяЭлемента)
	
	РеквизитПутьКДанным = Элементы[ИмяЭлемента].ПутьКДанным;
	ИмяКонстанты = СохранитьЗначениеРеквизита(РеквизитПутьКДанным);
	Если (ИмяКонстанты = "ИспользоватьПочтовыйКлиент" ИЛИ ИмяКонстанты = "ИспользоватьБизнесПроцессыИЗадачи") 
		И Не НаборКонстант[ИмяКонстанты] Тогда
		Прочитать();
	КонецЕсли;
	УстановитьДоступность(РеквизитПутьКДанным);
	ОбновитьПовторноИспользуемыеЗначения();
	Возврат ИмяКонстанты;
	
КонецФункции

&НаСервере
Функция СохранитьЗначениеРеквизита(РеквизитПутьКДанным)
	
	ЧастиИмени = СтрРазделить(РеквизитПутьКДанным, ".");
	Если ЧастиИмени.Количество() <> 2 Тогда
		Возврат "";
	КонецЕсли;
	
	ИмяКонстанты = ЧастиИмени[1];
	КонстантаМенеджер = Константы[ИмяКонстанты];
	КонстантаЗначение = НаборКонстант[ИмяКонстанты];
	
	Если КонстантаМенеджер.Получить() <> КонстантаЗначение Тогда
		КонстантаМенеджер.Установить(КонстантаЗначение);
	КонецЕсли;
	
	Возврат ИмяКонстанты;
	
КонецФункции

&НаСервере
Процедура УстановитьДоступность(РеквизитПутьКДанным = "")
	
	Если (РеквизитПутьКДанным = "НаборКонстант.ИспользоватьПочтовыйКлиент" ИЛИ РеквизитПутьКДанным = "")
		И ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Взаимодействия") Тогда
		
		Элементы.ИспользоватьПрочиеВзаимодействия.Доступность             = НаборКонстант.ИспользоватьПочтовыйКлиент;
		Элементы.ИспользоватьПризнакРассмотрено.Доступность               = НаборКонстант.ИспользоватьПочтовыйКлиент;
		Элементы.ОтправлятьПисьмаВФорматеHTML.Доступность                 = НаборКонстант.ИспользоватьПочтовыйКлиент;
		Элементы.ЗапретитьОтображениеНебезопасногоСодержимогоВПисьмах.Доступность = НаборКонстант.ИспользоватьПочтовыйКлиент;
		
	КонецЕсли;
	
	Если (РеквизитПутьКДанным = "НаборКонстант.ИспользоватьШаблоныСообщений" ИЛИ РеквизитПутьКДанным = "")
		И ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ШаблоныСообщений") Тогда
		
		Элементы.ГруппаНастройкаШаблоныСообщений.Доступность = НаборКонстант.ИспользоватьШаблоныСообщений;
	КонецЕсли;
	
	Если (РеквизитПутьКДанным = "НаборКонстант.ИспользоватьБизнесПроцессыИЗадачи" ИЛИ РеквизитПутьКДанным = "")
		И ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.БизнесПроцессыИЗадачи") Тогда
		
		//++ НЕ ГОСИС
		ДоступностьБизнесПроцессовИЗадач =
			НЕ НаборКонстант.ИспользоватьБизнесПроцессыИЗадачи
			ИЛИ (НЕ Константы.ИспользоватьСогласованиеЗаказовКлиентов.Получить()
				И НЕ Константы.ИспользоватьСогласованиеСоглашенийСКлиентами.Получить()
				И НЕ Константы.ИспользоватьСогласованиеЗаявокНаВозвратТоваровОтКлиентов.Получить()
				И НЕ Константы.ИспользоватьСогласованиеЦенНоменклатуры.Получить()
				// ИнтеграцияС1СДокументооборотом
				И НЕ Константы.ИспользоватьИнтеграциюС1СДокументооборот.Получить()
				// Конец ИнтеграцияС1СДокументооборотом
				И НЕ Константы.ИспользоватьСогласованиеЗаказовПоставщикам.Получить()
				И НЕ Константы.ИспользоватьСогласованиеЗаказовНаВнутреннееПотребление.Получить());
		Элементы.ИспользоватьБизнесПроцессыИЗадачи.Доступность 		   = ДоступностьБизнесПроцессовИЗадач;
		Элементы.ГруппаКомментарийИспользоватьБизнесПроцессы.Видимость = НЕ ДоступностьБизнесПроцессовИЗадач;
		
		Если НЕ ДоступностьБизнесПроцессовИЗадач Тогда
			Элементы.КомментарийИспользоватьБизнесПроцессы.Заголовок = ТекстКомментарияИспользоватьБизнесПроцессы();
		КонецЕсли;
		//-- НЕ ГОСИС
		
		Элементы.ОткрытьРолиИИсполнителиБизнесПроцессов.Доступность = НаборКонстант.ИспользоватьБизнесПроцессыИЗадачи;
		Элементы.ИспользоватьПодчиненныеБизнесПроцессы.Доступность  = НаборКонстант.ИспользоватьБизнесПроцессыИЗадачи;
		Элементы.ИзменятьЗаданияЗаднимЧислом.Доступность            = НаборКонстант.ИспользоватьБизнесПроцессыИЗадачи;
		Элементы.ИспользоватьДатуНачалаЗадач.Доступность            = НаборКонстант.ИспользоватьБизнесПроцессыИЗадачи;
		Элементы.ИспользоватьДатуИВремяВСрокахЗадач.Доступность     = НаборКонстант.ИспользоватьБизнесПроцессыИЗадачи;
		Элементы.ГруппаМониторингЗадач.Доступность					= НаборКонстант.ИспользоватьБизнесПроцессыИЗадачи;
		Элементы.ГруппаУведомлениеИсполнителейОНовыхЗадачах.Доступность = НаборКонстант.ИспользоватьБизнесПроцессыИЗадачи;
		
	КонецЕсли;
	
	Если Элементы.ГруппаМониторингЗадач.Видимость
		И (РеквизитПутьКДанным = "МониторингЗадачРасписание" Или РеквизитПутьКДанным = "")
		И ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.БизнесПроцессыИЗадачи") Тогда
		Элементы.МониторингЗадачНастроитьРасписание.Доступность	= МониторингЗадачИспользование;
		Если МониторингЗадачИспользование Тогда
			РасписаниеПредставление = Строка(МониторингЗадачРасписание);
			Представление = ВРег(Лев(РасписаниеПредставление, 1)) + Сред(РасписаниеПредставление, 2);
		Иначе
			Представление = "";
		КонецЕсли;
		Элементы.МониторингЗадачПояснение.Заголовок = Представление;
	КонецЕсли;
	
	Если Элементы.ГруппаУведомлениеИсполнителейОНовыхЗадачах.Видимость
		И (РеквизитПутьКДанным = "УведомлениеИсполнителейОНовыхЗадачахРасписание" Или РеквизитПутьКДанным = "")
		И ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.БизнесПроцессыИЗадачи") Тогда
		Элементы.УведомлениеИсполнителейОНовыхЗадачахНастроитьРасписание.Доступность	= УведомлениеИсполнителейОНовыхЗадачахИспользование;
		Если УведомлениеИсполнителейОНовыхЗадачахИспользование Тогда
			РасписаниеПредставление = Строка(УведомлениеИсполнителейОНовыхЗадачахРасписание);
			Представление = ВРег(Лев(РасписаниеПредставление, 1)) + Сред(РасписаниеПредставление, 2);
		Иначе
			Представление = "";
		КонецЕсли;
		Элементы.УведомлениеИсполнителейОНовыхЗадачахПояснение.Заголовок = Представление;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьРегламентноеЗадание(ИмяПредопределенного, Использование, Расписание, РеквизитПутьКДанным)
	РегламентноеЗадание = НайтиРегламентноеЗадание(ИмяПредопределенного);
	
	ПараметрыЗадания = Новый Структура;
	ПараметрыЗадания.Вставить("Использование", Использование);
	ПараметрыЗадания.Вставить("Расписание", Расписание);
	
	РегламентныеЗаданияСервер.ИзменитьЗадание(РегламентноеЗадание, ПараметрыЗадания);
	
	Если РеквизитПутьКДанным <> Неопределено Тогда
		УстановитьДоступность(РеквизитПутьКДанным);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция НайтиРегламентноеЗадание(ИмяПредопределенного)
	Отбор = Новый Структура;
	Отбор.Вставить("Метаданные", ИмяПредопределенного);
	
	РезультатПоиска = РегламентныеЗаданияСервер.НайтиЗадания(Отбор);
	Возврат ?(РезультатПоиска.Количество() = 0, Неопределено, РезультатПоиска[0]);
КонецФункции

//++ НЕ ГОСИС
////////////////////////////////////////////////////////////////////////////////
// Прочие

&НаСервере
Функция ТекстКомментарияИспользоватьБизнесПроцессы()
	
	ТекстКомментарияИспользоватьБизнесПроцессы = НСтр("ru = 'Невозможно отключение бизнес-процессов и задач, потому что включено:';
														|en = 'Cannot terminate business processes and tasks as the following is enabled:'");
	
	ДополнениеККомментарию = "";
	
	Если Константы.ИспользоватьСогласованиеЦенНоменклатуры.Получить() Тогда
		
		ДополнениеККомментарию =
			Символы.ПС + Символы.Таб + "- "
			+ НСтр("ru = 'Согласование цен в разделе ""Маркетинг""';
					|en = 'Price approval in the Marketing section'");
		
	КонецЕсли;
	
	Если Константы.ИспользоватьСогласованиеЗаказовКлиентов.Получить() Тогда
		
		ДополнениеККомментарию =
			ДополнениеККомментарию + ?(Не ПустаяСтрока(ДополнениеККомментарию), ";", "") + Символы.ПС + Символы.Таб + "- " 
			+ НСтр("ru = 'Согласование заказов клиентов в разделе ""Продажи""';
					|en = 'Sales order approval in the Sales section'");
		
	КонецЕсли;
	
	Если Константы.ИспользоватьСогласованиеЗаявокНаВозвратТоваровОтКлиентов.Получить() Тогда
		
		ДополнениеККомментарию =
			ДополнениеККомментарию + ?(Не ПустаяСтрока(ДополнениеККомментарию), ";", "") + Символы.ПС + Символы.Таб + "- " 
			+ НСтр("ru = 'Согласование заявок на возврат в разделе ""Продажи""';
					|en = 'Return request approval in the Sales section'");
		
	КонецЕсли;
	
	Если Константы.ИспользоватьСогласованиеСоглашенийСКлиентами.Получить() Тогда
		
		ДополнениеККомментарию =
			ДополнениеККомментарию + ?(Не ПустаяСтрока(ДополнениеККомментарию), ";", "") + Символы.ПС + Символы.Таб + "- " 
			+ НСтр("ru = 'Согласование соглашений с клиентами в разделе ""Продажи""';
					|en = 'Customer agreement approval in the Sales section'");
		
	КонецЕсли;
	
	Если Константы.ИспользоватьСогласованиеЗаказовПоставщикам.Получить() Тогда
		
		ДополнениеККомментарию =
			ДополнениеККомментарию + ?(Не ПустаяСтрока(ДополнениеККомментарию), ";", "") + Символы.ПС + Символы.Таб + "- " 
			+ НСтр("ru = 'Согласование документов закупок в разделе ""Закупки""';
					|en = 'Purchase document approval in the Purchases section'");
		
	КонецЕсли;
	
	Если Константы.ИспользоватьСогласованиеЗаказовНаВнутреннееПотребление.Получить() Тогда
		
		ДополнениеККомментарию =
			ДополнениеККомментарию + ?(Не ПустаяСтрока(ДополнениеККомментарию), ";", "") + Символы.ПС + Символы.Таб + "- " 
			+ НСтр("ru = 'Согласование заказов на внутреннее потребление в разделе ""Склад и доставка""';
					|en = 'Approve inventory consumption orders in the Warehouse and delivery section'");
		
	КонецЕсли;
	
	// ИнтеграцияС1СДокументооборотом
	Если Константы.ИспользоватьИнтеграциюС1СДокументооборот.Получить() Тогда
		
		ДополнениеККомментарию =
			ДополнениеККомментарию + ?(Не ПустаяСтрока(ДополнениеККомментарию), ";", "") + Символы.ПС + Символы.Таб + "- " 
			+ НСтр("ru = 'Интеграция с 1С:Документооборотом в разделе ""Документооборот""';
					|en = 'Integration with 1C:Document Management in section Document Management'");
		
	КонецЕсли;
	// Конец ИнтеграцияС1СДокументооборотом
	
	Если Не ПустаяСтрока(ДополнениеККомментарию) Тогда
		ТекстКомментарияИспользоватьБизнесПроцессы = ТекстКомментарияИспользоватьБизнесПроцессы + " " + ДополнениеККомментарию + ".";
	Иначе 
		ТекстКомментарияИспользоватьБизнесПроцессы = "";
	КонецЕсли;
	
	Возврат ТекстКомментарияИспользоватьБизнесПроцессы;
	
КонецФункции
//-- НЕ ГОСИС

#КонецОбласти
