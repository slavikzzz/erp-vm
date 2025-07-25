
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ПриЧтенииСозданииНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПриЧтенииСозданииНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ТекущийОбъект.Цех = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ТекущийОбъект.МаршрутнаяКарта, "Цех");
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	УправлениеДаннымиОбИзделияхКлиент.ОповеститьОЗаписиОсновнойМаршрутнойКарты(Запись);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура МаршрутнаяКартаПриИзменении(Элемент)
	
	Если ХарактеристикиИспользуются Тогда
		ОбновитьНастройкуХарактеристики();
		УправлениеДоступностью(ЭтаФорма);
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура СпособУказанияХарактеристикиПриИзменении(Элемент)
	
	Если СпособУказанияХарактеристики = 0 Тогда
		Запись.Характеристика = Неопределено;
	КонецЕсли; 
	
	УправлениеДоступностью(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Характеристика.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СпособУказанияХарактеристики");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеРавно;
	ОтборЭлемента.ПравоеЗначение = 1;

	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);

КонецПроцедуры

#Область Прочее

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()

	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПроверитьХарактеристикуПоВладельцу", Запись.Характеристика);

	СтруктураСтроки = Новый Структура;
	СтруктураСтроки.Вставить("Номенклатура",   Запись.Номенклатура);
	СтруктураСтроки.Вставить("Характеристика", Запись.Характеристика);
	СтруктураСтроки.Вставить("ХарактеристикиИспользуются", ХарактеристикиИспользуются);
	
	ОбработкаТабличнойЧастиСервер.ОбработатьСтрокуТЧ(СтруктураСтроки, СтруктураДействий, Неопределено);

	ЗаполнитьЗначенияСвойств(Запись, СтруктураСтроки);
	
	ХарактеристикиИспользуются = СтруктураСтроки.ХарактеристикиИспользуются;
	Элементы.Характеристика.Доступность = ХарактеристикиИспользуются;
	
	Если НЕ ХарактеристикиИспользуются Тогда
		Элементы.ГруппаСтраницыНастройкиХарактеристики.ТекущаяСтраница = Элементы.ГруппаСтраницаХарактеристикиНеИспользуются;
	КонецЕсли; 
	
	ОбновитьНастройкуХарактеристики();
	
	Если НЕ Запись.Характеристика.Пустая() Тогда
		СпособУказанияХарактеристики = 1;
	КонецЕсли;

	УправлениеДоступностью(ЭтаФорма);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеДоступностью(Форма)

	Форма.Элементы.Характеристика.ТолькоПросмотр = (Форма.СпособУказанияХарактеристики <> 1);

КонецПроцедуры

&НаСервере
Процедура ОбновитьНастройкуХарактеристики()

	Если НЕ ХарактеристикиИспользуются Тогда
		Возврат;
	КонецЕсли;
	
	Если Запись.МаршрутнаяКарта.Пустая() Тогда
		Элементы.ГруппаНастройка.ТекущаяСтраница = Элементы.ГруппаСтраницаМаршрутнаяКартаНеВыбрана;
		Возврат;
	КонецЕсли; 
	
	Элементы.ГруппаНастройка.ТекущаяСтраница = Элементы.ГруппаСтраницаМаршрутнаяКартаВыбрана;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ВыходныеИзделия.Характеристика,
	               |	ВыходныеИзделия.Ссылка.НачалоДействия КАК НачалоДействия,
	               |	ВыходныеИзделия.Ссылка.КонецДействия КАК КонецДействия
	               |ИЗ
	               |	Справочник.МаршрутныеКарты.ВыходныеИзделия КАК ВыходныеИзделия
	               |ГДЕ
	               |	ВыходныеИзделия.Ссылка = &Объект
	               |	И ВыходныеИзделия.Номенклатура = &Номенклатура
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	ВыходныеИзделия.НомерСтроки";
	
	Запрос.УстановитьПараметр("Объект",       Запись.МаршрутнаяКарта);
	Запрос.УстановитьПараметр("Номенклатура", Запись.Номенклатура);
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	Выборка = Результат.Выбрать();
	
	Выборка.Следующий();
	
	Если Выборка.Характеристика.Пустая() Тогда
		Элементы.ГруппаСтраницыНастройкиХарактеристики.ТекущаяСтраница = Элементы.ГруппаСтраницаХарактеристикаНастраивается;
	Иначе
		Запись.Характеристика = Выборка.Характеристика;
		Элементы.ГруппаСтраницыНастройкиХарактеристики.ТекущаяСтраница = Элементы.ГруппаСтраницаХарактеристикаУказанаВМаршрутнойКарте;
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
