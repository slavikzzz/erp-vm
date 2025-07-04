
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаголовокФормы = "";
	
	Параметры.Свойство("ЗаголовокФормы",             ЗаголовокФормы);
	Параметры.Свойство("Организация",                Организация);
	Параметры.Свойство("ТорговоеПредложение",        ТорговоеПредложение);
	Параметры.Свойство("ЭтоПокупатель",              ЭтоПокупатель);
	Параметры.Свойство("ТолькоРегионы",              ТолькоРегионы);
	Параметры.Свойство("КлючХраненияНастроек",       КлючХраненияНастроек);

	Если ЗначениеЗаполнено(ЗаголовокФормы) Тогда
		Заголовок = ЗаголовокФормы;
	КонецЕсли;
	
	ВидКонтактнойИнформации = ВидКонтактнойИнформацииАдреса();
	
	ИспользоватьХранилищеНастроек = Не ЗначениеЗаполнено(ТорговоеПредложение);
	
	ПеречитатьДанныеФормы();
	
	НастроитьЭлементыФормыПриСоздании();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	БизнесСетьКлиент.ПередЗакрытиемФормы(
		ЭтотОбъект, ПрограммноеЗакрытие, Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВозможенСамовывозПриИзменении(Элемент)
	
	Элементы.АдресаПродажи.Доступность = ИспользоватьАдреса;
	
КонецПроцедуры

&НаКлиенте
Процедура ВозможнаДоставкаПриИзменении(Элемент)
	
	Элементы.РегионыПродажи.Доступность = ИспользоватьРегионы;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыРегионыПродажи

&НаКлиенте
Процедура РегионыПродажиНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.РегионыПродажи.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЗаголовокВвода = НСтр("ru = 'Введите регион абонента';
							|en = 'Enter subscriber region'");
	ОткрытьФормуКонтактнойИнформации(ТекущиеДанные, ЗаголовокВвода);
	
КонецПроцедуры

&НаКлиенте
Процедура РегионыПродажиПриИзменении(Элемент)
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура РегионыПродажиПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	ЗаголовокВвода = НСтр("ru = 'Введите регион абонента';
							|en = 'Enter subscriber region'");
	ДополнительныеПараметры = Новый Структура("Представление, ЗначенияПолей");
	ДополнительныеПараметры.Вставить("НоваяСтрока", Истина);
	ДополнительныеПараметры.Вставить("ИмяСписка", "РегионыПродажи");
	ОткрытьФормуКонтактнойИнформации(ДополнительныеПараметры, ЗаголовокВвода);
	
КонецПроцедуры

&НаКлиенте
Процедура РегионыПродажиПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	ЗаголовокВвода = НСтр("ru = 'Регион абонента';
							|en = 'Subscriber region'");
	ОткрытьФормуКонтактнойИнформации(Элементы.РегионыПродажи.ТекущиеДанные, ЗаголовокВвода);
	
КонецПроцедуры

&НаКлиенте
Процедура РегионыПродажиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ЗаголовокВвода = НСтр("ru = 'Регион абонента';
							|en = 'Subscriber region'");
	ОткрытьФормуКонтактнойИнформации(Элементы.РегионыПродажи.ТекущиеДанные, ЗаголовокВвода);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыАдресаПродажи

&НаКлиенте
Процедура АдресаПродажиПредставлениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.АдресаПродажи.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЗаголовокВвода = НСтр("ru = 'Введите адрес склада самовывоза';
							|en = 'Enter the pickup warehouse address'");
	ОткрытьФормуКонтактнойИнформации(ТекущиеДанные, ЗаголовокВвода);

КонецПроцедуры

&НаКлиенте
Процедура АдресаПродажиПриИзменении(Элемент)
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура АдресаПродажиПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	ЗаголовокВвода = НСтр("ru = 'Введите адрес склада самовывоза';
							|en = 'Enter the pickup warehouse address'");
	ДополнительныеПараметры = Новый Структура("Представление, ЗначенияПолей, НоваяСтрока");
	ДополнительныеПараметры.Вставить("ИмяСписка", "АдресаПродажи");
	ОткрытьФормуКонтактнойИнформации(ДополнительныеПараметры, ЗаголовокВвода);
	
КонецПроцедуры

&НаКлиенте
Процедура АдресаПродажиПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	ЗаголовокВвода = НСтр("ru = 'Адрес склада самовывоза';
							|en = 'Pickup warehouse address'");
	ОткрытьФормуКонтактнойИнформации(Элементы.АдресаПродажи.ТекущиеДанные, ЗаголовокВвода);
	
КонецПроцедуры

&НаКлиенте
Процедура АдресаПродажиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ЗаголовокВвода = НСтр("ru = 'Адрес склада самовывоза';
							|en = 'Pickup warehouse address'");
	ОткрытьФормуКонтактнойИнформации(Элементы.АдресаПродажи.ТекущиеДанные, ЗаголовокВвода);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаполнитьРегионыПродажи(Команда)
	
	ОткрытьПодборРегионов("РегионыПродажи");
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьАдресаПродажи(Команда)
	
	ОткрытьПодборРегионов("АдресаПродажи");

КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьЗакрыть(Команда)
	
	ЗаписатьДанныеИЗакрыть(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура Записать(Команда)
	
	ЗаписатьДанныеИЗакрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура Перечитать(Команда)
	
	Оповещение = Новый ОписаниеОповещения("ПеречитатьПродолжение", ЭтотОбъект);
	ПоказатьВопрос(Оповещение, НСтр("ru = 'Данные изменены. Перечитать данные?';
									|en = 'Data is changed. Reread?'"), РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ВидКонтактнойИнформацииАдреса()
	
	ВидКонтактнойИнформации = УправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации(Перечисления.ТипыКонтактнойИнформации.Адрес);
	
	ВидКонтактнойИнформации.НастройкиПроверки.ВключатьСтрануВПредставление = Истина;
	
	Возврат ВидКонтактнойИнформации;
	
КонецФункции

&НаКлиенте
Процедура ЗаписатьДанныеИЗакрыть(ЗакрытьФорму = Ложь)
	
	Отказ = Ложь;
	
	ЗаписатьДанныеАдресовРегионов();
	
	Если Не Отказ Тогда
		ПоказатьОповещениеПользователя(НСтр("ru = 'Регионы и адреса 1С:Бизнес-сеть';
											|en = '1C:Business Network regions and addresses'"),,
			НСтр("ru = 'Регионы и адреса успешно сохранены в сервисе 1С:Бизнес-сеть';
				|en = 'Regions and addresses are successfully saved to 1С:Business Network service'"),
			БиблиотекаКартинок.БизнесСеть);
		ПрограммноеЗакрытие = Истина;
		Модифицированность = Ложь;
		Если ЗакрытьФорму Тогда
			Закрыть();
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаСервере
Функция АдресХранилищДанныхСписка(ИмяСписка)
	
	Возврат ПоместитьВоВременноеХранилище(ЭтотОбъект[ИмяСписка].Выгрузить());
	
КонецФункции

&НаКлиенте
Процедура ОткрытьФормуКонтактнойИнформации(ТекущиеДанные, ЗаголовокВвода)
	
	ЗначенияПолей = ЗначенияПолейАдреса(ТекущиеДанные.ЗначенияПолей, ТекущиеДанные.Представление);
	
	ПараметрыОткрытия = УправлениеКонтактнойИнформациейКлиент.ПараметрыФормыКонтактнойИнформации(
		ВидКонтактнойИнформации, ЗначенияПолей,
		ТекущиеДанные.Представление,, ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.Адрес"));
		
	ПараметрыОткрытия.Вставить("Заголовок", ЗаголовокВвода);
		
	Оповещение = Новый ОписаниеОповещения("ОткрытьФормуКонтактнойИнформацииЗавершение", ЭтотОбъект, ТекущиеДанные);
		
	ФормаКонтактнойИнформации = УправлениеКонтактнойИнформациейКлиент.ОткрытьФормуКонтактнойИнформации(ПараметрыОткрытия, ЭтотОбъект, Оповещение);
	
	Если Не ЗначениеЗаполнено(ЗначенияПолей) Тогда
		ФормаКонтактнойИнформации.Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗначенияПолейАдреса(ЗначенияПолей, Представление)
	
	Результат = "";
	
	Если ЭтоСтрана(Представление) Тогда
		
		ДанныеАдреса = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияПоПредставлению(
			Представление,
			Перечисления.ТипыКонтактнойИнформации.Адрес);
			
		ЗначенияПоПредставлению = РаботаСАдресами.СведенияОбАдресе(ДанныеАдреса);
		
		Если ЗначенияПоПредставлению.КодСтраны = "643" Тогда // для РФ необходимо указать тип
			ЗначенияПоПредставлению.ТипАдреса = "Муниципальный";
			Результат = РаботаСАдресами.ПоляАдресаВJSON(ЗначенияПоПредставлению);
		Иначе
			Результат = ДанныеАдреса;
		КонецЕсли;
		
	Иначе
		Результат = ЗначенияПолей;	
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура ОткрытьФормуКонтактнойИнформацииЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено И ДополнительныеПараметры <> Неопределено Тогда
		
		Если ДополнительныеПараметры.Свойство("НоваяСтрока") Тогда
			ТекущиеДанные = Элементы[ДополнительныеПараметры.ИмяСписка].ТекущиеДанные;
			Если ДополнительныеПараметры = Неопределено Тогда
				Возврат;
			КонецЕсли;
		Иначе
			ТекущиеДанные = ДополнительныеПараметры;
		КонецЕсли;
		
		Если ПустаяСтрока(Результат.Представление) И ПустаяСтрока(Результат.КонтактнаяИнформация) Тогда
			
			// Пустая страна, по умолчанию.
			ТекущиеДанные.Представление = ПредопределенноеЗначение("Справочник.СтраныМира.Россия");
			ТекущиеДанные.ЗначенияПолей = "";
			
		ИначеЕсли ЭтоСтрана(Результат.Представление) Тогда	
			ТекущиеДанные.Представление = Результат.Представление;
			ТекущиеДанные.ЗначенияПолей = "";
		Иначе
			
			Если СтрНайти("РегионыПродажи, РегионыЗакупки", ЭтотОбъект.ТекущийЭлемент.Имя) Тогда
				
				Если Результат.ВведеноВСвободнойФорме Тогда
					ПоказатьПредупреждение(, НСтр("ru = 'Ввод региона в свободной форме запрещен.';
													|en = 'Cannot enter region in free format.'"));
					Если ДополнительныеПараметры.Свойство("НоваяСтрока") Тогда
						УдалитьСтрокуСписка(ДополнительныеПараметры.ИмяСписка);
					КонецЕсли;
					Возврат;
				КонецЕсли;
				СжатьАдресКонтактнойИнформации(Результат.КонтактнаяИнформация, Результат.Представление);
			КонецЕсли;
			
			Модифицированность = Истина;
			ТекущиеДанные.Представление = Результат.Представление;
			ТекущиеДанные.ЗначенияПолей = Результат.КонтактнаяИнформация;
			
		КонецЕсли;
		
		
	ИначеЕсли ТипЗнч(ДополнительныеПараметры) = Тип("Структура")
		И ДополнительныеПараметры.Свойство("НоваяСтрока") Тогда
		
		УдалитьСтрокуСписка(ДополнительныеПараметры.ИмяСписка);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЭтоСтрана(Представление)
	
	Результат = Ложь;
	
	Если Не ЗначениеЗаполнено(Представление) Тогда
		Возврат Результат;
	КонецЕсли;
	
	Результат = УправлениеКонтактнойИнформацией.ДанныеСтраныМира(, Представление) <> Неопределено;
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура УдалитьСтрокуСписка(ИмяСписка, СтрокаСписка = Неопределено)
	
	Если СтрокаСписка = Неопределено Тогда
		СтрокаСписка = Элементы[ИмяСписка].ТекущиеДанные;
		Если СтрокаСписка = Неопределено Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	// Удаление текущей строки, если была отмена ввода адреса.
	ЭтотОбъект[ИмяСписка].Удалить(СтрокаСписка);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура СжатьАдресКонтактнойИнформации(ЗначенияПолей, Представление)
	
	БизнесСеть.ПолучитьРегионыКонтактнойИнформации(ЗначенияПолей, Представление);

КонецПроцедуры

&НаСервере
Процедура ЗаписатьДанныеАдресовРегионов()
	
	Регионы = РегионыПродажи.Выгрузить();
	Регионы.Свернуть("Представление, ЗначенияПолей");
	
	Адреса = АдресаПродажи.Выгрузить();
	Адреса.Свернуть("Представление, ЗначенияПолей");
	
	ДанныеРегионы = АдресаДляСохранения(Регионы);
	ДанныеАдреса = АдресаДляСохранения(Адреса);
	
	Если ИспользоватьХранилищеНастроек Тогда
		ЗаписатьДанныеВНастройки(ДанныеРегионы, ДанныеАдреса);
	Иначе
		ЗаписатьАдресаТорговогоПредложения(ДанныеРегионы, ДанныеАдреса);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьАдресаТорговогоПредложения(ДанныеРегионы, ДанныеАдреса)
	
	МодульТорговыеПредложенияСлужебный = ОбщегоНазначения.ОбщийМодуль("ТорговыеПредложенияСлужебный");
	
	МодульТорговыеПредложенияСлужебный.ЗаписатьДанныеРегионовВСостояниеСинхронизации(
		Организация, 
		ТорговоеПредложение,
		ДанныеРегионы, 
		ДанныеАдреса);
		
КонецПроцедуры

&НаСервере
Процедура ЗаписатьДанныеВНастройки(РегионыДоставки, РегионыСамовывоза)
	
	НастройкиРегионов = БизнесСеть.НастройкиАдресовИРегионовПоиска(КлючХраненияНастроек, Организация);
	
	НастройкиРегионов.ИспользоватьАдреса  = ИспользоватьАдреса;
	НастройкиРегионов.ИспользоватьРегионы = ИспользоватьРегионы;
	НастройкиРегионов.Регионы             = РегионыДоставки;
	НастройкиРегионов.Адреса              = РегионыСамовывоза;
	
	БизнесСеть.СохранитьНастройкиАдресовИРегионовПоиска(КлючХраненияНастроек, Организация, НастройкиРегионов);
	
КонецПроцедуры

&НаСервере
Функция АдресаДляСохранения(ДанныеАдресов)
	
	Результат = Новый Массив;
	
	Если Не ЗначениеЗаполнено(ДанныеАдресов) Тогда
		Возврат Результат;
	КонецЕсли;
	
	Для каждого СтрокаТаблицы Из ДанныеАдресов Цикл
		
		ЗаписьАдреса = БизнесСеть.ОписаниеЗаписиАдреса();
		
		СведенияОбАдресе = РаботаСАдресами.СведенияОбАдресе(СтрокаТаблицы.ЗначенияПолей, Новый Структура("КодыАдреса", Истина));
		
		ИдентификаторАдреса = ?(
			ЗначениеЗаполнено(СведенияОбАдресе.ИдентификаторДома),
			Строка(СведенияОбАдресе.ИдентификаторДома),
			Строка(СведенияОбАдресе.ИдентификаторАдресногоОбъекта));

		КодСтраны = СведенияОбАдресе.КодСтраны;	
			
		Если Не ЗначениеЗаполнено(КодСтраны) Тогда
			КодСтраны = КодСтраныПоПредставлению(СтрокаТаблицы.Представление);
		КонецЕсли;	
					
		ЗаписьАдреса.Представление = СтрокаТаблицы.Представление;
		ЗаписьАдреса.ЗначенияПолей = СтрокаТаблицы.ЗначенияПолей;
		ЗаписьАдреса.Идентификатор = ИдентификаторАдреса;
		ЗаписьАдреса.КодСтраны     = КодСтраны;
		
		Результат.Добавить(ЗаписьАдреса);
		
	КонецЦикла;	
	
	Возврат Результат;
	
КонецФункции

&НаСервереБезКонтекста
Функция КодСтраныПоПредставлению(Представление)
	
	Результат = "";
	
	Если Не ЗначениеЗаполнено(Представление) Тогда
		Возврат Результат;
	КонецЕсли;
	
	ДанныеСтраныМира = УправлениеКонтактнойИнформацией.ДанныеСтраныМира(, Представление);
	
	Если ДанныеСтраныМира = Неопределено Тогда
		Возврат Результат;
	КонецЕсли;
	
	Результат = ДанныеСтраныМира.Код;
	
	Возврат Результат;
	
КонецФункции


&НаКлиенте
Процедура ПриОтветеНаВопросОСохраненииИзмененныхДанных(РезультатВопроса, ДопПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		
		ЗаписатьДанныеИЗакрыть(Истина);
		
	ИначеЕсли РезультатВопроса = КодВозвратаДиалога.Нет Тогда
		
		Модифицированность = Ложь;
		Закрыть();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПеречитатьДанныеФормы()

	ОчиститьДанныеФормы();
	
	Если ИспользоватьХранилищеНастроек Тогда
		ЗаполнитьФормуПоДаннымХранилищаНастроек();
	Иначе
		ЗаполнитьФормуПоДаннымТорговогоПредложения();
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ОчиститьДанныеФормы()
	
	РегионыПродажи.Очистить();
	АдресаПродажи.Очистить();
	
	ИспользоватьРегионы = Ложь;
	ИспользоватьАдреса  = Ложь;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьФормуПоДаннымХранилищаНастроек()
	
	Настройки = БизнесСеть.НастройкиАдресовИРегионовПоиска(КлючХраненияНастроек, Организация);
	
	Для каждого ЭлементКоллекции Из Настройки.Регионы Цикл
		ЗаполнитьЗначенияСвойств(РегионыПродажи.Добавить(), ЭлементКоллекции);
	КонецЦикла;
	
	Для каждого ЭлементКоллекции Из Настройки.Адреса Цикл
		ЗаполнитьЗначенияСвойств(АдресаПродажи.Добавить(), ЭлементКоллекции);
	КонецЦикла;	
	
	ИспользоватьАдреса  = Настройки.ИспользоватьАдреса;
	ИспользоватьРегионы = Настройки.ИспользоватьРегионы;
	
	Если ТолькоРегионы Тогда
		ИспользоватьРегионы = Истина;
		ИспользоватьАдреса  = Ложь;
	КонецЕсли;	
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьФормуПоДаннымТорговогоПредложения()
	
	МодульТорговыеПредложенияСлужебный = ОбщегоНазначения.ОбщийМодуль("ТорговыеПредложенияСлужебный");
		
	ДанныеАдресовРегионов = МодульТорговыеПредложенияСлужебный.АдресаРегионыТорговогоПредложения(
		Организация, ТорговоеПредложение);
	
	Для каждого ЭлементКоллекции Из ДанныеАдресовРегионов.Регионы Цикл
		ЗаполнитьЗначенияСвойств(РегионыПродажи.Добавить(), ЭлементКоллекции);
	КонецЦикла;
	
	Для каждого ЭлементКоллекции Из ДанныеАдресовРегионов.Адреса Цикл
		ЗаполнитьЗначенияСвойств(АдресаПродажи.Добавить(), ЭлементКоллекции);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПодборРегионов(ИмяСписка)

	ПараметрыОткрытия = Новый Структура;
	
	Если СтрНайти("РегионыПродажи, РегионыЗакупки", ИмяСписка) Тогда
		ПараметрыОткрытия.Вставить("РежимВыбора", "Регионы");
	КонецЕсли;
	
	ПараметрыОткрытия.Вставить("Организация",         Организация);
	ПараметрыОткрытия.Вставить("АдресТаблицыАдресов", АдресХранилищДанныхСписка(ИмяСписка));
	
	ДополнительныеПараметры = Новый Структура("ИмяСписка", ИмяСписка);
	Оповещение = Новый ОписаниеОповещения("ОткрытьПодборРегионовЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	
	ОчиститьСообщения();
	
	ОткрытьФорму("Обработка.БизнесСеть.Форма.ПодборРегионов",
		ПараметрыОткрытия, ЭтотОбъект,,,, Оповещение);

КонецПроцедуры
	
&НаКлиенте
Процедура ОткрытьПодборРегионовЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если ТипЗнч(Результат) = Тип("Структура") И Результат.Свойство("АдресТаблицыАдресов") Тогда
		Модифицированность = Истина;
		ОбновитьДанныеНаСервере(Результат.АдресТаблицыАдресов, ДополнительныеПараметры.ИмяСписка);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьДанныеНаСервере(АдресТаблицыАдресов, ИмяСписка)
	
	// Необходимо обновить таблицу, с учетом существующих свойств.
	ТаблицаРезультата = ПолучитьИзВременногоХранилища(АдресТаблицыАдресов);
	Список = ЭтотОбъект[ИмяСписка]; // Регионы или Адреса.
	
	Для каждого СтрокаРезультата Из ТаблицаРезультата Цикл
		
		СтрокиСписка = Список.НайтиСтроки(Новый Структура("Представление", СтрокаРезультата.Представление));
		Если СтрокиСписка.Количество() = 0 И СтрокаРезультата.Пометка Тогда
			// Добавление новой строки
			НоваяСтрока = Список.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаРезультата);
		Иначе
			Если Не СтрокаРезультата.Пометка Тогда
				// Удаление не помеченной строки.
				Для каждого УдаляемаяСтрокаСписка Из СтрокиСписка Цикл
					Список.Удалить(УдаляемаяСтрокаСписка);
				КонецЦикла;
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура НастроитьЭлементыФормыПриСоздании()
	
	Элементы.ИспользоватьРегионы.Видимость = ИспользоватьХранилищеНастроек;
	Элементы.ИспользоватьАдреса.Видимость  = ИспользоватьХранилищеНастроек;
	
	Элементы.РегионыПродажи.Доступность = НЕ ИспользоватьХранилищеНастроек ИЛИ ИспользоватьРегионы;
	Элементы.АдресаПродажи.Доступность  = НЕ ИспользоватьХранилищеНастроек ИЛИ ИспользоватьАдреса;
	
	Если ЭтоПокупатель Тогда
		Элементы.ГруппаРегионыПродажи.Заголовок = НСтр("ru = 'Регионы закупок (для самовывоза)';
														|en = 'Purchase regions (for customer pickup)'");
		Элементы.ГруппаАдресаПродажи.Заголовок  = НСтр("ru = 'Адреса складов (для доставки)';
														|en = 'Warehouse addresses (for delivery)'");
		Элементы.ИспользоватьРегионы.Заголовок    = НСтр("ru = 'Возможен самовывоз';
														|en = 'Customer pickup is available'");
		Элементы.ИспользоватьАдреса.Заголовок     = НСтр("ru = 'Возможна доставка';
														|en = 'Delivery is possible'");
	КонецЕсли;
	
	Если ТолькоРегионы Тогда
		Элементы.ГруппаАдресаПродажи.Видимость = Ложь;
		Элементы.ИспользоватьРегионы.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПеречитатьПродолжение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ПеречитатьДанныеФормы();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
