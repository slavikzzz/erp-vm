#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Ключ.Пустая() Тогда
		ОблагаетсяНДФЛ = 1;
	КонецЕсли;
	
	ДатаИзмененийК353ФЗ = ЗарплатаКадрыПовтИсп.ДатаВступленияВСилуНА("ИзмененияК353ФЗ");
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ВидДоходаИсполнительногоПроизводства",
		"Заголовок",
		СтрШаблон(НСтр("ru = 'Вид дохода (исполнительные листы) до %1';
						|en = 'Income kind (garnishment orders) before %1'"), Формат(ДатаИзмененийК353ФЗ,"ДЛФ=D")));
		
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ВидДоходаИсполнительногоПроизводства2022",
		"Заголовок",
		СтрШаблон(НСтр("ru = 'Вид дохода (исполнительные листы) с %1';
						|en = 'Income kind (garnishment orders) from %1'"), Формат(ДатаИзмененийК353ФЗ,"ДЛФ=DD")));
	
	ВидыДоходовИсполнительногоПроизводстваКлиентСервер.НастроитьПолеВидДоходаДляВыплатыЗарплаты(ЭтотОбъект,ДатаИзмененийК353ФЗ - 1);
	ВидыДоходовИсполнительногоПроизводстваКлиентСервер.НастроитьПолеВидДоходаДляВыплатыЗарплаты(ЭтотОбъект,ДатаИзмененийК353ФЗ, "ВидДоходаИсполнительногоПроизводства2022"); 
	
	УстановитьДоступностьКодаДоходаНДФЛ(ЭтаФорма);
	КодДоходаНДФЛПрежнееЗначение = Объект.КодДоходаНДФЛ;
	КатегорияДоходаПрежнееЗначение = Объект.КатегорияДохода;
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	// СтандартныеПодсистемы.Свойства
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект, ДополнительныеПараметры);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ОблагаетсяНДФЛ = ?(ЗначениеЗаполнено(Объект.КодДоходаНДФЛ),1,0);
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
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

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если ОблагаетсяНДФЛ = 1 Тогда
		Если Не ЗначениеЗаполнено(Объект.КодДоходаНДФЛ) Тогда
			ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'Код дохода НДФЛ не заполнен.';
														|en = 'PIT income code is not populated.'"), , , "Объект.КодДоходаНДФЛ" , Отказ);
		ИначеЕсли Не ЗначениеЗаполнено(Объект.КатегорияДохода) Тогда
			ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'Категория дохода не заполнена.';
														|en = 'Income category is not filled in.'"), , , "Объект.КатегорияДохода" , Отказ);
		КонецЕсли;
	КонецЕсли;
	
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
Процедура ОблагаетсяНДФЛПриИзменении(Элемент)
	
	Если ОблагаетсяНДФЛ = 1 Тогда
		Объект.КодДоходаНДФЛ	= КодДоходаНДФЛПрежнееЗначение;
		Объект.КатегорияДохода	= КатегорияДоходаПрежнееЗначение;
	Иначе
		КодДоходаНДФЛПрежнееЗначение	= Объект.КодДоходаНДФЛ;
		КатегорияДоходаПрежнееЗначение	= Объект.КатегорияДохода;
		Объект.КодДоходаНДФЛ			= Неопределено;
		Объект.КатегорияДохода			= Неопределено;
	КонецЕсли;
	
	УстановитьДоступностьКодаДоходаНДФЛ(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура КодДоходаНДФЛПриИзменении(Элемент)
	Объект.СтрокаРаздела2Расчета6НДФЛ = УчетНДФЛКлиентПовтИсп.СтрокаРаздела2Расчета6НДФЛПоКодуДохода(Объект.КодДоходаНДФЛ);
	Объект.КатегорияДохода = УчетНДФЛКлиентПовтИсп.КатегорияДоходаПоКоду(Объект.КодДоходаНДФЛ);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

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

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДоступностьКодаДоходаНДФЛ(Форма)
	
	ДоступностьКодаНДФЛ = Форма.ОблагаетсяНДФЛ = 1;
	
	Объект = Форма.Объект;
	Элементы = Форма.Элементы;

	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "КодДоходаНДФЛ", "Доступность", ДоступностьКодаНДФЛ);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "КодДоходаНДФЛ", "АвтоОтметкаНезаполненного", ДоступностьКодаНДФЛ);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "КодДоходаНДФЛ", "ОтметкаНезаполненного",
		НЕ ЗначениеЗаполнено(Объект.КодДоходаНДФЛ));
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "КатегорияДохода", "Доступность", ДоступностьКодаНДФЛ);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "КатегорияДохода", "АвтоОтметкаНезаполненного", ДоступностьКодаНДФЛ);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "КатегорияДохода", "ОтметкаНезаполненного",
		НЕ ЗначениеЗаполнено(Объект.КодДоходаНДФЛ));
	
КонецПроцедуры

#КонецОбласти
