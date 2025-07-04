#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	ЗарплатаКадрыОтчеты.ПриКомпоновкеРезультатаВТабличныйДокумент(ЭтотОбъект, ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка, Истина);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ИнициализироватьОтчет() Экспорт
	
	ЗарплатаКадрыОбщиеНаборыДанных.ВывестиВНаборДанныхДополнительныеПоляПредставлений(
		СхемаКомпоновкиДанных.НаборыДанных.Найти("НаборДанныхСотрудники"), ДополнительныеПоляПредставлений());
	
КонецПроцедуры


// Для общей формы "Форма отчета" подсистемы "Варианты отчетов".
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	
	Настройки.События.ПередЗагрузкойНастроекВКомпоновщик = Истина;
	
КонецПроцедуры

// Вызывается перед загрузкой новых настроек. Используется для изменения схемы компоновки.
//
Процедура ПередЗагрузкойНастроекВКомпоновщик(Контекст, КлючСхемы, КлючВарианта, НовыеНастройкиКД, НовыеПользовательскиеНастройкиКД) Экспорт
	
	Если НовыеНастройкиКД <> Неопределено  Тогда
		
		ОрганизацияПараметр = ЗначениеПараметра(НовыеПользовательскиеНастройкиКД, "Организация");
		ДатаАктуальностиПараметр = ЗначениеПараметра(НовыеПользовательскиеНастройкиКД, "ДатаАктуальности");
		Если ЗначениеЗаполнено(ДатаАктуальностиПараметр) И ТипЗнч(ДатаАктуальностиПараметр) <> Тип("Дата") Тогда
			ДатаАктуальностиПараметр = ДатаАктуальностиПараметр.Дата;
		КонецЕсли;
		
		ИспользоватьОбособленныеТерритории = Ложь;
		Если ЗначениеЗаполнено(ОрганизацияПараметр) Тогда
			ИспользоватьОбособленныеТерритории = ПолучитьФункциональнуюОпцию("ИспользоватьОбособленныеТерритории", Новый Структура("Организация", ОрганизацияПараметр));
		КонецЕсли;
		
		ПрименяетсяЕНВД = Ложь;
		Если ЗначениеЗаполнено(ОрганизацияПараметр) И ЗначениеЗаполнено(ДатаАктуальностиПараметр) Тогда
			ПрименяетсяЕНВД = ОтражениеЗарплатыВБухучете.ПлательщикЕНВД(ОрганизацияПараметр, ДатаАктуальностиПараметр);
		Иначе
			ПрименяетсяЕНВД = ПолучитьФункциональнуюОпцию("ИспользуетсяЕНВД");
		КонецЕсли;
		
		ИспользоватьСтатьиФинансирования = ПолучитьФункциональнуюОпцию("ИспользоватьСтатьиФинансированияЗарплатаРасширенный");
		
		ТаблицаНастройкиОрганизации = НастройкаПоИмени(НовыеНастройкиКД.Структура, "НастройкиОрганизации");
		Если ТаблицаНастройкиОрганизации <> Неопределено Тогда
			
			ИзменитьИспользованиеГруппировки(ТаблицаНастройкиОрганизации.Строки, "ОтношениеКЕНВД", ПрименяетсяЕНВД);
			Если Не ИспользоватьСтатьиФинансирования Тогда
				ИзменитьИспользованиеГруппировки(ТаблицаНастройкиОрганизации.Строки, "СтатьяФинансирования", Неопределено);
			КонецЕсли;
			
		КонецЕсли;
		
		ТаблицаНастройкиПодразделений = НастройкаПоИмени(НовыеНастройкиКД.Структура, "НастройкиПодразделений");
		Если ТаблицаНастройкиПодразделений <> Неопределено Тогда
			
			ИзменитьИспользованиеГруппировки(ТаблицаНастройкиПодразделений.Строки, "ОтношениеКЕНВД", ПрименяетсяЕНВД);
			Если Не ИспользоватьСтатьиФинансирования Тогда
				ИзменитьИспользованиеГруппировки(ТаблицаНастройкиПодразделений.Строки, "СтатьяФинансирования", Неопределено);
			КонецЕсли;
			
			ПоказыватьНастройкиПодразделений = ЗначениеПараметра(НовыеПользовательскиеНастройкиКД, "ПоказыватьНастройкиПодразделений");
			Если ПоказыватьНастройкиПодразделений <> Неопределено Тогда
				ТаблицаНастройкиПодразделений.Использование = ПоказыватьНастройкиПодразделений;	
			КонецЕсли;
			
		КонецЕсли;
		
		ТаблицаНастройкиСотрудников = НастройкаПоИмени(НовыеНастройкиКД.Структура, "НастройкиСотрудников");
		Если ТаблицаНастройкиСотрудников <> Неопределено Тогда
			
			ИзменитьИспользованиеГруппировки(ТаблицаНастройкиСотрудников.Строки, "ОтношениеКЕНВД", ПрименяетсяЕНВД);
			Если Не ИспользоватьСтатьиФинансирования Тогда
				ИзменитьИспользованиеГруппировки(ТаблицаНастройкиСотрудников.Строки, "СтатьяФинансирования", Неопределено);
			КонецЕсли;
			
			ПоказыватьНастройкиСотрудников = ЗначениеПараметра(НовыеПользовательскиеНастройкиКД, "ПоказыватьНастройкиСотрудников");
			Если ПоказыватьНастройкиСотрудников <> Неопределено  Тогда
				ТаблицаНастройкиСотрудников.Использование = ПоказыватьНастройкиСотрудников;
			КонецЕсли;
			
		КонецЕсли;
		
		ТаблицаНастройкиТерриторий = НастройкаПоИмени(НовыеНастройкиКД.Структура, "НастройкиТерриторий");
		ПараметрПоказыватьНастройкиТерритории = НовыеНастройкиКД.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ПоказыватьНастройкиТерритории"));
		ПоказыватьНастройкиТерритории = ЗначениеПараметра(НовыеПользовательскиеНастройкиКД, "ПоказыватьНастройкиТерритории");
		
		Если ПараметрПоказыватьНастройкиТерритории <> Неопределено Тогда
			Если ИспользоватьОбособленныеТерритории Тогда
				РежимОтображенияНастройки = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Обычный;
			Иначе
				РежимОтображенияНастройки = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
			КонецЕсли;
			ПараметрПоказыватьНастройкиТерритории.РежимОтображения = РежимОтображенияНастройки;
		КонецЕсли;
		
		Если ТаблицаНастройкиТерриторий <> Неопределено Тогда
			
			ИзменитьИспользованиеГруппировки(ТаблицаНастройкиТерриторий.Строки, "ОтношениеКЕНВД", ПрименяетсяЕНВД);
			Если Не ИспользоватьСтатьиФинансирования Тогда
				ИзменитьИспользованиеГруппировки(ТаблицаНастройкиТерриторий.Строки, "СтатьяФинансирования", Неопределено);
			КонецЕсли;
			
			ПоказыватьНастройкиТерритории = ИспользоватьОбособленныеТерритории
					И ?(ПоказыватьНастройкиТерритории <> Неопределено, ПоказыватьНастройкиТерритории, Истина);
					
			ТаблицаНастройкиТерриторий.Использование = ПоказыватьНастройкиТерритории;
			
		КонецЕсли;
		
		Если КлючСхемы <> КлючВарианта Тогда
			ИнициализироватьОтчет();
		КонецЕсли;
		
		ОтчетыСервер.ПодключитьСхему(ЭтотОбъект, Контекст, СхемаКомпоновкиДанных, КлючСхемы);
		КлючСхемы = КлючВарианта;
		
	КонецЕсли;
	
КонецПроцедуры

Функция ЗначениеПараметра(ПользовательскиеНастройкиКД, ИмяПараметра)

	Параметр = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных(ИмяПараметра));
	Если Параметр <> Неопределено Тогда
		ЗначениеПараметра = ПользовательскиеНастройкиКД.Элементы.Найти(Параметр.ИдентификаторПользовательскойНастройки);
		Если ЗначениеПараметра <> Неопределено И ЗначениеПараметра.Использование Тогда
			Возврат ЗначениеПараметра.Значение;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

Функция НастройкаПоИмени(Структура, Имя)
	
	Группировка = Неопределено;
	
	Для каждого Элемент Из Структура Цикл
		Если ТипЗнч(Элемент) = Тип("ТаблицаКомпоновкиДанных") Тогда
			Если Элемент.Имя = Имя Тогда
				Возврат Элемент;
			КонецЕсли;	
		Иначе
			Если Элемент.Имя = Имя Тогда
				Возврат Элемент;
			КонецЕсли;	
			Для каждого Поле Из Элемент.ПоляГруппировки.Элементы Цикл
				Если Не ТипЗнч(Поле) = Тип("АвтоПолеГруппировкиКомпоновкиДанных") Тогда
					Если Поле.Поле = Новый ПолеКомпоновкиДанных(Имя) Тогда
						Возврат Поле;
					КонецЕсли;
				КонецЕсли;
			КонецЦикла;
			Если Элемент.Структура.Количество() = 0 Тогда
				Продолжить;
			Иначе
				Группировка = НастройкаПоИмени(Элемент.Структура, Имя);
				Если Не Группировка = Неопределено Тогда
					Возврат Группировка;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Группировка;
	
КонецФункции

Процедура ИзменитьИспользованиеГруппировки(КоллекцияЭлементовСтруктуры, Имя, ЗначениеИспользования)
	
	Для каждого ЭлементКоллекции Из КоллекцияЭлементовСтруктуры Цикл
		Для каждого Элемент Из ЭлементКоллекции.ПоляГруппировки.Элементы Цикл
			Если Не ТипЗнч(Элемент) = Тип("АвтоПолеГруппировкиКомпоновкиДанных") Тогда
				Если Элемент.Поле = Новый ПолеКомпоновкиДанных(Имя) Тогда
					Если ЗначениеИспользования = Неопределено Тогда
						ЭлементКоллекции.ПоляГруппировки.Элементы.Удалить(Элемент);
					Иначе
						Элемент.Использование = ЗначениеИспользования;
					КонецЕсли;
					Возврат;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры

Функция ДополнительныеПоляПредставлений() Экспорт
	
	ДополнительныеПоляПредставлений = ЗарплатаКадрыОбщиеНаборыДанных.ПустаяТаблицаДополнительныхПолейПредставлений();
	
	ДополнительныеПоля = Новый Структура;
	ДополнительныеПоля.Вставить("Представления_СотрудникиОрганизации", ДополнительныеПоляПредставлений);
	
	Возврат ДополнительныеПоля;
	
КонецФункции

#КонецОбласти


#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.';
						|en = 'Invalid object call on the client.'");
#КонецЕсли