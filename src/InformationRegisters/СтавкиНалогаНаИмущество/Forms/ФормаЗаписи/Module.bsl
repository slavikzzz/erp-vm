
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Запись, ЭтотОбъект);
	КлючЗаписи = Неопределено;
	ИмяРегистра = Метаданные.РегистрыСведений.СтавкиНалогаНаИмущество.Имя;
	ТолькоПросмотр = НЕ ПравоДоступа("Изменение", Метаданные.РегистрыСведений.СтавкиНалогаНаИмущество);
	
	Организация = Параметры.Организация;
	Элементы.Организация.Видимость = НЕ ЗначениеЗаполнено(Организация);
	Заголовок = Заголовок + " " + Строка(Организация);
	
	ЭтоФормаЗаписи = Параметры.Свойство("Ключ", КлючЗаписи);
	Если Параметры.Свойство("ЗначениеКопирования") И ЗначениеЗаполнено(Параметры.ЗначениеКопирования) Тогда
		СкопироватьЗаписьРегистра(Параметры.ЗначениеКопирования);
	Иначе
		ПрочитатьЗаписьРегистра(КлючЗаписи);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)

	Если Запись.ОсвобождениеОтНалогообложения Тогда
		Если ПустаяСтрока(Запись.КодНалоговойЛьготыОсвобождениеОтНалогообложения) Тогда
			ТекстСообщения = НСтр("ru = 'Не указан код налоговой льготы (освобождение от налогообложения)';
									|en = 'Tax relief code is not specified (taxation exemption)'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "КодНалоговойЛьготыОсвобождениеОтНалогообложения", , Отказ);
		КонецЕсли;
	КонецЕсли;

	Если Запись.УменьшениеСуммыНалогаВПроцентах И Запись.ПроцентУменьшения = 0 Тогда
		ТекстСообщения = НСтр("ru = 'Не указан процент уменьшения суммы налога';
								|en = 'Tax amount reduction percent is not specified'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "ПроцентУменьшения", , Отказ);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если Модифицированность И ЗавершениеРаботы Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Если Модифицированность Тогда
		
		Отказ = Истина;
		ЗадатьВопросФормаМодифицирована("ВопросПередЗакрытиемЗавершение");
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы
&НаКлиенте
Процедура ДатаИзмененияПриИзменении(Элемент)
	ТекстВопроса = НСтр("ru = 'Создать новую настройку на %1?';
						|en = 'Create a new customization on the %1?'");
	ТекстВопроса = СтрШаблон(ТекстВопроса, Формат(ДатаИзменения,"ДЛФ=D"));
	ПоказатьВопрос(Новый ОписаниеОповещения("ДатаИзмененияПриИзмененииЗавершение", ЭтотОбъект), ТекстВопроса, РежимДиалогаВопрос.ДаНет);
КонецПроцедуры

&НаКлиенте
Процедура ДатаИзмененияПриИзмененииЗавершение(Ответ, ДополнительныеПараметры) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Нет Тогда
		ПрочитатьЗаписьРегистраПриИзменииРеквизита(,ДатаИзменения);
		СтавкиНалогаНаИмуществоПериодПриИзменении(Запись, Элементы);
	ИначеЕсли Ответ = КодВозвратаДиалога.Да Тогда
		ПрочитатьЗаписьРегистраПриИзменииРеквизита(,ДатаИзменения, Истина);
		СтавкиНалогаНаИмуществоПериодПриИзменении(Запись, Элементы);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	Организация = Запись.Организация;
	ПрочитатьЗаписьРегистраПриИзменииРеквизита(,ДатаИзменения);
КонецПроцедуры

&НаКлиенте
Процедура ОсвобождениеОтНалогообложенияПриИзменении(Элемент)

	Если Запись.ОсвобождениеОтНалогообложения Тогда
		
		Запись.СнижениеНалоговойСтавки = Ложь;
		Запись.СнижениеНалоговойСтавкиДвижимоеИмущество = Ложь;
		Запись.УменьшениеСуммыНалогаВПроцентах = Ложь;
		Запись.ПроцентУменьшения = 0;
		Запись.ОсвобождениеОтНалогообложенияДвижимогоИмущества = Ложь;
		
	Иначе
		Запись.КодНалоговойЛьготыОсвобождениеОтНалогообложения = "";
	КонецЕсли;
	
	УстановитьДоступностьПараметровИмущественныхНалогов(Запись, Элементы);

КонецПроцедуры

&НаКлиенте
Процедура УменьшениеСуммыНалогаВПроцентахПриИзменении(Элемент)

	Если НЕ Запись.УменьшениеСуммыНалогаВПроцентах Тогда
		Запись.ПроцентУменьшения = 0;
	КонецЕсли;

	УправлениеФормой(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура КодНалоговойЛьготыОсвобождениеОтНалогообложенияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ТипОбъекта",		"РегистрСведений");
	ПараметрыФормы.Вставить("НазваниеОбъекта",	"ПараметрыНачисленияНалогаНаИмущество");
	ПараметрыФормы.Вставить("НазваниеМакета",	"ЛьготыПоНалогуНаИмущество");
	ПараметрыФормы.Вставить("ТекущийПериод",	Запись.Период);

	ОписаниеОповещения = Новый ОписаниеОповещения("КодНалоговойЛьготыОсвобождениеОтНалогообложенияНачалоВыбораЗавершение", ЭтотОбъект);
	ОткрытьФорму("ОбщаяФорма.ФормаВыбораКода", ПараметрыФормы,,,,, ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);

КонецПроцедуры

&НаКлиенте
Процедура КодНалоговойЛьготыОсвобождениеОтНалогообложенияНачалоВыбораЗавершение(Результат, ДополнительныеПараметры) Экспорт
    
    КодЛьготы = Результат;
    Если КодЛьготы <> Неопределено Тогда
        Запись.КодНалоговойЛьготыОсвобождениеОтНалогообложения = КодЛьготы;
    КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	Если ЗаписатьИзменения(Истина) Тогда
		Закрыть();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Записать(Команда)
	ЗаписатьИзменения();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	УстановитьДоступностьПараметровИмущественныхНалогов(Форма.Запись, Форма.Элементы);
КонецПроцедуры

&НаСервере
Процедура ПрочитатьЗаписьРегистра(КлючЗаписи = Неопределено, ПериодЗаписи = Неопределено, СоздатьНовую = Ложь)
	НастройкиНалоговУчетныхПолитик.ПрочитатьЗаписьРегистра(ЭтотОбъект, 
		ИмяРегистра,
		Организация,
		СоздатьНовую,
		КлючЗаписи,
		ПериодЗаписи);
	УправлениеФормой(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ПрочитатьЗаписьРегистраПриИзменииРеквизита(КлючЗаписи = Неопределено, ПериодЗаписи = Неопределено, СоздатьНовую = Ложь)
	Если НЕ Копирование Тогда
		ПрочитатьЗаписьРегистра(КлючЗаписи, ПериодЗаписи, СоздатьНовую);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура СкопироватьЗаписьРегистра(ЗначениеКопирования)
	НастройкиНалоговУчетныхПолитик.СкопироватьУчетнуюПолитику(ЭтотОбъект, ЗначениеКопирования, ИмяРегистра);
	УправлениеФормой(ЭтотОбъект);
	Копирование = Истина;
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ОповеститьПослеЗаписи()
	
	ПараметрыОповещения = Новый Структура("Организация, Период", Запись.Организация, Запись.Период);
	ИмяСобытия = "Запись_" + ИмяРегистра;
	Оповестить(ИмяСобытия, ПараметрыОповещения);
	
КонецПроцедуры

&НаСервере
Функция ЗаписатьИзмененияНаСервере(Закрытие = Ложь)
	ЗаписьУспешна = НастройкиНалоговУчетныхПолитик.ЗаписатьИзменениеЗаписейРегистра(ЭтотОбъект, Закрытие);
	Возврат ЗаписьУспешна;
КонецФункции

&НаКлиенте
Функция ЗаписатьИзменения(Закрытие = Ложь)
	
	Если ПроверкаДатыИСтавки(ДатаИзменения, Запись.Организация, Запись.НалоговаяСтавка) = Ложь Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ЗаписьУспешна = ЗаписатьИзмененияНаСервере(Закрытие);
	Если ЗаписьУспешна Тогда
		ОповеститьПослеЗаписи();
	КонецЕсли;
	Возврат ЗаписьУспешна;
КонецФункции

&НаКлиенте
Процедура ОписаниеИсторииОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	Если НавигационнаяСсылкаФорматированнойСтроки = "ИсторияИзменений" Тогда
		Если Модифицированность Тогда
			ЗадатьВопросФормаМодифицирована("ОткрытьИсториюИзмененийПродолжение");
		Иначе
			ОткрытьИсториюИзменений();
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ЗадатьВопросФормаМодифицирована(ИмяОповещения)
	
	ТекстВопроса = НСтр("ru = 'Данные были изменены. Сохранить изменения?';
						|en = 'The data has changed. Do you want to save the changes?'");
	Оповещение = Новый ОписаниеОповещения(ИмяОповещения, ЭтотОбъект);
	ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНетОтмена);
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросПередЗакрытиемЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Нет Тогда
		
		Модифицированность = Ложь;
		Закрыть();
		
	ИначеЕсли Результат = КодВозвратаДиалога.Да Тогда
		Если НЕ ЗаписатьИзменения(Истина) Тогда
			Возврат;
		КонецЕсли;
		Модифицированность = Ложь;
		Закрыть();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьИсториюИзменений()
	ОткрытьФорму("РегистрСведений.СтавкиНалогаНаИмущество.Форма.РедактированиеИстории",
		Новый Структура("ТолькоПросмотр, Организация", ТолькоПросмотр, Организация),
		ЭтаФорма,,,,
		Новый ОписаниеОповещения("ОткрытьИсториюИзмененийЗавершение", ЭтотОбъект));
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьИсториюИзмененийПродолжение(Результат, ДополнительныеПараметры) Экспорт
	Если Результат = КодВозвратаДиалога.Нет Тогда
		ОткрытьИсториюИзменений();
	ИначеЕсли Результат = КодВозвратаДиалога.Да Тогда
		Если НЕ ЗаписатьИзменения(Ложь) Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьИсториюИзмененийЗавершение(Результат, ДополнительныеПараметры) Экспорт
	Если ЗначениеЗаполнено(Результат) Тогда
		ПрочитатьЗаписьРегистра(Результат);
	КонецЕсли;
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДоступностьПараметровИмущественныхНалогов(Объект, Элементы, ПрефиксЭлементов = "")

	ОсвобождениеОтНалогообложения = Объект[ПрефиксЭлементов + "ОсвобождениеОтНалогообложения"];
	
	// Это сниженная ставка
	Элементы[ПрефиксЭлементов + "СнижениеНалоговойСтавки"].Доступность = НЕ ОсвобождениеОтНалогообложения;
	Элементы[ПрефиксЭлементов + "СнижениеНалоговойСтавкиДвижимоеИмущество"].Доступность = НЕ ОсвобождениеОтНалогообложения;
	
	// Все имущество освобождено от налога, код льготы.
	ПолеДоступно = ОсвобождениеОтНалогообложения;
	Элементы[ПрефиксЭлементов + "КодНалоговойЛьготыОсвобождениеОтНалогообложения"].Доступность = ПолеДоступно;
	Элементы[ПрефиксЭлементов + "КодНалоговойЛьготыОсвобождениеОтНалогообложения"].АвтоОтметкаНезаполненного = ПолеДоступно;
	Элементы[ПрефиксЭлементов + "КодНалоговойЛьготыОсвобождениеОтНалогообложения"].ОтметкаНезаполненного = 
		ПолеДоступно И ПустаяСтрока(Объект[ПрефиксЭлементов + "КодНалоговойЛьготыОсвобождениеОтНалогообложения"]);

	// Налог уменьшен на.
	Элементы[ПрефиксЭлементов + "УменьшениеСуммыНалогаВПроцентах"].Доступность = НЕ ОсвобождениеОтНалогообложения;
	ПолеДоступно = НЕ ОсвобождениеОтНалогообложения И Объект[ПрефиксЭлементов + "УменьшениеСуммыНалогаВПроцентах"];
	Элементы[ПрефиксЭлементов + "ПроцентУменьшения"].Доступность = ПолеДоступно;
	Элементы[ПрефиксЭлементов + "ПроцентУменьшения"].АвтоОтметкаНезаполненного = ПолеДоступно;
	Элементы[ПрефиксЭлементов + "ПроцентУменьшения"].ОтметкаНезаполненного = ПолеДоступно И Объект[ПрефиксЭлементов + "ПроцентУменьшения"] = 0;
	Элементы[ПрефиксЭлементов + "ПроцентУменьшенияДекорацияПроцент"].Доступность = ПолеДоступно;

	// Движимое имущество, принятое на учет с 1 января 2013 года
	ПолеДоступно = Объект[ПрефиксЭлементов + "Период"] >= '201801010000'
					И Объект[ПрефиксЭлементов + "Период"] < '201901010000';
	Элементы[ПрефиксЭлементов + "НалоговаяСтавкаДвижимоеИмущество"].Видимость = ПолеДоступно;
	Элементы[ПрефиксЭлементов + "НалоговаяСтавкаДвижимоеИмуществоДекорацияПроцент"].Видимость = ПолеДоступно;
	Элементы[ПрефиксЭлементов + "СнижениеНалоговойСтавкиДвижимоеИмущество"].Видимость = ПолеДоступно;
	Элементы[ПрефиксЭлементов + "ОсвобождениеОтНалогообложенияДвижимогоИмущества"].Видимость = ПолеДоступно;
	Элементы[ПрефиксЭлементов + "ОсвобождениеОтНалогообложенияДвижимогоИмущества"].Доступность = ПолеДоступно И НЕ ОсвобождениеОтНалогообложения;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура СтавкиНалогаНаИмуществоПериодПриИзменении(Объект, Элементы, ПрефиксЭлементов = "") Экспорт

	Если Объект[ПрефиксЭлементов + "Период"] >= '201801010000'
		И НЕ Элементы[ПрефиксЭлементов + "НалоговаяСтавкаДвижимоеИмущество"].Видимость Тогда
		
		Объект[ПрефиксЭлементов + "НалоговаяСтавкаДвижимоеИмущество"] = 1.1;
		
	ИначеЕсли Объект[ПрефиксЭлементов + "Период"] < '201801010000' Тогда
		
		Объект[ПрефиксЭлементов + "НалоговаяСтавкаДвижимоеИмущество"] = 0;
		Объект[ПрефиксЭлементов + "ОсвобождениеОтНалогообложенияДвижимогоИмущества"] = Ложь;
		
	КонецЕсли;
	
	УстановитьДоступностьПараметровИмущественныхНалогов(Объект, Элементы, ПрефиксЭлементов);
	
КонецПроцедуры

// Проверка даты и ставки.
// 
// Параметры:
//  ДатаУстановкиЗначения - Дата - Дата установки значения
//  Организация - СправочникСсылка.Организации - Организация
//  ТекущееЗначениеСтавки - Число - Текущее значение ставки на форме
// 
// Возвращаемое значение:
//  Булево - Проверка даты и ставки
&НаКлиенте
Функция ПроверкаДатыИСтавки(ДатаУстановкиЗначения, Организация, ТекущееЗначениеСтавки)
	РезультатПроверки = ПроверитьЗначениеИДатуУстановкиСтавки(ДатаУстановкиЗначения, Организация, ТекущееЗначениеСтавки);
	
	Если РезультатПроверки.Статус = "СтавкаНеУстановлена" Тогда
		ТекстСообщения = НСтр("ru = 'Ставка налога на имущество устанавливается с начала года';
								|en = 'Ставка налога на имущество устанавливается с начала года'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
		Возврат Ложь;
	КонецЕсли;
	
	Если РезультатПроверки.Статус = "СтавкиРазличаются" Тогда
		ШаблонСообщения = НСтр("ru = 'Ставка налога на имущество устанавливается с начала года. На %1 установлена ставка %2%%.';
								|en = 'Ставка налога на имущество устанавливается с начала года. На %1 установлена ставка %2%%.'");
		ТекстСообщения = СтрШаблон(ШаблонСообщения,
										Формат(НачалоГода(ДатаИзменения),"ДЛФ=D;"),
										РезультатПроверки.СтавкаНаНачалоГода);
		
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
КонецФункции
// Проверить значение и дату установки ставки.
// 
// Параметры:
//  ДатаУстановкиЗначения - Дата - Дата установки значения
//  Организация - СправочникСсылка.Организации - Организация
//  ТекущееЗначениеСтавки - Число - Текущее значение ставки
// 
// Возвращаемое значение:
//  Структура - Проверить значение и дату установки ставки:
// * Статус - Строка - Результат проверки
// * СтавкаНаНачалоГода - Число - Значение ставки налога на имущество на начало года, если не установлена - то 0.
&НаСервереБезКонтекста
Функция ПроверитьЗначениеИДатуУстановкиСтавки(ДатаУстановкиЗначения, Организация, ТекущееЗначениеСтавки)
	
	РезультатПроверки = Новый Структура("Статус,СтавкаНаНачалоГода","",0);
	
	Если ДатаУстановкиЗначения = НачалоГода(ДатаУстановкиЗначения) Тогда
		РезультатПроверки.Статус = "ДатаКорректна";
		РезультатПроверки.СтавкаНаНачалоГода = ТекущееЗначениеСтавки;
		Возврат РезультатПроверки;
	КонецЕсли;
	
	ЗначениеСтавкиНаНачалоГода = 0;
	
	Запрос = Новый Запрос();
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	СтавкиНалогаНаИмуществоСрезПоследних.НалоговаяСтавка КАК НалоговаяСтавка
	|ИЗ
	|	РегистрСведений.СтавкиНалогаНаИмущество.СрезПоследних(&НачалоГода, Организация = &Организация) КАК
	|		СтавкиНалогаНаИмуществоСрезПоследних";
	
	Запрос.Текст = ТекстЗапроса;
	
	Запрос.УстановитьПараметр("НачалоГода", НачалоГода(ДатаУстановкиЗначения));
	Запрос.УстановитьПараметр("Организация", Организация);
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		РезультатПроверки.Статус = "СтавкаНеУстановлена";
		РезультатПроверки.СтавкаНаНачалоГода = 0;
		Возврат РезультатПроверки;
	КонецЕсли;
	
	Выборка = Результат.Выбрать();
	Пока Выборка.Следующий() Цикл
		ЗначениеСтавкиНаНачалоГода = Выборка.НалоговаяСтавка;
	КонецЦикла;
	
	Если ТекущееЗначениеСтавки  <> ЗначениеСтавкиНаНачалоГода Тогда
		РезультатПроверки.Статус = "СтавкиРазличаются";
		РезультатПроверки.СтавкаНаНачалоГода = ЗначениеСтавкиНаНачалоГода;
		Возврат РезультатПроверки;
	КонецЕсли;
	
	Если ДатаУстановкиЗначения > НачалоГода(ДатаУстановкиЗначения) 
			И ТекущееЗначениеСтавки  = ЗначениеСтавкиНаНачалоГода Тогда
		РезультатПроверки.Статус = "ДатаКорректна";
		РезультатПроверки.СтавкаНаНачалоГода = ТекущееЗначениеСтавки;
		Возврат РезультатПроверки;
	КонецЕсли;
	
КонецФункции

#КонецОбласти
