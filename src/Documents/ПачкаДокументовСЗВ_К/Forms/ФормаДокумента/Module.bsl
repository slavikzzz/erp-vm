#Область ОписаниеПеременных

&НаКлиенте
Перем мНомерТекущейСтрокиЗаписиОСтаже;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиентСервер.ПриИнициализацииФормыРегламентированногоОтчета(ЭтаФорма, "ПФР");	
	ЭлектронныйДокументооборотСКонтролирующимиОрганами.ОтметитьКакПрочтенное(Объект.Ссылка);
	
	Если Параметры.Ключ.Пустая() Тогда
		ЗапрашиваемыеЗначенияПервоначальногоЗаполнения();
		ЗарплатаКадры.ЗаполнитьПервоначальныеЗначенияВФорме(ЭтаФорма, ЗапрашиваемыеЗначенияПервоначальногоЗаполнения());
		УстановитьСвойствоФактПроживанияВКрымуВидимость();
	КонецЕсли;
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.КоманднаяПанель = Элементы.ГруппаПечатьПереопределенная;
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.Свойства
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект, ДополнительныеПараметры);
	// Конец СтандартныеПодсистемы.Свойства
	
	// ПанельОтправкиВКонтролирующиеОрганы
	РегламентированнаяОтчетностьКлиентСервер.ПриИнициализацииФормыРегламентированногоОтчета(ЭтаФорма, "ПФР");
	// Конец ПанельОтправкиВКонтролирующиеОрганы
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ФлагБлокировкиДокумента = Объект.ДокументПринятВПФР;
	ОтправленВПФР = ЭлектронныйДокументооборотСКонтролирующимиОрганамиВызовСервера.ОбъектОтправлялсяВКонтролирующиеОрганы(Объект.Ссылка);
	
	УстановитьСвойствоФактПроживанияВКрымуВидимость();
	УстановитьСвойстваЭлементовФормы();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// ПанельОтправкиВКонтролирующиеОрганы
	СохранитьСтатусОтправки(ЭтотОбъект, Объект.Ссылка);
	// Конец ПанельОтправкиВКонтролирующиеОрганы
	
	УстановитьДоступностьДанныхФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("Запись_ПачкаДокументовСЗВ_К", ПараметрыЗаписи, Объект.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "ИзменениеДанныхФизическогоЛица" Тогда
		СтруктураОтбора = Новый Структура("Сотрудник", Источник);
		СтрокиПоСотруднику = Объект.Сотрудники.НайтиСтроки(СтруктураОтбора);
		ЗарплатаКадрыКлиентСервер.ОбработкаИзмененияДанныхФизическогоЛица(Объект, Параметр, СтрокиПоСотруднику, Модифицированность);
	ИначеЕсли ИмяСобытия = "РедактированиеДанныхСЗВ6ПоСотруднику" Тогда
		ПриИзмененииДанныхДокументаПоСотруднику(Параметр.АдресВоВременномХранилище);			
	КонецЕсли;
	
	// СтандартныеПодсистемы.Свойства
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтотОбъект, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
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

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	
	ДатаПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	ОрганизацияПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ФлагБлокировкиДокументаПриИзменении(Элемент)
	ФлагБлокировкиДокументаПриИзмененииНаСервере();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСотрудники

&НаКлиенте
Процедура СотрудникиСотрудникПриИзменении(Элемент)
	СтрокаТаблицы = Объект.Сотрудники.НайтиПоИдентификатору(Элементы.Сотрудники.ТекущаяСтрока);	
	Если СтрокаТаблицы <> Неопределено Тогда
		ЗаполнитьДанныеСотрудникаНаСервере();
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура СотрудникиОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	ОбработатьПодборНаСервере(ВыбранноеЗначение);
КонецПроцедуры

&НаКлиенте
Процедура СотрудникиПередУдалением(Элемент, Отказ)
	Для Каждого Идентификатор Из Элемент.ВыделенныеСтроки Цикл
		СтрокаСотрудник = Объект.Сотрудники.НайтиПоИдентификатору(Идентификатор);
		Если СтрокаСотрудник <> Неопределено Тогда 
			УдалитьСтрокиТаблицыЗаписиОСтаже(СтрокаСотрудник.Сотрудник);
			УдалитьСтрокиТаблицыПенсионныхСведений(СтрокаСотрудник.Сотрудник);
		КонецЕсли;
	КонецЦикла;	
КонецПроцедуры

&НаКлиенте
Процедура СотрудникиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	Если Элементы.Сотрудники.ТекущийЭлемент = Элементы.СотрудникиСотрудник
		И Не ЗначениеЗаполнено(Элементы.Сотрудники.ТекущиеДанные.Сотрудник) Тогда
		
		Возврат;
	КонецЕсли;	
		
	ОткрытьФормуРедактированияКарточкиДокумента();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	Оповещение = Новый ОписаниеОповещения("ВыполнитьПодключаемуюКомандуЗавершение", ЭтотОбъект, Команда);
	ПроверитьСЗапросомДальнейшегоДействия(Оповещение);
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьПодключаемуюКомандуЗавершение(Результат, Команда) Экспорт
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

&НаКлиенте
Процедура Подбор(Команда)
	КадровыйУчетКлиент.ПодобратьФизическихЛицОрганизации(Элементы.Сотрудники, Объект.Организация, АдресСпискаПодобранныхСотрудников());
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьНаДиск(Команда)
	Оповещение = Новый ОписаниеОповещения("ЗаписатьНаДискЗавершение", ЭтотОбъект);	
	ПроверитьСЗапросомДальнейшегоДействия(Оповещение);
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФайл(Команда)
	Если Модифицированность Тогда
		Записать();
	КонецЕсли;

	ДанныеФайла = ПолучитьДанныеФайлаНаСервере(Объект.Ссылка, УникальныйИдентификатор);
	Если ДанныеФайла <> Неопределено Тогда
		РаботаСФайламиКлиент.ОткрытьФайл(ДанныеФайла, Ложь);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьВКонтролирующийОрган(Команда)
	Оповещение = Новый ОписаниеОповещения("ОтправитьВКонтролирующийОрганЗавершение", ЭтотОбъект);	
	ПроверитьСЗапросомДальнейшегоДействия(Оповещение);
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьВИнтернете(Команда)
	Если Модифицированность Тогда
		Записать();
	КонецЕсли;

	РегламентированнаяОтчетностьКлиент.ПроверитьВИнтернете(ЭтаФорма, "ПФР");	
КонецПроцедуры

&НаКлиенте
Процедура Проверить(Команда)
	ОчиститьСообщения();

	Отказ = Ложь;
	ПроверкаЗаполненияДокумента(Отказ);
	
	ПроверкаСтороннимиПрограммами(Отказ);
КонецПроцедуры

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

#Область ПанельОтправкиВКонтролирующиеОрганы

&НаКлиенте
Процедура ОбновитьОтправку(Команда)
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОбновитьОтправкуИзПанелиОтправки(ЭтаФорма, "ПФР");
КонецПроцедуры

&НаКлиенте
Процедура ГиперссылкаПротоколНажатие(Элемент)
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОткрытьПротоколИзПанелиОтправки(ЭтаФорма, "ПФР");
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьНеотправленноеИзвещение(Команда)
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОтправитьНеотправленноеИзвещениеИзПанелиОтправки(ЭтаФорма, "ПФР");
КонецПроцедуры

&НаКлиенте
Процедура ЭтапыОтправкиНажатие(Элемент)
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОткрытьСостояниеОтправкиИзПанелиОтправки(ЭтаФорма, "ПФР");
КонецПроцедуры

&НаКлиенте
Процедура КритическиеОшибкиОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылка, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОткрытьКритическиеОшибкиИзПанелиОтправки(ЭтаФорма, "ПФР");
КонецПроцедуры

&НаКлиенте
Процедура ГиперссылкаНаименованиеЭтапаНажатие(Элемент)
	
	ПараметрыИзменения = Новый Структура;
	ПараметрыИзменения.Вставить("Форма", ЭтаФорма);
	ПараметрыИзменения.Вставить("Организация", Объект.Организация);
	ПараметрыИзменения.Вставить("КонтролирующийОрган",
		ПредопределенноеЗначение("Перечисление.ТипыКонтролирующихОрганов.ПФР"));
	
	РегламентированнаяОтчетностьКлиент.ИзменитьСтатусОтправки(ПараметрыИзменения);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура СохранитьСтатусОтправки(Форма, Ссылка)
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("Форма", Форма);
	СтруктураПараметров.Вставить("СсылкаНаОбъект", Ссылка);
	
	ИнтерфейсыВзаимодействияБРО.СохранитьСтатусОтправки(СтруктураПараметров);
	
КонецПроцедуры

#КонецОбласти

&НаСервереБезКонтекста
Функция ЗапрашиваемыеЗначенияПервоначальногоЗаполнения()
	
	ЗапрашиваемыеЗначения = ЗапрашиваемыеЗначенияЗаполненияПоОрганизации();
	ЗапрашиваемыеЗначения.Вставить("Организация", "Объект.Организация");
	ЗапрашиваемыеЗначения.Вставить("Ответственный", "Объект.Ответственный");
	
	Возврат ЗапрашиваемыеЗначения;
	
КонецФункции

&НаСервереБезКонтекста
Функция ЗапрашиваемыеЗначенияЗаполненияПоОрганизации()
	
	ЗапрашиваемыеЗначения = Новый Структура;
	ЗапрашиваемыеЗначения.Вставить("Руководитель", "Объект.Руководитель");
	ЗапрашиваемыеЗначения.Вставить("ДолжностьРуководителя", "Объект.ДолжностьРуководителя");
	
	Возврат ЗапрашиваемыеЗначения;
	
КонецФункции 

&НаСервереБезКонтекста
Функция ПолучитьДанныеФайлаНаСервере(Ссылка, УникальныйИдентификатор)	
	Возврат ЗарплатаКадры.ПолучитьДанныеФайла(Ссылка, УникальныйИдентификатор);	
КонецФункции	

&НаСервере
Процедура ЗаполнитьДанныеСотрудникаНаСервере();
	
	СтрокаТаблицы = Объект.Сотрудники.НайтиПоИдентификатору(Элементы.Сотрудники.ТекущаяСтрока);
	ДанныеСотрудника = ПолучитьДанныеСотрудниковНаСервере(Объект.Дата, СтрокаТаблицы.Сотрудник);
	ФизическиеЛица = Новый Массив;
	
	Если ДанныеСотрудника.Количество() > 0 Тогда
		ЗаполнитьЗначенияСвойств(СтрокаТаблицы, ДанныеСотрудника[0]);
		Если ДанныеСотрудника[0].ФактПроживанияВКрыму Тогда
			ФизическиеЛица.Добавить(ДанныеСотрудника[0].Сотрудник);
		КонецЕсли;
	КонецЕсли;
	
	ЗаполнитьЗаписиОСтаже(ФизическиеЛица);
	
КонецПроцедуры

&НаСервере
Функция ПолучитьДанныеСотрудниковНаСервере(Дата, Сотрудники)

	ТаблицаДанных = КадровыйУчет.КадровыеДанныеФизическихЛиц(Истина, Сотрудники, "Наименование,Фамилия,Имя,Отчество,СтраховойНомерПФР,ПостоянноПроживалВКрыму18Марта2014Года,ФактПроживанияДНРЛНРЗОХО,ФактПроживанияДНРЛНР,ФактПроживанияЗОХО", Дата);
	ТаблицаДанных.Сортировать("Наименование");
	ТаблицаДанных.Колонки.Добавить("Сотрудник");
	ТаблицаДанных.ЗагрузитьКолонку(ТаблицаДанных.ВыгрузитьКолонку("ФизическоеЛицо"), "Сотрудник");
	
	НайденныеСтроки = ТаблицаДанных.НайтиСтроки(Новый Структура("Фамилия", "-"));
	Для Каждого СтрокаТаблицаДанных Из НайденныеСтроки Цикл
		СтрокаТаблицаДанных.Фамилия = "";	
	КонецЦикла;
	
	ТаблицаДанных.Колонки.ПостоянноПроживалВКрыму18Марта2014Года.Имя = "ФактПроживанияВКрыму";
	
	Возврат ТаблицаДанных;
	
КонецФункции	

&НаСервере
Процедура ОбработатьПодборНаСервере(СписокСотрудников)
	
	ТаблицаДанных = ПолучитьДанныеСотрудниковНаСервере(Объект.Дата, СписокСотрудников);
	ФизическиеЛица = Новый Массив;
	
	Для Каждого СтрокаТаблицаДанных Из ТаблицаДанных Цикл
		СтруктураОтбора = Новый Структура("Сотрудник", СтрокаТаблицаДанных.Сотрудник);
		Если Объект.Сотрудники.НайтиСтроки(СтруктураОтбора).Количество() = 0 Тогда 
			НоваяСтрока = Объект.Сотрудники.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТаблицаДанных);
			Если СтрокаТаблицаДанных.ФактПроживанияВКрыму Тогда
				ФизическиеЛица.Добавить(СтрокаТаблицаДанных.Сотрудник);
			КонецЕсли;
		КонецЕсли;				
	КонецЦикла;
	
	ЗаполнитьЗаписиОСтаже(ФизическиеЛица)
	
КонецПроцедуры	

&НаСервере
Процедура ЗаполнитьЗаписиОСтаже(ФизическиеЛица)
	
	Если Не ФактПроживанияВКрымуВидимость Тогда
		Возврат;
	КонецЕсли;
	
	ПерсонифицированныйУчетВнутренний.ЗаполнитьЗаписиОСтажеСЗВК(Объект, ФизическиеЛица);
	
КонецПроцедуры	

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()
	ПерсонифицированныйУчетФормы.ОрганизацияПриИзменении(ЭтаФорма, ЗапрашиваемыеЗначенияЗаполненияПоОрганизации());	
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиентСервер.ПриИнициализацииФормыРегламентированногоОтчета(ЭтаФорма, "ПФР");
	УстановитьСвойствоФактПроживанияВКрымуВидимость();
КонецПроцедуры

&НаСервере
Процедура ДатаПриИзмененииНаСервере()
	
	УстановитьСвойствоФактПроживанияВКрымуВидимость();
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьСтрокиТаблицыЗаписиОСтаже(Сотрудник)
	УдаляемыеСтрокиТаблицы = Объект.ЗаписиОСтаже.НайтиСтроки(Новый Структура("Сотрудник", Сотрудник));
	
	Для Каждого УдаляемаяСтрока Из УдаляемыеСтрокиТаблицы Цикл
		Объект.ЗаписиОСтаже.Удалить(Объект.ЗаписиОСтаже.Индекс(УдаляемаяСтрока));
	КонецЦикла;	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьСтрокиТаблицыПенсионныхСведений(Сотрудник)
	УдаляемыеСтрокиТаблицы = Объект.СведенияДляОценкиПенсионныхПрав.НайтиСтроки(Новый Структура("Сотрудник", Сотрудник));
	
	Для Каждого УдаляемаяСтрока Из УдаляемыеСтрокиТаблицы Цикл
		Объект.СведенияДляОценкиПенсионныхПрав.Удалить(Объект.СведенияДляОценкиПенсионныхПрав.Индекс(УдаляемаяСтрока));
	КонецЦикла;	
КонецПроцедуры

&НаСервере
Функция АдресСпискаПодобранныхСотрудников()
	
	Возврат ПоместитьВоВременноеХранилище(Объект.Сотрудники.Выгрузить(,"Сотрудник").ВыгрузитьКолонку("Сотрудник"), УникальныйИдентификатор);
	
КонецФункции

&НаКлиенте
Процедура ОткрытьФормуРедактированияКарточкиДокумента()
	ДанныеТекущейСтроки = Элементы.Сотрудники.ТекущиеДанные;
	
	ДанныеШапкиТекущегоДокумента = Объект;
		
	Если ДанныеТекущейСтроки <> Неопределено Тогда	
		ДанныеТекущегоДокументаПоСотрудникуВоВременноеХранилище();
		
		ПараметрыОткрытияФормы = Новый Структура;
		ПараметрыОткрытияФормы.Вставить("АдресВоВременномХранилище", АдресДанныхТекущегоДокументаВХранилище);
		ПараметрыОткрытияФормы.Вставить("РедактируемыйДокументСсылка", ДанныеШапкиТекущегоДокумента.Ссылка);
		ПараметрыОткрытияФормы.Вставить("Сотрудник", ДанныеТекущейСтроки.Сотрудник);
		ПараметрыОткрытияФормы.Вставить("ФактПроживанияВКрымуВидимость", ФактПроживанияВКрымуВидимость);
			
		ОткрытьФорму("Документ.ПачкаДокументовСЗВ_К.Форма.ФормаКарточки", ПараметрыОткрытияФормы, ЭтаФорма);	
	КонецЕсли;	
КонецПроцедуры	

&НаСервере
Процедура ДанныеТекущегоДокументаПоСотрудникуВоВременноеХранилище()
	Если Элементы.Сотрудники.ТекущаяСтрока = Неопределено Тогда
		АдресДанныхТекущегоДокументаВХранилище = "";
		Возврат;
	КонецЕсли;	
	
	ДанныеТекущейСтрокиПоСотруднику = Объект.Сотрудники.НайтиПоИдентификатору(Элементы.Сотрудники.ТекущаяСтрока);
	
	Если ДанныеТекущейСтрокиПоСотруднику = Неопределено Тогда
		АдресДанныхТекущегоДокументаВХранилище = "";
		Возврат;
	КонецЕсли;
	
	ДанныеСотрудника = Новый Структура;
	ДанныеСотрудника.Вставить("Сотрудник", ДанныеТекущейСтрокиПоСотруднику.Сотрудник);
	ДанныеСотрудника.Вставить("ТерриториальныеУсловияНа31_12_2001", ДанныеТекущейСтрокиПоСотруднику.ТерриториальныеУсловияНа31_12_2001);
	ДанныеСотрудника.Вставить("РайонныйКоэффициентНа31_12_2001", ДанныеТекущейСтрокиПоСотруднику.РайонныйКоэффициентНа31_12_2001);
	ДанныеСотрудника.Вставить("Фамилия", ДанныеТекущейСтрокиПоСотруднику.Фамилия);
	ДанныеСотрудника.Вставить("Имя", ДанныеТекущейСтрокиПоСотруднику.Имя);
	ДанныеСотрудника.Вставить("Отчество", ДанныеТекущейСтрокиПоСотруднику.Отчество);
	ДанныеСотрудника.Вставить("СтраховойНомерПФР", ДанныеТекущейСтрокиПоСотруднику.СтраховойНомерПФР);
	ДанныеСотрудника.Вставить("ФактПроживанияВКрыму", ДанныеТекущейСтрокиПоСотруднику.ФактПроживанияВКрыму);
	ДанныеСотрудника.Вставить("ФактПроживанияДНРЛНРЗОХО", ДанныеТекущейСтрокиПоСотруднику.ФактПроживанияДНРЛНРЗОХО);
	ДанныеСотрудника.Вставить("ФактПроживанияДНРЛНР", ДанныеТекущейСтрокиПоСотруднику.ФактПроживанияДНРЛНР);
	ДанныеСотрудника.Вставить("ФактПроживанияЗОХО", ДанныеТекущейСтрокиПоСотруднику.ФактПроживанияЗОХО);
	ДанныеСотрудника.Вставить("ДатаДокумента", Объект.Дата);
	ДанныеСотрудника.Вставить("ЗаписиОСтаже", Новый Массив);
	ДанныеСотрудника.Вставить("СведенияДляОценкиПенсионныхПрав", Новый Массив);
		
	СтруктураПоиска = Новый Структура("Сотрудник", ДанныеТекущейСтрокиПоСотруднику.Сотрудник);
				
	СтрокиЗаписиОСтаже = Объект.ЗаписиОСтаже.НайтиСтроки(СтруктураПоиска);
	
	Для Каждого СтрокаСтаж Из СтрокиЗаписиОСтаже Цикл
		СтруктураПолейЗаписиОСтаже = СтруктураПолейЗаписиОСтаже();
		ЗаполнитьЗначенияСвойств(СтруктураПолейЗаписиОСтаже, СтрокаСтаж);
				
		ДанныеСотрудника.ЗаписиОСтаже.Добавить(СтруктураПолейЗаписиОСтаже);
	КонецЦикла;	

	СтрокиИтоговСтажа = Объект.СведенияДляОценкиПенсионныхПрав.НайтиСтроки(СтруктураПоиска);
	
	Для Каждого СтрокаИтоговСтажа Из СтрокиИтоговСтажа Цикл
		СтруктураПолей = СтруктураПолейСведенияДляОценкиПенсионныхПрав();
		ЗаполнитьЗначенияСвойств(СтруктураПолей, СтрокаИтоговСтажа);
				
		ДанныеСотрудника.СведенияДляОценкиПенсионныхПрав.Добавить(СтруктураПолей);
	КонецЦикла;	
	
	Если ЗначениеЗаполнено(АдресДанныхТекущегоДокументаВХранилище) Тогда
		ПоместитьВоВременноеХранилище(ДанныеСотрудника, АдресДанныхТекущегоДокументаВХранилище);	
	Иначе	
		АдресДанныхТекущегоДокументаВХранилище = ПоместитьВоВременноеХранилище(ДанныеСотрудника, УникальныйИдентификатор);
	КонецЕсли;	
	
КонецПроцедуры	

&НаСервере
Функция СтруктураПолейЗаписиОСтаже()
	СтруктураПолей = Новый Структура;
	
	СтруктураПолей.Вставить("НомерПериодаТрудовойДеятельности");
	СтруктураПолей.Вставить("НомерПериодаТрудовойДеятельности");
	СтруктураПолей.Вставить("НомерОсновнойЗаписи");
	СтруктураПолей.Вставить("НомерДополнительнойЗаписи");
	СтруктураПолей.Вставить("ОрганизацияТрудовойДеятельности");
	СтруктураПолей.Вставить("ВидДеятельности");
	СтруктураПолей.Вставить("ДатаНачалаПериода");
	СтруктураПолей.Вставить("ДатаОкончанияПериода");
	СтруктураПолей.Вставить("ОсобыеУсловияТруда");
	СтруктураПолей.Вставить("КодПозицииСписка");
	СтруктураПолей.Вставить("ОснованиеИсчисляемогоСтажа");
	СтруктураПолей.Вставить("НулевойПараметрИсчисляемогоСтажа");
	СтруктураПолей.Вставить("ПервыйПараметрИсчисляемогоСтажа");
	СтруктураПолей.Вставить("ВторойПараметрИсчисляемогоСтажа");
	СтруктураПолей.Вставить("ТретийПараметрИсчисляемогоСтажа");
	СтруктураПолей.Вставить("ОснованиеВыслугиЛет");
	СтруктураПолей.Вставить("ПервыйПараметрВыслугиЛет");
	СтруктураПолей.Вставить("ВторойПараметрВыслугиЛет");
	СтруктураПолей.Вставить("ТретийПараметрВыслугиЛет");
	СтруктураПолей.Вставить("ТерриториальныеУсловия");
	СтруктураПолей.Вставить("РайонныйКоэффициент");
	СтруктураПолей.Вставить("Должность");
	
	Возврат СтруктураПолей;
КонецФункции	

&НаСервере
Функция СтруктураПолейСведенияДляОценкиПенсионныхПрав()
	СтруктураПолей = Новый Структура;
	
	СтруктураПолей.Вставить("ВидСтажа");
	СтруктураПолей.Вставить("НомерЗаписи");
	СтруктураПолей.Вставить("КодСтажа");
	СтруктураПолей.Вставить("ОрганизацияТрудаЛетнойДеятельности");
	СтруктураПолей.Вставить("Месяцев");
	СтруктураПолей.Вставить("Дней");
	СтруктураПолей.Вставить("Лет");
		
	Возврат СтруктураПолей;
КонецФункции	

&НаКлиенте
Процедура ПриИзмененииДанныхДокументаПоСотруднику(АдресВоВременномХранилище)
	ДанныеТекущегоДокументаПоСотрудникуВДанныеФормы(АдресВоВременномХранилище);
КонецПроцедуры	

&НаСервере
Процедура ДанныеТекущегоДокументаПоСотрудникуВДанныеФормы(АдресВоВременномХранилище)
	
	ДанныеШапкиДокумента = Объект;
	
	ДанныеТекущегоДокумента = ПолучитьИзВременногоХранилища(АдресВоВременномХранилище);
	
	Если ДанныеТекущегоДокумента = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеТекущейСтрокиПоСотруднику = Неопределено;
	НайденныеСтроки = Объект.Сотрудники.НайтиСтроки(Новый Структура("Сотрудник", ДанныеТекущегоДокумента.Сотрудник));
		
	Если НайденныеСтроки.Количество() > 0 Тогда
		ДанныеТекущейСтрокиПоСотруднику = НайденныеСтроки[0];
		
		Если ДанныеТекущейСтрокиПоСотруднику.Сотрудник <> ДанныеТекущегоДокумента.Сотрудник Тогда
			ДанныеТекущейСтрокиПоСотруднику = Неопределено;
		КонецЕсли;
	КонецЕсли;
	
	Если ДанныеТекущейСтрокиПоСотруднику = Неопределено  Тогда
		
		ВызватьИсключение НСтр("ru = 'В текущем документе не найдены данные по редактируемому сотруднику.';
								|en = 'Data on the edited employee is not found in the current document.'");
	КонецЕсли;
	
	ДанныеТекущейСтрокиПоСотруднику = Объект.Сотрудники.НайтиПоИдентификатору(Элементы.Сотрудники.ТекущаяСтрока);
		
	ЗаполнитьЗначенияСвойств(ДанныеТекущейСтрокиПоСотруднику, ДанныеТекущегоДокумента);
		
	СтруктураПоиска = Новый Структура("Сотрудник", ДанныеТекущейСтрокиПоСотруднику.Сотрудник);
			
	СтрокиСтажа = Объект.ЗаписиОСтаже.НайтиСтроки(СтруктураПоиска);
	
	Для Каждого СтрокаСтажа Из СтрокиСтажа Цикл
		Объект.ЗаписиОСтаже.Удалить(СтрокаСтажа);
	КонецЦикла;
	
	Для Каждого ДанныеСтажа Из ДанныеТекущегоДокумента.ЗаписиОСтаже Цикл
		СтрокаСтажа = Объект.ЗаписиОСтаже.Добавить();
		СтрокаСтажа.Сотрудник = ДанныеТекущейСтрокиПоСотруднику.Сотрудник;
		ЗаполнитьЗначенияСвойств(СтрокаСтажа, ДанныеСтажа);
	КонецЦикла;	
	
	СтрокиИтогов = Объект.СведенияДляОценкиПенсионныхПрав.НайтиСтроки(СтруктураПоиска);
	
	Для Каждого СтрокаИтогов Из СтрокиИтогов Цикл
		Объект.СведенияДляОценкиПенсионныхПрав.Удалить(СтрокаИтогов);
	КонецЦикла;
	
	Для Каждого ДанныеИтогов Из ДанныеТекущегоДокумента.СведенияДляОценкиПенсионныхПрав Цикл
		СтрокаИтогов = Объект.СведенияДляОценкиПенсионныхПрав.Добавить();
		СтрокаИтогов.Сотрудник = ДанныеТекущейСтрокиПоСотруднику.Сотрудник;
		ЗаполнитьЗначенияСвойств(СтрокаИтогов, ДанныеИтогов);
	КонецЦикла;	
	
	Если ДанныеТекущегоДокумента.Модифицированность Тогда
		Модифицированность = Истина;
	КонецЕсли;
		
КонецПроцедуры

&НаСервере
Процедура УстановитьДоступностьДанныхФормы()
	Если Объект.ДокументПринятВПФР Тогда  
		ТолькоПросмотр = Истина;	
	КонецЕсли;		
КонецПроцедуры	

&НаСервере
Процедура ФлагБлокировкиДокументаПриИзмененииНаСервере()
	Модифицированность = Истина;
	Объект.ДокументПринятВПФР = ФлагБлокировкиДокумента;
	Если Не ФлагБлокировкиДокумента Тогда
		ТолькоПросмотр = Ложь;
	КонецЕсли;	
КонецПроцедуры

&НаСервере
Процедура ПроверкаЗаполненияДокумента(Отказ = Ложь)
	ДокументОбъект = РеквизитФормыВЗначение("Объект");
	
	ДокументОбъект.ПроверитьДанныеДокумента(Отказ);
КонецПроцедуры	

&НаКлиенте
Процедура ПроверкаСтороннимиПрограммами(Отказ)
	
	Если Отказ Тогда
		ТекстВопроса = НСтр("ru = 'При проверке встроенной проверкой обнаружены ошибки.
		|Выполнить проверку сторонними программами?';
		|en = 'Errors occurred while checking with the integrated check.
		|Check with third-party applications?'")
	Иначе	
		ТекстВопроса = НСтр("ru = 'При проверке встроенной проверкой ошибок не обнаружено.
		|Выполнить проверку сторонними программами?';
		|en = 'Errors are not detected while checking with the integrated check.
		|Check with third-party applications?'");
	КонецЕсли;
	
	Оповещение = Новый ОписаниеОповещения("ПроверкаСтороннимиПрограммамиЗавершение", ЭтотОбъект);
	ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверкаСтороннимиПрограммамиЗавершение(Ответ, ДополнительныеПараметры) Экспорт 
	
	Если Ответ = КодВозвратаДиалога.Да Тогда 
		ПроверитьСтороннимиПрограммами();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьСтороннимиПрограммами()
	Если Модифицированность Тогда
		Записать();
	КонецЕсли;

	ПараметрыОткрытия = Новый Структура;
	
	ПроверяемыеОбъекты = Новый Массив;
	ПроверяемыеОбъекты.Добавить(Объект.Ссылка);
	
	ПараметрыОткрытия.Вставить("СсылкиНаПроверяемыеОбъекты", ПроверяемыеОбъекты);
	
	ОткрытьФорму("ОбщаяФорма.ПроверкаФайловОтчетностиПерсУчетаПФР", ПараметрыОткрытия, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьСЗапросомДальнейшегоДействия(ОповещениеЗавершения = Неопределено)
	ОчиститьСообщения();
	
	Отказ = Ложь;
	ПроверкаЗаполненияДокумента(Отказ);	
	
	ДополнительныеПараметры = Новый Структура("ОповещениеЗавершения", ОповещениеЗавершения);
	
	Если Отказ Тогда 
		ТекстВопроса = НСтр("ru = 'В комплекте обнаружены ошибки.
							|Продолжить (не рекомендуется)?';
							|en = 'Errors were detected in the set.
							|Continue (not recommended)?'");
							
		Оповещение = Новый ОписаниеОповещения("ПроверитьСЗапросомДальнейшегоДействияЗавершение", ЭтотОбъект, ДополнительныеПараметры);					
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Нет, НСтр("ru = 'Предупреждение.';
																											|en = 'Warning.'"));
	Иначе 
		ПроверитьСЗапросомДальнейшегоДействияЗавершение(КодВозвратаДиалога.Да, ДополнительныеПараметры);				
	КонецЕсли;	
	
КонецПроцедуры	

&НаКлиенте
Процедура ПроверитьСЗапросомДальнейшегоДействияЗавершение(Ответ, ДополнительныеПараметры) Экспорт 
	
	Если Ответ <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;			
	
	Если ДополнительныеПараметры.ОповещениеЗавершения <> Неопределено Тогда 
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеЗавершения);
	КонецЕсли;
	
КонецПроцедуры	

&НаКлиенте
Процедура ЗаписатьНаДискЗавершение(Результат, Параметры) Экспорт
	Если Модифицированность Тогда
		Записать();
	КонецЕсли;

	ДанныеФайла = ПолучитьДанныеФайлаНаСервере(Объект.Ссылка, УникальныйИдентификатор);
	РаботаСФайламиКлиент.СохранитьФайлКак(ДанныеФайла);	
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьВКонтролирующийОрганЗавершение(Результат, Параметры) Экспорт
	Если Модифицированность Тогда
		Записать();
	КонецЕсли;

	РегламентированнаяОтчетностьКлиент.ПриНажатииНаКнопкуОтправкиВКонтролирующийОрган(ЭтаФорма, "ПФР");	
КонецПроцедуры

&НаСервере
Процедура УстановитьСвойствоФактПроживанияВКрымуВидимость()
	
	ФактПроживанияВКрымуВидимость = Ложь;
	
	Если Не ЗначениеЗаполнено(Объект.Организация) Тогда
		Возврат;
	КонецЕсли;
	
	СведенияОбОрганизации = ПерсонифицированныйУчет.СведенияОбОрганизации(Объект.Организация, Объект.Дата);
	Если ПерсонифицированныйУчет.ОрганизацияЗарегистрированаВКрыму(СведенияОбОрганизации.КПП, СведенияОбОрганизации.РегистрацияВНалоговомОргане) Тогда
		ФактПроживанияВКрымуВидимость = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьСвойстваЭлементовФормы()
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "Организация", "ТолькоПросмотр", ОтправленВПФР);
	
КонецПроцедуры

#КонецОбласти
