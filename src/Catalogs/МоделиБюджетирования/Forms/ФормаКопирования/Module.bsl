
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("МодельКопирования") Тогда
		МодельКопирования = Параметры.МодельКопирования;
	КонецЕсли;
	
	Если Параметры.Свойство("МодельБюджетирования") Тогда
		МодельБюджетирования = Параметры.МодельБюджетирования;
	КонецЕсли;	

	ЗаполнитьДеревоВидовБюджетов();

	//++ НЕ УТКА
	Если ПолучитьФункциональнуюОпцию("ИспользоватьБюджетныйПроцесс") Тогда
		ЗаполнитьДеревоЭтапыПодготовкиБюджетов();
	КонецЕсли;
	//-- НЕ УТКА 
		
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// Раскроем верхний уровень дерева
	ЭлементыДерева = ВидыБюджетов.ПолучитьЭлементы();
	Для каждого ЭлементДерева Из ЭлементыДерева Цикл
		Элементы.ВидыБюджетов.Развернуть(ЭлементДерева.ПолучитьИдентификатор());
	КонецЦикла;
	
	//++ НЕ УТКА
	ЭлементыДерева = ЭтапыПодготовкиБюджетов.ПолучитьЭлементы();
	Для каждого ЭлементДерева Из ЭлементыДерева Цикл
		Элементы.ЭтапыПодготовкиБюджетов.Развернуть(ЭлементДерева.ПолучитьИдентификатор());
	КонецЦикла;
	//-- НЕ УТКА
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ВидыБюджетовФлагПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ВидыБюджетов.ТекущиеДанные;
	УстановитьПометкиПодчиненных(ТекущиеДанные, "Флаг");
	УстановитьПометкиРодителей(ТекущиеДанные, "Флаг");

КонецПроцедуры

&НаКлиенте
Процедура ЭтапыПодготовкиБюджетовФлагПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ЭтапыПодготовкиБюджетов.ТекущиеДанные;
	УстановитьПометкиПодчиненных(ТекущиеДанные, "Флаг");
	УстановитьПометкиРодителей(ТекущиеДанные, "Флаг");

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура УстановитьФлажки(Команда)
	
	Дерево = Неопределено;
	Если Элементы.СтраницыВидыЭтапыБюджета.ТекущаяСтраница = Элементы.СтраницаВидыБюджетов Тогда
		Дерево = ВидыБюджетов;
	ИначеЕсли  Элементы.СтраницыВидыЭтапыБюджета.ТекущаяСтраница = Элементы.СтраницаЭтапыПодготовкиБюджетов Тогда
		Дерево = ЭтапыПодготовкиБюджетов;
	Иначе
		Возврат;
	КонецЕсли;
	
	Для Каждого Строка Из Дерево.ПолучитьЭлементы() Цикл
		Строка.Флаг = Истина;
		УстановитьПометкиПодчиненных(Строка, "Флаг");
	КонецЦикла;

КонецПроцедуры

&НаКлиенте
Процедура СнятьФлажки(Команда)
	
	Дерево = Неопределено;
	Если Элементы.СтраницыВидыЭтапыБюджета.ТекущаяСтраница = Элементы.СтраницаВидыБюджетов Тогда
		Дерево = ВидыБюджетов;
	ИначеЕсли  Элементы.СтраницыВидыЭтапыБюджета.ТекущаяСтраница = Элементы.СтраницаЭтапыПодготовкиБюджетов Тогда
		Дерево = ЭтапыПодготовкиБюджетов;
	Иначе
		Возврат;
	КонецЕсли;

	Для Каждого Строка Из Дерево.ПолучитьЭлементы() Цикл
		Строка.Флаг = Ложь;
		УстановитьПометкиПодчиненных(Строка, "Флаг");
	КонецЦикла;

КонецПроцедуры

&НаКлиенте
Процедура Скопировать(Команда)
	
	ВыбранныеВидыБюджетов = ПолучитьВыбранныеЭлементыОтбора(ВидыБюджетов,"Ссылка");
	ВыбранныеЭтапыПодготовкиБюджетов = ПолучитьВыбранныеЭлементыОтбора(ЭтапыПодготовкиБюджетов,"Ссылка");
	
	СкопироватьНаСервере(МодельБюджетирования, МодельКопирования, ВыбранныеВидыБюджетов, ВыбранныеЭтапыПодготовкиБюджетов, КопироватьЛимиты);
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьДеревоВидовБюджетов()
	
	//++ Локализация
	Компоновка = Обработки.ПомощникВыгрузкиЗагрузкиМоделиБюджетирования.ПолучитьМакет("ВидыБюджетов");
	
	КомпоновщикНастроек = Новый КомпоновщикНастроекКомпоновкиДанных;
	КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(Компоновка));
	КомпоновщикНастроек.ЗагрузитьНастройки(Компоновка.НастройкиПоУмолчанию);
	
	ФинансоваяОтчетностьСервер.УстановитьПараметрКомпоновки(КомпоновщикНастроек.Настройки, "ВыбранныеВидыБюджетов", Новый Массив());
	ФинансоваяОтчетностьСервер.УстановитьПараметрКомпоновки(КомпоновщикНастроек.Настройки, "Владелец", МодельКопирования);
				
	РезультатДерево = ФинансоваяОтчетностьСервер.ВыгрузитьРезультатСКД(Компоновка,КомпоновщикНастроек.Настройки,, Истина);
	
	ЗначениеВРеквизитФормы(РезультатДерево, "ВидыБюджетов");
	//-- Локализация
	Возврат; // в международной поставке не используется
	
КонецПроцедуры

// Устанавливает состояние пометки у подчиненных строк строки дерева значений
// в зависимости от пометки текущей строки.
//
// Параметры:
//  ТекСтрока - СтрокаДереваЗначений - Строка дерева значений.
//  ИмяФлажка - Строка - Имя колонки дерева.
// 
&НаКлиенте
Процедура УстановитьПометкиПодчиненных(ТекСтрока, ИмяФлажка)
	
	Подчиненные = ТекСтрока.ПолучитьЭлементы();
	
	Если Подчиненные.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого Строка Из Подчиненные Цикл
		
		Строка[ИмяФлажка] = ТекСтрока[ИмяФлажка];
		
		УстановитьПометкиПодчиненных(Строка, ИмяФлажка);
		
	КонецЦикла;
		
КонецПроцедуры

&НаСервереБезКонтекста
Процедура СкопироватьНаСервере(МодельБюджетирования, МодельКопирования, ВыбранныеВидыБюджетов, ВыбранныеЭтапыПодготовкиБюджетов = Неопределено, КопироватьЛимиты=Ложь)
	
	КодЯзыка = ОбщегоНазначения.КодОсновногоЯзыка();
	НачатьТранзакцию();
	
	Попытка

		СоответствиеСсылок = Новый Соответствие();
		
		// Копируем виды бюджетов
		СкопироватьВидыБюджета(МодельБюджетирования,ВыбранныеВидыБюджетов,СоответствиеСсылок);
		
		//++ НЕ УТКА

		// Удаляем текущие и копируем этапы подготовки бюджетов из модели-источника копирования.
		Если Не ВыбранныеЭтапыПодготовкиБюджетов = Неопределено Тогда
			СкопироватьЭтапыБюджета(МодельБюджетирования,ВыбранныеЭтапыПодготовкиБюджетов,СоответствиеСсылок);
		КонецЕсли;
		//-- НЕ УТКА
		
		Если КопироватьЛимиты Тогда
			МэппингГрупп = Новый Соответствие;
			
			Запрос = Новый Запрос;
			Запрос.Текст = "ВЫБРАТЬ
			|	ПравилаЛимитовПоДаннымБюджетирования.Ссылка,
			|	ПравилаЛимитовПоДаннымБюджетирования.ЭтоГруппа КАК ЭтоГруппа,
			|	ПравилаЛимитовПоДаннымБюджетирования.Родитель
			|ИЗ
			|	Справочник.ПравилаЛимитовПоДаннымБюджетирования КАК ПравилаЛимитовПоДаннымБюджетирования
			|ГДЕ
			|	ПравилаЛимитовПоДаннымБюджетирования.Владелец = &Владелец
			|
			|УПОРЯДОЧИТЬ ПО
			|	ЭтоГруппа ИЕРАРХИЯ";
			
			Запрос.УстановитьПараметр("Владелец", МодельКопирования);
			Выборка = Запрос.Выполнить().Выбрать();
			
			Пока Выборка.Следующий() Цикл
				КопияЛимита = Выборка.Ссылка.Скопировать(); // СправочникОбъект.ПравилаЛимитовПоДаннымБюджетирования -
				КопияЛимита.Владелец = МодельБюджетирования;
				Если Не Выборка.Родитель.Пустая() Тогда
					КопияЛимита.Родитель = МэппингГрупп[Выборка.Родитель];
				КонецЕсли;
				КопияЛимита.Записать();
				
				Если Выборка.ЭтоГруппа Тогда
					МэппингГрупп.Вставить(Выборка.Ссылка, КопияЛимита.Ссылка);
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		ОтменитьТранзакцию();
		
		ТекстОшибки = ПодробноеПредставлениеОшибки(ОписаниеОшибки());
		СобытиеЖР = НСтр("ru = 'Копирование модели бюджетирования';
						|en = 'Copy budgeting model'", КодЯзыка);
		ЗаписьЖурналаРегистрации(СобытиеЖР,
				УровеньЖурналаРегистрации.Ошибка,
				Метаданные.Справочники.МоделиБюджетирования,,
				ТекстОшибки);
		ВызватьИсключение;
	КонецПопытки;

	
КонецПроцедуры


// Возвращает дерево элементов финансовых отчетов.
// 
// Параметры:
// 	ВыбранныеВидыБюджетов - Массив из СправочникСсылка.ВидыБюджетов - 
// Возвращаемое значение:
// 	ДеревоЗначений - :
// 	 *Ссылка - СправочникСсылка.ЭлементыФинансовыхОтчетов - 
// 	 *Владелец - СправочникСсылка.ВидыБюджетов - 
//
&НаСервереБезКонтекста
Функция ДеревоЭлементовФинансовыхОтчетов(ВыбранныеВидыБюджетов)
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
		|	ЭлементыФинансовыхОтчетов.Ссылка КАК Ссылка,
		|	ЭлементыФинансовыхОтчетов.Владелец КАК Владелец
		|ИЗ
		|	Справочник.ЭлементыФинансовыхОтчетов КАК ЭлементыФинансовыхОтчетов
		|ГДЕ
		|	ЭлементыФинансовыхОтчетов.Владелец В(&Владелец)
		|ИТОГИ ПО
		|	Владелец,
		|	Ссылка ИЕРАРХИЯ";
	
	Запрос.УстановитьПараметр("Владелец",ВыбранныеВидыБюджетов);
	
	Дерево = Запрос.Выполнить().Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);
	
	Возврат Дерево;
КонецФункции

&НаСервереБезКонтекста
Процедура СкопироватьВидыБюджета(МодельБюджетирования,ВыбранныеВидыБюджетов,СоответствиеСсылок=Неопределено)
	
	Если СоответствиеСсылок = Неопределено Тогда
		СоответствиеСсылок = Новый Соответствие();
	КонецЕсли;
	ЭлементыСБитымиСсылками = Новый Массив();
	
	Для Каждого Стр Из ВыбранныеВидыБюджетов Цикл
		
		Если Не СоответствиеСсылок.Получить(Стр) = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		Копия = Стр.Скопировать(); // СправочникОбъект.ВидыБюджетов - 
		Копия.Владелец = МодельБюджетирования;
		Если ЗначениеЗаполнено(Копия.Родитель) Тогда
			Копия.Родитель = СоответствиеСсылок.Получить(Копия.Родитель);
		КонецЕсли;
		Копия.Записать();
		СоответствиеСсылок.Вставить(Стр,Копия.Ссылка);
		
	КонецЦикла;
	
	ЭлементыФО = ДеревоЭлементовФинансовыхОтчетов(ВыбранныеВидыБюджетов);
	
	Для Каждого ВидБюджета Из ЭлементыФО.Строки Цикл
		Владелец = СоответствиеСсылок.Получить(ВидБюджета.Владелец);
		Для Каждого ЭлементФО Из ВидБюджета.Строки Цикл
			КопияЭлементФО = ЭлементФО.Ссылка.Скопировать(); // СправочникОбъект.ЭлементыФинансовыхОтчетов - 
			КопияЭлементФО.Владелец = Владелец;
			КопияЭлементФО.Записать();
			СоответствиеСсылок.Вставить(ЭлементФО.Ссылка,КопияЭлементФО.Ссылка);
			СкопироватьЭлементФО(ЭлементФО,Владелец,КопияЭлементФО.Ссылка, СоответствиеСсылок,ЭлементыСБитымиСсылками);	
		КонецЦикла;
		
	КонецЦикла;
	
	Для Каждого ЭлементФО Из ЭлементыСБитымиСсылками Цикл
		ЭлементФО = ЭлементФО.ПолучитьОбъект(); // СправочникОбъект.ЭлементыФинансовыхОтчетов - 
		ОбработатьТЧЭлементаФО(ЭлементФО,СоответствиеСсылок);
		ЭлементФО.Записать();
	КонецЦикла;
	
КонецПроцедуры

//++ НЕ УТКА

&НаСервереБезКонтекста
Процедура СкопироватьЭтапыБюджета(МодельБюджетирования,ВыбранныеЭтапыПодготовкиБюджетов,СоответствиеСсылок, СоответствиеСсылокЭтапов=Неопределено)
	
	Если СоответствиеСсылокЭтапов = Неопределено Тогда
		СоответствиеСсылокЭтапов = Новый Соответствие();
	КонецЕсли;
	
	Для Каждого Стр Из ВыбранныеЭтапыПодготовкиБюджетов Цикл
		
		Если Не СоответствиеСсылокЭтапов.Получить(Стр) = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		Копия = Стр.Скопировать(); // СправочникОбъект.ЭтапыПодготовкиБюджетов - 
		Копия.Владелец = МодельБюджетирования;
		Если ЗначениеЗаполнено(Копия.Родитель) Тогда
			Копия.Родитель = СоответствиеСсылокЭтапов.Получить(Копия.Родитель);
		КонецЕсли;
		ОбработатьНастройкиДействияЭтапа(МодельБюджетирования,Копия,СоответствиеСсылок,СоответствиеСсылокЭтапов);
		Копия.Записать();
		СоответствиеСсылокЭтапов.Вставить(Стр,Копия.Ссылка);
		
	КонецЦикла;
		
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДеревоЭтапыПодготовкиБюджетов()
	
	//++ Локализация
	Компоновка = Обработки.ПомощникВыгрузкиЗагрузкиМоделиБюджетирования.ПолучитьМакет("ЭтапыПодготовкиБюджетов");
	
	КомпоновщикНастроек = Новый КомпоновщикНастроекКомпоновкиДанных;
	КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(Компоновка));
	КомпоновщикНастроек.ЗагрузитьНастройки(Компоновка.НастройкиПоУмолчанию);
	
	ФинансоваяОтчетностьСервер.УстановитьПараметрКомпоновки(КомпоновщикНастроек.Настройки, "ВыбранныеЭтапыБюджетов", Новый Массив());
	ФинансоваяОтчетностьСервер.УстановитьПараметрКомпоновки(КомпоновщикНастроек.Настройки, "Владелец", МодельКопирования);
				
	РезультатДерево = ФинансоваяОтчетностьСервер.ВыгрузитьРезультатСКД(Компоновка,КомпоновщикНастроек.Настройки,, Истина);
	
	ЗначениеВРеквизитФормы(РезультатДерево, "ЭтапыПодготовкиБюджетов");
	Если ЭтапыПодготовкиБюджетов.ПолучитьЭлементы().Количество() > 0 Тогда
		Элементы.СтраницаЭтапыПодготовкиБюджетов.Видимость = Истина;
	КонецЕсли;
	//-- Локализация
	Возврат; // в международной поставке не используется
	
КонецПроцедуры

//-- НЕ УТКА


// Описание
// 
// Параметры:
// 	СтрокаДерева - См. СкопироватьЭлементФО.ЭлементФО
// Возвращаемое значение:
// 	КоллекцияСтрокДереваЗначений из См. СкопироватьЭлементФО.ЭлементФО
//
&НаСервереБезКонтекста
Функция КоллекцияСтрокДереваФинансовыхОтчетов(СтрокаДерева)
	Возврат СтрокаДерева.Строки;
КонецФункции

// Копирует рекурсивно элементы финансовых отчетов.
// 
// Параметры:
// 	ЭлементФО - СтрокаДереваЗначений - строка дерева с колонками:
// 	 *Ссылка - СправочникСсылка.ЭлементыФинансовыхОтчетов -
// 	 *Владелец - СправочникСсылка.ВидыБюджетов -
// 	Владелец - СправочникСсылка.ВидыБюджетов - новый вид бюджета, владелец создаваемых элементов отчета.
// 	Родитель - СправочникСсылка.ЭлементыФинансовыхОтчетов - 
// 	СоответствиеСсылок - Соответствие, Неопределено - соответствие, где:
// 	 *Ключ - СправочникСсылка.ЭлементыФинансовыхОтчетов -
// 	 *Значение - СправочникСсылка.ВидыБюджетов -
// 	ЭлементыСБитымиСсылками - Массив из СправочникСсылка.ЭлементыФинансовыхОтчетов -
&НаСервереБезКонтекста
Процедура СкопироватьЭлементФО(ЭлементФО, Владелец, Родитель, СоответствиеСсылок, ЭлементыСБитымиСсылками)
	
	КоллекцияСтрок = КоллекцияСтрокДереваФинансовыхОтчетов(ЭлементФО);
	Для Каждого ПодчиненныйЭлементФО Из КоллекцияСтрок Цикл
		Если ПодчиненныйЭлементФО.Ссылка = ЭлементФО.Ссылка Тогда
			Продолжить;
		КонецЕсли;
		
		КопияЭлементФО = ПодчиненныйЭлементФО.Ссылка.Скопировать(); // СправочникОбъект.ЭлементыФинансовыхОтчетов -
		КопияЭлементФО.Владелец = Владелец;
		КопияЭлементФО.Родитель = Родитель;
		Ошибки = ОбработатьТЧЭлементаФО(КопияЭлементФО,СоответствиеСсылок);
		КопияЭлементФО.ОбменДанными.Загрузка = Истина;
		КопияЭлементФО.Записать();
		Если Ошибки Тогда 
			ЭлементыСБитымиСсылками.Добавить(КопияЭлементФО.Ссылка);
		КонецЕсли;

		СоответствиеСсылок.Вставить(ПодчиненныйЭлементФО.Ссылка,КопияЭлементФО.Ссылка); 
		СкопироватьЭлементФО(ПодчиненныйЭлементФО,Владелец,КопияЭлементФО.Ссылка, СоответствиеСсылок, ЭлементыСБитымиСсылками);	
	КонецЦикла;
		
КонецПроцедуры

&НаСервереБезКонтекста
Функция ОбработатьТЧЭлементаФО(ЭлементФО,СоответствиеСсылок)
	
	Ошибки = Ложь;
		
	// Обход всех тч
	ТабЧастиМетаданные = Метаданные.Справочники.ЭлементыФинансовыхОтчетов.ТабличныеЧасти;
	ТипДляОбработки = Тип("СправочникСсылка.ЭлементыФинансовыхОтчетов");
	Для Каждого ТЧ Из ТабЧастиМетаданные Цикл
		КолонкиДляОбработки = Новый Массив();
		Для Каждого Колонка Из ТЧ.Реквизиты Цикл
			Если Не Колонка.Тип.Типы().Найти(ТипДляОбработки) = Неопределено Тогда
				КолонкиДляОбработки.Добавить(Колонка.Имя);	
			КонецЕсли;
		КонецЦикла;
		ТабЧасть = ЭлементФО[ТЧ.Имя];
		
		Для Каждого Стр Из ТабЧасть Цикл
			Для Каждого КолонкаИмя Из КолонкиДляОбработки Цикл
				Если Не ТипЗнч(Стр[КолонкаИмя]) = ТипДляОбработки Тогда
					Продолжить;
				КонецЕсли;
				Замена = СоответствиеСсылок.Получить(Стр[КолонкаИмя]);
				Если Не Замена = Неопределено Тогда
					Стр[КолонкаИмя] = Замена;
				Иначе
					Ошибки = Истина;
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
		
	КонецЦикла;

	Если ЗначениеЗаполнено(ЭлементФО.СвязанныйЭлемент) Тогда
		Замена = СоответствиеСсылок.Получить(ЭлементФО.СвязанныйЭлемент);
		Если Не Замена = Неопределено Тогда
			ЭлементФО.СвязанныйЭлемент = СоответствиеСсылок.Получить(ЭлементФО.СвязанныйЭлемент);
		Иначе
			Ошибки = Истина;
		КонецЕсли;
	КонецЕсли;

	Возврат Ошибки;
	
КонецФункции

//++ НЕ УТКА
&НаСервереБезКонтекста
Процедура ОбработатьНастройкиДействияЭтапа(МодельБюджетирования,Этап,СоответствиеСсылок,СоответствиеСсылокЭтапов)
	
	Если Этап.Действие = Перечисления.ТипыДействийЭтаповПодготовкиБюджетов.ВводБюджетов Тогда
		
		НастройкаДействия = Этап.НастройкаДействия.Получить();
		Если ТипЗнч(НастройкаДействия) <> Тип("ТаблицаЗначений") Тогда
			Возврат;
		КонецЕсли;
		
		ПараметрыПоиска = Новый Структура;
		ПараметрыПоиска.Вставить("Имя","ВидыБюджетов");
		Строки = НастройкаДействия.НайтиСтроки(ПараметрыПоиска);
		Если Строки.Количество() = 0 Тогда 
			Возврат;
		КонецЕсли;
		
		тзВидыБюджетов = Строки[0].Значение;
		
		ВидыБюджетовДляКопирования = Новый Массив();
		Для Каждого Стр Из тзВидыБюджетов Цикл
			Замена = СоответствиеСсылок.Получить(Стр.ВидБюджета);
			Если ЗначениеЗаполнено(Замена) Тогда
				Стр.ВидБюджета = Замена;
			Иначе
				Если ВидыБюджетовДляКопирования.Найти(Стр.ВидБюджета) = Неопределено Тогда
					ВидыБюджетовДляКопирования.Добавить(Стр.ВидБюджета);
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
		
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ
		               |	ВидыБюджетов.Ссылка КАК Ссылка,
		               |	ИСТИНА КАК Флаг
		               |ИЗ
		               |	Справочник.ВидыБюджетов КАК ВидыБюджетов
		               |ГДЕ
		               |	ВидыБюджетов.Ссылка В(&ВидыБюджетовДляКопирования)
		               |ИТОГИ
		               |	МАКСИМУМ(Флаг)
		               |ПО
		               |	Ссылка ИЕРАРХИЯ";
					   
		Запрос.УстановитьПараметр("ВидыБюджетовДляКопирования",ВидыБюджетовДляКопирования);
		
		ВидыБюджетовДерево = Запрос.Выполнить().Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);
		
		ВидыБюджетовДляКопирования = ПолучитьВыбранныеЭлементыОтбора(ВидыБюджетовДерево,"Ссылка");
				
		СкопироватьВидыБюджета(МодельБюджетирования,ВидыБюджетовДляКопирования,СоответствиеСсылок);
		
		Для Каждого Стр Из тзВидыБюджетов Цикл
			Замена = СоответствиеСсылок.Получить(Стр.ВидБюджета);
			Если ЗначениеЗаполнено(Замена) Тогда
				Стр.ВидБюджета = Замена;
			КонецЕсли;
		КонецЦикла;
			
		Этап.НастройкаДействия = Новый ХранилищеЗначения(НастройкаДействия);
		
	ИначеЕсли Этап.Действие = Перечисления.ТипыДействийЭтаповПодготовкиБюджетов.УтверждениеБюджетов Тогда
		
		НастройкаДействия = Этап.НастройкаДействия.Получить();
		Если ТипЗнч(НастройкаДействия) <> Тип("ТаблицаЗначений") Тогда
			Возврат;
		КонецЕсли;

		ПараметрыПоиска = Новый Структура;
		ПараметрыПоиска.Вставить("Имя","УтверждаемыеЭтапыПодготовкиБюджетов");
		Строки = НастройкаДействия.НайтиСтроки(ПараметрыПоиска);
		Если Строки.Количество() = 0 Тогда 
			Возврат;
		КонецЕсли;
		
		УтверждаемыеЭтапы = Строки[0].Значение;
		ЭтапыДляКопирования = Новый Массив();
		
		Для Каждого Стр Из УтверждаемыеЭтапы Цикл
			Замена = СоответствиеСсылокЭтапов.Получить(Стр.Значение);
			Если ЗначениеЗаполнено(Замена) Тогда
				Стр.Значение = Замена;
			Иначе
				Если ЭтапыДляКопирования.Найти(Стр.Значение) = Неопределено Тогда
					ЭтапыДляКопирования.Добавить(Стр.Значение);
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;	
		
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ
		               |	ЭтапыПодготовкиБюджетов.Ссылка КАК Ссылка,
		               |	ИСТИНА КАК Флаг
		               |ИЗ
		               |	Справочник.ЭтапыПодготовкиБюджетов КАК ЭтапыПодготовкиБюджетов
		               |ГДЕ
		               |	ЭтапыПодготовкиБюджетов.Ссылка В(&ЭтапыДляКопирования)
		               |ИТОГИ
		               |	МАКСИМУМ(Флаг)
		               |ПО
		               |	Ссылка ИЕРАРХИЯ";
					   
		Запрос.УстановитьПараметр("ЭтапыДляКопирования",ЭтапыДляКопирования);
		
		ЭтапыДерево = Запрос.Выполнить().Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);
		
		ЭтапыДляКопирования = ПолучитьВыбранныеЭлементыОтбора(ЭтапыДерево,"Ссылка");
		
		СкопироватьЭтапыБюджета(МодельБюджетирования,ЭтапыДляКопирования,СоответствиеСсылок, СоответствиеСсылокЭтапов);
		
		Для Каждого Стр Из УтверждаемыеЭтапы Цикл
			Замена = СоответствиеСсылокЭтапов.Получить(Стр.Значение);
			Если ЗначениеЗаполнено(Замена) Тогда
				Стр.Значение = Замена;
			КонецЕсли;
		КонецЦикла;	

		Этап.НастройкаДействия = Новый ХранилищеЗначения(НастройкаДействия);
		
	КонецЕсли;
	
КонецПроцедуры
//-- НЕ УТКА

// Устанавливает состояние пометки у родительских строк строки дерева значений
// в зависимости от пометки текущей строки.
//
// Параметры:
//  ТекСтрока      - СтрокаДереваЗначений.
// 
&НаКлиенте
Процедура УстановитьПометкиРодителей(ТекСтрока, ИмяФлажка)
	
	Родитель = ТекСтрока.ПолучитьРодителя();
	Если Родитель = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	
	ТекСостояние = Родитель[ИмяФлажка];
	
	НайденыВключенные  = Ложь;
	НайденыВыключенные = Ложь;
	
	Для Каждого Строка Из Родитель.ПолучитьЭлементы() Цикл
		Если Строка[ИмяФлажка] = 0 Тогда
			НайденыВыключенные = Истина;
		ИначеЕсли Строка[ИмяФлажка] = 1
			ИЛИ Строка[ИмяФлажка] = 2 Тогда
			НайденыВключенные  = Истина;
		КонецЕсли; 
		Если НайденыВключенные И НайденыВыключенные Тогда
			Прервать;
		КонецЕсли; 
	КонецЦикла;
	
	Если НайденыВключенные И НайденыВыключенные Тогда
		Включить = 2;
	ИначеЕсли НайденыВключенные И (Не НайденыВыключенные) Тогда
		Включить = 1;
	ИначеЕсли (Не НайденыВключенные) И НайденыВыключенные Тогда
		Включить = 0;
	ИначеЕсли (Не НайденыВключенные) И (Не НайденыВыключенные) Тогда
		Включить = 2;
	КонецЕсли;
	
	Если Включить = ТекСостояние Тогда
		Возврат;
	Иначе
		Родитель[ИмяФлажка] = Включить;
		УстановитьПометкиРодителей(Родитель, ИмяФлажка);
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ПолучитьВыбранныеЭлементыОтбора(ДеревоОтбора,ИмяКолонки)
	
	ВыбранныеЗначения = Новый Массив;
	Если ТипЗнч(ДеревоОтбора) = Тип("ДанныеФормыДерево") ИЛИ ТипЗнч(ДеревоОтбора) = Тип("ДанныеФормыЭлементДерева") Тогда
		ЭлементыДерева = ДеревоОтбора.ПолучитьЭлементы();
	Иначе
		ЭлементыДерева = ДеревоОтбора.Строки;	
	КонецЕсли;
	Для Каждого ЭлементыДерева Из ЭлементыДерева Цикл
		Если ЭлементыДерева.Флаг Тогда
			ВыбранныеЗначения.Добавить(ЭлементыДерева[ИмяКолонки]);
			ПодчиненныеЗначения = ПолучитьВыбранныеЭлементыОтбора(ЭлементыДерева,ИмяКолонки);
			Для Каждого Значение Из ПодчиненныеЗначения Цикл
				ВыбранныеЗначения.Добавить(Значение);
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
	
	Возврат ВыбранныеЗначения;
	
КонецФункции

#КонецОбласти
