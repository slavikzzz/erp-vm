#Область ОписаниеПеременных

&НаКлиенте
Перем БылоНаименование, БылИдентификатор;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Ключ.Пустая() Тогда
		
		Если ЗначениеЗаполнено(Параметры.ЗначениеКопирования) Тогда
			// При копировании очищаем свойства, которые не могут быть продублированы.
			Объект.Идентификатор = СформироватьИдентификаторПоказателя(Объект.Идентификатор, Объект.Ссылка);
			Объект.ОтображатьВДокументахНачисления = Истина;
			Объект.ЗначениеРассчитываетсяАвтоматически = Ложь;
		КонецЕсли;
		
	КонецЕсли;
	
	Если Объект.Предопределенный Тогда
		УстановитьДоступностьПолейСлужебногоПоказателя();
	КонецЕсли;
	
	Элементы.ЗначениеПоказателяСтраницы.ТекущаяСтраница = ?(Объект.Предопределенный, 
		Элементы.ЗначениеРассчитываетсяАвтоматическиСтраница, 
		Элементы.Дополнительно);
		
	ЗаполнитьИнформациюОбИспользованииЗначений();
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.Свойства
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект, ДополнительныеПараметры);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ИдентификаторПоНаименованию = ИдентификаторПоПредставлению(ТекущийОбъект.Наименование);
	ПредопределенныеПоказатели = ЗарплатаКадрыРасширенныйПовтИсп.ИменаПредопределенныхПоказателей();
	Если ПредопределенныеПоказатели.Найти(ИдентификаторПоНаименованию) <> Неопределено Тогда 
		ИдентификаторПолученПоПредставлению = Истина;
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	БылоНаименование = Объект.Наименование;
	БылИдентификатор = Объект.Идентификатор;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	ЕстьРазделители = Ложь;
	Для Позиция = 1 По СтрДлина(Объект.Идентификатор) Цикл
		Если СтроковыеФункцииКлиентСервер.ЭтоРазделительСлов(КодСимвола(Объект.Идентификатор, Позиция)) Тогда
			ЕстьРазделители = Истина;
			Объект.Идентификатор = СтрЗаменить(Объект.Идентификатор, Сред(Объект.Идентификатор, Позиция, 1), "?");
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ОбновитьПовторноИспользуемыеЗначения();
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Запись_ПоказателиРасчетаРезервовПоОплатеТруда", Объект.Ссылка, ВладелецФормы);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// СтандартныеПодсистемы.Свойства
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтотОбъект, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НаименованиеПриИзменении(Элемент)
	
	ПрежнийИдентификатор = ИдентификаторПоПредставлению(БылоНаименование);
	
	Если Не ЗначениеЗаполнено(Объект.Идентификатор) 
		Или ПрежнийИдентификатор = Объект.Идентификатор
		Или ИдентификаторПолученПоПредставлению Тогда
		Объект.Идентификатор = ИдентификаторПоПредставлению(Объект.Наименование);
		ПредопределенныеПоказатели = ЗарплатаКадрыРасширенныйКлиентПовтИсп.ИменаПредопределенныхПоказателей();
		Если Объект.ИмяПредопределенныхДанных <> Объект.Идентификатор И ПредопределенныеПоказатели.Найти(Объект.Идентификатор) <> Неопределено Тогда 
			Объект.Идентификатор = СформироватьИдентификаторПоказателя(Объект.Идентификатор, Объект.Ссылка);
			ИдентификаторПолученПоПредставлению = Истина;
		КонецЕсли;
		БылИдентификатор = Объект.Идентификатор;
	КонецЕсли;
	
	БылоНаименование = Объект.Наименование;
	
КонецПроцедуры

&НаКлиенте
Процедура ИдентификаторПриИзменении(Элемент)
	
	ПрежнееНаименование = ПредставлениеПоИдентификатору(БылИдентификатор);
	
	Если Не ЗначениеЗаполнено(Объект.Наименование) 
		Или ПрежнееНаименование = Объект.Наименование 
		Или ИдентификаторПолученПоПредставлению Тогда
		Объект.Наименование = ПредставлениеПоИдентификатору(Объект.Идентификатор);
		БылоНаименование = Объект.Наименование;
	КонецЕсли;
	
	БылИдентификатор = Объект.Идентификатор;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

// СтандартныеПодсистемы.Свойства
&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.Свойства 
&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

&НаСервере
Процедура УстановитьДоступностьПолейСлужебногоПоказателя()
	
	// Если показатель служебный, 
	// то редактировать можно только отдельные поля.
	ДоступныеПоля = Новый Массив;
	ДоступныеПоля.Добавить(Элементы.Наименование);
	ДоступныеПоля.Добавить(Элементы.КраткоеНаименование);
	ДоступныеПоля.Добавить(Элементы.Точность);
	
	Для Каждого Элемент Из Элементы Цикл
		Если ДоступныеПоля.Найти(Элемент) <> Неопределено Тогда
			Продолжить;
		КонецЕсли;
		Если ТипЗнч(Элемент) = Тип("ПолеФормы") 
			И Элемент.Вид <> ВидПоляФормы.ПолеНадписи Тогда
			Элемент.Доступность = Ложь;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьИнформациюОбИспользованииЗначений()
	
	Перем ТекстИнфо;
	
	Если Объект.Ссылка = ОбщегоНазначения.ПредопределенныйЭлемент("Справочник.ПоказателиРасчетаРезервовПоОплатеТруда.ОстатокОтпуска") Тогда
		ТекстИнфо = НСтр("ru = 'Количество дней неиспользуемого отпуска по виду отпуска, указанного в начислении';
						|en = 'The number of days of unused leave by the leave kind specified in the accrued payroll'");
	ИначеЕсли Объект.Ссылка = ОбщегоНазначения.ПредопределенныйЭлемент("Справочник.ПоказателиРасчетаРезервовПоОплатеТруда.СохраняемыйЗаработок") Тогда
		
		ТекстИнфо = НСтр("ru = 'Сумма среднего заработка для рачета отпуска';
						|en = 'Average salary amount for leave calculation'");
		Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ГосударственнаяСлужба") Тогда
			НастройкиГосСлужбы = Новый Структура("ИспользоватьРасчетСохраняемогоДенежногоСодержания", Ложь);
			Модуль = ОбщегоНазначения.ОбщийМодуль("ГосударственнаяСлужба");
			Модуль.НастройкиПрограммыБюджетногоУчреждения(НастройкиГосСлужбы);
			Если НастройкиГосСлужбы.ИспользоватьРасчетСохраняемогоДенежногоСодержания Тогда
				ТекстИнфо = НСтр("ru = 'Сумма среднего заработка или сохраняемого денежного содержания (в зависимости от категории работника)';
								|en = 'Amount of average salary or retained monetary pay (depending on the employee category)'");
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
	ТекстИнфонадписиИспользованиеЗначений = ТекстИнфо;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ИдентификаторПоПредставлению(Знач Представление)
	
	Идентификатор = "";
	БылРазделитель = Ложь;
	Для НомСимвола = 1 По СтрДлина(Представление) Цикл
		Символ = Сред(Представление, НомСимвола, 1);
		Если СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(Символ) 
			И ПустаяСтрока(Идентификатор) Тогда
			// цифры в начале пропускаем
			Продолжить;
		КонецЕсли;
		Если СтроковыеФункцииКлиентСервер.ЭтоРазделительСлов(КодСимвола(Символ)) Тогда
			БылРазделитель = Истина;
		Иначе
			Если БылРазделитель Тогда
				БылРазделитель = Ложь;
				Символ = ВРег(Символ);
			КонецЕсли;
			Идентификатор = Идентификатор + Символ;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Идентификатор;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ПредставлениеПоИдентификатору(Знач Идентификатор)
	
	Представление = "";
	БылВРег = Ложь;
	Для НомСимвола = 1 По СтрДлина(Идентификатор) Цикл
		Символ = Сред(Идентификатор, НомСимвола, 1);
		ЭтоВРег = Символ = ВРег(Символ);
		Если Не БылВРег И ЭтоВРег И Не НомСимвола = 1 Тогда
			Символ = " " + Символ;
		КонецЕсли;
		БылВРег = ЭтоВРег;
		Представление = Представление + Символ;
	КонецЦикла;
	
	Возврат Представление;
	
КонецФункции

&НаСервереБезКонтекста
Функция СформироватьИдентификаторПоказателя(Идентификатор, Ссылка)
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("Идентификатор", Идентификатор);
	Запрос.УстановитьПараметр("КоличествоСимволов", СтрДлина(Идентификатор));
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	               |	ПоказателиРасчетаЗарплаты.Идентификатор
	               |ИЗ
	               |	Справочник.ПоказателиРасчетаЗарплаты КАК ПоказателиРасчетаЗарплаты
	               |ГДЕ
	               |	ПОДСТРОКА(ПоказателиРасчетаЗарплаты.Идентификатор, 1, &КоличествоСимволов) = &Идентификатор
	               |	И ПоказателиРасчетаЗарплаты.Ссылка <> &Ссылка";
				   
	ТекущиеИдентификаторы = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Идентификатор");			   
	
	Сч = 1;
	Пока Истина Цикл 
		НовыйИдентификатор = Идентификатор + Сч;
		Если ТекущиеИдентификаторы.Найти(НовыйИдентификатор) = Неопределено Тогда 
			Возврат НовыйИдентификатор;
		КонецЕсли;
		Сч = Сч + 1;
	КонецЦикла;
	
КонецФункции

#КонецОбласти
