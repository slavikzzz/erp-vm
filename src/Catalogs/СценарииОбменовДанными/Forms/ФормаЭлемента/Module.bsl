///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОписаниеПеременных

&НаКлиенте
Перем НомерОбрабатываемойСтроки;

&НаКлиенте
Перем КоличествоСтрок;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	ЭтоНовый = (Объект.Ссылка.Пустая());
	
	УзелИнформационнойБазы = Неопределено;
	
	Если ЭтоНовый
		И Параметры.Свойство("УзелИнформационнойБазы", УзелИнформационнойБазы)
		И УзелИнформационнойБазы <> Неопределено Тогда
		
		Справочники.СценарииОбменовДанными.ДобавитьЗагрузкуВСценарииОбменаДанными(Объект, УзелИнформационнойБазы);
		Справочники.СценарииОбменовДанными.ДобавитьВыгрузкуВСценарииОбменаДанными(Объект, УзелИнформационнойБазы);
		
		Наименование = НСтр("ru = 'Сценарий синхронизации для %1';
							|en = 'Synchronization scenario for %1'");
		Объект.Наименование = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Наименование, Строка(УзелИнформационнойБазы));
		
		РасписаниеРегламентногоЗадания = Справочники.СценарииОбменовДанными.РасписаниеРегламентногоЗаданияПоУмолчанию();
		
		Объект.ИспользоватьРегламентноеЗадание = Истина;
	Иначе
		// Получаем расписание из самого регламентного задания
		// если РЗ не задано, то расписание = Неопределено и будет создано на клиенте в момент редактирования расписания.
		РасписаниеРегламентногоЗадания = Справочники.СценарииОбменовДанными.ПолучитьРасписаниеВыполненияОбменаДанными(Объект.Ссылка);
	КонецЕсли;
	
	РазделениеВключено = ОбщегоНазначения.РазделениеВключено();
	
	Если РазделениеВключено Тогда
		
		ТекстПодсказки = НСтр("ru = 'Минимальный интервал не должен быть меньше 15 минут (900 секунд).
                              |Точное время выполнения сценария зависит от загруженности программы.';
                              |en = 'Minimum interval must be over 15 minutes (900 seconds).
                              |The exact scenario execution time depends on the application workload.'");
		
		Элементы.НастроитьРасписаниеРегламентногоЗадания.РасширеннаяПодсказка.Заголовок = ТекстПодсказки;
		Элементы.НастроитьРасписаниеРегламентногоЗадания.ОтображениеПодсказки = ОтображениеПодсказки.ОтображатьСнизу;
		
		Элементы.НастройкиОбменаИдентификаторТранспорта.Видимость = Ложь;
		
		Элементы.НастройкиОбменаУзелИнформационнойБазы.ИсторияВыбораПриВводе = ИсторияВыбораПриВводе.НеИспользовать;
		Элементы.НастройкиОбменаУзелИнформационнойБазы.КнопкаВыпадающегоСписка = Ложь;
		Элементы.ГруппаИнформацияОНастройкеВОднойБазе.Видимость = Истина;
		Элементы.ГруппаСценарийОтключен.Видимость = Объект.ОтключенАвтоматически;
		Элементы.ВыполнитьОбмен.Видимость = Ложь;
		
	КонецЕсли;
		
	Если Не ЭтоНовый Тогда
		ОбновитьСостоянияОбменовДанными();
	КонецЕсли;
	
	ПланыОбменаБСП = ОбменДаннымиПовтИсп.ПланыОбменаБСП();
	Для Каждого ИмяПланаОбмена Из ПланыОбменаБСП Цикл
		СписокУзловОбмена.Добавить(Тип("ПланОбменаСсылка." + ИмяПланаОбмена));
	КонецЦикла;
		
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОбновитьПредставлениеРасписания();
	
	УстановитьДоступностьГиперссылкиНастройкиРасписания();
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект)
	
	ПроверитьЗаполнениеНастройкиОбменаВСервисе(Отказ);
		
	Справочники.СценарииОбменовДанными.ОбновитьДанныеРегламентногоЗадания(Отказ, РасписаниеРегламентногоЗадания, ТекущийОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Запись_СценарииОбменовДанными", ПараметрыЗаписи, Объект.Ссылка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИспользоватьРегламентноеЗаданиеПриИзменении(Элемент)
	
	УстановитьДоступностьГиперссылкиНастройкиРасписания();
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкиОбменаУзелИнформационнойБазыПриИзменении(Элемент)
	
	Если РазделениеВключено Тогда
		Элементы.СоставРасписания.ТекущиеДанные.ИдентификаторТранспорта = "WS";
	Иначе	
		Элементы.СоставРасписания.ТекущиеДанные.ИдентификаторТранспорта = "";
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкиОбменаУзелИнформационнойБазыНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Если РазделениеВключено Тогда
		
		НачальноеЗначениеВыбора = Элементы.СоставРасписания.ТекущиеДанные.УзелИнформационнойБазы;
		ПараметрыФормы = Новый Структура("НачальноеЗначениеВыбора", НачальноеЗначениеВыбора);
		
		СтандартнаяОбработка = Ложь;
		ОткрытьФорму("Справочник.СценарииОбменовДанными.Форма.ВыборУзлаПланаОбмена", ПараметрыФормы, Элемент);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(Элемент.ТекстРедактирования, ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыНастройкиОбмена

&НаКлиенте
Процедура НастройкиОбменаУзелИнформационнойБазыОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Тип") И СписокУзловОбмена.НайтиПоЗначению(ВыбранноеЗначение) = Неопределено Тогда
		ТекстСообщения = НСтр("ru = 'Данные выбранного типа не могут быть использованы в этой форме.
			|Выберите другой тип данных.';
			|en = 'Cannot use data of this type in this form.
			|Please select another data type.'");
		Поле = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("НастройкиОбмена[%1].УзелИнформационнойБазы", Элементы.СоставРасписания.ТекущиеДанные.НомерСтроки-1);
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения, , Поле, "Объект");
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкиОбменаИдентификаторТранспортаНачалоВыбора(Элемент, ДанныеВыбора, ВыборДобавлением, СтандартнаяОбработка)
	
	Если Элементы.СоставРасписания.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьСписокВыбораВидаТранспортаОбмена(
		Элемент.СписокВыбора, 
		Элементы.СоставРасписания.ТекущиеДанные.УзелИнформационнойБазы);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыполнитьОбмен(Команда)
	
	ЭтоНовый = (Объект.Ссылка.Пустая());
	
	Если Модифицированность ИЛИ ЭтоНовый Тогда
		
		Если Не Записать() Тогда
			
			Возврат;
			
		КонецЕсли;
		
	КонецЕсли;
	
	НомерОбрабатываемойСтроки     = 1;
	КоличествоСтрок = Объект.НастройкиОбмена.Количество();
	
	Элементы.СоставРасписания.ТолькоПросмотр = Истина;
	
	ПодключитьОбработчикОжидания("ВыполнитьОбменДаннымиНаКлиенте", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьРасписаниеРегламентногоЗадания(Команда)
	
	РедактированиеРасписанияРегламентногоЗадания();
	
	ОбновитьПредставлениеРасписания();
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкиТранспорта(Команда)
	
	ТекущиеДанные = Элементы.СоставРасписания.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	ИначеЕсли Не ЗначениеЗаполнено(ТекущиеДанные.УзелИнформационнойБазы) Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыОткрытияФормы = ПараметрыОткрытияФормыТранспорта(ТекущиеДанные.УзелИнформационнойБазы);
	
	Если ПараметрыОткрытияФормы = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура("НастройкиТранспорта", ПараметрыОткрытияФормы.НастройкиТранспорта);
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Корреспондент", ТекущиеДанные.УзелИнформационнойБазы);
	ДополнительныеПараметры.Вставить("ИдентификаторТранспорта", ПараметрыОткрытияФормы.ИдентификаторТранспорта);
	
	Оповещение = Новый ОписаниеОповещения("СохранитьНастройкиТранспорта", ЭтотОбъект, ДополнительныеПараметры);
	
	ОткрытьФорму(ПараметрыОткрытияФормы.ПолноеИмяФормыНастройки, ПараметрыФормы,,,,, 
		Оповещение, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиВЖурналРегистрации(Команда)
	
	ТекущиеДанные = Элементы.СоставРасписания.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено
		Или Не ЗначениеЗаполнено(ТекущиеДанные.УзелИнформационнойБазы) Тогда
		Возврат;
	КонецЕсли;
	
	ОбменДаннымиКлиент.ПерейтиВЖурналРегистрацииСобытийДанныхМодально(ТекущиеДанные.УзелИнформационнойБазы,
																	ЭтотОбъект,
																	ТекущиеДанные.ВыполняемоеДействие);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура РедактированиеРасписанияРегламентногоЗадания()
	
	// Если расписание не инициализировано в форме на сервере, то создаем новое.
	Если РасписаниеРегламентногоЗадания = Неопределено Тогда
		
		РасписаниеРегламентногоЗадания = Новый РасписаниеРегламентногоЗадания;
		
	КонецЕсли;
	
	Диалог = Новый ДиалогРасписанияРегламентногоЗадания(РасписаниеРегламентногоЗадания);
	
	// Открываем диалог для редактирования Расписания.
	ОписаниеОповещения = Новый ОписаниеОповещения("РедактированиеРасписанияРегламентногоЗаданияЗавершение", ЭтотОбъект);
	Диалог.Показать(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура РедактированиеРасписанияРегламентногоЗаданияЗавершение(Расписание, ДополнительныеПараметры) Экспорт
		
	Если Расписание <> Неопределено Тогда
		
		Если РазделениеВключено 
			И Расписание.ПериодПовтораВТечениеДня <> 0
			И Расписание.ПериодПовтораВТечениеДня < 15 * 60 Тогда
			
			Расписание.ПериодПовтораВТечениеДня = 15 * 60;
			ТекстПредупреждения = НСтр("ru = 'Минимальный интервал не должен быть меньше 15 минут (900 секунд).';
										|en = 'Minimum interval must be over 15 minutes (900 seconds).'");
			ПоказатьПредупреждение(, ТекстПредупреждения);
			
		КонецЕсли;
		
		РасписаниеРегламентногоЗадания = Расписание;
		ОбновитьПредставлениеРасписания();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьПредставлениеРасписания()
	
	ПредставлениеРасписания = Строка(РасписаниеРегламентногоЗадания);
	
	Если ПредставлениеРасписания = Строка(Новый РасписаниеРегламентногоЗадания) Тогда
		
		ПредставлениеРасписания = НСтр("ru = 'Расписание не задано';
										|en = 'No schedule'");
		
	КонецЕсли;
	
	Элементы.НастроитьРасписаниеРегламентногоЗадания.Заголовок = ПредставлениеРасписания;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДоступностьГиперссылкиНастройкиРасписания()
	
	Элементы.НастроитьРасписаниеРегламентногоЗадания.Доступность = Объект.ИспользоватьРегламентноеЗадание;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьОбменДаннымиНаКлиенте()
	
	Если НомерОбрабатываемойСтроки > КоличествоСтрок Тогда // выход из рекурсии
		
		ВыводитьСостояние = (КоличествоСтрок > 1);
		Состояние(НСтр("ru = 'Данные синхронизированы.';
						|en = 'Data is synchronized.'"), ?(ВыводитьСостояние, 100, Неопределено));
		
		Элементы.СоставРасписания.ТолькоПросмотр = Ложь;
		
		Возврат; // выходим
		
	КонецЕсли;
	
	ТекущиеДанные = Объект.НастройкиОбмена[НомерОбрабатываемойСтроки - 1];
	
	ВыводитьСостояние = (КоличествоСтрок > 1);
	
	СтрокаСообщения = "";
	Если ТекущиеДанные.ВыполняемоеДействие = ПредопределенноеЗначение("Перечисление.ДействияПриОбмене.ЗагрузкаДанных") Тогда
		СтрокаСообщения = НСтр("ru = 'Выполняется получение данных из ""%1"".';
								|en = 'Importing data from %1.'");
	ИначеЕсли ТекущиеДанные.ВыполняемоеДействие = ПредопределенноеЗначение("Перечисление.ДействияПриОбмене.ВыгрузкаДанных") Тогда
		СтрокаСообщения = НСтр("ru = 'Выполняется отправка данных в ""%1"".';
								|en = 'Exporting data to %1.'");
	КонецЕсли;
	
	СтрокаСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтрокаСообщения, 
		ТекущиеДанные.УзелИнформационнойБазы);
	
	Прогресс = Окр(100 * (НомерОбрабатываемойСтроки -1) / ?(КоличествоСтрок = 0, 1, КоличествоСтрок));
	Состояние(СтрокаСообщения, ?(ВыводитьСостояние, Прогресс, Неопределено));
	
	// Запускаем выполнение обмена по строке настройки.
	ВыполнитьОбменДаннымиПоСтрокеНастройки(НомерОбрабатываемойСтроки);
	
	ОбработкаПрерыванияПользователя();
	
	НомерОбрабатываемойСтроки = НомерОбрабатываемойСтроки + 1;
	
	// Рекурсивно вызываем эту процедуру.
	ПодключитьОбработчикОжидания("ВыполнитьОбменДаннымиНаКлиенте", 0.1, Истина);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСостоянияОбменовДанными()
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТекстЗапроса = 
		"ВЫБРАТЬ
		|	СценарииОбменовДаннымиНастройкиОбмена.УзелИнформационнойБазы КАК УзелИнформационнойБазы,
		|	СценарииОбменовДаннымиНастройкиОбмена.УдалитьВидТранспортаОбмена КАК УдалитьВидТранспортаОбмена,
		|	СценарииОбменовДаннымиНастройкиОбмена.ИдентификаторТранспорта КАК ИдентификаторТранспорта,
		|	СценарииОбменовДаннымиНастройкиОбмена.ВыполняемоеДействие КАК ВыполняемоеДействие,
		|	ВЫБОР
		|		КОГДА СостоянияОбменовДанными.РезультатВыполненияОбмена ЕСТЬ NULL
		|			ТОГДА 0
		|		КОГДА СостоянияОбменовДанными.РезультатВыполненияОбмена = ЗНАЧЕНИЕ(Перечисление.РезультатыВыполненияОбмена.Предупреждение_СообщениеОбменаБылоРанееПринято)
		|			ТОГДА 2
		|		КОГДА СостоянияОбменовДанными.РезультатВыполненияОбмена = ЗНАЧЕНИЕ(Перечисление.РезультатыВыполненияОбмена.ВыполненоСПредупреждениями)
		|			ТОГДА 2
		|		КОГДА СостоянияОбменовДанными.РезультатВыполненияОбмена = ЗНАЧЕНИЕ(Перечисление.РезультатыВыполненияОбмена.Выполнено)
		|			ТОГДА 0
		|		ИНАЧЕ 1
		|	КОНЕЦ КАК РезультатВыполненияОбмена
		|ИЗ
		|	Справочник.СценарииОбменовДанными.НастройкиОбмена КАК СценарииОбменовДаннымиНастройкиОбмена
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СостоянияОбменовДанными КАК СостоянияОбменовДанными
		|		ПО (СостоянияОбменовДанными.УзелИнформационнойБазы = СценарииОбменовДаннымиНастройкиОбмена.УзелИнформационнойБазы)
		|			И (СостоянияОбменовДанными.ДействиеПриОбмене = СценарииОбменовДаннымиНастройкиОбмена.ВыполняемоеДействие)
		|ГДЕ
		|	СценарииОбменовДаннымиНастройкиОбмена.Ссылка = &Ссылка
		|
		|УПОРЯДОЧИТЬ ПО
		|	СценарииОбменовДаннымиНастройкиОбмена.НомерСтроки";
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("Ссылка", Объект.Ссылка);
	
	Объект.НастройкиОбмена.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры

&НаСервере
Процедура ВыполнитьОбменДаннымиПоСтрокеНастройки(Знач Индекс)
	
	Отказ = Ложь;
	
	// Запускаем выполнение обмена.
	ОбменДаннымиСервер.ВыполнитьОбменДаннымиПоСценариюОбменаДанными(Отказ, Объект.Ссылка, Индекс);
	
	// Обновляем данных табличной части сценария обмена.
	ОбновитьСостоянияОбменовДанными();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьСписокВыбораВидаТранспортаОбмена(СписокВыбора, УзелИнформационнойБазы)
	
	СписокВыбора.Очистить();
	
	Если ЗначениеЗаполнено(УзелИнформационнойБазы) Тогда
		
		Для Каждого Элемент Из НастроенныеТипыТранспорта(УзелИнформационнойБазы) Цикл
			СписокВыбора.Добавить(Элемент.Ключ, Элемент.Значение);
		КонецЦикла;
		
	КонецЕсли;
		
КонецПроцедуры

&НаСервереБезКонтекста
Функция НастроенныеТипыТранспорта(Знач УзелИнформационнойБазы)
	
	Результат = Новый Структура;
	ТаблицаТранспорта = ТранспортСообщенийОбмена.НастроенныеТипыТранспорта(УзелИнформационнойБазы);
	
	Для Каждого Строка Из ТаблицаТранспорта Цикл
		Псевдоним = ТранспортСообщенийОбмена.ПараметрТранспорта(Строка.ИдентификаторТранспорта, "Псевдоним");
		Результат.Вставить(Строка.ИдентификаторТранспорта, Псевдоним);
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура ПроверитьЗаполнениеНастройкиОбменаВСервисе(Отказ)
	
	Если РазделениеВключено Тогда
		
		НастройкиОбмена = Объект.НастройкиОбмена.Выгрузить();
		НастройкиОбмена.Свернуть("УзелИнформационнойБазы,ИдентификаторТранспорта,ВыполняемоеДействие");
		Объект.НастройкиОбмена.Загрузить(НастройкиОбмена);
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	НастройкиОбмена.УзелИнформационнойБазы КАК УзелИнформационнойБазы,
			|	НастройкиОбмена.ВыполняемоеДействие КАК ВыполняемоеДействие
			|ПОМЕСТИТЬ ВТ_НастройкиОбмена
			|ИЗ
			|	&НастройкиОбмена КАК НастройкиОбмена
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	ВТ_НастройкиОбмена.УзелИнформационнойБазы КАК УзелИнформационнойБазы
			|ПОМЕСТИТЬ ВТ_Загрузка
			|ИЗ
			|	ВТ_НастройкиОбмена КАК ВТ_НастройкиОбмена
			|ГДЕ
			|	ВТ_НастройкиОбмена.ВыполняемоеДействие = ЗНАЧЕНИЕ(Перечисление.ДействияПриОбмене.ЗагрузкаДанных)
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	ВТ_НастройкиОбмена.УзелИнформационнойБазы КАК УзелИнформационнойБазы
			|ПОМЕСТИТЬ ВТ_Выгрузка
			|ИЗ
			|	ВТ_НастройкиОбмена КАК ВТ_НастройкиОбмена
			|ГДЕ
			|	ВТ_НастройкиОбмена.ВыполняемоеДействие = ЗНАЧЕНИЕ(Перечисление.ДействияПриОбмене.ВыгрузкаДанных)
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	ЕСТЬNULL(ВТ_Выгрузка.УзелИнформационнойБазы, ВТ_Загрузка.УзелИнформационнойБазы) КАК УзелИнформационнойБазы,
			|	ВЫБОР
			|		КОГДА ВТ_Выгрузка.УзелИнформационнойБазы ЕСТЬ NULL
			|			ТОГДА 1
			|		КОГДА ВТ_Загрузка.УзелИнформационнойБазы ЕСТЬ NULL
			|			ТОГДА 2
			|	КОНЕЦ КАК НедостающееДействие
			|ИЗ
			|	ВТ_Загрузка КАК ВТ_Загрузка
			|		ПОЛНОЕ СОЕДИНЕНИЕ ВТ_Выгрузка КАК ВТ_Выгрузка
			|		ПО ВТ_Загрузка.УзелИнформационнойБазы = ВТ_Выгрузка.УзелИнформационнойБазы
			|ГДЕ
			|	(ВТ_Выгрузка.УзелИнформационнойБазы ЕСТЬ NULL
			|			ИЛИ ВТ_Загрузка.УзелИнформационнойБазы ЕСТЬ NULL)";
		
		Запрос.УстановитьПараметр("НастройкиОбмена", НастройкиОбмена);
		
		Результат = Запрос.Выполнить();
		
		Если Не Результат.Пустой() Тогда
			
			Отказ = Истина;
			
			Выборка = Результат.Выбрать();
			
			Пока Выборка.Следующий() Цикл
				
				Если Выборка.НедостающееДействие = 1 Тогда
					ШаблонСообщения = НСтр("ru = 'Для информационной базы ""%1"" не хватает действия по отправке данных';
											|en = 'An action to send data is missing for infobase ""%1""'");
				Иначе
					ШаблонСообщения = НСтр("ru = 'Для информационной базы ""%1"" не хватает действия по получению данных';
											|en = 'An action to receive data is missing for infobase ""%1""'");
				КонецЕсли;
				
				ТекстСообщения = СтрШаблон(ШаблонСообщения, Выборка.УзелИнформационнойБазы);
				
				ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
				
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
		
	Для Каждого Транспорт Из ТранспортСообщенийОбмена.ТаблицаПараметровТранспорта() Цикл
		
		Элемент = УсловноеОформление.Элементы.Добавить();
		
		ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
		ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("НастройкиОбменаИдентификаторТранспорта");
			
		ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.НастройкиОбмена.ИдентификаторТранспорта");
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ОтборЭлемента.ПравоеЗначение = Транспорт.ИдентификаторТранспорта;
		
		Элемент.Оформление.УстановитьЗначениеПараметра("Текст", Транспорт.Псевдоним);
		
	КонецЦикла;
		
КонецПроцедуры

&НаСервере
Функция ПараметрыОткрытияФормыТранспорта(Узел)

	ИдентификаторТранспорта = ТранспортСообщенийОбмена.ТранспортПоУмолчанию(Узел);
	
	Если Не ЗначениеЗаполнено(ИдентификаторТранспорта) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ПолноеИмяФормыНастройки = ТранспортСообщенийОбмена.ПолноеИмяФормыНастройки(ИдентификаторТранспорта);
	НастройкиТранспорта = ТранспортСообщенийОбмена.НастройкиТранспорта(Узел, ИдентификаторТранспорта);
	
	Результат = Новый Структура;
	Результат.Вставить("ИдентификаторТранспорта", ИдентификаторТранспорта);
	Результат.Вставить("ПолноеИмяФормыНастройки", ПолноеИмяФормыНастройки);
	Результат.Вставить("НастройкиТранспорта", НастройкиТранспорта);
	
	Возврат Результат;

КонецФункции

&НаКлиенте
Процедура СохранитьНастройкиТранспорта(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТранспортСообщенийОбменаВызовСервера.СохранитьНастройкиТранспорта(
		ДополнительныеПараметры.Корреспондент,
		ДополнительныеПараметры.ИдентификаторТранспорта,
		Результат);
	
КонецПроцедуры

#КонецОбласти
