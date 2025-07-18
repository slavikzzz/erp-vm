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
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки") Тогда
		РазделениеВключено = ОбщегоНазначения.РазделениеВключено();
		Элементы.ИспользоватьДополнительныеОтчетыИОбработки.Видимость = Не РазделениеВключено;
		Элементы.ОткрытьДополнительныеОтчетыИОбработки.Видимость      = Не РазделениеВключено
			// При работе в модели сервиса, если включено администратором сервиса.
			Или НаборКонстант.ИспользоватьДополнительныеОтчетыИОбработки;
	Иначе
		Элементы.ГруппаДополнительныеОтчетыИОбработки.Видимость = Ложь;
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РассылкаОтчетов") Тогда
		МодульРассылкаОтчетов = ОбщегоНазначения.ОбщийМодуль("РассылкаОтчетов");
		Элементы.ОткрытьРассылкиОтчетов.Видимость = МодульРассылкаОтчетов.ПравоДобавления(); 
		Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Взаимодействия") Тогда
			ТекстПодсказки = НСтр("ru = 'Позволяет узнать, когда, кому и с каким результатом были разосланы отчеты. Для ограничения объема хранимых данных
			|устаревшая история рассылок удаляется автоматически. Вместе с историей рассылок отчетов бессрочно сохраняются отправленные электронные письма.';
			|en = 'Provides you with the information on the date when reports were sent, the recipients, and the result of sending. To limit the amount of stored data,
			|obsolete report distribution history is automatically deleted. Besides the report distribution history, sent emails are saved indefinitely.'");
			Элементы.ГруппаНастройкиИсторииРассылкиОтчетов.РасширеннаяПодсказка.Заголовок = ТекстПодсказки;
		КонецЕсли;
		ФорматЧисла = НСтр("ru = '%Число% %Месяцев%';
							|en = '%Число% %Месяцев%'");
		ФорматЧисла = СтрЗаменить(ФорматЧисла, "%Число%", "Ч");
		ФорматЧисла = СтрЗаменить(ФорматЧисла, "%Месяцев%", НСтр("ru = 'мес.';
																|en = 'months'"));
		Элементы.КоличествоМесяцевХраненияИсторииРассылкиОтчетов.ФорматРедактирования =
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("ЧФ='%1'", ФорматЧисла);	
		Элементы.КоличествоМесяцевХраненияИсторииРассылкиОтчетов.Ширина = СтрДлина(ФорматЧисла);
	Иначе
		Элементы.ГруппаРассылкиОтчетов.Видимость = Ложь;
	КонецЕсли;

	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Мультиязычность.ПереводТекста") Тогда
		СервисПереводаТекста = НаборКонстант["СервисПереводаТекста"];
		Элементы.НастройкаСервисаПереводаТекста.Заголовок = ЗаголовокНастройкиСервисаПереводаТекста(СервисПереводаТекста);
	Иначе
		Элементы.ГруппаАвтоматическийПеревод.Видимость = Ложь;
	КонецЕсли;
	
	// Обновление состояния элементов.
	УстановитьДоступность();
	
	НастройкиПрограммыПереопределяемый.ПечатныеФормыОтчетыИОбработкиПриСозданииНаСервере(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	ОбновитьИнтерфейсПрограммы();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИспользоватьДополнительныеОтчетыИОбработкиПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьУчетОригиналовПервичныхДокументовПриИзменении(Элемент)

	Подключаемый_ПриИзмененииРеквизита(Элемент)

КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьСервисПереводаТекстаПриИзменении(Элемент)
	
	Подключаемый_ПриИзмененииРеквизита(Элемент);
	Если НаборКонстант["ИспользоватьСервисПереводаТекста"] И Не ЗначениеЗаполнено(НаборКонстант["СервисПереводаТекста"]) Тогда
		ПерейтиКНастройкамПереводчика();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкаСервисаПереводаТекстаОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "ПерейтиКНастройкеСервисаПереводаТекста" Тогда
		СтандартнаяОбработка = Ложь;
		ПерейтиКНастройкамПереводчика();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ХранитьИсториюРассылкиОтчетовПриИзменении(Элемент)
	
	Подключаемый_ПриИзмененииРеквизита(Элемент);   
		
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.РассылкаОтчетов") Тогда
		МодульРассылкаОтчетовВызовСервера = ОбщегоНазначенияКлиент.ОбщийМодуль("РассылкаОтчетовВызовСервера");
		МодульРассылкаОтчетовВызовСервера.ПриИзмененииХранитьИсториюРассылкиОтчетов();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КоличествоМесяцевХраненияИсторииРассылкиОтчетовПриИзменении(Элемент)
	
	Подключаемый_ПриИзмененииРеквизита(Элемент);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ДополнительныеОтчетыИОбработки(Команда)
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки") Тогда
		МодульДополнительныеОтчетыИОбработкиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ДополнительныеОтчетыИОбработкиКлиент");
		МодульДополнительныеОтчетыИОбработкиКлиент.ОткрытьСписокДополнительныхОтчетовИОбработок();
	КонецЕсли;
	
КонецПроцедуры    

&НаКлиенте
Процедура ОчиститьИсториюРассылкиОтчетов(Команда)

	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.РассылкаОтчетов") Тогда
		МодульРассылкаОтчетовКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("РассылкаОтчетовКлиент");
		МодульРассылкаОтчетовКлиент.ОчиститьИсториюРассылкиОтчетов(ЭтотОбъект);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПерейтиКНастройкамПереводчика()
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.Мультиязычность.ПереводТекста") Тогда
		МодульПереводТекстаНаДругиеЯзыкиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ПереводТекстаНаДругиеЯзыкиКлиент");
		ОписаниеОповещения = Новый ОписаниеОповещения("ПриЗавершенииНастройкиСервисаПеревода", ЭтотОбъект);
		МодульПереводТекстаНаДругиеЯзыкиКлиент.ПерейтиКНастройкам(ЭтотОбъект, ОписаниеОповещения);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗавершенииНастройкиСервисаПеревода(Знач ВыбранныйПереводчик, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныйПереводчик = Неопределено Тогда
		ВыбранныйПереводчик = ТекущийПереводчик();
	КонецЕсли;
	
	Элементы.НастройкаСервисаПереводаТекста.Заголовок = ЗаголовокНастройкиСервисаПереводаТекста(ВыбранныйПереводчик);
	Если Не ЗначениеЗаполнено(ВыбранныйПереводчик) Тогда
		НаборКонстант["ИспользоватьСервисПереводаТекста"] = Ложь;
		Подключаемый_ПриИзмененииРеквизита(Элементы.ИспользоватьСервисПереводаТекста);
	КонецЕсли;
	
	НаборКонстант["СервисПереводаТекста"] = ВыбранныйПереводчик;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ЗаголовокНастройкиСервисаПереводаТекста(СервисПереводаТекста)
	
	Если ЗначениеЗаполнено(СервисПереводаТекста) Тогда
		Шаблон = НСтр("ru = 'Перевод текста с помощью <a href=""%1"">%2</a>';
						|en = 'Translate with <a href=""%1"">%2</a>'");
	Иначе
		Шаблон = НСтр("ru = 'Перевод текста с помощью внешнего сервиса';
						|en = 'Online translation service'");
	КонецЕсли;
	
#Если Клиент Тогда
	Возврат СтроковыеФункцииКлиент.ФорматированнаяСтрока(Шаблон, "ПерейтиКНастройкеСервисаПереводаТекста", СервисПереводаТекста);
#Иначе
	Возврат СтроковыеФункции.ФорматированнаяСтрока(Шаблон, "ПерейтиКНастройкеСервисаПереводаТекста", СервисПереводаТекста);
#КонецЕсли
	
КонецФункции

&НаСервереБезКонтекста
Функция ТекущийПереводчик()
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Мультиязычность.ПереводТекста") Тогда
		МодульПереводТекстаНаДругиеЯзыки = ОбщегоНазначения.ОбщийМодуль("ПереводТекстаНаДругиеЯзыки");
		Возврат МодульПереводТекстаНаДругиеЯзыки.СервисПереводаТекста();
	КонецЕсли;
	
КонецФункции

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

////////////////////////////////////////////////////////////////////////////////
// Вызов сервера

&НаСервере
Функция ПриИзмененииРеквизитаСервер(ИмяЭлемента)
	
	РеквизитПутьКДанным = Элементы[ИмяЭлемента].ПутьКДанным;
	ИмяКонстанты = СохранитьЗначениеРеквизита(РеквизитПутьКДанным);
	УстановитьДоступность(РеквизитПутьКДанным);
	ОбновитьПовторноИспользуемыеЗначения();
	Возврат ИмяКонстанты;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Сервер

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
	
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьДополнительныеОтчетыИОбработки" ИЛИ РеквизитПутьКДанным = ""
		И ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки") Тогда
		Элементы.ОткрытьДополнительныеОтчетыИОбработки.Доступность = НаборКонстант.ИспользоватьДополнительныеОтчетыИОбработки;
	КонецЕсли;
	
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьУчетОригиналовПервичныхДокументов" ИЛИ РеквизитПутьКДанным = ""
		И ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УчетОригиналовПервичныхДокументов") Тогда
		Элементы.ОткрытьСостоянияОригиналовПервичныхДокументов.Доступность = НаборКонстант.ИспользоватьУчетОригиналовПервичныхДокументов;
	КонецЕсли;       
	
	Если  РеквизитПутьКДанным = "НаборКонстант.ХранитьИсториюРассылкиОтчетов" ИЛИ РеквизитПутьКДанным = ""
		И ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РассылкаОтчетов") Тогда
		Элементы.КоличествоМесяцевХраненияИсторииРассылкиОтчетов.Доступность = НаборКонстант["ХранитьИсториюРассылкиОтчетов"];
	КонецЕсли;

КонецПроцедуры

#КонецОбласти
