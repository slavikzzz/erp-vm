
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Параметры.Свойство("Операция",                         Операция);
	Параметры.Свойство("ОперацияКакРаспоряжениеВыработки", ОперацияКакРаспоряжениеВыработки);
	Параметры.Свойство("КоличествоНаКонтроле",             КоличествоНаКонтроле);
	Параметры.Свойство("НаОснованииНСИ",                   НаОснованииНСИ);
	
	Если НЕ Параметры.Свойство("ОперацияНаименование", ОперацияНаименование) Тогда
		ОперацияНаименование = Операция;
	КонецЕсли;
	
	Заголовок = СтрШаблон(НСтр("ru = 'Контроль операции ""%1""';
								|en = 'The ""%1"" operation control'"), ОперацияНаименование);
	
	Если НЕ Параметры.Свойство("ЕдиницаИзмеренияПредставление", ЕдиницаИзмеренияПредставление) Тогда
		ЕдиницаИзмеренияПредставление = УправлениеПроизводствомКлиентСервер.ПредставлениеЕдиницыИзмеренияОперации(
			Неопределено,
			КоличествоНаКонтроле);
	КонецЕсли;
		
	ЗаполнитьСписокПричинНепрохожденияКонтроля();
	
	НастроитьЭлементыФормы();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Готово(Команда)
	
	РаспределитьОстаток("КоличествоГотово");
	
КонецПроцедуры

&НаКлиенте
Процедура НаДоработку(Команда)
	
	РаспределитьОстаток("КоличествоНаДоработку");
	
КонецПроцедуры

&НаКлиенте
Процедура Брак(Команда)
	
	РаспределитьОстаток("КоличествоБрак");
	
КонецПроцедуры

&НаКлиенте
Процедура Применить(Команда)
	
	Если ПроверитьЗаполнениеРеквизитов() Тогда
		
		Результат = Новый Структура;
		Результат.Вставить("ЗаписиПротокола", Новый Массив);
		Результат.Вставить("ПересчитатьНормативы", ПересчитатьНормативы);
		
		Если КоличествоНаДоработку > 0 Тогда
			НовоеДействие = ОперативныйУчетПроизводстваКлиентСервер.ЗаписьПротоколаКонструктор("ОтправкаНаДоработку");
			НовоеДействие.Количество  = КоличествоНаДоработку;
			НовоеДействие.Комментарий = ПричинаНаДоработку;
			Результат.ЗаписиПротокола.Добавить(НовоеДействие);
		КонецЕсли;
		
		Если КоличествоБрак > 0 Тогда
			НовоеДействие = ОперативныйУчетПроизводстваКлиентСервер.ЗаписьПротоколаКонструктор("Брак");
			НовоеДействие.Количество  = КоличествоБрак;
			НовоеДействие.Комментарий = ПричинаБрак;
			Результат.ЗаписиПротокола.Добавить(НовоеДействие);
		КонецЕсли;
		
		Если КоличествоГотово > 0 Тогда
			НовоеДействие = ОперативныйУчетПроизводстваКлиентСервер.ЗаписьПротоколаКонструктор("Контроль");
			НовоеДействие.Количество  = КоличествоГотово;
			Результат.ЗаписиПротокола.Добавить(НовоеДействие);
		КонецЕсли;
		
		Закрыть(Результат);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура КоличествоПриИзменении(Элемент)
	
	РассчитатьПризнакПересчитатьНормативы(ЭтотОбъект);
	
	НастроитьЗависимыеЭлементыФормы(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПричинаПриИзменении(Элемент)
	
	НастроитьЗависимыеЭлементыФормы(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура НастроитьЭлементыФормы()
	
	НастроитьЭлементыОтраженияБрака();
	
	НастроитьПереключательПересчитатьНормативы();
	
	НастроитьЗависимыеЭлементыФормы(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура НастроитьЗависимыеЭлементыФормы(Форма, СписокРеквизитов = "")
	
	Элементы = Форма.Элементы;
	
	Инициализация = ПустаяСтрока(СписокРеквизитов);
	СтруктураРеквизитов = Новый Структура(СписокРеквизитов);
	
	Если Инициализация
		Или СтруктураРеквизитов.Свойство("Количество") Тогда
			
		ОбновитьКоличествоКРаспределению(Форма);
		
		Элементы.КоличествоНаДоработку.МаксимальноеЗначение = Форма.КоличествоНаДоработку + Форма.КоличествоКРаспределению;
		Элементы.КоличествоБрак.МаксимальноеЗначение        = Форма.КоличествоБрак + Форма.КоличествоКРаспределению;
		Элементы.КоличествоГотово.МаксимальноеЗначение      = Форма.КоличествоГотово + Форма.КоличествоКРаспределению;
		
		Элементы.ГруппаБыстрыеКоманды.Доступность           = Форма.КоличествоКРаспределению > 0;
		Элементы.ФормаПрименить.Доступность = (Форма.КоличествоГотово > 0 ИЛИ Форма.КоличествоБрак > 0 ИЛИ Форма.КоличествоНаДоработку > 0);
		
	КонецЕсли;
	
	Если Инициализация
		Или СтруктураРеквизитов.Свойство("ИнформационнаяПанель") Тогда
			
			Элементы.ГруппаИнформационнаяПанель.Видимость = ЗначениеЗаполнено(Элементы.ИнформационнаяПанельНадпись.Заголовок);
			
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура НастроитьЭлементыОтраженияБрака()
	
	Элементы.Брак.Доступность = ОперацияКакРаспоряжениеВыработки;
	Элементы.ГруппаБрак.Доступность = ОперацияКакРаспоряжениеВыработки;
	
	Если НЕ ОперацияКакРаспоряжениеВыработки Тогда
		Элементы.ИнформационнаяПанельНадпись.Заголовок = Документы.ПроизводственнаяОперация2_2.ТекстПредупрежденияНедоступностьОтраженияБрака();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура НастроитьПереключательПересчитатьНормативы()
	
	Элементы.ПересчитатьНормативы.Видимость = НаОснованииНСИ;
	
	Если НаОснованииНСИ Тогда
		
		Элементы.ПересчитатьНормативы.Заголовок = Документы.ПроизводственнаяОперация2_2.ТекстПереключателяПересчитатьНормативы(Операция);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьКоличествоКРаспределению(Форма)
	
	Форма.КоличествоКРаспределению = Форма.КоличествоНаКонтроле
		- Форма.КоличествоНаДоработку
		- Форма.КоличествоБрак
		- Форма.КоличествоГотово;
	
КонецПроцедуры

&НаКлиенте
Процедура РаспределитьОстаток(ИмяРеквизита)
	
	ЭтотОбъект[ИмяРеквизита] = ЭтотОбъект[ИмяРеквизита] + КоличествоКРаспределению;
	ТекущийЭлемент = Элементы[ИмяРеквизита];
	
	РассчитатьПризнакПересчитатьНормативы(ЭтотОбъект);
	
	НастроитьЗависимыеЭлементыФормы(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокПричинНепрохожденияКонтроля()
	
	ТекстЗапроса = "
	|ВЫБРАТЬ ПЕРВЫЕ 50
	|	Таблица.Комментарий КАК Комментарий
	|ИЗ
	|	Документ.ПроизводственнаяОперация2_2.Протокол КАК Таблица
	|ГДЕ
	|	Таблица.Событие = ЗНАЧЕНИЕ(Перечисление.СобытияПротоколаПроизводственнойОперации.ОтправкаНаДоработку)
	|	И Таблица.Комментарий <> """"
	|	И Таблица.Ссылка.Проведен
	|УПОРЯДОЧИТЬ ПО
	|	Таблица.Дата УБЫВ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ ПЕРВЫЕ 50
	|	Таблица.Комментарий КАК Комментарий
	|ИЗ
	|	Документ.ПроизводственнаяОперация2_2.Протокол КАК Таблица
	|ГДЕ
	|	Таблица.Событие = ЗНАЧЕНИЕ(Перечисление.СобытияПротоколаПроизводственнойОперации.Брак)
	|	И Таблица.Комментарий <> """"
	|	И Таблица.Ссылка.Проведен
	|УПОРЯДОЧИТЬ ПО
	|	Таблица.Дата УБЫВ
	|";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	
	Результаты = Запрос.ВыполнитьПакет();
	
	СпискиДляЗаполнения = Новый Массив;
	СпискиДляЗаполнения.Добавить(Элементы.ПричинаНаДоработку.СписокВыбора);
	СпискиДляЗаполнения.Добавить(Элементы.ПричинаБрак.СписокВыбора);
	
	Для Индекс = 0 По 1 Цикл
		ТекущийСписок = СпискиДляЗаполнения[Индекс]; // СписокЗначений
		Если НЕ Результаты[Индекс].Пустой() Тогда
			Выборка = Результаты[Индекс].Выбрать();
			Пока Выборка.Следующий() Цикл
				Если ТекущийСписок.НайтиПоЗначению(Выборка.Комментарий) = Неопределено Тогда
					ТекущийСписок.Добавить(Выборка.Комментарий);
					Если ТекущийСписок.Количество() >= 5 Тогда
						Прервать;
					КонецЕсли;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Функция ПроверитьЗаполнениеРеквизитов()
	
	ЕстьОшибки = Ложь;
	
	Если (КоличествоНаДоработку + КоличествоБрак + КоличествоГотово) > КоличествоНаКонтроле Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(
			НСтр("ru = 'Превышено доступное к контролю количество';
				|en = 'The quantity available for control is exceeded'"),,"КоличествоНаКонтроле",,ЕстьОшибки);
	КонецЕсли;
	
	Возврат НЕ ЕстьОшибки;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура РассчитатьПризнакПересчитатьНормативы(Форма)
	
	Если НЕ Форма.НаОснованииНСИ Тогда
		Возврат;
	КонецЕсли;
	
	Если Форма.ПересчитатьНормативы Тогда
		Возврат;
	КонецЕсли;
	
	Если Форма.КоличествоБрак Тогда
		Форма.ПересчитатьНормативы = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти