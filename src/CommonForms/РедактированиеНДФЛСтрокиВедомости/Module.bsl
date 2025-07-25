#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПолучитьПараметры();
	ПолучитьНДФЛ();	
	ГоловнаяОрганизация = ЗарплатаКадры.ГоловнаяОрганизация(Организация);
	УстановитьУсловноеОформление();
	ВедомостьНаВыплатуЗарплатыФормыВнутренний.РедактированиеНДФЛСтрокиНастроитьЭлементы(ЭтотОбъект);
	УстановитьВидимостьКолонокПрогрессивногоНалога(ДатаВыплаты);
	Заголовок = СтрШаблон(НСтр("ru = '%1 : НДФЛ';
								|en = '%1 : PIT'"), Строка(ФизическоеЛицо));
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения("ВыбратьИЗакрыть", ЭтотОбъект);
	ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(Оповещение, Отказ, ЗавершениеРаботы);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыНДФЛ

&НаКлиенте
Процедура НДФЛПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока И Не Копирование Тогда
		ЗаполнитьЗначенияСвойств(Элемент.ТекущиеДанные, ЭтотОбъект);
		Элемент.ТекущиеДанные.МесяцНалоговогоПериода = ДатаВыплаты;
		Элемент.ТекущиеДанные.ДатаПолученияДохода = ДатаВыплаты;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НДФЛКатегорияДоходаПриИзменении(Элемент)
	ТекущиеДанные = Элементы.НДФЛ.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ТекущиеДанные.МесяцНалоговогоПериода < ДатаЗакона263ФЗ Тогда
		КатегорииСФиксированнойДатой = КатегорииСФиксированнойДатойДоЗакона263ФЗ
	Иначе
		КатегорииСФиксированнойДатой = КатегорииСФиксированнойДатойПослеЗакона263ФЗ
	КонецЕсли;
	БеретсяИзДатыВыплаты = КатегорииСФиксированнойДатой.Найти(ТекущиеДанные.КатегорияДохода) = Неопределено;
	ПерезаполнитьДаты = ТекущиеДанные.БеретсяИзДатыВыплаты <> БеретсяИзДатыВыплаты;
	ТекущиеДанные.БеретсяИзДатыВыплаты = БеретсяИзДатыВыплаты;
	Если ПерезаполнитьДаты Тогда
		Если БеретсяИзДатыВыплаты Тогда
			ТекущиеДанные.ДатаПолученияДохода = ДатаВыплаты;
		Иначе
			ТекущиеДанные.ДатаПолученияДохода = ТекущиеДанные.МесяцНалоговогоПериода;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура НДФЛРегистрацияВНалоговомОрганеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	НастройкиКомпоновки = Новый НастройкиКомпоновкиДанных;
	
	МассивОрганизаций = Новый Массив;
	МассивОрганизаций.Добавить(Организация);
	МассивОрганизаций.Добавить(ГоловнаяОрганизация);
		
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(НастройкиКомпоновки.Отбор,
		"Владелец", ВидСравненияКомпоновкиДанных.ВСписке, МассивОрганизаций);
	ПараметрыФормы = Новый Структура;
	
	ПараметрыФормы.Вставить("ФиксированныеНастройки", НастройкиКомпоновки);
	ПараметрыФормы.Вставить("РежимВыбора", Истина);
	ПараметрыФормы.Вставить("МножественныйВыбор", Ложь);
	
	Если ЗначениеЗаполнено(Элементы.НДФЛ.ТекущиеДанные.РегистрацияВНалоговомОргане) Тогда
		ПараметрыФормы.Вставить("ТекущаяСтрока", Элементы.НДФЛ.ТекущиеДанные.РегистрацияВНалоговомОргане);
	КонецЕсли;
	
	ДополнительныеПараметры = Новый Структура("Строка", Элементы.НДФЛ.ТекущиеДанные);
	ДополнительныеПараметры.Вставить("Элемент", Элемент);
	ОписаниеОповещения = Новый ОписаниеОповещения("НДФЛРегистрацияВНалоговомОрганеВыборЗавершение", 
		ЭтотОбъект,
		ДополнительныеПараметры);
	ОткрытьФорму("Справочник.РегистрацииВНалоговомОргане.ФормаВыбора", 
		ПараметрыФормы, 
		ЭтотОбъект, , , ,
		ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура НДФЛРегистрацияВНалоговомОрганеВыборЗавершение(ВыбранноеЗначение, ДополнительныеПараметры) Экспорт
	
	Если ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		ДополнительныеПараметры.Строка.РегистрацияВНалоговомОргане = ВыбранноеЗначение;
		Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	ВыбратьИЗакрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Модифицированность = Ложь;
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПолучитьПараметры()
	
	Параметры.Свойство("ИдентификаторСтроки",	ИдентификаторСтроки);
	
	Параметры.Свойство("ФизическоеЛицо",    ФизическоеЛицо);
	Параметры.Свойство("Организация",       Организация);
	Параметры.Свойство("Подразделение",     Подразделение);
	Параметры.Свойство("ПериодРегистрации", ПериодРегистрации);
	Параметры.Свойство("ДатаВыплаты",       ДатаВыплаты);
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьНДФЛ()

	НДФЛ.Загрузить(ПолучитьИзВременногоХранилища(Параметры.АдресВХранилищеНДФЛПоСтроке));
	
	ДатаЗакона263ФЗ = УчетНДФЛ.ДатаЗакона263ФЗ();
	КатегорииСФиксированнойДатойДоЗакона263ФЗ = Новый ФиксированныйМассив(Перечисления.КатегорииДоходовНДФЛ.СФиксированнойДатойПолученияДохода());
	КатегорииСФиксированнойДатойПослеЗакона263ФЗ = Новый ФиксированныйМассив(Перечисления.КатегорииДоходовНДФЛ.СФиксированнойДатойПолученияДохода(ДатаЗакона263ФЗ));
	
	Для Каждого СтрокаНДФЛ Из НДФЛ Цикл
		Если СтрокаНДФЛ.МесяцНалоговогоПериода < ДатаЗакона263ФЗ Тогда
			КатегорииСФиксированнойДатой = КатегорииСФиксированнойДатойДоЗакона263ФЗ
		Иначе
			КатегорииСФиксированнойДатой = КатегорииСФиксированнойДатойПослеЗакона263ФЗ
		КонецЕсли;
		Если КатегорииСФиксированнойДатой.Найти(СтрокаНДФЛ.КатегорияДохода) = Неопределено Тогда
			СтрокаНДФЛ.БеретсяИзДатыВыплаты = Истина;
			СтрокаНДФЛ.ДатаПолученияДохода = ДатаВыплаты;
		Иначе
			СтрокаНДФЛ.БеретсяИзДатыВыплаты = Ложь;
			СтрокаНДФЛ.ДатаПолученияДохода = СтрокаНДФЛ.МесяцНалоговогоПериода;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры
	
&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.НДФЛДатаПолученияДохода.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("НДФЛ.БеретсяИзДатыВыплаты");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветНедоступногоТекста);
	Элемент.Оформление.УстановитьЗначениеПараметра("Доступность", Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьИЗакрыть(Результат = Неопределено, ДополнительныеПараметры = Неопределено) Экспорт
	
	Если ПроверитьЗаполнение() Тогда
		
		РезультатыРедактирования = Новый Структура;
		РезультатыРедактирования.Вставить("Модифицированность", Модифицированность);
		РезультатыРедактирования.Вставить("ИдентификаторСтроки", ИдентификаторСтроки);
		РезультатыРедактирования.Вставить("АдресВХранилищеНДФЛПоСтроке", АдресВХранилищеНДФЛПоСтроке());
		
		Модифицированность = Ложь;
		Закрыть(РезультатыРедактирования)
		
	КонецЕсли
	
КонецПроцедуры

&НаСервере
Функция АдресВХранилищеНДФЛПоСтроке()
	
	НДФЛФизлица = НДФЛ.Выгрузить();
	Для Каждого СтрокаНДФЛ Из НДФЛФизлица Цикл
		СтрокаНДФЛ.ИдентификаторСтроки = ИдентификаторСтроки;
		СтрокаНДФЛ.ФизическоеЛицо      = ФизическоеЛицо;
		Если Не СтрокаНДФЛ.БеретсяИзДатыВыплаты Тогда
			 СтрокаНДФЛ.МесяцНалоговогоПериода = СтрокаНДФЛ.ДатаПолученияДохода;
		КонецЕсли;
	КонецЦикла;
	
	Возврат ПоместитьВоВременноеХранилище(НДФЛФизлица, УникальныйИдентификатор);
	
КонецФункции	

&НаСервере
Процедура УстановитьВидимостьКолонокПрогрессивногоНалога(ДатаПолученияДохода)
	
	ВидимостьКолонок = ДатаПолученияДохода >= УчетНДФЛ.ДатаЗакона176ФЗ();
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ГруппаКолонокНалогПоПрогрессивнымСтавкам",
																"Видимость", ВидимостьКолонок);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "НДФЛСуммаСПревышения",
																"Видимость", НЕ ВидимостьКолонок);
	
КонецПроцедуры

#КонецОбласти
