#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Ключ.Пустая() Тогда
		ВызватьИсключение СтрШаблон(
			НСтр("ru = '%1 загружаются в автоматическом режиме';
				|en = '%1 are imported automatically'"),
			РеквизитФормыВЗначение("Объект").Метаданные().ПредставлениеСписка);
	КонецЕсли;
	
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
	
	// ПроцессыОбработкиДокументов
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ПроцессыОбработкиДокументовЗарплата") Тогда
		МодульПроцессыОбработкиДокументовЗарплата = ОбщегоНазначения.ОбщийМодуль("ПроцессыОбработкиДокументовЗарплата");
		МодульПроцессыОбработкиДокументовЗарплата.ПриСозданииНаСервере(ЭтотОбъект, Объект);
	КонецЕсли;
	// Конец ПроцессыОбработкиДокументов
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ТекстXML = ТекущийОбъект.ХранилищеXML.Получить();
	
	ПриПолученииДанныхНаСервере(ТекущийОбъект);
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	// ПроцессыОбработкиДокументов
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ПроцессыОбработкиДокументовЗарплата") Тогда
		МодульПроцессыОбработкиДокументовЗарплата = ОбщегоНазначения.ОбщийМодуль("ПроцессыОбработкиДокументовЗарплата");
		МодульПроцессыОбработкиДокументовЗарплата.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец ПроцессыОбработкиДокументов
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
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
	
	Если ИмяСобытия = "Запись_СведенияОЗастрахованномЛицеФСС" Тогда
		ПодключитьОбработчикОжиданияПрочитать();
		
	ИначеЕсли ИмяСобытия = "Запись_ФизическиеЛица"
		И Источник = Объект.ФизическоеЛицо Тогда
		ПодключитьОбработчикОжиданияПрочитать();
		
	ИначеЕсли ИмяСобытия = СЭДОФССКлиент.ИмяСобытияПослеПолученияСообщенийОтФСС() Тогда
		ПодключитьОбработчикОжиданияПрочитать();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	// ПроцессыОбработкиДокументов
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ПроцессыОбработкиДокументовЗарплата") Тогда
		МодульПроцессыОбработкиДокументовЗарплата = ОбщегоНазначения.ОбщийМодуль("ПроцессыОбработкиДокументовЗарплата");
		МодульПроцессыОбработкиДокументовЗарплата.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи, Отказ);
	КонецЕсли;
	// Конец ПроцессыОбработкиДокументов
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ТекстXML = ТекущийОбъект.ХранилищеXML.Получить();
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// ПроцессыОбработкиДокументов
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ПроцессыОбработкиДокументовЗарплата") Тогда
		МодульПроцессыОбработкиДокументовЗарплата = ОбщегоНазначения.ОбщийМодуль("ПроцессыОбработкиДокументовЗарплата");
		МодульПроцессыОбработкиДокументовЗарплата.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец ПроцессыОбработкиДокументов
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Запись_НесоответствиеСведенийОЗастрахованномЛицеСЭДО", ПараметрыЗаписи, Объект.Ссылка);
	СЭДОФССКлиент.ОповеститьОНеобходимостиОбновитьТекущиеДела();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	// ПроцессыОбработкиДокументов
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ПроцессыОбработкиДокументовЗарплата") Тогда
		МодульПроцессыОбработкиДокументовЗарплата = ОбщегоНазначенияКлиент.ОбщийМодуль("ПроцессыОбработкиДокументовЗарплатаКлиент");
		МодульПроцессыОбработкиДокументовЗарплата.ПередЗакрытием(ЭтотОбъект, Объект, Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	КонецЕсли;
	// Конец ПроцессыОбработкиДокументов
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СНИЛСПриИзменении(Элемент)
	СНИЛСПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.КомментарийНачалоВыбора(ЭтаФорма, Элемент, ДанныеВыбора, СтандартнаяОбработка)
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиКомандФормы

#Область ОбработчикиСобытийПроцессыОбработкиДокументов

&НаКлиенте
Процедура Подключаемый_ВыполнитьЗадачуПоОбработкеДокумента(Команда)
	// ПроцессыОбработкиДокументов
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ПроцессыОбработкиДокументовЗарплата") Тогда
		МодульПроцессыОбработкиДокументовЗарплата = ОбщегоНазначенияКлиент.ОбщийМодуль("ПроцессыОбработкиДокументовЗарплатаКлиент");
		МодульПроцессыОбработкиДокументовЗарплата.ВыполнитьЗадачу(ЭтотОбъект, Команда, Объект)
	КонецЕсли;
	// Конец ПроцессыОбработкиДокументов
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьЗадачуПоОбработкеДокументаОповещение(Контекст, ДополнительныеПараметры) Экспорт
	ВыполнитьЗадачуПоОбработкеДокументаНаСервере(Контекст);
	ВыполнитьОбработкуОповещения(ДополнительныеПараметры, Контекст);
КонецПроцедуры

&НаСервере
Процедура ВыполнитьЗадачуПоОбработкеДокументаНаСервере(Контекст)
	// ПроцессыОбработкиДокументов
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ПроцессыОбработкиДокументовЗарплата") Тогда	
		МодульПроцессыОбработкиДокументовЗарплата = ОбщегоНазначения.ОбщийМодуль("ПроцессыОбработкиДокументовЗарплата");
		МодульПроцессыОбработкиДокументовЗарплата.ВыполнитьЗадачу(ЭтотОбъект, Контекст, Объект);
	КонецЕсли;
	// Конец ПроцессыОбработкиДокументов
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КомментарийНаправившегоОткрытие(Элемент, СтандартнаяОбработка)
	// ПроцессыОбработкиДокументов
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ПроцессыОбработкиДокументовЗарплата") Тогда	
		МодульПроцессыОбработкиДокументовЗарплата = ОбщегоНазначенияКлиент.ОбщийМодуль("ПроцессыОбработкиДокументовЗарплатаКлиент");
		МодульПроцессыОбработкиДокументовЗарплата.КомментарийНаправившегоОткрытие(ЭтотОбъект, Элемент, СтандартнаяОбработка);
	КонецЕсли;
	// Конец ПроцессыОбработкиДокументов
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КомментарийСледующемуНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	// ПроцессыОбработкиДокументов
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ПроцессыОбработкиДокументовЗарплата") Тогда	
		МодульПроцессыОбработкиДокументовЗарплата = ОбщегоНазначенияКлиент.ОбщийМодуль("ПроцессыОбработкиДокументовЗарплатаКлиент");
		МодульПроцессыОбработкиДокументовЗарплата.КомментарийСледующемуНачалоВыбора(ЭтотОбъект, Элемент, ДанныеВыбора, СтандартнаяОбработка);
	КонецЕсли;
	// Конец ПроцессыОбработкиДокументов
КонецПроцедуры

#КонецОбласти

#Область Поддержка

&НаКлиенте
Процедура ВопросВПоддержку(Команда)
	
	ВопросВПоддержку = ПодготовитьВопросВПоддержку();
	
	//   *КодОшибки - Строка - идентификатор ошибки при отправки:
	//   *СообщениеОбОшибке - Строка, ФорматированнаяСтрока - сообщение об ошибке для пользователя;
	//   *URLСтраницы - Строка - URL страницы отправки сообщения.
	Если Не ЗначениеЗаполнено(ВопросВПоддержку.КодОшибки) Тогда
		ПараметрыОткрытия = Новый Структура;
		ПараметрыОткрытия.Вставить("ЗаголовокОкна", НСтр("ru = 'Отправка сообщения в службу технической поддержки';
														|en = 'Send a message to technical support.'"));
		ИнтернетПоддержкаПользователейКлиент.ОткрытьВебСтраницуСДополнительнымиПараметрами(
			ВопросВПоддержку.URLСтраницы,
			ПараметрыОткрытия);
	Иначе
		ИнформированиеПользователяКлиент.ПоказатьПодробности(ВопросВПоддержку.СообщениеОбОшибке);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Форма

&НаКлиенте
Процедура ВключитьВозможностьРедактирования(Команда)
	ВключитьВозможностьРедактированияНаСервере();
КонецПроцедуры

#КонецОбласти

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

#Область Свойства

// СтандартныеПодсистемы.Свойства 
&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры

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

#КонецОбласти

#Область ПодключаемыеКоманды

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

#КонецОбласти

#Область Форма

&НаСервере
Процедура ПриПолученииДанныхНаСервере(ТекущийОбъект = "Объект")
	Если ЗначениеЗаполнено(Объект.Критичность)
		И Элементы.Критичность.ТолькоПросмотр
		И Элементы.Критичность.СписокВыбора.НайтиПоЗначению(Объект.Критичность) = Неопределено Тогда
		Элементы.Критичность.СписокВыбора.Добавить(Объект.Критичность,
			Документы.НесоответствиеСведенийОЗастрахованномЛицеСЭДО.ПредставлениеКритичности(Объект.Критичность));
	КонецЕсли;
	
	ПравоИзменения = (Элементы.Найти("ФормаПровести") <> Неопределено);
	
	БлижайшиеСведения = БлижайшиеСведения();
	СведенияДо        = БлижайшиеСведения.СведенияДо;
	СведенияПосле     = БлижайшиеСведения.СведенияПосле;
	ПоследниеСведения = БлижайшиеСведения.ПоследниеСведения;
	
	ОбновитьЭлементыФормы();
КонецПроцедуры

&НаСервере
Функция БлижайшиеСведения()
	Результат = Новый Структура("СведенияДо, СведенияПосле, ПоследниеСведения");
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	Сведения.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.СведенияОЗастрахованномЛицеФСС КАК Сведения
	|ГДЕ
	|	Сведения.СНИЛС = &СНИЛС
	|	И Сведения.Страхователь = &Страхователь
	|	И Сведения.ПометкаУдаления = ЛОЖЬ
	|	И Сведения.ДатаОтправки <= &ВходящаяДата
	|	И Сведения.ДатаОтправки > ДАТАВРЕМЯ(1, 1, 1)
	|	И ВЫБОР
	|			КОГДА Сведения.ДатаОтправки = &ВходящаяДата
	|				ТОГДА Сведения.Дата < &Дата
	|			ИНАЧЕ ИСТИНА
	|		КОНЕЦ
	|
	|УПОРЯДОЧИТЬ ПО
	|	Сведения.ДатаОтправки УБЫВ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	Сведения.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.СведенияОЗастрахованномЛицеФСС КАК Сведения
	|ГДЕ
	|	Сведения.СНИЛС = &СНИЛС
	|	И Сведения.Страхователь = &Страхователь
	|	И Сведения.ПометкаУдаления = ЛОЖЬ
	|	И Сведения.ДатаОтправки >= &ВходящаяДата
	|	И ВЫБОР
	|			КОГДА Сведения.ДатаОтправки = &ВходящаяДата
	|				ТОГДА Сведения.Дата > &Дата
	|			ИНАЧЕ ИСТИНА
	|		КОНЕЦ
	|
	|УПОРЯДОЧИТЬ ПО
	|	Сведения.Дата
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗастрахованныеЛицаСЭДО.ПоследниеСведения КАК ПоследниеСведения
	|ИЗ
	|	РегистрСведений.ЗастрахованныеЛицаСЭДО КАК ЗастрахованныеЛицаСЭДО
	|ГДЕ
	|	ЗастрахованныеЛицаСЭДО.СНИЛС = &СНИЛС
	|	И ЗастрахованныеЛицаСЭДО.Страхователь = &Страхователь";
	Запрос.УстановитьПараметр("СНИЛС",        Объект.СНИЛС);
	Запрос.УстановитьПараметр("Страхователь", Объект.Страхователь);
	Запрос.УстановитьПараметр("ВходящаяДата", Объект.ВходящаяДата);
	Запрос.УстановитьПараметр("Дата",         Объект.Дата);
	
	РезультатыЗапроса = Запрос.ВыполнитьПакет();
	
	Таблица = РезультатыЗапроса[0].Выгрузить();
	Для Каждого СтрокаТаблицы Из Таблица Цикл
		Результат.СведенияДо = СтрокаТаблицы.Ссылка;
	КонецЦикла;
	
	Таблица = РезультатыЗапроса[1].Выгрузить();
	Для Каждого СтрокаТаблицы Из Таблица Цикл
		Если Результат.СведенияДо <> СтрокаТаблицы.Ссылка Тогда
			Результат.СведенияПосле = СтрокаТаблицы.Ссылка;
		КонецЕсли;
	КонецЦикла;
	
	Таблица = РезультатыЗапроса[2].Выгрузить();
	Для Каждого СтрокаТаблицы Из Таблица Цикл
		Результат.ПоследниеСведения = СтрокаТаблицы.ПоследниеСведения;
	КонецЦикла;
	
	Возврат Результат;
КонецФункции

&НаКлиенте
Процедура ПодключитьОбработчикОжиданияПрочитать()
	ОтключитьОбработчикОжидания("ПрочитатьНаКлиенте");
	ПодключитьОбработчикОжидания("ПрочитатьНаКлиенте", 0.1, Истина);
КонецПроцедуры

&НаКлиенте
Процедура ПрочитатьНаКлиенте()
	Прочитать();
КонецПроцедуры

&НаСервере
Процедура ОбновитьЭлементыФормы()
	
	Элементы.ФормаВключитьВозможностьРедактирования.Видимость = ПравоИзменения;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервере
Процедура ВключитьВозможностьРедактированияНаСервере()
	Если Не ПравоИзменения Тогда
		Возврат;
	КонецЕсли;
	
	Элементы.Критичность.СписокВыбора.Очистить();
	Элементы.Критичность.РежимВыбораИзСписка = Ложь;
	Элементы.Критичность.ТолькоПросмотр = Ложь;
	Элементы.Тип.ТолькоПросмотр = Ложь;
	Элементы.СотрудникНеЧислится.ТолькоПросмотр = Ложь;
	
	Элементы.Страхователь.ТолькоПросмотр = Ложь;
	Элементы.Дата.ТолькоПросмотр = Ложь;
	Элементы.Номер.ТолькоПросмотр = Ложь;
	Элементы.СНИЛС.ТолькоПросмотр = Ложь;
	Элементы.ВходящаяДата.ТолькоПросмотр = Ложь;
	Элементы.Текст.ТолькоПросмотр = Ложь;
	Элементы.ГоловнаяОрганизация.ТолькоПросмотр = Ложь;
	
	Элементы.ФизическоеЛицо.Вид = ВидПоляФормы.ПолеВвода;
	Элементы.ФизическоеЛицо.ТолькоПросмотр = Ложь;
КонецПроцедуры

#КонецОбласти

#Область Сотрудник

&НаСервере
Процедура СНИЛСПриИзмененииНаСервере()
	Документы.НесоответствиеСведенийОЗастрахованномЛицеСЭДО.ЗаполнитьФизлицоФИО(Объект);
КонецПроцедуры

#КонецОбласти

#Область Поддержка

&НаСервере
Функция ПодготовитьВопросВПоддержку()
	ДокументОбъект = РеквизитФормыВЗначение("Объект");
	
	//  Вложения - Массив Из Структура, Неопределено - файлы вложений. Важно: допускаются только
	//              текстовые вложения (*.txt). Поля структуры элемента вложения:
	//   *Представление - Строка - представление вложения. Например, "Вложение 1.txt";
	//   *ВидДанных - Строка - определяет преобразование переданных данных.
	//                Возможна передача одного из значений:
	//                  - ИмяФайла - Строка - полное имя файла вложения;
	//                  - Адрес - Строка - адрес во временном хранилище значения типа ДвоичныеДанные;
	//                  - Текст - Строка - текст вложения;
	//   *Данные - Строка - данные для формирования вложения;
	Вложения = Новый Массив;
	
	МассивСведений = Новый Массив;
	Если ЗначениеЗаполнено(СведенияДо) Тогда
		МассивСведений.Добавить(СведенияДо);
	КонецЕсли;
	Если ЗначениеЗаполнено(СведенияПосле) Тогда
		МассивСведений.Добавить(СведенияПосле);
	КонецЕсли;
	
	Если МассивСведений.Количество() > 0 Тогда
		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ
		|	Сведения.Ссылка КАК СведенияСсылка,
		|	ЕСТЬNULL(Регистрация.ДоставкаИдентификатор, """") КАК ДоставкаИдентификатор,
		|	ЕСТЬNULL(ВходящиеСведения.Содержимое, НЕОПРЕДЕЛЕНО) КАК ДоставкаХранилищеXML
		|	Сведения.ХранилищеXML КАК СведенияХранилищеXML,
		|	Сведения.ДатаОтправки КАК СведенияДатаОтправки,
		|	ЕСТЬNULL(Регистрация.РегистрацияИдентификатор, """") КАК РегистрацияИдентификатор,
		|	ЕСТЬNULL(ВходящиеРегистрации.Содержимое, НЕОПРЕДЕЛЕНО) КАК РегистрацияХранилищеXML
		|ИЗ
		|	Документ.СведенияОЗастрахованномЛицеФСС КАК Сведения
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.РегистрацияСведенийОЗастрахованномЛицеФСС КАК Регистрация
		|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ВходящиеСообщенияСЭДОФСС КАК ВходящиеСведения
		|			ПО Регистрация.ДоставкаИдентификатор = ВходящиеСведения.Идентификатор
		|				И Регистрация.Страхователь = ВходящиеСведения.Организация
		|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ВходящиеСообщенияСЭДОФСС КАК ВходящиеРегистрации
		|			ПО Регистрация.РегистрацияИдентификатор = ВходящиеРегистрации.Идентификатор
		|				И Регистрация.Страхователь = ВходящиеРегистрации.Организация
		|		ПО Сведения.РегистрацияСведений = Регистрация.Ссылка
		|ГДЕ
		|	Сведения.Ссылка В(&МассивСведений)";
		Запрос.УстановитьПараметр("МассивСведений", МассивСведений);
		
		Таблица = Запрос.Выполнить().Выгрузить();
		Для Каждого СтрокаТаблицы Из Таблица Цикл
			Уточнение = ?(СтрокаТаблицы.СведенияСсылка = СведенияДо, НСтр("ru = 'СведенияДо';
																			|en = 'СведенияДо'"), НСтр("ru = 'СведенияПосле';
																									|en = 'СведенияПосле'"));
			
			ТекстXML = СтрокаТаблицы.СведенияХранилищеXML.Получить();
			Если ЗначениеЗаполнено(ТекстXML) Тогда
				ДвоичныеДанные = ЗарплатаКадры.СтрокаВДвоичныеДанные(ТекстXML, КодировкаТекста.UTF8, Истина);
				Вложение = Новый Структура("Представление, ВидДанных, Данные");
				Вложение.Представление = Уточнение + "_" + СтрокаТаблицы.ДоставкаИдентификатор + ".xml";
				Вложение.ВидДанных     = "Адрес";
				Вложение.Данные        = ПоместитьВоВременноеХранилище(ДвоичныеДанные);
				Вложения.Добавить(Вложение);
			КонецЕсли;
			
			Если СтрокаТаблицы.ДоставкаХранилищеXML <> Неопределено Тогда
				ТекстXML = СтрокаТаблицы.ДоставкаХранилищеXML.Получить();
				Если ЗначениеЗаполнено(ТекстXML) Тогда
					Кодировка = СериализацияБЗК.КодировкаXML(ТекстXML);
					ДвоичныеДанные = ЗарплатаКадры.СтрокаВДвоичныеДанные(ТекстXML, Кодировка, Истина);
					Вложение = Новый Структура("Представление, ВидДанных, Данные");
					Вложение.Представление = Уточнение + НСтр("ru = 'Доставка';
																|en = 'Delivery'") + "_" + СтрокаТаблицы.ДоставкаИдентификатор + ".xml";
					Вложение.ВидДанных     = "Адрес";
					Вложение.Данные        = ПоместитьВоВременноеХранилище(ДвоичныеДанные);
					Вложения.Добавить(Вложение);
				КонецЕсли;
			КонецЕсли;
			
			Если СтрокаТаблицы.РегистрацияХранилищеXML <> Неопределено Тогда
				ТекстXML = СтрокаТаблицы.РегистрацияХранилищеXML.Получить();
				Если ЗначениеЗаполнено(ТекстXML) Тогда
					Кодировка = СериализацияБЗК.КодировкаXML(ТекстXML);
					ДвоичныеДанные = ЗарплатаКадры.СтрокаВДвоичныеДанные(ТекстXML, Кодировка, Истина);
					Вложение = Новый Структура("Представление, ВидДанных, Данные");
					Вложение.Представление = Уточнение + НСтр("ru = 'Регистрация';
																|en = 'Registration'") + "_" + СтрокаТаблицы.РегистрацияИдентификатор + ".xml";
					Вложение.ВидДанных     = "Адрес";
					Вложение.Данные        = ПоместитьВоВременноеХранилище(ДвоичныеДанные);
					Вложения.Добавить(Вложение);
				КонецЕсли;
			КонецЕсли;
			
		КонецЦикла;
	КонецЕсли;
	
	Возврат СЭДОФСС.ПодготовитьВопросВПоддержку(ДокументОбъект, Вложения);
КонецФункции

#КонецОбласти

#КонецОбласти
