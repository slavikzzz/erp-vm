///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОбъектМетаданных = МультиязычностьСервер.ОбъектМетаданных(Параметры.Объект);
	Если ОбъектМетаданных = Неопределено Тогда
		ОбъектМетаданных = МультиязычностьСервер.ОбъектМетаданных(Параметры.Ссылка);
	КонецЕсли;
	
	ТолькоПросмотр = Не ПравоДоступа("Изменение", ОбъектМетаданных);
	
	МультиязычныеСтрокиВРеквизитах = МультиязычностьСервер.МультиязычныеСтрокиВРеквизитах(ОбъектМетаданных);
	ХранениеВТабличнойЧасти = МультиязычностьСервер.ОбъектСодержитТЧПредставления(ОбъектМетаданных.ПолноеИмя(), Параметры.ИмяРеквизита);
	Реквизит = ОбъектМетаданных.Реквизиты.Найти(Параметры.ИмяРеквизита);
	Если Реквизит = Неопределено Тогда
		Для каждого СтандартныйРеквизит Из ОбъектМетаданных.СтандартныеРеквизиты Цикл
			Если СтрСравнить(СтандартныйРеквизит.Имя, Параметры.ИмяРеквизита) = 0 Тогда
				Реквизит = СтандартныйРеквизит;
				Прервать;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	СуффиксОсновногоЯзыка         = "";
	СуффиксДополнительногоЯзыка1 = "Язык1";
	СуффиксДополнительногоЯзыка2 = "Язык2";
	
	
	Если Не ОбщегоНазначения.ЭтоОсновнойЯзык() Тогда
		СуффиксОсновногоЯзыка = МультиязычностьСервер.СуффиксТекущегоЯзыка();
		Если СуффиксОсновногоЯзыка = "Язык1" Тогда
			СуффиксДополнительногоЯзыка1  = "";
			СуффиксОсновногоЯзыка         = "Язык1";
		ИначеЕсли СуффиксОсновногоЯзыка = "Язык2" Тогда
			СуффиксДополнительногоЯзыка2 = "";
			СуффиксОсновногоЯзыка         = "Язык2";
		КонецЕсли;
		
	КонецЕсли;
	
	ИспользуетсяПервыйДополнительныйЯзык = МультиязычностьСервер.ИспользуетсяПервыйДополнительныйЯзык()
			И ЗначениеЗаполнено(МультиязычностьСервер.КодПервогоДополнительногоЯзыкаИнформационнойБазы());
			
	ИспользуетсяВторойДополнительныйЯзык = МультиязычностьСервер.ИспользуетсяВторойДополнительныйЯзык()
			И ЗначениеЗаполнено(МультиязычностьСервер.КодВторогоДополнительногоЯзыкаИнформационнойБазы());
	
	НаборЯзыков = Новый ТаблицаЗначений;
	НаборЯзыков.Колонки.Добавить("КодЯзыка",      ОбщегоНазначения.ОписаниеТипаСтрока(10));
	НаборЯзыков.Колонки.Добавить("Представление", ОбщегоНазначения.ОписаниеТипаСтрока(150));
	НаборЯзыков.Колонки.Добавить("Суффикс",       ОбщегоНазначения.ОписаниеТипаСтрока(50));
	
	Если ХранениеВТабличнойЧасти И ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Мультиязычность.Печать") Тогда
		МодульУправлениеПечатьюМультиязычность = ОбщегоНазначения.ОбщийМодуль("УправлениеПечатьюМультиязычность");
		МодульУправлениеПечатьюМультиязычность.ПриЗаполненииНабораЯзыков(НаборЯзыков);
	КонецЕсли;
	
	ИспользуемыеЯзыки = Новый Соответствие;
	ИспользуемыеЯзыки.Вставить(МультиязычностьСервер.КодОсновногоЯзыка(), Истина);
	Если ИспользуетсяПервыйДополнительныйЯзык Тогда
		ИспользуемыеЯзыки.Вставить(МультиязычностьСервер.КодПервогоДополнительногоЯзыкаИнформационнойБазы(), Истина);
	КонецЕсли;
	Если ИспользуетсяВторойДополнительныйЯзык Тогда
		ИспользуемыеЯзыки.Вставить(МультиязычностьСервер.КодВторогоДополнительногоЯзыкаИнформационнойБазы(), Истина);
	КонецЕсли;
	
	Для Каждого ЯзыкКонфигурации Из Метаданные.Языки Цикл
		Если ИспользуемыеЯзыки[ЯзыкКонфигурации.КодЯзыка] <> Истина Тогда
			Продолжить;
		КонецЕсли;
		
		СтрокаЯзыка = НаборЯзыков.НайтиСтроки(Новый Структура("КодЯзыка", ЯзыкКонфигурации.КодЯзыка));
		
		Если СтрокаЯзыка.Количество() = 0 Тогда
			ДанныеЯзыка = НаборЯзыков.Добавить();
			ДанныеЯзыка.КодЯзыка = ЯзыкКонфигурации.КодЯзыка;
			ДанныеЯзыка.Представление = ЯзыкКонфигурации.Представление();
		Иначе
			ДанныеЯзыка = СтрокаЯзыка[0];
		КонецЕсли;
		
		Если ЯзыкКонфигурации.КодЯзыка =  МультиязычностьСервер.КодОсновногоЯзыка() Тогда
			ДанныеЯзыка.Суффикс = СуффиксОсновногоЯзыка;
		ИначеЕсли ЯзыкКонфигурации.КодЯзыка =  МультиязычностьСервер.КодПервогоДополнительногоЯзыкаИнформационнойБазы() Тогда
			ДанныеЯзыка.Суффикс = СуффиксДополнительногоЯзыка1;
		ИначеЕсли ЯзыкКонфигурации.КодЯзыка =  МультиязычностьСервер.КодВторогоДополнительногоЯзыкаИнформационнойБазы() Тогда
			ДанныеЯзыка.Суффикс = СуффиксДополнительногоЯзыка2;
		КонецЕсли;
		
	КонецЦикла;
	
	Если Реквизит = Неопределено Тогда
		ШаблонОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'При открытии формы %1 в параметре %2 указан не существующий реквизит %1';
				|en = 'When opening form %1, parameter %2 contains attribute %1 that does not exist'"), "ВводНаРазныхЯзыках", "ИмяРеквизита");
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонОшибки, Параметры.ИмяРеквизита);
	КонецЕсли;
	
	Если Реквизит.МногострочныйРежим Тогда
		СтандартныеПодсистемыСервер.УстановитьКлючНазначенияФормы(ЭтотОбъект, "МногострочныйРежим");
	КонецЕсли;
	
	Для Каждого ЯзыкКонфигурации Из НаборЯзыков Цикл
		НоваяСтрока = Языки.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ЯзыкКонфигурации);
		НоваяСтрока.Имя = "_" + СтрЗаменить(Новый УникальныйИдентификатор, "-", "");
	КонецЦикла;
	
	СформироватьПоляВводаНаРазныхЯзыках(Реквизит.МногострочныйРежим, Параметры.ТолькоПросмотр Или ТолькоПросмотр);
	
	Если Не ПустаяСтрока(Параметры.Заголовок) Тогда
		Заголовок = Параметры.Заголовок;
	Иначе
		Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = '%1 на разных языках';
				|en = '%1 in different languages'"), Реквизит.Представление());
		Если ПустаяСтрока(Заголовок) Тогда
			Заголовок = Реквизит.Представление();
		КонецЕсли;
	КонецЕсли;
	
	ОписаниеЯзыка = ОписаниеЯзыка(ТекущийЯзык().КодЯзыка);
	Если ОписаниеЯзыка <> Неопределено Тогда
		ЭтотОбъект[ОписаниеЯзыка.Имя] = Параметры.ТекущиеЗначение;
	КонецЕсли;
	
	ОсновнойЯзык = ОбщегоНазначения.КодОсновногоЯзыка();
	ЛокализуемыеРеквизитыВШапке = МультиязычностьСервер.НаименованияЛокализуемыхРеквизитовОбъектаВШапке(ОбъектМетаданных);

	Если ХранениеВТабличнойЧасти Тогда
		
		Для каждого Представление Из Параметры.Представления Цикл
			
			ОписаниеЯзыка = ОписаниеЯзыка(Представление.КодЯзыка);
			Если ОписаниеЯзыка <> Неопределено Тогда
				Если СтрСравнить(ОписаниеЯзыка.КодЯзыка, ТекущийЯзык().КодЯзыка) = 0 Тогда
					ЭтотОбъект[ОписаниеЯзыка.Имя] = ?(ЗначениеЗаполнено(Параметры.ТекущиеЗначение), Параметры.ТекущиеЗначение, Представление[Параметры.ИмяРеквизита]);
				Иначе
					ЭтотОбъект[ОписаниеЯзыка.Имя] = Представление[Параметры.ИмяРеквизита];
				КонецЕсли;
			КонецЕсли;
			
		КонецЦикла;
		
		Если ЛокализуемыеРеквизитыВШапке[Параметры.ИмяРеквизита] <> Неопределено Тогда
			ОписаниеЯзыка = ОписаниеЯзыка(ОсновнойЯзык);
			Если ЗначениеЗаполнено(СуффиксОсновногоЯзыка) И Параметры.Объект <> Неопределено Тогда
				ЭтотОбъект[ОписаниеЯзыка.Имя] = Параметры.Объект[Параметры.ИмяРеквизита + СуффиксОсновногоЯзыка];
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
	Если МультиязычныеСтрокиВРеквизитах
		И ЛокализуемыеРеквизитыВШапке[Параметры.ИмяРеквизита] <> Неопределено
		И (ИспользуетсяПервыйДополнительныйЯзык
		ИЛИ ИспользуетсяВторойДополнительныйЯзык) Тогда
		
		ОписаниеЯзыка = ОписаниеЯзыка(ОсновнойЯзык);
		Если ПустаяСтрока(СуффиксОсновногоЯзыка) Тогда
			ЭтотОбъект[ОписаниеЯзыка.Имя] = Параметры.ТекущиеЗначение;
		ИначеЕсли Параметры.ЗначенияРеквизитов <> Неопределено Тогда
			ЭтотОбъект[ОписаниеЯзыка.Имя] = Параметры.ЗначенияРеквизитов[Параметры.ИмяРеквизита + СуффиксОсновногоЯзыка]; 
		ИначеЕсли Параметры.Объект <> Неопределено Тогда
			ЭтотОбъект[ОписаниеЯзыка.Имя] = Параметры.Объект[Параметры.ИмяРеквизита + СуффиксОсновногоЯзыка];
		КонецЕсли;
		
		Если ИспользуетсяПервыйДополнительныйЯзык Тогда
			ОписаниеЯзыка = ОписаниеЯзыка(Константы.ДополнительныйЯзык1.Получить());
			Если ПустаяСтрока(СуффиксДополнительногоЯзыка1) Тогда
				ЭтотОбъект[ОписаниеЯзыка.Имя] = Параметры.ТекущиеЗначение;
			ИначеЕсли Параметры.ЗначенияРеквизитов <> Неопределено Тогда
				ЭтотОбъект[ОписаниеЯзыка.Имя] = Параметры.ЗначенияРеквизитов[Параметры.ИмяРеквизита + СуффиксДополнительногоЯзыка1];
			ИначеЕсли Параметры.Объект <> Неопределено Тогда
				ЭтотОбъект[ОписаниеЯзыка.Имя] = Параметры.Объект[Параметры.ИмяРеквизита + СуффиксДополнительногоЯзыка1];
			КонецЕсли;
		КонецЕсли;
		
		Если ИспользуетсяВторойДополнительныйЯзык Тогда
			ОписаниеЯзыка = ОписаниеЯзыка(Константы.ДополнительныйЯзык2.Получить());
			Если ПустаяСтрока(СуффиксДополнительногоЯзыка2) Тогда
				ЭтотОбъект[ОписаниеЯзыка.Имя] = Параметры.ТекущиеЗначение;
			ИначеЕсли Параметры.ЗначенияРеквизитов <> Неопределено Тогда
				ЭтотОбъект[ОписаниеЯзыка.Имя] = Параметры.ЗначенияРеквизитов[Параметры.ИмяРеквизита + СуффиксДополнительногоЯзыка2];
			ИначеЕсли Параметры.Объект <> Неопределено Тогда
				ЭтотОбъект[ОписаниеЯзыка.Имя] = Параметры.Объект[Параметры.ИмяРеквизита + СуффиксДополнительногоЯзыка2];
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
	Элементы.Перевести.Видимость = Ложь;
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Мультиязычность.ПереводТекста") Тогда
		МодульПереводТекстаНаДругиеЯзыки = ОбщегоНазначения.ОбщийМодуль("ПереводТекстаНаДругиеЯзыки");
		Элементы.Перевести.Видимость = МодульПереводТекстаНаДругиеЯзыки.ДоступенПереводТекста()
			И Не Параметры.ТолькоПросмотр И Не ТолькоПросмотр;
		ПредставлениеНаИсходномЯзыке = ПредставлениеНаИсходномЯзыке();
	КонецЕсли;
	
	Если ОбщегоНазначения.ЭтоМобильныйКлиент() Тогда
		ПоложениеКоманднойПанели = ПоложениеКоманднойПанелиФормы.Авто;
		Элементы.Переместить(Элементы.Перевести, Элементы.ФормаКоманднаяПанель);
		Элементы.ОК.Отображение = ОтображениеКнопки.Картинка;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	Если Не Модифицированность Тогда
		Закрыть();
		Возврат;
	КонецЕсли;
	
	Результат = Новый Структура;
	
	Результат.Вставить("ОсновнойЯзык",            ОсновнойЯзык);
	Результат.Вставить("ХранениеВТабличнойЧасти", ХранениеВТабличнойЧасти);
	Результат.Вставить("Модифицированность",      Модифицированность);
	Результат.Вставить("ЗначенияНаРазныхЯзыках",  Новый Массив);
	
	ТекущийКодЯзыка = ?(ТипЗнч(ТекущийЯзык()) = Тип("Строка"), ТекущийЯзык(), ТекущийЯзык().КодЯзыка); 
	
	Для каждого Язык Из Языки Цикл
		
		Если СтрСравнить(Язык.КодЯзыка, ТекущийКодЯзыка) = 0 
		   Или (СтрСравнить(Язык.КодЯзыка, ОсновнойЯзык) = 0 
		   И Не Результат.Свойство("СтрокаНаТекущемЯзыке")) Тогда
			Результат.Вставить("СтрокаНаТекущемЯзыке", ЭтотОбъект[Язык.Имя]);
		КонецЕсли;
		
		Если ТекущийКодЯзыка = ОсновнойЯзык И Язык.КодЯзыка = ОсновнойЯзык Тогда
			Продолжить;
		КонецЕсли;
		
		Значения = Новый Структура;
		Значения.Вставить("КодЯзыка",          Язык.КодЯзыка);
		Значения.Вставить("ЗначениеРеквизита", ЭтотОбъект[Язык.Имя]);
		Значения.Вставить("Суффикс",           Язык.Суффикс);
		
		Результат.ЗначенияНаРазныхЯзыках.Добавить(Значения);
	КонецЦикла;
	
	Закрыть(Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура Перевести(Команда)
	
	ПеревестиНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура СформироватьПоляВводаНаРазныхЯзыках(МногострочныйРежим, ТолькоПросмотр)
	
	Добавлять = Новый Массив;
	ТипСтрока = Новый ОписаниеТипов("Строка");
	Для Каждого ЯзыкКонфигурации Из Языки Цикл
		НовыйРеквизит = Новый РеквизитФормы(ЯзыкКонфигурации.Имя, ТипСтрока,, ЯзыкКонфигурации.Представление);
		НовыйРеквизит.СохраняемыеДанные = Истина;
		Добавлять.Добавить(НовыйРеквизит);
	КонецЦикла;
	
	ИзменитьРеквизиты(Добавлять);
	РодительЭлементов = Элементы.ГруппаЯзыки;
	
	Для Каждого ЯзыкКонфигурации Из Языки Цикл
		
		Если СтрСравнить(ЯзыкКонфигурации.КодЯзыка, ТекущийЯзык().КодЯзыка) = 0 И РодительЭлементов.ПодчиненныеЭлементы.Количество() > 0 Тогда
			Элемент = Элементы.Вставить(ЯзыкКонфигурации.Имя, Тип("ПолеФормы"), РодительЭлементов, РодительЭлементов.ПодчиненныеЭлементы.Получить(0));
			ТекущийЭлемент = Элемент;
		Иначе
			Элемент = Элементы.Добавить(ЯзыкКонфигурации.Имя, Тип("ПолеФормы"), РодительЭлементов);
		КонецЕсли;
		
		Элемент.ПутьКДанным        = ЯзыкКонфигурации.Имя;
		
		Если ЗначениеЗаполнено(ЯзыкКонфигурации.ФормаРедактирования) Тогда
			Элемент.Вид = ВидПоляФормы.ПолеНадписи;
			Элемент.Гиперссылка = Истина;
			Элемент.УстановитьДействие("Нажатие", "Подключаемый_Нажатие");
		Иначе
			Элемент.Вид                = ВидПоляФормы.ПолеВвода;
			Элемент.Ширина             = 40;
			Элемент.МногострочныйРежим = МногострочныйРежим;
			Элемент.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Верх;
			Элемент.ТолькоПросмотр     = ТолькоПросмотр;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ОписаниеЯзыка(КодЯзыка)
	
	Отбор = Новый Структура("КодЯзыка", КодЯзыка);
	НайденныеЭлементы = Языки.НайтиСтроки(Отбор);
	Если НайденныеЭлементы.Количество() > 0 Тогда
		Возврат НайденныеЭлементы[0];
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

&НаСервере
Процедура ПеревестиНаСервере()
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Мультиязычность.ПереводТекста") Тогда
		МодульПереводТекстаНаДругиеЯзыки = ОбщегоНазначения.ОбщийМодуль("ПереводТекстаНаДругиеЯзыки");
	Иначе
		Возврат;
	КонецЕсли;
	
	ИсходныйЯзык = СтрРазделить(ОбщегоНазначения.КодОсновногоЯзыка(), "_", Ложь)[0];
	Если ПредставлениеНаИсходномЯзыке <> ПредставлениеНаИсходномЯзыке() Тогда
		ПредставлениеНаИсходномЯзыке = ПредставлениеНаИсходномЯзыке();
		ПредставлениеНаИсходномЯзыкеИзменено = Истина;
	КонецЕсли;
	
	ДоступныеЯзыки = МодульПереводТекстаНаДругиеЯзыки.ДоступныеЯзыки();
	Если ДоступныеЯзыки.НайтиПоЗначению(ИсходныйЯзык) = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Для Индекс = 0 По Языки.Количество() - 1 Цикл
		СтрокаТаблицы = Языки[Индекс];
		ЯзыкПеревода = СтрРазделить(СтрокаТаблицы.КодЯзыка, "_", Ложь)[0];
		Если ИсходныйЯзык = ЯзыкПеревода Тогда
			Продолжить;
		КонецЕсли;
		Если ДоступныеЯзыки.НайтиПоЗначению(ЯзыкПеревода) = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		Если Не ПредставлениеНаИсходномЯзыкеИзменено И ЗначениеЗаполнено(ЭтотОбъект[СтрокаТаблицы.Имя]) Тогда
			Элементы[СтрокаТаблицы.Имя].ЦветФона = Новый Цвет;
		Иначе
			ЭтотОбъект[СтрокаТаблицы.Имя] = ПеревестиТекстНаСервере(ПредставлениеНаИсходномЯзыке, ЯзыкПеревода, ИсходныйЯзык);
			Элементы[СтрокаТаблицы.Имя].ЦветФона = ЦветаСтиля.ЦветИзмененногоПоля;
			Модифицированность = Истина;
		КонецЕсли;
	КонецЦикла;
	
	ПредставлениеНаИсходномЯзыкеИзменено = Ложь;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПеревестиТекстНаСервере(ИсходныйТекст, ЯзыкПеревода, ИсходныйЯзык)
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Мультиязычность.ПереводТекста") Тогда
		МодульПереводТекстаНаДругиеЯзыки = ОбщегоНазначения.ОбщийМодуль("ПереводТекстаНаДругиеЯзыки");
		Возврат МодульПереводТекстаНаДругиеЯзыки.ПеревестиТекст(ИсходныйТекст, ЯзыкПеревода, ИсходныйЯзык);
	КонецЕсли;
	
КонецФункции

&НаСервере
Функция ПредставлениеНаИсходномЯзыке()
	
	НайденныеСтроки = Языки.НайтиСтроки(Новый Структура("КодЯзыка", ОбщегоНазначения.КодОсновногоЯзыка()));
	Для Каждого ОписаниеЯзыка Из НайденныеСтроки Цикл
		Возврат ЭтотОбъект[ОписаниеЯзыка.Имя];
	КонецЦикла;
	
	Возврат "";
	
КонецФункции

#КонецОбласти