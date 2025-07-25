#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);

	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПриЧтенииСозданииНаСервере();
		ПодобратьЦветОформления();
	КонецЕсли;
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	ПрочитатьЦветОформления(ТекущийОбъект);
	
	ПриЧтенииСозданииНаСервере();	
	
	МодификацияКонфигурацииПереопределяемый.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)

	СохранитьЦветОформления(ТекущийОбъект);
	
	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Запись_ВариантыНаладки",, Объект.Владелец);

	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВладелецПриИзменении(Элемент)
	
	УправлениеДоступностьюВремениРаботы();	
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()
	
	УправлениеДоступностьюВремениРаботы();	
	
КонецПроцедуры

&НаСервере
Процедура ПрочитатьЦветОформления(ТекущийОбъект)

	ЦветОформленияОбъекта = ТекущийОбъект.ЦветОформления.Получить();
	Если ЦветОформленияОбъекта <> Неопределено Тогда
		ЦветОформления = ЦветОформленияОбъекта.ЦветОформления;
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ПодобратьЦветОформления()

	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ВариантыНаладки.ЦветОформления
	|ИЗ
	|	Справочник.ВариантыНаладки КАК ВариантыНаладки
	|ГДЕ
	|	НЕ ВариантыНаладки.ПометкаУдаления
	|	И ВариантыНаладки.Владелец = &Владелец";
	
	Запрос.УстановитьПараметр("Владелец", Объект.Владелец);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	ИспользуемыеЦвета = Новый Массив;
	Пока Выборка.Следующий() Цикл
		Хранилище = Выборка.ЦветОформления; // ХранилищеЗначения
		ЦветВариантаНаладки = Хранилище.Получить();
		Если ЦветВариантаНаладки <> Неопределено Тогда
			ИспользуемыеЦвета.Добавить(ЦветВариантаНаладки);
		КонецЕсли; 
	КонецЦикла;
	
	МакетЦветов = Справочники.ВариантыНаладки.ПолучитьМакет("Палитра");
	Для Сч = 1 По МакетЦветов.ВысотаТаблицы Цикл
		ОбластьОформления = МакетЦветов.Область(Сч, 1, Сч, 1);
		Если ИспользуемыеЦвета.Найти(ОбластьОформления.ЦветФона) = Неопределено Тогда
			ЦветОформления = Новый ХранилищеЗначения(ОбластьОформления.ЦветФона);
			Прервать;
		КонецЕсли;
	КонецЦикла;
		
КонецПроцедуры

&НаСервере
Процедура СохранитьЦветОформления(ТекущийОбъект)

	ПустойЦвет = Новый Цвет(0, 0, 0);
	Если ЦветОформления <> ПустойЦвет Тогда
		ЦветОформленияОбъекта = Новый Структура;
		ЦветОформленияОбъекта.Вставить("ЦветОформления", ЦветОформления);
		ЦветОформленияОбъекта.Вставить("ЦветОформленияRGB", ПроизводствоСервер.ЦветВФорматеRGB(ЦветОформления));
	Иначе
		ЦветОформленияОбъекта = Неопределено;
	КонецЕсли; 

	ТекущийОбъект.ЦветОформления = Новый ХранилищеЗначения(ЦветОформленияОбъекта);
	
КонецПроцедуры

&НаСервере
Процедура УправлениеДоступностьюВремениРаботы()

	Если НЕ Объект.Владелец.Пустая() Тогда
		РеквизитыВидаРЦ = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект.Владелец, "ПараллельнаяЗагрузка,ВариантЗагрузки");
		ВремяРаботыДоступно = (РеквизитыВидаРЦ.ПараллельнаяЗагрузка 
								И РеквизитыВидаРЦ.ВариантЗагрузки = Перечисления.ВариантыЗагрузкиРабочихЦентров.Синхронный);
	Иначе
		ВремяРаботыДоступно = Ложь;
	КонецЕсли; 

	Элементы.ВремяРаботы.Видимость = ВремяРаботыДоступно;
	Элементы.ЕдиницаИзмерения.Видимость = ВремяРаботыДоступно;
	Элементы.ВремяРаботыПояснение.Видимость = ВремяРаботыДоступно;
	
КонецПроцедуры

#КонецОбласти
