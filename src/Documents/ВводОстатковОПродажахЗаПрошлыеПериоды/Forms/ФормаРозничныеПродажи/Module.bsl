#Область ОписаниеПеременных

&НаКлиенте
Перем КэшированныеЗначения; //используется механизмом обработки изменения реквизитов ТЧ

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ИспользуетсяНесколькоОрганизаций = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций");
	Если Не (ИспользуетсяНесколькоОрганизаций ИЛИ ЗначениеЗаполнено(Объект.Организация)) Тогда
		Объект.Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию();
	КонецЕсли;
	
	ВалютаУправленческогоУчета = Константы.ВалютаУправленческогоУчета.Получить();
	ВалютаРегламентированногоУчета = ЗначениеНастроекПовтИсп.ВалютаРегламентированногоУчетаОрганизации(Объект.Организация);
	ВалютаСтр = Строка(ВалютаУправленческогоУчета);
	КоэффициентПересчетаИзВалютыУпрВРегл = КоэффициентПересчета(ВалютаУправленческогоУчета, ВалютаРегламентированногоУчета, Объект.Дата);
	
	СтрокаЗаголовка = "%1 (%2)";
	ЗаголовокЦена = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтрокаЗаголовка, НСтр("ru = 'Цена';
																									|en = 'Price'"), ВалютаСтр);
	ЗаголовокСумма = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтрокаЗаголовка, НСтр("ru = 'Сумма';
																									|en = 'Amount'"), ВалютаСтр);
	ЗаголовокНДС = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтрокаЗаголовка, НСтр("ru = 'НДС';
																								|en = 'VAT'"), ВалютаСтр);
	Элементы.РозничныеПродажиЦена.Заголовок = ЗаголовокЦена;
	Элементы.РозничныеПродажиСумма.Заголовок = ЗаголовокСумма;
	Элементы.РозничныеПродажиСуммаНДС.Заголовок = ЗаголовокНДС;
	
	ИспользуютсяКартыЛояльности = ПолучитьФункциональнуюОпцию("ИспользоватьКартыЛояльности");
		
	УстановитьЗаголовокЭтойФормы();
	ИмяТекущейТаблицыФормы = Элементы.РозничныеПродажи.Имя;
	
	ПриЧтенииСозданииНаСервере();
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПриЧтенииСозданииНаСервере();
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// Обработчик механизма "ДатыЗапретаИзменения"
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ПараметрыЗаписи.Вставить("ХозяйственнаяОперация", Объект.ХозяйственнаяОперация);
	Оповестить("Запись_ВводОстатков", ПараметрыЗаписи, Объект.Ссылка);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульПодключаемыеКомандыКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ПодключаемыеКомандыКлиент");
		МодульПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ПараметрыЗаполненияРеквизитов = Новый Структура;
	ПараметрыЗаполненияРеквизитов.Вставить("ЗаполнитьПризнакХарактеристикиИспользуются",
		Новый Структура("Номенклатура", "ХарактеристикиИспользуются"));
	ПараметрыЗаполненияРеквизитов.Вставить("ЗаполнитьПризнакАртикул",
		Новый Структура("Номенклатура", "Артикул"));
	НоменклатураСервер.ЗаполнитьСлужебныеРеквизитыПоНоменклатуреВКоллекции(Объект.РозничныеПродажи, ПараметрыЗаполненияРеквизитов);
	УстановитьЗаголовокЭтойФормы();
	
	ЗаполнитьСлужебныеРеквизитыПоНоменклатуре();
	СкладОбязателен = ПолучитьПризнакЗаполненияСклада(Объект.РозничныеПродажи);
	
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)

	Если ИсточникВыбора.ИмяФормы = "Обработка.ПодборТоваровВДокументПродажи.Форма.Форма" Тогда
		ОбработкаВыбораПодборНаСервере(ВыбранноеЗначение, КэшированныеЗначения);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_ВидКартыЛояльности" Тогда
		ПриЧтенииСозданииНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ОрганизацияПриИзмененииСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(
		Элемент.ТекстРедактирования, 
		ЭтотОбъект, 
		"Объект.Комментарий");
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	ДатаПриИзмененииНаСервере();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыРозничныеПродажи

&НаКлиенте
Процедура РозничныеПродажиНоменклатураПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы[ИмяТекущейТаблицыФормы].ТекущиеДанные;
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ЗаполнитьСтавкуНДС", ОбработкаТабличнойЧастиКлиентСервер.ПараметрыЗаполненияСтавкиНДС(Объект));
	СтруктураДействий.Вставить("ПроверитьХарактеристикуПоВладельцу", ТекущаяСтрока.Характеристика);
	СтруктураДействий.Вставить("ПроверитьЗаполнитьУпаковкуПоВладельцу", ТекущаяСтрока.Упаковка);
	СтруктураДействий.Вставить("ПересчитатьКоличествоЕдиниц");
	СтруктураДействий.Вставить("ЗаполнитьПризнакАртикул", Новый Структура("Номенклатура", "Артикул"));
	СтруктураДействий.Вставить("ЗаполнитьПризнакТипНоменклатуры", Новый Структура("Номенклатура", "ТипНоменклатуры"));
	СтруктураДействий.Вставить("ПриИзмененииТипаНоменклатуры", Новый Структура("ЕстьРаботы, ЕстьОтменено", Истина, Ложь));
	
	СтруктураДействий.Вставить("НоменклатураПриИзмененииПереопределяемый", Новый Структура("ИмяФормы, ИмяТабличнойЧасти",
		ИмяФормы, ИмяТекущейТаблицыФормы));
		
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	Если НЕ ЗначениеЗаполнено(ТекущаяСтрока.СтавкаНДС) Тогда
		ТекущаяСтрока.СтавкаНДС = СтавкаНДСНоменклатуры(ТекущаяСтрока.Номенклатура);
	КонецЕсли;
	УпаковкаПриИзменении();
	
	СкладОбязателен = ПолучитьПризнакЗаполненияСклада(Объект.РозничныеПродажи);
	
КонецПроцедуры

&НаКлиенте
Процедура РозничныеПродажиПриИзменении(Элемент)
	
	СкладОбязателен = ПолучитьПризнакЗаполненияСклада(Объект.РозничныеПродажи);
	
КонецПроцедуры

&НаКлиенте
Процедура РозничныеПродажиКоличествоПриИзменении(Элемент)

	ТекущаяСтрока = Элементы[ИмяТекущейТаблицыФормы].ТекущиеДанные;

	СтруктураДействий = Новый Структура;
	ДобавитьВСтруктуруДействияПриИзмененииКоличестваУпаковок(СтруктураДействий, ЭтаФорма);
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);

КонецПроцедуры

&НаКлиенте
Процедура РозничныеПродажиУпаковкаПриИзменении(Элемент)
	
	УпаковкаПриИзменении();
	
КонецПроцедуры

&НаКлиенте
Процедура РозничныеПродажиЦенаПриИзменении(Элемент)

	ТекущаяСтрока = Элементы[ИмяТекущейТаблицыФормы].ТекущиеДанные;

	СтруктураПересчетаСуммы = ОбработкаТабличнойЧастиКлиентСервер.ПараметрыПересчетаСуммыНДСВСтрокеТЧ(Объект);
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПересчитатьСуммуНДС", СтруктураПересчетаСуммы);
	СтруктураДействий.Вставить("ПересчитатьСумму");
	СтруктураДействий.Вставить("ПересчитатьСуммуБезНДС");
	СтруктураДействий.Вставить("ПересчитатьСуммуРегл", КоэффициентПересчетаИзВалютыУпрВРегл);
	СтруктураДействий.Вставить("ПересчитатьНДСРегл", СтруктураПересчетаСуммы);
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);

КонецПроцедуры

&НаКлиенте
Процедура РозничныеПродажиСуммаПриИзменении(Элемент)

	ТекущаяСтрока = Элементы[ИмяТекущейТаблицыФормы].ТекущиеДанные;

	СтруктураПересчетаСуммы = ОбработкаТабличнойЧастиКлиентСервер.ПараметрыПересчетаСуммыНДСВСтрокеТЧ(Объект);

	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПересчитатьСуммуНДС", СтруктураПересчетаСуммы);
	СтруктураДействий.Вставить("ПересчитатьЦенуПоСумме", "Количество");
	СтруктураДействий.Вставить("ПересчитатьСуммуБезНДС");
	СтруктураДействий.Вставить("ПересчитатьСуммуРегл", КоэффициентПересчетаИзВалютыУпрВРегл);
	СтруктураДействий.Вставить("ПересчитатьНДСРегл", СтруктураПересчетаСуммы);
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);

КонецПроцедуры

&НаКлиенте
Процедура РозничныеПродажиСтавкаНДСПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.РозничныеПродажи.ТекущиеДанные;

	СтруктураПересчетаСуммы = ОбработкаТабличнойЧастиКлиентСервер.ПараметрыПересчетаСуммыНДСВСтрокеТЧ(Объект);

	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПересчитатьСуммуНДС", СтруктураПересчетаСуммы);
	СтруктураДействий.Вставить("ПересчитатьСуммуБезНДС");
	СтруктураДействий.Вставить("ПересчитатьСуммуРегл", КоэффициентПересчетаИзВалютыУпрВРегл);
	СтруктураДействий.Вставить("ПересчитатьНДСРегл", СтруктураПересчетаСуммы);
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	
КонецПроцедуры

&НаКлиенте
Процедура РозничныеПродажиШтрихкодПриИзменении(Элемент)
	
	ШтрихКодПриИзменении(Элементы.РозничныеПродажи.ТекущиеДанные.ПолучитьИдентификатор())
	
КонецПроцедуры

&НаКлиенте
Процедура РозничныеПродажиМагнитныйКодПриИзменении(Элемент)
	
	МагнитныйКодПриИзменении(Элементы.РозничныеПродажи.ТекущиеДанные.ПолучитьИдентификатор());
	
КонецПроцедуры

&НаКлиенте
Процедура РозничныеПродажиВидКартыЛояльностиПриИзменении(Элемент)

	ВидКартыЛояльностиПриИзмененииСервер(Элементы.РозничныеПродажи.ТекущиеДанные.ПолучитьИдентификатор());
	
КонецПроцедуры

&НаКлиенте
Процедура РозничныеПродажиКартаЛояльностиПриИзменении(Элемент)
	
	КартаЛояльностиПриИзмененииСервер(Элементы.РозничныеПродажи.ТекущиеДанные.ПолучитьИдентификатор());
	
КонецПроцедуры

&НаКлиенте
Процедура РозничныеПродажиКартаЛояльностиНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	МассивПараметров = Новый Массив;
	Если ЗначениеЗаполнено(Элементы.РозничныеПродажи.ТекущиеДанные.ВидКартыЛояльности) Тогда
		МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.Владелец", Элементы.РозничныеПродажи.ТекущиеДанные.ВидКартыЛояльности));
		ПараметрыВыбора = Новый ФиксированныйМассив(МассивПараметров);
		Элементы.РозничныеПродажиКартаЛояльности.ПараметрыВыбора = ПараметрыВыбора;
	Иначе
		ПараметрыВыбора = Новый ФиксированныйМассив(МассивПараметров);
		Элементы.РозничныеПродажиКартаЛояльности.ПараметрыВыбора = ПараметрыВыбора;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Объект);
КонецПроцедуры


&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры


&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура ОткрытьПодбор(Команда)
	
	// &ЗамерПроизводительности
	ОценкаПроизводительностиКлиент.ЗамерВремени("Документ.ВводОстатковОПродажахЗаПрошлыеПериоды.ФормаРозничныеПродажи.Команда.ОткрытьПодбор", Истина);
	
	ПараметрЗаголовок = НСтр("ru = 'Подбор товаров в %Документ%';
							|en = 'Pick goods in %Документ%'");
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПараметрЗаголовок = СтрЗаменить(ПараметрЗаголовок, "%Документ%", Объект.Ссылка);
	Иначе
		ПараметрЗаголовок = СтрЗаменить(ПараметрЗаголовок, "%Документ%", НСтр("ru = 'ввод остатков';
																				|en = 'balance entry'"));
	КонецЕсли;

	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Соглашение",		Объект.СоглашениеСКлиентом);
	ПараметрыФормы.Вставить("Валюта",			Объект.Валюта);
	ПараметрыФормы.Вставить("ЦенаВключаетНДС",	Объект.ЦенаВключаетНДС);
	ПараметрыФормы.Вставить("РежимПодбораБезСуммовыхПараметров", Ложь);
	ПараметрыФормы.Вставить("РежимПодбораИспользоватьСкладыВТабличнойЧасти", Ложь);
	ПараметрыФормы.Вставить("СкрыватьРучныеСкидки", Истина);
	ПараметрыФормы.Вставить("ИспользоватьДатыОтгрузки", Ложь);
	ПараметрыФормы.Вставить("СкрыватьКомандуЦеныНоменклатуры", Истина);
	ПараметрыФормы.Вставить("СкрыватьКомандуОстаткиНаСкладах", Истина);
	ПараметрыФормы.Вставить("ПоказыватьПодобранныеТовары", Истина);
	ПараметрыФормы.Вставить("ЗапрашиватьКоличество", Истина);
	ПараметрыФормы.Вставить("Заголовок", ПараметрЗаголовок);
	ПараметрыФормы.Вставить("Дата",      Объект.Дата);
	ПараметрыФормы.Вставить("Документ",  Объект.Ссылка);
	ПараметрыФормы.Вставить("БезОтбораПоВключениюНДСВЦену", Истина);

	ОткрытьФорму("Обработка.ПодборТоваровВДокументПродажи.Форма", ПараметрыФормы, ЭтаФорма, УникальныйИдентификатор);

КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьИзВнешнегоФайла(Команда)
	
	ПараметрыЗагрузки = РаботаСТабличнымиЧастямиКлиент.ПараметрыЗагрузкиНоменклатуры();
	ПараметрыЗагрузки.Организация = Объект.Организация;
	ПараметрыЗагрузки.ЗагружатьЦены = Истина;
	ПараметрыЗагрузки.ЦенаВключаетНДС    = Объект.ЦенаВключаетНДС;
	ПараметрыЗагрузки.НалогообложениеНДС = Объект.НалогообложениеНДС;
	ПараметрыЗагрузки.ДатаЗаполнения     = Объект.Дата;
	
	Оповещение = Новый ОписаниеОповещения("ЗагрузитьИзВнешнегоФайлаЗавершение", ЭтотОбъект);
	РаботаСТабличнымиЧастямиКлиент.ПоказатьФормуЗагрузкиНоменклатуры(ПараметрыЗагрузки, Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьИзВнешнегоФайлаЗавершение(АдресЗагруженныхДанных, ДополнительныеПараметры) Экспорт
	
	Если ЗначениеЗаполнено(АдресЗагруженныхДанных) Тогда
		ПолучитьЗагруженныеТоварыИзХранилища(АдресЗагруженныхДанных, КэшированныеЗначения);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьЗаголовокЭтойФормы()
	
	АвтоЗаголовок = Ложь;
	
	Заголовок = ВводОстатковВызовСервера.ЗаголовокДокументаВводОстатковПоХозяйственнойОперации(Объект.Ссылка,
		Объект.Номер,
		Объект.Дата,
		Объект.ХозяйственнаяОперация);
	
КонецПроцедуры


&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//
	
	НоменклатураСервер.УстановитьУсловноеОформлениеХарактеристикНоменклатуры(ЭтаФорма, 
																			 "РозничныеПродажиХарактеристика",
																			 "Объект.РозничныеПродажи.ХарактеристикиИспользуются");
	
	//
	
	НоменклатураСервер.УстановитьУсловноеОформлениеЕдиницИзмерения(ЭтаФорма, 
																   "РозничныеПродажиНоменклатураЕдиницаИзмерения",
																   "Объект.РозничныеПродажи.Упаковка");
	
	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.РозничныеПродажиУпаковка.Имя);
	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);

	//
	
	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Подразделение.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.ХозяйственнаяОперация");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.ХозяйственныеОперации.ВводОстатковРозничныхПродажЗаПрошлыеПериоды;
	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);
	
	ОбщегоНазначенияУТ.УстановитьСнятьОтметкуНезаполненного(
		УсловноеОформление, "Склад", "Объект.Склад", "СкладОбязателен");
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ДобавитьВСтруктуруДействияПриИзмененииКоличестваУпаковок(СтруктураДействий, Форма)

	СтруктураПересчетаСуммы = ОбработкаТабличнойЧастиКлиентСервер.ПараметрыПересчетаСуммыНДСВСтрокеТЧ(Форма.Объект);

	СтруктураДействий.Вставить("ПересчитатьКоличествоЕдиниц");
	СтруктураДействий.Вставить("ПересчитатьСуммуНДС", СтруктураПересчетаСуммы);
	СтруктураДействий.Вставить("ПересчитатьСумму");
	СтруктураДействий.Вставить("ПересчитатьСуммуБезНДС");
	СтруктураДействий.Вставить("ПересчитатьСуммуРегл", Форма.КоэффициентПересчетаИзВалютыУпрВРегл);
	СтруктураДействий.Вставить("ПересчитатьНДСРегл", СтруктураПересчетаСуммы);

КонецПроцедуры

&НаСервере
Процедура ПолучитьЗагруженныеТоварыИзХранилища(АдресТоваровВХранилище, КэшированныеЗначения)
	
	ТоварыИзХранилища = ПолучитьИзВременногоХранилища(АдресТоваровВХранилище);
	
	СтруктураДействий = Новый Структура;
	ДобавитьВСтруктуруДействияПриИзмененииКоличестваУпаковок(СтруктураДействий, ЭтаФорма);

	Для Каждого СтрокаТоваров Из ТоварыИзХранилища Цикл
		СтрокаТЧТовары = Объект.РозничныеПродажи.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаТЧТовары, СтрокаТоваров);
		СтрокаТЧТовары.СуммаНДС = 0;
		ОбработкаТабличнойЧастиСервер.ОбработатьСтрокуТЧ(СтрокаТЧТовары, СтруктураДействий, КэшированныеЗначения);
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаВыбораПодборНаСервере(ВыбранноеЗначение, КэшированныеЗначения)
	
	ТаблицаТоваров = ПолучитьИзВременногоХранилища(ВыбранноеЗначение.АдресТоваровВХранилище);
	
	СтруктураДействий = Новый Структура;
	ДобавитьВСтруктуруДействияПриИзмененииКоличестваУпаковок(СтруктураДействий, ЭтаФорма);
	
	Для Каждого СтрокаТовара Из ТаблицаТоваров Цикл
		ТекущаяСтрока = Объект.РозничныеПродажи.Добавить();
		ЗаполнитьЗначенияСвойств(ТекущаяСтрока, СтрокаТовара, "Номенклатура, Характеристика, Упаковка, КоличествоУпаковок, Цена");
		ТекущаяСтрока.СтавкаНДС = СтавкаНДСНоменклатуры(ТекущаяСтрока.Номенклатура);

		ОбработкаТабличнойЧастиСервер.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	КонецЦикла;
	
	ПараметрыЗаполненияРеквизитов = Новый Структура;
	ПараметрыЗаполненияРеквизитов.Вставить("ЗаполнитьПризнакХарактеристикиИспользуются",
											Новый Структура("Номенклатура", "ХарактеристикиИспользуются"));
	ПараметрыЗаполненияРеквизитов.Вставить("ЗаполнитьПризнакАртикул",
											Новый Структура("Номенклатура", "Артикул"));
											
	НоменклатураСервер.ЗаполнитьСлужебныеРеквизитыПоНоменклатуреВКоллекции(Объект.РозничныеПродажи,ПараметрыЗаполненияРеквизитов);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция КоэффициентПересчета(ВалютаУправленческогоУчета, ВалютаРегламентированногоУчета, ДатаДокумента)
	
	Возврат РаботаСКурсамиВалютУТ.ПолучитьКоэффициентПересчетаИзВалютыВВалюту(
											ВалютаУправленческогоУчета,
											ВалютаРегламентированногоУчета,
											?(ДатаДокумента = Дата(1,1,1), ТекущаяДатаСеанса(), ДатаДокумента));
	
КонецФункции

&НаКлиенте
Процедура УпаковкаПриИзменении()

	ТекущаяСтрока = Элементы[ИмяТекущейТаблицыФормы].ТекущиеДанные;

	СтруктураПересчетаСуммы = ОбработкаТабличнойЧастиКлиентСервер.ПараметрыПересчетаСуммыНДСВСтрокеТЧ(Объект);

	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПересчитатьКоличествоЕдиниц");

	Если ТекущаяСтрока.Количество > 0 Тогда
		СтруктураДействий.Вставить("ПересчитатьЦенуЗаУпаковку", ТекущаяСтрока.Количество);
	КонецЕсли;

	СтруктураДействий.Вставить("ПересчитатьСумму");
	СтруктураДействий.Вставить("ПересчитатьСуммуНДС", СтруктураПересчетаСуммы);
	СтруктураДействий.Вставить("ПересчитатьСуммуБезНДС");
	СтруктураДействий.Вставить("ПересчитатьСуммуРегл", КоэффициентПересчетаИзВалютыУпрВРегл);
	СтруктураДействий.Вставить("ПересчитатьНДСРегл", СтруктураПересчетаСуммы);
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);

КонецПроцедуры

&НаСервереБезКонтекста
Функция СтавкаНДСНоменклатуры(Номенклатура)

	Возврат ОбщегоНазначенияУТ.ЗначенияРеквизитовОбъектаПоУмолчанию(Номенклатура, "СтавкаНДС").СтавкаНДС;

КонецФункции

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()
	
	ПараметрыЗаполненияРеквизитов = Новый Структура;
	ПараметрыЗаполненияРеквизитов.Вставить("ЗаполнитьПризнакХарактеристикиИспользуются",
											Новый Структура("Номенклатура", "ХарактеристикиИспользуются"));
	ПараметрыЗаполненияРеквизитов.Вставить("ЗаполнитьПризнакАртикул",
											Новый Структура("Номенклатура", "Артикул"));
	
	НоменклатураСервер.ЗаполнитьСлужебныеРеквизитыПоНоменклатуреВКоллекции(Объект.РозничныеПродажи,ПараметрыЗаполненияРеквизитов);
	
	ЗаполнитьСлужебныеРеквизитыПоНоменклатуре();
	СкладОбязателен = ПолучитьПризнакЗаполненияСклада(Объект.РозничныеПродажи);
	
	ПолучитьДанныеОВидахКартЛояльности();
	УстановитьВидимость();
	УстановитьУсловноеОформление();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСлужебныеРеквизитыПоНоменклатуре()
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ЗаполнитьПризнакАртикул", Новый Структура("Номенклатура", "Артикул"));
	СтруктураДействий.Вставить("ЗаполнитьПризнакТипНоменклатуры", Новый Структура("Номенклатура", "ТипНоменклатуры"));
	СтруктураДействий.Вставить("ПриИзмененииТипаНоменклатуры", Новый Структура("ЕстьРаботы, ЕстьОтменено", Истина, Ложь));
	
	ОбработкаТабличнойЧастиСервер.ОбработатьТЧ(Объект.РозничныеПродажи, СтруктураДействий, Новый Структура);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ПолучитьПризнакЗаполненияСклада(ТаблицаПродаж)
	
	Возврат ?(ТаблицаПродаж.Итог("СкладОбязателен") = 0, 0, 1);
	
КонецФункции

&НаСервере
Процедура ПолучитьДанныеОВидахКартЛояльности()
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	ВидыКарт.Ссылка
	|ИЗ
	|	Справочник.ВидыКартЛояльности КАК ВидыКарт
	|ГДЕ
	|	ВидыКарт.ТипКарты = ЗНАЧЕНИЕ(Перечисление.ТипыКарт.Магнитная)
	|
	|;
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	ВидыКарт.Ссылка
	|ИЗ
	|	Справочник.ВидыКартЛояльности КАК ВидыКарт
	|ГДЕ
	|	ВидыКарт.ТипКарты = ЗНАЧЕНИЕ(Перечисление.ТипыКарт.Штриховая)
	|
	|;
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	ВидыКарт.Ссылка
	|ИЗ
	|	Справочник.ВидыКартЛояльности КАК ВидыКарт
	|ГДЕ
	|	ВидыКарт.ТипКарты = ЗНАЧЕНИЕ(Перечисление.ТипыКарт.Смешанная)
	|");
	
	Результат = Запрос.ВыполнитьПакет();
	ВведеныМагнитныеВидыКарт = НЕ Результат[0].Пустой();
	ВведеныШтриховыеВидыКарт = НЕ Результат[1].Пустой();
	ВведеныСмешанныеВидыКарт = НЕ Результат[2].Пустой();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимость()
	
	Элементы.РозничныеПродажиШтрихкод.Видимость = ИспользуютсяКартыЛояльности 
																И (ВведеныШтриховыеВидыКарт ИЛИ ВведеныСмешанныеВидыКарт);
	Элементы.РозничныеПродажиМагнитныйКод.Видимость = ИспользуютсяКартыЛояльности
																	И (ВведеныМагнитныеВидыКарт ИЛИ ВведеныСмешанныеВидыКарт);
	Элементы.РозничныеПродажиВидКартыЛояльности.Видимость = ИспользуютсяКартыЛояльности
	
КонецПроцедуры

&НаСервере
Процедура ШтрихКодПриИзменении(Идентификатор)
	
	ТекущаяСтрока = Объект.РозничныеПродажи.НайтиПоИдентификатору(Идентификатор);
	ТипКода = Перечисления.ТипыКодовКарт.Штрихкод;
	Счетчик = 0;
	
	Если ТекущаяСтрока.ШтрихКод <> "" Тогда
		
		КартыЛояльностиШтриховые = КартыЛояльностиСервер.НайтиКартыЛояльности(ТекущаяСтрока.ШтрихКод, ТипКода);
		
		Для Каждого СтрокаТабличнойЧасти Из КартыЛояльностиШтриховые.ЗарегистрированныеКартыЛояльности Цикл
		
			Если ЗначениеЗаполнено(ТекущаяСтрока.ВидКартыЛояльности) Тогда
				Если ТекущаяСтрока.ВидКартыЛояльности = СтрокаТабличнойЧасти.ВидКарты Тогда
					НайденнаяКарта = СтрокаТабличнойЧасти.Ссылка;
					НайденныйВидКарты = СтрокаТабличнойЧасти.ВидКарты;
					МагнитныйКод = СтрокаТабличнойЧасти.МагнитныйКод;
					Счетчик = Счетчик + 1;
				КонецЕсли;
			Иначе
				НайденнаяКарта = СтрокаТабличнойЧасти.Ссылка;
				НайденныйВидКарты = СтрокаТабличнойЧасти.ВидКарты;
				МагнитныйКод = СтрокаТабличнойЧасти.МагнитныйКод;
				Счетчик = Счетчик + 1;
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
	Если Счетчик = 1 Тогда
		ТекущаяСтрока.КартаЛояльности = НайденнаяКарта;
		ТекущаяСтрока.ВидКартыЛояльности = НайденныйВидКарты;
		ТекущаяСтрока.МагнитныйКод = МагнитныйКод;
	Иначе 
		Если ТекущаяСтрока.ШтрихКод <> "" И НЕ ЗначениеЗаполнено(ТекущаяСтрока.ВидКартыЛояльности) Тогда
			ВидыКарт = КартыЛояльностиСервер.ПолучитьВозможныеВидыКартыЛояльностиПоКодуКарты(ТекущаяСтрока.ШтрихКод, ТипКода);
			Если ВидыКарт.Количество() = 1 Тогда
				ТекущаяСтрока.ВидКартыЛояльности = ВидыКарт[0];
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура МагнитныйКодПриИзменении(Идентификатор)
	
	ТекущаяСтрока = Объект.РозничныеПродажи.НайтиПоИдентификатору(Идентификатор);
	ТипКода = Перечисления.ТипыКодовКарт.МагнитныйКод;
	Счетчик = 0;
	
	Если ТекущаяСтрока.МагнитныйКод <> "" Тогда
		КартыЛояльностиМагнитные = КартыЛояльностиСервер.НайтиКартыЛояльности(ТекущаяСтрока.МагнитныйКод, ТипКода);
		Для Каждого СтрокаТЧ Из КартыЛояльностиМагнитные.ЗарегистрированныеКартыЛояльности Цикл
			Если ЗначениеЗаполнено(ТекущаяСтрока.ВидКартыЛояльности) Тогда
				Если ТекущаяСтрока.ВидКартыЛояльности = СтрокаТЧ.ВидКарты Тогда
					НайденнаяКарта = СтрокаТЧ.Ссылка;
					НайденныйВидКарты = СтрокаТЧ.ВидКарты;
					Штрихкод = СтрокаТЧ.ШтрихКод;
					Счетчик = Счетчик + 1;
				КонецЕсли;
			Иначе
				НайденнаяКарта = СтрокаТЧ.Ссылка;
				НайденныйВидКарты = СтрокаТЧ.ВидКарты;
				Штрихкод = СтрокаТЧ.ШтрихКод;
				Счетчик = Счетчик + 1;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Если Счетчик = 1 Тогда
		ТекущаяСтрока.КартаЛояльности = НайденнаяКарта;
		ТекущаяСтрока.ВидКартыЛояльности = НайденныйВидКарты;
		ТекущаяСтрока.ШтрихКод = ШтрихКод;
	Иначе
		Если ТекущаяСтрока.МагнитныйКод <> "" И НЕ ЗначениеЗаполнено(ТекущаяСтрока.ВидКартыЛояльности) Тогда
			ВидыКарт = КартыЛояльностиСервер.ПолучитьВозможныеВидыКартыЛояльностиПоКодуКарты(ТекущаяСтрока.МагнитныйКод, ТипКода);
			Если ВидыКарт.Количество() = 1 Тогда
				ТекущаяСтрока.ВидКартыЛояльности = ВидыКарт[0];
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ВидКартыЛояльностиПриИзмененииСервер(Идентификатор)
	
	УстановитьПривилегированныйРежим(Истина);
	ТекущаяСтрока = Объект.РозничныеПродажи.НайтиПоИдентификатору(Идентификатор);
	
	МагнитныйКод = СокрЛП(ТекущаяСтрока.МагнитныйКод);
	Штрихкод = СокрЛП(ТекущаяСтрока.Штрихкод);
	
	Счетчик = 0;
	НайденнаяКарта = Неопределено;
	
	Если МагнитныйКод <> "" Тогда
		КартыЛояльностиМагнитные = КартыЛояльностиСервер.НайтиКартыЛояльности(МагнитныйКод, Перечисления.ТипыКодовКарт.МагнитныйКод);
		Для Каждого СтрокаТЧ Из КартыЛояльностиМагнитные.ЗарегистрированныеКартыЛояльности Цикл
			НайденнаяКарта = СтрокаТЧ.Ссылка;
			Счетчик = Счетчик + 1;
		КонецЦикла;
	КонецЕсли;
	
	Если Штрихкод <> "" Тогда
		КартыЛояльностиШтриховые = КартыЛояльностиСервер.НайтиКартыЛояльности(Штрихкод, Перечисления.ТипыКодовКарт.Штрихкод);
		Для Каждого СтрокаТЧ Из КартыЛояльностиШтриховые.ЗарегистрированныеКартыЛояльности Цикл
			НайденнаяКарта = СтрокаТЧ.Ссылка;
			Счетчик = Счетчик + 1;
		КонецЦикла;
	КонецЕсли;
	
	Если Счетчик = 1 Тогда
		ТекущаяСтрока.КартаЛояльности = НайденнаяКарта;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура КартаЛояльностиПриИзмененииСервер(Идентификатор)
	
	ТекущаяСтрока = Объект.РозничныеПродажи.НайтиПоИдентификатору(Идентификатор);
	
	Запрос = Новый Запрос("
		|ВЫБРАТЬ
		|	КартыЛояльности.Владелец КАК ВидКартыЛояльности,
		|	КартыЛояльности.Штрихкод,
		|	КартыЛояльности.МагнитныйКод
		|ИЗ
		|	Справочник.КартыЛояльности КАК КартыЛояльности
		|ГДЕ
		|	КартыЛояльности.Ссылка = &Ссылка
		|");
	
	Запрос.УстановитьПараметр("Ссылка", ТекущаяСтрока.КартаЛояльности);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		ЗаполнитьЗначенияСвойств(ТекущаяСтрока, Выборка);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОрганизацияПриИзмененииСервер()
	
	ВалютаРегламентированногоУчета = ЗначениеНастроекПовтИсп.ВалютаРегламентированногоУчетаОрганизации(Объект.Организация);
	Объект.Валюта = ВалютаРегламентированногоУчета;
	
	Если ЗначениеЗаполнено(Объект.Организация) Тогда
		ЗаполнитьНалогообложениеНДС();
		НалогообложениеНДСПриИзмененииСервер();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ДатаПриИзмененииНаСервере()
	
	ЗаполнитьНалогообложениеНДС();
	НалогообложениеНДСПриИзмененииСервер();
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если ИспользуютсяКартыЛояльности Тогда
		Ошибки = Неопределено;
		Для Каждого Стр Из Объект.РозничныеПродажи Цикл
			ВидКартыЛояльностиТипКарты = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Стр.ВидКартыЛояльности, "ТипКарты");
			
			Если ВидКартыЛояльностиТипКарты = Перечисления.ТипыКарт.Штриховая И НЕ ЗначениеЗаполнено(Стр.ШтрихКод) Тогда
				Группа = "ШтрихКоды";
				Текст = Нстр("ru = 'Штрихкод для данного вида карт лояльности обязателен к заполнению';
							|en = 'Barcode for this loyalty card kind is required.'");
				ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки,
																						"Объект.РозничныеПродажи[%1].ШтрихКод",
																						Текст, ""
																						,
																						Стр.НомерСтроки - 1,
																						Текст);
			ИначеЕсли ВидКартыЛояльностиТипКарты = Перечисления.ТипыКарт.Магнитная И НЕ ЗначениеЗаполнено(Стр.МагнитныйКод) Тогда
				Группа = "МагнитныеКоды";
				Текст = Нстр("ru = 'Магнитный код для данного вида карт лояльности обязателен к заполнению';
							|en = 'Magnetic code for this loyalty card kind should be populated.'");
				ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки,
																						"Объект.РозничныеПродажи[%1].МагнитныйКод",
																						Текст, ""
																						,
																						Стр.НомерСтроки - 1,
																						Текст);
			ИначеЕсли ВидКартыЛояльностиТипКарты = Перечисления.ТипыКарт.Смешанная Тогда 
				Группа = "СмешанныеКоды";
				Если НЕ ЗначениеЗаполнено(Стр.ШтрихКод) Тогда
					Текст = Нстр("ru = 'Штрихкод для данного вида карт лояльности обязателен к заполнению';
								|en = 'Barcode for this loyalty card kind is required.'");
					ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки,
																							"Объект.РозничныеПродажи[%1].ШтрихКод",
																							Текст, ""
																							,
																							Стр.НомерСтроки - 1,
																							Текст);
				КонецЕсли;
				Если НЕ ЗначениеЗаполнено(Стр.МагнитныйКод) Тогда
					Текст = Нстр("ru = 'Магнитный код для данного вида карт лояльности обязателен к заполнению';
								|en = 'Magnetic code for this loyalty card kind should be populated.'");
					ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки,
																							"Объект.РозничныеПродажи[%1].МагнитныйКод",
																							Текст, ""
																							,
																							Стр.НомерСтроки - 1,
																							Текст);
				КонецЕсли;
			КонецЕсли
		КонецЦикла;
		
		ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки, Отказ);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура НалогообложениеНДСПриИзмененииСервер()
	
	СтруктураПересчетаСуммы = ОбработкаТабличнойЧастиКлиентСервер.ПараметрыПересчетаСуммыНДСВТЧ(Объект);
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ЗаполнитьСтавкуНДС", ОбработкаТабличнойЧастиКлиентСервер.ПараметрыЗаполненияСтавкиНДС(Объект));
	СтруктураДействий.Вставить("ПересчитатьСуммуНДС", СтруктураПересчетаСуммы);
	СтруктураДействий.Вставить("ПересчитатьСуммуБезНДС");
	СтруктураДействий.Вставить("ПересчитатьСуммуРегл", КоэффициентПересчетаИзВалютыУпрВРегл);
	СтруктураДействий.Вставить("ПересчитатьНДСРегл", СтруктураПересчетаСуммы);
	
	ОбработкаТабличнойЧастиСервер.ОбработатьТЧ(Объект.РозничныеПродажи, СтруктураДействий, Неопределено);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНалогообложениеНДС()
	
	ПараметрыУчетаПоОрганизации = УчетНДСУП.ПараметрыУчетаПоОрганизации(Объект.Организация, Объект.Дата);
	Объект.НалогообложениеНДС = ПараметрыУчетаПоОрганизации.ОсновноеНалогообложениеНДСПродажи;
	
КонецПроцедуры

#КонецОбласти
