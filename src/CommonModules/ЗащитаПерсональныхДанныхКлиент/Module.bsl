///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Осуществляет переход к форме подготовки согласия на обработку персональных данных, 
// используется как клиентский обработчик печати (поэтому является функцией, а не процедурой).
//
// Параметры:
//  ПараметрыПечати - Структура - параметры обработки команды печати:
//   * ОбъектыПечати - Массив           - в первом элементе ожидается субъект персональных данных;
//   * Форма         - ФормаКлиентскогоПриложения - форма, из которой выполняется печать.
//
// Возвращаемое значение:
//   Неопределено - не требуется, т.к. функция является клиентским обработчиком печати.
//
Функция ОткрытьФормуСогласиеНаОбработкуПерсональныхДанных(ПараметрыПечати) Экспорт
	
	Если ПараметрыПечати.ОбъектыПечати.Количество() = 0 Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Субъект = ПараметрыПечати.ОбъектыПечати[0];
	ОткрытьФорму("Документ.СогласиеНаОбработкуПерсональныхДанных.ФормаОбъекта", Новый Структура("Субъект", Субъект),
		ПараметрыПечати.Форма);
	Возврат Неопределено;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Процедуры и функции для встраивания подсистемы в формы объектов конфигурации.

// Определяет, что указанное событие - это событие об уничтожении персональных данных субъектов
// и обновляет объект управляемой формы.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма субъекта.
//  ИмяСобытия - Строка - имя обрабатываемого события.
//
Процедура ОбработкаОповещенияФормы(Форма, ИмяСобытия) Экспорт
	
	Если ИмяСобытия = "ИзмененаДатаУничтоженияПерсональныхДанных" Или ИмяСобытия = "УничтоженыПерсональныеДанные" Тогда
		Форма.Прочитать();
	КонецЕсли;
	
КонецПроцедуры

// Определяет, что указанное событие - это событие об уничтожении персональных данных субъектов
// и обновляет данные в таблице субъектов.
//
// Параметры:
//  СписокФормы - ТаблицаФормы - элемент формы динамического списка субъектов.
//  ИмяСобытия - Строка - имя обрабатываемого события.
//
Процедура ОбработкаОповещенияФормыСписка(СписокФормы, ИмяСобытия) Экспорт
	
	Если ИмяСобытия = "ИзмененаДатаУничтоженияПерсональныхДанных" Или ИмяСобытия = "УничтоженыПерсональныеДанные" Тогда
		СписокФормы.Обновить();
	КонецЕсли;
	
КонецПроцедуры

// Обработчик команды формы списка субъектов персональных данных.
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - форма субъекта.
//   Список - ДинамическийСписок - динамический список субъектов.
//
Процедура ПоказыватьСоСкрытымиПДн(Форма, Список) Экспорт
	
	Кнопка = Форма.Элементы.Найти("ПоказыватьСоСкрытымиПДн");
	Если Кнопка = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПоказыватьСоСкрытымиПДн = Не Кнопка.Пометка;
	
	Кнопка.Пометка = ПоказыватьСоСкрытымиПДн;
	Список.Параметры.УстановитьЗначениеПараметра("ПоказыватьСоСкрытымиПДн", ПоказыватьСоСкрытымиПДн);
	
	ЗащитаПерсональныхДанныхВызовСервера.СохранитьПоложениеОтбораПоказыватьСоСкрытымиПДн(Форма.ИмяФормы,
		ПоказыватьСоСкрытымиПДн);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Настраивает элементы формы НастройкиПользователейИПрав обработки ПанельАдминистрированияБСП.
// Запускает фоновое изменение настроек уничтожения персональных данных.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - настраиваемая форма.
//
Процедура НастройкиУничтоженияПерсональныхДанныхПриИзменении(Форма) Экспорт
	
	Элементы = Форма.Элементы;
	НаборКонстант = Форма.НаборКонстант;
	
	ПараметрыВыполнения = ЗащитаПерсональныхДанныхВызовСервера.НастройкиУничтоженияПерсональныхДанныхСистемы();
	ПараметрыВыполнения.ИспользоватьУничтожениеПерсональныхДанных =
		НаборКонстант.ИспользоватьСкрытиеПерсональныхДанныхСубъектов;
	
	ДлительнаяОперация = ЗащитаПерсональныхДанныхВызовСервера.ЗапуститьДлительнуюОперациюИзменениеНастроекУничтоженияПДн(
		Форма.УникальныйИдентификатор, ПараметрыВыполнения);
	
	ДоступностьЭлементов = Новый Соответствие;
	ДоступностьЭлементов.Вставить(Элементы.ИспользоватьУничтожениеПерсональныхДанных.Имя,
		Элементы.ИспользоватьУничтожениеПерсональныхДанных.Доступность);
	
	Если ДлительнаяОперация <> Неопределено И ДлительнаяОперация.Статус = "Выполняется" Тогда
		Элементы.ИспользоватьУничтожениеПерсональныхДанных.Доступность = Ложь;
		Элементы.ДекорацияОжиданиеИзмененияИспользованияУничтоженияПДн.Видимость = Истина;
	КонецЕсли;
	
	ДополнительныеПараметры = ДополнительныеПараметрыИзмененияНастроекУничтоженияПерсональныхДанных(Форма,
		ДоступностьЭлементов);
	
	НастройкиОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(Форма);
	НастройкиОжидания.ВыводитьОкноОжидания = Ложь;
	
	Обработчик = Новый ОписаниеОповещения("ПослеИзмененияНастроекУничтоженияПерсональныхДанных", ЭтотОбъект,
		ДополнительныеПараметры);
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, Обработчик, НастройкиОжидания);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Параметры:
//  Результат - см. ДлительныеОперацииКлиент.НовыйРезультатДлительнойОперации
//  ДополнительныеПараметры - см. ДополнительныеПараметрыИзмененияНастроекУничтоженияПерсональныхДанных
//
Процедура ПослеИзмененияНастроекУничтоженияПерсональныхДанных(Результат, ДополнительныеПараметры) Экспорт
	
	Форма = ДополнительныеПараметры.Форма;
	ДоступностьЭлементов = ДополнительныеПараметры.ДоступностьЭлементов;
	
	Элементы = Форма.Элементы; 
	НаборКонстант = Форма.НаборКонстант;
	
	Для Каждого КлючИЗначение Из ДоступностьЭлементов Цикл
		
		ИмяЭлемента = КлючИЗначение.Ключ;
		ДоступностьДо = КлючИЗначение.Значение;
		ТекущийЭлемент = Элементы.Найти(ИмяЭлемента);
		
		Если ТекущийЭлемент.Доступность <> ДоступностьДо Тогда
			ТекущийЭлемент.Доступность = ДоступностьДо;
		КонецЕсли;
		
	КонецЦикла;
		
	Если Элементы.ДекорацияОжиданиеИзмененияИспользованияУничтоженияПДн.Видимость Тогда
		Элементы.ДекорацияОжиданиеИзмененияИспользованияУничтоженияПДн.Видимость = Ложь;
	КонецЕсли;
	
	Если Результат <> Неопределено
		И Результат.Статус = "Выполнено" Тогда
		
		Оповестить("Запись_НаборКонстант", Новый Структура, "ИспользоватьСкрытиеПерсональныхДанныхСубъектов");
		ПоказатьОповещениеПользователя(НСтр("ru = 'Настройки уничтожения персональных данных изменены.';
											|en = 'The settings of personal data destruction are changed.'"));
		
	Иначе
		
		СтарыеНастройкиСистемы = ЗащитаПерсональныхДанныхВызовСервера.НастройкиУничтоженияПерсональныхДанныхСистемы();
		
		НаборКонстант.ИспользоватьСкрытиеПерсональныхДанныхСубъектов =
			СтарыеНастройкиСистемы.ИспользоватьУничтожениеПерсональныхДанных;
		
		Если Результат <> Неопределено Тогда
			СтандартныеПодсистемыКлиент.ВывестиИнформациюОбОшибке(
				Результат.ИнформацияОбОшибке);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Параметры:
//  Форма - ФормаКлиентскогоПриложения
//  ДоступностьЭлементов - Соответствие из КлючИЗначение:
//   * Ключ - Строка
//   * Значение - Булево
// 
// Возвращаемое значение:
//  Структура -дополнительные параметры изменения настроек уничтожения персональных данных:
//   * Форма - ФормаКлиентскогоПриложения
//   * ДоступностьЭлементов - Соответствие из КлючИЗначение:
//     * Ключ - Строка
//     * Значение - Булево
//
Функция ДополнительныеПараметрыИзмененияНастроекУничтоженияПерсональныхДанных(Форма, ДоступностьЭлементов)
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Форма", Форма);
	ДополнительныеПараметры.Вставить("ДоступностьЭлементов", ДоступностьЭлементов);
	
	Возврат ДополнительныеПараметры;
	
КонецФункции

#КонецОбласти
