
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	СписокКодов = КонтролируемыеСделкиПовтИсп.СписокКодовНаименованийСделки();
	Элементы.КодНаименованияСделки.СписокВыбора.Очистить();
	Для Каждого Код Из СписокКодов Цикл
		НовыйКод = Элементы.КодНаименованияСделки.СписокВыбора.Добавить();
		ЗаполнитьЗначенияСвойств(НовыйКод, Код);
	КонецЦикла;
	
	ВерсияУведомления = Документы.УведомлениеОКонтролируемыхСделках.ВерсияУведомления(Объект.УведомлениеОКонтролируемойСделке);
	
	УстановитьВидимостьКлассификаторовПредметаСделки();
	
	НастроитьКолонкиТабличнойЧасти();
	
	УстановитьСписокВыбораДляКодаСтороныСделки();
	
	ЗаполнитьПоляНаименованийКодов();
	
	ЗаполнитьДобавленныеПоляЛистов1В(ЭтотОбъект);
	
	ЗаполнитьДобавленныеПоляЛистов1Г(Этотобъект);
	
	УправлениеФормой(ЭтотОбъект);
	
	Если Объект.УказыватьСведенияЦепочкиСозданияСтоимости Тогда
		ПроверитьИЗаполнитьИдентификаторыЛистов1Б(ЭтотОбъект);
	КонецЕсли;
	
	Если Параметры.Свойство("АктивироватьСтрокуТабличнойЧасти") Тогда
		АктивироватьСтрокуТабличнойЧасти = Параметры.АктивироватьСтрокуТабличнойЧасти;
		ТекущийЭлемент = Элементы[АктивироватьСтрокуТабличнойЧасти.ТабличнаяЧасть];
		ТекущийЭлемент.ТекущаяСтрока = АктивироватьСтрокуТабличнойЧасти.НомерСтроки - 1;
	КонецЕсли;
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец ИнтеграцияС1СДокументооборотом
	
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	
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
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если НЕ ЗначениеЗаполнено(ТекущийОбъект.Номер) И НЕ ТекущийОбъект.ПометкаУдаления Тогда
		ТекущийОбъект.Номер = КонтролируемыеСделки.ПолучитьСледующийНомерКонтролируемойСделкиУведомления(ТекущийОбъект.УведомлениеОКонтролируемойСделке);
	КонецЕсли;
	
	Если ТекущийОбъект.Номер <> ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ТекущийОбъект.Ссылка, "Номер") Тогда
		ПараметрыЗаписи.Вставить("НомерКонтролируемойСделкиИзменился", Истина);
	КонецЕсли;

	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец ИнтеграцияС1СДокументооборотом
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("КонтролируемаяСделкаИзменена", Объект.УведомлениеОКонтролируемойСделке);
	Если ПараметрыЗаписи.Свойство("НомерКонтролируемойСделкиИзменился") Тогда
		Оповестить("НомерКонтролируемойСделкиИзменился", Объект.УведомлениеОКонтролируемойСделке);
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульПодключаемыеКомандыКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ПодключаемыеКомандыКлиент");
		МодульПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ЗаполнитьДобавленныеПоляЛистов1В(ЭтотОбъект);
	
	ЗаполнитьДобавленныеПоляЛистов1Г(ЭтотОбъект);
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура УведомлениеОКонтролируемойСделкеПриИзменении(Элемент)

	Если ЗначениеЗаполнено(Объект.УведомлениеОКонтролируемойСделке) Тогда 
		ПриИзмененииУведомленияОКонтролируемойСделкеНаСервере();
	Иначе
		Объект.Организация = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДоговорПриИзменении(Элемент)
	
	ПриИзмененииДоговораНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура СделкаСовершенаЧерезКомиссионераПриИзменении(Элемент)
	
	Если Не Объект.СделкаСовершенаЧерезКомиссионера Тогда
		Объект.Комиссионер = Неопределено;
	КонецЕсли;
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура КодНаименованияСделкиПриИзменении(Элемент)
	
	ИзменениеКодаНаименованияСделкиНаСервере();
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредметСделкиПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Объект.ПредметСделки) Тогда
		
		ПредметСделкиПриИзмененииНаСервере();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТипПредметаСделкиПриИзменении(Элемент)
	
	НастроитьКолонкиТабличнойЧасти();
	
КонецПроцедуры

&НаКлиенте
Процедура ТипСделкиПриИзменении(Элемент)
	
	УстановитьКодСтороныСделки(ЭтотОбъект);
	ПересчитатьСуммыДокумента();
	
КонецПроцедуры

&НаКлиенте
Процедура РедактироватьСуммыСделокПриИзменении(Элемент)
	
	ПересчитатьСуммыДокумента();
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ТНВЭДКодПриИзменении(Элемент)
	
	ЗаполнитьПолеНаименованияКода("ТНВЭД")
	
КонецПроцедуры

&НаКлиенте
Процедура ОКПКодПриИзменении(Элемент)
	
	ЗаполнитьПолеНаименованияКода("ОКП");
	
КонецПроцедуры

&НаКлиенте
Процедура ОКВЭДКодПриИзменении(Элемент)
	
	ЗаполнитьПолеНаименованияКода("ОКВЭД");
	
КонецПроцедуры

&НаКлиенте
Процедура ОКПД2КодПриИзменении(Элемент)
	
	ЗаполнитьПолеНаименованияКода("ОКПД2");
	
КонецПроцедуры

&НаКлиенте
Процедура УказыватьСведенияЦепочкиСозданияСтоимостиПриИзменении(Элемент)
	
	ПроверитьИЗаполнитьИдентификаторыЛистов1Б(ЭтотОбъект);
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентПриИзменении(Элемент)
	УправлениеФормой(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ОКВЭД2КодПриИзменении(Элемент)
	
	//++ Локализация
	
	ЗаполнитьПолеНаименованияКода("ОКВЭД2");
	
	//-- Локализация
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСделки

&НаКлиенте
Процедура СделкиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИзменениеСтрокиСделки();

КонецПроцедуры

&НаКлиенте
Процедура СделкиПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	Отказ = Истина;
	ИзменениеСтрокиСделки(Истина, Копирование);
КонецПроцедуры

&НаКлиенте
Процедура СделкиПередНачаломИзменения(Элемент, Отказ)
	Отказ = Истина;
	ИзменениеСтрокиСделки();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыЛисты1В

&НаКлиенте
Процедура Листы1ВВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИзменениеСтрокиЛиста1В();
	
КонецПроцедуры

&НаКлиенте
Процедура Листы1ВПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	ИзменениеСтрокиЛиста1В(Истина, Копирование);
	
КонецПроцедуры

&НаКлиенте
Процедура Листы1ВПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	ИзменениеСтрокиЛиста1В();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыЛисты1Г

&НаКлиенте
Процедура Листы1ГВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИзменениеСтрокиЛиста1Г();
	
КонецПроцедуры

&НаКлиенте
Процедура Листы1ГПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	ИзменениеСтрокиЛиста1Г(Истина, Копирование);
	
КонецПроцедуры

&НаКлиенте
Процедура Листы1ГПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	ИзменениеСтрокиЛиста1Г();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

#Область СлужебныеПроцедурыИФункцииБСП

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры

&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункцииБИД

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтотОбъект, Объект);
	
КонецПроцедуры
// Конец ИнтеграцияС1СДокументооборотом

#КонецОбласти

&НаКлиенте
Процедура ЗаписатьДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Записать(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	ОбщегоНазначенияУТКлиент.ЗаписатьИЗакрыть(ЭтотОбъект);
	
КонецПроцедуры
#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Объект = Форма.Объект;
	Элементы = Форма.Элементы;
	
	Элементы.КодСтороныСделки.Доступность = Форма.Объект.КодНаименованияСделки <> "";
	
	Элементы.СуммаДоходов.ТолькоПросмотр  = НЕ Объект.РедактироватьСуммыСделок;
	Элементы.СуммаРасходов.ТолькоПросмотр = НЕ Объект.РедактироватьСуммыСделок;
	
	Версия2018 = Форма.ВерсияУведомления >= КонтролируемыеСделкиКлиентСервер.ВерсияУведомления_2018();
	
	Элементы.Комиссионер.Видимость = Версия2018;
	Элементы.СделкаСовершенаЧерезКомиссионера.Видимость = Версия2018;
	Элементы.Комиссионер.Доступность = Объект.СделкаСовершенаЧерезКомиссионера И Версия2018;
	Элементы.Комиссионер.АвтоОтметкаНезаполненного = Объект.СделкаСовершенаЧерезКомиссионера И Версия2018;
	
	Элементы.Валюта.Видимость = Версия2018;
	
	ОписаниеОснованийКонтролируемости = 
		КонтролируемыеСделкиКлиентСервер.ОписаниеОснованийКонтролируемости(Форма.ВерсияУведомления);
		
	Для Каждого Описание Из ОписаниеОснованийКонтролируемости Цикл
		Элементы[Описание.Ключ].Видимость = Описание.Значение <> Неопределено;
		Если Описание.Значение <> Неопределено Тогда
			Элементы[Описание.Ключ].Заголовок = Описание.Значение.Наименование;
			Элементы[Описание.Ключ].Подсказка = Описание.Значение.Подсказка;
		КонецЕсли;
	КонецЦикла;
	
	УказыватьСведенияЦепочкиСозданияСтоимости = Форма.ВерсияУведомления
		>= КонтролируемыеСделкиКлиентСервер.ВерсияУведомления_2024();
	
	Элементы.УказыватьСведенияЦепочкиСозданияСтоимости.Видимость = УказыватьСведенияЦепочкиСозданияСтоимости;
	Элементы.ГруппаЛисты1В.Видимость = УказыватьСведенияЦепочкиСозданияСтоимости И Объект.УказыватьСведенияЦепочкиСозданияСтоимости;
	Элементы.ГруппаЛисты1Г.Видимость = УказыватьСведенияЦепочкиСозданияСтоимости И Объект.УказыватьСведенияЦепочкиСозданияСтоимости;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьПараметрыПредметаСделки(ПредметСделки, ВерсияУведомления)
	
	ПараметрыПредмета = Новый Структура("НаименованиеПредметаСделки, СтранаПроисхожденияПредметаСделки, ТипПредметаСделки,
		|КодТНВЭД, КодОКП, КодОКВЭД, КодОКВЭД2, КодОКПД2");
	
	Если Не ЗначениеЗаполнено(ПредметСделки) Тогда
		Возврат ПараметрыПредмета;
	КонецЕсли;
	
	Если ТипЗнч(ПредметСделки)=Тип("СправочникСсылка.Номенклатура") Тогда
		Предмет = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ПредметСделки, "НаименованиеПолное, СтранаПроисхождения, ТипНоменклатуры, КодТНВЭД, КодОКП, КодОКВЭД, КодОКВЭД2, КодОКПД2");
		ПараметрыПредмета.НаименованиеПредметаСделки = Предмет.НаименованиеПолное;
		ПараметрыПредмета.СтранаПроисхожденияПредметаСделки = Предмет.СтранаПроисхождения;
		
		ЭтоУслуга = ?(Предмет.ТипНоменклатуры = Перечисления.ТипыНоменклатуры.Услуга, Истина, Ложь);
		
		ЗаполняемыеКодыПредметовСделок = ЗаполняемыеКодыПредметовСделок(Не ЭтоУслуга, ВерсияУведомления);
		ЗаполнитьЗначенияСвойств(ПараметрыПредмета, Предмет, ЗаполняемыеКодыПредметовСделок);
		
		Если ЭтоУслуга Тогда
			ПараметрыПредмета.ТипПредметаСделки = Перечисления.ТипыПредметовКонтролируемыхСделок.РаботаУслуга;
		Иначе
			ПараметрыПредмета.ТипПредметаСделки = Перечисления.ТипыПредметовКонтролируемыхСделок.Товар;
		КонецЕсли;
	ИначеЕсли ТипЗнч(ПредметСделки)=Тип("ПеречислениеСсылка.ТипыСуммГрафикаКредитовИДепозитов") Тогда
		ПараметрыПредмета.ТипПредметаСделки = Перечисления.ТипыПредметовКонтролируемыхСделок.ДолговоеОбязательство;
	ИначеЕсли ТипЗнч(ПредметСделки)=Тип("СправочникСсылка.ОбъектыЭксплуатации") Тогда
		Предмет = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ПредметСделки, "Наименование");
		ПараметрыПредмета.НаименованиеПредметаСделки = Предмет.Наименование;
		ПараметрыПредмета.ТипПредметаСделки          = Перечисления.ТипыПредметовКонтролируемыхСделок.ИнойОбъектГражданскихПрав;
	ИначеЕсли ТипЗнч(ПредметСделки)=Тип("СправочникСсылка.НематериальныеАктивы") Тогда
		Предмет = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ПредметСделки, "Наименование, КодОКВЭД2");
		ПараметрыПредмета.НаименованиеПредметаСделки = Предмет.Наименование;
		ПараметрыПредмета.ТипПредметаСделки          = Перечисления.ТипыПредметовКонтролируемыхСделок.ИнойОбъектГражданскихПрав;
		
		ЗаполняемыеКодыПредметовСделок = ЗаполняемыеКодыПредметовСделок(Ложь, ВерсияУведомления);
		ЗаполнитьЗначенияСвойств(ПараметрыПредмета, Предмет, ЗаполняемыеКодыПредметовСделок);
	КонецЕсли;
	
	Возврат(ПараметрыПредмета);
	
КонецФункции

&НаСервере
Процедура ПриИзмененииДоговораНаСервере()
	
	Если ЗначениеЗаполнено(Объект.Договор) Тогда
		
		РеквизитыДоговора = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект.Договор, "ВалютаВзаиморасчетов,ОплатаВВалюте");
		Если НЕ РеквизитыДоговора.ОплатаВВалюте Тогда
			Объект.Валюта = ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета();
		Иначе
			Объект.Валюта = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.Договор, "ВалютаВзаиморасчетов");
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗаполняемыеКодыПредметовСделок(Товар, ВерсияУведомления)
	
	ЗаполняемыеКоды = Новый Массив;
	
	Если НЕ Товар И ВерсияУведомления = КонтролируемыеСделкиКлиентСервер.ВерсияУведомления_2012() Тогда
		ЗаполняемыеКоды.Добавить("КодОКВЭД");
	КонецЕсли;
	
	Если НЕ Товар И ВерсияУведомления > КонтролируемыеСделкиКлиентСервер.ВерсияУведомления_2012() Тогда
		ЗаполняемыеКоды.Добавить("КодОКВЭД2");
	КонецЕсли;
	
	Если Товар Тогда
		ЗаполняемыеКоды.Добавить("КодТНВЭД");
	КонецЕсли;
	
	Если Товар И ВерсияУведомления = КонтролируемыеСделкиКлиентСервер.ВерсияУведомления_2012() Тогда
		ЗаполняемыеКоды.Добавить("КодОКП");
	КонецЕсли;
	
	Если Товар И ВерсияУведомления > КонтролируемыеСделкиКлиентСервер.ВерсияУведомления_2012() Тогда
		ЗаполняемыеКоды.Добавить("КодОКПД2");
	КонецЕсли;
	
	Возврат СтрСоединить(ЗаполняемыеКоды, ",");
	
КонецФункции

&НаКлиенте
Процедура ПересчитатьСуммыДокумента()
	
	Если Объект.РедактироватьСуммыСделок Тогда
		Возврат;
	КонецЕсли;
	
	СуммаДоход = 0;
	СуммаРасход = 0;
	Если Объект.ТипСделки = ПредопределенноеЗначение("Перечисление.ТипыКонтролируемыхСделок.ОсуществленРасход") Тогда 
		СуммаРасход = Объект.Сделки.Итог("Стоимость");
	ИначеЕсли Объект.ТипСделки = ПредопределенноеЗначение("Перечисление.ТипыКонтролируемыхСделок.ПолученДоход") Тогда 
		СуммаДоход = Объект.Сделки.Итог("Стоимость");
	КонецЕсли;
	
	Если Объект.СуммаДоходов <> СуммаДоход Тогда 
		Объект.СуммаДоходов = СуммаДоход;
	КонецЕсли;
	
	Если Объект.СуммаРасходов <> СуммаРасход Тогда 
		Объект.СуммаРасходов = СуммаРасход;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьСписокВыбораДляКодаСтороныСделки()
	
	СоответствиеКодов = КонтролируемыеСделки.ПолучитьСоответствиеКодовСтороныСделки();
	Элементы.КодСтороныСделки.СписокВыбора.Очистить();
	
	СписокКодов = СоответствиеКодов.Получить(Объект.КодНаименованияСделки);
	Если СписокКодов<>Неопределено Тогда
		Для Каждого Код Из СписокКодов Цикл
			НовыйКод = Элементы.КодСтороныСделки.СписокВыбора.Добавить();
			ЗаполнитьЗначенияСвойств(НовыйКод, Код);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьКодСтороныСделки(Форма)
	
	СписокКодовСтороныСделки = Форма.Элементы.КодСтороныСделки.СписокВыбора;
	Если СписокКодовСтороныСделки.Количество()>1 Тогда
		Форма.Объект.КодСтороныСделки = ?(Форма.Объект.ТипСделки = ПредопределенноеЗначение("Перечисление.ТипыКонтролируемыхСделок.ПолученДоход"),
			СписокКодовСтороныСделки[0].Значение, СписокКодовСтороныСделки[1].Значение);
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьКлассификаторовПредметаСделки()
	
	ВерсияУведомления_2012 = КонтролируемыеСделкиКлиентСервер.ВерсияУведомления_2012();
	
	Элементы.ОКВЭД.Видимость  = ВерсияУведомления <= ВерсияУведомления_2012;
	Элементы.ОКВЭД2.Видимость = ВерсияУведомления > ВерсияУведомления_2012;
	Элементы.ОКП.Видимость    = ВерсияУведомления <= ВерсияУведомления_2012;
	Элементы.ОКПД2.Видимость  = ВерсияУведомления > ВерсияУведомления_2012;
	
КонецПроцедуры

&НаСервере
Процедура НастроитьКолонкиТабличнойЧасти()
	
	ВерсияУведомления2018ИСтарше = ВерсияУведомления >= КонтролируемыеСделкиКлиентСервер.ВерсияУведомления_2018();
	
	Элементы.СделкиПроцентнаяСтавка.Видимость = 
		ВерсияУведомления2018ИСтарше
		И Объект.ТипПредметаСделки = Перечисления.ТипыПредметовКонтролируемыхСделок.ДолговоеОбязательство;
	
	Элементы.СделкиЦена.Видимость = Не ВерсияУведомления2018ИСтарше
		ИЛИ Объект.ТипПредметаСделки <> Перечисления.ТипыПредметовКонтролируемыхСделок.ДолговоеОбязательство;
	
	Если ВерсияУведомления2018ИСтарше Тогда
		Элементы.СделкиКоличество.Формат = "ЧЦ=14; ЧДЦ=5";
	Иначе
		Элементы.СделкиКоличество.Формат = "ЧЦ=15; ЧДЦ=";
	КонецЕсли;
	
	Если Элементы.СделкиЦена.Видимость Тогда
		Если ВерсияУведомления2018ИСтарше Тогда
			Элементы.СделкиЦена.Заголовок = СтрШаблон(НСтр("ru = 'Цена, %1';
															|en = 'Price, %1'"), Объект.Валюта);
			Элементы.СделкиЦена.Формат = "ЧЦ=18; ЧДЦ=4";
		Иначе
			Элементы.СделкиЦена.Заголовок = НСтр("ru = 'Цена, руб.';
												|en = 'Price, rub.'");
			Элементы.СделкиЦена.Формат = "ЧЦ=15; ЧДЦ=";
		КонецЕсли;
	КонецЕсли;
	
	Элементы.СделкиСтранаОтправкиТовара.Видимость = ВерсияУведомления < КонтролируемыеСделкиКлиентСервер.ВерсияУведомления_2024();
	Элементы.СделкиСтранаСовершенияСделки.Видимость = ВерсияУведомления < КонтролируемыеСделкиКлиентСервер.ВерсияУведомления_2024();
	
	Элементы.СделкиСуммаБазыДляРасчетаРоялти.Видимость = ВерсияУведомления >= КонтролируемыеСделкиКлиентСервер.ВерсияУведомления_2024()
		И Объект.ТипПредметаСделки = Перечисления.ТипыПредметовКонтролируемыхСделок.ИнойОбъектГражданскихПрав;
	
	Элементы.СделкиОКТМОСовершенияСделки.Видимость = ВерсияУведомления >= КонтролируемыеСделкиКлиентСервер.ВерсияУведомления_2024();
	Элементы.СделкиНаселенныйПунктСовершенияСделки.Видимость = ВерсияУведомления >= КонтролируемыеСделкиКлиентСервер.ВерсияУведомления_2024();
	
КонецПроцедуры

&НаСервере
Процедура ИзменениеКодаНаименованияСделкиНаСервере()
	
	УстановитьСписокВыбораДляКодаСтороныСделки();
	Если Объект.КодНаименованияСделки = "" Тогда
		Объект.КодСтороныСделки = "";
	ИначеЕсли Объект.КодСтороныСделки <> "" Тогда
		Если Элементы.КодСтороныСделки.СписокВыбора.НайтиПоЗначению(Объект.КодСтороныСделки) = Неопределено Тогда
			Объект.КодСтороныСделки = "";
		КонецЕсли;
	КонецЕсли;
	
	УстановитьКодСтороныСделки(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ПредметСделкиПриИзмененииНаСервере()
	
	ПараметрыПредметаСделки = ПолучитьПараметрыПредметаСделки(Объект.ПредметСделки, ВерсияУведомления);
	
	Если ЗначениеЗаполнено(ПараметрыПредметаСделки.ТипПредметаСделки) Тогда
		Объект.ТипПредметаСделки = ПараметрыПредметаСделки.ТипПредметаСделки;
		НастроитьКолонкиТабличнойЧасти();
	КонецЕсли;
	
	Объект.НаименованиеПредметаСделки = ПараметрыПредметаСделки.НаименованиеПредметаСделки;
	Если ЗначениеЗаполнено(ПараметрыПредметаСделки.СтранаПроисхожденияПредметаСделки) Тогда
		Объект.СтранаПроисхожденияПредметаСделки = ПараметрыПредметаСделки.СтранаПроисхожденияПредметаСделки;
	КонецЕсли;
	
	Объект.КодТНВЭД  = ПараметрыПредметаСделки.КодТНВЭД;
	Объект.КодОКП    = ПараметрыПредметаСделки.КодОКП;
	Объект.КодОКВЭД  = ПараметрыПредметаСделки.КодОКВЭД;
	Объект.КодОКВЭД2 = ПараметрыПредметаСделки.КодОКВЭД2;
	Объект.КодОКПД2 = ПараметрыПредметаСделки.КодОКПД2;
	
	ЗаполнитьПоляНаименованийКодов();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПолеНаименованияКода(ИмяКлассификатора)
	
	Классификатор = Объект["Код" + ИмяКлассификатора];
	ЭтотОбъект[ИмяКлассификатора+"Наименование"] = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Классификатор, "Наименование");
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПоляНаименованийКодов()
	
	ЗаполнитьПолеНаименованияКода("ТНВЭД");
	ЗаполнитьПолеНаименованияКода("ОКВЭД");
	ЗаполнитьПолеНаименованияКода("ОКП");
	ЗаполнитьПолеНаименованияКода("ОКПД2");
	
КонецПроцедуры

&НаСервере
Процедура ПриИзмененииУведомленияОКонтролируемойСделкеНаСервере()
	ПараметрыУведомления = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект.УведомлениеОКонтролируемойСделке, "Организация, Дата, ВерсияУведомления");
	
	Объект.Организация = ПараметрыУведомления.Организация;
	Объект.Дата = ПараметрыУведомления.Дата;
	Если ВерсияУведомления <> ПараметрыУведомления.ВерсияУведомления Тогда
		ВерсияУведомления = ПараметрыУведомления.ВерсияУведомления;
		// Так как коды предмета сделки зависят от версии уведомления,
		// то после возможного изменения версии нужно обновить и коды.
		ПредметСделкиПриИзмененииНаСервере();
	КонецЕсли;
	
	УстановитьВидимостьКлассификаторовПредметаСделки();
	
	НастроитьКолонкиТабличнойЧасти();
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ПроверитьИЗаполнитьИдентификаторыЛистов1Б(Форма)
	
	Объект = Форма.Объект;
	
	Если Объект.УказыватьСведенияЦепочкиСозданияСтоимости Тогда
		Для Каждого СтрокаЛиста1Б Из Объект.Сделки Цикл
			ЗаполнитьИдентификаторЛиста1Б(СтрокаЛиста1Б);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ЗаполнитьИдентификаторЛиста1Б(СтрокаЛиста1Б)
	Если Не ЗначениеЗаполнено(СтрокаЛиста1Б.ИдентификаторЛиста1Б) Тогда
		СтрокаЛиста1Б.ИдентификаторЛиста1Б = Новый УникальныйИдентификатор();
	КонецЕсли;
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ЗаполнитьИдентификаторЛиста1В(СтрокаЛиста1В)
	Если Не ЗначениеЗаполнено(СтрокаЛиста1В.ИдентификаторЛиста1В) Тогда
		СтрокаЛиста1В.ИдентификаторЛиста1В = Новый УникальныйИдентификатор();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ИзменениеСтрокиСделки(ЭтоНовый = Ложь, Копирование = Ложь)
	
	ДанныеЗаполнения	= ?(Не ЭтоНовый ИЛИ Копирование, ПолучитьСтруктуруТабличнойЧастиСделки(), Новый Структура);
	СтруктураПараметров	= Новый Структура;
	СтруктураПараметров.Вставить("ЭтоНовый", ЭтоНовый);
	СтруктураПараметров.Вставить("Копирование", Копирование);
	СтруктураПараметров.Вставить("ДанныеЗаполнения", ДанныеЗаполнения);
	СтруктураПараметров.Вставить("ВерсияУведомления", ВерсияУведомления);
	СтруктураПараметров.Вставить("Валюта", Объект.Валюта);
	СтруктураПараметров.Вставить("ТипПредметаСделки", Объект.ТипПредметаСделки);
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("СтруктураПараметров", СтруктураПараметров);
	
	ОповещениеОЗакрытии = Новый ОписаниеОповещения("ИзменениеСтрокиСделкиЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	
	ОткрытьФорму("Документ.КонтролируемаяСделка.Форма.Лист1Б",
		СтруктураПараметров, ЭтотОбъект,,,, ОповещениеОЗакрытии);
	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьСтруктуруТабличнойЧастиСделки()
	
	СтрокаТаблицы	= Элементы.Сделки.ТекущиеДанные;
	Если СтрокаТаблицы = Неопределено Тогда
		Возврат Новый Структура;
	КонецЕсли;
	
	СтруктураТабличнойЧастиСделки = Новый Структура(
		"СтранаОтправкиТовара,
		|КодРегионаОтправкиТовара,
		|ГородОтправкиТовара,
		|НаселенныйПунктОтправкиТовара,
		|СтранаСовершенияСделки,
		|КодРегионаСовершенияСделки,
		|ГородСовершенияСделки,
		|НаселенныйПунктСовершенияСделки,
		|ОКТМОСовершенияСделки,
		|КодУсловийПоставки,
		|ЕдиницаИзмерения,
		|Количество,
		|ПроцентнаяСтавка,
		|СуммаБазыДляРасчетаРоялти,
		|Цена,
		|Стоимость,
		|ДатаСовершенияСделки");
	
	ЗаполнитьЗначенияСвойств(СтруктураТабличнойЧастиСделки, СтрокаТаблицы);
		
	Возврат СтруктураТабличнойЧастиСделки;
	
КонецФункции

&НаКлиенте
Процедура ИзменениеСтрокиСделкиЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
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
	ЗаполнитьИдентификаторЛиста1Б(СтрокаТаблицы);
	ПересчитатьСуммыДокумента();
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменениеСтрокиЛиста1В(ЭтоНовый = Ложь, Копирование = Ложь)
	
	ДанныеЗаполнения = ?(Не ЭтоНовый ИЛИ Копирование, ПолучитьСтруктуруТабличнойЧастиЛисты1В(), Новый Структура);
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("ЭтоНовый", ЭтоНовый);
	СтруктураПараметров.Вставить("Копирование", Копирование);
	СтруктураПараметров.Вставить("ДанныеЗаполнения", ДанныеЗаполнения);
	СтруктураПараметров.Вставить("ВерсияУведомления", ВерсияУведомления);
	СтруктураПараметров.Вставить("Листы1Б", СписокЛистов1Б());
	СтруктураПараметров.Вставить("Листы1В", СписокВыбораЛистов1В(ЭтоНовый, Копирование));
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("СтруктураПараметров", СтруктураПараметров);
	
	ОповещениеОЗакрытии = Новый ОписаниеОповещения("ИзменениеСтрокиЛиста1ВЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	
	ОткрытьФорму("Документ.КонтролируемаяСделка.Форма.Лист1В",
		СтруктураПараметров, ЭтотОбъект,,,, ОповещениеОЗакрытии);
	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьСтруктуруТабличнойЧастиЛисты1В()
	
	СтрокаТаблицы = Элементы.Листы1В.ТекущиеДанные;
	Если СтрокаТаблицы = Неопределено Тогда
		Возврат Новый Структура;
	КонецЕсли;
	
	СтруктураТабличнойЧастиЛисты1В = Новый Структура(
		"ТипЛиста,
		|ДатаСовершенияСделки,
		|ИдентификаторЛиста1Б,
		|КомментарийКЛисту1Б,
		|ИдентификаторПредыдущегоЛиста1В,
		|ИспользованиеПроисхождениеТовара,
		|НаименованиеИспользованияПроисхожденияТовара,
		|ПризнакУчастникаСделки,
		|Контрагент,
		|УчастникиВзаимозависимы,
		|НомерДоговора,
		|ДатаДоговора,
		|КодУсловийПоставки,
		|ОКТМОСовершенияСделки,
		|СтранаСовершенияСделки,
		|ЕдиницаИзмерения,
		|Количество,
		|Цена,
		|Валюта,
		|Стоимость");
	
	ЗаполнитьЗначенияСвойств(СтруктураТабличнойЧастиЛисты1В, СтрокаТаблицы);
	
	СвязанныеЛисты1Б = Новый Массив;
	Если ЗначениеЗаполнено(СтрокаТаблицы.ИдентификаторЛиста1В) Тогда
		СтрокиЛиста1В = Листы1БДляЛиста1В(СтрокаТаблицы.ИдентификаторЛиста1В);
		Для Каждого СтрокаЛиста1В Из СтрокиЛиста1В Цикл
			СвязанныеЛисты1Б.Добавить(СтрокаЛиста1В.ИдентификаторЛиста1Б);
		КонецЦикла;
	КонецЕсли;
	
	СтруктураТабличнойЧастиЛисты1В.Вставить("СвязанныеЛисты1Б", СвязанныеЛисты1Б);
	
	Возврат СтруктураТабличнойЧастиЛисты1В;
	
КонецФункции

&НаКлиенте
Процедура ИзменениеСтрокиЛиста1ВЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	СтруктураДанныхСтроки = РезультатЗакрытия;
	
	Если СтруктураДанныхСтроки = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЭтоНовый = ДополнительныеПараметры.СтруктураПараметров.ЭтоНовый;
	
	Если ЭтоНовый Тогда
		СтрокаТаблицы = Объект.Листы1В.Добавить();
	Иначе
		СтрокаТаблицы = Объект.Листы1В.НайтиПоИдентификатору(Элементы.Листы1В.ТекущаяСтрока);
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(СтрокаТаблицы, СтруктураДанныхСтроки);
	ЗаполнитьИдентификаторЛиста1В(СтрокаТаблицы);
	
	// Удаляем старые строки связи 1Б и 1В и добавляем новые
	СтрокиЛиста1В = Листы1БДляЛиста1В(СтрокаТаблицы.ИдентификаторЛиста1В);
	Для Каждого СтрокаЛиста1Б Из СтрокиЛиста1В Цикл
		Объект.СвязьЛистов1Би1В.Удалить(СтрокаЛиста1Б);
	КонецЦикла;
	
	Для Каждого ИдентификаторЛиста1Б Из СтруктураДанныхСтроки.Листы1Б Цикл
		НоваяСтрока1Би1В = Объект.СвязьЛистов1Би1В.Добавить();
		НоваяСтрока1Би1В.ИдентификаторЛиста1Б = ИдентификаторЛиста1Б;
		НоваяСтрока1Би1В.ИдентификаторЛиста1В = СтрокаТаблицы.ИдентификаторЛиста1В;
	КонецЦикла;
	
	ЗаполнитьДобавленныеПоляЛистов1В(ЭтотОбъект, СтрокаТаблицы);
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменениеСтрокиЛиста1Г(ЭтоНовый = Ложь, Копирование = Ложь)
	
	ДанныеЗаполнения = ?(Не ЭтоНовый ИЛИ Копирование, ПолучитьСтруктуруТабличнойЧастиЛисты1Г(), Новый Структура);
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("ЭтоНовый", ЭтоНовый);
	СтруктураПараметров.Вставить("Копирование", Копирование);
	СтруктураПараметров.Вставить("ДанныеЗаполнения", ДанныеЗаполнения);
	СтруктураПараметров.Вставить("ВерсияУведомления", ВерсияУведомления);
	СтруктураПараметров.Вставить("Листы1Б", СписокЛистов1Б());
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("СтруктураПараметров", СтруктураПараметров);
	
	ОповещениеОЗакрытии = Новый ОписаниеОповещения("ИзменениеСтрокиЛиста1ГЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	
	ОткрытьФорму("Документ.КонтролируемаяСделка.Форма.Лист1Г",
		СтруктураПараметров, ЭтотОбъект,,,, ОповещениеОЗакрытии);
	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьСтруктуруТабличнойЧастиЛисты1Г()
	
	СтрокаТаблицы = Элементы.Листы1Г.ТекущиеДанные;
	Если СтрокаТаблицы = Неопределено Тогда
		Возврат Новый Структура;
	КонецЕсли;
	
	СтруктураТабличнойЧастиСделки = Новый Структура(
		"ИдентификаторЛиста1Б,
		|НаименованиеУслуги,
		|УчастникиВзаимозависимы,
		|Контрагент,
		|Валюта,
		|Стоимость");
	
	ЗаполнитьЗначенияСвойств(СтруктураТабличнойЧастиСделки, СтрокаТаблицы);
	
	Возврат СтруктураТабличнойЧастиСделки;
	
КонецФункции

&НаКлиенте
Процедура ИзменениеСтрокиЛиста1ГЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	СтруктураДанныхСтроки = РезультатЗакрытия;
	
	Если СтруктураДанныхСтроки = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЭтоНовый = ДополнительныеПараметры.СтруктураПараметров.ЭтоНовый;
	
	Если ЭтоНовый Тогда
		СтрокаТаблицы = Объект.Листы1Г.Добавить();
	Иначе
		СтрокаТаблицы = Объект.Листы1Г.НайтиПоИдентификатору(Элементы.Листы1Г.ТекущаяСтрока);
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(СтрокаТаблицы, СтруктураДанныхСтроки);
	
	ЗаполнитьДобавленныеПоляЛистов1Г(ЭтотОбъект, СтрокаТаблицы);
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ЗаполнитьДобавленныеПоляЛистов1В(Форма, СтрокаТаблицы = Неопределено)
	
	ЗаполняемыеСтроки = Новый Массив;
	Если СтрокаТаблицы <> Неопределено Тогда
		ЗаполняемыеСтроки.Добавить(СтрокаТаблицы);
		ОписаниеСвязанныхЛистов = ОписаниеСвязанныхЛистов1БДля1В(Форма, СтрокаТаблицы.ИдентификаторЛиста1В);
	Иначе
		ЗаполняемыеСтроки = Форма.Объект.Листы1В;
		ОписаниеСвязанныхЛистов = ОписаниеСвязанныхЛистов1БДля1В(Форма);
	КонецЕсли;
	
	Листы1Б = Новый Соответствие;
	Для Каждого СтрокаЛиста1В Из ЗаполняемыеСтроки Цикл
		Если ЗначениеЗаполнено(СтрокаЛиста1В.ИдентификаторЛиста1Б) Тогда
			Листы1Б.Вставить(СтрокаЛиста1В.ИдентификаторЛиста1Б, "");
		КонецЕсли;
	КонецЦикла;
	
	ЗаполнитьОписаниеЛистов1Б(Форма, Листы1Б);
	
	Для Каждого СтрокаЛиста1В Из ЗаполняемыеСтроки Цикл
		
		Если ЗначениеЗаполнено(СтрокаЛиста1В.ИдентификаторЛиста1Б) Тогда
			СтрокаЛиста1В.Лист1Б = Листы1Б.Получить(СтрокаЛиста1В.ИдентификаторЛиста1Б);
		КонецЕсли;
		
		СтрокаЛиста1В.Договор = ?(ЗначениеЗаполнено(СтрокаЛиста1В.НомерДоговора) Или ЗначениеЗаполнено(СтрокаЛиста1В.ДатаДоговора),
			СтрШаблон(НСтр("ru = '%1 от %2';
							|en = '%1 от %2'"), СтрокаЛиста1В.НомерДоговора, Формат(СтрокаЛиста1В.ДатаДоговора, "ДЛФ=D")),
			"");
		СтрокаЛиста1В.Листы1Б = ОписаниеСвязанныхЛистов.Получить(СтрокаЛиста1В.ИдентификаторЛиста1В);
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ЗаполнитьДобавленныеПоляЛистов1Г(Форма, СтрокаТаблицы = Неопределено)
	
	ЗаполняемыеСтроки = Новый Массив;
	Если СтрокаТаблицы <> Неопределено Тогда
		ЗаполняемыеСтроки.Добавить(СтрокаТаблицы);
	Иначе
		ЗаполняемыеСтроки = Форма.Объект.Листы1Г;
	КонецЕсли;
	
	Листы1Б = Новый Соответствие;
	Для Каждого СтрокаЛиста1Г Из ЗаполняемыеСтроки Цикл
		Если ЗначениеЗаполнено(СтрокаЛиста1Г.ИдентификаторЛиста1Б) Тогда
			Листы1Б.Вставить(СтрокаЛиста1Г.ИдентификаторЛиста1Б, "");
		КонецЕсли;
	КонецЦикла;
	
	ЗаполнитьОписаниеЛистов1Б(Форма, Листы1Б);
	
	Для Каждого СтрокаЛиста1Г Из ЗаполняемыеСтроки Цикл
		Если ЗначениеЗаполнено(СтрокаЛиста1Г.ИдентификаторЛиста1Б) Тогда
			СтрокаЛиста1Г.Лист1Б = Листы1Б.Получить(СтрокаЛиста1Г.ИдентификаторЛиста1Б);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ОписаниеСвязанныхЛистов1БДля1В(Форма, ИдентификаторЛиста1В = Неопределено)
	
	Если ЗначениеЗаполнено(ИдентификаторЛиста1В) Тогда
		СвязиЛистов1Б = Форма.Объект.СвязьЛистов1Би1В.НайтиСтроки(Новый Структура("ИдентификаторЛиста1В", ИдентификаторЛиста1В));
	Иначе
		СвязиЛистов1Б = Форма.Объект.СвязьЛистов1Би1В;
	КонецЕсли;
	
	Листы1Б = Новый Соответствие;
	ИдентификаторыСвязиДляЛистов1В = Новый Соответствие;
	Для Каждого СтрокаСвязи Из СвязиЛистов1Б Цикл
		ИдентификаторСвязиДляЛиста1В = ИдентификаторыСвязиДляЛистов1В.Получить(СтрокаСвязи.ИдентификаторЛиста1В);
		Если ИдентификаторСвязиДляЛиста1В = Неопределено Тогда
			ИдентификаторСвязиДляЛиста1В = Новый Массив;
			ИдентификаторыСвязиДляЛистов1В.Вставить(СтрокаСвязи.ИдентификаторЛиста1В, ИдентификаторСвязиДляЛиста1В);
		КонецЕсли;
		ИдентификаторСвязиДляЛиста1В.Добавить(СтрокаСвязи.ИдентификаторЛиста1Б);
		Листы1Б.Вставить(СтрокаСвязи.ИдентификаторЛиста1Б, "");
	КонецЦикла;
	
	ЗаполнитьОписаниеЛистов1Б(Форма, Листы1Б);
	
	ОписаниеСвязейЛистов1Б = Новый Соответствие;
	Для Каждого КлючЗначение Из ИдентификаторыСвязиДляЛистов1В Цикл
		ОписаниеСвязей = Новый Массив;
		Для Каждого Идентификатор1Б Из КлючЗначение.Значение Цикл
			ОписаниеЛиста1Б = Листы1Б.Получить(Идентификатор1Б);
			Если ЗначениеЗаполнено(ОписаниеЛиста1Б) Тогда
				ОписаниеСвязей.Добавить(ОписаниеЛиста1Б);
			КонецЕсли;
		КонецЦикла;
		
		Если ЗначениеЗаполнено(ОписаниеСвязей) Тогда
			ОписаниеСвязейЛистов1Б.Вставить(КлючЗначение.Ключ, СтрСоединить(ОписаниеСвязей, ", "));
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ОписаниеСвязейЛистов1Б;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ЗаполнитьОписаниеЛистов1Б(Форма, Листы1Б)
	
	Для Каждого Строка1Б Из Форма.Объект.Сделки Цикл
		Если Листы1Б.Получить(Строка1Б.ИдентификаторЛиста1Б) <> Неопределено Тогда
			Листы1Б.Вставить(Строка1Б.ИдентификаторЛиста1Б, Формат(Строка1Б.ДатаСовершенияСделки, "ДЛФ=D"));
		КонецЕсли;
	КонецЦикла;
	
	Возврат Листы1Б;
	
КонецФункции

&НаКлиенте
Функция Листы1БДляЛиста1В(ИдентификаторЛиста1В)
	Возврат Объект.СвязьЛистов1Би1В.НайтиСтроки(Новый Структура("ИдентификаторЛиста1В", ИдентификаторЛиста1В));
КонецФункции

&НаКлиенте
Функция СписокЛистов1Б()
	
	СписокЛистов1Б = Новый Массив;
	
	Для Каждого СтрокаЛиста1Б Из Объект.Сделки Цикл
		ОписаниеЛиста1Б = Новый Структура;
		ОписаниеЛиста1Б.Вставить("ИдентификаторЛиста1Б", СтрокаЛиста1Б.ИдентификаторЛиста1Б);
		ОписаниеЛиста1Б.Вставить("ДатаСовершенияСделки", СтрокаЛиста1Б.ДатаСовершенияСделки);
		ОписаниеЛиста1Б.Вставить("Количество", СтрШаблон(НСтр("ru = '%1 %2';
																|en = '%1 %2'"), СтрокаЛиста1Б.Количество, СтрокаЛиста1Б.ЕдиницаИзмерения));
		ОписаниеЛиста1Б.Вставить("Стоимость", СтрокаЛиста1Б.Стоимость);
		СписокЛистов1Б.Добавить(ОписаниеЛиста1Б);
	КонецЦикла;
	
	Возврат СписокЛистов1Б;
	
КонецФункции

&НаКлиенте
Функция СписокВыбораЛистов1В(ЭтоНовый, Копирование)
	
	// Добавляем все листы с типом "ТорговыйПосредник", кроме текущего.
	СтрокаТаблицы = Элементы.Листы1В.ТекущиеДанные;
	ИдентификаторТекущейСтроки = Неопределено;
	Если СтрокаТаблицы <> Неопределено И Не Копирование И Не ЭтоНовый Тогда
		ИдентификаторТекущейСтроки = СтрокаТаблицы.ПолучитьИдентификатор();
	КонецЕсли;
	
	СписокЛистов1В = Новый СписокЗначений;
	
	Для Каждого СтрокаЛиста1В Из Объект.Листы1В Цикл
		
		Если СтрокаТаблицы <> Неопределено
			И СтрокаТаблицы.ТипЛиста <> СтрокаЛиста1В.ТипЛиста Тогда
			// Можно выбирать в качестве предыдущей сделки только сделки с таким же типом листа.
			// Т.е. для последующей реализации нельзя выбирать сделки предшествующей продажи и наоборот.
			Продолжить;
		КонецЕсли;
		
		Если СтрокаЛиста1В.ПризнакУчастникаСделки <> ПредопределенноеЗначение("Перечисление.ТипыУчастниковЦепочкиКонтролируемыхСделок.ТорговыйПосредник") Тогда
			// В качестве предыдущих листов можно выбирать только листы с типом "Торговый посредник".
			Продолжить;
		КонецЕсли;
		
		Если ИдентификаторТекущейСтроки = Неопределено
			Или ИдентификаторТекущейСтроки <> СтрокаЛиста1В.ПолучитьИдентификатор() Тогда
			СписокЛистов1В.Добавить(СтрокаЛиста1В.ИдентификаторЛиста1В, ОписаниеЛиста1В(СтрокаЛиста1В));
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат СписокЛистов1В;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ОписаниеЛиста1В(СтрокаЛиста1В)
	
	Если КонтролируемыеСделкиКлиентСервер.НужноЗаполнятьСведенияОСделкеЛиста1В(СтрокаЛиста1В.ИспользованиеПроисхождениеТовара) Тогда
		Возврат СтрШаблон(НСтр("ru = '%1, %2 %3, на сумму %4 (%5)';
								|en = '%1, %2 %3, на сумму %4 (%5)'"),
			Формат(СтрокаЛиста1В.ДатаСовершенияСделки, "ДЛФ=D"), СтрокаЛиста1В.Количество, СтрокаЛиста1В.ЕдиницаИзмерения,
			Формат(СтрокаЛиста1В.Стоимость, "ЧДЦ=2; ЧГ=3,0"), Строка(СтрокаЛиста1В.Контрагент));
	Иначе
		Возврат СтрШаблон(НСтр("ru = '%1 (строка %2)';
								|en = '%1 (строка %2)'"), Строка(СтрокаЛиста1В.ИспользованиеПроисхождениеТовара), Строка(СтрокаЛиста1В.НомерСтроки));
	КонецЕсли;
	
КонецФункции

#КонецОбласти