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
	
	КоличествоОшибок = КоличествоОшибок(ЭтотОбъект);
	Если КоличествоОшибок > 0 Тогда
		ИзменитьОформлениеОшибки(ЭтотОбъект);
	Иначе
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриОткрытииЗавершение", ЭтотОбъект);
	ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПояснениеОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "требования" Тогда
		
		ПараметрыПреобразования = ТребованияФНСКлиентСервер.ТребованияКИзображениямОтветаНаТребованиеДокументов();
		КонтекстЭДОКлиент.ПоказатьТребованияКИзображениямУниверсальная(ПараметрыПреобразования);
		
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
	
	Закрыть(Истина);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

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
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция КоличествоОшибок(Форма) Экспорт
	
	Отбор = Новый Структура();
	Отбор.Вставить("Выполнено", Ложь);
	 
	НайденныеСтроки = Форма.ОписанияФайлов.НайтиСтроки(Отбор);
		
	Возврат НайденныеСтроки.Количество();
	
КонецФункции

&НаКлиенте
Процедура ЗакрытьЕслиОткрыта()
	
	Если Открыта() Тогда
		Закрыть();
	КонецЕсли;

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
	Строка = Новый ФорматированнаяСтрока(
		Ссылка, 
		" ФНС. ",
		Символы.ПС,
		ДопустимыеРасширения());
	
	Возврат Строка;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция Жирным(Текст)
	
	Строка = Новый ФорматированнаяСтрока(Текст, Новый Шрифт(,,Истина));
	
	Возврат Строка;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ДопустимыеРасширения()
	
	Строка = Новый ФорматированнаяСтрока(
		НСтр("ru = 'Допустимые расширения файлов - ';
			|en = 'Допустимые расширения файлов - '"),
		Жирным("tif"),
		", ",
		Жирным("jpg"),
		", ",
		Жирным("pdf"),
		", ",
		Жирным("png"),
		".");
	
	Возврат Строка;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ИзменитьОформлениеОшибки(Форма)
	
	Элементы = Форма.Элементы;
	
	Ошибок = КоличествоОшибок(Форма);
	
	ОднаОшибка   = Ошибок = 1;
	МногоОшибок  = Ошибок > 1;
	ВсеСОшибками = Ошибок = Форма.ОписанияФайлов.Количество();
	
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
		НСтр("ru = 'Перенос некоторых файлов в Пакет с дополнительными документами невозможен в связи с несоответствием ';
			|en = 'Перенос некоторых файлов в Пакет с дополнительными документами невозможен в связи с несоответствием '"),
		СсылкаНаТребования(),
		":",
		Символы.ПС);
		
	Количество = 0;
	Для каждого ОписаниеФайла Из Форма.ОписанияФайлов Цикл
			
		Если НЕ ОписаниеФайла.Выполнено Тогда
			Количество = Количество + 1;
			
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
		ТретьяСтрока);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ПоказатьОшибкуПоОдному(Форма)
	
	Элементы = Форма.Элементы;
	Всего    = Форма.ОписанияФайлов.Количество();
	
	Для каждого ОписаниеФайла Из Форма.ОписанияФайлов Цикл
			
		Если НЕ ОписаниеФайла.Выполнено Тогда
			
			ПерваяСтрока = Новый ФорматированнаяСтрока(
				НСтр("ru = 'Перенос файла ';
					|en = 'Перенос файла '"),
				СсылкаНаФайл(ОписаниеФайла),
				НСтр("ru = ' в Пакет с дополнительными документами невозможен в связи с несоответствием ';
					|en = ' в Пакет с дополнительными документами невозможен в связи с несоответствием '"),
				СсылкаНаТребования());
				
			ТретьяСтрока = НСтр("ru = 'Продолжить без добавления этого файла?';
								|en = 'Продолжить без добавления этого файла?'");
			
			Элементы.Пояснение.Заголовок = Новый ФорматированнаяСтрока(
				ПерваяСтрока,
				Символы.ПС,
				Символы.ПС,
				ТретьяСтрока);
				
		КонецЕсли;
			
	КонецЦикла;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ПоказатьОбщуюОшибкуПоКаждому(Форма)
	
	Элементы = Форма.Элементы;
	
	ПерваяСтрока = Новый ФорматированнаяСтрока(
		НСтр("ru = 'Не удалось перенести ни один из файлов в Пакет с дополнительными документами в связи с несоответствием ';
			|en = 'Не удалось перенести ни один из файлов в Пакет с дополнительными документами в связи с несоответствием '"),
		СсылкаНаТребования());
		
	ТретьяСтрока = НСтр("ru = 'Продолжить без добавления этого файла?';
						|en = 'Продолжить без добавления этого файла?'");
			
		Элементы.Пояснение.Заголовок = Новый ФорматированнаяСтрока(
			ПерваяСтрока,
			Символы.ПС,
			Символы.ПС,
			ТретьяСтрока);
		
КонецПроцедуры

&НаСервере
Процедура ОбработатьПараметры(Параметры)
	
	Для каждого ОписанияФайла Из Параметры.ОписанияФайлов Цикл
		НоваяСтрока = ОписанияФайлов.Добавить();
	    ЗаполнитьЗначенияСвойств(НоваяСтрока, ОписанияФайла);
		НоваяСтрока.ВнутреннийИдентификаторФайла = Строка(Новый УникальныйИдентификатор);
	КонецЦикла; 
	
КонецПроцедуры

#КонецОбласти