#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	Элементы.ГруппаКомментарий.Картинка = ОбщегоНазначенияКлиентСервер.КартинкаКомментария(Объект.Комментарий);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	СобытияФорм.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);

	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	
	ВерсияУведомления = Документы.УведомлениеОКонтролируемыхСделках.ВерсияУведомления(Объект.УведомлениеОКонтролируемойСделке);
	
	ЗаполнитьДобавленныеПоляСделки(ЭтотОбъект);
	
	Если Параметры.Свойство("АктивироватьСтрокуТабличнойЧасти") Тогда
		АктивироватьСтрокуТабличнойЧасти = Параметры.АктивироватьСтрокуТабличнойЧасти;
		ТекущийЭлемент = Элементы[АктивироватьСтрокуТабличнойЧасти.ТабличнаяЧасть];
		ТекущийЭлемент.ТекущаяСтрока = АктивироватьСтрокуТабличнойЧасти.НомерСтроки - 1;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ЗаполнитьДобавленныеПоляСделки(ЭтотОбъект);
	
	Элементы.ГруппаКомментарий.Картинка = ОбщегоНазначенияКлиентСервер.КартинкаКомментария(Объект.Комментарий);
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом

КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура УведомлениеОКонтролируемойСделкеПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Объект.УведомлениеОКонтролируемойСделке) Тогда 
		ПриИзмененииУведмомленияОКонтролируемойСделкеНаСервере();
	Иначе
		Объект.Организация = Неопределено;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура РасчетныйДокументНачалоВыбора(Элемент, ДанныеВыбора, ВыборДобавлением, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПараметрыОткрытияФормы = Новый Структура;
	ПараметрыОткрытияФормы.Вставить("УведомлениеОКонтролируемыхСделках", Объект.УведомлениеОКонтролируемойСделке);
	ПараметрыОткрытияФормы.Вставить("Организация", Объект.Организация);
	ПараметрыОткрытияФормы.Вставить("Контрагент", Объект.Контрагент);
	ПараметрыОткрытияФормы.Вставить("Договор", Объект.ДоговорКонтрагента);
	ПараметрыОткрытияФормы.Вставить("ПредметСделки", Объект.ПредметСделки);
	
	ОповещениеОЗакрытии = Новый ОписаниеОповещения("РасчетныйДокументНачалоВыбораЗавершение", ЭтотОбъект);
	
	ОткрытьФорму("РегистрНакопления.КонтролируемыеСделкиОрганизаций.Форма.ФормаДокументовСделки",
		ПараметрыОткрытияФормы, Элемент, , , , ОповещениеОЗакрытии);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСделки

&НаКлиенте
Процедура СделкиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИзменениеСтрокиЦепочки();
	
КонецПроцедуры

&НаКлиенте
Процедура СделкиПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	
	Если Объект.Сделки.Количество() >= КонтролируемыеСделкиКлиентСервер.МаксимальноеКоличествоСделокВЦепочке() Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'В цепочке не может быть более 4 сделок
			|Добавить еще одну нельзя';
			|en = 'В цепочке не может быть более 4 сделок
			|Добавить еще одну нельзя'"));
		Возврат;
	КонецЕсли;
	
	ИзменениеСтрокиЦепочки(Истина, Копирование);
	
КонецПроцедуры

&НаКлиенте
Процедура СделкиПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	ИзменениеСтрокиЦепочки();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы
&НаКлиенте
Процедура ЗаписатьДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Записать(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Провести(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиИЗакрыть(Команда)
	
	ОбщегоНазначенияУТКлиент.ПровестиИЗакрыть(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПриИзмененииУведмомленияОКонтролируемойСделкеНаСервере()
	
	ПараметрыУведомления = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект.УведомлениеОКонтролируемойСделке, "Организация,ВерсияУведомления");
	Объект.Организация = ПараметрыУведомления.Организация;
	ВерсияУведомления = ПараметрыУведомления.ВерсияУведомления;
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменениеСтрокиЦепочки(ЭтоНовый = Ложь, Копирование = Ложь)
	
	ДанныеЗаполнения = ?(Не ЭтоНовый ИЛИ Копирование, ПолучитьСтруктуруТабличнойЧастиСделки(), Новый Структура);
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("ЭтоНовый", ЭтоНовый);
	СтруктураПараметров.Вставить("Копирование", Копирование);
	СтруктураПараметров.Вставить("ДанныеЗаполнения", ДанныеЗаполнения);
	СтруктураПараметров.Вставить("ВерсияУведомления", ВерсияУведомления);
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("СтруктураПараметров", СтруктураПараметров);
	
	ОповещениеОЗакрытии = Новый ОписаниеОповещения("ИзменениеСтрокиЦепочкиЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	
	ОткрытьФорму("Документ.ЦепочкаСозданияСтоимостиКонтролируемойСделки.Форма.ФормаСделки",
		СтруктураПараметров, ЭтотОбъект,,,, ОповещениеОЗакрытии);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменениеСтрокиЦепочкиЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	СтруктураДанныхСтроки = РезультатЗакрытия;
	
	Если СтруктураДанныхСтроки = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЭтоНовый = ДополнительныеПараметры.СтруктураПараметров.ЭтоНовый;
	
	Если ЭтоНовый Тогда
		СтрокаТаблицы = Объект.Сделки.Добавить();
	Иначе
		СтрокаТаблицы = Объект.Сделки.НайтиПоИдентификатору(Элементы.Сделки.ТекущаяСтрока);
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(СтрокаТаблицы, СтруктураДанныхСтроки);
	
	ЗаполнитьДобавленныеПоляСделки(ЭтотОбъект, СтрокаТаблицы);
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура РасчетныйДокументНачалоВыбораЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	Если ЗначениеЗаполнено(РезультатЗакрытия) Тогда
		Объект.РасчетныйДокумент = РезультатЗакрытия;
		Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьСтруктуруТабличнойЧастиСделки()
	
	СтрокаТаблицы = Элементы.Сделки.ТекущиеДанные;
	Если СтрокаТаблицы = Неопределено Тогда
		Возврат Новый Структура;
	КонецЕсли;
	
	СтруктураТабличнойЧастиСделки = Новый Структура(
		"ПризнакУчастникаСделки,
		|ИспользованиеПроисхождениеТовара,
		|НаименованиеИспользованияПроисхожденияТовара,
		|ДатаСовершенияСделки,
		|Контрагент,
		|УчастникиВзаимозависимы,
		|НомерДоговора,
		|ДатаДоговора,
		|КодУсловийПоставки,
		|СтранаСовершенияСделки,
		|ОКТМОСовершенияСделки,
		|Количество,
		|ЕдиницаИзмерения,
		|Цена,
		|Валюта,
		|Стоимость");
	
	ЗаполнитьЗначенияСвойств(СтруктураТабличнойЧастиСделки, СтрокаТаблицы);
	
	Возврат СтруктураТабличнойЧастиСделки;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ЗаполнитьДобавленныеПоляСделки(Форма, СтрокаТаблицы = Неопределено)
	
	ЗаполняемыеСтроки = Новый Массив;
	Если СтрокаТаблицы <> Неопределено Тогда
		ЗаполняемыеСтроки.Добавить(СтрокаТаблицы);
	Иначе
		ЗаполняемыеСтроки = Форма.Объект.Сделки;
	КонецЕсли;
	
	Для Каждого СтрокаСделки Из ЗаполняемыеСтроки Цикл
		
		СтрокаСделки.Договор = ?(ЗначениеЗаполнено(СтрокаСделки.НомерДоговора) Или ЗначениеЗаполнено(СтрокаСделки.ДатаДоговора),
			СтрШаблон(НСтр("ru = '%1 от %2';
							|en = '%1 от %2'"), СтрокаСделки.НомерДоговора, Формат(СтрокаСделки.ДатаДоговора, "ДЛФ=D")),
			"");
		
	КонецЦикла;
	
КонецПроцедуры

#Область СлужебныеПроцедурыИФункцииБСП

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры

// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#КонецОбласти
