
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ПредставлениеПроизвольногоРемонта = НСтр("ru = '<произвольный ремонт>';
											|en = '<any R&M>'");
	
	Если Параметры.Свойство("ОбъектЭксплуатации") Тогда
		
		ОбъектЭксплуатации = Параметры.ОбъектЭксплуатации;
		
	Иначе
		
		Отказ = Истина;
		
	КонецЕсли;
	
	ЗаполнитьДеревоРемонтов();

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если Не ЗавершениеРаботы И Модифицированность Тогда
		
		Отказ = Истина;
		
		ПоказатьВопрос(
			Новый ОписаниеОповещения("ПеренестиРемонтыВДокумент", ЭтаФорма),
			НСтр("ru = 'Данные были изменены. Перенести изменения в документ?';
				|en = 'The data was modified. Migrate the changes to the document?'"),
			РежимДиалогаВопрос.ДаНетОтмена);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПеренестиВДокумент(Команда)
	
	ПеренестиРемонтыВДокумент();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьСтроки(Команда)
	ОтметитьЭлементыПоСтрокамДерева(Истина);
КонецПроцедуры

&НаКлиенте
Процедура ИсключитьСтроки(Команда)
	ОтметитьЭлементыПоСтрокамДерева(Ложь);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоРемонтовОтмечен.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоРемонтов.ЭтоСтрокаВидаРемонта");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;

	Элемент.Оформление.УстановитьЗначениеПараметра("Отображать", Ложь);

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоРемонтовПредставление.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоРемонтов.ЭтоСтрокаВидаРемонта");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоРемонтов.ВидРемонта");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", Новый ПолеКомпоновкиДанных("ПредставлениеПроизвольногоРемонта"));

КонецПроцедуры

&НаКлиенте
Процедура ПеренестиРемонтыВДокумент(Знач Результат=Неопределено, ДополнительныеПараметры=Неопределено) Экспорт
	
	Если Результат = Неопределено Тогда
		Результат = КодВозвратаДиалога.Да;
	КонецЕсли;
	
	Если Результат = КодВозвратаДиалога.Нет Тогда
		Модифицированность = Ложь;
		Закрыть();
	КонецЕсли;
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		
		// Снятие модифицированности, т.к. перед закрытием признак проверяется.
		Модифицированность = Ложь;
		
		ПараметрыОповещения = ПараметрыОповещенияФормыДокумента();
		
		Закрыть();
		
		ОповеститьОВыборе(ПараметрыОповещения);
		
	КонецЕсли;
	
КонецПроцедуры

// Формирует дерево ремонтов
//
&НаСервере
Процедура ЗаполнитьДеревоРемонтов()
	
	ДеревоРемонтов.ПолучитьЭлементы().Очистить();
	
	Если ЗначениеЗаполнено(ОбъектЭксплуатации) Тогда
		
		Запрос = Новый Запрос(
			"ВЫБРАТЬ
			|	ВЫРАЗИТЬ(ДанныеЗаполнения.Узел КАК Справочник.УзлыОбъектовЭксплуатации) КАК Узел,
			|	ВЫРАЗИТЬ(ДанныеЗаполнения.ВидРемонта КАК Справочник.ВидыРемонтов) КАК ВидРемонта,
			|	ВЫРАЗИТЬ(ДанныеЗаполнения.СтатьяРасходов КАК ПланВидовХарактеристик.СтатьиРасходов) КАК СтатьяРасходов,
			|	ВЫРАЗИТЬ(ДанныеЗаполнения.КодРемонта КАК ЧИСЛО(10, 0)) КАК КодРемонта
			|ПОМЕСТИТЬ ДанныеТаблицы
			|ИЗ
			|	&ДанныеЗаполнения КАК ДанныеЗаполнения
			|
			|ИНДЕКСИРОВАТЬ ПО
			|	Узел,
			|	ВидРемонта
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	ДанныеЗаполнения.Узел,
			|	ДанныеЗаполнения.ВидРемонта,
			|	МАКСИМУМ(ДанныеЗаполнения.СтатьяРасходов) КАК СтатьяРасходов,
			|	МАКСИМУМ(ДанныеЗаполнения.КодРемонта) КАК КодРемонта
			|ПОМЕСТИТЬ ДанныеЗаполнения
			|ИЗ
			|	ДанныеТаблицы КАК ДанныеЗаполнения
			|
			|СГРУППИРОВАТЬ ПО
			|	ДанныеЗаполнения.Узел,
			|	ДанныеЗаполнения.ВидРемонта
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	Узлы.Родитель КАК Родитель,
			|	Узлы.Ссылка КАК Узел,
			|	Узлы.Класс КАК Класс
			|ПОМЕСТИТЬ Узлы
			|ИЗ
			|	Справочник.УзлыОбъектовЭксплуатации КАК Узлы
			|ГДЕ
			|	Узлы.Владелец = &ОбъектЭксплуатации
			|	И НЕ Узлы.ПометкаУдаления
			|	И Узлы.Статус В (ЗНАЧЕНИЕ(Перечисление.СтатусыОбъектовЭксплуатации.ВЭксплуатации))
			|
			|ИНДЕКСИРОВАТЬ ПО
			|	Узел,
			|	Класс
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	Узлы.Родитель КАК Родитель,
			|	Узлы.Узел КАК Узел,
			|	ВидыРемонтов.Владелец КАК Класс,
			|	ВидыРемонтов.Ссылка КАК ВидРемонта
			|ПОМЕСТИТЬ РемонтыУзлов
			|ИЗ
			|	Узлы КАК Узлы
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ВидыРемонтов КАК ВидыРемонтов
			|		ПО Узлы.Класс = ВидыРемонтов.Владелец
			|			И (НЕ ВидыРемонтов.ПометкаУдаления)
			|
			|ОБЪЕДИНИТЬ ВСЕ
			|
			|ВЫБРАТЬ
			|	Узлы.Родитель,
			|	Узлы.Узел,
			|	Узлы.Класс,
			|	ЗНАЧЕНИЕ(Справочник.ВидыРемонтов.ПустаяСсылка)
			|ИЗ
			|	Узлы КАК Узлы
			|
			|ИНДЕКСИРОВАТЬ ПО
			|	Класс,
			|	ВидРемонта
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	РемонтыУзлов.Родитель КАК Родитель,
			|	РемонтыУзлов.Узел КАК Узел,
			|	РемонтыУзлов.Класс КАК Класс,
			|	РемонтыУзлов.ВидРемонта КАК ВидРемонта,
			|	ВЫБОР
			|		КОГДА ДанныеЗаполнения.Узел ЕСТЬ NULL 
			|			ТОГДА ЛОЖЬ
			|		ИНАЧЕ ИСТИНА
			|	КОНЕЦ КАК Отмечен,
			|	ЕСТЬNULL(ДанныеЗаполнения.СтатьяРасходов, НЕОПРЕДЕЛЕНО) КАК СтатьяРасходов,
			|	ЕСТЬNULL(ДанныеЗаполнения.КодРемонта, 0) КАК КодРемонта
			|ИЗ
			|	РемонтыУзлов КАК РемонтыУзлов
			|		ЛЕВОЕ СОЕДИНЕНИЕ ДанныеЗаполнения КАК ДанныеЗаполнения
			|		ПО РемонтыУзлов.Узел = ДанныеЗаполнения.Узел
			|			И РемонтыУзлов.ВидРемонта = ДанныеЗаполнения.ВидРемонта
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	ВидыРемонтов.Ссылка КАК ВидРемонта,
			|	ВЫБОР
			|		КОГДА ДанныеЗаполнения.КодРемонта ЕСТЬ NULL 
			|			ТОГДА ЛОЖЬ
			|		ИНАЧЕ ИСТИНА
			|	КОНЕЦ КАК Отмечен,
			|	ЕСТЬNULL(ДанныеЗаполнения.СтатьяРасходов, НЕОПРЕДЕЛЕНО) КАК СтатьяРасходов,
			|	ЕСТЬNULL(ДанныеЗаполнения.КодРемонта, 0) КАК КодРемонта
			|ИЗ
			|	Справочник.ОбъектыЭксплуатации КАК Объекты
			|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВидыРемонтов КАК ВидыРемонтов
			|		ПО Объекты.Класс = ВидыРемонтов.Владелец
			|			И (НЕ ВидыРемонтов.ПометкаУдаления)
			|		ЛЕВОЕ СОЕДИНЕНИЕ ДанныеЗаполнения КАК ДанныеЗаполнения
			|		ПО (ВидыРемонтов.Ссылка = ДанныеЗаполнения.ВидРемонта)
			|			И (ДанныеЗаполнения.Узел = ЗНАЧЕНИЕ(Справочник.УзлыОбъектовЭксплуатации.ПустаяСсылка))
			|ГДЕ
			|	Объекты.Ссылка = &ОбъектЭксплуатации
			|	И НЕ ВидыРемонтов.Владелец ЕСТЬ NULL 
			|
			|ОБЪЕДИНИТЬ ВСЕ
			|
			|ВЫБРАТЬ
			|	ЗНАЧЕНИЕ(Справочник.ВидыРемонтов.ПустаяСсылка),
			|	ВЫБОР
			|		КОГДА ДанныеЗаполнения.КодРемонта ЕСТЬ NULL 
			|			ТОГДА ЛОЖЬ
			|		ИНАЧЕ ИСТИНА
			|	КОНЕЦ,
			|	ЕСТЬNULL(ДанныеЗаполнения.СтатьяРасходов, НЕОПРЕДЕЛЕНО),
			|	ЕСТЬNULL(ДанныеЗаполнения.КодРемонта, 0)
			|ИЗ
			|	Справочник.ОбъектыЭксплуатации КАК Объекты
			|		ЛЕВОЕ СОЕДИНЕНИЕ ДанныеЗаполнения КАК ДанныеЗаполнения
			|		ПО (ДанныеЗаполнения.Узел = ЗНАЧЕНИЕ(Справочник.УзлыОбъектовЭксплуатации.ПустаяСсылка))
			|			И (ДанныеЗаполнения.ВидРемонта = ЗНАЧЕНИЕ(Справочник.ВидыРемонтов.ПустаяСсылка))
			|ГДЕ
			|	Объекты.Ссылка = &ОбъектЭксплуатации");
		
		ИспользоватьУзлы = ПолучитьФункциональнуюОпцию("ИспользоватьУзлыОбъектовЭксплуатации");
		
		ТаблицаРемонтов = ПолучитьИзВременногоХранилища(Параметры.Таблицы.Ремонты);
		Если Не ИспользоватьУзлы Тогда
			ТаблицаРемонтов.ЗаполнитьЗначения(Справочники.УзлыОбъектовЭксплуатации.ПустаяСсылка(), "Узел");
		КонецЕсли;
		
		Запрос.УстановитьПараметр("ОбъектЭксплуатации", ОбъектЭксплуатации);
		Запрос.УстановитьПараметр("ДанныеЗаполнения", ТаблицаРемонтов);
		
		ПакетРезультатов = Запрос.ВыполнитьПакет();
		
		СтрокиДерева = ДеревоРемонтов.ПолучитьЭлементы();
		
		// Добавление объекта эксплуатации, как корня дерева
		СтрокаОбъектаЭксплуатации = СтрокиДерева.Добавить();
		СтрокаОбъектаЭксплуатации.Представление = Строка(ОбъектЭксплуатации);
		СтрокаОбъектаЭксплуатации.ИндексКартинки = 1;
		
		СтрокиОбъектаЭксплуатации = СтрокаОбъектаЭксплуатации.ПолучитьЭлементы();
		
		// Заполнение видов ремонтов объекта
		Выборка = ПакетРезультатов[5].Выбрать();
		Пока Выборка.Следующий() Цикл
			
			СтрокаВидаРемонта = СтрокиОбъектаЭксплуатации.Вставить(0);
			СтрокаВидаРемонта.ИндексКартинки = 3;
			СтрокаВидаРемонта.Представление = Выборка.ВидРемонта;
			СтрокаВидаРемонта.ЭтоСтрокаВидаРемонта = Истина;
			ЗаполнитьЗначенияСвойств(СтрокаВидаРемонта, Выборка, "ВидРемонта, Отмечен, СтатьяРасходов, КодРемонта");
			
		КонецЦикла;
		
		Если ИспользоватьУзлы Тогда
			
			// Добавление узлов объекта эксплуатации и их видов ремонтов
			Выборка = ПакетРезультатов[4].Выбрать();
			
			СоответствиеСтрок = НовыйСоответствиеСтрок();
			СоответствиеСтрок.Вставить(Справочники.УзлыОбъектовЭксплуатации.ПустаяСсылка(), СтрокаОбъектаЭксплуатации.ПолучитьЭлементы());
			
			МассивОбходаВыборки = Новый Массив;
			МассивОбходаВыборки.Добавить(Справочники.УзлыОбъектовЭксплуатации.ПустаяСсылка());
			
			СчетОбходаВыборки = 0;
			Пока СчетОбходаВыборки < МассивОбходаВыборки.Количество() Цикл
				
				Выборка.Сбросить();
				СтруктураПоиска = Новый Структура("Родитель", МассивОбходаВыборки[СчетОбходаВыборки]);
				Пока Выборка.НайтиСледующий(СтруктураПоиска) Цикл
					
					СтрокиУзла = СоответствиеСтрок.Получить(Выборка.Узел); // ДанныеФормыКоллекцияЭлементовДерева
					
					Если СтрокиУзла = Неопределено Тогда
						
						СтрокиРодителя = СоответствиеСтрок.Получить(МассивОбходаВыборки[СчетОбходаВыборки]); // ДанныеФормыКоллекцияЭлементовДерева
						
						НоваяСтрока = СтрокиРодителя.Добавить();
						НоваяСтрока.Представление = Строка(Выборка.Узел);
						НоваяСтрока.Узел = Выборка.Узел;
						НоваяСтрока.ИндексКартинки = 2;
						
						СтрокиУзла = НоваяСтрока.ПолучитьЭлементы();
						
						СоответствиеСтрок.Вставить(Выборка.Узел, СтрокиУзла);
						МассивОбходаВыборки.Добавить(Выборка.Узел);
						
					КонецЕсли;
					
					СтрокаВидаРемонта = СтрокиУзла.Вставить(0);
					СтрокаВидаРемонта.ИндексКартинки = 3;
					СтрокаВидаРемонта.Представление = Выборка.ВидРемонта;
					СтрокаВидаРемонта.ЭтоСтрокаВидаРемонта = Истина;
					ЗаполнитьЗначенияСвойств(СтрокаВидаРемонта, Выборка, "Узел, ВидРемонта, Отмечен, СтатьяРасходов, КодРемонта");
					
				КонецЦикла;
				
				СчетОбходаВыборки = СчетОбходаВыборки + 1;
				
			КонецЦикла;
			
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

//  
// Возвращаемое значение:
// Соответствие из КлючИЗначение:
// * Ключ - СправочникСсылка.УзлыОбъектовЭксплуатации
// * Значение - ДанныеФормыКоллекцияЭлементовДерева
&НаСервере
Функция НовыйСоответствиеСтрок()
	Возврат Новый Соответствие();
КонецФункции

// Процедура рекурсивного обхода дерева с копированием данным отмеченных строк
//
&НаСервере
Процедура ДополнитьТаблицуПоСтрокамДерева(Таблица, Знач Строки=Неопределено)
	
	Если Строки = Неопределено Тогда
		Строки = ДеревоРемонтов.ПолучитьЭлементы();
	КонецЕсли;
	
	Для Каждого Строка Из Строки Цикл
		
		Если Строка.ЭтоСтрокаВидаРемонта Тогда
			Если Строка.Отмечен Тогда
				ЗаполнитьЗначенияСвойств(Таблица.Добавить(), Строка);
			КонецЕсли;
		Иначе
			ДополнитьТаблицуПоСтрокамДерева(Таблица, Строка.ПолучитьЭлементы());
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Процедура рекурсивно выставляет флаг "Отмечен" на заданное значение в строках дерева ремонтов.
//
&НаСервере
Процедура ОтметитьЭлементыПоСтрокамДерева(Отмечен, Знач Строки=Неопределено)
	
	Если Строки = Неопределено Тогда
		Строки = ДеревоРемонтов.ПолучитьЭлементы();
	КонецЕсли;
	
	Для Каждого Строка Из Строки Цикл
		
		Если Строка.ЭтоСтрокаВидаРемонта Тогда
			Строка.Отмечен = Отмечен;
		Иначе
			ОтметитьЭлементыПоСтрокамДерева(Отмечен, Строка.ПолучитьЭлементы());
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Возвращает заполненные параметры оповещения формы документа заказа на ремонт
//
// Возвращаемое значение:
// 		Структура - Структура параметров оповещения.
//
&НаСервере
Функция ПараметрыОповещенияФормыДокумента()
	
	ПараметрыОповещения = Новый Структура;
	ПараметрыОповещения.Вставить("ВыполняемаяОперация", "ПодборРемонтов");
	ПараметрыОповещения.Вставить("Таблицы", Новый Структура);
	
	ТаблицаРемонтов = Новый ТаблицаЗначений;
	ТаблицаРемонтов.Колонки.Добавить("Узел", Новый ОписаниеТипов("СправочникСсылка.УзлыОбъектовЭксплуатации"));
	ТаблицаРемонтов.Колонки.Добавить("ВидРемонта", Новый ОписаниеТипов("СправочникСсылка.ВидыРемонтов"));
	ТаблицаРемонтов.Колонки.Добавить("СтатьяРасходов", Новый ОписаниеТипов("ПланВидовХарактеристикСсылка.СтатьиРасходов"));
	ТаблицаРемонтов.Колонки.Добавить("КодРемонта", Новый ОписаниеТипов("Число"));
	
	ДополнитьТаблицуПоСтрокамДерева(ТаблицаРемонтов);
	
	ПараметрыОповещения.Таблицы.Вставить("Ремонты", ПоместитьВоВременноеХранилище(ТаблицаРемонтов));
	
	Возврат ПараметрыОповещения;
	
КонецФункции

#КонецОбласти
