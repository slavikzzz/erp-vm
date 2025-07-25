#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОписаниеПеременных

Перем Коллекция;
Перем Колонки;

Перем Уровни;
Перем ЗначенияУровней;
Перем ТекущийЭлемент;
Перем Индекс;

Перем ЭтоНачалоОбхода;

#КонецОбласти

#Область ПрограммныйИнтерфейс

// Данные элемента коллекции, на котором в данный момент спозиционирован обход.
// 
// Возвращаемое значение:
// 	ФиксированнаяСтруктура, ФиксированноеСоответствие - .
//
Функция ТекущиеДанные() Экспорт
	
	Если Колонки <> Неопределено Тогда
		ЗаполнитьЗначенияСвойств(Колонки, ТекущийЭлемент);
		Возврат Новый ФиксированнаяСтруктура(Колонки);
	КонецЕсли;
	
	Если ТипЗнч(ТекущийЭлемент) = Тип("СтрокаТаблицыЗначений") Тогда
		Возврат ОбщегоНазначения.ФиксированныеДанные(
			ОбщегоНазначения.СтрокаТаблицыЗначенийВСтруктуру(ТекущийЭлемент));
	ИначеЕсли ТипЗнч(ТекущийЭлемент) = Тип("Структура") Или ТипЗнч(ТекущийЭлемент) = Тип("Соответствие") Тогда
		Возврат ОбщегоНазначения.ФиксированныеДанные(ТекущийЭлемент);
	КонецЕсли;
	
	Возврат ТекущийЭлемент;
	
КонецФункции

// Индекс текущего элемента коллекции, на котором в данный момент спозиционирован обход. 
// 
// Возвращаемое значение:
// 	Число, Неопределено - .
//
Функция ТекущаяСтрока() Экспорт
	Возврат ?(Индекс = -1, Неопределено, Индекс);
КонецФункции

// Получает следующий элемент коллекции. 
// Для обхода коллекции нужно вызвать данный метод для позиционирования на первый элемент 
// и далее вызывать до тех пор, пока не будет возвращено значение Ложь.
// 
// Если при получении элементов выбираются все элементы со значением поля, равным значению поля, 
// заданному при предыдущем вызове метода СледующийПоЗначениюПоля, то при попытке получить элементы со значением поля, 
// отличающимся от полученного методом СледующийПоЗначениюПоля, будет возвращено значение Ложь.
// 
// Возвращаемое значение:
// 	Булево - Истина - следующий элемент выбран, Ложь - достигнут конец коллекции.
// 
Функция Следующий() Экспорт
	
	Если ЭтоНачалоОбхода Тогда
		Если ТекущийЭлемент <> Неопределено Тогда
			ЭтоНачалоОбхода = Ложь;
			Возврат Истина;
		КонецЕсли;
		Если Не ЕстьСледующийЭлемент() Тогда
			Возврат Ложь;
		КонецЕсли;
		ПерейтиНаСледующийЭлемент();
		ЭтоНачалоОбхода = Ложь;
		Возврат Истина;
	КонецЕсли;
	
	Если ЕстьСледующийЭлемент() И СледующийЭлементПодходит() Тогда
		ПерейтиНаСледующийЭлемент();
		Возврат Истина;
	КонецЕсли;
	
	ЭтоНачалоОбхода = Истина;
	Возврат Ложь;
	
КонецФункции

// Получает следующий элемент коллекции по значению указанного поля. 
// Обход позиционируется на следующий элемент со значением, отличающимся от текущего значения, по указанному полю. 
// При первом вызове - остается на текущем элементе коллекции.
// 
// Важно. Коллекция должна быть упорядочена по всем полям, используемым последовательными вызовами этого метода.
// Причем порядок вызова метода для разных полей должен соответствовать последовательности полей, заданных при упорядочивании. 
//
// Параметры:
// 	ИмяПоля - Строка - имя поля элементов коллекции, в котором будет осуществляться поиски следующего значения.
// Возвращаемое значение:
// 	Булево - Истина - следующая запись выбрана; Ложь - достигнут конец выборки.
//
Функция СледующийПоЗначениюПоля(ИмяПоля) Экспорт
	
	ПроверитьПараметр("ИмяПоля", ИмяПоля, Тип("Строка"));
	
	ЭтоНачалоОбхода = Истина;
	
	Если Не ЕстьУровень(ИмяПоля) Тогда
		Возврат НачалоОбходаПоЗначениюПоля(ИмяПоля);
	КонецЕсли;
	
	Проверить(ЭтоПоследнийУровень(ИмяПоля), 
		СтрШаблон(НСтр("ru = 'Неверная последовательность обхода коллекции. 
			 |СледующийПоЗначениюПоля(""%1"") уже ранее был вызван';
			 |en = 'Invalid collection traversal sequence. 
			 |СледующийПоЗначениюПоля(""%1"") has been called before'"), ИмяПоля));

	УдалитьУровень(ИмяПоля);
	
	Пока ЕстьСледующийЭлемент() И СледующийЭлементПодходит() Цикл
		Если Не ЗначенияПолейЭлементовРавны(СледующийЭлемент(), ТекущийЭлемент, ИмяПоля) Тогда
			ПерейтиНаСледующийЭлемент();
			ДобавитьУровень(ИмяПоля);
			Возврат Истина;
		КонецЕсли;
		ПерейтиНаСледующийЭлемент();
	КонецЦикла;
	
	Возврат Ложь;
	
КонецФункции

// Получает следующий элемент коллекции по значениям указанных полей. 
// Работает аналогично методу СледующийПоЗначениюПоля, 
// но позволяет осуществлять переход по значениям сразу нескольких полей.
// 
// Параметры:
// 	ИменаПолей 	- Строка, Массив Из Строка - имена полей, в которых будет осуществляться поиск следующих значений. 
//
// Возвращаемое значение:
// 	Булево - Истина - следующая запись выбрана; Ложь - достигнут конец выборки.
//
Функция СледующийПоЗначениямПолей(ИменаПолей) Экспорт

	ПроверитьПараметр("ИменаПолей", ИменаПолей, Новый ОписаниеТипов("Строка, Массив"));
	Возврат СледующийПоЗначениюПоля(ИменаПолейСтрокой(ИменаПолей));
	
КонецФункции

// Осуществляет поиск элемента коллекции по указанным условиям и установку указателя обхода на него.
// Текущий элемент не рассматривается.
// Поиск осуществляется вне зависимости от выполненных ранее переходов методом СледующийПоЗначениюПоля.
// 
// Параметры:
// 	СтруктураПоиска - Структура:
// 	* Ключ - Строка - имя поля,
// 	* Значение - Произвольный - значение поиска по полю.
// Возвращаемое значение:
// 	Булево - Истина - запись найдена, Ложь - в противном случае.
//
Функция НайтиСледующий(СтруктураПоиска) Экспорт

	ПроверитьПараметр("СтруктураПоиска", СтруктураПоиска, Тип("Структура"));
	
	СброситьУровни();
	
	ИменаПолей = КлючиСтруктуры(СтруктураПоиска);
	Пока ЕстьСледующийЭлемент() Цикл
		ПерейтиНаСледующийЭлемент();
		Если ЗначенияПолейЭлементовРавны(ТекущийЭлемент, СтруктураПоиска, ИменаПолей) Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Ложь;
	
КонецФункции

// Позиционирует обход в начало.
// После вызова метода Следующий обход спозиционируется на первый элемент.
// 
Процедура Сбросить() Экспорт
	СброситьУровни();
	ТекущийЭлемент = Неопределено;
	Индекс = -1;
	ЭтоНачалоОбхода = Истина;
КонецПроцедуры

// Получает количество элементов в обходимой коллекции.
// 
// Возвращаемое значение:
// 	Число - количество элементов.
//
Функция Количество() Экспорт
	Возврат Коллекция.Количество();
КонецФункции

// Возвращает коллекцию, для которой предназначен обход.
// 
// Возвращаемое значение:
// 	ТаблицаЗначений, 
// 	Массив Из Структура, 
// 	Массив Из СтрокаТаблицыЗначений, 
// 	ДанныеФормыКоллекция,
// 	НаборЗаписей,
// 	ТабличнаяЧасть - коллекция, заданная при инициализации обхода.
//
Функция Владелец() Экспорт
	Возврат Коллекция;
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура УстановитьКоллекцию(КоллекцияСтрок) Экспорт
	Коллекция = КоллекцияСтрок;
	ЗаполнитьСоставКолонок();
	Сбросить();
КонецПроцедуры

Процедура ПриСоздании()
	Коллекция = Новый Массив;
	ИнициализироватьУровни();
	Сбросить();
КонецПроцедуры

Функция НачалоОбходаПоЗначениюПоля(ИмяПоля)

	Если ТекущийЭлемент <> Неопределено Тогда
		ДобавитьУровень(ИмяПоля);
		Возврат Истина;
	КонецЕсли;

	Если Не ЕстьСледующийЭлемент() Тогда
		Возврат Ложь;
	КонецЕсли;

	ПерейтиНаСледующийЭлемент();
	ДобавитьУровень(ИмяПоля);

	Возврат Истина;
	
КонецФункции

Функция ЕстьСледующийЭлемент()
	
	Если Коллекция.Количество() = 0 Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если Индекс + 1 = Коллекция.Количество() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

Функция СледующийЭлементПодходит()

	ИндексУровня = Уровни.ВГраница();
	Пока ИндексУровня >=0 Цикл
		Уровень = Уровни[ИндексУровня];
		Если Не ЗначенияПолейЭлементовРавны(СледующийЭлемент(), ЗначениеУровня(Уровень), Уровень) Тогда
			Возврат Ложь;
		КонецЕсли;
		ИндексУровня = ИндексУровня - 1;
	КонецЦикла;
	
	Возврат Истина;
	
КонецФункции

Функция СледующийЭлемент()
	Возврат Коллекция[Индекс + 1];
КонецФункции

Процедура ПерейтиНаСледующийЭлемент()

	Если Индекс + 1 < Коллекция.Количество() Тогда
		ТекущийЭлемент = Коллекция[Индекс + 1];
		Индекс = Индекс + 1;
	КонецЕсли;
	
КонецПроцедуры

Функция ЗначенияПолейЭлементовРавны(Элемент1, Элемент2, Знач ИменаПолей)
	
	Если ТипЗнч(ИменаПолей) = Тип("Строка") Тогда
		ИменаПолей = КлючиСтруктуры(Новый Структура(ИменаПолей));
	КонецЕсли;
	
	Для Каждого ИмяПоля Из ИменаПолей Цикл
		Если Элемент1[ИмяПоля] <> Элемент2[ИмяПоля] Тогда
			Возврат Ложь;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Истина;
	
КонецФункции

Функция ЕстьУровень(Уровень)
	Возврат Уровни.Найти(Уровень) <> Неопределено;
КонецФункции

Функция ЭтоПоследнийУровень(Уровень)
	Возврат ?(Уровни.Количество() = 0, Ложь, Уровни[Уровни.ВГраница()] = Уровень);
КонецФункции

Процедура ДобавитьУровень(Уровень)
	
	Если Не ЕстьУровень(Уровень) Тогда
		Уровни.Добавить(Уровень);
	КонецЕсли;
	
	ИменаПолей = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Уровень, ",");
	
	ЗначенияУровня = Новый Структура;
	Для Каждого ИмяПоля Из ИменаПолей Цикл
		ЗначенияУровня.Вставить(ИмяПоля, ТекущийЭлемент[ИмяПоля]);
	КонецЦикла;
	ЗначенияУровней.Вставить(Уровень, ЗначенияУровня);
	
КонецПроцедуры

Процедура УдалитьУровень(Уровень)

	ИндексУровня = Уровни.Найти(Уровень);
	Если ИндексУровня <> Неопределено Тогда
		Уровни.Удалить(ИндексУровня);
		ЗначенияУровней.Удалить(Уровень);
	КонецЕсли;
	
КонецПроцедуры

Процедура ИнициализироватьУровни()
	Уровни = Новый Массив;
	ЗначенияУровней = Новый Соответствие;
КонецПроцедуры

Процедура СброситьУровни()
	Уровни.Очистить();
	ЗначенияУровней.Очистить();
КонецПроцедуры

Функция ЗначениеУровня(Уровень)
	Возврат ЗначенияУровней[Уровень];
КонецФункции

Процедура УпорядочитьМассив(Массив)
	Таблица = Новый ТаблицаЗначений;
	Таблица.Колонки.Добавить("Колонка");
	ОбщегоНазначенияКлиентСервер.ДополнитьТаблицуИзМассива(Таблица, Массив, "Колонка");
	Таблица.Сортировать("Колонка");
	Массив = Таблица.ВыгрузитьКолонку("Колонка");
КонецПроцедуры

Функция ИменаПолейСтрокой(ИменаПолей)

	Если ТипЗнч(ИменаПолей) = Тип("Строка") Тогда
		Возврат СтрСоединить(КлючиСтруктуры(Новый Структура(ИменаПолей)), ",");
	КонецЕсли;
	
	КопияМассива = СтрРазделить(СтрСоединить(ИменаПолей, ","), ",");
	УпорядочитьМассив(КопияМассива);
	Возврат СтрСоединить(КопияМассива, ",");
	
КонецФункции

Процедура ЗаполнитьСоставКолонок()
	
	Если ТипЗнч(Коллекция) = Тип("ТаблицаЗначений") Тогда
		Колонки = Новый Структура(СтрСоединить(ОбщегоНазначения.ВыгрузитьКолонку(Коллекция.Колонки, "Имя"), ","));
	ИначеЕсли ТипЗнч(Коллекция) = Тип("ДанныеФормыКоллекция") Тогда
		Колонки = Новый Структура(
			СтрСоединить(ОбщегоНазначения.ВыгрузитьКолонку(Коллекция.Выгрузить().Колонки, "Имя"), ","));
	ИначеЕсли ЭтоНаборЗаписей(Коллекция) Или ЭтоТабличнаяЧасть(Коллекция) Тогда
		Колонки = Новый Структура(
			СтрСоединить(ОбщегоНазначения.ВыгрузитьКолонку(Коллекция.ВыгрузитьКолонки().Колонки, "Имя"), ","));
	Иначе
		Колонки = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

Функция ЭтоНаборЗаписей(ПроверяемаяКоллекция)
	
	ОбъектМетаданных = Метаданные.НайтиПоТипу(ТипЗнч(ПроверяемаяКоллекция));
	
	Если ОбъектМетаданных = Неопределено Или Не ОбщегоНазначения.ЭтоРегистр(ОбъектМетаданных) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат ТипЗнч(ПроверяемаяКоллекция) = 
		ТипЗнч(ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(ОбъектМетаданных.ПолноеИмя()).СоздатьНаборЗаписей());
	
КонецФункции

Функция ЭтоТабличнаяЧасть(ПроверяемаяКоллекция)
	
	ОбъектМетаданных = Метаданные.НайтиПоТипу(ТипЗнч(ПроверяемаяКоллекция));
	
	Если ОбъектМетаданных = Неопределено Или ТипЗнч(ОбъектМетаданных.Родитель()) = ТипЗнч(Метаданные) Тогда 
		Возврат Ложь;
	КонецЕсли;
	
	Возврат 
		ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ОбъектМетаданных.Родитель(), "ТабличныеЧасти")
		И ОбъектМетаданных.Родитель().ТабличныеЧасти.Содержит(ОбъектМетаданных);
	
КонецФункции

Функция КлючиСтруктуры(Структура)
	Возврат ОбщегоНазначения.ВыгрузитьКолонку(Структура, "Ключ");
КонецФункции

Процедура ПроверитьПараметр(ИмяПараметра, ЗначениеПараметра, ОжидаемыеТипы)
	ОбщегоНазначенияКлиентСервер.ПроверитьПараметр("ОбходКоллекции", ИмяПараметра, ЗначениеПараметра, ОжидаемыеТипы);
КонецПроцедуры

Процедура Проверить(Условие, Сообщение = "")
	ОбщегоНазначенияКлиентСервер.Проверить(Условие, Сообщение, "ОбходКоллекции");
КонецПроцедуры

#КонецОбласти

#Область Инициализация

ПриСоздании();

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.';
						|en = 'Invalid object call on the client.'");
#КонецЕсли