#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Настройки общей формы отчета подсистемы "Варианты отчетов".
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - Форма отчета.
//   КлючВарианта - Строка - Имя предопределенного варианта отчета или уникальный идентификатор пользовательского.
//   Настройки - См. ОтчетыКлиентСервер.ПолучитьНастройкиОтчетаПоУмолчанию
//
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	Настройки.События.ПриСозданииНаСервере = Истина;
	Настройки.События.ПриЗагрузкеПользовательскихНастроекНаСервере = Истина;
КонецПроцедуры

// Вызывается в обработчике одноименного события формы отчета после выполнения кода формы.
//
// Параметры:
//   ЭтаФорма             - ФормаКлиентскогоПриложения - Форма отчета.
//   Отказ                - Булево - передается из параметров обработчика "как есть".
//   СтандартнаяОбработка - Булево - передается из параметров обработчика "как есть".
//
// См. также:
//   "ФормаКлиентскогоПриложения.ПриСозданииНаСервере" в синтакс-помощнике.
//
Процедура ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка) Экспорт
	Параметры = ЭтаФорма.Параметры;
	
	КомпоновщикНастроекФормы = ЭтаФорма.Отчет.КомпоновщикНастроек;
	
	Если Параметры.Свойство("Расшифровка") 
		И ТипЗнч(Параметры.Расшифровка) = Тип("Структура")
		И Параметры.Расшифровка.Свойство("ТекущийПериод") Тогда
	
		ПараметрыРасшифровки = Параметры.Расшифровка;
		ПрименяемыеНастройки = КомпоновщикНастроекФормы.ФиксированныеНастройки;
		
		// Установить параметры данных
		КомпоновкаДанныхКлиентСервер.УстановитьПараметр(ПрименяемыеНастройки, 
			"ТекущийПериод", ПараметрыРасшифровки.ТекущийПериод);
		КомпоновкаДанныхКлиентСервер.УстановитьПараметр(ПрименяемыеНастройки, 
			"ПрошлыйПериод", ПараметрыРасшифровки.ПрошлыйПериод);
		КомпоновкаДанныхКлиентСервер.УстановитьПараметр(ПрименяемыеНастройки, 
			"ТипПараметраКлассификации", ПараметрыРасшифровки.ТипПараметраКлассификации);
		КомпоновкаДанныхКлиентСервер.УстановитьПараметр(ПрименяемыеНастройки, 
			"СтрокаТекущая", НСтр("ru = 'Текущая';
									|en = 'Current'"));
		КомпоновкаДанныхКлиентСервер.УстановитьПараметр(ПрименяемыеНастройки, 
			"СтрокаПредыдущая", НСтр("ru = 'Предыдущая';
									|en = 'Previous'"));
			
		// Установить отбор
		ОтборРасшифровки = ПрименяемыеНастройки.Отбор; // ОтборКомпоновкиДанных
		Для Каждого Элемент Из ПараметрыРасшифровки.Отбор Цикл
			ЭлементОтбора = ОтборРасшифровки.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
			ЭлементОтбора.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных(Элемент.Ключ);
			ЭлементОтбора.ПравоеЗначение = Элемент.Значение;
			ЭлементОтбора.Использование  = Истина;
		КонецЦикла;
		
		ПараметрыРасшифровки.Вставить("ПрименяемыеНастройки", ПрименяемыеНастройки);
	Иначе
		Отказ = Истина;
	КонецЕсли;
КонецПроцедуры

// Вызывается в одноименном обработчике формы отчета после выполнения кода формы.
//
// Параметры:
//   ЭтаФорма          - ФормаКлиентскогоПриложения - Форма отчета, содержит:
//     * Параметры - Структура - содержит:
//       ** Расшифровка - Структура - содержит:
//         *** Заголовок - Строка -
//   НовыеНастройкиКД  - НастройкиКомпоновкиДанных - настройки, которые будут установлены.
//
Процедура ПриЗагрузкеПользовательскихНастроекНаСервере(ЭтаФорма, НовыеНастройкиКД) Экспорт
	
	Отчет = ЭтаФорма.Отчет;
	Параметры = ЭтаФорма.Параметры;

	Если Не Параметры.Свойство("Расшифровка") 
		Или ТипЗнч(Параметры.Расшифровка) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	// Установить заголовки
	ПараметрыРасшифровки = Параметры.Расшифровка;
	Настройки = Отчет.КомпоновщикНастроек.Настройки; // НастройкиКомпоновкиДанных - 
	Настройки.ПараметрыВывода.УстановитьЗначениеПараметра("Заголовок", ПараметрыРасшифровки.Заголовок);
	Выбор = Настройки.Выбор.Элементы;
	ПредыдущееЗначениеПараметра = Новый ПолеКомпоновкиДанных("ПрошлоеЗначениеПараметраКлассификации");
	ТекущееЗначениеПараметра = Новый ПолеКомпоновкиДанных("ТекущееЗначениеПараметраКлассификации");
	Для Каждого Элемент Из Выбор Цикл
		Если Элемент.Поле = ПредыдущееЗначениеПараметра
		 Или Элемент.Поле = ТекущееЗначениеПараметра Тогда
			Элемент.Заголовок = ПараметрыРасшифровки.ТипПараметраКлассификации;
		КонецЕсли;
	КонецЦикла;
	
	// Если есть Расшифровка Отбор и Параметры данных попадут в Настройки из Фиксированных настроек
	Для каждого Параметр Из Настройки.ПараметрыДанных.Элементы Цикл
		Параметр.Значение = Неопределено;
		Параметр.Использование = ложь;
	КонецЦикла;
	Настройки.Отбор.Элементы.Очистить();
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли