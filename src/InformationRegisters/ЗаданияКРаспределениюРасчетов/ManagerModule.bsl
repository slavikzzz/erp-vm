#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

#Область ОбновлениеИнформационнойБазы

// Добавляет в список процедуры-обработчики обновления данных ИБ
// для всех поддерживаемых версий библиотеки или конфигурации.
// Вызывается перед началом обновления данных ИБ для построения плана обновления.
//
//  Обработчики - ТаблицаЗначений - описание полей, см. в процедуре
//                ОбновлениеИнформационнойБазы.НоваяТаблицаОбработчиковОбновления.
//
// Пример добавления процедуры-обработчика в список:
//  Обработчик = Обработчики.Добавить();
//  Обработчик.Версия              = "1.1.0.0";
//  Обработчик.Процедура           = "ОбновлениеИБ.ПерейтиНаВерсию_1_1_0_0";
//  Обработчик.МонопольныйРежим    = Ложь;
//
// Параметры:
// 	Обработчики - см. ОбновлениеИнформационнойБазы.НоваяТаблицаОбработчиковОбновления
//
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт

	Обработчик = Обработчики.Добавить();
	Обработчик.Процедура = "РегистрыСведений.ЗаданияКРаспределениюРасчетов.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	Обработчик.Версия = "11.5.14.13";
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Идентификатор = Новый УникальныйИдентификатор("bce28808-488b-45ae-9d61-5f0641e7689f");
	Обработчик.Многопоточный = Истина;
	Обработчик.ПроцедураЗаполненияДанныхОбновления = "РегистрыСведений.ЗаданияКРаспределениюРасчетов.ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию";
	Обработчик.ПроцедураПроверки = "ОбновлениеИнформационнойБазы.ДанныеОбновленыНаНовуюВерсиюПрограммы";
	Обработчик.Порядок = Перечисления.ПорядокОбработчиковОбновления.Обычный;
	Обработчик.Комментарий = НСтр("ru = 'Перезаполняет регистры плановых оплат и отгрузок по части записей.';
									|en = 'Refills registers of scheduled payments and shipments based on some of the records.'");
	
	Читаемые = Новый Массив;
	Читаемые.Добавить(Метаданные.РегистрыНакопления.РасчетыСКлиентами.ПолноеИмя());
	Читаемые.Добавить(Метаданные.РегистрыНакопления.РасчетыСКлиентамиПланОплат.ПолноеИмя());
	Читаемые.Добавить(Метаданные.РегистрыНакопления.РасчетыСКлиентамиПоСрокам.ПолноеИмя());
	Читаемые.Добавить(Метаданные.РегистрыНакопления.РасчетыСКлиентамиПланОтгрузок.ПолноеИмя());
	Читаемые.Добавить(Метаданные.РегистрыНакопления.РасчетыСПоставщиками.ПолноеИмя());
	Читаемые.Добавить(Метаданные.РегистрыНакопления.РасчетыСПоставщикамиПланОплат.ПолноеИмя());
	Читаемые.Добавить(Метаданные.РегистрыНакопления.РасчетыСПоставщикамиПоСрокам.ПолноеИмя());
	Читаемые.Добавить(Метаданные.РегистрыНакопления.РасчетыСПоставщикамиПланПоставок.ПолноеИмя());
	Читаемые.Добавить(Метаданные.РегистрыСведений.ВспомогательнаяИнформацияВзаиморасчетов.ПолноеИмя());
	Обработчик.ЧитаемыеОбъекты = СтрСоединить(Читаемые, ",");
	
	Изменяемые = Новый Массив;
	Изменяемые.Добавить(Метаданные.РегистрыНакопления.РасчетыСКлиентамиПланОплат.ПолноеИмя());
	Изменяемые.Добавить(Метаданные.РегистрыНакопления.РасчетыСПоставщикамиПланОплат.ПолноеИмя());
	Изменяемые.Добавить(Метаданные.РегистрыНакопления.РасчетыСКлиентамиПланОтгрузок.ПолноеИмя());
	Изменяемые.Добавить(Метаданные.РегистрыНакопления.РасчетыСПоставщикамиПланПоставок.ПолноеИмя());
	Изменяемые.Добавить(Метаданные.РегистрыСведений.ЗаданияКРаспределениюРасчетов.ПолноеИмя());
	Обработчик.ИзменяемыеОбъекты = СтрСоединить(Изменяемые, ",");
	
	Обработчик.ПриоритетыВыполнения = ОбновлениеИнформационнойБазы.ПриоритетыВыполненияОбработчика();
	
	НоваяСтрока = Обработчик.ПриоритетыВыполнения.Добавить();
	НоваяСтрока.Процедура = "РегистрыНакопления.РасчетыСКлиентами.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	НоваяСтрока.Порядок = "После";

	НоваяСтрока = Обработчик.ПриоритетыВыполнения.Добавить();
	НоваяСтрока.Процедура = "РегистрыНакопления.РасчетыСПоставщиками.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	НоваяСтрока.Порядок = "После";
	
	НоваяСтрока = Обработчик.ПриоритетыВыполнения.Добавить();
	НоваяСтрока.Процедура = "РегистрыНакопления.РасчетыСКлиентамиПланОплат.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	НоваяСтрока.Порядок = "После";

	НоваяСтрока = Обработчик.ПриоритетыВыполнения.Добавить();
	НоваяСтрока.Процедура = "РегистрыНакопления.РасчетыСКлиентамиПланОтгрузок.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	НоваяСтрока.Порядок = "После";
	
	НоваяСтрока = Обработчик.ПриоритетыВыполнения.Добавить();
	НоваяСтрока.Процедура = "РегистрыНакопления.РасчетыСПоставщикамиПланОплат.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	НоваяСтрока.Порядок = "После";

	НоваяСтрока = Обработчик.ПриоритетыВыполнения.Добавить();
	НоваяСтрока.Процедура = "РегистрыНакопления.РасчетыСПоставщикамиПланПоставок.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	НоваяСтрока.Порядок = "После";
	
	НоваяСтрока = Обработчик.ПриоритетыВыполнения.Добавить();
	НоваяСтрока.Процедура = "РегистрыНакопления.ЗаданияКРаспределениюРасчетов.ОбработатьДанныеДляПереходаНаНовуюВерсиюУдалитьДублированиеСтрок";
	НоваяСтрока.Порядок = "До";

	Обработчик = Обработчики.Добавить();
	Обработчик.Процедура = "РегистрыСведений.ЗаданияКРаспределениюРасчетов.ОбработатьДанныеДляПереходаНаНовуюВерсиюУдалитьДублированиеСтрок";
	Обработчик.Версия = "11.5.14.17";
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Идентификатор = Новый УникальныйИдентификатор("a763cfbb-f94f-4c67-8e13-0e96a3a7f353");
	Обработчик.Многопоточный = Истина;
	Обработчик.ПроцедураЗаполненияДанныхОбновления = "РегистрыСведений.ЗаданияКРаспределениюРасчетов.ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсиюУдалитьДублированиеСтрок";
	Обработчик.ПроцедураПроверки = "ОбновлениеИнформационнойБазы.ДанныеОбновленыНаНовуюВерсиюПрограммы";
	Обработчик.Порядок = Перечисления.ПорядокОбработчиковОбновления.НеКритичный;
	Обработчик.Комментарий = НСтр("ru = 'Перезаполняет задания к распределению расчетов по части записей.';
									|en = 'Refills jobs for allocating AR/AP by some records.'");
	Читаемые = Новый Массив;
	Читаемые.Добавить(Метаданные.РегистрыНакопления.РасчетыСКлиентами.ПолноеИмя());
	Читаемые.Добавить(Метаданные.РегистрыНакопления.РасчетыСКлиентамиПланОплат.ПолноеИмя());
	Читаемые.Добавить(Метаданные.РегистрыНакопления.РасчетыСКлиентамиПоСрокам.ПолноеИмя());
	Читаемые.Добавить(Метаданные.РегистрыНакопления.РасчетыСКлиентамиПланОтгрузок.ПолноеИмя());
	Читаемые.Добавить(Метаданные.РегистрыНакопления.РасчетыСПоставщиками.ПолноеИмя());
	Читаемые.Добавить(Метаданные.РегистрыНакопления.РасчетыСПоставщикамиПланОплат.ПолноеИмя());
	Читаемые.Добавить(Метаданные.РегистрыНакопления.РасчетыСПоставщикамиПоСрокам.ПолноеИмя());
	Читаемые.Добавить(Метаданные.РегистрыНакопления.РасчетыСПоставщикамиПланПоставок.ПолноеИмя());
	Читаемые.Добавить(Метаданные.РегистрыСведений.ВспомогательнаяИнформацияВзаиморасчетов.ПолноеИмя());
	Читаемые.Добавить(Метаданные.РегистрыСведений.ЗаданияКРаспределениюРасчетов.ПолноеИмя());
	Обработчик.ЧитаемыеОбъекты = СтрСоединить(Читаемые, ",");
	
	Изменяемые = Новый Массив;
	Изменяемые.Добавить(Метаданные.РегистрыСведений.ЗаданияКРаспределениюРасчетов.ПолноеИмя());
	Обработчик.ИзменяемыеОбъекты = СтрСоединить(Изменяемые, ",");
	
	Блокируемые = Новый Массив;
	Блокируемые.Добавить(Метаданные.РегистрыСведений.ЗаданияКРаспределениюРасчетов.ПолноеИмя());
	Обработчик.БлокируемыеОбъекты = СтрСоединить(Блокируемые, ",");
	Обработчик.ПриоритетыВыполнения = ОбновлениеИнформационнойБазы.ПриоритетыВыполненияОбработчика();
	
КонецПроцедуры

Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ПараметрыВыборки = Параметры.ПараметрыВыборки;
	ПараметрыВыборки.ПолныеИменаРегистров = "РегистрСведений.ЗаданияКРаспределениюРасчетов";
	ПараметрыВыборки.СпособВыборки = ОбновлениеИнформационнойБазы.СпособВыборкиИзмеренияНезависимогоРегистраСведений();
	
	Если НЕ Константы.НоваяАрхитектураВзаиморасчетов.Получить() Тогда
		Возврат;
	КонецЕсли;
	
	ДополнительныеПараметры = ОбновлениеИнформационнойБазы.ДополнительныеПараметрыОтметкиОбработки();
	ДополнительныеПараметры.Вставить("ЭтоНезависимыйРегистрСведений", Истина);
	ДополнительныеПараметры.Вставить("ПолноеИмяРегистра", "РегистрСведений.ЗаданияКРаспределениюРасчетов");
	
	Запрос = Новый Запрос();
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.Текст = "
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ЗНАЧЕНИЕ(Перечисление.ТипыРасчетовСПартнерами.РасчетыСКлиентом) КАК ТипРасчетов,
		|	Регистр.АналитикаУчетаПоПартнерам КАК АналитикаУчетаПоПартнерам,
		|	Регистр.ОбъектРасчетов КАК ОбъектРасчетов,
		|	Регистр.Валюта КАК Валюта
		|ПОМЕСТИТЬ ВтДанныеДляПересчета
		|ИЗ
		|	РегистрНакопления.РасчетыСКлиентамиПланОплат КАК Регистр
		|ГДЕ
		|	Регистр.УдалитьХозяйственнаяОперация <> ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПустаяСсылка)
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ЗНАЧЕНИЕ(Перечисление.ТипыРасчетовСПартнерами.РасчетыСПоставщиком) КАК ТипРасчетов,
		|	Регистр.АналитикаУчетаПоПартнерам КАК АналитикаУчетаПоПартнерам,
		|	Регистр.ОбъектРасчетов КАК ОбъектРасчетов,
		|	Регистр.Валюта КАК Валюта
		|ИЗ
		|	РегистрНакопления.РасчетыСПоставщикамиПланОплат КАК Регистр
		|ГДЕ
		|	Регистр.УдалитьХозяйственнаяОперация <> ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПустаяСсылка)
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ЗНАЧЕНИЕ(Перечисление.ТипыРасчетовСПартнерами.РасчетыСКлиентом) КАК ТипРасчетов,
		|	Регистр.АналитикаУчетаПоПартнерам КАК АналитикаУчетаПоПартнерам,
		|	Регистр.ОбъектРасчетов КАК ОбъектРасчетов,
		|	Регистр.Валюта КАК Валюта
		|ИЗ
		|	РегистрНакопления.РасчетыСКлиентамиПланОтгрузок КАК Регистр
		|ГДЕ
		|	Регистр.УдалитьПорядокЗачета <> """"
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ЗНАЧЕНИЕ(Перечисление.ТипыРасчетовСПартнерами.РасчетыСПоставщиком) КАК ТипРасчетов,
		|	Регистр.АналитикаУчетаПоПартнерам КАК АналитикаУчетаПоПартнерам,
		|	Регистр.ОбъектРасчетов КАК ОбъектРасчетов,
		|	Регистр.Валюта КАК Валюта
		|ИЗ
		|	РегистрНакопления.РасчетыСПоставщикамиПланПоставок КАК Регистр
		|ГДЕ
		|	Регистр.УдалитьПорядокЗачета <> """"
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	ТипРасчетов,
		|	АналитикаУчетаПоПартнерам,
		|	ОбъектРасчетов,
		|	Валюта
		|;
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	Данные.ТипРасчетов КАК ТипРасчетов,
		|	Данные.АналитикаУчетаПоПартнерам КАК АналитикаУчетаПоПартнерам
		|ИЗ ВтДанныеДляПересчета КАК Данные";
		
	ТекстЗапросаДанныхДляЗаписи = "
		|ВЫБРАТЬ
		|	Данные.ТипРасчетов КАК ТипРасчетов,
		|	Данные.АналитикаУчетаПоПартнерам КАК АналитикаУчетаПоПартнерам,
		|	Данные.ОбъектРасчетов КАК ОбъектРасчетов,
		|	Данные.Валюта КАК Валюта,
		|	Неопределено КАК Документ,
		|	МИНИМУМ(ЕСТЬNULL(Задания.ДатаПересчета,ДАТАВРЕМЯ(3000,1,1))) КАК ДатаПересчета,
		|	ДАТАВРЕМЯ(1,1,1) КАК ДатаПересчетаПлан
		|ИЗ
		|	ВтДанныеДляПересчета КАК Данные
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЗаданияКРаспределениюРасчетов КАК Задания
		|			ПО Задания.ТипРасчетов = Данные.ТипРасчетов
		|				И Задания.АналитикаУчетаПоПартнерам = Данные.АналитикаУчетаПоПартнерам
		|				И Задания.ОбъектРасчетов = Данные.ОбъектРасчетов
		|				И Задания.Валюта = Данные.Валюта
		|СГРУППИРОВАТЬ ПО
		|	Данные.ТипРасчетов,
		|	Данные.АналитикаУчетаПоПартнерам,
		|	Данные.ОбъектРасчетов,
		|	Данные.Валюта
		|";
	
	ЗапросДанных = Новый Запрос(ТекстЗапросаДанныхДляЗаписи);
	ЗапросДанных.МенеджерВременныхТаблиц = Запрос.МенеджерВременныхТаблиц ;
	ПоляПоиска = "ТипРасчетов,АналитикаУчетаПоПартнерам";
	СтруктураПоиска = Новый Структура(ПоляПоиска);
	
	НачатьТранзакцию();
	
	Попытка
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ЗаданияКРаспределениюРасчетов");
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
		Блокировка.Заблокировать();
		
		ВыборкаАналитика = Запрос.Выполнить().Выбрать();
		
		ДанныеДляЗаписи = ЗапросДанных.Выполнить().Выгрузить();
		ДанныеДляЗаписи.Индексы.Добавить(ПоляПоиска);
		
		Пока ВыборкаАналитика.Следующий() Цикл
			
			НаборЗаписей = СоздатьНаборЗаписей();
			НаборЗаписей.Отбор.ТипРасчетов.Установить(ВыборкаАналитика.ТипРасчетов);
			НаборЗаписей.Отбор.АналитикаУчетаПоПартнерам.Установить(ВыборкаАналитика.АналитикаУчетаПоПартнерам);
			ЗаполнитьЗначенияСвойств(СтруктураПоиска, ВыборкаАналитика);
			
			НаборЗаписей.Загрузить(ДанныеДляЗаписи.Скопировать(СтруктураПоиска));
			
			НаборЗаписей.Записать();
		КонецЦикла;
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение(ОписаниеОшибки());
	КонецПопытки;
	
	Запрос.Текст =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ЗаданияКРаспределениюРасчетов.ТипРасчетов КАК ТипРасчетов,
		|	ЗаданияКРаспределениюРасчетов.АналитикаУчетаПоПартнерам КАК АналитикаУчетаПоПартнерам,
		|	ЗаданияКРаспределениюРасчетов.ОбъектРасчетов КАК ОбъектРасчетов,
		|	ЗаданияКРаспределениюРасчетов.Валюта КАК Валюта
		|ИЗ
		|	РегистрСведений.ЗаданияКРаспределениюРасчетов КАК ЗаданияКРаспределениюРасчетов
		|ГДЕ
		|	ЗаданияКРаспределениюРасчетов.ДатаПересчетаПлан <> ДАТАВРЕМЯ(3000,1,1)";
		
	РегистрируемыеКортежи = Запрос.Выполнить().Выгрузить();
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, РегистрируемыеКортежи, ДополнительныеПараметры);
	
КонецПроцедуры

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	Если ОбновлениеИнформационнойБазы.ЕстьДанныеДляОбработки(Неопределено, Метаданные.РегистрыНакопления.РасчетыСКлиентами)
		ИЛИ ОбновлениеИнформационнойБазы.ЕстьДанныеДляОбработки(Неопределено, Метаданные.РегистрыНакопления.РасчетыСПоставщиками)
		ИЛИ ОбновлениеИнформационнойБазы.ЕстьДанныеДляОбработки(Неопределено, Метаданные.РегистрыНакопления.РасчетыСКлиентамиПланОплат)
		ИЛИ ОбновлениеИнформационнойБазы.ЕстьДанныеДляОбработки(Неопределено, Метаданные.РегистрыНакопления.РасчетыСПоставщикамиПланОплат)
		ИЛИ ОбновлениеИнформационнойБазы.ЕстьДанныеДляОбработки(Неопределено, Метаданные.РегистрыНакопления.РасчетыСКлиентамиПланОтгрузок)
		ИЛИ ОбновлениеИнформационнойБазы.ЕстьДанныеДляОбработки(Неопределено, Метаданные.РегистрыНакопления.РасчетыСПоставщикамиПланПоставок) Тогда
		Параметры.ОбработкаЗавершена = ОбновлениеПредшествующихДанныхЗавершено();
		Возврат;
	КонецЕсли;
	
	ПолноеИмяОбъекта = "РегистрСведений.ЗаданияКРаспределениюРасчетов";
	Если Не ОбновлениеИнформационнойБазы.ЕстьДанныеДляОбработки(Параметры.Очередь, ПолноеИмяОбъекта) Тогда
		Параметры.ОбработкаЗавершена = Истина;
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	ОбновляемыеДанные = ОбновлениеИнформационнойБазы.ДанныеДляОбновленияВМногопоточномОбработчике(Параметры);
	Если ОбновляемыеДанные.Количество() = 0 Тогда
		Параметры.ОбработкаЗавершена = Ложь;
		Возврат;
	КонецЕсли;
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Данные.ТипРасчетов КАК ТипРасчетов,
	|	Данные.АналитикаУчетаПоПартнерам КАК АналитикаУчетаПоПартнерам,
	|	Данные.ОбъектРасчетов КАК ОбъектРасчетов,
	|	Данные.Валюта КАК Валюта,
	|	Данные.Документ КАК Документ
	|ПОМЕСТИТЬ ВтДанныеДляОбработки
	|ИЗ &ОбновляемыеДанные КАК Данные
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ТипРасчетов,
	|	АналитикаУчетаПоПартнерам,
	|	Валюта,
	|	ОбъектРасчетов
	|;
	|ВЫБРАТЬ 
	|	ВТДляОбработки.ТипРасчетов = ЗНАЧЕНИЕ(Перечисление.ТипыРасчетовСПартнерами.РасчетыСКлиентом) КАК ЭтоРасчетыСКлиентами,
	|	ВТДляОбработки.ТипРасчетов КАК ТипРасчетов,
	|	ВТДляОбработки.АналитикаУчетаПоПартнерам КАК АналитикаУчетаПоПартнерам,
	|	ВТДляОбработки.ОбъектРасчетов КАК ОбъектРасчетов,
	|	ВТДляОбработки.ОбъектРасчетов.Объект КАК Объект,
	|	ВТДляОбработки.Валюта КАК ВалютаРасчетов,
	|	ЗНАЧЕНИЕ(Справочник.КлючиАналитикиУчетаПоПартнерам.ПустаяСсылка) КАК АналитикаУчетаПоПартнерамПриемник,
	|	ЗНАЧЕНИЕ(Справочник.ОбъектыРасчетов.ПустаяСсылка) КАК ОбъектРасчетовПриемник,
	|	ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка) КАК ВалютаПриемник,
	|	ВТДляОбработки.Документ КАК Документ,
	|	1 КАК Приоритет,
	|	ЛОЖЬ КАК ПоДаннымОбъектаРасчетовИсточника,
	|	МИНИМУМ(ЕСТЬNULL(Задания.ДатаПересчета, ДАТАВРЕМЯ(3000,1,1))) КАК ДатаПересчета,
	|	МИНИМУМ(ЕСТЬNULL(Задания.ДатаПересчетаПлан, ДАТАВРЕМЯ(3000,1,1))) КАК ДатаПересчетаПлан,
	|	СУММА(ЕСТЬNULL(Задания.КоличествоДокументов,0)) КАК КоличествоДокументов
	|ИЗ
	|	ВтДанныеДляОбработки КАК ВТДляОбработки
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЗаданияКРаспределениюРасчетов КАК Задания
	|			ПО ВТДляОбработки.ТипРасчетов = Задания.ТипРасчетов
	|				И ВТДляОбработки.АналитикаУчетаПоПартнерам = Задания.АналитикаУчетаПоПартнерам
	|				И ВТДляОбработки.ОбъектРасчетов = Задания.ОбъектРасчетов
	|				И ВТДляОбработки.Валюта = Задания.Валюта
	|ГДЕ
	|	ЕСТЬNULL(Задания.Обработка,0) = 0
	|
	|СГРУППИРОВАТЬ ПО
	|	ВТДляОбработки.ТипРасчетов,
	|	ВТДляОбработки.АналитикаУчетаПоПартнерам,
	|	ВТДляОбработки.ОбъектРасчетов,
	|	ВТДляОбработки.ОбъектРасчетов.Объект,
	|	ВТДляОбработки.Валюта,
	|	ВТДляОбработки.Документ
	|";
	
	Запрос.УстановитьПараметр("ОбновляемыеДанные", ОбновляемыеДанные);
	
	//Блокировка на весь массив не нужна, если запись добавится то пересчитается еще один раз.
	//Цель обработки сделать пересчет хотя бы один раз.
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	ДанныеКОбработке = Результат.Выгрузить();
	ДанныеКОбработке.Очистить();
	ДанныеКОбработке.Колонки.Добавить("ПорядокОбработки", ОбщегоНазначения.ОписаниеТипаЧисло(15,0));
	ДанныеКОбработке.Индексы.Добавить("ПорядокОбработки");
	
	ПорцияДанныхКОбработке = ДанныеКОбработке.СкопироватьКолонки();
	
	Запрос.Текст = ОперативныеВзаиморасчетыСервер.ТекстЗапросаКоличествоЗаписейВОперативныхРегистрахВзаиморасчетов("ВтДанныеДляОбработки");
	ЧислоЗаписейВРегистрахПоОбъектамРасчетов = Запрос.Выполнить().Выгрузить();
	ЧислоЗаписейВРегистрахПоОбъектамРасчетов.Индексы.Добавить("АналитикаУчетаПоПартнерам, ОбъектРасчетов, Валюта");
	
	РазмерПорцииОбработкиЗаписей = 10000;
	РазмерТекущейПорции = 0;
	ПорядокОбработки = 1;
	
	Пока Выборка.Следующий() Цикл
		
		Если Выборка.ДатаПересчета = Дата(3000,1,1) И Выборка.ДатаПересчетаПлан = Дата(3000,1,1) Тогда
			
			СтрокаКОбработке = ДанныеКОбработке.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаКОбработке, Выборка);
			СтрокаКОбработке.ПорядокОбработки = 0;
			
		Иначе
			
			СтруктураОтбора = Новый Структура;
			СтруктураОтбора.Вставить("АналитикаУчетаПоПартнерам", Выборка.АналитикаУчетаПоПартнерам);
			СтруктураОтбора.Вставить("ОбъектРасчетов", Выборка.ОбъектРасчетов);
			СтруктураОтбора.Вставить("Валюта", Выборка.ВалютаРасчетов);
			
			ЗаписиПоОбъектуРасчетов = ЧислоЗаписейВРегистрахПоОбъектамРасчетов.НайтиСтроки(СтруктураОтбора);
			ЧислоЗаписейВРегистрахПоОбъектуРасчетов = ?(ЗаписиПоОбъектуРасчетов.Количество() > 0,
				ЗаписиПоОбъектуРасчетов[0].КоличествоЗаписей, 0);
					
			Если НЕ РазмерТекущейПорции = 0 
				И (РазмерТекущейПорции + ЧислоЗаписейВРегистрахПоОбъектуРасчетов) > РазмерПорцииОбработкиЗаписей Тогда
				
				ПорядокОбработки = ПорядокОбработки + 1;
				РазмерТекущейПорции = 0;
				
			КонецЕсли;
			
			СтрокаКОбработке = ДанныеКОбработке.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаКОбработке, Выборка);
			СтрокаКОбработке.ПорядокОбработки = ПорядокОбработки;

			РазмерТекущейПорции = РазмерТекущейПорции + ЧислоЗаписейВРегистрахПоОбъектуРасчетов;

		КонецЕсли;
		
	КонецЦикла;
	
	Для ТекущийПорядокОбработки = 0 По ПорядокОбработки Цикл

		СтрокиКОбработке = ДанныеКОбработке.НайтиСтроки(Новый Структура("ПорядокОбработки", ТекущийПорядокОбработки));
		
		ПорцияДанныхКОбработке.Очистить();

		Для Каждого СтрокаКОбработке Из СтрокиКОбработке Цикл

				Если СтрокаКОбработке.ПорядокОбработки = 0 Тогда

					НаборЗаписей = СоздатьНаборЗаписей();
					НаборЗаписей.Отбор.ТипРасчетов.Установить(СтрокаКОбработке.ТипРасчетов);
					НаборЗаписей.Отбор.АналитикаУчетаПоПартнерам.Установить(СтрокаКОбработке.АналитикаУчетаПоПартнерам);
					НаборЗаписей.Отбор.ОбъектРасчетов.Установить(СтрокаКОбработке.ОбъектРасчетов);
					НаборЗаписей.Отбор.Валюта.Установить(СтрокаКОбработке.ВалютаРасчетов);
					ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(НаборЗаписей);

				Иначе
					
					ЗаполнитьЗначенияСвойств(ПорцияДанныхКОбработке.Добавить(), СтрокаКОбработке);
					
				КонецЕсли;

		КонецЦикла;

		Если ПорцияДанныхКОбработке.Количество() > 0 Тогда
			
			НачатьТранзакцию();

			Попытка
				
				Блокировка = Новый БлокировкаДанных;
				
				// Блокировка регистра распределения расчетов.
				ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ЗаданияКРаспределениюРасчетов");
				ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
				ЭлементБлокировки.ИсточникДанных = ПорцияДанныхКОбработке;
				ЭлементБлокировки.ИспользоватьИзИсточникаДанных("ТипРасчетов", "ТипРасчетов");
				ЭлементБлокировки.ИспользоватьИзИсточникаДанных("АналитикаУчетаПоПартнерам", "АналитикаУчетаПоПартнерам");
				ЭлементБлокировки.ИспользоватьИзИсточникаДанных("ОбъектРасчетов", "ОбъектРасчетов");
				ЭлементБлокировки.ИспользоватьИзИсточникаДанных("Валюта", "ВалютаРасчетов");
				
				Блокировка.Заблокировать();
				
				ОперативныеВзаиморасчетыСервер.ВыполнитьОтложенноеРаспределение(Новый Структура("ДанныеКОбработке", ПорцияДанныхКОбработке));
				
				Для каждого СтрокаКОбработке Из ПорцияДанныхКОбработке Цикл
					НаборЗаписей = СоздатьНаборЗаписей();
					НаборЗаписей.Отбор.ТипРасчетов.Установить(СтрокаКОбработке.ТипРасчетов);
					НаборЗаписей.Отбор.АналитикаУчетаПоПартнерам.Установить(СтрокаКОбработке.АналитикаУчетаПоПартнерам);
					НаборЗаписей.Отбор.ОбъектРасчетов.Установить(СтрокаКОбработке.ОбъектРасчетов);
					НаборЗаписей.Отбор.Валюта.Установить(СтрокаКОбработке.ВалютаРасчетов);
					ОбновлениеИнформационнойБазы.ЗаписатьНаборЗаписей(НаборЗаписей);
				КонецЦикла;
					
				ЗафиксироватьТранзакцию();

			Исключение

				ОтменитьТранзакцию();
				ВызватьИсключение (ОписаниеОшибки());

			КонецПопытки;
			
		КонецЕсли;

	КонецЦикла;
	
	Параметры.ОбработкаЗавершена = ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(Параметры.Очередь, ПолноеИмяОбъекта);
	
КонецПроцедуры

Функция ОбновлениеПредшествующихДанныхЗавершено()
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("РежимВыполнения", Перечисления.РежимыВыполненияОбработчиков.Отложенно);
	ТекстЗапроса =
		"ВЫБРАТЬ
		|	ОбработчикиОбновления.ИмяОбработчика КАК ИмяОбработчика,
		|	ОбработчикиОбновления.Статус КАК Статус
		|ИЗ
		|	РегистрСведений.ОбработчикиОбновления КАК ОбработчикиОбновления
		|ГДЕ
		|	ОбработчикиОбновления.ИмяОбработчика В (
		|		&РасчетыСКлиентами,
		|		&РасчетыСКлиентамиПланОплат,
		|		&РасчетыСКлиентамиПланОтгрузок,
		|		&РасчетыСПоставщиками,
		|		&РасчетыСПоставщикамиПланОплат,
		|		&РасчетыСПоставщикамиПланПоставок)
		|	И ОбработчикиОбновления.Статус В (
		|		ЗНАЧЕНИЕ(Перечисление.СтатусыОбработчиковОбновления.Ошибка))
		|
		|СГРУППИРОВАТЬ ПО
		|	ОбработчикиОбновления.Статус,
		|	ОбработчикиОбновления.ИмяОбработчика";
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&РасчетыСКлиентамиПланОплат", """РегистрыНакопления.РасчетыСКлиентамиПланОплат.ОбработатьДанныеДляПереходаНаНовуюВерсию""");
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&РасчетыСКлиентамиПланОтгрузок", """РегистрыНакопления.РасчетыСКлиентамиПланОтгрузок.ОбработатьДанныеДляПереходаНаНовуюВерсию""");
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&РасчетыСКлиентами", """РегистрыНакопления.РасчетыСКлиентами.ОбработатьДанныеДляПереходаНаНовуюВерсию""");
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&РасчетыСПоставщикамиПланОплат", """РегистрыНакопления.РасчетыСПоставщикамиПланОплат.ОбработатьДанныеДляПереходаНаНовуюВерсию""");
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&РасчетыСПоставщикамиПланПоставок", """РегистрыНакопления.РасчетыСПоставщикамиПланПоставок.ОбработатьДанныеДляПереходаНаНовуюВерсию""");
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&РасчетыСПоставщиками", """РегистрыНакопления.РасчетыСПоставщиками.ОбработатьДанныеДляПереходаНаНовуюВерсию""");
	Запрос.Текст = ТекстЗапроса;

	СтатусыОбработчиков = Запрос.Выполнить().Выгрузить();
	
	Для Каждого Обработчик Из СтатусыОбработчиков Цикл
		
		ТекстСообщения = НСтр("ru = 'Обновление зависимых данных завершено с ошибкой.
		|Не выполнен обработчик обновления';
		|en = 'Dependent data update completed with an error.
		|The update handler is not performed'") + " """ + Обработчик.ИмяОбработчика + """";
		
		ВызватьИсключение ТекстСообщения;
		
	КонецЦикла;
	
	Возврат Ложь;
	
КонецФункции

Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсиюУдалитьДублированиеСтрок(Параметры) Экспорт
	
	ПараметрыВыборки = Параметры.ПараметрыВыборки;
	ПараметрыВыборки.ПолныеИменаРегистров = "РегистрСведений.ЗаданияКРаспределениюРасчетов";
	ПараметрыВыборки.СпособВыборки = ОбновлениеИнформационнойБазы.СпособВыборкиИзмеренияНезависимогоРегистраСведений();
	
	ДополнительныеПараметры = ОбновлениеИнформационнойБазы.ДополнительныеПараметрыОтметкиОбработки();
	ДополнительныеПараметры.Вставить("ЭтоНезависимыйРегистрСведений", Истина);
	ДополнительныеПараметры.Вставить("ПолноеИмяРегистра", "РегистрСведений.ЗаданияКРаспределениюРасчетов");
	
	Запрос = Новый Запрос();
	Запрос.Текст =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ЗаданияКРаспределениюРасчетов.ТипРасчетов КАК ТипРасчетов,
		|	ЗаданияКРаспределениюРасчетов.АналитикаУчетаПоПартнерам КАК АналитикаУчетаПоПартнерам,
		|	ЗаданияКРаспределениюРасчетов.ОбъектРасчетов КАК ОбъектРасчетов,
		|	ЗаданияКРаспределениюРасчетов.Валюта КАК Валюта,
		|	ЗаданияКРаспределениюРасчетов.Документ КАК Документ,
		|	ЗаданияКРаспределениюРасчетов.ДатаПересчета КАК ДатаПересчета,
		|	ЗаданияКРаспределениюРасчетов.ДатаПересчетаПлан КАК ДатаПересчетаПлан
		|ИЗ
		|	РегистрСведений.ЗаданияКРаспределениюРасчетов КАК ЗаданияКРаспределениюРасчетов
		|ГДЕ
		|	ЗаданияКРаспределениюРасчетов.УдалитьОбъектРасчетов <> НЕОПРЕДЕЛЕНО";
		
	РегистрируемыеКортежи = Запрос.Выполнить().Выгрузить();
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, РегистрируемыеКортежи, ДополнительныеПараметры);
	
КонецПроцедуры

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсиюУдалитьДублированиеСтрок(Параметры) Экспорт
	
	ПолноеИмяОбъекта = "РегистрСведений.ЗаданияКРаспределениюРасчетов";
	Если Не ОбновлениеИнформационнойБазы.ЕстьДанныеДляОбработки(Параметры.Очередь, ПолноеИмяОбъекта) Тогда
		Параметры.ОбработкаЗавершена = Истина;
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	ОбновляемыеДанные = ОбновлениеИнформационнойБазы.ДанныеДляОбновленияВМногопоточномОбработчике(Параметры);
	Если ОбновляемыеДанные.Количество() = 0 Тогда
		Параметры.ОбработкаЗавершена = Ложь;
		Возврат;
	КонецЕсли;
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Данные.ТипРасчетов КАК ТипРасчетов,
	|	Данные.АналитикаУчетаПоПартнерам КАК АналитикаУчетаПоПартнерам,
	|	Данные.ОбъектРасчетов КАК ОбъектРасчетов,
	|	Данные.Валюта КАК Валюта,
	|	Данные.Документ КАК Документ,
	|	Данные.ДатаПересчета КАК ДатаПересчета,
	|	Данные.ДатаПересчетаПлан КАК ДатаПересчетаПлан
	|ПОМЕСТИТЬ ВтДанныеДляОбработки
	|ИЗ
	|	&ОбновляемыеДанные КАК Данные
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТДляОбработки.ТипРасчетов КАК ТипРасчетов,
	|	ВТДляОбработки.АналитикаУчетаПоПартнерам КАК АналитикаУчетаПоПартнерам,
	|	ВТДляОбработки.ОбъектРасчетов КАК ОбъектРасчетов,
	|	ВТДляОбработки.Валюта КАК Валюта,
	|	ВТДляОбработки.Документ КАК Документ,
	|	ВТДляОбработки.ДатаПересчета КАК ДатаПересчета,
	|	ВТДляОбработки.ДатаПересчетаПлан КАК ДатаПересчетаПлан,
	|	МАКСИМУМ(Задания.Приоритет) КАК Приоритет
	|ИЗ
	|	ВтДанныеДляОбработки КАК ВТДляОбработки
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЗаданияКРаспределениюРасчетов КАК Задания
	|		ПО ВТДляОбработки.ТипРасчетов = Задания.ТипРасчетов
	|		И ВТДляОбработки.АналитикаУчетаПоПартнерам = Задания.АналитикаУчетаПоПартнерам
	|		И ВТДляОбработки.ОбъектРасчетов = Задания.ОбъектРасчетов
	|		И Задания.Валюта = ВТДляОбработки.Валюта
	|		И ВТДляОбработки.Документ = Задания.Документ
	|		И ВТДляОбработки.ДатаПересчета = Задания.ДатаПересчета
	|		И ВТДляОбработки.ДатаПересчетаПлан = Задания.ДатаПересчетаПлан
	|СГРУППИРОВАТЬ ПО
	|	ВТДляОбработки.ТипРасчетов,
	|	ВТДляОбработки.АналитикаУчетаПоПартнерам,
	|	ВТДляОбработки.ОбъектРасчетов,
	|	ВТДляОбработки.Валюта,
	|	ВТДляОбработки.Документ,
	|	ВТДляОбработки.ДатаПересчета,
	|	ВТДляОбработки.ДатаПересчетаПлан";
	
	Запрос.УстановитьПараметр("ОбновляемыеДанные", ОбновляемыеДанные);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		НаборЗаписей = СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.ТипРасчетов.Установить(Выборка.ТипРасчетов);
		НаборЗаписей.Отбор.АналитикаУчетаПоПартнерам.Установить(Выборка.АналитикаУчетаПоПартнерам);
		НаборЗаписей.Отбор.ОбъектРасчетов.Установить(Выборка.ОбъектРасчетов);
		НаборЗаписей.Отбор.Валюта.Установить(Выборка.Валюта);
		НаборЗаписей.Отбор.Документ.Установить(Выборка.Документ);
		НаборЗаписей.Отбор.ДатаПересчета.Установить(Выборка.ДатаПересчета);
		НаборЗаписей.Отбор.ДатаПересчетаПлан.Установить(Выборка.ДатаПересчетаПлан);
		
		НачатьТранзакцию();
		
		Попытка
				
			Блокировка = Новый БлокировкаДанных;
				
			// Блокировка регистра "Задания к распределению расчетов".
			ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ЗаданияКРаспределениюРасчетов");
			ЭлементБлокировки.УстановитьЗначение("ТипРасчетов", Выборка.ТипРасчетов);
			ЭлементБлокировки.УстановитьЗначение("АналитикаУчетаПоПартнерам", Выборка.АналитикаУчетаПоПартнерам);
			ЭлементБлокировки.УстановитьЗначение("ОбъектРасчетов", Выборка.ОбъектРасчетов);
			ЭлементБлокировки.УстановитьЗначение("Валюта", Выборка.Валюта);
			ЭлементБлокировки.УстановитьЗначение("Документ", Выборка.Документ);
			ЭлементБлокировки.УстановитьЗначение("ДатаПересчета", Выборка.ДатаПересчета);
			ЭлементБлокировки.УстановитьЗначение("ДатаПересчетаПлан", Выборка.ДатаПересчетаПлан);
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
				
			Блокировка.Заблокировать();
			
			НаборЗаписей.Прочитать();
			Если НаборЗаписей.Количество() = 0 Тогда
				ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(НаборЗаписей);
				ЗафиксироватьТранзакцию();
				Продолжить;
			КонецЕсли;
			НаборЗаписей.Очистить();
			
			НоваяЗаписьРегистра = НаборЗаписей.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяЗаписьРегистра, Выборка);
			НоваяЗаписьРегистра.Обработка = 0;
			НоваяЗаписьРегистра.КоличествоДокументов = 1;
			ОбновлениеИнформационнойБазы.ЗаписатьНаборЗаписей(НаборЗаписей);
				
			ЗафиксироватьТранзакцию();
				
		Исключение
				
			ОтменитьТранзакцию();
				
			ОбновлениеИнформационнойБазыУТ.СообщитьОНеудачнойОбработке(ИнформацияОбОшибке(), Выборка.ОбъектРасчетов);
				
		КонецПопытки;
		
	КонецЦикла;
	
	Параметры.ОбработкаЗавершена = ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(Параметры.Очередь, ПолноеИмяОбъекта);
	
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
