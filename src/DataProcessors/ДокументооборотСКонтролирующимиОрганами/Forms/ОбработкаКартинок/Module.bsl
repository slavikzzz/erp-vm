&НаКлиенте
Перем КонтекстЭДОКлиент;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ОбработатьПараметры(Параметры);
	ШаблонОписаниеФайла = ШаблонОписаниеФайла();
	
	ИзменитьОформлениеПроцессаПреобразования(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриОткрытииЗавершение", ЭтотОбъект);
	ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура Подключаемый_НачатьОбработкуФайлов()
	
	Адрес = ВыполнитьОбработкуКартинок();
	ОбработкиФайловЗавершение(Адрес);
	
КонецПроцедуры

&НаКлиенте
Процедура ПояснениеОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "требования" Тогда
		
		КонтекстЭДОКлиент.ПоказатьТребованияКИзображениямУниверсальная(ПараметрыПреобразования);
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "Подробнее" Тогда
		
		ОткрытьФорму(КонтекстЭДОКлиент.ПутьКОбъекту + ".Форма.ОшибкиПреобразованияСканКопий", ПараметрыФормыОшибок());
		
	Иначе
		
		ВнутреннийИдентификаторФайла = НавигационнаяСсылкаФорматированнойСтроки;
		ОткрытьКартинку(ВнутреннийИдентификаторФайла);
		
	КонецЕсли;
	
КонецПроцедуры


#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Отмена(Команда)
	ЗакрытьЕслиОткрыта();
КонецПроцедуры

&НаКлиенте
Процедура ПродолжитьБезФайла(Команда)
	ЗаполнитьРезультатИЗакрыть();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ПараметрыФормыОшибок()

	Данные = ДанныеФормыВЗначение(ОписанияФайлов, Тип("ТаблицаЗначений"));
	
	Отбор = Новый Структура();
	Отбор.Вставить("Выполнено", Ложь);
	 
	Копия = Данные.Скопировать(Отбор);
	
	Адрес  = ПоместитьВоВременноеХранилище(Копия, Новый УникальныйИдентификатор);
		
	ДополнительныеПараметры = Новый Структура();
	ДополнительныеПараметры.Вставить("Адрес", Адрес);
	
	Возврат ДополнительныеПараметры;

КонецФункции
 

&НаКлиенте
Процедура ОткрытьКартинку(ВнутреннийИдентификаторФайла)
	
	Для каждого ОписаниеФайла Из ОписанияФайлов Цикл
		Если ОписаниеФайла.ВнутреннийИдентификаторФайла = ВнутреннийИдентификаторФайла Тогда
			ОперацииСФайламиЭДКОКлиент.ОткрытьФайл(ОписаниеФайла.Адрес, ОписаниеФайла.Имя);
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытииЗавершение(Результат, ВходящийКонтекст) Экспорт
	
	КонтекстЭДОКлиент = Результат.КонтекстЭДО;
	
	ПодключитьОбработчикОжидания("Подключаемый_НачатьОбработкуФайлов", 0.1, Истина);
	
КонецПроцедуры

&НаСервере
Функция ВыполнитьОбработкуКартинок() Экспорт
	
	ДополнительныеПараметры = Новый Структура();
	ДополнительныеПараметры.Вставить("ОписанияФайлов", ТаблицуЗначенийВМассивСтруктур(Истина));
	ДополнительныеПараметры.Вставить("ПараметрыПреобразования", ПараметрыПреобразования);
	
	Адрес = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
	ОперацииСФайламиЭДКО.ОбработатьКартинки(ДополнительныеПараметры, Адрес);
	
	Возврат Адрес;
	
КонецФункции

&НаКлиенте
Процедура ОбработкиФайловЗавершение(Адрес) Экспорт
	
	ЕстьОшибки = РазобратьОтветНаСервере(Адрес); 
	
	Если ЕстьОшибки Тогда
		ИзменитьОформлениеОшибки(ЭтотОбъект);
	Иначе
		// Если все обработалось
		Процент = 100;
		ИзменитьОформлениеПроцессаПреобразования(ЭтотОбъект);
		
		// Чтобы было видно 100
		ПодключитьОбработчикОжидания("Подключаемый_ПоказатьЗавершениеПроцесса", 0.5, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция РазобратьОтветНаСервере(Адрес) Экспорт
	
	Результат = ПолучитьИзВременногоХранилища(Адрес);
	
	ЕстьОшибки = Ложь;
	
	ОписанияФайлов.Очистить();
	Для каждого СтрокаРезультата Из Результат Цикл
		НоваяСтрока = ОписанияФайлов.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаРезультата);
		
		НоваяСтрока.Адрес = ПоместитьВоВременноеХранилище(СтрокаРезультата.ДвоичныеДанные, Новый УникальныйИдентификатор);
		
		Если ЗначениеЗаполнено(НоваяСтрока.ОписаниеОшибки) Тогда
			ЕстьОшибки = Истина;
		КонецЕсли;
	КонецЦикла; 
		
	Возврат ЕстьОшибки;
	
КонецФункции

&НаКлиенте
Процедура Подключаемый_ПоказатьЗавершениеПроцесса()
	ЗаполнитьРезультатИЗакрыть();
КонецПроцедуры	

&НаКлиенте
Процедура ПрогрессВыполнения(Результат, ДополнительныеПараметры) Экспорт
	
	// Сюда не будет заходить если указан параметр РежимОтладки, так как он делает фоновое задание синхронным
	
	Если Результат.Статус = "Выполняется" Тогда
		Прогресс = ПрочитатьПрогресс(Результат.ИдентификаторЗадания);
		Если Прогресс <> Неопределено Тогда
			Процент = Прогресс.Процент;
			ИзменитьОформлениеПроцессаПреобразования(ЭтотОбъект);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПрочитатьПрогресс(ИдентификаторЗадания)
	Возврат ДлительныеОперации.ПрочитатьПрогресс(ИдентификаторЗадания);
КонецФункции

&НаКлиенте
Процедура ЗакрытьЕслиОткрыта()
	
	Если Открыта() Тогда
		Закрыть();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьРезультатИЗакрыть()
	
	Закрыть(ТаблицуЗначенийВМассивСтруктур(Ложь, Истина));

КонецПроцедуры

&НаСервере
Функция ТаблицуЗначенийВМассивСтруктур(ДобавлятьДвДанные = Ложь, БезОшибок = Истина)
	
	Результат = Новый Массив;
	Для каждого ОписаниеФайла Из ОписанияФайлов Цикл
		
		Если БезОшибок И ЗначениеЗаполнено(ОписаниеФайла.ОписаниеОшибки) Тогда
			Продолжить;
		КонецЕсли;
		
		НоваяСтрока = ОбщегоНазначения.СкопироватьРекурсивно(ШаблонОписаниеФайла);
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ОписаниеФайла);
		
		Если ДобавлятьДвДанные Тогда
			НоваяСтрока.Вставить("ДвоичныеДанные", ПолучитьИзВременногоХранилища(НоваяСтрока.Адрес));
		КонецЕсли;
		
		НоваяСтрока.ВнутреннийИдентификаторФайла = Строка(Новый УникальныйИдентификатор);
		
		Результат.Добавить(НоваяСтрока);
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция ШаблонОписаниеФайла()
	
	// Заполняем шаблон на основе таблицы формы ОписанияФайлов
	// чтобы колонки совпадали и не приходилось изменять в нескольких местах при добавлении колонок
	Таблица = ОписанияФайлов.Выгрузить();
	Таблица.Очистить();
	НоваяСтрока = Таблица.Добавить();
	
	Шаблон = Новый Структура();
	Для каждого Колонка Из Таблица.Колонки Цикл
		Шаблон.Вставить(Колонка.Имя, НоваяСтрока[Колонка.Имя]);
	КонецЦикла; 
		
	Возврат Шаблон;
	
КонецФункции
	
&НаКлиентеНаСервереБезКонтекста
Процедура ИзменитьОформлениеПроцессаПреобразования(Форма)
	
	ЭтоОшибка = Ложь;
	Элементы = Форма.Элементы;
	
	Элементы.Картинка.Видимость = ЭтоОшибка;
	Элементы.Процент.Видимость = НЕ ЭтоОшибка;
	
	Элементы.Пояснение.Заголовок = Новый ФорматированнаяСтрока(
		НСтр("ru = 'Выполняется преобразование скан-копий к ';
			|en = 'Выполняется преобразование скан-копий к '"),
		СсылкаНаТребования(),
		НСтр("ru = '.';
			|en = '.'"));
		
	Элементы.ФормаПродолжитьБезФайла.Видимость = ЭтоОшибка;
	Элементы.ФормаПродолжитьБезФайла.КнопкаПоУмолчанию = ЭтоОшибка;
	
	Элементы.ФормаОтмена.КнопкаПоУмолчанию = НЕ ЭтоОшибка;
	Элементы.ФормаОтмена.Заголовок = НСтр("ru = 'Отмена';
											|en = 'Отмена'");
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция СсылкаНаФайл(ОписаниеФайла)
	Возврат Новый ФорматированнаяСтрока(ОписаниеФайла.Имя,,,,ОписаниеФайла.ВнутреннийИдентификаторФайла);
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция СсылкаНаФайлСТирешкой(ОписаниеФайла)
	
	Возврат Новый ФорматированнаяСтрока(
		"- ",
		СсылкаНаФайл(ОписаниеФайла),
		Символы.ПС);
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция СсылкаНаТребования()
	
	Ссылка = Новый ФорматированнаяСтрока(НСтр("ru = 'требованиям';
												|en = 'требованиям'"),,,,"требования");
	Ссылка = Новый ФорматированнаяСтрока(Ссылка, " получателя");
	
	Возврат Ссылка;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ПодробнееОбОшибках()
	
	Возврат Новый ФорматированнаяСтрока(НСтр("ru = 'Подробнее об ошибках';
											|en = 'Подробнее об ошибках'"),,,,"Подробнее");
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ИзменитьОформлениеОшибки(Форма)
	
	Элементы = Форма.Элементы;
	
	Элементы.Картинка.Видимость = Истина;
	Элементы.Процент.Видимость  = Ложь;
	
	Ошибок = 0;
	Всего  = Форма.ОписанияФайлов.Количество();
	Для каждого ОписаниеФайла Из Форма.ОписанияФайлов Цикл
		Если НЕ ОписаниеФайла.Выполнено Тогда
			Ошибок = Ошибок + 1;
		КонецЕсли;
	КонецЦикла;
	
	ОднаОшибка   = Ошибок = 1;
	МногоОшибок  = Ошибок > 1;
	ВсеСОшибками = Ошибок = Всего;
	
	Если ОднаОшибка Тогда
		ПоказатьОшибкуПоОдному(Форма);
	ИначеЕсли МногоОшибок Тогда 
		ПоказатьОшибкуПоНескольким(Форма, Ошибок);
	ИначеЕсли ВсеСОшибками Тогда 
		ПоказатьОбщуюОшибкуПоКаждому(Форма);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ПоказатьОшибкуПоНескольким(Форма, Ошибок)
	
	Элементы = Форма.Элементы;
	
	Элементы.Пояснение.Заголовок = Новый ФорматированнаяСтрока(
		НСтр("ru = 'При преобразовании следующих файлов к ';
			|en = 'При преобразовании следующих файлов к '"),
		СсылкаНаТребования(),
		НСтр("ru = ' возникли ошибки:';
			|en = ' возникли ошибки:'"),
		Символы.ПС);
		
	Количество = 0;
	Для каждого ОписаниеФайла Из Форма.ОписанияФайлов Цикл
			
		Если НЕ ОписаниеФайла.Выполнено Тогда
			Количество = Количество + 1;
			ВтораяСтрока = СтрокаКрасным(ОписаниеФайла.ОписаниеОшибки);
			
			
			Если Количество <= 3 Тогда
				Элементы.Пояснение.Заголовок = Новый ФорматированнаяСтрока(
					Элементы.Пояснение.Заголовок,
					СсылкаНаФайлСТирешкой(ОписаниеФайла));
			Иначе
				Прервать;
			КонецЕсли;
				
		КонецЕсли;
			
	КонецЦикла;
	
	Если Ошибок > 3 Тогда
		
		КоличествоФайлов = ДлительнаяОтправкаКлиентСервер.ЧислоИПредметИсчисления(
			Ошибок - 3,
			НСтр("ru = 'файл';
				|en = 'файл'"),
			НСтр("ru = 'файла';
				|en = 'файла'"),
			НСтр("ru = 'файлов';
				|en = 'файлов'"),
			"м");
		
		Элементы.Пояснение.Заголовок = Новый ФорматированнаяСтрока(
			Элементы.Пояснение.Заголовок,
			НСтр("ru = 'и еще ';
				|en = 'и еще '"),
			КоличествоФайлов);
			
	КонецЕсли;
	
	ТретьяСтрока = НСтр("ru = 'Продолжить без добавления этих файлов?';
						|en = 'Продолжить без добавления этих файлов?'");
	
	Элементы.Пояснение.Заголовок = Новый ФорматированнаяСтрока(
		Элементы.Пояснение.Заголовок,
		Символы.ПС,
		Символы.ПС,
		ПодробнееОбОшибках(),
		Символы.ПС,
		Символы.ПС,
		ТретьяСтрока);
	
	Элементы.ФормаПродолжитьБезФайла.Видимость         = Истина;
	Элементы.ФормаПродолжитьБезФайла.КнопкаПоУмолчанию = Истина;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ПоказатьОшибкуПоОдному(Форма)
	
	Элементы = Форма.Элементы;
	Всего    = Форма.ОписанияФайлов.Количество();
	
	Для каждого ОписаниеФайла Из Форма.ОписанияФайлов Цикл
			
		Если НЕ ОписаниеФайла.Выполнено Тогда
			
			ПерваяСтрока = Новый ФорматированнаяСтрока(
				НСтр("ru = 'При преобразовании файла ';
					|en = 'При преобразовании файла '"),
				СсылкаНаФайл(ОписаниеФайла),
				НСтр("ru = ' к ';
					|en = ' к '"),
				СсылкаНаТребования(),
				НСтр("ru = ' возникла ошибка по причине:';
					|en = ' возникла ошибка по причине:'"));
				
			ВтораяСтрока = СтрокаКрасным(ОписаниеФайла.ОписаниеОшибки);	
			
			Если Всего > 1 Тогда
				ТретьяСтрока = НСтр("ru = 'Продолжить без добавления этого файла?';
									|en = 'Продолжить без добавления этого файла?'");
			ИНаче	
				ТретьяСтрока = "";
			КонецЕсли;
			
			Элементы.Пояснение.Заголовок = Новый ФорматированнаяСтрока(
				ПерваяСтрока,
				Символы.ПС,
				ВтораяСтрока,
				Символы.ПС,
				ТретьяСтрока);
				
		КонецЕсли;
			
	КонецЦикла;
	
	Элементы.ФормаПродолжитьБезФайла.Видимость         = Всего > 1;
	Элементы.ФормаПродолжитьБезФайла.КнопкаПоУмолчанию = Всего > 1;
	
	Элементы.ФормаОтмена.КнопкаПоУмолчанию = Всего = 1;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ПоказатьОбщуюОшибкуПоКаждому(Форма)
	
	Элементы = Форма.Элементы;
	
	Элементы.Пояснение.Заголовок = Новый ФорматированнаяСтрока(
		НСтр("ru = 'Не удалось преобразовать ни один из файлов к ';
			|en = 'Не удалось преобразовать ни один из файлов к '"),
		СсылкаНаТребования(),
		Символы.ПС,
		ПодробнееОбОшибках());;
		
	Элементы.ФормаПродолжитьБезФайла.Видимость = Ложь;
	Элементы.ФормаОтмена.КнопкаПоУмолчанию     = Истина;
	Элементы.ФормаОтмена.Заголовок             = НСтр("ru = 'Закрыть';
														|en = 'Закрыть'");
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция СтрокаКрасным(ИсходнаяСтрока)

	Возврат Новый ФорматированнаяСтрока(ИсходнаяСтрока, ,Новый Цвет(255,0,0));

КонецФункции

&НаСервере
Процедура ОбработатьПараметры(Параметры)
	
	Для каждого ОписанияФайла Из Параметры.ОписанияФайлов Цикл
		НоваяСтрока = ОписанияФайлов.Добавить();
	    ЗаполнитьЗначенияСвойств(НоваяСтрока, ОписанияФайла);
	КонецЦикла; 
	
	ИсходноеКоличество = ОписанияФайлов.Количество();
	
	ПараметрыПреобразования = Параметры.Параметры;
	ИдентификаторВладельца = Параметры.ИдентификаторВладельца;
	
КонецПроцедуры


#КонецОбласти