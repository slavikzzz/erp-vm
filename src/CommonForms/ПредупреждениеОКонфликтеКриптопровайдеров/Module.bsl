#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Криптопровайдер1СОтчетности = Параметры.Сертификаты[0].Криптопровайдер;
	
	Отпечатки = Новый Массив;
	Для Каждого Сертификат Из Параметры.Сертификаты	Цикл
		Отпечатки.Добавить(Сертификат.Отпечаток);
	КонецЦикла;

	Количество = Параметры.Криптопровайдеры.Количество();
	ЧастиСтроки = Новый Массив;
	ЧастиСтроки.Добавить(СтрШаблон(НСтр("ru = 'На вашем компьютере одновременно установлены %1 криптопровайдера: ';
										|en = 'На вашем компьютере одновременно установлены %1 криптопровайдера: '"), Количество));
	КриптопровайдерДляДругихЦелей = Неопределено;
	Для Каждого Криптопровайдер Из Параметры.Криптопровайдеры Цикл
		ЧастиСтроки.Добавить(Новый ФорматированнаяСтрока(Криптопровайдер.Представление, Новый Шрифт("Arial",, Истина)));
		ЧастиСтроки.Добавить(", ");
		Если Криптопровайдер.ТипКриптопровайдера <> Криптопровайдер1СОтчетности.ТипКриптопровайдера
			И (Криптопровайдер.Поддерживается ИЛИ КриптопровайдерДляДругихЦелей = Неопределено) Тогда
			КриптопровайдерДляДругихЦелей = Криптопровайдер;
		КонецЕсли;
	КонецЦикла;
	ЧастиСтроки.Удалить(ЧастиСтроки.ВГраница());
	ЧастиСтроки.Добавить(".");
	
	Элементы.ТекстКриптопровайдеры.Заголовок = Новый ФорматированнаяСтрока(ЧастиСтроки);
	
	ЧастиСтроки = Новый Массив;
	ЧастиСтроки.Добавить(Новый ФорматированнаяСтрока("Рекомендации:", Новый Шрифт("Arial",, Истина)));
	ЧастиСтроки.Добавить(Символы.ПС);
	
	Если ЗначениеЗаполнено(КриптопровайдерДляДругихЦелей) Тогда
		ЧастиСтроки.Добавить("1. Если криптопровайдер ");
		ЧастиСтроки.Добавить(Новый ФорматированнаяСтрока(КриптопровайдерДляДругихЦелей.Представление, Новый Шрифт("Arial",, Истина)));
		ЧастиСтроки.Добавить(" установлен по ошибке или он более не требуется - удалите его.");
		ЧастиСтроки.Добавить(Символы.ПС);
		ЧастиСтроки.Добавить("После этого выполните переустановку криптопровайдера ");
		ЧастиСтроки.Добавить(Новый ФорматированнаяСтрока(Криптопровайдер1СОтчетности.Представление, Новый Шрифт("Arial",, Истина)));
		ЧастиСтроки.Добавить(" (используется для 1С-Отчетности).");
		ЧастиСтроки.Добавить(Символы.ПС);
		ЧастиСтроки.Добавить(Символы.ПС);
	КонецЕсли;
	
	Индекс = 2;
	Если ЗначениеЗаполнено(Криптопровайдер1СОтчетности) И ЗначениеЗаполнено(КриптопровайдерДляДругихЦелей)
		И КриптопровайдерДляДругихЦелей.Поддерживается Тогда
		ЧастиСтроки.Добавить("2. Если криптопровайдер ");
		ЧастиСтроки.Добавить(Новый ФорматированнаяСтрока(КриптопровайдерДляДругихЦелей.Представление, Новый Шрифт("Arial",, Истина)));
		ЧастиСтроки.Добавить(" требуется, например, для работы Клиент-Банка, то вы можете перейти на использование");
		ЧастиСтроки.Добавить(Символы.ПС);
		ЧастиСтроки.Добавить("единого криптопровайдера, отправив заявление на подключение к 1С-Отчетности заново.");
		ЧастиСтроки.Добавить(Символы.ПС);
		ЧастиСтроки.Добавить(Символы.ПС);
		Индекс = 3;
	КонецЕсли;
	ЧастиСтроки.Добавить(СтрШаблон("%1. Настройте отправку 1С-Отчетности с другого компьютера по ", Индекс));
	ЧастиСтроки.Добавить(Новый ФорматированнаяСтрока("инструкции",,,, "http://its.1c.ru/bmk/elreps/comp2"));
	ЧастиСтроки.Добавить(".");
	ЧастиСтроки.Добавить(Символы.ПС);
	ЧастиСтроки.Добавить(Символы.ПС);
	
	Индекс = Индекс + 1;
	Если ЭлектроннаяПодписьВМоделиСервиса.ИспользованиеВозможно() Тогда
		ЧастиСтроки.Добавить(СтрШаблон("%1. Перейти на использование ", Индекс));
		ЧастиСтроки.Добавить(Новый ФорматированнаяСтрока("Электронной подписи в программе",,,, "https://1cfresh.com/articles/ES-key_storage_in_cloud"));
		ЧастиСтроки.Добавить(".");
		ЧастиСтроки.Добавить(Символы.ПС);
		ЧастиСтроки.Добавить(Символы.ПС);
		Индекс = Индекс + 1;
	КонецЕсли;
	
	Индекс = Индекс + 1;
	Если КриптографияЭДКО.ИспользованиеОблачнойПодписиВозможно()  Тогда
		ЧастиСтроки.Добавить(СтрШаблон("%1. Перейти на использование ", Индекс));
		ЧастиСтроки.Добавить(Новый ФорматированнаяСтрока("""Облачной"" подписи",,,, "https://1cfresh.com/articles/ES-key_storage_in_cloud"));
		ЧастиСтроки.Добавить(".");
		ЧастиСтроки.Добавить(Символы.ПС);
		ЧастиСтроки.Добавить(Символы.ПС);
		Индекс = Индекс + 1;
	КонецЕсли;
	
	Если ЕстьСертификат1СОтчетности(Отпечатки) Тогда
		ЧастиСтроки.Добавить(СтрШаблон("%1. Обратиться в техподдержку 1С-Отчетности по т. 8 800 700-86-68.", Индекс));
		ЧастиСтроки.Добавить(Символы.ПС);
		ЧастиСтроки.Добавить(Символы.ПС);
	КонецЕсли;
	
	Элементы.ТекстРекомендации.Заголовок = Новый ФорматированнаяСтрока(ЧастиСтроки);
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ТекущийЭлемент = Элементы.ФормаЗакрыть;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура БольшеНеПоказыватьПриИзменении(Элемент)
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура НеПоказыватьБольшеЭтоПредупреждение(Команда)
	
	НеПоказыватьБольшеЭтоПредупреждениеНаСервере(БольшеНеПоказывать);
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Элементы = Форма.Элементы;
	Элементы.ФормаНеПоказыватьБольшеЭтоПредупреждение.Доступность = Форма.БольшеНеПоказывать;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура НеПоказыватьБольшеЭтоПредупреждениеНаСервере(БольшеНеПоказывать)
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("ПредупреждениеОКонфликтеКриптопровайдеров", "БольшеНеПоказывать", БольшеНеПоказывать);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЕстьСертификат1СОтчетности(Сертификаты)
	
	Результат = Мультирежим.УчетныеЗаписиПоСертификатам(Сертификаты);
	Возврат Результат.Количество() > 0;
	
КонецФункции

#КонецОбласти